# WoW: Forever — best macros for Warrior, Rogue, Hunter, Paladin, Shaman

Research date: 2026-11-09. Client in scope: WoW: Forever, Interface 16001, build 1.60.1.x.
Labels: **GEMETEN** = seen in a named, dated source (source tag in brackets). **AFGELEID** = my reasoning.
**[CE]** = relies on a Classic Era rule that no Forever source confirms yet.

Important honesty note: **no macro below has been tested in the live Forever client by me or by any source.**
Both build-checked macro sites say so outright: foreverdb.net marks every macro "Not yet tested in game",
classicwowforever.com says "Not tested in the live Forever client yet". Spell *names* were checked against
build 1.60.1.70862 by those two sites. Character counts were measured with a script (see bottom).

---

## 0. Sources (all read 2026-11-09)

| Tag | Source | Date |
|---|---|---|
| B1 | Blizzard, "Create the Hero You Want to Be in WoW: Forever" — https://worldofwarcraft.blizzard.com/en-us/news/24304075 | 2026-09-22 |
| B2 | Blizzard, "Class Deep Dives — Hunter and Druid" — https://worldofwarcraft.blizzard.com/en-us/news/24301515 | 2026-09-30 |
| B3 | Blizzard, "Class Deep Dives — Priest and Warrior" — https://worldofwarcraft.blizzard.com/en-us/news/24301514 | 2026-09-30 |
| B4 | Blizzard, "Class Deep Dives — Mage and Shaman" — https://worldofwarcraft.blizzard.com/en-us/news/24302097 | 2026-10-07 |
| B5 | Blizzard, "Class Deep Dives — Rogue and Warlock" — https://worldofwarcraft.blizzard.com/en-us/news/24310968 | 2026-10-07 |
| B6 | Blizzard, "Class Deep Dives — Paladin" — https://worldofwarcraft.blizzard.com/en-us/news/24302099 | 2026-10-15 |
| B7 | Blizzard forum, Kaivax, "WoW Forever Beta Development Notes – Updated November 2" — https://us.forums.blizzard.com/en/wow/t/wow-forever-beta-development-notes-%E2%80%93-updated-november-2/2360696 | posts 25 Sep, 2 Oct, 8 Oct, 16 Oct, 26/27 Oct, 3 Nov, 4 Nov 2026 |
| B8 | Blizzard, "WoW: Forever Hotfixes – November 5, 2026" — https://news.blizzard.com/en-us/article/24315281 | entries 5 + 6 Nov 2026 |
| B9 | Blizzard, "WoW: Forever—What's New and What Feels Familiar" — https://worldofwarcraft.blizzard.com/en-gb/news/24315821 | 2026-11-03 |
| F1 | foreverdb.net/macros/{warrior,rogue,hunter,paladin,shaman} — "build 1.60.1.70862, extracted 2026-11-09" | 2026-11-09 |
| F2 | classicwowforever.com/macros/{class}/ (CC BY 4.0, names checked vs build 1.60.1.70862) | updated 2026-11-03 |
| F3 | mmonster.co/wow-forever/guides/macros | updated 2026-11-03 |
| F4 | rankedboost.com/world-of-warcraft/forever/macros/hunter/ | updated 2026-11-07 |
| F5 | kami-labs.fr/en/wow-forever/macros-wow-forever-9-classes/ | 2026-10-01 |
| F6 | Wowhead Forever user guide (Hazedesunna) — https://www.wowhead.com/forever/guide/beginners-guide-to-writing-macros-in-wow-forever-34950 (+ comment by "Adsun", shown "2 days ago" ≈ 7 Nov) | updated 2026-10-20 |
| F7 | Blizzard forum bug report "Forever: Warlock Cast Sequence Bug" — https://us.forums.blizzard.com/en/wow/t/forever-warlock-cast-sequence-bug/2354983 (no Blizzard reply) | 2026-09-19 |
| F8 | CurseForge ZMacros (Forever 1.60.1, file 1.0.3) — https://www.curseforge.com/wow/addons/zmacros | 2026-11-06 |
| F9 | Warcraft Tavern Forever hunter pets guide — https://www.warcrafttavern.com/forever/guides/hunter-pets/ | undated (©2026) |
| C1 | Wowhead Classic Warrior DPS macros (2025-03-19) and Tank macros (2024-11-21) | Classic Era baseline |
| C2 | Wowhead Classic Hunter macros, Sh3rro | 2025-03-20 |
| C3 | Wowhead Classic Rogue macros, Rokman | 2024-11-21 |
| C4 | Wowhead Classic Holy Paladin macros | 2024-11-21 |
| C5 | Wowhead Classic Shaman healer macros | 2024-11-21 |
| L1 | LOCAL candidate: `E:\World of Warcraft\_forever_\Interface\AddOns\ZygorGuidesViewerForever\Data-Forever\Skill_Training.lua` (Zygor Forever, TOC Interface 16001, Version 1.6) — trainer levels per class | file is **older than 16 Oct/3 Nov notes** (still has Righteous Fury at 16, Seal of Fury R3 at 25, Blessing of Salvation/Light, no Shank) |
| L2 | LOCAL candidate: `...\AddOns\HandyNotes_ClassTrainers\Data.lua` | — |
| L3 | LOCAL candidate: `...\AddOns\CharacterForever\Media\Race-*.tga` race list | — |

