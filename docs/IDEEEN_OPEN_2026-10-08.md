# Wat hebben we nog bedacht? — inventaris 8 okt 2026

Gemaakt door een mh-research-helper, 8 okt 2026. Alleen gelezen, niets aan de code veranderd, niets gecommit.

## ⚠️ Eerst dit: deze lijst is NIET compleet

- **`docs/` is niet gelezen.** De vaste regel van deze helper is: lees niets onder `MidnightHelper/docs/`.
  Die regel ging vóór de opdracht. Dus NIET gelezen: `docs/NEXT_SESSION.md` (en de index onderaan),
  `docs/NEXT_SESSION_ARCHIVE.md`, `docs/SURVEY_RESULTS.md` (wensen van spelers) en de plan- en specbestanden.
  Ideeën die alleen daar staan, ontbreken hier. Een helper die `docs/` wél mag lezen moet dat deel nog doen.
- Twee zoekopdrachten lieten per ongeluk een paar regels uit `docs/` zien (`docs/parked/GroundSafety.lua:306`
  en drie regels van `docs/BROKER_ABSORPTION_PLAN.md`). Die zijn NIET gebruikt.
- **Wel gelezen:** de geheugenmap (MEMORY.md + de genoemde bestanden en nog ~25 andere), en de code in
  `Modules/`, `Locales/`, `Core.lua`, `Bindings.xml`, de `.toc`, `CURSEFORGE_DESCRIPTION.md`.
- **"Gebouwd" betekent hier: het staat in de werkmap op 8 okt.** Niet of het in een release zit en niet of
  Rob het getest heeft. Git mocht deze helper niet gebruiken.
- Bakken: **A** = nooit gebouwd · **B** = half, of wacht op Robs keuze · **C** = blijkt al af (of afgewezen).
- GEMETEN = met grep/lezen in het genoemde bestand gezien, mét een positieve controle waar het om een lege
  uitkomst ging. AFGELEID = uit een aantekening of redenering, niet in de bron gezien.

## Top 5 voor Rob

1. **Na je dood weer een echte les.** In een dungeon zegt MH nu alleen "kijk in Blizzards Death Recap".
   Er bestaat een nieuwere Blizzard-functie (`C_DeathRecap`) die MH ná het gevecht misschien mag lezen.
   Dan kan MH weer zelf zeggen wat je doodde. Eerst één keer meten of dat mag.
2. **Dispellen uitleggen.** Blizzard tekent zelf een rand om wat je kunt weghalen. MH kan uitleggen wat die
   rand betekent (gepland vanaf 14 okt). En het piepje bij een dispelbare debuff op jezelf is al gebouwd,
   maar nog nooit in een gevecht getest.
3. **Toetsen ook op balk-addons.** "Welke toets zit erop" in het Zo-speel-je-venster werkt alleen op
   Blizzards eigen balken. Wie EllesmereUI, Bartender of ElvUI gebruikt, ziet niets. Jij zei op 27 sep:
   later toevoegen.
4. **"Hoe begin ik Midnight op een alt?"** Het spel legt nergens uit waar je begint, of hoe je de intro
   overslaat. Een kort Codex-stukje past precies bij wat MH goed doet: uitleggen.
5. **Schatten stap voor stap afvinken.** Bij sommige schatten (zoals Gift of the Cycle) vinkt MH alleen de
   laatste stap af. Elke stap apart kan, maar dan moeten we per stap het quest-nummer in het spel meten.

⏰ Tijdgebonden, geen top 5: **WoW Forever** — de beta loopt tot 21 okt, de launch is 4 nov (bak B).

## Bak A — nooit gebouwd (wat een speler het meest merkt bovenaan)

