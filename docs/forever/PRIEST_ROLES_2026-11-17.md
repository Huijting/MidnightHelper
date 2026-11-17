# Priest per rol: feiten voor "How you play" (WoW Forever)

Onderzoek van mh-research, 17 nov 2026. Voor mh-writer, die hieruit `ROLES.PRIEST` schrijft in de vorm van
`ROLES.DRUID` (`Modules/ForeverHowToPlay.lua` r. 373-453).
Client: WoW Forever, build **1.60.1.70938**.

## 0. Leeswijzer

- **[G]** = GEMETEN: gezien in een bron met naam en datum. De bron staat erachter.
- **[A]** = AFGELEID: beredeneerd, niet gezien.
- Niets hiervan is in de client getest. Rob of Cisca moet het in het spel bevestigen.
- De voordeur (`_probe.py`, `run gamedata`) is niet gebruikt. DB2 is gelezen uit de lokale cache.
- 🔴 `docs/forever/DRUID_ROLES_2026-11-16.md` heb ik **niet** gelezen: mijn eigen agentregel verbiedt lezen in `docs/`.
  De vorm komt uit `ROLES.DRUID` in de Lua. Mist dit bestand iets dat het druid-bestand wel heeft, dan komt het daardoor.
- Regelnummers zijn van het moment van lezen. `ForeverMacros.lua` werd tijdens mijn sessie bewerkt (na r. 744 kwamen er
  ~29 regels bij), dus nummers daar kunnen verschoven zijn.

### Broncodes

| Code | Bron | Datum |
|---|---|---|
| DB2 | `C:\Users\RobHu\AppData\Local\MidnightHelper\gamedata_cache\db2\1.60.1.70938\<Tabel>.enUS.csv` (Blizzards tabellen, wago.tools) | build 1.60.1.70938, gelezen 17 nov 2026 |
| BLOK | `Modules/ForeverBlock_Priest.lua` r. 19-61 | gelezen 17 nov 2026 |
| HTP | `Modules/ForeverHowToPlay.lua`, `CLASSES.PRIEST` r. 240-278 | gelezen 17 nov 2026 |
| TRAIN | `Modules/ForeverTrainerData.lua`, `PRIEST` r. 669-873 | gelezen 17 nov 2026 |
| MAC | `Modules/ForeverMacros.lua` (priest: r. 284-294, 538-558, 624-632, 671-675, 737-743) | gelezen 17 nov 2026 |
| CWF-K | classicwowforever.com/class-guides/priest/ | "Updated 11 Nov 2026", build 1.60.1.70862 |
| CWF-D / CWF-H / CWF-S | classicwowforever.com/class-guides/priest/discipline/ , /holy/ , /shadow/ | "Updated 11 Nov", build 1.60.1.70862 |
| CWF-T | classicwowforever.com/talents/priest/ | "Updated 11 Nov 2026" |
| IV-S | icy-veins.com/wow-forever/shadow-priest-leveling | "Last Updated: Nov 4, 2026" |
| IV-D | icy-veins.com/wow-forever/discipline-priest-healer-pve-rotation-cooldowns-abilities | "Last Updated: Nov 4, 2026" |
| IV-H | icy-veins.com/wow-forever/holy-priest-healer-pve-rotation-cooldowns-abilities | "Last Updated: Nov 4, 2026" |
| IV-HG | icy-veins.com/wow-forever/holy-priest-healer-pve-guide | "Last Updated: Nov 10, 2026" |
| WH-D | wowhead.com/forever/guide/classes/priest/discipline/rotation-cooldowns-pve-healer | "Updated: 2026/10/30" |
| WH-H | wowhead.com/forever/guide/classes/priest/holy/rotation-cooldowns-pve-healer | "Updated: 2026/10/31" |
| WH-L | wowhead.com/forever/guide/classes/priest/leveling-guide | "Updated: 2026/11/12" |
| WH-D20 | wowhead.com/forever/guide/classes/priest/discipline/level-20-healer-overview | "Updated: 2026/11/12", maar "created during the beta and no longer updated" |
| POL | polestar.guide/guides/class/priest | geen datum; "Checked on game build 1.60.1.70450" (een beta-build); talentplannen staan "paused" (polestar.guide/docs/players/talent-plans) |
| MET | method.gg/wow-forever/wow-forever-priest-leveling-guide-and-talents | "Last Updated: 14th November 2026" |
| MOB | mobalytics.gg/wow-forever/classes/toleduck-priest-leveling-guide | "Updated on Nov 15, 2026" |
| BP | boosting.pro/wow-forever-priest-leveling-guide/ | 4 nov 2026 (boven level 30 "a forecast") |
| WFG-S / WFG-D / WFG-H | wow-forever.gg/classes/priest/shadow/ , /discipline/ , /holy/ | "Updated 2026-11-05" |
| WFF-S / WFF-D | wowforeverforge.com/priest/shadow/guide/ , /discipline/guide/ | patchregel "14 November 2026" |
| WC | wowcamp.fun/en/classes/priest/ | "Updated 15 November 2026" |
| FC | foreverchanges.pro/spellbook/priest | build 1.60.1.70938 |
| WCALC | wowcalc.net/en/forever/wiki/spells/priest/lightwell | build 1.60.1.70888 |
| WIKI | warcraft.wiki.gg/wiki/Priest_abilities_(Forever) | geen datum gezien |

Alle webbronnen zijn gelezen via Exa (zoeken en ophalen) op 17 nov 2026. `www.icy-veins.com` gaf rechtstreeks 403.
De pagina's van Wowhead "Shadow Priest Leveling" en "Discipline Priest Leveling" kwamen leeg terug: **niet gelezen**.

---

## 1. Kort antwoord: welke boom is welke rol

| band | Boom | Rol | Zekerheid |
|---|---|---|---|
| 1 | Discipline | **healer** (schilden, Penance) | [G] CWF-K noemt Discipline "Healer"; WH-D: "Discipline Priest is a healing spec"; IV-D: "a Discipline Priest's main job is to heal" |
| 2 | Holy | **healer** (groep) | [G] CWF-K noemt Holy "Healer"; WH-H: "Holy Priests are a pure healing specialization"; IV-H: "a Holy Priest's main job is to heal" |
| 3 | Shadow | **damage van afstand** | [G] CWF-K noemt Shadow "Ranged damage"; DB2 `Spell` 15473: "you may not cast healing spells while in this form" |

- [G] Band 1/2/3 = Discipline/Holy/Shadow: MAC r. 624-632 (`SPEC_NAMES.PRIEST`), DB2 `TalentTab` r. 11-13 (OrderIndex 0/1/2),
  en de PosX-banden hieronder (Penance en Power Infusion in band 1, Prayer of Mending in band 2, Shadowform in band 3).
- [G] Blizzards data zegt zelf **niets** over rollen: DB2 `TalentTab.RoleMask` = 0 voor alle drie, en `ChrSpecialization` heeft
  voor de priest maar één rij (ID 1487, r. 6). De rol komt dus uit de talenten en de gidsen.
