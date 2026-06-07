--[[
	Showdowns (12.0.7 "Revelations") — data only, geen UI.
	Rotating Void worlds: Naigtal & Val. Wekelijkse rotatie via portaal in de
	Voidstorm (Screaming Ridge ~51.4, 71.3) of het vaste portaal in Silvermoon
	(Bazaar, zelfde verdieping als de weekly-quest-hub, iets verderop). Weekly "Showdown on <zone>"
	beloont een Riftstalker's Cache en telt mee voor de Great Vault World-rij.
	Heroic World Tier: geen unlock-vereiste, keuze bij het portaal;
	GetInstanceInfo() ret11 (hasWorldTier) is true binnen de zones.

	Bronnen: Wowhead/Blizzard juni 2026 + PTR-verificatie door Rob (6 juni
	2026, zie docs/PTR_12.0.7_DATA.md). Velden met nil zijn bewust leeg tot de
	volgende PTR-rotatie (Val) — UI-code moet daar op nil checken, zelfde
	"never lie"-patroon als VoidAssaults.lua.
]]

local _, ns = ...

ns.SHOWDOWNS = {
	-- Verified op PTR: uiMapID gemeten in Umbral Base Camp; weekly uit questlog.
	zones = {
		{
			key = "naigtal",
			name = "Naigtal", -- fallback-weergavenaam; C_Map-naam wint zodra uiMapID bekend is
			uiMapID = 2600, -- PTR-verified; hele zone (WQ-dump bevestigde dit). Kaart-pad: EK > Quel'Thalas > Voidstorm > Naigtal
			weekly = 96717, -- "Showdown on Naigtal" (PTR-verified). Percentage-quest ("Ethereal Operations Disrupted"): voortgang via GetQuestProgressBarPercent. Questlog-categorie: "Void Assaults"
			worldBossNpcID = 263843, -- Nexus-Captain Leth'ir (Wowhead)
			worldBossQuest = 96472, -- "The Nexus-Captain" killquest (Wowhead PTR-2)
			bossName = "Nexus-Captain Leth'ir",
		},
		{
			key = "val",
			name = "Val",
			uiMapID = nil, -- TODO: volgende PTR-rotatie (zie docs/PTR_12.0.7_DATA.md)
			weekly = nil, -- TODO: "Showdown on Val"
			worldBossNpcID = 263670, -- Imperator Pertinax (Wowhead)
			worldBossQuest = nil, -- TODO
			bossName = "Imperator Pertinax",
		},
	},

	-- Naigtal-zijquests (chain-detectie / "bezig in zone"-hint).
	naigtalSideQuests = { 96054 }, -- Surveying the Mana-Bog (PTR-verified)

	-- World quests: NIET hardcoden — C_TaskQuest.GetQuestsOnMap(uiMapID) werkt
	-- en levert een roterende pool. PTR-sample 6 juni 2026 (alle mapID 2600,
	-- bevestigt dat 2600 de hele zone dekt): 96623, 96809, 96432, 96660,
	-- 96668, 96293 (96809/96293 hebben isQuestStart=true: vermoedelijk
	-- zone-events i.p.v. reguliere WQ's).

	-- Toegang.
	portalVoidstorm = { mapID = nil, x = 51.4, y = 71.3 }, -- TODO: Voidstorm-uiMapID verifiëren (sta bij portaal, /dump C_Map.GetBestMapForUnit("player"))
	portalSilvermoon = { mapID = 2393, x = 47.93, y = 48.09 }, -- vast portaal (exact midden), zelfde verdieping als de weekly-quest-hub in de Bazaar, iets verderop (PTR-verified 7 juni 2026, Rob)
	introNpc = { name = "Riftblade Maella", mapID = 2393, x = 27.48, y = 76.51 },

	-- Beloningen/currency (gedeeld met Void Assaults).
	fieldAccoladeCurrency = 3405,
	riftstalkersCacheItem = 275690, -- PTR-verified 6 juni 2026. Weekly telt mee voor Great Vault World-rij (type 6, progress liep op na turn-in).
}
