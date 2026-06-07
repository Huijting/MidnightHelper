# Session Notes — Claude (Cowork) × Cursor samenwerking

Laatst bijgewerkt: 2026-06-06. Doel: context-overdracht tussen Cowork-taken en Cursor.

## Werkafspraken

- **Cursor coördineert git** (commits/push). Claude levert uncommitted diffs + per fix: bestand, regels, in-game test.
- Eén schrijver tegelijk; altijd `git status` checken voor beginnen.
- **⚠️ Claude/Cowork: NOOIT hele bestanden via de sandbox-mount (her)schrijven.**
  De mount levert soms afgekapte reads; een read-modify-write via script schrijft
  die truncatie dan terug naar de host (7 juni: frFR.lua zo beschadigd, staart
  uit git HEAD hersteld). Host-tools (Read/Edit/Write) zijn betrouwbaar; de
  mount alleen voor read-only checks, en ook dan eof-errors wantrouwen.
- Geen CurseForge-release zonder expliciete vraag van Rob.
- Vault-enum mapping (`[1]=dungeon, [3]=raid, [6]=world`) is **correct** (Enum.WeeklyRewardChestThresholdType: None=0, Activities=1, RankedPvP=2, Raid=3, World=6) — niet "fixen".

## Voor Cursor — review + commit batch 7 juni (commits `605c670` / `19df573` / `705306d`)

Alle onderdelen zijn door Rob live in-game getest (✅ per sectie hieronder).
Voorgestelde opdeling in 3 commits:

1. **Profession Academy (Fase 5 compleet):** `Modules/ProfessionAcademy.lua`,
   `Modules/ProfessionAcademyData.lua` (nieuw, beide), TOC-regels, UI.lua
   (sub-tab), `docs/PROFESSION_ACADEMY_PLAN.md` (nieuw), locales
   (PROFACAD_*-keys + subtitle-rewrite). Omvat: 7 hoofdstukken, voortgang per
   char, prof-detectie, class-advies, tree-state (specSkillLines 2906-2918,
   alleen 2909 in-game geverifieerd — rest Wowhead, faalt veilig), hoofdstuk
   1+2 auto-detectie, events TRADE_SKILL_SHOW/SKILL_LINES_CHANGED/
   TRAIT_CONFIG_UPDATED.
2. **Interrupt-macro's herbouwd:** `Modules/InterruptMacrosData.lua`
   (herschreven: SPELLS-tabel + 2 gegenereerde varianten),
   `Modules/InterruptMacros.lua` (pick-nav gegeneraliseerd, per-type index,
   button-hergebruik), locales (MACROS_INTERRUPT_*). Changelog-regel: oude
   focus-swap-macro vervangen door Focus- en Mouseover-variant — gebruikers
   moeten hun macro opnieuw kopiëren.
3. **Showdowns-data + PTR-doc** (uit iteratie 1): `Modules/ShowdownsData.lua`
   (portalSilvermoon), `docs/PTR_12.0.7_DATA.md` (rares).

Review-punten:
- **Draai zelf luacheck/parse op alle gewijzigde .lua** — de Cowork-mount gaf
  false-positive eof-errors (NUL-padding), host-bestanden zijn leidend.
- **`Locales/frFR.lua` extra aandacht:** was door Claude-script-fout afgekapt
  en is hersteld uit HEAD + host-edits. Check: bestand eindigt op
  `ns._mhLocales.frFR = pack`; in de herstelde staart 4× NBSP → spatie en
  mogelijk LF i.p.v. CRLF (normaliseren mag). Rob hertest Frans in-game nog.
- deDE/esES/ptBR hebben elders nog `\\n` (toont letterlijk "\n" in-game) in
  oude strings — bestaand euvel, los van deze batch (backlog-item).
- BS-treasure-flag discrepantie (89182 vs 80416) staat genoteerd in het plan;
  niet in code gebruikt.

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

### Fase 5, iteratie 1 (commit `605c670` + `19df573`)

**Profession Academy ("Professions 101")** — nieuwe Toolbox-sub-tab (niet
beta-gated, naast Consumables/Macros/Academy):

