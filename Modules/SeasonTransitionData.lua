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
