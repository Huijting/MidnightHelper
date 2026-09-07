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
---
--- ✅ BOTH ROWS ARE MEASURED, each with the value MOVING rather than merely being read:
---     Growl      2649   hunter pet,          on -> autoEnabled=true, off -> false  (7 Sep)
---     Suffering  17735  warlock Voidwalker,  on -> autoEnabled=true, off -> false  (7 Sep)
--- A single reading of `true` would only have proved the field exists.
---
--- 🔴 `7812` (Sacrifice) USED TO BE IN THIS TABLE, carrying the label *"not a taunt but often
--- confused"*. Found 7 Sep while confirming Suffering. This table is not a glossary — every id
--- in it makes `ShouldWarn` warn, so a row that says in its own text that it does not belong
--- was a false alarm waiting for someone to put Sacrifice on autocast. The note was worth
--- keeping; arming it was not.
---
--- ✅ AND THE REST OF THE VOIDWALKER'S BAR WAS READ RATHER THAN ASSUMED — Rob's own tooltips,
--- 7 Sep, because three of its four abilities sit on autocast and "on by default" is not the
--- same as "belongs in this table":
---     17735  Suffering            "taunts the target to attack it for 6 sec"; autocast
---                                 "taunts any target who attacks its master"     -> IN
---     112042 Threatening Presence "increasing threat generation"; autocast
---                                 "always keep this effect active"               -> OUT
---     3716   Consuming Shadows    "drains health from all nearby enemies"        -> OUT
---     17767  Shadow Bulwark       "increases health by 30%" below 20%            -> OUT
---
--- 📌 Threatening Presence is the one worth explaining, because it is genuinely tempting: more
--- pet threat does contribute to Rob's actual complaint. It stays out for three reasons, and
--- the first is enough on its own — **it is not a taunt, and our sentence says it is**. Then:
--- its own autocast text says to keep it active, so warning about it would fire for every
--- warlock with a Voidwalker out; and the behaviour Rob reported is precisely what Suffering's
--- autocast line describes, taking mobs off whoever is tanking.
local PET_TAUNTS = {
	[2649] = "Growl (hunter pet)",
	[17735] = "Suffering (warlock Voidwalker)",
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

	-- The live decision, printed by the probe so "it said nothing" is never a mystery.
	--
	-- ⚠️ Through `ns.` and not through the locals: those are declared BELOW this function, and
	-- calling them directly is a nil global at run time. Lint check [6] caught exactly that
	-- here — the same trap `FitFoot` fell into on 6 Sep. An `ns.` name resolves when the
	-- function runs, by which point the whole file has loaded.
	if ns.PetTauntVerdict then
		local warn, _n, reason = ns.PetTauntVerdict()
		print(("  |cffffd100live check right now: would warn = %s (%s)|r"):format(
			tostring(warn), tostring(reason)))
	end
	if ns.PetTauntRealPlayers then
		print(("  |cff8a8f98real players in the group: %d|r  (Valeera is not one, but she still"):
			format(ns.PetTauntRealPlayers()))
		print("  |cff8a8f98counts as somebody to steal aggro from — see the line below)|r")
	end
	if ns.PetTauntTankInGroup then
		local t = ns.PetTauntTankInGroup()
		print(("  |cff8a8f98somebody tanking: %s|r"):format(tostring(t)))
		print("  |cff8a8f98   true = warn · false = stay quiet · nil = roles unreadable, warn anyway|r")
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

--------------------------------------------------------------------------------
-- The reminder itself
--------------------------------------------------------------------------------
--
-- ✅ MEASURED on Rob's Beast Mastery hunter, 7 Sep 2026, and the second run is what makes it
-- a measurement rather than a sighting:
--
--     Growl on   ->  6. Growl  autoAllowed=true  autoEnabled=true   spellID=2649
--     Growl off  ->  6. Growl  autoAllowed=true  autoEnabled=false  spellID=2649
--
-- The value MOVED. A single reading of `true` would only have proved the field exists.
--
-- 📌 And the same run settled the role question: standing solo, `UnitGroupRolesAssigned`
-- answered `NONE` while `GetSpecializationRole` answered `DAMAGER`. The unit route is not
-- merely secret-prone, it is empty when nobody has assigned you anything — which is most of
-- the time. The spec route is the only one that always knows.
--
-- 🔴 WHAT THIS DELIBERATELY DOES NOT CLAIM: that somebody else is tanking. We cannot read
-- another player's role without walking into a secret, so the line says only what is true and
-- measured -- *you* are not the tank and *your* pet's taunt is on. In a five-man that is the
-- same thing; in a two-man old raid it is not, and there the sentence is still not a lie.
--
-- ⚠️ Silent when solo, and that is not laziness: in a delve you WANT Growl on. Valeera tanks
-- nothing. So the group check is a feature, not a guard.

local watcher = CreateFrame("Frame")
local warnedFor = nil -- one warning per instance visit, not per event

--- 🔴 GetNumGroupMembers COUNTS VALEERA — measured in a delve, 7 Sep 2026.
---
--- The first version required `GetNumGroupMembers() >= 2` to keep delves quiet, on the
--- assumption that solo means a group of one. It does not: Rob's `/mh pet` inside a delve
--- read **`instance: true (scenario)   group size: 2`**. The delve companion occupies a party
--- slot, so every one of the four conditions was met and the warning would have fired in the
--- one place it must never fire.
---
--- ⚠️ Not fixed by excluding `scenario`: Broken Throne rituals are scenarios too, and those
--- are real groups where the warning is wanted. The honest test is not how many units are in
--- the party but how many of them are PEOPLE — a follower is not a player.
---
--- ⚠️ `UnitIsPlayer` is guarded rather than trusted. A secret boolean survives `pcall` and
--- bites at the comparison, which is the trap four GUID reads fell into in July.
--- @return number
local function RealPlayersInGroup()
	if IsInRaid and IsInRaid() then
		-- Followers do not take raid slots, so the plain count is safe here.
		return (GetNumGroupMembers and GetNumGroupMembers()) or 0
	end
	local n = 1 -- yourself
	for i = 1, 4 do
		local u = "party" .. i
		if UnitExists and UnitExists(u) and UnitIsPlayer then
			local ok, isPlayer = pcall(UnitIsPlayer, u)
			if ok and not Secret(isPlayer) and isPlayer == true then
				n = n + 1
			end
		end
	end
	return n
end

--- Is somebody in this group tanking?
---
--- 🔴 ROB'S QUESTION, 7 Sep 2026, holding a screenshot of his party frame: *"waarom zien we
--- daar wel dat ik DPS ben en Valeera een tank is?"* Fair, and it corrected me. I had treated
--- `UnitGroupRolesAssigned` as unusable because Blizzard's 12.1 notes say it returns a secret
--- **when the unit's identity is secret**. That is a documented POSSIBILITY, and I had turned
--- it into a blanket refusal — while Rob's own `/mh pet` had printed `DAMAGER` from that very
--- function twice that afternoon, in a delve and in a raid.
---
--- ⚠️ So the rule is not "do not read it". The rule is **do not COMPARE a secret**: `role ==
--- "TANK"` is what throws, not the call. Guarded, the read is worth having.
---
--- 📌 Followers count. Valeera holds the TANK role in a delve, and a pet taunting off her is
--- the same mistake as taunting off a player — which is what makes this answer Rob's duo-delve
--- question at the same time.
---
--- @return boolean|nil true = somebody is tanking, false = nobody is, nil = could not read
local function TankInGroup()
	if not (UnitExists and UnitGroupRolesAssigned) then
		return nil
	end
	local units, n = {}, 0
	if IsInRaid and IsInRaid() then
		for i = 1, 40 do
			units[#units + 1] = "raid" .. i
		end
	else
		for i = 1, 4 do
			units[#units + 1] = "party" .. i
		end
	end
	-- ⚠️ No `UnitIsUnit` to skip yourself: that returns a SECRET BOOLEAN on 12.1 and asking
	-- what it is throws. Not needed anyway — we only get here when the player is not a tank,
	-- so finding "a tank" can never be finding yourself.
	for i = 1, #units do
		local u = units[i]
		if UnitExists(u) then
			local ok, role = pcall(UnitGroupRolesAssigned, u)
			if ok and role ~= nil and not Secret(role) then
				n = n + 1
				if role == "TANK" then
					return true
				end
			end
		end
	end
	if n == 0 then
		return nil -- nobody's role could be read; that is not the same as nobody tanking
	end
	return false
end

--- Is there anybody else at all — player or follower?
---
--- 🔴 This replaced a `>= 2 REAL players` rule on 7 Sep, and Rob's reason is the whole point:
--- *"ik merk dat wanneer mijn pets Growl aan hebben staan, dat ze heel snel doodgaan als er
--- meerdere adds zijn. Ik wil het graag in een delve hebben."* The old rule kept delves quiet
--- on my assumption that solo means nobody to steal aggro from. Valeera is somebody, she reads
--- as TANK, and his pet dies for it.
---
--- ⚠️ But "anybody" still has to mean SOMEBODY. Alone in an old dungeon with no group at all,
--- the pet IS the tank and Growl belongs on — so an empty party stays silent. That case and
--- "group exists, roles unreadable" are different things and are answered differently below.
--- @return boolean
local function AnyGroupMember()
	if IsInRaid and IsInRaid() then
		return ((GetNumGroupMembers and GetNumGroupMembers()) or 0) > 0
	end
	for i = 1, 4 do
		if UnitExists and UnitExists("party" .. i) then
			return true
		end
	end
	return false
end

--- @return boolean|nil warn, string|nil tauntName, string reason — nil warn = cannot tell
local function ShouldWarn()
	-- Somebody has to be there to steal aggro from.
	if not AnyGroupMember() then
		return false, nil, "nobody else here — your pet IS the tank"
	end
	local inInst = false
	if IsInInstance then
		local ok, a = pcall(IsInInstance)
		inInst = ok and a or false
	end
	if not inInst then
		return false, nil, "not in an instance"
	end

	-- Am I the tank? Spec route only -- see the note above.
	if not (GetSpecialization and GetSpecializationRole) then
		return nil, nil, "no spec API on this client"
	end
	local spec = GetSpecialization()
	if not spec then
		return nil, nil, "no specialization selected"
	end
	local okRole, role = pcall(GetSpecializationRole, spec)
	if not okRole or role == nil then
		return nil, nil, "GetSpecializationRole gave nothing"
	end
	if role == "TANK" then
		return false, nil, "you ARE the tank"
	end

	-- Is anyone else? Added 7 Sep after Rob pointed at his own party frame.
	--
	-- ⚠️ `nil` FALLS THROUGH ON PURPOSE. Could-not-read is not the same as nobody-tanking, and
	-- staying silent on a reading we failed to make would hide a real mistake on the strength
	-- of our own blindness. When it is nil the warning behaves exactly as it did before this
	-- check existed — and the sentence never claimed a tank exists, so it stays true either way.
	local tank = TankInGroup()
	if tank == false then
		return false, nil, "nobody in the group is tanking"
	end

	-- Is a taunt on autocast?
	if not (GetPetActionInfo and UnitExists and UnitExists("pet")) then
		return false, nil, "no pet out"
	end
	local slots = (NUM_PET_ACTION_SLOTS and tonumber(NUM_PET_ACTION_SLOTS)) or 10
	for i = 1, slots do
		local ok, name, _tex, _isToken, _isActive, _allowed, autoEnabled, spellID =
			pcall(GetPetActionInfo, i)
		if ok then
			local sid = (not Secret(spellID)) and tonumber(spellID) or nil
			if sid and PET_TAUNTS[sid] and autoEnabled == true then
				return true, (not Secret(name)) and name or nil,
					tank == true and "taunt on autocast, somebody else is tanking"
					or "taunt on autocast (nobody's role could be read)"
			end
		end
	end
	return false, nil, "no known taunt on autocast"
end

--- Exposed so the probe can print the same verdict the live path uses. ⚠️ There is no
--- `if testMode` branch anywhere below: the test walks the identical function, which is the
--- rule in CLAUDE.md and the reason `/mh dispeltest` exists in the shape it does.
function ns.PetTauntVerdict()
	return ShouldWarn()
end

--- Same reason: the probe above needs this and is defined earlier in the file.
function ns.PetTauntRealPlayers()
	return RealPlayersInGroup()
end

function ns.PetTauntTankInGroup()
	return TankInGroup()
end

--- @param force boolean|nil skip the once-per-instance memory (the test path)
local function Check(force)
	local warn, tauntName = ShouldWarn()
	if warn ~= true then
		if warn == false then
			warnedFor = nil -- left the instance, or turned it off: allow a fresh warning later
			--- Rob, 7 Sep: *"op het moment dat ik de growl weer uitzet, kan die dan automatisch
			--- weggaan?"* Yes. `PET_BAR_UPDATE` already brings us here when the autocast toggle
			--- changes, so the card leaves the moment its reason does.
			---
			--- ⚠️ Only on `false`, never on `nil`. `nil` means we could not read the situation,
			--- and pulling a warning off the screen because we went blind would be the same
			--- mistake as never showing it -- the player would see the card vanish and read that
			--- as "handled". A `nil` leaves it standing until its own timer runs out.
			if ns.RetractMidnightToast then
				pcall(ns.RetractMidnightToast, "pet_taunt_on")
			end
		end
		return
	end
	local key = tostring(GetInstanceInfo and select(8, GetInstanceInfo()) or "?")
	if not force then
		if warnedFor == key then
			return
		end
		warnedFor = key
	end

	local label = tauntName or "Growl"
	print(("|cffffcc00%s|r %s"):format(
		(ns.L and ns:L("PRINT_PREFIX")) or "Midnight Helper:",
		(ns:L("PETTAUNT_WARN_CHAT")):format(label)))
	if ns.QueueMidnightToast then
		pcall(ns.QueueMidnightToast, {
			id = "pet_taunt_on",
			title = ns:L("PETTAUNT_WARN_TITLE"),
			body = (ns:L("PETTAUNT_WARN_CHAT")):format(label),
			--- 🔴 Rob, 7 Sep: *"ik wil het graag in een delve hebben met een duidelijke
			--- waarschuwing. Niet alleen maar een regel beneden in mijn chat."* Same answer
			--- as the level gate got on 5 Sep, and for the same reason — nobody reads chat
			--- mid-pull. 20 seconds because this is acted on (right-click the pet bar), not
			--- glanced at, and the same SOUNDKIT the rest of the addon uses so "Midnight
			--- Helper wants you" stays one sound instead of a zoo.
			displaySec = 20,
			--- Rob picked this one by ear from `/mh pet sounds` (candidate 5). I cannot hear
			--- anything, so the choice is his and the list existed to make it his.
			soundKit = SOUNDKIT and SOUNDKIT.RAID_WARNING or nil,
			--- Dead centre for this one toast. The next toast returns to wherever the player
			--- dragged theirs, because the position is applied per toast and never stored.
			center = true,
			--- Rob, 7 Sep, straight after it first worked: *"kan ie flashen??"* Yes — and
			--- this toast is the reason the option exists, because it is one you act on
			--- before the pull rather than read afterwards.
			flash = true,
			icon = 132270, -- Growl's own icon
		})
	end
end

--- `/mh pet test` — fire the real thing on demand, debounce ignored.
---
--- 🔴 Rob asked for this the moment he needed it: *"hebben we een commando om hem op te
--- roepen??"* — standing in a delve where the warning should have appeared and did not, with
--- no way to tell a broken feature from an unloaded file. CLAUDE.md has required exactly this
--- of anything that can go quiet since Spec 30, and I built the warning without it.
function ns.RunPetTauntTest()
	local warn, _name, reason = ShouldWarn()
	local p = Prefix()
	print(("%s pet taunt test — would warn: %s (%s)"):format(
		p, tostring(warn), tostring(reason)))
	if warn ~= true then
		print("  |cff8a8f98Nothing fired, and the reason above is why. That is the answer,|r")
		print("  |cff8a8f98not a failure — silence here is a decision, not a gap.|r")
		return
	end
	Check(true)
end

--- `/mh pet sounds` — play the alarm candidates so Rob can pick one.
---
--- 🔴 Rob, 7 Sep: *"kunnen we geen alarmgeluid zoals op een onderzeeboot die met spoed moet
--- duiken ofzo??"* Probably, but **I cannot hear anything**, so choosing one for him would be
--- picking a name off a list and calling it a decision. This plays them instead.
---
--- ⚠️ Each name is a CANDIDATE. A `SOUNDKIT` constant can simply not exist on a client, and
--- `PlaySound` can refuse to queue one — three different faults all end in silence, which is
--- why this prints what every step returned rather than what it was supposed to do. Same
--- reason `/mh zonegate test` exists in the shape it does.
---
--- 📌 Each one plays THREE times half a second apart, because that is what turns a single
--- game sound into something that reads as an alarm. If the winner still feels too polite,
--- the repeat count is the knob before the sound itself is.
local ALARM_CANDIDATES = {
	"ALARM_CLOCK_WARNING_1",
	"ALARM_CLOCK_WARNING_2",
	"ALARM_CLOCK_WARNING_3",
	"UI_RAID_BOSS_WHISPER_WARNING",
	"RAID_WARNING",
	"UI_SCENARIO_ENDING",
	"IG_QUEST_FAILED",
	"READY_CHECK", -- what it uses today, for comparison
}

function ns.PetTauntSoundGallery()
	local p = Prefix()
	print(p .. " alarm candidates — three plays each, one every 3 seconds.")
	print("  |cff8a8f98Say which NUMBER you want and it goes in. 'None of them' is also an|r")
	print("  |cff8a8f98answer — then we look for a different kit or play one more often.|r")
	if not (PlaySound and C_Timer and C_Timer.After) then
		print("  |cffff5555PlaySound or C_Timer is missing — nothing can be played here.|r")
		return
	end
	for i = 1, #ALARM_CANDIDATES do
		local name = ALARM_CANDIDATES[i]
		local id = SOUNDKIT and SOUNDKIT[name]
		C_Timer.After((i - 1) * 3, function()
			if not id then
				print(("  %2d. %-30s |cffff5555not on this client|r"):format(i, name))
				return
			end
			local ok, willPlay = pcall(PlaySound, id, "Master")
			print(("  %2d. %-30s id=%s  %s"):format(i, name, tostring(id),
				ok and ("willPlay=" .. tostring(willPlay)) or "|cffff5555errored|r"))
			-- The repeat is the point: one beep is a notification, three is an alarm.
			for r = 1, 2 do
				C_Timer.After(r * 0.5, function()
					pcall(PlaySound, id, "Master")
				end)
			end
		end)
	end
end

watcher:RegisterEvent("PLAYER_ENTERING_WORLD")
watcher:RegisterEvent("GROUP_ROSTER_UPDATE")
watcher:RegisterEvent("PET_BAR_UPDATE")
watcher:RegisterEvent("UNIT_PET")
watcher:SetScript("OnEvent", function()
	-- A tick of delay: on zone-in the pet bar is not populated yet, and asking too early
	-- reads an empty bar as "no taunt" -- silence that looks exactly like an all-clear.
	if C_Timer and C_Timer.After then
		C_Timer.After(2, function()
			pcall(Check)
		end)
	else
		pcall(Check)
	end
end)
