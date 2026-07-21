local _, ns = ...

--[[
	Midnight Helper — Adventure Guide side panel.

	MH's own boss coaching beside Blizzard's Encounter Journal, following whichever
	boss you have selected. Blizzard's journal explains the mechanics; this adds the
	part it never covers — what YOUR role should do about them.

	WHY THIS ONE IS HARDER than the other panels: it has to track the SELECTED
	encounter, not just the window opening. The shared helper's `watch` option does
	that with a ticker that only runs while the journal is visible.

	THE ID PROBLEM (the crux — read before changing anything):
	MH stores boss ids in two different numbering schemes.
	  • ns.DUNGEON_ROSTER carries `encounterID` (the Encounter Journal's own
	    numbering) and/or `dungeonEncounterID` (what ENCOUNTER_START sends).
	  • Some bosses have ONLY the second one — 14 of the roster's 57 boss rows at
	    the time of writing, including the whole Blinding Vale. Indexing just
	    `encounterID` would leave those permanently unmatched, and the panel would
	    stay blank for them with no error to explain why.
	Both fields are indexed, and EJ_GetEncounterInfo hands back both numbers, so a
	match never has to be guessed. Neither matches → show nothing, never a wrong boss.

	EJ_GetEncounterInfo's 7th return is the dungeonEncounterID. Verified against
	BossHelper/Core/EncounterIDLookup.lua:26, whose own comment reads "returværdi #7:
	dungeonEncounterID (samme ID som ENCOUNTER_END sender)".

	Deliberately NO name matching. Boss names are localised, so matching them would
	break on every non-English client — the exact bug that broke the Omnium Folio
	button, and the reason the track-ceiling code never compares track names either.
]]

local function GetJournalFrame()
	return EncounterJournal
end

--- The selected journal encounter id — also the watch token, so the panel rebuilds
--- when the player clicks a different boss.
local function SelectedJournalID()
	return EncounterJournal and EncounterJournal.encounterID
end

--- @return journalEncounterID|nil, dungeonEncounterID|nil
local function ReadSelectedEncounter()
	local jid = SelectedJournalID()
	if not jid then
		return nil, nil
	end
	if not EJ_GetEncounterInfo then
		return jid, nil
	end
	local ok, _, _, _, _, _, _, dungeonEncounterID = pcall(EJ_GetEncounterInfo, jid)
	if not ok then
		return jid, nil
	end
	return jid, dungeonEncounterID
end

--------------------------------------------------------------------------------
-- Index: encounter id (either scheme) -> MH boss entry
--------------------------------------------------------------------------------
local index

local function AddEntry(id, rec)
	if type(id) ~= "number" or id <= 0 then
		return
	end
	if index[id] == nil then
		index[id] = rec
	end
end

local function BuildIndex()
	if index then
		return index
	end
	index = {}
	-- Dungeons. Season gating lives in GetDungeonRoster, so use it rather than the
	-- raw table: a dungeon hidden for the current season should not match here either.
	for _, d in ipairs((ns.GetDungeonRoster and ns.GetDungeonRoster()) or {}) do
		for _, b in ipairs((d and d.bosses) or {}) do
			local rec = { dungeonKey = d.key, boss = b }
			AddEntry(b.encounterID, rec)
			AddEntry(b.dungeonEncounterID, rec) -- the 14 bosses that have only this
		end
	end
	-- Raids and custom entries. NOTE: pairs, not ipairs — CUSTOM_BOSS_ENTRIES is
	-- keyed by entry name (RaidCoachData.lua:117, DaggerspineCoach.lua:49), so
	-- ipairs would silently iterate nothing at all.
	for key, e in pairs(ns.CUSTOM_BOSS_ENTRIES or {}) do
		for _, b in ipairs((e and e.bosses) or {}) do
			local rec = { dungeonKey = key, boss = b, entry = e }
			AddEntry(b.encounterID, rec)
			AddEntry(b.dungeonEncounterID, rec)
		end
	end
	return index
end

local function FindBoss()
	local jid, did = ReadSelectedEncounter()
	local idx = BuildIndex()
	return (jid and idx[jid]) or (did and idx[did]) or nil
end

--------------------------------------------------------------------------------
-- Panel content
--------------------------------------------------------------------------------
--- The tip key for the player's current role, so the panel says something about
--- what THEY have to do rather than repeating the mechanics list next to it.
local function RoleTipKey(tips)
	if not tips then
		return nil
	end
	-- Same two-step detection DelveCuriosAdvisor already uses (GetPlayerRoleKey,
	-- DelveCuriosAdvisor.lua:40): the assigned group role first, falling back to the
	-- spec's own role when solo or unassigned. Reusing the proven order rather than
	-- inventing a second one.
	local role
	if UnitGroupRolesAssigned then
		local ok, r = pcall(UnitGroupRolesAssigned, "player")
		if ok then
			role = r
		end
	end
	if (not role or role == "NONE") and GetSpecialization and GetSpecializationRole then
		local spec = GetSpecialization()
		if spec then
			local okR, r = pcall(GetSpecializationRole, spec)
			if okR then
				role = r
			end
		end
	end
	if role == "TANK" then
		return tips.tank
	elseif role == "HEALER" then
		return tips.healer
	elseif role == "DAMAGER" then
		return tips.dps
	end
	return nil
end

local function BuildLines()
	local hit = FindBoss()
	if not hit or not hit.boss then
		return {}
	end
	local boss = hit.boss
	local tips = ns.GetDungeonBossTips and ns.GetDungeonBossTips(hit.dungeonKey, boss.key)
	local roleKey = RoleTipKey(tips)

	-- Nothing written for this boss yet: offering to open an empty guide helps
	-- nobody, so stay quiet instead.
	if not tips then
		return {}
	end

	local out = {}
	out[#out + 1] = { text = boss.name or "", color = "good" }
	if roleKey then
		out[#out + 1] = { text = ns:L(roleKey), color = "soft" }
	end
	out[#out + 1] = {
		text = ns:SafeL("EJPANEL_OPEN") or "",
		color = "dim",
		onClick = function()
			if hit.entry and ns.ShowBossWindowForEntry then
				pcall(ns.ShowBossWindowForEntry, hit.entry, boss.key)
			elseif ns.ShowDungeonBossWindow then
				pcall(ns.ShowDungeonBossWindow, hit.dungeonKey, boss.key)
			end
		end,
	}
	return out
end

local panel = ns.CreateSidePanel({
	name = "MidnightHelperEncounterJournalPanel",
	titleKey = "EJPANEL_TITLE",
	width = 280,
})

ns.AttachSidePanel({
	panel = panel,
	getFrame = GetJournalFrame,
	addon = "Blizzard_EncounterJournal",
	buildLines = BuildLines,
	watch = SelectedJournalID, -- rebuild when another boss is selected
	watchInterval = 0.3,
})
