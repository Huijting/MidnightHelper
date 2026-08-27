# Midnight Helper 3.6.0

Most of this release is us correcting things we had told you wrong.

## Valeera: killing things feeds her too

We said her progress came from loot. It doesn't — every kill in a delve adds to her standing.
If you skipped packs on our advice, that cost you.

## The Catalyst works differently since 12.1, and the tier guide now says so

The new piece keeps the secondary stats, the tertiaries and the item level of whatever you put
in. A badly rolled piece comes back badly rolled, permanently.

It didn't always work this way. The Catalyst used to stamp fixed stats on anything, so feeding
it a leftover was the clever move. That habit now costs you. Feed it your **best** piece in
that slot.

You can check this for free: the Catalyst screen previews the result before you confirm.

Charges are also **per character** and cap at 8, so your alts have been saving them all along —
and one sitting at 8 has stopped gaining. The account summary names which ones.

## New: /mh stats

What crit, haste, mastery and versatility actually do, in your spec's order, with your own live
numbers beside them.

Mastery is a different effect for every spec — the one stat no guide can explain in general. So
that sentence comes from the game itself rather than from a list we would have to keep correct.

It opens with the honest part: higher item level almost always wins, and stats only decide
between two pieces that are already close.

## Party targets can dispel

Right-click a group member's name to remove what is on them; right-click their target to purge
it. The row turns red when the game says there is something there you can take off — Blizzard
draws that, so it is never our guess about what an aura is.

The panel is off by default. `/mh partytargets` turns it on.

**Half of this is still under construction, and you should know which half.** The red has been
confirmed in a live dungeon: rows light up at the right moment, for the right person. The
right-click dispel has *not* been confirmed on a real dispellable debuff — everything we can
measure about it is correct, and that is not the same as seeing it work. The purge on the
right half has been seen casting.

So treat the dispel click as untested and tell us what happens. `/mh glow` prints what the
button is carrying and what your client actually cast, which is exactly what we need in a
report.

## Windows now honour your settings

The boss window ignored its own off switch in rituals and raids; that is now settable per
content type. And a group member asking everyone to show the consumable board no longer opens
it for someone who turned that off.

Panels that were closed also kept doing work. Four of them now stop while hidden, which takes
the addon from 0.060 to 0.003 milliseconds a frame while you stand still with everything shut.

Both of those come from **AndyMM22**, who found them, fixed them and measured them. Thank you.

## Smaller, but they were wrong

- The dispel alert was silent in raids, which is where dispelling matters most.
- Delves name all 48 story variants now, instead of a handful.
- Highlighted words in the curio explanations were losing their first letter or two.
- Emoji that WoW cannot draw were showing as empty boxes in seven languages.
- Four input boxes could keep hold of the keyboard after closing, quietly eating movement keys.
- Season stats showed two counters while tracking five; the empty ones were simply missing,
  which reads as "not tracked" rather than "none yet".
- Searching for "stats" opened a developer dump instead of the counters it promised.

## One honest note about the languages

Four Spanish, French, Portuguese and Italian settings labels promised "on entering the dungeon"
for an alert that also fires in rituals and delves. Rather than leave a wrong translation
standing, those four now fall back to the corrected English until a native speaker fixes them.

Seven other strings are simply older than the English they came from. They are still accurate;
they just haven't caught up. If you speak one of these languages and want to help, `/mh
translate` shows you how.
