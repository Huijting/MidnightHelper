local _, ns = ...

--[[
	ForeverBlessTip.lua — WoW Forever, paladin: which blessing for the player under your mouse (step 1 of "slimme zegen").
	Rob, 17 Nov 2026 (via Sparring 17-11): "Kan er een macro komen of bestaat er een macro ... die kan zien wat voor speler
	het is waar ik overheen [ga] en welke ik hem dan moet geven?" On the options (1 tooltip tip, 2 one smart button):
	"Allebei." This is (1); the smart button is (2), later. Plan: docs/IDEEEN.md, "slimme zegen".

	A line in the unit tooltip of a friendly PLAYER: "MH: Blessing of Might (Shift+Z)". Off by default (/mh blesstip on, or
	the setting). The table per class is a suggestion, AFGELEID (Classic knowledge; Might 19740 only gives melee attack
	power in Forever, GEMETEN by sparring in DB2 70938): melee → Might, casters → Wisdom, hybrids and hunters → Kings once
	you have it (20), else Wisdom. A blessing you do not know yet falls back to the next one you do. The player can change
	any class: /mh blesstip set <class> might|wisdom|kings.
	The key in brackets only when MH's key block macro for it exists ("MH SHIFT-Z" etc., ForeverBlock_Paladin.lua).
	NOT measured: whether TooltipDataProcessor (or OnTooltipSetUnit) fires in Forever, and whether UnitClass on a stranger
	is readable (secret values). So: every reading is guarded, /mh blesstip prints the hook, how often it fired and the
	choice + reason for your mouseover, and stores it in ns.db.foreverBlessTipProbe (silence rule, CLAUDE.md).
]]

if not ns.IS_FOREVER then
	return
end

