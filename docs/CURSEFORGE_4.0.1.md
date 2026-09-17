# Midnight Helper 4.0.1

A fix-and-polish release on top of 4.0.0, with one big repair: the advice on how to stay alive.

## Stay alive, rebuilt for every class

The **Stay alive** card in the Academy (DPS tab) used to take its advice from which key a spell sat
on. That put the wrong buttons under the wrong advice on nearly every class: a Retribution Paladin
was told to keep **Divine Shield** up before the pull, and saw **Blessing of Sacrifice**, which only
works on someone else, under "when your health drops fast".

Every class and spec has now been checked against current Midnight guides, spell by spell. Each
button sits in one of six steps:

- **keep this up** — only the things you really keep rolling, like Ironfur or Shield of the Righteous
- **a small one** — press it often, just before a big hit
- **a big one** — your emergency button, save it
- **heal yourself**, **get away** and **interrupt**

Where it matters, a short note says more: *only against magic*, *only against area damage*, *cast it
on yourself*, *breaks fear and charm*. Almost every class now has a "get away" row as well
(Disengage, Heroic Leap, Hover, Divine Steed…). Type `/mh survival` to see, per spell, why it is or
is not on your card.

## Cleaner cooldown lists

- Spells Midnight removed or made passive are gone from the damage, tank and healer lists (Icy
  Veins, Apocalypse, Storm, Earth, and Fire, Last Stand, Zen Meditation and more), and a few current
  ones were added, such as Wake of Ashes, Dark Transformation, Zenith and Convoke the Spirits.
- The tank and healer lists now show only the spells you actually have on your own spec.
- **Devourer** Demon Hunters get their own cooldown list instead of Havoc's.
- Your keybinds do not move. The one exception is a fix: Vengeance's **Metamorphosis** gets its key.

## Delves are as easy to find as dungeons

- Type a delve's name, or one of its bosses, in the search bar: it opens the **Delve Coach** for that
  delve, on that boss.
- Every delve in the Delves list has a small **book** button that opens its coach. Clicking the row
  still sets the route.
- The boss button on the quick bar opens the Delve Coach when you are inside a delve, instead of the
  last dungeon you looked at.

## New rares and a new hunt

- **Nine rares** the Rares page did not know yet: five in Voidstorm's Blackcore corner, two on
  Slayer's Rise and two on the Isle of Quel'Danas.
- **Elite rares say so**: an *Elite* tag in the list, and "bring a group" in the alarm and tooltip.
  Blackcore also tells you how to summon him.
- **Heroic Slugger** is an achievement hunt now: all nineteen Val and Naigtal rares, with a route.

## Smaller things

- **All settings inside Midnight Helper:** the Settings screen opens a full settings page in the
  addon's own look, in step with Blizzard's options panel.
- **Boss window:** the difficulty button moved to the top right, lines marked "Normal and Heroic"
  show on Normal again, the chat and share lines name your role, and the full chat list includes the
  DPS block.
- **Codex room:** the handbook chapters say *Codex handbook* under their name, so *Raid & crests*
  no longer looks like a second raid screen.
