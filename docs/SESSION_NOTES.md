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

## Open / volgende stappen

1. **12.0.7 content** (release ~16 juni, mogelijk 30 juni): Void-zones Naigtal & Val + Escalations (VoidAssaults/WorldContent), world boss Nexus-Captain Leth'ir + Heroic World Tier (WorldBoss), Omnium Folio/Runes weekly (checklist + Codex), Sporefall raid (Codex/vault), Great Vault tooltip-rework verifiëren op PTR. Bij release: `120005` uit TOC.
2. **Backlog (laag, uit review):** Profession.lua event-debounce (BAG_UPDATE/QUEST_LOG_UPDATE); Bindings.xml → `MIDNIGHTHELPER_TOGGLEMAIN`; `SetVaultReminderOption` popup-backfill voor upgraders; dode branch VaultAdvisor.lua ~176-181; VaultReminder.lua:123 `isCurrent`-conditie; `ts==0` guards AltOverview ~1192/1222; SMC-grid reflow; info-drawer inline; search-UX; compact-mode double-shrink.
3. **Reviewpunt:** ts vs aparte `vaultTs` bij login-restore (Fase 1-tradeoff, Cursor akkoord met huidige aanpak).