- **A1 · Death-recap-les via `C_DeathRecap` / `C_DamageMeter`** — na het gevecht lezen wat je doodde, zonder combat log. · bron: `vanguard-aggrocaller-mit.md` + `spec-api-deprecated.md` (3 okt), `death-recap-popup-plan.md` ("12.1-rethink") · A · GEMETEN: grep `C_DeathRecap|C_DamageMeter` in alle `.lua` = 0; positieve controle: `C_DeathInfo.GetDeathRecapLinks` wél (`Retrospective.lua:719-722`). Dat de oude combat-log-les op 12.1 dicht zit: AFGELEID uit `cleu-taint-investigation.md` (29 aug) + `Retrospective.lua:201-208`. Of die API ná het gevecht leesbaar is: AFGELEID, nooit gemeten.
- **A2 · Live toetsen + toetsenblok op balk-addons** — EllesmereUI, Bartender, Dominos, ElvUI. · bron: `LiveKeys.lua:9-10` (Rob 27 sep: "later"), `keybind-fixed-block-idea.md` (4 okt: "Blizzard én EllesmereUI") · A · GEMETEN: `LiveKeys.lua:9` zegt "Standard Blizzard bars only"; grep `Ellesmere` in `KeyBlock.lua` = 0; positieve controle: `BarInventory.lua:461` kent die addon-namen wel.
- **A3 · Codex: Midnight beginnen op een alt** — Image of Lady Liadrin, quest 91281 vanaf level 80, overslaan met achievement 42045. · bron: `tww-intro-on-an-alt.md` (8 sep, "kandidaat voor de Codex") · A · GEMETEN: grep `91281|42045|Skip the Midnight` in `Locales/` = 0; positieve controle: "Adventure Mode" staat wel in `enUS.lua:179/195/210` (algemene zin) en "Liadrin" in andere zinnen. ⚠️ Die ID's komen van de wiki, niet uit de client (staat zo in de memory) — eerst meten.
- **A4 · Groeps-kickscore na de run** — wie kickte wat, gedeeld na afloop (Spec 14 fase 2). · bron: `midnight-helper-day2-plan.md` (14 jul) · A · GEMETEN: `InterruptScore.lua:9` "…Comms) is Phase 2"; grep kick/interrupt in `Comms.lua` = 0. Werkt alleen als iedereen MH heeft: AFGELEID.
- **A5 · Schat-tussenstappen apart afvinken** — altaren, rituelen, sleutels. · bron: `achievement-prereq-tracking-gap.md` (5 jul, lage prio) · A · GEMETEN: `AchievementsData.lua:457-464` (Gift of the Cycle, 6 stappen), `:69-73`, `:82-86`, `:88-92` zonder `quest`/`item`; positieve controle: `:484-489` en `:522-528` hebben wél quest-ID's.
- **A6 · Trading Post: transmog "heb je al", 3D-model, vastzetten** · bron: `midnight-helper-current-work.md` (10 jul) · A · GEMETEN: `TradingPost.lua:212-230` kijkt alleen mount + pet; voorbeeld = groot icoon (`:284-287`); grep `Frozen|SetFrozenPerksVendorItem` = 0.
- **A7 · Extra healer-cooldowns** — Rapture, Spirit Shell, Symbol of Hope, Flourish, Grove Guardians. · bron: `healer-initiative.md` (14 jul) · A · GEMETEN: grep in `HealerCooldowns.lua` = 0; positieve controle: Tranquility/Revival/Barrier = 3 treffers.
- **A8 · Ritual Sites-mounts in het mounts-tabblad** · bron: `collectible-mounts-tab.md` (9 jul) · A · GEMETEN: `MountProgress.lua:153` heeft er één (Void-Touched Hawkstrider, faction 2792). Dat het er vijf zijn: AFGELEID uit de memory.
- **A9 · Snelle chatregels** — vaste zinnen naar je groep, naast de quick bar. · bron: `handy-chat-lines-idea.md` (15 jul / 16 aug) · A · GEMETEN: `QuickBar.lua` heeft alleen knoppen; `SendChatMessage` staat alleen in `DungeonLiveCoach.lua`, `PtrProbe.lua`, `Comms.lua`. Of chat in 12.x hiervoor mag: AFGELEID/onbekend.
- **A10 · Keybind-opties Spec 07/08** — volgorde op hoe vaak je drukt, hint "deze toets is lastig", vaste plek voor een tweede kick. · bron: `spec-07-08-keybinds.md` (14 jul) · A · GEMETEN: grep `coreByFrequency|offInterruptCluster|KEY_REACH_RANK|learnCasts` = 0; positieve controle `alsoStop` = 33 treffers. Dat het toetsenblok dit grotendeels vervangt: AFGELEID.
- **A11 · Rustig overstappen** — een paar toetsen per week, niet alles ineens. · bron: `keybind-tomorrow-sba-and-mouse.md` (6 aug) · A · AFGELEID: grep "stage/habit/per week" in `ApplyLayout.lua` en `KeyBlock.lua` leeg, maar het kan onder een andere naam bestaan.
- **A12 · FarstriderLib als reisplanner** (strikt optioneel) · bron: `farstrider-travel-integration.md` (26 jul) · A · GEMETEN: alleen de meetknop `Addons/Farstrider.lua` (`/mh trail`). Het grootste gat (Hearthstone vergeten) is al zelf opgelost: `Delves.lua:1663-1690`.
- **A13 · WoW-sneltoetsen voor álle schermen** · bron: `mh-icon-set.md` (10 sep) · A · GEMETEN: `Bindings.xml` heeft 8× `MIDNIGHTHELPER_TAB_`; de keypad-commando's (C1) dekken hetzelfde via een slash.
- **A14 · Uitklappaneel voor 12-knopsmuizen** · bron: `keybind-tomorrow-sba-and-mouse.md` (6 aug) · A · GEMETEN: `KeybindSchema.lua:88` stopt bij 6 knoppen. Mogelijk achterhaald: Rob koos 4 okt "muis standaard leeg".
- **A15 · Buff-herinnering noemen op CurseForge** — reclame, geen code. · bron: `mh-market-position.md` (19 jul) · A · GEMETEN: `CURSEFORGE_DESCRIPTION.md` noemt buffs één keer (`:47`, de "kan ze niet zien"-zin), niet als functie; positieve controle: "Delve|Vault" = 5 treffers.
- **A16 · KeyUI bestuderen** — hoe zij toetsenbord + muis tekenen. Onderzoek, geen code. · bron: `keybind-tomorrow-sba-and-mouse.md` (6 aug) · A · AFGELEID.
- **A17 · FastMark via secure type `raidtarget`** — techniek, de speler merkt niets. · bron: `vanguard-aggrocaller-mit.md` (3 okt) · A · GEMETEN: `FastMark.lua:8` gebruikt nog `/tm N`.
- **A18 · Beroepenplan exporteren naar KnowledgeLoadout (KL1)** — mijn eigen oude suggestie, nooit door Rob gevraagd. · bron: `mh-market-position.md` (31 aug) · A · GEMETEN: grep `KnowledgeLoadout|KL1` = 0.

