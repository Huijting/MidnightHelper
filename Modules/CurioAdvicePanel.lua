local _, ns = ...

--[[
	Midnight Helper — the advice panel that sits beside Valeera's own window.

	Rob asked for this in three parts, over weeks: an advice screen "zoals we in
	serienummer 1 hadden", saying "wat volgens de meerderheid online het beste is",
	and appearing "ernaast" when her window opens. The first two shipped on 2 sep as
	stars inside /mh curios. This is the third, and it is the one he could see was
	missing: he opened her window and got a chat line saying we had no ranking.

	⚠️ WHY THIS IS NOT THE EXISTING POPUP. `DelveCuriosAdvisor`'s popup is built on
	ITEM ids -- it resolves names with C_Item.GetItemInfo and draws item icons. That
	was right for Season 1, whose curios really were items. Season 2's are trait
	entries with spellIDs, measured 2 sep in Rob's own client, so that popup can
	never hold them: it would render "#1248877". It is not broken and it is not
	removed -- a 12.0.7 client still has real data for it -- but it cannot grow into
	this, so this is a separate, smaller frame that reads the tree.

	📌 WHAT IT DELIBERATELY DOES NOT DO. It does not repeat the effect text. Beside
	her window the player is choosing, not studying; three slots of full tooltips
	would be a wall. It answers the one question that belongs here -- what should I
	pick, and do I already have it -- and points at /mh curios for the rest.

	⚠️ AND IT NEVER INVENTS THE ANSWER. Every option, the slot names and the current
	pick come from GetCompanionChoices(), i.e. from the tree in front of the player.
	The only thing we supply is the star, which is checked against that same tree by
	the caller. A slot we have no recommendation for says so, rather than showing
	nothing and letting the blank read as approval of whatever is slotted.

	🔴 TWO THINGS ROB ASKED FOR THE MOMENT HE SAW IT BESIDE HER FRAME, 2 sep:

	  1. The same order as her window. The tree hands back 110784, 110785, 110786 --
	     Poisons, Utility, Combat -- while she reads Poisons, Combat, Utility. Two
	     lists of the same three things in different orders, side by side, and the
	     reader does the matching. Order now comes from DELVE_CURIO_SLOT_ORDER.
	  2. Readable and resizable. It shipped at a fixed 300px with the small font,
	     which is fine for a glance and not for reading. It is now drag-resizable
	     from the bottom-right, scrolls when the content is taller than the frame,
	     and remembers the size.
]]

local panel

local PAD = 14
local TITLE_H = 26
local SLOT_HEAD_H = 20
local LINE_H = 17
local SLOT_GAP = 10
local FOOT_H = 44
local MIN_W, MIN_H = 240, 160
local MAX_W, MAX_H = 620, 900
local DEF_W, DEF_H = 320, 300

local function L(key)
	return (ns.L and ns:L(key)) or key
end

--- Remembered size lives in the addon db; position deliberately does not (see Anchor).
local function SizeStore()
	ns.db = ns.db or {}
	ns.db.curioAdvicePanel = ns.db.curioAdvicePanel or {}
	return ns.db.curioAdvicePanel
end

--- Anchor beside Valeera's window when it is up, otherwise centre-right of screen.
--- ⚠️ Anchored to her frame, not to a remembered position: the point of this panel
--- is that it is NEXT TO the thing it talks about. If her window moves, we move.
local function Anchor(f)
	local host = DelvesCompanionConfigurationFrame
	f:ClearAllPoints()
	if host and host.IsShown and host:IsShown() then
		f:SetPoint("TOPLEFT", host, "TOPRIGHT", 4, 0)
		return
	end
	f:SetPoint("CENTER", UIParent, "CENTER", 260, 40)
end

