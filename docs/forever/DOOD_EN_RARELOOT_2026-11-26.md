# Dood en rare-loot in WoW Forever — feitenonderzoek 26 nov 2026

Client: WoW Forever 1.60.1, nieuwste build **1.60.1.71139** (wago.tools `builds`, 25 nov 2026 19:13).
Blizzard UI-bron: `Gethe/wow-ui-source`, branch **`forever`**, head-commit `d9c22e3` met bericht "1.60.1 (71139)"
(25 nov 2026) — dezelfde branch als `tools/event_snapshot.py` / `event_check.py` (BRANCHES = live, ptr, forever).
DB2 via `tools/gamedata.py` (wago CSV, build 1.60.1.71139 tenzij anders gezegd). Ter vergelijking Classic Era
1.15.9.70576.

Per bewering: **GEMETEN** = gezien in de genoemde bron met datum/build. **AFGELEID** = mijn redenering.
Licentieregel nageleefd: uit Polestar, HandyNotes_WoWForever, QuestieDB en Zygor is niets overgenomen; ze zijn alleen
gelezen om kandidaten te vinden, die daarna in Blizzard-data of een andere bron zijn nagekeken.

---

## VRAAG A — na de dood

### A1. Resurrection Sickness

| Bewering | Status | Bron |
|---|---|---|
| Spell-id **15007** "Resurrection Sickness". Daarnaast bestaat **470199** "[DNT] Resurrection Sickness Prevention" (interne spell, geen tekst). | GEMETEN | DB2 SpellName, Forever 71139 |
| 470199 bestaat ook in Classic Era 1.15.9 (DurationIndex 21 = oneindig), dus geen Forever-nieuwigheid. Wat hij precies doet: onbekend (effect = periodic aura, geen trigger-spell). | GEMETEN (bestaan) / onbekend (werking) | DB2 SpellMisc + SpellEffect, Forever en Era |
| Stat-verlies: aura-tekst "Decreases all attributes by $s1%, all damage caused by $s2%, armor and resistance by $s3%." met s1 = s2 = s3 = **-75**. Dus **-75% alle attributen, -75% schade, -75% armor en resistance**. | GEMETEN | DB2 Spell.AuraDescription + SpellEffect (EffectBasePointsF -75, aura 80/79/101), Forever 71139 |
| Classic Era heeft dezelfde 75% (oud formaat: BasePoints -76 + DieSides 1). Forever veranderde dit dus niet. | GEMETEN | DB2 SpellEffect, Era 1.15.9 |
| Duur-record: DurationIndex **427** = Duration 60000 ms, DurationPerLevel 60000 ms, MaxDuration 600000 ms. Dus 1 minuut + 1 minuut per niveau, maximaal 10 minuten. Era gebruikt dezelfde index 427. | GEMETEN | DB2 SpellMisc + SpellDuration, Forever en Era |
| 15007 heeft **geen** SpellLevels-rij (positieve controle in dezelfde run: 116 en 133 hebben er wél een). Vanaf welk niveau "per level" telt staat dus niet in DB2. | GEMETEN | DB2 SpellLevels, Forever 71139 |
| Minimumniveau: Forever-constante **`MIN_RES_SICKNESS_LEVEL = 11`** (tabel `LevelConstsExposed_Camelot`). | GEMETEN | `Blizzard_APIDocumentationGenerated/LevelConstantsDocumentation.lua`, forever-branch 71139 |
| De Spirit Healer-keuze in Forever: `GameEvent.HandleConfirmXpLoss` roept `GetResSicknessDuration()` aan; is `UnitLevel("player") < Constants.LevelConstsExposed.MIN_RES_SICKNESS_LEVEL` dan dialoog `XP_LOSS_NO_SICKNESS_NO_DURABILITY` (geen straf), anders `XP_LOSS`. | GEMETEN | `Blizzard_Game/Mainline/EventImplementation.lua` r. 860-869; geladen in Forever omdat `Camelot/EventRouting.lua` `RegisterSharedEvents` + `RegisterMainlineEvents` + `RegisterCamelotEvents` aanroept |
| Duurregel voor de speler: tot en met niveau 10 geen sickness; niveau 11 = 1 min, oplopend 1 min per niveau, vanaf 20 = 10 min. Dat is dezelfde regel als Classic Era. | AFGELEID (uit 427 + constante 11; de server past het toe, niet zichtbaar in DB2). In-game nameten, zie testen. |
| Let op: de Forever-tekst `CONFIRM_XP_LOSS_NO_SICKNESS_NO_DURABILITY` zegt "Players that are **below level 10** can resurrect here with no penalty", terwijl de constante 11 is (= niveau 10 en lager). Era zegt "level 10 or below". Eén van de twee klopt niet voor niveau 10. | GEMETEN (beide teksten) / onbekend (welke waar is) | DB2 GlobalStrings 20435, Forever en Era |
| Duurzaamheid bij de Spirit Healer: tekst `CONFIRM_XP_LOSS` = "If I resurrect you all of your items will take **25%% durability damage (equipped and inventory)** and you will be afflicted by %s of Resurrection Sickness." | GEMETEN | DB2 GlobalStrings 11790, Forever 71139 (Era: zelfde tekst zonder spell-link) |
| Forever heeft een tweede tekst met **10%**: `CONFIRM_XP_LOSS_NO_SICKNESS` = "...all of your items will take 10%% durability damage" (Era: 25%). Ik vond geen Forever-dialoog die deze tekst gebruikt (alleen `XP_LOSS` en `XP_LOSS_NO_SICKNESS_NO_DURABILITY` in `GameDialogDefs.lua` en `Mainline/GameDialogDefs.lua`). | GEMETEN (tekst) / AFGELEID (ongebruikt; ik las niet de hele UI-bron) |
| Hoeveel duurzaamheid de server écht afhaalt: niet te meten van hier. De Blizzard-tekst zegt 25%. | AFGELEID |
| Geen Forever-pagina van Blizzard of Wowhead gevonden die de duur per niveau noemt; Wowhead Forever-tooltip van 15007 geeft alleen naam + icoon (`spell_shadow_deathscream`). | GEMETEN (tooltip-JSON 26 nov) |
| **Nameting (later 26 nov, mh-research, na Polestars "10m op level 14").** Polestars eigen opslag op Robs shaman: `resSickness = { seconds = 240, level = 14 }` (`_forever_\WTF\…\Ima-Shammydude\SavedVariables\Polestar.lua` r431, door de bouwchat zelf nagekeken). Polestars "10m" is een vaste terugval (`Polestar\QoL\Death.lua`:59 `SICKNESS = 600`) als hij op dat level nog niet mat. | GEMETEN |
| DB2 71139: SpellMisc 15007 → DurationIndex 427; SpellDuration 427 = 60000 + 60000 per level, max 600000 (Era: -600000 + 60000/level). Helling en plafond GEMETEN; startpunt uit de meting op 14 → 1 min op 11 … 9 min op 19, 10 min vanaf 20. | GEMETEN (DB2, 14) / AFGELEID (overige levels) |
| **GEMETEN in de client, 26 nov (Robs screenshot, Druid 15, Forever):** Blizzards popup: "If I resurrect you all of your items will take 25% durability damage (equipped and inventory) and you will be afflicted by **5 minutes** of [Resurrection Sickness]." → level 15 = 5 min en 25% (ook tassen) GEMETEN; MH's venster zei ernaast hetzelfde. MH-tekst nu "on your gear and bags". | GEMETEN |
| Blizzards eigen Spirit Healer-popup gebruikt `GetResSicknessDuration()` (Mainline EventImplementation.lua 860-869, CONFIRM_XP_LOSS). MH's `/mh ghost` print die waarde sinds 26 nov. Of hij antwoordt als je leeft: niet gemeten. | GEMETEN (bron) |

