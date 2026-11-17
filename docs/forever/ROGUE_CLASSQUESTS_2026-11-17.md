# Rogue class-quests in WoW Forever (1.60.1.70938) — feiten voor `Modules/ForeverClassQuests.lua`

mh-research, 17 nov 2026. Alleen gelezen en opgezocht; niets in het spel gemeten. Elke bewering heeft **GEMETEN** (gezien in
een genoemde bron) of **AFGELEID** (beredeneerd). Quest-id's blijven onbewezen tot de client ze afvinkt (`/mh classquest`).

🔴 Belangrijkste vondst: Forever heeft **twee nieuwe rogue-ketens** die Zygor niet kent en die NIET in Spokens
`Compendium.lua` staan: **The Horn of Xelthos** (78261 → 78307, ring) en **The Eye of Bhossca** (78676 → 78699, dolk).
De zoekopdracht `classes = 8` in het Compendium vond druid 98393 wél (positieve controle) maar deze niet: het Compendium
is van build 70450 en mist ze. Ze staan wel in Spokens geluidspakket, op Wowhead Forever, Icy Veins DB, Polestar en WowSeer.

## 1. Bronnen

| Afk. | Bron | Datum / build | Gebruikt voor |
|---|---|---|---|
| Z-AC | Zygor Forever `ZygorLevelingAllianceCLASSIC.lua` r. 22466-22694 ("Rogue Class Quests") | lokaal, gelezen 17 nov | Alliance: dwarf-L10, Poisons, level 50 |
| Z-AL | idem, hoofdgids r. 975, 1163-1166, 3966-4092, 5757-5768, 5878-5916 | lokaal | Human/NE L10, Renzik, Lucius, lockbox |
| Z-HC | `ZygorLevelingHordeCLASSIC.lua` r. 24253-24503 ("Rogue Class Quests") | lokaal | Horde: Poisons, level 50 |
| Z-HL | idem, hoofdgids r. 966-978, 1514-1521, 3765-3767, 4189-4193, 4762-4782, 4992-4996, 5258-5292, 5383-5430, 8831 | lokaal | Orc/Troll/Undead L10, level 16 |
| Z-P | `ZygorProfessionsAllianceCLASSIC.lua` r. 8516-8550, `...HordeCLASSIC.lua` r. 7992-8042 (Lockpicking) | lokaal | level 16-ketens |
| Z-C | `ZygorLevelingCommonCLASSIC.lua` r. 89-94, 149-157, 1160-1163 | lokaal | Skyborne |
| Z-D | `ZygorDungeonHordeCLASSIC.lua` r. 587 | lokaal | ingang Scarlet Monastery |
| SP-C | Spoken `Spoken_Quests\Data\Compendium.lua` (client 1.60.1.**70450** + Efficient Games) | lokaal | prev, ender, races, classes |
| SP-QL | Spoken `SpokenQuestsAudioShared\generated\questlog_npc_lookups.lua` / `questlog_object_lookups.lua` / `questlog_item_lookups.lua` | lokaal | questgever per quest |
| SP-ID | Spoken `...\generated\quest_id_lookups.lua` | lokaal | nieuwe quest-id's (78xxx, 96xxx) |
| SP-N | Spoken `Spoken_Quests\Locale\Names\<taal>.lua` + regel in `DataModules.lua:879-882` | lokaal | NPC-namen per taal |
| HN | `HandyNotes_ClassTrainers\Data.lua` (Forever 1.60.1.70532) | lokaal | trainer-coördinaten, UiMap-id's |
| WH | Wowhead Forever questpagina `https://www.wowhead.com/forever/quest=<id>` | opgehaald 17 nov 2026 | doelen, serie, beloning |
| WH-T | Wowhead tooltip-JSON `https://nether.wowhead.com/forever/tooltip/{quest,npc,object}/<id>[?locale=]` | opgehaald 17 nov 2026 | doelvolgorde, spawns, namen per taal |
| DB2 | wago.tools DB2-CSV build 1.60.1.70938. `CharBaseInfo` via het web (`wago.tools/db2/CharBaseInfo/csv?build=1.60.1.70938`); `UiMap`, `SpellLevels`, `SpellEffect`, `SpellName`, `QuestV2`, `Item`, `ItemSparse` gelezen uit de lokale cache van `gamedata.py` (`%LOCALAPPDATA%\MidnightHelper\gamedata_cache\db2\1.60.1.70938\`, alleen Grep/Read, voordeur niet gebruikt) | 70938 | rassen, kaart-id's, spell-level, leerspells |
| IV | Icy Veins "WoW Forever Rogue Class Quests Guide" `icy-veins.com/wow-forever/rogue-class-quests` | bijgewerkt 4 nov 2026 | ketens, wat leert wat |
| IVDB | Icy Veins Database `db.icy-veins.com/wow-forever/quests/<id>` | "added 1.60.1.70532" | level, start/eind, coördinaten |
| PS | Polestar `polestar.guide/guides/class/rogue/...` (10 rogue-gidsen) | 7-15 nov 2026 | stappen, rassen, nieuwe ketens |
| S60 | stillsixty `stillsixty.com/guides/rogue-class-quests` | bijgewerkt 10 nov 2026 | overzicht, "new in Forever" |
| WS | WowSeer `wowseer.gg/quest/<id>` | opgehaald 17 nov 2026 | required level, start/eind |
| WT | Warcraft Tavern Forever poisons-/lockpicking-gids | geen datum (beelden okt 2026) | Pick Lock = trainer |
| UGT | UrGameTips "Tools of the Trade ... in WoW: Forever" | 6 nov 2026 | Ambermill Strongbox |
| FDB | ForeverDB `foreverdb.net/guide/windshaper-skyborne-rogue` | 17 nov 2026, "checked against 70938" | Skyborne |

Positieve controles in dezelfde run: Spoken-Compendium `[98393]` gevonden (druid); `questlog_npc_lookups` 3102 → 197 en
5923 → 4218 (kloppen met MH); Wowhead-tooltip npc 233 `?locale=deDE` = "Bauer Saldean"; Spoken deDE `[233]` = "Bauer Saldean";
Zygor-grep `Lucius##6966` raak in dezelfde run als de lege grep op Xelthos/Bhossca/Veenix/Dead Drop/Myrokos.

## 2. Wie kan rogue zijn

GEMETEN (DB2 `CharBaseInfo` 70938, rijen met ClassID 4): ras 1 Human, 2 Orc, 3 Dwarf, 4 NightElf, 5 Scourge, 7 Gnome,
8 Troll, 95 Skyborne (High Order, Alliance), 96 Skyborne (Windshaper, Horde). **Geen Tauren** (ras 6 heeft alleen klasse
1, 3, 7, 11). S60 zegt hetzelfde ("every race but Tauren").

## 3. Spells en welke quest ze leert

| Spell | Feit | Status |
|---|---|---|
| **Poisons 2842** | `SpellLevels`: SpellLevel 20. Leerspells `2995` en `364159` (beide "Poisons", effect 36 → 2842, plus skill 40) | GEMETEN (DB2 70938) |
| Poisons, Alliance | Beloning van **2359 Klaven's Tower** ("Spell learned: Poisons (spell=2842)" + Recipe: Thistle Tea 18160) | GEMETEN (WH 2359; IV; PS "Master Mathias Shaw: Poisons") |
| Poisons, Horde | Beloning van **2480 Hinott's Assistance** ("You will learn: Poisons 2842" + Hinott's Oil 8095). 2478 geeft alleen Recipe: Thistle Tea | GEMETEN (WH 2480 en 2478; IV; PS) |
| Poisons via trainer? | Nee: "Forever teaches Poisons through this chain, not the trainer" | GEMETEN (PS, 15 nov 2026); niet in het spel gemeten |
| `ns.FOREVER_QUEST_FIRST[2842]` | Staat er: `Modules/ForeverTrainer.lua:40` `[2842] = true, -- Rogue: Poisons (20)`. Klopt met het bovenstaande | GEMETEN (bestand gelezen) |
| **Pick Lock 1804** | Komt van de **trainer** op level 16, niet uit een quest (Zygor: "Train the Pick Lock Ability" bij Lord Tony Romano / Gest / Ormok / Osborne; WT: "any Rogue Trainer") | GEMETEN (Z-AC r. 22502, Z-HC r. 24267, Z-P, WT). `SpellLevels` zegt SpellLevel 1; level 16 is dus een trainer-eis: AFGELEID |
| Thieves' Tools 5060 | Geen spell maar een item; nodig voor Pick Lock. Uit quest 2282 (Alliance, "Provided item"), uit Wrenix' machine (Horde, 2381), van Estelle Gendry (Undead), of te koop | GEMETEN (WH 2282, WH-T 2381, WH 1999, WT, PS) |
| Of `IsPlayerSpell(2842)` waar wordt | Niet gemeten. Poisons is een vak-spell (opent het maakvenster) | NIET GEMETEN |

Geen andere rogue-spell komt uit een quest: GEMETEN alleen voor wat WH per quest als "you will learn" toont (alle quests
hieronder nagelopen; alleen 2359 en 2480 tonen een spell).

## 4. De ketens

Rasmaskers uit SP-C: `4294967373` = alle Alliance-rassen + Skyborne-Alliance (bit 32); `8589934770` = alle Horde-rassen +
Skyborne-Horde (bit 33); `130` = Orc + Troll; `2` = Orc; `16` = Undead. GEMETEN (SP-C kop r. 4-9 legt de bits uit).

