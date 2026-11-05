# WoW Forever — Rogue: spells tot 60 + VOORSTEL voor het toetsenblok

> 🌙 **Nacht 5→6 nov 2026, onderzoek door mh-research (één helper per class). NIET goedgekeurd door Rob, NIET in de
> addon.** Alleen een goedgekeurde tabel komt in `Modules/ForeverBlock_<Class>.lua`.
>
> **Zelf nagekeken in de nacht (GEMETEN):**
> - beginspells staan in Blizzards data met AcquireMethod 2: Sinister Strike 1752, Eviscerate 2098 (wago wowf 1.60.1.70790, SkillLineAbility);
> - de concepttabel hieronder laadt in de échte motor (`Modules/ForeverBlock.lua`, offline met nagebootste spells):
>   elke spellnaam bestaat in SpellName, elke toets is een blok-plek, geen spell op twee toetsen;
> - stance/vorm-nummers: SpellShapeshiftForm.BonusActionBar (Cat 1, Bear 3, Stealth 1, Battle 1, Defensive 2,
>   Berserker 3, Moonkin/Shadowform/Ghost Wolf 0).
> - Niet in het spel getest. Elke toetskeuze is een voorstel (AFGELEID).
> - Voor alle classes geldt (helpers, GEMETEN in de data): een account-perk 'Talented' geeft al talentpunten vanaf
>   level 5-9, dus talent-levels hieronder kunnen tot 5 levels vroeger zijn.

**Aandachtspunten van de nachtcontrole:**
- Shift-2 gebruikt `[equipped:Guns]` enz. voor het juiste schot; standaard macro-syntax, niet in Forever getest.

---

# WoW Forever Rogue: spells 1-60, states and a key-block proposal (client 1.60.1.70790)

Researched in the night of 5 to 6 Nov 2026. Read-only: nothing in the repo was changed.
G = GEMETEN (seen in a named, dated source). A = AFGELEID (reasoned).

## Sources

All read on 5 Nov 2026 (late evening / night).

