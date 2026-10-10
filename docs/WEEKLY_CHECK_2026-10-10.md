# Weekly checklist check — 10 Oct 2026

Eight possible addon issues from the site chat's research
(`midnighthelper-site/drafts/weekly-checklist-research-2026-10-10.md`), each checked against
Blizzard's notes, wago.tools DB2, Wowhead quest pages (Quick Facts + every comment with its date,
read through `lv_comments0` on 10 Oct), Warcraft Wiki and the addon code.

- **MEASURED** = seen in a named source, with its date or build. **DERIVED** = my reasoning.
- wago.tools: "hotfixes on" means `useHotfixes=1`. Builds: 12.1.0.69933 (live) and 12.1.5.70077 (PTR).
- Wowhead comment dates are US Central time, as Wowhead stores them.
- Code was read on 10 Oct. Line numbers are from that read. Nothing was changed.
- Nothing here was checked in the game client. Each item lists the `/run` check where it matters.

## Summary

| # | Item | Verdict | Fix (file:line) |
|---|---|---|---|
| 1 | Orin's extra Voidcore | **ADDON WRONG**. It is live now, not from 12.1.5 | ResetRoutine.lua after :178: new giver `orin` |
| 2 | Purging the Vaults | **ADDON WRONG**. It is a real weekly and missing from This Week | ResetRoutine.lua after :208: new giver `abdumati` |
| 3 | Vereesa, Trailing Xal'atath | **ADDON WRONG** in weeks she does not offer it | ResetRoutine.lua:178: own `pickupKey` with honest text |
| 4 | Ritual Sites pickup | **ADDON WRONG** at enUS.lua:1791 (+ pin at ResetRoutine.lua:1172). RitualSites.lua:11 is right | enUS.lua:1791 text + ResetRoutine.lua:1172 pin |
| 5 | Gilded Stash per week | **ADDON RIGHT** (4) | none |
| 6 | Halduron, Hope in the Darkest Corners | **ADDON RIGHT** (levelling version). VaultAlts is incomplete | none (side finding below: dungeon ids) |
| 7 | Special Assignment ids / Dundun 8 | ids **valid** but list **INCOMPLETE** (3 Coiled Isle ones missing). Dundun 8 **RIGHT** | DelveWeeklyTrackers.lua:29: add 3 entries |
| 8 | Keystone Myth rating | **ADDON RIGHT** (3600). The Wiki's 3400 is the unhotfixed datamine | optional: Codex.lua:171 last sentence |

---

## 1. Orin Straylight's extra weekly Voidcore. ADDON WRONG

**Live or 12.1.5?** It is live now, since the reset of 6 Oct (US) / 7 Oct (EU). It does not wait for 12.1.5.

Evidence:
- MEASURED: Blizzard "12.1.5 Content Update Notes" (news.blizzard.com 24304162, 1 Oct 2026) lists three steps by week. Week of 6 Oct: Orin offers "Umbral Blessings of the Catalyst", which unlocks 1 extra Nebulous Voidcore a week for gold, Voidlight Marl or Veteran Mistcrests. Week of 13 Oct: "Ancient Depths, Ancient Venom". Week of 20 Oct: Venomstones, and the crest cap is lifted. The EU version of the article says "week of 7 October".
- MEASURED: Wowhead News 383270, "Weekly Bonus Rolls Now Available" (6 Oct 2026, 10:08 CDT), says it went live with this reset. The unlock needs 97945 "In the Catalyst's Shadow" + 97978 "Prismatic Potential". Cost: 5,000 gold, 2,000 Voidlight Marl or 100 Veteran crests. Icy Veins (6 Oct) and method.gg (6 Oct) say the same, and method.gg adds "2 bonus rolls a week" (vault + Orin).
- MEASURED Wowhead quests (10 Oct):
  - 97981 "Umbral Blessings of the Catalyst": Important Quest, req 90, added 12.1.0. Comments of 8 Oct: you pick it up from Orin (npc 269987) at the Catalyst. The quest marker wrongly points to Voidstorm.
  - Weekly purchase quests, all req 90, Side None, added 12.1.0: **98016** Gold (5,000 g), **98015** Voidlight Marl (2,000), **98012** Veteran Mistcrest (100, currency 3443).
  - 95279 / 95290 / 95304 are the Season 1 versions (Decimus, Dawncrest). Do not use them.
  - Icy Veins writes "80 Veteran Dawncrest". That conflicts with Wowhead 98012 (100 Veteran Mistcrest). DERIVED: Icy Veins is describing the Season 1 quest.
