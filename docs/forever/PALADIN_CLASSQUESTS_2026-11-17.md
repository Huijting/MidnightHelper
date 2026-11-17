# Paladin class-quests in WoW Forever (build 1.60.1.70938) — feiten voor `Modules/ForeverClassQuests.lua`

Onderzoek: mh-research, 17 nov 2026. Alleen gelezen, niets gebouwd. De voordeur (`_probe.py`) is NIET gebruikt.
**G** = GEMETEN (gezien in de genoemde bron, vandaag). **A** = AFGELEID (beredeneerd, niet gezien).
Niets is in het spel gemeten: quest-id's zijn onbewezen tot de client ze afvinkt (`/mh classquest`).

## 1. Bronnen

| Afk. | Bron | Wat |
|---|---|---|
| Z-A | `ZygorGuidesViewerForever\Guides-Forever\Leveling\ZygorLevelingAllianceCLASSIC.lua` | "Paladin Class Quests" r. 23114-23742; leveling r. 1456-1511 (Human), 2704-2762 (Dwarf), 5720-5733 (Valor), 11334-11339 (Nobility) |
| Z-H | `...\ZygorLevelingHordeCLASSIC.lua` | Undead-paladin in de Tirisfal-gids: r. 164-213, 259-268, 307-311, 343-345, 459-469, 1110-1115, 1230-1236, 1335-1480. Er is GEEN Horde "Paladin Class Quests"-gids (G: grep, positieve controle `##94434` raakt wel) |
| SP | Spoken: `Spoken_Quests\Data\Compendium.lua` (uit build 70450; prev/ender/races, classes = 2) en `SpokenQuestsAudio*\generated\questlog_npc_lookups.lua` (quest → gever) | ketens en gevers |
| HN | `HandyNotes_ClassTrainers\Data.lua` (build 70532) | trainer-coördinaten |
| DB2 | `%LOCALAPPDATA%\MidnightHelper\gamedata_cache\db2\1.60.1.70938\` (CharBaseInfo, ChrRaces, UiMap, SpellName, ItemSparse) | rassen, map-id's, spell- en item-id's |
| WH | Wowhead Forever: questpagina's `wowhead.com/forever/quest=<id>` en tooltip-JSON `nether.wowhead.com/forever/tooltip/npc/<id>?locale=N` (17 nov 2026) | beloningen, series, doelen, spawns, namen per taal |
| AW | `azeroth.wiki/forever/quests/<id>` (17 nov 2026) | gever, inleveraar, coördinaten, min. level |
| IV | `db.icy-veins.com/wow-forever/quests/<id>` ("added 1.60.1.70532") | gever/inleveraar, keten met id's |
| LW | `legacyofwarcraft.com/db/forever/quests/paladin.html` | lijst van alle 182 quests in de Paladin-categorie van de speldata |
| gidsen | Icy Veins "Paladin Class Quests" (4 nov), Daily Respawn (11 en 14 nov), forg.gg (6 okt / 10 nov), chaosboost (9 nov), conquestcapped (6 nov), warcraft.wiki.gg (patch 1.60.1) | tweede bron |

Positieve controles in dezelfde run: npc 233 = "Bauer Saldean" (deDE, WH locale=3) én in Spoken deDE.lua r. 14; Zygor-grep vond `##94434`; ItemSparse vond 268484 Moonsilver Blade; CharBaseInfo heeft (6,11) Tauren-druid en (95,11) Skyborne-druid.

## 2. Wie kan paladin zijn

| Ras (raceFile) | Factie | Bron |
|---|---|---|
| Human (`Human`, ras 1) | Alliance | G: DB2 CharBaseInfo rij 2 (1,2) |
| Dwarf (`Dwarf`, ras 3) | Alliance | G: CharBaseInfo rij 14 (3,2) |
| Undead (`Scourge`, ras 5) | Horde | G: CharBaseInfo rij 877 (5,2); ChrRaces 5 = Scourge |

Geen Tauren-paladin en geen Skyborne-paladin (G: geen rij (6,2), (95,2) of (96,2); Spoken-maskers 1, 4 en 16 zeggen hetzelfde). Dus: geen Tauren- of Skyborne-quests.

## 3. Spells en items, en welke quest ze geeft

| Wat | Id | Level | Wie | Quest | Bron |
|---|---|---|---|---|---|
| Holy Light | spell 635 | 2 | Undead | 90902 Rediscovering the Light | G: WH "You will learn: Holy Light (635)"; AW min. level 2. A: hij komt bij het AANNEMEN (het doel is 5 keer Holy Light casten) |
| Redemption | spell 7328 | 12 | Human | 1788 | G: WH 1788 "You will learn: Redemption (7328)" |
| Redemption | spell 7328 | 12 | Dwarf | 1785 | G: AW 1785 "Spells learned: Redemption". A: zelfde id 7328 |
| Redemption | spell 7328 | 12 | Undead | 94441 | G: WH 94441 (7328), AW, warcraft.wiki |
| Sense Undead | spell 5502 | 20 | Human, Dwarf | 1652 The Tome of Valor | G: WH 1652 "You will learn: Sense Undead (5502)" + item Bastion of Stormwind 9607; AW idem. Bijvangst, geen eigen keten |
| Verigan's Fist | item 6953 | 20 | Human, Dwarf | 1806 | G: WH 1806; DB2 ItemSparse 6953 |
| Wolfsbane | item 267369 | 20 (start vanaf 18) | Undead | 95140 Old Fire-Eye | G: WH 95140. Niet in de lokale ItemSparse-cache (controle 268484 wel) |
| Summon Warhorse | spell 13819 | 40 | Human, Dwarf | 1661 The Tome of Nobility | G: WH 1661 "You will learn: Summon Warhorse (13819)" |
| Summon Warhorse (Undead) | spell 1279399 | 40 | Undead | 94971 A Paladin's Steed | G: WH 94971; DB2 SpellName 1279399; warcraft.wiki |
| keuze: Lightforged Blade 20504 / Chivalrous Signet 20505 / Sanctified Orb 20512 (+ Holy Mightstone 20620) | items | 50 | Human, Dwarf | 8418 Forging the Mightstone | G: WH 8418. 20504/20505/20512 staan niet in de lokale ItemSparse-cache |
| Summon Charger | spell 23214 | 60 | Human, Dwarf | 7647 Judgment and Redemption | A: WH Forever toont bij 7647 geen "You will learn"; gidsen (Daily Respawn 14 nov, conquestcapped) + Classic zeggen Summon Charger. DB2 SpellName 23214 bestaat (G) |
| Summon Forsaken Charger | spell 1296534 | 60 | Undead | 97185 Justice and Retribution | G: WH 97185; DB2 SpellName 1296534 |

`ForeverTrainer.lua` `ns.FOREVER_QUEST_FIRST`: 7328 (12) en 635 (Undead, 2) kloppen (G, zie boven). Niet in die lijst en wel een quest-spell: 5502 Sense Undead (Alliance, quest 1652), 13819, 1279399, 23214, 1296534.
A: de vier mount-spells zijn in Forever mogelijk "collection mounts" (warcraft.wiki noemt Summon Forsaken Charger "Warband Mount"); of `IsPlayerSpell` ze ziet is NIET gemeten. De keten eindigt ook als de laatste quest af is.

## 4. De ketens

Kolommen: quest — gever → inleveraar. Coördinaten staan in tabel 5. Bron per keten boven de tabel.

### 4.1 Redemption, Human (12) — G: Z-A 23117-23208, AW, SP
| # | Quest | Gever → inleveraar | Doel |
|---|---|---|---|
| 1 | 2998 Tome of Divinity (alt 3681 van Brandur Ironhammer, Ironforge) | Brother Wilhelm → Duthorian Rall | wegwijzer. G: AW/IV/SP (927). A: niet verplicht (Zygor neemt 1641 direct; er bestaat geen wegwijzer bij de Stormwind-trainers) |
| 2 | 1641 The Tome of Divinity | Duthorian → Duthorian | geeft item Tome of Divinity 6775 |
| 3 | 1642 | start: item 6775 in je tas (G: DB2 ItemSparse StartQuestID 1642) → Duthorian | |
| 4 | 1643 | Duthorian → Stephanie Turner | |
| 5 | 1644 | Stephanie → Stephanie | 10 Linen Cloth 2589 (doel 1) |
| 6 | 1780 | Stephanie → Duthorian | |
| 7 | 1781 | Duthorian → Gazin Tenorm | geeft Symbol of Life 6866 |
| 8 | 1786 | Gazin → Henze Faulk | Symbol of Life gebruiken op het lijk. WH: geen doel-vak; Zygor: `q 1786/1` |
| 9 | 1787 | Henze → Gazin | Defias Script 6846 van Defias Rogue Wizards (doel 1) |
| 10 | 1788 | Gazin → Duthorian | leert Redemption |

Kwijt: 1790 The Symbol of Life (Duthorian, nieuwe Symbol) — G: AW.

### 4.2 Redemption, Dwarf (12) — G: Z-A 2704-2762 en 23209-23306, AW, SP
| # | Quest | Gever → inleveraar | Doel |
|---|---|---|---|
| 1 | 2999 Tome of Divinity (alt 2997 Azar Stronghammer, Kharanos; 3000 Lord Grayson Shadowbreaker, Stormwind) | Brandur Ironhammer → Tiza Battleforge | wegwijzer (G: AW, IV, SP 5149/1232/928) |
| 2 | 1645 | Tiza → Tiza | geeft item Tome of Divinity 6916 |
| 3 | 1646 | start: item 6916 (G: StartQuestID 1646) → Tiza | |
| 4 | 1647 | Tiza → John Turner (loopt rond) | |
| 5 | 1648 | John Turner → John Turner | 10 Linen Cloth (doel 1) |
| 6 | 1778 | John Turner → Tiza | |
| 7 | 1779 | Tiza → Muiredon Battleforge | geeft Symbol of Life |
| 8 | 1783 | Muiredon → Narm Faulk | Symbol of Life op het lijk (Zygor `q 1783/1`) |
| 9 | 1784 | Narm → Muiredon | Dark Iron Script 6847 van Dark Iron Spies (doel 1) |
| 10 | 1785 | Muiredon → Tiza | leert Redemption |

Kwijt: 1789 The Symbol of Life (Tiza).

### 4.3 Verigan's Fist, Human + Dwarf (20) — G: Z-A 23317-23453, AW, SP, WH-series 1651→1652→1653→1654→1806
| # | Quest | Gever → inleveraar | Doel |
|---|---|---|---|
| 1 | 1793 The Tome of Valor (alt 1794 bij Tiza Battleforge, Ironforge) | Duthorian → Duthorian | geeft item Tome of Valor 6776 |
| 2 | 1649 | start: item 6776 (G: StartQuestID 1649) → Duthorian | |
| 3 | 1650 | Duthorian → Daphne Stilwell (Westfall) | |
| 4 | 1651 | Daphne → Daphne | Protect Daphne Stilwell (doel 1): golven van 3, 4 en 5 Defias Raiders (Z-A) |
| 5 | 1652 | Daphne → Duthorian | leert Sense Undead 5502 + Bastion of Stormwind |
| 6 | 1653 The Test of Righteousness | Duthorian → Jordan Stilwell (poort van Ironforge) | |
| 7 | 1654 | Jordan → Jordan | 1 Whitestone Oak Lumber 6994 (Deadmines, Goblin Woodcarver); 2 Jordan's Refined Ore Shipment 6993; 3 Jordan's Smithing Hammer 6895 (Shadowfang Keep, stal); 4 Purified Kor Gem 7083 |
| 7a | 1655 Bailor's Ore Shipment | Bailor Stonehand → Bailor (Loch Modan) | Jordan's Ore Shipment 6992 uit "Bailor's Ore"; beloning 6993 |
| 7b | 1442 Seeking the Kor Gem | Thundris Windweaver → Thundris (Darkshore) | Corrupted Kor Gem 6995 van Blackfathom-naga; beloning 7083 |
| 8 | 1806 | Jordan → Jordan | Verigan's Fist |

