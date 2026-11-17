# Hunter per rol — feiten voor "How you play" (WoW Forever, build 1.60.1.70938)

Onderzoek: mh-research, 17 nov 2026. Voor mh-writer: teksten in de vorm van `ROLES.DRUID`
(`Modules/ForeverHowToPlay.lua` r. 373-453). Niets hiervan is in de client getest.

Elke bewering heeft een label:
- **GEMETEN [bron]** = gezien in die bron (code hieronder), vandaag.
- **AFGELEID** = beredeneerd; de reden staat erbij.
- Een gids-bewering is "GEMETEN in de gids" (de gids zegt het), niet "waar in het spel".

Spelnamen en toetsen staan in het Engels, precies zoals in de addon.

---

## 0. Kort

1. **Banden:** Beast Mastery = band 1, Marksmanship = band 2, Survival = band 3. GEMETEN op drie manieren (hoofdstuk 2).
2. **Alle drie zijn damage.** BM = pet doet het meeste, makkelijkst en snelst met levelen. MM = eigen schoten van ver,
   in gidsen de keuze voor groepen. Survival = **dichtbij vechten** plus traps, in gidsen de traagste om te levelen.
3. **Talent-toetsen per boom:** BM: Summon Hawk (**Shift-F1**, 25), Intimidation (**Shift-3**, 30), Bestial Wrath (**F1**, 40).
   MM: Trueshot Aura (**Shift-X**, 25), Scatter Shot (**E**, 30), Sniper Shot (**Shift-4**, 40).
   Survival: Deterrence (**C**, 20), Counterattack (**Shift-V**, 25 of 30: zie 9.10), Strider Kick (**blok D**, 30).
4. **Aimed Shot is in Forever geen talent**: elke Hunter leert hem op 20 bij de trainer (toets **4**).
5. 🔴 **Voor Survival staan twee kernknoppen op blok D** (Strider Kick, Aspect of the Beast). Geen vaste toets. Zie hoofdstuk 11.
6. 🔴 **Revive Pet en Feed Pet komen uit de tweede pet-quest** (Training the Beast), niet uit de tem-quests. Zie 5.1 en 11.

---

## 1. Bronnen (codes)

