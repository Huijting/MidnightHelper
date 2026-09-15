# Midnight Helper 4.0.0

Same addon, new coat of paint. Everything you used in 3.x is still there. It looks different, and you
now decide more of what you see and where it sits.

## Rooms with cards

Click **Me**, **Codex** or **Tools** on the left and you get a card for every screen in that room:
its icon, its name and, where the addon already knows it, one line of status — *weekly things done*,
*Great Vault 2 / 9*, *Missing enchants: 7*. Click a card to open the screen.

The long list of tabs under the rooms is gone; the cards replace it, and the window opens on your
**Me** cards.

## An icon for every screen

Every screen has its own icon, shown in a strip at the top with one line on what the screen is for.
The window has new colours as well: deep twilight violet with warm gold. The pop-up cards, like
*Rare nearby*, follow the new look too, and the rare's 3D model in them now moves instead of standing
still. So does the Rares page: flat rows, a rare that is up in green, one you killed this week muted
and marked done instead of green as well, and the distance to every open rare in its row.

## Your screens, your order

- **Hide what you never use:** right-click a card and pick *Hide this screen*. A line under the cards
  counts what you hid and brings it back.
- **Put them in your order:** drag a card to where you want it. Every room remembers its own order,
  and right-click → *Reset the order* puts it back.
- **The favourite buttons under the search bar** drag the same way.
- **All screens in one list:** Settings → *Choose your screens*. The same list is in Blizzard's
  settings under Midnight Helper → Screens.

Hiding only takes a screen out of the lists. Search and links still open it, and its alerts keep
working. **This Week** and **Settings** always stay.

## Prefer the old look?

In Blizzard's settings for Midnight Helper, tick **Classic look (as in 3.x)**. Every screen goes back
exactly as it was, with the long tab list. Untick it for the new look again. The **Classic** / **Modern**
button at the top right of the window does the same in one click.

## Raids: The Tidebound Grotto, and a route to every door

The Raids page now lists **The Tidebound Grotto** as well, below the four raids. Open a raid and a
*Route to ...* button sets a waypoint to its entrance, the same button the Dungeons page already had.

## Silvermoon City: Dungeons & Raids

The Silvermoon City screen, where the portals are, has a new **Dungeons & Raids** block: The Dreamrift,
The Voidspire, March on Quel'Danas, The Venomous Abyss, The Tidebound Grotto and the Midnight dungeons,
each one click away from a route to its entrance.

## Silvermoon City in cards

In the new look the Silvermoon City screen shows its places as cards, with new icons for portals, flight
masters, M+ teleports, the bank, the auction house, the inn, item upgrades, the mailbox, transmog, the
Creation Catalyst, crests, the weekly quest givers, the PvP hub, every profession and gathering trainer
the training dummies, crafting orders, the specialization reset, the Prey hub and Magister Astalor. The
Classic look keeps the buttons from 3.x.

## Raid tips, rewritten

We checked every boss tip against DBM's current encounter mods and the current guides. The spell
links were right, but the advice often was not: several tips said the opposite of what the fight
needs. All 17 raid bosses are rewritten: The Venomous Abyss, The Dreamrift, The Voidspire and March
on Quel'Danas. Normal comes first, the Heroic and Mythic rules are marked, and tanks, healers and
damage dealers get their own lines.

The eight Season 2 Mythic+ dungeons got the same treatment. The 17 bosses of Altar of Fangs, Murder
Row, Den of Nalorakk, The Blinding Vale and Voidscar Arena are rewritten, and Kings' Rest, Temple of
Sethraliss and Ruby Life Pools, which had no tips at all, now have them for all 11 bosses.
Rotmire in Sporefall and the Ritual Site bosses were checked too: Rotmire is rewritten around Fungal
Bloom, and the Ritual Site tips now say plainly what no source describes yet instead of promising it.
The eight Season 1 dungeons followed, all 29 bosses, and several of them had it backwards: at Vordaza
you make the phantoms collide instead of killing them, and at Nysarra you stand in the light of her
wound instead of dodging it.

Every raid boss also has a short version: three plain lines, plus one for your own role. The boss
window shows it by default, **Show all tips** brings back everything, and Settings → *Short tips in the
boss window* turns it off. The Raids page shows the short block above the full tips, and puts this
season's raid first, with the Season 1 raids below under their own heading. The dungeon bosses have
the same short version, and the Dungeons page shows it the same way.

Every raid and dungeon on those two pages now shows its bosses as moving 3D models. Click one and the
tips window opens on that boss.

## Fixes

- **Two Inscription treasures in Harandar showed each other's state.** *Intrepid Explorer's Marker*
  and *Leftover Sanguithorn Pigment* had swapped quest IDs, so picking up one ticked the other. Found
  because TwelveInchy picked up the Marker and the addon still showed a red cross; the Pigment was then
  still lying in the world. All 88 profession treasures were checked; these two were the only pair.
- **No more "That area starts at level 82" in Harandar at level 81.** The level for a zone came from
  a levelling guide. It now comes from the game itself: Eversong Woods, Zul'Aman, Harandar and
  Voidstorm all scale from 80 to 90, and only the Coiled Isle starts at 90. The warning also says
  *above your level* instead of *well above you*.
- **The feast for three tanks.** The feast advice for **Vengeance**, **Guardian** and **Brewmaster** now
  points at *Hearty Silvermoon Parade*, matching the Season 2 class guides.
- **The Recommended button leaves your own choices alone.** It used to put Classic, compact mode, text size,
  the minimap icon, the quick bar and the arrow and boss window sizes back as well, showed every achievement
  you had hidden again, and switched the big boss model on although that is off by default. Now it only sets
  the features, as it always said it would.
- **The Sporefall boss window opens by itself on every client language.** It matched Rotmire by an
  id the game never sends, so outside English clients it stayed shut.
- **The Settings page scrolls**, so no button sticks out below a small window.
- **The old beta checkboxes** for Codex, Guide, Macros and Role Academy are now part of the screen
  list. If you had one switched off, that screen is hidden, and one click brings it back.

## Translations

The new texts are in German, French, Spanish, Portuguese and Italian. We wrote them ourselves and no
native speaker has checked them yet, so corrections are very welcome.

## About the icons

The icons were generated locally with an open image model (Z-Image Turbo) from text prompts,
then picked and cropped by us. No Blizzard artwork was used as input for the icons.

## What we are working on next

No dates, and nothing here is a promise:

- **All settings inside the addon**, in the new look.
- **Weekly ticks for quest givers whose quests rotate**, like Lady Liadrin.
- **A count of the weekly Knowledge drops per profession**, once we have measured how the game keeps
  track of them.

If something in the addon is wrong on your screen, saying so is the fastest way it gets fixed —
half of this release started as exactly that.
