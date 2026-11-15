# Patch 12.1.7 "Echoes of the Worldcore": wat zegt de community?

Speuropdracht 5 van 5. Gemaakt op zondag 15 nov 2026. Ik heb alleen gelezen. Ik heb niets in MH veranderd.

## Zo lees je dit

- **GEMETEN** = ik las het zelf, in de bron die erbij staat. Ik zeg ook wat voor bron het is:
  - *blue post* = Blizzard zelf.
  - *datamine* = iemand heeft het uit de speldata van de PTR gehaald. Het kan nog veranderen.
  - *DB2* = ik heb het zelf in Blizzards speltabellen gezien (wago.tools, via `tools/gamedata.py`).
  - *addon-code* = de GitHub van een addon-maker (commits, changelog, TOC).
  - *gids* = een site die het zelf uitlegt of een schatting maakt.
  - *spelermening* = wat een speler zegt. Dat is een kandidaat, geen bewijs.
- **AFGELEID** = mijn eigen conclusie uit wat ik las.
- **[RAAKT MH]** = hier zie ik een plek in MH die het raakt. Bij elke plek staat bestand en regel.

---

## 0. Het korte verhaal

1. Blizzard heeft nog geen datum genoemd. Maar de speldata zet Turbulent Timeways op **di 1 dec (US) en wo 2 dec (EU)**. Blizzard zegt dat dat event begint "at the launch" van 12.1.7. Dus 1/2 dec is heel waarschijnlijk.
2. Blizzard schreef na 29 okt geen PTR-notities meer. Er staan **geen klasse-wijzigingen** in. Spelers klagen daarover.
3. Addon-makers deden voor 12.1.7 bijna alleen **het TOC-nummer** omhoog (DBM, BigWigs, LittleWigs, Dominos). Het echte werk ging naar WoW Forever.
4. De grote API-verandering is **GUID-versluiering** (server-ID en spawn-ID). Die komt "in a future build". AllTheThings moest er op Forever al iets voor uitzetten.
5. 12.1.7 neemt ook de Forever-regels van 1.60.1 mee. Eén daarvan: **Edit Mode-layouts worden per UI-soort bewaard** (muis/toetsenbord apart van gamepad).
6. **Aqir Invasions verdwijnen.** De beloningen blijven, maar zonder reputatie-eis en duurder (Corrupted Swarmer 2.500 → 3.500 Marl). MH-tekst zegt nog 2.500 en "Exalted".
7. **Talebound wordt een bron van crests, Venomstones en gear** (Mistcrest-zakjes, Venomstone Cache, gear-kisten). MH kent Talebound als bron nog nergens.
8. Turbulent Timeways duurt **8 weken** (speldata: 1344 uur). De Wowhead-gids zegt nog 6 weken. Die is verouderd.
9. De Omnium Folio krijgt **2 nieuwe runes en 2 nieuwe quests**. MH's Folio-data heeft er nog 5 rijen.
10. MH laadt niet in Talebound (`## AllowLoadGameType: standard`). Dat is goed. Dominos doet hetzelfde met `ExcludeLoadGameType: wowhack`.

---

## 1. Wanneer komt 12.1.7?

- Blizzard heeft geen live-datum gegeven.
  GEMETEN, *spelermening*: forumtopic "When will 12.1.7 be an[n]ounced", 11 nov, geen antwoord van Blizzard.
  https://us.forums.blizzard.com/en/wow/t/when-will-1217-be-an-ounced/2411077
  GEMETEN, *blue post*: de PTR-notities (topic 2383391) hebben na 29 okt geen nieuw bericht (zie §2).
- Blizzard Watch gokt **di 8 dec** (US). Dat is rekenwerk, geen datum van Blizzard.
  GEMETEN, *gids*, 15 okt: https://blizzardwatch.com/2026/10/15/wow-midnight-patch-12-1-7-release-date/
- **De speldata zegt 1 dec (US) en 2 dec (EU).**
  GEMETEN, *DB2*: tabel `Holidays`, HolidayNameID 430 = "Turbulent Timeways".
  - PTR 12.1.7.70892: er is een nieuwe datum. Rij US (Region 961) = 1 dec 2026 07:00. Rij EU (Region 4) = 2 dec 2026 05:00. Rijen Azië (2 en 24) = 3 dec. Duur = 1344 uur = 8 weken.
  - Live 12.1.5.70783: die datum staat er niet. Duur = 1008 uur = 6 weken (dat was de ronde van 30 jun – 11 aug).
  - Controle: dezelfde rij geeft ook de oude data 26 sep 2023, 7 jan 2025, 17 jun 2025, 2 dec 2025 en 30 jun 2026. Die kloppen met de Warcraft Wiki. De datums heb ik met de hand uit het getal gehaald.
  - Welke Region-code welk land is: AFGELEID uit de weekdag (US reset op dinsdag, EU op woensdag).
  GEMETEN, *blue post*, 15 okt: "Turbulent Timeways begins at the launch of Echoes of the Worldcore and lasts eight weeks."
  https://www.mmo-champion.com/content/14609-Patch-12-1-7-Echoes-of-the-Worldcore-Overview
  AFGELEID: dus 12.1.7 gaat live op **di 1 dec (US) / wo 2 dec (EU)**. Dit kan nog schuiven.
  Een gids zag hetzelfde in de PTR-kalender. GEMETEN, *gids*, mmonster.co, 2 nov: https://mmonster.co/blog/wow-patch-12-1-7