### 4a. Blade of Cunning (item 7298), level 10 — per ras

Beloning "Blade of Cunning (item 7298)" GEMETEN op WH 2206, 2239, 2242, 1858, 1978. Vanaf level 10: GEMETEN (IV, PS, S60;
Zygor `ding 10`); S60 toont "Requires 10" bij 1963/1858/1886-1978.

| q | Naam | Gever | Inleveraar | Doel | Status |
|---|---|---|---|---|---|
| **Human (+ Skyborne-Alliance)** | | | | | |
| 2205 | Seek out SI: 7 | Keryn Sylvius (917) | Master Mathias Shaw (332) | pakje brengen | GEMETEN gever SP-QL, ender SP-C, Z-AL r. 975/1165, PS |
| 2206 | Snatch and Grab | Master Mathias Shaw (332) | zelfde | Defias Shipping Schedule (7675) zakkenrollen bij de Defias Dockmaster (6846) | GEMETEN SP-QL (332), SP-C prev 2205, WH, WH-T, IV, PS. Niet in Zygor |
| **Dwarf / Gnome** | | | | | |
| 2218 | Road to Salvation | Hogral Bakkan (1234) | Hulfdan Blackbeard (5165) | — | GEMETEN Z-AC r. 22472-22478, SP-QL, SP-C |
| 2238 | Simple Subterfugin' | Hulfdan Blackbeard | Onin MacHammar (6886) | — | GEMETEN Z-AC r. 22482-22485, SP-C ender 6886 |
| 2239 | Onin's Report | Onin MacHammar | Hulfdan Blackbeard | Onin's Report (7715) wordt meegegeven | GEMETEN Z-AC r. 22488-22490, SP-QL (6886), WH |
| **Night Elf** | | | | | |
| 2241 | The Apple Falls | Jannok Breezesong (3599) | Syurna (4163) | — | GEMETEN Z-AL r. 3966-3994, SP-QL, SP-C |
| 2242 | Destiny Calls | Syurna | Syurna | Sethir's Journal (7737) zakkenrollen bij Sethir the Ancient (6909) | GEMETEN Z-AL r. 4022 (`q 2242/1`), 4092; WH; IV |
| **Orc** (1859 is alleen voor Orc; Troll begint bij 1963) | | | | | |
| 1859 | Therzok | Kaplak (3170) | Therzok (6446) | — | GEMETEN SP-C races = 2, Z-HL r. 3767/4192, PS "Orc only ... only a pointer" |
| 1963 | The Shattered Hand | Therzok | Therzok | Tazan (6494) doden, Tazan's Satchel (7209) | GEMETEN SP-C races = 130, Z-HL r. 4996 (`q 1963/1`), WH |
| 1858 | The Shattered Hand | Therzok | Therzok | Tazan's Key (7208) zakkenrollen bij Gamon; satchel openen → Tazan's Logbook (7295) | GEMETEN Z-HL r. 5268-5292, WH, WH-T |
| **Undead** | | | | | |
| 1885 | Mennet Carkad | Marion Call (2130) | Mennet Carkad (6467) | — | GEMETEN Z-HL r. 973-977, SP-QL |
| 1886 | The Deathstalkers | Mennet Carkad | Mennet Carkad | Astor's Letter of Introduction (7231): praat met Astor Hadren (6497), dan doden | GEMETEN Z-HL r. 1514-1521 (`q 1886/1`), WH |
| 1898 | The Deathstalkers | Mennet Carkad | Andron Gant (6522) | — | GEMETEN Z-HL r. 4764-4768, SP-C ender 6522 |
| 1899 | The Deathstalkers | Andron Gant | Mennet Carkad | Andron's Ledger (7294) uit Andron's Bookshelf | GEMETEN Z-HL r. 4772-4777 (`q 1899/1`), SP-QL (6522) |
| 1978 | The Deathstalkers | Mennet Carkad | Varimathras (2425) | ledger afleveren | GEMETEN SP-QL (6467), SP-C ender 2425, WH. Zygor-plek fout, zie §8 |

- Troll: "Trolls: take The Shattered Hand from him at 10" GEMETEN (PS 7 nov); dat 1963 zonder 1859 kan = AFGELEID uit PS +
  het masker (SP-C zegt wel `prev = 1859`).
- Skyborne-Alliance: PS noemt de Human-route "(Human, Skyborne only)"; het masker van 2205/2206 bevat Skyborne-Alliance
  (GEMETEN SP-C). Dat een Skyborne hem echt krijgt: AFGELEID, niet in het spel gemeten.
- Skyborne-Horde: **geen Blade-keten**. GEMETEN: maskers 2/130/16 bevatten bit 33 niet (SP-C); PS noemt geen Skyborne in
  de Horde-gids.
- Of de drie Alliance-ketens elkaar uitsluiten: NIET GEMETEN.

### 4b. Thieves' Tools / eerste slot, level 16

Vanaf level 16: GEMETEN (S60 "Requires 16" bij 2282, 2381, 1999; PS; Z-P "at least level 16").

| q | Naam | Gever | Inleveraar | Doel | Status |
|---|---|---|---|---|---|
| **Alliance (alle rassen)** | | | | | |
| 2281 | Redridge Rendezvous | Renzik "The Shiv" (6946) | Lucius (6966) | — | GEMETEN Z-AL r. 5766-5768, 5879; Z-P; SP-QL; SP-C zonder `prev` |
| 2282 | Alther's Mill | Lucius | Lucius | Thieves' Tools (5060) krijg je mee; oefenen op Practice Lockboxes; Lucius's Lockbox → Token of Thievery (7871). Beloning: Certificate of Thievery (7907) | GEMETEN Z-AL r. 5892-5915 (`q 2282/1`), WH |
| **Horde (alle rassen, ook Skyborne-Horde: masker)** | | | | | |
| 2379 | Zando'zan | Shenthul (3401) | Zando'zan (3402) | — | GEMETEN Z-HL r. 5261-5274, Z-P r. 8005-8009, SP-QL |
| 2382 | Wrenix of Ratchet | Zando'zan | Wrenix the Wretched (7161) | — | GEMETEN Z-HL r. 5275/5383, SP-QL (3402) |
| 2381 | Plundering the Plunderers | Wrenix | Wrenix | E.C.A.C. (7970) + Thieves' Tools (5060) uit Wrenix's Gizmotronic Apparatus (7166); The Jewel of the Southsea openen, E.C.A.C. op Polly (7167), Southsea Treasure (7968). Beloning: Thistle Tea (7676; PS/S60: tien stuks) | GEMETEN Z-HL r. 5387-5430 (`q 2381/1`), Z-P, WH, WH-T |

Voorloopjes (wegwijzers, niet in de schets): Alliance 2300 SI:7 (Keryn Sylvius → Renzik), 2299 To Hulfdan! (Hogral Bakkan →
Hulfdan) → 2298 Kingly Shakedown (Hulfdan → Renzik), 2259 Erion Shadewhisper (Jannok Breezesong → Erion 4214) → 2260
Erion's Behest (Erion → Renzik). Horde 2380 To Orgrimmar! (Kaplak → Shenthul), 2378 Find the Shattered Hand (Mennet Carkad →
Shenthul). GEMETEN: gevers SP-QL, enders SP-C, series WH, PS. Dat 2281 en 2379 zonder voorloopje kunnen: GEMETEN in Zygor
(neemt ze direct aan), SP-C geeft 2281 geen `prev` maar 2379 wél `prev = 2378` → voor 2379 **AFGELEID**.

### 4c. Poisons (spell 2842), level 20

| q | Naam | Gever | Inleveraar | Doel | Status |
|---|---|---|---|---|---|
| **Alliance** | | | | | |
| 2360 | Mathias and the Defias | Master Mathias Shaw (332) | Agent Kearnen (7024) | — | GEMETEN Z-AC r. 22524-22539, SP-QL, WH |
| 2359 | Klaven's Tower | Agent Kearnen | Master Mathias Shaw | Defias Tower Key (7923) zakkenrollen bij Malformed Defias Drone; Duskwood Chest (slot, Lockpicking ~70-75) → Klaven Mortwake's Journal (7908). **Leert Poisons** + Recipe: Thistle Tea | GEMETEN Z-AC r. 22543-22564 (`q 2359/2`, `/1`), WH, WS (required level 20), IV, PS |
| **Horde** | | | | | |
| 2460 | The Shattered Salute | Shenthul (3401) | Shenthul | wacht op zijn groet, dan `/salute` | GEMETEN Z-HC r. 24280-24294 (`q 2460/1`), WH ("Shattered Salute Performed (1)") |
| 2458 | Deep Cover | Shenthul | Taskmaster Fizzule (7233) | Flare Gun (8051) twee keer afvuren, dan `/salute` op Fizzule. Beloning Fizzule's Whistle (8066) | GEMETEN Z-HC r. 24295-24308, WH, IV, PS |
| 2478 | Mission: Possible But Not Probable | Taskmaster Fizzule | Shenthul | zie objective-tabel §6. Beloning Recipe: Thistle Tea (18160) | GEMETEN Z-HC r. 24309-24355, WH, WH-T |
| 2479 | Hinott's Assistance | Shenthul | Serge Hinott (2391) | Sample of Zanzil's Altered Mixture (8087) wordt meegegeven | GEMETEN Z-HC r. 24356-24392, SP-C ender 2391, WH |
| 2480 | Hinott's Assistance | Serge Hinott | Serge Hinott | wachten tot de kuur klaar is. **Leert Poisons** + Hinott's Oil (8095) | GEMETEN Z-HC r. 24393-24403 (`q 2480/1`), WH, IV, PS |

