local _, ns = ...

--[[
	Midnight Helper — a short advice card beside the Corrosive Codex window.

	Rob, 19 Oct 2026, standing in the Labyrinth with the Codex open: "kunnen wij hier ook een simpel
	advies aan plakken? net zoals we bij valeera hebben?" — the sister of CurioAdvicePanel.lua.

	MEASURED that evening on Rob's live client (/run into MidnightHelperDB.codexChoice + /reload):
	  • The window is Blizzard's PlayerChoiceFrame, choiceID 1076, questionText "Corrosive Codex".
	  • ONE option (id 6145) carrying TWELVE buttons, ids 13..24, always in the same order.
	    (22 Oct the same twelve came back as ids 49..60, same order: ReadCodex counts places, not ids.)
	  • A gift you have is marked by the atlas "common-icon-checkmark" at the start of the button's
	    text — `selected` and `showCheckmark` were both false on Rob's two picks, so neither is the
	    flag. The atlas name is language-independent, the button text around it is not.
	  • Each button carries the client's own tooltip, in the player's language.

	📌 WHAT IT DOES. It answers "what should I pick, and do I already have it" in a few lines,
	the same job the curio panel does. Gift NAMES come from the window itself, so they are right
	in every language without a translation of ours; only the situation labels are our text.
	It does not repeat the tooltips: the player is hovering them already.

	⚠️ IT NEVER CLICKS. Choosing a gift is the player's action; this card only reads.
	Rob, 22 Oct 2026, asked for a button that picks our advice. mh-research (side-session note
	codex_autopick_2026-10-22.md): an addon MAY send the pick, but a gift that is still locked costs
	8 Corrosive Souls at once, with no popup, and we cannot yet tell locked from unlocked. Rob chose
	option A: click a situation on this card and ITS GIFTS LIGHT UP in Blizzard's window; the player
	clicks. A gold frame on top of Blizzard's button that takes no mouse, so the click is untouched.
]]

local CODEX_CHOICE_ID = 1076
local CHECK_ATLAS = "common%-icon%-checkmark"

--- Button id (measured) -> English name, used only when the live window gives no text.
local GIFT_NAMES = {
	[13] = "Ophidian Maw", [14] = "Viperine Grasp", [15] = "Mephitic Cloud", [16] = "Gorgoneion Gaze",
	[17] = "Lithic Plumage", [18] = "Ouroboric Cycle", [19] = "Insidious Venom", [20] = "Virulent Mucus",
	[21] = "Accursed Poison", [22] = "Plague of Corrosion", [23] = "Miasma Geyser", [24] = "Ula'tek's Gift",
}

--- The advice. Each row: a situation (our text) and the gifts for it, as button ids.
--- `pair = true` means "these two together"; otherwise the gifts are alternatives.
--- Two independent research rounds, 19 Oct 2026, agreed on every row (counts and URLs in
--- docs/CODEX_GIFTS_2026-10-19.md): Ula'tek's Gift first in 8 of 9 guides; Ula'tek + Insidious
--- for bosses and Kindo'jan (Method 10 Oct and the pages that copy it); Plague + Maw for trash
--- (5 sources); Mucus + Gaze for survival (4 current + 2 older).
ns.CODEX_GIFT_ADVICE = {
	{ key = "CODEXADV_ROW_DAMAGE", gifts = { 24 } },
	{ key = "CODEXADV_ROW_BOSS", gifts = { 24, 19 }, pair = true },
	{ key = "CODEXADV_ROW_PACKS", gifts = { 22, 13 }, pair = true },
	{ key = "CODEXADV_ROW_SURVIVE", gifts = { 20, 16 }, pair = true },
	{ key = "CODEXADV_ROW_CASTERS", gifts = { 21 } },
}

