# Warrior class-quests in WoW Forever: feiten voor `Modules/ForeverClassQuests.lua`

mh-research, 17 nov 2026. Client: Forever build 1.60.1.70938. Alleen gelezen, niets in het spel gezien.
Elke bewering: **GEMETEN** (bron + regel/URL, gezien vandaag) of **AFGELEID** (redenering).
Let op: deze helper leest volgens zijn eigen regel niets in `docs/`. Het warlock-feitenbestand is dus NIET gelezen; de
opbouw hieronder volgt de beschrijving in de opdracht (bronnen, ketens, plekken, namen, Lua-schets, open punten) en de
vorm van `Modules/ForeverClassQuests.lua` (P, O(), CHAINS.DRUID, WL_P, CHAINS.WARLOCK), die wel gelezen is.

## 0. Kort

- **Drie ketens die een spell opleveren** (GEMETEN Wowhead Forever + DB2, zie 2):
  - level 10: **Defensive Stance 71 + Sunder Armor 7386 + Taunt 355**, zes routes per ras (Human, Dwarf/Gnome, Night Elf,
    Orc/Troll, Tauren, Undead) en een eigen Skyborne-quest (94003).
  - level 30: **Berserker Stance 2458 + Intercept 20252**, "The Islander" 1718 en "The Affray" 1719, voor iedereen.
- **Item-ketens**: Whirlwind-wapen (30-40), vier wapenvervolgen op level 10, pantser op level 20 (Alliance en Horde),
  Fallen Hero / Voodoo Feathers (50-52).
- **Nieuw in Forever** voor de warrior: alleen 92479 (brief, level 1), 92532 (Skyborne-intro, level 2) en 94003
  (Skyborne level 10). Geen 98xxx-reeks zoals bij de druid (GEMETEN in Spoken, zie 1; AFGELEID dat er geen andere zijn).
- MH's `ns.FOREVER_QUEST_FIRST` (71, 355, 7386 op 10; 2458, 20252 op 30) **klopt** (zie 2.3).
- Drie Zygor-fouten gevonden (zie 8).

## 1. Bronnen

| # | Bron | Wat | Datum / build | Gebruikt voor |
|---|---|---|---|---|
| Z | Zygor Forever, `ZygorLevelingAllianceCLASSIC.lua` r. 21877-22144, `ZygorLevelingHordeCLASSIC.lua` r. 23269-23560, `ZygorLevelingCommonCLASSIC.lua` r. 92, 146, 1150-1158, 1346-1349, 1574-1583 | stappen, coördinaten, item-id's, objective-nummers | bestand op schijf, gelezen 17 nov | volgorde, plekken van doelen |
| ZT | Zygor `Data-Forever\Skill_Training.lua` r. 213-374 (WARRIOR) | wat de trainer verkoopt | idem | controle quest-spells |
| S | Spoken `Spoken_Quests\Data\Compendium.lua` (r. 1318-1479, 3491-3499, 4346, 4359, 4449, 1437) | prev / ender / races / classes per quest | gemaakt uit Forever 1.60.1.70450 (kop r. 13) | ketens, wie inlevert, rassen |
| SL | Spoken `SpokenQuestsAudioShared\generated\quest_id_lookups.lua` r. 461-464, 923-927, 1421-1432, 1497-1501, 1662-1668, 2245-2248 | welke NPC's dezelfde quest geven | idem | extra gevers |
| SN | Spoken `Spoken_Quests\Locale\Names\<taal>.lua` | namen van questgevers per taal | idem | tweede bron namen |
| D | wago DB2 via `tools/gamedata.py`: SpellEffect, SpellName, SpellLevels, SkillLineAbility, CharBaseInfo, ChrRaces, UiMap | structuur en id's | Forever 1.60.1.70938 | teach-spells, levels, rassen, kaarten |
| WT | Wowhead Forever tooltip-JSON via `tools/gamedata.py` (npc, quest, item; ook `--locale`) | namen, spawns, objectives | opgehaald 17 nov 2026 | spawns, objective-teksten, namen per taal |
| WP | Wowhead Forever questpagina's via WebFetch: quest 1665, 1678, 1683, 1498, 1819, 94003, 1719, 1792, 8425, 1667, 1681, 1686; spell 8121, 71 | "You will learn / choose one of", series | opgehaald 17 nov 2026 | beloningen |
| H | `HandyNotes_ClassTrainers\Data.lua` (Forever) | trainer-coördinaten per UiMap | bestand op schijf | coördinaten trainers |
| IV | Icy Veins, "WoW Forever Warrior Class Quests Guide" (Abide), https://www.icy-veins.com/wow-forever/warrior-class-quests | beloningen in woorden | "Last Updated: Nov 4, 2026" | controle |
| CX | WoW Forever Codex, https://wowforevercodex.com/classes/warrior/quests | gevers, levels, beloningen | geen datum gezien | extra gevers, levels |
| FD | foreverdb.net/guide/leveling-warrior, wowclassicforever.info/classes/warrior/quests | "Taunt/Sunder/Intercept van de quest" | wowclassicforever: "Last reviewed: November 12, 2026"; foreverdb: geen datum | alleen controle |

