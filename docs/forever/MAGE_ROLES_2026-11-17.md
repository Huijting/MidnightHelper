# Mage per rol (WoW Forever) — feiten voor mh-writer

Onderzoek: mh-research, 17 nov 2026. Client: Forever build **1.60.1.70938**.
Doel: `ROLES.MAGE` in `Modules/ForeverHowToPlay.lua`, in dezelfde vorm als `ROLES.DRUID` (r. 373-453):
per rol `band`, `title`, en een body met "Simple order", "Per 10 levels" (10-60) en "Beginner mistakes".

**Niets hiervan is in de client getest.** Alles komt uit DB2, uit MH's eigen bestanden en uit gidsen.
Rob speelt zelf een Forever-mage: hij kan de punten in hoofdstuk 12 nameten.

Let op: `docs/forever/DRUID_ROLES_2026-11-16.md` heb ik **niet gelezen** (mijn agentregel: niets lezen onder `docs/`).
De vorm komt uit `ROLES.DRUID` in de Lua zelf.

---

## 0. Bronnen (afkortingen in dit bestand)

Elke bewering hieronder heeft **GEMETEN** (met bron) of **AFGELEID** (beredeneerd).
"GEMETEN in gids" betekent: ik heb gezien dát de gids het zegt. De bewering zelf is dan niet in DB2 of de client nagemeten, tenzij dat erbij staat.

| Code | Bron | Datum |
|---|---|---|
| **D** | Blizzard DB2, lokale cache `C:\Users\RobHu\AppData\Local\MidnightHelper\gamedata_cache\db2\1.60.1.70938\<Tabel>.enUS.csv` (r. = regelnummer in dat CSV) | build 1.60.1.70938, gelezen 17 nov 2026 |
| **TD** | `Modules/ForeverTrainerData.lua` r. 345-519 (MAGE) | gegenereerd 7 nov 2026 |
| **KB** | `Modules/ForeverBlock_Mage.lua` r. 18-74 (het vaste toetsenblok) | 6 nov 2026 |
| **HP** | `Modules/ForeverHowToPlay.lua` (CLASSES.MAGE r. 102-127, ROLES.DRUID r. 373-453) | 16 nov 2026 |
| **FM** | `Modules/ForeverMacros.lua` (SPEC_MACROS r. 495-515, TREE r. 674, banden r. 671-673 en 703) | 17 nov 2026 |
| **IV-F** | https://www.icy-veins.com/wow-forever/frost-mage-leveling (Teloril) | bijgewerkt 10 nov 2026 |
| **IV-A** | https://www.icy-veins.com/wow-forever/arcane-mage-leveling (Farmerfarms) | bijgewerkt 4 nov 2026 |
| **IV-V** | https://www.icy-veins.com/wow-forever/fire-mage-leveling (Farmerfarms) | bijgewerkt 4 nov 2026 |
| **IV-O** | https://www.icy-veins.com/wow-forever/mage-class-overview | bijgewerkt 27 okt 2026 |
| **CWF-F / -A / -V** | https://classicwowforever.com/class-guides/mage/frost/ , `/arcane/` , `/fire/` (Garazon, "Spell build 1.60.1.70862") | bijgewerkt 11 nov 2026 |
| **WFI** | https://wowforeverinfo.com/guides/mage-leveling/ (tooltips per rang; "Talent data was updated on 5 November 2026") | 22 okt, bijgewerkt 9 nov 2026 |
| **PS** | https://polestar.guide/guides/class/mage ("Checked on game build 1.60.1.70450"; plannen gepauzeerd volgens https://polestar.guide/docs/players/talent-plans) | beta-build (okt 2026) |
| **WH-F / -V / -A** | https://www.wowhead.com/forever/guide/classes/mage/frost/level-20-dps-overview (Porom, "created during the beta and is no longer updated"), `/fire/overview-pve-dps`, `/arcane/overview-pve-dps` (Foolipe) | geen datum zichtbaar |
| **MOB** | https://mobalytics.gg/wow-forever/classes/mage-leveling-guide (Asuna_qt) | bijgewerkt 4 nov 2026 |
| **MRR** | https://mobalytics.gg/wow-forever/classes/mrronit-s-arcane-mage-levelling-guide-1-60 | geen datum |
| **WFA** | https://www.wowforeveraddon.com/guides/mage-leveling-guide/ | geen datum |
| **TF** | https://talentsforever.com/mage/leveling (71.372 geplande builds, 18 sep - 4 nov) | geteld 5 nov 2026 |
| **CWG** | https://classicwow.gg/forever/guides/mage | geen datum |
| **SYS** | https://systematic.gg/forums/mage/t/arcane-mage-leveling-in-wow-forever-level-10-60-arcane-blast-missile-barrage-rotation-dungeons | 24 okt 2026 (beta) |
| **WFDB** | https://wowfdb.com/classes/mage/fire/rotation/ | geen datum |
| **WT** | https://www.warcrafttavern.com/forever/guides/mage/ | geen datum |
| **WFL** | https://wowforeverleveling.com/guides/fire-mage-leveling-wow-forever | 4 nov 2026 |

Alle gidsen gelezen via Exa op 17 nov 2026. Helemaal gelezen: IV-O, IV-V, CWF-F, CWF-A, CWF-V (tot level 60-blok), WFI (tot in het Fire-speeldeel). Van de rest alleen de stukken die de zoekmachine teruggaf.
Alle gidsen zijn van ná 18 aug 2026. De oudste (PS, SYS, WH-F) zijn van de beta en op punten verouderd: zie hoofdstuk 11.

---

## 1. Samenvatting

| Rol | Boom | **band** | Eerste eigen spell | Talent-spells (vroegste level, toets) |
|---|---|---|---|---|
| Arcane | Arcane | **1** | Arcane Missiles, 8 (**3**) | Arcane Blast 20 (**Ctrl-2**), Arcane Wrath 25 (**Shift-F1**), Presence of Mind 30 (**Shift-3**), Arcane Power 40 (**Q**) |
| Fire | Fire | **2** | Fireball, 1 (**1**) | Pyroblast 20 (**4**), Blast Wave 30 (**F3**), Combustion 40 (**Q**) |
| Frost | Frost | **3** | Frostbolt, 4 (**2**) | Ice Lance 20 (**F**), Ice Block 25 (**C**), Cold Snap 30 (**Shift-C**), Ice Barrier 40 (**X**) |

Alle drie zijn damage van afstand. Geen vormen, geen stances: elke toets doet altijd hetzelfde (GEMETEN: KB r. 19 `states = {}`).

---

## 2. Welke boom is welke band — GEMETEN

- De mage-boom is `TraitTree` **1112**. GEMETEN: D `TraitTree` r. 11 (`,1112,10,0,0,0,1,1,1,0`) en FM r. 674 (`MAGE = 1112`).
- De boom heeft **53 nodes**. GEMETEN: D `TraitNode` r. 300-351 en r. 554 (node 113627).
- De nodes staan in drie groepen op PosX: 1020-2820 (18 nodes), 5020-6820 (17 nodes), 9080-10880 (18 nodes). GEMETEN: dezelfde regels. Dat zijn precies MH's banden (FM r. 671-673; in code r. 703: `posX < 4000` = 1, `< 8000` = 2, anders 3).
- **Band 1 = Arcane**: daar staan Arcane Power (12042), Arcane Blast (400574), Presence of Mind (12043). **Band 2 = Fire**: Combustion (11129), Pyroblast (11366), Blast Wave (11113). **Band 3 = Frost**: Ice Barrier (11426), Ice Block (11958), Ice Lance (1312002). GEMETEN: de keten D `TraitNode` → `TraitNodeXTraitNodeEntry` (r. 299-350, 557) → `TraitNodeEntry` (r. 315-368, 660) → `TraitDefinition` (r. 315-368, 660) → `SpellName`.
- Dat klopt met de tabvolgorde: D `TalentTab` r. 2-4: Arcane OrderIndex 0, Fire 1, Frost 2 (ClassMask 128). GEMETEN. En met FM r. 643 (`enUS = { "Arcane", "Fire", "Frost" }`). GEMETEN.

---

## 3. Vroegste level per talent — hoe het gemeten is

