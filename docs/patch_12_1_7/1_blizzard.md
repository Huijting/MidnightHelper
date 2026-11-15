# Patch 12.1.7 "Echoes of the Worldcore": wat Blizzard zelf zegt

Speuropdracht 1 van 5. Gemaakt op 15 nov 2026 door een mh-research-helper. Alleen gelezen, niets gewijzigd.

**Labels**
- **GEMETEN** = ik heb het zelf gezien in de bron die erbij staat, met die datum.
- **AFGELEID** = mijn eigen redenering.
- [RAAKT MH] = een MH-onderdeel moet er misschien iets mee. [RAAKT MH NIET] = voor MH waarschijnlijk niet van belang.

**Bronnen die ik helemaal heb gelezen**
- B1: Blizzard-nieuws "Midnight: Echoes of the Worldcore Overview", 15 okt 2026. https://worldofwarcraft.blizzard.com/news/24310659
- B2: PTR-ontwikkelnotities (blauwe post van Linxy), 15 okt 2026, plus updates van 22 en 29 okt. Volledige tekst gelezen via de JSON van de thread. De thread is gesloten. https://us.forums.blizzard.com/en/wow/t/midnight-echoes-of-the-worldcore-ptr-development-notes/2383391 (EU-kopie: eu.forums.blizzard.com, topic 635787)
- B3: "WoW: Midnight's Talebound Demo is Now Live", 30 okt 2026. https://worldofwarcraft.blizzard.com/news/24313107/wow-midnights-talebound-demo-is-now-live
- B4: "Tales Take a Dark Turn in Midnight's Talebound", 12 sep 2026. https://worldofwarcraft.blizzard.com/en-us/news/24302576
- B5: "World of Warcraft: Midnight What's Next Panel Recap" (BlizzCon), 12 sep 2026. https://worldofwarcraft.blizzard.com/en-us/news/24298591
- B6: "Hotfixes: November 6, 2026" (live 12.1.5, loopt van 13 okt t/m 6 nov), 7 nov 2026. https://worldofwarcraft.blizzard.com/news/24307310/hotfixes-november-6-2026
- B7: WoW Weekly van 30 okt, 6 nov en 13 nov 2026 (worldofwarcraft.blizzard.com/news/24316094, /24316097, /24315205)
- B8: Blauwe post "Raid Encounter Design in Season 3" (Limestone, WoW Developer), 13 nov 2026. https://us.forums.blizzard.com/en/wow/t/2414817
- D1: Blizzards eigen speldata (DB2) via `tools/gamedata.py`: PTR **12.1.7.70892** (12 nov 2026) en live **12.1.5.70783** (4 nov 2026). Tabellen Holidays, HolidayNames, HolidayDescriptions, ItemSparse, GlobalStrings.

---

## 1. Releasedatum

- Blizzard heeft **geen** releasedatum genoemd in B1 t/m B8. GEMETEN (15 nov). Let op: dat ik niets vond, bewijst niet dat er niets is.
- Blizzard zegt wel: "Turbulent Timeways begins at the launch of Echoes of the Worldcore and lasts eight weeks." GEMETEN (B1, 15 okt).
- In de PTR-data start Turbulent Timeways op **di 1 dec 2026 07:00** (rij voor de VS) en **wo 2 dec 2026 05:00** (rij voor Europa), 1344 uur lang. GEMETEN (D1, Holidays 1425 en 1458). Op live 12.1.5 staat die datum er nog niet; daar is 30 jun 2026 de laatste. GEMETEN (D1).
- Dus: de patch komt waarschijnlijk op di 1 dec (VS) / wo 2 dec (EU). AFGELEID. PTR-data kan nog schuiven.
- Op de roadmap van BlizzCon staat 12.1.7 "tussen herfst en winter". Dat komt uit een verslag van de dia, niet van Blizzard zelf: outputlag.com, 12 sep 2026. AFGELEID / tweedehands.
- [RAAKT MH] weekplanning, dashboard, site.

## 2. Wat Blizzard in de PTR-notes zet (B2, 15 okt)

De notes hebben maar zes stukken: verhaal, Lorewalking, Omnium Folio, Housing, beroepen, UI. GEMETEN.

