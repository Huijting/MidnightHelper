--[[
	Midnight Helper — Season transition logic (Design Spec 05).
	Two-phase, signal-driven S1→S2 checklist:
	  Phase A "closing"  — while 12.0.7 / M+ Season 1 is live (finish-before-reset).
	  Phase B "prep"     — once the client is on 12.1 (lead-in, unlock, alts).
	  Phase C "season"   — once C_MythicPlus confirms the S2 season id is live.

	The interface build flips exactly on patch day; the M+ season id flips exactly
	when S2 opens (~1 week later). Until an id is known/verified, we never claim it.

	Public API (Home-compatible, like ns.GetResetRoutineSteps):
	  ns.GetSeasonPhase()               -> "closing" | "prep" | "season"
	  ns.GetSeasonTransitionSteps()     -> { { text, color, status, onClick }, ... }
	  ns.ToggleSeasonManual(id)         -> flip a manual-tick item
	  ns.PrintSeasonTransitionDiagnostics()  -> /mh season (verifies ids in-game)
]]

local _, ns = ...

-- ---------------------------------------------------------------- phase detection
local function ClientBuild()
	return select(4, GetBuildInfo()) or 0 -- interface number, e.g. 120007
end

local function IsPatchLive()
	local b = ns.SEASON2 and ns.SEASON2.patchInterface
	return b ~= nil and ClientBuild() >= b
end

-- Phase names kept for the existing checklist UI; the shared truth now lives in
-- SeasonTransitionData (ns.GetSeason2State), so every gate agrees.
function ns.GetSeasonPhase()
	local state = ns.GetSeason2State and ns.GetSeason2State() or "hidden"
	if state == "live" then
		return "season"
	elseif state == "preview" then
		return "prep"
	end
	return "closing"
end

-- Newcomer = a character that provably did NOT engage Season 1. never-lie: we only
-- ever conclude "not a newcomer" from a real signal (an M+ score). A zero score does
-- NOT prove they skipped S1 (they may have raided), so we return nil (uncertain) and
-- the UI keeps showing the checklist WITH a dismiss — never a silent hide on a guess.
-- Returns (isNewcomer, mplusScore): false = engaged S1; nil = uncertain.
function ns.IsSeasonNewcomer()
	local score = 0
	if C_MythicPlus and C_MythicPlus.GetOverallDungeonScore then
		score = C_MythicPlus.GetOverallDungeonScore() or 0
	end
	if score and score > 0 then
		return false, score
	end
	return nil, score
end

--- Has this account ever provably engaged with endgame?
---
--- IsSeasonNewcomer above can only ever prove the NEGATIVE: a Mythic+ score means
--- you played, no score means nothing at all. So this is the only direction the
--- signal supports, and it is the one worth acting on -- we never claim someone is
--- new, we only stop pushing a beginner roadmap at someone we can prove is not.
---
--- ⚠️ THE OBSERVATION IS REMEMBERED, and it has to be. `GetOverallDungeonScore`
--- is per SEASON: it resets to 0 the moment Season 2 opens. Reading it live would
--- hand the "new player" block back to every veteran on exactly the day the new
--- season starts. Having once had a score is a fact about the player that does not
--- become false, so it is recorded once and kept.
---
--- Account-wide on purpose (MidnightHelperDB has no per-character split): a fresh
--- alt belongs to a player who already knows the game.
--- @return boolean
function ns.HasProvenSeasonExperience()
	ns.db = ns.db or {}
	if ns.db.provenSeasonExperience then
		return true
	end
	-- Signal 1: a Mythic+ score. Proves group endgame.
	local engaged = ns.IsSeasonNewcomer()
	if engaged == false then -- false means "provably played"; nil means "unknown"
		ns.db.provenSeasonExperience = true
		return true
	end

	-- Signal 2: a finished Delver's Journey. Added 2026-07-27 after the first
	-- version reported "unknown" for Rob -- an expert player, months into Midnight,
	-- with the Journey complete and three "of the Dawn" achievements. He simply had
	-- not run keys this season. One narrow signal is not experience; it is one kind
	-- of experience, and choosing it made the feature not fire for the person it was
	-- built for.
	--
	-- `maxed` comes from the game's own HasMaximumRenown, so there is no invented
	-- threshold. A rank cut-off like "rank >= 4 means experienced" would be exactly
	-- the kind of made-up number this addon does not ship: nobody could say why 4.
	-- Unreadable stays unproven -- nil is not a zero.
	if ns.GetDelverJourneyStatus then
		local st = ns.GetDelverJourneyStatus()
		if st and st.readable and st.maxed then
			ns.db.provenSeasonExperience = true
			return true
		end
	end

	return false
