# Midnight Helper 3.0.0 — Season 2, and a route that knows where you are

## Getting there

`/mh plan` lays out the whole way to your current target as steps you can click, and the route arrow now walks it. It steers to the first step on your own map, replans as you move, and tells you "you are here, walk through" rather than spinning when you are already standing on one.

All three Amani Windcaller landing spots were measured in game, so choosing between them is arithmetic rather than a guess. If the door is closer than the flight, it says so and skips the hop.

## The Coiled Isle, finished

The Mysterious Mix Master's ten offerings, each with its three ingredients. Both remaining hunts. And one Route button in the card header instead of ten identical ones all pointing at the same cauldron.

## The Ring of Glory

The briefing now opens in red: the golem's slam cannot be interrupted and lands underneath you, so stun it or take it on a defensive.

It is written down rather than shown at the moment it happens, because patch 12.1 no longer lets an addon see which spell an enemy is casting. That was measured rather than assumed, and a warning that cannot know what it is warning about is worse than a sentence you read before you go in.

## Things that were quietly broken

Every Coiled Isle treasure was invisible to the search box — the index read a field those hunts deliberately leave empty, so searching for one found nothing. It now reads the name your own client gives it, which makes it work in your language as well.

The command list was missing nine features that shipped months ago, and could not itself be found by searching for "commands". The measurement commands now sit in a group of their own.

Also fixed: an unreadable map reported as "another continent", a travel step that declared itself finished before you had moved, and an arrow pointing at your own feet.
