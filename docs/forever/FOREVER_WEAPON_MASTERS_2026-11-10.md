# WoW: Forever weapon masters and weapon skills (MH data table)

Researched 2026-11-10 by mh-research (read-only). Purpose: let MH answer "where do I learn weapon X?" for every class and race in WoW: Forever.

Labels:
- **MEASURED** = seen in a named source (URL or file:line), date seen given.
- **DERIVED** = my own reasoning from measured data. Says what it rests on.
- **SECONDARY** = another site's claim that I could not re-measure myself.
- "not found" = I looked and did not find it. An empty search proves nothing.

Main sources (all read 2026-11-10 unless noted):

| Key | Source | What it is |
|---|---|---|
| WH-TT | `https://nether.wowhead.com/forever/tooltip/npc/<id>` (and `/classic/...`) | Wowhead Forever NPC tooltip JSON, incl. map pins. The normal wowhead.com pages showed a "Human Verification" CAPTCHA after a few loads; I did not solve it. |
| WH-SP | `https://www.wowhead.com/forever/spell=<id>` | Wowhead Forever spell pages (title + "Classes" quick fact, patch 1.60.1.69876). |
| WAGO-F | `https://wago.tools/db2/SkillRaceClassInfo/csv?build=1.60.1.70862` | Forever client table SkillRaceClassInfo. |
| WAGO-C | same, `build=1.15.9.70003` | Classic Era client table, for comparison. |
| WCT | `https://www.warcrafttavern.com/forever/guides/weapon-trainers/` | Warcraft Tavern Forever guide. No publish date on the page; its comment thread was "27 days ago", so about 14 Oct 2026. |
| BW | `https://blizzardwatch.com/2026/10/06/weapon-trainers-wow-classic-forever/` | Blizzard Watch, 6 Oct 2026. |
| TFE | `https://theforeverera.com/en/npcs/<id>/` | cMaNGOS classic-db 1.12 trainer lists (classic-era data), pages updated 7 Oct to 8 Nov 2026. |
| BLZ-R | `https://news.blizzard.com/en-us/article/24310968/...rogue-and-warlock` | Blizzard, 7 Oct 2026. |
| BLZ-S | `https://news.blizzard.com/en-us/article/24302097/...mage-and-shaman` | Blizzard, 7 Oct 2026. |
| FORUM-D | `https://us.forums.blizzard.com/en/wow/t/polearms-for-druid-edit-people-are-saying-we-can-huzaa/2394618` | Player post, 28 Oct 2026 (beta). |
| ZYG-A / ZYG-H / ZYG-C | `E:\World of Warcraft\_forever_\Interface\AddOns\ZygorGuidesViewerForever\Guides-Forever\Leveling\ZygorLeveling{Alliance,Horde,Common}CLASSIC.lua` | Zygor Forever guides (TOC: Interface 16001, Version 1.6). The `*Trial.lua` files hold the same steps. |
| ZYG-T | `...\ZygorGuidesViewerForever\Libs-Forever\LibRover-1.0\data_transit.lua` | Zygor transit data (boats, portals, zeppelins). |
| ZYG-TAXI | `...\ZygorGuidesViewerForever\Libs-Forever\LibTaxi-1.0\data.lua` | Zygor flight masters + flight cost matrix. |
| ZYG-MAP | `...\ZygorGuidesViewerForever\Libs-Forever\LibRover-1.0\data.lua` | Zygor zone name -> uiMapId table. |
| GOSSIP | `E:\World of Warcraft\_forever_\Interface\AddOns\SpokenQuestsAudioShared\generated\npc_gossip_file_lookups.lua` | NPC gossip texts in the Spoken Quests addon (classic flavour text, describes the other weapon masters). |

---

## 1. Every weapon master in Forever

Eight weapon masters, four per faction, all in the six old capitals.
- **MEASURED**: WH-TT shows all eight with the subtitle "Weapon Master" and their city.
- **SECONDARY**: WCT, BW and SenseOS (`senseos.gg/guides/wow-forever/weapon-skills/`, updated 7 Nov 2026) all list the same eight.
- No neutral weapon master (Booty Bay, Gadgetzan, Dalaran, Zephras Isle) was found. **not found**: the trainer section of Wowhead's Zephras Isle guide (`wowhead.com/forever/guide/zephras-isle-zone-overview`, via Exa) lists class and profession trainers but no weapon master. SenseOS says "none has been announced". That is an empty search, not proof.

### 1a. Identity, place, coordinates

uiMapId comes from ZYG-MAP (**MEASURED**, lines: Stormwind 1453 `data.lua:48`, Ironforge 1455 `:43`, Undercity 1458 `:53`, Darnassus 1457 `:62`, Orgrimmar 1454 `:70`, Thunder Bluff 1456 `:77`). The Wowhead area id comes from WH-TT.