- PTR-builds: 70424 (15 okt), 70493 (22 okt), 70668 (29 okt), 70740 (4 nov), 70892 (12 nov).
  GEMETEN, *datamine*: https://thewowdb.com/news/retail-ptr-12-1-7-21578/ en de commits in https://github.com/Gethe/wow-ui-source (tak 12.1.7).

---

## 2. Wat Blizzard zelf zei (blue posts)

Bron: het topic "Midnight: Echoes of the Worldcore PTR Development Notes". Ik las de JSON van het forum op 15 nov.
https://us.forums.blizzard.com/en/wow/t/2383391

- Bericht 1 (15 okt). Bericht 2 en 3 (15 okt) zijn **leeg**. Die zijn vast gereserveerd. Bericht 4 (22 okt): één zin, "various bug fixes and behind-the-scenes updates". Bericht 5 (29 okt): de Talebound-demo. Daarna niets meer. GEMETEN, *blue post*.
- Er staan **geen klasse-wijzigingen** in. GEMETEN, *blue post*.
  Spelers vragen ernaar. GEMETEN, *spelermening*: "Where are the class/spec changes?", 29 okt – 13 nov, geen antwoord van Blizzard. https://us.forums.blizzard.com/en/wow/t/2395455
  Wel staan er wat klasse-getallen in de datamine van build 70668 (Hunter Explosive Shot, Trick Shots, Volley; Druid). GEMETEN, *datamine*, MMO-Champion, 29 okt: https://www.mmo-champion.com/threads/2670882-Patch-12-1-7-PTR-Build-70668
- Wat er in bericht 1 staat (GEMETEN, *blue post*, 15 okt):
  - Verhaal "The Return to Dornogal".
  - Lorewalking: 4 verhalen (Jaina, Thrall, Titans, Tyr), vanaf level 10.
  - Omnium Folio: 2 extra Motes of Omnial Inquiry en 2 nieuwe runes (zie §11).
  - Housing: decor draait niet meer vanzelf bij het laden.
  - Beroepen: meer Deftness uit *Bountiful Harvests* (Herbalism) en *Plentiful Ores* (Mining). Geen getallen.
  - Edit Mode: een optie om **door de Personal Resource Display heen te klikken**.
  - Tooltip: Outfit 1 van je transmog is wat de Armory laat zien.
  - Bekende fouten: lucht (skybox) op de Mac in Kalimdor en Eastern Kingdoms; een Lua-fout bij karakter-kopie, maar de kopie lukt wel.
- Talebound-demo op de PTR: 30 okt 10:00 PDT tot 2 nov 10:00 PDT. Geen abonnement nodig. GEMETEN, *blue post*, 29 okt.

---

## 3. Maakt 12.1.7 addons kapot? (API)

Hoofdbron: Warcraft Wiki "Patch 12.1.7/API changes". Geschreven door Meorawr op 16 okt. Laatste wijziging 16 okt (ik las de geschiedenis van de pagina). Dit is een samenvatting van Blizzards API-notities. De pagina met de officiële notities zelf bestaat nog niet (404).
https://warcraft.wiki.gg/wiki/Patch_12.1.7/API_changes

### 3a. GUID-versluiering

- Het server-ID en het spawn-ID in de GUID van casts, creatures, vehicles, pets en game objects worden onleesbaar. Ze blijven gelijk binnen jouw sessie. De vorm van de GUID blijft hetzelfde. Dit komt "in a future build of 12.1.7". GEMETEN, *wiki-samenvatting van Blizzard-notities*, 16 okt.
- Of het al in build 70892 zit: **niet gemeten**.
- Wat een addon-maker al moest doen: AllTheThings zet op Forever de tooltip-regels "Alive" en "Spawned" uit. Die gaven "random ages of up to about 97 days". GEMETEN, *addon-code*, 11 nov: https://github.com/ATTWoWAddon/AllTheThings/commit/5a1530a1a8fe2a450bcae86127f0a61c209ca6ac
  Ze zetten het alleen uit voor Forever. AFGELEID: op retail 12.1.7 krijgen ze dezelfde onzin.
- [RAAKT MH] MH haalt uit een GUID alleen het npcID (veld 6). Dat veld blijft leesbaar. GEMETEN: 12 keer `strsplit("-", …GUID…)` in 11 bestanden; zie `Modules/Rares.lua:1031` en `Modules/VignetteCapture.lua:45`. MH rekent nergens een spawn-tijd uit (geen `0x7fffff`, `2^23` of `spawnEpoch` gevonden).
  MH's eigen commits op GitHub zeggen: 17 okt "loosen GUID patterns", 9 nov "read the npc id from obfuscated creature GUIDs", 11 nov "GUID obfuscation closed addon-wide". GEMETEN, *commit-titels*. AFGELEID: één keer testen zodra de PTR-build het heeft.

