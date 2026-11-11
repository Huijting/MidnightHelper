# WoW Forever: spells behind class quests, and Judgement (11 Nov 2026)

mh-research, 11 Nov 2026, read-only. Client: WoW Forever 1.60.1.70888.
Trigger: Rob, 11 Nov, Paladin level 4. He had Judgement but could not use it, thought he first needed a quest line,
and got a quest he called "Continue Training". Question: does this happen for other classes too?

Every claim is marked **MEASURED** (seen in a named, dated source) or **INFERRED** (my reasoning).

## Sources (all read 11 Nov 2026)

| Code | Source |
|---|---|
| DB2 | wago.tools DB2 CSV, Forever build **1.60.1.70888**, via `tools/gamedata.py` (SpellName, SpellEffect, SkillLineAbility, SpellAuraRestrictions, GlobalStrings) |
| WH-tt | Wowhead Forever tooltip JSON (nether.wowhead.com/forever/tooltip), via `gamedata.py` |
| WH-page | Wowhead Forever pages in the browser window, tabs "Taught by", "Reward from" (spell 20271, 768, 355, 71, 7328, 635, 5487, 1066, 1515, 2842, 8071; item 6619). No CAPTCHA. |
| IV | Icy Veins "WoW Forever <Class> Class Quests" guides, all nine classes, each "Last Updated: Nov 4, 2026" |
| WIKI | warcraft.wiki.gg quest pages (edit date given per claim) |
| ZYG | local Zygor Forever guide, `_forever_/Interface/AddOns/ZygorGuidesViewerForever/Guides-Forever/Leveling/ZygorLevelingHordeCLASSIC.lua` |
| SPK | local `_forever_/Interface/AddOns/Spoken_Quests/Data/Compendium.lua` (its header says it was built from the Forever 1.60.1.70450 client tables plus Efficient Games data; it gives quest title, class/race mask and chain order) |

Positive control for "no Reward-from tab on Wowhead": in the same browser run, Cat Form, Defensive Stance,
Redemption, Holy Light, Bear Form, Aquatic Form, Tame Beast, Poisons and Stoneskin Totem all **did** show a "Reward from"
tab. Judgement did not. **MEASURED** (WH-page).

---

## 1. Paladin Judgement in Forever

### 1a. How you get it: from the trainer, level 4. Not a quest, and not automatic.

- Wowhead Forever spell 20271 "Judgement": "Requires level 4", "Training cost: 1", tab **"Taught by (16)"**, and **no
  "Reward from" tab**. **MEASURED** (WH-page).
  - The 16 trainers include Forever-only NPCs, so this list is Forever data and not left over from Classic:
    **Aramis Hammerhand** (244808, Deathknell), **Shari Stilwell** (246152, Brill), Hilda the Breaker (246389),
    Alodan the Hopeful (246344) and Garen Largo (260093). The others are the classic Alliance trainers (Brother
    Sammuel, Azar Stronghammer, Bromos Grummner, Lord Grayson Shadowbreaker and so on). **MEASURED** (WH-page).
  - "Training cost: 1" means 1 silver, which is MH's `c = 100` copper. **INFERRED** (the unit icon was not read).
- DB2 SkillLineAbility 11549: Spell 20271, AcquireMethod **0**. Start spells are AcquireMethod 2, for example Seal of
  Righteousness 20154 and, for Human/Dwarf only, Holy Light 635. So Judgement is **not** a start spell. **MEASURED** (DB2).
- DB2 SpellEffect: the teaching spell **10321 "Judgement"** teaches 20271 **and** 21084 "Seal of Righteousness".
  21084 supersedes the start seal 20154 (SkillLineAbility 11957, SupercedesSpell = 20154). **MEASURED** (DB2).
  Only 21084 has the line "Unleashing this Seal's energy will cause 25 to 26 Holy damage to an enemy"; 20154 does not
  have it. **MEASURED** (WH-tt).
  So learning Judgement also swaps your Seal of Righteousness for the version that Judgement can use. **INFERRED**
  (the MH code says the same at `ForeverTrainer.lua:189`).