Niet gebruikt: wowforever.kickegg.net (zei o.a. "Ironband compound in Loch Modan", terwijl Wowhead zelf "eastern Dun
Morogh" zegt; onbetrouwbaar, GEMETEN in WP 1681).

## 2. Wat levert wat

### 2.1 Spells (DB2, GEMETEN D SpellEffect Effect=36 "learn spell", build 70938)

| Teach-spell | Naam (SpellName) | Leert (index: spell) |
|---|---|---|
| 8121 | Path of Defense | 0: 71 Defensive Stance, 1: 7386 Sunder Armor, 2: 355 Taunt |
| 8616 | Path of the Berserker | 0: 2458 Berserker Stance, 1: 20252 Intercept |
| 1612 | Defensive Stance | 0: 71 (alleen) |
| 3196 | Taunt | 0: 355 (alleen) |

Positieve controle in dezelfde run: 5487 Bear Form gaf 5488 en 19179 terug. WP spell=8121 toont dezelfde drie effecten
(GEMETEN). Welke teach-spell een quest werpt staat niet in DB2 (serverdata).

SpellLevels (GEMETEN D): 71, 355, 7386 = level 10; 2458, 20252 = level 30; 1680 Whirlwind = 36 (controle 6673 = 1).

### 2.2 Beloning per quest (GEMETEN WP, 17 nov)

| Quest | Beloning op Wowhead Forever |
|---|---|
| 1665 Bartleby's Mug | You will learn: Defensive Stance (spell=71) |
| 1678 Vejrek | You will learn: Defensive Stance (71) |
| 1683 Vorlus Vilehoof | You will learn: Defensive Stance (71) |
| 1498 Path of Defense | You will learn: Defensive Stance (71) |
| 1819 Ulag the Cleaver | You will learn: Defensive Stance (71) |
| 94003 The Skybreaker Bulwark | You will learn: Defensive Stance (71); also receive: Stormforged Protector (item=275290) |
| 1719 The Affray | You will learn: Berserker Stance (2458) |
| 1792 Whirlwind Weapon | choose one: Whirlwind Axe 6975, Whirlwind Sword 6977, Whirlwind Warhammer 6976 |
| 8425 Voodoo Feathers | choose one: Diamond Flask 20130, Razorsteel Shoulders 20517, Fury Visor 20521 |
| 1667 Dead-tooth Jack | choose one: Haggard's Axe 6979, Hammer 6983, Dagger 6980, Sword 6985 |

- Dat de level-10-quests ook **Taunt en Sunder Armor** leren: AFGELEID (sterk). Wowhead toont bij 1665 alleen "Defensive
  Stance", terwijl teach-spell 8121 alle drie leert; IV ("Rewards – Defensive Stance, Taunt, and Sunder Armor", per ras),
  CX en FD zeggen alle drie (GEMETEN in die gidsen).
- Dat 1719 ook **Intercept** leert: AFGELEID (sterk). DB2 8616 leert 2458 + 20252; CX en worstguidesever.com (17 sep 2026)
  en FD zeggen Intercept; IV noemt alleen Berserker Stance.
- **Skyborne (94003)**: Wowhead toont Defensive Stance, net als bij 1665. Of Skyborne ook Taunt en Sunder Armor uit 94003
  krijgt, is **NIET GEMETEN**: IV noemt bij Skyborne alleen "Defensive Stance and Stormforged Protector" (bij de andere
  rassen wel alle drie), CX noemt alleen het schild. Zie Open.

### 2.3 Controle `ns.FOREVER_QUEST_FIRST` (Modules/ForeverTrainer.lua r. 36-37)

- 71, 355, 7386 (10) en 2458, 20252 (30) als quest-spell: **klopt**.
  - GEMETEN ZT: in de WARRIOR-tabel staan 71, 355, 7386, 2458, 20252 niet als trainerspell (positieve controle: 6673
    Battle Shout r. 215 en 100 Charge r. 218 wel gevonden met hetzelfde patroon). Wel staan er trainerspells die ze
    eisen: Sunder Armor rank 2 `req=7386` (r. 263), Intercept rank 2 `req=20252` (r. 317), Revenge `req=71` (r. 240),
    Shield Block/Disarm/Shield Wall `req=71` (r. 246, 249, 277), Berserker Rage/Whirlwind/Pummel `req=2458`
    (r. 285, 300, 304).
  - GEMETEN D en WP: zie 2.1 en 2.2.
- Niet in de lijst en ook geen quest-spell: Whirlwind 1680 (trainer, level 36, `req=2458`; GEMETEN ZT r. 300).

## 3. Rassen (GEMETEN D CharBaseInfo + ChrRaces, 70938)

Warrior (ClassID 1) kan: 1 Human, 2 Orc, 3 Dwarf, 4 NightElf, 5 Scourge (Undead), 6 Tauren, 7 Gnome, 8 Troll,
95 Skyborne (High Order, race bit 32) en 96 Skyborne (Windshaper, bit 33). Beide Skyborne hebben ClientFileString
"Skyborne". Dus **Skyborne kan warrior zijn**.

Wie mag welke quest (GEMETEN S, races-masker): de level-10-quests van Alliance (1638, 1679, 1684 enz.) hebben masker
4294967373 = alle Alliance-rassen + High Order Skyborne; Horde (1505, 1818 enz.) 8589934770 = alle Horde-rassen +
Windshaper Skyborne. 94003 heeft 12884901888 = alleen de twee Skyborne. 1718/1719/1791/8417: geen ras = iedereen.
Uitzondering: 1700 alleen Human (1), 1703 alleen Night Elf (8), 1704 alleen Dwarf+Gnome (68).
De indeling "ras X doet route Y" komt dus NIET uit een beperking maar uit Zygor (`|only if Human Warrior` enz.) en IV
(per ras). AFGELEID: kies per ras de route bij het startgebied, zoals Zygor.

## 4. Ketens

Kolommen: q = quest-id, gever, inleveraar, doelen. Gevers/inleveraars GEMETEN S (`ender`, of zonder `ender` = de gever)
en Z; extra gevers SL/CX. Objectives GEMETEN WT (tooltip-volgorde) en Z (`q <id>/<n>`).

### 4.1 Defensive Stance + Taunt + Sunder Armor, level 10, spell 71

**Human** (Zygor A r. 21880-21913):

| q | Naam | Gever | Inleveraar | Doel |
|---|---|---|---|---|
| 1638 | A Warrior's Training | Lyria Du Lac 913 (Elwynn); ook Ilsa Corbin 5480 (Stormwind) (SL r. 461-464, CX) | Harry Burlguard 6089 | praten |
| 1639 | Bartleby the Drunk | Harry Burlguard | Bartleby 6090 | praten |
| 1640 | Beat Bartleby | Bartleby | Bartleby | 1: "Beat Bartleby" (hij valt meteen aan, Z r. 21901) |
| 1665 | Bartleby's Mug | Bartleby | Harry Burlguard | geen objective (WT: geen Requirements; dat je de mok bij het aannemen krijgt = AFGELEID) → **leert de spells** |

**Dwarf en Gnome** (Z A r. 21914-21939):

| q | Naam | Gever | Inleveraar | Doel |
|---|---|---|---|---|
| 1679 | Muren Stormpike | Granis Swiftaxe 1229 (Dun Morogh, Kharanos) | Muren Stormpike 6114 (Ironforge, boven) | praten |
| 1678 | Vejrek | Muren Stormpike | Muren Stormpike | 1: Vejrek's Head (item 6799, drop van Vejrek 6113 in de hut, Dun Morogh) → **leert de spells** |

CX: 1678 "level 11, requires 10" (GEMETEN CX).

**Night Elf** (Z A r. 21940-21959):

| q | Naam | Gever | Inleveraar | Doel |
|---|---|---|---|---|
| 1684 | Elanaria | Kyra Windblade 3598 (Teldrassil, Dolanaar); SL noemt ook Moon Priestess Amara en Sentinel Elissa Starbreeze | Elanaria 4088 (Darnassus) | praten |
| 1683 | Vorlus Vilehoof | Elanaria | Elanaria | 1: Horn of Vorlus (item 6805, drop van Vorlus Vilehoof 6128, Teldrassil) → **leert de spells** |

**Orc en Troll** / **Tauren** (Z H r. 23272-23305; zelfde quest-id's, andere starter):

| q | Naam | Gever | Inleveraar | Doel |
|---|---|---|---|---|
| 1505 | Veteran Uzzek | Orc/Troll: Tarshaw Jaggedscar 3169 (Durotar, Razor Hill); Tauren: Krang Stonehoof 3063 (Mulgore, Bloodhoof); ook Sorek 3354 (Orgrimmar) (SL r. 1497-1501) | Uzzek 5810 (The Barrens, Far Watch Post) | praten |
| 1498 | Path of Defense | Uzzek | Uzzek | 1: 5 Singed Scale (item 6486) van Thunder Lizards 3130 (Durotar, Thunder Ridge) → **leert de spells** |

**Undead** (Z H r. 23322-23341):

| q | Naam | Gever | Inleveraar | Doel |
|---|---|---|---|---|
| 1818 | Speak with Dillinger | Austil de Mon 2131 (Tirisfal, Brill, binnen); CX noemt ook Baltus Fowler 4595 (Undercity) | Deathguard Dillinger 1496 | praten |
| 1819 | Ulag the Cleaver | Deathguard Dillinger | Deathguard Dillinger | 1: Ulag the Cleaver 6390 doden (Z: "click Doors" bij het mausoleum) → **leert de spells** |

**Skyborne**, beide facties (Z Common r. 1150-1153, 1346-1349, 1574-1577):

| q | Naam | Gever | Inleveraar | Doel |
|---|---|---|---|---|
| 94003 | The Skybreaker Bulwark | Seena Skybreaker 252377 (Zephras Isle, binnen) | Seena Skybreaker | 1: Skybreaker Bulwark (item 263993, drop van Zaal Stormshield 257196, Shrine of Akir) → Defensive Stance + schild Stormforged Protector 275290 |

Niet opgenomen: 92532 "The Warrior's Path" (Skyborne, level 2, Rorian the Dayseeker 251361 → Blademaster Ren 251964;
WT tooltip; geen beloning op CX) en de brieven op level 1 (3100, 3106, 3112, 3116, 2383, 3065, 3091, 3095 en de nieuwe
92479 "A Scribbled Letter", Human: Marshal McBride → Tordrin Stemblade 248415; GEMETEN S r. 4346, CX). Die leveren
alleen XP op (CX: "40 experience").

Zygor laat de routes elkaar uitsluiten (`'|complete completedq(1679)` bij de Human-stappen en omgekeerd, Z A r. 21885,
21893, 21918, 21925). AFGELEID: na één route ken je 71, dus de keten stopt toch (code: "spell known").

### 4.2 Berserker Stance + Intercept, level 30, spell 2458

| q | Naam | Gever | Inleveraar | Doel |
|---|---|---|---|---|
| 1718 | The Islander | warrior-trainer in een hoofdstad: Zygor Wu Shen 5479 (Stormwind) / Sorek 3354 (Orgrimmar); SL ook Torm Ragetotem 3041, Baltus Fowler 4595, Kelv Sternhammer 5113; CX ook Darnath Bladesinger 7315 | Klannoc Macleod 6236 (Fray Island, The Barrens) | praten |
| 1719 | The Affray | Klannoc Macleod | Klannoc Macleod | op het rooster stappen, zes Affray Challengers 6240, dan Big Will 6238 → **leert Berserker Stance (+ Intercept, AFGELEID)** |

Objective-volgorde 1719 is **tegenstrijdig**: WP: 1 "Big Will slain", 2 "Explore Zone", 3 "Step on the grate to begin
the Affray"; WT tooltip: Big Will / (leeg) / Step on the grate; Zygor: `1719/1` = rooster, `1719/2` = Big Will
(Z A r. 21982, 21992; H r. 23405, 23415). Advies: geen idx (zie 9). Rooster en Big Will staan op dezelfde plek.

### 4.3 Whirlwind-wapen (item), level 30 (eindgevecht level 40 elite)

Volgt op 1719 (S: 1791 `prev = 1719`). Zelfde voor beide facties.

| q | Naam | Gever | Inleveraar | Doel |
|---|---|---|---|---|
| 1791 | The Windwatcher | Klannoc Macleod | Bath'rah the Windwatcher 6176 (Alterac Mountains) | praten |
| 1712 | Cyclonian | Bath'rah | Bath'rah | 1: 8 Liferoot 3357 (kruid/AH), 2: 30 Bloodscalp Tusk 3901 (Stranglethorn), 3: Essence of the Exile 6851 |
| 1714 | Essence of the Exile | object Bath'rah's Cauldron 89931 (S `enderObject = 89931`) | de ketel | 8 Thundering Charm 4480, 8 Burning Charm 4479, 8 Cresting Charm 4481 (Arathi Highlands) → levert 6851 |
| 1713 | The Summoning | Bath'rah | Bath'rah | 1: Whirlwind Heart 6894 (drop van Cyclonian 6239, level 40 elite, na het oproepen) |
| 1792 | Whirlwind Weapon | Bath'rah | Bath'rah | kies Whirlwind Axe 6975 / Sword 6977 / Warhammer 6976 |

Level: CX "Cyclonian level 40, requires level 30"; IV "You can start this chain at Level 30"; Zygor pas bij `ding 38`
(GEMETEN). 1714 is een quest van een object, geen NPC: AFGELEID beter als doel binnen 1712 dan als eigen stap.

### 4.4 Wapenvervolg op level 10 (item, keuze uit 4 wapens)

GEMETEN S (prev/ender), WT (doelen), WP (beloningen 1667), CX (gevers, beloningsnamen). Zygor heeft alleen 1502-1503 en
1820-1821, de rest niet.

| Ras | q (volgorde) | Gevers → inleveraar | Doelen (WT) | Beloning (CX/WP) |
|---|---|---|---|---|
| Human | 1666 → 1667 | Harry Burlguard → Marshal Haggard 294 (Elwynn, Eastvale); 1667 Haggard → Haggard | 1667: Marshal Haggard's Badge 6782, Dead-tooth's Key 6783 ("in his camp to the south", WP) | Haggard's Axe/Hammer/Dagger/Sword |
| Dwarf/Gnome | 1680 → 1681 → 1682 | Muren → Tormus Deepforge 6031 (Ironforge); 1681, 1682 Tormus | 1681: Umbral Ore 6800 ("compound south of Helm's Bed Lake in eastern Dun Morogh", WP) | Umbral Axe/Mace/Dagger/Sword |
| Night Elf | 1686 → 1692 → 1693 | Elanaria; 1692 Elanaria → Mathiel 6142 (Darnassus); 1693 Mathiel | 1686: 8 Elunite Ore 6808 (wrak bij de vuurtoren van Auberdine, Darkshore, onder water, WP) + Elura's Medallion 6809 (Shade of Elura); 1692: Case of Elunite afgeven | Elunite Axe/Hammer/Dagger/Sword |
| Orc/Troll/Tauren | 1502 → 1503 | Uzzek → Thun'grim Firegaze 5878 (Barrens); 1503 Thun'grim | 1503: Forged Steel Bars 6534 uit de Stolen Iron Chest 58369 (Z H r. 23314-23315) | Thun'grim's Axe/Mace/Dagger/Sword |
| Undead | 1820 → 1821 → 1822 | Dillinger → Coleman Farthing 1500 (Brill); 1821, 1822 Coleman | 1821: Agamand Family Axe 7567, Dagger 7568, Mace 7569, Sword 7566 (vier wapenrekken in de crypte, Z H r. 23350-23378) | Heirloom Axe/Hammer/Dagger/Sword |

### 4.5 Pantser op level 20 (item)

Alliance (S r. 1407-1420, 1437; gevers SL r. 2245-2248):
1698 Yorus Barleybrew (gever Wu Shen of Darnath Bladesinger → Yorus Barleybrew 6166, Redridge) → 1699 The Rethban Gauntlet
(Yorus; WT: "Enter the Rethban Caverns, reach the first fork, and return ... within the time allowed") → 1702 The
Shieldsmith (Yorus → Furen Longbeard 5413, Stormwind; schild Furen's Favor, CX) → 1701 Fire Hardened Mail (Furen; 50
Scorched Spider Fang, 12 Charred Horn, Galvanized Horn, Vial of Phlogiston; WT) → 1782 Furen's Armor (Furen; Fire
Hardened Hauberk, CX). Vervolg per ras (S races): Human 1700 → 1705 → 1706 (Grimand Elmore 1416, Stormwind; 20 Burning
Blood + Burning Rock); Night Elf 1703 → 1710 → 1711 (Mathiel; 20 Sunscorched Shell); Dwarf/Gnome 1704 → 1708 → 1709
(Klockmort Spannerspan 6169, Ironforge; 20 Searing Coral).

Horde (S r. 1466-1479; gevers SL r. 1428-1432: Torm Ragetotem, Sorek, Baltus Fowler):
1823 Speak with Ruga (→ Ruga Ragetotem 6394, Camp Taurajo) → 1824 Trial at the Field of Giants (Ruga; 5 Twitching
Antenna, verlopen na 15 min volgens IV; schild Ruga's Bulwark, CX) → 1825 Speak with Thun'grim (→ Thun'grim) → 1838
Brutal Armor (Thun'grim; 15 Smoky Iron Ingot, 10 Powdered Azurite, 10 Iron Bar, Vial of Phlogiston) → 1848 Brutal
Hauberk (Thun'grim). Vervolg (alle Horde-rassen): 1839 → 1842 → 1843 (Ula'elek 6408, Sen'jin; 7 Uncloven Satyr Hoof),
1840 → 1844 → 1845 (Orm Stonehoof 6410, Thunder Bluff; Galvanized Horn), 1841 → 1846 → 1847 (Velora Nitely 6411,
Undercity; 8 Sturdy Dragonmaw Shinbone).

Plekken van de materialen: niet gemeten (geen Zygor-stappen, geen coördinaten in WT/WP). Vial of Phlogiston komt uit
Razorfen Kraul (IV). Deze ketens zijn dus nog **niet bouwbaar met pijl naar de doelen**, wel met pijl naar de NPC's.

### 4.6 Fallen Hero / Voodoo Feathers (item), level 50-52

| q | Naam | Gever | Inleveraar | Doel (WT + Z) |
|---|---|---|---|---|
| 8417 | A Troubled Spirit | trainer: Zygor Wu Shen / Sorek; SL ook Christoph Walker 4593, Kelv Sternhammer, Darnath Bladesinger; CX ook Torm Ragetotem | Fallen Hero of the Horde 7572 (Swamp of Sorrows) | praten |
| 8423 | Warrior Kinship | Fallen Hero | Fallen Hero | 1: 7 Helboar 5993 (Blasted Lands) |
| 8424 | War on the Shadowsworn | Fallen Hero | Fallen Hero | 1: 20 Shadowsworn Adept 6006, 2: 10 Shadowsworn Cultist 6004, 3: 20 Shadowsworn Thug 6005 (Blasted Lands) |
| 8425 | Voodoo Feathers | Fallen Hero | Fallen Hero | 1: 2 Amber 20606, 2: 2 Blue 20607, 3: 2 Green Voodoo Feather 20608 (Sunken Temple, dungeon, groep nodig) |

Level: CX 8417 level 50, 8423-8425 "requires level 50"; Zygor `ding 52` (GEMETEN).

### 4.7 Niet opgenomen

Dungeon- en raidquests met `classes = 1` in S (ZG 8041-8079/8184, AQ 8544-8562, Naxx 9034-9042, T0.5 8912/8920/8937/
8944/8959/9006/9013/9022, Codex of Defense): geen leveling-ketens; CX noemt ze. Niet uitgezocht.

## 5. Plekken (UiMap GEMETEN D UiMap 70938)

UiMap: Elwynn 1429, Stormwind City 1453, Dun Morogh 1426, Ironforge 1455, Teldrassil 1438, Darnassus 1457, Durotar 1411,
Mulgore 1412, Orgrimmar 1454, The Barrens 1413, Tirisfal Glades 1420, Undercity 1458, Thunder Bluff 1456, Zephras Isle
2521, Alterac Mountains 1416, Arathi Highlands 1417, Stranglethorn Vale 1434, Blasted Lands 1419, Swamp of Sorrows 1435,
Redridge Mountains 1433, Hillsbrad 1424, Wetlands 1437, Stonetalon 1442.

Regel: trainers uit H, anders Z, anders WT-spawn. WT-spawns staan in Wowhead's zone-ruimte; dat die gelijk is aan UiMap
is AFGELEID (bij Lyria, Kyra, Muren, Seena, Klannoc enz. valt WT samen met H of Z). Stormwind en Redridge hebben in WT
TWEE sets spawns: de set die met Z/H klopt is gebruikt (Stormwind: Wu Shen 80.6,59.6 ≈ H 80.70,59.95; Grimand Elmore WT
59.6,34 ≈ Z 59.72,33.78; Redridge: Magistrate Solomon WT 24.6-24.8 ≈ Z 24.90,44.45, dus Yorus 21.4,44.7).

| Sleutel | NPC (id) | m | x | y | Bron |
|---|---|---|---|---|---|
| lyria | Lyria Du Lac (913) | 1429 | 41.10 | 65.63 | H (Z 41.09,65.77; WT 41,65.8) |
| ilsa | Ilsa Corbin (5480) | 1453 | 80.26 | 59.72 | H |
| harry | Harry Burlguard (6089) | 1453 | 77.13 | 53.27 | Z (WT 77,53.2) |
| bartleby | Bartleby (6090) | 1453 | 76.80 | 53.20 | Z, loopt rond (WT 76.5,52.6) |
| haggard | Marshal Haggard (294) | 1429 | 84.6 | 69.4 | WT (CX 84.6,69.4) |
| granis | Granis Swiftaxe (1229) | 1426 | 47.24 | 52.78 | H (Z 47.36,52.65) |
| muren | Muren Stormpike (6114) | 1455 | 70.78 | 90.27 | Z |
| tormus | Tormus Deepforge (6031) | 1455 | 48.6 | 43.0 | WT (CX 48.6,42.5) |
| kyra | Kyra Windblade (3598) | 1438 | 56.21 | 59.19 | H (Z 56.22,59.19) |
| elanaria | Elanaria (4088) | 1457 | 57.29 | 34.61 | Z |
| mathiel | Mathiel (6142) | 1457 | 59.2 | 45.5 | WT (CX 59.5,45.4) |
| tarshaw | Tarshaw Jaggedscar (3169) | 1411 | 54.09 | 42.39 | H (Z 54.19,42.46) |
| krang | Krang Stonehoof (3063) | 1412 | 48.35 | 63.74 | H (Z 48.34,63.76) |
| uzzek | Uzzek (5810) | 1413 | 61.38 | 21.11 | Z |
| thungrim | Thun'grim Firegaze (5878) | 1413 | 57.23 | 30.34 | Z |
| austil | Austil de Mon (2131) | 1420 | 61.87 | 52.85 | H (Z 61.85,52.54) |
| dillinger | Deathguard Dillinger (1496) | 1420 | 58.20 | 51.45 | Z |
| coleman | Coleman Farthing (1500) | 1420 | 61.72 | 52.29 | Z |
| seena | Seena Skybreaker (252377) | 2521 | 59.91 | 73.08 | H (Z 59.89,72.86) |
| wushen | Wu Shen (5479) | 1453 | 80.70 | 59.95 | H (Z 80.55,59.87) |
| sorek | Sorek (3354) | 1454 | 80.39 | 32.38 | H (Z 80.38,32.38) |
| kelv | Kelv Sternhammer (5113) | 1455 | 70.34 | 90.65 | H |
| darnath | Darnath Bladesinger (7315) | 1457 | 58.94 | 35.35 | H |
| torm | Torm Ragetotem (3041) | 1456 | 57.24 | 87.37 | H |
| baltus | Baltus Fowler (4595) | 1458 | 47.40 | 17.29 | H |
| christoph | Christoph Walker (4593) | 1458 | 46.93 | 15.23 | H |
| klannoc | Klannoc Macleod (6236) | 1413 | 68.62 | 49.17 | Z (WT 68.6,49) |
| bathrah | Bath'rah the Windwatcher (6176) | 1416 | 80.50 | 66.92 | Z (WT 80.4,66.8) |
| fallenHero | Fallen Hero of the Horde (7572) | 1435 | 34.29 | 66.15 | Z (WT 34.2,65.4-66) |
| yorus | Yorus Barleybrew (6166) | 1433 | 21.4 | 44.7 | WT (set AFGELEID, zie boven) |
| furen | Furen Longbeard (5413) | 1453 | 64.60 | 37.22 | Z Common r. 1978 |
| grimand | Grimand Elmore (1416) | 1453 | 59.72 | 33.78 | Z A r. 1213 |
| klockmort | Klockmort Spannerspan (6169) | 1455 | 68.6 | 46.6 | WT |
| ruga | Ruga Ragetotem (6394) | 1413 | 44.6 | 59.4 | WT |
| ulaelek | Ula'elek (6408) | 1411 | 56.2 | 74.5 | WT |
| orm | Orm Stonehoof (6410) | 1456 | 39.0 | 56.2 | WT, loopt rond (38.4-39.6, 55.4-57.2) |
| velora | Velora Nitely (6411) | 1458 | 62.6 | 39.5 | WT |

Doelplekken (geen NPC), alle Z tenzij anders:

| Sleutel | Wat | m | x | y | Bron |
|---|---|---|---|---|---|
| vejrek | Vejrek in de hut | 1426 | 27.83 | 57.95 | Z A r. 21931 (WT 27.2-27.8,57.4-57.8) |
| vorlus | Vorlus Vilehoof | 1438 | 47.26 | 63.52 | Z A r. 21954 (WT 47.2-47.6,63.4-64) |
| lizards | Thunder Lizards | 1411 | 39.27 | 28.29 | Z H r. 23297 |
| ulag | Ulag (deuren mausoleum) | 1420 | 59.64 | 48.09 | Z H r. 23335 |
| zaal | Zaal Stormshield | 2521 | 56.61 | 50.37 | Z Common r. 1348 (WT 56.4-56.6,50.3-50.5) |
| steelChest | Stolen Iron Chest | 1413 | 55.05 | 26.66 | Z H r. 23315 |
| agCrypt | ingang crypte Agamand | 1420 | 52.25 | 26.86 | Z H r. 23351 |
| agMace / agDagger / agAxe / agSword | wapenrekken | 1420 | 52.66/51.89/51.70/52.65 | 27.04/27.12/25.69/25.86 | Z H r. 23357-23375 |
| grate | rooster Fray Island | 1413 | 68.61 | 48.72 | Z A r. 21982 |
| tusks | Bloodscalp-trollen | 1434 | 25.85 | 11.25 | Z A r. 22031 |
| charmBurning | Burning Exile | 1417 | 26.60 | 31.80 | Z A r. 22019 |
| charmThundering | Thundering Exile | 1417 | 52.60 | 52.20 | Z A r. 22023 |
| charmCresting | Cresting Exile | 1417 | 68.00 | 30.00 | Z A r. 22027 |
| cauldron | Bath'rah's Cauldron (object 89931) | 1416 | 79.31 | 66.81 | Z A r. 22035 |
| cyclonian | oproepplek Cyclonian | 1416 | 80.57 | 62.56 | Z A r. 22056 |
| helboar | Helboar | 1419 | 51.34 | 53.45 | Z A r. 22077 |
| shadowsworn | Shadowsworn-kamp | 1419 | 65.17 | 32.83 | Z A r. 22087 |
| sunken | ingang Sunken Temple (bestaat al als `P.sunken`) | 1435 | 69.36 | 56.89 | Z A r. 22114 |

Niet gevonden (geen bron met coördinaten): kamp van Dead-tooth Jack (1667), Umbral Ore in Ironband's Compound (1681),
Elunite-kratten en Shade of Elura (1686), Rethban Caverns (1699), alle materialen van 4.5.

## 6. Objective-index

`O(place, textKey, idx, items)`: met `items` telt "één ervan in de tas"; met `idx` de client-objective. Dat de
tooltip-volgorde gelijk is aan de client-index: AFGELEID (zoals bij de druid).

| q | WT-volgorde | Zygor | Advies |
|---|---|---|---|
| 1640 | 1 Beat Bartleby | (geen nummer) | idx 1 |
| 1678 | 1 Vejrek's Head | 1678/1 | items {6799} (of idx 1) |
| 1683 | 1 Horn of Vorlus | 1683/1 | items {6805} |
| 1498 | 1 Singed Scale x5 | 1498/1 | idx 1 (aantal telt) |
| 1819 | 1 Ulag the Cleaver | 1819/1 | idx 1 |
| 94003 | 1 Skybreaker Bulwark | 94003/1 | items {263993} |
| 1719 | 1 Big Will, 2 (Explore Zone), 3 grate | 1 grate, 2 Big Will | **geen idx**: één doel op `grate`; klaar = quest compleet → Klannoc |
| 1503 | 1 Forged Steel Bars | 1503/1 | items {6534} |
| 1821 | Axe, Dagger, Mace, Sword | Axe /1, Dagger /2, Mace /3, Sword **/1** | items per wapen: {7567}, {7568}, {7569}, {7566} |
| 1712 | 1 Liferoot x8, 2 Bloodscalp Tusk x30, 3 Essence of the Exile | 1712/2 tusk, 1712/3 essence | idx 1, 2, 3 |
| 1714 | Thundering, Burning, Cresting x8 | (geen nummer) | binnen 1712 als items {charm, 6851} (één charm telt al als klaar: beperking) |
| 1713 | 1 Whirlwind Heart | 1713/1 | items {6894} |
| 8423 | 1 Helboar x7 | 8423/1 | idx 1 |
| 8424 | 1 Adept x20, 2 Cultist x10, 3 Thug x20 | /1, /2, /3 | idx 1, 2, 3 |
| 8425 | 1 Amber, 2 Blue, 3 Green x2 | /1, /2, /3 | idx 1, 2, 3 |
| 1667 | Badge 6782, Key 6783 | - | items {6782} (plek onbekend) |
| 1681 | Umbral Ore 6800 | - | items {6800} (plek onbekend) |
| 1686 | Elunite Ore 6808 x8, Elura's Medallion 6809 | - | idx 1 / items {6809} (plek onbekend) |

Item-id's GEMETEN WT item-tooltips (6799, 6805, 6486, 6534, 7566-7569, 263993, 3357, 3901, 6851, 4479-4481, 6894,
20606-20608) en Z; 6782/6783/6800/6808/6809 GEMETEN WP.

## 7. NPC-namen per taal (GEMETEN WT `--locale`, 17 nov; tweede bron SN)

Controle npc 233: deDE "Bauer Saldean", frFR "Saldean le fermier", esES "Granjero Saldean", esMX "Granjero Saldean"
(= SN esMX r. 16), ptBR "Fazendeiro Saldanha", ruRU "Фермер Сальден". Een naam tussen [haken] = Wowhead heeft hem niet
in die taal: weggelaten. enUS/nlNL/itIT = Engels (zoals de module).

| id | enUS | deDE | frFR | esES | esMX | ptBR | ruRU |
|---|---|---|---|---|---|---|---|
| 913 | Lyria Du Lac | Lyria Du Lac | Lyria Du Lac | Lyria Du Lac | Lyria Du Lac | Lyria Du Lac | Лирия дю Лак |
| 5480 | Ilsa Corbin | Ilsa Corbin | Ilsa Corbin | Ilsa Corbin | Ilsa Corbin | Ilsa Cletes | Ильса Корбин |
| 6089 | Harry Burlguard | Harry Burlguard | Harry Burlguard | Harry Burlguard | Harry Burlguard | Ari Barbotina | Гарри Берлгард |
| 6090 | Bartleby | Bartleby | Bartleby | Bartleby | Bartleby | Bartolino | Бартлби |
| 294 | Marshal Haggard | Marshal Haggard | Maréchal Haggard | Alguacil Haggard | Mariscal Haggard | Delegado Fadigas | Маршал Хаггард |
| 1229 | Granis Swiftaxe | Granis Swiftaxe | Granis Swiftaxe | Granis Hachaveloz | Granis Hachaveloz | Granis Celeraxa | Гранис Быстрый Топор |
| 6114 | Muren Stormpike | Muren Stormpike | Muren Foudrepique | Muren Pico Tormenta | Muren Pico Tormenta | Muren Lançatroz | Марен Грозовая Вершина |
| 6031 | Tormus Deepforge | Tormus Deepforge | Tormus Deepforge | Tormus Forjahonda | Tormus Forjahonda | Tormus Baixaforja | Тормус Подземная Кузня |
| 3598 | Kyra Windblade | Kyra Windblade | Kyra Windblade | Kyra Espada del Viento | Kyra Espada del Viento | Kyra Laminéola | Кайра Ветрорез |
| 4088 | Elanaria | Elanaria | Elanaria | Elanaria | Elanaria | Elanaria | Эланария |
| 6142 | Mathiel | Mathiel | Mathiel | Mathiel | Mathiel | Mathiel | Матиль |
| 3169 | Tarshaw Jaggedscar | Tarshaw Jaggedscar | Tarshaw Jaggedscar | Tarshaw Marcauna | Tarshaw Marcauna | Tarshaw Zigatriz | Таршо Рваный Шрам |
| 3063 | Krang Stonehoof | Krang Stonehoof | Krang Stonehoof | Krang Pezuñapétrea | Krang Pezuña Pétrea | Krang Casco de Pedra | Кранг Каменное Копыто |
| 3354 | Sorek | Sorek | Sorek | Sorek | Sorek | Sorek | Сорек |
| 5810 | Uzzek | Uzzek | Uzzek | Uzzek | Uzzek | Uzzek | Уззек |
| 5878 | Thun'grim Firegaze | Thun'grim Firegaze | Thun'grim Firegaze | Thun'grim Vistafuego | Thun'grim Vistafuego | Thun'grim Olhafogo | Тун'грим Огневзор |
| 2131 | Austil de Mon | Austil de Mon | Austil de Mon | Austil de Mon | Austil de Mon | Austil de Mon | Остил де Мон |
| 1496 | Deathguard Dillinger | Todeswache Dillinger | Garde noir Dillinger | Guardia de la Muerte Dillinger | Guardia de la Muerte Dillinger | Necroguarda Dinis | Страж смерти Диллинжер |
| 1500 | Coleman Farthing | Coleman Farthing | Coleman Farthing | Coleman Lontananza | Coleman Farthing | Eurico Palhares | Колман Фартинг |
| 252377 | Seena Skybreaker | Seena Skybreaker | Seena Briseciel | Seena Rompecielos | Seena Rompecielos | Seena Rompe-céus | Сиина Небовержица |
| 5479 | Wu Shen | Wu Shen | Wu Shen | Wu Shen | Wu Shen | Wu Shen | Ву Шен |
| 5113 | Kelv Sternhammer | Kelv Sternhammer | Kelv Sternhammer | Kelv Martillodusto | Kelv Martillo Severo | Kelv Severomalho | Кельв Суровый Молот |
| 7315 | Darnath Bladesinger | Darnath Bladesinger | Darnath Bladesinger | Darnath Rugefilo | Darnath Rugefilo | Darnath Cantalâmina | Дарнат Певец Клинка |
| 3041 | Torm Ragetotem | Torm Ragetotem | Torm Ragetotem | Torm Furiatótem | Torm Tótem de Ira | Torm Totem da Fúria | Торм Тотем Гнева |
| 4595 | Baltus Fowler | Baltus Fowler | Baltus Fowler | Baltus Avez | Baltus Fowler | Dalto Flores | Балтус Птицелов |
| 4593 | Christoph Walker | Christoph Walker | Christoph Walker | Christof Camino | Christoph Walker | Cristovão Ribeiro | Кристоф Уокер |
| 6236 | Klannoc Macleod | Klannoc Macleod | Klannoc Macleod | Klannoc Macleod | (niet gemeten) | Klannoc Macleod | Кланнок Маклеод |
| 6176 | Bath'rah the Windwatcher | Bath'rah der Windbehüter | Bath'rah la Vigie des vents | Bath'rah el Cazavientos | Bath'rah el Vigía del viento (SN; WT [haken]) | Bath'rah, o Vigia dos Ventos | Бат'ра Ветростраж |
| 7572 | Fallen Hero of the Horde | Gefallener Held der Horde | Héros déchu de la Horde | Héroe caído de la Horda | Héroe caído de la Horda (SN; WT [haken]) | Herói Caído da Horda | Павший герой Орды |
| 6166 | Yorus Barleybrew | Yorus Gerstenbräu | Yorus Barleybrew | Yorus Cebadiz | Yorus Cebadiz | Yorus Cervevada | Йорус Ячменовар |
| 5413 | Furen Longbeard | Furen Longbeard | Furen Longbeard | Furen Barbalarga | Furen Barbalarga | Furen Barbalonga | Фьюрен Длиннобород |
| 1416 | Grimand Elmore | Grimand Elmore | Grimand Elmore | Grimand Elmore | Grimand Elmore | Grimand Elmore | Гриманд Элмор |
| 6169 | Klockmort Spannerspan | Klockmort Spannerspan | Klockmort Spannerspan | Klockmort Palmalicate | Klockmort Palmalicate | Cronomorfus Espanafuso | Клацморт Гайкокрут |
| 6394 | Ruga Ragetotem | Ruga Ragetotem | Ruga Ragetotem | Ruga Furiatótem | Ruga Tótem de Ira | Ruga Totem da Fúria | Руга Тотем Гнева |
| 6408 | Ula'elek | Ula'elek | Ula'elek | Ula'elek | Ula'elek | Ula'elek | Ула'елек |
| 6410 | Orm Stonehoof | Orm Stonehoof | Orm Stonehoof | Orm Pezuñapétrea | Orm Pezuña Pétrea | Orm Casco de Pedra | Орм Каменное Копыто |
| 6411 | Velora Nitely | Velora Nitely | Velora Nitely | Velora Noctis | Velora Noctis | Velora Noitile | Велора Нители |

Tweede bron (SN), overeenstemming GEMETEN: 294 esMX, 1496 esMX, 3063 esMX, 5878 esMX, 6031 esMX, 6114 esES/esMX/ptBR/ruRU,
6176 deDE/frFR/esES/ptBR/ruRU, 7572 deDE/frFR/esES/esMX/ptBR/ruRU, 1500 esES/ptBR/ruRU, 4595 esES/ptBR/ruRU, 6089
ptBR/ruRU, 5810 ruRU: allemaal gelijk aan WT. Let op: esMX 4595/1500/4593 zijn bij WT Engels zonder haken terwijl
esES ze vertaalt; SN esMX heeft ze niet. Dus esMX voor die drie = alleen WT.

Doelwitten (voor de objective-teksten), WT: 6113 Vejrek: de/fr/es/pt Vejrek, ru Веджрек, esMX [haken].
6128 Vorlus Vilehoof: de Vorlus Elendshuf, fr Vorlus Vilehoof, es Vorlus Pezuñavil, pt Vorlus Cascruel, ru Ворлус
Подлое Копыто, esMX [haken]. 6390 Ulag the Cleaver: de Ulag der Spalter, fr Ulag le Fendeur, es Ulag el Cuchillero,
esMX Ulag el Cuchilla, pt Ulag, o Cutelo, ru Улаг Колун. 257196 Zaal Stormshield: de Zaal Stormshield, fr Zaal
Pare-tempête, es Zaal Escudo de Tormenta, ru Заал Щит Бури, esMX en ptBR [haken]. 6238 Big Will: de Big Will, fr Grand
Will, es Will el Grande, pt Grande Gui, ru Большой Билл, esMX [haken]. 6239 Cyclonian: de Cyclonian, fr Cyclonien, es
Ciclonio, pt Ciclonium, ru Циклониан, esMX [haken]. 3130 Thunder Lizard: de Donnerechse, fr Lézard-tonnerre, es/esMX
Truenagarto, pt Lagarto Trovejante, ru Рокочущая ящерица. Itemnamen per taal: niet gemeten.

## 8. Fouten in Zygor (GEMETEN in de Zygor-bestanden)

1. **1821 Agamand Heirlooms**: het zwaard heeft hetzelfde objective-nummer als de bijl:
   `collect Agamand Family Sword##7566 |q 1821/1` (Horde r. 23375) en `collect Agamand Family Axe##7567 |q 1821/1`
   (r. 23369). WT-volgorde is Axe, Dagger, Mace, Sword, dus het zwaard is waarschijnlijk 4 (AFGELEID).
2. **1719 The Affray**: Zygor `1719/1` = rooster, `1719/2` = Big Will (A r. 21982/21992, H r. 23405/23415); Wowhead
   (pagina en tooltip) zet Big Will eerst en het rooster op 3. Een van beide is fout; welke = niet gemeten.
3. **Alliance-gids, Sunken Temple-stappen**: `Click Here to Continue |confirm |q 9053` (A r. 22111) en `|q 9053 |future`
   (A r. 22123). 9053 is de druid-quest van Torwa Pathfinder (zie CHAINS.DRUID Torwa); bedoeld is 8425 (de Horde-gids
   zegt `|q 8425`, H r. 23532/23544). Kopieerfout.
4. Gat, geen fout: Zygor stopt de Undead-keten bij 1821 en neemt 1822 "Heirloom Weapon" (de wapenkeuze) niet aan; ook
   1666/1667, 1680-1682, 1686/1692/1693 en de level-20-pantserketens ontbreken. GEMETEN: grep op die id's in de
   Zygor-levelinggidsen vond 1820, 1821, 1502, 1503 wel en 1822 niet (zelfde zoekopdracht = positieve controle).

## 9. Lua-schets (voorstel; de bouwchat beslist)

Vorm zoals WL_P en CHAINS.WARLOCK. `faction` is verplicht (MyChains vergelijkt `c.faction == faction`, r. 646), dus
gedeelde ketens twee keer (A en H), zoals Torwa. `P.sunken` en `SKYBORNE` bestaan al in het bestand; `ORCTROLL` en `UD`
ook (warlock-blok). Nieuwe textKeys `FCQ_OBJ_WR_*` en `FCQ_CHAIN_WR_*` moeten in de locales.

```lua
--[[ Warrior (17 Nov 2026). All facts: docs/forever/WARRIOR_CLASSQUESTS_2026-11-17.md (mh-research): Zygor Forever
	"Warrior Class Quests", Spoken, wago DB2 1.60.1.70938 (teach spells 8121 = 71+7386+355, 8616 = 2458+20252),
	Wowhead Forever. Coordinates: HandyNotes for trainers, else Zygor, else Wowhead spawns.
	AFGELEID: Taunt/Sunder from the level 10 quests and Intercept from 1719 (Wowhead shows only the first spell);
	Skyborne 94003 = Defensive Stance GEMETEN, Taunt/Sunder for Skyborne NOT measured. 1719 has no idx on purpose
	(Wowhead and Zygor disagree). ]]
local WR_P = {
	lyria = { npc = "Lyria Du Lac", id = 913, m = 1429, x = 41.10, y = 65.63 },
	harry = { npc = "Harry Burlguard", id = 6089, m = 1453, x = 77.13, y = 53.27 },
	bartleby = { npc = "Bartleby", id = 6090, m = 1453, x = 76.80, y = 53.20 },
	granis = { npc = "Granis Swiftaxe", id = 1229, m = 1426, x = 47.24, y = 52.78 },
	muren = { npc = "Muren Stormpike", id = 6114, m = 1455, x = 70.78, y = 90.27 },
	kyra = { npc = "Kyra Windblade", id = 3598, m = 1438, x = 56.21, y = 59.19 },
	elanaria = { npc = "Elanaria", id = 4088, m = 1457, x = 57.29, y = 34.61 },
	tarshaw = { npc = "Tarshaw Jaggedscar", id = 3169, m = 1411, x = 54.09, y = 42.39 },
	krang = { npc = "Krang Stonehoof", id = 3063, m = 1412, x = 48.35, y = 63.74 },
	uzzek = { npc = "Uzzek", id = 5810, m = 1413, x = 61.38, y = 21.11 },
	austil = { npc = "Austil de Mon", id = 2131, m = 1420, x = 61.87, y = 52.85 },
	dillinger = { npc = "Deathguard Dillinger", id = 1496, m = 1420, x = 58.20, y = 51.45 },
	seena = { npc = "Seena Skybreaker", id = 252377, m = 2521, x = 59.91, y = 73.08 },
	wushen = { npc = "Wu Shen", id = 5479, m = 1453, x = 80.70, y = 59.95 },
	sorek = { npc = "Sorek", id = 3354, m = 1454, x = 80.39, y = 32.38 },
	klannoc = { npc = "Klannoc Macleod", id = 6236, m = 1413, x = 68.62, y = 49.17 },
	bathrah = { npc = "Bath'rah the Windwatcher", id = 6176, m = 1416, x = 80.50, y = 66.92 },
	fallenHero = { npc = "Fallen Hero of the Horde", id = 7572, m = 1435, x = 34.29, y = 66.15 },
	-- Objective places (no NPC), Zygor.
	vejrek = { m = 1426, x = 27.83, y = 57.95 },
	vorlus = { m = 1438, x = 47.26, y = 63.52 },
	lizards = { m = 1411, x = 39.27, y = 28.29 },
	ulag = { m = 1420, x = 59.64, y = 48.09 },
	zaal = { m = 2521, x = 56.61, y = 50.37 },
	grate = { m = 1413, x = 68.61, y = 48.72 },
	tusks = { m = 1434, x = 25.85, y = 11.25 },
	charmBurning = { m = 1417, x = 26.60, y = 31.80 },
	charmThundering = { m = 1417, x = 52.60, y = 52.20 },
	charmCresting = { m = 1417, x = 68.00, y = 30.00 },
	cauldron = { m = 1416, x = 79.31, y = 66.81 },
	cyclonian = { m = 1416, x = 80.57, y = 62.56 },
	helboar = { m = 1419, x = 51.34, y = 53.45 },
	shadowsworn = { m = 1419, x = 65.17, y = 32.83 },
}
local R = WR_P
local HUMAN_WR, DWGN, NELF, TAUREN = { Human = true }, { Dwarf = true, Gnome = true }, { NightElf = true }, { Tauren = true }

local function WrDefense(faction, races, quests)
	return { key = "defensive", spell = 71, level = 10, faction = faction, races = races, quests = quests }
end
local function WrUzzek(races, starter)
	return WrDefense("Horde", races, {
		{ q = 1505, from = starter, to = R.uzzek },
		{ q = 1498, from = R.uzzek, objs = { O(R.lizards, "FCQ_OBJ_WR_SCALES", 1) }, to = R.uzzek },
	})
end

CHAINS.WARRIOR = {
	WrDefense("Alliance", HUMAN_WR, {
		{ q = 1638, from = R.lyria, to = R.harry },
		{ q = 1639, from = R.harry, to = R.bartleby },
		{ q = 1640, from = R.bartleby, objs = { O(R.bartleby, "FCQ_OBJ_WR_BEATBARTLEBY", 1) }, to = R.bartleby },
		{ q = 1665, from = R.bartleby, to = R.harry },
	}),
	WrDefense("Alliance", DWGN, {
		{ q = 1679, from = R.granis, to = R.muren },
		{ q = 1678, from = R.muren, objs = { O(R.vejrek, "FCQ_OBJ_WR_VEJREK", nil, { 6799 }) }, to = R.muren },
	}),
	WrDefense("Alliance", NELF, {
		{ q = 1684, from = R.kyra, to = R.elanaria },
		{ q = 1683, from = R.elanaria, objs = { O(R.vorlus, "FCQ_OBJ_WR_VORLUS", nil, { 6805 }) }, to = R.elanaria },
	}),
	WrUzzek(ORCTROLL, R.tarshaw),
	WrUzzek(TAUREN, R.krang),
	WrDefense("Horde", UD, {
		{ q = 1818, from = R.austil, to = R.dillinger },
		{ q = 1819, from = R.dillinger, objs = { O(R.ulag, "FCQ_OBJ_WR_ULAG", 1) }, to = R.dillinger },
	}),
}
for _, faction in ipairs({ "Alliance", "Horde" }) do
	local trainer = faction == "Alliance" and R.wushen or R.sorek
	table.insert(CHAINS.WARRIOR, WrDefense(faction, SKYBORNE, {
		{ q = 94003, from = R.seena, objs = { O(R.zaal, "FCQ_OBJ_WR_ZAAL", nil, { 263993 }) }, to = R.seena },
	}))
	table.insert(CHAINS.WARRIOR, { key = "berserker", spell = 2458, level = 30, faction = faction, quests = {
		{ q = 1718, from = trainer, to = R.klannoc },
		{ q = 1719, from = R.klannoc, objs = { O(R.grate, "FCQ_OBJ_WR_AFFRAY") }, to = R.klannoc },
	} })
	-- Item chain: needs 1719 done first (Spoken prev). Cyclonian is a level 40 elite.
	table.insert(CHAINS.WARRIOR, { key = "whirlwind", nameKey = "FCQ_CHAIN_WR_WHIRLWIND", level = 30, faction = faction,
		quests = {
			{ q = 1791, from = R.klannoc, to = R.bathrah },
			{ q = 1712, from = R.bathrah, objs = {
				O(nil, "FCQ_OBJ_WR_LIFEROOT", 1),
				O(R.tusks, "FCQ_OBJ_WR_TUSKS", 2),
				O(R.charmBurning, "FCQ_OBJ_WR_CHARM_BURNING", nil, { 4479, 6851 }),
				O(R.charmThundering, "FCQ_OBJ_WR_CHARM_THUNDERING", nil, { 4480, 6851 }),
				O(R.charmCresting, "FCQ_OBJ_WR_CHARM_CRESTING", nil, { 4481, 6851 }),
				O(R.cauldron, "FCQ_OBJ_WR_ESSENCE", 3),
			}, to = R.bathrah },
			{ q = 1713, from = R.bathrah, objs = { O(R.cyclonian, "FCQ_OBJ_WR_CYCLONIAN", nil, { 6894 }) }, to = R.bathrah },
			{ q = 1792, from = R.bathrah, to = R.bathrah },
		} })
	table.insert(CHAINS.WARRIOR, { key = "fallenhero", nameKey = "FCQ_CHAIN_WR_FALLENHERO", level = 50, faction = faction,
		quests = {
			{ q = 8417, from = trainer, to = R.fallenHero },
			{ q = 8423, from = R.fallenHero, objs = { O(R.helboar, "FCQ_OBJ_WR_HELBOAR", 1) }, to = R.fallenHero },
			{ q = 8424, from = R.fallenHero, objs = {
				O(R.shadowsworn, "FCQ_OBJ_WR_ADEPT", 1),
				O(R.shadowsworn, "FCQ_OBJ_WR_CULTIST", 2),
				O(R.shadowsworn, "FCQ_OBJ_WR_THUG", 3),
			}, to = R.fallenHero },
			{ q = 8425, from = R.fallenHero, objs = {
				O(P.sunken, "FCQ_OBJ_WR_FEATHER_AMBER", 1),
				O(P.sunken, "FCQ_OBJ_WR_FEATHER_BLUE", 2),
				O(P.sunken, "FCQ_OBJ_WR_FEATHER_GREEN", 3),
			}, to = R.fallenHero },
		} })
end
```

Opmerkingen bij de schets (AFGELEID):
- Berserker en Whirlwind hebben allebei level 30; `MyChains` sorteert alleen op level (r. 651-653), dus de volgorde bij
  gelijk level ligt niet vast. Whirlwind kan pas na 1719. Opties: Whirlwind 1718/1719 laten voorafgaan, of de sortering
  bij gelijk level de tabelvolgorde laten houden.
- NPC_NAMES: alle `id`'s hierboven staan in tabel 7.
- De wapenketens (4.4) en pantserketens (4.5) kunnen later met `nameKey`; voor 1667, 1681, 1686 en de level-20-materialen
  ontbreken plekken (`O(nil, ...)` met items kan wel).
- `trainer` per factie is wat Zygor doet. Per ras kan ook (Kelv/Darnath/Torm/Baltus), zie gevers in 4.2/4.6.

## 10. Open / niet gemeten

1. **Skyborne en Taunt/Sunder Armor**: leert 94003 alleen Defensive Stance (teach 1612) of alle drie (8121)? Niet te
   meten buiten de client. Na 94003: `/mh classquest` en het spellboek (355, 7386) bekijken, of de trainer op Zephras Isle.
2. **Welke teach-spell werpt welke quest**: serverdata; alleen AFGELEID uit DB2 + gidsen.
3. **Client-index van 1719** (Wowhead vs Zygor) en van 1821 (Zygor-dubbel): in het spel `C_QuestLog.GetQuestObjectives`
   lezen met de quest in het log.
4. **Gevers die maar in één bron staan**: Ilsa Corbin (SL+CX), Baltus Fowler voor 1818 (alleen CX), Darnath voor 1718 en
   Torm voor 8417 (alleen CX), Moon Priestess Amara / Sentinel Elissa Starbreeze voor 1684 (alleen SL).
5. **Andere Forever-quests**: S is gemaakt uit build 70450, de client is 70938. Dat er na 70450 geen nieuwe warrior-
   quests bijkwamen: niet gemeten.
6. **Coördinaten**: niets in het spel gezien. WT-spawns = UiMap AFGELEID. Ontbreken: Dead-tooth Jack-kamp, Umbral Ore,
   Elunite-kratten/Shade of Elura, Rethban Caverns, alle level-20-materialen.
7. **esMX**: 6236 Klannoc en de meeste doelwitten niet gemeten (Wowhead [haken], SN heeft alleen gevers); 4595, 1500,
   4593 alleen WT. Itemnamen per taal: niet gemeten.
8. **1699 The Rethban Gauntlet**: WT-tooltip noemt "Highperch" als eerste vereiste (Highperch ligt in Thousand Needles);
   waarschijnlijk een Wowhead-fout, niet uitgezocht. 1846 toont "Dragonmaw Shinbone x 999" (testen van botten), idem.
9. Level-60-quests (T0.5, ZG, AQ, Naxx) en de Codex of Defense: niet uitgezocht.
