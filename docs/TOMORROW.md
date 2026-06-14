# Morgen — test & uitzoek (Midnight Helper)

## 🌅 MORGENOCHTEND (14 juni) — PTR 12.0.7 verder invullen

Hoofdfocus: `docs/PTR_12.0.7_DATA.md` afmaken. Met de nieuwe **`/mh eventspy`**
gaat dit sneller — op de PTR komen de uiMapIDs er direct uit. Open punten:

1. **Val-uiMapID** — sta in Val (of wacht op de rotatie) en `/mh eventspy`;
   `GetEventUiMapID` zou Val's map nu moeten teruggeven. (Naigtal = 2600 al ✅.)
2. **"Showdown on Val" quest-ID** (Naigtal = 96717 ✅).
3. **Rare NPC-IDs / coords in Val** (Naigtal grotendeels ✅).
4. **Folio Mote-ID** + Sporefall-vault-check.
5. **Zone-events identificeren**: zodra Void Assault / Abundance / Saltheril's
   Soiree / Runestone Defense actief worden, hun areaPoiID + naam noteren →
   dan krijgen ze in de Events-tab ook een naam + info-entry (EventInfoData).

## ✅ STAND 13 JUNI avond — Events-tab batch (Claude)

Gebouwd vandaag (fase A van het Broker-absorptieplan):

- `Modules/EventScheduler.lua` (NIEUW) — taint-veilige wereld-event-lezer +
  `/mh eventspy` (in Core.lua). Zone→uiMap- en naam-cache (persistent in
  SavedVars). Geverifieerde live-IDs: Voidstorm 2405, Harandar 2413,
  Eversong 2395 (in PTR-doc).
- `Modules/EventInfoData.lua` (NIEUW) — "wat is dit / wat levert het op" per
  event (areaPoiID): Stormarion Assault 8419, Legends of the Haranir 8423
  (web-geverifieerd: Icy Veins / Sportskeeda / Boostmatch).
- `Modules/EventsPanel.lua` (NIEUW) — eigen **Events-tab**: Nu bezig / Komt
  eraan, klikbare live-events (route via AddSmartTomTomWay), hover-uitleg,
  live mee-tikkend. A3-blok uit WorldContent gehaald.
- Versie → **1.8.0**, CHANGELOG bijgewerkt.

### 💾 Commit-voorstel (Cursor — doen om alles veilig te stellen)

Draai eerst luacheck/loadfile (mount gaf weer truncatie-false-positives;
host-bestanden zijn syntactisch geverifieerd met een Lua-parser). Commit-bericht:

> feat(events): Events-tab + taint-veilige EventScheduler + /mh eventspy + event-info (1.8.0)

Bestanden:

- **Nieuw:** `Modules/EventScheduler.lua`, `Modules/EventInfoData.lua`,
  `Modules/EventsPanel.lua`, `docs/BROKER_ABSORPTION_PLAN.md`.
- **Gewijzigd:** `Core.lua` (/mh eventspy), `UI.lua` (Events-tab registratie),
  `Modules/WorldContent.lua` (kleine regel-knophoogte in push/Relayout; A3-blok
  verplaatst), `MidnightHelper.toc` (3 modules + versie 1.8.0),
  `Locales/enUS.lua` + `Locales/nlNL.lua` (event/tab-strings), `CHANGELOG.md`,
  `docs/TOMORROW.md`, `docs/PTR_12.0.7_DATA.md`.

CF-release pas ná in-game test (jouw call) — de DE/FR/ES/PT-strings vallen nu
terug op enUS; vertalen kan later (I18N_ROADMAP).

### 🧪 Nog in-game te checken (na /reload)

- [ ] **Events-tab** verschijnt in de zijbalk; Nu bezig (goud) + Komt eraan.
- [ ] Klik op een lopend event → waypoint/route gezet.
- [ ] Hover op Stormarion Assault / Legends of the Haranir → uitleg + beloningen.
- [ ] Void & Rituals-tab: events-blok is wég (alleen Ritual + Void), niets stuk.
- [ ] Taalwissel NL/EN: tab-titel + secties vertalen mee.