| NPC id | Name | Faction (NPC rep faction, WH-TT) | City / spot | uiMapId | Wowhead Forever pins (WH-TT) | Zygor Forever coords (file:line) | WCT coords |
|---|---|---|---|---|---|---|---|
| 11867 | Woo Ping | Alliance (Stormwind) | Stormwind City, Weller's Arsenal, Trade District | 1453 | 63.8,69.0; plus 57.0,57.4 and 57.0,57.6 | 63.88,69.09 (ZYG-A:1121); 63.85,69.08 (ZYG-A:2885, ZYG-C:1983) | 63.8,69.0 |
| 11865 | Buliwyf Stonehand | Alliance (Ironforge) | Ironforge, Timberline Arms, Military Ward | 1455 | 61.4,89.2 / 61.4,89.6 / 61.6,89.2 / 61.6,89.6 | 61.17,89.52 (ZYG-A:1251, :2633, :4437, :6751, :7435; ZYG-C:1955) | shop 62.2,89.6 |
| 13084 | Bixi Wobblebonk | Alliance (Ironforge) | Ironforge, same shop | 1455 | 61.4,87.6 / 61.4,89.0 / 62.0,89.4 / 62.0,89.6 | 62.23,89.62 (ZYG-A:1246, :2639) | 62.2,89.6 |
| 11866 | Ilyenia Moonfire | Alliance (Darnassus) | Darnassus, Warrior's Terrace | 1457 | 57.2,45.4 / 57.4,46.4 / 57.4,46.6 / 57.6,46.4 / 57.6,46.6 | 57.56,46.73 (ZYG-A:4044, :4740) | 57.6,46.7 |
| 11868 | Sayoc | Horde (Orgrimmar) | Orgrimmar, Arms of Legend, Valley of Honor | 1454 | 81.4,19.4 / 81.4,19.6 / 81.6,19.4 | **not found** (Zygor has no Sayoc step) | 81.5,19.6 |
| 2704 | Hanashi | Horde (**Darkspear Trolls**) | Orgrimmar, same shop | 1454 | 81.4,19.4 / 81.4,19.6 / 81.6,19.4 | 81.53,19.63 (ZYG-H:4377, :5250); 81.53,19.61 (ZYG-H:6073, :8203) | 81.5,19.6 |
| 11869 | Ansekhwa | Horde (Thunder Bluff) | Thunder Bluff, Lower Rise | 1456 | 40.4,62.4 / 40.4,62.6 / 40.6,62.6 / 41.0,62.2 / 41.2,61.4 | 40.93,62.73 (ZYG-H:2652, :5861) | 40.9,62.7 |
| 11870 | Archibald | Horde (Undercity) | Undercity, War Quarter, inner ring | 1458 | 9 pins between 56.4-57.8 x, 31.4-33.8 y (incl. 57.0,32.8) | 57.31,32.77 (ZYG-H:982, :4456, :8237) | 57.3,32.8 |

All values in this table are **MEASURED** (2026-11-10).

Wowhead area ids (WH-TT, **MEASURED**): Stormwind 1519, Ironforge 1537, Darnassus 1657, Orgrimmar 1637, Thunder Bluff 1638, Undercity 1497.

**Wowhead vs Zygor:**
- All eight agree within about 0.5 map units. Several NPCs have more than one Wowhead pin because they walk around (Archibald has 9 pins). The Bixi gossip text says she wanders in the shop (GOSSIP:7195).
- Woo Ping's 57.0,57.4 and 57.0,57.6 pins are classic-era. WH-TT `/classic/` shows only those two. WH-TT `/forever/` adds 63.8,69.0. **DERIVED**: Forever uses new bounds for the Stormwind map (uiMapId 1453). Three things back this up. Zygor Forever has a Stormwind boat dock at 22.60,56.13 (ZYG-T:58), and classic Stormwind had no harbour. Zygor puts the Stormwind flight master at 71.29,72.22 (ZYG-TAXI:180). And wowclassicforever.info/trainers says the Forever client's Stormwind map has "other bounds than Classic Era's". **Use 63.8,69.0 in Forever.**
- BW (6 Oct) gives Woo Ping "57, 57". That is the classic-map value and is wrong on the Forever map (**DERIVED**, see above).
- forevermastery.com (cMaNGOS spawn) gives Sayoc 81.7,19.5. That is a classic spawn. The Wowhead Forever pins are 81.4-81.6.

### 1b. What each one teaches (with spell ids)

