--[[
	Midnight Helper — Ritual Coach data (Midnight 12.0.5).

	Fase 1 (data + EN/NL content). Body text lives in Locales/RitualTips.lua.
	Mirrors the Delve Coach model (DelveTipsData.lua): entries hold ids + section
	{titleKey, bodyKey} pairs; the actual text always comes from the locale pack,
	so the future cross-locale share carries only ids, never text.

	Three kinds of content:
	  A. RITUAL_SITE_ENTRIES   — the two rotating sites (linked to RitualSites.lua
	     SITES via siteKey, so coords/detection stay single-sourced).
	  B. RITUAL_CHALLENGES     — the 8 modifiers; each is a self-contained tip unit.
	  C. RITUAL_COACH_INTRO    — one "how it works" entry (tiers / scoring / weekly
	     / regen orbs).

	Verified in-game (Rob, obelisk @ Daggerspine, 8 Jun 2026):
	  - Spoils % per challenge confirmed straight off the obelisk tooltips — these
	    match the Blizzard 12.0.5 news post (NOT the guide aggregators). Stored in
	    `spoilsPct`.
	  - `spellId` / `iconId` are the obelisk challenge spell + its icon. The icon
	    drives the coach UI; `spellId` is also the cleanest unlock signal: a learned
	    challenge reads "Right click to unlearn" (IsPlayerSpell(spellId) true) vs an
	    unlearned one "Click to learn". Fase 4 uses IsPlayerSpell over quest flags.
	  - 2nd currency confirmed = Voidlight Marl (not Dark Particles/Duskglow Marl).

	⚠️ still thin (never-lie): boss names and per-scenario routes stay generic —
	  the Daggerspine obelisk showed scenario "A Strike From the Sea" (antagonist
	  Selen'vjar), captured in the PHASES text, but the actual final-boss kill and
	  whether a second scenario layout exists are still to confirm.
]]

local _, ns = ...

-- C. "How it works" intro -----------------------------------------------------
ns.RITUAL_COACH_INTRO = {
	id = "howitworks",
	nameKey = "RITUAL_COACH_INTRO_NAME",
	sections = {
		{ titleKey = "RITUAL_COACH_SEC_TIERS", bodyKey = "RITUAL_TIP_INTRO_TIERS" },
		{ titleKey = "RITUAL_COACH_SEC_SCORING", bodyKey = "RITUAL_TIP_INTRO_SCORING" },
		{ titleKey = "RITUAL_COACH_SEC_WEEKLY", bodyKey = "RITUAL_TIP_INTRO_WEEKLY" },
		{ titleKey = "RITUAL_COACH_SEC_ORBS", bodyKey = "RITUAL_TIP_INTRO_ORBS" },
	},
}

-- A. Sites --------------------------------------------------------------------
-- siteKey matches the key in RitualSites.lua SITES (daggerspine / brokenthrone).
ns.RITUAL_SITE_ENTRIES = {
	{
		id = "daggerspine",
		siteKey = "daggerspine",
		nameKey = "RITUAL_COACH_SITE_DAGGERSPINE",
		sections = {
			{ titleKey = "RITUAL_COACH_SEC_OVERVIEW", bodyKey = "RITUAL_TIP_DAGGERSPINE_OVERVIEW" },
			{ titleKey = "RITUAL_COACH_SEC_PHASES", bodyKey = "RITUAL_TIP_DAGGERSPINE_PHASES" },
			{ titleKey = "RITUAL_COACH_SEC_NOTES", bodyKey = "RITUAL_TIP_DAGGERSPINE_NOTES" },
		},
	},
	{
		id = "brokenthrone",
		siteKey = "brokenthrone",
		nameKey = "RITUAL_COACH_SITE_BROKENTHRONE",
		sections = {
			{ titleKey = "RITUAL_COACH_SEC_OVERVIEW", bodyKey = "RITUAL_TIP_BROKENTHRONE_OVERVIEW" },
			{ titleKey = "RITUAL_COACH_SEC_PHASES", bodyKey = "RITUAL_TIP_BROKENTHRONE_PHASES" },
			{ titleKey = "RITUAL_COACH_SEC_NOTES", bodyKey = "RITUAL_TIP_BROKENTHRONE_NOTES" },
		},
	},
}

-- B. Challenges (the 8 modifiers) ---------------------------------------------
-- spoilsPctCandidate = value from the Blizzard 12.0.5 news post; NOT displayed.
ns.RITUAL_CHALLENGES = {
	{
		id = "tendrils",
		nameKey = "RITUAL_CHAL_TENDRILS",
		spoilsPct = 10, spellId = 1278771, iconId = 537022,
		sections = {
			{ titleKey = "RITUAL_COACH_SEC_MECHANIC", bodyKey = "RITUAL_TIP_TENDRILS_MECHANIC" },
			{ titleKey = "RITUAL_COACH_SEC_UNLOCK", bodyKey = "RITUAL_TIP_TENDRILS_UNLOCK" },
		},
	},
	{
		id = "manifestations",
		nameKey = "RITUAL_CHAL_MANIFESTATIONS",
		spoilsPct = 15, spellId = 1278786, iconId = 4631365,
		sections = {
			{ titleKey = "RITUAL_COACH_SEC_MECHANIC", bodyKey = "RITUAL_TIP_MANIFESTATIONS_MECHANIC" },
			{ titleKey = "RITUAL_COACH_SEC_UNLOCK", bodyKey = "RITUAL_TIP_MANIFESTATIONS_UNLOCK" },
		},
	},
	{
		id = "alarmbells",
		nameKey = "RITUAL_CHAL_ALARMBELLS",
		spoilsPct = 13, spellId = 1278775, iconId = 2065615,
		sections = {
			{ titleKey = "RITUAL_COACH_SEC_MECHANIC", bodyKey = "RITUAL_TIP_ALARMBELLS_MECHANIC" },
			{ titleKey = "RITUAL_COACH_SEC_UNLOCK", bodyKey = "RITUAL_TIP_ALARMBELLS_UNLOCK" },
		},
	},
	{
		id = "malevolentboons",
		nameKey = "RITUAL_CHAL_MALEVOLENTBOONS",
		spoilsPct = 20, spellId = 1278772, iconId = 442737,
		sections = {
			{ titleKey = "RITUAL_COACH_SEC_MECHANIC", bodyKey = "RITUAL_TIP_MALEVOLENTBOONS_MECHANIC" },
			{ titleKey = "RITUAL_COACH_SEC_UNLOCK", bodyKey = "RITUAL_TIP_MALEVOLENTBOONS_UNLOCK" },
		},
	},
	{
		id = "taintedcorpses",
		nameKey = "RITUAL_CHAL_TAINTEDCORPSES",
		spoilsPct = 10, spellId = 1282739, iconId = 463286,
		sections = {
			{ titleKey = "RITUAL_COACH_SEC_MECHANIC", bodyKey = "RITUAL_TIP_TAINTEDCORPSES_MECHANIC" },
			{ titleKey = "RITUAL_COACH_SEC_UNLOCK", bodyKey = "RITUAL_TIP_TAINTEDCORPSES_UNLOCK" },
		},
	},
	{
		id = "reinforced",
		nameKey = "RITUAL_CHAL_REINFORCED",
		spoilsPct = 15, spellId = 1278773, iconId = 6712962,
		sections = {
			{ titleKey = "RITUAL_COACH_SEC_MECHANIC", bodyKey = "RITUAL_TIP_REINFORCED_MECHANIC" },
			{ titleKey = "RITUAL_COACH_SEC_UNLOCK", bodyKey = "RITUAL_TIP_REINFORCED_UNLOCK" },
		},
	},
	{
		id = "patrols",
		nameKey = "RITUAL_CHAL_PATROLS",
		spoilsPct = 15, spellId = 1282714, iconId = 442272,
		sections = {
			{ titleKey = "RITUAL_COACH_SEC_MECHANIC", bodyKey = "RITUAL_TIP_PATROLS_MECHANIC" },
			{ titleKey = "RITUAL_COACH_SEC_UNLOCK", bodyKey = "RITUAL_TIP_PATROLS_UNLOCK" },
		},
	},
	{
		id = "embers",
		nameKey = "RITUAL_CHAL_EMBERS",
		spoilsPct = 25, spellId = 1278780, iconId = 3578234,
		sections = {
			{ titleKey = "RITUAL_COACH_SEC_MECHANIC", bodyKey = "RITUAL_TIP_EMBERS_MECHANIC" },
			{ titleKey = "RITUAL_COACH_SEC_UNLOCK", bodyKey = "RITUAL_TIP_EMBERS_UNLOCK" },
		},
	},
}

-- Convenience lookups (consumed by the coach panel in fase 2).
function ns.GetRitualChallengeById(id)
	if not id then
		return nil
	end
	for _, c in ipairs(ns.RITUAL_CHALLENGES) do
		if c.id == id then
			return c
		end
	end
	return nil
end

function ns.GetRitualSiteEntryByKey(siteKey)
	if not siteKey then
		return nil
	end
	for _, e in ipairs(ns.RITUAL_SITE_ENTRIES) do
		if e.siteKey == siteKey then
			return e
		end
	end
	return nil
end