So MH's line `ForeverTrainerData.lua:523` `{ l = 4, id = 20271, c = 100 }` (at the trainer, no quest) is **right**.

### 1b. Why it "could not be used": Judgement only works while a Seal is on you

- Tooltip: "Unleash the energy of a Seal spell upon an enemy. Does not consume the Seal. Refer to individual Seals for
  Judgement effect." 10 yd range, 10 sec cooldown. **MEASURED** (WH-tt 20271).
- DB2 SpellAuraRestrictions row 14267: Spell 20271 has **CasterAuraState = 5**. Only two spells in all of Forever need
  that state: Judgement 20271 and Swift Judgement 1310994 (the talent, same "Unleash the energy of a Seal" text).
  **MEASURED** (DB2, filter CasterAuraState=5 → 2 rows).
- If the caster lacks that state, the client shows `SPELL_FAILED_CASTER_AURASTATE` = **"You can't do that yet"**.
  **MEASURED** (DB2 GlobalStrings 11564, Forever 1.60.1.70888).
- Aura state 5 is the "a Seal is active" state. **INFERRED**. The number comes from the classic server enum I know
  (AURA_STATE_JUDGEMENT = 5). It is backed by the fact that only the two Judgement spells use it.

**Most likely explanation of what Rob saw (INFERRED):** he pressed Judgement with no Seal on. The game then says
"You can't do that yet". That reads like "you have not unlocked this yet", and at that same level-4 moment Aramis
Hammerhand offers him new class quests (see 1c). No quest unlocks Judgement.
To check in game: put Seal of Righteousness on (key 3), then press Judgement (key 2) on an enemy within 10 yards.
A second possible cause, also INFERRED and not measured: if his seal is still the old 20154 and not 21084, the Seal of
Righteousness tooltip will lack the "Unleashing this Seal's energy…" line. `/run print(IsPlayerSpell(21084))` should
print `true` after training Judgement.

### 1c. The quest Rob means: "Continue Your Training" (91209). It exists, it is Undead-only, and it teaches nothing.

- **Continue Your Training**, quest **91209**. Forever only (patch 1.60.1). Level 4, requires 4. **Undead** Paladin.
  Starts at **Aramis Hammerhand** (Deathknell, Tirisfal Glades 31.1, 66.4) and ends at **Shari Stilwell** (Brill,
  60.2, 52.7): "Follow the road east out of Deathknell to find the town of Brill. Report to Shari Stilwell to continue
  your training." Rewards: **90 XP and +50 Undercity reputation, no spell, no item.** **MEASURED** (WIKI, edited 7 Nov
  2026; WH-tt 91209; ZYG lines 262 and 459-464; SPK `[91209]` races = 16 (Undead), classes = 2 (Paladin), ender 246152).
- It comes after **Coming to Terms** (91208, level 4, same NPC): find the Frightened Paladin in the hills west of
  Deathknell (27.7, 63.8). She refuses help and attacks, so you kill her. Reward 180 XP + 50 Undercity rep, **no spell**.
  **MEASURED** (WIKI "Coming to Terms (quest)", edited 7 Nov 2026; SPK `prev = 91208` on 91209).
- The Undead Paladin quests before it: **A Difficult Path** (98601, level 1, Shadow Priest Sarvis → Aramis, 40 XP,
  no spell), then **Rediscovering the Light** (90902, level 2), which gives **Holy Light** (spell 635). **MEASURED**
  (WIKI edited 7 and 10 Nov 2026; WH-page 635 "Reward from: Rediscovering the Light 90902").
  The wiki notes say you learn Holy Light the moment you accept the quest. You need it to heal 5 Injured Deathguards.
  **MEASURED** (WIKI "Rediscovering the Light", edited 10 Nov 2026).
