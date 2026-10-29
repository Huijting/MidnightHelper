# Midnight Helper 4.14.0 (beta 2): your records per Tier, a Labyrinth splits window, a Solo tab for healers

## This is a beta

Betas get new things to you sooner. To get them: open the CurseForge app, go to Midnight Helper and set the
**release type** to **Beta**. Some of what is below has not been tested in every situation yet. Tell us how it goes,
also when everything works:

- `/mh report` in game, or *Report a problem* in Settings,
- a comment here on CurseForge,
- or the feedback form on midnighthelper.com.

## New in beta 2

- **Delve Log: records per Tier.** Until now a quick Tier 1 run could count as your fastest next to your Tier 11 runs.
  Records now count per Tier. The tab has a new look: your totals in four boxes, one line per delve with its top Tier
  and your record there. Click a delve for your record on every Tier and your last runs, each with how it did
  against the record.
- **A notice after every delve**, for 8 seconds in the middle of the screen: your time, and whether it is a new record
  for that delve on that Tier. Try it with `/mh scorecard test`; Settings → *Notice after a delve* switches it off.
- **Labyrinth splits window.** When you leave the Labyrinth, a window shows the whole run: every room, its time, and
  how it did against your best. `/mh labsplits` opens your best times per Tier, with the day you set them.
- **Fixed:** after the first room the splits could say the wrong Tier (Tier 6 in a Tier 11 run). The list no longer
  says "0 new record(s)", and the scorecard detail line shows "-36m 13s" instead of "-2173s".
- **Codex, Labyrinth:** the Great Vault part now mentions Blizzard's hotfix of 27 October.

## New: Labyrinth splits

Race your own best time, room by room, in the Labyrinth of Kindo'jan.

- **After every room** a line on screen (and in chat) with your time for that room, and how it compares to your best
  for that room on that Tier: faster, slower, or a new record.
- **When you leave**, a window with every room's time and how it did against your best (the list stays in chat too).
- `/mh labsplits` opens your best times per Tier. Settings → *Labyrinth splits* switches it off.
- Start your run outside the Labyrinth. If Midnight Helper first sees you when you are already inside (for example the
  first time with this version), that room does not count. A `/reload` later on keeps your run.

## New: a Solo tab for all seven healers

Healing alone in a delve or the Labyrinth, with Valeera at your side, is a different job from healing a group. The
*How you play* window has a new **Solo** tab for every healer spec: what to do before the fight, how to attack (with
your own keys), how to heal with your clicks, and what to do when it goes wrong. A Restoration Druid with Rake but
without Starsurge gets the Cat Form steps.

Also for healers: `/mh curios` now says which role Valeera can take when you heal yourself (Tank or DPS, and why).

## Shopping list at the auction house

- **The right amount.** Click a row in Midnight Helper's list, then the silver or gold one in the results: the amount
  box now says what you still need (for example 16) instead of 1. You still press *Buy* yourself. Don't want this?
  Settings → *Fill in the amount when buying*.
- **No search during a purchase.** Click a row while a purchase window is still open and Midnight Helper waits and
  tells you so at the top of the screen. A search at that moment closes the purchase window, which cancels it.
- **Shoulders without an enchant** now count as missing, like head and feet, and go on the shopping list.
- The *Raid | Profession* tabs and *Everything to Auctionator* follow the language you picked.
- *How do I buy this?* links to the same steps with pictures on midnighthelper.com/shopping/.

## Also

- **Labyrinth splits:** if your splits from beta 1 sit under the wrong Tier, `/mh labsplits move 6 11` moves them (the
  faster time per room wins).
- **Labyrinth:** once all three Hexmasks follow you, the Hexmask room hint stays quiet for the rest of the run, and
  `/mh hexmask` now also knows Kindo'jan's platform.
- **Short notices on screen** (the Hexmask hint, the delve chest route) no longer sit under the game's big room name.
  They show below the middle of the screen, stay while your mouse is on them, and you can drag them where you like.
- **Rares:** *Generate Route* stays in the zone you picked. Pick the Coiled Isle while you stand in Silvermoon and the
  arrow takes you to the portal first.
- **Delves in German, French, Spanish, Portuguese, Italian and Russian:** every story variant now has Blizzard's own
  name and description in your language, and the Delve Coach recognises the story in your language.
- More game names now match your game client in every language.

The new texts in German, French, Spanish, Portuguese, Italian, Russian and Mexican Spanish are our own translation:
native speakers, corrections are very welcome.

Have fun!