**Er staat NIETS in over Mythic+, delves, raid, crests, Great Vault, PvP of klassen.** GEMETEN (B2, volledige tekst). De updates van 22 en 29 okt noemen alleen "bug fixes and behind-the-scenes updates" en de Talebound-demo. GEMETEN.

### 2a. Verhaal: "The Return to Dornogal"
- Xal'atath heeft de Worldcore opengebroken. De enige weg erheen is de kapotte Coreway in Dornogal. Je helpt Arator, Brinthe, Dagran en Brann. GEMETEN (B1, B2).
- Geen beloningen genoemd. GEMETEN.
- [RAAKT MH] Codex / weekplanning (nieuwe campagne).

### 2b. Lorewalking: 4 nieuwe verhalen
- Bij **Apprentice Lorewalker Li Li Stormstout**. Vanaf **level 10**. Verhalen: Jaina, Thrall, Titans, Tyr. GEMETEN (B1, B2).
- Plaats: B1 zegt "Stormwind, Orgrimmar, or **Silvermoon City**". B2 zegt per ongeluk "Stormwind, Orgrimmar, or Stormwind City". GEMETEN. Dat het Silvermoon is: AFGELEID (B1 is de nieuwere, nette versie).
- Er is een knop "Ask a Question" in het Lorewalking-scherm onder de minimap. Je kunt stoppen met het kruisje. GEMETEN.
- Herhaalbaar. **Tijdens Lorewalking kun je geen andere quests doen of laten opschieten.** Pauzeren mag. Begin je een ander verhaal, dan is je voortgang in het eerste weg. GEMETEN.
- [RAAKT MH] Codex / uitleg (de quest-blokkade is een valkuil voor spelers).

### 2c. Omnium Folio
- Twee extra **Motes of Omnial Inquiry** te verdienen. Hoe, zegt Blizzard niet. GEMETEN.
- **Rune of Empowerment**: je Rune of Critical Power / Burning Haste / Masterful Cunning / Versatile Warrior geeft 20% meer van die stat. GEMETEN.
- **Rune of Critical Mass**: met Rune of Void-Touched Orbs als Core Rune: kans op 3 bollen (Void-schade of heling, 5 yards). Met Rune of Unleashed Fire: kans op een ontploffing (gedeelde Fire-schade of heling, 10 yards). GEMETEN.
- Lore over de Sunstrider Omnium: praat met **Magister Umbric, Grand Magister Rommath of Custodian Veldharin** in het Lycaneum op Isle of Quel'Danas. GEMETEN.
- [RAAKT MH] Omnium Folio-module.

### 2d. Housing
- Fout opgelost: decor draaide soms bij het omzetten tussen rotatie-formaten. Na één keer bewerken en opslaan wordt alles in het nieuwe formaat bewaard. GEMETEN (B2).
- Nieuwe Housing-decor bij de Timewalking-verkopers. GEMETEN (B1).
- [RAAKT MH NIET], tenzij MH housing-tips heeft.

### 2e. Beroepen
- Herbalism: meer Deftness uit de specialisatie **Bountiful Harvests**. Mining: meer Deftness uit **Plentiful Ores**. Geen getallen. GEMETEN (B2).
- [RAAKT MH] beroepen-advies (als MH Deftness-punten aanraadt).

### 2f. Interface
- **Edit Mode: optie om met de muis door de Personal Resource Display heen te klikken.** GEMETEN (B2).
  - In de PTR-data staat een nieuwe tekst: GlobalStrings 60302 `HUD_EDIT_MODE_SETTING_PERSONAL_RESOURCE_DISPLAY_ALLOW_MOUSEOVER_THROUGH` = "Allow Mouseover Through". Op live 12.1.5 bestaat die niet; de 22 andere PRD-teksten wel (dat is de controle). GEMETEN (D1).
- Tooltip: **Outfit 1** van je transmog is wat de WoW Armory-website laat zien. GEMETEN (B2).
- "End caps" en "Simple Keybinds" (uit jullie lijst) staan **niet** in Blizzards notes. GEMETEN (B2). Die komen dus uit datamining, niet van Blizzard.
- [RAAKT MH] Edit Mode-uitleg en toetsen/balken (PRD-optie). [RAAKT MH] `/mh export` / Armory: Outfit 1.

