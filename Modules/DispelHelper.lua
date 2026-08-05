local _, ns = ...

--[[
	Midnight Helper — dispel helper, first slice.

	The pieces for this have been lying around for weeks and were never joined up:

	  ns.GetKnownClassDispels()  what THIS character can dispel, filtered on
	                             IsPlayerSpell so nothing is claimed for a spec
	                             that does not have it
	  ns.HEALER_DISPELS[spec]    the healing-spec variant, verified against JustAC
	  ns.Aura.ForEachPlayerDebuff  secret-safe reads through the 12.1 facade
	  DispelCapture.lua          already records which schools bosses actually use

	What was missing is the one sentence that matters in the moment: **you have
	something on you right now that you can remove yourself.**

	⚠️ YOUR OWN DEBUFFS ONLY. Another unit's auras can be secret in 12.x, so a
	party-wide helper would rest on something nobody has confirmed can be read.

	⚠️ AND YOUR OWN ARE NOT ALWAYS READABLE EITHER. This file was written on
	2026-07-27 claiming they were "fully readable, in every kind of content". That
	was wrong, and the measurement behind it was taken standing still. Measured on
	live 12.0.7 on 2026-07-28: `ShouldAurasBeSecret` is false out of combat and
	**true in combat**, with `Aura.Trusted()` flipping to false with it -- exactly
	the moment this feature is meant to speak.

	So the question is not "can we read auras" but "can we read them right now", and
	the answer is reported rather than assumed. Hidden debuffs are counted, and an
	unreadable scan says so instead of saying "clear".

	Never-lie throughout:
	  • A secret dispelName is skipped. Unreadable is not the same as absent, and
	    this never reports "nothing to dispel" -- it reports what it can see.
	  • Nothing is shown for a character with no dispel. GetKnownClassDispels
	    already returns empty there, and an alert you cannot act on is noise.
	  • The school comes from the game's own dispelName, never from a table of
	    spell ids we maintain.
]]

-- The API's English school string -> our canonical key. Same map DispelCapture
-- uses; kept local rather than shared because one file owning a two-line table is
-- cheaper than a dependency between them.
local SCHOOL = {
	Magic = "magic",
	Curse = "curse",
	Poison = "poison",
	Disease = "disease",
}

local function isSecret(v)
	return issecretvalue ~= nil and issecretvalue(v)
end

