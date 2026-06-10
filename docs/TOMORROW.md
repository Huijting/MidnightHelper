# Morgen — test & uitzoek (Midnight Helper)

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
