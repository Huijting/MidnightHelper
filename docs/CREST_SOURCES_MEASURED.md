# Dawncrest tiers — measured in-game, 2026-07-22

Captured with `/mh crests` on Rob's LIVE client (12.0.7, Midnight Season 1). Every
line below is `C_CurrencyInfo.GetCurrencyInfo(id).description` verbatim — the game's
own text, not our summary.

**Do not hardcode these strings into the addon.** They are here as a reference for
writing Codex prose and for sanity-checking future claims. The addon should keep
showing the live description, which is already translated into every client language
and updates itself when Blizzard moves a source. The handoff draft
(`MH_HANDOFF_2026-07-20_AVOND.md`, §1c/1d) proposed English source lines that this
measurement contradicts — see "Where the draft was wrong" at the bottom.

## Adventurer — currency 3383

> Used to upgrade Adventurer equipment in Midnight Season 1 up to item levels
> **224-237**. When used for crafting, sets the item level of the resulting item to
> 220-233 based on Quality. Earned from the following activities:
> - Repeatable Outdoor Events
> - Tier 4 Delves
> - Prey Hunts (Normal)

## Veteran — currency 3341 (and 3342)

> Used to upgrade Veteran equipment in Midnight Season 1 up to item levels
> **237-250**. Earned from the following activities:
> - Repeatable Outdoor Events
> - Raid Finder Voidspire, The Dreamrift, March On Quel'Danas
> - Heroic Season Dungeons
> - Delves (Tiers 5 to 6)
> - Trovehunter's Bounty (Tiers 4 to 5)
> - Prey Hunts (Hard)

⚠️ **Both ids are real and they disagree on the balance.** 3342 read **220**, 3341
read **120**, and *both* returned the full description — so `DawncrestData.lua`'s
comment ("3342 is a duplicate, 3341 is primary") does not match what the game
returned today. `GetTierCurrencyQty` takes the MAX, so MH currently shows 220.
Unresolved: which number the player's own currency tab shows. Worth one look before
anyone trusts the Veteran count.

## Champion — currency 3343 (3344 read 0)

> Used to upgrade Champion equipment in Midnight Season 1 up to item levels
> **250-263**. Earned from the following activities:
> - Weekly Outdoor Events
> - Normal Voidspire, The Dreamrift, March On Quel'Danas
> - Mythic Season Dungeons
> - Mythic Keystone Dungeons (+2 to +3)
> - Delves (Tiers 7 to 10)
> - Trovehunter's Bounty (Tiers 6 to 7)
> - Prey Hunts (Nightmare)

## Hero — currency 3345

Only the activity list was on screen; the item-level sentence scrolled off.

> - Heroic Voidspire, The Dreamrift, March On Quel'Danas
> - Mythic Keystone Dungeons (+4 to +8)
> - Delves (Tier 11)
> - Trovehunter's Bounty (Tier 8+)
> - Prey Hunts (Nightmare)

## Myth — currency 3347

> Used to upgrade Myth equipment in Midnight Season 1 up to item levels **278-289**.
> When used for crafting, sets the item level of the resulting item to 272-285 based
> on Quality. Earned from the following activities:
> - Mythic Voidspire, The Dreamrift, March On Quel'Danas
> - Mythic Keystone Dungeons (+9 and up)

⚠️ The list may continue past the bottom of the captured screen. Treat it as "at
least these two", not "exactly these two".

## Where the draft was wrong

The handoff proposed writing these as fixed English lines. Measured against the
game, several were simply untrue:

| Tier | Draft claimed | Game says |
|---|---|---|
| Champion | "normal raid and low Mythic+ keys" | also weekly outdoor events, Mythic Season Dungeons, Delves 7-10, Trovehunter's Bounty 6-7, Prey Hunts (Nightmare) |
| Myth | "high bountiful delves, ritual sites, high keys and mythic raid + weekly vault" | Mythic raid and Mythic Keystone +9 and up. **No delves, no ritual sites, no vault** in the captured text |

Two lessons, both already ours: the game often knows the answer better than we do,
and a fact written from memory on a phone is a guess no matter how confident it
reads. `/mh crests` is the way to re-check after any patch.
