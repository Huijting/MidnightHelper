# Session Notes — Claude (Cowork) × Cursor samenwerking

Laatst bijgewerkt: 2026-06-06. Doel: context-overdracht tussen Cowork-taken en Cursor.

## Werkafspraken

- **Cursor coördineert git** (commits/push). Claude levert uncommitted diffs + per fix: bestand, regels, in-game test.
- Eén schrijver tegelijk; altijd `git status` checken voor beginnen.
- Geen CurseForge-release zonder expliciete vraag van Rob.
- Vault-enum mapping (`[1]=dungeon, [3]=raid, [6]=world`) is **correct** (Enum.WeeklyRewardChestThresholdType: None=0, Activities=1, RankedPvP=2, Raid=3, World=6) — niet "fixen".

## Gedaan

### Fase 1 (commit `47103b1`) — bugs
- `userSized`-guard: `ns._mhProgrammaticResize` rond programmatic resizes (UI.lua)
- Login-snapshot guard: `prev` vóór table-replace; vault-velden + `ts` uit prev bij `not dataLoaded` (AltOverview.lua)
- Spec-nil guards (VaultAdvisor.lua ~1326/~1629)
- Hearthstone `/use item:6948` (Delves.lua)
- Forward-decl fixes: `GetItemIcon` (DelveItemsPopup.lua), `GetItemIDFromLink` (VaultAdvisor.lua) — Lua lexical scoping, géén false positives

### Fase 2 (gecommit) — consistency
- Reset-anchor gecentraliseerd: VaultReminder + AltOverview delegeren naar `ns.MhGetWeeklyResetAnchorTs()`; `IsResetDayNow` via `GetSecondsUntilWeeklyReset() > 6*86400` (regio-correct)
- Toast: `C_Timer.NewTimer` + `handle:Cancel()` (MidnightToast.lua)

### Fase 3a (gecommit) — layout/performance
- Delves-venster springt niet meer naar 800px (UI.lua, SelectTab)
- Codex frame-pooling: `AcquireArticleBlock`/`ApplyArticleToBlock` + pool-vriendelijke `AttachCurrencyTooltip` (MidnightCodex.lua)

### Fase 3b (commit `e24d148`) — polish + PTR
- Home eerste sidebar-tab; `ns.UI_METRICS` (sidePad/topPad/sectionGap/scrollGutter); `UpdateMaxWindowBounds()` (cap → max 1400×1200 op grote schermen)
- TOC: `## Interface: 120005, 120007`; `Sync-MidnightHelper-PTR.bat`; RELEASE_CHECKLIST-notitie
- PTR 12.0.7 smoke-test: geen fouten

### Fase 3c (commit `2a35c8f`) — Toolbox-tab
- Macros + Consumables + Academy → één "Toolbox"-tab met sub-tabs (patroon: Addons-host). 15 → 13 tabs.
- Panels blijven onder oude ids in `ns.panels`; `SelectTab` heeft legacy-alias (macros/consumables/academy → toolbox+sub) zodat Guide.lua/Codex-navigatie ongewijzigd werkt.
- Beta-gating macros/academy verplaatst naar sub-tabs (`RelayoutToolboxSubNav`, fallback Consumables). Nieuwe locale-key: `TAB_TOOLBOX` (6 talen).

### Fase 3d — Reference → Codex (commit na `2a35c8f`)
- Reference is een Codex-categorie geworden (`reference`, label `TAB_REFERENCE`): het volledige ReferenceGuide-panel (eigen scroll + Dawncrest/Professions-subtabs) wordt embedded in een host-frame binnen het Codex-panel; artikel-scroll en host wisselen per categorie. 13 → 12 tabs.
- `SelectTab("reference")`-alias → codex + categorie; `NavigateFromCodex`-branch en Codex-artikelen (dawncrest/professions) werken ongewijzigd.
- Beta-gating: categorieknop verbergt via `betaKey` in `CODEX_CATEGORIES`; `RefreshCodexPanel` bounce't een uitgeschakelde opgeslagen categorie naar Start. Geen nieuwe locale-keys.
- Nieuwe publieke accessors: `ns.GetActiveCodexCategory` / `ns.SetActiveCodexCategory`.
- Zoek-fix: `runSearchFromBar` roept `TryCodexSearch` eerst aan; fuzzy pass 2 voor typos; dode `MH_RunSearchQuery`-wrapper verwijderd/gedocumenteerd.