local PREFIX = "|cffffcc00Midnight Helper:|r "
-- English names (ForeverBlock's Known() takes the English name and finds the rank this client knows), and the block key.
local BLESS = {
	-- id = rank 1 (sparring, GEMETEN DB2 wowf 70938), only used to show the client's name in a chat line.
	might = { name = "Blessing of Might", key = "SHIFT-Z", label = "Shift+Z", id = 19740 },
	wisdom = { name = "Blessing of Wisdom", key = "SHIFT-V", label = "Shift+V", id = 19742 },
	kings = { name = "Blessing of Kings", key = "SHIFT-X", label = "Shift+X", id = 20217 },
}
-- First choice per class; then the fallbacks in this order. AFGELEID, Rob/players may change it.
local DEFAULT = {
	WARRIOR = "might", ROGUE = "might",
	MAGE = "wisdom", WARLOCK = "wisdom", PRIEST = "wisdom",
	HUNTER = "kings", DRUID = "kings", SHAMAN = "kings", PALADIN = "kings",
}
local FALLBACK = { kings = { "kings", "wisdom", "might" }, wisdom = { "wisdom", "kings", "might" }, might = { "might", "kings", "wisdom" } }

local state = { hook = "none", fired = 0 }

local function Enabled()
	return ns.db and ns.db.foreverBlessTip == true
end

local function IsPaladin()
	local _, token = UnitClass("player")
	return token == "PALADIN"
end

local function Clean(v)
	if v == nil or (issecretvalue and issecretvalue(v)) then
		return nil
	end
	return v
end

local function Known(name)
	return ns.ForeverKnownSpell and ns.ForeverKnownSpell(name) or nil
end

--- The blessing for a unit: kind ("might"…), spell id, label, and the reason. nil + reason when there is none.
local function Pick(unit)
	if not unit then
		return nil, "no unit"
	end
	local okP, isPlayer = pcall(UnitIsPlayer, unit)
	if not (okP and Clean(isPlayer)) then
		return nil, "not a player (or unreadable)"
	end
	local okA, assist = pcall(UnitCanAssist, "player", unit)
	if not (okA and Clean(assist)) then
		return nil, "not friendly (or unreadable)"
	end
	local okC, _, token = pcall(UnitClass, unit)
	token = okC and Clean(token) or nil
	if type(token) ~= "string" then
		return nil, "class unreadable"
	end
	local own = ns.db and ns.db.foreverBlessTable and ns.db.foreverBlessTable[token]
	local want = BLESS[own] and own or DEFAULT[token] or "kings"
	for i, kind in ipairs(FALLBACK[want]) do
		local id = Known(BLESS[kind].name)
		if id then
			local why = ("%s → %s%s%s"):format(token, want, own and " (your choice)" or "",
				i > 1 and (", not known yet, so " .. kind) or "")
			return kind, id, token, why
		end
	end
	return nil, ("%s → %s, but you know no blessing yet"):format(token, want)
end

local function KeyLabel(kind)
	local b = BLESS[kind]
	if GetMacroIndexByName then
		local ok, idx = pcall(GetMacroIndexByName, "MH " .. b.key)
		if ok and type(idx) == "number" and idx > 0 then
			return b.label
		end
	end
	return nil
end

local function SpellName(id)
	if C_Spell and C_Spell.GetSpellName then
		local ok, n = pcall(C_Spell.GetSpellName, id)
		if ok and type(n) == "string" and n ~= "" and not (issecretvalue and issecretvalue(n)) then
			return n
		end
	end
	return nil
end

local function OnUnitTooltip(tt)
	state.fired = state.fired + 1
	if not (Enabled() and IsPaladin()) or tt ~= GameTooltip then
		return
	end
	local ok, _, unit = pcall(tt.GetUnit, tt)
	unit = ok and Clean(unit) or nil
	local kind, id, token, why = Pick(unit)
	state.last = { unit = unit, pick = kind, why = token and why or id }
	if not kind then
		return
	end
	local key = KeyLabel(kind)
	local name = SpellName(id) or BLESS[kind].name
	tt:AddLine(ns:L("FBLESS_TIP_FMT"):format(name .. (key and (" (" .. key .. ")") or "")), 0.95, 0.80, 0.35)
	tt:Show()
end

local function Hook()
	if TooltipDataProcessor and TooltipDataProcessor.AddTooltipPostCall and Enum and Enum.TooltipDataType
		and Enum.TooltipDataType.Unit then
		local ok = pcall(TooltipDataProcessor.AddTooltipPostCall, Enum.TooltipDataType.Unit, OnUnitTooltip)
		if ok then
			state.hook = "TooltipDataProcessor"
			return
		end
	end
	if GameTooltip and GameTooltip.HasScript and GameTooltip:HasScript("OnTooltipSetUnit") then
		GameTooltip:HookScript("OnTooltipSetUnit", OnUnitTooltip)
		state.hook = "OnTooltipSetUnit"
	end
end

--------------------------------------------------------------------------------
-- (2) The smart blessing button (19 Nov 2026; Rob via sparring, letterlijk: "Ja, die mogen door" on step 2 of
-- "slimme zegen", plan in docs/IDEEEN.md). ONE key that blesses the friendly player under your mouse with the blessing
-- Pick() chooses (the same choice as the tooltip line, and your own table).
-- How (the plan's rules): a hidden SecureActionButton "MidnightHelperSmartBless" (type spell, unit mouseover); a
-- SEPARATE event frame sets its "spell" attribute out of combat on UPDATE_MOUSEOVER_UNIT; in combat the last choice
-- stays (attributes cannot change then); no script on the secure button itself (lesson ForeverPartyPanel.lua:12-13).
-- Click phase pinned like ForeverDisenchant.lua (useOnKeyDown false, LeftButtonUp). You press it through a macro
-- "MH Smart Bless" (/click MidnightHelperSmartBless), made when you switch it on, out of combat; drag it to a bar.
-- Off by default (players choose): ns.db.foreverSmartBless == true. /mh blesstip says the button's state and spell.
-- NOT measured: that /click reaches a secure button in Forever, and UPDATE_MOUSEOVER_UNIT on unit frames.
--------------------------------------------------------------------------------
local SMART_NAME, SMART_MACRO = "MidnightHelperSmartBless", "MH Smart Bless"
local smart, smartWhy, smartSpell = nil, "not built (switched off, or not a paladin)", nil

local function SmartOn()
	return ns.db and ns.db.foreverSmartBless == true
end

local function BuildSmart()
	if smart or (InCombatLockdown and InCombatLockdown()) then
		return smart
	end
	smart = CreateFrame("Button", SMART_NAME, UIParent, "SecureActionButtonTemplate")
	smart:SetSize(1, 1)
	smart:SetPoint("TOPLEFT", UIParent, "TOPLEFT", -50, 50) -- off screen: only the macro clicks it
	smart:RegisterForClicks("LeftButtonUp")
	smart:SetAttribute("useOnKeyDown", false)
	smart:SetAttribute("type", "spell")
	smart:SetAttribute("unit", "mouseover")
	return smart
end

local function SmartUpdate()
	if not (SmartOn() and IsPaladin()) then
		smartWhy = "switched off (or not a paladin)"
		return
	end
	if InCombatLockdown and InCombatLockdown() then
		smartWhy = "in combat: the last choice stays"
		return
	end
	local b = BuildSmart()
	if not b then
		return
	end
	local kind, id, _, why = Pick("mouseover")
	if kind and id then
		b:SetAttribute("spell", id)
		smartSpell = id
		smartWhy = why
	else
		smartWhy = "mouseover: " .. tostring(id) .. " (the button keeps its last spell)"
	end
end

--- Make the macro once (out of combat); true when it exists afterwards.
local function SmartMacro()
	if not (GetMacroIndexByName and CreateMacro) or (InCombatLockdown and InCombatLockdown()) then
		return false
	end
	local ok, idx = pcall(GetMacroIndexByName, SMART_MACRO)
	if ok and type(idx) == "number" and idx > 0 then
		return true
	end
	local okC = pcall(CreateMacro, SMART_MACRO, 134400, "/click " .. SMART_NAME, true)
	return okC
end

function ns.IsForeverSmartBlessOn()
	return SmartOn()
end

function ns.SetForeverSmartBless(on)
	ns.db = ns.db or {}
	if on then
		ns.db.foreverSmartBless = true
		BuildSmart()
		SmartUpdate()
		if SmartMacro() then
			print(PREFIX .. ns:L("FBLESS_BTN_ON_FMT"):format(SMART_MACRO))
			if ShowMacroFrame then
				pcall(ShowMacroFrame) -- to drag it onto a bar (AFGELEID that Forever has it, as ForeverMacros.lua says)
			end
		else
			print(PREFIX .. ns:L("FBLESS_BTN_NOMACRO"))
		end
	else
		ns.db.foreverSmartBless = nil
		print(PREFIX .. ns:L("FBLESS_BTN_OFF"))
	end
end

local sev = CreateFrame("Frame")
pcall(sev.RegisterEvent, sev, "UPDATE_MOUSEOVER_UNIT")
pcall(sev.RegisterEvent, sev, "PLAYER_REGEN_ENABLED")
pcall(sev.RegisterEvent, sev, "PLAYER_ENTERING_WORLD")
sev:SetScript("OnEvent", function()
	if SmartOn() then
		SmartUpdate()
	end
end)

-- Hook once, at login (the tooltip exists by then); cheap when the switch is off (one counter, one return).
local ev = CreateFrame("Frame")
ev:RegisterEvent("PLAYER_LOGIN")
ev:SetScript("OnEvent", function(self)
	self:UnregisterAllEvents()
	if IsPaladin() then
		Hook()
	end
end)

--- /mh blesstip [on|off|set <class> <might|wisdom|kings>|reset]: the switch, your own table, and the diagnosis.
function ns.ForeverBlessTipSlash(arg)
	arg = (arg or ""):lower()
	ns.db = ns.db or {}
	if arg == "on" or arg == "off" then
		ns.db.foreverBlessTip = (arg == "on") or nil
		print(PREFIX .. ns:L(arg == "on" and "FBLESS_ON" or "FBLESS_OFF"))
		return
	end
	if arg == "button on" or arg == "button off" then
		ns.SetForeverSmartBless(arg == "button on")
		return
	end
	local cls, kind = arg:match("^set%s+(%a+)%s+(%a+)$")
	if cls then
		cls = cls:upper()
		if not DEFAULT[cls] or not BLESS[kind] then
			print(PREFIX .. ns:L("FBLESS_SET_USAGE"))
			return
		end
		ns.db.foreverBlessTable = ns.db.foreverBlessTable or {}
		ns.db.foreverBlessTable[cls] = kind
		-- The client's own words (a translator saw "HUNTER now gets might" in every language).
		local names = LOCALIZED_CLASS_NAMES_MALE
		print(PREFIX .. ns:L("FBLESS_SET_FMT"):format((names and names[cls]) or cls,
			SpellName(BLESS[kind].id) or BLESS[kind].name))
		return
	end
	if arg == "reset" then
		ns.db.foreverBlessTable = nil
		print(PREFIX .. ns:L("FBLESS_RESET"))
		return
	end
	-- Diagnosis: what MH reads and decides for your mouseover right now.
	local kind, id, token, why = Pick("mouseover")
	print(PREFIX .. ("blessing tip: %s, paladin %s, hook %s, fired %d time(s)"):format(Enabled() and "ON" or "off",
		tostring(IsPaladin()), state.hook, state.fired))
	print("  mouseover: " .. (kind and (("%s (%s) — %s"):format(SpellName(id) or kind, tostring(id), why)) or tostring(id)))
	-- The smart button (19 Nov 2026): on/off, built, the spell on it now, the last decision, and the macro.
	local mOk, mIdx = false, 0
	if GetMacroIndexByName then
		mOk, mIdx = pcall(GetMacroIndexByName, SMART_MACRO)
	end
	print(("  smart button: %s, built %s, spell on it %s, last: %s; macro \"%s\" %s (/mh blesstip button on|off)"):format(
		SmartOn() and "ON" or "off", tostring(smart ~= nil), smartSpell and (SpellName(smartSpell) or tostring(smartSpell))
		or "none", smartWhy, SMART_MACRO, (mOk and type(mIdx) == "number" and mIdx > 0) and "exists" or "missing"))
	local t = {}
	for c, d in pairs(DEFAULT) do
		local own = ns.db.foreverBlessTable and ns.db.foreverBlessTable[c]
		t[#t + 1] = c:sub(1, 3) .. "=" .. (own and (own .. "*") or d)
	end
	table.sort(t)
	print("  table (* = yours): " .. table.concat(t, " "))
	print("  " .. ns:L("FBLESS_HELP"))
	ns.db.foreverBlessTipProbe = {
		at = time and time() or 0, enabled = Enabled(), hook = state.hook, fired = state.fired,
		mouseover = { pick = kind, id = id, class = token, why = kind and why or id }, last = state.last,
	}
	print("  saved in SavedVariables (foreverBlessTipProbe) — /reload writes it to disk.")
end
