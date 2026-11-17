# Warrior per rol — feiten voor "How you play" (WoW Forever)

**Datum:** 17 nov 2026 · **Build:** wowf 1.60.1.70938 · **Door:** mh-research (alleen lezen; dit bestand is de enige uitvoer).
**Doel:** feiten voor mh-writer, zodat die `ROLES.WARRIOR` kan schrijven in de vorm van `ROLES.DRUID`
(`Modules/ForeverHowToPlay.lua` r. 373-452): per rol `band`, `title`, en een body met **Simple order**, **Per 10 levels**
(10, 20, 30, 40, 50, 60) en **Beginner mistakes**.

**Leeswijzer.** Achter elke bewering staat **GEMETEN** (gezien in een genoemde bron) of **AFGELEID** (beredeneerd).
"DB2" = Blizzards tabellen van build 1.60.1.70938, gelezen uit de lokale cache
`%LOCALAPPDATA%\MidnightHelper\gamedata_cache\db2\1.60.1.70938\` en via `run gamedata …`.
Dat 70938 de nieuwste Forever-build is: GEMETEN, `run gamedata builds` op 17 nov 2026 (`wowf 1.60.1.70938, 2026-11-13`).

**Niet gelezen:** `docs/forever/DRUID_ROLES_2026-11-16.md`. Mijn eigen agentregel verbiedt lezen onder `docs/`. De vorm
komt daarom uit `ROLES.DRUID` in de code zelf. Kan de indeling dus iets afwijken van het druid-onderzoek.

---

## 0. Kort

| Rol | Boom | `band` | Wapen | Vanaf |
|---|---|---|---|---|
| Tank | Protection | 3 | eenhandig wapen + schild | level 10 (Defensive Stance, quest) |
| Damage, tweehandig | Arms | 1 | één groot wapen | level 1 |
| Damage, twee wapens | Fury | 2 | wapen in elke hand | level 20 (Dual Wield bij de trainer) |

- De boom is **TraitTree 1117** (53 talenten, 3 banden, 7 rijen). GEMETEN in DB2.
- Welke boom bij welke rol hoort is GEMETEN aan de wapen-eis van de talenten zelf (§2.4), en de gidsen zeggen hetzelfde.
- Vroegste talent-levels: rij 1-7 = level 10, 15, 20, 25, 30, 35, 40. De twee bouwstenen zijn GEMETEN, de som is AFGELEID (§2.2).
- De gidsen zijn het **oneens** over welke boom het snelst levelt (§8). Dat hoort in de tekst, niet een keuze van ons.

---

## 1. Bronnen

| Bron | Wat | Datum |
|---|---|---|
| DB2 wowf 1.60.1.70938 | `TraitTree`, `TraitNode`, `TraitNodeXTraitNodeEntry`, `TraitNodeEntry`, `TraitDefinition`, `TraitNodeGroupXTraitNode`, `TraitNodeGroupXTraitCond`, `TraitCond`, `TraitEdge`, `TraitCurrencySource`, `TraitTreeXTraitCurrency`, `TraitCurrency`, `TalentTab`, `SpellName`, `Spell`, `SpellLevels`, `SpellCooldowns`, `SpellPower`, `SpellMisc`, `SpellCastTimes`, `SpellDuration`, `SpellShapeshift`, `SpellEquippedItems`, `SpellEffect`, `SkillLineAbility`, `SpellAuraOptions`, `SpellTargetRestrictions` | build van 13 nov 2026 |
| `Modules/ForeverBlock_Warrior.lua` r. 20-66 | MH's vaste toetsenblok (welke toets, per stance) | gelezen 17 nov |
| `Modules/ForeverHowToPlay.lua` r. 157-196 | bestaande `CLASSES.WARRIOR`-tekst | gelezen 17 nov |
| `Modules/ForeverMacros.lua` r. 384-405, 671-675 | `SPEC_MACROS` (talent-levels), `TREE.WARRIOR = 1117` | gelezen 17 nov |
| `Modules/ForeverTrainerData.lua` r. 1304-1406 | trainer-spells met level (bron: What's Training?, Camelot-data, MIT) | gelezen 17 nov |
| `Modules/ForeverClassQuests.lua` r. 476-484, 534-564 | stance-quests level 10 en 30 | gelezen 17 nov |
| Icy Veins Forever, Abide — Arms / Fury / Protection leveling | `icy-veins.com/wow-forever/arms-warrior-leveling`, `…/fury-warrior-leveling`, `…/protection-warrior-leveling` | bijgewerkt 4 nov 2026 |
| Wowhead Forever — Arms leveling (shoop) | `wowhead.com/forever/guide/classes/warrior/arms/dps-leveling-tips` | bijgewerkt 15 nov 2026 |
| Wowhead Forever — Protection leveling (Riyani) | `wowhead.com/forever/guide/classes/warrior/protection/tank-leveling-tips` | bijgewerkt 6 nov 2026 |
| polestar.guide — Warrior | `polestar.guide/guides/class/warrior` | Polestar 0.4.0, 16 nov 2026; plannen "checked on build 1.60.1.70450" |
| Mobalytics — Warrior Leveling 1-60 (Ahlaundoh) | `mobalytics.gg/wow-forever/classes/warrior-leveling-guide` | bijgewerkt 13 nov 2026 |
| Mobalytics — Fury 1-60 (Kargoz) | `mobalytics.gg/wow-forever/classes/1-60-fury-warrior-leveling-guide` | bijgewerkt 2 nov 2026 (vóór de launch) |
| Method — Warrior Leveling (Babyhoof) | `method.gg/wow-forever/wow-forever-warrior-leveling-guide-and-talents` | bijgewerkt 14 nov 2026 |
| Warcraft Tavern — Warrior Leveling (Passion) | `warcrafttavern.com/forever/guides/warrior-leveling/` | geen datum op de pagina; builds "designed for the Beta, capped at level 30" |
| wowforeverleveling.com — Fury vs Arms | `wowforeverleveling.com/guides/fury-vs-arms-warrior-wow-forever` | 4 nov, bijgewerkt 9 nov 2026 |
| wowforeverguides.com — Fury leveling (Harenil) | `wowforeverguides.com/leveling/warrior/fury` | 8 nov 2026 |

Niet gelukt: de Wowhead-pagina voor **Fury leveling** gaf alleen een titel terug (geen tekst). Niet gemeten dus.
Alle gidsen zijn gelezen via een zoek-/leesdienst (gewone fetch gaf 403); de tekst is die van de pagina, maar ik heb
de pagina's niet in een browser gezien. Blizzards eigen patch-notes zijn niet rechtstreeks gelezen: alleen via de gidsen.

---

## 2. De talentboom: TraitTree 1117

### 2.1 Hoe gemeten

GEMETEN (DB2, lokale cache; script in de scratchpad dat de CSV's koppelt):
`TraitNode` (TraitTreeID = 1117, 53 rijen) → `TraitNodeXTraitNodeEntry` → `TraitNodeEntry` (MaxRanks) →
`TraitDefinition` (SpellID) → `SpellName`; en `TraitNode` → `TraitNodeGroupXTraitNode` → `TraitNodeGroupXTraitCond` →
`TraitCond` (SpentAmountRequired); voorwaarden tussen talenten uit `TraitEdge`.

- Dat boom 1117 de warrior is: GEMETEN aan de inhoud (Mortal Strike 12294, Bloodthirst 23881, Shield Slam 23922 zitten
  erin). `TraitTree` zelf heeft geen class-kolom. `ForeverMacros.lua` r. 674 zegt ook `WARRIOR = 1117`.
- PosX-waarden: 1020-2820 (band 1), 5020-6820 (band 2), 9080-10880 (band 3). PosY: 2130, 2730, 3330, 3930, 4530, 5130,
  5730 = rij 1-7. GEMETEN. Dat klopt met de opmerking in `ForeverMacros.lua` r. 671-673.
- Positieve controle: mijn uitkomst (Spearing Strike 25, Sweeping Strikes 30, Death Wish 30, Mortal Strike / Bloodthirst
  / Shield Slam 40) is gelijk aan `SPEC_MACROS` (gemeten op build 70862) én aan de gidsen (Icy Veins, Mobalytics). Drie
  bronnen, los van elkaar.

### 2.2 De level-regel

- GEMETEN, `TraitTreeXTraitCurrency` rij 4695: boom 1117 gebruikt currency **3820**.
- GEMETEN, `TraitCurrencySource`: currency 3820 geeft **1 punt per level, van "Level 10" t/m "Level 60"** (rijen
  36242-36292). `TraitCurrency` 3820: `SourcedMax = 51`. Dus punt N komt op level 9 + N.
- GEMETEN, `TraitCond` (18 rijen voor boom 1117): elke rij van een band eist punten **in de rijen erboven van dezelfde
  band**: 5, 10, 15, 20, 25, 30 (rij 2 t/m 7). Rij 1 heeft geen eis.
- AFGELEID: een talent met eis S kan op zijn vroegst als punt S + 1 = **level 10 + S**. Dat is "op zijn vroegst": alleen
  als je al je punten in die ene boom zet.
- GEMETEN, `TraitCurrencySource` rijen 37163-37167 + spell 1225474 **Talented** ("You gain talent points every level
  starting at level $s1 instead of starting at level 10, but you still may not have more than 51 total talent points"):
  een perk (node 110298 in boom 1188, 5 rangen: level 9, 8, 7, 6, 5). Dus **talenten kunnen tot 5 levels eerder**.
  Warcraft Tavern ("Talented from the Legacy system … up to 5 levels sooner") en Wowhead (Protection, "Legacy Points")
  zeggen hetzelfde. `ROLES.DRUID` gebruikt hiervoor de zin "a perk can bring them up to 5 levels sooner".
- NIET GEMETEN: of het spel een talent-spell met een eigen level (Mortal Strike, Bloodthirst, Shield Slam hebben
  `SpellLevels.BaseLevel = 40`) met de perk echt eerder geeft. Wowhead (Arms) schrijft "Getting Mortal Strike as early
  as possible" bij Talented; dat is een gids, geen meting in de client.

### 2.3 De boom, per band

"Level" = vroegste level zonder perk (AFGELEID uit §2.2). Tussen haakjes: spell-id · aantal rangen. Alles GEMETEN in DB2.

**Band 1 — Arms** (17 talenten)

| Rij | Punten nodig | Level | Talenten |
|---|---|---|---|
| 1 | 0 | 10 | Improved Heroic Strike (12282 · 3), Deflection (16462 · 5), Improved Rend (12286 · 3) |
| 2 | 5 | 15 | Improved Charge (12285 · 2), Improved Tactical Mastery (12295 · 3), Improved Overpower (12290 · 2) |
| 3 | 10 | 20 | Anger Management (12296 · 1; eist Improved Tactical Mastery), Deep Wounds (12834 · 3; eist Improved Rend) |
| 4 | 15 | 25 | **Spearing Strike** (1310222 · 1), Two-Handed Weapon Specialization (12163 · 3), Impale (16493 · 2; eist Deep Wounds) |
| 5 | 20 | 30 | Bloodthrill (1289682 · 2), **Sweeping Strikes** (12292 · 1), Weaponmaster (1290261 · 5) |
| 6 | 25 | 35 | Improved Slam (12862 · 2), Improved Hamstring (12289 · 3) |
| 7 | 30 | 40 | **Mortal Strike** (12294 · 1; eist Sweeping Strikes) |

**Band 2 — Fury** (18 talenten)

| Rij | Punten nodig | Level | Talenten |
|---|---|---|---|
| 1 | 0 | 10 | Booming Voice (12321 · 5), Cruelty (12320 · 5) |
| 2 | 5 | 15 | Lingering Rage (1323964 · 5), Unbridled Wrath (12322 · 5) |
| 3 | 10 | 20 | Furious Precision (1323963 · 3), **Piercing Howl** (12323 · 1), Blood Craze (16487 · 3), Enrage (12317 · 5) |
| 4 | 15 | 25 | Dual Wield Specialization (23584 · 5), **Reckless Swings** (1329555 · 1), Improved Execute (20502 · 2) |
| 5 | 20 | 30 | Improved Berserker Rage (20500 · 2), **Death Wish** (12328 · 1), Gore Drinker (1323967 · 2; eist Blood Craze), Improved Intercept (20504 · 2) |
| 6 | 25 | 35 | Improved Whirlwind (1310315 · 2), Flurry (12319 · 3) |
| 7 | 30 | 40 | **Bloodthirst** (23881 · 1; eist Death Wish) |

**Band 3 — Protection** (18 talenten)

| Rij | Punten nodig | Level | Talenten |
|---|---|---|---|
| 1 | 0 | 10 | Improved Bloodrage (12301 · 2), Shield Specialization (12298 · 5), Iron Will (12962 · 5) |
| 2 | 5 | 15 | Anticipation (12297 · 5), Improved Revenge (12797 · 3), Improved Thunder Clap (12287 · 3) |
| 3 | 10 | 20 | **Last Stand** (12975 · 1), Master of Defense (1310316 · 2; eist Shield Specialization), Improved Disarm (12313 · 3), Defiance (12792 · 3) |
| 4 | 15 | 25 | Improved Sunder Armor (12308 · 3), **Vanguard** (1310317 · 1), Improved Shield Bash (12311 · 2) |
| 5 | 20 | 30 | Improved Shield Wall (12312 · 2), **Concussion Blow** (12809 · 1), Focused Rage (29787 · 3) |
| 6 | 25 | 35 | Bastion (16538 · 5) |
| 7 | 30 | 40 | **Shield Slam** (23922 · 1; eist Concussion Blow) |

Vet = een talent dat een toets krijgt (Vanguard is passief, maar verandert wat **R** doet). De keten voor die elf
(definitie → node → groep → cond):

| Talent | TraitDefinition | TraitNode | Groep | TraitCond | SpentAmountRequired |
|---|---|---|---|---|---|
| Spearing Strike | 135480 | 105949 | 11647 | 43518 | 15 |
| Sweeping Strikes | 135476 | 105945 | 11646 | 43517 | 20 |
| Mortal Strike | 135472 | 105941 | 11644 | 43515 | 30 |
| Piercing Howl | 135466 | 105935 | 11662 | 43531 | 10 |
| Reckless Swings | 145966 | 113636 | 11661 | 43530 | 15 |
| Death Wish | 135458 | 105927 | 11660 | 43529 | 20 |
| Bloodthirst | 135461 | 105930 | 11658 | 43527 | 30 |
| Last Stand | 135501 | 105970 | 11668 | 43537 | 10 |
| Vanguard | 135497 | 105966 | 11667 | 43536 | 15 |
| Concussion Blow | 135496 | 105965 | 11666 | 43535 | 20 |
| Shield Slam | 135490 | 105959 | 11664 | 43533 | 30 |

- GEMETEN, met positieve controle: **"Raging Blows" bestaat niet in `SpellName` van build 70938** (dezelfde grep vond
  wel "Improved Cleave" 12329). Het zit ook niet in de 53 nodes. Gidsen die het noemen (Kargoz, Warcraft Tavern,
  wowforeverleveling) zijn op dat punt verouderd; wowforeverguides zegt zelf ook dat het weg is.
- De namen "Arms / Fury / Protection" bij band 1 / 2 / 3: `TalentTab` (ClassMask 1) geeft Arms OrderIndex 0, Fury 1,
  Protection 2 — GEMETEN. Dat band 1 = OrderIndex 0 enz. is AFGELEID uit de inhoud (Mortal Strike, Bloodthirst, Shield
  Slam). `SPEC_NAMES.WARRIOR` in `ForeverMacros.lua` r. 588-596 gebruikt dezelfde volgorde.

### 2.4 Welke boom bij welke rol

GEMETEN in DB2 `SpellEquippedItems` (wat een talent eist dat je vasthoudt):

- **Band 1 (Arms):** Two-Handed Weapon Specialization (12163) eist item-class 2 (wapen), subclass-masker 136546. Dat
  masker is: tweehandige bijl, tweehandige mace, polearm, tweehandig zwaard, staff, spear (de decodering van de bits is
  AFGELEID uit Blizzards vaste subclass-nummers). → **één groot wapen**.
- **Band 2 (Fury):** Dual Wield Specialization (23584) en Furious Precision (1323963) eisen
  `EquippedItemInvTypes = 4194304` = bit 22 = wapen in de **off-hand** (decodering AFGELEID). → **twee wapens**.
- **Band 3 (Protection):** Shield Slam (23922), Bastion (16538) en Defiance (12792) eisen item-class 4, subclass-masker
  64 = **schild** (decodering AFGELEID). Defiance werkt alleen in Defensive Stance (`SpellShapeshift` masker 131072). → **tank**.

GEMETEN in de gidsen, alle eens: Mobalytics ("If you want to play with a two-hander, Arms… dual-wield, Fury… a shield,
Protection"), Icy Veins (Arms = two handed weapon, Fury = two weapons, Protection = weapon and shield), polestar,
wowforeverleveling. `ForeverDirection.lua` r. 156-162 (`GUIDE.WARRIOR`) heeft dezelfde indeling al.

Dual Wield zelf (spell 674): **bij de trainer op level 20** — GEMETEN in `ForeverTrainerData.lua` r. 1326, Warcraft
Tavern (mijlpalen-tabel), Icy Veins Fury ("Train dual wielding at Level 20").

---

## 3. Toetsen (MH's vaste toetsenblok)

GEMETEN in `Modules/ForeverBlock_Warrior.lua` r. 26-63. Leeg = die toets doet niets in die stance.

| Toets | Battle Stance | Defensive Stance | Berserker Stance |
|---|---|---|---|
| **1** | Heroic Strike | Heroic Strike | Heroic Strike |
| **2** | Overpower | Revenge | Whirlwind |
| **3** | Mortal Strike / Bloodthirst / Shield Slam | idem | idem |
| **4** | Execute | — | Execute |
| **5** | Sunder Armor | Sunder Armor | Sunder Armor |
| **Shift-1** | Thunder Clap | Thunder Clap | — |
| **Shift-2** | Demoralizing Shout | idem | idem |
| **Shift-3** | Death Wish | idem | idem |
| **Shift-4** | Cleave | idem | idem |
| **Q** | Sweeping Strikes | — | Recklessness |
| **E** | Shield Bash | Shield Bash | Pummel |
| **R** | Charge | Charge (alleen met Vanguard) | Intercept |
| **F** | Mocking Blow | Taunt | — |
| **Z** | — | Shield Block | — |
| **X** | Last Stand | idem | idem |
| **C** | Retaliation | Shield Wall | — |
| **V** | Hamstring | Disarm | Hamstring |
| **F1** | Bloodrage | idem | idem |
| **F2** | Victory Rush | idem | idem |
| **F3** | Spearing Strike | — | — |
| **Shift-Q** | Intimidating Shout | idem | idem |
| **Shift-F** | Challenging Shout | idem | idem |
| **Shift-R** | Piercing Howl | idem | idem |
| **Shift-F1** | Reckless Swings | idem | idem |
| **Shift-Z** | Rend | Rend | — |
| **Shift-X** | Battle Shout | idem | idem |
| **Shift-C** | Slam | idem | idem |
| **Shift-V** | Concussion Blow | Concussion Blow | Berserker Rage |
| **Ctrl-1 / Ctrl-2 / Ctrl-3** | Battle / Defensive / Berserker Stance | | |
| **Shift-E** | race-spell | | |
| blok D (eigen Alt-toetsen) | Shoot Bow / Gun / Crossbow, Throw | | |

De stance-verdeling in het blok klopt met DB2 `SpellShapeshift` (§4). GEMETEN voor elke rij hierboven die in §4 staat.
Eén bewuste afwijking: Concussion Blow werkt volgens DB2 in elke stance, maar in Berserker Stance staat op **Shift-V**
Berserker Rage (keuze van het blok, geen fout).

---

## 4. Spell-feiten uit DB2

Alles GEMETEN in DB2 1.60.1.70938, tenzij er AFGELEID bij staat. Rage = `SpellPower.ManaCost / 10`. Cooldown =
`SpellCooldowns` (ms). Stance = `SpellShapeshift.ShapeshiftMask_0`: 65536 = Battle, 131072 = Defensive, 262144 =
Berserker (AFGELEID: bit = vormnummer − 1; de stance-spells 2457 / 71 / 2458 hebben vorm 17 / 18 / 19 in `SpellEffect`).
"Trainer" = level uit `ForeverTrainerData.lua`; dat level is gelijk aan `SpellLevels.BaseLevel` in elke rij waar DB2
er een heeft (Dual Wield 674 en Plate Mail 750 hebben geen `SpellLevels`-rij: daar is de trainer-data de enige bron).

### 4.1 Voor iedereen

| Spell | Id | Level, bron | Stance | Rage | Cooldown | Wat (DB2) |
|---|---|---|---|---|---|---|
| Heroic Strike | 78 | 1, start | alle | 15 | — | op je volgende slag; "high amount of threat" |
| Battle Shout | 6673 | 1, trainer | alle | 10 | — | buff, duurt 3 minuten (180000 ms) |
| Charge | 100 | 4, trainer | Battle | 0 | 15 s | "Cannot be used in combat"; geeft 9 Rage (rang 2 op 26: 12); stun 1 s |
| Rend | 772 | 4, trainer | Battle + Defensive | 10 | — | bleed, 9 s (rang 1) |
| Thunder Clap | 6343 | 6, trainer | Battle + Defensive | 20 | 6 s | max **4** vijanden (`SpellTargetRestrictions`); 20% trager aanvallen |
| Hamstring | 1715 | 8, trainer | Battle + Berserker | 10 | — | 40% trager lopen, 15 s |
| Bloodrage | 2687 | 10, trainer | alle | kost health | 60 s | 10 Rage direct + 10 in 10 s (spell 29131) |
| Defensive Stance | 71 | 10, quest | — | — | — | passief 7376: 10% minder damage krijgen, 10% minder damage doen, threat +80% (`SpellEffect` base 80) |
| Sunder Armor | 7386 | 10, quest | alle | 15 | — | stapelt 5× (`SpellAuraOptions.CumulativeAura`), 30 s; "high amount of threat" |
| Taunt | 355 | 10, quest | Defensive | 0 | 8 s | "has no effect if the target is already attacking you" |
| Overpower | 7384 | 12, trainer | Battle | 5 | 5 s | "Only useable after the target dodges" |
| Shield Bash | 72 | 12, trainer | Battle + Defensive | 10 | 12 s | **schild nodig**; interrupt, 6 s slot |
| Revenge | 6572 | 14, trainer | Defensive | 5 | 5 s | "must follow a block, dodge or parry"; "high amount of threat" |
| Demoralizing Shout | 1160 | 14, trainer | alle | 10 | — | vijanden slaan zwakker, 45 s |
| Tactical Mastery | 1310185 | 14, trainer | — | — | — | passief: "retain up to 10 Rage when you change Stances" |
| Mocking Blow | 694 | 16, trainer | Battle | 10 | 2 min | vijand valt jou 6 s aan |
| Shield Block | 2565 | 16, trainer | Defensive | 10 | 5 s | **schild nodig**; blokt **2** aanvallen (`ProcCharges`), 7 s |
| Disarm | 676 | 18, trainer | Defensive | 20 | 60 s | 10 s |
| Cleave | 845 | 20, trainer | alle | 20 | — | op je volgende slag; doel + 1 vijand ernaast |
| Dual Wield | 674 | 20, trainer | — | — | — | passief: wapen in de off-hand |
| Retaliation | 20230 | 20, trainer | Battle | 0 | 15 min | 15 s, max 30 tegenaanvallen |
| Slam | 1240193 | 20, trainer | alle | 15 | 15 s | **cast 1,5 s** |
| Victory Rush | 402927 | 20, trainer | alle | 0 | 30 s | heelt 10% van je max health; binnen 20 s (spell 402975) na het doden van een "non-trivial enemy" |
| Intimidating Shout | 5246 | 22, trainer | alle | 25 | 3 min | 8 s; tot 5 vijanden vluchten |
| Execute | 5308 | 24, trainer | Battle + Berserker | 15 | — | alleen bij 20% health of minder; gebruikt al je Rage |
| Challenging Shout | 1161 | 26, trainer | alle | 5 | 10 min | alle vijanden dichtbij vallen jou 6 s aan |
| Shield Wall | 871 | 28, trainer | Defensive | 0 | 15 min | **schild nodig**; 60% minder damage, 12 s |
| Berserker Stance | 2458 | 30, quest | — | — | — | passief 7381: +3% crit, +10% damage krijgen |
| Intercept | 20252 | 30, quest | Berserker | 10 | 30 s | charge ín een gevecht; stun 3 s |
| Berserker Rage | 18499 | 30, trainer | Berserker | 0 | 30 s | 10 s immuun voor Fear en Incapacitate; extra Rage als je geraakt wordt |
| Whirlwind | 1680 | 36, trainer | Berserker | 25 | 10 s | max **4** vijanden; "weapon damage from both melee weapons"; maar één rang |
| Pummel | 6552 | 38, trainer | Berserker | 10 | 10 s | interrupt, 4 s slot; geen schild nodig |
| Plate Mail | 750 | 40, trainer | — | — | — | plate dragen |
| Recklessness | 1719 | 50, trainer | Berserker | 0 | 30 min | 15 s: +100% crit, immuun voor Fear, +20% damage krijgen |

Bron van de quest-rijen: `ForeverClassQuests.lua` r. 476-479 (quest 8121 leert 71 + 7386 + 355; quest 8616 leert
2458 + 20252 — GEMETEN in DB2 door een eerder onderzoek, hier niet opnieuw gemeten) en de gidsen (Icy Veins, Method,
Warcraft Tavern: Defensive Stance + Taunt + Sunder Armor op 10; Berserker Stance + Intercept op 30, "The Affray").

### 4.2 Talent-spells met een toets

| Spell | Id | Vroegste level | Stance | Rage | Cooldown | Wat (DB2) |
|---|---|---|---|---|---|---|
| Spearing Strike | 1310222 | 25 | Battle | 15 | 20 s | 75% wapen-damage; nog eens 75% erbij tegen Giants, Dragonkin en vijanden op een mount; haalt ze van hun mount |
| Sweeping Strikes | 12292 | 30 | Battle | 30 | 30 s | je volgende **5** slagen (`ProcCharges`) raken ook een vijand ernaast; 20 s |
| Mortal Strike | 12294 | 40 | alle | 30 | 6 s | wapen-damage + bonus; doel krijgt 10 s 50% minder healing. Rangen: 48, 54, 60 |
| Piercing Howl | 12323 | 20 | alle | 10 | — | alle vijanden dichtbij 50% trager, 6 s |
| Reckless Swings | 1329555 | 25 | alle | kost health | 15 s | je volgende **4** slagen geven elk 5 Rage extra; 8 s |
| Death Wish | 12328 | 30 | alle | 10 | 3 min | 30 s: +20% physical damage, immuun voor Fear, **+5% damage krijgen** |
| Bloodthirst | 23881 | 40 | alle | 30 | 6 s | damage uit Attack Power; +10% loopsnelheid 10 s. **Heelt niet.** Rangen: 48, 54, 60 |
| Last Stand | 12975 | 20 | alle | 0 | 3 min | +30% max health voor 20 s; "After the effect expires, the health is lost" |
| Vanguard | 1310317 | 25 | — | — | — | passief: Charge werkt ook in Defensive Stance (vervangt Charge door 1240287, masker Battle + Defensive) |
| Concussion Blow | 12809 | 30 | alle | 10 | 45 s | stun 5 s |
| Shield Slam | 23922 | 40 | alle | 20 | 6 s | **schild nodig**; "very high amount of threat"; 50% kans 1 magie-effect weg te halen. Rangen: 48, 54, 60 |

- "Kost health": `SpellPower.PowerType = -2`, `PowerCostPct` 20 (Bloodrage) en 25 (Reckless Swings) — GEMETEN. Dat het
  bij Reckless Swings om 25% van je **base health** gaat (dus minder dan het lijkt) zeggen Icy Veins, wowforeverleveling
  en wowforeverguides; in DB2 niet te zien. Voor Bloodrage zegt Icy Veins alleen "costs some health".
- Vanguard: de vervang-Charge 1240287 heeft dezelfde `Attributes_0` als de gewone Charge; alleen de zin "Cannot be used
  in combat" ontbreekt in de tekst. Dat hij nog steeds **niet in een gevecht** werkt is AFGELEID uit die gelijke
  attributen, en GEMETEN in Icy Veins (Protection: "you still cannot Charge while already in combat").
- Heroic Strike en Cleave: `Attributes_0` wijkt 4 af van de andere aanvallen (de "volgende slag"-vlag; betekenis
  AFGELEID). Dat die slag dan **geen Rage** oplevert: GEMETEN in Icy Veins (alle drie) en Wowhead (Arms), niet in DB2.

### 4.3 Passieve talenten die in de tekst kunnen komen

Tekst GEMETEN in DB2 `Spell.Description_lang`. ⚠️ De **getallen** van talenten met meer rangen noem ik hier niet als
feit: DB2 heeft één spell per talent, en hoe het getal per rang oploopt is NIET GEMETEN (bij Cruelty is de DB2-waarde 5
de eindwaarde, bij Improved Rend is DB2 15 terwijl Icy Veins 35% noemt).

| Talent | Rij / level | Wat de client-tekst zegt |
|---|---|---|
| Shield Specialization | Prot 1 / 10 | meer blokkans; kans op 5 Rage als je blokt (spell 1310318) |
| Improved Revenge | Prot 2 / 15 | Revenge doet meer damage |
| Master of Defense | Prot 3 / 20 | kans op 5 Rage als je dodget of parryt met een schild (spell 23602) |
| Defiance | Prot 3 / 20 | meer threat in Defensive Stance met een schild |
| Focused Rage | Prot 5 / 30 | aanvallen kosten minder Rage |
| Bastion | Prot 6 / 35 | meer damage zolang je een schild draagt |
| Improved Tactical Mastery | Arms 2 / 15 | je houdt meer Rage bij een stance-wissel |
| Anger Management | Arms 3 / 20 | 1 Rage per 3 s in een gevecht; Rage loopt buiten een gevecht trager weg |
| Two-Handed Weapon Specialization | Arms 4 / 25 | meer damage met tweehandige wapens |
| Bloodthrill | Arms 5 / 30 | slagen met je main hand op een vijand met jouw Rend: kans dat Overpower mag |
| Weaponmaster | Arms 5 / 30 | bonus per wapensoort: axe/polearm crit, mace/staff negeert armor, sword kans op extra slag |
| Improved Slam | Arms 6 / 35 | Slam: kortere cooldown en cast, en hij "no longer interrupts or delays your melee swing" |
| Furious Precision | Fury 3 / 20 | off-hand raakt vaker |
| Dual Wield Specialization | Fury 4 / 25 | off-hand doet meer damage **en geeft meer Rage** |
| Gore Drinker | Fury 5 / 30 | na Enrage, Berserker Rage, Bloodrage, Death Wish, Reckless Swings of Bloodthirst geven je volgende slagen wat health terug |
| Improved Whirlwind | Fury 6 / 35 | Whirlwind: kortere cooldown, meer damage op de dichtstbijzijnde vijand |
| Flurry | Fury 6 / 35 | na een crit: je volgende 3 slagen (spell 12966) sneller |

---

## 5. Rol: Tank (Protection) — `band = 3`

**Voorstel title:** `Protection: tank`.

**Feiten voor de inleiding**

- Vanaf level 10: Defensive Stance komt uit een quest; dezelfde quest geeft Taunt en Sunder Armor. (§4.1)
- Je draagt een **eenhandig wapen en een schild**. Icy Veins (Protection): "using a 2-handed weapon early on until you
  learn Revenge" (level 14), daarna schild + eenhandig. GEMETEN in de gids.
- Wat een tank doet (uitleg voor de beginner): Icy Veins, FAQ "What Are Threat and Aggro?": threat = verborgen waarde
  die bepaalt wie een vijand aanvalt; "Each enemy tracks threat separately"; als tank moet je op **elke** vijand genoeg
  threat maken, anders loopt hij naar de healer. GEMETEN in de gids.
- Voor levelen in je eentje: de gidsen zijn het **oneens** (§8). Icy Veins noemt Protection de snelste en raadt hem aan;
  Wowhead (Protection) en Mobalytics zeggen iets vergelijkbaars; polestar zegt "slower alone".
- De Protection-boom "komt op gang" rond level 16 (Shield Block naast Revenge): Mobalytics, Wowhead (Protection),
  Icy Veins ("Slow start before Level 16"). GEMETEN in drie gidsen.

**Simple order (in een groep), met toetsen**

De volgorde komt uit Icy Veins (Protection, Single-Target + AoE Rotation) en Wowhead (Protection, priority). De toetsen
uit §3. Het samenvoegen tot één lijst is AFGELEID.

1. Defensive Stance (**Ctrl-2**). Battle Shout (**Shift-X**) aan. — Icy Veins stap 1; Wowhead "Maintain Battle Shout".
2. Bloodrage (**F1**) voor Rage om mee te beginnen. — Icy Veins stap 1 ("Use Bloodrage on cooldown, ideally between pulls").
3. Pull. Tot level 25: Charge (**R**) werkt alleen in Battle Stance (**Ctrl-1**), daarna terug naar Defensive Stance
   (**Ctrl-2**). Met Vanguard (talent, 25 op zijn vroegst) werkt Charge (**R**) gewoon in Defensive Stance. — Icy Veins
   stap 2; DB2 §4.2. Of pull met je afstandswapen (blok D) — Icy Veins, "Charge"-uitleg.
4. Meer vijanden: Demoralizing Shout (**Shift-2**, vanaf 14) één keer, Thunder Clap (**Shift-1**) telkens als hij klaar
   is. — Icy Veins AoE stap 1-2.
5. Shield Block (**Z**, vanaf 16), en Revenge (**2**, vanaf 14) zodra die oplicht. — Icy Veins stap 6-7; Wowhead 1-2.
6. Shield Slam (**3**, vanaf 40) telkens als hij klaar is. — Icy Veins stap 5; Wowhead 3.
7. Sunder Armor (**5**) op je hoofddoel; tot 5 stapels op een baas. — Icy Veins stap 9; Wowhead 5.
8. Taunt (**F**) als een vijand iemand anders aanvalt. — Icy Veins AoE-inleiding ("Use Taunt on enemies that you lose
   aggro on, then build threat on them").
9. Rage over: Heroic Strike (**1**) op één vijand, Cleave (**Shift-4**, vanaf 20) bij twee of meer. — Icy Veins stap 11
   / AoE 5; Wowhead 11 ("Heroic Strike if above 30 rage").

Noodknoppen: Last Stand (**X**, talent, 20 op zijn vroegst), Shield Wall (**C**, vanaf 28). Interrupt: Shield Bash
(**E**, vanaf 12). Stun: Concussion Blow (**Shift-V**, talent, 30 op zijn vroegst). — Icy Veins, "Utility and Crowd Control".

Gidsen oneens over **Rend** (**Shift-Z**): Icy Veins zet hem vroeg ("Apply Rend early if the target will survive most
of the bleed"), Wowhead laat ("Cast Rend if you're already high on threat").

**Per 10 levels** (levels: §4 en §2.3)

- **10:** Defensive Stance (**Ctrl-2**), Taunt (**F**) en Sunder Armor (**5**) uit de quest; Bloodrage (**F1**) bij de
  trainer. Daarna: Shield Bash (**E**) op 12, Revenge (**2**) en Demoralizing Shout (**Shift-2**) op 14, Shield Block
  (**Z**) op 16, Disarm (**V**) op 18. Thunder Clap (**Shift-1**, level 6) werkt ook in Defensive Stance.
- **20:** Last Stand (**X**, talent). Victory Rush (**F2**), Cleave (**Shift-4**). Daarna: Intimidating Shout
  (**Shift-Q**) op 22, Vanguard (talent, passief: Charge in Defensive Stance) op 25, Challenging Shout (**Shift-F**) op
  26, Shield Wall (**C**) op 28.
- **30:** Concussion Blow (**Shift-V**, talent). Berserker Stance (**Ctrl-3**, quest) met Intercept (**R**) en Berserker
  Rage (**Shift-V** in die stance). Daarna: Bastion (talent, passief) op 35.
- **40:** Shield Slam (**3**, talent). Plate Mail bij de trainer (plate dragen).
- **50:** niets nieuws voor deze rol (Recklessness op **Q** is een damage-knop voor Berserker Stance). Sterkere rangen:
  Shield Slam op 48 en 54, Revenge op 44 en 54, Sunder Armor op 46 en 58, Thunder Clap op 48 en 58.
- **60:** Shield Slam rang 4; niets nieuws.

Talent-levels zijn "op zijn vroegst"; de perk Talented kan ze tot 5 levels eerder brengen (§2.2).

**Beginner mistakes** (elk met bron)

- Shield Slam, Shield Block, Shield Bash en Shield Wall **zonder schild**. — GEMETEN, DB2 `SpellEquippedItems` (class 4,
  masker 64) voor 23922, 2565, 72, 871. (Staat voor drie ervan al in `CLASSES.WARRIOR`; Shield Wall is nieuw.)
- Taunt op een vijand die jou al aanvalt: doet niets. — GEMETEN, DB2-tekst van spell 355.
- Denken dat Thunder Clap de hele groep raakt: hij raakt er **4**. Een vijfde vijand kan naar de healer lopen. —
  GEMETEN, DB2 `SpellTargetRestrictions.MaxTargets = 4`; Icy Veins AoE stap 2.
- Vijanden achter je laten staan. Van achteren kun je niet blokken, dodgen of parryen, en Revenge licht dan niet op. —
  GEMETEN, Icy Veins ("Keep the pack in front of you so you can block, dodge and parry attacks").
- Charge (**R**) in Defensive Stance zonder Vanguard. — GEMETEN, DB2 (Charge 100 masker Battle; Vanguard 1310317).
  Staat al in `CLASSES.WARRIOR`.
- Van stance wisselen met veel Rage: je houdt er maar 10 over (Tactical Mastery, vanaf 14). — GEMETEN, DB2 1310185;
  Icy Veins ("any Rage above that amount is lost"). Vóór level 14 houd je niets over: AFGELEID.
- Heroic Strike (**1**) blijven indrukken als je weinig Rage hebt. Dan is er niets over voor Revenge of Shield Slam. —
  GEMETEN, Icy Veins ("Repeatedly queueing Heroic Strike while struggling for Rage only makes the problem worse").
- Shield Block tegen vijanden die spells casten: die blok je niet. — GEMETEN, Icy Veins stap 7; Mobalytics noemt ook
  elementals (behalve Earth).
- Execute (**4**) zoeken in Defensive Stance: die werkt daar niet. — GEMETEN, DB2 (masker Battle + Berserker); Wowhead
  (Protection): "you have to leave Defensive Stance to use it".
- Last Stand te laat of als heal gebruiken: de extra health gaat na 20 s weer weg. — GEMETEN, DB2-tekst 12975.
- Challenging Shout en Mocking Blow geven geen threat: na 6 s loopt de vijand terug als je niets doet. — GEMETEN,
  Icy Veins ("doesn't copy another player's threat").

---

## 6. Rol: Arms, damage met één groot wapen — `band = 1`

**Voorstel title:** `Arms: damage with one big weapon`.

**Feiten voor de inleiding**

- Vanaf level 1. Je staat bijna altijd in Battle Stance. — GEMETEN, Icy Veins (Arms), Mobalytics ("Arms will stay in
  Battle Stance for the majority of the time as Overpower is a core component").
- Draait om Rend, Overpower en harde slagen; Sweeping Strikes op 30 en Mortal Strike op 40 zijn de grote stappen. —
  GEMETEN, Icy Veins, Mobalytics, Warcraft Tavern, polestar.
- Sterk afhankelijk van je wapen: een nieuw wapen is de grootste winst. — GEMETEN, Wowhead (Arms), Mobalytics, Method.
- Geen eigen heal behalve Victory Rush (vanaf 20): eten en verband blijven nodig. — GEMETEN, Icy Veins, wowforeverleveling.

**Simple order, met toetsen**

Volgorde uit Icy Veins (Arms, Single-Target), Mobalytics (Arms, "Levels 24-60") en Wowhead (Arms). Samenvoegen: AFGELEID.

1. Battle Stance (**Ctrl-1**), Battle Shout (**Shift-X**). — alle drie.
2. Charge (**R**) om te beginnen. — Icy Veins stap 2, Mobalytics stap 2.
3. Rend (**Shift-Z**), als de vijand nog even leeft. — Icy Veins stap 5, Wowhead stap 2.
4. Overpower (**2**, vanaf 12) zodra die oplicht. — Icy Veins stap 6, Wowhead stap 3, Mobalytics stap 5.
5. Mortal Strike (**3**, vanaf 40) telkens als hij klaar is; houd er 30 Rage voor over. — Icy Veins stap 8, Wowhead stap 4.
6. Victory Rush (**F2**, vanaf 20) na een kill als je health mist. — alle drie.
7. Twee vijanden: Sweeping Strikes (**Q**, vanaf 30), dan Cleave (**Shift-4**, vanaf 20). Vóór 30: Thunder Clap
   (**Shift-1**). — Icy Veins AoE stap 2, 4, 7; Mobalytics stap 4.
8. Rage over: Heroic Strike (**1**). — alle drie, steeds als laatste.

Erbij: Demoralizing Shout (**Shift-2**, vanaf 14) tegen vijanden die hard slaan (Icy Veins stap 4, Mobalytics stap 6).
Spearing Strike (**F3**, talent, 25) eerst tegen Giants en Dragonkin (alle drie; DB2 §4.2). Hamstring (**V**) op
vijanden die weglopen (Mobalytics).

Gidsen oneens:
- **Rend of Overpower eerst:** Icy Veins en Wowhead zetten Rend boven Overpower, Mobalytics Overpower boven Rend.
- **Slam** (**Shift-C**): Mobalytics "Never cast slam without Improved Slam", Wowhead "avoid using Slam, until you unlock
  Improved Slam" (talent, 35 op zijn vroegst); Icy Veins: vanaf 20 mag het, direct na een gewone slag.
- **Heroic Strike vanaf hoeveel Rage:** Wowhead 40+, Mobalytics 60+ (tot 24) en 85+ (daarna), Icy Veins "excessive".
- **Whirlwind** (Berserker Stance) solo: Icy Veins "a death sentence" (alleen in een groep, bij 4 vijanden); Mobalytics
  noemt hem alleen voor dungeons; Wowhead zet hem wel in de AoE-lijst.

**Per 10 levels**

- **10:** Heroic Strike (**1**), Charge (**R**), Rend (**Shift-Z**), Thunder Clap (**Shift-1**), Hamstring (**V**),
  Battle Shout (**Shift-X**); Bloodrage (**F1**) op 10. Daarna: Overpower (**2**) op 12, Demoralizing Shout
  (**Shift-2**) op 14.
- **20:** Victory Rush (**F2**), Cleave (**Shift-4**), Slam (**Shift-C**), Retaliation (**C**). Daarna: Execute (**4**)
  op 24, Spearing Strike (**F3**, talent) op 25.
- **30:** Sweeping Strikes (**Q**, talent, alleen Battle Stance). Berserker Stance (**Ctrl-3**, quest) met Intercept
  (**R**) en Berserker Rage (**Shift-V**). Daarna: Improved Slam (talent, passief) op 35, Whirlwind (**2** in Berserker
  Stance) op 36, Pummel (**E** in Berserker Stance) op 38.
- **40:** Mortal Strike (**3**, talent). Plate Mail bij de trainer.
- **50:** Recklessness (**Q** in Berserker Stance). Sterkere rangen: Mortal Strike op 48 en 54.
- **60:** Mortal Strike rang 4; niets nieuws.

**Beginner mistakes**

- Heroic Strike (**1**) steeds indrukken. Hij vervangt je gewone slag en die slag geeft dan geen Rage; je houdt niets
  over voor Mortal Strike of Overpower. — GEMETEN, Icy Veins, Wowhead ("effectively doubling its Rage cost"), Mobalytics.
- Slam (**Shift-C**) zonder het talent Improved Slam: 1,5 s cast, en hij vertraagt je gewone slag. — cast GEMETEN in DB2
  (1500 ms); "vertraagt je slag" GEMETEN in de tekst van Improved Slam (12862) en in Mobalytics / Wowhead.
- Overpower (**2**) in de verkeerde stance of te laat. Alleen Battle Stance, en alleen kort nadat de vijand dodget. —
  stance GEMETEN in DB2; "up to 5 seconds" GEMETEN in Mobalytics (niet in DB2 gevonden).
- Rend op een vijand die bijna dood is, of op een vijand die niet kan bloeden. — GEMETEN, Icy Veins (stap 5; "Bleed
  immune enemies prevent Rend and Bloodthrill"), Mobalytics.
- Al je Rage in Execute (**4**) stoppen bij een vijand die toch al doodgaat: de volgende begin je met 0 Rage. —
  GEMETEN, Mobalytics ("often a trap"), Icy Veins stap 11, Wowhead.
- Sweeping Strikes (**Q**) in een andere stance: alleen Battle Stance. — GEMETEN, DB2 masker 65536.
- Een interrupt zoeken op **E** met een tweehandig wapen: Shield Bash heeft een schild nodig. Je eigen interrupt is
  Pummel (38, Berserker Stance). — GEMETEN, DB2 (72 schild; 6552 Berserker, level 38); Mobalytics ("No interrupt until
  level 38").
- In Berserker Stance blijven staan: je krijgt 10% meer damage, en Rend en Thunder Clap werken daar niet. — GEMETEN,
  DB2 (7381; maskers van 772 en 6343); Icy Veins.
- Met een oud wapen doorlopen, of een nieuwe wapensoort gebruiken zonder de weapon skill te trainen. — GEMETEN,
  Wowhead (Arms), Icy Veins ("Leveling Tips"), Warcraft Tavern.

---

## 7. Rol: Fury, damage met twee wapens — `band = 2`

**Voorstel title:** `Fury: damage with two weapons`.

**Feiten voor de inleiding**

- Twee wapens kan pas vanaf **level 20** (Dual Wield bij de trainer, §2.4). Tot dan: je beste wapen; een tweehandig
  wapen is prima. — GEMETEN, Icy Veins (Fury: "You cannot dual wield until Level 20, so use your best weapon until
  then; a good two handed weapon works well"), Mobalytics ("Can't dual wield until level 20").
- Fury wordt pas echt sterk met Whirlwind (36) en Bloodthirst (40). — GEMETEN, Icy Veins, Mobalytics ("Doesn't really
  come online until level 36"), Warcraft Tavern, wowforeverguides.
- Je hebt **twee** goede wapens nodig, en beide weapon skills. — GEMETEN, Icy Veins, wowforeverleveling.
- Whirlwind, Pummel, Intercept en Berserker Rage werken alleen in Berserker Stance (§4.1): je wisselt dus vaak van
  stance. — DB2 + Icy Veins ("Switching stances can be tedious").

**Simple order, met toetsen**

Tot level 36 is de volgorde die van Arms (§6): Rend, Overpower, Heroic Strike in Battle Stance. — GEMETEN, Icy Veins
(Fury: "starts out with a simple rotation built around auto attacks, Rend, and Overpower"), wowforeverguides (16-35:
Rend, Overpower, Heroic Strike, Execute, Victory Rush).

Vanaf 36, uit Icy Veins (Fury, Single-Target). Samenvoegen: AFGELEID.

1. Battle Shout (**Shift-X**). Bloodrage (**F1**) voor Rage. — Icy Veins stap 1.
2. Charge (**R**) in Battle Stance (**Ctrl-1**). — Icy Veins stap 2.
3. Death Wish (**Shift-3**, talent, 30) op een sterke vijand. — Icy Veins stap 5.
4. Berserker Stance (**Ctrl-3**): Whirlwind (**2**, vanaf 36) telkens als hij klaar is. — Icy Veins stap 6.
5. Bloodthirst (**3**, talent, 40) telkens als hij klaar is. — Icy Veins stap 7.
6. Victory Rush (**F2**) na een kill als je health mist. — Icy Veins stap 3.
7. Rage over: Heroic Strike (**1**); bij twee vijanden Cleave (**Shift-4**). — Icy Veins stap 12 / AoE 5.
8. Weinig Rage: Reckless Swings (**Shift-F1**, talent, 25; kost health), of Berserker Rage (**Shift-V** in Berserker
   Stance). — Icy Veins stap 1-2; DB2 §4.2.

Gidsen oneens:
- **Whirlwind of Bloodthirst eerst:** Icy Veins zet Whirlwind boven Bloodthirst (met het talent Improved Whirlwind);
  Kargoz (Mobalytics, 2 nov, van vóór de launch) zet Bloodthirst boven Whirlwind.
- **In welke stance blijven:** Icy Veins: na Whirlwind terug naar Battle Stance (minder damage krijgen); Kargoz:
  Berserker Stance is "your primary offensive stance".
- **Dual Wield Specialization:** wowforeverleveling zegt "no longer adds hit or Rage"; Icy Veins en wowforeverguides
  zeggen dat hij off-hand-Rage geeft. DB2 70938 geeft Icy Veins gelijk: de tekst van 23584 noemt "the Rage generated by
  your off-hand attacks". GEMETEN.
- **Talentvolgorde:** Icy Veins neemt Reckless Swings op 31, Kargoz niet; Kargoz en polestar noemen rangen die niet
  bestaan (Flurry 5, Improved Tactical Mastery 5 — DB2: 3 en 3) en Kargoz noemt Raging Blows (bestaat niet, §2.3).

**Per 10 levels**

- **10:** niets nieuws voor deze rol: je speelt als Arms, met één wapen (§6, level 10).
- **20:** Dual Wield bij de trainer: nu kan er een wapen in je andere hand. Piercing Howl (**Shift-R**, talent). Victory
  Rush (**F2**), Cleave (**Shift-4**). Daarna: Execute (**4**) op 24, Reckless Swings (**Shift-F1**, talent) op 25.
- **30:** Death Wish (**Shift-3**, talent). Berserker Stance (**Ctrl-3**, quest) met Intercept (**R**) en Berserker Rage
  (**Shift-V**). Daarna: Whirlwind (**2** in Berserker Stance) op 36, Pummel (**E** in Berserker Stance) op 38.
- **40:** Bloodthirst (**3**, talent; je moet eerst Death Wish hebben). Plate Mail bij de trainer.
- **50:** Recklessness (**Q** in Berserker Stance). Sterkere rangen: Bloodthirst op 48 en 54.
- **60:** Bloodthirst rang 4; niets nieuws.

**Beginner mistakes**

- Fury spelen met één goed wapen en een slecht tweede. — GEMETEN, wowforeverleveling ("Common mistakes"), Icy Veins.
- Twee wapens willen vóór level 20: kan niet. — GEMETEN, trainer-data + Icy Veins + Mobalytics.
- Het talent Furious Precision overslaan: je off-hand mist dan vaak, en een misser geeft geen Rage. — GEMETEN,
  Icy Veins, wowforeverleveling, Kargoz.
- Denken dat Bloodthirst heelt. In Forever niet: hij geeft loopsnelheid. — GEMETEN, DB2-tekst 23881; wowforeverleveling.
- Death Wish (**Shift-3**) indrukken in een gevecht dat je dreigt te verliezen: je krijgt 30 s lang 5% meer damage. —
  GEMETEN, DB2 12328; wowforeverleveling.
- Whirlwind (**2**) zoeken in Battle Stance: alleen Berserker Stance. En daar werken Rend (**Shift-Z**) en Thunder Clap
  (**Shift-1**) niet. — GEMETEN, DB2-maskers. (Thunder Clap staat al in `CLASSES.WARRIOR`.)
- Van stance wisselen met veel Rage: je houdt 10 over. Geef het eerst uit. — GEMETEN, DB2 1310185; Icy Veins.
- Reckless Swings (**Shift-F1**) indrukken als je weinig health hebt: hij kost health. — GEMETEN, DB2 `SpellPower`
  (type −2, 25); Icy Veins ("when you … have health to spare").
- Een talentvolgorde uit Classic of uit de beta volgen. De boom is anders. — GEMETEN, wowforeverleveling; en zelf
  gemeten: twee gidsen noemen rangen/talenten die build 70938 niet heeft (§2.3, §7 "Gidsen oneens").

---

## 8. Waar de gidsen het oneens zijn (samengevat)

| Punt | Wie zegt wat |
|---|---|
| **Welke boom levelt het snelst (solo)** | Icy Veins: "Protection is the fastest Warrior specialization for leveling in WoW Forever and the one we recommend". Wowhead (Protection): Arms- en Fury-spelers "will be looking to Protection for the first 35-40 levels". Mobalytics: Protection als je geen voorkeur hebt, "Slightly slower kill speed", eventueel naar Fury rond 40. Method: Arms beter in een groep, Protection "fantastic for solo grinding". wowforeverleveling: Arms het makkelijkst solo, Protection vanaf 16 voor de minste rusttijd. Warcraft Tavern: alle drie goed, "Traditionally, most players level as Arms". **polestar: "Protection is slower alone".** |
| Rend of Overpower eerst (Arms) | Icy Veins + Wowhead: Rend. Mobalytics: Overpower. |
| Slam zonder Improved Slam | Mobalytics + Wowhead: nooit. Icy Veins: mag vanaf 20, direct na een gewone slag. |
| Whirlwind of Bloodthirst eerst (Fury) | Icy Veins: Whirlwind. Kargoz: Bloodthirst. |
| Rend als tank | Icy Veins: vroeg. Wowhead: alleen als je threat al hoog is. |
| Geeft Dual Wield Specialization Rage | wowforeverleveling: nee. Icy Veins, wowforeverguides: ja. DB2 70938: **ja**. |
| Trainer-levels van rangen | De rang-tabel in Wowhead (Arms) ("Heroic Strike 12; 22; 32…", "Charge: 1") klopt niet met `ForeverTrainerData.lua` en DB2 (Heroic Strike 8, 16, 24…; Charge 4, 26, 46). Icy Veins' rang-tabel (Protection) klopt wél met de trainer-data. Volg DB2 / de trainer-data. |

Advies aan de schrijver (AFGELEID): bij de tank-kaart het zinnetje "the guides disagree" opnemen zoals bij de druid
("the guides call the cat smoother"), en geen boom als "de beste" noemen.

---

## 9. Wat AFGELEID is, en wat niet gemeten is

**AFGELEID**
1. Vroegste talent-level = 10 + SpentAmountRequired (§2.2). De twee bouwstenen zijn gemeten; de som geldt alleen als
   alle punten in die boom gaan.
2. Band 1 / 2 / 3 = Arms / Fury / Protection (inhoud + `TalentTab`-volgorde).
3. De decodering van stance-maskers (65536 / 131072 / 262144) en van item-maskers (tweehandig, off-hand, schild). De
   uitkomst klopt overal met de client-teksten en de gidsen.
4. De "Simple order"-lijsten: stappen uit de gidsen, toetsen uit de code, samengevoegd en ingekort door mij.
5. Vanguard-Charge werkt nog steeds niet in een gevecht (gelijke attributen; Icy Veins zegt het ook).
6. Vóór level 14 houd je bij een stance-wissel geen Rage over (Tactical Mastery komt op 14).
7. De voorgestelde titels.

**NIET GEMETEN**
- Niets is in de client getest. Alles is DB2, code en gidsen.
- Of de perk Talented een talent met eigen spell-level (40) echt eerder geeft.
- Hoe de getallen van passieve talenten per rang oplopen (§4.3).
- Hoe lang Overpower bruikbaar blijft na een dodge (alleen Mobalytics: 5 s).
- "Base health" bij Bloodrage en Reckless Swings (alleen gidsen).
- Wowheads Fury-leveling-pagina (gaf geen tekst).
- Het druid-onderzoeksbestand in `docs/` (niet gelezen, agentregel).

---

## 10. Opmerkingen bij de bestaande tekst (`CLASSES.WARRIOR`)

Geen fout gevonden. Alle levels en toetsen in r. 157-196 kloppen met DB2 70938 en met `ForeverBlock_Warrior.lua`
(GEMETEN, regel voor regel naast §3 en §4 gelegd). Twee dingen om te weten, geen wijzigingsverzoek:

- "Simple order" r. 180 zegt "Heroic Strike (1) again and again". Voor level 1-10 klopt dat met Warcraft Tavern en
  Mobalytics (het is dan je enige aanval). Vanaf Overpower / Revenge zeggen alle gidsen: Heroic Strike alleen met Rage
  over. De rolkaarten hierboven volgen dat.
- Bij "Beginner mistakes" r. 193 ontbreekt Shield Wall in het rijtje "without a shield" (DB2: 871 eist ook een schild).

Extra feit uit twee gidsen, niet in DB2 gezocht: **Dual Talent Specialization op level 40 bij de class trainer**
(Warcraft Tavern mijlpalen-tabel; wowforeverleveling "From 40: use Dual Specialization"). Kan een zin opleveren als
"vanaf 40 kun je een tank-build en een damage-build naast elkaar hebben" — eerst nameten vóór het in een tekst komt.