end

-- ---------------------------------------------------------------- status resolvers
-- Each returns status ("done"/"todo"/"unknown") and, where it can, a resolved name
-- so /mh season can prove the id maps to the intended achievement/quest.
local function achievStatus(id)
	if not id then
		return "unknown"
	end
	local _, name, _, completed = GetAchievementInfo(id)
	if not name then
		return "unknown"
	end
	return completed and "done" or "todo", name
end

local function questStatus(id)
	if not id or not C_QuestLog then
		return "unknown"
	end
	local name
	if C_QuestLog.GetTitleForQuestID then
		name = C_QuestLog.GetTitleForQuestID(id)
	end
	local done = C_QuestLog.IsQuestFlaggedCompleted and C_QuestLog.IsQuestFlaggedCompleted(id)
	return (done and "done" or "todo"), name
end

local function mountStatus(id)
	if not id or not C_MountJournal or not C_MountJournal.GetMountInfoByID then
		return "unknown"
	end
	local info = { C_MountJournal.GetMountInfoByID(id) }
	local name, collected = info[1], info[11]
	if name == nil and collected == nil then
		return "unknown"
	end
	return (collected and "done" or "todo"), name
end

-- ---------------------------------------------------------------- manual ticks (SV)
local function sdb()
	MidnightHelperDB = MidnightHelperDB or {}
	local t = MidnightHelperDB.seasonTransition
	if type(t) ~= "table" then
		t = { manualDone = {}, dismissedCard = false, lastPhase = "closing" }
		MidnightHelperDB.seasonTransition = t
	end
	t.manualDone = t.manualDone or {}
	return t
end

-- status ("done"/"todo"/"unknown") + optional resolved name for one item.
local function itemStatus(item)
	if item.achiev then
		return achievStatus(item.achiev)
	elseif item.quest then
		return questStatus(item.quest)
	elseif item.mount then
		return mountStatus(item.mount)
	elseif item.journey then
		-- A track, not a goal: it is never "done" while the season is still running,
		-- so the best honest answer is "there is still something to gain here".
		-- Unreadable stays "unknown" — we never claim a rank we could not read, and
		-- never call it finished.
		local st = ns.GetDelverJourneyStatus and ns.GetDelverJourneyStatus()
		if not st or not st.readable then
			return "unknown"
		end
		-- A finished track IS done. The first version returned "todo" unconditionally
		-- on the assumption that a track never completes while the season runs; Rob was
		-- sitting on rank 10 / 4200-4200 and still being told to go finish it.
		return st.maxed and "done" or "todo"
	elseif item.dawn then
		-- Unlike the journey, this one CAN be finished: all five earned is genuinely
		-- done. nil means the achievement API said nothing, which is "unknown" —
		-- never "you have them all".
		local d = ns.GetNextDawnAchievement and ns.GetNextDawnAchievement()
		if not d then
			return "unknown"
		end
		return d.allDone and "done" or "todo"
	end
	-- manual: only ever "done" (hand-ticked) or "unknown" (awaiting a tick) — never
	-- an auto "todo" we can't back up.
	return sdb().manualDone[item.id] and "done" or "unknown"
end

function ns.ToggleSeasonManual(id)
	local t = sdb()
	if t.manualDone[id] then
		t.manualDone[id] = nil
	else
		t.manualDone[id] = true
	end
	if ns.RefreshHomePanel then
		ns.RefreshHomePanel()
	end
	return t.manualDone[id] == true
end

