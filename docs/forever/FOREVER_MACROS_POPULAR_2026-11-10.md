# WoW: Forever macros: which ones are used and recommended most

Research date: 10 Nov 2026. Input: `FOREVER_MACROS_2026-11-09_A.md` (universal, racials), `_B.md` (Warrior, Rogue, Hunter,
Paladin, Shaman), `_C.md` (Mage, Warlock, Priest, Druid). Their macro ids are reused here and not re-researched.
The ids clash between files: Warrior W1-W8 (B) vs Warlock W1-W8 (C), Paladin P1-P8 (B) vs Priest P1-P8 (C). This file
always names the class next to the id. **NEW** = a macro that is not in A/B/C.

Labels: **GEMETEN** = seen in a named, dated source (all pages read on 10 Nov 2026). **AFGELEID** = my reasoning.
Every count and every player quote in the tables is GEMETEN. The score formula and the ranking built from it are
AFGELEID.

**Nobody has tested these macros in the live Forever client: not me, and not any source.** foreverdb says "Not yet
tested in game" on each macro. classicwowforever says "Not tested in the live Forever client yet". Player posts below
are reports of what happened to them. They are not tests that I ran.

---

## 0. Main findings

1. **The two class macros players talk about most on the official forums both behave differently in Forever.**
   - **Warrior "change stance + use ability" macros need two presses.** GEMETEN: EU forum "Warrior Stance Dance now
     triggers micro GCD" (beta, 2 to 7 Oct 2026, 26 posts). The poster tested the same macro in Classic Era, where one
     press is enough (3 Oct). A second EU thread "Vanguard for warriors and associated macro changes" (2 Oct) agrees. A
     player tested it there: "the macro stops after switching to battle stance... it doesn't seem to trigger a gcd". It
     is still reported after launch, in the US thread "Warrior macro not working properaly" (5 + 6 Nov 2026,
     `/cast Defensive Stance` + `/cast Taunt` needs two presses). foreverdb (9 Nov) designs its warrior macros for this:
     "the first press changes stance and the second uses the ability". No Blizzard reply found. AFGELEID: Warrior
     W1/W2/W3/W6 still work, but as two-press keys, and the window should say so.
   - **Druid powershift macros (`/cast !Cat Form`, `!Bear Form`, `!Dire Bear Form`) leave the caster action bar
     showing.** GEMETEN: 7 authors in 6 threads I opened, 7 to 10 Nov 2026 (2404620, 2404886, 2404966, 2407588,
     2407846 US; 641094 EU). Three more threads seen only by title (2404531, 2404529, 2405278, all 7 Nov) and one beta
     thread (2371563, 4 Oct). One workaround posted (9 Nov): the addon "ShiftBar" plus `/click ShiftBarHold`. A later
     post (10 Nov) says it only half helps. No Blizzard acknowledgement found by 10 Nov. Druid D1 is the most-discussed
     class macro in my sample, and today it triggers a known bug.
2. **The sources are less independent than they look.**
   - **60.tools copies classicwowforever.** GEMETEN, measured by script: per class, 50 to 56 of the 60.tools macros are
     byte-identical to classicwowforever code (warrior 50/51, hunter 56/56, warlock 53/53). classicwowforever is CC BY
     4.0. I found no credit line on the 60.tools warrior page. Both are counted here as one family, "cwf/60t".
   - **mmonster credits 9 of its starter macros to other sites.** GEMETEN: "Source RankedBoost" on Arcane Shot+pet,
     Earth Shock, Polymorph, Counterspell, Fear and Trinket. "Source Wowhead macro guide" on Stance swap,
     Charge/Execute/Taunt, One ranged button and Mark/Thorns/Gift. Its "Items and gear" and "Targets and marks" sections
     are command lists, not macros, so they are not counted.
3. **Shift macros can fail because of a key clash, not a macro bug.** GEMETEN, player claims, US forum
   "Forever... [mod:shift] macros not working?" (8 Nov 2026). Two causes are named. Default Shift+key bindings can clash
   with the macro's key. A Self Cast key or Focus Cast key set to Shift also clashes ("set to none or they'll cause
   conflicts"). Many A/B/C macros use Shift. AFGELEID: the window needs a one-line hint about this.
4. **Rank-less `/cast` mostly works, with two counter-reports.** GEMETEN: in the beta (2 Oct 2026, thread 2370149),
   `/cast Charge` tried "Charge Rank 3" with only Rank 1 learned, and `Charge(Rank 1)` fixed it. The same fix was
   posted on 10 Oct (thread 2377230). This adds to A's counter-report from 5 Nov (Healing Touch cast Rank 1). Whether
   it still happens on live is not known.
5. **Players ask most for raid-marker macros, not class macros.** GEMETEN: 3 threads (7 Oct, 9 Nov, 10 Nov 2026). Old
   `/script` marker macros fail, and the answer each time is `/tm 8`. Only 1 macro site (foreverdb) has a marker macro.
