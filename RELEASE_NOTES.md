# Midnight Helper 5.11.0: which click heals what, a travel planner with flight paths, and help after you die

Found something odd, or does everything just work? Tell us: `/mh report` in game, a comment here on CurseForge, or the
feedback form on midnighthelper.com.

This version adds new files: after updating, restart the game once (a `/reload` is not enough for new files).

## Both games: which click heals what

- A big card with a drawn mouse shows which click heals what on your group frames, live: hold Alt, Ctrl or Shift and
  the card shows that layer. Every spell has its own tooltip. Open it with `/mh clickcard`. Size with Shift+scroll; it
  can be see-through outside a group.
- It reads your active DandersFrames click profile. Without one it shows Midnight Helper's own layout.
- **On paper:** the button *Print (website)* gives the key block code, now with your clicks in it. Paste it on
  midnighthelper.com (Key block page) for one sheet with your keys and your clicks, per layer, with spell and rank.
  Spells you have not learned yet say so ("level 24", "talent").

## Forever: heals on a click on your group frames

- Switch on *Heals on a click on your group frames* (needs the DandersFrames addon): Midnight Helper makes a click
  profile with the heals, dispels and res your character knows, and keeps it up to date when you learn a new spell or
  rank. Druid, Priest, Paladin and Shaman. Switch it off and what DandersFrames had before comes back.
- *Keep left-click for targeting* (on by default): a plain left-click still targets and right-click opens the menu;
  the heals are on Alt and Ctrl. Good when you heal on the side, or in Cat or Bear Form.
- Druids also get Wild Growth, Rebirth (Shift + middle button) and Innervate once they have them.

## Forever: the way there, with flight paths

- The arrow and "The way there" now use flight paths you know, boats, zeppelins and your teleports and Hearthstone,
  and pick the quickest. Midnight Helper learns your flight points each time you open a flight map, and times your own
  flights and boat rides, so the minutes get better as you play.
- A small route panel next to the arrow shows every step with its time (minutes:seconds) and the total. On the flight
  map, the stop to click has a gold ring. Don't want it? Switch off *Route steps next to the arrow*.
- The trainer arrow picks the trainer you reach quickest, not the one in a straight line. Teleport: Moonglade counts.
- Class quest cards say how you get there, and say "upstairs, inside" when the person you need stands upstairs.

## Forever: class quests

- Kill and collect steps point at the nearest of all the places where that creature or item is ("3 areas, this one is
  nearest"), and at the spawn closest to you.
- Mouse over a step that asks for an item (Earthroot): the game's tooltip, how many you have, and which of your other
  characters have it and whether they can mail it to you (with the Syndicator addon).
- Curing the Sick: a warning to use the salve only out of combat, and how many doses you have left against how many you
  still need.

## Forever: rares

- A window when a rare comes into sight, with buttons to target it, show it in Find, or set a waypoint.
- The rare in 3D, in that window and when you hover a rare in Find.
- Midnight Helper remembers what you looted from each rare and shows it ("Your loot (3 kills)").

## Forever: after you die

- A window shows how far your corpse is, how long the run takes as a ghost, what the Spirit Healer costs at your level,
  and has an arrow to your corpse. Close it and it stays closed for that death. The arrow goes away as soon as you live
  again. Don't want it? Switch off *Window after you die*.

## Forever: more

- **Do this now** always shows how worn your gear is, next to your free bag slots: green, yellow or red. Mouse over it
  for your most worn items and the nearest vendor who repairs; click it for the arrow there.
- **Your race** in How you play, tab Start: what your race gives you, for your own class.
- **Gear check** also shows your legs, and updates as soon as you enchant something.
- **Oath of Light** lasts 1 hour since the Forever hotfix of 25 November; the Holy Paladin text says so.
- **Quiet helpers** has more settings that work in Forever: the missing buff icon, the upgrade notice, the arrow size
  and meters, the minimap icon, the quick bar, and the cast warning bars.
- Commands that only work in Midnight are hidden in Forever, and say so when you type one.
- The key block code names your whole character ("Ima Druiddude"), and shows the spell behind each of Midnight
  Helper's own key macros.

## Both games: more

- **Move** has a Done bar at the top (or press Escape), and the cast warning bars can be moved too.
- **Thank strangers for a buff**: a buff you get during a fight is thanked when the fight ends.
- **Key block**: Undo never takes off what you put on a button yourself, and the window says first what Undo will do.
  *Update* also puts back what is missing.

## Fixed

- Forever: Move no longer stops with an error on some bars.

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