- MEASURED: Orin, npc 269987, Wowhead map 2393 at 40.0 / 64.4–64.6. `data/patch_12_1_5_ids.tsv:183` has 40.00 / 64.80 (Zygor).
- MEASURED in the code: a grep for `Orin|97981|98016|98015|98012|97978|97945|269987` in `Modules/` hits only a comment at `MidnightCodexData.lua:461`. So ResetRoutine has no Orin step. Only `Codex.lua:79` and `:175` mention him, and both are correct about the week of 6 Oct.
- DERIVED, not measured: that 98012/98015/98016 stay flagged until the next reset after you buy. One Wowhead news comment says Orin then shows a blue "?" like a repeatable.

**Fix**, `Modules/ResetRoutine.lua` after :178:
`{ key = "orin", name = "Orin Straylight", quests = { 98016, 98015, 98012 }, minLevel = 90, noLearn = true, pickupKey = "HOME_ROUTINE_GIVER_PICKUP_ORIN_FMT", pin = { 2393, 40.0, 64.6, "HOME_ROUTINE_PIN_ORIN" }, available = function() return C_QuestLog.IsQuestFlaggedCompleted(97981) end },`
plus 2 locale keys (enUS + nlNL + 5 packs). `noLearn`, because Orin also hands out the 12.1.5 story quests. Client check first:
`/run for _,q in ipairs({97981,98012,98015,98016}) do print(q, C_QuestLog.IsQuestFlaggedCompleted(q)) end`, once before and once after buying.

## 2. Purging the Vaults. ADDON WRONG (missing on This Week)

**Real repeatable weekly on live?** Yes.

Evidence:
- MEASURED: Wowhead quest **95520** Quick Facts (10 Oct): Type **Weekly Meta Quest**, Requires level 90. Start: **Warleader Abdumati** and Talon Commander Zela. End: Warleader Abdumati. Not sharable. Added 12.1.0.
- MEASURED, objective: reach 100% from Temple Patrols, Strikes, Incursions, Ancient Foes and elites in the Vaults of Atal'Utek.
- MEASURED, rewards on Wowhead: Corrosive Soul (273000) ×1, Trovehunter's Bounty (274374) ×1, Venom-Cursed Fragment (279382) ×1, Coffer Key Shards 125 and 187 (two entries), Voidlight Marl 150, Corrosive Coin 1,500.
- MEASURED, Wowhead comments:
  - Lazey (7 Aug): the Trovehunter's Bounty reward checks hidden flag 86371. If you already had a map this week, it is not in the rewards, and the other way round.
  - tritoch99 (14 Aug): you need "Into the Vaults of Atal'Utek" (98388) first.
  - Comments up to 1 Sep describe completing it week after week. There are none after 1 Sep.
