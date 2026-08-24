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

The original check had confirmed that bountiful delves count and concluded the others do not. That is not a measurement, it is a gap where a measurement should have been.

So the guess came out and the real thing went in. The popup now counts what actually feeds her while you are inside: **Chunks of Companion Experience** by rarity, **Boons**, and the occasional rich find — one of them paid 26,000 in a single pickup. The XP figure beside it is read from her own standing rather than added up from a table, so it stays right whatever bonus you are running and whatever Blizzard changes next patch.

It recognises those extras by what they *do*, not by their names: anything you loot that raises her standing counts, in any language, including items nobody has written down yet. That matters — the 26,000 one was unknown to every source we could find an hour before it turned up.

She is also given a reason rather than an instruction. Healer is the recommendation, and the reason it is a recommendation differs depending on what you play, so it now says the one that applies to you.

## Standing next to a portal and being told to fly

If you were on the Coiled Isle dock with the portal in front of you, the travel advice would ignore it and route you to a flight master.

The hint now asks the travel planner first, so a portal is reported as the first step when a portal is the first step. The arrow follows: it points at the portal, and after you take it, it hands back to your actual destination — which it already did after a flight, and now does after both.

## Two things we were telling you that were not so

The consumable check said bag sharing was "coming in Phase 2". It arrived in 1.8.3. If a groupmate runs Midnight Helper you have been seeing their bags this whole time — the footer just never said so, in seven languages.

And a ritual boss tip promised its detailed steps "in the next Midnight Helper update", through four updates. It now says the truth instead: that boss was never datamined, nobody has reported a run, and if you fight it we would genuinely like to hear what it did.

## The professions course now opens in its own window, and only there

3.4.0 gave the course a window beside the game. It also kept rendering the whole thing squeezed into the bottom of the Professions panel, which was the version most people actually met. That copy is gone.

The panel keeps what a dashboard should have — your professions, the live advice, your progress — and **Full course** opens the reader. That button used to hide the contents list instead of opening anything, which is exactly what it sounded like it did. The chapter list grows with the window now, so widening it finally makes the titles readable rather than just the text column wider.

## Advice you could not act on, again

3.4.0 fixed a line that told you to spend Knowledge Points that were locked behind a skill requirement. It fixed it in one of the two places that say it.

The Professions 101 advice line never asked. So on a profession with every specialization padlocked you were still told where to put your next points, with a list of nodes underneath that nobody had checked you could buy. Both now say what is actually true — raise the skill first, and your Knowledge is safe until then.

## The Ring of Glory is an arena, and it means it

Our tip described three fixed variants ending at two named bosses, one of which we had taken from a guide and never seen.

It is a series of opponents that differs between runs. A full Tier 11 run measured seven: clear the ground, then Crushfoot, the Bluegill Brothers, Brinebeater, Guth'kar the Bound, three Arena champions at once, and Drakta. Another run gave a single boss after the clear. So the tip lists that run as an example and says plainly that meeting a name it does not list means the arena rolled differently — not that you did something wrong.

Crushfoot's charge is what kills people, and **crowd control stops it**. That is measured. Players also report two towers with blue orbs that teleport you across; that is reported, and the tip says so rather than dressing it up.

And a line came out. We used to tell you to break line of sight behind a pillar when Drakta pulls. That is group-guide advice: solo you are always the target, and since 12.1 an addon cannot see which spell an enemy is casting, so we cannot warn you either. There was no time to react to it. It now says what it is — damage to survive.

## Venomfall Deeps was missing, on purpose, until it was not

The delve roster deliberately left it out in August: the client returned only the other two for that map, which we recorded as measured absence rather than an oversight, and it matched Blizzard gating the Nemesis delve behind Season 2. The note ended by naming the test that would change the answer.

Season 2 opened. The test was re-run. It is in.

## Fixed

A buff button on the consumable check has been quietly refusing to cast since 1.8.4. It drew fine and did nothing, and only an error log showed why — our own frame was making its own click untrusted. If you ever wondered why clicking a buff there did nothing, it was not you.

Party rows are clickable people now: left-click targets the group member, right-click targets what they are looking at. Previously you could only click the mob.

`/mh plan` used to say "you are already there, or close enough that a plan would be silly" when it meant "this is on the map you are standing on" — which across Silvermoon can be a long walk.

## Come and say hello

Every correction above started with someone noticing the addon had told them something untrue — including the last one, which was reported from a dock with a screenshot. That is worth more than any feature list, and Discord is where it reaches me fastest: **https://discord.gg/kBHaHcsASQ**