-- Dismiss: the Home card can be hidden, but it comes back on a phase change (a new
-- phase is new, relevant information the player should see once).
local function phaseGate()
	local t = sdb()
	local phase = ns.GetSeasonPhase()
	if t.lastPhase ~= phase then
		t.lastPhase = phase
		t.dismissedCard = false
	end
	-- ALSO un-hide when the checklist itself grew. Rob dismissed this card weeks ago
	-- when it held three items he did not care about; two more were added since
	-- (Delver's Journey, "of the Dawn") and Blizzard has now announced the season is
	-- ending — yet the card stayed hidden, because only a PHASE change brought it
	-- back and that does not happen until patch day, which is too late to act on.
	--
	-- So: a new item is new information, exactly like a new phase. Items the player
	-- already dismissed stay dismissed; the count only ever grows the card back once.
	local list = ns.SEASON_TRANSITION and ns.SEASON_TRANSITION[phase == "closing" and "closing" or "prep"]
	local count = (type(list) == "table") and #list or 0
	if count > 0 then
		if type(t.lastItemCount) ~= "number" then
			-- No baseline yet, which means this build introduced the counter. Anyone
			-- who dismissed the card did so against a SHORTER list than they have now
			-- (the closing checklist went from three items to five), so recording the
			-- current count silently would help exactly nobody. Show it once instead;
			-- the dismiss button is right there and from here on the count decides.
			t.lastItemCount = count
			t.dismissedCard = false
		elseif count > t.lastItemCount then
			t.lastItemCount = count
			t.dismissedCard = false
		elseif count < t.lastItemCount then
			t.lastItemCount = count -- shrank (phase switch): just track it
		end
	end
	return phase, t
end

function ns.IsSeasonCardDismissed()
	local _, t = phaseGate()
	return t.dismissedCard == true
end

function ns.DismissSeasonCard()
	local t = sdb()
	t.dismissedCard = true
	if ns.RefreshHomePanel then
		ns.RefreshHomePanel()
	end
end

-- ---------------------------------------------------------------- Home-compatible steps
local function L(key)
	return (ns.L and ns:L(key)) or key
end

-- color: good (done) | warn (closing todo, door closing) | soft (prep todo) | dim (manual/unknown)
function ns.GetSeasonTransitionSteps()
	local phase = ns.GetSeasonPhase()
	local steps = {}

	local function push(item, todoColor)
		local status = itemStatus(item)
		local color = (status == "done") and "good" or (status == "todo" and todoColor or "dim")
		local text = L(item.textKey)
		-- A journey item names the rank you are actually on, so the line is about YOUR
		-- progress rather than a generic reminder. Only when it could be read: the
		-- generic text stands in otherwise, never "rank 0".
		if item.journey then
			local st = ns.GetDelverJourneyStatus and ns.GetDelverJourneyStatus()
			if st and st.readable then
				-- Finished: say so, instead of urging them to finish it.
				local key = st.maxed and "ST_CLOSE_JOURNEY_DONE" or "ST_CLOSE_JOURNEY_AT"
				text = (L(key)):format(st.rank)
			end
		end
		-- Name the next tier still open, in the game's own wording. With none left the
		-- generic line stands and the status already reads "done".
		if item.dawn then
			local d = ns.GetNextDawnAchievement and ns.GetNextDawnAchievement()
			if d and d.name then
				text = (L("ST_CLOSE_DAWN_AT")):format(d.name, d.remaining)
			end
		end
		local onClick
		if item.manual then
			onClick = function()
				ns.ToggleSeasonManual(item.id)
			end
		end
		steps[#steps + 1] = { text = text, color = color, status = status, onClick = onClick }
	end

	if phase == "closing" then
		for _, item in ipairs(ns.SEASON_TRANSITION.closing) do
			push(item, "warn") -- the door is closing → higher urgency
		end
	else
		for _, item in ipairs(ns.SEASON_TRANSITION.prep) do
			push(item, "soft")
		end
		if phase == "prep" then
			steps[#steps + 1] = { text = L("ST_SEASON_SOON"), color = "soft" }
		end
	end

	return steps
end

-- ---------------------------------------------------------------- /mh season diagnostic
function ns.PrintSeasonTransitionDiagnostics()
	local prefix = ("|cffffcc00%s|r"):format(L("PRINT_PREFIX"))
	local phase = ns.GetSeasonPhase()
	print(("%s Season transition — phase |cffffffff%s|r"):format(prefix, phase))
	-- Without this line the newcomer wiring is unobservable: a player who dismissed
	-- the onboarding block months ago sees no difference either way, and a change
	-- nobody can observe is a change nobody can verify.
	local engaged, score = ns.IsSeasonNewcomer()
	local journey = ns.GetDelverJourneyStatus and ns.GetDelverJourneyStatus()
	local journeyProof = (journey and journey.readable and journey.maxed) and true or false
	local verdict = (engaged == false or journeyProof) and "provably played"
		or "unknown (neither signal proves anything)"
	print(("   endgame experience: %s · remembered %s"):format(
		verdict, tostring(ns.db and ns.db.provenSeasonExperience or false)))
	print(("      M+ score %s%s · Delver's Journey %s"):format(
		tostring(score), (engaged == false) and " (proof)" or "",
		journey and journey.readable
			and (("rank %d%s"):format(journey.rank, journey.maxed and " complete (proof)" or ""))
			or "unreadable"))
	print(("   -> new-player block on This Week: %s"):format(
		(ns.HasProvenSeasonExperience and ns.HasProvenSeasonExperience()) and "hidden"
			or ((ns.db and ns.db.onboardingDismissed) and "dismissed by you" or "shown")))
	print(("   client build %d · 12.1 gate %s · S2 M+ season id %s"):format(
		ClientBuild(),
		tostring(ns.SEASON2 and ns.SEASON2.patchInterface),
		tostring(ns.SEASON2 and ns.SEASON2.mplusSeasonId)
	))
	-- The live season number, straight from the game. Capture this on Season 1 so
	-- the gate can be self-learning ("a season higher than S1 means S2 is live")
	-- instead of needing someone present at the flip to read the new id.
	local liveSeason = "n/a"
	if C_MythicPlus and C_MythicPlus.GetCurrentSeason then
		local ok, cur = pcall(C_MythicPlus.GetCurrentSeason)
		liveSeason = ok and tostring(cur) or "error"
	end
	print(("   |cff40c040LIVE M+ season id (from the game): %s|r · S1 recorded as %s"):format(
		liveSeason,
		tostring(ns.SEASON2 and ns.SEASON2.s1MplusSeasonId)
	))
	local newcomer, score = ns.IsSeasonNewcomer()
	print(("   season newcomer: %s (M+ score %s) · card dismissed: %s"):format(
		newcomer == false and "no" or (newcomer == nil and "unknown" or "yes"),
		tostring(score),
		tostring(ns.IsSeasonCardDismissed and ns.IsSeasonCardDismissed())
	))

	local function report(label, list)
		print(("   |cffe8c36a%s|r"):format(label))
		for _, item in ipairs(list) do
			local status, name = itemStatus(item)
			local src = item.achiev and ("ach " .. item.achiev)
				or item.quest and ("quest " .. item.quest)
				or item.mount and ("mount " .. item.mount)
				or item.journey and "journey"
				or item.dawn and "dawn"
				or "manual"
			local mark = (status == "done") and "|cff44ff44done|r"
				or (status == "todo") and "|cffffcc00todo|r"
				or "|cff888888unknown|r"
			-- Show the line the PLAYER gets, not the raw key: a journey item renders
			-- its live rank via ST_CLOSE_JOURNEY_AT, so printing L(textKey) here made
			-- the diagnostic disagree with This Week (Rob, PTR 2026-07-24). This is the
			-- tool used to verify — it must match what is on screen.
			local text = L(item.textKey)
			if item.journey then
				local st = ns.GetDelverJourneyStatus and ns.GetDelverJourneyStatus()
				if st and st.readable then
					text = (L(st.maxed and "ST_CLOSE_JOURNEY_DONE" or "ST_CLOSE_JOURNEY_AT")):format(st.rank)
				end
			end
			if item.dawn then
				local d = ns.GetNextDawnAchievement and ns.GetNextDawnAchievement()
				if d and d.name then
					text = (L("ST_CLOSE_DAWN_AT")):format(d.name, d.remaining)
				end
			end
			print(("     • %-8s %-12s %s  → %s%s"):format(
				item.id, src, mark, text,
				name and ("  |cff888888[" .. name .. "]|r") or ""
			))
		end
	end

	report("closing (Season 1)", ns.SEASON_TRANSITION.closing)
	report("prep (Season 2)", ns.SEASON_TRANSITION.prep)
	print("   Verify each resolved [name] matches the intended reward before it is trusted.")
end