### Fase 4a — 12.0.7-voorbereiding (commit na `05adf8d`)
- Vier Codex-artikelen (Showdowns/Sporefall/Folio/Timeways) in `MidnightCodexData.lua` + alle 6 locales (keys `CODEX_127_*`).
- Zoek-fixes: al in commit `05adf8d` (Codex-voorrang + fuzzy matching).
- `Modules/ShowdownsData.lua` (nieuw, in TOC): data-only module. PTR-verified: Naigtal uiMapID **2600** (hele zone), weekly **96717**, zijquest 96054, `hasWorldTier=true`, HWT zonder unlock (2 opties bij portaal), WQ's via `C_TaskQuest.GetQuestsOnMap(2600)` (niet hardcoden). Val: nil-TODO's tot volgende rotatie.
- `docs/PTR_12.0.7_DATA.md`: live checklist met /dump-commando's; punten 1/2/6 (deels) ✅. Open: rares, Riftstalker's Cache-ID, Voidstorm-mapID, Mote-ID (Folio), Val-data, Rotmire-vault-check.
- Research-feiten: Leth'ir npc 263843/quest 96472, Pertinax 263670, Rotmire 254176 (raid zone 16279, ilvls 259/272/285/298, mythic flex 15-25), Folio week-1 quest 96410, Timeways 30 jun-11 aug (mount item 258884, ach 61463, 4 weken), Darkspear Dash event 1793 (27-28 jun), API: `GetInstanceInfo` ret11 hasWorldTier, `Enum.TieredEntranceType.WorldTier`, geen C_WeeklyRewards-wijzigingen, C_Club breaking (ClubMemberOpaqueId).

### Fase 4b — Showdowns-UI (commit `fc08697`)

Keuzes (Rob, via vraag): sectie in World-tab (derde blok in WorldContent, na Void Assaults); gating via `select(4, GetBuildInfo()) >= 120007` (PTR zichtbaar, live automatisch bij release).

- **`Modules/Showdowns.lua` (nieuw, 199 regels):** logica + `ns.*`-helpers (geen UI): `IsShowdownsAvailable` (build-gate), `GetActiveShowdownZone` (weekly-questflag, patroon VoidAssaults; zones met nil-weekly matchen nooit), `ShowdownZoneName` (C_Map-naam, fallback `zone.name` voor Val), `IsShowdownWeeklyDone`, `GetShowdownWeeklyProgress` (GetQuestProgressBarPercent, pcall-guarded), `GetShowdownWorldBossStatus` (done=nil als killquest-ID onbekend), `GetShowdownHWTInfo` (in-zone check + `select(11, GetInstanceInfo())`), `RouteShowdownIntro` (Maella-waypoint), `RouteShowdownPortal` (no-op zolang Voidstorm-mapID nil — knop verborgen, "never lie").
- **`Modules/WorldContent.lua`:** Showdowns-sectie (header/actief/volgende rotatie/weekly/boss/HWT + 2 knoppen + 3 infolines) — build regels ~417-467, refresh ~188-262, locale-refresh ~500-502. Alle sd-widgets in `ui.sdWidgets`; refresh SetShown't ze op `IsShowdownsAvailable()` en verbergt daarna conditioneel (nextFs zonder actieve zone, bossFs zonder bossName, hwtFs buiten zone, portalBtn zonder mapID).
- **`Modules/ShowdownsData.lua`:** `name` + `bossName` per zone toegevoegd (locale-onafhankelijke fallbacks; C_Map-naam wint zodra uiMapID bekend).
- **TOC:** `Modules\Showdowns.lua` na ShowdownsData, vóór VoidAssaults.
- **Locales:** 18 nieuwe `SHOWDOWNS_*`-keys in alle 6 talen (na `INFO_DRAWER_BODY_VOID`/`VOID_INFO_SHARED`-blok).
- Syntax: alle gewijzigde/nieuwe Lua-bestanden gecheckt (loadfile, Lua 5.3-texlua). Let op: Cowork-sandbox-mount sync't host-edits onbetrouwbaar — `git status` aan Cursor-kant is leidend.
- **In-game test (PTR 12.0.7, Rob 6 juni): ✅ GESLAAGD** — Showdowns-sectie in Void & Rituals: Naigtal actief + "Next rotation: Val", weekly done (groen), boss-regel Leth'ir "not killed yet", HWT-regel zichtbaar in Naigtal en correct weg in Silvermoon, portaal-knop correct afwezig, Maella-knop routeert netjes (hearth → SWC → waypoint). Geen Lua-errors.
- **Live 12.0.5 (Rob 6 juni): ✅ OK** — sectie verborgen, geen layout-gat, geen errors; ALT-M-toggle werkt. Beide batches klaar voor commit.

