# Wapenquests per class — notities bij `wapenquests_data.lua`

mh-research, 18 nov 2026. WoW Forever 1.60.1.70959. Repo niet aangeraakt. Elke bewering: **GEMETEN** (gezien in een
genoemde bron) of **AFGELEID** (beredeneerd). "(2)" / "(3)" = aantal bronnen dat hetzelfde zegt.

## 1. Wat er geleverd is

5 nieuwe ketens (16 tabelrijen, per factie/ras), 8 nieuwe `NPC_NAMES`-rijen, 30 nieuwe tekstsleutels (Engels).

| Class | Keten (`key`) | Level | Beloning | Groep nodig? |
|---|---|---|---|---|
| Warrior | `firstweapon` (5 routes: Human, Dwarf/Gnome, Night Elf, Orc/Troll/Tauren, Undead) | 10 | 1 van 4 wapens, item level 15 | nee |
| Warlock | `soranruk` | 20 | Orb (off-hand) of Staff of Soran'ruk, item level 25 | ja, 2 dungeons (BFD + SFK) |
| Warlock | `orahil` (4 routes per trainer) | 35 | Orb (off-hand) of Staff, item level 40, shadow of fire | 1 elite van level 40 |
| Warlock | `imprequest` | 50 | Soul Harvester (staf) / Abyss Shard / Robes of Servitude | ja, Sunken Temple |
| Shaman | `tempest` (Alliance Dwarf; Horde Orc/Tauren/Troll) | 30 | 1 van 3 wapens item level 40 + schild | ja, RFK + elite-ritueel |

## 2. Hoe een item-keten nu werkt (GEMETEN in `ForeverClassQuests.lua`, gelezen 18 nov)

- Geen `spell` = item-keten: einde zodra de laatste quest gedaan is. `nameKey` verplicht (anders geen naam).
- `NowPick` (regel 2487): ronde 1 spell-ketens, ronde 2 item-ketens, ronde 3 `low`. Binnen een ronde: laagste level eerst,
  daarna tabelvolgorde (`MyChains`, regel 2103).
- `NowSkip` (regel 2469): een item-keten verdwijnt uit "Do this now" boven `level + ITEM_CHAIN_SPAN` (= 10), behalve met
  `always = true` of als een quest ervan in je log staat. Voor de nieuwe ketens: firstweapon weg vanaf 21, soranruk
  vanaf 31, tempest vanaf 41, orahil vanaf 46, imprequest nooit (60 = max). Dat past bij de item levels (AFGELEID).
- `needs` op de keten = één quest-id (`Ready`, regel 2114). Meerdere id's kan alleen in een `strict`-keten per quest.
- `strict` (Dreadsteed) is hier NIET gebruikt: een overgeslagen wijs-quest zou zo'n keten nooit laten eindigen.
- Plekken: `npc` + `id` alleen nodig waar je een quest haalt of inlevert; doel-plekken hebben alleen `m`, `x`, `y`.
- De nieuwe ketens moeten ná het mage-blok geplakt worden (staat bovenin het lua-bestand): de warlock-tabel staat in
  het bestand vóór `MA_P`, `PA_P` en `RO_P`, en de nieuwe warlock-ketens gebruiken `MA.tabetha`, `PA.bfd`, `RO.sfk`.

## 3. Per class: wat er al was, wat erbij komt, wat ik weglaat

Bron "was er al": het bestand zelf (GEMETEN). Bron "niet gebouwd in Spoken-lijst": mijn scratch-script `wq_unbuilt.py`
(Spoken Compendium, class-masker, tegen alle getallen in het lua-bestand; positieve controle in dezelfde run: 1792 = wel
genoemd, 1740 = niet genoemd). Let op: Spoken's lijst komt uit build 70450 en is niet volledig (de Alliance-Tempest-
quests 96264/96135/96016 staan er niet in; die kwamen uit QuestieDB en gidsen).