A: 1655 en 1442 gaan open zodra 1653 af is (geen prereq bij AW/SP; of 1654 in je log moet staan is niet gemeten).

### 4.4 Summon Warhorse, Human + Dwarf (40) — G: Z-A 11334-11339 en 23455-23461, AW, WH
| # | Quest | Gever → inleveraar |
|---|---|---|
| 1 | 4485 The Tome of Nobility (alt 4486 van Brandur Ironhammer, Ironforge) | Arthur the Faithful (Stormwind) → Duthorian. Gever 4485: SP (5491) en forg.gg zeggen Arthur; AW zegt Tiza Battleforge: **bronnen oneens** |
| 2 | 1661 The Tome of Nobility | Duthorian → Duthorian; leert Summon Warhorse. A: Zygor neemt 1661 direct, de wegwijzer lijkt niet verplicht |

### 4.5 Forging the Mightstone, Human + Dwarf (min. 50, questlevel 52) — G: Z-A 23462-23533, AW, IV
| # | Quest | Gever → inleveraar | Doel |
|---|---|---|---|
| 1 | 8415 Chillwind Point | Lord Grayson Shadowbreaker (of Brandur Ironhammer) → Commander Ashlam Valorfist | |
| 2 | 8414 Dispelling Evil | Ashlam → High Priest Thel'danis | 20 Minion's Scourgestone 12840 (doel 1) |
| 3 | 8416 Inert Scourgestones | Thel'danis → Ashlam | |
| 4 | 8418 Forging the Mightstone | Ashlam → Ashlam | Sunken Temple: 2 Amber 20606 (1), 2 Blue 20607 (2), 2 Green 20608 (3) Voodoo Feather |