### Fase 4c — 12.0.5 backlog-batch (commit `90658a8`)

- **Keybind genamespaced:** `Bindings.xml` → `MIDNIGHTHELPER_TOGGLEMAIN` (was generiek `TOGGLEMAIN`, collision-gevoelig: `BINDING_NAME_*`-globals zijn addon-overstijgend); body roept nu `MidnightHelper_KeybindToggleMain()` aan i.p.v. inline duplicate. `Locales/Locale.lua:249` zet de nieuwe global; locale-table-keys ongewijzigd. **Let op:** bestaande custom keybinds onder de oude naam raken gebruikers kwijt (default ALT-M blijft) — changelog-regel waard.
- **Profession.lua ~910:** event-debounce — BAG_UPDATE/QUEST_LOG_UPDATE-bursts gecoalesced naar max 1 refresh per 0.2s (`C_Timer.NewTimer`, timer-handle-patroon zoals MidnightToast).
- **VaultAdvisor.lua ~176:** dode "dungeon and not raid"-pre-check verwijderd (zelfde uitkomst als de volgende branch; gedrag ongewijzigd).
- **VaultReminder.lua ~118-145:** `snapshotTrusted`-guard — als `C_WeeklyRewards.HasAvailableRewards` bestaat is live leidend voor het ingelogde personage; stale snapshot kon direct na claimen nog "ready"/"likely" tonen.
- **AltOverview.lua ~1244/~1274:** `ts > 0`-guards toegevoegd (ts==0 = "geen snapshot-timestamp", niet "stale"; zelfde guard als regel 246/530).
- Syntax: alle gewijzigde fragmenten + Bindings.xml gecheckt.
- **In-game test (live 12.0.5):** Esc → Keybindings → Midnight Helper: "Toggle main window" zichtbaar met default ALT-M, werkt; Professions-tab open + loot iets / lever quest in → één refresh i.p.v. burst (geen zichtbare lag); Vault claimen → reminder-knop verdwijnt direct na claim (niet pas na snapshot-update); Alt Overview: nieuw char zonder snapshot toont geen onterechte "likely claim"-status.

## Open / volgende stappen

0. **Showdowns vervolg:** AccountWeeklyChecklist-entries (Showdown-weekly + Folio-mote zodra IDs compleet); Home-dashboard kan `ns.GetActiveShowdownZoneName`/`ns.IsShowdownWeeklyDone` hergebruiken; Val-data + Voidstorm-portaal-mapID invullen na volgende PTR-rotatie (knop verschijnt dan vanzelf).

1. **12.0.7 content** (release ~16 juni, mogelijk 30 juni): Void-zones Naigtal & Val + Escalations (VoidAssaults/WorldContent), world boss Nexus-Captain Leth'ir + Heroic World Tier (WorldBoss), Omnium Folio/Runes weekly (checklist + Codex), Sporefall raid (Codex/vault), Great Vault tooltip-rework verifiëren op PTR. Bij release: `120005` uit TOC.
2. **Backlog (laag, uit review):** `SetVaultReminderOption` popup-backfill voor upgraders; SMC-grid reflow; info-drawer inline; search-UX; compact-mode double-shrink. (Debounce, keybind-namespace, VaultAdvisor dode branch, VaultReminder isCurrent en ts==0-guards: gedaan in Fase 4c.)
3. **Reviewpunt:** ts vs aparte `vaultTs` bij login-restore (Fase 1-tradeoff, Cursor akkoord met huidige aanpak).
