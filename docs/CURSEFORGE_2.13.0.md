# Midnight Helper 2.13.0

## Every command, in the addon

The Tools page now lists all forty of them, grouped, with a line each saying what they
do. Most of this addon was reachable only by typing something you already had to know.
The build now fails if a command on that page is not actually wired up, so the list
cannot quietly drift away from the addon.

## The action prompt, at last announced

A large icon appears when your interrupt applies to what your target is casting, and
when your target carries something you can strip off. It has been in here for a while
without being mentioned, because nobody had yet watched it do its job. Now somebody has.
Turn it on with `/mh prompt` and drag it where you want it.

`/mh prompt sound` makes the purge half speak, or chime, or stay quiet. Interrupts stay
silent on purpose: the game lets an addon show whether a cast can be kicked, but never
read it, and making a sound means reading it.

The purge half also used to light up on friendly players, who always carry something
dispellable, so pressing it answered "Invalid target". It only appears on enemies now.
Shaman and Hunter were missing from it entirely; four classes are covered instead of two.

## Fixed

Four places read a unit's GUID with a check that cannot tell a hidden value from an
ordinary one, two of them in the raid and delve coaches. Against a boss whose GUID the
client hides, that throws an error in the middle of the fight.

`/mh kicks who` is gone. It could never work: Midnight refuses combat log access to every
addon, this one included.

## Ready for patch 12.1

The Coiled Isle arrives with nine rares, their coordinates and kill quests measured on
the test realm rather than guessed, and Altar of Fangs arrives with beginner steps for
all three bosses. Both stay hidden until your client is actually running 12.1, so nothing
shows up before it exists.
