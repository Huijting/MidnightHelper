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
	might = { name = "Blessing of Might", key = "SHIFT-Z", label = "Shift+Z" },
	wisdom = { name = "Blessing of Wisdom", key = "SHIFT-V", label = "Shift+V" },
	kings = { name = "Blessing of Kings", key = "SHIFT-X", label = "Shift+X" },
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
	local cls, kind = arg:match("^set%s+(%a+)%s+(%a+)$")
	if cls then
		cls = cls:upper()
		if not DEFAULT[cls] or not BLESS[kind] then
			print(PREFIX .. ns:L("FBLESS_SET_USAGE"))
			return
		end
		ns.db.foreverBlessTable = ns.db.foreverBlessTable or {}
		ns.db.foreverBlessTable[cls] = kind
		print(PREFIX .. ns:L("FBLESS_SET_FMT"):format(cls, kind))
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