Spell ids are **MEASURED** from the WH-SP page titles (2026-11-10): One-Handed Axes 196, Two-Handed Axes 197, One-Handed Maces 198, Two-Handed Maces 199, Polearms 200, One-Handed Swords 201, Two-Handed Swords 202, Staves 227, Bows 264, Guns 266, Daggers 1180, Thrown 2567, Crossbows 5011, Fist Weapons 15590. Not taught by anyone: Wands 5009, Shoot 5019, Unarmed 203, Defense 204, Shield 9116, Block 107, Dual Wield 674.

SkillLine ids are **MEASURED** from `ZygorGuidesViewerForever\Code-Forever\Item-DataTables.lua:197-216`: Swords 43, Axes 44, Bows 45, Guns 46, Maces 54, 2H Swords 55, Staves 136, 2H Maces 160, 2H Axes 172, Daggers 173, Thrown 176, Crossbows 226, Wands 228, Polearms 229, Fist 473, Dual Wield 118, Shield 433.

Where the teach lists come from:
- **Wowhead Forever has no "Teaches" tab** on the weapon master pages (MEASURED on the Woo Ping page, 2026-11-10; only "Drops (13)").
- SenseOS says the trainer menus live on the server and are not in the client.
- So no source holds a full Forever list measured in game. The lists below combine WCT (Forever guide), TFE (classic 1.12 cMaNGOS), GOSSIP (in-game flavour text) and the Zygor Forever steps.

| NPC | Teaches (spell id) | WCT (Forever) | TFE classic 1.12 | GOSSIP (classic text) | Zygor Forever steps |
|---|---|---|---|---|---|
| Woo Ping 11867 | 1H Swords 201, 2H Swords 202, Staves 227, Daggers 1180, Crossbows 5011, Polearms 200 | same 6 | same 6 | same (GOSSIP:7195) | 2H Swords, 1H Swords, Staves, Daggers (ZYG-A:1121-1124) |
| Buliwyf 11865 | 1H Axes 196, 2H Axes 197, 1H Maces 198, 2H Maces 199, Guns 266, Fist 15590 | same 6 | same 6 | same (GOSSIP:7200) | 2H Axes, 2H Maces, Guns, 1H Maces (ZYG-A:2633-2634, :7435-7438) |
| Bixi 13084 | Daggers 1180, Thrown 2567, Crossbows 5011 | same 3 | same 3 | same (GOSSIP:7195) | Thrown (ZYG-A:1246) |
| Ilyenia 11866 | Staves 227, Bows 264, Daggers 1180, Thrown 2567, Fist 15590 | same 5 | same 5 | same (GOSSIP:7204) | Bows, Staves, Thrown (ZYG-A:4044-4045, :4740-4741) |
| Sayoc 11868 | 1H Axes 196, 2H Axes 197, Bows 264, Daggers 1180, Thrown 2567, Fist 15590; **Staves 227 disputed** | 7 incl. **Staves** | 6, **no Staves** | 6, **no Staves** (GOSSIP:7213, :7217, :1743) | none |
| Hanashi 2704 | 1H Axes 196, 2H Axes 197, Staves 227, Bows 264, Thrown 2567 | same 5 | same 5 | same (GOSSIP:7209) | Staves, 2H Axes (ZYG-H:4377, :6073) |
| Ansekhwa 11869 | 1H Maces 198, 2H Maces 199, Staves 227, Guns 266 | same 4 | same 4 | same (GOSSIP:1743) | 2H Maces, 1H Maces, Staves, Guns (ZYG-H:5861-5864) |
| Archibald 11870 | 1H Swords 201, 2H Swords 202, Daggers 1180, Crossbows 5011, Polearms 200 | same 5 | same 5 | same (GOSSIP:1743) | Swords, Crossbows, 2H Swords (ZYG-H:982, :8237-8238) |

All source columns are **MEASURED** (2026-11-10). The "Teaches" column for Forever is **DERIVED**: where the sources agree I take that list.

Seen in Forever by players, all dated:
- A Horde druid trained Polearms at level 20 for 1 gold from the Undercity weapon trainer (FORUM-D, 28 Oct 2026, beta). **MEASURED**, player report.
- Swords learned from the Undercity weapon master (beta, 10 Oct 2026) and gun training at Thunder Bluff (29 Oct 2026). **SECONDARY**: these forum posts are cited by forevermastery.com; I did not open them.
- TFE marks Hanashi, Sayoc, Ansekhwa and Archibald as "Seen on the server" (builds 70790 and 70862, 6-8 Nov 2026). That confirms the NPCs exist. It does not confirm their teach lists.

**Conflict 1, Sayoc and Staves.**
- WCT says Sayoc teaches Staves.
- cMaNGOS (TFE), the in-game gossip texts of Hanashi, Ansekhwa and Archibald (GOSSIP:1743, :7213, :7217) and an old Wowhead comment (Allakhazam, via Exa) all say he does not.
- **DERIVED**: tell Horde players "Staves in Orgrimmar = Hanashi". That is safe either way.

