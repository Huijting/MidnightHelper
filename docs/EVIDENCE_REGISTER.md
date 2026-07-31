# Evidence register

Meaningful gameplay claims and implementation-critical values, with how well each one
is actually known. Not a dump of every constant — only things that would mislead a
player, or break the addon, if they were wrong.

**Statuses:** `OFFICIAL_CONFIRMED` · `IN_GAME_VERIFIED` · `ADDON_RESEARCH` ·
`PTR_PROVISIONAL` · `COMMUNITY_REPORTED` · `UNKNOWN`

`IN_GAME_VERIFIED` means the live client was asked directly. `PTR_PROVISIONAL` includes
things measured on the PTR: the measurement is real, but the PTR is not live.

---

## Season 1 — things that expire

| Topic | Claim or value | Status | Patch | Source | Checked | Code | Notes |
|---|---|---|---|---|---|---|---|
| Keystone Master S1 | achievement 61256 | IN_GAME_VERIFIED | 12.0.7 | `/mh season` resolved the name | 2026-07-11 | `SeasonTransitionData.lua` | |
| "of the Dawn" set | achievements 42767-42770 + 1 | IN_GAME_VERIFIED | 12.0.7 | `/mh crests` resolved all names | 2026-07-24 | `DawncrestData.lua` | The odd-looking low ids are correct — header warns against "fixing" them |
| My Shady Nemesis | achievement 61797 | IN_GAME_VERIFIED | 12.0.7 | `/mh ach nullaeus` id sweep | 2026-07-27 | `SeasonTransitionData.lua` | Hidden Feat of Strength; invisible to a category walk. Criteria not yet read |
| Lighting the Dark | achievement 61798, reward "Title: the Ominous" | IN_GAME_VERIFIED | 12.0.7 | `/mh ach id 61798` — criteria and reward read | 2026-07-27 | `SeasonTransitionData.lua` | Description: "Defeat Nullaeus in his lair on Tier ?? before the release of the next season of delves." The "??" is verbatim from the client |
| Let Me Solo Him | achievement 61799 | IN_GAME_VERIFIED | 12.0.7 | id sweep | 2026-07-27 | `SeasonTransitionData.lua` | Criteria not yet read |
| Fabled Let Me Solo Him | achievement 61808 | IN_GAME_VERIFIED | 12.0.7 | id sweep | 2026-07-27 | not wired | A fifth nobody announced. Unknown what it asks |
| Prey capstone | achievement 62351 "Preying For Midnight", reward "Title: Preyseeker", meta of 7 | IN_GAME_VERIFIED | 12.0.7 | `/mh ach id 62351` | 2026-07-27 | `SeasonTransitionData.lua` | |
| Nemesis name | spelled **Nullaeus** | IN_GAME_VERIFIED | 12.0.7 | achievement 61798 description | 2026-07-27 | locale files | The announcement spelled it both "Nulleaus" and "Nullaeus" |
| Nemesis rewards | item 263413 "Nullaeus Domaneye"; mount item 263222 "Arcanovoid Construct" | COMMUNITY_REPORTED | 12.0.7 | Wowhead, S1-ending post | 2026-07-25 | comment only, shown nowhere | Item ids cannot be swept the way currencies can |
| S1 Mythic+ season id | 17 | IN_GAME_VERIFIED | 12.0.7 | `C_MythicPlus.GetCurrentSeason()` via `/mh season` | 2026-07-19 | `SeasonTransitionData.lua` | Makes the S2 gate self-learning |
| Weekly crest cap | **does not exist** | IN_GAME_VERIFIED | 12.0.7 | `maxQuantity` / `maxWeeklyQuantity` = 0 on all five tiers | 2026-07-22 | removed from `DawncrestGuide.lua` | A guide claimed ~100/week. Refuted; nothing put in its place |
| Crest sources per tier | full source list + ilvl range | IN_GAME_VERIFIED | 12.0.7 | `C_CurrencyInfo`, already localised | 2026-07-22 | `docs/CREST_SOURCES_MEASURED.md` | No hardcoding needed |

## Patch 12.1 / Season 2