## 📍 STAND 13 JUNI — Broker_MidnightEvents doorgepluisd (Claude)

Rob installeerde **Broker_MidnightEvents** (artherion77, v1.0.3, GPL-2.0,
~6.200 regels) zodat we ervan kunnen leren. Volledige analyse +
absorptie-roadmap: **`docs/BROKER_ABSORPTION_PLAN.md`**. Kernpunten:

- ⚖️ **GPL-2.0 ≠ onze MIT** → aanpak en feitelijke IDs/API's overnemen,
  géén code (copyleft). Zelfde posture als RitualAlert.
- ✅ **Audit taint-exposure: wij zijn schoon.** We lezen geen
  `C_UIWidgetManager` StatusBar-widgets of `C_EventScheduler`-timestamps
  (de twee secret-bronnen die Broker isoleert). Onze weekly-% gaat via
  `GetQuestProgressBarPercent` (pcall + `math.floor`, geen secret in 12.x)
  naar eigen FontStrings, niet naar de gedeelde GameTooltip. De
  MidnightHealerHelper-spam was een ánder addon, niet wij.
- 🔧 **Taint-patroon = verplichte ontwerpregel** zodra we wél live
  event-timers/voortgangsbalken bouwen (zie plan §Taint).
- 🎯 **Grootste echte gap**: een event-timer-systeem (`C_EventScheduler` +
  `C_AreaPoiInfo.GetEventsForMap`) — bestaat nog niet bij ons. `GetEventUiMapID`
  is meteen de route naar de open **Val-uiMapID** in PTR_12.0.7_DATA.md.

## 📍 STAND 11 JUNI ~10u (koffiepauze)

- Stap 5 (level-test) ✅ · stap 4 (Zygor-mine) ✅ · stap 3 (12.0.7-web) ✅
  → alles in PTR_12.0.7_DATA.md; **release = di 16 juni!**
- Extra: hotfix MidnightHealerHelper-secretvalue-spam + EllesmereUIQoL-
  advies (zie SESSION_NOTES) — Rob: `/reload` + combat-test op de lvl 80,
  en EllesmereUIDB-regel runnen.
- **Volgende: stap 1 — follower-run Windrunner Spire + Maisara** (Cisca is
  wakker ☕). Daarna: Cursor-commit 11-juni-batches; rest = PTR/live-lijst.

## 📋 Ritual Boss Coach — Daggerspine Point voorbereiden (volgende rotatie)

Web-geverifieerd: **Lady Selen'vjar = eindboss = npc 257498** (Ritual Chest =
object 602746); Daggerspine = zone 16939; stage 2 = void-**empowered Mindbreaker**
(npc nog ⬜). Stage-namen **"Ritual Roles" / "Beast From the Deep" /
"Summoner's Fall"** zijn nu **web-BEVESTIGD** (14 jun datamining, niet langer een
gok). Alle details in PTR_12.0.7_DATA.md §B. **Nodig zodra Daggerspine de actieve week is:** Rob
draait 'm één keer met de spy aan → stepIDs (+ evt. scenarioID, kan
afwijken van 3236!) via `/mh ritualspy`; daarna bouw ik de twee
boss-entries (npcIDs dan via Wowhead opzoeken; tips uit Robs run +
tooltips). Backlog-idee uit Gemini-overzicht (laagdrempelig, later):
**collectibles-checklist per site** (candle/meat/egg/kelp/bone pile —
Wowhead heeft alle waypoints) — past mooi bij de bestaande NOTES-keys.

⚠️ **Gemini-deepdive Broken Throne (12 jun) AFGEKEURD na verificatie** —
niet opnieuw narennen: "Abyssal Wildfire" en "Void-infused Channelers"
bestaan niet op Wowhead, "Tier 1-11" en "Nemesis Pactsworn" spreken de
geverifieerde T1-6 tegen, "+15% per vlam" onvindbaar, Eaglet-drop botst
met Icy Veins. Ger'loks wildfire-spellnaam blijft "nog te bevestigen".