**Zygor quirk (MEASURED, ZYG-A:4044):** the step "Train Thrown" at Ilyenia checks `weaponskill("TH_STAFF")` instead of `THROWN`. This is a Zygor bug. Ilyenia does teach Thrown in all the other sources.

---

## 2. Cost and level requirement per skill

| Skill | Level | Cost (base) | Status |
|---|---|---|---|
| All 13 skills except Polearms | 1 | 10 silver | WCT and BW: **MEASURED**, guide claims. TFE: 10 s for every skill, **MEASURED** classic-era. Client: MinLevel 0 on all these rows in WAGO-F, **MEASURED**. Forevermastery cites a player post from 25 Oct 2026 of "10 silver at level 10" (**SECONDARY**). |
| Polearms 200 | 20 | 1 gold | Client: MinLevel 20 on SkillRaceClassInfo row 136 (Warrior/Paladin/Hunter) and row 2483 (Druid) in WAGO-F, **MEASURED**. FORUM-D: 1 g at level 20, **MEASURED** player report. WCT, BW and TFE (classic) say the same. |

Reputation discount:
- WCT says faction discounts apply to these prices (**MEASURED**, guide claim).
- How large the discount is per rep level: **not found**.
- The discount follows the NPC's own faction, which is in table 1a (**DERIVED**). Note that Hanashi belongs to Darkspear Trolls, not Orgrimmar (WH-TT, **MEASURED**). So an Orc may pay a different price at Hanashi than at Sayoc (**DERIVED**, not checked in game).

Class trainer skills, for comparison (Zygor `Data-Forever\Skill_Training.lua`, format {spellID, copper}, **MEASURED**; that the unit is copper is **DERIVED**):
- Dual Wield 674: Hunter level 20, 2100 (line 57).
- Dual Wield 674: Warrior level 20, 4000 (line 253).
- Dual Wield 674: Rogue level 10, 300 (line 1741).

---

## 3. Which class can learn which weapon (Forever), and what changed

Source: WAGO-F, rows where SkillID is the weapon skill (**MEASURED**). Rows with Availability 0 or 1 count as "can learn". Class bits: Warrior 1, Paladin 2, Hunter 4, Rogue 8, Priest 16, Shaman 64, Mage 128, Warlock 256, Druid 1024. The table matches the WCT class table and the WH-SP "Classes" field.

| Weapon | War | Pal | Hun | Rog | Pri | Sha | Mag | Wlk | Dru | Change vs classic |
|---|---|---|---|---|---|---|---|---|---|---|
| 1H Axes 196 | Y | Y | Y | **Y (new)** | | Y | | | | Rogue added |
| 2H Axes 197 | Y | Y | Y | | | **Y (baseline)** | | | | Shaman: was a talent |
| 1H Maces 198 | Y | Y | | Y | Y | Y | | | Y | none |
| 2H Maces 199 | Y | Y | | | | **Y (baseline)** | | | Y | Shaman: was a talent |
| 1H Swords 201 | Y | Y | Y | Y | | | Y | Y | | none |
| 2H Swords 202 | Y | Y | Y | | | | | | | none |
| Polearms 200 (lvl 20) | Y | Y | Y | | | | | | **Y** | Druid: see below |
| Staves 227 | Y | | Y | | Y | Y | Y | Y | Y | none |
| Daggers 1180 | Y | | Y | Y | Y | Y | Y | Y | Y | none (all Hunters now start with it, see section 4) |
| Fist 15590 | Y | | Y | Y | | Y | | | Y | none |
| Bows 264 | Y | | Y | Y | | | | | | none |
| Crossbows 5011 | Y | | Y | Y | | | | | | none |
| Guns 266 | Y | | Y | Y | | | | | | none |
| Thrown 2567 | Y | | Y | Y | | | | | | none |
| Wands 5009 | | | | | Y | | Y | Y | | none, never trained |

Changes, each with its source:

1. **Rogue: one-handed axes.**
   - MEASURED, BLZ-R (7 Oct 2026): "Rogues can now learn to equip one-handed axes."
   - MEASURED, client: SkillID 44 rows 629 and 630 have ClassMask 1 (Warrior) in WAGO-C and ClassMask 9 (Warrior + Rogue) in WAGO-F.
   - MEASURED, WH-SP: spell 196 "Classes" lists Rogue on `/forever/` and not on `/classic/`.
   - Two-handed axes stay closed to rogues (no Rogue row for SkillID 172).