## Bak B — half, of wacht op Rob

- **B1 · Blizzards dispel-rand uitleggen** (dispel-optie D) — gepland na 14 okt. · bron: `mh-market-position.md` + `aura-facade-12-1.md` (7 okt) · B · AFGELEID: in `MidnightCodexData.lua` staat "dispel" alleen als zoekwoord (`:701`), geen artikel gevonden. Het plan zelf staat in `docs/` (niet gelezen).
- **B2 · Piepje bij een dispelbare debuff op jezelf** (optie C) — gebouwd, standaard uit, nooit in gevecht getest. · bron: `DispelSound.lua:4-20` (7 okt) · B · GEMETEN: de kop zegt zelf "NOT MEASURED … a test and not a feature yet". Wacht op Robs test (`/mh dispelsound test`).
- **B3 · Heal-lens groeit** — per baas "dispel dit hier" voor healers. Nu 4 bazen, allemaal Season 1, geen enkele S2. · bron: `healer-initiative.md` (15 jul) · B · GEMETEN: `HealerCooldowns.lua:375-393`. Wacht op `/mh dispellog`-data uit echte runs.
- **B4 · Laatste losse instellingen in het instellingenscherm** — kick-alarm, aantal muisknoppen, openables-geluid, toasts, delve-popups. · bron: `settings-inventory-2026-09-14.md` · B · GEMETEN: `SettingsDefs.lua` heeft 53 `Toggle(`-regels (o.a. lootTips, runScorecard, pullSummary, quickBar = positieve controle); grep `kicks|interruptMissAlert|mouse|openablesSound|toast` daarin = 0.
- **B5 · WoW Forever-helper (16001-TOC)** · bron: `wow-forever-research.md` (22 sep) · B · GEMETEN: `.toc` = `## Interface: 120007, 120100, 120105`, geen 16001. Wacht op beta-toegang (beta t/m 21 okt) of de launch op 4 nov.
- **B6 · Reclamefilm "Midnight Confusion" + flamingo-post** · bron: `mh-ad-research.md` (15 sep) · B · AFGELEID (buiten de repo): wacht volgens de memory op Robs oordeel over v1 en zijn eigen opname.
- **B7 · Introfilm "Questions at Dusk"** · bron: `mh-intro-video.md` (10-11 sep) · B · AFGELEID: wacht op Robs spelopnames en zijn muziekkeuze.
- **B8 · Iconen verspreiden via Stream Deck / Discord / CurseForge** · bron: `mh-icon-set.md` (10 sep, Rob: "geen idee nog") · B · AFGELEID.

