local _, ns = ...

--[[
	NewChoices.lua — "New in this version: your choice". One small window with a card per new thing a player can switch.

	Rob, 12 Nov 2026, via sparring, verbatim: "Ja, bouw het (Recommended)", with his three choices:
	  A "Keuzes in plaats van changelog (Recommended)" — when there is something to choose, only this window comes, with a
	    button "What else is new?" that opens the changelog. One window, not two (Changelog.lua asks NewChoicesTakeOver).
	  B "Iedereen (Recommended)" — new players too, the first time they have MH.
	  C "Niet tonen (Recommended)" — whoever already placed MH's key block does not see the key card.

	Rules:
	  - Closing without a choice changes nothing. Every button goes through the same function as the setting / command.
	  - The key card never places keys: "Show me" opens the existing key block window (/mh block), which shows the plan
	    first and can always be undone.
	  - Each card is shown automatically once (ns.db.newChoicesSeen[id], account-wide). A later version adds a card with a
	    new id: one line in CARDS, and only that card comes.
	  - Waits for the other login questions (direction, bar layout) and for the end of a fight.
	  - /mh new shows every card that applies, seen or not. /mh new check prints what it would show and why.
]]

local PREFIX = "|cffffcc00Midnight Helper:|r "
local GOOD = "|cff7fff7f"
local W = 440
local PAD = 16

-- Why the key card did or did not apply, the last time it was asked (for /mh new check).
local keyWhy = "not asked yet"

local function InCombat()
	return InCombatLockdown and InCombatLockdown()
end

--------------------------------------------------------------------------------
-- The cards. avail() = does this card apply to this player right now.
--------------------------------------------------------------------------------
--- An On/Off card for a screen MH can show (Rob, 13 Nov 2026, via sparring, verbatim: "Ja, raad alleen voor nieuwe
--- spelers en één keertje bij een volgende update. Zodat ook oude spelers weten wat voor fancies we allemaal hebben.
--- En ze moeten dan ook weten of te zien krijgen dat we meer bars hebben."). Texts are the setting's own (already in
--- every language); the switch is the setting's own setter, and the native setting follows.
local function ScreenCard(id, head, body, isOn, setOn, nativeKey, combatSafe)
	return {
		id = id,
		head = head,
		body = body,
		avail = function()
			return isOn() ~= nil
		end,
		buttons = function()
			local on = isOn() and true or false
			local function set(v)
				return function()
					if not combatSafe and InCombat() then
						print(PREFIX .. ns:L("FPARTY_NOT_IN_COMBAT"))
						return
					end
					setOn(v)
					if ns.SyncNativeSetting and nativeKey then
						ns.SyncNativeSetting(nativeKey, v)
					end
				end
			end
			return {
				{ text = ns:L("NEWC_ON"), current = on, click = set(true) },
				{ text = ns:L("NEWC_OFF"), current = not on, click = set(false) },
			}
		end,
	}
end