- [A] **Er zijn drie blokken nodig, niet twee.** `RolesText` vergelijkt `r.band == band` (HTP-bestand r. 525): één getal
  per blok. Met alleen één "healer"-blok op band 2 ziet een Discipline-speler (band 1) zijn rol niet bovenaan.
  Voorstel titels (vorm van de druid): `"Discipline: healer"` (band 1), `"Holy: healer"` (band 2),
  `"Shadow: damage from a distance"` (band 3).

---

## 2. De talentboom in DB2 (boom 1114)

- [G] Priest = TraitTree **1114**: MAC r. 674; DB2 `TraitTree` r. 12; `TraitNode` r. 352-399 en 521-525 (52 zichtbare nodes).
- [G] Talentpunten: 1 punt per level vanaf level 10 (DB2 `TraitCurrencySource` r. 2-52: "Level 10" t/m "Level 60",
  currency 3820; boom 1114 gebruikt currency 3820: `TraitTreeXTraitCurrency` r. 9). Dus punt N = level 9 + N, 51 punten op 60.
- [G] Per rij een eis "zoveel punten in deze boom": `TraitCond` r. 107-125 (SpentAmountRequired 0/5/10/15/20/25/30),
  gekoppeld via `TraitNodeGroupXTraitCond` r. 107-125 en `TraitNodeGroupXTraitNode`.
- [A] Vroegste level van een rij = 10 + SpentAmountRequired (je moet eerst zoveel punten uitgeven; het volgende punt
  komt een level later). Dezelfde rekenregel als MAC r. 478-480 en 571-573.