## Bak C — al af (niet opnieuw voorstellen)

- C1 · Eigen slash per scherm voor je keypad (`/mhrares` enz.) — `KeypadCommands.lua` (7 okt), `/mh keypad`. GEMETEN. ⚠️ MEMORY.md noemt dit nog als open idee.
- C2 · Vast toetsenblok, mét neerzetten, terugdraaien, export en uitleg — `KeyBlock.lua:1009-1159`, `/mh block why` (`:2114`), export (`:2193`). GEMETEN. ⚠️ De kop van `KeyBlock.lua:10-11` zegt nog "only draws the picture" — verouderd commentaar.
- C3 · Echte toets per spreuk in Zo-speel-je — `LiveKeys.lua`, `PlayCardWindow.lua:333-363`. GEMETEN.
- C4 · Prot-kaart stap 5 = Hand of Reckoning, plus tab "Voor je groep" — `PlayCards.lua:35-37`, `PlayCardWindow.lua:906-910`. GEMETEN.
- C5 · Zo-speel-je voor iedereen (schakelaar weg sinds 4.1.0) — `PlayCards.lua:323`. GEMETEN.
- C6 · Je eigen keybinds exporteren/printen — `KeybindExport.lua` (`/mh binds`). GEMETEN.
- C7 · Toets 1 vrij voor de Single-Button Assistant — `Core.lua:2252-2281` (`/mh sba`). GEMETEN.
- C8 · Keybind-v7-reparaties: AoE-tweeling eerst, racial op Shift+E — `KeybindSchema.lua:189-195`, `:999-1019`. GEMETEN.
- C9 · Death Recap vanzelf openen (met vraag + schakelaar) — `Retrospective.lua:438-479`, `SettingsDefs.lua:133`. GEMETEN. ⚠️ MEMORY.md zegt nog "open: auto-openen ja/nee".
- C10 · Dispel-lijst voor niet-healers — `HealerCooldowns.lua:272-299`. GEMETEN.
- C11 · Zoeken op mount-, rare- en schatnaam — `NavSearch.lua:477-535`. GEMETEN.
- C12 · Trading Post per categorie — `TradingPost.lua:130-164`, `:396`. GEMETEN.
- C13 · Hearthstone + Silvermoon-portaal als route — `Delves.lua:1663-1690` (7 okt). GEMETEN.
- C14 · Quick bar (reload, groep verlaten op 3 manieren, bord, bossvenster, route, vluchtmeester) — `QuickBar.lua`, `enUS.lua:3300-3335`. GEMETEN.
- C15 · Bosstips voor jouw moeilijkheid + korte tips — `SettingsDefs.lua:314-325`; `DungeonTips.lua` 387× `_QUICK =`, `RaidTips.lua` 119×. GEMETEN.
- C16 · Alle instellingen in MH zelf — `SettingsDefs.lua` (53 toggles). GEMETEN. (Restje: B4.)
- C17 · M+-advies naast Blizzards M+-venster — `KeystoneSidePanel.lua`. GEMETEN.
- C18 · Curio-effectteksten uit de client — `CurioExplain.lua`. GEMETEN.
- C19 · Aggro-instellingen uitleggen (optie 1 van het dreigingsvoorstel) — `AggroSettings.lua`, `/mh aggro`. GEMETEN. Of er nog andere opties openstaan: niet te zien zonder `docs/`.
- C20 · Klasse per alt opgeslagen — `AltOverview.lua:560`. GEMETEN.
- C21 · De 4.0-iconen in de addon — `Media/Icons/` (28 schermen + 30 Silvermoon-pins, 64 px gezien). GEMETEN.
- C22 · Spells die niet meer bestaan van de blokken af — `KeybindRoles_Hunter.lua:117`, `KeybindRoles_Mage.lua:164` ("REMOVED 5 Oct 2026"). GEMETEN.
- C23 · Tank-/DPS-toolkit + pull-samenvatting — `TankToolkit.lua`, `DpsToolkit.lua`, `TankPullSummary.lua`, `SettingsDefs.lua:255-271`. GEMETEN.
- C24 · Curse Surges — treffers in `EventScheduler.lua`, `Rares.lua`, `AchievementsData.lua`. GEMETEN (alleen dat ze erin staan).
- C25 · ilvl + enchant per slot op het karakterscherm — opgelost met BetterCharacterPanel, niet zelf bouwen. AFGELEID (`character-sheet-slot-overlay-idea.md`, 11 sep).

