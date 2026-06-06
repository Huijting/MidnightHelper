# PTR 12.0.7 — data nog te verzamelen (Rob, in-game)

Reeds geverifieerd (Wowhead/Blizzard, juni 2026):

| Wat | ID |
|---|---|
| Naigtal zone | 16943 (Wowhead-zone; uiMapID nog nodig) |
| Val zone | 16900 (idem) |
| Nexus-Captain Leth'ir (world boss Naigtal) | npc 263843, killquest 96472 |
| Imperator Pertinax (world boss Val) | npc 263670 |
| Rotmire (Sporefall) | npc 254176, raid zone 16279 |
| Omnium Folio week 1-quest "Seeking Knowledge" | quest 96410 |
| Field Accolade | currency 3405 (bestaand) |
| Spawn of Vyranoth (Timeways-mount) | item 258884, achievement 61463 |
| Darkspear Dash | event 1793 (27-28 juni) |
| API | TOC 120007; `GetInstanceInfo()` ret11 `hasWorldTier`; `Enum.TieredEntranceType.WorldTier`; geen C_WeeklyRewards-wijzigingen |

## Nog nodig — run dit op de PTR

**1. uiMapID van Naigtal en Val** (voor waypoints/zone-detectie)
Sta in de zone en run:
```
/dump C_Map.GetBestMapForUnit("player")
```
Noteer per zone (en eventueel per verdieping/subzone).
- ✅ **Naigtal = uiMapID 2600** (gemeten in Umbral Base Camp, PTR 6 juni 2026)
- ⬜ Val = ? (volgende rotatie, of check of het vaste Silvermoon-portaal een keuze biedt)

**2. Showdown weekly quest-IDs** ("Showdown on Naigtal" / "Showdown on Val", + evt. Heroic-variant)
Pak de weekly aan en run:
```
/run for i=1,C_QuestLog.GetNumQuestLogEntries() do local q=C_QuestLog.GetInfo(i) if q and not q.isHeader then print(q.questID, q.title) end end
```
Zoek de Showdown-regels in de chat.
- ✅ **"Showdown on Naigtal" = quest 96717** (PTR, 6 juni 2026)
- ✅ Zijquest "Surveying the Mana-Bog" = quest 96054 (Naigtal)
- ⬜ "Showdown on Val" = ? (volgende rotatie)
- ⬜ Heroic-variant weekly = ? (bestaat die als aparte quest?)
- ✅ Na de weekly: Maella biedt "So Much More To Do" → keuzedialoog "Unity against the Void": **Disruptions Continue** (WQ's/events) óf **Dangerous Enemies** (rares/overseers/elites) — vervolg-weekly naar keuze. ⬜ Quest-IDs van beide opties: kies er één en run de questlog-dump.

**3. Rare NPC-IDs Naigtal/Val** (Interminable Uarn, Indomitable Mk. XII, Glacial Broodmother, The Horror Below, + wat je verder tegenkomt)
- ✅ Naigtal: **Voidwarped Sporebat = npc 265698** (PTR 6 juni)
- ✅ Naigtal: **Indomitable Mk XII = npc 264571** (PTR 6 juni — stond op de research-lijst)
- ✅ Naigtal: **Lomelith = npc 263955** (PTR 6 juni)
- ✅ Naigtal: **Slaipaan = npc 264576** (PTR 6 juni)
- ✅ Naigtal: **Interminable Uarn = npc 263947** (PTR 6 juni — stond op de research-lijst)
- ✅ Naigtal: **Swalewing Matriarch = npc 263954** (PTR 6 juni)
Target de rare en run:
```
/run local g=UnitGUID("target") print(g and select(6,strsplit("-",g)), UnitName("target"))
```

**4. Riftstalker's Cache item-ID**
- ✅ **Riftstalker's Cache = item 275690**; weekly turn-in verhoogde de Great Vault World-rij (type 6) — Blizzard-claim bevestigd (PTR 6 juni) — shift-klik het item in de chat of run met het item in je tas:
```
/run for b=0,4 do for s=1,C_Container.GetContainerNumSlots(b) do local i=C_Container.GetContainerItemInfo(b,s) if i and i.hyperlink and i.hyperlink:find("Riftstalker") then print(i.itemID, i.hyperlink) end end end
```

**5. Mote of Omnial Inquiry** — zelfde bagscan, zoekterm "Omnial". Check ook of het een currency is:
```
/dump C_CurrencyInfo.GetCurrencyInfo(3405)
```
(en kijk in je currency-tab of er een nieuwe Omnium-valuta staat — hover + `/dump GameTooltip:GetPrimaryTooltipData()`)

**6. Heroic World Tier status** — klopt het dat er géén unlock-vereiste meer is? En:
```
/dump select(11, GetInstanceInfo())
```
in een Showdown-zone (verwacht: `hasWorldTier = true`).
- ✅ **`hasWorldTier = true` bevestigd in Naigtal** (PTR, 6 juni 2026)
- ✅ Geen unlock-vereiste: portaal bood direct twee opties (Normal / Heroic World Tier) op een verse PTR-kopie

**7. Portaalrotatie** — wisselt Naigtal/Val wekelijks of om de paar dagen? (Bronnen spreken elkaar tegen; bepaalt of we de VoidAssaults-weekly-aanpak kunnen hergebruiken.)

**8. Sporefall Great Vault** — telt een Rotmire-kill mee in de bestaande Raids-rij? Na een kill:
```
/dump C_WeeklyRewards.GetActivities(3)
```

## Wat hiermee gebouwd wordt

- `VoidAssaults.lua`/`WorldContent.lua`: Showdowns-sectie (actieve zone-detectie via weekly quest-flag, zelfde patroon als 12.0.5 Void Assaults) — nodig: 1, 2, 7
- `WorldBoss.lua`: Leth'ir/Pertinax-entries — nodig: 1, 2 (kill-quests per boss: 96472 bekend, Pertinax + Heroic-varianten nodig)
- `Rares.lua`: nieuwe zone-rares — nodig: 1, 3
- `AccountWeeklyChecklist`: Folio-mote + Showdown-weekly — nodig: 2, 5
- Codex-artikelen: al geschreven (geen IDs nodig) ✔
