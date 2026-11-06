> Fact-check by mh-research (6 Nov 2026) of the How to play text for Warrior, Rogue, Priest, Shaman and Warlock.
> Every correction here was applied by mh-writer; the final text is in Modules/ForeverHowToPlay.lua.

# Fact-check: HTP_5_CLASSES.md (Warrior, Rogue, Priest, Shaman, Warlock), WoW Forever 1.60.1.70790

Checked 6 Nov 2026 by an independent research agent. Read only; nothing in the repo was touched. Keys were NOT checked
(as asked). Every verdict says MEASURED (seen in a named, dated source) or INFERRED (reasoned from data).

## Sources used

- **DB2, build 1.60.1.70790 (wowf), wago.tools.**
  - Local extract `scratchpad\wago_wowf\` (fetched 5 Nov 2026): Spell, SpellName, SpellMisc, SpellLevels, SpellCooldowns,
    SpellCategories, SpellEffect, SpellShapeshift, SpellShapeshiftForm, SkillLineAbility, Trait* tables.
  - Fetched in the browser on 6 Nov 2026 with `?build=1.60.1.70790`: SpellDuration, SpellCastTimes, SpellReagents,
    SpellEquippedItems, SpellTargetRestrictions, SpellAuraRestrictions, SpellTotems, TotemCategory, SummonProperties,
    PowerType, GlobalStrings, ItemSparse, ChrRaces, CharBaseInfo.
  - Duration indexes used below (SpellDuration): 1 = 10 s, 8 = 15 s, 18 = 20 s, 21 = until cancelled, 31 = 8 s, 165 = 7 s.
  - Cast-time indexes (SpellCastTimes): 7 = 10 s, 14 = 3 s, 16 = 1.5 s.
- **Blizzard, Priest and Warrior deep dive, 30 Sep 2026:** https://worldofwarcraft.blizzard.com/en-us/news/24301514
- **Blizzard, Mage and Shaman deep dive, 7 Oct 2026:** https://worldofwarcraft.blizzard.com/en-us/news/24302097
- **Blizzard, Rogue and Warlock deep dive, 8 Oct 2026:** https://worldofwarcraft.blizzard.com/en-us/news/24310968
  - All three are beta texts. Where they disagree with the live DB2, this file follows the DB2.
- **Icy Veins class-quest guides (third party, "Last Updated Nov 4, 2026"):** /wow-forever/warrior-class-quests,
  /warlock-class-quests, /shaman-class-quests, /rogue-class-quests.
- **warcraft.wiki.gg:** Rage (edited 16 Jan 2026), Combo points (16 Oct 2026), Stealth (18 Feb 2026), Shadowform
  (15 Oct 2026). These pages are retail or classic-era, so only used as INFERRED support.

Note: the text has **18** `[check]` markers, not 17. Warrior 4, Rogue 6, Priest 3, Shaman 3, Warlock 2.

How talent levels were checked (INFERRED from MEASURED tables):
- TraitCurrencySource gives 1 talent point per level from level 10 (currency 3820).
- TraitCond gives the points you must spend first: 10, 15, 20 or 30.
- So the earliest level is 20, 25, 30 or 40. This matches Blizzard's "milestone talents at 11, 16, 21, 31 points".
- Caveat (UNSURE): spell 1225474 "Talented" says *"You gain talent points every level starting at level 5"*. It is a node
  in a separate account-style trait tree (TraitTree 1188, system 45). A character with it reaches each tier up to 5
  levels earlier. "At the earliest" is right for a normal new character.

---

## A. The 18 [check] markers

### 1. Warrior: Rage
> The Warrior has **Rage** instead of mana. [check: how Rage fills (hitting and being hit) and that it runs down outside a fight]

- **Verdict: TRUE.**
  - MEASURED: Blizzard 30 Sep 2026 covers both "Rage from taking damage" and "Rage from dealing damage".
  - MEASURED: DB2 PowerType ID 2 (RAGE) has RegenPeace -12.5 and RegenCombat 0. So it drops outside a fight and does
    not drop in a fight.
  - INFERRED: -12.5 in DB2 units means -1.25 Rage per second. The wiki gives the same figure for retail.
- **Sentence:** "The Warrior has **Rage** instead of mana. You get Rage when you hit and when you are hit. Outside a fight,
  your Rage slowly runs down to 0."

### 2. Warrior: Hamstring
> **V** = Hamstring (8): Battle and Berserker Stance. [check: that it slows the enemy]

- **Verdict: TRUE.** MEASURED, DB2 spell 1715:
  - SpellEffect 680511: aura 33 (slow), base points -40.
  - DurationIndex 8 = 15 s.
  - Description: "slowing the enemy's movement by $s2% for $d".
  - SpellShapeshift: Battle and Berserker.
- **Sentence:** "**V** = Hamstring (8): slows the enemy a lot for 15 seconds. Battle and Berserker Stance."

### 3. Warrior: Bloodrage
> **F1** = Bloodrage (10). [check: what it does (gives Rage)]

- **Verdict: TRUE.** MEASURED, DB2 spell 2687:
  - Description: "Generates ... rage at the cost of health, and then generates an additional ... rage over $29131d".
  - SpellCooldowns: RecoveryTime 60000.
- **Sentence:** "**F1** = Bloodrage (10): gives you Rage right away and a bit more over a few seconds. It costs a little
  health. Cooldown 1 minute."

### 4. Warrior: shields
> Shield Bash, Shield Block and Shield Slam without a shield. [check: that they need a shield]

- **Verdict: TRUE.** MEASURED, DB2 SpellEquippedItems: rows 165150 (spell 72), 165664 (spell 2565) and 183764
  (spell 23922). Each has EquippedItemClass 4 (armor) and subclass mask 64 (shield).
- **Sentence:** keep it. Optional: "All three need a shield in your off hand."

### 5. Rogue: Energy
> The Rogue has **Energy** instead of mana. [check: that Energy fills up by itself, quickly]

- **Verdict: TRUE.**
  - MEASURED: DB2 PowerType ID 4 (ENERGY) has MaxBasePower 100, RegenPeace 10 and RegenCombat 10.
  - INFERRED: that is 10 Energy per second, in and out of a fight, so an empty bar is full in about 10 seconds.
- **Sentence:** "The Rogue has **Energy** instead of mana. Energy fills up by itself, fast: an empty bar is full again in
  about 10 seconds."

### 6. Rogue: speed in Stealth
> **Stealth** (level 1, Shift-R) makes you hard to see. You move slower. [check: slower in Stealth]

- **Verdict: TRUE.** MEASURED, DB2 spell 1784:
  - SpellEffect 680124: aura 33, -50.
  - Description: "reduces your speed by $s3%".
- **Sentence:** "... makes you hard to see. You move at half speed."

### 7. Rogue: combo points
> [check: combo points — builders give combo points, finishers use them all; up to 5]

- **Verdict: TRUE.**
  - MEASURED: DB2 PowerType ID 5 (COMBO_POINTS) has MaxBasePower 5.
  - MEASURED: builders say "Awards $s2 combo point(s)" (Sinister Strike 1752, Backstab 53, Gouge 1776, Garrote 703).
  - MEASURED: finishers list 1 to 5 points (Eviscerate 2098, Kidney Shot 408).
  - INFERRED: "finishers use them all" is not in the Forever DB2 text. warcraft.wiki.gg Combo points (16 Oct 2026) says
    finishers "consume all available combo points".
- **Sentence:** "Hits like Sinister Strike give you **combo points** (up to 5). A finisher uses all your combo points.
  More points make it stronger."

### 8. Rogue: leaving Stealth
> **Shift-R** = Stealth (1): sneak. Press it again to leave Stealth. [check: that pressing it again leaves Stealth]

- **Verdict: TRUE (INFERRED).**
  - MEASURED: SpellShapeshiftForm 30 (Stealth) has Flags 1. Battle Stance (17) has Flags 7, which includes 0x2,
    "not toggleable".
  - INFERRED: Stealth lacks that flag, so pressing it again cancels it. No source states this in so many words.
- **Add (MEASURED, SpellCooldowns for 1784: CategoryRecoveryTime 10000):** "After you leave Stealth, you cannot go back
  in for 10 seconds." This is a real beginner trap when you press it again by accident.

### 9. Rogue: Evasion
> **Z** = Evasion (8): your small defensive key. [check: what it does (more dodge for a few seconds)]

- **Verdict: TRUE.** MEASURED, DB2 spell 5277:
  - Aura 49 (dodge) +50.
  - DurationIndex 8 = 15 s.
  - CategoryRecoveryTime 300000 (5 minutes).
- **Sentence:** "**Z** = Evasion (8): you dodge many more attacks for 15 seconds. Cooldown 5 minutes."
  - Note: "small" undersells it. +50% dodge is a big defensive tool.

### 10. Rogue: openers in Shadowmeld
> Night Elf: Shadowmeld is not Stealth. In Shadowmeld your openers do not work ... [check in game: openers in Shadowmeld]

- **Verdict: probably TRUE (INFERRED). Still needs the in-game test.**
  - MEASURED: Garrote 703, Ambush 8676, Cheap Shot 1833, Sap 6770 and Pick Pocket 921 require shapeshift form 30
    (Stealth) in SpellShapeshift.
  - MEASURED: Shadowmeld 20580 only applies aura 16 (stealth level) and aura 103. It has no aura 36 (form change).
  - INFERRED: so Shadowmeld does not count as the Stealth form.
- **Sentence:** keep it, and keep the in-game check.

### 11. Priest: Psychic Scream
> Psychic Scream on V (enemies around you run away in fear; cooldown 30 seconds). [check: what Psychic Scream does]

- **Verdict: TRUE.** MEASURED, DB2 spell 8122:
  - Description: "causing $i enemies within $a1 yards to flee for $d. Damage caused may interrupt the effect."
  - CategoryRecoveryTime 30000.
  - DurationIndex 31 = 8 s.
- **Sentence:** "... (a few enemies around you run away in fear for up to 8 seconds; damage can end it; cooldown 30
  seconds)."

### 12. Priest: leaving Shadowform
> Healing in Shadowform. No healing spell works in Shadowform. Leave it first: press Ctrl-1 again. [check: that pressing Ctrl-1 again leaves Shadowform]

- **"No healing spell works in Shadowform": TRUE.**
  - MEASURED: description of 15473 says "you may not cast healing spells while in this form".
  - MEASURED: Lesser Heal, Heal, Greater Heal, Flash Heal, Renew and Prayer of Healing all have Shadowform in
    ShapeshiftExclude.
- **"Press Ctrl-1 again": TRUE (INFERRED).** SpellShapeshiftForm 28 (Shadowform) has Flags 201. That has no 0x2
  "not toggleable" bit, so recasting cancels it. Right-clicking the buff also works (INFERRED).
- **UNSURE:** Flags 201 also lacks 0x100 ("don't auto-unshift"). warcraft.wiki.gg (15 Oct 2026, patch 2.3.0 note) says
  casting a spell the form forbids made you leave the form automatically. In Forever a heal may simply end Shadowform
  for you. Needs an in-game test.
- **Extra (MEASURED):** Shadowform also blocks these non-heals:
  - Fear Ward (6346), Chastise (1277331, Dwarf) and Confounding Flash (1277455, Gnome): ShapeshiftExclude_0 = 134217728
    = form 28.
  - This differs from Blizzard's beta line "allows all non-healing spells".
- **Sentence:** "No healing spell works in Shadowform. Fear Ward and the Dwarf and Gnome race spells do not work in it
  either. Leave it first: press Ctrl-1 again."

### 13. Priest: Shackle Undead
> Shackle Undead (Shift-Q) on a normal enemy. [check: Undead only (the name says so)]

- **Verdict: TRUE.** MEASURED:
  - DB2 SpellTargetRestrictions 203869 (spell 9484): TargetCreatureType 32 (Undead).
  - Description: "Shackles the target undead enemy".
- **Sentence:** "Shackle Undead (Shift-Q) on a normal enemy. It only works on Undead enemies."

### 14. Shaman: one totem per element
> Totems belong to four elements: Earth, Fire, Water and Air. [check: only one totem of each element at a time]

- **Verdict: TRUE.**
  - MEASURED: totems summon into SummonProperties 63 (Fire, slot 1), 81 (Earth, slot 2), 82 (Water, slot 3) and
    83 (Air, slot 4).
  - MEASURED: Blizzard 7 Oct 2026 describes the totem bar as "one of each element".
  - INFERRED: a new totem of the same element replaces the old one.
- **Sentence:** "... You can have one totem of each element at a time. A new one replaces the old one."

### 15. Shaman: totem bar at 20
> From level 20 the game gives you a **totem bar**. [check in game: that the totem bar appears at 20]

- **Verdict: TRUE (data). An in-game look is still nice.**
  - MEASURED: DB2 Call of the Elements 66842 has BaseLevel 20.
  - MEASURED: Blizzard 7 Oct 2026: "Learning this ability at level 20 unlocks the totem bar".
- **Extra (MEASURED):** Call of the Elements has CastingTimeIndex 14 (3 s cast). Blizzard says it costs the mana of all
  4 totems.
- **Note on 30 and 40:** DB2 gives Call of the Ancestors (66843) level 30 and Call of the Spirits (66844) level 40, as the
  text says. Blizzard's beta article has the two names the other way round. The live DB2 wins, so keep the text.

### 16. Shaman: casting in Ghost Wolf
> Casting in Ghost Wolf. Almost every Shaman spell does not work in a form. [check in game: does a spell in Ghost Wolf give an error, or end the wolf and cast]

- **Verdict: UNSURE. Needs the in-game test.**
- **What the data says (INFERRED from MEASURED values):**
  - SpellShapeshiftForm 16 (Ghost Wolf) has Flags 200. That has no 0x1 "stance" bit, so it is a real shapeshift.
  - Most Shaman spells have SpellMisc Attributes_0 bit 0x10000 ("not while shapeshifted"). Examples: Lightning Shield
    327680, weapon imbues 328192, Totemic Recall 65536.
  - Flags 200 also has no 0x100 "don't auto-unshift" bit. So the client probably ends the wolf for you, not a red error.
    This is only reasoned; test it.
- **Extra (MEASURED):** Ghost Wolf 2645 has CastingTimeIndex 14 (3 s cast) and is "Only useable outdoors".
- **Sentence for now:** "Casting in Ghost Wolf. Your spells do not work in the wolf. Leave it first (press R again)."
  Keep the in-game check.

### 17. Warlock: Soul Shards
> **4** = Drain Soul (10): use it to kill the enemy, and you get a **Soul Shard**. [check: what a Soul Shard is and that Drain Soul gives one when the enemy dies]

- **Verdict: TRUE, with one important gap.**
  - MEASURED: DB2 1120 description: "Non-trivial targets killed by Drain Soul will always grant you a Soul shard".
    Damaged targets also have a chance to give one.
  - MEASURED: Blizzard 8 Oct 2026: "progressive chance per tick".
  - MEASURED: Soul Shard is item 6265 (ItemSparse).
- **Gap (MEASURED, DB2 SpellReagents):** Soul Shards are spent by:
  - Summon Voidwalker 697, Summon Succubus 712, Summon Incubus 713 and Summon Felhunter 691: 1 shard each.
  - Create Healthstone 6201, Create Soulstone 693, Soul Fire 6353 and Shadowburn 17877.
  - Summon Imp 688 costs none.
- **Sentence:** "**4** = Drain Soul (10): use it to finish off an enemy that gives XP, and you get a **Soul Shard**. A Soul
  Shard is a small item in your bags. You need one to summon most demons (all but the Imp) and to make a Healthstone or
  Soulstone. Grey (too easy) enemies give no shard."

### 18. Warlock: Curse of Exhaustion
> Curse of Exhaustion on R (helps you stay away from the enemy) [check: that it slows the enemy]

- **Verdict: TRUE.**
  - MEASURED: DB2 18223: "Reduces the target's movement speed by $s1% for $d".
  - MEASURED: Blizzard 8 Oct 2026: "reduces movement speed by 30%".
- **Sentence:** "Curse of Exhaustion on R (slows the enemy, so you can stay away from it)".

**Tally of the 18:**
- 14 settled TRUE on measured data: 1, 2, 3, 4, 5, 6, 7, 9, 11, 13, 14, 15, 17, 18.
  - Number 7 has one inferred part ("uses them all").
  - Number 17 needs an added sentence about shard costs.
- 2 TRUE by inference only (Stealth and Shadowform toggles: 8 and 12). Number 12 also has an open question about
  auto-cancel.
- 1 probably TRUE but needs the in-game test (Shadowmeld: 10).
- 1 open (Ghost Wolf casting: 16).

---

## B. Plain claims that are wrong or misleading (corrections)

### B1. Warlock Imp quest names: FALSE
> **Summon Imp** (1, from the quest "The Stolen Tome" (Alliance) or "Piercing the Veil" (Horde)).

- MEASURED, Icy Veins warlock class quests (updated 4 Nov 2026): Human "The Stolen Tome", Gnome "Beginnings",
  Orc/Troll "Vile Familiars", Undead "Piercing the Veil".
- **Sentence:** "**Summon Imp** (1, from your first class quest in your starting area. The name depends on your race:
  Human 'The Stolen Tome', Gnome 'Beginnings', Orc and Troll 'Vile Familiars', Undead 'Piercing the Veil')."

### B2. Inferno "(50, quest)": UNSURE, probably wrong
> Inferno (50, quest) is on **F3**.

- MEASURED: DB2 Inferno 1122 has BaseLevel 50. SpellReagents row 19427 needs item 5565 "Infernal Stone" for each cast.
  CategoryRecoveryTime 3600000 (1 hour).
- No quest found (MEASURED absence in one source only): the Icy Veins quest page says the demon quests go up to the
  Felhunter at 30 and lists none for Inferno. An empty search proves nothing.
- **Sentence:** "Inferno (50) is on **F3**. Each cast needs an Infernal Stone. Cooldown 1 hour." Drop "quest" unless it is
  confirmed in game.

### B3. Ghostly Strike overstated: FALSE as written
> Ghostly Strike (talent): after it, Ambush and Garrote work without Stealth.

- MEASURED, DB2 14278: "causes your next Ambush or Garrote cast within $1329326d to not require Stealth". Spell 1329326
  has DurationIndex 165 = 7 s.
- **Sentence:** "Ghostly Strike (talent): after it, your next Ambush or Garrote works without Stealth, if you use it
  within 7 seconds. MH's keys cannot see that ..." (rest unchanged).

### B4. Preparation too narrow: misleading
> Preparation on F3 (resets Evasion and Vanish)

- MEASURED, DB2 14185: "immediately finishes the cooldown on your other Rogue abilities". RecoveryTime 600000
  (10 minutes).
- **Sentence:** "Preparation on F3 (resets the cooldown of your other Rogue spells, like Evasion, Sprint and Vanish)".

### B5. Vanish and Blind need reagents: missing, a beginner will be stuck
> 22: Distract on Shift-F, Vanish on X (your escape). ... 34: Blind on Shift-V.

- MEASURED, DB2 SpellReagents: Vanish 1856 and 1857 need item 5140 "Flash Powder". Blind 2094 needs item 5530 "Blinding
  Powder" (names from ItemSparse).
- **Sentence:** "Vanish on X (your escape; each use costs a Flash Powder, bought from a vendor)". "34: Blind on Shift-V
  (costs a Blinding Powder)."
  - INFERRED: Flash Powder comes from a vendor and Blinding Powder is made with Poisons, as in Classic. Not checked for
    Forever.

### B6. Sap: missing limits
> **Shift-Q in Stealth** = Sap (10): takes one enemy out for a while. Damage breaks it. Sap does not break your Stealth.

- MEASURED:
  - DB2 6770 description: "Only works on Humanoids that are not in combat ... Does not break Stealth".
  - SpellTargetRestrictions 201876: TargetCreatureType 64 (Humanoid).
- **Sentence:** "... = Sap (10): takes one humanoid enemy out for a while, before the fight starts. It does not work on
  beasts or on enemies already fighting. Damage breaks it. Sap does not break your Stealth."

### B7. Charge "your movement key": missing limit
> **R** = Charge (4): your movement key. It works in Battle Stance only.

- MEASURED, DB2 100 description: "Cannot be used in combat."
- **Sentence:** "**R** = Charge (4): run to an enemy to start a fight. It works in Battle Stance only, and not once you
  are already fighting."

### B8. Charge error text: doubtful wording
> Without it, you get a red "wrong stance" error.

- MEASURED: GlobalStrings 10171, SPELL_FAILED_ONLY_SHAPESHIFT = "Must be in %s".
- INFERRED: the red text reads "Must be in Battle Stance".
- **Sentence:** "Without it, you get a red error: 'Must be in Battle Stance'." Or drop the quotes.

### B9. Power Word: Shield: missing Weakened Soul
> **Z** = Power Word: Shield (6): a shield on you or a friend. Cooldown 4 seconds.

- MEASURED:
  - DB2 17: CategoryRecoveryTime 4000. Description: "Once shielded, the target cannot be shielded again for $6788d".
  - Weakened Soul 6788 has DurationIndex 8 = 15 s.
- **Sentence:** "**Z** = Power Word: Shield (6): a shield on you or a friend. Cooldown 4 seconds, but the same person can
  only get a new shield after 15 seconds."

### B10. Shaman totems need the element's Totem item: missing
> - **Z** = Stoneskin Totem (4, from a quest) ... 30: Grounding Totem on X ...

- MEASURED, DB2 SpellTotems (RequiredTotemCategoryID) with TotemCategory names:
  - Earth Totem (2): Earthbind 2484, Stoneclaw 5730, Strength of Earth 8075, Stoneskin 8071, Tremor 8143.
  - Fire Totem (4): Searing 3599, Magma 8190.
  - Water Totem (5): Healing Stream 5394.
  - Air Totem (3): Grounding 8177.
- MEASURED, Icy Veins shaman quests (4 Nov 2026): Earth Totem at 4 (Skyborne at 3), Fire Totem at 10, Water Totem at 20,
  Air Totem at 30 ("Call of Air").
- **Sentence to add under "Totems":** "Each element has a Totem item that you get from a class quest: Earth (level 4),
  Fire (10), Water (20), Air (30). You need that item in your bags for all totems of that element."
- **Fix the Grounding line:** "30: Grounding Totem on X (needs the Air Totem from the level 30 quest)".

### B11. Grounding Totem target: imprecise
> Grounding Totem on X (takes one harmful spell meant for you)

- MEASURED, DB2 8177: "redirect one harmful spell cast on a nearby party member to itself every $8179t1 seconds. Will
  not redirect area of effect spells."
- **Sentence:** "Grounding Totem on X (catches one harmful spell aimed at you or a group member nearby; not area
  spells)".

### B12. Fire Nova: imprecise
> Pressing Fire Nova (Shift-4) with no fire totem down. It only works next to your own Fire totem (Searing or Magma).

- MEASURED:
  - DB2 408341: "Instantly inflicts ... fire damage to enemies within ... yd of your active Fire totem." Cooldown 10 s
    (CategoryRecoveryTime 10000).
  - Blizzard 7 Oct 2026: "an eruption of Fire damage at the location of your current Fire Totem".
- **Sentence:** "Pressing Fire Nova (Shift-4) with no Fire totem down. It needs one of your Fire totems (like Searing or
  Magma). It hits the enemies near that totem, not the ones near you."

### B13. Healing Stream in the "before level 20" list: minor slip
> Before level 20, your totems each have their own key: ... Healing Stream (F4).

- MEASURED: DB2 Healing Stream 5394 has BaseLevel 20, and the text itself says "20: ... Healing Stream Totem".
- **Fix:** remove Healing Stream from the "before level 20" list.

### B14. Concussion Blow stance note: doubtful
> Concussion Blow on Shift-V (Battle and Defensive), 30.

- MEASURED: DB2 12809 has no SpellShapeshift row, so the spell works in all three stances.
- INFERRED: the "(Battle and Defensive)" note is about the key, because Shift-V is Berserker Rage in Berserker Stance.
  Keys were not checked.
- **Sentence if this is about the spell:** "Concussion Blow on Shift-V (a stun; in Berserker Stance this key is Berserker
  Rage instead), 30."

### B15. Shank needs an off-hand weapon: missing
> 24: Shank on Shift-3 (cooldown 10 seconds, gives a little Energy back).

- MEASURED:
  - DB2 1329283 description: "Instantly strike with your off-hand weapon ... generating $s2 Energy". Base points 15.
  - SpellMisc 874521: Attributes_3 = 17235968, which contains 0x01000000.
- INFERRED: 0x01000000 is "requires an off-hand weapon" in the usual attribute naming.
- **Sentence:** "24: Shank on Shift-3 (a hit with your off-hand weapon, so you need a weapon in each hand; cooldown 10
  seconds; gives 15 Energy back)."

### B16. Rogue Throw: missing weapon need
> **Shift-2** = Throw (1): a ranged throw.

- MEASURED: DB2 SpellEquippedItems 166869 (spell 2764): subclass mask 65536 (Thrown).
- **Sentence:** "**Shift-2** = Throw (1): a ranged throw. You need a throwing weapon (like throwing knives) in your
  ranged slot."

### B17. Human Priest Divine Grace: missing limit
> Human: Divine Grace (10, Shift-R; an instant heal on a friend, not on you)

- MEASURED:
  - DB2 1277370: "Instantly heals a friendly target below $s2% Health ... Cannot be cast on self". SpellEffect 1289711
    base points 50.
  - CategoryRecoveryTime 600000 (10 minutes).
  - Blizzard 30 Sep 2026 said 5 minutes (beta); the DB2 wins.
- **Sentence:** "Human: Divine Grace (10, Shift-R; an instant heal on a friend below half health, not on you; cooldown
  10 minutes)".

### B18. Victory Rush: missing condition
> Victory Rush on F2 (it heals you; cooldown 30 seconds)

- MEASURED:
  - DB2 402927: "Only useable within $402975d after you kill a non-trivial enemy". Victorious 402975 has
    DurationIndex 18 = 20 s.
  - Heals 10% (SpellEffect 1049598, base points 10). RecoveryTime 30000.
- **Sentence:** "Victory Rush on F2 (only in the 20 seconds after you kill an enemy that gives XP; it heals you a bit;
  cooldown 30 seconds)".

### B19. Talent levels "at the earliest": TRUE, with a caveat (UNSURE)
- All talent levels in the text match the DB2 tier gates (method above): Warrior, Rogue, Priest, Shaman and Warlock.
- Blizzard's beta articles put Premeditation (16-point) and Mutilate (21-point) elsewhere. The live DB2 gives
  Premeditation spent ≥10 (level 20) and Mutilate spent ≥30 (level 40), which matches the text. The DB2 wins.
- Caveat (UNSURE): the "Talented" perk (spell 1225474) can lower each tier by up to 5 levels for some accounts.
- Optional addition for block D: Conflagrate 25, Bane of Havoc 30, Wrack 40, Incinerate 40 (at the earliest).

### B20. Warlock: small points
- "Summon Incubus (20)": also from a quest. MEASURED: Icy Veins, separate Succubus and Incubus chains. Write "Summon
  Succubus or Summon Incubus (20, quest)".
- "Create Healthstone (10) goes on block D": it costs a Soul Shard. MEASURED: SpellReagents row 19759, item 6265. Add
  "(costs a Soul Shard)".
- "48: Soul Fire on Q (your biggest hit)" (MEASURED):
  - It costs a Soul Shard (SpellReagents row 19791).
  - It has a 6 s cast (CastingTimeIndex 171 = 6000 ms) and a 1-minute cooldown (CategoryRecoveryTime 60000).
- "It always has a demon with it": overstated. At level 1 you first need the Imp quest. Suggest "It almost always has a
  demon with it."

### B21. Priest and Shaman: small points (optional)
- Lesser Heal "your big heal": at level 1 it is your only direct heal, and its rank 1 cast is 1.5 s (index 16). Suggest
  "your main heal" (INFERRED wording).
- Prayer of Fortitude (48) needs a Holy Candle. Levitate (34) needs a Light Feather. MEASURED: SpellReagents rows for
  21562 → item 17028 "Holy Candle" and 1706 → item 17056 "Light Feather".
- Ghost Wolf (20): 3-second cast and outdoors only. MEASURED: CastingTimeIndex 14; description "Only useable outdoors".
- Cannibalize (Undead, rogue F4 line) only works near a Humanoid or Undead corpse. Rapid Regeneration (Troll) stops when
  you move, act or take damage. MEASURED: descriptions of 20577 and 1260270.

---

## C. Claims checked and fine (brief)

### Warrior
- From 10 it can tank. Defensive Stance at 10 from a quest that also gives Taunt and Sunder Armor (MEASURED: Icy Veins
  4 Nov 2026; DB2 71 / 355 / 7386 base 10).
- Berserker Stance at 30 from "The Affray" (MEASURED: Icy Veins; DB2 2458 base 30).
- Tactical Mastery 14 keeps 10 Rage (MEASURED: DB2 1310185 base points 10; Blizzard 30 Sep).
- Heroic Strike 1, no stance limit (DB2 78, no shapeshift row). Battle Stance 1. Battle Shout 1.
- Charge 4, Battle only (SpellShapeshift). Rend 4, a bleed, Battle and Defensive (mechanic 15). Thunder Clap 6, Battle
  and Defensive, cooldown 6 s, several targets (CategoryRecoveryTime 6000; mask 196608; Blizzard).
- Taunt only in Defensive, cooldown 8 s (catcd 8000). Sunder Armor in every stance.
- Overpower 12, Battle only, after a dodge. Shield Bash 12, interrupts, Battle and Defensive.
- Revenge 14 (Defensive). Demoralizing Shout 14. Mocking Blow 16 (Battle). Shield Block 16 (Defensive). Disarm 18
  (Defensive).
- Cleave 20. Slam 20 with a 1.5 s cast and 15 s cooldown (1240193: CastingTimeIndex 16 = 1500 ms; catcd 15000).
  Victory Rush 20, 30 s cooldown. Retaliation 20 (Battle).
- Intimidating Shout 22. Execute 24 (Battle and Berserker; target at 20% health or lower).
- Challenging Shout 26. Shield Wall 28 (Defensive).
- Retaliation and Shield Wall each 15-minute cooldown, not shared (RecoveryTime 900000, Category 0; Blizzard 30 Sep).
- Intercept 30 and Berserker Rage 30 (Berserker). Whirlwind 36 (Berserker). Pummel 38 (Berserker). Recklessness 50
  (Berserker).
- Vanguard lets Charge work in Defensive Stance (1310317 description). Piercing Howl is an area slow (12323).
- Spearing Strike and Sweeping Strikes need Battle Stance (SpellShapeshift).
- The only self-heal is Victory Rush (INFERRED: Bloodthirst no longer heals per Blizzard; Last Stand is temporary max
  health).
- Shoot Bow/Gun/Crossbow and Throw match the ranged weapon (SkillLineAbility class mask 9 or 13, learned with the weapon
  skill).

### Rogue
- Stealth 1. Pick Pocket 4, Stealth only. Sap 10 and Garrote 14 need Stealth. Ambush 18 needs Stealth, behind and a
  dagger. Cheap Shot 26 needs Stealth and stuns.
- Sinister Strike 1. Eviscerate 1, a finisher. Slice and Dice 10 and Rupture 20, finishers.
- Backstab 4 needs a dagger and to be behind (SpellEquippedItems mask 32768 = dagger; description).
- Gouge 6, any damage breaks it. Sprint 10. Kick 12, interrupt. Expose Armor 14. Feint 16 lowers threat.
- Poisons from a quest around 20 (Icy Veins: the level 20 quest).
- Distract 22. Vanish 22. Shank 24, cooldown 10 s, gives Energy. Kidney Shot 30. Disarm Trap 30. Blind 34.
- Talent levels all match.
- Blade Flurry hits one more nearby enemy. Mutilate needs daggers (mask 32768).
- Cannibalize = Undead, Rapid Regeneration = Troll (RaceMasks 128), Read Leyline = High Order Skyborne (RaceMasks_1 = 1
  → ChrRaces 95, bit 32). Shadowmeld is Night Elf and Blood Fury is Orc (racial SkillLineAbility).

### Priest
- Six Priest races, each with two race spells at 10 and 20, all as listed:
  - Desperate Prayer has a 10-minute cooldown. Starshards has 30 s.
  - Dark Sacrifice trades health for mana. Contingency Plan wards an ally and shields and heals them when low.
  - Races MEASURED: CharBaseInfo has priest rows for races 1/3/4/5/7/8 only. Spells and levels MEASURED in
    SkillLineAbility RaceMasks.
- Smite 1. Lesser Heal 1, then Heal 16 and Greater Heal 40. Shoot 1 needs a wand (mask 524288 = wand).
- Power Word: Fortitude 1. Shadow Word: Pain 4. Power Word: Shield 6 (cooldown 4 s). Fade 8 (cooldown 30 s). Renew 8.
  Mind Blast 10 (cooldown 8 s). Resurrection 10, not in combat (description).
- Inner Fire 12. Cure Disease 14. Dispel Magic 18.
- Flash Heal 20. Holy Fire 20. Shackle Undead 20. Devouring Plague 20 and Fear Ward 20 for all races (RaceMasks -1;
  Blizzard).
- Prayer of Healing 30. Mind Control 30. Shadow Word: Death 32. Abolish Disease 32. Levitate 34. Prayer of Fortitude 48.
- Silence is the only interrupt, a talent at 30. Talent levels all match.

### Shaman
- Dwarves can be Shaman (MEASURED: CharBaseInfo row 905 = race 3, class 7; Icy Veins).
- Ghost Wolf 20.
- Stoneskin 4 from a quest. Earthbind 6, cooldown 15 s. Stoneclaw 8, cooldown 30 s, taunts. Lightning Shield 8.
  Flame Shock 10. Searing 10 from a quest. Strength of Earth 10.
- Weapon buffs: Rockbiter 1, Flametongue 10, Frostbrand 20, Windfury 30. Each lasts 60 minutes (description "Lasts for
  60 minutes"; Blizzard 7 Oct).
- One weapon buff at a time (INFERRED: no Shaman Dual Wield found in the DB2 class lines).
- Earth Shock 4 interrupts. All three shocks share one 6 s cooldown (Category 19, CategoryRecoveryTime 6000).
- Fire Nova 12. Purge 12. Ancestral Spirit 12, not in combat. Cure Poison 16. Tremor 18 removes Fear, Charm and Sleep.
- Frost Shock 20 slows. Lesser Healing Wave 20 (1.5 s cast). Healing Stream 20 from a quest. Call of the Elements 20.
  Totemic Recall 20 gives back 25% mana (SpellEffect base points 25; Blizzard).
- Cure Disease 22. Totemic Call 22 moves totems to you (437009 description, cooldown 30 s). Blizzard's beta article
  called this "Totemic Projection"; the live DB2 has Totemic Call.
- Call of the Ancestors 30. Chain Lightning 32. Chain Heal 40. Call of the Spirits 40.
- One shield at a time (408510: "Only one Elemental Shield can be active"). Talent levels all match.

### Warlock
- Shadow Bolt 1. Immolate 1. Demon Skin 1 (armor and health regen), then Demon Armor 20.
- Corruption 4. Curse of Weakness 4, then Curse of the Elements 20 (440892 base 20). Life Tap 6. Bane of Agony 8.
  Fear 8 (one target at a time).
- Drain Soul 10. Create Healthstone 10. Voidwalker 10 from a quest. Health Funnel 12 heals the pet. Drain Life 14.
  Unending Breath 16. Create Soulstone 18. Searing Pain 18.
- Succubus or Incubus 20 from quests. Rain of Fire 20. Banish 28, Demons and Elementals only (TargetCreatureType 12).
- Felhunter 30 from a quest. Hellfire 30. Shadow Ward 32 (cooldown 30 s). Howl of Terror 40. Death Coil 42 (horror and
  heal; cooldown 2 minutes).
- Soul Fire 48. Bane of Doom 60, not on players (description).
- Voidwalker Torment (pet spell 3716, level 10). Felhunter Spell Lock (19244, level 36).
- One curse and one bane can sit on one enemy (descriptions: "Only one Curse per Warlock" and "Only one Bane per
  Warlock"; Blizzard).
- Shadowburn costs a Soul Shard (SpellReagents row 20433). No interrupt of its own.
- No stances or forms (INFERRED: Metamorphosis is in the DB2 Warlock line but not in any Forever talent node).
- Wand Shoot is learned on its own (acquire method 2).

---

## D. Things a beginner would be actively misled by (priority)

1. Warlock: the Imp quest name is only right for Humans and Undead (B1).
2. Warlock: demon summons (all but the Imp) and the Healthstone cost a Soul Shard. The text never says so, and
   "Demon out (block D)" fails without one (17, B20).
3. Rogue: Vanish and Blind need a powder reagent (B5). Sap only works on Humanoids out of combat (B6). Shank needs an
   off-hand weapon (B15). Throw needs a throwing weapon (B16).
4. Shaman: each element's totems need that element's Totem item from a class quest. Grounding Totem at 30 is useless
   without the Air Totem quest (B10).
5. Rogue: Ghostly Strike only frees the next Ambush or Garrote, within 7 seconds (B3).
6. Warrior: Charge cannot be used once you are in combat (B7). Victory Rush only works right after a kill (B18).
7. Priest: Power Word: Shield on the same target only every 15 seconds (B9). Divine Grace only on friends below half
   health (B17).
8. Stealth: pressing it again by accident means 10 seconds without Stealth (8).