local CARDS = {
	-- Forever, per character (Rob, 13 Nov 2026, via sparring, verbatim: "Als kaartjes erin"): the two login questions
	-- are cards here now, so a new character gets ONE overview instead of three windows. The direction card picks the
	-- tree right on the card (hover a button for its sentence); the bar layout card's Yes is the question's own Yes.
	{
		id = "direction",
		perChar = true,
		head = "FDIR_ASK_TITLE",
		bodyFn = function()
			return ns.ForeverDirectionCardBody()
		end,
		avail = function()
			return ns.IS_FOREVER and ns.ForeverDirectionCardApplies ~= nil and ns.ForeverDirectionCardApplies()
		end,
		buttons = function()
			return ns.ForeverDirectionCardButtons()
		end,
	},
	{
		id = "barlayout",
		perChar = true,
		head = "NEWC_BAR_HEAD",
		body = "FBAR_ASK_TEXT",
		avail = function()
			if not (ns.IS_FOREVER and ns.ForeverBarLayoutDecision and ns.ForeverBarLayoutYes) then
				return false
			end
			local ok, yes = pcall(ns.ForeverBarLayoutDecision)
			return ok and yes and true or false
		end,
		buttons = function()
			return {
				{
					text = ns:L("FBAR_YES"),
					closes = true,
					click = function()
						-- Hides the choice window itself (before the click handler below), logs, sets the layout and
						-- asks for the reload.
						ns.ForeverBarLayoutYes(_G.MidnightHelperNewChoices, "card")
					end,
				},
			}
		end,
	},
	{
		id = "donow",
		again = "2", -- shown once more with the screens (13 Nov 2026)
		head = "SET_FOREVER_DONOW_TITLE",
		body = "NEWC_DONOW_BODY",
		avail = function()
			return ns.IS_FOREVER and ns.SetForeverDoNowMode ~= nil and ns.ForeverDoNowMode ~= nil
		end,
		buttons = function()
			local cur = ns.ForeverDoNowMode()
			local list = {}
			for _, m in ipairs({ "auto", "always", "off" }) do
				list[#list + 1] = {
					text = ns:L("FDONOW_MODE_" .. m:upper()),
					current = (cur == m),
					click = function()
						ns.SetForeverDoNowMode(m)
						if ns.SyncNativeSetting then
							ns.SyncNativeSetting("mh_foreverDoNowMode", ns.ForeverDoNowMode())
						end
						if m == "off" then
							print(PREFIX .. ns:L("FDONOW_OFF_HOW"))
						else
							print(PREFIX .. ns:L("FDONOW_MODE_CHAT_FMT"):format(ns:L("FDONOW_MODE_" .. m:upper())))
						end
					end,
				}
			end
			return list
		end,
	},
	{
		id = "partypanel",
		again = "2", -- shown once more with the screens (13 Nov 2026)
		head = "SET_FOREVER_PARTY_TITLE",
		body = "NEWC_PARTY_BODY",
		avail = function()
			return ns.IS_FOREVER and ns.SetForeverPartyPanel ~= nil and ns.IsForeverPartyPanelOn ~= nil
		end,
		buttons = function()
			local on = ns.IsForeverPartyPanelOn() and true or false
			local function set(v)
				return function()
					if InCombat() then
						print(PREFIX .. ns:L("FPARTY_NOT_IN_COMBAT"))
						return
					end
					ns.SetForeverPartyPanel(v)
					if ns.SyncNativeSetting then
						ns.SyncNativeSetting("mh_foreverPartyPanel", v)
					end
					print(PREFIX .. ns:L(v and "FPARTY_ON" or "FPARTY_OFF"))
				end
			end
			return {
				{ text = ns:L("NEWC_ON"), current = on, click = set(true) },
				{ text = ns:L("NEWC_OFF"), current = not on, click = set(false) },
			}
		end,
	},
	-- Midnight's own group panel (PartyTargets.lua). Rob's first sentence about this window, 12 Nov 2026: "Misschien ook
	-- een idee om dit met de party targets te doen, dan weten mensen gelijk dat we het hebben". Same on/off as
	-- /mh partytargets and the setting.
	{
		id = "partytargets",
		again = "2", -- shown once more with the screens (13 Nov 2026)
		head = "SET_PARTYTARGETS_TITLE",
		body = "NEWC_PT_BODY",
		avail = function()
			return not ns.IS_FOREVER and ns.SetPartyTargetsEnabled ~= nil and ns.IsPartyTargetsEnabled ~= nil
		end,
		buttons = function()
			local on = ns.IsPartyTargetsEnabled() and true or false
			local function set(v)
				return function()
					if InCombat() then
						print(PREFIX .. ns:L("FPARTY_NOT_IN_COMBAT"))
						return
					end
					ns.SetPartyTargetsEnabled(v)
					if ns.SyncNativeSetting then
						ns.SyncNativeSetting("mh_partyTargets", v)
					end
					print(PREFIX .. ns:L(v and "PARTYTARGETS_ON" or "PARTYTARGETS_OFF"))
				end
			end
			return {
				{ text = ns:L("NEWC_ON"), current = on, click = set(true) },
				{ text = ns:L("NEWC_OFF"), current = not on, click = set(false) },
			}
		end,
	},
	{
		id = "keyblock",
		-- "Seen" per character (Rob, 12 Nov 2026, via sparring: "Ja, per character"): every character without the block
		-- gets this card once. The other cards stay account-wide, like their settings.
		perChar = true,
		head = "NEWC_KEYS_HEAD",
		body = "NEWC_KEYS_BODY",
		-- Rob's choice C: not for whoever already placed the block on this character + spec.
		avail = function()
			if not (ns.ShowKeyBlock and ns.KeyBlockIsPlaced) then
				keyWhy = "no key block module"
				return false
			end
			local ok, placed = pcall(ns.KeyBlockIsPlaced)
			if not ok then
				keyWhy = "KeyBlockIsPlaced error: " .. tostring(placed)
				return false
			end
			if placed then
				keyWhy = "placed on this spec"
				return false
			end
			-- Placed on another spec of this character also counts: that player knows the block already. (And it keeps
			-- us quiet in the first seconds after login, when the spec may not be readable yet.)
			local guid = UnitGUID and UnitGUID("player")
			local snaps = ns.db and ns.db.keyBlockSnapshots
			if guid and type(snaps) == "table" then
				for k in pairs(snaps) do
					if type(k) == "string" and k:sub(1, #guid + 1) == guid .. ":" then
						keyWhy = "placed on another spec (" .. k:sub(#guid + 2) .. ")"
						return false
					end
				end
			end
			keyWhy = "not placed"
			return true
		end,
		buttons = function()
			return {
				{
					text = ns:L("NEWC_KEYS_BTN"),
					closes = true,
					click = function()
						ns.ShowKeyBlock()
					end,
				},
			}
		end,
	},
	-- The screens (13 Nov 2026, Rob's list: the quick bar with reload / leave group and the MH logo, and the marker bar
	-- "waar je alle iconen neer kan zetten op spelers"; plus the two other things MH puts on screen by itself). All four
	-- load in both games (both tocs). Account-wide, like their settings: new players see them, existing players once.
	ScreenCard("quickbar", "SETTINGS_QUICKBAR", "SETTINGS_QUICKBAR_TT", function()
		return ns.IsQuickBarShown and ns.IsQuickBarShown()
	end, function(v)
		ns.SetQuickBarShown(v)
	end, "mh_quickBar"),
	ScreenCard("fastmark", "SET_MARK_TOGGLE_TITLE", "SET_MARK_TOGGLE_DESC", function()
		return ns.IsFastMarkEnabled and ns.IsFastMarkEnabled()
	end, function(v)
		ns.SetFastMarkEnabled(v)
	end, "mh_fastMark"),
	ScreenCard("missingbuff", "SET_MBUFF_TOGGLE_TITLE", "SET_MBUFF_TOGGLE_DESC", function()
		return ns.IsMissingBuffEnabled and ns.IsMissingBuffEnabled()
	end, function(v)
		ns.SetMissingBuffEnabled(v)
	end, "mh_missingBuff"),
	ScreenCard("minimap", "SETTINGS_MINIMAP_ICON", "SETTINGS_MINIMAP_ICON_TT", function()
		return ns.IsMinimapIconShown and ns.IsMinimapIconShown()
	end, function(v)
		ns.SetMinimapIconShown(v)
	end, "mh_minimapIcon", true),
}

local function Seen()
	if not ns.db then
		return nil
	end
	ns.db.newChoicesSeen = ns.db.newChoicesSeen or {}
	local seen = ns.db.newChoicesSeen
	-- One-time repair (13 Nov 2026): before this fix, cards were marked "seen" the moment the window was told to show,
	-- even when nobody could see it, and an open window could be re-filled with only the unseen rest. Measured in
	-- Rob's SV (the only one: unreleased): the screens and the second round stood on "seen" without him ever seeing
	-- them, and the key card on a character where he did not take the bar layout. So: forget those once.
	if not ns.db.newChoicesFix1 then
		ns.db.newChoicesFix1 = true
		for _, k in ipairs({ "quickbar", "fastmark", "missingbuff", "minimap", "donow#2", "partypanel#2", "partytargets#2" }) do
			seen[k] = nil
		end
		-- The key card was meant to stay unseen next to the bar layout card; give it back where the bar layout card
		-- was shown (a character that did take the bar layout has its block placed, so the card does not apply there).
		local back = {}
		for k in pairs(seen) do
			local g = type(k) == "string" and k:match("^barlayout:(.+)$")
			if g then
				back[#back + 1] = "keyblock:" .. g
			end
		end
		for _, k in ipairs(back) do
			seen[k] = nil
		end
	end
	-- Second one-time repair (13 Nov 2026, late): MEASURED in Rob's SV, newChoicesShowLog — the screens were marked at
	-- 22:58:02 under the 1.5-s-visible rule, which Rob did not experience as seeing them. The rule is now "closed by the
	-- player"; give the screens one more round under it. Only Rob's account has these keys (nothing released yet).
	if not ns.db.newChoicesFix2 then
		ns.db.newChoicesFix2 = date and date("%Y-%m-%d %H:%M:%S") or true
		for _, k in ipairs({ "quickbar", "fastmark", "missingbuff", "minimap", "donow#2", "partypanel#2", "partytargets#2" }) do
			seen[k] = nil
		end
	end
	return seen
end

--- The key a card's "seen" is stored under: its id, plus the character's GUID for a per-character card. A card with
--- `again = "<n>"` is a new round of an older card (stored as "id#n"): everyone sees it once more, also whoever saw the
--- old round (13 Nov 2026: the group panel and "Do this now" come back once with the screens, for existing players).
local function SeenKey(c)
	local id = c.again and (c.id .. "#" .. c.again) or c.id
	if c.perChar then
		local g = UnitGUID and UnitGUID("player")
		return id .. ":" .. tostring(g or "?")
	end
	return id
end

--- The cards that apply; with onlyUnseen, only those not shown automatically before.
local function Pick(onlyUnseen)
	local seen = Seen() or {}
	local out = {}
	for _, c in ipairs(CARDS) do
		local ok, yes = pcall(c.avail)
		if ok and yes and not (onlyUnseen and seen[SeenKey(c)]) then
			out[#out + 1] = c
		end
	end
	-- One subject, one card (Rob, 13 Nov 2026, via sparring: "Ja, jouw advies"): when the bar layout card is there, the
	-- key card stays out. It is NOT marked seen (only shown cards are), so if the player does not take the bar layout,
	-- the key card comes the next time instead. "Reload now" after the bar layout's Yes marks it seen on purpose
	-- (ForeverLayoutCarry.lua), because the key block then opens by itself.
	local hasBar = false
	for _, c in ipairs(out) do
		if c.id == "barlayout" then
			hasBar = true
		end
	end
	if hasBar then
		for i = #out, 1, -1 do
			if out[i].id == "keyblock" then
				table.remove(out, i)
			end
		end
	end
	return out
end

--- Which title the window gets (Rob, 13 Nov 2026, via sparring: "Ja, jouw advies" — two titles). Rule: "New in this
--- version" only when a NEW FEATURE (an account-wide card) is in it AND this account has seen the window before;
--- otherwise "Welcome: set up Midnight Helper" (a new character, or someone who has MH for the first time). Decided once
--- per opening, before the cards are marked seen, so the title does not flip while the window is open.
local function OpenMode(cards)
	local seen = Seen() or {}
	local seenBefore = next(seen) ~= nil
	local hasFeature = false
	for _, c in ipairs(cards) do
		if not c.perChar then
			hasFeature = true
		end
	end
	return (hasFeature and seenBefore) and "update" or "welcome"
end

--------------------------------------------------------------------------------
-- The window
--------------------------------------------------------------------------------
local win
local cardFrames = {}
local Render

local function Btn(parent)
	local b = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
	b:SetHeight(22)
	return b
end

local function Build()
	if win then
		return win
	end
	local f = CreateFrame("Frame", "MidnightHelperNewChoices", UIParent, "BackdropTemplate")
	f:SetSize(W, 200)
	f:SetPoint("CENTER", 0, 60)
	f:SetFrameStrata("DIALOG")
	f:SetClampedToScreen(true)
	f:SetMovable(true)
	f:EnableMouse(true)
	f:RegisterForDrag("LeftButton")
	f:SetScript("OnDragStart", f.StartMoving)
	f:SetScript("OnDragStop", f.StopMovingOrSizing)
	f:SetBackdrop({
		bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
		edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Border",
		tile = true,
		tileSize = 32,
		edgeSize = 32,
		insets = { left = 11, right = 12, top = 12, bottom = 11 },
	})
	f:SetBackdropColor(1, 1, 1, 0.95)

	f.title = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	f.title:SetPoint("TOPLEFT", PAD + 4, -18)
	f.title:SetPoint("RIGHT", f, "RIGHT", -140, 0) -- replaced below by the dock button's left edge, once it exists
	f.title:SetJustifyH("LEFT")
	f.title:SetWordWrap(true)

	local x = CreateFrame("Button", nil, f, "UIPanelCloseButton")
	x:SetPoint("TOPRIGHT", -6, -6)

	f.intro = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	f.intro:SetPoint("TOPLEFT", PAD + 4, -44)
	f.intro:SetWidth(W - 2 * PAD - 8)
	f.intro:SetJustifyH("LEFT")
	f.intro:SetSpacing(2)

	-- The cards sit in a scroll area; it only scrolls when the window would not fit the screen (Layout).
	f.scroll = CreateFrame("ScrollFrame", "MidnightHelperNewChoicesScroll", f, "UIPanelScrollFrameTemplate")
	f.content = CreateFrame("Frame", nil, f.scroll)
	f.content:SetSize(W - 2 * PAD, 1)
	f.scroll:SetScrollChild(f.content)

	f.more = Btn(f)
	f.more:SetScript("OnClick", function()
		f:Hide()
		if ns.ShowChangelogWindow then
			ns:ShowChangelogWindow(true)
		end
	end)
	f.close = Btn(f)
	f.close:SetScript("OnClick", function()
		f:Hide()
	end)

	-- No click-through (13 Nov 2026): every button dead for the first 0.7 s on screen; closing starts the rest.
	if ns.GuardFreshClicks then
		ns.GuardFreshClicks(f, function(fr)
			local list = { fr.more, fr.close }
			for _, c in ipairs(cardFrames) do
				for _, b in ipairs(c.btns or {}) do
					list[#list + 1] = b
				end
			end
			return list
		end)
	end
	f:HookScript("OnHide", function()
		-- The f:Hide() a few lines down (while building) also fires this, before `win` is set: that is not a player
		-- closing anything. Rob's BugSack, 13 Nov 2026 (fcf82a7): "NewChoices.lua:785: attempt to index upvalue 'win'".
		if not win then
			return
		end
		if ns.LoginQuestionClosed then
			ns.LoginQuestionClosed()
		end
		-- "Seen" is decided here, when the player closes it (13 Nov 2026; see ShownLater).
		if ns._NewChoicesOnClosed then
			ns._NewChoicesOnClosed()
		end
	end)

	f:Hide()
	win = f
	tinsert(UISpecialFrames, "MidnightHelperNewChoices")
	if ns.RegisterMidnightDialogPopup then
		ns.RegisterMidnightDialogPopup(f)
	end
	-- The title stops where RegisterMidnightDialogPopup's "Dock to window" button starts (Rob's screenshot, 13 Nov 2026:
	-- the centred title ran under it, over "your choice"). Anchored to the button, so a longer label in another language
	-- or "Undock" moves the edge with it. A long title wraps; Render starts the intro below it.
	if f._mhDockBtn then
		f.title:ClearAllPoints()
		f.title:SetPoint("TOPLEFT", PAD + 4, -18)
		f.title:SetPoint("RIGHT", f._mhDockBtn, "LEFT", -8, 0)
	end
	return f
end

local function CardFrame(i)
	local c = cardFrames[i]
	if c then
		return c
	end
	c = CreateFrame("Frame", nil, win.content, "BackdropTemplate")
	c:SetBackdrop({
		bgFile = "Interface\\Buttons\\WHITE8X8",
		edgeFile = "Interface\\Buttons\\WHITE8X8",
		edgeSize = 1,
	})
	c:SetBackdropColor(0, 0, 0, 0.35)
	c:SetBackdropBorderColor(0.6, 0.5, 0.2, 0.6)
	c.head = c:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	c.head:SetPoint("TOPLEFT", 8, -8)
	c.head:SetJustifyH("LEFT")
	c.body = c:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	c.body:SetPoint("TOPLEFT", c.head, "BOTTOMLEFT", 0, -4)
	c.body:SetJustifyH("LEFT")
	c.body:SetSpacing(2)
	c.btns = {}
	c.lines = {} -- visible sentences beside buttons (stacked cards)
	cardFrames[i] = c
	return c
end

-- Window size of the last render, for /mh new check (13 Nov 2026: the direction card grew; the window first widens,
-- and only if that is not enough the cards scroll — Rob via sparring: "Ja, jouw advies").
local lastSize = "not shown yet"

local Layout -- (cards, width) → window height; defined below

Render = function(cards)
	local f = Build()
	-- Try the normal width first; if the window would be taller than ~92% of the screen, widen (texts wrap less).
	local scale = (f.GetScale and f:GetScale()) or 1
	local screenH = (UIParent and UIParent.GetHeight and UIParent:GetHeight() or 768) / (scale > 0 and scale or 1)
	local h, w
	local limit = screenH * 0.92
	for _, width in ipairs({ W, W + 120, W + 240 }) do
		w = width
		h = Layout(cards, width)
		if h <= limit then
			break
		end
	end
	local scrolled = false
	if h > limit then
		-- Still too high at the widest: the cards go in a scroll area (Rob, 13 Nov 2026, via sparring: "Ja, jouw
		-- advies" — drop the key card next to the bar layout card, AND a scroll bar).
		h = Layout(cards, w, limit)
		scrolled = true
	end
	lastSize = ("%d x %d, screen %d high (%s)"):format(w, math.floor(h), math.floor(screenH),
		scrolled and "scroll bar on" or "fits")
end

-- scrollLimit (optional): the window's maximum height; the cards then scroll inside it.
Layout = function(cards, Wt, scrollLimit)
	local f = win
	f:SetWidth(Wt)
	f.intro:SetWidth(Wt - 2 * PAD - 8)
	local welcome = (f.mode == "welcome")
	f.title:SetText(ns:L(welcome and "NEWC_WELCOME_TITLE" or "NEWC_TITLE"))
	f.intro:SetText(ns:L(welcome and "NEWC_WELCOME_INTRO" or "NEWC_INTRO"))
	local introTop = math.max(44, math.floor(18 + f.title:GetStringHeight() + 8))
	f.intro:ClearAllPoints()
	f.intro:SetPoint("TOPLEFT", PAD + 4, -introTop)
	local SCROLLBAR = 26
	local innerW = Wt - 2 * PAD - (scrollLimit and SCROLLBAR or 0)
	local cardsTop = introTop + f.intro:GetStringHeight() + 10
	-- Cards live in f.content, the scroll child; y counts from the top of that area.
	local y = 0
	for i, card in ipairs(cards) do
		local c = CardFrame(i)
		c:ClearAllPoints()
		c:SetPoint("TOPLEFT", f.content, "TOPLEFT", 0, -y)
		c:SetWidth(innerW)
		c.head:SetWidth(innerW - 16)
		c.body:SetWidth(innerW - 16)
		c.head:SetText(ns:L(card.head))
		local bodyText
		if card.bodyFn then
			local okB, t = pcall(card.bodyFn)
			bodyText = okB and t or ""
		else
			bodyText = ns:L(card.body)
		end
		c.body:SetText(bodyText)
		local list = card.buttons()
		for _, b in ipairs(c.btns) do
			b:Hide()
		end
		for _, l in ipairs(c.lines) do
			l:Hide()
		end
		-- Buttons as wide as their text (lint [28]), a new row when the next one does not fit.
		local top = 8 + c.head:GetStringHeight() + 4 + c.body:GetStringHeight() + 8
		local bx, rowsUsed = 8, 1
		-- 🔴 A button with a `line` gets its sentence VISIBLE beside it, one button per row (Rob, 13 Nov 2026, via
		-- sparring, verbatim: "Laat de uitleg zichtbaar bij elke knop" — the direction card's trees, like the bands of
		-- the old question). All buttons of such a card get the same width, so the sentences line up.
		local stacked, stackW, rowY = false, 0, top
		for _, spec in ipairs(list) do
			if spec.line then
				stacked = true
			end
		end
		for j, spec in ipairs(list) do
			local b = c.btns[j]
			if not b then
				b = Btn(c)
				c.btns[j] = b
			end
			b:SetText((spec.current and (GOOD .. "> |r") or "") .. spec.text)
			-- A button may carry one sentence of explanation (the direction card: what each tree is), on hover.
			b:SetScript("OnEnter", spec.tip and function(self)
				if GameTooltip then
					GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
					GameTooltip:SetText(spec.text, 1, 0.82, 0)
					GameTooltip:AddLine(spec.tip, 1, 1, 1, true)
					GameTooltip:Show()
				end
			end or nil)
			b:SetScript("OnLeave", spec.tip and function()
				if GameTooltip then
					GameTooltip:Hide()
				end
			end or nil)
			ns.FitButtonToText(b, 70, stacked and math.floor(innerW * 0.4) or (innerW - 16))
			if stacked then
				stackW = math.max(stackW, b:GetWidth())
			else
				if bx > 8 and bx + b:GetWidth() > innerW - 8 then
					bx = 8
					rowsUsed = rowsUsed + 1
				end
				b:ClearAllPoints()
				b:SetPoint("TOPLEFT", bx, -(top + (rowsUsed - 1) * 26))
				bx = bx + b:GetWidth() + 6
			end
			b:SetScript("OnClick", function()
				spec.click()
				-- A click proves this card was seen (the 1.5 s rule in ShownLater covers the rest).
				local seenT = Seen()
				if seenT then
					seenT[SeenKey(card)] = true
				end
				-- Rob, 13 Nov 2026, via sparring, verbatim: "Ja, dicht na kiezen" (he chose On and the window stayed).
				-- One card: close at once. More cards: close once every card got a choice in this opening (sparring's
				-- advice; Rob decided only the one-card case).
				f.chosen = f.chosen or {}
				f.chosen[card.id] = true
				local allChosen = true
				for _, other in ipairs(f.cards or {}) do
					if not f.chosen[other.id] then
						allChosen = false
					end
				end
				if spec.closes or allChosen then
					f:Hide()
				elseif f:IsShown() then
					Render(f.cards)
				end
			end)
			b:Show()
		end
		local h
		if stacked then
			-- Second pass: same width for every button, the sentence to its right, each row as high as its sentence.
			for j, spec in ipairs(list) do
				local b = c.btns[j]
				b:SetWidth(stackW)
				b:ClearAllPoints()
				b:SetPoint("TOPLEFT", 8, -rowY)
				local l = c.lines[j]
				if not l then
					l = c:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
					l:SetJustifyH("LEFT")
					l:SetSpacing(2)
					c.lines[j] = l
				end
				l:SetWidth(innerW - 16 - stackW - 8)
				l:ClearAllPoints()
				l:SetPoint("TOPLEFT", 8 + stackW + 8, -(rowY + 3))
				l:SetText(spec.line or "")
				l:Show()
				rowY = rowY + math.max(22, l:GetStringHeight() + 6) + 6
			end
			h = rowY + 2
		else
			h = top + rowsUsed * 26 + 4
		end
		c:SetHeight(h)
		c:Show()
		y = y + h + 8
	end
	for i = #cards + 1, #cardFrames do
		cardFrames[i]:Hide()
	end
	f.cards = cards
	f.more:SetText(ns:L("NEWC_MORE"))
	ns.FitButtonToText(f.more, 100, innerW / 2)
	f.close:SetText(ns:L("CHANGELOG_CLOSE"))
	ns.FitButtonToText(f.close, 90, innerW / 2)
	f.more:ClearAllPoints()
	f.more:SetPoint("BOTTOMLEFT", PAD, 16)
	f.close:ClearAllPoints()
	f.close:SetPoint("BOTTOMRIGHT", -PAD, 16)
	local contentH = math.max(1, y - 8)
	local footer = 8 + 4 + 22 + 16
	local scrollH = contentH
	if scrollLimit and cardsTop + contentH + footer > scrollLimit then
		scrollH = math.max(120, scrollLimit - cardsTop - footer)
	end
	f.content:SetSize(innerW, contentH)
	f.scroll:ClearAllPoints()
	f.scroll:SetPoint("TOPLEFT", f, "TOPLEFT", PAD, -cardsTop)
	f.scroll:SetSize(innerW, scrollH)
	local bar = f.scroll.ScrollBar or _G["MidnightHelperNewChoicesScrollScrollBar"]
	if bar and bar.SetShown then
		bar:SetShown(scrollH < contentH)
	end
	if scrollH >= contentH and f.scroll.SetVerticalScroll then
		f.scroll:SetVerticalScroll(0)
	end
	local total = cardsTop + scrollH + footer
	f:SetHeight(total)
	return total
end

local function MarkSeen(cards)
	local seen = Seen()
	if not seen then
		return
	end
	for _, c in ipairs(cards) do
		seen[SeenKey(c)] = true
	end
end

-- 🔴 "SEEN" ONLY WHEN THE PLAYER DEALT WITH IT (13 Nov 2026). First rule (4fef65f): visible for 1.5 s. MEASURED in
-- Rob's SV the same night: an opening at 22:58:02 with all 7 screen cards, visible 1.5 s, so "seen" — and Rob says he
-- never saw it (AFGELEID: he was logging out / switching characters). Visible is not seen. Now a card counts as seen
-- only when the player CLOSES the window himself (Close, X, Esc — after it was visible at least SEEN_AFTER) or clicks
-- one of its buttons. Logging out or /reload with the window open does not hide it through OnHide, so those cards
-- come again next login. Every automatic opening goes in ns.db.newChoicesShowLog (max 10); /mh new check prints them.
local SEEN_AFTER = 1
local lastShow -- the log entry of the current/last automatic opening

local function ShownLater(cards, how)
	local ids = {}
	for _, c in ipairs(cards) do
		ids[#ids + 1] = SeenKey(c)
	end
	local entry = {
		at = date and date("%Y-%m-%d %H:%M:%S") or "?",
		char = UnitGUID and UnitGUID("player") or "?",
		how = how,
		mode = win and win.mode,
		cards = table.concat(ids, ","),
		count = #cards,
		marked = false,
	}
	lastShow = entry
	if ns.db then
		ns.db.newChoicesShowLog = ns.db.newChoicesShowLog or {}
		local L = ns.db.newChoicesShowLog
		L[#L + 1] = entry
		while #L > 10 do
			table.remove(L, 1)
		end
	end
	-- The OnHide hook in Build reads these: the cards of this opening, its log line, and since when it was visible.
	win._mhShowCards = cards
	win._mhShowEntry = entry
	win._mhVisibleSince = nil
	local token = {}
	win._mhShowToken = token
	local function watch(n)
		if win._mhShowToken ~= token or not win:IsShown() then
			return
		end
		if win:IsVisible() then
			win._mhVisibleSince = win._mhVisibleSince or (GetTime and GetTime() or 0)
		elseif n < 600 and C_Timer and C_Timer.After then
			-- Shown but hidden with the whole UI (a movie): look again until it is really visible.
			C_Timer.After(0.5, function()
				watch(n + 1)
			end)
		end
	end
	watch(0)
end

--- The window closed. Mark this opening's cards seen only if it was visible long enough to be read (Build hooks this).
local function OnWindowClosed()
	if not win then
		return
	end
	local entry, cards, since = win._mhShowEntry, win._mhShowCards, win._mhVisibleSince
	win._mhShowEntry, win._mhShowCards, win._mhShowToken = nil, nil, nil
	if not (entry and cards) then
		return
	end
	local now = GetTime and GetTime() or 0
	local secs = since and (now - since) or 0
	entry.closedAfter = math.floor(secs * 10 + 0.5) / 10
	if since and secs >= SEEN_AFTER then
		MarkSeen(cards)
		entry.marked = true
	end
end
ns._NewChoicesOnClosed = function()
	OnWindowClosed()
end

--------------------------------------------------------------------------------
-- Automatic: after the other login questions, never in a fight.
--------------------------------------------------------------------------------
-- The changelog too: since 13 Nov 2026 a card can turn up after it opened (late check below), and Rob's choice A is one
-- window, not two at once.
-- And the key block window: after "Yes" on the bar layout question it opens by itself after the reload (13 Nov 2026).
local OTHER_QUESTIONS = { "MidnightHelperForeverDirection", "MidnightHelperForeverBarLayout", "MidnightHelperForeverMyLayout",
	"MidnightHelperChangelogFrame", "MidnightHelperKeyBlock" }
local lastWhy = "not checked yet"

local function OtherQuestionOpen()
	-- Forever: also while a login question is still to COME (Rob, 13 Nov 2026: "Eén voor één"); between the direction
	-- question closing and the bar layout question opening there is a moment where neither frame is shown.
	if ns.ForeverDirectionPending and ns.ForeverDirectionPending() then
		return "the direction question (still to come or open)"
	end
	if ns.ForeverBarLayoutPending and ns.ForeverBarLayoutPending() then
		return "the bar layout question (open, or reload asked)"
	end
	-- Edit Mode still loading: wait, or the bar layout card would be missing from the one overview (13 Nov 2026).
	if ns.ForeverBarLayoutNotReady and ns.ForeverBarLayoutNotReady() then
		return "Edit Mode still loading (bar layout card)"
	end
	-- ~1.5 s rest after the previous question closed: no click-through (13 Nov 2026).
	if ns.LoginQuestionRestLeft and ns.LoginQuestionRestLeft() > 0 then
		return "rest after the previous question"
	end
	-- An intro movie, or the UI hidden (Alt+Z): the window would be "shown" where nobody can see it.
	if InCinematic and InCinematic() then
		return "intro movie"
	end
	if UIParent and UIParent.IsVisible and not UIParent:IsVisible() then
		return "the game UI is hidden"
	end
	for _, n in ipairs(OTHER_QUESTIONS) do
		local fr = _G[n]
		if fr and fr.IsShown and fr:IsShown() then
			return n
		end
	end
	return nil
end

local tries = 0
local changelogAfter = false -- set by NewChoicesTakeOver when it took over before knowing there would be a card
local function TryAutoShow()
	local cards = Pick(true)
	if #cards == 0 then
		-- Edit Mode not loaded yet: the bar layout card may still come; keep waiting rather than give up.
		if ns.ForeverBarLayoutNotReady and ns.ForeverBarLayoutNotReady() and tries < 300 and C_Timer and C_Timer.After then
			tries = tries + 1
			lastWhy = "waiting: Edit Mode still loading (nothing else to choose yet)"
			C_Timer.After(2, TryAutoShow)
			return
		end
		lastWhy = "nothing new to choose"
		if changelogAfter then
			-- We took over at login without knowing yet; nothing came, so the changelog gets its turn after all.
			changelogAfter = false
			if ns.ShowChangelogWindow then
				ns:ShowChangelogWindow(false)
			end
		end
		return
	end
	changelogAfter = false
	local busy = OtherQuestionOpen()
	if InCombat() or busy then
		tries = tries + 1
		lastWhy = InCombat() and "waiting: in combat" or ("waiting: " .. busy .. " is open")
		-- Questions wait as long as the player needs; give up after ~10 minutes and try again next login.
		if tries < 300 and C_Timer and C_Timer.After then
			C_Timer.After(2, TryAutoShow)
		end
		return
	end
	-- 🔴 NEVER REPLACE AN OPEN WINDOW (13 Nov 2026, Rob's 11-13.png: a 2-card Welcome window while 6 other cards
	-- already stood on "seen"). An automatic attempt that finds the window open stops; it does not re-render it with
	-- whatever is still unseen.
	if win and win:IsShown() then
		lastWhy = "window already open"
		return
	end
	Build().chosen = {}
	win.mode = OpenMode(cards)
	Render(cards)
	win:Show()
	ShownLater(cards, "auto")
	lastWhy = ("shown with %d card(s)"):format(#cards)
end

--- Changelog.lua asks this at login (Rob's choice A): true = there is something to choose, this window comes instead.
--- 13 Nov 2026, Rob (new Midnight character, level 10): "pas kwam toen ik /MH new deed. En niet vanaf het begin". The
--- only check was AT PLAYER_ENTERING_WORLD; nothing new then = never again that session, while /mh new later showed the
--- key card. MEASURED in his SV: newChoicesSeen holds only "partytargets", no "keyblock:<guid>" for any character, so
--- the key card was never once picked at login. Not measured why it did not apply that early (the spec or the bars may
--- not be readable yet, see avail). So: when nothing applies at login, look again a few seconds later.
local LATE_CHECKS = { 6, 20 }
local lateDone = false
local function LateCheck(n)
	if lateDone then
		return
	end
	local ok, cards = pcall(Pick, true)
	if ok and #cards > 0 then
		lateDone = true
		lastWhy = ("late check %d: %d card(s)"):format(n, #cards)
		TryAutoShow()
	elseif n == #LATE_CHECKS then
		lastWhy = "nothing new to choose (also not on the late checks; key card: " .. keyWhy .. ")"
	end
end

function ns.NewChoicesTakeOver()
	local ok, cards = pcall(Pick, true)
	-- Forever with Edit Mode still loading: the bar layout card may yet apply. Take over now (one window, the overview
	-- first: Rob, 13 Nov 2026); if in the end nothing applies, TryAutoShow hands over to the changelog after all.
	if ok and #cards == 0 and ns.ForeverBarLayoutNotReady and ns.ForeverBarLayoutNotReady() and C_Timer and C_Timer.After then
		changelogAfter = true
		lastWhy = "nothing yet at login; waiting for Edit Mode (bar layout card)"
		C_Timer.After(3, TryAutoShow)
		return true
	end
	if not ok or #cards == 0 then
		lastWhy = "nothing at login (key card: " .. keyWhy .. "); late checks pending"
		if C_Timer and C_Timer.After then
			for n, sec in ipairs(LATE_CHECKS) do
				C_Timer.After(sec, function()
					LateCheck(n)
				end)
			end
		end
		return false
	end
	if C_Timer and C_Timer.After then
		-- A moment after the world appears, so the direction question (if any) is already up and we can wait for it.
		C_Timer.After(3, TryAutoShow)
	else
		TryAutoShow()
	end
	return true
end

--- Mark one card as seen on this character/account without showing it (ForeverLayoutCarry.lua: "Reload now" opens the
--- key block itself, so the key card has nothing left to offer there).
function ns.NewChoicesMarkSeen(id)
	local seen = Seen()
	if not seen then
		return
	end
	for _, c in ipairs(CARDS) do
		if c.id == id then
			seen[SeenKey(c)] = true
		end
	end
end

--- How many cards apply now (seen or not): the changelog's "Choices" button shows only when this is above 0.
function ns.NewChoicesCount()
	local ok, cards = pcall(Pick, false)
	return ok and #cards or 0
end

--- /mh new · /mh new check
function ns.NewChoicesSlash(arg)
	arg = (arg or ""):lower()
	if arg == "check" or arg == "why" then
		local all, fresh = Pick(false), Pick(true)
		print(PREFIX .. ("new choices: %d apply, %d not seen yet; last login: %s"):format(#all, #fresh, lastWhy))
		print(("  key card now: %s"):format(keyWhy))
		print(("  window size last shown: %s"):format(lastSize))
		print(("  one-time repairs: 1 %s, 2 %s"):format(ns.db and ns.db.newChoicesFix1 and "done" or "not run",
			ns.db and ns.db.newChoicesFix2 and ("done (" .. tostring(ns.db.newChoicesFix2) .. ")") or "not run"))
		local log = ns.db and ns.db.newChoicesShowLog
		if type(log) == "table" and #log > 0 then
			-- The last three automatic openings, newest last: when, where, which cards, and whether they count as seen.
			for i = math.max(1, #log - 2), #log do
				local ls = log[i]
				print(("  opening %s on %s: %d card(s): %s; closed after %ss; counted as seen: %s"):format(
					tostring(ls.at), tostring(ls.char), tonumber(ls.count) or 0, tostring(ls.cards),
					tostring(ls.closedAfter or "-"), ls.marked and "yes" or "no"))
			end
		else
			print("  automatic openings: none logged yet")
		end
		local seen = Seen() or {}
		for _, c in ipairs(CARDS) do
			local ok, yes = pcall(c.avail)
			print(("  %s: %s, %s"):format(c.id, (ok and yes) and "applies" or (ok and "does not apply" or "error"),
				seen[SeenKey(c)] and "seen" or "not seen") .. (c.perChar and " (per character)" or ""))
		end
		return
	end
	local cards = Pick(false)
	if #cards == 0 then
		print(PREFIX .. ns:L("NEWC_NONE"))
		return
	end
	Build().chosen = {}
	win.mode = OpenMode(cards)
	Render(cards)
	win:Show()
end
