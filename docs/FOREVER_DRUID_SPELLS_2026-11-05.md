# WoW Forever Druid: active spells levels 1-60 (client 1.60.1.70790)

Researched 5 Nov 2026. Research by mh-research for the Forever key block (Rob: "Eigen Forever-lijst"); positive control re-checked by hand against Rob's /mh spellbook dump.

## Sources (all fetched 5 Nov 2026)
- **DB2** = wago.tools, product `wowf`, build **1.60.1.70790** (wago `created_at` 2026-11-04 18:08). This is the same build as Rob's client (`E:\World of Warcraft\.build.info` line 5 says `1.60.1.70790 ... wowf`).
  Tables used: SkillLineAbility (SkillLine 574 Balance, 134 Feral Combat, 573 Restoration), SpellName, Spell (rank subtext), SpellLevels, SpellMisc (passive bit 0x40), SpellShapeshift, SpellEffect (teach spells), TraitTree/TraitNode/TraitNodeEntry/TraitDefinition/TraitCond (talents), ChrSpecialization.
- **WH** = Wowhead Forever: `wowhead.com/forever/spells/abilities/druid` (282 rows, read from the page's own listview data). Its `source` field is 6 = trainer, 4 = quest, 2 = drop/book. Also used: the per-spell "Reward from" and "Taught by" tabs.
- **Zygor** = `ZygorGuidesViewerForever\Data-Forever\Skill_Training.lua` (lines 1252-1494) plus the leveling guides. Its trainer data matches DB2 builds up to 70707 (30 Oct), so it is **older** than the live build (see "Build churn").
- warcraft.wiki.gg "To Darnassus (Forever)": quest 98397, level 20, rewards Cat Form, Claw, Prowl, Rip.
- conquestcapped.com WoW Forever Druid overview ("Updated 19 Oct 2026", but it cites the 30 Oct hotfixes).

## Positive control: PASSES (GEMETEN, DB2 70790)
| Rob measured | DB2 70790 |
|---|---|
| Healing Touch R1 5185, Restoration | 5185 "Rank 1", SkillLine 573 (Restoration), level 1, AcquireMethod 2 (starting spell) |
| Mark of the Wild R1 1126, Restoration | 1126 "Rank 1", 573, level 1 (WH: trainer, 10c) |
| Rejuvenation R1 774, Restoration | 774 "Rank 1", 573, level 4 |
| Moonfire R1 8921, Balance | 8921 "Rank 1", 574 (Balance), level 4 |
| Thorns R1 467, Balance | 467 "Rank 1", 574, level 6 |
| Wrath R1 5176 / R2 5177, Balance | 5176 level 1 (starting spell), 5177 level 6, both 574 |
| Shadowmeld 20580, Elune's Light 1259799 | both in SpellName with subtext "Racial" |
| Spec 1484 | ChrSpecialization 1484 = "Druid", ClassID 11 (one spec per class) |
| Level 7: nothing else | The next spells are Entangling Roots R1 and Healing Touch R2 at level 8. That matches Rob's spellbook. |

## Legend
- Level marked `*` is a talent. The number is the earliest level the tree row opens. It is AFGELEID from TraitCond: each row needs 5 more points spent in that section (0/5/10/15/20/25/30). There are 51 points (TraitCurrency 3820 SourcedMax 51), so I assume 1 point per level from level 10. The level DB2 SpellLevels gives for talent spells is often stale vanilla data (Insect Swarm 20, Nature's Swiftness/Swiftmend/Shifting Power 1).
- Form: "Cat" or "Bear/Dire Bear" means the spell needs that form. The DB2 SpellShapeshift mask has no "usable without form" attribute for these. "none" means caster form. The reading of the mask is AFGELEID, but the mask values themselves are GEMETEN.
- Every row's ID, rank, level and tab is GEMETEN in DB2 70790. "+WH" means Wowhead Forever lists the same ID with the same level and gives the source shown.

## Full table (208 rows)
| Spell | Rank | ID | Level | How learned | Tab | Form | Measured? |
|---|---|---|---|---|---|---|---|
| Healing Touch | Rank 1 | 5185 | 1 | starting spell (DB2 AcquireMethod 2) | Restoration | none (not in Moonkin) | GEMETEN (DB2 + WH) |
| Mark of the Wild | Rank 1 | 1126 | 1 | trainer | Restoration | none | GEMETEN (DB2 + WH) |
| Wrath | Rank 1 | 5176 | 1 | starting spell (DB2 AcquireMethod 2) | Balance | none | GEMETEN (DB2 + WH) |
| Moonfire | Rank 1 | 8921 | 4 | trainer | Balance | none | GEMETEN (DB2 + WH) |
| Rejuvenation | Rank 1 | 774 | 4 | trainer | Restoration | none (not in Moonkin) | GEMETEN (DB2 + WH) |
| Thorns | Rank 1 | 467 | 6 | trainer | Balance | none | GEMETEN (DB2 + WH) |
| Wrath | Rank 2 | 5177 | 6 | trainer | Balance | none | GEMETEN (DB2 + WH) |
| Entangling Roots | Rank 1 | 339 | 8 | trainer | Balance | none | GEMETEN (DB2 + WH) |
| Healing Touch | Rank 2 | 5186 | 8 | trainer | Restoration | none (not in Moonkin) | GEMETEN (DB2 + WH) |
| Bear Form | Shapeshift | 5487 | 10 | quest: Body and Heart 6001 (A) / 6002 (H); Skyborne: Strength and Mercy 94638 | Feral Combat | (is a form) | GEMETEN (DB2 + WH) |
| Demoralizing Roar | Rank 1 | 99 | 10 | trainer | Feral Combat | Bear/Dire Bear | GEMETEN (DB2 + WH) |
| Growl | - | 6795 | 10 | quest (taught with Bear Form: teach spells 19179/5488 learn 5487+6795+6807) | Feral Combat | Bear/Dire Bear | GEMETEN (DB2 + WH) |
| Mark of the Wild | Rank 2 | 5232 | 10 | trainer | Restoration | none | GEMETEN (DB2 + WH) |
| Maul | Rank 1 | 6807 | 10 | quest (taught with Bear Form) | Feral Combat | Bear/Dire Bear | GEMETEN (DB2 + WH) |
| Moonfire | Rank 2 | 8924 | 10 | trainer | Balance | none | GEMETEN (DB2 + WH) |
| Nature's Grasp | Rank 1 | 16689 | 10 | trainer (was a talent in Classic, WH) | Balance | none | GEMETEN (DB2 + WH) |
| Rejuvenation | Rank 2 | 1058 | 10 | trainer | Restoration | none (not in Moonkin) | GEMETEN (DB2 + WH) |
| Teleport: Moonglade | - | 18960 | 10 | probably quest "Moonglade" 5921 (A) / 5922 (H); no trainer in Zygor or WH | Balance | none | level/tab GEMETEN; source AFGELEID |
| Enrage | - | 5229 | 12 | trainer | Feral Combat | Bear/Dire Bear | GEMETEN (DB2 + WH) |
| Regrowth | Rank 1 | 8936 | 12 | trainer | Restoration | none (not in Moonkin) | GEMETEN (DB2 + WH) |
| Revive | Rank 1 | 437138 | 12 | trainer (NEW in Forever) | Restoration | none | GEMETEN (DB2 + WH) |
| Bash | Rank 1 | 5211 | 14 | trainer | Feral Combat | Bear/Dire Bear | GEMETEN (DB2 + WH) |
| Cure Poison | - | 8946 | 14 | quest: Power over Poison 6125 (A) / 6130 (H) | Restoration | none | GEMETEN (DB2 + WH) |
| Healing Touch | Rank 3 | 5187 | 14 | trainer | Restoration | none (not in Moonkin) | GEMETEN (DB2 + WH) |
| Thorns | Rank 2 | 782 | 14 | trainer | Balance | none | GEMETEN (DB2 + WH) |
| Wrath | Rank 3 | 5178 | 14 | trainer | Balance | none | GEMETEN (DB2 + WH) |
| Aquatic Form | Shapeshift | 1066 | 16 | quest: Aquatic Form 5061 (A) / 31 (H) | Feral Combat | (is a form) | GEMETEN (DB2 + WH) |
| Moonfire | Rank 3 | 8925 | 16 | trainer | Balance | none | GEMETEN (DB2 + WH) |
| Rejuvenation | Rank 3 | 1430 | 16 | trainer | Restoration | none (not in Moonkin) | GEMETEN (DB2 + WH) |
| Swipe | Rank 1 | 779 | 16 | trainer | Feral Combat | Bear/Dire Bear | GEMETEN (DB2 + WH) |
| Entangling Roots | Rank 2 | 1062 | 18 | trainer | Balance | none | GEMETEN (DB2 + WH) |
| Faerie Fire | Rank 1 | 770 | 18 | trainer | Balance | none (also Cat/Bear/Moonkin) | GEMETEN (DB2 + WH) |
| Hibernate | Rank 1 | 2637 | 18 | trainer | Balance | none | GEMETEN (DB2 + WH) |
| Maul | Rank 2 | 6808 | 18 | trainer | Feral Combat | Bear/Dire Bear | GEMETEN (DB2 + WH) |
| Nature's Grasp | Rank 2 | 16810 | 18 | trainer | Balance | none | GEMETEN (DB2 + WH) |
| Regrowth | Rank 2 | 8938 | 18 | trainer | Restoration | none (not in Moonkin) | GEMETEN (DB2 + WH) |
| Cat Form | Shapeshift | 768 | 20 | quest: To Darnassus 98397 (A) / To Thunder Bluff 98362 (H); WH also lists trainers | Feral Combat | (is a form) | GEMETEN (DB2 + WH + wiki) |
| Claw | Rank 1 | 1082 | 20 | quest (comes with Cat Form: teach spell 1309050 learns 768+5215+1082+1079); WH also trainer | Feral Combat | Cat | GEMETEN (DB2 + WH) |
| Demoralizing Roar | Rank 2 | 1735 | 20 | trainer | Feral Combat | Bear/Dire Bear | GEMETEN (DB2 + WH) |
| Feral Charge | - | 1238122 | 20* | TALENT (Feral section, row 3) | Feral Combat | Cat or Bear | GEMETEN (DB2 tree 1089); level AFGELEID |
| Healing Touch | Rank 4 | 5188 | 20 | trainer | Restoration | none (not in Moonkin) | GEMETEN (DB2 + WH) |
| Mark of the Wild | Rank 3 | 6756 | 20 | trainer | Restoration | none | GEMETEN (DB2 + WH) |
| Omen of Clarity | - | 16864 | 20 | trainer, but **passive** now (so it is not in the active list; see notes) | Balance | - | GEMETEN (DB2 + WH) |
| Prowl | Rank 1 | 5215 | 20 | quest (comes with Cat Form); WH also trainer | Feral Combat | Cat | GEMETEN (DB2 + WH) |
| Rebirth | Rank 1 | 20484 | 20 | trainer | Restoration | none | GEMETEN (DB2 + WH) |
| Rip | Rank 1 | 1079 | 20 | quest (comes with Cat Form); WH also trainer | Feral Combat | Cat | GEMETEN (DB2 + WH) |
| Shred | Rank 1 | 5221 | 20 | trainer (level 20 instead of Classic's 22, WH) | Feral Combat | Cat | GEMETEN (DB2 + WH) |
| Starfire | Rank 1 | 2912 | 20 | trainer | Balance | none | GEMETEN (DB2 + WH) |
| Moonfire | Rank 4 | 8926 | 22 | trainer | Balance | none | GEMETEN (DB2 + WH) |
| Rejuvenation | Rank 4 | 2090 | 22 | trainer | Restoration | none (not in Moonkin) | GEMETEN (DB2 + WH) |
| Soothe Animal | Rank 1 | 2908 | 22 | trainer | Balance | none | GEMETEN (DB2 + WH) |
| Wrath | Rank 4 | 5179 | 22 | trainer | Balance | none | GEMETEN (DB2 + WH) |
| Ferocious Bite | Rank 1 | 1328618 | 24 | trainer (NEW rank, added in build 70753 on 2 Nov) | Feral Combat | Cat | GEMETEN (DB2 + WH) |
| Rake | Rank 1 | 1822 | 24 | trainer | Feral Combat | Cat | GEMETEN (DB2 + WH) |
| Regrowth | Rank 3 | 8939 | 24 | trainer | Restoration | none (not in Moonkin) | GEMETEN (DB2 + WH) |
| Remove Curse | - | 2782 | 24 | trainer | Restoration | none | GEMETEN (DB2 + WH) |
| Revive | Rank 2 | 1237948 | 24 | trainer | Restoration | none | GEMETEN (DB2 + WH) |
| Swipe | Rank 2 | 780 | 24 | trainer | Feral Combat | Bear/Dire Bear | GEMETEN (DB2 + WH) |
| Thorns | Rank 3 | 1075 | 24 | trainer | Balance | none | GEMETEN (DB2 + WH) |
| Insect Swarm | Rank 1 | 5570 | 25* | TALENT (Balance section, row 4) | Balance | none | GEMETEN (DB2 tree 1089); level AFGELEID |
| Lacerate | Rank 1 | 1328617 | 25* | TALENT (Feral section, row 4; DB2 SpellLevels also says 25) | Feral Combat | Bear/Dire Bear | GEMETEN (DB2 tree 1089) |
| Swiftmend | - | 18562 | 25* | TALENT (Restoration section, row 4) | Restoration | none (not in Moonkin) | GEMETEN (DB2 tree 1089); level AFGELEID |
| Abolish Poison | - | 2893 | 26 | trainer | Restoration | none | GEMETEN (DB2 + WH) |
| Dash | Rank 1 | 1850 | 26 | trainer | Feral Combat | Cat | GEMETEN (DB2 + WH) |
| Healing Touch | Rank 5 | 5189 | 26 | trainer | Restoration | none (not in Moonkin) | GEMETEN (DB2 + WH) |
| Maul | Rank 3 | 6809 | 26 | trainer | Feral Combat | Bear/Dire Bear | GEMETEN (DB2 + WH) |
| Starfire | Rank 2 | 8949 | 26 | trainer | Balance | none | GEMETEN (DB2 + WH) |
| Challenging Roar | - | 5209 | 28 | trainer | Feral Combat | Bear/Dire Bear | GEMETEN (DB2 + WH) |
| Claw | Rank 2 | 3029 | 28 | trainer | Feral Combat | Cat | GEMETEN (DB2 + WH) |
| Cower | Rank 1 | 8998 | 28 | trainer | Feral Combat | Cat | GEMETEN (DB2 + WH) |
| Entangling Roots | Rank 3 | 5195 | 28 | trainer | Balance | none | GEMETEN (DB2 + WH) |
| Moonfire | Rank 5 | 8927 | 28 | trainer | Balance | none | GEMETEN (DB2 + WH) |
| Nature's Grasp | Rank 3 | 16811 | 28 | trainer | Balance | none | GEMETEN (DB2 + WH) |
| Rejuvenation | Rank 5 | 2091 | 28 | trainer | Restoration | none (not in Moonkin) | GEMETEN (DB2 + WH) |
| Rip | Rank 2 | 9492 | 28 | trainer | Feral Combat | Cat | GEMETEN (DB2 + WH) |
| Bash | Rank 2 | 6798 | 30 | trainer | Feral Combat | Bear/Dire Bear | GEMETEN (DB2 + WH) |
| Faerie Fire | Rank 2 | 778 | 30 | trainer | Balance | none (also Cat/Bear/Moonkin) | GEMETEN (DB2 + WH) |
| Insect Swarm | Rank 2 | 24974 | 30 | trainer (needs the talent) | Balance | none | GEMETEN (DB2 + WH) |
| Mark of the Wild | Rank 4 | 5234 | 30 | trainer | Restoration | none | GEMETEN (DB2 + WH) |
| Nature's Swiftness | - | 17116 | 30* | TALENT (Restoration section, row 5) | Restoration | none (not in Moonkin) | GEMETEN (DB2 tree 1089); level AFGELEID |
| Rebirth | Rank 2 | 20739 | 30 | trainer | Restoration | none | GEMETEN (DB2 + WH) |
| Regrowth | Rank 4 | 8940 | 30 | trainer | Restoration | none (not in Moonkin) | GEMETEN (DB2 + WH) |
| Shred | Rank 2 | 6800 | 30 | trainer | Feral Combat | Cat | GEMETEN (DB2 + WH) |
| Tranquility | Rank 1 | 740 | 30 | trainer | Restoration | none (not in Moonkin) | GEMETEN (DB2 + WH) |
| Travel Form | Shapeshift | 783 | 30 | trainer | Feral Combat | (is a form) | GEMETEN (DB2 + WH) |
| Wrath | Rank 5 | 5180 | 30 | trainer | Balance | none | GEMETEN (DB2 + WH) |
| Demoralizing Roar | Rank 3 | 9490 | 32 | trainer | Feral Combat | Bear/Dire Bear | GEMETEN (DB2 + WH) |
| Ferocious Bite | Rank 2 | 22568 | 32 | trainer (was Rank 1 in Classic) | Feral Combat | Cat | GEMETEN (DB2 + WH) |
| Healing Touch | Rank 6 | 6778 | 32 | trainer | Restoration | none (not in Moonkin) | GEMETEN (DB2 + WH) |
| Ravage | Rank 1 | 6785 | 32 | trainer | Feral Combat | Cat | GEMETEN (DB2 + WH) |
| Track Humanoids | - | 5225 | 32 | trainer | Feral Combat | Cat | GEMETEN (DB2 + WH) |
| Lacerate | Rank 2 | 1328616 | 34 | trainer | Feral Combat | Bear/Dire Bear | GEMETEN (DB2 + WH) |
| Maul | Rank 4 | 8972 | 34 | trainer | Feral Combat | Bear/Dire Bear | GEMETEN (DB2 + WH) |
| Moonfire | Rank 6 | 8928 | 34 | trainer | Balance | none | GEMETEN (DB2 + WH) |
| Rake | Rank 2 | 1823 | 34 | trainer | Feral Combat | Cat | GEMETEN (DB2 + WH) |
| Rejuvenation | Rank 6 | 3627 | 34 | trainer | Restoration | none (not in Moonkin) | GEMETEN (DB2 + WH) |
| Starfire | Rank 3 | 8950 | 34 | trainer | Balance | none | GEMETEN (DB2 + WH) |
| Swipe | Rank 3 | 769 | 34 | trainer | Feral Combat | Bear/Dire Bear | GEMETEN (DB2 + WH) |
| Thorns | Rank 4 | 8914 | 34 | trainer | Balance | none | GEMETEN (DB2 + WH) |
| Frenzied Regeneration | - | 22842 | 36 | trainer (only one rank now) | Feral Combat | Bear/Dire Bear | GEMETEN (DB2 + WH) |
| Pounce | Rank 1 | 9005 | 36 | trainer | Feral Combat | Cat | GEMETEN (DB2 + WH) |
| Regrowth | Rank 5 | 8941 | 36 | trainer | Restoration | none (not in Moonkin) | GEMETEN (DB2 + WH) |
| Revive | Rank 3 | 1237949 | 36 | trainer | Restoration | none | GEMETEN (DB2 + WH) |
| Rip | Rank 3 | 9493 | 36 | trainer | Feral Combat | Cat | GEMETEN (DB2 + WH) |
| Claw | Rank 3 | 5201 | 38 | trainer | Feral Combat | Cat | GEMETEN (DB2 + WH) |
| Entangling Roots | Rank 4 | 5196 | 38 | trainer | Balance | none | GEMETEN (DB2 + WH) |
| Healing Touch | Rank 7 | 8903 | 38 | trainer | Restoration | none (not in Moonkin) | GEMETEN (DB2 + WH) |
| Hibernate | Rank 2 | 18657 | 38 | trainer | Balance | none | GEMETEN (DB2 + WH) |
| Nature's Grasp | Rank 4 | 16812 | 38 | trainer | Balance | none | GEMETEN (DB2 + WH) |
| Shred | Rank 3 | 8992 | 38 | trainer | Feral Combat | Cat | GEMETEN (DB2 + WH) |
| Soothe Animal | Rank 2 | 8955 | 38 | trainer | Balance | none | GEMETEN (DB2 + WH) |
| Wrath | Rank 6 | 6780 | 38 | trainer | Balance | none | GEMETEN (DB2 + WH) |
| Cower | Rank 2 | 9000 | 40 | trainer | Feral Combat | Cat | GEMETEN (DB2 + WH) |
| Dire Bear Form | Shapeshift | 9634 | 40 | trainer | Feral Combat | (is a form) | GEMETEN (DB2 + WH) |
| Ferocious Bite | Rank 3 | 22827 | 40 | trainer | Feral Combat | Cat | GEMETEN (DB2 + WH) |
| Hurricane | Rank 1 | 16914 | 40 | trainer | Balance | none | GEMETEN (DB2 + WH + Zygor) |
| Innervate | - | 29166 | 40 | trainer | Restoration | none | GEMETEN (DB2 + WH) |
| Insect Swarm | Rank 3 | 24975 | 40 | trainer (needs the talent) | Balance | none | GEMETEN (DB2 + WH) |
| Mark of the Wild | Rank 5 | 8907 | 40 | trainer | Restoration | none | GEMETEN (DB2 + WH) |
| Moonfire | Rank 7 | 8929 | 40 | trainer | Balance | none | GEMETEN (DB2 + WH) |
| Moonkin Form | Shapeshift | 24858 | 40* | TALENT (Balance section, row 7, 30 points) | Balance | (is a form) | GEMETEN (DB2 tree 1089) |
| Primal Bite | Rank 1 | 407995 | 40* | TALENT (Feral section, row 7) | Feral Combat | Bear/Dire Bear | GEMETEN (DB2 tree 1089) |
| Prowl | Rank 2 | 6783 | 40 | trainer | Feral Combat | Cat | GEMETEN (DB2 + WH) |
| Rebirth | Rank 3 | 20742 | 40 | trainer | Restoration | none | GEMETEN (DB2 + WH) |
| Rejuvenation | Rank 7 | 8910 | 40 | trainer | Restoration | none (not in Moonkin) | GEMETEN (DB2 + WH) |
| Shifting Power | - | 1322605 | 40* | TALENT (Feral section, row 7) | Feral Combat | Cat | GEMETEN (DB2 tree 1089); level AFGELEID |
| Tranquility | Rank 2 | 8918 | 40 | trainer | Restoration | none (not in Moonkin) | GEMETEN (DB2 + WH) |
| Wild Growth | Rank 1 | 408120 | 40* | TALENT (Restoration section, row 7) | Restoration | none (not in Moonkin) | GEMETEN (DB2 tree 1089) |
| Demoralizing Roar | Rank 4 | 9747 | 42 | trainer | Feral Combat | Bear/Dire Bear | GEMETEN (DB2 + WH) |
| Faerie Fire | Rank 3 | 9749 | 42 | trainer | Balance | none (also Cat/Bear/Moonkin) | GEMETEN (DB2 + WH) |
| Lacerate | Rank 3 | 414644 | 42 | trainer | Feral Combat | Bear/Dire Bear | GEMETEN (DB2 + WH) |
| Maul | Rank 5 | 9745 | 42 | trainer | Feral Combat | Bear/Dire Bear | GEMETEN (DB2 + WH) |
| Ravage | Rank 2 | 6787 | 42 | trainer | Feral Combat | Cat | GEMETEN (DB2 + WH) |
| Regrowth | Rank 6 | 9750 | 42 | trainer | Restoration | none (not in Moonkin) | GEMETEN (DB2 + WH) |
| Starfire | Rank 4 | 8951 | 42 | trainer | Balance | none | GEMETEN (DB2 + WH) |
| Barkskin | - | 22812 | 44 | trainer | Balance | any form | GEMETEN (DB2 + WH) |
| Healing Touch | Rank 8 | 9758 | 44 | trainer | Restoration | none (not in Moonkin) | GEMETEN (DB2 + WH) |
| Rake | Rank 3 | 1824 | 44 | trainer | Feral Combat | Cat | GEMETEN (DB2 + WH) |
| Rip | Rank 4 | 9752 | 44 | trainer | Feral Combat | Cat | GEMETEN (DB2 + WH) |
| Swipe | Rank 4 | 9754 | 44 | trainer | Feral Combat | Bear/Dire Bear | GEMETEN (DB2 + WH) |
| Thorns | Rank 5 | 9756 | 44 | trainer | Balance | none | GEMETEN (DB2 + WH) |
| Bash | Rank 3 | 8983 | 46 | trainer | Feral Combat | Bear/Dire Bear | GEMETEN (DB2 + WH) |
| Dash | Rank 2 | 9821 | 46 | trainer | Feral Combat | Cat | GEMETEN (DB2 + WH) |
| Moonfire | Rank 8 | 9833 | 46 | trainer | Balance | none | GEMETEN (DB2 + WH) |
| Pounce | Rank 2 | 9823 | 46 | trainer | Feral Combat | Cat | GEMETEN (DB2 + WH) |
| Rejuvenation | Rank 8 | 9839 | 46 | trainer | Restoration | none (not in Moonkin) | GEMETEN (DB2 + WH) |
| Shred | Rank 4 | 9829 | 46 | trainer | Feral Combat | Cat | GEMETEN (DB2 + WH) |
| Wrath | Rank 7 | 8905 | 46 | trainer | Balance | none | GEMETEN (DB2 + WH) |
| Claw | Rank 4 | 9849 | 48 | trainer | Feral Combat | Cat | GEMETEN (DB2 + WH) |
| Entangling Roots | Rank 5 | 9852 | 48 | trainer | Balance | none | GEMETEN (DB2 + WH) |
| Ferocious Bite | Rank 4 | 22828 | 48 | trainer | Feral Combat | Cat | GEMETEN (DB2 + WH) |
| Nature's Grasp | Rank 5 | 16813 | 48 | trainer | Balance | none | GEMETEN (DB2 + WH) |
| Regrowth | Rank 7 | 9856 | 48 | trainer | Restoration | none (not in Moonkin) | GEMETEN (DB2 + WH) |
| Revive | Rank 4 | 1237950 | 48 | trainer | Restoration | none | GEMETEN (DB2 + WH) |
| Gift of the Wild | Rank 1 | 21849 | 50 | book: "Book: Gift of the Wild" (17682) | Restoration | none | GEMETEN (DB2 + WH) |
| Healing Touch | Rank 9 | 9888 | 50 | trainer | Restoration | none (not in Moonkin) | GEMETEN (DB2 + WH) |
| Hurricane | Rank 2 | 17401 | 50 | trainer | Balance | none | GEMETEN (DB2 + WH) |
| Insect Swarm | Rank 4 | 24976 | 50 | trainer (needs the talent) | Balance | none | GEMETEN (DB2 + WH) |
| Lacerate | Rank 4 | 1235826 | 50 | trainer | Feral Combat | Bear/Dire Bear | GEMETEN (DB2 + WH) |
| Mark of the Wild | Rank 6 | 9884 | 50 | trainer | Restoration | none | GEMETEN (DB2 + WH) |
| Maul | Rank 6 | 9880 | 50 | trainer | Feral Combat | Bear/Dire Bear | GEMETEN (DB2 + WH) |
| Primal Bite | Rank 2 | 1238069 | 50 | trainer | Feral Combat | Bear/Dire Bear | GEMETEN (DB2 + WH) |
| Ravage | Rank 3 | 9866 | 50 | trainer | Feral Combat | Cat | GEMETEN (DB2 + WH) |
| Rebirth | Rank 4 | 20747 | 50 | trainer | Restoration | none | GEMETEN (DB2 + WH) |
| Starfire | Rank 5 | 9875 | 50 | trainer | Balance | none | GEMETEN (DB2 + WH) |
| Tranquility | Rank 3 | 9862 | 50 | trainer | Restoration | none (not in Moonkin) | GEMETEN (DB2 + WH) |
| Wild Growth | Rank 2 | 1238214 | 50 | trainer | Restoration | none (not in Moonkin) | GEMETEN (DB2 + WH) |
| Cower | Rank 3 | 9892 | 52 | trainer | Feral Combat | Cat | GEMETEN (DB2 + WH) |
| Demoralizing Roar | Rank 5 | 9898 | 52 | trainer | Feral Combat | Bear/Dire Bear | GEMETEN (DB2 + WH) |
| Moonfire | Rank 9 | 9834 | 52 | trainer | Balance | none | GEMETEN (DB2 + WH) |
| Rejuvenation | Rank 9 | 9840 | 52 | trainer | Restoration | none (not in Moonkin) | GEMETEN (DB2 + WH) |
| Rip | Rank 5 | 9894 | 52 | trainer | Feral Combat | Cat | GEMETEN (DB2 + WH) |
| Faerie Fire | Rank 4 | 9907 | 54 | trainer | Balance | none (also Cat/Bear/Moonkin) | GEMETEN (DB2 + WH) |
| Rake | Rank 4 | 9904 | 54 | trainer | Feral Combat | Cat | GEMETEN (DB2 + WH) |
| Regrowth | Rank 8 | 9857 | 54 | trainer | Restoration | none (not in Moonkin) | GEMETEN (DB2 + WH) |
| Shred | Rank 5 | 9830 | 54 | trainer | Feral Combat | Cat | GEMETEN (DB2 + WH) |
| Soothe Animal | Rank 3 | 9901 | 54 | trainer | Balance | none | GEMETEN (DB2 + WH) |
| Swipe | Rank 5 | 9908 | 54 | trainer | Feral Combat | Bear/Dire Bear | GEMETEN (DB2 + WH) |
| Thorns | Rank 6 | 9910 | 54 | trainer | Balance | none | GEMETEN (DB2 + WH) |
| Wrath | Rank 8 | 9912 | 54 | trainer | Balance | none | GEMETEN (DB2 + WH) |
| Ferocious Bite | Rank 5 | 22829 | 56 | trainer | Feral Combat | Cat | GEMETEN (DB2 + WH) |
| Healing Touch | Rank 10 | 9889 | 56 | trainer | Restoration | none (not in Moonkin) | GEMETEN (DB2 + WH) |
| Pounce | Rank 3 | 9827 | 56 | trainer | Feral Combat | Cat | GEMETEN (DB2 + WH) |
| Claw | Rank 5 | 9850 | 58 | trainer | Feral Combat | Cat | GEMETEN (DB2 + WH) |
| Entangling Roots | Rank 6 | 9853 | 58 | trainer | Balance | none | GEMETEN (DB2 + WH) |
| Hibernate | Rank 3 | 18658 | 58 | trainer | Balance | none | GEMETEN (DB2 + WH) |
| Lacerate | Rank 5 | 1235827 | 58 | trainer | Feral Combat | Bear/Dire Bear | GEMETEN (DB2 + WH) |
| Maul | Rank 7 | 9881 | 58 | trainer | Feral Combat | Bear/Dire Bear | GEMETEN (DB2 + WH) |
| Moonfire | Rank 10 | 9835 | 58 | trainer | Balance | none | GEMETEN (DB2 + WH) |
| Nature's Grasp | Rank 6 | 17329 | 58 | trainer | Balance | none | GEMETEN (DB2 + WH) |
| Ravage | Rank 4 | 9867 | 58 | trainer | Feral Combat | Cat | GEMETEN (DB2 + WH) |
| Rejuvenation | Rank 10 | 9841 | 58 | trainer | Restoration | none (not in Moonkin) | GEMETEN (DB2 + WH) |
| Starfire | Rank 6 | 9876 | 58 | trainer | Balance | none | GEMETEN (DB2 + WH) |
| Ferocious Bite | Rank 6 | 31018 | 60 | book: "Book of Ferocious Bite V" (24101) | Feral Combat | Cat | GEMETEN (DB2 + WH) |
| Gift of the Wild | Rank 2 | 21850 | 60 | book (WH source = drop) | Restoration | none | GEMETEN (DB2 + WH) |
| Healing Touch | Rank 11 | 25297 | 60 | book: "Book of Healing Touch XI" (21294) | Restoration | none (not in Moonkin) | GEMETEN (DB2 + WH) |
| Hurricane | Rank 3 | 17402 | 60 | trainer | Balance | none | GEMETEN (DB2 + WH) |
| Insect Swarm | Rank 5 | 24977 | 60 | trainer (needs the talent) | Balance | none | GEMETEN (DB2 + WH) |
| Mark of the Wild | Rank 7 | 9885 | 60 | trainer | Restoration | none | GEMETEN (DB2 + WH) |
| Primal Bite | Rank 3 | 1238070 | 60 | trainer | Feral Combat | Bear/Dire Bear | GEMETEN (DB2 + WH) |
| Prowl | Rank 3 | 9913 | 60 | trainer | Feral Combat | Cat | GEMETEN (DB2 + WH) |
| Rebirth | Rank 5 | 20748 | 60 | trainer | Restoration | none | GEMETEN (DB2 + WH) |
| Regrowth | Rank 9 | 9858 | 60 | trainer | Restoration | none (not in Moonkin) | GEMETEN (DB2 + WH) |
| Rejuvenation | Rank 11 | 25299 | 60 | book (WH source = drop) | Restoration | none (not in Moonkin) | GEMETEN (DB2 + WH) |
| Revive | Rank 5 | 1237951 | 60 | trainer | Restoration | none | GEMETEN (DB2 + WH) |
| Rip | Rank 6 | 9896 | 60 | trainer | Feral Combat | Cat | GEMETEN (DB2 + WH) |
| Starfire | Rank 7 | 25298 | 60 | book (WH source = drop) | Balance | none | GEMETEN (DB2 + WH) |
| Tranquility | Rank 4 | 9863 | 60 | trainer | Restoration | none (not in Moonkin) | GEMETEN (DB2 + WH) |
| Wild Growth | Rank 3 | 1238215 | 60 | trainer | Restoration | none (not in Moonkin) | GEMETEN (DB2 + WH) |

(The Omen of Clarity row is for information only. It is passive, so it is not counted in the 208 active rows.)

## Forms (GEMETEN unless marked otherwise)
| Form | ID | Level | How | Tab |
|---|---|---|---|---|
| Bear Form | 5487 | 10 | quest Body and Heart 6001/6002 (Skyborne 94638); also teaches Growl + Maul R1 | Feral Combat |
| Aquatic Form | 1066 | 16 | quest Aquatic Form 5061/31 | Feral Combat |
| Cat Form | 768 | 20 | quest To Darnassus 98397 / To Thunder Bluff 98362 (new quests); also teaches Claw R1, Prowl R1, Rip R1. WH also lists trainers. | Feral Combat |
| Travel Form | 783 | 30 | trainer | Feral Combat |
| Dire Bear Form | 9634 | 40 | trainer | Feral Combat |
| Moonkin Form | 24858 | 40 (talent, 30 points in the Balance section, AFGELEID) | talent | Balance |

## Talent tree (GEMETEN: DB2 TraitTree 1089, linked to SkillLine 574 via SkillLineXTraitTree 158)
There is one tree with 52 nodes in three sections and 51 points. These are the active talent spells (SpellMisc passive bit is off):
Feral Charge 1238122 (row 3), Insect Swarm 5570 (row 4), Lacerate 1328617 (row 4), Swiftmend 18562 (row 4),
Nature's Swiftness 17116 (row 5), Moonkin Form 24858, Primal Bite 407995, Shifting Power 1322605, Wild Growth 408120 (all row 7).
All other nodes are passive.
TraitTree 1083 (36 nodes) still contains Berserk 417141 and Feral Charge (Bear) 16979, but no SkillLine links to that tree. It is an older tree.
Zygor's TalentAdvisor-Builds.lua still names Berserk and Improved Shifting Power. Neither is in tree 1089, so Zygor's builds are stale.

## Not learnable / removed (compared with Classic Era DB2 1.15.9.70576, GEMETEN)
- **Tiger's Fury**: Ranks 2-4 (6793/9845/9846) are gone from the client. Rank 1 (5217) is still in DB2, but its AcquireMethod changed from 0 to 3 ("never learned") in beta build 70235 (5 Oct 2026). Shifting Power appeared in the same build. Conquest Capped says Tiger's Fury was "replaced by the Shifting Power talent", and Zygor does not list it.
  **Conflict:** Wowhead Forever still lists Tiger's Fury at the trainer at level 24 (4000c). My judgement is "not learnable" (AFGELEID), but this needs checking at a trainer at level 24.
- **Faerie Fire (Feral)**: all ranks (16857, 17390-17392) are gone. The normal Faerie Fire can now be used in Cat, Bear and Moonkin form (DB2 shapeshift mask; Conquest Capped).
- **Frenzied Regeneration**: Ranks 2 and 3 (22895/22896) are gone, so it has one rank.
- **Feral Charge (Bear)** 16979 was replaced by Feral Charge 1238122, which works in Cat or Bear form.
- Berserk is not in the live tree (see above).

## Added or changed (GEMETEN)
- Revive (new out-of-combat resurrect) has 5 ranks: levels 12, 24, 36, 48, 60.
- Lacerate: R1 is a talent at 25, then trainer ranks at 34, 42, 50 and 58.
- Primal Bite: R1 is a talent at 40, R2 at 50, R3 at 60. Search summaries say it was renamed from Mangle (Bear). I did not open that source myself, so treat the rename as unconfirmed.
- Wild Growth: R1 is a talent at 40, R2 at 50, R3 at 60.
- Shifting Power: new talent, needs Cat Form.
- Ferocious Bite has a new Rank 1 at 24 (1328618). The old ranks moved up one: 22568 is now Rank 2 at 32, and 31018 is Rank 6 at 60.
- Shred Rank 1 now comes at level 20 instead of 22.
- Omen of Clarity is trainer-learned at 20 and passive. In Classic it was a talent and a 10-minute self-buff.
- Nature's Grasp is trainer-learned, ranks 1-6. In Classic it was a talent.
- Cat Form now comes from a quest at level 20. The quest also teaches Claw R1, Prowl R1 and Rip R1.

## Build churn (GEMETEN, wago build-by-build checks)
- Build 70707 (30 Oct): Primal Bite R2 at 36, R4 1238073 existed, Lacerate 414644 was at level 42, and Ferocious Bite 1328618 did not exist.
- Builds 70753/70755 (2-3 Nov): Ferocious Bite 1328618 added at 24, Lacerate 1328617 added as a level-25 talent, Primal Bite cut to 3 ranks.
- Zygor's Skill_Training.lua matches the 70707 state. For example, it lists "Primal Bite Rank 4 1238073" and "Lacerate Rank 1 414644 at 42". Do not use Zygor's data for these spells.

## Not verified
- Teleport: Moonglade: how it is learned (probably the level-10 "Moonglade" quest, AFGELEID).
- Whether the level-60 books (Healing Touch XI, Rejuvenation XI, Starfire VII, Ferocious Bite V, Gift of the Wild) can actually drop in Forever yet.
- Whether Cat Form, Claw, Prowl and Rip can also be bought at a trainer. Wowhead lists trainers for them.
- Trainer costs: these are Wowhead values only. I did not use them.
- One Wowhead page showed a human-verification check (`spell=19027`). I did not try to get past it.