## 💡 IDEE (Rob, 12 jun avond): emote-listener voor de Ritual Boss Coach

Inspiratie uit het addon **RitualAlert** (Xamael; gaat over een ánder
event — Twilight Ascension in Voidstorm mapID 241, open-world interrupt-
ritueel, géén overlap met onze Ritual Sites). NB: geen licentie in de map
→ aanpak overnemen, niet de code.

Bruikbare techniek: ze matchen op **boss-emotes** via CHAT_MSG_MONSTER_-
EMOTE / RAID_BOSS_EMOTE / MONSTER_YELL / MONSTER_SAY i.p.v. ENCOUNTER_-
START. Dat is precies wat onze Ritual Boss Coach mist: Robs spy-run
bevestigde dat Ger'lok/Dragonhawk GEEN ENCOUNTER_START afvuren, maar ze
**roepen wel** bij hun casts. → **emote-listener toevoegen aan
RitualBossCoach.lua** die op die teksten een gerichte flash/alert toont op
het exacte moment ("Binding Nebula! → kill de nebula", "interrupt
Dissonant Reflections"), bovenop het venster dat al bij stage-start opent.
Vereist: emote-strings opvangen tijdens Robs volgende run (de spy logt nu
al stages — uitbreiden met een emote-dump zodat we de exacte triggerzinnen
×locale weten vóór we matchen; never-lie: pas alerten op bevestigde tekst).
Spell-IDs nu bekend (14 jun datamining, voor cast-matching naast emotes):
**Binding Nebula = 1284125** (live)/1284106 (PTR) · **Dissonant Reflections =
1284081** (live)/1284085 (PTR). Zie PTR_12.0.7_DATA.md §B.
Tweede bruikbaar detail: hun vignette→waypoint-fallback ("kies niet-
eclipse, dan dichtstbij") als referentie voor evt. Void Rift-routing.

## 💡 Ritual Boss Coach — ✅ GEBOUWD (Claude, 12 jun middag)

Modules/RitualBossCoach.lua: auto-open boss-venster bij stage 2 (stepID
16393) in scenario 3236, zelflerend npcID (boss1-frame), data-spy naar
SavedVars (`/mh ritualspy`), `/mh ritualboss` voor tests. De spy verzamelt
de open vragen hieronder nu AUTOMATISCH tijdens Robs runs: stage 3-step,
ENCOUNTER_START ja/nee, boss-npcIDs. Origineel idee hieronder bewaard.

## 💡 NIEUW IDEE (Rob, 12 jun): Ritual Boss Coach — venster à la dungeons

Robs 3 doden op de Corrupted Amani Dragonhawk leverden de eerste twee
geverifieerde scenario-boss-gidsen op (Dissonant Reflections-kick +
Binding Nebula-kapotslaan, nu als bullets in BROKENTHRONE_PHASES ×6).
Volgende stap: **per scenario-boss eigen stappen + het bestaande
DungeonBossWindow hergebruiken** (auto-open bij engage, model, Chat/Deel).
✅ Eerste data binnen (Rob, 12 jun, in de run): **scenarioID 3236 "Broken
Throne", 3 stages; stage 2 = stepID 16393 "Corrupted Beast"** (= de
Dragonhawk-fase, widgetSetID 2102) → stage/step-gebaseerd triggeren kan
sowieso, óók zonder ENCOUNTER_START. Nog ophalen: stage 3-step (Ger'lok),
ENCOUNTER_START ja/nee bij boss-pull, npcIDs (target eerst, dan de
GUID-oneliner — "nil nil nil" = zonder target gedraaid).
**Oorspronkelijke vraag:** weten of scenario-bosses
ENCOUNTER_START afvuren —
`/run local f=CreateFrame("Frame") f:RegisterEvent("ENCOUNTER_START") f:SetScript("OnEvent",function(_,_,id,n) print("ENC:",id,n) end) print("encounter-spy aan")`
vóór de boss draaien; printen er ENC-regels → zelfde trigger-route als
dungeons; zo niet → scenario-API (C_ScenarioInfo-criteria) als trigger.
Boss-data groeit organisch via Robs runs (death recaps = bronmateriaal).

## 💡 NIEUW IDEE (Rob, 11 jun): Void Rifts (bijv. "Void Rift: Tranquil Repose")

Lokale rift-events in de assault-zones; wij dekken alleen de zone-weekly.
Kandidaat-features: (1) "rift actief"-hint + route-knop op Void & Rituals,
(2) live stage/percentage in ons paneel, (3) weekteller indien flag bestaat.
**Nodig (Rob, bij het volgende rift):**
`/dump C_ScenarioInfo.GetScenarioInfo()` ·
`/dump C_ScenarioInfo.GetScenarioStepInfo()` ·
`/run local m=C_Map.GetBestMapForUnit("player") for _,id in ipairs(C_AreaPoiInfo.GetAreaPOIForMap(m)) do local i=C_AreaPoiInfo.GetAreaPOIInfo(m,id) print(id, i and i.name) end`
(scenario-IDs, criteria-vorm, en of rifts als kaart-POI zichtbaar zijn —
POI = routeerbaar op afstand.)

## ⭐ PLAN 11 JUNI

1. **Follower-run Windrunner Spire + Maisara Caverns** — verificatie van de
   nieuwe Coach-boss-stappen (fase 3 batch 1). ✅ Voorwerk 11 jun: DBM +
   Wowhead-kruisverificatie gedaan — Muro'jin-ijsval BEVESTIGD
   ("runtotrap"), Vordaza-fantomen GECORRIGEERD (doden i.p.v. aanraken!).
   Nog live te checken: Duo's hook-breekt-cast, Muro'jin-berserk-claim,
   Vordaza's orbs/Soulrot. (Bonus: Windrunner Spire = dungeon van de
   week → Halduron-weekly meteen mee.)
2. **PTR 12.0.7-sessie** — open punten uit `PTR_12.0.7_DATA.md`: Val-data
   (uiMapID, weekly-ID, Pertinax-killquest, Voidstorm-portaal-mapID),
   rare-coords + kill-quest-IDs (§3b, baseline-truc), Folio Mote-ID,
   vervolg-weekly-keuze-IDs, Sporefall-vault-check. ✅ Web-check gedaan
   (11 jun): **release = 16 juni**, rotatie wekelijks ✅, portaal in
   Voidstorm/Howling Reach (2405), Folio-weekly account-breed, Decimus
   (HWT→Myth), valuta Voidlight Marl — alles in PTR_12.0.7_DATA.md.
   Blijft voor PTR/live: Val-uiMapID, Showdown-on-Val-ID, rare-data,
   Mote-ID, Sporefall-vault.
3. **Zygor-mine (Robs idee):** ZygorGuidesViewer heeft MID-databestanden
   (Data-Retail/Dungeons.lua, gidsen, entree-routing via LibRover) —
   kandidaat-bron voor o.a. dungeon-entrees en 12.0.7-data. ⚠️ Zygor is
   commercieel/proprietary (géén MIT zoals BossHelper): alleen feitelijke
   IDs/coords als kruisreferentie gebruiken en door Rob in-game laten
   bevestigen, nooit tekst overnemen.
4. Shard-cap-toast: ingekorte tekst checken bij de volgende cap (alt).
📌 **Geverifieerd feit (Rob, 11 jun, lvl-80-warlock): Delves zijn sub-90
gecapt op max Tier 3.** ✅ Verwerkt (11 jun): Start Here stap 4 ×6 +
DELVE_WEEKLY_UNDERLEVEL_HINT ×6.

5. **Level-eligibility-test (Robs 82-priest):** log in en doorloop de
   "After the reset"-routine + Dungeons-tab "Deze week". Noteer per regel:
   wat toont MH vs. wat bieden de NPC's écht aan op 82? (Liadrin-Spark /
   Halduron / Aethas naast de vault, trainer/service-weeklies, vault-rij,
   void/ritual-weeklies.) Met die lijst vullen we `minLevel` in
   GIVER_WEEKLIES + evt. level-gates elders, zodat een low-level char
   eerlijk "beschikbaar vanaf level X" ziet i.p.v. "ga ophalen" naar een
   NPC die niets aanbiedt — zelfde never-lie-klasse als de ritual-intro-fix.