2. **Shaman: 2H Axes and 2H Maces moved to baseline** (no talent needed, but still trained at a weapon master).
   - MEASURED, BLZ-S (7 Oct 2026): "Two-Handed Axes and Maces" is in the Enhancement "Talents Moved to Baseline" list.
   - MEASURED, client: rows 701 (SkillID 172) and 702 (SkillID 160) for Shaman have Availability 2 in WAGO-C and 0 in WAGO-F.
   - **DERIVED**: Availability 2 means "talent", 0 means "trainable", 1 means "known at creation".
3. **Druid: Polearms.**
   - MEASURED, FORUM-D (beta, 28 Oct 2026): a Horde druid trained it at level 20 for 1 g in Undercity.
   - The client row exists in both builds: row 2483 (Druid, MinLevel 20) in WAGO-F and WAGO-C. In WAGO-C the row also has an extra column `Field_1_15_0_52124_007 = 42142`, which the Forever schema does not have.
   - **DERIVED**: that extra field may be the condition that kept it Season-of-Discovery-only in Classic Era. Not verified.
   - **SECONDARY**: wowforevertalents.com and stay-juicy.com say a vanilla druid could not wield a polearm. WCT calls Druid polearms new in Forever.
4. **Hunter: Thrown is not a change.**
   - Row 143 (Hunter, Thrown) exists in both builds (**MEASURED**).
   - WCT's table first missed it and was corrected after a reader comment ("Good catch", about 27 days before 10 Nov) (**MEASURED**).
5. **Shaman: Dual Wield is unclear.**
   - Row 2455 (Shaman, SkillID 118, MinLevel 0) exists in both builds (**MEASURED**).
   - Blizzard does not mention it. Zygor's Shaman class-trainer data has no Dual Wield entry (Skill_Training.lua, SHAMAN block from line 1496; **MEASURED**: no 674 there).
   - Status: **not confirmed**. Do not tell shamans they can dual wield.
6. **New race/class rows (DERIVED; outside weapon masters but they affect the starting tables).**
   - WAGO-F has a Human bit in Hunter rows (Bows row 126: 138 -> 139; Axes row 628: 8 -> 9; Guns row 635: 138 -> 139).
   - It also has Skyborne-only rows (RaceMasks_0 = 0, RaceMasks_1 = 3: rows 2526-2555).
   - That RaceMasks_1 = 3 means the Skyborne is **DERIVED**. Forever ChrRaces has rows 95 "High Order Skyborne" and 96 "Windshaper Skyborne" (WAGO ChrRaces build 1.60.1.70862, **MEASURED**), and these rows match the Skyborne list on forevermastery.com. The exact bit mapping is not verified.

---

## 4. Starting weapon skills per class and race

Source: WAGO-F rows with Availability = 1 (**MEASURED** rows; reading Availability 1 as "known at creation" is **DERIVED**).
- Forevermastery.com says these marks match Classic's starting lists in 327 of 327 cases (**SECONDARY**).
- It fits the WCT statement that Wands are a default skill for Mage, Priest and Warlock (**MEASURED**, guide).
- Everyone also starts with Defense (row 4) and Unarmed (row 6). Warrior, Paladin and Shaman start with Shield (row 246).
- "Classic Era" = the same table in WAGO-C (classic-era fallback). It is identical except where marked.

| Class | All races of the class | Per race |
|---|---|---|
| Warrior | none | Human: 1H Swords, 1H Axes, 1H Maces. Orc: 1H Swords, 1H Axes, 2H Axes. Dwarf: 1H Axes, 2H Axes, 1H Maces. Night Elf: 1H Swords, Daggers, 1H Maces. Undead: 1H Swords, 2H Swords, Daggers. Tauren: 1H Axes, 2H Maces, 1H Maces. Gnome: 1H Swords, Daggers, 1H Maces. Troll: 1H Axes, Daggers, Thrown. Skyborne (Forever only): 1H Swords, 2H Swords, 1H Maces, 2H Maces, Daggers, Bows, Thrown. |
| Paladin | 1H Maces, 2H Maces | none |
| Hunter | **Daggers** (Forever: row 129 ClassMask 264 -> 268. In Classic Era only Night Elf hunters start with Daggers, row 631) | Human (Forever only): Bows. Night Elf: Bows. Orc, Troll: 1H Axes, Bows. Dwarf, Tauren: 1H Axes, Guns. Skyborne: Bows, 1H Swords, 2H Swords. |
| Rogue | Daggers, Thrown | Human, Orc, Dwarf, Troll: **1H Axes** (Forever only: shared row 629 with warriors. Blizzard only says rogues "can learn" axes, so **check in game**). Skyborne: Bows, 1H Swords, 1H Maces. |
| Priest | 1H Maces, Wands | none |
| Shaman | 1H Maces, Staves | Skyborne: Daggers, 2H Maces |
| Mage | Staves, Wands | Skyborne: Daggers |
| Warlock | Daggers, Wands | none |
| Druid | Staves | Night Elf: Daggers. Tauren: 1H Maces. Skyborne: Daggers, 1H Maces, 2H Maces. |

