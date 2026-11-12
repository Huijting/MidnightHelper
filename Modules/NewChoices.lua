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

local function InCombat()
	return InCombatLockdown and InCombatLockdown()
end

--------------------------------------------------------------------------------
-- The cards. avail() = does this card apply to this player right now.
--------------------------------------------------------------------------------
local CARDS = {
	{
		id = "donow",
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
	{
		id = "keyblock",
		head = "NEWC_KEYS_HEAD",
		body = "NEWC_KEYS_BODY",
		-- Rob's choice C: not for whoever already placed the block on this character + spec.
		avail = function()
			if not (ns.ShowKeyBlock and ns.KeyBlockIsPlaced) then
				return false
			end
			local ok, placed = pcall(ns.KeyBlockIsPlaced)
			if not ok or placed then
				return false
			end
			-- Placed on another spec of this character also counts: that player knows the block already. (And it keeps
			-- us quiet in the first seconds after login, when the spec may not be readable yet.)
			local guid = UnitGUID and UnitGUID("player")
			local snaps = ns.db and ns.db.keyBlockSnapshots
			if guid and type(snaps) == "table" then
				for k in pairs(snaps) do
					if type(k) == "string" and k:sub(1, #guid + 1) == guid .. ":" then
						return false
					end
				end
			end
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
}

local function Seen()
	if not ns.db then
		return nil
	end
	ns.db.newChoicesSeen = ns.db.newChoicesSeen or {}
	return ns.db.newChoicesSeen
end

--- The cards that apply; with onlyUnseen, only those not shown automatically before.
local function Pick(onlyUnseen)
	local seen = Seen() or {}
	local out = {}
	for _, c in ipairs(CARDS) do
		local ok, yes = pcall(c.avail)
		if ok and yes and not (onlyUnseen and seen[c.id]) then
			out[#out + 1] = c
		end
	end
	return out
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
	f.title:SetPoint("TOP", 0, -18)
	f.title:SetWidth(W - 60)

	local x = CreateFrame("Button", nil, f, "UIPanelCloseButton")
	x:SetPoint("TOPRIGHT", -6, -6)

	f.intro = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	f.intro:SetPoint("TOPLEFT", PAD + 4, -44)
	f.intro:SetWidth(W - 2 * PAD - 8)
	f.intro:SetJustifyH("LEFT")
	f.intro:SetSpacing(2)

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

	f:Hide()
	win = f
	tinsert(UISpecialFrames, "MidnightHelperNewChoices")
	if ns.RegisterMidnightDialogPopup then
		ns.RegisterMidnightDialogPopup(f)
	end
	return f
end

local function CardFrame(i)
	local c = cardFrames[i]
	if c then
		return c
	end
	c = CreateFrame("Frame", nil, win, "BackdropTemplate")
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
	cardFrames[i] = c
	return c
end

Render = function(cards)
	local f = Build()
	f.title:SetText(ns:L("NEWC_TITLE"))
	f.intro:SetText(ns:L("NEWC_INTRO"))
	local innerW = W - 2 * PAD
	local y = 44 + f.intro:GetStringHeight() + 10
	for i, card in ipairs(cards) do
		local c = CardFrame(i)
		c:ClearAllPoints()
		c:SetPoint("TOPLEFT", PAD, -y)
		c:SetWidth(innerW)
		c.head:SetWidth(innerW - 16)
		c.body:SetWidth(innerW - 16)
		c.head:SetText(ns:L(card.head))
		c.body:SetText(ns:L(card.body))
		local list = card.buttons()
		for _, b in ipairs(c.btns) do
			b:Hide()
		end
		-- Buttons as wide as their text (lint [28]), a new row when the next one does not fit.
		local top = 8 + c.head:GetStringHeight() + 4 + c.body:GetStringHeight() + 8
		local bx, rowsUsed = 8, 1
		for j, spec in ipairs(list) do
			local b = c.btns[j]
			if not b then
				b = Btn(c)
				c.btns[j] = b
			end
			b:SetText((spec.current and (GOOD .. "> |r") or "") .. spec.text)
			ns.FitButtonToText(b, 70, innerW - 16)
			if bx > 8 and bx + b:GetWidth() > innerW - 8 then
				bx = 8
				rowsUsed = rowsUsed + 1
			end
			b:ClearAllPoints()
			b:SetPoint("TOPLEFT", bx, -(top + (rowsUsed - 1) * 26))
			bx = bx + b:GetWidth() + 6
			b:SetScript("OnClick", function()
				spec.click()
				if spec.closes then
					f:Hide()
				elseif f:IsShown() then
					Render(f.cards)
				end
			end)
			b:Show()
		end
		local h = top + rowsUsed * 26 + 4
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
	f:SetHeight(y + 4 + 22 + 16)
end

local function MarkSeen(cards)
	local seen = Seen()
	if not seen then
		return
	end
	for _, c in ipairs(cards) do
		seen[c.id] = true
	end
end

--------------------------------------------------------------------------------
-- Automatic: after the other login questions, never in a fight.
--------------------------------------------------------------------------------
local OTHER_QUESTIONS = { "MidnightHelperForeverDirection", "MidnightHelperForeverBarLayout", "MidnightHelperForeverMyLayout" }
local lastWhy = "not checked yet"

local function OtherQuestionOpen()
	for _, n in ipairs(OTHER_QUESTIONS) do
		local fr = _G[n]
		if fr and fr.IsShown and fr:IsShown() then
			return n
		end
	end
	return nil
end

local tries = 0
local function TryAutoShow()
	local cards = Pick(true)
	if #cards == 0 then
		lastWhy = "nothing new to choose"
		return
	end
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
	Render(cards)
	MarkSeen(cards)
	win:Show()
	lastWhy = ("shown with %d card(s)"):format(#cards)
end

--- Changelog.lua asks this at login (Rob's choice A): true = there is something to choose, this window comes instead.
function ns.NewChoicesTakeOver()
	local ok, cards = pcall(Pick, true)
	if not ok or #cards == 0 then
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
		local seen = Seen() or {}
		for _, c in ipairs(CARDS) do
			local ok, yes = pcall(c.avail)
			print(("  %s: %s, %s"):format(c.id, (ok and yes) and "applies" or (ok and "does not apply" or "error"),
				seen[c.id] and "seen" or "not seen"))
		end
		return
	end
	local cards = Pick(false)
	if #cards == 0 then
		print(PREFIX .. ns:L("NEWC_NONE"))
		return
	end
	Render(cards)
	win:Show()
end
