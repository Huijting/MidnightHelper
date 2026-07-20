# Midnight Helper 2.8.4

Everything since 2.8.1, most of it found by testing rather than by writing new features.
Several things turned out to be answering confidently and wrongly — not crashing, just
quietly telling you something untrue. Those got fixed first.

## 📖 The Omnium Folio button now works everywhere

If your character has visited an old expansion's zone, the minimap landing-page button stays
stuck on that page — and "Open rune window" opened a Covenant Sanctum instead of your runes.
Pressing the button now puts it back on Midnight first, then opens the Folio.

It also identified the rune page by its English name, so on any other language it insisted
your button was on a different expansion while you were looking straight at Midnight's.

## 💰 The profession panel was quoting the wrong numbers

Artisan's Moxie and Unalloyed Abundance were reading currency ids belonging to something
else entirely — one of them a hidden internal counter the game uses for delve turn-ins,
others a cooking accolade and a jewelcrafting token shown under the wrong profession's name.
Those balances were then compared against recipe costs, so a recipe could be marked out of
reach based on a number that had nothing to do with it.

Every id that could not be verified in-game has been removed. The line now disappears
instead of showing a figure we cannot stand behind. If you see nothing where a Moxie balance
used to be, that is the fix.

## 🩺 Dispel reference for tanks and DPS

Your toolkit lists what your own spec can actually dispel. Previously only healers got this,
even though plenty of tank and damage specs carry a dispel — and it matters most when nobody
else is free to press it.

## 🎓 The Role Academy remembered DPS

DPS content was missing altogether. Not thin — absent. That absence was also hiding a crash.

## 🌍 Translations

The healer tips, dispel reference, consumable ready board and Mythic+ commands were English
only and quietly fell back to it everywhere else. They are now translated into German,
French, Spanish, Portuguese and Italian. These are working translations rather than
Blizzard's own in-game wording — if something reads wrong in your language, please say so.

## 🔧 Also in this release

- Fixed a crash when opening the profession panel.
- Fixed a burst of "tried to call the protected function" errors from the death recap in
  dungeons.
- New: a copy button for sharing ritual routes.
- Ritual Sites now read as tiers 1–6.
- Season 2 content appears when the season actually opens, not when the patch lands.
- The Mythic+ interrupt notes name the dungeons we have no data for, instead of skipping
  them silently, and the consumable ready board says when the game is hiding information
  from it rather than implying all is well.
