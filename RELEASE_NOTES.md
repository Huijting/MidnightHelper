# Midnight Helper 3.5.0

Midnight Helper is written and maintained by one person. That is the honest reason updates arrive in bursts rather than on a schedule.

## The languages are done

3.4.0 said the other languages would follow within a few days. They have.

German, French, Spanish, Portuguese and Italian now read as their own language throughout — the whole professions course, the Codex, the dungeon and delve guidance, the academy, the commands and the achievement text. Dutch and English were already there. That is roughly thirty thousand characters per language.

What stays English is the short stuff, deliberately: stat names, `DPS`, `Flask`, `Bountiful`, and anything Blizzard writes in English in your client anyway. Translating those would mean inventing a word your own tooltips do not use.

## And they use your client's words, not ours

Translating a sentence is the easy half. The harder half is the words inside it that Blizzard has already chosen for you, because if we invent our own you end up reading advice that does not match the tooltip it is describing.

So every game term was checked against Blizzard's own game data rather than against a guide or a dictionary. Four of them were wrong:

- The Italian course called the Deftness stat **Destrezza**. The Italian client calls it **Velocità**. Anyone following that chapter was looking for a stat that does not exist by that name.
- **Crafting Details**, **Patron** and **Recipe Difficulty** had been left in English in French, Spanish and Portuguese, next to sentences that were translated around them.

## A correction in English does not reach the other five languages

This one is worth explaining, because it is invisible from the outside and it had already bitten us.

When a language pack is missing a line, you get the English one — that is why nothing ever shows up blank. But when the pack *has* the line, it wins. So a sentence we correct in English keeps its old, wrong wording in every language that already translated it, and it does so silently.

Seven strings were sitting like that. One of them was the work orders chapter still saying a crafter can take four public orders **per day** — in five languages — which is the exact error 3.4.0 announced having fixed. Two more were the Alchemy and Herbalism chapters still describing the routes we had replaced. They are corrected now.

The tool that checks this used to ask whether a key existed in a pack and call that translated. It now runs the addon's own resolver and reads what it actually returns, which is the only question that was ever being asked.

## Valeera, in the delve

Her progress now shows while you are in one: where she is, and what the bar in front of you cannot tell you — what a bountiful run is actually worth, measured from your own recent runs rather than from a number someone posted.

And it does not pretend that number is fixed. A run is worth what the delve and your pickups make it, so once your runs disagree the popup gives you the range instead of a single tidy figure. Nobody has measured how much that varies, and inventing a precision is worse than admitting the spread.

She is also given a reason rather than an instruction. Healer is the recommendation, and the reason it is a recommendation differs depending on what you play, so it now says the one that applies to you.

The X closes it for good, not just for that delve. `/mh valeera` or the Pop-out windows card brings it back, and it says so in chat when you close it.

## Standing next to a portal and being told to fly

If you were on the Coiled Isle dock with the portal in front of you, the travel advice would ignore it and route you to a flight master.

The hint now asks the travel planner first, so a portal is reported as the first step when a portal is the first step. The arrow follows: it points at the portal, and after you take it, it hands back to your actual destination — which it already did after a flight, and now does after both.

## Come and say hello

Every correction above started with someone noticing the addon had told them something untrue — including the last one, which was reported from a dock with a screenshot. That is worth more than any feature list, and Discord is where it reaches me fastest: **https://discord.gg/kBHaHcsASQ**
