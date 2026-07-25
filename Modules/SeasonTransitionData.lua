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
	-- "opens ~1 week after the patch" instead of as an action. Fill from
	-- C_MythicPlus.GetCurrentSeason() once it returns the new id.
	mplusSeasonId = nil,

	-- Season 1's M+ season id, captured on live via `/mh season`. This is what makes
	-- the gate self-learning: once the game reports a season id HIGHER than this,
	-- Season 2 is genuinely open — no need for anyone to be present at the flip to
	-- read the new number. nil = we have not captured it yet, and the gate then
	-- falls back to "patch is live, season is not" rather than guessing.
	-- CAPTURED IN-GAME 2026-07-19 (Rob, live 12.0.7, `/mh season`):
	-- C_MythicPlus.GetCurrentSeason() = 17 while Midnight Season 1 is running.
	s1MplusSeasonId = 17,
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
	local s2 = ns.SEASON2 and ns.SEASON2.mplusSeasonId
	if s2 then
		return live == s2 -- exact id known: use it
	end
	-- Self-learning fallback: any season NEWER than the recorded Season 1 means
	-- Season 2 (or later) has opened, so the gate flips correctly without anyone
	-- being online at the moment the season starts.
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