### 2g. Bekende PTR-fouten (B2)
- Mac: skyboxen in Kalimdor en Eastern Kingdoms kapot. Karakter kopiëren geeft een Lua-fout maar lukt wel. GEMETEN. [RAAKT MH NIET]

## 3. Turbulent Timeways VI (B1 + PTR-data)

- Duurt **8 weken**, start bij de patch. GEMETEN (B1).
- Mount: **Markeet of the Infinite** (skyriding) via "Master of the Turbulent Timeways VI": heb "Mastery of the Timeways" in **4 willekeurige weken**. GEMETEN (B1).
- Elke Timewalking-dungeon geeft **Knowledge of the Timeways** (5% XP, stapelt). Na **4** dungeons wordt dat **Mastery of the Timeways**: 30% XP zolang de buff loopt. GEMETEN (B1).
- De Timewalking-quest van **Archmage Aethas Sunreaver** in Silvermoon geeft tijdelijk een **Heroic-level Cache of Quel'Thalas Treasures**. GEMETEN (B1 en de event-tekst in D1, HolidayDescriptions 447).
  - In de data bestaan twee kisten: item **250116** "Rewards a piece of **Champion** equipment" en item **250117** "Rewards a piece of **Hero** equipment". GEMETEN (D1, ItemSparse live 12.1.5.70783). Dat de event-kist 250117 is: AFGELEID.
- [RAAKT MH] weekplanning (wekelijkse Hero-kist buiten de Vault), mounts.

### Schema per week (PTR-data, D1, 12.1.7.70892)

Tijd = realmtijd van die regio (VS-rij 07:00, EU-rij 05:00). GEMETEN. Dat dit de reset-tijd is: AFGELEID.

| Week | VS (di) | EU (wo) | Timewalking-dungeons | Ook die week |
|---|---|---|---|---|
| 1 | 1 dec | 2 dec | Battle for Azeroth | Battleground Bonus, Pet Battle Bonus |
| 2 | 8 dec | 9 dec | Shadowlands | |
| 3 | 15 dec | 16 dec | Dragonflight | **Delves Bonus Event** (delves + Labyrinth geven meer) |
| 4 | 22 dec | 23 dec | Classic | **Midnight Dungeon Event** (eindbaas geeft een extra item) |
| 5 | 29 dec | 30 dec | Burning Crusade | |
| 6 | 5 jan | 6 jan | Wrath of the Lich King | Arena Skirmish Bonus |
| 7 | 12 jan | 13 jan | Cataclysm | World Quest Bonus |
| 8 | 19 jan | 20 jan | Mists of Pandaria | |

- Turbulent Timeways stopt na 1344 uur: **di 26 jan 07:00 (VS) / wo 27 jan 05:00 (EU)**. GEMETEN (duur in D1); de einddatum zelf is uitgerekend. AFGELEID.
- Niet in de 8 weken: **Legion** (al op 17/18 nov, vóór de patch) en **Warlords of Draenor** (9/10 feb 2027). GEMETEN (D1).
- Welke uitbreiding bij welke rij hoort, lees ik uit de beschrijvingsteksten (HolidayDescriptions 483 BfA, 492 SL, 493 DF, 465 Classic, 222 BC, 220 Wrath, 224 Cata, 237 MoP). GEMETEN.
- 🔴 **Op live 12.1.5 staat nog een ander december-schema** (bijv. BfA op 8 dec, Shadowlands op 29 dec, Dragonflight op 19 jan). De PTR heeft dat omgegooid. GEMETEN (D1, diff live tegen PTR). Heeft MH data die het schema nu al leest of vastlegt, dan kan die tot de patch het verkeerde tonen. AFGELEID.
- [RAAKT MH] weekplanning, delves, M+-gids (Midnight Dungeon Event).

## 4. Andere events rond de patch (PTR-data, D1)

