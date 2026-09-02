--[[
	Campaign / quest-chain lead-in tracker.

	Two chains live here now. Both answer the same question — "there is content you
	cannot see yet, and here is the thread that opens it" — so they share one engine
	rather than one module each.

	HONESTY BY CONSTRUCTION. A block appears only when the live quest API says its start
	quest exists and is not yet completed. If a configured quest ID were wrong,
	`IsQuestFlaggedCompleted` would answer for a quest that never applies to this
	character, so the guard below (needs GetTitleForQuestID to actually name it) keeps a
	bogus ID from parking a permanent, false "go do this" nudge on the dashboard. The
	arrow follows the live objective through AddSmartQuestRoute, so once you are on the
	quest the route is Blizzard's own waypoint, not our fallback coords.

	--- 1. Curse of Ula'tek ------------------------------------------------------------

	Patch 12.1's lead-in campaign went LIVE in 12.0.7 with the weekly reset of 7 July
	2026 (Blizzard front-loads it so players are ready when 12.1 lands). It is the
	prerequisite gate for the Coiled Isle. Because it is live, every ID here can be —
	and must be — confirmed in-game rather than trusted from datamine.

	CONFIRMED (start quest cross-checked two ways: Rob's live `/mh campaign` returned
	title="Hagar's Invitation" for 92895, and Zygor's own "The Curse of Ula'tek Campaign"
	guide gives the same, plus the chain and coords):
	  - start quest "Hagar's Invitation" = 92895, from Orweyna (npc 253640) in central
	    Silvermoon City (uiMap 2393) at 45.38 / 70.07. Lor'themar stands at the same spot
	    offering the unrelated base-Midnight quest "War of Light and Shadow" — which is
	    why the first route looked wrong; the giver we want is Orweyna.
	  - the chain below is Chapter 1 ("Legacy of the Amani", 93011), the Amani spine only
	    — NOT Zygor's optional Lorewalking side-arcs. Extend to Chapter 2 (the
	    Voidstorm/Val/Naigtal arc, 96048…) once Rob is there to confirm it in-game.
	  - reward mount "Dusk Grimlynx" = item 246731; reward pet "Akiki" = npc 260149
	    (still Wowhead-sourced — confirm via the collection when earned).

	--- 2. Vaults of Atal'Utek ---------------------------------------------------------

	Added 14 Aug 2026. The Vaults are a 12.1 area on the Coiled Isle with their own map,
	their own currency and three achievements, and none of it is reachable until this
	three-quest chain is done. Rob walked in already past it and still said "I have no
	idea what I can all do there"; somebody who has not done the chain cannot even see
	the question.

	MEASURED, not datamined: all three ids were confirmed by `/mh atal` on Rob's own
	client on 13 Aug 2026, which read their real titles back — and the game titles two of
	them longer than the guides do ("Vaults of Atal'Utek: One Coin Too Many").

	✅ THE VAULTS ENTRANCE IS NOW MEASURED — and the wait was worth it.

	This entry shipped with no start* fields for two days, because no measurement existed.

	On 14 Aug the client answered. C_Map.GetMapLinksForMap lists **three** links from The
	Coiled Isle into the Vaults, and three back out. See `startCandidates` below.

	⚠️ CORRECTION, 15 Aug — and it is a correction of ours, not of a guide.

	This header used to say Zygor's ~47.24 / 60.79 "was the kind of number that puts
	someone NEXT to a door", and that the single entrance every guide describes does not
	exist. Zygor writes that coordinate as `|goto Vaults of Atal'Utek/0 47.24,60.79`: it
	is on map **2509, inside the Vaults**, the quest hub where you pick up 98388. It was
	never a claim about the island. Our notes copied it on 12 Aug as "the entrance, on The
	Coiled Isle" and every later comparison inherited that.

	What survives: the three links are measured, and a single static coordinate would
	still have been the wrong shape. What does not: nobody was off by four, and no guide
	was contradicted. Measuring two maps against each other and calling the gap someone
	else's error is its own kind of confident wrong answer — the same family as the one
	this file was built to avoid.
]]