| Topic | Claim or value | Status | Patch | Source | Checked | Code | Notes |
|---|---|---|---|---|---|---|---|
| S2 dungeon roster | 8 dungeons, journalInstanceIDs + encounterIDs | PTR_PROVISIONAL | 12.1.0 | Encounter Journal via `/mh ej save`, build 120100 | 2026-07-27 | `DungeonRosterData.lua` | `docs/PTR_S2_ENCOUNTERS.md`. Three counts cross-check against the patch notes |
| Venomous Abyss order | 2888, 2874, 2894, 2882, 2871, 2887, 2883, 2895 | PTR_PROVISIONAL | 12.1.0 | Encounter Journal index | 2026-07-27 | `RaidCoachData.lua` | **Not** ascending and **not** DBM's SetEncounterID order. Only the journal index gives fight order |
| Tidebound Grotto | journalInstanceID 1317, encounter 2849, single boss | PTR_PROVISIONAL | 12.1.0 | journal + DBM-Lairs-Midnight | 2026-07-27 | `TideboundGrottoCoach.lua` | Listed under raids, one boss — consistent with a lair |
| `EJ_GetCreatureInfo` 1st return | journal creature entry id, **not** an NPC id | IN_GAME_VERIFIED | 12.1.0 | four-digit values for Midnight bosses | 2026-07-27 | `EncounterCapture.lua` | Was mislabelled `creatureID` for one run |
| Valeera poisons | node 110784: Soulthirst 1250826, Forgotten Master 1249934, Bloodcrypt 1251120 | PTR_PROVISIONAL | 12.1.0 | `/mh valeera save`, tree 1223 | 2026-07-27 | `DelveCuriosData.lua` | `docs/PTR_VALEERA_TREE.md` |
| Valeera poison ids (old) | 1248517 / 1251113 / 1251862 | **REFUTED** | — | Wowhead, 2026-07-12 | 2026-07-27 | removed | None match the client. The effect descriptions came from the same source and are therefore unproven too |
| Poison effects | which poison does what | UNKNOWN | 12.1.0 | — | — | shown from `C_Spell.GetSpellDescription` at runtime | No recommendation is given, deliberately |
| Delves on offer | 10, with poi ids and coordinates | PTR_PROVISIONAL | 12.1.0 | `C_AreaPoiInfo.GetDelvesForMap` | 2026-07-27 | `docs/PTR_DELVE_SCAN.md` | The three datamined S2 delves did **not** appear. That proves nothing: the API returns what is on offer, and S2 opens after the patch |
| New S2 delves | The Ring of Glory, Gnarldor Isle, Venomfall Deeps | COMMUNITY_REPORTED | 12.1.0 | Wowhead datamining | 2026-06-20 | not implemented | Re-scan once Season 2 is live |
| S2 nemesis | "Azta'rec" | COMMUNITY_REPORTED | 12.1.0 | Wowhead datamining | 2026-06-25 | not implemented | |
| Auras secret in 12.1 | `ShouldAurasBeSecret` = false **OUT OF COMBAT ONLY** | UNKNOWN in combat | 12.1.0 | `/mh auras` outside and inside a delve, build 120100 | 2026-07-27 | `Modules/Auras.lua` | ⚠️ **The 27 jul conclusion "not a blocker" was measured in the wrong state.** Both readings were taken standing still, out of combat. JustAC 4.55.0 (BlizzardAPI.lua:82) models the flag as flipping at combat edges and falls back to `IS_MIDNIGHT_OR_LATER and InCombatLockdown()` — i.e. secret IN combat, validated in-game on 12.0.7 per its own comment. Re-measure during a fight |
| CombatSafety 12.1 crash | fixed | PTR_PROVISIONAL | 12.1.0 | multiple delve fights, BugGrabber silent | 2026-07-27 | `CombatSafety.lua` | Symptom gone. The mechanism (secret geometry on `SetAlphaFromBoolean` frames) is reasoned, not proven |
| Roleset system | present and live on 12.1; every frame defaults to roleset `roleless` | PTR_PROVISIONAL | 12.1.0 | `/mh roleset save`, build 120100 | 2026-07-27 | `Modules/ApiProbe.lua` | `C_Roleset` has ApplyRolesetFilters, GetActiveAllowedRolesets, GetActiveBlockedRolesets; every frame has AddRoleset, SetRolesets, RemoveRoleset, GetRolesetNames, IsRolesetFiltered |
| Roleset filtering, right now | **nothing is filtered** | PTR_PROVISIONAL | 12.1.0 | allowed = `{}`, blocked = `{}`; `IsRolesetFiltered()` false on every MH frame checked | 2026-07-27 | — | Measured, not assumed. Not a blocker for 2.12.0 |
| Roleset risk that remains | an ACTIVE ALLOWLIST that omits `roleless` would hide every default frame | UNKNOWN | 12.1.0 | reasoning from the measured shape | 2026-07-27 | — | Both lists are empty today. Unknown which content activates one, or which roleset names exist. `IsRolesetFiltered()` lets us detect it rather than guess |
| S2 item levels | +46 over Season 1; tracks Adventurer 259-276 … ~337 | COMMUNITY_REPORTED | 12.1.0 | Wowhead / Icy Veins | 2026-07-27 | not implemented | Used only to answer a question, not shown anywhere |
| Gear at a rollover | existing gear keeps its item level | ADDON_RESEARCH | 12.1.0 | S2 item levels increase rather than decrease; a stat squish is an expansion pre-patch event | 2026-07-27 | `Locales/Codex.lua` | Codex states the mechanic without numbers |
| 12.1 patch date | 11 August (US) / 12 August (EU) | OFFICIAL_CONFIRMED | 12.1.0 | Blizzard, "Curse of Ula'tek Goes Live August 11!" — news.blizzard.com article 24294370 | 2026-07-31 | nowhere yet | Announced in the article's own headline and on the launcher front page. The 11/12 split is our EU convention: 11 Aug is a US Tuesday reset, so Europe lands a day later |
| Season 2 start | week of 18 August | OFFICIAL_CONFIRMED | 12.1.0 | Blizzard, "The Shadows Deepen: Midnight Season 2 Begins August 18" — article 24294369; the patch article adds "One week after the content update goes live the new season will begin" | 2026-07-31 | `Locales/*.lua` `ST_SEASON_SOON`, shown by `Modules/SeasonTransition.lua` in the prep phase | Player-facing wording says **week of**, not a bare date, because the US and EU resets fall on different days |

## Method notes

Three claims died on their own description in a single day (2026-07-27): an achievement
whose name matched but whose criteria described a different fight, a boss order that
looked sorted, and a column labelled `creatureID` that held something else. **A matching
name is not evidence. Read the criteria, the description, or the range.**
