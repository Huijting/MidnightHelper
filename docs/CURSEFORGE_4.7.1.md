# Midnight Helper 4.7.1: key block fixes

Thank you for trying the new key block! Two things went wrong in 4.7.0, and they are fixed now.

## Mounts on your bars no longer block the key block

If you had **mounts** (or pets, toys or flyouts) on action bar 5, 6 or 7, the key block left them where they were. The
spells that belonged there, like Revive, Prowl or Dash, never landed, even though the picture showed them.

Now everything in the way moves aside to block D, just like spells and macros already did. **Undo** puts it all back
where it was.

**Placed the block in 4.7.0 and saw a mount where a spell should be?** Open `/mh block`, press **Undo**, then press
**Place it on bars 5, 6 and 7** again.

## Your play card shows the right key

- When a spell sits both on your key block and somewhere else, the play card now shows the **key block** key.
- Some specs have their own version of a spell with the same name, for example Wrath for Balance Druids. The play
  card now finds those too, so it no longer says "no key" for a spell that is right there on key 1.

## Better for players in other languages

About 360 spells in the key block now carry their exact spell ID, checked against Blizzard's own game data. In German,
French, Spanish, Portuguese and Italian game clients, the key block finds these spells by their ID, so they land on
the right key.

Something wrong? `/mh report` in game, a comment here, or the feedback form on midnighthelper.com.