--- Insidious Venom (19) poisons YOU. Of the twelve, only Ula'tek's Gift (24) and Ouroboric Cycle
--- (18) say "while you are Poisoned" — the others count Poisoned ENEMIES. MEASURED in the client's
--- own tooltips (Rob's dump, 19 Oct); two guides say the same. So Insidious next to anything else
--- adds nothing, and its 12 s of lower secondary stats only costs you.
local SELF_POISON = 19
local SELF_POISON_PAYOFF = { [24] = true, [18] = true }

local panel
local lastWhy = "never opened"
local lastChoiceID

local PAD = 14
local WIDTH = 300
local LINE_GAP = 3

local function L(key)
	return (ns.L and ns:L(key)) or key
end

local function DB()
	ns.db = ns.db or {}
	ns.db.codexAdvice = ns.db.codexAdvice or {}
	return ns.db.codexAdvice
end

function ns.IsCodexAdviceEnabled()
	return DB().off ~= true
end

function ns.SetCodexAdviceEnabled(on)
	DB().off = (not on) and true or nil
	if not on and panel then
		panel:Hide()
	end
end

--- Read the open Codex. Returns names[id], have[id], or nil + why.
local function ReadCodex()
	if not (C_PlayerChoice and C_PlayerChoice.GetCurrentPlayerChoiceInfo) then
		return nil, nil, "no C_PlayerChoice"
	end
	local info = C_PlayerChoice.GetCurrentPlayerChoiceInfo()
	if not info then
		return nil, nil, "no choice open"
	end
	lastChoiceID = info.choiceID
	if info.choiceID ~= CODEX_CHOICE_ID then
		return nil, nil, "another choice window (" .. tostring(info.choiceID) .. ")"
	end
	-- 🔴 Rob's run 19 Oct (videos A + D): the card said "no gift picked yet" for a whole minute while Blizzard's
	-- window showed two ticks, so the atlas in the text is not always there when we read. Three signals now, any
	-- one is enough: the atlas, `selected`/`showCheckmark`, and the shape Rob's dump had with both slots full
	-- (exactly the picks enabled, the other ten disabled). `/mh gifts` stores the raw fields to check which held.
	-- 🔴 GEMETEN 22 Oct 2026 (Rob's /mh gifts dump): the button ids are now 49..60, not the 13..24 of 19 Oct, while
	-- the order and the checkmark atlas stayed the same. Blizzard renumbers; the order is what holds. So a button is
	-- known by its PLACE (1st = 13 … 12th = 24, the ids the advice below is written in), never by b.id.
	local names, have = {}, {}
	local enabled, total = {}, 0
	for _, opt in ipairs(info.options or {}) do
		for _, b in ipairs(opt.buttons or {}) do
			local id, text = b.id and (13 + total) or nil, b.text
			if id then
				total = total + 1
				if b.disabled == false then
					enabled[#enabled + 1] = id
				end
				if b.selected == true or b.showCheckmark == true then
					have[id] = true
				end
			end
			if id and type(text) == "string" then
				if text:find(CHECK_ATLAS) then
					have[id] = true
				end
				local clean = text:gsub("|A.-|a", ""):gsub("|T.-|t", ""):gsub("^%s+", ""):gsub("%s+$", "")
				if clean ~= "" then
					names[id] = clean
				end
			end
		end
	end
	if not next(have) and total >= 10 and (#enabled == 1 or #enabled == 2) then
		for _, id in ipairs(enabled) do
			have[id] = true
		end
	end
	return names, have, nil, info
end

--------------------------------------------------------------------------------
-- Lighting up Blizzard's gift buttons (option A, 22 Oct 2026)
--------------------------------------------------------------------------------

--- Which advice row is lit (index into ns.CODEX_GIFT_ADVICE), remembered per account. nil = none.
local function LitRow()
	local r = tonumber(DB().litRow)
	return (r and ns.CODEX_GIFT_ADVICE[r]) and r or nil
end

local glows = {}
local lastGlowWhy = "nothing lit"

--- Blizzard's gift buttons by place (13..24), found by walking PlayerChoiceFrame for frames that carry the
--- `buttonID` their OnClick sends (Blizzard_PlayerChoice, read by mh-research 22 Oct 2026) and matching that id to
--- the place it has in the choice info. Not by frame names or a fixed path: those are Blizzard's to change.
--- @return table|nil byPlace, string why
local function FindGiftButtons(info)
	local host = _G.PlayerChoiceFrame
	if not (host and host:IsShown()) then
		return nil, "Codex window not shown"
	end
	local placeOf, n = {}, 0
	for _, opt in ipairs(info and info.options or {}) do
		for _, b in ipairs(opt.buttons or {}) do
			if b.id then
				placeOf[b.id] = 13 + n
				n = n + 1
			end
		end
	end
	local byPlace, found = {}, 0
	local function walk(frame, depth)
		if depth > 8 or not frame.GetChildren then
			return
		end
		for _, child in ipairs({ frame:GetChildren() }) do
			local id = rawget(child, "buttonID")
			if type(id) == "number" and placeOf[id] and child:IsShown() then
				if not byPlace[placeOf[id]] then
					found = found + 1
				end
				byPlace[placeOf[id]] = child
			end
			walk(child, depth + 1)
		end
	end
	walk(host, 1)
	if found ~= 12 then
		return nil, ("found %d of 12 gift buttons"):format(found)
	end
	return byPlace, "12 buttons found"
end

local function Glow(i)
	local g = glows[i]
	if not g then
		g = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
		g:EnableMouse(false) -- the click must reach Blizzard's button untouched
		if g.SetBackdrop then
			g:SetBackdrop({ edgeFile = "Interface\\Buttons\\WHITE8x8", edgeSize = 3 })
			g:SetBackdropBorderColor(1, 0.82, 0.1, 1)
		end
		local pulse = g:CreateAnimationGroup()
		pulse:SetLooping("BOUNCE")
		local a = pulse:CreateAnimation("Alpha")
		a:SetFromAlpha(1)
		a:SetToAlpha(0.35)
		a:SetDuration(0.7)
		g._pulse = pulse
		glows[i] = g
	end
	return g
end

local function HideGlows()
	for _, g in ipairs(glows) do
		g:Hide()
		g._pulse:Stop()
	end
end

--- Light the lit row's gifts that you do not have yet. A gift you have is already ticked, and clicking it would
--- switch it OFF — so it never gets a glow that says "click me".
local function UpdateGlows(info, have)
	local r = LitRow()
	if not r then
		HideGlows()
		lastGlowWhy = "nothing lit"
		return
	end
	local byPlace, why = FindGiftButtons(info)
	lastGlowWhy = why
	if not byPlace then
		HideGlows()
		return
	end
	-- Called twice a second while the card is up: keep a running pulse going instead of restarting it.
	local n = 0
	for _, id in ipairs(ns.CODEX_GIFT_ADVICE[r].gifts) do
		local btn = byPlace[id]
		if btn and not have[id] then
			n = n + 1
			local g = Glow(n)
			g:ClearAllPoints()
			g:SetPoint("TOPLEFT", btn, "TOPLEFT", -4, 4)
			g:SetPoint("BOTTOMRIGHT", btn, "BOTTOMRIGHT", 4, -4)
			g:SetFrameStrata(btn:GetFrameStrata())
			g:SetFrameLevel(btn:GetFrameLevel() + 10)
			g:Show()
			if not g._pulse:IsPlaying() then
				g._pulse:Play()
			end
		end
	end
	for i = n + 1, #glows do
		glows[i]:Hide()
		glows[i]._pulse:Stop()
	end
	lastGlowWhy = why .. (", %d lit"):format(n)
end

local function Anchor(f)
	local host = _G.PlayerChoiceFrame
	f:ClearAllPoints()
	if host and host.IsShown and host:IsShown() then
		f:SetPoint("TOPLEFT", host, "TOPRIGHT", 4, 0)
	else
		f:SetPoint("CENTER", UIParent, "CENTER", 300, 40)
	end
end

local function EnsurePanel()
	if panel then
		return panel
	end
	local f = CreateFrame("Frame", "MidnightHelperCodexAdvicePanel", UIParent, "BackdropTemplate")
	f:SetSize(WIDTH, 200)
	f:SetFrameStrata("HIGH")
	f:SetFrameLevel(220)
	f:SetClampedToScreen(true)
	f:EnableMouse(true)
	-- Solid, not the dialog texture: that one is see-through, and on 21 Oct 2026 the Party Targets panel's
	-- "— no target —" read straight through this card (Rob's screenshot), mixed into the gift lines.
	if f.SetBackdrop then
		f:SetBackdrop({
			bgFile = "Interface\\Buttons\\WHITE8x8",
			edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Border",
			tile = true,
			tileSize = 32,
			edgeSize = 32,
			insets = { left = 11, right = 12, top = 12, bottom = 11 },
		})
		f:SetBackdropColor(0.06, 0.06, 0.1, 1)
	end
	tinsert(UISpecialFrames, f:GetName())

	local close = CreateFrame("Button", nil, f, "UIPanelCloseButton")
	close:SetPoint("TOPRIGHT", f, "TOPRIGHT", 2, 2)
	close:SetScript("OnClick", function()
		f:Hide()
	end)
	-- Whatever closes the card takes its glows along; they belong to it.
	f:SetScript("OnHide", HideGlows)

	-- 🔴 Rob's run, 19 Oct 10:28:32 (video D): the card said "no gift picked yet" while Blizzard's window showed two
	-- checkmarks. The card only redrew on PLAYER_CHOICE_UPDATE + one retry, so a pick made with the window open could
	-- go unseen. While it is up it now re-reads the window twice a second — one table read, nothing else.
	local acc = 0
	f:SetScript("OnUpdate", function(_, dt)
		acc = acc + (dt or 0)
		if acc >= 0.5 then
			acc = 0
			ns.RefreshCodexAdvicePanel()
		end
	end)

	f._lines = {}
	panel = f
	return f
end

local function LineAt(f, i, template)
	local fs = f._lines[i]
	if not fs then
		fs = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
		if ns.MHScalableFont then
			fs:SetFontObject(ns.MHScalableFont("GameFontHighlight"))
		end
		fs:SetJustifyH("LEFT")
		fs:SetWordWrap(true)
		f._lines[i] = fs
	end
	if template and ns.MHScalableFont then
		fs:SetFontObject(ns.MHScalableFont(template))
	end
	fs:ClearAllPoints()
	return fs
end

local function GiftText(id, names, have)
	local name = names[id] or GIFT_NAMES[id] or ("#" .. tostring(id))
	if have[id] then
		return "|cff66dd66" .. name .. " |A:common-icon-checkmark:14:14:0:0|a|r"
	end
	return "|cffffffff" .. name .. "|r"
end

function ns.RefreshCodexAdvicePanel()
	if not (panel and panel:IsShown()) then
		return false
	end
	local f = panel
	local names, have, why, info = ReadCodex()
	if not names then
		lastWhy = why
		f:Hide()
		return false
	end

	for _, fs in ipairs(f._lines) do
		fs:Hide()
	end
	f._rowBtns = f._rowBtns or {}
	for _, b in ipairs(f._rowBtns) do
		b:Hide()
	end
	local y = -PAD
	local n = 0
	local function Add(text, r, g, b, template, extraGap)
		n = n + 1
		local fs = LineAt(f, n, template)
		fs:SetPoint("TOPLEFT", f, "TOPLEFT", PAD, y)
		fs:SetPoint("RIGHT", f, "RIGHT", -PAD - (n == 1 and 18 or 0), 0)
		fs:SetTextColor(r, g, b)
		fs:SetText(text)
		fs:Show()
		y = y - (fs:GetStringHeight() or 14) - LINE_GAP - (extraGap or 0)
	end

	Add(L("CODEXADV_TITLE"), 1, 0.9, 0.55, "GameFontNormal", 4)

	local mine = {}
	for id = 13, 24 do
		if have[id] then
			mine[#mine + 1] = "|cff66dd66" .. (names[id] or GIFT_NAMES[id]) .. "|r"
		end
	end
	if #mine > 0 then
		Add(L("CODEXADV_YOURS") .. " " .. table.concat(mine, " + "), 0.85, 0.82, 0.7, nil, 6)
	else
		Add(L("CODEXADV_YOURS_NONE"), 0.85, 0.7, 0.35, nil, 6)
	end

	-- Each situation is a button: click = light its gifts in Blizzard's window, click again = off (option A).
	Add(L("CODEXADV_LIGHT_HINT"), 0.55, 0.78, 1, "GameFontHighlightSmall", 4)
	local lit = LitRow()
	for i, row in ipairs(ns.CODEX_GIFT_ADVICE) do
		local top = y
		Add(L(row.key), 1, 0.82, 0.2)
		local parts = {}
		for _, id in ipairs(row.gifts) do
			parts[#parts + 1] = GiftText(id, names, have)
		end
		local joiner = row.pair and " + " or (" " .. L("CODEXADV_OR") .. " ")
		Add("   " .. table.concat(parts, joiner), 1, 1, 1, nil, 4)
		local b = f._rowBtns[i]
		if not b then
			b = CreateFrame("Button", nil, f)
			b.bg = b:CreateTexture(nil, "BACKGROUND")
			b.bg:SetAllPoints()
			b.bg:SetColorTexture(1, 0.82, 0.1, 0.18)
			b:SetHighlightTexture("Interface\\Buttons\\UI-Listbox-Highlight2", "ADD")
			f._rowBtns[i] = b
		end
		b:ClearAllPoints()
		b:SetPoint("TOPLEFT", f, "TOPLEFT", PAD - 4, top + 2)
		b:SetPoint("RIGHT", f, "RIGHT", -PAD + 4, 0)
		b:SetHeight(top - y)
		b.bg:SetShown(lit == i)
		b:SetScript("OnClick", function()
			DB().litRow = (LitRow() ~= i) and i or nil
			ns.RefreshCodexAdvicePanel()
		end)
		b:Show()
	end
	if lit then
		Add(L("CODEXADV_LIT_HINT"), 0.55, 0.78, 1, "GameFontHighlightSmall", 4)
	end
	UpdateGlows(info, have)

	-- The one thing worth saying about the player's OWN pair: Insidious Venom with a gift it cannot help.
	if have[SELF_POISON] and #mine >= 2 then
		local helped = false
		for id in pairs(SELF_POISON_PAYOFF) do
			if have[id] then
				helped = true
			end
		end
		if not helped then
			Add((L("CODEXADV_WARN_SELFPOISON")):format(names[SELF_POISON] or GIFT_NAMES[SELF_POISON],
				names[24] or GIFT_NAMES[24], names[18] or GIFT_NAMES[18]), 1, 0.55, 0.4, nil, 4)
		end
	end

	Add(L("CODEXADV_FOOT"), 0.7, 0.68, 0.63, "GameFontHighlightSmall")

	f:SetHeight(math.abs(y) + PAD)
	lastWhy = "shown"
	return true
end

function ns.ShowCodexAdvicePanel()
	local f = EnsurePanel()
	Anchor(f)
	f:Show()
	if not ns.RefreshCodexAdvicePanel() then
		return false
	end
	-- The button texts can arrive a moment after the window; a short second look costs nothing.
	if C_Timer and C_Timer.After then
		C_Timer.After(0.3, function()
			if panel and panel:IsShown() then
				ns.RefreshCodexAdvicePanel()
			end
		end)
	end
	return true
end

function ns.HideCodexAdvicePanel()
	if panel then
		panel:Hide()
	end
end

--- `/mh gifts` — what the card decided and why. Its normal state outside the Codex is "nothing".
function ns.PrintCodexAdviceStatus()
	local p = "|cffffcc00Midnight Helper|r gifts:"
	print(("%s enabled=%s  shown=%s  last=%s  lastChoiceID=%s"):format(p,
		tostring(ns.IsCodexAdviceEnabled()), tostring(panel and panel:IsShown() or false),
		tostring(lastWhy), tostring(lastChoiceID)))
	print(("   lit row=%s  glow: %s"):format(tostring(LitRow()), tostring(lastGlowWhy)))
	local names, have, why, info = ReadCodex()
	if not names then
		print("   " .. tostring(why))
		return
	end
	for id = 13, 24 do
		print(("   %d  %s%s"):format(id, tostring(names[id]), have[id] and "  |cff66dd66(have)|r" or ""))
	end
	-- The raw button fields, for the SavedVariables file after a /reload: which signal said "have"?
	local dump = { at = date and date("%Y-%m-%d %H:%M:%S") or "?", buttons = {} }
	for _, opt in ipairs(info and info.options or {}) do
		for _, b in ipairs(opt.buttons or {}) do
			dump.buttons[#dump.buttons + 1] = {
				id = b.id, text = b.text, disabled = b.disabled, selected = b.selected, showCheckmark = b.showCheckmark,
			}
		end
	end
	DB().lastDump = dump
	print("   |cff8a8f98Raw fields saved; /reload writes them to the SavedVariables file.|r")
end

local events = CreateFrame("Frame")
for _, ev in ipairs({ "PLAYER_CHOICE_UPDATE", "PLAYER_CHOICE_CLOSE" }) do
	pcall(events.RegisterEvent, events, ev)
end
events:SetScript("OnEvent", function(_, event)
	if event == "PLAYER_CHOICE_CLOSE" then
		ns.HideCodexAdvicePanel()
		return
	end
	if not ns.IsCodexAdviceEnabled() then
		lastWhy = "switched off"
		return
	end
	local names, _, why = ReadCodex()
	if names then
		ns.ShowCodexAdvicePanel()
	else
		lastWhy = why
		ns.HideCodexAdvicePanel()
	end
end)
