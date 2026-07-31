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

✅ **RESOLVED the same day.** Blizzard's own Currencies tab showed **Veteran
Dawncrest = 120**, i.e. id **3341**. 3342's 220 is something else and must not be
displayed as a balance. `GetTierCurrencyQty` used to take the MAX across primary and
alternates, so MH showed 220 — a hundred crests the player does not have, in the
panel meant for planning upgrades. Fixed: the primary id wins, alternates are only
consulted when the primary is not a currency the game knows.

Every primary id matched the game exactly: 3383=54, 3341=120, 3343=31, 3347=240,
and the tab read Hero=20. No alternate matched.

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

## Caps: there are none (measured 2026-07-22)

`/mh crests` reported for **every** tier:

```
maxQuantity=0   maxWeeklyQuantity=0   earnedThisWeek=0
```

Two independent signals agree: Blizzard's Currencies tab renders genuinely capped
currencies as a fraction (Dawnlight Manaflux 4/8, Nebulous Voidcore 25/28, Radiant
Spark Dust 21/21, Untainted Mana-Crystals 475/1000) and shows all five Dawncrests as
a bare number.

`DAWNCREST_GUIDE_SUMMARY` claimed "Each color has a weekly cap (~100)". That sentence
has been removed from enUS and nlNL. The tilde was the tell: it was an estimate that
had been shipping as a fact, in the one panel a player uses to plan a week of
upgrades. Nothing replaced it — "there is no cap" would be a fresh claim about game
behaviour, and the absence of a cap field is not proof that no cap exists anywhere.

`earnedThisWeek=0` is NOT evidence of anything: the weekly reset had just happened
(This Week showed "Resets in 6d 15h"), so zero is the expected reading either way.

## Which Veteran id is real — settled

`totalEarned` decided it: **3341 = 30**, matching the "Season Total Earned: 30" line
in the game's own Veteran tooltip. **3342 reported a balance of 220 with
totalEarned=0**, which is not how a currency the player has actually earned behaves.
3341 is the real one; the MAX rule that preferred 3342 has been removed.

Other totals captured, for reference: Adventurer totalEarned=64 (have 54), Champion
3343 totalEarned=301 (have 31), Hero totalEarned=900 (have 20), Myth totalEarned=240
(have 240).

## 12.1 PTR, 2026-07-24 — the Mistcrest claim is NOT confirmed by the game

Measured on the 12.1 PTR while **Season 2 was already live** (`/mh season`: live M+
season id **18**, recorded S1 = 17, so the self-learning gate flipped correctly on
its own).

`/mh crests` there still reported all six known ids as **"* Dawncrest"**, each
described as *"Midnight **Season 1**"* — 3383, 3341, 3342, 3343, 3344, 3347. So the
old ids are untouched.

