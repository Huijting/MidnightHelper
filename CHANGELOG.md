# Changelog

All notable changes to this project are documented in this file.

## 3.4.0

- **Professions 101 became a real beginner course.** Six chapters new or rewritten from the beginner copy in `docs/COPY_*_BEGINNER.md`: quality, the six profession stats, Concentration, work orders, patron orders (split out of work orders — it is the largest weekly Knowledge source, sits at a different place, and carries a timing trap), and making gold. The gold chapter introduces `datedKey`: its perishable half lives in `PROFACAD_CH_GOLD_DATED_202608`, so a re-measurement replaces one string instead of seven language packs. ⚠️ On re-measurement write a NEW dated key and repoint the chapter — editing in place discards the only signal of how old the advice is.
- **Contents rail + a window of its own.** Measured first: 14 chapters, ~32k characters, ~355 rendered lines, roughly thirteen screens. The rail is off by default (`ns.db.profAcadContents`); the window is `/mh course` and a Pop-out windows card. The window renders but does not own — chapter list, ticks, selection and text all come from `ProfessionAcademy`, and `ComposeChapterBody` was extracted out of the refresh loop so both surfaces build the text from one implementation.
- **All ten remaining advisor routes corrected** (Spec 28, on Spec 24 + gamedata build 12.1.0.69382). New schema fields, backwards compatible: `points` (a hint, with the in-game tooltip named as the authority — sources disagreed at every profession, sometimes by a factor of two), `points = 0` (open the branch, invest nothing; satisfied the moment it is unlocked), and `goals`, which shows BOTH branches rather than resolving to one. The old `anyOf` hid the gold-versus-self choice; picking for the player would only replace a coin flip with a guess. `Craftsmithing` removed from Blacksmithing — added in July with a citation that did not cover it. Enchanting's order reversed: disenchanting reads raw Skill and ignores every craft stat, so the first ~50 points we recommended did nothing (Wowhead's own boilerplate table contradicts its own prose — do not restore it). Inscription's double spelling retired: gamedata settles it at trait 109660 `Perfected Products`; the "Perfect …" names belong to its sub-branches.
- **Stopped advising unspendable Knowledge.** `CanSpendKnowledge` in `Profession.lua`: any tab unlockable **or** any root at `activeRank >= 1`. ⚠️ `ShouldShowPointsReminderForSkillLine` is the WRONG function — measured across six professions it returned true where nothing was unlockable and false where four tabs were. And the lock is invisible on the node: a padlocked tab reported `canPurchaseRank`, `isAvailable` and `meetsEdgeRequirements` all true. Found by enumerating `C_ProfSpecs` rather than guessing an API name.
- Corrected: the work orders chapter claimed four public orders **per day** (it is four held, one returning daily) and described one order table where there are two counters — you order at the table, you craft at your own workbench. The node list under the advice line no longer calls itself "your open choices" (they are nodes inside trees, not alternatives, and availability is never checked) and reports `4 of N` instead of truncating in silence.
- New: `/mh fp` and a city-guide button point the arrow at the nearest flight master from wherever you stand. Compares in world yards rather than raw map coordinates, because map units are not square — the shared `GetNearestFlightPoint` comparison is left alone for its six other callers. Silvermoon's two flight masters added to the city guide, built by reading `ns.FLIGHT_POINTS` rather than copying coordinates into a second place.
- **Five language packs had stale copies of seven corrected strings.** A pack that carries a key does not fall back, so German, French, Spanish, Portuguese and Italian kept showing the old wording — including "four per day", and Alchemy/Herbalism chapter text that contradicted the corrected routes beside it (route data has no language). The stale entries are deleted so they fall back to the corrected English. Wrong text in your own language is worse than correct text in a language you can read.

## 3.3.0