Lokaal, gelezen 17 nov 2026:
- **[K]** `Modules/ForeverBlock_Hunter.lua` r. 19-74 — MH's vaste toetsen.
- **[C]** `Modules/ForeverHowToPlay.lua` r. 128-156 — `CLASSES.HUNTER`, de bestaande klassetekst.
- **[M]** `Modules/ForeverMacros.lua` — r. 221-231 (class-macro's), r. 384-447 (`SPEC_MACROS`), r. 608-616 (`SPEC_NAMES`),
  r. 673-677 (boom 1091 en de PosX-banden), r. 739-752 (Talented).
- **[TD]** `Modules/ForeverTrainerData.lua` r. 219-344 — trainer-spells met level (bron daar: What's Training, Camelot-data).
- **[CQ]** `Modules/ForeverClassQuests.lua` r. 599-663 — de pet-quests.
- **[DIR]** `Modules/ForeverDirection.lua` r. 169-173 en `Locales/enUS.lua` r. 5062-5063, 5081-5083.
- **[DB2 Tabel]** lokale cache `C:\Users\RobHu\AppData\Local\MidnightHelper\gamedata_cache\db2\1.60.1.70938\<Tabel>.enUS.csv`.
- **[SR]** `https://wago.tools/db2/SpellRange/csv?build=1.60.1.70938` (stond niet in de cache; opgehaald via Exa, 17 nov 2026).

Gidsen (allemaal van na 18 aug 2026; gelezen via Exa, niet via de browser):
- **[IV-BM]** Icy Veins, BM leveling — `https://www.icy-veins.com/wow-forever/beast-mastery-hunter-leveling` (gepubliceerd 17 okt 2026; update-datum niet gezien).
- **[IV-MM]** Icy Veins, MM leveling — `https://www.icy-veins.com/wow-forever/marksmanship-hunter-leveling` (bijgewerkt 4 nov 2026).
- **[IV-SV]** Icy Veins, Survival leveling — `https://www.icy-veins.com/wow-forever/survival-hunter-leveling` (bijgewerkt 4 nov 2026).
- **[IV-OV]** Icy Veins, class overview — `https://www.icy-veins.com/wow-forever/hunter-class-overview` (27 okt / 3 nov 2026).
- **[WH]** Wowhead — `https://www.wowhead.com/forever/guide/classes/hunter/leveling-guide` (bijgewerkt 12 nov 2026).
- **[CWF]** classicwowforever — `https://classicwowforever.com/talents/hunter/` (bijgewerkt 11 nov 2026; client 1.60.1.70862).
- **[PS]** Polestar — `https://polestar.guide/guides/class/hunter` (geen datum; "checked on game build 1.60.1.70450").
- **[WM-BM] [WM-MM] [WM-SV]** warcraftmaps — `https://warcraftmaps.com/classes/hunter/<beast-mastery|marksmanship|survival>/rotation` (gecontroleerd 16 nov 2026; build 1.60.1.70685).
- **[FDB]** WoW Forever DB — `https://wowfdb.com/classes/hunter/...` (`abilities/`, `beast-mastery/leveling/`, `survival/leveling/`, `survival/rotation/`, `marksmanship/rotation/`, `survival/talents/`; build 1.60.1.70938; geen datum).
- **[WFI]** `https://wowforeverinfo.com/guides/hunter-leveling/` (bijgewerkt 9 nov 2026).
- **[FG]** `https://foreverguide.app/guides/leveling/hunter` (geen datum).
- **[SF]** `https://speedingfines.gg/guides/classes/hunter/` (geen datum; noemt de hotfix van 3 nov).
- **[HP]** `https://hearthproof.com/classes/hunter/leveling/` (14 nov 2026; client 1.60.1.70888).
- **[SYS]** `https://systematic.gg/forums/hunter/t/marksmanship-hunter-leveling-in-wow-forever-talent-order-10-60-rapid-killing-sniper-shot-dungeons` (24 okt 2026, vóór de launch).
- **[FW]** `http://foreverwow.com/class-guides/hunter/marksmanship/` (bijgewerkt 7 nov; build 70862).
- **[TS]** `https://timesaver.gg/tools/wow-forever/talent-calculator/hunter` (gecontroleerd 13 nov 2026).
- **[WCFI]** `https://wowclassicforever.info/classes/hunter/` (geen datum).

---

## 2. Welke boom is welke band

| Band | Boom | Bewijs |
|---|---|---|
| 1 | Beast Mastery | GEMETEN [DB2 TalentTab] ID 361, OrderIndex 0, ClassMask 4 |
| 2 | Marksmanship | GEMETEN [DB2 TalentTab] ID 363, OrderIndex 1 |
| 3 | Survival | GEMETEN [DB2 TalentTab] ID 362, OrderIndex 2 |

- Hunter-boom = TraitTree **1091**. GEMETEN [DB2 TraitTree] (rij 1091) en [M] r. 676.
- Tweede bewijs: in [DB2 TraitNode] (`TraitTreeID=1091`, 52 rijen) staan de knopen in drie PosX-groepen: 1020-2820,
  5020-6820, 9080-10880. Via TraitNodeXTraitNodeEntry → TraitNodeEntry → TraitDefinition → SpellName zit Bestial Wrath
  in groep 1, Sniper Shot in groep 2, Lacerating Strikes in groep 3. GEMETEN. Dat zijn dezelfde grenzen als [M] r. 673-675.
- Derde bewijs: `SPEC_NAMES.HUNTER.enUS = { "Beast Mastery", "Marksmanship", "Survival" }`. GEMETEN [M] r. 609.
- Controle met de Druid: Balance OrderIndex 0 = band 1, Feral 1 = band 2, Restoration 2 = band 3, precies zoals in
  `ROLES.DRUID`. GEMETEN [DB2 TalentTab] + `ForeverHowToPlay.lua` r. 376-433.

---

## 3. De talentboom (Forever, niet classic)

### 3.1 Hoe de levels zijn berekend

- Je krijgt 1 talentpunt op level 10, 11, 12 … (één per level). GEMETEN [DB2 TraitCurrencySource] rijen 36242 e.v.
  ("Level 10", "Level 11", … munt 3820).
- Elke rij van een boom vraagt 5 punten meer in die boom: 0, 5, 10, 15, 20, 25, 30. GEMETEN [DB2 TraitCond] 42813-42818
  (BM), 42821-42826 (MM), 42833-42838 (Survival), kolom SpentAmountRequired; gekoppeld via TraitNodeGroupXTraitCond en
  TraitNodeGroupXTraitNode.
- **Vroegste level = 10 + punten nodig.** AFGELEID (rekensom uit de twee regels hierboven; het klopt alleen als al je
  punten in die ene boom gaan). Niet in de client getest.
- Legacy-perk **Talented**: rang 1-5 geeft een punt op level 9, 8, 7, 6, 5. GEMETEN [DB2 TraitCurrencySource] 37163-37167.
  Dus tot 5 levels eerder. AFGELEID: of een talent-spell met een eigen spell-level (Summon Hawk 25, enz.) dan ook
  echt eerder werkt, is nergens gemeten ([SF] zegt letterlijk "untested").

### 3.2 De boom per band

Alles hieronder GEMETEN [DB2 TraitNode + TraitNodeGroupXTraitNode + TraitCond + TraitNodeEntry (MaxRanks) + TraitDefinition
+ SpellName]. Het level is AFGELEID (3.1). Vet = een knop die je indrukt.

**Band 1 — Beast Mastery (16 talenten)**

| Rij | Punten | Level | Talenten (max. rangen) |
|---|---|---|---|
| 1 | 0 | 10 | Deadly Aspects (5), Endurance Training (5) |
| 2 | 5 | 15 | Focused Fire (2), Improved Aspect of the Monkey (3), Improved Revive Pet (2) |
| 3 | 10 | 20 | Pathfinding (2), Bestial Swiftness (1), Unleashed Fury (5) |
| 4 | 15 | 25 | Improved Mend Pet (2), Ferocity (5), **Summon Hawk** (1) |
| 5 | 20 | 30 | Spirit Bond (2), **Intimidation** (1), Bestial Discipline (2) |
| 6 | 25 | 35 | Frenzy (5) |
| 7 | 30 | 40 | **Bestial Wrath** (1) |

**Band 2 — Marksmanship (16 talenten)**

| Rij | Punten | Level | Talenten (max. rangen) |
|---|---|---|---|
| 1 | 0 | 10 | Hawk Eye (3), Improved Concussive Shot (5), Lethal Attacks (5) |
| 2 | 5 | 15 | Improved Stings (3), Efficiency (5), Careful Aim (5) |
| 3 | 10 | 20 | Rapid Killing (2), Improved Arcane Shot (5), Lone Wolf (1) |
| 4 | 15 | 25 | **Trueshot Aura** (1), Mortal Shots (5) |
| 5 | 20 | 30 | Rapid Recuperation (2), Barrage (3), **Scatter Shot** (1) |
| 6 | 25 | 35 | Ranged Weapon Specialization (5) |
| 7 | 30 | 40 | **Sniper Shot** (1) |

**Band 3 — Survival (18 talenten)**

| Rij | Punten | Level | Talenten (max. rangen) |
|---|---|---|---|
| 1 | 0 | 10 | Improved Tracking (5), Deflection (5) |
| 2 | 5 | 15 | Entrapment (5), Savage Strikes (2), Survivalist (5), Improved Wing Clip (3) |
| 3 | 10 | 20 | Clever Traps (2), Surefooted (3), **Deterrence** (1) |
| 4 | 15 | 25 | Survival Tactics (2), Predator's Edge (5), **Counterattack** (1) — ⚠️ zie 9.10 |
| 5 | 20 | 30 | Resourcefulness (2), Expose Prey (2), Survivalist's Discipline (2), **Strider Kick** (1) |
| 6 | 25 | 35 | Lightning Reflexes (5) |
| 7 | 30 | 40 | Lacerating Strikes (1, passief) |

Voorwaarden (pijlen in de boom), GEMETEN [DB2 TraitEdge]: Bestial Swiftness → Intimidation → Bestial Wrath;
Ferocity → Frenzy; Careful Aim → Mortal Shots; Rapid Killing → Rapid Recuperation; Trueshot Aura → Sniper Shot;
Deterrence → Counterattack; Expose Prey → Lacerating Strikes. "Op volle rang" zegt [CWF]; de pijl zelf is gemeten.

Spell-levels van de talent-knoppen, GEMETEN [DB2 SpellLevels]: Deterrence 20, Summon Hawk 25, Trueshot Aura 25,
Intimidation 30, Scatter Shot 30, Strider Kick 30, **Counterattack 30**, Bestial Wrath 40, Sniper Shot 40.

`SPEC_MACROS` ([M] r. 427-447) zegt: Summon Hawk 25, Intimidation 30, Bestial Wrath 40, Scatter Shot 30, Sniper Shot 40,
Strider Kick 30, Deterrence 20, Counterattack 30. Alles gelijk aan de boom, **behalve Counterattack** (boom: rij 4 = 25).
De regel `aimedmulti` (level 20, `talent = false`) is geen talent: dat is het trainer-level van Aimed Shot.

### 3.3 Niet noemen (staat niet meer in de boom)

GEMETEN [DB2]: de 50 talenten hierboven zijn alle zichtbare knopen van boom 1091. Positieve controle: dezelfde
zoekopdracht vond wél Bestial Wrath, Sniper Shot en Lacerating Strikes. Deze classic-namen zitten er **niet** in:
- Aimed Shot als talent (is nu een trainer-spell op 20, GEMETEN [TD] r. 245).
- Trueshot Aura als 31-punts-talent (staat nu in rij 4).
- Wyvern Sting, Improved Hunter's Mark, Improved Aspect of the Hawk, Thick Hide, Improved Eyes of the Beast,
  Humanoid Slaying, Monster Slaying, Killer Instinct, Improved Feign Death, Trap Mastery. [FDB abilities] noemt er acht
  van als "Removed in Forever" (GEMETEN in de gids).
- **Improved Serpent Sting**: de knoop (105003) bestaat nog, maar staat op PosY 39300 (ver buiten beeld) en zit niet in
  de groepen waarin punten tellen. GEMETEN [DB2 TraitNode, TraitNodeGroupXTraitNode]. AFGELEID: geparkeerd, niet te kiezen.
  [TS] telt 50 talenten (klopt met "niet te kiezen"); [CWF] (oudere build 70862) telt 51 en noemt hem nog. → niet noemen.
  De nieuwe naam is **Improved Stings** (rij 2).
- Een tweede geparkeerde knoop: de oude Lightning Reflexes (104982, PosX 102800). De nieuwe (110859) staat in rij 6.

---

## 4. MH's vaste toetsen (overnemen, niets verzinnen)

Alles GEMETEN [K] r. 21-58.

| Toets | Spell | Toets | Spell |
|---|---|---|---|
| **1** | Auto Shot | **Shift-1** | Multi-Shot |
| **2** | Serpent Sting | **Shift-2** | Explosive Trap, anders Immolation Trap |
| **3** | Arcane Shot | **Shift-3** | Intimidation |
| **4** | Aimed Shot | **Shift-4** | Sniper Shot |
| **5** | Raptor Strike | **Q** | Rapid Fire |
| **F1** | Bestial Wrath | **Shift-F1** | Summon Hawk |
| **F2** | Mend Pet | **F3** | Revive Pet |
| **F4** | Call Pet | **E** | Scatter Shot |
| **R** | Aspect of the Cheetah | **Shift-R** | Aspect of the Hawk |
| **F** | Distracting Shot | **Shift-F** | Wing Clip |
| **Z** | Disengage | **Shift-Z** | Hunter's Mark |
| **X** | Feign Death | **Shift-X** | Trueshot Aura |
| **C** | Deterrence | **Shift-C** | Mongoose Bite |
| **V** | Freezing Trap | **Shift-V** | Counterattack |
| **Shift-Q** | Concussive Shot | **Shift-E** | race-spell |
| **Ctrl-1** | pet: attack | **Ctrl-2 / Ctrl-3** | pet: follow / stay |

- **Blok D** (je eigen Alt-toetsen), GEMETEN [K] r. 61-67: Aspect of the Monkey, **Aspect of the Beast**, **Strider Kick**,
  Volley, Frost Trap, Viper Sting, Scorpid Sting, Aspect of the Pack, Aspect of the Wild, Tranquilizing Shot, Flare.
- **Zelf plaatsen** (`listed`), GEMETEN [K] r. 68-73: Feed Pet, Dismiss Pet, Scare Beast, Tame Beast, Beast Training,
  Beast Lore, Eyes of the Beast, Eagle Eye, Immolation Trap, alle Track-spells.
- AFGELEID uit [K] r. 28 + r. 70 + [C] r. 150: vanaf 34 is **Shift-2** Explosive Trap; Immolation Trap heeft dan geen
  toets meer.
- MH-macro's die bij de rollen passen (venster Macro's, geen vaste toets), GEMETEN [M]: "Melee Weave" (Mongoose Bite +
  Raptor Strike, r. 224), "Pet Care" (Revive/Call/Mend in één knop, r. 230), "Mark + Pet" (r. 228), en per boom
  Intimidation, BestialWrath, Summon Hawk / Scatter Shot, Aimed+Multi, Sniper Shot / Strider Kick, Counter Atk,
  Deterrence (r. 428-447).

---

## 5. Voor alle drie de rollen gelijk

### 5.1 Pet (temmen, voeren, terughalen)

- Level 10: drie quests **Taming the Beast** bij je Hunter-trainer; je temt telkens een dier met de Taming Rod.
  GEMETEN [CQ] r. 650-658; [PS] noemt dezelfde quests.
- Die keten leert je **Tame Beast, Call Pet en Dismiss Pet**. GEMETEN [DB2 SpellEffect]: leer-spell 1579 leert 1515,
  883, 2641. Dat de derde tem-quest die spell geeft: GEMETEN in [CQ] r. 602-604 (daar: Wowhead "You will learn").
- Daarna de quest **Training the Beast** (opent na de derde tem-quest, GEMETEN [CQ] r. 659): die leert **Beast Training,
  Feed Pet en Revive Pet**. GEMETEN [DB2 SpellEffect]: leer-spell 5300 leert 5149, 6991, 982.
- Alle zes hebben spell-level 10. GEMETEN [DB2 SpellLevels].
- Tame Beast: "Once tamed, the beast will be very unhappy and disloyal. Try feeding the pet immediately." GEMETEN
  [DB2 Spell 1515]. Dus: happiness en loyalty bestaan in Forever. [IV-MM] zegt hetzelfde ("remember to feed your pet").
- Temmen duurt 20 seconden, je armor is dan 100% lager, en een dier boven je eigen level kan niet. GEMETEN in [FDB abilities]
  (de getallen niet zelf in DB2 nagemeten).
- Feed Pet: voer van ongeveer het level van je pet werkt het best. GEMETEN [DB2 Spell 6991]. In je tassen licht op wat
  je pet eet. GEMETEN in [WH].
- Niet voeren: "it may just decide to leave"; een blije pet doet meer schade. GEMETEN in [WH]. "An unhappy pet does 25%
  less damage (Classic rule)". GEMETEN in [FDB survival/leveling]; het getal is daar zelf als classic-regel gemerkt.
- Dismiss Pet maakt je pet minder blij. GEMETEN [DB2 Spell 2641].
- **Revive Pet** (**F3**): pet komt terug met 15% health; kost al je basis-mana. GEMETEN [DB2 SpellEffect 982, SpellPower 982].
  Cast 10 seconden: GEMETEN in [FDB abilities].
- **Mend Pet** (**F2**, level 12): je kanaliseert 5 seconden, tot 20 yards van je pet. GEMETEN [TD] r. 233,
  [DB2 SpellMisc 136 + SpellDuration 28 + SR 3]. AFGELEID: tijdens het kanaliseren schiet je niet ([WM-BM] zegt dat ook).
- Pet-toetsen **Ctrl-1 / Ctrl-2 / Ctrl-3**, **F4** = Call Pet. GEMETEN [K] r. 52-56.
- Pet-spells (Growl, Bite, Claw) geef je je pet met Beast Training. Hogere rangen leer je door een dier te temmen dat
  ze al kent (GEMETEN in [IV-SV], [IV-MM]); pet-trainers verkopen ook spells, betaald met Training Points (GEMETEN in [WH]).

### 5.2 Spells per level (trainer)

Alles GEMETEN [TD] r. 219-344, tenzij anders gezegd.
- 1: Auto Shot, Raptor Strike (start-spells; GEMETEN [DB2 SpellLevels 75 en 2973]). 4: Serpent Sting, Aspect of the Monkey.
- 6: Arcane Shot, Hunter's Mark. 8: Concussive Shot. 10: Aspect of the Hawk.
- 12: Mend Pet, Distracting Shot, Wing Clip. 14: Scare Beast, Eagle Eye, Eyes of the Beast.
- 16: Immolation Trap, Mongoose Bite. 18: Multi-Shot.
- 20: **Aimed Shot**, Aspect of the Cheetah, Disengage, Freezing Trap, Dual Wield (passief).
- 22: Scorpid Sting. 24: Beast Lore. 26: Rapid Fire. 28: Frost Trap.
- 30: Feign Death, **Aspect of the Beast**. 32: Flare. 34: Explosive Trap. 36: Viper Sting.
- 40: Volley, Aspect of the Pack, Mail. 46: Aspect of the Wild.
- 60: Tranquilizing Shot heeft spell-level 60 (GEMETEN [DB2 SpellLevels 19801]); staat niet in [TD]; hoe je hem krijgt: niet gemeten.

### 5.3 Getallen die in de teksten kunnen (allemaal GEMETEN in DB2 1.60.1.70938)

- **Dode zone:** Auto Shot, Aimed Shot en Multi-Shot werken van 8 tot 35 yards. [DB2 SpellMisc RangeIndex 114] + [SR 114].
  Sniper Shot 8-45 yards [SR 582]. **Summon Hawk 0-35 en Scatter Shot 0-15: die werken wél dichtbij** [SR 571, SR 11].
- Aimed Shot: cast 2 seconden, cooldown 6 seconden, "shares its cooldown with Multi-Shot". [SpellMisc 19434 + SpellCastTimes 5,
  SpellCooldowns 19434, Spell 19434].
- Multi-Shot: cooldown 6 seconden. Arcane Shot: 6 seconden. [SpellCooldowns 2643, 3044].
- Summon Hawk: "shares its cooldown with Arcane Shot", 6 seconden; een hawk blijft 18 seconden; hoogstens 2 tegelijk.
  [Spell 1293241, SpellCooldowns, SpellEffect index 2 = 2, SpellMisc 1293248 + SpellDuration 85].
- Intimidation: je pet stunt 3 seconden bij zijn volgende treffer; cooldown 1 minuut. [Spell 19577, SpellMisc 24394, SpellCooldowns].
- Bestial Wrath: pet doet 50% meer schade, 18 seconden; cooldown 2 minuten. [SpellEffect 19574, SpellMisc, SpellCooldowns].
- Rapid Fire: 40% sneller schieten **en** slaan, 15 seconden; cooldown 5 minuten. [Spell 3045, SpellEffect, SpellDuration 8, SpellCooldowns].
- Trueshot Aura: 30 minuten; meer Ranged Attack Power voor "party or raid members". [Spell 1299346, SpellMisc + SpellDuration 30].
- Scatter Shot: 50% wapenschade, vijand 4 seconden in de war, elke schade breekt het, "turns off your attack";
  cooldown 30 seconden. [Spell 19503, SpellEffect, SpellDuration 35, SpellCooldowns].
- Sniper Shot: cast 4 seconden, cooldown 15 seconden, je volgende 3 schoten 10 yards verder, 10 seconden lang.
  [SpellMisc 1310687 + SpellCastTimes 15, SpellCooldowns, SpellAuraOptions ProcCharges 3, SpellEffect, SpellDuration 1].
- Lone Wolf: 20% meer schade "while you do not have an active pet". [Spell 415370, SpellEffect].
- Deterrence: 25% meer dodge en parry, 10 seconden; cooldown 5 minuten. [SpellEffect 19263, SpellDuration 1, SpellCooldowns].
- Counterattack: "becomes active after parrying"; zet de vijand 5 seconden vast; cooldown 5 seconden. [Spell 19306, SpellDuration 28, SpellCooldowns].
- Mongoose Bite: "Can only be performed after you dodge"; cooldown 5 seconden. [Spell 1495, SpellCooldowns].
- Raptor Strike: cooldown 6 seconden. [SpellCooldowns 2973].
- Strider Kick: 100% melee-wapenschade, daarna 30% sneller lopen voor 3 seconden; cooldown 8 seconden. [Spell 1317257, SpellEffect, SpellDuration 27, SpellCooldowns].
- Expose Prey: aanvallen op een vijand met **Hunter's Mark** geven een kans dat Mongoose Bite mag. [Spell 1310532].
- Lacerating Strikes: Mongoose Bite geeft ook een bleed (40% van zijn schade). [Spell 1310533, SpellEffect].
- Aspect of the Beast: untrackable **en** meer Melee Attack Power (rang 1: 50). [Spell 13161, SpellEffect]. Level 30.
- Deadly Aspects: werkt alleen met Aspect of the Hawk aan (Auto Shot, sneller schieten) of Aspect of the Beast aan
  (melee, sneller slaan). [Spell 19552].
- Disengage: "Attempts to disengage from the target by reducing threat. Disables auto-attack." Melee-bereik, cooldown
  5 seconden. [Spell 781, SpellMisc RangeIndex 2, SpellCooldowns]. Het is dus **geen sprong naar achteren**.
- Feign Death: cooldown 30 seconden; "after 6 min you will actually die". [Spell 5384, SpellDuration 41, SpellCooldowns].
- Concussive Shot: 50% trager, 4 seconden; cooldown 12 seconden. [SpellEffect 5116, SpellDuration 35, SpellCooldowns].
- Volley: 6 seconden kanaliseren, geen cooldown. [SpellMisc 1510 + SpellDuration 32, SpellCooldowns].
- Traps: Immolation, Explosive, Freezing en Frost hebben elk 30 seconden cooldown. [SpellCooldowns]. Dat het één
  gedeelde cooldown is: GEMETEN in [CWF] ("since 2 November every trap shares one 30-second cooldown") en [C] r. 151;
  niet in DB2 nagemeten (tabel met categorieën ontbreekt in de cache).
- Getallen voor talenten met meer rangen (Careful Aim, Unleashed Fury, enz.) staan in [CWF]; niet zelf per rang nagemeten.

---

## 6. Rol 1 — Beast Mastery

- **band = 1** (GEMETEN, hoofdstuk 2)
- **Voorgestelde title:** `Beast Mastery: damage with your pet`

### Intro-feiten
- Damage. Je pet doet het meeste werk: hij houdt de vijand bezig en jij schiet van afstand. GEMETEN in [IV-BM], [IV-OV],
  [WFI], [PS], [FDB beast-mastery/leveling]; past bij [DIR] `FDIR_HUNTER_1`.
- Voor levelen: in alle gelezen gidsen de eerste keus ("easiest", "fastest and safest"). GEMETEN in [IV-BM], [IV-MM]
  ("quite a bit worse still than leveling as Beast Mastery"), [WH] ("generally thought of as the easiest"), [WFI], [PS],
  [FDB], [HP]. Geen gids zegt iets anders (zie 9.1 voor de nuance).
- Vanaf level 10 (je pet). Nieuw in Forever: **Summon Hawk** (25): extra vogels op je doel. GEMETEN [DB2] + [IV-OV].
- Zwak punt: groepen vijanden; je pet kan er maar één vasthouden. GEMETEN in [WFI], [IV-BM].

### Simple order (met toetsen)
Vooraf: Aspect of the Hawk aan (**Shift-R**). Deadly Aspects werkt alleen dan. GEMETEN [K], [DB2 Spell 19552].
1. Hunter's Mark (**Shift-Z**). GEMETEN in [IV-BM], [WM-BM].
2. Pet erop (**Ctrl-1**) en even wachten tot hij de vijand heeft. GEMETEN in [IV-BM] ("a couple of attacks"), [WM-BM].
3. Serpent Sting (**2**). GEMETEN in [IV-BM], [WM-BM] ([WM-BM]: alleen als de vijand langer dan 15 seconden leeft).
4. Summon Hawk (**Shift-F1**, vanaf 25): zorg dat er steeds 2 hawks zijn. GEMETEN in [IV-BM], [IV-OV], [WM-BM].
5. Aimed Shot (**4**, vanaf 20) als je stilstaat. GEMETEN in [IV-BM] ("on cooldown"), [WM-BM]. Twee of meer vijanden:
   Multi-Shot (**Shift-1**) in plaats van Aimed Shot (zelfde cooldown). GEMETEN in [IV-BM] + [DB2].
6. Auto Shot (**1**) loopt de hele tijd door. Arcane Shot (**3**): vóór 25 gewoon gebruiken; vanaf 25 alleen als er al
   2 hawks zijn (zelfde cooldown als Summon Hawk). GEMETEN in [IV-BM], [WM-BM] + [DB2 Spell 1293241].
7. Pet bijna dood: Mend Pet (**F2**). Vijand op jou: Intimidation (**Shift-3**, vanaf 30) of Disengage (**Z**, vanaf 20);
   echt mis: Feign Death (**X**, vanaf 30). GEMETEN in [IV-BM], [WM-BM].
8. Zware vijand: Bestial Wrath (**F1**, vanaf 40) samen met Rapid Fire (**Q**, vanaf 26). GEMETEN in [IV-BM], [WM-BM].

### Per 10 levels
- **10:** pet (Taming the Beast, daarna Training the Beast; 5.1). Call Pet (**F4**), Revive Pet (**F3**), pet-toetsen
  (**Ctrl-1/2/3**), Aspect of the Hawk (**Shift-R**). Eerste talentpunt; rij 1 = Deadly Aspects, Endurance Training.
  Daarna: Mend Pet (**F2**) op 12, Multi-Shot (**Shift-1**) op 18. GEMETEN [TD], [K], [DB2]; level AFGELEID (3.1).
- **20:** Aimed Shot (**4**), Aspect of the Cheetah (**R**), Disengage (**Z**), Freezing Trap (**V**). Talent-rij 3:
  Bestial Swiftness (pet loopt 30% sneller; nodig voor Intimidation), Unleashed Fury, Pathfinding. GEMETEN [TD], [K],
  [DB2 TraitEdge, SpellEffect 19596].
- **30:** Intimidation (**Shift-3**, talent). Feign Death (**X**). Daarvóór: Summon Hawk (**Shift-F1**, talent) op 25,
  Rapid Fire (**Q**) op 26. GEMETEN [DB2], [TD], [K]; talent-level AFGELEID.
- **40:** Bestial Wrath (**F1**, talent; alle 30 punten ervoor moeten in Beast Mastery zitten). Daarvóór: Frenzy
  (talent, passief) vanaf 35, Explosive Trap op **Shift-2** vanaf 34. Volley (blok D). GEMETEN [DB2 TraitCond 42813], [TD], [K].
- **50:** niets nieuws voor deze rol; sterkere rangen (Summon Hawk op 36 en 48, Aimed Shot op 44 en 52, Mend Pet op 44 en 52).
  GEMETEN [TD]. De gidsen zetten de punten na 40 in Marksmanship (Lethal Attacks, Careful Aim). GEMETEN in [PS], [WFI],
  [CWF], [SF], [HP].
- **60:** sterkere rangen (Summon Hawk, Aimed Shot, Mend Pet op 60); niets nieuws. GEMETEN [TD].

### Beginner mistakes
- Schieten vóór je pet de vijand heeft: dan komt de vijand naar jou. GEMETEN in [IV-BM] ("one of the most common mistakes"), [WM-BM].
- Summon Hawk en Arcane Shot als twee losse knoppen zien. Ze delen één cooldown; hawks eerst. GEMETEN [DB2 Spell 1293241] + [WM-BM].
- Vechten in Aspect of the Cheetah of Monkey. Deadly Aspects werkt alleen met Hawk aan. GEMETEN [DB2 Spell 19552] + [WM-BM].
- Aimed Shot beginnen terwijl je loopt: hij heeft 2 seconden cast. GEMETEN [DB2] + [WM-BM].
- Je pet laten doodgaan omdat Mend Pet je schoten stopt. GEMETEN in [WM-BM], [IV-BM] ("always be watching your pet's health").
- Je pet niet voeren. GEMETEN in [WH], [IV-MM], [FDB].
- Meer vijanden tegelijk pakken: je pet houdt er één vast. GEMETEN in [WFI], [IV-BM].
- Bestial Wrath en Rapid Fire los van elkaar gebruiken. GEMETEN in [WM-BM] (alleen deze gids).

---

## 7. Rol 2 — Marksmanship

- **band = 2** (GEMETEN, hoofdstuk 2)
- **Voorgestelde title:** `Marksmanship: damage from a distance`

### Intro-feiten
- Damage. Je eigen schoten doen het werk, van ver. GEMETEN in [IV-OV], [IV-MM], [WM-MM], [PS]; past bij [DIR] `FDIR_HUNTER_2`.
- Voor levelen: het kan goed, maar de gidsen noemen het minder dan Beast Mastery; je pet houdt de vijand slechter vast
  omdat jij meer schade doet. GEMETEN in [IV-MM], [SYS], [WFI].
- Sterk in groepen: Trueshot Aura helpt de hele party of raid; Multi-Shot en Volley voor groepen vijanden. GEMETEN
  [DB2 Spell 1299346] + [IV-OV], [HP], [FDB beast-mastery/leveling] ("move to Marksmanship at 40 for dungeon runs").
- **Lone Wolf** (talent, 20 op zijn vroegst): 20% meer schade zolang je géén pet hebt. Een keuze, geen moeten. GEMETEN
  [DB2 Spell 415370]. Tijdens levelen houden de gidsen de pet: [FG] ("left out … this build keeps the pet"), [WM-MM],
  [IV-MM] (pet tankt).
- Aimed Shot (trainer, 20) is je hoofdschot; **Sniper Shot** (talent, 40) is nieuw: 4 seconden cast, tot 45 yards.
  GEMETEN [TD], [DB2] + [IV-OV].

### Simple order (met toetsen)
Vooraf: Aspect of the Hawk (**Shift-R**) en Trueshot Aura (**Shift-X**, vanaf 25) aan. GEMETEN [K] + [WM-MM].
1. Hunter's Mark (**Shift-Z**); heb je een pet: pet erop (**Ctrl-1**). GEMETEN in [IV-MM], [WM-MM].
2. Vijand nog ver weg: Sniper Shot (**Shift-4**, vanaf 40) als opening. GEMETEN in [FW], [WFI]
   ("use it before the enemy reaches you"); [IV-MM] opent ermee als je de Rapid Killing-buff hebt, anders Aimed Shot.
3. Serpent Sting (**2**). GEMETEN in [IV-MM] (altijd, om Rapid Killing), [FDB marksmanship/rotation]. ⚠️ [WM-MM]: alleen
   op lange gevechten. Zie 9.6.
4. Aimed Shot (**4**, vanaf 20) elke keer dat hij klaar is; sta stil. GEMETEN in [IV-MM], [WM-MM], [FDB].
5. Arcane Shot (**3**) tussendoor, als je mana het toelaat. GEMETEN in [WM-MM], [FDB]; [IV-MM] alleen bij vol mana.
6. Auto Shot (**1**) loopt door.
7. Groep vijanden: Multi-Shot (**Shift-1**) in plaats van Aimed Shot; grote groep: Volley (blok D, vanaf 40).
   GEMETEN in [IV-MM], [WM-MM], [FDB].
8. Vijand bij jou: Scatter Shot (**E**, vanaf 30), dan afstand nemen; Concussive Shot (**Shift-Q**) maakt hem traag.
   GEMETEN in [WM-MM], [FW], [FDB].
9. Zware vijand: Rapid Fire (**Q**, vanaf 26) aan het begin. GEMETEN in [IV-MM], [WM-MM].

### Per 10 levels
- **10:** pet (5.1), Aspect of the Hawk (**Shift-R**). Rij 1: Lethal Attacks, Hawk Eye, Improved Concussive Shot.
  Vanaf 15 rij 2: Careful Aim, Efficiency, Improved Stings. Multi-Shot (**Shift-1**) op 18. GEMETEN [DB2], [TD], [K].
- **20:** Aimed Shot (**4**): van de trainer, geen talent. Talent-rij 3: Rapid Killing, Improved Arcane Shot, Lone Wolf.
  Aspect of the Cheetah (**R**), Disengage (**Z**), Freezing Trap (**V**). GEMETEN [TD], [DB2], [K].
- **30:** Scatter Shot (**E**, talent). Feign Death (**X**). Daarvóór: Trueshot Aura (**Shift-X**, talent) op 25,
  Rapid Fire (**Q**) op 26. GEMETEN [DB2], [TD], [K]; talent-level AFGELEID.
- **40:** Sniper Shot (**Shift-4**, talent; Trueshot Aura moet je hebben). Volley (blok D). Daarvóór: Ranged Weapon
  Specialization (passief) vanaf 35, Trueshot Aura rang 2 bij de trainer op 32. GEMETEN [DB2 TraitEdge], [TD] r. 276, 297.
- **50:** sterkere rangen: Sniper Shot op 48, Trueshot Aura op 50, Volley op 50, Aimed Shot op 44 en 52. GEMETEN [TD].
  Na 40 zetten de gidsen de punten in Beast Mastery (Deadly Aspects, enz.). GEMETEN in [IV-MM], [PS], [WFI].
- **60:** sterkere rangen (Sniper Shot op 58, Aimed Shot en Trueshot Aura op 60); niets nieuws. GEMETEN [TD].
- Schrijver: na elke nieuwe rang Trueshot Aura opnieuw aanzetten (hij duurt 30 minuten). GEMETEN [DB2 SpellDuration 30] + [FW].

### Beginner mistakes
- Lopen tijdens Aimed Shot of Sniper Shot: beide hebben een cast (2 en 4 seconden). GEMETEN [DB2] + [WM-MM], [FDB].
- Multi-Shot op één vijand: dan is Aimed Shot ook 6 seconden weg. GEMETEN [DB2 Spell 2643] + [WM-MM].
- Sniper Shot als de vijand al bij je staat: 4 seconden cast en hij werkt niet binnen 8 yards. GEMETEN [SR 582] + [FW], [WFI].
- Lone Wolf nemen en je pet toch uit hebben: dan doet het talent niets. GEMETEN [DB2 Spell 415370] + [FG].
- Trueshot Aura vergeten. GEMETEN in [WM-MM].
- Na Scatter Shot doorslaan: elke schade haalt het effect weg, en hij zet je aanval uit. GEMETEN [DB2 Spell 19503] + [FDB].
  Scatter Shot is geen echte interrupt ([FDB]); de Hunter heeft er geen ([FDB abilities]).
- Al je mana aan Serpent Sting en Arcane Shot uitgeven. GEMETEN in [WM-MM]; [IV-MM] zegt: je mana is je grens.
- Rapid Fire op een vijand die bijna dood is (cooldown 5 minuten). GEMETEN [DB2] + [WM-MM], [FDB].

---

## 8. Rol 3 — Survival

- **band = 3** (GEMETEN, hoofdstuk 2)
- **Voorgestelde title:** `Survival: damage up close, with traps`

### Intro-feiten
- Damage, **dichtbij**. In Forever is Survival de melee-Hunter: Raptor Strike, Mongoose Bite, Counterattack, Strider Kick,
  plus traps. GEMETEN [DB2] (alle nieuwe Survival-talenten gaan over melee of traps) + [WCFI], [WM-SV], [WFI], [FDB], [PS].
  Past bij [DIR] `FDIR_HUNTER_3`.
- Voor levelen: de traagste van de drie; tot ongeveer 30 speel je als elke andere Hunter (pet erop, schieten).
  GEMETEN in [IV-SV] ("starts off as the weakest of the three"), [WFI], [FDB survival/leveling], [HP].
- Je houdt je pet en je schietwapen: je opent van afstand en stapt dan in. GEMETEN in [IV-SV], [FDB], [WM-SV].
- Kernspells komen laat: Mongoose Bite 16, Deterrence 20, Counterattack 25 (of 30), Strider Kick en Aspect of the Beast 30,
  Lacerating Strikes 40. GEMETEN [TD], [DB2]; talent-levels AFGELEID.
- Welk melee-wapen: de gidsen zijn het oneens (9.3). [DIR] `FDIRB_W_SURVIVAL` zegt nu "not known yet": dat klopt nog.
- Kost veel mana (melee-spells) en een grote crit kan de vijand van je pet trekken. GEMETEN in [IV-SV], [WFI].

### Simple order (met toetsen)
Vooraf: Aspect of the Hawk (**Shift-R**) zolang je schiet; vanaf 30 **Aspect of the Beast** (blok D) voor het vechten
dichtbij. GEMETEN [K], [DB2 Spell 13161] + [WM-SV], [FDB survival/rotation].
1. Hunter's Mark (**Shift-Z**). Zonder Mark werkt Expose Prey niet. GEMETEN [DB2 Spell 1310532] + [IV-SV], [WM-SV], [FDB].
2. Pet erop (**Ctrl-1**). GEMETEN in [IV-SV], [WM-SV].
3. Serpent Sting (**2**), dan Arcane Shot (**3**) terwijl de vijand komt of jij erheen loopt. GEMETEN in [IV-SV], [WM-SV].
4. Trap bij je voeten: Immolation Trap (**Shift-2**, vanaf 16; vanaf 34 is deze toets Explosive Trap). GEMETEN [K] +
   [WM-SV], [FDB]. Traps werken in Forever ook in een gevecht. GEMETEN in [IV-SV], [CWF].
5. Dichtbij: Mongoose Bite (**Shift-C**, vanaf 16) zodra hij oplicht; Raptor Strike (**5**) elke keer dat hij klaar is;
   Strider Kick (blok D, vanaf 30) elke keer dat hij klaar is. GEMETEN in [WM-SV], [FDB], [IV-SV].
6. Counterattack (**Shift-V**) direct na een parry. GEMETEN [DB2 Spell 19306] + [WM-SV], [FDB].
7. Vijand rent weg, of jij wilt weer afstand: Wing Clip (**Shift-F**). GEMETEN in [WM-SV], [IV-SV].
8. In nood: Deterrence (**C**, vanaf 20; geeft ook meer kansen op Mongoose Bite en Counterattack), Feign Death (**X**, vanaf 30).
   GEMETEN [DB2] + [WM-SV], [FDB].
⚠️ Stap 5: [IV-SV] loopt na Strider Kick weer naar afstand en schiet (weven); [WM-SV] en [FDB] blijven dichtbij. Zie 9.2.

### Per 10 levels
- **10:** pet (5.1). Raptor Strike (**5**) heb je vanaf level 1. Rij 1: Improved Tracking, Deflection; vanaf 15 rij 2:
  Savage Strikes, Survivalist, Entrapment, Improved Wing Clip. Wing Clip (**Shift-F**) op 12, Mongoose Bite (**Shift-C**)
  en Immolation Trap (**Shift-2**) op 16. GEMETEN [TD], [K], [DB2].
- **20:** Deterrence (**C**, talent). Freezing Trap (**V**), Disengage (**Z**), Dual Wield (passief, trainer). Aimed Shot (**4**).
  Talent-rij 3 ook: Surefooted, Clever Traps. GEMETEN [DB2], [TD] r. 245-251, [K].
- **30:** Strider Kick (blok D, talent), Aspect of the Beast (blok D, trainer), Feign Death (**X**). Daarvóór:
  Counterattack (**Shift-V**, talent) op 25 volgens de boom (⚠️ 9.10), Predator's Edge (passief) vanaf 25.
  Rij 5 ook: Expose Prey, Resourcefulness, Survivalist's Discipline. GEMETEN [DB2], [TD] r. 267-270, [K].
- **40:** Lacerating Strikes (talent, passief: Mongoose Bite geeft ook een bleed; Expose Prey moet je hebben).
  Daarvóór: Explosive Trap op **Shift-2** vanaf 34, Lightning Reflexes (passief) vanaf 35. GEMETEN [DB2 TraitEdge], [TD], [K].
- **50:** sterkere rangen: Counterattack op 42 en 54, Mongoose Bite op 44, Raptor Strike op 48, Explosive Trap op 44 en 54,
  Aspect of the Beast op 50. GEMETEN [TD]. Punten na 40: Marksmanship volgens [PS], [WFI], [FG]; Beast Mastery volgens
  [FDB]. Oneens (9.4).
- **60:** sterkere rangen (Aspect of the Beast en Wing Clip op 60, Mongoose Bite op 58, Raptor Strike op 56); niets nieuws.
  GEMETEN [TD].

### Beginner mistakes
- Verwachten dat Survival vroeg sterk is. Tot rond 30 speel je op afstand, met je pet. GEMETEN in [IV-SV], [FDB], [WFI].
- Meteen naar binnen rennen. Open van afstand (Mark, pet, Sting, schot) en stap dan in. GEMETEN in [FDB survival/rotation], [IV-SV].
- Hunter's Mark vergeten: dan geeft Expose Prey geen Mongoose Bite. GEMETEN [DB2 Spell 1310532] + [WM-SV], [FDB].
- Op Mongoose Bite of Counterattack drukken als ze niet oplichten. Mongoose Bite mag alleen na een dodge (of via
  Expose Prey), Counterattack alleen na een parry. GEMETEN [DB2 Spell 1495, 19306, 1310532].
- Dichtbij in Aspect of the Hawk blijven na level 30. Hawk helpt alleen je schoten; Beast geeft Melee Attack Power.
  GEMETEN [DB2 Spell 13165, 13161] + [WM-SV].
- Strider Kick en Aspect of the Beast op een vaste toets zoeken. Ze staan op blok D. GEMETEN [K] r. 62.
- Na 34 Immolation Trap op **Shift-2** zoeken: die toets is dan Explosive Trap. AFGELEID uit [K] r. 28, r. 70.
- Zonder trap beginnen. GEMETEN in [WM-SV] (alleen deze gids).

---

## 9. Gidsen oneens

1. **Hoe goed levelt Marksmanship?** [IV-MM]: "one of the strongest … quite a bit worse than Beast Mastery". [WH]: "all
   three are extremely competitive". [SYS] (vóór launch): "on paper, no". Allen noemen BM eerst.
2. **Survival: dichtbij blijven of weven?** [IV-SV]: in voor Raptor Strike / Mongoose Bite / Strider Kick, dan terug naar
   afstand en schieten. [WM-SV], [FDB]: na de opening dichtbij blijven. [WFI]: "kick, then run back out to range".
3. **Survival-wapen.** [WM-SV]: twee wapens ("fighting with a single weapon" is een fout). [HP]: "a two-hander still
   out-damages its dual wield". [FDB], [IV-SV]: traag zwaar wapen, dual wield mag ook. Geen meting.
4. **Survival-punten.** Strider Kick op 30 ([FDB], [SF]; [CWF] zet hem in de band 30-39), 32 ([FG]), 34 ([PS]) of 35
   ([IV-SV] via [TS], [WFI]). Lacerating Strikes op 40 ([FDB], [FG], [PS]; [CWF] in de band 40-49) of 45 ([IV-SV] via
   [TS], [WFI]); [IV-SV] zegt dat je hem ook kunt overslaan. Eerste punten: Improved Tracking ([PS], [FG], [FDB], [CWF]) of Lethal Attacks uit Marksmanship ([IV-SV], [WFI]).
   Na 40: Marksmanship ([PS], [WFI], [FG]) of Beast Mastery ([FDB]). De boom zelf: 30 en 40 op zijn vroegst.
5. **BM eerste punten.** Deadly Aspects eerst ([IV-BM], [PS], [WFI], [SF], [HP], Maxroll via [TS]) of Endurance Training
   eerst ([CWF]). [IV-BM] noemt beide en kiest schade. Pathfinding vroeg: ja ([IV-BM], [WFI]), niet ([PS], [CWF]).
6. **Serpent Sting.** Altijd erop ([IV-BM], [IV-MM], [FDB]) of alleen als de vijand lang leeft / je mana het toelaat
   ([WM-BM]: langer dan 15 seconden; [WM-MM]: "on short fights skip the sting"; [IV-SV]: niet opnieuw zetten).
7. **Aimed Shot of Multi-Shot op één vijand.** [IV-BM], [IV-MM] (Impakt): Aimed Shot, Multi-Shot "never" op één vijand.
   [IV-SV] (Veramos, zelfde site): Aimed Shot "will not be used even in single target", Multi-Shot wel. [WM-BM]:
   Aimed Shot stilstaand, Multi-Shot als je loopt.
8. **Welke pet.** [IV-MM]: Bear is sterk (Swipe raakt meer vijanden). [IV-SV]: Cat of Raptor met Claw; Bear "not as
   great as it seems". [FDB]: Bear met Swipe voor groepen.
9. **MM-punten.** Sniper Shot op 40 ([IV-MM], [PS], [WFI], [FG], [FW]), 47 (stillsixty via [SYS]) of 49 ([FDB] via [SYS]).
   Trueshot Aura op 25 ([IV-MM], [FG], [FW], [WFI]), 30 ([PS], [WM-MM]) of 34 ([FDB] via [SYS]). De boom: 25 en 40 op zijn vroegst.
10. **Counterattack: 25 of 30.** De boom zet hem in rij 4 (15 punten → 25, AFGELEID); [CWF] ("15 points in Survival"),
    [FG] ("Counterattack at level 25"), [WM-SV] ("Lv 25"), [PS] (26 in hun volgorde). Maar [DB2 SpellLevels 19306] = 30
    en MH's `SPEC_MACROS` zegt 30 ([M] r. 444); de trainer geeft rang 2 op 30 ([TD] r. 268). Welke wint in het spel: niet gemeten.
    Advies voor de tekst: "25 at the earliest" met de boom, of beide noemen.
11. **Auto Shot.** [IV-SV], [FDB], [WFI], [SYS]: je moet 0,5 seconde stilstaan voor hij schiet (sinds 15 okt). [SYS] meldt
    dat oudere pagina's (wowf.io, Wowhead level-30-gids) nog "no cast time" zeggen. Niet in DB2 gemeten.
12. **Arcane Shot naast hawks (BM).** [WM-BM]: zodra er 2 hawks zijn. [IV-BM]: alleen als je mana vol is én de hawks nog
    langer dan 6 seconden blijven.

---

## 10. Niet gemeten

- **Niets is in de client getest.** Alles komt uit DB2, MH's eigen bestanden en gidsen.
- Of "10 + punten" in het spel klopt (AFGELEID), en of Talented een talent-spell vóór zijn spell-level laat werken.
- Counterattack 25 of 30 (9.10).
- **Lacerate voor de Hunter.** [WCFI]: "Every Hunter also learns Lacerate, a bleed, at 30". [FDB survival/rotation]:
  "listed as a level-30 trainer spell, so check what your trainer offers". GEMETEN [DB2]: spells 24118 / 24119 / 24120 /
  1299332 heten Lacerate (rang 1-4, spell-level 30 / 40 / 50 / 60) en staan in SkillLineAbility onder Survival (lijn 51).
  Maar: niet in [TD] (trainerlijst) en geen toets in [K]. Of de trainer hem echt verkoopt: niet gemeten. → niet noemen
  tot het in de client gezien is.
- Of de twee geparkeerde knopen (Improved Serpent Sting, oude Lightning Reflexes) echt niet te kiezen zijn (AFGELEID).
- Dat alle vier de traps één cooldown delen (gids + [C]; DB2 toont alleen 30 seconden per trap).
- Auto Shot: 0,5 seconde stilstaan (alleen gidsen); en of `/cast !Auto Shot` in Forever werkt zoals in Classic
  ([K] r. 7-8 zegt zelf "not yet measured in Forever").
- Pet-geluk in getallen (25% minder schade is een classic-regel volgens [FDB]); of een pet echt wegloopt ([WH] zegt het).
- Tem-getallen (20 seconden, niet boven je level) en Revive Pet 10 seconden: alleen uit [FDB].
- Getallen per rang van talenten met meer rangen: alleen uit [CWF] (build 70862), niet nagemeten in 70938.
- Hoe je Tranquilizing Shot (60) krijgt.
- Raptor Strike als "volgende slag"-aanval en de bug die [FDB] noemt.
- Welk melee-wapen het beste is voor Survival (9.3).
- De Icy Veins-pagina's zijn niet tot het eind gelezen (afgekapt na "Leveling Tips"); [IV-BM] update-datum niet gezien.

---

## 11. Opmerkingen voor de bouwchat (niet door mij aangepast)

1. **Survival en blok D.** Strider Kick (talent, cooldown 8 seconden, in elke gids een kernknop) en Aspect of the Beast
   (het melee-aspect vanaf 30) staan op blok D ([K] r. 62). De roltekst moet dat zeggen; of ze een vaste toets verdienen
   is een keuze voor Rob.
2. **Immolation Trap na 34.** Shift-2 wordt Explosive Trap; Immolation Trap staat dan alleen nog in `listed`. [WM-SV] en
   [FDB] gebruiken Immolation Trap ook na 34 op één vijand.
3. **`CLASSES.HUNTER` r. 141** zegt: "pet quests: you learn Tame Beast, Call Pet and Revive Pet". Gemeten ([DB2 SpellEffect]
   1579 en 5300, [CQ]): de tem-keten geeft Tame Beast, Call Pet en **Dismiss Pet**; **Revive Pet, Feed Pet en Beast
   Training** komen uit de volgende quest, Training the Beast. Een speler die daar stopt, kan zijn pet niet voeren of terughalen.
4. **`SPEC_MACROS` Counterattack level 30** ([M] r. 444) tegenover rij 4 van de boom (25). Zie 9.10.
5. **Lacerate (Hunter)**: als de trainer hem echt verkoopt op 30, ontbreekt hij in `ForeverTrainerData.lua` en in het
   toetsenblok. Eerst in de client nakijken (trainer-venster van een Hunter van 30+).
6. **Disengage** staat in `CLASSES.HUNTER` zonder uitleg. In Forever verlaagt hij threat van dichtbij en zet hij je
   auto-attack uit; het is geen sprong ([DB2 Spell 781]).