### A2. Client-API in de Forever-UI-bron (branch `forever`, 71139)

| API / event | Bestaat in Forever? | Argumenten → terugkeer | Status |
|---|---|---|---|
| `C_DeathInfo.GetCorpseMapPosition(uiMapID)` | ja | uiMapID (number) → `position` Vector2DMixin, **nilable** | GEMETEN, `DeathInfoDocumentation.lua` |
| `C_DeathInfo.GetDeathReleasePosition(uiMapID)` | ja | uiMapID → Vector2DMixin, nilable (waar je "released" bent) | GEMETEN, idem |
| `C_DeathInfo.GetGraveyardsForMap(uiMapID)` | ja | uiMapID → tabel van `GraveyardMapInfo` {areaPoiID, position, name, textureIndex, graveyardID, isGraveyardSelectable} | GEMETEN, idem |
| `C_DeathInfo.GetSelfResurrectOptions()` / `UseSelfResurrectOption(type,id)` | ja | — | GEMETEN, idem |
| Events `PLAYER_DEAD`, `PLAYER_ALIVE`, `PLAYER_UNGHOST`, `CORPSE_IN_RANGE`, `CORPSE_OUT_OF_RANGE`, `CORPSE_IN_INSTANCE`, `CONFIRM_XP_LOSS`, `AREA_SPIRIT_HEALER_IN_RANGE/OUT_OF_RANGE`, `PLAYER_SKINNED`(hasFreeRepop), `RESURRECT_REQUEST`(inviter), `CEMETERY_PREFERENCE_UPDATED`, `REQUEST_CEMETERY_LIST_RESPONSE` | ja | — | GEMETEN, `DeathInfoDocumentation.lua`; `PLAYER_UNGHOST` ook in `tools/blizzard_events_snapshot.json` (forever 71139) |
| `GetCorpseRecoveryDelay()` | gebruikt door geladen code (`RESURRECT`, `RECOVER_CORPSE`-dialogen: `StartDelay = GetCorpseRecoveryDelay`, `timeleft = GetCorpseRecoveryDelay() + 60`) | geen arg → seconden | GEMETEN (gebruik in `Blizzard_StaticPopup_Game/GameDialogDefs.lua`); dat de functie bestaat = AFGELEID uit onbewaakt gebruik |
| `UnitIsGhost("player")`, `GetReleaseTimeRemaining()`, `CanPortGraveyard()`, `RepopMe()`, `GetResSicknessDuration()`, `GetCemeteryPreference()`/`SetCemeteryPreference(id)` | gebruikt door geladen Forever-code | — | GEMETEN (gebruik in `Camelot/EventImplementation.lua`, `Mainline/EventImplementation.lua`, `SelectableGraveyardDataProvider.lua`); bestaan AFGELEID |
| `C_Map.GetBestMapForUnit`, `GetPlayerMapPosition`, `GetWorldPosFromMapPos`, `GetMapWorldSize` | ja | — | GEMETEN, `MapDocumentation.lua` (forever). Daarmee kan afstand in yards (lijk ↔ speler) berekend worden: AFGELEID |
| Wereldkaart: Forever voegt `DeathMapDataProviderMixin` (lijk-pin via `GetCorpseMapPosition`) en `SelectableGraveyardDataProviderMixin` (pins via `GetGraveyardsForMap`) toe | ja | — | GEMETEN, `Blizzard_WorldMap.lua` r. 201 en 218 |
| De "release position"-pin staat uitgeschakeld in de code ("Disabled for now, need a different icon") | — | — | GEMETEN, `DeathMapDataProvider.lua` |
| Alle functies dragen `SecretArguments = "AllowedWhenUntainted"` | — | — | GEMETEN (doc); gevolg voor gewone getallen als argument: AFGELEID geen probleem |

