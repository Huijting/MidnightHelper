# Warlock class-quests in WoW Forever (1.60.1.70938) - feiten voor `Modules/ForeverClassQuests.lua`

Onderzoek 17 nov 2026 (mh-research, alleen lezen). Vorm: dezelfde velden als de druid-ketens (`key`, `spell` of
`nameKey`, `level`, `faction`, `races`, per quest `q`, `alt`, `from`/`to`, `objs`). Niets hiervan is in het spel
gezien: quest-ids blijven onbewezen tot de client ze afvinkt (`/mh classquest`).

Elke bewering heeft een label:
- **G** = GEMETEN, met bron en regel/URL.
- **A** = AFGELEID, met de reden.

## Bronnen (alle na 18 aug 2026)

| Code | Bron | Datum |
|---|---|---|
| ZA | Zygor Forever `Guides-Forever\Leveling\ZygorLevelingAllianceCLASSIC.lua`, "Warlock Class Quests" r. 23743-24407 | gelezen 17 nov |
| ZH | Zygor Forever `...ZygorLevelingHordeCLASSIC.lua`, "Warlock Class Quests" vanaf r. 24843 (gelezen t/m r. 25452) | gelezen 17 nov |
| ZC | Zygor Forever `...ZygorLevelingCommonCLASSIC.lua` (alleen "Skyborne Starter (1-13)", r. 5): **geen** warlock-stap. Positieve controle: zelfde bestand heeft 30 treffers op Druid/Skyborne; r. 92-97 Skyborne-klasse-quests voor Warrior, Hunter, Rogue, Shaman, Druid, Mage | 17 nov |
| SPC | Spoken `Spoken_Quests\Data\Compendium.lua` (gemaakt uit Forever 1.60.1.70450 + Era-tabellen + Efficient Games): `prev`, `ender`, `races` | 17 nov |
| SPQ | Spoken `SpokenQuestsAudioShared\generated\quest_id_lookups.lua` (titel -> gever -> quest-id, en quest-teksten) | 17 nov |
| DB2 | `run gamedata db2 ... --game forever` = wago DB2 build 1.60.1.70938 | 17 nov |
| WH | `run gamedata npc/quest/item ... --game forever [--locale xx]` = Wowhead Forever tooltip-JSON | 17 nov |
| QW | questing.wiki/wow-forever/quests/<id>/ (via Exa). Per pagina staat de onderliggende bron: "Wowhead Forever record 1.60.1, checked 2026-09-30/10-01", of "Completao corrected Questie Forever export, 2026-10-04", of "AHledger player observations 2026-10-04" | opgehaald 17 nov |
| PS | polestar.guide (open-source Forever-gidsaddon, GPL-3.0), warlock-gidsen "Last changed 2026-11-02, Polestar 0.3.0"; incubus-horde 2026-11-10 (0.3.7) | opgehaald 17 nov |
| IV | icy-veins.com/wow-forever/warlock-class-quests, "Last Updated: Nov 4, 2026" | opgehaald 17 nov |
| HN | `HandyNotes_ClassTrainers\Data.lua` (Forever 1.60.1.70532), sleutel XXXXYYYY = x.xx,y.yy | 17 nov |
| FDB | foreverdb.net/quest/1689-the-binding ("seen in Forever", 2-4 spelers met companion-addon) | opgehaald 17 nov |
| DR | dailyrespawn.com Felsteed-artikel, "Last verified 2026-11-13", gepubliceerd 14 nov 2026 | opgehaald 17 nov |

Coordinatenregel (Rob gemeten > HandyNotes > Zygor > gids): voor trainers HN, anders Zygor, anders WH-spawn of QW.

## 0. Wie kan warlock zijn, welke spells

**Ras x klasse (G: DB2 CharBaseInfo, ClassID 9 = Warlock):** RaceID 1 (rij 5), 2 (rij 12), 5 (rij 31), 7 (rij 52),
8 (rij 920, nieuw in Forever). Skyborne (RaceID 95/96) heeft **geen** ClassID-9-rij (95: klassen 1,3,4,8,11; 96:
1,3,4,7,11). Positieve controle: dezelfde tabel geeft 56 rijen, o.a. 95/96 voor Druid (11).
-> **Geen Skyborne-warlock, dus geen Skyborne-ketens** (A, sluit aan bij ZC r. 92-97 en PS "Who can be a Warlock").

**raceFile voor `races = {}` (G: DB2 ChrRaces ClientFileString):** 1 Human, 2 Orc, 5 Scourge, 7 Gnome, 8 Troll.
PlayableRaceBit 0/1/4/6/7.

**Spells (G: DB2 SpellName + SpellLevels, 1.60.1.70938):**

| Spell | id | SpellLevel | BaseLevel | Leer-spell ("Teach ...", G: SpellName) |
|---|---|---|---|---|
| Summon Imp | 688 | 1 | 1 | 7763 Teach Summon Imp |
| Summon Voidwalker | 697 | 10 | 10 | 11520 |
| Summon Succubus | 712 | 20 | 20 | 11519 |
| Summon Incubus | 713 | 20 | 20 | 366815 Teach Summon Incubus |
| Summon Felhunter | 691 | 30 | 30 | 1373 |
| Summon Felsteed | 5784 | 40 | 0 | 5785 |
| Inferno | 1122 | 50 | 50 (MaxLevel 60) | - |
| Ritual of Doom | 18540 | 60 | 60 | - |
| Summon Dreadsteed | 23161 | 60 | 0 | 23160 |

Welke quest welke spell leert:
- 1598 en 1485 -> Summon Imp **688** (G: QW 1598 en 1485, "You will learn: Summon Imp, Spell #688", Wowhead Forever record 30 sep).
- 1504 -> **697** (G: QW 1504). 1689 en 1471 -> voidwalker (G: tooltipteksten "summon and subdue a voidwalker", WH; SPQ r. 8110 tekst 1471 "I will impart to you the spell used for voidwalker"). Dat 1689/1471 ook 697 leren = A.
- 1739, 1513, 1474 -> **712** + Small Soul Pouch **22243** (G: QW 1739/1513/1474).
- 65603, 65604, 65597 -> Summon Incubus (G: PS "Gakin the Darkbinder: Summon Incubus", IV; SPQ r. 8112 tekst 65597 "I will teach you the spell to summon the incubus"; Small Soul Pouch G: QW 65603/65604, QW 65597 AHledger). **Spell-id 713 = A** (enige speler-incubus-spell in DB2).
- 1795 -> **691** + Box of Souls **22244** (G: QW 1795).
- 4490 -> Felsteed (G: WH-tooltip 4490 "to learn the ability to summon a Felsteed"). Id 5784 = A.
- 7631 -> Dreadsteed (G: PS "Dreadsteed Spirit: Summon Dreadsteed"). Id 23161 = A.
- **Inferno (1122) en Ritual of Doom (18540): geen quest gevonden.** Niet in ZA/ZH "Warlock Class Quests", niet in de
  PS-lijst van 18 warlock-class-quests, niet in de SPC-lijst `classes = 256` (positieve controle: alle drie hebben
  wel Felsteed). -> trainer-spells, geen keten (A). De Kroshius-keten gaat over een infernal maar geeft een item.

---

## 1. Imp (level 1) - `spell = 688`

Forever: de start-quest leert de Imp (G: QW 1598/1485 "You will learn: Summon Imp"; IV; PS). Of een nieuwe
warlock de Imp echt nog niet kent = niet in de client gemeten. Doel-index en item-ids: G (WH-tooltip "Requirements",
ZA/ZH `q <id>/1`, DB2 ItemSparse).