## ⭐ EERSTE TAAK — ✅ GEDAAN (Claude, 10 juni): lokalisatie + blokjes-sweep

RitualTips (67 keys ×4), StartHere (33 keys ×4) en de twee
PROF_GENERATE-knoppen staan nu in deDE/frFR/esES/ptBR (mens-kwaliteit,
eigennamen EN, stadsnamen per bestandsconventie). Key-audit ×6 en
%s/%d-check host-geverifieerd. Bonus-sweep op blokjes: ZWSP's verwijderd
(DelveTips/GuideAdvisor/ptBR), ✓ in DAWNCREST_ACH_DONE_FMT ×6 →
ReadyCheck-texture, onbeschermde →-pijlen → "->", WorldContent-hint door
SanitizeUIFontText, 3 verminkte MT-strings hersteld. Details + commit-
voorstel: SESSION_NOTES.md "batch 10 juni". **Cursor: luacheck (mount gaf
weer truncatie-false-positives; host-bestanden geverifieerd).**

### Nieuwe in-game checks (na /reload):

- [ ] **Taal-check ×4**: wissel naar Deutsch/Français/Español/Português →
      Start Here-tab, Ritual Coach (Void & Rituals), share-knop en de
      Generate-route-knoppen (Professions → Treasures & Books) zijn vertaald;
      nergens blokjes; teksten lopen netjes (geen afgekapte knoppen).
