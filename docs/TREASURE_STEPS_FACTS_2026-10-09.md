# Schat-tussenstappen: quest-ID's (9 okt 2026, mh-research)

Vraag: welke verborgen quest-ID hoort bij de tussenstappen zonder ID in `Modules/AchievementsData.lua`?
Alleen gelezen, niets in de code veranderd.

## Hoe MH een stap afvinkt (GEMETEN, code)

- `Achievements.lua:454` `PrereqDone(p)`: een stap is klaar als `C_QuestLog.IsQuestFlaggedCompleted(p.quest)` true geeft, **of** als `p.item` in je tassen zit. Een stap zonder `quest` en zonder `item` vinkt nooit af.
- `Achievements.lua:891` `PendingTrackedPrereqs`: alleen stappen mét `quest` of `item` doen mee in de pijlroute, dichtstbijzijnde eerst, tenzij de node `orderedPrereqs = true` heeft.
- Vorm van de Sealing Orb-rijen (`AchievementsData.lua:485-488`):
  `{ name = "Sealing Orb 1", mapID = 2437, x = 24.02, y = 75.66, quest = 93918 },`

## Bronnen en positieve controle

| bron | datum | Sealing Orb 93916-93919 gevonden? |
|---|---|---|
| Zygor `Guides-Retail/Achievements/ZygorAchievementsCommonMID.lua` | bestand 20 aug 2026 | ja, r. 1152-1167 (`Solve the Puzzle \|q 93916` enz.) |
| Zygor `Guides-Retail/Poi/MID_Common_Treasures.lua` | bestand 18 aug 2026 | (Poi-bestand, geen Zul'Aman-stappen) |
| HandyNotes_Midnight v156 `zones/*.lua` | bestand 15 sep 2026 | ja, `zul_aman.lua:280-283` |
| wago.tools QuestV2, build 12.1.5.70077 | gelezen 9 okt 2026 | ja, 93916-93919 bestaan |

Alle drie de bronnen vinden de bekende ID's, dus een lege uitkomst verderop is een echte "staat er niet in" voor díe bron.
Let op: wago QuestV2 heeft alleen de kolommen ID / UniqueBitFlag / UiQuestDetailsThemeID, **geen namen** (GEMETEN). Wago bewijst dus alleen dát een ID bestaat, niet bij welke stap hij hoort.

## Gift of the Cycle (Harandar, criteria 110254, regels 457-464)

| stap | quest-ID | bron | status |
|---|---|---|---|
| ACH_STEP_PILLOW (pak kussen) | geen quest gevonden; item **257054** (A Rolled-Up Pillow) | Zygor Achievements r. 931; HandyNotes harandar.lua:310 | item GEMETEN, quest niet gevonden |
| ACH_STEP_ALTARWISDOM | **93146** | Zygor Achievements r. 939 (`Speak to the Elder Spirit \|q 93146`); HandyNotes harandar.lua:307 (Altar of Wisdom); wago QuestV2 bestaat | GEMETEN (2 onafhankelijke bronnen) |
| ACH_STEP_KNIFE (pak mes) | geen quest gevonden; item **257024** | Zygor r. 944; HandyNotes harandar.lua:300 | item GEMETEN, quest niet gevonden |
| ACH_STEP_ALTARVIGOR | **93145** | Zygor r. 951 (`Speak to the Huntress Spirit \|q 93145`); HandyNotes harandar.lua:297; wago bestaat | GEMETEN (2 bronnen) |
| ACH_STEP_BALL (pak bal) | geen quest gevonden; item **256882** | Zygor r. 956; HandyNotes harandar.lua:290 | item GEMETEN, quest niet gevonden |
| ACH_STEP_ALTARINNOCENCE | **93130** | Zygor r. 963 (`Speak to the Child-Like Spirit \|q 93130`); HandyNotes harandar.lua:287; wago bestaat | GEMETEN (2 bronnen) |

Extra (GEMETEN): HandyNotes harandar.lua:315-316 zet bij Gift of the Cycle (93144) `questDeps = {93130, 93145, 93146}`. De coördinaten van de drie altaren in MH zijn gelijk aan die van HandyNotes (51.15/58.56, 47.18/53.14, 51.15/47.55).
Niet gemeten: of de client deze drie vlaggen echt zet. Dat is een in-game check: `/dump C_QuestLog.IsQuestFlaggedCompleted(93146)` na het altaar.

## Treasures of the Coiled Isle (63359)

### Amani Privateer's Cache (criteria 115289, regels 69-73)

| stap | quest-ID | bron | status |
|---|---|---|---|
| ACH_STEP_COD_POOL | niet gevonden; item Grisly Morsel **265525** | Zygor Poi r. 1412 (alleen `\|q 94569` = de kist zelf) | quest niet gevonden, item GEMETEN |
| ACH_STEP_CRATE | niet gevonden; item Privateer's Loop Half of Key **265610** | Zygor Poi r. 1426 | idem |
| ACH_STEP_URN | niet gevonden; item Privateer's Teeth Half of Key **265603** | Zygor Poi r. 1421 | idem |

Zygor gebruikt hier geen stap-quests: elke regel hangt aan 94569 (de kist). HandyNotes coiled_isles.lua:325-329 heeft alleen POI's zonder quest. Wowhead object=619906 (gelezen 9 okt): reacties noemen geen ID's.
AFGELEID: de twee halve sleutels verdwijnen als je ze combineert tot item 265602, dus een `item`-vinkje zou dan weer uitgaan.

### Grave of Someone Forgotten (criteria 115291, regels 82-86)

| stap | quest-ID | bron | status |
|---|---|---|---|
| ACH_STEP_SPIRIT_1 (Zan'ja, NPC 263242) | niet gevonden | Zygor Poi r. 1476-1478 (`confirm`, geen `\|q`) | niet gevonden |
| ACH_STEP_SPIRIT_2 (Ru'ko, NPC 263243) | niet gevonden | Zygor Poi r. 1480-1482 | niet gevonden |
| ACH_STEP_SPIRIT_3 (Zuzan, NPC 263241) | niet gevonden | Zygor Poi r. 1472-1474 | niet gevonden |

Geen items, dus ook geen `item`-alternatief. HandyNotes coiled_isles.lua:357-361: alleen POI's. Wowhead object=645549 en npc=263242 (gelezen 9 okt): geen ID's.
Bijvangst (GEMETEN, bronnen spreken elkaar tegen): Wowhead-nieuws van 17 aug 2026 en meerdere reacties zeggen dat alleen **Ru'ko en Zuzan** nodig zijn; Zygor (18 aug) en Method (10 aug) noemen alle drie. Zan'ja (SPIRIT_1) is dus misschien overbodig. Niet in de client gemeten.

### Vul'zahn's Smuggled Treasure (criteria 115293, regels 88-92)

| stap | quest-ID | bron | status |
|---|---|---|---|
| ACH_STEP_TRADE_1 (Apothecary Dezi, 57.20/48.45) | niet gevonden; item Potion of Headache Relief **271791** | Zygor Poi r. 1630 (alleen `\|q 95976` = de kist) | quest niet gevonden, item GEMETEN |
| ACH_STEP_TRADE_2 (Witherbark Cook, 58.04/48.78) | niet gevonden; item Snuffling Boar Stew **271788** | Zygor Poi r. 1635 | idem |
| ACH_STEP_TRADE_3 (Vul'zahn, 58.16/45.68) | niet gevonden; item Soldier's Smuggled Treasure Key **271792** | Zygor Poi r. 1640 | idem |

AFGELEID: drankje en stoofpot geef je weg in de volgende stap, dus een `item`-vinkje gaat daarna weer uit.

### Overige Coiled Isle-blokken (niet gevraagd, wel gevonden)

| stap | ID | bron | status |
|---|---|---|---|
| ACH_STEP_PEARL_NPC (Brine-Crusted, r. 63, 70.58/77.07) | **96001** (`Place the Pearl \|q 96001`, 70.59/77.07); daarna 96002 = "Wait for the Key" | Zygor Poi r. 1515-1517; wago bestaat | GEMETEN (1 bron, Zygor) |
| ACH_STEP_CLAM (r. 62) | geen quest; item Luminescent Pearl **271815** | Zygor Poi r. 1511 | item GEMETEN |
| ACH_STEP_LOST_ITEM (Lost Spirit, r. 77) | geen quest voor het oppakken; item Forgotten Trinket **269935**. Het afgeven aan de geest is quest **95574** | Zygor Poi r. 1579 en 1584; wago bestaat | ID's GEMETEN; 95574 aan déze stap koppelen = AFGELEID |

Ook nagekeken in Zygor, alleen items/buffs en geen quest: Eversong safebox-sleutels (items 258768/258769/258770), Sheri (koop item 256397), Fungal Mallet (buff 1266347), Void-Shielded Tomb (buff 1252541, item 251519). Ingangen en deuren (UNDERBELLY_WAY_IN, CAVE_ENTRANCE, CAVE_DOOR) zijn plekken: daar hoort geen quest bij.

## Let op bij het plakken (AFGELEID uit `Achievements.lua:891`)

Een stap met `quest` doet mee in de pijlroute, een stap zonder niet. Zet je alleen bij de altaren een quest, dan stuurt de pijl je (dichtstbijzijnde eerst) naar een altaar terwijl je het voorwerp nog niet hebt. Er zijn twee manieren om dat op te lossen. Rob kiest.
1. Alleen fragment A gebruiken en accepteren dat de pijl de oppak-stappen overslaat.
2. Fragment B gebruiken: geef de oppak-stap het `item` én de quest van zijn altaar, en zet `orderedPrereqs = true` op de node. Het vinkje staat dan aan zolang het voorwerp in je tas zit, en blijft aan nadat je het hebt afgegeven.

## Plak-klaar (alleen GEMETEN ID's)

### Gift of the Cycle, fragment A (alleen quest-ID's die 1-op-1 bij de stap horen)

```lua
				prereqs = {
					{ name = "ACH_STEP_PILLOW", mapID = 2413, x = 51.39, y = 56.00 },
					{ name = "ACH_STEP_ALTARWISDOM", mapID = 2413, x = 51.15, y = 58.56, quest = 93146 },
					{ name = "ACH_STEP_KNIFE", mapID = 2413, x = 45.14, y = 54.12 },
					{ name = "ACH_STEP_ALTARVIGOR", mapID = 2413, x = 47.18, y = 53.14, quest = 93145 },
					{ name = "ACH_STEP_BALL", mapID = 2413, x = 51.10, y = 50.49 },
					{ name = "ACH_STEP_ALTARINNOCENCE", mapID = 2413, x = 51.15, y = 47.55, quest = 93130 },
				} },
```

### Gift of the Cycle, fragment B (de ID's zijn GEMETEN; dat ze zo gecombineerd worden is AFGELEID)

```lua
				orderedPrereqs = true,
				prereqs = {
					{ name = "ACH_STEP_PILLOW", mapID = 2413, x = 51.39, y = 56.00, item = 257054, quest = 93146 },
					{ name = "ACH_STEP_ALTARWISDOM", mapID = 2413, x = 51.15, y = 58.56, quest = 93146 },
					{ name = "ACH_STEP_KNIFE", mapID = 2413, x = 45.14, y = 54.12, item = 257024, quest = 93145 },
					{ name = "ACH_STEP_ALTARVIGOR", mapID = 2413, x = 47.18, y = 53.14, quest = 93145 },
					{ name = "ACH_STEP_BALL", mapID = 2413, x = 51.10, y = 50.49, item = 256882, quest = 93130 },
					{ name = "ACH_STEP_ALTARINNOCENCE", mapID = 2413, x = 51.15, y = 47.55, quest = 93130 },
				} },
```

### Brine-Crusted Chest (r. 61-64; 96001 komt uit één bron)

```lua
				prereqs = {
					{ name = "ACH_STEP_CLAM", mapID = 2512, x = 69.58, y = 82.48 },
					{ name = "ACH_STEP_PEARL_NPC", mapID = 2512, x = 70.58, y = 77.07, quest = 96001 },
				} },
```

### Privateer's Cache, Grave of Someone Forgotten, Vul'zahn

Geen fragment. Voor geen enkele stap is een quest-ID gevonden in Zygor, HandyNotes, wago of de Wowhead-reacties. Wat wel kan: de client vragen. Laat Rob een stap doen en lees daarna de quest-vlaggen uit via SavedVariables, met een diff van `C_QuestLog.GetAllCompletedQuestIDs()` van vóór en ná de stap.
⚠️ Die API-naam is een kandidaat. Hij komt uit andere addons (`Plumber/Modules/DevTool.lua`, `Broker_MidnightEvents/DevHarvest.lua`) en is niet in de client geverifieerd.
