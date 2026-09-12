# Midnight Helper 3.11.1

A small release: the fixes that came out of the first day with 3.11.0.

## Routes into the corners of a zone

Treasures, rares and achievement spots in **Slayer's Rise**, **Val**, **Naigtal** and similar places
sit on their own small map inside a zone. The arrow looked up where such a map lies in a table of its
own, and it got lost: in Silvermoon it pointed at a flight master while the travel popup said
*Portal to Voidstorm*, in Voidstorm it sent you back, and once it said to head for Orgrimmar.

- The arrow now asks the game which zone a map belongs to, the way the travel popup already did, so
  the two agree.
- Inside Midnight's zones it no longer tells you to go to your capital first.
- Tested on the treasure that started it: from Silvermoon, through the portal, to the vial in
  Slayer's Rise.

## No error when you ask for a route in combat

Asking for a route during a fight — a profession treasure, for example — raised a blocked-action
error, because the travel popup moves a protected Hearthstone button. The arrow is now set straight
away and the popup is skipped in combat; click the route again after the fight if you want the
portal advice.

## Delve Coach: Replicating Venomborne

The final boss of *Fungal Pharmacon* in **The Grudge Pit** and *Eggsplosive Growth* in **The
Darkway** was missing from the coach. He is in now, with his model and a boss line on
**Serpentogenesis**, **Venom Splash** and **Hydra Strike**. The coach also stopped naming the
optional exit step (*Leave-O-Bot*) as the story you are in.

## Trovehunter's Bounty works anywhere

You can use the map outside a delve: its buff lasts until your next **Tier 4+** delve, which then
ends in a Hidden Trove. Midnight Helper said "active in delve"; in every language it now says what
the map actually does, and it recognises the Season 2 buff.

## From Blizzard's 10 September hotfixes

- **The Lost Explorers:** interrupt Mor'zahi's *Final Ascension* whenever you can — since the
  hotfix, that resets his rising damage.
- **Twilight Crypts:** the *Loosed Loa* variant now has Explorer's League Supplies and an Abandoned
  Restoration Stone.

## What we are working on next

No dates, and nothing here is a promise:

- **A new look, version 4.0.0:** an icon for every screen and larger pop-outs.
- **Weekly ticks for quest givers whose quests rotate**, like Lady Liadrin. The first reset after
  3.11.0 decides which record to trust.

If something in the addon is wrong on your screen, saying so is the fastest way it gets fixed —
everything above started as exactly that.