### 3b. TOC-regels

- In `##`-regels worden variabelen zoals `[Game]` of `[Family]` niet meer ingevuld. Zo'n regel wordt helemaal overgeslagen. `[AllowLoadGameType …]` werkt gewoon. GEMETEN, *wiki*, 16 okt.
- [RAAKT MH] Niet. De `##`-regels van `MidnightHelper.toc` (regel 1-20) hebben geen variabelen. GEMETEN.
- Dominos gebruikt nog `localization\[TextLocale].lua` en `core\barStates\[Game].lua` als **bestandsregel**. AFGELEID: bestandsregels vallen hier niet onder; alleen `##`-regels. Een UI-simulator op GitHub schreef het ook zo: "variable-bearing ## metadata skipped" (Osso/wow-ui-sim, 23 okt, *addon-code*).

### 3c. De Forever-regels gaan mee (patch 1.60.1)

De wiki zegt: "Includes API changes from Patch 1.60.1". Dit zijn die regels. GEMETEN, *wiki-kopie van Blizzard-notities* (8 en 16 okt):
https://warcraft.wiki.gg/wiki/Patch_1.60.1/API_changes/notes

- `SendChatMessage` met "EMOTE" heeft buiten instances een toets- of klik-actie nodig (net als SAY en YELL al hadden).
  [RAAKT MH] Niet. MH stuurt geen "EMOTE". GEMETEN met grep; controle: "SAY" wordt wel gevonden (`DelvePartyShare.lua:169`, `RitualShare.lua:79`), en voor SAY gold de regel al.
- Proef-accounts (trial) kunnen **geen addon-berichten** meer sturen.
  [RAAKT MH] Klein. `Modules/Comms.lua`, `DelveShareSync.lua` en `ConsumableReadyComms.lua` sturen met `C_ChatInfo.SendAddonMessage` in een `pcall`. AFGELEID: op een trial gebeurt er dan stil niets.
- Nieuwe geheime eigenschap `FrameStrata`: `GetFrameStrata` kan een secret teruggeven bij frames met die eigenschap.
  AFGELEID: MH vraagt dit alleen van zijn eigen frames (`UI.lua:2289`, `Addons/Guide.lua:854-926`). Risico klein.
- `require` heet nu `import`.
- **Edit Mode-layouts worden per UI-soort bewaard** (muis en toetsenbord apart van gamepad). Een oude layout-tekst importeren geeft geen fout meer.
  [RAAKT MH] `Modules/EditModeBackup.lua` (GetLayouts, SaveLayouts, ConvertStringToLayoutInfo) en `Modules/BarInventory.lua:363`. MH weigert al een restore tussen versies (`EditModeBackup.lua:141-159`, 15 nov). AFGELEID: test op de PTR wat `GetLayouts` nu teruggeeft.
- Nieuwe CVars `nameplateMaxVerticalDistance` en `nameplateMaxVerticalDistanceAtMaxRange`.
  [RAAKT MH] Niet. MH zet geen nameplate-CVars (grep: 0).

### 3d. Nieuwe knop bij de minimap

- ElvUI moest een nieuwe Blizzard-knop opvangen: `MinimapBackdrop.ExternalEventURLButton`. GEMETEN, *addon-code*, 22 okt: https://github.com/tukui-org/ElvUI/commit/125a26fc
- Op 6 nov schreef ElvUI: "external event is also on forever (cn region)". Of de knop op retail 12.1.7 verschijnt: **niet gemeten**.

---

## 4. Wat moesten andere addon-makers aanpassen?

Ik las de commits sinds half oktober op GitHub (15 nov).

