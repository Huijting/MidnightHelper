# Midnight Helper 2.14.0

## Setting up your bars is a panel now

`/mh setup` replaces a set of commands you had to run from memory, in the right order, on
the right character. Getting that wrong once cost one of us eight keybinds, with nothing
on screen to warn him. The panel says who you are and whether your keys are account-wide
or this character's own before it offers anything that changes them, and nothing
destructive happens on a single click.

Open Midnight Helper on a character whose bars have never been set up and it now offers,
once, to do it for you. There was no way to find out `/mh setup` existed: a changelog is
read by nobody and a store page is read once, before installing.

The recommended layout is something you can apply rather than a picture to copy by hand.
It touches action bars 1-8 and nothing else, and a button beside it puts your old layout
back. If your mouse sends 6 7 8 9 0 - instead of mouse buttons, one press puts those on
action bar 8 and leaves every key you already bound where your hands expect it.

## Smaller things

A quick bar, off by default: `/mh bar`. Your healing potion and healthstone as keybinds
instead of action bar slots. `/mh fps` reads out the graphics settings that cost the most
frames and changes none of them. A Details! page that copies a profile for you to paste.

## Patch 12.1

The world boss scan used a function 12.1 removed. It failed silently and fell back to a
stale answer, which is worse than an error.

In combat, 12.1 hides some of your own buffs and reports them as simply absent - three of
five, measured. The addon now says it cannot tell, rather than telling you that you are
missing something you are holding.

The Season 2 gate opened on patch day, six days early, because it keyed off a number that
changes with the patch instead of with the season.

## Fixed

The search box did not index the Addons pages at all. Shift+scroll resizes every dialog.