- **Corrected: "Knowledge Points are permanent, there is no way to refund or respec them"** in `PROFACAD_CH_TREES_BODY`, all seven languages. Untrue since 11 Aug 2026 — one reset per profession, from Theremis in Silvermoon City, and it also takes back the recipes those points taught. Deliberately rewritten rather than deleted: dropping the sentence swings the text from too strict to too loose, and too loose is the more dangerous error, since a beginner who believes they can experiment freely burns their single reset. The reassurance that survives is that points cannot be wasted, only misordered. A route button to Theremis and a search entry shipped alongside it.
- **Corrected: `advisorRoutes[202]` (Engineering) had Recycling last.** In Midnight recycling is the recipe-discovery engine and stays switched off until points go into it, so our route sent players to a dead end and let them conclude the feature was broken. Moved to the front.
- **Corrected: Leatherworking contradicted itself on one screen** — the route said armour tree first, `PROFACAD_CH_LEATHERWORKING_BODY` said "Learned Leatherworker first". The route was deliberately flipped on 24 Jul and the prose was not, so the prose was the stale half; corrected in all seven languages rather than reverting the route.
- **Three gear slots could never reach a recommendation, and it was the data model rather than a missing row.** Rings and weapons were keyed by secondary stat, which put Eyes of the Eagle (1236059) and the primary-stat weapon proc (1236095) permanently out of reach; the weapon slot is now role-aware via `ns.GetPlayerRoleKey()`. Shoulders gained the Speed / Leech / Avoidance trio head and feet already had (243963 / 244021 / 243991), brute-forced with `/mh item save` over an id range because no readable source carried them. Head completed with Empowered Hex of Leeching. Legs show both kits and both spellthreads and assert no rule about choosing between them — the Agi-versus-Str split some sources publish is not an axis the item tooltips recognise.
- Seventeen flask and combat-potion picks refreshed against the guide already cited, plus seven the checker could not resolve by name. New `tools/check_consumables.py` compares our picks to that guide and reports where ours is not named, so this can go stale loudly instead of quietly. Both vault-stat generators now write atomically.
- Ritual tier item levels restored and measured at the obelisk (T1 215 · T2 231 · T3 244 · T4 259 · T5 268 · T6 275); tier 6 exists and needs six challenges. We had been printing wrong numbers and separately contradicting ourselves about how many tiers there are.
- Withdrawn or corrected: two Codex crest claims that outlived their season, the Field Accolade vendor tracks and their prices, a promised Spark of Radiance (item 232875, ExpansionID 11 — The War Within; Midnight's is Spark of Tides 274476), a weekly the reset routine still sent everyone to after it stopped being offered, and hand-maintained raid boss names, now read from the journal.
- Season 2 delve questline surfaced, which the addon knew about and had never said. Rare arrival hints moved off the arrow label into chat. Balance Druid split by hero talent; Shadow Priest deliberately not split. Stat priorities refreshed for 12.1.

## 3.2.0

- **Corrected, and it was our own claim from 3.1.0**: `DELVE_REWARDS_CAP_AT_8` said tiers 9-11 give exactly what tier 8 gives. True of the gear, false of the crests. Measured on Rob's client with `/mh crest`: a Tier 8 Bountiful run paid **Champion Mistcrest +11**, a Tier 11 run paid **Hero Mistcrest +10**, neither with a Gilded Stash. The in-game currency tooltips agree independently (Champion lists "Delves (Tiers 7 to 10)", Hero lists "Delves (Tier 11)"). The original error was a measurement of the entrance window — which describes gear — quietly widening into a statement about "the rewards".
- New: `/mh crest` — snapshots every currency and diffs them after a run, filed under the tier you name. Deliberately without a name filter: a filter can only ever find the crests you already believe in, and goes blind the moment a patch renames one.
- **Fixed: the consumables check reported "no health potion" to players holding a better one.** Season 2 shipped Concentrated Silvermoon Health Potion (271883/271884) and its recipe *consumes 25* of the old Silvermoon Health Potion, so everyone who upgraded failed the bag check at every dungeon door and silently lost their potion keybind. Both ids of each adjacent pair now count, on both sides — every Midnight flask and potion appears to exist under two neighbouring ids sharing one name, and we had only ever stored one.
- Fixed: `Locales/StartHere.lua` told new players in seven languages that delves come "with **Brann** at your side". Midnight's companion is Valeera, and `CurioExplain.lua` has said so for months. It sat in the first paragraph a new player reads.
- New: the Coiled Isle portal is findable from both ends. A pin in the City Guide's Travel category for the way in, on the measured coordinate (2393, 56.74/67.30, captured standing at Astalor with his npc id 246231) rather than the 55.00/63.40 the Codex published — nearly four points out, which in a city is a different street. A clickable waypoint in the Prey article for the way back (2512, 58.12/48.48). The addon already knew both portals and offered them ahead of flying; it just never showed anyone where to walk.
- **Settled**: the portal is gated on the **quest**, not on renown. An alt at Preyhunter's Journey **renown 0** with the chain completed can use it. The plan recorded in `Delves.lua` was to convert the row to `requiresRenown = { faction = 2808, level = 1 }` on the strength of a guide sentence; that would have hidden the portal from exactly the players it serves. Which quest is the gate is now labelled as still open rather than assumed.
- **Settled**: quest **96466** exists — the client named it "Prey: Anguish Island" three times. Open for three days because two guides had it and our server check denied it. Also found: **92926** "Prey: Astalor's Initiative", in no guide we read.
- New: a button on the Enchants tab that opens the socket window for the slot with the empty socket, and only when there is one. Cisca did not know how to get a gem in, and "socket 1x Eversong Diamond" is a verb you have to already know. `/mh socket` measured first — it reports whether `ItemSocketingFrame` is actually on screen afterwards, because a pcall that does not error proves nothing about a protected call.
- New: rares with a quirk say it in chat when you come within 80 yards — Coin-Eye Skully swims, Farthik appears only after you open the chest. Built twice wrong first: on our arrow's label, which stands down whenever TomTom's arrow is up, and then behind `_mhRouteOwner`, a runtime flag a `/reload` clears. It is a fact about a place, not about a route you started. `/mh rarehint` reports why it is or is not speaking.
- Fixed: the consumables board opened itself in raids, where its five rows can only show five of forty — an arbitrary slice that need not include you, presented as a group overview. Manual opening still works.
- Fixed: from inside a delve the route arrow announced "(other continent — travel back)". A delve's map has no continent relationship to anything outdoors, so an unreachable target there means "you are indoors", not "you are far away". It now says to leave first, and the flight hint stays for the part after.
- Fixed: `BuildTravelPlan` called `GetNearestFlightPoint` without a position, which returns the first stop the faction may use — list order, not distance. Chat and arrow gave two different answers for the same delve. Every plan falling back to flight was naming an arbitrary stop.
- Fixed: the flight-leg decision was made once, when the route was set. Rob set his inside a delve, where there is no flight point to find, so it correctly declined and never reconsidered. It now asks again on leaving an instance.
- New: `/mh portals` — which portals this character may use and why, because withholding one on an unreadable quest flag looks identical to a bug from outside. Uses the game's ready-check textures; Unicode ticks render as empty boxes in the WoW font, which this addon already knew and I forgot.
- New: The Ring of Glory warns that the higher tiers send **three** loose golems, pullable one at a time — two together is two uninterruptible slams. Gnok rising again is now measured rather than borrowed from Method and Icy Veins; Drakta keeps the hedge. Seven languages, including the danger text that had never been translated at all.
- New: the About window credits EXBoss and EXBossData, HandyNotes_Midnight, GTFO and RareScanner, and states plainly that ids and numbers are confirmed against the client before shipping and that no code is used. EXBoss asked publicly to be credited and was the one source we had leaned on without naming.
- Fixed: `Openables.lua` now rescans on `SKILL_LINES_CHANGED` and `TRADE_SKILL_LIST_UPDATE` — a tailoring study book stayed hidden until a reload.

## 3.1.0

- New: a Delve Coach entry for **Venomfall Deeps**, the only delve that had none. Built from Rob's own death rather than from a guide: `1288126` Wrath of Ula'tek killed him from 100% health, his death recap named it Nature damage and marked it Avoidable, and instance **3079** wrote itself into `ns.db.hazardZones` as "Venomfall Deeps" — closing a candidate open since 17 aug on nothing but an ability-name match. The fixed rotation (Noxious Bile, Void Toxin, Soul Extinction, Venom Storm) and the intermission rules come from a community guide and the text says so where a player reads it.
- New: `DELVE_LOOT_TABLE_S2` filled — eleven tiers of end-chest and Trovehunter's Bounty item levels with their upgrade tracks, every one read off the delve entrance window. `C_DelvesUI.GetDelveEntranceTiers()` returns a per-tier `context`, and tiers 8-11 share it; hovering tier 8 confirmed the inference by reading 295/305 exactly as tier 11 had. The tooltip now says outright that tiers 9-11 add nothing.
- New: `ns.LearnVaultIlvlByTier` — the Great Vault column nobody could measure now learns itself from `GetVaultProgress`, which was already reading an example reward's item level and never using it. Stored as a maximum seen, because the vault takes the lowest of your best two activities, and shown with a star.
- Fixed (shipped in 3.0.0): **362** doubled backslashes before `\n` and **116** before `\"` across deDE, esES, frFR and ptBR — raw escape characters on screen, almost all of them in the Role Academy. enUS, nlNL and itIT were correct, which made it one generation run rather than a convention. The first repair attempt assumed two backslashes where there are three and broke all four packs; they were reverted and fixed from the bytes.
- Fixed: esES shipped `ALT_UPDATED_MINUTES` as `__TKHace 0__m` — an unfinished translation marker with the `%d` replaced by a literal zero. Found by lint check `[13]` on its first run.
- New: lint check `[13]` — format specifiers, colour markup and escape sequences in every translated string, checked against enUS. Three distinct classes of breakage found in the two hours after it existed, none of them about language.
- New: deDE gained the entire DPS Academy track, five missing heal chapters and 49 dungeon boss tips (80.2% → 83.0%). Also corrected `Verspottungsschlüssel` — a Schlüssel opens a door; a keyboard key is a Taste.
- Fixed: the i18n audit dropped deliberately-English keys from the numerator but not the denominator, so every pack read better than it was. nlNL is at 100% of translatable keys and was already.
- New: sixteen hazard ids from GTFO 6.8, and `/mh hazards check` — every id in the file put to the client with a positive control that must resolve and an impossible id that must not. All 189 came back named.
- Fixed: `HealerInGroup` called `UnitGroupRolesAssigned` bare and compared the result inside an `if`. 12.1 can return a secret there, and comparing a secret in a conditional throws. Flagged by the API watcher, guarded like its sister module.
- New: `/mh quest` and `/mh npc <id>` — read a quest id from the open window, and ask the client what an npc id is called. Both exist because a guide's id that nobody can check is what quest 96466 has been for three days.
- New: `/mh here` now records the target's npc id, and still inspects the target inside delves that refuse to give a position. `ns.POSITION_BLOCKED` carries 3079: Blizzard blocks coordinates in Venomfall Deeps, measured on the spot, and a silent route arrow there is not a broken one.
- Fixed: the Codex category labelled "Void & Rituals" is now "World content" (`CODEX_CAT_WORLD`, all seven packs, plus a Dutch label). Half of what it holds is neither void nor ritual — Prey hunts, rares, Showdowns and Turbulent Timeways sit there too. Rob went looking for the Prey article, read the button row and walked past it; the same class of fault as the twelve type-only commands on 18 aug and the unsearchable Coiled Isle treasures.
- New: the Coiled Isle portal is explained in the Codex Prey article, with a waypoint to Astalor. Zygor's walked route shows the portal used as an objective of the quest handed out the moment 96004 is turned in, which supports our gate over their travel graph's later one.
- Measured: `C_DelvesUI.GetCurrentDelvesSeasonNumber()` exists and returned 2 with our own season gate independently agreeing — the third correction to that gate, and the first time it was checked against the client. Added as a refusal only, never a grant, for the same reason the M+ season id is.
- Measured: HandyNotes_Midnight 154 against our Coiled Isle data — 22 treasures, 11 glyphs and 10 lore nodes match to the decimal; nine of eleven rares agree within 0.13. Coin-Eye Skully sits 4.4 away and is flagged rather than changed, since their file still ships a memorial coordinate Rob proved wrong in July.

## 3.0.0

- New: `Modules/TravelPlan.lua` / `/mh plan` — the whole way to a target as clickable steps, and `Modules/NativeArrow.lua` now walks it: it steers to the first step on the player's own map, rebuilds the plan on every update so progress needs no tracking, and reports "you are standing on this step" instead of drawing an arrow at someone's feet. All three Amani Windcaller landing spots measured in game (`ns.AMANI_HUBS`), so `ChooseHub` is arithmetic; the hop is skipped when the door is nearer than the NPC.
- Fixed: `BuildTravelPlan` wrote the chosen Windcaller back into its own module-level `LINKS` table, so the first plan any character built stamped that NPC into the data permanently and every later plan on every character inherited it. Found because Rob was standing at the eastern Windcaller and the plan named it for a northern door.
- Fixed: `MapContinent` returning nil was read as "a different continent", and `MHSameZoneOrSub` cut a two-leg journey short at both the start and the end of a leg — the second one let a leg declare itself arrived 1.5 seconds in.
- New: the Coiled Isle's Mysterious Mix Master — ten offerings with three ingredients each in `ns.MIX_MASTER_RECIPES`, verified machine-side (every row sums to three, every column totals ten). One shared Route button in the card header replaced ten identical ones pointing at the same cauldron.
- Fixed: every Coiled Isle treasure was invisible to the search box. `NavSearch` indexed `node.name`, and those hunts deliberately have none; it now reads `ns.AchievementNodeName`, which is the client's own localized name. Seventh instance of that same fault.
- Fixed: the command list itself was unsearchable, and was missing nine features that had shipped months earlier. The five measurement probes moved into a labelled group rather than being deleted.
- New: a red `danger` section in the Delve Coach, used once — The Ring of Glory, where the golem's slam cannot be interrupted and lands underneath you.
- Measured, and it killed a feature: 12.1 gives an addon nothing readable about an enemy cast. The spell id from `UNIT_SPELLCAST_START` was secret 13 times out of 13; sampling all twelve returns of `UnitCastingInfo` over six casts gave name, text, icon, castID, `notInterruptible`, spellID **and both timestamps** as secret, leaving only `castBarID` (a counter) and `isTradeSkill`. With the start and end times secret, even a cast's duration is not a fingerprint. A delve target's GUID has been secret since 16 aug. So `Modules/BracePrompt.lua`, built and measured the same day, was removed rather than shipped as a prompt that could not name what it warned about — the knowledge went into the Delve Coach instead.
- Fixed: `/mh here` threw on a secret string because `type(x) == "string"` is true for one. Root cause was six file-local copies of `IsSecretValue`, none exported; `ns.IsSecretValue` and `ns.CanAccessText` now live in `Core.lua`.
- Fixed: a slash command whose router whitelisted two literal spellings while the handler had learned four arguments, so half of them answered "Unknown command".
- New: two `/mh shots` scenes (Achievements on an expanded card, the Delve Coach on The Ring of Glory). A scene may now omit `tab` and may name a different window as its subject. `/mh keys` and `/mh plan` were on the list and are not shootable: both print to chat, and the rig hides UIParent.

## 2.18.0

- New: `Modules/HazardData.lua` + `Modules/Hazards.lua` — 173 avoidable-damage spell ids across 20 instances, harvested from GTFO 6.7.2 per entry rather than per section header. Every id was put to the client twice with two controls holding (an impossible id stayed empty, our own six DBM ids all resolved) and all 173 came back named. Shown in the Delve Coach and via `/mh hazards`.
- New: hazards are keyed on the instance id the client itself reports, so no zone name is ever typed. Asked what instance 1592 is called, `C_Map` answered "Ny'alotha" — a Battle for Azeroth raid — because GTFO's field is not a uiMapID. Sixteen of seventeen returned nothing and the one that answered was the wrong one, which is the whole argument for `ns.db.hazardZones` learning names on entry. Gnarldor Isle (3038) named itself on Rob's first run.
- Fixed: `IsSeasonLive()` used one timestamp for every region, so Season 2 would have opened about a day early across Europe. It now asks `GetSecondsUntilWeeklyReset` — already regional, already right — and requires a reset on or after the season date. Third correction to this gate: six days early in June, five in August, one day in the EU now.
- Fixed: the same wrong day was written into `RAID_BOSS_NYMRISSA_STEPS` in five languages. Fixing the gate and leaving the sentence would have been worse, since players read the sentence.
- New: `ns.ACHIEVEMENT_HUNTS` gains Soft Underbelly (62601) and Oppose the Foes (63601). Left out on 15 Aug because HandyNotes gave several nodes 10.00/10.00; that was not broken data but a way of saying "no fixed spot" — three of Soft Underbelly's five only exist during the Underbelly Temple Strike, and Ancient Foes spawn where the incursion ends. Every criteria id read from the client and confirmed twice (HandyNotes pairs the same criterion with the same NPC id; Method's eight names match).
- New: `ns.AchievementNodeRoutable` — added before the first coordinate-less node existed, because `NodeWorldPos` reads `(node.x or 0)` and would have pointed the arrow at 0,0 with full confidence.
- New: `/mh keys` and `Modules/CorrosiveCodexHunts.lua` — the four Altar of Corrosion choice nodes behind a treasure hunt, with the item→node pairing, item ids and quest names Method supplies, all attributed. Two sources agreeing (Feather of Tok'jara at 2509 48.46/25.80, now four independent reads) is marked differently from one source claiming.
- Fixed: three multi-return calls guarded as `f and f()`, which yields a single value. The dispel icon had therefore never appeared, the flight banner had never named its destination, and the world-boss fallback ran on every call. Lint check `[12]` now fails the build on the pattern.
- Fixed: `/mh ach id` read `GetAchievementCriteriaInfo` only as far as totalQuantity, so it printed criteria names and never criteria ids — the one number needed to add a hunt. It now captures `criteriaID` (10th return) and `assetID` (8th) separately and writes to `ns.db.achDump`.
- Measured: quest 96466 from Method's portal guide does not exist. Settled not by waiting for the season but by a rival id for the same content — Method's own Prey guide names the follow-up 96528, which resolves ("Prey: Anguish from Beyond"), so "not live yet" cannot explain 96466's silence. The portal gate itself was always on 96004 and never moved.
- Also: `/mh mech` (client-side name check with two controls), `/mh keys` in seven languages, and the Corrosive Codex / Altar of Corrosion split recorded — two systems with two currencies that this addon had been treating as one.

## 2.17.0

- New: `Modules/CurioExplain.lua` — `/mh curios` prints what each Valeera delve curio does, with nothing hardcoded. Ids are resolved through the trait tree (`C_Traits.GetConfigIDByTreeID` → `GetTreeNodes` → `GetEntryInfo` → `GetDefinitionInfo`) and the text comes from `GetSpellDescription` on the player's own ranks. No ranking is offered: which curio wins depends on spec and delve, and nobody measured that.
- Fixed the same async bug twice in one day and wrote down why: `GetSpellDescription` reads a cache, so the first pass printed "(no description)" for eight options. `C_Spell.RequestLoadSpellData` plus a one-second deferred read turns silence into an answer. I had copied that call from my own morning fix without the reason for it.
- New: seven Coiled Isle treasures carry `prereqs` in `ns.ACHIEVEMENT_HUNTS` — the step that unlocks them, with its own coordinates on a clickable button rather than in the sentence. A locked chest with no explanation reads as a wrong coordinate.
- New: `Modules/FlightMapHint.lua` now glows the pin as well as naming it, found through `FlightMapFrame.dataProviders` → the provider owning `AddFlightNode` → `slotIndexToPin`, matching on `taxiNodeData.name`. Matching is by prefix: a node name carries its zone ("Anathos, Silvermoon City"), which is why equality found nothing. Two guesses preceded this — a template name and a lookup route — while a working reference sat on disk.
- New: `/mh mount <text>` asks `C_MountJournal` the way `/mh ach` asks the achievement API, plus Auriferous Venomfang with every id measured on Rob's client.
- New: the Coiled Isle portal pair in `MIDNIGHT_PORTALS`, gated on quest 96004 (title verified against the client, character for character). `PortalUsable` returns false when the flag is unreadable — deliberately the opposite default to the delve chests, because hiding a portal costs a walk and inventing one costs trust in the arrow.
- Measured: quest 96466 from the same guide paragraph does not resolve on this client. Recorded as undecided, not refuted — Method may have tested on the PTR, and a Season 2 quest that has not activated looks identical from here. Re-measure after the reset.
- Fixed: `ns.AchievementNodeName` existed but was called in two of six places, so 22 criteria showed `?` and Route crashed on a nameless node. A helper that is not used everywhere is worse than no helper — it makes the bug look fixed.
- Fixed: the share row's buttons ran past the frame edge. The row never asked how wide it was, and the fix I nearly made — dropping a button — would have been wrong: the Dutch labels are roughly three times the English width, which is why only Carola saw it.
- Fixed: a delve boss GUID is a secret value in 12.x. `type(guid) == "string"` is true for one, so checking `issecretvalue` and then indexing anyway still threw. The flag has to gate the read.
- Also: the delve boss prompt hides after five seconds, and the copy dialog has a size.

## 2.16.0

- New: a chest route inside delves — `ns.DELVE_CHESTS`, 36 Sturdy Chests across 13 maps, extracted from HandyNotes_Midnight and cross-checked against the six coordinates we already shipped in our own tip text (exact to the decimal). A Chests button in the delve coach points the arrow at the nearest one still open and re-points on the quest flag, not on distance. Measured first: `/mh zone` inside Gnarldor Isle reports the user waypoint as refused while world coordinates resolve, which is why our own arrow works there and Blizzard's pin cannot.
- New: `ns.IsDelveChestDone` is three-state. An unreadable quest flag returns nil, never false, so a wrong id costs a chest walked to twice rather than a chest silently hidden — the quest ids come from one addon whose Coiled Isle band was wrong on 13 Aug.
- New: chests are learned from `LOOT_OPENED` on maps we ship nothing for, filtered to GameObject GUIDs so a looted corpse is not recorded as a chest, keeping the objectID. Learned lists announce themselves and never overrule the shipped table.
- New: two-leg travel. `ns.RouteFirstToFlightPoint` sends the arrow to a walkable flight master first and hands over to the destination the moment `UnitOnTaxi` is true — boarding ends leg one, not landing. Narrow by design: different map, a faction-usable flight point where you stand, and not the same stop.
- New: `Modules/FlightMapHint.lua` names the stop to take on `FlightMapFrame` itself, checked against `C_TaxiMap` rather than trusting our own table, with separate lines for undiscovered and unreachable. It only draws; no node is ever selected.
- New: flight points 23 → 649 across 154 maps, joined from Zygor's LibTaxi through LibRover's own name→uiMapID table rather than by matching zone names. One block that did not resolve is reported and dropped. Faction is now stored and filtered; unknown faction still counts as usable.
- New: `/mh binds` exports the player's real bindings — a third source beside the schema and the auto-map, read from the client and never written. Multi-key commands print every key, a key on an empty slot is shown and counted, macros are named via `GetActionText` when `GetMacroInfo` fails, and the Assisted Combat slot is named for what it is (two runs a minute apart reported Frozen Orb and then Flurry).
- New: `Modules/BriefNotice.lua` — a five-second on-screen notice that fades itself and takes no mouse input, for feedback that answers "did my click work".
- Fixed: the Layout tab laid its cards out across `HOST_W` (the keyboard's width) while the host is a scroll child of a narrower panel, so the third column's right-aligned keycaps fell off the edge. `UIPanelScrollFrameTemplate` scrolls vertically only, so nothing could bring them back — and a missing key reads as "unbound", not as broken.
- Fixed: the delve boss prompt hides itself after five seconds instead of sitting over the fight it asks about.
- Also: `/mh ach check` holds every achievement hunt against the client and separates a wrong criterion id from an incomplete node list; it found Showdown Slugger: Naigtal shipping 8 nodes for 10 criteria, closed via `assetID` after the client returned "Slaipaan" for three different criteria.
- Also: the Coiled Isle gains its glyph (63395) and lore (63662) hunts. 62601 and 63601 were deliberately left out — their HandyNotes coordinates are 10.00/10.00 placeholders, and an arrow that points somewhere gets believed.
- Tools: `tools/delve_chests.py`, `tools/flight_points.py` and `tools/keybind_mine.py` all diff against what we ship before printing, and none of them writes to the addon.

## 2.15.0

- New: the two 12.1 delves, for real. Gnarldor Isle and The Ring of Glory in the Delves panel, coach and picker — enumerated from the player's own client via `C_AreaPoiInfo.GetDelvesForMap` after two POI sweeps proved `GetAreaPOIForMap` never returns delves at all (our own eleven were the positive control). Routes with the three Sturdy Chests as clickable waypoints, bosses as multi-source candidates (Drakta confirmed by an actual run), showcase models that fail soft on a wrong id.
- New: Venomous Abyss raid coach filled in — beginner steps for all eight bosses built from DBM's hand-written encounter modules plus the journal, with `{SPELL:id}` links so the client renders names in the player's language and a wrong id shows as a broken link. Where sources disagree the text says so (Blink Nova: run vs stack). A pre-release note sits above the raid until the tips are verified live.
- New: a strip of 3D boss models on the raid page — display ids shipped as client-DB2 candidates and verified the same evening against the player's own `/mh ej save` capture, eight for eight.
- New: Coiled Isle category in the Codex; the Vaults article split into three at its bullet boundaries without rewriting a word, in all seven languages. Every coordinate is a clickable `{WAY:}` link (105 on map 2509, and Szarith on his own map 2613), and the Honored Dead article carries a Follow the route button into the existing Achievements hunt.
- New: the Codex body renders hyperlinks — converted from FontString to the read-only EditBox the other panels use, with the stale-first-measure defence carried over.
- New: coordinate clicks route through `AddSmartTomTomWay` — TomTom when present, else Blizzard pin + SuperTrack, plus the Travel Assistant's portal/hearth advice.
- New: crest bundles that cannot open say why before the click — tooltip shows the season total and explains that spending does not lower it (the cap counts earned; it rises at reset). Fully blocked bundles leave the Openables button; blocked ones sort below usable ones. Cap check asks the game's own `PlayerHasMaxQuantity` OR our earned-vs-max arithmetic — measured to disagree, both run.
- New: Openables reads `hasLoot` from the client as a second net behind the tooltip patterns (the approach every bag addon on disk uses; none ships a list).
- Fixed: the delve coach picker was hardcoded for eleven delves and The Ring of Glory overflowed the frame; height follows the list now.
- Fixed: the Codex intro called itself a "Season 1 handbook" in seven languages, three of which translate the word — one anchor found half of them, the sweep found the rest.
- Fixed: unrecognised delve runs were silently dropped by DelveHistory at the exact moment the client named them; the name is kept in SavedVariables now.
- Corrected: the entrance note that claimed Zygor was ~4 units off — Zygor's coordinate was on map 2509 (inside the Vaults), never a claim about the island. The three real entrances (measured via `GetMapLinksForMap`) stand.

## 2.14.0

- New: `/mh setup`. Laying out your bars was a set of commands run from memory, in the right order, on the right character. Rob cleaned his Hunter while that Hunter was still on account-wide bindings - he had switched his Druid - and his Mage lost eight keys, with nothing on screen naming the set he was on. The panel shows character, class, layout size and binding set first, and every destructive action arms on the first press and acts on the second.
- New: the setup nudge. Opening Midnight Helper on a character whose bars have never been set up shows a card offering to do it, with the wizard one click away. It answers a question Rob asked directly: if he tells a beginner the addon can lay out her spells, where does she go? The condition is measured against our own per-character record of slots we placed, not inferred from bound keys - Blizzard binds 1 through = on a brand-new character, so the first version would have stayed silent for exactly the person it was built for.
- New: the recommended bar layout as an applicable Edit Mode string, with `/mh editmode restore` and a button beside it to undo. Bars 1-8 only, so pet, stance and macro bars are never moved. Refuses when a competing bar addon is loaded, and names the patch a string was exported on - 12.1 verified byte-identical to the 12.0.7 export, so no second copy was needed.
- New: thumb-pad keys 6 7 8 9 0 - onto action bar 8 from the setup panel. The button keeps each key on the button it already occupied rather than repacking the bar; three earlier versions renumbered them and each looked tidier while moving something the player's hands already knew.
- New: a Quick Keybind Mode button, so Blizzard's own hover-and-press binding is next to ours instead of three menus away.
- New: `/mh bar`, a small quick bar, off by default - Midnight Helper, reload, setup, and leaving a party, instance or delve. Leaving a delve needed `C_PartyInfo.DelveTeleportOut`: solo in a delve is a scenario with a group of zero, so there was never a party to leave.
- New: healing potion and healthstone as bindable actions through `CLICK` in Bindings.xml, so they cost a keybind instead of an action bar slot. Nothing bound by default.
- New: `/mh fps`, read-only, using Blizzard's own global strings as labels so they are translated in every language. It distinguishes a setting deliberately raised for raids from one still on its default, because the two look identical and only one is worth mentioning.
- New: a Details! damage meter page on the Platynator pattern - it copies a profile string for you to paste and never imports anything itself.
- New: shift+scroll resizes every Midnight Helper dialog, remembered per window.
- Fixed for 12.1: `C_TaskQuest.GetQuestsForPlayerByMapID` was removed. The call sat behind a `pcall` on a nil field, so it failed silently and the world boss page fell back to a stale cache rather than erroring.
- Fixed: task POI coordinates are expressed in whichever map you queried, not in `poi.mapID`. Pairing the two put waypoints nowhere, invisible until the Coiled Isle became the first zone where the ids differ. A POI belonging to another map is also clamped to the border, so each map is now asked for the bosses that live on it before any border pin is accepted.
- Fixed for 12.1: in combat the client hides some of your own buffs and `GetPlayerAuraBySpellID` answers with nothing rather than refusing - three of five, measured on live. `Aura.HasPlayerAura` returns nil instead of false unless the read can be trusted, so a hidden buff can no longer become a confident "you do not have it".
- Fixed: the Season 2 gate opened on patch day. Its self-learning fallback read "any M+ season newer than Season 1", and that number increments with the patch, not the season - the Currencies page showed five zeroes for Mistcrest while hiding the Dawncrests the player was carrying. It now requires the season start date as well.
- Fixed: the search box never indexed the Addons pages, so searching for the tools they cover returned nothing on pages we built ourselves. Commands are indexed by what they do rather than only by name, and read from the single command list instead of a second private copy.
- Fixed: `/mh apply clean` removed a second binding on a filled slot. A second key on a slot that holds something is a choice, not cruft.
- Fixed: a button's answer went only to chat. The setup panel now shows the result of the last action, including the Edit Mode preset refusals, which previously left the panel looking like a button that did nothing.
- Fixed: the About window credited the wrong authors, in all seven languages.

## 2.13.0

- New: every command the addon has, listed inside it. The Tools page shows all forty in groups with a line each. Most of this addon was reachable only by typing something you already had to know; the linter now fails the build when a listed command is not routed, so the page cannot drift from the code.
- Announced at last: the action prompt (`/mh prompt`). A large icon when your interrupt applies to what your target is casting, and when your target carries something you can strip. It shipped unannounced in 2.12.0 under the rule that nothing gets announced until somebody has watched it work; Rob has now seen both halves fire.
- New: `/mh prompt sound` - spoken, chime or off, for the purge half. Interrupts stay silent by necessity, not choice: `notInterruptible` is a secret value, the icon works only because SetAlphaFromBoolean lets the engine read it, and there is no PlaySoundFromBoolean.
- Fixed: the prompt only re-resolved your interrupt and purge on a spec change, but every purge here is a talent and so are most interrupts - a loadout swap inside one spec left it offering a spell you had just talented away until the next reload. It now also listens to `TRAIT_CONFIG_UPDATED`.
- Fixed: the purge prompt printed "PURGE" over every class's icon. That is the shaman's name for it and our own shorthand for the category - a mage saw it, went looking for a button called Purge, and has Spellsteal. It resolves the real spell name from the id it already had. The ownership check also failed OPEN when `IsPlayerSpell` was missing or errored, claiming the spell for the whole class on the strength of not knowing; it fails closed now.
- Fixed: the purge prompt appeared on friendly players, who always carry dispellable auras, so pressing it answered "Invalid target". It now requires an enemy (`UnitIsEnemy`, not `UnitCanAttack` - a neutral quest giver is attackable too).
- Fixed: only Priest and Mage had an offensive purge listed, so nine classes could never see that half at all. Shaman (Purge 370) and Hunter (Tranquilizing Shot 19801) added, each confirmed by two independent installed addons. Druid Soothe, Warlock Devour Magic and DH Consume Magic stay out, each for a stated reason.
- Fixed: four places split a unit GUID behind a bare `type()` check, which cannot tell a secret string from an ordinary one - two of them shipped, in `RaidCoachData` and `SporefallCoach` on `UnitGUID("boss1")`. Against a boss whose GUID the client hides, that throws mid-fight.
- New: `/mh goto 47.0 62.2 [name]` points the arrow at any spot in your current zone, naming it from our own data when something of ours stands there.
- Fixed: the zone rail in the Rares tab built its buttons once from a snapshot, so a zone registered later listed its rares above a rail with no button for it. It now fills its own gaps on every refresh.
- Removed: `/mh kicks who`. It answered "ON" and could never do anything - Midnight refuses combat log registration to every addon, DBM included (`DBM-Core.lua:1680`). The interrupt card also still advertised it after the command was taken out.
- Ready for 12.1: the Coiled Isle with nine rares - names, npcIDs, coordinates and seven kill-quest ids all measured on the PTR - and Altar of Fangs with beginner steps for all three bosses, written from the mechanics in DBM's own mods. Both behind the patch gate, so nothing appears before the content exists.

## 2.12.0

- New: Party targets, a panel showing every group member and what they are attacking, with their role, class colour and the raid marker on their target. Clicking a line takes that target, in combat too. Draggable, and resizable by width. Off by default - `/mh partytargets` or the Settings page. An enemy target's name is a secret value in 12.x, so the panel shows names it is not allowed to read: no sorting by target, no "three of us are on yours", no highlighting the row that matches you.
- Fixed: the route arrow never appeared for anyone who also had WaypointUI installed. Deliberate once, on the grounds of one guide per screen, but it silently cancelled an advertised feature - and a pin on the ground and an arrow with a distance are not the same answer. The arrow now draws alongside it; `/mh arrow yield` restores the old behaviour.
- Fixed: the route arrow was nearly invisible against dark ground. Its halo was black, which only ever helped on bright backgrounds. A pale glow now sits outside the dark edge, so it reads on both.
- New: `/mh arrow` reports who is guiding you, whether a route ever published a target, and which addon is standing in the way. Standing down on purpose and being broken looked identical from outside.
- New: Stay alive, at the top of the Role Academy's DPS track - your own buttons in the order a fight needs them. Assembled from the keybind role data, so it covers every class, and resolved against your live spellbook, so a spell replaced by a talent shows the name on your bars rather than the one in our table.
- Present but unannounced, because none of the three has been seen working: `/mh prompt` (your interrupt and your purge shown when they apply), the dispel indicator beside a party member, and `/mh kicks who` (naming whoever landed an interrupt). All three are off or silent by default and fail without a sound. They will be announced in the release where somebody has watched them do their job.
- Fixed: the welcome popup promised Alt+M opens the addon. That binding is only applied while the key is free, so for some players the first sentence the addon spoke was untrue. It now points at `/mh` and offers the keybind as something you set.
- Fixed: two Dutch labels said something other than what they meant - the missing-buff marker read "MIST", which is the Dutch word for fog.

## 2.11.1

- Fixed: the crest pages claimed a weekly cap of roughly 100 per colour. There is no such cap - the game reports no weekly limit on any tier, measured 22 July - and the claim had already been removed from the English and Dutch guide text that day. It was still present in the Codex in all seven languages and in the crest guide in deDE, frFR, esES, ptBR and itIT. Removed everywhere.

## 2.11.0

- New: the Season 1 closing checklist tracks what actually expires and ticks itself off - Delver's Journey, the five "of the Dawn" achievements, the three Nullaeus nemesis achievements (61797/61798/61799) and the Prey capstone Preying For Midnight (62351). All four nemesis entries turned out to be hidden Feats of Strength, invisible to a normal achievement walk.
- New: Codex article "When a season ends" under Start Here - gear, currencies and progress tracks at a rollover, written free of item levels and dates so it survives the next flip. It also separates a season change from a stat squish, which belongs to an expansion pre-patch.
- New: measurement tools - /mh ej (boss roster from the Encounter Journal), /mh ach (find an achievement id, including hidden ones, and read its criteria), /mh delvescan, /mh poisons, /mh valeera save, /mh trail.
- New: Valeera's Poisons slot is shown with each poison's own description read from the client. No recommendation yet, because the effect data available to us was tied to spell ids the client does not have.
- Changed: the big 3D boss model in the boss window defaults to off; an explicit opt-in is preserved.
- Changed: Codex articles can carry search keywords, so an article is findable by topic and not only by the words in its title.
- Changed: long diagnostics write to SavedVariables instead of flooding chat.
- Fixed: patch 12.1 no longer errors during delve fights - the combat warning's glow border used a Backdrop whose geometry is a secret value on 12.1. Confirmed on the test realm.
- Fixed: Season 2 data corrected against the client - 14 missing journal encounterIDs filled in, and The Venomous Abyss was listed in DBM numbering rather than fight order.
- Fixed: the death recap remembers a refusal per client build instead of reporting it every session; an accessibility alert could be covered by a toast; the Delver's Journey claimed a finished track was unfinished; a milestone card vanished before it could be read.

## 2.10.0

- New: profession advice on This Week and beside the Blizzard profession window - names the tree to fill, then the exact node once the recommended trees are done, with every open choice listed and what it does (read live from the game, all eleven professions, localized). Build order verified against current guides per profession; corrected Blacksmithing, Leatherworking, Engineering (had no recipe tree) and Inscription.
- New: /mh kp (what weekly Knowledge is readable), /mh nodes (dumps the spec-tree nodes to SavedVariables), /mh crests (crest sources straight from the game).
- New: the Professions course opens each chapter with a plain-language intro and tells you where to click to spend points (Specializations tab); "academy" now finds the course in search.
- New: personal milestones, a Codex tip of the day on This Week, and season counters (groundwork for a look-back).
- New: findability - search results scroll, side panels and the profession course are searchable, and clickable rows in side panels highlight on hover.
- Fixed: the route arrow returns to the route you interrupted after a rare detour - on kill, on someone else's kill, or when the rare is already gone on arrival; it stays on a rare that is still alive.
- Fixed: Veteran crest count was a hundred too high (took the wrong currency id); the weekly essence line no longer poses as progress it cannot read; a non-existent weekly cap claim was removed; three dead "Advice goal" buttons were removed; Jennara Sunglow's location was wrong in seven languages.

## 2.9.0

- New: side panels beside Blizzard's own windows - character sheet (enchants, sockets, tier set, upgrade ceiling), Mythic+ (Great Vault dungeon row), Adventure Guide (tips for the selected boss) and mount collection (wishlist). Draggable, position remembered, /mh panelreset restores them.
- New: /mh tracks - which slots are at their upgrade-track ceiling, and the two routes onward (Great Vault, crafting), including that top crests are earnable solo via high Bountiful Delves and Tier 6 Ritual Sites.
- New Codex entry 'Getting gear crafted' - sparks, crests, missives, placing an order, and the trap that the crafter cannot supply your sparks or crests.
- New: DPS tips for all 43 bosses that have tips (previously tank and healer only).
- Fixed: weekly list now recognises all of Lady Liadrin's twelve pool quests (knew four); Showdown weekly from Riftblade Maella added; single "take me there" arrows clear on arrival.
- Fixed: Mythic+ vault breakdown called runs 'keys' and could print 'Slot 1: 5/1 done'; the dungeon row counts heroic and timewalking runs too.

## 2.8.4

- Fixed: Omnium Folio button opened a Covenant Sanctum when the minimap button was stuck on an old expansion (SetBestLandingPageMode repair on press); and it identified the rune page by its English name, breaking every non-English client.
- Fixed: profession panel showed wrong currency balances and compared them against recipe costs - all fourteen unverified Artisan's Moxie / Unalloyed Abundance ids removed.
- Fixed: crash when opening the profession panel; ADDON_ACTION_FORBIDDEN burst from the death recap in dungeons.
- New: dispel reference for tank and DPS specs; Role Academy DPS content (was absent, and hid a crash); copy button for ritual routes.
- Ritual Sites read as tiers 1-6; Season 2 gates on the season opening, not the patch; M+ interrupt notes name dungeons with no data; consumable board reports what it cannot see.
- Translations: heal-lens, dispel reference, consumable board and Mythic+ commands now in de/fr/es/pt/it.

## 2.8.3

- Fixed: Omnium Folio button could open a Covenant Sanctum instead of the rune window (it read the landing-page frame, which reports Midnight even when the minimap button is on another expansion; now asks the button itself).
- Fixed: Ritual Sites text said tiers 1-5; Tier 6 has been live for a while.
- Translations: heal-lens, dispel toolkit, consumable ready board and Mythic+ commands now in de/fr/es/pt/it instead of falling back to English.

## 2.8.2

- Fixed: profession panel showed wrong currency balances — every unverified Artisan's Moxie / Unalloyed Abundance id removed (three resolved to other professions' currencies, one to a hidden delve tracker).
- Fixed: crash when opening the profession panel; burst of ADDON_ACTION_FORBIDDEN errors from the death recap in dungeons.
- Fixed: Omnium Folio "Open rune window" recognised the page by its English name, breaking every non-English client; no longer reports success when no window opened.
- New: dispel reference for tank and DPS specs; Role Academy DPS content (was absent, and hid a crash).
- New: healer boss tips in Magisters' Terrace and The Blinding Vale, distinguishing cleanse / purge-the-boss / heal-to-full.
- New: copy button for sharing ritual routes.
- Season 2 content gates on the season opening, not the patch landing; M+ interrupt notes name dungeons with no data; consumable ready board reports what it cannot see.

## 2.8.1

- Boss guide opens on the boss you are fighting at the pull, and a button brings it back when combat hides it.
- New: mount wishlist (star mounts in the Mounts tab; "This Week" tracks your picks).
- New: `/mh groupbuffs` (missing raid-wide buffs, honest when auras are hidden) and `/mh pawn` (stat weights as a Pawn scale).
- New: Codex entry explaining gear upgrade tracks; Discord invite in Settings and on "This Week".
- Fixed: phantom "Trovehunter Bounty detected!" popup outside delves; addon icon and minimap button were never drawn; crash when opening the window in delves/follower dungeons; crash in `/mh pawn`; "50%%" in the Dawncrest guide; dungeon lost when changing floors; delve popups in follower dungeons.

## [2.8.0] - 2026-07-16

Know your role — and see how it went. What to press, when to press it, and an honest look at how the run actually went. Plus everything for Season 2, dormant until 12.1.

### Added

- **A toolkit for every role** — the Role Academy now has a spec-aware toolkit for **healer, tank and DPS**, showing the buttons *your* spec has. Healers: healing cooldowns labelled with what each is *for*, a deepened beginner course, and a "what can I dispel?" reference. Tanks: active mitigation + personal defensives. DPS: damage cooldowns + personal defensives. Spell tooltips on hover; the list is filtered to what you actually have (Berserk *or* Incarnation, never both).
- **Death recap** (`Modules/Retrospective.lua`) — in dungeons/raids it names the killing blow plus a lesson, on a readable card. In delves/rituals/follower dungeons — where 12.x forbids addons from reading the combat log — it opens **Blizzard's own Death Recap** (`DeathRecapFrame:OpenRecap`, which does work there), asks once, and is toggleable in Settings or via `/mh death auto`.
- **Tank pull summary** (`Modules/TankPullSummary.lua`) — active-mitigation uptime %, defensive cooldowns used, a nudge when none were, Brewmaster Stagger. `/mh pullsummary` + `boss` / `popup` / `status`. Pulls under 12s are skipped; where auras are secret it says "hidden" instead of a false 0%.
- **Interrupt scorecard** (`Modules/InterruptScore.lua`) — landed vs wasted kicks, with an optional local-only nudge on a wasted kick. `/mh kicks`.
- **Mythic+ gain advisor** — per-dungeon season best and where another key adds the most rating, plus an honest gear pointer (keystone tooltip / Great Vault). `/mh mplus`.
- **Openables** — recognises "Use: Collect N …" reward/currency packs and uncollected cosmetic appearances; hides items whose requirement you don't meet.
- **Keybind coach: stop-toolkit cross-listing** — the interrupt card also lists abilities that stop a cast (stun/silence), tagged with why, while they keep their own key. Blinding Light deliberately excluded (won't reliably stop a cast). Druid forms pinned to the same keys in every spec: Travel `R`, Cat/Bear/Moonkin `Shift+R/T/X`.
- **Season 2 / patch 12.1 content**, season-gated (invisible until interface >= 120100): the raid *The Venomous Abyss*, the lair *The Tidebound Grotto*, the dungeon *Altar of Fangs*, and the full S2 Mythic+ rotation (5 Midnight-native + Kings' Rest / Temple of Sethraliss / Ruby Life Pools). All ids verified against the installed DBM mods and confirmed on the 12.1 PTR.
- **NavSearch `@category` filters + a `/mh` command palette**; translations now route to a GitHub issue form.

### Fixed

- The main window's auto-grow didn't reserve the favourites row, so the sidebar's last tab hung off the bottom edge.
- Codex entries overlapped the next entry's title (block height was measured before the text wrapped).
- **Omnium Folio**: the open button could open another expansion's landing page; it now verifies it's the Midnight Folio, level-gates levelling alts (the unlock quests are account-wide, so an alt looked "unlocked"), and reports through the addon's own toast.
- **Death recap**: no more `ADDON_ACTION_FORBIDDEN` spam in delves/rituals (zone-event bursts are debounced so the instance info settles first), and the restricted card no longer fires on PvP deaths.
- **Interrupt scorecard**: focus/mouseover kicks counted as whiffs (only the target's GUID was stored); the whiff TTS was silently mute (bad argument order). The party-chat shout was dropped — a kick pressed with nothing casting is a wasted global, not a missed interrupt.
- **Keybind coach**: ~13 verified core abilities were missing (JustAC cross-check), and the DPS toolkit listed *Dark Ascension* under Unholy Death Knight — it is a Shadow Priest talent.
- Tank pull-summary popups could swallow a back-to-back second summary (toast id dedupe).

### Changed

- **Lighter, honest data throughout**: every DPS spec's damage cooldowns re-verified against the installed JustAC data (build 12.1.0.68301); ambiguous spell ids (Warbreaker, Convoke, Wake of Ashes, …) are left out rather than guessed.

## [2.7.0] - 2026-07-12

Everyday decisions, made easier — *"is this an upgrade?"* and *"how did that run go?"* — plus a calm on-ramp to the next season and a route arrow that finally guides every route.

### Added

- **Loot upgrade tips** — hover any gear and Midnight Helper says whether it's an **Upgrade**, **Sidegrade** or **Lower** for your spec, with the exact item-level change (same stat weights as the Great Vault advisor). Upgrades also get a green arrow on the bag item. Toggle with `/mh loot`.
- **Season transition checklist** — as a new season approaches, *This Week* shows what to wrap up now and, once the patch is live, how to get ready for the next one. Signal-driven from the client build + M+ season, so it only appears when relevant and never shows a made-up "done". `/mh season`.
- **Post-run scorecard** — one friendly line after a Midnight delve or ritual: your time (with a nudge vs your own average / a record) and deaths. `/mh scorecard`, plus `/mh scorecard detail` for the exact numbers.
- **Season 2 in the Codex** — a reassuring "what a new season means" explainer and a Season 2 glossary (crest, upgrade track, tier set, Catalyst, Bountiful, Nemesis, Lair, start-of-season rescale).

### Changed

- **Route arrow** — Midnight Helper's own on-screen arrow now guides delves, world bosses, the Trading Post, Silvermoon City and more (not just rares/treasures) even without TomTom, and releases on arrival. It's **brighter with a dark outline** so it reads on any background.
- **Find nearest bountiful delve** now measures distance and picks the actually-closest one (it used to return the first in roster order).
- **Lighter at login** — only your active language pack is built instead of all seven, for lower memory use.

### Fixed

- An error could repeatedly appear inside delves, dungeons and Mythic+ (the game hides some aura details in that content, which the accessibility/ritual debuff scans tripped over — *"cannot be indexed with secret keys"*). Now handled quietly.

## [2.6.0] - 2026-07-10

Two new pages — a **Collectible mounts** tab and a **Raids** page — and a beginner-focused pass over the whole window, so Midnight Helper answers *"what should I do right now?"* before it answers anything else.

### Added

- **Collectible mounts tab** (*Me → Collectible mounts*) — a checklist of the 17 new Midnight mounts. A green tick for the ones you own, a red cross for the rest; each shows live progress (renown level, meta-achievement steps, item counts), how to get it, and a floating **3D preview** when you hover its name. Hover a Voidlight Marl line for your balance across every character. Mounts that are pure RNG — a rare drop, a puzzle, a hidden chain — honestly show no progress bar rather than a made-up one.
- **Raids page** (*Codex → Raids*) — boss steps for all three Season 1 raids and their nine bosses, with tank/healer/dps lines and clickable spell links. Boss names come from the Encounter Journal, so they follow your game language. The Raid Coach still opens by itself on a boss pull; this page is for preparing beforehand.
- **"Next up" headline on Home** — the single most useful thing to do right now, with a **Take me there** button and a tally of your weekly progress.
- **Bosses in search** — type a boss name to open its coach steps directly (52 bosses across dungeons and raids).

### Changed

- **Search index** — the *Collectible mounts*, *Raids* and *Pop-out windows* tabs were missing from it entirely; typing "mount" found nothing. Fixed.
- **First run** now opens the Start Here roadmap instead of a tour of the window's buttons, and Start Here leads with its six-step plan (the walkthrough sits below it, collapsed).
- **Home** opens with fewer sections unfolded and packs the folded ones into a tidy two-column grid. Everything is one click away and your choice is remembered. Existing choices are reset once so the new defaults apply.
- **Sidebar** — the Character list is grouped into *Collections*, *Gear*, *Resources* and *Alts & history*.
- **Names** — Home → **This Week**, SMC City Guide → **Silvermoon City**, Launchpad → **Pop-out windows**.
- **Colours** — one shared palette: "done" is the same green and "do this" the same amber on every page.
- **Translations** — everything above is available in German, French, Spanish, Portuguese and Italian.

### Fixed

- Ritual Sites and Void Assaults offered a "pick it up" step at any level, so a levelling character could have been sent at endgame content as the headline action. They are now gated behind max level for that purpose; they still appear in the checklist below it.

## [2.5.0] - 2026-07-09

Adds support for the new **Devourer** Demon Hunter specialization, refreshes consumables for 12.0.7, and folds in the July distribution / onboarding / polish batch.

### Added

- **Devourer Demon Hunter support** — the new Midnight 12.0.7 Void DPS spec (specID **1480**, verified via wago.tools `ChrSpecialization` + an in-game dump):
  - The **keybind coach** maps the Devourer rotation, cooldowns and **Void Metamorphosis** onto your layout. Roles are derived from ClassCodex/JustAC data, keyed by spell ID and scoped to the spec; baseline Demon Hunter abilities apply automatically.
  - The **consumables bar** recommends the correct flask, potion, oil, augment rune and feast for Devourer.
- **Minimap-button toggle** — hide Midnight Helper's minimap icon for a clean minimap; the addon stays reachable from the game's **AddOns compartment**. Open the window any time with **Alt+M**.
- **Auto-release pipeline** — a BigWigs packager (`.pkgmeta` + GitHub Action) builds and publishes the CurseForge zip automatically on a version tag.
- **LuaLS groundwork** — `.luarc.json` + type annotations for editor diagnostics.
- **Guided professions mode** — an opt-in "take you by the hand" wizard (Professions 101 → *Guided mode*) that walks a beginner through learning and levelling any of the 11 professions **one step at a time**, with trainer / Work Order waypoints and a profession switcher. Steps auto-tick from live game state (profession learned, window opened, tool equipped, skill-rank milestones); anything we can't read is a manual *Done*. Step data is derived from the verified `PROFGUIDE_LVL_*` routes; text in English + Dutch (other languages fall back to English).

### Changed

- **Consumables refreshed for patch 12.0.7** — flasks, combat/healing potions, weapon oil, augment rune and feasts re-checked against the current guides (cross-verified across ClassCodex, Icy Veins and Wowhead/Method).
- **Complete addon metadata** in the `.toc` (author, category, website, license, six-language notes) plus an AddonCompartment entry.
- **Leveling tips (80→90) fully translated** into German, French, Spanish, Portuguese and Italian; the delve-count tip is decoupled from a hard-coded number.
- **README** refreshed for interface `120007` and the current feature set.

### Fixed

- Opening **Settings while in combat** (e.g. inside a Delve) no longer throws `ADDON_ACTION_BLOCKED` — guarded with `InCombatLockdown()` plus a message.
- A **Delve crash** from comparing a "secret" `GetUnitSpeed("player")` value on patch 12.x — now guarded with `issecretvalue`.
- A **keyboard-layout tooltip crash** (a `SetText` alpha-argument misuse) on the spell-strip card headers.
- **Beta / Leveling tab toggles** now update the open window live, without a `/reload`.
- Rare/zone data: the Eruundi map-ID conflict and the Asha name were corrected.
- **Delve boss-coach prompt** no longer mis-fires on trash/critters and no longer misses the real boss: it now triggers on the final scenario stage (the boss room) via `C_ScenarioInfo`, with `ENCOUNTER_START` as confirmation.
- **Delve consumables popup** no longer re-appears after the last boss (kept the "already used" state across the `IsDelveInProgress` flicker) and can't show at an open-world boss (`IsInInstance()` gate).
- **Consumable Ready-check** board no longer pops solo in open-world scenarios (allow-list of real Ritual Sites) and no longer re-appears at ritual/delve completion.
- **Ritual Site buttons** always set a waypoint now — an unroutable live quest objective (a scenario/instance map) used to leave the active-site button doing nothing; `AddSmartQuestRoute` now falls back to the target coords, which protects every caller.

## [2.4.1] - 2026-07-05

Moves all settings into the native Blizzard Settings window, expands the achievement metas, and fixes two 12.x "secret value" regressions. Released as a Beta.

### Changed

- **Settings now live in the native Blizzard Settings window** (Game Menu → Options → AddOns → Midnight Helper): searchable, a tooltip on every option, sub-categories, and your **language selector right at the top**. The in-addon Settings tab becomes a **launcher** (eyecatcher + "Open settings" + the Test/Preview/Reset quick actions), since native action buttons assert on client 12.0. Blizzard's own **Defaults** button doubles as "recommended". Per-achievement visibility gets its own subsection. `/mh settings` opens the native panel.

### Added

- **Achievement zone-meta drill-down.** The four zone metas that feed *Light Up the Night* (Forever Song, Making an Amani Out of You, That's All Folks!, Yelling into the Voidstorm) are now expandable (+/−) to show their component sub-achievements with live progress — read straight from the game's criteria API.

### Fixed

- **Missing Buff is back in the open world.** It was wrongly hidden across *all* Midnight zones: the reminder used "is player health a secret value?" as a fallback signal for "are auras unreliable", but health reads as secret in open-world Midnight zones while auras are perfectly readable there. It now trusts Blizzard's authoritative `C_Secrets.ShouldAurasBeSecret()` and only uses the health fallback if that API is absent — so it shows in open content again and still stays quiet in delves/rituals. (Regression from 2.4.0.) `/mh mbuff` now also prints the enabled / auras-secret / health-secret signals for diagnosis.
- **Delve boss-coach prompt no longer over-fires.** It popped when you targeted a neutral quest giver (they're "attackable" too) and re-popped on every random enemy. It now only offers on a genuinely hostile (`UnitIsEnemy`) target, and at most **once per delve**.

## [2.4.0] - 2026-07-05

Adds the Combat Safety cast warning and a delve boss-coach prompt, plus several patch 12.x "secret value" fixes. Released as a Beta.

### Added

- **Combat Safety — dangerous cast warning.** When an enemy casts a spell that targets **you**, a movable red icon with a countdown appears (so you can move or interrupt). Optional **cast bars** show several incoming casts at once, and an optional **voice** speaks the cast's name. All of it is 12.x "secret value" safe (visibility is driven by Blizzard's own boolean/duration APIs, never by reading protected values). Enable and tune it in **Settings → Notifications**; an "only important casts" toggle narrows it, and a Preview button lets you position the icon/bars. Default on (icon); bars and voice are opt-in.
- **Delve Coach boss prompt.** Targeting an enemy in a delve (out of combat) now shows a small **"open the Delve Coach?"** button, mirroring the dungeon boss window — so you can pull up boss tips without opening menus. It hides once you're in combat and doesn't fire for trivial critters.

### Fixed

- **No more `ADDON_ACTION_FORBIDDEN`/taint errors on the reset route.** Accepting a quest from a giver no longer throws a Lua error when the NPC's GUID or name is a 12.x "secret value" (the giver-learn falls back safely and never guesses).
- **Missing Buff no longer spams in delves/rituals.** In content where 12.x hides auras, the reminder could keep telling you to re-apply a buff (e.g. a Shaman shield) it couldn't actually see. It now detects that auras are secret and stays quiet there; it works normally in open content.

## [2.3.1] - 2026-07-04

Hotfix for a combat error introduced in 2.3.0.

### Fixed

- **Missing Buff reminder no longer throws a blocked-action error in combat.** When a maintainable buff dropped or was reapplied mid-fight (for example on entering a ritual), the reminder tried to hide/show its icon while that icon was treated as "protected" — producing an `ADDON_ACTION_BLOCKED` error (and repeated spam). The click-to-cast button is now positioned independently of the reminder icon instead of being anchored to it, so the icon is never protected and can hide/show freely during combat. Click-to-cast (out of combat) still works exactly as before.

## [2.3.0] - 2026-07-04

The biggest release yet: a completely rebuilt Leveling/Layout tab, three new on-screen tools (Missing Buff, Openables, Fast Mark), and full localization of it all.

### Added

- **Leveling tab completely rebuilt around a live keyboard layout.** The old per-class/spec guide (~6,900 lines plus a 5,152-key advisor and duplicate consumables data) is gone. In its place: an ISO keyboard that reads your **actual spellbook** (`C_SpellBook`) and lays out every ability by role, following a single universal keybind standard (**v6**: E=interrupt, Q=movement, Z=minor defensive, C=major defensive, V=dispel/CC, F1=burst; overflow Shift→Ctrl→Alt; AoE as the Shift-twin of its single-target key; F2/F3/F4 self-heal anchors). Coverage is **all 13 classes and 39 specs** via a name→role classifier (~490 entries) built and cross-checked against installed rotation/interrupt/defensive addons. Hand-tuned maps ship for a few specs (Frost Mage, Elemental/Enhancement Shaman, Hunter, Paladin) and act as overrides; every other spec is generated live from what you can currently cast — no wrong or missing spell IDs, and it re-draws on level-up, talent/loadout swap and spec change.
- **Spell-strip category cards** under the keyboard group your abilities (builder, spender, AoE, interrupt, movement, utility, defensive, dispel/CC, cooldowns, self-heals) with real in-game tooltips on each row. Healers get a dedicated **"Single-target heals (mouseover)"** card (click-cast), while raid heals stay on keys.
- **"Consumables & extras" bar** on the Layout tab: a full-width strip of flasks, food, weapon oils/runes, augment runes and other non-keybind essentials with live ready/missing status, plus an "extras only" filter.
- **Missing Buff reminder** (replaces the standalone MissingClassBuff addon). A movable, resizable on-screen icon appears when you can cast a maintainable class buff you don't have active — raid buff, form, shield, weapon imbue, poison, stance, pet, ally buff or Paladin aura. **Click it to cast** (out of combat). Own, Wowhead-12.0.7-verified data across all 13 classes; toggle in Settings.
- **Openables tracker.** A movable button (with count badge and expandable list) for openable bag items — caches, lockboxes, satchels, quest containers. Left-click opens the next one; items you can't open yet at your level are hidden, and a sound plays when a new openable drops. Toggle in Settings.
- **Fast Mark bar.** Quickly mark your target (the eight raid icons + clear), drop world markers on the ground (left-click set, right-click clear, clear-all) and run a ready check. Secure buttons (post-12.0 `/tm` + `worldmarker`), a draggable gold-bordered bar that appears only while you're in a party/raid. Enable in Settings or with `/mh mark`.

### Changed

- **Route arrow shows per-content icon and colour** — rare (red), treasure (gold), achievement (yellow), reset route (blue) — with the target name and distance in the matching colour. If **WaypointUI** is installed, Midnight Helper hands the route to its in-world pin and stands its own arrow down (single guide); with TomTom it stays out of the way as before; with neither, its own arrow guides you.
- **Guides are out of Beta.** The Codex, Guide, Leveling, Macros and Role Academy tabs are promoted to full features (Beta badges removed).
- **Full localization.** All new strings (Missing Buff, Openables, Fast Mark and their settings) are translated into German, French, Spanish, Portuguese, Italian and Dutch.

### Fixed

- **Ritual consumable checks trigger on every ritual site**, not just one hardcoded scenario — so Daggerspine and the other sites now prompt correctly.
- **Treasure toast no longer vanishes** when you move away from a treasure it's already showing.
- **Dungeon boss info opens when you target the boss** (instead of on encounter-start).
- **Route clearing is more reliable across all route types** — internal clears no longer stop a route the player didn't clear themselves.

## [2.2.0] - 2026-07-01

Standalone route guidance — the arrow no longer depends on TomTom.

### Fixed

- **Route arrow works without TomTom.** The whole "arrow survives arrival / advances to the next stop" behaviour was previously TomTom-only; without TomTom you got a single Blizzard waypoint with no keepalive, so it vanished on arrival and never advanced. A new module (`Modules/NativeArrow.lua`) now draws **our own on-screen direction arrow** (rotates toward the target, shows live distance, drag to reposition) and drives Blizzard's native user waypoint + SuperTrack, following the active route lead (`ns.lastTarget`), re-asserting it when the game clears it on arrival, and advancing it to the next open stop — for every route type (Achievements, Rares, Professions/Treasures, Reset routine).
- **Safety net when TomTom's crazy arrow drops.** If TomTom is installed but its arrow is hidden (e.g. an outdated TomTom/HereBeDragons that can't re-point across zones), the native waypoint takes over so you keep a direction. While TomTom's arrow is actually showing, the native layer stays completely idle (no change for working TomTom setups).
- **Rare hunts advance automatically on the native path.** During a Generate Route rare hunt without TomTom, the arrow flows to the nearest still-open rare after each kill, and — like TomTom's cleardistance — when you reach a rare that isn't spawned (no vignette) and aren't in combat, it automatically moves on to the next one and returns to that rare later once it spawns. `/mh skip` (or the Skip keybind) is still there as a manual override. Distance on the arrow can be shown in meters (Settings > General).
- **Weekly/reset route tours every stop instead of sticking.** The route arrow now moves on from any stop (vault, quest givers, ritual/void hub, profession trainers, work-order station) once you accept a quest there or stand on it for a few seconds — so it no longer gets stuck on things it can't auto-verify (Halduron's rotating weekly, a ritual intro you skip, an empty trainer). Every stop is shown honestly in the checklist with its real status; this only affects where the arrow points.
- **Quest givers now track their rotating weeklies automatically.** Midnight Helper learns which quest each giver (Liadrin, Halduron, Aethas) hands out the moment you accept it, so a rotating dungeon-of-the-week no longer shows as "not picked up" — no manual updates needed, and it self-heals every week for everyone.
- **No more arrow flicker on arrival.** When TomTom briefly blanks its arrow as you reach a waypoint, Midnight Helper no longer flashes its own arrow for a moment — it only steps in for a sustained drop.
- **Main window sits above the action bars.** The window now uses a higher frame strata, so your keybind/action-bar buttons no longer bleed through the bottom of it.
- **Clear the active route/arrow any time.** Right-click the arrow, use `/mh clear` (aliases `clearroute` / `stop`), or bind a key (Esc → Key Bindings → Midnight Helper → Clear active route). Fully stops whichever route is running (achievement, rare, treasure or reset) and removes the arrow, TomTom and native waypoints.
- **No more borrowed HereBeDragons dependency.** The Achievements cross-zone re-point (`ForceArrowToLead`) now translates coordinates via the game's own `C_Map` world coordinates instead of a `HereBeDragons-2.0` instance lent by TomTom/HandyNotes — so cross-map routing behaves identically whether or not those addons are present, and can't break on an old library version.

## [2.1.1] - 2026-07-01

Fixes and polish for the Achievements tab.

### Fixed

- **The route arrow no longer disappears** — not on arrival, not when you kill a rare on the way, and not when you cross between sub-zones (e.g. into Slayer's Rise while routing in Voidstorm). Midnight Helper keeps the crazy arrow pinned to your next open treasure/rare itself, translating it onto whatever map you're standing on (via HereBeDragons), so it keeps flowing even without TomTom's "set closest waypoint" option. It also re-points proactively on each map change and on combat-end, and leaves the arrow alone when you're parked on an un-spawned stop (use `/mh skip`).
- The "you're nearly there" rare alert now fires only when you're actually on a rare route, not when you pass a previously-routed rare while heading to a treasure.

### Added

- **Skip the current route target** with `/mh skip` (or `/mh next`) or a new keybind (Esc → Key Bindings → Midnight Helper). Useful when a rare isn't spawned — the arrow moves to the next open one and you cycle back to skipped stops later.
- **Per-card type tags** (Treasure / Telescope / Lore / Rare), an **Elite** flag on the tougher rares (cross-referenced from HandyNotes), and a tooltip hint on the achievements that count toward **Light Up the Night** (Brilliant Petalwing mount).
- **Live Light Up the Night breakdown** under the tab summary: the four zone metas it requires (Forever Song, Making an Amani Out of You, That's Aln Folks!, Yelling into the Voidstorm), each with its own progress, read live from the achievement criteria. Hover a row for an accurate per-criterion checklist (real done/missing status), Shift-click to link, Ctrl-click to open Blizzard's panel, and click the header to preview the **Brilliant Petalwing** mount.
- **Full localization** of the route how-to notes, step labels and chat/popup messages into all seven languages. Treasure/rare/item names stay in your game-client language to match the world.
- **Checklist readability:** zebra striping and a hover highlight make it clear which Waypoint button belongs to which stop. Plus `/mh arrowdebug`, an optional diagnostics log for routing support.

## [2.1.0] - 2026-06-30

A new Achievements tab for Midnight's collectible hunts.

### Added

- **Achievements tab** (Me room): track the Treasures, The Highest Peaks (telescopes), Midnight Lore Hunter and the zone rare-hunter achievements across Eversong Woods, Zul'Aman, Harandar and Voidstorm, with live per-node progress and one-click TomTom routing to whatever you still miss. The arrow auto-advances as you loot or kill, and survives crossing zones, sub-areas and portals.
- **Rare hunters:** every zone's rares (A Bloody Song, Tallest Tree in the Forest, Leaf None Behind, The Ultimate Predator) as a routable checklist — cross-referenced from HandyNotes and verified against the in-game achievement criteria.
- **Per-card renown and collectible.** Each card shows the faction renown the achievement feeds (with your current renown level) and its completion reward — Sootpaw (pet), Pango Plating and the Interdimensional Parcel Signal (toys) and the Vivacious Chloroceros (mount) — with a collected check read live from your journals.
- **Expandable checklists** with a Waypoint button and a how-to tooltip per treasure, plus a step-by-step hint toast for the multi-step ones (urns, orbs, altars, the Peculiar Cauldron grind, …).
- **Tab summary** showing achievements done, collectibles owned, and live progress on the **Light Up the Night** meta toward the **Brilliant Petalwing** mount.
- **Route nearest open** button — sends the arrow to the closest treasure you still need across all tracked achievements.
- **Sorting and hiding:** open achievements sort to the top, completed ones to the bottom; hide finished or unwanted ones from Settings > Tabs or the "all done — hide it?" prompt.
- **Shift-click** a card to link the achievement in chat; **Ctrl-click** to open Blizzard's achievement panel.

### Fixed

- Removed a taint vector (reassigning the `StaticPopupDialogs` global) that could block Blizzard's spellbook from opening on lower-level alts.

## [2.0.0] - 2026-06-25

A major redesign of how you navigate Midnight Helper, plus full localization.

### Added

- **Four-room navigation.** The sidebar is reorganised into four rooms — Me, Codex, Tools and Settings — that filter the tabs to what fits the room you're in.
- **Global search bar** at the top of the window: type a tab, tool or Codex topic and jump straight to it, with a favourites row (the **+**) for one-click returns.
- **Breadcrumb** in the title bar showing your current location, and a **"Read in Codex"** button on tabs that have a matching Codex article.
- **Tools Launchpad:** a single Tools-room page to open every floating helper window (Delve Coach, consumable board, dungeon boss window, curios advisor, ritual boss coach).
- **Adjustable content text size** (A- / A+) in Settings.
- **Gem advisor** alongside the enchant checker: flags empty sockets and suggests stat-matched gems for your spec.
- **Full localization:** the entire addon is now translated into German, French, Spanish, Portuguese, Italian and Dutch (alongside English), including a first-run onboarding tour for the new layout and a Warband Bank explainer in the Codex.

### Changed

- **One settings home.** Every option now lives in the in-addon Settings tab, with Vault and Tabs as their own categories. Right-click the minimap icon or `/mh settings` opens it; the old Blizzard interface panel and the quick-settings popup are retired.
- **The "after the reset" route auto-advances:** the TomTom arrow moves to the next open stop as you claim the Great Vault and pick up your weeklies.

### Fixed

- The Info button now reflects the tab that's actually open.
- More rares show a 3D model preview.
- The profession trainer-weekly hint no longer mentions Enchanting on every profession (the skill-25 note shows only for Enchanting).
- The Profession treasure arrow now survives crossing continents.
- The Tools Launchpad now follows your chosen language (it previously stayed English).

## [1.8.6] - 2026-06-22

### Added

- **Leader can re-open the consumable board for the whole group.** The party/raid leader (or an assistant) can run `/mh boardall` to pop everyone's consumable board at once, so the whole group can re-check flasks, runes, food and buffs on demand before a pull.
- **"Final boss — open coach?" prompt in delves.** If you closed the Delve Coach earlier in a run, a small button now reappears when a boss encounter starts, letting you re-open the coach for the final fight with one click.

## [1.8.5] - 2026-06-21

### Fixed

- **World boss "Warband: defeated this week" now shows on every character** once any one of your characters kills it, using the account-wide quest flag (the same approach that fixed the Omnium Folio alt counter). Previously alts that hadn't looted still showed "not defeated yet". The completing character's name is now remembered account-wide so alts can show "defeated by …" too.
- **Weekly Coffer Shard cap popup now appears only once per character per week.** Previously it could re-appear on every login because the "seen this week" mark was only set when the toast finished displaying; it's now set the moment the cap is detected. (After updating you may see it one more time, then it stays off until the next reset.)

### Added

- **Professions 101 — skill-leveling routes & Work Orders.** Each profession chapter can now show a concise "Skill leveling 1-100" route (Alchemy & Herbalism first, more to follow) with trainer, shopping list and step-by-step skill ranges. Plus a new **"Work Orders explained"** chapter covering all four order types and how to both order items and craft for others.
- **Setting to hide the weekly Coffer Shard cap popup** (Settings → Dungeon). First community request (gadrinonturalyon on CurseForge) — the shard-cap toast can now be turned off.
- **Setting to show/hide the 3D boss model** in the floating boss window (Settings → Dungeon). Turning it off hides the model; takes effect immediately while the window is open.
- **Italian language (itIT).** Full interface and guide translation. Auto-selects on an Italian WoW client (since patch 5.0.4), or choose it manually with `/mh lang it`. Older changelog entries intentionally remain in English (as with the other added languages).

## [1.8.4] - 2026-06-21

### Added

- **Consumable board redesigned to an icon view.** Each cell is now a real item or spell icon with a status badge (green = ready/active, amber = in your bags but not used, red = missing, grey = unknown), stack counts, and buff timers above your own row. Your own consumables are **clickable to use** straight from the board.
- **Raid & class buffs on the board.** Shows Arcane Intellect (Mage), Battle Shout (Warrior), Power Word: Fortitude (Priest), Mark of the Wild (Druid) and Skyfury (Shaman) — only when a provider class is in the group. **Hover a buff to see exactly who has it and who's missing** (the whole group, read directly so it works cross-faction and with multiple of the same class). Your own class buff is **clickable to cast**.
- **Smarter, gap-free columns.** Healthstone only appears when a Warlock is in the group; weapon oil only for specs that use it.
- **Wider trigger + quick access.** The consumable check now also appears when you enter a **ritual or delve** (not just dungeons), and you can reopen the board with a **middle-click on the minimap button** (also `/mh board`).
- **"Not in your bags" tooltip:** hovering a slot you're missing shows the recommended item.

### Changed

- **Food (Well Fed) detection now covers every food** via its shared buff icon, instead of a fixed spell list.

### Fixed

- **Omnium Folio unlock counter is now account-wide** — alts no longer show 0/5 when the rows are already unlocked on your account (also fixes the Folio weekly reminder).
- **Delve/Ritual death counter no longer resets to 0 after a `/reload`** (deaths are now stored on the persistent run).
- **Lua error from 12.x "secret" aura values** when checking buffs is resolved (the lookup is inverted to a secret-safe path).
- **The Catalyst is now correctly named the Matrix Catalyst** (was "Creation Catalyst"), with how to unlock it (Eldara Dawnrunner) and the Dawnlight Manaflux currency; the renown vendors Rae'ana and Sergeant Vornin are clickable waypoints.

## [1.8.3] - 2026-06-20

### Added

- **Consumable ready-check.** When you enter a dungeon, Midnight Helper checks your own **flask, augment rune, combat & healing potions, food and healthstone** (from your bags) and shows the **group's buff status** — all with Blizzard ready-check icons. Run it any time with `/mh readycheck`, mute it with `/mh readytoggle` or the new **settings toggle** (Dungeon Coach). Never-lie: when a slot genuinely can't be read it shows a **"?"** rather than a false "missing".
- **Consumable ready board.** A floating board appears automatically on dungeon entry showing each group member's ready-check icons. It's draggable, **SHIFT+scroll to zoom**, and hides itself when you pull (or after 25s). Open it any time with `/mh readyboard`.
- **Group bag sharing.** Group members running Midnight Helper share their bag status, so you see their **flask/rune/potions/food/healthstone** instead of "bag unknown" (the API can't read other players' bags directly).
- **Daggerspine Point boss window** now opens automatically at each boss stage (Mindbreaker, Selen'vjar), the same as the other Midnight dungeons.
- **Ritual Sites Renown Codex article.** A new world Codex entry explains the **8-rank "Journeys" track**: what each rank unlocks (regeneration orbs, treasures, housing decor, shrines, pets, and the Void-Touched Hawkstrider mount) and why a higher-rank site yields more spoils.
- **Vendor waypoints for the Ritual Sites renown vendors:** **Rae'ana** (housing decor, Dark Obelisk) and **Sergeant Vornin** (pets, Void-Touched Hawkstrider) in Silvermoon are now clickable waypoints anywhere their names appear.

### Changed

- **Consumable check: food added + spec-matched flask/rune.** Food/feast is now part of the check, and your flask and augment rune show **green for the spec-recommended best** and **amber for an alternate**.
- **Omnium Folio tab — "Open rune window" button.** Opens the Folio directly via the expansion landing page, so you can reach it even when your UI hides the minimap expansion button (e.g. Ellesmere UI). Falls back to a hint if it can't open (e.g. in combat).
- **Folio weekly reminder now tells you what this week's Mote needs** — e.g. "collect 8 Ritualized Arcana from Ritual Site elites" — instead of just a generic do-it reminder.

### Fixed

- Consumable ready-check derives each item's buff via the item's own spell, so a missing buff is never reported falsely when the item is on cooldown or the aura name differs.
- **Omnium Folio unlock counter** (and the Folio weekly reminder) now count **account-wide** unlocks. Previously an alt that hadn't personally done the questline showed 0/5 even though the rows were already unlocked on the account; it now reads the account-wide quest state with the per-character flag as a fallback.

## [1.8.2] - 2026-06-17

### Added

- **Omnium Folio tab:** the full patch 12.0.7 rune tree — all five rows and thirteen runes as clickable spell links (hover for the live tooltip), each with a short effect note. A **content-type selector (Mythic+ / Raid / PvP / World)** highlights the recommended pick per row, plus the unlock walkthrough with a **clickable waypoint** to where the questline starts, and a live **"x/5 rows unlocked"** counter from your Folio quest progress. Recommendations are general baselines, not per-spec BiS; the tab appears on clients 12.0.7 and later.
- **Folio weekly reminder:** the Account snapshot weekly checklist now shows an account-wide line to do this week's Omnium Folio Mote, tracked across the weekly reset, and disappears once your Folio is fully unlocked (5/5).

### Changed

- **Floating boss window — closing now only dismisses that one boss.** Pressing the X keeps just that boss away; the next boss brings a fresh window (a new pull, a ritual stage, or simply targeting the boss). A new **"Open automatically" toggle** (Dungeon Coach settings) is the permanent opt-out; the window still opens on `/mh bosswin`.
- **Targeting a dungeon boss reopens the boss window** and jumps to that boss (uses the boss's creature ID; falls back to a boss-classification check where the target's ID is hidden).
- **Great Vault advisor — threshold-aware tier note.** Instead of a generic "this is tier" line, the advisor now tells you whether taking a vault tier piece *completes* your 2- or 4-set bonus (take it!) or is just another piece with no new bonus yet (a stat upgrade may win the week).

### Fixed

- Lua error in ritual scenarios on 12.x: boss unit IDs are now "secret" values and could taint and error when read; they are now skipped safely.
- Showdown world boss data: Imperator Pertinax now uses the correct creature ID (261072) and kill quest (96473), cross-checked against external addon data.

## [1.8.1] - 2026-06-16

### Added

- **Tier Sets tab** (Character): your class set, your 2- and 4-piece set bonuses as clickable links (hover for the live, localized tooltip), and a live counter of how many tier pieces you have equipped. Explains what tier sets are and how to get them (raid tokens, Great Vault, the Creation Catalyst — itself a clickable waypoint).
- **Currencies tab** (Guides): a "where do I earn it, where do I spend it" map for every Midnight currency with your **live balances**, plus a waypoint to each Renown Quartermaster.
- **Clickable vendor names → waypoints:** known vendor/NPC names anywhere in the addon are now clickable to set a TomTom (or Blizzard) waypoint.
- **Rare skull:** route to a rare from its alert and a skull marks it on its nameplate as you arrive, so it's easy to spot among other mobs (taint-safe; works solo and in groups).
- **Simple view:** a toggle at the top of the menu hides everything but the core tabs — calmer for new players. Set once; remembered account-wide. (Full view is the default.)
- **Val & Naigtal Showdown rares** added to the Rares tab.

### Changed

- **A calmer, more cohesive look:** one unified gold accent across every tab and all six languages; boss role lines now use role **icons** instead of three competing colours; softer link colours and desaturated status colours; the Silvermoon City guide no longer looks "boxed in"; and **tooltips now appear at your cursor** everywhere.
- The **Enchants** panel now updates the moment you apply an enchant, and each suggestion is clickable to copy its name for the Auction House.

### Fixed

- World-boss "defeated this week" line is now correct across your whole warband (and names who did it first).
- Veteran Dawncrest balance reads correctly; the in-game changelog popup is no longer stuck on old versions (it was showing up to 1.5.5).
- Removed duplicate ability names that repeated next to their own clickable spell link in boss steps.

## [1.8.0] - 2026-06-15

### Added

- **Events tab** — a new sidebar tab listing all of Midnight's world events in one place: what's firing **now** and what's **coming up** over the next day, with live countdowns. Live events are **clickable to set a route** (TomTom or Blizzard waypoint + travel advice), and **hovering** any event explains what it is and what it rewards. **Shift-click** an event to spin its rewards as full 3D models. `/mh eventspy` dumps the live scheduler for diagnostics.
- **Full raid coaches** — beginner boss steps for all three Midnight raids: **The Dreamrift** (Chimaerus), **The Voidspire** (6 bosses) and **March on Quel'Danas** (Belo'ren, L'ura, the Crown). Each boss lists its key casts as clickable spell links with the action to take (dodge / interrupt / move / defensive), and the boss window opens automatically when you pull. The **Sporefall raid (Rotmire)** and **Daggerspine Point ritual** are in too.
- **Mythic+ tab** — affix ladder, Xal'atath's Bargain variants, the full Season 1 dungeon pool, and **must-interrupt lists per dungeon** (clickable spell links where confirmed). Includes a **Beginner mode** with a plain-language glossary so the jargon doesn't bury you.
- **Helper alerts (opt-in, accessibility)** — turn it on in the Mythic+ tab's Beginner mode and you get one big, calm on-screen warning (with sound) when **you** get a dangerous debuff to react to. Starts with Devouring Rift; more are added as they're confirmed. (Enemy-cast interrupt alerts aren't possible this patch — that data is protected by the game — so this watches your own debuffs instead.)
- **Enchants tab** — a quick check of your equipped gear: which enchantable slots are missing an enchant, with a stat-matched Midnight suggestion for your spec. Every suggestion is a **clickable, hoverable link** (real tooltip), and clicking one drops its name into a copy box for an **Auction House** search. Head and feet show the Speed / Leech / Avoidance choice; legs show the armor-kit (Agi/Str) and spellthread (Int) options.
- **Currencies tab** — a "where do I earn it, where do I spend it" map for every Midnight currency (Voidlight Marl, Field Accolade, Dawncrests, PvP), with your **live balance** beside each and a **waypoint button per Renown Quartermaster**. Currency names are clickable.
- **Gear & Currency Vendors** added to the Silvermoon City guide — Maren Silverwing (Field Accolade gear caches) and Triam Dawnsetter (cosmetic transmog caches), as routable waypoints.
- **Delve & Ritual Log** — your ritual-scenario runs are now logged alongside delves (site, time, deaths, completion) with totals.
- **More weekly-checklist coverage** — additional weeklies tracked (e.g. Building the Voidforge).

### Changed

- All of the above is **fully translated** into English, Nederlands, Deutsch, Français, Español and Português.
- **Faithbreaker Ger'lok** steps now name the real abilities (interrupt Shadowbolt Volley, line-of-sight Shadow Blast); the **Broken Throne dragonhawk** mechanic is corrected (soak the red pools); a note explains that destroying the Dark Obelisks weakens the ritual bosses.

### Fixed

- **World boss "Warband" line** now correctly shows the boss as defeated this week on **every** character once **any** of your characters has killed it (it used to read "not defeated yet" on alts that hadn't personally looted), and names the character who did it first.
- **Veteran Dawncrest** currency now reads the correct id (with a fallback so the balance shows regardless).
- Delve Log recent-runs entries now expand correctly.

### Notes

- Event and currency reading is fully taint-safe under the 12.x protected-data model (scheduler/widget reads happen in an isolated ticker; the UI only reads plain values).
- Boss and Mythic+ data is written against DBM / Wowhead and is being verified in-game — corrections welcome.

## [1.7.1] - 2026-06-12

### Added

- **Floating Boss Window** (`/mh bosswin`): a compact, movable companion window with the current boss's steps — clickable spell links, a full-body **3D model side panel** (close it per dungeon; the portrait button brings it back), boss pager that **auto-advances when a boss dies**, Chat and Share buttons, resize grip, and **Shift+scroll to scale** the whole window (great for high resolutions). Opens automatically at every boss pull; closing it keeps it away for that dungeon only.
- **Boss steps now in all six languages** — the final localization gap is closed: every dungeon guide reads natively in English, Nederlands, Deutsch, Français, Español and Português (spell names were already client-localized via the links).

### Fixed

- **Windrunner Spire boss order:** Emberdawn is boss 1 (was listed after Derelict Duo) — affects the Coach tab, boss window pager and live coach.
- Boss window model could render empty on first show (async model loading) — it now reloads itself an instant later.

## [1.7.0] - 2026-06-11

### Added

- **Dungeons tab** — your new dungeon companion (sidebar → Dungeons):
  - **This week:** Spark weekly, Halduron's dungeon of the week, Cracked Keystone and your Great Vault Dungeons row, tracked live.
  - **Dungeons 101:** a six-chapter beginner course from your first queue to your first Heroic, with per-character progress — in all six languages.
  - **Dungeon Coach:** boss steps for **all 12 dungeons (43 bosses)** — what to dodge, what to kick, what your role does — in plain beginner language. Every ability is a **clickable spell link**: hover for the real tooltip, and the spell names show in your client's language. Collapsible per dungeon, with a route button to every entrance (TomTom + travel advice, including the legacy portals).
  - **Live coach:** the steps for a boss appear in your chat the moment you pull it (once per boss per session; `/mh livetips` toggles). `/mh bossshare` shares the last boss's steps with your group — used mid-fight, the share is queued and sent automatically the moment combat ends (Blizzard blocks addon chat in combat).
  - Boss steps are written against DBM data and Wowhead spell tooltips; in-game verification is ongoing — corrections welcome!
- **Rare alert, supercharged:** the toast now shows the actual **3D model** of the rare at double size, is **draggable** (position saved for all toasts), and knows when you're already flying to your routed target ("you're nearly there!" instead of "click to add a waypoint"). New option: only alert during an active rare hunt (starts when you route a rare, ends when the route is done). False positives from treasures/events are gone (kill-vignette filter + npcID matching).
- **Weekly shard cap alert:** one clear popup (with its own ready-check sound) the moment a character hits 600/600 Coffer Shards for the week — stop farming, go do something fun. `/mh shardtest` previews it.
- **"After the reset" routine on Home** now understands low-level characters: quest givers show "available from level 90" instead of sending you to an NPC with nothing to offer, Halduron's leveling weekly is tracked, and profession weeklies respect your skill level.

### Fixed

- **Ritual Sites intro hint is step-aware:** it now shows exactly which of the five intro steps is next (robust against Blizzard's out-of-order quest flags) instead of always pointing at Lilatha.
- **Vordaza (Maisara Caverns):** corrected dangerous advice — kill the Unstable Phantoms before they reach anyone; do not touch them.
- **Herbalism/Mining 101:** corrected the Overload mechanic description (12h cooldown reduced by gathering, not a 30-minute cooldown).
- **Delves guidance:** Start Here and the weekly hints now mention that Delves are capped at Tier 3 below level 90.
- **Dungeons 101 chapter 3:** arrow glyph no longer renders as a box.
- **Shard cap alert:** the once-per-week marker is only set when the popup actually shows (a /reload could previously swallow it).

## [1.6.0] - 2026-06-10

### Fixed

- **Ritual Sites:** Daggerspine Point Curious Obelisk waypoint **37.59, 65.20** (was 34.9, 65.4).
- **Main window:** programmatic resize (Delves min-height, saved size apply) no longer sets `mainWindowUserSized`, so auto-sizing still works until you drag the grip.
- **Account snapshot:** vault progress is not overwritten with zeros on login before `C_WeeklyRewards.GetActivities` loads; previous vault values and `ts` are kept until a real refresh.
- **Vault Advisor:** no Lua error on low-level / spec-less characters (title falls back to `?`).
- **Travel Assistant:** Hearthstone secure button uses `/use item:6948` so it works on non-English clients.
- **Delve bounty toast / Vault Advisor:** forward-declaration fixes for `GetItemIcon` and `GetItemIDFromLink` (avoids nil global calls on 12.x).
- **Weekly reset timing:** Account snapshot and Vault Reminder use `C_DateAndTime.GetSecondsUntilWeeklyReset` via `ns.MhGetWeeklyResetAnchorTs()` (region-correct; US Tuesday / EU Wednesday at server reset) instead of hardcoded local Wednesday 08:00.
- **Toasts:** hide timer uses `C_Timer.NewTimer` so dismissing one toast early no longer fades out the next queued toast.
- **Main window:** opening the Delves tab no longer forces height to 800px on every switch; content scrolls in the existing Delves ScrollFrame.
- **Search bar:** Codex topic search (`vault`, `weekly`, `delve`, `dawncrest`, etc.) runs before Guide/SMC routing — the old `MH_RunSearchQuery` wrap in Midnight Codex was overwritten by Guide.lua at load time and never ran. Typo-tolerant second pass for longer keywords (e.g. `dawncreast` → Dawncrest).
- **Vault Reminder:** after claiming vault rewards, the reminder button clears immediately for the logged-in character (live `C_WeeklyRewards.HasAvailableRewards` is authoritative; stale snapshot no longer keeps "ready").
- **Alt Overview:** characters without a vault snapshot timestamp (`ts == 0`) no longer show a false "likely claim" status.
- **Consumables:** fixed mistranslated spec-cycle hint in German, French, Spanish, and Brazilian Portuguese (`CONS_SPEC_HINT`; German had literally "bicycle specifications").
- **Toolbox — Professions — Generate Route Treasures/Books:** dynamic TomTom arrow to the nearest remaining pin with auto-advance, region gate, and hearthstone/portal travel advice via the shared travel assistant.
- **Void & Rituals — Ritual Coach:** removed misleading per-run unlock tags (obelisk learn/unlearn is selection, not permanent unlock).

### Improved

- **Midnight Codex:** four **12.0.7** articles (Showdowns, Sporefall, Omnium Folio, Turbulent Timeways) in all six locale packs (`CODEX_127_*`).
- **12.0.7 prep:** `ShowdownsData.lua` — PTR-verified Naigtal ids (uiMapID 2600, weekly 96717, Riftstalker's Cache 275690); Val placeholders until next rotation. See `docs/PTR_12.0.7_DATA.md`.
- **12.0.7 prep:** PTR-verified Silvermoon Showdown portal (**2393, 47.93, 48.09**); two more Naigtal rare NPC ids in `docs/PTR_12.0.7_DATA.md` (Warbringer Thal'kuur, Auredar's Chassis).
- **12.0.7 prep:** `docs/PTR_12.0.7_DATA.md` §3b — instructions for collecting rare coords and kill-quest IDs before adding Showdown rares to `Rares.lua`.
- **Account weekly checklist:** Showdown weekly line for the current character on 12.0.7+ clients (build-gated; hidden when zone weekly ID is unknown).
- **World tab — Showdowns (12.0.7):** new section under Void Assaults (active rotation, weekly progress, world boss, Heroic World Tier in-zone, Maella waypoint). Hidden on clients below interface 120007; portal button stays hidden until Voidstorm map ID is verified.
- **Professions tab:** BAG_UPDATE / QUEST_LOG_UPDATE refreshes are debounced (max one panel refresh per 0.2s) so looting or quest hand-ins do not trigger a burst of redraws.
- **Professions tab:** Enchanting characters see weekly disenchant material bag counts (Swirling Arcane Essence 0–5, Brimming Mana Shard 0–1) in the currency summary.
- **Midnight Codex:** article blocks are pooled and reused on refresh (AcquireRow-style pattern), so Currencies live updates no longer create new frames on every `CURRENCY_DISPLAY_UPDATE`.
- **Sidebar:** Home is listed first in the This Week section (matches the default tab).
- **Layout:** shared `ns.UI_METRICS` insets for Home and Codex panels (prep for tab consolidation).
- **Main window:** resize cap scales up on large displays (up to 1400×1200, bounded by screen size); verified at 1400px width on UI scale 1.35.
- **Toolbox — Consumables:** click an item row to copy its name for the Auction House (repeated clicks cycle alternates); tooltip hint on item hover.
- **Travel Assistant:** Mage **Teleport: Silvermoon City** and **Portal: Silvermoon City** buttons in the travel popup; `ShowTravelAssistFor` is reusable for treasure routes and other waypoints.
- **Toolbox — Professions:** treasure/book tracker grouped by zone; generate buttons renamed and localized (`Generate Route Treasures` / `Generate Route Books`).

### Changed

- **TOC:** `## Interface: 120005, 120007` for live + 12.0.7 PTR; drop `120005` from the TOC once 12.0.7 is live (see `RELEASE_CHECKLIST.md`).
- **Sidebar (13 tabs):** **Toolbox** merges Macros, Consumables, and Role Academy (sub-tabs under Guides). Legacy tab ids (`macros` / `consumables` / `academy`) still route via `SelectTab` for Guide and Codex navigation. Beta Settings checkboxes gate the Macros and Academy sub-tabs.
- **Sidebar (12 tabs):** **Reference** is now a **Midnight Codex** category (embedded Reference guide with Dawncrest / Professions sub-tabs). `SelectTab("reference")` still works via alias. Reference beta checkbox gates the category button.
- **Keybinding:** internal binding id is now `MIDNIGHTHELPER_TOGGLEMAIN` (was generic `TOGGLEMAIN`, collision-prone across addons). Default **Alt+M** is unchanged; if you set a **custom** key for Toggle main window, re-bind it once under **Keybindings → Midnight Helper**.
- **Interrupt macros:** replaced the old focus-swap macro with **Focus** and **Mouseover** variants (one spell table, generated per spec). If you copied the old macro into your action bars, copy the new text from **Toolbox → Macros → Interrupt**.
- **Professions panel:** moved from the sidebar into **Toolbox** (legacy `SelectTab("professions")` and search still route there).
- **Toolbox — Professions:** one hub sub-tab with **Overview**, **Treasures & Books**, and **Course (101)** inner tabs (legacy `professions` / `profacademy` ids still route to the matching inner tab).
- **Professions panel — Generate Treasures/Books:** TomTom waypoints now follow a shortest-hop route per zone (greedy chain from your position or the first pin), grouped by map.

### Added

- **Home — "After the reset" routine:** ordered per-character to-do list at the top of Home (claim the Great Vault, weekly quest givers next to the vault, Ritual/Void weeklies at the Bazaar hub, profession trainer weeklies) with live status colors (to do / picked up / done / locked) and a one-click **TomTom route along the open stops** (vault → quest givers → hub → trainer).
- **Weekly quest givers tracked:** Lady Liadrin's Spark weekly (choice of four), Halduron Brightwing's dungeon-of-the-week, and Aethas Sunreaver's event weeklies show real per-NPC pickup/done status.
- **Profession trainer weeklies — all 11 professions:** the Professions Hub "This week" block and the reset routine now track every profession's weekly trainer/service quest (including rotating variants for Enchanting and the gathering professions).
- **Account snapshot — per-slot vault detail:** hover a character's vault column to see, per World/Dungeon/Raid slot, the **item level of the reward currently locked in** (Blizzard's own example reward) and the registered tier — so on an alt you instantly know whether higher delves or rituals are still worth running this week.
- **Void & Rituals — two views:** "This week" (currencies, active sites, weekly status with live progress %, route buttons, compact challenge list) and "Ritual Coach" (full reference: scenario notes, how-it-works, challenge mechanics and unlocks, party share). Your choice is remembered.
- **Void & Rituals — live weekly progress:** the Void Assaults zone weekly shows its "Strikes disrupted" percentage live; same for the Ritual weekly when it exposes a progress bar.
- **Ritual weekly intro hint:** characters that have not finished the per-character intro questline ("Ranger Captain's Summons" chain) see exactly that, instead of a misleading "pick it up at the hub".
- **Ritual Coach — site intel completed:** Broken Throne scenario ("A Corrupted Path" — Faithbreaker Ger'lok), Dark Obelisk locations for **both** sites, verified Tainted Bone Pile spots, and recommended item levels per tier (T1 215 → T5 264).
- **Home — World boss route button:** one click sets a TomTom waypoint to the active world boss.
- **Localization:** Ritual Coach, Start Here, the route buttons and all new strings above are fully translated in all six languages (English, Nederlands, Deutsch, Français, Español, Português).
- **Delve party share v2:** receivers with a different chat locale get tips re-rendered locally via addon message (`MHDelve` prefix); plain chat text remains the universal fallback. Solo test mode whispers the descriptor to yourself.

### Added (verify on second PC before CurseForge release notes)

- **PTR sync:** `Sync-MidnightHelper-PTR.bat` copies the working tree to `_ptr_` / `_xptr_` installs (excluded from CurseForge zip).
- **Keybinding (1.5.5):** **Keybindings → Midnight Helper → Toggle main window** — same as `/mh`; default **Alt+M**; Stream Deck hotkey OK. *Not in CF changelog until confirmed.*
- **Toolbox — Professions 101:** beginner profession course (seven chapters, per-character progress, class-based profession advice, Enchanting/Alchemy starter chapters when owned, KP tree summary when spec data is available). Work Order station waypoint at Captain Flaresworn.
- **Toolbox — Professions 101:** starter chapters for all eleven Midnight professions with trees (Tailoring through Skinning); only chapters for professions you have are shown.
- **Toolbox — Professions 101:** Tree Advisor shows live next-root advice per owned profession (purchased ranks, repeated under the choosing-trees chapter).
- **Toolbox — Professions 101:** new **Gear up** chapter (tools, stations, Midnight tier, first recipes) with auto-detect when profession tools are equipped (slots 20/23).
- **Toolbox — Professions Hub:** **This week** block on Overview (trainer weekly quest flag per known profession, Enchanting disenchant mat bag counts).
- **Toolbox — Professions Hub:** Tree Advisor v2 — per-character advice goal (Allround / Gold / Self-sufficient) with goal-specific routes and hover tooltips on the goal buttons.
- **Toolbox — Professions Hub:** trainer weekly unlock hint when not yet available; optional accessory-slot tip on Overview (slots 21/22/24/25).
- **Void & Rituals — Ritual Coach:** scenario tips and challenge picker (sorted by Spoils) with party share (`MHRitual` cross-locale sync) and ritual weekly hints (locked / pickup / in-progress).
- **Start Here:** new-player roadmap tab with weekly progress ticks and navigation into existing tabs.

### Fixed

- **Combat lockdown:** rare-spotted toast no longer triggers `ADDON_ACTION_BLOCKED` (`SetPropagateMouseClicks`) when your first toast of the session fires mid-combat — the toast frame is now created at load time.
- **Vault reminder popup:** closes itself after you click the waypoint button (the arrow takes over).
- **SMC city guide — World boss button:** shows the boss name whenever it is known (live, cache, or kill data); only a pure rotation guess gets an "open map to confirm" suffix.
- **Font rendering sweep:** characters the game fonts can't render (checkmark in the Dawncrest done-line, unguarded arrow glyphs, invisible zero-width spaces from old machine translations) replaced or removed across all six languages; a handful of garbled machine-translated strings rewritten.
- **Keybindings:** appear under **Midnight Helper** (not Other); binding uses `SlashCmdList` (not Other / broken direct call).
- **Keybindings:** `Bindings.xml` not listed in `.toc` (avoids Unrecognized XML warnings).

## [1.5.3] - 2026-06-03

### Fixed

- **World boss weekly status** no longer shows last week's kill as done after reset (only the active boss this week; clears stale SavedVariables; uses Blizzard weekly reset time).
- **World boss** login error fixed (`attempt to call a nil value` in cache cleanup).
- **Packaging:** CurseForge zip excludes dev files (`Sync-MidnightHelper.bat`, scripts); build fails if any slip through.

## [1.5.2] - 2026-06-02

### Fixed

- **Delve story tooltip hook** no longer registers on every tooltip type (e.g. **UnitAura** from nameplate addons). Fixes `secret number` compare errors in delves when addons such as **Platynator** show aura tooltips.
- **POI ID** handling uses `canaccessvalue` / safe tonumber before matching delve map POIs.

## [1.5.1] - 2026-05-30

### Added

- **Midnight Codex** (beta sidebar tab): handbook with **Start Here**, weekly loop, currencies, delves, dungeons, raid, world content, and professions — each article links to the relevant addon tab. Toggle in **Esc → AddOns → Midnight Helper** (beta tabs).
- **Live currency balances** in Codex (with snapshot fallback) and **Blizzard tooltips** on currency titles and icons.
- Global search keywords (`codex`, `wiki`, `start here`, `currency`, …) open the Codex.
- **Delve weekly trackers** on Home: Trovehunter's Bounty, Gilded Stash (T11+ bountiful), and Special Assignments with account alt rollup.

### Changed

- Codex moved into the **beta** sidebar block (between Professions and Consumables) with its own settings checkbox.
- Codex **Open** buttons use correct destinations (e.g. Dawncrests → **Basics**, Great Vault → **Delves & Vault** section).

### Fixed

- **Trovehunter's Bounty** on Home / Account: no longer shows “looted — use it!” unless the map is actually in your bags.
- **Delve Coach**: auto-select active boss in multi-boss delves; session-only carousel browse without sticking preview state; live delve **boss 3D preview** and story-variant detection (map tooltip, Grudge Pit / Arena Champion fallbacks).

## [1.5.0] - 2026-05-29

### Added — Home "This Week" dashboard

- New **Home** tab that opens by default: weekly reset countdown, account-wide Great Vault status, world boss this week, weekly chores (SMC, keys, shards), and a quick shortcut to Rares.

### Added — Rares tab

- **Rares** tab with per-character weekly tracking. Pick the nearest incomplete rare or build a full **route** (nearest-neighbour ordering).
- Distances use **world coordinates (yards)** so the route truly starts at the closest rare and works across maps.
- **TomTom** integration: the "crazy arrow" stays locked on the nearest waypoint instead of jumping to the last one added.

### Added — Live rare-nearby alerts

- Audible alert + on-screen toast when a tracked rare is detected near you, **even with the main window closed** (uses `C_VignetteInfo`).
- Distance-gated (~500 yds) so you are not pinged for rares across the zone; a far rare still alerts once you get close.
- Clicking the toast adds the rare as an **extra** TomTom waypoint (arrow points to it) **without clearing** a route you are already following.
- Toggle in **Esc → AddOns → Midnight Helper**.

### Changed

- Sidebar tabs grouped into labelled sections; **Reference** tab renamed to **Basics**.
- Main window enforces a dynamic minimum height so the new tabs never overlap the About button.

## [1.4.3] - 2026-05-27

### Changed — World boss

- Moved from SMC City Guide to **Delves & Vault** tab (top of panel).
- Warband kill stored in SavedVariables so alts show done without re-opening the map.
- Compact single line when warband already finished (~18px, no empty gap).

### Fixed

- TomTom button uses fresh state (no stale “open map” after UI already shows the boss).
- Alt shows “warband done (CharacterName)” when another character completed the boss.

## [1.4.2] - 2026-05-27

### Fixed — World boss (SMC City Guide)

- TomTom button always re-checks live/cache state (no stale “open map” after UI already shows the boss).
- Compact one-line row when the warband already completed this week's boss (shows character name).
- Account-wide week cache: once any character finds the boss, alts use it without opening the map.
- Background scan on login scans zone map data automatically.

## [1.4.1] - 2026-05-27

### Added

- **SMC City Guide — World boss this week:** shows the active Midnight Season 1 boss (Lu'ashal, Cragpine, Thorm'belan, or Predaxas), warband kill status, and a **TomTom** button with Travel Assistant for cross-zone routing.

## [1.4.0] - 2026-05-27

*First CurseForge upload after **1.3.2**.*

### Added — Great Vault Advisor

- **Great Vault Advisor** side panel on Blizzard’s Great Vault loot screen: ranks vault choices vs. your equipped gear (item level, guide stat weights, tier sets).
- **Auto / Raid / M+** stat profiles (Auto picks raid vs. M+ weights from vault slot type).
- Optional **Pawn** integration when installed.
- Advisor strings and settings in **Esc → AddOns → Midnight Helper** (all six UI languages).
- Hero-talent-specific stat weights for supported specs (Icy Veins–sourced catalog).

### Added — Beta sidebar tabs

- **Beta** tab group in the sidebar (between Professions and Consumables): **Guide** (reference), **Leveling Guides**, **Macros**, **Role Academy** — each with a Beta badge and tooltip.
- Per-tab and master toggles in addon settings (`Show beta tabs in sidebar`).

### Added — Vault reminders (settings)

- Great Vault reminder options in addon settings: chat summary, minimap ping, login popup (localized).

### Changed

- Sidebar layout: beta block separated; macros no longer duplicated at the bottom of the tab list.
- Vault Advisor panel layout and Blizzard vault UI hook polish; duplicate advisor on Delves tab removed.

### Fixed

- Beta tab settings checkboxes no longer cause Lua errors (`RefreshBetaTabVisibility` nil `self`).
- Vault Advisor Blizzard banner / claim UI edge cases from earlier 1.4.0 dev builds.

## [1.3.2] - 2026-05-23

*First CurseForge upload after **1.3.0** — bundles everything that landed on `main` since then (including work that was tagged 1.3.1 in git only).*

### Added — Localization

- **Six UI languages:** English, **Deutsch**, **Français**, **Español**, **Português (BR)**, and **Nederlands** (NL is addon-only — use `/mh lang nl`).
- **`/mh lang auto`** follows your WoW client when a pack exists (`de`, `fr`, `es`, `pt`, `en`; `esMX` → Spanish pack).
- Translated **Delve Coach** tips, **Leveling Guides** advisor + gear notes, consumable notes, and guide groups for DE / FR / ES / PT / NL (not only EN/NL anymore).
- Minimap broker language picker updated for all packs.

### Added — Features

- **Valeera curio advisor** on the Delves tab and popup at repair / gossip NPCs.
- **Delve consumables:** per-delve session tracking, “active” state, `/mh items mark` and `/mh items reset`; secure item-click buttons.
- **Bounty toast** reminder when Trovehunter's Bounty is available in a delve.
- **Leveling Guides — In groups** tab: interrupt priority, defensives, and party tips by role (level brackets 10 / 30 / 60 / 80).
- Leveling Guides **Layout** sub-tab: ISO keyboard prototype (Midnight key highlights).
- **SMC City Guide** weekly/hub checklist; waypoint buttons tint green when quests are done (configure IDs in `Modules/SMCChecklistData.lua`).

### Changed

- Delve consumable minimap icons and popup behaviour polished for Midnight secure rules.
- Delves panel layout and localized delve names improved.

### Fixed

- Delve consumables popup: no Lua errors on use or `/mh items mark`; no forbidden `COMBAT_LOG_EVENT_UNFILTERED` registration on Midnight.
- Delve party chat fallbacks where needed for client font/locale edge cases.

## [1.3.1] - 2026-05-24

*Git-only tag between CF 1.3.0 and 1.3.2 — not published separately on CurseForge.*

### Added

- Valeera curio advisor; delve consumables session tracking; bounty toast (see **1.3.2** notes above).

## [1.3.0] - 2026-05-19

### Added

- **Delve Party Share:** send Delve Coach tips to party, raid, or instance chat (brief, boss, sections, copy dialog). Recipients do not need this addon. **Test (/say)** on Delve Coach for solo testing.
- **Delve items popup:** quick-use panel for **RAID-R Mini** (244193) and **Trovehunter's Bounty** (252415) when you carry them in a delve.
- **Minimap launchers** for those items (left-click opens popup, right-click uses item) — visible **only during an active delve**.
- **Delve Coach:** Shift + mouse wheel scales the whole panel (like the main Midnight Helper window). Resize via corner grip, bottom bar, or right edge; mouse wheel scrolls tip text.
- Party-share chat lines with **spell hyperlinks** (EN/NL).

### Changed

- Delve items UI auto-shows when entering a delve (retries until `IsDelveInProgress` is true). Closing the popup suppresses auto-show until the next delve.
- Boss spotlight: more reliable first-load preview, loading text no longer hidden behind the model, saved zoom per boss.

### Fixed

- Party share only sends when you are in a real group (avoids Blizzard “You aren't in a party” spam when solo).
- Delve Coach “More” share menu, share API wiring, and assorted open/layout edge cases from 1.2.6 testing.

### Note

- Major feature release for CurseForge. Small follow-up patches may use the **Valeera** codename in release notes.

## [1.2.6] - 2026-05-21

### Added

- **Delve Coach:** floating in-delve tips panel for all **11 Midnight Season 1 delves** (Overview, Route, Trash, Boss).
- **English and Dutch** tip text (`/mh lang en` / `/mh lang nl`); locale validation for every delve section.
- **Boss spotlight:** 3D creature preview with prev/next; **mouse-wheel zoom** per boss (saved per character).
- **Blue spell hyperlinks** in tips (hover/click for spell tooltips where IDs are known).
- **Preview** from Delves tab (“Delve Coach (preview tips)”) and `/mh coach`; auto-show when entering a delve (optional).
- Resizable, draggable coach window with minimize.

### Fixed

- Boss model camera framing and `SetLight` crash on `PlayerModel`.
- GameTooltip `SetText` signature on boss zoom hint (retail API).

## [1.2.5] - 2026-05-20

### Added

- **Role Academy** tab: tank and heal tracks (mindset, prep, triage, anxiety ladder from delves → dungeons/raids).
- Quick links to Macros, Consumables, Leveling Guides, and Delves from the academy panel.
- Search routes keywords such as `tank`, `heal`, `academy`, and `mentor` to Role Academy.

## [1.2.4] - 2026-05-20

### Added

- **Great Vault reset reminders:** chat on login, minimap tooltip lines, pulsing minimap icon (toggle in minimap quick settings).
- **Blizzard map waypoint fallback** when TomTom is not installed (delves, profession pins, bountiful finder, portal step).
- **Account snapshot:** profession weekly currencies in row tooltip (Abundance, Dundun shards, Moxie summary).

### Changed

- Account snapshot: sort/filter toolbar, level/ilvl, stale-since-Wednesday badge, Untainted Mana-Crystals column.
- Guide search routes consumable keywords to the Consumables tab; multi-word queries improved.

## [1.2.3] - 2026-05-19

### Fixed

- **Travel Assistant (Delves):** no longer suggests Hearthstone when you are already near a delve entrance or after you enter the delve; zone changes no longer re-open the travel popup.
- **Bountiful delve routing:** fixed a Lua error when calculating distance to the waypoint (`GetWorldPosFromMapPos` return value).

### Added

- **Consumables** sidebar tab (Wowhead-backed lists per spec, with guide search preview).

### Changed

- Clearer **TomTom** guidance (EN/NL): TomTom is recommended for the map arrow; Travel Assistant (Hearthstone / hub portals) works without TomTom. Info drawer, tooltips, travel popup hint, and chat messages updated.

### Note

- Minor drop-in update — safe to install over 1.2.2.

## [1.2.2] - 2026-05-16

### Added

- **Macros** tab: per-spec team interrupt macro plus utility macros (cursor / mouseover / focus), EN and NL descriptions.
- Guide search **preview** drives keyboard layout and macros for another class/spec without relogging.
- Guide search chat and strings respect `/mh lang en` or `nl`.

### Changed

- Midnight key layout roles (interrupt on E, overflow Alt / Shift / Ctrl).

### Note

- Addon is still actively evolving; expect ongoing tweaks and improvements.

## [1.2.1] - 2026-04-30

### Fixed

- Main window gold dialog frame: inner layout stays inside the border art so corners no longer look clipped; removed the transparent gutter along the bottom and right edges (resize grip still works and draws on top).

### Changed

- Info and About buttons restored to standard `UIPanelButtonTemplate` styling with the same chrome tint as the search row, matching other sidebar controls.

## [1.2.0] - 2026-04-29

### Changed

- Leveling guide consumables use Midnight Wowhead-backed item ID priority lists (feasts, food, flasks, potions, oil where relevant, runes); Death Knight keeps Runeforging (no weapon oil).
- Guide gear tips aligned with Stat priority where wording conflicted (including Beast Mastery Hunter and several other specs).
- Shadow Priest / Elemental Shaman guide data fixes (gear keys).

## [1.1.0] - 2026-04-29

### Added

- Delves and Great Vault dashboard improvements.
- Alt overview with per-character currencies (keys, shards, undercoins).
- Localization support for English and Dutch text flow.
