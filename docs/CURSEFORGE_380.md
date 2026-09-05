# Midnight Helper 3.8.0

Two things this release is mostly about: the boss advice is now checked against a source that has to be right, and the addon stopped sending you places you cannot use.

## The tips are measured now, not written

Every spell ID in our raid, dungeon, delve and ritual tips was held against **DBM's own boss mods**. DBM has to get these right to do its job, so it is the hardest source available short of the encounter itself.

It found bullets we could not stand behind. **21 of them named abilities DBM never warns on** — those are gone rather than reworded, because a tip about a spell that does not fire is worse than no tip. The Venomous Abyss, Rotmire, Taz'Rah and Nalorakk are rewritten from DBM's warning lists, and four thin raid tips were refilled from the same place.

A check in the build now holds every new tip against DBM, so an ID that means nothing cannot ship again. Thirty-three known gaps remain and are listed as gaps rather than quietly carried.

Separately, advice for what your **role** has to do was missing in thirteen places. Ninety-one lines added, found by reading Zygor's dungeon guides beside our own — where two guides agree we can say it plainly, and where they disagree we now know to look instead of guessing.

## Routes to content you cannot reach yet

Midnight Helper would happily route a level 70 to a rare in Voidstorm and say nothing about it.

It now says so — on screen, with a sound — and names the level the area is built for. **The route is still set**, because looking up where something stands is useful at any level, and there is a setting for players who would rather be held back. Below level 78 a red bar across the top of the window says the addon is aimed above you.

One thing is measured rather than assumed: **the game does not stop you walking in.** A level 70 took the portal and walked into Silvermoon. So the wording says "this area is built for level 80 and up" and never "you cannot go there".

## Routing faults that failed silently

- In Harandar the portal advice pointed at **open water**. The coordinate had been inherited from a bulk import in May and never measured; the portals are inside The Den.
- Stepping through a portal on a rare route left TomTom with **no arrow at all**, so for anyone running it the route simply ended at the door.
- An arrow was drawn **pointing straight up** when there was no direction to give. Refusing to guess a direction was right; leaving a shape on screen that still looks like the answer was not.
- From outside Midnight there was **no answer at all** to "how do I get there". It now names your own capital and hands over to the portal once you are standing in it.
- Routing to a portal did not end when you went through it — the addon would turn you around and send you back.

## One map, three zones

Silvermoon, Voidstorm and Harandar sit side by side on a single map. Six places in the addon read that map without asking **where** on it, and answered "Silvermoon" while you stood in Harandar.

The worst of them decided which rare list to watch. On two thirds of that map, nearby rares were compared against the wrong zone and matched nothing at all — no alert, no error, nothing to notice.

## New: Dundun

He hides in Bountiful delves and hands out an extra reward for finding him. The addon says when he is worth looking for and what opening the extra chest actually costs.

He is not always a fake tree — a tester found him as a pole — so the description gives you the tell instead: planks and screws, paint instead of bark, something built rather than grown.

## Smaller

`/mh report` for when the addon tells you something wrong. The Codex is now readable on the web. Guards for an item function Blizzard removes in 12.1.5. And three new diagnostics — `/mh zonegate`, `/mh travelwhy`, and a new line in `/mh arrow` naming which part of the addon set your route — for the times it goes quiet and you cannot tell whether that is on purpose.
