# Midnight Helper 3.10.0

Most of this release is about the gap between a screen looking right and a screen answering your
question. A route that points seven kilometres backwards is obvious. A search result that opens the
correct window on the wrong page is not — and from where you sit, that is the same as no answer.

## Your pet is taunting and you are not the tank

Growl is on by default. In a group, that means your pet spends the whole pull yanking things off the
person meant to be holding them, and nothing tells you.

Midnight Helper now watches for it and says so — once, in the middle of your screen, with a sound,
and only when somebody is actually tanking. It counts **people**, not party slots, so a delve with
Valeera in it no longer reads as a group. Turn Growl off and the warning takes itself away.

Measured on real pets: **Growl** on hunter pets and **Suffering** on the Voidwalker. *Sacrifice* was
in that list and should not have been — it is not a taunt, and it has been removed. `/mh pet` prints
what the addon can see and why it did or did not warn.

## The portal to the Coiled Isle

Take the portal in Silvermoon and the route arrow used to keep pointing at the portal — from the
other side of it, seven kilometres away.

Four separate faults, all fixed:

- the arrow never let go when a portal route ended
- Silvermoon City has **no world coordinates at all**, so no distance in yards can be measured there
  — the door step now asks three different ways and says which one it used
- standing inside the room, the route sent you back out to the door you had already walked through
- the map pins outlived the route that made them

`/mh arrow` now prints where the route thinks the portal comes out and where you actually are.

## The Coiled Isle wants level 90, and nothing said so

The isle is tuned ten levels above the rest of the region. The addon knew the region floor and
applied it to the isle too, so a character who could not do anything there was told nothing.

While measuring that, the Midnight entry level turned out to be **80**, not the 78 we had recorded —
confirmed three independent ways, including by the game refusing to let a level-79 character pick a
flower.

## A search result now lands on the answer

Type a word, click the result, and you arrived at the right screen and then had to hunt. Four
places, all repaired:

- the **profession guide** opened on the step you are standing on, which is right for levelling and
  wrong for looking something up. Search "azeroot" and it opens on the step that mentions Azeroot.
- a **Codex article** opened its category page, scrolled to the top. It now scrolls to the article.
- and it kept scrolling **short** of it, because the page is still growing when you land. It now
  keeps landing while the text settles.
- the **course** silently showed a different chapter when you asked for one this character cannot
  see. It now says which chapter you asked for, that this character does not have that profession,
  and what you are looking at instead.

## Which Corrosive gift should I take first?

Twelve gifts, all costing exactly 8 Corrosive Souls. Because the price is identical, the first pick
is about what you need — never about what you can afford.

One thing explains the whole system: it is a **poison loop**. Half the gifts get stronger against a
poisoned enemy, or while you are poisoned yourself. So every good pair is one gift that poisons plus
one that pays off on poison. The Codex now says that, and then names picks by the problem you have
rather than handing you a ranked list.

## /mh souls

The addon has been keeping a ledger of your Corrosive Souls since August and never showed it to
anyone. It does now: what you earned, what each source paid, and what you spent.

Two numbers on that screen have different scopes, and the screen says so: your bag count is **this
character**, the ledger is your **whole account**. Souls are Warbound. And the ledger counts only
what it watched, so your real total can be higher than what it lists — that is said out loud rather
than left for you to discover as a contradiction.

## Where do I pick Azeroot?

The answer is better than a route: it does not matter. All five Midnight herbs grow in all four
zones, and all three ores appear in all four as well. So gather where your week already takes you.

The guided profession advisor also has a door now. It had exactly one button, no slash command and
no line in the search index — `/mh profguide` opens it, and searching for a material, an ore or a
herb finds it.

## Paladin

- **Blessed Hammer** could never be classified. It is a talent override of Crusader Strike, so the
  spellbook reports it under Crusader Strike's id, which belongs to a different spec — and the
  lookup picked its winner before testing the spec. It now walks the candidates and takes the first
  that also passes.
- **Retribution** got its taunt back. *Hand of Reckoning* was marked Protection-only.
- **Holy Bulwark** and **Rite of Sanctification** added for Protection.

## Codex

Two new articles: the **first hour of the expansion** (where Midnight starts, that the campaign can
be skipped, and what that costs — nothing), and **the Corrosive powers**.

Three articles removed. *Turbulent Timeways V* was still on the shelf with its window of 30 June to
11 August, telling you in the present tense to run four dungeons a week. It ended the day 12.1
launched. The Omnium Folio was there twice.

## Smaller

- **Dundun** takes a third shape: as well as the two trees, he can be a flamingo.
- The Inscription chapter claimed the weekly Treatise is +2 Knowledge "and no other profession has
  that". The +2 is right; the exclusivity was backed by nothing, so it now says the Treatise gives 2
  Knowledge instead of the usual 1.
- The Midnight scouting map offers five starting zones. Picking one closes the other four —
  and abandoning the quest opens them again.

## What we are working on next

No dates, and nothing here is a promise — this is simply what is on the bench:

- **The weekly list shows about half of your week.** Two screens each cover a different half and
  neither says so. That is the next real job.
- **Macros**, which exist in the addon and are almost impossible to find.
- **"Which of my characters has that profession?"** The addon already knows; it does not say.
- A **healer track**: a cooldown sheet, a dispel helper, and callouts.

If something in the addon is wrong on your screen, saying so is the fastest way it gets fixed —
several items above started as exactly that.
