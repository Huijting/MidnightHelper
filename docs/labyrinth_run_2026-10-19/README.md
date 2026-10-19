# Rob's Labyrinth run, 19 Oct 2026 — what the video showed

10 videos in `C:\Users\RobHu\Videos\Captures\` (`World of Warcraft 2026-10-19 09-03-05.mp4` … `10-33-04.mp4`, ~27 GB).
🔴 **Keep them** (Rob: *"gooi de files dan niet weg"*). Five `mh-research` analysts, one per stretch: `report_A.md` …
`report_E.md`, brief in `BRIEF.md`. Frames stayed in the session scratchpad (temporary).

**Run (MH Delve Log, MEASURED):** tier 11, 10 rooms, 0 deaths, 5723 s, key used, end boss Kindo'jan.
**Character:** Earthshammy (Elemental Shaman), Valeera as healer (MEASURED in all five reports).

## The ten rooms (MEASURED, clock time)

| # | Room | Task (game name) | Boss | Time |
|---|---|---|---|---|
| 1 | Chamber of Rites | Graverobbers | The Drill Sergeant (~90 s; "Drilling Charge", "Seismic Detonation") | 09:03–09:14 |
| 2 | The Reliquary | **Reigns** of the Warlord (MH writes "Reins") | Pit Boss (among Relic Raiders), Daakajin (~35 s) | 09:14–09:26 |
| 3 | Halazzi's Lair | Fools and Curses | optional Pit Boss elite | 09:27–09:41 |
| 4 | Central Chamber | Returning the Bounty | Pit Boss | 09:42–09:48 |
| 5 | The Catacombs | Encroaching Darkness (4 Flames of Jan'alai) | — | 09:49–09:57 |
| 6 | The Cave Towers | Raging Spirits | The Undead Trollbunal (~50 s; no MH tip) | 09:57–10:04 |
| 7 | Nalorakk's Rest | Malicious Masks | Grukk (~49 s; Interrupting Shout = school lock 3.9 s) | 10:05–10:11 |
| 8 | Akil'zon's Roost | The Wandering | — | 10:13–10:17 |
| 9 | Jan'alai's Refuge | Taken Antiquities | Sha'Kuro (~94 s) | 10:18–10:26 |
| 10 | De Empire's Rest | — | Den'zara (~15 s) → Kindo'jan (3:25.65, DBM) | 10:32–10:38 |

## Hexmasks and the locked door, this run

- **Akil'zon's Roost = Locked Door** (MEASURED, tried 3×, "Requires Archaic Amani Key").
- **Jan'alai's Refuge = Fiery Hexmask** (MEASURED, clicked 10:24:43).
- **Nalorakk's Rest = a mask** (MEASURED "Collecting" 10:08:58). The Frozen Hexmask in the boss room → INFERRED Frozen.
- **Chamber of Rites = empty** (INFERRED; nothing at 50.4/81.6 at 10:30:48).
- **The Cave Towers = the third mask (Thundering)**, INFERRED by elimination. Rob spent ~7 min in that room without going to 88.5/51.5.
- **Keeper of the Key** seen in Halazzi's Lair (09:34) and in Jan'alai's Refuge (10:22), both passed.
- Both masks fought along into Kindo'jan's room (MEASURED presence; damage not measured).

## Chest 14 — solved

All five chests still open were in the **Flooded Chamber** (#3 #11 #12 #14 #25; "40 of 44"). The map draws no room there
(MEASURED, world map 09:48:24). The way in is behind an ice wall that needs the Fiery Hexmask. Rob followed the arrow to
16 m and ended in a dead-end alcove at 63.2/43.6 (10:11:31). The arrow pointed there ~23.5 min, and MH's chat line said
"that room may not be open" instead of "ice wall, needs the Fiery Hexmask". Rob had the Fiery Hexmask from 10:24:43 and
never went back.

## MH bugs (MEASURED)

1. **Codex card said "no gift picked yet"** while two gifts were ticked (09:04, 10:28). Fixed in code 19 Oct (three signals + re-read every 0.5 s); not yet tested.
2. **"Room boss: Kindo'jan – show tips?" opens the Coach on the Overview**, not on the boss (`DelveCoach.lua:1762-1767`). No boss tip on screen the whole fight. It also says "Room boss" for the end boss.
3. **Chest skip loop**: once all five Flooded Chamber chests are skipped, every click says "Skipped Sturdy Chest 11 — it comes back last" (10:19:36–10:20:05).
4. **"1 empty sockets"** (Gear check, no singular).
5. **Valeera panel Poisons slot "No recommendation"** while the Kindo'jan tip names Bursting Toad Toxin.

## Tip texts that the video contradicts or completes

- 🔴 **Kindo'jan intermission:** no intermission at 72% or 67%; the loa tests started at **33%** (88 s after the pull). One fight; Rob earlier set "70%, zoals in de video". Rob decides.
- Halazzi in the intermission: a targetable **"Shadow of Halazzi"**.
- Den'zara: ~15 s, then she raises Kindo'jan; ~40 s of RP before he can be attacked.
- Hexmasks in the boss room: seen, so "players say" can go.
- Task names: Graverobbers, Reigns of the Warlord, Fools and Curses, Returning the Bounty, Encroaching Darkness, Raging Spirits, Malicious Masks, The Wandering, Taken Antiquities.
- Drill Sergeant: "Drilling Charge". Pit Boss also in the Reliquary and in Fools and Curses.
- Trollbunal: Shredding Swipe, Soul Roar, Fire Cascade, Crushing Slam — MH has nothing (research needed).
- Grukk: Interrupting Shout locks a spell school ~4 s.
- In-game object name "Loa-Spirit Mist/Wind Conduit" (Codex says "Loa-Spiritual Conduits").

## Ideas (from the moments above)

- **Flooded Chamber**: say "ice wall, needs the Fiery Hexmask" in the route; put its 5 chests at the back as one group; after the Fiery Hexmask, "you can melt the ice wall now".
- **Hexmask help**: hint on entering one of the five rooms (rank 2+), a Coach button that routes through the five spots, "hexmask" as a search word (Rob searched "hex" at 10:30:15), a Keeper of the Key hint ("kill him for the locked-door key").
- **Arrow**: "no chests left in this room" on screen too, not only in chat; one number per chest.
- **Overlaps**: DANGEROUS CAST over the minimap zone text; Delve Coach over the minimap; Battle res panel over the world map; Valeera's "?" row in the consumable check.

## Questions for Rob

1. The 70% line: keep it, or follow this fight (33%)?
2. Two big health drops on Kindo'jan (67→43% at once, 18→4%), each when a green 15-stack debuff disappeared. Which gifts did you have at the boss?
3. Bloodlust went in phase 1 and the kill took 3:25. Keep "use it in phase 2"?
