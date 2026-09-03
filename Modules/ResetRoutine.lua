--[[
	Reset Routine — "what do I do after the weekly reset, in which order?"
	Pure logic for the Home dashboard block: an ordered, per-character list of
	claim/pick-up steps with live status, plus a TomTom route along the stops
	that are still open (vault -> Bazaar hub -> Work Order station).

	never-lie rules:
	  - Every step states only what a real signal confirms (live vault API,
	    quest flags/log, GetRitualWeeklyHint states). Steps whose state cannot
	    be read are omitted entirely instead of guessed.
	  - Trainer weeklies only appear for owned professions whose weekly quest
	    ID is in-game verified (ns.PROF_ACADEMY.weekly.trainerQuests).
	  - The Great Vault chest coordinate (Silvermoon bank, neutral wing) is
	    the same one the VaultReminder popup waypoint already uses in-game.

	Public API:
	  ns.GetResetRoutineSteps() -> array of { text, color, onClick } where
	    color is "good" | "warn" | "soft" | "dim" (Home maps these to its own
	    palette). Steps are pre-ordered; Home prefixes "1." etc.
	  ns.StartResetRoute() -> clears TomTom and queues pins for the OPEN stops
	    in order; only pin 1 gets the crazy arrow + travel UI (Rares pattern),
	    and ns.lastTarget is pointed back at pin 1 so the shared zone-change
	    re-assert restores the right arrow (see the 9 Jun treasure-arrow saga).
]]

local _, ns = ...

-- Shared Void Assaults / Ritual Sites hub, 2nd floor of The Bazaar (Lilatha).
local HUB_MAP, HUB_X, HUB_Y = 2393, 48.2, 49.6
-- Great Vault chest: Silvermoon bank, neutral wing. Same coordinate as the
-- VaultReminder popup waypoint (GREAT_VAULT_* in VaultReminder.lua) — keep in
-- sync; backlog: centralize into one ns-level constant.
local VAULT_MAP, VAULT_X, VAULT_Y = 2393, 50.36, 65.19
-- Work Order station fallback (ns.PROF_ACADEMY.workOrderStation wins).
local STATION_MAP, STATION_X, STATION_Y = 2393, 45.0, 55.6
-- Weekly quest givers next to the vault — same spot as the city-guide
-- "weekly_hub" pin (UI.lua SMC_CATEGORIES).
local GIVERS_MAP, GIVERS_X, GIVERS_Y = 2393, 48.95, 64.92