local function EnsurePanel()
	if panel then
		return panel
	end

	local f = CreateFrame("Frame", "MidnightHelperCurioAdvicePanel", UIParent, "BackdropTemplate")
	local st = SizeStore()
	f:SetSize(tonumber(st.width) or DEF_W, tonumber(st.height) or DEF_H)
	f:SetFrameStrata("HIGH")
	f:SetFrameLevel(220)
	f:SetClampedToScreen(true)
	f:EnableMouse(true)
	f:SetResizable(true)
	if f.SetResizeBounds then
		-- 12.x name. SetMinResize/SetMaxResize were removed in 10.x, so calling them
		-- would error rather than silently do nothing.
		f:SetResizeBounds(MIN_W, MIN_H, MAX_W, MAX_H)
	end
	if f.SetBackdrop then
		f:SetBackdrop({
			bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
			edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Border",
			tile = true,
			tileSize = 32,
			edgeSize = 32,
			insets = { left = 11, right = 12, top = 12, bottom = 11 },
		})
		f:SetBackdropColor(0.06, 0.06, 0.1, 0.94)
	end
	tinsert(UISpecialFrames, f:GetName())

	local title = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	title:SetPoint("TOPLEFT", f, "TOPLEFT", PAD, -PAD)
	title:SetPoint("TOPRIGHT", f, "TOPRIGHT", -PAD - 16, -PAD)
	title:SetJustifyH("LEFT")
	title:SetTextColor(1, 0.9, 0.55)
	f._title = title

	local close = CreateFrame("Button", nil, f, "UIPanelCloseButton")
	close:SetPoint("TOPRIGHT", f, "TOPRIGHT", 2, 2)
	close:SetScript("OnClick", function()
		f:Hide()
	end)

	local foot = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	foot:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", PAD, 14)
	foot:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -PAD, 14)
	foot:SetJustifyH("LEFT")
	foot:SetWordWrap(true)
	foot:SetTextColor(0.7, 0.68, 0.63)
	f._foot = foot

	-- Scrolling middle. The rows live on `content`, which grows as tall as it needs;
	-- the scroll frame is whatever the player has dragged the window to.
	local scroll = CreateFrame("ScrollFrame", nil, f, "UIPanelScrollFrameTemplate")
	scroll:SetPoint("TOPLEFT", f, "TOPLEFT", PAD, -(PAD + TITLE_H))
	scroll:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -(PAD + 12), FOOT_H)
	f._scroll = scroll

	local content = CreateFrame("Frame", nil, scroll)
	content:SetSize(10, 10)
	scroll:SetScrollChild(content)
	f._content = content

	-- Drag the corner. A texture rather than a template so it matches the backdrop
	-- and cannot pick up a template's own OnMouseDown.
	local grip = CreateFrame("Button", nil, f)
	grip:SetSize(16, 16)
	grip:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -4, 4)
	grip:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
	grip:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
	grip:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")
	grip:SetScript("OnMouseDown", function()
		f:StartSizing("BOTTOMRIGHT")
	end)
	grip:SetScript("OnMouseUp", function()
		f:StopMovingOrSizing()
		local s = SizeStore()
		s.width, s.height = math.floor(f:GetWidth() + 0.5), math.floor(f:GetHeight() + 0.5)
		-- Re-anchor: StartSizing leaves the frame on its own points, and without this
		-- it stops following her window the first time you resize it.
		Anchor(f)
		ns.RefreshCurioAdvicePanel()
	end)
	f._grip = grip

	f._lines = {}
	panel = f
	return f
end

--- One reusable font string per row, grown on demand.
--- ⚠️ Parented to the scroll content, not the frame: a row on the frame would sit
--- still while the rest scrolled past it.
local function LineAt(f, index)
	local fs = f._lines[index]
	if not fs then
		fs = f._content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
		fs:SetJustifyH("LEFT")
		f._lines[index] = fs
	end
	fs:ClearAllPoints()
	fs:SetPoint("LEFT", f._content, "LEFT", 0, 0)
	fs:SetPoint("RIGHT", f._content, "RIGHT", 0, 0)
	return fs
