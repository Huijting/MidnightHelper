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

## Voor Cursor — review + commit batch 6 (7 juni avond, commits `2f22c3d` / `1833a08`)

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

### Fase 5, iteratie 14 (commits `2f22c3d` + `1833a08`) — Tree Advisor v2: doel-picker + leek-UX

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

## Voor Cursor — review + commit batch 8 juni avond (commits `0f0bb61` / `c0643d1` / `a2eb2a7`)

Voorgestelde opdeling in 3 commits:

1. **Ritual Coach fase 1:** `RitualCoachData.lua`, `Locales/RitualTips.lua`
   (EN/NL body-content), `docs/RITUAL_COACH_PLAN.md`, 2 TOC-regels.
2. **Ritual Coach fase 2:** `RitualCoach.lua`, Coach-blok in
   `WorldContent.lua`, TOC-regel `RitualCoach.lua`, 6 coach-UI-keys ×2 in
   `RitualTips.lua`.
3. **Generate Treasures fix:** `Profession.lua` — `skipCrazyArrow`/`skipTravelUI`
   gespiegeld op Rares; re-assert na `PLAYER_ENTERING_WORLD` én
   `ZONE_CHANGED_NEW_AREA` (debounce + onderdrukte reis-UI bij quiet rerun).

Luacheck niet beschikbaar (geen mingw-gcc); `loadfile` parse op alle
gewijzigde `.lua` = OK. CF-release blijft op de plank (0b hieronder).

## Open / volgende stappen

