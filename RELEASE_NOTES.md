# Midnight Helper 5.10.0: which weapon, How you play in tabs, and your other characters in tooltips

Found something odd, or does everything just work? Tell us: `/mh report` in game, a comment here on CurseForge, or the
feedback form on midnighthelper.com.

This version adds new files: after updating, restart the game once (a `/reload` is not enough for new files).

## Both games: your other characters in tooltips

- **Recipes**: which of your other characters have that profession, with their skill. In WoW Forever also "needs 50",
  "can learn it" or "knows it".
- **Ingredients**: which of your other characters have a profession that uses it.
- **Weapons and armor you can send**: who can wear it, from which level, and whether its item level is higher than what
  they wear in that slot now.
- In WoW Forever only characters you can mail to: the same realm, and characters of the other faction are listed apart
  ("other faction, can't mail").
- A bank character? Mark it, and it is left out of "who can wear this": the **Bank** button on its row in Characters
  (Forever), or `/mh alttip bank <name>`.
- A character counts once you have logged in on it with this version. Don't want it? Switch off *Your other characters
  in item tooltips*, or `/mh alttip off`.

## Forever: which weapon?

How you play has a new block for every class: **Which weapon?** It tells you which weapon kinds suit you, which ones you
can already use, and where you learn the others (a trainer of your own faction, from which level). It changes with
your level and your race. Druids: in Bear Form and Cat Form your attacks do your weapon's damage per second, so a
two-hander almost always wins.

The stats sentence in Do this now starts with what counts most: weapon damage per second for fighters, spell damage or
healing for casters and healers. Warlocks: spell damage first, then Intellect and Spirit, which count the same.

## Forever: How you play in tabs

No more one long page. How you play now has tabs on the left: **Start**, **Your keys**, **Weapon & stats**, **Group**
and **Levels**, with the headings of the open tab under them. Click a heading to jump there. It remembers the tab you
used last. The text is the same, only divided. Every way in (`/mh play`, the key block, Do this now) opens this page.

## Forever: Gear check for enchants

- A small window next to your character window shows the enchant on every slot that can have one, or *no enchant*.
  Armor kits show their name.
- Do this now says how many slots have no enchant.
- Enchanters see which enchants they can make themselves.
- Don't want it? Switch off *Gear check: enchants next to your character window*.

## Forever: "better than what you wear" counts more

- The enchant (or armor kit) on what you wear now counts. If you would lose one, the line says so.
- Spell damage and healing on items count for casters and healers, and for Retribution and Protection Paladins.
  One-school lines (for example Fire damage) count only when your direction casts that school.
- This works the same in the tooltip, the quest reward hint, the pickup notice and the bags-full list.

## Forever: taunts on the mouse

With `/mh mouseover on`, Growl, Taunt, Mocking Blow and Distracting Shot go to the enemy under your mouse.

## Fixed

- The key block window no longer says "nothing changes" once your block is already on your bars.

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
