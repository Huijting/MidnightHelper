--[[
	Midnight Helper — Season transition data (Design Spec 05).
	The item lists + constants for the S1→S2 (patch 12.1 "Curse of Ula'tek")
	transition checklist. Logic lives in Modules/SeasonTransition.lua.

	Never-lie: every item resolves from a real game signal, or it is a manual
	tick — never a guessed "done". IDs marked VERIFY are confirmed in-game via
	/mh season (which prints each item's resolved name) before we trust them.
]]

local _, ns = ...

ns.SEASON2 = {
	-- 12.1.0 → interface 120100 (standard WoW numbering: major*1e4 + minor*1e2).
	-- Safe default: until the client actually reports >= this, GetSeasonPhase()
	-- stays "closing", so nothing S2 is claimed early.
	patchInterface = 120100,

	-- S2 Mythic+ season id — unknown until the season actually opens (~1 week after
	-- the patch). nil = never claim the season is live; S2-season items then show as
	-- "opens ~1 week after the patch" instead of as an action.
	--
	-- ⚠️ DO NOT FILL THIS IN WITH 18. `/mh season` on live, 13 Aug 2026 — five days
	-- BEFORE Season 2 opens — already reports `GetCurrentSeason() = 18`. The number
	-- moves with the patch, not with the season, so 18 does not mean "S2 is live" and
	-- recording it as if it did is how the 12 August bug comes back.
	--
	-- It is only safe to fill once someone has watched the number change AT the season
	-- flip and it turns out to be something other than 18. Until then the date in
	-- `seasonStartsAt` is the gate, and IsSeasonLive() now applies it to this branch too.
	mplusSeasonId = nil,

	-- Season 1's M+ season id, captured on live via `/mh season`. This is what makes
	-- the gate self-learning: once the game reports a season id HIGHER than this,
	-- Season 2 is genuinely open — no need for anyone to be present at the flip to
	-- read the new number. nil = we have not captured it yet, and the gate then
	-- falls back to "patch is live, season is not" rather than guessing.
	-- CAPTURED IN-GAME 2026-07-19 (Rob, live 12.0.7, `/mh season`):
	-- C_MythicPlus.GetCurrentSeason() = 17 while Midnight Season 1 is running.
	s1MplusSeasonId = 17,

	--- ⚠️ THE M+ SEASON ID IS NOT THE SEASON. MEASURED THE HARD WAY, 12 Aug 2026.
	---
	--- The self-learning fallback above reads "any season newer than 17 means Season 2
	--- has opened". On live 12.1 that fired the same day the patch did: `/mh crestscan`
	--- came back with the Currencies page rendering Adventurer..Myth MISTCREST, all at
	--- zero, which only happens when `IsSeason2Live()` is true. Rob confirmed in one
	--- sentence what the addon had already decided for itself: "nog niet open, seizoen 2
	--- begint pas 18 augustus".
	---
	--- So the number increments at PATCH time, not at season start, and the gate the
	--- comment below calls self-learning was learning the wrong lesson. It was written
	--- to stop us announcing S2 content a week LATE; it announced it six days EARLY
	--- instead, hiding the Dawncrests Rob is actually carrying behind five zeroes.
	---
	--- A date is the only signal we have that means what we need it to mean. Rob's, and
	--- he plays this game for a living hours a day — this is his statement, not a
	--- datamined guess.
	---
	--- ⚠️ Falsifier, so this is checkable rather than trusted: 1787011200 is
	--- 2026-08-18 00:00 UTC, which is midnight, not the regional reset. If the season
	--- turns out to open some hours later on that day, or a day later in the EU, this
	--- is early by that much — bounded to one day, where the old gate was out by six.
	--- If Rob reports on 18 Aug that the content is still shut, move this to the reset.
	seasonStartsAt = 1787011200,
}

-- Each item: id (stable key for manual ticks), textKey (locale), and ONE source:
--   achiev = <id>  → GetAchievementInfo (auto done/todo; name resolvable for verify)
--   quest  = <id>  → C_QuestLog.IsQuestFlaggedCompleted
--   mount  = <id>  → C_MountJournal collected flag
--   manual = true  → hand tick (persisted) when no readable signal exists
ns.SEASON_TRANSITION = {
	-- Phase A — things that go away at the S2 reset. Shown while S1 is live.
	closing = {
		-- Keystone Master (S1) → the season-1 M+ mount. Achievement id from Wowhead;
		-- VERIFY the resolved name reads "Keystone Master" via /mh season before trusting.
		{ id = "ksm_s1", textKey = "ST_CLOSE_KSM", achiev = 61256 },
		-- Current-tier raid metas. The active AotC/Cutting Edge achievement id is
		-- ambiguous across sources (Voidspire vs March on Quel'Danas) → hand tick until
		-- confirmed in-game. Never a guessed id.
		{ id = "aotc", textKey = "ST_CLOSE_AOTC", manual = true },
		{ id = "ce", textKey = "ST_CLOSE_CE", manual = true },
		-- Delver's Journey. Not an achievement but a track you are part-way along, so
		-- it gets its own status type (see SeasonTransition's `journey` branch) and
		-- shows the live rank instead of a tick.
		--
		-- ⚠️ IT DOES NOT WARN ABOUT LOSING ANYTHING. Several guide sites claim
		-- unclaimed rewards are lost forever at the season flip. Warcraft Wiki says
		-- otherwise: afterwards they are sold by Telemancer Astrandis with no unlock
		-- requirement, at a much higher Voidlight Marl price. So the honest line is
		-- "finishing now is cheaper than buying later" — a nudge, not an alarm.
		-- Do not let anyone sharpen this wording later.
		{ id = "delver_journey", textKey = "ST_CLOSE_JOURNEY", journey = true },
		-- The five "of the Dawn" item-level achievements (Adventurer → Myth). Blizzard
		-- announced 2026-07-25 that they go away with Season 1, and they are worth more
		-- than a tick: each grants a 50% upgrade discount across the whole Warband.
		--
		-- One line, not five: the tiers are progressive, so the checklist names the next
		-- one still open and stays out of the way once they are all earned. All five
		-- achievement ids were verified in-game — see DawncrestData's header before
		-- doubting the odd-looking 42767-42770.
		{ id = "dawn_achievements", textKey = "ST_CLOSE_DAWN", dawn = true },

		-- ---- Announced 2026-07-25, Blizzard's own "Season 1 ending soon" post ----
		-- Four more things that stop being obtainable at the season flip. Two of them
		-- are a mount and a title, which is the kind of thing people are genuinely
		-- upset to miss, so they belong on this list rather than in a guide page.
		--
		-- ⚠️ ALL FOUR ARE MANUAL TICKS ON PURPOSE. We have the achievement NAMES from
		-- the announcement and no ids, and an achievement cannot be tracked by name
		-- (names are localised -- the Omnium Folio trap). Guessing an id would put a
		-- wrong "done" in front of someone on a deadline, which is the worst possible
		-- place to be wrong.
		--
		-- ⚠️ MEASURED 2026-07-26 (Rob, live client, `/mh ach`): THREE OF THE FOUR NAMES
		-- IN THE ANNOUNCEMENT DO NOT EXIST IN THE CLIENT. "My Shady Nemesis" returns
		-- only Warlord-of-Draenor achievements (9508-9515); "Lighting the Dark" returns
		-- nothing; "Big Prey Hunter" is absent from a 40-hit Prey listing. The article
		-- paraphrased. Do not go looking for those names again -- they are not there.
		--
		-- ❌ REFUTED, SAME DAY: `Let Me Solo It` (61420) looked like the article's "Let
		-- Me Solo Him" -- right era (between Keystone Master 61256 and Prey 61386+),
		-- right joke. Its description is "Dazzle the crowd! Win without a scratch."
		-- That is a Showdown, not a nemesis solo kill. The name matched and the thing
		-- did not, which is exactly why `/mh ach id` exists. Do not re-adopt 61420.
		--
		-- ✅ THE SWEEP PAID OFF, 2026-07-26 (late): `/mh ach ominous` re-run with the
		-- reward-text search AND the id sweep found `Lighting the Dark` = id 61798,
		-- HIDDEN (absent from the 5163-achievement visible tree), todo. It matched on
		-- "ominous", a word that is not in its name -- so the hit came from its
		-- description or reward text, consistent with the announced title "the
		-- Ominous". Sits in Midnight's own id band (KSM 61256, Prey 61386+).
		--
		-- ⚠️ NOT WIRED YET. Run `/mh ach id 61798` and read the criteria first. 61420
		-- looked at least this convincing and turned out to be a Showdown.
		--
		-- ❌ THIS KILLS THE "12.1-datamined, not on live" THEORY. These achievements
		-- ARE on this client; they are hidden, which the category walk cannot see. So
		-- the nemesis pair is probably hidden too rather than absent, and the way to
		-- find it is the sweep with a word from its REWARD or flavour -- not its name.
		-- Untried angles: `/mh ach nullaeus`, `/mh ach nulleaus`, `/mh ach domaneye`,
		-- `/mh ach arcanovoid`. Those last two are the announced reward item names
		-- (263413, 263222) and would settle the nemesis's spelling at the same time.
		--
		-- TO UPGRADE ONE OF THESE TO AUTO-TRACKED: confirm with `/mh ach id <n>` that
		-- the CRITERIA describe the thing we claim -- never the name alone -- then
		-- replace `manual = true` with `achiev = <id>`. achievStatus() takes over.
		--
		-- Prey capstone: `The Deadliest of Prey` (62134) is ❌ REFUTED -- "Complete 5
		-- Prey Hunts in War Mode", i.e. PvP, not the Journey. Still unchecked:
		-- `Preying For Midnight` (62351) and `Gotta Hunt Them All` (62383).
		--
		-- The shown texts name no achievement, on purpose: three of the four names do
		-- not exist here, and putting a name in front of a player that their own
		-- Achievements pane cannot find is the kind of small lie this addon does not
		-- tell. Each line states the ACTION, which Blizzard's post does support.
		--
		-- The nemesis's name is deliberately absent from the shown text: the source
		-- spells it both "Nulleaus" and "Nullaeus" in the same article, and we do not
		-- put a coin-flip in front of the player.
		--
		-- Rewards named in the announcement, UNVERIFIED against the client (item ids
		-- cannot be swept the way currencies can, so these wait for someone to see
		-- them drop): My Shady Nemesis -> item 263413 "Nullaeus Domaneye";
		-- Let Me Solo Him -> mount item 263222 "Arcanovoid Construct";
		-- Lighting the Dark -> title "the Ominous". None of these ids are used below;
		-- they are recorded here so the next session does not have to re-find them.
		-- ✅ FOUND 2026-07-27 by `/mh ach nullaeus` once the spelling was known. All
		-- four are hidden Feats of Strength, invisible to the category walk and only
		-- reachable by the id sweep. Yesterday's conclusion that "My Shady Nemesis"
		-- does not exist was WRONG -- it was hidden, not absent. Note the ids run
		-- 61797/61798/61799 consecutively, with 61808 "Fabled Let Me Solo Him:
		-- Nullaeus" as a fifth we did not know about.
		--
		-- ⚠️ CRITERIA NOT YET READ for these two. Wired anyway because the evidence is
		-- far stronger than the 61420 case that burned us: 61799 names Nullaeus in its
		-- own title, both sit adjacent to the confirmed 61798, and both match the
		-- announcement wording. Still worth one `/mh ach id 61797 61799 61808` -- if a
		-- criterion says something else, unwire rather than reword.
		{ id = "s1_nemesis", textKey = "ST_CLOSE_NEMESIS", achiev = 61797 },
		{ id = "s1_solo", textKey = "ST_CLOSE_SOLO", achiev = 61799 },
		-- ✅ CONFIRMED 2026-07-27 via `/mh ach id 61798`, and it answered three open
		-- questions at once:
		--   name        "Lighting the Dark"
		--   description "Defeat Nullaeus in his lair on Tier ?? before the release of
		--                the next season of delves."
		--   reward      "Title: the Ominous"
		--   points      0  -> a Feat of Strength, which is exactly why the category
		--                     walk could not see it and the id sweep could.
		-- So: the spelling is NULLAEUS, the deadline is real and in Blizzard's own
		-- words, and the title matches the announcement. The "Tier ??" is verbatim
		-- from the client -- do not repeat it to the player as if it were a number.
		{ id = "s1_dark", textKey = "ST_CLOSE_DARK", achiev = 61798 },
		-- ✅ CONFIRMED 2026-07-26 via `/mh ach id 62351`: "Preying For Midnight",
		-- description "Complete the achievements listed below", reward "Title:
		-- Preyseeker", 7 criteria (Gotta Hunt Them All, Look I'm Just Trying To Fish
		-- Here, Trapped In The Middle With You, I Didn't Hear No Bell, Kitchen
		-- Nightmare, Midnight Hunter, You're Trapped In Here With Me). The only one of
		-- the four announced items that survived contact with the client.
		--
		-- ⚠️ WHAT IS VERIFIED IS THE ACHIEVEMENT, NOT THE DEADLINE. Blizzard's post
		-- says Prey progress closes with Season 1; the achievement's own name carries
		-- no "(Season 1)" marker. Given that the same post's naming was wrong three
		-- times over, the shown text promises only the title -- the surrounding card
		-- already carries the "wrap up before Season 2" framing.
		{ id = "s1_prey", textKey = "ST_CLOSE_PREY", achiev = 62351 },
	},
	-- Phase B — the run-up to S2. Shown once the client is on 12.1.
	prep = {
		-- 12.1 lead-in (Hagar's Invitation 92895 → Chapter 1 chain). Live-verified in
		-- CampaignLeadIn; gates the Coiled Isle.
		{ id = "leadin", textKey = "ST_PREP_LEADIN", quest = 92895 },
		-- Coiled Isle unlock signal is unknown until the PTR → manual for now.
		{ id = "isle", textKey = "ST_PREP_ISLE", manual = true },
		{ id = "alts", textKey = "ST_PREP_ALTS", manual = true },
	},
}

--------------------------------------------------------------------------------
-- Shared Season 2 state. Lives HERE, in the data file, because the gates that use
-- it (DungeonRosterData, RaidCoachData, MythicPlusData, TideboundGrottoCoach) run
-- at LOAD time and load before the SeasonTransition UI module — so this file is
-- placed early in the .toc and owns both the constants and the derived state.
--------------------------------------------------------------------------------

local function ClientBuild()
	return select(4, GetBuildInfo()) or 0 -- interface number, e.g. 120007
end

local function IsPatchLive()
	local b = ns.SEASON2 and ns.SEASON2.patchInterface
	return b ~= nil and ClientBuild() >= b
end

local function LiveMplusSeason()
	if C_MythicPlus and C_MythicPlus.GetCurrentSeason then
		local ok, cur = pcall(C_MythicPlus.GetCurrentSeason)
		if ok and type(cur) == "number" and cur > 0 then
			return cur
		end
	end
	return nil
end

local function IsSeasonLive()
	local live = LiveMplusSeason()
	if not live then
		return false
	end

	--- ⚠️ THE DATE GATES EVERYTHING, INCLUDING A KNOWN ID. Read this before "improving" it.
	---
	--- This check used to sit BELOW the `mplusSeasonId` branch, whose comment said "exact
	--- id known: use it, and the date cannot override it". That was written expecting the
	--- known id to be the number the game reports once Season 2 has opened.
	---
	--- It is not. Measured on live 13 Aug 2026, five days before the season starts:
	--- `C_MythicPlus.GetCurrentSeason()` already returns **18**, against 17 for Season 1.
	--- The number moves with the PATCH.
	---
	--- So filling in `mplusSeasonId = 18` — the obvious next step now that we know it, and
	--- exactly what a future session will reach for — would have made `live == s2` true
	--- immediately and thrown the gate open five days early. The same bug as 12 August,
	--- reintroduced by writing down a measurement.
	---
	--- The date now applies to both routes. An id can still REFUSE (a client that never
	--- advanced past Season 1 stays shut) but it can no longer grant on its own.
	--- ⚠️ AND THE DATE ALONE IS A DAY EARLY IN EUROPE. Fixed 17 aug, before it bit.
	---
	--- `seasonStartsAt` is 2026-08-18 00:00 UTC. A season opens at a weekly RESET, and
	--- resets are regional: the Americas turn on Tuesday, Europe on Wednesday morning.
	--- So for Rob, Carola and every EU player this date is roughly 29 hours early —
	--- exactly the falsifier the comment beside `seasonStartsAt` wrote down for itself,
	--- and the watch log confirms it ("18 aug NA, EU-reset 19 aug").
	---
	--- Rather than hardcode two regional timestamps and get one of them wrong, ask the
	--- client when its OWN reset is. `GetSecondsUntilWeeklyReset` is already regional
	--- and already correct, so the question becomes: has a weekly reset happened on or
	--- after the season date? Subtracting one week from the next reset gives the last
	--- one, and if that is still before the season date, the season has not turned here
	--- yet no matter what the calendar says.
	---
	--- This also removes the "someone must be present at the flip" problem entirely: it
	--- is right in every region without anyone measuring anything.
	local startsAt = ns.SEASON2 and ns.SEASON2.seasonStartsAt
	if startsAt then
		local now = (GetServerTime and GetServerTime()) or (time and time()) or 0
		if now < startsAt then
			return false
		end
		local secs
		if C_DateAndTime and C_DateAndTime.GetSecondsUntilWeeklyReset then
			local ok, v = pcall(C_DateAndTime.GetSecondsUntilWeeklyReset)
			if ok and type(v) == "number" and v > 0 then
				secs = v
			end
		end
		if secs then
			-- The most recent reset for THIS region.
			local lastReset = (now + secs) - (7 * 24 * 60 * 60)
			if lastReset < startsAt then
				return false
			end
		end
		-- No reset API: fall back to the bare date. Being a day early in the EU is
		-- still better than never opening at all, and it is the old behaviour.
	end

	local s2 = ns.SEASON2 and ns.SEASON2.mplusSeasonId
	if s2 then
		return live == s2 -- past the date, so the exact id may decide
	end

	local s1 = ns.SEASON2 and ns.SEASON2.s1MplusSeasonId
	if s1 then
		return live > s1
	end
	return false -- neither id known: never claim the season
end

--- Where Season 2 stands, as one shared answer for every gated feature.
--- Replaces five separate copies of `interface >= 120100`, which all treated the
--- PATCH as the season. It is not: Season 2 opens about a week AFTER the patch
--- (watch log, 20 + 25 jun), so those gates would have announced the Venomous
--- Abyss raid, the S2 M+ rotation and the Tidebound Grotto for seven days during
--- which none of them existed.
--- @return string state  "hidden" (pre-patch) | "preview" (patch live, season not) | "live"
function ns.GetSeason2State()
	if IsSeasonLive() then
		return "live"
	end
	if IsPatchLive() then
		return "preview"
	end
	return "hidden"
end

--- Should Season 2 content be listed at all? True from the patch onwards — during
--- the preview week it is shown but labelled, never presented as available.
function ns.IsSeason2Visible()
	return ns.GetSeason2State() ~= "hidden"
end

--- True only when Season 2 is genuinely open and its content can be done.
function ns.IsSeason2Live()
	return ns.GetSeason2State() == "live"
end
