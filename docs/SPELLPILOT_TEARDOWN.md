# SpellPilot — what it does, and what it taught us

Read on 3 Aug 2026, version 0.11.3, `## Interface: 120007` (live, not PTR).
Installed at Rob's request purely to read; **All Rights Reserved**, so nothing is
copied. API names are facts about the game and may be used; their code may not.

CurseForge lists it as an interrupt helper. It is considerably more than that.

## It overlaps Midnight Helper in four places

| Their file | What it is | MH equivalent |
|---|---|---|
| `FolioGuide.lua` | "Read-only Omnium Folio recommendation panel" | `Modules/OmniumFolio.lua` |
| `StatGuide*.lua` | Stat priority guidance | `Modules/PawnExport.lua`, partly the Academy |
| `Hearthstones.lua` | Hearthstone/travel helper | the parked Farstrider travel idea |
| `ReputationTracker.lua` | Reputation progress | parts of the weekly panels |

Plus `Interrupts.lua`, `Removals.lua`, `Debuffs.lua`, `HealthAssist.lua`,
`InnervateAlert.lua`, `PetStatus.lua`. One day old, 22 downloads at the time of
reading, already at 0.11.3.

The market note from July said MH's edge is **explaining**, not tracking, and that
the checklist niche is taken. This does not change that, but it does say the
utility-reminder niche is being taken too, quickly, by someone shipping several
times a day.

## Their secret handling is the same as ours — independently

`ReminderFrame.lua:168`

    frame:SetAlphaFromBoolean(notInterruptible, 0, 1)

and in `Interrupts.lua`, next to the assignment:

    -- Assignment is permitted for a protected value. Do not inspect its
    -- truthiness; ReminderFrame maps it directly to frame alpha.

That is exactly what `Modules/CombatSafety.lua` does, arrived at separately. Two
addons converging on the same technique is the strongest evidence yet that it is
the intended route rather than a trick that happens to work.

## Three things they use that MH does not

**1. `castBarID` is readable.** `Interrupts.lua:104` — "castBarID is explicitly
non-secret in Midnight and lets target changes detect a cast already in progress
without branching on protected data." Same shape as the party-target panel's use
of `UnitExists`: gate on the field that reads, display the one that does not. MH
has no use of it yet, and "is a cast happening right now" is a question several
modules ask.

**2. `aura.canActivePlayerDispel`.** `Removals.lua:81` reads it straight off the
aura table: a boolean for "you personally can remove this", with no dispel-type
table to maintain and no class logic. If it holds up, most of the data work the
dispel-helper was going to need does not exist.

**3. `C_UnitAuras.GetAuraSlots(unit, "HELPFUL|DISPELLABLE", 1)`.**
`Removals.lua:93`, with the comment that some legacy NPC frenzy effects are
removable but carry no readable Enrage label, and that this filter exposes them
anyway.

MH uses **neither** of the last two — grepped, zero hits in `Modules/`.

## Before building on any of that

Their file is `## Interface: 120007`, so it runs on live — but every one of those
calls sits inside a `pcall`, which means their code cannot tell you whether the
field exists on 12.0.7 or is silently absent until 12.1. A `pcall` that fails
looks exactly like one that returns nothing, which is the same trap this
repository has walked into four times in two weeks.

So: measure both on Rob's live client before designing around them. Does
`canActivePlayerDispel` come back readable, secret, or nil? Does the
`HELPFUL|DISPELLABLE` filter return slots today? `Modules/DispelCapture.lua` is
already the harness for exactly this kind of question and it saves to
SavedVariables, so the measurement costs one dungeon.

That measurement is now the first step of the dispel-helper rather than a
side-quest: it decides whether that feature needs a maintained spell table at all.

## MEASURED, 3 Aug 2026 — Twilight Crypts, a delve, in combat

One of the two is a dead end and the other is the way in.

### `canActivePlayerDispel` adds nothing

From the readability log, keyed spellId / name / dispelName / canActivePlayerDispel:

