# Corrosive Codex — gifts, picks and the window (19 Oct 2026)

Two independent `mh-research` rounds plus a live measurement on Rob's client. Source for `Modules/CodexAdvicePanel.lua`.

## The window — MEASURED (Rob's client, /run into MidnightHelperDB.codexChoice, 19 Oct)

- Blizzard `PlayerChoiceFrame` (load-on-demand `Blizzard_PlayerChoice`), choiceID **1076**, questionText "Corrosive Codex".
- One option (id 6145, widgetSetID 2281) with **12 buttons, ids 13–24**:
  13 Ophidian Maw · 14 Viperine Grasp · 15 Mephitic Cloud · 16 Gorgoneion Gaze · 17 Lithic Plumage · 18 Ouroboric Cycle ·
  19 Insidious Venom · 20 Virulent Mucus · 21 Accursed Poison · 22 Plague of Corrosion · 23 Miasma Geyser · 24 Ula'tek's Gift
- A gift you have = the atlas `common-icon-checkmark` at the start of the button text. `selected` and `showCheckmark` were **false** on both of Rob's picks.
- Rob's picks that evening: Lithic Plumage + Insidious Venom. The other ten had `disabled = true`.
- Opens on `PLAYER_CHOICE_UPDATE`, closes on `PLAYER_CHOICE_CLOSE` (round B, wow-ui-source live b9be937971 = 12.1.5.70448).

## Spell IDs — MEASURED (wago 12.1.5.70448)

Codex versions 1303467–1303478: Lithic 1303467, Ouroboric 1303468, Gaze 1303469, Mephitic 1303470, Viperine 1303471, Maw 1303472,
Mucus 1303473, Accursed 1303474, Plague 1303475, Miasma 1303476, Ula'tek 1303477, Insidious 1303478.
Proc: about 1 per minute each, Ula'tek 2 per minute. Second slot at 8 unlocked: Blizzard's own article (round B).

## Poison: two kinds — MEASURED text, from the tooltips in Rob's dump

- **You poisoned** pays off only on **Ula'tek's Gift** (+5 stacks) and **Ouroboric Cycle** (+1 s per step). Only **Insidious Venom** poisons you.
- **Enemy poisoned** pays off on Maw, Viperine, Lithic, Mucus and Miasma. Plague, Accursed, Gaze and Mephitic poison enemies.
- So **Lithic + Insidious do nothing for each other**. expcarry (2 Oct) and mythic-store (24 Aug) say the same; no source recommends that pair.

## Picks — GUIDE OPINION, counted across both rounds

| Situation | Pick | Sources |
|---|---|---|
| First gift | Ula'tek's Gift | 8 of 9 general guides (Method 10 Oct, expcarry 2 Oct, Icy Veins 24 Aug, Wowvendor 23 Aug, Mythic-Store, Boostmatch, a Wowhead comment, …). RPGStash hedges; Moleman picks Ouroboric. |
| Bosses, Kindo'jan | Ula'tek + Insidious Venom | Method boss guide 10 Oct; Kingboost, Skycoach and MMOGah copy it. Mein-MMO (15 Oct) alone says Ula'tek + Ophidian Maw. |
| Trash, groups | Plague of Corrosion + Ophidian Maw | 5 (Wowvendor, Mythic-Store, RPGStash, Wowhead comment, expcarry "Best for Delves"); ConCon video 17 Oct |
| Survival | Virulent Mucus + Gorgoneion Gaze | 4 current + 2 older |
| Casters | Accursed Poison | the existing Codex card; the tooltip measures it |
| "Best overall" (not used) | Ouroboric + Plague | 5 guides. But Plague poisons enemies and Ouroboric wants YOU poisoned, so the text gives them no link. Left out on purpose. |

Lithic Plumage: no source above C (Method D).

## Open, not built on

- **Mephitic Cloud:** enemies' abilities "additionally heal their target". Round A reads that as the player they hit (a benefit); guides read it as enemies healing. The panel no longer warns about it.
- **Ouroboric Cycle** lost its "Offer 8 Corrosive Souls" tooltip line in 12.1.5 (both rounds). The meaning is unknown.
- **Codex card `CODEX_CORRPOWER_BODY`:** round A found three claims that are not supported, listed in NEXT_SESSION.