- Zygor's order for an Undead Paladin at level ~4: accept Coming to Terms + Continue Your Training + A Light in the
  Darkness at Aramis, then "Train Abilities" at Aramis (ZYG lines 259-268). So **Aramis already trains Judgement in
  Deathknell**, and Shari Stilwell in Brill trains it too. **MEASURED** (ZYG + WH-page trainer list).
- **Is there a similar quest for other Paladins?** None found. SPK lists every Paladin-sorted quest (sort = 141).
  Human and Dwarf get only the classic letters (3101 Consecrated Letter, 3107 Consecrated Rune) and the level-12 Tome of
  Divinity. Nothing named "Continue…" or "Training". **MEASURED** (SPK grep `sort = 141`). An empty search is not proof
  that a quest does not exist.
- Rob has two Forever Paladins, one Undead (Scourge, Horde) and one Human. This report assumes he means the Undead one,
  because 91209 is Undead-only. **MEASURED** that both exist (local Syndicator.lua); **INFERRED** which one he played.

---

## 2. All nine classes: which spells come only from a class quest

How I found them:
1. A scratch script took every first rank that `ForeverTrainerData.lua` names as `req` but does not list itself.
2. Wowhead tooltips sorted out the talents (tooltip says "Talent").
3. What remained, plus the known quest spells, was checked against DB2 teaching spells (SpellEffect Effect 36 =
   "learn spell"), Wowhead "Reward from", and IV/WIKI.

**DB2 cannot tell trainer from quest**: AcquireMethod is 0 for both. So "quest" below always rests on WH-page, IV or WIKI.

### Paladin

| Spell (id) | Level | Quest (id) | Basis |
|---|---|---|---|
| Holy Light r1 (635), Undead only | 2 | Rediscovering the Light (90902), Aramis Hammerhand, Deathknell | MEASURED: WH-page reward-from; WIKI 10 Nov 2026. Human/Dwarf start with it: DB2 SkillLineAbility 6501 AcquireMethod 2, RaceMask 5; the Undead row 59546 has AcquireMethod 0, RaceMask 16 |
| **Redemption r1 (7328)** | 12 | Human: The Tome of Divinity (**1788**, ends at Duthorian Rall, Stormwind). Dwarf: The Tome of Divinity (**1785**, ends at Tiza Battleforge, Ironforge). Undead: A Lesson in Divinity (**94441**, Danitha Morr, Bandarion Keep, Tirisfal 22.0, 44.6), the last of a 7-step chain 94434→94435→94436→94438→94440→94441 | MEASURED: WH-page 7328 "Reward from" = 1785, 1788, 94441, no "Taught by NPC" tab; WIKI (human 9) edited 18 Oct 2025, (dwarf 9) 22 Oct 2025, A Lesson in Divinity (7) edited 10 Nov 2026; IV Paladin. DB2 teaching spell 7329 |
| Judgement (20271) | 4 | **none — trainer** | see section 1 |

Not quest spells: Seal of Command 20375, Holy Shield 20925, Holy Shock 1311606 and Light's Vigil 1310911 are
talents. **MEASURED** (WH-tt "Talent").

### Warrior