**Is de plek van de Spirit Healer leesbaar?**
- Er is geen functie "dichtstbijzijnde Spirit Healer". GEMETEN (DeathInfo-doc heeft er geen).
- `GetGraveyardsForMap` is de enige kandidaat. De enige AreaPOI-rijen met "Graveyard" in Forever DB2 (21 stuks) liggen
  allemaal op ContinentID 30 = Alterac Valley (filter `ContinentID!=30` gaf 0, de eerste 15 rijen toonden 30). GEMETEN.
  Daaruit AFGELEID: de functie geeft waarschijnlijk alleen battleground-kerkhoven en in de open wereld een lege tabel.
  **Niet gemeten in de client** — zie test 2.
- Wowhead Forever-tooltip van npc 6491 "Spirit Healer" geeft 16 spawns, maar alleen in één zone (139, Eastern
  Plaguelands). Geen volledige lijst. GEMETEN (tooltip-JSON 26 nov).
- `GetDeathReleasePosition` geeft waar je losliet (vlak bij het kerkhof waar je verscheen), niet de healer zelf.
  AFGELEID uit de naam en de uitgeschakelde pin-tekst `SPIRIT_HEALER_RELEASE_RED`.
- Server-tabel WorldSafeLocs is niet op wago voor Forever (HTTP 400). GEMETEN; dat het een servertabel is: AFGELEID.

