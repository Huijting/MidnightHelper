# Rogue per rol — feiten voor "How you play" (WoW Forever)

Onderzoek: mh-research, 17 nov 2026. Voor mh-writer: teksten in de vorm van `ROLES.DRUID` (`Modules/ForeverHowToPlay.lua`).
Build van de spel-data: **1.60.1.70938** (wago DB2, opgehaald 17 nov 2026 via `tools/gamedata.py` en de lokale cache).
Niets hiervan is in het spel zelf getest. DB2 = structuur en getallen uit Blizzards tabellen, geen proef in de client.

Bij elke bewering staat **GEMETEN** (met bron) of **AFGELEID** (beredeneerd).

## Bronnen (afkortingen)

| Afk. | Bron | Datum / build |
|---|---|---|
| DB2 | wago DB2 Forever, tabellen `TraitNode`, `TraitNodeXTraitNodeEntry`, `TraitNodeEntry`, `TraitDefinition`, `TraitNodeGroupXTraitNode`, `TraitNodeGroupXTraitCond`, `TraitCond`, `TraitEdge`, `TraitDefinitionEffectPoints`, `CurvePoint`, `TalentTab`, `Spell`, `SpellName`, `SpellLevels`, `SpellPower`, `SpellCooldowns`, `SpellMisc`, `SpellDuration`, `SpellEffect`, `SpellEquippedItems`, `SpellShapeshift` | build 1.60.1.70938, 17 nov 2026 |
| BLOCK | `Modules/ForeverBlock_Rogue.lua` r. 28-58 (MH's vaste toetsen) | gelezen 17 nov 2026 |
| HTP | `Modules/ForeverHowToPlay.lua` r. 197-239 (`CLASSES.ROGUE`) | gelezen 17 nov 2026 |
| MAC | `Modules/ForeverMacros.lua` r. 407-426 (`SPEC_MACROS`), r. 618 (boomnamen), r. 676 (`TREE.ROGUE = 1111`) | gelezen 17 nov 2026 |
| TRN | `Modules/ForeverTrainerData.lua` r. 874-987 (trainer-levels Rogue) | gelezen 17 nov 2026 |
| CWF-A / CWF-C / CWF-S | classicwowforever.com/class-guides/rogue/assassination/ , /combat/ , /subtlety/ | "Updated 11 Nov" 2026, build 1.60.1.70862 |
| CWF-K | classicwowforever.com/class-guides/rogue/ (class-pagina) | "Updated 11 Nov 2026", build 1.60.1.70862 |
| IV-A / IV-C / IV-S | icy-veins.com/wow-forever/assassination-rogue-leveling , /combat-rogue-leveling , /subtlety-rogue-leveling | "Last Updated: Nov 4, 2026". IV-A en IV-S heel gelezen; IV-C alleen het stuk tot en met de rotatie (zoekfragment), de tips onderaan niet. |
| MOB | mobalytics.gg/wow-forever/classes/rogue-leveling-guide | "Updated on Nov 12, 2026" |
| WFA | wowforeveraddon.com/guides/rogue-leveling-guide/ | "Updated 2026-11-11" |
| WT | warcrafttavern.com/forever/guides/rogue-leveling/ | geen datum gevonden; gelezen tot en met de mijlpaaltabellen van Combat (de rest was afgekapt) |
| MMO | mmoexp.com (Rogue Leveling Guide 1-60, Combat) | 14 nov 2026 |
| POL | polestar.guide/guides/class/rogue | geen datum; "Checked on game build 1.60.1.70450"; talentplannen staan daar op pauze |
| WM | warcraftmaps.com/classes/rogue/subtlety/rotation | "checked 16 Nov 2026", maar build 1.60.1.70685 |
| WH | wowhead.com/forever/guide/classes/rogue/... | tekst NIET leesbaar (zie "Niet gemeten") |

Let op de datum **2 november 2026**: Blizzard heeft toen alle drie de Rogue-bomen omgebouwd (GEMETEN: CWF-K/CWF-C, "Blizzard:
Forever development notes, 2 November, checked 3 Nov"). Gidsen of builds van vóór die datum (POL build 70450, WM build 70685)
beschrijven een oude boom. De boom hieronder is gemeten in build 70938 en komt overeen met CWF (build 70862).

---

## 1. Welke boom is welke band

- **Band 1 = Assassination, band 2 = Combat, band 3 = Subtlety.** GEMETEN, drie keer:
  - DB2 `TalentTab` (cache `TalentTab.enUS.csv` r. 8-10): 182 Assassination `OrderIndex` 0, 181 Combat `OrderIndex` 1, 183 Subtlety `OrderIndex` 2, alle drie `ClassMask` 8.
  - DB2 `TraitNode`, boom 1111, 54 knopen: PosX 1020-2820 = Malice … Mutilate; PosX 5020-6820 = Efficient Strikes … Adrenaline Rush; PosX 9080-10880 = Opportunity … Death Mark.
  - MAC r. 618: `enUS = { "Assassination", "Combat", "Subtlety" }`; r. 676: `ROGUE = 1111`.
- **De Rogue-boom is `TraitTree` 1111.** GEMETEN: MAC r. 676, en de 54 knopen van boom 1111 zijn allemaal Rogue-talenten (DB2-dump 17 nov).
- **17 + 19 + 18 = 54 talenten.** GEMETEN: DB2 `TraitNode` boom 1111 (17 in band 1, 19 in band 2, 18 in band 3).
- **Vroegste level van een talent = 10 + het aantal punten dat al in die boom moet zitten.** AFGELEID (zelfde regel als bij de andere classes).
  Steun, GEMETEN in DB2 `SpellLevels`: Premeditation `BaseLevel` 20 (10 punten nodig), Venom 30 (20 nodig), Hemorrhage 30 (20 nodig),
  Mutilate 40 (30 nodig), Death Mark 40 (30 nodig): 5 van 5 kloppen met 10 + punten.
- **De Legacy-perk Talented geeft talentpunten tot 5 levels eerder.** GEMETEN in gidsen (WT: "up to 5 levels sooner"; MMO: "a first point at
  level 5 with Rank 5", maximum blijft 51; POL docs/players/talent-plans). Niet in DB2 gemeten.
- **51 talentpunten op level 60.** GEMETEN in gidsen (CWF: "0 of 51 points"; MOB: "Points spent 51"; MMO). Niet in DB2 gemeten.

### De hele boom (GEMETEN: DB2 build 70938; "nodig" = `TraitCond.SpentAmountRequired`; level = AFGELEID 10 + nodig)

Band 1, Assassination:

| Rij | Nodig | Vroegst | Talenten (rangen) |
|---|---|---|---|
| 1 | 0 | 10 | Improved Gouge (3), Remorseless Attacks (2), Malice (5) |
| 2 | 5 | 15 | Ruthlessness (3), Improved Expose Armor (2), Improved Slice and Dice (3) |
| 3 | 10 | 20 | Vigor (2), Blood Splatter (1), Lethality (2; eist Malice) |
| 4 | 15 | 25 | Vile Poisons (5), **Cold Blood** (1), Improved Poisons (5) |
| 5 | 20 | 30 | Relentless Strikes (5), **Venom** (1), Improved Kidney Shot (2) |
| 6 | 25 | 35 | Seal Fate (3) |
| 7 | 30 | 40 | **Mutilate** (1; eist Venom) |

Band 2, Combat:

| Rij | Nodig | Vroegst | Talenten (rangen) |
|---|---|---|---|
| 1 | 0 | 10 | Coup de Grace (3), Efficient Strikes (2), Lightning Reflexes (5) |
| 2 | 5 | 15 | Puncturing Wounds (3), Deflection (3), Precision (3), Improved Sprint (2) |
| 3 | 10 | 20 | Endurance (2), **Riposte** (1; eist Deflection), Composure (2) |
| 4 | 15 | 25 | Improved Kick (2), Flawless Execution (1), Weapon Expertise (2; eist Precision), Aggression (3) |
| 5 | 20 | 30 | Dual Wield Specialization (2), **Blade Flurry** (1), Hack and Slash (5) |
| 6 | 25 | 35 | Flash of Steel (5) |
| 7 | 30 | 40 | **Adrenaline Rush** (1; eist Blade Flurry) |

Band 3, Subtlety:

| Rij | Nodig | Vroegst | Talenten (rangen) |
|---|---|---|---|
| 1 | 0 | 10 | Setup (3), Master of Deception (3), Opportunity (5) |
| 2 | 5 | 15 | Dirty Deeds (2), Camouflage (3), Improved Ambush (3), Dirty Tricks (2) |
| 3 | 10 | 20 | Initiative (3), **Premeditation** (1), Serrated Blades (3) |
| 4 | 15 | 25 | Elusiveness (2), **Ghostly Strike** (1), Quick Getaway (2; eist Dirty Tricks) |
| 5 | 20 | 30 | Heightened Senses (2), **Preparation** (1), **Hemorrhage** (1; eist Serrated Blades) |
| 6 | 25 | 35 | Boot Knife (5) |
| 7 | 30 | 40 | **Death Mark** (1; eist Preparation) |

Vet = een talent met een eigen knop. De rest is passief (geen toets).
"Eist X" = GEMETEN als `TraitEdge` in DB2. Dat X daarvoor op volle rang moet staan is GEMETEN in een gids (CWF talentpagina:
"Preparation at full rank"), niet in DB2.

### Talent-levels in `SPEC_MACROS` (MAC r. 407-426), nagekeken tegen de boom

- Cold Blood 25, Mutilate 40, Adrenaline Rush 40, Blade Flurry 30, Riposte 20, Premeditation 20, Ghostly Strike 25, Preparation 30:
  alle acht kloppen met 10 + nodig. GEMETEN (MAC) + AFGELEID (regel).
- `shankvenom` staat op level 40 met `need = 399956` (Mutilate): dat is het level van de **macro**, niet van Venom. Venom zelf is 30
  op zijn vroegst, Shank is 24 bij de trainer. GEMETEN: MAC r. 411-412, DB2 (Venom rij 5), TRN r. 909.

---

## 2. Wat elke Rogue heeft (voor alle drie de rollen)

Toetsen: GEMETEN in BLOCK. Levels: GEMETEN in TRN (trainer) tenzij anders gezegd. Getallen: GEMETEN in DB2 (rang 1).

| Toets | Spell | Level | Feit |
|---|---|---|---|
| 1 | Sinister Strike | 1 | 45 Energy, 1 combo point. Werkt met elk wapen, ook van voren. |
| 2 | Backstab | 4 | 60 Energy, 150% wapenschade, 1 combo point. Dolk in de hoofdhand, en achter de vijand staan. |
| 4 | Eviscerate | 1 | Finisher, 35 Energy. |
| Shift-4 | Slice and Dice | 10 | Finisher, 25 Energy. Je slaat 20% sneller; 9 / 12 / 15 / 18 / 21 seconden bij 1-5 punten. Rang 2 op 42: 30% sneller (TRN r. 946, DB2 spell 6774). |
| 5 | Rupture | 20 | Finisher, 25 Energy. Schade over tijd; 8-16 seconden bij 1-5 punten. |
| Shift-3 | Shank | 24 | Slag met je tweede wapen: 5 Energy, geeft 15 Energy terug, cooldown 10 seconden, kan niet missen. Rang 2 op 44 geeft 25 Energy terug (TRN r. 951, DB2 spell 1329549). |
| — | Poised (passief) | 18 | Volle Energy en niet in gevecht: je volgende aanval kost 10 Energy minder. Geen toets. (TRN r. 897, DB2 spell 1328825) |
| Shift-R | Stealth | 1 | Je loopt 50% langzamer. Na Stealth 10 seconden wachten. |
| 1 (in Stealth) | Garrote | 14 | 50 Energy, schade over 18 seconden, 1 combo point. In Stealth én achter de vijand. |
| 2 (in Stealth) | Ambush | 18 | 60 Energy, 250% wapenschade, 1 combo point. In Stealth, achter de vijand, dolk in de hoofdhand. |
| V (in Stealth) | Cheap Shot | 26 | 60 Energy, stun van 4 seconden, 2 combo points. |
| V | Kidney Shot | 30 | Finisher, 25 Energy, stun 1-5 seconden, cooldown 20 seconden. Rang 2 op 50: 2-6 seconden (TRN r. 963, DB2 spell 8643). |
| Shift-Q | Gouge | 6 | 45 Energy, 4 seconden uitgeschakeld, cooldown 10 seconden. Vijand moet naar je toe kijken. Schade breekt het. |
| Shift-Q (in Stealth) | Sap | 10 | 65 Energy. Alleen Humanoids die niet vechten. Breekt Stealth niet. |
| E | Kick | 12 | 25 Energy, cooldown 10 seconden. Stopt een spell; die soort spell 5 seconden op slot. |
| Z | Evasion | 8 | +50% dodge, 15 seconden, cooldown 5 minuten. |
| R | Sprint | 10 | +50% snelheid, 15 seconden, cooldown 5 minuten. |
| X | Vanish | 22 | Cooldown 5 minuten. |
| F | Feint | 16 | 20 Energy, cooldown 10 seconden. Minder threat. |
| Shift-Z | Expose Armor | 14 | Finisher, 25 Energy, 30 seconden minder armor op de vijand. |
| Shift-F | Distract | 22 | 30 Energy, cooldown 30 seconden. |
| Shift-V | Blind | 34 | 30 Energy, 10 seconden, cooldown 5 minuten. Schade breekt het. |
| Shift-2 | Throw / Shoot | 1 | Hangt af van het wapen in je afstandsslot (BLOCK r. 36, HTP r. 210). |

Verder, voor alle rollen:
- **Dual Wield op level 10** (een wapen in elke hand). GEMETEN: TRN r. 882. Passief, geen toets (DB2 spell 674).
- **Poisons vanaf ongeveer level 20, uit een quest; het zijn items, niet op het blok (blok D).** GEMETEN: HTP r. 225 en r. 237; WT ("20 Poisons, Class Quest"); POL (quest "Poisons", levels 20-24 Alliance, 20-26 Horde).
- **Energy vult zichzelf, ongeveer 10 per seconde.** GEMETEN in gidsen (IV-A, IV-C: "10 Energy a second"; MOB: "1 per 0.1 seconds"); HTP r. 200 zegt hetzelfde in woorden. Niet in DB2 gemeten.
- **Een Rogue heeft geen aanval die een hele groep raakt, en kan zichzelf niet healen.** GEMETEN in gidsen (IV-A/IV-C/IV-S "No AoE", "No self-healing skills"; CWF-A: "A Rogue has no area attack, so a pack means control"). Combat's Blade Flurry (twee vijanden) is de enige uitzondering (IV-C, MOB).
- **Een Rogue doet alleen schade: geen tank, geen healer.** GEMETEN: CWF-K ("Rogues only deal damage").
- **Combo points blijven op de vijand waar je ze opbouwde.** GEMETEN in gidsen (IV-A, IV-C, CWF-A, CWF-C).
- **Vanish kost een Flash Powder, Blind een Blinding Powder.** GEMETEN: HTP r. 226-227, r. 236; IV-S (Vanish "requires a reagent", Blind "only if you have Blinding Powder"); CWF-A (Blinding Powder is een spell op 34 die het poeder maakt; TRN r. 929). Niet in DB2 gemeten in deze ronde.

---

## 3. Rol: Assassination (band 1)

**Voorgestelde title:** `Assassination: daggers and poison`

### Intro-feiten
- Schade van dichtbij, met dolken en gif. GEMETEN: CWF-K ("Poisons & combo points"); POL ("Assassination with daggers and poisons (Mutilate)"); WFA ("Assassination is the dagger and poison route").
- Het hoofdtalent Mutilate komt op zijn vroegst op level 40 en heeft dolken nodig. GEMETEN: DB2 (rij 7, 30 punten nodig; `SpellLevels` 40; `SpellEquippedItems` subclass-masker 32768 = dolken, ook op de twee deelslagen 399960 en 399961). Level 40 = AFGELEID (10 + 30), gesteund door `BaseLevel` 40.
- "Een dolk in elke hand": GEMETEN in gidsen (CWF-A: "You need a dagger in each hand"; IV-A: "you must use two Daggers"). In DB2: de beschrijving zegt "attacks with both weapons" en beide deelslagen eisen een dolk (GEMETEN); dat het dus twee dolken zijn is AFGELEID.
- Tot 40 speel je met Backstab (achter de vijand, dolk) of Sinister Strike. GEMETEN: CWF-A, IV-A.
- De gidsen noemen deze boom niet de makkelijkste start: WT "generally not recommended as a starter build"; MOB "Requires heavy talent point investment"; IV-A: de grote sprong komt pas met Mutilate, daarvoor kan het "a bit slow" voelen. GEMETEN (gidsen).
- Sommige vijanden zijn immuun voor gif. GEMETEN: IV-A ("Mobs can be immune to poison"). Welke vijanden: niet gemeten.

### Simple order (toetsen: GEMETEN in BLOCK; de volgorde is samengevoegd uit CWF-A, IV-A en WT = AFGELEID, per stap staat de gids)
1. Vanaf 20: gif op beide wapens (items op blok D). — CWF-A, IV-A.
2. Wacht op volle Energy (Poised, vanaf 18: eerste aanval 10 Energy goedkoper). — CWF-A; DB2.
3. Stealth (**Shift-R**), loop achter de vijand. Open met Ambush (**2**, vanaf 18, dolk in de hoofdhand) of Garrote (**1**, vanaf 14). Op een sterke vijand vanaf 26: Cheap Shot (**V**), een stun van 4 seconden. — CWF-A. (IV-A noemt Cheap Shot of Garrote; WT noemt Ambush.)
4. Combo points maken: Backstab (**2**) als je achter de vijand staat, anders Sinister Strike (**1**). Vanaf 40: Mutilate (**3**), 2 punten per keer. — CWF-A, IV-A.
5. Shank (**Shift-3**, vanaf 24) elke keer dat hij klaar is. Met Venom (vanaf 30) maakt elke Shank je gif 6 seconden sterker. — CWF-A ("Use it on cooldown"); DB2.
6. Finisher: Slice and Dice (**Shift-4**) als het gevecht lang duurt; anders Eviscerate (**4**) bij 5 punten. Rupture (**5**, vanaf 20) op een vijand die lang leeft (elite, baas). — CWF-A, IV-A.
7. Cold Blood (**F1**, vanaf 25) vlak voor een Eviscerate met 5 punten. — CWF-A; IV-C zegt hetzelfde ("use it on Eviscerate").

Tip voor de tekst: staat de vijand met zijn gezicht naar je toe, dan Gouge (**Shift-Q**), achter hem stappen en Backstab (**2**). GEMETEN: CWF-S, IV-S. Gouge kost 45 Energy en duurt 4 seconden (DB2).

### Per 10 levels (trainer-levels GEMETEN in TRN; talent-levels AFGELEID 10 + nodig, "nodig" GEMETEN in DB2; toetsen GEMETEN in BLOCK)
- **10**: Sinister Strike (**1**), Eviscerate (**4**), Backstab (**2**), Stealth (**Shift-R**), Gouge (**Shift-Q**), Evasion (**Z**) heb je al. Nieuw op 10: Slice and Dice (**Shift-4**), Sprint (**R**), Sap (**Shift-Q** in Stealth), en een wapen in elke hand (Dual Wield). Eerste talentpunt. Daarna Kick (**E**) op 12, Garrote (**1** in Stealth) en Expose Armor (**Shift-Z**) op 14, Feint (**F**) op 16, Ambush (**2** in Stealth) en Poised (passief) op 18.
- **20**: Rupture (**5**). Poisons uit een quest. Daarna Vanish (**X**) op 22, Shank (**Shift-3**) op 24, Cold Blood (**F1**, talent) op 25: je volgende Sinister Strike, Backstab, Ambush, Eviscerate of Mutilate is zeker een crit; cooldown 3 minuten (DB2 spell 14177: +100%, 180 s). Cheap Shot (**V** in Stealth) op 26.
- **30**: Venom (talent, passief, geen toets): elke Shank geeft je gif 6 seconden lang 30% meer schade en 20% meer kans om aan te slaan (DB2 spell 1329328 en 1310703). Kidney Shot (**V**) op 30. Daarna Blind (**Shift-V**) op 34. Seal Fate (talent, passief) op 35: een crit met een aanval die combo points geeft, geeft een extra punt (33 / 66 / 100% bij 1-3 rangen; DB2 curve 83040).
- **40**: Mutilate (**3**, talent): 60 Energy, slaat met beide dolken (90% wapenschade elk), 2 combo points, 20% meer schade op een vergiftigde vijand (DB2 spell 399956, 399960). Daarna Slice and Dice rang 2 op 42, Shank rang 2 op 44.
- **50**: Mutilate rang 2 (trainer, TRN r. 964), Kidney Shot rang 2. Verder niets nieuws voor deze rol.
- **60**: Mutilate rang 3 (TRN r. 984) en sterkere rangen; niets nieuws voor deze rol.

Passieve talenten die een schrijver mag noemen (getallen GEMETEN: DB2 `CurvePoint`, build 70938):
Malice +1-5% crit; Improved Slice and Dice 15 / 30 / 45% langer; Ruthlessness 20 / 40 / 60% kans op een punt terug na een finisher;
Remorseless Attacks: na een kill 20 / 40% meer crit op je volgende aanval, 20 seconden lang; Blood Splatter: Rupture 6 seconden
langer, Garrote 9 seconden langer; Lethality 10 / 20% meer crit-schade; Relentless Strikes: per combo point 4-20% kans dat een
finisher 25 Energy teruggeeft; Vile Poisons tot 20% meer gifschade; Improved Poisons tot 10% vaker gif, tot 50% kans dat een
lading niet opgaat.

### Beginner mistakes
- Mutilate zonder dolken. Het heeft een dolk in elke hand nodig. GEMETEN: DB2 (dolk-eis), CWF-A, IV-A. → haal de tweede dolk vóór level 40 (CWF-A).
- Shank vergeten. Venom werkt alleen door Shank. GEMETEN: DB2-beschrijving van Venom; CWF-K ("Venom only triggers from Shank").
- Een toets zoeken voor Venom. Het is passief. GEMETEN: DB2 (spell 1329328 heeft geen kosten en geen cooldown; MAC r. 411 "Venom is passive").
- Backstab van voren of zonder dolk. GEMETEN: DB2-beschrijving; HTP r. 233.
- Punten verspillen met Mutilate. Mutilate geeft 2 punten; bij 4 punten is één gewone slag (Sinister Strike of Backstab) genoeg. GEMETEN: CWF-A, CWF-K.
- Van vijand wisselen met punten op de oude. Punten gaan niet mee. GEMETEN: IV-A, CWF-A.
- Gif vergeten na een bezoek aan de trainer (nieuwe rangen). GEMETEN: CWF-S ("Recoat after each trainer visit").
- Verwachten dat gif op elke vijand werkt. Sommige zijn immuun. GEMETEN: IV-A.

---

## 4. Rol: Combat (band 2)

**Voorgestelde title:** `Combat: steady damage with any weapon`
(De opdracht zei "zwaarden/Combat". GEMETEN: de boom is niet aan zwaarden gebonden, zie Hack and Slash hieronder. "Swords" in de titel
zou dus te smal zijn; in de tekst kan "a sword, axe, mace, fist weapon or dagger" staan.)

### Intro-feiten
- De gidsen noemen Combat de makkelijkste boom om alleen mee te levelen: MOB "the best leveling Rogue spec by far"; WFA "Combat is the usual solo pick"; POL "Level as Combat … for the steadiest kills". GEMETEN (gidsen). IV en CWF kiezen geen beste boom.
- Je hoeft niet achter de vijand te staan: de hoofdslag is Sinister Strike. GEMETEN: WFA ("does not depend on standing behind the target"); DB2 (Sinister Strike heeft geen positie-eis in de beschrijving; Backstab wel).
- Werkt met elk eenhandig wapen. GEMETEN: DB2, Hack and Slash (spell 13960, rij 5, 5 rangen): zwaard/bijl 1-5% kans op een extra slag, dolk/vuistwapen 1-5% meer crit, knots negeert 3-15% armor (`CurvePoint` 106209, 83026, 106210). Gidsen: CWF-K ("Combat and Subtlety work with any weapon type"), WFA.
- Rogues kunnen in Forever eenhandige bijlen leren. GEMETEN in gidsen (CWF-K, WFA, MOB). Niet in DB2 gemeten.
- Een langzaam wapen in de hoofdhand, een snel in de andere hand. GEMETEN in gidsen (CWF-C, MOB).
- Blade Flurry is het enige wat een Rogue heeft tegen twee vijanden tegelijk. GEMETEN: IV-C, MOB.

### Simple order (toetsen: GEMETEN in BLOCK; volgorde samengevoegd uit CWF-C, IV-C, MOB, WT = AFGELEID)
1. Wacht op volle Energy (Poised, vanaf 18). — CWF-C.
2. Openen mag uit Stealth (**Shift-R**): Garrote (**1**, vanaf 14) of vanaf 26 Cheap Shot (**V**). Gewoon naar de vijand lopen mag ook. — CWF-C, IV-C; WT ("Alternatively, walk up to mobs and attack directly").
3. Sinister Strike (**1**) om combo points te maken. — alle gidsen.
4. Riposte (**Shift-F1**, vanaf 20) zodra hij oplicht: dat gebeurt nadat je een aanval pareert. — CWF-C, IV-C, MOB.
5. Shank (**Shift-3**, vanaf 24) als hij klaar is. — CWF-C. (MOB: "when below 60 energy", zie "Gidsen oneens".)
6. Finisher: Slice and Dice (**Shift-4**) op een gevecht dat lang duurt; anders Eviscerate (**4**) bij 5 punten. — CWF-C, IV-C. (MOB en WT wegen dit anders, zie "Gidsen oneens".)
7. Twee vijanden: Blade Flurry (**Shift-1**, vanaf 30). Vanaf 40 samen met Adrenaline Rush (**Q**) bij een zware pull. Verlies je, dan Evasion (**Z**). — CWF-C, MOB, WFA.

### Per 10 levels
- **10**: Sinister Strike (**1**), Eviscerate (**4**), Stealth (**Shift-R**), Gouge (**Shift-Q**), Evasion (**Z**) heb je al. Nieuw op 10: Slice and Dice (**Shift-4**), Sprint (**R**), Sap (**Shift-Q** in Stealth), een wapen in elke hand. Eerste talentpunt. Daarna Kick (**E**) op 12, Garrote (**1** in Stealth) en Expose Armor (**Shift-Z**) op 14, Feint (**F**) op 16, Poised (passief) op 18.
- **20**: Riposte (**Shift-F1**, talent; eist Deflection): werkt alleen vlak nadat je een aanval pareert. 10 Energy, 150% wapenschade, de vijand is 6 seconden ontwapend, cooldown 6 seconden (DB2 spell 14251). Rupture (**5**) en Poisons (quest) op 20. Daarna Vanish (**X**) op 22, Shank (**Shift-3**) op 24, Cheap Shot (**V** in Stealth) op 26. Flawless Execution (talent, passief) op 25: Eviscerate kost 15 Energy minder (DB2 curve 128126).
- **30**: Blade Flurry (**Shift-1**, talent): 15 seconden lang sla je 20% sneller en raakt elke slag ook een tweede vijand vlakbij. 25 Energy, cooldown 2 minuten (DB2 spell 13877). Kidney Shot (**V**) op 30. Hack and Slash (talent, passief): een bonus die van je wapen afhangt. Daarna Blind (**Shift-V**) op 34. Flash of Steel (talent, passief) op 35: Shank geeft tot 15 Energy extra en is tot 2 seconden eerder klaar (DB2 curves 83037 en 128124: 3-15 Energy, 0,4-2,0 s).
- **40**: Adrenaline Rush (**Q**, talent; eist Blade Flurry): 15 seconden lang vult je Energy twee keer zo snel; cooldown 5 minuten (DB2 spell 13750: +100%, 15 s, 300 s). Daarna Slice and Dice rang 2 op 42 (30% sneller in plaats van 20%), Shank rang 2 op 44 (25 Energy terug in plaats van 15).
- **50**: Kidney Shot rang 2 en sterkere rangen; niets nieuws voor deze rol.
- **60**: sterkere rangen; niets nieuws voor deze rol.

Passieve talenten die een schrijver mag noemen (GEMETEN: DB2 `CurvePoint`, build 70938):
Efficient Strikes: Sinister Strike (en Hemorrhage) 3 / 5 Energy goedkoper; Coup de Grace: Eviscerate 7 / 13 / 20% sterker;
Precision +1-3% raakkans; Deflection +2 / 4 / 6% parry; Endurance: Sprint en Evasion 30 / 60% sneller terug; Composure: Poised
haalt nog 5 / 10 Energy extra van je eerste aanval; Aggression: Sinister Strike en Eviscerate 5 / 10 / 15% sterker; Dual Wield
Specialization: je tweede wapen doet 25 / 50% meer schade; Weapon Expertise: 1 / 2% minder vaak ontweken of gepareerd;
Improved Sprint 50 / 100% kans dat Sprint je losmaakt; Improved Kick 50 / 100% kans op Silence.

Let op het level van Riposte, Blade Flurry en Adrenaline Rush: 20, 30 en 40 zijn de vroegste levels, en alleen als álle eerdere
punten in Combat zitten (en voor Riposte: Deflection 3/3 binnen de eerste 10 punten). AFGELEID uit de boom. Gidsen nemen ze soms
later: Riposte op 21 (CWF-C) of 22 (MOB, MMO), Blade Flurry op 32 (MOB, MMO), Adrenaline Rush op 42 (MOB, MMO).

### Beginner mistakes
- Blade Flurry aanzetten naast een vijand die je met Sap, Gouge of Blind hebt uitgeschakeld. De extra slagen maken hem wakker. GEMETEN: CWF-C ("Keep it away from a target you've Gouged or Sapped").
- Riposte indrukken als er niets gepareerd is. Hij werkt alleen vlak na een parry. GEMETEN: DB2-beschrijving ("becomes active after parrying an opponent's attack").
- Backstab of Ambush met een zwaard, bijl of knots. Beide hebben een dolk in de hoofdhand nodig. GEMETEN: DB2; HTP r. 233.
- Punten in Hack and Slash zetten zonder naar je wapens te kijken. De bonus hangt af van het soort wapen. GEMETEN: DB2-beschrijving; CWF-C ("Pick your main weapons before you spend them").
- Blade Flurry en Adrenaline Rush bewaren en nooit gebruiken. GEMETEN: MOB ("making sure we use our Blade Flurry as often as possible"); IV-C ("using this ability on cooldown").
- Een snel wapen in de hoofdhand. Gidsen: langzaam in de hoofdhand, snel in de andere hand. GEMETEN: CWF-C, MOB.
- Van vijand wisselen met combo points op de oude. GEMETEN: CWF-C, IV-C.

---

## 5. Rol: Subtlety (band 3)

**Voorgestelde title:** `Subtlety: strike from Stealth`

### Intro-feiten
- Deze boom vecht vanuit Stealth: een sterke eerste slag, veel combo points al vóór het gevecht. GEMETEN: CWF-S ("Subtlety fights from Stealth: Ambush and Cheap Shot open, Premeditation and Initiative give you most of your Combo Points before the first hit"); POL ("suits stealth openers").
- Alleen levelen gaat langzamer dan met Combat. GEMETEN in gidsen: POL ("slower solo"); MOB ("Low kill speed and heavy reliance on talent points"); WFA ("a slower start for solo play"). MOB noemt wel "Good PvP capability while levelling".
- Hemorrhage (level 30 op zijn vroegst) is volgens IV-S de hoofdreden om Subtlety te levelen: goedkoop, van voren, met elk wapen. GEMETEN: IV-S; DB2 (35 Energy, geen positie-eis in de beschrijving, `SpellEquippedItems` = alle slagwapens).
- Het hoofdtalent Death Mark komt op zijn vroegst op level 40. GEMETEN: DB2 (rij 7, 30 nodig, `SpellLevels` 40). Death Mark is nieuw sinds 2 nov 2026 (CWF-K).
- Ambush en Backstab hebben een dolk in de hoofdhand nodig; Hemorrhage en Ghostly Strike niet. GEMETEN: DB2 `SpellEquippedItems` (32768 tegenover 173555).

### Simple order (toetsen: GEMETEN in BLOCK; volgorde samengevoegd uit CWF-S, IV-S, WT = AFGELEID)
1. Stealth (**Shift-R**). Staat er een tweede Humanoid bij: Sap (**Shift-Q**). Sap breekt Stealth niet. — CWF-S; DB2.
2. Premeditation (**Shift-C**, vanaf 20): 2 combo points op de vijand. Daarna de eerste slag. — CWF-S, IV-S.
3. Eerste slag van achteren: Ambush (**2**, vanaf 18, dolk in de hoofdhand). Op een sterke vijand vanaf 26: Cheap Shot (**V**), een stun van 4 seconden. — CWF-S, IV-S. (WT's tweede build opent met Garrote, **1**.)
4. Ghostly Strike (**Shift-X**, vanaf 25) en Shank (**Shift-3**, vanaf 24) elke keer dat ze klaar zijn. — IV-S, WT.
5. Combo points maken: vanaf 30 Hemorrhage (**3**). Daarvoor: Backstab (**2**) als je achter de vijand staat, anders Sinister Strike (**1**). — IV-S, CWF-S.
6. Finisher: Eviscerate (**4**) als de vijand bijna dood is; Rupture (**5**) op een vijand die lang leeft; Slice and Dice (**Shift-4**) op een lang gevecht. — CWF-S, IV-S.
7. Vanaf 40: Death Mark (**Q**) op de sterkste vijand, het liefst terwijl Rupture of Garrote loopt. — CWF-S; DB2 (Garrote en Rupture tellen dubbel).
8. Nood: Vanish (**X**). Preparation (**F3**, vanaf 30) maakt Vanish, Evasion en Sprint meteen weer klaar. — CWF-S, IV-S; DB2.

**Let op, voor mh-writer:** IV-S en CWF-S raden aan om na Ghostly Strike nog een Ambush of Garrote te doen (7 seconden lang kan dat
zonder Stealth). **Met MH's toetsen kan dat niet via 1 en 2**: buiten Stealth geven die toetsen Sinister Strike en Backstab. GEMETEN:
BLOCK r. 21, 27, 29-30 (`[bonusbar:1]` / `[nobonusbar:1]`); HTP r. 238 zegt het al tegen de speler. Schrijf dus niet "press 2 for Ambush
after Ghostly Strike".

### Per 10 levels
- **10**: Sinister Strike (**1**), Eviscerate (**4**), Backstab (**2**), Stealth (**Shift-R**), Gouge (**Shift-Q**), Evasion (**Z**) heb je al. Nieuw op 10: Sap (**Shift-Q** in Stealth), Slice and Dice (**Shift-4**), Sprint (**R**), een wapen in elke hand. Eerste talentpunt. Daarna Kick (**E**) op 12, Garrote (**1** in Stealth) op 14, Feint (**F**) op 16, Ambush (**2** in Stealth) en Poised (passief) op 18.
- **20**: Premeditation (**Shift-C**, talent): 2 combo points op je doelwit; gebruik ze binnen 20 seconden, anders zijn ze weg; cooldown 2 minuten (DB2 spell 14183). Rupture (**5**) en Poisons (quest) op 20. Daarna Vanish (**X**) op 22, Shank (**Shift-3**) op 24. Ghostly Strike (**Shift-X**, talent) op 25: 40 Energy, cooldown 20 seconden, 1 combo point, 7 seconden lang 15% meer dodge (DB2 spell 14278). Cheap Shot (**V** in Stealth) op 26.
- **30**: Hemorrhage (**3**, talent; eist Serrated Blades): 35 Energy, 1 combo point, werkt van voren; de vijand krijgt 15 seconden lang 15% meer schade van jouw Rupture en Garrote (DB2 spell 16511). Preparation (**F3**, talent): maakt de cooldown van je andere Rogue-spells meteen klaar; eigen cooldown 10 minuten (DB2 spell 14185). Kidney Shot (**V**) op 30. Daarna Blind (**Shift-V**) op 34. Boot Knife (talent, passief) op 35: Shank geeft met 20 / 40 / 60 / 80 / 100% kans 2 combo points (DB2 curve 83008).
- **40**: Death Mark (**Q**, talent; eist Preparation): een finisher, 25 Energy, cooldown 10 seconden. Hij bewaart 6 seconden lang een deel van je schade (meer per combo point) en deelt die daarna in één keer uit, tot een maximum. Schade van Rupture en Garrote telt dubbel (DB2 spell 1316709). Daarna Slice and Dice rang 2 en Vanish rang 2 op 42, Shank rang 2 op 44, Death Mark rang 2 op 48 (trainer, TRN r. 957).
- **50**: Kidney Shot rang 2 op 50, Death Mark rang 3 op 56 (TRN r. 973); niets nieuws voor deze rol.
- **60**: Death Mark rang 4 (TRN r. 981) en sterkere rangen; niets nieuws voor deze rol.

Hemorrhage en Preparation hebben allebei 20 punten in Subtlety nodig. Op level 30 heb je 21 punten: één van de twee op 30, de
andere op 31. AFGELEID (1 punt per level vanaf 10). Gidsen: CWF-S neemt Hemorrhage op 30 en Preparation op 31.
Premeditation is 20 op zijn vroegst (MAC r. 421 zegt ook 20); CWF-S neemt het pas op 24, POL op 26.

Passieve talenten die een schrijver mag noemen (GEMETEN: DB2 `CurvePoint`, build 70938):
Opportunity: Backstab, Garrote, Ambush en Mutilate 4-20% sterker; Improved Ambush +15 / 30 / 45% crit op Ambush; Camouflage: in
Stealth 5 / 10 / 15% minder traag, Stealth 2 / 4 / 6 seconden eerder terug; Initiative 33 / 67 / 100% kans op een extra combo point
bij Ambush, Garrote en Cheap Shot; Serrated Blades: negeert 3 / 6 / 9% armor, Rupture 10 / 20 / 30% sterker; Dirty Deeds: Cheap Shot
en Garrote 10 / 20 Energy goedkoper en Garrote mag ook van voren; Elusiveness: Vanish en Blind 45 / 90 seconden eerder terug;
Dirty Tricks: Sap en Blind 25 / 50% goedkoper; Quick Getaway: één doelwit meer in Sap, en 15 / 30% sneller lopen, 3 seconden lang, na een Sap.

### Beginner mistakes
- Ambush of Backstab zonder dolk in de hoofdhand, of van voren. GEMETEN: DB2; HTP r. 233.
- Na Ghostly Strike op 1 of 2 drukken voor Garrote of Ambush. Buiten Stealth geven MH's toetsen daar Sinister Strike en Backstab. GEMETEN: HTP r. 238; BLOCK.
- Premeditation gebruiken en dan wachten. De 2 punten zijn na 20 seconden weg, en de cooldown is 2 minuten. GEMETEN: DB2. CWF-S: bewaar het voor sterke vijanden.
- Preparation gebruiken terwijl er niets op cooldown staat. Eigen cooldown 10 minuten. GEMETEN: DB2; IV-S ("a button you will hopefully never have to use").
- Death Mark zonder combo points. Het is een finisher. GEMETEN: DB2-beschrijving ("Finishing move").
- Rupture op een vijand die bijna dood is. GEMETEN: CWF-S ("Pack enemies die before a bleed pays off"); IV-S.
- Een vijand slaan die in Sap of Blind staat. Schade maakt hem wakker. GEMETEN: DB2-beschrijvingen; HTP r. 234.
- Vanish terwijl er nog een bleed of gif op jóú tikt. Dat breekt je Stealth meteen weer. GEMETEN: CWF-A.
- In een groep meteen alles geven. Wacht tot de tank de vijand heeft; anders valt de vijand jou aan. GEMETEN: IV-S. Feint (**F**) verlaagt je threat (DB2; HTP r. 224).

---

## 6. Gidsen oneens

1. **Welke boom om mee te levelen.** MOB: Combat "by far" de beste. WFA en POL: Combat is de gewone keuze. WT: Assassination "generally not recommended as a starter build". IV en CWF kiezen niet. IV-S raadt Subtlety aan om Hemorrhage (30). → Schrijf geen "beste boom" als feit; "the guides call Combat the easiest to level alone" kan wel (3 gidsen).
2. **Slice and Dice of Eviscerate.** MOB: tot level 42 Eviscerate, pas na Slice and Dice rang 2 (42) Slice and Dice bijhouden. WT: Slice and Dice "ASAP". CWF: op lange gevechten eerst 2-3 punten in Slice and Dice, dan Eviscerate bij 5. IV-A/IV-C: Slice and Dice als de vijanden lang genoeg leven, anders Eviscerate bij 5. IV-S: Slice and Dice is "go-to", vanaf 30 Rupture.
3. **Wanneer Shank.** CWF en IV: elke keer dat hij klaar is. MOB: "when below 60 energy".
4. **Hoe openen als Subtlety.** IV-S en WT (Ambush-build): altijd Ambush. CWF-S: Premeditation en dan Cheap Shot vanaf 26 (5 punten vóór de eerste slag). WT (bleed-build): Garrote.
5. **Welk wapen als Subtlety.** CWF-S en WM: dolk in de hoofdhand. IV-S: een langzaam wapen voor Sinister Strike en een dolk voor Ambush, met een wissel-macro.
6. **Hemorrhage en het wapen.** IV-S: "will deal the same damage no matter the weapon type". DB2 (GEMETEN, spell 16511): 100% wapenschade, 145% met een dolk. Niet in het spel nagemeten wat dat netto doet.
7. **Level van Mutilate.** DB2: 30 punten nodig = level 40. POL zegt 30 (build 70450, van vóór 2 nov). IV-A zegt bij "Strengths" "Massive Level 30 power spike with Mutilate", en verderop op dezelfde pagina "Level 40". → 40.
8. **Levels van Riposte / Blade Flurry / Adrenaline Rush / Premeditation.** Zie de rollen: vroegst 20 / 30 / 40 / 20; gidsen nemen ze 0-6 levels later.
9. **Premeditation en Stealth.** CWF-S ("from stealth") en IV-S ("can be used from Stealth"). DB2 (GEMETEN, build 70938): Premeditation heeft géén Stealth-masker in `SpellShapeshift` (0) en geen "alleen in Stealth"-vlag (`Attributes_0` 327696), terwijl Garrote, Ambush, Cheap Shot en Sap die in dezelfde uitvoer wél hebben (masker 536870912). Dat het dus ook buiten Stealth werkt is AFGELEID en niet in het spel getest. → De stap "Premeditation, dan openen" klopt in beide gevallen; schrijf er geen "only in Stealth" of "also outside Stealth" bij.
10. **Opener als Assassination.** IV-A: Cheap Shot of Garrote. WT: Ambush. CWF-A: Ambush met dolk, anders Garrote; Cheap Shot op een sterke vijand.

---

## 7. Niet noemen (oude namen die niet meer in de boom staan)

GEMETEN: geen van deze namen staat tussen de 54 talenten van boom 1111 in build 70938 (de dump toont wél de nieuwe namen ernaast,
dus de zoekactie werkte).

| Oude naam | Waar hij nog staat | Nu |
|---|---|---|
| Improved Sinister Strike | POL, IV-C, IV-S, WT (mijlpaaltabel) | heet **Efficient Strikes** |
| Improved Eviscerate | POL, WT (mijlpaaltabel) | heet **Coup de Grace** |
| Murder | POL | weg (CWF-K: "Murder is gone") |
| Quietus | POL | weg |
| Thousand Cuts | POL, WM, IV rogue-class-overview | weg; **Death Mark** is nu het 31-punts talent |
| Cutthroat | WM, IV rogue-class-overview | weg |
| Improved Distract | (CWF noemt hem als verdwenen) | weg |
| Sword / Dagger / Mace / Fist Weapon Specialization | klassieke gidsen | samen **Hack and Slash** (CWF-K, WFA) |
| Improved Sap | klassieke gidsen | heet **Dirty Tricks** (CWF-K) en doet iets anders |

Ook niet overnemen:
- "Venom is the capstone: a finisher" (POL). GEMETEN in DB2: Venom is passief, rij 5.
- "Mutilate at 30" (POL, één regel in IV-A). GEMETEN in DB2: rij 7, level 40.
- Lethality / Seal Fate / Dual Wield Specialization / Camouflage met 5 rangen (POL). GEMETEN in DB2: 2 / 3 / 2 / 3 rangen.
- "Mutilate 75% weapon damage" (van vóór 2 nov). GEMETEN in DB2: 90%.

---

## 8. Niet gemeten

- **Niets is in het spel getest.** Alles onder DB2 komt uit Blizzards tabellen (build 70938), niet uit een draaiende client.
- **Wowhead Forever-gidsen**: de tekst kwam niet door (alleen titel; de Combat-pagina meldt "updated 2026/11/06", auteur warstry). Geen browser gebruikt. Wat Wowhead over volgorde en fouten zegt is dus onbekend.
- **Death Mark: hoeveel procent hij bewaart.** De DB2-beschrijving gebruikt een variabele (`$<ratio>`) die niet in de cache zit. CWF zegt 12% per combo point (60% bij 5); dat is GEMETEN in een gids, niet in DB2.
- **Moet je voor Mutilate achter de vijand staan?** De DB2-beschrijving noemt het niet (Backstab en Ambush noemen het wel). Dat het dus niet hoeft is AFGELEID.
- **Premeditation buiten Stealth** (zie "Gidsen oneens" punt 9).
- **Vol-rang-eis bij "eist X"**: alleen uit een gids (CWF).
- **Talented-perk** en **51 punten**: alleen uit gidsen.
- **Flash Powder / Blinding Powder** als kosten: uit HTP en gidsen, niet in DB2 nagekeken in deze ronde.
- **Welke vijanden immuun zijn voor gif**, en vanaf welk level de Poisons-quest per ras precies kan.
- **Energy 10 per seconde**: uit gidsen en HTP.
- **Eenhandige bijlen voor Rogues**: uit gidsen.
- **De volgorde in "Simple order"** is door mij samengevoegd uit meerdere gidsen (AFGELEID); geen enkele gids geeft precies deze lijst, en geen gids kent MH's toetsen.
- **WT heeft geen datum**; de talentnamen daar zijn grotendeels van na 2 nov (Composure, Flash of Steel, Death Mark), maar de mijlpaaltabel gebruikt nog twee oude namen.

## 9. Kort voor mh-writer

- Band 1 = Assassination, 2 = Combat, 3 = Subtlety.
- Toetsen alleen uit BLOCK: 1 / 2 / 3 / 4 / 5, Shift-1 (Blade Flurry), Shift-3 (Shank), Shift-4 (Slice and Dice), Q (Adrenaline Rush of Death Mark), F1 (Cold Blood), F3 (Preparation), Shift-F1 (Riposte), Shift-C (Premeditation), Shift-X (Ghostly Strike), V (Kidney Shot; in Stealth Cheap Shot), Shift-Q (Gouge; in Stealth Sap), E, R, Shift-R, Z, X, F, Shift-Z, Shift-F, Shift-V.
- Toets **3** is Mutilate én Hemorrhage (BLOCK r. 31); toets **Q** is Adrenaline Rush én Death Mark (BLOCK r. 38).
- Venom, Poised, Seal Fate, Hack and Slash, Flash of Steel, Boot Knife, Flawless Execution: passief, geen toets.
- Zin uit de Druid-tekst die hier ook past: "Talent levels here are the earliest; a perk can bring them up to 5 levels sooner."
- Niet schrijven: Ambush/Garrote via 1 of 2 na Ghostly Strike; "best spec"; "only in Stealth" bij Premeditation; oude talentnamen uit hoofdstuk 7.