- [ ] **Dawncrest-gids**: een rij met afgeronde tier-achievement toont nu een
      groen vinkje-icoon i.p.v. een blokje (check in elke taal die je toch al
      doorloopt).
- [ ] **Ritual-weekly-hint**: prefix is nu "-> " (was →; kon blokje zijn).
- [ ] **Reset-routine op Home (nieuw, 10 juni)**: Home-tab toont bovenaan
      "Na de reset — in deze volgorde" met genummerde stappen: vault-claim
      (alleen als er echt iets klaarstaat), ritual-weekly (incl. intro-state
      op de druid), void-weekly, trainer-weekly (alleen op chars met
      Enchanting — enige geverifieerde ID). Klik op een open stap → waypoint;
      route-knop onderaan → TomTom-keten vault → hub → station, pijl op de
      eerste stop, chatmelding "x stop(s)". Na claimen/oppakken springt de
      regel live om. Vault-pin = hetzelfde coördinaat als de bestaande
      VaultReminder-popup-waypoint (49.93/64.54).
- [ ] **Vault-popup (fix, 10 juni)**: klik op de waypoint-knop in de
      login-popup → popup sluit nu vanzelf (waypoint neemt het over).
- [ ] **Vault per-slot-detail in Account Snapshot (nieuw, 10 juni)**: hover
      over de vault-kolom van een char → per rij (World/Dungeons/Raid) nu
      slot-regels: groen "Slot N: ilvl X gear (level Y)" voor ontgrendelde
      slots, grijs "vergrendeld — p/t" voor de rest. Check op je main: kloppen
      de delve-tiers/ilvls met wat je deze week draaide? Sla daarna een keer
      op een alt over de main-rij — slot-data hoort bewaard te blijven.
      (Raid-rij toont bewust geen level — semantiek nog te verifiëren; ilvl
      verschijnt zodra het reward-item in de client-cache zit, evt. pas bij
      de tweede refresh.)
- [ ] **Void & Rituals: twee weergaven (nieuw, 10 juni)**: knoppen "Deze week"
      | "Ritual Coach" onder de subtitle. Deze week-view = currencies, hub-
      knop, ritual/void-status + hint, site-knoppen, Showdowns (12.0.7) en de
      compacte challenge-lijst (naam + Spoils%) — zonder scrollen te overzien?
      Coach-view = alle uitleg + volledige challenge-lijst + share-knop.
      Check: wisselen laat geen gaten/overlap achter, keuze blijft bewaard na
      /reload, taal wisselen vertaalt de knoppen, en op live (12.0.5) geen
      Showdowns-restjes in beide views.