### Warrior
- **Was er al:** `defensive` (10, 7 routes), `berserker` (30), `whirlwind` (30, Whirlwind Axe e.d.), `fallenhero` (50, Sunken Temple).
- **Komt erbij:** `firstweapon` (10), vijf routes. Start bij de NPC waar de Defensive Stance-quest eindigt.
  - Human: 1666 → 1667. Dwarf/Gnome: 1680 → 1681 → 1682. Night Elf: 1686 → 1692 → 1693.
    Orc/Troll/Tauren: 1502 → 1503. Undead: 1820 → 1821 → 1822. (GEMETEN: QuestieDB + Spoken, 2; Horde ook Zygor, 3.)
  - Beloningen GEMETEN: namen op de Wowhead Forever-questpagina's, id's in DB2 ItemSparse 70959 (zie lua).
- **Weggelaten:** de level 20-harnasketens (Alliance 1698-1711, Horde 1823-1848): harnas, geen wapen. Level 60
  (8316, 8912 e.v.): buiten 10-55.
- **Niet gevonden:** een wapen-vervolg voor Skyborne na 94003 (Spoken noemt voor hen alleen 92532 en 94003). AFGELEID
  dat het er niet is.
- **Grens (AFGELEID uit de code):** een Night Elf die de Human-route van Defensive Stance liep, krijgt de Human-
  wapenketen pas te zien als 1666 in zijn log staat (dan pakt `MyChains` de "route van een ander ras"); daarvoor zegt
  zijn eigen keten "not open yet" (`needs = 1683`).

### Warlock
- **Was er al:** imp, voidwalker, succubus, incubus, felhunter, felsteed, inferno, dreadsteed. Geen enkele wapenketen.
- **Komt erbij:**
  - `soranruk` (20): één quest 1740 bij Doan Karhan (Barrens, naast Takar the Seer). 3 Soran'ruk Fragments van
    Twilight Acolytes in Blackfathom Deeps, 1 Large Soran'ruk Fragment van Shadowfang Darksouls in Shadowfang Keep.
    Geen voorgaande quest (QuestieDB + foreverquestlog, 2). GEMETEN.
  - `orahil` (35): wijs-quest van de demon trainer → 1799 → 4961 → 4976 → 4964 of 4975. Onderweg kies je één van twee
    shard-quests (4962 felhound = shadow-orb Dar'Orahil; 4963 infernal = fire-orb Noh'Orahil). GEMETEN (QuestieDB,
    Spoken, foreverquestlog; welke shard bij welke orb: Spoken `prev` + Wowhead-tooltips).
  - `imprequest` (50): 8419 (of 8420 bij Impsy zelf) → 8421 → 8422. Dit was de enige class zonder Sunken Temple-keten.
    GEMETEN (QuestieDB, Spoken, Zygor, Wowhead; 3).
- **Weggelaten:** Enchanted Gold Bloodrobe (4736-4786): een gewaad. Ritual of Doom (7581-7583): een spell, stond al als
  "niet gebouwd" in de kop van het bestand.
- **Niet gemeten:** hoe je de Felhas Ruby / Infus Emerald gebruikt (op een levende, verzwakte of dode demon). De tekst
  zegt daarom alleen "use the gem … on a felhound / an infernal". Of 1799 de wijs-quest echt nodig heeft (QuestieDB:
  nee; Spoken: `prev = 4965`).
- **Fout in een bron gevonden:** QuestieDB geeft 4967 (Zevrost, Orgrimmar) een Alliance-masker en 4968 (Demisette
  Cloyce, Stormwind) een Horde-masker. Spoken zegt het omgekeerd, en dat klopt met waar die NPC's staan. Spoken gevolgd.
- **Plek-conflict:** foreverquestlog zet de Burning Blade Summoner op "80.3, 77.0" in Desolace; Wowhead Forever geeft
  19 spawns rond 50-53, 72-84 (Mannoroc Coven). Wowhead gevolgd.

### Shaman
- **Was er al:** earth (4), fire (10), water (20), air (30), mastery (50, alleen Horde). Geen wapenketen; de kop van
  het bestand noemde "The Tempest's Weapons" als niet gebouwd.