end

--- Redraw from the tree. Returns false when there is nothing honest to show.
function ns.RefreshCurioAdvicePanel()
	if not panel or not panel:IsShown() then
		return false
	end
	local f = panel

	-- ⚠️ ONE call, both returns. Written first as an `and`/`or` chain, which yields a
	-- single value and silently drops the reason, and then asked the client a second
	-- time to get it back. That is lint check [12] in this repo.
	local nodes, why
	if ns.GetCompanionChoices then
		nodes, why = ns.GetCompanionChoices()
	end

	for _, fs in ipairs(f._lines) do
		fs:Hide()
	end

	f._title:SetText(L("CURIOPANEL_TITLE"))
	f._content:SetWidth(math.max(10, f._scroll:GetWidth()))

	local y = 0
	local n = 0

	if not nodes then
		n = n + 1
		local fs = LineAt(f, n)
		fs:SetPoint("TOP", f._content, "TOP", 0, y)
		fs:SetWordWrap(true)
		fs:SetTextColor(0.82, 0.8, 0.74)
		fs:SetText(L(why or "CURIO_NO_CHOICES"))
		fs:Show()
		f._foot:SetText("")
		f._content:SetHeight(60)
		return true
	end

	-- Her window's order, not the tree's. See DELVE_CURIO_SLOT_ORDER.
	if ns.SortDelveCurioSlots then
		nodes = ns.SortDelveCurioSlots(nodes)
	end

	local picks = ns.GetDelveCurioGuidePicks and ns.GetDelveCurioGuidePicks() or nil
	local anyNote = false

	for _, node in ipairs(nodes) do
		local labelKey = ns.GetDelveCurioSlotLabelKey
			and ns.GetDelveCurioSlotLabelKey(node.nodeID) or nil
		n = n + 1
		local head = LineAt(f, n)
		head:SetPoint("TOP", f._content, "TOP", 0, y)
		head:SetWordWrap(false)
		head:SetTextColor(1, 0.82, 0.2)
		head:SetText(labelKey and L(labelKey)
			or (L("CURIO_CHOICE_FMT")):format(#node.options))
		head:Show()
		y = y - SLOT_HEAD_H

		local recommended, active
		for _, o in ipairs(node.options) do
			if o.active then
				active = o
			end
			if picks and o.spellID and picks[o.spellID] then
				recommended = o
			end
		end

		n = n + 1
		local rec = LineAt(f, n)
		rec:SetPoint("TOP", f._content, "TOP", 0, y)
		rec:SetWordWrap(true)
		if recommended then
			rec:SetTextColor(0.55, 0.85, 1)
			rec:SetText((L("CURIOPANEL_REC_FMT")):format(recommended.name or "?"))
		else
			-- 🔴 Say it. A slot with no line under it reads as "whatever you have is
			-- fine", which is a recommendation we have not made.
			rec:SetTextColor(0.6, 0.58, 0.55)
			rec:SetText(L("CURIOPANEL_NO_REC"))
		end
		rec:Show()
		y = y - math.max(LINE_H, rec:GetStringHeight() + 2)

		-- Our own reading of what the player currently has, but only where there is no
		-- guide star to speak for the slot. Two opinions stacked on one line is how a
		-- reader stops being able to tell which is which.
		local noteKey
		if not recommended and active and ns.GetDelveCurioOurNote then
			noteKey = ns.GetDelveCurioOurNote(active.spellID)
		end
		if noteKey then
			anyNote = true
			n = n + 1
			local note = LineAt(f, n)
			note:SetPoint("TOP", f._content, "TOP", 0, y)
			note:SetWordWrap(true)
			note:SetTextColor(0.62, 0.78, 0.62)
			note:SetText(L("CURIO_NOTE_MARK") .. L(noteKey))
			note:Show()
			y = y - math.max(LINE_H, note:GetStringHeight() + 2)
		end

		n = n + 1
		local yours = LineAt(f, n)
		yours:SetPoint("TOP", f._content, "TOP", 0, y)
		yours:SetWordWrap(true)
		if not active then
			yours:SetTextColor(0.85, 0.7, 0.35)
			yours:SetText(L("CURIOPANEL_NO_PICK"))
		elseif recommended and active.spellID == recommended.spellID then
			yours:SetTextColor(0.45, 0.85, 0.45)
			yours:SetText(L("CURIOPANEL_YOURS_MATCH"))
		else
			yours:SetTextColor(0.85, 0.8, 0.6)
			yours:SetText((L("CURIOPANEL_YOURS_OTHER_FMT")):format(active.name or "?"))
		end
		yours:Show()
		y = y - math.max(LINE_H, yours:GetStringHeight() + 2) - SLOT_GAP
	end

	-- The foot carries whichever claims are actually on screen. A disclaimer for a
	-- mark nobody can see is noise, and worse, it trains the reader to skip the foot.
	local footText = L("CURIOPANEL_FOOT")
	if anyNote then
		footText = footText .. " " .. L("CURIO_NOTE_DISCLAIMER")
	end
	f._foot:SetText(footText)
	f._content:SetHeight(math.max(10, math.abs(y)))
	return true
end

--- 🔴 IT SAID "Nothing slotted yet" FOR ALL THREE SLOTS ON ROB'S FIRST LOOK, and on the
--- next reload it was right — with the active-detection code untouched. So the first
--- version was not wrong, it was EARLY: `activeEntry` is empty until the trait config
--- is loaded, and one retry at 1s was not always enough.
---
--- ⚠️ That is the worse kind of green. "It works now" after changing three unrelated
--- things is not a fix, it is a coincidence that has not failed yet — and an advice
--- panel that intermittently claims you have nothing equipped is worse than one that
--- says nothing, because the player believes it and re-picks.
---
--- So the panel stops depending on when it is opened: it refreshes on the event that
--- announces the config, and on her window appearing, as well as on a short ladder of
--- retries. Any one of those arriving is enough.
local eventFrame

local function EnsureEvents()
	if eventFrame then
		return
	end
	eventFrame = CreateFrame("Frame")
	eventFrame:RegisterEvent("TRAIT_CONFIG_UPDATED")
	eventFrame:RegisterEvent("TRAIT_TREE_CHANGED")
	eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
	eventFrame:SetScript("OnEvent", function()
		ns.RefreshCurioAdvicePanel()
	end)

	-- Her window carries the companion id the whole read depends on, so its OnShow is
	-- the earliest moment the answer can exist.
	local host = DelvesCompanionConfigurationFrame
	if host and host.HookScript then
		host:HookScript("OnShow", function()
			ns.RefreshCurioAdvicePanel()
		end)
	end
end

function ns.ShowCurioAdvicePanel()
	local f = EnsurePanel()
	EnsureEvents()
	Anchor(f)
	f:Show()
	-- ⚠️ Effect text is not shown here, but the NAMES still come from spell data, and
	-- a cold cache gives nothing. GetCompanionChoices requests as it walks.
	ns.RefreshCurioAdvicePanel()
	if C_Timer and C_Timer.After then
		-- A ladder rather than a single retry: 0.3s catches the common case without a
		-- visible flicker, 3s covers a slow load. Cheap, and it is the difference
		-- between "usually right" and "right".
		for _, delay in ipairs({ 0.3, 1, 3 }) do
			C_Timer.After(delay, function()
				ns.RefreshCurioAdvicePanel()
			end)
		end
	end
end

function ns.HideCurioAdvicePanel()
	if panel then
		panel:Hide()
	end
end

function ns.ToggleCurioAdvicePanel()
	if panel and panel:IsShown() then
		ns.HideCurioAdvicePanel()
		return false
	end
	ns.ShowCurioAdvicePanel()
	return true
end