- **DB2** = wago.tools, product `wowf`, build **1.60.1.70790**. The caller's folder `scratchpad\wago_wowf\` (fetched 5 Nov, 23:25).
  I fetched these extra tables for the same build myself with curl (all HTTP 200):
  `SkillLineXTraitTree`, `CharBaseInfo`, `ChrRaces`, `SpellDuration`, `SpellPower`.
  They are in `scratchpad\rogue_work\`, with my scripts.
- **Classic Era DB2** for comparison: build **1.15.9.70576** (`SkillLineAbility`, `SpellName`, `SpellLevels`, `SpellShapeshift`,
  `Spell`, `Talent`), same folder.
- **WH** = Wowhead Forever, read in the in-app browser (own tab, closed after):
  - `wowhead.com/forever/spells/abilities/rogue`: 154 rows from the page's own listview data. `source` 6 = trainer, 2 = drop/book, empty = none.
  - Spell pages 2842 (Poisons), 438040 (Redirect), 1804 (Pick Lock), 400080 (a rune engraving) and 1241505 (not found).
  - No verification check was shown.
- **Blizzard UI** = `Gethe/wow-ui-source`, branch `forever`, head commit `eac30af` "1.60.1 (70790)", dated 4 Nov 2026.
  Files: `Blizzard_ActionBarController/ActionBarController.lua` (lines 145-182) and `Blizzard_ActionBar/Shared/StanceBar.lua`.
- **EllesmereUI** (Forever install):
  - `EllesmereUIActionBars\EUI_ActionBars_Paging.lua`, lines 105-132 and 197-209.
  - `EllesmereUI\EllesmereUI_VisibilityRules.lua`, lines 56-85.
  - `EUI_ActionBars_Keybinds.lua`, lines 131-148.
- **Zygor** = `_forever_\...\ZygorGuidesViewerForever\Data-Forever\Skill_Training.lua`, ROGUE block, lines 1724-1892.
  It is **older** than build 70790. For example, it has Mutilate "Rank 2" at 40 needing spell 1310707, which is now nameless and `AcquireMethod 3`.
- **MH repo** (read only):
  - `Modules\KeyBlock.lua`: BLOCK at lines 22-59, CATEGORY at lines 96-107.
  - `Modules\ForeverBlock.lua` (engine and table format) and `Modules\ForeverBlock_Druid.lua` (the approved shape).
  - `Modules\KeybindRoles_Rogue.lua`: the retail Rogue precedent.
- **Druid example:** I read the scratchpad copy `scratchpad\forever_druid_spells.md` and the approved Druid Lua table.
  - **Not read:** `MidnightHelper\docs\` (my agent rule forbids it). So the PLAN_FOREVER_DRUID proposal itself was not read.
  - My proposal table follows the shape of the approved Lua table instead.

## Positive control: PASSES (G)

- Rogue = ChrClasses 4 and ChrSpecialization 1488 "Rogue". That is one spec, as for every class.
- Starting spells (DB2 SkillLineAbility `AcquireMethod 2`):
  - **Sinister Strike Rank 1 (1752)**, SkillLine 38 Combat, level 1.
  - **Eviscerate Rank 1 (2098)**, SkillLine 253 Assassination, level 1.
  - WH lists both at level 1 with no source. That means they are not bought at a trainer.
  - Also with `AcquireMethod 2`: Rogue Passive (DND) 21184, a hidden passive.
- **Stealth Rank 1 (1784)** is level 1 and trainer-bought (WH source 6, 10 copper; Zygor level 1, 10 copper).
- Talent tree **1111**:
  - SkillLineXTraitTree row 162 links SkillLine 38 to tree 1111.
  - TraitNodeGroupDisplayInfo gives the three sections: group 11580 = Assassination (253), 11573 = Combat (38), 11572 = Subtlety (39).
  - The tree has 54 nodes.
- Races that can be Rogue (CharBaseInfo ClassID 4): Human 1, Orc 2, Dwarf 3, Night Elf 4, Undead 5, Gnome 7, Troll 8,
  **High Order Skyborne 95** and **Windshaper Skyborne 96**. So the new race Skyborne can be a Rogue, on both factions.

## Spell list (active spells, levels 1-60)

**Legend**
- `*` = talent. The level is the earliest one at which the tree row opens. This is A:
  - Each row needs 5 more points spent in that section: 0/5/10/15/20/25/30 (TraitCond, G).
  - You get 1 point per level from 10 to 60, so 51 points (TraitCurrencySource "Level 10".."Level 60", SourcedMax 51, G).
  - So the earliest level for row n is 10 + 5(n-1).
  - Exception: the "Talented" perk (spell 1225474) starts the points up to 5 levels earlier, still with a 51 maximum (G, spell text).
    With it, the levels below can be up to 5 lower.
- **Needs Stealth:** ShapeshiftMask bit 29 is set (536870912). Form 30 = "Stealth" (G). Reading the mask as "required form" is A.
  The descriptions say "Must be stealthed" for Garrote, Ambush and Cheap Shot (G).
- **Tab** = the SkillLine of the ability. For the 6 talent spells that have no SkillLineAbility row, the tab is the section (A).

| Spell | Rank | ID | Level | How learned | Tab | Needs Stealth | Measured? |
|---|---|---|---|---|---|---|---|
| Eviscerate | Rank 1 | 2098 | 1 | starting spell (AcquireMethod 2) | Assassination | - | G (DB2 + WH no source) |
| Sinister Strike | Rank 1 | 1752 | 1 | starting spell (AcquireMethod 2) | Combat | - | G (DB2 + WH no source) |
| Stealth | Rank 1 | 1784 | 1 | trainer | Subtlety | (is the state) | G (DB2 + WH) |
| Throw | - | 2764 | 1 | comes with the Thrown skill (AcquireMethod 1, ClassMask incl. Rogue) | General (A) | - | G (DB2) |
| Shoot Bow / Shoot Gun / Shoot Crossbow | - | 2480 / 7918 / 7919 | 1 | come with that weapon skill (AcquireMethod 1) | General (A) | - | G (DB2) |
| Backstab | Rank 1 | 53 | 4 | trainer | Combat | - | G (DB2 + WH) |
| Pick Pocket | - | 921 | 4 | trainer | Subtlety | **Stealth** | G (DB2 + WH) |
| Gouge | Rank 1 | 1776 | 6 | trainer | Combat | - | G (DB2 + WH) |
| Sinister Strike | Rank 2 | 1757 | 6 | trainer | Combat | - | G (DB2 + WH) |
| Evasion | - | 5277 | 8 | trainer | Combat | - | G (DB2 + WH) |
| Eviscerate | Rank 2 | 6760 | 8 | trainer | Assassination | - | G (DB2 + WH) |
| Sap | Rank 1 | 6770 | 10 | trainer | Subtlety | **Stealth** | G (DB2 + WH) |
| Slice and Dice | Rank 1 | 5171 | 10 | trainer | Assassination | - | G (DB2 + WH) |
| Sprint | Rank 1 | 2983 | 10 | trainer | Combat | - | G (DB2 + WH) |
| Backstab | Rank 2 | 2589 | 12 | trainer | Combat | - | G (DB2 + WH) |
| Kick | Rank 1 | 1766 | 12 | trainer | Combat | - | G (DB2 + WH) |
| Expose Armor | Rank 1 | 8647 | 14 | trainer | Assassination | - | G (DB2 + WH) |
| Garrote | Rank 1 | 703 | 14 | trainer | Assassination | **Stealth** | G (DB2 + WH) |
| Sinister Strike | Rank 3 | 1758 | 14 | trainer | Combat | - | G (DB2 + WH) |
| Pick Lock | - | 1804 | 16 (Zygor); DB2 SpellLevel 1 | trainer (WH spell page: taught by rogue trainers) | Lockpicking | - | G (DB2 + WH page + Zygor) |
| Eviscerate | Rank 3 | 6761 | 16 | trainer | Assassination | - | G (DB2 + WH) |
| Feint | Rank 1 | 1966 | 16 | trainer | Combat | - | G (DB2 + WH) |
| Ambush | Rank 1 | 8676 | 18 | trainer | Assassination | **Stealth** | G (DB2 + WH) |
| Gouge | Rank 2 | 1777 | 18 | trainer | Combat | - | G (DB2 + WH) |
| Backstab | Rank 3 | 2590 | 20 | trainer | Combat | - | G (DB2 + WH) |
| Rupture | Rank 1 | 1943 | 20 | trainer | Assassination | - | G (DB2 + WH) |
| Stealth | Rank 2 | 1785 | 20 | trainer | Subtlety | - | G (DB2 + WH) |
| Riposte | - | 14251 | 20* | TALENT (Combat section, row 3) | Combat (A) | - | G (DB2 tree 1111); level A |
| Premeditation | - | 14183 | 20* | TALENT (Subtlety section, row 3) | Subtlety (A) | **no** (see changes) | G (DB2 tree 1111; SpellLevels also 20) |
| Distract | - | 1725 | 22 | trainer | Subtlety | - | G (DB2 + WH) |
| Garrote | Rank 2 | 8631 | 22 | trainer | Assassination | **Stealth** | G (DB2 + WH) |
| Sinister Strike | Rank 4 | 1759 | 22 | trainer | Combat | - | G (DB2 + WH) |
| Vanish | Rank 1 | 1856 | 22 | trainer | Subtlety | - | G (DB2 + WH) |
| Eviscerate | Rank 4 | 6762 | 24 | trainer | Assassination | - | G (DB2 + WH) |
| Shank | (no rank text) | 1329283 | 24 | trainer (NEW in Forever) | Combat | - | G (DB2 + WH) |
| Cold Blood | - | 14177 | 25* | TALENT (Assassination section, row 4) | Assassination (A) | - | G (DB2 tree 1111); level A |
| Ghostly Strike | - | 14278 | 25* | TALENT (Subtlety section, row 4) | Subtlety | - | G (DB2 tree 1111); level A |
| Ambush | Rank 2 | 8724 | 26 | trainer | Assassination | **Stealth** | G (DB2 + WH) |
| Cheap Shot | - | 1833 | 26 | trainer | Assassination | **Stealth** | G (DB2 + WH) |
| Expose Armor | Rank 2 | 8649 | 26 | trainer | Assassination | - | G (DB2 + WH) |
| Kick | Rank 2 | 1767 | 26 | trainer | Combat | - | G (DB2 + WH) |
| Backstab | Rank 4 | 2591 | 28 | trainer | Combat | - | G (DB2 + WH) |
| Feint | Rank 2 | 6768 | 28 | trainer | Combat | - | G (DB2 + WH) |
| Rupture | Rank 2 | 8639 | 28 | trainer | Assassination | - | G (DB2 + WH) |
| Sap | Rank 2 | 2070 | 28 | trainer | Subtlety | **Stealth** | G (DB2 + WH) |
| Disarm Trap | - | 1842 | 30 | trainer | Subtlety | - | G (DB2 + WH) |
| Garrote | Rank 3 | 8632 | 30 | trainer | Assassination | **Stealth** | G (DB2 + WH) |
| Kidney Shot | Rank 1 | 408 | 30 | trainer | Assassination | - | G (DB2 + WH) |
| Sinister Strike | Rank 5 | 1760 | 30 | trainer | Combat | - | G (DB2 + WH) |
| Blade Flurry | - | 13877 | 30* | TALENT (Combat section, row 5) | Combat (A) | - | G (DB2 tree 1111); level A (SpellLevels says 1, stale) |
| Preparation | - | 14185 | 30* | TALENT (Subtlety section, row 5) | Subtlety (A) | - | G (DB2 tree 1111); level A |
| Hemorrhage | - | 16511 | 30* | TALENT (Subtlety section, row 5) | Subtlety | - | G (DB2 tree 1111; SpellLevels also 30) |
| Eviscerate | Rank 5 | 8623 | 32 | trainer | Assassination | - | G (DB2 + WH) |
| Gouge | Rank 3 | 8629 | 32 | trainer | Combat | - | G (DB2 + WH) |
| Ambush | Rank 3 | 8725 | 34 | trainer | Assassination | **Stealth** | G (DB2 + WH) |
| Blind | - | 2094 | 34 | trainer | Subtlety | - | G (DB2 + WH) |
| Sprint | Rank 2 | 8696 | 34 | trainer | Combat | - | G (DB2 + WH) |
| Backstab | Rank 5 | 8721 | 36 | trainer | Combat | - | G (DB2 + WH) |
| Expose Armor | Rank 3 | 8650 | 36 | trainer | Assassination | - | G (DB2 + WH) |
| Rupture | Rank 3 | 8640 | 36 | trainer | Assassination | - | G (DB2 + WH) |
| Garrote | Rank 4 | 8633 | 38 | trainer | Assassination | **Stealth** | G (DB2 + WH) |
| Sinister Strike | Rank 6 | 8621 | 38 | trainer | Combat | - | G (DB2 + WH) |
| Eviscerate | Rank 6 | 8624 | 40 | trainer | Assassination | - | G (DB2 + WH) |
| Feint | Rank 3 | 8637 | 40 | trainer | Combat | - | G (DB2 + WH) |
| Stealth | Rank 3 | 1786 | 40 | trainer | Subtlety | - | G (DB2 + WH) |
| Mutilate | Rank 1 | 399956 | 40* | TALENT (Assassination section, row 7) | Assassination | - | G (DB2 tree 1111; SpellLevels also 40) |
| Adrenaline Rush | - | 13750 | 40* | TALENT (Combat section, row 7) | Combat (A) | - | G (DB2 tree 1111); level A |
| Death Mark | Rank 1 | 1316709 | 40* | TALENT (Subtlety section, row 7) (NEW in Forever) | Subtlety | - | G (DB2 tree 1111; SpellLevels also 40) |
| Ambush | Rank 4 | 11267 | 42 | trainer | Assassination | **Stealth** | G (DB2 + WH) |
| Kick | Rank 3 | 1768 | 42 | trainer | Combat | - | G (DB2 + WH) |
| Slice and Dice | Rank 2 | 6774 | 42 | trainer | Assassination | - | G (DB2 + WH) |
| Vanish | Rank 2 | 1857 | 42 | trainer | Subtlety | - | G (DB2 + WH) |
| Backstab | Rank 6 | 11279 | 44 | trainer | Combat | - | G (DB2 + WH) |
| Rupture | Rank 4 | 11273 | 44 | trainer | Assassination | - | G (DB2 + WH) |
| Shank | (no rank text) | 1329549 | 44 | trainer (2nd rank; SupercedesSpell 1329283) | Combat | - | G (DB2 + WH) |
| Expose Armor | Rank 4 | 11197 | 46 | trainer | Assassination | - | G (DB2 + WH) |
| Garrote | Rank 5 | 11289 | 46 | trainer | Assassination | **Stealth** | G (DB2 + WH) |
| Gouge | Rank 4 | 11285 | 46 | trainer | Combat | - | G (DB2 + WH) |
| Sinister Strike | Rank 7 | 11293 | 46 | trainer | Combat | - | G (DB2 + WH) |
| Death Mark | Rank 2 | 1325756 | 48 | trainer (needs the talent) | Subtlety | - | G (DB2 + WH) |
| Eviscerate | Rank 7 | 11299 | 48 | trainer | Assassination | - | G (DB2 + WH) |
| Sap | Rank 3 | 11297 | 48 | trainer | Subtlety | **Stealth** | G (DB2 + WH) |
| Ambush | Rank 5 | 11268 | 50 | trainer | Assassination | **Stealth** | G (DB2 + WH) |
| Kidney Shot | Rank 2 | 8643 | 50 | trainer | Assassination | - | G (DB2 + WH) |
| Mutilate | Rank 2 | 1241582 | 50 | trainer (needs the talent) | Assassination | - | G (DB2 + WH) |
| Backstab | Rank 7 | 11280 | 52 | trainer | Combat | - | G (DB2 + WH) |
| Feint | Rank 4 | 11303 | 52 | trainer | Combat | - | G (DB2 + WH) |
| Rupture | Rank 5 | 11274 | 52 | trainer | Assassination | - | G (DB2 + WH) |
| Garrote | Rank 6 | 11290 | 54 | trainer | Assassination | **Stealth** | G (DB2 + WH) |
| Sinister Strike | Rank 8 | 11294 | 54 | trainer | Combat | - | G (DB2 + WH) |
| Death Mark | Rank 3 | 1325757 | 56 | trainer (needs the talent) | Subtlety | - | G (DB2 + WH) |
| Eviscerate | Rank 8 | 11300 | 56 | trainer | Assassination | - | G (DB2 + WH) |
| Expose Armor | Rank 5 | 11198 | 56 | trainer | Assassination | - | G (DB2 + WH) |
| Ambush | Rank 6 | 11269 | 58 | trainer | Assassination | **Stealth** | G (DB2 + WH) |
| Kick | Rank 4 | 1769 | 58 | trainer | Combat | - | G (DB2 + WH) |
| Sprint | Rank 3 | 11305 | 58 | trainer | Combat | - | G (DB2 + WH) |
| Backstab | Rank 8 | 11281 | 60 | trainer | Combat | - | G (DB2 + WH) |
| Backstab | Rank 9 | 25300 | 60 | book/drop (WH source 2) | Combat | - | G (DB2 + WH) |
| Death Mark | Rank 4 | 1325758 | 60 | trainer (needs the talent) | Subtlety | - | G (DB2 + WH) |
| Eviscerate | Rank 9 | 31016 | 60 | book/drop (WH source 2) | Assassination | - | G (DB2 + WH) |
| Feint | Rank 5 | 25302 | 60 | book/drop (WH source 2) | Combat | - | G (DB2 + WH) |
| Gouge | Rank 5 | 11286 | 60 | trainer | Combat | - | G (DB2 + WH) |
| Mutilate | Rank 3 | 1241584 | 60 | trainer (needs the talent) | Assassination | - | G (DB2 + WH) |
| Rupture | Rank 6 | 11275 | 60 | trainer | Assassination | - | G (DB2 + WH) |
| Stealth | Rank 4 | 1787 | 60 | trainer | Subtlety | - | G (DB2 + WH) |

**Not on the list, with the reason**
- **Redirect 438040.** DB2 SkillLineAbility (Subtlety) says `AcquireMethod 0`, level 1.
  But WH Forever shows no trainer and no quest. It is also in the Classic Era (Season of Discovery) data.
  How you get it is **unknown**. A: probably not learnable. It is on block D in the draft, so it only shows up if the client has it.
- **Season of Discovery rune leftovers** (all `AcquireMethod 3` = never learned, G):
  Shadowstrike, Shuriken Toss, Saber Slash, Shiv, Main Gauche, Poisoned Knife, Between the Eyes, Blade Dance, Quick Draw,
  and the Mutilate damage parts 399960/399961/1241585/1241586/1241588/1241590.
  The "Engrave ..." spells are SkillLine 2851 Engraving. WH says rune items teach them. A: not part of Forever play. Not on the block.
- **Envenom.** It is not in Forever:
  - 399963 has no SpellName in 70790.
  - The chain 1241505 → 1241507 → 1241508 → 1241509 in Assassination has no name, level or misc data. WH Forever does not know 1241505.
  - A: it is not playable in this build. Watch later builds.
- **Passives** (not active): Detect Traps 2836 (trainer 24), Poised 1328825 (trainer 18, NEW), Safe Fall 1860 (trainer 40), Venom 1329328 (talent),
  plus all the other talent nodes.

### Poisons (block D question)
- **Poisons 2842** (the profession). DB2 level 20.
  WH Forever (G): reward from **Klaven's Tower 2359** (Alliance, quest level 24, needs 20) and **Hinott's Assistance 2480** (Horde, level 20).
  WH also lists rogue trainers on the "taught by" tab.
- The poisons are still **crafted items**. G: every poison "spell" in SkillLine 40 has Effect 24, which creates an item.
  The text ("Coats a weapon with poison that lasts 30 minutes...") describes using that item.
  The recipes are: Instant I-VI, Deadly I-V, Crippling I-II, Mind-numbing I-III, Wound I-IV, Blinding Powder,
  and the newer Atrophic, Numbing, Sebacious and Occult I-II. Recipe levels are in the A/G dump `rogue_work\rogue_sla.tsv`.
- So putting poison on a weapon is an **item use**, not a spell. The ForeverBlock engine only handles spells
  (`Known()` uses `C_Spell.GetSpellInfo`). A: poisons belong on **block D** (the player's own bar), dragged there by the player.
  A future engine option would be an item macro per weapon hand. Open question 6.

### Racials for the Rogue races (G: DB2 SkillLineAbility race masks + CharBaseInfo)

| Race | Active racials (ID, cooldown) | Passive |
|---|---|---|
| Human | Perception 20600 (3 min), **Will to Survive 1259718** (3 min, removes stuns) | Ruthless, The Human Spirit |
| Orc | Blood Fury 20572 (2 min), **Shatter Curse 1299026** (3 min) | Hardiness, Command |
| Dwarf | Stoneform 20594 (3 min), Find Treasure 2481 | Artisan's Precision, Big Game Hunter |
| Night Elf | Shadowmeld 20580, **Elune's Light 1259799** (3 min) | Quickness, Wisp Spirit |
| Undead | Will of the Forsaken 7744 (2 min), Cannibalize 20577 (2 min) | Underwater Breathing, Touch of the Grave |
| Gnome | Escape Artist 20589 (2 min), **Eureka! 1259812** (2 min; this version is Rogue-only, ClassMask 8) | Engineering Specialization, Expansive Mind |
| Troll | Berserking 20554 (3 min), **Rapid Regeneration 1260270** (3 min) | Regeneration, Beast Slaying |
| Skyborne, both factions | **Walk on Air 1259416** (90 s glide) | Elemental Insight, Wind Blessed |
| High Order Skyborne (95) | **Read Leyline 1259705** (2 min, health/mana regen) | |
| Windshaper Skyborne (96) | **Skysight 1259686** (2 min, movement speed) | |

- **Bold** = not a Classic racial. Skyborne uses RaceMasks_1: bit 32 = race 95, bit 33 = race 96 (G).
- SkillRaceClassInfo 2525 gives the Skyborne racial line to ClassMask 1503, which includes Rogue (G).

### What Forever changed compared with Classic Era 1.15.9.70576 (G, DB2 diff)
- **New spells:** Shank (24 and 44), Death Mark (Subtlety capstone at 40, ranks 2-4 at 48/56/60), Poised (passive, 18) and Venom (passive talent).
- **Mutilate** 399956 was a Season of Discovery rune (`AcquireMethod 3`, level 1). Now it is `AcquireMethod 0`, level 40 (talent), with trainer ranks at 50 and 60.
- **Removed:** Hemorrhage ranks 2-3 (17347/17348). Hemorrhage is now one rank. Envenom 399963 is gone.
- **Premeditation:** the stealth requirement is gone (ShapeshiftMask 536870912 → 0). It moved from the Classic 30-point tier to row 3.
- **Ghostly Strike** now also says: "causes your next Ambush or Garrote cast ... to not require Stealth".
- **Hemorrhage** now raises Rupture and Garrote damage taken.
- **Cold Blood** now also affects Mutilate.
- **Sap:** up to 2 targets with the Quick Getaway talent (1310728). New text: "Does not break Stealth".
- **Distract** now also lowers enemy stealth detection.
- **Tree:** Murder, Sleight of Hand, Improved Sap, Deadliness and the weapon specialisations are gone from the live tree.
  Several node IDs were renamed (14162 is now "Coup de Grace"; in Classic it was Improved Eviscerate).

## States and macro conditions

**Stealth is the Rogue's only state.**

### Evidence
- **G (DB2):** Stealth R1-R4 (1784/1785/1786/1787), effect 0 = aura 36 (shapeshift) with value 30.
  **SpellShapeshiftForm 30 = "Stealth", BonusActionBar = 1.**
- **G (DB2, scan with a positive control):** of all Rogue SkillLineAbility spells, plus the talent spells and the Vanish auras 11327/11329,
  only Stealth R1-R4 have aura 36 (the control, Stealth 1784, was found).
  Besides those four, the whole client has five other spells that set form 30. None of them is a Rogue spell: Stealth (TEST) 8874,
  Arantir's Deception 9736/9740, a DNT fog 460631, and an unattached "Stealth" 1256867.
- **G (Blizzard UI, forever, 70790):** `ActionBarController_UpdateAll` uses `C_ActionBar.GetBonusBarIndex()`
  when `HasBonusActionBar()` and the page is 1. So the main bar pages by bonus bar.
- **G (EllesmereUI on Forever):**
  - `CLASS_PAGING_STATES.ROGUE = { { id = "stealth", macro = "[bonusbar:1]", label = "Stealth" } }`.
  - `CLASS_DEFAULTS.ROGUE = { stealth = 7 }`.
  - The comment on Forever: "every class pages bar 1 by its stance/form offset (6 + offset)".
- **Openers need form 30.** G: ShapeshiftMask 536870912 on Ambush, Garrote, Cheap Shot, Sap and Pick Pocket.
  A: bit 29 = form 30, the same reading the Druid list used.

### So the condition is `[bonusbar:1]`, not `[stealth]` (A, with reasons)
- **Shadowmeld (Night Elf) is the trap.** G: Shadowmeld is a stealth aura (aura 16 + 103) with **no** shapeshift aura.
  - A: so `[stealth]` (IsStealthed) is true in Shadowmeld, but the openers cannot be cast, because they need form 30.
  - `[bonusbar:1]` stays false in Shadowmeld. That is exactly right.
- **Vanish** (1856/1857) triggers 11327/11329. Those carry the stealth aura and themselves need form 30 (G).
  A: Vanish puts you into Stealth, so `[bonusbar:1]` is true after Vanish. To check in game.
- **State definition:** `{ name = "stealth", cond = "[bonusbar:1]", guards = true }`, `baseGuard = "[nobonusbar:1]"`.
- **Not yet tested in Forever:** a `[bonusbar:N]` macro in Rob's client.
  - The Druid table uses it, but its forms only come at level 10/20.
  - Test: `/run print(GetBonusBarOffset())` in Stealth should print 1. Out of Stealth and in Shadowmeld it should print 0.
- **Ghostly Strike exception (G text, A effect).** After Ghostly Strike, Ambush and Garrote work **without** Stealth.
  - The stealth keys cannot follow that, because classic macros have no aura condition.
  - A Subtlety Rogue who wants that combo needs Ambush/Garrote somewhere unconditional. Open question 3.

### Extra pseudo-states for the ranged key (my addition, A)
- `[equipped:Guns]`, `[equipped:Bows]` and `[equipped:Crossbows]`, with no guard.
- The engine supports any condition per state, and only keys that name the state get the clause.
- Caveat (A): the item-type words are client-language words. But the whole engine already assumes an English client, because it works by English spell name.

## Proposal per key (Rogue)

- Levels are the earliest level. `*` = talent (row rule, A).
- "—" = nothing.
- Stealth column = what the key does in `[bonusbar:1]`. An empty Stealth cell means the base spell also works in Stealth (no guard).

| Key | Task | Base | Stealth `[bonusbar:1]` | Why (A unless marked) |
|---|---|---|---|---|
| 1 | main | Sinister Strike (1) | Garrote (14) | Main builder. In Stealth: the opener that works with every weapon. Before 14, 1 is Sinister Strike in Stealth too (rule 3). |
| 2 | rotation | Backstab (4) | Ambush (18) | Both need "dagger + behind" (G text), so the key keeps its job: the dagger hit from behind. |
| 3 | rotation | Mutilate (40*) / Hemorrhage (30*) | | The talent builder. One list: A, they exclude each other (31 + 21 points > 51). Works in Stealth too. |
| 4 | spender | Eviscerate (1) | | The main finisher from level 1. |
| 5 | rotation / spender | Rupture (20) | | KeyBlock's own spender places are 4, 5 and Shift-4 (G, CATEGORY.spender). |
| Shift-4 | 2nd spender | Slice and Dice (10) | | Same place as the Druid's 2nd finisher (Ferocious Bite). |
| Shift-1 | AoE | Blade Flurry (30*) | | The Rogue's only cleave. Retail Rogue has Blade Flurry on Shift+1 too (G, KeybindRoles_Rogue.lua line 88). |
| Shift-2 | AoE (ranged here) | Shoot Gun / Shoot Bow / Shoot Crossbow (by equipped weapon), else Throw (1) | | The Rogue has no 2nd AoE. Retail precedent: Rob kept Poisoned Knife (the ranged builder) on Shift+2 (G, line 72, 23 Oct). |
| Shift-3 | cd3 | Shank (24) | | Everyone has it. It has a 10 s cooldown and gives Energy back (G: cd 10000 ms, 5 Energy, energize effect). |
| Q | big cooldown | Adrenaline Rush (40*) / Death Mark (40*) | | The capstones: one list, they exclude each other (31 + 31). Retail: Adrenaline Rush and Deathmark are on Q (G, lines 74 and 92). Death Mark is really a 10 s finisher (G); see question 4. |
| F1 | cd2 | Cold Blood (25*) | | |
| F3 | cd4 | Preparation (30*) | | |
| Shift-F1 | cd2b | Riposte (20*) | | Talent with a short cooldown, like the Druid's Swiftmend here. 6 s cooldown, off the GCD (G: StartRecoveryTime 0). |
| E | interrupt | Kick (12) | | Same in Stealth. |
| R | movement | Sprint (10) | | The Druid's Dash analog (Druid R = Dash in Cat). |
| Shift-R | movement 2 | Stealth (1) | (pressing again leaves Stealth, A) | Same place as the Druid's Prowl. |
| F | taunt / help | Feint (16) | Pick Pocket (4) | Forever Feint only lowers threat (G text), like the Druid's Cower on F. In Stealth Feint is useless, so Pick Pocket goes here. |
| Z | small defensive | Evasion (8) | | The Rogue's own damage cooldown, like Barkskin on Z. Retail had Feint on Z; see question 5. |
| X | defensive 2 | Vanish (22) | | The escape. |
| C | big defensive / big heal | — | | A Forever Rogue has none. See question 7. |
| Shift-Z | defensive row 2 | Expose Armor (14) | | Group utility (armor debuff). The Druid used this row for its group buffs. |
| Shift-X | defensive row 2 | Ghostly Strike (25*) | | It gives +15% dodge for 7 s (G), so a small defensive as well as a builder. |
| Shift-C | defensive row 2 | Premeditation (20*) | | No longer needs Stealth in Forever (G mask). |
| V | CC | Kidney Shot (30) | Cheap Shot (26) | V = the stun, like the Druid (Bash / Pounce). |
| Shift-Q | CC | Gouge (6) | Sap (10) | Shift-Q = the incapacitate that breaks on damage (both, G text). The Druid has Hibernate here. |
| Shift-F | CC | Distract (22) | | The Druid has Soothe Animal here (calming / attention). |
| Shift-V | CC / dispel | Blind (34) | | The Rogue has no dispel. |
| F2 | quick heal | — | | No Rogue heal in Forever. |
| F4 | heal over time / recuperate | Cannibalize (Undead) / Rapid Regeneration (Troll) / Read Leyline (High Order Skyborne) | | The racial heals over time. Each race has at most one, so one list. See question 8. |
| Shift-E | racial | Shadowmeld / Perception / Blood Fury / Stoneform / Will of the Forsaken / Escape Artist / Berserking / Walk on Air | | The Classic racial of each race (Skyborne: Walk on Air). New racials go to block D, as Elune's Light did for the Druid. |
| Ctrl-1/2/3 | forms / stances | — | | The Rogue has no forms. Stealth sits on Shift-R. |
| T / Shift-T / G | fixed | potion / healthstone / trinket | | Not spells. |
| block D | own bar | Pick Lock, Disarm Trap, Redirect (if it exists), Elune's Light, Will to Survive, Shatter Curse, Find Treasure, Eureka!, Skysight, and the poison items | | Things that are not combat keys, or that are race-specific extras. |

**Example macros the engine would write (A, from the engine code):**
- 1: `/cast [bonusbar:1] Garrote; [nobonusbar:1] Sinister Strike`
- V at 26-29: `/cast [bonusbar:1] Cheap Shot`. From 30: `... ; [nobonusbar:1] Kidney Shot`.
- Shift-2: `/cast [equipped:Guns] Shoot Gun; [equipped:Bows] Shoot Bow; [equipped:Crossbows] Shoot Crossbow; Throw`. That is about 110 characters, under the 255 limit.

## Draft Lua table (for review, NOT in the repo)

```lua
-- DRAFT 5-6 Nov 2026, not approved. Shape: Modules/ForeverBlock.lua header. Names exactly as in SpellName.csv (70790).
ns.FOREVER_BLOCK_CLASSES.ROGUE = {
	states = {
		{ name = "stealth", cond = "[bonusbar:1]", guards = true },
		-- Ranged key only (Shift-2): pick the shot that matches the equipped ranged weapon.
		{ name = "gun", cond = "[equipped:Guns]" },
		{ name = "bow", cond = "[equipped:Bows]" },
		{ name = "xbow", cond = "[equipped:Crossbows]" },
	},
	baseGuard = "[nobonusbar:1]",
	keys = {
		["1"] = { stealth = "Garrote", base = "Sinister Strike" },
		["2"] = { stealth = "Ambush", base = "Backstab" },
		["3"] = { all = { "Mutilate", "Hemorrhage" } },
		["4"] = { all = "Eviscerate" },
		["5"] = { all = "Rupture" },
		["SHIFT-4"] = { all = "Slice and Dice" },
		["SHIFT-1"] = { all = "Blade Flurry" },
		["SHIFT-2"] = { gun = "Shoot Gun", bow = "Shoot Bow", xbow = "Shoot Crossbow", base = "Throw" },
		["SHIFT-3"] = { all = "Shank" },
		["Q"] = { all = { "Adrenaline Rush", "Death Mark" } },
		["F1"] = { all = "Cold Blood" },
		["F3"] = { all = "Preparation" },
		["SHIFT-F1"] = { all = "Riposte" },
		["E"] = { all = "Kick" },
		["R"] = { all = "Sprint" },
		["SHIFT-R"] = { all = "Stealth" },
		["F"] = { stealth = "Pick Pocket", base = "Feint" },
		["Z"] = { all = "Evasion" },
		["X"] = { all = "Vanish" },
		["SHIFT-Z"] = { all = "Expose Armor" },
		["SHIFT-X"] = { all = "Ghostly Strike" },
		["SHIFT-C"] = { all = "Premeditation" },
		["V"] = { stealth = "Cheap Shot", base = "Kidney Shot" },
		["SHIFT-Q"] = { stealth = "Sap", base = "Gouge" },
		["SHIFT-F"] = { all = "Distract" },
		["SHIFT-V"] = { all = "Blind" },
		["F4"] = { all = { "Cannibalize", "Rapid Regeneration", "Read Leyline" } },
		["SHIFT-E"] = { all = { "Shadowmeld", "Perception", "Blood Fury", "Stoneform", "Will of the Forsaken",
			"Escape Artist", "Berserking", "Walk on Air" } },
	},
	toBlockD = { "Pick Lock", "Disarm Trap", "Redirect", "Elune's Light", "Will to Survive", "Shatter Curse",
		"Find Treasure", "Eureka!", "Skysight" },
	listed = { "Poisons" }, -- the profession spell; may appear in the spellbook scan (A)
}
```

**Engine notes (A, from reading `ForeverBlock.lua`)**
- **`all`** returns early, without conditions. That is right here, because none of those keys has a Stealth spell.
- **Shift-2** has no Stealth entry, so it gets no guard. Its picture is always Throw's icon, because `show = baseId or show`. That is cosmetic.
- **Lists** mean "first known wins". On 3, a character with both Mutilate and Hemorrhage would only get Mutilate.
  The "Talented" perk does not raise the 51 maximum (G), so that cannot happen.

## Open questions for Rob

1. **Stealth on 1:** Garrote (any weapon, from behind), Cheap Shot (from the front, stun), or Ambush (dagger)? My pick is Garrote, with Cheap Shot on V and Ambush on 2.
2. **Pick Pocket on F in Stealth** (and Feint on F, as the Druid has Cower)? Or Pick Pocket on block D, and Feint on Z as in retail?
3. **Ghostly Strike plus Ambush/Garrote without Stealth (Subtlety).** Shall I put Ambush and Garrote **also** on block D (`toBlockD`), so a Subtlety Rogue can press them after Ghostly Strike?
4. **Q = Adrenaline Rush / Death Mark.** Death Mark is a finisher with a 10 s cooldown and a 6 s mark (G), not a big cooldown. Q echoes retail Deathmark-on-Q. The alternative is C (empty) or Shift-C.
5. **Feint on F** goes against retail, where Feint is on Z as a small defensive (`defensive_1`). Forever Feint only lowers threat (G), so I chose F. OK?
6. **Poisons are items.** Block D for now. Do you want an engine option later for item macros (one key per weapon hand)? That would be an engine change for one class. It needs a client test.
7. **C is empty.** Candidates: the new defensive racials (Will to Survive, Shatter Curse), or Preparation (it resets Evasion and Vanish).
8. **Racial heals on F4.** The task matches "heal over time / recuperate". But the Druid rule put new racials on block D. Keep F4, or everything on Shift-E and block D?
9. **Skyborne:** Walk on Air on Shift-E, Read Leyline on F4, Skysight on block D. The approved **Druid** table has no Skyborne racial at all, though Skyborne can be a Druid (CharBaseInfo 900/903, G). Is that worth a separate look?
10. **Ranged on Shift-2** with `[equipped:...]` pseudo-states. OK, or the ranged shot to block D?
11. **Redirect:** in the DB2 as `AcquireMethod 0`, but no trainer or quest on WH. Can someone with a Rogue check it at a trainer?

## What is GEMETEN vs AFGELEID

**GEMETEN**
- Every ID, rank, SpellLevel, SkillLine (tab), AcquireMethod, ShapeshiftMask, cooldown, duration and energy cost in this file. Source: DB2 70790.
- WH Forever source and level per ability: 154-row listview, plus the Poisons quests (2359/2480), Pick Lock trainers and Redirect without a source.
- Talent tree 1111:
  - its nodes, sections and rows;
  - the row conditions (spent 5/10/15/20/25/30);
  - 51 points from level 10 to 60;
  - the "Talented" spell text.
- Stealth form 30 with BonusActionBar 1.
- Shadowmeld has no shapeshift aura.
- Blizzard's forever ActionBarController pages by bonus bar.
- EllesmereUI's Rogue state is `[bonusbar:1]`.
- The Classic Era vs Forever differences listed above (DB2 diff with 1.15.9.70576).
- Which races can be a Rogue (CharBaseInfo), and their racials (SkillLineAbility race masks).
- The retail precedents (KeybindRoles_Rogue.lua lines).

**AFGELEID**
- The earliest level of each talent (row rule; up to 5 lower with "Talented").
- That the mask bit means "needs this form".
- That `[stealth]` is true in Shadowmeld.
- That Vanish leaves you in Stealth form.
- That Stealth on Shift-R cancels Stealth when pressed again.
- That Mutilate/Hemorrhage and the three capstones exclude each other (point arithmetic).
- That Redirect, Envenom and the runes are not playable.
- That the `[equipped:Guns]`-style words work as written.
- The whole key proposal: every place is a judgment call.
- The tab of the 6 talent spells that have no SkillLineAbility row.

**Not verified (cannot be measured from here)**
- `[bonusbar:1]` in a real Forever macro.
- Whether the level-60 books (Backstab IX, Eviscerate IX, Feint V) can drop yet.
- Whether a Rogue starts with the Thrown skill. A: yes, from `AcquireMethod 2` on Thrown 2567 with ClassMask 13.
- Trainer costs: WH only, not used.
