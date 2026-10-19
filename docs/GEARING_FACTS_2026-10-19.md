# Gear in Season 2 — the facts behind the baby-steps card and the gear ladder (19 Oct 2026)

Two independent `mh-research` rounds (A: game data on wago 12.1.5.70448 + Blizzard; B: guides). They agree on everything
below unless a row says otherwise. Asked by Rob for Carola ("ik doe delves… maar ik ga niet omhoog met mijn gear").

## Tracks — MEASURED (A: ItemBonusListGroupEntry 614–618 → ItemScalingConfig; B: four guides agree)

| Track | 1/6 | 2/6 | 3/6 | 4/6 | 5/6 | 6/6 |
|---|---|---|---|---|---|---|
| Adventurer | 266 | 269 | 272 | 276 | 279 | 282 |
| Veteran | 279 | 282 | 285 | 289 | 292 | 295 |
| Champion | 292 | 295 | 298 | 302 | 305 | 308 |
| Hero | 305 | 308 | 311 | 315 | 318 | 321 |
| Myth | 318 | 321 | 324 | 328 | 331 | 334 |

- Six ranks; a drop is 1/6; each step 2/6…6/6 costs **20 crests of the item's own track + gold** (10/20/30/40/50 g),
  so 1/6 → 6/6 = 100 crests (A MEASURED, ItemExtendedCost 11457–11481; B GUIDE).
- 🔴 **Rob MEASURED 19 Oct (evening), Blizzard's Item Upgrade window:** Veteran 2/6 → 3/6 (282 → 285) cost **10** crests +
  20 gold, and he says Adventurer steps cost 10 too. Research round B (UI source @12.1.5 b9be937): the price comes from
  the server per step (`upgradeLevelInfos[k+1].currencyCostsToUpgrade[1].cost`, with `discountInfo.isDiscounted` → green
  number + a tooltip naming the reason). 20 stays the base price (guides + PTR notes "flat costs"); 10 = half is
  most likely the Warband discount from "… of the Mist" or a watermark (INFERRED — Rob can hover the number to see).
  So GearLadder learns the real price at the NPC (ITEM_UPGRADE_MASTER_SET_ITEM/UPDATE) and labels 20 as an estimate.
- One crest type per track; no mixing (both).
- Slot discount: cheaper/free up to an item level you already had in that slot (A: Blizzard Support 000336964;
  B: GlobalStrings 50516–50521). Warband-wide only after the "… of the Mist" achievements (62410–62416).

## Crest sources — MEASURED (CurrencyTypes 3442–3446 descriptions; both rounds)

- Adventurer: repeatable outdoor events, Tier 4 delves.
- Veteran: repeatable outdoor events, Raid Finder, Heroic dungeons, delves T5–6, Trovehunter's Bounty T4–5.
- Champion: weekly outdoor events, Normal raid, Mythic 0, M+ +2–3, delves T7–10, Trovehunter's T6–7.
- Hero: Heroic raid, M+ +4–8, delves T11, Trovehunter's T8+.
- Myth: Mythic raid, M+ +9+.
- Delve tiers 1–3: no crests.
- Gilded Stash after T11, 4× a week: Hero + Myth (A MEASURED, RenownRewards 1849).
- Amounts per run: no official table (guides disagree); MH measured T8 bountiful +11 Champion, T11 bountiful +10 Hero (19 Aug).

## Delve gear (GUIDE, both rounds; Rob measured T8–11 chest 295 and Trovehunter 305 on 19 Aug)

- **Without a Restored Coffer Key / not bountiful: no real gear** (non-upgradeable or ≤ 272). The likeliest reason
  "my gear does not go up" (both rounds, INFERRED from the mechanics).
- Bountiful end chest: T1 266 … T7 292, **T8–11 295 (Champion 2/6)**.
- Great Vault, world row: T1 279 … T7 302, **T8+ 305 (Hero 1/6)**; slots at 2 / 4 / 8 activities (B GUIDE; A: Kaivax 1 Aug).
- Trovehunter's Bounty T8+: 305 Hero 1/6, once per week per character (item 265714 MEASURED).
- Keys: 100 Coffer Key Shards = 1 key, 600 shards/week (MEASURED, currency 3310); Journey rank 6: +2 keys/week.
- Heroic Soul Fragment (285807): 3 → random Hero 2/6 (308) (MEASURED). Mythical Soul Fragment (285065): Wah'du, Myth 2/6
  (game text; guides say 1/6).

## Cap — MEASURED

Blizzard 12.1.5 notes (13 Oct): "the week of October 20, the crest cap will be lifted." Before that the cap grew 100
per week (GUIDE); crests above it turned into the next lower crest (GUIDE).

## Suggested item level per delve tier (GUIDE, Icy Veins 11 Oct; not enforced)

T4 259 · T5 268 · T6 275 · T7 281 · **T8 290** · T9 296 · T10 303 · **T11 309**.
