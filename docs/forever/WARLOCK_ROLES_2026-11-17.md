# Warlock per rol (WoW Forever) — feitenbestand, 17 nov 2026

Voor: de beginnerstekst "per rol" in `Modules/ForeverHowToPlay.lua` (tabel `ROLES`, nog geen `WARLOCK`-rij: GEMETEN, de tabel heeft
nu DRUID, WARRIOR, MAGE, PRIEST). Gemaakt door mh-research. Alleen feiten; de tekst schrijft mh-writer.

**Labels.** GEMETEN = zelf gezien in een genoemde bron (DB2-build of codebestand). AFGELEID = beredeneerd. GIDS = staat in een
spelersgids (naam + datum), niet zelf gemeten.

**Bronnen**
- **DB2**: wago.tools CSV, product `wowf`, build **1.60.1.70938** (wago-datum 13 nov 2026; `run gamedata builds` noemt hem de
  nieuwste Forever-build). Tabellen: TalentTab, TraitTree, TraitNode, TraitNodeXTraitNodeEntry, TraitNodeEntry, TraitDefinition,
  TraitDefinitionEffectPoints, CurvePoint, TraitNodeGroup(+XTraitNode, +XTraitCond), TraitCond, TraitEdge, TraitTreeXTraitCurrency,
  TraitCurrency, TraitCurrencySource, SpellName, Spell, SpellEffect, SpellMisc, SpellCastTimes, SpellDuration, SpellCooldowns,
  SpellPower, SpellLevels, SpellAuraOptions, SpellTargetRestrictions, SpellReagents, SkillLine, SkillLineAbility, ItemSparse.
  Eén vergelijking met build **1.60.1.70862** (tabel Spell) voor Wrack en Soul Siphon.
- **MH-code** (gelezen 17 nov 2026): `Modules/ForeverHowToPlay.lua` (CLASSES.WARLOCK, ROLES), `ForeverBlock_Warlock.lua`,
  `ForeverMacros.lua` (DEFS warlock, SPEC_NAMES, TREE), `ForeverTrainerData.lua` (WARLOCK), `ForeverClassQuests.lua`
  (CHAINS.WARLOCK), `ForeverMainStats.lua`, `ForeverDirection.lua`.