| Spell (id) | Level | Quest (id) | Basis |
|---|---|---|---|
| **Defensive Stance (71)** | 10 | Human: Bartleby's Mug (1665). Dwarf/Gnome: Vejrek (1678). Night Elf: Vorlus Vilehoof (1683). Orc/Troll/Tauren: Path of Defense (1498, after Veteran Uzzek 1505). Undead: Ulag the Cleaver (1819, after Speak with Dillinger 1818, Brill). Skyborne: The Skybreaker Bulwark (94003) | MEASURED: WH-page 71 "Reward from" lists exactly these 6 ids; IV Warrior |
| **Taunt (355)**, **Sunder Armor r1 (7386)** | 10 | the same level-10 quest (IV: "Rewards – Defensive Stance, Taunt, and Sunder Armor" for Human, Dwarf/Gnome, NE, Orc/Troll/Tauren, Undead) | MEASURED: IV. DB2 + WH-tt teaching spell 8121 "Path of Defense": "Teaches Defensive Stance, Sunder Armor (Rank 1), and Taunt (Rank 1)". WH-page 355 has **no trainer and no quest tab**, only two books: "Manual: The Path of Defense" (6619) and "Manual of Taunt" (6621). How the quest hands it over (direct, or as that book) is **not measured**. For Skyborne, IV lists only Defensive Stance + Stormforged Protector, so Taunt/Sunder for Skyborne is **not found** |
| **Berserker Stance (2458)**, **Intercept r1 (20252)** | 30 | The Affray (1719), after The Islander (1718), Klannoc Macleod, Fray Island (The Barrens) | MEASURED: WIKI "The Affray" ("You will also learn: Intercept and Berserker Stance", edited 23 Oct 2025, says it remains in Forever); DB2 + WH-tt 8616 "Path of the Berserker": "Teaches Berserker Stance (Rank 1). Teaches Intercept (Rank 1)."; IV Warrior |

Talents, not quests: Bloodthirst 23881, Mortal Strike 12294, Shield Slam 23922. **INFERRED** from their absence in
the trainer list; I did not fetch their tooltips.

### Hunter