local _, ns = ...

-- Chains are plain data — extend by appending IDs. Per-campaign locale keys keep the
-- dashboard text specific ("New: Curse of Ula'tek" is not a heading the Vaults can
-- borrow) without the dashboard having to know which campaign it is drawing.
local ULATEK = {
	key = "ulatek_leadin",
	nameKey = "CAMPAIGN_ULATEK_NAME",
	headerKey = "HOME_SECTION_CAMPAIGN",
	availableKey = "HOME_CAMPAIGN_AVAILABLE",
	inprogressKey = "HOME_CAMPAIGN_INPROGRESS",
	routeBtnKey = "HOME_CAMPAIGN_ROUTE_BTN",
	startMapID = 2393, -- Silvermoon City
	startX = 45.38, -- Orweyna (npc 253640); Zygor coords, matches Rob's screenshot
	startY = 70.07,
	-- Deliberately just the quest IDs — no per-objective coords. MH's job here is
	-- DISCOVERY (surface the campaign + rewards) and a push to the START; once you are on
	-- it, the base game guides you (map objective, its own waypoint where it has one, the
	-- NPCs' gold ! markers) — that is not Zygor-specific, it is WoW itself. Trying to
	-- route every objective would rebuild Zygor from Zygor's data: a per-patch coord
	-- maintenance burden for a one-time campaign, redundant with an addon many players
	-- already run. A static fallback coord also cannot follow objective-to-objective (it
	-- sat 13m from the moved objective and would not clear — Rob, 10 jul), so it was worse
	-- than leaving the guidance to the game.
	chain = {
		{ questID = 92895, nameKey = "CAMPAIGN_ULATEK_STARTQUEST" }, -- Hagar's Invitation
		{ questID = 92899 }, -- History Lesson
		{ questID = 92900 }, -- A Favor for Kinduru
		{ questID = 92901 }, -- Revisionist History
		{ questID = 92904 }, -- Return to Zul'Aman
		{ questID = 92907 }, -- Amani Answers
		{ questID = 92955 }, -- The Tablets of Numazon
		{ questID = 92957 }, -- There's the Rub
		{ questID = 92958 }, -- Brain Drain
		{ questID = 92951 }, -- Digging Deeper
		{ questID = 92952 }, -- Mission to Maisara
		{ questID = 92953 }, -- Memories of Malacrass
		{ questID = 92954 }, -- Maisara Caverns: Master of Souls
		{ questID = 93010 }, -- The Serpent Shrine
		{ questID = 93011 }, -- Legacy of the Amani (Chapter 1 capstone)
		{ questID = 93012 }, -- Dead End
	},
	rewards = {
		{ kind = "mount", itemID = 246731, nameKey = "CAMPAIGN_ULATEK_REWARD_MOUNT" }, -- Dusk Grimlynx
		{ kind = "pet", creatureID = 260149, nameKey = "CAMPAIGN_ULATEK_REWARD_PET" }, -- Akiki
	},
}

local VAULTS = {
	key = "vaults_atalutek",
	nameKey = "CAMPAIGN_VAULTS_NAME",
	headerKey = "HOME_SECTION_VAULTS",
	availableKey = "HOME_VAULTS_AVAILABLE",
	inprogressKey = "HOME_VAULTS_INPROGRESS",
	routeBtnKey = "HOME_VAULTS_ROUTE_BTN",
	-- ✅ MEASURED 14 Aug 2026, and there turned out to be three of them.
	--
	-- `/mh atal` now reads C_Map.GetMapLinksForMap, and the client lists three links
	-- from The Coiled Isle (2512) into the Vaults (2509) -- not the one entrance every
	-- guide describes. Zygor's 47.24 / 60.79 is nearest to the first of these and still
	-- ~4 map units off it, which is the same story as the Crafting Orders pin.
	--
	-- Three real doors mean a single static coordinate would be arbitrary: correct, but
	-- possibly the one across the island. So the route picks the nearest to where the
	-- player is standing, and falls back to the first when they are not on 2512 yet.
	startMapID = 2512, -- The Coiled Isle
	startCandidates = {
		{ 45.37, 64.93 },
		{ 43.28, 44.19 },
		{ 31.88, 64.90 },
	},
	--- 🔴 SAY WHAT IT COSTS TO GET IN, because this block shows to people who cannot.
	--- `GetTitleForQuestID` names a quest whether or not you are eligible for it, so the
	--- honesty guard at the top of this file does NOT keep this nudge away from a level-80
	--- character. It used to read "there is content here" and stop, which is the cruellest
	--- possible version: a door with no key and no sign.
	---
	--- MEASURED 31 Aug 2026: level 90 on seven of these quests (tooltip API), and 98388 sits
	--- at OrderIndex 4 of questline 6232 directly after 93420 "Lor'themar's Judgement" --
	--- with the Altar of Fangs dungeon (93417) and the Venomous Abyss raid (93418) as steps
	--- inside that same campaign. So the gate is real content, not a level number.
	---
	--- ✅ AND ONE GATE EARLIER, from Blizzard's own words. Hotfixes 13 Aug 2026, Quests:
	--- "Fixed an issue where players could begin Curse of Ula'tek campaign quests without
	--- first completing the main Midnight campaign", with the developer's note that it
	--- "was intended to require ACCOUNT COMPLETION of the main Midnight campaign".
	---
	--- 📌 That is Rob's warbound observation in Blizzard's phrasing: he predicted the chain
	--- was account-wide from being able to walk in on every alt, and this is the mechanism.
	--- Our gate line named the second door and not the first; it now names both.
	--- ⚠️ Found by the new content watch on its first run -- the hotfix sections the API
	--- watch stamps as "not our concern" are where this lived for eighteen days.
	gateKey = "HOME_VAULTS_GATE",
	chain = {
		{ questID = 98388, nameKey = "CAMPAIGN_VAULTS_STARTQUEST" }, -- Into the Vaults of Atal'Utek
		{ questID = 97640 }, -- Vaults of Atal'Utek: One Coin Too Many
		--- ⚠️ ADDED 31 Aug: we shipped this chain as three quests for two weeks and it is
		--- four. `QuestLineXQuest` row 52726 puts 98515 at OrderIndex 6, between the two
		--- either side of it. Two overlapping questlines describe this zone -- 6352 holds
		--- three quests, 6232 holds all eight -- and we had copied the short one, which is
		--- also why Wowhead labels these "1st of 3".
		---
		--- ✅ ITS NATURE IS SETTLED, 2 Sep 2026: one-time STORY, not a daily. The questline
		--- data was right and "Zygor files it under dailies" was a misreading of Zygor.
		---
		--- MEASURED in ZygorDailiesCommonMID.lua (guide updated to 9.6 that morning). The
		--- guide's own end-of-day check names the eight quests it considers today's dailies:
		---     |complete false or not completedq(96644,96640,96643,98420,98419,96641,96642,96639)
		--- 98515 is NOT among them. It appears earlier in that same file only because the
		--- dailies guide walks a new player through the intro chain before starting the loop,
		--- and it appears again in ZygorLevelingCommonMID.lua inside the story sequence,
		--- followed by picking up the flight path.
		---
		--- 📌 The lesson is about where we looked, not about Zygor. "It is in the dailies
		--- file" was true and meant nothing; the file's own definition of a daily was eleven
		--- lines further down. A guide's folder name is not its classification.
		---
		--- Its four objectives are repeatable activities, which is why both readings looked
		--- explicable for two days -- and is exactly why the objectives being repeatable says
		--- nothing about the quest that asks for them.
		{ questID = 98515 }, -- Vaults of Atal'Utek: A Toxic Tour
		{ questID = 98428 }, -- Vaults of Atal'Utek: The Altar of Corrosion
	},
	--- Rewards MEASURED 31 Aug (wiki infoboxes; both unlock spells corroborated on Wowhead):
	--- 41,100 XP, 103g 48s, 1000 Corrosive Coins, and two unlocks -- the zone itself
	--- (spell 1310359) and the Altar of Corrosion (spell 1310218), where Spirit Corrosion is
	--- spent on traits. Only the two unlocks are shown: XP and gold are not why anyone does
	--- this, and a coin total we read off a wiki is not worth a line on the dashboard.
	---
	--- ⚠️ A THIRD reward list was discarded rather than shipped. An extraction returned items
	--- and currencies for 98515 that came back IDENTICAL for an unrelated quest -- a shared
	--- zone sidebar being scraped, not a reward box. That is exactly the shape of the mistake
	--- that puts invented loot in front of a player.
	rewards = {
		{ kind = "unlock", nameKey = "CAMPAIGN_VAULTS_REWARD_ZONE" },
		{ kind = "unlock", nameKey = "CAMPAIGN_VAULTS_REWARD_ALTAR" },
	},
}

local CAMPAIGNS = { ULATEK, VAULTS }

local function QuestDone(questID)
	if not (questID and C_QuestLog and C_QuestLog.IsQuestFlaggedCompleted) then
		return false
	end
	local ok, done = pcall(C_QuestLog.IsQuestFlaggedCompleted, questID)
	return ok and done == true
end

local function OnQuest(questID)
	if not (questID and C_QuestLog and C_QuestLog.IsOnQuest) then
		return false
	end
	local ok, on = pcall(C_QuestLog.IsOnQuest, questID)
	return ok and on == true
end

--- Does the game actually know this quest ID? A real quest has a title. This is the
--- guard that stops a wrong datamined ID from showing a phantom campaign nudge.
local function QuestIsReal(questID)
	if not (questID and C_QuestLog and C_QuestLog.GetTitleForQuestID) then
		return false
	end
	local ok, title = pcall(C_QuestLog.GetTitleForQuestID, questID)
	return ok and type(title) == "string" and title ~= ""
end

--- Live state of one chain, or nil when there is nothing to show.
--- Where to send someone who has not started yet.
---
--- Most campaigns have one door and carry plain startX/startY. The Vaults have three
--- (measured 14 Aug, see the VAULTS entry), so those carry `startCandidates` instead
--- and this picks the nearest to the player.
---
--- Nearest is computed in map units, which are not metres and are not even the same
--- distance in x as in y on a non-square map. That is fine for choosing between three
--- doors and would not be fine for anything else, so it does not leave this function.
--- If the player is not on the campaign's start map we cannot compare at all, and the
--- first candidate is returned rather than a guess dressed up as a choice.
local function ResolveStart(campaign)
	if campaign.startX and campaign.startY then
		return campaign.startX, campaign.startY
	end
	local list = campaign.startCandidates
	if type(list) ~= "table" or #list == 0 then
		return nil, nil
	end
	local first = list[1]
	if not (C_Map and C_Map.GetBestMapForUnit and C_Map.GetPlayerMapPosition) then
		return first[1], first[2]
	end
	local okMap, here = pcall(C_Map.GetBestMapForUnit, "player")
	if not okMap or here ~= campaign.startMapID then
		return first[1], first[2]
	end
	local okPos, pos = pcall(C_Map.GetPlayerMapPosition, campaign.startMapID, "player")
	if not (okPos and pos and pos.GetXY) then
		return first[1], first[2]
	end
	local okXY, px, py = pcall(pos.GetXY, pos)
	if not (okXY and px and py) then
		return first[1], first[2]
	end
	px, py = px * 100, py * 100
	local best, bestDist = first, nil
	for _, cand in ipairs(list) do
		local dx, dy = cand[1] - px, cand[2] - py
		local d = dx * dx + dy * dy
		if bestDist == nil or d < bestDist then
			best, bestDist = cand, d
		end
	end
	return best[1], best[2]
end

local function StateFor(campaign)
	local start = campaign.chain[1]
	if not start or not QuestIsReal(start.questID) then
		return nil -- unknown/unconfirmed quest: stay silent rather than guess
	end

	-- Walk the chain once: which quest are we on, what is the first not-yet-done step, and
	-- has any of it been finished at all?
	local onQuestID, firstOpenID, anyDone, allDone = nil, nil, false, true
	for _, step in ipairs(campaign.chain) do
		if QuestDone(step.questID) then
			anyDone = true
		else
			allDone = false
			if not firstOpenID then
				firstOpenID = step.questID
			end
			if not onQuestID and OnQuest(step.questID) then
				onQuestID = step.questID
			end
		end
	end
	if allDone then
		return nil -- every known milestone finished; the nudge has done its job
	end

	-- "Have I begun?" is not "am I on the first open step" — the chain branches and can be
	-- done out of order. You have begun the moment you are on ANY chain quest or have
	-- finished ANY of them; only a truly untouched chain is still "available". Point the
	-- route at the quest you are actually on, else the first step you have not done.
	local status = (onQuestID or anyDone) and "inprogress" or "available"
	local activeQuestID = onQuestID or firstOpenID
	local startX, startY = ResolveStart(campaign)
	local hasStartCoords = campaign.startMapID ~= nil and startX ~= nil and startY ~= nil
	return {
		key = campaign.key,
		name = ns:L(campaign.nameKey),
		status = status,
		headerKey = campaign.headerKey,
		availableKey = campaign.availableKey,
		inprogressKey = campaign.inprogressKey,
		routeBtnKey = campaign.routeBtnKey,
		-- Only worth saying while you have not started: once you are on a chain quest you
		-- are demonstrably past the gate, and repeating it then is noise.
		gateKey = (status == "available") and campaign.gateKey or nil,
		startMapID = campaign.startMapID,
		startX = startX,
		startY = startY,
		activeQuestID = activeQuestID,
		rewards = campaign.rewards,
		-- Can this state actually put an arrow somewhere? Once you are on a chain quest
		-- the game's own objective drives, so yes regardless of coords. Before that we
		-- need a measured start, and the Vaults do not have one — so the dashboard draws
		-- the nudge and skips the button rather than offering a route to nowhere.
		canRoute = (status == "inprogress") or hasStartCoords,
	}
end

--- Every visible lead-in, in declaration order. Empty table when none apply.
--- @return table[] states
function ns.GetCampaignLeadInStates()
	local out = {}
	for _, campaign in ipairs(CAMPAIGNS) do
		local st = StateFor(campaign)
		if st then
			out[#out + 1] = st
		end
	end
	return out
end

--- Live state of one lead-in.
--- @param key string|nil campaign key; omit for the first visible one (back-compat)
--- @return table|nil {
---   key, name, status = "available"|"inprogress",
---   headerKey, availableKey, inprogressKey, routeBtnKey,
---   startMapID, startX, startY, activeQuestID, rewards, canRoute }
---   nil when there is nothing to show (all known steps done, or the start quest ID is
---   not a real quest on this client — do not invent a nudge).
function ns.GetCampaignLeadInState(key)
	for _, campaign in ipairs(CAMPAIGNS) do
		if key == nil or campaign.key == key then
			local st = StateFor(campaign)
			if st then
				return st
			end
			if key ~= nil then
				return nil
			end
		end
	end
	return nil
end

-- Quick membership test for every chain, so the accept-handler only ever touches our own
-- quests and never hijacks the player's super-track for something unrelated.
local CHAIN_SET = {}
for _, campaign in ipairs(CAMPAIGNS) do
	for _, step in ipairs(campaign.chain) do
		CHAIN_SET[step.questID] = true
	end
end

--- Turn on Blizzard's own quest arrow for a quest you are on. This is the reliable way
--- to point at the LIVE objective ("Arrive at the meeting" in Harandar) — the game knows
--- where that is, we do not, and its objective moves zone to zone as the quest advances.
local function SuperTrackQuest(questID)
	if questID and C_SuperTrack and C_SuperTrack.SetSuperTrackedQuestID then
		pcall(C_SuperTrack.SetSuperTrackedQuestID, questID)
	end
end

--- Route to a lead-in.
---
--- Before you have picked it up: head to the start (Orweyna in Silvermoon for Ula'tek).
--- A campaign with no measured start has `canRoute` false in that state and never gets
--- here from the dashboard.
---
--- Once you are ON a chain quest: let Blizzard's own quest arrow drive, because the
--- objective ("Arrive at the meeting" in Harandar) roams and the game knows where it is.
--- Crucially we must NOT fall back to the campaign start here — that dropped an MH
--- waypoint on Silvermoon, which stole the super-track and left the arrow pointing at the
--- pickup you had already left. So: clear any competing waypoint, super-track the quest,
--- and only add an objective waypoint if the game actually has a placeable one (no start
--- fallback).
--- @param key string|nil campaign key; omit for the first visible one
function ns.RouteCampaignLeadIn(key)
	local st = ns.GetCampaignLeadInState(key)
	if not st then
		return false
	end

	if st.status == "inprogress" then
		-- Already on it: hand guidance to the game. Super-track the quest so its objective
		-- shows on the map (and the native arrow appears wherever the game has a waypoint).
		-- No fallback coord — a static point can't follow objective-to-objective and just
		-- lingered "13m away" once the objective moved. The gold ! markers do the last bit.
		SuperTrackQuest(st.activeQuestID)
		if ns.AddSmartQuestRoute then
			ns.AddSmartQuestRoute(st.activeQuestID, nil, nil, nil, st.name)
		end
		return true
	end

	if not st.canRoute then
		return false -- no measured start; saying nothing beats pointing at a guess
	end

	if ns.AddSmartQuestRoute then
		return ns.AddSmartQuestRoute(st.activeQuestID, st.startMapID, st.startX, st.startY, st.name)
	end
	if ns.AddSmartTomTomWay then
		return ns.AddSmartTomTomWay(st.startMapID, st.startX, st.startY, st.name)
	end
	return false
end

-- Auto-continue: when you accept one of our chain quests, super-track it so the arrow
-- carries on to the next objective without re-opening Midnight Helper. Scoped to the
-- chains, so it never overrides super-tracking for an unrelated quest you pick up.
local accepted = CreateFrame("Frame")
accepted:RegisterEvent("QUEST_ACCEPTED")
accepted:SetScript("OnEvent", function(_, _, arg1, arg2)
	-- QUEST_ACCEPTED payload changed across versions: sometimes (questID), sometimes
	-- (logIndex, questID). Take whichever argument is one of our chain quests.
	local questID = (arg1 and CHAIN_SET[arg1] and arg1) or (arg2 and CHAIN_SET[arg2] and arg2)
	if questID then
		SuperTrackQuest(questID)
	end
end)

--------------------------------------------------------------------------------
-- `/mh campaign` — verify the configured IDs against the live game.
--------------------------------------------------------------------------------

function ns.PrintCampaignLeadInDiagnostics()
	local p = "|cffffff78Midnight Helper:|r "
	for _, campaign in ipairs(CAMPAIGNS) do
		print(p .. ns:L(campaign.nameKey))
		for i, step in ipairs(campaign.chain) do
			local title = "?"
			if C_QuestLog and C_QuestLog.GetTitleForQuestID then
				local ok, t = pcall(C_QuestLog.GetTitleForQuestID, step.questID)
				if ok and type(t) == "string" and t ~= "" then
					title = t
				end
			end
			print(("  chain[%d] quest %d  title=%s  done=%s  onQuest=%s"):format(
				i, step.questID, title, tostring(QuestDone(step.questID)), tostring(OnQuest(step.questID))))
		end
		local st = StateFor(campaign)
		print(("  state = %s  canRoute = %s"):format(
			st and st.status or "nil (hidden)", st and tostring(st.canRoute) or "-"))

		--- 🔴 SHOW THE GATE TEXT EVEN WHEN THE DASHBOARD WILL NEVER SHOW IT.
		---
		--- ✅ MEASURED 31 Aug 2026 and Rob called it before the probe did. `/mh campaign` on
		--- **Warlockie, level 82**, returns done=true for all four chain quests -- and a
		--- level-82 character cannot have completed a level-90 quest. **Completion is
		--- account-wide.** He noticed because he could walk into the Vaults on every alt.
		---
		--- So the gate line is correct AND permanently unverifiable by the person who signs
		--- it off: it reaches only somebody who has run this chain on NO character. Working
		--- as intended and genuinely broken look identical from his chair, which is the exact
		--- case this repo has a rule about -- hence the print below.
		---
		--- ⚠️ This does NOT settle whether 98515 is story or daily. A daily completed today
		--- also reads done until reset, so done=true is consistent with both.
		---
		--- So the diagnostic prints the sentence and says who would see it. He can read the
		--- wording without being able to reach the state.
		if campaign.gateKey then
			print(("  gate (shown only before you start): %s"):format(ns:L(campaign.gateKey)))
			if st == nil then
				print("    ^ hidden for you: every chain step reads done. If that is true on a "
					.. "character that never ran it, the chain is account-wide -- measured true 31 Aug.")
			end
		end

		-- Ground truth for the arrow: what does Blizzard itself have as the next waypoint for
		-- the active quest, and can a waypoint be placed on that map? This says whether
		-- super-track alone can guide, or whether we need explicit objective coords.
		if st and st.status == "inprogress" and C_QuestLog and C_QuestLog.GetNextWaypoint then
			local okWp, mapID, x, y = pcall(C_QuestLog.GetNextWaypoint, st.activeQuestID)
			if okWp and mapID then
				local canPlace = "?"
				if C_Map and C_Map.CanSetUserWaypointOnMap then
					local okC, v = pcall(C_Map.CanSetUserWaypointOnMap, mapID)
					canPlace = okC and tostring(v) or "err"
				end
				print(("  active %d nextWaypoint -> map %s  %.1f/%.1f  canPlaceWaypoint=%s"):format(
					st.activeQuestID, tostring(mapID), (x or 0) * 100, (y or 0) * 100, canPlace))
			else
				print(("  active %d nextWaypoint -> none (game has no waypoint for this objective)"):format(st.activeQuestID))
			end
			local superID = C_SuperTrack and C_SuperTrack.GetSuperTrackedQuestID and C_SuperTrack.GetSuperTrackedQuestID() or nil
			print(("  currently super-tracked quest = %s"):format(tostring(superID)))
		end
	end

	-- Also list every quest currently in the log with its ID, so an accepted campaign
	-- quest can be identified by name and its real ID captured — no macro needed.
	if C_QuestLog and C_QuestLog.GetNumQuestLogEntries and C_QuestLog.GetInfo then
		print(p .. "quests in your log (accept the campaign quest first):")
		local n = select(1, C_QuestLog.GetNumQuestLogEntries()) or 0
		local shown = 0
		for i = 1, n do
			local ok, info = pcall(C_QuestLog.GetInfo, i)
			if ok and info and not info.isHeader and info.questID and info.questID > 0 then
				shown = shown + 1
				print(("  |cff71d5ff%d|r  %s"):format(info.questID, tostring(info.title or "?")))
			end
		end
		if shown == 0 then
			print("  (none)")
		end
	end
end
