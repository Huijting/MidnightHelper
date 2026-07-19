# Midnight Helper 2.8.2

A correctness release. Most of this came out of testing 2.8.1 in-game and finding that a few
things had been quietly telling you the wrong thing — not crashing, just answering
confidently and incorrectly. Those are the worst kind, so they got fixed first.

## 💰 The profession panel was quoting the wrong numbers

Artisan's Moxie and Unalloyed Abundance were reading currency ids that belong to something
else entirely. One turned out to be a hidden internal counter the game uses for delve
turn-ins; others were a cooking accolade, an inscription tracker and a jewelcrafting token,
each displayed under the wrong profession's name.

Worse, those balances were being compared against recipe costs — so the panel could tell you
a recipe was out of reach based on a number that had nothing to do with it.

Every id that could not be verified in-game has been removed. The line now disappears
entirely rather than showing a figure we cannot stand behind. If you see nothing where a
Moxie balance used to be, that is the fix: better to say nothing than to guess.

## 🩺 Dispel reference for tanks and DPS

Your toolkit now lists what *your* spec can actually dispel. Previously only healers got
this, even though plenty of tank and damage specs carry a dispel — and it matters just as
much when nobody else is free to press it.

## 🎓 The Role Academy remembered DPS

DPS content was missing altogether. Not thin — absent. Its absence was also hiding a crash,
which is part of why it went unnoticed for so long.

## 💙 More healer boss tips

Bosses in Magisters' Terrace and The Blinding Vale now carry healer callouts, and they
distinguish between three jobs that are easy to confuse:

- a debuff on a player you cleanse,
- a buff on the **boss** you purge — a different action, with different spells,
- a wound that simply needs someone healed back to full.

Telling you to cleanse something no cleanse can touch would be worse than saying nothing, so
each one is named for what it actually is.

## 📖 Omnium Folio button on non-English clients

The "Open rune window" button identified the rune page by its English name. In any other
language that check could never match, so those players were told their button was on a
different expansion while looking straight at Midnight's. It now asks the game directly.

It also no longer claims success when no window opened — it checks, and speaks up if nothing
appeared.

## 🔧 Also in this release

- Fixed a crash when opening the profession panel.
- Fixed a burst of "tried to call the protected function" errors from the death recap in
  dungeons. It now detects being refused instead of assuming it worked, and can no longer
  produce more than a few of these in a session whatever else goes wrong.
- New: a copy button for sharing ritual routes.
- Season 2 content now appears when the season actually opens rather than when the patch
  lands — those are about a week apart.
- The Mythic+ interrupt notes name the dungeons we have no data for, instead of quietly
  skipping them.
- The consumable ready board says when the game is hiding information from it, rather than
  implying all is well.