### Afgewezen of dood — ook niet opnieuw voorstellen

- X1 · Live dispel-melding voor groepsleden — 12.1 maakt die auras geheim; hercheck 7 okt: "deur blijft dicht". AFGELEID (`aura-facade-12-1.md`).
- X2 · Void Assault naar de Special Assignment routeren — Rob koos de hub. AFGELEID (`home-dashboard-collapsible-and-routes.md`).
- X3 · Item level per M+-sleutelniveau — de API gaf onzin. AFGELEID (`midnight-helper-day2-plan.md`).
- X4 · CurseForge-vertaalplatform — dood, het loopt via GitHub. AFGELEID (`midnight-helper-day2-plan.md`).
- X5 · "Beste curio"-ranglijst — Everything Delves doet dat al. AFGELEID (`mh-market-position.md`).
- X6 · De hele Ula'tek-campagne stap voor stap routeren — Rob koos licht. AFGELEID (`midnight-helper-current-work.md`).
- X7 · Muisknoppen standaard vullen in het toetsenblok — Rob 4 okt: leeg laten. AFGELEID (`keybind-fixed-block-idea.md`).
- X8 · Wago-downloadteller — zit achter Patreon. AFGELEID (`midnight-helper-current-work.md`).
- X9 · Start Here als starttabblad, Raids onder Dungeons, enz. — afgewezen door het ontwerppanel. AFGELEID (`beginner-ux-overhaul.md`).

## Aantallen

- **A: 18** · **B: 8** · **C: 25 af + 9 afgewezen = 34**.

## Aanvulling uit `docs/` (bouwchat, 8 okt) — wat de helper niet mocht lezen

Bron: `docs/NEXT_SESSION.md` (grep op idee/wens/brainstorm/geparkeerd/Rob kiest) + `docs/SURVEY_RESULTS.md`.
Niet volledig: het archief en de plan-/specbestanden zijn niet doorgelopen.

