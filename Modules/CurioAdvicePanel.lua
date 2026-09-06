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
--- 🔴 MEASURE THE FOOT, DO NOT RESERVE A NUMBER FOR IT — 6 Sep 2026, and it is the third
--- time this exact fault has shipped.
---
--- Yberamos, our first bug report from Discord, sent a screenshot through `/mh report`: the
--- foot text of this panel drawn straight through the last slot's lines. `FOOT_H = 44` is a
--- constant, and the scroll frame's bottom edge was pinned to it — but the foot's LENGTH is
--- decided at draw time. When any slot carries a `>>` note the foot gains
--- `CURIO_NOTE_DISCLAIMER`, roughly 250 characters together, which at this width wraps to six
--- or seven lines. Everything past 44 pixels grows up into the scrolling area.
---
--- 📌 Yberamos named the mechanism himself, which is why this was ten minutes rather than an
--- afternoon: *"the text ... is anchored to the bottom of the screen and the text 'you have:
--- ...' ignores it. Therefore, if the window is too short, they overlap."*
---
--- 📌 SAME FAULT, THIRD PANEL. Professions → Overview drew two paragraphs over each other for
--- exactly this reason (fixed 30 Aug, shipped in 3.7.3), and the changelog window reserved
--- 100px for a footer it had never measured (`2d37151`). The pattern is a fixed height
--- standing in for text nobody has laid out yet, and it stays invisible until a longer
--- sentence — or a longer language — arrives.
---
--- ⚠️ DECLARED HERE, above the frame builder, because the resize handler in it calls this.
--- Written first as a `local function` further down, where the handler's reference resolved
--- to a nil global — caught by lint check [6] rather than by Rob.
--- @param f table the panel frame
local FitFoot

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
	--- ⚠️ RE-MEASURE WHILE DRAGGING, not only on release — Rob, 6 Sep 2026, testing the fix
	--- that had just landed: *"wanneer ik de panel resize rechts onderin dan overlapt het
	--- inderdaad"*. The grip's OnMouseUp re-runs the whole layout, so letting go corrects it;
	--- but a narrower window rewraps the foot on every frame of the drag, and until you
	--- release it is drawn through the text above. `FitFoot` alone is cheap — one
	--- GetStringHeight and one SetPoint — so it can run live where a full redraw could not.
	f:SetScript("OnSizeChanged", function(self)
		FitFoot(self)
	end)

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