| Addon | Wat ze deden voor 12.1.7 | Datum | Soort |
|---|---|---|---|
| DBM | "Update tocs for 12.1.7 ptr". De andere 97 commits gaan over Forever en raids. https://github.com/DeadlyBossMods/DeadlyBossMods/commit/74dbddee | 23 okt | GEMETEN, addon-code |
| BigWigs | "Bump toc": 120107 erbij, **120007 eruit**. https://github.com/BigWigsMods/BigWigs/commit/0bf704d2 | 21 okt | GEMETEN, addon-code |
| LittleWigs | "Bump toc". Ook nieuwe delve-baasmodules (Ring of Glory: Gnok en Drakta; Gnarldor Isle; Labyrinth: Den'Zara). Dat is 12.1.5-inhoud. | 17-23 okt | GEMETEN, addon-code |
| Dominos | TOC: `## ExcludeLoadGameType: plunderstorm, wowhack`. Changelog 11.5.1: "Explicitly disabled Dominos for Plunderstorm and Talebound." Changelog 12.0.0: "In Forever and the 12.1.7 PTR, you can set bars to page into the gamepad UI range. This gives you a total of 360 action slots." En: "Action bar numbering now follows Blizzard's." https://github.com/tullamods/Dominos/blob/main/CHANGELOG.md | 9-15 nov | GEMETEN, addon-code |
| Bartender4 | Een eigen "vehicle"-knop, want de knop van Blizzard "is encumbered with EditMode hooks and can cause taint". https://github.com/Nevcairiel/Bartender4/commit/c452e25b | 14 nov | GEMETEN, addon-code |
| ElvUI | De nieuwe minimap-knop (§3d). Taint-reparaties: niet meer `x.SetTexture = E.noop`, maar `hooksecurefunc` (23 okt). Groter venster voor toetsen-binden (26 okt). "drop the secret check in UnitExists" (11 nov). | 22 okt – 15 nov | GEMETEN, addon-code |
| Details | "Use UnitNameFromGUID instead of UnitName where possible". | 15 okt | GEMETEN, addon-code |
| HandyNotes: Midnight Treasures and Rares (Kemayo) | Nog **geen** 12.1.7. TOC zegt `120105, 120100`. Laatste commit 21 okt. https://github.com/kemayo/wow-handynotes-midnight | 21 okt | GEMETEN, addon-code |
| Zygor | In het archief (tot 10 nov) zag ik geen 12.1.7-inhoud. Op 29 okt werkten ze de Aqir Invasions nog bij. https://zygorguides.com/archive | 10 nov | GEMETEN, gids |
| WeakAuras | Geen officiële Midnight-versie, alleen een fork. Niet zelf op GitHub gecontroleerd. https://wowaddons.xyz/ | 6 nov | GEMETEN, gids (tweedehands) |
| TomTom | Geen openbare GitHub gevonden. | - | niet gemeten |

AFGELEID: voor retail 12.1.7 veranderden addon-makers bijna alleen het TOC-nummer. Niemand meldt dat 12.1.7 zelf iets kapotmaakt. De echte drukte zit bij Forever.

- [RAAKT MH] **Talebound: goed geregeld.** `MidnightHelper.toc` regel 3 = `## AllowLoadGameType: standard`. MH laadt dus niet in Talebound en niet in Plunderstorm. GEMETEN. BigWigs (modules) en HandyNotes doen hetzelfde. Dominos sluit "wowhack" uit. Dat "wowhack" de interne naam van Talebound is: AFGELEID uit de speltekst (`WOWHACK_…`, `WOW_LABS_PRESENCE_GM3` = "Talebound" in build 70668).
- [RAAKT MH] **Taint-les van ElvUI en Bartender4.** Overschrijf geen functie van een Blizzard-frame met een lege functie. Gebruik `hooksecurefunc`. En raak de vehicle-knop van Blizzard niet aan (Edit Mode-hooks). AFGELEID: MH heeft 3 plekken die op zo'n patroon lijken (grep `= function() end` / `.SetTexture =` / `MainMenuBarVehicleLeaveButton`: `Modules/BarInventory.lua`, `Modules/WorldBoss.lua`, `tools/travel_harness/load.lua`). Niet nagekeken of dat Blizzard-frames zijn.

---

## 5. Delves, Valeera, Mythic+, Great Vault, crests, raid

- In de notities van Blizzard: **niets** over delves, Valeera, Mythic+, Great Vault of crests. GEMETEN, *blue post*.
- In de datamine van build 70493 staat bij Great Vault en Mythic+ ook niets. Wel nieuwe Labyrinth-prestaties: "Fabled Let Me Solo Him: Kindo'jan" (alleen, Tier 11, titel "Fabled Vanquisher of The First Hash'ey") en twee `[DNT]`-kopieën van "Let Me Solo Him: Kindo'jan". GEMETEN, *datamine*, MMO-Champion, 22 okt: https://www.mmo-champion.com/content/14636-Patch-12-1-7-PTR-Build-70493
- Raid: build 70892 veranderde vier raid-vaardigheden. *Falling Debris*, *Malice* (Doomscale Warden, twee versies) en *Virulent Spit* (Ula'tek). Allemaal Nature-schade. GEMETEN, *datamine*, MMO-Champion, 12 nov: https://www.mmo-champion.com/content/14691-Patch-12-1-7-PTR-Build-70892
  AFGELEID: dit is bijstellen van The Venomous Abyss. Niet nagekeken of MH's raid-tips deze namen noemen.
- **Talebound geeft gear, crests en Venomstones voor de gewone game.** GEMETEN, *datamine*:
  - 4 prestaties (Final Confrontation op Normal, Veteran, Heroic, Mythic) geven elk een **Venomstone Cache** = 10 Ascendant Venomstones.
  - 3 prestaties (alle Scribe-verbeteringen per klasse) geven een **Nebulous Voidcache** = 1 Nebulous Voidcore (voor de bonus-roll).
  - 8 prestaties geven een **gear-kist**: 1 Champion, 5 Heroic, 2 Mythic.
  - Ducats-prestaties geven **Mistcrest-zakjes** (Champion, Hero, Myth).
  - 3 prestaties geven Voidlight Marl (samen 7.500).
  Wowhead, 29 okt: https://www.wowhead.com/news/talebound-end-game-player-power-rewards-venomstones-bonus-rolls-experience-383659
  MMO-Champion build 70668, 29 okt (lijst met prestaties): https://www.mmo-champion.com/threads/2670882-Patch-12-1-7-PTR-Build-70668
  Itemnummers Venomstone Cache 288965 en Nebulous Voidcache 288961: GEMETEN, *gids* (taleboundwiki.com, 6 nov, tweedehands): https://taleboundwiki.com/rewards/venomstones-and-voidcores/
- **Sinds 5 nov geven de gear-kisten geen raid-gear meer.** Eerst stond er Mythic Venomous Abyss-loot in. Nu komt de loot uit de Vaults of Atal'Utek (open wereld). GEMETEN, *datamine*, Wowhead, 5 nov: https://www.wowhead.com/news/mythic-venomous-abyss-caches-replaced-by-open-world-gear-in-talebound-rewards-383746
  Spelers waren verdeeld: raid-loot zonder raid vonden sommigen oneerlijk. GEMETEN, *spelermening* (samengevat door Wowhead).
- Mistcrest is de crest van Season 2. In de PTR-tabel staan Adventurer t/m Myth Mistcrest (CurrencyTypes 3437-3446). GEMETEN, *DB2*, PTR 70892.
- [RAAKT MH] **MH kent Talebound nog nergens als bron.** grep "Talebound" in `Modules/`: 0 treffers. GEMETEN.
  - `Modules/TrackCeiling.lua:149` telt Venomstones als item 280562 in tassen en bank. Een dichte Venomstone Cache telt dan niet mee (10 stenen). AFGELEID.
  - Crest- en gear-gidsen (`DawncrestGuide.lua`, `GearLadder.lua`) noemen Talebound niet. AFGELEID: dat kan een regel worden.
- Wensen van spelers voor 12.1.7: Valeera als tank beter maken, Labyrinth-bugs oplossen. GEMETEN, *spelermening*, forum, 30 okt (in topic 2395455). Een andere speler denkt dat Blizzard dit voor 12.2 bewaart (13 nov).
- Losse PTR-meldingen (elk één speler): een curio is al een week "locked" (21 okt, https://us.forums.blizzard.com/en/wow/t/2388287); de Vault waarschuwt niet voor een unique-equipped item (20 okt, https://us.forums.blizzard.com/en/wow/t/2388047). GEMETEN, *spelermening*.
- Ter info, niet 12.1.7: Season 3 begint kort na 12.2 Eclipse (begin 2027). Nieuwe delve-nemesis Astalor Bloodsworn, en Valeera's maximum gaat omhoog. GEMETEN, *blue post*, BlizzCon-overzicht 12 sep: https://news.blizzard.com/en-gb/article/24298591/world-of-warcraft-midnight-whats-next-panel-recap

---

## 6. Events en hun schema

### Turbulent Timeways VI

- Begint op de patchdag en duurt **8 weken**. GEMETEN, *blue post* (15 okt) en *DB2* (1344 uur, zie §1).
- Mastery of Timeways in **4 willekeurige weken** geeft de prestatie en de mount *Markeet of the Infinite*. In build 70424 stond er 5; sinds 70493 staat er 4. GEMETEN, *datamine*, MMO-Champion 22 okt.
- Elke Timewalking-dungeon geeft *Knowledge of the Timeways* (5%, stapelt). Na 4 wordt het *Mastery of Timeways* (30% XP). GEMETEN, *blue post*.
- De Timewalking-quests van Archmage Aethas Sunreaver in Silvermoon geven tijdelijk een Heroic *Cache of Quel'Thalas Treasures*. GEMETEN, *blue post*.
- Let op: de Wowhead-gids zegt nog "6 weeks" en "5 weeks". Die tekst komt van de vorige ronde. GEMETEN, *gids*: https://www.wowhead.com/guide/world-events/turbulent-timeways-timewalking-rewards
- **Welke uitbreiding in welke week: niet gevonden.** Blizzard noemde geen nieuwe Timewalking-uitbreiding. De Timewalking-verkopers krijgen nieuwe decor (Classic t/m Dragonflight). GEMETEN, *datamine*, Wowhead decor-gids, 19 okt: https://www.wowhead.com/guide/midnight/decor-patch-12-1-7-sources-models
- [RAAKT MH] Klopt al. `Locales/Codex.lua:186` (`CODEX_TT6_BODY`) zegt 8 weken, 4 weken, Aethas, decor, en "welke dungeons: nog niet bekend". `enUS.lua:1068` (`MOUNTPROG_TIMEWAYS6_HOWTO`) zegt ook 8 weken. GEMETEN.

### Aqir Invasions verdwijnen

- Op de 12.1.7-PTR zijn de Aqir Invasions weg. De 4 Feats of Strength en de titel *Bane of the Swarm* zijn dan niet meer te halen. De beloningen blijven te koop, **zonder reputatie-eis, maar duurder**: alles samen 11.700 → 16.900 Voidlight Marl. Blizzard heeft het niet bevestigd. GEMETEN, *datamine/PTR-test*, Wowhead, 3 nov: https://www.wowhead.com/news/complete-aqir-invasions-before-their-removal-in-12-1-7-for-cheaper-rewards-383693
- Per item: mount *Corrupted Swarmer* en toy *Curse of the Aqir* 2.500 → 3.500; pet *Aqir Razorwing* 2.000 → 3.000. GEMETEN, *gids* (tweedehands), wowgoldshop.eu, 4 nov: https://wowgoldshop.eu/de/news/wow-midnight-aqir-invasions-end-12-1-7-ptr/
- De meeste reacties zijn negatief ("FOMO", "zonde van de ontwikkeltijd"). Een paar spelers zijn blij dat ze het nu kunnen overslaan. GEMETEN, *spelermening*, reacties onder het Wowhead-artikel en forumtopic 3 nov: https://us.forums.blizzard.com/en/wow/t/aqir-invasions-are-getting-removed/2399827
- [RAAKT MH] `Modules/MountProgress.lua:200` (rij `aqirswarmer`) meet de voortgang als reputatie (need = 5000). En `Locales/enUS.lua:1092` (`MOUNTPROG_AQIRSWARMER_HOWTO`) zegt "Reach Exalted … for 2,500 Voidlight Marl". Na 12.1.7 kloppen allebei niet meer (PTR-stand). GEMETEN (MH-code) + AFGELEID (de gevolgen).
  MH verbergt het Aqir-artikel in de Codex al vanaf 12.1.7 (`Modules/MidnightCodexData.lua:610-612`, `maxInterface = 120105`). GEMETEN.

### Winter Veil in de buurt (housing)

- Nieuw: een **Tree Defense**-activiteit bij de buurtboom, zingen met de carolers, en 12 Candy Cane-cadeaus bezorgen. Gevonden via nieuwe prestaties. GEMETEN, *datamine*, Wowhead 25 okt: https://www.wowhead.com/news/new-winter-veil-neighborhood-activities-updates-in-patch-12-1-7-383562
- Nieuwe mount *Winterrrgl's Pine-Powered Candy Cane Contraption* (van de Greench), pet *Petite Snow Buddy*, cadeau 2026 = *Throw Bow*. GEMETEN, *datamine*, Wowhead 16 okt: https://www.wowhead.com/news/new-winter-veil-mount-and-rewards-coming-with-patch-12-1-7-383451
- Build 70892: verborgen munt "Winter Veil Gift" en spell "Give Gift" (cadeau aan een buurtbewoner). GEMETEN, *datamine*, MMO-Champion 12 nov.
- De data van Winter Veil zelf: **niet nagekeken**.

### Trading Post

- Nieuwe items voor december/januari, o.a. *Goldrinn Shrine Defender*, *Winterspring Frostsaber*, *Savage Ebony Battle Turtle*. Maandnamen "January: Primeval" en "February: Tough Love". GEMETEN, *datamine*, Wowhead 13 nov: https://www.wowhead.com/news/new-trading-post-items-datamined-on-patch-12-1-7-ptr-old-steelseries-promotion-383864 en MMO-Champion 12 nov.

---

## 7. Talebound

- Een **los spel in WoW**: een PvE-actie-RPG. Drie eigen klassen: Slayer, Inquisitor, Witch. Dorp Quillgrave. Verhalen: Darkhaven, Greenthistle Wood, Greywake's Expedition, Grove of the Night Court, en een Final Confrontation. Munten: Bound Silver (warband) en Ducats. GEMETEN, *blue post* (15 en 29 okt) en *datamine* (Wowhead 24 okt).
- Demo 30 okt – 2 nov. Wat spelers zeiden (GEMETEN, *spelermening*, PTR-forum, 30 okt – 2 nov):
  - Mooie sfeer, maar slechte besturing en camera. https://us.forums.blizzard.com/en/wow/t/2397344
  - Elke actie zet je karakter vast, dus je wordt onnodig geraakt.
  - Inlogproblemen: geen realm, geen karakter maken, Talebound niet in het menu.
  - Waarom zitten beloningen bij de Trading Post?
- Opslaan: de speltekst zegt "You may exit and rejoin Tales at any time. Your progress is saved" (`WOWHACK_TALE_SAVE_TUTORIAL`, build 70493, *datamine*). Een speler meldde dat de instance toch opnieuw begon na weggaan (1 nov, *spelermening*, via taleboundwiki.com/community). Tegenstrijdig; PTR.
- XP-drankjes: Wowhead 24 okt zegt "30% voor 2 uur" (vier drankjes, naar de verhalen genoemd). Wowhead 29 okt zegt bij de puzzel-beloningen "10% voor 2 uur". Tegenstrijdig; **niet zelf gemeten**.
- [RAAKT MH] MH laadt niet in Talebound (§4). De beloningen vallen wel in de gewone game (§5, §11).

---

## 8. Timeways-dungeons

Zie §6. Er is geen lijst per week gevonden. Geen nieuwe Timewalking-uitbreiding aangekondigd. AFGELEID: het schema is pas zeker als het event live is.

---

## 9. Beroepen

- Meer Deftness uit *Bountiful Harvests* (Herbalism) en *Plentiful Ores* (Mining). Geen getallen. GEMETEN, *blue post*, 15 okt.
- Talebound geeft beroepsspullen: *Packed Alchemy Crate* en *Outfitter's Crate*. GEMETEN, *datamine*, Wowhead 29 okt.
- Nieuwe speltekst: "You cannot do that while on a Class Trial" bij crafting orders (`CRAFTING_ORDER_CLASS_TRIAL`, build 70892). GEMETEN, *datamine*.
- [RAAKT MH] Misschien. Als MH's beroepen-advies Deftness van deze twee specs noemt, kan het getal veranderen. **Niet nagekeken.**

---

## 10. Housing

- Decor draait niet meer vanzelf (fix). GEMETEN, *blue post*.
- Prijzen van decor aangepast: The War Within iets goedkoper, sommige Midnight-decor duurder. GEMETEN, *datamine*, Wowhead (via de 12.1.7-nieuwslijst, ca. 3 nov).
- Meer dan 200 nieuwe decor-items. De 4 nieuwe Lorewalking-boeken zijn leesbaar. GEMETEN, *datamine*, Wowhead decor-gids 19 okt.
- Twee nieuwe buitenkanten: *Cozy Cabin Burrow* en *Icy Cabin Burrow* (build 70668). GEMETEN, *datamine*.
- Klacht: decor die in de winkel zit in plaats van in het spel (16 okt). GEMETEN, *spelermening*.
- [RAAKT MH] Nauwelijks; MH doet weinig met housing.

---

## 11. Toetsen, actiebalken, Edit Mode

- Edit Mode: door de Personal Resource Display heen klikken. GEMETEN, *blue post*.
- Edit Mode-layouts per UI-soort (§3c). [RAAKT MH] `Modules/EditModeBackup.lua`.
- Gamepad krijgt aandacht. Nieuwe of veranderde speltekst in build 70668: `OPTIONS_TOOLTIP_GAMEPAD_POSSESS_BAR_OVERRIDE`, `OPTIONS_TOOLTIP_GAMEPAD_STANCE_BAR_OVERRIDE`, `TARGETING_MODE_DESCRIPTION` (richten met een vizier), `MAP_USE_SOFT_CURSOR_TOOLTIP`. GEMETEN, *datamine*, MMO-Champion 29 okt.
- Dominos: op de 12.1.7-PTR kun je balken laten bladeren naar de **gamepad-slots**, samen 360 actie-slots. GEMETEN, *addon-code* (§4).
  [RAAKT MH] AFGELEID: MH's balk-gereedschap (`BarInventory.lua`, `BarPreset.lua`, `KeybindAutoMap.lua`, `ApplyLayout.lua`) gaat waarschijnlijk uit van de gewone slots. **Niet nagekeken** welke slot-nummers MH aanneemt.
- Dominos 12 nummert balken nu zoals Blizzard. [RAAKT MH] Bijna niet: `Modules/LiveKeys.lua:10-11` leest Dominos nog niet. GEMETEN.
- Bartender4: de vehicle-knop van Blizzard geeft taint door Edit Mode (§4).
- Spelersbug: met "Combined Backpack" staat de volgorde van de tassen omgekeerd (tas 4 boven), ook de reagent-tas. 15 okt. https://us.forums.blizzard.com/en/wow/t/2383570 GEMETEN, *spelermening*.

---

## 12. Omnium Folio

- Twee nieuwe runes. GEMETEN, *blue post*, 15 okt:
  - *Rune of Empowerment*: je stat-rune (Critical Power, Burning Haste, Masterful Cunning, Versatile Warrior) geeft 20% meer.
  - *Rune of Critical Mass*: je kern-rune heeft kans op een extra effect (Void-bollen of een vuurstoot).
- Spell-nummers: *Rune of Empowerment* = 1324888 (1 rij). *Rune of Critical Mass* = 13 rijen (1324904 t/m 1325566). Welke van de 13 de rune zelf is: **niet gemeten**. GEMETEN, *DB2*, SpellName, PTR 70892.
- Twee nieuwe quests voor de 2 Motes. AFGELEID dat het die twee zijn:
  - Quest **99509** "Seeking Knowledge: Core Logic" (level 90, Coreway-expeditie, *Runic Archive Orb*). GEMETEN, *Wowhead-tooltip* via `gamedata`, PTR, 15 nov.
  - Prestatie **64417** "Delving into a Tale" (Talebound) geeft de quest "Seeking Knowledge: Memories and Tales". GEMETEN, *datamine*, MMO-Champion 70668 (29 okt) en taleboundwiki.com (9 nov). Questnummer: niet gevonden.
- Spelermening: 20% meer van één rune is maar ~31 stat. Wowhead-reactie 29 okt.
- [RAAKT MH] `Modules/OmniumFolioData.lua:20-70`: 5 rijen, `unlockQuests = { 96410, 96441, 96442, 96443, 96444 }`. De nieuwe runes en quests staan er niet in. GEMETEN.

---

## 13. Het verhaal "The Return to Dornogal"

- Lor'themar stuurt je met Arator naar Dornogal. Je helpt Dagran tegen skardyn in Hallowfall, zoekt Tyr op het Isle of Dorn (hij zit op het strand), haalt de disc van Archaedas in Uldaman en eindigt in de Vault of Memory. Het verhaal stopt met een cliffhanger naar 12.2. GEMETEN, *gids/PTR-playthrough*, Wowhead 30 okt: https://www.wowhead.com/news/returning-to-dornogal-patch-12-1-7-campaign-playthrough-story-spoilers-383482
- Prestatie "The Coreway Advance" (beloning nog TBD). GEMETEN, *datamine*, build 70668.
- Questnummers van de keten: **niet gevonden**.
- [RAAKT MH] `Modules/CampaignLeadIn.lua` heeft de 12.1.5-start (95533, 95187). Voor 12.1.7 staat er niets in (grep "Dornogal"/"Coreway" in dat bestand: 0). GEMETEN.

---

## 14. Lorewalking

- Li Li staat in Silvermoon, Stormwind, Orgrimmar en Dornogal. GEMETEN, *gids*, Wowhead Lorewalking-gids, bijgewerkt 10 nov: https://www.wowhead.com/guide/world-events/lorewalking-questlines-guides-rewards
  De Blizzard-notitie zegt "Stormwind, Orgrimmar, or Stormwind City". AFGELEID: een typefout van Blizzard.
- Truc uit de gids: het Lorewalking-paneel brengt je terug naar de bank waar je begon. Dat is een gratis hearthstone zonder cooldown. Dat bestond al vóór 12.1.7. GEMETEN, *gids*.
  [RAAKT MH] Misschien een idee voor de reisplanner. `Locales/Codex.lua:188` noemt de plaatsen van Li Li nog niet. GEMETEN.
- In build 70424 kreeg Argus (Antorus) in Lorewalking zwakkere schade (Sweeping Scythe ~62% lager). AFGELEID: het Titans-verhaal gaat door Antorus. GEMETEN, *datamine*, fullsendwow.com, 17 okt.

---

## 15. Overige PTR-meldingen

- De camera-fout bij sommige mounts is terug (15 okt). https://us.forums.blizzard.com/en/wow/t/2383575 GEMETEN, *spelermening*.
- Inlogproblemen tijdens de demo (30-31 okt). GEMETEN, *spelermening*.

---

## 16. Wat ik niet kon meten

- **Reddit** (r/wow, r/CompetitiveWoW, r/wowaddons, r/wowui): geblokkeerd. Zoeken gaf een weigering; een directe vraag gaf 403. Ik heb het niet omzeild. Dus: niets van Reddit in dit stuk. Dat bewijst niet dat daar niets staat.
- **Icy Veins**: alleen via zoek-uittreksels gelezen (wel met datum).
- **Wowhead**-pagina's: via Exa-kopieën gelezen, niet direct.
- **De officiële API-notities "Midnight 12.1.7 PTR Changes"**: de wiki-pagina `/notes` bestaat niet (404) en op het forum vond ik ze niet. Ik gebruikte de wiki-samenvatting.
- Of de **GUID-versluiering** al in build 70892 zit.
- **WeakAuras** en **TomTom** niet zelf bij de bron nagekeken.
- Het **weekschema** van Turbulent Timeways.

---

## 17. Alle [RAAKT MH]-punten op een rij

| # | Wat | Waar in MH | Hoe zeker |
|---|---|---|---|
| 1 | Corrupted Swarmer: na 12.1.7 geen reputatie nodig en 3.500 Marl | `Modules/MountProgress.lua:200`, `Locales/enUS.lua:1092` | PTR-stand; Wowhead 3 nov + wowgoldshop 4 nov |
| 2 | Omnium Folio: 2 nieuwe runes, quests 99509 en "Memories and Tales" | `Modules/OmniumFolioData.lua` | blue post + DB2 + datamine |
| 3 | Nieuw verhaal "Return to Dornogal" | `Modules/CampaignLeadIn.lua` | Wowhead playthrough; questnummers onbekend |
| 4 | Talebound als bron van crests, Venomstones en gear | `Modules/TrackCeiling.lua:149`, `DawncrestGuide.lua`, `GearLadder.lua` | datamine (PTR) |
| 5 | Edit Mode-layouts per UI-soort | `Modules/EditModeBackup.lua`, `Modules/BarInventory.lua:363` | wiki (1.60.1 → 12.1.7); testen |
| 6 | Gamepad-slots tot 360 | balk-gereedschap (BarInventory, BarPreset, KeybindAutoMap, ApplyLayout) | addon-code (Dominos); niet nagekeken in MH |
| 7 | GUID-versluiering | GUID-parsers (12 plekken); MH zegt "closed" | testen zodra de build het heeft |
| 8 | Trial-accounts sturen geen addon-berichten | `Modules/Comms.lua` e.a. | wiki; klein |
| 9 | Lorewalking: plaatsen van Li Li | `Locales/Codex.lua:188` | gids |
| 10 | Al goed: geen TOC-variabelen, geen "EMOTE", laadt niet in Talebound, Timeways-tekst 8 weken | `MidnightHelper.toc`, `Codex.lua:186`, `enUS.lua:1068` | GEMETEN |