6. **NEW gaps in A/B/C.** **Druid: Rejuvenation on mouseover** appears in 8 of 12 source families, and it is SenseOS's
   one druid pick. **Druid: Mark of the Wild / Thorns** is in 6 of 12, and it is a Wowhead example and a kami-labs
   levelling pick. **Paladin: Divine Shield / Divine Protection with a cancel** is in 7 of 12. **Warlock: Bane of Agony
   on mouseover** is in 6 of 12, and it is SenseOS's one warlock pick. **Hunter: pet attack/follow control key**: 4
   players posted about it (6 to 9 Nov). **Universal: one ranged-attack button** for Shoot Bow/Gun/Crossbow/Throw.

---

## 1. Sources and how they were counted

All read on **10 Nov 2026**, by script (urllib, saved in the scratchpad) unless marked otherwise.

| Family | Pages read | Page date (from the page) | Notes |
|---|---|---|---|
| **foreverdb** (named) | `foreverdb.net/macros` + `/macros/<class>` ×9 | "extracted 2026-11-09", build 1.60.1.70862 | 17-22 macros per class, 20 general. Has "Needs: X (level N)" lines. |
| **classicwowforever (cwf)** (named) | `/macros/` + `/macros/<class>/` ×9 | "Reviewed 3 November 2026" | 70-78 per class (670 total). CC BY 4.0. |
| ↳ 60.tools | `/macros` + `/macros/<class>` ×9 | no date on page | Copy of cwf (see §0.2). Counted together with cwf. |
| **rankedboost** (named) | hub + 9 class + 27 spec pages | dateModified 2026-11-08 | Class page = "macros for any spec" (3-6 picks), counted as a shortlist. |
| **mmonster** (named) | `mmonster.co/wow-forever/guides/macros` | 21 Oct, updated 3 Nov 2026 | "Starter macros for every class": 1-3 per class, counted as a shortlist. Partly copied (§0.2). |
| **kami-labs** (named) | article (1 Oct 2026) + tool panels `?wowf_mc_panel=<class>&lang=en` ×9 | tool page dateModified 29 Sep 2026 | Cards with sections (leveling, combat, pvp, ...). The "leveling" section counts as a shortlist. The "Core spells" table (35 single rank-less spells per class) was left out. |
| **Wowhead Forever guide** (named) | guide 34950 + its 3 comments | updated 2026/10/20; comment by Adsun "3 days ago" (about 7 Nov) | **The script got HTTP 403.** I read it with **one browser load**, which worked with no CAPTCHA. User guide with 6 examples, counted as a shortlist. |
| zockify | `/forever/<class>/macros/` ×9 | 18 Oct to 1 Nov 2026 | 13-21 per class. |
| senseos | `senseos.gg/guides/wow-forever/macros/` | 26 Oct, updated 5 Nov 2026 | "A macro for every class": exactly 1 per class, plus 3 stance examples. Shortlist. |
| wowforevercodex | blog 30 Sep 2026 | 30 Sep 2026 | "Three to start with": 3 macros in total. Shortlist. |
| wow-forever.gg | `/guides/macros/` + 9 class pages | 2026-11-08 | 8-10 per class (89 total). Shortlist. |
| github-compendium | `raw.githubusercontent.com/Eightylol/Forever-Macros/main/README.md` | posted on EU forum 9 Nov 2026 (thread 640888) | Player-made, "syntax/spell-checked with AI". |
| guildjen | `guildjen.com/best-wow-forever-macros/` | 3 Nov, modified 7 Nov 2026 | About 12 "best" macros across categories. Shortlist. |

**Counting method** (script `analyze_macros.py` in the scratchpad):
- It splits every page into macro blocks and matches each block to an A/B/C id with spell-name rules, e.g. Warrior W1
  = Charge **and** Intercept in one macro.
- **I spot-checked the matches by hand.** I removed false hits from command-list sections (mmonster, rankedboost hub)
  and from item names. Positive control: Victory Rush, Soulstone and Feed Pet were found where they exist. The negative
  results (foreverdb has no Victory Rush macro, no Feed Pet macro) were therefore trusted, as GEMETEN absence on that
  page only.
- **"Named x/6"** = how many of the 6 named sources (foreverdb, cwf, rankedboost, mmonster, kami-labs, Wowhead guide)
  have that macro or a close variant.
- **"All x/12"** = how many of the 12 families have it (cwf+60.tools counted once).
- **"Shortlists"** = how many short editor top lists picked it: rankedboost class page, mmonster starters, kami
  "leveling", senseos, codex, wow-forever.gg, guildjen, Wowhead examples. A copy (marked `*`) still counts as a pick,
  because the editor chose it.
- **"Players"** = distinct forum authors after 18 Aug 2026 who post or ask for that macro (§9).
- **Score (AFGELEID)** = All + Shortlists + min(Players, 3). It only sorts the list. Rob decides.

Levels come from A/B/C unless marked "fdb" (foreverdb "Needs:" line, GEMETEN 10 Nov) or "senseos"/"wfgg"/"rb".

---

## 2. Warrior (ids from file B)