--- Every debuff school this character can actually remove from a friendly target.
--- Healing spec and non-healing spec both counted: a Prot Paladin dispels too,
--- which was Rob's point on 2026-07-15 and is why the toolkit shows it for
--- non-healers as well.
--- @return table set  { magic = true, poison = true, ... } (possibly empty)
--- @return table list { { id, types }, ... } the spells behind it
function ns.GetDispellableSchools()
	local set, spells = {}, {}

	local known = ns.GetKnownClassDispels and ns.GetKnownClassDispels()
	if type(known) == "table" then
		for _, d in ipairs(known) do
			spells[#spells + 1] = d
			for _, t in ipairs(d.types or {}) do
				set[t] = true
			end
		end
	end

	-- The healing-spec dispel, when this character is in that spec.
	if ns.HEALER_DISPELS and GetSpecialization and GetSpecializationInfo then
		local okIdx, idx = pcall(GetSpecialization)
		if okIdx and idx then
			local okID, specID = pcall(GetSpecializationInfo, idx)
			local d = okID and specID and ns.HEALER_DISPELS[specID]
			if d then
				-- Only if the character really has the spell. Same honesty bar as
				-- GetKnownClassDispels: a spec table is not proof of a spellbook.
				local known2 = true
				if IsPlayerSpell then
					local okS, res = pcall(IsPlayerSpell, d.id)
					known2 = (not okS) or res == true
				end
				if known2 then
					spells[#spells + 1] = d
					for _, t in ipairs(d.types or {}) do
						set[t] = true
					end
				end
			end
		end
	end

	return set, spells
end

--- Debuffs on YOU right now that YOU could dispel.
---
--- @return table found  { { name, school, spellID }, ... } — empty is "none seen",
---                      which is not the same as "none there"; see `readable`.
--- @return boolean readable  false when the answer cannot be trusted
--- @return number hidden  debuffs seen whose school could not be read
function ns.GetDispellableSelfDebuffs()
	local found, hidden = {}, 0
	local schools = ns.GetDispellableSchools()
	if not next(schools) then
		return found, true, 0 -- nothing this character can dispel: honestly empty
	end
	if not (ns.Aura and ns.Aura.ForEachPlayerDebuff) then
		return found, false, 0
	end

	local ok = ns.Aura.ForEachPlayerDebuff(function(aura)
		local dn = aura and aura.dispelName
		if dn == nil or isSecret(dn) then
			-- ⚠️ COUNT THESE. The first version just skipped them, and `readable`
			-- only reported whether the SCAN crashed -- Aura.Scan returns true even
			-- when every field it handed back was secret. So in combat this would
			-- have printed "nothing on you that you can dispel" while something was
			-- sitting on you: unreadable dressed up as absent, which is the one
			-- thing this file's own header forbids.
			--
			-- Measured on live 12.0.7, 2026-07-28: ShouldAurasBeSecret is false out
			-- of combat and TRUE in combat, so this is the normal case in a fight,
			-- not an edge case.
			if dn ~= nil then
				hidden = hidden + 1
			end
			return
		end
		local school = SCHOOL[dn]
		if not school or not schools[school] then
			return
		end
		local name = aura.name
		if isSecret(name) then
			name = nil
		end
		found[#found + 1] = {
			name = name,
			school = school,
			spellID = (not isSecret(aura.spellId)) and aura.spellId or nil,
		}
	end)

	-- Untrusted auras mean the answer is unknowable, not empty. Trusted() reads
	-- C_Secrets.ShouldAurasBeSecret, which flips at combat edges.
	local trusted = true
	if ns.Aura and ns.Aura.Trusted then
		trusted = ns.Aura.Trusted() and true or false
	end
	local readable = (ok and true or false) and trusted and hidden == 0
	return found, readable, hidden
end

--- /mh dispel — what can you remove from yourself right now?
function ns.PrintDispelStatus()
	local prefix = ("|cffffcc00%s|r"):format(ns.L and ns:L("PRINT_PREFIX") or "MH")
	local schools, spells = ns.GetDispellableSchools()

	if #spells == 0 then
		print(("%s %s"):format(prefix, ns:L("DISPEL_NONE_KNOWN")))
		return
	end

	local names = {}
	for _, d in ipairs(spells) do
		local n = ns.HealerCooldownSpellName and ns.HealerCooldownSpellName(d.id)
		names[#names + 1] = n or tostring(d.id)
	end
	local schoolList = {}
	for s in pairs(schools) do
		schoolList[#schoolList + 1] = s
	end
	table.sort(schoolList)
	print(("%s %s"):format(prefix, ns:L("DISPEL_HEADER")))
	print(("   %s: %s"):format(table.concat(names, ", "), table.concat(schoolList, ", ")))

	local found, readable, hidden = ns.GetDispellableSelfDebuffs()
	-- Anything readable is still worth showing, even when the rest is hidden.
	for _, d in ipairs(found) do
		print(("   |cffff8080%s|r  (%s)%s"):format(
			tostring(d.name or "?"), d.school,
			d.spellID and ("  spell " .. tostring(d.spellID)) or ""))
	end
	if not readable then
		-- The one thing this must never do is turn an unreadable scan into "clear".
		print("   " .. ns:L("DISPEL_UNREADABLE"))
		if hidden > 0 then
			print(("      %d debuff(s) hidden by combat secrecy"):format(hidden))
		end
		return
	end
	if #found == 0 then
		print("   " .. ns:L("DISPEL_CLEAR"))
	end
	return
end

--------------------------------------------------------------------------------
-- The live alert.
--
-- This deliberately does NOT register its own UNIT_AURA handler. AccessibleAlerts
-- already runs one, engine-filtered to the player, with a global cooldown and a
-- per-spell cooldown, reading through ns.Aura and skipping secret values. A second
-- handler on the same event would double the work every time an aura changes on
-- you, and would need its own copy of every one of those guards.
--
-- So this exposes a hook that the existing scan calls, and owns only two things:
-- its own on/off setting, and the decision of what counts as worth saying.
--
-- Separate setting on purpose. AccessibleAlerts is a beginner accessibility aid;
-- wanting "tell me when I can cleanse myself" is a different wish, and a raider
-- who wants the second should not have to switch on the first.
--------------------------------------------------------------------------------

local function AlertSettings()
	if not ns.db then
		return nil
	end
	ns.db.dispelAlert = ns.db.dispelAlert or {}
	local d = ns.db.dispelAlert
	if d.enabled == nil then
		d.enabled = false -- opt-in, like every other on-screen helper here
	end
	return d
end

--- @return boolean
function ns.DispelAlertEnabled()
	local d = AlertSettings()
	return (d and d.enabled) and true or false
end

--- @return boolean now
function ns.ToggleDispelAlert()
	local d = AlertSettings()
	if not d then
		return false
	end
	d.enabled = not d.enabled
	return d.enabled
end

--- Called by AccessibleAlerts for each readable debuff it scans.
---
--- Returns the line to show, or nil to stay quiet. Kept to a pure decision with no
--- side effects: the caller owns the cooldowns, the sound and the frame, so this
--- cannot accidentally alert twice or bypass a gap.
---
--- @param aura table  a debuff already checked for a readable spellId
--- @return string|nil message
function ns.GetDispelAlertFor(aura)
	if not ns.DispelAlertEnabled() then
		return nil
	end
	if type(aura) ~= "table" then
		return nil
	end
	local dn = aura.dispelName
	if dn == nil or isSecret(dn) then
		return nil -- unreadable: not "no school", just unknown
	end
	local school = SCHOOL[dn]
	if not school then
		return nil
	end
	local schools = ns.GetDispellableSchools()
	if not schools[school] then
		return nil -- something else's job, or nobody's
	end
	local name = aura.name
	if name == nil or isSecret(name) then
		name = nil
	end
	if name then
		return (ns:L("DISPEL_ALERT_FMT")):format(name)
	end
	-- The school alone is still actionable, and is better than inventing a name.
	return (ns:L("DISPEL_ALERT_SCHOOL_FMT")):format(ns:L("DISPEL_SCHOOL_" .. school:upper()))
end

--------------------------------------------------------------------------------
-- /mh dispel probe — is there a way around combat secrecy?
--
-- Measured 2026-07-28 in The Gulf of Memory: enumerating your own debuffs during
-- combat hands back a secret dispelName, so the helper above is blind in exactly
-- the moment it exists for.
--
-- But enumeration and lookup are different questions. Walking the list tells you
-- WHAT is on someone, which is the information the secrecy is there to withhold.
-- Asking "do I have spell 1270859" reveals nothing you did not already know to
-- ask, and Aura.GetPlayerAura takes that second path -- GetAuraDataBySpellID /
-- GetPlayerAuraBySpellID rather than the by-index scan.
--
-- Whether Blizzard actually allows it is not something to reason about. This
-- probe asks, using the spell ids DispelCapture has already recorded from real
-- play, and reports what came back. Run it in combat with a debuff on you.
--------------------------------------------------------------------------------

--- /mh dispel probe — try the lookup path against every recorded debuff id.
--------------------------------------------------------------------------------
-- Allies (2026-08-03) — the party-wide half this file said it could not have
--------------------------------------------------------------------------------

--- Does this ally carry something removable right now?
---
--- The header above says a party-wide helper "would rest on something nobody has
--- confirmed can be read". That was true when it was written and is not any more.
--- Measured in a dungeon on 3 Aug, six tallies of 36 scans:
---
---     player 36 hits · party3 36 · party4 28 · party2 11 · party1 0
---     zero errors, zero noUnit
---
--- It discriminates — party1 said no every time while party3 said yes every time,
--- in the same fights — which a broken, forbidden or secret filter could not do.
--- So `GetAuraSlots(unit, "HARMFUL|DISPELLABLE", 1)` answers, live, in combat.
---
--- Note what is NOT claimed: this returns whether a removable aura is present, not
--- what it is. The name and spellId of that aura stay secret and are never asked
--- for. "There is something on them" is the whole sentence, and it is enough —
--- you press your dispel, the game picks.
---
--- ⚠️ UNSETTLED: whether `DISPELLABLE` means "removable by YOU" or "removable at
--- all". SpellPilot reaches for the HELPFUL variant to catch enrages, which hints
--- at the second. Until that is measured, callers must gate on the player owning
--- a dispel at all, and must not promise the player can handle this particular
--- one.
function ns.AllyHasRemovableAura(unit)
	if not (unit and C_UnitAuras and C_UnitAuras.GetAuraSlots) then
		return nil
	end
	local uOk, exists = pcall(UnitExists, unit)
	if not uOk or exists ~= true then
		return nil
	end
	local ok, _, firstSlot = pcall(C_UnitAuras.GetAuraSlots, unit, "HARMFUL|DISPELLABLE", 1)
	if not ok then
		return nil -- unreadable is not "nothing there"
	end
	return firstSlot ~= nil
end

--------------------------------------------------------------------------------
-- Offensive purge — a DIFFERENT thing from everything above
--------------------------------------------------------------------------------

--- Taking a buff off an ENEMY, not a debuff off a friend.
---
--- Rob's action prompt showed nothing for a Shadow Priest and the reason was a
--- category error of mine: `NONHEALER_DISPELS.PRIEST` is Purify Disease, which is
--- a friendly dispel a Shadow Priest does not even have. What he was asking about
--- is Dispel Magic, the offensive purge — and this addon had no notion of that
--- concept anywhere.
---
--- ⚠️ PRIEST ONLY, deliberately. 528 is corroborated by SpellPilot's own class
--- table (`Classes/Removals.lua:28`, "Dispel Magic", Magic), and Rob can confirm
--- it in one pull because the icon either appears or does not. Every other class
--- with a purge — shaman, mage, hunter, evoker and the soothe/enrage cases — is
--- left out rather than guessed at. An invented spell ID shows the wrong icon and
--- teaches someone the wrong button, which is worse than showing nothing.
ns.OFFENSIVE_PURGES = {
	PRIEST = { id = 528, types = { "magic" } },
	-- Added 5 Aug: Rob switched to his Frost Mage to test the action prompt and the
	-- purge half could not have worked — a mage's offensive dispel is Spellsteal,
	-- and only Priest was listed. Three sources agree on 30449:
	-- JustAC/Data/SpellCategories.lua:514, SpellPilot/Classes/Removals.lua:25, and
	-- our own KeybindRoles_Mage.lua:99 ("offensieve dispel, steelt enemy-buff").
	MAGE = { id = 30449, types = { "magic" } },
}

local cachedPurgeIcon, cachedPurgeSpell, purgeResolved

--- @return string|nil texture, number|nil spellID
function ns.GetPlayerPurgeIcon()
	if purgeResolved then
		return cachedPurgeIcon, cachedPurgeSpell
	end
	purgeResolved = true
	if not UnitClass then
		return nil
	end
	local _, token = UnitClass("player")
	local entry = token and ns.OFFENSIVE_PURGES[token]
	if not entry then
		return nil
	end
	-- Same IsPlayerSpell gate the friendly dispels use: never claim a spell for a
	-- spec that does not have it.
	if IsPlayerSpell then
		local ok, has = pcall(IsPlayerSpell, entry.id)
		if ok and has ~= true then
			return nil
		end
	end
	if not (C_Spell and C_Spell.GetSpellTexture) then
		return nil
	end
	local ok, tex = pcall(C_Spell.GetSpellTexture, entry.id)
	if not ok or not tex then
		return nil
	end
	cachedPurgeIcon, cachedPurgeSpell = tex, entry.id
	return cachedPurgeIcon, cachedPurgeSpell
end

--- Spec changes can add or remove the purge, so the cache must not outlive one.
local purgeEv = CreateFrame("Frame")
purgeEv:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
purgeEv:RegisterEvent("PLAYER_ENTERING_WORLD")
purgeEv:SetScript("OnEvent", function()
	purgeResolved = false
	cachedPurgeIcon, cachedPurgeSpell = nil, nil
end)

--- The icon to show for it: the player's own dispel spell.
---
--- Better than a generic symbol, because it answers "what do I press" in the same
--- glance. Returns nil when this character has no dispel at all, which is also the
--- gate that keeps the indicator off a warrior's screen entirely.
local cachedDispelIcon, cachedDispelSpell
function ns.GetPlayerDispelIcon()
	if cachedDispelIcon ~= nil then
		return cachedDispelIcon, cachedDispelSpell
	end
	local _, spells = ns.GetDispellableSchools and ns.GetDispellableSchools()
	local first = type(spells) == "table" and spells[1] or nil
	if not (first and first.id and C_Spell and C_Spell.GetSpellTexture) then
		return nil
	end
	local ok, tex = pcall(C_Spell.GetSpellTexture, first.id)
	if not ok or not tex then
		return nil
	end
	cachedDispelIcon, cachedDispelSpell = tex, first.id
	return cachedDispelIcon, cachedDispelSpell
end

function ns.PrintDispelProbeSelf()
	local prefix = ("|cffffcc00%s|r"):format(ns.L and ns:L("PRINT_PREFIX") or "MH")
	local store = ns.db and ns.db.dispelCapture
	if type(store) ~= "table" or not next(store) then
		print(prefix .. " no captured debuffs yet -- run some content with DispelCapture on.")
		return
	end
	if not (ns.Aura and ns.Aura.GetPlayerAura) then
		print(prefix .. " aura facade not available.")
		return
	end

	local inCombat = InCombatLockdown and InCombatLockdown() or false
	local trusted = ns.Aura.Trusted and ns.Aura.Trusted() or false
	print(("%s dispel lookup probe -- in combat = %s, Trusted() = %s"):format(
		prefix, tostring(inCombat), tostring(trusted)))
	if not inCombat then
		print("   |cffe8c36aRun this DURING a fight|r -- out of combat proves nothing.")
	end

	local present, readable, blind = 0, 0, 0
	for _, entry in pairs(store) do
		local id = type(entry) == "table" and tonumber(entry.spellId) or nil
		if id then
			local data, ok = ns.Aura.GetPlayerAura(id)
			if not ok then
				blind = blind + 1
			else
				readable = readable + 1
				if data then
					present = present + 1
					local dn = data.dispelName
					print(("   |cff40c040FOUND|r %-8s %-28s school=%s"):format(
						tostring(id), tostring(entry.name or "?"),
						(dn ~= nil and not isSecret(dn)) and tostring(dn) or "SECRET"))
				end
			end
		end
	end
	print(("   looked up %d ids: %d answered, %d refused, %d currently on you"):format(
		readable + blind, readable, blind, present))
	print("   If something is on you and this found it, the lookup path works in combat")
	print("   and the helper can be rebuilt on it. If it found nothing, it cannot.")
end
