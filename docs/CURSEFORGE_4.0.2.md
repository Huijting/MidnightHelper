# Midnight Helper 4.0.2

A repair release. The biggest fix is one most players never saw fail: the marker bar.

## The marker bar works for everyone

- **It now works on every client language.** The raid marker bar wrote its commands in English, and
  those commands are translated per client, so on German, French and other clients its buttons did
  nothing at all. They now ask the game for the right words.
- **"Clear all world markers" works again**, and one click is one action. The buttons fired twice per
  click before, which made you hit the game's "You can't do this right now" limit sooner.
- **You can see which flares are down:** a world marker button wears a gold ring while its flare is
  on the ground, also when someone else in the group placed it.
- **New group buttons** next to the markers: ready check, role check and a pull timer (left-click 10
  seconds, right-click stops it). They are dimmed, with the reason in the tooltip, when you are not
  the leader or an assistant, because the game ignores them then.
- `/mh mark check` shows what the buttons use on your client.

## Keybind advice: Z, X and C mean the same on every character

On every class and spec, the bare **Z**, **X** and **C** now hold a defensive, or stay empty. Before,
**X** often held a dispel or crowd control (Purge, Fear, Shiv, Cleanse Toxins), so the key meant
something different on each alt. Those spells move to the Shift and Ctrl layers of the same keys.

## Interrupt card

- **Disrupting Shout** (Protection Warrior) is an area interrupt and now has a key; it had none.
- **Sigil of Misery** and **Void Nova** (Devourer) are listed as spells that can also stop a cast.
- Devourer no longer gets a key for Chaos Nova, which that spec does not have.

## Curse Surges on the Coiled Isle

- The Events screen showed a running surge as *Coming up — in 21 min*; those minutes were the time
  until it **ended**. A running surge now shows as running, with the time it has left.
- Surges are named after their boss, and a click on the running one sets a route there.
- `/mh surge` tells you which surge is up now and which boss is next, and when.

## Smaller fixes

- **Boss window:** the "open?" button after combat now only appears after a boss pull, not after
  every trash pack.
- **The Coiled Altar:** Guillotine needs 3 players outside Mythic, not 5, since Blizzard's hotfix of
  1 September.
- **Arcane Mage:** Arcane Orb is no longer listed as a burst cooldown to save; current guides use it
  as a normal rotation button.