| # | id | Purpose (one line) | Named | All | Shortlists | Players | Level | Score |
|---|---|---|---|---|---|---|---|---|
| 1 | **W6** | Taunt the mouseover, Shift = Mocking Blow, changes stance first | 6/6 | 9/12 | 4 (rb, wfgg, mmonster*, Wowhead) | 4 | 10 (Mocking Blow 16) | 16 |
| 2 | **W2** | Overpower from any stance | 4/6 | 9/12 | 3 (senseos, guildjen, wfgg) | 0 | 12 | 12 |
| 3 | **W5** | Interrupt: Shield Bash, or Pummel in Berserker, focus first | 4/6 | 8/12 | 3 (rb, senseos, wfgg) | 0 | 12 (Pummel 38) | 11 |
| 4 | W3 | Execute, out of Defensive Stance if needed | 6/6 | 8/12 | 2 (mmonster*, Wowhead) | 1 | 24 | 11 |
| 5 | W1 | Charge out of combat, Intercept in combat | 4/6 | 5/12 | 2 (rb, wfgg) | 4 | 4 (Intercept 30) | 10 |
| 6 | **NEW** | Stance key: Battle ⇄ Defensive (or all three on modifiers) | 4/6 | 5/12 | 2 (mmonster*, Wowhead) | 2 | 10 (Def. Stance quest) | 9 |
| 7 | W7 | Sunder Armor, grabbing a target first | 4/6 | 6/12 | 2 (rb, wfgg) | 0 | 10 | 8 |
| 8 | **NEW** | Thunder Clap, Shift = Demoralizing Shout | 4/6 | 5/12 | 3 (kami-lev, rb, wfgg) | 0 | 6 (Demo 14, fdb) | 8 |

Just below: NEW Revenge+Shield Block (7), NEW Shield Wall/Last Stand (7), W4 Victory Rush (6: cwf, kami, wfgg,
zockify; foreverdb has none), W8 Heroic Strike/Cleave (6). Also in 4/12: Bloodrage, Berserker Rage, Hamstring,
weapon swap, Disarm, Intimidating Shout.

Player detail (GEMETEN):
- W1 family "Charge with a stance swap": Kyn (US, 2 Oct), garemoko (EU, 2 Oct), shramWOW (US, 9 Oct), Passed (US,
  15 Oct).
- W6 Taunt/Mocking Blow: Reeper (5 Nov), FlatBlowfish (6 Nov), Lestro (EU, 5 Oct), Adsun (Wowhead comment, about
  7 Nov).
- Stance key: phobomancer (23 Sep, stances on the mouse wheel), Kibanu (23 Sep).
- Lancer (EU, 5 Nov) posts a "fall-through" priority macro, `/cast Charge` → Execute → Mortal Strike → Heroic Strike,
  and claims it works in Forever. Single claim, not counted for a top spot.
- Classic habit (older than 18 Aug, not Forever evidence): Blizzard thread 326172 "Classic WOW Warrior Charge/Intercept
  Macro" (8 Oct 2019, 12 posts).

---

## 3. Rogue (ids from file B)

| # | id | Purpose | Named | All | Shortlists | Players | Level | Score |
|---|---|---|---|---|---|---|---|---|
| 1 | **R2** | One opener key: Ambush/Cheap Shot/Garrote from Stealth, else Sinister Strike | 4/6 | 8/12 | 4 (kami-lev, rb, senseos, wfgg) | 0 | 1 (SS); openers 14/18/26 | 12 |
| 2 | **R4** | Sap on mouseover/focus, Stealth first | 4/6 | 7/12 | 3 (kami-lev, rb, wfgg) | 0 | 10 | 10 |
| 3 | **R5** | Kick: focus, else mouseover, else target | 4/6 | 7/12 | 2 (rb, wfgg) | 0 | 12 | 9 |
| 4 | R3 | Pick Pocket, then open | 3/6 | 6/12 | 2 (kami-lev, wfgg) | 0 | 4 | 8 |
| 5 | **NEW** | Blind on mouseover/focus | 4/6 | 6/12 | 1 (rb: Sap, Blind outside Stealth) | 0 | 34 (fdb) | 7 |
| 6 | **NEW** | Sinister Strike + `/startattack` (plain levelling key) | 3/6 | 5/12 | 2 (kami-lev, mmonster) | 0 | 1 | 7 |
| 7 | R6 | Safe Vanish (Stealth out of combat) | 4/6 | 6/12 | 0 | 0 | 22 | 6 |
| 8 | **NEW** | Gouge on mouseover / Gouge → Backstab | 4/6 | 6/12 | 0 | 0 | not measured | 6 |

Just below: NEW Evasion+Sprint panic key (6), R1 `!Stealth` (5), R8 poison key (5), NEW Feint (5), NEW Cold Blood (5).
R7 Shank: only cwf and wow-forever.gg (score 3). AFGELEID: it is new since 3 Nov, so few sites have it yet.
No rogue macro thread found on the forums (searched: "forever macro", "macros forever", "mouseover macro").

---

## 4. Hunter (ids from file B)

