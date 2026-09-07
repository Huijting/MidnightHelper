local _, ns = ...

--[==[
	Midnight Helper — `/mh pet`: can we see that your pet is still taunting?

	🔴 ROB'S REQUEST, 7 Sep 2026: *"het komt regelmatig voor dat ik Carola of Cisca in een
	instance zitten met een tank en dan vergeten we onze Growl uit te zetten — kunnen we dat
	melden?"* A pet taunting while somebody else tanks pulls mobs off them, and nothing in the
	game says a word about it.

	⚠️ THE OBVIOUS VERSION OF THIS FEATURE CANNOT BE BUILT. "Is there a tank in the group"
	needs `UnitGroupRolesAssigned` on OTHER units, and 12.1 returns a **secret** for those
	whenever the unit's identity is hidden. `role == "TANK"` on a secret is the comparison that
	throws — the same trap four GUID reads fell into in July, two of which shipped. See
	`Modules/DelveCuriosAdvisor.lua:40`.

	✅ So the question is turned around: **am I not the tank?** That is answered by
	`GetSpecializationRole`, which asks about your SPEC and never about a unit, so no secret can
	reach it. `DelveCuriosAdvisor.GetPlayerRoleKey` already does exactly this, guard and all.

	❓ WHAT IS GENUINELY UNKNOWN, and the only reason this probe exists: whether the pet action
	bar's autocast state is readable on 12.1. Nothing in this addon has ever called
	`GetPetActionInfo`. Not knowing is not the same as it being blocked — so ask, rather than
	assume in either direction. See [[silence-is-not-absence]].

	📌 This is measurable SOLO. Only the group half needed other people, and that half is gone.
]==]

local function Prefix()
	return ("|cffffcc00%s|r"):format((ns.L and ns:L("PRINT_PREFIX")) or "Midnight Helper:")
end

local function Secret(v)
	return issecretvalue and v ~= nil and issecretvalue(v) == true
end

--- One value, made printable without ever asking what it IS.
local function State(v)
	if v == nil then
		return "|cff8a8f98nil|r"
	end
	if Secret(v) then
		return "|cffff5555SECRET|r"
	end
	return "|cff40c040" .. tostring(v) .. "|r"
end

--- Taunts a pet can put on autocast, by spell id so it survives translation.
--- ⚠️ CANDIDATES, not a measured list — these come from what the classes are known to have,
--- and the probe prints every slot anyway so a missing one shows up as an unrecognised row
--- rather than as silence.
local PET_TAUNTS = {
	[2649] = "Growl (hunter pet)",
	[17735] = "Suffering (warlock Voidwalker)",
	[7812] = "Sacrifice (Voidwalker, not a taunt but often confused)",
}

function ns.PrintPetTauntProbe()
	local p = Prefix()
	print(p .. " pet taunt probe")

	-- Your own role, both routes, so the difference is visible rather than assumed.
	local unitRole, specRole
	if UnitGroupRolesAssigned then
		local ok, r = pcall(UnitGroupRolesAssigned, "player")
		unitRole = ok and r or nil
	end
	if GetSpecialization and GetSpecializationRole then
		local s = GetSpecialization()
		if s then
			local ok, r = pcall(GetSpecializationRole, s)
			specRole = ok and r or nil
		end
	end
	print(("  your role — UnitGroupRolesAssigned: %s   GetSpecializationRole: %s"):format(
		State(unitRole), State(specRole)))
	print("  |cff8a8f98The second one is what a real feature would use: it asks your SPEC,|r")
	print("  |cff8a8f98not a unit, so no secret can reach it.|r")

	local inInst, kind = false, "none"
	if IsInInstance then
		local ok, a, b = pcall(IsInInstance)
		if ok then
			inInst, kind = a, b
		end
	end
	local n = (GetNumGroupMembers and GetNumGroupMembers()) or 0
	print(("  instance: %s (%s)   group size: %s   pet out: %s"):format(
		tostring(inInst), tostring(kind), tostring(n),
		tostring(UnitExists and UnitExists("pet") or false)))

	-- THE POINT OF THE WHOLE FILE.
	if not GetPetActionInfo then
		print("  |cffff5555GetPetActionInfo does not exist on this client|r — that is the answer.")
		return
	end
	local slots = (NUM_PET_ACTION_SLOTS and tonumber(NUM_PET_ACTION_SLOTS)) or 10
	print(("  pet action bar (%d slots):"):format(slots))

	local seen, taunt = 0, nil
	for i = 1, slots do
		local ok, name, tex, isToken, isActive, autoAllowed, autoEnabled, spellID =
			pcall(GetPetActionInfo, i)
		if ok and name ~= nil then
			seen = seen + 1
			print(("    %2d. %-24s autoAllowed=%s autoEnabled=%s spellID=%s"):format(
				i, tostring(Secret(name) and "<secret>" or name),
				State(autoAllowed), State(autoEnabled), State(spellID)))
			local sid = (not Secret(spellID)) and tonumber(spellID) or nil
			if sid and PET_TAUNTS[sid] then
				taunt = { slot = i, id = sid, label = PET_TAUNTS[sid], on = autoEnabled }
			end
		end
	end

	if seen == 0 then
		print("    |cffff8844nothing came back|r — no pet out, or the bar is not readable.")
		print("    |cff8a8f98Empty here does NOT mean 'blocked': summon a pet and run it again|r")
		print("    |cff8a8f98before concluding anything. That is the positive control.|r")
		return
	end

	print("  verdict:")
	if not taunt then
		print("    |cff8a8f98No known pet taunt on the bar. Either this pet has none, or its|r")
		print("    |cff8a8f98id is not in our candidate list — the rows above say which.|r")
	else
		print(("    |cffffd100%s|r in slot %d, autocast reads %s"):format(
			taunt.label, taunt.slot, State(taunt.on)))
		if Secret(taunt.on) then
			print("    |cffff5555Autocast is SECRET|r — the reminder cannot be built this way.")
		elseif taunt.on == nil then
			print("    |cffff8844Autocast came back nil|r — readable call, unusable answer.")
		else
			print("    |cff40c040Autocast is readable.|r Together with the spec role above,")
			print("    |cff40c040the reminder is buildable: not the tank + taunt on = warn.|r")
		end
	end
end
