# Midnight Helper 2.8.1

A follow-up to 2.8.0, built almost entirely from in-game testing: the boss guide now
actually reaches you at the pull, plus a mount wishlist, a group-buff check and a Pawn
export — and a handful of things that turned out never to have worked at all.

## 🐉 The boss guide reaches you at the pull

The guide opens on the boss you are really fighting, taken from the encounter itself. When
combat hides it (so it stays out of your way), a small button now brings it straight back.

Before, in a follower dungeon, it appeared and vanished in the same instant — the NPC tank
pulls before you can target anything, and there was no way to get it back. Now there is.

## 🐎 Mount wishlist

Star any mount in the Mounts tab. "This Week" then reminds you which of *your* picks you are
still chasing — never a claim about every mount in the game, only the ones you chose.

- The star is the gold favourite star you already know from the mount journal.
- Clicking a reminder opens the Mounts tab.

## 🛡️ Know what your group is missing

- `/mh groupbuffs` — which raid-wide class buffs your group lacks, and who could cast them.
  Inside instances the game hides party auras from addons; when that happens it says so
  rather than reporting "all good" while blind.
- `/mh pawn` — your spec's stat weights as a Pawn scale string, ready to paste into
  **Pawn → Scales → Import**.

## 📖 Gear upgrade tracks, explained

A new Codex entry for anyone who has wondered what "Hero 3/6" on a tooltip means: the five
tracks low to high, why the track sets your item-level ceiling, that a rank costs that
track's crests plus a little gold, and where to upgrade.

## 🔧 Fixes

- **A phantom "Trovehunter Bounty detected!" popup** appeared in dungeons where no such
  bounty exists. Any toast without a title fell back to that text.
- **The addon icon and minimap button were never drawn.** Both image files were saved in a
  format the game cannot read, so they silently showed nothing.
- **Crash when opening the window inside a delve or follower dungeon** — the game hides your
  stats there, and reading them threw an error.
- **Crash when running `/mh pawn`**, and the same fault hardened in the Discord copy box.
- The Dawncrest guide showed "50%%" instead of "50%".
- The boss guide lost track of which dungeon you were in when you changed floors.
- Delve popups no longer appear in follower dungeons, which are not delves.

## 💬 Come say hi

There is now a Discord invite in Settings and on "This Week" — for questions, ideas, or if
you would like to help translate. The addon stays free either way.
