# Midnight Helper 5.9.1: the 12 x 4 key block in Midnight, and Ctrl+Shift+click to disenchant in Forever

Want new things sooner and help test them? We put out betas regularly: set the release type of Midnight Helper in the
CurseForge app to **Beta**. Found something odd, or does everything just work? Tell us: `/mh report` in game, a comment
here on CurseForge, or the feedback form on midnighthelper.com.

## Midnight: the 12 x 4 key block

The second key block layout from Forever is now in Midnight too. The old block stays the default.

- **The same 12 keys on every bar**: 1 2 3 4, Q E R F, Z X C V. First without a modifier, then with Shift, then with
  Ctrl, then with Alt.
- **The same job on the same key, for every spec**: E is your interrupt, R moves you, Z X C are your defensives, V is
  crowd control. Healers: C is your big emergency heal, your normal heals are on 1, 2 and 3. Which spell goes where was
  checked per spec.
- **Ctrl holds your things**: Ctrl-F combat potion, Ctrl-Z health potion, Ctrl-C healthstone, Ctrl-V and Ctrl-X your
  trinkets.
- **Why these keys?** explains the job of every key.
- **Two extra keys, if you want them**: 5 becomes *Interact With Target*, and Shift-Space calls Blizzard's random
  favorite mount. Press it again to get off, but never in the air.
- Does Blizzard's Single-Button Assistant sit on one of your keys? Midnight Helper never covers it. Drag it to another
  place, then press *Update (add new spells)* in `/mh block`.

## Key block: switch with one button

- A **Layout** button in the key block window (`/mh block`) switches between the old block and 12 x 4. Midnight Helper
  takes the block off your bars, switches, and places it again. Click again to go back.
- The trinket places only show a trinket with a *Use:* effect, because only that one can go on a key. The tooltip names
  the trinket you wear.

## Forever: disenchant with Ctrl+Shift+click

For enchanters: hold **Ctrl+Shift** and click a weapon or armor in your bags, and Midnight Helper disenchants it. It
works in Blizzard's bags and in Baganator. The tooltip tells you when an item can. Never in combat, and without Ctrl+Shift
your bags work as always. Don't want it? Switch off *Ctrl+Shift+click disenchants* in the quiet helpers.

## Forever: buffs

- The buff button casts your buff **on you**, whatever you target. No more clicking yourself first.
- No more *runs out soon* when someone else gave you a stronger version than you know (a higher rank, or a group buff
  like Arcane Brilliance). Your own cast could not replace it anyway. When it is gone, Midnight Helper asks for yours.

## Forever: key block

- The buttons show the icon of what the key does **now**: in Bear Form you see Maul and Growl, not Wrath.
- A spell you just learned, for example from a quest, is on its key right away.
- The trainer window names the keys of the layout you use, with the form when a key only works in a form, for example
  "Maul -> 1 (Bear Form)".

## Fixed

- Dutch: the *Doe dit nu* window is called by its Dutch name everywhere.

## Credits

- Includes data from "Polestar Recorder sessions" by the Polestar authors
  ([github.com/fitzforge/polestar](https://github.com/fitzforge/polestar)),
  [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/), filtered and reduced. The Polestar authors do not
  endorse Midnight Helper.
- Includes data from [AllTheThings](https://github.com/ATTWoWAddon/AllTheThings), MIT licence (the licence text is in
  the addon).
- Quest names and quest order include data from the Spoken addon, partly from
  [Efficient Games](https://efficient.games), [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/), reduced.
- Uses QuestieDB's quest data if you have QuestieDB installed; none of it is included in Midnight Helper.

Have fun!