⚠️ **That probe is blind to new ids** — it only iterates `ns.DAWNCREST_TIERS`. So it
cannot answer whether Season 2 crests exist under different ids. `/mh crestscan`
(walks the player's own currency list) was added for that and returned **"no
currency with 'crest' in the name is in your list"** — but on a character
(*Theexodus*) that owns zero crests, so they are simply not listed. Absence is not
proof.

**What the currency tab DID show, and it matters:** a **"Season 2"** header holding
**Venomblight Manaflux 3**, where Season 1 uses **Dawnlight Manaflux**. Combined with
Dawn**crest**, that reads as a Dawn→Venom family rename, not Dawn→Mist. The raid
(*The Venomous Abyss*) and a new delve (*Venomfall Deeps*) point the same way.

**So: do NOT run the 307-occurrence rename to "Mistcrest" on the strength of the
handoff.** `MH_HANDOFF_2026-07-24.md` block 4 calls it confirmed, sourced from guide
sites; the client does not agree so far. `/mh crestfind` (numeric id sweep, works on
currencies the character never earned) was added to settle it from the client.

Unresolved on the PTR: id **3341 read 0 while 3342 read 290** — the reverse of live,
where 3341 was the real one. Both showed `totalEarned=0` there, so that tiebreaker
does not work on a copied character. MH picks the primary id, so it would show 0
where the tab may show 290. Check the PTR currency tab on the character that has
them before treating this as a bug.

## ✅ SETTLED — Season 2 crests ARE "Mistcrest" (12.1 PTR, `/mh crestfind`, 2026-07-24)

The client named them. The handoff was right and the Dawn→Venom hypothesis on this
page (written one message earlier, from the Venomblight Manaflux sighting) was
**wrong** — Venomblight is the manaflux family only; the crests are Mistcrest.

### Season 2 — Mistcrest ids, captured

| Tier | id (set A) | id (set B) |
|---|---|---|
| Adventurer | 3437 | 3442 |
| Veteran | 3438 | 3443 |
| Champion | 3439 | 3444 |
| Hero | 3440 | 3445 |
| Myth | 3441 | 3446 |

All read `qty 0` and `Season 2` on that character. **Two full sets of five**, grouped
(3437-3441, then 3442-3446) — not paired consecutively the way Season 1 is.

Also captured: **Venomblight Manaflux id 3465** (Season 2), the counterpart of
**Dawnlight Manaflux id 3378** (Season 1).

### Season 1 — the duplicate pairs, now fully visible

| Tier | id A (qty) | id B (qty) |
|---|---|---|
| Adventurer | 3383 (0) | **3391 (180)** |
| Veteran | 3341 (0) | **3342 (290)** |
| Champion | 3343 (0) | **3344 (30)** |
| Hero | 3345 (0) | **3346 (30)** |
| Myth | 3347 (0) | 3348 (0) |

⚠️ **This reopens the "which id is real" question, and the answer is not simply
"the primary".** On LIVE (2026-07-22) the tab showed Veteran = 120 = id **3341**, and
3342's 220 was rejected because `totalEarned` was 0. On this PTR character the
reverse holds: 3341 = 0 while **3342 = 290**. So MH (which takes the primary id since
2.10.0) would report 0 Veteran crests here.

Note the S1 layout is also inconsistent: Adventurer pairs 3383↔**3391**, not 3384.
Any rule of the form "second id wins" or "primary id wins" is therefore a guess.
**Do not change `GetTierCurrencyQty` on the strength of this PTR reading** — a copied
character is not a clean sample. Settle it on a character whose currency tab actually
lists the crests, using the tab as the arbiter, exactly as live was settled.

Related oddity: on that PTR character the currency tab showed **no crests at all**
(only a Season 1 header with Untainted Mana-Crystals, and a Season 2 header with
Venomblight Manaflux), while `GetCurrencyInfo` happily returned 290 for 3342. So the
UI hides what the API still answers. Worth knowing before trusting either alone.

### Do not pick this up

`Test Myth Dawncrest` **id 3543** (Season 1) is a developer test currency that the
sweep found. It is not player-facing; keep it out of the data.

## 12.1 PTR, 2026-07-31 — the game names them, and the season gate is OPEN

`/mh crests save` on Rob's PTR character, read back from SavedVariables.

**`seasonTwoLive = true`** — `IsSeason2Live()` returns true on this PTR build, so
every season-gated path in the addon is live there. That makes the PTR the only
place the Season 2 crest handling can be tested before 18 August.

The client resolved our captured ids to real names, which settles that they are the
right ids:

| Tier | id | name | qty |
|---|---|---|---|
| Adventurer | 3437 (S2) / 3442 (S2-alt) | **Adventurer Mistcrest** | 0 / 0 |
| Veteran | 3438 / 3443 | **Veteran Mistcrest** | 0 / 0 |
| Champion | 3439 / 3444 | **Champion Mistcrest** | 0 / 0 |

Season 1 on the same character: 3341 Veteran Dawncrest **0** while its "duplicate"
3342 reads **290**, and 3343 Champion **0** against 3344 at **30**. That is the
inverse of the 22 July measurement on live, where the primary held the real balance.
Do not read anything into it yet — this character earned its crests before the
season flipped, and which id a balance lands on across a season boundary is exactly
what nobody has measured.

**Still open: which Season 2 set is primary.** Both read 0 and both resolve to the
same name, so nothing here separates them. It needs a character that has actually
earned a Mistcrest — patch day at the earliest.

### What it caught in our own code

The row's NUMBER was season-aware but its icon and tooltip were still bound to the
Season 1 id, so the panel showed a Mistcrest balance under a tooltip reading "Myth
Dawncrest — Midnight Season 1". Fixed by giving the season choice one definition
(`TierCurrencyIds`) instead of three call sites. The server request had the same
gap: it only ever asked for the Season 1 ids, and a currency the server never
pushed reads as zero — indistinguishable from having none.
