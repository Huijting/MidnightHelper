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
- **⭐ CF-RELEASE = ALTIJD in-game changelog (Rob, 16 jun, expliciet):** zodra Rob om een
  CurseForge-release vraagt, MOET het in-game changelog-blok voor die versie gemaakt/bijgewerkt
  worden (`Modules/Changelog.lua` `CHANGELOG_ENTRIES` + `CHANGELOG_<ver>_*`-keys in enUS+nlNL),
  naast `CHANGELOG.md` + `docs/CURSEFORGE_<ver>.md`. Niet-onderhandelbaar onderdeel van elke release.
- **In-game changelog meeschrijven (vaste regel, 16 jun):** elke feature-batch werkt
  `Modules/Changelog.lua` (`CHANGELOG_ENTRIES`) + `CHANGELOG_<ver>_*`-keys in enUS+nlNL in
  DEZELFDE commit bij. 1.8.0 stond t/m 1.5.5 stale → nu gevangen door de dev-zelfcheck
  (`MidnightHelperDB.changelogDevCheck=true` waarschuwt bij login). Zie `docs/RELEASE_CHECKLIST.md`.
- Vault-enum mapping (`[1]=dungeon, [3]=raid, [6]=world`) is **correct** (Enum.WeeklyRewardChestThresholdType: None=0, Activities=1, RankedPvP=2, Raid=3, World=6) — niet "fixen".

## Voor Cursor — review + commit batch 16 juni #3 (boss-venster: target-reopen + auto-open-toggle) → 1.8.2

**STATUS: ⏳ UNCOMMITTED (Claude/Cowork).** Aanleiding (Rob, 16 jun): "als je het boss-venster
wegklikt en daarna een boss target, laat hem dan weer zien — wie hem niet wil zet hem uit in de
instellingen." Die settings-opt-out bestond nog niet, dus die is meteen toegevoegd. Voorgesteld
commit-bericht:

> feat(bosswin): target-reopen op npcID + persistente 'auto-open'-toggle (settings)

Wijzigingen:
- **`Modules/DungeonBossWindow.lua`**: (1) nieuwe `ns.IsBossWindowAutoOpenEnabled` /
  `ns.SetBossWindowAutoOpenEnabled` (db: `ui.bossWin.autoOpen`, default aan). (2) `BossWindowOnEncounter`
  returnt vroeg als auto-open uit staat. (3) onderaan een `PLAYER_TARGET_CHANGED`-frame: bouwt
  `NPC_TO_BOSS` (reverse uit de bestaande `CREATURES`-tabel = model-creature-IDs, dus locale-onafh.),
  pakt npcID uit `UnitGUID("target")` (veld 6), gate op `IsInInstance()=="party"`, en bij een hit:
  `suppressedFor=nil` (heft de X-suppress op) + `ShowDungeonBossWindow(dungeonKey, bossKey)`. Throttle:
  niet opnieuw tonen als 't venster al op precies die boss staat (geen flikker / focus-steal).
- **`Modules/SettingsPage.lua`**: `AddToggle` "Automatisch openen" in de Dungeon Coach-sectie (onder
  SET_BOSSWIN_DESC), gekoppeld aan de getter/setter.