- [ ] **Weekly-% op Void & Rituals (nieuw, 10 juni)**: met de void-zone-weekly
      in je log hoort achter "Weekly quest …: not completed" nu "(NN% gedaan)"
      te staan, live meelopend tijdens strikes (jouw 20%-screenshot). Zelfde
      voor de ritual-weekly als die een voortgangsbalk blijkt te hebben —
      heeft 'ie geen balk, dan verschijnt er bewust niets.
- [ ] **World-boss-routeknop op Home (nieuw, 10 juni)**: rode "Route naar
      Lu'ashal"-knop onder het World Boss-blok → TomTom-pijl + reisadvies.
- [ ] **SMC world-boss-knop (fix, 10 juni)**: de rode "World boss"-knop in
      Quest Hubs toont nu de bossnaam zodra MH 'm kent — bij een pure
      rotatie-gok met suffix "(open map ter bevestiging)". Alleen als er
      écht niets bekend is blijft "(open map)" staan. Check: zelfde naam
      als het Home-blok (Lu'ashal); na map openen verdwijnt de suffix.
- [x] ~~**Weekly quest givers — bevestigen + rest dumpen**~~ ✅ **COMPLEET
      (10 juni)**: Liadrin 93766/93909/93910/93911 (in-game bevestigd, regel
      werd blauw), Halduron 93761 "Windrunner Spire" (rep-dungeon-weekly —
      per week andere dungeon/ID, lijst groeit), Aethas 93600 "The Arena
      Calls" + 94836 "Late Night Training" (event-gebonden). Alle drie de
      givers tonen nu echte per-giver-statussen; de "niet getrackt"-regel is
      weg. **Blijft open:** level-eisen (minLevel nil — test ooit op een
      low-level alt), volgende weken Halduron/Aethas-IDs bijvullen, en
      trainer-weekly-IDs van de andere profs (Tailoring bij Belspa enz.). Route-knop is nu een echte rode knop —
      check dat 'ie netjes onder de stappen staat en de keten zet
      (vault → givers → hub → station).
- [ ] **Hint "intro"-state (nieuw, 10 juni)**: op de druid hoort de hint nu
      "intro-questlijn nog niet af — start Ranger Captain's Summons bij
      Lilatha" te tonen i.p.v. "haal bij de hub". Op de main: zelfde dump
      (94380/94381/96080/94382/94383/95843) — 94383 hoort daar true te zijn
      en de hint blijft pickup/inprogress. Keten op de druid afronden (Void
      Strike doe je in de actieve assault-zone) → hint verspringt naar
      pickup → weekly staat bij de hub.

---

Stand: 9 juni, avond. Begin met `/reload`, dan onderstaande. Details staan in
`SESSION_NOTES.md` (0b-blok + de losse secties).

## 1. Testen in-game (na /reload)

- [ ] **Start Here-tab** (gecorrigeerde content): subtitel "max level"; stap 1
      zonder "Bountiful Delves"; stap 4 met Tier-8/Restored-Coffer-Key-uitleg;
      stap 5 met de "Ritual Interest"-unlock. Bovenaan de **"Deze week: X/N"**-
      teller; stap 3 vault-nudge.
- [ ] **Void & Rituals — ritual-weekly-hint**: onder "Weekly quest … not
      completed" hoort nu **"Nog niet opgepakt — haal bij de Bazaar-hub"** te
      staan (jouw geval: renown unlocked, weekly niet in log).
- [ ] **Ritual Coach** (Void & Rituals): challenge-lijst toont nu **mechanic +
      Spoils% + hoe-ontgrendelen**, GEEN valse "unlocked/locked"-status meer;
      icoontjes renderen; gesorteerd op Spoils.
- [ ] **Ritual-share**: "Share challenge tips"-knop → in party de 9 regels
      (confirm-popup); solo met share-testmodus aan → self-whisper.
- [ ] **Generate Treasures** (Professions): pak een treasure, loop/vlieg een
      zonegrens over → **pijl blijft staan** en wijst naar de dichtstbijzijnde
      (re-assert is teruggedraaid; enkele crazy-arrow overleeft zones zelf).
- [ ] **Taal wisselen**: Start Here, Coach, hint en share vertalen mee.

## 2. Uitzoeken / bevestigen

- [ ] **Ritual-weekly afronden**: pak "Midnight: Ritual Sites" op (Bazaar-hub,
      Lilatha/Darkglen) + doe 'm → springen de World-tab én de Start Here-teller
      op groen? (Bevestigt de hele weekly-detectie end-to-end.)
- [ ] **Max level = 90?** Sanity-check — alle guides + de Lilatha-tooltip zeggen
      90; Start Here gebruikt nu "max level". Klopt dat met jouw realm?
- [ ] **Start Here-volgorde**: matcht de roadmap-volgorde/gating nu met je
      live-ervaring? Nog andere onnauwkeurigheden gespot?

## 3. Grotere open punten (geen haast)

- Ritual Coach **fase 4**: échte unlock-tracking via de unlock-quest-flags
  (NPC-turn-ins). Vereist een `/dump` van die quest-IDs zodra je ze unlockt —
  IsPlayerSpell bleek selectie, niet unlock.
- Dezelfde **weekly-hint op Start Here stap 5** (nu alleen op de World-tab).
- **Cross-locale share-test** met 2 spelers (Delve én Ritual) — solo-testmodus
  ✅ (10 jun, Rob); de 2-speler-test is het laatste restje, geen blokker.
- ~~**Woensdag-reset (10 juni)**: weekly-semantiek + vault-reset meemaken.~~
  ✅ Bevestigd 10 juni: trainer-weekly 93698 reset netjes (Rob: na reset
  opgepakt + gedaan → ✓ klopte); Liadrin-Spark-IDs en de intro-hint
  doorliepen de cyclus ook correct.
- **CF-release**: nog NIET — eerst de reset + paar dagen daily-driven (jouw call).
- Nieuwe brokken uit de beginner-brainstorm: **currency-overzicht** of
  **gear-roadmap**.

## 4. Cursor — commit + push (nu doen, om alles veilig te stellen)

Branch `main` staat **5 commits ahead** van origin + onderstaande uncommitted.
Draai eerst luacheck/loadfile (de Cowork-mount gaf truncatie-false-positives;
host-bestanden zijn compleet geverifieerd), commit dan en **push**.

Uncommitted, gegroepeerd:

1. **Ritual Coach fase 3 (share):** `Modules/RitualShare.lua`,
   `Modules/RitualShareSync.lua` (nieuw), `Modules/WorldContent.lua`
   (share-knop), `Locales/RitualTips.lua` (RITUAL_SHARE_*-keys), TOC.
2. **Start Here-tab:** `Modules/StartHere.lua`, `Locales/StartHere.lua` (nieuw),
   `UI.lua` (tab-registratie), TOC. Incl. weekly-teller + vault-nudge en de
   content-accuratesse-pass (max level / regular-vs-Bountiful Delves /
   Ritual-Interest-unlock).
3. **Ritual-weekly-hint + Coach-correctie:** `Modules/RitualSites.lua`
   (`GetRitualWeeklyHint`), `Modules/RitualCoach.lua` (unlock-status verwijderd —
   was selectie, niet unlock), `Modules/WorldContent.lua` (hint-regel + altijd
   how-to-unlock), `Locales/RitualTips.lua` (RITUAL_WEEKLY_HINT_*-keys).
4. **Generate Treasures-fix:** `Modules/Profession.lua` (alleen pin 1 krijgt de
   crazy-arrow; re-assert-experiment teruggedraaid).
5. **Docs:** `docs/RITUAL_COACH_PLAN.md`, `docs/SESSION_NOTES.md`, `docs/TOMORROW.md`.

Changelog-regels: "Nieuw: Start Here-tab (new-player roadmap)", "Nieuw: Ritual
Coach (scenario + challenge-referentie + share)", "Fix: Generate Treasures-pijl",
"Ritual-weekly-hint (unlock/oppakken)".
