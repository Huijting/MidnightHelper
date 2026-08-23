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

Her level, how far to the next one, and how much is left — shown when you enter a delve and gone when you leave. That is the whole feature. Close it and it stays closed; `/mh valeera` brings it back.

It was going to be cleverer than that, and it should not have been. It claimed only Bountiful delves feed her reputation and turned the remainder into "about six more bountiful runs". A tester ran a level 3 delve — not bountiful — and gained reputation for it. Less than a bountiful run, but not nothing, so the sentence was simply false, in six languages.

The original check had confirmed that bountiful delves count and concluded the others do not. That is not a measurement, it is a gap where a measurement should have been. The estimate built on top of it is gone rather than corrected — a per-run figure that cannot be pinned down is not worth predicting from. What is left is one sentence that is true: every delve adds to it, bountiful ones add more.

She is also given a reason rather than an instruction. Healer is the recommendation, and the reason it is a recommendation differs depending on what you play, so it now says the one that applies to you.

## Standing next to a portal and being told to fly

If you were on the Coiled Isle dock with the portal in front of you, the travel advice would ignore it and route you to a flight master.

The hint now asks the travel planner first, so a portal is reported as the first step when a portal is the first step. The arrow follows: it points at the portal, and after you take it, it hands back to your actual destination — which it already did after a flight, and now does after both.

## Come and say hello

Every correction above started with someone noticing the addon had told them something untrue — including the last one, which was reported from a dock with a screenshot. That is worth more than any feature list, and Discord is where it reaches me fastest: **https://discord.gg/kBHaHcsASQ**