| # | id | Purpose | Named | All | Shortlists | Players | Level | Score |
|---|---|---|---|---|---|---|---|---|
| 1 | **H8** | Clean Feign Death (stop attack, pet back) | 5/6 | 8/12 | 3 (mmonster, rb, wfgg) | 0 | 30 | 11 |
| 2 | **H4** | Melee weave: Raptor Strike + Mongoose Bite | 4/6 | 7/12 | 3 (kami-lev, rb, wfgg) | 0 | 1 (Mongoose 16) | 10 |
| 3 | **NEW** | Pet control key: `/petattack`, Shift = `/petfollow` or `/petpassive` | 3/6 | 6/12 | 1 (wfgg) | 4 | pet from the lvl-10 quest (fdb text) | 10 |
| 4 | H1 | Hunter's Mark + send the pet | 4/6 | 7/12 | 2 (kami-lev, wfgg) | 0 | 6 | 9 |
| 5 | H5 | Call / Mend / Revive Pet on one key | 4/6 | 7/12 | 2 (rb, senseos: the one hunter pick) | 0 | 10/12 | 9 |
| 6 | H7 | Aspects on one key (Hawk / Cheetah / Monkey) | 4/6 | 5/12 | 3 (kami-lev, rb, wfgg) | 0 | 4/10/20 | 8 |
| 7 | **NEW** | Traps on modifiers (Freezing / Frost / Immolation-Explosive) | 4/6 | 6/12 | 1 (wfgg) | 1 | 16/20/28 (fdb) | 8 |
| 8 | **NEW** | Stings on mouseover / Sting then Arcane Shot | 3/6 | 6/12 | 2 (kami-lev, wfgg) | 0 | not measured | 8 |

Just below: **NEW Arcane Shot + `/petattack`** (7). It is rankedboost's first hunter macro and mmonster's first
starter (credited to RankedBoost). AFGELEID: it does the same job as H1, so merge them as "opener that sends the pet".
Below that: Tranquilizing Shot (6), Concussive/Wing Clip (6), H2 Auto Shot (6), H3 Aimed/Multi (4), H6 Feed Pet (3: cwf,
gh, kami; zockify links a separate Feed Pet guide).

Player detail (GEMETEN):
- Pet control: NavyWhale (6 Nov), Ruro (6 Nov), holysmokes (9 Nov), Kurkina (EU, 9 Nov).
- **`/petdefensive` does not work in macros**; the other pet stances do (NavyWhale, holysmokes, thread 2403442, 6 to
  9 Nov). AFGELEID: leave `/petdefensive` out of any MH macro.
- Traps on modifiers: Haruhisuki (8 Nov, `/use [mod:shift] Frost Trap; [nomod] Freezing Trap`).

---

## 5. Paladin (ids from file B)

| # | id | Purpose | Named | All | Shortlists | Players | Level | Score |
|---|---|---|---|---|---|---|---|---|
| 1 | **P7** | Holy Light on mouseover/target/self, Shift = Flash of Light | 5/6 | 8/12 | 3 (kami-lev, mmonster, wfgg) | 0 | 1 (Flash 20) | 11 |
| 2 | **P2** (or P1) | Holy Strike + Judgement + `/startattack` | 4/6 | 7/12 | 3 (rb, wfgg, kami-lev for P1) | 0 | 4/6 | 10 |
| 3 | **NEW** | Divine Shield / Divine Protection, second press or modifier cancels it | 4/6 | 7/12 | 3 (guildjen, kami-lev, rb) | 0 | 6 (DP) / 34 (DS) (fdb) | 10 |
| 4 | **NEW** | Holy Shock friend-or-foe on mouseover | 4/6 | 8/12 | 2 (senseos: the one paladin pick, wfgg) | 0 | 30, Holy talent (fdb) | 10 |
| 5 | **NEW** | Blessing of Protection on mouseover (Alt = self) | 4/6 | 7/12 | 2 (rb, wfgg) | 0 | 10 (fdb) | 9 |
| 6 | **NEW** | Light's Vigil on focus (then Holy Shock) | 4/6 | 7/12 | 2 (mmonster, wfgg) | 0 | 40, Holy talent (fdb) | 9 |
| 7 | P8 | Hammer of Justice: stop cast, focus first | 4/6 | 6/12 | 2 (rb, wfgg) | 0 | 8 | 8 |
| 8 | **NEW** | Blessing of Freedom on mouseover/self | 3/6 | 6/12 | 1 (wfgg) | 0 | 18 (fdb) | 7 |

Just below: P4 Judgement mouseover taunt (6), P6 Lay on Hands (5), P5 Blessings on one key (5, but 2 players: Adhecard
9 Nov and Zooterkins 10 Nov post mouseover/`[@player]` Blessing of Kings macros), P3 Seal by gear (3).
AFGELEID: ranks 4 and 6 are Holy talents. For a list every paladin can use, put P8 or Freedom before them.

---

## 6. Shaman (ids from file B)

