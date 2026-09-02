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
]]

local panel

local PAD = 14
local TITLE_H = 24
local SLOT_HEAD_H = 18
local LINE_H = 15
local SLOT_GAP = 10
local FOOT_H = 30
local WIDTH = 300

local function L(key)
	return (ns.L and ns:L(key)) or key
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
	f:SetSize(WIDTH, 200)
	f:SetFrameStrata("HIGH")
	f:SetFrameLevel(220)
	f:SetClampedToScreen(true)
	f:EnableMouse(false)
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
	foot:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", PAD, 12)
	foot:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -PAD, 12)
	foot:SetJustifyH("LEFT")
	foot:SetWordWrap(true)
	foot:SetTextColor(0.7, 0.68, 0.63)
	f._foot = foot

	f._lines = {}
	panel = f
	return f
end

--- One reusable font string per row, grown on demand.
local function LineAt(f, index)
	local fs = f._lines[index]
	if not fs then
		fs = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
		fs:SetPoint("LEFT", f, "LEFT", PAD, 0)
		fs:SetPoint("RIGHT", f, "RIGHT", -PAD, 0)
		fs:SetJustifyH("LEFT")
		fs:SetWordWrap(false)
		f._lines[index] = fs
	end
	return fs
end

--- Redraw from the tree. Returns false when there is nothing honest to show.
function ns.RefreshCurioAdvicePanel()
	if not panel or not panel:IsShown() then
		return false
	end
	local f = panel
	-- ⚠️ ONE call, both returns. Written first as
	--     local nodes, why = ns.GetCompanionChoices and ns.GetCompanionChoices() or nil, nil
	-- which silently drops the second return (an `and`/`or` chain yields one value) and
	-- then asked the client a second time to get it back. That is lint check [12] in this
	-- repo, and it caught nothing here only because it was caught while typing.
	local nodes, why
	if ns.GetCompanionChoices then
		nodes, why = ns.GetCompanionChoices()
	end

	for _, fs in ipairs(f._lines) do
		fs:Hide()
	end

	f._title:SetText(L("CURIOPANEL_TITLE"))

	local y = -(PAD + TITLE_H)
	local n = 0

	if not nodes then
		n = n + 1
		local fs = LineAt(f, n)
		fs:SetPoint("TOP", f, "TOP", 0, y)
		fs:SetWordWrap(true)
		fs:SetTextColor(0.82, 0.8, 0.74)
		fs:SetText(L(why or "CURIO_NO_CHOICES"))
		fs:Show()
		f._foot:SetText("")
		f:SetHeight(PAD + TITLE_H + 44 + FOOT_H)
		return true
	end

	local picks = ns.GetDelveCurioGuidePicks and ns.GetDelveCurioGuidePicks() or nil

	for _, node in ipairs(nodes) do
		-- Slot heading, named where we know the name (measured off her window).
		local labelKey = ns.GetDelveCurioSlotLabelKey
			and ns.GetDelveCurioSlotLabelKey(node.nodeID) or nil
		n = n + 1
		local head = LineAt(f, n)
		head:SetPoint("TOP", f, "TOP", 0, y)
		head:SetWordWrap(false)
		head:SetTextColor(1, 0.82, 0.2)
		head:SetText(labelKey and L(labelKey)
			or (L("CURIO_CHOICE_FMT")):format(#node.options))
		head:Show()
		y = y - SLOT_HEAD_H

		-- What the guides pick, and what the player actually has. Both read from the
		-- same list, so they can never disagree about which options exist.
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
		rec:SetPoint("TOP", f, "TOP", 0, y)
		rec:SetWordWrap(false)
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
		y = y - LINE_H

		n = n + 1
		local yours = LineAt(f, n)
		yours:SetPoint("TOP", f, "TOP", 0, y)
		yours:SetWordWrap(false)
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
		y = y - LINE_H - SLOT_GAP
	end

	f._foot:SetText(L("CURIOPANEL_FOOT"))
	f:SetHeight(math.abs(y) + FOOT_H + 8)
	return true
end

function ns.ShowCurioAdvicePanel()
	local f = EnsurePanel()
	Anchor(f)
	f:Show()
	-- ⚠️ Effect text is not shown here, but the NAMES still come from spell data, and
	-- a cold cache gives nothing. GetCompanionChoices requests as it walks; one retry
	-- covers the round-trip without making the panel feel late. Same lesson as
	-- CurioExplain, which needed four -- this needs fewer because it prints names, not
	-- descriptions, and names come back sooner.
	ns.RefreshCurioAdvicePanel()
	if C_Timer and C_Timer.After then
		C_Timer.After(1, function()
			ns.RefreshCurioAdvicePanel()
		end)
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