### A3. Snelheid als geest

| Bewering | Status | Bron |
|---|---|---|
| 8326 "Ghost": aura 31 = **+25%** looptempo en aura 58 = +25% zwemtempo (plus aura 95 = ghost-staat). | GEMETEN (getallen) / AFGELEID (betekenis van aura-nummers 31/58/95, uit de bekende aura-lijst) | DB2 SpellEffect, Forever 71139 |
| Night Elf "Wisp Spirit" (20585, Racial Passive): "Transform into a wisp upon death, increasing movement speed by **75%**" (via 20584: aura 31 = 75, 58 = 75). | GEMETEN | DB2 Spell + SpellEffect Forever; Wowhead Forever-tooltip 20585 (26 nov) zegt ook 75% |
| **Forever veranderde de wisp**: Classic Era 1.15.9 heeft 20584 op 49+1 = **50%**. Gewone geest is in beide 25%. | GEMETEN | DB2 SpellEffect, Era 1.15.9 vs Forever 71139 |
| Of een nachtelf 25% en 75% tegelijk krijgt of alleen de hoogste: onbekend. | AFGELEID (normaal geldt de hoogste) — in-game meten |

### Testen voor Rob (in Forever, elk regeltje < 255 tekens)

1. Als geest: `/dump C_DeathInfo.GetCorpseMapPosition(C_Map.GetBestMapForUnit("player"))` → verwacht een x,y.
2. Als geest in de open wereld: `/dump C_DeathInfo.GetGraveyardsForMap(C_Map.GetBestMapForUnit("player"))` → is hij leeg?
3. `/dump GetResSicknessDuration(), Constants.LevelConstsExposed and Constants.LevelConstsExposed.MIN_RES_SICKNESS_LEVEL`
4. `/dump GetCorpseRecoveryDelay(), GetReleaseTimeRemaining(), UnitIsGhost("player")`
5. Als geest: `/dump GetUnitSpeed("player")` (en bij een nachtelf).
6. Een niveau-10- en een niveau-11-character bij de Spirit Healer: welke tekst verschijnt?

---

## VRAAG B — wat een Forever-rare laat vallen

### B1. Wat de bronnen hebben

