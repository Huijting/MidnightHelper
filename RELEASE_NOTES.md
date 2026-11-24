# Midnight Helper 5.9.0: a key block with the same 12 keys on every bar, and a group check

Want new things sooner and help test them? We put out betas regularly: set the release type of Midnight Helper in the
CurseForge app to **Beta**. Found something odd, or does everything just work? Tell us: `/mh report` in game, a comment
here on CurseForge, or the feedback form on midnighthelper.com.

Everything in this release is for **WoW Forever**.

## Key block: a second layout, "12 x 4"

The old key block stays the default. Want the new one? Type `/mh block undo` if your block is placed, then
`/mh block style 12x4`, open `/mh block` and place it again.

- **The same 12 keys on four bars**: 1 2 3 4, Q E R F, Z X C V. First without a modifier, then with Shift, then with
  Ctrl, then with Alt (your own bar). No more 5, T, G or F1-F4.
- **The same job on the same key, for every class**: E is your interrupt, R moves you, Z X C are your defensives, V is
  crowd control, and if you heal, C is your big heal and Shift-C your quick heal. Which spell goes where was worked out
  per class, so you don't have to guess for a class you never played.
- **Ctrl holds your things**: Ctrl-F bandage, Ctrl-Z health potion, Ctrl-X mana potion, Ctrl-C healthstone, Ctrl-V
  trinket. Midnight Helper puts the best one from your bags there.
- **Why these keys?** A button in the key block window explains the job of every key, without spell names.
- **One layout for all your characters**: your keys count for every Forever character. When a character still has the
  other layout on its bars, Midnight Helper says so at login, with a *Fix it now* button.
- **Two extra keys, if you want them**: Midnight Helper asks once. 5 becomes *Interact With Target* (talk to, loot or pick
  up what you target; a key you already had for it keeps working), and Shift-Space calls your fastest mount. A character
  without a mount gets it as soon as it learns one. Undo any time: `/mh block extras off`.
- Placing the block now also frees the keys of the other layout, so no old key keeps pressing a block button.
- At a low level, a key whose spell you don't have yet holds the spell you do have (for example Immolate on 3 for a
  young Warlock). A spell is never asked for on two keys, and *Later* on a question about a new spell is remembered.

## How you play shows your keys

*How you play* now names the keys of the layout you chose, for all nine classes. A spell without a key in that layout
says *block D*.

## Do this now

- **Upgrades in your bags** come first, with *Wear it* and *Not this one*. Switch it off in the settings if you don't
  want it.
- A **How you play** button opens the play card of this character.
- Left of your money you see how many **free bag slots** you have: orange when almost full, red when full.
- Your class quest card and *Do this now* show **how far you are**, for example "Vile Familiar Head: 4/6".

## Group check: buffs and consumables

A new window for your group, like the ready check window in Midnight. It opens at a ready check and with
`/mh readyboard`. Per player: the class buffs (Arcane Intellect, Fortitude, Mark of the Wild, a Blessing) and who in the
group can give them. For yourself also your elixir, food, weapon buff, health and mana potion, and a healthstone when
there is a Warlock in the group. Click a buff you can give to cast it. It closes when a fight starts. Don't want it at
every ready check? `/mh readyboard auto off`.

## Dungeon quests and QuestieDB

- If you have the **QuestieDB** addon installed, Midnight Helper uses its quest data where it has no place of its own: in the
  dungeon quest lists, and a *Ready to turn in* line with a button for the arrow in *Do this now*. Midnight Helper's own
  data always comes first. Switch: *Use QuestieDB if you have it*.
- A quest that has two versions with the same name shows one row, and doing either one counts for the quest after it.
- A quest you only get inside the dungeon is listed under the quests you get inside.

## Fixed

- The trainer arrow no longer sends you to a trainer far away when the trainer next to you can teach you.
- Warrior: key 3 no longer holds Mortal Strike when you don't have that talent; it uses Bloodthirst or Shield Slam.
- Priest: *How you play* no longer says that Chastise does not work in Shadowform (it does since the hotfix of 23 Nov).
- The buttons of Midnight Helper's questions are now in your own language.
- No more error at login when a macro on a key block button was lost, for example after the game was shut down
  suddenly. Midnight Helper puts the right macro back.
- In the old block, T and Shift-T use Forever's health potions and healthstones.
- A few class quest facts were corrected.

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
