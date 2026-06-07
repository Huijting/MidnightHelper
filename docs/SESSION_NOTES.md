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

**STATUS: ✅ AFGEROND** — Cursor review + commits gepusht: `605c670`
(Professions 101), `19df573` (interrupt macros), `705306d` (Showdowns-data),
`95547c4` (notes). Working tree clean. Frans in-game hertest: werkt.

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
- ~~Luacheck~~ ✅ Cursor: lua loadfile op alle 12 gewijzigde .lua OK.
- ~~frFR.lua~~ ✅ eindigt correct (regel 955); **Frans in-game hertest door
  Rob: ✅ werkt.**
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

### Fase 5, iteratie 3 (commit `eeafef7`) — TERUGGEDRAAID + essence-teller

**Les: codebase doorzoeken vóór bouwen.** Claude bouwde een "KP Treasures"-
Toolbox-sub-tab (2 nieuwe modules, 85 treasures met flags 89067-89184 van
Wowhead) — maar **`Modules/Profession.lua` (sidebar Character → Professions)
had dit al**, completer: treasures + boeken (`MIDNIGHT_DATA`, incl. items die
in Claudes bron ontbraken: Vial of Eversong Oddities 89111, Enchanted Sunfire
Silk 89101, Sweeping Harvester's Scythe 89161), Moxie/unspent-KP-regels,
Generate Treasures/Books-knoppen, én een eigen Midnight-skillLine-mapping
(2906-2918). Rob ontdekte de duplicatie bij het testen; keuze (Rob via
vraag): nieuwe tab schrappen.

- **Teruggedraaid:** ProfessionTreasures(.Data).lua verwijderd; TOC-, UI.lua-
  (sub-tab/builder/drawer) en locale-wijzigingen (PROFTREAS_*) gereverteerd.
- **Behouden:** Enchanting essence-teller verhuisd naar Profession.lua —
  na de Shards of Dundun-regel, alleen mét Enchanting: "Weekly disenchant
  mats in bags: Swirling Arcane Essence x/5 · Brimming Mana Shard x/1"
  (items 267654/267655, GetItemQuantityByID, namen via GetItemInfo met
  EN-fallback; locale-key `PROF_ESSENCE_FMT` ×6 — rest van dat panel is
  hardcoded EN, key alvast klaar voor latere lokalisatie).
- **Bijvangst geverifieerd:** Robs LW/Skin-alt toonde identieke vinkjes in
  oude panel en (inmiddels geschrapte) nieuwe tab → flag-IDs 89xxx kloppen.
  Tree-state werkt ook op gathering-profs ("Thorough Tanning, Talented
  Tracker" bij Skinning).
- **Backlog nieuw:** `ProfessionAcademyData.specSkillLines` dupliceert de
  mapping in Profession.lua (`MIDNIGHT_SKILL_LINE_BY_PROFESSION_ENUM`) — ooit
  centraliseren (bijv. ns-level tabel).
- **In-game test:** Professions-panel (sidebar) op Ench-char: essence-regel
  onderaan currency-blok met juiste bagcounts; disenchanten → telt op (panel
  open laten); char zonder Ench → geen regel.

### Fase 5, iteratie 4 (commit `b285e08`)

Robs review-vragen na de iteratie-3-revert: "hoort Professions wel in de
sidebar?" en "geven de Generates de kortste route?". Beide aangepakt:

- **Professions-panel → Toolbox-sub-tab** (patroon Fase 3c/3d): TAB_DEFS-
  entry weg, sidebar Character-sectie = account+delvelog; sub-tab-def
  `professions` (vóór profacademy, niet beta-gated) met no-op builder —
  Profession.lua bouwt ongewijzigd via zijn EnsureMainUI-hook in
  `ns.panels.professions` (CreateToolboxSubPanel registreert onder zelfde
  id). `SelectTab("professions")`-alias toegevoegd (callers: Guide.lua:1160,
  ProfessionsGuide.lua:785 — werken ongewijzigd; ook saved-tab-restore).
  Info-drawer: toolbox-branch → INFO_DRAWER_BODY_PROFESSIONS (key bestond).
  Geen locale-wijzigingen (TAB_PROFESSIONS bestond).
- **Generate Treasures/Books: echte greedy looproute.** Was: sort op afstand
  vanaf startpositie, alleen huidige map (rest ongesorteerd achteraan). Nu:
  pins per map gegroepeerd (zones bijeen), huidige map eerst; per map een
  ketting — start bij speler (huidige map) of eerste pin (andere maps),
  daarna steeds dichtstbijzijnde vanaf het vórige punt. Filter op
  open-items/eigen profs ongewijzigd. `FAR_CROSSMAP_SORT` vervallen.
  Chat-melding: "shortest-hop route". Route-logica getest in texlua
  (speler→dichtbij→buur→ver; tweede map A→buurman→ver ✓).
- Eerder in deze batch (zelfde commit-kandidaat): essence-teller in
  Profession.lua + `PROF_ESSENCE_FMT` ×6 + iteratie-3-revert (zie boven).
- Syntax: host-bestanden compleet geverifieerd (Profession.lua 1223 r.,
  UI.lua 2581 r.); mount gaf opnieuw truncatie-false-positives —
  **Cursor: luacheck/loadfile.**
- **In-game test (live, Rob 7 juni): ✅ GESLAAGD** — sidebar zonder
  Professions; Toolbox-sub-tab werkt; zoekbalk ("kp"/"treasure") en
  Codex-Reference-knop landen op de sub-tab; Generate Treasures: zones
  netjes gegroepeerd (SMC×2 → Voidstorm → Harandar×2 → Slayer's Rise×2 →
  Eversong), melding "shortest-hop route per zone (player position
  unavailable)" = correcte fallback binnen Silvermoon (positie-API geeft
  daar nil; buiten = "from your position"); essence-regel op Ench-main
  zichtbaar onder Shards of Dundun ("Swirling Arcane Essence 0/5 ·
  Brimming Mana Shard 0/1"). Iteratie 6 (alle prof-hoofdstukken): LW/Skin-
  alt toont hoofdstuk 6 LW + 7 Skinning, teller 1/7 ✅.

## Voor Cursor — review + commit batch 2 (7 juni middag, commits `eeafef7` / `b285e08` / `a8074ed`)

Alle onderdelen live getest door Rob (✅ per iteratie hieronder). Voorgestelde
opdeling in 3 commits:

1. **Essence-teller + iteratie-3-revert:** `Modules/Profession.lua`
   (essence-regel), 6 locales (`PROF_ESSENCE_FMT`). Let op: de iteratie-3-
   bestanden (ProfessionTreasures*.lua) zijn aangemaakt én weer verwijderd —
   als git ze niet kent is er niets te doen.
2. **Toolbox-verhuizing + greedy route:** `UI.lua` (TAB_DEFS, sub-tab-def,
   alias, info-drawer), `Modules/Profession.lua` (RunTomTomGenerate
   herschreven, FAR_CROSSMAP_SORT vervallen).
3. **Academy compleet (iteratie 5+6):** `Modules/ProfessionAcademyData.lua`
   (9 nieuwe chapters → 16 totaal), 6 locales (27 nieuwe CH-keys + subtitle
   ×2 herschreven).

Review-punten: luacheck/loadfile op alles (mount gaf wéér false positives);
changelog-regels: "Professions verhuisd naar Toolbox", "Generate-routes nu
shortest-hop", "Professions 101 dekt alle 11 professies", "essence-teller".
Backlog ongewijzigd + nieuw: skillLine-mapping dubbel (Profession.lua vs
ProfessionAcademyData) — ooit centraliseren.

### Fase 5, iteratie 6 (commit `a8074ed`) — ALLE professies in de Academy

Op Robs verzoek: starthoofdstukken voor de resterende 8 professies (LW, BS,
Eng, Inscription, JC, Herbalism, Mining, Skinning) — Professions 101 dekt nu
alle 11 professies met trees. Research via Wowhead-spec-gidsen (12.0.5,
Penguinr2gt, 21 feb 2026) en wow-professions.com (gathering; Wowhead-slugs
voor gathering-specs bestaan niet/CDN-error).

- **Data:** 8 nieuwe chapters (keys `leatherworking`/`blacksmithing`/
  `engineering`/`inscription`/`jewelcrafting`/`herbalism`/`mining`/
  `skinning`, skillLineIDs 165/164/202/773/755/182/186/393) → totaal 16
  chapters (5 generiek + 11 prof, gefilterd op owned).
- **Locales:** 24 nieuwe `PROFACAD_CH_*`-keys ×6 (48 chapter-keys per taal,
  geverifieerd). Subtitle vereenvoudigd ×6: "elke professie heeft een eigen
  starthoofdstuk".
- **Kerninhoud per prof (bron-feiten):** LW: enige bron leather+mail, eerst
  Learned Leatherworker (verlaagt ook Concentration-kosten), één slot-node
  tegelijk. BS: enige plate; The Old Ways = fundamentals; Armor-/Weapon-
  smithing per slot/wapentype; alloys/stones verkopen los. Eng: enige guns;
  Recycling = fundamentals + mats terug; Bits=reagents/scopes,
  Bots=gadgets (namen misleiden). Inscription: centrale Calm Hands-node
  maxen = wekelijkse Treatise +2 KP (uniek!). JC: enige ringen/kettingen;
  centrale Glamorous Gems-node volstaat voor max-kwaliteit Eversong
  Diamonds; Proficient Processor goedkoop; geen Concentration op
  prospect/crush. Herbalism: ~40 Botany-root = mounted gathering (Druid
  slaat over!), dan ~40 Bountiful Harvests; elk kruid in elke zone. Mining:
  ~40 Meticulous Mining-root = mounted minen, dan ~50 Plentiful Ores; erts
  maxen → meer Dazzling Thorium; Over-LODE 30-min-CD. Skinning: Thorough
  Tanning root→leather/scales-tak; Diffusers (motes), Majestic Lures
  (dagelijks zone-beest, epische mats); Finesse- vs Perception-tools.
  Tree-namen LW/Skinning gevalideerd tegen Robs in-game dumps.
- **In-game test (Rob):** main (Tailor+Ench): 7 hoofdstukken zichtbaar;
  LW/Skin-alt: LW- en Skinning-hoofdstuk zichtbaar i.p.v. Ench; teksten
  NL/EN steekproef; teller klopt overal.

### Fase 5, iteratie 5 (commit `a8074ed`) — Tailoring-starthoofdstuk

- Hoofdstuk 8 in `ns.PROF_ACADEMY.chapters` (key `tailoring`, skillLineID
  197 — alleen zichtbaar mét Tailoring, zoals Ench/Alch). 3 nieuwe keys
  (`PROFACAD_CH_TAILORING_*`) ×6 + subtitle bijgewerkt ("Enchanting, Alchemy
  & Tailoring").
- Research (Wowhead tailoring-specializations, 21 feb 2026, Penguinr2gt):
  4 trees — Fiber Arts (fundamentals, alle crafts), Fabric Specialist
  (skill/resourcefulness + cloth-gathering; Otherworldly = Haranir/Voidstorm,
  Eastern Kingdoms = Eversong/Zul'Aman), Sin'dorei Finery (armor per
  slot-groep, sub-nodes unlocken recepten), Nimble Needlework (armor+bolts;
  Sunfire Silk Weaving/Arcanoweaving + Expertise = meer bolts, kortere CD).
  Bolts (Arcanoweave/Sunfire Silk Bolt) achter dagelijkse CD, alleen voor
  gespecialiseerde tailors; tailors enige bron crafted cloth gear. Advies:
  eerste ~30 in Nimble Needlework-root, dan armor (één slot-groep maxen) óf
  bolts (Expertise). Robs main (Nimble Needlework + Fiber Arts) spoort met
  dit advies.
- **In-game test (Rob, main):** Professions 101 toont nu 8 hoofdstukken
  (7 zichtbaar op Tailor+Ench: alle generieke + Ench + Tailoring, geen
  Alchemy); teller klopt; hoofdstuk leesbaar in NL/EN.

## Voor Cursor — review + commit batch 3 (7 juni avond, commits `73f1f36` / `41e4cf1` / `3aa1681`)

Alles live getest door Rob (✅ per iteratie hieronder, incl. volledige
leek-flow op een verse 82-priest). Voorgestelde opdeling in 3 commits:

1. **Tree Advisor v1 (iteratie 7):** `ProfessionAcademyData.lua`
   (advisorRoutes), `ProfessionAcademy.lua` (GetSpecSummary→tabs,
   GetAdviceForProf + BuildAdviceLine, advies in header-blok én onder
   hoofdstuk-2-body, display = gekochte ranks), 2 locale-keys ×6
   (PROFACAD_ADVISE_*). Bevat de forward-decl-fix (GetAdviceForProf vóór
   BuildProfsText — nil-call gevangen door Robs test).
2. **Professions Hub (iteratie 8):** `Modules/ProfessionsHub.lua` (nieuw),
   UI.lua (defs/builders/alias/info-drawer), TOC, 5 keys ×6 (PROFHUB_*,
   INFO_DRAWER_BODY_PROFHUB), `ns.MH_GetProfessionsOverviewText` in
   ProfessionAcademy.lua.
3. **"Gear up"-hoofdstuk + tekst-fixes (iteratie 9):**
   `ProfessionAcademyData.lua` (chapter gearup, detect proftool),
   `ProfessionAcademy.lua` (AllProfToolsEquipped slots 20/23 — in-game
   geverifieerd, PLAYER_EQUIPMENT_CHANGED, auto-tick-loop), 3 keys ×6
   (PROFACAD_CH_GEARUP_*, incl. tier-alinea + lectern/rod-flow) en de
   herschreven PROFACAD_CH_TREES_BODY ×6 (verouderde "Chapters 6 and 7"-
   verwijzing weg).

Review-punten: luacheck/loadfile alles (mount-truncatie blijft);
changelog: "Professions Hub: Overview/Treasures/Course in één tab",
"Tree Advisor: live volgende-punten-advies", "nieuw Gear up-hoofdstuk".
Let op in ProfessionsHub.lua: `ns.panels.professions` wijst nu naar het
inner treasures-frame (Profession.lua-hook bouwt daar ongewijzigd in).

Nabrander uit Robs Tailoring-leek-test (zelfde batch, commit 3):
- Tier-flow werkt (Midnight Tailoring direct actief na leren ✓).
- Gearup-body ×6: tools/accessoires komen van ÁNDERE professies
  (BS/LW) → AH "Profession Equipment" of een crafter; supplies-vendor
  soms basics. (Vraag van Rob "moet je die altijd kopen/laten maken?" —
  ja, behalve Ench-rods.)
- Terminologie geüniformeerd ×6: "Beginner route"/"Route"/"Farming
  route" → overal **"Starter build"** (Rob las er als leek meerdere
  routes in); Skinning = "Starter build (farming)".

### Fase 5, iteratie 7 (commit `73f1f36`) — Tree Advisor v1 (concept C)

Eerste plak van concept C, als advies-regel in het Professions 101-blok
(geen aparte tab; doel-picker Goud/Zelfvoorziening/Levelen kan later).

- **Data (`ProfessionAcademyData.lua`):** `advisorRoutes` per skillLine —
  gecureerde default-route van tree-ROOTS in volgorde (uit dezelfde
  research als de starthoofdstukken). `anyOf` = spelerkeuze telt voor de
  stap (LW leather/scales, BS armor/weapons, Tailor Finery/Fiber Arts,
  Alch Flasks/Potions); `skipIfClass = "DRUID"` op Herbalism-Botany
  (druïden gatheren al in vorm). **Namen moeten exact matchen met
  `GetTabInfo().name`** — mismatch = regel verschijnt niet (never lie).
  Live geverifieerde namen: Ench ×4, Tailor ×2, LW ×1, Skin ×2; rest komt
  uit de gidsen (Insc "Blueprints"/"Calm Hands"-onzekerheid: Calm Hands is
  vermoedelijk een node, niet een tab — route start daarom bij Blueprints).
- **Logica (`ProfessionAcademy.lua`):** `GetSpecSummary` geeft nu ook
  `tabs = { {name, active, max}, ... }`; `GetAdviceForProf` loopt de route
  en geeft de eerste niet-volle root terug (voorkeur voor de tree waar al
  punten in zitten bij anyOf), `false` bij route compleet, `nil` bij
  mismatch/geen data. BuildProfsText toont groene regel:
  "Advice: next points into X (root a/b) — the chapter below explains
  why." of de route-compleet-variant. 2 nieuwe keys ×6
  (PROFACAD_ADVISE_NEXT_FMT / _ADVISE_DONE).
- Stub-test (texlua, Robs echte waarden): Ench → Disenchanting Delegate
  (4/31) ✓; Tailor → Nimble (20/31) ✓; anyOf met Fiber Arts gestart →
  Fiber Arts ✓; alles vol → "route compleet" ✓; naam-mismatch → geen
  regel ✓; Druid-Herb → slaat Botany over ✓.
- **Fix na eerste test:** `GetAdviceForProf` stond ná `BuildProfsText`
  (local-scoping → nil-call op regel 125); verplaatst naar vóór de caller.
  Ironisch: zelfde bug-klasse als de Fase 1 forward-decl-fixes.
- **⚠️ API-bevinding:** de ochtend-dump las Shatterer-root als 31/31 (met
  spec-venster open); 's avonds las dezelfde node (107817, zelfde config)
  6/31 in álle velden (active/current/ranksPurchased) — en de in-game
  tooltip bevestigde **"Rank 5/30"**: de avond/closed-lezing is de juiste.
  Conclusie: lezingen met het venster open kunnen onbetrouwbaar zijn (de
  31/31 van 's ochtends voor 1152/1155 was vermoedelijk artefact); de
  closed-state waar MH op draait klopt. Apply Knowledge zonder Apply
  Changes is bewust onzichtbaar voor MH (committed-only, never lie);
  na Apply Changes update het blok live.
- **Display-fix:** advies toont nu gekochte ranks (API-rank − gratis
  basisrank) zodat het matcht met de in-game tooltip ("5/30" i.p.v. "6/31").
- **UX-fix (Rob):** het advies stond alleen bovenin het blok — wie bij
  hoofdstuk 2 ("kies ÉÉN tree") aankomt ziet het niet meer en kiest blind.
  Advies-regels (met profnaam-prefix) worden nu óók onder de hoofdstuk-2-
  body getoond, op de plek van de keuze. Refactor: `BuildAdviceLine()`
  gedeeld door header-blok en hoofdstuk-injectie.
- **In-game test (live, Rob 7 juni avond): ✅ grotendeels** — main:
  Tailoring-advies "Nimble Needlework (22/31→ wordt 21/30)" en Ench-advies
  Spellbound Shatterer correct (root was echt 5/30 — advisor wees terecht
  de route-start aan); live mee-veranderen na Apply Changes bevestigd
  (Rob gaf bewust punten uit als test). Nog open: LW/Skin-alt-check +
  taal-wissel na de display-fix.

### Fase 5, iteratie 8 (commit `41e4cf1`) — Professions Hub

Robs UX-wens: "alles van de proffs bijeen, maar geen lange lap". Eén
Toolbox-sub-tab "Professions" met interne tabs (patroon: Macros-pick-nav):
**Overview | Treasures & Books | Course (101)**.

- **`Modules/ProfessionsHub.lua` (nieuw, ~230 regels):** host met interne
  nav. Overview = dashboard (profs/KP/tree-advies via nieuwe publieke
  `ns.MH_GetProfessionsOverviewText()` uit ProfessionAcademy.lua) + hint
  onderin; Treasures-frame registreert zich als **`ns.panels.professions`**
  zodat Profession.lua's EnsureMainUI-hook ongewijzigd erin bouwt (hub-build
  draait binnen EnsureMainUI, vóór de hook — volgorde klopt); Course-frame
  gaat direct naar `BuildProfessionAcademyPanel` (inner frame heeft eigen
  `_header`). Events SKILL_LINES_CHANGED/TRAIT_CONFIG_UPDATED/
  TRADE_SKILL_SHOW verversen het Overview; RefreshLocaleUI-hook voor
  knoplabels; OnShow herstelt de gekozen inner tab (SelectTab's
  hide-all-loop verbergt het inner treasures-frame — inner select toont
  hem weer).
- **UI.lua:** toolbox-defs: `professions`+`profacademy` → één
  `professionsHub` (label TAB_PROFESSIONS); SelectTab-alias:
  professions→hub+treasures, profacademy→hub+course (zoekbalk,
  ProfessionsGuide-knop, saved tabs blijven werken; onbekende saved sub-tab
  valt terug op Consumables); info-drawer per inner tab (treasures→
  PROFESSIONS, course→PROFACADEMY, overview→nieuw PROFHUB).
- **TOC:** ProfessionsHub.lua na ProfessionAcademy.lua. **Locales:** 5
  nieuwe keys ×6 (PROFHUB_TAB_OVERVIEW/_TREASURES/_COURSE,
  PROFHUB_OVERVIEW_HINT, INFO_DRAWER_BODY_PROFHUB).
- Syntax: ProfessionsHub.lua parsed (mount was vers); rest host-geverifieerd.
- **In-game test (Rob):** Toolbox toont nu 4 sub-tabs (Consumables,
  Professions, + 2 beta); Professions opent op Overview met jouw
  profs/KP/advies; interne tabs wisselen; Treasures & Books werkt als
  voorheen (incl. essence-regel + Generates); Course = Professions 101
  compleet; zoekbalk "kp" → landt op Treasures-tab; punt uitgeven →
  Overview ververst; talen wisselen vertaalt knoppen/hint.

### Fase 5, iteratie 9 (commit `3aa1681`) — "Gear up"-hoofdstuk

Robs leek-ervaring op de 82-priest: profs geleerd, maar dan? Tool (rod!)
nodig, station-vereisten, recepten bij de trainer "kopen" — het eerste-uur-
gat in de cursus. Nieuw hoofdstuk 2 ("gearup", tussen knowledge en trees):

- **Inhoud (research wow-professions/Wowhead):** 1 tool + 2 accessoires per
  prof in eigen slots bovenin het professievenster; zonder tool craft je
  veel recepten niet; starter-tools bij prof-vendors, Ench maakt eigen rods
  (groen = trainer-recept op skill 1, blauw via Transitories-tree, epic
  vendor); grijze craft-knop → vereisten-regel lezen (tool of station:
  aambeeld/lectern/kookvuur, rond de trainerwijk); skill 25 = trees,
  first craft = +1 KP. 3 keys ×6 (PROFACAD_CH_GEARUP_*). Na Robs tweede
  leek-test (venster opende op "Classic Enchanting 1/300"!) opent de body
  nu met de tier-uitleg: dropdown bovenin wisselt uitbreidings-tiers,
  alles in de cursus = MIDNIGHT-tier, anders leren bij de
  Silvermoon-trainers.
- **Auto-detectie `detect = "proftool"`:** vinkje zodra elke owned primary
  prof een tool in z'n slot heeft (`GetInventoryItemID("player", 20/23)` —
  prof-gear-slots; **slotnummers 20/23 nog niet in-game geverifieerd**: bij
  verkeerde slots vinkt hij gewoon nooit automatisch af, checkbox blijft
  handmatig — never lie). PLAYER_EQUIPMENT_CHANGED ververst; kpspent/
  proftool-auto-ticks samengevoegd in één loop.
- **Tekst-fix (Rob, priest zonder profs):** `PROFACAD_CH_TREES_BODY`
  verwees nog naar "Chapters 6 and 7 ... Enchanting and Alchemy" en
  "Alchemy at 25/50/60/75" — stamde uit de 2-profs-pilot; nummering is
  inmiddels dynamisch en op een char zonder profs bestaan die hoofdstukken
  niet. Herschreven ×6: generiek ("de eerste rond skill 25"), verwijst nu
  naar "de starthoofdstukken hieronder" + het live advies.
- **In-game test (live, Rob 7 juni avond): ✅ GESLAAGD** — volledige
  leek-flow op de 82-priest doorlopen: Midnight-tier los leren bij Dolothos
  (100g, "Requires: Level 80, Enchanting (1)") — venster opende eerst op
  Classic Enchanting 1/300 → tier-alinea toegevoegd; basis-rod bij vendor
  Lyna (10g, materiaal, niet de tool), Runed-versie craften vereist
  **Enchanter's Lectern** (station, in-game bevestigd), equippen → vinkje
  hoofdstuk 2 verscheen automatisch = **gear-slots 20/23 geverifieerd**.
  Body-zin Ench-rod aangescherpt ×6 (vendor-rod → lectern → equip).
  Accessoire-slots: komen van andere profs (BS Craftsmithing/LW), via AH
  "Profession Equipment" — optioneel voor starters (in chat uitgelegd,
  evt. later in hoofdstuktekst).

## Voor Cursor — review + commit batch 4 (7 juni namiddag, commit `e660250`)

Klein batchje, 1 commit volstaat: "Consumables: copy-to-AH bar + tooltip
hint; fix mistranslated spec hints". Bestanden: `GuideConsumables.lua`
(OnClick + tooltip-regel), `ConsumablesPanel.lua` (copy-balk +
`ns.MH_ConsumablesCopyName`, scroll-anchor 28px), 6 locales
(CONS_COPY_HINT + CONS_COPY_TT nieuw; CONS_SPEC_HINT hersteld in
deDE/frFR/esES/ptBR — deDE zei "Fahrradspezifikationen"), SESSION_NOTES.
Data-verificatie consumables: geen wijzigingen nodig (21/21 IDs correct,
meta actueel — zie iteratie 10 hieronder). Door Rob getest: copy + tooltip-
hint (`CONS_COPY_TT`) ✅ (beide in `e660250`). Luacheck
zoals altijd zelf draaien.

**Nieuw prioriteits-backlogitem:** Delve-share v2 (vertaalde ontvangst via
addon-messages) — MOET in de volgende CF-release; zie "Open / volgende
stappen" punt 0a.

### Fase 5, iteratie 10 (commit `e660250`) — Consumables-check + copy-balk

Robs vraag: klopt de Consumables-tab nog, en namen kopieerbaar voor het AH.

- **Data-verificatie: ✅ ACTUEEL.** JSON (gegenereerd 18 mei, 12.0.5): 39
  specs compleet, alle categorieën gevuld, 0 warnings, 21 unieke items.
  Alle 21 item-IDs op Wowhead geverifieerd (21/21 naam-match, alles
  "Midnight 12.0.5"); meta-check via Method.gg + Archon.gg: de 4 flasks,
  potions (Light's Potential/Recklessness), food (Hearty-varianten),
  Thalassian Phoenix Oil en Void-Touched Augment Rune zijn exact de
  huidige picks. **Geen wijzigingen nodig.** Niche-kandidaten voor later
  (bewust niet toegevoegd): utility-potions (invis/mana/absorb),
  cauldrons, Quel'dorei Medley (secondary-feast), Hunter-ammo,
  alternatieve oils.
- **Copy-balk (nieuw):** klik op een item-rij in Consumables → naam in
  een editbox onderin (auto-focus + selectie, Ctrl+C → AH-zoekbalk);
  herhaald klikken wisselt best → alternates. `GuideConsumables.lua`
  (hit-OnClick), `ConsumablesPanel.lua` (copy-balk +
  `ns.MH_ConsumablesCopyName`, scroll 28px omhoog), key `CONS_COPY_HINT`
  ×6. **Rob-test: ✅ werkt perfect**; vindbaarheid was matig (balk onderin
  valt niet op) → groene regel "Klik: kopieer naam (voor het veilinghuis)"
  in de item-tooltip toegevoegd (`CONS_COPY_TT` ×6). **Tooltip-hint na
  commit `e660250` ook ✅ bevestigd door Rob.**
- **Bijvangst:** `CONS_SPEC_HINT` was machinaal verminkt in 4 talen
  (deDE letterlijk "Fahrradspezifikationen" = fietsspecificaties, voor
  "cycles specs"!) — hersteld in deDE/frFR/esES/ptBR. Bevestigt het
  backlog-vermoeden dat oude machinevertalingen een review-pass nodig
  hebben.
- **In-game test (Rob):** Toolbox → Consumables: copy-balk onderin;
  klik flask → naam geselecteerd in het vakje → Ctrl+C → plakken in
  AH-zoek; nogmaals klikken → alternate-naam; spec wisselen werkt
  ongewijzigd; geen overlap tussen lijst en copy-balk.

## Voor Cursor — review + commit batch 5 (7 juni avond, commits `a77fd44` / `e410ea5` / `9dcdf64`; tussentijdse batch)

Voorgestelde opdeling in 3 commits:

1. **Delve-share v2 (iteratie 11):** `Modules/DelveShareSync.lua` (nieuw),
   `DelvePartyShare.lua` (DoSendLines-signature + broadcast), TOC, key
   `DELVE_SHARE_XLOC_HEADER_FMT` ×6. **🎯 Dit was het verplichte punt voor
   de volgende CF-release.** Verzendpad live getest in een party-delve ✅;
   solo-testmodus-check staat nog open bij Rob.
2. **Weekly-blok Professions Hub (iteratie 12):**
   `ProfessionAcademyData.lua` (weekly-tabel), `ProfessionsHub.lua`
   (BuildWeeklyText + events debounced), 3 keys ×6 (PROFHUB_WEEKLY_*).
   Let op data-comment: flag-semantiek 93698 verifieert Rob in-game
   (✓ hoort er nu te staan, woensdag reset-check).
3. **Showdown-checklist-regel + PTR-doc (iteratie 13):**
   `AccountWeeklyChecklist.lua` (regel na SMC-blok, build-gated via
   Showdowns-helpers), 2 keys ×6 (ACCOUNT_WEEKLY_SHOWDOWN_*),
   `docs/PTR_12.0.7_DATA.md` §3b (rares-verzamelinstructies).

Mocht de Consumables-tooltip-hint (`CONS_COPY_TT` ×6 +
GuideConsumables-tooltipregel) niet in e660250 zitten, neem die dan in
commit 1 of een eigen commitje mee. Luacheck zoals altijd (mount gaf weer
false positives op Hub/Data/PartyShare — host-tails geverifieerd).

### Fase 5, iteratie 11 (commit `a77fd44`) — Delve-share v2: vertaalde ontvangst

Backlog-punt 0a gebouwd (vereiste voor volgende CF-release).

- **`Modules/DelveShareSync.lua` (nieuw, ~140 regels):** prefix `MHDelve`
  (RegisterAddonMessagePrefix); zender broadcast compacte descriptor
  `"1|<chatLocale>|<mode>|<entryId>"` op PARTY/RAID/INSTANCE_CHAT náást de
  bestaande platte tekst (die blijft de universele fallback). Ontvanger
  (CHAT_MSG_ADDON): negeert eigen broadcast; **alleen bij taalverschil**
  met de zender worden de tips lokaal herbouwd via
  `BuildDelvePartyShareLines` (leest de éigen locale-pack — tekst komt
  nooit over de lijn, dus tip-IDs blijven release-stabiel) en geprint met
  header `DELVE_SHARE_XLOC_HEADER_FMT` (nieuw, ×6). Zelfde taal = stil
  (geen duplicatie). Dedupe per zender+entry+mode (20s).
- **Solo-testpad:** met share-testmodus aan whispert de zender de
  descriptor naar zichzelf; de ontvanger accepteert die self-whisper
  (alleen in testmodus) en rendert ongeacht taal, header krijgt
  "(test)"-suffix. Hele pijplijn dus zonder tweede speler verifieerbaar.
- **`DelvePartyShare.lua`:** `DoSendLines(lines, entryId, mode)` +
  broadcast-aanroep op het bestaande verzendmoment (zelfde channel-keuze,
  combat-lock en cooldown gelden automatisch). **TOC:** DelveShareSync na
  DelvePartyShare.
- Checks: DelveShareSync parsed (texlua); payload-round-trip,
  taal-filter en pipe-guard stub-getest ✓. DelvePartyShare-eof-fail op de
  mount = bekende truncatie (host compleet, 532 regels) — Cursor luacheck.
- **In-game test (live, Rob 7 juni avond): ✅ verzendpad** — share in een
  echte party-delve (Sunkiller Sanctum): platte tekst kwam normaal aan,
  geen errors met de broadcast erbij (oude MH bij het maatje negeert de
  prefix zoals verwacht). Nog open: solo-testmodus-check (blauw
  "(test)"-blok + dedupe) en echte cross-locale-ontvangst zodra twee
  spelers de nieuwe versie draaien.

### Fase 5, iteratie 12 (commit `e410ea5`) — "Deze week"-blok (concept B, eerste regels)

Eerste echte weekly-regels, in het Professions Hub Overview (dashboard):

- **Data (`ProfessionAcademyData.weekly`):** `trainerQuests = { [333] =
  93698 }` ("Splintered Radiance", Dolothos — alleen geverifieerde IDs;
  andere profs toevoegen zodra gedumpt, regel verschijnt vanzelf) +
  `enchantingEssences` (267654 ×5 / 267655 ×1) — nu centraal in data
  (Profession.lua heeft nog z'n eigen kopie; backlog: daarnaartoe
  verwijzen).
- **`ProfessionsHub.lua`:** `BuildWeeklyText()` — onder het Overview-blok
  een sectie "This week": per owned prof met bekend quest-ID een regel
  "✓/⏳ <prof>: trainer weekly" (IsQuestFlaggedCompleted, pcall) en voor
  Enchanting de essence-bagcounts. Events QUEST_LOG_UPDATE/BAG_UPDATE
  toegevoegd, gedebounced 0.3s (timer-handle). 3 keys ×6
  (PROFHUB_WEEKLY_HEADER/_TRAINER/_ESSENCES).
- Syntax: mount-eof-fails = bekende truncatie; host-tails geverifieerd
  (Hub 288 r., Data 279 r.). **Cursor: luacheck.**
- **In-game test (Rob):** Hub → Overview op de main: blok "This week" met
  "✓ Enchanting: trainer weekly" (groene check — weekly is vandaag
  ingeleverd; verifieert meteen de flag-semantiek van 93698!) +
  essence-regel; op de priest (weekly niet gedaan): ⏳-icoon; Tailoring
  toont géén trainer-regel (ID onbekend — correct). **Woensdag na reset:**
  ✓ hoort terug naar ⏳ te springen (reset-bevestiging). Belspa-dump
  (Tailoring-ID) maakt de tweede regel compleet.

### Fase 5+, iteratie 13 (commit `9dcdf64`) — 12.0.7-prep: Showdown-checklist-regel

Scope-bevinding bij de 12.0.7-prep:
- **Rares:** Rares.lua-entries vereisen `{ questId, mapID, x, y, naam }` —
  we hebben alleen npc-IDs. Niet toe te voegen zonder te liegen →
  **PTR-instructies** (coords-dump + kill-flag-scan met baseline-trucje
  MH_T) toegevoegd aan PTR_12.0.7_DATA.md §3b; volgende PTR-sessie van Rob
  levert alles.
- **World bosses:** al gedekt door de Showdowns-sectie (Fase 4b, Leth'ir
  getest); Pertinax wacht op Val-rotatie. Reguliere WORLD_BOSSES-rotatie
  bewust niet aangeraakt (12.0.7-bosses zijn Showdown-content).
- **GEBOUWD: Showdown-weekly-regel in AccountWeeklyChecklist** (huidige
  character, na het SMC-blok): via `ns.IsShowdownsAvailable()` (build-gate
  ≥120007 zit dáár), `GetActiveShowdownZone/GetActiveShowdownZoneName`,
  `IsShowdownWeeklyDone`. Zone zonder bekende weekly-ID matcht nooit →
  geen regel (never lie). Groen "done" / oranje "not done yet". 2 keys ×6
  (ACCOUNT_WEEKLY_SHOWDOWN_DONE/OPEN_FMT). Line-pool (24) heeft ruimte.
- **In-game test:** live 12.0.5 → géén Showdown-regel (gate); PTR 12.0.7 →
  regel met zonenaam, kleur klopt met weekly-status; Folio-mote-regel volgt
  zodra Mote-ID bekend is (PTR-doc punt 5).

## Voor Cursor — review + commit batch 6 (7 juni avond, commits `2f22c3d` / `TBD2`)

Voorgestelde opdeling in 2 commits:

1. **Tree Advisor v2 (iteratie 14):** `ProfessionAcademyData.lua`
   (advisorGoalRoutes), `ProfessionAcademy.lua` (MH_Get/SetProfAdvisorGoal
   + doel-route-keuze), `ProfessionsHub.lua` (doel-knoppenrij + tooltips),
   9 keys ×6 (PROFHUB_GOAL_* incl. TT-varianten).
2. **Leek-UX (zelfde avond):** trainer-weekly-suffix
   (PROFHUB_WEEKLY_TRAINER_REQ ×6) + accessoire-tip in Overview
   (PROFHUB_ACCESSORY_HINT_FMT ×6, slots 21/22/24/25 — fail-safe bij
   verkeerde slots; PLAYER_EQUIPMENT_CHANGED toegevoegd aan hub-events;
   gearup-vinkje blijft bewust tools-only, accessoires zijn optioneel).

Luacheck zelf draaien (mount onbetrouwbaar). Release-advies: **nog NIET
naar CF** — eerst woensdag-reset meemaken (weekly-semantiek), Delve-share
v2 solo-test, paar dagen daily-driven. CF alleen op expliciete vraag Rob.

**Versie: TOC gebumpt naar 1.6.0 (Rob, 7 juni)** — dit wordt de
release-versie zodra bovenstaande checks rond zijn. CHANGELOG: Cursor mag
de 1.6.0-kop alvast opzetten met de hoofdpunten van vandaag: Professions
Hub (Overview/Treasures/Course), Professions 101-cursus (alle 11 profs,
detectie, tree-state), Tree Advisor (live advies + doelen),
interrupt-macro's herbouwd (Focus/Mouseover — opnieuw kopiëren!),
Delve-share v2 (vertaalde ontvangst), Consumables copy-naar-AH,
shortest-hop Generate-routes, This week-blok, Showdown-checklist-regel
(12.0.7), frFR-herstel + vertaal-fixes.

### Fase 5, iteratie 14 (commits `2f22c3d` + `TBD2`) — Tree Advisor v2: doel-picker + leek-UX

- **Doelen:** Allround (= v1-routes) / Goud / Zelfvoorzienend, per
  character opgeslagen (`ns.db.profAcademy[guid].advisorGoal`).
  "Goedkoop levelen" bewust geparkeerd (geen bronnen — never invent).
- **Data (`advisorGoalRoutes`):** alleen onderbouwde overrides — Ench
  (goud: Elevating eerst — weapon/ring/chest verkopen; self: Shatterer→
  Delegate), Alch (goud: Flasks→Transmutation; self: Potions eerst),
  Tailor (goud: Nimble/bolts; self: Fabric Specialist), LW (goud:
  Flawless Fortes-consumables), Insc (goud: Perfected Products), JC
  (goud: Glamorous Gems eerst). Ontbrekend doel/prof → fallback
  advisorRoutes. Routes blijven op TAB-niveau (GetTabInfo-namen).
- **Logica (`ProfessionAcademy.lua`):** `ns.MH_Get/SetProfAdvisorGoal`
  (ProgressBag); GetAdviceForProf kiest route per doel. **UI
  (`ProfessionsHub.lua`):** "Advice goal: [Allround|Gold|Self-sufficient]"
  knoppenrij in het Overview (actieve knop getint); klik → opslaan +
  advies overal ververst (Overview, Academy-blok, hoofdstuk 2). 4 keys ×6
  (PROFHUB_GOAL_*).
- Stub-tests: Robs echte Ench-state → alle doelen wijzen Shatterer aan
  (goud-stap-1 Elevating is al vol — correct); verse enchanter → goud:
  Elevating, allround/self: Shatterer ✓ (doel-divergentie bewezen).
- **UX-aanvulling (Rob-test):** doel-knoppen hebben nu hover-tooltips
  (wat kies je en waarom — PROFHUB_GOAL_TT_* ×6); de open trainer-weekly-
  regel kreeg een grijze leek-suffix met de voorwaarden
  (PROFHUB_WEEKLY_TRAINER_REQ ×6: Flaresworn-intro + Ench skill 25 —
  Robs priest kreeg de weekly terecht nog niet op skill 1).
- Procesnotitie: Cursor committe batch 5 (a77fd44/e410ea5/9dcdf64) tijdens
  het bouwen en polishte enkele PROFHUB-vertalingen — overgenomen als
  anker; geen conflicten.
- **In-game test (Rob):** Hub → Overview: doel-knoppenrij onder de kop;
  wissel Allround→Gold op je main: Tailoring-advies hoort te verschuiven
  van Nimble-route naar Nimble→Fiber Arts-route (zelfde eerste stap zolang
  Nimble niet vol is — verschil zichtbaarder op de verse priest:
  Ench-advies Allround=Shatterer vs Gold=Elevating); keuze blijft bewaard
  na /reload en is per character; hoofdstuk 2-advies volgt mee.

## Open / volgende stappen

0a. **✅ Delve-share v2 (commit `a77fd44`) — klaar voor CF-release.** Nog
    open vóór release: solo-testmodus-check (blauw "(test)"-blok) en echte
    cross-locale-ontvangst zodra twee spelers de nieuwe versie draaien.

0b. **⏳ CF-release — nog NIET.** Eerst woensdag-reset meemaken
    (weekly-semantiek 93698), Delve-share v2 solo-test, paar dagen
    daily-driven. CF alleen op expliciete vraag van Rob.

0. **Showdowns vervolg:** Showdown-weekly-regel in AccountWeeklyChecklist ✅
    (`9dcdf64`); nog Folio-mote zodra ID bekend; Home-dashboard kan
    `ns.GetActiveShowdownZoneName`/`ns.IsShowdownWeeklyDone` hergebruiken;
    Val-data + Voidstorm-portaal-mapID invullen na volgende PTR-rotatie.

1. **12.0.7 content** (release ~16 juni, mogelijk 30 juni): Void-zones Naigtal & Val + Escalations (VoidAssaults/WorldContent), world boss Nexus-Captain Leth'ir + Heroic World Tier (WorldBoss), Omnium Folio/Runes weekly (checklist + Codex), Sporefall raid (Codex/vault), Great Vault tooltip-rework verifiëren op PTR. Bij release: `120005` uit TOC.
2. **Backlog (laag, uit review):** `SetVaultReminderOption` popup-backfill voor upgraders; SMC-grid reflow; info-drawer inline; search-UX; compact-mode double-shrink. (Debounce, keybind-namespace, VaultAdvisor dode branch, VaultReminder isCurrent en ts==0-guards: gedaan in Fase 4c.)
3. **Reviewpunt:** ts vs aparte `vaultTs` bij login-restore (Fase 1-tradeoff, Cursor akkoord met huidige aanpak).
