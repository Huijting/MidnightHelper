# Proposal — tier advice at the obelisk

Status: **proposal, not built.** Rob approved writing it up on 1 Aug 2026, for
after 2.12.0.

## The idea in one line

Not "record which tier you did" — **"tell you which tier you can take, while you
are standing at the obelisk deciding"**.

## Why this shape

The obelisk experiment (see `docs/RESEARCH_12_1.md`) set out to capture the tier of
a completed ritual run and failed: the client never marks which tier you picked.
But the same measurement turned up data nobody was looking for.
`C_DelvesUI.GetDelveEntranceTiers()` returns, for each of the six tiers:

| field | measured value |
|---|---|
| `suggestedILvl` | 215 / 231 / 244 / 257 / 264 / 274 |
| `tierDescription` | e.g. `"Tier 3 - 1 Challenges"` |

That list reads live, at the entrance, for every tier at once. It is worthless for
a history log and genuinely useful for a decision — which is the moment the player
is actually in when the data is available.

It also fits what MH is for. The market check (July 2026) concluded MH's edge is
**explaining**, not tracking; the checklist niche is taken. "You can take Tier 4"
is explaining.

## What it would say

At the obelisk, one line, in the panel or as a toast:

> **Tier 4** vraagt ilvl 257 — jij hebt 268. Dat kan.
> Tier 5 vraagt 264, dat kan ook. Tier 6 vraagt 274, dat is 6 boven je ilvl.

The useful part is naming the **highest tier you clear comfortably**, because that
is the number the player is trying to work out by squinting at six rows.

## It is bigger than rituals (measured 2 Aug 2026)

The proposal below was written from ritual-obelisk data only. `GetDelveEntranceTiers()`
also answers at a **delve** entrance — `entranceType` 1, eleven tiers, `suggestedILvl`
170 → 264. Delves are run far more often than rituals, so most of this feature's value
is there.

Two things worth saying that came out of the same measurement:

- **A ritual asks for more gear than a delve at the same tier number.** Ritual Tier 1
  suggests 215; delve Tier 1 suggests 170. Someone who has cleared Tier 5 delves and
  walks up to a Tier 5 ritual is not looking at the same thing, and nothing on screen
  says so.
- **In a bountiful delve, Tier 4 appears to be where Trovehunter's Bounty starts.**
  Tiers 1–3 give Bountiful Coffer + Bountiful Heavy Trunk; from Tier 4 the Bounty is
  added. Read live from the rewards list, so it never needs maintaining — but it was
  measured in **one** bountiful delve, and the comparison delve was a different delve
  (it had to be). Do not state the threshold as a rule until a second bountiful delve
  confirms it. Reading the list live sidesteps this entirely: show what *this* entrance
  offers per tier, and no general claim is needed.

The rewards themselves are containers with item level 1 — they say *what* you get, not
how good it is. Do not present them as a gear-level comparison.

## Ingredients, all verified present

- `C_DelvesUI.GetDelveEntranceTiers()` — measured, returns the six-entry list.
- `C_DelvesUI.GetTieredEntranceType()` — measured, flips 0 → 2 on arriving at a
  tiered entrance. This is the trigger: it is the only signal the client gives that
  you are standing at one.
- `GetAverageItemLevel()` — already used in `Modules/AltOverview.lua:252` and
  `Modules/KnowledgeRuntime.lua:1035`, both behind a `pcall`. Returns overall and
  equipped; **equipped** is the honest one to compare against a requirement.
- `Modules/RitualSites.lua` — where it belongs, next to `ns.GetRitualWeeklyHint()`.

Nothing here needs a new API, a new library, or a PTR trip.

## Open questions to settle before building

1. **`suggestedILvl` is a suggestion, not a gate.** Whether the game blocks entry
   below it, or merely advises, is not measured. The wording must not promise
   "you can enter" if it is only "this is aimed at". Measure once by standing at an
   obelisk on a low-ilvl alt and reading what the picker actually allows.
2. **Which item level to compare.** Equipped vs overall differ for anyone with a
   bag full of upgrades. Equipped is what you fight with; say so in the text.
3. **How big a gap is "comfortable"?** Inventing a margin ("+5 is fine") would be a
   guess. Safer first version: state the two numbers and which tiers are at or
   below the player's ilvl, and let the player judge. A margin can come later if
   Rob's own runs suggest one.
4. **Where it appears.** A toast at the obelisk risks being noise for someone who
   runs twenty rituals a week. A line in the ritual panel is quieter but needs the
   panel open. Rob decides; the toast should at minimum be switchable.
5. **Challenges change the difficulty too.** `tierDescription` carries a challenge
   count ("Tier 3 - 1 Challenges") and higher tiers require active challenges. The
   advice is incomplete if it only compares ilvl, so the challenge count should be
   shown alongside rather than folded into a single verdict.

## What this is not

It does not record anything, and it must not be turned into a backfill for
`RitualLog`. Tier 0 in the log means unknown. If the widget sweep now built into
`/mh tier` finds a real tier caption inside a ritual, *that* becomes the recording
route — a separate piece of work, and evidence-led rather than inferred from what
was on offer at the door.