-- Stops you've already visited this route (coordKey -> true). Once you've been at a
-- stop for a few seconds (or accepted a quest there), it's excluded from the route so
-- the arrow tours every stop once and never sticks/ping-pongs on one you don't finish
-- right now (Halduron's rotating weekly, a ritual intro you skip, an empty trainer…).
-- The step still shows in the checklist with its real status — this only affects the
-- arrow, and never claims anything is "done".
local visited = {}
local dwellKey, dwellTicks = nil, 0
--- A single "take me there" pin (one step's button, not the whole route).
--- Tracked so the arrow can clear itself once you are standing on it: the dwell
--- ticker below only ran while a FULL route was active, so a single pin stayed on
--- screen forever — Rob had one spinning at 0m for ten minutes (2026-07-22).
local singleTarget
--- Forward declaration: RouteSingle needs to start the ticker, and the ticker is
--- defined much further down. Declaring the local here keeps it in scope without
--- the call resolving to a global nil.
local StartDwellTicker
local function CoordKey(mapID, x, y)
	return tostring(mapID) .. ":" .. tostring(x) .. ":" .. tostring(y)
end

-- Per-giver weekly definitions. Fill ONLY in-game-verified data (dump
-- instructions in TOMORROW.md). Semantics once filled:
--   done   — any listed quest flagged completed (weekly flag = "this week")
--   inlog  — any listed quest in the quest log ("picked up")
--   locked — verified minLevel known and the character is below it
--   pickup — none of the above (eligible, go grab it)
-- quests = {} (no verified IDs) -> NO status claim is made for that giver;
-- minLevel = nil -> no eligibility claim is made (never lie).
-- Liadrin's choice-of-four (one Spark weekly per week, "any" semantics) —
-- Wowhead-verified 10 Jun 2026, in-game confirmation via Rob's dump pending:
--   93766 Midnight: World Quests · 93909 Midnight: Delves ·
--   93910 Midnight: Prey · 93911 Midnight: Dungeons
-- (all "level 90 meta quest" on Wowhead = quest level, NOT the requirement —
-- minLevel stays nil until the real requirement is confirmed in-game).
-- Halduron: rep-dungeon weekly — a DIFFERENT dungeon (= different quest ID)
-- each week. Old weekly flags reset at the weekly reset, so "any" semantics
-- stays correct; add each newly-dumped week's ID to the list.
--   93761 "Windrunner Spire" (Rob in-game, week of 10 Jun 2026)
-- Aethas: weekend/event weeklies (can offer more than one at once; "any"
-- = done as soon as one is turned in — good enough for the routine):
--   93600 "The Arena Calls" + 94836 "Late Night Training: Week 1 of 3"
--   (Rob in-game, 10 Jun 2026; future events will add IDs here).
-- minLevel: Robs level-80-test (11 jun, verse warlock) — Liadrin en Aethas
-- bieden op 80 NIETS aan; hun Spark-/event-weeklies zijn endgame-content,
-- dus aanname max level 90 (gedocumenteerde aanname: 81-89 niet apart
-- getest). Halduron biedt op 80 wél een quest aan — een LEVELING-variant
-- ("Hope in the Darkest Corners", XP + Quel'Thalas Adventurer's Cache) —
-- dus géén minLevel daar; dat quest-ID toevoegen zodra gedumpt, dan krijgen
-- levelaars ook echte done/opgepakt-status bij hem.
local GIVER_WEEKLIES = {
	-- Liadrin offers FOUR of a twelve-quest pool per character per week, so a list of
	-- four could only ever recognise a third of what she hands out. Rob picked
	-- "Midnight: World Boss" (93913) and the routine kept telling him to go and get a
	-- quest that was already in his log.
	--
	-- All eleven below were confirmed on 2026-07-22 via /mh weeklies, which asks the
	-- game for each id's own title and compares it with the label.
	--
	-- 93891 "Legends of the Haranir" was left out because it returned NO TITLE, which
	-- we read as the game agreeing it was obsolete. That reasoning is WRONG and the
	-- id is back in. On 29 jul the same probe returned no title for 96713 "Showdown on
	-- Val" — an id Rob confirmed himself in June by accepting the quest. A missing
	-- title means the client has not cached that quest, not that it does not exist.
	--
	-- The costs are not symmetric either. A dead id in this list matches nothing and
	-- does nothing; a missing one produces exactly the bug this list exists to stop,
	-- where MH tells you to go and pick up a quest already in your log. So when in
	-- doubt, keep it.
	--
	-- 95843 "Midnight: Ritual Sites" was measured on 29 jul: Rob picked it, the probe
	-- reported NOT IN OUR DATA, and the game gave its title. The pool is therefore
	-- bigger than the twelve we were told about, so expect more of these — /mh
	-- weeklies now names any unknown one instead of quietly showing an empty pool.
	{ key = "liadrin", name = "Lady Liadrin", minLevel = 90, quests = {
		93766, -- World Quests
		93769, -- Housing
		93889, -- Saltheril's Soiree
		93890, -- Abundance
		93891, -- Legends of the Haranir (no title from the client; see above)
		93892, -- Stormarion Assault
		93909, -- Delves
		93910, -- Prey
		93911, -- Dungeons
		93913, -- World Boss
		94457, -- Battlegrounds
		95842, -- Void Assaults (also the Void meta quest below)
		95843, -- Ritual Sites (Rob's pick, measured 29 jul 2026)
	} },
	-- Dungeon-of-the-week (rotates; add each week's confirmed ID here):
	--   93761 "Windrunner Spire" (10 jun 2026), 93164 "Maisara Caverns"
	--   (1 jul 2026, Rob confirmed via /mh questscan — dungeon rep-weekly). 95468 =
	--   "Hope in the Darkest Corners", the leveling variant Halduron offers sub-90
	--   (Rob's level-80-warlock, 11 jun). "any" covers all audiences.
	{ key = "halduron", name = "Halduron Brightwing", quests = { 93761, 93164, 95468 }, minLevel = nil },
	{ key = "aethas", name = "Aethas Sunreaver", quests = { 93600, 94836 }, minLevel = 90 },
	-- Showdown weekly, from Riftblade Maella in the active Void world. MH already
	-- had both zone ids (ShowdownsData.lua, Rob verified 96713 in-game on 16 jun)
	-- but only used them in the Void & Rituals tab and the account snapshot -- never
	-- in the reset routine, so the weekly people actually read never mentioned it
	-- (Rob, 2026-07-22).
	--
	-- Only one zone is active per week, and listing both is harmless: the routine
	-- asks whether ANY of a giver's quests is on the player or done.
	--
	-- The HEROIC variants are SEPARATE quests, and missing them was a real bug: Rob
	-- accepted "Showdown on Naigtal (Heroic)" and this step went on telling him to go
	-- and get it. Naigtal heroic = 96718, measured from his log on 29 jul via
	-- /mh showdown. Val heroic 96714 comes from Broker_MidnightEvents and is NOT
	-- verified -- 96713 -> 96714 mirrors Naigtal's 96717 -> 96718, but Val is exactly
	-- where a datamined guess already failed once (96716 vs the real 96713).
	--
	-- An earlier note here said 96714 must be removed if /mh weeklies reports no title
	-- for it. Do NOT follow that rule: it is disproven. On 29 jul the probe returned
	-- no title for 96713 as well, and Rob accepted that quest himself in June. No
	-- title means the client has not cached the quest, not that it does not exist.
	--
	-- minLevel 90 is an ASSUMPTION, same as Liadrin's and Aethas's: this is endgame
	-- Void-world content and sub-90 access was never tested. Correct it if a levelling
	-- character is offered one.
	-- ⚠️ Maella is NOT in Silvermoon. Rob went looking for her there on 29 jul and
	-- found nothing, because the step is named after her while the pin points at the
	-- portal. She stands on the outpost inside the active Void world -- verified on
	-- Val (2599, 59.56/19.33, ShowdownsData.valOutpostNpc). Her Naigtal position has
	-- never been captured, so the text says "through the portal" rather than naming a
	-- spot we cannot point to.
	--
	-- ⚠️ noNameMatch: a SECOND NPC called "Riftblade Maella" stands in Silvermoon at
	-- 27.48/76.51 and runs the Decor Duels housing minigame -- same name, different
	-- NPC (ShowdownsData.lua, Rob on the PTR 16 jun). Name matching would file her
	-- housing quests as Showdown weeklies, so this giver is matched by quest id and
	-- learned NPC id only. Both are exact; the name is the one that lies here.
	{
		key = "maella",
		name = "Riftblade Maella",
		-- Val 96713 + Naigtal 96717 (normal), Naigtal 96718 (heroic, measured from
		-- Rob's log), Val 96714 (heroic, datamined and still unverified). Listing all
		-- four is safe: the routine asks whether ANY of them is on the player or done,
		-- and only one world is active per week.
		quests = { 96713, 96717, 96718, 96714 },
		minLevel = 90,
		noNameMatch = true,
		pickupKey = "HOME_ROUTINE_GIVER_PICKUP_SHOWDOWN_FMT",
		pin = { 2393, 47.93, 48.09, "HOME_ROUTINE_PIN_SHOWDOWN" },
		-- Shares the Showdowns section's own gate rather than repeating its reasoning, so
		-- the two can never disagree again. See the note in GiverState.
		available = function()
			return not (ns.IsShowdownsAvailable and not ns.IsShowdownsAvailable())
		end,
	},
}

local VOID_META_QUEST = 95842 -- "Midnight: Void Assaults"
local VOID_ZONE_WEEKLIES = { 94385, 94386 } -- Eversong / Zul'Aman zone weeklies

-- Profession trainer locations (map 2393), keyed by base skillLine — the
-- trainer weekly is picked up at the TRAINER, not the Work Order station.
-- Coordinates mirror the in-game-verified SMC city-guide pins (UI.lua
-- SMC_CATEGORIES); skillLine IDs match ProfessionAcademyData chapters.
local TRAINER_PINS = {
	[171] = { 47.02, 51.88 }, -- Alchemy
	[164] = { 43.74, 51.33 }, -- Blacksmithing
	[333] = { 47.97, 53.63 }, -- Enchanting (Dolothos)
	[202] = { 43.53, 54.01 }, -- Engineering
	[773] = { 46.78, 51.48 }, -- Inscription
	[755] = { 47.93, 55.15 }, -- Jewelcrafting
	[165] = { 43.15, 55.70 }, -- Leatherworking
	[197] = { 48.25, 54.15 }, -- Tailoring
	[182] = { 48.20, 51.52 }, -- Herbalism
	[186] = { 42.68, 52.84 }, -- Mining
	[393] = { 43.27, 55.59 }, -- Skinning
}

--------------------------------------------------------------------------------
-- Signal helpers (all pcall-guarded)
--------------------------------------------------------------------------------

local function Flagged(qid)
	if not (C_QuestLog and C_QuestLog.IsQuestFlaggedCompleted and qid) then
		return false
	end
	local ok, done = pcall(C_QuestLog.IsQuestFlaggedCompleted, qid)
	return ok and done or false
end

local function OnQuest(qid)
	if not (C_QuestLog and C_QuestLog.IsOnQuest and qid) then
		return false
	end
	local ok, has = pcall(C_QuestLog.IsOnQuest, qid)
	return ok and has or false
end

-- true / false / nil (API unavailable -> step omitted, never guessed).
local function VaultReady()
	if C_WeeklyRewards and C_WeeklyRewards.HasAvailableRewards then
		local ok, ready = pcall(C_WeeklyRewards.HasAvailableRewards)
		if ok then
			return ready and true or false
		end
	end
	return nil
end

--- Is the player at this expansion's max level? Ritual Sites and Void Assaults offer a
--- "pick it up" step at ANY level, so without this gate the Home headline would send a
--- level-40 character straight at endgame content. Those steps still appear in the full
--- checklist below the headline — they just never become the headline itself.
local function AtMaxLevel()
	local cap
	if ns.GetDelveCapLevel then
		local ok, lvl = pcall(ns.GetDelveCapLevel)
		if ok then
			cap = tonumber(lvl)
		end
	end
	if (not cap or cap <= 0) and GetMaxLevelForPlayerExpansion then
		local ok, lvl = pcall(GetMaxLevelForPlayerExpansion)
		if ok then
			cap = tonumber(lvl)
		end
	end
	if not cap or cap <= 0 then
		return true -- cap unknown: never hide a real action on a guess
	end
	return ((UnitLevel and UnitLevel("player")) or 0) >= cap
end

--- 🔴 CAN THIS CHARACTER ACT ON A STEP WITH THIS LEVEL REQUIREMENT?
---
--- Rob, 3 Sep 2026, on a level-68 Paladin: "onze MH laat dingen zien die we nog helemaal
--- niet kunnen doen". He was right, and the cause was one operator. `GetNextWeeklyAction`
--- promoted the first step where `s.heroEligible ~= false` -- eligible unless it says no --
--- and only two of the eleven step constructors in this file ever said no. So a weekly
--- giver became the Home headline with a "Take me there" button on a level 68.
---
--- 📌 THE DISTINCTION THAT MATTERS, and it is the whole design: presence is a MAP, the
--- headline and its route button are a RECOMMENDATION. Showing an endgame weekly in the
--- list teaches a levelling player what the week looks like. Recommending it spends their
--- actual flight time on a quest giver with nothing to offer -- and, per CLAUDE.md, leaves
--- them unable to tell a wrong addon from their own mistake.
---
--- ⚠️ A nil minLevel does NOT mean "any level". It means NOBODY MEASURED IT. Halduron
--- carries `minLevel = nil` deliberately (see the note at GIVER_WEEKLIES) because a
--- level-80 warlock was offered his levelling variant 95468 on 11 Jun -- but level 68 was
--- never tested, and two of his three quests are max-level dungeon weeklies. So at max
--- level an unmeasured requirement is harmless, and below it costs the headline and keeps
--- the row. Unknown should lose you the recommendation, never the information.
local function CanActAt(minLevel)
	if minLevel then
		local ok, lvl = pcall(UnitLevel, "player")
		return ((ok and tonumber(lvl)) or 0) >= minLevel
	end
	return AtMaxLevel()
end

-- "done" | "inlog" | "pickup" | "intro" | nil (unknowable)
local function RitualState()
	if ns.IsRitualWeeklyDone and ns.IsRitualWeeklyDone() then
		return "done"
	end
	if ns.GetRitualWeeklyHint then
		local _, kind = ns.GetRitualWeeklyHint()
		if kind == "inprogress" then
			return "inlog"
		elseif kind == "pickup" then
			return "pickup"
		elseif kind == "intro" or kind == "locked" then
			return "intro"
		end
	end
	return nil
end

-- "done" | "inlog" | "pickup"
local function VoidState()
	if ns.IsVoidAssaultWeeklyDone and ns.IsVoidAssaultWeeklyDone() then
		return "done"
	end
	if OnQuest(VOID_META_QUEST) then
		return "inlog"
	end
	for _, qid in ipairs(VOID_ZONE_WEEKLIES) do
		if OnQuest(qid) then
			return "inlog"
		end
	end
	return "pickup"
end

-- Owned primary professions, split into trainer weeklies with a verified
-- quest ID (tracked) and owned profs without one (untracked names — shown as
-- an honest "not tracked yet" line instead of silently disappearing).
local function OwnedProfTrainerWeeklies()
	local tracked, untracked = {}, {}
	if not GetProfessions or not GetProfessionInfo then
		return tracked, untracked
	end
	local quests = ns.PROF_ACADEMY and ns.PROF_ACADEMY.weekly and ns.PROF_ACADEMY.weekly.trainerQuests
	if type(quests) ~= "table" then
		quests = {}
	end
	local okP, p1, p2 = pcall(GetProfessions)
	if not okP then
		return tracked, untracked
	end
	local slots = {}
	if p1 then
		slots[#slots + 1] = p1
	end
	if p2 then
		slots[#slots + 1] = p2
	end
	for _, slot in ipairs(slots) do
		local ok, name, _, skillLevel, _, _, _, skillLine = pcall(GetProfessionInfo, slot)
		if ok and skillLine then
			local q = quests[skillLine]
			if type(q) == "number" then
				q = { q } -- backward compat with the old single-ID form
			end
			if type(q) == "table" and #q > 0 then
				tracked[#tracked + 1] = {
					name = name or "?",
					quests = q,
					skillLine = skillLine,
					skill = math.floor(tonumber(skillLevel) or 0),
				}
			else
				untracked[#untracked + 1] = name or "?"
			end
		end
	end
	return tracked, untracked
end

--------------------------------------------------------------------------------
-- Auto-learn giver weeklies (self-healing; no hand-maintained IDs).
-- When you accept a quest from a giver NPC we remember it under that giver in
-- SavedVars, so a rotating weekly (Halduron's dungeon-of-the-week) is tracked from
-- then on without us ever adding IDs. Per account; the moment you pick it up MH
-- learns it, so the status is never wrong. The giver is identified from a quest we
-- already know (static or learned) or from the NPC we've mapped before, with a
-- locale-name fallback the first time. See the learn frame at the bottom of the file.
--------------------------------------------------------------------------------
local pendingNpcID, pendingNpcName

local function LearnStore()
	MidnightHelperDB = MidnightHelperDB or {}
	local s = MidnightHelperDB.giverLearn
	if type(s) ~= "table" then
		s = {}
		MidnightHelperDB.giverLearn = s
	end
	s.npc = s.npc or {} -- npcID -> giverKey
	s.quests = s.quests or {} -- giverKey -> { [questID] = true }
	return s
end

local function NpcIDFromGUID(guid)
	if type(guid) ~= "string" then
		return nil
	end
	-- WoW 12.x: NPC-GUID's kunnen "secret" zijn → een secret string indexeren/parsen (guid:match)
	-- tainted de uitvoering en crasht ("attempt to index local 'guid' (a secret string value)").
	-- Guard: bij een secret GUID geen ID teruggeven; LearnGiverQuest valt dan terug op de NPC-naam
	-- (GiverKeyByName). issecretvalue is veilig aan te roepen op elke waarde (ook secret/nil).
	if issecretvalue and issecretvalue(guid) then
		return nil
	end
	local id = guid:match("^Creature%-%d+%-%d+%-%d+%-%d+%-(%d+)%-")
	return id and tonumber(id) or nil
end

-- The giver that already owns a quest id (static def OR learned), or nil.
local function GiverKeyForQuest(questID)
	for _, def in ipairs(GIVER_WEEKLIES) do
		for _, qid in ipairs(def.quests) do
			if qid == questID then
				return def.key
			end
		end
	end
	for key, set in pairs(LearnStore().quests) do
		if set[questID] then
			return key
		end
	end
	return nil
end

local function GiverKeyByName(name)
	if not name then
		return nil
	end
	-- 12.x: UnitName van een quest-NPC kan secret zijn → een secret string vergelijken tainted/crasht
	-- ("attempt to compare a secret string value"). Guard: secret naam → niet vergelijken (geen naam-
	-- attributie). Getrackte givers werken nog via questID (GiverKeyForQuest), dus never-lie blijft heel.
	if issecretvalue and issecretvalue(name) then
		return nil
	end
	for _, def in ipairs(GIVER_WEEKLIES) do
		-- Skip givers whose name is shared with an unrelated NPC (see noNameMatch).
		-- Matching those on name would attribute the wrong quests, and a confidently
		-- wrong attribution is worse than no attribution at all.
		if def.name == name and not def.noNameMatch then
			return def.key
		end
	end
	return nil
end

-- Called on QUEST_ACCEPTED: attribute the quest to a giver and remember it.
local function LearnGiverQuest(questID)
	questID = tonumber(questID)
	-- Consume the pending NPC (set on the preceding QUEST_DETAIL) so a later
	-- auto-accepted quest can't reuse a stale giver and mis-attribute.
	local npcID, npcName = pendingNpcID, pendingNpcName
	pendingNpcID, pendingNpcName = nil, nil
	if not questID then
		return
	end
	local s = LearnStore()
	local key = GiverKeyForQuest(questID)
	if not key and npcID then
		key = s.npc[npcID]
	end
	if not key then
		key = GiverKeyByName(npcName)
	end
	if not key then
		return -- can't attribute confidently — never guess (never-lie)
	end
	if npcID then
		s.npc[npcID] = key -- learn NPC -> giver for future rotations
	end
	s.quests[key] = s.quests[key] or {}
	s.quests[key][questID] = true
end

-- All quest IDs for a giver: static def + anything we've learned.
local function GiverAllQuestIDs(def)
	local ids = {}
	for _, qid in ipairs(def.quests) do
		ids[#ids + 1] = qid
	end
	local learned = LearnStore().quests[def.key]
	if learned then
		for qid in pairs(learned) do
			ids[#ids + 1] = qid
		end
	end
	return ids
end

--- Is this quest finished and waiting to be handed in?
---
--- 🔴 THE WHOLE ROUTINE LOST ITS ARROW THE MOMENT YOU PICKED A QUEST UP, and Rob
--- reported it on 2 sep 2026: "ik heb een quest opgehaald en die moet ik weer
--- inleveren, maar ik krijg nu geen pijl (als ik de questgiver weer aanklik)."
---
--- The cause is one line below: "inlog" produced a step with no `pin`, no `open`
--- and no `onClick`, so `ComputeOpenPins` dropped that stop and the line went dead
--- to the click. Picking a quest up made the addon stop helping with it — at
--- exactly the point the player has committed to it. Four lines in his screenshot
--- were in that state at once.
---
--- ⚠️ BUT "IN MY LOG" IS NOT "READY TO HAND IN", and routing on the first would be
--- the confident wrong answer this file already warns about twice: it would send
--- you to stand in front of an NPC with nothing to say, while the objective is out
--- in the world. So the giver is only routed to once the client says the quest is
--- actually complete.
local function ReadyToHandIn(qid)
	if not (C_QuestLog and C_QuestLog.ReadyForTurnIn) then
		return false
	end
	local ok, ready = pcall(C_QuestLog.ReadyForTurnIn, qid)
	return (ok and ready) and true or false
end

-- "done" | "turnin" | "inlog" | "locked" | "pickup" | nil (no known IDs -> no claim)
local function GiverState(def)
	local ids = GiverAllQuestIDs(def)
	if #ids == 0 then
		return nil
	end
	for _, qid in ipairs(ids) do
		if Flagged(qid) then
			return "done"
		end
	end
	-- Ready-to-hand-in beats merely-in-log: if any of this giver's quests is
	-- finished, the giver is a stop again.
	for _, qid in ipairs(ids) do
		if OnQuest(qid) and ReadyToHandIn(qid) then
			return "turnin"
		end
	end
	for _, qid in ipairs(ids) do
		if OnQuest(qid) then
			return "inlog"
		end
	end
	if def.minLevel and UnitLevel then
		local ok, lvl = pcall(UnitLevel, "player")
		if ok and tonumber(lvl) and lvl < def.minLevel then
			return "locked"
		end
	end

	--- ⚠️ "NOT DONE YET" IS NOT THE SAME AS "STILL AVAILABLE", and this function assumed it
	--- was. Everything above answers from the player's own log; nothing asked whether the
	--- quest can still be picked up at all.
	---
	--- Found by the stale-advice audit on 19 aug: `Showdowns.lua` quotes Blizzard's hotfix
	--- verbatim — "The Naigtal and Val Sparks of War quests will no longer be offered when
	--- Season 2 begins" — and hides its own section accordingly, while this routine kept
	--- posting Riftblade Maella as an open to-do with a waypoint, on every level-90
	--- character, every week. One addon, two answers, and the one people actually read was
	--- the wrong one. It also costs a portal trip rather than merely misinforming.
	---
	--- The gate is `IsShowdownsAvailable` itself rather than a copy of its reasoning, so
	--- the two cannot drift apart again. Note the ordering matters: a weekly already in
	--- your log returns "inlog" above and never reaches here, which is deliberate — the
	--- hotfix stops NEW offers and takes nothing off the list of someone already holding
	--- one.
	---
	--- ⚠️ ITS OWN ANSWER, NOT nil. nil already means "we do not know this giver's quest
	--- ids", and the caller turns that into a generic "go look at the quest givers" line
	--- with a route pin. Reusing it here would swap a specific wrong nudge for a vague one
	--- and still walk the player to Silvermoon. "locked" is wrong too — that claims a
	--- requirement you could go and meet.
	if def.available and not def.available() then
		return "unavailable"
	end
	return "pickup"
end

local function StationCoords()
	local st = ns.PROF_ACADEMY and ns.PROF_ACADEMY.workOrderStation
	if type(st) == "table" and st.mapID and st.x and st.y then
		return st.mapID, st.x, st.y
	end
	return STATION_MAP, STATION_X, STATION_Y
end

--------------------------------------------------------------------------------
-- Routing
--------------------------------------------------------------------------------

local function ClearTomTom()
	ns.MH_TomTomClearAll()
end

local function PinLabel(labelKey, labelArg)
	local label = ns:L(labelKey)
	if labelArg then
		label = label:format(labelArg)
	end
	return label
end

local function RouteSingle(mapID, x, y, labelKey, labelArg)
	if not ns.AddSmartTomTomWay then
		return
	end
	ClearTomTom()
	ns.AddSmartTomTomWay(mapID, x, y, PinLabel(labelKey, labelArg))
	-- Remember where we sent them, so the arrow can retire once they arrive.
	singleTarget = { mapID, x, y }
	dwellKey, dwellTicks = nil, 0
	if StartDwellTicker then
		StartDwellTicker()
	end
end

--------------------------------------------------------------------------------
-- Public API
--------------------------------------------------------------------------------

function ns.GetResetRoutineSteps()
	local steps = {}

	-- 1. Great Vault (claim before anything else).
	local ready = VaultReady()
	if ready == true then
		steps[#steps + 1] = {
			text = ns:L("HOME_ROUTINE_VAULT_READY"),
			color = "warn",
			open = true,
			-- Rewards are already sitting in the vault: whatever level this character is,
			-- walking over and taking them is a real action.
			heroEligible = true,
			pin = { VAULT_MAP, VAULT_X, VAULT_Y, "HOME_ROUTINE_PIN_VAULT" },
			onClick = function()
				RouteSingle(VAULT_MAP, VAULT_X, VAULT_Y, "HOME_ROUTINE_PIN_VAULT")
			end,
		}
	elseif ready == false then
		steps[#steps + 1] = { text = ns:L("HOME_ROUTINE_VAULT_NONE"), color = "good" }
	end

	-- 2. Weekly quest givers next to the vault. Givers with verified quest IDs
	-- get a real done / picked-up / locked / pickup status; givers without
	-- collapse into one honest "not tracked yet" reminder line + waypoint.
	local giversRoute = function()
		RouteSingle(GIVERS_MAP, GIVERS_X, GIVERS_Y, "HOME_ROUTINE_PIN_GIVERS")
	end
	local untrackedGivers, anyGiverOpen = false, false
	for _, def in ipairs(GIVER_WEEKLIES) do
		local gs = GiverState(def)
		if gs == "done" then
			steps[#steps + 1] = { text = ns:L("HOME_ROUTINE_GIVER_DONE_FMT"):format(def.name), color = "good" }
		elseif gs == "turnin" then
			-- Finished, waiting at the giver: a real stop again, with the same pin the
			-- pickup used. The giver has not moved -- only our reason to walk there has.
			anyGiverOpen = true
			local pin = def.pin or { GIVERS_MAP, GIVERS_X, GIVERS_Y, "HOME_ROUTINE_PIN_GIVERS" }
			steps[#steps + 1] = {
				text = ns:L("HOME_ROUTINE_GIVER_TURNIN_FMT"):format(def.name),
				color = "warn",
				open = true,
				-- The quest is in this character's log and finished. Whatever the level
				-- requirement was, they already met it -- handing in is always actionable.
				heroEligible = true,
				pin = pin,
				onClick = def.pin and function()
					RouteSingle(pin[1], pin[2], pin[3], pin[4])
				end or giversRoute,
			}
		elseif gs == "inlog" then
			-- Deliberately not routed: the work is out in the world, not at the giver.
			-- Clicking still routes you there, because a player who wants to look at the
			-- quest giver should not be told no -- it just is not an open stop.
			local pin = def.pin or { GIVERS_MAP, GIVERS_X, GIVERS_Y, "HOME_ROUTINE_PIN_GIVERS" }
			steps[#steps + 1] = {
				text = ns:L("HOME_ROUTINE_GIVER_INLOG_FMT"):format(def.name),
				color = "prog",
				onClick = def.pin and function()
					RouteSingle(pin[1], pin[2], pin[3], pin[4])
				end or giversRoute,
			}
		elseif gs == "locked" then
			steps[#steps + 1] = {
				text = ns:L("HOME_ROUTINE_GIVER_LOCKED_FMT"):format(def.name, def.minLevel),
				color = "dim",
			}
		elseif gs == "pickup" then
			anyGiverOpen = true
			-- Most givers share the Silvermoon hub next to the vault, so that wording
			-- and pin are the default. A giver who stands somewhere else carries its
			-- own -- sending someone to the vault for a quest in the Void world would
			-- be a confident wrong answer.
			local pin = def.pin or { GIVERS_MAP, GIVERS_X, GIVERS_Y, "HOME_ROUTINE_PIN_GIVERS" }
			steps[#steps + 1] = {
				text = ns:L(def.pickupKey or "HOME_ROUTINE_GIVER_PICKUP_FMT"):format(def.name),
				color = "warn",
				open = true, -- routing exclusion after you've visited is handled generically
				-- This is the line that put Halduron in a level 68's headline. A giver with
				-- no measured minLevel is not "fine at any level", it is unmeasured.
				heroEligible = CanActAt(def.minLevel),
				pin = pin,
				onClick = def.pin and function()
					RouteSingle(pin[1], pin[2], pin[3], pin[4])
				end or giversRoute,
			}
		elseif gs == "unavailable" then
			-- Deliberately silent. The quest cannot be picked up any more, so there is
			-- nothing to do and nothing to route to — and saying "nothing to do here" for
			-- content that has ended is just another line to read past.
		else
			untrackedGivers = true
		end
	end
	if untrackedGivers then
		steps[#steps + 1] = {
			text = ns:L("HOME_ROUTINE_GIVERS"),
			color = "soft",
			-- Only carry the route pin here when no tracked giver already does.
			open = not anyGiverOpen or nil,
			-- We do not know what these givers offer, let alone at what level. That is
			-- exactly the case that must not become a recommendation while levelling.
			heroEligible = AtMaxLevel(),
			pin = { GIVERS_MAP, GIVERS_X, GIVERS_Y, "HOME_ROUTINE_PIN_GIVERS" },
			onClick = giversRoute,
		}
	end

	-- 3. Ritual Sites weekly.
	local rs = RitualState()
	if rs == "done" then
		steps[#steps + 1] = { text = ns:L("HOME_ROUTINE_RITUAL_DONE"), color = "good" }
	elseif rs == "inlog" then
		steps[#steps + 1] = {
			text = ns:L("HOME_ROUTINE_RITUAL_INLOG"),
			color = "prog",
			onClick = function()
				local site = ns.GetActiveRitualSite and ns.GetActiveRitualSite()
				if site and ns.RouteRitualSite then
					ns.RouteRitualSite(site)
				elseif ns.SelectTab then
					ns.SelectTab("world")
				end
			end,
		}
	elseif rs == "pickup" or rs == "intro" then
		steps[#steps + 1] = {
			text = ns:L(rs == "intro" and "HOME_ROUTINE_RITUAL_INTRO" or "HOME_ROUTINE_RITUAL_PICKUP"),
			color = rs == "intro" and "soft" or "warn",
			open = true,
			heroEligible = AtMaxLevel(), -- endgame content: never the headline while levelling
			pin = { HUB_MAP, HUB_X, HUB_Y, "HOME_ROUTINE_PIN_HUB" },
			onClick = function()
				if ns.RouteRitualHub then
					ns.RouteRitualHub()
				end
			end,
		}
	end

	-- 4. Void Assaults weekly (same hub).
	local vs = VoidState()
	if vs == "done" then
		steps[#steps + 1] = { text = ns:L("HOME_ROUTINE_VOID_DONE"), color = "good" }
	elseif vs == "inlog" then
		steps[#steps + 1] = {
			text = ns:L("HOME_ROUTINE_VOID_INLOG"),
			color = "prog",
			onClick = function()
				-- Hybride routing (QoL): volg het live void-weekly-objectief via de
				-- actieve zone-quest; lukt dat niet, val terug op het wereld-tabblad.
				local zone = ns.GetActiveVoidAssaultZone and ns.GetActiveVoidAssaultZone()
				local lbl = (zone and ns.VoidZoneName and ns.VoidZoneName(zone)) or "Void Assault"
				if zone and zone.weekly and ns.AddSmartQuestRoute
					and ns.AddSmartQuestRoute(zone.weekly, zone.mapID, nil, nil, lbl) then
					return
				end
				if ns.SelectTab then
					ns.SelectTab("world")
				end
			end,
		}
	else
		steps[#steps + 1] = {
			text = ns:L("HOME_ROUTINE_VOID_PICKUP"),
			heroEligible = AtMaxLevel(), -- endgame content: never the headline while levelling
			color = "warn",
			open = true,
			pin = { HUB_MAP, HUB_X, HUB_Y, "HOME_ROUTINE_PIN_HUB" },
			onClick = function()
				if ns.RouteRitualHub then
					ns.RouteRitualHub()
				end
			end,
		}
	end

	-- 4b. Extra event-weeklies (datamined quest-IDs). Alleen tonen als relevant:
	-- in je log of gedaan — we asserten geen beschikbaarheid voor event-gated
	-- weeklies (never-lie). Hergebruikt de generieke GIVER-fmt-keys (alle 6 talen).
	local EXTRA_WEEKLIES = {
		{ q = 89507, name = "Abundant Offerings" },
		{ q = 94446, name = "A Nightmarish Task" },
		{ q = 93784, name = "Gnawing Curiosity" },
		{ q = 93767, name = "Arcantina" },
		{ q = 94623, name = "Building the Voidforge" }, -- Decimus @ Voidstorm (PTR_12.0.7_DATA)
		-- Nog te bevestigen (geen quest-ID; in-game capturen): Beacon of Hope,
		-- Prey Hunts, Saltheril's Soiree, Bonus Event. Voeg toe zodra ID bekend.
	}
	for _, w in ipairs(EXTRA_WEEKLIES) do
		local st = ns.GetWeeklyQuestStatus and ns.GetWeeklyQuestStatus(w.q)
		if st == "done" then
			steps[#steps + 1] = { text = ns:L("HOME_ROUTINE_GIVER_DONE_FMT"):format(w.name), color = "good" }
		elseif st == "turnin" then
			steps[#steps + 1] = { text = ns:L("HOME_ROUTINE_GIVER_INLOG_FMT"):format(w.name), color = "warn" }
		elseif st == "active" then
			steps[#steps + 1] = { text = ns:L("HOME_ROUTINE_GIVER_INLOG_FMT"):format(w.name), color = "prog" }
		end
	end

	-- 5. Profession trainer weeklies. Tracked = verified quest ID; pickup
	-- routes to that profession's trainer (city-guide pin), not the station.
	local stMap, stX, stY = StationCoords()
	local tracked, untracked = OwnedProfTrainerWeeklies()
	for _, prof in ipairs(tracked) do
		-- Rotating weekly variants: any flagged = done, any in log = picked up.
		local done, inlog = false, false
		for _, qid in ipairs(prof.quests) do
			if Flagged(qid) then
				done = true
				break
			end
		end
		local readyToHandIn = false
		if not done then
			for _, qid in ipairs(prof.quests) do
				if OnQuest(qid) then
					inlog = true
					if ReadyToHandIn(qid) then
						readyToHandIn = true
					end
					break
				end
			end
		end

		-- Crafting profs (service quest) pick up at the Work Order station;
		-- Enchanting + gatherers at their profession trainer. Hoisted out of the
		-- pickup branch on 2 sep so the hand-in can route to the same place — the
		-- trainer does not move between giving you the quest and taking it back.
		local serviceProfs = ns.PROF_ACADEMY and ns.PROF_ACADEMY.weekly and ns.PROF_ACADEMY.weekly.serviceProfs
		local isService = serviceProfs and serviceProfs[prof.skillLine] or false
		local wx, wy, wPinKey, wPinArg
		if isService then
			wx, wy = stX, stY
			wPinKey, wPinArg = "HOME_ROUTINE_PIN_STATION", nil
		else
			local tpin = TRAINER_PINS[prof.skillLine]
			wx, wy = tpin and tpin[1] or stX, tpin and tpin[2] or stY
			wPinKey, wPinArg = "HOME_ROUTINE_PIN_TRAINER_FMT", prof.name
		end

		if done then
			steps[#steps + 1] = { text = ns:L("HOME_ROUTINE_TRAINER_DONE_FMT"):format(prof.name), color = "good" }
		elseif readyToHandIn then
			-- Same bug as the quest givers above: this used to become an unroutable
			-- line the moment the quest entered the log, and stayed one after it was
			-- finished. Rob had Blacksmithing sitting here on 2 sep.
			steps[#steps + 1] = {
				text = ns:L("HOME_ROUTINE_TRAINER_TURNIN_FMT"):format(prof.name),
				color = "warn",
				open = true,
				-- In the log and finished: already proven reachable by this character.
				heroEligible = true,
				pin = { stMap, wx, wy, wPinKey, wPinArg },
				onClick = function()
					RouteSingle(stMap, wx, wy, wPinKey, wPinArg)
				end,
			}
		elseif inlog then
			-- In the log but not finished: the crafting or gathering is the next step,
			-- not the walk. Clickable, not an open stop.
			steps[#steps + 1] = {
				text = ns:L("HOME_ROUTINE_TRAINER_INLOG_FMT"):format(prof.name),
				color = "prog",
				onClick = function()
					RouteSingle(stMap, wx, wy, wPinKey, wPinArg)
				end,
			}
		else
			-- Trainer-type weeklies are skill-gated: Enchanting verifiably
			-- needs skill 25, and Rob's fresh skill-1 Herbalism got nothing at
			-- the trainer (11 jun) while his leveled alt did. Below 25 we say
			-- so honestly instead of sending you to an empty trainer. Service
			-- quests are NOT skill-gated (fresh skill-1 Alchemy worked).
			if not isService and (prof.skill or 0) < 25 then
				steps[#steps + 1] = {
					text = ns:L("HOME_ROUTINE_TRAINER_LOWSKILL_FMT"):format(prof.name),
					color = "dim",
				}
			else
			-- Coordinates come from the hoisted block above; only the wording differs
			-- between picking up at the station and at the trainer. Two copies of the
			-- same isService branch is how they drift apart.
			local textKey = isService and "HOME_ROUTINE_SERVICE_PICKUP_FMT"
				or "HOME_ROUTINE_TRAINER_PICKUP_FMT"
			steps[#steps + 1] = {
				text = ns:L(textKey):format(prof.name),
				color = "warn",
				-- Profession weeklies are gated by SKILL, not by character level -- the
				-- skill-25 branch directly above is that gate, and it was measured (a
				-- fresh skill-1 Herbalism got nothing, a levelled alt did). So this stays
				-- a real action while levelling, and on Rob's level 68 it is the honest
				-- headline the giver row was stealing.
				heroEligible = true,
				open = true,
				pin = { stMap, wx, wy, wPinKey, wPinArg },
				onClick = function()
					RouteSingle(stMap, wx, wy, wPinKey, wPinArg)
				end,
			}
			end
		end
	end
	if #untracked > 0 then
		steps[#steps + 1] = {
			text = ns:L("HOME_ROUTINE_TRAINER_UNTRACKED_FMT"):format(table.concat(untracked, ", ")),
			color = "dim",
			onClick = function()
				if ns.SelectTab then
					ns.SelectTab("professions")
				end
			end,
		}
	end

	return steps
end

--- The one thing worth doing right now, plus this character's weekly tally — the answer
--- the Home headline exists to give. The routine already returns a priority-ordered,
--- live list where every open step carries a route, so the headline is simply its first
--- entry this character may actually act on.
---
--- "dim" steps (level-locked givers, weeklies we cannot track yet) are left out of the
--- tally: counting them would make "3 of 10" a total you can never reach.
---
--- 🔴 TWO FIXES, 3 Sep 2026, both from one level-68 screenshot.
---
--- 1. THE HERO NOW FAILS CLOSED. It was `s.heroEligible ~= false` -- eligible unless the
---    step objected -- and only 2 of the 11 step constructors ever objected. Now a step
---    must claim `== true`. The consequence is deliberate: a step nobody annotated loses
---    the headline instead of silently claiming it, so the next weekly added to this file
---    cannot repeat the bug by omission. It keeps its row either way.
---
--- 2. THE TALLY COUNTS WHAT YOU CAN DO. It excluded only `dim`, which meant Rob's "3 of 8"
---    counted the Ritual Sites and Void Assaults steps -- the two this very file had just
---    marked endgame-only for the headline. The knowledge existed and was applied to the
---    headline but not to the number underneath it. A denominator you cannot reach is not
---    progress, it is a standing accusation of being behind.
---
--- ⚠️ `done` still counts every finished step, including ones this character could not
--- start today. That is on purpose: an account-wide weekly that reads done IS done, and
--- subtracting it would make the number go backwards on an alt.
--- @return step|nil, done(number), total(number), later(number)
function ns.GetNextWeeklyAction()
	local ok, steps = pcall(ns.GetResetRoutineSteps)
	if not ok or type(steps) ~= "table" then
		return nil, 0, 0, 0
	end
	local hero, done, total, later = nil, 0, 0, 0
	for _, s in ipairs(steps) do
		if s.color == "dim" or s.heroEligible == false then
			-- Out of this character's reach today. Counted separately so the UI can say
			-- how many are waiting rather than quietly shrinking the list.
			if s.color ~= "good" then
				later = later + 1
			end
		else
			total = total + 1
			if s.color == "good" then
				done = done + 1
			end
		end
		if not hero and s.open and s.heroEligible == true then
			hero = s
		end
	end
	return hero, done, total, later
end

-- Open stops, routine order, duplicate coordinates (ritual + void share the
-- hub; the giver pins sit next to the vault) collapsed into one pin each.
local function ComputeOpenPins()
	local pins, seen = {}, {}
	local okSteps, steps = pcall(ns.GetResetRoutineSteps)
	if not okSteps or type(steps) ~= "table" then
		return pins
	end
	for _, step in ipairs(steps) do
		-- 🔴 The route is a recommendation too, and it was the biggest one. Until 3 Sep
		-- this tested `step.open and step.pin` only, so "Start route" happily sent a
		-- level-68 character through the endgame Bazaar hub and named the stops in chat.
		-- Fixing the headline alone would have left the more expensive version of the same
		-- wrong answer in place -- one that costs a whole flight path, not one hop.
		if step.open and step.pin and step.heroEligible ~= false then
			local key = table.concat({ step.pin[1], step.pin[2], step.pin[3] }, ":")
			-- Skip stops you've already visited this route (dwelled at / accepted there)
			-- so the arrow tours each stop once and never sticks on an unfinished one.
			if not seen[key] and not visited[key] then
				seen[key] = true
				pins[#pins + 1] = step.pin
			end
		end
	end
	return pins
end

local function PinsSignature(pins)
	local parts = {}
	for i, p in ipairs(pins) do
		parts[i] = table.concat({ p[1], p[2], p[3] }, ":")
	end
	return table.concat(parts, "|")
end

-- Active-route state. The reset route, the treasure route and the delve route
-- all share the single crazy arrow + ns.lastTarget, so a tiny owner token
-- (ns._mhRouteOwner) arbitrates: whoever issued the live arrow last owns it,
-- and the others stand down instead of fighting it on every event.
local routeActive = false
local routeSig
local advancePending = false
local advanceFrame

local function IssueRoute(pins)
	ClearTomTom()
	-- Sequential route: set ONLY the current stop as the waypoint. Adding every stop
	-- made TomTom's "set closest waypoint" swing the arrow between the several city
	-- stops as you walked (givers/hub/trainers/station all nearby). One waypoint at a
	-- time = the arrow stays on the current stop; IssueRoute re-runs to the next stop
	-- as each one is visited/done. routeSig still tracks the whole open set for advance.
	local first = pins[1]
	if first then
		ns.AddSmartTomTomWay(first[1], first[2], first[3], PinLabel(first[4], first[5]))
		ns.lastTarget = { mapID = first[1], x = first[2], y = first[3], name = PinLabel(first[4], first[5]) }
	end
	routeSig = PinsSignature(pins)
end

-- Let another navigation feature take the arrow (treasure / delve call this).
function ns.CancelResetRoute()
	routeActive = false
	routeSig = nil
end

-- Map (0..1) -> world yards (pcall-safe) for a real proximity check.
local function WorldXY(mapID, x01, y01)
	if not (C_Map and C_Map.GetWorldPosFromMapPos and CreateVector2D and mapID) then
		return nil
	end
	local ok, _, w = pcall(C_Map.GetWorldPosFromMapPos, mapID, CreateVector2D(x01, y01))
	if ok and type(w) == "table" then
		if w.GetXY then
			return w:GetXY()
		end
		return w.x, w.y
	end
	return nil
end

local function PlayerWorldXY()
	local pmap = C_Map and C_Map.GetBestMapForUnit and C_Map.GetBestMapForUnit("player")
	if not pmap then
		return nil
	end
	local pos = C_Map.GetPlayerMapPosition and C_Map.GetPlayerMapPosition(pmap, "player")
	if not pos then
		return nil
	end
	local px, py = pos:GetXY()
	if not (px and py) then
		return nil
	end
	return WorldXY(pmap, px, py)
end

-- The coord (0-100) the arrow is currently on, or nil.
local function LeadCoord()
	local t = ns.lastTarget
	if not (t and t.mapID and t.x and t.y) then
		return nil
	end
	return t.mapID, t.x, t.y
end

-- Is the player standing at a route coord (within ~22 yd)? Cross-continent coords
-- give a huge distance, so this reads false when you're not even there.
local function PlayerNearCoord(mapID, x, y)
	local pwx, pwy = PlayerWorldXY()
	local twx, twy = WorldXY(mapID, (x or 0) / 100, (y or 0) / 100)
	if not (pwx and twx) then
		return false
	end
	local dx, dy = pwx - twx, pwy - twy
	return (dx * dx + dy * dy) <= (22 * 22)
end

-- Re-evaluate the open stops; if the still-open set changed (a stop got claimed
-- or picked up), move the arrow to the next open stop. Stand down when another
-- feature owns the arrow, or when every stop is done.
local function AdvanceResetRoute()
	if not routeActive then
		return
	end
	if ns._mhRouteOwner and ns._mhRouteOwner ~= "reset" then
		ns.CancelResetRoute()
		return
	end
	local pins = ComputeOpenPins()
	if #pins == 0 then
		ClearTomTom()
		ns.lastTarget = nil
		routeActive = false
		routeSig = nil
		if ns._mhRouteOwner == "reset" then
			ns._mhRouteOwner = nil
		end
		if ns.PrintChatKey then
			ns:PrintChatKey("HOME_ROUTINE_ROUTE_DONE")
		end
		return
	end
	if PinsSignature(pins) ~= routeSig then
		IssueRoute(pins) -- arrow now points at the next still-open stop
		if ns.PrintChatKey then
			ns:PrintChatKey("HOME_ROUTINE_ROUTE_NEXT_FMT", PinLabel(pins[1][4], pins[1][5]))
		end
	end
end

local function ScheduleAdvance()
	if not routeActive or advancePending then
		return
	end
	advancePending = true
	if C_Timer and C_Timer.After then
		C_Timer.After(1.0, function() -- debounce QUEST_LOG_UPDATE bursts
			advancePending = false
			AdvanceResetRoute()
		end)
	else
		advancePending = false
		AdvanceResetRoute()
	end
end

-- Dwell fallback: park at the CURRENT stop (arrow on it) for ~6s and it's marked
-- visited, so the route moves on instead of the arrow sticking on a stop you didn't
-- finish right now (Halduron's rotating weekly, a ritual intro you skip, an empty
-- trainer…). Works for every stop; resets the counter when the lead changes or you
-- walk away. Never claims a stop is "done" — the checklist keeps its real status.
local dwellTicker
--- Assigns the forward-declared local from the top of the file (see StartDwellTicker
--- there); NOT a new local, or RouteSingle would still see nil.
function StartDwellTicker()
	if dwellTicker or not (C_Timer and C_Timer.NewTicker) then
		return
	end
	dwellTicker = C_Timer.NewTicker(2, function()
		if not routeActive then
			-- A single "take me there" pin earns the same courtesy as a full route:
			-- you asked to be taken somewhere, you are standing on it, so the arrow
			-- has done its job. Previously this branch just returned and the pin
			-- stayed up indefinitely.
			if singleTarget then
				if PlayerNearCoord(singleTarget[1], singleTarget[2], singleTarget[3]) then
					dwellTicks = dwellTicks + 1
					if dwellTicks >= 3 then -- ~6s parked on it, same as the route dwell
						ClearTomTom()
						singleTarget, dwellKey, dwellTicks = nil, nil, 0
					end
				else
					dwellTicks = 0
				end
				return
			end
			-- Nothing to watch: stop rather than tick on forever.
			dwellKey, dwellTicks = nil, 0
			if dwellTicker then
				pcall(function() dwellTicker:Cancel() end)
				dwellTicker = nil
			end
			return
		end
		local lm, lx, ly = LeadCoord()
		if not lm then
			dwellKey, dwellTicks = nil, 0
			return
		end
		local key = CoordKey(lm, lx, ly)
		if visited[key] or not PlayerNearCoord(lm, lx, ly) then
			dwellKey, dwellTicks = nil, 0
			return
		end
		if dwellKey ~= key then
			dwellKey, dwellTicks = key, 0
		end
		dwellTicks = dwellTicks + 1
		if dwellTicks >= 3 then -- ~6s parked on this stop
			visited[key] = true
			dwellKey, dwellTicks = nil, 0
			ScheduleAdvance()
		end
	end)
end

--- Re-place the pin for the stop we are already on, without saying anything.
---
--- Silent on purpose. Nothing changed for the player -- same stop, same route -- so
--- announcing "Next stop" again would be noise, and Rob already had that line three
--- times in one run. This only repairs a pin that quietly went missing.
local function ReassertRoute()
	if not routeActive then
		return
	end
	if ns._mhRouteOwner and ns._mhRouteOwner ~= "reset" then
		return -- someone else is guiding now; leave their arrow alone
	end
	local pins = ComputeOpenPins()
	if #pins == 0 then
		return -- nothing open: AdvanceResetRoute handles finishing, not this
	end
	IssueRoute(pins)
end

local function EnsureAdvanceFrame()
	if advanceFrame then
		return
	end
	advanceFrame = CreateFrame("Frame")
	advanceFrame:RegisterEvent("WEEKLY_REWARDS_UPDATE") -- vault claimed
	advanceFrame:RegisterEvent("QUEST_ACCEPTED") -- weekly picked up
	advanceFrame:RegisterEvent("QUEST_REMOVED")
	advanceFrame:RegisterEvent("QUEST_TURNED_IN")
	advanceFrame:RegisterEvent("QUEST_LOG_UPDATE")
	-- Zone changes, because a waypoint can go missing without anything here failing
	-- visibly. Rob walked the route on an alt, stepped through the Voidstorm portal
	-- into Naigtal, and the arrow never came back -- not on returning to Silvermoon,
	-- not on re-running the route. Only /reload fixed it (30 jul).
	--
	-- IssueRoute records routeSig whether or not the waypoint actually landed, and
	-- TomTom will not place a Silvermoon pin while you are standing in an instanced
	-- Void world. So the pin was dropped, the signature was updated anyway, and back
	-- in Silvermoon the open set was unchanged -- meaning `signature ~= routeSig` was
	-- false and IssueRoute was never called again. The route believed it was already
	-- pointing somewhere it had failed to point.
	--
	-- Rather than teach IssueRoute which map hosts which waypoint, re-assert on the
	-- event that caused it. Cheap, and it covers every other way a pin can vanish:
	-- a loading screen, the player clearing TomTom, another addon.
	advanceFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	advanceFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
	advanceFrame:SetScript("OnEvent", function(_, event)
		if event == "ZONE_CHANGED_NEW_AREA" or event == "PLAYER_ENTERING_WORLD" then
			-- Forget the signature so the next advance re-issues instead of deciding
			-- it is already showing the right stop. Delayed: right after a portal the
			-- map APIs are still mid-loading-screen, which is the state that lost the
			-- pin in the first place.
			if routeActive and C_Timer and C_Timer.After then
				C_Timer.After(2, ReassertRoute)
			end
			return
		end
		-- Accepting a quest while parked on the current stop = you did what you came for;
		-- mark it visited so the route moves on (covers givers/hub we can't auto-track).
		if event == "QUEST_ACCEPTED" and routeActive then
			local lm, lx, ly = LeadCoord()
			if lm and PlayerNearCoord(lm, lx, ly) then
				visited[CoordKey(lm, lx, ly)] = true
			end
		end
		ScheduleAdvance()
	end)
end

-- Set the TomTom route along the still-open stops and keep the arrow advancing
-- to the next stop as each one gets done.
function ns.StartResetRoute()
	if not ns.AddSmartTomTomWay then
		return
	end
	local pins = ComputeOpenPins()
	if #pins == 0 then
		if ns.PrintChatKey then
			ns:PrintChatKey("HOME_ROUTINE_ROUTE_EMPTY")
		end
		ns.CancelResetRoute()
		return
	end
	ns._mhRouteOwner = "reset" -- claim the shared arrow (treasure/delve yield)
	wipe(visited) -- fresh route: re-arm every stop
	dwellKey, dwellTicks = nil, 0
	singleTarget = nil -- the full route supersedes any single "take me there" pin
	IssueRoute(pins)
	routeActive = true
	EnsureAdvanceFrame()
	StartDwellTicker()
	if ns.PrintChatKey then
		ns:PrintChatKey("HOME_ROUTINE_ROUTE_SET_FMT", #pins)
	end
end

-- One-shot diagnostic: /mh resetdebug — prints the full reset-route state so we can
-- see exactly which stop is open/lead and why the arrow sticks or ping-pongs.
function ns.ResetRouteDebug()
	local function p(s)
		print("|cff88ddff[MH reset]|r " .. s)
	end
	local lm, lx, ly = LeadCoord()
	p(("active=%s owner=%s nearLead=%s dwell=%s/3"):format(
		tostring(routeActive), tostring(ns._mhRouteOwner),
		tostring(lm and PlayerNearCoord(lm, lx, ly)), tostring(dwellTicks)))
	local vkeys = {}
	for k in pairs(visited) do
		vkeys[#vkeys + 1] = k
	end
	p("visited: " .. (#vkeys > 0 and table.concat(vkeys, "  ") or "(none)"))
	local lt = ns.lastTarget
	p("lastTarget = " .. (lt and (tostring(lt.name) .. " @ " .. tostring(lt.mapID) .. " " ..
		tostring(lt.x) .. "," .. tostring(lt.y)) or "nil"))
	for _, def in ipairs(GIVER_WEEKLIES) do
		p(("giver %s -> %s"):format(tostring(def.name), tostring(GiverState(def))))
	end
	-- 🔴 PRINT WHY A STEP WAS PASSED OVER, not just that it was. Since 3 Sep a step can be
	-- open, carry a pin, and still be skipped for the headline and the route because this
	-- character cannot act on it. From outside, correct filtering and a broken data table
	-- look identical -- and the person who signs this off plays at max level, where the
	-- filter never fires. So the state he cannot reach has to be readable here.
	p(("cap=%s playerLevel=%s atMax=%s"):format(
		tostring(ns.GetDelveCapLevel and select(2, pcall(ns.GetDelveCapLevel))),
		tostring(UnitLevel and UnitLevel("player")), tostring(AtMaxLevel())))
	local okSteps, steps = pcall(ns.GetResetRoutineSteps)
	if okSteps and type(steps) == "table" then
		for i, s in ipairs(steps) do
			local pin = s.pin and ("[%s %s,%s]"):format(tostring(s.pin[1]), tostring(s.pin[2]), tostring(s.pin[3])) or "-"
			local hero = (s.heroEligible == true and "yes")
				or (s.heroEligible == false and "NO (out of reach)")
				or "n/a"
			p(("step %d open=%s hero=%s color=%s pin=%s | %s"):format(
				i, tostring(s.open and true or false), hero, tostring(s.color), pin, tostring(s.text)))
		end
	end
	local hero, done, total, later = ns.GetNextWeeklyAction()
	p(("tally: %s of %s doable, %s waiting on level | headline = %s"):format(
		tostring(done), tostring(total), tostring(later),
		hero and tostring(hero.text) or "(none)"))
	local pins = ComputeOpenPins()
	local labels = {}
	for _, pin in ipairs(pins) do
		labels[#labels + 1] = tostring(pin[2]) .. "," .. tostring(pin[3])
	end
	p("open pins (route order): " .. (table.concat(labels, "  ") ))
	local s = LearnStore()
	for key, set in pairs(s.quests) do
		local qs = {}
		for qid in pairs(set) do
			qs[#qs + 1] = tostring(qid)
		end
		p(("learned %s: %s"):format(key, table.concat(qs, ",")))
	end
end

-- Always-on learn frame (independent of the route): remember which quest each giver
-- NPC hands out this week, so rotating weeklies self-heal. See LearnGiverQuest.
do
	local learnFrame = CreateFrame("Frame")
	learnFrame:RegisterEvent("QUEST_DETAIL")
	learnFrame:RegisterEvent("QUEST_ACCEPTED")
	learnFrame:SetScript("OnEvent", function(_, event, a1, a2)
		if event == "QUEST_DETAIL" then
			local guid = UnitGUID and (UnitGUID("npc") or UnitGUID("questnpc"))
			pendingNpcID = NpcIDFromGUID(guid)
			pendingNpcName = (UnitName and (UnitName("npc") or UnitName("questnpc"))) or nil
		elseif event == "QUEST_ACCEPTED" then
			-- Retail passes questID (a1); older clients passed (logIndex, questID).
			LearnGiverQuest(a2 or a1)
		end
	end)
end

--------------------------------------------------------------------------------
-- `/mh profweekly` — why the routine did or did not send you to a profession
-- weekly (Rob, 29 jul 2026: "ik werd niet naar de professions quest gestuurd").
--
-- Step 5 has five different outcomes -- done, in your log, skill-gated, pick up at
-- the Work Order station, pick up at the trainer -- and a sixth silent one where
-- the profession is not tracked at all. From the outside they are impossible to
-- tell apart: four of them simply do not produce a route, so "no route" is the
-- symptom of half the branches.
--
-- Rather than reason about which one fired, this prints the inputs the step reads
-- and names the branch. Read-only: professions, quest flags and the same tables
-- the step itself uses.
--------------------------------------------------------------------------------
function ns.PrintProfWeeklyDiagnostics()
	local p = ("|cffffcc00%s|r"):format(ns:L("PRINT_PREFIX"))
	print(("%s Profession weeklies — what step 5 sees:"):format(p))

	if not (GetProfessions and GetProfessionInfo) then
		print("   |cffff8080the profession API is unavailable on this client|r")
		return
	end
	local okP, p1, p2 = pcall(GetProfessions)
	if not okP then
		print("   |cffff8080GetProfessions failed|r")
		return
	end
	if not p1 and not p2 then
		print("   |cffff8080this character has NO primary professions|r — step 5 has nothing to show.")
		return
	end

	local serviceProfs = (ns.PROF_ACADEMY and ns.PROF_ACADEMY.weekly and ns.PROF_ACADEMY.weekly.serviceProfs) or {}
	local tracked, untracked = OwnedProfTrainerWeeklies()

	for _, prof in ipairs(tracked) do
		local isService = serviceProfs[prof.skillLine] and true or false
		print(("   |cff8fd3ff%s|r  skillLine %d, skill %d, %s"):format(
			prof.name, prof.skillLine, prof.skill or 0,
			isService and "Work Order station" or "trainer"))
		local done, inlog = false, false
		for _, qid in ipairs(prof.quests) do
			local f, o = Flagged(qid), OnQuest(qid)
			done = done or f
			inlog = inlog or o
			print(("      quest %d — completed: %s, in your log: %s"):format(qid, tostring(f), tostring(o)))
		end
		local branch
		if done then
			branch = "|cff40c040DONE this week|r — no route, correctly"
		elseif inlog then
			branch = "|cffffd100already in your log|r — no route, correctly"
		elseif not isService and (prof.skill or 0) < 25 then
			branch = "|cff9d9d9dskill-gated|r — trainer weeklies need skill 25, so no route"
		elseif isService then
			branch = "|cff40c040PICKUP at the Work Order station|r — should route"
		else
			branch = "|cff40c040PICKUP at the trainer|r — should route"
		end
		print(("      -> %s"):format(branch))
	end

	for _, name in ipairs(untracked) do
		print(("   |cffff8080%s|r — owned, but we hold no weekly quest id for it, so step 5 stays silent."):format(name))
	end

	if #tracked == 0 and #untracked == 0 then
		print("   |cffff8080GetProfessions returned slots but none resolved|r — GetProfessionInfo gave no skillLine.")
	end
end