- MEASURED, place:
  - Wowhead npc 262798 (Abdumati) is on **map 2509 (Vaults of Atal'Utek) at 47.2 / 60.8**.
  - Zygor `ZygorDailiesCommonMID.lua:2019` and `:2086` accept and turn in 95520 at "Vaults of Atal'Utek 47.24,60.81". The accept is behind `questonmap`, so it is offered again each time.
  - Zela: map 2512 at 58.6 / 45.8 (matches MH's pin at ResetRoutine.lua:208).
- MEASURED: Warcraft Wiki "Midnight Season 2" (edited 8 Oct) names Purging the Vaults as a source of the weekly Trovehunter's Bounty.
- MEASURED in the code:
  - In `Modules/`, 95520 appears only at `AtalUtekProbe.lua:78`.
  - But the claim "only AtalUtekProbe" is incomplete: `Codex.lua:161` (CODEX_ATALUTEK_BODY) already calls it "the weekly worth not missing", from Abdumati in the Amani Foothold.
  - The This Week list (GIVER_WEEKLIES, ResetRoutine.lua:90-) does not have it.
  - `ResetRoutine.lua:201` notes that Zela also gives it, and that is why she is `noLearn`.
- UNSURE: `AtalUtekProbe.lua:1781` records +2 Corrosive Soul from this quest in Rob's recorder (matched by clock time). Wowhead shows ×1.
- Minor: `AtalUtekProbe.lua:24` says "~47.24 / 60.79 on The Coiled Isle". Wowhead and Zygor put Abdumati on map 2509 (the Vaults), not on 2512.

**Fix**, `Modules/ResetRoutine.lua` after :208:
`{ key = "abdumati", name = "Warleader Abdumati", quests = { 95520 }, minLevel = 90, noLearn = true, pickupKey = "HOME_ROUTINE_GIVER_PICKUP_ABDUMATI_FMT", pin = { 2509, 47.2, 60.8, "HOME_ROUTINE_PIN_ABDUMATI" }, available = function() return C_QuestLog.IsQuestFlaggedCompleted(98388) end },`
plus 2 locale keys. `noLearn`, because Abdumati also hands out dailies (98419, 98420).

## 3. Vereesa, "Trailing Xal'atath" (98172). ADDON WRONG in off weeks

**What is true:** she does not offer it every week. Players report a per-character gap: after you finish it, she does not offer it the next week. That makes it "every other week" for someone who does it every time. No Blizzard statement found.

Evidence:
- MEASURED: Wowhead 98172 Quick Facts (10 Oct):
  - Type "Meta Quest". It is *not* "Weekly Meta Quest" like 95520, 95468 and 96995.
  - Requires 90, Start/End Vereesa Windrunner, added 12.1.0.
  - Rewards: Spark of Tides, Apex Cache, Void Vestige.
  - It says **Side: Alliance**. UNSURE: MH's id was measured on Rob's own character (code comment at :163). If that character is Horde, Wowhead's side flag is wrong. This is not an addon issue.
- MEASURED, Wowhead comments on 98172 and on item 279576 (Void Vestige):
  - 18 Aug: she is not offering it this week (+75).
  - 2 Sep: it has not shown up this week (+46).
  - 15 Sep: it did not appear this week; the poster has 2 of 4 Vestiges.
  - 16 Sep: it seems timegated to not happen every week.
  - 16 Sep and 17 Sep: two other players did get it that same week.
  - 19 Sep: one player could not pick it up.
- MEASURED: US forum thread 2338425 (18 Aug – 5 Sep) has no blue reply. Two posters on 19 Aug say it was missing on the main that had done it the week before, while alts still saw it. Posts on 2 and 5 Sep say "every other week".
- MEASURED: Wowhead News 382442 (13 Aug): one Void Vestige a week from this quest. 4 Vestiges unlock the "Silvermoon in Void" campsite.
- DERIVED: the per-character gap fits all the dated reports: offered in the US weeks of 11 Aug, 25 Aug and 8 Sep, and Rob met it on 9 Sep (code comment). It also explains why the same week reads "yes" for some players and "no" for others.
- MEASURED in the code: in `GiverState` (ResetRoutine.lua:852-968), a quest that is neither flagged nor in the log falls through to `"pickup"` (:967). In an off week, MH therefore shows a warn-coloured "pick it up next to the vault" and routes the player there.
- NOT MEASURED: whether `IsQuestFlaggedCompleted(98172)` stays true during the off week. If it does, MH already says "done" then, and only the text below is needed.

**Fix**, `Modules/ResetRoutine.lua:178`: add
`pickupKey = "HOME_ROUTINE_GIVER_PICKUP_VEREESA_FMT"`, with text like
"Weekly (%s): Trailing Xal'atath. Not offered every week (players report: not the week after you finish it). If she has nothing, it is back next week."
Client check in an off week: `/run print(C_QuestLog.IsQuestFlaggedCompleted(98172))`.

## 4. Ritual Sites pickup. ADDON WRONG at enUS.lua:1791. RitualSites.lua:11 is right

Evidence:
- MEASURED: Wowhead 95843 "Midnight: Ritual Sites" (Meta Quest, req 90, added 12.0.5) has **no Start NPC** and End: **Lady Liadrin**. Comment by Nevial (28 May): it is chosen in the quest-selection menu ("complete any ritual site"). After you accept it, it counts 0/3.
- MEASURED in the code: ResetRoutine.lua:116 and :133 record that Rob picked 95843 from Liadrin's choice on 29 Jul 2026. That is a code comment, measured then.
- MEASURED in the code, the texts disagree:
  - `RitualSites.lua:11`, `enUS.lua:1124` (RITUAL_INFO_PICKUP) and `RitualTips.lua:80` (RITUAL_WEEKLY_HINT_PICKUP) all say Liadrin, only in some weeks. That is right.
  - `enUS.lua:1791` HOME_ROUTINE_RITUAL_PICKUP says "pick it up at the Bazaar hub", and the routine step pins and routes to the hub: `ResetRoutine.lua:1172` (`pin = { HUB_MAP, ... "HOME_ROUTINE_PIN_HUB" }`) and `:1173` (`RouteRitualHub`).
  - The same wrong text is in nlNL.lua:1738, deDE.lua:148, frFR.lua:146, esES.lua:149, ptBR.lua:146 and itIT.lua:197.
- DERIVED: step 3 (ResetRoutine.lua:1149-1179) shows a warn "pickup" every week, also in weeks Liadrin does not offer it. When she does offer it, the Liadrin step (pool at :133) already covers it.
- Related, not asked, MEASURED on Wowhead: 95842 "Midnight: Void Assaults" also has no Start NPC and ends at Liadrin. The zone weeklies 94385 (start: Ranger Captain Lilatha, the hub) and 94386 (start: Kul'amara the Fierce) come from elsewhere. So HOME_ROUTINE_VOID_PICKUP ("Bazaar hub", enUS.lua:1795) is only true for 94385.

**Fix**:
- `Locales/enUS.lua:1791`: `HOME_ROUTINE_RITUAL_PICKUP = "Ritual Sites weekly: Lady Liadrin (next to the vault) offers it only in some weeks, as one of her four choices."`
- `ResetRoutine.lua:1169`: color `"soft"`.
- `ResetRoutine.lua:1172-1177`: use the GIVERS pin and `giversRoute` instead of the hub.
- Then run `check_drift` (7 packs).

## 5. Gilded Stash per week. ADDON RIGHT (4)

Evidence:
- MEASURED: wago.tools RenownRewards **1849** "Gilded Jackpot" (CovenantID 47, Level 4), in 12.1.0.69933 with hotfixes on and in 12.1.5.70077. Its text: after a Tier 11 delve a Gilded Stash appears, **4 times per week**, with Hero and Myth Mistcrests. The Season 1 rows 1622 and 1625 (CovenantID 36) are different.
- MEASURED, sources for 4: Warcraft Wiki "Midnight Season 2" (8 Oct), wowcarry Season 2 delves guide (24 Aug), conquestcapped (Aug 2026).
- MEASURED, sources for 3: khorium.pro (2 Oct) and timesaver.gg (citing Icy Veins) say 3 a week, 21 crests. That is the War Within Season 2 rule: Wowhead News 368350 (29 Jan 2025) says at most 3 Gilded Stashes a week, 7 crests each.
- DERIVED: the "3" guides carry the TWW number over.
- MEASURED, DB2 Spell (12.1.0.69933): the old TWW tooltip ("Gilded Stash looted: …/$s2", "Gilded Crests") is on spell 1216211 "Gilded Stash". Two Midnight spells carry a copy of it: 1284796 "Fabled Let Me Solo Him: Nullaeus" and 1299681 "Fabled Let Me Solo Him: Azta'rec" (whose $s2 = 3).
- DERIVED: that is copied text, not the Season 2 stash rule. It is a likely source of the "3" confusion.
- MEASURED in the code: `DelveWeeklyTrackers.lua:11` has `GILDED_MAX = 4`. `enUS.lua:3682` says "up to 4 a week".
- Side note, DERIVED and not measured in the client:
  - The counter only counts T11 runs with `wasBountiful` and does not check "lives left" (`DelveWeeklyTrackers.lua:142-146`).
  - Blizzard's renown text says "a Tier 11 delve" and does not say Bountiful. Guides and the TWW precedent say Bountiful.

**Fix**: none.

## 6. Halduron, "Hope in the Darkest Corners" (95468). ADDON RIGHT

**Which is right:** ResetRoutine.lua:139-144 is right. It is the levelling version, still live in Season 2, but only below level 90. VaultAlts is incomplete.

Evidence:
- MEASURED: Wowhead 95468 (10 Oct): Weekly Meta Quest, **Requires level 80**, Start/End Halduron, added 12.0.1. Gives XP plus a Quel'Thalas Adventurer's Cache.
- MEASURED: Warcraft Wiki "Hope in the Darkest Corners" (edited 16 Sep 2026): level 80-90, "available only to alt characters that are not yet max level".
- MEASURED: hotfix of 15 Sep 2026 (Wowhead News 382918, Wiki): delves count for this quest again. So it is live in Season 2, for levellers.
- MEASURED: Halduron's level-90 quests are the featured dungeons. Wowhead 93751–93758 all say Requires 90, Start Halduron.
- MEASURED in a local addon: `Broker_MidnightEvents/Data.lua:151-157` treats 95468 as sub-90 (`levelMax = 89`) and the featured dungeon as `levelMin = 90`.
- MEASURED: "VaultAlts" is the website vaultalts.com/wow-weekly-checklist (updated 21 Sep 2026). It is not an addon; nothing local is called that.
  - It lists 95468 as "still live in 12.1" with no level note.
  - The same table puts Trailing Xal'atath "on the Coiled Isle". That contradicts Wowhead (Vereesa, Silvermoon). So it is a weak source.

**Fix**: none.

**Side finding, UNSURE (needs the client):**
- `ResetRoutine.lua:144` and `DungeonRosterData.lua:332` use **93761** "Windrunner Spire" and **93164** "Maisara Caverns". Both give **404 on Wowhead** (10 Oct).
- Wowhead and `Broker_MidnightEvents/Data.lua:126-147` have Windrunner Spire = **93751** and Maisara Caverns = **93754** (pool 93751–93758, all "Start: Halduron").
- The code says 93761 was verified in game on 10 Jun. It is either a typo (93751 vs 93761) or a gap in Wowhead's data.
- By the code's own rule (ResetRoutine.lua:111-114: a dead id costs nothing, a missing one causes the bug), the safe fix is to **add** ids, not remove any: `quests = { 93751, 93752, 93753, 93754, 93755, 93756, 93757, 93758, 93761, 93164, 95468 }`.
- Check: `/run for _,q in ipairs({93751,93754,93761,93164}) do print(q, C_QuestLog.IsQuestFlaggedCompleted(q)) end` after doing Halduron's dungeon.

## 7. Special Assignment ids and "8 Shards of Dundun". IDS VALID, LIST INCOMPLETE. DUNDUN RIGHT

Evidence, Special Assignments:
- MEASURED: Wowhead (10 Oct). All 16 ids at `DelveWeeklyTrackers.lua:22-29` exist with matching titles.
  - In every one of the 8 pairs, `questID` is a "Capstone World Quest" and `unlockID` is an "Emissary Quest".
  - There are Season 2 comments, e.g. 93013 (25 Sep), 93438 (15 Sep), 94743 (16 Sep) and 94866 (8 Oct). The 94866 comment reports an unlock bug: "Complete 0 world quests … to unlock".
- MEASURED, missing from the list: Wowhead's quest search shows three **12.1.0 Coiled Isle** Special Assignments:
  - **Face the Swarm** 95922 (Capstone) / 96029 (Emissary)
  - **Wraith Wrath** 95918 / 96307
  - **Demand and Supply** 95921 / 96492
- MEASURED: Warcraft Wiki "Special Assignment" (edited 24 Sep 2026) lists 11 Midnight Special Assignments, including these 3. It says one or two are available each week, and each unlocks after 3 other world quests in its zone.
- MEASURED: on Wowhead (10 Oct) two are active right now: Ours Once More! (91796) and Face the Swarm (95922), each with about 2 days 20 hours left on NA.
- UNSURE: `SA_WEEKLY_MAX = 3` (`DelveWeeklyTrackers.lua:19`) against the Wiki's "one-two each week". Not measured. This is not part of the question.
- DERIVED: the pairing of the new ids (Capstone = questID, Emissary = unlockID) follows the pattern of the existing 8. The Wowhead types are MEASURED.

Evidence, Dundun:
- MEASURED: wago.tools CurrencyTypes **3376** "Shard of Dundun": MaxQty **8**, MaxEarnablePerWeek **8**, in 12.1.0.69933 and 12.1.5.70077 (hotfixes on).
- `Profession.lua:734` ("/ 8") and `Codex.lua:150` ("8 a week at most") are right.

**Fix**, `Modules/DelveWeeklyTrackers.lua` after :29:
`{ questID = 95922, unlockID = 96029, title = "Face the Swarm" }, { questID = 95918, unlockID = 96307, title = "Wraith Wrath" }, { questID = 95921, unlockID = 96492, title = "Demand and Supply" },`
Optional: `Profession.lua:734` could print `info.maxWeeklyQuantity` instead of the literal 8. The value is right today.

## 8. Keystone Myth: Season 2 rating. ADDON RIGHT (3600)

Evidence:
- MEASURED: Blizzard "12.1.5 Content Update Notes" (1 Oct 2026) and "Midnight's 12.1.5 Content Update Arrives October 13" both give **3600**. Reward: title "the Venomous Contender" and the Timelost Saddle.
- MEASURED: wago.tools build **12.1.5.70077, hotfixes on**:
  - Achievement **63690** "Midnight Keystone Myth: Season 2" says "at least **3600**".
  - Its criteria chain: tree 232362 → criteria 116983 (earn achievement 63689, "[DNT] … Season 2 Personal Achievement") → tree 232359 → child **232360 "Rating Requirement", Amount 3600**.
- MEASURED: the same build **with hotfixes off** has description "[PH]" and Amount **3400**. DERIVED: the Warcraft Wiki's 3400 ("Midnight Season 2", edited 8 Oct) comes from the unhotfixed datamine.
- MEASURED: Season 1, achievement 63097, asked 3400 (Wowhead + DB2).
- MEASURED: the achievement is not in 12.1.0.69933. That is expected for 12.1.5 content; the same query returns rows on 70077.
- MEASURED in the code: `Codex.lua:171` says 3600, and Season 1 3400. Both right. Only its last sentence ("still said [PH]") is now outdated.

**Fix**, optional, `Locales/Codex.lua:171`: replace the last bullet with "Blizzard's notes and the hotfixed game data both say 3600; some datamined lists still show 3400." Then run `check_drift`.

---

## Not measured (client checks before shipping 1, 2, 3 and 6)

- 1: `/run for _,q in ipairs({97981,98012,98015,98016}) do print(q, C_QuestLog.IsQuestFlaggedCompleted(q)) end`, before and after buying.
- 2: is 95520 flagged after hand-in, and is Abdumati at 2509 47.2/60.8?
- 3: in an off week, `/run print(C_QuestLog.IsQuestFlaggedCompleted(98172))`.
- 6: Halduron's real dungeon ids (93751… or 93761…).
