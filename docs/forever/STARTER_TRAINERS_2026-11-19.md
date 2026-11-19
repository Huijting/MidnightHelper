# Starter class trainers in WoW Forever: how far do they teach? (19 Nov 2026)

## Answer in short
- **Every class trainer in a race starting area teaches spells up to level 6 at most.** Same cap for every class. GEMETEN in 5 independent sources (below). No source gives any other cap for Forever.
- **Every trainer in the first village (Razor Hill, Sen'jin, Bloodhoof, Brill, Dolanaar, Goldshire, Kharanos), in the capitals and in Shen'dar Village / Valanaar teaches the full list (1-60).**
- For MH: a starter trainer only helps while the next spell the player needs is level 6 or lower. From level 8 on he must go to a full trainer. AFGELEID (from the cap).
- Rob's bug fits exactly: Mai'ah showed Arcane Intellect R1 (lvl 1), Frostbolt R1 (4), Conjure Water R1 (4), Fireball R2 (6), Conjure Food R1 (6), Fire Blast R1 (6). GEMETEN levels, Forever DB2 SpellLevels build 1.60.1.70959: 1459=1, 116=4, 5504=4, 143=6, 587=6, 2136=6. His level-8 spells (Arcane Missiles 5143, Polymorph 118: BaseLevel 8) and level-10 spells (Frost Nova 122, Conjure Water R2 5505, Frost Armor R2 7300: BaseLevel 10) were not on her list. So her list stops at 6. GEMETEN (Rob in game + DB2).
- Eversong / Sunstrider: no trainer rows in MH's list and none in Warcraft Tavern's Forever list. AFGELEID: not in Forever (Classic world).

## Sources (all fetched 19 Nov 2026)
- [WT] Warcraft Tavern, "Class Trainer Locations - WoW Forever" (Val Hull, no date on the page): "Trainers marked with an asterisk (*) ... will only teach abilities up to level 6." Asterisks also read in the raw table rows (Exa).
- [WH-Z] Wowhead Forever guide "Zephras Isle Zone Overview" (Nodge, updated 2026/10/22): every Thendal Village trainer has "(Up to Level 6)". Shen'dar and Valanaar trainers do not.
- [WH-L] Wowhead Forever Hunter leveling guide (Serenal, 2026/11/12) and Priest leveling guide (Serenal, 2026/11/17): "...and only trains abilities up to level 6" for Thorgas, Ayanna, Jen'shan, Lanka, Branstock, Anetta, Shanda, Ken'jai, Duesten.
- [W4E] guide.wow4ever.se "Teaches in Forever": lists that players recorded in Forever with the Forever Scout addon (dates 5-15 Nov 2026, 1-4 players each).
- [SS] stillsixty.com npc pages. Their trainer data = CMaNGOS Classic-DB plus Forever changes (their About page). This is a Classic CANDIDATE, not a Forever measurement.
- [WFI] wowforeverinfo.com city guide (8 Nov 2026): "*" = only up to level 6.
- [WH-C] Wowhead Classic mage trainer guide (2023/11/09): "the Mage trainers found in the 1-5 starter zones only train through level 6". Classic CANDIDATE.

## Q1: starting-area trainers (npc ids from ForeverTrainerSpots.lua)
| npc | name | area | highest level | full list? | source |
|---|---|---|---|---|---|
| 5884 | Mai'ah (mage) | Valley of Trials | 6 | no | Rob in game; WT*; SS 6; WH-C |
| 3154 | Jen'shan (hunter) | Valley of Trials | 6 | no | WT*; WH-L; SS 6 |
| 3707 | Ken'jai (priest) | Valley of Trials | 6 | no | WT*; WH-L; SS 6 |
| 3155 | Rwag (rogue) | Valley of Trials | 6 | no | WT*; SS 6 |
| 3157 | Shikrik (shaman) | Valley of Trials | 6 | no | WT*; SS 6 |
| 3156 | Nartok (warlock) | Valley of Trials | 6 | no | WT*; SS 6 |
| 3153 | Frang (warrior) | Valley of Trials | 6 | no | WT*; SS 6 |
| 3060 | Gart Mistrunner (druid) | Camp Narache | 6 | no | WT*; SS 6 |
| 3061 | Lanka Farshot (hunter) | Camp Narache | 6 | no | WT*; WH-L; SS 6 |
| 3062 | Meela Dawnstrider (shaman) | Camp Narache | 6 | no | WT*; SS 6 |
| 3059 | Harutt Thunderhorn (warrior) | Camp Narache | 6 | no | WT*; SS 6 |
| 2124 | Isabella (mage) | Deathknell | 6 | no | WT*; SS 6 |
| 244808 | Aramis Hammerhand (paladin, new) | Deathknell | 6 | no | WT*; WFI*. No spell list found (SS 404, W4E empty) |
| 2123 | Dark Cleric Duesten (priest) | Deathknell | 6 | no | WT*; WH-L; SS 6 |
| 2122 | David Trias (rogue) | Deathknell | 6 (see conflict) | no | SS 6; warcraftmaps.com (CMaNGOS) 6. WT has NO asterisk |
| 2126 | Maximillion (warlock) | Deathknell | 6 | no | WT*; SS 6 |
| 2119 | Dannal Stern (warrior) | Deathknell | 6 | no | WT*; SS 6 |
| 944 | Marryk Nurribit (mage) | Coldridge | 6 | no | WT*; SS 6 |
| 926 | Bromos Grummner (paladin) | Coldridge | 6 | no | W4E 7 spells, max 6 (7 Nov); WT*. SS says 8 (Purify) |
| 837 | Branstock Khalder (priest) | Coldridge | 6 | no | WT*; WH-L; SS 6 |
| 916 | Solm Hargrin (rogue) | Coldridge | 6 | no | WT*; SS 6 |
| 460 | Alamar Grimm (warlock) | Coldridge | 6 | no | WT*; SS 6 |
| 912 | Thran Khorman (warrior) | Coldridge | 6 | no | WT*; SS 6 |
| 895 | Thorgas Grimson (hunter) | Coldridge | 6 | no | WT*; WH-L; SS 6 |
| 257446 | Teo Hammerstorm (shaman, new) | Coldridge | 6 | no | W4E 4 spells, max 6 (5 Nov, 3 players); WT*; WFI* |
| 198 | Khelden Bremen (mage) | Northshire | 6 | no | WT*; SS 6 |
| 925 | Brother Sammuel (paladin) | Northshire | 6 | no | W4E 7 spells, max 6 (9 Nov, 2 players); WT*. SS says 8 (Purify) |
| 375 | Priestess Anetta (priest) | Northshire | 6 | no | WT*; WH-L; SS 6 |
| 915 | Jorik Kerridan (rogue) | Northshire | 6 | no | WT*; SS 6 |
| 459 | Drusilla La Salle (warlock) | Northshire | 6 | no | WT*; SS 6 |
| 911 | Llane Beshere (warrior) | Northshire | 6 | no | WT*; SS 6 |
| 248415 | Tordrin Sternblade (hunter, new) | Northshire | 6 (see conflict) | no | WT* only. WFI lists him WITHOUT asterisk. No spell list found |
| 3597 | Mardant Strongoak (druid) | Shadowglen | 6 | no | WT*; SS 6 |
| 3596 | Ayanna Everstride (hunter) | Shadowglen | 6 | no | WT*; WH-L; SS 6 |
| 3595 | Shanda (priest) | Shadowglen | 6 | no | WT*; WH-L; SS 6 |
| 3594 | Frahun Shadewhisper (rogue) | Shadowglen | 6 | no | WT*; SS 6 |
| 3593 | Alyissia (warrior) | Shadowglen | 6 | no | WT*; SS 6 |
| 251373 | Xyton Silverwind (druid) | Thendal Village, Zephras | 6 | no | WH-Z; WT*; W4E 5 spells (8 Nov) |
| 251376 | Tai'ree Farsight (hunter) | Thendal Village | 6 | no | WH-Z; WT*; W4E 5 spells, max 6 (10 Nov) |
| 251379 | Dorii Brightwhisper (mage) | Thendal Village | 6 | no | WH-Z; WT*; W4E 6 spells, max 6 (6 Nov). Same 6 spells as Mai'ah |
| 251389 | Akeri Duskblade (rogue) | Thendal Village | 6 | no | WH-Z; WT* |
| 251374 | Windshaper Boro (shaman) | Thendal Village | 6 | no | WH-Z; WT* |
| 251964 | Blademaster Ren (warrior) | Thendal Village | 6 | no | WH-Z; WT*; W4E 5 spells, max 6 (15 Nov) |

Fixed cap or per class? **Fixed: 6 for every class.** GEMETEN for every class at least once in a Forever-dated source; no Forever source gives another number. The only other number is SS (Classic-DB) saying 8 for the two paladin starters (Purify); Forever player recordings [W4E] show both stop at 6 without Purify, so in Forever it is 6.

## Q2: Horde mage
| npc | name | where | highest level | full list? | source |
|---|---|---|---|---|---|
| 5880 | Un'Thuwa | Sen'jin Village | 60 (tabs 1-10 ... 51-60) | yes | SS; WT no asterisk; WH-C no "only to 6" note; dragonfire-bg (Classic DB) "Teaches (146)" |
| 5882 | Pephredo | Orgrimmar | 60 | yes | SS; WT no asterisk |
| 5883 | Enyo | Orgrimmar | 60 | yes | SS; WT no asterisk |
| 5885 | Deino | Orgrimmar | 60 | yes | SS; WT no asterisk |
| 7311 | Uthel'nay | Orgrimmar | 60 | yes | SS; WT no asterisk |
Un'Thuwa's spell list in SS (Classic-DB) has Frost Nova R1, Conjure Water R2, Frost Armor R2 at level 10 - exactly Rob's missing spells. No Forever player recording of Un'Thuwa's list found (W4E empty). So "full" for these five is WT (Forever guide, no asterisk) + Classic data, not a Forever spell list.

## Q3: first-village trainers
- WT: NO asterisk on any trainer in Razor Hill, Sen'jin, Bloodhoof Village, Brill, Dolanaar, Goldshire, Kharanos (also none on Camp Gev'rek 262560/262558, Shen'dar 254xxx, Valanaar 252xxx). GEMETEN (WT).
- Forever player recordings [W4E], full list up to 60: Kal 3602 (Dolanaar, 184 spells, 5 Nov, 2 players); Ingrid Dunwald 258113 (Kharanos, 165 spells, 5 Nov, 4 players); Anathamaas Aetherwind 252373 (Valanaar, 161 spells, 15 Nov, 1 report). GEMETEN.
- SS (Classic-DB) full 1-60 tabs: Tarshaw Jaggedscar 3169 (Razor Hill), Krang Stonehoof 3063 (Bloodhoof), Cain Firesong 2128 (Brill), Zaldimar Wefhellt 328 (Goldshire), Magis Sparkmantle 1228 (Kharanos), Kal 3602. CANDIDATE.
- Not checked one by one: the other village trainers. AFGELEID full (WT has no asterisk on them).

## Conflicts and limits
- David Trias 2122: WT no asterisk, but Classic-DB (SS, warcraftmaps) and the Wowhead WotLK guide say up to 6. No Forever list. Treat as starter (6) unless Rob sees otherwise.
- Tordrin Sternblade 248415: WT asterisk, WFI no asterisk. No Forever list. Advice: treat as starter (6); he stands in Northshire like the others.
- Aramis Hammerhand 244808: only guide asterisks (WT, WFI). No spell list.
- NOT measured: Wowhead Forever npc "Teaches" tabs. WebFetch cannot see them: positive control wowhead.com/classic/npc=5884 also showed no Teaches tab, though it has one. Exa fetch of wowhead = SOURCE_NOT_AVAILABLE. No browser tool in this session.
- The WT asterisk lists came through a summarising fetch; most rows were re-read in raw Exa table text (asterisks seen on Mai'ah, Isabella, Marryk, Khelden, Jen'shan, Lanka, Thorgas, Ayanna, Tordrin, Tai'ree, Bromos, Sammuel, Aramis, Ken'jai, Duesten, Branstock, Anetta, Shanda, Rwag, Solm, Jorik, Teo, Shikrik, Meela, Nartok, Maximillion, Alamar, Drusilla, Frang, Dannal, Thran, Llane; none on David Trias).
- W4E lists are what players recorded; they can be incomplete. Their max level is still 6 for every starter they cover.
- foreverquestlog.com says for Dorii "every Mage trainer teaches the same list (192)". That is contradicted by WH-Z, WT and W4E; ignore it.