| Spell (id) | Level | Quest (id) | Basis |
|---|---|---|---|
| **Tame Beast (1515), Call Pet (883), Dismiss Pet (2641)** | 10 | the 3rd "Taming the Beast": Orc/Troll 6082, Dwarf 6085, Tauren 6088, Night Elf 6102, Skyborne 94013 | MEASURED: WH-page 1515 "Reward from" = those 5; WIKI "Taming the Beast (Orc and Troll 3)" (Tame Beast, Call Pet, Dismiss Pet; edited 30 Sep 2026); DB2 teaching spell 1579 teaches 1515+883+2641 |
| **Beast Training (5149), Feed Pet (6991), Revive Pet (982)** | 10 | Training the Beast: Orc/Troll 6081, Dwarf 6086, Tauren 6089, NE 6103, Skyborne 94050 (Quel'dora Quickgale, Valanaar), **Human 94793** (Isaac Chan, Goldshire) | MEASURED: WIKI "Training the Beast (Orc and Troll)" (Beast Training, Feed Pet, Revive Pet; edited 30 Sep 2026); DB2 teaching spell 5300 teaches 5149+6991+982; SPK chain ids; WH-tt 94050/94793 |
| Human hunter's Tame Beast step | 10 | chain 94792→94863→94864→94793 | **Not found** in WH-page's Tame Beast "Reward from" list (5 entries, no Human). The Human chain exists in SPK (MEASURED); which step gives Tame Beast is not measured |

IV Hunter: one big class quest at 10 ("full suite of pet abilities"). Nothing else confirmed after level 30.
Summon Hawk 1293241, Trueshot Aura 1299346, Counterattack 19306 and Sniper Shot 1310687 are talents. **MEASURED** (WH-tt).

### Rogue

| Spell (id) | Level | Quest (id) | Basis |
|---|---|---|---|
| **Poisons (2842)**, plus Thistle Tea (IV) | 20 | Alliance: Mathias and the Defias (2360) → Klaven's Tower (**2359**). Horde: The Shattered Salute (2460) → Deep Cover (2458) → Mission: Possible But Not Probable (2478) → Hinott's Assistance (2479) → Hinott's Assistance (**2480**) | MEASURED: WH-page 2842 "Reward from" = 2359 and 2480; IV Rogue ("unlock the ability to craft and use Poisons and Thistle Tea"); SPK chain |

WH-page 2842 also has a "Taught by (21)" list. It holds classic trainers plus a Season of Discovery NPC (Boarton
Shadetotem), so that list is inherited data and proves nothing for Forever. **MEASURED** (the list); **INFERRED** (that
it is legacy). The level-10 Rogue quests give an item (Blade of Cunning), no spell. **MEASURED** (IV).

### Priest

Every Priest race gets its two race spells from class quests. You can go straight to the capital NPC too. **MEASURED** (IV Priest).

| Race | Level 10 spell (id), quest | Level 20 spell (id), quest |
|---|---|---|
| Human | Divine Grace (1277370), quest "Divine Grace" (SPK 94774), ends at High Priestess Laurena, Stormwind | Feedback (13896), "Arcane Feedback" (SPK 5676/5677/5678) |
| Dwarf | Desperate Prayer (13908), "Desperate Prayer" (SPK 5634-5640, one per starting NPC), ends at High Priest Rohan, Ironforge | Chastise (1277331), "Chastise" (SPK 5641/5645/5647) |
| Night Elf | Starshards (10797), "Returning Home" (SPK 5628-5633) / "Stars of Elune" (5627), ends at Priestess Alathea, Darnassus | Elune's Grace (2651), "Elune's Grace" (SPK 5672-5675) |
| Gnome | Confounding Flash (1277455), "Confounding Flash" (SPK 94817/94822/94824), ends at High Priestess Mims, Ironforge | Contingency Plan (1277462); quest title **not found** in SPK |
| Troll | Hex of Weakness (9035), "Hex of Weakness" (SPK 5652-5657), ends at Ur'kyo, Orgrimmar | Shadowguard (18137), "Shadowguard" (SPK 5642/5643/5680) |
| Undead | Touch of Weakness (2652), "Touch of Weakness" (SPK 5658-5663), ends at Aelthalyste, Undercity | Dark Sacrifice (1277324), "Dark Sacrifice" (SPK 5644/5646/5679) |

Basis: spell-to-quest per IV (MEASURED). Spell ids, race masks and teaching spells from DB2 (MEASURED): 19338, 1277387,
19350, 19325, 19318, 19331, 19337, 1277663, 2946, 19345, 19357. Quest ids and titles from SPK (MEASURED). That a quest
with a spell's name gives that spell is INFERRED for each SPK id; I did not open each one on Wowhead.
Level 4 "In Favor of…/Garments of…" gives only a robe. **MEASURED** (IV).
Holy Nova 15237, Mind Flay 15407, Penance 402174 and Prayer of Mending 401859 are talents. **INFERRED** (not in the trainer list; tooltips not fetched).

### Shaman

| Spell (id) | Level | Quest (id) | Basis |
|---|---|---|---|
| **Stoneskin Totem r1 (8071)** + Earth Totem item | 4 (Skyborne 3) | Call of Earth: Orc/Troll 1518, Tauren 1521, Dwarf 94375, Skyborne 92468 (requires 3) | MEASURED: WH-page 8071 "Reward from" = those 4; IV ("Ability Learned – Stoneskin Totem"); DB2 teaching spells 8073/8199 |
| **Searing Totem r1 (3599)** + Fire Totem + Totem of Charged Flames | 10 | Call of Fire: last step Horde 1527, Dwarf 94468, Skyborne 97257 | MEASURED: IV ("Ability Learned – Searing Totem"); DB2 teaching spell 8200. The last-step ids come from SPK chain order and are **INFERRED** (WH-page not opened) |
| **Healing Stream Totem r1 (5394)** + Water Totem | 20 | Call of Water: Horde chain …220→63→100→96, Dwarf 94495→…→94505 | MEASURED: IV; DB2 teaching spell 8201. Which step: **INFERRED** |
| Air Totem (item only) | 30 | Call of Air (1531/1532) | MEASURED: IV ("Rewards – Air Totem"), no spell |

### Mage

**No spells behind class quests.** IV Mage says this in so many words (MEASURED). The trainer-list gaps are start spells
(Fireball 133, Frost Armor 168: DB2 AcquireMethod 2, MEASURED) and talents (Ice Lance 1312002, Arcane Blast 400574,
Arcane Wrath 1326079: WH-tt "Talent", MEASURED; Pyroblast 11366, Blast Wave 11113, Ice Barrier 11426: INFERRED talents).

### Warlock

| Spell (id) | Level | Quest | Basis |
|---|---|---|---|
| **Summon Imp (688)** | 1 | Human The Stolen Tome (1598), Gnome Beginnings (1599), Orc/Troll Vile Familiars (1485→1499), Undead Piercing the Veil (1470) | MEASURED: IV; SPK ids |
| **Summon Voidwalker (697)** | 10 | Human/Gnome via Gakin the Darkbinder or Lago Blackwrench (SPK: Surena Caledon 1688 → The Binding 1689); Orc/Troll Gan'rul Bloodeye (1506→1501→1504); Undead Carendin Halgar (1478→1473→1471) | MEASURED: IV. Ids of the "The Binding" steps from SPK; which step teaches is **INFERRED** |
| **Summon Succubus (712)** or **Summon Incubus (713)** | 20 | separate chains (IV); SPK has Heartswood 1738 → The Binding 1739 (A), Love's Gift 1512 → The Binding 1513 (H), What Is Love? 65602 → The Binding 65603 (A), Love Hurts 65601 → Wish You Were Here 65610 (H) | MEASURED: IV and SPK titles/ids; mapping step→demon **INFERRED** |
| **Summon Felhunter (691)** | 30 | Tome of the Cabal chain (SPK 1758/1801-1805), Horde The Binding 1795 | MEASURED: IV; the ids are **INFERRED** |

DB2 teaching spells, all MEASURED: 7763 "Teach Summon Imp", 11520 "Teach Summon Voidwalker", 11519 "Teach Summon
Succubus", 1373 "Teach Summon Felhunter".

### Druid

| Spell (id) | Level | Quest (id) | Basis |
|---|---|---|---|
| **Bear Form (5487) + Growl (6795) + Maul r1 (6807)** | 10 | Body and Heart: NE **6001**, Tauren **6002**; Skyborne **Strength and Mercy (94638)** | MEASURED: WH-page 5487 "Reward from" = 6001, 6002, 94638; DB2 teaching spells 5488/19179 teach exactly 5487+6795+6807; WIKI "Body and Heart" lists all three (classic-era page, edited 2018) |
| **Aquatic Form (1066)** | 16 | Aquatic Form: Alliance **5061**, Horde **31** (after A Lesson to Learn → Trial of the Lake → Trial of the Sea Lion) | MEASURED: WH-page 1066 "Reward from" = 31, 5061; IV; WIKI (classic-era, 2018). Skyborne: SPK masks put Skyborne on 31/5061 (MEASURED); no separate quest found |
| **Cat Form (768) + Prowl (5215) + Claw r1 (1082) + Rip r1 (1079)** | 20 | The Great Cat Spirit chain, reward on **To Thunder Bluff (98362)** / **To Darnassus (98397)** | MEASURED: WH-page 768 "Reward from" = 98362, 98397 (level 20); DB2 teaching spell 1309050 teaches 768+5215+1082+1079; IV. Skyborne: "The Great Windborne Cat Spirit" (98341) exists in SPK, but WH lists no Skyborne reward quest for Cat Form → **not found** |

Teleport: Moonglade (18960): DB2 has it with AcquireMethod 0 (MEASURED). It is **not** in MH's trainer list, and IV
assumes you already have it at 10. Where Forever teaches it is **not measured**.

---

## 3. MH compared with the game

### 3a. MH is right (no change needed)
- `ForeverTrainerData.lua:523` Judgement at the trainer, level 4, 1 silver. MEASURED (section 1a).
- `ForeverHowToPlay.lua:78` Undead Holy Light from "Rediscovering the Light" at 2. MEASURED.
- Warrior `:164-165`, `:177` (Defensive Stance + Sunder + Taunt from the level-10 quest; Berserker Stance from "The
  Affray" at 30), Druid `:51`, `:57` (Bear Form, Cat Form with Claw/Rip/Prowl from quests), Rogue `:225`, `:237`
  (Poisons from a quest ~20), Shaman `:285`, `:295`, `:300`, `:308`, `:315` (Totem items and Stoneskin/Searing/Healing
  Stream from quests), Warlock `:325-327` (demons from class quests, Imp quest names per race), Hunter `:141` (pet
  quests at 10). All match IV + WH-page. MEASURED.
- `FTRAIN_FOOTER` ("Talents, books and quest spells are not in this list"): correct for every case above.

### 3b. Places where MH does not say a quest is needed (gaps)
MH nowhere literally says "learn this at the trainer" for a quest spell. The gaps are lines that give a spell a level
and a key with no word about a quest, so a new player will look for it at the trainer:

1. **Redemption** — `ForeverHowToPlay.lua:92` "12: Redemption on F3" (nlNL `ForeverHowToPlay_nlNL.lua:74`). The game:
   rank 1 only from the level-12 quest chain (1788 Human, 1785 Dwarf, 94441 Undead); Wowhead has no trainer for 7328.
   MEASURED.
2. **Aquatic Form** — `ForeverHowToPlay.lua:56` "16: Aquatic Form on R while you swim" (nlNL `:38`). The game: quest
   5061/31 at 16. MEASURED.
3. **Priest race spells** — `ForeverHowToPlay.lua:245-251`, `:263`, `:269` ("Every Priest race has two Priest spells
   of its own: one at level 10 and one at level 20"). No word that both come from class quests. MEASURED (IV).
4. **Judgement** — `ForeverHowToPlay.lua:80` (nlNL `:62`) is right about the trainer. It does not say that Judgement
   only works while a Seal is on, or that otherwise the game says "You can't do that yet". That missing sentence is
   most likely Rob's whole problem. MEASURED (the facts); INFERRED (that this is what Rob hit).
5. **The trainer window's "Needs something else first" list** (`ForeverTrainer.lua:186-205`, `FTRAIN_NEEDS_FMT` =
   "- %s: first %s"). When rank 1 came from a quest, the window says e.g. "Redemption: first Redemption" (rank 2 at
   24), "Sunder Armor: first Sunder Armor" (22), "Maul: first Maul" (18), "Stoneskin Totem: first Stoneskin Totem"
   (14), "Searing Totem…" (20), "Healing Stream Totem…" (30), "Intercept…" (42), "Prowl…" (40), "Rip…" (28),
   "Desperate Prayer…" (18) and so on. It never says the first rank is a quest reward. INFERRED (read from the code;
   not seen in game).

### 3c. Side finding: a wrong `req` in the trainer data
- `ForeverTrainerData.lua:86`: `{ l = 28, id = 3029, c = 4500, n = "Claw", req = { 16942 } }`. DB2 SkillLineAbility
  says Claw 3029 **supersedes 1082** (Claw rank 1, from the Cat Form quest). **16942 is "Sharpened Claws", a talent**
  (WH-tt). MEASURED.
  Result: a druid without that talent would see "Claw: first Sharpened Claws" and never be offered Claw rank 2.
  INFERRED (code reading, `ForeverTrainer.lua:187-205`). The fix would be `req = { 1082 }`. Not changed: this job is
  read-only.

## Not found / not measured (honest gaps)
- How the Warrior quest hands over Taunt and Sunder Armor: directly, or as the book "Manual: The Path of Defense" that
  you have to use. And whether Skyborne Warriors get Taunt/Sunder from their quest.
- Which step of the Human Hunter chain gives Tame Beast. Skyborne Cat Form's reward quest. The Gnome "Contingency Plan"
  quest id. The exact rewarding step for Call of Fire/Water, the Warlock demon chains and the Priest quests (titles and
  ids are measured, the step is inferred).
- Where Forever teaches Teleport: Moonglade.
- Everything above level 30 that IV says is still unconfirmed (mounts, level-50/60 quests).