- **Gidsen** (opgehaald 17 nov 2026):
  - [WT] Warcraft Tavern, "Warlock Leveling Guide" (Zephan) — geen datum of build op de pagina. De tekst kent de nieuwe Wrack
    ("twice as fast") en de Legacy-perk Talented.
  - [IV-A] [IV-D] [IV-X] Icy Veins, Affliction / Demonology / Destruction Warlock Leveling Guide (Abide) — "Last Updated: Nov 4, 2026".
  - [MC] Mobalytics, "Warlock Leveling Guide (Level 1-60)" (Crix) — "Updated on Nov 16, 2026".
  - [MK] Mobalytics, Kargoz' 1-60 Affliction- en Demonology-gids — datum niet gezien (alleen fragmenten gelezen).
  - [ME] Method.gg, "WoW Forever Warlock Leveling Guide & Talents" (Roguery) — "Last Updated: 16th November 2026".
  - [FW] foreverwow.com, Affliction Warlock Guide (Garazon) — "Spell build 1.60.1.70862, Updated 7 Nov".
  - Kleinere sites, alleen fragmenten: [SS] stillsixty.com, [GN] guided.news, [MU] muchamielwow.github.io, [FT] forever-tavern.com,
    [R60] roadto60forever.com (1-30), [WM] warcraftmaps.com (build 70685, "not tested"), wowtbc.gg (beta).
  - Wowhead Forever: NIET geraadpleegd (pagina's geven 403 aan scripts).

**Niet gedaan.** De twee voorbeeldbestanden (ROGUE_ROLES, MAGE_ROLES) heb ik NIET gelezen: mijn agentregel verbiedt lezen in
`MidnightHelper/docs/`. De indeling volgt de zeven punten van de opdracht en de vorm van `ROLES` in ForeverHowToPlay.lua.

---

## 1. Welke boom is welke band

| Band | Boom | Bewijs |
|---|---|---|
| 1 | **Affliction** | GEMETEN DB2 TalentTab: ID 302, ClassMask 256, **OrderIndex 0**. Band 1 = TraitNode PosX 1020-2820 in boom 1116; daar staan Suppression, Improved Corruption, Siphon Life, Wrack (GEMETEN). |
| 2 | **Demonology** | GEMETEN TalentTab ID 303, **OrderIndex 1**. Band 2 = PosX 5020-6820: Unholy Power, Demonic Sacrifice, Soul Link, Demonic Pact. |
| 3 | **Destruction** | GEMETEN TalentTab ID 301, **OrderIndex 2**. Band 3 = PosX 9080-10280: Bane, Shadowburn, Conflagrate, Incinerate. |

- GEMETEN DB2 TraitTree: rij ID **1116**, TraitSystemID 10. Boom 1116 heeft **52 nodes**: 17 (band 1) + 19 (band 2) + 16 (band 3).
  TraitTree zelf noemt geen class; dat 1116 de Warlock is staat in `ForeverMacros.lua` (`TREE.WARLOCK = 1116`, GEMETEN in code) en
  blijkt uit de inhoud van de nodes (GEMETEN).
- GEMETEN `ForeverMacros.lua`: `SPEC_NAMES.WARLOCK.enUS = { "Affliction", "Demonology", "Destruction" }`. De spec-macro's kloppen
  met de banden: spec 1 = Exhaustion (18223), Channels, Siphon Life (18265); spec 2 = Demon Sac (18788), HealthFunnel, Searing Pain;
  spec 3 = Bane Havoc (1225228), Shadowburn (17877), Nuke Picker (1293817).
- GEMETEN `ForeverMainStats.lua`: alle drie de banden hebben `role = "caster"`. Band 1: Spirit, Intellect. Band 2 en 3: Intellect, Stamina.
- AFGELEID: alle drie de bomen zijn "schade van afstand". Geen tank, geen healer. De demon vangt de klappen op als je alleen speelt.
- Voorstel voor de titels (AFGELEID, de schrijver kiest): "Affliction: damage over time", "Demonology: damage with your demon",
  "Destruction: damage with big hits".

## 2. Talentpunten: hoe "nodig" werkt (GEMETEN, tenzij anders gezegd)

- TraitCurrency 3820 hoort bij boom 1116. TraitCurrencySource: 1 punt per level van **10 t/m 60** = 51 punten (SourcedMax 51).
- Vijf extra bronregels "Talented Rank 1 (Level 9)" … "Talented Rank 5 (Level 5)": met de Legacy-perk Talented komen de punten tot
  5 levels eerder. [WT] zegt hetzelfde. Alle levels hieronder zijn **zonder** die perk ("at the earliest").
- Elke rij van een boom heeft een poort (TraitCond, SpentAmountRequired) = punten die al in de rijen erboven van **dezelfde boom**
  moeten zitten: rij 1 = 0, rij 2 = 5, rij 3 = 10, rij 4 = 15, rij 5 = 20, rij 6 = 25, rij 7 = 30.
- AFGELEID: vroegste level = 10 + punten nodig. Dus rij 1 = 10, rij 2 = 15, rij 3 = 20, rij 4 = 25, rij 5 = 30, rij 6 = 35, rij 7 = 40.
- Pijlen (TraitEdge, type 2): Amplify Curse → Curse of Exhaustion; Siphon Life → Wrack; Demonic Sacrifice → Soul Link → Demonic Pact;
  Master Summoner → Fel Domination; Intensity → Pyroclasm; Conflagrate → Fire and Brimstone; Bane of Havoc → Incinerate.
  AFGELEID: het eerste talent moet vol zijn (Master Summoner 2/2, Intensity 3/3). Niet in het spel getest; [WT] noemt ook "Master Summoner 2/2".
- **Rang-getallen: gebruik de CurvePoint-waarde, niet SpellEffect.** GEMETEN: TraitDefinitionEffectPoints (OperationType 0) wijst per
  effect een curve aan met (rang : waarde). De kale SpellEffect-waarde is vaak fout of alleen de hoogste rang. Voorbeelden:
  Improved Life Tap effect = 0, curve 10/20; Improved Bane of Agony effect = 2, curve 5/10; Improved Shadow Bolt effect = 0, curve 4..20.
  AFGELEID dat de client de curve gebruikt; de gidsgetallen kloppen ermee (IV: Suppression 4 punten = 4% hit en 16% minder threat = curve 4:4 en 4:-16).

## 3. De bomen: talenten met een knop, en de passieve kern

Alle getallen GEMETEN in DB2 70938 (curve-waarden per rang). Toetsen GEMETEN in `ForeverBlock_Warlock.lua`. "blok D" = geen vaste
toets; de speler zet hem op zijn eigen Alt-toetsen.

### 3a. Affliction (band 1)

**Met een knop**

| Talent (spell) | Rij / nodig | Vroegste level | Voorwaarde | Wat het doet | Toets |
|---|---|---|---|---|---|
| Amplify Curse (18288) | rij 3 / 10 | 20 | – | Volgende Curse of Weakness of Bane of Agony 50% sterker, of volgende Curse of Exhaustion "by 20%". Buff 30 s. Cooldown 3 min. Geen GCD. | Shift-3 |
| Curse of Exhaustion (18223) | rij 4 / 15 | 25 | Amplify Curse | Vijand 30% langzamer, 12 s. Instant. Kost 8% mana. Is een Curse. | R |
| Siphon Life (18265) | rij 5 / 20 | 30 | – | Rang 1: 11 health per 3 s van vijand naar jou, 30 s. Instant, 150 mana. Rangen 2-4 bij de trainer op 38, 48, 58 (ook in ForeverTrainerData). | F4 |
| Wrack (1316697) | rij 7 / 30 | 40 | Siphon Life | Kanaal van 6 s, schade elke seconde (basis 25,2 per tik), 200 mana. Tijdens het kanaal tikken jouw Siphon Life, Corruption en Bane of Agony op dat doel **100% sneller**. Geneest NIET. Eén rang. | blok D |

**Passief (kern)**
- Rij 1: **Improved Corruption** 5 (17810): cast −0,4 s per rang (2,0 s → instant op 5/5), schade +2..10%. **Suppression** 5 (18174):
  hit +1..5%, threat −4..−20%. **Improved Life Tap** 2 (18182): +10/20% mana.
- Rij 2: **Improved Drains** 3 (403511): Drain Life/Soul/Mana +7/13/20%. **Soul Harvest** 2 (437032): een vijand die XP geeft sterft
  met jouw Drain Soul erop → 10 s lang +50/100% mana-herstel, en 50/100% van je gewone mana-herstel loopt door tijdens casten. **Grim Reach** 2: bereik +10/20%.
- Rij 3: **Fel Concentration** 3 (17783): 23/47/70% kans dat een klap je Drain Life/Mana/Soul of Wrack niet inkort.
  **Pandemic** 3 (427712): crit-bonus van Corruption, Bane of Agony/Doom, de drains, Siphon Life en Wrack +33/67/100%.
  **Improved Bane of Agony** 2: +5/10%.
- Rij 4: **Nightfall** 2 (18094): 2/4% kans per schade van Corruption, Drain Soul, Drain Life of Wrack op Shadow Trance: 10 s lang is je
  volgende Shadow Bolt instant (17941: −100% casttijd). **Malevolence** 5 (1310949): crit van Shadow-spells +1..5%.
- Rij 5: **Soul Siphon** 3 (17804): Drain Life, Drain Soul en Wrack +4/8/12% per eigen Corruption, Siphon Life en Bane of Agony op het
  doel; maximaal 12/24/36%.
- Rij 6: **Shadow Mastery** 5 (18271): Shadow-schade en gedrainde health +2..10%.

### 3b. Demonology (band 2)

**Met een knop**

| Talent (spell) | Rij / nodig | Vroegste level | Voorwaarde | Wat het doet | Toets |
|---|---|---|---|---|---|
| Demonic Sacrifice (18788) | rij 3 / 10 | 20 | – | Offert je demon voor een buff van **2 uur** (7.200.000 ms). Imp: +15% Shadow-schade. Voidwalker: 2% mana per 4 s. Succubus/Incubus: +15% Fire-schade. Felhunter: 3% health per 4 s. De buff vervalt als je **welke demon dan ook** oproept. | Shift-C |
| Fel Domination (18708) | rij 4 / 15 | 25 | Master Summoner | Volgende demon-oproep 5,5 s sneller en 50% goedkoper. Buff 15 s. Cooldown 5 min. | Shift-F1 |
| Soul Link (19028) | rij 5 / 20 | 30 | Demonic Sacrifice | 30% van de schade op jou gaat naar je demon; jij en je demon doen 3% meer schade. Kost 20% mana. Blijft zolang de demon er is. | Shift-X |

**Passief (kern)**
- Rij 1: **Unholy Power** 5 (18769): demon-schade +2..10%. **Demonic Embrace** 5: Stamina +3..15%. **Improved Imp** 3: Firebolt en
  Fire Shield +10/20/30%. **Improved Health Funnel** 2: +20/40% health, kost −15/−30%, threat −50/−100%.
- Rij 2: **Demonic Energies** 2 (1225214): je demon krijgt 8/15% van jouw spell-schade als health; bij Life Tap krijgt hij 50/100% van
  jouw mana erbij. **Fel Vitality** 3: health en mana van de demon +5/10/15%, jouw max mana +5/10/15%.
  **Improved Voidwalker** 3: Torment, Consume Shadows, Sacrifice, Suffering +10/20/30%. **Demonic Aegis** 2: Demon Skin/Armor +15/30%.
- Rij 3: **Master Summoner** 2 (18709): oproepen −2/−4 s (van 10 s) en −20/−40% mana. **Improved Sayaad** 3: Lash of Pain en Soothing
  Kiss +10/20/30%, Seduction en Lesser Invisibility duren 10/20/30% langer.
- Rij 4: **Demonic Brand** 3 (1293695): Searing Pain geeft 17/33/50% minder threat en "brandmerkt" het doel 10 s; de volgende 2/4/6
  aanvallen van je demon op dat doel doen extra Fire- of Shadow-schade (bedrag niet gemeten). Shadow-schade geeft veel threat.
  **Decimation** 2 (440870): Soul Fire-cooldown −45/−90%. Shadow Bolt of Searing Pain op een vijand onder 35% health doet 3/6% meer,
  en 10 s lang is Soul Fire 20/40% sneller en kost hij geen Soul Shard.
- Rij 5: **Demonic Knowledge** 3: spell-schade van jou en je demon tot 33/67/100% van je level, zolang je demon er is.
  **Improved Felhunter** 3: Spell Lock-cooldown −2/−4/−6 s.
- Rij 6: **Master Demonologist** 5 (23785): Imp = Fire-schade +2..10%; Voidwalker = fysieke schade op jullie −2..−10%;
  Succubus/Incubus = Shadow-schade +2..10%; Felhunter = magische schade op jullie −2..−10%.
- Rij 7 (30 nodig, level 40, na Soul Link): **Demonic Pact** 1 (425464), passief: de Demonic Sacrifice-buff vervalt niet meer als je een
  **andere** demon oproept. Dezelfde demon opnieuw oproepen laat hem nog wel vervallen.

### 3c. Destruction (band 3)

**Met een knop**

| Talent (spell) | Rij / nodig | Vroegste level | Voorwaarde | Wat het doet | Toets |
|---|---|---|---|---|---|
| Shadowburn (17877) | rij 3 / 10 | 20 | – | Instant Shadow-klap (rang 1: 66). Cooldown 15 s. 105 mana. **Kost 1 Soul Shard** (SpellReagents 6265). Sterft het doel (dat XP geeft) binnen 8 s, dan krijg je een shard. Rangen bij de trainer: 24, 32, 40, 48, 56. | Shift-4 |
| Conflagrate (1293817) | rij 4 / 15 | 25 | – | Instant Fire-klap (rang 1: 95) op een doel met **jouw Immolate**; die Immolate is dan weg. Cooldown 10 s. 100 mana. Rangen: 32, 40, 48, 54, 60. | blok D |
| Bane of Havoc (1225228) | rij 5 / 20 | 30 | – | 5 min op één doel: 15% van al jouw schade op andere doelen komt ook op dit doel. Maar 1 doel tegelijk. Kost 5% mana. Is een **Bane**. | blok D |
| Incinerate (412758) | rij 7 / 30 | 40 | Bane of Havoc | Cast 2,5 s. Fire-schade (rang 1: 97), +25% als het doel jouw Immolate heeft. 205 mana. Rangen: 50, 60. | blok D |

**Passief (kern)**
- Rij 1: **Bane** 5 (17788): Shadow Bolt, Immolate en Incinerate −0,1..−0,5 s; Soul Fire −0,4..−2,0 s. **Improved Shadow Bolt** 5
  (17793): na een Shadow Bolt-crit neemt het doel 12 s lang 4..20% meer Shadow-schade van jou. **Destructive Reach** 2: bereik +10/20%.
- Rij 2: **Aftermath** 5 (18119): eerste klap van Immolate +10..50%; Conflagrate heeft 20..100% kans op Daze (50% langzamer, 5 s).
  **Cataclysm** 3: mana-kosten −3/−6/−10%. **Molten Skin** 5 (1225220): alle schade op jou −2..−10%.
- Rij 3: **Ruin** 5 (17959): crit-bonus van Destruction-spells +20..100%.
- Rij 4: **Agonizing Flames** 3 (17927): Destruction-schade +3/7/10%, Searing Pain-crit +3/7/10%. **Intensity** 3: 23/47/70% geen
  vertraging door klappen.
- Rij 5: **Fire and Brimstone** 3 (412751, na Conflagrate): Conflagrate-crit +8/17/25%. **Pyroclasm** 2 (na Intensity): Soul Fire,
  Rain of Fire en Hellfire 13/26% kans op 3 s stun.
- Rij 6: **Shadow and Flame** 5 (426316): Conflagrate raakt → 20 s lang +4..20% Shadow-schade; Shadowburn raakt → 20 s lang +4..20%
  Fire-schade. En 20..100% kans dat Conflagrate Immolate **niet** opeet en dat Shadowburn zijn Soul Shard meteen teruggeeft.
  Op 5/5 (vroegst level 39) is dat dus altijd. [IV-X] zegt hetzelfde.

## 4. De gewone spells die voor elke rol tellen (GEMETEN DB2 + ForeverTrainerData; levels kloppen in beide)

| Spell | Level | Feiten | Toets |
|---|---|---|---|
| Shadow Bolt | 1 (start) | Cast: rang 1 1,7 s, rang 2 2,2 s, rang 3 2,8 s, rang 4+ 3,0 s. Rangen 6, 12, 20, 28, 36, 44, 52, 60. | 1 |
| Immolate | 1 (trainer, 10 koper) | Cast 2 s. Eerste klap + DoT van 15 s (tik per 3 s). Rangen per 10 levels. | 3 |
| Corruption | 4 | Cast 2 s (zonder talent). Duur: rang 1 12 s, rang 2 (14) 15 s, rang 3+ (24) 18 s. Tik per 3 s. | 2 |
| Curse of Weakness | 4 | Curse, 2 min. Vijand doet minder fysieke schade. | Shift-V (tot 20) |
| Life Tap | 6 | Zet (basis + Spirit) health om in evenveel mana. Rang 1 basis 20. Instant. | F |
| Bane of Agony | 8 | **Bane**, 24 s, tik per 2 s. Tekst: "dealt slowly at first, and builds up". Instant. | 5 |
| Fear | 8 | Cast 1,5 s, kost 15% mana. Rang 1 10 s, rang 3 (56) 20 s. "Damage caused may interrupt the effect." 1 doel tegelijk. | V |
| Drain Soul | 10 | Kanaal 15 s, tik per 3 s. Elke tik op een vijand die XP geeft heeft een kans op een Soul Shard; sterft hij door Drain Soul, dan altijd. | 4 |
| Create Healthstone | 10 | Cast 3 s, 1 Soul Shard. Rang 1 geneest 120. | blok D (steen op Shift-T) |
| Health Funnel | 12 | Kanaal 10 s, geneest je demon, kost jouw health. | F2 |
| Drain Life | 14 | Kanaal 5 s, tik per seconde. Rangen 22, 30, 38, 46, 54 (per tik 10 / … / 22 / 28 / … / 51). | C |
| Curse of Recklessness | 14 | Curse: minder armor; de vijand vlucht niet en **negeert Fear**. | blok D |
| Searing Pain | 18 | Cast 1,5 s. "Causes a high amount of threat." | blok D |
| Create Soulstone | 18 | 1 Soul Shard. | geen (listed) |
| Curse of the Elements | 20 | Curse, 5 min: alle magie-weerstand omlaag en +4% magische schade (rang 2 op 30: +6%, rang 3 op 40: +8%, rang 4 op 50: +10%). | Shift-V (vanaf 20) |
| Demon Armor | 20 | Vervangt Demon Skin. 30 min. | Shift-Z |
| Rain of Fire | 20 | Kanaal 8 s, gebied. | Shift-1 |
| Banish | 28 | Alleen Demons en Elementals. 20 s (rang 2 op 48: 30 s). | Shift-Q |
| Hellfire | 30 | Kanaal 15 s rond jou; doet ook **jou** elke seconde schade. | Shift-2 |
| Shadow Ward | 32 | Vangt Shadow-schade op, 30 s; cooldown 30 s. | Z |
| Howl of Terror | 40 | Cast 2 s; 5 vijanden vluchten 10 s (rang 2: 15 s); cooldown 40 s. | Shift-F |
| Death Coil | 42 | 3 s horror + schade; jij krijgt die schade als health; cooldown 2 min. | X |
| Soul Fire | 48 | Cast 6 s, cooldown 1 min, 1 Soul Shard. | Q |
| Inferno | 50 | Uit een quest (7603, `ForeverClassQuests.lua`); 1 Infernal Stone; cooldown 1 uur. | F3 |
| Bane of Doom | 60 | **Bane**: grote klap na 60 s; cooldown 60 s; niet op spelers. | F1 |
| Shoot (wand) | start | Spell 5019; DB2 SkillLineAbility: AcquireMethod 2, class-masker 400 (Priest, Mage, Warlock). **Niet op het blok** (`listed`): de speler sleept hem zelf naar een balk. | geen |

- **Soul Shard** (item 6265): stapelt niet (Stackable 1, GEMETEN ItemSparse). Kost 1 shard (GEMETEN SpellReagents): Summon
  Voidwalker / Succubus / Incubus / Felhunter, Create Healthstone / Soulstone / Firestone / Spellstone, Ritual of Summoning,
  Shadowburn, Soul Fire. Summon Imp heeft geen reagent-rij: gratis. Small Soul Pouch 14 vakken, Soul Pouch 24 (GEMETEN ItemSparse).
- **Curse en Bane**: elke Curse zegt "Only one Curse per Warlock can be active on any one target", elke Bane hetzelfde met "Bane"
  (GEMETEN). Dus één Curse + één Bane per vijand. Banes: Agony, Doom, Havoc. Curses: Weakness, Recklessness, Elements, Tongues, Exhaustion.
- **Demons** (GEMETEN `ForeverClassQuests.lua`): Imp level 1 (eerste class-quest), Voidwalker 10, Succubus en Incubus 20 (zelfde
  eerste quest; je kunt beide doen), Felhunter 30, Felsteed 40, Inferno 50, Dreadsteed 60. Oproepen: cast 10 s (GEMETEN DB2).
- **Demon-spells** (GEMETEN DB2 SpellLevels): Imp: Firebolt 1, Blood Pact 4, Fire Shield 14. Voidwalker: Torment 10, Sacrifice 16,
  Consume Shadows 18 (niet in een gevecht), Suffering 24 (cooldown 2 min). Succubus/Incubus: Lash of Pain 20, Soothing Kiss 22,
  Seduction 26 (alleen Humanoids; elke schade breekt het), Lesser Invisibility 32. Felhunter: Devour Magic 30, Tainted Blood 32,
  Spell Lock 36 (cooldown 30 s), Paranoia 42.
  GIDS [IV, WT, ME]: nieuwe demon-spells en -rangen koop je als Grimoire bij een demon-trainer. GEMETEN alleen: de items bestaan
  (49 "Grimoire of …"-rijen in ItemSparse 70938).
- **Pet-toetsen** (GEMETEN blok): Ctrl-1 = aanvallen, Ctrl-2 = volgen, Ctrl-3 = blijven. De oproep-spells staan op blok D.

## 5. Eenvoudige volgorde per rol (levelen)

Toetsen uit `ForeverBlock_Warlock.lua`. Bron per stap tussen haken. De volgorde zelf is GIDS; de feiten erachter staan in 3 en 4.

### 5a. Affliction
Speelbaar vanaf level 4 (Corruption) en 8 (Bane of Agony). GIDS: eerste keus om te levelen bij [WT], [ME], [MC], [MK].
1. Demon erop af: **Ctrl-1**. [WT, IV-A, MC]
2. Bane of Agony (**5**) om te pullen: de schade begint laag, dus je demon pakt de vijand. [WT, MC, MK; tekst GEMETEN]
3. Corruption (**2**). Met Improved Corruption 5/5 instant (vroegst level 14 als je die eerst neemt). [WT, MC; GEMETEN]
4. Siphon Life (**F4**, vanaf 30), alleen op een vijand die lang leeft. [IV-A, WT, MC]
5. Immolate (**3**) alleen op een taaie vijand. [WT, IV-A] Shadow-talenten maken hem niet sterker. [IV-A]
6. Taaie vijand: je Curse (**Shift-V**) erbij. [IV-A vanaf 20; WT pas vanaf 40]
7. Daarna vullen: tot ongeveer level 30 je wand (geen vaste toets), daarna Drain Life (**C**). [WT, ME, IV-A; MC legt de grens bij 38]
8. Licht Shadow Trance op (Nightfall, vanaf 25)? Shadow Bolt (**1**): die is dan instant. [IV-A, MC; GEMETEN]
9. Vanaf 40: Wrack (blok D) in plaats van Drain Life als je health goed is. Eerst de DoTs erop. [WT, MC; GEMETEN]
10. Meer health dan mana? Life Tap (**F**). [WT, IV-A]
11. Soul Shard nodig: maak de vijand af met Drain Soul (**4**). [IV-A, MC; GEMETEN]
Twee vijanden: DoTs op de eerste, Fear (**V**) erop, vecht met de tweede. [WT, MC] (Zie "Gidsen oneens" over Fear en DoTs.)

### 5b. Demonology
Speelbaar vanaf level 1 (Imp), echt vanaf 10 (Voidwalker). GIDS: [WT] levelt eerst als Affliction en wisselt op 27; [MC] heeft
twee varianten (vanaf 10 Demonology, of een wissel op 26); [IV-D] en [WM] gaan vanaf 10 de boom in; [ME]: "activates a little later".
1. Demon erop af: **Ctrl-1**; laat hem eerst raken. [IV-D, WT]
2. Vanaf 30: Soul Link (**Shift-X**) aan, en opnieuw na elke oproep. [IV-D, SS; GEMETEN "lasts as long as the Demon is active"]
3. Vanaf 25 (Demonic Brand): Searing Pain (blok D) op de vijand van je demon; opnieuw als het merk op is (10 s). [WT, IV-D; GEMETEN]
   Vóór Demonic Brand: geen Searing Pain. [WT, ME]
4. Bane of Agony (**5**) en Corruption (**2**) op vijanden die lang genoeg leven. Corruption heeft hier een cast van 2 s. [IV-D, WT]
5. Vullen: wand, of Shadow Bolt (**1**); Drain Life (**C**) als je health nodig hebt. [IV-D, ME, WT]
6. Demon bijna dood: Health Funnel (**F2**). Het kost jouw health. [IV-D; GEMETEN]
7. Life Tap (**F**): met Demonic Energies krijgt je demon ook mana. [IV-D; GEMETEN]
8. Vanaf 40 (Demonic Pact): Demonic Sacrifice (**Shift-C**) op de ene demon, daarna een **andere** oproepen (blok D). De buff duurt
   2 uur. [IV-D, WT, ME; GEMETEN] Welke demon: zie "Gidsen oneens".
9. Vanaf 48, met Decimation: vijand onder 35% → Shadow Bolt of Searing Pain, dan Soul Fire (**Q**): sneller en zonder shard. [ME; GEMETEN]

### 5c. Destruction
Speelbaar vanaf level 1 (Shadow Bolt, Immolate). GIDS: [IV-X] en [MC] raden hem af om mee te levelen (veel mana, weinig herstel);
[WT] en [ME] noemen hem wel speelbaar; [WT]: sterk in dungeons.
1. Demon erop af: **Ctrl-1**. [WT, IV-X]
2. Immolate (**3**). [WT, IV-X] ([IV-X]: eerst Shadow Bolt van ver, meteen Immolate erachteraan.)
3. Taaie vijand: Bane of Agony (**5**) en je Curse (**Shift-V**). [WT, IV-X]
4. Vanaf 25: Conflagrate (blok D). Vóór Shadow and Flame 5/5 (vroegst 39) eet hij Immolate op: pas aan het eind van Immolate, of als
   laatste klap. Daarna: elke keer als hij klaar is. [IV-X, WT, SS; GEMETEN]
5. Vullen: Shadow Bolt (**1**); vanaf 40 Incinerate (blok D), met Immolate op het doel. [WT, IV-X; GEMETEN]
6. Vanaf 20: Shadowburn (**Shift-4**) als laatste klap: dan krijg je de Soul Shard terug. [WT, IV-X; GEMETEN]
7. Life Tap (**F**) tussen gevechten; mana laag → wand. [WT, IV-X]
8. Meer vijanden: vanaf 30 Bane of Havoc (blok D) op één taaie vijand en de rest aanvallen; Rain of Fire (**Shift-1**, 20);
   Hellfire (**Shift-2**, 30) alleen met genoeg health. [IV-X; GEMETEN]

## 6. Per 10 levels: wat nieuw is en telt

Levels: trainer = ForeverTrainerData + DB2 SpellLevels (beide GEMETEN, gelijk); talent = AFGELEID "vroegst" (zie 2); quest =
ForeverClassQuests (GEMETEN in code).

### Affliction
- **10**: Drain Soul (**4**), Create Healthstone (blok D), Voidwalker (quest). Je had al: Shadow Bolt (**1**), Immolate (**3**),
  Corruption (**2**, 4), Curse of Weakness (**Shift-V**, 4), Life Tap (**F**, 6), Bane of Agony (**5**, 8), Fear (**V**, 8).
  Eerste talent: Improved Corruption of Suppression (gidsen oneens). Daarna: Health Funnel (**F2**) 12; Drain Life (**C**) en Corruption
  rang 2 (15 s) op 14; Improved Drains / Soul Harvest (talent, passief) vanaf 15; Searing Pain en Create Soulstone 18.
- **20**: Amplify Curse (**Shift-3**, talent). Curse of the Elements (**Shift-V**), Demon Armor (**Shift-Z**), Rain of Fire
  (**Shift-1**), Succubus/Incubus (quest). Daarna: Corruption rang 3 (18 s) en Drain Mana 24; Curse of Exhaustion (**R**, talent, na
  Amplify Curse) en Nightfall (talent, passief) 25; Banish (**Shift-Q**) 28.
- **30**: Siphon Life (**F4**, talent), Soul Siphon (talent, passief). Drain Life rang 3, Hellfire (**Shift-2**), Felhunter (quest).
  Daarna: Shadow Ward (**Z**) 32; Shadow Mastery (talent, passief) 35; Siphon Life rang 2 en Drain Life rang 4 op 38.
- **40**: Wrack (blok D, talent, na Siphon Life). Howl of Terror (**Shift-F**), Felsteed (quest). Daarna: Death Coil (**X**) 42;
  Soul Fire (**Q**) en Siphon Life rang 3 op 48.
- **50**: Inferno (**F3**, quest). Curse of the Elements rang 4 (+10%). Verder sterkere rangen.
- **60**: Bane of Doom (**F1**). Verder sterkere rangen.

### Demonology
- **10**: Voidwalker (quest; kost 1 Soul Shard; Torment). Drain Soul (**4**) voor shards. Eerste talenten: Unholy Power, Demonic
  Embrace, Improved Imp, Improved Health Funnel. Daarna: Health Funnel (**F2**) 12; Demonic Energies / Fel Vitality / Improved
  Voidwalker (talenten, passief) vanaf 15; Voidwalker: Sacrifice 16, Consume Shadows 18; Searing Pain (blok D) 18.
- **20**: Demonic Sacrifice (**Shift-C**, talent), Master Summoner (talent, passief). Succubus/Incubus (quest; Lash of Pain 20,
  Seduction 26). Demon Armor (**Shift-Z**). Daarna: Suffering (Voidwalker) 24; Fel Domination (**Shift-F1**, talent, na Master
  Summoner) 25; Demonic Brand (talent, passief) 25-27; Decimation (talent, passief) 25.
- **30**: Soul Link (**Shift-X**, talent, na Demonic Sacrifice). Felhunter (quest; Devour Magic 30, Spell Lock 36). Daarna:
  Demonic Knowledge (talent, passief); Master Demonologist (talent, passief) vanaf 35.
- **40**: Demonic Pact (talent, passief, na Soul Link): nu pas loont Demonic Sacrifice naast een demon. Howl of Terror
  (**Shift-F**), Felsteed (quest). Daarna: Death Coil (**X**) 42; Soul Fire (**Q**) 48 (Decimation).
- **50**: Inferno (**F3**, quest): een Infernal, 1 Infernal Stone per keer, cooldown 1 uur.
- **60**: Bane of Doom (**F1**). Verder sterkere rangen.

### Destruction
- **10**: Shadow Bolt (**1**) en Immolate (**3**; rang 2 op 10). Eerste talent: Bane (snellere casts) of Improved Shadow Bolt.
  Daarna: Shadow Bolt rang 3 op 12 (cast 2,8 s); Aftermath / Cataclysm (talenten, passief) vanaf 15; Searing Pain (blok D) 18.
- **20**: Shadowburn (**Shift-4**, talent; 1 Soul Shard), Ruin (talent, passief). Rain of Fire (**Shift-1**). Shadow Bolt rang 4
  (cast 3,0 s). Daarna: Shadowburn rang 2 op 24; Conflagrate (blok D, talent) 25; Agonizing Flames / Intensity (passief) vanaf 25.
- **30**: Bane of Havoc (blok D, talent). Fire and Brimstone (na Conflagrate) en Pyroclasm (na Intensity), passief. Hellfire
  (**Shift-2**). Daarna: Conflagrate rang 2 en Shadowburn rang 3 op 32; Shadow and Flame (talent, passief) 35-39.
- **40**: Incinerate (blok D, talent, na Bane of Havoc). Conflagrate rang 3, Shadowburn rang 4. Daarna: Soul Fire (**Q**) 48.
- **50**: Incinerate rang 2. Inferno (**F3**, quest).
- **60**: Incinerate rang 3, Conflagrate rang 6. Bane of Doom (**F1**).

## 7. Beginnersfouten per rol

### Affliction
1. Bane of Agony te vroeg opnieuw zetten. De sterkste tikken komen aan het eind. [GEMETEN tekst; IV-A, MK, GN]
2. Wrack gebruiken als je health nodig hebt. Wrack geneest niet; Drain Life wel. [GEMETEN; WT, IV-A, MC]
3. Alle DoTs op een vijand die bijna dood is. Zonde van de mana: maak hem af met je wand. [IV-A, FT, MU]
4. Curse of Recklessness op de vijand die je wilt Fearen. Die vijand negeert Fear. [GEMETEN tekst; SS, MU]
5. Siphon Life op elke vijand. Rang 1 is zwak en duur (150 mana, 11 per 3 s): alleen op vijanden die lang leven. [GEMETEN; IV-A, WT]
6. (Algemeen) Fear vlak bij andere vijanden: de vijand rent weg en kan er meer meebrengen. [WT, MK, R60, GN]

### Demonology
1. Searing Pain vóór je Demonic Brand hebt. Hij geeft veel threat en trekt de vijand van je demon af. [GEMETEN tekst; WT, ME, MU]
2. Demonic Sacrifice gebruiken vóór Demonic Pact (40). Je bent je demon kwijt, en een demon oproepen wist de buff. [GEMETEN; IV-D, ME, SS]
3. Na Demonic Pact dezelfde demon weer oproepen als je offerde. Dan is de buff weg. [GEMETEN tekst Demonic Pact; IV-D]
4. Soul Link vergeten na een nieuwe demon. Hij stopt als de demon weg is. [GEMETEN; IV-D, SS]
5. Geen Soul Shard hebben. Alle demons behalve de Imp kosten er één. [GEMETEN SpellReagents; IV-D] (staat al in CLASSES.WARLOCK)
6. Health Funnel (**F2**) te lang aanhouden: hij kost jouw health. [GEMETEN; IV-D]

### Destruction
1. Conflagrate meteen na Immolate. Hij eet Immolate op (tot Shadow and Flame 5/5). [GEMETEN; IV-X, SS]
2. Conflagrate op een vijand zonder jouw Immolate: dat werkt niet. [GEMETEN tekst]
3. Shadowburn zonder Soul Shard, of op een vijand die nog lang leeft: de shard is weg. Hij komt alleen terug als de vijand binnen 8 s
   sterft. [GEMETEN; IV-X, WT]
4. Bane of Havoc en Bane of Agony op dezelfde vijand. Er past maar één Bane op. [GEMETEN; IV-X]
5. Zonder mana komen te staan. Destruction kost de meeste mana: Life Tap tussen gevechten, en je wand voor bijna-dode vijanden. [WT, IV-X, MC]
6. Hellfire (**Shift-2**) met weinig health: hij doet ook jou schade. [GEMETEN tekst; IV-X]

## 8. Gidsen oneens

| Onderwerp | Wie zegt wat | Wat DB2 70938 zegt |
|---|---|---|
| Welke boom om te levelen | Affliction eerst: WT, ME, MC, MK. Demonology "net zo sterk" na Demonic Brand (WT), via een wissel op 27 (WT) of 26 (MC). Destruction: afgeraden door IV-X en MC; "speelbaar" volgens WT en ME. | Niet te meten. |
| Wat Wrack doet | IV-A (4 nov), FW (build 70862), SS: "+10% schade van je andere Shadow-DoTs". WT, MC (16 nov), GN ("since the November 10 hotfix"): DoTs tikken twee keer zo snel. | GEMETEN: in **70862** stond "increasing the damage they take from your other Shadow damage over time effects by $s2%"; in **70938** "deal their periodic damage $s2% faster", s2 = 100. De oude gidsen zijn dus verouderd. |
| Wat Soul Siphon telt | FW (70862): elk ander Affliction-effect. MC: alleen Corruption, Bane of Agony, Siphon Life ("Curses no longer count"). | GEMETEN: 70862 "each of your other Affliction effects"; 70938 alleen Corruption, Siphon Life, Bane of Agony. |
| Wanneer Wrack | wowtbc.gg (beta): "level 30 talent". MC: 40. WT: 47 (of 40 na een wissel). IV-A: 51. | GEMETEN: 30 punten in Affliction + Siphon Life → vroegst 40. |
| Eerste 5 punten Affliction | Suppression eerst: IV-A, ME (4 punten = "nooit missen op gelijk level"). Improved Corruption eerst: WT, MC, FW, SS. | Beide rij 1. De "nooit missen"-claim is niet gemeten. |
| Fear en DoTs | WT, MC: eerst DoTs erop, dan Fear. SS: "Fear only a mob you haven't dotted: your damage breaks Fear". WT: geen Shadow Bolt of eerste klap van Immolate op een Feared vijand. | GEMETEN tekst: "Damage caused **may** interrupt the effect." Hoe vaak: niet gemeten. |
| Vullen vóór level 30 | Wand: WT, ME, IV-A. MC: Drain Life is zwak tot in de 30; rang 4 (38) is het omslagpunt. WT: Drain Life vanaf 30. | Drain Life rang 3 op 30, rang 4 op 38 (GEMETEN). Wandschade niet gemeten. |
| Welke demon | WT: Voidwalker tot 20, daarna Succubus/Incubus. ME: Succubus (drain tanking). IV-D: Voidwalker met Improved Voidwalker. MU: sinds 2 nov houdt de Voidwalker minder (demon-health per Stamina omlaag). | Niet gemeten. |
| Welke demon offeren | IV: Felhunter (3% health per 4 s) solo, Imp (+15% Shadow) in dungeons; Destruction: Succubus (+15% Fire). WT: Imp. ME: Imp als de Voidwalker tankt. | De vier buffs zelf: GEMETEN (zie 3b). |
| Curse of the Elements | IV: vanaf 20 op taaie vijanden. WT: pas vanaf 40 (rang 3, +8%). | Rang 1 +4%, rang 3 +8% (GEMETEN). |
| Shadowburn | WT: alleen als laatste klap. IV-X: na Shadow and Flame 5/5 steeds gebruiken. | Beide passen bij de tekst (GEMETEN). |
| Torment = taunt? | CLASSES.WARLOCK (MH): "The Voidwalker can taunt (Torment)". IV: "generates threat, rather than forcing the mob to change targets like a taunt". | GEMETEN: de tooltip zegt "Taunts the creature, increasing the chance that it will attack the Voidwalker"; het effect is type 63 zonder taunt-aura. Menace (403828) heeft in dezelfde data wél een taunt-aura. AFGELEID: Torment geeft threat. |
| Inferno, Ritual of Doom | WT-tabel: "Class Trainers" (50, 60). | MH-code: quest 7603 (Inferno) en 7583 (Ritual of Doom). GEMETEN: geen van beide staat in ForeverTrainerData. |

## 9. Niet noemen

**Talenten en namen die NIET in boom 1116 staan** (GEMETEN: alle 52 nodes opgesomd; namen nagezocht in SpellName 70938 met
een treffer als controle in dezelfde run: "Wrack" → 1 id, "Curse of Agony" → 7 id's). De meeste zijn Classic-talenten; dat ze in
Classic een talent waren is AFGELEID (eigen kennis, niet nagemeten).
- Geen spell met die naam: Dark Pact, Fel Intellect, Improved Searing Pain, Improved Drain Soul, Improved Drain Mana, Improved
  Succubus, Improved Enslave Demon, Improved Curse of Agony, Enslave Demon. Ook "Dark Power" (genoemd door GN) bestaat niet.
- Spell bestaat nog, maar is geen talent meer: Improved Curse of Weakness, Improved Curse of Exhaustion, Improved Healthstone,
  Improved Firestone, Improved Spellstone, Improved Subjugate Demon, Improved Firebolt, Improved Lash of Pain, Improved Immolate,
  Devastation, Emberstorm, Apocalypse, Curse of Idiocy, Improved Drain Life (23554, geen talent).
- "Fel Stamina" is nu de naam van de Felhunter-buff van Demonic Sacrifice (18790), geen talent.

**Oude namen** (GEMETEN): de speler heeft **Bane of Agony** (niet Curse of Agony: die naam hebben alleen vijand-spells),
**Bane of Doom** (niet Curse of Doom), **Subjugate Demon** (niet Enslave Demon), **Improved Sayaad** (niet Improved Succubus).
Curse of Shadow staat niet bij de trainer; Curse of the Elements dekt alle magie.

**Staat in de DB2-skill-lines maar niet in de boom of bij de trainer** (resten van Season of Discovery, AcquireMethod 3): Metamorphosis,
Fel Armor, Chaos Bolt, Shadowflame, Demonic Grace, Dance of the Wicked, Grimoire of Synergy, Vengeance, Invocation, Shadow Cleave,
Demon Charge, Demonic Howl, Menace. Of een speler ze kan krijgen: niet gemeten. Niet noemen.

**Classic-gewoontes die niet meer kloppen** (GEMETEN): Demonic Sacrifice geeft bij de Imp **Shadow** en bij de Succubus **Fire**
(in Classic andersom), en duurt 2 uur. Wrack is een level-40-talent, geen level-30. Wrack "+10% DoT-schade" is van vóór build 70938.
Rang 10 van Shadow Bolt, rang 8 van Immolate en rang 7 van Corruption staan in DB2 (level 60) maar niet bij de trainer: niet noemen.

## 10. Niet gemeten

- Niets is in het spel zelf gemeten (geen C_Traits, geen trainer-venster). Alles is DB2-CSV, MH-code of gids.
- Of een pijl (TraitEdge type 2) het eerste talent **vol** eist. AFGELEID ja.
- "4 punten Suppression = nooit missen op gelijk level" (IV, ME, MC). Wandschade, en de "halve seconde vertraging" van de wand (FW).
- Hoeveel health/threat de demons hebben; de hotfixes van 2 en 10 nov die MU en GN noemen.
- De schade van Demonic Brand ($<minDam>/$<maxDam> in de tekst) en van Wrack op hogere levels (één rang, basis 25,2 per tik).
- Bereik in yards en straal van gebiedsspells (alleen index-nummers gezien).
- "Kost X% mana" (Fear 15%, Soul Link 20%, Curse of Exhaustion 8%, Bane of Havoc 5%) is SpellPower.PowerCostPct. Of dat van je
  basis-mana of van je hele mana is: niet gemeten. Schrijf geen percentage in de spelerstekst.
- Of Grimoires echt bij demon-trainers te koop zijn (alleen: de items bestaan). Of de Incubus dezelfde spells heeft als de Succubus
  (de talenttekst "Succubus' and Incubus'" wijst erop; skill-line niet nagelopen). Level van Phase Shift (Imp).
- Dual Talent Specialization op 40 (alleen WT). Kosten van een talent-wissel.
- Waar je Portal of Summoning (437169, level 60) leert. Inferno en Ritual of Doom: alleen uit MH-code.
- DB2 heeft geen level voor Shadow Ward, Unending Breath, Eye of Kilrogg, Sense Demons en Detect Invisibility; die levels komen
  alleen uit ForeverTrainerData.
- Wowhead Forever en Blizzards eigen class-pagina zijn niet geraadpleegd.
- De gidsvolgordes zijn niet door ons getest; [WM] zegt dat zelf ook van zijn builds.

## 11. Waar de schrijver op moet letten

- **Geen vaste toets** voor: Wrack, Conflagrate, Incinerate, Bane of Havoc, Searing Pain, de oproep-spells, Create Healthstone (alle
  blok D) en de wand (Shoot, niet op het blok). Dat zijn juist de kernknoppen van Destruction (Conflagrate, Incinerate), van
  Demonology (Searing Pain) en het level-40-talent van Affliction. Schrijf "blok D", verzin geen toets.
  Wel bestaand (GEMETEN `ForeverMacros.lua`): de macro "Nuke Picker" (Shift = Incinerate, Ctrl = Conflagrate, Alt = Shadowburn, kaal =
  Shadow Bolt), "Channels" (Alt = Life Tap, Ctrl = Wrack, Shift = Drain Soul, kaal = Drain Life), "Searing Pain" (met /petattack) en
  "Demon Sac". De speler zet die zelf op een balk.
- Talent-levels zijn "vroegst"; met de perk Talented tot 5 levels eerder (zelfde zin als bij de andere classes).
- Curse en Bane zijn twee soorten: één van elk per vijand. CLASSES.WARLOCK legt dat al uit.
- Drain Soul geeft in Forever ook tijdens het kanaal een kans op een shard, niet alleen bij de laatste klap.
- Voor Demonology: zeg duidelijk dat Demonic Sacrifice pas loont met Demonic Pact (40).
- Voor Destruction: het omslagpunt is Shadow and Flame 5/5 (vroegst 39); dan eet Conflagrate Immolate niet meer op.
