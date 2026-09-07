# Midnight Helper 3.9.0

Four things in this release were quiet failures: the addon looked right, said nothing, and was
wrong. That is the kind we go looking for hardest, because nobody can report what leaves no trace.

## The rares tab was reading the wrong flag, and it cost you loot

Every Midnight rare carries **two** quest ids. One records that *your account* killed it this
week; the other records that *this character* did. The Coffer Key Shards follow the second one.

We were reading the first.

So an alt that had never set foot on the Coiled Isle saw eleven rares greyed out as finished, the
route skipped past them and the scanner stayed silent — while every one of them would still have
paid out. Measured the hard way: a rare our own panel called done handed over 50 Coffer Key Shards.

Twelve rows are switched to the per-character flag. Only the Coiled Isle was affected; the older
zones already carried the right id, which is how the fault stayed hidden.

## Four rares that could never tick themselves off

Four Coiled Isle rares had no weekly id recorded, and a workaround hung them on an **achievement**
instead. An achievement never resets. One kill marked them done forever and they disappeared from
the route for good.

Their real ids are in now — one of them found by watching it flip during a kill rather than by
looking it up anywhere.

## Dundun says which visit this is

Your **first** Dundun of the week on a character adds a second Bountiful Coffer, and opening that
coffer can cost a second Restored Coffer Key. Every visit after that lets you pick a reward, which
lands in an Abundant Spoils at the end — no coffer, so no key.

The addon used to recite that rule because it could not tell which case you were in. Now it reads
the conversation by number instead of by sentence, so it names your actual case, in every language.

## Three classes had an empty key and nothing said so

- **Shadow Priest** — the spec's biggest burst button was missing from F1. Blizzard renamed *Void
  Eruption* to *Voidform* in 12.0.0 and our table still looked for the old name, so Power Infusion
  quietly slid into the slot and the screen looked complete.
- **Beast Mastery Hunter** — the AoE key sat empty because *Multi-Shot* was replaced by
  *Wild Thrash*.
- **Guardian Druid** — never had *Lunar Beam*, which is the first line of its own priority list.

Twelve abilities added across Druid, Priest and Hunter, every id read from a real spellbook rather
than from a website.

## Thank you, Yberamos

The curio advice panel's closing line overlapped the text above it when the window was made small.
It was reported on Discord by **Yberamos**, and chasing it turned up a second panel with the same
fault that nobody had noticed. That is what a good bug report does.

The foot now scrolls with the rest of the content instead of sitting in reserved space, and the
panel follows the addon's own text-size slider like everything else.

## Smaller

- `/mh binds` now names any ability we have no place for yet. That count was the only thing
  standing between the three empty keys above and nobody noticing.
- The rare tooltip no longer claims a kill was done "on this character" when it was not.
- Two new diagnostics, `/mh questsnap` and `/mh sniff`, for finding a quest id or an event by
  watching it happen instead of guessing at it.