- **`Modules/ProfessionAcademyData.lua` (nieuw):** 7 hoofdstukken (Knowledge,
  trees, recepten, Moxie, weekly-routine, Enchanting-start, Alchemy-start) +
  Work Order-station-waypoint (2393, 45.0, 55.6 — zelfde coords als SMC-gids).
- **`Modules/ProfessionAcademy.lua` (nieuw, ~330 regels):** scrollende
  hoofdstukkenlijst met per hoofdstuk een praktijkopdracht-checkbox; voortgang
  per character (`ns.db.profAcademy[guid]`); voortgangsteller bovenin; alleen
  TRADE_SKILL_SHOW auto-detecteert (hoofdstuk 1), rest handmatig ("never
  lie"); Flaresworn-waypoint-knop bij hoofdstuk 5; RefreshLocaleUI-hook.
- **UI.lua:** sub-tab-def `profacademy` + builder + info-drawer-branch.
- **TOC:** beide modules vóór ShowdownsData.
- **Locales:** 27 `PROFACAD_*`/`TAB_PROF_ACADEMY`-keys in alle 6 talen
  (inhoud uit docs/PROFESSION_ACADEMY_PLAN.md-research).
- **Showdowns-data bijgewerkt (zelfde batch):** `portalSilvermoon` = 2393,
  47.93, 48.09 (PTR-verified); 4 nieuwe Naigtal-rares in PTR_12.0.7_DATA.md
  (Slaipaan 264576, Interminable Uarn 263947, Swalewing Matriarch 263954 +
  eerder Lomelith). WorldContent kan later een Silvermoon-portaal-knop krijgen
  (RouteShowdownPortal dekt nu alleen Voidstorm) — bewust buiten deze batch.
- Syntax: nieuwe modules + datablokken gecheckt. **Let op: de Cowork-sandbox-
  mount trunceert host-edits → texlua-check op de mount gaf false-positive
  eof-errors voor enUS/nlNL/deDE/frFR/esES/ptBR/UI.lua/ShowdownsData; host-
  bestanden geverifieerd compleet. Cursor: draai zelf even `luacheck`/parse.**
- **In-game test (live of PTR):** `/mh` → Toolbox → "Professions 101":
  7 hoofdstukken zichtbaar, voortgang "0/7"; checkbox togglen werkt en blijft
  bewaard na `/reload`; professievenster openen vinkt hoofdstuk 1 automatisch
  af; Flaresworn-knop zet waypoint; taal wisselen vertaalt alles; voortgang is
  per character (check op alt).

### Review-fixes 7 juni (commit `19df573`)

Uit Robs in-game review van de Fase 5-batch + macrovraag:

- **ProfessionAcademy.lua ~149:** unicode-✓ achter afgeronde hoofdstuktitel
  rendert als blokje in het WoW-font → vervangen door
  `|TInterface\\RaidFrame\\ReadyCheck-Ready:12:12:0:0|t` (zelfde texture als
  Profession.lua `ICON_COMPLETED`).
- **`PROFACAD_CH_KNOWLEDGE_TASK` (6 talen):** "(default key: K)"-hint
  toegevoegd — beginners weten niet hoe het professievenster opent.
- **Interrupt-macro's herbouwd.** De oude focus-swap-macro (focus als
  klembord, `/targetenemy`-gok, `/clearfocus` sloopt bestaande focus, random
  `/startattack`-pull zonder target) miste meer dan hij raakte.
  - **`Modules/InterruptMacrosData.lua` (herschreven):** 14 gedupliceerde
    macro-strings → één `SPELLS`-tabel per class/spec (`false` = geen kick,
    Disc/Holy) + `ns.MH_GetInterruptSpell` en `ns.MH_GetInterruptMacroVariants`
    (2 gegenereerde varianten: Focus `[@focus,harm,nodead][]` en Mouseover
    `[@mouseover,harm,nodead][]`; naam/desc via locale-keys, per call gebouwd
    zodat taalwissel werkt). `ns.InterruptMacrosByClassSpec` vervallen (enige
    consumer herschreven).
  - **`Modules/InterruptMacros.lua`:** pick-nav (was utility-only)
    gegeneraliseerd — type-defs hebben nu `getList`; per-type geselecteerde
    index in `panel._mhMacrosPickIndex[typeId]` (reset bij spec-wissel);
    Interrupt-tab toont nu Focus|Mouseover-knoppen met per-variant
    omschrijving + `MACROS_COPY_SUFFIX`. Bonus: pick-buttons worden hergebruikt
    i.p.v. elke rebuild opnieuw aangemaakt (frame-leak weg).
  - **Locales (6 talen):** 4 nieuwe keys (`MACROS_INTERRUPT_VARIANT_FOCUS/
    _MOUSEOVER`, `MACROS_INTERRUPT_DESC_FOCUS/_MOUSEOVER`);
    `MACROS_INTERRUPT_SUBTITLE` herschreven (beschreef het oude swap-gedrag);
    `MACROS_ERR_EMPTY_SPEC` zonder "focus-swap". Let op: in deDE/frFR/esES/
    ptBR stond `\\n` (dubbele backslash, toont letterlijk "\n" in-game) in de
    oude subtitle — de nieuwe regels gebruiken dat niet meer; rest van die
    bestanden heeft mogelijk hetzelfde euvel (aparte backlog-check waard).
    frFR bevat NBSP's vóór dubbele punten (Edit-tool matcht daar niet op;
    regel via script vervangen).