Alles GEMETEN in Holidays 12.1.7.70892, tenzij anders gezegd.
- **WoW's 22nd Anniversary**: di 17 nov 10:00, 504 uur (tot ongeveer 8 dec). Uitrekenen einddatum: AFGELEID.
- **Pilgrim's Bounty**: zo 22 nov 10:00, 167 uur.
- **World Quest Bonus Event**: 24/25 nov.
- **Darkmoon Faire**: rij start vr 4 dec 00:00 met 48 uur en dan 168 uur. Dat de kermis open is van zo 6 t/m zo 13 dec: AFGELEID. Volgende: 1 jan 2027.
- **Wanderer's Festival**: 7 dec (elk jaar, 24 uur).
- **Feast of Winter Veil**: 15 dec 10:00 (elk jaar), 432 uur, dus tot ongeveer 2 jan 10:00. De einddatum is uitgerekend: AFGELEID. Op de BlizzCon-roadmap staat "Winter Veil updates" bij 12.1.7 (outputlag.com, 12 sep, tweedehands). Blizzard gaf er zelf geen details over. GEMETEN (B1, B2).
- **Nieuwe naamloze event-rij 1895** op de PTR: start 1 dec 2026 00:00, 2904 uur (ongeveer tot 1 apr 2027). Niet op live. GEMETEN. Waarvoor hij is, weet ik niet. AFGELEID: misschien zet hij 12.1.7-inhoud aan.
- [RAAKT MH] weekplanning / dashboard.

## 5. Talebound: wat Blizzard zelf zegt

- Nieuwe PvE "action RPG"-spelsoort. Solo of met vrienden. Komt met 12.1.7. GEMETEN (B1, B4, B5).
- **Start met 4 verhalen**: Darkhaven, Greenthistle Wood, Greywake's Expedition en **Grove of the Night Court** (Tilywth, The Fairy Queen; Maernok, The Nightmare King). De demo had alleen de eerste drie. GEMETEN (B4, B3).
- **3 klassen: Slayer, Inquisitor, Witch.** Iedereen kan dubbel springen, ontwijken en blokken. GEMETEN (B3, B4). (Jullie lijst noemt klasse "Traveler"; die naam gebruikt Blizzard in deze teksten niet. GEMETEN.)
- Moeilijkheden in de demo: Normal, Veteran, Heroic. GEMETEN (B3).
- Dorp **Quillgrave**: Arcanist (drankjes), Scribe (talenten), Outfitter (start-health, schade, energie, focus), Antiquarian (passieven). GEMETEN (B4).
- Munten: **Bound Silver** (Warband-gebonden; uit quests, achievements en voortgang) en **Ducats** (omzetten naar middelen voor Talebound). GEMETEN (B1).
- Winkel: in het karakterkeuze-scherm, in het Game Menu, of bij **Nib** in Quillgrave. GEMETEN (B1).
- Beloningen volgens Blizzard: **cosmetisch**. Genoemd: Ensemble: Witch Hunter's Shadow Attire, Quillgrave Storyteller's Lectern, Quillgrave Talebound Shadowtome, **Shadowbound Storybook**-mount. GEMETEN (B1, B4).
- Demo op de PTR: 30 okt 10:00 PDT tot 2 nov 10:00 PDT (B2). Het nieuwsartikel zegt "October 30–November 1" (B3). GEMETEN; de twee bronnen verschillen.
- ⚠️ Blizzard noemt **geen** gear, crests of Vault-beloningen voor Talebound. GEMETEN (B1, B3, B4). Wat jullie al weten over S2-beloningen via de Traveling Raven komt uit datamining (zie 8).
- [RAAKT MH] Codex (nieuwe spelsoort uitleggen), weekplanning.

## 6. Live hotfixes vlak vóór de patch (12.1.5, B6)