C1–C5 are older than 18 Aug 2026; they are used only as "what experienced Classic players recommend", never as Forever proof.

---

## 1. Factions: who can play Paladin and Shaman?

- **GEMETEN [B1, 22 Sep 2026]** — Blizzard's race/class tables:
  - **Paladin:** Alliance = Human, Dwarf. Horde = **Undead** (new).
  - **Shaman:** Horde = Orc, Tauren, Troll, **Skyborne (Windshaper, Horde-aligned)**. Alliance = **Dwarf** (new).
  - Alliance-aligned Skyborne can be Mage, not Shaman. No Blood Elf, no Draenei, no Tauren Paladin.
  - So **both factions can play both Paladin and Shaman.**
- Candidates only (not proof): L2 lists Horde paladin trainers (e.g. "Aramis Hammerhand", "Hilda the Breaker") and Alliance shaman trainers (e.g. "Ingrid Dunwald", "Teo Hammerstorm"); L3 race art = Dwarf, Gnome, Human, NightElf, Orc, Scourge, Skyborne, Tauren, Troll.
- AFGELEID: macros are the same for both factions (spell names don't differ by race). Racial spells differ, not covered here.

---

## 2. What is different about macros in Forever (vs Classic Era)

| # | Claim | Label |
|---|---|---|
| 1 | Learning a new spell **no longer auto-adds it to your action bars** (3 Nov notes). | GEMETEN [B7, 3 Nov] |
| 2 | A bar slot does **not** update itself when you buy a new rank; a `/cast` line without a rank always casts the highest rank you know. | GEMETEN [F5, 1 Oct; F3, 3 Nov; F6, 20 Oct] — community claim, not Blizzard |
| 3 | **Focus target exists in Forever** (Classic Era has none). Blizzard fixed "using a focus macro to cast Light's Vigil" (16 Oct) and added gamepad "Focus Target" support (3 Nov). So `[@focus]` macros are a real Forever option. | GEMETEN [B7, 16 Oct + 3 Nov; F1 "Classic Era hides the focus target"] |
| 4 | Several weapons can again be swapped **within one GCD**, e.g. 2-hander → sword and shield via macro (8 Oct). | GEMETEN [B7, 8 Oct] |
| 5 | **Scrolls now trigger the GCD** (16 Oct) → a macro can't read a scroll and cast in one press. | GEMETEN [B7, 16 Oct; F3] |
| 6 | **Hunter Auto Shot needs 0.5 s standing still** before it fires, "matching early versions of WoW"; Auto Shot **still fires while you cast Aimed Shot or Sniper Shot** (16 Oct). | GEMETEN [B7, 16 Oct] |
| 7 | New option "Auto Attack/Auto Shot": Hunters switch automatically between melee and Auto Shot (16 Oct). | GEMETEN [B7, 16 Oct] |
| 8 | Built-in **Swing Timer bar** exists (4 Nov fix mentions it). | GEMETEN [B7, 4 Nov] |
| 9 | `/castsequence` exists; one beta report: a sequence **stalls** when a Rank 2+ Curse of Weakness is the first spell; reordering fixed it. No Blizzard reply. | GEMETEN [F7, 19 Sep] |
| 10 | 255 characters per macro (same as Classic). | GEMETEN [F3] |
| 11 | Macros can't be created or placed in combat; sending macro text to others is blocked in boss encounters. | GEMETEN [F8] — addon page, not Blizzard |
| 12 | Whether Retail's 2026 macro limits (chat/markers) apply to Forever: not confirmed by Blizzard. | GEMETEN [F3 says "not confirmed"] |
| 13 | Stance numbers (`[stance:N]`) may follow the order you **learned** the stances (a player who skipped the Defensive Stance quest had Berserker as 2). | GEMETEN [F6 comment, ≈7 Nov] — single player claim, unverified |
| 14 | Spell names must be in the client's language. | GEMETEN [F5] |

AFGELEID tips from the table: (a) use rankless `/cast` macros while levelling — they fix the "old rank on the bar" problem from #1/#2; (b) `[@focus]` interrupts/CC are now worth teaching, which Classic Era players are not used to; (c) after the stance quests, check that Battle=1, Defensive=2, Berserker=3 on your stance bar before trusting warrior macros.

---

## 3. WARRIOR

Forever changes that matter for macros:
- **Tactical Mastery is baseline at level 14**: keep 10 Rage when changing stance. — GEMETEN [B3, 30 Sep; L1 lists it at 14]
- **Victory Rush learned at level 20**: 30 s cooldown, heals 10% max health, active 20 s after killing a non-trivial enemy. — GEMETEN [B3]
- **Thunder Clap usable in Defensive Stance.** — GEMETEN [B3]
- **Vanguard** (Prot 16-point talent): Charge usable in Defensive Stance. — GEMETEN [B3]
- Defensive Stance threat bonus 80% (was 30%). — GEMETEN [B7, 3 Nov]
- Stance swaps don't use the GCD, so swap + ability can share one press; if only the swap fires, press again. — GEMETEN [F2] (is also Classic behaviour)

**W1 — Charge out of combat, Intercept in combat (stance-aware)**
```
#showtooltip
/startattack
/cast [nocombat,stance:1] Charge; [combat,stance:3] Intercept; [nocombat] Battle Stance; Berserker Stance
```
One key to close the gap: Charge when out of combat, Intercept in combat; swaps stance first if needed.
Level: Charge 4, Intercept + Berserker Stance 30 (before 30 only the Charge half works). GEMETEN [F1, F2, L1].
[CE] Charge is out-of-combat only (Classic rule, stated by F2; no Blizzard Forever text). With Vanguard you may drop the stance part for Charge.

**W2 — Overpower from any stance**
```
#showtooltip Overpower
/startattack
/cast [stance:1] Overpower; Battle Stance
```
Hits Overpower in Battle Stance, otherwise swaps to Battle Stance first (press again). Thanks to baseline Tactical Mastery you keep 10 Rage.
Level 12. GEMETEN [F1, L1]. Note: Overpower lights up after a dodge, and in Forever also via the Arms talent Bloodthrill on Rend targets — GEMETEN [B3, B7 3 Nov].

**W3 — Execute, out of Defensive Stance if needed**
```
#showtooltip Execute
/startattack
/cast [stance:2] Battle Stance; Execute
```
Execute on a target under 20% health; from Defensive Stance the first press swaps to Battle Stance.
Level 24. GEMETEN [F1, F2, L1].

**W4 — Victory Rush after a kill (Forever-new)**
```
#showtooltip Victory Rush
/startattack
/cast Victory Rush
```
Free heal + damage after each kill; great for solo levelling.
Level 20. GEMETEN [B3, F2, L1].

**W5 — Interrupt: Shield Bash, or Pummel in Berserker Stance, focus first**
```
#showtooltip
/cast [stance:3,@focus,harm,nodead][stance:3] Pummel; [@focus,harm,nodead][] Shield Bash
```
Interrupts your focus (if it is a living enemy), else your target. Shield Bash needs a shield.
Level: Shield Bash 12, Pummel 38. GEMETEN [F1 macro, L1 levels]. Focus = Forever-only option (see §2 #3).

**W6 — Tank taunt on mouseover; Shift = Mocking Blow**
```
#showtooltip
/cast [mod:shift,stance:1,@mouseover,harm,nodead][mod:shift,stance:1] Mocking Blow; [mod:shift] Battle Stance; [stance:2,@mouseover,harm,nodead][stance:2] Taunt; Defensive Stance
```
Taunts the enemy under your mouse (or your target) without losing your target; Shift for Mocking Blow; swaps stance if needed.
Level: Taunt with Defensive Stance (10), Mocking Blow 16. GEMETEN [F1; L1 for Mocking Blow 16].

**W7 — Sunder Armor, grabbing a target first**
```
#showtooltip Sunder Armor
/targetenemy [noharm][dead]
/startattack
/cast Sunder Armor
```
Targets the nearest enemy if you have none, starts attacking, Sunders. Sunder threat scales with Attack Power in Forever.
Level 10. GEMETEN [F1; B3 for AP threat].

**W8 — Heroic Strike, Shift = Cleave (Rage dump)**
```
#showtooltip
/startattack
/cast [mod:shift] Cleave; Heroic Strike
```
Queues Heroic Strike on your next swing, Cleave with Shift; keeps auto-attack running after target swaps.
Level: Heroic Strike 1, Cleave 20. GEMETEN [F1, F2; C1 for the /startattack advice].

Also recommended by sources (not in the top 8): Berserker Rage from any stance (lvl 30) [F1, F2]; weapon swap 1H+shield ↔ 2H, now working again inside one GCD [F1, B7 8 Oct]; Bloodrage + Battle Shout [F1]; Death Wish + trinkets [F1]; cancel Blessing of Protection inside attack macros `/cancelaura Blessing of Protection` [C1, Classic].

---

## 4. ROGUE

Forever changes that matter for macros:
- **Sap no longer breaks Stealth.** — GEMETEN [B5, 7 Oct]. Sap's tooltip no longer says "Must be stealthed", but client data still lists Stealth as a requirement — GEMETEN [F1]; untested → treat Sap as "from Stealth" [CE].
- **New: Shank** (level 24, 5 Energy, 10 s CD, off-hand strike, generates 15 Energy, can't miss; rank 2 at 44). — GEMETEN [B7, 3 Nov]. Hotfix 6 Nov: tooltip ranks/combo points. — GEMETEN [B8]
- Distract also lowers enemy stealth detection for 10 s. — GEMETEN [B5]
- Poisons: more charges, and can sit on a weapon together with a sharpening/weight stone. — GEMETEN [B5]

**R1 — Stealth that never switches itself off**
```
#showtooltip Stealth
/cast !Stealth
```
Spamming the key never cancels Stealth by accident.
Level 1. GEMETEN [F1; C3 Classic].

**R2 — One opener key (Stealth-aware)**
```
#showtooltip
/cast [stealth,mod:shift] Cheap Shot; [stealth,mod:ctrl] Garrote; [stealth] Ambush; Sinister Strike
/startattack [nostealth]
```
From Stealth: Ambush (Shift = Cheap Shot, Ctrl = Garrote). Out of Stealth: Sinister Strike + auto-attack.
Level: Garrote 14, Ambush 18 (needs a dagger, from behind), Cheap Shot 26. GEMETEN [F1 macro; L1 levels].
AFGELEID: Combat (sword) rogues should swap Ambush and Cheap Shot so the no-modifier press is Cheap Shot.

**R3 — Pick Pocket, then open**
```
#showtooltip
/cast [stealth] Pick Pocket
/cast [stealth,mod:shift] Garrote; [stealth] Cheap Shot; Sinister Strike
```
Robs the target and opens in the same press. Free gold while levelling.
Level: Pick Pocket 4; opener as R2. GEMETEN [F1, F2 — both list Pick-Pocket-then-opener macros]. F1 notes you must stand still a moment before pressing.

**R4 — Sap on mouseover or focus, Stealth first**
```
#showtooltip Sap
/cast [nostealth] !Stealth; [@mouseover,harm,nodead][@focus,harm,nodead][] Sap
```
First press stealths, next press Saps the mob under your mouse / your focus / your target — your main target stays.
Level 10. GEMETEN [F1]. Forever: Sap does not break Stealth [B5], and Quick Getaway talent allows one extra Sap target [B7, 3 Nov].

**R5 — Kick: focus, else mouseover, else target**
```
#showtooltip Kick
/cast [@focus,harm,nodead][@mouseover,harm,nodead][] Kick
```
Dungeon interrupt that doesn't need a target swap.
Level 12. GEMETEN [F1; F2 has the mouseover version].

**R6 — Safe Vanish (Stealth out of combat)**
```
#showtooltip [nocombat] Stealth; Vanish
/stopattack [combat]
/cast [nocombat] !Stealth; Vanish
```
Out of combat: Stealth. In combat: stops your swing first so a pending hit can't break the Vanish.
Level 22. GEMETEN [F2; F1 has the plain /stopattack + Vanish version].

**R7 — Shank with auto-attack (Forever-new)**
```
#showtooltip Shank
/startattack
/cast Shank
```
Energy-positive off-hand stab on a 10 s cooldown; press on cooldown.
Level 24. GEMETEN [B7, 3 Nov; F2].

**R8 — Poison on main hand, Shift = off hand**
```
#showtooltip
/use [nomod] Instant Poison; [mod:shift] Crippling Poison
/use [nomod] 16; [mod:shift] 17
```
Applies poison from your bags to the right weapon. Replace the names with the rank you carry (e.g. "Instant Poison II").
Level: poisons 20 (Instant 20, Crippling 20, Deadly 30). GEMETEN [F1 macro; F2/L1 levels].
[CE] F2's version adds `/click StaticPopup1Button1` to confirm a replace popup; not verified in Forever.

Also recommended (not in top 8): Evasion + Sprint panic key (lvl 8/10; F2 says neither uses the GCD) [F2]; Blind focus with Shift (34) [F1]; Distract at cursor `/cast [@cursor] Distract` (22) [F1]; Cold Blood + Eviscerate [F1]; Gouge→Backstab castsequence [F1].

---

## 5. HUNTER

Forever changes that matter for macros:
- **Auto Shot needs 0.5 s standing still; it keeps firing while you cast Aimed/Sniper Shot.** — GEMETEN [B7, 16 Oct]. AFGELEID: the Classic Era "don't clip your Auto Shot" macros are not needed; just don't move.
- Option "Auto Attack/Auto Shot" auto-switches melee/ranged. — GEMETEN [B7, 16 Oct]
- **Aimed Shot baseline at 20**; Arcane Shot no longer shares its cooldown; Multi-Shot shares a cooldown with Aimed Shot. — GEMETEN [B2, 30 Sep]
- **Traps usable in combat**; all traps share one 30 s cooldown (3 Nov). — GEMETEN [B2; B7 3 Nov]. AFGELEID: the Classic "Feign Death → trap" macro is no longer required to place traps.
- Hunter's Mark can no longer be stacked using different ranks. — GEMETEN [B7, 3 Nov]
- Pet Happiness and Feed Pet still exist (beta note: happiness bugged). — GEMETEN [F9, undated]. (A search snippet of a CurseForge "Feed Pet Forever" page said feeding needs a real click; I did not open that page — not counted as measured.)
- Every pet family has its own unique ability (e.g. Boar Charge, Wolf Furious Howl, Crab Pinch). — GEMETEN [B2]

**H1 — Pull: send pet + Hunter's Mark**
```
#showtooltip Hunter's Mark
/petattack
/cast Hunter's Mark
```
Marks the target and sends the pet in one press.
Level 6 (pet from ~10). GEMETEN [F1, F2; C2 Classic].

**H2 — Auto Shot that never toggles off, pet attacks too**
```
#showtooltip Auto Shot
/petattack
/cast !Auto Shot
```
Starts shooting (spamming won't stop it) and sends the pet. Stand still 0.5 s in Forever.
Level 1. GEMETEN [F1; C2 Classic].

**H3 — Aimed Shot, Shift = Multi-Shot**
```
#showtooltip
/cast [mod:shift] Multi-Shot; Aimed Shot
```
In Forever these share a cooldown anyway, so one key fits: single target vs packs.
Level: Multi-Shot 18, Aimed Shot 20 (baseline in Forever). GEMETEN [F1 macro; B2; L1].

**H4 — Melee weave: Raptor Strike + Mongoose Bite**
```
#showtooltip Raptor Strike
/startattack
/cast Mongoose Bite
/cast Raptor Strike
```
When a mob reaches you: Mongoose Bite if it's lit (after a dodge), otherwise queue Raptor Strike.
Level: Raptor Strike 1, Mongoose Bite 16. GEMETEN [F1; F4; C2 Classic].

**H5 — Call / Mend / Revive pet on one key**
```
#showtooltip
/cast [@pet,dead][mod:shift] Revive Pet; [nopet] Call Pet; Mend Pet
```
No pet → Call Pet; dead pet or Shift → Revive Pet; otherwise Mend Pet.
Level: Call/Revive Pet from the level-10 taming quests, Mend Pet 12. GEMETEN [F2 macro; F4 levels; F9 quests].
[CE] Whether `[@pet,dead]` sees a dead pet in this client is untested.

**H6 — Feed Pet out of combat**
```
#showtooltip Feed Pet
/cast [pet,nocombat] Feed Pet
/use [pet,nocombat] Chunk of Boar Meat
```
Keeps your pet happy; replace the food name with what your pet eats.
Level: after the last taming quest. GEMETEN [F2 macro; F9].

**H7 — Aspects on one key**
```
#showtooltip
/cast [mod:shift] !Aspect of the Cheetah; [mod:ctrl] !Aspect of the Monkey; !Aspect of the Hawk
```
Hawk by default, Cheetah with Shift (travel), Monkey with Ctrl (melee defence); `!` stops it toggling off.
Level: Monkey 4, Hawk 10, Cheetah 20. GEMETEN [F1 macro; F4/L1 levels].

**H8 — Clean Feign Death**
```
#showtooltip Feign Death
/stopattack
/petfollow
/cast Feign Death
```
Stops attacking, calls the pet back, drops threat. F1 reads the Forever tooltip as: Feign Death kills you after 6 minutes if not cancelled.
Level 30. GEMETEN [F1, F2, F4].

Also recommended (not in top 8): pet attack/follow/stay on one key with mouseover [F1]; Shift = recall pet [F2]; Scatter Shot + `/petpassive` (Classic CC) [C2]; Tranquilizing Shot on focus (60) [F4]; Flare at cursor (32) [F1, C2]; tracking with modifiers (24) [F2].

---

## 6. PALADIN

Forever changes that matter for macros (big ones):
- **Judgement no longer consumes your Seal.** — GEMETEN [B6, 15 Oct; F1; F2]
- **Seal twisting is gone as a baseline trick**; it was moved into a Ret capstone (Twist of Light) — GEMETEN [B6]; then **Twist of Light was removed** and the new 31st Ret talent **Unsealed Wrath** stores copies of your active Seal (3 stacks) that pop when you land a hit with a different Seal — GEMETEN [B7, 3 Nov]. AFGELEID: all Classic "seal twist" macros are obsolete.
- **Holy Strike** new at level 6 (instant, weapon-based Holy damage). — GEMETEN [B6; L1]
- **Seal of Fury** new tank Seal at level 10: its Judgement **taunts** at 10 yards. — GEMETEN [B6; L1]
- **Righteous Fury at level 10** (was 16). — GEMETEN [B7, 3 Nov]
- **Consecration baseline at 20**; Lay on Hands cooldown 20 min. — GEMETEN [B6]
- **Blessing of Kings baseline (20)**; **Salvation, Mass Salvation and Blessing of Light removed**. — GEMETEN [Blizzard "Deep Dive Panel Recap", https://news.blizzard.com/en-us/article/24303313, no date on page: "Blessing of Kings ... become baseline"; F2 "Kings is baseline, learned at level 20"; B7 3 Nov for the removals]
- Paladins still have **no interrupt**. — GEMETEN [same Panel Recap, undated]
- Light's Vigil (31-pt Holy talent) is now friendly-only, and Blizzard fixed it for focus macros. — GEMETEN [B7, 16 Oct + 3 Nov]

**P1 — Holy Strike with auto-attack (Forever-new)**
```
#showtooltip Holy Strike
/startattack
/cast Holy Strike
```
Your levelling bread-and-butter melee button.
Level 6. GEMETEN [B6, F1, F2].

**P2 — Judgement + Holy Strike in one press**
```
#showtooltip Holy Strike
/startattack
/cast [nomod:shift] Judgement
/cast Holy Strike
```
Judges when ready, then Holy Strike; Shift skips the Judgement. No re-seal needed in Forever.
Level: Judgement 4, Holy Strike 6. GEMETEN [F1].
[CE] Works only if Judgement is still off the GCD (Classic rule). Not confirmed for Forever.

**P3 — Seal by gear: shield = Seal of Fury, else Seal of Righteousness**
```
#showtooltip
/cast [worn:Shields] Seal of Fury; Seal of Righteousness
```
One seal key for tank and solo: picks the tank seal when you wear a shield.
Level: Seal of Righteousness 1, Seal of Fury 10. GEMETEN [F1 uses `[equipped:Shields]`; `worn` is the same conditional — AFGELEID].

**P4 — Tank taunt: Judgement on mouseover (with Seal of Fury)**
```
#showtooltip Judgement
/cast [@mouseover,harm,nodead][] Judgement
```
With Seal of Fury active, Judgement taunts (10 yd) the mob under your mouse without changing target.
Level: Judgement 4 + Seal of Fury 10. GEMETEN [B6 taunt mechanic; F1 macro].

**P5 — Blessings on one key (mouseover)**
```
#showtooltip
/cast [mod:shift,@mouseover,help,nodead][mod:shift] Blessing of Wisdom; [mod:ctrl,@mouseover,help,nodead][mod:ctrl] Blessing of Kings; [@mouseover,help,nodead][] Blessing of Might
```
Might by default, Wisdom with Shift, Kings with Ctrl, on the player under your mouse (else target).
Level: Might 4, Wisdom 14, Kings 20. GEMETEN [F2 macro; L1/F2 levels].

**P6 — Lay on Hands: mouseover / target / yourself, Alt = always you**
```
#showtooltip Lay on Hands
/cast [mod:alt,@player][@mouseover,help,nodead][help,nodead][@player] Lay on Hands
```
Emergency full heal; with no friendly target it lands on you.
Level 10; 20-min cooldown in Forever. GEMETEN [F1 macro; B6 cooldown].

**P7 — Heal on mouseover: Holy Light, Shift = Flash of Light**
```
#showtooltip
/cast [mod:shift,@mouseover,help,nodead][mod:shift,help,nodead][mod:shift,@player] Flash of Light; [@mouseover,help,nodead][help,nodead][@player] Holy Light
```
Heals the friend under your mouse, else friendly target, else yourself.
Level: Holy Light 1, Flash of Light 20. GEMETEN [F1; C4 Classic mouseover advice].

**P8 — Hammer of Justice: stop cast, focus first (your "interrupt")**
```
#showtooltip Hammer of Justice
/stopcasting
/cast [@focus,harm,nodead][@mouseover,harm,nodead][] Hammer of Justice
```
Paladins have no interrupt; a stun on the caster is the substitute.
Level 8. GEMETEN [F1; C4 Classic stopcasting advice; "no interrupt" from Panel Recap].

Also recommended: Light's Vigil on focus `/cast [@focus,help,nodead][] Light's Vigil` (31-pt Holy talent; F1 lists level 40) [F3; B7 16 Oct fix]; Blessing of Protection mouseover with Alt = Divine Protection [F2]; Divine Shield that cancels itself on second press (34) [F2]; Consecration + /startattack (20) [F1]; Seal of the Crusader → Judgement → Seal of Righteousness castsequence (6) [F1] — AFGELEID: in Forever this is a debuff-then-swap sequence, not a twist.

---

## 7. SHAMAN

Forever changes that matter for macros (big ones):
- **Totem Bar + "Call" spells** — GEMETEN [B4, 7 Oct]:
  - Call of the Elements (level 20): unlocks the totem bar, drops your 4 preset totems after a 3 s cast.
  - Totemic Recall (level 20): destroys all your totems, refunds 25% of their mana.
  - Totemic Projection (level 22) — **renamed "Totemic Call" on 3 Nov**: now teleports your totems **to your own position**, 30 s cooldown. — GEMETEN [B7, 3 Nov]
  - Second and third preset: **level conflict** — Blizzard B4 says Call of the Spirits 30, Call of the Ancestors 40; F2 and L1 (client/Zygor data) say Call of the Ancestors 30, Call of the Spirits 40. F2 states the client shows Ancestors 30 / Spirits 40.
- Totems have a **1.0 s GCD** (was 1.5); buff totems last 5 min. — GEMETEN [B4]
- Fire Nova Totem removed → **Fire Nova is a spell** that hits around your Fire totem. — GEMETEN [B4]
- Weapon imbues last **60 min** (was 5). — GEMETEN [B4]
- Water Shield = Restoration 11-pt talent; only one shield at a time. — GEMETEN [B4]
- AFGELEID: from level 20 the classic `/castsequence` totem macro is replaced by Call of the Elements.

**S1 — Totems: drop set / Shift = Recall / Ctrl = pull them to you**
```
#showtooltip
/cast [mod:shift] Totemic Recall; [mod:ctrl] Totemic Call; Call of the Elements
```
Press = your 4 totems; Shift = pick them up and get mana back; Ctrl = move them to where you stand. Set up the totem bar first.
Level: 20 (Ctrl half 22). GEMETEN [F2 macro (already uses the new name "Totemic Call"); B4; B7].

**S2 — All three totem sets on one key**
```
#showtooltip
/cast [mod:ctrl] Call of the Ancestors; [mod:alt] Call of the Spirits; [mod:shift] Totemic Recall; Call of the Elements
```
Three presets (e.g. solo / melee group / caster group) plus Recall.
Level: 20 / 30 / 40 (which name is 30 vs 40 is disputed, see above). GEMETEN [F2].

**S3 — Before level 20: one totem per press**
```
#showtooltip
/castsequence reset=combat Strength of Earth Totem, Searing Totem
```
Until you have Call of the Elements: first press Strength of Earth, second Searing; resets after combat.
Level 10. GEMETEN [F1 idea]. AFGELEID: I removed Healing Stream Totem from F1's version because it is a level-20 spell in Classic ([CE]; not verified for Forever). [CE] castsequence stall bug report exists [F7].

**S4 — Earth Shock interrupt: stop cast, focus first**
```
#showtooltip Earth Shock
/stopcasting
/cast [@focus,harm,nodead][@mouseover,harm,nodead][] Earth Shock
```
Cancels your own cast and shocks the caster (focus, mouseover, or target).
Level 4. GEMETEN [F1; F2; C5 Classic]. [CE] that Earth Shock still interrupts in Forever is not stated by Blizzard; F1 calls it "the Shaman's interrupt".

**S5 — Purge on mouseover / focus / target**
```
#showtooltip Purge
/cast [@mouseover,harm,nodead][@focus,harm,nodead][] Purge
```
Strips a magic buff without changing target.
Level 12. GEMETEN [F1, F2; L1].

**S6 — Heal on mouseover: Healing Wave, Shift = Lesser Healing Wave**
```
#showtooltip
/cast [mod:shift,@mouseover,help,nodead][mod:shift,help,nodead][mod:shift,@player] Lesser Healing Wave; [@mouseover,help,nodead][help,nodead][@player] Healing Wave
```
Mouseover → friendly target → yourself; Shift for the fast heal.
Level: Healing Wave 1, Lesser Healing Wave 20. GEMETEN [F1; C5 Classic].

**S7 — Lightning Shield, Shift = Water Shield**
```
#showtooltip
/cast [mod:shift] Water Shield; Lightning Shield
```
One shield key; Water Shield needs the Resto talent.
Level: Lightning Shield 8. GEMETEN [F1, F2; B4].

**S8 — Shock + auto-attack (levelling / Enhancement)**
```
#showtooltip
/startattack
/cast [mod:shift] Flame Shock; [mod:ctrl] Frost Shock; Earth Shock
```
Earth Shock by default, Flame with Shift, Frost with Ctrl, and starts melee so you don't stand idle.
Level: Earth 4, Flame 10, Frost 20. GEMETEN [F1/F2 shock macro; C5 /startattack advice; L1 levels].

Also recommended: Grounding Totem with /stopcasting (30) [F1]; Nature's Swiftness + Healing Wave (Resto talent) [F1]; Stormstrike + /startattack (Enh talent; 6 s CD since 3 Nov) [F1; B7]; Ghost Wolf `/cast !Ghost Wolf` (20) [F1]; Cure Poison/Disease mouseover [F1, F2]; weapon imbue key [F1] — less needed now imbues last 60 min [B4].

---

## 8. Open points (not verified anywhere)

1. Any macro in the live Forever client — **zero sources tested in game** (F1, F2 say so).
2. Judgement on/off GCD in Forever (matters for P2).
3. Sap requiring Stealth (B5 vs F1 client-data note).
4. Earth Shock interrupt behaviour unchanged (no Blizzard text either way).
5. Charge out-of-combat-only rule (Classic; F2 repeats it).
6. Call of the Ancestors vs Call of the Spirits level (B4 vs F2/L1).
7. `[stance:N]` numbering vs learn order (one player comment, F6).
8. `/castsequence` stall bug (F7, beta, no reply).
9. Whether Retail's 2026 chat/marker macro limits apply (F3: unconfirmed).
10. Local Zygor data (L1) is older than the 16 Oct and 3 Nov notes — only use it where Blizzard/F1/F2 agree.

## 9. Character counts (measured)

GEMETEN (script `count_macros.py`, 2026-11-09, run on this file; newlines count as 1 character): all 40 macros are within 255.
Longest single lines are 156–179 characters (W6, P5, P7, S6). No source states a per-line limit in Forever;
F2 splits lines over 125 characters only for display on its website (AFGELEID: not a game limit).

| Macro | Total chars | Longest line | ≤255 |
|---|---|---|---|
| W1 | 131 | 105 | OK |
| W2 | 77 | 41 | OK |
| W3 | 73 | 39 | OK |
| W4 | 57 | 25 | OK |
| W5 | 101 | 88 | OK |
| W6 | 191 | 178 | OK |
| W7 | 85 | 27 | OK |
| W8 | 65 | 39 | OK |
| R1 | 35 | 20 | OK |
| R2 | 137 | 99 | OK |
| R3 | 113 | 72 | OK |
| R4 | 95 | 78 | OK |
| R5 | 75 | 57 | OK |
| R6 | 94 | 39 | OK |
| R7 | 43 | 18 | OK |
| R8 | 102 | 57 | OK |
| H1 | 57 | 26 | OK |
| H2 | 50 | 22 | OK |
| H3 | 53 | 40 | OK |
| H4 | 79 | 26 | OK |
| H5 | 80 | 67 | OK |
| H6 | 90 | 38 | OK |
| H7 | 108 | 95 | OK |
| H8 | 65 | 24 | OK |
| P1 | 55 | 24 | OK |
| P2 | 85 | 29 | OK |
| P3 | 69 | 56 | OK |
| P4 | 65 | 42 | OK |
| P5 | 192 | 179 | OK |
| P6 | 108 | 82 | OK |
| P7 | 169 | 156 | OK |
| P8 | 114 | 70 | OK |
| S1 | 92 | 79 | OK |
| S2 | 132 | 119 | OK |
| S3 | 78 | 65 | OK |
| S4 | 102 | 64 | OK |
| S5 | 77 | 58 | OK |
| S6 | 176 | 163 | OK |
| S7 | 61 | 48 | OK |
| S8 | 92 | 66 | OK |

Note: H6 and R8 contain item names you must replace (food / poison rank); their length changes with the name.