- Syntax: nieuwe data-module + variant-logica getest met stub-`ns` (mage
  focus/mouseover correct, Disc priest nil, Balance Solar Beam). Mount-
  truncatie gaf opnieuw false-positive eof-errors op alle gewijzigde
  bestanden (NUL-padding in tail) — host-bestanden compleet geverifieerd.
  **Cursor: draai zelf luacheck/parse vóór commit.**
- **In-game test:** `/mh` → Toolbox → Macros → Interrupt: Focus|Mouseover-
  knoppen zichtbaar, wissel update macrotekst + uitleg; juiste spell per spec
  (alt-check); Disc/Holy priest toont nette "geen macro"-melding; Utility-tab
  werkt ongewijzigd; taal wisselen vertaalt knoppen/uitleg; Professions 101:
  groen vinkje-icoon i.p.v. blokje achter afgeronde titel, K-hint zichtbaar.

### Fase 5, iteratie 2 (commit `605c670`) — prof-detectie + spec-advies

Robs review: "MH ziet niet wat we al hebben; en zonder profs zou hij advies
moeten geven wat bij de spec past." Keuzes (Rob via vraag): detectie +
class-advies nu (tree-state/`C_ProfSpecs` ná /dump-verificatie); blok bovenin
Professions 101.

- **`Modules/ProfessionAcademyData.lua`:** `profNames` (EN-fallback per
  skillLineID, 11 profs), `advice` per class-token (armor-logica: plate →
  BS+Mining, mail/leather → LW+Skinning, cloth → Tailoring+Enchanting; whyKey
  per armor-type), `adviceAlt` = Alchemy+Herbalism.
- **`Modules/ProfessionAcademy.lua`:** `GetPrimaryProfessions()`
  (GetProfessions/GetProfessionInfo, nil-slot-proof via `next`),
  `ProfName()` (C_TradeSkillUI.GetProfessionInfoBySkillLineID pcall-guarded,
  fallback profNames), `BuildProfsText()` (profs-regel; bij <2 profs advies +
  alternatief), `IsChapterVisible()` — Ench/Alch-hoofdstukken (skillLineID
  stond al in data) alleen zichtbaar mét die prof; hernummering op zichtbare;
  `CountProgress` telt alleen zichtbare (dus "0/5" zonder profs, "0/7" met
  Ench+Alch). Nieuw FontString-blok tussen voortgang en scroll;
  `SKILL_LINES_CHANGED` ververst bij leren/droppen prof.