- **Komt erbij:** `tempest` (30), NIEUW in Forever.
  - Alliance (Dwarf): 96264 → 79358 → 96135 → 96016, alles bij Veyric Thunderhame, einde bij Bath'rah. Stevig (3).
  - Horde: 79360 → 79364 → 79361 → 79366 → 79442. 🔴 Wie geeft en wie inneemt is NIET hard: QuestieDB en
    foreverquestlog noemen per quest Rau Cliffrunner, Prate Cloudseer én Bath'rah door elkaar; drie gidsen schrijven
    letterlijk "volg je questlog". Ik heb gekozen: de NPC die de doeltekst van de quest zelf noemt (GEMETEN voor
    79364, 79361, 79442), en Rau voor de rest. Onzeker blijft vooral: waar lever je 79360 in (Rau of Bath'rah) en wie
    geeft 79366 (Prate of Rau; ze staan 12 kaartpunten uit elkaar in Thousand Needles).
  - Beloning GEMETEN (Wowhead Forever-pagina 79442, ruwe tekst): kies Lightning's Grasp / Tidebringer's Claw / Rage of
    the Storm, plus Elementalist's Guard (schild). foreverquestlog toont voor de Horde alleen Rage of the Storm: conflict.
- **Weggelaten:** 79365 With Wind Beneath Your Wings (Bath'rah → Rau, alleen Orc/Tauren volgens foreverquestlog, staat
  niet in de Wowhead-reeks): onduidelijk of je hem krijgt. Windshaper (Skyborne): 79361 en 79442 hebben in twee
  bronnen alleen Orc/Tauren/Troll; één gids zegt dat Windshapers de keten wel lopen. Niet gebouwd; met een quest in
  het log volgt de route vanzelf.
- **Niet gevonden:** een Sunken Temple-keten voor de Dwarf-shaman. 8410-8413 hebben in QuestieDB een Horde-masker en
  er is geen Alliance-kopie in de Forever-lijst (zelfde zoekopdracht raakte wel 8410-8418). AFGELEID dat hij niet bestaat.
- **Niet gemeten:** de precieze plek van de blauwe cirkel (31.0, 45.8 = spawn van Ravaging Tempest, één bron);
  klikken op de zak óf de Corrupted Totems gebruiken (bronnen verschillen, de tekst noemt beide).

### Paladin
- **Was er al (wapens):** Verigan's Fist (`verigan` + `veriganore` + `verigangem`, 20, Alliance), Wolfsbane
  (`wolfsbane` + `wolfsbanegem`, 20, Undead), Bandarion Keep (`keep`, 8, Undead: knots + schild), `mightstone` (50,
  Alliance, o.a. Lightforged Blade).
- **Komt erbij:** niets.
- **Niet gevonden:** een level 50-keten voor de Undead-paladin. 8414-8418 hebben ras-masker 5 (Human + Dwarf) en er
  is geen Undead-kopie in de Forever-lijst. AFGELEID dat hij niet bestaat.
- De vier in de kop genoemde "gevonden, niet onderzocht" (Cloak of the Divine Storm, Aeonas, Reliquary of Tyr, Errant
  Knight) gaven 0 treffers in Spoken's lijst. Dat bewijst niets: dezelfde grep vond ook de bestaande rogue-ketens
  Xelthos en Bhossca niet, dus Spoken mist zulke nieuwe quests. Niet onderzocht; of ze een wapen geven weet ik niet.

### Mage
- **Was er al (wapens):** `focus` (10, staf of orb), `windbough` (10, Skyborne-wand), `items` + `wand` (30, Mage's
  Wand), `celestial` (35), `magecraft` (50, Glacial Spike). **Komt erbij:** niets.

### Hunter
- **Was er al:** tame, training, `charm` (50, Sunken Temple). **Komt erbij:** niets tussen 10 en 55 gevonden.
- **Weggelaten:** The Ancient Leaf 7632-7636 (60, begint met een raid-item).

### Rogue
- **Was er al:** `blade` (10, een dolk), tools, poisons, xelthos, bhossca, azure (50). **Komt erbij:** niets.

### Priest
- **Was er al:** robe (5), ras-spells (10, 20), `cenarion` (50, Sunken Temple). **Komt erbij:** niets gevonden.

### Druid
- **Was er al:** bear, poison, aquatic, cat, `torwa` (50, o.a. Moonshadow Stave). **Komt erbij:** niets gevonden.

### Sunken Temple-ronde (level 50)
Gebouwd waren: warrior, paladin (A), hunter, rogue, priest, shaman (H), mage, druid. Nieuw: warlock. Daarmee heeft
elke class er één; Dwarf-shaman en Undead-paladin hebben er geen (AFGELEID, zie boven).

### Geen classquest, wel gezien
"The Valor Family" in Darkshire (96139 bij Sirra Von'Indi, level 18, Alliance) met Ira's Dagger 96137, Merrick's Bow
96138, Grant's Shield 79362, Silvia's Sword 79363. QuestieDB geeft twee ervan een shaman- en Horde-masker, wat niet bij
een Darkshire-NPC past. Niet onderzocht; geen classquest.

## 4. Foutsoorten-checklist

| Soort | Wat ik deed |
|---|---|
| Aantallen | In de teksten: 8 Elunite Ore, 3 + 1 fragmenten, 10 Rotting Wood, 4 Bloodvenom Essence, 2 veren per kleur, 5 × 4 totems, 1 Felcloth. Alles GEMETEN in Wowhead Forever-tooltips. |
| Parallelle quests | Orahil: twee shard-quests die elkaar uitsluiten en naast 1799 lopen → als item-stappen ín 1799. 8419/8420 en de vier wijs-quests → `alt`. Horde Call of Air heeft drie id's → geen `needs`. |
| Route ander ras | Eén `key` per keten (`firstweapon`, `orahil`, `imprequest`, `tempest`) zodat `MyChains` een andere route oppakt. Grens: zie Warrior. |
| Factie-filters | QuestieDB-fout 4967/4968 gevonden. Horde-shaman zonder Skyborne. |
| Afwezig in ItemSparse | Soul Harvester 20536, Abyss Shard 20534, Robes of Servitude 20530 ontbreken in ItemSparse 70959; de Wowhead Forever-tooltips bestaan wel. Bewijst niets. |
| Clientnamen | 8 NPC's × 6 talen GEMETEN (Wowhead per taal + Spoken, 2), behalve Rau Cliffrunner ptBR (1). Item- en monsternamen in de nieuwe teksten zijn NIET per taal gemeten. |
| Wat klik je | Strongbox, kist, wapenrekken, kratten: uit Zygor en QuestieDB (item ← object). Edelsteen op demon: niet gemeten. |
| Forever ≠ Classic | Elke quest-id geeft een Wowhead **Forever**-tooltip; ketens uit QuestieDB **Forever** en Spoken (Forever 70450); beloningen van Wowhead Forever-pagina's. Tempest is nieuw in Forever. |
| Elite / groep | Dungeons: BFD, SFK, RFK, Sunken Temple. Elites: Demon of the Orb (40), Ravaging Tempest (40). De warrior-quests: geen elite (Dead-Tooth Jack en Shade of Elura level 11 normaal). |

Uit mijn hoofd, niet gemeten (staat zo in een tekstsleutel): de namen "Agamand Mills" en "Irontree Woods" als plek.
Zygor geeft alleen coördinaten ("the crypt", "around this area"). Laat de bouwchat ze nameten of weglaten.
Monster-levels in de totem-teksten: gids conquestcapped (19 okt) + deels Wowhead-tooltips (Mirefin 35-37, Lost One
35-37, Dustbelcher 38-39, Stonevault Bonesnapper 39-40, Maraudine 38-40).

## 5. Advies: de melding "je bent level X: er is een wapenquest"

- **Is er al een melding?** GEMETEN (grep in `Modules/Forever*.lua`): de classquest-functies worden alleen aangeroepen
  uit `ForeverDoNow.lua`, `ForeverOverview.lua` en `ForeverHowToPlay.lua`. `ForeverDoNow.lua:803` ververst bij
  `PLAYER_LEVEL_UP`, dus de regel verschijnt vanzelf in "Do this now". AFGELEID: een aparte melding op het moment van
  level-up is er niet (ik heb de level-up-code van `ForeverTrainer.lua` en `ForeverChars.lua` niet gelezen).
- **Voorstel:**
  1. Geef wapenketens een vlag `weapon = true` (nieuw: firstweapon, soranruk, orahil, imprequest, tempest; bestaand:
     whirlwind, verigan, wolfsbane, keep, blade, focus, windbough, wand, celestial, en de level 50-ketens).
  2. Bij level-up: is er een keten met `weapon` die nú voor het eerst `Ready` is (level gehaald én `needs` gedaan) →
     één regel, bv. `FCQ_NEW_WEAPON_FMT = "Level %d: a weapon quest for your class is open now: %s. Start: %s in %s."`
  3. Niet alleen in chat (Rob: "niemand kijkt in de chat"): dezelfde regel bovenaan de classquest-kaart, met de
     pijl-knop. Chat als logboek erbij.
  4. Een schakelaar (spelers kiezen): aan / uit.
  5. Let op `needs`: de warrior-wapenketen opent pas na de Defensive Stance-quest. Meld hem dus op dát moment, niet
     op level 10 zelf.
- **Twee kleine motor-wensen die uit dit werk komen (geen opdracht, een idee):**
  - "Heb dit bij je vóór je de quest haalt": nu werkt `pre` alleen met de quest in je log. Voor Impsy (Felcloth) heb
    ik het opgelost door bij de trainer te beginnen.
  - Een "lever in bij A of B"-tekst voor ketens waar de bronnen het niet eens zijn (Horde-Tempest).

## 6. Voor de TESTLIJST (in het spel nameten)

1. Horde-shaman: per Tempest-quest wie hem geeft en wie hem inneemt (vooral 79360 en 79366).
2. Shaman: plek van de blauwe cirkel bij de steam pools; klik je de zak of gebruik je het item.
3. Warlock: hoe gebruik je de edelsteen bij Mannoroc Coven; biedt Menara 1799 aan zonder de wijs-quest.
4. Warrior: klopt de volgorde van de vier Agamand-rekken met de index (1 axe, 2 dagger, 3 mace, 4 sword).
5. Alle nieuwe coördinaten (Zygor of Wowhead, geen enkele in het spel gezien).
6. Night Elf-warrior: liggen de kratten Elunite onder water.

## 7. Bronnen en werkwijze

- Wowhead Forever-tooltips via `tools/gamedata.py`, zoals de opdracht vroeg mét argumenten op de commandoregel (geen
  `probe_job.txt`). Eén keer liepen twee gamedata-aanroepen tegelijk (npc + object); alleen lezen, geen job-bestand.
- Wowhead Forever-questpagina's (beloningen, reeksen, reacties) via WebFetch/Exa, 18 nov 2026.
- QuestieDB (openbaar, GitHub, commit e9a67d1), gedownload naar `scratchpad\dl_questie_forever\` en alleen met Grep
  gelezen. `classicQuestDB.lua` in die map is een 404-bestand (verkeerd pad, niet gebruikt).
- Spoken (`_forever_\Interface\AddOns\Spoken_Quests\Data\Compendium.lua`, `Locale\Names\*.lua`).
- Zygor Forever (Horde warrior 23511-23625, Alliance warlock 24079-24175).
- HandyNotes_DungeonRaidLocations-Forever (ingang Razorfen Kraul).
- foreverquestlog.com en zeven gidsen (namen en datums staan bovenin het lua-bestand). Gidsen van vóór 4 nov (launch)
  beschrijven de beta.
- Niets gelezen onder `MidnightHelper/docs/`.