| # | id | Purpose | Named | All | Shortlists | Players | Level | Score |
|---|---|---|---|---|---|---|---|---|
| 1 | **S4** | Earth Shock interrupt: stop cast, focus/mouseover first | 5/6 | 9/12 | 4 (mmonster*, rb, senseos: the one shaman pick, wfgg) | 0 | 4 | 13 |
| 2 | **S6** | Healing Wave on mouseover, Shift = Lesser Healing Wave | 5/6 | 8/12 | 3 (kami-lev, mmonster, wfgg) | 0 | 1 (LHW 20) | 11 |
| 3 | **S1** (+S2) | Totem bar: Call of the Elements, Shift Recall, Ctrl Totemic Call (+ the other sets) | 4/6 | 7/12 | 2 (rb, wfgg) | 0 | 20 (Totemic Call 22) | 9 |
| 4 | S5 | Purge on mouseover/focus | 4/6 | 7/12 | 2 (rb, wfgg) | 0 | 12 | 9 |
| 5 | **NEW** | Searing Totem, then Fire Nova around it | 4/6 | 6/12 | 1 (wfgg) | 0 | 10/12 (fdb) | 7 |
| 6 | **NEW** | Nature's Swiftness + Healing Wave | 3/6 | 6/12 | 1 (wfgg) | 0 | Resto talent | 7 |
| 7 | **NEW** | Cure Poison / Cure Disease on mouseover | 4/6 | 5/12 | 1 (rb) | 0 | not measured | 6 |
| 8 | S8 | Shock + `/startattack` (Earth/Flame/Frost on modifiers) | 4/6 | 4/12 | 0 | 1 | 4/10/20 | 5 |

Just below: NEW Stormstrike (6, talent), S2 counted with S1, S3 totem castsequence before 20 (5), S7 shields (5),
NEW Chain Heal (5), NEW Grounding/Tremor (5). Player: Kasorayn (9 Nov) uses "a macro for shocks that casts the spell
and then starts autoattack" (S8).

---

## 7. Mage (ids from file C)

| # | id | Purpose | Named | All | Shortlists | Players | Level | Score |
|---|---|---|---|---|---|---|---|---|
| 1 | **M2** | Counterspell, even mid-cast | 5/6 | 10/12 | 5 (mmonster*, rb, senseos, codex, wfgg) | 0 | 24 | 15 |
| 2 | **M1** (+M1b) | Polymorph on mouseover / focus | 5/6 | 8/12 | 2 (mmonster*, wfgg) | 0 | 8 | 10 |
| 3 | **M3** | Frost Nova, Ctrl = Blink | 4/6 | 5/12 | 3 (kami-lev, rb, wfgg) | 0 | 10 (Blink 20) | 8 |
| 4 | M8 | Remove Lesser Curse on mouseover/target/self | 4/6 | 6/12 | 1 (rb) | 0 | 18 | 7 |
| 5 | M7 | Frostbolt, modifier = Rank 1 | 3/6 | 5/12 | 2 (rb, wfgg) | 0 | 4 | 7 |
| 6 | M6 | Ice Block, modifier cancels | 3/6 | 6/12 | 1 (wfgg) | 0 | Frost talent | 7 |
| 7 | **NEW** | Blizzard / Flamestrike at cursor, or Rank 1 on Shift | 3/6 | 5/12 | 2 (guildjen, kami-lev) | 0 | 20 (fdb, Blizzard) | 7 |
| 8 | M4 | Drink, Shift/Ctrl = conjure water/food | 3/6 | 5/12 | 1 (kami-lev) | 0 | 4/6 | 6 |