Druid Feral Combat: WCT says druids have it at level 1 (**MEASURED**, guide claim). Its SkillLine id: **not found**.

Which race/class pairs are actually playable in Forever (for example Human hunter, Horde paladin) was not checked. This table only repeats what the rows say.

---

## 5. Nearest trainer per weapon, and routes for the "wrong city" cases

### 5a. Where each weapon is taught, per faction

This is **DERIVED** from the lists in section 1b.

| Weapon | Alliance | Horde |
|---|---|---|
| 1H Swords, 2H Swords | Stormwind (Woo Ping) only | Undercity (Archibald) only |
| Polearms (lvl 20) | Stormwind (Woo Ping) only | Undercity (Archibald) only |
| 1H Axes, 2H Axes | Ironforge (Buliwyf) only | Orgrimmar (Sayoc, Hanashi) |
| 1H Maces, 2H Maces | Ironforge (Buliwyf) only | Thunder Bluff (Ansekhwa) only |
| Guns | Ironforge (Buliwyf) only | Thunder Bluff (Ansekhwa) only |
| Bows | Darnassus (Ilyenia) only | Orgrimmar (Sayoc, Hanashi) |
| Crossbows | Stormwind (Woo Ping), Ironforge (Bixi) | Undercity (Archibald) only |
| Daggers | Stormwind, Ironforge (Bixi), Darnassus | Orgrimmar (Sayoc), Undercity |
| Fist Weapons | Ironforge (Buliwyf), Darnassus | Orgrimmar (Sayoc) only |
| Staves | Stormwind, Darnassus | Orgrimmar (Hanashi; Sayoc disputed), Thunder Bluff |
| Thrown | Ironforge (Bixi), Darnassus | Orgrimmar (Sayoc, Hanashi) |

What each home city does not teach (**DERIVED**):
- Stormwind (Human): axes, maces, guns, bows, fist, thrown.
- Ironforge (Dwarf, Gnome): swords, polearms, staves, bows.
- Darnassus (Night Elf): swords, polearms, axes, maces, guns, crossbows.
- Orgrimmar (Orc, Troll): swords, polearms, maces, guns, crossbows.
- Thunder Bluff (Tauren): swords, polearms, axes, bows, crossbows, daggers, fist, thrown.
- Undercity (Undead): axes, maces, guns, bows, staves, fist, thrown.

### 5b. Routes (Zygor transit and taxi data, MEASURED file:line; the chaining into routes is DERIVED)

Transit lines in ZYG-T (`data_transit.lua`):