- Elke rij van de boom heeft een slot: "geef eerst N punten uit in de rijen erboven, in dezelfde band". GEMETEN: D `TraitCond` r. 89-106 (18 voorwaarden, 6 per band, `SpentAmountRequired` 5/10/15/20/25/30, currency 3820) en D `TraitNodeGroupXTraitCond` r. 89-106 (welke rij elke voorwaarde op slot zet) en D `TraitNodeGroupXTraitNode` (welke nodes in welke groep).
- Rij = PosY: 2130 → 0 punten, 2730 → 5, 3330 → 10, 3930 → 15, 4530 → 20, 5130 → 25, 5730 → 30. GEMETEN (zelfde tabellen; elke rij-groep nagelopen).
- Talentpunten: **1 punt per level, vanaf level 10 tot en met 60 = 51 punten**. GEMETEN: D `TraitCurrencySource` r. 2-52 ("Level 10" … "Level 60", elk Amount 1, currency 3820) en D `TraitTreeXTraitCurrency` r. 8 (boom 1112 gebruikt currency 3820).
- Dus: een talent in een rij die N punten vraagt, kan op zijn vroegst met punt N+1 = **level 10 + N**. AFGELEID (rekensom op gemeten getallen). Rijen: **10, 15, 20, 25, 30, 35, 40**.
- De Legacy-perk **Talented** geeft tot 5 punten eerder (rang 1-5: een punt op level 9/8/7/6/5). GEMETEN: D `TraitCurrencySource` r. 114-118. Dus elk talent-level hieronder kan tot 5 levels eerder. AFGELEID. Dezelfde zin als bij de druid ("a perk can bring them up to 5 levels sooner", HP r. 387) past hier.
- De levels kloppen met de gidsen: WFI zegt bij elk talent "Requires N points in <boom>" met dezelfde N (bv. Ice Lance 10, Ice Block 15, Fingers of Frost 20, Winter's Chill 25, Ice Barrier 30; Pyroblast 10, Heating Up 15, Blast Wave 20, Fire Power 25, Combustion 30; Missile Barrage 5, Arcane Blast 10, Arcane Wrath 15, Presence of Mind 20, Arcane Instability 25, Arcane Power 30). GEMETEN in gids (WFI). CWF noemt dezelfde levels (Ice Lance 20, Ice Block 25, Cold Snap 30, Ice Barrier 40, Pyroblast 20, Heating Up 25, Blast Wave 30, Combustion 40, Missile Barrage 15, Arcane Blast 20, Arcane Wrath 25, Presence of Mind 30, Arcane Power 40). GEMETEN in gids.
- De levels in `SPEC_MACROS` (FM r. 496-514) kloppen alle negen met deze meting: Arcane Power 40, Arcane Blast 20, Arcane Wrath 25, Pyroblast 20, Combustion 40, Blast Wave 30, Ice Block 25, Ice Lance 20, Ice Barrier 40. GEMETEN.

**"Vroegste level" is geen advies.** Gidsen nemen sommige talenten later (bv. CWF-F neemt Fingers of Frost op 37-38, WFI-Fire neemt Pyroblast op 23 en Combustion op 43). GEMETEN in gids.

### Vereisten tussen talenten — GEMETEN (D `TraitEdge` r. 37-41, 62, 88)

| Eerst nodig | Dan pas |
|---|---|
| Ice Lance | Fingers of Frost |
| Cold Snap | Ice Barrier |
| Critical Mass | Combustion |
| Pyroblast | Heating Up |
| Presence of Mind | Arcane Power |
| Arcane Blast | Arcane Wrath |
| Arcane Concentration | Arcane Meditation |

Richting (links = eerst nodig) is AFGELEID uit de rijen (de linker node staat steeds hoger in de boom). Gidsen bevestigen drie ervan: "Arcane Wrath … needs Arcane Blast first" (CWF-A), "Heating Up (row 4, needs Pyroblast)" (WFL), "All five [Arcane Concentration] are needed for Arcane Meditation" (CWF-A). GEMETEN in gids.
Geen van deze vereisten maakt een talent later dan zijn rij-level. AFGELEID.

---

## 4. De drie bomen, per rij — GEMETEN (D, keten uit hoofdstuk 2)

Tussen haakjes: spell-id, maximaal aantal rangen. **Vet** = een spell met een toets.

### Band 1 — Arcane (45 punten in totaal)

| Level | Talenten |
|---|---|
| 10 | Wand Specialization (6057, 2) · Improved Channeling (11237, 5) · Arcane Resilience (28574, 3) |
| 15 | Arcane Subtlety (11210, 2) · Magic Absorption (29441, 2) · Arcane Concentration (11213, 5) · Missile Barrage (400588, 2) |
| 20 | Arcane Geometry (11247, 2) · Arcane Impact (11242, 3) · **Arcane Blast** (400574, 1) |
| 25 | Arcane Shielding (11252, 2) · Improved Counterspell (11255, 2) · Arcane Meditation (18462, 3) · **Arcane Wrath** (1326079, 1; node 113627) |
| 30 | **Presence of Mind** (12043, 1) · Arcane Mind (11232, 5) |
| 35 | Arcane Instability (15058, 3) |
| 40 | **Arcane Power** (12042, 1) |

Controle: 45 punten klopt met de teller in de rekenmachine van WFI ("Arcane 0 (45)"). GEMETEN in gids.

### Band 2 — Fire (46 punten)

| Level | Talenten |
|---|---|
| 10 | Incineration (18459, 5) · Accelerant (11069, 5) |
| 15 | Ignite (11119, 5) · Flame Throwing (11100, 2) · Impact (11103, 3) |
| 20 | Burning Soul (11083, 3) · Improved Flamestrike (11108, 3) · **Pyroblast** (11366, 1) · Improved Fire Blast (11078, 2) |
| 25 | Improved Scorch (11095, 3) · Improved Fire Ward (11094, 2) · Heating Up (400624, 1) · Master of Elements (29074, 3) |
| 30 | Critical Mass (11115, 3) · **Blast Wave** (11113, 1) |
| 35 | Fire Power (11124, 3) |
| 40 | **Combustion** (11129, 1) |

### Band 3 — Frost (48 punten)

| Level | Talenten |
|---|---|
| 10 | Frost Warding (11189, 2) · Improved Frostbolt (11070, 5) · Precision (29438, 3) |
| 15 | Ice Shards (11207, 5) · Frostbite (11071, 3) · Improved Frost Nova (11165, 2) · Permafrost (11175, 3) |
| 20 | Frost Channeling (11160, 3) · Improved Blizzard (11185, 3) · **Ice Lance** (1312002, 1) |
| 25 | Arctic Reach (16757, 2) · **Ice Block** (11958, 1) · Shatter (11170, 3) |
| 30 | Improved Cone of Cold (11190, 3) · **Cold Snap** (12472, 1) · Fingers of Frost (400647, 2) |
| 35 | Winter's Chill (11180, 5) |
| 40 | **Ice Barrier** (11426, 1) |

### Niet (meer) in de boom — GEMETEN

- **Piercing Ice** (11151) en **Arcane Focus** (11222): de definitie bestaat nog (D `TraitDefinition` r. 326 en 367), maar er hangt geen node meer aan (nodes 105773 en 105814 bestaan niet in D `TraitNode`; positieve controle in dezelfde zoekactie: node 105761 werd wél gevonden). Blizzards notes van 2 nov zeggen hetzelfde: "Piercing Ice is gone", "Arcane Focus is gone" (GEMETEN in gids: CWF-F, kop "What Blizzard changed").
- **"Improved Fireball"** heet nu **Accelerant** (spell 11069, D `SpellName` r. 3230). Het verkort ook Frostfire Bolt en Arcane Wrath (D `Spell` r. 3504).
- **Frost Blast** en **Wake of Fire**: de namen staan nog in D `SpellName`, maar niet in de boom en niet in TD. "Frost Blast is gone" (CWF-F, Blizzard-notes 2 nov). Gidsen die ze noemen (IV-A, MOB, WH-V) lopen achter. Niet noemen.

---

## 5. Wat de spells doen — getallen

DB2-waarden hieronder zijn **rang 1** van de spell, tenzij anders gezegd. De getallen kloppen 1-op-1 (controle: Frostbolt vertraagt met 40%, D `SpellEffect` r. 90 = −40).

⚠️ **Talenten met meer rangen:** de waarde per rang staat niet betrouwbaar in de tabellen die ik heb (D `SpellEffect` geeft bij Shatter "1" en bij Arcane Concentration "100"; de echte waarde komt uit een tabel die niet in de cache zit, `TraitDefinitionEffectPoints`). Voor die talenten gebruik ik de tooltiptekst uit WFI en CWF. Dat is GEMETEN in gids, **niet** in DB2.

### Talent-spells met een toets

| Spell | Feiten | Bron |
|---|---|---|
| **Arcane Blast** (Ctrl-2) | Cast 1,5 s (ook op de hoogste rang). Geen cooldown. Elke cast: 12% van je Intellect als spell damage erbij, en de volgende Arcane Blast kost 100% meer mana. Duurt 18 s vanaf de eerste. | GEMETEN: D `SpellMisc` r. 17055 en 26672 (cast-index 16 = 1500 ms), `SpellCooldowns` r. 2749, `SpellEffect` r. 21386-21387 (12 en 100), `SpellDuration` r. 44 (18000 ms) |
| | Stapelt tot **4** keer. | GEMETEN in gids (WFI-tooltip, CWF-A, IV-A). Niet in DB2 gemeten (tabel SpellAuraOptions zit niet in de cache) |
| **Arcane Wrath** (Shift-F1) | Cast 3,5 s. Cooldown 6 s. Krijgt extra spell damage: 5% van je maximale mana. | GEMETEN: D `SpellMisc` r. 31887 (index 22 = 3500 ms), `SpellCooldowns` r. 4474 (6000), `SpellEffect` r. 42619 (5) |
| **Presence of Mind** (Shift-3) | Je volgende mage-spell met een cast korter dan 10 s is instant. Cooldown 3 minuten. | GEMETEN: D `Spell` r. 3873, `SpellCooldowns` r. 1502 (180000) |
| **Arcane Power** (Q) | 15 s lang: spells doen 30% meer damage en kosten 30% meer mana. Cooldown 3 minuten. | GEMETEN: D `Spell` r. 3872, `SpellEffect` r. 3979-3981 (30), `SpellDuration` r. 9 (15000), `SpellCooldowns` r. 777 (180000) |
| **Pyroblast** (4) | Cast **6 s**. Geen cooldown. Damage, en daarna 12 s lang nog damage. | GEMETEN: D `SpellMisc` r. 5344 en 7181 (index 171 = 6000 ms), `SpellDuration` r. 27 (12000), `SpellCooldowns` r. 1282 |
| **Blast Wave** (F3) | Instant, rond jezelf. Damage, en vijanden lopen 6 s lang 50% trager. Cooldown 45 s. | GEMETEN: D `Spell` r. 3519, `SpellEffect` r. 6012 (−50), `SpellDuration` r. 30 (6000), `SpellCooldowns` r. 1148 (45000) |
| **Combustion** (Q) | Elke Fire-treffer geeft 10% meer crit-kans met Fire. Cooldown 3 minuten. | GEMETEN: D `Spell` r. 3523, `SpellEffect` r. 17645 (10), `SpellCooldowns` r. 1322 (180000) |
| | Stopt na **3** crits (alleen directe treffers tellen, geen DoT-tikken). | GEMETEN in gids (WFI-tooltip, CWF-V, CWG). Het getal 3 is niet in DB2 gemeten |
| **Ice Lance** (F) | Instant. Cooldown **8 s**. Doet 300% meer damage op een Frozen vijand. | GEMETEN: D `SpellMisc` r. 31260 (index 1 = instant), `SpellCooldowns` r. 4353 (8000), `SpellEffect` r. 41670 (300), `Spell` r. 18182 |
| | Deelt die cooldown met **Fire Blast**. | GEMETEN in gids (CWF-F citeert Blizzards notes van 2 nov; WFI; WFA). In DB2 hebben beide 8 s categorie-cooldown (`SpellCooldowns` r. 422 en 4353); dát het dezelfde categorie is, is niet in DB2 gemeten |
| **Ice Block** (C) | 10 s lang kan niets je raken, maar je kunt niet aanvallen, lopen of casten. Cooldown 5 minuten. | GEMETEN: D `Spell` r. 3842, `SpellDuration` r. 2 (10000), `SpellCooldowns` r. 934 (300000) |
| **Cold Snap** (Shift-C) | Zet de cooldown van al je andere Frost-spells op nul. Eigen cooldown 10 minuten. | GEMETEN: D `Spell` r. 3951, `SpellCooldowns` r. 1395 (600000) |
| **Ice Barrier** (X) | Schild dat damage opvangt. 1 minuut lang 15% meer Frost-damage; zolang het schild heel is nog 5% erbij, en klappen vertragen je cast niet. Cooldown 30 s. | GEMETEN: D `Spell` r. 3673, `SpellEffect` r. 42729-42731 (5 en 15), `SpellDuration` r. 4 (60000), `SpellCooldowns` r. 1279 (30000) |

### Talenten zonder toets die het spel veranderen

| Talent (vroegst) | Wat het doet | Bron |
|---|---|---|
| Missile Barrage (15) | Arcane Blast heeft kans, en Arcane Wrath / Fireball / Frostbolt / Frostfire Bolt de helft van die kans, dat je volgende Arcane Missiles 50% korter duurt en 100% minder mana kost (dus gratis). | GEMETEN: D `Spell` r. 8774, `SpellEffect` r. 21391-21393 (−50, −100) |
| | Kans op 2/2: 40% (Arcane Blast) en 20% (de rest). Op 1/2: 20% en 10%. | GEMETEN in gids (WFI-tooltips, CWF-A) |
| Arcane Concentration (15) | Na een damage-spell kans op Clearcasting: je volgende damage-spell kost geen mana. 5/5 = 10%. | GEMETEN: D `Spell` r. 3554 (tekst). 10% = GEMETEN in gids (WFI, CWF-A) |
| Improved Channeling (10) | 5/5: Arcane Missiles wordt niet meer korter als je geraakt wordt; Arcane Blast en Arcane Wrath 70% van de keren niet. | GEMETEN: D `Spell` r. 3557 (tekst). Getallen GEMETEN in gids (WFI) |
| Arcane Meditation (25) | 3/3: 50% van je mana-regeneratie loopt door terwijl je cast. | GEMETEN: D `Spell` r. 23759 (tekst). 50% GEMETEN in gids (WFI, CWF-A) |
| Arcane Subtlety (15) | 2/2: Arcane-spells geven 30% minder threat. | GEMETEN in gids (WFI-tooltip); tekst D `Spell` r. 3553 |
| Heating Up (25) | Een crit (geen DoT-tik) met Fireball, Frostfire Bolt, Fire Blast of Scorch maakt je volgende Pyroblast 25% sneller, 20 s lang. Fire Blast geeft bij elke treffer een extra stapel. | GEMETEN: D `Spell` r. 8782, `SpellEffect` r. 21413 (−25), `SpellDuration` r. 17 (20000) |
| | Maximaal **3** stapels. 3 stapels = Pyroblast in 1,5 s, **niet** instant. | 3 stapels: GEMETEN in gids (WFI, CWF-V, CWG) en D `SpellEffect` r. 41172 geeft −3. 1,5 s: AFGELEID (6 s × 25%); WFDB en WFL noemen ook 1,5 s |
| Ignite (15) | 5/5: een Fire-crit laat het doel nog 40% van die damage branden, in 4 s. | GEMETEN: D `Spell` r. 3521, `SpellEffect` r. 7091 (40), `SpellDuration` r. 31 (4000) |
| Impact (15) | Fire-spells hebben een kans het doel 2 s te stunnen. | GEMETEN: D `Spell` r. 3517, `SpellDuration` r. 35 (2000). Kans per rang niet gemeten |
| Improved Fire Blast (20) | 2/2: Fire Blast elke 6 s in plaats van 8, en 15 yards verder. | GEMETEN in gids (WFI-tooltip, CWF-V); tekst D `Spell` r. 3507 |
| Improved Scorch (25) | Scorch kan het doel kwetsbaar maken: 3% meer Fire-damage **van jou** per stapel, tot 5 stapels, 30 s. | GEMETEN: D `Spell` r. 3515 en 6654, `SpellEffect` r. 14912 (3), `SpellDuration` r. 128 (30000) |
| Frostbite (15) | Je vertragingen (Chill) hebben een kans het doel 5 s te bevriezen. 3/3 = 15%. | GEMETEN: D `Spell` r. 3506, `SpellDuration` r. 131 (5000). 15% op 3/3 en 10% op 2/3: GEMETEN in gids (WFI) |
| Shatter (25) | 3/3: 50% meer crit-kans op een Frozen vijand, met al je spells. | Tekst GEMETEN: D `Spell` r. 3529. 50%: GEMETEN in gids (WFI, CWF-F) |
| Fingers of Frost (30) | Je vertragingen hebben 15% kans (2/2) dat je volgende **2** spells doen alsof het doel Frozen is. Duurt 15 s. | GEMETEN: D `Spell` r. 8785, `SpellEffect` r. 21415 (2), r. 39615 (15), `SpellDuration` r. 9 (15000) |
| Winter's Chill (35) | Frostbolt (en Ice Lance met Fingers of Frost) zet stapels op het doel. Je volgende **Cone of Cold** doet per stapel 20% meer damage. Tot 5 stapels. | GEMETEN: D `Spell` r. 3531, `SpellEffect` r. 6324 (20), r. 6194 (5). Heel anders dan in Classic |
| Improved Blizzard (20) | Blizzard vertraagt ook: 40%, 1,5 s. | GEMETEN: D `Spell` r. 3532, `SpellEffect` r. 6645 (−40), `SpellDuration` r. 42 (1500). CWF-F: "caps that slow at 40% for 1.5 sec" |
| Improved Frost Nova (15) | 2/2: Frost Nova elke 21 s in plaats van 25. | GEMETEN in gids (CWF-F); tekst D `Spell` r. 3528 |
| Precision (10, Frost) | 3/3: 6% meer kans om te raken met alle spells. Alle drie de rollen nemen het in de gidsen. | Tekst GEMETEN: D `Spell` r. 8212. 6%: GEMETEN in gids (WFI, CWF) |

### Gewone spells (trainer) — cooldowns en duur, GEMETEN in D

| Spell (toets) | Feit | Bron |
|---|---|---|
| Frostbolt (2) | Vertraagt 40%. Cast 1,5 s op rang 1, 3,0 s op de hoogste trainer-rang. | `SpellEffect` r. 90; `SpellMisc` r. 79 en 4535 |
| Fireball (1) | Cast 1,5 s op rang 1, 3,5 s op de hoogste rang. | `SpellMisc` r. 94 en 4463 |
| Fire Blast (5) | Instant. Cooldown 8 s. | `SpellCooldowns` r. 422 |
| Scorch (Ctrl-1) | Cast 1,5 s. | `SpellMisc` r. 1172, 5178 |
| Frostfire Bolt (Ctrl-3) | Trainer, level 40. Cast 3 s. Vertraagt 40%, en geeft 9 s lang nog damage. Telt als Fire én Frost. | TD r. 442; `SpellLevels` r. 7217; `SpellMisc` r. 17085; `SpellEffect` r. 21430; `SpellDuration` r. 46; `Spell` r. 8809 |
| Frost Nova (V) | Bevriest tot 8 s. Damage kan het breken. Cooldown 25 s. | `Spell` r. 31; `SpellDuration` r. 29; `SpellCooldowns` r. 84 |
| Cone of Cold (Shift-F) | Kegel vóór je. Vertraagt 6 s. Cooldown 10 s. | `Spell` r. 29; `SpellDuration` r. 30; `SpellCooldowns` r. 1199 |
| Polymorph (Shift-Q) | Werkt alleen op Beasts, Humanoids en Critters. Elke damage breekt het. Eén doel tegelijk. | `Spell` r. 28 |
| Counterspell (E) | Stopt een cast; die school 10 s op slot. Cooldown 30 s. | `Spell` r. 512; `SpellDuration` r. 2; `SpellCooldowns` r. 347 |
| Blink (R) | 20 yards vooruit; haalt je ook uit stuns en roots. Cooldown 15 s. | `Spell` r. 481; `SpellCooldowns` r. 429 |
| Evocation (F1) | 8 s kanaliseren voor mana. Cooldown 8 minuten. | `Spell` r. 3874; `SpellDuration` r. 29; `SpellCooldowns` r. 1464 |
| Flamestrike (Shift-4) | Cast 3 s. Maar één Flamestrike tegelijk per mage. | `Spell` r. 506; `SpellMisc` r. 822 |
| Arcane Explosion (Shift-2) | Instant, rond jezelf. | `Spell` r. 396; `SpellMisc` r. 566 |
| Mana Shield (Z) | Vangt alleen **fysieke** damage op, en dat kost mana. | `Spell` r. 404 |
| Fire Ward (F4) / Frost Ward (F2) | Delen één cooldown van 30 s. | `SpellCooldowns` r. 5 en 759 (staat al in HP r. 125) |

---

## 6. Toetsen — GEMETEN (KB r. 21-56; overgenomen, niets verzonnen)

| Toets | Spell | | Toets | Spell |
|---|---|---|---|---|
| **1** | Fireball | | **E** | Counterspell |
| **2** | Frostbolt | | **R** | Blink |
| **3** | Arcane Missiles | | **Shift-R** | Slow Fall |
| **4** | Pyroblast | | **F** | Ice Lance |
| **5** | Fire Blast | | **Z** | Mana Shield |
| **Shift-1** | Blizzard | | **X** | Ice Barrier |
| **Shift-2** | Arcane Explosion | | **C** | Ice Block |
| **Shift-3** | Presence of Mind | | **Shift-C** | Cold Snap |
| **Shift-4** | Flamestrike | | **V** | Frost Nova |
| **Ctrl-1** | Scorch | | **Shift-Q** | Polymorph |
| **Ctrl-2** | Arcane Blast | | **Shift-F** | Cone of Cold |
| **Ctrl-3** | Frostfire Bolt, anders Shoot (wand) | | **Shift-V** | Remove Lesser Curse |
| **Q** | Arcane Power, anders Combustion | | **Shift-Z** | Ice Armor, anders Frost Armor |
| **F1** | Evocation | | **Shift-X** | Arcane Brilliance, anders Arcane Intellect |
| **F2** | Frost Ward | | **Shift-E** | je ras-spell |
| **F3** | Blast Wave | | **Shift-F1** | Arcane Wrath |
| **F4** | Fire Ward | | | |

- Een toets met twee spells: de eerste die je kent wint. GEMETEN: `Modules/ForeverBlock.lua` r. 16.
- **Q** is dus Arcane Power voor een Arcane-mage en Combustion voor een Fire-mage. Beide tegelijk kan niet: elk vraagt 30 punten in zijn eigen boom plus zichzelf, samen 62, en je hebt er 51 (56 met Talented). AFGELEID.
- **Ctrl-3** is je wand, tot je **Frostfire Bolt** leert (trainer, level 40). Dan neemt Frostfire Bolt de toets. Shoot moet je dan zelf op een Alt-toets zetten. GEMETEN: KB r. 31-33, HP r. 109. ⚠️ Dit raakt alle drie de rollen: de gidsen laten je juist veel met de wand afmaken.
- Niet op het blok, wel op blok D (eigen Alt-toetsen): **Mage Armor**, Amplify Magic, Dampen Magic, Conjure Water, Conjure Food, de mana-edelstenen (Conjure Mana Agate/Jade/Citrine/Ruby). GEMETEN: KB r. 60-66.
- Vaste toetsen voor elke klasse: T = potion, Shift-T = healthstone, G = trinket. GEMETEN: HP r. 33.

---

## 7. Wat je bij de trainer leert — GEMETEN (TD r. 345-519; nieuwe spells, geen rangen)

Steekproef van dertien spells tegen D `SpellLevels` (Frostbolt 4, Fire Blast 6, Arcane Missiles 8, Frost Nova 10, Arcane Explosion 14, Flamestrike 16, Blink 20, Scorch 22, Counterspell 24, Cone of Cold 26, Ice Armor 30, Mage Armor 34, Frostfire Bolt 40): alles gelijk. GEMETEN.

| Level | Nieuw (toets) |
|---|---|
| 1 | Arcane Intellect (Shift-X). Fireball (1) en Frost Armor (Shift-Z) heb je vanaf het begin: AFGELEID (ze staan niet in TD; hun rang 2 vraagt rang 1, TD r. 352 en 357; D `SpellLevels` geeft level 1) |
| 4 | Frostbolt (2), Conjure Water (blok D) |
| 6 | Fire Blast (5), Conjure Food (blok D), Comprehend Scroll (niet op het blok) |
| 8 | Arcane Missiles (3), Polymorph (Shift-Q) |
| 10 | Frost Nova (V) |
| 12 | Slow Fall (Shift-R), Dampen Magic (blok D) |
| 14 | Arcane Explosion (Shift-2) |
| 16 | Flamestrike (Shift-4) |
| 18 | Remove Lesser Curse (Shift-V), Amplify Magic (blok D) |
| 20 | Blink (R), Blizzard (Shift-1), Evocation (F1), Mana Shield (Z), Fire Ward (F4), eerste teleports |
| 22 | Scorch (Ctrl-1), Frost Ward (F2) |
| 24 | Counterspell (E) |
| 26 | Cone of Cold (Shift-F) |
| 28 | Conjure Mana Agate (blok D) |
| 30 | Ice Armor (Shift-Z neemt het over van Frost Armor) |
| 34 | Mage Armor (blok D) |
| 38 | Conjure Mana Jade (blok D) |
| 40 | **Frostfire Bolt** (Ctrl-3), eerste portals |
| 48 | Conjure Mana Citrine (blok D) |
| 58 | Conjure Mana Ruby (blok D) |

Na 40 komt er bij de trainer geen nieuwe gevechtsspell meer bij; alleen sterkere rangen. GEMETEN (TD r. 450-518).

**Sterkere rangen van talent-spells bij de trainer** (GEMETEN, TD):
Pyroblast 24, 30, 36, 42, 48, 54, 60 · Blast Wave 36, 44, 52, 60 · Ice Lance 28, 34, 42, 48, 56 · Ice Barrier 46, 52, 58 · Arcane Blast 30, 40, 50, 60 · Arcane Wrath 36, 48, 60 · Frostfire Bolt 50, 60.

**Sterkere rangen van de hoofdspells** (GEMETEN, TD):
Frostbolt 8, 14, 20, 26, 32, 38, 44, 50, 56 · Fireball 6, 12, 18, 24, 30, 36, 42, 48, 54, 60 · Fire Blast 14, 22, 30, 38, 46, 54 · Arcane Missiles 16, 24, 32, 40, 48, 56 · Scorch 28, 34, 40, 46, 52, 58 · Arcane Explosion 22, 30, 38, 46, 54 · Flamestrike 24, 32, 40, 48, 56 · Blizzard 28, 36, 44, 52, 60 · Cone of Cold 34, 42, 50, 58 · Frost Nova 26, 40, 54 · Ice Armor 40, 50, 60.
Noem geen rangnummers: TD r. 11-12 waarschuwt dat tellen in die lijst fout gaat.

**Arcane Brilliance** (Shift-X): spell-level 56 (GEMETEN: D `SpellLevels` r. 5918), maar staat **niet** in TD. Een item leert hem (GEMETEN: D `ItemEffect` r. 5517 → spell 23028). Welk item en waar: niet gemeten. Advies: weglaten, of alleen "56" zonder "trainer".

---

## 8. Rol **Arcane** — `band = 1`

### Waar hij goed in is

| As | Wat de bronnen zeggen |
|---|---|
| Eén doel | Sterk in korte uitbarstingen: Arcane Blast-stapels, dan Arcane Wrath en gratis Arcane Missiles; Arcane Power + Presence of Mind als grote klap. GEMETEN in gids (CWF-A, IV-A, WT). |
| Veel doelen | Arcane Explosion (instant, rond jezelf). In dungeons sterk, omdat Arcane Subtlety de threat verlaagt. GEMETEN in gids (WH-A: "the AoE feels amazing and is by far the highlight"; IV-A). Niet om alleen een groep mee te pakken. |
| Vertragen | **Het zwakst van de drie.** De boom heeft geen vertraging of bevriezing. Je gebruikt de gewone spells: Frostbolt om te openen, Frost Nova. GEMETEN: boom in hoofdstuk 4 (D). GEMETEN in gids: WFI ("the weakest at keeping enemies off you"), IV-A ("Lacks control & survivability"). |
| Levelen | Kan nu goed, maar gidsen zijn het niet eens. IV-A: "isn't just viable, it's powerful". MRR noemt het de beste. WFI, WFA, MOB en PS raden Frost aan en noemen Arcane mana-duur. TF: 31,1% van de geplande level-builds is Arcane (Frost 46,8%, Fire 22,1%). GEMETEN in gids. |
| Mana | Tegenstrijdig. IV-O: Arcane heeft de beste mana-hulp (Arcane Meditation, Missile Barrage, Arcane Concentration). WT, WFA en PS: juist mana-hongerig door Arcane Blast. Beide kloppen met DB2: de hulp-talenten bestaan, en elke Arcane Blast-stapel maakt de volgende 100% duurder. |

### Vanaf wanneer

- Arcane Missiles op 8, talentpunten vanaf 10, Missile Barrage op zijn vroegst 15, **Arcane Blast 20**. Tot 20 speel je met Frostbolt, Fireball en Arcane Missiles "like any mage". GEMETEN (D, TD; citaat CWF-A).

### Simple order (één vijand) — voorstel, met bron per stap

1. Open met Frostbolt (**2**): de vijand komt dan langzaam. GEMETEN in gids: IV-A, WFI, MRR, CWF-A. Vanaf 25 openen IV-A en MRR met Arcane Wrath (**Shift-F1**); bij IV-A komt Frostbolt eerst.
2. Arcane Blast (**Ctrl-2**, vanaf 20), een paar keer. Hoeveel: gidsen verschillen — zie hieronder.
3. Licht Missile Barrage op (vanaf 15)? Meteen Arcane Missiles (**3**): gratis en twee keer zo snel. GEMETEN in gids: alle (CWF-A: "Channel it the moment it lights up").
4. Arcane Wrath (**Shift-F1**, vanaf 25) zodra hij klaar is (cooldown 6 s), terwijl de stapels staan. GEMETEN in gids: CWF-A, WFI.
5. Vijand bij je? Frost Nova (**V**), stap weg. GEMETEN in gids: IV-A, CWF-A, MRR.
6. Bijna dood: wand (**Ctrl-3**, tot je Frostfire Bolt leert) of Fire Blast (**5**). GEMETEN in gids: IV-A, WFI, MRR.
7. Zware vijand of baas, vanaf 40: Arcane Power (**Q**) op vier stapels; Presence of Mind (**Shift-3**, vanaf 30) en dan Arcane Wrath voor een instant grote klap. GEMETEN in gids: CWF-A, MRR, PS.

Groep vijanden: Frost Nova (**V**), dan Arcane Explosion (**Shift-2**, vanaf 14). In een dungeon: naast de tank staan en Arcane Explosion. GEMETEN in gids: IV-A.
Mana op: Evocation (**F1**, vanaf 20). Vanaf 34 Mage Armor (blok D). GEMETEN in gids: CWF-A, IV-A.

**Hoeveel Arcane Blasts? Gidsen oneens** (GEMETEN in gids):
- MRR: nooit meer dan 2 ("the mana cost becomes too high").
- IV-A: 1 tot 3, tot Missile Barrage oplicht; laat de stapels daarna vallen.
- WFI: 2 of 3; Arcane Wrath op 3 of 4 stapels.
- CWF-A: 2 voor een gewone vijand, alle 4 op een elite of baas.
- WH-A: 1, dan meteen Arcane Missiles of Arcane Wrath (om mana te sparen).
Veilige zin voor beginners: "een of twee, op een baas tot vier". AFGELEID (grootste gemene deler).

**Clearcasting waarop? Gidsen oneens:** IV-A, WFI en CWF-A: op je duurste spell (een Arcane Blast met stapels, of Arcane Wrath). MRR: op Arcane Missiles. GEMETEN in gids. Advies: weglaten of de meerderheid volgen.

### Per 10 levels (alleen wat bij deze rol hoort)

| Level | Feit | Bron |
|---|---|---|
| 1-9 | Arcane Intellect (Shift-X) 1, Frostbolt (2) 4, Fire Blast (5) 6, Arcane Missiles (3) en Polymorph (Shift-Q) 8 | TD |
| **10** | Frost Nova (V). Eerste talentpunt. Rij 1: Improved Channeling (Arcane Missiles wordt niet meer korter door klappen), Wand Specialization, Arcane Resilience | TD r. 358; D |
| 14 | Arcane Explosion (Shift-2) | TD r. 363 |
| 15 | Talenten: Missile Barrage, Arcane Concentration, Arcane Subtlety, Magic Absorption | D |
| **20** | **Arcane Blast** (Ctrl-2, talent). Ook: Blink (R), Evocation (F1), Mana Shield (Z). Talenten rij 3: Arcane Impact, Arcane Geometry | D; TD r. 372-379 |
| 24 | Counterspell (E) | TD r. 391 |
| 25 | **Arcane Wrath** (Shift-F1, talent; eerst Arcane Blast nodig). Arcane Meditation (eerst Arcane Concentration nodig) | D |
| **30** | **Presence of Mind** (Shift-3, talent). Arcane Mind (talent). Sterkere Arcane Blast bij de trainer. Ice Armor (Shift-Z) | D; TD r. 406, 412 |
| 34 | Mage Armor (blok D) | TD r. 423 |
| 35 | Arcane Instability (talent) | D |
| 36 | Sterkere Arcane Wrath | TD r. 425 |
| **40** | **Arcane Power** (Q, talent; eerst Presence of Mind nodig). Frostfire Bolt (Ctrl-3; je wand verhuist). Sterkere Arcane Blast en Arcane Missiles | D; TD r. 436, 437, 442 |
| **50** | Niets nieuws. Sterkere Arcane Blast (50), Arcane Wrath en Arcane Missiles (48) | TD r. 467, 468, 475 |
| **60** | Niets nieuws. Sterkere Arcane Blast en Arcane Wrath (60), Arcane Missiles (56) | TD r. 498, 507, 508 |

CWF-A op 40: "Frostfire Bolt comes too, but Frostbolt is cheaper for fishing Missile Barrage." GEMETEN in gids.

### Beginnersfouten (kies er 2-4)

- **Arcane Blast blijven drukken.** Elke stapel maakt de volgende 100% duurder; je mana is zo op. GEMETEN: D `SpellEffect` r. 21387. GEMETEN in gids: IV-A ("you will go OOM quickly"), WT ("don't spam it mindlessly"), MRR.
- **Lopen tijdens Arcane Missiles.** Het is een channel; bewegen breekt het af. GEMETEN in gids: CWF-A ("moving cancels it"). Channel-vlag in DB2 niet apart nagelezen.
- **De gratis Arcane Missiles laten liggen.** Missile Barrage is voor je vólgende Arcane Missiles; gebruik hem meteen. GEMETEN in gids: CWF-A, MRR.
- **Arcane Power op een gewone vijand.** Hij maakt je spells ook 30% duurder en heeft 3 minuten cooldown. GEMETEN: D `SpellEffect` r. 3980, `SpellCooldowns` r. 777. GEMETEN in gids: CWF-A ("keep it for elites, bosses and the big pull").
- **Een vertraging in de Arcane-boom zoeken.** Die is er niet. Frost Nova (V) en Frostbolt (2) zijn je afstandhouders. GEMETEN (D, boom).
- **Arcane Explosion naast je schaap.** Elke damage breekt Polymorph. GEMETEN: D `Spell` r. 28; GEMETEN in gids: CWF-A.
- **Area-spells op drie of minder vijanden.** Kost je hele mana-balk. GEMETEN in gids: IV-A ("The biggest mistake Mage players make while leveling").

---

## 9. Rol **Fire** — `band = 2`

### Waar hij goed in is

| As | Wat de bronnen zeggen |
|---|---|
| Eén doel | **De meeste damage op één doel.** GEMETEN in gids: IV-V ("does the best single-target DPS out of the class's three specializations"), WFI ("Fire hits hardest"), WFA ("our level-60 simulation ranks it above Frost"). Sterkst op een vijand die lang leeft (elite, baas): Improved Scorch-stapels, Ignite, Fire Power (CWF-V, CWG). |
| Veel doelen | Flamestrike (16), Blast Wave (30), Arcane Explosion. **Gidsen oneens:** IV-V: "the strongest burst AoE in the game". MOB: "Fire: Weakest AoE of the 3, mana problems". GEMETEN in gids. Wel eens: het trekt snel threat; wacht op de tank (WFI, CWG). |
| Vertragen | Weinig. Blast Wave (30): 50% trager, 6 s. Impact: kans op 2 s stun. Frostfire Bolt (40): 40% trager. Geen bevriezing, geen Ice Block. GEMETEN: D (hoofdstuk 5). GEMETEN in gids: WFI ("Fire has no freezes of its own, so enemies reach you more often"), IV-V ("Weak defensives"). |
| Levelen | Snel, maar riskanter dan Frost. GEMETEN in gids: WFI ("Fast, riskier"), IV-V ("very enjoyable to level"), MOB ("harder for solo content"). |

### Vanaf wanneer

- Fireball vanaf level 1. Pyroblast op zijn vroegst 20. Het echte Fire-spel begint bij **Heating Up (25)**: daarvóór is Pyroblast alleen een opener. GEMETEN in gids: CWF-V ("before 25 use Pyroblast only as an opener"). Levels: D.

### Simple order (één vijand)

1. Open van ver met Pyroblast (**4**, vanaf 20). Daarvóór: Fireball (**1**). GEMETEN in gids: CWF-V, WFI, WFDB, PS, IV-V.
2. Fireball (**1**) als gewone spell. GEMETEN in gids: CWF-V, WFI, WFDB.
3. Fire Blast (**5**) elke keer dat hij klaar is. Vanaf 25 geeft elke Fire Blast een Heating Up-stapel. GEMETEN: D `Spell` r. 8782; gidsen CWF-V, IV-V.
4. Twee of drie Heating Up-stapels (vanaf 25)? Pyroblast (**4**). GEMETEN in gids: CWF-V ("cast it at two or three"), WFI en IV-V ("at three"), WFDB (drie; twee alleen als je tijd hebt voor 3 s).
5. Vijand vlakbij: Scorch (**Ctrl-1**, vanaf 22) in plaats van Fireball; of Frost Nova (**V**), stap weg. Vanaf 30 daarna Blast Wave (**F3**). GEMETEN in gids: WFI ("Scorch up close"), IV-V, CWF-V ("Frost Nova and then Blast Wave").
6. Bijna dood: wand (**Ctrl-3**, tot Frostfire Bolt) of Fire Blast. GEMETEN in gids: IV-V (wand onder 15% health).
7. Elite of baas, vanaf 40: Combustion (**Q**). GEMETEN in gids: CWF-V, PS.

Groep: Frost Nova (**V**), Flamestrike (**Shift-4**, vanaf 16), Blast Wave (**F3**, vanaf 30), Arcane Explosion (**Shift-2**) om af te maken. GEMETEN in gids: IV-V.
Vanaf 40: Frostfire Bolt (**Ctrl-3**) als iets vertraagd moet worden; Fireball slaat harder per cast (CWF-V: "use Frostfire Bolt when something needs a slow"; WFDB gebruikt hem vanaf 40 juist als vaste vuller). **Gidsen oneens.** GEMETEN in gids.

⚠️ IV-V speelt een mengvorm: eerst Arcane-talenten (Missile Barrage, Arcane Concentration, Arcane Blast) en zet Arcane Blast + Arcane Missiles in de Fire-volgorde. CWF-V, WFI en PS doen dat niet. Voor "Fire" als rol: de zuivere volgorde hierboven. AFGELEID (keuze).

### Per 10 levels

| Level | Feit | Bron |
|---|---|---|
| 1-9 | Fireball (1) 1, Fire Blast (5) 6, Polymorph (Shift-Q) 8 | TD |
| **10** | Frost Nova (V). Eerste talentpunt. Rij 1: Accelerant (Fireball cast korter; 5/5 = 0,5 s), Incineration (meer crit op Fire Blast en Scorch) | TD; D; 0,5 s: D `SpellEffect` r. 6720 (−500) en gids (WFI, CWF-V) |
| 15 | Talenten: Ignite, Impact, Flame Throwing | D |
| 16 | Flamestrike (Shift-4) | TD r. 368 |
| **20** | **Pyroblast** (4, talent): 6 s cast, dus alleen als opener. Ook: Blink (R), Evocation (F1), Fire Ward (F4), Mana Shield (Z). Talenten rij 3: Improved Fire Blast, Burning Soul, Improved Flamestrike | D; TD |
| 22 | Scorch (Ctrl-1) | TD r. 389 |
| 24 | Counterspell (E) | TD r. 391 |
| 25 | **Heating Up** (talent, passief; eerst Pyroblast nodig). Ook Improved Scorch, Master of Elements | D |
| 26 | Cone of Cold (Shift-F) | TD r. 396 |
| **30** | **Blast Wave** (F3, talent). Critical Mass (talent). Ice Armor (Shift-Z) | D; TD r. 412 |
| 34 | Mage Armor (blok D) | TD r. 423 |
| 35 | Fire Power (talent) | D |
| **40** | **Combustion** (Q, talent; eerst Critical Mass nodig). **Frostfire Bolt** (Ctrl-3, trainer; je wand verhuist) | D; TD r. 442 |
| **50** | Niets nieuws. Sterkere Frostfire Bolt (50), Fireball en Pyroblast (48), Blast Wave (52) | TD |
| **60** | Niets nieuws. Sterkere Fireball, Pyroblast, Blast Wave, Frostfire Bolt (60) | TD r. 509, 513, 514, 518 |

### Beginnersfouten (kies er 2-4)

- **Pyroblast casten terwijl de vijand al bij je is.** 6 s cast: te traag. Gebruik hem als opener, of met Heating Up-stapels. GEMETEN: D (6000 ms). GEMETEN in gids: CWF-V ("too slow once a mob is on you").
- **Denken dat drie stapels Heating Up een instant Pyroblast geven.** Het is 75% korter: 1,5 s. Je moet nog stilstaan. GEMETEN in gids: CWG ("not an instant Pyroblast"), WFDB. Rekensom AFGELEID uit D.
- **Area-spells op minder dan drie vijanden.** GEMETEN in gids: IV-V ("The biggest mistake new Fire Mages make").
- **Blast Wave en Cone of Cold vlak na elkaar.** Dan zijn beide vertragingen tegelijk op, en beide op cooldown. GEMETEN in gids: IV-V ("Don't overlap snares").
- **Een Ice Block zoeken.** Fire heeft er geen. Je redmiddelen: Frost Nova (V), Blink (R), Blast Wave (F3). GEMETEN (D, boom); gids CWF-V ("Fire has no Ice Block").
- **Area-damage vóór de tank de groep vast heeft.** Fire trekt snel threat. GEMETEN in gids: WFI, CWG.
- **Twee Flamestrikes willen leggen.** Er kan er maar één tegelijk liggen. GEMETEN: D `Spell` r. 506.
- **Flamestrike of Arcane Explosion naast je schaap.** Breekt Polymorph. GEMETEN: D `Spell` r. 28; gids CWF-V.

---

## 10. Rol **Frost** — `band = 3`

### Waar hij goed in is

| As | Wat de bronnen zeggen |
|---|---|
| Eén doel | Goed, maar met geluk: je wacht op een bevriezing of op Fingers of Frost, en dan slaat Ice Lance hard (300% meer op Frozen, plus Shatter). GEMETEN: D. GEMETEN in gids: IV-F ("need a little bit of luck"), WFI ("relies on lucky freezes and procs"). |
| Veel doelen | Het bekende groepen-pakken: Frost Nova, Blizzard, Cone of Cold. Kan nog, maar kleiner dan in Classic: Improved Blizzard vertraagt 40% voor 1,5 s (was 65%), en de sterke vertraging van Cone of Cold geldt voor de eerste 4 vijanden. GEMETEN: D (40%, 1,5 s). "Was 65%" en "eerste 4": GEMETEN in gids (CWF-F; WFI-tooltip van Cone of Cold). GEMETEN in gids: CWF-F ("Plan on a few mobs at a time"), WFA ("Blizzard was nerfed but still works"), IV-F ("some of the best AoE farming in the game"), IV-A ("AoE grinding is (mostly) a thing of the past"). **Toon verschilt per gids.** |
| Vertragen | **De beste.** Frostbolt 40% trager, Frostbite (kans op 5 s bevriezen), Frost Nova (8 s), Cone of Cold, Permafrost, Improved Blizzard. Plus de noodknoppen Ice Block, Cold Snap, Ice Barrier. GEMETEN: D (hoofdstuk 4 en 5). |
| Levelen | **De veiligste; eerste keus van de meeste gidsen.** GEMETEN in gids: WFI ("Level as Frost"), WFA, MOB ("beginner friendly"), PS ("the safest"), IV-F ("smooth, comfortable"). TF: 46,8% van de geplande level-builds. Kanttekening IV-F: Frost komt pas goed op gang rond 30 (Shatter + Fingers of Frost); je kunt ook als Arcane beginnen en rond 31 wisselen. |

### Vanaf wanneer

- Frostbolt op level 4, Frost Nova op 10. **Ice Lance op zijn vroegst 20.** Tot dan: Frostbolt en afmaken met de wand. GEMETEN: TD, D; gids WFI.

### Simple order (één vijand)

1. Frostbolt (**2**) van zo ver mogelijk, en blijf casten: elke treffer vertraagt. GEMETEN in gids: IV-F, WFI, CWF-F, WFA, MOB.
2. Is de vijand Frozen (door Frost Nova, of door het talent Frostbite)? Ice Lance (**F**, vanaf 20). GEMETEN in gids: alle. D: 300% meer op Frozen.
3. Komt hij bij je? Frost Nova (**V**), stap weg, Frostbolt en dan Ice Lance. GEMETEN in gids: IV-F, WFI, CWF-F, WFA.
4. Fingers of Frost (talent, vanaf 30) licht op: je volgende 2 spells doen alsof het doel Frozen is — Ice Lance. GEMETEN: D; gidsen IV-F, WFI, MOB.
5. Ice Lance nog niet klaar en de vijand is dichtbij: Cone of Cold (**Shift-F**, vanaf 26). GEMETEN in gids: WFI. Met Winter's Chill (vanaf 35): Cone of Cold op 5 stapels, ook op één vijand (IV-F, CWF-F).
6. Bijna dood: wand (**Ctrl-3**, tot Frostfire Bolt) of Fire Blast (**5**) als hij niet Frozen is. GEMETEN in gids: IV-F, WFI, WFA.

Groep (vanaf 20): Frost Nova (**V**), stap weg, Blizzard (**Shift-1**), daarna Cone of Cold (**Shift-F**); Arcane Explosion (**Shift-2**) als je niet stil kunt staan. GEMETEN in gids: WFA, IV-F, MOB.
Nood: Ice Block (**C**, vanaf 25); Cold Snap (**Shift-C**, vanaf 30) voor een tweede Frost Nova of Ice Block; Blink (**R**). GEMETEN in gids: CWF-F, WFA.
Vanaf 40: Ice Barrier (**X**) vóór elk gevecht en opnieuw als hij op is. GEMETEN in gids: CWF-F, MOB, WFI.

**Fingers of Frost: gidsen oneens over de volgorde** (GEMETEN in gids):
- IV-F en WFI: eerste lading op Frostbolt; bij de laatste lading Frostbolt casten en Ice Lance er vlak achter drukken, zodat beide tellen.
- MOB: je cast afbreken en meteen Ice Lance, zodat niet Frostbolt maar Ice Lance de lading pakt.
Voor beginners volstaat: "licht Fingers of Frost op, druk dan Ice Lance". AFGELEID (wat beide gemeen hebben).

### Per 10 levels

| Level | Feit | Bron |
|---|---|---|
| 1-9 | Frost Armor (Shift-Z) 1, Frostbolt (2) 4, Fire Blast (5) 6, Polymorph (Shift-Q) 8 | TD; HP r. 107 |
| **10** | Frost Nova (V). Eerste talentpunt. Rij 1: Improved Frostbolt (5/5 = 0,5 s korter), Precision, Frost Warding | TD r. 358; D; 0,5 s: gids (WFI, CWF-F) |
| 14 | Arcane Explosion (Shift-2) | TD r. 363 |
| 15 | Talenten: Frostbite, Ice Shards, Improved Frost Nova, Permafrost | D |
| **20** | **Ice Lance** (F, talent). Blizzard (Shift-1), Blink (R), Evocation (F1), Mana Shield (Z). Talenten rij 3: Improved Blizzard, Frost Channeling | D; TD r. 372-379 |
| 22 | Frost Ward (F2) | TD r. 388 |
| 24 | Counterspell (E) | TD r. 391 |
| 25 | **Ice Block** (C, talent). Ook Shatter, Arctic Reach | D |
| 26 | Cone of Cold (Shift-F) | TD r. 396 |
| **30** | **Cold Snap** (Shift-C, talent). Fingers of Frost (talent; eerst Ice Lance nodig), Improved Cone of Cold. Ice Armor: Shift-Z cast die voortaan | D; TD r. 412; HP r. 122 |
| 34 | Mage Armor (blok D) | TD r. 423 |
| 35 | Winter's Chill (talent) | D |
| **40** | **Ice Barrier** (X, talent; eerst Cold Snap nodig). Frostfire Bolt (Ctrl-3; je wand verhuist) | D; TD r. 442 |
| **50** | Niets nieuws. Sterkere Frostbolt, Cone of Cold, Ice Armor (50), Ice Barrier (46, 52), Blizzard (52) | TD |
| **60** | Niets nieuws. Sterkere Blizzard en Ice Armor (60), Frostbolt en Ice Lance (56), Cone of Cold en Ice Barrier (58) | TD |

CWF-F op 40: Improved Frostbolt en Winter's Chill werken alleen op Frostbolt, niet op Frostfire Bolt. GEMETEN in gids; klopt met de tekst in D `Spell` r. 3505 en 3531 (noemen alleen Frostbolt).

### Beginnersfouten (kies er 2-4)

- **Ice Lance op een vijand die niet Frozen is.** Dan is het een kleine klap. De grote (300% meer) is er alleen op Frozen, of met Fingers of Frost. GEMETEN: D `Spell` r. 18182, `SpellEffect` r. 41670.
- **Ice Lance willen blijven drukken.** 8 s cooldown, gedeeld met Fire Blast. Druk je net Fire Blast, dan is Ice Lance er niet bij de volgende bevriezing. GEMETEN: D (8 s); gedeeld = gids (CWF-F, WFI, WFA). WFI: "one big hit per freeze, not a spell to spam".
- **Je eigen bevriezing breken.** Damage kan Frost Nova breken. Cast eerst Frostbolt en druk Ice Lance er meteen achteraan. GEMETEN: D `Spell` r. 31; gids IV-F, WFI.
- **In Ice Block iets willen doen.** Je kunt niet casten, lopen of aanvallen. 5 minuten cooldown. GEMETEN: D `Spell` r. 3842, `SpellCooldowns` r. 934.
- **Cold Snap voor niets gebruiken.** 10 minuten cooldown: bewaar hem voor als het misgaat. GEMETEN: D `SpellCooldowns` r. 1395; gids CWF-F.
- **Blizzard of Cone of Cold over je schaap.** Breekt Polymorph. GEMETEN: D `Spell` r. 28; gids CWF-F.
- **Elke vijand met Blizzard openen.** Eén vijand is goedkoper met Frostbolt en de wand. GEMETEN in gids: WFA; IV-A (niet op 3 of minder).
- **Een volle Frostbolt op een bijna dode vijand.** Gebruik de wand of Fire Blast. GEMETEN in gids: IV-F, WFI.

---

## 11. Voor alle drie de rollen

Feiten die in elke rol passen (één keer noemen is genoeg, bv. in de eerste alinea of bij de fouten):

- **Polymorph (Shift-Q)** werkt alleen op Beasts, Humanoids en Critters; elke damage breekt het; één doel tegelijk. GEMETEN: D `Spell` r. 28.
- **Counterspell (E, 24)** is je interrupt. Cooldown 30 s. GEMETEN: D; staat al in HP r. 121.
- **Wand**: alle gidsen laten je zwakke vijanden met de wand afmaken, om mana te sparen (IV-F, IV-A, IV-V, WFI, WH-F, MRR). GEMETEN in gids. In MH: Ctrl-3 tot level 40.
- **Mana**: drinken tussen gevechten hoort erbij (WFI: "you'll stop to drink more than most classes"). Evocation (F1, 20), mana-edelstenen (blok D, 28/38/48/58), Mage Armor (blok D, 34). GEMETEN: TD; gidsen.
- **Dual Specialization op 40**: WFI, CWF en WFA zeggen het. GEMETEN in gids. Niet in DB2 of client gemeten — alleen noemen als je het wilt en dan als "the guides say".
- **Talent-levels zijn de vroegste**; met de perk Talented tot 5 levels eerder (hoofdstuk 3).

### Waar gidsen het oneens zijn, of achterlopen — samengevat

| Punt | Wie zegt wat | Wat klopt met DB2 70938 |
|---|---|---|
| Arcane Blast-getallen | CWG: +10% damage, 8 s, +175% mana. SYS (24 okt): 15% Int, +175%, 15 s. WFI, CWF-A, IV-A: 12% Int, +100%, 18 s, 4 stapels | **12%, +100%, 18 s** (D). CWG en SYS zijn oud (gewijzigd 2 nov volgens CWF) |
| Missile Barrage-rij | IV-A-tabel: level 25. SYS: "row 1". CWF-A en WFI: rij 2, level 15 | **Rij 2, level 15** (D: PosY 2730, 5 punten) |
| Piercing Ice, Arcane Focus, "Improved Fireball" | PS (build 70450) noemt ze nog | Weg / heet Accelerant (D, hoofdstuk 4) |
| Frost Blast, Wake of Fire | IV-A, MOB, WH-V noemen ze | Niet in boom of trainerlijst |
| Ice Barrier | MOB: "+3% damage" | **15% + 5%** (D) |
| Beste level-rol | WFI, WFA, MOB, PS: Frost. IV: alle drie kunnen. MRR: Arcane | Smaak; geen meting |
| Fire en groepen | IV-V: sterkste burst-AoE. MOB: zwakste AoE van de drie | Niet te meten |
| Arcane en mana | IV-O: beste mana-hulp. WT, WFA, PS: mana-hongerig | Beide kanten kloppen (hoofdstuk 8) |
| Aantal Arcane Blasts, Clearcasting, Fingers of Frost-volgorde, Frostfire Bolt bij Fire | zie hoofdstuk 8, 9, 10 | Smaak; geen meting |
| Teleport: Dalaran | WFI: level 40. CWF, WFA: level 50 | Niet in TD; niet gemeten. Geen rol-feit: weglaten |

---

## 12. Niet gemeten — eerlijk lijstje

1. **Niets is in de client getest.** Ook de toetsen niet opnieuw: ik heb `ForeverBlock_Mage.lua` gelezen, niet het blok in het spel gezien.
2. **Waarden per rang van talenten met meer rangen** (Shatter 50%, Frostbite 15%, Arcane Concentration 10%, Missile Barrage 40/20%, enz.): alleen uit gids-tooltips (WFI, CWF). De tabel `TraitDefinitionEffectPoints` zit niet in de cache en ik mocht de voordeur niet gebruiken.
3. **Maximum aantal stapels** van Arcane Blast (4) en het aantal crits van Combustion (3): alleen uit gidsen (drie gidsen eens). `SpellAuraOptions` zit niet in de cache.
4. **Dat Ice Lance en Fire Blast dezelfde cooldown delen**: uit gidsen (CWF citeert Blizzards notes van 2 nov) plus het gemeten feit dat beide 8 s categorie-cooldown hebben. De categorie zelf (`SpellCategories`) niet gemeten. Onbekend: of Improved Fire Blast dan ook Ice Lance versnelt.
5. **Of Arcane Missiles afbreekt bij bewegen**: uit gids (CWF-A); de channel-vlag in DB2 niet uitgelezen.
6. **Hoe je Arcane Brilliance leert** (item, maar welk).
7. **Dual Specialization op 40** en **Teleport: Dalaran**: alleen gidsen.
8. De groepen 12862-12865 in de boom bevatten alleen node 113627 (Arcane Wrath) en hebben geen voorwaarde; waarvoor ze dienen weet ik niet. Raakt de tekst niet.
9. `docs/forever/DRUID_ROLES_2026-11-16.md` niet gelezen (agentregel).

Voor Rob om na te meten in het spel, als hij wil (elk een halve minuut):
- Staat Ice Lance op cooldown direct na een Fire Blast? (punt 4)
- Hoeveel stapels Arcane Blast toont de buff maximaal? (punt 3)
- Wat zegt de tooltip van Shatter en Frostbite op de hoogste rang? (punt 2)

---

## 13. Voor mh-writer — vorm

- Vorm: `MAGE = { { band = 1, title = "...", body = [[...]] }, { band = 2, ... }, { band = 3, ... } }`, in `ROLES` naast `DRUID` (HP r. 373-453). Markering `**woord**` wordt goud (HP r. 459-462).
- Body zoals bij de druid: eerst één alinea ("From level …", wat de gidsen over levelen zeggen, één uitgelegd spelwoord), dan `**Simple order:**` (genummerd, toets vet, "from N" erbij), `**Per 10 levels:**` (regels 10, 20, 30, 40, 50, 60; tussenlevels met "Then …" of "Before that: …"), `**Beginner mistakes:**` (de druid heeft er 2 per rol).
- Spelwoorden die uitleg nodig hebben (Rob: leg elk spelwoord uit): **Frozen** (bevroren: de vijand kan niet lopen), **crit**, **cast** / **instant**, **channel** (je moet stil blijven staan terwijl de spell loopt), **proc** liever vermijden ("lights up"), **threat**, **AoE** liever "several enemies". "Instant" en "CC" zijn al uitgelegd in CLASSES.MAGE (HP r. 111, 113).
- De regel uit de druid-tekst past letterlijk: "Talent levels here are the earliest; a perk can bring them up to 5 levels sooner." (HP r. 387).
- Schrijf geen rangnummers ("Rank 2"); zeg "stronger ranks" zoals bij de druid.
- Noem niet: Frost Blast, Wake of Fire, Piercing Ice, Arcane Focus, Improved Fireball (heet Accelerant).
- Waar gidsen het oneens zijn (hoofdstuk 11): kies de voorzichtige zin of zeg "the guides differ", zoals de druid-tekst doet bij Moonkin Form ("40 is not a rule", HP r. 415).
