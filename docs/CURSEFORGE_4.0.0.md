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
The window has new colours as well: deep twilight violet with warm gold.

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
exactly as it was, with the long tab list. Untick it for the new look again.

## Fixes

- **Two Inscription treasures in Harandar showed each other's state.** *Intrepid Explorer's Marker*
  and *Leftover Sanguithorn Pigment* had swapped quest IDs, so picking up one ticked the other. Found
  because a player picked up the Marker and the addon still showed a red cross; the Pigment was then
  still lying in the world. All 88 profession treasures were checked; these two were the only pair.
- **No more "That area starts at level 82" in Harandar at level 81.** The level for a zone came from
  a levelling guide. It now comes from the game itself: Eversong Woods, Zul'Aman, Harandar and
  Voidstorm all scale from 80 to 90, and only the Coiled Isle starts at 90. The warning also says
  *above your level* instead of *well above you*.
- **The Settings page scrolls**, so no button sticks out below a small window.
- **The old beta checkboxes** for Codex, Guide, Macros and Role Academy are now part of the screen
  list. If you had one switched off, that screen is hidden, and one click brings it back.

## Translations

The new texts are in German, French, Spanish, Portuguese and Italian. We wrote them ourselves and no
native speaker has checked them yet, so corrections are very welcome.

## About the icons

The screen icons were generated locally with an open image model (Z-Image Turbo) from text prompts,
then picked and cropped by us. No Blizzard artwork was used as input for the icons.

## What we are working on next

No dates, and nothing here is a promise:

- **All settings inside the addon**, in the new look.
- **Weekly ticks for quest givers whose quests rotate**, like Lady Liadrin.
- **A count of the weekly Knowledge drops per profession**, once we have measured how the game keeps
  track of them.

If something in the addon is wrong on your screen, saying so is the fastest way it gets fixed —
half of this release started as exactly that.