| Line | Link | Faction |
|---|---|---|
| :20 | Teldrassil 55.91,89.64 (Rut'theran) <-> Darnassus 30.06,41.44, pink portal | A |
| :58 | Stormwind City 22.60,56.13 <-> Darkshore 30.76,41.00 (Auberdine), boat | A |
| :63 | Teldrassil 54.86,96.79 (Rut'theran) <-> Darkshore 33.19,40.13 (Auberdine), boat | A |
| :73 | Auberdine -> Menethil Harbor (Wetlands 4.65,57.16), one-way boat (:74 is the segment after the load screen) | A |
| :78 | Menethil -> Southshore, one-way | A |
| :83 | Southshore -> Auberdine, one-way | A |
| :68 | Menethil <-> Theramore, boat | A |
| :95 | Stormwind City 60.36,12.47 <-> Ironforge 72.90,50.27, Deeprun Tram (`{cost:500}` is a route weight, **DERIVED**) | A |
| :100 | Zephras Isle 65.82,83.42 (Valanaar) <-> Alterac Mountains 12.52,51.96 (Dalaran), airship | Zygor `fac:A` |
| :30 / :36 | Dalaran (Alterac Mountains 12.04,56.21) <-> Stormwind City 49.87,86.67, Skyborne-only portal (`cond: RaceClassMatch('SKYBORNE')`) | A |
| :108 | Tirisfal Glades 60.70,58.76 (Undercity) <-> Durotar 50.82,13.81 (Orgrimmar), zeppelin | H |
| :111 / :114 | Tirisfal <-> Grom'gol, Durotar <-> Grom'gol, zeppelins | H |
| :117 | Zephras Isle 57.94,80.72 <-> Mulgore 34.29,25.73 (Skywatcher Plateau), airship | Zygor `fac:H` |
| :125 | Booty Bay <-> Ratchet, boat | neutral |
| :128 | Riverglades Powderfuse Port <-> Tanaris Steamwheedle Port, boat | neutral |
| :25 / :47 | Moonglade -> Rut'theran / -> Thunder Bluff, Druid only | |
| :152-170 | Mage teleports (Darnassus 3565, Ironforge 3562, Stormwind 3561, Undercity 3563, Orgrimmar 3567, Thunder Bluff 3566) | |
| :178 | Druid Teleport: Moonglade 18960 | |

Flight masters in ZYG-TAXI (**MEASURED**):

| City | NPC (id) | Coords | Line |
|---|---|---|---|
| Stormwind | Dungar Longdrink (352) | 71.29,72.22 | :180 |
| Ironforge | Gryth Thurden (1573) | 55.50,47.74 | :149 |
| Rut'theran | Vesprystus (3838) | 58.40,94.02 | :75 |
| Auberdine | Caylais Moonfeather (3841) | 36.34,45.58 | :26 |
| Menethil | Shellei Brondir (1571) | 9.49,59.69 | :201 |
| Orgrimmar | Doras (3310) | 45.12,63.89 | :56 |
| Thunder Bluff | Tal (2995) | 46.99,49.83 | :89 |
| Undercity | Michael Garrett (4551) | 63.25,48.56 | :189 |

Flight cost values in ZYG-TAXI (**MEASURED**; that the unit is seconds is **DERIVED**):
- Org -> TB 226 (:434), TB -> Org 210 (:560).
- IF -> SW 211 (:690), SW -> IF 259 (:845).
- IF -> Menethil 129 (:691), Menethil -> IF 89 (:750).
- Auberdine -> Rut'theran 84 (:229), Rut'theran -> Auberdine 85 (:457).

**Wrong-city routes (DERIVED from the lines above):**

| Player | Needs | Route |
|---|---|---|
| Night Elf (Darnassus) | Swords, Polearms, Crossbows (Stormwind) | portal to Rut'theran (T:20) -> boat to Auberdine (T:63) -> boat to Stormwind (T:58) |
| Night Elf | Axes, Maces, Guns (Ironforge) | as above to Stormwind, then the Deeprun Tram (T:95). Or: Auberdine -> Menethil one-way boat (T:73), then fly Menethil -> IF (TAXI:750). |
| Human (Stormwind) | Axes, Maces, Guns, Fist, Thrown (Ironforge) | Deeprun Tram (T:95) or flight SW -> IF (TAXI:845) |
| Human, Dwarf, Gnome | Bows (Darnassus only for Alliance) | Stormwind -> Auberdine boat (T:58) -> Rut'theran boat (T:63) or flight (TAXI:229) -> portal (T:20). From Ironforge, take the tram to Stormwind first (T:95). |
| Dwarf, Gnome (Ironforge) | Swords, Polearms, Staves (Stormwind) | Deeprun Tram (T:95) |
| Skyborne (Alliance) | Stormwind | airship Valanaar -> Dalaran (T:100) -> Skyborne portal to Stormwind (T:30). Then as Human. |
| Orc, Troll (Orgrimmar) | Swords, Polearms, Crossbows (Undercity) | zeppelin Durotar -> Tirisfal (T:108) |
| Orc, Troll | Maces, Guns (Thunder Bluff) | no transit line; flight Org -> TB (TAXI:434) |
| Tauren (Thunder Bluff) | Axes, Bows, Thrown, Fist, Daggers (Orgrimmar) | flight TB -> Org (TAXI:560) |
| Tauren | Swords, Polearms, Crossbows (Undercity) | flight TB -> Org (TAXI:560) -> zeppelin (T:108) |
| Undead (Undercity) | Axes, Bows, Thrown, Fist, Staves (Orgrimmar) | zeppelin Tirisfal -> Durotar (T:108) |
| Undead | Maces, Guns (Thunder Bluff) | zeppelin (T:108) -> flight Org -> TB (TAXI:434) |
| Skyborne (Horde) | Thunder Bluff | airship Zephras Isle -> Mulgore, Skywatcher Plateau, just north of TB (T:117) |

**Conflict 2, skyboat faction.**
- Zygor marks the Dalaran skyboat `fac:A` (T:100) and the Mulgore skyboat `fac:H` (T:117).
- Wowhead's Zephras Isle guide (via Exa, 2026-11-10) says players of both factions can take either skyboat.
- **DERIVED**: Zygor encodes the intended route, not a hard lock.

---

## 6. Skills no weapon master teaches, and quirks

| Item | Fact | Status |
|---|---|---|
| Wands 5009 | Known from the start by Priest, Mage, Warlock. No weapon master teaches it, and other classes cannot learn it. | WCT, **MEASURED** (guide). Client: row 144 only, Availability 1, **MEASURED**. |
| Shoot 5019 | Tooltip: "Attack with an equipped wand", requires level 1. | WH-TT, **MEASURED** |
| Shield 9116 | Warrior, Paladin, Shaman, known at creation. It is not in any weapon master list and not in Zygor's class-trainer data. | WAGO-F row 246 Availability 1, **MEASURED**. "Known at creation" is **DERIVED**. |
| Dual Wield 674 | Taught by the class trainer, not a weapon master: Rogue at 10, Warrior and Hunter at 20. The Shaman row is unconfirmed (section 3 item 5). | WAGO-F rows 131, 132, 2455; Zygor Skill_Training.lua:57, :253, :1741, **MEASURED** |
| Defense 204, Unarmed 203 | Every character has them from the start. | WAGO-F rows 4 and 6; WCT, **MEASURED** |
| Feral Combat | New druid skill, from level 1. | WCT; SenseOS (client), **MEASURED** (guide claims) |
| Fishing poles | Not a weapon skill. Fishing Pole (item 6256) has no skill requirement. Strong Fishing Pole (6365) requires Fishing (10). They are gated by the Fishing profession. | WH-TT item tooltips, **MEASURED** |
| Thrown 2567 | A normal trainable skill (Bixi, Ilyenia, Sayoc, Hanashi). It is a starting skill for all rogues and for Troll and Skyborne warriors. | sections 1b and 4 |
| Crossbows 5011 | Never a starting skill for anyone (row 128, Availability 0 only). | WAGO-F, **MEASURED** |
| Polearms 200 | No class or race starts with it (rows 136 and 2483 have Availability 0). It is the only weapon skill with a level gate (20). | WAGO-F, **MEASURED** |
| Racial weapon skill bonuses | Gone in Forever. | SenseOS, forevermastery (citing Blizzard 26 Oct 2026 notes), **SECONDARY** |

---

## 7. MH data block (facts from the tables above; status in the comments)

```lua
-- Forever weapon masters. Coords = Forever map (uiMapId). Source: WH-TT + Zygor Forever, 2026-11-10.
-- teaches = spell ids. Forever lists = WCT/cMaNGOS/gossip agreement (DERIVED); not menu-checked in game.
FOREVER_WEAPON_MASTERS = {
  [11867] = { name = "Woo Ping",          side = "Alliance", map = 1453, x = 63.8, y = 69.0, teaches = { 201, 202, 227, 1180, 5011, 200 } },
  [11865] = { name = "Buliwyf Stonehand", side = "Alliance", map = 1455, x = 61.2, y = 89.5, teaches = { 196, 197, 198, 199, 266, 15590 } },
  [13084] = { name = "Bixi Wobblebonk",   side = "Alliance", map = 1455, x = 62.2, y = 89.6, teaches = { 1180, 2567, 5011 } },
  [11866] = { name = "Ilyenia Moonfire",  side = "Alliance", map = 1457, x = 57.6, y = 46.7, teaches = { 227, 264, 1180, 2567, 15590 } },
  [11868] = { name = "Sayoc",             side = "Horde",    map = 1454, x = 81.5, y = 19.6, teaches = { 196, 197, 264, 1180, 2567, 15590 }, disputed = { 227 } }, -- WCT says +Staves; coords WCT (no Zygor step)
  [2704]  = { name = "Hanashi",           side = "Horde",    map = 1454, x = 81.5, y = 19.6, teaches = { 196, 197, 227, 264, 2567 } },     -- rep faction: Darkspear Trolls
  [11869] = { name = "Ansekhwa",          side = "Horde",    map = 1456, x = 40.9, y = 62.7, teaches = { 198, 199, 227, 266 } },
  [11870] = { name = "Archibald",         side = "Horde",    map = 1458, x = 57.3, y = 32.8, teaches = { 201, 202, 1180, 5011, 200 } },
}
-- Cost: 10 silver at level 1; Polearms (200) 1 gold at level 20; reputation discount applies (size not found).
```

Coordinates in the block are rounded from Zygor and WCT (both measured, and they agree with the Wowhead pins within 0.5).

---

## Open gaps (to check in game)

1. Sayoc and Staves: WCT says yes, classic data and gossip say no.
2. Reputation discount per rep level: not found.
3. No in-game trainer-menu dump exists for any of the eight. Wowhead Forever has no "Teaches" tab.
4. Do Human, Orc, Dwarf and Troll rogues really start with 1H Axes (client row 629), or only "can learn" them (Blizzard)?
5. Can rogues actually train 1H Axes at Buliwyf, Sayoc and Hanashi? This is derived from client data and the trainer lists, not seen in a dated in-game report.
6. Shaman Dual Wield row: not confirmed.
7. Any weapon master outside the six capitals (Dalaran, Zephras Isle, new zones): none found. An empty search proves nothing.
8. RaceMasks_1 = 3 meaning Skyborne: derived, not verified.
9. Feral Combat SkillLine id: not found.
