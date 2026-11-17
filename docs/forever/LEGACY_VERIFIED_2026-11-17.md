# Legacy Points (WoW Forever) — controle van het eerdere onderzoek

Datum: 17 nov 2026. Client-build: **1.60.1.70938** (wowf, bij wago sinds 13 nov 2026).
Nagelopen: `LEGACY_RESEARCH_2026-11-17.md` (tekst kreeg ik aangeleverd; ik heb niets onder `docs/` gelezen).

**Uitslag: 79 ✅ · 2 ❌ · 1 ❓.** Daarnaast 12 nieuwe feiten die in het eerdere onderzoek ontbraken (hoofdstuk 8). Drie daarvan zijn belangrijk vóór het bouwen: Dedicated Study is geen passieve perk, elke boom heeft 2 lege "Unknown"-vakjes, en er zijn twee reeksen achievement-ID's.

## Bronnen (afkortingen)

| Afk. | Bron | Datum |
|---|---|---|
| **DB2** | Blizzards DB2-tabellen via wago.tools, build 1.60.1.70938. Lokale cache `%LOCALAPPDATA%\MidnightHelper\gamedata_cache\db2\1.60.1.70938\`; ontbrekende tabellen opgehaald via de voordeur (`run gamedata db2 …`) | build 13 nov 2026, gelezen 17 nov 2026 |
| **UI** | Blizzards eigen UI-code voor Forever: GitHub `Gethe/wow-ui-source`, branch `forever`, commit `bebcb6bf` met titel "1.60.1 (70938)". Dit is een spiegel van Blizzards geëxporteerde interface-code, zelfde buildnummer. Het is niet de client zelf | commit 13 nov 2026 |
| **BLIZ** | Blizzard News, "Get to Know the World of Warcraft: Forever Legacy System", news.blizzard.com/en-us/article/24307383 | 23 sep 2026 |
| **WH-tip** | Wowhead tooltip-JSON (`run gamedata spell/npc … --game forever`) | 17 nov 2026 |
| **WH-gids** | Wowhead-gids "Legacy System Overview for Forever" (Nodge), wowhead.com/forever/guide/legacy-system-overview-rewards | bijgewerkt 15 nov 2026 |
| **ZYG** | Zygor Forever, lokaal: `ZygorGuidesViewerForever\Libs-Forever\LibRover-1.0\data_inns.lua` regel 114 | lokaal bestand |

Onder `E:\World of Warcraft\_forever_\` staat **geen** export van Blizzards interface-code (GEMETEN: alleen `Interface\AddOns` met addons van derden). Daarom is de UI-code uit de GitHub-spiegel gehaald.

Regel in dit document: **GEMETEN** = zelf gezien in de genoemde bron. **AFGELEID** = beredeneerd.

---

## 1. Basis en namen

| # | Bewering | Uitslag | Bron |
|---|---|---|---|
| 1.1 | Punten zijn account-breed | ✅ GEMETEN | BLIZ: "These points are Battle.net account-wide and available to all your non-Hardcore characters." Let op het woord **non-Hardcore** (zie 8.4) |
| 1.2 | Perks zijn per character | ✅ GEMETEN | BLIZ: "Each character on your account can spend these points differently and completely independent of each other." |
| 1.3 | Max 16 uitgeven per character; TraitCurrency 4225 SourcedMax 16 | ✅ GEMETEN | DB2 `TraitCurrency`: `4225, Type 2, Flags 0, Icon 135884, SourcedMax 16`. BLIZ: "At the launch of the game, you will be able to spend up to 16 points total on each character." |
| 1.4 | Spelzin "seasonal cap" | ✅ GEMETEN | DB2 `GlobalStrings` `LEGACY_POINTS_SEASONAL_CAP` = "You can spend up to your current seasonal cap of %d Legacy Points in total." UI (`Blizzard_LegacyTree.lua`) vult `%d` met `currencyInfo.maxQuantity` |
| 1.5 | Bomen 1187 / 1188 / 1189 = Professions / Adventure / Resourcefulness | ✅ GEMETEN | UI `LegacyConstantsDocumentation.lua`: `LEGACY_TREE_PROFESSIONS_ID = 1187`, `LEGACY_TREE_ADVENTURE_ID = 1188`, `LEGACY_TREE_PROGRESSION_ID = 1189`. DB2 `GlobalStrings`: `LEGACY_TREE_PROFESSIONS` "Professions", `LEGACY_TREE_ADVENTURE` "Adventure", `LEGACY_TREE_PROGRESSION` "Resourcefulness". Intern heet boom 3 dus "Progression" |
| 1.6 | `LEGACY_BUTTON` = "Legacy" | ✅ GEMETEN | DB2 `GlobalStrings.enUS` |
| 1.7 | `LEGACY_CHALLENGE_FRAME_TITLE` bestaat | ✅ GEMETEN | = "Legacy Challenges" |
| 1.8 | `LEGACY_TREE_FRAME_TITLE` bestaat | ✅ GEMETEN | = "Legacy Tree" |
| 1.9 | `LEGACY_TRACK_FRAME_TITLE` bestaat | ✅ GEMETEN | = "Progress Track" |
| 1.10 | `BINDING_NAME_TOGGLELEGACYSYSTEM` bestaat | ✅ GEMETEN | = "Toggle Legacy Pane" |
| 1.11 | deDE "Vermächtnispunkte" | ✅ GEMETEN | DB2 `GlobalStrings.deDE` `LEGACY_REWARD_TRACK_POINTS` |
| 1.12 | frFR "Points d'héritage" | ✅ GEMETEN, met kanttekening | Client schrijft **Points d’héritage** met het krullende teken ’ (U+2019), niet de rechte ' |
| 1.13 | esES "Puntos de legado" | ✅ GEMETEN | DB2 `GlobalStrings.esES` |
| 1.14 | ptBR "Pontos de Legado" | ✅ GEMETEN | DB2 `GlobalStrings.ptBR` |
| 1.15 | ruRU "Очки старинных наград" | ✅ GEMETEN | DB2 `GlobalStrings.ruRU` |

## 2. Punten verdienen

| # | Bewering | Uitslag | Bron |
|---|---|---|---|
| 2.1 | 65 regels in TraitCurrencySource met Amount 1 | ❌ → **130 regels met Amount 1 (2 × 65) plus 1 regel met Amount 0** | DB2 `TraitCurrencySource`, currency 4225. Reeks A: rij-ID 37077, 37085–37144, 37179, 37182–37184 (laatste kolom = 60). Reeks B: rij-ID 38797–38861 (laatste kolom = 61). Extra: rij 38875 "Play in the WoW: Forever Beta", Amount **0**, achievement 64283. Voor de speler blijven het 65 challenges (BLIZ: "sixty-five Legacy Challenges"). Zie 8.3 |
| 2.2 | Class voor het eerst 25 / 45 / 60 = 27 | ✅ GEMETEN | DB2: 9 classes × 3. BLIZ: "Classes: Total of 27 points" |
| 2.3 | Alchemy, Blacksmithing, Enchanting, Engineering, Leatherworking, Tailoring op 150 / 225 / 300 = 18 | ✅ GEMETEN | DB2 + BLIZ "Tradeskills: Total of 18 Points" |
| 2.4 | Verzamelberoepen tellen niet | ✅ GEMETEN | BLIZ: "each non-gathering primary profession". DB2: geen regels voor Mining, Herbalism, Skinning. Ook Cooking, First Aid en Fishing hebben geen regels |
| 2.5 | PvP = 12 | ✅ GEMETEN | DB2 + BLIZ: 5 ranks (3, 7, 10, 13, 14) + 4 × Exalted bij een battleground-factie + 3 × Field of Honor Journey (week 4, 7, 10) |
| 2.6 | Explorer + Valthalak-keten = 2 | ✅ GEMETEN | DB2: "Have a character with the Explore Azeroth achievement." en "Complete the questline beginning with An Earnest Proposition, and ending with Saving the Best for Last." |
| 2.7 | Novice / Experienced / Master Spelunker = 3 | ✅ GEMETEN | DB2 `Achievement` titels + BLIZ (dungeons level 15–25, 26–45, 46–60) |
| 2.8 | Onyxia, Hyjal, Barrow Deeps = 3 | ✅ GEMETEN | DB2: "Conqueror of the Lair", "Conqueror of the Wilds", "Conqueror of the Deeps". BLIZ: 13 Hyjal-bazen, 8 Barrow Deeps-bazen |
| 2.9 | Elke challenge is een achievement met beloning "Earn 1 Legacy Point." | ✅ GEMETEN | DB2 `Achievement.Reward_lang`: 130 rijen met precies die tekst |
| 2.10 | Categorieën 15585 / 15593 / 15594 / 15596 | ❌ → het zijn er **20**; 15585 is alleen Warrior | DB2 `Achievement_Category` + `Achievement.Category`. Zie lijst hieronder |
| 2.11 | Venster open vanaf het eerste punt (Blizzard) | ✅ GEMETEN | BLIZ: "You gain access to the Legacy System as soon as you earn your first Legacy Point." UI: knop en venster werken pas als `C_MajorFactions.GetCurrentRenownLevel(2802) > 0` |
| 2.12 | Knop-tooltip "when your first character reaches level 25" | ✅ GEMETEN | DB2 `LEGACY_MICRO_BUTTON_LOCKED_TOOLTIP` = "This feature becomes available when your first character reaches level 25." UI toont hem alleen zolang de knop op slot zit |

**Categorieën (2.10), GEMETEN in DB2 `Achievement_Category`:**

- Classes 15568 → Druid 15577, Hunter 15578, Mage 15579, Paladin 15580, Priest 15581, Rogue 15582, Shaman 15583, Warlock 15584, Warrior 15585
- Tradeskills 15586 → Alchemy 15587, Blacksmithing 15588, Enchanting 15589, Engineering 15590, Leatherworking 15591, Tailoring 15592
- Dungeons 15593
- Raids 15594 (heeft ook een lege subcategorie "Tier 1 Gear" 15626)
- Player vs. Player 15595 → Ranks 15597, Reputations 15598, Season Journey 15620
- Adventure 15596 (subcategorieën Explorer 15607, Eastern Kingdoms 14777, Kalimdor 14778; de 2 punt-achievements staan in 15596 zelf)

Zes hoofdcategorieën, dat klopt met BLIZ ("six different categories").

Twee kleine tekstverschillen binnen Blizzards eigen data (GEMETEN): `TraitCurrencySource` zegt "Commander or Champion", de achievement zegt "Lieutenant-Commander or Champion" (Rank 10). `TraitCurrencySource` zegt "Southseas Archipelago battleground", de achievement heet "Master of Darkspear Islands" (Darkspear Raiders / Theramore Expeditionary Force). Gebruik de achievement-tekst; dat is wat de speler ziet.

## 3. Punten uitgeven en terugdraaien

| # | Bewering | Uitslag | Bron |
|---|---|---|---|
| 3.1 | Legacy-knop in het micromenu | ✅ GEMETEN | UI `Blizzard_MicroMenu/Mainline/MainMenuBarMicroButtons.lua`: `LegacyMicroButton` met `LegacyMicroButtonMixin`; klik roept `ToggleLegacySystemUI()` aan |
| 3.2 | Of met een toets | ✅ GEMETEN | UI `Bindings_Camelot.xml`: binding `TOGGLELEGACYSYSTEM` → `ToggleLegacySystemUI()`. Standaardtoets **Y** staat alleen in BLIZ ("using the default hotkey (Y)") |
| 3.3 | Apply-knop | ✅ GEMETEN | UI `Blizzard_LegacyTree.lua`: `ApplyButton` → `CommitConfig()`. Er is ook een `UndoButton` voor nog niet toegepaste keuzes |
| 3.4 | Kolom 2 open bij 5 punten in die boom | ✅ GEMETEN | DB2 `TraitCond` 49252 / 49260 / 49264: `SpentAmountRequired 5`, currency 4225; via `TraitNodeGroupXTraitCond` gekoppeld aan de kolom-2-nodes |
| 3.5 | Kolom 3 open bij 10 punten in die boom | ✅ GEMETEN | DB2 `TraitCond` 49251 / 49259 / 49263: `SpentAmountRequired 10` |
| 3.6 | Terugdraaien bij de class-trainer | ✅ GEMETEN (gidsen) + client ondersteunt het | WH-gids: "You are able to respec your Legacy Points at the class trainer." Client: het bevestigingsvenster sluit als je wegloopt van de "talent master" (UI `GameDialogDefs.lua`, `CheckTalentMasterDist()`). In het venster zelf kan het niet: DB2 `TraitTree.Flags = 1` voor 1187/1188/1189 en UI-enum `TraitTreeFlag.CannotRefund = 1` |
| 3.7 | Alles tegelijk | ✅ GEMETEN | DB2 `GlobalStrings` `CONFIRM_TALENT_WIPE_5` = "Do you want to unlearn all of your legacy perks?" (UI-enum `RespecType.Legacy = 4`, tekstnummer = type + 1) |
| 3.8 | Kosten per rang = 1 punt | ✅ GEMETEN | DB2 `TraitTreeXTraitCost`: 1187 → cost 4843, 1188 → 4844, 1189 → 4846. DB2 `TraitCost`: alle drie `Amount 1`, currency 4225 |
| 3.9 | Reset-prijs niet gemeten | ❓ blijft zo | Niet in clientdata: de prijs komt van de server en staat in het geldvakje van het bevestigingsvenster (UI: `MoneyFrame_Update(dialog.MoneyFrame, data.cost)`). Gidsen noemen **10 goud** voor de eerste reset (allthings.how, 21 sep 2026; conquestcapped.com, tekst loopt tot 12 nov 2026). howtovideogame.com (bijgewerkt 12 nov 2026) zegt dat Blizzard de live-prijs niet heeft gepubliceerd. Of de prijs oploopt is nergens bevestigd. **Noem in de addon geen bedrag** |

## 4. Beloningen

| # | Bewering | Uitslag | Bron |
|---|---|---|---|
| 4.1 | 15 punten → Holstered Replica Ironforge Air Rifle 276236 | ✅ GEMETEN | DB2 `RenownRewards` rij 1856: Level 15, ItemID 276236. DB2 `ItemSparse` 276236 = "Holstered Replica Ironforge Air Rifle". De beloningskaart zelf toont "Replica Ironforge Air Rifle" (ToastDescription) |
| 4.2 | 25 → Spectral Bear Cub 277714 | ✅ GEMETEN | `RenownRewards` 1857 + `ItemSparse` |
| 4.3 | 40 → Spectral Bear Tabard 277717 | ✅ GEMETEN | `RenownRewards` 1858 + `ItemSparse` |
| 4.4 | 55 → Reins of the Spectral Bear 277718 | ✅ GEMETEN | `RenownRewards` 1859 + `ItemSparse` (item vraagt level 60, kwaliteit epic) |
| 4.5 | Het gaat om verdiende punten, niet uitgegeven | ✅ GEMETEN | BLIZ: "Legacy Points accumulate on your entire account, unlocking toys and cosmetic items." UI: het totaal is het renown-level van factie 2802 (zie 7) |
| 4.6 | Ophalen bij Innkeeper Wiley, NPC 6791 | ✅ GEMETEN | DB2 `RenownRewards.Description`: "Visit Innkeeper Wiley in Ratchet to claim your reward." WH-tip npc 6791 = Innkeeper Wiley, Ratchet |
| 4.7 | Ratchet 62.05, 39.41 | ✅ GEMETEN | ZYG: `npcid=6791, x=62.05, y=39.41`. WH-tip: 62, 39.4. WH-gids: `/way 62.0 39.4` |

Alle vier de kaartteksten eindigen in de client op: "Visit Innkeeper Wiley in Ratchet to claim your reward." De koppeling `RenownRewards.CovenantID 48` ↔ factie 2802 is AFGELEID (Blizzards UI vraagt de beloningen op met factie 2802; dit zijn de enige passende rijen).

## 5. Perks: ID, rangen, kolom, voorwaarde

Alle 21 perks kloppen op spell-ID, aantal rangen en kolom. **21 × ✅ GEMETEN.**
Keten in DB2: `TraitNode` (boom, positie) → `TraitNodeXTraitNodeEntry` → `TraitNodeEntry` (MaxRanks) → `TraitDefinition` (SpellID) → `SpellName`. Kolom = `PosX`: 2400 = kolom 1, 3300 = kolom 2, 4200 = kolom 3.

De 6 voorwaarden ("vereist …") kloppen ook: **6 × ✅**. De pijl zelf is GEMETEN (DB2 `TraitEdge`, Type 2 = `SufficientForAvailability`). Dat de vorige perk **vol** moet zijn (5/5, 3/3, 2/2) is AFGELEID: de nodes missen de vlag `ActiveAtFirstRank` (16), en zo werkt het in retail.

| Boom | Perk | Spell | Rangen | Kolom | Node | Vereist (pijl) |
|---|---|---|---|---|---|---|
| Professions | Working Overtime | 1225451 | 5 | 1 | 110290 | — |
| Professions | Bountiful Harvest | 1225435 | 5 | 1 | 110291 | — |
| Professions | Master Chef | 1225457 | 5 | 2 | 110289 | — |
| Professions | Bartering | 1225459 | 2 | 2 | 110286 | — |
| Professions | Performance Bonus | 1225456 | 3 | 2 | 110292 | Bountiful Harvest |
| Professions | Luremaster | 1225455 | 2 | 2 | 110293 | — |
| Professions | Dedicated Study | 1225469 | 1 | 3 | 110284 | Bartering |
| Adventure | Well Rested | 1225478 | 5 | 1 | 110301 | — |
| Adventure | Thrill of Adventure | 1225472 | 5 | 1 | 110296 | — |
| Adventure | High Alert | 1225477 | 2 | 2 | 110305 | — |
| Adventure | Talented | 1225474 | 5 (trapjes) | 2 | 110298 | Well Rested |
| Adventure | Field Guide | 1225479 | 3 | 2 | 110304 | — |
| Adventure | Field Medicine | 1225475 | 2 | 2 | 110303 | — |
| Adventure | Frequent Flier | 1225490 | 1 | 3 | 110300 | Field Guide |
| Resourcefulness | Gourmand | 1225499 | 3 | 1 | 110313 | — |
| Resourcefulness | The Quick and the Dead | 1225500 | 2 | 1 | 110315 | — |
| Resourcefulness | Reinforce | 1225497 | 5 | 1 | 110318 | — |
| Resourcefulness | For Great Honor | 1225501 | 5 | 2 | 110319 | — |
| Resourcefulness | Permanence | 1225502 | 2 | 2 | 110316 | Gourmand |
| Resourcefulness | Diplomat | 1225485 | 5 | 2 | 110314 | — |
| Resourcefulness | Reagent Economy | 1225503 | 1 | 3 | 110309 | The Quick and the Dead |

Elke boom telt 23 rangen (GEMETEN, opgeteld). Met 16 punten past er dus hooguit één kolom-3-perk op een character: die kost minstens 11 punten (10 voor de poort + 1). AFGELEID uit 3.4, 3.5 en 3.8.

## 6. Talented

| # | Bewering | Uitslag | Bron |
|---|---|---|---|
| 6.1 | TraitCurrencySource 37163–37167, "Talented Rank 1 (Level 9)" … "Rank 5 (Level 5)", currency 3820 | ✅ GEMETEN | DB2 `TraitCurrencySource` |
| 6.2 | Node 110298 in boom 1188, tiered | ✅ GEMETEN | DB2 `TraitNode`: `110298, 1188, Type 1` (UI-enum `TraitNodeType.Tiered = 1`). UI: `LEGACY_TREE_ADVENTURE_TALENTED_NODE_ID = 110298` |
| 6.3 | Entries 136852 / 137374 / 137373 / 137372 / 137371 = rang 1–5 | ✅ GEMETEN | DB2 `TraitNodeXTraitNodeEntry` (index 100/200/300/400/500) en de koppeling in `TraitCurrencySource.TraitNodeEntryID` |

Extra, GEMETEN: de speltekst zegt "you still may not have more than 51 total talent points" en DB2 `TraitCurrency 3820` heeft `SourcedMax 51`. Talented geeft dus **eerder** punten, niet **meer**. Blizzards eigen knop rekent zo: `10 − nodeInfo.activeRank` (UI `MainMenuBarMicroButtonsOverrides.lua`).

## 7. API's (waren AFGELEID, nu nagemeten)

| # | Bewering | Uitslag | Bron |
|---|---|---|---|
| 7.1 | `Constants.LegacyConsts.*` | ✅ GEMETEN | UI `LegacyConstantsDocumentation.lua`, waarden hieronder |
| 7.2 | `C_Traits.GetConfigIDBySystemID(45)` | ✅ bestaat, maar **gebruik hem niet** | Functie GEMETEN in UI `SharedTraitsDocumentation.lua`; systeem 45 GEMETEN in DB2 (`TraitTree.TraitSystemID`). Blizzards Legacy-venster gebruikt hem nergens. In systeem 45 zit ook een lege boom 1118, dus het antwoord kan dubbelzinnig zijn (AFGELEID) |
| 7.3 | `C_Traits.GetConfigIDByTreeID` | ✅ GEMETEN | Dit is wat Blizzard zelf gebruikt (`Blizzard_LegacySystemUtil.lua`, `Blizzard_LegacyTree.lua`) |
| 7.4 | `C_Traits.GetTreeCurrencyInfo` | ✅ GEMETEN | Argumenten `(configID, treeID, excludeStagedChanges)` |
| 7.5 | `C_Traits.GetNodeInfo` | ✅ GEMETEN | `(configID, nodeID)` |
| 7.6 | Event `TRAIT_TREE_CURRENCY_INFO_UPDATED` | ✅ GEMETEN | UI docs + `Blizzard_SharedTalentFrame.lua` |
| 7.7 | Event `TRAIT_CONFIG_UPDATED` | ✅ GEMETEN | idem |
| 7.8 | Event `TRAIT_NODE_CHANGED` | ✅ GEMETEN | idem |
| 7.9 | `LegacySystemFrame_LoadUI()` in `Blizzard_LegacySystem` | ✅ GEMETEN | UI `Blizzard_LegacySystem_Bootstrap.lua`. TOC: `LoadOnDemand: 1`, `AllowLoadGameType: camelot` |

**`Constants.LegacyConsts` (GEMETEN, UI-documentatie build 70938):**

| Naam | Waarde |
|---|---|
| `LEGACY_REWARD_TRACK_FACTION_ID` | 2802 |
| `LEGACY_POINTS_TRAIT_CURRENCY_ID` | 4225 |
| `LEGACY_TREE_PROFESSIONS_ID` | 1187 |
| `LEGACY_TREE_ADVENTURE_ID` | 1188 |
| `LEGACY_TREE_PROGRESSION_ID` | 1189 |
| `LEGACY_TREE_ADVENTURE_TALENTED_NODE_ID` | 110298 |
| `LEGACY_DEFAULT_CATEGORY_WARRIOR` / `PALADIN` / `HUNTER` / `ROGUE` / `PRIEST` / `SHAMAN` / `MAGE` / `WARLOCK` / `DRUID` | 15585 / 15580 / 15578 / 15582 / 15581 / 15583 / 15579 / 15584 / 15577 |

**Zo leest Blizzards eigen venster de punten (GEMETEN, letterlijk uit `Blizzard_LegacySystemUtil.lua`):**

```lua
local treeID = LegacyTreeData[1].treeID;                  -- = Constants.LegacyConsts.LEGACY_TREE_PROFESSIONS_ID (1187)
local configID = C_Traits.GetConfigIDByTreeID(treeID);
local excludeStagedChanges = false;
local treeCurrencyInfo = C_Traits.GetTreeCurrencyInfo(configID, treeID, excludeStagedChanges);
local currencyInfo = treeCurrencyInfo and treeCurrencyInfo[1] or nil;
currencyInfo.renownCurrency = C_MajorFactions.GetCurrentRenownLevel(Constants.LegacyConsts.LEGACY_REWARD_TRACK_FACTION_ID);
```

Wat Blizzard met de velden doet (GEMETEN in de UI-code):

| Veld / aanroep | Waar Blizzard het toont |
|---|---|
| `currencyInfo.quantity` | "Available points: %s" (`LEGACY_POINTS_AVAILABLE`) |
| `currencyInfo.maxQuantity` | het getal in de "seasonal cap"-tooltip (nu 16) |
| `currencyInfo.spentInTree` | het getal "uitgegeven in deze boom" |
| `C_MajorFactions.GetCurrentRenownLevel(2802)` | het grote puntentotaal in het schild en op de beloningsbalk = **verdiende** punten |
| `C_Traits.GetMaxAvailableTraitCurrency(4225, false)` | het tweede getal in "Legacy Points %d / %d" (`LEGACY_POINTS_CURR_MAX`) = hoeveel er te verdienen valt |
| `C_Traits.GetTraitCurrencyForAchievement(4225, achievementID)` | hoeveel punten één challenge geeft |
| `C_MajorFactions.GetRenownLevels(2802)` + `GetRenownRewardsForLevel(2802, level)` | de beloningsbalk (15 / 25 / 40 / 55) |
| `nodeInfo.currentRank` / `nodeInfo.maxRanks` | "2/5" op een perk-knop |
| `C_Traits.GetTreeInfo(configID, treeID).cannotRefund` | verbergt de Reset-knop |

Structuur `TreeCurrencyInfo` (GEMETEN, UI-docs): `traitCurrencyID`, `quantity`, `maxQuantity` (kan nil zijn), `spent`, `spentInTree` (kan nil zijn).

Events die Blizzards Legacy-knop zelf gebruikt (GEMETEN): `ACHIEVEMENT_EARNED`, `MAJOR_FACTION_RENOWN_LEVEL_CHANGED` (argumenten: `majorFactionID, newRenownLevel, oldRenownLevel`), `UPDATE_BINDINGS`.

Overige globale functies (GEMETEN, `Blizzard_LegacySystem_Bootstrap.lua`): `ToggleLegacySystemUI()`, `ToggleLegacyChallenges()`, `ShowLegacyChallenge(achievementID, closeOtherWindows)`. `ToggleLegacySystemUI()` doet **niets** zolang het renown-level 0 is.

**Niet gemeten:** wat deze aanroepen op een echt character teruggeven. Dat kan alleen in het spel. Voorstel voor Rob (één regel, onder 255 tekens):

```
/dump C_MajorFactions.GetCurrentRenownLevel(2802), C_Traits.GetTreeCurrencyInfo(C_Traits.GetConfigIDByTreeID(1187),1187,false)
```

---

## 8. Nieuwe feiten (stonden niet in het eerdere onderzoek)

### 8.1 Dedicated Study is geen passieve perk — het is een knop
GEMETEN. DB2 `SpellMisc` 1225469: geen passief-vlag (`Attributes_0 = 0`; de andere 20 perks hebben 448), `CastingTimeIndex 37` = 25 000 ms. DB2 `SpellCooldowns`: `CategoryRecoveryTime 82 800 000` ms = 23 uur. WH-tip bevestigt: "25 sec cast, 23 hrs cooldown". BLIZ noemt het "a daily cooldown".
Dat de vlag 0x40 "passief" betekent is AFGELEID (vaste betekenis in WoW-spelldata).

### 8.2 Elke boom heeft 2 lege vakjes "Unknown"
GEMETEN. DB2 `TraitNode`: 27 nodes in de drie bomen = 21 perks + 6 extra (113506, 113508 in 1187; 113510, 113511 in 1188; 113512, 113513 in 1189). Alle zes wijzen naar spell **1317256 "Unknown"** met tekst "To be added in a future update." Ze staan in kolom 3 (PosX 4200) en een nieuwe kolom 4 (PosX 5100), met een pijl ertussen. `Flags = 10` = `NeverPurchasable` (2) + `TestGridPositioned` (8), volgens de UI-enum `TraitNodeFlag`.
Gevolg: wie `C_Traits.GetTreeNodes(treeID)` afloopt krijgt **9** nodes per boom, niet 7. Sla nodes met vlag 2 over.

### 8.3 Twee reeksen achievement-ID's voor dezelfde 65 challenges
GEMETEN. Reeks A: 684 (Onyxia), 61499–61504, 61989, 61992–62026, 62028–62035, 62041–62049, 62054, 62382, 63340–63342; `Achievement.Flags = 134349824`. Reeks B: 63969–64033 (aaneengesloten); `Flags = 268567552`. Zelfde titels, zelfde teksten.
In `TraitCurrencySource` hoort reeks A bij waarde 60 en reeks B bij waarde 61 in de kolom die wago `SuperDistrictSetID` noemt. Retail heeft die kolom niet (GEMETEN, retail-header 12.1.5.70783). De tabel `SuperDistrictSet` bestaat in Forever; rij 60 en 61 hebben daar allebei type 12.
**Wat 60 en 61 betekenen is niet gemeten (❓).** Vermoeden (AFGELEID): het hangt samen met de aparte Hardcore-regels uit BLIZ (8.4).
Gevolg voor de bouw: **geen achievement-ID's uit één reeks vastleggen.** Vraag de client: loop de categorieën af met `GetCategoryNumAchievements` / `GetAchievementInfo(categoryID, index)` en gebruik `C_Traits.GetTraitCurrencyForAchievement(4225, id)`. Zo doet Blizzards eigen venster het ook.
Test voor Rob om te zien welke reeks zijn client gebruikt: `/dump C_Traits.GetTraitCurrencyForAchievement(4225,61499), C_Traits.GetTraitCurrencyForAchievement(4225,63969)`

### 8.4 Hardcore heeft eigen regels
GEMETEN in BLIZ (23 sep 2026): Hardcore is er bij de start niet. Challenges uit gewone realms tellen niet in Hardcore. Een challenge die je in Hardcore haalt telt wél overal. PvP-challenges kunnen niet in Hardcore; daarvoor komen 12 eigen challenges. WH-gids (15 nov 2026) zegt hetzelfde.

### 8.5 Het puntentotaal is een "renown-level"
GEMETEN. DB2 `Faction` 2802 = "Legacy Track", `RenownCurrencyID 3485`. DB2 `CurrencyTypes` 3485 = "Renown - Legacy Rank", `MaxQty 90`. Wat die 90 betekent is niet gemeten.

### 8.6 Talented kun je niet zomaar terugdraaien
GEMETEN. DB2 `GlobalStrings` `ERR_LEGACY_WIPE_ERROR_CLASS_POINTS`: "Unlearning your "Talented" legacy perk would put you at a talent point deficit. You must unlearn your class talents first." UI-enum `TraitVendorResetFailureReason.ClassPointDeficit`.

### 8.7 Wowhead-tooltips tonen bij 4 perks het verkeerde getal
GEMETEN, zie hoofdstuk 9. Wowhead toont de kale spell-waarde, niet de waarde per rang.

### 8.8 Spaanse client (esES): twee perks met dezelfde naam
GEMETEN in DB2 `SpellName.esES` én WH-tip (esES): spell 1225485 (Diplomat) heet daar **"Estudio dedicado"**, net als 1225469 (Dedicated Study). Waarschijnlijk een vertaalfout van Blizzard. In esMX heet Diplomat "Diplomático". Of de esES-client dit echt zo toont is niet in het spel gemeten.

### 8.9 De knopnaam is in drie talen vreemd vertaald
GEMETEN in DB2 `GlobalStrings` `LEGACY_BUTTON`: deDE "Klassisch", esES "Banda antigua", ruRU "Классические". frFR "Héritage", esMX en ptBR "Legado". Het is wat de client toont.

### 8.10 Italiaans bestaat niet voor Forever
GEMETEN: in `GlobalStrings.itIT` en `SpellName.itIT` staan al deze teksten in het Engels.

### 8.11 Reagent Economy: Blizzards artikel zegt meer dan de speltekst
GEMETEN. Client (build 70938): "Your class abilities no longer require reagents purchaseable from vendors." BLIZ en WH-gids voegen toe dat tier-1-kampeeronderdelen geen materialen kosten. Dat staat **niet** in de speltekst. Of het effect bestaat is niet gemeten.

### 8.12 Er liggen 14 ongebruikte perks in de data
GEMETEN: `TraitNodeEntry` 136840–136876 bevat ook entries die aan geen enkele node hangen (controle in dezelfde zoekactie: 136844 gaf wél een treffer). Namen onder meer Meticulous, Master Forager, Second Home, Master Swimmer, Play Dead, Iron Stomach, Personal Banking, Fast Recovery, Second Chance, Adaptability, "Optimization - NYI". Niet in het spel te kiezen; niet noemen.

---

## 9. Spelertekst per perk met de echte getallen

Bron tekst: DB2 `Spell.Description_lang` (enUS). Bron getallen: DB2 `TraitDefinitionEffectPoints` → `CurvePoint` (waarde per rang; `OperationType 0` = `Set` volgens de UI-enum). Waar geen curve bestaat geldt de kale waarde uit `SpellEffect`. **Alles GEMETEN in DB2.** Dat de client de curve-waarde in de tooltip zet is AFGELEID (zo werken talenten). Steun, geen bewijs: vier sites die zeggen uit de client te lezen tonen dezelfde rij-waarden (wowfdb.com build 70938; sixtyforever.com en wowforeverbuilder.com beta-build 70425; endgametools.com). Zij putten uit dezelfde clientdata als DB2, dus het is geen onafhankelijke meting. Echt bewijs = de tooltip in het spel.

### Professions

| Perk | Tekst (X = getal per rang) | Per rang | Afwijkingen |
|---|---|---|---|
| Working Overtime | Increases your chance to gain a skill increase from using any primary, secondary, or class-based tradeskill by X%. | 4 / 8 / 12 / 16 / 20 | ⚠ WH-tip toont **10%**. Dat getal bestaat op geen enkele rang |
| Bountiful Harvest | You are X% more likely to discover Scarce materials from Mining, Herbalism, and Skinning. | 20 / 40 / 60 / 80 / 100 | WH-gids schrijft "amount … by 20%"; de client zegt "more likely" (kans, niet hoeveelheid) |
| Master Chef | Your cooking recipes have a X% chance to create an extra result. | 10 / 20 / 30 / 40 / 50 | ⚠ WH-tip toont **30%** |
| Bartering | Reduces the gold price of items from all vendors by X%. | 5 / 10 | WH-gids laat Bartering weg uit de tabel |
| Performance Bonus | You have a X% chance to receive 100% increased Merchant's Favor when you turn in a crate to the Azeroth Commerce Authority or Durotar Supply and Logistics. | 5 / 10 / 15 | ⚠ WH-gids zegt 5 rangen; het zijn er **3** |
| Luremaster | While fishing with a Lure active, you have a X% chance to catch an extra fish. | 25 / 50 | ⚠ WH-gids zegt 5 rangen; het zijn er **2** |
| Dedicated Study | Increases your skill by 1 in your lowest tradeskill among your Primary and Secondary tradeskills. If you have already reached 300 skill in your two current Primary Tradeskills and all three Secondary Tradeskills, you will gain 2 to 4 of a random Elemental Essence. | 1 rang. **25 sec cast, 23 uur cooldown** | DB2: basiswaarde 3 met spreiding 0,667; WH-tip toont "2 to 4". warcraftmaps.com schrijft "3" |

### Adventure

| Perk | Tekst | Per rang | Afwijkingen |
|---|---|---|---|
| Well Rested | Your rested experience accumulates X% faster and your rested experience cap is increased by X%. | 4 / 8 / 12 / 16 / 20 (beide getallen) | — |
| Thrill of Adventure | You gain X% of your maximum Health and Mana over 10 sec each time you deliver the killing blow to a non-trivial enemy. Ineffective in dungeons, raids, and battlegrounds. | 1 / 2 / 3 / 4 / 5 | "10 sec" = duur van spell 1261483 (DB2 `SpellDuration` 1 = 10 000 ms) |
| High Alert | Increases your ability to detect nearby targets with Stealth as if your level were increased by X. Ineffective in Battlegrounds. | 1 / 2 | Curve geeft 5 / 10; de tekst deelt door 5 |
| Talented | You gain talent points every level starting at level X instead of starting at level 10, but you still may not have more than 51 total talent points. | 9 / 8 / 7 / 6 / 5 | — |
| Field Guide | Reduces your cooldown on adding Camp features by X% | 8 / 17 / 25 | Curve −288 000 / −612 000 / −900 000 ms, tekst deelt door 36 000. BLIZ: de cooldown is 1 uur. In de client staat geen punt achter de zin |
| Field Medicine | Reduces the duration of the Recently Bandaged effect by X sec when you use a bandage. Ineffective in dungeons, raids, and battlegrounds. | 5 / 10 | — |
| Frequent Flier | You receive a 50% discount on all flight paths, and your flight path mount flies 20% faster. | 1 rang | Geen curve; kale waarden −50 en 20 |

### Resourcefulness

| Perk | Tekst | Per rang | Afwijkingen |
|---|---|---|---|
| Gourmand | Increases the duration of beneficial effects from eating food by X%. | 33 / 67 / 100 | — |
| The Quick and the Dead | Increases movement speed while dead by X% and your helpful spells and abilities cost no resources for Y min after being resurrected or until you enter combat. | X = 5 / 10, Y = 1 / 2 | — |
| Reinforce | You take X% less durability loss when you die. | 8 / 16 / 24 / 32 / 40 | ⚠ WH-tip toont **20%**. WH-gids noemt geen getal |
| For Great Honor | Increases Honor Points gained by X%. | 2 / 4 / 6 / 8 / 10 | — |
| Permanence | Your class abilities which grant long-duration stat or attribute benefits to all party or raid members last X% longer, and the benefits you gain from resting at a camp last Y% longer. | X = 50 / 100, Y = 50 / 100 | ⚠ WH-tip toont **100% en 50%**; op rang 2 is het 100% en 100% |
| Diplomat | Increases your reputation gains by X%. | 2 / 4 / 6 / 8 / 10 | — |
| Reagent Economy | Your class abilities no longer require reagents purchaseable from vendors. | 1 rang, geen getal | Zie 8.11. "purchaseable" staat zo in de client |

Lege vakjes: spell 1317256 "Unknown" — "To be added in a future update."

---

## 10. Clientnamen per taal

Bron: DB2 `SpellName.<taal>.csv`, build 70938. **GEMETEN.** itIT = Engels (8.10). Let op het krullende teken ’ in het Frans.

| Spell | enUS | deDE | frFR | esES | esMX | ptBR | ruRU |
|---|---|---|---|---|---|---|---|
| 1225451 | Working Overtime | Überstunden machen | Heures supplémentaires | Horas extra | Horas extra | Hora Extra | Сверхурочные |
| 1225435 | Bountiful Harvest | Reiche Ernte | Récolte généreuse | Cosecha generosa | Cosecha abundante | Colheita Farta | Обильная жатва |
| 1225457 | Master Chef | Meisterkoch | Cordon bleu | Maestro cocinero | Maestro cocinero | Mestre Chef | Шеф-повар |
| 1225459 | Bartering | Feilschen | Marchandage | Regateando | Regateo | Pechincha | Товары со скидкой |
| 1225456 | Performance Bonus | Leistungsbonus | Bonus de performance | Bonus de rendimiento | Bonificación de desempeño | Bônus de Desempenho | Бонус за производительность |
| 1225455 | Luremaster | Meister der Köder | Maître des appâts | Maestro de los cebos | Maestro del cebo | Mestre das Iscas | Мастер приманок |
| 1225469 | Dedicated Study | Engagiertes Studium | Étude assidue | Estudio dedicado | Estudio dedicado | Estudo Dedicado | Усердная учеба |
| 1225478 | Well Rested | Gut ausgeruht | Bien reposé | Bien descansado | Bien descansado | Bem Descansado | Хороший отдых |
| 1225472 | Thrill of Adventure | Abenteuerlust | Frisson de l’aventure | Emoción de la aventura | Pasión por la aventura | Emoção da Aventura | Приключенческий азарт |
| 1225477 | High Alert | Höchste Alarmstufe | Alerte avancée | Alerta máxima | Alerta máxima | Nível Alto de Alerta | Повышенная готовность |
| 1225474 | Talented | Talentiert | Talent | Talentoso | Talentoso | Talento é para quem tem | Талантливый герой |
| 1225479 | Field Guide | Leitfaden | Guide de terrain | Guía de campo | Guía de campo | Guia de Campo | Полевое руководство |
| 1225475 | Field Medicine | Feldmedizin | Médecine de terrain | Medicina de campo | Medicamento de campo | Medicina de Campo | Полевая медицина |
| 1225490 | Frequent Flier | Vielflieger | Vols fréquents | Viajero frecuente | Volador frecuente | Voador Frequente | Полеты со скидкой |
| 1225499 | Gourmand | Gourmand | Gourmand | Gastronomía | Gastronomía | Glutão | Гурман |
| 1225500 | The Quick and the Dead | Schneller als der Tod | Mort et vif | Este muerto está muy vivo | Este muerto está muy vivo | Rápida e Mortal | Быстрый и мертвый |
| 1225497 | Reinforce | Verstärken | Renforcer | Refuerzo | Refuerzo | Reforçar | Укрепление |
| 1225501 | For Great Honor | Große Ehre | Pour un grand honneur | Por gran honor | Cuestión de honor | Por Grande Honra | Великая честь |
| 1225502 | Permanence | Permanenz | Permanence | Permanencia | Permanencia | Permanência | Постоянство |
| 1225485 | Diplomat | Diplomat | Diplomatie | **Estudio dedicado** (zie 8.8) | Diplomático | Diplomata | Дипломат |
| 1225503 | Reagent Economy | Reagenzwirtschaft | Économie des composants | Ahorro de componentes | Ahorro de componentes | Economia de Reagentes | Экономия реагентов |
| 1317256 | Unknown | Unbekannt | Inconnu | Desconocido | Desconocido | Desconhecido | Неизвестно |

**Venster- en boomnamen (DB2 `GlobalStrings.<taal>`, GEMETEN):**

| Tag | enUS | deDE | frFR | esES | esMX | ptBR | ruRU |
|---|---|---|---|---|---|---|---|
| `LEGACY_TREE_PROFESSIONS` | Professions | Berufe | Métiers | Profesiones | Profesiones | Profissões | Профессии |
| `LEGACY_TREE_ADVENTURE` | Adventure | Abenteuer | Aventure | Aventura | Aventura | Aventura | Приключения |
| `LEGACY_TREE_PROGRESSION` | Resourcefulness | Einfallsreichtum | Ingéniosité | Ingenio | Inventiva | Desenvoltura | Находчивость |
| `LEGACY_REWARD_TRACK_POINTS` | Legacy Points | Vermächtnispunkte | Points d’héritage | Puntos de legado | Puntos de legado | Pontos de Legado | Очки старинных наград |
| `LEGACY_TREE_FRAME_TITLE` | Legacy Tree | Vermächtnisbaum | Arbre d’héritage | Árbol de legado | Árbol de legado | Árvore de Legado | Старинное древо |
| `LEGACY_CHALLENGE_FRAME_TITLE` | Legacy Challenges | Vermächtnis-Herausforderungen | Défis d’héritage | Desafíos de legado | Desafíos de legado | Desafios de Legado | Старинные испытания |
| `LEGACY_TRACK_FRAME_TITLE` | Progress Track | Fortschrittsanzeige | Suivi de la progression | Seguimiento de progreso | Línea de progreso | Trilha de progresso | Шкала прогресса |
| `LEGACY_BUTTON` | Legacy | Klassisch | Héritage | Banda antigua | Legado | Legado | Классические |

Tip (AFGELEID): omdat MH in het spel draait kan het deze namen ook live ophalen (`_G.LEGACY_TREE_PROFESSIONS`, `C_Spell.GetSpellName(id)`). Dan volgt de addon vanzelf een latere correctie van Blizzard.

---

## 11. Wat de schrijver mag gebruiken

**Vast en veilig (GEMETEN in Blizzards data of Blizzards eigen tekst):**

1. Legacy Points verdien je op je hele account, met 65 challenges. Elke challenge geeft 1 punt.
2. Elk character geeft zijn eigen punten uit. Nu maximaal 16 per character ("seasonal cap").
3. Drie bomen: Professions, Adventure, Resourcefulness. Elke rang kost 1 punt.
4. Kolom 2 gaat open na 5 punten in die boom, kolom 3 na 10.
5. De 21 perks, hun rangen en de getallen per rang uit hoofdstuk 9. Gebruik de rij-getallen, niet de Wowhead-tooltip.
6. Dedicated Study is een knop: 25 seconden casten, 23 uur wachttijd.
7. Talented geeft talentpunten eerder (vanaf level 9 tot 5), nooit meer dan 51.
8. Het venster gaat open bij je eerste punt. Voor de meeste spelers is dat level 25. Standaardtoets Y (alleen Blizzards artikel).
9. Beloningen bij 15 / 25 / 40 / 55 verdiende punten; ophalen bij Innkeeper Wiley in Ratchet (62.05, 39.41).
10. Terugdraaien: alle perks tegelijk, bij je class-trainer. Heb je Talented, dan moet je eerst je class-talenten terugdraaien.
11. Verzamelberoepen en Cooking, First Aid, Fishing geven geen punten.
12. De namen per taal uit hoofdstuk 10.

**Niet gebruiken of eerst nameten:**

- Geen bedrag voor het terugdraaien (❓ 3.9). Schrijf: "de trainer laat de prijs zien".
- Geen vaste achievement-ID's (8.3). Laat de client de lijst geven.
- Niets over de "Unknown"-vakjes behalve dat ze later komen (8.2).
- Niets over kampeeronderdelen bij Reagent Economy (8.11).
- Niet "vereist 5/5" als hard feit: de pijl is gemeten, "vol" is afgeleid (hoofdstuk 5). Veilig is: "vereist Well Rested".
- Hardcore: alleen noemen dat het eigen regels krijgt en er nog niet is (8.4).

**Voor de bouwer:**

- Lees punten zoals Blizzard: `C_Traits.GetConfigIDByTreeID(1187)` → `C_Traits.GetTreeCurrencyInfo(configID, 1187, false)[1]`; totaal verdiend = `C_MajorFactions.GetCurrentRenownLevel(2802)`.
- Gebruik `Constants.LegacyConsts` in plaats van losse getallen, met een nil-check (bestaat alleen in Forever).
- `GetConfigIDByTreeID` kan nil geven (Blizzard checkt daar zelf op). nil = nog niet leesbaar, niet "nul punten".
- Sla nodes met `flags` bit 2 (`NeverPurchasable`) over.
- Alle `C_Traits`-functies dragen in de documentatie `SecretArguments = "AllowedWhenUntainted"`. Wat dat voor een addon betekent is niet gemeten.

## 12. Open punten (niet te meten zonder het spel)

| Punt | Hoe te meten |
|---|---|
| Wat de API op een echt character teruggeeft | `/dump`-regel uit hoofdstuk 7 |
| Welke achievement-reeks (A of B) Robs client gebruikt | `/dump`-regel uit 8.3 |
| Prijs van terugdraaien, en of die oploopt | Bij de class-trainer het bevestigingsvenster lezen |
| Toont de esES-client echt "Estudio dedicado" bij Diplomat | Alleen op een Spaanse client |
| Is "vol" echt nodig voor de pijl-perks | In het venster: Well Rested op 4/5 zetten en kijken of Talented open is |
| Toont de perk-tooltip in het spel de rij-waarde (hoofdstuk 9) | In het Legacy-venster met de muis op Reinforce: rang 1 hoort 8% te tonen, niet 20% |
| Wat de waarden 60 en 61 (twee achievement-reeksen) betekenen | Niet uit clientdata te halen; volgt deels uit de `/dump`-regel van 8.3 |
