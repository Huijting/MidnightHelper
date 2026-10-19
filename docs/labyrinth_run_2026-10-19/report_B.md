# Report B — videos 09-27-08 + 09-42-14 (saved by the main session; the agent's Write was refused)

Character: **Earthshammy (Elemental Shaman)**, not the Prot Paladin. Valeera heals.

## Timeline (clock time)
- before 09:27: Reliquary room, Reins of the Warlord (Warlord Kaz'kara yell 09:25) — INFERRED
- 09:27:08 Reliquary portal "Enter Halazzi's Lair"; arrow "Sturdy Chest 44, 159m"
- 09:27:18–09:41:18 **Halazzi's Lair, "Fools and Curses"** (0/5 Cursed Energy). ~14 min.
  - 09:28:24 "Loa-Spirit Mist Conduit" at 21.72/45.63 (not clicked, INFERRED)
  - 09:30:16 chest 42 at 11.72/54.54 (Halazzi's Shroud), 09:30:22 chest 44 at 10.59/55.68, 09:30:36 chest 43 at 9.40/54.74 — all seal 9, within 0.3 of our data (MEASURED)
  - 09:30:36 MH: "No chests left in Halazzi's Lair … next one is in Flooded Chamber: that room may not be open …" → arrow on **Sturdy Chest 25 (61.16/44.80)** and it stays there until after 09:49:09
  - 09:34:43–09:35:48 **Keeper of the Key** (lvl 90) near 21/39 — not attacked
  - 09:38:38–~09:39:15 **Pit Boss** elite (Relic Raiders, cast "Bombardment") — appears in Fools and Curses; tracker stays 4/5 → optional (INFERRED)
  - stuck at 4/5 ~5.5 min; carried the last curse east first (29.7/47.5, 29.6/41.7) before the sarcophagus at ~19/44
- 09:42:24–09:48:04 **Central Chamber, "Returning the Bounty"**: bundle → 10 Hoarding Looters (stuck at 7/10 ~90 s, wandered into Chamber of Rites doorway 44.1/85.0) → Pit Boss (<40 s) → timed grab 00:44 → Impressive Treasure Chest
- 09:48:24 world map: chest-25 dot on blank parchment between the Central ring and Nalorakk's Rest (MEASURED)

## Key findings
1. Arrow pointed at unreachable chest 25 (Flooded Chamber) for 18+ minutes; warned once in chat only.
2. "Middle of nowhere" = the Flooded Chamber is not drawn on the map; chests 3/11/12/14/25 all sit there.
3. Sealed Halazzi chests (#41–43 HN) placed correctly → Journey rank 9 likely.
4. Task names: "Fools and Curses", "Returning the Bounty". Pit Boss can appear in Fools and Curses (our tip says "without a boss").
5. MH "DANGEROUS CAST" warning overlaps the zone text above the minimap.
6. Chest labels: "Sturdy Chest N" = list position; plus "35 of 44" counter → two numbers for one chest. Data-file comments #37/#38 sit at list positions 36/37.
7. In-game object name "Loa-Spirit Mist Conduit"; Codex says "Loa-Spiritual Conduits".
8. MH room-boss log has no pull 09:27–09:49: Pit Boss and Daakajin have no encounterId in DelveBossShowcase.lua 332/334.

## Ideas
1. Park/skip the route on the arrow itself when all remaining chests are in the Flooded Chamber (or no Fiery Hexmask).
2. Explain the Flooded Chamber (not drawn on map, ice wall needs fire); measure its entrance first.
3. One number per chest ("Chest 25 — 37 of 44 opened").
4. Add task names to DELVE_TIP_LABYRINTH_ROOMS.
5. Use the in-game name "Loa-Spirit Mist Conduit".
6. Keeper of the Key hint ("kill him for the locked-door key"); new spot: Halazzi's Lair.
7. Move the default DANGEROUS CAST position off the zone text.
8. Fix data-file comments.