- **Locales:** 8 nieuwe `PROFACAD_*`-keys × 6 talen (PROFS_LINE_FMT,
  PROFS_NONE, ADVICE_PICK_FMT, ADVICE_ALT_FMT, WHY_PLATE/MAIL/LEATHER/CLOTH).
- Stub-test (texlua): 2 profs → namen + alle 7 hoofdstukken; 1 prof (alleen
  slot 2) → naam + advies + 6 hoofdstukken; 0 profs → advies + 5 hoofdstukken.
  Bekende nicety: advies kan een prof noemen die je al hebt (1-prof-case) —
  prima, later filterbaar. Mount-truncatie blijft: **Cursor, luacheck.**
- **API in-game geverifieerd (Rob, live):** `GetProfessionInfo` ret7 =
  skillLine (171/182 op Alch/Herb-alt) — detectie klopt. Robs "Tailoring
  ontbreekt" bleek de statische subtitle ("Starter guides: Enchanting &
  Alchemy") die als status las → `PROFACAD_SUBTITLE` herschreven in 6 talen
  ("je eigen professies worden hieronder gedetecteerd; starthoofdstukken
  voorlopig Ench/Alch, meer volgt"). Tailoring-starthoofdstuk = aparte
  research-taak (backlog Fase 5).
- **Tree-state GEBOUWD (zelfde batch).** Plan-vraag 3 beantwoord — Rob
  verifieerde live op zijn main (Ench): child-skillLine **Midnight
  Enchanting = 2909** (via `C_TradeSkillUI.GetChildProfessionInfos()`,
  venster open); `C_ProfSpecs.GetConfigIDForSkillLine(2909)` = 52497993
  (base 333 geeft 0!); tabs 1152 Spellbound Shatterer / 1153 Disenchanting
  Delegate / 1154 Transitories / 1155 Elevating Equipment, alle state 1;
  `C_Traits.GetTreeCurrencyInfo(cfg, tab, false)[1]` = { quantity=27
  (onbesteed), spent=78 } — **identiek per tab, dus profession-breed**;
  `GetRootPathForTab` → nodeID, `GetNodeInfo().activeRank`: 31/1/4/31 bij
  maxRanks 31 — **rank 1 = unlocked maar onaangeroerd, >1 = punten erin**.
  C_ProfSpecs heeft 27 functies (o.a. GetTabInfo met .name).
  - **Implementatie:** `specSkillLines = { [333] = 2909 }` in
    ProfessionAcademyData (alleen geverifieerde IDs toevoegen!);
    `GetSpecSummary()` in ProfessionAcademy (volledig pcall-guarded, nil bij
    config 0/onbekende mapping → regel verschijnt gewoon niet, never lie);
    spec-regel per prof in het blok ("X KP besteed, Y beschikbaar — gestarte
    trees: ..."); hoofdstuk 2 (`trees`) heeft nu `detect = "kpspent"` →
    auto-afvinken zodra spent > 0; auto-hint toont bij elk `detect`-type;
    `TRAIT_CONFIG_UPDATED` ververst (KP uitgeven → blok update live).
    2 nieuwe locale-keys ×6 (PROFACAD_SPEC_LINE_FMT/_SPEC_NONE_STARTED).
  - Stub-test (texlua, Robs echte waarden): "78 KP spent, 27 available —
    Elevating Equipment, Disenchanting Delegate, Spellbound Shatterer" ✓;
    geen mapping → nil ✓; config 0 → nil ✓.
  - ~~TODO child-IDs~~ ✅ **Alle 11 ingevuld** via Wowhead skill-pagina's
    (2906-2918, klopt ook met "Midnight Herbalism"-naam uit Robs alt-dump).
    Bijvangst: Wowhead-comment met ALLE KP-treasure-waypoints + quest-flags
    (89067-89184) → in PROFESSION_ACADEMY_PLAN.md gezet (vraag 7 ✅, goud
    voor concept B). Resterende check: config kan 0 zijn tot
    Specializations-tab één keer geopend is — login-gedrag testen.
  - **In-game test (live, Rob 7 juni): ✅ GESLAAGD** — main: "Tailoring:
    60 KP spent, 6 available — Nimble Needlework, Fiber Arts" + "Enchanting:
    78 KP spent, 27 available — Elevating Equipment, Disenchanting Delegate,
    Spellbound Shatterer", beide direct na login zónder venster te openen;
    teller 2/6 met hoofdstuk 1+2 auto-afgevinkt. **Login-gedrag:** spec-data
    is bij login beschikbaar zodra de spec-tab ooit één keer geopend was
    (Tailoring-regel verscheen pas na eerste keer openen); TRADE_SKILL_SHOW
    ververst nu altijd, dus hoofdstuk-1-opdracht ("open K") maakt het
    self-healing voor verse chars. KP uitgeven → blok update live
    (TRAIT_CONFIG_UPDATED ✅, Rob bevestigd).
- **In-game test (live, Rob 7 juni): ✅ GESLAAGD** — Alch/Herb-alt: blok
  toont "Your professions: Alchemy & Herbalism", teller 1/6 (Ench-hoofdstuk
  verborgen); 1 prof gedropt → blok verspringt live naar advies (geen
  /reload); beide gedropt → "geen professies"-staat + class-advies +
  Alch/Herb-alternatief. SKILL_LINES_CHANGED-refresh werkt. Taal-check: 5
  talen OK; Frans faalde → bleek frFR.lua-truncatie door Claude's
  script-edit via de mount (zie werkafspraak hierboven). Staart (regels
  837-914 HEAD: GUIDE_GEAR/STATS + shouldCopyFromEnUS + pack-registratie)
  uit git HEAD hersteld via host-Edit. Let op in de diff: in de herstelde
  staart zijn 4 NBSP's → gewone spaties genormaliseerd en de aangeplakte
  regels kunnen LF i.p.v. CRLF zijn (cosmetisch; Cursor mag normaliseren).
  Frans-hercheck na /reload nog open.

### Fase 5 (gestart 7 juni) — Profession Academy

Nieuw initiatief: professions begrijpelijk maken voor beginners, pilot
Enchanting + Alchemy. Design + research staat in **docs/PROFESSION_ACADEMY_PLAN.md**
(3 concepten: Academy-hoofdstukken → weekly KP-checklist → Tree Advisor; binnen
MH, geen aparte addon). Bevat geverifieerde systeemfeiten (Moxie nu
prof-specifiek, Ench-KP via disenchanten, KP permanent) én een lijst open
PTR-verificaties incl. kandidaat quest-flags 93528-93543 voor weekly
KP-drops. Cursor: input op het plan welkom bij de volgende review; bouw start
pas na akkoord Rob op fasering.

## Open / volgende stappen

0. **Showdowns vervolg:** AccountWeeklyChecklist-entries (Showdown-weekly + Folio-mote zodra IDs compleet); Home-dashboard kan `ns.GetActiveShowdownZoneName`/`ns.IsShowdownWeeklyDone` hergebruiken; Val-data + Voidstorm-portaal-mapID invullen na volgende PTR-rotatie (knop verschijnt dan vanzelf).

1. **12.0.7 content** (release ~16 juni, mogelijk 30 juni): Void-zones Naigtal & Val + Escalations (VoidAssaults/WorldContent), world boss Nexus-Captain Leth'ir + Heroic World Tier (WorldBoss), Omnium Folio/Runes weekly (checklist + Codex), Sporefall raid (Codex/vault), Great Vault tooltip-rework verifiëren op PTR. Bij release: `120005` uit TOC.
2. **Backlog (laag, uit review):** `SetVaultReminderOption` popup-backfill voor upgraders; SMC-grid reflow; info-drawer inline; search-UX; compact-mode double-shrink. (Debounce, keybind-namespace, VaultAdvisor dode branch, VaultReminder isCurrent en ts==0-guards: gedaan in Fase 4c.)
3. **Reviewpunt:** ts vs aparte `vaultTs` bij login-restore (Fase 1-tradeoff, Cursor akkoord met huidige aanpak).
