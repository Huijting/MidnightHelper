local _, ns = ...

--[[
	ForeverSmartBuff.lua — WoW Forever: one macro "MH Smart Buff" that puts your class buff on the player under your
	mouse, else on your target. The same idea as the Paladin's Smart Bless (ForeverBlessTip.lua), for the other classes.

	Rob, 21 Nov 2026 (via sparring): "Kunnen wij ook een soort mouse-over macro maken voor de andere buffs, voor alle andere
	classes. Zodat ik die standaard op eenzelfde plek kan zetten, terwijl als mensen langslopen, dat ik gauw op hun een
	buff kan geven." On the proposal, literally: "Ja, wou het maar."

	Which classes (GEMETEN in ns.FOREVER_SPELL_IDS, wago DB2 wowf 1.60.1.70862, ForeverSpellIds.lua): the long buff a class
	puts on someone else — Mage Arcane Intellect, Priest Power Word: Fortitude, Druid Mark of the Wild. Paladin = Smart
	Bless (not twice). Warlock (Unending Breath) and Shaman (Water Breathing / Water Walking) only have short spells for
	water, Warrior/Rogue/Hunter none: no macro for them (the switch says so).
	How: unlike blessings there is one buff per class, so the macro line is fixed and the game picks at the press:
	  /cast [@mouseover,help,nodead][@target,help,nodead] <client name>
	plus a /run line that prints a hint when nobody friendly is under the mouse or targeted. MH writes it with EditMacro
	(the road that works in Forever, GEMETEN by Rob on Smart Bless, 21 Nov), out of combat, when the spell or the language
	changes. Cast by name = the highest rank you know (the client's rule, as the How you play text says).
	Overlap: the key block's mouseover mode (ForeverBlock.lua MO_HELP, /mh mouseover on) already puts these buffs on the
	mouse on their block keys. This is one macro to put anywhere, also without the key block.
	Off by default (players choose). Switch in Quiet helpers, diagnosis /mh smartbuff.
	NOT measured: the [help,nodead] chain with two units in one clause list in Forever (Smart Bless uses two clauses with
	a spell each; this uses one spell after two conditions — the same macro syntax, AFGELEID).
]]

if not ns.IS_FOREVER then
	return
end

local PREFIX = "|cffffcc00Midnight Helper:|r "
local MACRO = "MH Smart Buff"
local BUFF = { MAGE = "Arcane Intellect", PRIEST = "Power Word: Fortitude", DRUID = "Mark of the Wild" }

local written, why = nil, "not written yet"

local function On()
	return type(ns.db) == "table" and ns.db.foreverSmartBuff == true
end

local function ClassBuff()
	local _, cls = UnitClass("player")
	return BUFF[cls], cls
end

local function ClientName(id)
	if C_Spell and C_Spell.GetSpellName then
		local ok, n = pcall(C_Spell.GetSpellName, id)
		if ok and type(n) == "string" and n ~= "" and not (issecretvalue and issecretvalue(n)) then
			return n
		end
	end
	return nil
end

local function Quoteless(s)
	return (tostring(s or ""):gsub("[\"\\|]", ""))
end

--- The macro body for now: body, spell id (nil when not learned), reason.
local function Body()
	local english = ClassBuff()
	if not english then
		return nil, nil, "this class has no buff for others"
	end
	local id = ns.ForeverKnownSpell and ns.ForeverKnownSpell(english)
	if not id then
		-- The client's name from rank 1 (a name can be read for a spell you do not know).
		local ids = ns.FOREVER_SPELL_IDS and ns.FOREVER_SPELL_IDS[english]
		local shown = (ids and ids[1] and ClientName(ids[1])) or english
		return "#showtooltip\n/run print(\"" .. Quoteless(ns:L("FSBUFF_NOTYET_FMT"):format(shown)) .. "\")", nil,
			english .. " not learned yet"
	end
	local name = ClientName(id) or english
	-- #showtooltip without a name: the game shows the first /cast spell (saves room for the hint).
	local cast = "#showtooltip\n/cast [@mouseover,help,nodead][@target,help,nodead] " .. name
	local body = cast .. "\n/run if not(UnitCanAssist(\"player\",\"mouseover\")or UnitCanAssist(\"player\",\"target\"))then print(\""
		.. Quoteless(ns:L("FSBUFF_NONE")) .. "\")end"
	-- A macro holds 255 characters; a long name or a long hint (Cyrillic counts double) can pass it: then no hint line.
	if #body > 255 then
		return cast, id, "known: " .. name .. " (" .. id .. "), without the hint line (too long)"
	end
	return body, id, "known: " .. name .. " (" .. id .. ")"
end

local function Write()
	if not On() then
		why = "switched off"
		return
	end
	if InCombatLockdown and InCombatLockdown() then
		why = "in combat: the last text stays"
		return
	end
	if not (GetMacroIndexByName and EditMacro) then
		why = "no macro API"
		return
	end
	local body, _, r = Body()
	if not body then
		why = r
		return
	end
	if #body > 255 then
		why = ("too long for a macro (%d characters)"):format(#body)
		return
	end
	if body == written then
		return
	end
	local ok, idx = pcall(GetMacroIndexByName, MACRO)
	if not (ok and type(idx) == "number" and idx > 0) then
		why = "the macro \"" .. MACRO .. "\" does not exist (switch it on again to make it)"
		return
	end
	local okE, err = pcall(EditMacro, idx, MACRO, 134400, body)
	if okE then
		written = body
		why = "written " .. (date and date("%H:%M:%S") or "") .. " — " .. r
	else
		why = "EditMacro error: " .. tostring(err)
	end
end

local function Make()
	if not (GetMacroIndexByName and CreateMacro) or (InCombatLockdown and InCombatLockdown()) then
		return false
	end
	local ok, idx = pcall(GetMacroIndexByName, MACRO)
	if ok and type(idx) == "number" and idx > 0 then
		return true
	end
	local okC = pcall(CreateMacro, MACRO, 134400, "#showtooltip\n/run print(\"MH\")", true)
	if okC then
		written = nil
	end
	return okC
end

function ns.IsForeverSmartBuffOn()
	return On()
end

function ns.SetForeverSmartBuff(on)
	ns.db = ns.db or {}
	local english = ClassBuff()
	if on and not english then
		ns.db.foreverSmartBuff = nil
		print(PREFIX .. ns:L("FSBUFF_NOCLASS"))
		return
	end
	if on then
		ns.db.foreverSmartBuff = true
		if Make() then
			Write()
			local id = ns.ForeverKnownSpell and ns.ForeverKnownSpell(english)
			print(PREFIX .. ns:L("FSBUFF_ON_FMT"):format(MACRO, (id and ClientName(id)) or english))
			if ShowMacroFrame then
				pcall(ShowMacroFrame)
			end
		else
			print(PREFIX .. ns:L("FSBUFF_NOMACRO"))
		end
	else
		ns.db.foreverSmartBuff = nil
		print(PREFIX .. ns:L("FSBUFF_OFF"))
	end
end

local ev = CreateFrame("Frame")
for _, e in ipairs({ "PLAYER_ENTERING_WORLD", "PLAYER_REGEN_ENABLED", "SPELLS_CHANGED" }) do
	pcall(ev.RegisterEvent, ev, e)
end
ev:SetScript("OnEvent", function()
	if On() then
		Write()
	end
end)

--- /mh smartbuff [on|off]: the switch, and what the macro says now and why.
function ns.ForeverSmartBuffSlash(arg)
	arg = (arg or ""):lower()
	if arg == "on" or arg == "off" then
		ns.SetForeverSmartBuff(arg == "on")
		return
	end
	local english, cls = ClassBuff()
	local body, id, r = Body()
	print(PREFIX .. ("smart buff: %s, class %s, buff %s"):format(On() and "ON" or "off", tostring(cls),
		english or "none (no macro for this class)"))
	print("  now: " .. tostring(r) .. (id and (" · client name: " .. tostring(ClientName(id))) or ""))
	local okB, mBody = false, nil
	if GetMacroIndexByName and GetMacroBody then
		local okI, idx = pcall(GetMacroIndexByName, MACRO)
		if okI and type(idx) == "number" and idx > 0 then
			okB, mBody = pcall(GetMacroBody, idx)
		end
	end
	print("  macro \"" .. MACRO .. "\": " .. ((okB and type(mBody) == "string") and mBody:gsub("\n", " | ") or "missing"))
	print("  last write: " .. why .. ((InCombatLockdown and InCombatLockdown()) and " (in combat now)" or ""))
	print("  MH would write: " .. (body and body:gsub("\n", " | ") or "nothing"))
	if type(ns.db) == "table" then
		ns.db.foreverSmartBuffProbe = { at = time and time() or 0, on = On(), class = cls, id = id, why = why,
			macro = okB and mBody or nil }
	end
end