Note on M1: both shortlist picks are the **focus** version (mmonster "Polymorph on your focus", wfgg "Polymorph with
focus"). AFGELEID: show M1b, or M1 with the focus clause, as the main Polymorph macro.
Just below: NEW Ice Lance (6), NEW Mana Shield/Wards (6), NEW wand `!Shoot` (5), NEW Fire Blast (5), MX1 Arcane Missiles
(5), M5 mana gems (3), MX2 (2). No mage macro thread found. Corelas (8 Nov) posted `[mod:shift] Fireball; Frostbolt`
failing, which is the Shift clash in §0.3.

---

## 8. Warlock (ids from file C)

| # | id | Purpose | Named | All | Shortlists | Players | Level | Score |
|---|---|---|---|---|---|---|---|---|
| 1 | **W2** (+W2b) | Fear on mouseover/focus, pet called back, Ctrl = Banish | 5/6 | 8/12 | 3 (mmonster*, rb, wfgg) | 0 | 8 (Banish 28) | 11 |
| 2 | **NEW** | Bane of Agony on mouseover | 2/6 | 6/12 | 3 (kami-lev, senseos: the one warlock pick, wfgg) | 0 | 8 (senseos) | 9 |
| 3 | **W8** | Demon's main button (Spell Lock / Seduction / Sacrifice / Fire Shield) | 4/6 | 7/12 | 1 (wfgg, partial: "Pet attack, Spell Lock on Shift") | 0 | 10/20/30 | 8 |
| 4 | **NEW** | Curse picker on modifiers (Weakness / Recklessness / Elements / Tongues) | 4/6 | 7/12 | 1 (wfgg) | 0 | 4/14/20 (fdb) | 8 |
| 5 | **NEW** | Summon demon on modifiers (+ Fel Domination in combat) | 4/6 | 6/12 | 2 (kami-lev, wfgg) | 0 | Imp 1, VW 10, Succ 20, FH 30 (fdb) | 8 |
| 6 | W6 | Drain Life / Drain Soul you can mash, Ctrl = Life Tap | 4/6 | 6/12 | 1 (kami-lev) | 0 | 6/10/14 | 7 |
| 7 | W7 | DoT castsequence (Corruption, Bane of Agony, Immolate) | 3/6 | 4/12 | 2 (kami-lev, codex) | 1 | 1/4/8 | 7 |
| 8 | W3 | Health Funnel that doesn't restart | 4/6 | 5/12 | 1 (wfgg) | 0 | 12 | 6 |

Just below: W4 Soulstone (6), W5 Healthstone (5), W1 Shadow Bolt + pet (4: only cwf, kami, rb), WX1 Death Coil (4).
Player detail (GEMETEN):
- W7: the castsequence stall bug report (19 Sep 2026, beta, already in A).
- NEW: zack (8 Nov) posted `/cast [target=none] Consume Shadows` so the Voidwalker is not stuck in combat after a kill.
  One post; seen only in foreverdb + kami as a macro.

---

## 9. Priest (ids from file C)

| # | id | Purpose | Named | All | Shortlists | Players | Level | Score |
|---|---|---|---|---|---|---|---|---|
| 1 | **P3** | Flash Heal on mouseover/target/self | 5/6 | 9/12 | 4 (mmonster, codex, wfgg, kami article) | 0 | 20 | 13 |
| 2 | **P4** | Dispel Magic friend or foe (Ctrl = Abolish Disease) | 4/6 | 8/12 | 3 (rb, senseos: the one priest pick, wfgg) | 1 | 18 | 12 |
| 3 | **P1** | Power Word: Shield on mouseover, stops your cast | 4/6 | 7/12 | 3 (kami-lev, rb, wfgg) | 0 | 6 | 10 |
| 4 | **NEW** | Penance friend-or-foe on mouseover | 4/6 | 7/12 | 1 (wfgg) | 0 | 30, Disc talent (fdb) | 8 |
| 5 | **NEW** | Shadow Word: Pain on mouseover | 3/6 | 5/12 | 2 (kami-lev, wfgg) | 0 | 4 (fdb) | 7 |
| 6 | P8 | Prayer of Healing, Ctrl = Inner Focus first | 4/6 | 6/12 | 1 (wfgg) | 0 | 30 | 7 |
| 7 | **NEW** | Prayer of Mending on mouseover / tank | 3/6 | 6/12 | 1 (wfgg) | 0 | talent | 7 |
| 8 | **NEW** | Silence on focus, even mid-cast | 3/6 | 6/12 | 1 (wfgg) | 0 | talent | 7 |

Just below: P2 Renew (6, baseline at 8; AFGELEID: a better pick for all priests than ranks 7-8), NEW wand (6), NEW
race spells such as Contingency Plan / Divine Grace (6), P5 Scream/Fade (5), P7 Shackle (5), P6 downrank heal (5),
PX1 (4), PX2 (3).
Player detail (GEMETEN):
- P4: Myth (3 Nov) posted a mouseover Dispel Magic.
- P6: Tisman (18 Oct) asks for an auto-downrank tag for `Renew(Rank 11)` in mouseover macros. A second poster
  (5 Nov) says macros don't auto-downrank on low-level targets, while spellbook spells do.

---

## 10. Druid (ids from file C)

| # | id | Purpose | Named | All | Shortlists | Players | Level | Score |
|---|---|---|---|---|---|---|---|---|
| 1 | **D8** | Healing Touch on mouseover, Ctrl = cheaper rank | 6/6 | 9/12 | 2 (mmonster, wfgg) | 3 | 1 | 14 |
| 2 | **NEW** | Rejuvenation on mouseover/target/self | 4/6 | 8/12 | 2 (senseos: the one druid pick, wfgg: listed first) | 1 | 4 (senseos, wfgg) | 11 |
| 3 | **NEW** | Mark of the Wild, then Thorns (Shift = Gift of the Wild) | 5/6 | 6/12 | 3 (kami-lev, mmonster*, Wowhead) | 1 | 1 / Thorns 6 (fdb) | 10 |
| 4 | D2 | Aquatic in water, Travel outdoors, Cat indoors | 4/6 | 7/12 | 2 (rb, wfgg) | 0 | 16/20/30 | 9 |
| 5 | D4 | Innervate on mouseover, leaves form | 4/6 | 7/12 | 2 (rb, wfgg) | 0 | 40 | 9 |
| 6 | D5 | Rebirth in combat, Revive out of combat | 4/6 | 7/12 | 2 (rb, wfgg) | 0 | 12/20 | 9 |
| 7 | D1 | `!Cat Form` / powershift (break roots) | 3/6 | 5/12 | 1 (kami article) | **7** | 20 | 9 |
| 8 | DX3 | Growl on mouseover | 4/6 | 7/12 | 1 (wfgg) | 0 | 10 | 8 |

**D1 warning:** the macro is fine, but the client bugs it today (§0.1). AFGELEID: show it with a one-line warning,
or hold it back until Blizzard fixes the action-bar paging.

Player detail (GEMETEN):
- D8: Atheren (5 Nov), Xadie (8 Nov, Shift/Ctrl rank macro), MilesPrower (8 Nov: "copy pasted your macro directly and
  it works as expected").
- Andrew (3 Nov): keeps Mark of the Wild, Thorns, Regrowth and Rejuvenation on a hidden bar and fires them with `/click`
  macros so they auto-downrank on low-level players. He also changes a "Moonfire max rank minus 1" macro all the time.
- Other druid macros players posted: Lunatic (7 Nov) `/cast [form:1] Bash; War Stomp`; IDCAA (9 Nov) form-dependent
  Swipe/Shred/Nature's Grasp, which stopped changing by form at launch; Risemix (3 Nov) one-button Balance castsequence.
  The poster himself calls it about a 3% DPS loss.

Just below: NEW Nature's Swiftness + Healing Touch (7, Wowhead comment + wfgg), NEW Dash from Cat (7: mmonster's own pick
+ kami article), NEW Shred/Ravage/Pounce (6), NEW Regrowth (6), NEW Prowl (6), NEW Faerie Fire any form (6), DX1 (6),
D7 (5), D6 (2), D3 (1), DX2 Shifting Power (1: zockify only).

---

## 11. Universal top list (file A ids)

Counted only on general sections (foreverdb general page, rankedboost hub templates, mmonster "For every class",
wow-forever.gg "every class", github "Universal", guildjen, Wowhead examples). The class pages also have trinket and
potion lines, but those are not counted here.

Score here = All + min(Players, 3) (AFGELEID; the general sections have no shortlists to count).

| # | id | Purpose | Named | All | Players | Level / needs | Score |
|---|---|---|---|---|---|---|---|
| 1 | **U7** (+ racial burst template) | Trinkets (13/14) with your main spell or racial | 3/6 (fdb, rb, mmonster*) | 6/12 (+ guildjen, gh, wfgg racial-only) | 0 | an on-use trinket | 6 |
| 2 | **U8** | Skull / markers with `/tm` (mouseover or target) | 1/6 (fdb, 3 variants) | 1/12 | **3 threads, 9 authors** | any | 4, but the most asked-for |
| 3 | U10 (+U12) | Set/clear focus; assist the focus | 1/6 (fdb) | 2/12 (+ gh); wfgg has a focus-on-Shift template | 2 | any | 4 |
| 4 | **U2/U3/U4** | Healthstone first, then potion | 2/6 (fdb, rb) | 3/12 (+ wfgg) | 0 | a stone/potion | 3 |
| 5 | **NEW** | One ranged-attack button `[worn:Bows] Shoot Bow; [worn:Guns] Shoot Gun; ...; Throw` | 2/6 (Wowhead, mmonster*) | 3/12 (+ gh) | 0 | 1; Warrior/Rogue/Hunter | 3 |
| 6 | **U1** | Mount on/off | 1/6 (fdb) | 2/12 (+ guildjen) | 0 found | a mount | 2 |
| 7 | U5 | Bandage on mouseover/self | 1/6 (fdb) | 2/12 (+ gh) | 0 | a bandage | 2 |
| 8 | U6 | Eat + drink in one press | 1/6 (rb) | 2/12 (+ gh) | 0 | food + drink | 2 |
| (pattern, not ranked) | **NEW** | Mouseover cast template `[@mouseover,help,nodead][help,nodead][@player] SPELL` / harm version | 1/6 (kami article) | 3/12 (+ wfgg, senseos) | 3 | any | 6 |

AFGELEID on the last row: it is a pattern, not a ready macro. The class lists already contain it (Paladin P7, Shaman
S6, Priest P3, Druid D8, NEW Rejuvenation), so it is left out of the ranking.

Player detail (GEMETEN):
- U8: thread 2374877 (7 Oct, 15 posts: Ashkir, Fake, Jezza, Tiffamy, Wedgie), 2407565 (9 Nov: Kasorayn, Trinith) and
  2408649 (10 Nov: Sniklefrits, KxanMonkey). Every answer is `/tm N`. Fake adds `/tm [@mouseover,exists,nodead] 3`.
  Kasorayn says his Classic Era marker macro "doesn't work".
- Mouseover/self: Sakiri (2 Nov) prefers mouseover macros to the built-in option because they are "more selective".
  Adhecard (9 Nov) and Zooterkins (10 Nov) use `[@player]` / `[@mouseover,help,nodead][]` buff macros. The reason is a
  bug: with "Enable Interact Key" on, friendly casts land on a nearby NPC (thread 2405408, 7 to 10 Nov, several
  players).
- Focus: Fake (7 Oct) binds a marker that also sets focus. Kurkina (EU, 9 Nov) could not get
  `/target [@focustarget]` + `/petattack` to work.

Seen in players' posts but not in our list, no source count (NEW, social):
- Mouseover group invite via `/run ... C_PartyInfo.InviteUnit(...)`: cuddlesquid (4 Nov). BlackCat and kazius asked
  for it.
- `/ginvite` macros are blocked ("A macro script has been blocked..."): HushGlowie (5 Nov), Oski (6 Nov).
- Whisper-target macro via `/script SendChatMessage`: Oski (6 Nov).
- Quest turn-in `/click QuestFrameCompleteButton` and a dungeon-rare `/target` list: sorrymybad (26 Oct, beta).
- foreverdb and the github compendium also have a pull timer and a ready check (2/12).

Mount (U1) honesty note: only 2 of 12 families have a mount on/off macro, and I found no player post asking for one
(search "mount macro after:2026-10-01" gave none about a mount macro). AFGELEID: keep U1 for completeness, low on the
list.

---

## 12. Per-class top 3 (by score; AFGELEID ranking from GEMETEN counts)

| Class | 1 | 2 | 3 |
|---|---|---|---|
| Warrior | W6 Taunt/Mocking Blow | W2 Overpower | W5 Shield Bash/Pummel |
| Rogue | R2 opener | R4 Sap | R5 Kick |
| Hunter | H8 Feign Death | H4 Raptor/Mongoose | NEW pet attack/follow key |
| Paladin | P7 Holy Light/Flash | P2 (P1) Holy Strike+Judgement | NEW Divine Shield/Protection with cancel |
| Shaman | S4 Earth Shock interrupt | S6 Healing Wave mouseover | S1 totem bar key |
| Mage | M2 Counterspell | M1/M1b Polymorph (focus) | M3 Frost Nova/Blink |
| Warlock | W2 Fear (+Banish) | NEW Bane of Agony mouseover | W8 demon main button |
| Priest | P3 Flash Heal mouseover | P4 Dispel Magic | P1 Power Word: Shield |
| Druid | D8 Healing Touch | NEW Rejuvenation mouseover | NEW Mark of the Wild/Thorns |
| Universal | U7 trinkets/burst | U8 `/tm` markers | U10 focus set/clear (U2-U4 healthstone→potion is 4th) |

---

## 13. What I searched, and what I could not reach

Forums (GEMETEN, Discourse JSON, read 10 Nov 2026):
- **US searches:** "forever macro order:latest", "macros forever after:2026-10-01", "mouseover macro after:2026-10-01",
  "macro after:2026-11-04", "powershift macro after:2026-10-01", "mount macro after:2026-10-01",
  "castsequence after:2026-09-01".
- **EU search:** "forever macro after:2026-09-01".
- **Threads opened in full:** US 2399184, 2406434, 2359443, 2370149, 2372427, 2374877, 2377230, 2384533, 2386249,
  2392404, 2399469, 2400930, 2401520, 2401793, 2403442, 2404620, 2404886, 2404966, 2405026, 2405408, 2405876, 2406064,
  2407565, 2407588, 2407653, 2407846, 2408333, 2408649; EU 633150, 633220, 639793, 640888, 640909, 641094.
- **Seen by title only:** 2404531, 2404529, 2405278, 2371563, 2408885 ("How's your class feeling?", 96 posts, not read).
- The searches only return the top 50 topics per query. More macro threads can exist. **An empty search proves
  nothing.**

**Reddit: not reached.**
- `www.reddit.com` JSON gave HTTP 403 to the script. `old.reddit.com` sent me to a login page.
- WebSearch and Exa found no Forever macro thread on Reddit.
- r/wowforever exists. GEMETEN: Windows Central (9 Nov 2026) quotes a post "from r/wowforever".
- No Reddit evidence is in this file. A 2019 r/classicwow "warrior stance dance macro suite" turned up in a search
  snippet. It is Classic habit only, not opened.

**Wowhead:** the script got 403. One browser load worked (10 Nov, no CAPTCHA). I stopped there.

**Seen in searches, not counted:** wowcalc.net/en/forever/wiki/macros, muchamielwow.github.io,
wowbuildsforever.com/macros (418 macros), playground.ru (Russian, 5 Nov), a YouTube guide (Loru Gaming), Icy Veins
(403 per file C).

**Not verified anywhere:**
- Whether the warrior two-press behaviour and the druid action-bar bug are intended, or fixed later. No blue post was
  found.
- Whether the beta rank bug (`Charge` tried Rank 3) still happens on live.
- Every macro in the live client, because no source tested any.

Working files (scratchpad, temporary): `analyze_macros.py`, `out/summary.txt`, `out/counts.txt`, `out/newcand.txt`,
`out/forum.txt` under
`C:\Users\RobHu\AppData\Local\Temp\claude\e1c44003d48d72c2\45f8f015-eb58-4e9a-bfdc-686d6fb09ce4\scratchpad\`.
