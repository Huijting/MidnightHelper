# Midnight Helper 5.8.0: class quests on a card, dungeon quests, and where you get that recipe

Want new things sooner and help test them? We put out betas regularly: set the release type of Midnight Helper in the
CurseForge app to **Beta**. Found something odd, or does everything just work? Tell us: `/mh report` in game, a comment
here on CurseForge, or the feedback form on midnighthelper.com.

Everything in this release is for **WoW Forever**.

## Your class quest, on a card

The small class quest window is now a card in your class colour: the quest, who to see, where, what it is for, and
*Show the way*.

- **The level 1 class quest**: the note that sends a new character to the class trainer, for all 56 combinations of
  class and race (Skyborne get theirs at level 2). It appears once you have handed in the quest before it. Skipped it?
  It is shown up to level 5. A class quest for a spell always comes first.
- **Trainer places**: many places in the class quests now come from Zygor's guides. If you have HandyNotes: Class
  Trainers, the arrow uses that addon's place while you play, unless Midnight Helper has a measured place or you
  talked to that trainer before.

## Which quests before a dungeon

In *Dungeons & group*, a dungeon with quests has a **Quests** button: what to pick up first and from whom, what is
already in your log, what you get inside, what comes later in a chain, and what you have done. It knows 471 quests in
32 dungeons and wings. Where it knows the place, a button sets the arrow. The numbers and places come from Zygor's
dungeon quest guides and have not all been checked in the game. Some quests have no place.

## Where do I get this?

- **Recipes you don't know yet**: the tooltip and *Skill up* say where you get them: a trainer, a vendor, monsters, a
  quest or with the profession, and what it needs. That is 1,102 of the 2,119 recipes we know of; 206 of those can
  have an arrow to a person. When the answer may be old, it says *Classic data, not yet seen in Forever*. When it
  doesn't know which trainer or vendor, it says so.
- **Ingredients**: for 194 of them the tooltip and *Skill up* say whether monsters drop it, which profession gathers it
  or who sells it. Monsters have no place. For a known vendor, *Skill up* has a button for the arrow.

## Your next talent, for all nine classes

5.7.0 had this for Paladins. *Do this now* can now name your next talent for every class, in these directions:

- Warrior: Arms, Protection
- Paladin: Retribution, Protection
- Hunter: Beast Mastery
- Rogue: Combat
- Priest: Shadow, Holy
- Shaman: Enhancement, Restoration
- Mage: Frost
- Warlock: Affliction, Destruction
- Druid: Feral, Restoration

Each order follows one public guide. Other directions get no talent line. The line is now on top, in gold, and names
your own key for Talents. The Talents button is gone: opening that window from an addon could cause "action blocked".

## Bags full

- **Protected from Destroy**: food and drink, ammunition, class reagents, poisons, potions, elixirs, flasks, bandages,
  scrolls, keys, bags, recipes and books, and pets, mounts and other things you learn from are no longer suggested.
  In 5.7.0 some of these could be.
- **Earlier help**: the window also opens when your bags are almost full (2 free slots; `/mh bags <0-10>` changes
  that). Switch: *Help when your bags are almost full*.
- **A spare bag first**: with an empty bag slot and a spare bag, the window offers to put that bag on.
- Grey items that are worth nothing at a vendor can be suggested too. *Destroy* still asks first.

## XP per hour

Under the XP bar of the overview you see how long your next level takes at the pace of your last hour of play. The
tooltip has your XP per hour. Switch: *XP per hour and time to the next level*.

## Fixed

- `/mh rest on`, `off`, `mana` and `health`, for the low mana and health warning, were broken in 5.7.0 and are repaired.
- The Earth Totem quest of Dwarf and Windshaper shamans no longer sends you to the giver of its first quest before
  that quest is open.
- *Skill up* now keeps each character's known recipes from that character's own profession windows; somebody else's
  linked profession no longer counts.
- The *Skill up*, *Bags full*, worn gear and *How you play* windows now have a solid background. The trainer button
  in *Skill up* names the profession.
- The Hunter text in *How you play* now says that most guides pick Beast Mastery for levelling, not every guide.

## Credits

- Includes data from "Polestar Recorder sessions" by the Polestar authors
  ([github.com/fitzforge/polestar](https://github.com/fitzforge/polestar)),
  [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/), filtered and reduced. The Polestar authors do not
  endorse Midnight Helper.
- Includes data from [AllTheThings](https://github.com/ATTWoWAddon/AllTheThings), MIT licence (the licence text is in
  the addon).
- Quest names and quest order include data from the Spoken addon, partly from
  [Efficient Games](https://efficient.games), [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/), reduced.

Have fun!
