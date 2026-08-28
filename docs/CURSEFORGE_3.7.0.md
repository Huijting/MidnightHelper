# Midnight Helper 3.7.0

## The dispel click works now, and 3.6.0 shipped it broken

That release told you this half was untested and asked you to report what happened. Here is what
happened: on most specs it did nothing at all.

The button was carrying the spell's **ID**. For a spell that a specialisation replaces — Purify
on a Holy Priest is exactly that — the base ID resolves to nothing. No cast, no error message,
no clue that anything was wrong. It casts by **name** now.

Both halves are confirmed in a live dungeon this time: right-click a group member's name to take
something off them, right-click their target to purge it.

If you tried it last week and concluded your button was broken, you were right and we were not.

## Rows dim when you cannot reach that person

Measured with your own dispel, so it is your real range — including whatever a talent does to
it — rather than a fixed number we picked.

When we cannot tell, the row stays bright on purpose. A wrongly dimmed row tells you not to
bother about somebody you could have saved; a wrongly bright one costs you a wasted click. Those
are not the same mistake.

## You are on the panel too

If you have a dispel, there is now a row for you, directly under the last party member. If you
have no dispel there is no row, rather than a row that does nothing when you click it.

It cannot appear and vanish mid-fight — WoW does not allow that for a clickable button — so it
sits there quietly and turns red the same way everyone else's row does.

## The Delves tab did nothing while you were flying

Clicking "Weekly Great Vault" or "Midnight Delves" on a flight path left them shut until you
landed.

There is a rule that defers a heavy rebuild while you are moving. That is right for background
updates and wrong for something you just clicked — and on a taxi you never stop moving, so the
click was deferred every time. Your own clicks now go through; background updates still wait.

## The Tier Sets page admits its data is last season's

The set name and the two bonus links on that page were read during Season 1 and have not been
re-checked for Season 2. The page used to hedge about that. It now says it plainly.

Hover a bonus link for the live tooltip, which is always right, and believe the set name on your
own gear over the one we print. Where the pieces come from is read from your client and is
current.
