# Paladin per role (WoW Forever, build 1.60.1.70938) — facts for the beginner text

Researched 17 Nov 2026 by mh-research. Read-only; nothing else in the repo was changed.

**Labels.** GEMETEN = seen by me in this run, in the named source. AFGELEID = reasoned from measured things.
GIDS = a guide says it (name + date); not checked in the client. A level for a talent is always the EARLIEST level:
10 + the points the row needs. The Legacy perk Talented can bring that up to 5 levels sooner (GEMETEN:
TraitCurrencySource 37163-37167, PlayerLevel 9/8/7/6/5, currency 3820).

**Not done.** I did not read the two example files (ROGUE_ROLES / HUNTER_ROLES): my agent rule forbids reading
anything under `docs/`. The layout below follows the seven points of the task, and the shape of the finished role
texts in `Modules/ForeverHowToPlay.lua` (ROLES.DRUID/WARRIOR/MAGE/PRIEST/ROGUE), which I did read.

## 0. Sources

- DB2, local cache `…\gamedata_cache\db2\1.60.1.70938\` (CSV, read with Read/Grep; the front door was not used):
  TalentTab, TraitTree, TraitNode, TraitNodeXTraitNodeEntry, TraitNodeEntry, TraitDefinition, TraitEdge,
  TraitNodeGroupXTraitNode, TraitNodeGroupXTraitCond, TraitCond, TraitDefinitionEffectPoints, CurvePoint,
  TraitCurrencySource, SpellName, Spell, SpellEffect, SpellMisc, SpellDuration, SpellCastTimes, SpellCooldowns,
  SpellAuraOptions, SpellLevels, SpellEquippedItems, SkillLineAbility, SkillRaceClassInfo, CharBaseInfo,
  ChrSpecialization.
- MH code: `Modules/ForeverBlock_Paladin.lua` (keys), `ForeverBlock.lua` (how a key list works),
  `ForeverHowToPlay.lua` (CLASSES.PALADIN), `ForeverMacros.lua` (SPEC_NAMES, paladin rows), `ForeverTrainerData.lua`
  (PALADIN, from What's Training), `ForeverClassQuests.lua` (CHAINS.PALADIN), `ForeverDirection.lua`,
  `ForeverMainStats.lua`, `ForeverBuffs.lua`.
- Guides (all read 17 Nov 2026 through Exa):
  - Wowhead Forever: Protection tank overview (Riyani, updated 14 Nov 2026), Protection leveling (Riyani, 6 Nov 2026),
    Retribution overview (Surveillant, 16 Nov 2026).
  - Icy Veins Forever: Holy rotation page (Mytholxgy, 4 Nov 2026); Paladin class overview (no date shown; contains
    beta values, see 6a); the Icy Veins Ret leveling build as retold by khorium.pro (8 Nov 2026, "as of November 4").
  - ConquestCapped: Protection (13 Nov), Holy (13 Nov), Retribution (13 Nov), Paladin abilities by level (7 Nov).
  - WoW Forever DB (wowfdb.com): Ret / Prot / Holy leveling pages and the Protection page (no date on the page).
  - wowforeveraddon.com Paladin leveling (updated 11 Nov 2026, game version 1.60.1).
  - foreverwow.com Ret and Holy guides (Garazon, build 1.60.1.70862, updated 7 Nov).
  - Warcraft Tavern Protection guide (no date; still lists two talents that are gone, see 6b).
  - wowforeverforge.com Holy (14 Nov), foreversixty.gg Holy, mobalytics Holy, wowhandbook.com spellbook (client
    1.60.1.70938), allthings.how abilities (8 Nov), systematic.gg beta threads (14-24 Oct, BETA: only for 6b).

## 1. Which tree is which band

| Band | Tree | TalentTab ID | OrderIndex | ClassMask | PosX of its nodes (TraitTree 1100) | Nodes | Ranks in total |
|---|---|---|---|---|---|---|---|
| 1 | Holy | 382 | 0 | 2 | 1020-2820 | 17 | 46 |
| 2 | Protection | 383 | 1 | 2 | 5020-6820 | 17 | 49 |
| 3 | Retribution | 381 | 2 | 2 | 9080-10880 | 17 | 44 |

- GEMETEN: TalentTab rows 381/382/383 (ClassMask 2 = Paladin). TraitNode has 51 nodes with TraitTreeID 1100; each one
  resolved node → entry → definition → spell name (tables in 2). Band 1 holds Holy Shock and Light's Vigil, band 2
  Holy Shield and Redoubt, band 3 Seal of Command, Repentance and Vengeance.
- GEMETEN: this matches `ForeverMacros.lua` SPEC_NAMES.PALADIN enUS = { "Holy", "Protection", "Retribution" }, TREE.PALADIN
  = 1100, and the band limits in SpecBand() (posX < 4000 = 1, < 8000 = 2, else 3).
- GEMETEN: **Divine Intellect is in Protection** (node 105332, X 5620) and **Unyielding Faith is in Retribution** (node
  105331, X 9680). Divine Strength, Improved Seals and Holy Conduit are in Holy. (That the first two were Holy talents
  in Classic is from memory, not measured; WoW Forever DB also says "Divine Intellect is a Protection talent".)
- Roles. DB2 has NO role per tree in Forever (GEMETEN: TalentTab.RoleMask is 0 on all rows; ChrSpecialization has one
  row "Paladin"). Holy = healer, Protection = tank, Retribution = damage up close is AFGELEID from the talents
  (healing talents / shield and threat talents / weapon talents) and is what every guide uses (Wowhead "Protection
  Paladin Tank Guide", Icy Veins "Holy Paladin Healer", Wowhead "Retribution Paladin DPS"), and what MH already has in
  `ForeverMainStats.lua` BY_TREE.PALADIN (heal / tank / melee).
- GEMETEN: Paladin races in CharBaseInfo 70938: RaceID 1 (Human), 3 (Dwarf), 5 (Undead).
- GEMETEN: 51 class talent points at 60 (TraitCurrencySource: "Level 10" … "Level 60", one point each).

## 2. The talents per tree

"Needs" = GEMETEN in TraitCond (tree 1100, currency 3820) through TraitNodeGroupXTraitCond: row 2 needs 5 points in
row 1, row 3 needs 10 in rows 1-2, row 4 needs 15 in rows 1-3, row 5 needs 20 in rows 1-4, row 6 needs 25 in rows
1-5, row 7 needs 30 in the tree. Conds: Holy 43191/43330/43329/43328/43326/43327, Protection
43386/43385/43384/43383/50985/50987, Retribution 43438/43437/43436/43435/43434/43433.
"Needs first" = GEMETEN in TraitEdge (left node → right node).
Numbers per rank = GEMETEN in CurvePoint through TraitDefinitionEffectPoints; where that table has no row, the number
is SpellEffect.EffectBasePointsF. ⚠️ The curve overrides the base: Eye for an Eye has base 15 but its curve says 5/10.

### 2a. Holy (band 1)

| Row | Needs | Earliest | Talent (spell id) | Ranks | Key? | What it does |
|---|---|---|---|---|---|---|
| 1 | 0 | 10 | Spiritual Focus (20205) | 5 | passive | 14/28/42/56/70% chance that Flash of Light, Holy Light and Light's Vigil lose no cast time when you are hit |
| 1 | 0 | 10 | Divine Strength (20262) | 5 | passive | +2/4/6/8/10% Strength |
| 2 | 5 | 15 | Healing Light (20237) | 3 | passive | +4/8/12% healing of Holy Light, Flash of Light, Holy Shock |
| 2 | 5 | 15 | Reverence (1310899) | 2 | passive | 15/30% of your mana regeneration goes on while you cast |
| 2 | 5 | 15 | Improved Seals (20224) | 5 | passive | +3/6/9/12/15% damage of Seals and Judgements |
| 2 | 5 | 15 | Purifying Power (429144) | 2 | passive | Cleanse and Purify cost 10/20% less; Exorcism and Holy Wrath cooldown 17/33% shorter |
| 3 | 10 | 20 | **Divine Favor** (20216) | 1 | **Shift-3** | next Flash of Light, Holy Light or Holy Shock: +100% crit chance. Cooldown 2 min, no global cooldown |
| 3 | 10 | 20 | Illumination (20210) | 5 | passive | needs Reverence first. After a crit heal: 20/40/60/80/100% chance to get mana back (tooltip: 50% of the spell's base cost) |
| 3 | 10 | 20 | Holy Conduit (1237268) | 2 | passive | Consecration, Holy Wrath, Exorcism, Hammer of Wrath cost 20/40% less |
| 4 | 15 | 25 | Divine Precision (1310904) | 2 | passive | +4/8% hit with Holy spells; Silence on you 10/20% shorter |
| 4 | 15 | 25 | Infusion of Light (426065) | 2 | passive | a crit with Holy Shock or Flash of Light makes your next Holy Light (within 15 s) 0.5/1.0 s faster |
| 4 | 15 | 25 | **Oath of Light** (1328548) | 1 | **Shift-R** | on one friend, 5 min: your Holy Light, Flash of Light and Holy Shock heal that friend for more. One Oath at a time. No cooldown |
| 5 | 20 | 30 | Consecrated Ground (1310905) | 2 | passive | +5/10% Holy spell damage on the first enemies that enter your Consecration |
| 5 | 20 | 30 | **Holy Shock** (1311606) | 1 | **F4** | instant: Holy damage on an enemy or a heal on a friend. Cooldown 10 s. Ranks 2-4 at the trainer (40, 48, 56) |
| 5 | 20 | 30 (31) | Boundless Light (1328550) | 2 | passive | needs Holy Shock first. +15/30% crit chance of Holy Shock on friends who do NOT have your Oath of Light |
| 6 | 25 | 35 | Holy Power (5923) | 5 | passive | crit heals of Holy spells are 10/20/30/40/50% bigger |
| 7 | 30 | 40 | **Light's Vigil** (1310911) | 1 | **Shift-F1** | needs Holy Shock first. 1.5 s cast, on a friend, lasts 30 s: your next Holy Shock on that friend has no cooldown and heals that friend and their party. Cooldown 6 s. One Vigil per party. Ranks 2-3 at the trainer (50, 60) |

### 2b. Protection (band 2)

| Row | Needs | Earliest | Talent (spell id) | Ranks | Key? | What it does |
|---|---|---|---|---|---|---|
| 1 | 0 | 10 | Divine Intellect (20257) | 5 | passive | +2/4/6/8/10% Intellect |
| 1 | 0 | 10 | Redoubt (20127) | 5 | passive | melee hits on you have a 10% chance to give +6/12/18/24/30% block chance for 10 s or 5 blocks |
| 2 | 5 | 15 | Precision (20189) | 3 | passive | +1/2/3% chance to hit |
| 2 | 5 | 15 | Guardian's Favor (20174) | 2 | passive | Blessing of Protection cooldown 1/2 min shorter; Blessing of Freedom lasts 3/6 s longer |
| 2 | 5 | 15 | Sacred Duty (1224697) | 2 | passive | Divine Shield, Divine Protection and Templar's Bulwark cooldown 30/60 s shorter; Forbearance 5/10 s shorter |
| 3 | 10 | 20 | **Templar's Bulwark** (1311015) | 1 | **X** | a shield that soaks up damage equal to 100% of your max health, for 8 s. Cooldown 5 min, no global cooldown. Gives Forbearance (1 min) and cannot be cast with Forbearance |
| 3 | 10 | 20 | Improved Hammer of Justice (20487) | 3 | passive | Hammer of Justice cooldown 5/10/15 s shorter (base 60 s) |
| 3 | 10 | 20 | Shield Specialization (20150) | 2 | passive | needs Redoubt first. Your shield blocks 15/30% more; a block has a 50/100% chance to give back 4% of your max mana (at most once per 3 s) |
| 3 | 10 | 20 | Toughness (20143) | 5 | passive | +2/4/6/8/10% armor from items |
| 4 | 15 | 25 | **Swift Judgement** (1310994) | 1 | **F1** | needs Templar's Bulwark first. A second Judgement with its own cooldown (60 s, no global cooldown). Does not use up the seal |
| 4 | 15 | 25 | Improved Righteous Fury (20468) | 3 | passive | with Righteous Fury on: 3/6/9% less damage taken |
| 4 | 15 | 25 | Anticipation (20096) | 5 | passive | +4/8/12/16/20 Defense |
| 5 | 20 | 30 | Stoicism (1328546) | 2 | passive | Stun and Charm on you 10/20% shorter |
| 5 | 20 | 30 | **Holy Shield** (20925) | 1 | **Shift-4** | +30% block chance for 10 s, and Holy damage to the attacker on each block; 4 charges. Cooldown 10 s. Needs a shield (SpellEquippedItems: class 4, mask 64). Ranks 2-4 at the trainer (40, 50, 60) |
| 5 | 20 | 30 | Reckoning (20177) | 5 | passive | 8/16/24/32/40% chance after a block, and 20/40/60/80/100% after a crit on you, to get an extra attack; stores up to 4 |
| 6 | 25 | 35 | Iron Creed (1311034) | 3 | passive | Holy Strike makes 10/20/30% more threat; with Righteous Fury on, Holy Strike also gives 2/4/6% less damage taken for 6 s |
| 7 | 30 | 40 | Shieldsworn (1328544) | 1 | passive | needs Holy Shield first. Holy Strike cooldown 4 s shorter (10 → 6 s). Holy Strike hits with your shield: it triggers Holy Shield and Shield Specialization without using a charge, and lets you block spells for 6 s |

### 2c. Retribution (band 3)

| Row | Needs | Earliest | Talent (spell id) | Ranks | Key? | What it does |
|---|---|---|---|---|---|---|
| 1 | 0 | 10 | Deflection (20060) | 5 | passive | +1/2/3/4/5% parry |
| 1 | 0 | 10 | Benediction (20101) | 5 | passive | instant spells and abilities cost 2/4/6/8/10% less mana |
| 2 | 5 | 15 | Improved Judgement (25956) | 2 | passive | Judgement cooldown 1/2 s shorter (10 → 8 s) |
| 2 | 5 | 15 | Conviction (20117) | 3 | passive | +2/4/6% crit with all spells and attacks |
| 2 | 5 | 15 | Sanctified Judgement (1311074) | 3 | passive | Judgement has a 33/66/100% chance to give back 20/40/60% of the mana of the judged seal |
| 3 | 10 | 20 | Vindication (9452) | 3 | passive | your melee hits can lower the enemy's attack power (amount not worked out) |
| 3 | 10 | 20 | Unyielding Faith (9453) | 2 | passive | Fear and Disorient on you 15/30% shorter |
| 3 | 10 | 20 | **Seal of Command** (20375) | 1 | **3** | a seal, 30 s: hits have a chance to do an extra Holy hit of 70% weapon damage. Its Judgement does double damage on a stunned or incapacitated enemy. Ranks 2-5 at the trainer (30, 40, 50, 60) |
| 3 | 10 | 20 | Pursuit of Justice (26022) | 2 | passive | +8/15% movement speed, also mounted (does not stack with other speed effects) |
| 4 | 15 | 25 | Eye for an Eye (9799) | 2 | passive | a crit on you does 5/10% of its damage to the attacker too |
| 4 | 15 | 25 | Sacred Arbiter (1311087) | 1 | passive | Holy Strike does 20% more damage and refreshes all Judgement effects on the enemy |
| 4 | 15 | 25 | Two-Handed Weapon Specialization (20111) | 3 | passive | with a two-handed weapon: +2/4/6% Physical and Holy damage, 7/14/20% less threat |
| 5 | 20 | 30 | Turn Evil (1328370) | 2 | passive | Turn Undead casts 0.5/1.0 s faster, cooldown 5/10 s shorter, and it works on Demons too |
| 5 | 20 | 30 | **Repentance** (20066) | 1 | **V** | takes one Humanoid out for up to 6 s; any damage wakes it. Cooldown 1 min |
| 5 | 20 | 30 | Vengeance (20049) | 3 | passive | needs Seal of Command first. After a crit: +1/2/3% Physical and Holy damage for 30 s, stacks 5 times |
| 6 | 25 | 35 | Champion of the Light (1311084) | 5 | passive | spell damage +12/24/36/48/60% of your Intellect; Hammer of Wrath casts 0.2/0.4/0.6/0.8/1.0 s faster (base 1.0 s, so instant at 5/5) |
| 7 | 30 | 40 | Unsealed Wrath (1310735) | 1 | passive | needs Repentance first. Your melee hits store a copy of your active seal (15 s, up to 3). A hit with a DIFFERENT seal uses all copies: each one gets the stored seal's normal chance to work |

- GEMETEN: every talent with a button has a key in `ForeverBlock_Paladin.lua` (Divine Favor, Oath of Light, Holy Shock,
  Light's Vigil, Templar's Bulwark, Swift Judgement, Holy Shield, Seal of Command, Repentance). Shieldsworn, Sacred
  Arbiter and Unsealed Wrath are passive: no key.
- GEMETEN: the talent levels in `ForeverMacros.lua` agree: holyshock 30, lightsvigil 40, divinefavor 20, holyshield 30,
  sealcommand 20. `ForeverDirection.lua` (Holy Shield, shield, 30) agrees too.

## 3. The buttons every Paladin has (trainer and quests)

Levels: GEMETEN in `ForeverTrainerData.lua` PALADIN (What's Training data). Cross-checked in DB2 SpellLevels for 19 of
them, all agree: Seal of Righteousness, Judgement, Holy Strike, Divine Protection, Seal of the Crusader, Hammer of
Justice, Lay on Hands, Blessing of Protection, Righteous Fury, Seal of Fury, Redemption, Blessing of Freedom,
Consecration, Exorcism, Divine Intervention, Divine Shield, Hammer of Wrath, Blessing of Sacrifice, Holy Wrath. The
others were not cross-checked in DB2; WoW Forever DB's trainer lists (GIDS) give the same levels.
Keys: GEMETEN in `ForeverBlock_Paladin.lua`. "block D" = the player's own Alt keys.

| Level | Spell | Key | Measured facts (DB2) |
|---|---|---|---|
| 1 | Seal of Righteousness | 3 (until Seal of Command is known) | seal, 30 s; a slower weapon does more Holy damage per hit |
| 1 | Holy Light | C | 2.5 s cast. Human/Dwarf start with it; Undead get it from a level 2 quest (class quests) |
| 1 | Devotion Aura | Ctrl-1 | armor for the party |
| 4 | Judgement | 2 | cooldown 10 s, no global cooldown; "Does not consume the Seal" (spell 20271) |
| 4 | Blessing of Might | Shift-Z | 60 min |
| 6 | Holy Strike | 1 | instant weapon hit plus Holy damage; cooldown 10 s; any melee weapon |
| 6 | Divine Protection | Z | 6 s immune, cannot attack; cooldown 5 min; Forbearance |
| 6 | Seal of the Crusader | block D | more attack power and 40% faster attacks, but less damage per hit; its Judgement makes the enemy take more Holy damage |
| 8 | Hammer of Justice | E | stun 3 s (rank 1); cooldown 60 s |
| 8 | Purify | Shift-C | removes a disease and a poison effect (how many: not read) |
| 10 | Lay on Hands | Q | heals for your max health, drains all your mana; cooldown 20 min |
| 10 | Blessing of Protection | Shift-F | 6 s (rank 1) immune to physical attacks, the friend cannot attack; cooldown 5 min; Forbearance |
| 10 | Righteous Fury | block D | 30 min: +33% all threat, another +90% threat from Holy attacks |
| 10 | Seal of Fury | F | seal, 30 s: extra Holy damage per hit; with a shield each hit also gives an absorb shield of 50% of that damage. Its Judgement does damage and TAUNTS for 3 s (spell 20232, DurationIndex 27) |
| 12 | Redemption | F3 (out of combat) | class quest (Human, Dwarf and Undead each have a chain); 10 s cast |
| 14 | Blessing of Wisdom | Shift-V | mana every 5 s, 60 min |
| 16 | Retribution Aura | Ctrl-2 | Holy damage to whoever hits a party member |
| 18 | Blessing of Freedom | R | 10 s, cooldown 20 s |
| 20 | Consecration | Shift-1 | trainer spell (not a talent). 8 s on the ground, cooldown 8 s; the first 4 enemies that enter take extra damage |
| 20 | Exorcism | 5 | Undead and Demons only; cooldown 15 s |
| 20 | Flash of Light | F2 | 1.5 s cast |
| 20 | Blessing of Kings | Shift-X | trainer spell (not a talent). +10% all stats, 60 min |
| 22 | Concentration Aura | Ctrl-3 | 35% chance that being hit does not delay a cast, for the party |
| 22 | Seal of Justice | block D | hits can stun; its Judgement stops the enemy from fleeing |
| 24 | Turn Undead | Shift-Q | Undead only (Demons too with Turn Evil); 1.5 s cast; cooldown 30 s |
| 30 | Divine Intervention | F3 (in combat) | ⚠️ "The paladin sacrifices himself" (spell 19752): YOU DIE; the friend is safe for 3 min but cannot act. Cooldown 1 hour |
| 30 | Seal of Light | block D | hits can heal you; its Judgement lets attackers of that enemy get healed |
| 34 | Divine Shield | Z | 10 s immune, you deal 50% less damage; cooldown 5 min; Forbearance |
| 38 | Seal of Wisdom | block D | hits can give you mana; its Judgement lets attackers of that enemy get mana |
| 40 | Plate Mail | - | you can wear plate |
| 42 | Cleanse | Shift-C | removes a poison, a disease and a magic effect (how many: not read) |
| 44 | Hammer of Wrath | 4 | only at 20% health or less; 1.0 s cast; cooldown 6 s |
| 46 | Blessing of Sacrifice | block D | |
| 50 | Holy Wrath | block D | 2 s cast, Undead and Demons around you; cooldown 60 s |
| 52 / 54 / 60 | Greater Blessing of Might / Wisdom / Kings | Shift-Z / Shift-V / Shift-X in a group | |

- GEMETEN: Forbearance (25771) lasts 60 s; its text names Divine Shield, Divine Protection, Blessing of Protection and
  Templar's Bulwark. Lay on Hands is not in it.
- Class quests (GEMETEN in `ForeverClassQuests.lua` CHAINS.PALADIN): Redemption 12 (all three races); a two-handed
  weapon at 20 (Alliance: Verigan's Fist, a mace; Undead: Wolfsbane, a sword; both chains need dungeons); Warhorse 40
  (Alliance and Undead); Alliance only: item quests at 50 and the Charger chain at 60. Undead only: Holy Light at 2, and
  from 8 the Bandarion Keep quests (a mace and a shield).
- Two spells with an open question, see 6c: **Voice of Truth** (SpellLevels 20; 6 s immune to Silence and Interrupt,
  cooldown 3 min; MH: block D) and **Hammer of the Righteous** (SpellLevels 40; hits up to 4 enemies, cooldown 6 s,
  needs a ONE-HANDED weapon; MH: Shift-2).

## 4. Per role: a simple order, with the source of each step

Keys as MH has them (`ForeverBlock_Paladin.lua`). Nothing here is a new key.

### 4a. Holy = healer (band 1)

Start: Holy Light from level 1. The tree's own buttons come at 20 (Divine Favor), 25 (Oath of Light), 30 (Holy
Shock) and 40 (Light's Vigil), all at the earliest (GEMETEN, 2a).
GIDS (WoW Forever DB): Holy is the slowest of the three to level alone; level as Retribution and heal in dungeons, or
play Holy with a partner. No guide disagrees.

In a group:
1. Before the pull: a blessing on everyone; Blessing of Wisdom (**Shift-V**, from 14) on yourself; from 20 Blessing of
   Kings (**Shift-X**) when you do not know what to give. — GIDS Icy Veins Holy (4 Nov): "if you are ever unsure …
   default to this"; WoW Forever DB: Wisdom on yourself from 14.
2. Aura: Devotion Aura (**Ctrl-1**), or Concentration Aura (**Ctrl-3**, from 22) when casters get hit a lot. — GIDS
   Icy Veins Holy (4 Nov).
3. Oath of Light (**Shift-R**, from 25) on the tank; it lasts 5 minutes. — GIDS Icy Veins (4 Nov) "Maintain Oath of
   Light on your Tank at all times"; ConquestCapped Holy (13 Nov). Duration GEMETEN.
   ⚠️ 26 nov: Forever-hotfix 25 nov zet de duur op 60 minuten. GEMETEN: Wowhead Forever-tooltip "for 1 hour"; DB2
   71139 SpellMisc DurationIndex 5 = nog 300000 ms (de hotfix zit niet in de DB2-bestanden). Spelerstekst nu "1 hour".
4. Flash of Light (**F2**, from 20) is your normal heal. Before 20: Holy Light (**C**). — GIDS Icy Veins (4 Nov),
   ConquestCapped (13 Nov).
5. Holy Light (**C**) for a big hit. From 25 (Infusion of Light): best right after a crit, then it casts 1 s faster.
   — GIDS Icy Veins, ConquestCapped; numbers GEMETEN.
6. Holy Shock (**F4**, from 30) when there is no time to cast, or while you move. — GIDS Icy Veins (4 Nov).
7. The whole party hurt, from 40: Light's Vigil (**Shift-F1**) on one player, then Holy Shock (**F4**) on that same
   player. — GEMETEN (spell text), GIDS Icy Veins, ConquestCapped.
8. Divine Favor (**Shift-3**, from 20) before a heal that must be big. — GIDS ConquestCapped (13 Nov),
   wowforeverforge (14 Nov).
9. Bad effect on a friend: Purify / Cleanse (**Shift-C**). — GEMETEN (trainer 8 / 42).
10. Emergency: Lay on Hands (**Q**). It uses all your mana. — GEMETEN; GIDS Icy Veins.
Nothing to heal: Seal of Righteousness (**3**), Judgement (**2**) and Holy Strike (**1**) up close. — GIDS Icy Veins
Holy (4 Nov), "DPSing as a Holy Paladin".
Alone: play the Retribution order (4c) with the seal on **3**; from 30 Holy Shock (**F4**) on the enemy is your one
strong damage button. — GIDS WoW Forever DB Holy leveling.

Seal for a healer in a group: Seal of Light (block D, from 30) or Seal of Wisdom (block D, from 38) and judge it once.
— GIDS Icy Veins (4 Nov): "Use Seal of Light if no other Paladin is, otherwise use Seal of Wisdom"; ConquestCapped
(13 Nov): Seal of Wisdom. This is group fine-tuning; a beginner can skip it.

Talent order (GIDS WoW Forever DB Holy leveling; every step checked against the row rules of 2, AFGELEID valid):
Spiritual Focus 5 (10-14), Reverence 2 (15-16), Healing Light 3 (17-19), Illumination 5 (20-24), Divine Favor (25),
Infusion of Light 2 (26-27), Oath of Light (28), Divine Precision 1 (29), Holy Shock (30), … Light's Vigil (40).
foreverwow.com (7 Nov) takes Oath of Light at 25 instead; both are valid.

### 4b. Protection = tank (band 2)

Start: level 10 (Righteous Fury and Seal of Fury at the trainer; first talent point). The tree's buttons: Templar's
Bulwark 20, Swift Judgement 25, Holy Shield 30; Shieldsworn (passive) 40, all at the earliest (GEMETEN, 2b).
You carry a one-handed weapon and a shield (GEMETEN: Holy Shield needs a shield; Seal of Fury's absorb needs a shield).

1. Before the pull: Righteous Fury on (block D; lasts 30 minutes), Seal of Fury (**F**), a blessing, an aura. —
   GEMETEN (spell data); GIDS Wowhead Prot leveling (6 Nov), ConquestCapped Prot (13 Nov).
2. From 30: Holy Shield (**Shift-4**) just before the enemies reach you; press it again every time it is ready. — GIDS
   ConquestCapped (13 Nov) opener; Wowhead leveling (6 Nov) "apply Holy Shield before engaging".
3. Judgement (**2**) on the first enemy. With Seal of Fury on, Judgement is your taunt (3 s). — GEMETEN; GIDS all.
4. Two or more enemies, from 20: Consecration (**Shift-1**) under them. Only the first 4 take the extra damage. —
   GEMETEN (4); GIDS Wowhead overview (14 Nov), ConquestCapped.
5. Holy Strike (**1**) every time it is ready. — GIDS all three Prot guides.
6. An enemy runs to someone else: Judgement (**2**). Not ready? From 25: Swift Judgement (**F1**), a second Judgement
   with its own 1-minute cooldown. — GEMETEN; GIDS ConquestCapped, WoW Forever DB ("spend Swift Judgement on a missed
   or needed second taunt").
7. An enemy casts a spell: Hammer of Justice (**E**). The Paladin has no interrupt. — MH code comment in
   `ForeverMacros.lua` (11 Nov); GIDS WoW Forever DB, ConquestCapped ("No interrupt").
8. Exorcism (**5**, from 20) on Undead and Demons; Hammer of Wrath (**4**, from 44). — GIDS Wowhead leveling (6 Nov).
9. Big damage coming, from 20: Templar's Bulwark (**X**). Last resort: Lay on Hands (**Q**). — GEMETEN; GIDS
   ConquestCapped cooldown table.
Low on mana: drop Consecration first. — GIDS Wowhead leveling (6 Nov), ConquestCapped (13 Nov).
From 40 (Shieldsworn): Holy Shield first, then Holy Strike. — GIDS Wowhead leveling (6 Nov).
Not tanking (alone, or someone else tanks): use Seal of Righteousness (**3**), not Seal of Fury. — GIDS WoW Forever
DB Prot leveling; ConquestCapped (13 Nov) mistakes list.

Talent order (GIDS WoW Forever DB Prot leveling, "launch standard build"; AFGELEID valid against 2): Redoubt 5
(10-14), Precision 3 (15-17), Sacred Duty 2 (18-19), Templar's Bulwark (20), Shield Specialization 2 (21-22),
Toughness 2 (23-24), Swift Judgement (25), Improved Righteous Fury 3 (26-28), Anticipation 1 (29), Holy Shield (30),
… Shieldsworn (40). Other guides start in Retribution: see 6a.

### 4c. Retribution = damage up close (band 3)

Start: level 1 (Seal of Righteousness); Judgement 4, Holy Strike 6. The tree's buttons: Seal of Command 20,
Repentance 30; Sacred Arbiter (passive) 25, Unsealed Wrath (passive) 40, at the earliest (GEMETEN, 2c).
GIDS (WoW Forever DB, wowforeveraddon 11 Nov, Icy Veins via khorium 8 Nov): the fastest tree to level alone, with one
slow two-handed weapon. The class quest at 20 gives one (class quests).

1. Before the fight: Blessing of Might (**Shift-Z**) until 20, then Blessing of Kings (**Shift-X**). — GIDS Icy Veins
   leveling (via khorium, 8 Nov).
2. Aura: Devotion Aura (**Ctrl-1**); Retribution Aura (**Ctrl-2**, from 16) against several enemies. — GIDS Icy Veins
   (via khorium).
3. Seal on (**3**): Seal of Righteousness until 20, then Seal of Command (key 3 switches by itself). — GEMETEN (key
   list); GIDS all.
4. Judgement (**2**) every time it is ready. It does not use up the seal. — GEMETEN; GIDS all.
5. Holy Strike (**1**) every time it is ready (10 s). — GEMETEN cooldown; GIDS all.
6. Undead or Demon, from 20: Exorcism (**5**). — GEMETEN; GIDS all.
7. Two or more enemies, from 20: Consecration (**Shift-1**). Not on one enemy: it costs too much mana. — GIDS Icy
   Veins (via khorium): "almost twice as much as Judgement and Holy Strike together".
8. From 44: Hammer of Wrath (**4**) when the enemy is at 20% health or less. — GEMETEN; GIDS all.
9. Strong enemy: Hammer of Justice (**E**), then Judgement (**2**). With Seal of Command, Judgement does double damage
   on a stunned enemy. — GEMETEN (spell 20375 text); GIDS WoW Forever DB, foreverwow.com (7 Nov).
10. A second Humanoid, from 30: Repentance (**V**), and do not hit it. — GEMETEN; GIDS wowforeveraddon (11 Nov).
11. Put the seal back on when it runs out (30 s). Low on health: Holy Light (**C**) between fights. — GEMETEN
    duration; GIDS WoW Forever DB ("Holy Light between pulls instead of eating").
From 40, Unsealed Wrath: optional. Hit a few times with one seal, then switch to another seal for one hit. — GIDS
ConquestCapped Ret (13 Nov); foreverwow.com (7 Nov): "only twist Seals when you have the Mana for it". ⚠️ MH has only
one damage seal on the block for a Ret Paladin, see 7.1.

Talent order (GIDS wowforeveraddon, 11 Nov; AFGELEID valid against 2): Benediction 5 (10-14), Conviction 3 and
Improved Judgement 2 (15-19), Seal of Command (20), Sanctified Judgement 3 and Pursuit of Justice 1 (21-24), Sacred
Arbiter (25), Two-Handed Weapon Specialization 3 and Pursuit of Justice 2/2 (26-29), Repentance (30), Vengeance 3
(31-33), Vindication 1 (34), Champion of the Light 5 (35-39), Unsealed Wrath (40).

## 5. Per 10 levels: what is new that counts for the role

Trainer and quests: GEMETEN (`ForeverTrainerData.lua`, `ForeverClassQuests.lua`). Talents: earliest level, GEMETEN (2).

### 5a. Holy (healer)
- 10: you already have Holy Light (**C**), Devotion Aura (**Ctrl-1**), Blessing of Might (**Shift-Z**), Divine
  Protection (**Z**), Hammer of Justice (**E**), Purify (**Shift-C**). New at 10: Lay on Hands (**Q**), Blessing of
  Protection (**Shift-F**). First talent: Spiritual Focus (GIDS). Then Redemption (**F3**, quest) at 12, Blessing of
  Wisdom (**Shift-V**) at 14, Reverence and Healing Light (talents, passive) from 15, Blessing of Freedom (**R**) at 18.
- 20: Flash of Light (**F2**), Blessing of Kings (**Shift-X**). Divine Favor (**Shift-3**, a talent). Illumination
  (a talent, passive; needs Reverence). Then Concentration Aura (**Ctrl-3**) at 22, Oath of Light (**Shift-R**, a
  talent) and Infusion of Light (passive) at 25.
- 30: Holy Shock (**F4**, a talent). Divine Intervention (**F3** in a fight: you die). Seal of Light (block D). Then
  Divine Shield (**Z**) at 34, Holy Power (a talent, passive) at 35, Seal of Wisdom (block D) at 38.
- 40: Light's Vigil (**Shift-F1**, a talent; needs Holy Shock). Holy Shock rank 2. Plate Mail. Then Cleanse
  (**Shift-C**) at 42, Blessing of Sacrifice (block D) at 46, Holy Shock rank 3 at 48.
- 50: Light's Vigil rank 2, Lay on Hands rank 3. Then Greater Blessing of Might at 52 and of Wisdom at 54, Holy Shock
  rank 4 at 56.
- 60: Greater Blessing of Kings, Light's Vigil rank 3; nothing new for this role.

### 5b. Protection (tank)
- 10: Righteous Fury (block D) and Seal of Fury (**F**). You already have Judgement (**2**), Holy Strike (**1**),
  Hammer of Justice (**E**), Devotion Aura (**Ctrl-1**), Divine Protection (**Z**). Also Lay on Hands (**Q**) and
  Blessing of Protection (**Shift-F**). First talent: Redoubt (GIDS). Then Precision, Guardian's Favor or Sacred Duty
  (talents, passive) from 15, Retribution Aura (**Ctrl-2**) at 16.
- 20: Templar's Bulwark (**X**, a talent). Consecration (**Shift-1**), Blessing of Kings (**Shift-X**), Exorcism
  (**5**). Shield Specialization (a talent, passive; needs Redoubt). Then Swift Judgement (**F1**, a talent; needs
  Templar's Bulwark) and Improved Righteous Fury (passive) at 25.
- 30: Holy Shield (**Shift-4**, a talent; needs a shield). Reckoning (a talent, passive). Then Divine Shield (**Z**)
  at 34, Iron Creed (a talent, passive) at 35.
- 40: Shieldsworn (a talent, passive; needs Holy Shield): Holy Strike every 6 s, and it works with Holy Shield. Plate
  Mail. Holy Shield rank 2. Then Hammer of Wrath (**4**) at 44, Blessing of Sacrifice (block D) at 46.
- 50: Holy Shield rank 3, Holy Wrath (block D); stronger ranks of Seal of Fury and Consecration.
- 60: Holy Shield rank 4; stronger ranks; nothing new for this role.

### 5c. Retribution (damage)
- 10: you already have Seal of Righteousness (**3**), Judgement (**2**), Holy Strike (**1**), Blessing of Might
  (**Shift-Z**), Hammer of Justice (**E**). New at 10: Lay on Hands (**Q**). First talent: Benediction (most guides)
  or Deflection (Icy Veins). Then Improved Judgement, Conviction or Sanctified Judgement (talents, passive) from 15,
  Retribution Aura (**Ctrl-2**) at 16.
- 20: Seal of Command (key **3**, a talent). Consecration (**Shift-1**), Exorcism (**5**), Blessing of Kings
  (**Shift-X**), Flash of Light (**F2**). Pursuit of Justice (a talent, passive: you move 15% faster at 2/2). The
  class quest for a two-handed weapon. Then Sacred Arbiter and Two-Handed Weapon Specialization (talents, passive)
  at 25.
- 30: Repentance (**V**, a talent). Vengeance (a talent, passive; needs Seal of Command). Seal of Command rank 2. Then
  Divine Shield (**Z**) at 34, Champion of the Light (a talent, passive) at 35.
- 40: Unsealed Wrath (a talent, passive; needs Repentance). Plate Mail. The Warhorse quest. Then Hammer of Wrath
  (**4**) at 44.
- 50: Seal of Command rank 4, Holy Wrath (block D), Hammer of Wrath rank 2 at 52; nothing new for this role.
- 60: Seal of Command rank 5 and stronger ranks; the Charger quest (Alliance); nothing new for this role.

### 5d. Seals, Judgement, Blessings, Auras: what a beginner picks

| | Holy (healer) | Protection (tank) | Retribution (damage) |
|---|---|---|---|
| Seal | Seal of Righteousness (**3**) when you hit; in a group from 30/38 Seal of Light or Wisdom (block D) — GIDS Icy Veins 4 Nov | Seal of Fury (**F**) while you tank; Seal of Righteousness (**3**) when you do not — GEMETEN taunt; GIDS ConquestCapped, WoW Forever DB | Seal of Righteousness (**3**) until 20, then Seal of Command (**3**) with a slow two-hander — GIDS all |
| Judgement (**2**) | only when there is nothing to heal | every time it is ready; it is your taunt | every time it is ready |
| Blessing | Wisdom (**Shift-V**) on yourself; Kings (**Shift-X**) for others from 20 | Kings from 20 — GIDS Icy Veins default (AFGELEID for the tank) | Might (**Shift-Z**) until 20, then Kings — GIDS Icy Veins via khorium |
| Aura | Devotion (**Ctrl-1**) or Concentration (**Ctrl-3**) | guides disagree: Retribution (**Ctrl-2**) or Devotion (**Ctrl-1**), see 6a | Devotion (**Ctrl-1**); Retribution (**Ctrl-2**) against several enemies |

- GEMETEN: a Judgement never uses up the seal in Forever (spell 20271: "Does not consume the Seal"); all seals last
  30 s (DurationIndex 9); Might, Wisdom and Kings last 60 min (DurationIndex 42).
- GEMETEN (spell texts): one seal at a time; one blessing per Paladin on a player; one aura per Paladin on a player.

## 6. Beginner mistakes per role

### Holy
1. Holy Light for every small hit. Flash of Light (**F2**, from 20) is the cheap normal heal. — GIDS wowforeverforge
   (14 Nov) "Five common mistakes"; Icy Veins (4 Nov).
2. Light's Vigil when only one or two players are hurt. It is very expensive. — GIDS ConquestCapped Holy (13 Nov);
   foreversixty.gg ("1,340 mana").
3. Light's Vigil on one player and Holy Shock on another. The party heal only comes from Holy Shock on the SAME
   player. — GEMETEN (spell 1310911 text).
4. Forgetting Oath of Light on the tank, or expecting it on two players. One Oath at a time, 5 minutes (1 hour since the 25 Nov hotfix, see step 3). — GEMETEN;
   GIDS Icy Veins (4 Nov).
5. Lay on Hands while you still need mana. It takes all the mana you have left. — GEMETEN (spell 633 text).
6. Blessing of Protection on the tank. The tank cannot attack while it lasts. — GEMETEN (spell 1022 text); GIDS
   ConquestCapped Prot (13 Nov).
7. Divine Intervention (**F3** in a fight) by accident: you die. — GEMETEN (spell 19752 text); GIDS Warcraft Tavern.

### Protection
1. Forgetting Righteous Fury. Without it you make far less threat; it lasts 30 minutes. — GEMETEN; GIDS
   ConquestCapped (13 Nov): "check it before every pull".
2. Seal of Fury on when you are not the tank. Every Judgement taunts. — GEMETEN; GIDS ConquestCapped (13 Nov) mistakes
   list; WoW Forever DB.
3. No shield. Holy Shield does not work without one, and Seal of Fury gives no absorb. — GEMETEN
   (SpellEquippedItems; spell 1311649 text).
4. Consecration every time it is ready. Your mana runs out. — GIDS Wowhead Prot leveling (6 Nov); ConquestCapped.
5. Pulling more than 4 enemies. Consecration's extra damage is for the first 4, and you have no taunt for a group. —
   GEMETEN (4); GIDS ConquestCapped (13 Nov).
6. Divine Protection (**Z**) while tanking: you cannot attack for 6 s, so enemies leave you. And Templar's Bulwark,
   Divine Shield, Divine Protection and Blessing of Protection all give Forbearance: one of them per minute. — GEMETEN
   (spells 498, 25771); GIDS ConquestCapped cooldown table.
7. Looking for an interrupt. There is none; Hammer of Justice (**E**) is your stop, once a minute. — MH code comment;
   GIDS WoW Forever DB.

### Retribution
1. Putting the seal on again after every Judgement (a Classic habit). Judgement does not use it up; a seal lasts
   30 s. — GEMETEN; GIDS ConquestCapped Ret (13 Nov), wowforeveraddon (11 Nov).
2. Seal of Command with a fast weapon. It wants a slow two-hander. — GIDS WoW Forever DB, Icy Veins via khorium.
3. Consecration on one enemy. — GIDS Icy Veins via khorium (8 Nov); systematic/Icy ("only on two or more mobs").
4. Hitting the enemy you put in Repentance. Any damage wakes it; it only works on Humanoids. — GEMETEN (spell 20066).
5. Judgement with Seal of Fury on in a group: it taunts the enemy onto you. — GEMETEN; GIDS ConquestCapped Ret
   (13 Nov): "Never judge Seal of Fury on a boss".
6. Hammer of Wrath early (only at 20% or less) and Exorcism on a normal enemy (Undead and Demons only). — GEMETEN;
   already in MH's class text.

## 6a. Guides disagree

1. **Which tree levels best.** Retribution is the fastest alone: WoW Forever DB, wowforeveraddon (11 Nov), Icy Veins
   via khorium (8 Nov). Wowhead Prot leveling (6 Nov) calls Protection "a very viable, if not the best, leveling
   spec"; WoW Forever DB calls Protection leveling "mostly untested theory … safe and slow".
2. **First Retribution talent.** Benediction (wowforeveraddon, WoW Forever DB, foreverwow.com) or Deflection (Icy
   Veins via khorium).
3. **Seal of Command at 20 or 22.** Most take it at 20; Icy Veins takes Pursuit of Justice at 20-21 and the seal at 22.
4. **Protection talent order.** Protection first (Holy Shield at 30, Shieldsworn at 40: WoW Forever DB) or
   Retribution first for Benediction and Pursuit of Justice (Wowhead 6 Nov, Icy Veins); ConquestCapped (13 Nov) says
   that way Holy Shield comes at 42 and Shieldsworn at 52.
5. **The tank's aura.** Retribution Aura (Wowhead 6 Nov, ConquestCapped 13 Nov) or Devotion Aura (WoW Forever DB:
   "the safe default").
6. **Vengeance stacks.** 3 (WoW Forever DB; foreverwow.com talent line) or 5 (Wowhead 16 Nov, ConquestCapped, khorium).
   GEMETEN in 70938: 5 (SpellAuraOptions 20050 CumulativeAura 5).
7. **Seal of Fury's taunt.** 4 s (Wowhead 14 Nov table; Icy Veins overview) or 3 s (ConquestCapped, WoW Forever DB,
   wowforeveraddon: "since a 30 Oct hotfix"). GEMETEN in 70938: 3 s.
8. **Redoubt.** "4-20%" (WoW Forever DB), 30% (Wowhead 14 Nov). GEMETEN in 70938: 6/12/18/24/30%.
9. **Holy Shield block.** 20% (Wowhead 14 Nov) or 30% (ConquestCapped, others). GEMETEN in 70938: 30% on all four
   ranks, 4 charges. A server hotfix cannot be seen in DB2.
10. **Shield Specialization mana.** 6% (Wowhead 14 Nov) or 4% (ConquestCapped). GEMETEN in 70938: 4% (spell 1310925).
11. **Seal duration.** 40 s (ConquestCapped abilities page, 7 Nov) or 30 s (wowforeveraddon). GEMETEN: 30 s.
12. **Hammer of the Righteous and Voice of Truth from the trainer.** Yes: ConquestCapped (7 Nov), wowhandbook.com,
    allthings.how (8 Nov), foreverwow.com (7 Nov), Wowhead Ret overview (16 Nov, Voice of Truth). Not confirmed: WoW
    Forever DB ("the Season of Discovery record … isn't confirmed to be trainable; don't build around it"), and its
    trainer lists and MH's own `ForeverTrainerData.lua` have neither. See 6c.
13. **Sense Undead.** Gone (ConquestCapped 7 Nov), a level 20 spell (allthings.how 8 Nov), or from the Verigan's Fist
    quest 1652 (comment in `ForeverClassQuests.lua`, source Wowhead).
14. **Lower ranks to save mana (healer).** Not needed (ConquestCapped 13 Nov) or yes, Flash of Light rank 5
    (foreversixty.gg). Not beginner material.
15. **Seal swapping with Unsealed Wrath.** Worth about 10% (ConquestCapped 13 Nov, from a simulation of 12 Nov) or
    only with mana to spare (foreverwow.com 7 Nov).
16. **Stats for Retribution.** Strength or Intellect first: already settled in `ForeverMainStats.lua` (equal).

## 6b. Do not mention (not in build 70938)

Talents that have NO node in tree 1100 (GEMETEN: all 51 nodes resolved; none is one of these):
- **One-Handed Weapon Specialization** — TraitDefinition 135154 still exists but is on no node (GEMETEN:
  TraitNodeXTraitNodeEntry has no row for entry 130353; same run found entry 130014). Still named by Warcraft Tavern,
  warcraftforever.wiki and the Icy Veins beta build.
- **Improved Seal of Fury** — a SpellName row exists (1314103), no node. Named by Warcraft Tavern and beta guides;
  lfcarry: removed 2 Nov.
- **Improved Concentration Aura** (definition 134821), **Improved Holy Strike** (134823), **Sanctified Light**
  (134817), **Guarded by the Light** (135160), **Crusade** (142633): definitions without a node (GEMETEN, same
  check). Three more orphan definitions (135156, 135225, 142632) point at spells without a name in this build
  (407669, 426158, 1311085).
- **Twist of Light**, **Instrument of Law** (beta names; now Unsealed Wrath and Champion of the Light) — GEMETEN: no
  SpellName row; the same search found Unsealed Wrath.
- Classic talents with no node: Improved Devotion Aura, Improved Retribution Aura, Improved Blessing of Might,
  Improved Blessing of Wisdom, Improved Lay on Hands, Improved Seal of Righteousness, Improved Seal of the Crusader,
  Lasting Judgement, Sanctity Aura, Blessing of Sanctuary.
- **Consecration and Blessing of Kings as talents**: both are trainer spells at 20 (GEMETEN trainer data; no node).
- **Blessing of Salvation**, **Blessing of Sanctuary**: no SpellName row (GEMETEN). **Blessing of Light**, **Sanctity
  Aura**: a name row exists, but no node and not in the trainer data. GIDS: Wowhead (16 Nov) lists Sanctity Aura and
  Blessing of Salvation as removed; ConquestCapped (7 Nov) says Blessing of Salvation and Blessing of Light are gone.
- Beta values still on some pages: Swift Judgement "finishes the cooldown of Judgement" (Icy Veins overview; 70938: a
  separate Judgement, 60 s), Sacred Arbiter +10% (70938: +20%), Iron Creed 5 ranks (70938: 3), Holy Shield needing
  Templar's Bulwark (70938: no edge), "Divine Intellect is a Holy talent".
- **Crusader Strike**, Avenger's Shield, Divine Storm, Hand of Reckoning, Seal of Martyrdom, Beacon of Light: name
  rows exist (left over from another game version), no node, not in the trainer data. Hammer of the Righteous's own
  tooltip still says "Cooldown shared with Crusader Strike": do not repeat that.
- "Seal twisting" as something every Paladin does: only with the Unsealed Wrath talent.

## 6c. Not measured

- **How a Paladin gets Hammer of the Righteous (407632) and Voice of Truth (1310897).** GEMETEN: both are in
  SkillLineAbility with new rows (59214, skill 267; 59228, skill 594) next to Seal of Fury and Swift Judgement, with
  SpellLevels 40 and 20, and neither is a talent (no TraitDefinition). NOT in `ForeverTrainerData.lua`. DB2 does not say
  who teaches a spell. One look at a Paladin trainer at 20 and at 40 settles it.
- **Shared cooldowns.** The table that groups cooldowns (SpellCategories) is not in the cache. Not measured: that
  Divine Shield and Divine Protection share a cooldown (MH's text says so; both have a 5-minute category cooldown),
  and what Hammer of the Righteous shares with.
- **Server hotfixes.** DB2 70938 is client data. The hotfixes of 11 Nov (guides) can differ from it.
- **Tooltip numbers that grow with level** (Holy Shock, Oath of Light, Vindication, Blessing of Might): not worked
  out. Guides say Oath of Light adds up to 400 / 115 / 230 at 60.
- **Mana costs**: not read.
- **Dual spec at level 40**: GIDS only (Wowhead 16 Nov, wowforeveraddon 11 Nov, ConquestCapped).
- **Seal of Command's proc rate**: GIDS only ("about 7 a minute", Icy Veins); DB2 shows a 1 s internal cooldown.
- **TraitEdge type** (2 on seven edges, 3 on Holy Shock → Boundless Light): read as "needs first" (AFGELEID; the
  guides agree for Vengeance, Unsealed Wrath, Shieldsworn and Light's Vigil).
- **Role per tree**: not in DB2 (see 1).
- **Nothing was checked in the game.**

## 7. For the build chat (seen in MH's code and texts; not changed)

1. **Key 3 hides Seal of Righteousness for a Ret Paladin.** `ForeverBlock_Paladin.lua` line 24: `["3"] = { base = {
   "Seal of Command", "Seal of Righteousness" } }`, and `ForeverBlock.lua` takes the first one you know (`First(def.base)`).
   Once Seal of Command is known, Seal of Righteousness has no key, and it is not in toBlockD either. The Ret capstone
   Unsealed Wrath (40) only works when you switch between two seals, and the guides switch between exactly these two.
   Seal of Fury (**F**) and the block D seals do work as the second seal. Players choose: a line in the text, or
   Seal of Righteousness in toBlockD.
2. **Divine Intervention on F3 in a fight kills the Paladin** (spell 19752: "sacrifices himself", cooldown 1 hour).
   CLASSES.PALADIN "What comes later" only says "in a fight, F3 casts this one instead of Redemption".
3. **Righteous Fury is missing from the class text.** It is a level 10 trainer spell (block D) and the tank's first
   button; "Levels 1-10: your buttons" lists Seal of Fury but not Righteous Fury.
4. **CLASSES.PALADIN "What comes later" has no talents line**, unlike the other classes. The nine talent keys and
   their earliest levels: Divine Favor Shift-3 (20), Templar's Bulwark X (20), Seal of Command 3 (20), Oath of Light
   Shift-R (25), Swift Judgement F1 (25), Holy Shock F4 (30), Holy Shield Shift-4 (30), Repentance V (30), Light's
   Vigil Shift-F1 (40).
5. **Hammer of the Righteous (Shift-2; macro row "righteous", level 40, talent = false) and Voice of Truth (block D)
   are not in `ForeverTrainerData.lua`.** Either the trainer list misses two rows, or the spells cannot be learned
   (6a.12, 6c). Until that is known, the role text should not lean on either.
6. **Hammer of the Righteous needs a one-handed weapon** (SpellEquippedItems 251475: class 2, mask 145 = one-handed
   axe, mace, sword). A Ret Paladin with a two-hander cannot use Shift-2. The macro row is spec 2 only, which fits.
7. **Forbearance line in "Beginner mistakes"**: Templar's Bulwark gives it and is blocked by it too (spell 25771 text).
8. **"Divine Shield and Divine Protection share one cooldown"**: not verifiable in the cache (6c). Left as it is.
9. **Turn Undead "works on Undead only"**: true without the talent; with Turn Evil (Ret, 30) also on Demons.
10. Checked and correct in the class text (GEMETEN): a seal lasts 30 s; a blessing 60 min; Judgement 10 s and does not
    use up the seal; Divine Protection 6 s / 5 min; Lay on Hands 20 min; Divine Shield 10 s with half damage at 34;
    Seal of Fury at 10 and its Judgement taunts (3 s could be added); Consecration, Exorcism, Flash of Light and
    Blessing of Kings at 20; Cleanse 42; Hammer of Wrath 44; Greater Blessings 52 (Might), 54 (Wisdom), 60 (Kings).
11. `ForeverMacros.lua` SPEC_NAMES.PALADIN, the paladin talent levels, `ForeverDirection.lua` GUIDE.PALADIN and
    `ForeverMainStats.lua` (Champion of the Light exists: Ret row 6, 5 ranks) all agree with DB2 70938.