- **`Locales/SettingsPage.lua`**: `SET_BOSSWIN_AUTO_TITLE` + `SET_BOSSWIN_AUTO_DESC` in alle 6 locales;
  `SET_BOSSWIN_DESC` herschreven (X = stil voor de run; targeten haalt 'm terug).
- **Secret-value crash-fix (Rob meldde 5× error in een ritual):**
  `Modules/RitualBossCoach.lua` `NpcIdFromGUID` deed `strsplit` op `UnitGUID("boss1..5")` — in 12.x
  zijn die GUID's 'secret' (`type()`=="string" maar string-ops tainten/crashen). Toegevoegd: file-locale
  `IsSecretValue` (= DelveBossShowcase-patroon, `issecretvalue`), guard op de guid én op `UnitName`
  (ook secret). Datamine-leren faalt nu stil i.p.v. crashen (never-lie: niet gokken).
- **Zelfde guard in de nieuwe target-trigger** (`DungeonBossWindow.lua`): `TargetNpcID` checkt
  `IsSecretValue(guid)`. **Plus fallback**: omdat target-GUID's in instances waarschijnlijk óók secret
  zijn (Rares.lua slaat instances bewust over), heropent een target met `UnitClassification=="worldboss"`
  (niet-secret) het venster alsnog — op de boss die nu vooraan staat — als de npcID niet leesbaar is.
- **In-game changelog (Robs vaste regel)**: `Modules/Changelog.lua` nieuw **1.8.2**-blok +
  `CHANGELOG_182_1/2/3` in enUS+nlNL (de/fr/es/pt via SafeL → EN). ⚠️ TOC staat nog op **1.8.1**;
  bump naar 1.8.2 pas bij de volgende release (geen CF-release gevraagd).

Verificatie: host-Read = leidend (de sandbox-mount gaf wéér stale/afgekapte reads — pyread==stat maar
inhoud was een oude, kortere versie; "near <eof>"-valsposities genegeerd). Ingevoegde Lua-blokken +
locale-entries los gecompileerd (lupa) = OK. **In-game test (Rob):**
1. Ritual opnieuw in → geen Lua-error meer (boss-units worden stil overgeslagen als hun GUID secret is).
2. Dungeon in → boss-venster met X sluiten → een boss targeten → venster komt terug (op die boss als de
   GUID leesbaar is, anders via de worldboss-fallback op de huidige boss).
3. Settings → Dungeon Coach "Automatisch openen" uit → geen pull-open én geen target-open;
   `/mh bosswin` opent nog wel.
⭐ **Te bevestigen door Rob:** is `UnitGUID("target")` op een dungeon-boss secret of niet? Zo niet →
exacte boss-sprong werkt; zo wel → de worldboss-fallback draagt de feature. Beide paden zijn nu safe.

**Vervolg (Rob 16 jun, na test): suppress nu PER BOSS i.p.v. per run.** Rob meldde: in een ritual het
venster weggeklikt bij fase 2 → bij de volgende boss(en) kwam geen nieuw venster. Oorzaak: de X zette
suppress voor de hele entry/dungeon, dus elke volgende boss bleef onderdrukt (rituals lopen via
RitualBossCoach-stages, niet via mijn `IsInInstance()=="party"`-target-trigger). Fix in
`DungeonBossWindow.lua`: `suppressedFor` is nu een composiet `"dungeonKey\31bossKey"` (helpers
`SuppressKey`/`CurBossKey`). De X onderdrukt enkel die ene boss; `BossWindowOnEncounter` en
`ns.IsBossWindowSuppressedFor(dungeonKey, bossKey)` vergelijken op de composiet en wissen suppress bij
een andere boss. `RitualBossCoach.lua` geeft nu `b.key` mee aan `IsBossWindowSuppressedFor`. Netto: X =
"deze boss even weg", de volgende boss (pull, ritual-stage of targeten) komt vanzelf terug; permanent
uit blijft de settings-toggle. Compile + runtime-asserts (lupa) OK. **In-game test (Rob):** ritual →
venster wegklikken bij boss 1 → boss 2 geeft weer een vers venster; idem in een dungeon over twee bosses.

**Toevoeging (Rob 17 jun): nieuwe Omnium Folio-tab (12.0.7 rune-advisor).** Eerst web-geverifieerd
(zie `docs/PATCH_12_0_7_ADVICE.md` — Gemini's rune-tree klopte, unlock-NPC/locatie + Sporefall/Showdown-
namen gecorrigeerd, account-vs-char blijft open). Nieuw:
- `Modules/OmniumFolioData.lua` — data-only: 5 rijen + 13 runes (Wowhead spell-IDs), unlock-questketen
  96410/96441-96444, en per-content-type aanbevelingen (M+/Raid/PvP/World; "spec" = volg spec-stat).
- `Modules/OmniumFolio.lua` — tab-paneel naar TierSet-sjabloon: scroll + read-only EditBox, {spell}-links
  via `ns:GetSpellLinkMarkup` + `AttachDelveTipHyperlinksToEditBox` (hover-tooltips), segmented
  M+/Raid/PvP/World-knoppen (actief = LockHighlight, keuze in `ns.db.omniumMode`), live "x/5 rijen
  ontgrendeld"-teller uit `C_QuestLog.IsQuestFlaggedCompleted` (pcall, taint-veilig). Gate
  `ns.IsOmniumFolioAvailable()` = toc ≥ 120007.
- `Locales/OmniumFolio.lua` — enUS+nlNL (merge-patroon; de/fr/es/pt via SafeL → EN). Rune-namen zijn
  fallback-labels; live spell-tooltip wint.
- Bedrading: `MidnightHelper.toc` (Locale + 2 Modules na TierSet), `UI.lua` TAB_DEFS `omnium` na `tier`
  + panel-build-branch + `SidebarTabVisible`-gate (≥120007). In-game changelog `CHANGELOG_182_4` (en/nl).
- ⚠️ **FIX (Rob 17 jun, tab kwam niet): `omnium` óók in `SIDEBAR_SECTIONS` zetten.** De gegroepeerde
  sidebar (UI.lua `SIDEBAR_SECTIONS`, ~regel 269) rendert ALLEEN tabs die in een sectie-`ids`-lijst staan;
  `TAB_DEFS` maakt enkel het paneel + de knop-frame, niet de plek in de sidebar. `omnium` toegevoegd aan
  de `character`-sectie (`{ "account", "delvelog", "enchants", "tier", "omnium" }`). Build 120007 bevestigd
  door Rob, dus de gate was 't niet. `layoutTab` respecteert `SidebarTabVisible`, dus op <120007 blijft-ie
  verborgen. → Edit aan bestaand UI.lua, dus een gewone `/reload` toont de tab (geen herstart meer nodig;
  de nieuwe module-bestanden laadden al bij Robs eerdere herstart).
- Verificatie: 3 nieuwe bestanden los gecompileerd (lupa) = OK, geen truncatie (bytes==stat, staart heel);
  UI.lua-snippets los gecompileerd = OK. **In-game test (Rob):** tab "Omnium Folio" verschijnt op
  12.0.7; spell-links hoveren tonen tooltips; M+/Raid/PvP/World wisselt de "<- aanbevolen"-markering;
  teller toont je voltooide Folio-rijen. ⚠️ Bevestig of de unlock-teller per-char of account-breed telt
  (open discrepantie) → tekst claimt het niet hard.

**Toevoeging (Rob 17 jun #2): addon-kruischeck + 2 kleine fixes (mee in 1.8.2).**
- **Pertinax-datacorrectie** (`ShowdownsData.lua`): Val world boss npc **263670 → 261072** + killquest
  **96473** (Zygor 9.6 DB-kruischeck; 263670 bestond niet = was fout). Codex-comment ook bijgewerkt.
  Zie de "Addon-kruischeck 17 juni"-sectie in `docs/PTR_12.0.7_DATA.md` (+ Mote of Omnial = spell 1294322
  via Plumber, in-game bevestigd; Nalorakk-creature-ID blijft open).
- **Vault-advisor: drempel-bewuste tier-note** (`VaultAdvisor.lua`). Aanleiding: Rob zag de advisor de
  trinket boven een tier-helm zetten terwijl hij 2 tier-stukken heeft (Pawn telt set-bonussen niet mee).
  De generieke tier-note is nu drempel-bewust: nieuwe `PlayerHasTierInSlot` (same-slot-swap-check) +
  herschreven `BuildTierWarningText` → "voltooit je 2-/4-set — pakken" vs "3/5, geen nieuwe bonus tot
  4-set". Keys `VAULT_ADVISOR_TIER_COMPLETES_FMT`/`_PROGRESS_FMT`/`_MAXED_FMT` (en+nl). Runtime-asserts
  (lupa) OK voor 1→2/2→3/3→4/4→5/same-slot/geen-telling.

**Toevoeging (Rob 17 jun #3): Folio-weekly in de account-checklist.** Rob: de Folio-weekly werd niet
gemeld terwijl 't wel een wekelijkse "doe-dit-eerst" is. Gebouwd: `ns.GetOmniumFolioWeeklyStatus`
(`OmniumFolio.lua`) — account-brede status die de keten-telling + eerstvolgende reset in `ns.db.omniumWeekly`
bijhoudt; "pending" zolang deze week's Mote niet geclaimd is, vervalt na de reset, verdwijnt bij 5/5.
`AccountWeeklyChecklist.lua`: `folioWeekly` in de compute-return + een gouden regel vooraan (boven Vault)
met tooltip, alleen als `pending`. Keys `ACCOUNT_WEEKLY_FOLIO_FMT/_TT_TITLE/_TT_BODY` (en+nl). ⚠️ Eerste
meting na install kan "pending" tonen ook al deed je 'm al (geen historie) — zelfcorrigeert na de reset.
Detector runtime-getest (lupa): eerste-run/claim/reset-rollover/5-5 allemaal correct. Ook de Omnium-tab-
tekst (intro+voet) bijgewerkt naar account-breed + juiste unlock-start (Icy Veins 16 jun), en de
in-game-changelog `CHANGELOG_182_4` uitgebreid.

**Toevoeging (Rob 17 jun #4): volledige 6-taals-lokalisatie vóór upload.** Alle nieuwe 1.8.2-strings
nu in de/fr/es/pt naast en/nl: hele Omnium-tab (`Locales/OmniumFolio.lua` kreeg 4 merge-blokken —
UI + alle 13 effect-omschrijvingen vertaald; rune-NAMEN blijven EN = eigennaam + live spell-tooltip
toont de gelokaliseerde naam; `{FOLIOSTART}`-token in elke INTRO behouden), de 3 vault-tier-keys
(`VAULT_ADVISOR_TIER_COMPLETES/PROGRESS/MAXED_FMT`) en de 3 Folio-checklist-keys
(`ACCOUNT_WEEKLY_FOLIO_FMT/_TT_TITLE/_TT_BODY`) in deDE/frFR/esES/ptBR. SettingsPage-boss-keys waren al
6-talig. Alles los gecompileerd (lupa) inкl. de Franse apostrofs/accenten = OK. ⚠️ De in-game
changelog-popup (`CHANGELOG_*`) blijft bewust en+nl met EN-fallback — bestaand patroon voor ÁLLE versies
(RELEASE_CHECKLIST). Niet veranderd; alleen vertalen als Rob dat expliciet wil (dan ook 1.6-1.8.1 mee).

**Release-status:** 1.8.2 is nu een volwaardige feature-patch (boss-venster-verbeteringen + secret-fix
+ Omnium Folio-tab + Folio-weekly-checklist + vault-advisor-tier-note + Pertinax-datafix), volledig
6-talig. Release-artefacten staan klaar:
`CHANGELOG.md` [1.8.2], `docs/CURSEFORGE_1.8.2.md`, `docs/CURSEFORGE_DESCRIPTION.md` (1.8.2-refresh),
in-game changelog `CHANGELOG_182_1..5`. **Open bij release (Cursor):** TOC `## Version:` → 1.8.2 +
`120005` uit de Interface-regel, dan build (`package.ps1`) + upload. Nu nog uncommitted/geen release.

## Voor Cursor — review + commit batch 16 juni #2 (UX Tier-1a: visuele rust) → 1.8.1

**STATUS: ✅ GECOMMIT in checkpoint `e995124` (wip 1.8.1).** (Eerste increment van een gefaseerde
UX-refresh; Rob koos de volle scope maar wil per fase kunnen reviewen/terugrollen.) Bericht:

> style(ui): Tier-1a visuele rust — gedeeld palet, rustige links, rol-iconen i.p.v. kleur-regenboog

Aanleiding: 3 review-agenten (IA + visueel + consistentie) — addon voelt "te druk": te veel tabs,
~13 concurrerende kleuren, een paar oude panelen met afwijkende chrome. Volledige synthese +
3-tier-plan in dit gesprek. Dit is Tier-1a (laag risico, alleen kleuren/witruimte):
- **`UI.lua`**: nieuw gedeeld palet `ns.UI_COLORS` (1 goud E8C36A, 1 dim-grijs, body, footer,
  status good/warn/bad, link-blauw) — RGB + *_HEX. Panelen gaan hier stap voor stap uit lezen.
- **`DelveTipMarkup.lua`**: rustiger link-tinten — item `1eff00`→`9ccf8a`, currency `ffd200`→`e8c36a`
  (spell blijft `71d5ff`). Haalt de neon weg.
- **`DungeonGuide.lua`**: de tank/healer/dps-**kleur-regenboog** vervangen door **rol-ICONEN**
  (`INLINE_TANK/HEALER/DAMAGER_ICON`) + neutrale tekst; boss-naam naar palet-goud. = de grootste
  rustgever (en duidelijker voor beginners).
- **Spacing** `SetSpacing(4)`→`6` in CurrencyGuide/TierSet/GearEnchant; gold-headers in TierSet/
  GearEnchant-code naar `e8c36a`.

host-Read bevestigt alle edits gebalanceerd; lupa OK voor DelveTipMarkup/GearEnchant/CurrencyGuide
(DungeonGuide/TierSet gaven weer de mount-truncatie-"near <eof>"-valspositieven — host is leidend).

**Toevoeging (Rob 16 jun): klikbare vendor-namen → TomTom-waypoint, addon-breed.**
`DelveTipMarkup.lua`: centrale `ns.VENDOR_WAYPOINTS` (naam → uiMapID/x/y: Maren/Triam/Cuzoth/
Vaskarn/4 QM's/4 PvP-vendors), `ns:SetMapWaypoint`, `ns:GetWayLinkMarkup`, `ns:LinkifyVendors`
(wikkelt bekende namen in een `|Hmhway:..|h`-link, magic-chars geëscaped), plus een `{WAY:mapID:x:y:Label}`-
token. `ExpandDelveTipMarkup` draait nu auto-linkify; de EditBox-handler vangt `mhway:` → waypoint
(hover toont naam + "Klik = waypoint"). `CurrencyGuide.BodyText` roept `LinkifyVendors` aan → de
namen in de Valuta-tab zijn nu klikbaar. **Herbruikbaar:** elke tekst via de markup linkt deze namen
vanzelf. (De QM-knoppenrij onderaan Currencies is nu strikt genomen overbodig — kan later weg.)

**✅ Tier 1 afgerond (16 jun, Rob: "leef je uit").** Bovenop de eerste increment:
- **Goud-unificatie:** `|cffffd100`→`|cffe8c36a` in alle 6 locales (replace_all); panel-header-
  constants `{0.82,0.68,0.30}`/`{1,0.82,0.0}`→`{0.91,0.76,0.42}` in DungeonGuide/HomeDashboard/
  DelveHistory/MidnightCodex/StartHere/EventsPanel + UI.lua sidebar-header + RitualSites infoHeader.
- **Subtitel:** SMC warm-grijs `{0.92,0.85,0.68}`→koel `{0.75,0.78,0.82}` (= de nieuwe-panelen-stijl).
- **Status ontzadigd:** DungeonGuide GOOD/WARN naar palet; GearEnchant `ff5555`→`e66b6b`,
  `73d873`→`8cd98c`.
- **Klikbare vendor-namen** (zie hierboven) live in Currencies.
Alleen kleur/getal/string-edits → geen syntax-risico. Restje optioneel: header→body-gaps ruimer.

**Twee Rob-wensen (16 jun):**
- **Tooltips bij de muis.** De link-hover-tooltips (DelveTipMarkup `ShowDelveTipHyperlinkTooltip`)
  stonden via `ANCHOR_RIGHT` rechtsboven het MH-venster → nu **`ANCHOR_CURSOR`** (volgt de muis).
  Dekt alle spell/item/currency/vendor-link-hovers in de panelen. ⏳ Rest van de tooltip-ankers
  (rij/knop-tooltips, ~20 `ANCHOR_RIGHT`-plekken) → meenemen in de Tier-2-consistentiepass.
- **Rare-doodshoofd.** `Rares.lua`: op `NAME_PLATE_UNIT_ADDED` krijgt een bekende rare (npcID in
  ZONES veld 6 of geleerd) een **Skull-raidmarker** (`SetRaidTarget(unit,8)`), wereld-only, alleen
  als nog niet gemarkeerd, opt-out via `ns.db.rareSkull=false`. Werkt solo/in combat (niet protected,
  pcall-guard voor groep-zonder-assist). Set groeit mee met de npcID-learning. (Settings-toggle later.)
  **Verfijnd (Rob 16 jun):** de auto-nameplate-match miste rares zonder bekend npcID. Nu vlagt een
  **toast-klik/route** de gejaagde rare expliciet (`ns.MH_FlagRareForSkull`, live npcID uit
  `FireRareAlert`): skull meteen als 'ie zichtbaar is (`MarkVisibleRareByNpc` scant nameplates),
  anders zodra z'n nameplate verschijnt (`PENDING_SKULL`). RouteRare vlagt ook via KnownRareNpc.
  ⚠️ **BUGFIX (Rob 16 jun): `SetRaidTarget` is PROTECTED** → gaf 3× ADDON_ACTION_FORBIDDEN
  (Rares.lua:220/261, ook door pcall heen). Vervangen door een **eigen skull-texture op de
  nameplate** (`UI-RaidTargetingIcon_8`, taint-veilig, à la RareScanner): `ShowSkullOnNameplate`/
  `RefreshNameplateSkull`/`HideNameplateSkull` op NAME_PLATE_UNIT_ADDED/REMOVED (nameplate-hergebruik
  afgevangen). Geen protected calls meer.

## Voor Cursor — batch 16 juni #3 (UX Tier-2a: tooltips overal bij de cursor) → 1.8.1

**STATUS: ✅ GECOMMIT in checkpoint `e995124` (wip 1.8.1).** `"ANCHOR_RIGHT"`→`"ANCHOR_CURSOR"` (string-swap, geen syntax-risico) in alle
paneel-tooltips: UI.lua, Rares, EventsPanel, MidnightCodex, DawncrestGuide, DelveCuriosAdvisor,
AltOverview, DelveCoach, AccountWeeklyChecklist, Addons/Guide, GuideConsumables, WorldBoss,
Profession, DelveItemsPopup, VaultAdvisor, KeyboardLayoutPrototype, RoleAcademy, Delves
(+ eerder DelveTipMarkup link-hovers). Broker/LDB-tooltip bewust gelaten (hoort bij de minimap-knop);
ANCHOR_TOPRIGHT/BOTTOM/TOP/LEFT/NONE niet geraakt (andere literals).

**Tier-2b SMC-gids geharmoniseerd (16 jun, laag risico, géén scroll-logic aangeraakt):** de
**border-box** rond de SMC-scroll (`smcRim`) onzichtbaar gemaakt — die boxte de gids in en liet 'm
"als een andere addon" ogen (geen ander paneel heeft 'm). De donkere scroll-fill `0.04/0.042/0.055`
→ `0.048/0.05/0.062` (= `MH_CHROME.contentWell`, gelijk aan de rest). Titel/subtitel waren al
geharmoniseerd (Tier 1). De custom Slider zelf is een dunne neutrale scrollbar (niet luid) → gelaten.

**Tier-2 user-zichtbare doelen nu behaald:** tooltips bij cursor, één goud, SMC niet meer geboxt,
subtitels gelijk. **Optioneel later (code-netheid, lager rendement/hoger risico):** gedeelde
`ns.MakePanelHeader`, SMC-Slider → `UIPanelScrollFrameTemplate`, padding via `UI_METRICS`.
**✅ Tier 3 — Simpele modus (16 jun).** `UI.lua`: `SIMPLE_MODE_TABS` = {starthere, home, delves,
dungeons, world}; `MHSimpleModeOn()` (standaard AAN, nil=aan; expliciet `ns.db.simpleMode=false`
= volledig). `SidebarTabVisible` verbergt niet-kerntabs in simpele modus. **Toggle-knop bovenaan
de sidebar** (`MidnightHelperSimpleToggle`) flipt `ns.db.simpleMode` + `RelayoutSidebarTabs()`;
label "+ Toon alle tabs" / "− Eenvoudige weergave" (`SIDEBAR_SHOW_ALL`/`SIDEBAR_SIMPLE` ×6 talen).
Geselecteerde-tab-redirect veralgemeniseerd → onzichtbare tab valt terug op Home. **Niets verwijderd,
volledig reversibel** (toggle + git). **Default = VOLLEDIG (Rob 16 jun):** `MHSimpleModeOn()` = `ns.db.simpleMode == true` (nil = volledig).
Iedereen start met alle tabs; simpel is opt-in via de toggle (label "− Eenvoudige weergave" in
volledige modus / "+ Toon alle tabs" in simpele). Flip = `not MHSimpleModeOn()`. Account-breed
(`MidnightHelperDB`), dus één klik = voorgoed op alle characters.
⚠️ **Bugfix (Rob screen 1):** RelayoutSidebarTabs raakte tabs in volledig-verborgen secties niet
aan → die bleven op hun creatie-positie staan (overlap bij eerste view). Nu worden bij elke relayout
éérst álle `ns.tabButtons` verborgen, daarna de zichtbare opnieuw geplaatst.

Daarmee zijn **Tier 1 + 2 + 3 klaar** — de hele "minder druk / aantrekkelijker"-wens. Optioneel
later: gedeelde `ns.MakePanelHeader`, SMC-Slider→template, Settings-checkbox als alternatief voor
de sidebar-toggle, één-malige login-hint bij simpele modus.

## Voor Cursor — review + commit batch 16 juni #1 (Tier Sets-tab) → 1.8.1

**STATUS: ✅ GECOMMIT in checkpoint `e995124` (wip 1.8.1).** Eerste **1.8.1**-batch (NÁ de 1.8.0
CF-release). TOC is bij deze checkpoint naar **1.8.1** gebumpt (1.8.0 staat live op CF).

Voorgesteld bericht:

> feat(tier): Tier Sets-tab (uitleg + per-spec bonussen + live 2/4-set-teller)

Robs wens: "tier set gear — als we 't doen, goed: allebei de niveaus." Plaatsing (Rob gekozen):
**Character-sectie** (naast Account/Delve Log/Enchants).

**`Modules/TierSetData.lua` (nieuw)** — `ns.TIER_SLOTS` (1/3/5/10/7), `ns.TIER_SET_BY_CLASS`
(13 set-namen, Blizzard-blog/Icy-Veins), `ns.TIER_SPEC_BONUS` (2/4-set spell-IDs per **stabiele
specID**, Wowhead 12.0.7-PTR). DH-spec **Devourer** bewust weggelaten (nieuwe spec, specID nog
onbevestigd → never-lie).

**`Modules/TierSet.lua` (nieuw)** — paneel (kloon van Enchant/Currency-stijl):
- **Niveau 1**: gelokaliseerde uitleg (`TIER_GUIDE_BODY`) — wat tier is (5 slots, 2/4-set), hoe je
  't krijgt (Voidspire-tokens bazen 2–5 + slots, Dreamrift-chest, Vault 2/4/6, **Creation Catalyst**
  Silvermoon week 1 / +1 per 2 wk / max 8 / Catalyst Unbound na 4-set), en het beginner-pad.
- **Niveau 2**: jouw class-set-naam + 2/4-set als **klikbare spell-links** (live tooltip = actuele,
  gelokaliseerde bonus → geen hardcoded bonus-tekst, never-lie-vriendelijk) + **live teller**
  "tier x/5" met gekleurde 2-set/4-set-labels. Teller leest de set-piece-count uit de item-tooltip
  ("(n/5)") via `C_TooltipInfo.GetInventoryItem` (taint-veilig, read-only). Ververst op
  PLAYER_EQUIPMENT_CHANGED / PLAYER_SPECIALIZATION_CHANGED.
- Voet: "datamined voor 12.0.7 — hover voor live tooltip, bevestig in-game" (IDs zijn PTR-bevestigd).

**UI.lua** — tab geregistreerd in de **Character-sectie** (`SIDEBAR_SECTIONS` ids + `TAB_DEFS` +
`keyById` + info-drawer `INFO_DRAWER_BODY_TIER` + build/refresh-dispatch). **.toc**: `TierSetData.lua`
vóór `TierSet.lua` (na CurrencyGuide).

**Locales ×6**: `TAB_TIER`, `TIER_SUBTITLE`, `INFO_DRAWER_BODY_TIER`, `TIER_GUIDE_BODY`,
`TIER_YOUR_SET`, `TIER_2SET`, `TIER_4SET`, `TIER_COUNT_FMT`, `TIER_COUNT_UNKNOWN`,
`TIER_SET_UNKNOWN`, `TIER_FOOTER`.

Verificatie: lupa compileert TierSetData + TierSet volledig (read==disk); host-Read bevestigt
balans. ⚠️ specIDs zijn de stabiele retail-IDs; **set-bonus-spell-IDs zijn PTR-bevestigd** — bij
12.0.7-live even kruischecken (research flagde dit). Mount gaf weer wisselende truncatie-positives.

**Toevoeging (PTR-validatie 16 jun):** tier-set bevestigd op live 12.0.7 (Elemental 4-set
1264863 matchte de in-game tooltip; teller las "Mantle of the Primal Core (2/5)" correct). Veteran-
crest PTR-bevestigd: 3341 = primary (volledige beschrijving), 3342 = duplicaat, code neemt max →
veilig. **Creation Catalyst nu klikbaar** in TIER_GUIDE_BODY via `{CATALYST}`-token →
`SetCatalystWaypoint` (TomTom/native, Silvermoon 2393 40.31/64.85, = SMC-guide-locatie); locale-key
`TIER_CATALYST_NAME` ×6; body OnHyperlinkClick vangt "mhcatalyst" (spell-links houden hover-tooltip).

**Bugfix enchant-paneel ververst niet bij enchanten (Robs zus, 16 jun):** een enchant op een
al-gedragen stuk wisselt het item niet → `PLAYER_EQUIPMENT_CHANGED` vuurt niet, dus het paneel
liep pas bij tab-wissel bij. Fix: `GearEnchantCheck.lua` + `TierSet.lua` luisteren nu óók naar
**UNIT_INVENTORY_CHANGED** (gefilterd op unit "player"), met een `C_Timer.After(0.1)`-refresh
(item-link toont de nieuwe enchantID soms een frame later). Alleen actief als het paneel open is.

**Val/Naigtal data-compleet (PTR 16 jun):** Val uiMapID 2599, weekly 96713, zijquest 96053,
intro Screaming Ridge (Voidstorm 2405), Maella-outpost 2599 59.56/19.33. Volledige rare-rosters
(Val 10 / Naigtal 8) + Pertinax WB 261072 in `docs/PTR_12.0.7_DATA.md` — klaar voor Rares.lua
(kill-quest-IDs blijven open, niet scrapebaar → vignette/npcID-detectie of live-capture).

**✅ Dup-cast-sweep KLAAR (16 jun).** Alle boss-step-locales gecheckt. Verwijderd (pure naam-
herhaling ná de blauwe link): RitualTips ×7 (Ger'lok: Shadowbolt Volley/Shadow Blast; Rotmire:
Fungal Bloom/Bursting Shroom/Festering→Writhing Vines/Bursting Doom Shroom/Putrid Fist) +
MythicPlus ×1 ("(Divine Guile)" op Lothraxion). **Bewust gelaten** (géén pure dupe): RaidTips
"(Umbral Collapse, a group soak)", MythicPlus mob-namen "(Blazing Pyromancer)" e.d. (= welke mob
cast), DungeonTips/DelveTips effect-omschrijvingen "(disease)", "(frontal cone)". Via replace_all
per Engelse naam → alle 6 talen in één keer.

**✅ Showdown-rares in `Modules/Rares.lua` (16 jun).** Val (10) + Naigtal (8) toegevoegd uit de
achievement-rosters + coords (roamers in-game gemeten). `MAP_TO_ZONE_KEY` 2599→val / 2600→naigtal.
questId-veld = **0** (geen bevestigde kill-quest → niet datamine-baar): geen weekly-tint, maar
route (coords) + vignette-alert (npcID veld 6) werken. Nieuwe helper **`RareKey(rare)`** valt voor
questId 0 terug op "npc:<id>" zodat up/found-tracking niet op sleutel "0" botst. ⚠️ Kill-quest-IDs
later in-game capturen → dan komt de weekly-tint erbij. (Klein: zones tonen ook op 12.0.5 tot
launch; Cursor mag ze achter een ≥120007-gate zetten als gewenst.)

## 📌 STAND 16 juni — na 1.8.1-release (overdracht naar volgende sessie)

**1.8.1 is LIVE op CurseForge** (door Cursor geüpload; veel downloads). Versie 1.8.1, interface 120005/120007.

**Wat er in 1.8.1 zit (deze sessie gebouwd):** Tier Sets-tab, Currencies-tab (live saldo's +
klikbare vendor→TomTom-waypoints, addon-breed), Enchants AH-copy/refresh-fix, rare-skull op
nameplate (taint-veilige texture), **UX-refresh Tier 1+2+3** (één goud-palet, rol-iconen i.p.v.
kleur-regenboog, rustige links, ontzadigde status, tooltips bij de cursor, SMC niet meer "geboxt",
**Simpele modus**-toggle — default VOLLEDIG), dup-cast-sweep, Showdown-rares Val/Naigtal in Rares.lua,
+ fixes (world-boss-warband, Veteran-crest, in-game changelog t/m 1.8.1, SetRaidTarget-forbidden).
Val/Naigtal-data compleet (uiMap 2599/2600, weekly 96713/96717, intro Screaming Ridge, rosters).

**Open / volgende sessie (geen blockers):**
- **UX optioneel (lager rendement):** gedeelde `ns.MakePanelHeader`, SMC-Slider→`UIPanelScrollFrameTemplate`,
  Settings-checkboxes voor Simpele modus + rare-skull (`ns.db.rareSkull`), één-malige login-hint.
- **In-game te capturen (live):** Showdown-rare **kill-quest-IDs** (dan komt de weekly-tint erbij;
  niet datamine-baar), **Mote of Omnial Inquiry** item-ID, **Pertinax** echte npcID (261072 vs 263670),
  Heroic-Showdown-weekly-IDs. Zie `docs/PTR_12.0.7_DATA.md`.
- **ROADMAP-backlog:** live event-voortgangsbalken, reward-galleries, Rares HandyNotes-coords.
- **Tier-set-spell-IDs** waren PTR-bevestigd (Elemental live geverifieerd) — bij twijfel andere specs
  in-game kruischecken.

**Belangrijke werkafspraken (zie boven):** never-lie; Cursor doet git/CF; **CF-release = ALTIJD
in-game changelog**; host-Read is leidend (sandbox-mount truncatie-false-positives).

---

## 🎯 Voor Cursor — CF-RELEASE 1.8.1 (16 juni — Rob vraagt erom)

**STATUS: ✅ GECOMMIT + GEPUSHT + ZIP GEBOUWD** — release-commit `441f470`
(`release: MidnightHelper 1.8.1`). loadfile OK (111 files); zip =
`dist/MidnightHelper-1.8.1.zip` (root `MidnightHelper/`, TOC 1.8.1, geen
scripts/docs/tools, 127 entries; TierSet + CurrencyGuide aanwezig). **Rob doet de
CF-upload zelf** met `docs/CURSEFORGE_1.8.1.md` (changelog) +
`docs/CURSEFORGE_DESCRIPTION.md` (START/END) + verse screenshots.

**STATUS (origineel): ⏳ KLAAR VOOR RELEASE.** TOC staat al op **1.8.1**. Alle release-artefacten klaar
(conform Robs regel "CF-release = ALTIJD in-game changelog"):
- **In-game changelog**: `Modules/Changelog.lua` heeft een **1.8.1**-blok (`CHANGELOG_181_1..6`) +
  keys in `enUS`/`nlNL` (de/fr/es/pt vallen via SafeL terug op EN = bestaand patroon).
- **`CHANGELOG.md`**: `[1.8.1] - 2026-06-16`.
- **`docs/CURSEFORGE_1.8.1.md`**: short summary + changelog-paste + upload-checklist + test.
- **`docs/CURSEFORGE_DESCRIPTION.md`**: bijgewerkt naar **1.8.1-refresh** (+ Tier Sets-sectie,
  1.8.1-highlight-bullet, display version 1.8.1).

**Stappen voor Cursor:** (1) `git status` + luacheck/loadfile op host-bestanden; (2) `package.ps1`
→ `dist/MidnightHelper-1.8.1.zip` (geen scripts in zip, root = `MidnightHelper/`); (3) upload als
**Release**, versie **1.8.1**, interface 120005; plak changelog uit `CURSEFORGE_1.8.1.md` + vervang
projectpagina-description door `CURSEFORGE_DESCRIPTION.md` (START/END); (4) commit-bericht
`release: MidnightHelper 1.8.1`. Verse screenshots: Tier Sets, Currencies (klikbare vendors),
boss-window, Simple-view-toggle.

## 🎯 Voor Cursor — CF-RELEASE 1.8.0 (15 juni — Rob gaf expliciet groen licht!)

**STATUS: ✅ GECOMMIT + GEPUSHT + ZIP GEBOUWD** — release-commit `58e4edb`
(`release: MidnightHelper 1.8.0`, batches #4–#9 samengevoegd). loadfile OK (109
files); zip = `dist/MidnightHelper-1.8.0.zip` (root `MidnightHelper/`, TOC 1.8.0,
geen scripts/docs/tools, 125 entries). **Rob doet de CF-upload zelf** met
`docs/CURSEFORGE_1.8.0.md` (changelog) + `docs/CURSEFORGE_DESCRIPTION.md`
(START/END-markers) + verse screenshots.

**STATUS (origineel): ⏳ KLAAR VOOR RELEASE.** Rob heft de "geen-CF"-regel hiervoor expliciet op:
*"dan doen we nu een CF update 1.8.0 en dan kunnen we morgen met 1.8.1 aan de slag."*
Versie blijft **1.8.0** (TOC staat al goed; NIET naar 1.8.1 bumpen — dat is morgen).

**Stappen:**
1. **Commit eerst alle openstaande batches** #6, #7, #8, #9 (zie blokken hieronder) als ze nog niet
   binnen zijn — die zitten allemaal in deze 1.8.0-release.
2. Draai luacheck/loadfile op de gewijzigde bestanden (mount gaf weer truncatie-false-positives;
   host-bestanden zijn met een Lua-parser/host-Read geverifieerd — zie de batch-blokken).
3. `CHANGELOG.md`: [Unreleased] + oude [1.8.0]-stub zijn samengevoegd tot één volledige
   **[1.8.0] - 2026-06-15** (alle batch #4–#9-features + fixes). CF-tekst staat in
   **`docs/CURSEFORGE_1.8.0.md`** (short summary + changelog + upload-checklist + test-stappen).
4. Build: `powershell -ExecutionPolicy Bypass -File tools\package.ps1` → `dist/MidnightHelper-1.8.0.zip`.
   ⚠️ CF-regels: geen scripts in de zip, zip-root = exact `MidnightHelper/`, geen docs/tools.
5. Upload als **Release**, display version **1.8.0**, game version interface **120005**
   (120007 mag in de TOC blijven tot 12.0.7 live is). Description + verse screenshots
   (suggestie: Currencies-tab, Enchants-tab, raid/M+ boss-window, Events-tab).
6. Tag/commit-bericht: `release: MidnightHelper 1.8.0` (of jouw conventie).

**Aanrader vóór upload:** Rob even de **Currencies-** en **Enchants-tab** in-game laten bevestigen
(waren de verste/grootste toevoegingen; world-boss-fix is al live bevestigd ✅). Geen blocker, wel netjes.

**In-game changelog-popup bijgewerkt (16 jun):** `Modules/Changelog.lua` `CHANGELOG_ENTRIES` stond
nog op 1.5.5 (Rob zag dit op de PTR — titel 1.8.0, regels t/m 1.5.5). Toegevoegd: blokken **1.6.0 /
1.7.0 / 1.7.1 / 1.8.0** met keys `CHANGELOG_160_*` / `170_*` / `171_*` / `180_*` (enUS + nlNL;
de/fr/es/pt vallen via SafeL terug op EN, = bestaand patroon). Hoort bij de 1.8.0-release.
➡️ Bij de 1.8.1-bump: voeg een `1.8.1`-blok toe (tier sets) — keys `CHANGELOG_181_*`.

**Na de release:** morgen 1.8.1 — tier-set-feature (beide niveaus, zie TOMORROW.md) + openstaande
zaken uit ROADMAP.md.

## Voor Cursor — review + commit batch 15 juni #9 (Enchant-links/AH-copy + Currency saldo's/QM-waypoints)

**STATUS: ✅ GECOMMIT in release 1.8.0 (`58e4edb`).**

Voorgesteld bericht:

> feat(enchants+currency): klikbare enchant-suggesties + AH-copy; live currency-saldo's + QM-waypoints

Robs feedback op de Enchants-screen: de "your pick"-keuzes hadden geen tooltip, en hij wil
(net als consumables) een kopieerregel voor de AH bij het aanklikken.

**`Modules/GearEnchantCheck.lua` (herschreven).** Elke suggestie is nu een klikbare/hoverbare
link (tooltip) + klik → naam landt in een kopieerbalk onderaan (InputBox, voorgeselecteerd voor
Ctrl+C, consumables-patroon via `ui.linkAH` + `OnHyperlinkClick`). **Echte data (Wowhead 12.0.7,
research 15 jun):**
- HEAD tertiary-keuze: Blessing of Speed 1236070 / Hex of Leeching 1236055 / Rune of Avoidance 1236083.
- FEET tertiary-keuze: Farstrider's Hunt 1236085 / Shaladrassil's Roots 1236072 / Lynx's Dexterity 1236057.
- LEGS: Forest Hunter's Armor Kit (item 244640, Agi/Str) of Arcanoweave Spellthread (item 240154, Int).
- SHOULDER: **gecorrigeerd** — géén tertiary (dat was fout); nu optionele utility-enchant
  (item 243962 Akil'zon's Swiftness) met "effect in-game bevestigen", geen rode MISSING-alarm.
- Bestaande ring/wapen/chest-IDs door research bevestigd (spell-IDs kloppen; item-namen toegevoegd
  als AH-zoekstring). `/mh enchants` blijft werken (links klikbaar in chat).
- Nieuwe locale-keys ×6: `ENCHANT_PICK`, `ENCHANT_LEGS_AGISTR`, `ENCHANT_LEGS_INT`,
  `ENCHANT_SHOULDER_OPT`, `ENCHANT_COPY_LABEL`. (`ENCHANT_NOTE_TERTIARY/_LEGS` nu ongebruikt — gelaten.)

**`Modules/CurrencyGuide.lua` (uitgebreid).** (1) **Live saldo's**: `{CURRENCY:id}` rendert nu
link + `|cff8fce8f(N)|r` via `C_CurrencyInfo.GetCurrencyInfo().quantity`, ververst op
`CURRENCY_DISPLAY_UPDATE`. (2) **QM-waypoint-knoppenrij** onderaan (SMC Court / Amani / Hara'ti /
Singularity) → TomTom-slash indien aanwezig, anders `C_Map.SetUserWaypoint`. Coords (Wowhead):
Caeris Fairdawn map 2395 43.46/47.42, Magovu 2437 45.95/65.92, Naynar 2413 50.99/50.75, Anomander
2405 52.57/72.89 — in-game te bevestigen. Locale-keys ×6: `CURRENCY_QM_LABEL` +
`CURRENCY_QM_COURT/AMANI/HARATI/SINGULARITY`.

Verificatie: host-Read bevestigt beide modules compleet + gebalanceerd (GearEnchantCheck 352 r,
CurrencyGuide 214 r). ⚠️ De sandbox-mount serveerde een **stale/afgekapte** kopie (stat én read
gaven 5413 B / 129 r voor een 352-regel-bestand) → lupa/luaparser via de mount onbruikbaar;
host-Read is leidend.

**Bugfix world-boss warband-line (`Modules/WorldBoss.lua`).** Rob: alt die de boss níet deed toonde
"Warband: not defeated yet" terwijl Earthshammy 'm al versloeg. Oorzaak: de 12-jun-fix (availability-
early-return weghalen) was wél in `SyncWarbandDoneFromQuestLog` doorgevoerd maar **niet** in
`ns.IsWorldBossKilled` — die deed nog `if IsWorldBossAvailableThisWeek(boss) then return false`,
wat de account-brede warband-cache op alts maskeerde (WQ is per-char 'active'). Early-return
verwijderd; week-reset blijft door `ClearStaleWbWeekCache` afgevangen. `IsWorldBossAvailableThisWeek`
blijft in gebruik door `IsWorldBossDoneOnThisCharacter` (per-char "looted"-regel, dáár correct).

## Voor Cursor — review + commit batch 15 juni #8 (Currency cheatsheet-tab + {CURRENCY:} markup)

**STATUS: ✅ GECOMMIT in release 1.8.0 (`58e4edb`).**

Voorgesteld bericht:

> feat(currency): "Valuta"-cheatsheet-tab (waar verdien/geef ik elke currency uit) + {CURRENCY:id} markup

Robs wens: "ik weet van de helft van wat ik krijg niet waar/aan wat ik het kan uitgeven."

**Nieuwe tab "Currencies/Valuta"** (`Modules/CurrencyGuide.lua`, nieuw — kloon van het
GearEnchantCheck-paneelpatroon: read-only EditBox in een scroll, klikbare links, RefreshLocaleUI-
hook). Rendert één gelokaliseerde `CURRENCY_GUIDE_BODY` met per currency: waar verdien je 'm +
bij welke vendor geef je 'm uit. Dekt **Voidlight Marl** ({CURRENCY:3316}), **Field Accolade**
({CURRENCY:3405}), **Dawncrests** (3383/3341/3343/3345/3347 → Cuzoth/Vaskarn, verwijst naar de
Dawncrest-tab), **PvP** (Honor/Conquest/Bloody Tokens/Marks → Dawnrunner/Bloodstar/Bloodvalor/
Soryn) en de **4 Renown Quartermasters** (Caeris Fairdawn/Magovu/Naynar/Anomander per zone).

**Nieuwe markup `{CURRENCY:id}`** in `Modules/DelveTipMarkup.lua`: `ns:GetCurrencyLinkMarkup`
gebruikt `C_CurrencyInfo.GetCurrencyLink` (game-gelokaliseerde naam, kleur ffd200) met fallback;
expansie in `ExpandDelveTipMarkup`; tooltip-handler kreeg een `currency`-tak (`SetCurrencyByID`).
Currency-namen in de cheatsheet zijn dus auto-gelokaliseerd + linken naar je live saldo.

**UI.lua** — tab geregistreerd: `SIDEBAR_SECTIONS` guides-ids (`currency` na `smcguide`),
`TAB_DEFS`, `keyById`, info-drawer-body (`INFO_DRAWER_BODY_CURRENCY`), build-dispatch
(`BuildCurrencyGuidePanel`) + refresh-dispatch (`RefreshCurrencyGuidePanel`).
**.toc**: `Modules\CurrencyGuide.lua` na GearEnchantCheck.

**Locales ×6** (en/nl/de/fr/es/pt): `TAB_CURRENCY`, `CURRENCY_SUBTITLE`, `CURRENCY_GUIDE_BODY`,
`INFO_DRAWER_BODY_CURRENCY`.

**DawncrestData.lua fix:** Veteran-crest `currencyId` 3342 → **3341** primary + `alternateCurrencyIds = { 3342 }`
(zelfde patroon als Champion 3343/alt 3344). Rob ziet in-game geen ID, dus alt dekt beide; de
3341/3343/3345/3347-reeks + Wowhead wijzen op 3341. Rollback-veilig: alt valt terug op 3342.

Verificatie: host-Read bevestigt alle edits well-formed; CurrencyGuide.lua compileert (lupa OK).
⚠️ luaparser/lupa via de sandbox-mount gaf weer **valse** "near <eof>"-fouten door CRLF-truncatie
van de mount (zelfs op ongewijzigde regels) — host-Read is leidend, bestanden zijn compleet.

## Voor Cursor — review + commit batch 15 juni #7 (SMC gear & currency vendors)

**STATUS: ✅ GECOMMIT in release 1.8.0 (`58e4edb`).**

Voorgesteld bericht:

> feat(smc): Gear & Currency Vendors-sectie in SMC City Guide (Maren + Triam)

`UI.lua` — nieuwe `SMC_CATEGORIES`-sectie **"Gear & Currency Vendors"** (na Essential Services),
met twee waypoint-pins bij de Ritual/Void-hub (~48.11, 49.10 — coords in-game te bevestigen):
- **Maren Silverwing** (Wowhead npc 255473, `<Quartermaster>`): ruilt **Field Accolades** (uit
  Ritual Sites + Void Assaults) voor Void-Touched **GEAR**-caches — Champion 75 / Hero 500;
  zet ook Dark Particle → Field Accolade. Atlas `WarWithin-Icon-Crest`.
- **Triam Dawnsetter** (Wowhead npc 255476, `<Cosmetic Equipment Salvager>`): **ALLEEN
  cosmetics/transmog, GEEN gear** — Void-Touched looks per slot, 5 Field Accolade + 150 Voidlight
  Marl elk (wapens 10 + 200), geen duplicates. Atlas `services-icon-transmogrifier`.

Beide pins zijn auto-doorzoekbaar (de `ns._mhSMCGuideSearchRows`-loop pakt label+description).
Sectie volgt de bestaande hardcoded-NL stijl van `SMC_CATEGORIES` (geen locale-keys nodig).
luaparser: OK (2646 regels).

**Currency-bron (research, Wowhead-bevestigd):** Voidlight Marl = currency **3316** (Renown
Quartermasters + zone-vendors, warband-transferable); Field Accolade = **3405** (Maren).
⚠️ **Mogelijke fix voor Cursor:** `DawncrestData.lua` heeft Veteran `currencyId = 3342`, maar
Wowhead-research wijst op **3341** voor Veteran Dawncrest. Niet blind gewijzigd — graag in-game
bevestigen (Currency-tab) vóór aanpassen.

**Open vervolg (optioneel, met Rob bespreken):** volledige "waar geef ik welke currency uit"-
cheatsheet in de addon (Voidlight Marl, Field Accolade, Dawncrests, Honor/Conquest/Bloody Tokens,
profession-currency) + Renown Quartermasters per zone (Caeris Fairdawn/Magovu/Naynar/Anomander).

## Voor Cursor — review + commit batch 15 juni #6 (debuff-alert + Delve & Ritual Log + weekly)

**STATUS: ✅ GECOMMIT in release 1.8.0 (`58e4edb`).**

Voorgesteld bericht:

> feat(alerts+log+weekly): debuff-alert (eigen auras) + Delve & Ritual Log + Voidforge-weekly

**Idee 2 herbouwd → debuff-alert (werkt).** `Modules/AccessibleAlerts.lua` van enemy-cast
(geblokkeerd) naar **eigen-debuff-detectie** (UNIT_AURA "player"; leesbaar). Flasht één rustige
melding + geluid zodra je een debuff uit `ns.DEBUFF_ALERTS` krijgt; per-debuff message of
`ALERT_DEBUFF_FMT` met de naam. Opt-in, throttle 4s/6s, gate party/scenario. Geseed met
**440313 Devouring Rift** (M+ Devour). Module terug in TOC; toggle + testknop terug in
beginnersmodus; ALERT_HELP/ENABLED_MSG herschreven + ALERT_DEBUFF_FMT/DEVOURING_RIFT ×6 talen.
CHANGELOG: eerlijke "Helper alerts (opt-in)"-regel. Lijst groeit met de ritual-debuff-logger.

**Delve & Ritual Log.** `Modules/RitualLog.lua` (nieuw) logt ritual-scenario-runs (site, tier
indien leesbaar, tijd, deaths, voltooid) in EXACT het DelveHistory-run-model. `Modules/
DelveHistory.lua`: Refresh toont nu een **"Rituals"-sectie** (hergebruikt rij-opmaak +
totalen), en de **bestaande uitklap-bug gefixt** (`row._mhKey` werd nooit gezet → recent-runs
klapten niet uit; nu wel, voor delves én rituals). Tab hernoemd naar **"Delve & Ritual Log"**
+ subtitle + `DELVELOG_SEC_RITUALS` ×6 talen. Detectie via scenario-naam (Broken Throne /
Daggerspine). Heeft een echte run nodig om tier-leesbaarheid te bevestigen (Rob test vanavond).

**Must-kicks compleet (alle 8 M+-dungeons).** Research (Method ability-trackers + Icy-Veins):
Magisters' Terrace (Polymorph 468966, Pyroblast 1254294, Terror Wave 1264693 — bosses niks
kickbaar), Nexus-Point Xenas (Kasreth Arcane Zap 1250553, Lothraxion Divine Guile 1257595 =
kick de hoornloze shade, + Nullify 1258681 / Umbra Bolt 1271094 / Holy Bolt 1263892), Windrunner
Spire (Chain Lightning / Spirit Bolt / Poison Blades / Fungal Bolt — namen, IDs "not found").
`MPLUS_KICKS` + `MPLUS_KICK_MAGISTERS/NEXUSPOINT/WINDRUNNER` ×6 talen, klikbare links waar
bevestigd. Maisara blijft namen-only tot live-capture.

**Raid-bosses verrijkt uit EXBoss (Rob draait EXBoss/EXBossData).** Robs `EXBossData/
EncounterData.lua` (event_spell_map_v2) heeft per raid-boss een event→spell-map met spellID +
**`voiceLabelUS`** (Engels actie-label: Heal/Drop/Beam/DODGE/Kick/Intermission…) + severity —
dekt ál onze raids incl. de gaten Crown (2738), L'ura (2740), Chimaerus (2795). `RaidTips.lua`:
Crown/L'ura/Chimaerus STEPS kregen een **"Key casts"-regel** met spell-links per actie
(dodge/interrupt/move/defensive), ×6 talen; de "nog niet gedataminet"-caveats vervangen.
Cross-check: Chimaerus' interrupt {SPELL:1249017} matcht onze eerdere DBM-ID. Bron-caveat
"(EXBoss timeline — confirm in-game)" in de tekst. **Vervolg (zelfde batch): de 5 Voidspire-
bossen (Averzian/Vorasius/Salhadaar/Vaelgor/Vanguard) óók verrijkt** met een "Key casts"-regel
×6 talen — meerdere IDs cross-checken onze bestaande (Averzian-interrupt 1255702 + wipe 1251583,
Salhadaar burn-window 1246175, Vanguard-auras, Vaelgor Dread Breath/Gloom/Radiant Barrier).
Bewust buiten de regel gelaten: Nullbeam 1262623 (EXBoss zegt "frontal", Wowhead "tank-soak" —
conflict, niet asserten). Nu hebben **alle 9/9 raid-bosses** EXBoss-key-casts (Belo'ren als laatste toegevoegd, ×6 talen
— bevestigt onze kleur-split 1241162/1241163 + Rebirth 1241313). **EXBossData blijft dé bron**
voor verder verrijken (de M+ dungeon-bóssen + trash-kicks — al cureert EXBoss daar andere casts
dan method.gg, dus niet blind mergen).
Ritual-scenario's staan NIET in EXBoss (debuffs blijven via de logger).

**Gear-enchant-check (Rob-wens, `/mh enchants`).** `Modules/GearEnchantCheck.lua` (nieuw):
scant de enchantbare 12.0-slots (Weapon, Chest, Helm, Shoulder, 2 Ringen, Boots, Legs),
vlagt slots zonder enchant, en stelt per slot een Midnight-enchant voor op basis van de
spec-top-secundaire-stat (eigen resolver op `ns.VAULT_ADVISOR_SPEC_WEIGHTS`). Stat-gematcht
voor ringen (Silvermoon's Alacrity/Nature's Fury/Zul'jin's Mastery/Silvermoon's Tenacity) +
proc-wapen; chest = Mark of the Worldsoul (primary); helm/shoulder/boots = tertiair (keuze);
legs = professie-kit. Enchant-data 15-jun research (Wowhead/Method/wow-professions). Taint-
veilig (read-only inventory+spec). Slot-namen via Blizzard-globals (auto-gelokaliseerd).
**Paneel toegevoegd (Rob wilde geen chat-spam):** eigen tab **"Enchants"** onder de
Character-sectie (UI.lua: TAB_DEFS, SIDEBAR_SECTIONS, build/refresh-dispatch, keyById,
info-drawer). Read-only EditBox met hoverbare spell-links; ververst op show +
PLAYER_EQUIPMENT_CHANGED/PLAYER_SPECIALIZATION_CHANGED. `/mh enchants` blijft als bonus.
14 locale-keys ×6 talen (ENCHANT_* + TAB_ENCHANTS + ENCHANT_SUBTITLE + INFO_DRAWER_BODY_ENCHANTS).
Tertiaire/legs-keuze bewust generiek (never-lie, geen valse BiS-claim).

**Weekly-pariteit.** `Modules/ResetRoutine.lua` `EXTRA_WEEKLIES` + **Building the Voidforge
(94623)** (enige met bevestigde ID; hergebruikt GIVER-fmt, geen nieuwe locale-keys). Beacon of
Hope / Prey Hunts / Saltheril's Soiree / Bonus Event: géén quest-ID bekend → bewust NIET
toegevoegd (never-lie), capturen we in-game.

**Review:** alle nieuwe/gewijzigde Lua host-geverifieerd (RitualLog/AccessibleAlerts parsen
schoon; DelveHistory-Refresh + ResetRoutine-blok geïsoleerd geparseerd; bash-mount kapt grote
files af = bekend). Locale-pariteit 6× (host-Grep). Taint: alleen eigen-aura-reads, in pcall.

## Voor Cursor — review + commit batch 15 juni #5 (live-test hotfixes)

**STATUS: ✅ GECOMMIT in release 1.8.0 (`58e4edb`).** Fixes na Robs eerste live test.

Voorgesteld bericht:

> fix(12.x secret values): interrupt-alerts verwijderd (geblokkeerd) + Rituals/Raids-split + boss-camera + must-kick-links

**Belangrijke 12.0.7-ontdekking:** vijandelijke cast-data is nu een **'secret' waarde**
(Blizzard blokkeert interrupt-automatisering). Een secret als table-key gebruiken of
erop een if-test doen gooit een fout. Twee crashes daardoor (Rob live in ritual):
- 🐛 **`Modules/RitualBossCoach.lua`** (32× `cannot be indexed with secret keys`, r.127):
  `ALERT_SPELLS[spellID]` met secret spellID. Fix: `LookupAlert()` doet een +0-launder-
  poging én de lookup in `pcall` → lukt = alert flasht, secret/mislukt = geen alert
  (nooit spam). Throttle nu via `lastAlertAt.t` (platte key i.p.v. secret spellID).
- 🗑️ **Idee 2 (cast-/interrupt-alerts) VERWIJDERD — definitief geblokkeerd in 12.x.**
  Rob's live cast-logger (RitualBossCoach, tijdelijk) bewees het: zowel de spell-**ID**
  (`CAST met 'secret' spell-ID`) als de cast-**naam** (UnitCastingInfo) van vijandelijke
  casts is 'secret' en onleesbaar voor een tainted addon. Een eigen interrupt-/cast-alert
  is dus onmogelijk (DBM heeft daar privileges voor die wij niet hebben). Daarom:
  - `Modules/AccessibleAlerts.lua` uit de TOC gehaald (file blijft op schijf voor een
    eventuele debuff-gebaseerde herziening).
  - "Helper alerts"-toggle + testknop uit de beginnersmodus (DungeonGuide) gehaald +
    de FillMythic-ref. ALERT_*-locale-keys blijven (ongebruikt, onschadelijk).
  - CHANGELOG: "Live cast alerts on the Broken Throne ritual"-regel verwijderd (klopte
    niet meer — never-lie).
  - RitualBossCoach's FlashAlert/ALERT_SPELLS-pad is nu dode (pcall-veilige) code; de
    cast-logger blijft als dormante datamine-tool. Beide kunnen later gestript worden.
  - **Pivot-optie (backlog):** alerts op **eigen speler-debuffs** (UnitAura "player" is
    NIET secret) — bv. flash als jíj in Binding Nebula zit. Dat mag wél en is de
    haalbare route voor idee 2.

**Idee 2 HERBOUWD als debuff-alert (15 jun, na Rob's "ja"):** `Modules/AccessibleAlerts.lua`
herschreven van enemy-cast → **eigen-debuff-detectie** (UNIT_AURA "player"; leesbaar,
bevestigd via Sated 57724). Flasht één grote, rustige melding + geluid zodra je een debuff
uit `ns.DEBUFF_ALERTS` krijgt; per-debuff message of generieke `ALERT_DEBUFF_FMT` met de
naam. Throttle 4s globaal + 6s per debuff; gate op party/scenario; opt-in (default uit).
Geseed met **440313 Devouring Rift** (M+ Devour-week → "heal/dispel het eraf"); lijst groeit
zodra de ritual-debuff-logger ID's vangt (Binding Nebula etc.). Module terug in TOC; toggle +
testknop terug in de beginnersmodus; CHANGELOG bijgewerkt. Locale ALERT_HELP/ENABLED_MSG
herschreven (debuff i.p.v. interrupt) + ALERT_DEBUFF_FMT/DEVOURING_RIFT ×6 talen.

**UI-tweaks (Robs screenshots):**
- `Modules/DungeonBossWindow.lua` — picker **gesplitst in "Rituals" en "Raids"** (was één
  "Rituals & Raids"-groep). Split op `ritual_`-keyprefix. 2 nieuwe locale-keys
  DGN_WIN_PICK_RITUALS/RAIDS ×6 talen.
- `Modules/DungeonBossWindow.lua` — model-zoom via **`SetCamDistanceScale`** (camera-
  afstand, blijft GECENTREERD). Eerdere pogingen faalden: RefreshCamera (klein/top-left)
  en `SetPosition` depth (model dreef naar de hoek + scroll liep vast op −1.0 met
  chat-spam). Nu: `MODEL_CAMSCALE`-tabel zet per-boss start-zoom (Belo'ren 240387 = 2.2),
  reset op creatureID-wissel, blijft staan bij refresh. Scroll past `_mhCamScale` aan
  (0.5..5.0) en print **alleen bij wijziging** (geen spam). Andere modellen = 1.0.
  Belo'ren-waarde fine-tunen zodra Rob de scroll-waarde doorgeeft.
- **Must-kick-tooltips (Robs vraag, screen 3) — grotendeels gedaan.** Web-research (Method
  ability-trackers → Wowhead spell=) leverde geverifieerde IDs voor de legacy-dungeons:
  Repel 1255377, Icy Blast 1271074, Shadow Bolt 473657, Death Bolt 1278893, Glacial
  Overload 1262029 (LoS-cast, géén kick — tekst zegt al "break LoS"), Dread Screech 248831,
  Healing Touch 396640. Die staan nu als {SPELL:}-link in `MPLUS_KICK_*` (×6 talen) en de
  kick-regels zijn EditBoxes geworden (`ui.mythicKickRows`) → klikbaar met tooltip.
  **Maisara's trash (Hex/Reanimation/Shrink): "not found"** — geen betrouwbare bron (WowCarry
  linkte naar verkeerde speler-spells), dus bewust platte tekst gelaten tot live-capture.
- **Dubbele spell-namen weg (Robs screen 1/2):** de redundante " (Naam)" achter elke
  {SPELL:}-link verwijderd in `RaidTips.lua` (17 strings) + `MythicPlus.lua` Bargains (5),
  ×6 talen. De blauwe link toont de naam al; de witte dubbel-tekst (zonder tooltip) is weg.
- ✅ **Broken Throne LIVE gevalideerd (Rob, 15 jun, ritual gecleared).** Twee guide-
  correcties uit de echte run, ×6 talen in `RitualTips.lua`:
  - **Dragonhawk (Corrupted Beast):** mechanic was fout. KILLER = Volatile Plumage laat
    kleine RODE PLASSEN vallen die je moet **SOAKEN** (erin staan = kleine tik; lege plas =
    enorme Shadowflame-explosie = de wipe). Geverifieerd via Wowhead-comments + Robs kill.
    Oude "ontwijk/dood-de-nebula"-tekst vervangen.
  - **Ger'lok (Corruptor's End):** notitie aangescherpt — hem van zijn platform/naar
    beneden pullen **reset het gevecht** (Robs live-bevinding).
  - Auto-open-per-stage (16391/16393/16394) + scenario 3236 in-game bevestigd; de
    debuff-logger werkt (ving `57724 Sated`). Player-auras zijn dus leesbaar → debuff-
    alert blijft een haalbare backlog-optie.

## Voor Cursor — review + commit batch 15 juni #4 (volledige raids + Mythic+-tab)

**STATUS: ✅ GECOMMIT in release 1.8.0 (`58e4edb`).** Grote batch; mag
samen met #3 of apart.

Voorgesteld bericht:

> feat(raids+mplus): alle 3 Season 1-raids in de Boss Coach + Mythic+-subtab (affixes, pool, must-kicks) — 6 talen

**Context:** Rob wilde "volledige raids toevoegen en daarna alle Mythics". Data 15 jun
gedataminet en gekruist tussen Robs **DBM-Raids-Midnight** (autoritatieve encounter-IDs)
en Wowhead/Method/Icy-Veins (spell-IDs/NPC-IDs/mechanics). Alles "confirm in-game".
Volledige ID-tabel in `docs/RAID_MPLUS_DATA.md`.

**Nieuw — raids:**
- `Modules/RaidCoachData.lua` — de 3 Season 1-raids als CUSTOM_BOSS_ENTRIES (zelfde
  boss-venster als Sporefall/Ritual): **The Dreamrift** (Chimaerus), **The Voidspire**
  (6 bosses: Averzian, Vorasius, Salhadaar, Vaelgor & Ezzorak, Lightblinded Vanguard,
  Crown of the Cosmos), **March on Quel'Danas** (Belo'ren + Midnight Falls/L'ura). Elke
  raid = 1 picker-regel onder "Rituals & Raids"; binnen het venster blader je de bosses
  (3D-model + stappen + klikbare {SPELL:}-links). Auto-open op ENCOUNTER_START via de
  echte DBM-encounter-IDs (2733-2740, 2795), met naam/npc-fallback (zelflerend).
- `Locales/RaidTips.lua` — 18 keys × 6 talen (steps + tank/healer/dps waar goed
  onderbouwd). Crown/L'ura/Chimaerus bewust beschrijvend waar spell-IDs niet gedataminet
  zijn (never-lie, met "confirm in-game"-noot in de tekst).
- `Modules/SporefallCoach.lua` — Rotmire encounterID **2711** vast geseed (instant
  auto-open op de eerste pull i.p.v. pas na zelf-leren).

**Nieuw — Mythic+:**
- `Modules/MythicPlusData.lua` — affix-ladder (+2 Lindormi's Guidance … +12 Xal'atath's
  Guile), de 4 wekelijkse Xal'atath's Bargain-varianten, per-dungeon must-kicks (alleen
  dungeons met schone method.gg-bron — Magisters'/Nexus-Point/Windrunner bewust nog niet)
  + helpers `GetMythicPoolDungeons`/`GetMythicKicks`.
- `Locales/MythicPlus.lua` — 26 keys × 6 talen.
- `Modules/DungeonGuide.lua` — nieuwe **"Mythic+"-subtab** naast This week/Dungeons 101/
  Dungeon Coach. Toont affix-ladder (level-prefix), Bargain-varianten (EditBox met
  klikbare links), de 8-dungeon-pool (dynamische gelokaliseerde namen), systeem-weetjes
  (Resilient Keystones, Waystones, crests) en must-kicks. `FillMythic()` herbouwt de
  dynamische tekst bij elke refresh → taalwissel komt mee.
- **Beginnersmodus (Rob 15 jun, voor zijn zus — toegankelijkheid).** Toggle bovenaan de
  Mythic+-view (`ns.db.ui.mplusBeginner`): aan = rustige, jargon-vrije laag (intro "wat is
  een key", "start hier: Follower/Normal, geen timer, kan niet falen" + woordenboek dat
  kick/soak/tank/key/affix/CC/dispel/wipe in gewone taal uitlegt); de hele expert-laag
  verbergt dan via `hiddenFn`. Uit = volledige info. `MythicPlusData.lua` `MPLUS_GLOSSARY`
  (12 termen) + `Locales/MythicPlus.lua` apart beginner-blok ×6 talen.
- **"Deze week, voor jou"-kaartje (idee 3).** In de beginnersmodus bovenaan: een rustig
  plan dat naar Follower/Normal stuurt (geen timer, kan niet falen, mag altijd weg), een
  "bonus deze week"-regel als de dungeon-of-the-week bekend is (`GetDungeonOfTheWeek`,
  anders verborgen — never-lie), en een "begin niet met Maisara (zwaarste)"-tip.
- **Getemde één-taak melding (idee 2) — `Modules/AccessibleAlerts.lua`.** Opt-in (standaard
  uit). Tijdens een dungeon/scenario flitst ÉÉN grote, rustige melding (met geluid) zodra
  een vijand vlakbij een ONDERBREEKBARE cast start → "Interrupt!" + spellnaam. Anti-spam:
  4s globale pauze + 6s per spell. Eerlijk-by-design: triggert op de live
  `UnitCastingInfo`-interruptvlag, niet op een verzonnen dungeon-spell-lijst. Taint-veilig
  (UNIT_SPELLCAST_* + frame, zoals RitualBossCoach). Aan/uit + testknop in de
  beginnersmodus; `ns.db.alerts.enabled/sound`; `ns.ToggleAccessibleAlerts`. Locale ALERT_*
  ×6 talen. Alle 3 toegankelijkheidsideeën van Rob (voor zijn zus) hiermee klaar.
- `Locales/DungeonGuide.lua` — DGN_SUBTITLE ×6 bijgewerkt ("Mythic+ volgt later" → "plus
  een Mythic+-tab met affixen en must-kicks").
- `MidnightHelper.toc` — RaidTips, MythicPlus (locales) + RaidCoachData, MythicPlusData
  (modules) toegevoegd op de juiste laadvolgorde.

**Review-punten:** RaidCoachData/MythicPlusData/RaidTips/MythicPlus parsen schoon
(luaparser, non-ASCII geneutraliseerd). DungeonGuide + SporefallCoach: bash-mount kapt ze
af (false parse-fail op resp. r.588/r.112) → host-Read bevestigt complete, gebalanceerde
files. Locale-pariteit: 6 merge-blokken per nieuw locale-bestand (host-Grep). Taint:
geen secret-arithmetic aangeraakt. Commit vanuit Cursor.

## Voor Cursor — review + commit batch 15 juni #3 (ADDON_ACTION_FORBIDDEN écht gefixt)

**STATUS: ✅ GECOMMIT in release 1.8.0 (`58e4edb`).**

Voorgesteld bericht:

> fix(ritualboss+dungeoncoach): CLEU→UNIT_SPELLCAST_START (ADDON_ACTION_FORBIDDEN) + dungeon-coach accordion

**Context:** de fix in batch #2 (`5c87e90`) verplaatste de CLEU-registratie naar
laadtijd, maar dat was niet genoeg: Rob kreeg de fout **opnieuw bij het inloggen**
(`RitualBossCoach.lua:144 in main chunk`). Conclusie: in deze 12.x-client is
`RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")` zélf beschermd — CLEU mag dit addon
helemaal niet registreren, ongeacht context. MH heeft ook nooit CLEU gebruikt; de
bestaande pattern is `UNIT_SPELLCAST_*` (zoals DelveItemsPopup).

**Gewijzigd:**
- 🐛 **`Modules/RitualBossCoach.lua`** — CLEU volledig verwijderd (geen `clf`-frame,
  geen `COMBAT_LOG_EVENT_UNFILTERED` meer). De cast-alert luistert nu via
  `UNIT_SPELLCAST_START` + `UNIT_SPELLCAST_SUCCEEDED` op de bestaande `f`-frame
  (gewone, niet-beschermde RegisterEvent). Nieuwe `OnUnitSpellCast(spellID)` gate't
  op `inScenario` en houdt de 3s-throttle + `ALERT_SPELLS`-lookup aan. OnEvent-
  handler vangt nu `arg3` (spellID) op. Comments bijgewerkt (geen clf-verwijzingen
  meer).
- ✨ **`Modules/DungeonGuide.lua` — Dungeon Coach accordion** (Rob 15 jun: twee
  dungeons bleven tegelijk open). Bij het openklikken van een dungeon worden nu
  eerst alle andere gesloten (loop over `ui.coachCollapsed` → alles `true`, daarna
  de aangeklikte op `false`). Max één dungeon tegelijk open; nogmaals klikken
  sluit hem. Sessie-gebonden state, geen nieuwe locale-keys.

**Review-punten:** geen CLEU-registratie meer in het hele addon (host-Grep:
`COMBAT_LOG_EVENT_UNFILTERED`/`clf` komen alleen nog in geen enkele actieve regel
voor). `OnUnitSpellCast` gedefinieerd (r.123) vóór de `f`-frame (r.298) die hem
aanroept. Syntax niet via sandbox-luaparser te checken (mount kapt regel 363 af —
zelfde mount-truncatie als altijd); wijziging is triviaal-valide Lua, host-Read
bevestigt structuur. In-game: ritual ingaan + boss laten casten → flash zonder
forbidden-error; en geen error meer bij login.

## Voor Cursor — review + commit batch 15 juni #2 (weekly-pariteit + progress-bars)

**STATUS: ✅ AFGEROND** — Cursor commit gepusht: `5c87e90`. Geen CF, versie blijft 1.8.0.

Voorgesteld bericht:

> feat(events+home): live event-voortgangsbalken (taint-veilig) + extra weekly-checklist-pariteit

**Gewijzigd:**
- 🐛 **`Modules/RitualBossCoach.lua` — ADDON_ACTION_FORBIDDEN gefixt.** De cast-
  listener registreerde `COMBAT_LOG_EVENT_UNFILTERED` dynamisch bij scenario-start
  → dat gebeurt in een combat/secure-context → "tried to call protected
  RegisterEvent" (Rob 15 jun, 6×). Nu één keer geregistreerd bij het laden
  (schone context); `OnCombatLog` gate't zelf op `inScenario` (goedkoop). Geen
  dynamische (un)register meer.
- 🐛 **`Modules/RitualSites.lua` — actieve-site-detectie gefixt.** Matchte puur op
  positie → een gewone POI bij de INACTIEVE obelisk werd als actief gezien (Rob
  15 jun: MH zei "Daggerspine actief" terwijl de kaart "Ritual Site: Broken
  Throne" toonde). Nu eist `DetectActiveSite` een ritual-naam (site-naam in de
  POI-naam, of generieke "Ritual Site" + obelisk-positie). Geen false positive
  meer; bij onbekend toont de UI eerlijk "rouleert wekelijks".
- `Modules/DungeonBossWindow.lua` + `Locales/DungeonGuide.lua` — boss-picker
  gegroepeerd: "Rituals & Raids" (custom-entries, gesorteerd) bovenaan, "Dungeons"
  eronder. 2 titel-keys (DGN_WIN_PICK_RITUALRAID/DUNGEONS) in alle 6 talen.
- `Locales/RitualTips.lua` — Daggerspine-scaffold verrijkt (×6 talen): Lady
  Selen'vjar + Empowered Mindbreaker met bevestigde namen/stages/locatie
  (Eversong /way 34.9 65.4, naga, 3 stages) + noot "detailed steps in the next MH
  update" zodat de boss niet leeg oogt in de lijst. Abilities zelf wachten op de
  eerste live run (never-lie).
- `Modules/EventScheduler.lua` — `probeProgress` leest de StatusBar-widget van een
  lopend event (Void Incursion 8718→2042 override) in de ticker; barValue/barMax
  worden via `plainNumber` gelaunderd (taint-veilig), `progressPct` als platte
  number op de ongoing-entry.
- `Modules/EventsPanel.lua` — toont "(NN%)" op de Nu-regels.
- `Modules/ResetRoutine.lua` — extra event-weeklies (Abundant Offerings 89507,
  A Nightmarish Task 94446, Gnawing Curiosity 93784, Arcantina 93767) met
  weekly-status (done/turnin/active); alleen getoond als in-log of gedaan
  (never-lie, geen beschikbaarheids-assertie). Hergebruikt GIVER-fmt-keys (6 talen).

**Review-punten:** `lua loadfile` op de 3 .lua (host-geverifieerd: probeProgress/
pct-line geïsoleerd, ResetRoutine via HEAD-reconstructie). Taint-ontwerpregel
gevolgd: alle secret-arithmetic in de EventScheduler-ticker. Commit vanuit Cursor.

## Voor Cursor — review + commit batch 15 juni (quick wins + datamine)

**STATUS: ✅ AFGEROND** — Cursor commit gepusht: `92377c4`.

Voorgesteld bericht:

> feat(coach+codex): reward-previews + Ger'lok cast-alert/steps (Shadowbolt Volley 1273031) + Turbulent Timeways & Omnium Folio codex + datamine-oogst

**Gewijzigd:**
- `Modules/EventInfoData.lua` — Stormarion (8419) `rewards = {257180, 265030}`
  (mount Contained Stormarion Defender + pet Kai) → shift-klik-reward-gallery werkt.
- `Modules/ModelPreview.lua` — `ns.ResolveItemSpec` (gedeeld door PreviewItem +
  de reward-gallery, zodat mount/pet/gear correct renderen).
- `Modules/EventsPanel.lua` — gallery gebruikt ResolveItemSpec.
- `Modules/RitualBossCoach.lua` — cast-alert Shadowbolt Volley **1273031**.
- `Locales/RitualTips.lua` — `RITUAL_ALERT_SHADOWBOLT` ×6 + Ger'lok-steps ×6
  verrijkt met {SPELL:1273031} (interrupt) en {SPELL:1279186} (LoS).
- `CHANGELOG.md` — `[Unreleased]`-blok (versie blijft 1.8.0; geen TOC-bump).
- `docs/DATAMINE_HAUL.md` (NIEUW) — web+addon-oogst 15 jun (reward-IDs, Ger'lok-
  spells, meer raids ontdekt, Turbulent Timeways, MidnightRoutine/HandyNotes/DBM-
  kruisreferenties); `docs/SESSION_NOTES.md`.
- **Codex-artikelen (top-3 #1+#2):** `Modules/MidnightCodexData.lua` (2 articles:
  omnium_folio in 'weekly', turbulent_timeways in 'world') + `Locales/Codex.lua`
  (CODEX_FOLIO_*/CODEX_TT_* en+nl; rest fallback). Datamined, marked confirm-at-launch.
- `docs/ROADMAP.md` — feature-backlog 15 jun ("onthouden": weekly-pariteit, live
  progress-bars, meer raid-coaches, reward-galleries, Rares.lua, emote-listener, …).

**Review-punten:** `lua loadfile` op de gewijzigde .lua (host-geverifieerd met
luaparser + Grep-pariteit 6/6). Spell-IDs 1273031/1279186 zijn live (12.0.5) →
links resolven meteen; Rotmire/Showdown-IDs zijn 12.0.7. Commit vanuit Cursor.

## Voor Cursor — review + commit batch 14 juni #2 (boss-coach-trio)

**STATUS: ✅ AFGEROND** — Cursor commit gepusht: `43b04cf`.

Voorgesteld bericht:

> feat(coach): Sporefall raid-coach (Rotmire) + Daggerspine ritual-scaffold + cast-alerts Broken Throne

**Nieuw (2):** `Modules/SporefallCoach.lua` (Rotmire 254176 als boss-entry +
tips + ENCOUNTER_START-auto-open, zelflerend encounterID), `Modules/DaggerspineCoach.lua`
(Lady Selen'vjar 257498 + Mindbreaker-stage als scaffold, picker/model klaar).

**Gewijzigd:** `Modules/RitualBossCoach.lua` (CLEU cast-alerts: flash bij
Binding Nebula 1284125/1284106 + Dissonant Reflections 1284081/1284085, alleen
tijdens het scenario, 3s throttle), `MidnightHelper.toc` (2 modules), en **alle 6
locales**: `Locales/RitualTips.lua` (RAID_BOSS_ROTMIRE_*, RITUAL_BOSS_MINDBREAKER/
SELENVJAR_STEPS, RITUAL_ALERT_*) + `Locales/{enUS,nlNL,deDE,frFR,esES,ptBR}.lua`.

**Lokalisatie-pass (14 jun #2 incl.):** alle nieuwe features van vandaag —
Events-tab, world-events, event-info, weekly-status, model-preview én de
boss/alert-tips — zijn nu **volledig vertaald naar DE/FR/ES/PT** (waren enUS-
fallback). Key-pariteit 6/6 host-geverifieerd, %s-format-specifiers gelijk, geen
ZWSP. (Eerdere "ptBR mist GERLOK_STEPS" was vals alarm = mount-lag; ptBR had 'm
al. Alle boss/alert-keys staan 6/6, host-geverifieerd via Grep.)

**Review-punten:** `lua loadfile` op de gewijzigde .lua. Spell-IDs zijn 12.0.7
(resolven de spell-links pas live). Commit vanuit Cursor (host), niet Cowork
(mount gaf weer afgekapte reads — host-geverifieerd met luaparser + Grep-pariteit).
Geen CF-upload.

## Voor Cursor — review + commit batch 13 juni (Events-tab / Broker-absorptie)

**STATUS: ✅ AFGEROND** — Cursor commit gepusht: `81976b1` (basis `03fa4ac` +
uitbreiding 14 juni: event-info, weekly-status, hybride routing, ModelPreview).

Eén cohesieve commit (of splits per logische groep — bestandslijst hieronder).
Voorgesteld bericht:

> feat(events+ui): Events-tab, EventScheduler + /mh eventspy, event-info + weekly-status, hybride next-waypoint-routing, roteerbare 3D-model-preview (1.8.0)

⚠️ **Commit vanuit Cursor (host), niet vanuit Cowork** — de Cowork-mount gaf
vanavond afgekapte reads; alleen de host-bestanden zijn compleet. Geen CF-upload.

**Nieuw (4):**
- `Modules/EventScheduler.lua` — taint-veilige wereld-event-lezer (dedicated
  ticker → platte tabellen; alle scheduler/widget-reads gelaunderd via pcall),
  getters + zone→uiMap/naam-cache (persistent in SavedVars).
- `Modules/EventInfoData.lua` — event-info op areaPoiID (8419 Stormarion, 8423
  Haranir), web-geverifieerd (Icy Veins / Sportskeeda / Boostmatch).
- `Modules/EventsPanel.lua` — eigen Events-tab (Nu bezig / Komt eraan, klikbare
  live-events → AddSmartTomTomWay, hover-tooltips, live mee-tikkend).
- `docs/BROKER_ABSORPTION_PLAN.md` — analyse Broker_MidnightEvents (GPL-2.0:
  aanpak/IDs only) + fase-roadmap.

**Gewijzigd (9):**
- `Core.lua` — `/mh eventspy`-subcommando.
- `UI.lua` — Events-tab registratie (TAB_DEFS + dispatch + keyById).
- `Modules/WorldContent.lua` — push/Relayout kleine regel-knophoogte; A3-blok
  hieruit verplaatst naar de Events-tab (Void & Rituals weer puur Ritual+Void).
- `MidnightHelper.toc` — 3 modules + **versie 1.8.0**.
- `Locales/enUS.lua` + `Locales/nlNL.lua` — TAB_EVENTS/EVENTS_*/WORLD_EVENT_*/
  EVENT_INFO_*-keys. DE/FR/ES/PT vallen terug op enUS (vertalen = backlog).
- `CHANGELOG.md` — [1.8.0]-blok.
- `docs/PTR_12.0.7_DATA.md` — live zone-uiMapIDs (Voidstorm 2405, Harandar 2413,
  Eversong 2395) + `/mh eventspy`-route naar Val-uiMapID.
- `docs/TOMORROW.md` — batch-samenvatting + morgenochtend PTR-plan.

**Uitbreiding 14 juni (zelfde batch):**
- **Event-info-laag** `Modules/EventInfoData.lua` (NIEUW) + **weekly-status per
  event** (`ns.GetWeeklyQuestStatus`, Kaliel's-Tracker-techniek) → gekleurde tag
  in de Events-tab. Quest-koppeling: Stormarion 8419→94581, Haranir 8423→89268.
- **Hybride next-waypoint-routing** `ns.AddSmartQuestRoute` in `Modules/Delves.lua`
  (volgt live quest-objectief via GetNextWaypoint, anders fallback-coords);
  Events-tab-klik gebruikt 'm.
- **Docs:** `docs/ADDON_LEARNINGS.md` (NIEUW; Kaliel's Tracker-learnings),
  `docs/PTR_12.0.7_DATA.md` (uitgebreide datamining 14 jun), `docs/TOMORROW.md`,
  `docs/BROKER_ABSORPTION_PLAN.md`.
- **Hybride routing toegepast op route-knoppen:** `Modules/RitualSites.lua`
  (RouteSite volgt bij de actieve site + weekly-in-log het live objectief, anders
  obelisk-coords; quiet re-assertion ongewijzigd) en `Modules/ResetRoutine.lua`
  (void-weekly "inlog"-stap zet nu een waypoint naar het objectief i.p.v. alleen
  het tabblad openen). Hub-knoppen blijven bewust "pickup".
- **Roteerbare 3D-model-preview** `Modules/ModelPreview.lua` (NIEUW):
  `ns.ShowModelPreview(spec|lijst)`, `ns.PreviewItem`, `ns.PreviewCreature` —
  sleep=draaien, scroll=zoom, spin/reset, prev/next, ESC. Hooks: **B** `/mh model
  [item-link | itemID | npc <id>]` (Core.lua); **A** shift-klik op een event in
  de Events-tab → reward-gallery (mechaniek klaar; reward-item-IDs per event nog
  in te vullen in EVENT_INFO.rewards); **C** `/mh model npc <id>` voor bosses.
- **Model-preview verfijnd + ingebouwd in boss/rare-vensters:** gear/wapens
  worden nu via DressUpModel op je personage gepast (TryOn) i.p.v. een leeg
  SetItem-model; mounts → mount-display; decor/toy → SetItem. **Hook C**:
  shift-klik op het mini-model in het boss-venster (`Modules/DungeonBossWindow.lua`)
  én op een rare-toast (`Modules/MidnightToast.lua`) opent de grote roteerbare
  preview via `ns.PreviewCreature`.
- Extra gewijzigd t.o.v. lijst hierboven: **`Modules/Delves.lua`**,
  **`Modules/EventInfoData.lua`**, **`Modules/EventsPanel.lua`**,
  **`Modules/RitualSites.lua`**, **`Modules/ResetRoutine.lua`**,
  **`Modules/ModelPreview.lua`** (nieuw), **`Modules/DungeonBossWindow.lua`**,
  **`Modules/MidnightToast.lua`**. `git add -A` pakt alles mee.

**Review-punten:**
- **Luacheck/loadfile draaien** — de Cowork-mount gaf vanavond truncatie-false-
  positives; alle nieuwe/gewijzigde .lua zijn host-geverifieerd met een
  Lua-parser (luaparser), maar bevestig graag met `lua loadfile`.
- Geen taint-exposure toegevoegd: alle secret-reads zitten in de
  EventScheduler-ticker; render/click-paden lezen alleen platte waarden.
- Geen CurseForge-release zonder Robs expliciete vraag.

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
`77581cc` / `1ca4eb5` / `07cbc48` / `7a68e00`)

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
keys ×6 (SHARD_CAP_TOAST_TITLE_FMT/_BODY + SHARD_CAP_CHAT_FMT).
**In-game ✅ (Rob, zelfde avond): toast verscheen precies op het
600-moment.** Body was te lang voor het toast-frame (afgekapt met "…") →
SHARD_CAP_TOAST_BODY ×6 ingekort tot één kernzin ("Geen shards meer uit
rares of world quests tot de reset."); de volledige uitleg blijft in de
chatregel. Hertest bij de volgende cap (alt) of via taalwissel-blik.

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

## Voor Cursor — commit + push Dungeon Coach fase 3 batch 1 (`4d72666` /
`e67dd00` / `0ec7fa1`)

Boss-stappen **nog niet in-game geverifieerd** (follower-runs 11 juni) — commit
OK, release pas ná Robs verificatie. Geen CF-release.

## Voor Cursor — review + commit Dungeon Coach fase 3, batch 1 (10/11 juni)

Eerste boss-stappen-batch: **Windrunner Spire + Maisara Caverns** (Normal).
Eigen MH-tekst in beginner-taal, gekruisrefereerd tegen BossHelper (MIT) en
DungeonHelper op Robs machine — **in-game verificatie door Rob in
follower-runs staat nog open vóór dit in een release gaat.**

1. **`Modules/DungeonTipsData.lua` (nieuw, in TOC):** `ns.DUNGEON_TIPS`
   per dungeon-key → boss-key → { steps, tank, healer } locale-keys
   (`DGN_TIP_<DGN>_<BOSS>_<SECTIE>` — share-sync-klaar voor fase 5) +
   `GetDungeonBossTips` / `DungeonHasTips`.
2. **`Locales/DungeonTips.lua` (nieuw, in TOC):** 21 keys ×2 (EN/NL; audit
   42 ✓) — 7 bosses met genummerde stappen + tank/healer-regels.
3. **`Modules/DungeonGuide.lua`:** Coach-weergave toont per boss de stappen
   (bossnaam goud, tank-regel blauw, healer-regel groen); dungeons zónder
   content tonen per dungeon eerlijk de "volgt nog"-regel (globale
   soon-note vervallen).

**Cursor: loadfile op DungeonTipsData.lua, Locales/DungeonTips.lua,
DungeonGuide.lua + TOC-parse (2 nieuwe regels).**

**In-game test (Rob):** Dungeons-tab → Coach: WS + Maisara tonen per boss
stappen + gekleurde rol-regels; overige dungeons "volgt nog"; taal wisselen
EN↔NL vertaalt alles. **Verificatie-runs:** follower-run WS en Maisara —
kloppen de stappen in de praktijk (vooral: Derelict Duo hook-door-de-
spookdame, Muro'jin ijsval-tegen-duikvlucht, Vordaza fantoom-pops één
tegelijk)? Correcties direct doorgeven, dan slijp ik de tekst.

## Voor Cursor — 11 juni ochtend: Overload-correctie gathering-101 (×6)

Robs vraag "wat is dat extra-loot-ding bij gathering?" legde een **feitfout**
in onze 101-teksten bloot: Herbalism/Mining-hoofdstukken zeiden "(30-minuten-
cooldown)" voor Overload — fout. Research (Icy Veins / wow-professions /
Method, 11 jun): **Overload Infused Herb/Deposit** wordt geleerd bij je
eerste speciale node; geeft een lading motes; eerste keer per kruid-/ertssoort
+1 KP; **cooldown = 12 uur basis, –±30 min per gegatherde node** (dáár kwam
de 30 min vandaan); 2e charge bij 40 root-punten; trees "Midnight Overload"
(Herb) / "Over-LODED" (Mining) buffen verder; infused soorten Lightfused /
Wild / Primal / Voidbound (Lightfused & Voidbound = meeste motes). De
Overload-zin in `PROFACAD_CH_HERBALISM_BODY` + `PROFACAD_CH_MINING_BODY` is
in **alle 6 talen** herschreven met de juiste feiten. (Skinning-tekst was al
correct: Diffusers/Lures, geen node-overload.) **Cursor: loadfile op de 6
hoofd-locales; meenemen in de eerstvolgende commit-batch.** Rob: check de
nieuwe alinea in-game op je Herb/Mining-alt — klopt het verhaal met wat de
tooltip zegt?

## Voor Cursor — 11 juni: level-eligibility-pass routine (Robs lvl-80-test)

Rob deed de geplande low-level-test met een **verse level-80 warlock**
(Alch+Herb). Bevindingen + fixes (alles in ResetRoutine.lua + 1 key ×6):

- **Liadrin & Aethas bieden op 80 NIETS** → `minLevel = 90` in
  GIVER_WEEKLIES (gedocumenteerde aanname: endgame-weeklies; 81-89 niet
  apart getest). Routine toont sub-90 nu grijs "beschikbaar vanaf level 90"
  via de bestaande locked-state.
- **Halduron biedt sub-90 een leveling-variant**: "Hope in the Darkest
  Corners" = **95468** (XP + Quel'Thalas Adventurer's Cache) → toegevoegd
  aan zijn quest-lijst ("any") — levelaars krijgen nu ook echte status.
- **Great Vault bestaat gewoon op 80** (rijen Raids/Dungeons/World
  zichtbaar) → regel 1 was correct, geen gate. Bijvangst vault-tooltip:
  World-rij telt Delves T1-11, World Activities T1, Prey T1/5/8, **Ritual
  Sites T5/6/7/12/13 per difficulty** → genoteerd voor VaultAdvisor-data.
- **Lilatha biedt de Void-zoneweekly (94385) aan op 80** ✓ — regel 6 klopt;
  intro-keten-stap "Outfitting and Allies" stond ook klaar.
- **Trainer-soort weeklies zijn SKILL-gated**: verse skill-1 Herbalism →
  Nathera biedt niets; Ench vereist aantoonbaar 25; Robs gelevelde
  Herb-alt kreeg 'm wel. Service-soort is NIET skill-gated (verse skill-1
  Alchemy kreeg de hele Flaresworn→Camberon-keten + weekly 93690 — itemID
  263454-notebook bevestigt de MidnightRoutine-data nogmaals). Fix:
  trainer-soort met skill < 25 toont nu dim "wordt op lage skill nog niet
  aangeboden" (`HOME_ROUTINE_TRAINER_LOWSKILL_FMT` ×6) i.p.v. een loze
  ophaal-opdracht; drempel 25 = Ench-verified, aanname voor gatherers
  (comment in code). GetProfessionInfo-skillLevel (ret3) nu meegelezen.

**Cursor: loadfile op ResetRoutine.lua + de 6 locales; let op de
geneste if in de trainer-stap (inspringing mag genormaliseerd).** Rob-test:
op de warlock horen na /reload regels 2/4 grijs "vanaf level 90" te zijn,
regel 3 (Halduron) blauw "opgepakt" (95468 in log), regel 8 (Herbalism)
dim "lage skill", regel 7 (Alchemy) blauw/groen na de keten.

## Voor Cursor — 11 juni: Zygor-mine → dungeon-entrees + route-knoppen

Robs Zygor-idee leverde direct op (TOMORROW punt 4 ✅). Bron:
ZygorGuidesViewer LibRover-portaaldata + Midnight-zonetabel (proprietary →
alléén feitelijke coords/IDs als kruisreferentie, geen tekst; bron in
code-comment gedocumenteerd; Rob spot-checkt in-game).

- **Alle 12 `entrance`-velden gevuld** in `DungeonRosterData.lua`:
  Maisara Zul'Aman 43.74/39.43 · Nalorakk Zul'Aman 29.79/84.51 ·
  Windrunner Spire Eversong 35.37/78.82 · Murder Row SMC 57.20/61.06 ·
  Blinding Vale Harandar 26.24/78.09 · Voidscar **Slayer's Rise 2444**
  53.67/33.08 · Nexus-Point **Voidstorm 2405** 64.93/61.78 · Magisters'
  **Quel'Danas-Midnight 2424** 63.53/15.48 · Skyreach Spires of Arak (542)
  35.6/33.7 · Pit of Saron Icecrown (118) 54.78/91.80 · Triumvirate
  Eredath (882) 22.30/55.89 · Algeth'ar Thaldraszus (2025) 58.27/42.22.
- **Zygors Midnight-zonetabel als bijvangst genoteerd**: Voidstorm=2405(+2479),
  Slayer's Rise=2444 (eigen zone!), Harandar=2413(+2480/2576), Quel'Danas
  M=2424, Atal'Aman=2535/2536 (← het mysterieuze treasure-zone-ID),
  Zul'Aman=2437(+2580). Let op: Rares.lua mapt 2444→"voidstorm"-key —
  cosmetisch correct genoeg voor rares, maar wel weten.
- **`ns.RouteDungeonEntrance(d)`** (RosterData): TomTom-pin + reis-assistent
  (AddSmartTomTomWay → HS/portal-advies bij verre targets — Icecrown/Argus!).
- **Coach-view: rode "Route naar <dungeon>"-knop per dungeon** (hergebruikt
  HOME_WB_ROUTE_BTN_FMT ×6, dus geen nieuwe keys; label ververst met
  EJ-naam in refresh).
- 12.0.7-scan in Zygor: **niets bruikbaars** (Naigtal-hits = oude
  Legion-invasiepunten). Curiositeit: "Imperator Pertinax npc **252308**"
  in een Eversong-event-guide — ánders dan onze Val-worldboss 263670;
  mogelijk pre-patch-event-versie, niet verwarren.

**Cursor: loadfile op DungeonRosterData.lua + DungeonGuide.lua.**
**Rob-test:** Coach → rode route-knop per dungeon; klik Windrunner Spire →
pijl naar Eversong 35/79 + (van ver) reis-popup; klik een legacy (Pit of
Saron) → HS/portal-advies. Pin-posities spot-checken waar je toch bent.

## 11 juni: web-research 12.0.7 (stap 3 — alleen docs, geen code)

Bron: Wowhead-news 381787 (Blizzard-blog) + releaseberichten. Alles verwerkt
in `docs/PTR_12.0.7_DATA.md` (nieuwe kop bovenaan). Hoofdpunten:

- **🔴 Release bevestigd: dinsdag 16 juni** (niet 30 juni) → TOC-actie
  (`120005` eruit) staat klaar in RELEASE_CHECKLIST; Showdowns-gate ≥120007
  doet de rest vanzelf.
- **Rotatie wekelijks bevestigd** (open punt §7 ✅) → VoidAssaults-patroon
  herbruikbaar.
- **Portaal zit in Voidstorm/Howling Reach (2405)** — coords nog dumpen.
- **Folio-weekly is account/warband-breed** → AccountWeeklyChecklist-regel
  wordt account-niveau, géén per-char (semantiek-waarschuwing in doc).
- Nieuw: HWT-advies-ilvl 274, Decimus (HWT→Myth-track, ID ⬜), toy
  Lightveil Recall Beacon, vendors Ventem/Zuronar + valuta "Voidlight Marl"
  (ID ⬜), achievement "Showdown Success: Val" 62880.
- **Niet via web vindbaar:** "Showdown on Val"-quest-ID, Val-uiMapID,
  rare-coords/kill-quests, Mote-ID — blijft Robs PTR/live-lijstje (§1-§5).

**Cursor: alleen docs gewijzigd (PTR_12.0.7_DATA.md, SESSION_NOTES.md,
TOMORROW.md) — geen luacheck nodig; meenemen met de volgende push.**

## 11 juni: hotfix derden-addons (lvl-80-errorspam — NIET ons addon, geen commit)

Robs lvl 80 kreeg 100+ errors. Oorzaak: Midnights **secrets-systeem** maakt
aura-velden (canActivePlayerDispel, spellId, dispelName…) geheim voor
addon-code in combat; vergelijken/indexeren gooit errors.

- **MidnightHealerHelper 1.0.632** (DruxlyeSofty, CF 1091858): nieuwe
  dispel/HoT-indicator-feature leest die velden direct. **Lokale hotfix in
  diens `Dispel.lua`**: `MHH_HasSecret(...)`-guard (issecretvalue) bovenin
  `IsTrackedDispellableAura` + `IsTrackedPlayerHotAura` → secret-aura's
  worden overgeslagen. Gevolg: geen errors meer; indicator kan in combat
  voor secret-aura's simpelweg niet tonen (by design). Addon-update
  overschrijft de hotfix — prima; check CF op >1.0.632.
- **EllesmereUIQoL 8.1.1**: auto-open-containers roept `UseContainerItem()`
  aan — nu protected, feature dood. Uit te zetten:
  `/run EllesmereUIDB.autoOpenContainers = false` + `/reload`.
- **Les voor MH:** secrets raken aura/combat-lezende code. MH leest vooral
  quest/currency/vault/EJ-API's → laag risico, maar bij toekomstige
  combat-features eerst `issecretvalue`-strategie bepalen.
- Verificatie: host-bestand intact (847 regels); sandbox-parser gaf de
  bekende mount-truncatie-false-positive (mount stopte op 812 mid-token).
- **Restpuntje (bewust gelaten):** 4× ADDON_ACTION_FORBIDDEN "UNKNOWN()"
  bij login uit MHH Dispel.lua-eventregistratie (via pcall-wrapper
  Compatibility.lua:59) — Blizzard heeft registratie van bepaalde
  combat-events protected gemaakt; pcall vangt de Lua-fout maar het
  forbidden-log blijft. Onschuldig (addon draait door), fix = auteur.
  Robs hotfix-test ✅: secretvalue-spam weg, Ellesmere stil.

## Voor Cursor — 11 juni: rare-detectie false positives (RareScanner-les)

Rob: UP-melding/alert terwijl de rare er niet is. Oorzaak: wij matchten
**elke** vignette binnen 130 yd van de spawn (ook treasures/events/POI's).
RareScanner filtert op atlas en matcht op npcID — overgenomen in
`Modules/Rares.lua` (alleen dit bestand):

- `RARE_KILL_ATLAS` whitelist (VignetteKill/VignetteKillElite/
  vignettekillboss — RSConstants.IsNpcAtlas) + `VignetteKillClass(info)`
  (true/nil/false; nil = atlas onbekend → alleen naam-match toegestaan).
- `NpcIdFromObjectGUID(guid)` — veld 6 van objectGUID, à la RSButtonHandler.
- Matchprioriteit (UP-cache én alert-pad): 1) npcID exact (nieuw optioneel
  6e dataveld `npcId`, nog nergens gevuld — 12.0.7-rares krijgen ze als
  eerste), 2) naam-roughmatch, 3) afstand ≤130 yd **alléén nog bij
  kill-atlas** (vangnet voor gelokaliseerde vignette-namen).
- `kill == false`-vignettes worden in beide paden volledig overgeslagen.
- `/mh rarescan` print nu ook `atlas=`, `kill=`, `npc=` per vignette.

**Bonus (Robs vraag n.a.v. RareScanner-screenshot): 3D-model in de
rare-toast.** RareScanner is **All Rights Reserved** → code/data niet
overnemen; het idee wel, via Blizzards publieke API. Eigen implementatie:

- `MidnightToast.lua`: `PlayerModel`-frame in het icon-slot (eager
  aangemaakt, EnableMouse(false)); nieuw spec-veld **`npcId`** → toast toont
  het 3D-model van de NPC i.p.v. het icoon (`SetCreature(npcID)` — zelfde
  route als DBM-GUI/MDT, géén displayID-database nodig; `SetPortraitZoom
  0.62`). Geen npcId of model → icoon zoals voorheen (drakenkop blijft
  fallback).
- `Rares.lua`: `FireRareAlert(rare, npcId)`; live-alert geeft het npcID uit
  de vignette-objectGUID door (werkt dus óók waar dataveld rare[6] leeg is).
- Iteratie 2 na Robs Duskburn-screenshot (model te klein, linksonder in
  slot): model nu 56×56 los van het icon-slot (LEFT+8, verticaal
  gecentreerd), PortraitZoom 0.85, SetFacing 0.45 (3/4-aanzicht); icon-slot
  + kwaliteitsring verborgen zodra het model toont (lege ring oogt kapot).
  `FireRareAlert` bewaart het laatste echte npcID in
  `ui.rareAlert.lastNpcId` zodat **`/mh raretest` het model hertoont** —
  finetune-loop zonder nieuwe spawn.
- Iteratie 3 (Rob, Lady Liminus-screenshot: "2× zo groot, als ie maar
  verplaatsbaar is"): **toast versleepbaar** (SetMovable + RegisterForDrag;
  klik=waypoint blijft — drag start pas na de drempel) met positie bewaard
  in `ui.toast.pos` (offset t.o.v. UIParent-midden, schaal-onafhankelijk).
  Nieuw spec-veld **`scale`** (default 1); rare-alert geeft `scale = 2`
  mee. SetPoint-offsets gedeeld door schaal zodat 2×-rare en 1×-shard op
  dezelfde schermplek verschijnen. Geen nieuwe locale-keys.
- Iteratie 4 (Robs Warden-screenshot): **tooltip-fossiel** "Click to open
  delve items" op de rare-toast → nieuw spec-veld `clickHintKey`
  (MidnightToast OnEnter; fallback blijft TOAST_CLICK_HINT voor de
  delve-bounty-toast); rare-alert gebruikt RARE_ALERT_CLICK_HINT.
  Plus **instelling "alleen melden tijdens rare-hunt"** (Robs vraag):
  sessievlag `rareHuntActive` in Rares.lua, gezet door RouteRare (route-
  knop paneel/toast-klik); `ui.rareAlert.onlyWhileRouting` (default uit =
  huidig gedrag); `ns.SetRareAlertOnlyWhileRouting`; sub-checkbox in het
  Broker-settingspaneel (ingesprongen onder de rare-alert-checkbox,
  openMain-anker verlegd). 3 nieuwe keys ×6 hoofdlocales (18 regels):
  RARE_ALERT_CLICK_HINT, SETTINGS_RARE_ALERT_ONLYROUTE(+_TT).
  Luacheck-lijst hierdoor: **Rares.lua, MidnightToast.lua, Broker.lua** +
  encoding-sweep 6 hoofdlocales.
- Iteratie 8 (Rob: shard-cap-toast ✅ na unstick; wil uniek opvallend
  geluid): nieuw toast-spec-veld **`soundKit`** (MidnightToast, afgespeeld
  bij tonen, Master-kanaal, pcall). Live-test Rob: UI_LEGENDARY_LOOT_TOAST
  bleek nauwelijks hoorbaar (ook met speakers hard) → **READY_CHECK**
  (Robs keuze, bewezen luid). Rare-alert houdt zijn eigen wekker-geluid.
  Debug-tussenstap: nieuw commando **`/mh shardtest`** (Core.lua-dispatch +
  `ns.TestShardCapAlert` in ShardCapAlert.lua) — vuurt de toast incl.
  geluid direct af, zonder dedupe/cap-eis; print het soundkit-ID. ✅ Rob
  bevestigt: kit én toast-pad klinken (eerdere stilte = stale code vóór de
  reload). Luacheck-lijst: +**Core.lua**, **ShardCapAlert.lua**.
- Iteratie 7 (Rob: óók na reload nog "click to add" tijdens de zone-route):
  twee gaten — sessievars overleefden /reload niet én GenerateRaresRoute
  (route-alle-rares) zette de hunt-status helemaal niet. Herontwerp:
  `lastRoutedRareId`/`rareHuntActive` vervangen door **persistente set**
  `ui.rareAlert.routedIds` + `routedAnchor` (week-anker à la ShardCapAlert).
  MarkRareRouted (RouteRare vervangt set bij clearOthers, toast-klik vult
  aan; GenerateRaresRoute markeert de hele route), IsRareRouted (per rare →
  aankomst-tekst), IsRareHuntActive (**hunt dooft vanzelf zodra alle
  geroutete rares done zijn**, of bij reset/nieuwe route). Settings-tooltip
  ONLYROUTE_TT ×6 herschreven naar het nieuwe gedrag (never-lie). De
  beschrijvingen in iteratie 4/5 hieronder zijn hiermee deels achterhaald.
- Iteratie 6 (Rob: 600/600 gehaald, géén shard-cap-melding): dedupe werd
  gezet bij **queuen**; cap viel tijdens de rare-hunt → shard-toast stond
  achter een rare-toast in de wachtrij → /reload (veel getest vandaag) →
  wachtrij weg, week tóch afgevinkt. Fix: nieuw toast-spec-veld **`onShow`**
  (MidnightToast, pcall bij daadwerkelijk tonen); ShardCapAlert zet de
  week-dedupe + chatregel nu in onShow. Fallback zonder toast-systeem
  markeert wel direct. Rob-unstick:
  `/run local g=UnitGUID("player") if MidnightHelperDB.shardCapAlert then MidnightHelperDB.shardCapAlert[g]=nil end` + /reload.
- Iteratie 5 (Robs Terrinor-screenshot, onderweg náár de geroutete rare):
  "click to add a waypoint" terwijl je er al heen vliegt is onzinnig →
  `lastRoutedRareId` (gezet in RouteRare); is de alert-rare het actieve
  route-doel, dan **aankomst-variant**: body RARE_ALERT_TOAST_ONROUTE_BODY
  ("Dit is je route-doel — je bent er bijna!"), géén onClick/klik-hint;
  geluid blijft. Nieuwe key ×6 hoofdlocales.

Luacheck: **Modules/Rares.lua + Modules/MidnightToast.lua**. Sandbox-parser
gaf op beide wederom de mount-truncatie-false-positive (mid-token EOF);
host-staarten geverifieerd intact (Rares 1248, Toast 414) — host is leidend.

**Rob-test:** ga naar een plek waar de false positive optrad (treasure/event
bij een rare-spawn): regel hoort nu grijs/down te zijn. Bij een échte rare:
UP + alert zoals voorheen. Bij twijfel `/mh rarescan` — de regel met
`kill=false -> match=NONE` is de oude boosdoener.

Commitvoorstel: `fix(rares): filter vignettes op kill-atlas + npcID-match
(RareScanner-aanpak) tegen false positives` en
`feat(toast): 3D-model van de rare in de alert-toast via npcId/SetCreature`

**Rob-test (model):** volgende échte rare-alert hoort het model van de rare
te tonen i.p.v. de drakenkop. Shard-cap/vault-toasts blijven iconen.

## Voor Cursor — 11 juni: stap-bewuste ritual-intro-hint (Robs lvl-81-test)

Rob (81, na rift-inlever): geen ritual weekly. Flags: alleen 94381 true →
introlijn halverwege. Lilatha bood níéts aan: de volgende stap (96080 Void
Strike) start in de actieve assault-zone, niet bij haar — maar onze hint
zei "start bij Lilatha". Wowhead bevestigt bovendien (comments 94380):
**de keten is buggy geordend** — 94381 kan true zijn terwijl 94380 false
blijft, exact Robs geval. Geen bewijs voor een level-gate (Wowhead: geen
level-eis).

- `RitualSites.lua`: `RITUAL_INTRO_CHAIN` (5 stappen) + stap-bewuste hint in
  `GetRitualWeeklyHint`: **hoogste voltooide stap + 1** = volgende stap
  (robuust tegen de bug-volgorde); toont "stap X/5: <waar/wat>" + suffix
  "(staat al in je questlog)" als de stap in het log zit. Oude generieke
  INTRO-tekst blijft als vangnet.
- `Locales/RitualTips.lua`: 7 nieuwe keys ×6 talen (42 regels):
  RITUAL_INTRO_STEP_FMT/_INLOG/_SUMMONS/_ALLIES/_VOIDSTRIKE/_PROBLEMS/
  _INTEREST. Stap-teksten geverifieerd via Wowhead-tooltips (94382:
  "investigate reports, disrupt a Ritual Site"; 94383: "check in with Lady
  Darkglen").

Luacheck: **Modules/RitualSites.lua** (+ encoding-sweep RitualTips.lua).

**Rob-test (lvl 81):** Void & Rituals hoort nu te tonen: "Introlijn op dit
personage — stap 3/5: Void Strike — deze stap speelt zich af in de actieve
assault-zone". Daarna Void Strike doen in Eversong → hint hoort door te
schuiven naar stap 4/5.

Commitvoorstel: `feat(rituals): stap-bewuste intro-hint (5 stappen, robuust
tegen Blizzards bug-volgorde) + 7 locale-keys ×6`

## 11 juni: Delves-T3-feit in teksten (terwijl Rob shards farmt)

Robs geverifieerde feit (lvl-80-warlock, 11 jun): **sub-90 zijn Delves
gecapt op Tier 3** — nu verwerkt op de twee kandidaat-plekken uit
TOMORROW.md:

- `Locales/StartHere.lua`: START_S4_BODY ×6 — "(onder level 90 is Tier 3
  het maximum)" ingevoegd vóór de Tier-8/Bountiful-zin.
- 6 hoofdlocales: DELVE_WEEKLY_UNDERLEVEL_HINT ×6 — zin toegevoegd "Tot
  die tijd zijn Delves gecapt op Tier 3." (hint via
  ShouldShowDelveWeeklyUnderlevel/AccountWeeklyChecklist:350).

Alleen locale-strings, geen codewijziging → geen luacheck; wel
encoding-sweep StartHere.lua + 6 hoofdlocales meenemen.

## 11 juni: Dungeons 101 → 4 talen + SafeL-fix (Robs "nog een stapje")

- `Locales/DungeonGuide.lua`: **deDE/frFR/esES/ptBR-blokken toegevoegd**
  (40 keys ×4 = 160 regels; alle 6 blokken nu identiek qua keys —
  6×40=240 geverifieerd). Mens-kwaliteit, game-termen in het Engels per
  conventie (Group Finder, Follower Dungeon, Heroic, Spark weekly, Vault…);
  frFR met spatie vóór ;:!? — header-comment bijgewerkt (EN+NL-pilot →
  alle zes). **Boss-tips (DungeonTips.lua) bewust NIET gelokaliseerd** —
  wachten op Robs follower-run-verificatie (eerst feiten, dan vertalen).
- **Blokje-fix onderweg gevonden:** `Modules/DungeonGuide.lua` renderde
  cursus-bodies met kale `ns:L`, terwijl CH3 "Toolbox → Macros" bevat
  (pijl = bewezen blokje) — gold ook al voor EN/NL! Beide render-paden
  (opbouw regel ~419 + locale-refresh ~514) naar `ns:SafeL`.

Luacheck: **Modules/DungeonGuide.lua**; encoding-sweep
Locales/DungeonGuide.lua. Rob-test: Dungeons-tab → Dungeons 101, hoofdstuk
3 — pijl hoort nu als "->" (of pijl-vervanging van SafeL) te tonen, geen
blokje; met `/mh locale dede` (of een DE-client) steekproef hoofdstuktitels.

Commitvoorstel: `feat(l10n): Dungeons 101 in 6 talen + SafeL voor
cursus-bodies (pijl-blokje CH3)`

## 11 juni: boss-stappen kruisverificatie via DBM-Party-Midnight + Wowhead
## (Robs idee: "staat dat niet tussen mijn andere addons?")

Bron: DBM-Party-Midnight (lokaal, spell-IDs/voice-cues/comments) + Wowhead
nether-spelltooltips. Resultaat van de drie spannendste claims:

- **Derelict Duo hook-door-spookdame: ondersteund.** DBM-comment "Heaving
  Yank happens at same time as Shriek" + voice-cue **"behindboss"** bij de
  Yank (472793); cast-break-claim zelf blijft BossHelper-bron →
  follower-run bevestigt definitief.
- **Muro'jin ijsval-tegen-duikvlucht: BEVESTIGD.** DBM private-aura-cue
  **"runtotrap"** bij Carrion Swoop (1249478) — letterlijk ons advies.
  Bonus: Infected Pinions = dispelbare disease (RemoveDisease) → healer-
  regel ×2 aangevuld met "dispel".
- **Vordaza fantomen: GECORRIGEERD (was gevaarlijk advies!).** Wowhead
  Final Pursuit (1251775): fantoom dat doelwit bereikt/ander fantoom raakt
  **barst voor 254k binnen 3,5 yd** — ons "pop ze door ertegenaan te lopen"
  eruit. Lingering Dread (1251813): schreeuw **bij doden**, vlakke
  groepsschade (geen stack-claim). Nieuwe stappen ×2 (EN/NL):
  dóden vóór bereik, één tegelijk, frontale golf van Unmake ("rotating
  beam"-claim geschrapt — tooltip 1252130: frontal surge + pushback).
- Restpunt voor de follower-run: berserk-claim Muro'jin (DBM-comment
  "Nekraxx can be resurrected" — nuance onbevestigd), orbs/Soulrot-namen
  Vordaza, hook-cast-break Duo.

Alleen Locales/DungeonTips.lua gewijzigd (EN/NL-teksten) → encoding-sweep;
geen luacheck nodig.

Commitvoorstel: `fix(dungeon-tips): Vordaza-fantomen gecorrigeerd (Wowhead
tooltips) + Muro'jin dispel-info; kruisverificatie via DBM`

## Voor Cursor — Dungeon Coach fase 3 batch 2 (11 juni avond): 6 S1-dungeons

Robs vraag "kunnen we niet alles online compleet maken?" → ja: **alle 6
resterende S1-dungeons hebben nu boss-stappen** (21 bosses ×3 secties,
EN+NL). Methode (zelfde als de Vordaza-correctie): DBM-Party-Midnight-mods
(spell-IDs, voice-cues als "runtotrap"/"breaklos"/"catchballs"/"movetobeam",
comments) + Wowhead-spelltooltips (59 stuks opgehaald) — elke mechanische
claim herleidbaar tot een van die twee bronnen. Eigen MH-tekst,
beginnerstaal.

- `Locales/DungeonTips.lua`: +126 regels (63 keys ×2: MR=Murder Row ×4
  bosses, DN=Nalorakk ×3, BV=Blinding Vale ×4, VA=Voidscar ×3,
  NX=Nexus-Point ×3, MT=Magisters ×4); header-comment batch 2 toegevoegd.
- `Modules/DungeonTipsData.lua`: 21 boss-entries onder murderrow/nalorakk/
  blindingvale/voidscar/nexuspoint/magisters (keys conform RosterData);
  bron-comment. Consistentie geverifieerd: 63 refs ↔ 126 locale-regels,
  per-prefix geteld (mount was stale, host-Grep gebruikt).
- Hoogtepunten qua counterplay (uit DBM-cues): Zaen "Murder in a Row" =
  zichtlijn breken; Kasreth Reflux Charge = IN de leyline stappen; Gemellus
  Neural Link = je gelinkte kloon aanraken; Seranel Wave of Silence = IN de
  Suppression Zone staan; Degentrius Essence = inslagen soaken.
- **Status: online-geverifieerd, nog niet in-game gedraaid** — zelfde klasse
  als batch 1; Robs runs blijven de eindcheck. DGN_TIPS_SOON toont nu alleen
  nog bij de 4 legacy-dungeons (Skyreach/PoS/Triumvirate/Algeth'ar) —
  batch 3 kan via DBM-Party-WoD/WotLK/Legion/Dragonflight + Wowhead.

Luacheck: **Modules/DungeonTipsData.lua**; encoding-sweep
Locales/DungeonTips.lua. Rob-test: Coach openen → elke S1-dungeon hoort nu
stappen te tonen i.p.v. "worden geschreven".

Commitvoorstel: `feat(dungeon-coach): fase 3 batch 2 — boss-steps voor alle
6 resterende S1-dungeons (DBM+Wowhead-geverifieerd, EN/NL)`

## 12 juni: ritual-weekly-mysterie OPGELOST (Robs mage) + void-done-fix

Rob: "mage ziet geen ritual weekly bij de hub, voor altijd uitzoeken."
Flag-dump mage: **95843 = TRUE** → de weekly was al voltooid deze week;
de hub is terecht leeg. Niet warband-breed (lvl-81 = false). Verklaring
(Robs eigen herinnering klopt): de introlijn eindigt bij Lady Darkglen
die direct de weekly meegeeft — mage deed 'm samen met de intro-quests
zonder het als "de weekly" te herkennen. Routine toont na reload netjes
done/done; refresh-pad gecheckt (QUEST_LOG_UPDATE → RefreshHomePanel bij
zichtbaar paneel) — geen bug; eerder screenshot was verouderd/andere char.

**Wel gevonden+gefixt:** `VoidAssaults.lua IsWeeklyDone()` keek alléén
naar meta 95842 — telt nu ook de zone-weeklies 94385/94386 als done
(mage-case suggereerde dat de meta-flag kan achterblijven; weekly-reset-
flags, dus never-lie-veilig). Raakt routine-regel 6 én de Void-tab-status.
Luacheck 1.7.1-batch: **+ Modules/VoidAssaults.lua**.

Open verificatie (Robs andere 90, intro niet gedaan): hoort intro-regel
te tonen + 95843 false — bevestigt de keten definitief.

## 12 juni: rare-route per character (Robs paladin-vangst)

Paladin logde naast Terrinor in en kreeg "dit is je route-doel" door de
zone-route van een ándere char: `ui.rareAlert.routedIds` was account-breed
(ns.db.ui). Fix in Rares.lua: **`routedByChar[guid] = {anchor, ids}`** —
zelfde per-char-patroon als shardCapAlert/dungeonCourse; legacy-velden
worden opgeruimd. Raakt IsRareRouted (aankomst-tekst), IsRareHuntActive
("alleen tijdens hunt"-optie) en MarkRareRouted. Luacheck 1.7.1-batch:
Rares.lua zat er al in.

Boss-venster nice-to-have (Rob): buiten dungeons toont /mh bosswin alleen
de dungeon-van-de-week — dungeon-keuze (dropdown of < > door dungeons)
backlog voor 1.8.

## 12 juni: rares-overhaul — zelflerende npcIDs + hover-modelpreview

Robs ochtend-idee gebouwd (Rares.lua, alles in de 1.7.1-batch):

- **`LearnRareNpc`/`KnownRareNpc`**: elke naam- of npc-vignette-match slaat
  het npcID op in **`ns.db.rareNpcIds[questId]`** (account-breed, bewust:
  modellen zijn char-onafhankelijk). Statisch rare[6] wint; afstand-only-
  matches leren bewust NIET (cross-match-risico). Eén hunt door de zone =
  alle modellen bekend. Gebruikt in: UP-cache-matching (npc-first),
  MatchRareInZone, FireRareAlert-fallback, /mh raretest.
- **Hover-modelpreview**: rij-hover in het Rares-paneel toont links een
  klein goud-omrand paneel met de rare in vol ornaat (PortraitZoom 0,
  TOOLTIP-strata, async-nalaad-tik à la boss-venster). Alleen bij bekend/
  geleerd npcID — geen leeg kader, geen gok. Geen nieuwe locale-keys.

Rob-test: zone-route lopen (leert IDs vanzelf) → daarna hoveren in het
Rares-paneel: gespotte rares tonen hun model; nooit-geziene rares tonen
alleen de tooltip.

## 12 juni: world-boss "Warband: not defeated"-fix (Robs paladin)

Robs paladin toonde "Warband: not defeated" terwijl hij vrij zeker een
kill had deze week. Oorzaak in `WorldBoss.lua
SyncWarbandDoneFromQuestLog`: een **availability-early-return** — als de
WQ voor de húidige char nog beschikbaar was, werd de account-cache nooit
gelezen. Maar WQ-beschikbaarheid is per-char; op elke alt die de boss nog
kon doen werd de warband-status dus gemaskeerd. Guard verwijderd: eigen
flag eerst (registreert + cachet), dan de account-cache. NB: de cache
wordt pas gevuld als de killer-char ná de kill één keer met MH ingelogd
is/refresht — Rob checkt de flag (Lu'ashal = 92560) op de killer-char.
Tweede verificatie ritual-keten (Robs andere 90): flags exact het
warlock-patroon (alleen 94381 true) en Home-regel 5 toont correct de
intro-tekst — keten + weergave kloppen. Luacheck 1.7.1-batch: **+
Modules/WorldBoss.lua**.

## 12 juni: rare-toast-model clipte niet (stak onder de rand uit)

PlayerModels renderen buiten hun frame-rect én het 56px-vak paste niet in
de ~42px binnenruimte van de toast. Fix (MidnightToast.lua): model in een
**clip-container** binnen de backdrop-insets (TOPLEFT/BOTTOMLEFT 11px,
breedte 52) met `SetClipsChildren(true)`; model SetAllPoints op de
container. Zelfde behandeling evt. later voor het boss-venster-thumb als
daar overflow opduikt (nog niet gemeld). Luacheck-batch: MidnightToast.lua
zat er al in.

## 12 juni: CF-teksten geschoond + Settings-plan (Robs opdracht)

- **Alt+M en alle /mh-commando's uit de publieke teksten** (Robs besluit:
  slash = intern testgereedschap): CURSEFORGE_DESCRIPTION.md Quick start
  verwijst nu naar het minimap-icoon; Dungeons-secties en 1.7.1-notes
  noemen de Share-knop van het boss-venster i.p.v. /mh bossshare; boss-
  venster "opens automatically" i.p.v. /mh bosswin. Commando's zelf
  blijven gewoon werken.
- **`docs/SETTINGS_PAGE_PLAN.md`** (nieuw): "Mission Control"-design voor
  een Settings-tab in MH — eyecatcher met roterend 3D-model, void-
  parallax, categorie-cards met LIVE test/voorbeeld-knoppen (hergebruikt
  TestRareAlert/TestShardCapAlert/ShowDungeonBossWindow), settings-zoek,
  moderne toggles; 4 fasen, 5 open besluiten voor Rob. Maakt meteen de
  verstopte instellingen (livetips, bosswin-schaal, geluiden) zichtbaar.

## 12 juni: Broken Throne — Dissonant Reflections-tip (Robs death recap)

Rob stierf 2× op de Corrupted Amani Dragonhawk (voor-laatste Broken
Throne-boss): death recap toonde **Dissonant Realities -230k** door een
*Dissonant Reflection*. Wowhead (spell 1284085, 12.0.5): periodieke void-
spiegelbeelden casten Dissonant Realities = burst op alles binnen 100 yd;
**interrupt stuurt het spiegelbeeld direct weg** — kick is dus verplicht,
afstand helpt niet. Verwerkt in RITUAL_TIP_BROKENTHRONE_PHASES ×6 (plain
text, geen {SPELL:}-token — de Ritual Coach rendert FontStrings en de
ritual-share verstuurt platte tekst; token zou rauw lekken). Bron: Robs
recap + Wowhead — geverifieerd genoeg voor never-lie. Encoding-sweep
RitualTips.lua zit al in de batch.

## Voor Cursor — 12 juni middag: Ritual Boss Coach (post-1.7.1, na settings)

Robs gekozen volgende feature: het boss-venster hergebruiken in de Broken
Throne-ritual. Trigger = scenario-stap (scenarioID 3236, in-game bevestigd
12 jun) — werkt dus óók als scenario-bosses geen ENCOUNTER_START blijken
af te vuren; de ingebouwde spy beantwoordt die vraag vanzelf.

- **NIEUW `Modules/RitualBossCoach.lua`**: synthetische venster-entry
  `ritual_brokenthrone` met (vooralsnog alleen) de Corrupted Amani
  Dragonhawk (stage 2 "Corrupted Beast", stepID 16393). Auto-open bij die
  stage (1× per bezoek; X = met rust voor de rest van de run — zelfde
  regel als dungeons); venster sluit bij verlaten/afronden. **Zelflerend
  model** (rares-recept): npcID alléén geleerd van het boss1-frame
  tijdens de bijbehorende stage → `ns.db.ritualBossNpcIds`. **Data-spy**:
  stages/steps, ENCOUNTER_START/END en alle boss-unit-npcIDs automatisch
  naar `ns.db.ritualBossSpy` (max 80 regels; chat-echo alleen met debug
  aan) — geen /dump-huiswerk meer voor stage 3/Ger'lok.
  `/mh ritualboss` (toggle, ook buiten de ritual) + `/mh ritualspy` (dump).
- **`Modules/DungeonBossWindow.lua`**: custom-entry-route —
  `ns.ShowBossWindowForEntry(d, bossKey)` (geen roster-lookup),
  `ns.IsBossWindowSuppressedFor/IsBossWindowShowing/HideBossWindowForEntry`,
  creatureID-override via `b.creatureId` (vóór de CREATURES-map).
- **`Modules/DungeonLiveCoach.lua`**: BossDisplayName valt nu terug op
  `ns.CUSTOM_BOSS_ENTRIES` → Chat/Share-knoppen werken ongewijzigd voor de
  ritual-boss (tips lopen via dezelfde ns.DUNGEON_TIPS-sleutel).
- **`Locales/RitualTips.lua`**: RITUAL_BOSS_DRAGONHAWK_STEPS ×6 — 4 bullets
  uit Robs death recaps + Wowhead-tooltips, mét {SPELL:}-links (1284125
  Binding Nebula, 1291610 Volatile Plumage, 1284085 Dissonant Realities);
  mag hier wél: het venster rendert via EditBox. Shadowflame Breath blijft
  plain (geen geverifieerd ID).
- **`Core.lua`**: slash-handlers ritualboss/ritualspy (intern, niet in
  publieke teksten). **TOC**: Modules\RitualBossCoach.lua (na
  DungeonLiveCoach, vóór SettingsPage).
- **Web-research (12 jun, na Robs eerste live-trigger):** ritual-structuur
  is vast 3 stages (objectives → mini-boss → eindboss + chest; Icy Veins);
  Dragonhawk = stage-2-spawn maar "**can** spawn" (Wowhead) suggereert een
  mini-boss-POOL — spy bevestigt. **Model-seed npcID 255653** (Wowhead +
  Petopia onafhankelijk) als `seedCreatureId`; geleerd ID wint. ⚠️ Open:
  Wowhead-comment claimt dat Volatile Plumage-poelen GESOAKT moeten worden
  (erin = weinig schade, erbuiten = veel) — haaks op intuïtie, eerst door
  Rob in-game bevestigen vóór het in de tips gaat.
- **Robs spy-run #1 (12 jun avond, T1 compleet, score 122):** volledige
  stage-map binnen — 16391 "Void Reversal" / 16393 "Corrupted Beast" /
  16394 "Corruptor's End". **GEEN ENCOUNTER_START/END en geen boss-frames
  gelogd** → stage-triggering is de enige route; modellen via seeds (de
  boss1-leerroute kan hier niet vuren, seed-fallback was dus essentieel).
- **Ger'lok-pagina gebouwd:** boss-entry gerlok (stepID 16394, seed npcID
  257284 — Wowhead + Warcraft Wiki, eindboss bevestigd) +
  RITUAL_BOSS_GERLOK_STEPS ×6 (adds maken hem vrijwel immuun → direct
  wegbranden [Wowhead-comment + Robs run]; brandende grond ontwijken
  [Robs observatie, spellnaam "nog te bevestigen"]; naar lager platform
  trekken mag, niet te ver — reset-hotfix 1 mei). PHASES-regel ×6
  bijgewerkt: "eindboss-kill nog te bevestigen" eruit (Rob killde hem,
  wiki bevestigt eindboss).

- **Dungeon-picker in het boss-venster (Robs backlog-keuze, 12 jun
  avond):** de dungeonnaam onder de bosstitel is nu een UIPanelButton
  (Coach-les: kale Buttons/FontString-overlays zijn onbetrouwbaar
  klikbaar) die een UIDropDownMenu opent (DelveCoach-huispatroon) met
  alle roster-dungeons + custom entries (Broken Throne) — vinkje op de
  huidige; knopbreedte volgt de naam; tooltip-hint DGN_WIN_PICK_HINT ×6
  (Locales/DungeonGuide.lua). PickerEntries/InitDungeonPickerMenu staan
  VÓÓR EnsureWindow (scoping-les). Refresh-fallback `b.seedCreatureId`
  toegevoegd vóór de CREATURES-map, zodat de ritual-entry ook via de
  picker meteen een model heeft.

Luacheck: RitualBossCoach.lua (nieuw), DungeonBossWindow.lua,
DungeonLiveCoach.lua, Core.lua, Locales/RitualTips.lua,
Locales/DungeonGuide.lua, TOC.
**Rob-test:** `/mh ritualboss` buiten de ritual → venster met de
Dragonhawk-stappen (spell-links hoverbaar; model verschijnt pas nadat de
npcID één keer geleerd is in een echte run); in de Broken Throne hoort het
venster vanzelf te openen zodra stage 2 "Corrupted Beast" start, en weg te
gaan bij verlaten. Na de run: `/mh ritualspy` → stages + eventuele
ENCOUNTER-regels + boss-npcIDs (die data sluit de open vragen uit
TOMORROW.md).

Commitvoorstel: `feat(ritual): Ritual Boss Coach — boss-venster in de
Broken Throne via scenario-stappen, zelflerend model + data-spy`

## Voor Cursor — 12 juni middag: Settings-tab "Mission Control" (post-1.7.1)

Robs go op het settings-plan (besluiten: roulerende eyecatcher · Broker
blijft mini · slider náást shift+scroll · Geavanceerd als 5e categorie ·
gelokaliseerde tabnaam). Gebouwd (F1+F2+F3-licht):

- **NIEUW `Modules/SettingsPage.lua`** (~660 regels, parser ✓): push/
  Relayout-engine met categorieën als view-modes (Algemeen · Meldingen &
  popups · Dungeon Coach · Delen · Geavanceerd). Eyecatcher-strip met
  **langzaam roterend 3D-model** (clip-container; pool = alle
  DUNGEON_BOSS_CREATURES + geleerde rareNpcIds, loting per open-beurt),
  tagline + live versienummer, **pulserend goud accentlijntje**
  (AnimationGroup). Actieve categorie/taal/guide-modus kleurt goud.
- **Instellingen** (alles via bestaande setters): taal ×7 (incl. AUTO),
  open-bij-login, compact, guide-zichtbaarheid ×3; rare-alert aan/uit +
  geluid (nieuw zichtbaar) + alleen-tijdens-hunt + **TEST-knop**
  (TestRareAlert); shard-cap **TEST**; toast-positie **Voorbeeld**
  (sleepbare voorbeeld-toast) + **Reset**; live boss-tips-toggle (eindelijk
  zichtbaar); boss-venster **schaal-slider 0.7-1.8** (live) + Open-knop;
  Geavanceerd: debug, geleerde-rares-wissen, boss-venster-layout-reset.
- **Robs review-ronde 1 (verwerkt):** Delen-categorie geschrapt tot fase 5
  ’m echt vult (één regel = te leeg; de uitlegtekst staat nu onderaan
  Dungeon Coach); keybind-verwijzing verwijderd (eerder besluit: keybind is
  privé — bovendien renderden de →-pijlen als blokjes in de FontString).
  SET_ADV_KEYBIND-keys ×6 uit de locale verwijderd. Sidebar-volgorde TOOLS
  omgedraaid: Addons eerst, Instellingen onderaan vlak boven About
  (UI.lua: sectie-ids + TAB_DEFS).
- **NIEUW `Locales/SettingsPage.lua`** (parser ✓): ~25 page-keys ×6
  (TAB_SETTINGS, SET_*, INFO_DRAWER_BODY_SETTINGS); hergebruikt bestaande
  SETTINGS_*-keys voor rare/compact/guide/language.
- **Exposures:** DungeonLiveCoach `Set/IsDungeonLiveTipsEnabled`;
  DungeonBossWindow `ns.DUNGEON_BOSS_CREATURES` export +
  `Set/GetBossWindowScale` + `ResetBossWindowLayout` (slider-loop-guard
  via `_mhSettingValue`).
- **UI.lua:** TAB_DEFS + sidebar TOOLS (settings vóór addons) +
  build-dispatch + SelectTab-refresh + info-drawer-mapping.
- **TOC:** Locales\SettingsPage.lua + Modules\SettingsPage.lua.

Luacheck: SettingsPage (module+locale, beide parser ✓), UI.lua,
DungeonLiveCoach.lua, DungeonBossWindow.lua, TOC; encoding-sweep
Locales/SettingsPage.lua. **Rob-test:** sidebar → Instellingen: eyecatcher
roteert (en wisselt per bezoek), categorieën schakelen, TEST-knoppen
vuren toast+geluid, voorbeeld-toast slepen → positie blijft, slider
schaalt het boss-venster live (open hem ernaast), taal wisselen herlabelt
de hele pagina direct.

Commitvoorstel: `feat(settings): Mission Control-settingstab — eyecatcher,
live test-knoppen, alle verborgen toggles zichtbaar (plan F1-F3)`

## 🚀 GO-BLOK CURSOR — release 1.7.1 (12 juni)

**Cursor commits (12 juni push):** `97cff7c` boss-venster · `b2649e0` l10n
fase 6 · `7fd4243` WS-volgorde · `cdaa74f` rares-overhaul · `6d3baa0`
fixes (void/world-boss/toast/Broken Throne) · `e99dc85` release 1.7.1.
Combat-share-wachtrij en rares-hover-preview nog niet live gezien door Rob.

Robs besluit: boss-venster + volledige zes-talen-dekking = **1.7.1**
(1.8 gereserveerd voor Mythic/M+). Inhoud van deze release:

1. **DungeonBossWindow** (nieuw, 5 feedbackrondes verwerkt — details in de
   sectie hieronder): /mh bosswin, model-zijpaneel, auto-advance bij kill,
   Chat/Deel-knoppen, Shift+scroll-schaling, overal slepen, ESC.
2. **Fase 6 voltooid:** Locales/DungeonTips.lua nu **129 keys × 6 talen =
   774 regels** (deDE/frFR/esES/ptBR toegevoegd, mens-kwaliteit;
   blokken geverifieerd: 6 merges, totaal klopt). Daarmee is ALLES in 6
   talen.
3. **WS-bossvolgorde gefixt** (Emberdawn eerst) in DungeonRosterData.
4. TOC → **1.7.1**; CHANGELOG [1.7.1]; docs/CURSEFORGE_1.7.1.md klaar.

**Luacheck:** Modules/DungeonBossWindow.lua (NIEUW, in TOC),
Modules/DungeonLiveCoach.lua, Modules/DungeonRosterData.lua, Core.lua;
**encoding-sweep Locales/DungeonTips.lua (774 regels, 4 nieuwe blokken!) +
Locales/DungeonGuide.lua** (+3 keys ×6).

**Rob-test vóór upload:** /mh bosswin → alles uit de eerdere rondes + de
nieuwe vertalingen steekproeven (`/mh locale dede` → boss-venster +
Coach-tab tonen Duitse stappen met Duitse spell-links).

Commitvoorstellen: `feat(dungeon-coach): zwevend boss-venster (model-
paneel, auto-advance, chat/share, shift+scroll-schaling)` ·
`feat(l10n): boss-steps in alle 6 talen (fase 6, 129 keys ×4 nieuw)` ·
`fix(dungeons): WS-bossvolgorde (Emberdawn eerst)` ·
`chore(release): 1.7.1`

## Voor Cursor — 12 juni: zwevend Dungeon Boss Window (1.8-feature #1)

1.7.0 is live (57 downloads eerste ochtend). Robs gisteren geparkeerde
wens gebouwd: **NIEUW `Modules/DungeonBossWindow.lua`** (in TOC, vóór
DungeonLiveCoach) — compact zwevend venster met de boss-stappen van de
huidige dungeon:

- Titel = dungeonnaam (EJ), pager **< i/N >** langs de bosses, body =
  read-only EditBox met {SPELL:id}-links + hover-tooltips (zelfde patroon
  als Coach-tab/DelveCoach, incl. de nameting-op-volgend-frame tegen stale
  EditBox-metingen).
- **Versleepbaar** via de titelstrip; positie in `ui.bossWin` (offset
  t.o.v. UIParent-center). Hoogte dynamisch op de tekst.
- **Auto-open + meebladeren bij ENCOUNTER_START** (hook in
  DungeonLiveCoach, pcall, los van de chat-tips-setting). Sluiten met X =
  stil voor de rest van déze dungeon (sessie-suppress per dungeonKey);
  nieuwe dungeon opent weer; handmatig openen heft suppress op.
- **`/mh bosswin`** (Core.lua) togglet overal; buiten een dungeon valt hij
  terug op de dungeon-van-de-week (of Windrunner Spire) — Robs test-eis.
- Geen nieuwe locale-keys (titel/namen uit EJ; subkop hergebruikt
  DGN_VIEW_COACH; "soon"-fallback hergebruikt DGN_TIPS_SOON).

**Robs feedbackronde 1 verwerkt (module herschreven, nu 440 regels):**
1. **Resizable**: grip rechtsonder (ChatIM-SizeGrabber), breedte vrij
   340-720 (bewaard in `ui.bossWin.w`), hoogte snapt na het loslaten terug
   naar de tekstinhoud; body herwrapt live (LEFT+RIGHT-ankers).
2. **Pager gefixt**: de sleepstrip lag óver de </> -knoppen (zelfde klasse
   als de Coach-klik-bug) → strip eindigt nu op -176 van rechts en alle
   knoppen staan een frame-level hoger.
3. **3D-model van de boss** linksboven (rare-toast-recept: SetCreature +
   PortraitZoom 0.85 + Facing 0.45). Nieuwe `CREATURES`-tabel: 42 van 43
   bosses gemapt uit DBM SetCreatureID (4 ontbrekende vanmorgen alsnog
   gegrept: Emberdawn 231606, Kroluk 231631, Restless Heart 231636,
   Raktul 248605); alleen nalorakk:nalorakk heeft geen ID in DBM ("too
   many IDs to guess") → model blijft daar verborgen (never-lie).
   Header nu 78px hoog.

**Robs feedbackronde 2 verwerkt (v3, host 547 regels, einde geverifieerd):**
1. Kop toont nu de **bossnaam** (GameFontNormalLarge), sub = dungeonnaam —
   was 4× "Windrunner Spire"; gouden naamregel uit de body (dubbel).
2. **Model-laadprobleem** (beeld pas na heen-en-weer bladeren): async
   laden → `SetModelCreature` doet een nalaad-tik op +0.2s die dezelfde
   creature opnieuw zet (modelGen-guard tegen tussentijds bladeren).
3. **Vastgeklikt zijpaneel** met de boss in vol ornaat (PortraitZoom 0),
   links naast het venster (TOPRIGHT→TOPLEFT-anker, groeit mee in hoogte,
   schaalt en sleept mee). Eigen X → `ui.bossWin.modelPanel=false`
   (bewaard); het **mini-portret in de kop is nu een knop** die het paneel
   weer opent. Paneel verbergt zichzelf eerlijk als een boss geen
   creature-ID heeft.
4. **SHIFT+scroll = schalen** (Robs idee, voor 5120x1440 e.d.): 0.7-1.8 in
   stappen van 0.1, bewaard in `ui.bossWin.scale`; positie-opslag
   schaal-onafhankelijk (toast-recept: Save vóór SetScale, Apply erna);
   wheel-handler op frame én body-EditBox; gewone scroll onaangetast.
   Resize-grip (breedte) blijft ernaast bestaan.

**Ronde 3 (Robs vraag om ideeën + chat-knop + sleepbaar):**
1. **Overal slepen**: HookDrag op frame, titelstrip, body-EditBox én
   zijpaneel (drag start na de drempel; spell-link-kliks blijven werken).
2. **Chat-knop** (rechtsonder, naast de grip): print de gétoonde boss
   nogmaals lokaal — `ns.PrintDungeonBossTips` exposed in DungeonLiveCoach
   (NB: wrapper ná de local-definitie, scoping-valkuil gevangen).
3. **Share-knop** ernaast: deelt de gétoonde boss;
   `ns.ShareDungeonBossTips(dungeonKey, bossKey)` accepteert nu optionele
   args (zonder args = laatst gepullde boss; combat-wachtrij blijft).
4. **Auto-doorbladeren bij kill** (eigen idee): ENCOUNTER_END success in
   LiveCoach → `ns.BossWindowOnEncounterEnd` → venster springt naar de
   volgende boss (geen wrap; eindboss blijft staan).
5. **ESC sluit** (UISpecialFrames; bewust zónder dungeon-suppress — die
   blijft exclusief aan de X).
6. ApplyHeight +22px voor de knoppenrij. 2 nieuwe keys ×6:
   DGN_WIN_CHAT/DGN_WIN_SHARE (Share-knop 72px breed voor "Partager").

**Ronde 6 (Rob, fase-6-test): taalwissel ververste het open venster niet**
(pas bij bladeren) → `ns.RefreshLocaleUI`-wrap (MidnightToast-patroon):
herlabelt Chat/Deel-knoppen en hertekent het venster direct bij een
taalwissel. f._chatBtn/_shareBtn refs toegevoegd.

**Ronde 5 (Rob): paneel-verbergen dungeon-gebonden** — `panelHiddenFor`
(dungeonKey, sessievar, géén SavedVariable meer): nieuwe dungeon = model
altijd open; binnen de dungeon waar je 'm wegklikte blijft hij weg;
thumb-toggle heft op. `ui.bossWin.modelPanel` vervallen (oude waarde in
SavedVars is onschadelijk, wordt genegeerd).

**Ronde 4 (Rob):**
1. Zijpaneel kwam na X niet terug → thumb-toggle verhard: OnMouseUp +
   RegisterForClicks("AnyUp") + frame-level +10 + highlight-texture
   (zichtbaar dat het een knop is) + chathint bij het sluiten
   (DGN_WIN_PANEL_HINT, nieuwe key ×6).
2. **Boss-volgorde Windrunner Spire gecorrigeerd in DungeonRosterData**:
   Emberdawn is boss 1 (Robs follower-run + DBM-modnummers 2655<2656 +
   encounter-IDs 3056<3057) — Duo stond er ten onrechte voor. Overige 11
   dungeons gecheckt tegen de DBM-encounter-ID-reeksen: volgorde klopt.
   (Raakt Coach-tab, venster-pager én live-coach — allemaal roster-driven.)

Luacheck: **Modules/DungeonBossWindow.lua**, **Modules/DungeonLiveCoach.lua**,
**Modules/DungeonRosterData.lua** (host-staarten geverifieerd;
sandbox-mount stale), Core.lua, TOC-regel; encoding-sweep
Locales/DungeonGuide.lua (+3 keys ×6).

**Rob-test:** `/reload` → `/mh bosswin` (buiten dungeon: dungeon-van-de-
week, pager bladert door de bosses, spell-links hoveren, venster slepen →
positie blijft na reload). In een dungeon: pull → venster springt naar de
juiste boss; X sluiten → blijft dicht tot een nieuwe dungeon.

Commitvoorstel: `feat(dungeon-coach): zwevend boss-venster met pager en
spell-links (/mh bosswin, auto-open bij pull)`

## 🚀 GO-BLOK CURSOR — release 1.7.0, definitieve stand (11 juni, eind van de dag)

**Cursor commits (11 juni push):** `e8020cc` rares/toast · `ef4f416` ritual-hint ·
`c233ddc` shard/reset · `b49b00b` dungeon coach batch 2+3 · `ad1b25e` live coach ·
`a87ff93` l10n · `0d77ec2` release 1.7.0. Combat-share-wachtrij nog niet live
gezien door Rob.


Rob heeft live getest: Coach klikbaar + eerste-expand-layout ✅, spell-links
✅, live chat-stappen bij pull (ook in follower dungeons) ✅, shard-toast +
ready-check ✅, rare-toast (model/2×/sleep/onroute) ✅. Combat-share-wachtrij
is logisch eenvoudig maar nog niet live gezien — geen blokker.

**Volledige luacheck-lijst van vandaag (alle batches gecombineerd):**
Core.lua · Modules/Rares.lua · Modules/MidnightToast.lua ·
Modules/Broker.lua · Modules/RitualSites.lua · Modules/ShardCapAlert.lua ·
Modules/DungeonGuide.lua · Modules/DungeonTipsData.lua ·
Modules/DungeonLiveCoach.lua (NIEUW, in TOC) — plus encoding-sweep op:
Locales/DungeonTips.lua (VOLLEDIGE rewrite!), Locales/DungeonGuide.lua,
Locales/RitualTips.lua, Locales/StartHere.lua en de 6 hoofdlocales.
Docs-only mee: PTR_12.0.7_DATA.md, TOMORROW.md, CURSEFORGE_*.md,
CHANGELOG.md, MidnightHelper.toc (1.7.0).

**Daarna (Rob):** `tools\package.ps1` → dist/MidnightHelper-1.7.0.zip →
CF-upload met docs/CURSEFORGE_1.7.0.md (one-liner + changelog) en de
bijgewerkte docs/CURSEFORGE_DESCRIPTION.md (Dungeons-bullet + sectie er al
in verwerkt) + Robs nieuwe Dungeons-screenshot.

Details per batch in de secties hieronder. ⤵

## Voor Cursor — 🎯 RELEASE 1.7.0 (11 juni, Robs expliciete vraag) + slotbatch

Robs vragenronde ("popup bij de boss? delen met party? inklapbaar? S1
compleet? wanneer S2? → vandaag CF-update") → alles gebouwd:

**1. Dungeon Coach inklapbaar** (`Modules/DungeonGuide.lua`): push-engine
kreeg optioneel `hiddenFn`; Relayout verbergt ná de mode-check; per dungeon
een onzichtbare klik-overlay op de naam (toggle, sessie-gebonden, default
DICHT) + ASCII-indicator [+]/[-] (pijl-glyphs = blokjes).

**2. Season 1 compleet — batch 3** (4 legacy-dungeons, 15 bosses ×3 ×2):
bron DBM-Party-WoD/WotLK/Legion/Dragonflight, bewust de
**IsPostMidnight-tak** (12xxxxx-revamp-spells!) + ~70 Wowhead-tooltips via
agents. `Locales/DungeonTips.lua` +90 regels (SR/PS/ST/AA),
`Modules/DungeonTipsData.lua` +15 entries → **totaal 12 dungeons / 43
bosses**. Counterplay-goud: Garfrost achter erts schuilen, Tyrannus' Rime
Blast bevriest Bone Piles (stopt adds), L'ura's beam DOOR de noten,
Vexamus-orbs soaken, Araknath-stralen blokkeren (maar nooit de tank).

**3. Live coach** (NIEUW `Modules/DungeonLiveCoach.lua` + TOC-regel):
ENCOUNTER_START → boss-stappen in eigen chat (1× per boss per sessie,
wipes spammen niet; kleuren als Coach-view; SafeL). Encounter-ID-tabel
(43 stuks) uit de DBM-mods gelezen. **`/mh bossshare`** deelt de stappen
van de laatst gepullde boss als platte tekst naar INSTANCE_CHAT/PARTY
(chunks ≤240 tekens, markup gestript); **`/mh livetips`** togglet
(`ui.dungeonLiveTips`, default aan). Beide commands in Core.lua-dispatch.
6 nieuwe keys ×6 in Locales/DungeonGuide.lua (DGN_LIVE_*/DGN_SHARE_*).
Gelokaliseerde ontvangst (à la delve-share v2) blijft fase 5.

**4. Season 2:** NIET in 12.0.7 — komt met 12.1 ("zomer 2026", community
verwacht ~11 aug na Turbulent Timeways; geen officiële datum). Geen
addon-actie nodig.

**Release-test-vangst (Rob):** `/mh bossshare` gooide ADDON_ACTION_BLOCKED —
de oude global `SendChatMessage` loopt op 12.x via Blizzard_Deprecated-
ChatInfo en is protected vanuit addon-code. Fix: `C_ChatInfo.SendChatMessage`
met legacy-fallback, exact het bestaande patroon van DelvePartyShare:297 en
RitualShare:161 (had ik moeten afkijken). LiveCoach regel ~210.

**Klik-fix Coach (Robs screenshot: dungeons niet aanklikbaar — 3 iteraties,
definitief):** overlay-aanpak op de FontString geheel verlaten (0px-rect-
hoogte + onbetrouwbare hit-tests in de scroll-child; 3 varianten faalden
live). Definitief: **de dungeonnaam is zélf een Button** in de push-engine
(`push(btn, …, true, "coach")`). Iteratie 4: plain Button rendert geen
tekst → **MakeButton** (widget van de route-knoppen; dungeonnaam = rode
knop "[+] <naam> [Season 1]"). Iteratie 5, WARE OORZAAK (debug-print):
de toggle zelf was de klassieke Lua-instinker **`x and false or true` ≡
altijd true** — elke klik zette opnieuw "dicht"; de klik vuurde (in elk
geval in de MakeButton-versie) prima. Fix: expliciete if/else. Les voor
de hele codebase: nooit `and false or` gebruiken (sweep: nergens anders
aanwezig). Overlay-code en ui.coachToggles/Relayout-blok verwijderd;
debug-prints verwijderd. Iteratie 6 (Robs screens: eerste expand =
overlappende layout, dicht+open = perfect): EditBox-tekst wordt gezet
terwijl de box verborgen is → eerste GetNumLines-meting stale. Fix in
Relayout: per tipbox `_mhLastH` cachen; bij hoogteverandering één
nameting via C_Timer.After(0) (`ui._mhRelayoutPending`-guard, convergeert
in 2-3 frames) — zelfde klasse oplossing als DelveCoach' applyHeights. Tweede bug meegefixt: overlays bleven
onzichtbaar actief in week/cursus-view → Relayout toont ze alleen in
coach-mode (`ui.coachToggles`). Plus DGN_COACH_INTRO ×6 geactualiseerd
("klik op een dungeon-naam…"; oude tekst beloofde stappen "in komende
updates" terwijl alles er al staat). NB: het "lege venster" op Robs
screenshot was **BossHelper** (eigen weergave; "Fire = bad"-frasering staat
ook daar — MIT-kruisreferentie), niet MH.

**Combat-blok op addon-chat (Robs live-test + probes):** /mh bossshare
werd geblokkeerd vlak na de boss-kill terwijl Robs `/run
C_ChatInfo.SendChatMessage(...)` buiten combat gewoon aankwam (en
DungeonHelpers auto-share bij de pull faalde identiek) → **Midnight
blokkeert addon-spelerchat tijdens combat**, beide API's. Fix in
DungeonLiveCoach: `InCombatLockdown()` → share in `pendingShare`-wachtrij +
melding, automatisch versturen op PLAYER_REGEN_ENABLED (mooi voor wipes).
Nieuwe key DGN_SHARE_QUEUED ×6. ⚠ Geldt vermoedelijk óók voor
DelvePartyShare/RitualShare wanneer die in combat gebruikt worden —
backlog: zelfde regen-wachtrij daar (post-1.7.0; buiten combat werken ze).

**Spell-links (Robs DungeonHelper-vergelijk, "nu inbouwen, release
schuift"):** alle 43 bosses hebben nu klikbare ability-links:

- `Locales/DungeonTips.lua` **volledig herschreven** (host-Write, 412
  regels): ~218 ability-namen → **{SPELL:id}-tokens** (IDs uit dezelfde
  DBM-mods als de mechanics; namen zonder zeker ID — Shadow Bolt, Turbulent
  Arrow, Deathshroud, Soulrot, Sparkburn e.d. — bewust platte tekst).
  Bonus: spelnamen renderen client-gelokaliseerd → de links zijn in ALLE
  talen correct, ook waar de zinnen nog EN zijn.
- `Modules/DungeonGuide.lua`: coach-bossFs is nu een **read-only EditBox**
  (FontStrings doen geen hyperlinks) met AttachDelveTipHyperlinksToEditBox
  → hover/klik = echte spell-tooltip; Relayout meet `_mhTipBox`-widgets via
  GetNumLines×GetLineHeight; render door ns:ExpandDelveTipMarkup.
- `Modules/DungeonLiveCoach.lua`: chat-print expandeert rich (links zijn
  klikbaar in chatframes); `/mh bossshare` expandeert naar kale spelnamen
  (geen markup over de lijn). KeyToLines(key, rich) + ExpandPlain.
- Verificatie: 258 keys ✓, 218 tokens ✓, host-staart intact (412 regels);
  sandbox-parser zag een 90-regels-stale-mount (false positive, host-Greps
  bewijzen volledig bestand). **Luacheck-lijst: + Locales/DungeonTips.lua
  expliciet draaien** (volledige rewrite!), DungeonGuide.lua,
  DungeonLiveCoach.lua.
- Rob-test extra: Coach openklappen → [Spell]-namen lichtblauw, hover =
  tooltip; boss-pull → links in chat klikbaar; /mh bossshare → kale namen
  in party-chat. CHANGELOG + CF-notes vermelden de feature.

**Pre-release-review (Robs vraag "missen we nog wat?"):** twee vangsten —
(a) **never-lie-fix Dungeons 101 CH5 ×6**: beloofde "delen, ieder in z'n
eigen taal" (= fase 5!) → nu eerlijk: stappen verschijnen bij de pull in je
chat, delen via /mh bossshare (platte tekst, gelokaliseerd delen volgt);
(b) CF-notes vermelden expliciet dat boss-steps nu EN/NL zijn (fallback
EN). Backlog genoteerd: settings-checkbox voor livetips (command volstaat
voor 1.7.0).

**5. Release-prep:** TOC → **1.7.0**; CHANGELOG [1.7.0]-blok;
`docs/CURSEFORGE_1.7.0.md` (one-liner, changelog-paste, projectpagina-
Dungeons-blok, screenshot-suggesties). Zip: `tools\package.ps1` → upload
Rob.

**Luacheck slotbatch:** DungeonGuide.lua, DungeonTipsData.lua,
DungeonLiveCoach.lua (NIEUW — parser ✓), Core.lua, MidnightHelper.toc-check;
encoding-sweep Locales/DungeonTips.lua + Locales/DungeonGuide.lua.
Sandbox-parser: LiveCoach OK; Guide/TipsData wéér mount-truncatie-false-
positives (host-staarten geverifieerd intact).

**Rob-test vóór de upload (follower-run = perfecte kans):**
1. Coach: alles dicht, [+] klikken klapt open, route-knop verschijnt mee.
2. Pull een boss → stappen in chat (1×; wipe = geen herhaling).
3. `/mh bossshare` in de groep (Cisca ziet platte tekst).
4. `/mh livetips` uit/aan.
5. Daarna: Cursor commit + push → `tools\package.ps1` → CF-upload met
   docs/CURSEFORGE_1.7.0.md.

Commitvoorstellen: `feat(dungeon-coach): batch 3 — S1 compleet (12/12
dungeons, 43 bosses)` · `feat(dungeon-coach): inklapbare Coach +
DungeonLiveCoach (boss-stappen bij pull, /mh bossshare, /mh livetips)` ·
`chore(release): 1.7.0 — TOC, changelog, CF-notes`

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

1. **12.0.7 content** (🔴 release bevestigd: 16 juni): Void-zones Naigtal & Val + Escalations (VoidAssaults/WorldContent), world boss Nexus-Captain Leth'ir + Heroic World Tier (WorldBoss), Omnium Folio/Runes weekly (checklist + Codex), Sporefall raid (Codex/vault), Great Vault tooltip-rework verifiëren op PTR. Bij release: `120005` uit TOC.
2. **Backlog (laag, uit review):** `SetVaultReminderOption` popup-backfill voor upgraders; SMC-grid reflow; info-drawer inline; search-UX; compact-mode double-shrink. (Debounce, keybind-namespace, VaultAdvisor dode branch, VaultReminder isCurrent en ts==0-guards: gedaan in Fase 4c.)
3. **Reviewpunt:** ts vs aparte `vaultTs` bij login-restore (Fase 1-tradeoff, Cursor akkoord met huidige aanpak).