function FitFoot(f)
	if not (f and f._foot and f._scroll) then
		return
	end
	--- 🔴 A CAP ON THE RESERVED SPACE IS NOT A CAP ON THE TEXT — corrected 6 Sep 2026, after
	--- Rob dragged the panel to its smallest and the overlap came straight back.
	---
	--- The first version of this reserved at most half the frame and the comment claimed the
	--- foot would "get clipped instead". **A FontString does not clip itself.** Anchored to
	--- the bottom with word wrap, it simply keeps growing upward past whatever the scroll
	--- frame was given — so capping the reservation moved the overlap rather than removing
	--- it. At MIN_H the foot wants ~107px and the cap allowed 60; the other 47 landed on the
	--- slot text, which is exactly the screenshot Rob sent.
	---
	--- ⚠️ So the LINE COUNT is what gets bounded, with `SetMaxLines`, and the reservation is
	--- bounded to match. Then both the drawing and the space are finite and they agree.
	--- Guarded because a missing `SetMaxLines` must not error; without it we fall back to
	--- reserving what the foot asks for, which is the pre-cap behaviour — worse layout in a
	--- tiny window, never an overlap.
	local avail = (f:GetHeight() or DEF_H) - PAD - TITLE_H
	local budget = math.max(FOOT_H, avail * 0.5)
	local clipped = false
	if f._foot.SetMaxLines then
		local lh = (f._foot.GetLineHeight and f._foot:GetLineHeight()) or 0
		if lh > 0 then
			f._foot:SetMaxLines(math.max(1, math.floor((budget - 22) / lh)))
			clipped = true
		end
	end

	local h = f._foot:GetStringHeight() or 0
	if h <= 0 then
		-- Empty foot (the "nothing to show" branch): give the scroll the space back
		-- rather than leaving a 44px hole under a one-line message.
		f._scroll:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -(PAD + 12), PAD)
		f._fit = { frameH = f:GetHeight(), h = 0, want = PAD, budget = budget, empty = true }
		return
	end
	-- 14 is the foot's own bottom offset; the rest is breathing room between the last
	-- scrolled line and the first wrapped foot line.
	local want = math.max(FOOT_H, h + 22)
	if clipped then
		want = math.min(want, budget)
	end
	f._scroll:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -(PAD + 12), want)

	--- 🔎 KEEP THE NUMBERS. Rob, 6 Sep, third screenshot: at a mid-size window the foot still
	--- draws over the slot text, while the SCROLL side is clearly right (the slot line is cut
	--- off exactly where it should be). So the reservation is smaller than what the foot
	--- actually paints, and from a screenshot the two cannot be told apart. `/mh curios fit`
	--- prints them; this is the same move as `/mh travelwhy` yesterday, made after the second
	--- wrong explanation rather than the fourth.
	f._fit = {
		frameH = f:GetHeight(), avail = avail, budget = budget,
		lineH = (f._foot.GetLineHeight and f._foot:GetLineHeight()) or nil,
		maxLines = clipped and math.max(1, math.floor((budget - 22) / ((f._foot.GetLineHeight and f._foot:GetLineHeight()) or 12))) or nil,
		h = h, want = want, clipped = clipped,
	}

	--- ⚠️ AND MEASURE ONCE MORE NEXT FRAME. A `GetStringHeight` taken inside OnSizeChanged
	--- can still be using the width the FontString had BEFORE the resize, which would make
	--- `h` too small and is the leading candidate for the screenshot above. Re-running is
	--- idempotent, so this cannot make a correct layout wrong -- guarded against recursing
	--- forever.
	if not f._fitAgain and C_Timer and C_Timer.After then
		f._fitAgain = true
		C_Timer.After(0, function()
			f._fitAgain = nil
			if f:IsShown() then
				FitFoot(f)
			end
		end)
	end
end

--- `/mh curios fit` — what did the foot measurement actually decide?
---
--- 🔴 Built 6 Sep 2026 after two fixes that each looked right and each left an overlap at a
--- size Rob then found. A screenshot shows THAT the foot overflows; it cannot show whether
--- the reservation was too small or the paint too tall, and those need opposite fixes.
function ns.PrintCurioFit()
	local f = panel
	if not f then
		print("|cffffcc00Midnight Helper|r curio fit: panel not built yet — open it first.")
		return
	end
	local d = f._fit
	if not d then
		print("|cffffcc00Midnight Helper|r curio fit: no measurement yet — open the panel once.")
		return
	end
	print(("|cffffcc00Midnight Helper|r curio fit — venster %s hoog, scrollruimte %s"):format(
		tostring(math.floor((d.frameH or 0) + 0.5)), tostring(math.floor((d.avail or 0) + 0.5))))
	print(("   voet vraagt: %s px   gereserveerd: %s px   plafond: %s px"):format(
		tostring(math.floor((d.h or 0) + 0.5)), tostring(math.floor((d.want or 0) + 0.5)),
		tostring(math.floor((d.budget or 0) + 0.5))))
	print(("   regelhoogte: %s   max regels: %s   begrensd: %s"):format(
		tostring(d.lineH or "?"), tostring(d.maxLines or "-"),
		d.clipped and "|cff44ff44ja|r" or "|cffff8844nee — SetMaxLines ontbreekt|r"))
	print("   |cff8a8f98Overlapt het terwijl 'gereserveerd' groter is dan wat je ziet, dan meet|r")
	print("   |cff8a8f98de voet zichzelf te laag. Is 'gereserveerd' juist klein: dan het plafond.|r")
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
		FitFoot(f)
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
	FitFoot(f)
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
