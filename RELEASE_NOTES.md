# Midnight Helper 4.7.3: shopping for raid night, buttons, and a key block fix

## Why this one comes quickly

4.7.3 was a beta this morning. We release it to everyone now because it fixes a mistake in 4.7.2: on block D of the
key block, some spells got **another spell's button** (see below). Thank you to everyone who tried the beta!

**Placed the key block before?** Open `/mh block`, press **Undo**, then place it again. That clears out anything that
landed on block D by mistake.

**Tell us how it goes, also when everything works.** A short "works fine on my Hunter" helps us as much as a bug
report. No need to write a lot:

- `/mh report` in game, or *Report a problem* in Settings,
- a comment here on CurseForge,
- or the feedback form on midnighthelper.com.

Something looks odd? A screenshot says more than a long story.

Want to try new things before everyone else? In the CurseForge app, set the release type for Midnight Helper to
**Beta**.

## Buttons instead of commands

Many things only worked if you knew the right `/mh` command. Now they have a button:

- **All settings** (the first button on the Settings page) has new switches: the action prompt and its sound, the
  dispel alert, upgrade arrows in your bags, the upgrade line in item tooltips, the scorecard after a delve, the tank
  summary after each pull, and letting WaypointUI drive the arrow.
- **Tools → Pop-out windows** has five more windows: your stats, Pawn weights, your keybinds, what your curios do,
  and your graphics settings. The whole page now scrolls.
- **Settings** has buttons for *Report a problem*, *What's new* and *Side panels back in place*. *Help translate* opens
  a window with the links to copy.
- **The quick bar** shows a **route button** while a route runs (click: skip a stop, right-click: stop, Shift-click:
  the plan) and a **nearest flight master** button outside instances.

## Key block: the wrong spell on block D (please check)

In 4.7.2, spells that Midnight Helper does not know yet went on a free Alt key in block D. Because of a mix-up, some of
them got **another spell's button**. On a Paladin, for example, "Warband Map to Everywhere All At Once" landed where
Crusader Aura belonged.

**Do you see a strange spell on an Alt key of block D?** Open `/mh block`, press **Undo**, then place the block again.

## Key block: smaller fixes

- **Hunters:** no more "New for your key block: Primal Rage" question every time you swap pets. Primal Rage now uses
  the button you really have: **Command Pet**.
- **Fold-out buttons** (like a Mage's Portals and Teleports): the fold-out button itself now goes on a free Alt key
  of block D, instead of every portal one by one. Loose copies leave block D, and Undo puts them back. Mages: Cone of
  Cold now gets a free Alt key for Fire and Arcane too.
- **Paladin auras** and the **herbalism Overload** spells no longer get a key. You rarely switch them in a fight.
- **Five spells that no longer exist** in Midnight are gone from the list, for example Shear and Sigil of Doom.
- Every place on the standard key blocks now has its exact spell ID, so midnighthelper.com can show the right spell and
  tooltip for each key.

## Ready for the raid? Now with shopping

`/mh ready` shows what you need for a raid night. New in this version:

- **Click a row at the auction house** and it searches for that item. Not at the auction house? You get the name to
  copy (Ctrl+C). **Shift-click** puts a link in chat.
- **To Auctionator:** with Auctionator installed, one button puts everything you still need in a shopping list, with
  the amounts. Each character gets its own list.
- **Mail and bank count too.** Bought something and it still waits in your mailbox? The window says "+30 in mail" and
  **Pick it up** instead of "Buy". The same for your bank and your Warband bank. Open your mailbox once, so Midnight
  Helper knows what is in it. What you buy at the auction house counts right away.
- **Your gear:** missing enchants and empty sockets are in the same list, with Midnight Helper's first pick. The
  Enchants tab (`/mh enchants`) still shows all options.

**No need to remember commands:** *Ready for the raid?* and *Your key block* now also have a button in the Midnight
Helper window, under **Tools → Pop-out windows**.

Translated into German, French, Spanish, Portuguese and Italian (our own translations; corrections are welcome).

Have a good raid night!
