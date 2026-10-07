local _, ns = ...

--[[
	A sound when YOU get a debuff your spec can remove (`/mh dispelsound on|off|test|why`). OFF by default.

	Rob, 7 Oct 2026: option C of docs/DISPEL_RECHECK_2026-10-07.md. Reading debuffs in combat is closed (secret
	auras, MEASURED 12 Aug / 31 Aug, rechecked 7 Oct). This reads NOTHING: it hands Blizzard a list of spell ids with
	C_UnitAuras.AddAuraSound, and the game plays the sound itself when one of them lands on "player". DBM does the same
	for "player" (DBM-Core/modules/objects/BossMod.lua:1474-1516, the call shape below is theirs).

	Which spells: the dispellable debuffs this account has actually met (ns.db.dispelCapture, filled out of combat by
	DispelCapture.lua, each with its school), and only the schools YOUR spec removes (ns.GetDispellableSchools). Re-done
	on login and on a spec change.

	⚠️ NOT MEASURED, which is why this is a test and not a feature yet:
	  - whether the game plays it for a known, non-private debuff on "player" in combat;
	  - the sound: FileDataID 566558 is DBM's default raid-warning sound ("Sound\\Doodad\\BellTollNightElf.ogg" per
	    DBM-Core/modules/objects/CoreOptions.lua:69). `/mh dispelsound test` plays it so you hear it first.
	  - since 12.1.5 a sound plays at most 5 seconds and throttleSeconds may not exceed 5 (wiki, in the recheck).
	`/mh dispelsound why` says what was registered and what the client refused.
]]

local SOUND_FILE = 566558
local THROTTLE = 3

local registered = {} -- ids returned by AddAuraSound
local lastReport = { ok = 0, fail = 0, spells = 0, why = "not run yet" }

local function API()
	local U = C_UnitAuras
	return U and U.AddAuraSound, U and (U.RemoveAuraSound or U.RemovePrivateAuraAppliedSound)
end

local function Enabled()
	return ns.db and ns.db.dispelSound == true
end

local function Clear()
	local _, remove = API()
	for _, id in ipairs(registered) do
		if remove then
			pcall(remove, id)
		end
	end
	registered = {}
end

local function Build()
	if not GetBuildInfo then
		return 0
	end
	local _, _, _, build = GetBuildInfo() -- 4th value = the interface number, e.g. 120100
	return tonumber(build) or 0
end

--- (Re)register the sounds for this spec. @return number ok, number fail, number spells
local function Register()
	Clear()
	local add = API()
	if not Enabled() then
		lastReport = { ok = 0, fail = 0, spells = 0, why = "off (/mh dispelsound on)" }
		return 0, 0, 0
	end
	if not add then
		lastReport = { ok = 0, fail = 0, spells = 0, why = "C_UnitAuras.AddAuraSound does not exist on this client" }
		return 0, 0, 0
	end
	local schools = ns.GetDispellableSchools and ns.GetDispellableSchools() or {}
	if not next(schools) then
		lastReport = { ok = 0, fail = 0, spells = 0, why = "your spec removes no debuff school" }
		return 0, 0, 0
	end
	local ids, seen = {}, {}
	for _, e in pairs(ns.db and ns.db.dispelCapture or {}) do
		local id = type(e) == "table" and tonumber(e.spellId)
		if id and id > 0 and e.school and schools[e.school] and not seen[id] then
			seen[id] = true
			ids[#ids + 1] = id
		end
	end
	local ok, fail = 0, 0
	local newApi = Build() >= 120105
	for _, id in ipairs(ids) do
		local info = { spellID = id, unitToken = "player", soundFileID = SOUND_FILE, outputChannel = "Master" }
		-- 12.1.5: throttleSeconds is a FIELD of this table (wiki API_C_UnitAuras.AddAuraSound, mh-research
		-- docs/PATCH_12_1_5_PREP_2026-10-07.md), not a third argument as DBM passes it. Max 5.
		if newApi then
			info.throttleSeconds = THROTTLE
		end
		local good, handle = pcall(add, 0, info)
		if good and handle then
			registered[#registered + 1] = handle
			ok = ok + 1
		else
			fail = fail + 1
		end
	end
	lastReport = { ok = ok, fail = fail, spells = #ids,
		why = #ids == 0 and "no captured debuff of a school you remove yet (dispelCapture fills in dungeons)" or "registered" }
	return ok, fail, #ids
end

local ev = CreateFrame("Frame")
ev:RegisterEvent("PLAYER_ENTERING_WORLD")
ev:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
ev:SetScript("OnEvent", function(_, event, unit)
	if event == "PLAYER_SPECIALIZATION_CHANGED" and unit ~= "player" then
		return
	end
	if InCombatLockdown and InCombatLockdown() then
		return -- the next login or spec change does it; the list does not change mid-fight
	end
	pcall(Register)
end)

--- `/mh dispelsound [on|off|test|why]`
function ns.DispelSoundCommand(arg)
	local p = ("|cffffcc00%s|r"):format(ns:L("PRINT_PREFIX"))
	arg = (arg or ""):lower()
	if arg == "on" or arg == "off" then
		ns.db = ns.db or {}
		ns.db.dispelSound = (arg == "on")
		local ok, fail, n = Register()
		print(("%s dispel sound %s: %d of %d spells registered, %d refused."):format(p, arg, ok, n, fail))
	elseif arg == "test" then
		if PlaySoundFile then
			pcall(PlaySoundFile, SOUND_FILE, "Master")
		end
		print(p .. " dispel sound: this is the sound (FileDataID " .. SOUND_FILE .. ").")
	else
		print(("%s dispel sound: %s. Registered %d of %d spells, %d refused. Client build %d. /mh dispelsound on|off|test"):format(
			p, Enabled() and "ON" or "off", lastReport.ok, lastReport.spells, lastReport.fail, Build()))
		print("   " .. tostring(lastReport.why))
	end
end
