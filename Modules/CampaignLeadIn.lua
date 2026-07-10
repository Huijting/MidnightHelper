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

	VALUES TO CONFIRM (source: Wowhead live-content guide, 7 Jul 2026 — treat as ~95%,
	Rob confirms in-game, same tier as HandyNotes coords):
	  - start quest "Hagar's Invitation" = 92895, in central Silvermoon City
	    (uiMap 2393) at ~45.45 / 70.26
	  - reward mount "Dusk Grimlynx" = item 246731 (from an early chapter quest)
	  - reward pet "Akiki" = npc 260149 (whole Chapter 1 complete)
	Run `/mh campaign` in-game to see the live state of these IDs.
]]

local _, ns = ...

-- The chain, in order. Only the start is known today; append confirmed quest IDs as
-- they are captured, and the tracker follows the last incomplete one. `chapter` is
-- display-only. Keep this a plain data table — no logic — so extending it is trivial.
local CAMPAIGN = {
	key = "ulatek_leadin",
	nameKey = "CAMPAIGN_ULATEK_NAME",
	startMapID = 2393, -- Silvermoon City
	startX = 45.45,
	startY = 70.26,
	-- Ordered milestone quests. First entry is the pickup; add the rest as verified.
	chain = {
		{ questID = 92895, nameKey = "CAMPAIGN_ULATEK_STARTQUEST" }, -- Hagar's Invitation
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

--- Route to the campaign: follow the live objective if you are on a chain quest,
--- otherwise head to the pickup in Silvermoon. Reuses the shared quest-route engine,
--- which already falls back to coords when the objective sits somewhere unwaypointable.
function ns.RouteCampaignLeadIn()
	local st = ns.GetCampaignLeadInState()
	if not st then
		return false
	end
	local label = st.name
	if ns.AddSmartQuestRoute then
		return ns.AddSmartQuestRoute(st.activeQuestID, st.startMapID, st.startX, st.startY, label)
	end
	if ns.AddSmartTomTomWay then
		return ns.AddSmartTomTomWay(st.startMapID, st.startX, st.startY, label)
	end
	return false
end

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
