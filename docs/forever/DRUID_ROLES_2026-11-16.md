# Druid per rol — feiten (WoW Forever, build 1.60.1.70938)

Onderzoek mh-research, 16 nov 2026 (Bouwchat 16-11 (2)), voor druid stap 2 (Rob via Sparring 16-11, letterlijk "ja":
per rol een eenvoudige volgorde en per 10 levels wat er verandert; rol van de speler bovenaan, de rest inklapbaar).
Elke regel zegt GEMETEN (bron) of AFGELEID. Niets is in het spel gezien.

**Grootste vondst:** de talentboom van Forever is NIET die van classic. De oude `Talent`-tabel in DB2 heeft nog de classic
rijen; de boom die het spel gebruikt staat in de Trait-tabellen (TraitTree 1089). Alles over talenten hieronder komt daaruit.

**Bronnen:**
- [DB2] wago.tools CSV wowf 1.60.1.70938 (SkillLineAbility, SpellLevels, Spell, SpellName, SpellShapeshift,
  SpellCooldowns, SpellPower, SpellMisc, TraitNode, TraitNodeEntry, TraitDefinition, TraitEdge, TraitCond,
  TraitNodeGroupXTraitNode, TraitCurrency, TraitCurrencySource, TalentTab), gelezen 16 nov 2026.
- [WH] Wowhead Forever tooltip-JSON, 16 nov 2026.
- [ZT] Zygor Forever `Data-Forever/Skill_Training.lua` (trainerlijst, OUDERE build; zie conflicten).
- [ZB] Zygor Forever `Guides-Forever/TalentAdvisor-Builds.lua` + `Code-Forever/TalentAdvisor-Data.lua`.
- [WT-L] Warcraft Tavern Forever Druid Leveling; [WT-F] Feral; [WT-R] Restoration (deels verouderd: noemt Gift of the
  Earthmother, niet in de 70938-boom); [WT-PS] "Powershifting is Back (Sort of)", 30 sep 2026 (beta).
- [MG] method.gg Forever Druid Leveling, bijgewerkt 14 nov 2026.
- Icy Veins en Mobalytics gaven 403: alleen zoekfragmenten, zo gemarkeerd.
- Alle gidsclaims = AFGELEID (spelersgidsen voor Forever).

## 0. Voor alle vier de rollen

| Feit | Status / bron |
|---|---|
| Talentpunten: 1 per level van 10 t/m 60, 51 totaal | GEMETEN [DB2] TraitCurrencySource (currency 3820), TraitCurrency SourcedMax 51; Zygor-builds hebben 51 regels [ZB] |
| "Talented" (1225474): punten tot 5 levels eerder, max 51 | GEMETEN [DB2]; hoe je het vrijspeelt NIET GEMETEN. Met dit perk kan elk "vroegste level" hieronder tot 5 lager zijn |
| Tier-drempels: t2 = 5 punten, dan 10/15/20/25, t7 = 30; tellen alleen punten in díe sectie | GEMETEN [DB2] TraitCond |
| Vroegste level per tier zonder "Talented": t1 10, t2 15, t3 20, t4 25, t5 30, t6 35, t7 40 | AFGELEID |
| Secties links→rechts: Balance, Feral, Restoration; TalentTab OrderIndex 0/1/2 | GEMETEN [DB2] |
| MH BY_TREE: 1 = caster (Balance), 2 = melee (Feral), 3 = heal (Resto) + aparte tank-regel; beer en kat beide band 2 | klopt met GEMETEN volgorde |
| Verhuisd t.o.v. classic: Insect Swarm → Balance; Furor → Feral; Heart of the Wild en Natural Shapeshifter → Resto | GEMETEN [DB2] |
| Zygor-Feral zet ook punten in Resto/Balance; Zygor-Resto begint met 5× Improved Wrath (Balance) → vroege Resto kan op punten "Balance" lijken | GEMETEN [ZB]; effect op MH AFGELEID |