- [G] De Legacy-perk **Talented** geeft tot 5 punten eerder (DB2 `TraitCurrencySource` r. 114-118: "Talented Rank 1
  (Level 9)" t/m "Rank 5 (Level 5)"). De druid-tekst zegt: "Talent levels here are the earliest; a perk can bring them
  up to 5 levels sooner." Die zin geldt hier ook.
- [G] Voorwaarden tussen talenten: DB2 `TraitEdge` r. 42-45, 74-76, 79.
- [G] Alle punten tellen mee voor de rijen eronder (ik heb de telgroepen 12760, 12765, 12770 nagelopen: elke node van
  rij 1-5 zit erin). POL zegt dat Mental Strength niet meetelt: dat klopt niet meer in build 70938.

**ACTIEF** = een spell met een toets. De rest is passief (geen toets).

### Discipline (band 1, PosX 1020-2820)

| Rij | Punten nodig | Vroegste level | Talent (spell-id, max rangen) | Wat het doet (DB2 `Spell`, zonder getallen) | Eist |
|---|---|---|---|---|---|
| 1 | 0 | 10 | Power in Light (1309969, 5) | Smite en Penance doen meer schade op een doelwit met jouw Holy Fire of Shadow Word: Pain | |
| 1 | 0 | 10 | Wand Specialization (14524, 2) | meer wand-schade (25% op 2/2: `SpellEffect` basis 25) | |
| 1 | 0 | 10 | Twin Disciplines (1225132, 5) | meer schade en healing van instant spells | |
| 2 | 5 | 15 | Silent Resolve (14523, 3) | minder threat | |
| 2 | 5 | 15 | Holy Precision (1309957, 3) | meer kans om te raken met Holy spells | |
| 2 | 5 | 15 | Mental Strength (18551, 5) | meer Intellect | |
| 2 | 5 | 15 | Martyrdom (14531, 2) | | |
| 3 | 10 | 20 | Mental Agility (14520, 3) | Smite, Holy Fire en instant spells goedkoper | |
| 3 | 10 | 20 | **Inner Focus** (14751, 1) ACTIEF | volgende spell kost geen mana en heeft 25% meer crit-kans (`SpellEffect` -100 / 25) | |
| 3 | 10 | 20 | Improved Power Word: Shield (14748, 3) | schild vangt meer op | |
| 3 | 10 | 20 | Meditation (14521, 3) | een deel van je mana-herstel loopt door tijdens casten | |
| 4 | 15 | 25 | Improved Inner Fire (14747, 3) | | |
| 4 | 15 | 25 | Improved Mana Burn (14750, 2) | | |
| 4 | 15 | 25 | Soul Warding (402000, 1) | Power Word: Shield: cooldown 4 s korter (dus weg) en 15% goedkoper (`SpellEffect` -4000 / -15) | Improved Power Word: Shield |
| 5 | 20 | 30 | **Penance** (402174, 1) ACTIEF | Holy damage op een vijand óf healing op een vriend, meteen en elke seconde, 2 s lang | |
| 5 | 20 | 30 | Renewed Hope (425280, 5) | heals op iemand met Weakened Soul critten vaker en korten Weakened Soul in | Soul Warding |
| 6 | 25 | 35 | Divine Aegis (431622, 3) | een crit-heal laat een schildje achter | |
| 7 | 30 | 40 | **Power Infusion** (10060, 1) ACTIEF | doelwit: 20% meer spell damage en healing (`SpellEffect` basis 20) | Penance |

### Holy (band 2, PosX 5020-6820)

| Rij | Punten nodig | Vroegste level | Talent (spell-id, max rangen) | Wat het doet | Eist |
|---|---|---|---|---|---|
| 1 | 0 | 10 | Twilight Focus (14913, 3) | kans dat schade je cast niet vertraagt (70% op 3/3: `SpellEffect` basis 70) | |
| 1 | 0 | 10 | Improved Renew (14908, 3) | Renew healt meer | |
| 1 | 0 | 10 | Holy Specialization (14889, 5) | meer crit-kans met Holy spells | |
| 2 | 5 | 15 | Spell Warding (27900, 5) | minder spell-schade op jou | |
| 2 | 5 | 15 | Divine Fury (18530, 5) | Smite, Holy Fire, Heal en Greater Heal casten sneller | |
| 3 | 10 | 20 | **Holy Nova** (15237, 1) ACTIEF | explosie om je heen: schade op vijanden, healing op groepsleden, geen threat | |
| 3 | 10 | 20 | Blessed Recovery (27811, 3) | | |
| 3 | 10 | 20 | Inspiration (14892, 3) | crit-heal geeft het doelwit meer armor | |
| 4 | 15 | 25 | Holy Reach (27789, 2) | | |
| 4 | 15 | 25 | Improved Healing (14912, 3) | Lesser Heal, Heal, Greater Heal, Penance en Prayer of Mending goedkoper | |
| 4 | 15 | 25 | Searing Light (14909, 2) | meer Holy damage; kans op een gratis Holy Nova | Divine Fury |
| 4 | 15 | 25 | Holy Binding (1328569, 1) | Flash Heal op een ander healt jou voor 50% (`SpellEffect` basis 50), zonder threat | |
| 5 | 20 | 30 | Litany of Light (1317006, 2) | mana terug als je vorige heal een andere spell was | |
| 5 | 20 | 30 | Spirit of Redemption (20711, 1) | na je dood kun je kort gratis healen; je kunt niet bewegen; daarna sterf je | |
| 5 | 20 | 30 | Spiritual Guidance (14901, 5) | Spirit geeft healing en een beetje damage | |
| 6 | 25 | 35 | Spiritual Healing (14898, 3) | al je heals healen meer | |
| 7 | 30 | 40 | **Prayer of Mending** (401859, 1) ACTIEF | healt het doelwit zodra het schade krijgt, springt dan naar een ander groepslid (tot 5 keer: `SpellEffect` basis 5) | Spirit of Redemption |

### Shadow (band 3, PosX 9080-10880)

| Rij | Punten nodig | Vroegste level | Talent (spell-id, max rangen) | Wat het doet | Eist |
|---|---|---|---|---|---|
| 1 | 0 | 10 | Shadow Focus (15260, 5) | meer kans om te raken met Shadow spells | |
| 1 | 0 | 10 | Blackout (15326, 5) | kans op een stun | |
| 1 | 0 | 10 | Spirit Tap (15270, 5) | na een kill: veel meer Spirit, en mana-herstel loopt door tijdens casten | |
| 2 | 5 | 15 | Improved Mind Blast (15273, 5) | kortere cooldown op Mind Blast | |
| 2 | 5 | 15 | Improved Shadow Word: Pain (15275, 2) | Shadow Word: Pain duurt langer | |
| 2 | 5 | 15 | Shadow Reach (17322, 2) | meer bereik | |
| 3 | 10 | 20 | Improved Psychic Scream (15392, 2) | | Blackout |
| 3 | 10 | 20 | **Mind Flay** (15407, 1) ACTIEF | channel: Shadow damage en het doelwit loopt trager | |
| 3 | 10 | 20 | Improved Mind Flay (1225139, 2) | elke tik van Mind Flay is sterker dan de vorige (20% op 2/2: `SpellEffect` basis 20) | Mind Flay |
| 4 | 15 | 25 | Dark Inspiration (1326159, 5) | Mind Blast en een volle Mind Flay geven jou en je groep meer Spirit | |
| 4 | 15 | 25 | **Vampiric Embrace** (15286, 1) ACTIEF | je groep wordt geheald voor 20% van je Shadow damage (`SpellEffect` basis 20) | |
| 4 | 15 | 25 | Shadow Weaving (15257, 3) | | |
| 5 | 20 | 30 | **Silence** (15487, 1) ACTIEF | doelwit kan niet casten; onderbreekt een cast | |
| 5 | 20 | 30 | Devouring Contagion (1309950, 2) | Devouring Plague goedkoper (en springt over: CWF-S) | |
| 6 | 25 | 35 | Darkness (15259, 5) | meer Shadow damage | |
| 6 | 25 | 35 | Early Demise (1310076, 2) | Shadow Word: Death crit vaker op een doelwit met weinig health | |
| 7 | 30 | 40 | **Shadowform** (15473, 1) ACTIEF | +10% Shadow damage, Shadow spells half zo duur, 15% minder fysieke schade, crit-bonus verdubbeld; geen healing spells (`SpellEffect` 10 / -50 / -15 / 100) | Vampiric Embrace |

[G] voor alle drie de tabellen: DB2 `TraitNode` (PosX/PosY), `TraitNodeXTraitNodeEntry` r. 351-398 en 524-528,
`TraitNodeEntry` r. 369-419 en 614-618 (MaxRanks), `TraitDefinition` (zelfde regels, SpellID), `SpellName`, `Spell`
(omschrijving), `TraitNodeGroupXTraitNode` + `TraitCond` (punten), `TraitEdge` (kolom "Eist").
[A]: de kolom "Vroegste level".
Tegencontrole [G]: CWF-T telt ook "52 talents", "Discipline talents 18", "Shadow Magic talents 17", en noemt dezelfde
eisen ("20 points in Discipline", "30 points in Holy; Spirit of Redemption at full rank").

### Levels van de actieve talent-spells

| Spell | Toets | Punten | Vroegste level | Tweede bron |
|---|---|---|---|---|
| Mind Flay | 1 | 10 | 20 [A] | IV-S "20: Earliest Mind Flay (Talent)" [G]; DB2 `SpellLevels` 15407 = 20 [G] |
| Holy Nova | Shift-1 | 10 | 20 [A] | CWF-H zet hem op 20 [G]; DB2 `SpellLevels` 15237 = 20 [G] |
| Inner Focus | F1 | 10 | 20 [A] | HTP r. 271 "20 at the earliest" [G] |
| Vampiric Embrace | Ctrl-3 | 15 | 25 [A] ⚠️ | IV-S "25: Earliest Vampiric Embrace (Talent)" [G]; maar zie punt 6.8 |
| Penance | Shift-F1 | 20 | 30 [A] | CWF-D zet hem op 30 [G]; DB2 `SpellLevels` 402174 = 30 [G] |
| Silence | E | 20 | 30 [A] | CWF-S zet hem op 30 [G] |
| Power Infusion | Q | 30 | 40 [A] | CWF-D "Discipline's 31-point talent" op 40 [G]; DB2 `SpellLevels` 10060 = 40 [G] |
| Prayer of Mending | Ctrl-2 | 30 | 40 [A] | CWF-H op 40 [G]; DB2 `SpellLevels` 401859 = 40 [G] |
| Shadowform | Ctrl-1 | 30 | 40 [A] | IV-S "40: Shadowform" [G] |

Dit zijn dezelfde levels als in HTP r. 271.

---

## 3. Toetsen (MH's vaste blok)

[G] Alles uit BLOK r. 21-60; de levels uit TRAIN en HTP r. 252-271. Niets verzonnen.

| Toets | Spell | Vanaf |
|---|---|---|
| 1 | Smite; zodra je Mind Flay kent: **Mind Flay** | 1 / talent 20 |
| 2 | Shadow Word: Pain | 4 |
| 3 | Mind Blast | 10 |
| 4 | Holy Fire | 20 |
| Shift-4 | Shadow Word: Death | 32 |
| 5 | Shoot (wand) | 1, met een wand |
| Shift-1 | Holy Nova | talent 20 |
| Shift-2 | Prayer of Healing | 30 |
| Shift-3 | Devouring Plague | 20 |
| Q | Power Infusion | talent 40 |
| F1 | Inner Focus | talent 20 |
| Shift-F1 | Penance | talent 30 |
| F2 | Flash Heal | 20 |
| F3 | Resurrection | 10 |
| F4 | Renew | 8 |
| E | Silence | talent 30 |
| R | Levitate | 34 |
| F | Fade | 8 |
| Z | Power Word: Shield | 6 |
| C | Lesser Heal (1), dan Heal (16), dan Greater Heal (40) | 1 |
| Shift-Z | Inner Fire | 12 |
| Shift-X | Power Word: Fortitude (1), later Prayer of Fortitude (48) | 1 |
| Shift-C | Cure Disease (14), dan Abolish Disease (32) | 14 |
| V | Psychic Scream | 14 |
| Shift-Q | Shackle Undead | 20 |
| Shift-F | Mind Control | 30 |
| Shift-V | Dispel Magic | 18 |
| Ctrl-1 | Shadowform | talent 40 |
| Ctrl-2 | Prayer of Mending | talent 40 |
| Ctrl-3 | Vampiric Embrace | talent 25 |
| Shift-E | ras-skill (Stoneform, Shadowmeld, …) | |
| T / Shift-T / G | potion / healthstone / trinket (voor elke class) | |
| blok D | Fear Ward, Divine Spirit, Prayer of Spirit, Shadow Protection, Prayer of Shadow Protection, Mind Soothe, Mind Vision, Mana Burn, Lightwell | |

### 🔴 X en Shift-R zijn de ras-spells: per ras iets anders

[G] HTP r. 244-251 en BLOK r. 37 en 40. Schrijf in de roltekst dus nooit "X = …" of "Shift-R = …" zonder het ras.

| Ras | Level 10 | Level 20 |
|---|---|---|
| Dwarf | Desperate Prayer op **X** (cooldown 10 min) | Chastise op **Shift-R** |
| Human | Divine Grace op **Shift-R** (cooldown 10 min) | Feedback op **X** |
| Night Elf | Starshards op **Shift-R** (cooldown 30 s) | Elune's Grace op **X** |
| Undead | Touch of Weakness op **X** | Dark Sacrifice op **Shift-R** |
| Troll | Hex of Weakness op **Shift-R** | Shadowguard op **X** |
| Gnome | Confounding Flash op **Shift-R** | Contingency Plan op **X** |

- [G] Cooldowns hierboven kloppen met DB2 `SpellCooldowns`: Desperate Prayer 13908 = 600000 ms, Divine Grace 1277370 =
  600000 ms, Starshards 10797 = 30000 ms. Ook gemeten: Contingency Plan 1277462 = 600000 ms, Dark Sacrifice 1277324 =
  600000 ms, Chastise 1277331 = 120000 ms, Feedback 13896 = 180000 ms, Elune's Grace 2651 = 300000 ms.
- [A] Voor de roltekst is één zin genoeg: "Your race spells are on X and Shift-R (see the list above)". Welke ras-spell
  bij welke rol past (bijvoorbeeld Desperate Prayer voor een healer) heb ik niet in een gids gemeten.

### Let op bij toets C

[G] HTP r. 254: Heal (16) en Greater Heal (40) nemen toets C over. [A] Vanaf 40 staat de goedkope Heal dus niet meer op
het blok. Gidsen zeggen "Heal voor gewone schade, Greater Heal voor grote klappen" (CWF-D, WH-H). Met MH's blok is dat
één toets: schrijf "C = your big heal", niet twee aparte heals.

---

## 4. Spells per level (trainer), voor "Per 10 levels"

[G] TRAIN r. 669-873, tenzij anders gezegd. Alleen nieuwe spells; sterkere rangen staan in de regel eronder.
Rangnummers noem ik niet: de kop van TRAIN waarschuwt dat tellen in die lijst fout gaat.

| Level | Nieuw (toets) |
|---|---|
| 1 | Smite (1), Lesser Heal (C), Power Word: Fortitude (Shift-X), Shoot (5). Smite en Lesser Heal zijn startspells: DB2 `SpellLevels` 585 en 2050 = level 1 |
| 4 | Shadow Word: Pain (2) |
| 6 | Power Word: Shield (Z) |
| 8 | Fade (F), Renew (F4) |
| 10 | Mind Blast (3), Resurrection (F3); eerste ras-spell (quest); eerste talentpunt |
| 12 | Inner Fire (Shift-Z) |
| 14 | Cure Disease (Shift-C), Psychic Scream (V) |
| 16 | Heal (C) |
| 18 | Dispel Magic (Shift-V) |
| 20 | Devouring Plague (Shift-3), Flash Heal (F2), Holy Fire (4), Shackle Undead (Shift-Q), Fear Ward (blok D), Mind Soothe (blok D); tweede ras-spell (quest) |
| 22 | Mind Vision (blok D) |
| 24 | Mana Burn (blok D) |
| 30 | Prayer of Healing (Shift-2), Mind Control (Shift-F), Divine Spirit (blok D), Shadow Protection (blok D) |
| 32 | Shadow Word: Death (Shift-4), Abolish Disease (Shift-C) |
| 34 | Levitate (R) |
| 40 | Greater Heal (C). Lightwell (blok D): zie punt 8.3, staat **niet** in TRAIN |
| 48 | Prayer of Fortitude (Shift-X): zie punt 8.4, staat **niet** in TRAIN |
| 60 | Prayer of Spirit (blok D) |

Sterkere rangen bij de trainer [G]:
- Mind Blast 16, 22, 28, 34, 40, 46, 52, 58. Shadow Word: Pain 10, 18, 26, 34, 42, 50, 58.
- Mind Flay 28, 36, 44, 52, 60. Devouring Plague 28, 36, 44, 52, 60. Shadow Word: Death 40, 48, 56.
- Smite 6, 14, 22, 30, 38, 46, 54. Holy Fire 24, 30, 36, 42, 48, 54, 60. Holy Nova 28, 36, 44, 52, 60.
- Renew 14, 20, 26, 32, 38, 44, 50, 56. Heal 22, 28, 34. Flash Heal 26, 32, 38, 44, 50, 56. Greater Heal 46, 52, 58.
- Power Word: Shield 12, 18, 24, 30, 36, 42, 48, 54, 60. Prayer of Healing 40, 50, 60.
- **Penance 40, 50, 60. Prayer of Mending 50, 60.** (talent-spells met trainer-rangen)
- Psychic Scream 28, 42, 56. Resurrection 22, 34, 46, 58. Dispel Magic 36. Mind Control 44, 58.

---

## 5. Per rol

### 5a. Discipline: healer (band 1)

**Intro-feiten**
- [G] Healen kan vanaf level 1: Lesser Heal is een startspell (DB2 `SpellLevels` 2050; HTP r. 254).
- [G] Het eigen karakter (schilden, Penance) komt pas op 25-30: Soul Warding vanaf 25, Penance vanaf 30 (tabel 2).
- [G] In een groep: sterk op één doelwit, de tank. WH-D: "Discipline particularly excels in tank healing roles".
  WFG-D noemt als zwakte "Weak group healing".
- [G] Alleen levelen kan: Smite, Holy Fire en de wand, later Penance erbij (CWF-D, IV-D). Of dat sneller is dan
  Shadow: gidsen oneens, zie 6.1.
- [G] **Weakened Soul**: wie een Power Word: Shield kreeg, kan een tijdje geen nieuwe krijgen (DB2 `Spell` 17: "Once
  shielded, the target cannot be shielded again"; 6788: "Cannot benefit from Power Word: Shield"; 15 s volgens HTP r. 258
  en CWF-K).

**Simple order, in een groep**

| # | Stap (toets) | Bron |
|---|---|---|
| 1 | Power Word: Shield (**Z**) op de tank, vlak voor de pull | [G] WH-D stap 1; WFG-D "Shield the tank just before they pull, not after"; CWF-D |
| 2 | Renew (**F4**) op de tank | [G] WH-D "Maintain Renew on the target"; CWF-D |
| 3 | Penance (**Shift-F1**, vanaf 30) op wie gewond is, elke keer als hij klaar is | [G] WH-D stap 2; CWF-D "Penance whoever is lowest each time it's ready"; cooldown 12 s: DB2 |
| 4 | Heal / Greater Heal (**C**) voor gewone schade | [G] WH-D stap 4; CWF-D "Heal for steady damage" |
| 5 | Flash Heal (**F2**, vanaf 20) als C te langzaam is | [G] CWF-D; IV-D "Use Flash Heal in an emergency" |
| 6 | Meer mensen gewond: Prayer of Healing (**Shift-2**, vanaf 30) | [G] WH-D "Cast Prayer of Healing on an injured party"; CWF-D |
| 7 | Inner Focus (**F1**, vanaf 20) vóór een dure heal. Power Infusion (**Q**, vanaf 40) op jezelf of een caster | [G] WH-D; CWF-D; WFG-D |

[A] De volgorde 1-7 als één lijst is mijn samenvoeging; de stappen 1-4 staan in die volgorde in WH-D.

**Simple order, alleen**

[G] IV-D, letterlijk de volgorde: Power Word: Fortitude en Inner Fire aan; Power Word: Shield (**Z**); Holy Fire (**4**,
vanaf 20); Smite (**1**); Mind Blast (**3**); Shadow Word: Pain (**2**); Penance (**Shift-F1**) "if it isn't needed for
healing"; dan de wand (**5**) tot de vijand dood is.
[G] WH-D20 (beta, level 20) heeft dezelfde volgorde zonder Penance.

**Per 10 levels** (talent-levels = vroegste, tabel 2)

| Level | Nieuw voor deze rol | Bron |
|---|---|---|
| 10 | Je hebt: Lesser Heal (**C**), Power Word: Shield (**Z**), Renew (**F4**), Resurrection (**F3**, alleen buiten een gevecht), Smite (**1**). Daarna: Inner Fire (**Shift-Z**) op 12, Cure Disease (**Shift-C**) op 14, Heal (**C**) op 16, Dispel Magic (**Shift-V**) op 18 | [G] TRAIN, BLOK, HTP r. 262 |
| 20 | Flash Heal (**F2**), Holy Fire (**4**), Fear Ward (blok D). Inner Focus (**F1**, talent): volgende spell gratis en meer crit-kans, cooldown 3 min. Daarna: Soul Warding (passief talent) vanaf 25: Shield zonder cooldown en goedkoper | [G] TRAIN; DB2 `SpellCooldowns` 14751 = 180000 ms; tabel 2 |
| 30 | Penance (**Shift-F1**, talent): healt een vriend of doet schade op een vijand; cooldown 12 s. Prayer of Healing (**Shift-2**), Divine Spirit (blok D). Daarna: Abolish Disease (**Shift-C**) en Shadow Word: Death (**Shift-4**) op 32; Divine Aegis (passief) vanaf 35 | [G] TRAIN; DB2 `SpellCooldowns` 402174 = 12000 ms |
| 40 | Power Infusion (**Q**, talent, eist Penance): 20% meer spell damage en healing, cooldown 3 min. Greater Heal neemt **C** over. Sterkere Penance bij de trainer. Lightwell (blok D), zie 8.3 | [G] DB2 `SpellCooldowns` 10060 = 180000 ms, `SpellEffect` 20; TRAIN r. 775, 780. Duur 15 s: CWF-K tooltip |
| 50 | Sterkere rangen van Penance, Prayer of Healing, Flash Heal, Renew. Prayer of Fortitude (**Shift-X**) op 48, zie 8.4 | [G] TRAIN r. 810-827 |
| 60 | Sterkere rangen van Penance, Prayer of Healing, Power Word: Shield. Prayer of Spirit (blok D). Niets nieuws voor de rol | [G] TRAIN r. 852-872 |

**Beginner mistakes** (kandidaten; kies er 2-4)

| Fout | Bron |
|---|---|
| Dezelfde speler twee keer achter elkaar een schild willen geven. Weakened Soul houdt dat tegen. Hij geldt per speler: een ander kun je wel meteen een schild geven | [G] DB2 `Spell` 17; WFG-D "Weakened Soul is per target"; CWF-D "Weakened Soul only locks out the player it's on" |
| Penance op een vijand om je groep te healen. Dat doet hij niet: Penance healt óf doet schade | [G] CWF-K "Penance heals or damages its target; dealing damage doesn't heal your allies"; DB2 `Spell` 402174 |
| Penance laten liggen. Hij is elke 12 s klaar | [G] WFF-D "Sitting on Penance"; DB2 cooldown |
| Prayer of Healing op de verkeerde speler. Hij healt de groep van de speler die je kiest | [G] DB2 `Spell` 596 "heals the target and their party"; WFG-D; WH-H; CWF-D |
| Inner Focus bewaren voor nood. Gebruik hem vaak: het is een gratis dure heal | [G] WH-D "Try not to save this for emergencies"; WFG-D |
| Iedereen uit gewoonte een schild geven. Elk schild kost mana | [G] WFF-D |
| Shadow Word: Death (**Shift-4**) als opener. Sterft de vijand niet, dan verlies je 30% van je health | [G] CWF-D "never open with it"; DB2 `SpellEffect` 1309595 index 2 = 30 |

Geen fout (meer): een schild op een Warrior- of beer-tank. Zie 6.7.

### 5b. Holy: healer (band 2)

**Intro-feiten**
- [G] Healen vanaf level 1 (zelfde startspells als Discipline).
- [G] Holy is de groeps-healer. IV-HG: "Holy thrives during AoE healing phases"; "very beginner-friendly".
- [G] Alleen levelen gaat traag. IV-HG: "they lack tools to solo level effectively … it is a better idea to primarily
  use Shadow talents until you're able to get into group content". POL: "Holy is the dungeon healer and slower alone".
  WC: "Guides don't recommend Holy for leveling".
- [G] De eigen spells komen laat: Holy Nova vanaf 20, Prayer of Mending vanaf 40 (tabel 2).

**Simple order, in een groep**

| # | Stap (toets) | Bron |
|---|---|---|
| 1 | Renew (**F4**) op de tank als de pull begint | [G] WH-H "Keep Renew on the tank"; CWF-H "Renew the tank as the pull starts" |
| 2 | Prayer of Mending (**Ctrl-2**, vanaf 40) op de tank vóór de pull, en steeds opnieuw | [G] CWF-H "put Prayer of Mending on the tank before the pull"; WH-H; cooldown 10 s: DB2 |
| 3 | Heal / Greater Heal (**C**) voor gewone schade | [G] WH-H "Cast Heal as the main heal"; CWF-H; IV-H |
| 4 | Flash Heal (**F2**, vanaf 20) als C te laat zou komen | [G] CWF-H "Flash Heal when Heal would land too late"; IV-H "in an emergency"; WH-H |
| 5 | Hele groep gewond: Holy Nova (**Shift-1**, talent vanaf 20) als ze vlak bij je staan, anders Prayer of Healing (**Shift-2**, vanaf 30) | [G] CWF-H; WH-H. ⚠️ IV-H raadt Holy Nova als groeps-heal af: zie 6.14 |
| 6 | Power Word: Shield (**Z**) om tijd te winnen | [G] IV-H stap 1 "if you need to buy time"; WH-H |
| 7 | Valt een vijand jou aan: Fade (**F**) | [G] WH-H "If you pull aggro, cast it"; DB2 `Spell` 586 |

[A] De volgorde 1-7 als één lijst is mijn samenvoeging. IV-H heeft Prayer of Mending niet in zijn lijst.

**Simple order, alleen**

[G] IV-H, letterlijk: Fortitude en Inner Fire aan; Power Word: Shield (**Z**); Smite (**1**) terwijl de vijand komt; Mind
Blast (**3**); Shadow Word: Pain (**2**); dan de wand (**5**).
[G] CWF-H vanaf 20: "Open quest mobs with Holy Fire and follow with Smite" (Holy Fire = **4**).

**Per 10 levels**

| Level | Nieuw voor deze rol | Bron |
|---|---|---|
| 10 | Zelfde als Discipline op 10. Daarna Inner Fire 12, Cure Disease 14, Heal 16, Dispel Magic 18 | [G] TRAIN |
| 20 | Holy Nova (**Shift-1**, talent): instant; schade op vijanden om je heen en healing voor je groep; geen threat. Flash Heal (**F2**), Holy Fire (**4**), Fear Ward (blok D). Daarna: Holy Binding (passief talent) vanaf 25: Flash Heal op een ander healt jou voor de helft | [G] DB2 `Spell` 15237; tabel 2 |
| 30 | Prayer of Healing (**Shift-2**), Divine Spirit (blok D). Spirit of Redemption (passief talent). Daarna: Abolish Disease (**Shift-C**) op 32, Spiritual Healing (passief) vanaf 35 | [G] TRAIN; tabel 2 |
| 40 | Prayer of Mending (**Ctrl-2**, talent, eist Spirit of Redemption): healt zodra het doelwit schade krijgt en springt dan door, tot 5 keer; cooldown 10 s. Greater Heal neemt **C** over. Lightwell (blok D), zie 8.3 | [G] DB2 `SpellCooldowns` 401859 = 10000 ms, `SpellEffect` 5 sprongen; TRAIN r. 775 |
| 50 | Sterkere rangen van Prayer of Mending, Holy Nova (52), Prayer of Healing, Renew. Prayer of Fortitude (**Shift-X**) op 48, zie 8.4 | [G] TRAIN |
| 60 | Sterkere rangen van Prayer of Mending, Holy Nova, Prayer of Healing. Prayer of Spirit (blok D). Niets nieuws voor de rol | [G] TRAIN |

Inner Focus (**F1**) is een Discipline-talent. Een Holy-speler krijgt hem alleen met 10 punten in Discipline (CWF-H neemt
hem pas op 60). [G] tabel 2.

**Beginner mistakes** (kandidaten)

| Fout | Bron |
|---|---|
| Prayer of Healing op de verkeerde speler. Hij healt de groep van de speler die je kiest | [G] DB2 `Spell` 596; WH-H "heals the party of the target you cast it on, not your own party"; WFG-H |
| Flash Heal voor alles gebruiken. Hij is snel maar duur; hij is voor nood | [G] IV-H "reserve the use of Flash Heal for emergencies only"; WH-H "It is expensive" |
| Holy Nova om de groep te healen terwijl ze ver weg staan. Hij werkt alleen vlak om je heen, en hij is duur | [G] DB2 `Spell` 15237 (om de caster heen); IV-H "this spell is costly"; CWF-H "if they're next to you" |
| Prayer of Mending niet opnieuw zetten. Elke 10 s kan hij weer | [G] WFG-H "Recast Prayer of Mending the moment it's ready" |
| Alleen levelen en vinden dat het traag gaat. Dat hoort bij Holy: quest met Smite en de wand, heal in dungeons | [G] IV-HG; POL; WC |
| Na een heal nog een spell casten om een vijand af te maken. Maak af met de wand (**5**): die kost geen mana | [G] IV-H "use your wand to finish off a foe"; IV-HG |

### 5c. Shadow: damage from a distance (band 3)

**Intro-feiten**
- [G] Shadow Word: Pain op 4, Mind Blast op 10 (TRAIN). Mind Flay is een talent, 20 op zijn vroegst; Shadowform een
  talent, 40 op zijn vroegst (tabel 2).
- [G] De meeste gidsen noemen Shadow de beste keus om alleen te levelen: IV-S, POL ("fastest kills and least drinking"),
  CWF-S, BP ("All three experts finish leveling as Shadow"). Over de levels vóór 40 zijn ze het oneens: zie 6.1.
- [G] Vroeg doet de wand veel van het werk. IV-S: "About 40 to 50% of your total damage early on will come from
  auto-shoot". MET en BP zeggen hetzelfde.
- [G] Shadow heeft geen spell die veel vijanden tegelijk raakt. IV-S: "No AoE abilities".
- [G] Een Shadow-priest kan in dungeons nog healen, maar niet in Shadowform (MET: "Can heal dungeons (even when Shadow
  spec)"; DB2 `Spell` 15473).
- [G] **DoT** = schade in stukjes over een paar seconden (Shadow Word: Pain, Devouring Plague). **Channel** = een spell
  die werkt zolang je stilstaat (IV-S: "you must stand still while it channels").

**Simple order** (één vijand, alleen)

| # | Stap (toets) | Bron |
|---|---|---|
| 1 | Power Word: Shield (**Z**) op jezelf, als de vijand je gaat bereiken | [G] IV-S stap 1 (met "Drop this step if the enemy isn't attacking you"); CWF-S; MET |
| 2 | Mind Blast (**3**) als opener, van ver | [G] IV-S "Cast Mind Blast to pull the enemy"; CWF-S "open with Mind Blast from max range"; MET; MOB |
| 3 | Shadow Word: Pain (**2**) | [G] IV-S; CWF-S; MET |
| 4 | Devouring Plague (**Shift-3**, vanaf 20) op een vijand die lang leeft | [G] IV-S stap 4 (weglaten bij weinig mana); CWF-S "on anything that will live a while" |
| 5 | Mind Flay (**1**, talent vanaf 20), en laat hem uitlopen. Daarvóór: Smite (**1**) | [G] IV-S stap 5 en "Before learning Mind Flay, you can use Smite"; CWF-S "letting each channel finish" |
| 6 | Afmaken met de wand (**5**) | [G] IV-S stap 6; MET; MOB; BP |
| + | Shadow Word: Death (**Shift-4**, vanaf 32) alleen als de vijand er dood van gaat | [G] CWF-S; IV-S; WFG-S; WFF-S; zie 6.3 |
| + | Vampiric Embrace (**Ctrl-3**, vanaf 25) op een vijand die lang leeft | [G] CWF-S "on any enemy that takes a while to kill"; BP "on hard fights" |
| + | Shadowform (**Ctrl-1**, vanaf 40) aan vóór de eerste pull, en aan laten | [G] CWF-S "shift into Shadowform before the first pull … stay in it between pulls" |
| + | Silence (**E**, vanaf 30) op een vijand die cast | [G] CWF-S "Silence a caster that is about to heal or fear" |

- [G] Weinig mana: sla Devouring Plague en Mind Flay over en gebruik eerder de wand (IV-S: "Drop these steps if you're
  running out of mana").
- [G] Waarom de wand als laatste: na elke spell die mana kost, staat je mana-herstel 5 seconden stil (IV-S: "Mana regen
  stops for 5 seconds every time you spend mana"). De wand kost geen mana.
- [G] In een groep: Mind Blast geeft veel threat (DB2 `Spell` 8092: "but causes a high amount of threat"). Zie 6.4.

**Per 10 levels**

| Level | Nieuw voor deze rol | Bron |
|---|---|---|
| 10 | Mind Blast (**3**), cooldown 8 s. Je hebt al: Smite (**1**), Shadow Word: Pain (**2**), Power Word: Shield (**Z**), Fade (**F**), de wand (**5**). Daarna: Inner Fire (**Shift-Z**) op 12, Psychic Scream (**V**) op 14 | [G] TRAIN; DB2 `SpellCooldowns` 8092 = 8000 ms |
| 20 | Mind Flay (talent): neemt toets **1** over van Smite. Devouring Plague (**Shift-3**): een DoT die jou healt, cooldown 24 s. Daarna: Vampiric Embrace (**Ctrl-3**, talent) vanaf 25: je groep krijgt 20% van je Shadow damage als healing; cooldown 30 s | [G] BLOK r. 22; DB2 `Spell` 2944, `SpellCooldowns` 2944 = 24000 ms, 15286 = 30000 ms, `SpellEffect` 15286 = 20; duur 30 s: CWF-K tooltip |
| 30 | Silence (**E**, talent): je interrupt; cooldown 45 s. Mind Control (**Shift-F**). Daarna: Shadow Word: Death (**Shift-4**) op 32: instant, cooldown 18 s. Levitate (**R**) op 34 | [G] DB2 `SpellCooldowns` 15487 = 45000 ms, 1309595 = 18000 ms; TRAIN |
| 40 | Shadowform (**Ctrl-1**, talent, eist Vampiric Embrace): 10% meer Shadow damage, Shadow spells half zo duur, 15% minder fysieke schade; geen healing spells. Daarvóór: Darkness (passief) vanaf 35 | [G] DB2 `Spell` + `SpellEffect` 15473; `TraitEdge` r. 42 |
| 50 | Sterkere rangen van Mind Flay, Mind Blast, Shadow Word: Pain, Devouring Plague, Shadow Word: Death. Prayer of Fortitude (**Shift-X**) op 48, zie 8.4 | [G] TRAIN |
| 60 | Sterkere rangen van Mind Flay en Devouring Plague. Niets nieuws voor de rol | [G] TRAIN r. 855, 863 |

**Beginner mistakes** (kandidaten)

| Fout | Bron |
|---|---|
| Shadow Word: Death (**Shift-4**) op een vijand met veel health. Sterft hij niet, dan verlies je 30% van je eigen health | [G] DB2 `SpellEffect` 1309595 index 2 = 30; IV-S; CWF-S; WFG-S; WFF-S |
| Mind Flay afbreken. Met Improved Mind Flay is de laatste tik de sterkste | [G] DB2 `Spell` 1225139; CWF-S; WFG-S "Don't clip Mind Flay"; WFF-S |
| Een vijand afmaken met spells. Doe het met de wand (**5**): dan komt je mana eerder terug | [G] IV-S (5-seconden-regel); MOB; BP; WC |
| Healen in Shadowform. Dat kan niet. Power Word: Shield (**Z**) werkt wel in Shadowform | [G] DB2 `Spell` 15473; WFG-S "Power Word: Shield works in Shadowform"; CWF-S. Staat al in HTP r. 273 |
| Psychic Scream (**V**) bij andere vijanden in de buurt. Bange vijanden rennen weg en halen er meer bij | [G] IV-S "feared mobs will likely run around and aggro other mobs"; CWF-S; WC |
| In een groep openen met Mind Blast (**3**). Hij geeft veel threat; laat de tank eerst. Valt een vijand jou aan: Fade (**F**) | [G] DB2 `Spell` 8092; WFF-S; IV-S over Fade |

Staat al in `CLASSES.PRIEST` (HTP r. 273-277), dus niet herhalen tenzij de schrijver het wil: healen in Shadowform,
Smite missen na Mind Flay, Shoot zonder wand, geen interrupt vóór Silence, Shackle Undead alleen op Undead.

---

## 6. Waar de gidsen het oneens zijn

1. **Welke boom vóór level 40 (alleen levelen).**
   - Shadow vanaf 10: IV-S (hoofdroute), POL, CWF-S, WC, Kargoz in BP.
   - Eerst Discipline, op 40 omzetten naar Shadow: MOB ("The fastest way to level isn't Shadow from level 10"),
     Hydramist en EjrSP in BP. IV-S noemt dit als tweede keus ("Respec at 40 Route", kost 1 gold).
   - MET: een eigen build tot 39 en "At Level 40 … I recommend re-speccing to Shadow". De build zelf kon ik niet lezen
     (de talentrekenaar kwam niet mee). [A] Het is geen diepe Shadow-build: MET zegt dat Mind Flay pas op 40 komt en
     noemt "until reaching Penance and then later Shadowform".
   - [A] Schrijf voor Shadow dus niet "de snelste vanaf 10". Wel veilig: "most guides level as Shadow; some play
     Discipline until 40".
2. **Eerste talentpunten.** Wand Specialization eerst: IV-S, BP, MOB, CWF-D. Spirit Tap eerst: CWF-S, POL, WC.
3. **Shadow Word: Death.** MET: "Shadow Word: Death on cooldown". Alle anderen: alleen als afmaker (IV-S, CWF-S, WFG-S,
   WFF-S, BP). MOB noemt nog 10% terugslag; dat is oud. Sinds Blizzards notes van 2 nov is het 30% (CWF-K), en DB2 70938
   zegt 30.
4. **Mind Blast als opener.** Alleen: ja (IV-S, CWF-S, MET, MOB, BP). In een groep: niet, om de threat (WFF-S: "Opening
   with Mind Blast on a fresh pull"; WFG-S: "unless threat is a problem for your tank").
5. **Schild vóór elke pull.** BP: Hydramist "ideally yes", Kargoz "do not shield every pull automatically". IV-S: laat
   weg als de vijand je niet bereikt.
6. **Flash Heal.** Alleen in nood: IV-D, IV-H, WH-H. Vaker: WFF-D ("Into the gap until Penance is back").
7. **Schild op een Warrior- of beer-tank.** WH-D20 (beta): "Skip this if they are a rage-based tank". Nieuwer: WH-H
   (31 okt) "rage users still generate rage through the absorb, so it is safe to use on a tank"; CWF-K (Blizzard):
   "Shields no longer reduce Warrior Rage". [A] Het nieuwste wint: het mag.
8. **Vampiric Embrace: level 25 of 30.** 25: DB2-rij (15 punten), IV-S ("25: Earliest Vampiric Embrace"), CWF-S.
   30: DB2 `SpellLevels` 15286 BaseLevel 30; WFG-S "Learned at level 30"; WC: "Wowhead's tooltip says Vampiric Embrace
   needs level 30 … If the game lets you take it earlier, take it at 27". Open, zie 8.2.
9. **Binding Heal bestaat niet meer.** Nog genoemd door WH-H, IV-HG en POL. Blizzard verving hem op 2 nov door Holy
   Binding (CWF-K). DB2 70938: de boom heeft Holy Binding (1328569), geen Binding Heal. Niet noemen.
10. **Prayer of Mending.** Blizzard: één per doelwit. Tooltip: één per priest (CWF-K; DB2 `Spell` 401859: "can only be
    placed on one target at a time per caster"). Schrijf dit niet stellig.
11. **Cooldown van Divine Grace en Contingency Plan.** Client: 10 min (DB2 600000 ms). Blizzards gids: 5 min (CWF-K).
    HTP zegt 10 min: dat klopt met de client.
12. **POL: "Mental Strength telt niet mee voor de Discipline-rijen".** In DB2 70938 telt hij wel mee. POL is op een
    beta-build gecontroleerd.
13. **wowforeverforge noemt Shadowfiend.** Die zit niet in de boom en niet in TRAIN. Niet overnemen.
14. **Holy Nova als groeps-heal.** Ja, als de groep vlak bij je staat: CWF-H ("Holy Nova if they're next to you"), WH-H
    ("Cast Holy Nova if the group is stacked and you need a threat-free group heal"). Liever niet: IV-H en IV-D ("this
    spell is costly and should be avoided if you're looking to do a group heal"; alleen "if Searing Light procs and no
    one is in imminent danger"). [A] Veilig voor de tekst: Prayer of Healing is de groeps-heal; Holy Nova alleen als
    iedereen vlak bij je staat, en hij kost veel mana.

---

## 7. Getallen, gemeten in DB2

[G] DB2 `SpellCooldowns` (ms), rang 1:

| Spell (id) | Cooldown |
|---|---|
| Power Word: Shield (17) | 4 s |
| Mind Blast (8092) | 8 s |
| Penance (402174) | 12 s |
| Prayer of Mending (401859) | 10 s |
| Shadow Word: Death (1309595) | 18 s |
| Devouring Plague (2944) | 24 s |
| Vampiric Embrace (15286) | 30 s |
| Fade (586), Psychic Scream (8122) | 30 s |
| Silence (15487) | 45 s |
| Inner Focus (14751), Power Infusion (10060), Fear Ward (6346) | 3 min |
| Holy Nova (15237), Holy Fire (14914), Mind Flay (15407) | geen |

[G] DB2 `SpellEffect`: Shadow Word: Death terugslag 30%; Shadowform +10 / -50 / -15 / +100; Soul Warding -4000 ms en -15%;
Inner Focus -100% mana en +25% crit; Power Infusion 20%; Vampiric Embrace 20%; Holy Binding 50%; Prayer of Mending 5
sprongen; Wand Specialization 25; Twilight Focus 70; Improved Mind Flay 20.

Niet uit DB2 gehaald (alleen uit tooltips in CWF-K, build 70862): duur van Power Infusion (15 s), Vampiric Embrace
(30 s), Silence (5 s), Weakened Soul (15 s), Spirit of Redemption (15 s), Mind Flay (3 s, 50% trager).

---

## 8. Open punten en dingen die niet kloppen

1. **Niets is in de client getest.** Alles hierboven is data en gidsen.
2. **Vampiric Embrace op 25 of 30** (zie 6.8). De rij zegt 25, de spell zelf zegt level 30. Test: kan een priest van
   25-29 met 15 punten in Shadow het talent nemen? HTP r. 271 zegt nu 25.
3. **Lightwell op 40** staat niet in `ForeverTrainerData.lua` (hele priest-lijst gelezen; Greater Heal op 40 staat er
   wel, dus het zoeken werkte). Toch: DB2 `SpellLevels` 724 = level 40; FC (build 70938): "A Holy talent in Classic;
   trained without one now", 3 rangen vanaf 40; WCALC: "trained from a trainer here", rangen 40/50/60; CWF-H: "Greater
   Heal and Lightwell come at 40". Hij zit niet in de talentboom (geen van de 52 talenten). [A] De trainerlijst van MH
   mist hem waarschijnlijk. Voor de bouwchat.
4. **Prayer of Fortitude op 48** staat ook niet in TRAIN. DB2 `SpellLevels` 21562 = 48. WIKI geeft als bron
   "[Codex: Prayer of Fortitude]": een boek, niet de trainer. HTP r. 270 noemt alleen het level; dat klopt. Waar het
   boek vandaan komt, heb ik niet gemeten.
5. **Prayer of Shadow Protection op 56** (DB2 `SpellLevels` 27683 = 56; CWF-S) staat ook niet in TRAIN.
6. **`SPEC_MACROS`: Inner Focus heeft `level = 40`** (MAC r. 541). Dat is het level van de macro (die cast Greater Heal),
   niet van het talent (20). `ns.ForeverDirectionTalents` gebruikt dat getal als talent-level, dus "Do this now" kan
   Inner Focus op 40 tonen. Penance (level 30) staat in `CLASS_MACROS`, niet in `SPEC_MACROS`, en komt daardoor niet in
   die lijst. Voor de bouwchat; ik heb niets veranderd.
7. **Dual spec op 40**: CWF-D en BP zeggen dat Blizzard dit bevestigt. Niet zelf gemeten; niet gebruiken zonder meting.
8. **Welke ras-spell bij welke rol past** is niet gemeten in een gids.
9. Een losse node 105865 (Holy Specialization, PosY 21300) hangt buiten de boom. De zichtbare is 110855. Geen gevolg
   voor de tekst.
10. Litany of Light: DB2 `SpellEffect` zegt 20, CWF-K (build 70862) zegt 5% per rang. Getal niet noemen.

---

## 9. Wat AFGELEID is, op een rij

- De kolom "vroegste level" van elk talent (10 + punten). De punten zelf zijn gemeten.
- Dat er drie rolblokken nodig zijn (uit de code `r.band == band`), en de titels.
- De samengevoegde "Simple order"-lijsten van Discipline en Holy in een groep (de losse stappen zijn gemeten).
- Dat toets C vanaf 40 alleen Greater Heal is.
- Dat een schild op een rage-tank mag (nieuwste twee bronnen tegen één oude).
- Dat `ForeverTrainerData.lua` Lightwell mist.
- Dat de build van Method tot 39 geen diepe Shadow-build is (6.1).
- De veilige zin over Holy Nova (6.14) en over "most guides level as Shadow" (6.1).
- Dat één verwijzing naar de ras-lijst genoeg is voor X en Shift-R (hoofdstuk 3).
