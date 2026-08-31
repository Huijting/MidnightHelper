# Midnight Helper 3.7.3

Corrections, almost all of them. Things the addon said that were wrong, in five professions and
four languages — plus one thing it never said at all.

## The profession advisor went quiet for entire professions

You could stand in front of Enchanting with 235 Knowledge Points in hand, a finished branch
behind you, and get no advice at all. Not a wrong recommendation — nothing.

The cause is worth saying plainly, because it explains why it hit some professions and not
others. Our routes name each step by its name, and Blizzard's own vocabulary sets a trap here:
in the API a **node is called a path**, and a node and a tab are reached by different calls. So
a step written as a tab but actually pointing at a node matched nothing — and one unreadable
step abandoned the rest of the route with it. Steps three and four never got a chance.

Twelve steps across five professions were written that way. All eleven professions have now been
checked against a real client, one character at a time, and a checker runs over them so this
particular fault cannot come back unnoticed.

**Skinning is the clearest example of why guessing could not have fixed this:** `Lasting Leather`
is a **tab** in Leatherworking and a **node** in Skinning. Same name, two different things, and
no guide or website records which is which — that layer simply is not written down anywhere
outside the game.

## It was picking a branch for you and not saying so

Where a route reached a genuine fork, the advisor named one option. It looked like the answer.
It was the first one in our list.

Enchanting has three disenchanting branches and three enchant families, and which you want
depends on what you actually do with the profession. The advisor now names **all** of them and
says the choice is yours. The Enchanting chapter has gained a section on the three families,
with what each one is for — measured in the game's data, twice, independently.

Mining's chapter had the opposite problem: it never mentioned its own first step, so anyone
following it skipped a node and wondered why the numbers did not add up.

## Four languages had delve tips written by a translation machine

German, French, Spanish and Portuguese delve tips were machine-translated in one batch a while
back, and it shows once you look. Some of what that produced:

- The French text told you to **ransack** the mana containers. The English means a rifle.
- "Wipe risk on high tiers" came out as **"eliminates the risk"** — the opposite advice, in two
  languages.
- The Portuguese warned you to avoid **sadness**, where the English says *grues* — the monsters
  that live in the dark.
- The boss name **Mycomight** had been translated into Spanish as "my power".
- The word *delve* appeared as five different words in one Portuguese file.

All four have been rewritten from the English by native-level translators, not patched. Zone
names now appear as **your own client shows them** — *Bosques de Canción Eterna*, *Floresta do
Canto Eterno* — which they did not before.

## The delve companion had the wrong name in Portuguese

She is **Valira Sanguinar** in a Portuguese client. We wrote Valeera everywhere except one
hand-written block, and that block turned out to be the one that was right.

The other four languages were checked rather than assumed, and all of them do keep Valeera — so
nothing changed there. One language localising a name says nothing about the next one.

## Five spell links were not links, and one sentence nobody could translate

Five abilities printed as plain lowercase words instead of spell links you can hover —
`void bolt patram` where a tooltip belonged. They have real IDs now, each one tied to the boss
that casts it. That mattered more than it sounds: there are around 125 spells named "Void Bolt",
and the obvious one is used by 85 other creatures and not by this boss.

And one line was ambiguous in our own English — two translators read it in opposite directions,
which is how we noticed. It now says what the game actually does: pick up the rifle, use Galvanic
Blast on the mana containers until the Arcane Barrier drops.

## Smaller things

- The bottom of Professions → Overview drew two paragraphs on top of each other. The bug had
  always been there; a longer advice line was what finally exposed it.
- *Ruins of Deathholme* is spelled **Deatholme**, with one h.
- Reporting a bug on GitHub gave you an empty text box. There is a proper form now — and it says
  in as many words that "it told me something wrong" counts as a bug. An out-of-date explanation
  is a worse fault in this addon than an error message, because nothing on screen looks broken.
