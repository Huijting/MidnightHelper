--[[
	Curse of Ula'tek — campaign lead-in tracker.

	Patch 12.1's lead-in campaign went LIVE in 12.0.7 with the weekly reset of 7 July
	2026 (Blizzard front-loads it so players are ready when 12.1 lands). It is the
	prerequisite gate for the Coiled Isle. Because it is live, every ID here can be —
	and must be — confirmed in-game rather than trusted from datamine.

	HONESTY BY CONSTRUCTION. This block appears only when the live quest API says the
	start quest exists and is not yet completed. If the configured quest ID were wrong,
	`IsQuestFlaggedCompleted` would answer for a quest that never applies to this
	character, so the guard below (needs GetTitleForQuestID to actually name it) keeps a
	bogus ID from parking a permanent, false "go do this" nudge on the dashboard. The
	arrow follows the live objective through AddSmartQuestRoute, so once you are on the
	quest the route is Blizzard's own waypoint, not our fallback coords.

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
	Run `/mh campaign` in-game to see the live state of every chain ID.
]]

local _, ns = ...

-- The chain, in order (Chapter 1 spine, from Zygor's Ula'tek guide, cross-checked with
-- the live quest API on Rob's character). The tracker follows the first incomplete one;
-- the block hides when all are done. Plain data — extend by appending IDs.
local CAMPAIGN = {
	key = "ulatek_leadin",
	nameKey = "CAMPAIGN_ULATEK_NAME",
	startMapID = 2393, -- Silvermoon City
	startX = 45.38, -- Orweyna (npc 253640); Zygor coords, matches Rob's screenshot
	startY = 70.07,
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

--- Live state of the lead-in campaign.
--- @return table|nil {
---   name, status = "available"|"inprogress"|"done",
---   startMapID, startX, startY, activeQuestID, rewards }
---   nil when there is nothing to show (all known steps done, or the start quest ID is
---   not a real quest on this client — do not invent a nudge).
function ns.GetCampaignLeadInState()
	local start = CAMPAIGN.chain[1]
	if not start or not QuestIsReal(start.questID) then
		return nil -- unknown/unconfirmed quest: stay silent rather than guess
	end

	-- The step to point at: the first chain quest not yet completed.
	local activeQuestID, allDone = nil, true
	for _, step in ipairs(CAMPAIGN.chain) do
		if not QuestDone(step.questID) then
			activeQuestID = step.questID
			allDone = false
			break
		end
	end
	if allDone then
		return nil -- every known milestone finished; the nudge has done its job
	end

	local status = OnQuest(activeQuestID) and "inprogress" or "available"
	return {
		name = ns:L(CAMPAIGN.nameKey),
		status = status,
		startMapID = CAMPAIGN.startMapID,
		startX = CAMPAIGN.startX,
		startY = CAMPAIGN.startY,
		activeQuestID = activeQuestID,
		rewards = CAMPAIGN.rewards,
	}
end

-- Quick membership test for the chain, so the accept-handler only ever touches our own
-- quests and never hijacks the player's super-track for something unrelated.
local CHAIN_SET = {}
for _, step in ipairs(CAMPAIGN.chain) do
	CHAIN_SET[step.questID] = true
end

--- Turn on Blizzard's own quest arrow for a quest you are on. This is the reliable way
--- to point at the LIVE objective ("Arrive at the meeting" in Harandar) — the game knows
--- where that is, we do not, and its objective moves zone to zone as the quest advances.
local function SuperTrackQuest(questID)
	if questID and C_SuperTrack and C_SuperTrack.SetSuperTrackedQuestID then
		pcall(C_SuperTrack.SetSuperTrackedQuestID, questID)
	end
end

--- Route to the campaign. On a chain quest: super-track it so Blizzard's arrow follows
--- the live objective, plus a TomTom waypoint for TomTom users. Before you have picked
--- it up: head to Orweyna in Silvermoon. AddSmartQuestRoute already falls back to coords
--- when an objective sits somewhere unwaypointable.
function ns.RouteCampaignLeadIn()
	local st = ns.GetCampaignLeadInState()
	if not st then
		return false
	end
	if st.status == "inprogress" then
		SuperTrackQuest(st.activeQuestID)
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
-- chain, so it never overrides super-tracking for an unrelated quest you pick up.
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
	print(p .. "Curse of Ula'tek lead-in")
	for i, step in ipairs(CAMPAIGN.chain) do
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
	local st = ns.GetCampaignLeadInState()
	print(("  state = %s"):format(st and st.status or "nil (hidden)"))

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