| Keten | faction / races | q | gever -> inleveraar | objs |
|---|---|---|---|---|
| imp Human | Alliance / Human | 1598 The Stolen Tome | Drusilla La Salle 459 -> Drusilla | idx 1 Powers of the Void 6785, Stolen Books (object 83763) Elwynn 56.71,43.95 (ZA 23751-23752) |
| imp Gnome | Alliance / Gnome | 1599 Beginnings | Alamar Grimm 460 -> Alamar | idx 1 3x Feather Charm 6753 van Frostmane Novice 946, Dun Morogh 28.73,82.58 (ZA 23766-23769; grotingang 26.80,79.86) |
| imp Orc/Troll | Horde / Orc, Troll | 1485 Vile Familiars | Ruzan 5765 -> Ruzan | idx 1 6x Vile Familiar Head 6487 van Vile Familiar 3101, Durotar 45.34,56.36 (ZH 24851-24853) |
| imp Undead | Horde / Scourge | 1470 Piercing the Veil | Venya Marthand 5667 -> Venya | idx 1 3x Rattlecage Skull 6281 van Rattlecage Skeleton 1890, Tirisfal 32.73,60.10 (ZH 24870-24871) |

- Races: 1598 QW-record "Human, Gnome"; 1485 QW-record "Orc, Undead, Troll" (G). SPC 1470/1485 `races = 18`
  (Orc+Undead) (G) - Troll ontbreekt daar; PS/IV: Orc en Troll doen 1485 (G, gidsen). Indeling per startgebied = A.
- Optionele brief vooraf (geen spell): 3105 Tainted Letter -> Drusilla (SPC r. 1820, races 1), 3115 Tainted
  Memorandum -> Alamar (SPC r. 1829, races 64), 3090 Tainted Parchment -> Nartok 3156 (SPC r. 1805, races 2),
  **98575 Tainted Tablet -> Nartok (nieuw in Forever, alleen Troll)** (G: SPC r. 4805 `races = 128`; WH-tooltip 98575;
  ZH r. 3049/3069), 3099 Tainted Scroll -> Maximillion 2126 (SPC r. 1814). De brief-ontvanger is de trainer, niet de
  imp-gever (Nartok vs Ruzan, Maximillion vs Venya) (G: SPC enders). Voorstel: weglaten, zoals bij de druid (A).
- 1499 Vile Familiars (Ruzan -> Zureetha Fargaze 3145) geeft het startwapen (PS "Primitive Hand Blade / Walking
  Stick"), geen spell (G: WH-tooltip 1499 "Speak with Zureetha Fargaze"; SPC r. 1319 prev 1485, ender 3145).

## 2. Voidwalker (level 10) - `spell = 697`

| Keten | q | titel | van | naar | objs |
|---|---|---|---|---|---|
| A Human | 1685 | Gakin's Summons | Remen Marcot 6121 (Goldshire, kelder Lion's Pride Inn) | Gakin 6122 | - |
| A Gnome | 1715 | The Slaughtered Lamb | Lago Blackwrench 6120 (Ironforge) | Gakin | - |
| A beide | 1688 | Surena Caledon | Gakin | Gakin | idx 1 Surena's Choker 6810: kill Surena Caledon 881, Elwynn 71.02,80.78 (ZA 23827-23832) |
| A beide | 1689 | The Binding | Gakin | Gakin | idx 1 Summoned Voidwalker 5676 doden, gebruik Bloodstone Choker 6928 op de cirkel, Stormwind 39.11,84.37 (ZA 23850-23853) |
| H Orc/Troll | 1506 | Gan'rul's Summons | Ophek 3294 (Razor Hill) | Gan'rul Bloodeye 5875 | - |
| H Orc/Troll | 1501 | Creature of the Void | Gan'rul | Gan'rul | idx 1 Tablet of Verga 6535 uit Burning Blade Stash (58595), Skull Rock, Durotar 51.62,9.74 (ZH 24941-24943; grot 55.02,9.79) |
| H Orc/Troll | 1504 | The Binding | Gan'rul | Gan'rul | idx 1 Summoned Voidwalker doden, Glyphs of Summoning 7464, Orgrimmar 49.44,50.02 (ZH 24959-24962) |
| H Undead | 1478 | Halgar's Summons | Ageron Kargal 5724 (Brill, boven in de herberg) | Carendin Halgar 5675 | - |
| H Undead | 1473 | Creature of the Void | Carendin | Carendin | idx 1 Egalin's Grimoire 6285 uit Perrine's Chest, Tirisfal 51.06,67.57 (ZH 24896-24898) |
| H Undead | 1471 | The Binding | Carendin | Carendin | idx 1 Summoned Voidwalker doden, Runes of Summoning 6284, Undercity 86.62,27.10 (ZH 24908-24910) |

- Volgorde en gevers/enders: G (ZA 23746-23924, ZH 24880-24968; SPC r. 1296/1298/1303/1320/1323/1325/1398/1401/1402/1424;
  SPQ "Gakin's Summons" Lago=1717 / Remen=1685 r. 2441-2443).
- Races in het Wowhead-record (G: QW): 1506 en 1504 "Orc, Undead, Troll"; 1478 "Orc, Undead"; 1688 "Human, Gnome".
  PS: "Halgar's Summons (Undercity) (Orc, Troll, Undead only)" en "you can do only one of the two" (G, gids).
  Voorstel: Orgrimmar-keten `races = { Orc, Troll }`, Undercity-keten `races = { Scourge }`; de keten stopt toch zodra
  697 bekend is (A).
- 1688 heeft geen voorganger nodig (G: QW 1688 "Before you start: unavailable while The Binding active"; PS "If Lago
  does not offer it, go to Gakin anyway"). Dus `q = 1685` / `q = 1715` als eerste stap per ras (A).

## 3. Succubus (level 20) - `spell = 712` - en Incubus (level 20, nieuw t.o.v. Zygor) - `spell = 713`

Zygor heeft alleen de oude succubus-ketens van Stormwind en Orgrimmar. **Niet in Zygor (G: grep ZA/ZH op `##1472`,
`##1476`, `##1474`, `##65593`, `##65597`, `##65601`, `##65602`, `##65603`, `##65604`, `##65610` = 0 treffers; controle in
dezelfde grep: `##8420` wel gevonden):** de Undercity-succubus en alle incubus-ketens.

Incubus bestaat in Forever (G: WH-tooltips 65593, 65597, 65601, 65602, 65603, 65604, 65610; QW 65597 "AHledger player
quest observations", dus door spelers gezien; DB2 SpellName 713 en 366815; DB2 ItemSparse 190179/190180/190181/190186/
190187; PS "Forever's incubus"). Een speler kan **beide** doen (G: PS "Takar offers both branches: take both";
"Cazul offers both of Orgrimmar's branches").

### 3a. Alliance (Human en Gnome)

| Keten | q | titel | van | naar | objs |
|---|---|---|---|---|---|
| (optioneel, Gnome) | 1717 | Gakin's Summons | Lago Blackwrench 6120 | Gakin | - |
| succ + inc | 1716 | Devourer of Souls | Gakin 6122 | Takar the Seer 6244 (Barrens) | - |
| succubus | 1738 | Heartswood | Takar | Gakin | idx 1 Heartswood 6912 (object 93192), Ashenvale 31.49,31.45 (ZA 23965-23966) |
| succubus | 1739 | The Binding | Gakin | Gakin | idx 1 Summoned Succubus 5677, Heartswood Core 6913, Stormwind 39.11,84.37 (ZA 23980-23983) |
| incubus | 65602 | What Is Love? | Takar | Gakin | idx 1 Wooden Figurine 190186, Ashenvale 26.6,22.0 (QW/Questie) |
| incubus | 65603 | The Binding | Gakin | Gakin | idx 1 Summoned Incubus 185335 (QW "NPC #185335"), Wooden Figurine op dezelfde cirkel (PS) |

- 1716 gever Gakin, ender Takar (G: SPQ r. 2362 + r. 8139; QW 1716). 1717 = alleen een wijzer, 1716 heeft hem niet
  nodig (G: QW 1716 "Before you start" noemt alleen Heartswood; QW 1717 "unavailable while 1716 active or completed").
  PS: 1717 "(Gnome only)". Voorstel: Alliance-ketens beginnen bij 1716 (Gakin); 1717 hoogstens als eerste stap in
  een Gnome-variant (A).
- 1738: gever Takar, ender Gakin (G: SPC r. 1429 ender 6122, prev 1716; QW 1738).
- 65602: gever Takar, ender Gakin (G: QW "Pick up Takar the Seer 49.3,57.1", "Turn in Gakin"; PS; IV).
  Tegenstrijdig: SPC r. 4257 heeft geen `ender`, wat volgens de SPC-kop betekent "inleveraar = gever" (G). Gekozen: QW/PS/IV (A).
- Wooden Figurine: torch-truc (Unlit Torch buiten, aansteken, figuur boven in het huis) (G: PS stap 5).
- Races-record 1716/1717/1738/1739 "Human, Gnome" (G: QW).

### 3b. Horde Orgrimmar (Orc, Troll; Undead mag ook)

| Keten | q | titel | van | naar | objs |
|---|---|---|---|---|---|
| succ + inc | 1507 | Devourer of Souls | Gan'rul Bloodeye 5875 | Cazul 5909 | - |
| succubus | 1508 | Blind Cazul | Cazul | Zankaja 5910 | - |
| succubus | 1509 | News of Dogran | Zankaja | Gazrog 3464 (Crossroads) | - |
| succubus | 1510 | News of Dogran | Gazrog | Ken'zigla 4197 (Malaka'jin, Stonetalon) | - |
| succubus | 1511 | Ken'zigla's Draught | Ken'zigla | Grunt Logmar 5911 (Camp Taurajo) | - (item meegegeven) |
| succubus | 1515 | Dogran's Captivity | Logmar | Grunt Dogran 5908 | - |
| succubus | 1512 | Love's Gift | Dogran | Gan'rul | - (Dirt-caked Pendant meegegeven) |
| succubus | 1513 | The Binding | Gan'rul | Gan'rul | idx 1 Summoned Succubus, Dogran's Pendant 6626, Orgrimmar 49.45,50.03 (ZH 25029-25032) |
| incubus | 65601 | Love Hurts | Cazul | Magar 3363 (Orgrimmar) | - |
| incubus | 65610 | Wish You Were Here | Magar | Gan'rul | idx 1 Withered Scarf 190187, Fallen Sky Lake, Ashenvale 64.0,79.0 (QW/Questie); drop van Shadethicket-mobs, ca. 1 op 20 (PS, G gids) |
| incubus | 65604 | The Binding | Gan'rul | Gan'rul | idx 1 Summoned Incubus, Withered Scarf, cirkel in Neeru's tent (PS) |