Deze horen niet bij 12.1.7, maar ze veranderen wat MH nu zegt. Alles GEMETEN in B6.
- **20 okt: Mistcrests zijn uncapped.** Conquest en Bloody Tokens ook. "Spoils of War": +50% Conquest, +40% Honor. [RAAKT MH] crests / weekplanning.
- **20 okt: Ascendant Venomstones** te krijgen na quest "Ascending with Venomstones". [RAAKT MH]
- **27 okt: Labyrinth-scenario's die geen Great Vault-tegoed gaven, zijn gerepareerd.** [RAAKT MH] Great Vault.
- 14 okt: Dundun zit weer in Bountiful delves. 16 okt: Valeera's Stagger werkte niet met een healer erbij (gerepareerd); Scar of Kathra'natir deed te veel schade aan Valeera (gerepareerd). [RAAKT MH] delves + Valeera.
- 13 okt: veel M+-dungeons zwakker gemaakt (Altar of Fangs, Murder Row, Ruby Life Pools, Temple of Sethraliss, The Blinding Vale, Voidscar Arena). [RAAKT MH] M+-gids.
- 5 en 6 nov: The Venomous Abyss flink zwakker (Vashnik, Entombed Sentinels, Twin Fangs, The Coiled Altar, Ula'tek). [RAAKT MH] raid-tips.
- 27 okt: klassen-tuning (Feral, Resto Druid, MM Hunter, Fire Mage, Sub Rogue, Affliction en Destruction Warlock) en PvP-tuning. [RAAKT MH] alleen als MH getallen noemt.
- Nieuwere retail-hotfixes dan 6 nov vond ik niet; de nieuwslijst van 15 nov toont alleen Forever-hotfixes. GEMETEN.

## 7. Wat Blizzard zegt over later (niet 12.1.7)

- Season 3 begint "kort na" de lancering van 12.2 Eclipse. GEMETEN (B5). Dus geen nieuw seizoen met 12.1.7. AFGELEID (sluit aan bij jullie lijst).
- 13 nov: raid-ontwerpers willen in Season 3 minder "één fout = iedereen dood". Ze nodigen uit om te testen "once Season 3 launches on the PTR". Die PTR is er dus nog niet. GEMETEN (B8).
- Season 3 (uit B5): M+-pool Thraegar's Stand, The Underrot, Iron Docks, Sanguine Depths, The Stonecore, Uldaman: Legacy of Tyr, Magisters' Terrace, Maisara Cavern. Nieuwe top-5%-beloning; top 1% en 5% worden per specialisatie berekend. Delves: Valeera krijgt een hoger level-plafond en nieuwe Curios; nieuwe Nemesis **Astalor Bloodsworn**. Housing: Showcase, mannequins, kopiëren/plakken. Calibration Chamber. Transmog over pantsertypes heen vanaf 12.2.5. GEMETEN (B5). [RAAKT MH] later, niet voor 1 dec.

## 8. Niet van Blizzard zelf (alleen ter waarschuwing)

Dit is datamining door MMO-Champion, geen Blizzard-tekst. Andere helpers zoeken dit verder uit.
- Build 70668 (29 okt): Talebound-achievements met Traveling Raven-beloningen, zoals Cache of Champion/Heroic/Mythic Treasures, Venomstone Cache, Nebulous Voidcache en Champion/Hero/Myth Mistcrest Pouches. Er is ook een "Mythic"-moeilijkheid (Blizzard noemt die niet). Achievement "The Coreway Advance". https://www.mmo-champion.com/content/14657-Patch-12-1-7-PTR-Build-70668
- Klassen in build 70668: bijna alles is gelijk aan de live hotfix van 27 okt (Verdancy, Regrowth, Improved Swiftmend, Trick Shots, Explosive Shot, Volley, Rain of Fire). Nieuw lijkt alleen: "Salvo Volley now also applies Explosive Shot to up to 2 targets". Mijn vergelijking van de twee lijsten: AFGELEID.
- Build 70892 (12 nov): Trading Post-mounts Goldrinn Shrine Defender en Winterspring Frostsaber, een "Give Gift"-spell voor de buurt met Winter Veil Gift. https://www.mmo-champion.com/content/14691-Patch-12-1-7-PTR-Build-70892

## Wat ik niet kon meten
- Een officiële releasedatum. Niet gevonden.
- Of de PTR-eventdata nog verandert vóór de patch.
- Waarvoor event-rij 1895 is.
- Hoe je de twee nieuwe Motes of Omnial Inquiry krijgt. Blizzard zegt het niet.
- Het questnummer van de Aethas Sunreaver-Timewalking-quest. Niet opgezocht.
