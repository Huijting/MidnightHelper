# Midnight Helper 3.7.2

Five corrections. Nothing new was added — things we had told you wrong are now right.

## The Tier Sets page was showing you last season's set

Our list of class set names and bonuses came from a datamine in June. That is **Season 1** —
and it was still being presented as this season's truth a week into Season 2. If that page
never quite made sense to you, it was not you.

The list is gone. The page now reads the set off a tier piece **you are wearing**: the set
name, all five piece names, how many you have, and what both bonuses do — in the game's own
words, already in your language. It cannot go out of date, because we no longer keep a copy
of it.

Wearing no tier piece, it says so instead of naming a set.

**What that costs, so you know:** the page answers "which set am I wearing", not "which set
should I be chasing this season". Your own gear cannot answer the second one, and the list
that claimed to was wrong.

## Names the game shows in English were being translated into names that exist nowhere

There is no Dutch client for WoW. A Dutch player looking for "Kampioen crest" will not find
it anywhere, because the game says **Champion Crest**. That came from a tester who went
looking and came back empty-handed.

The same rule was already written down for achievement titles, and was broken in five of six
languages: *Veteran of the Dawn* had become *Veteran der Morgendämmerung*, *Veterano del
Alba*, *Veteraan van de Dageraad* — while the player's own Achievements pane kept showing the
English one.

Both are corrected. More importantly the addon can now tell "English on purpose" apart from
"not translated yet", which it could not before — so these no longer quietly translate
themselves back on the next load.

The remaining question is honest and open: Spanish, Portuguese and Italian translate the
crest ranks today, German and French do not. Whether their clients show a translated rank is
something a native speaker has to look at, not something we should guess from here.

## A pin said "you cannot use this yet" about a portal you were walking through

The check was right. The timing was not: it ran once when the panel was built and the answer
was kept for the session. Right after a reload the quest data has not loaded, so it read "not
done" — and stuck.

It is asked when you hover now, and re-checked whenever the panel refreshes.

## An error every session, for anyone who watches their error log

The death recap asked the game for the combat log and was refused. It has been refused
everywhere we have tried on this patch — Timewalking, Looking For Raid, and an ordinary
Normal dungeon — and it has never once been allowed, so every attempt did nothing but add a
line to your log.

It stops asking. The check is tied to the patch number, so a future patch clears it and we
measure again rather than assuming the door stays shut.

## "That is on another continent" now reaches you

When a route target sits on another continent, the addon names the flight point to head for
first. That sentence lived on the route arrow's own label — which is hidden whenever TomTom
is drawing, so nobody running TomTom has ever seen it. It goes to chat now, once per target,
and never from inside an instance where "another continent" would be a guess rather than a
fact.