Skyborne doet de factie-keten: masker bevat Skyborne (GEMETEN SP-C); in het spel NIET gemeten.

### 4d. Touch of Zanzil genezen (Alliance), na 2359 — optioneel

| q | Naam | Gever | Inleveraar | Doel | Status |
|---|---|---|---|---|---|
| 2607 | The Touch of Zanzil | Master Mathias Shaw | Doc Mixilpixil (7207) | — | GEMETEN Z-AC r. 22565-22570, SP-C prev 2359, SP-QL |
| 2608 | The Touch of Zanzil | Doc Mixilpixil | Doc Mixilpixil | `/lay` met de Doc als doelwit | GEMETEN Z-AC r. 22571-22581 (`q 2608/1`), WH |
| 2609 | The Touch of Zanzil | Doc Mixilpixil | Doc Mixilpixil | Simple Wildflowers (3421), Leaded Vial (3372), Bronze Tube (4371), Spool of Light Chartreuse Silk Thread (8431). Beloning Eau de Mixilpixil (8432) | GEMETEN WH, WH-T, SP-QL (7207), IV, PS. Niet in Zygor |

Horde heeft dit niet apart: 2480 geneest én leert Poisons (GEMETEN IV, PS).

### 4e. NIEUW in Forever: The Horn of Xelthos (ring), beide facties

| q | Naam | Gever | Inleveraar | Doel | Status |
|---|---|---|---|---|---|
| 78261 | The Horn of Xelthos | Dead Drop (object 410369) | Dead Drop | doel 1 Horn of Xelthos (210183) uit Shadowfang Keep, alleen; doel 2 Find Veenix (4086) | GEMETEN WH, IVDB ("Category: Rogue, Faction: Both, Level 23, added 1.60.1.70532"), WS, PS, S60 ("New in Forever"), SP-QL object 410369, SP-ID, DB2 `QuestV2` |
| 78270 | Goblin Lockpicks (zij-quest) | Veenix (4086) | Veenix | Venture Co. Work Order (210187) zakkenrollen bij een Venture Co. Logger. Beloning Breaching Charge (210186) voor de poort | GEMETEN WH, IVDB (start/eind Veenix), PS, SP-ID. **Niet** in DB2 `QuestV2` 70938 (78261/78307 wel) → mogelijk herhaalbaar: AFGELEID |
| 78307 | The Horn of Xelthos | — (alleen inleveren) | Dead Drop | niets; pas beschikbaar na een brief van C (PS: kwartier tot twee uur) | GEMETEN WH (serie 78261 → 78307), IVDB, WS, SP-ID, PS. Beloning **Pyrewood Signet Ring (277210)** + 30 zilver: GEMETEN WH, WS, PS, S60; item in DB2 `ItemSparse` 70938 |

- In SFK: Breaching Charge bij de binnenplaatspoort, Sister's Half-Key (Gemela) en Brother's Half-Key (Gefell)
  zakkenrollen, samenvoegen, kist in de stallen: GEMETEN (PS 13 nov; Sportskeeda 14 nov). Niet in het spel gemeten.
- Level: quest-level 23 GEMETEN (WH, IVDB). "Required level 1" GEMETEN (WS; Fextralife). PS zegt "Reach level 23",
  ForeverChanges "from level 20". Schets gebruikt 23: AFGELEID (keuze).
- WH/WS tonen ook "Rune of Deadly Brew (203994)" als beloning: een rest uit Season of Discovery; S60 en PS noemen hem niet.

### 4f. NIEUW in Forever: The Eye of Bhossca (dolk), beide facties

| q | Naam | Gever | Inleveraar | Doel | Status |
|---|---|---|---|---|---|
| 78676 | The Eye of Bhossca | Dead Drop (410369) | Dead Drop | Eye of Bhossca (210953) uit de Scarlet Monastery, alleen | GEMETEN WH, WS (required level 25), SP-QL object 410369, SP-ID, PS, DB2 `QuestV2` |
| 78699 | The Eye of Bhossca | — (alleen inleveren) | Dead Drop | niets; na een brief van C | GEMETEN SP-ID (r. 12188), IVDB ("Requires level 25, Rogue, End: Dead Drop"), WH. Beloning **Ruby-Adorned Blade (277246)**: GEMETEN WH, PS; item in DB2 `ItemSparse`. IVDB toont alleen XP + geld |

- "once you are level 30 and have done the horn job ... C's letter arrives ... The quest data lists a minimum of 25, but
  players get the letter, and the job, at 30": GEMETEN (PS 7 nov). `needs = 78261` en `level = 30` in de schets: AFGELEID.
