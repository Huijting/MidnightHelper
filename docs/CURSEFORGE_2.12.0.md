# Midnight Helper 2.12.0

## See what your group is attacking

A new panel shows every party member and what they are on: their role, their class
colour, and the raid marker sitting on their target. Click a line to take that target
yourself, in combat too. Drag it where you like, drag the corner to widen it.

It stays off until you ask for it. Turn it on with `/mh partytargets`, or from the
Settings page.

## The route arrow comes back

If you had WaypointUI installed, the route arrow never appeared. That was deliberate,
one guide on screen, but it quietly cancelled a feature this addon advertises, and a pin
on the ground and an arrow with a distance answer different questions. The arrow now
draws alongside it. `/mh arrow yield` restores the old behaviour, and `/mh arrow` reports
who is guiding you and why.

The arrow was also hard to see against dark ground: its halo was black, which only helps
on bright backgrounds. It now has a pale glow outside the dark edge.

## Stay alive

At the top of the Role Academy's DPS track, your own buttons in the order a fight needs
them: the shield you keep up, the one for when your health drops, how you get away, how
you interrupt. It reads your real talents, so a spell replaced by a talent shows the name
that is actually on your bars.

## Smaller things

The welcome popup no longer promises that Alt+M opens the addon. That key is only
assigned when it happens to be free, so for some players the first thing this addon said
was untrue. It now points at `/mh`.

Two Dutch labels said something other than what they meant.

`/mh kicks who` is new: switch it on and a line in chat names whoever landed an
interrupt, and the spell they stopped. Dungeons and raids only — the combat log it
reads is refused in delves, ritual sites and follower dungeons.