0b. **✅ Ritual Coach fase 1+2 (commits `0f0bb61` / `c0643d1`).** Oorspronkelijk
    idee (7 juni):
    Delve Coach-patroon maar voor Rituals. Ontwerpschets:
    - **Hergebruik:** `RitualSites.lua` bestaat al (site-tracking);
      DelveTips/DelveTipMarkup/DelvePartyShare + ShareSync v2 zijn het
      bewezen patroon — share-infra evt. generaliseren (payload krijgt
      content-type: "delve"|"ritual", zelfde prefix, zelfde
      locale-rendering).
    - **Content is grotendeels online te researchen** (Rob checkte dit):
      wowhead.com/guide/midnight/ritual-sites-challenges-locations-rewards
      + Icy Veins. Structuur: Curious Obelisk-entry, Tier 1-5, 8 Challenges
      (modifiers vanaf Tier 3, elk met eigen mechanic — perfecte
      tip-eenheden), fases trash → mini-boss → boss, Spoils-multiplier,
      wekelijkse rotatie Eversong/Zul'Aman. Te bouwen als research-batch
      (zoals de prof-hoofdstukken); Rob verifieert in-game en levert de
      praktijk-nuances.
    - **UI:** sub-tab of sectie in Void & Rituals-tab (waar de
      Ritual-content al leeft), Coach-balk met share-knoppen zoals de
      Delve Coach.
    - **Locale-structuur:** RITUAL_CHAT_<ID>_<SECTIE>-keys zodat de
      vertaalde ontvangst (v2) gratis meewerkt.
    Eerst: inventariseren welke rituals er zijn + wat RitualSites al weet.
    - **8 juni — designplan geschreven: `docs/RITUAL_COACH_PLAN.md`.**
      Inventaris (RitualSites.lua kent al sites/weekly/currency/renown/TomTom,
      mist alle content) + research (Blizzard-post + 5 guides): 2 roterende
      sites, Curious Obelisk, Tier 1-5 (3/4/5 vereisen 1/2/4 challenges),
      8 challenges als tip-eenheden, deaths −5%/max −50%, weekly tier-decay,
      renown-track. Datamodel-voorstel (site- + challenge-tabellen, gespiegeld
      op DELVE_TIP_ENTRIES), share-infra-keuze (parallel `MHRitual` nu vs.
      generaliseren later), 5-fasen-voorstel. **8 open in-game-verificaties**
      voor Rob (Spoils-% per challenge — bronnen conflicteren, tier-ilvls,
      challenge-unlock-quest-IDs, 2e currency-naam/ID, scenario-variatie,
      coords, Dark-Obelisk-locaties Zul'Aman, bossnamen).
    - **8 juni — FASE 1 GEBOUWD (data + EN/NL, geen UI).** Nieuw:
      `Modules/RitualCoachData.lua` (intro + 2 site-entries via `siteKey` →
      `RitualSites.SITES`, geen dubbele coords; 8 challenge-entries met
      `spoilsPct`/`spellId`/`iconId`; lookups `ns.GetRitualChallengeById` /
      `ns.GetRitualSiteEntryByKey`) + `Locales/RitualTips.lua` (enUS+nlNL,
      26 body-keys ×2, andere 4 talen vallen terug op EN zoals DelveTips) +
      2 TOC-regels (Locales\RitualTips na DelveTips; Modules\RitualCoachData
      na RitualSites).
    - **Robs obelisk-screenshots (Daggerspine) verifiëren live:** Spoils-%
      = Blizzard-waarden (10/15/13/20/10/15/15/25 voor Tendrils/Manif/
      AlarmBells/MalBoons/Tainted/Reinforced/Patrols/Embers), Spell+Icon-IDs
      geoogst, 2e currency = **Voidlight Marl**, scenario "A Strike From the
      Sea" / antagonist **Selen'vjar**. **Belangrijk voor fase 4:** challenge-
      unlock-tracking via `IsPlayerSpell(spellId)` (geleerd="Right click to
      unlearn"), niet via quest-flags — schoner dan de prof-flag-aanpak.
    - Syntax: v1-validatie draaide vólledig schoon (parse + alle keys resolven
      EN/NL + siteKeys matchen RitualSites); edits daarna host-Read-geverifieerd.
      Mount serveerde bij de hervalidatie een stale/afgekapte kopie (140 r. ipv
      143, byte-count van de eerste write) → bekende truncatie-false-positive.
      **Cursor: draai zelf luacheck/loadfile op RitualCoachData.lua +
      RitualTips.lua vóór commit.**
    - **Open (geen blokker):** tier-ilvls, Selen'vjar-eindboss-kill, 2e
      Daggerspine-scenario?, Broken-Throne-content (volgende rotatie),
      Voidlight-Marl-currency-ID. Details in `docs/RITUAL_COACH_PLAN.md`.
    - **8 juni — FASE 2 GEBOUWD: Coach-blok in Void & Rituals-tab.** Nieuw
      `Modules/RitualCoach.lua` (pure logica, spiegelt RitualSites↔WorldContent-
      split): `ns.IsRitualChallengeUnlocked` (IsPlayerSpell→IsSpellKnown,
      pcall, fail-safe "locked"), `ns.GetRitualChallengesForDisplay` (gesorteerd
      op spoilsPct desc), `ns.RitualChallengeIconMarkup` (`|T<iconId>:14|t`),
      `ns.BuildRitualChallengeTitle` (icon+naam+`+X% Spoils`+status, ready-check-
      texture voor unlocked — géén ✓-blokje), `ns.GetRitualCoachActiveSiteEntry`.
      `WorldContent.lua`: Coach-sectie ná de ritual-info-regels — actieve-site-
      regel + scenario(PHASES)+site-notes(NOTES), "How it works" (4 intro-regels),
      en de challenge-picker (8 regels: titel+mechanic, unlock-regel alleen als
      vergrendeld). Refresh in RefreshWorldPanel (active-site-tekst + titels +
      unlock-show), taal-refresh in RefreshLocaleUI. 6 nieuwe coach-UI-keys ×2
      (RITUAL_COACH_HEADER/_CHALLENGES_HEADER/_ACTIVE_FMT/_ACTIVE_UNKNOWN/
      _STATUS_UNLOCKED/_STATUS_LOCKED). TOC: `Modules\RitualCoach.lua` na
      RitualCoachData.
    - **Validatie:** RitualCoach.lua parse't schoon (mount vers); coach-logica
      stub-getest (sort Embers25>MalBoons20>Tendrils10 ✓, unlock via IsPlayerSpell
      true/false + nil-safe ✓, icon-markup ✓, titel-build ✓, active-site-lookup ✓).
      **Mount blijft bevroren op pre-edit kopieën** van RitualCoachData/RitualTips/
      WorldContent (stale byte-counts, mid-bestand afgekapt) → texlua-parse daarop
      = bekende false-positive; host-bestanden via Read compleet geverifieerd
      (einden + inserts balanced). **Cursor: luacheck/loadfile op RitualCoach.lua,
      WorldContent.lua, RitualCoachData.lua, RitualTips.lua vóór commit.**
    - **In-game test (Rob) — kernpunt:** Void & Rituals → nieuw "Ritual Coach"-
      blok; challenge-lijst gesorteerd op Spoils met de echte icoontjes; **de 4
      die jij geleerd hebt (Embers/MalBoons/Reinforced/Patrols) tonen "✓
      unlocked", de andere 4 "(locked)" + unlock-uitleg** — dit bevestigt of
      `IsPlayerSpell(spellId)` de juiste API is (zo niet: alles toont locked →
      omschakelen). Verder: actieve-site-regel + scenario/notes kloppen, taal
      wisselen vertaalt labels, icoontjes renderen (geen vraagtekens).
    - **Volgende:** fase 3 (share-knoppen, parallel `MHRitual`-sync) op akkoord.

### Losse fix 8 juni — Generate Treasures: geen TomTom-pijl

Rob: na "Generate Treasures" verscheen er geen (bruikbare) TomTom-pijl.
Oorzaak: `RunTomTomGenerate` in `Profession.lua` gaf de 6e arg `skipCrazyArrow`
**niet** mee aan `ns.AddSmartTomTomWay` → `crazy=true` + `SetCrazyArrow` op álle
pins → TomTom verplaatst de pijl steeds naar de laatst-toegevoegde = de vérste
pin (vaak andere zone), dus geen pijl naar de eerste stop. Daarnaast stond
`skipTravelUI` omgekeerd (`i < nPins`, laatste pin i.p.v. eerste). **Fix:**
gespiegeld op het bewezen `Rares.lua`-patroon — `skipTravelUI = i > 1` en
`skipCrazyArrow = i > 1`, zodat alleen pin 1 (start van de greedy route) de pijl
+ reis-UI krijgt. `nPins`-local verwijderd (was alleen voor de oude regel).
Bestand: `Modules/Profession.lua` ~1091-1101. Eén-regel-changelog waard.

**Re-assert-experiment TERUGGEDRAAID (8 juni).** Eerst toegevoegd: een
re-assert-frame (PLAYER_ENTERING_WORLD + ZONE_CHANGED_NEW_AREA, debounced) dat
de generate stil opnieuw draaide om de vluchtige crazy-arrow terug te zetten.
**Bleek averechts.** Robs sleutel-observatie: de **enkele** ritual-waypoint
(`RouteRitualSite`, één crazy arrow) blijft vanzelf staan vanuit de stad tot bij
de ritual, óók over zonegrenzen — zónder enige re-assert. Conclusie: een enkele
crazy arrow overleeft zone-changes native; mijn re-assert deed juist
`ClearAllWaypoints()` + hergenereren bij elke zonewissel en wíste daarmee de
werkende pijl (en herzette 'm op een slecht moment, positie nog niet gesetteld).
Daarom **volledig verwijderd**: `activeRoute`, `quiet`-param, `_mhTreasureReassertFrame`,
de ZONE_CHANGED/ENTERING_WORLD-handler. Wat blijft = de kern-bugfix
(`skipCrazyArrow = i > 1` zodat alleen pin 1/dichtstbijzijnde de arrow krijgt,
`skipTravelUI = i > 1`). Verwachting: de treasure-pijl gedraagt zich nu net als
de ritual-pijl. **Rob hertest.** Mocht een enkele crazy arrow tóch niet
overleven bij 15 waypoints (TomTom `setclosest`-gedrag o.i.d.), dan is de nette
fallback: pin-1-uid bewaren en op zone-change alleen `SetCrazyArrow(uid)`
opnieuw zetten zónder clear/regenerate (vereist dat `AddSmartTomTomWay` de uid
teruggeeft — raakt de gedeelde Delves-functie). Cursor: luacheck (mount gaf
truncatie/binary-false-positive op Profession.lua; host via Read geverifieerd).

**ROOT-CAUSE GEVONDEN + GEFIXT (9 juni).** De revert was incompleet — de pijl
verdween nog steeds bij zonegrenzen (Rob: SMC→Eversong→Zul'Aman), terwijl
delve/ritual-pijlen wél bleven. Oorzaak: **Delves.lua heeft al een gedeelde
zone-change-re-assert** (`eventFrame` ~regel 2030-2073, ZONE_CHANGED_NEW_AREA/
PLAYER_ENTERING_WORLD → `restoreDelveArrow()` herstelt de crazy-arrow uit
`ns.lastTarget`). Dát houdt single delve/ritual-waypoints levend over grenzen.
Maar `AddSmartTomTomWay` zet `ns.lastTarget` bij **élke** call → na de 15-pin-
loop wijst die naar de **láátste/verste** pin, terwijl de zichtbare crazy-arrow
op **pin 1 (dichtstbijzijnde)** staat. Bij een grens herstelt de re-assert dus
de verkeerde target (verste pin) of `IsMidnightTravelComplete` denkt dat je er
al bent → wist 'm → pijl weg. **Fix:** in `RunTomTomGenerate` ná de loop
`ns.lastTarget` terugwijzen naar `toAdd[1]` (pin 1, mét de arrow). Nu herstelt de
bestaande re-assert de júíste pin → pijl overleeft zonegrenzen, net als
delve/ritual. Eén regel, hergebruikt de bewezen infra, geen nieuw event-frame.
Verklaart ook "vroeger bleef 'ie wel": oude generate zette lastTarget
waarschijnlijk op de juiste pin. Bestand: `Modules/Profession.lua` ~1106-1115.
Host-geverifieerd. **Open later (nicety):** pijl laten doorschuiven naar de
volgende pin bij aankomst (nu blijft 'ie op de dichtstbijzijnde tot je 'm pakt).

**HERBOUWD naar dynamische nearest-pijl (9 juni, Rob-wens).** Probleem bij de
vaste route: in SMC (positie onbekend) startte de route op de eerste pin in de
datalijst i.p.v. de dichtstbijzijnde → pijl wees verkeerd. Rob wil: **altijd naar
de dichtstbijzijnde, en bij looten automatisch door naar de volgende.**
`RunTomTomGenerate` volledig herschreven (vaste greedy route + AddSmartTomTomWay
eruit): zet alle eligible treasures als TomTom-stippen (crazy=false,
cleardistance=0 zodat ze blijven tot gelooten), en een manager houdt de
crazy-arrow op de dichtstbijzijnde pin **op je huidige map**. Een 2s-ticker +
QUEST_LOG_UPDATE/ZONE_CHANGED/PLAYER_ENTERING_WORLD-events: (a) her-SetCrazyArrow
elke tick zodat de pijl de zone-drop overleeft, (b) verwijderen gelooten pins
(quest-flag) en doorschuiven naar de volgende dichtstbijzijnde, (c) stoppen +
"all collected"-melding als alles op is. Positie onbekend (SMC) → houdt de
huidige/eerste pin tot je buiten bent en de positie er is. `ns.lastTarget=nil`
gezet zodat de Delves-zone-re-assert niet meevecht. Geen TomTom → single Blizzard-
waypoint-fallback. Eigen `treasureEvents`-frame; state in SetupProfessionModule.
Parse OK; host-geverifieerd. **Cursor: luacheck.** Bestand: `Modules/Profession.lua`
~1007-1140.

**DIEPSTE ROOT-CAUSE GEVONDEN (9 juni) — positie-helper-bug.** Rob's `/dump` in
SMC: `C_Map.GetPlayerMapPosition(2393,"player")` → `pos=true`. Maar
`GetPlayerMapPositionForWaypoints` riep `C_Map.GetPlayerMapPosition(mapID)` aan
**zónder het `"player"`-unit-argument** → altijd nil → "player position
unavailable" **overal**, niet alleen in steden. Dít is waarom elke route op de
eerste data-pin startte i.p.v. de dichtstbijzijnde (de hele saga). **Fix:**
regel 482, `mapID` → `mapID, "player"`. Nu werkt de positie overal en wijst de
dynamische pijl naar de écht dichtstbijzijnde. (Bestond al vóór deze sessie.)
Plus extra vangnet in de manager: zonder positie tóch een pin in je huidige zone
kiezen via `GetBestMapForUnit` (map=2393 in SMC). Eén-regel-fix, host-geverifieerd.

**Treasure-pijl → HS/portal-advies bij verre zone (9 juni, Rob-wens).** De
dynamische pijl zet waypoints rechtstreeks in TomTom → kreeg dus niet de reis-
assistent (HS + beste in-wereld-portal) die delve/ritual-waypoints wél krijgen.
Opgelost zónder de kritieke `AddSmartTomTomWay` aan te raken: de travel-assist-
logica geëxtraheerd naar **`ns.ShowTravelAssistFor(targetMap, xPct, yPct, title)`**
in `Delves.lua` (na AddSmartTomTomWay; gebruikt dezelfde forward-declared
`travelPopup`/`hsBtn`/`MIDNIGHT_PORTALS`). De treasure-manager roept 'm aan
**alleen bij een target-wissel** (`changed`) zodat 'ie Esc respecteert en niet
elke tick re-popt; de functie verbergt zichzelf bij same-region/dichtbij (geen
nag op je eigen continent). Bewust een parallelle kopie i.p.v. refactor van
AddSmartTomTomWay (blast-radius: die voedt álle waypoints). Bestanden:
`Modules/Delves.lua` ~724-816 (nieuw), `Modules/Profession.lua` (assist-call).
**Vervolg (Rob: na HS naar SMC kwam er geen wegwijzer naar Harandar):** het
advies toonde alleen bij target-wissel, dus na aankomst in SMC (target = nog
steeds de Harandar-pin, ongewijzigd) verscheen "Portal to Harandar" niet.
`TreasureUpdateArrow(forceAssist)` toegevoegd; op **PLAYER_ENTERING_WORLD**
(loading-screen-aankomst: HS/portal/vlucht) wordt het advies geforceerd
hertoond voor het verre target → je ziet in SMC nu meteen de Portal-to-Harandar-
wegwijzer. Seamless ZONE_CHANGED blijft changed-only (geen re-pop-spam).
**Vervolg 2 (Rob: geen pijl in SMC bij verre target, portal-knop werd gestolen):**
de ticker SetCrazyArrow'de elke 2s naar de (cross-continent, onzichtbare)
treasure → een cross-continent-pijl rendert niet én de portal-knop-pijl (klik →
`SetCrazyArrow` naar portal, regel ~2498 Delves) werd binnen 2s teruggestolen.
**Fix:** de pijl alleen aansturen als de dichtstbijzijnde treasure op je
**huidige map** ligt (`onCurrentMap = best.mapID == curMap`). Ver weg → pijl met
rust laten; de popup + portal-knop leiden je (klik = pijl naar portal, niet meer
gestolen), en op het nieuwe continent pakt de treasure-pijl het weer op — zoals
delves.
**Vervolg 3 (Rob: popup blijft hangen/komt terug na Esc + Lua-error bij
aankomst):** (1) **Lua-error** `GetMapInfo(nil)` in GetZoneDisplayName via
ShowTravelAssistFor wanneer `GetBestMapForUnit` nil geeft mid-loading-screen →
guard toegevoegd (`if not currentMap then return`, Delves.lua ~732). (2) **Popup-
gedrag:** de assist werd op `changed or forceAssist` getoond → kon re-poppen en
negeerde Esc. Vervangen door een **target+zone-sleutel** (`best.uid .. "@" ..
curMap`): toon één keer per nieuw target ÓF bij aankomst in een nieuwe zone
(zodat "Portal to Harandar" verschijnt als je in SMC landt), maar geen re-pop op
elke tick en Esc gerespecteerd binnen hetzelfde target+zone. `forceAssist`-param
+ de PLAYER_ENTERING_WORLD-special-case verwijderd (de curMap-sleutel dekt
aankomst al). `treasureAssistKey` gereset in TreasureClearPins. Host-geverifieerd.
**Vervolg 4 (Rob: crash bij Generate + knoppen hernoemen):** (1) **Crash**
`attempt to concatenate field 'uid' (a table value)` — TomTom's waypoint-`uid`
is een **tabel**, niet een string. assistKey gebruikt nu `tostring(best.questID)`
i.p.v. `best.uid` (uid blijft fijn voor SetCrazyArrow/vergelijking, alleen niet
voor string-concat). (2) **Knoppen hernoemd + gelokaliseerd:** "Generate
Treasures"/"Generate Books" → `ns:L("PROF_GENERATE_TREASURES_BTN")` /
`PROF_GENERATE_BOOKS_BTN`. Keys in enUS ("Generate Route Treasures"/"...Books") +
nlNL ("Genereer Treasure-route"/"Genereer Book-route"); andere talen fallback EN.
Host-geverifieerd. **Cursor: luacheck.**
**Open (nicety):** pijl automatisch op de portal
zetten i.p.v. één klik (vereist managed portal-waypoint + ns.GetPortalToward).
**Cursor: luacheck.** **Open (later):** ooit DRY maken
(AddSmartTomTomWay óók via ShowTravelAssistFor).

**Mage-teleport-knop in reis-popup (9 juni — GEBOUWD; spell-ID's geverifieerd op
Robs Mage: mage=true tele=true portal=true).** Research: **Teleport: Silvermoon
City = 1259190** (lvl 82), **Portal: Silvermoon City = 1259194** (lvl 88) — de
NIEUWE Midnight-hub-spells (niet de oude BC-"Teleport: Silvermoon"). Secure
`mageBtn` (MidnightHelperMageTeleBtn) in `travelPopup`, eigen rij boven HS/portal
(popup-hoogte → 184 indien getoond). In `ns:ShowTravelPopup` (gedeeld door álle
reisadvies, incl. ShowTravelAssistFor → ook treasures/delves/rituals): toon alleen
voor **Mage + `IsPlayerSpell(1259190)` + niet in regio 1 (Silvermoon)**; macrotext
= **gelokaliseerde** spellnaam (`C_Spell.GetSpellName`), gezet buiten combat
(locale-veilig). Plus tekstregel "Mage: <spell> available". Eén plek, geen
caller-layout aangeraakt. Bestand: `Modules/Delves.lua` ~2539-2604. Host-
geverifieerd. In-game ✅ (Rob: teleport-knop werkte, zelfs van Orgrimmar).
**Portal: Silvermoon City (1259194) toegevoegd (9 juni):** tweede secure
`magePortalBtn`; ShowTravelPopup toont nu beide (gepaard −25/+25 op de mage-rij,
of enkel gecentreerd) o.b.v. `IsPlayerSpell` per spell; `MageTeleSpellName` →
`MageSpellName(id)`; popup-hoogte 200 als een mage-knop toont. **Cursor:
luacheck.** **Open:** layout fine-tunen indien nodig.

**Tracker per zone gegroepeerd (9 juni, Rob-wens).** De Professions-tracker
(Treasures/Books-lijst per professie-kolom) toonde naam + coords zonder zone.
Toegevoegd: **zone-subkopjes** binnen elke Treasures/Books-sectie, gegroepeerd op
`C_Map.GetMapInfo(mapID).name` (zones alfabetisch, rij-volgorde binnen een zone
behouden). `MountZoneHeader` (lichtblauw, links, 16px) + `AddRowsGroupedByZone`
in `PopulateProfessionColumn`; constante `TRACKER_ZONE_HEADER_HEIGHT`. Kolom-
hoogte groeit vanzelf mee (y-accumulatie → `return y+8`). Bestand:
`Modules/Profession.lua` ~840-883. Host-geverifieerd. **Cursor: luacheck.**

### Fase 2 Ritual Coach — in-game ✅ (Rob, 8 juni)

Void & Rituals toont het Coach-blok perfect: actieve site + scenario (A Strike
From the Sea/Selen'vjar) + site-notes, "How it works", en de challenge-lijst
gesorteerd op Spoils met echte icoontjes + mechanic + how-to-unlock.

**CORRECTIE 8 juni — unlock-status verwijderd (never-lie).** De aanname dat
`IsPlayerSpell(spellId)` permanente unlock leest was **fout**. Rob in-game:
de obelisk-"Click to learn / Right click to unlearn" (Rank 0/1 ↔ 1/1) is de
**per-run SELECTIE-toggle**, geen permanente unlock — élke challenge klapt terug
naar "learn" zodra je 'm deselecteert. `IsPlayerSpell` las dus selectie, wat in
het paneel zou misleiden (en nutteloos is buiten de obelisk). **Verwijderd:**
`ns.IsRitualChallengeUnlocked` + TICK uit RitualCoach.lua, de "✓ unlocked /
(locked)"-tag uit `BuildRitualChallengeTitle`; WorldContent toont de
how-to-unlock-regel nu **altijd** (statische, altijd-ware referentie). De
RITUAL_COACH_STATUS_*-keys staan ongebruikt in de locale (laten staan). Echte
"heb ik dit permanent vrijgespeeld"-detectie zou via de unlock-quest-flags
moeten (fase 4, nog open — quest-IDs nog te dumpen). Coach is nu zuiver
referentie: per challenge mechanic + Spoils% + hoe te ontgrendelen.

### Nieuw 8 juni — "Start Here"-tab (new-player roadmap)

Robs idee na de "stel je weet niks van Midnight"-brainstorm: een geleide
eerste-week-route die de bestaande systemen aan elkaar rijgt i.p.v. ze los uit te
leggen. Keuze Rob (via vraag): **eigen top-tab**, als eerste in de sidebar.

- **`Modules/StartHere.lua` (nieuw):** scroll-paneel (zelfde layout-engine als
  WorldContent: ui.order + push + Relayout op GetStringHeight). Intro + 6
  genummerde stappen (item level → character afstellen → Great Vault → Delves →
  Ritual Sites & Void Assaults → renown/professies/currencies) + reset-dag-blok.
  Elke stap heeft een **nav-knop** via `ns.SelectTab` (delves/consumables/home/
  delves/world/profacademy — alle bestaande ids/aliassen). Stap 5 **auto-tickt**
  twee weeklies via `ns.IsRitualWeeklyDone` + `ns.IsVoidAssaultWeeklyDone`
  (pcall, ready-check-texture voor done; never-lie: alleen getickt waar een
  echt signaal bestaat). Events QUEST_LOG_UPDATE/PLAYER_ENTERING_WORLD/
  WEEKLY_REWARDS_UPDATE + OnShow refreshen de ticks; RefreshLocaleUI-hook.
- **`Locales/StartHere.lua` (nieuw):** TAB_START_HERE + 28 START_*-keys ×2
  (enUS+nlNL); andere 4 talen vallen terug op EN.
- **`UI.lua`:** `{ id="starthere", labelKey="TAB_START_HERE" }` in TAB_DEFS;
  "starthere" als eerste id in SIDEBAR_SECTIONS-week (vóór home; Home blijft de
  SelectTab-fallback, los van sidebar-volgorde); build-dispatch
  `ns.BuildStartHerePanel`; SelectTab-refresh `ns.RefreshStartHerePanel`.
- **TOC:** `Locales\StartHere.lua` na RitualTips; `Modules\StartHere.lua` na
  RitualCoach.
- **Validatie:** beide nieuwe bestanden parsen schoon (mount vers); 28 keys
  resolven EN/NL; alle 6 navTabs zijn geldige SelectTab-ids (stub-getest).
  UI.lua-edits host-Read-geverifieerd (mount gaf truncatie-false-positive).
  **Cursor: luacheck op StartHere.lua + UI.lua.**
- **In-game test (Rob):** nieuwe eerste tab "Start Here"; stappen + nav-knoppen
  landen op de juiste tab; op stap 5 staan Ritual/Void-weeklies groen als gedaan,
  oranje als open; taal wisselen vertaalt alles. Reset-tekst noemt EU=woensdag/
  US=dinsdag.
- **Verrijkt 8 juni (zelfde sessie):** subtitel-belofte ("wekelijkse stappen
  vinken zichzelf af") waargemaakt met meer never-lie-detectie:
  - **Weekly-teller bovenaan** ("Deze week: X/N doelen gedaan", groen bij vol) —
    telt alleen binaire weeklies mét helper: Ritual + Void (+ Showdown via
    `IsShowdownsAvailable`/`IsShowdownWeeklyDone` op 12.0.7). Geen helper = niet
    geteld.
  - **Stap 3 (Vault):** claim-nudge via `GetVaultReminderState` — ready-entry
    voor de huidige char → groen "claim 'm!", anders neutrale hint.
  - ~~**Stap 4 (Delves):** "Delver's Call: X/Y"~~ **TERUGGEDRAAID** (Rob: 0
    delves op verse char → toonde 6/10). `GetDelverCallState.completed` =
    `IsQuestFlaggedCompleted` op de Delver's Call-quests, en die flags zijn
    **account/warband-breed** → misleidend per-character. Geen schoon per-char
    "delves deze week"-signaal → regel verwijderd; stap 4 houdt knop + uitleg.
  - 4 nieuwe keys ×2 (START_WEEKLY_SUMMARY_FMT/_VAULT_READY/_VAULT_NONE/
    _DELVERCALL_FMT). `statusKind`-veld per stap + `ui.statusRows`. Alles
    pcall-guarded. Validatie: host-bestanden compleet (mount gaf weer truncatie-
    false-positive); 6 helpers bestaan; keys resolven EN/NL.
- **Mogelijke uitbreidingen later:** per-stap "klaar"-vinkje voor stap 1/2/6
  (geen schoon signaal), of een "verberg na 1e week"-optie.

**Content-accuratesse-pass 8 juni (Rob spotte fouten + research Method/Icy
Veins/forums):**
- **"level 80" → "max level"** in subtitel ×2. Midnight-cap is **90** (5 guides +
  Lilatha-tooltip "Level 90 (Elite)"); "max level" is futureproof en altijd waar.
- **Stap 1:** "run a few Bountiful Delves" was fout (Bountiful is Tier 8+ en
  Coffer-Key-gated). Herschreven ×2: makkelijke winst eerst — campaign + world
  quests + renown-milestone-quests + **gewone** Delves (+ Prey + Heroic dungeons)
  om ilvl te klimmen; crafted/AH voor baseline.
- **Stap 4:** Bountiful-nuance toegevoegd ×2: klim eerst gewone tiers; vanaf
  **Tier 8** Bountiful met **Restored Coffer Key** → Champion + Hero-vault.
- **Stap 5:** Rituals zijn **unlock-gated** (questlijn "Ritual Interest" in
  Silvermoon — letterlijk uit Robs renown-dump `unlockDescription`) + lagere
  prioriteit (random Champion-gear); Void Assaults = de toegang. **"tracks what
  you've unlocked" geschrapt** (die feature is verwijderd, zie fase-2-correctie).
- Achtergrond: ritual-weekly 95843 is correct + unlock-gated; op een char zónder
  de "Ritual Interest"-questlijn verschijnt 'm niet (Robs char had renown 4 =
  unlocked, dus zijn weekly was simpelweg nog niet opgepakt deze week — geen bug).
- Host-geverifieerd (mount truncatie-false-positive). **Cursor: luacheck.**
- **GEBOUWD 8 juni — dynamische ritual-weekly-hint.** `ns.GetRitualWeeklyHint()`
  in `RitualSites.lua` → (text, kind) of nil; never-lie, alleen echte signalen:
  - **locked** (renown 2792 niet `isUnlocked`) → toont de game's eigen
    `unlockDescription` via `RITUAL_WEEKLY_HINT_LOCKED_FMT` ("Complete the quest
    Ritual Interest in Silvermoon City").
  - **pickup** (unlocked, quest niet in log) → "haal de weekly bij de hub".
  - **inprogress** (in log, niet ingeleverd) → "afmaken + inleveren".
  - weekly done / unlock-staat onbekend → nil (niks tonen).
  Belangrijk inzicht (Rob): de **renown-unlock is warband-breed, de weekly-quest
  per-character** — daarom toonde zijn char renown 4 maar geen weekly (gewoon nog
  niet opgepakt deze week). De hint legt dat nu uit. `WorldContent.lua`:
  `ui.ritualWeeklyHintFs` onder de weekly-regel in de ritual-sectie, getoond/
  verborgen op de hint. 4 keys ×2 (`RITUAL_WEEKLY_HINT_*`). Host-geverifieerd
  (mount truncatie-false-positive). **Cursor: luacheck.** **Open:** evt. dezelfde
  hint ook op Start Here stap 5.

### Nieuw 8 juni — Ritual Coach fase 3 (share-knoppen)

Plan-Optie 2 gebouwd: **parallelle share-infra met prefix `MHRitual`**, volledig
los van Delve-share v2 (`MHDelve`) zodat die CF-klare keten ongemoeid blijft.

- **`Modules/RitualShare.lua` (nieuw):** `ns.BuildRitualShareLines(entryId, mode)`
  — alleen `entryId="challenges"`: kop + 1 regel per challenge (naam + Spoils% +
  eerste mechanic-bullet), gesorteerd op Spoils via
  `GetRitualChallengesForDisplay`. **Locale-only / player-state-onafhankelijk**
  (unlock-status bewust NIET gedeeld) zodat cross-locale-ontvangers exact
  hetzelfde herbouwen. `ns.SendRitualShare` (kanaalkeuze PARTY/RAID/INSTANCE via
  zelfde party-category-logica als Delve, combat-lock, 18s-cooldown, pendingSend-
  guard, 0.35s line-gap, **confirm-popup vanaf 3 regels**). `GetRitualShareCopyText`
  voor buiten-groep-delen. Test-mode hergebruikt `ns.GetDelvePartyShareTestMode`
  (één toggle voor beide). Zelfstandig (kleine helpers gedupliceerd — bewust, plan).
- **`Modules/RitualShareSync.lua` (nieuw):** kopie van het Delve-v2-patroon, prefix
  `MHRitual`, payload `"1|<chatLocale>|<mode>|<entryId>"`; ontvanger met andere
  locale herbouwt via `BuildRitualShareLines` (tekst nooit over de lijn). Self-
  whisper-testpad + dedupe (20s) identiek aan DelveShareSync.
- **`WorldContent.lua`:** "Share challenge tips"-knop onder de challenge-lijst in
  het Coach-blok (`ns.SendRitualShare("challenges","all")`), + label in
  RefreshLocaleUI. **Locales:** 11 nieuwe `RITUAL_SHARE_*`/`RITUAL_COACH_SHARE_BTN`-
  keys ×2 (enUS+nlNL). **TOC:** RitualShare + RitualShareSync na RitualCoach.
- **Validatie:** beide nieuwe bestanden parsen schoon; alle share-keys resolven
  EN/NL; `BuildRitualShareLines("challenges","all")` → 9 nette regels (Embers 25 →
  … → Tendrils 10) met de mechanic per challenge; bad-entry geweigerd; payload-
  format ok. WorldContent-knop host-Read-geverifieerd. **Cursor: luacheck.**
- **In-game test (Rob):** Void & Rituals → "Share challenge tips"-knop; in een
  party → confirm-popup → 9 regels in party-chat; solo met share-testmodus aan →
  self-whisper rendert de regels (en cross-locale zodra een 2e MH-speler met
  andere taal meedoet). Combat/cooldown/no-group-meldingen kloppen.
- **Open:** echte cross-locale-ontvangst met 2 spelers (zoals Delve-share 0a);
  evt. een Copy-knop in de UI (helper `GetRitualShareCopyText` ligt klaar).

## Voor Cursor — commit + push 8 juni late avond (commits `bd875cf` / `572fc22` /
`caa37f7` / `68ec20e` / `71973f9` + docs)

Eerst 5 commits die nog niet op origin stonden (`6ad6370` … `7dbd16f`), daarna
deze 5. `loadfile` parse op alle gewijzigde `.lua` = OK; luacheck niet
beschikbaar (geen mingw-gcc).

1. **Ritual Coach share fase 3:** `RitualShare.lua`, `RitualShareSync.lua`
   (`MHRitual`-prefix, parallel aan Delve v2).
2. **Ritual weekly-hint + Coach unlock-correctie:** `RitualSites.lua`
   (`GetRitualWeeklyHint`), `RitualCoach.lua` (geen `IsPlayerSpell`-tags).
3. **Coach UI-wiring:** `WorldContent.lua`, `RitualTips.lua` (share + hint keys),
   `MidnightHelper.toc` (RitualShare + StartHere-regels).
4. **Start Here-tab:** `StartHere.lua`, `Locales/StartHere.lua`, `UI.lua`.
5. **Generate Treasures-pijl:** `Profession.lua` — re-assert teruggedraaid
   (enkele crazy-arrow overleeft zones; alleen `skipCrazyArrow`-fix blijft).
6. **Docs:** `SESSION_NOTES.md`, `TOMORROW.md`, `CHANGELOG.md`.

## Voor Cursor — commit + push 9 juni (treasure-pijl + reis-assistent, `10dea3c`)

`loadfile` parse op `Profession.lua`, `Delves.lua`, `enUS.lua`, `nlNL.lua` = OK.
Luacheck niet beschikbaar. Commit alle uncommitted + push `origin/main`.

- **Profession.lua:** dynamische nearest-treasure-pijl (player-map positie-fix,
  regio-gate, auto-advance, portal/HS-advies via `ShowTravelAssistFor`),
  questID-crash-fix, tracker per zone, gelokaliseerde route-knoppen.
- **Delves.lua:** `ns.ShowTravelAssistFor`, currentMap-nil-guard, Mage
  Teleport/Portal Silvermoon-knoppen.
- **Locales enUS/nlNL:** `PROF_GENERATE_TREASURES_BTN` / `_BOOKS_BTN`.
- **Docs:** `SESSION_NOTES.md`, `TOMORROW.md`, `CHANGELOG.md`.

## Voor Cursor — review + commit batch 10 juni (commits `d6cf079` / `7bb2386` /
`948c5ea` / `cc8d2ef` / `af4f9f2` / `13dac4c` / `48d40a3` + docs `da7da88`)

**Release 1.6.0** — CF-upload door Rob met `CURSEFORGE_1.6.0.md` +
`CURSEFORGE_DESCRIPTION.md`.

## Voor Cursor — review + commit batch 10 juni (lokalisatie ⭐ + blokjes-sweep)

Door Claude (Cowork) gebouwd, alle edits via host-tools; **mount bleef bevroren
op pre-edit kopieën** (RitualTips toonde 197 i.p.v. 561 regels) → alle
verificatie host-side. **Cursor: luacheck/loadfile op RitualTips.lua,
StartHere.lua, enUS/nlNL/deDE/frFR/esES/ptBR.lua, DelveTips.lua,
GuideAdvisor.lua, WorldContent.lua vóór commit.** Appends kunnen LF i.p.v.
CRLF zijn (cosmetisch; normaliseren mag). Voorgestelde opdeling in 2 commits:

1. **Lokalisatie deDE/frFR/esES/ptBR (de ⭐-taak uit TOMORROW.md):**
   - `Locales/RitualTips.lua`: 4 nieuwe merge-blokken (67 keys ×4; key-audit
     host-geverifieerd: 402 = 67×6, identieke key-set/volgorde per blok;
     header-comment bijgewerkt). WoW-eigennamen EN gehouden (challenge-/site-/
     NPC-/item-/quest-/scenarionamen, Spoils, Ritual Chest, Curious Obelisk);
     stadsnamen volgen de bestaande conventie per bestand (Silbermond /
     Lune-d'argent / Lunargenta / Luaprata).
   - `Locales/StartHere.lua`: 4 nieuwe merge-blokken (33 keys ×4; 198 = 33×6
     geverifieerd). Nav-knoplabels matchen de bestaande TAB_*-vertalingen
     (Tiefen / Gouffres / Profundidades / Profundidades; Verbrauchsmaterial /
     Consommables / Consumibles / Consumíveis). `TAB_START_HERE`: "Erste
     Schritte" / "Bien démarrer" / "Primeros pasos" / "Comece aqui".
   - `deDE/frFR/esES/ptBR.lua`: `PROF_GENERATE_TREASURES_BTN` / `_BOOKS_BTN`
     toegevoegd (na PROF_ESSENCE_FMT, ~regel 186).
   - Format-specifiers (%s/%d) per `_FMT`-key geverifieerd identiek ×6.
2. **Blokjes-sweep (Robs extra check):** alle .lua host-side gescand op tekens
   buiten ASCII/Latin-1/Latin-Ext-A + veilige typografie (• — – ‘’ “” … „):
   - **ZWSP (U+200B) verwijderd** — onzichtbaar/blokje, MT-artefact (bijv.
     "variáveis ​​salvas"): `DelveTips.lua` (7 regels), `GuideAdvisor.lua` (24),
     `ptBR.lua` (5).
   - **✓ (U+2713) — bewezen blokje-glyph (zelfde als de ProfessionAcademy-fix
     7 juni):** `DAWNCREST_ACH_DONE_FMT` ×6 → ReadyCheck-texture. Consumer
     (DawncrestGuide.lua:287) gebruikt `ns:L`, geen SafeL; regel verschijnt
     alleen bij completed tier-achievement — daarom nooit eerder gespot.
   - **→ (U+2192)** — "missing glyph = square" volgens de eigen comments in
     Locale.lua:307 en ProfessionsGuide.lua:159: vervangen door "->" in
     deDE/frFR/esES/ptBR (álle voorkomens: VAULT_REMINDER_*, SEARCH_CHAT_SMC_
     PIN_FMT, LOCALE_STATUS_AUTO_FALLBACK_FMT, DELVES_VAULT_CLAIM_READY) en in
     enUS/nlNL alléén de twee keys zónder SafeL-pad (`LOCALE_STATUS_AUTO_
     FALLBACK_FMT`, `SEARCH_CHAT_SMC_PIN_FMT`). CHANGELOG-/PROFGUIDE-pijlen in
     enUS/nlNL bewust gelaten: Changelog.lua rendert via SafeL, ProfessionsGuide
     heeft een eigen gsub-normalisatie.
   - **`Modules/WorldContent.lua` ~161:** de ritual-weekly-hint-prefix "→ "
     ging als enige rendered literal niet door een sanitizer → nu via
     `ns.SanitizeUIFontText` (fallback "-> ").
   - **Bijvangst MT-fixes:** nlNL `DELVE_SHARE_BAR_HINT_TEST` was verminkt
     ("alleen → deel-knoppen") → herschreven; deDE idem ("Wenn du alleine
     sind, teilen du die Schaltflächen…") → herschreven; frFR
     DAWNCREST_ACH_DONE_FMT "ton bataille" → "ton bataillon".
   - **Bewust gelaten (veilig):** „ (U+201E, CP1252 — deDE-citaten), − (U+2212
     op collapse-knoppen, al maanden in-game zichtbaar zonder klachten), CJK
     `LOCALE_NAME_koKR/zhCN/zhTW` (rendert alleen op CJK-clients met eigen
     font; chat heeft al de Latijnse fallback in Locale.lua), en alle pijlen/
     symbolen in code-comments.

In-game test (Rob): zie de nieuwe punten in TOMORROW.md §1.

### Nabrander 10 juni — ritual-weekly-hint: "intro"-state (per-character keten)

Robs druid (lvl 90, renown warband-unlocked) kreeg "haal de weekly bij de hub",
maar de hub bood **niets** aan. Research (Wowhead quest 94383 + storyline 6270):
de weekly zit achter de per-character intro-keten **Ranger Captain's Summons
(94380) → Outfitting and Allies (94381) → Void Strike (96080) → Ritual
Problems (94382, Kul'amara) → Ritual Interest (94383, Darkglen)**. Robs
druid-dump bevestigt per-character flags: 94381 true, rest false (main heeft
alles). De oude "pickup"-hint loog dus op chars zonder afgeronde keten.

- **`Modules/RitualSites.lua`:** constante `RITUAL_INTRO_FINAL_QUEST = 94383`
  (~regel 21, met keten-comment); `GetRitualWeeklyHint()` heeft een nieuwe
  state **"intro"** tussen unlocked en pickup: renown unlocked maar 94383 niet
  geflagd op dit personage → intro-hint (pcall-guarded; flag-API onbeschikbaar
  → valt terug op pickup zoals voorheen). Doc-comment bijgewerkt.
- **`Locales/RitualTips.lua`:** nieuwe key `RITUAL_WEEKLY_HINT_INTRO` ×6
  (na _PICKUP per blok; audit nu 68 keys ×6 = 408 ✓, header-comment
  bijgewerkt). Tekst noemt de startquest + dat de Void Strike-stap in de
  actieve assault-zone gebeurt.
- **Te verifiëren (Rob):** (1) druid na /reload → hint toont nu de
  intro-tekst i.p.v. "haal bij de hub"; (2) zelfde dump op de main → 94383
  hoort true te zijn en de hint blijft daar pickup/inprogress (bevestigt dat
  94383 écht per-character is en niet warband); (3) keten afronden op de druid
  → hint verspringt naar pickup → weekly verschijnt bij de hub.
- **Cursor: luacheck/loadfile op RitualSites.lua + RitualTips.lua** (zelfde
  batch als hierboven; mount blijft onbetrouwbaar).

### Nieuw 10 juni — Reset-routine op het Home-dashboard (Rob-wens)

Robs vraag: "een logische volgorde na de reset — eerst vault, dan die en die
weeklies ophalen op die en die plek, een route-lint zoals delves/treasures."
Keuzes (Rob via vraag): Home-dashboard + checklist mét route-lint.

- **`Modules/ResetRoutine.lua` (nieuw, ~290 r.):** pure logica.
  `ns.GetResetRoutineSteps()` → geordende stappen voor het ingelogde
  personage, elk met tekst/kleur/onClick: (1) Great Vault claimen (live
  `C_WeeklyRewards.HasAvailableRewards`, los van de reminder-instelling;
  API weg → stap weggelaten, never lie), (2) Ritual-weekly (hergebruikt
  `GetRitualWeeklyHint`-states incl. de nieuwe intro-state; klik → hub-route
  of actieve-site-route), (3) Void-weekly (meta 95842 + zonequests
  94385/94386: done/in-log/ophalen), (4) trainer-weeklies — alleen owned
  profs met geverifieerd quest-ID uit `ns.PROF_ACADEMY.weekly.trainerQuests`
  (nu alleen Enchanting 93698; meer IDs = vanzelf meer regels).
  `ns.StartResetRoute()` → TomTom-keten langs de nog-open stops (vault →
  Bazaar-hub → Work Order-station), dubbele hub-pin gededupliceerd, alleen
  pin 1 krijgt crazy-arrow + travel-UI (Rares-patroon) en `ns.lastTarget`
  wijst terug naar pin 1 (de 9-juni-treasure-les). Chatmelding met aantal
  stops / "niets te routeren".
- **Vault-kist-coördinaat:** Silvermoon-bank, neutrale vleugel, **2393 /
  50.3 / 65.1** — research-verified (Wowhead Great Vault-guide +
  conquestcapped, juni 2026), **in-game te bevestigen** (pin ernaast =
  cosmetisch, bank is onmisbaar).
- **`Modules/HomeDashboard.lua`:** nieuw full-width blok bovenaan
  `BuildLayout` (vóór Vault|World Boss): genummerde stappen + route-knop;
  rendert alleen als de module stappen geeft (pcall-guarded). Bestaande
  events (WEEKLY_REWARDS_UPDATE/QUEST_LOG_UPDATE) verversen het blok al.
- **TOC:** `Modules\ResetRoutine.lua` na VoidAssaults.
- **Locales:** 18 nieuwe `HOME_ROUTINE_*`-keys ×6 (na HOME_VOID_WEEKLY_TODO;
  audit 108 = 18×6 ✓).
- **Vervolg (Rob-wens):** de VaultReminder-login-popup bleef staan na klik op
  de waypoint-knop → `VaultReminder.lua` ~322: `f:Hide()` na het zetten van de
  waypoint. Bijvangst: VaultReminder had al een in-game-gebruikt
  vault-coördinaat (**2393/49.93/64.54**) → ResetRoutine daarop uitgelijnd
  (was research-coords 50.3/65.1); backlog: ooit centraliseren in één
  ns-constante.
- **Vervolg 2 (Rob-wens):** (a) stap "Weekly quest givers" (Liadrin /
  Halduron / Aethas, naast de vault) toegevoegd als stop 2 — zelfde plek als
  de city-guide-pin `weekly_hub` (2393/48.95/64.92). Hun quest-IDs zijn nog
  nérgens geverifieerd (SMCChecklistData.questIds = {}; Liadrin is bovendien
  keuze-uit-4), dus de stap toont eerlijk "oppakken wordt nog niet getrackt"
  i.p.v. een gegokte status; pin zit wel in het route-lint. IDs dumpen → echte
  status (TOMORROW.md). (b) De route-regel is nu een echte
  UIPanelButtonTemplate-knop: HomeDashboard heeft een aparte button-pool
  (`AcquireButton`, alleen full-width-blokken; tekstbreedte + 28px, cap op
  child-breedte) naast de tekstrows — templates kunnen niet achteraf op de
  bestaande rows. 2 nieuwe keys ×6 (HOME_ROUTINE_GIVERS/_PIN_GIVERS; audit
  120 = 20×6).
- **Vervolg 3 (Rob-vraag: "mag de char 'm wel, en opgepakt/gedaan-status"):**
  giver-stap is nu data-gedreven scaffold in ResetRoutine.lua:
  `GIVER_WEEKLIES` (Liadrin/Halduron/Aethas, elk `quests = {}` +
  `minLevel = nil` — alléén geverifieerde data invullen) + `GiverState()`:
  done (een ID geflagd = "deze week gedaan") → inlog ("opgepakt") → locked
  (level < geverifieerde minLevel = eligibility-check) → pickup. Givers
  zónder IDs collapsen in de bestaande eerlijke "nog niet getrackt"-regel
  (route-pin maar één keer). Zodra Robs dumps de IDs leveren: invullen in
  GIVER_WEEKLIES én SMCChecklistData.weekly_hub.questIds — statussen
  verschijnen vanzelf. 4 nieuwe keys ×6 (HOME_ROUTINE_GIVER_DONE/_INLOG/
  _PICKUP/_LOCKED_FMT; audit 144 = 24×6).
- **Vervolg 4 (Robs review):** (a) trainer-weekly-stap verdween stilletjes op
  chars zonder Enchanting (enige geverifieerde ID) → owned profs zónder
  geverifieerd quest-ID tonen nu een grijze "nog niet getrackt — quest-ID
  onbekend"-regel (klik → Professions Hub); de stap kan niet meer "missen".
  (b) Trainer-pickup routeert nu naar de tráiner van die professie (per-prof
  city-guide-pincoords gespiegeld in `TRAINER_PINS`, skillLine-keyed) i.p.v.
  het Work Order-station; pin-label gelokaliseerd met profnaam
  (`HOME_ROUTINE_PIN_TRAINER_FMT`; pins ondersteunen nu een format-arg).
  Trainer kreeg ook een "opgepakt"-state (`_TRAINER_INLOG_FMT`).
  (c) Kleurverschil opgepakt vs. nog-ophalen was te klein (WARN-geel vs
  SOFT-geel) → nieuwe `COLOR_PROG` (lichtblauw) voor alle
  "opgepakt/in-log"-regels (ritual/void/giver/trainer). 3 nieuwe + 1
  herschreven key ×6 (audit 162 = 27×6).
- **Vervolg 5 (Robs vraag "staan die IDs niet online?"):** jawel —
  Wowhead-DB: Liadrins Spark-keuze-uit-4 = **93766 Midnight: World Quests /
  93909 Midnight: Delves / 93910 Midnight: Prey / 93911 Midnight: Dungeons**
  (zelfde reeks als Void Assaults 95842 / Ritual Sites 95843). Ingevuld in
  `GIVER_WEEKLIES.liadrin` én `SMCChecklistData.weekly_hub.questIds`
  (mode "any" — max 1 Spark-weekly p/w). In-game bevestiging door Rob
  pending (TOMORROW). minLevel bewust nil gelaten: Wowheads "level 90" is
  quest-level, niet de vereiste. Halduron (rep-dungeon) en Aethas (weekend)
  hebben geen publieke IDs → blijven untracked tot Robs dump.
- **Vervolg 6 (Robs spot): SMC-knop "World boss: (open map)" terwijl Home
  "Active: Lu'ashal" toont.** Oorzaak: `GetActiveWorldBoss` heeft 3 bronnen
  (live / week-cache / rotatie-schedule); Home toont ook de schedule-gok als
  naam, maar de SMC-knop verstopte de naam zodra het geen live/cache-hit was.
  Fix (`UI.lua`): gedeelde helper `SMCWorldBossButtonText()` (vervangt de 2
  gedupliceerde label-plekken ~905/~1247; de builder kreeg zo ook de
  SavedVariables-fallback die alleen de refresher had): naam bekend via
  live/cache/kill-data → "World boss: %s"; alleen schedule-gok → nieuw
  "World boss: %s (open map ter bevestiging)"
  (`WB_SMC_BUTTON_UNCONFIRMED_FMT` ×6); helemaal niets bekend → oude
  "(open map)". Knop verbergt nu nooit meer een naam die Home wél toont.
- **Vervolg 7 (Rob-wens): per-slot vault-detail in de Account Snapshot.**
  Probleem: op een alt weet je niet meer welke gear-waarde al in elk
  vault-slot staat (moet ik nog tier 8+ delves doen?). Gebouwd in
  `AltOverview.lua`:
  - **Capture:** `BuildVaultCategorySnapshot` levert nu ook `slots[]` per rij
    (t=threshold, p=progress, l=geregistreerd activity-level, i=example-
    reward-ilvl via `GetExampleRewardItemHyperlinks`+`GetDetailedItemLevelInfo`,
    alleen voor ontgrendelde slots; nil als item nog niet gecachet — volgende
    save vult 'm, never lie). Helper `GetActivityRewardIlvl`.
  - **Opslag:** `vaultWorldSlots/vaultDungeonSlots/vaultRaidSlots` in de
    char-snapshot + opgenomen in de login-carry-over-lijst (geen clobber met
    lege data).
  - **Weergave:** vault-tooltip in Account Snapshot toont per rij nu per
    slot: "Slot N: ilvl X gear (level Y)" (groen), "ontgrendeld" zonder
    ilvl als het item nog niet gecachet was, of "vergrendeld — p/t" (grijs).
    Raid-rij toont bewust géén level (activity-level = difficulty-encoding,
    semantiek nog niet in-game geverifieerd; ilvl wél). Bestaande
    staleness-warning dekt ook de slot-data.
  - Semantiek van de ilvl: dit is Blizzards éigen example-reward van dat slot
    op snapshot-moment — dus exact "wat krijg ik nu uit dit slot", inclusief
    het effect van een hogere delve die het slot omhoog duwde. Zelfde bron
    als het Great Vault-blok op de Delves-tab (GetVaultProgress); de
    ilvl-API is daarop gelijkgetrokken (C_Item.GetDetailedItemLevelInfo
    eerst, legacy-global als fallback).
  - 5 nieuwe `ALT_VAULT_SLOT_*`-keys ×6 (audit 30 = 5×6). Let op frFR:
    bestaande regels daar bevatten onzichtbare NBSP-varianten — anker voor
    de insert was daarom ALT_VAULT_RESET_GLOW_HINT.
  - In-game test: op de main hover over de vault-kolom in Account Snapshot →
    per rij slot-regels met ilvl; log een alt in → de main-rij behoudt de
    slot-data; check dat de World-rij delve-tiers toont die kloppen met wat
    je deze week draaide.
- **Vervolg 8 (Robs review na reset):** (a) **Liadrin-IDs in-game bevestigd**:
  routine-regel sprong na het oppakken naar blauw "opgepakt" op Robs alt —
  de Wowhead-IDs (93766/93909/93910/93911) zijn hiermee geverifieerd. De
  intro-state toonde tegelijk correct op dezelfde alt zonder ritual-intro.
  (b) **Rode route-knop bij de World Boss** (Home, This week): button-pool
  uitgebreid naar kolom-blokken (`ui._layoutBtnIndex` gedeeld tussen full- en
  kolom-layout; breedte gecapt op kolombreedte); World Boss-sectie krijgt
  "Route naar %s"-knop via `ns.RouteToWorldBoss` — alleen getoond als de
  boss-entry échte coords heeft (functie weigert anders toch). Key
  `HOME_WB_ROUTE_BTN_FMT` ×6. (c) ~~Open check~~ ✅ **OPGELOST**: Rob had de
  Enchanting-weekly ná de reset opgepakt én gedaan — flag 93698 reset dus
  netjes wekelijks en de "done"-status klopte. Daarmee is ook de
  weekly-flag-semantiek-check uit iteratie 12 (7 juni, "woensdag hoort ✓
  terug naar ⏳ te springen") definitief bevestigd: de cyclus
  reset → todo → done is nu live gezien.
- **Vervolg 9 (Rob-wens): live weekly-voortgang op de Void & Rituals-tab.**
  De zone-weekly's "Strikes disrupted"-balk (en evt. de ritual-weekly-balk)
  nu als "(NN% gedaan)"-suffix achter de TODO-regels. Spiegelt het bewezen
  Showdowns-patroon: `ns.GetVoidAssaultWeeklyProgress()` (VoidAssaults.lua,
  loopt de zone-weeklies af, IsOnQuest → GetQuestProgressBarPercent) en
  `ns.GetRitualWeeklyProgress()` (RitualSites.lua, quest 95843). Beide
  pcall-guarded én filteren pct 0 weg: een quest zónder progressbar leest
  ook 0, dus 0 → nil → geen suffix (never lie; de TODO-tekst dekt
  "nog niet begonnen" al). WorldContent rendert de suffix; QUEST_LOG_UPDATE
  stond al in de refresh-events → loopt live mee tijdens strikes. 1 nieuwe
  gedeelde key ×6 (`WEEKLY_PROGRESS_PCT_FMT`).
- **Vervolg 10 (Robs review: tab te vol/scrollen): Void & Rituals krijgt twee
  weergaven.** Keuze Rob (via vraag): interne sub-tabs; status-view houdt
  week-status + hint, route-knoppen en een kórte challenge-lijst.
  Implementatie (`WorldContent.lua`), bewust zónder de layout-engine te
  herbouwen:
  - Twee panel-knoppen onder de subtitle: **"Deze week" | "Ritual Coach"**
    (actieve knop disabled); keuze account-breed bewaard in
    `ns.db.ui.worldViewMode`; scroll-anker verschoven naar onder de knoppen.
  - `ui.order`-entries hebben nu optioneel `mode` ("status"/"coach") +
    `dataDriven`; `Relayout()` verbergt wrong-mode widgets en toont
    right-mode niet-dataDriven widgets (dataDriven = refresh blijft eigenaar
    van show/hide; refresh draait altijd vóór Relayout). Ongetagd = beide
    views (accolades/renown/hub-knop).
  - **Status-view:** ritual-sectie (incl. hint + site-knoppen), void-sectie,
    Showdowns (12.0.7-gated; sd-infolines via `_mhSdLine`-vlag bij hun blok
    gehouden), plus nieuw: compacte challenge-lijst (alleen
    `BuildRitualChallengeTitle` per regel = icoon+naam+Spoils%, hoogste
    eerst) + verwijs-hint naar de Coach-view.
  - **Coach-view:** alle referentie (ritual/void-infobullets, site-scenario/
    notes, "How Ritual Sites work", volledige challenge-lijst met mechanics
    + unlock, share-knop).
  - 2 nieuwe keys ×6 (`WORLD_VIEW_STATUS`, `WORLD_VIEW_COACH_HINT`); de
    Coach-knop hergebruikt RITUAL_COACH_HEADER. RefreshLocaleUI ververst
    nav-labels + compacte lijst.
- **Vervolg 11: Halduron + Aethas geïdentificeerd (Rob, gossip-hercheck).**
  `GIVER_WEEKLIES` compleet: Halduron = **93761 "Windrunner Spire"**
  (rep-dungeon-weekly, 1000 rep naar keuze — per week een andere dungeon =
  ander ID, lijst groeit per gedumpte week; weekly-flags resetten dus
  "any" blijft correct); Aethas = **93600 "The Arena Calls" + 94836 "Late
  Night Training: Week 1 of 3"** (event-gebonden, kan er meerdere tegelijk
  aanbieden; "any" = klaar zodra er één is ingeleverd — bewuste keuze).
  Bijvangst geschrapt: 92600 "Cracked Keystone" bleek géén giver-weekly
  (item-start uit T11-delve, eens per season). Zelfde 7 IDs nu ook in
  `SMCChecklistData.weekly_hub.questIds` — de city-guide-checklistregel
  werkt daarmee voor het eerst.

**Release-docs klaar (10 juni):** `CHANGELOG.md` [Unreleased] aangevuld met
alle 10-juni-features/fixes (Cursor: hernoemen naar [1.6.0] bij de commit);
**`docs/CURSEFORGE_1.6.0.md`** = paste-klare release notes + upload-checklist
+ CF-regels (de eerdere afwijzingsreden — scripts in de zip — staat er
expliciet in); **`docs/CURSEFORGE_DESCRIPTION.md`** = volledig nieuwe
projectpagina-description (sterke punten bovenaan, wow-factor, EN) met
screenshot-volgorde-suggesties voor Robs nieuwe set. Robs smoke-test ✅
(incl. rare-kill zonder errors na de toast-fix).

**🚀 1.6.0 IS LIVE OP CURSEFORGE (10 juni, einde dag) — "live and kicking"
aldus Rob.** Post-release-checks ✅ (schone-map-smoke + paginarendering OK,
Rob 10 jun); feedback nog geen — in de gaten houden de komende dagen.
Volgende sessie: **Delve & Ritual Log** (bovenaan ROADMAP.md) + 12.0.7-prep
(release ~16/30 juni).

**🎯 CF-RELEASE VANDAAG (Robs expliciete vraag, 10 juni).** Release-checks:
woensdag-reset-semantiek ✅ (vandaag live bevestigd), Liadrin/Halduron/
Aethas-tracking ✅, blokjes-sweep ✅, 4-talen-lokalisatie ✅,
**Delve-share v2 solo-testmodus ✅ (Rob, 10 jun — laatste 0a-punt; alleen
de echte 2-speler-cross-locale-test blijft open, geen blokker)**. Nog vóór
de release: (1) Cursor: luacheck + commits van deze hele batch, (2) Rob:
korte smoke na /reload (routine-blok, beide Void & Rituals-views, vault-
tooltip-slots, taal-wissel). CHANGELOG
1.6.0-punten van vandaag, aanvullend op de eerdere lijst: reset-routine op
Home (+ route-lint), per-slot vault-detail in Account Snapshot, weekly
quest givers getrackt (Liadrin/Halduron/Aethas), Void & Rituals in twee
weergaven (Deze week | Ritual Coach), weekly-voortgang-%, world-boss-
routeknop, ritual-intro-hint, vault-popup sluit na waypoint, alle nieuwe
strings in 6 talen + blokjes-fixes.

- **Vervolg 12 — Broken Throne-research-sprint (Rob in-game + bronnen):**
  RitualTips ×6 bijgewerkt met: (a) scenario "A Corrupted Path" /
  Faithbreaker Ger'lok in BROKENTHRONE_PHASES (obelisk-verified; in-site
  banner heette "Void Reversal" — relatie nog verduidelijken, zie plan);
  (b) tier-ilvls T1 215 / T2 231 / T3 244 / T4 257 / T5 264 in INTRO_TIERS —
  let op: obelisk-tooltip zegt "Recommended", dus advies, geen harde eis;
  (c) Dark-Obelisk-coords in béide SITE_NOTES: Daggerspine 9 spawns,
  Broken Throne 6 ("onderzoek er 5 van de N") — bron: Robs lokale
  HandyNotes_RitualSites (liuyu, CF 1525494), overlay door Rob in-game
  tegen de werkelijkheid gecheckt; coords zijn feitelijke game-data,
  bron hier gedocumenteerd. (d) Tainted Bone Pile Zul'Aman 47.91/36.52
  in-game bevestigd. Method-gids-bijvangst in RITUAL_COACH_PLAN
  (NPC-coords, Patrols-questnaam "Misappropriated Treasures").
- **Vervolg 13 — ALLE 11 trainer-weekly-IDs binnen (Robs addon-truc #2):**
  Robs lokale **MidnightRoutine**-addon (ProfessionKnowledge.lua) bleek de
  complete per-prof weekly-tabel te hebben. Drievoudig gekruisvalideerd:
  ons in-game 93698 zit in z'n Ench-set {93697-99}, z'n trainer-coords
  matchen onze city-guide-pins, en z'n weekly-drop-flags 93528-93543
  matchen onze eigen Wowhead-research. `trainerQuests` is nu een LIJST per
  base-skillLine (sommige profs roteren varianten; "any"-semantiek):
  Alch 93690 · BS 93691 · Ench {93697-99} · Eng 93692 · Herb {93700-04} ·
  Insc 93693 · JC 93694 · LW 93695 · Mining {93705-09} · Skin {93710-14} ·
  Tailoring 93696. Consumers aangepast op lijst-vorm (backward-compat met
  oude single-ID): `ProfessionsHub.BuildWeeklyText` en
  `ResetRoutine.OwnedProfTrainerWeeklies`+trainer-stap. Effect: de
  "This week"-Hub-regel en de routine-stap werken nu voor álle profs; de
  grijze "niet getrackt"-regel verdwijnt. In-game spot-check (Rob): doe op
  de main de Tailoring-service-quest (93696) → regel hoort groen te worden.
- **Vervolg 14 — combat-lockdown-fix MidnightToast (Robs smoke-test!):**
  login direct in een rare-gevecht gaf `ADDON_ACTION_BLOCKED:
  SetPropagateMouseClicks` (MidnightToast.lua:148 via Rares→QueueToast).
  Oorzaak: het toast-frame werd lazy aangemaakt bij de éérste toast — die
  kan mid-combat vallen, en SetPropagateMouseClicks/-Motion zijn
  combat-protected. Fix: (a) **eager creation** — `EnsureToastFrame()`
  onderaan het bestand (addon-load = laadscherm = nooit lockdown, setters
  draaien precies één keer veilig); (b) belt-and-braces: de drie setters
  achter `not InCombatLockdown()` (worst case mist de toast
  click-propagation i.p.v. een blocked-error). Hertest: log in een char
  die direct aggro heeft / spawn een rare-toast in combat → geen error.
- **Cursor: luacheck/loadfile op ResetRoutine.lua, HomeDashboard.lua,
  VaultReminder.lua, SMCChecklistData.lua, UI.lua, AltOverview.lua,
  VoidAssaults.lua, RitualSites.lua, WorldContent.lua, RitualTips.lua,
  ProfessionAcademyData.lua, ProfessionsHub.lua, MidnightToast.lua + de 6
  hoofd-locales.** In-game test: zie TOMORROW.md.

## Voor Cursor — commit + push batch 10 juni avond (commits `9b8dca1` /
`77581cc` / `1ca4eb5` / `07cbc48` / `TBD5`)

**Geen CF-release** — werk richting 1.7.0; release alleen op expliciete vraag Rob.

## Voor Cursor — review + commit batch 10 juni avond (Dungeon Coach fase 1+2)

Nieuw initiatief ná de 1.6.0-release; design + besluiten in
**docs/DUNGEON_COACH_PLAN.md** (Rob koos: eigen tab, share-generalisatie
later in de share-fase, content zelf schrijven met BossHelper (MIT) als
kruisreferentie, fase 1+2 samen → review). Voorgestelde opdeling in 2 commits:

1. **Plan + roadmap:** `docs/DUNGEON_COACH_PLAN.md` (nieuw),
   `docs/ROADMAP.md` (Dungeon Coach-blok + trainer-IDs ✅).
2. **Fase 1+2 — Dungeons-tab:** `Modules/DungeonRosterData.lua` (nieuw:
   launch-8 + S1-legacy-4, EJ-IDs uit BossHelper/Method — 4 launch-only
   dungeons hebben journalInstanceID/encounterID nil tot Robs EJ-dump;
   weekly-hooks spark 93911 / keystone 92600 / Halduron-map 93761),
   `Modules/DungeonGuide.lua` (nieuw: 3 views Deze week | Dungeons 101 |
   Coach; push/Relayout-engine met mode-tags; 101 = 6 hoofdstukken met
   per-char vinkjes in `ns.db.dungeonCourse[guid]`; coach = roster met
   EJ-namen runtime + eerlijke "tips coming soon"), `Locales/DungeonGuide.lua`
   (nieuw, 40 keys ×2 EN/NL — audit 80 ✓; rest valt terug op EN zoals
   StartHere destijds), `UI.lua` (sidebar week-sectie + TAB_DEFS +
   build-dispatch + SelectTab-refresh, 13→14 tabs), TOC (3 regels).

**Roster EJ-compleet (Robs dumps, zelfde avond):** alle 12 journal-instance-
IDs binnen — **Magisters' Terrace = 1300** (Midnight-revamp; BossHelpers 249
was het legacy-TBC-entry, gecorrigeerd), Murder Row 1304, Den of Nalorakk
1311, The Blinding Vale 1309, Voidscar Arena 1313. De kleine boss-nummers
uit Robs EJ-overlay (3101-3287) bleken **dungeonEncounterIDs**
(ENCOUNTER_START/DBM-type; EJ_GetEncounterInfo = nil) → eigen veld
`dungeonEncounterID` per boss (straks de kill-detectie voor het Dungeon
Log). Bossnamen lokaliseren nu via journal-ID óf **per index in de
journal-instance** (`GetDungeonBossName(b, d, index)` — volgorde in onze
data gelijk aan EJ, geverifieerd op Robs screenshots) → journal-encounter-
IDs zijn niet meer nodig voor weergave.

**Prof-weekly-fix (zelfde avond, Robs veldwerk):** Robs Herbalism-weekly
"Traditional Harvests" (Botanist Nathera, item 263462 +3 KP) bevestigt de
MidnightRoutine-set in-game (itemID matcht Herbalism {93700-93704}; Robs
flag-dump: 93700-93703 false, **93704 true** — actieve variant deze week,
flags werken, "any"-semantiek bevestigd). Maar de routine stuurde 'm voor
Alchemy naar de tráiner terwijl craft-profs hun "service quest" bij het
**Work Order-station** halen → nieuw `weekly.serviceProfs`-set in
ProfessionAcademyData (Alch/BS/Eng/Insc/JC/LW/Tailoring) en ResetRoutine
routeert + verwoordt de pickup per soort: service → station-pin +
`HOME_ROUTINE_SERVICE_PICKUP_FMT` (×6, noemt ook de Flaresworn-intro +
skill-eis), trainer-soort (Ench + gatherers) → trainer-pin zoals het was.

**Shard-cap-toast (Rob-wens, zelfde avond):** `Modules/ShardCapAlert.lua`
(nieuw, in TOC) — éénmalige toast + chatregel per character zodra de
weekly Coffer Shards-cap (currency 3310, `quantityEarnedThisWeek >=
maxWeeklyQuantity`) bereikt is, zodat je weet dat verder rares/WQ's farmen
voor shards zinloos is. Herhaalt pas ná de weekly reset (per char
opgeslagen in `ns.db.shardCapAlert[guid] = reset-anker`; geen anker
leesbaar → liever stil dan fout). Checkt op CURRENCY_DISPLAY_UPDATE + 5s
na PLAYER_ENTERING_WORLD (char die al gecapt inlogt krijgt 'm ook). 3
keys ×6 (SHARD_CAP_TOAST_TITLE_FMT/_BODY + SHARD_CAP_CHAT_FMT). In-game
test: cap de 600 op je huidige char (je bent er net mee bezig!) → toast +
chatregel precies één keer; /reload erna → stil; volgende week na reset →
kan opnieuw.

**Cursor: luacheck/loadfile op DungeonRosterData.lua, DungeonGuide.lua,
Locales/DungeonGuide.lua, UI.lua, ResetRoutine.lua,
ProfessionAcademyData.lua, ShardCapAlert.lua + de 6 locales + TOC-parse.**
Mount-truncatie blijft — host-bestanden leidend.

**In-game test (Rob):** nieuwe Dungeons-tab onder Delves & Vault; drie
view-knoppen wisselen zonder gaten; Deze week: Spark-regel klopt met je
log, "Dungeon van de week: Windrunner Spire" (je hebt 93761 opgepakt),
Cracked Keystone-status, vault-rij; 101: hoofdstukken lezen + vinkjes
blijven na /reload en zijn per char; Coach: 12 dungeons in 2 groepen,
EJ-namen gelokaliseerd (wissel even van taal), launch-only-4 tonen
EN-fallbacknamen. Daarna dumpen: `/dump EJ_GetInstanceInfo(1315)`-spot-check
+ de EJ-IDs van Murder Row / Den of Nalorakk / Blinding Vale / Voidscar
(open de Adventure Guide op die dungeon en `/dump EJ_GetInstanceInfo(EJ_GetInstanceByIndex(i, false))`
of vraag mij om de scan-macro).

## Open / volgende stappen (vervolg)

0a. **✅ Delve-share v2 (commit `a77fd44`) — klaar voor CF-release.** Nog
    open vóór release: solo-testmodus-check (blauw "(test)"-blok) en echte
    cross-locale-ontvangst zodra twee spelers de nieuwe versie draaien.

0b. **✅ CF-release 1.6.0 (10 juni, Robs expliciete vraag).** Zip via
    `tools/package.ps1`; upload door Rob met `docs/CURSEFORGE_1.6.0.md` +
    `docs/CURSEFORGE_DESCRIPTION.md`. Woensdag-reset-semantiek ✅;
    Delve-share v2 solo-test ✅; cross-locale 2-speler-test blijft open
    (geen blokker).

0. **Showdowns vervolg:** Showdown-weekly-regel in AccountWeeklyChecklist ✅
    (`9dcdf64`); nog Folio-mote zodra ID bekend; Home-dashboard kan
    `ns.GetActiveShowdownZoneName`/`ns.IsShowdownWeeklyDone` hergebruiken;
    Val-data + Voidstorm-portaal-mapID invullen na volgende PTR-rotatie.

1. **12.0.7 content** (release ~16 juni, mogelijk 30 juni): Void-zones Naigtal & Val + Escalations (VoidAssaults/WorldContent), world boss Nexus-Captain Leth'ir + Heroic World Tier (WorldBoss), Omnium Folio/Runes weekly (checklist + Codex), Sporefall raid (Codex/vault), Great Vault tooltip-rework verifiëren op PTR. Bij release: `120005` uit TOC.
2. **Backlog (laag, uit review):** `SetVaultReminderOption` popup-backfill voor upgraders; SMC-grid reflow; info-drawer inline; search-UX; compact-mode double-shrink. (Debounce, keybind-namespace, VaultAdvisor dode branch, VaultReminder isCurrent en ts==0-guards: gedaan in Fase 4c.)
3. **Reviewpunt:** ts vs aparte `vaultTs` bij login-restore (Fase 1-tradeoff, Cursor akkoord met huidige aanpak).