| Bron | Wat erin staat | Licentie | Status |
|---|---|---|---|
| **DB2 (wago)** | Geen loottabellen. `Creature` in Forever heeft 189 rijen (huisdieren e.d.), geen rares; kolommen zonder loot (alleen `AlwaysItem_*` = uitrusting). 3470/5828/5831 staan er niet in, positieve controle: 2671/7380 wel. `JournalEncounterItem` bestaat niet voor Forever (HTTP 400). Wél: `Item` (klasse, slot, icoon) en `ItemSet`. | Blizzard | GEMETEN |
| **Wowhead Forever tooltip-JSON** (`nether.wowhead.com/forever/tooltip/...`) | NPC: naam, niveau, zone, spawns, **geen loot**. Item: naam, kwaliteit, icoon, stats **en "Dropped by: X" + "Drop Chance: y%"** (één bron per item). | Wowhead-eigendom; staf op hun forum: "We do not allow scraping or exporting of data from Wowhead" | GEMETEN (26 nov); licentiestatus uit forum-citaat |
| **Wowhead Forever gewone pagina** | `curl` → **HTTP 403** (text/html, 919 bytes). Via de WebFetch-tool kwam de pagina wél door (tabs Quick Facts/Screenshots/Videos, "can be found in The Barrens"), maar **zonder Drops-tab en zonder itemnamen** in de tekst. | idem | GEMETEN 26 nov |
| **HandyNotes_WoWForever** (Kemayo, v5) | Per rare: npc-id, coördinaten, `loot = { itemID, ... }` — **zonder kansen**. | Geen LICENSE in de map, README zonder licentie, GitHub-repo `kemayo/wow-handynotes-forever` licentie = null → standaard alle rechten voorbehouden | GEMETEN (bestanden + `gh api`); "ARR" = AFGELEID uit ontbreken licentie |
| **Spoken** (+ Spoken_Quests/Bosses) | **Geen lootdata.** 0 treffers voor 3470/5828/5831 in Spoken_Quests en Spoken_Bosses (positieve controle: npc 3338 wel, 17×). Spoken/Data = alleen DeveloperList.lua en Dungeons.lua. | Geen LICENSE-bestand in `Spoken/`, README en toc zonder licentie | GEMETEN |
| QuestieDB (Forever) | `npcDrops` per item (lijst npc-id's), **geen kansen** | GPL-3.0 / deels "all rights reserved" (eigen LICENSE.md) | GEMETEN — niet bruikbaar |
| Polestar_ItemDB / Codex | itemstats en bronnen, geen kansen voor deze rares gevonden | GPL (taakregel) | alleen kandidaat |
| LootRaceForever | geen loottabellen (waarde-teller) | CC BY-NC-SA 4.0 | GEMETEN |
| **Drop Tables** (`valcheffnet/DropTables`, `data/shared.json`) | Echte Forever-tellingen per npc: kills, lootable, opened, per item drops → kans. 2344 mobs, 11 inzendingen, dagelijks bijgewerkt; bevat ook EG Link (CC BY 4.0), Everloot (CC BY-SA 4.0) en Blackthornes Farmer (MIT). **3470, 5828, 5831: niet aanwezig** (positieve controle npc 1529 Bleeding Horror: 107 kills, Linen Cloth 25,48%). | **Data CC BY-SA 4.0** (code ARR) | GEMETEN 26 nov |
| **EG Link output** (`JIVESCORP/eg-link-output-wowf`) | Loot per npc per build met kans. Alle 16 builds met loot doorzocht: **0 records** voor de drie rares (controle npc 1529: 5 records). | **CC BY 4.0** | GEMETEN 26 nov |
| wowlayerup `opendata` | alleen bèta-release 2026.10.0 (24 okt), wereld-loot leeg | data CC BY 4.0 | GEMETEN (releases + Last-Modified) |
| NorgannonDB / forever-db / Forever Quest Log | wel drop chances, maar afgeleid van QuestieDB | GPL-3.0 | GEMETEN (hun README) — valt onder de GPL-regel |
| **Icy Veins Forever DB** (`db.icy-veins.com/wow-forever/npcs/<id>`) | Volledige droptabel met kansen. `curl` en WebFetch: 403; via Exa-fetch wel leesbaar. | Eigendom Icy Veins; geen hergebruiklicentie gezien | GEMETEN (inhoud via Exa 26 nov); licentie = AFGELEID (hun voorwaarden niet gelezen) |
| Everloot (`everloot.app`) | database bestaat; npc-pagina's gaven 403 via Exa | CC BY-SA 4.0 (volgens Drop Tables LICENSE-DATA) | niet gemeten |

### B2. Aanbeveling: één bron

**Drop Tables, data onder CC BY-SA 4.0.** Reden (AFGELEID): het is de enige open bron met echte Forever-tellingen én
de grootste dekking (hij neemt EG Link, Everloot en Blackthornes al mee), dagelijks bijgewerkt, licentie staat er
expliciet. Voorwaarden: naamsvermelding "Drop Tables contributors, https://github.com/valcheffnet/DropTables", en
**wat MH ervan maakt (onze datatabel) moet ook CC BY-SA 4.0 zijn** (ShareAlike). Hun **code** is ARR: niet kopiëren.
Of ShareAlike past bij de licentie van Midnight Helper zelf: dat is Robs beslissing (AFGELEID, geen juridisch advies).
Wil Rob geen ShareAlike: EG Link (CC BY 4.0, alleen naamsvermelding) is schoner, maar heeft nog minder dekking.

Belangrijk: **voor de drie gevraagde rares zegt Drop Tables vandaag niets** (niet aanwezig, GEMETEN). MH moet dan
"nog geen data" tonen. Itemnaam en icoon komen het best uit de client zelf (in de taal van de speler); MH hoeft alleen
npc-id → item-id + kans mee te nemen (AFGELEID).

### B3. Wat er bekend is over de drie rares (ter referentie)

Kandidaat-items komen uit HandyNotes_WoWForever (ARR, alleen gelezen). Bestaan, slot en icoon: Blizzard DB2 `Item`
(Forever 71139, GEMETEN). Kansen: Wowhead Forever tooltip-JSON en Icy Veins (beide 26 nov, GEMETEN; **niet vrij te
gebruiken** in MH zonder toestemming — AFGELEID).

| Rare | Item | DB2 Item (klasse/slot, IconFileDataID) | Wowhead Forever tooltip | Icy Veins | Drop Tables / EG Link |
|---|---|---|---|---|---|
| **Rathorian (3470)** — lvl 15 Demon (Rare) | 5111 Rathorian's Cape (groen, ilvl 17, vereist 12) | armor/cloth, back, 133150 | Dropped by Rathorian, **17.08%** | 16.5% | geen record |
| | 5112 Ritual Blade (groen, dolk, ilvl 17, vereist 12) | weapon/dagger, 135638 | Dropped by Rathorian, **18.18%** | 20.3% | geen record |
| | (IV noemt ook o.a. Linen Cloth 28.5%, Soldier's Cloak 4.43%, Jagged Knives 285282 1.27%) | | | | |
| **Humar the Pridelord (5828)** — lvl 23 Beast (Rare Elite), kat | 285331 Mark of the Pack Leader (blauw, nek, ilvl 25, vereist 20, +5 Str +5 Int) | armor/misc, neck, 133291 | Dropped by Humar the Pridelord, **81.25%** | wel in de lijst, **geen kans** vermeld | geen record |
| **Swiftmane (5831)** — lvl 21 Beast (Rare Elite) | 285330 Signet of the Zhevra (blauw, ring, ilvl 23, vereist 18, +6 Agi +2 Spi) | armor/misc, finger, 133345 | Dropped by Swiftmane, **91.56%** | 94.7% (ook Long Tail Hair 5120 60.9%) | geen record |

Extra, GEMETEN in DB2: 285331 en 285330 horen bij **ItemSet 2132 "Blessing of Kalimdor"** = 285331, 285330, 285329
(Raptor Hide Cloak). Setbonus (2) volgens de Wowhead-tooltip: spell 1318244 "Kalimdor Speed" (naam GEMETEN in DB2
SpellName), "Increases movement speed by 5% in The Barrens and Stonetalon Mountains" (GEMETEN, Wowhead-tooltip).
Wie 285329 laat vallen: niet nagekeken.

De kansen van Wowhead en Icy Veins verschillen een paar procent (andere steekproeven). Een tooltip noemt maar één
"Dropped by"; voor een volledige lijst per npc is de tooltip dus niet genoeg (GEMETEN aan de vorm van de JSON).

---

## Gebruikte lokale kopieën (alleen data, niets uitgevoerd)

Scratchpad van deze sessie: `uisrc_forever/` (Blizzard UI-bron, forever 71139), `egl/` (EG Link loot per build),
`droptables/` (shared.json, LICENSE-DATA, README), scripts `dt_rares.py` en `egl_rares.py`.