- Succubus-volgorde: G (ZH 24972-25037; SPC r. 1326-1334 prev/ender; SPQ). Incubus: G (WH-tooltips; QW 65601 "Pick up
  Cazul ... Turn in Magar 63.7,49.9", 65610 "Pick up Magar ... Turn in Gan'rul", 65604 "Gan'rul 48.3,45.3"; SPC r. 4256/4259).
- 1507 en 1472 sluiten elkaar uit (G: QW 1507 "Unavailable if 1472 is active or completed", QW 1472 omgekeerd).
- Races-record 1507-1513 "Orc, Undead" - **zonder Troll** (G: QW 1507, 1513, series 1508). Gidsen zeggen dat trollen
  deze route lopen (G: IV "Orc and Troll", PS, urgametips 21 okt). Niet in de client gemeten -> open punt.

### 3c. Horde Undercity (Undead; Orc mag ook)

| Keten | q | titel | van | naar | objs |
|---|---|---|---|---|---|
| succ + inc | 1472 | Devourer of Souls | Carendin Halgar 5675 | Godrick Farsan 5693 | - |
| succubus | 1476 | Hearts of the Pure | Godrick | Carendin | idx 1 Dalin's Heart 6312 (Dalin Forgewright 5682, Silverpine); idx 2 Corma's Heart 6313 (Corma Villard 5683, Wetlands) |
| succubus | 1474 | The Binding | Carendin | Carendin | idx 1 Summoned Succubus, Pure Hearts 6286, cirkel onder Carendin |
| incubus | 65593 | Hearts of the Lovers | Godrick | Carendin | idx 1 Avelina's Heart 190179 (Silverpine 63.5,65.3); idx 2 Isaac's Heart 190180 (Barrens/Ratchet 61.8,38.5) |
| incubus | 65597 | The Binding | Carendin | Carendin | idx 1 Summoned Incubus, Lovers' Hearts 190181 |

- G: SPQ r. 2360 (Carendin -> 1472), r. 8137 (Godrick ender 1472), r. 2344/2345 (1474, 65597 bij Carendin);
  SPC r. 1297/1299/1301; QW 1472, 1476, 65593; WH-tooltips (volgorde van de harten = objective-volgorde; gelijk aan
  client-index = A, net als bij de druid).
- Plekken: Dalin WH-spawns Silverpine 43.4-45.6, 81.4-86.8 (24 spawns), QW/EverythingQuests-pin 47.6,85.65; Corma WH
  Wetlands 49.4-50.6, 12.2-13.5, pin 49.93,12.55; Summoned Succubus Undercity 86.4,27.2 (QW), Summoned Incubus
  Undercity 86.0-86.6, 26.4-27.5 (WH 185335). Avelina/Isaac: alleen de Questie-pins hierboven (hun npc-id's niet gevonden).
- Races-record 1472/1476/1474 "Orc, Undead" (G: QW). PS: dit is "the Undercity's version, for warlocks who took
  Carendin Halgar's Devourer of Souls instead of Gan'rul's".

## 4. Felhunter (level 30) - `spell = 691`

| Keten | q | titel | van | naar | objs |
|---|---|---|---|---|---|
| A | 1798 | Seeking Strahad | Gakin 6122 | Strahad Farsan 6251 (Ratchet) | - |
| A | 1758 | Tome of the Cabal | Strahad | Krom Stoutarm 6294 (Ironforge) | - |
| A | 1802 | Tome of the Cabal | Krom | Krom | idx 1 Moldy Tome 6931 (Hillsbrad 27.78,72.78); idx 2 Tattered Manuscript 6997 (Damaged Chest 92423, Thousand Needles 43.43,32.69; grot 44.09,37.29) |
| A | 1804 | Tome of the Cabal | Krom | Strahad | idx 1 3x Rod of Channeling 6930 (Dragonmaw Bonewarder/Shadowwarder, Wetlands 45.09,43.08; ook 49.48,48.47) |
| H Orc/Troll | 2996 | Seeking Strahad | Gan'rul 5875 | Strahad | - |
| H Undead | 3001 | Seeking Strahad | Carendin 5675 | Strahad | - |
| H | 1801 | Tome of the Cabal | Strahad | Jorah Annison 6293 (Undercity) | - |
| H | 1803 | Tome of the Cabal | Jorah | Jorah | idx 1 Moldy Tome, idx 2 Tattered Manuscript (zelfde plekken) |
| H | 1805 | Tome of the Cabal | Jorah | Strahad | idx 1 3x Rod of Channeling (zelfde plek) |
| A + H | **1795** | The Binding | Strahad | Strahad | idx 1 Summoned Felhunter 6268, Tome of the Cabal 6999, Barrens 62.60,35.28 (ZA 24044-24046) |

- G: ZA 23994-24051, ZH 25041-25094; SPC r. 1432/1450/1452/1455-1459/1785/1790; SPQ r. 2368-2371 (Seeking Strahad:
  Carendin=3001, Gan'rul=2996, Gakin=1798), r. 2506-2509 en 8401-8409; WH-tooltips (volgorde Moldy Tome, Tattered
  Manuscript; ZA `q 1802/1`, `/2`).
- **Zygor-fouten (G):** ZA r. 24041/24046/24050 en ZH r. 25084/25089/25093 noemen de felhunter-binding `##1471`.
  1471 is de Undercity-voidwalker (WH-tooltip 1471 "summon and subdue a voidwalker ... Carendin Halgar"; SPC r. 1296
  prev 1473). De felhunter-binding is **1795** (WH-tooltip 1795 "summon and subdue a felhunter ... Strahad Farsan";
  SPC r. 1450 prev 1805; QW 1795 "Faction: Both factions", "Complete any one: 1804, 1805"; Wowhead Forever
  quest=1795-pagina (via Exa) "Series: 1. Seeking Strahad ... 5. The Binding").
  ZH r. 25054 levert `##1758` in bij Jorah; dat moet **1801** zijn (G: SPC r. 1455 1801 ender 6293, prev 2996).
- 2996 en 3001 sluiten elkaar uit (G: QW 2996/3001). Voorstel: per ras een keten met de ander als `alt` (A).
- Races-record 1798 "Human, Gnome", 2996/3001 "Orc, Undead" (zonder Troll) (G: QW). PS: Orgrimmar-start "(Orc, Troll only)".
- PS noemt voor Gnomes "Seeking Strahad (Ironforge) from Lago Blackwrench" (G, gids). SPQ en QW kennen voor 1798 alleen
  Gakin (G). Quest-id van een Lago-variant niet gevonden -> open punt.
- Tattered Manuscript: PS zegt "Where: 49, 96.8 on the The Barrens map" (G) tegenover ZA/ZH Thousand Needles
  43.43,32.69 (G). Niet opgelost; Zygor gekozen (coordinatenregel).

## 5. Felsteed (level 40) - `spell = 5784`

| Keten | q | van | naar | objs |
|---|---|---|---|---|
| A Human | 4488 Summon Felsteed | Demisette Cloyce 461 (Stormwind) | Strahad | - |
| A Gnome | 4487 Summon Felsteed | Briarthorn 5172 (Ironforge) | Strahad | - |
| H Orc/Troll | 3631 Summon Felsteed | Zevrost 3326 (Orgrimmar) | Strahad | - |
| H Undead | 4489 Summon Felsteed | Kaal Soulreaper 4563 (Undercity) | Strahad | - |
| alle | 4490 Summon Felsteed | Strahad | Strahad | - (alleen praten) |

- Gever per quest: G (SPQ r. 287-292: Demisette=4488, Zevrost=3631, Kaal=4489, Briarthorn=4487, Strahad=4490;
  QW 4487/4488/4489/3631 "Pick up ..."). De vier starters sluiten elkaar uit (G: QW "Unavailable if 3631/4488/4489 ...").
- **Zygor-fout (G):** ZA r. 24058-24059 laat Demisette "4487 of 4488" geven; Demisette = 4488, Briarthorn = 4487.
  ZA/ZH kennen 4487 (Ironforge) en 4489 (Undercity) niet als starter.
- 4490: WH-tooltip "Speak to Strahad Farsan in Ratchet to learn the ability to summon a Felsteed", geen Requirements (G).
- Live in Forever: DR (14 nov): "the quest is live and works"; hotfix 9 nov: de quest geeft nu ook Apprentice Riding,
  wie eerder klaar was krijgt die bij de eerste keer oproepen (G, gids). In Forever staat de Felsteed in de
  Mounts-verzameling (G: DR) -> of `IsSpellKnown(5784)` als "klaar" werkt = open punt.
- PS: "No quest offered? Finish the felhunter chain first: players report the mount comes after it" (G, gids; niet
  in de quest-records gezien).

## 6. Dreadsteed (level 60) - `spell = 23161`

| q | titel | van | naar | objs |
|---|---|---|---|---|
| 7562 | Mor'zul Bloodbringer | Spackle Thornberry 5520 (SW) / Jubahl Corpseseeker 6382 (IF) / Kurgul 5815 (Org) / Martha Strain 5753 (UC) | Mor'zul Bloodbringer 14436 | - |
| 7563 | Rage of Blood | Mor'zul | Mor'zul | idx 1 30x Raging Beast's Blood 18590, uilbeesten Winterspring 63.65,16.33 (grot 65.04,18.78) |
| 7564 | Wildeyes | Mor'zul | Gorzeeki Wildeyes 14437 | - (Case of Blood meegegeven) |
| 7626 | Bell of Dethmoora | Mor'zul | Gorzeeki | idx 1 10x Elixir of Shadow Power 9264 (Alchemie/AH) |
| 7627 | Wheel of the Black March | Mor'zul | Gorzeeki | idx 1 6x Large Brilliant Shard 14344; idx 2 25x Dark Iron Ore 11370 |
| 7628 | Doomsday Candle | Mor'zul | Gorzeeki | idx 1 35x Black Dragonscale 15416 |
| 7630 | Arcanite | Gorzeeki | Gorzeeki | idx 1 3x Arcanite Bar 12360 |
| 7623 | Lord Banehollow | Gorzeeki | Lord Banehollow 9516 (Shadow Hold, Felwood) | - (Shadowy Potion 18802 kopen bij Gorzeeki; buff Taint of Shadow 23179; ingang 35.42,58.61) |
| 7624 | Ulathek the Traitor | Banehollow | Banehollow | idx 1 The Traitor's Heart 18719: kill Ulathek 14523, Felwood 40.77,48.42 (praten 39.89,49.17) |
| 7625 | Xorothian Stardust | Banehollow | Gorzeeki | idx 1 Xorothian Stardust 18687, kopen bij Ur'dan 14522, Felwood 36.17,44.46 |
| 7629 | Imp Delivery | Gorzeeki | Gorzeeki | idx 1 "Parchment Created": Imp in a Jar 18688 bij het alchemielab in Scholomance |
| 7631 | Dreadsteed of Xoroth | Mor'zul | Dreadsteed Spirit 14504 (Dire Maul West) | geen objective in de tooltip; J'eevee's Jar 18663, Black Lodestone 18629, Xorothian Glyphs 18670 kopen bij Gorzeeki |

- G: ZA 24226-24406, ZH 25265-25452; SPC r. 2990-3010 (prev: 7563<-7562, 7564<-7563, 7623/7626/7627/7628<-7564,
  7624<-7623, 7625<-7624, 7629<-7625, 7630<-7626, 7631<-7629; ender 7631 = 14504); WH-tooltips (Requirements-volgorde);
  DB2 ItemSparse (alle item-ids).
- 7562-gevers: G SPQ r. 2256-2260 (Spackle, Martha Strain, Kurgul, Jubahl Corpseseeker, allemaal 7562); QW 7562 noemt
  daarnaast Greshka 12807 (Swamp of Sorrows 48.58,55.27, WH "Demon Master") (G, EverythingQuests). Zygor kent alleen
  Spackle (ZA 24227) en Kurgul (ZH 25266). PS koppelt Spackle=Human, Jubahl=Gnome, Kurgul=Orc/Troll, Martha=Undead (G, gids).
- Voorstel lineaire volgorde voor het druid-format: 7562, 7563, 7564, 7626, 7627, 7628, 7630, 7623, 7624, 7625, 7629,
  7631 (A: volgt de SPC-prev-ketting en de stapvolgorde van ZA/PS). Let op: ZA en PS laten 7623 al direct na 7564
  aannemen; met de regel "laatste quest in je log beslist" springt de pijl dan naar Banehollow terwijl 7626-7628 nog
  open staan (A). De bouwchat moet hier kiezen.
- Live-status: in de Forever-data (G: QW-records, Questie-export 4 okt); conquestcapped (1 nov) "nobody has played
  them yet"; geen bevestiging na de launch gevonden. Scholomance-ingang heeft geen coordinaat (ZA gebruikt
  `Scholomance/0 0.00,0.00`). Dire Maul-West-deur: Feralas 60.32,30.16 (ZH r. 25438). De Dreadsteed Spirit heeft op
  Wowhead 0 spawns (G: WH 14504).

## 7. Item-ketens (geen spell -> `nameKey`, zoals Torwa)

### 7a. Shard of the Green Flame (level 50)
| q | titel | van | naar | objs |
|---|---|---|---|---|
| 7601 | What Niby Commands | Niby the Almighty 14469 | Impsy 14470 | - |
| 7602 | Flawless Fel Essence | Impsy | Impsy | idx 1 Azshara 18624 (Legashi-saters, Azshara 52.03,18.65); idx 2 Jaedenar 18622 (Jaedenar Legionnaire 9862, Felwood 36.25,55.94); idx 3 Dark Portal 18623 (Felguard Sentry 6011, Blasted Lands 61.32,54.18) |
| 7603 | Kroshius' Infernal Core | Impsy | Niby | idx 1 Kroshius' Infernal Core 18625: Fel Fire 18626 gebruiken, Kroshius 14467 doden, Felwood 45.73,34.81 |
Beloning 7603: Shard of the Green Flame **18762** (G: QW 7603; WH item 18762; DB2 ItemSparse). Min. level 50, questlevel 55 (G: QW).
G: ZA 24083-24190; SPC r. 2996-2998; WH-tooltip 7602 (volgorde Azshara/Jaedenar/Dark Portal; ZA `q 7602/1..3`).

### 7b. An Imp's Request (level 50)
| q | titel | van | naar | objs |
|---|---|---|---|---|
| 8419 (alt 8420) | An Imp's Request / Hot and Itchy | 8419: stad-trainer (Demisette, Zevrost, Kaal, Briarthorn); 8420: Impsy | Impsy | idx 1 Felcloth 14256 (Zygor: kopen/farmen) |
| 8421 | The Wrong Stuff | Impsy | Impsy | idx 1 10x Rotting Wood 20613 (Felwood 46.89,24.16); idx 2 4x Bloodvenom Essence 20614 (Tainted Ooze 7092, Felwood 40.92,46.83) |
| 8422 | Trolls of a Feather | Impsy | Impsy | idx 1/2/3 2x Amber 20606 / Blue 20607 / Green 20608 Voodoo Feather, Sunken Temple (ingang Swamp of Sorrows 69.36,56.89) |
Beloning 8422: keuze Soul Harvester 20536, Abyss Shard 20534, Robes of Servitude 20530 (G: QW item-ids; WH-item-tooltips;
DB2 `Item` heeft de rijen, `ItemSparse` niet). G: SPQ r. 306-310 (8419-gevers), SPC r. 3493-3496 (8421 prev 8419), ZA 24088-24111.

### 7c. Niet uitgewerkt (alleen gevonden, G: SPC `classes = 256`, PS-lijst)
Orb of Soran'ruk 1740 (Doan Karhan 6247, Barrens 49.2,57.2 WH), Dread Mage Hat (Alliance), Enchanted Gold Bloodrobe
(1796, 4736-4739, 4781-4786), Orb of Orahil (1799, 4961-4976), Tome of Sacrifice (7581-7583), Atiesh (9271).

---

## 8. Plekken (`P`): UiMap-id + x/y

UiMap-id's G (DB2 UiMap 1.60.1.70938): 1411 Durotar, 1413 The Barrens, 1419 Blasted Lands, 1420 Tirisfal Glades,
1421 Silverpine Forest, 1424 Hillsbrad Foothills, 1426 Dun Morogh, 1428 Burning Steppes, 1429 Elwynn Forest,
1435 Swamp of Sorrows, 1437 Wetlands, 1440 Ashenvale, 1441 Thousand Needles, 1442 Stonetalon Mountains, 1444 Feralas,
1447 Azshara, 1448 Felwood, 1452 Winterspring, 1453 Stormwind City, 1454 Orgrimmar, 1455 Ironforge, 1458 Undercity.

| P-sleutel (voorstel) | npc (id) | m | x, y | bron |
|---|---|---|---|---|
| drusilla | Drusilla La Salle (459) | 1429 | 49.69, 42.65 | HN r. 103 (ZA 49.87,42.65) |
| alamar | Alamar Grimm (460) | 1426 | 28.38, 66.18 | HN r. 61 (ZA 28.59,66.23, boven in Anvilmar) |
| ruzan | Ruzan (5765) | 1411 | 42.59, 69.00 | ZH 24848 |
| venya | Venya Marthand (5667) | 1420 | 30.98, 66.41 | ZH 24867 |
| remen | Remen Marcot (6121) | 1429 | 44.49, 66.27 | ZA 23869 |
| lago | Lago Blackwrench (6120) | 1455 | 47.63, 9.26 | ZA 23789 |
| gakin | Gakin the Darkbinder (6122) | 1453 | 39.22, 85.23 | ZA 23811; FDB "seen in Forever" 39.3,85.2 |
| circleSW | - | 1453 | 39.11, 84.37 | ZA 23853 (FDB questkaart 39.1,84.4) |
| ophek | Ophek (3294) | 1411 | 54.37, 41.29 | ZH 24920 |
| ganrul | Gan'rul Bloodeye (5875) | 1454 | 48.24, 45.29 | ZH 24929 |
| circleOrg | - | 1454 | 49.44, 50.02 | ZH 24962 |
| ageron | Ageron Kargal (5724) | 1420 | 61.62, 52.67 | ZH 24884 |
| carendin | Carendin Halgar (5675) | 1458 | 85.04, 26.01 | ZH 24890 |
| circleUC | - | 1458 | 86.62, 27.10 | ZH 24910 |
| takar | Takar the Seer (6244) | 1413 | 49.31, 57.10 | ZA 23954 |
| cazul | Cazul (5909) | 1454 | 47.06, 46.48 | ZH 24978 |
| zankaja | Zankaja (5910) | 1454 | 37.03, 59.45 | ZH 24987 |
| gazrog | Gazrog (3464) | 1413 | 51.93, 30.32 | ZH 24992 |
| kenzigla | Ken'zigla (4197) | 1442 | 73.25, 95.12 | ZH 25002 |
| logmar | Grunt Logmar (5911) | 1413 | 44.62, 59.27 | ZH 25012 |
| dogran | Grunt Dogran (5908) | 1413 | 43.31, 47.89 | ZH 25018 |
| magar | Magar (3363) | 1454 | 63.7, 49.9 | QW 65601 (Questie); WH-spawns 63.2-63.6,50.0-50.6 |
| godrick | Godrick Farsan (5693) | 1458 | 84.81, 14.83 | QW 1472 (EverythingQuests); WH 85.0-85.6,14.2-15.6 |
| strahad | Strahad Farsan (6251) | 1413 | 62.63, 35.50 | ZA 24003 |
| circleRatchet | - | 1413 | 62.60, 35.28 | ZA 24046 |
| krom | Krom Stoutarm (6294) | 1455 | 74.21, 9.42 | ZA 24009 |
| jorah | Jorah Annison (6293) | 1458 | 75.91, 37.87 | ZH 25054 |
| demisette | Demisette Cloyce (461) | 1453 | 39.24, 84.96 | HN r. 213 |
| briarthorn | Briarthorn (5172) | 1455 | 50.35, 5.66 | HN r. 142 |
| zevrost | Zevrost (3326) | 1454 | 48.47, 45.43 | HN r. 190 |
| kaal | Kaal Soulreaper (4563) | 1458 | 86.21, 15.93 | HN r. 306 |
| spackle | Spackle Thornberry (5520) | 1453 | 39.53, 84.53 | HN r. 216 |
| jubahl | Jubahl Corpseseeker (6382) | 1455 | 52.70, 6.08 | HN r. 144 |
| kurgul | Kurgul (5815) | 1454 | 47.52, 46.72 | HN r. 191 |
| martha | Martha Strain (5753) | 1458 | 85.70, 16.08 | HN r. 309 |
| niby | Niby the Almighty (14469) | 1448 | 41.38, 44.86 | ZA 24085 |
| impsy | Impsy (14470) | 1448 | 41.36, 45.02 | ZA 24089 |
| morzul | Mor'zul Bloodbringer (14436) | 1428 | 12.69, 31.64 | ZA 24234 |
| gorzeeki | Gorzeeki Wildeyes (14437) | 1428 | 12.43, 31.63 | ZA 24251 |
| banehollow | Lord Banehollow (9516) | 1448 | 35.93, 44.41 | ZA 24309 |
| urdan | Ur'dan (14522) | 1448 | 36.17, 44.46 | ZA 24349 |
| dreadsteedSpirit | Dreadsteed Spirit (14504) | 1444 | 60.32, 30.16 | Dire Maul-West-deur ZH 25438; dat de pijl daarheen moet = A |

Objective-plekken (zonder npc): stolenBooks 1429 56.71,43.95 (ZA 23752); featherCharms 1426 28.73,82.58 (ZA 23769);
familiars 1411 45.34,56.36 (ZH 24853); rattlecage 1420 32.73,60.10 (ZH 24871); surena 1429 71.02,80.78 (ZA 23832);
verga 1411 51.62,9.74 (ZH 24943); grimoire 1420 51.06,67.57 (ZH 24898); heartswood 1440 31.49,31.45 (ZA 23966);
figurine 1440 26.6,22.0 (QW 65602); scarf 1440 64.0,79.0 (QW 65610); dalin 1421 44.4,83.4 (WH-spawn; pin 47.6,85.65);
corma 1437 50.0,12.8 (WH-spawn; pin 49.93,12.55); avelina 1421 63.5,65.3 (QW 65593); isaac 1413 61.8,38.5 (QW 65593);
moldyTome 1424 27.78,72.78 (ZA 24017); manuscript 1441 43.43,32.69 (ZA 24022); rods 1437 45.09,43.08 (ZA 24033);
owlbeasts 1452 63.65,16.33 (ZA 24241); ulathek 1448 40.77,48.42 (ZA 24325); essAzshara 1447 52.03,18.65 (ZA 24123);
essJaedenar 1448 36.25,55.94 (ZA 24119); essBlasted 1419 61.32,54.18 (ZA 24130); kroshius 1448 45.73,34.81 (ZA 24185);
rottingWood 1448 46.89,24.16 (ZA 24106); ooze 1448 40.92,46.83 (ZA 24101); sunken 1435 69.36,56.89 (ZA 24142, gelijk
aan de bestaande `P.sunken` van de druid).

**Let op Stormwind (G):** Wowhead Forever geeft voor Gakin, Demisette, Spackle en de summoned demons twee reeksen,
bv. Gakin 25.4,78.4 / 25.4,78.6 / 25.6,77.8 / 25.6,78.6 **en** 39.2,85.2 (WH npc 6122). QW toont de 25.x-reeks.
FDB (spelers in Forever) ziet Gakin op 39.3,85.2 en de voidwalker op 38.8,84.7; HN zet Demisette op 39.24,84.96.
Dus 39.x is de UiMap-1453-ruimte; **gebruik de 25.x-reeks niet** (A, op basis van FDB + HN + ZA). Voor andere steden
klopt WH met Zygor (bv. Gan'rul WH 48.2,45.4 vs ZH 48.24,45.29).

## 9. NPC-namen per taal (G: WH-tooltips `--locale`, 17 nov; esMX-gaten aangevuld uit Spoken `Spoken_Quests\Locale\Names\esMX.lua`)

Controle: npc 233 = "Bauer Saldean" (de), "Saldean le fermier" (fr), "Granjero Saldean" (es/mx), "Fazendeiro Saldanha"
(pt), "Фермер Сальден" (ru), gelijk aan de druid-meting. Een Engelse naam zonder [haken] = de naam van die client.
[haken] bij esMX = Wowhead heeft geen esMX-naam. Zygor's `NPCs_deDE.lua` wijkt af (Classic-namen: "Krom Starkarm",
"Zureetha Fernblick", "Lord Schattenfluch", "Gorzeeki Wildaug"); WH en Spoken deDE zijn het onderling eens (Gakin der
Dunkelbinder, Takar der Seher, Grunzer Dogran, Jubaal Corpseseeker, Niby der Allmächtige) -> WH gekozen (A).

| id | enUS | deDE | frFR | esES | esMX | ptBR | ruRU |
|---|---|---|---|---|---|---|---|
| 459 | Drusilla La Salle | Drusilla La Salle | Drusilla La Salle | Drusilla La Salle | Drusilla La Salle | Drusilla La Salle | Друзилла ла Салле |
| 460 | Alamar Grimm | Alamar Grimm | Alamar Grimm | Alamar Grimm | Alamar Grimm | Alamar Carranca | Аламар Мрачнн |
| 5765 | Ruzan | Ruzan | Ruzan | Ruzan | Ruzan | Ruzan | Рузан |
| 5667 | Venya Marthand | Venya Marthand | Venya Marthand | Venya Martmani | Venya Marthand | Vênia Martingil | Вения Мартанд |
| 3145 | Zureetha Fargaze | Zureetha Fargaze | Zureetha Fargaze | Vistalonga | Zureetha Vistalonga | Zureta Vista-longa | Зурита Востроглазая |
| 6121 | Remen Marcot | Remen Marcot | Remen Marcot | Remen Marcot | Remen Marcot | Rêmulo Marcos | Ремен Маркот |
| 6120 | Lago Blackwrench | Lago Blackwrench | Lago Blackwrench | Llago Llavenegra | Yago Llavenegra | Iago Chavenegra | Лаго Злобноверт |
| 6122 | Gakin the Darkbinder | Gakin der Dunkelbinder | Gakin le Tisse-noir | Gakin el Presotenebra | Gakin el Presotenebra | Gakin, o Neromante | Гакин Темнопряд |
| 3294 | Ophek | Ophek | Ophek | Ophek | Ophek | Ophek | Офек |
| 5875 | Gan'rul Bloodeye | Gan'rul Bloodeye | Gan'rul Bloodeye | Ojo sangriento de Gan'rul | Gan'rul Ojosangre | Gan'rul Olho de Sangue | Ган'рул Кровавый Глаз |
| 5724 | Ageron Kargal | Ageron Kargal | Ageron Kargal | Ageron Kargal | Ageron Kargal | Ageron Karhal | Агерон Каргал |
| 5675 | Carendin Halgar | Carendin Halgar | Carendin Halgar | Carendin Halgar | Carendin Halgar | Silvério Hidalgo | Карендин Халгар |
| 6244 | Takar the Seer | Takar der Seher | Takar le Prophète | Takar el Profeta | Takar el Vidente | Takar, o Vidente | Такар Провидец |
| 5909 | Cazul | Cazul | Cazul | Cazul | Cazul | Cazul | Казул |
| 5910 | Zankaja | Zankaja | Zankaja | Zankaja | Zankaja | Zankaja | Занкайя |
| 3464 | Gazrog | Gazrog | Gazrog | Gazrog | Gazrog | Gazrog | Газрог |
| 4197 | Ken'zigla | Ken'zigla | Ken'zigla | Ken'zigla | Ken'zigla | Ken'zigla | Кен'зигла |
| 5911 | Grunt Logmar | Grunzer Logmar | Grunt Logmar | Bruto Logmar | Bruto Logmar | Bruto Logmar | Рубака Логмар |
| 5908 | Grunt Dogran | Grunzer Dogran | Grunt Dogran | Bruto Dogran | Bruto Dogran | Bruto Dogran | Рубака Догран |
| 3363 | Magar | Magar | Magar | Magar | Magar | Magar | Магар |
| 5693 | Godrick Farsan | Godrick Farsan | Godrick Farsan | Godrick Farsan | Godrick Farsan | Godofredo Fasano | Годрик Фарсан |
| 6251 | Strahad Farsan | Strahad Farsan | Strahad Farsan | Strahad Farsan | Strahad Farsan | Strahad Farsan | Страхад Фарсан |
| 6294 | Krom Stoutarm | Krom Stoutarm | Krom Stoutarm | Krom Brazorrecio | Krom Brazorrecio | Krom Braçoforte | Кром Крепкорук |
| 6293 | Jorah Annison | Jorah Annison | Jorah Annison | Jorah Annison | Jorah Annison | Jonas Anísio | Йорах Аннисон |
| 461 | Demisette Cloyce | Demisette Cloyce | Demisette Cloyce | Demisette Cloyce | Demisette Cloyce | Joyce Lopes | Демизетта Клойс |
| 5172 | Briarthorn | Briarthorn | Eglantine | Brezospina | Brezospina (Spoken; WH [Briarthorn]) | Cravespinho | Остротерн |
| 3326 | Zevrost | Zevrost | Zevrost | Zevrost | Zevrost | Zevrost | Зеврост |
| 4563 | Kaal Soulreaper | Kaal Soulreaper | Kaal Soulreaper | Revientalmas Kaal | Kaal Segador de Almas | Kaal Ceifalma | Каел Жнец Душ |
| 5520 | Spackle Thornberry | Spackle Thornberry | Spackle Thornberry | Spackle Espinamora | Spackle Zarzamora | Spackle Cardopomo | Шпакл Шиповникс |
| 6382 | Jubahl Corpseseeker | Jubaal Corpseseeker | Jubahl Cherche-corps | Jubahl Buscadáver | Jubahl Buscador de cadáveres (Spoken; WH [..]) | Jubahl Catadefunto | Жубал Труполов |
| 5815 | Kurgul | Kurgul | Kurgul | Kurgul | Kurgul | Kurgul | Кургул |
| 5753 | Martha Strain | Martha Strain | Martha Strain | Martha Forza | Martha Strain | Marta Seixas | Марта Стрейн |
| 14469 | Niby the Almighty | Niby der Allmächtige | Niby le Tout-puissant | Niby el Todopoderoso | Niby el Todopoderoso (Spoken; WH [..]) | Niby, o Todo-poderoso | Ниби Всемогущий |
| 14470 | Impsy | Impsy | Démonet | Diblis | niet gemeten | Diabretim | Бесенок |
| 14436 | Mor'zul Bloodbringer | Mor'zul Bloodbringer | Mor'zul Bloodbringer | Mor'zul Sangredoble | Mor'zul Sangredoble (Spoken; WH [..]) | Mor'zul Trazangre | Мор'зул Кровопуск |
| 14437 | Gorzeeki Wildeyes | Gorzeeki Wildeyes | Gorzeeki Wildeyes | Gorzeeki Ojosalvajes | Gorzeeki Ojovago (Spoken; WH [..]) | Gorzeeki Olholouco | Горзиеки Дикоглаз |
| 9516 | Lord Banehollow | Lord Banehollow | Seigneur Banehollow | Lord Pesadilla | niet gemeten | Lorde Nihilus | Лорд Гиблопуст |
| 14522 | Ur'dan | Ur'dan | Ur'dan | Ur'dan | niet gemeten | Ur'dan | Ур'дан |
| 14504 | Dreadsteed Spirit | Schreckensrossgeist | Esprit de Destrier de l'effroi | Espíritu Corcelorror | niet gemeten | Espírito de Corcel Medonho | Дух коня погибели |

Doelwitten (voor de FCQ_OBJ-teksten):

| id | enUS | deDE | frFR | esES | esMX | ptBR | ruRU |
|---|---|---|---|---|---|---|---|
| 881 | Surena Caledon | Surena Caledon | Surena Caledon | Surena Caledon | Surena Caledon | Surena Caledon | Сурена Каледон |
| 5676 | Summoned Voidwalker | Beschworener Leerwandler | Marcheur du Vide invoqué | Abisario invocado | Abisario invocado | Emissário do Caos Evocado | Призванный демон Бездны |
| 5677 | Summoned Succubus | Beschworener Sukkubus | Succube invoquée | Súcubo invocado | Súcubo invocado | Súcubo Evocado | Вызванный суккуб |
| 185335 | Summoned Incubus | Beschworener Inkubus | Incube invoqué | Íncubo invocado | Íncubo invocado | Íncubo Evocado | Призванный инкуб |
| 6268 | Summoned Felhunter | Beschworener Teufelsjäger | Chasseur corrompu invoqué | Manáfago invocado | Manáfago invocado | Caçador Vil Evocado | Призванный охотник Скверны |
| 5682 | Dalin Forgewright | Dalin Forgewright | Dalin Forgewright | Dalin Forjador | Dalin Forjador | Dalin Forjífice | Далин Искусник |
| 5683 | Corma Villard | Corma Villard | Corma Villard | Corma Villardo | Comar Villardo | Corma Vilardo | Корма Виллард |
| 14467 | Kroshius | Kroshius | Kroshius | Kroshius | niet gemeten | Kroshius | Крошиус |
| 14523 | Ulathek | Ulathek | Ulathek | Ulathek | niet gemeten | Ulathek | Улатек |
| 14502 | Xorothian Dreadsteed | Xorothianisches Schreckensross | Destrier de l'effroi xorothien | Corcel de la Muerte Xorothiano | niet gemeten | Corcel Medonho Zorotiano | Ксоротианский конь погибели |

Niet gemeten per taal: Avelina Lilly en Isaac Pearson (npc-id's niet gevonden), Doan Karhan 6247, Greshka 12807.
"Аламар Мрачнн" (ru, 460) staat zo in Wowhead (lijkt een tikfout van Blizzard; zo laten, het is wat de client toont = A).

## 10. Voorstel in druid-vorm (schets voor de bouwchat; textKeys zijn voorstellen, niets is bestaande code)

```lua
-- races = raceFile (ChrRaces.ClientFileString). Coordinaten: zie tabel in hoofdstuk 8.
local HUM, GNO = { Human = true }, { Gnome = true }
local ORCTROLL, UD = { Orc = true, Troll = true }, { Scourge = true }
CHAINS.WARLOCK = {
	{ key = "imp", spell = 688, level = 1, faction = "Alliance", races = HUM, quests = {
		{ q = 1598, from = P.drusilla, objs = { O(P.stolenBooks, "FCQ_OBJ_WL_POWERSVOID", 1) }, to = P.drusilla } } },
	{ key = "imp", spell = 688, level = 1, faction = "Alliance", races = GNO, quests = {
		{ q = 1599, from = P.alamar, objs = { O(P.featherCharms, "FCQ_OBJ_WL_FEATHERCHARM", 1) }, to = P.alamar } } },
	{ key = "imp", spell = 688, level = 1, faction = "Horde", races = ORCTROLL, quests = {
		{ q = 1485, from = P.ruzan, objs = { O(P.familiars, "FCQ_OBJ_WL_FAMILIARHEAD", 1) }, to = P.ruzan } } },
	{ key = "imp", spell = 688, level = 1, faction = "Horde", races = UD, quests = {
		{ q = 1470, from = P.venya, objs = { O(P.rattlecage, "FCQ_OBJ_WL_RATTLESKULL", 1) }, to = P.venya } } },

	{ key = "voidwalker", spell = 697, level = 10, faction = "Alliance", races = HUM, quests = {
		{ q = 1685, from = P.remen, to = P.gakin },
		{ q = 1688, from = P.gakin, objs = { O(P.surena, "FCQ_OBJ_WL_SURENA", 1) }, to = P.gakin },
		{ q = 1689, from = P.gakin, objs = { O(P.circleSW, "FCQ_OBJ_WL_BIND_VOID", 1) }, to = P.gakin } } },
	-- Gnome: zelfde, eerste stap { q = 1715, from = P.lago, to = P.gakin }
	{ key = "voidwalker", spell = 697, level = 10, faction = "Horde", races = ORCTROLL, quests = {
		{ q = 1506, from = P.ophek, to = P.ganrul },
		{ q = 1501, from = P.ganrul, objs = { O(P.verga, "FCQ_OBJ_WL_VERGA", 1) }, to = P.ganrul },
		{ q = 1504, from = P.ganrul, objs = { O(P.circleOrg, "FCQ_OBJ_WL_BIND_VOID", 1) }, to = P.ganrul } } },
	{ key = "voidwalker", spell = 697, level = 10, faction = "Horde", races = UD, quests = {
		{ q = 1478, from = P.ageron, to = P.carendin },
		{ q = 1473, from = P.carendin, objs = { O(P.grimoire, "FCQ_OBJ_WL_GRIMOIRE", 1) }, to = P.carendin },
		{ q = 1471, from = P.carendin, objs = { O(P.circleUC, "FCQ_OBJ_WL_BIND_VOID", 1) }, to = P.carendin } } },

	{ key = "succubus", spell = 712, level = 20, faction = "Alliance", quests = {
		{ q = 1716, from = P.gakin, to = P.takar },
		{ q = 1738, from = P.takar, objs = { O(P.heartswood, "FCQ_OBJ_WL_HEARTSWOOD", 1) }, to = P.gakin },
		{ q = 1739, from = P.gakin, objs = { O(P.circleSW, "FCQ_OBJ_WL_BIND_SUCC", 1) }, to = P.gakin } } },
	{ key = "incubus", spell = 713, level = 20, faction = "Alliance", quests = {
		{ q = 1716, from = P.gakin, to = P.takar },
		{ q = 65602, from = P.takar, objs = { O(P.figurine, "FCQ_OBJ_WL_FIGURINE", 1) }, to = P.gakin },
		{ q = 65603, from = P.gakin, objs = { O(P.circleSW, "FCQ_OBJ_WL_BIND_INC", 1) }, to = P.gakin } } },
	{ key = "succubus", spell = 712, level = 20, faction = "Horde", races = ORCTROLL, quests = {
		{ q = 1507, from = P.ganrul, to = P.cazul },
		{ q = 1508, from = P.cazul, to = P.zankaja },
		{ q = 1509, from = P.zankaja, to = P.gazrog },
		{ q = 1510, from = P.gazrog, to = P.kenzigla },
		{ q = 1511, from = P.kenzigla, to = P.logmar },
		{ q = 1515, from = P.logmar, to = P.dogran },
		{ q = 1512, from = P.dogran, to = P.ganrul },
		{ q = 1513, from = P.ganrul, objs = { O(P.circleOrg, "FCQ_OBJ_WL_BIND_SUCC", 1) }, to = P.ganrul } } },
	{ key = "incubus", spell = 713, level = 20, faction = "Horde", races = ORCTROLL, quests = {
		{ q = 1507, from = P.ganrul, to = P.cazul },
		{ q = 65601, from = P.cazul, to = P.magar },
		{ q = 65610, from = P.magar, objs = { O(P.scarf, "FCQ_OBJ_WL_SCARF", 1) }, to = P.ganrul },
		{ q = 65604, from = P.ganrul, objs = { O(P.circleOrg, "FCQ_OBJ_WL_BIND_INC", 1) }, to = P.ganrul } } },
	{ key = "succubus", spell = 712, level = 20, faction = "Horde", races = UD, quests = {
		{ q = 1472, from = P.carendin, to = P.godrick },
		{ q = 1476, from = P.godrick, objs = { O(P.dalin, "FCQ_OBJ_WL_DALIN", 1), O(P.corma, "FCQ_OBJ_WL_CORMA", 2) }, to = P.carendin },
		{ q = 1474, from = P.carendin, objs = { O(P.circleUC, "FCQ_OBJ_WL_BIND_SUCC", 1) }, to = P.carendin } } },
	{ key = "incubus", spell = 713, level = 20, faction = "Horde", races = UD, quests = {
		{ q = 1472, from = P.carendin, to = P.godrick },
		{ q = 65593, from = P.godrick, objs = { O(P.avelina, "FCQ_OBJ_WL_AVELINA", 1), O(P.isaac, "FCQ_OBJ_WL_ISAAC", 2) }, to = P.carendin },
		{ q = 65597, from = P.carendin, objs = { O(P.circleUC, "FCQ_OBJ_WL_BIND_INC", 1) }, to = P.carendin } } },

	{ key = "felhunter", spell = 691, level = 30, faction = "Alliance", quests = {
		{ q = 1798, from = P.gakin, to = P.strahad },
		{ q = 1758, from = P.strahad, to = P.krom },
		{ q = 1802, from = P.krom, objs = { O(P.moldyTome, "FCQ_OBJ_WL_MOLDYTOME", 1), O(P.manuscript, "FCQ_OBJ_WL_MANUSCRIPT", 2) }, to = P.krom },
		{ q = 1804, from = P.krom, objs = { O(P.rods, "FCQ_OBJ_WL_RODS", 1) }, to = P.strahad },
		{ q = 1795, from = P.strahad, objs = { O(P.circleRatchet, "FCQ_OBJ_WL_BIND_FEL", 1) }, to = P.strahad } } },
	{ key = "felhunter", spell = 691, level = 30, faction = "Horde", races = ORCTROLL, quests = {
		{ q = 2996, alt = { 3001 }, from = P.ganrul, to = P.strahad },
		{ q = 1801, from = P.strahad, to = P.jorah },
		{ q = 1803, from = P.jorah, objs = { O(P.moldyTome, "FCQ_OBJ_WL_MOLDYTOME", 1), O(P.manuscript, "FCQ_OBJ_WL_MANUSCRIPT", 2) }, to = P.jorah },
		{ q = 1805, from = P.jorah, objs = { O(P.rods, "FCQ_OBJ_WL_RODS", 1) }, to = P.strahad },
		{ q = 1795, from = P.strahad, objs = { O(P.circleRatchet, "FCQ_OBJ_WL_BIND_FEL", 1) }, to = P.strahad } } },
	-- Undead: zelfde, eerste stap { q = 3001, alt = { 2996 }, from = P.carendin, to = P.strahad }

	-- Felsteed per ras: Human 4488 (P.demisette, alt 4487), Gnome 4487 (P.briarthorn, alt 4488),
	-- Orc/Troll 3631 (P.zevrost, alt 4489), Undead 4489 (P.kaal, alt 3631); daarna { q = 4490, from = P.strahad, to = P.strahad }.
	-- Dreadsteed per ras: 7562 van P.spackle / P.jubahl / P.kurgul / P.martha, dan de volgorde uit hoofdstuk 6.
}
```

---

## Open / niet gemeten

1. **Niets in het spel gezien.** Alle quest-ids, objective-indexen en coordinaten zijn uit bestanden en databases;
   de client heeft nog niets afgevinkt. Dat de Wowhead-"Requirements"-volgorde gelijk is aan de client-index = A.
2. **Trollen (nieuw in Forever):** het Wowhead-record noemt Troll bij 1485, 1504, 1506, maar **niet** bij 1507-1513,
   1472-1476, 2996/3001, 3631/4489 en 1478 (alleen "Orc, Undead"). Gidsen (IV, PS, mmojugg 15 nov) zeggen dat trollen
   de Orgrimmar-route lopen. Niet gemeten. Test met een troll-warlock op 20, 30 en 40.
3. **Incubus spell-id 713** bij 65603/65604/65597 = A (gidsen + questtekst; quest-record noemt geen spell).
4. **65602-gever:** QW/PS/IV zeggen Takar; Spoken-Compendium suggereert gever = inleveraar (Gakin). Gekozen: Takar.
5. **Gnome-felhunter:** PS laat Gnomes "Seeking Strahad" bij Lago halen; quest-id daarvan niet gevonden (SPQ/QW: alleen
   Gakin voor 1798).
6. **Felsteed:** in Forever een echte mount in de Mounts-verzameling (DR). Of `IsSpellKnown(5784)` de keten als klaar
   ziet, is niet getest. PS: spelers melden dat de felhunter-keten eerst af moet; niet in records gezien.
7. **Dreadsteed:** geen speler-bevestiging na de launch gevonden. Scholomance-ingang zonder coordinaat; Dreadsteed
   Spirit heeft geen spawn op Wowhead. Lineaire volgorde in hoofdstuk 6 is een keuze (A).
8. **Inferno (1122) en Ritual of Doom (18540):** geen quest gevonden; aangenomen trainer-spell (A).
9. **Coordinaat-conflicten:** Tattered Manuscript (Zygor Thousand Needles 43.43,32.69 vs PS "49, 96.8 on The Barrens
   map"); Dalin Forgewright (WH-spawns rond 44.4,83.4 vs pin 47.6,85.65); Stormwind dubbele Wowhead-reeks (hoofdstuk 8).
10. **Zygor-fouten** (moet de bouwchat niet overnemen): felhunter-binding 1471 -> 1795; Horde 1758 -> 1801;
    Demisette 4487/4488 -> 4488 (Briarthorn = 4487).
11. **Zoeken naar nieuwe Forever-warlock-quests:** alleen 98575 (Tainted Tablet, Troll) gevonden. Niet alle id's
    gescand: wel 98560-98590, 98720-98760 (controle: druid 98731/98738/98739 gevonden), 65585-65615 (gaf 65593, 65597,
    65604). PS-lijst (18 warlock-class-quests, nov 2026) en SPC `classes = 256` tonen niets anders nieuws.
12. **esMX ontbreekt** voor Impsy 14470, Lord Banehollow 9516, Ur'dan 14522, Dreadsteed Spirit 14504, Kroshius 14467,
    Ulathek 14523, Xorothian Dreadsteed 14502. Avelina Lilly en Isaac Pearson: geen id, geen namen.
13. **Imp-keten:** of een nieuwe Forever-warlock zonder Summon Imp begint, is niet in de client gezien (records zeggen
    dat 1598/1485 hem leren). Voor 1599 en 1470 komt "leert Summon Imp" alleen uit gidsen (PS, IV).
14. **Item-ketens** (Orb of Soran'ruk, Dread Mage Hat, Bloodrobe, Orb of Orahil, Tome of Sacrifice) niet uitgewerkt.