### 4.6 Summon Charger, Human + Dwarf (60) — G: Z-A 23535-23741, AW, SP
| # | Quest | Gever → inleveraar | Doel |
|---|---|---|---|
| 1 | 7638 Lord Grayson Shadowbreaker (alt 7670 van Brandur) | Duthorian → Lord Grayson | |
| 2 | 7637 Emphasis on Sacrifice | Grayson → High Priest Rohan (Ironforge) | 150 goud |
| 3 | 7639 To Show Due Judgment | Rohan → Grayson | |
| 4 | 7640 Exorcising Terrordale | Grayson → Grayson | 25 Terrordale Spirits met de Exorcism Censer 18752 (doel 1) |
| 5 | 7641 The Work of Grimand Elmore | Grayson → Grimand Elmore | |
| 6 | 7642 Collection of Goods | Grimand → Grimand | 1 = 5 Stratholme Holy Water 13180, 2 = 10 Arthas' Tears 8836, 3 = 40 Runecloth 14047, 4 = 6 Arcanite Bar 12360, + 150 goud |
| 7 | 7648 Grimand's Finest Work | Grimand → Grayson | |
| 8 | 7643 Ancient Equine Spirit | Grayson → Ancient Equine Spirit (Dire Maul West, na Tendris Warpwood) | Manna-Enriched Horse Feed 18775 (doel 1) |
| 8a | 7645 Manna-Enriched Horse Feed | Merideth Carlson → Merideth (Southshore) | 20 Enriched Manna Biscuit 13724 (Argent Dawn, Friendly) + 50 goud |
| 9 | 7644 Blessed Arcanite Barding | Equine Spirit → Grayson | |
| 10 | 7646 The Divination Scryer | Grayson → Grayson | 1 Azerothian Diamond 12800, 2 Pristine Black Diamond 18335 |
| 11 | 7647 Judgment and Redemption | Grayson → Darkreaver's Fallen Charger (Scholomance) | 1 Charger's Redeemed Soul 18799, 2 Blessed Arcanite Barding 18792 (uit Lord Grayson's Satchel 18804) |

Herkansing: 7666 Again Into the Great Ossuary (Grayson; nieuwe scryer) — G: SP prev 7647.

### 4.7 Holy Light, Undead (2) — G: Z-H 155-213, AW, SP, WH
| # | Quest | Gever → inleveraar | Doel |
|---|---|---|---|
| 1 | 98601 A Difficult Path (na 364 The Mindless Ones: G SP prev = 364) | Shadow Priest Sarvis → Aramis Hammerhand | lees de Consecrated Scroll 282423 |
| 2 | 90902 Rediscovering the Light | Aramis → Aramis | heal 5 Injured Deathguard 259377 met Holy Light (doel 1) |

### 4.8 Bandarion Keep, Undead (vanaf 8; items) — G: Z-H 259-345, 459-465, 1230-1460, AW, SP. Bijzaak.
| # | Quest (min. level) | Gever → inleveraar | Doel |
|---|---|---|---|
| – | 91208 Coming to Terms (4) → 91209 Continue Your Training (4) | Aramis → Aramis; Aramis → Shari Stilwell (Brill) | Frightened Paladin 246143 (27.68, 63.82); geen beloning, niet in de schets |
| 1 | 91282 A Second Home (8) | Shari Stilwell → Breton Samuels | |
| 2 | 91285 Murlocs at the Gates (7) | Breton → Breton | 1 = 8 Vile Fin Attacker, 2 = 8 Vile Fin Seer; keuze Skullthumper 246164 / Driftwood Smasher 246165 |
| 3 | 91294 Touring the Grounds (8) | Breton → Danitha Morr | 1 Hilda the Breaker, 2 Jorin Croge, 3 Ander Solliden, 4 Danitha Morr |
| 4 | 91316 Making Repairs (8), los | Jorin Croge → Jorin | 12 Sturdy Lumber 246213 (crypte in Shadowvale); Salvaged Wooden Tower Shield 246265 |
| 5 | 91317 The Tarnished (9) | Danitha → Danitha | 1 Rudolph Gelhardt's Head 270435, 2 = 8 Tarnished Drudge, 3 = 6 Tarnished Zealot |
| 6 | 95803 A Token of Good Faith (9) | Danitha → Lady Sylvanas Windrunner (Undercity) | |

### 4.9 Redemption, Undead (12) — G: AW, SP (gevers), WH-series 94434→…→94441, warcraft.wiki; Z-H alleen 94427 en 94434
| # | Quest | Gever → inleveraar | Doel |
|---|---|---|---|
| 1 | 94427 A Lesson in Divinity | Danitha Morr → Tanis Alderwood (Undercity) | G: Zygor neemt hem aan vóór de Keep-quests af zijn; forg.gg zegt dat je die eerst moet doen: niet gemeten |
| 2 | 94434 | Tanis → Tanis | 10 Linen Cloth (doel 1) |
| 3 | 94435 | Tanis → Danitha | geeft Symbol of Life 6866 |
| 4 | 94436 | Danitha → Deathguard Billmuth (beneden) | |
| 5 | 94438 | Billmuth → Deathguard Falgan (Venomweb Vale) | Symbol of Life op Falgan (doel 1, G: WH) |
| 6 | 94440 | Falgan → Billmuth | Scarlet Crusade Attack Plans 264693 van Scarlet Friar / Zealot (doel 1) |
| 7 | 94441 | Billmuth → Danitha | leert Redemption |

### 4.10 Wolfsbane, Undead (91858 vanaf 18; 95036 en verder vanaf 20) — G: AW, SP (gevers), WH-series; chaosboost 9 nov. Niet in Zygor.
| # | Quest | Gever → inleveraar | Doel |
|---|---|---|---|
| 1 | 91858 Diplomatic Incident | Danitha Morr → Trevan Rol (The Sepulcher) | |
| 2 | 91859 A Curious Pair | Trevan → Deathguard Baldren | |
| 3 | 91860 A Grim Fate | Baldren → Charred Remains (voorwerp, Fenris Isle) | |
| 4 | 91861 Into Fenris Keep | Charred Remains → Lumina Windsinger (248755, Fenris Keep) | |
| 5 | 91862 Lumina Windsinger | Lumina → Lumina | Fenris Isle Key 267412 van Rot Hide-gnolls (doel 1) |
| 6 | 96204 The Windshaper's Wrath | Lumina (Fenris) → Lumina (259620, The Sepulcher) | Escort Lumina (doel 1, G: WH) |
| 7 | 95034 The Debt | Lumina → Lumina | Speak with Lumina Windsinger (doel 1) |
| 8 | 95036 A Moon-Kissed Blade | Lumina → Trevan Rol | 1 Trevan's Weapon Notes 267454, 2 Whitestone Oak Lumber 6994 (Deadmines), 3 Enchanted Silver Ingot 267361 (Shadowfang Keep, A: chaosboost), 4 Purified Kor Gem 272448 (G: WH) |
| 8a | 95042 Seeking the Kor Gem | Ulric Frostveil → Ulric (Ashenvale) | Corrupted Kor Gem 6995 (Blackfathom-naga) |
| 9 | 95111 An Underrated Talent | Trevan → Ott (Tarren Mill) | |
| 10 | 95125 Ott's Masterwork | Ott → Ott | Watch Ott craft the blade (doel 1) |
| 11 | 95126 The Moonsilver Blade | Ott → Trevan | geeft Moonsilver Blade 268484 |
| 12 | 95140 Old Fire-Eye | Lumina (Sepulcher) → Lumina | 1 Old Fire-Eye 259897 (level 25 elite), 2 Moonsilver Blade; beloning Wolfsbane |

### 4.11 Summon Warhorse, Undead (40) — G: IV, WH, SP (97022 = 260093), warcraft.wiki. Niet in Zygor.
| # | Quest | Gever → inleveraar |
|---|---|---|
| 1 | 97022 Report to Danitha | Garen Largo (Undercity) of Alodan the Hopeful (Thunder Bluff) → Danitha Morr |
| 2 | 94971 A Paladin's Steed | Danitha → Danitha; leert Summon Warhorse 1279399 |

### 4.12 Summon Forsaken Charger, Undead (60) — id's G (IV, LW, WH); gevers grotendeels A. Niet in Zygor, niet in Spoken.
| # | Quest | Gever → inleveraar | Bron gever |
|---|---|---|---|
| 1 | 97174 A Worthy Endeavor | Alodan the Hopeful → Danitha | G: IV. JudgeHype (16 nov): "een van de gevers" |
| 2 | 97175 Due Sacrifice | Danitha → Zayus (Orgrimmar), 150 goud | G: IV (start); A (einde, questtekst) |
| 3 | 97177 Acts of Mercy | Zayus → Danitha | A (questtekst) |
| 4 | 97176 Exorcising Terrordale | Danitha → Danitha; 25 Terrordale Spirits (doel 1) | A. WH-reactie (GuliverGumba): na Acts of Mercy "gebeurde er niets" |
| 5 | 97178 Ott of Tarren Mill | Danitha → Ott | A |
| 6 | 97179 Collection of Goods | Ott → Ott; zelfde vier materialen + 150 goud | G: IV (start Ott 60.5, 26.2) |
| 7 | 97180 Ott's Finest Work | Ott → Danitha | A |
| 8 | 97182 An Offering of Vengeance | Danitha → Ancient Equine Spirit (Dire Maul West) | A |
| 8a | 97186 Manna-Enriched Horse Feed | Nathanos Blightcaller → Nathanos; 20 biscuits + 50 goud | A |
| 9 | 97183 Blessed Arcanite Barding | Equine Spirit → Danitha | A |
| 10 | 97184 The Divination Scryer | Danitha → Danitha; twee diamanten | A |
| 11 | 97185 Justice and Retribution | Danitha → Darkreaver's Fallen Charger; Spirit of Retribution 276783 + barding uit Danitha's Satchel 276785 | A; beloning G (WH) |

### 4.13 Gevonden, niet uitgezocht (niet in de schets)
- Alliance, vanaf 22: "Cloak of the Divine Storm" 277205 via 78088 A Strange Artifact → 78089 → 78090 → 78091 → 78092 → 78093 Return to Delgren. Start is een voorwerp: Strange Orb, Darkshore 56.2, 26.4 → Delgren the Purifier, Ashenvale 26.2, 38.7 (G: IV, Icy Veins-gids). Tussenstappen en beloning per stap niet gemeten.
- Alliance, vanaf 35 en 45: de Aeonas-quests (96438 Battle at the Mannoroc Coven van Katherine the Pure → 79939 → 79940; 79945 → 79946 → 79963 → 79970; 96449; 81766 → 96476 …). G: IV dat ze bestaan; beloningen niet gemeten.
- Undead, vanaf 50: 93030 The Knight of Mourning → 99187 The Reliquary of Tyr (dungeon "Blackmaw Hold"). G: IV; gever en beloning niet gemeten.
- 98465-98470 The Errant Knight, 95365 Where's The Squire?: staan in LW, IV toont alleen het id.
- Rest van LW (83xxx-85xxx, 79xxx-82xxx): oude seizoensquests in de data; of ze spelen in Forever is niet gemeten.

## 5. Plekken (UiMap-id's G in DB2 UiMap 70938)

Regel: HandyNotes > Zygor > gids. Stormwind en Eastern Plaguelands hebben in Forever een grotere kaart (HN r. 4-5): daar alleen Zygor/HN-waarden. In het spel is niets gemeten.

| Sleutel | NPC (id) | Map | x, y | Bron |
|---|---|---|---|---|
| wilhelm | Brother Wilhelm (927) | Elwynn 1429 | 40.90, 66.09 | HN |
| duthorian | Duthorian Rall (6171) | Stormwind 1453 | 50.48, 47.49 | Z-A (WH nieuwe set 50.4-50.6, 47.2-47.6) |
| stephanie | Stephanie Turner (6174) | 1453 | 63.84, 72.21 | Z-A |
| gazin | Gazin Tenorm (6173) | 1453 | 49.51, 44.90 | Z-A |
| henze | Henze Faulk (6172) | 1429 | 72.60, 51.41 | Z-A |
| defiasWizards | – | 1429 | 74.07, 51.57 | Z-A |
| brandur | Brandur Ironhammer (5149) | Ironforge 1455 | 23.13, 6.14 | HN |
| tiza | Tiza Battleforge (6179) | 1455 | 27.64, 12.19 | Z-A |
| johnTurner | John Turner (6175) | 1455 | 21.55, 50.80 | Z-A (loopt: ook 22.93,61.36 / 32.40,78.58 / 43.09,84.17) |
| muiredon | Muiredon Battleforge (6178) | 1455 | 23.53, 8.29 | Z-A |
| narm | Narm Faulk (6177) | Dun Morogh 1426 | 78.32, 58.09 | Z-A |
| darkIronSpies | – | 1426 | 77.39, 61.27 | Z-A |
| daphne | Daphne Stilwell (6182) | Westfall 1436 | 42.71, 88.40 | Z-A (loopt; leveling-gids 42.33, 88.64) |
| jordan | Jordan Stilwell (6181) | 1426 | 52.48, 36.92 | Z-A |
| bailor | Bailor Stonehand (6241) | Loch Modan 1432 | 35.96, 44.92 | Z-A |
| bailorsOre | – | 1432 | 71.62, 21.55 | Z-A |
| thundris | Thundris Windweaver (3649) | Darkshore 1439 | 37.40, 40.13 | Z-A |
| deadmines | – (ingang huis Moonbrook) | 1436 | 42.57, 71.83 | Z-A 23371 |
| bfd | – (water in bij Blackfathom) | Ashenvale 1440 | 14.12, 13.88 | Zygor dungeon-gids r. 371 |
| arthur | Arthur the Faithful (5491) | 1453 | 49.61, 49.84 | HN |
| grayson | Lord Grayson Shadowbreaker (928) | 1453 | 48.43, 50.22 | HN |
| ashlam | Commander Ashlam Valorfist (10838) | W. Plaguelands 1422 | 42.70, 84.03 | Z-A |
| scourgestones | – | 1422 | 40.65, 70.27 | Z-A |
| theldanis | High Priest Thel'danis (1854) | 1422 | 52.09, 83.35 | Z-A (patrouilleert) |
| rohan | High Priest Rohan (11406) | 1455 | 26.98, 7.30 | Z-A (loopt; AW 24.7, 8.2) |
| terrordale | – | E. Plaguelands 1423 | 15.97, 25.26 | Z-A. A: Forever-kaartruimte |
| grimand | Grimand Elmore (1416) | 1453 | 59.71, 33.77 | Z-A |
| stratGate | – (Service Gate) | 1423 | 41.43, 17.71 | Z-A 23612 |
| merideth | Merideth Carlson (2357) | Hillsbrad 1424 | 52.18, 55.50 | Z-A |
| equineSpirit | Ancient Equine Spirit (14566) | Feralas 1444 | 60.32, 30.16 | Z-A: deur Dire Maul West (A: de geest staat binnen) |
| fallenCharger | Darkreaver's Fallen Charger (14568) | 1422 | 69.94, 74.03 | Zygor Events-gids r. 1277: trap bij Scholomance (A) |
| sarvis | Shadow Priest Sarvis (1569) | Tirisfal 1420 | 30.84, 66.20 | Z-H |
| aramis | Aramis Hammerhand (244808) | 1420 | 30.97, 66.77 | HN (Z-H 31.09, 66.40; WH 31.0, 66.2) |
| deathguards | – | 1420 | 31.98, 64.72 | Z-H |
| shari | Shari Stilwell (246152) | 1420 | 60.20, 52.50 | HN |
| breton | Breton Samuels (246349) | 1420 | 21.85, 45.21 | Z-H |
| vileFin | – | 1420 | 14.68, 54.75 | Z-H |
| hilda / ander | – (Hilda 246389 loopt; Ander 246394) | 1420 | 21.95, 47.24 / 25.41, 50.41 | Z-H |
| jorin | Jorin Croge (246393) | 1420 | 22.70, 44.68 | Z-H |
| lumberCrypt / gelhardt / tarnished | – | 1420 | 10.42, 65.69 / 11.53, 64.21 / 12.87, 63.45 | Z-H (ingang crypte 12.90, 65.73) |
| danitha | Danitha Morr (246378) | 1420 | 22.09, 44.66 | Z-H (boven) |
| sylvanas | Lady Sylvanas Windrunner (10181) | Undercity 1458 | 58.06, 91.78 | Z-H |
| tanis | Tanis Alderwood (257648) | 1458 | 65.45, 37.47 | Z-H |
| billmuth | Deathguard Billmuth (257655) | 1420 | 21.9, 44.5 | AW (WH 22.0, 44.4-44.6) |
| falgan | Deathguard Falgan (257663) | 1420 | 86.7, 47.7 | AW (WH 86.4-86.6, 47.4-47.6) |
| trevan | Trevan Rol (248840) | Silverpine 1421 | 43.3, 41.0 | AW, WH |
| baldren | Deathguard Baldren (259611) | 1421 | 45.8, 41.8 | AW, WH |
| charredRemains | Charred Remains (voorwerp) | 1421 | 64.9, 34.4 | AW |
| luminaFenris | Lumina Windsinger (248755) | 1421 | 65.5, 23.5 | AW |
| luminaSepulcher | Lumina Windsinger (259620) | 1421 | 43.3, 41.0 | AW, WH 43.2, 41.0 |
| ulric | Ulric Frostveil (259649) | Ashenvale 1440 | 11.8, 34.5 | AW, WH |
| ott | Ott (3539) | Hillsbrad 1424 | 60.4, 26.2 | AW, WH |
| oldFireEye | – (Old Fire-Eye 259897 zwerft) | 1421 | 49.4, 86.8 | chaosboost; ligt in de WH-spawnwolk 43-51, 79-89 |
| garen | Garen Largo (260093) | 1458 | 47.50, 14.90 | HN |
| alodan | Alodan the Hopeful (246344) | Thunder Bluff 1456 | 25.40, 14.60 | HN |
| zayus | Zayus (5994) | Orgrimmar 1454 | 35.7, 86.9 | pullcall / classic-wow.com (Classic-data) |

Niet gemeten: ingang Shadowfang Keep (plek = nil). Nathanos Blightcaller (11878): WH geeft 26.4-26.6, 74.4-74.8, dat is de oude Classic-waarde; de Forever-kaart van Eastern Plaguelands is groter → plek = nil.

## 6. Objective-index

Volgorde G in WH/AW/IV en Zygor `q <id>/<n>`; dat hij gelijk is aan de index van `C_QuestLog.GetQuestObjectives` = A (voor alle).
1644/1648/94434: 1 Linen Cloth. 1787: 1. 1784: 1. 1651: 1. 1654: 1 lumber, 2 refined ore, 3 hammer, 4 gem. 1655: 1. 1442: 1. 8414: 1. 8418: 1 amber, 2 blue, 3 green. 7640: 1. 7642: 1 holy water, 2 Arthas' Tears, 3 runecloth, 4 arcanite (Zygor noemt goud "/5"). 7643: 1. 7646: 1 Azerothian, 2 Pristine Black. 7647: 1 Redeemed Soul, 2 barding (IV, WH; Zygor zet de Lost Soul op /1). 90902: 1. 91285: 1 attackers, 2 seers. 91294: 1 Hilda, 2 Jorin, 3 Ander, 4 Danitha. 91316: 1. 91317: 1 head, 2 drudges, 3 zealots. 94438: 1. 94440: 1. 91862: 1. 96204: 1. 95034: 1. 95036: 1 notes, 2 lumber, 3 ingot, 4 gem. 95042: 1. 95125: 1. 95140: 1 Old Fire-Eye, 2 blade. 97176: 1. 97179: zelfde volgorde als 7642 (IV). 97184: 1, 2. 97185: 1 Spirit of Retribution, 2 barding (IV).
Zonder index: 1786 en 1783 (WH toont geen doel; Zygor wel `/1`) en 97182 (volgorde bij IV: barding, dan voer): daar wacht de stap tot de client de quest compleet meldt.

## 7. NPC-namen per taal

G: WH tooltip per locale (2 fr, 3 de, 6 es, 11 esMX, 8 pt, 7 ru), 17 nov 2026; controle 233 in elke taal. Een Engels uitziende naam zonder [haken] is de naam van die client. In [haken] bij WH = niet vertaald → weggelaten (of uit Spoken, dan staat dat erbij). Verschillen met Spoken: zie onder de tabel.

| id | deDE | frFR | esES | esMX | ptBR | ruRU |
|---|---|---|---|---|---|---|
| 927 | Bruder Wilhelm | Frère Wilhelm | Hermano Wilhelm | Hermano Wilhelm | Irmão Guilhermino | Брат Вильгельм |
| 6171 | Duthorian Rall | Duthorian Rall | Duthorian Rall | Duthorian Rall | Benedito Brião | Даториан Ралл |
| 6174 | Stephanie Turner | Stephanie Turner | Stephanie Turner | Stephanie Turner | Stephanie Turner | Стефани Тернер |
| 6173 | Gazin Tenorm | Gazin Tenorm | Gazin Tenorm | Gazin Tenorm | Gazin Tenorm | Газин Тенорм |
| 6172 | Henze Faulk | Henze Faulk | Henze Faulk | Henze Faulk | Henze Faulk | Хенз Фолк |
| 5149 | Brandur Ironhammer | Brandur Ironhammer | Brandur Martiyerro | Brandur Martiyerro (Spoken; WH in haken) | Brandur Ferromalho | Брандар Железный Молот |
| 6179 | Tiza Battleforge | Tiza Battleforge | Tiza Forjabatalla | Tiza Forjabatalla | Tiza Beloforja | Тиза Кузнебой |
| 6175 | John Turner | John Turner | John Turner | John Turner | João Turner | Джон Тернер |
| 6178 | Muiredon Battleforge | Muiredon Battleforge | Muiredon Forjabatalla | Muiredon Forjabatalla | Muiredon Beloforja | Майридон Кузнебой |
| 6177 | Narm Faulk | Narm Faulk | Narm Faulk | Narm Faulk | Narm Faulk | Нарм Фолк |
| 6182 | Daphne Stilwell | Daphne Stilwell | Daphne Fontana | Daphne Fontana | Dafne Calmafonte | Дафна Стилвелл |
| 6181 | Jordan Stilwell | Jordan Stilwell | Jordan Fontana | Jordan Fontana | Jardel Calmafonte | Джордан Стилвелл |
| 6241 | Bailor Stonehand | Bailor Stonehand | Bailor Petramano | Bailor Petramano | Bailor Manopedra | Балор Крепкорук |
| 3649 | Thundris Windwirker | Thundris Windweaver | Thundris Tejevientos | Thundris Tejevientos | Trovejius Tecevento | Тандрис Ветропряд |
| 5491 | Arthur der Treue | Arthur le Fidèle | Arthur el Leal | Arthur el Leal | Artur, o Fiel | Артур Верный |
| 928 | Lord Grayson Shadowbreaker | Seigneur Grayson Shadowbreaker | Lord Grisillo Quiebrasombras | Lord Grisillo Quiebrasombras | Lorde Grayson Quebrassombra | Лорд Грейсон Тенелом |
| 10838 | Kommandant Ashlam Valorfist | Commandant Ashlam Valorfist | Comandante Ashlam Puñovalor | Comandante Ashlam Puñovalor | Comandante Ashlam Punhobom | Командир Ашлам Отважный Кулак |
| 1854 | Hohepriester Thel'danis | Grand prêtre Thel'danis | Sumo Sacerdote Thel'danis | Sumo sacerdote Thel'danis (Spoken; WH in haken) | Sumo Sacerdote Thel'danis | Верховный жрец Тель'данис |
| 11406 | Hohepriester Rohan | Grandprêtre Rohan | Sumo Sacerdote Rohan | Sumo sacerdote Rohan | Sumo Sacerdote Rohan | Верховный жрец Рохан |
| 1416 | Grimand Elmore | Grimand Elmore | Grimand Elmore | Grimand Elmore | Grimand Elmore | Гриманд Элмор |
| 2357 | Merideth Carlson | Merideth Carlson | Merideth Carlson | – | Judite Castanheira | Меридет Карлсон |
| 14566 | Uralter Pferdegeist | Ancien esprit équin | Antiguo espíritu equino | – | Espírito Equino Antigo | Дух древнего коня |
| 14568 | Schattensichels gefallenes Streitross | Destrier déchu de Ravassombre | Arremetedor Atracoscuro | – | Corcel Caído de Noctilatrus | Падший скакун Темного Терзателя |
| 1569 | Schattenpriester Sarvis | Prêtre des ombres Sarvis | Sacerdote de las Sombras Sarvis | Sacerdote de las Sombras Sarvis | Sacerdote Sombrio Sarvis | Жрец Тьмы Сарвис |
| 244808 | Aramis Hammerhand | Aramis Mainmartel | Aramis Manomartillo | Aramis Manomartillo | Aramis Cerramartelo | Арамис Хаммерхенд |
| 246152 | Shari Stilwell | Shari Morpuits | Shari Fontana | Shari Fontana | Shária Calmafonte | Шари Стилвелл |
| 246349 | Brenton Samuels | Breton Samuels | Breton Samuels | Breton Samuels | Bretônio Samuel | Бретон Самуэльс |
| 246393 | Jorin Croge | Jorin Croge | Jorin Croge | Jorin Croge | Jorin Croge | Джорин Крог |
| 246378 | Danitha Morr | Danitha Morr | Danitha Morr | Danitha Morr | Danitha Morr | Данита Морр |
| 10181 | Fürstin Sylvanas Windrunner | Dame Sylvanas Windrunner | Lady Sylvanas Brisaveloz | Lady Sylvanas Brisaveloz | Grande Dama Sylvana Correventos | Леди Сильвана Ветрокрылая |
| 257648 | Tanis Alderwood | Tanis Aulnebois | Tanis Alderwood | Tanis Alisero | Tanis Amieiro | Танис Элдервуд |
| 257655 | Todeswache Billmuth | Nécrogarde Billmuth | Guardia de la Muerte Billmuth | Guardia de la Muerte Billmuth | Necroguarda Billmuth | Страж смерти Билмут |
| 257663 | Todeswache Falgan | Nécrogarde Falgan | Guardia de la Muerte Falgan | Guardia de la Muerte Falgan | Necroguarda Falgan | Страж смерти Фалган |
| 248840 | Trevan Rol | Trevan Rol | Trevan Rol | Trevan Rol | Trevano Rol | Треван Рол |
| 259611 | Todeswache Baldren | Nécrogarde Baldren | Guardia de la Muerte Baldren | Guardia de la muerte Baldren | Necroguarda Baldreno | Страж смерти Балдрен |
| 248755 | Lumina Windsinger | Lumina Chantelevent | Lumina Vientocantor | Lumina Vientocantor | Lúmina Cantavento | Люмина Песнь Ветра |
| 259620 | Lumina Windsinger | Lumina Chantelevent | Lumina Vientocantor | – | – | Люмина Песнь Ветра |
| 259649 | Ulric Frostveil | Ulric Voile-de-givre | Ulric Veloescarcha | Ulric Veloscarcha | Ulorico Glacivéu | Ульрик Фроствейл |
| 3539 | Ott | Ott | Ott | Ott | Ott | Отт |
| 260093 | Garen Largo | Garen Largo | Garen Largo | Garen Largo | Gareno Largo | Гарен Ларго |
| 246344 | Alodan der Hoffnungsvolle | Alodan l'Optimiste | Alodan el Esperanzado | Alodan, el Optimista | Alodor, o Esperançoso | Алодан Жизнерадостный |
| 5994 | Zayus | Zayus | Zayus | Zayus | Zayus | Зайус |
| 11878 | Nathanos Blightcaller | Nathanos le Flétrisseur | Nathanos Clamorinfecto | Nathanos Clamañublo | Nathanos Arauto da Praga | Натанос Гнилостень |

Bronnen oneens (WH gekozen): 927 esES (Spoken: "Hermano Fijalontad"); 6179 ruRU (Spoken: "Тиза Боевой Горн"); 10838 ruRU (Spoken: "Командир Ашлам Смелонрав"); 1569 ruRU (Spoken: "Жрец Тени Сарвис"). 259620 esMX/ptBR: WH heeft geen vertaling, terwijl 248755 (dezelfde Lumina) er wel een heeft: dan toont de module in die twee talen op de Sepulcher de Engelse naam. Spoken kent geen van de nieuwe Forever-NPC's (2xxxxx).

## 8. Fouten in Zygor (niet overnemen)

1. Z-A 23213: Brandur Ironhammer geeft `Tome of Divinity##2997`. Fout: 2997 is van Azar Stronghammer (Kharanos); Brandur geeft 2999 (G: AW, IV, SP; Zygors eigen leveling-gids r. 2706 zegt wél 2999).
2. Z-A 23219-23228: 1645 wordt aangenomen maar nooit ingeleverd; 1646 wordt twee keer aangenomen (bij Tiza én via het boek). 1646 start alleen uit het item 6916.
3. Z-A 23320-23321: `1794` en `1793` allebei bij Duthorian Rall. 1794 is van Tiza Battleforge in Ironforge (G: AW; SP ender 6179).
4. Z-A 23441: bij het inleveren staat `accept Seeking the Kor Gem##1442` (moet turnin zijn).
5. Z-A 23497 / 23509: de Sunken Temple-stap verwijst naar `|q 8236` en `|q 8232` (8232 is de hunter-quest); moet 8418 zijn.
6. Z-A 23644: "Collect 50 Gold" hangt aan `|q 7637`; hoort bij 7645.
7. Z-A 23734: `Charger's Lost Soul##18749 |q 7647/1`; doel 1 is de Charger's Redeemed Soul 18799 (G: WH, IV).
8. Z-A 23463: "ding 52" vóór Chillwind Point; de quest kan vanaf 50 (G: AW, IV). Geen fout, wel te laat.
9. Typefouten: 23182 "Ressurect", 23281 "Resseurect", 23574 "xorcising Terrordale".
10. Z-H: de gids stopt na 94434. 94435-94441 (de rest van Redemption), de Wolfsbane-keten, 97022/94971 en 97174-97185 ontbreken (G: grep met positieve controle).
11. Z-H 4785-4788: "talk Garen Largo##260093" met `trainer Baltus Fowler##4595` (de warrior-trainer).

## 9. Lua-schets (plaats ná het laatste class-blok)

Vorm = HU_P / CHAINS.HUNTER. Hergebruikt: `O`, `HUM`, `DWGN`, `UD`, `P.sunken` en de drie warrior-teksten `FCQ_OBJ_WR_FEATHER_*` (zelfde veren, zelfde volgorde).
Twee dingen die de module nu niet kent:
- **Quest die uit een item in je tas start** (1642, 1646, 1649). In de schets staat `item = <id>` als extra veld. Zonder aanpassing zegt de module "get the quest from Duthorian Rall / Tiza Battleforge": de plek klopt (daar kreeg je het boek en daar lever je in), de tekst niet. Voorstel: staat de quest niet in het log en heb je `e.item` in je tas, toon dan `FCQ_USE_ITEM_FMT` met de itemnaam uit de client.
- **Voorwerp als gever/inleveraar** (Charred Remains): plek zonder `id`, dan toont de module de Engelse naam.

```lua
--[[ Paladin (17 Nov 2026). All facts: docs/forever/PALADIN_CLASSQUESTS_2026-11-17.md (mh-research): Zygor Forever
	"Paladin Class Quests" + the leveling guides (Undead), Spoken, wago DB2 1.60.1.70938, Wowhead Forever, azeroth.wiki,
	the Icy Veins database, HandyNotes. Paladins: Human, Dwarf, Undead (CharBaseInfo); no Tauren, no Skyborne.
	AFGELEID: the trainer breadcrumbs (2998/2999, 4485, 7638, 97022) are optional; 4485 is given by Arthur the Faithful
	(Spoken, forg.gg; azeroth.wiki says Tiza Battleforge); the objective index; the givers of the Forsaken Charger chain
	(only the quest ids, Alodan, Danitha and Ott are measured); Summon Charger = 23214 on 7647 (Wowhead shows no spell).
	1786/1783 have no objective index on purpose (Wowhead shows none): the step waits until the quest is complete.
	`item` = the quest starts from that item in your bags (needs support in Step; without it the arrow is still right).
	Zygor mistakes not copied: 2997 at Brandur (= 2999), 1794 at Duthorian (= Tiza), |q 8232 at the Sunken Temple step
	(= 8418), Lost Soul as 7647/1. Trainers: HandyNotes; the rest: Zygor; Undead level 12+: azeroth.wiki / Wowhead. ]]
local PA_P = {
	-- Alliance
	wilhelm = { npc = "Brother Wilhelm", id = 927, m = 1429, x = 40.90, y = 66.09 },
	duthorian = { npc = "Duthorian Rall", id = 6171, m = 1453, x = 50.48, y = 47.49 },
	stephanie = { npc = "Stephanie Turner", id = 6174, m = 1453, x = 63.84, y = 72.21 },
	gazin = { npc = "Gazin Tenorm", id = 6173, m = 1453, x = 49.51, y = 44.90 },
	henze = { npc = "Henze Faulk", id = 6172, m = 1429, x = 72.60, y = 51.41 },
	brandur = { npc = "Brandur Ironhammer", id = 5149, m = 1455, x = 23.13, y = 6.14 },
	tiza = { npc = "Tiza Battleforge", id = 6179, m = 1455, x = 27.64, y = 12.19 },
	johnTurner = { npc = "John Turner", id = 6175, m = 1455, x = 21.55, y = 50.80 },
	muiredon = { npc = "Muiredon Battleforge", id = 6178, m = 1455, x = 23.53, y = 8.29 },
	narm = { npc = "Narm Faulk", id = 6177, m = 1426, x = 78.32, y = 58.09 },
	daphne = { npc = "Daphne Stilwell", id = 6182, m = 1436, x = 42.71, y = 88.40 },
	jordan = { npc = "Jordan Stilwell", id = 6181, m = 1426, x = 52.48, y = 36.92 },
	bailor = { npc = "Bailor Stonehand", id = 6241, m = 1432, x = 35.96, y = 44.92 },
	thundris = { npc = "Thundris Windweaver", id = 3649, m = 1439, x = 37.40, y = 40.13 },
	arthur = { npc = "Arthur the Faithful", id = 5491, m = 1453, x = 49.61, y = 49.84 },
	grayson = { npc = "Lord Grayson Shadowbreaker", id = 928, m = 1453, x = 48.43, y = 50.22 },
	ashlam = { npc = "Commander Ashlam Valorfist", id = 10838, m = 1422, x = 42.70, y = 84.03 },
	theldanis = { npc = "High Priest Thel'danis", id = 1854, m = 1422, x = 52.09, y = 83.35 },
	rohan = { npc = "High Priest Rohan", id = 11406, m = 1455, x = 26.98, y = 7.30 },
	grimand = { npc = "Grimand Elmore", id = 1416, m = 1453, x = 59.71, y = 33.77 },
	merideth = { npc = "Merideth Carlson", id = 2357, m = 1424, x = 52.18, y = 55.50 },
	-- Inside a dungeon: the arrow points at the Dire Maul West door / the stairs to Scholomance (AFGELEID).
	equineSpirit = { npc = "Ancient Equine Spirit", id = 14566, m = 1444, x = 60.32, y = 30.16 },
	fallenCharger = { npc = "Darkreaver's Fallen Charger", id = 14568, m = 1422, x = 69.94, y = 74.03 },
	-- Horde (Undead)
	sarvis = { npc = "Shadow Priest Sarvis", id = 1569, m = 1420, x = 30.84, y = 66.20 },
	aramis = { npc = "Aramis Hammerhand", id = 244808, m = 1420, x = 30.97, y = 66.77 },
	shari = { npc = "Shari Stilwell", id = 246152, m = 1420, x = 60.20, y = 52.50 },
	breton = { npc = "Breton Samuels", id = 246349, m = 1420, x = 21.85, y = 45.21 },
	jorin = { npc = "Jorin Croge", id = 246393, m = 1420, x = 22.70, y = 44.68 },
	danitha = { npc = "Danitha Morr", id = 246378, m = 1420, x = 22.09, y = 44.66 },
	sylvanas = { npc = "Lady Sylvanas Windrunner", id = 10181, m = 1458, x = 58.06, y = 91.78 },
	tanis = { npc = "Tanis Alderwood", id = 257648, m = 1458, x = 65.45, y = 37.47 },
	billmuth = { npc = "Deathguard Billmuth", id = 257655, m = 1420, x = 21.9, y = 44.5 },
	falgan = { npc = "Deathguard Falgan", id = 257663, m = 1420, x = 86.7, y = 47.7 },
	trevan = { npc = "Trevan Rol", id = 248840, m = 1421, x = 43.3, y = 41.0 },
	baldren = { npc = "Deathguard Baldren", id = 259611, m = 1421, x = 45.8, y = 41.8 },
	charredRemains = { npc = "Charred Remains", m = 1421, x = 64.9, y = 34.4 }, -- an object: no id, English name
	luminaFenris = { npc = "Lumina Windsinger", id = 248755, m = 1421, x = 65.5, y = 23.5 },
	luminaSepulcher = { npc = "Lumina Windsinger", id = 259620, m = 1421, x = 43.3, y = 41.0 },
	ulric = { npc = "Ulric Frostveil", id = 259649, m = 1440, x = 11.8, y = 34.5 },
	ott = { npc = "Ott", id = 3539, m = 1424, x = 60.4, y = 26.2 },
	garen = { npc = "Garen Largo", id = 260093, m = 1458, x = 47.50, y = 14.90 },
	alodan = { npc = "Alodan the Hopeful", id = 246344, m = 1456, x = 25.40, y = 14.60 },
	zayus = { npc = "Zayus", id = 5994, m = 1454, x = 35.7, y = 86.9 },
	-- Objective places (no NPC)
	defiasWizards = { m = 1429, x = 74.07, y = 51.57 },
	darkIronSpies = { m = 1426, x = 77.39, y = 61.27 },
	bailorsOre = { m = 1432, x = 71.62, y = 21.55 },
	deadmines = { m = 1436, x = 42.57, y = 71.83 },
	bfd = { m = 1440, x = 14.12, y = 13.88 },
	scourgestones = { m = 1422, x = 40.65, y = 70.27 },
	terrordale = { m = 1423, x = 15.97, y = 25.26 },
	stratGate = { m = 1423, x = 41.43, y = 17.71 },
	deathguards = { m = 1420, x = 31.98, y = 64.72 },
	vileFin = { m = 1420, x = 14.68, y = 54.75 },
	hilda = { m = 1420, x = 21.95, y = 47.24 },
	ander = { m = 1420, x = 25.41, y = 50.41 },
	lumberCrypt = { m = 1420, x = 10.42, y = 65.69 },
	gelhardt = { m = 1420, x = 11.53, y = 64.21 },
	tarnished = { m = 1420, x = 12.87, y = 63.45 },
	oldFireEye = { m = 1421, x = 49.4, y = 86.8 },
}
local PA = PA_P

-- The four things Grimand Elmore / Ott asks for (plus 150 gold); the same order in 7642 and 97179.
local function PaGoods()
	return {
		O(PA.stratGate, "FCQ_OBJ_PA_HOLYWATER", 1),
		O(nil, "FCQ_OBJ_PA_ARTHAS", 2),
		O(nil, "FCQ_OBJ_PA_RUNECLOTH", 3),
		O(nil, "FCQ_OBJ_PA_ARCANITE", 4),
	}
end
local function PaDiamonds()
	return { O(nil, "FCQ_OBJ_PA_AZEROTHIAN", 1), O(nil, "FCQ_OBJ_PA_BLACKDIAMOND", 2) }
end
-- The last quest: open the satchel (objective 2 = the barding), then the Scholomance fight (objective 1 = the soul).
local function PaScholo()
	return { O(nil, "FCQ_OBJ_PA_SATCHEL", 2), O(PA.fallenCharger, "FCQ_OBJ_PA_SCRYER", 1) }
end

CHAINS.PALADIN = {
	-- Redemption (12). DWGN: there is no Gnome paladin (CharBaseInfo), so the extra race does nothing.
	{ key = "redemption", spell = 7328, level = 12, faction = "Alliance", races = HUM, quests = {
		{ q = 2998, alt = { 3681 }, from = PA.wilhelm, to = PA.duthorian },
		{ q = 1641, from = PA.duthorian, to = PA.duthorian },
		{ q = 1642, item = 6775, from = PA.duthorian, to = PA.duthorian },
		{ q = 1643, from = PA.duthorian, to = PA.stephanie },
		{ q = 1644, from = PA.stephanie, objs = { O(nil, "FCQ_OBJ_PA_LINEN", 1) }, to = PA.stephanie },
		{ q = 1780, from = PA.stephanie, to = PA.duthorian },
		{ q = 1781, from = PA.duthorian, to = PA.gazin },
		{ q = 1786, from = PA.gazin, objs = { O(PA.henze, "FCQ_OBJ_PA_RESURRECT") }, to = PA.henze },
		{ q = 1787, from = PA.henze, objs = { O(PA.defiasWizards, "FCQ_OBJ_PA_DEFIAS_SCRIPT", 1) }, to = PA.gazin },
		{ q = 1788, from = PA.gazin, to = PA.duthorian },
	} },
	{ key = "redemption", spell = 7328, level = 12, faction = "Alliance", races = DWGN, quests = {
		{ q = 2999, alt = { 2997, 3000 }, from = PA.brandur, to = PA.tiza },
		{ q = 1645, from = PA.tiza, to = PA.tiza },
		{ q = 1646, item = 6916, from = PA.tiza, to = PA.tiza },
		{ q = 1647, from = PA.tiza, to = PA.johnTurner },
		{ q = 1648, from = PA.johnTurner, objs = { O(nil, "FCQ_OBJ_PA_LINEN", 1) }, to = PA.johnTurner },
		{ q = 1778, from = PA.johnTurner, to = PA.tiza },
		{ q = 1779, from = PA.tiza, to = PA.muiredon },
		{ q = 1783, from = PA.muiredon, objs = { O(PA.narm, "FCQ_OBJ_PA_RESURRECT") }, to = PA.narm },
		{ q = 1784, from = PA.narm, objs = { O(PA.darkIronSpies, "FCQ_OBJ_PA_DARKIRON_SCRIPT", 1) }, to = PA.muiredon },
		{ q = 1785, from = PA.muiredon, to = PA.tiza },
	} },
	-- Verigan's Fist (20). The two side quests of 1654 stand first, so they are asked before the dungeons; they open
	-- after 1653 (AFGELEID). 1652 also teaches Sense Undead 5502 (Wowhead).
	{ key = "veriganore", nameKey = "FCQ_CHAIN_PA_VERIGAN_ORE", level = 20, needs = 1653, faction = "Alliance", quests = {
		{ q = 1655, from = PA.bailor, objs = { O(PA.bailorsOre, "FCQ_OBJ_PA_ORECRATE", 1) }, to = PA.bailor } } },
	{ key = "verigangem", nameKey = "FCQ_CHAIN_PA_VERIGAN_GEM", level = 20, needs = 1653, faction = "Alliance", quests = {
		{ q = 1442, from = PA.thundris, objs = { O(PA.bfd, "FCQ_OBJ_PA_KORGEM", 1) }, to = PA.thundris } } },
	{ key = "verigan", nameKey = "FCQ_CHAIN_PA_VERIGAN", level = 20, faction = "Alliance", quests = {
		{ q = 1793, alt = { 1794 }, from = PA.duthorian, to = PA.duthorian },
		{ q = 1649, item = 6776, from = PA.duthorian, to = PA.duthorian },
		{ q = 1650, from = PA.duthorian, to = PA.daphne },
		{ q = 1651, from = PA.daphne, objs = { O(PA.daphne, "FCQ_OBJ_PA_DEFEND_DAPHNE", 1) }, to = PA.daphne },
		{ q = 1652, from = PA.daphne, to = PA.duthorian },
		{ q = 1653, from = PA.duthorian, to = PA.jordan },
		{ q = 1654, from = PA.jordan, objs = {
			O(PA.bailor, "FCQ_OBJ_PA_ORE", 2),
			O(PA.thundris, "FCQ_OBJ_PA_PURIFIEDGEM", 4),
			O(PA.deadmines, "FCQ_OBJ_PA_LUMBER", 1),
			O(nil, "FCQ_OBJ_PA_HAMMER", 3),
		}, to = PA.jordan },
		{ q = 1806, from = PA.jordan, to = PA.jordan },
	} },
	-- Warhorse (40). A collection mount in Forever? Whether the spell check sees it = NOT measured.
	{ key = "warhorse", spell = 13819, level = 40, faction = "Alliance", quests = {
		{ q = 4485, alt = { 4486 }, from = PA.arthur, to = PA.duthorian },
		{ q = 1661, from = PA.duthorian, to = PA.duthorian },
	} },
	-- Level 50 (quest level 52): an item to choose. Brandur Ironhammer in Ironforge gives 8415 too.
	{ key = "mightstone", nameKey = "FCQ_CHAIN_PA_MIGHTSTONE", level = 50, faction = "Alliance", quests = {
		{ q = 8415, from = PA.grayson, to = PA.ashlam },
		{ q = 8414, from = PA.ashlam, objs = { O(PA.scourgestones, "FCQ_OBJ_PA_SCOURGESTONES", 1) }, to = PA.theldanis },
		{ q = 8416, from = PA.theldanis, to = PA.ashlam },
		{ q = 8418, from = PA.ashlam, objs = {
			O(P.sunken, "FCQ_OBJ_WR_FEATHER_AMBER", 1),
			O(P.sunken, "FCQ_OBJ_WR_FEATHER_BLUE", 2),
			O(P.sunken, "FCQ_OBJ_WR_FEATHER_GREEN", 3),
		}, to = PA.ashlam },
	} },
	-- Charger (60). 7645 (Merideth's horse feed) is asked inside 7643.
	{ key = "charger", spell = 23214, level = 60, faction = "Alliance", quests = {
		{ q = 7638, alt = { 7670 }, from = PA.duthorian, to = PA.grayson },
		{ q = 7637, from = PA.grayson, to = PA.rohan },
		{ q = 7639, from = PA.rohan, to = PA.grayson },
		{ q = 7640, from = PA.grayson, objs = { O(PA.terrordale, "FCQ_OBJ_PA_TERRORDALE", 1) }, to = PA.grayson },
		{ q = 7641, from = PA.grayson, to = PA.grimand },
		{ q = 7642, from = PA.grimand, objs = PaGoods(), to = PA.grimand },
		{ q = 7648, from = PA.grimand, to = PA.grayson },
		{ q = 7643, from = PA.grayson, objs = { O(PA.merideth, "FCQ_OBJ_PA_HORSEFEED", 1) }, to = PA.equineSpirit },
		{ q = 7644, from = PA.equineSpirit, to = PA.grayson },
		{ q = 7646, from = PA.grayson, objs = PaDiamonds(), to = PA.grayson },
		{ q = 7647, from = PA.grayson, objs = PaScholo(), to = PA.fallenCharger },
	} },

	-- Undead. Holy Light (2): opens after The Mindless Ones 364 (Spoken prev). The spell comes when you take 90902
	-- (AFGELEID), so the chain may end there; the quest itself is then in your log.
	{ key = "holylight", spell = 635, level = 2, needs = 364, faction = "Horde", races = UD, quests = {
		{ q = 98601, from = PA.sarvis, to = PA.aramis },
		{ q = 90902, from = PA.aramis, objs = { O(PA.deathguards, "FCQ_OBJ_PA_HEAL_DEATHGUARDS", 1) }, to = PA.aramis },
	} },
	-- Bandarion Keep (from 8): a mace and a shield. Optional; Making Repairs is a side quest of Jorin Croge.
	{ key = "keep", nameKey = "FCQ_CHAIN_PA_KEEP", level = 8, faction = "Horde", races = UD, quests = {
		{ q = 91282, from = PA.shari, to = PA.breton },
		{ q = 91285, from = PA.breton, objs = {
			O(PA.vileFin, "FCQ_OBJ_PA_VILEFIN_ATTACKERS", 1), O(PA.vileFin, "FCQ_OBJ_PA_VILEFIN_SEERS", 2) }, to = PA.breton },
		{ q = 91294, from = PA.breton, objs = {
			O(PA.jorin, "FCQ_OBJ_PA_TOUR_JORIN", 2), O(PA.hilda, "FCQ_OBJ_PA_TOUR_HILDA", 1),
			O(PA.ander, "FCQ_OBJ_PA_TOUR_ANDER", 3), O(PA.danitha, "FCQ_OBJ_PA_TOUR_DANITHA", 4) }, to = PA.danitha },
		{ q = 91316, from = PA.jorin, objs = { O(PA.lumberCrypt, "FCQ_OBJ_PA_STURDY_LUMBER", 1) }, to = PA.jorin },
		{ q = 91317, from = PA.danitha, objs = {
			O(PA.gelhardt, "FCQ_OBJ_PA_GELHARDT", 1), O(PA.tarnished, "FCQ_OBJ_PA_DRUDGES", 2),
			O(PA.tarnished, "FCQ_OBJ_PA_ZEALOTS", 3) }, to = PA.danitha },
		{ q = 95803, from = PA.danitha, to = PA.sylvanas },
	} },
	-- Redemption (12), NEW in Forever. The Scarlet camp is at Falgan's spot in Venomweb Vale (AFGELEID).
	{ key = "redemption", spell = 7328, level = 12, faction = "Horde", races = UD, quests = {
		{ q = 94427, from = PA.danitha, to = PA.tanis },
		{ q = 94434, from = PA.tanis, objs = { O(nil, "FCQ_OBJ_PA_LINEN", 1) }, to = PA.tanis },
		{ q = 94435, from = PA.tanis, to = PA.danitha },
		{ q = 94436, from = PA.danitha, to = PA.billmuth },
		{ q = 94438, from = PA.billmuth, objs = { O(PA.falgan, "FCQ_OBJ_PA_RESURRECT", 1) }, to = PA.falgan },
		{ q = 94440, from = PA.falgan, objs = { O(PA.falgan, "FCQ_OBJ_PA_ATTACK_PLANS", 1) }, to = PA.billmuth },
		{ q = 94441, from = PA.billmuth, to = PA.danitha },
	} },
	-- Wolfsbane (item 267369), NEW in Forever. 91858 can be taken from level 18, 95036 needs 20: level 20 here.
	{ key = "wolfsbanegem", nameKey = "FCQ_CHAIN_PA_WOLFSBANE_GEM", level = 20, needs = 95034, faction = "Horde", races = UD,
		quests = { { q = 95042, from = PA.ulric, objs = { O(PA.bfd, "FCQ_OBJ_PA_KORGEM", 1) }, to = PA.ulric } } },
	{ key = "wolfsbane", nameKey = "FCQ_CHAIN_PA_WOLFSBANE", level = 20, faction = "Horde", races = UD, quests = {
		{ q = 91858, from = PA.danitha, to = PA.trevan },
		{ q = 91859, from = PA.trevan, to = PA.baldren },
		{ q = 91860, from = PA.baldren, to = PA.charredRemains },
		{ q = 91861, from = PA.charredRemains, to = PA.luminaFenris },
		{ q = 91862, from = PA.luminaFenris, objs = { O(PA.luminaFenris, "FCQ_OBJ_PA_FENRIS_KEY", 1) }, to = PA.luminaFenris },
		{ q = 96204, from = PA.luminaFenris, objs = { O(PA.luminaFenris, "FCQ_OBJ_PA_ESCORT_LUMINA", 1) }, to = PA.luminaSepulcher },
		{ q = 95034, from = PA.luminaSepulcher, objs = { O(PA.luminaSepulcher, "FCQ_OBJ_PA_TALK_LUMINA", 1) },
			to = PA.luminaSepulcher },
		{ q = 95036, from = PA.luminaSepulcher, objs = {
			O(PA.trevan, "FCQ_OBJ_PA_WEAPON_NOTES", 1),
			O(PA.ulric, "FCQ_OBJ_PA_PURIFIEDGEM", 4),
			O(PA.deadmines, "FCQ_OBJ_PA_LUMBER", 2),
			O(nil, "FCQ_OBJ_PA_SILVER_INGOT", 3),
		}, to = PA.trevan },
		{ q = 95111, from = PA.trevan, to = PA.ott },
		{ q = 95125, from = PA.ott, objs = { O(PA.ott, "FCQ_OBJ_PA_WATCH_OTT", 1) }, to = PA.ott },
		{ q = 95126, from = PA.ott, to = PA.trevan },
		{ q = 95140, from = PA.luminaSepulcher, objs = { O(PA.oldFireEye, "FCQ_OBJ_PA_OLD_FIREEYE", 1) }, to = PA.luminaSepulcher },
	} },
	-- Warhorse (40), NEW in Forever. Alodan the Hopeful in Thunder Bluff gives 97022 too.
	{ key = "warhorse", spell = 1279399, level = 40, faction = "Horde", races = UD, quests = {
		{ q = 97022, from = PA.garen, to = PA.danitha },
		{ q = 94971, from = PA.danitha, to = PA.danitha },
	} },
	-- Forsaken Charger (60), NEW in Forever. Quest ids measured; most givers AFGELEID from the quest texts. A player
	-- wrote on Wowhead that nothing followed after 97177. Measure in game before trusting this chain.
	-- 97186 (Nathanos Blightcaller's horse feed) is asked inside 97182, without a place (his Forever spot is unknown).
	{ key = "charger", spell = 1296534, level = 60, faction = "Horde", races = UD, quests = {
		{ q = 97174, from = PA.alodan, to = PA.danitha },
		{ q = 97175, from = PA.danitha, to = PA.zayus },
		{ q = 97177, from = PA.zayus, to = PA.danitha },
		{ q = 97176, from = PA.danitha, objs = { O(PA.terrordale, "FCQ_OBJ_PA_TERRORDALE", 1) }, to = PA.danitha },
		{ q = 97178, from = PA.danitha, to = PA.ott },
		{ q = 97179, from = PA.ott, objs = PaGoods(), to = PA.ott },
		{ q = 97180, from = PA.ott, to = PA.danitha },
		{ q = 97182, from = PA.danitha, objs = { O(nil, "FCQ_OBJ_PA_HORSEFEED_H") }, to = PA.equineSpirit },
		{ q = 97183, from = PA.equineSpirit, to = PA.danitha },
		{ q = 97184, from = PA.danitha, objs = PaDiamonds(), to = PA.danitha },
		{ q = 97185, from = PA.danitha, objs = PaScholo(), to = PA.fallenCharger },
	} },
}
```

Let op bij de schets:
- De neven-ketens (`veriganore`, `verigangem`, `wolfsbanegem`) staan vóór hun hoofdketen: zelfde level, dus de tabelvolgorde beslist wat "Do this now" eerst noemt. Vóór 1653 / 95034 zijn ze niet `Ready`.
- Human stap 1 stuurt naar Goldshire (Brother Wilhelm). Is de wegwijzer niet verplicht (A), dan kan stap 1 ook weg en begint de keten bij 1641: keuze voor Rob/bouwchat.
- `O(PA.henze, "FCQ_OBJ_PA_RESURRECT")` heeft bewust geen index.

### enUS-tekstvoorstellen (stijl van de bestaande FCQ-regels)

```lua
	FCQ_CHAIN_PA_VERIGAN = "Verigan's Fist (a two-handed mace)",
	FCQ_CHAIN_PA_VERIGAN_ORE = "Verigan's Fist: Bailor's ore",
	FCQ_CHAIN_PA_VERIGAN_GEM = "Verigan's Fist: the Kor Gem",
	FCQ_CHAIN_PA_MIGHTSTONE = "Commander Valorfist's quests (a reward to choose)",
	FCQ_CHAIN_PA_KEEP = "The Bandarion Keep quests (a mace and a shield)",
	FCQ_CHAIN_PA_WOLFSBANE = "Wolfsbane (a two-handed sword)",
	FCQ_CHAIN_PA_WOLFSBANE_GEM = "Wolfsbane: the Kor Gem",
	FCQ_USE_ITEM_FMT = "use %s in your bags: it starts the next quest.",
	FCQ_OBJ_PA_LINEN = "bring 10 Linen Cloth (it drops from humanoids, or buy it at the Auction House)",
	FCQ_OBJ_PA_RESURRECT = "use the Symbol of Life from your bags on the body here",
	FCQ_OBJ_PA_DEFIAS_SCRIPT = "defeat Defias Rogue Wizards for the Defias Script",
	FCQ_OBJ_PA_DARKIRON_SCRIPT = "defeat Dark Iron Spies for the Dark Iron Script",
	FCQ_OBJ_PA_DEFEND_DAPHNE = "protect Daphne Stilwell: three waves of Defias Raiders come (3, 4 and 5: bring help)",
	FCQ_OBJ_PA_ORECRATE = "loot Bailor's Ore, a crate next to a tree stump (elite ogres around it: bring help)",
	FCQ_OBJ_PA_KORGEM = "get a Corrupted Kor Gem from the naga at Blackfathom Deeps (elites: bring help)",
	FCQ_OBJ_PA_ORE = "you need Jordan's Refined Ore Shipment: do the quest Bailor's Ore Shipment here",
	FCQ_OBJ_PA_PURIFIEDGEM = "you need a Purified Kor Gem: do the quest Seeking the Kor Gem here",
	FCQ_OBJ_PA_LUMBER = "in the dungeon Deadmines (you need a group), defeat Goblin Woodcarvers for Whitestone Oak Lumber",
	FCQ_OBJ_PA_HAMMER = "in the dungeon Shadowfang Keep (you need a group), take Jordan's Smithing Hammer in the stable",
	FCQ_OBJ_PA_SCOURGESTONES = "defeat undead for 20 Minion's Scourgestones",
	FCQ_OBJ_PA_TERRORDALE = "use the Exorcism Censer on the green circles and defeat 25 Terrordale Spirits (bring help)",
	FCQ_OBJ_PA_HOLYWATER = "in the dungeon Stratholme (you need a group), open Supply Crates for 5 Stratholme Holy Water",
	FCQ_OBJ_PA_ARTHAS = "bring 10 Arthas' Tears (a herb: pick it with Herbalism, or buy it at the Auction House)",
	FCQ_OBJ_PA_RUNECLOTH = "bring 40 Runecloth",
	FCQ_OBJ_PA_ARCANITE = "bring 6 Arcanite Bars, and 150 gold",
	FCQ_OBJ_PA_HORSEFEED = "bring 20 Enriched Manna Biscuits (Argent Dawn quartermaster, from Friendly) and 50 gold here: this quest gives the Manna-Enriched Horse Feed. Then defeat Tendris Warpwood in Dire Maul West (you need a group)",
	FCQ_OBJ_PA_HORSEFEED_H = "bring 20 Enriched Manna Biscuits (Argent Dawn quartermaster, from Friendly) and 50 gold to Nathanos Blightcaller in the Eastern Plaguelands: his quest gives the Manna-Enriched Horse Feed. Then defeat Tendris Warpwood in Dire Maul West (you need a group)",
	FCQ_OBJ_PA_AZEROTHIAN = "bring an Azerothian Diamond (from Mining, or buy it at the Auction House)",
	FCQ_OBJ_PA_BLACKDIAMOND = "bring a Pristine Black Diamond (a rare drop in high dungeons, or buy it at the Auction House)",
	FCQ_OBJ_PA_SATCHEL = "open the satchel in your bags: the Divination Scryer and the barding are inside",
	FCQ_OBJ_PA_SCRYER = "in the dungeon Scholomance (you need a group), use the Divination Scryer in the Great Ossuary basement after Rattlegore, then defeat the spirits and Death Knight Darkreaver",
	FCQ_OBJ_PA_HEAL_DEATHGUARDS = "heal 5 Injured Deathguards with Holy Light (it hurts you too: watch your health)",
	FCQ_OBJ_PA_VILEFIN_ATTACKERS = "defeat 8 Vile Fin Attackers",
	FCQ_OBJ_PA_VILEFIN_SEERS = "defeat 8 Vile Fin Seers",
	FCQ_OBJ_PA_TOUR_JORIN = "talk to Jorin Croge (inside)",
	FCQ_OBJ_PA_TOUR_HILDA = "talk to Hilda the Breaker (she walks around)",
	FCQ_OBJ_PA_TOUR_ANDER = "talk to Ander Solliden",
	FCQ_OBJ_PA_TOUR_DANITHA = "talk to Danitha Morr (upstairs)",
	FCQ_OBJ_PA_STURDY_LUMBER = "collect 12 Sturdy Lumber from the Lumber Piles in the crypt",
	FCQ_OBJ_PA_GELHARDT = "defeat Rudolph Gelhardt (upstairs in the house) for his head",
	FCQ_OBJ_PA_DRUDGES = "defeat 8 Tarnished Drudges",
	FCQ_OBJ_PA_ZEALOTS = "defeat 6 Tarnished Zealots",
	FCQ_OBJ_PA_ATTACK_PLANS = "defeat Scarlet Friars and Scarlet Zealots for the Scarlet Crusade Attack Plans",
	FCQ_OBJ_PA_FENRIS_KEY = "defeat Rot Hide gnolls for the Fenris Isle Key and free Lumina Windsinger",
	FCQ_OBJ_PA_ESCORT_LUMINA = "walk with Lumina Windsinger and keep her alive until she is out of Fenris Keep",
	FCQ_OBJ_PA_TALK_LUMINA = "talk to Lumina Windsinger",
	FCQ_OBJ_PA_WEAPON_NOTES = "talk to Trevan Rol for Trevan's Weapon Notes",
	FCQ_OBJ_PA_SILVER_INGOT = "in the dungeon Shadowfang Keep (you need a group), get the Enchanted Silver Ingot",
	FCQ_OBJ_PA_WATCH_OTT = "watch Ott forge the blade",
	FCQ_OBJ_PA_OLD_FIREEYE = "defeat Old Fire-Eye with the Moonsilver Blade (a level 25 elite worgen that roams near the Greymane Wall: bring help)",
```
A in de teksten: "talk to Trevan Rol for the notes" (uit de questtekst), "with the Moonsilver Blade" en "Enchanted Silver Ingot in Shadowfang Keep" (chaosboost), "elite ogres" bij Bailor's Ore (Zygor: level 20 elite-gebied).

### NPC_NAMES-regels

```lua
	-- Paladin (17 Nov 2026, mh-research: Wowhead Forever tooltips per locale, control npc 233). Missing esMX/ptBR = Wowhead
	-- has no name there. 5149 and 1854 esMX from Spoken. 927 esES, 6179/10838/1569 ruRU: Spoken disagrees, Wowhead kept.
	[927] = { deDE = "Bruder Wilhelm", frFR = "Frère Wilhelm", esES = "Hermano Wilhelm", esMX = "Hermano Wilhelm", ptBR = "Irmão Guilhermino", ruRU = "Брат Вильгельм" },
	[6171] = { deDE = "Duthorian Rall", frFR = "Duthorian Rall", esES = "Duthorian Rall", esMX = "Duthorian Rall", ptBR = "Benedito Brião", ruRU = "Даториан Ралл" },
	[6174] = { deDE = "Stephanie Turner", frFR = "Stephanie Turner", esES = "Stephanie Turner", esMX = "Stephanie Turner", ptBR = "Stephanie Turner", ruRU = "Стефани Тернер" },
	[6173] = { deDE = "Gazin Tenorm", frFR = "Gazin Tenorm", esES = "Gazin Tenorm", esMX = "Gazin Tenorm", ptBR = "Gazin Tenorm", ruRU = "Газин Тенорм" },
	[6172] = { deDE = "Henze Faulk", frFR = "Henze Faulk", esES = "Henze Faulk", esMX = "Henze Faulk", ptBR = "Henze Faulk", ruRU = "Хенз Фолк" },
	[5149] = { deDE = "Brandur Ironhammer", frFR = "Brandur Ironhammer", esES = "Brandur Martiyerro", esMX = "Brandur Martiyerro", ptBR = "Brandur Ferromalho", ruRU = "Брандар Железный Молот" },
	[6179] = { deDE = "Tiza Battleforge", frFR = "Tiza Battleforge", esES = "Tiza Forjabatalla", esMX = "Tiza Forjabatalla", ptBR = "Tiza Beloforja", ruRU = "Тиза Кузнебой" },
	[6175] = { deDE = "John Turner", frFR = "John Turner", esES = "John Turner", esMX = "John Turner", ptBR = "João Turner", ruRU = "Джон Тернер" },
	[6178] = { deDE = "Muiredon Battleforge", frFR = "Muiredon Battleforge", esES = "Muiredon Forjabatalla", esMX = "Muiredon Forjabatalla", ptBR = "Muiredon Beloforja", ruRU = "Майридон Кузнебой" },
	[6177] = { deDE = "Narm Faulk", frFR = "Narm Faulk", esES = "Narm Faulk", esMX = "Narm Faulk", ptBR = "Narm Faulk", ruRU = "Нарм Фолк" },
	[6182] = { deDE = "Daphne Stilwell", frFR = "Daphne Stilwell", esES = "Daphne Fontana", esMX = "Daphne Fontana", ptBR = "Dafne Calmafonte", ruRU = "Дафна Стилвелл" },
	[6181] = { deDE = "Jordan Stilwell", frFR = "Jordan Stilwell", esES = "Jordan Fontana", esMX = "Jordan Fontana", ptBR = "Jardel Calmafonte", ruRU = "Джордан Стилвелл" },
	[6241] = { deDE = "Bailor Stonehand", frFR = "Bailor Stonehand", esES = "Bailor Petramano", esMX = "Bailor Petramano", ptBR = "Bailor Manopedra", ruRU = "Балор Крепкорук" },
	[3649] = { deDE = "Thundris Windwirker", frFR = "Thundris Windweaver", esES = "Thundris Tejevientos", esMX = "Thundris Tejevientos", ptBR = "Trovejius Tecevento", ruRU = "Тандрис Ветропряд" },
	[5491] = { deDE = "Arthur der Treue", frFR = "Arthur le Fidèle", esES = "Arthur el Leal", esMX = "Arthur el Leal", ptBR = "Artur, o Fiel", ruRU = "Артур Верный" },
	[928] = { deDE = "Lord Grayson Shadowbreaker", frFR = "Seigneur Grayson Shadowbreaker", esES = "Lord Grisillo Quiebrasombras", esMX = "Lord Grisillo Quiebrasombras", ptBR = "Lorde Grayson Quebrassombra", ruRU = "Лорд Грейсон Тенелом" },
	[10838] = { deDE = "Kommandant Ashlam Valorfist", frFR = "Commandant Ashlam Valorfist", esES = "Comandante Ashlam Puñovalor", esMX = "Comandante Ashlam Puñovalor", ptBR = "Comandante Ashlam Punhobom", ruRU = "Командир Ашлам Отважный Кулак" },
	[1854] = { deDE = "Hohepriester Thel'danis", frFR = "Grand prêtre Thel'danis", esES = "Sumo Sacerdote Thel'danis", esMX = "Sumo sacerdote Thel'danis", ptBR = "Sumo Sacerdote Thel'danis", ruRU = "Верховный жрец Тель'данис" },
	[11406] = { deDE = "Hohepriester Rohan", frFR = "Grandprêtre Rohan", esES = "Sumo Sacerdote Rohan", esMX = "Sumo sacerdote Rohan", ptBR = "Sumo Sacerdote Rohan", ruRU = "Верховный жрец Рохан" },
	[1416] = { deDE = "Grimand Elmore", frFR = "Grimand Elmore", esES = "Grimand Elmore", esMX = "Grimand Elmore", ptBR = "Grimand Elmore", ruRU = "Гриманд Элмор" },
	[2357] = { deDE = "Merideth Carlson", frFR = "Merideth Carlson", esES = "Merideth Carlson", ptBR = "Judite Castanheira", ruRU = "Меридет Карлсон" },
	[14566] = { deDE = "Uralter Pferdegeist", frFR = "Ancien esprit équin", esES = "Antiguo espíritu equino", ptBR = "Espírito Equino Antigo", ruRU = "Дух древнего коня" },
	[14568] = { deDE = "Schattensichels gefallenes Streitross", frFR = "Destrier déchu de Ravassombre", esES = "Arremetedor Atracoscuro", ptBR = "Corcel Caído de Noctilatrus", ruRU = "Падший скакун Темного Терзателя" },
	[1569] = { deDE = "Schattenpriester Sarvis", frFR = "Prêtre des ombres Sarvis", esES = "Sacerdote de las Sombras Sarvis", esMX = "Sacerdote de las Sombras Sarvis", ptBR = "Sacerdote Sombrio Sarvis", ruRU = "Жрец Тьмы Сарвис" },
	[244808] = { deDE = "Aramis Hammerhand", frFR = "Aramis Mainmartel", esES = "Aramis Manomartillo", esMX = "Aramis Manomartillo", ptBR = "Aramis Cerramartelo", ruRU = "Арамис Хаммерхенд" },
	[246152] = { deDE = "Shari Stilwell", frFR = "Shari Morpuits", esES = "Shari Fontana", esMX = "Shari Fontana", ptBR = "Shária Calmafonte", ruRU = "Шари Стилвелл" },
	[246349] = { deDE = "Brenton Samuels", frFR = "Breton Samuels", esES = "Breton Samuels", esMX = "Breton Samuels", ptBR = "Bretônio Samuel", ruRU = "Бретон Самуэльс" },
	[246393] = { deDE = "Jorin Croge", frFR = "Jorin Croge", esES = "Jorin Croge", esMX = "Jorin Croge", ptBR = "Jorin Croge", ruRU = "Джорин Крог" },
	[246378] = { deDE = "Danitha Morr", frFR = "Danitha Morr", esES = "Danitha Morr", esMX = "Danitha Morr", ptBR = "Danitha Morr", ruRU = "Данита Морр" },
	[10181] = { deDE = "Fürstin Sylvanas Windrunner", frFR = "Dame Sylvanas Windrunner", esES = "Lady Sylvanas Brisaveloz", esMX = "Lady Sylvanas Brisaveloz", ptBR = "Grande Dama Sylvana Correventos", ruRU = "Леди Сильвана Ветрокрылая" },
	[257648] = { deDE = "Tanis Alderwood", frFR = "Tanis Aulnebois", esES = "Tanis Alderwood", esMX = "Tanis Alisero", ptBR = "Tanis Amieiro", ruRU = "Танис Элдервуд" },
	[257655] = { deDE = "Todeswache Billmuth", frFR = "Nécrogarde Billmuth", esES = "Guardia de la Muerte Billmuth", esMX = "Guardia de la Muerte Billmuth", ptBR = "Necroguarda Billmuth", ruRU = "Страж смерти Билмут" },
	[257663] = { deDE = "Todeswache Falgan", frFR = "Nécrogarde Falgan", esES = "Guardia de la Muerte Falgan", esMX = "Guardia de la Muerte Falgan", ptBR = "Necroguarda Falgan", ruRU = "Страж смерти Фалган" },
	[248840] = { deDE = "Trevan Rol", frFR = "Trevan Rol", esES = "Trevan Rol", esMX = "Trevan Rol", ptBR = "Trevano Rol", ruRU = "Треван Рол" },
	[259611] = { deDE = "Todeswache Baldren", frFR = "Nécrogarde Baldren", esES = "Guardia de la Muerte Baldren", esMX = "Guardia de la muerte Baldren", ptBR = "Necroguarda Baldreno", ruRU = "Страж смерти Балдрен" },
	[248755] = { deDE = "Lumina Windsinger", frFR = "Lumina Chantelevent", esES = "Lumina Vientocantor", esMX = "Lumina Vientocantor", ptBR = "Lúmina Cantavento", ruRU = "Люмина Песнь Ветра" },
	[259620] = { deDE = "Lumina Windsinger", frFR = "Lumina Chantelevent", esES = "Lumina Vientocantor", ruRU = "Люмина Песнь Ветра" },
	[259649] = { deDE = "Ulric Frostveil", frFR = "Ulric Voile-de-givre", esES = "Ulric Veloescarcha", esMX = "Ulric Veloscarcha", ptBR = "Ulorico Glacivéu", ruRU = "Ульрик Фроствейл" },
	[3539] = { deDE = "Ott", frFR = "Ott", esES = "Ott", esMX = "Ott", ptBR = "Ott", ruRU = "Отт" },
	[260093] = { deDE = "Garen Largo", frFR = "Garen Largo", esES = "Garen Largo", esMX = "Garen Largo", ptBR = "Gareno Largo", ruRU = "Гарен Ларго" },
	[246344] = { deDE = "Alodan der Hoffnungsvolle", frFR = "Alodan l'Optimiste", esES = "Alodan el Esperanzado", esMX = "Alodan, el Optimista", ptBR = "Alodor, o Esperançoso", ruRU = "Алодан Жизнерадостный" },
	[5994] = { deDE = "Zayus", frFR = "Zayus", esES = "Zayus", esMX = "Zayus", ptBR = "Zayus", ruRU = "Зайус" },
```

## 10. Open / niet gemeten

1. Niets is in het spel gezien: alle quest-id's, coördinaten en de objective-index wachten op `/mh classquest` van een paladin.
2. Zijn de wegwijzers verplicht (2998/3681, 2997/2999/3000, 4485/4486, 7638/7670, 97022, 97174)? AW toont ze als "prerequisite", Zygor slaat ze bij Human over. Niet gemeten.
3. Gever van 4485: Arthur the Faithful (Spoken, forg.gg) of Tiza Battleforge (AW).
4. Quests die uit een item starten (1642, 1646, 1649) vragen een kleine uitbreiding van `Step` (zie 9).
5. Ziet `IsPlayerSpell` de mounts (13819, 1279399, 23214, 1296534)? En leert 7647 echt 23214? WH Forever toont daar geen spell.
6. Forsaken Charger (97174-97185): gevers en inleveraars grotendeels afgeleid; een speler meldt op Wowhead dat het na 97177 stokte. Nathanos' plek in de grotere Forever-kaart is onbekend.
7. Moet je de Bandarion Keep-quests doen vóór 94427? forg.gg zegt ja, Zygor neemt 94427 eerder aan. Niet gemeten.
8. Gaan 1655 en 1442 (en 95042) pas open met 1654 (95036) in je log? Aanname in de schets: na 1653 (95034).
9. Wolfsbane: waar in Shadowfang Keep de Enchanted Silver Ingot ligt; de ingang van Shadowfang Keep als coördinaat.
10. Terrordale (Zygor 15.97, 25.26): Eastern Plaguelands heeft in Forever een grotere kaart; dat Zygors getal al in die kaart staat is afgeleid (de Service Gate is wel omgerekend).
11. Namen: esMX voor 2357, 14566, 14568, 259620 en ptBR voor 259620 ontbreken op Wowhead. Vier namen waar Spoken en Wowhead verschillen (zie 7).
12. Niet uitgezocht: Cloak of the Divine Storm (78088-78093), de Aeonas-quests (Alliance 35+), The Reliquary of Tyr (Undead 50, 93030 → 99187), The Errant Knight, Where's The Squire? (zie 4.13). Hoe Undead-paladins Sense Undead leren.
13. `ForeverTrainer.lua`: 5502 Sense Undead staat mogelijk ten onrechte als trainer-spell voor Alliance-paladins (Wowhead: quest 1652). Niet in de trainerdata nagekeken.