**Vormen** (GEMETEN [DB2] SpellShapeshift):
- Heals (Healing Touch, Rejuvenation, Regrowth, Swiftmend, Wild Growth, Nature's Swiftness) werken NIET in Moonkin, Cat
  of Bear (alleen caster/Tree of Life). Wowhead Moonkin-tooltip: "prevents the use of healing spells".
- Wrath, Moonfire, Starfire, Hurricane, Insect Swarm werken in Moonkin. Rebirth, Innervate, Remove Curse, Cure Poison,
  Abolish Poison ook.
- Faerie Fire: caster, Cat, Bear, Dire Bear, Moonkin; NIET in Travel of Aquatic Form (mask 0x40000091).
- Omen of Clarity = passief op 20 (trainer), geen knop (GEMETEN [DB2] SpellMisc, SkillLineAbility; [ZT]).

## 1. BEER = tank (vanaf 10, Bear Form-quest)

**Eenvoudige volgorde** (AFGELEID uit [WT-L], [MG]):
1. Trekken met Faerie Fire **5** (18+) of Feral Charge **E** (20+; 8-25 yard [WH]).
2. Demoralizing Roar **Shift-2** één keer.
3. Primal Bite **3** steeds als hij klaar is (40+, 6 s cd, 20 Rage [WH]).
4. Lacerate **2** tot 5 stapels (25+).
5. Rage over: Maul **1** op één doel, Swipe **Shift-1** op 2+ (16+).
6. Growl **F** als een vijand iemand anders slaat.

| Lvl | Wat verandert | Toets | Status |
|---|---|---|---|
| 10 | Bear Form, Maul, Growl, Demoralizing Roar. t1 Feral: Ferocity, Furor | Ctrl-1, 1, F, Shift-2 | GEMETEN |
| 12-18 | Enrage 12 (10 Rage + 20 over 10 s, cd 1 min, armor −27%), Bash 14, Swipe 16, Faerie Fire + Maul r2 op 18 | Q, V, Shift-1, 5 | GEMETEN |
| 15 | t2: Thick Hide, Feral Instinct | - | boom GEMETEN, level AFGELEID |
| 20 | Feral Charge (talent t3): charge, root + interrupt 4 s, cd 15 s, 5 Rage. Demoralizing Roar r2 | E | GEMETEN |
| 25 | Lacerate (talent t4, na Savage Fury): 15 Rage, bloeding, 5×. Trainer-ranks 34/42/50/58. Challenging Roar 28 | 2, Shift-F | GEMETEN |
| 30 | Leader of the Pack (t5). Bash r2 | - | boom GEMETEN, level AFGELEID |
| 35 | Natural Reaction, Rend and Tear (t6). Frenzied Regeneration 36 (Rage → leven, cd 3 min) | X | GEMETEN |
| 40 | Dire Bear Form (vervangt Bear Form). Primal Bite (talent t7, na Leader of the Pack) | Ctrl-1, 3 | GEMETEN |
| 44 | Barkskin | Z | GEMETEN |
| 50/60 | Primal Bite r2/r3; Lacerate r4 50, r5 58; Maul 50/58 | - | GEMETEN |

Tijdens het levelen: [WT-L] beer = hybride binnen Feral, kat het soepelst; [MG] beer = gereedschap 10-20, tanken in
dungeons. AFGELEID: solo als beer kan, maar trager; tanken is voor groepen.

Beginnersfouten: Feral Charge binnen 8 yard (werkt niet); Enrage bij zware klappen (minder armor); Frenzied
Regeneration zonder Rage (doet niets); Growl op een vijand die jou al slaat (doet niets); bear-weaving/powershifting
werkt niet zoals classic.

## 2. KAT = schade van dichtbij (vanaf 20, Cat Form-quest; Prowl erbij)

**Eenvoudige volgorde** (AFGELEID uit [WT-L], [MG]):
1. Prowl **Shift-R**, open met Shred **3** van achteren.
2. Faerie Fire **5** op taaie vijanden.
3. Rake **2** (24+); niet als de vijand bijna dood is.
4. Claw **1** voor combo points; Shred **3** als je achter de vijand staat.
5. Bij 4-5 combo points: Rip **4** als de vijand lang leeft, anders Ferocious Bite **Shift-4** (24+).
6. Shifting Power **Q** als je Energy onder 50 is (40+).

| Lvl | Wat verandert | Toets | Status |
|---|---|---|---|
| 20 | Cat Form, Claw, Shred (van achteren), Rip, Prowl. Feral Charge (Cat): sprong achter de vijand. Omen of Clarity passief | Ctrl-2, 1, 3, 4, Shift-R, E | GEMETEN ([ZT] Shred 22 = oudere data) |
| 24 | Rake, Ferocious Bite (r1, id 1328618, 35 Energy) | 2, Shift-4 | GEMETEN ([ZT] FB 32 = ouder) |
| 26-28 | Dash 26, Cower 28, Claw + Rip r2 28 | R, F | GEMETEN |
| 25-35 | Blood Frenzy, Predatory Discipline (t4), Leader of the Pack (t5), Rend and Tear (t6) | - | boom GEMETEN, levels AFGELEID |
| 32 | Ravage (opener uit Prowl, van achteren). Poised (passief; hoe geleerd NIET GEMETEN) | Ravage: blok D | GEMETEN |
| 36 | Pounce (uit Prowl, stun) | V | GEMETEN |
| 40 | Shifting Power (talent t7, na Predatory Discipline): 40 Energy voor 55% basismana, cd 8 s, alleen Cat. Prowl r2 | Q | GEMETEN |
| 50/60 | ranks (FB 48/56/60, Rip 52/60, Shred 54) | - | GEMETEN |

Tijdens het levelen: ja, eerste keus van de gidsen ([MG] "fastest and most popular", [WT-L] "smoothest").

Beginnersfouten: oud powershiften (Furor geeft nu de Energy terug die je had toen je Cat verliet, geen nieuwe; [WT-PS]:
niet meer zinvol, Shifting Power vervangt het); Shifting Power te vaak (geen mana meer om te healen [MG]); Shred van
voren (moet van achteren; gebruik Claw); Rip/Rake op een vijand die bijna dood is. Tiger's Fury bestaat niet als
trainerspell in Forever (AFGELEID).

## 3. BALANCE = caster-schade (vanaf 1; Moonkin Form = talent, vroegst 40)

**Eenvoudige volgorde** (AFGELEID uit [MG], [WT-L]):
1. Moonfire **2**.
2. Insect Swarm **4** (25+).
3. Wrath **1** als vuller. Met Eclipse (30+): Wrath bouwt ladingen op, dan Starfire **3**.
4. Starfire **3** (20+) als opener op één vijand.
5. Hurricane **Shift-1** op groepen (40+).
Weinig mana: Wrath blijven gebruiken (goedkoop) — Mobalytics-fragment, AFGELEID.

| Lvl | Wat verandert | Toets | Status |
|---|---|---|---|
| 1-10 | Wrath 1, Moonfire 4, Thorns 6, Entangling Roots 8, Nature's Grasp 10. t1: Improved Wrath, Genesis | 1, 2, Shift-Z, V, X | GEMETEN |
| 15 | t2: Moonglow, Improved Moonfire, Nature's Majesty, Nature's Reach | - | boom GEMETEN, level AFGELEID |
| 20 | Starfire. Omen of Clarity passief. t3: Nature's Splendor, Improved Entangling Roots | 3 | GEMETEN |
| 25 | Insect Swarm (talent t4; DB2 zegt "requires 20", tier-drempel geeft 25, [MG] 25). Ranks 30/40/50/60 | 4 | boom GEMETEN, 25 AFGELEID |
| 30 | Eclipse (t5, 3 ranks): Wrath maakt je volgende 2 Starfires sneller; max 4 ladingen, 15 s. Nature's Grace | - | GEMETEN |
| 40 | Moonkin Form (t7): kost 35% basismana; groep +3% crit; geen heals. Hurricane (trainer). Innervate | Ctrl-3, Shift-1, F1 | GEMETEN |
| 44-60 | Barkskin 44; Hurricane 50/60; Starfire 42/50/58/60 | Z | GEMETEN |

Tijdens het levelen: werkbaar maar trager ([MG]). Zygor-Balance neemt Moonkin pas op 53 [ZB]: "Moonkin op 40" is
geen moet.

Beginnersfouten: healen in Moonkin (kan niet; uit de vorm gaan kost mana); naar een Omen of Clarity-knop zoeken
(passief).

## 4. RESTORATION = healer (vanaf 1)

**Eenvoudige volgorde (groep)** (AFGELEID uit [WT-R]):
1. Rejuvenation **F4** op de tank.
2. Regrowth **F2** op iemand die laag staat.
3. Swiftmend **Shift-F1** (25+, cd 15 s): alleen op iemand met jouw Rejuvenation of Regrowth.
4. Wild Growth **Shift-2** (40+, 3 s cast, cd 6 s, groep) als meer mensen schade krijgen.
5. Healing Touch **C** bij grote schade. Nood: Nature's Swiftness **Shift-3** (30+), dan Healing Touch.
6. Innervate **F1** (40+) als je mana laag is.

| Lvl | Wat verandert | Toets | Status |
|---|---|---|---|
| 1-12 | Healing Touch 1, Rejuvenation 4, Regrowth 12, Revive 12 (buiten gevecht) | C, F4, F2, F3 | GEMETEN |
| 10-15 | t1: Nature's Focus, Heart of the Wild. t2: Naturalist, Reflection, Natural Shapeshifter | - | boom GEMETEN, levels AFGELEID |
| 14-26 | Cure Poison 14 (quest), Rebirth 20 (F3 in gevecht), Remove Curse 24, Abolish Poison 26. t3: Gift of Nature, Bloom | Shift-C, F3, Shift-V | GEMETEN |
| 25 | Swiftmend (talent t4) | Shift-F1 | boom GEMETEN, 25 AFGELEID |
| 30 | Nature's Swiftness (t5, cd 3 min), Living Spirit (t5). Tranquility (trainer) | Shift-3, Q | GEMETEN |
| 40 | Wild Growth (talent t7, 550 mana). Innervate | Shift-2, F1 | GEMETEN |
| 50/60 | Gift of the Wild 50/60; Wild Growth r2/r3 | Shift-X | GEMETEN |

Tijdens het levelen: solo niet aanbevolen ([WT-L]: vijanden gaan langzaam dood). AFGELEID: level met Wrath en
Moonfire, heal in dungeons. Zygor-Resto begint met schadetalenten [ZB].

Beginnersfouten: healen in een vorm (kan niet); een HoT overschrijven die nog loopt; Tranquility te vroeg stoppen; HoTs
niet vóór de schade. ⚠️ [WT-R] raadt downranking aan, maar **MH's toetsen casten altijd de hoogste rank**: geen
downranking aanraden.

## 5. Forever versus classic

Nieuw/anders in Forever (GEMETEN [DB2]): Lacerate (Feral t4, 25), Primal Bite (Feral t7, 40; Forever's Mangle voor de
beer), Shifting Power (Feral t7, 40), Feral Charge (t3, 20, beer én kat), Swiftmend (t4, 25), Wild Growth (t7, 40),
Eclipse (Balance t5, 30), Revive (12), Omen of Clarity (basis-passief 20), nieuwe passieve talenten (Genesis, Nature's
Majesty, Nature's Splendor, Bloom, Living Spirit, Natural Instinct, Natural Reaction, Rend and Tear, Predatory
Discipline, Overgrowth).

Niet in Forever voor zover gemeten (AFGELEID): Mangle, Savage Roar, Starfall, Starsurge, Sunfire, Lifebloom, Nourish,
Living Seed, Efflorescence, Berserk, Skull Bash, Survival Instincts, Faerie Fire (Feral), Tiger's Fury.

Conflicten DB2 70938 vs Zygor [ZT] (ouder): Shred 20 vs 22; Ferocious Bite 24 vs 32; Lacerate talent 25 vs trainer 42;
Primal Bite 50/60 vs 36/48/60. Gebruik DB2.

## 6. Correcties op de DRUID-tekst in ForeverHowToPlay.lua

1. "18: Faerie Fire on 5 (works in every form)" → niet in Travel of Aquatic Form (GEMETEN SpellShapeshift).
2. "20: Cat Form … with Claw, Rip and Prowl" → ook Shred op 20; Feral Charge (talent) vanaf 20.
3. Overige levels in die tekst kloppen met [DB2].

## 7. Spells zonder toets op het blok

Ravage, Teleport: Moonglade, Track Humanoids, Elune's Light → blok D. Omen of Clarity, Poised → passief.
