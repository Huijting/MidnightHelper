local _, ns = ...

--[[
	MaxLevelWelcome.lua — Midnight: "You are 90. This is what you do now." Once, the moment you reach the top level.

	Rob, 16 Nov 2026 (via sparring, on the list of small ideas, letterlijk: "allemaal"). Idea S1 form 1 in
	docs/IDEEEN.md: survey answer #24 asked exactly this, and GEMETEN that day nothing in the addon did anything at that
	moment except refresh a bar (ZoneLevelGate.lua, PLAYER_LEVEL_UP).

	A small Blizzard popup (StaticPopup, like FirstRun.lua: Escape, position and the Shift+scroll rule are Blizzard's
	own there) with three buttons: "My gear: what now?" (GearLadder.lua), "Start Here", and "Later".
	- Only on PLAYER_LEVEL_UP to the max level of the player's expansion (GetMaxLevelForPlayerExpansion), never on login:
	  a character that is already 90 never sees it.
	- Once per character (ns.db.maxLevelWelcome[guid]). In a fight it waits until the fight ends.
	- Retail only: Forever has its own level path (the file stops there).

	/mh maxlevel        what MH would do for this character, and why (silence rule, CLAUDE.md)
	/mh maxlevel popup  the popup as players see it (does not use up the one time)
]]

if ns.IS_FOREVER then
	return
end

local POPUP_KEY = "MIDNIGHTHELPER_MAXLEVEL_WELCOME"

local function MaxLevel()
	if GetMaxLevelForPlayerExpansion then
		local ok, v = pcall(GetMaxLevelForPlayerExpansion)
		if ok and tonumber(v) then
			return tonumber(v)
		end
	end
	return nil
end

local function Guid()
	return UnitGUID and UnitGUID("player") or nil
end

local function Seen()
	if type(ns.db) ~= "table" then
		return nil
	end
	ns.db.maxLevelWelcome = ns.db.maxLevelWelcome or {}
	return ns.db.maxLevelWelcome
end

local function Show()
	if type(StaticPopupDialogs) ~= "table" or not StaticPopup_Show then
		return
	end
	StaticPopupDialogs[POPUP_KEY] = StaticPopupDialogs[POPUP_KEY] or {}
	local d = StaticPopupDialogs[POPUP_KEY]
	-- Texts refreshed every time so they follow the current language.
	d.text = ns:L("MAXLVL_POPUP_FMT"):format(MaxLevel() or 90, ns:L("GEARLADDER_TITLE"), ns:L("TAB_START_HERE"))
	d.button1 = ns:L("MAXLVL_BTN_GEAR") -- short: a popup button is narrow; the full window name is in the text
	d.button2 = ns:L("MAXLVL_LATER")
	d.button3 = ns:L("TAB_START_HERE")
	d.OnAccept = function()
		if ns.ToggleGearLadder then
			ns.ToggleGearLadder()
		end
	end
	d.OnAlt = function()
		if ns.ShowMainUI then
			ns:ShowMainUI()
		end
		if ns.SelectTab then
			ns.SelectTab("starthere")
		end
	end
	d.timeout = 0
	d.whileDead = true
	d.hideOnEscape = true
	d.showAlert = false
	d.preferredIndex = 3 -- Blizzard's advice against taint
	StaticPopup_Show(POPUP_KEY)
end

local waiting = false
local f = CreateFrame("Frame")

local function ShowWhenCalm()
	if InCombatLockdown and InCombatLockdown() then
		waiting = true
		f:RegisterEvent("PLAYER_REGEN_ENABLED")
		return
	end
	waiting = false
	Show()
end

f:RegisterEvent("PLAYER_LEVEL_UP")
f:SetScript("OnEvent", function(self, event, newLevel)
	if event == "PLAYER_REGEN_ENABLED" then
		self:UnregisterEvent("PLAYER_REGEN_ENABLED")
		if waiting then
			ShowWhenCalm()
		end
		return
	end
	local max = MaxLevel()
	local guid = Guid()
	local seen = Seen()
	if not (max and guid and seen) or tonumber(newLevel) ~= max or seen[guid] then
		return
	end
	seen[guid] = true
	-- A moment for the game's own level-up fanfare first.
	if C_Timer and C_Timer.After then
		C_Timer.After(3, ShowWhenCalm)
	else
		ShowWhenCalm()
	end
end)

--- `/mh maxlevel [popup]` (Core.lua).
function ns.HandleMaxLevelCommand(arg)
	arg = (arg or ""):lower()
	if arg == "popup" then
		Show()
		return
	end
	local max, lvl, guid = MaxLevel(), UnitLevel and UnitLevel("player"), Guid()
	local seen = Seen() or {}
	local why
	if not max then
		why = "the game does not say its max level here (GetMaxLevelForPlayerExpansion): never shows"
	elseif guid and seen[guid] then
		why = "already shown for this character"
	elseif lvl and lvl >= max then
		why = "already at the top level: it only shows at the moment you reach it, not on login"
	else
		why = ("will show once when this character reaches %d"):format(max)
	end
	print(("|cffffcc00Midnight Helper|r max-level welcome: level %s of %s; %s. (/mh maxlevel popup = see it)"):format(
		tostring(lvl), tostring(max), why))
end
