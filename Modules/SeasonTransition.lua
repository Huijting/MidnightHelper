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
			-- ST_SEASON_SOON carries a hardcoded Season 2 date, which it may do
			-- because Blizzard published it on 30 jul. It is only ever shown in the
			-- "prep" phase -- the window between the patch and the season opening --
			-- so it retires itself the moment the season goes live. It DOES have to
			-- be rewritten for Season 3; there is no mechanism that will notice.
			steps[#steps + 1] = { text = L("ST_SEASON_SOON"), color = "soft" }
		end
	end

	return steps
end

-- ---------------------------------------------------------------- /mh season diagnostic
--- When does the gate open for THIS player, in their own region?
---
--- ⚠️ Added 17 aug so the regional fix is checkable BEFORE it fires rather than
--- after. Rob can only reach a Wednesday reset, but Midnight Helper has players on
--- Tuesday resets too, and "wait and see" would test one region and ship for five.
---
--- Prints the arithmetic rather than the verdict: server time, the season date, the
--- client's own seconds-until-reset, and the two resets derived from it. If the last
--- reset is before the season date the season has not turned here, whatever the
--- calendar says — and the line that matters is the one naming the exact moment it
--- will. A wrong answer is then visible today instead of on the day.
local function PrintResetGate(prefix)
	local startsAt = ns.SEASON2 and ns.SEASON2.seasonStartsAt
	if not startsAt then
		return
	end
	local now = (GetServerTime and GetServerTime()) or (time and time()) or 0
	local secs
	if C_DateAndTime and C_DateAndTime.GetSecondsUntilWeeklyReset then
		local ok, v = pcall(C_DateAndTime.GetSecondsUntilWeeklyReset)
		if ok and type(v) == "number" and v > 0 then
			secs = v
		end
	end

	local function When(ts)
		return (date and date("!%Y-%m-%d %H:%M UTC", ts)) or tostring(ts)
	end

	print(("   |cff8fd3ffreset gate|r  now %s · season date %s"):format(
		When(now), When(startsAt)))

	if not secs then
		-- The one branch that would fail silently: no API, so the bare date decides
		-- and Europe is a day early again. Say it out loud.
		print("      |cffff5040GetSecondsUntilWeeklyReset unavailable|r — falling back to the")
		print("      |cffff5040bare date, which is about a day early outside the Americas.|r")
		return
	end

	local nextReset = now + secs
	local lastReset = nextReset - (7 * 24 * 60 * 60)
	print(("      your resets: last %s · next %s"):format(When(lastReset), When(nextReset)))

	if now < startsAt then
		print(("      |cffffd100not yet: the season date has not passed.|r Opens for you at %s."):format(
			When(nextReset >= startsAt and nextReset or startsAt)))
	elseif lastReset < startsAt then
		print(("      |cffffd100not yet: no reset since the season date.|r Opens for you at %s."):format(
			When(nextReset)))
	else
		print(("      |cff40d060open|r — your reset at %s was on or after the season date."):format(
			When(lastReset)))
	end
end

function ns.PrintSeasonTransitionDiagnostics()
	local prefix = ("|cffffcc00%s|r"):format(L("PRINT_PREFIX"))
	local phase = ns.GetSeasonPhase()
	print(("%s Season transition — phase |cffffffff%s|r"):format(prefix, phase))
	PrintResetGate(prefix)
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

	--- ⚠️ THE DATE IS PART OF THE GATE SINCE 12 Aug, AND THIS DID NOT SHOW IT.
	---
	--- On patch day the self-learning fallback ("any M+ season newer than 17") opened
	--- Season 2 six days early, because that number increments with the PATCH. The gate
	--- now also requires `SEASON2.seasonStartsAt`. A diagnostic that reports the season
	--- id but not the date cannot tell you whether the gate is holding — which is the
	--- only question worth asking in the days before a season opens.
	local state = ns.GetSeason2State and ns.GetSeason2State() or "?"
	--- ⚠️ This line used to count down to `seasonStartsAt` itself, which put two
	--- different opening moments on one screen the moment the reset gate landed above
	--- it: "opens 18 Aug 00:00 UTC — 0.7 days away" directly under "opens for you at
	--- 19 Aug 03:59 UTC". Rob's own screenshot, 17 aug.
	---
	--- Both numbers were true about different things and that is exactly what makes it
	--- a bug: a reader has to know which of the two the addon actually obeys. It obeys
	--- the reset, so that is the one that gets counted down to, and the bare date is
	--- named as what it is — the earliest it could happen anywhere.
	local startsAt = ns.SEASON2 and ns.SEASON2.seasonStartsAt
	local now = (GetServerTime and GetServerTime()) or (time and time()) or 0
	local when = "not set"
	if startsAt then
		-- The moment this player's gate actually opens: their first reset on or after
		-- the season date, or the date itself if their reset already covers it.
		local opensAt = startsAt
		if C_DateAndTime and C_DateAndTime.GetSecondsUntilWeeklyReset then
			local ok, secs = pcall(C_DateAndTime.GetSecondsUntilWeeklyReset)
			if ok and type(secs) == "number" and secs > 0 then
				local nextReset = now + secs
				local lastReset = nextReset - (7 * 24 * 60 * 60)
				if lastReset < startsAt then
					opensAt = nextReset
				else
					opensAt = lastReset
				end
			end
		end
		local left = opensAt - now
		if left > 0 then
			when = ("%s UTC — %.1f days away"):format(
				date("!%d %b %H:%M", opensAt), left / 86400)
		else
			when = ("%s UTC — passed"):format(date("!%d %b %H:%M", opensAt))
		end
		if opensAt ~= startsAt then
			when = when .. (" (season date %s UTC, earliest anywhere)"):format(
				date("!%d %b %H:%M", startsAt))
		end
	end
	print(("   |cffffd100Season 2 gate: %s|r · opens %s"):format(state, when))
	if state == "preview" then
		print("   |cff8a8f98\"preview\" is correct before the season opens: S2 content may be|r")
		print("   |cff8a8f98listed and labelled, never presented as something you can do.|r")
	elseif state == "live" and startsAt and now < startsAt then
		print("   |cffff5040LIVE before the start date — the date gate is not being applied.|r")
	end
	-- The experience verdict is printed once, at the top. This line used to repeat it
	-- from ns.IsSeasonNewcomer alone and so reported "unknown" three lines under a
	-- "provably played" that had been carried by a different signal (Rob, 2026-07-27).
	-- One question, one answer: this line now only reports the card.
	print(("   season card dismissed: %s"):format(
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