| pattern | seen |
|---|---|
| `read / read / nil / read` (combat) | 167 |
| `read / read / nil / read` (idle) | 31 |
| `secret / secret / nil / secret` (combat) | 279 |

The field is readable exactly when `spellId` and `name` are, and secret the moment
they are. Not one combination exists where it answers while the rest stays shut.
So it is worth no more than `dispelName` already was, and the hope that it would
remove the need for a maintained spell table is dead. Do not revisit it because a
competitor uses it — they use it where the aura is readable anyway.

### The `DISPELLABLE` filter is the real find

`C_UnitAuras.GetAuraSlots("target", "HELPFUL|DISPELLABLE", 1)`, 200 calls:

    hits 27 · misses 173 · errors 0 · absent 0

It **exists on 12.0.7** — not a 12.1 addition, which is what the watcher entry
implied. It never errored. And it returned a slot 27 times while, in the same
content and the same fight, per-aura `name` and `spellId` were coming back secret.

That is the shape the dispel helper needs and could not get: **"there is something
removable on this target" is answerable even when "what is it" is not.** Which is
also the honest form of the feature — MH's edge is explaining, and "you can purge
that" is a complete thought without the buff's name in it.

Two caveats, both real:

- `misses` includes every call made with no target at all, since the probe fired
  per aura scan and did not record whether a target existed. So 27/200 is a floor
  on how often it fires, not a hit rate. Worth tightening if the number ever
  matters; it does not for the yes/no.
- This measured **HELPFUL on the target** — purge and soothe. Dispelling a debuff
  off a party member is `HARMFUL|DISPELLABLE` against `party1..4`, and that is a
  different call in different content. Measured next.

### The friendly side works — dungeon, 3 Aug 2026

Six tallies, 36 scans each, in a real dungeon run with the group:

| probe | hits | misses | noUnit | errors |
|---|---|---|---|---|
| `player` HARMFUL | 36 | 0 | 0 | 0 |
| `party3` HARMFUL | 36 | 0 | 0 | 0 |
| `party4` HARMFUL | 28 | 8 | 0 | 0 |
| `party2` HARMFUL | 11 | 25 | 0 | 0 |
| `party1` HARMFUL | 0 | 36 | 0 | 0 |
| `target` HELPFUL | 0 | 20 | 16 | 0 |

**Zero errors anywhere, and it discriminates.** party1 answered no every single
time while party3 answered yes every single time, in the same fights. A filter
that was broken, forbidden or secret could not produce that spread — it would be
all-yes or all-error. `noUnit = 0` on all four confirms the group was really
there, so the misses are real "nothing removable on them" answers.

**This is the green light for the dispel helper.** "Does this ally have something
you can remove" is answerable, live, in combat, with no spell table, no class
logic and no reading of anything secret.

**Sampling caveat, and it matters for the wording of the feature.** The probe
fires per aura scan, and scans are driven by the player already having aura
activity — so these are not "how often does someone have a dispellable debuff".
`player` at 36/36 almost certainly reflects that bias rather than a permanently
debuffed priest. Use the filter as a live yes/no, never to claim a frequency.

## Timewalking refuses the combat log. Settled, not transient.

Third refusal, third dungeon, third day:

    07-25  Dire Maul                              diff 24  ADDON_ACTION_FORBIDDEN
    07-25  Zul'Farrak                             diff 24  ADDON_ACTION_FORBIDDEN
    08-03  Hellfire Citadel: The Shattered Halls  diff 24  ADDON_ACTION_FORBIDDEN

`Modules/Retrospective.lua` argues these were probably one-offs caught mid-loading-screen,
on the grounds that DBM was announcing bosses in the same dungeon. Three
independent occurrences refute the "transient" half. DBM's success is still
unexplained and is now the sharper question: something about MH's registration is
refused where theirs is not, specifically at difficulty 24, which also reports
`hasSecretRestrictions = true`.

Practical consequence, and it is not small: **interrupt credit does not work in
Timewalking**, which is where Rob actually plays with his group. The feature is
sound in normal and heroic dungeons and useless in the content it was asked for.