- **D1 · Teller voor de wekelijkse Knowledge-drops** ("1 van 2 deze week" per beroep; Loa-Blessed Rune 259197) ·
  NEXT_SESSION.md:3023 (13 sep, Rob: "zet het in het logboek voor later") · **A** · GEMETEN: grep `259197` in
  `Modules/` = 0 (zelfde run vond wél andere ids, bv. `111843`). Plan daar: eerst meten met een `/mh`-diagnose.
- **D2 · Renown/reputatie in de Account snapshot** · NEXT_SESSION.md:1679 (27 sep, "Rob kiest") · **A** · GEMETEN:
  grep `renown|reput` in `AltOverview.lua` = 0; positieve controle: `HomeDashboard.lua:909` vindt "renown".
- **D3 · Tank/healer met één klik markeren** · NEXT_SESSION.md:1678 · **A** · GEMETEN: `FastMark.lua` heeft geen
  `UnitGroupRolesAssigned`/`TANK`/`HEALER`. (Lege uitkomst zonder positieve controle in hetzelfde bestand.)
- **D4 · Flask → eten → olie met één knop** · NEXT_SESSION.md:1678 · **A** · AFGELEID: niet in de code gezocht.
- **D5 · Kadertje bij een gekozen rare met portret + afstand** (gezien in Friend Finder; All Rights Reserved →
  alleen het idee, niet aan onze pijl hangen) · NEXT_SESSION.md:3232 (12 sep) · **A** · AFGELEID: `Rares.lua:2201`
  heeft een 3D-model, of dat hetzelfde is niet bekeken.
- **D6 · Uit Midnight Chores (MIT, alleen ideeën):** prey-telling via widget 1843, delve-telling vanaf tier 9,
  Soirée/Haranir/Stormarion/World Tour-weeklies, de Darkmoon Faire, "waarom groen"-diagnose per klus ·
  NEXT_SESSION.md:3725 (11 sep) · **A** · GEMETEN alleen Darkmoon: in `Modules/` alleen de beroepsboom "Darkmoon
  Curiosity" (`ProfessionAcademyData.lua:493`), geen Faire. Rest AFGELEID.
- **D7 · Weekplan korter / op maat voor wie solo speelt** · `SURVEY_RESULTS.md:24` (vragenlijst #11, 2 okt) · **B** ·
  AFGELEID: niet in de code nagekeken.
- **D8 · Open keuzes voor Rob uit de handoff:** CHANGELOG_1xx in de/fr/es/pt vol machinetekst (wissen → Engels, of
  herschrijven) (:210); delve-coach in de Labyrinth op de PTR nakijken (:241); Raidbots-bericht zelf versturen (:1460).
  · **B** · AFGELEID uit de handoff.
- **C26 · Snelknoppenbalk met knop naar het consumables-bord (in groep) en het bossvenster (in instance)** —
  NEXT_SESSION.md:2820 zei "nog niet gebouwd", maar GEMETEN: `QuickBar.lua:263-300`. Al af.

**Living Bomb (bijvangst hieronder) is ONSCHADELIJK — GEMETEN:** `RoleAcademy.lua:839-853` toont een toolkit-regel
alleen als `IsPlayerSpell(id)` true is. Wie Living Bomb niet kan casten, ziet hem dus niet. Dode data, geen fout.

## Bijvangst (geen ideeën, wel gezien)

- `DpsToolkit.lua:53` noemt Living Bomb (44457) als burst-cooldown voor Fire Mage, terwijl
  `KeybindRoles_Mage.lua:164` zegt dat Living Bomb sinds 5 okt niet castbaar is in 12.1. Niet onderzocht.
- MEMORY.md loopt achter op 4 regels: keypad-snelkoppelingen, vast toetsenblok, "toets per spreuk" en
  death-recap auto-openen zijn alle vier gebouwd (C1, C2, C3, C9).
