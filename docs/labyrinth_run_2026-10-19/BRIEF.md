# Brief: Rob's Labyrinth run of 19 Oct 2026, video analysis

Rob (the Midnight Helper maintainer, a Prot Paladin tank) recorded his whole run of **The Labyrinth of Kindo'jan**
(WoW 12.1.5 delve, tier 11, solo with companion Valeera) on 19 Oct 2026. MH's Delve Log (MEASURED): 10 rooms, 0 deaths,
5723 s, key used, end boss Kindo'jan. MH's room-boss log: 10:33:26 Den'zara encounter start, 10:35:13 Kindo'jan encounter
start; other room-boss pulls at 09:11:22, 10:03:05, 10:09:52 and 10:25:12 (names unreadable).

## Videos
All in `C:\Users\RobHu\Videos\Captures\`. The file name is the start time (local clock):
`World of Warcraft 2026-10-19 HH-MM-SS.mp4`. Rob plays on a **32:9** screen. Downscaled to 1280 wide, chat and
small text are unreadable, so take crops at full resolution for the left third (chat), the right third (minimap,
quest tracker, MH arrow) and the middle (MH windows) when you need to read them.

🔴 **NEVER delete, move or change any video.** Rob: "gooi de files dan niet weg". Read only.

## Tools
- ffmpeg: `C:\Users\RobHu\Tools\ffmpeg\ffmpeg-9.0.2-essentials_build\bin\ffmpeg.exe` (ffprobe is next to it).
- Write frames ONLY under your own folder:
  `C:\Users\RobHu\AppData\Local\Temp\claude\E--World-of-Warcraft--retail--Interface-AddOns\5628ab90-e9cb-4aca-b39c-6a5803c9ff79\scratchpad\labyrinth_2026-10-19\frames_<your letter>\`
- One shell command per call. No `&&`, no pipes, no heredocs. Example of a coarse pass, 1 frame per 10 s:
  `"<ffmpeg>" -hide_banner -loglevel error -i "<video>" -vf "fps=1/10,scale=1920:-1" "<dir>\a_%04d.jpg"`
  Crop the right third at full resolution: `-vf "fps=1/10,crop=iw/3:ih:2*iw/3:0"`. Use `-ss <sec>` before `-i`
  for fine passes around key moments (for example 1 frame per second).
- Then look at the frames with the Read tool. Frame n of an fps=1/10 pass sits at (n-1)*10 s into the video.
- Go coarse first, then fine around bosses, chests, masks and MH windows.

## What MH knows (read these, don't change them)
- Chest list with numbers #1-#38 plus extras: `E:\World of Warcraft\_retail_\Interface\AddOns\MidnightHelper\Modules\DelveChestData.lua` lines 86-155 (map 2647, coordinates x/y in map percent, room names, `seal = N` = Journey rank).
- Labyrinth texts: grep `DELVE_TIP_LABYRINTH_BOSS`, `DELVE_TIP_LABYRINTH_ROOMS` in `MidnightHelper\Locales\enUS.lua`, and `CODEX_LABYRINTH_BODY`, `CODEX_LABJOURNEY_BODY` in `MidnightHelper\Locales\Codex.lua` (English block, lines 118-273).
- Hexmasks: five shared spots, each run 3 masks + the locked door + 1 empty, random: Chamber of Rites 50.3/82.6,
  The Cave Towers 88.5/51.5, Akil'zon's Roost 56.8/17.8, Jan'alai's Refuge 18.8/18.2, Nalorakk's Rest 58.5/21.7.
- The Flooded Chamber (chests #3 #11 #12 #14 #25) sits behind an ice wall that needs fire (the Fiery Hexmask).

## What we want from your part, per room, with video time AND clock time (file start + offset)
1. Which room it is (the zone text under the minimap, or the room name on screen), and when he enters and leaves.
2. Room boss: name, what it does, how long it took, anything that matches or contradicts our tips. If Sha'Kuro: how long his stun lasts.
3. Chests: every chest he opens or walks past. Where (minimap/map position if readable), and what MH's arrow or label said (chest number).
4. Hexmasks and the locked door: where he saw them, which mask, whether he clicked it, and what it did.
5. Mislaid Treasures, Corrosive Souls, other pickups.
6. MH on screen: every MH window, arrow, button, chat line or popup. Did it help, confuse, show wrong info, or overlap? Any Lua error or BugSack.
7. Moments where Rob seems lost or searching (running back and forth, map open a long time). Rob said he could NOT find some chests, for example **chest number 14** ("seems to stand in the middle of nowhere"), and found 2 of the 3 Hexmasks, learning too late that he had to look for them and could use the arrow.

Label everything MEASURED (seen in a frame, give the frame and time) or INFERRED. Don't guess at names you cannot read.

## Output
Write your report to `...\scratchpad\labyrinth_2026-10-19\report_<your letter>.md`: a timeline table first, then
findings under the 7 headings above, then "MH improvement ideas" (concrete, with the moment that shows the need).
Reply with a short summary of the most important findings.