- S60 noemt deze keten niet. De stappen in het klooster (vermomming, Scryer's Key, brievenbus, banken, Reliquary Key)
  staan alleen in PS.

### 4g. The Azure Key, level 50, beide facties

| q | Naam | Gever | Inleveraar | Doel | Status |
|---|---|---|---|---|---|
| 8233 | A Simple Request | rogue-trainer in een hoofdstad | Lord Jorach Ravenholdt (6768) | — | GEMETEN Z-AC r. 22601-22611 (Lord Tony Romano), Z-HC r. 24416-24425 (Ormok), SP-QL (5165 Hulfdan), PS (Osborne, Syurna, Hulfdan; Ormok, Miles Dexter) |
| 8234 | Sealed Azure Bag | Lord Jorach Ravenholdt | Archmage Xylem (8379) | Sealed Azure Bag (19775) van Timbermaw Shaman (6188), Azshara | GEMETEN Z-AC r. 22612-22630 (`q 8234/1`), SP-C ender 8379 |
| 8235 | Encoded Fragments | Archmage Xylem | Archmage Xylem | 10 Encoded Fragment (20023) van Forest Ooze (8766) | GEMETEN Z-AC r. 22631-22657 (`q 8235/1`), SP-QL |
| 8236 | The Azure Key | Archmage Xylem | Lord Jorach Ravenholdt | Azure Key (20022) van Morphaz (5719) in de Sunken Temple (groep) | GEMETEN Z-AC r. 22658-22692 (`q 8236/1`), IVDB ("Requires level 50") |

🔴 **Beloning onzeker.** WH toont de keuze Duskbat Drape (19982) / Ebon Mask (19984) / Whisperwalk Boots (20255). PS
(15 nov): "Classic offered ... and Forever's notes say the choice may be gone". IVDB toont alleen XP, geld en +150
Ravenholdt. DB2: de drie items staan in `Item` maar **niet** in `ItemSparse` 70938 (controle in dezelfde grep: 7298, 20022,
277210 staan er wel). GEMETEN zijn die drie waarnemingen; wat de quest echt geeft: NIET GEMETEN.
Naar Xylem: Sanath Lim-yo (8395) teleporteert je omhoog (3503 "Meeting with the Master", Z-AC r. 22624): GEMETEN in Zygor.

### 4h. Wel gevonden, niet in de schets

| Wat | Feit | Status |
|---|---|---|
| Undead level 16-20: 1998 Fenwick Thatros → 1999 Tools of the Trade | Gever en inleveraar Mennet Carkad (SP-QL). 1998: Fenwick's Head (7306) van Fenwick Thatros (6570). 1999: Dalaran Status Report (7309) uit de Ambermill Strongbox; Thieves' Tools bij Estelle Gendry (6566). WH toont geen beloning (alleen XP) | GEMETEN WH, WH-T, SP-C races = 16, PS, UGT. Levert niets op → niet gebouwd |
| Ravenholdt, level 24: 6681 The Manor, Ravenholdt (start: item Elegant Letter 17126; naar Fahrad 6707) → 6701 Syndicate Emblems | Alleen reputatie (WH: 100 Ravenholdt) | GEMETEN WH, SP-QL (item 17126), SP-C |
| Ravenholdt, nieuw in Forever: 96779 Syndicate Sabotage, 96781 What's the Big Idea?, 96782 Covert Extraction, 96783 A Way In (gever npc 13085), 96784 Master of Disguise, 96785 Ain't No Telling, 96786 The Syndicate Sting (gever 266847) | PS "Ravenholdt (levels 24-36), 8 quests, reward: Ravenholdt reputation", gever Myrokos Silentform | GEMETEN id's in SP-ID / SP-QL en titels in PS (11 nov). Dat ze alleen voor rogues zijn en wat ze geven: NIET GEMETEN |
| 8249 Junkboxes Needed | 5 Heavy Junkbox (16885) → Dusksteel Throwing Knife (20086), reputatie | GEMETEN WH |
| Skyborne: 92483 At Home in the Shadows | Rorian the Dayseeker (251361) → Akeri Duskblade (251389), level 2, geen beloning behalve reputatie. Skyborne heeft **geen** eigen level 10-quest | GEMETEN Z-C r. 94/151, SP-C, SP-QL, WH, S60, FDB (70938). Lege zoekactie in SP-C op Skyborne-rogue met controle warrior 94003 / druid 94006 in dezelfde grep |
| 2358 Horns of Nez'ra | Staat in SP-C (prev 2282) en DB2 `QuestV2`, maar WH Forever geeft **404** | GEMETEN; niet in Forever te doen: AFGELEID |

## 5. Plekken

Regel: HandyNotes > Zygor > Wowhead/gids. UiMap-id's GEMETEN in DB2 `UiMap` 70938: Durotar 1411, The Barrens 1413,
Alterac Mountains 1416, Tirisfal Glades 1420, Silverpine Forest 1421, Hillsbrad Foothills 1424, Dun Morogh 1426, Elwynn
Forest 1429, Redridge Mountains 1433, Westfall 1436, Teldrassil 1438, Stonetalon Mountains 1442, Azshara 1447, Stormwind
City 1453, Orgrimmar 1454, Ironforge 1455, Darnassus 1457, Undercity 1458 (HN gebruikt dezelfde id's).
⚠️ Stormwind en Redridge hebben in Forever een grotere kaart (HN-kop): Wowhead geeft daar twee sets. De set die met
Zygor klopt is gebruikt (Shaw 78.4,70.6 / Renzik 78.4,71 / Lucius 23,52.2); de andere set (75.8,59.8 en 28.2,52.2) is de
oude kaartruimte. WowSeer toont voor Shaw de oude set: niet gebruiken voor Stormwind.

| Sleutel | NPC (id) | UiMap | x | y | Bron |
|---|---|---|---|---|---|
| keryn | Keryn Sylvius (917) | 1429 | 43.87 | 65.94 | HN; Z-AL r. 975 gelijk |
| shaw | Master Mathias Shaw (332) | 1453 | 78.31 | 70.75 | Z-AC r. 22526; WH-T 78.4,70.6 |
| dockmaster | — (Defias Dockmaster 6846) | 1429 | 48.0 | 87.0 | WH-T spawnpunt; PS 48.1,87 |
| hogral | Hogral Bakkan (1234) | 1426 | 47.72 | 52.62 | HN; Zygor 47.56,52.61 |
| hulfdan | Hulfdan Blackbeard (5165) | 1455 | 51.96 | 14.84 | HN; Zygor 51.94,14.82 |
| onin | Onin MacHammar (6886) | 1426 | 25.16 | 44.45 | Z-AC r. 22484; WH-T 25.2,44.4 |
| jannok | Jannok Breezesong (3599) | 1438 | 56.38 | 60.14 | HN = Z-AL r. 3968 |
| syurna | Syurna (4163) | 1457 | 36.99 | 21.91 | HN = Z-AL r. 3993 |
| sethir | — (Sethir the Ancient 6909) | 1438 | 37.52 | 24.29 | Z-AL r. 4022; WH-T 37.5,24.3 |
| renzik | Renzik "The Shiv" (6946) | 1453 | 78.25 | 71.13 | Z-AL r. 5768; WH-T 78.4,71; PS 78.3,71.1 |
| lucius | Lucius (6966) | 1433 | 22.97 | 52.04 | Z-AL r. 5879; WH-T 23,52.2 |
| luciusBox | — (Practice Lockbox 46.89,45.22; Lucius's Lockbox) | 1433 | 46.95 | 44.69 | Z-AL r. 5895/5900 |
| kearnen | Agent Kearnen (7024) | 1436 | 68.49 | 70.08 | Z-AC r. 22539; WS 68.5,70.1 |
| towerKey | — (Malformed Defias Drone) | 1436 | 71.63 | 73.91 | Z-AC r. 22543 |
| duskChest | — (Duskwood Chest, boven in de toren) | 1436 | 70.41 | 73.93 | Z-AC r. 22556 |
| doc | Doc Mixilpixil (7207) | 1453 | 80.06 | 69.91 | Z-AC r. 22570 |
| romano | Lord Tony Romano (13283) | 1453 | 80.28 | 68.58 | HN; Zygor 80.28,68.57 |
| kaplak | Kaplak (3170) | 1411 | 51.92 | 43.83 | HN; Zygor 51.98,43.69 |
| therzok | Therzok (6446) | 1454 | 42.74 | 53.54 | Z-HL r. 4192 |
| tazan | — (Tazan 6494, loopt rond) | 1413 | 62.92 | 44.07 | Z-HL r. 4996 |
| gamon | — (Gamon, in de herberg) | 1454 | 54.00 | 68.03 | Z-HL r. 5278 |
| marion | Marion Call (2130) | 1420 | 61.85 | 51.89 | HN; Zygor 61.75,52.00 |
| mennet | Mennet Carkad (6467) | 1458 | 83.51 | 69.11 | Z-HL r. 977; UGT 83.2,69 |
| astor | — (Astor Hadren 6497, loopt de weg Brill ↔ Sepulcher) | 1421 | 47.50 | 39.80 | Z-HL r. 1521 ("spawns near The Sepulcher"); WH-T geeft alleen een pad in Tirisfal |
| andron | Andron Gant (6522) | 1458 | 54.82 | 76.30 | Z-HL r. 4768 |
| bookshelf | — (Andron's Bookshelf) | 1458 | 55.42 | 77.05 | Z-HL r. 4773 |
| varimathras | Varimathras (2425) | 1458 | 56.24 | 92.22 | Z-HL r. 8831 (ook 10644, 10715); WH-T 56.2,92.4. NIET r. 4782 |
| shenthul | Shenthul (3401) | 1454 | 43.05 | 53.74 | HN = Z-HC r. 24282 |
| zandozan | Zando'zan (3402) | 1454 | 42.73 | 52.95 | Z-HL r. 5274 |
| wrenix | Wrenix the Wretched (7161) | 1413 | 63.07 | 36.32 | Z-HL r. 5383 |
| gizmo | — (Wrenix's Gizmotronic Apparatus) | 1413 | 63.12 | 36.32 | Z-HL r. 5389 |
| jewel | — (The Jewel of the Southsea; oefenkisten 65.06,45.43) | 1413 | 64.95 | 45.44 | Z-HL r. 5430; Z-P r. 8029 |
| flare | — (plek om de flares af te vuren) | 1413 | 55.47 | 6.08 | Z-HC r. 24304 |
| fizzule | Taskmaster Fizzule (7233) | 1413 | 55.44 | 5.56 | Z-HC r. 24308 |
| silixiz | — (Foreman Silixiz) | 1413 | 54.80 | 5.97 | Z-HC r. 24312 |
| vtower | — (Venture Co.-toren; lagen 54.71,5.73 / 54.81,5.59 / 54.63,5.64; Gallywix 54.75,5.59; lockbox 54.75,5.55) | 1413 | 54.75 | 5.59 | Z-HC r. 24318-24348 |
| hinott | Serge Hinott (2391) | 1424 | 61.63 | 19.19 | Z-HC r. 24392 |
| ormok | Ormok (3328) | 1454 | 43.90 | 54.63 | HN; Zygor 43.91,54.62 |
| jorach | Lord Jorach Ravenholdt (6768) | 1416 | 86.03 | 78.88 | Z-AC r. 22611; IVDB 86.1,79.1 |
| xylem | Archmage Xylem (8379) | 1447 | 29.71 | 40.52 | Z-AC r. 22630; IVDB 29.5,40.3 |
| timbermaw | — (Timbermaw Shaman; ook 41.49,19.55) | 1447 | 43.77 | 25.56 | Z-AC r. 22618 |
| oozes | — (Forest Ooze) | 1447 | 73.40 | 25.20 | Z-AC r. 22642 |
| (Morphaz) | bestaande `P.sunken` | 1435 | 69.36 | 56.89 | Z-AC r. 22669 |
| deadDrop | Dead Drop (object 410369) | 1421 | 47.1 | 71.1 | WH-T object; IVDB; WS; PS 47.1,71 |
| veenix | Veenix (4086) | 1442 | 58.2 | 51.6 | WH-T; IVDB 58.3,51.7 (en 59.1,54.1) |
| sfk | — (ingang Shadowfang Keep) | 1421 | 44.8 | 67.8 | PS |
| sm | — (gebouw Scarlet Monastery) | 1420 | 82.65 | 32.88 | Z-D r. 587 |
| (niet in schets) fenwick | Fenwick Thatros (6570) | 1421 | 59.4 | 34.2 | WH-T |
| (niet in schets) strongbox | Ambermill Strongbox | 1421 | 63.7 | 65.3 | UGT 6 nov 2026 |
| (niet in schets) estelle | Estelle Gendry (6566) | 1458 | 78.2 | 75.6 | WH-T |

Dat Wowhead-zonecoördinaten gelijk zijn aan UiMap-coördinaten: AFGELEID (hier 7 keer naast Zygor gelegd — Shaw, Renzik,
Lucius, Onin, Sethir, Varimathras, Eltheen Nightbreeze — steeds binnen 0,3).

## 6. Objective-index

"Wowhead-volgorde" = de volgorde onder "Requirements" in de tooltip. Dat die gelijk is aan de index van
`C_QuestLog.GetQuestObjectives`: AFGELEID. Waar Zygor `q <id>/<n>` heeft, staat dat erbij.

| q | idx | Doel | Bron |
|---|---|---|---|
| 2206 | 1 | Defias Shipping Schedule (7675) | WH-T (enige doel) |
| 2242 | 1 | Sethir's Journal (7737) | Z-AL `q 2242/1`; WH |
| 1963 | 1 | Tazan's Satchel (7209) | Z-HL `q 1963/1`; WH |
| 1858 | 1 | Tazan's Logbook (7295) | Z-HL `q 1858/1`; WH-T |
| 1858 | 2 | Tazan's Key (7208) | WH-T (tweede regel); Zygor zonder index |
| 1886 | 1 | Astor's Letter of Introduction (7231) | Z-HL `q 1886/1` |
| 1899 | 1 | Andron's Ledger (7294) | Z-HL `q 1899/1` |
| 2282 | 1 | Token of Thievery (7871) | Z-AL `q 2282/1`; WH |
| 2381 | 1 | Southsea Treasure (7968) | Z-HL `q 2381/1`; WH-T |
| 2359 | 1 | Klaven Mortwake's Journal (7908) | Z-AC `q 2359/1`; WH-T |
| 2359 | 2 | Defias Tower Key (7923) | Z-AC `q 2359/2`; WH-T |
| 2460 | 1 | Shattered Salute Performed | Z-HC `q 2460/1`; WH |
| 2458 | — | geen doelregel op Wowhead; Zygor schrijft `q 2458/1` | bronnen oneens → geen idx (stap wacht tot de client "compleet" zegt) |
| 2478 | 1 | Mutated Venture Co. Drone ×2 | Z-HC `/1`; WH-T |
| 2478 | 2 | Venture Co. Lookout ×2 | Z-HC `/2`; WH-T |
| 2478 | 3 | Venture Co. Patroller ×2 | Z-HC `/3`; WH-T |
| 2478 | 4 | Gallywix's Head (8074) | Z-HC `/4`; WH-T |
| 2478 | 5 | Silixiz's Tower Key (8072) | Z-HC `/5`; WH-T |
| 2478 | 6 | Cache of Zanzil's Altered Mixture (8073) | Z-HC `/6`; WH-T |
| 2480 | 1 | Cure Completed | Z-HC `q 2480/1`; WH |
| 2608 | — | geen doelregel op Wowhead; Zygor `q 2608/1` | geen idx |
| 2609 | 1-4 | Simple Wildflowers 3421, Leaded Vial 3372, Bronze Tube 4371, Spool 8431 | WH-T; in de schets als items in je tas |
| 8234 | 1 | Sealed Azure Bag (19775) | Zygor `q 8234/1` |
| 8235 | 1 | Encoded Fragment ×10 (20023) | Zygor `q 8235/1` |
| 8236 | 1 | Azure Key (20022) | Zygor `q 8236/1` |
| 78261 | 1 | Horn of Xelthos (210183) | WH, IVDB, WS (zelfde volgorde) |
| 78261 | 2 | Find Veenix | WH, IVDB, WS |
| 78270 | 1 | Venture Co. Work Order (210187) | IVDB |
| 78676 | 1 | Eye of Bhossca (210953) | WH, WS |

## 7. NPC-namen per taal

Bron: SP-N (GEMETEN). Spokens eigen regel (`DataModules.lua:879-882`): een questgever die in een taalbestand ontbreekt,
heeft in die taal een onvertaalde naam. "=" hieronder betekent dus: gelijk aan Engels volgens die regel. Steekproef op
Wowhead-tooltips per taal, alle acht gelijk: 6946 deDE, 7024 ruRU, 917 ptBR, 6467 ptBR, 7233 esES en esMX, 6966 frFR (=),
5165 deDE (=), plus 6768 deDE/esES (=), 7207 esES (=), 7024 frFR (=). 13283, 3328 en 2425 staan niet in Spoken: alle zes
talen van WH-T (GEMETEN). Controle npc 233: "Bauer Saldean" in beide bronnen.

| id | enUS | deDE | frFR | esES | esMX | ptBR | ruRU |
|---|---|---|---|---|---|---|---|
| 917 | Keryn Sylvius | = | = | = | = | Anabela Cabreira | Керин Сильвиус |
| 332 | Master Mathias Shaw | Meister Mathias Shaw | Maître Mathias Shaw | Maestro Mathias Shaw | Maestro Mathias Shaw | Mestre Mathias Shaw | Мастер Матиас Шоу |
| 1234 | Hogral Bakkan | = | = | = | = | = | Хограл Баккан |
| 5165 | Hulfdan Blackbeard | = | = | Hulfdan Barbanegra | Hulfdan Barbanegra | Hulfdan Barbanegra | Хальфдан Чернобород |
| 6886 | Onin MacHammar | = | = | = | = | = | Онин МакМолот |
| 3599 | Jannok Breezesong | = | = | Jannok Brisón | Jannok Brisón | Jannok Brisacanto | Джаннок Поющий Ветерок |
| 4163 | Syurna | = | = | = | = | = | Сиарна |
| 6946 | Renzik "The Shiv" | Renzik "Das Messer" | Renzik "le kriss" | Renzik "Cuchillo" | Renzik "Chafarote" | Renzik, "O Bicudo" | Рензик Нож |
| 6966 | Lucius | = | = | = | = | = | Люций |
| 7024 | Agent Kearnen | Agentin Kearnen | = | Agente Kearnen | Agente Kearnen | Agente Marta Hari | Посланница Кеарнен |
| 7207 | Doc Mixilpixil | = | = | = | = | Doutor Mixilpixil | Док Миксиль-Пиксиль |
| 13283 | Lord Tony Romano | Lord Tony Romano | Seigneur Tony Romano | Lord Tony Romano | Lord Tony Romano | Lorde Tony Romano | Лорд Тони Романо |
| 3170 | Kaplak | = | = | = | = | = | Каплак |
| 6446 | Therzok | = | = | = | = | = | Терзок |
| 2130 | Marion Call | = | = | = | = | Marion Calder | Марион Зов |
| 6467 | Mennet Carkad | = | = | = | = | Júnio Aquino | Меннит Каркад |
| 6522 | Andron Gant | = | = | = | = | Andron Gante | Андрон Гант |
| 2425 | Varimathras | Varimathras | Varimathras | Varimathras | Varimathras | Varimatras | Вариматрас |
| 3401 | Shenthul | = | = | = | = | = | Шентул |
| 3402 | Zando'zan | = | = | = | = | = | Зандо'зан |
| 7161 | Wrenix the Wretched | Wrenix der Jämmerliche | Wrenix le Misérable | Desdio el Desdichado | Desdio el Desdichado | Wrenix, o Ignóbil | Реникс Презренный |
| 7233 | Taskmaster Fizzule | Zuchtmeister Fizzule | Sous-chef Fizzule | Capataz Burbujita | Capataz Fizzule | Capataz Arruela | Надсмотрщик Физзул |
| 2391 | Serge Hinott | = | = | = | = | Serguei Hinoto | Серж Хинотт |
| 3328 | Ormok | Ormok | Ormok | Ormok | Ormok | Ormok | Ормок |
| 6768 | Lord Jorach Ravenholdt | = | Seigneur Jorach Ravenholdt | = | = | Lorde Jorach Corvoforte | Лорд Джорах Черный Ворон |
| 8379 | Archmage Xylem | Erzmagier Xylem | Archimage Xylem | Archimago Xylem | Archimago Xylem | Arquimago Tauriel | Верховный маг Ксилем |

Niet gemeten per taal: Veenix (4086) en het object Dead Drop (410369) → weggelaten, Engels verschijnt.

## 8. Fouten en gaten in Zygor

| # | Waar | Wat | Bewijs |
|---|---|---|---|
| 1 | Horde-hoofdgids r. 4778 | `accept The Deathstalkers##1978 \|goto Undercity 65.53,79.73`: verkeerde plek. Gever is Mennet Carkad, die op 83.51,69.11 staat | GEMETEN: Zygor zelf r. 4763 en 4777; SP-QL 1978 → 6467. 65.53,79.73 is het oude Classic-getal (Wow Buddy noemt het bij Mennet Carkad) |
| 2 | Horde-hoofdgids r. 4782 | Varimathras op 59.75,84.64 | GEMETEN: Zygor elders 56.24,92.22 (r. 8831) en 56.25,92.20 (r. 10644, 10715); WH-T 56.2-56.6, 90.8-93.6 |
| 3 | Alliance "Rogue Class Quests" r. 22678 | `\|q 8232 \|future` bij de Sunken Temple: 8232 is "The Green Drake" (hunter). Moet 8236 zijn | GEMETEN: SP-C `[8232]` classes = 4 |
| 4 | Horde "Rogue Class Quests" r. 24475 | `\|confirm \|q 8425`: 8425 is "Voodoo Feathers" (warrior). Moet 8236 zijn | GEMETEN: SP-C `[8425]` classes = 1 |
| 5 | Hele Zygor | 2206 Snatch and Grab ontbreekt (r. 1165 levert 2205 in en stopt): de Human krijgt bij Zygor geen Blade of Cunning | GEMETEN: grep `##2206` geeft alleen "Greymist Hunter##2206"; `##2205` in dezelfde grep wel raak |
| 6 | Hele Zygor | De nieuwe Forever-ketens (Xelthos, Bhossca, Veenix, Dead Drop, Myrokos) en 2609 ontbreken | GEMETEN: lege grep, met `Lucius##6966` raak in dezelfde run |
| 7 | r. 24304 / r. 22576 | `q 2458/1` en `q 2608/1`: Wowhead toont bij die quests geen doelregel | GEMETEN verschil; wie gelijk heeft: niet gemeten |
| 8 | Horde "Rogue Class Quests" | Serge Hinott op drie plekken: 61.63,19.19 / 61.49,18.95 / 61.58,18.97 | GEMETEN r. 24392-24403 (klein) |
| 9 | Beide "Rogue Class Quests" | De level 10-ketens van Human, Night Elf, Orc/Troll en Undead en de level 16-ketens staan alleen in de hoofd- en beroepsgidsen | GEMETEN (geen fout, wel een gat) |

## 9. Lua-schets

Plek: ná het warrior-blok (dan bestaan `DWGN`, `NELF`, `UD`, `O`, `P.sunken`). Niet getest, niet door een Lua-parser gehaald.

```lua
--[[ Rogue (17 Nov 2026). All facts: docs/forever/ROGUE_CLASSQUESTS_2026-11-17.md (mh-research): Zygor Forever (class
	guides + main leveling guides), Spoken, wago DB2 1.60.1.70938, Wowhead Forever, Icy Veins, Polestar, HandyNotes.
	Poisons 2842 comes from 2359 (Alliance) / 2480 (Horde): GEMETEN on Wowhead Forever. Pick Lock is a trainer spell.
	NEW in Forever, not in Zygor: The Horn of Xelthos (78261-78307) and The Eye of Bhossca (78676-78699).
	AFGELEID: Troll starts at 1963; Skyborne (Alliance) walks the Human route; 2379 without its pointer quest;
	level 23/30 and needs = 78261 for the two Dead Drop chains; what 8236 pays in Forever is NOT measured.
	Zygor mistakes not copied: Varimathras 59.75,84.64 and the 1978 pickup at 65.53,79.73. ]]
local RO_P = {
	keryn = { npc = "Keryn Sylvius", id = 917, m = 1429, x = 43.87, y = 65.94 },
	shaw = { npc = "Master Mathias Shaw", id = 332, m = 1453, x = 78.31, y = 70.75 },
	hogral = { npc = "Hogral Bakkan", id = 1234, m = 1426, x = 47.72, y = 52.62 },
	hulfdan = { npc = "Hulfdan Blackbeard", id = 5165, m = 1455, x = 51.96, y = 14.84 },
	onin = { npc = "Onin MacHammar", id = 6886, m = 1426, x = 25.16, y = 44.45 },
	jannok = { npc = "Jannok Breezesong", id = 3599, m = 1438, x = 56.38, y = 60.14 },
	syurna = { npc = "Syurna", id = 4163, m = 1457, x = 36.99, y = 21.91 },
	renzik = { npc = "Renzik \"The Shiv\"", id = 6946, m = 1453, x = 78.25, y = 71.13 },
	lucius = { npc = "Lucius", id = 6966, m = 1433, x = 22.97, y = 52.04 },
	kearnen = { npc = "Agent Kearnen", id = 7024, m = 1436, x = 68.49, y = 70.08 },
	doc = { npc = "Doc Mixilpixil", id = 7207, m = 1453, x = 80.06, y = 69.91 },
	romano = { npc = "Lord Tony Romano", id = 13283, m = 1453, x = 80.28, y = 68.58 },
	kaplak = { npc = "Kaplak", id = 3170, m = 1411, x = 51.92, y = 43.83 },
	therzok = { npc = "Therzok", id = 6446, m = 1454, x = 42.74, y = 53.54 },
	marion = { npc = "Marion Call", id = 2130, m = 1420, x = 61.85, y = 51.89 },
	mennet = { npc = "Mennet Carkad", id = 6467, m = 1458, x = 83.51, y = 69.11 },
	andron = { npc = "Andron Gant", id = 6522, m = 1458, x = 54.82, y = 76.30 },
	varimathras = { npc = "Varimathras", id = 2425, m = 1458, x = 56.24, y = 92.22 },
	shenthul = { npc = "Shenthul", id = 3401, m = 1454, x = 43.05, y = 53.74 },
	zandozan = { npc = "Zando'zan", id = 3402, m = 1454, x = 42.73, y = 52.95 },
	wrenix = { npc = "Wrenix the Wretched", id = 7161, m = 1413, x = 63.07, y = 36.32 },
	fizzule = { npc = "Taskmaster Fizzule", id = 7233, m = 1413, x = 55.44, y = 5.56 },
	hinott = { npc = "Serge Hinott", id = 2391, m = 1424, x = 61.63, y = 19.19 },
	ormok = { npc = "Ormok", id = 3328, m = 1454, x = 43.90, y = 54.63 },
	jorach = { npc = "Lord Jorach Ravenholdt", id = 6768, m = 1416, x = 86.03, y = 78.88 },
	xylem = { npc = "Archmage Xylem", id = 8379, m = 1447, x = 29.71, y = 40.52 },
	-- The Dead Drop is a chest (object 410369), not an NPC: no id, so the English name shows in every language.
	deadDrop = { npc = "Dead Drop", m = 1421, x = 47.1, y = 71.1 },
	veenix = { npc = "Veenix", id = 4086, m = 1442, x = 58.2, y = 51.6 },
	-- Objective places (no NPC).
	dockmaster = { m = 1429, x = 48.0, y = 87.0 },
	sethir = { m = 1438, x = 37.52, y = 24.29 },
	luciusBox = { m = 1433, x = 46.95, y = 44.69 },
	towerKey = { m = 1436, x = 71.63, y = 73.91 },
	duskChest = { m = 1436, x = 70.41, y = 73.93 },
	tazan = { m = 1413, x = 62.92, y = 44.07 },
	gamon = { m = 1454, x = 54.00, y = 68.03 },
	astor = { m = 1421, x = 47.50, y = 39.80 },
	bookshelf = { m = 1458, x = 55.42, y = 77.05 },
	gizmo = { m = 1413, x = 63.12, y = 36.32 },
	jewel = { m = 1413, x = 64.95, y = 45.44 },
	flare = { m = 1413, x = 55.47, y = 6.08 },
	silixiz = { m = 1413, x = 54.80, y = 5.97 },
	vtower = { m = 1413, x = 54.75, y = 5.59 },
	timbermaw = { m = 1447, x = 43.77, y = 25.56 },
	oozes = { m = 1447, x = 73.40, y = 25.20 },
	sfk = { m = 1421, x = 44.8, y = 67.8 },
	sm = { m = 1420, x = 82.65, y = 32.88 },
}
local RO = RO_P
local HUMSKY, ORC, TROLL = { Human = true, Skyborne = true }, { Orc = true }, { Troll = true }

local function RoBlade(faction, races, quests)
	return { key = "blade", nameKey = "FCQ_CHAIN_RO_BLADE", level = 10, faction = faction, races = races, quests = quests }
end
-- 1963: the satchel is objective 1 (handed in, then given back for 1858). 1858: 1 = Logbook, 2 = Key (Wowhead order).
local RO_HAND1 = { q = 1963, from = RO.therzok, objs = { O(RO.tazan, "FCQ_OBJ_RO_TAZAN", 1) }, to = RO.therzok }
local RO_HAND2 = { q = 1858, from = RO.therzok, objs = {
	O(RO.gamon, "FCQ_OBJ_RO_TAZANKEY", 2),
	O(nil, "FCQ_OBJ_RO_LOGBOOK", 1),
}, to = RO.therzok }

CHAINS.ROGUE = {
	-- Blade of Cunning (10). Skyborne (Alliance) on the Human route: Polestar + the quest's race mask, not seen in game.
	RoBlade("Alliance", HUMSKY, {
		{ q = 2205, from = RO.keryn, to = RO.shaw },
		{ q = 2206, from = RO.shaw, objs = { O(RO.dockmaster, "FCQ_OBJ_RO_SCHEDULE", 1) }, to = RO.shaw },
	}),
	RoBlade("Alliance", DWGN, {
		{ q = 2218, from = RO.hogral, to = RO.hulfdan },
		{ q = 2238, from = RO.hulfdan, to = RO.onin },
		{ q = 2239, from = RO.onin, to = RO.hulfdan },
	}),
	RoBlade("Alliance", NELF, {
		{ q = 2241, from = RO.jannok, to = RO.syurna },
		{ q = 2242, from = RO.syurna, objs = { O(RO.sethir, "FCQ_OBJ_RO_SETHIR", 1) }, to = RO.syurna },
	}),
	-- 1859 is Orc only (a pointer); a Troll takes 1963 straight from Therzok (Polestar; AFGELEID that it needs no 1859).
	RoBlade("Horde", ORC, { { q = 1859, from = RO.kaplak, to = RO.therzok }, RO_HAND1, RO_HAND2 }),
	RoBlade("Horde", TROLL, { RO_HAND1, RO_HAND2 }),
	RoBlade("Horde", UD, {
		{ q = 1885, from = RO.marion, to = RO.mennet },
		{ q = 1886, from = RO.mennet, objs = { O(RO.astor, "FCQ_OBJ_RO_ASTOR", 1) }, to = RO.mennet },
		{ q = 1898, from = RO.mennet, to = RO.andron },
		{ q = 1899, from = RO.andron, objs = { O(RO.bookshelf, "FCQ_OBJ_RO_LEDGER", 1) }, to = RO.mennet },
		{ q = 1978, from = RO.mennet, to = RO.varimathras },
	}),
	-- Thieves' Tools and the first lock (16). The race pointers (2300, 2299-2298, 2259-2260; 2380, 2378) are left out.
	{ key = "tools", nameKey = "FCQ_CHAIN_RO_TOOLS", level = 16, faction = "Alliance", quests = {
		{ q = 2281, from = RO.renzik, to = RO.lucius },
		{ q = 2282, from = RO.lucius, objs = { O(RO.luciusBox, "FCQ_OBJ_RO_LUCIUSBOX", 1) }, to = RO.lucius },
	} },
	{ key = "tools", nameKey = "FCQ_CHAIN_RO_TOOLS", level = 16, faction = "Horde", quests = {
		{ q = 2379, from = RO.shenthul, to = RO.zandozan },
		{ q = 2382, from = RO.zandozan, to = RO.wrenix },
		-- E.C.A.C. (7970) in your bags, or the treasure already: the machine step is done.
		{ q = 2381, from = RO.wrenix, objs = {
			O(RO.gizmo, "FCQ_OBJ_RO_GIZMO", nil, { 7970, 7968 }),
			O(RO.jewel, "FCQ_OBJ_RO_SOUTHSEA", 1),
		}, to = RO.wrenix },
	} },
	-- Poisons (20).
	{ key = "poisons", spell = 2842, level = 20, faction = "Alliance", quests = {
		{ q = 2360, from = RO.shaw, to = RO.kearnen },
		{ q = 2359, from = RO.kearnen, objs = {
			O(RO.towerKey, "FCQ_OBJ_RO_TOWERKEY", 2),
			O(RO.duskChest, "FCQ_OBJ_RO_JOURNAL", 1),
		}, to = RO.shaw },
	} },
	{ key = "poisons", spell = 2842, level = 20, faction = "Horde", quests = {
		{ q = 2460, from = RO.shenthul, objs = { O(RO.shenthul, "FCQ_OBJ_RO_SALUTE", 1) }, to = RO.shenthul },
		-- No index on purpose (Wowhead shows no objective, Zygor says /1): waits until the client says complete.
		{ q = 2458, from = RO.shenthul, objs = { O(RO.flare, "FCQ_OBJ_RO_FLARE") }, to = RO.fizzule },
		{ q = 2478, from = RO.fizzule, objs = {
			O(RO.silixiz, "FCQ_OBJ_RO_SILIXIZ", 5),
			O(RO.vtower, "FCQ_OBJ_RO_DRONES", 1),
			O(RO.vtower, "FCQ_OBJ_RO_PATROLLERS", 3),
			O(RO.vtower, "FCQ_OBJ_RO_LOOKOUTS", 2),
			O(RO.vtower, "FCQ_OBJ_RO_GALLYWIX", 4),
			O(RO.vtower, "FCQ_OBJ_RO_CACHE", 6),
		}, to = RO.shenthul },
		{ q = 2479, from = RO.shenthul, to = RO.hinott },
		{ q = 2480, from = RO.hinott, objs = { O(RO.hinott, "FCQ_OBJ_RO_CURE", 1) }, to = RO.hinott },
	} },
	-- OPTIONAL: the Touch of Zanzil cure (Alliance, after 2359). A player who cures it another way never finishes it,
	-- so the line would stay in "Do this now": decide before building.
	{ key = "zanzil", nameKey = "FCQ_CHAIN_RO_ZANZIL", level = 20, needs = 2359, faction = "Alliance", quests = {
		{ q = 2607, from = RO.shaw, to = RO.doc },
		{ q = 2608, from = RO.doc, objs = { O(RO.doc, "FCQ_OBJ_RO_LAY") }, to = RO.doc },
		{ q = 2609, from = RO.doc, objs = {
			O(nil, "FCQ_OBJ_RO_WILDFLOWERS", nil, { 3421 }),
			O(nil, "FCQ_OBJ_RO_VIAL", nil, { 3372 }),
			O(nil, "FCQ_OBJ_RO_TUBE", nil, { 4371 }),
			O(nil, "FCQ_OBJ_RO_THREAD", nil, { 8431 }),
		}, to = RO.doc },
	} },
}
for _, faction in ipairs({ "Alliance", "Horde" }) do
	-- NEW in Forever. 78270 Goblin Lockpicks (Veenix: Work Order 210187 -> Breaching Charge 210186) is a side quest
	-- inside 78261, not a step: it is missing from QuestV2, so "done" may never be true for it. 78307 and 78699 are
	-- hand-ins only, offered after a letter from C (minutes to hours later).
	table.insert(CHAINS.ROGUE, { key = "xelthos", nameKey = "FCQ_CHAIN_RO_XELTHOS", level = 23, faction = faction, quests = {
		{ q = 78261, from = RO.deadDrop, objs = {
			O(RO.veenix, "FCQ_OBJ_RO_VEENIX", 2),
			O(RO.sfk, "FCQ_OBJ_RO_HORN", 1),
		}, to = RO.deadDrop },
		{ q = 78307, from = RO.deadDrop, to = RO.deadDrop },
	} })
	table.insert(CHAINS.ROGUE, { key = "bhossca", nameKey = "FCQ_CHAIN_RO_BHOSSCA", level = 30, needs = 78261,
		faction = faction, quests = {
			{ q = 78676, from = RO.deadDrop, objs = { O(RO.sm, "FCQ_OBJ_RO_EYE", 1) }, to = RO.deadDrop },
			{ q = 78699, from = RO.deadDrop, to = RO.deadDrop },
		} })
	-- The Azure Key (50). What 8236 pays in Forever is not measured (the Classic item choice may be gone).
	local trainer = faction == "Alliance" and RO.romano or RO.ormok
	table.insert(CHAINS.ROGUE, { key = "azure", nameKey = "FCQ_CHAIN_RO_AZURE", level = 50, faction = faction, quests = {
		{ q = 8233, from = trainer, to = RO.jorach },
		{ q = 8234, from = RO.jorach, objs = { O(RO.timbermaw, "FCQ_OBJ_RO_AZUREBAG", 1) }, to = RO.xylem },
		{ q = 8235, from = RO.xylem, objs = { O(RO.oozes, "FCQ_OBJ_RO_FRAGMENTS", 1) }, to = RO.xylem },
		{ q = 8236, from = RO.xylem, objs = { O(P.sunken, "FCQ_OBJ_RO_AZUREKEY", 1) }, to = RO.jorach },
	} })
end
```

Rijen voor `NPC_NAMES` (uit §7; "=" uitgeschreven als de Engelse naam):

```lua
	-- Rogue (17 Nov 2026, mh-research: Spoken name files; 13283, 3328, 2425 from Wowhead Forever tooltips per locale;
	-- control npc 233). A name equal to English = Spoken's rule "missing = not translated" (12 spot checks on Wowhead).
	[917] = { deDE = "Keryn Sylvius", frFR = "Keryn Sylvius", esES = "Keryn Sylvius", esMX = "Keryn Sylvius", ptBR = "Anabela Cabreira", ruRU = "Керин Сильвиус" },
	[332] = { deDE = "Meister Mathias Shaw", frFR = "Maître Mathias Shaw", esES = "Maestro Mathias Shaw", esMX = "Maestro Mathias Shaw", ptBR = "Mestre Mathias Shaw", ruRU = "Мастер Матиас Шоу" },
	[1234] = { deDE = "Hogral Bakkan", frFR = "Hogral Bakkan", esES = "Hogral Bakkan", esMX = "Hogral Bakkan", ptBR = "Hogral Bakkan", ruRU = "Хограл Баккан" },
	[5165] = { deDE = "Hulfdan Blackbeard", frFR = "Hulfdan Blackbeard", esES = "Hulfdan Barbanegra", esMX = "Hulfdan Barbanegra", ptBR = "Hulfdan Barbanegra", ruRU = "Хальфдан Чернобород" },
	[6886] = { deDE = "Onin MacHammar", frFR = "Onin MacHammar", esES = "Onin MacHammar", esMX = "Onin MacHammar", ptBR = "Onin MacHammar", ruRU = "Онин МакМолот" },
	[3599] = { deDE = "Jannok Breezesong", frFR = "Jannok Breezesong", esES = "Jannok Brisón", esMX = "Jannok Brisón", ptBR = "Jannok Brisacanto", ruRU = "Джаннок Поющий Ветерок" },
	[4163] = { deDE = "Syurna", frFR = "Syurna", esES = "Syurna", esMX = "Syurna", ptBR = "Syurna", ruRU = "Сиарна" },
	[6946] = { deDE = "Renzik \"Das Messer\"", frFR = "Renzik \"le kriss\"", esES = "Renzik \"Cuchillo\"", esMX = "Renzik \"Chafarote\"", ptBR = "Renzik, \"O Bicudo\"", ruRU = "Рензик Нож" },
	[6966] = { deDE = "Lucius", frFR = "Lucius", esES = "Lucius", esMX = "Lucius", ptBR = "Lucius", ruRU = "Люций" },
	[7024] = { deDE = "Agentin Kearnen", frFR = "Agent Kearnen", esES = "Agente Kearnen", esMX = "Agente Kearnen", ptBR = "Agente Marta Hari", ruRU = "Посланница Кеарнен" },
	[7207] = { deDE = "Doc Mixilpixil", frFR = "Doc Mixilpixil", esES = "Doc Mixilpixil", esMX = "Doc Mixilpixil", ptBR = "Doutor Mixilpixil", ruRU = "Док Миксиль-Пиксиль" },
	[13283] = { deDE = "Lord Tony Romano", frFR = "Seigneur Tony Romano", esES = "Lord Tony Romano", esMX = "Lord Tony Romano", ptBR = "Lorde Tony Romano", ruRU = "Лорд Тони Романо" },
	[3170] = { deDE = "Kaplak", frFR = "Kaplak", esES = "Kaplak", esMX = "Kaplak", ptBR = "Kaplak", ruRU = "Каплак" },
	[6446] = { deDE = "Therzok", frFR = "Therzok", esES = "Therzok", esMX = "Therzok", ptBR = "Therzok", ruRU = "Терзок" },
	[2130] = { deDE = "Marion Call", frFR = "Marion Call", esES = "Marion Call", esMX = "Marion Call", ptBR = "Marion Calder", ruRU = "Марион Зов" },
	[6467] = { deDE = "Mennet Carkad", frFR = "Mennet Carkad", esES = "Mennet Carkad", esMX = "Mennet Carkad", ptBR = "Júnio Aquino", ruRU = "Меннит Каркад" },
	[6522] = { deDE = "Andron Gant", frFR = "Andron Gant", esES = "Andron Gant", esMX = "Andron Gant", ptBR = "Andron Gante", ruRU = "Андрон Гант" },
	[2425] = { deDE = "Varimathras", frFR = "Varimathras", esES = "Varimathras", esMX = "Varimathras", ptBR = "Varimatras", ruRU = "Вариматрас" },
	[3401] = { deDE = "Shenthul", frFR = "Shenthul", esES = "Shenthul", esMX = "Shenthul", ptBR = "Shenthul", ruRU = "Шентул" },
	[3402] = { deDE = "Zando'zan", frFR = "Zando'zan", esES = "Zando'zan", esMX = "Zando'zan", ptBR = "Zando'zan", ruRU = "Зандо'зан" },
	[7161] = { deDE = "Wrenix der Jämmerliche", frFR = "Wrenix le Misérable", esES = "Desdio el Desdichado", esMX = "Desdio el Desdichado", ptBR = "Wrenix, o Ignóbil", ruRU = "Реникс Презренный" },
	[7233] = { deDE = "Zuchtmeister Fizzule", frFR = "Sous-chef Fizzule", esES = "Capataz Burbujita", esMX = "Capataz Fizzule", ptBR = "Capataz Arruela", ruRU = "Надсмотрщик Физзул" },
	[2391] = { deDE = "Serge Hinott", frFR = "Serge Hinott", esES = "Serge Hinott", esMX = "Serge Hinott", ptBR = "Serguei Hinoto", ruRU = "Серж Хинотт" },
	[3328] = { deDE = "Ormok", frFR = "Ormok", esES = "Ormok", esMX = "Ormok", ptBR = "Ormok", ruRU = "Ормок" },
	[6768] = { deDE = "Lord Jorach Ravenholdt", frFR = "Seigneur Jorach Ravenholdt", esES = "Lord Jorach Ravenholdt", esMX = "Lord Jorach Ravenholdt", ptBR = "Lorde Jorach Corvoforte", ruRU = "Лорд Джорах Черный Ворон" },
	[8379] = { deDE = "Erzmagier Xylem", frFR = "Archimage Xylem", esES = "Archimago Xylem", esMX = "Archimago Xylem", ptBR = "Arquimago Tauriel", ruRU = "Верховный маг Ксилем" },
```

Tekstsleutels (voorstel voor enUS; de zinnen zijn van mij, de feiten erin staan in §4):

| Sleutel | Voorstel |
|---|---|
| FCQ_CHAIN_RO_BLADE | Blade of Cunning |
| FCQ_CHAIN_RO_TOOLS | Thieves' Tools |
| FCQ_CHAIN_RO_ZANZIL | Cure the Touch of Zanzil |
| FCQ_CHAIN_RO_XELTHOS | The Horn of Xelthos (ring) |
| FCQ_CHAIN_RO_BHOSSCA | The Eye of Bhossca (dagger) |
| FCQ_CHAIN_RO_AZURE | The Azure Key |
| FCQ_OBJ_RO_SCHEDULE | Pick Pocket the Defias Dockmaster for the shipping schedule (killing him gives nothing) |
| FCQ_OBJ_RO_SETHIR | Pick Pocket Sethir the Ancient for his journal (do not attack him) |
| FCQ_OBJ_RO_TAZAN | Kill Tazan and take his satchel |
| FCQ_OBJ_RO_TAZANKEY | Pick Pocket Gamon in the inn for Tazan's Key |
| FCQ_OBJ_RO_LOGBOOK | Use the key on Tazan's Satchel in your bags |
| FCQ_OBJ_RO_ASTOR | Talk to Astor Hadren on the road, pick both answers, then kill him for the letter |
| FCQ_OBJ_RO_LEDGER | Take Andron's Ledger from the bookshelf behind him |
| FCQ_OBJ_RO_LUCIUSBOX | Practise on the lockboxes, then open Lucius's Lockbox |
| FCQ_OBJ_RO_GIZMO | Take an E.C.A.C. and Thieves' Tools from Wrenix's machine |
| FCQ_OBJ_RO_SOUTHSEA | Open The Jewel of the Southsea in the ship, use the E.C.A.C. on Polly, kill it |
| FCQ_OBJ_RO_TOWERKEY | Pick Pocket the Malformed Defias Drone for the tower key |
| FCQ_OBJ_RO_JOURNAL | Open the Duskwood Chest at the top of the tower |
| FCQ_OBJ_RO_SALUTE | Wait for Shenthul's salute, then /salute him |
| FCQ_OBJ_RO_FLARE | Fire the Flare Gun twice, then /salute Taskmaster Fizzule |
| FCQ_OBJ_RO_SILIXIZ | Pick Pocket Foreman Silixiz for the tower key |
| FCQ_OBJ_RO_DRONES / _PATROLLERS / _LOOKOUTS | Kill 2 Mutated Venture Co. Drones / 2 Patrollers / 2 Lookouts |
| FCQ_OBJ_RO_GALLYWIX | Kill Grand Foreman Puzik Gallywix (elite) for his head |
| FCQ_OBJ_RO_CACHE | Pick Gallywix's Lockbox for the cache |
| FCQ_OBJ_RO_CURE | Wait while Serge Hinott finishes the cure |
| FCQ_OBJ_RO_LAY | Target Doc Mixilpixil and type /lay |
| FCQ_OBJ_RO_WILDFLOWERS / _VIAL / _TUBE / _THREAD | Get Simple Wildflowers / a Leaded Vial / a Bronze Tube / the Spool of Light Chartreuse Silk Thread |
| FCQ_OBJ_RO_VEENIX | Find Veenix; take Goblin Lockpicks, Pick Pocket a Venture Co. Logger for a Work Order, hand it in for the Breaching Charge |
| FCQ_OBJ_RO_HORN | Go into Shadowfang Keep alone and bring out the Horn of Xelthos |
| FCQ_OBJ_RO_EYE | Go into the Scarlet Monastery alone and bring out the Eye of Bhossca |
| FCQ_OBJ_RO_AZUREBAG | Get the Sealed Azure Bag from a Timbermaw Shaman |
| FCQ_OBJ_RO_FRAGMENTS | Get 10 Encoded Fragments from Forest Oozes |
| FCQ_OBJ_RO_AZUREKEY | Get the Azure Key from Morphaz in the Sunken Temple (group) |

## 10. Open / niet gemeten

1. **Niets is in het spel gemeten.** Geen enkele quest-id is door de client afgevinkt; geen enkele coördinaat is gelopen.
2. Of `IsPlayerSpell(2842)` / `IsSpellKnown(2842)` waar wordt na de quest (Poisons is een vak-spell). Zo niet, dan eindigt
   de keten alleen op "laatste quest af".
3. **8236**: wat hij in Forever geeft (item-keuze mogelijk weg). Tot dat gemeten is, is "azure" een keten met een
   onbekende beloning.
4. **78307 en 78699** zijn alleen inleveren en komen pas na een brief (PS: kwartier tot twee uur). De lijn stuurt de
   speler dan direct terug naar de Dead Drop terwijl daar nog niets is. Een tekst "wacht op de brief van C" is nodig.
5. **78261**: of doel 2 "Find Veenix" afgaat bij het eerste gesprek of pas na Goblin Lockpicks; of de Breaching Charge
   opgebruikt wordt; of 78270 herhaalbaar is (ontbreekt in `QuestV2`). Daarom zit de Work Order alleen in de tekst.
6. Minimumlevel van 78261: data zegt 1, gidsen zeggen 20-23. Minimumlevel van 78676: data 25, Polestar 30.
7. `needs = 78261` voor Bhossca (Polestar: "have done the horn job"): of 78261 of 78307 de voorwaarde is, is niet gemeten.
8. Troll zonder 1859; Skyborne-Alliance op de Human-route; Skyborne-Horde zonder Blade; 2379 zonder 2378/2380.
9. Of de drie Alliance-Blade-ketens (en de wegwijzers op level 16) elkaar uitsluiten. Polestar zegt bij level 16:
   "Taking it shuts out the other towns' breadcrumbs".
10. 8233: welke trainer hem aan welk ras geeft. Schets: Lord Tony Romano / Ormok (Zygor); Polestar noemt Osborne,
    Syurna, Hulfdan, Ormok en Miles Dexter; Spoken noemt Hulfdan.
11. 2381: of de E.C.A.C. opgebruikt wordt (dan springt de stap een paar tellen terug naar de machine).
12. Astor Hadren loopt: de plek is Zygors "spawnt bij The Sepulcher"; Wowhead toont een pad in Tirisfal.
13. Namen per taal van Veenix en Dead Drop; UiMap-gelijkheid van Wowhead-coördinaten (alleen vergeleken, niet bewezen).
14. De Ravenholdt-quests 96779-96786 (nieuw in Forever): alleen id's en titels gezien; klasse, volgorde en beloning niet.
15. Wowhead-pagina's zijn gelezen via een samenvattend hulpmodel (WebFetch); de infobox (start/eind, required level)
    is daar niet zichtbaar. Start/eind komt daarom uit Zygor en Spoken, required level uit WowSeer/Icy Veins DB/stillsixty.
