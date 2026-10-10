# Midnight Helper 4.7.6 (beta): swap your keys with one click, and Bartender and ElvUI

## This is a beta

This version is a **beta**: it goes to players who set the release type for Midnight Helper to **Beta** in the
CurseForge app. Everyone else gets it a little later, once we know it works on more characters than ours.

**Tell us how it goes, also when everything works.** A short "works fine with my Bartender bars" helps us as much as
a bug report:

- `/mh report` in game, or *Report a problem* in Settings,
- a comment here on CurseForge,
- or the feedback form on midnighthelper.com.

## Which spells you press, now in a window (`/mh presses`)

4.7.5 counted which spells you press and printed it in chat. That was hard to read, so it is a window now: your
most-pressed spells, how often, the key each one sits on, and whether that key is **easy, okay or hard**.

- **Swap with one click.** Every tip has a **Swap** button. MH moves the two spells on your bars for you, out of
  combat and one swap at a time, and tells you which key each one is on now.
- **Undo** takes your swaps back one at a time, newest first, or **all at once**. It still works after a /reload.
- **Heals, interrupts and defensives never move.** You reach for those by habit, in a hurry, so a tip never touches
  them.
- **More places to swap to:** after a few fights, an easy key holding a spell you never pressed counts as a good spot
  for a busy one.
- Counting is still off until you turn it on: `/mh presses on`, or the button in the window.

## Bartender4 and ElvUI

`/mh presses` and the *How you play* card now find the key a spell sits on in **Bartender4** and **ElvUI** bars too,
not only on Blizzard's own. `/mh playkeys` says which bar addon each key came from.

We wrote this from the code of both addons, but we do not run them ourselves. **If you use Bartender or ElvUI, you
are exactly the tester we need:** type `/mh playkeys` and tell us whether the keys match your bars.

## Key block: all your characters at once

The key block's **Cheat sheet** has a new button, **All characters**. Every character that has the key block placed
keeps its code, so one copy box holds them all, each with the date it was last updated. Paste them on
midnighthelper.com in one go and print a sheet per character.

## Small things

- **Marker bar** (`/mh mark`): a new button marks the **tank** with a blue square and the **healer** with a green
  triangle in one click, from your group's roles. Only one of them in the group? Then only that one is marked.
- **Settings:** five switches that had no button now have one: the short pop-up notes (toasts), the Trovehunter's
  Bounty toast, the sound for new things to open, the Delve items window opening by itself, and how many extra mouse
  buttons the key layout may use.
- **Codex, Starting the Midnight campaign:** lost the quest? Stormwind, Orgrimmar or the Adventure Guide offer it
  again. And the skip line only appears once a character on your account has the *Midnight* achievement.
- **Raidbots export** (`/mh raidbots`): race ids 95 and 96 get the race name SimulationCraft expects.

New text in German, French, Spanish, Portuguese and Italian is our own translation: native speakers, corrections
are very welcome.

Have fun!
