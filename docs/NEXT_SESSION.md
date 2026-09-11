# Midnight Helper — waar we staan

## 🛠️ 11 sep — Liadrin: een turn-in-logboek NAAST de vlaggen (meetfase, Rob koos optie 1)

Het antwoord op "OPEN 9 sep, de weekly-vinkjes rusten op bewijs dat niets waard is". De aanpak komt
uit Midnight Chores (okarr, MIT; gelezen, niets gekopieerd): de voltooid-vlaggen van terugkerende
Midnight-weeklies resetten nooit, dus tel alleen een `QUEST_TURNED_IN` van déze week.
- **`ResetRoutine.lua`, blok onderaan:**
  - `MidnightHelperDB.turnInLog[guid] = { week, quests = {qid=ts}, givers = {key=ts}, lastLogin }`.
    Een nieuwe week begint leeg; een uur speling op `LastWeeklyResetAt`.
  - **Giver-toewijzing:** eerst `GiverKeyForQuest`, anders de NPC van het inlever-venster
    (`QUEST_COMPLETE` → `UnitGUID("questnpc")` → de geleerde `LearnStore().npc`).
  - **Bescherming bij het inloggen:** in de eerste 10 s na `PLAYER_LOGIN` wordt een `QUEST_TURNED_IN`
    genegeerd voor een quest die niet in het log stond. Dat wordt wel opgeschreven in
    `lastLogin.ids`, zodat de bewering van Midnight Chores in ONZE client gemeten wordt.
  - `WORLD_QUEST_COMPLETED_BY_SPELL` en `QUEST_COMPLETE` zijn nieuw voor MH en staan in een `pcall`
    (onbekend event = een laadfout, zie LEARNED_SPELL_IN_TAB).
- **`GiverState` gebruikt het nog NIET.** `/mh weeklies` (`WeeklyHubProbe.lua`) toont het naast de
  vlaggen: per giver *"handed in <tijd>"*, en per quest in Liadrins lijst *"+ handed in"*.
- **Beslismoment: woensdag 16 sep op de resetochtend** (TESTLIJST). Vlaggen "completed" en logboek
  leeg = de premisse klopt, en dan wordt de "done" van `GiverState` voor Liadrin (en de andere
  roterende givers) gebaseerd op het logboek.
- 🔎 **Eerste meetpunt, Rob 11 sep (hunter, /reload om Fri 16:55):** `lastLogin` 0 genegeerde
  turn-ins; 0 quests ingeleverd sinds de reset. Het logboek laadt en schrijft dus. Maar 0 re-fires
  bij één reload bewijst niets over de bewering van Midnight Chores; die kan gelden voor de eerste
  login van een week. En inleveringen van vóór 11 sep kent het logboek niet, dus woensdag 16 sep
  is de eerste eerlijke vergelijking.

## 📏 11 sep — `/mh curscan` GEMETEN (Twelveinchy, Lv80, 14:58; uit `curScan` in het SV-bestand)

| id | currency | maxQuantity | maxWeekly | seizoen? | verplaatsbaar |
|---|---|---|---|---|---|
| 3028 | Restored Coffer Key | 0 | 0 | nee | nee |
| 3310 | Coffer Key Shards | 0 | **600** | nee | nee |
| 3465 | Venomblight Manaflux | **8** | 0 | nee | nee |
| 2803 | Undercoin | 0 | 0 | nee | **ja, 100%** |
| 3356 | Untainted Mana-Crystals | **1000** | 0 | nee | nee |
| 3448 | Corrosive Coin | 0 | 0 | nee | **ja, 100%** |
| 3316 | Voidlight Marl | 0 | 0 | nee | **ja, 100%** |
| 3405 | Field Accolade | 0 | **0** | nee | nee |
| 3442-3446 | Mistcrest A/V/C/H/M | **500/500/500/400/400** | 0 | **nee** | nee |

- Bevestigd door de client: de cap van 8 voor Manaflux (MH had die als eigen constante) en de weekcap
  van 600 voor Shards.
- 🔴 **Crests: `useTotalEarnedForMaxQty = false`.** De crest-rij van het Currencies-blok testte alleen
  een seizoens-cap, en meldde daardoor nooit "vol". Gerepareerd: nu wordt ook een gewone cap getest.
  ⚠️ **Het Crests-tabblad (`DawncrestGuide.lua:96-110`) bouwt zijn cap-regel op `totalEarned`.** Of
  dat klopt, is nu twijfelachtig. Eerst meten op een max-level character (TESTLIJST); zonder die
  meting niet aanpassen. Ook de Field Accolade-weekcap van 0 kan aan level 80 liggen: de Codex zegt
  "weekly cap".
- **Nieuw in de tooltip:** `CURACC_TT_TRANSFER_FMT`, *"Can be moved between your characters with
  Blizzard's currency transfer (%d%% arrives)"*. Alleen als de client `isAccountTransferable` meldt.
  AFGELEID: `transferPercentage` is het deel dat aankomt; 100 bij Marl, en die kan aantoonbaar
  verplaatst worden.
- Van de 12 opgeslagen characters hebben er 3 al `cur`-data. De rest verschijnt als "not seen yet"
  tot ze een keer inloggen.
- ✅ **Tweede scan op een max-level character (Rob, 5 screenshots, 11 sep):**
  - **Mana-Crystals: weeklyMax 250** (thisWeek 45). Op Lv80 was dat 0: caps kunnen per level
    verschillen. Het blok leest de weekcap van het huidige character, alleen voor de tooltip.
  - **Crests:** `useTotalEarnedForMaxQty` is **true** bij Adventurer (147/147 verdiend), Veteran
    (qty 80, verdiend 20; kennelijk omgewisseld), Hero (50) en Myth (10), en **false** bij Champion
    (0 verdiend). De vlag gaat dus pas aan zodra er iets verdiend is. Het Crests-tabblad
    (`totalEarned`) klopt daarmee voor wie verdiend heeft; de zorg van hierboven is ingetrokken.
    De crest-rij van het blok test beide.
  - 🔴 **Field Accolade: maxWeeklyQuantity 0, ook op max-level.** `CODEX_CUR_ACCOLADES_BODY` (7
    talen) zegt *"Weekly earn cap"*. De client meldt die niet. Nakijken: bestaat er een cap die de
    API niet toont, of klopt onze tekst niet?
  - Verder hetzelfde als op Lv80: Shards weeklyMax 600 (591 deze week), Manaflux max 8, en Undercoin,
    Corrosive Coin en Voidlight Marl transferable.

## 🧹 11 sep — SavedVariables opgeschoond (door Rob, op advies van de pc-chat): 4,05 → 0,83 MB

De pc-chat zocht uit waarom WoW traag opstart. Rob draaide daarna een `/run`-commando dat 11
meetdumps op nil zette. Die chat heeft in de repo niets aangeraakt.
- GEMETEN (script `sv_sizes.py`, mtime 11:52; positieve controle: 155 top-level keys gevonden, onder
  meer `ejCapture`): de sleutels `tierProbe`, `chunkLog`, `atalProbe`, `tierScan`, `unlearnedDump`,
  `sniffLog`, `lockProbe`, `knowledgeProbeApi`, `worldBossProbe`, `crestProbe` en `itemScan` zijn
  **weg**. `ejCapture` staat er nog (RaidCoachData noemt die als bron om uit te breiden).
  `valeera.log = false`.
- GEMETEN in de code: geen enkele functie **leest** die elf. Alleen de diagnosecommando's schrijven
  ze. De bevindingen staan al in commentaar en in deze handoff: POI 8927 van `atalProbe`, de Dundun-
  sniff, en de tier-2-meting van `itemScan`. Alles is opnieuw te maken met `/mh atal`, `/mh sniff`,
  `/mh tier`, enzovoort. Er is niets verloren dat nog nodig is.
- De grootste die overblijven zijn echte functies: `editModeBackups` 350 KB en `taxiSeen` 52 KB. Daarna
  staan er nog ~20 kleine probe-dumps (samen ~150 KB).
- ✅ **`/mh cleanup` GEBOUWD (Rob: *"bouw /mh cleanup maar"*), NIET getest.**
  `Modules/SavedVarCleanup.lua`:
  - `/mh cleanup` toont de aanwezige dumps met een geschatte KB en waar ze vandaan komen. Pas
    `/mh cleanup yes` wist ze, en zet `valeera.log` uit.
  - Bij het inloggen komt één chatregel (na 15 s) als de dumps samen boven 1 MB komen.
  - **Een vaste lijst van 49 sleutels, nooit een patroon.** Elke sleutel is op 11 sep nagemeten
    (`sv_classify.py` + `sv_reads.py`): alleen geschreven door een diagnose en door geen functie
    gelezen, of door niets meer geschreven (4 wezen).
  - **Bewust NIET op de lijst:** `dispelCapture` (DispelHelper leest hem), `ritualBossSpy`,
    `eventSpy`, `soulLedger`, `captures`, `ejCapture`, `keybindExport` en `editModeBarsExport`, plus
    alle instellingen.
  - Staat in `MH_COMMANDS` (groep PROBE) als `CMDLIST_CLEANUP`, in 7 talen. De uitvoer is Engels,
    net als bij de andere diagnoses.
  - Niet gebouwd: een maximum voor logs. De melding bij 1 MB vangt hetzelfde, zonder gegevens weg
    te gooien die iemand misschien nog meet.
  - 📌 **Een nieuwe probe die naar `ns.db` schrijft, hoort in `DUMPS`.** Dat controleert nog niets;
    kandidaat voor een lintcheck.
  - 🔎 **Robs eerste run, 11 sep:**
    - De dry run toonde 38 dumps, "about 248 KB". De schatting valt ~1,5× te hoog uit
      (`profIdDump` 48 KB tegen 31 KB in het bestand); voor "hoe groot" is dat goed genoeg.
    - Na `yes` + `/reload` kwamen er **drie terug**. `dispelFieldLog` en `dispelLookupLog` zijn
      levende, gededupliceerde logs van de altijd draaiende DispelCapture. Die zijn nu **van de
      lijst af**, dus 47 sleutels.
    - `kicksProbeContext` kwam terug omdat Robs `/mh kicks probe` nog **aan** stond (maximaal 60
      regels). Nu meldt de dry run nog draaiende recorders ("Still recording: …"), en `yes` zet de
      kick-probe en de Valeera-log uit.
    - ✅ **Tweede ronde getest, Rob 11 sep:** `yes` zette de kick-probe uit, en na `/reload` stond er
      *"No measurement dumps …, and no recorder left on."* GEMETEN (sv_sizes, 12:40): 0,81 MB, 119
      top-level keys. `ejCapture`, `charCurrencies` en `ui` staan er nog; `valeera.log = false`.
  - 🔴 **NIEUWE BEVINDING: `editModeBackups` groeide van 350 naar 513 KB** tussen 11:52 en 12:40,
    alleen door reloads. Er zit wel een maximum op (`MAX_KEPT = 3`, EditModeBackup.lua:26), maar
    `MH_EditModeCapture("login")` bewaart **elke sessie** een kopie, ook als er niets veranderd is.
    GEMETEN in het bestand: alle drie de backups hebben het label `"login"`. Na drie reloads is de
    backup van vóór een wijziging dus weg, en daar is de functie juist voor (*"what did I change?"*).
    ✅ **Gebouwd 11 sep (Rob: *"ja, doe dat maar"*), NIET getest.** `SameLayout` (`active` +
    `DeepEqual` op `data`):
    - `"login"` en `"manual"` slaan niets op als de lay-out gelijk is aan de nieuwste backup; er komt
      dan `"unchanged"` terug, en `/mh editmode` zegt dat ook.
    - `FoldLoginDuplicates` haalt oudere "login"-kopieën weg die gelijk zijn aan de backup erna.
    - `"before-bars-import"` wordt nooit overgeslagen of samengevoegd, want de undo zoekt hem op dat
      label (`:470`).
    - Nieuwe backups krijgen `at = time()`.
    - 🔴 **Robs eerste test loog, en mijn testpunt liet het toe.** `/mh editmode` zei "unchanged",
      maar het bestand (13:01) had nog steeds 3 backups. `editmode_parse.py` las ze als tabellen en
      vond **#1 en #2 identiek qua waarde**; alleen de tekst verschilt: `offsetX = -0` tegen `0`,
      8×. Positieve controle: #1 tegen #3 geeft 17 verschillen ("Twelveinchy" / "Bell 1080").
      AFGELEID: live floats houden restjes die de SV-schrijver afrondt. Een backup die uit het bestand
      is ingelezen, is daardoor nooit exact gelijk aan de live lay-out; "unchanged" kwam van een
      kopie uit dezelfde sessie. **Gerepareerd:** getallen gelden als gelijk binnen 0,01.
      ✅ **GEMETEN na Robs reloads + uitloggen (13:22):** 2 backups. #1 "login" van 13:01, daarna
      geen nieuwe kopie. #2 is de oude set met "Bell 1080", "MH V1.0" en "MH Hunter BM", drie lay-outs
      die Rob niet meer heeft. Die zijn niet terug te zetten; de module is read-only, en terugzetten is
      een aparte beslissing (kop van EditModeBackup.lua). SV: 4,05 MB (vanochtend) → 0,64 MB.

## 🔎 11 sep — Midnight Chores (okarr, v1.0.7, **MIT**) doorgelicht: aanwijzingen, NIETS overgenomen

Rob installeerde het en vroeg: *"check wat het is en hoe we daar van kunnen leren"*. Het is een
chore-tracker die aan Blizzards quest tracker vastzit: tabs Weekly en Events, per character, met een
surge-aftelling, delve-knoppen, BiS-lijsten en een optionele auto-quest. De licentie is MIT, dus code
mag met naamsvermelding. **Alles hieronder is een KANDIDAAT uit hun code, niet in onze client
gemeten.** Alleen de twee regels over MH zelf zijn GEMETEN.
- 🔴 **Liadrin-vlaggen:** hun uitgangspunt is dat de voltooid-vlag van terugkerende Midnight-weeklies
  **nooit** reset. Daarom tellen zij alleen een `QUEST_TURNED_IN` van déze week (log, gewist bij de
  reset, met 10 s bescherming na het inloggen). Dat verklaart onze 13/13-meting van 9 sep.
  GEMETEN: `ResetRoutine.lua:794-797` geeft "done" zodra één vlag staat. De oorzaak van "OPEN 9 sep"
  is daarmee waarschijnlijk gevonden. De reparatie is een turn-in-log; meten op één alt, op een
  resetochtend.
- ✅ **Trovehunter's Bounty — GEMETEN en GEREPAREERD, 11 sep.** Rob, `/mh item 274374 252415`:
  *"274374 — Trovehunter's Bounty, Midnight Season 2"* en *"252415 — … Midnight Season 1"*. MH las
  overal 252415. Nu leest alles `Config.DELVE_ITEM_TROVEHUNTER_BOUNTY = 274374`; de reservewaarden
  in DelveItemsPopup, -Brokers, Delves en MidnightToast volgen. De buff: `…_SPELLS = { 1293799
  (S2-KANDIDAAT, niet gemeten), 1254631 (S1) }`. DelveWeeklyTrackers vraagt beide plus de
  `GetItemSpell` van het item. De popup vond hem al op naam. Nog open: `/mh spell 1293799` en een
  test in een delve (TESTLIJST).
- **Curse Surge:** zij gebruiken `C_AreaPoiInfo.GetEventsForMap(2512)`, niet `GetAreaPOIForMap`, met
  `IsAreaPOITimed` + `GetAreaPOISecondsLeft`. Plus een voorspelling: 5 vaste plekken, elk 2700 s, in
  een vaste volgorde, per regio een startanker (EU 1786617900). Weekly 96995. Onze `/mh atal` gebruikte
  de andere API; daarmee kan optie C ("er loopt nu een surge") opnieuw open.
- **Spark-weekly:** currency **3509** "Tidal Spark Dust" (`totalEarned` tegen `maxQuantity`). Of die
  per character of per account is, is niet zeker.
- **Tegenspraak met MH om na te meten:** Halduron (MH 93761 gemeten, zij 93751-93758); 93423-93426
  (zij PvP-quests "Sparks of War", MH delve-referentie); Aethas 94836 (MH) tegen 94835; de naam van
  een surge-plek ("Siege at Coiler's Wake" tegen "Siege at the Whispering Marsh"; de coördinaten
  kloppen).
- **Wat zij hebben en MH niet (ideeën):** prey-telling via widget 1843, een delve-telling vanaf
  tier 9, Soirée/Haranir/Stormarion/World Tour-weeklies, de Darkmoon Faire, per chore een diagnose
  *"waarom groen"* (`/mc why`).
- ⚠️ **Hun riskante plekken, niet overnemen:** ze schrijven in Blizzards Group Finder (hun eigen
  commentaar noemt dat een taint-bron), verbergen de tracker via een secure handler, en hebben een
  item-ID-sweep die de client laat crashen.

## 🛠️ 11 sep — Spec 38 optie B: ALLEEN punt 4 en 6 gebouwd (Robs keuze), NIET getest

Rob: *"doe punt 4 en 6 maar"*. De punten 1 (Vault-blokjes), 2 (klasse-icoon), 3 (week-balkje) en 5
(kolommen vallen weg bij een smal venster) zijn bewust **niet** gebouwd.
- **Punt 4, `EntryIsLeveling` in `AltOverview.lua`:** characters onder de max-level van de client
  (`ns.GetDelveCapLevel`, dezelfde poort als Bountiful) staan onder één regel. Dat gebeurt pas vanaf
  twee, en nooit bij het huidige character. De keuze wordt bewaard in
  `db.ui.accountSnapshot.levelersExpanded`.
  - 🔴 **Het criterium van de spec werkt niet op Robs data.** De spec zegt "alle drie de
    Vault-rijen onbeschikbaar", maar zijn screenshot van 10 sep toont een level 15 op "0/9"; de
    client geeft elke level een Vault. Daarom is het "onder de max-level" geworden. Daardoor vallen
    ook Lv80/82 in de groep. Dat staat als vraag in de TESTLIJST.
- **Punt 6:**
  - `NextSteps()`: de rij-tooltip opent met *"Still open this week"*, met hooguit drie punten uit het
    snapshot. Voor een stale rij niet, want die getallen zijn van vóór de reset.
  - Een legenda onder de tabel: `ALT_TABLE_LEGEND`.
  - De vijf kolomkoppen zijn herschreven als wat / Why / Resets.
  - Het muntje en het kristal bouwen hun uitleg uit `CURACC_USE_*` (Spec 39), zodat de twee tabbladen
    het niet oneens kunnen zijn. De oude gedeelde hint `ALT_COL_UNDER_MANA_HINT` stuurde ook de
    Undercoins naar Zah'ran; die is weg.
- Zeven talen, via één script (`alt_option_b_texts.py` in de scratchpad; alleen regels die precies één
  keer voorkwamen). `check_drift --mark ALT_COL_KEYS_HINT`. Lint 0 hard, check_drift 0.

## 🛠️ 11 sep — Spec 39 GEBOUWD: currencies per character, en wat je ermee moet doen (NIET getest)

Rob keurde het voorstel goed: *"ga je gang met jouw voorstellen"*. Alles staat in
`docs/SPEC_39_CURRENCIES.md`, ook de bronnen per regel en wat nog open is. De testpunten staan in
`docs/TESTLIJST.md`, en de eerste is `/mh curscan`.
- `Modules/CurrencyAccount.lua` (nieuw): het blok "Your characters" boven de gids, met negen rijen,
  adviesregels op basis van de caps van de client, per character in de tooltip, en `/mh curscan`.
- `AltOverview.lua`: het snapshot krijgt `cur` (er komt alleen iets bij). `CurrencyGuide.lua`: het blok
  staat boven de scroll. `Core.lua` / `CommandList.lua`: `curscan` is gerouteerd en staat als unlisted.
- 🔴 **Echte fout gerepareerd:** de gids verkocht Marens Season 1-caches (*"Champion 75 / Hero
  500"*). In Season 2 zijn dat Veteran-caches (500/750). Gerepareerd in alle 7 talen;
  `check_drift --mark CURRENCY_GUIDE_BODY`.
- Nieuwe keys `CURACC_*` in 7 talen (eigen vertalingen). Lint 0 hard, check_drift 0.

**Wat er vóór het bouwen gemeten was** (Robs vraag, dezelfde ochtend):
- GEMETEN, wat er al is:
  - **`Modules/CurrencyGuide.lua`** (tabblad Currencies) legt uit waar je iets verdient en waar je het
    uitgeeft, met het live saldo van **alleen het huidige character**. De tekst (`CURRENCY_GUIDE_BODY`)
    is van **15 jun** en noemt Voidlight Marl, Field Accolade, de crests (`{CRESTS}`, volgt het seizoen)
    en PvP.
  - 🔴 **Geen enkele Season 2-currency staat in die gids.** Undercoins 2803, Untainted Mana
    Crystals 3356, Coffer Key Shards 3310, Restored Coffer Key 3028, Venomblight Manaflux 3465 en
    Corrosive Coin 3448 ontbreken allemaal. De gids die zegt *"a quick map of every Midnight
    currency"* is dus sinds 18 aug onvolledig.
  - **Het accountoverzicht** (`db.charCurrencies`) bewaart per character alleen keys, shards (+ week),
    Undercoins, Mana Crystals en Manaflux.
  - **Het blok *This week*** heeft al twee regels over het hele account die zeggen wat je moet doen:
    *"Restored Coffer Keys on account: 22 (6 characters)"* en *"Catalyst charges waiting: 18"*.
- AFGELEID, niet gemeten: `C_CurrencyInfo.GetCurrencyInfo` geeft ook `maxQuantity`,
  `maxWeeklyQuantity` en `quantityEarnedThisWeek`. Daarmee kan een regel als "bijna op de cap, geef
  uit" op data rusten in plaats van op een getal dat wij zelf opschrijven. In 12.1 nog niet per
  currency gemeten.

## ⏸️ GEPARKEERD (11 sep, WoW dicht zolang ComfyUI de videokaart gebruikt) — "Sort: Shards" sorteert niet goed

Rob, 10 sep laat: *"Bij de account snapshot is de sorteerfunctie die klopt niet. Er staat nu
'sort shards' voor het sorteren van de shards. Dat gaat niet goed, maar daar moeten we morgen even
naar kijken."* **Nog niets aan veranderd.** Wát er precies misgaat heeft hij niet gezegd: vraag
eerst wat hij zag en wat hij verwachtte, liefst met een screenshot.
- GEMETEN in de code, alleen gelezen (`CompareSnapshotEntries`, `Modules/AltOverview.lua:715`):
  - `"shards"` sorteert op de **wallet** (`e.shards`), niet op de weekkolom. Standaard is dat
    aflopend, want `sortDesc` is `nil` → aflopend voor alles behalve naam.
  - Het **huidige character staat altijd bovenaan**, welke sortering er ook gekozen is
    (`ac`/`bc` in de comparator).
  - De nieuwe **Week-kolom heeft geen sorteersleutel.**
- AFGELEID, niet bevestigd: sinds optie A staan wallet en week in aparte kolommen. Verwacht Rob
  sortering op Week (x/600), of snapt hij niet waarom zijn eigen character bovenaan blijft? Dan is
  "klopt niet" een van die twee. Het kan ook iets anders zijn; niet raden, vragen.
- Optie B: punt 4 en 6 zijn op 11 sep gebouwd (zie boven). Rob koos de punten 1, 2, 3 en 5 niet. De
  oude keys zijn opgeruimd.

## ✅ 10 sep avond — Spec 38 (Account snapshot): §3 + optie A af, optie B wacht op Rob

Van de research-chat via Rob (`docs/SPEC_38_ACCOUNT_TABLE.md`). **§3 (c18101a), optie A
(c83425c + 6744069) en de voetregel van *This week* (835015f) zijn door Rob in-game goedgekeurd.**

**Optie A (§2c), `Modules/AltOverview.lua`:**
- Kolommen van rechts naar links: kristal · Undercoins · Week · Shards · Keys, dan Vault.
  `AnchorThreeNumericCells` is `AnchorNumericCells` geworden, gestuurd door `NUM_COL_ORDER`/`NumColW`.
- De twee currency-koppen tonen Blizzards eigen icoon, en de tooltiptitel is de naam uit
  `C_CurrencyInfo.GetCurrencyInfo` (`CurrencyIconAndName`). Daarmee staat de verkeerde vertaling van
  §1e ("Unter/Sous/Bajo/Menos / Mana") niet meer op het scherm. Sorteren op Undercoins zit op het muntje.
- Shards is gesplitst in wallet en Week ("x/600", vinkje bij de cap, "—" als het stale is). Vault
  toont het opgetelde "unlocked/total"; CLAIM!, LIKELY en de reset-pulse zijn ongewijzigd.
- Beroepen staan niet meer in de naamcel (de tooltip heeft ze). De × staat alleen bij hover. Relog is
  een gedimde rij met een klokje, en `ALT_ROW_STALE_TOOLTIP` staat bovenaan de tooltip; de oude
  `ALT_VAULT_TOOLTIP_STALE_RESET` onderaan is weg.
- Nieuwe keys in 7 talen: `ALT_COL_WEEK`, `ALT_COL_WEEK_HINT`, `ALT_COL_SHARDS_WALLET_HINT` en
  `ALT_ROW_STALE_TOOLTIP`. `ALT_COL_VAULT_HINT_FMT` is herschreven voor de optelling. check_drift: 0.
- **Rob, eerste blik (c83425c): de indeling werkt, de relog-tooltip klopt.** Zijn screenshot liet
  zien dat een lange naam de getallen afkapte ("Purlymixanox-Bloodhoof Lv90 · 269 i…"). **Tweede
  ronde:** level en ilvl staan nu in een eigen kolom (`lvlFs`/`lvlH`, `COL_W_LVL` 60,
  `LvlCellRightOffset`), zoals in de mock-up van de spec. Op de kop sorteer je op level. De tooltip
  gaf het relog-advies twee keer; `ALT_TOOLTIP_SHARDS_WEEKLY_STALE` is eruit. Nieuwe keys:
  `ALT_COL_LEVEL_ILVL` en `_HINT`.
- ✅ **Rob, na de tweede ronde (6744069): "alle punten goed afgewerkt".** Vault blijft "0/9" bij
  een relog-rij. De voetregel van *This week* die tegen de regel erboven plakte is daarna
  gerepareerd in `AccountWeeklyChecklist.lua`: de regels worden gestapeld op hun echte teksthoogte,
  en bij een breedtewijziging opnieuw. Rob: *"ziet er goed uit"*.
- ✅ **Opgeruimd 11 sep (Rob: *"ruim die oude teksten maar op"*):** elf keys die door optie A
  ongebruikt raakten zijn uit alle 7 talen en uit `Translations2026.lua` gehaald, 86 regels:
  `ALT_STALE_WED_BADGE`, `ALT_UNDER_MANA_CELL_FMT`, `ALT_SHARDS_CELL_FMT`/`_STALE_FMT`,
  `ALT_VAULT_ROW_FMT`, `ALT_VAULT_EMPTY`, `ALT_COL_UNDER_MANA`, `ALT_VAULT_TOOLTIP_STALE_RESET`,
  `ALT_ROW_LEVEL_ILVL_FMT`, `ALT_TOOLTIP_SHARDS_WEEKLY_STALE` en `ALT_COL_SHARDS_HINT`. Die laatste
  stond niet op de lijst; lint [18] wees hem aan zodra de andere weg waren.
  - GEMETEN vóór het weghalen: 0 keer gebruikt buiten `Locales/` (commentaar niet meegeteld). De
    positieve controle `ALT_COL_UNDER_MANA_HINT` werd gevonden en blijft staan. Lint 0 hard,
    check_drift 0.

**§3, de vier kleine reparaties:**
1. Geen afbreken meer in de getalcellen en de vault-cel (`SetWordWrap(false)` + `SetMaxLines(1)`).
2. `FormatShardsCell` krijgt `weeklyMax` mee in de relog-tak, dus "/600" in plaats van "/0".
3. Een Vault-kop met een tooltip: `ALT_COL_VAULT` en `ALT_COL_VAULT_HINT_FMT`, 7 talen. De tooltip
   noemt de drie rijen voluit in volgorde, zodat hij ook de "M D R"-cellen in fr/es uitlegt.
4. `ROW_H` 17 → 20. Namen en beroepen worden per teken afgekapt (`Utf8Len`/`Utf8Head`), niet per byte.

- **Bijvangst, in dezelfde ronde gerepareerd:** `CLAUDE.md` zei dat `fill()` alleen invult wat
  ontbreekt. GEMETEN (`Translations2026.lua:44`): hij vervangt ook elke waarde die gelijk is aan het
  Engels. De regel in `CLAUDE.md` zegt dat nu, met de gevolgen.
- **Volgende stap:** Robs test van §3 + optie A. **Optie B (§2d) pas na Robs akkoord.**

## ✅ 10 sep avond, later — Spec 33 af, behalve het client-oordeel van §7

Rob: *"doe ze allemaal maar, ook die Rapid Fire macro's"*.
- 🔴 **De macro's staan nu ook in de bron.** `TeamMacrosData.lua` wordt gegenereerd uit
  `data/team_macros_gemini.json` door `tools/generate_team_macros_lua.py`. GEMETEN: die JSON gaf de
  Lua van vóór 10 sep exact terug, dus hij is echt de bron. Alle nieuwe macro's staan erin en de Lua
  is opnieuw gegenereerd. Het waarom per macro staat in een `note`-veld, dat de generator niet leest.
  De generator schrijft nu atomisch.
- **Hunter's Mark in de pet-macro**, zoals Rob het bedoelde: `/cast [@target,harm,nodead,nocombat]
  Hunter's Mark` vóór Kill Command. Alleen bij het openen, want een macro ziet niet of het teken er al
  op staat. ⚠️ Niet gemeten of Hunter's Mark de global cooldown deelt.
- **Rapid Fire (MM):** *Shot without breaking Rapid Fire*, gebaseerd op Robs eigen macro's op
  Watchmenow. Eén macro met Aimed Shot; de uitleg zegt dat het voor Arcane, Steady en Multi-Shot
  hetzelfde werkt. Death Chakram is weggelaten, want die staat niet in onze 12.1-data.
- **§2a zoeken:** de tab heeft meer zoekwoorden, en elke macro van je klasse en spec (plus de World-
  macro's) is een eigen treffer die op díe macro landt (`ns.MH_OpenMacro`).
- **§2b:** `/mh macros` bestaat en staat in `ns.MH_COMMANDS`.
- **§2c:** er is een kaart in de Tools-zaal.
- **§7, half af:** alle macrospells tegen `KeybindRoles_*` gelegd.
  - 72 bekend, 3 pet-aanvallen (terecht niet gevonden), **8 om na te kijken**: Rescue (Evoker), Summon
    Black Ox / Jade Serpent Statue (Monk), Final Reckoning (Paladin), Shadow Crash (Priest), Windfury
    Totem (Shaman), Guillotine (Warlock) en Spear of Bastion (Warrior).
  - Dat is geen oordeel, want KeybindRoles kent alleen de hoofdknoppen. Het oordeel van de client komt
    van het nieuwe **`/mh macrocheck`**: per spellnaam in je huidige spec *known* of *not found*, met je
    eigen interrupt als positieve controle. Dat moet per klasse en spec in het spel.
  - 📌 De eerste run van de kruiscontrole vond maar 10 spells. De laatste regel van elke macro eindigt op
    `]=],` en mijn script gooide daardoor de naam weg. Een telling die te klein is om waar te zijn, is
    een fout in het script, geen schone uitslag.
- 🔎 **Eerste `/mh macrocheck`, Hunter BM (Redisch), 10 sep.** De controle staat op known, en alles
  is known behalve **Misdirection** (not found) en Bite/Smack (pet-families; Claw is known).
  Misdirection botst met `KeybindRoles_Hunter.lua`, dat hem "baseline" noemt. **Open:** talent niet
  gekozen, of verdwenen in 12.1? *Smart Misdirection* staat bij BM én MM. De tweede meting is
  **Redisch op Marksmanship**.
  - 🔴 **Rob heeft geen Watchmenow meer.** Ik noemde hem zijn MM-hunter op basis van de map
    `WTF\...\Arathor\Watchmenow`, maar zo'n map blijft staan als een personage verwijderd, hernoemd
    of verhuisd is. Een map in `WTF` bewijst dus niet dat een personage bestaat. De addon slaat per
    personage ook geen klasse op in het accountoverzicht; dat is gemeten, er staat geen `class`-veld
    in. De Rapid Fire-macro is wel echt Robs eigen werk: die macro's stonden in dat bestand.
- 🔎 **Tweede meting, Redisch op Marksmanship.** De controle staat op known, en alles is known behalve
  weer **Misdirection**. Online (murlok.io, class-talenten) staat dat Misdirection in Midnight een
  **talent in de class-boom** is, gedeeld door alle specs. Dat verklaart beide metingen.
  - ✅ **GEMETEN door Rob, 10 sep:** zijn talentboom toont Misdirection als node, *Rank 0/1*, Spell
    ID 34477. Het is dus een class-talent dat hij niet gekozen had, en murlok.io klopte. Het
    commentaar in `KeybindRoles_Hunter.lua`, dat "baseline" zei, is aangepast. Het veld zelf (geen
    `specs`) klopt nog: elke spec kan het talent kiezen.
- 🔎 **De 8 namen om na te kijken, online en in Zygors 12.x-talentdata (10 sep).**
  - **Final Reckoning is WEG** (Maxroll 12.1 "Removed", forum). Hij zit nu in Execution Sentence, dat
    je op een doelwit cast. *Cursor Execution* is daarom vervangen door **Mouseover Execution
    Sentence**.
  - **Shadow Crash is WEG en werd Tentacle Slam** (Icy Veins 12.1, Maxroll, Wowhead), en die heeft een
    doelwit nodig. *Cursor Shadow Crash* is vervangen door **Mouseover Tentacle Slam**.
  - **Spear of Bastion heet Champion's Spear.** Hernoemd in 10.0, bestaat nog in Midnight, en je gooit
    hem nog op een plek. In *Cursor Spear* is alleen de naam veranderd.
  - **Void Torrent** bestaat alleen nog in de **Voidweaver**-hero-talenten (Maxroll, Wowhead). De drie
    Shadow-macro's zeggen dat nu; zonder Voidweaver casten ze gewoon meteen.
  - **Blijven staan:** Rescue (Evoker, Method 12.1), Jade Serpent Statue (wiki, 12.0.0), Black Ox
    Statue (in Zygors data) en Guillotine (Wowhead, bouwdiscussie 12.1).
  - **Open:** Windfury Totem, want die staat niet in de gidsen voor 12.1 en niet in Zygor. Te meten op
    Robs Shaman.
  - Dit zijn allemaal bronnen, geen client-meting. Rob heeft Paladin, Priest, Shaman, Warlock, Druid en
    Mage; `/mh macrocheck` daar is de echte meting.
- 🔎 **Paladin Retribution, 10 sep:** de controle staat op known, maar **Execution Sentence is not
  found**. Volgens Maxroll 12.1 (spec-boom) en Zygors Ret-build is het een talent. ⚠️ Deze paladin is
  **level 80** (Rob), dus het talent kan ook nog buiten bereik liggen in plaats van niet gekozen. De
  uitleg van de macro zegt "(nog) niet", en de onderste regel van macrocheck noemt nu ook "or cannot
  take yet at your level".
  - 📌 **Patroon:** van twee *not found* waren er twee een talent dat niet gekozen was. Macrocheck ziet
    alleen "zit niet in je spellbook" en kan een niet-gekozen talent niet onderscheiden van een spell
    die weg is. Het verschil staat in de talentboom, of in een bron.
  - De uitleg van *Smart Misdirection* (bij BM en MM) zegt nu dat je het talent nodig hebt.

## 🧰 10 sep avond — Spec 33, eerste ronde. De "nog open"-lijst hieronder is inmiddels afgewerkt (zie boven)

Rob vond zijn eigen BM-hunter-macro ("method", op Redisch, Lightbringer; alleen dat personage) niet
terug op Carola's pc: *"dat soort macro's moet bij ons in de macro set komen"*. Spec 33 (7 sep) had
precies deze al op de lijst en stond op "na 3.10.0". GEMETEN vóór het bouwen: van Spec 33 was
**niets** gebouwd.

**Nu gebouwd in `TeamMacrosData.lua`.** Elke spellnaam is gecontroleerd tegen `KeybindRoles_*.lua`,
en de spec-index tegen `InterruptMacrosData.lua`.
- Hunter BM: **Kill Command + Pet Attack** (§3a, Robs eigen tekst, als eerste), **Mouseover Barbed
  Shot** (§3a2).
- Hunter alle drie de specs: **Cursor Traps** (§4; Freezing Trap is baseline) en **Mouseover
  Hunter's Mark** (Robs vraag, 10 sep; baseline).
- Druid Guardian: **Mouseover Growl** (§3c).
- Priest Shadow: Madness, Voidform en Mind Blast **zonder Void Torrent af te breken** (§3b).

**Nog OPEN uit Spec 33, niet gebouwd:**
1. §2a: de zoekfunctie vindt de Macros-tab nog steeds alleen op *interrupt / macro / kick*
   (`NavSearch.lua:239`). Die zoekindex zou uit `TeamMacrosData.lua` moeten komen.
2. §2b: er is geen `/mh macros` (GEMETEN: `Core.lua` kent "macros" alleen als tab-vlag).
3. §2c: de Tools-zaal noemt de Macros-tab niet.
4. §7: de hele macrodata is nog nooit tegen de 12.1-client gelegd.
5. Kandidaat uit Robs eigen macro's, **niet toegevoegd, Rob beslist**: op Watchmenow (MM) staat
   `/use [nochanneling:rapid fire] …` met `/cancelaura Aspect of the turtle` onder vijf schoten.
   Dat is dezelfde soort als de Shadow-macro's: je channel niet afbreken.

## 🌙 10 sep avond — Dundun-macro zet nu een maan

Rob: het ping-vlaggetje verdwijnt; kan dat langer? **Nee.** Het is WoW's eigen Ping System; de duur
bepaalt de game, en de instellingen hebben er geen optie voor (twee gidsen, niet in de client
gemeten). Daarom zet de macro in `DundunShrine.lua` nu ook `/tm 0` en `/tm 5` (maan, Robs keuze):
een raid-teken blijft staan. ✅ **Werkt**: Rob zette de nieuwe macro erin, *"hij werkt goed"*. Rob moet zijn bestaande
macro zelf bijwerken, want de addon maakt macro's niet aan.
- ❌ **Een grondmaan (world marker) is geprobeerd en weer weggehaald.** GEMETEN door Rob in een
  delve: met `[@cursor]` komt hij waar de muis staat, en met `[@target]` en `[@player]` vraagt de game
  nog om een klik op de grond. Een macro kan in 12.1 dus geen grondmarkering op een unit leggen. Rob:
  *"vergeet die world marker"*. Wel gemeten en bruikbaar: grondmarkeringen werken in een delve met
  alleen Valeera, en de maan is world marker 7 maar raid target 5.
- 📌 Er zijn nog meer surge-bevindingen van online, die nog niet in de addon zitten. De in-game
  Events-tab toont welke surge er loopt en wanneer. De Mix Master-daily gaat pas open via een
  *Handful of Esoteric Ingredients* bij Ofi in het moeras (één Wowhead-reactie). Allebei wachten op
  Robs altar-screen.

## ✅ 10 sep middag — Rob testte de Curse Surges; wat daaruit volgde

- **Getest, alles gezien:** de Rares-tab (0/12, beide weg), de kaart (2/5, grijze No route, Elite),
  de popup met de baasnaam, zoeken op `kassi`, en de tegenproef bij Mix Master. De popup-bug is
  daarmee echt weg. Details staan in `docs/TESTLIJST.md`.
- 🔎 **`/mh rarequests`:** een surge-kill zet band **A** (96969/96970 done) en niet band **B**
  (93722/93673 --). GEMETEN op Earthshammy, die de surge deed (Rob bevestigde het personage).
  Vastgelegd bij `RARE_QUEST_PAIRS`.
- 🔎 **`/mh atal` (SV `atalProbe`, at=1789034570, 10 sep ~12:03):** op 2512 stond alleen POI 8927
  (Wraith Wrath). Dat is de positieve controle; een surge-POI was er niet. **C blijft dicht** tot een
  meting terwijl er zichtbaar een surge loopt.
- **Na de test gebouwd:**
  - `kind` op kaarten, met drie nieuwe labels: Event (Turn the Surge, Oppose the Foes), Pet battle
    (Safari) en Mixing (Mix Master). Rob had gezien dat die onder [Rare] stonden.
  - Mix Master toont nu de ontgrendel-uitleg `ACH_NOTE_MIX_GATES`, die sinds augustus nergens werd
    gebruikt, plus een live Renown-regel (2772, nodig 3). Gebouwd via `GateText` +
    `gateNote`/`gateRenown`.
  - De ketel-waypoint staat nu op 57.41/48.70 (Robs meting). De oude 57.23/48.46 was Apothecary Dezi.
    ✅ Gezien: *"1m away"*.
  - ✅ Kaartsoorten gezien; de deck-iconen ook (Rob en Carola: *"supergaaf"*).
  - 🔁 **De Mix Master-voorwaarden zag Rob niet.** Ze stonden alleen in de popup, en Mix Master
    heeft geen Waypoint-knop per rij: de kopknop is gedeeld en opent geen popup. Een rij aanklikken
    doet niets. Hij hield de muis erboven, dus nu staan ze ook in het muis-vakje.
    ✅ **Gezien:** *"Your Renown with Zul'jarra's Forces: 8 (needs 3)"*, in groen. De live lezing van
    faction 2772 werkt, en Rob voldoet aan de eerste voorwaarde.
- **Rob vroeg: moet er eerst een quest bij Tokka/Dezi?** Onze eigen notitie noemt twee
  voorwaarden en geen quest. Zygor heeft een Ofi-questreeks in het moeras (93387 → 93393, *"A Little
  Kindness"*). Of die nodig is voor de ketel is **niet gemeten**.

## 🔎 10 sep middag — twee losse eindjes

- **Een onbekende schrijver in `docs/API_WATCH.md`.** Voor de derde keer (2, 5 en 10 sep) stond er
  een *"Tweede run van vandaag"* ongecommit op schijf. Op Robs woord gecommit (`6fe654e`). De
  ochtendroutine in `CLAUDE.md` commit zo'n verweesde wachter-regel voortaan zelf, vóór de pull. Wat
  gemeten en uitgesloten is, staat daar; **wie het schrijft is open**. Volgende stap als het
  terugkomt: de Windows-taakplanner bekijken (`schtasks`, kost Rob een prompt).
- **Deck-iconen: ✅ Rob koos DiabloHeavy (10 sep middag).** Alle 28 staan in
  `Downloads\MH_deck_iconen_diablo\` (script `mh_deck_diablo.py`, zelfde scratchpad): elk label op de
  hoogte van DELVES, eerst minder letterafstand en pas daarna hooguit 5% smaller. Nog op de deck
  bekijken. Hieronder de meting die aan de keuze voorafging: `mh_label_fonts.py` (scratchpad van sessie bce6ed51) zet
  alle acht labels op de hoogte van DELVES: 12,5 px op de deck, waar de rest nu op 81–95% staat. In
  geen enkel font hoeft er iets te krimpen, behalve bij DiabloHeavy.
  🔴 **GEMETEN:** de losse bestanden in `_retail_\Fonts\` (FRIZQT__, MORPHEUS, SKURRI, ARIALN) zijn
  alle vier **hetzelfde bestand: Barlow Condensed Bold**, een vervangend font. De echte Friz
  Quadrata en Morpheus staan niet los op schijf. Na Robs keuze: de volle set van 28 naar een
  **nieuwe** map naast `E:\ComfyMCP\mh_iconen\deck_144`, niets overschrijven.

## ✅ 10 sep — Ori'kassi uitgezocht: hij is de eindboss van een Curse Surge, één van VIJF

Onderzocht terwijl Rob weg was, in de volgorde die gisteravond hieronder werd afgesproken: eerst
onze eigen data, dan pas andere bronnen.

### 📌 GEMETEN in Robs eigen client — de sterkste bron die er is

Een oude `/mh atal`-run staat in `WTF/.../SavedVariables/MidnightHelper.lua` (`atalProbe`), en die
vroeg achievement **63390** bij de client op:

| # | criterium | naam (van de client) |
|---|---|---|
| 1 | 115368 | Looming Mutagenitor |
| 2 | 115369 | Vassti, the Exalted Broodmother |
| 3 | 115370 | Ss'akrithos |
| 4 | 115371 | **Venom Lancer Ori'kassi** |
| 5 | 111353 | **Malformed Leviathan** |

Achievement-naam van de client: **"Turn the Surge"**. Vijf bosses.

### Zygor en HandyNotes, allebei kandidatenbronnen, allebei eens met de client

**Zygor** (`ZygorEventsCommon.lua`, map `Events Guides\Midnight (80-90)\Curse Surges\`) kent precies
**vijf scenario's** op map 2512:

| scenario | ID | areapoiid | plek | boss |
|---|---|---|---|---|
| The Broodmother's Nest | 3278 | 8888 | 46.16 / 33.61 | Vassti — ✅ Zygors `kill`-stap (45.29/28.64) |
| The Malformed Leviathan | 3270 | 8891 | 47.00 / 62.22 | Leviathan — ✅ Zygors eigen `kill`-stap |
| Mlurkkr Massacre | 3286 | 8889 | 70.18 / 33.15 | Ss'akrithos — ✅ Zygors `kill`-stap (71.28/31.39) |
| **Siege at Coiler's Wake** | 3274 | 8890 | 67.64 / 77.90 | Ori'kassi — ✅ Zygors `kill`-stap **én Robs scherm** |
| The Looming Mutagenitor | 3288 | 8887 | 26.26 / 67.40 | Mutagenitor — ✅ Zygors `kill`-stap (26.71/64.95) |

🔴 **Correctie, middag 10 sep:** hier stonden drie koppelingen als AFGELEID ("op naam", "door
eliminatie"). **Zygor heeft voor álle vijf een `kill`-stap**, elk binnen zijn eigen scenario, en
HandyNotes heeft ook alle vijf (`RareElite`, criteria 115368/115369/115370 = de client). Alle vijf
dus GEMETEN in de zin van "drie bronnen eens". Ik had vanochtend alleen de twee regels gezien die ik
zocht.

Vrijspelen volgens Zygor: het tweede hoofdstuk van de Curse of Ula'tek-campagne, plus de quests
*Counter-Curse Bounty* (97382, Jan'sari the Watchful) en *Turn Back the Surge* (96995, Talon Commander
Zela) vanaf renown 2696 ≥ 2.

**HandyNotes** (`zones/coiled_isles.lua`) zet beide als `RareElite` met `note = curse_surge_note`, en
zijn criteria voor Ori'kassi (**115371**) en de Leviathan (**111353**) zijn **gelijk aan wat de client
gaf**. 📌 Onze PTR-notitie van 6 aug zei al *"one of five locations"* — toen uit twee gidssites, nu
bevestigd door een derde bron én door de client.

### 🔴 Twee correcties op mezelf, van vanochtend

1. **Ik meldde een tegenstrijdigheid die er niet was.** Onze probe-notitie van 19 aug noemde criteria
   115368/115369/115370; ik zette die tegenover HandyNotes' 115371/111353. Het zijn gewoon **de andere
   drie bosses**. Niemand zat fout — ik vergeleek verschillende rijen.
2. **Zygors `scenariogoal 111387` voor Ori'kassi is een scenariostap-ID**, een andere nummerreeks dan
   achievement-criteria. Dat hij voor de Leviathan samenvalt met het criterium (111353) is toeval, geen
   bevestiging.

### ⚠️ Wat er vandaag mis is in de addon — GEMETEN in de code

1. **De route stuurt naar niets.** `NearestOpenRareRespectingSkips` routeert naar elke rare waarvan
   `rare[1]` niet op done staat. Voor Ori'kassi is dat **93722**. Zolang die niet omslaat, wijst de pijl
   naar 67.16/77.52 — **of er nu een surge loopt of niet**. Aankomen bij een lege plek ziet er van
   buiten precies uit als verouderde data.
2. **Een scheve helft.** De rares-lijst draagt **2 van de 5** surge-bosses, alleen omdat de
   PTR-vignettevlucht van 6 aug die twee toevallig zag. Vassti, Ss'akrithos en de Mutagenitor staan er
   niet in.
3. **We leggen nergens uit wat een Curse Surge is.** De Codex noemt het één keer terloops, in een
   power-beschrijving (*"ghostly allies at Curse Surges"*).

### ✅ Het precedent bestaat al: Oppose the Foes (63601)

Doelen die alleen tijdens een evenement bestaan, als **checklist** met een notitie per node, en
`ns.AchievementNodeRoutable` houdt nodes zonder `mapID/x/y` uit de route. Exact deze vorm — alleen met
één verschil: surges hebben wél een **vaste plek**, alleen geen vast **moment**.

### ✅ A + B GEBOUWD, 10 sep middag — Rob: *"doe maar allebei"*

- **A** — `AchievementsData.lua`: 63390 met **alle vijf** bosses. Ze gebruiken `wp*` en geen
  `mapID/x/y`: elke rij krijgt een Waypoint-knop, maar de route slaat ze over. De kaartknop zegt
  dus "No route", en dat klopt. Uitleg `ACH_NOTE_CURSE_SURGE` in 7 talen, en alle vijf staan in
  `ELITE_RARE_CRITERIA`.
- **B** — de twee rijen zijn uit `COILED_ISLE.rares`. `RARE_QUEST_PAIRS` houdt ze wél, zodat
  `/mh rarequests` de open vraag (flipt een surge-kill iets?) nog kan meten.
- 🐛 **Bestaande bug meegenomen** (GEMETEN in de code): `ns.ShowTreasureToast` las `activeEntry`,
  maar die `local` wordt pas ~150 regels later gedeclareerd. Op die plek was het dus een global, en
  die was altijd nil. Gevolgen:
  - elke popup van een naamloze node (alle Coiled Isle-hunts) kreeg de titel *"Treasure"*
  - knop 1 kreeg bij `wp*`-nodes (Mix Master) geen coördinaat, en deed dus niets

  De fix is `EntryForNode`, met `wp*` als fallback. Nooit op een scherm gezien, dus staat op de
  testlijst.
- **Zoeken** op een node met een notitie toont nu dezelfde popup als de Waypoint-knop.
- Testen: bovenaan `docs/TESTLIJST.md`. **C blijft open** tot het POI-nummer gemeten is.

### 💡 Het oorspronkelijke voorstel (A en B nu gebouwd, C open)

- **A. 63390 "Turn the Surge" als achievement-hunt**, vijf criteria van de client, met een notitie
  *"dit is een evenement op een vaste plek; het loopt niet altijd"*. Coördinaten wél, want de plek is
  vast — maar dan moet de route weten dat er alleen iets is als het evenement loopt.
- **B. Ori'kassi en de Leviathan uit `COILED_ISLE.rares`.** Dan stopt de pijl met naar lege plekken
  sturen. ⚠️ **Prijs:** de rare-alert matcht vignettes tegen de rares-lijst (`MatchRareInZone`), dus
  deze twee verliezen hun "vlakbij"-melding. Alleen deze twee hadden die überhaupt; de andere drie
  surges nooit.
- **C. Later:** een "er loopt nú een surge, hier"-signaal op basis van de area-POI's (8887-8891
  volgens Zygor). Machinerie bestaat al (`PrintAreaPOIs` in `AtalUtekProbe.lua`).

### ❓ Open — alleen in het spel te meten

1. **`/mh rarequests` op Earthshammy**, want díé deed de surge gisteravond. Slaat **93722** (B) of
   **96969** (A) nu om naar done? Dan weten we of de rare-rij zichzelf ooit kán afvinken. (De
   `rarequests`-snapshot in SV is van **9 sep 07:00 op Iceicebaby**, dus vóór de surge en op een
   ander personage — die zegt hier niets over.)
2. **`/mh atal` terwijl er een surge loopt.** Welk POI-ID verschijnt: **8890** (Zygor) of **8937**
   (HandyNotes)? Die twee bronnen zijn het oneens en ik kies er niet één. De oude probe zag **geen
   enkele** surge-POI — toen liep er dus geen, en *"leeg is geen bewijs van afwezigheid"* staat er zelf
   bij.
3. **De cyclus.** Onbewezen. De PTR-notitie citeert twee gidssites ("rotating"), een forumdraad noemt
   ~20 minuten per surge. **Er gaat geen getal de addon in tot het gemeten is.**

---

## (verslag) 🔴 VOOR MORGEN — Venom Lancer Ori'kassi is geen rare maar een SCENARIO

Rob, 9 sep 23:26, na de shard-metingen. De route stuurde hem naar **Venom Lancer Ori'kassi** als
rare. Wat hij aantrof:

- een gebeurtenis-balk **"Siege at Coiler's Wake"** → **"The Slithering Advance"**
- een voortgangsbalk *"Ula'tek's Spawn Defeated and Trolls Freed"* op **53%** — hij viel er middenin
- als beloning: een Shadowclaw Jerkin **en 112 Coffer Key Shards**

### 📌 Onze eigen data wist dit half, en dat is het sterkste bewijs dat er is

`Rares.lua` draagt precies **twee** entries met een waarschuwing, en het zijn dezelfde twee:

```
:240  Malformed Leviathan        -- elite; ⚠️ id UNVERIFIED, see the band note
:280  Venom Lancer Ori'kassi     -- elite; ⚠️ id UNVERIFIED
:329  ⚠️ Venom Lancer and Malformed Leviathan stay at `0` on purpose
```

En bij de Leviathan staat al sinds augustus (`Rares.lua:220`): *"it is the one that is an EVENT
rather than a plain rare: a scenario banner announces 'Defeat the Monstrosity!'"*. Onze eigen
aantekening bij Ori'kassi zegt **"never killed"** — nu weten we waaróm: je doodt hem niet als rare,
je doet mee aan een scenario.

🔴 **Dus allebei de entries die wij zelf verdacht hadden gemarkeerd, zijn evenementen.** Dat is geen
toeval meer, dat is een categorie. Beginnen bij die twee regels is morgen sneller dan zoeken.

### ⚠️ Wat dit raakt

1. **De route.** We sturen hem naar een vaste coördinaat alsof er iets staat. Loopt het evenement
   niet, dan komt hij aan bij niets — en dat ziet er van buiten uit als verouderde data.
2. **112 shards is een DERDE uitbetalingsklasse**: 50 (wiki, onbewezen), 75 (gemeten, rare),
   112 (gemeten, dit evenement).
   ✅ **De waarnemer van vanavond overleeft dat door zijn ontwerp** — hij neemt de **modus**, niet
   het gemiddelde, dus één losse 112 tussen de 75's verschuift niets. Was het een gemiddelde
   geweest, dan had deze avond het getal meteen kapotgemaakt.
3. **De quest-ID's** (96969/96970) vielen al buiten de gemeten band. Dat past bij een evenement.

### Morgen, in deze volgorde

1. **Onze eigen twee regels lezen** — `Rares.lua:220-240` en `:280`, plus de bandnotitie. Daar staat
   al meer dan een zoekmachine gaat opleveren.
2. **Dan pas online/andere addons** — HandyNotes_Midnight is de kandidatenbron, geen bewijs
   ([[handynotes-rare-coords-trusted]] gaat over coördinaten, niet over het TYPE content).
3. **Vraag om te beantwoorden:** is dit een periodiek evenement met een eigen timer? Zo ja, hoort het
   niet in de rares-lijst maar bij het world-content-spoor, en moet de route erover zwijgen als het
   niet loopt.

⚠️ **Niets aan aanraken tot dat helder is.** Ori'kassi uit de rares halen terwijl hij daar soms wél
te doden is, zou een tweede fout op de eerste stapelen.
## ✅ 9 sep — de shard-onenigheid is GEMETEN, en er is géén bug (bijna wel gemeld)

Rob werd rank 10 in de Delver's Journey en vroeg wat *"Coffer Key Shards earned from all sources is
increased"* praktisch betekent. `/mh shards` op zijn client:

```
quantity               = 45
quantityEarnedThisWeek = 517
maxWeeklyQuantity      = 600
maxQuantity            = 0
```

**Twee dingen beantwoord, en één blijft open.**

1. ✅ **De weekcap is NIET verhoogd op rank 10** — `maxWeeklyQuantity` staat gewoon op 600. De
   verhoging zit dus in wat elke bron uitbetaalt, niet in het plafond.
2. ✅ **De drieweg-onenigheid uit de kop van `CofferShards.lua` is beslecht: ze zijn het eens.**
   `maxQuantity = 0`, en **beide** kopieën (`AltOverview.lua:298`, `Delves.lua:2248`) testen
   `maxQ <= 0` en vallen terug op de weekcap. Alle drie komen op 600 uit.

### 🔴 En ik was op weg een bug te melden die niet bestaat

De probe printte `maxQuantity = 0` met erachter *"AltOverview and Delves use this first"*. Samen
gelezen zegt dat: die twee schermen rekenen met nul. **Dat doen ze niet** — ik zag het pas toen ik
beide kopieën echt opende.

📌 **De hint was geschreven toen alleen de VOLGORDE bekend was en niemand een echte nul gezien had.**
Zodra die nul er stond, wees hij de verkeerde kant op. ⚠️ **Een diagnose die zijn lezer misleidt is
erger dan een die minder zegt, want hij wordt geloofd.** Hij meldt nu per geval wat de terugval
*doet* in plaats van te hinten naar de leesvolgorde.

⚠️ **En het blijft een val, om de reden waarvoor hij opgeschreven was:** de terugval redt ze alléén
omdat `maxQuantity` nul is. Publiceert Blizzard ooit een echte levenslange cap, dan vuurt de terugval
niet meer, tonen die twee schermen stilletjes die andere cap en blijft de waarschuwing de weekcap
gebruiken — en geen van beide ziet er kapot uit.

### ✅ BEANTWOORD 9 sep: één rare betaalt **75**, en de wiki-50 is fout

Rob deed een schone voor-en-na op een **verse character**: 600 weekruimte (dus geen afknipping),
niets anders geloot ertussen, Journey rank 10 — accountbreed, door hem bevestigd op díé character.

```
quantity                447 -> 522   = +75
quantityEarnedThisWeek    0 ->  75   = +75
```

Beide tellers zeggen hetzelfde, dus dit is hard.

🔴 **Wat het vandaag kost, zodat de omvang op papier staat:** met 525 shards over zei het paneel
*"about 11 rares"* waar het antwoord **7** is. Rob zou vier rares te veel lopen. ⚠️ Die fout raakt
**alleen spelers die het verst zijn**, en wordt nooit gemeld — je zit gewoon eerder aan je cap dan
beloofd. Exact dezelfde vorm als alles van vandaag.

🔴 **Maar 75 is NIET het nieuwe getal om in te vullen.** Rank 10 zegt letterlijk dat alle bronnen
méér betalen, dus de uitbetaling **hangt af van je rank** — een constante in dat bestand is per
definitie fout voor iemand. En *"de basis is 50 en rank 10 geeft +50%"* mag je er niet uit
concluderen: die verhouding bestaat uit één gemeten en één wiki-getal, en een verhouding is niet
beter dan zijn slechtste helft. De basis is nooit gemeten.

📌 **Daarom staat de 50 er nog**, met de meting eromheen gedocumenteerd. Hem vervangen door 75 ruilt
een **bekende** fout in voor een **verborgen** fout (goed op rank 10, stil fout daaronder).

### ✅ GEBOUWD 9 sep — de waarnemer: wat jóúw spel betaalt, niet wat een wiki zegt

`CURRENCY_DISPLAY_UPDATE` op currency 3310. Elke **toename** wordt weggeschreven in
`ns.db.shardGains` (max 40), en `ns.GetObservedShardGain()` geeft de **meest voorkomende** gave terug.
Zodra er **drie schone waarnemingen** zijn én die meest voorkomende minstens de helft is, rekent
*"nog ongeveer N rares"* daarmee. Anders blijft de wiki-50 staan **en zegt `/mh shards` dat erbij**.

⚠️ **Bewust NIET toegeschreven aan rares.** Shards komen ook uit chests, treasures en afgemaakte
delves, en `Rares.lua` vuurt geen "je hebt er een gedood"-signaal. Zo'n gave "een rare" noemen zou een
gok zijn in feitenkleding — en questvlaggen zijn precies wat vandaag onbetrouwbaar bleek. Er staat
dus *"een uitbetaling gaf N"*, en dat is toevallig ook precies wat het paneel nodig heeft.

🔴 **Drie valkuilen afgevangen, en de eerste is dezelfde die Robs meting had kunnen bederven:**
1. **Afgeknipte gaven tellen niet mee.** Vlak bij de cap krijg je alleen wat er nog past, dus een 75
   arriveert als 12. Een handvol daarvan zou het getal stilletjes omlaag trekken. Alleen gaven
   waar ruimte voor was tellen; het aantal overgeslagene wordt **gemeld**, niet verstopt.
2. **De eerste meting legt alleen de basislijn vast.** Zonder dat lijkt inloggen op een gave van
   alles wat je bezit, en één zo'n rij vergiftigt het gemiddelde voorgoed.
3. **Een modus die niet typisch is, telt niet.** Is de meest voorkomende waarde minder dan de helft
   van de waarnemingen, dan is het een allegaartje en geen tarief — dan zwijgt hij.

📌 `/mh shards` toont nu of het getal **GEMETEN** is of nog geleend, met hoeveel waarnemingen. Want
een tarief van 50 en een tarief van 75 zien er in de uitvoer identiek uit, en juist het geleende was
fout.

### 💡 De redenering: dezelfde als vanochtend bij de givers — waarnemen in plaats van afleiden

De addon kan `CURRENCY_DISPLAY_UPDATE` volgen en opschrijven wat een rare-kill jóú daadwerkelijk
opleverde — precies zoals het soul-grootboek item 273000 volgt. Dan komt *"nog ongeveer N rares"* uit
**jouw eigen spel** in plaats van uit een tabel, klopt hij op elke rank, en overleeft hij elke
tuning-hotfix zonder dat wij iets weten.
⚠️ Tot dat er is: het getal blijft te hoog voor gevorderde spelers, en dat staat nu in de code.

### ❓ Oorspronkelijke vraag (verslag): hoevéél meer betaalt een bron op rank 10?

`SHARDS_PER_RARE = 50` is een wiki-cijfer, expliciet gemarkeerd als **nooit in Robs client gemeten**.
De regel *"nog ongeveer 2 rares"* deelt daarop. Klopt die 50 niet meer op rank 10, dan is die regel
scheef **voor precies de spelers die het verst zijn** — en dat wordt nooit gemeld, want je zit
gewoon eerder aan je cap dan voorspeld.
📌 **Meting: shards noteren, één rare doden, opnieuw kijken.** Levert het eerste gemeten getal op dat
we voor deze currency hebben.
## ✅ 9 sep — acht "spring naar dit scherm"-toetsen, voor Robs Stream Deck

Rob heeft Alt+M al op zijn Stream Dock en wilde knoppen die meteen naar Rares of Delves gaan:
*"kunnen we daar intern een lijst voor maken die in principe niet voor anderen bedoeld is? Maar wel
eventueel te vinden als kleine leuke extra?"*

📌 **Dit is zijn keypad-idee van 8 sep — en de ontwerpvraag die het toen blokkeerde geldt hier niet.**
Die versie was per-scherm **slash-commando's** (`/rares`), en het open punt was botsing: korte
generieke namen zijn van wie ze het laatst claimt. **Bindings hebben geen namespace-probleem** — ze
staan onder onze eigen kop in Blizzards keybinding-scherm.

⚠️ **En een binding past ook gewoon beter bij de hardware.** Een Stream Deck kan ook een commando
*typen*, maar dat heeft het chatvenster nodig, kost een Enter, en verdwijnt als er al een tekstveld
focus heeft. Eén toetsaanslag die de client zelf afhandelt is robuuster.

✅ **Gebouwd:** `MidnightHelper_KeybindTab(id)` plus acht bindings (This Week, Rares, Delves, Codex,
Professions, Achievements, Mounts, Account snapshot). **Niets standaard gebonden** behalve het
bestaande Alt+M — acht toetsen inpikken op andermans toetsenbord is precies wat dit addon anderen
niet aandoet.

🔴 **Acht, geen negenentwintig.** Het keybinding-scherm is een lijst die een mens leest; alle tabs
binden zou de drie bestaande toetsen begraven onder een muur waar niemand langs scrollt.

📌 **De labels komen uit de tabbladen zelf** (`ApplyBindingLabels` bouwt ze uit `TAB_*`), niet uit
nieuwe strings. Dat scheelde **56 vertalingen** (8 × 7 talen) — er is één nieuw formaat,
`BINDING_NAME_OPEN_TAB_FMT` — én een binding kan nooit iets anders heten dan het tabblad waar hij
heen gaat. Dat is dezelfde fout die deze week twee keer gerepareerd is: het zoekresultaat dat
*"Course (101)"* zei voor de adviseur, en de giver-regel die drie van de vier givers bij naam noemde.

**Het lijstje dat hij vroeg:** `docs/STREAMDECK.md` — de recepteerkant (welke toetsen, waarom
*Hotkey* en niet *Text*, wat te doen als een knop niets doet). ⚠️ `docs/` gaat niet mee in de zip,
dus dat bereikt geen speler; de **bindings** staan wél gewoon in het spel voor wie kijkt. Precies de
twee helften die Rob vroeg.

### ✅ En acht icoontjes, want alle knoppen zagen er hetzelfde uit

Robs volgende vraag zodra het werkte. **Gemeten dat er niets te kopiëren viel:** alleen de vier
zijbalk-kamers hebben een icoon (`UI.lua:333-336`), de tabbladen zelf geen enkele.

📌 **SVG, geen PNG — en dat is een grens van mij, geen ontwerpkeuze.** Een SVG is tekst, dus die kan
ik exact schrijven; een bitmap kan ik niet tekenen. Meegenomen voordeel: scherp op elk deckformaat.
Een script schrijft ze (`docs/streamdeck-icons/`, acht stuks, addon-kleuren, elk een eigen accent)
en **controleert daarna zijn eigen uitvoer**: elk bestand moet als XML parsen en zijn label dragen.

⚠️ **Er staat een WOORD op, niet alleen een symbool.** Een abstract icoontje is na een week weg-zijn
een raadspel, en dit is nu juist het soort knop dat je niet dagelijks gebruikt.

🔴 **En bij de WoW-iconen-optie geen namen verzonnen.** De vier die in het document staan zijn de
namen die dit addon zélf gebruikt en dus gegarandeerd bestaan; voor de rest staat er hoe je ze zelf
opzoekt. Een plausibele icoonnaam is precies het soort gok waar dit project een regel over heeft.

### 🔴 En daarna: hernoemen is niet omzetten

Rob: *"alleen verwacht ie png 🙂 maar dat is simpel renamen"* — en het wérkte, wat betekent dat zijn
software naar de **inhoud** kijkt in plaats van naar de extensie. ⚠️ **Dat is geen fundament.** Een
`.svg` die `.png` heet is een bestand dat over zijn eigen formaat liegt; het houdt op te werken bij
een update, op een andere machine, of na een profiel-export — en dan lijkt het addon stuk terwijl het
de bestandsnaam is.

✅ **Er staan nu echte PNG's naast:** 288×288, RGBA, doorzichtige hoeken. **Gemeten dat er geen
converter is** (geen cairosvg, cairo of wand; PIL 12.3 wél), dus ze zijn **opnieuw getekend** uit
dezelfde specificatie in plaats van geconverteerd — 4× supersampling en LANCZOS, want PIL-primitieven
hebben harde randen en een kartelig icoontje ziet er kapot uit op zo'n fel schermpje. Het script
controleert zijn eigen uitvoer: elk bestand moet heropenen als 288×288 RGBA PNG.

📌 **Meegegeven vóór hij WoW-iconen gaat zoeken:** spel-iconen zijn klein — WoW tekent ze voor een
actiebalkvakje. Opgerekt naar een deck-toets worden ze zacht. Het alternatief staat in het document:
het spel-icoon **op** ons frame zetten in plaats van uitrekken, en het script kan dat samenstellen
zodra hij bestanden heeft.

### ✅ En daarna de gouden sierlijst — Rob vond een pack van €12 en vroeg: kunnen wij dat niet zelf?

**Het antwoord splitst netjes in tweeën, en het eerlijke deel eerst.** Het **frame** is meetkunde en
kleurverloop: gouden rand met bevel, verzonken donker vlak met warme gloed, hoekstenen, naamplaatje.
Dat is gebouwd en staat er. De **geschilderde illustraties** in zo'n betaald pack zijn tekenwerk, en
dat kan ik niet maken — dat is precies waar die €12 voor is.

🔴 **Maar de belangrijkste vondst is dat het geen keuze is.** Op Robs voorbeeldafbeelding staan
*DUNGEON, SPELLS, REP, GUILD, BAG, SHEATH, CURRENCY, PVP, NEAR/NEAREST/SELF, REPLY* — allemaal
**functies van WoW zelf**, geen schermen van deze addon. **Dat pack dekt onze acht knoppen niet**, en
na aankoop heeft hij ze nog steeds nodig. Ze vullen elkaar aan in plaats van te concurreren, en dat
is in het document gezet zodat niemand hier later de verkeerde afweging in leest.

⚠️ **Twee echte fouten onderweg, allebei zichtbaar in het eerste resultaat:** `paste` mét masker
**vervángt** pixels inclusief alpha, dus een grotendeels transparante gloed wiste het donkere vlak
weg en de knop kwam wit terug — dat moest `alpha_composite`. En `arc` op de omhullende rechthoek
tekent een **ellips**, geen afgeronde-rechthoek-rand, dus er lag een grote cirkel over de knop. Beide
zijn gerepareerd mét de reden erbij in het script, want ze zien er in code allebei redelijk uit.
## 🔴 9 sep — ik bouwde iets dat kan zwijgen en géén manier om te zien dát het zweeg

Rob klikte Liadrin aan, deed `/mh weeklies`, en alle vijf de givers stonden nog steeds op *"not
visited since this was built"*. De waarneming had niets opgeschreven — en er was **geen enkele manier
om te zien waarom niet**.

📌 **Vier verschillende fouten geven precies datzelfde stille resultaat:** er ging helemaal geen
gesprekvenster open, de NPC was niet te identificeren, het was geen giver die we volgen, of de
questlijst was onleesbaar. Van buiten één symptoom.

⚠️ **Dit staat als harde regel in CLAUDE.md (Spec 30)** — *"bouw je iets dat kan zwijgen, bouw dan een
manier om te zien dát het zweeg"* — en ik heb hem dezelfde dag elders wél toegepast (`/mh curiodebug`
print waaróm de Valeera-tip zweeg) en hier vergeten. Dat is geen pech, dat is de regel niet toepassen
op mijn eigen nieuwe code.

✅ **Gerepareerd:** élk gesprekvenster laat nu een spoor achter — tijd, NPC-naam (alleen als hij geen
secret value is), of hij aan een giver gekoppeld kon worden, hoeveel quests er waren, en de **reden**.
`/mh weeklies` print dat bovenaan, vóór de tabel, want het beantwoordt de vraag die de tabel niet kán
beantwoorden: **ging er überhaupt een venster open?**

### ✅ En de meting is binnen: de hypothese klopt

Twee stappen, allebei op Robs scherm:

1. **Bankier (Ceera):** `npc=Ceera  giver=not matched  -> not a giver we track`. Het event vuurt, de
   naam is leesbaar, en een bankier wordt terecht niet als giver gezien. **De hele keten werkt.**
2. **Liadrin daarna aangeklikt:** het spoor bleef op **Ceera** staan.

🔴 **Dus een NPC zonder aanbod opent HELEMAAL GEEN gesprekvenster.** Er is geen event om op te
reageren. *"Ze had iets"* is waarneembaar; *"ze had niets"* is dat niet, en dat zit in het spel.

📌 **Twee gevolgen, en het tweede is een correctie op mezelf.**
- De asymmetrie die ik inbouwde blijkt **noodzakelijk** in plaats van alleen voorzichtig. Ik koos hem
  op een risico-argument (een verborgen taak is duur); hij was de enige beschikbare optie. ⚠️ Gelijk
  krijgen om een andere reden dan je bedacht, is geen bevestiging van je redenering.
- **De waarde is smaller dan mijn eigen commentaar suggereerde.** Dit kan een onterechte *"done"*
  corrigeren wanneer een giver écht werk heeft. Het kan een terechte "done" niet bevestigen. Dat is
  de helft die je loot kost — dus de helft die je wilt — maar het is een helft, en dat staat nu ook
  zo in de code.

⚠️ **Nog steeds open:** waaróm alle dertien Liadrin-vlaggen op completed staan. **De meting daarvoor
is volgende week**, vóór Rob iets doet: `/mh weeklies`. Slaan er een paar om naar `-`, dan resetten ze
wél en klopte het scherm toevallig. Blijven ze staan, dan is bewezen dat die vlaggen structureel
onbruikbaar zijn voor "deze week".
## ✅ 9 sep — "open de kist" staat nu op de toast, niet alleen in de chat

Rob stond bij **Farthik the Plunderer** met de rare-toast op zijn scherm: *"voor deze moeten we een
kist open maken, kunnen we dat vermelden?"*

📌 **We wisten het al.** Farthik draagt `spawnKey = "RARE_SPAWN_FROM_CHEST"`, geschreven op 19 aug
voor precies dit geval, en `RareArrivalHintKey` geeft hem netjes terug. Hij ging alleen naar **chat**
— terwijl deze toast, twee keer zo groot als elke andere, vóór Robs neus de algemene zin stond te
tonen en de nuttige zin erachter langs scrolde. [[mh-already-contains-it]], derde keer vandaag.

✅ **En de toast kon dit al aan.** `MidnightToast` groeit sinds 26 aug mee met zijn tekst, met als
reden in het commentaar: *"any toast that wanted to tell the player what to DO could not say it on
the card"*. Precies dit geval, gebouwd en nooit hiervoor gebruikt.

⚠️ **De chatregel blijft, en dat is geen compromis.** Die won op 19 aug een echt argument: de hint
stond eerst op het **label van onze pijl**, en dat label wordt helemaal niet getekend voor iedereen
met TomTom — de meeste testers. Chat kan geen enkele addon je afnemen.
🔴 Maar CLAUDE.md scherpte het op 3 sep aan: **chat is een verslag, geen antwoord ter plekke.**
*"Open de kist"* is geen verslag van iets dat je gemist hebt — het is het volgende wat je moet doen.
Dus **allebei**, niet in plaats van.

📌 Dit geldt meteen ook voor `ARROW_TARGET_ROAMS` (Coin-Eye Skully zwemt). Zelfde soort zin, zelfde
plek, zonder extra werk — de hint komt uit één functie.

### 🔴 En het testgereedschap kon precies dít geval niet testen

Rob wilde het meteen controleren en had Farthik **net gedood**. Rares zijn weekly, dus het middel dat
bestaat om niet op een spawn te hoeven wachten (`/mh raretest`) liep vast op precies dat wachten:
het vuurde altijd `zone.rares[1]` — de eerste rare van je zone, niet te kiezen — en met `onRoute`
leeg, dus met de ándere bodytekst.

✅ **`/mh raretest <naam>`** kiest nu de rare op naam en vuurt zijn **aankomst**-kaart. Kaal
`/mh raretest` is onveranderd. De chatregel erbij noemt wélke hint hij gebruikte, of *"none for this
rare"* — zodat "geen tweede regel" te onderscheiden is van "deze rare hoort er geen te hebben".

⚠️ **Door dezelfde deur als het spel:** het roept `FireRareAlert` aan, dezelfde functie als de live
scan, zonder test-tak. Een test die de afkorting neemt, slaagt juist op de build waar die afkorting
de bug is (CLAUDE.md, Spec 30).
📌 **De bredere les:** een diagnose die de *normale* uitkomst kan tonen maar het *bijzondere* geval
niet, is precies de helft van een diagnose — en het bijzondere geval is altijd waarom je hem bouwde.
## 🔴 9 sep — de weekly-vinkjes rusten op bewijs dat niets waard is (OPEN)

Rob, na de This Week-test: *"maar ik heb behalve een proff quest nog helemaal niets gedaan vandaag op
geen enkele character."* Het scherm zei tegelijk **"Resets in 6d 16h"** (dus de reset was ~6 uur
eerder) én **acht groene vinkjes "done this week"**. Die twee kunnen niet samen waar zijn.

**GEMETEN met `/mh weeklies`:**

| pool | uitkomst |
|---|---|
| **Liadrin, 13 ID's** | **13× `completed`** |
| Void Assault, 2 | 1× `-`, 1× `in your log` |
| Showdown, 5 | 4× `-`, 1× `completed` |

📌 `GiverState` geeft *"done"* zodra **één** ID uit de pool op completed staat. Bij Liadrin staan ze
**allemaal** op completed, en dat kan niet van deze week zijn. **Haar vinkje kan dus nooit iets
anders zeggen dan "done", wat je ook doet.**

⚠️ **En 12 van de 13 geven "no title from the game"** — maar dat verklaart het niet: 93890
*"Midnight: Abundance"* heeft wél een titel én staat op completed, en de Showdown-pool heeft ID's
zónder titel die gewoon `-` teruggeven. De Void- en Showdown-pools gedragen zich normaal, dus het is
geen kapotte API. **De oorzaak is niet vastgesteld. Niets gerepareerd.**

### 🔴 En een correctie op mezelf, binnen één beurt

Ik schreef *"die vinkjes betekenen niets"*. Rob liep naar Liadrin: **ze bood deze week niets aan.**
Dus de **uitkomst** klopte. Wat niet deugt is het **bewijs** — dertien permanent-voltooide vlaggen
kunnen die conclusie niet dragen, ook niet als hij toevallig juist is. ⚠️ *Toevallig gelijk hebben
leest van buiten precies hetzelfde als het weten*, en dat is precies waarom dit een bug blijft.

### ✅ GEBOUWD 9 sep — de addon schrijft nu op wat een giver écht aanbood

`GOSSIP_SHOW` erbij op de bestaande learn-frame; `ObserveGossipOffer` leest
`C_GossipInfo.GetAvailableQuests()` en zet **alleen het aantal** in
`MidnightHelperDB.giverLearn.offers` met een tijdstempel.

⚠️ **ALLEEN AANTALLEN, NOOIT TITELS.** Een questnaam van een NPC kan in 12.x een secret value
zijn; dit heeft aan "hoeveel" genoeg, dus het raakt de strings niet aan. **De goedkoopste guard is
er geen nodig hebben.**

🔴 **En het gebruik is ASYMMETRISCH, expres.** Stond je sinds de reset voor die giver én zei het spel
dat er quests waren, dan is dat beslissend en krijgen de vlaggen geen stem → `pickup`. Maar **nul
gezien vlagt nooit iets af als "done"**: de aanbieding kan achter iets zitten wat wij niet zien, en
een onterechte "done" **verbergt werk** terwijl een onterechte "pickup" alleen een loopje kost. Deze
addon heeft vandaag al een weekly toegevoegd die stilletjes ontbrak (Trailing Xal'atath, een Spark) —
de fout die iets verstopt is de dure.

📌 **Drie toestanden in `/mh weeklies`, niet twee:** *"deze week gezien (n)"*, *"gezien vóór de
reset"*, en *"nooit voor gestaan"*. Die middelste is precies wat een boolean zou vernietigen — en de
derde is [[silence-is-not-absence]]: een niet-bezochte giver ziet er van binnenuit identiek uit als
een lege.

⚠️ **Wat dit NIET oplost:** waaróm alle dertien Liadrin-vlaggen op completed staan. Dat blijft open.
Dit maakt de vlaggen alleen overrulebaar door iets wat je zelf gezien hebt.

### 💡 De redenering erachter: *"kunnen we dat uitzoeken, op dat moment?"*

Ja. In plaats van "done" **afleiden** uit questvlaggen, kun je het de client **vragen** op het moment
dat je voor de NPC staat: `C_GossipInfo.GetAvailableQuests()` zegt letterlijk welke quests die NPC nú
voor je heeft.

✅ **En de helft staat er al.** `GOSSIP_SHOW` is al geregistreerd in drie modules
(`DundunShrine`, `DelveCuriosAdvisor`, `EventSniffer`), en `ResetRoutine` leert nú al welke quest bij
welke giver hoort via `QUEST_DETAIL` → `QUEST_ACCEPTED` (`LearnGiverQuest`). Wat ontbreekt is één
stap: bij `GOSSIP_SHOW` op een bekende giver opschrijven **hoeveel hij aanbood en wanneer**.

Dan kan de regel iets zeggen wat waar is — *"Liadrin had niets voor je toen je er 2 uur geleden
stond"* — in plaats van een gok die er als een feit uitziet. 📌 Dat is dezelfde beweging als
[[verify-against-the-client]]: vraag het spel in plaats van het af te leiden.

⚠️ Bij het bouwen: quest-namen en NPC-GUID's kunnen in 12.x **secret** zijn. `ResetRoutine` guardt
dat al op twee plekken (`NpcIDFromGUID`, `GiverKeyByName`); een nieuwe lezing moet dat ook doen.
## 🔴 9 sep — "You're all caught up this week. Nice." bóven "8 of 13". Op één scherm.

Robs screenshot van de Vereesa-test liet iets zien dat groter was dan wat er getest werd. De kop zei
dat zijn week af was; de regel er direct onder zei **8 van 13**; daaronder stonden **vijf genummerde
open dingen**, waaronder de Vereesa-regel die we net hadden toegevoegd.

📌 **GEMETEN oorzaak — een ontbrekende toets, geen fout getal.** `ns.GetNextWeeklyAction` wijst alleen
een kop-stap aan die `open` is, en `open` betekent *"er is ergens iets op te halen"*. Robs vijf
resterende weeklies zaten **al in zijn questlog**, dus niets stond open, er kwam geen kop-stap uit, en
de keten viel door naar de felicitatie **zonder ooit te vragen of de week af wás**. De functie gaf de
hele tijd `done=8, total=13` terug — die tak keek er alleen nooit naar.

⚠️ **En de tak erbóven had deze vorm al gevonden.** Er staat sinds 3 sep een rode aantekening bij dat
*"all done" een leugen zou zijn* voor een levelend personage wiens stops buiten bereik liggen. Dat gat
is toen gedicht voor **dat** geval. Dezelfde doorval had een **tweede deur** — alles opgepakt, niets
ingeleverd — en die bleef open. 📌 **Een guard die geschreven is voor het geval dat je tegenkwam, is
het herlezen waard zodra er een nieuwe route naartoe opduikt.**

✅ **Gerepareerd:** de felicitatie staat nu achter `done >= total`. Is er niets op te halen maar is de
week niet af, dan zegt hij dat: *"Nothing left to pick up — but %d weekly things are still unfinished.
They are in the list below."* Geen route, want er is werkelijk nergens heen te lopen. Zeven talen,
linter 0 hard.

✅ **En de Vereesa-regel zelf werkte precies zoals voorspeld:** *"3. Weekly (Vereesa Windrunner):
picked up — finish and turn it in."* Niet *"pick it up next to the vault"* — dat was de Liadrin-bug.
De scope-regel onderaan staat er ook. Beide afgetekend.
## ✅ 9 sep — Spec 35, de kleine stap: elk weekly-scherm zegt nu wat het NIET dekt

Eerst gemeten, want de aantallen uit dat onderzoeksdocument wilde ik zelf tellen voordat ik teksten
schrijf die zeggen *"wij dekken X niet"*.

| | |
|---|---|
| **alleen This Week** | Liadrin, Halduron, Aethas, Maella, trainer-weekly, Void Assaults, world boss |
| **alleen Account snapshot** | Delver's Call, Catalyst, coffer keys, shards, Omnium Folio, Manaflux |
| **op allebei** | Showdowns, vault, Ritual Sites |

**Zeven om zeven, drie gedeeld.** Werk er één af en je hebt echt ongeveer de helft van je week gedaan
terwijl het scherm leest als klaar. Dat is precies waar Rob tegenaan liep.

🔴 **En Spec 35 had het op één punt MIS: keystones.** Het document zette ze op de accountlijst.
Gemeten: `AccountWeeklyChecklist.lua` heeft nul treffers op `mythic`, `M+`, `keystone` én `dungeon`.
Ze staan op **geen van beide**. (Wel in de vault-rij, maar dat is een ander scherm.) Zelfde soort
fout als de vier feitelijke twijfels van de beoordelaars: het document was scherp over de vórm en
onbetrouwbaar over de inhoud.

✅ **Gebouwd:** beide lijsten sluiten nu af met een klikbare regel die de inhoud van de ánder noemt.
`HOME_ROUTINE_SCOPE_NOTE` en `ACCOUNT_WEEKLY_SCOPE_NOTE`, zeven talen, linter 0 hard.

⚠️ **Twee ontwerpkeuzes, allebei expres:**
1. **De kop blijft staan.** *"Your week — do these in order"* is waar over de **volgorde** — waarvoor
   hij geschreven is — en staat in zeven pakketten. De onwaarheid zit in de gesuggereerde **omvang**,
   dus die krijgt een zin.
2. **De notities noemen wat er op het ándere scherm staat, en claimen niet dat het paar compleet is.**
   Je keystone staat op geen van beide. Een regel die *"samen hebben we alles"* impliceert, zou
   dezelfde leugen zijn, één niveau hoger.

📌 **Niet gedaan: samenvoegen.** Dat is het juiste eindbeeld, maar de twee schermen zijn het oneens
over scope — dit is accountbreed, dat is het personage waar je op staat — en dat is een eigen klus.

### ✅ Trailing Xal'atath toegevoegd — quest **98172**, GEMETEN

Vereesa Windrunner, 100 Fading Voidwhispers → **Spark of Tides** + Apex Cache + Void Vestige. Een
Spark bepaalt wat je kunt laten craften, dus dit ontbrak niet zomaar.

✅ **Het ID komt uit `/mh questscan xal` tegen Robs eigen questlog terwijl de quest erin stond.**
Niet gedatamined. Dat verschil telt hier zwaarder dan gewoonlijk: op 29 jul bleek een gedatamined
Showdown-ID (96716) fout waar het echte 96713 was, en die waarschuwing staat nog boven Maella.
📌 Geen eigen `pin` — Rob keek: ze staat bij de andere weekly-givers, dus ze deelt de bestaande stop.
⚠️ `minLevel = 90` is een **aanname**, net als bij Liadrin, Aethas en Maella. Fout zijn zet de regel
in *"Later, as you level"* in plaats van hem te verbergen — de veilige richting.

🔴 **En de fallback-regel noemde de givers bij naam.** `HOME_ROUTINE_GIVERS` las *"Weekly quest givers
(Liadrin / Halduron / Aethas)"* — met Vereesa erbij noemde hij er drie van vier. **De vierde naam
toevoegen stelt dezelfde bug alleen uit**, dus de haakjes zijn eruit in alle zeven pakketten. Een
handbijgehouden lijst binnen een vertaalde string is precies de vorm die dit project blijft
repareren; drift gemarkeerd, linter 0 hard.

### Nog open uit Spec 35
- ⛔ **Het Halduron-blok NIET aankomen.** Rob bevestigde `93761` op 10 jun in de client; een eigen
  meting slaat een Wowhead-ID. Eerst `/mh questscan` op de acht.
- Mythic 0 zou sinds 18 aug een **dagelijkse** reset hebben, en Nymrissa (97128) zou de **RAID**-rij
  van de vault vullen in plaats van World. Allebei uit geladen Wowhead-pagina's, **niet** in Robs
  client gemeten.
## ✅ 9 sep — twee metingen uit Robs client, en het web had ongelijk

### ✅ De Catalyst-claim KLOPT — en het internet zei iets anders

Robs tooltip op **Venomblight Manaflux**, woordelijk: *"Slowly accumulates every two weeks. Total
Maximum: 1/8"*, met daaronder **All Characters: 19** en een uitsplitsing —
Purlymixanox 2, Earthshammy 2, Twelveinchy 2, Warlockie 2, en het personage waar hij op stond 1.

🔴 **Verschillende getallen per personage. Dus per character, cap 8. Onze zin was al goed en de
addon-regel *"which alts have stopped gaining"* is zinvol.** Meerdere webgidsen zeiden account-wide;
die zaten ernaast. 📌 Dit is [[verify-against-the-client]] in één screenshot: één tooltip sloeg vier
zoekresultaten.
⚠️ En het bewijst iets over de vorm van mijn eigen twijfel: ik las "bronnen spreken elkaar tegen" als
"wij weten het niet", terwijl de client het gewoon opschrijft. Tegenspraak tussen fansites is een
reden om te méten, geen reden om te twijfelen aan wat we hadden.

### ✅ De Valeera-tip: machinerie bewezen, en beter dan een lege controle

`/mh curiodebug` op zijn eigen personage:

```
treeID= 1223   configID= 57051366   roleNodeID= 110817
subtree name= Tank
=> resolved role: tank
your role= dps   node 110818 taken= true
=> heal tip: silent — your role is dps, not healer
```

📌 **Twee van de drie voorwaarden waren écht waar** — Valeera stáát op Tank en node 110818 ís genomen.
Dat is een veel sterkere controle dan drie keer `nil`: de node-lezing en de rol-lezing zijn allebei
positief bevestigd, en de enige reden voor stilte is de juiste. [[silence-is-not-absence]] met een
positieve controle die er per ongeluk al in zat.
**Rest:** de groene regel zelf op een healer zien. Geen haast.

## 📄 9 sep — de nieuwe omschrijving is LIVE in de repo

Rob: *"waar vind ik de nieuwe description precies die we nu gaan gebruiken?"* Antwoord: op de
gewone plek. Het concept is gepromoveerd naar **`CURSEFORGE_DESCRIPTION.md`** (repo-root, de
canonieke plek) en `docs/CURSEFORGE_DESCRIPTION_DRAFT.md` is weg — twee bestanden met bijna dezelfde
inhoud is precies hoe de dubbele Omnium Folio-artikelen ontstonden.

**5244 → 1623 woorden.** Het werkblok met aantekeningen is er door een script afgehaald, niet met de
hand, en datzelfde script weigert te schrijven als er een comment overleeft of als de kop niet meer
klopt. ⚠️ Nog niet op de CF-pagina zelf — dat plakt Rob.
## ✅ 9 sep — Valeera's Blood-Stained Blades, mét de voorwaarde die het onderzoek miste

Uit `docs/RESEARCH_VALEERA_DPS_VIDEO.md`: healing op Valeera versterkt haar schade, 8 seconden, en
het stapelt. Het document zei terecht **ship het zonder getal** — Icy Veins zegt 8%, een
Wowhead-samenvatting 7%, geen enkele bron noemt een maximum, en de video's *"12 stacks = 80%"* rekent
met géén van beide uit (12×8=96, 12×7=84). Dat is geen bron tegen bron, dat is een bron die zichzelf
niet klopt.

### 🔴 Maar de voorgestelde zin was onvoorwaardelijk, en dat is onjuist

📌 **We hadden die spell al zelf gemeten** — `docs/PTR_VALEERA_TREE.md` regel 107, uit onze eigen
client-dump, sterker dan Wowhead en Icy Veins samen:

```
node 110818    [0/1]
    Blood-Stained Blades    entry 137781   spell 1251122
```

⚠️ **`[0/1]` betekent: het is een KEUZE in haar boom, geen vaste eigenschap.** Het onderzoek stelde
voor te schrijven *"blijf haar healen, elke heal maakt haar harder slaan"* — voor iedereen die die
node niet genomen heeft is dat gewoon onwaar. De dump had het antwoord; het proza eromheen niet.

### Wat er gebouwd is

`ns.ValeeraHealTipState()` in `DelveCuriosAdvisor.lua` geeft **true/false + een reden** terug. Drie
voorwaarden moeten tegelijk gelden: jij bent healer (`GetPlayerRoleKey`), Valeera staat op tank
(`GetCompanionActiveRoleKey`), én node 110818 is genomen (`C_Traits.GetNodeInfo`).

⚠️ **`HasBloodStainedBlades()` is DRIETRAPS**: `nil` betekent **onleesbaar**, niet "nee". Melden dat
iemand een node niet genomen heeft terwijl je de boom niet kon lezen, is een feit verzinnen over zijn
build. Zelfde discipline als `ns.Aura`.

🔴 **En de plek was bijna fout.** `HaveAdvice()` is in **Season 2 false** — er is geen curio-pack —
dus het paneel klapt nu dicht tot één eerlijke regel. Had ik de tip in het normale pad gehangen, dan
had hij **in het seizoen waar we in zitten nooit kunnen verschijnen**, terwijl wij dachten dat we
advies hadden toegevoegd. Hij rendert daarom in **beide** takken, en geeft dat ingeklapte paneel
meteen weer iets waars te zeggen.

📌 De reden staat in `/mh curiodebug`, want zwijgen is hier de normale uitkomst en correct zwijgen is
van buiten niet te onderscheiden van kapot.

### Bewust NIET overgenomen uit dat document

De DPS-getallen uit de video (één speler, één context, geen methode), de curio- en
power-ranglijsten (wij rangschikken bewust niet), *"de DPS-meter meet Ula'tek's Gift verkeerd"* (de
spreker zegt zelf dat hij het niet zeker weet), en de Resto-Shaman/Skyfury-theorie (hij noemt het
veertien minuten lang "windfury" en corrigeert pas op 15:12).

📌 **Bijvangst, geen opdracht:** rolkoppeling — welke rol je háár geeft tegenover die van jezelf — is
een echt gat in ons advies en past bij wat we doen (uitleggen) in plaats van wat we weigeren
(ranglijstjes).
## 📝 9 sep — de CF-omschrijving herschreven van 5244 naar 1592 woorden (CONCEPT, niet live)

Rob: *"Als ik het als onbekende zou kijken is dat een mega lange lijst."* Vier beoordelaars gevraagd
— een eerste-keer-addongebruiker, een terugkerende speler, een winkelpagina-specialist en een
sceptische 25-addon-gebruiker. **Concept staat in `docs/CURSEFORGE_DESCRIPTION_DRAFT.md`; het live
bestand is niet aangeraakt.**

📌 **GEMETEN, en het is één getal:** `### Highlights` besloeg **3740 woorden = 71% van de pagina**,
met 20 vetgedrukte labels en **nul kopjes** — dus voor een scannende lezer had die sectie geen vorm.
Daarnaast ~400 woorden **letterlijke** herhaling: 40 verschillende woordgroepen van 8+ woorden stonden
er tweemaal (`Multicraft` regel 15 én 128, `Take me there` regel 16 én 61).

| | live | concept |
|---|---|---|
| woorden | 5244 | **1592** (−70%) |
| leestijd | ~24 min | **~7 min** |
| kopjes | 10 | 13 |

### 🔴 De belangrijkste vondst was niet de lengte

Twee beoordelaars vonden **onafhankelijk** hetzelfde: onze gracht is niet "wij leggen uit" — dat
claimt elke gids — maar dat we **zeggen wanneer we iets niet weten**. *"Zygor zegt nooit 'ik weet het
niet'."* Dat principe stond nergens als kop; eerste voorkomen was **woord 1056**, als bijzin over een
delve-consumable. Het heeft nu een eigen sectie: **"What it will not tell you."**

### 🔴 En drie claims die onze eigen never-lie-regel hadden moeten vangen

Gemeten in het live bestand, alle drie weg in het concept: *"the two **cannot** disagree"* (r21),
*"(**no wrong or missing** spell IDs)"* (r78), *"**Own, verified** data across every class"* (r85).
Plus *"guessing convincingly"* dat er **twee keer** stond (r23 en r53) — *"je eerlijkheidsprincipe
twee keer in dezelfde woorden zeggen leest als protesteren"*.
📌 De linter faalt op een verzonnen spell-ID en de winkelpagina claimde ondertussen perfectie over 40
specs. **De regel stopte bij de `.lua`-bestanden.**

### ⚠️ Wat NIET geschrapt is, en waarom dat expres is

Alle vier prezen dezelfde dingen: de eerste 350 woorden (*"het beste addon-pitch dat ik dit jaar
gelezen heb"*), 🌐 *"You can read a lot of it before installing anything"* (*"Niemand doet dit"*), de
account-wide-keybinds-zin, en de kleurtje-najagen-zin. Allemaal ongewijzigd overgenomen.

### ✅ De vijf feiten zijn afgehandeld — en de beoordelaars hadden vier keer ongelijk

📌 **Dit is het punt van de hele exercitie:** vier experts leverden scherpe structuurkritiek die
klopte, én een reeks feitelijke twijfels waarvan de meeste onjuist waren. Structuur is hun vak,
onze spelinhoud niet. **Een vermoeden van een beoordelaar is een kandidaat, geen meting.**

| # | claim | uitkomst |
|---|---|---|
| 1 | "Champion 4/6" zou 4/8 moeten zijn | ❌ **beoordelaar fout** — Rob: 6 rangen. Ongewijzigd |
| 2 | "top-tier crests solo" verdacht | ❌ **beoordelaar fout** — Rob bevestigt. **Terug in het concept** |
| 3 | 14 delves / 17 raidbossen rijmen niet | ❌ **beoordelaar fout** — alle drie exact gemeten |
| 4 | "52 bosses" klopt niet | ✅ **beoordelaar goed**, maar anders dan gedacht |
| 5 | Catalyst "per character, cap 8" | ⚠️ **onopgelost, en het raakt code** |

**Punt 3 gemeten in onze eigen data:** `DelveTipsData` heeft precies **14** `rosterName`-regels
(Venomfall Deeps inbegrepen); `RaidCoachData` heeft 4 raidnamen en **17** `encounterID`s, waarvan de
laatste **8** onder The Venomous Abyss vallen. De beoordelaar nam aan dat de drie Season 1-raids elk
3 bossen hadden; het zijn er 1, 6 en 2.

**Punt 4:** onze data heeft **57 dungeon-encounters over 16 dungeons + 17 raid = 74**, niet 52. Maar
het zoekgetal is kleiner, want `NavSearch` indexeert alleen bossen waar we stappen voor schreven
(`GetDungeonBossTips`) — een runtime-lookup die geen statische telling kan vaststellen. 📌 Dus het
getal is **niet verifieerbaar én het verrot** bij elke nieuwe tip. Niet opgenomen in het concept:
**een winkelpagina hoort geen getal te dragen dat bederft.**

### 🔴 Punt 5 is geen zin maar GEDRAG — openstaand

Gezocht op het web: de **cap van 8** wordt door meerdere gidsen bevestigd. **"Per character" is
betwist** — sommige bronnen zeggen account-wide. Warcraft Wiki dekt Midnight niet, maar noteert dat
Dragonflight S1 *"account-wide"* was maar *"spent on a per-character basis"*. Dat verklaart de
tegenspraak én zou onze formulering half onwaar maken.

⚠️ **En dit staat niet alleen op de pagina.** De addon zelf *"names which alts have stopped
gaining"* — dat is betekenisloos als het opbouwen account-breed is. **Meting voor Rob: vergelijk de
charge-teller op twee characters.** Verschillen ze → per character. Zijn ze gelijk → account-wide, en
dan is er een feature fout, niet alleen een zin.

### De oorspronkelijke vijf punten (verslag)

Bewust **niet** stilzwijgend aangepast — een vermoeden van een beoordelaar is een kandidaat, geen
meting. (Bewijs dat dat nodig is: de tiende twijfel van de power-user was dat de Knowledge
Points-link kapot was omdat hij naar de site-root wijst. **Nagemeten: `site/index.html` ÍS de
KP-pagina.** Vals alarm.)

1. **"Champion 4/6"** in de openingszin — heeft die track niet **8** rangen? Ongewijzigd gelaten: het
   is de beste zin van de pagina en een vermoeden is geen reden om hem aan te raken.
2. **"top-tier crests are earnable solo"** — hoge consequentie als het één tier ernaast zit.
   **Weggelaten uit het concept**, niet ontkend: niet beweren tot het gemeten is.
3. **Catalyst "charges cap at 8, per character"** — Blizzard heeft dat meer dan eens veranderd. De
   *omkering* (secondaries blijven behouden) staat er wel in; twee beoordelaars noemden dat de
   sterkste zin voor een terugkerende speler.
4. **De boss- en delve-tellingen** (17 bosses / 52 bosses / 14 delves) rijmen niet zichtbaar.
5. ✅ **Al opgelost in het concept:** de commandoregel `/mh lang de` suggereerde dat een Duitser op
   een Engelse client Duits kan kiezen. Dat kan niet — packs zijn client-gated
   ([[locale-packs-gated-by-client]], gemeten 18 aug). De *tabel* klopte; die ene regel niet.
## 📦 9 sep — 3.10.0 IS GETAGD. Rob zei "go".

`.toc` op 3.10.0, `CHANGELOG_3100_1..7` in enUS (Engels, zoals altijd), `Modules/Changelog.lua`
bijgewerkt, `CHANGELOG.md` uitgeschreven. Linter 0 hard, Lua-syntax schoon over 253 bestanden.

🔴 **En Robs vraag "(en geen description??)" legde een echt gat bloot.** `CURSEFORGE_DESCRIPTION.md`
draagt een tabel met **elk** slash-commando, en de drie die deze release toevoegt stonden er niet in:
`/mh pet`, `/mh souls`, `/mh profguide`. ⚠️ Dit staat op **geen enkele checklist** — de releaselijst
noemt de `.toc`, het changelogvenster, de notities en `CHANGELOG.md`, maar de omschrijving alleen als
*"Rob plakt hem"*. Een nieuw commando bereikt de speler dus wél via de changelog van deze week en
daarna nooit meer via de pagina waar iemand het addon uitkiest.
📌 **Voorstel na de release:** een lintregel die `ns.MH_COMMANDS` tegen die tabel houdt. Dezelfde
vorm als check 10 (geroute maar niet-gelijste commando's), één bestand verderop.

### 💤 Nog steeds open uit Spec 31 B10: de KOP van de omschrijving

De concepttekst voor de bovenkant ligt klaar in de spec, maar er zit één geschrapte clausule in die
Rob expliciet moet goedkeuren. **Niet aangeraakt** — de commandotabel is een feitelijke aanvulling,
de kop is een redactionele keuze en die is niet van mij.

---

## 📦 9 sep — release 3.10.0: notities geschreven (dit blok bleef staan als verslag)

**79 commits sinds v3.9.0.** `docs/CURSEFORGE_3.10.0.md` en `RELEASE_NOTES.md` staan er, byte-voor-byte
identiek gecontroleerd (6611 bytes, 125 regels). ⚠️ **Groter dan elke eerdere release** — 3.7.3 was
82 regels / 4709 tekens en ging schoon door. De lengteregel is dood en twee keer weerlegd; ging het
tóch mis, dan is dat *nieuwe* informatie over de packager en niet een reden om de regel terug te
zetten. Handmatig plakken kost twee minuten en staat in het draaiboek.

**Nog NIET gedaan, bewust — dat wacht op "go":** `.toc`-versie, `Modules/Changelog.lua` +
`CHANGELOG_3100_*`, `CHANGELOG.md`, en de tag. Een 3.10.0-regel in het in-game changelogvenster
terwijl de `.toc` 3.9.0 zegt, toont een versie die niet bestaat.

### 💡 Robs voorstel: vertel in de changelog ook waar we mee bezig zijn

**Aanbevolen, en er staat een concept in.** De CF-notities eindigen nu op *"What we are working on
next"* met vier punten, expliciet zónder datums en zónder belofte. 📌 Waarom dáár en niet in het
in-game changelogvenster: dat venster is een **verslag** van wat er gebeurd is, per versie, en het is
bewust Engelstalig geschiedschrijving. Wat er komt is geen geschiedenis.
⚠️ Regel bij dit blok: alleen dingen die écht op de bank liggen. Een lijst die belooft is een lijst
waar iemand je aan houdt.

### 💡 En Robs tweede idee, met een meting erbij: "welk personage heeft dat beroep wél?"

Uit de test van vandaag: hij zocht op `inscription` op een character zonder Inscription, kreeg
terecht de rode regel, en vroeg *"is het een idee om na de release te kijken of we kunnen zeggen
welke char in onze lijst hem wel heeft??"*

✅ **GEMETEN dat de data er al is:** `AltOverview.lua:439-440` schrijft per personage
`professions` én `professionsFull` weg. De rode regel kan er dus een tweede zin bij krijgen —
*"Purlymixanox heeft dit wel"* — zonder één nieuwe meting. [[mh-already-contains-it]], deze keer in
de goede richting. Na de release.
## ✅ 9 sep — de Codex-sprong is af, en de vierde ronde van dezelfde bug is gevonden

**GEMETEN door Rob:** zoeken op `mephitic` landt nu bovenaan het juiste artikel. De sprong wordt een
halve seconde herhaald terwijl de pagina nog groeit; de eerste versie sprong één keer, op hoogtes die
nog te klein waren, en kwam **te kort** — de kop stond onderaan het venster.

### 🔴 En toen wees zijn tweede screenshot een vierde plek aan

Rob zocht op **`inscription`**, koos de bovenste optie, en kreeg de cursus op **hoofdstuk 4,
"Quality"**. Het woord Inscription stond nergens op het scherm.

📌 **GEMETEN oorzaak, en er valt niets te gokken.** `SelectedKey` in `ProfessionCourseWindow.lua`
zoekt het gevraagde hoofdstuk in de lijst die `MH_GetCourseChapters` teruggeeft — en die is
**gefilterd op de beroepen die dit personage heeft** (`IsChapterVisible`). Rob heeft geen Inscription
op dit character, dus het hoofdstuk zit niet in die lijst, en de terugval pakt *"het eerste
hoofdstuk dat nog niet afgevinkt is"*. Zijn 1-3 stonden op ✓. Vandaar 4.

⚠️ **De terugval is op zichzelf goed** — de cursus heropenen hoort je terug te zetten waar je gebleven
was, niet op hoofdstuk 1. Wat ontbrak is dat hij *"geen voorkeur"* niet kon onderscheiden van *"ik
vroeg juist om dat hoofdstuk"*.

✅ **Gebouwd:** vraagt iemand om een hoofdstuk dat in de data bestaat maar op dit personage verborgen
is, dan staat er nu bovenaan het leesvenster in rood wélk hoofdstuk je vroeg, dat dit personage dat
beroep niet heeft, en wat je in plaats daarvan ziet. Zeven talen (`PROFCOURSE_CH_HIDDEN_FMT`).

🔴 **En de zoekregel blijft staan, bewust.** Inscription uit de zoekindex halen zou de lezer breken
waar deze addon voor bestaat: iemand die kiest wélk beroep hij neemt, wil dat hoofdstuk lezen
**vóórdat** hij het leert. Het antwoord op *"dit kun je nog niet zien"* is het zéggen, niet de vraag
onstelbaar maken — dezelfde keuze als bij de Silvermoon-pins onder level 80.

📌 **Vier keer nu dezelfde vorm**, en het loont om ze naast elkaar te zetten: het venster opende op
**jouw stap** (beroepsgids), op de **categorie** in plaats van het artikel (Codex), **te kort**
(Codex, tweede ronde), en nu op **een ander hoofdstuk zonder dat te zeggen**. Steeds: het juiste
scherm, de verkeerde plek, en niets dat de lezer vertelt dat er iets anders gebeurde dan hij vroeg.
## 🔴 9 sep — de restlijst uit de research-chat: de blokkade bestaat niet meer

Rob gaf een complete restlijst door met de opdracht *"bepaal of ie gelijk heeft en voer het evt uit"*.
Alles hieronder is **gemeten in de code**, niet uit de lijst overgenomen.

### 🔴 §1 "EERST, WANT HET BLOKKEERT DE REST" is ACHTERHAALD — en dat blokkeerde vier andere punten

De lijst zet de Blessed Hammer-bug bovenaan met een ⛔ erbij: *"Schrijf de linterregel uit §5c NIET
voordat dit is uitgezocht."* **Dat is 7-8 sep allebei al gebeurd.**

| bewering | gemeten |
|---|---|
| komt unclassified terug | ✅ **opgelost** — `KeybindAutoMap.lua:254-282` loopt de drie kandidaten en neemt de eerste die óók de spec-test haalt |
| "misschien dragen we het override-ID" | ❌ **de DATA was goed**, de LOOKUP niet. `204019` mag blijven staan |
| ⛔ linterregel nog niet schrijven | ✅ **staat er al**, `lint_addon.py:1507-1524`, mét de vernauwing die de meting opleverde |

📌 **Waarom dit telt:** één achterhaald punt met een ⛔ eraan hield vier punten tegen die er geen last
van hadden. Een blokkade die zichzelf niet opheft is duurder dan het werk erachter — en de lijst
citeerde `SPEC_32` als bewijs terwijl de code er al voorbij was. Precies de val uit
[[never-assume-always-factcheck]] punt 1: *een aantekening is een claim mét een datum, geen bewijs.*

### ✅ Wél waar, en uitgevoerd

- **Spec 34 — de exclusiviteitsclaim bij Inscription.** GEMETEN: `enUS.lua:1007` zei *"+2 KP every
  week, the only profession with that"*. De +2 is gestaafd, *"the only profession"* door niets. Ook
  *"Unique perk:"* aan het begin doet dezelfde claim — die is dus mee vervangen. Nu: *"so your
  Treatise gives 2 Knowledge instead of the usual 1"*. **Alle zeven talen**, `check_drift --mark`
  erachteraan, linter 0 hard.
- **Spec 31 B6 — half af, klopt.** `DELVE_REWARDS_UNMEASURED` had de vraag al,
  `DELVE_TIP_UNMEASURED` (`enUS.lua:1469`) niet. Toegevoegd in zeven talen: *"Walk it? /mh report
  puts what you met into one paste."*
- **§7, de drie zelfcorrecties, kloppen alle drie.** Wago staat live in de `.toc`, de README zegt 14
  delves, B6 was half.

### ⏸️ Niet gedaan, en waarom

- **Spec 33 (macro's)** — groot, en het is vindbaarheidswerk vlak vóór een release. Na 3.10.0.
- **Spec 35 (weekly-lijst)** — de kleine stap ("elk scherm zegt wat het NIET dekt") is goed en klein,
  maar raakt de lijst waar Rob deze week zijn reset op draait. Eerst de release.
- ⚠️ **Het Haldurun-blok: NIET aankomen.** De lijst waarschuwt zelf al dat `93751` en ons `93761`
  dezelfde naam dragen en dat Rob 93761 op 10 jun in de client bevestigde. Eigen meting slaat een
  Wowhead-ID — zie [[valeera-s2-poisons]]. Eerst `/mh questscan`.

## 🔴 9 sep — Rob vond een dode datum in de Codex, en een artikel dat er twee keer stond

Bij het testen van de zoek-fix: *"wat me wel opvalt is dat er nog bv een oude datum in staat die
allang voorbij is"*.

**GEMETEN, en het is erger dan één datum:** de Weekly-loop-pagina droeg **vier** artikelen over
**twee** systemen.

| artikel | probleem |
|---|---|
| `timeways_127` — *"Turbulent Timeways V (Jun 30 - Aug 11)"* | 🔴 het evenement is op **11 aug** afgelopen, de dag dat 12.1 uitkwam. Vier weken lang stond er in de tegenwoordige tijd dat je vier dungeons per week moest lopen |
| `turbulent_timeways` (categorie world) | tweede exemplaar van hetzelfde dode evenement |
| `folio_127` — *"Omnium Folio & Runes (12.0.7)"* | dubbel |
| `omnium_folio` — *"Omnium Folio (12.0.7)"* | ✅ de blijver: die heeft de vijfwekenketen, de meta en de inhaalregel |

✅ **Drie entries verwijderd uit `MidnightCodexData.lua`.** De locale-keys blijven staan — ongebruikte
keys zijn een SOFT-lintregel en niets meer, terwijl ze in zeven packs weghalen churn is met een echte
kans op schade. Komt Timeways VI, dan ligt de tekst klaar.

🔴 **`docs/CONTENT_WATCH.md` bestaat om te vinden "waar de addon liegt" en heeft dit nooit gezien.**
De wachter leest de **bronnen**; niemand leest onze **eigen plank** tegen de kalender. Een artikel met
een einddatum die voorbij is, is machinaal te vinden. **Openstaand voorstel:** een lintregel die elke
datum in een locale-string tegen vandaag houdt.

⚠️ Beide Folio-titels zeggen nog *"(12.0.7)"* terwijl de client 12.1 draait. Dat is **niet onwaar** —
het systeem kwam in 12.0.7 en bestaat nog — maar het leest verouderd. Of de plank überhaupt
patchnummers moet dragen is Robs keuze; niet aangeraakt.
## ✅ 9 sep — "kan dat op alles?" was de juiste vraag, en het antwoord was twee plekken

Rob, na de mislukte Azeroot-zoekactie: *"ja bouw die zoek-fix maar, en kan dat op alles?"*

📌 **De vorm van de bug:** een zoekresultaat kon alleen een **scherm** openen, nooit de **plek op dat
scherm** die matchte. Oorzaak gemeten in `NavSearch.lua`: het klikpad wiste eerst het zoekvak en riep
daarna `go()` **zonder argument** aan. De getypte term overleefde de klik niet, dus geen enkel doel
kón hem gebruiken.

✅ **Gebouwd — de term reist nu mee:** `r._mhQuery` wordt per rij bewaard (het zoekvak is op het
moment van klikken al leeg), en `go(query)` geeft hem door. De Enter-toets-route (`MHNavSearchTryJump`)
doet hetzelfde.

**Daarna elke ingang in dat bestand langsgelopen in plaats van alleen de kapotte. Twee waren fout:**

| ingang | was | nu |
|---|---|---|
| Beroepsgids | opende op **jouw** stap (`AdvanceToCurrent`) | `MH_OpenProfessionGuide(sl, query)` landt op de stap die de term noemt |
| Codex-**artikel** | opende de **categorie**, scroll terug naar boven | `MH_ScrollCodexToArticle(id)` scrollt naar het artikel zelf |
| Cursus-hoofdstuk | sprong al goed | ongewijzigd |
| Tabs, rares, mounts, treasures | openen het ding zélf | ongewijzigd |

🔴 **De Codex-fout stond al als commentaar in de code:** *"each lands on its category page"*. Dat las
wekenlang als een beschrijving in plaats van als het gebrek dat het was. En de regel die het had
kunnen voorkomen stond óók al geschreven, boven `MH_ScrollProfAcademyToChapter`: *"Landing on the tab
is not the same as finding the answer."* Eén keer toegepast, twee keer niet.

⚠️ Twee ontwerpkeuzes bewust: de beroepsgids krijgt een **parameter, geen modus** (geen enkele
bestaande aanroeper verandert), en `FindStepByText` zoekt in **alle taalvarianten** van een stap —
de index is Engels, een Nederlandse client rendert `.nl`, dus alleen de zichtbare tekst matchen zou
juist voor die speler niets vinden.

## 🔴 9 sep — drie van de vier testpunten af, en twee dingen die ik niet gemeten heb

Rob testte de vier openstaande punten. ✅ Drie goed: `/mh souls` rendert met de nieuwe scope-tekst,
`/mh profguide` opent kaal op Alchemy (stap 8/11 — correct, `DefaultGuideSkillLine()` kiest je eerste
échte beroep), en het zoeklabel leest nu **"Guided mode — Herbalism"**.

### 🔴 Het vierde punt faalt, en het is de derde ronde van dezelfde bug

Rob zocht "azeroot", klikte, en landde op **stap 6 van 9** — precies waar hij 8 sep ook landde.
📌 **GEMETEN oorzaak:** `ns.MH_OpenProfessionGuide` eindigt op `AdvanceToCurrent()`
(`ProfessionGuided.lua:517`), en `f:SetScript("OnShow", ...)` doet het nog een keer. De gids springt
dus altijd naar de stap waar je zélf staat. Robs Herbalism is voorbij skill 30, dus de stap die de
Azeroot-tekst draagt schuift onder hem weg.

🔴 **De vorm is drie keer dezelfde en werd twee keer "opgelost".** Eerst stond het antwoord er niet
(8 sep, ochtend). Toen stond het er maar was het onvindbaar (8 sep, avond — `NavSearch`). Nu is het
vindbaar en brengt de zoekactie je naar de verkeerde bladzijde. **Een zoekresultaat dat het juiste
venster opent en de verkeerde stap toont, is van buiten hetzelfde als geen antwoord** — dezelfde
maatstaf als de rode regel over chat: het antwoord hoort te staan waar je erom vraagt.

⚠️ **En de gids heeft twee taken die botsen.** Als *levelgids* is "spring naar waar je staat" precies
goed; als *opzoekboek* is het fout. Voorstel: `MH_OpenProfessionGuide(skillLine, matchText)` — komt
er een zoekterm mee, dan landt hij op de eerste stap wiens titel of body die term bevat, anders op
`AdvanceToCurrent()` zoals nu. Niet gebouwd.

### 🔴 Twee beweringen van mij die NIET gemeten zijn

Rob las de nieuwe soul-tekst en stelde de juiste vraag: *"zijn die warbound en kan je een keuze
ongedaan maken?"*

1. **"Souls are Warbound" stond sinds 8 sep in `AtalUtekProbe.lua` zonder één bewijs.** Gegrept: het
   woord kwam in geen enkel meetdocument voor. Ik had het afgeleid uit "47 verdiend, 7 in de tas, de
   rest staat op alts" — wat *soulbound per character* net zo goed verklaart.
   ✅ **GEMETEN dezelfde middag, Robs eigen tooltip op item 273000: er staat letterlijk `Warbound`.**
   De claim klopte dus. ⚠️ **Maar hij was een gok toen hij in het spel te lezen stond**, en de lezer
   moest ernaar vragen voordat iemand keek. Gelijk krijgen is niet hetzelfde als gelijk hebben.
   Regel staat er weer, nu mét de bron erbij in het commentaar.
2. **Of je een ontgrendelde power ongedaan kunt maken is nog steeds NIET onderzocht.** We weten dat
   het −8 souls kost (2× gemeten, 8 sep); over teruggeven staat nergens iets. De Codex is een
   trait-boom, dus `C_Traits` kent er in principe een antwoord op (`canRefundRank` per node), maar
   een **Reset**-knop in het venster is een hardere meting dan een API-veld. **Openstaand.**

📌 De regel: een zin die in het spel te lezen is, is een claim die we onderbouwd moeten hebben.
[[never-assume-always-factcheck]]

### 🔴 En de tooltip gaf iets wat we niet vroegen: **Er'inye** — waar ik het daarna volledig fout las

Blizzards eigen flavour text op item 273000: *"Corrosive Souls can be used at the Altar of Corrosion
**or given to Er'inye in exchange for Corrosive Coins**."*

🔴 **HIER STOND: "`Er'inye` komt in deze hele repo nul keer voor." DAT WAS ONWAAR, en Rob zag het
binnen een uur op zijn eigen scherm staan.** Gemeten met een script mét positieve controle: **18
vermeldingen in 5 bestanden**, waaronder een compleet Codex-blok in **alle zeven talen** met
waypoint (`{WAY:2509:51.10:62.76}`), de Corrode Spirit-aankoop, en de *Skull of Er'inye* als
handelaar met drie pagina's mounts en pets van 500 tot 25.000 coin.

⚠️ **DE OORZAAK IS ERGER DAN EEN VERKEERD ZOEKPATROON: het gereedschap zéi dat het afkapte.** Mijn
grep eindigde op `[Showing results with pagination = limit: 25]`, en alle 25 zichtbare regels waren
`Altar of Corrosion`-treffers. Ik las "staat niet in de 25 die ik zie" als "staat niet in de repo".
📌 Dit is [[silence-is-not-absence]] met een nieuwe vermomming: niet een leeg resultaat, maar een
**afgekapt** resultaat. Een leeg resultaat maakt je nog achterdochtig; een vol resultaat waarvan de
staart ontbreekt voelt als bewijs. **Regel: een uitvoer met een paginering-regel eronder is geen
meting.** Herhaal hem zonder limiet, of tel in een script.

✅ **Wat er ná de meting nog van over is, en dat is smal:** we beschrijven waar coins **heen** gaan,
maar nergens dat je souls **in** coins kunt omzetten. Gescand op zinnen met allebei: 12 treffers, en
de enige inhoudelijke is *"coin has no cap, while Corrosive Souls are rationed. Farm coin freely; do
not plan an evening around souls."* 📌 Dát maakt de omruil juist interessant: souls zijn de schaarse
kant, dus souls→coins is een val. Eén zin waard in het bestaande blok, geen nieuw artikel.

### 🆕 Nieuwe weekly gemeten op Robs scherm: **Trailing Xal'atath**

Vereesa Windrunner in Silvermoon. *Collect 100 Fading Voidwhispers* (uit dungeons, delves, treasures
en "other dangerous creatures"), beloning **Spark of Tides** + Apex Cache + Void Vestige.

🔴 **`Voidwhisper` komt in geen enkele module en in geen enkel taalbestand voor** — alleen in
`CONTENT_WATCH.md`, als hotfix-regel van 20 aug. Onze weekly-lijst kent hem dus niet. ⚠️ En hij geeft
een **Spark**, wat de crafting-tier van een speler direct raakt.
📌 Dit is precies de klacht uit Spec 35, nu met een naam erbij. Niet gebouwd: eerst de release.

⚠️ **Nog een meetfeit uit dezelfde tooltip:** Rob houdt **44** souls over vier characters plus 16 in
de bank, terwijl ons grootboek 47 verdiend en 19 uitgegeven telt. Dat rijmt niet, en er is niets mis:
het grootboek noteert alleen wat het zág, vanaf 15 aug en alleen op characters die met de addon
ingelogd zijn. **Het is een steekproef, geen boekhouding** — en dat staat nu ook in de uitvoer, zodat
de lezer de tegenspraak niet zelf hoeft te vinden en dan het hele scherm wantrouwt.
## 🔴 9 sep — CurseForge wordt door niets bewaakt, en de browser kan er wél bij

Rob: *"nog steeds geen nieuwe mensen of nieuwe ideeën op de github, voor we dat over het hoofd
zien??"* Terechte vraag, en hij legt een echt gat bloot — al viel de uitkomst mee.

📌 **GEMETEN wat `gh_inbox` dekt:** open issues, open PR's, de nieuwste issue/PR-reacties en recent
gesloten items. **Niet**: Discussions, stars/forks, en — het belangrijkst — **CurseForge**. In de
hele `tools/`-map komt "curseforge" alleen voor als uitgaande link in `build_site.py`.

🔴 **Dat is dezelfde vorm als de bug van gisteren.** `gh_inbox` bestaat omdat Andy's vijf PR's 17
dagen bleven liggen; die redenering — *"geen enkele wachter dekt mensen"* — is nooit toegepast op de
plek waar de **spelers** zitten. GitHub is waar een ontwikkelaar komt; CF is waar 12,5K downloads
vandaan komen.

### ✅ En de browser komt langs Cloudflare, wat we dachten dat niet kon

`web_fetch_exa` faalt op de comments-pagina (`CRAWL_LIVECRAWL_TIMEOUT`), maar de ingebouwde browser
laadt hem gewoon. **Dat maakt een CF-controle bouwbaar** — tot vandaag stond genoteerd dat de
Cloudflare-check niet omzeild was.

### 🔴 En twee dingen die ik zelf fout had

1. **"Niemand heeft die vier reacties ooit gelezen" — ONWAAR.** Rob heeft ze zelf beantwoord, twee
   keer. Ik leidde dat af uit het ontbreken van een tool: geen wachter ⇒ niemand keek. Dat is
   [[silence-is-not-absence]] toegepast op mensen. **De vier reacties zijn twee maanden oud, gaan
   over de shard-popup en het 3D-bossmodel, zijn in v1.8.5 opgelost, en eindigen met *"i absolutely
   love it. massive help"*.** Niets open.
2. **De eerste fetch las "v3.7.2, 29 aug, 11,1K downloads" en dat was een STALE CACHE.** De browser
   geeft **12,5K downloads en 7 sep** — 3.9.0 staat dus gewoon live. ⚠️ Het teken zat in de dump
   zelf: *"Last Update Aug 29"* náást *"Updated 1 day ago"*. Een pagina die zichzelf tegenspreekt is
   een cache, niet een feit — precies de val uit CLAUDE.md's kop, nu met twee velden in plaats van
   een datum.

**Voorstel, nog niet gebouwd:** een CF-stap in het ochtendrondje die het aantal reacties leest en
meldt wanneer dat verandert. Klein, en het dekt de enige groep gebruikers die we nu structureel niet
zien.
## ✅ 9 sep — releasecontrole: vertalingen gemeten, en één label gerepareerd

Rob vóór de release: *"hebben we alle vertalingen van de nieuwe dingen nu ook goed staan? … en is er
niets meer echt open?"* Beide gemeten in plaats van uit het hoofd beantwoord.

### Vertalingen — 84 van 84

| controle | uitkomst |
|---|---|
| `check_drift` | **0 gedrift** in alle zes de talen |
| nieuwe sleutels × 7 talen | **84 van 84 aanwezig**, geen enkele terugval |
| lint [13] markup / eigennamen | 0 / 0 |
| lint [15] vaste termen toch vertaald | 0 |
| lint HARD | 0 |

🔴 **De eerste versie van die 84-controle gaf een vals alarm en zijn eigen controle ving het.** Vier
`CODEX_*`-sleutels kwamen terug als ontbrekend in **alle zeven** talen, inclusief enUS — voor een
artikel dat Rob de avond ervoor had zien renderen. Oorzaak: `Codex.lua` **wijst** zijn taalblokken
niet toe maar **merget** erin (`merge(ns._mhLocales and ns._mhLocales.enUS, {`), en mijn patroon
zocht alleen naar een toewijzing. Zeven blokken gezien, nul herkend.
📌 Zonder die enUS-regel in de lijst was dit een geloofwaardig "vier vertalingen ontbreken" geworden.
**Zet altijd iets in de meting waarvan je het antwoord al weet.**

⚠️ **Eén ding dat GEEN zeven talen heeft, en dat is de conventie van het bestand:**
`ProfessionGuidedData.lua` draagt `{ en = …, nl = … }` inline — **57 Nederlandse regels, nul Duitse,
Franse of Spaanse**. De Azeroot- en mining-tekst staat dus in twee talen, net als elke andere stap
daar. Geen omissie van gisteren maar de vorm van dat bestand; voor de vijf andere talen valt het
terug op Engels.

### 🔴 En één label was zichtbaar fout

De zoekingang van gisteren zei *"Course (101) — Herbalism"* voor iets dat de **adviseur** is en niet
de cursus. Nu `PGUIDE_LAUNCH_BTN` → **"Guided mode — Herbalism"**, gelijk aan de titel van het
venster dat opengaat. Een zoekresultaat dat het verkeerde scherm noemt, in de index die juist moet
voorkomen dat je verkeerd zoekt.

### Wat er open staat: niets onwaars, wel vier dingen ongezien

Volledige lijst in `docs/TESTLIJST.md`: de Azeroot-tekst (Robs screenshot was stap 6, de tekst zit in
stap 1-30), `/mh souls` met de nieuwe scope-tekst, `/mh profguide` als kaal commando, en het
gerepareerde zoeklabel. **Geen van vieren kan iets onwaars beweren** — het is alles wat gebouwd is en
nooit gerenderd.
## ✅ 9 sep, RESETDAG — band B reset wekelijks. De rare-vraag is dicht.

De meting die sinds zondag openstond, gedaan door Rob op de ochtend van de reset (woensdag 9 sep):

```
12 of 14 done on band A,  0 of 14 on band B
```

| band | gedrag | bewijs |
|---|---|---|
| **A** (98344-98355) | **reset NIET** | twaalf staan nog op `done`, uren ná de reset |
| **B** (93673-97122) | **reset WEL** | Destra stond 6 sep op B gevlagd, staat nu leeg |

🎯 **Daarmee klopt alles wat we in 3.9.0 hebben uitgeleverd.** `RARES_TIP_DONE` zegt *"Done this week
on this character (resets Wednesday). Another character of yours can still loot it."* — alle drie de
beweringen staan nu overeind: **per character** (6 sep gemeten), **reset woensdag** (vandaag
gemeten), en **een alt kan hem nog looten** (volgt uit per-character). **Geen tekstwijziging in zeven
talen nodig.**

📌 **En band A is daarmee ook benoemd:** hij reset niet, dus het is de permanente/account-kant —
precies wat het veld `acct` in `Rares.lua` beweert. Die naam was een aanname en is nu een meting.

### ⚠️ Wat deze run NIET bewijst, en dat is de zonelijst

Het tweede blok toont **0 van N gevlagd** in elke zone — Eversong 0/15, Zul'Aman 0/15, Harandar
0/15, Voidstorm 0/14, Val 0/10, Naigtal 0/10, Coiled Isle 0/14.

🔴 **Dat bewijst vandaag niets.** Een net-gereset week en een lijst met verkeerde quest-ids zien er
op de ochtend van de reset **identiek** uit: allebei nul. Dit is [[silence-is-not-absence]] in zijn
zuiverste vorm, en het scherm vraagt er zelf om (*"Recognise one you killed LAST week?"*) — maar dat
is een vraag aan Robs geheugen, niet aan de client.

**Om dit te sluiten is een meting op een ánder moment nodig:** één `/mh rarequests` later deze week,
nadat hij in zo'n zone een rare heeft gedood. Springt er dan iets op `done`, dan werken die ids en
resetten ze; blijft alles nul, dan zijn de ids fout en heeft die tab nooit iets gemeten.
## ✅ 8 sep (avond) — "waar pluk ik Azeroot?" en het antwoord is beter dan een route

Robs brainfart: *"ik wil mijn alchemy levelen en ik moet bv Azeroot hebben, maar ik heb geen idee
waar die het beste te plukken is."*

📌 **Eerst gekeken wat er al is.** `ProfessionGuidedData.lua` noemde Azeroot al — als één van de vier
basiskruiden — maar zei alleen *wát*, niet *waar*. En op Robs schijf staat **geen** GatherMate2, geen
Routes, geen node-addon. Mijn aanname dat die niche bezet was klopte hier niet.

### 🔴 En het feit dat we vonden maakt de vraag kleiner in plaats van groter

Zygors Midnight-beroepengids draagt een farm-gids **per materiaal per gebied**, en de titels alleen
al zijn het feit:

| materiaal | gebieden |
|---|---|
| Sanguithorn · Azeroot · Argentleaf · Mana Lily · Tranquility Bloom | **alle vier** |
| Refulgent Copper · Umbral Tin · Brilliant Silver | **alle vier** |
| Void-Tempered Leather | Eversong Woods |
| Void-Tempered Scales | Zul'Aman |

🎯 **Alle vijf kruiden en alle drie ertsen zitten in alle vier de gebieden.** Het kruid bepaalt dus
nooit waar je heen gaat — je wéék doet dat. Dat is een beter antwoord dan welke route ook, en het is
precies wat MH hoort te doen: de vraag terugbrengen tot iets wat je kunt onthouden.

✅ **Gebouwd:** de 1-30-stappen van Herbalism en Mining zeiden *"begin in Eversong Woods"* zónder
reden. Nu leggen ze uit waaróm dat niet uitmaakt. Een bevel is een uitleg geworden.

### ⚠️ Robs grens, en hoe die is toegepast

Rob: *"alleen feiten uit Zygor, geen routes overnemen."* Zo gedaan — de **titels** zijn gebruikt
(*"Azeroot (Eversong Woods)"* = waar het groeit), dezelfde soort gebruik als bij quest-ID's. **Geen
waypoint, geen coördinaat en geen zin van hen is overgenomen.**

🔴 **En het bewijst GROEIT-IN, niet DICHTST-IN.** Vier gidsen per kruid zegt dat het in vier gebieden
te vinden is; het zegt niets over opbrengst per uur. Die zin mag niet uitgroeien tot een claim over
efficiëntie — dat zou gemeten moeten worden, en dát is het grootboek-idee (optie C), niet dit.

### ⚠️ Skinning is de uitzondering, en het bewijs is er dunner

Leer en schubben verschillen wél per gebied. Maar Zygor heeft daar **twee** gidsen in totaal tegen
**vier per materiaal** bij kruiden en erts. Eén gids is even goed te rijmen met *"daar zit het"* als
met *"die ene hebben ze geschreven"*, en niets hier kan die twee scheiden. De tekst zegt daarom
**"waar je begint te zoeken"** en niet "de enige plek".

📌 **Nog niet gedaan, bewust:** optie C — meten wat jij oogst en waar, zoals het soul-grootboek. Dat
is het enige dat "welk gebied levert het meest op" ooit echt kan beantwoorden, en het helpt pas
nadat je gefarmd hebt.

### 🔴 En toen vond Rob de échte bug: die adviseur was nergens te vinden

Direct na de reload: *"ehm maar waar? en als ik op azeroot zoek vind ik niks."* **Allebei waar.**

`MH_OpenProfessionGuide` had **één** aanroeper — een knop binnen de Academy. Geen slash-commando,
geen regel in `NavSearch.lua`. De enige weg naar het antwoord was al weten waar het woonde.

🔴 **Dit is exact dezelfde bug als die twintig regels lager in `NavSearch.lua` al is opgelost**, voor
de cursushoofdstukken. Die kop zegt letterlijk dat een beginner zoekt op het woord dat hij *heeft*,
niet op de naam van het scherm — en toen kwam de adviseur binnen met geen van beide. **Een oplossing
die naast het volgende geval staat en er niet op wordt toegepast, is de duurste soort.**

✅ **Drie deuren gemaakt:**
1. **`/mh profguide`** — een eigen commando, ook in `CommandList` zodat hij in `/mh` verschijnt.
2. **Zoekingangen per beroep**, gelezen uit `ns.PROF_GUIDES` in plaats van een handlijst.
3. **De trefwoorden zijn de staptekst zélf.** Een materiaal dat in een stap genoemd wordt is
   vindbaar op het moment dat het geschreven wordt — de enige versie hiervan die niet kan
   verouderen, en verouderde handlijsten zijn precies waarvoor dit bestand steeds gerepareerd wordt.

📌 Zoeken op **"azeroot"** landt nu op de Herbalism-gids. Net als "sanguithorn", "umbral tin" of
welk materiaal we er ooit bij schrijven.

✅ **BEVESTIGD 8 sep, 23:0x.** Rob typte `azer` en kreeg *"Course (101) — Herbalism · inside
Professions"*; de knop opende Guided mode op zijn eigen stap (6 van 9).

⚠️ **MAAR HET LABEL KLOPT NIET, en dat is mijn fout.** Ik hergebruikte `PROFHUB_TAB_COURSE` als
voorvoegsel, dus er staat **"Course (101)"** boven iets dat de **adviseur** is en niet de cursus.
Die twee zijn verschillende schermen en het label wijst naar het verkeerde. Klein, maar het is
precies het soort verwarring dat de zoekindex juist zou moeten wegnemen.
📌 **Te doen:** een eigen labelsleutel voor de guided advisor (7 talen), of het voorvoegsel
weglaten en alleen de beroepsnaam tonen. Niet vanavond — Rob ging slapen, en het is een label en
geen fout antwoord.
## 🔴 8 sep (avond) — het soul-grootboek bestond al, en niemand kon het lezen

Rob: *"ja bouw dat grootboekje maar."* Ik begon te bouwen en stopte na één grep: het staat er al
sinds **15 augustus**, in `AtalUtekProbe.lua:1489-1577`. Het kijkt naar item 273000, schrijft elke
verandering weg met tijd, delta, quest-id, questtitel en de seconden sinds die turn-in, en heeft
zelfs een settle-timer tegen tas-geflikker.

📌 **Weer [[mh-already-contains-it]].** Ik had het bijna een tweede keer gebouwd.

### 🔴 Maar de échte fout is een andere, en die is groter

**Drie weken meten, en `/mh atal` printte alleen hóéveel regels er waren.** De inhoud was uitsluitend
te lezen door iemand met een shell over de SavedVariables — vanavond dus door mij, met een
Python-script. **Een instrument dat alleen werkt voor wie een terminal heeft, is geen diagnose.**

Dat is dezelfde vorm als de Spec 30-regel, maar een slag dieper: die zegt *"bouw je iets dat kan
zwijgen, bouw dan een manier om te zien dát het zweeg"*. Hier zweeg niets — er werd gemeten, keurig,
en de meting was onbereikbaar voor de enige persoon die eraan had.

### ✅ WAT ER AL IN STOND — gemeten in Robs client, niet geciteerd

| bron | opbrengst | waargenomen |
|---|---|---|
| **Lair: Nymrissa Wavecaller** | **+3** | **6×**, elke keer 3 |
| **Purging the Vaults** | **+2** | 1× |
| een power ontgrendelen | **−8** | 2× |

✅ **Intern consistent:** twee keer −8 tegenover een Codex-screenshot met precies twee ontgrendelde
gifts (Ophidian Maw, Viperine Grasp). Het grootboek en het scherm vertellen hetzelfde verhaal.

✅ **En het bevestigt de structuur waar de hele farm-vraag om draait:** meerdere `+3` van de lair
binnen één week. Dat kan alleen als de gegarandeerde bronnen **per karakter** resetten — precies wat
de gidsen beweren, nu gemeten in plaats van overgenomen.

### ✅ Gebouwd: `/mh souls`

Groepeert de regels per bron, toont de spreiding en hoe vaak, en zegt erbij wat het níét weet.

⚠️ **Attributie is een klok, geen bewijs.** Een bron wordt alleen genoemd als de turn-in **binnen een
minuut** vóór de winst lag. `Containment Zone (+2216s)` is 37 minuten later en betekent niets; die
telt als niet-toegewezen. De seconden staan erbij zodat de lezer oordeelt in plaats van de code.

🔴 **En de settle-timer van de recorder lekt — GEMETEN.** Vier regels in het log zijn een min en een
plus van gelijke grootte, één seconde uit elkaar: de tas die heropbouwt. Het commentaar bij die timer
claimt dat dit opgevangen wordt; dat klopt niet altijd. `/mh souls` filtert ze er daarom **zelf** uit
(gelijk en tegengesteld binnen 5 s) **en print hoeveel het er waren** — de fout blijft zo zichtbaar
in plaats van stilletjes opgeruimd te worden.

**Nog uit te zoeken:** waaróm de settle lekt. Twee opnames één seconde uit elkaar zouden door de
3-seconden-timer geblokkeerd moeten worden; van buitenaf is niet te zien waarom dat niet gebeurde.

### 🔴 En binnen tien minuten stond er een val in mijn eigen scherm

Rob draaide `/mh souls` en ik las mijn eigen uitvoer na: 47 verdiend, 19 uitgegeven, netto 28 — maar
bovenaan stond *"you hold 7"*. Eenentwintig zoek. Ik dacht een bug gevonden te hebben.

📌 **Er was geen bug.** `GetItemCount` leest de tas van **dit ene karakter**; het grootboek zit in
`ns.db` en de `.toc` declareert alleen `## SavedVariables`, dus dat is **account-breed**. De 47 en de
19 zijn wat de hele warband verdiende en uitgaf; de 7 is één zak. De andere souls liggen bij zijn
alts. Beide getallen klopten.

🔴 **Maar ze stonden onder elkaar zonder dat erbij stond dat het twee verschillende schalen zijn — en
ik trapte er zelf als eerste in.** Dat is geen theoretisch risico: de eerste lezer van dat scherm
maakte binnen een minuut de verkeerde aftreksom.

✅ **Gerepareerd:** de kop zegt nu *"in this character's bags"* met eronder dat souls Warbound zijn en
dat het grootboek de hele account is, met de expliciete instructie het niet af te trekken. De
regel eronder zegt *"across every character"*.

✅ **En elke nieuwe regel legt vast wélk karakter hem schreef.** Dat is precies het bewijs dat
ontbrak voor de claim waar dit systeem om draait: zes `+3` van de lair zijn alleen bewijs van een
per-karakter-reset als ze van verschillende karakters komen — en dat wist het grootboek niet.
⚠️ Oude regels dragen geen naam en worden **niet** geraden; `/mh souls` telt alleen karakters die
er echt in staan.
## ✅ 8 sep (avond) — GEBOUWD: "Corrosive Codex — welke gift eerst?"

Rob: *"kunnen we ook de mensen vertellen welke ze het beste als eerste kunnen kiezen? … zoek dat
maar uit."* Nieuw artikel `corrosive_powers`, categorie **coiledisle**, sort 15, zeven talen.

### Wat het zoeken opleverde

📌 **In de addons: niets.** Geen van de twaalf namen staat in Plumber, HandyNotes_Midnight of
Zygor. ✅ Met positieve controle op dezelfde scope: `grep "Corrosive"` geeft daar **17 bestanden**,
inclusief Zygors Midnight-gidsen. Het patroon vindt dus wél iets — de nul is een echte nul.

📌 **Online: zeven bronnen, één antwoord** (Icy Veins, Method, Boostmatch, Mythic Store,
ConquestCapped, Phrasemaker, een Wowhead-comment). Allemaal **Ula'tek's Gift** eerst, en allemaal om
dezelfde reden: hij werkt zónder tweede power.

✅ **Half te verifiëren, en dat is meer dan gebruikelijk:** hun beschrijving van Ula'tek's Gift komt
vrijwel woordelijk overeen met de tooltip die Rob op 15 aug uit zijn eigen client haalde
(`CORROSIVE_CODEX_MEASURED.md`). Over díé power liegen ze niet.

### 🔴 Waarom het artikel tóch geen ranglijst is

1. **Ze spreken elkaar tegen op een getal** — zie de correctie hieronder, want mijn eerste versie
   sloeg daarin dóór.
2. **Ula'tek's Gift is al ~30% generfd.** Een tierlijst van augustus is niet vanzelf waar vandaag.
3. **Eén optie als hét antwoord is hier precies de fout** — zie [[one-option-shown-as-the-answer]].

✅ **Dus de kern van het artikel is de GIFKRINGLOOP, niet de volgorde.** De helft van de twaalf wordt
sterker tegen een *Poisoned* doelwit of terwijl je zelf vergiftigd bent; daarom is elk goed duo
*gifbron + gifbeloning*. Dat is structureel en overleeft een tuningpas. Daarna pas de keuze **per
probleem** (schade / groepjes / doodgaan / casters), niet per rangorde.

⚠️ **Eén waarschuwing overgenomen die maar in twee bronnen stond**: `Mephitic Cloud` laat getroffen
**vijanden** genezen wat ze aanvallen — in groepscontent werkt hij tegen je.

📌 **Het artikel zegt zelf welk deel gemeten is en welk deel van gidsen komt.** Dat is de enige
eerlijke vorm als je advies geeft dat je niet volledig kunt verifiëren.

### 🔴 CORRECTIE binnen het uur — ik maakte er valse balans van

Rob vroeg door: *"is er ook niks online te vinden?"* Gericht gezocht op de énige open vraag (het
tweede-slot-getal), en de uitkomst haalt mijn eigen zin onderuit.

| bron | zegt |
|---|---|
| **Wowhead** — quest 97616, item 277506 **én spell 1310218, in een tabel** | **8** |
| Method · WowCarry · ConquestCapped · Icy Veins | **8** |
| Boostmatch | 6 |

**Zes tegen één**, en de zwaarste is Wowheads spell-pagina: *"a 2nd power when you unlock 8 powers,
so after spending 64 Corrosive Souls."* WowCarry voegt een controleerbaar gevolg toe: de
Soul→Coin-wissel bij Er'inye gaat pas bij diezelfde 8 open — één drempel, twee waarneembare
gevolgen.

🔴 **Mijn tekst zei "gidsen zeggen 8, één zegt 6, dus we weten het niet". Dat is geen voorzichtigheid
maar VALSE BALANS** — het presenteert 6-tegen-1 als een muntworp. Dat is de spiegel van
[[one-option-shown-as-the-answer]]: daar wordt één optie hét antwoord, hier wordt een uitschieter
een gelijkwaardige partij.

✅ **Herschreven in alle zeven talen:** zes bronnen zeggen 8, Wowheads spell-pagina zet het in een
tabel, één blog zegt 6 — dus 8 klopt vrijwel zeker, wij hebben het alleen zelf niet gezien, en de
speler weet het op het moment dat zijn tweede slot verschijnt.

📌 **Robs screenshot zegt trouwens waar hij staat:** Ophidian Maw en Viperine Grasp hebben geen
slotje, de andere tien wel. **Twee van de acht**, en 5 souls in bezit. De meting ligt dus nog een
eind weg — maar hij ligt bij hem, niet bij een gids.
## ✅ 8 sep (avond) — Dundun is óók een flamingo

Rob, met screenshot uit een Bountiful delve: een **houten flamingo** — planken, verf, precies het
soort ding dat getimmerd is in plaats van gegroeid.

📌 **Onze tekst was hier al goed geschreven en dat is het aardige.** Hij zei niet "zoek een boom",
maar *"ga af op 'dat heeft iemand gemaakt', niet op één vorm"*, met **twee** gevonden vormen als
bewijs: een nepboom en een neppaal. De flamingo is de **derde**, en die maakt de regel sterker in
plaats van hem te weerleggen.

✅ **Toegevoegd in alle zeven talen**, in `DUNDUN_CHAT_WHAT` én `DUNDUN_PANEL_BODY`. Een derde
voorbeeld dat zó ver van de eerste twee afligt, is precies wat "niet op één vorm" geloofwaardig
maakt — een boom en een paal lijken nog op elkaar, een flamingo niet.

⚠️ **`check_drift` sloeg aan op `DUNDUN_PANEL_BODY` en dat was loos alarm**: hij meet **herkomst**,
dus een gewijzigde enUS-string maakt de zes vertalingen "gedrift" ook als je ze in dezelfde beurt
hebt bijgewerkt — wat hier zo is. `--mark DUNDUN_PANEL_BODY` gezet, en daarna staat de teller weer
op **0 gedrift** in alle zes.
📌 `DUNDUN_CHAT_WHAT` kwam er niet in voor: die sleutel is nieuwer dan de v3.5.0-basis en heeft dus
geen vastgelegde herkomst om vanaf te driften.
## ✅ 8 sep (avond) — keybind-cheatsheet opnieuw gegenereerd

Verplicht na elke `KeybindRoles_*`-wijziging, en die waren er vandaag drie op de Paladin (Holy
Bulwark, Rite of Sanctification, Hand of Reckoning naar `{66,70}`). Beide stappen door de voordeur:
`_probe.py run keybind_sheet/gen_keybinds` en `… /build_outputs`. 39 specs, HTML + XLSX ververst.

De ingebouwde verificatie van de generator toont de Prot-layout meteen, en de drie wijzigingen staan
erin.

⚠️ **De sheet en de client geven Holy Bulwark een ANDERE toets** — de sheet `Ctrl+C`, Robs
`/mhautomap` vanochtend `Shift+C`. **Geen van beide is stuk.** De sheet modelleert het schema met
*alle* entries die voor die spec gelden; de live allocator ziet alleen de spells die dit karakter
écht kent. Minder concurrenten om de overloop-toetsen geeft een andere verdeling.

📌 **AFGELEID, niet gemeten** — dat is de plausibele verklaring, niet een bewezen. Wat er wél
vaststaat en het onthouden waard is: **de cheatsheet is een model van het schema, geen spiegel van
één karakter.** Wie hem naast zijn eigen `/mh binds` legt en verschil ziet, kijkt niet naar een bug.
## 🔁 8 sep (avond) — DBM 12.1.9 doorgelicht: geen bevinding, wél een les over de meting

Robs addon-manager heeft alles bijgewerkt. **Bestandsdatums zijn dan waardeloos** — alles stond op
20:05 — dus in plaats daarvan de versies gelezen van de bronnen die wij citeren:

| bron | nu | notitie |
|---|---|---|
| **DBM-Core** | **12.1.9** | was 12.1.7 in onze aantekeningen |
| ZygorGuidesViewer | 9.6 | ongewijzigd; Zygor versiet gidsdata los van de viewer |
| HandyNotes_Midnight | 155 · JustAC 5.3.7 · Plumber 1.9.5 | — |

### 🔴 De omgekeerde check van [19] is een goed idee en mijn eerste versie deugde niet

Check [19] vraagt *"wordt ONZE id door DBM gedekt"*. De omgekeerde vraag — *"waarschuwt DBM ergens
op terwijl wij zwijgen"* — leverde op 1 sep Bloodletting op, dus die wilde ik hermeten.

Mijn scratch filterde op `rec["strong"]` en meldde **106 ids over 25 bossen**. Maar de positieve
controle (`1301231`, dat we sinds 1 sep dekken) kwam terug als *"strong: none"*.

🔴 **En bijna trok ik daaruit de verkeerde conclusie: "DBM waarschuwt er niet meer op".** Dat is
onwaar. `Zuljan.lua:31` draagt
`mod:AddAuraSoundOption(1301231, true, 1301231, 1, 2, "watchfeet", 8, 0)` — de aura heeft **zichzelf**
als parent, dus DBM geeft wel degelijk een signaal. `tip_audit.classify()` noemt het daarom `warned`,
en dat klopt.

📌 **De aura-logica die ik oversloeg is op 3 sep juist toegevoegd omdat "alleen strong" te grof was.**
Ik heb dus een probleem opnieuw gemaakt dat dit bestand vijf dagen geleden al had opgelost — precies
[[read-the-working-example-whole]], maar dan op onze eigen tooling.

⚠️ **Gevolg: die 106 is GEEN bevindingenlijst.** Elke ability die DBM via een self-aura afhandelt
staat er ten onrechte in. Niet gebruiken.

✅ **Wat wél vaststaat:** de Zul'jan-tip is correct onderbouwd, onze aantekening van 1 sep klopt, en
er is vanavond niets aan de tips te repareren.

📌 **Als iemand de omgekeerde check echt wil bouwen:** hij moet dezelfde aura-afweging maken als
`classify()`, niet alleen `strong` lezen. Dat is een echte klus, geen avondklusje.
## 🔴 8 sep — de Coiled Isle is 90, en dat legde twee fouten in de zone-poort bloot

Rob nam zijn verse level 80 door het portaal: *"alles is daar lvl 90 😛 dus niet verstandig haha."*

### 1. De isle gaf GEEN waarschuwing, terwijl hij daar juist voor gebouwd is

`REGION_MIN_LEVEL[1] = 80` dekt heel Quel'Thalas — Silvermoon, Eversong, Zul'Aman, Quel'Danas **én
de Coiled Isle**. Robs 80 haalt die drempel, dus zweeg de poort. Terwijl de isle op **90** staat.

📌 **De regio-regel is niet fout, hij is eenzijdig.** Hij neemt bewust de láágste van een regio,
zodat we nooit een waarschuwing wegpoetsen (Zul'Amans 82 mag Eversongs 80 niet overrulen). Dat
dekt de ene richting; de Coiled Isle is de spiegel ervan — een zone **tien levels boven** de
ondergrens van zijn eigen regio, en dat kan het model niet zeggen.

✅ **`MAP_MIN_LEVEL` toegevoegd**, per kaart en vóór de regio gecontroleerd. Eén rij:
`[2512] = 90`. ⚠️ Hij mag alleen ooit **verhogen** — een rij die verlaagt zou precies de bug
terugbrengen die de regio-regel voorkomt.

📌 Dit is de sterkste rij in dat bestand: de andere komen uit gidsen, deze uit **Robs eigen ogen in
de client**. En het is de rij die het vaakst geraakt wordt, want wij routeren daar elke week naar
rares.

### 2. En daarbij viel `ns.MidnightEntryLevel = 78` om

Dat getal stond er met als onderbouwing *"waar de intro-questlijn opengaat, uit twee gidsen plus
Robs eigen lezing"*. **Vanochtend gemeten: het is 80.** Op 78 niets, op 79 niets, op 80 komt de
quest vanzelf binnen.

🔴 **Twee gidsen waren het met elkaar eens en hadden allebei ongelijk.** Dat is de val die dit
project blijft tegenkomen: overeenstemming tussen bronnen is geen meting, en een getal dat vaak
herhaald is, is geen getal dat gecontroleerd is.

✅ **Nu 80.** Dat maakt de rode balk **accurater**, niet alleen consistenter: op 79 valt er echt
niets te doen en daar zweeg hij over. Hij komt nu uit op hetzelfde getal als
`REGION_MIN_LEVEL[1]` — niet door twee feiten plat te slaan, maar doordat ze allebei langs een
eigen weg op 80 gemeten zijn.

**Te testen:** route naar een rare op de isle met een character onder de 90 → er hoort nu een
waarschuwing te komen (wél mét route, dat was Robs keuze van 5 sep). En `/mh zonegate` op zo'n
character noemt nu 90 voor de isle in plaats van 80.
## ✅ 8 sep — de Italiaanse profressie-regel: vier afwijkingen, niet één

Ik zou alleen "Lunargenta" repareren, maar had beloofd de regel eerst hélemaal na te lezen. Dat
loonde: `CODEX_PROFRESET_BODY` (itIT) week op **vier** punten af van zijn eigen pack.

| stond er | is nu | waarom |
|---|---|---|
| `Bazaar di Lunargenta` | `Bazaar di Silvermoon` | Spaanse naam in een Italiaanse zin |
| `azzerare Forgiatura` | `azzerare Blacksmithing` | beroepsnaam |
| `lasciare Incantamento intatto` · `un Incantamento azzerato` | `Enchanting` | idem, 2× |
| `punto Conoscenza` · `la Conoscenza spesa` | `Knowledge` | vaste term, blijft in álle packs Engels |

📌 **GEMETEN, niet naar smaak beslist.** `itIT.lua` gebruikt `Blacksmithing/Enchanting/Knowledge`
**28×** en de Italiaanse vormen **0×**; in heel `Codex.lua` was dit de **enige** regel met die
vormen. De regel was dus een uitschieter tegen zijn eigen pack én tegen de rest van het bestand —
dat is wat het een fout maakt in plaats van een stijlkeuze.

✅ **Positieve tegencontrole in dezelfde run:** na afloop `grep "Forgiatura|Incantamento|Conoscenza|
Lunargenta"` → alleen nog **Lunargenta**, op vier regels die allemaal in het **esES**-blok staan,
waar hij hoort. De nul hierboven is dus een echte nul en geen kapot patroon.

⚠️ **Eén ding bewust niet aangeraakt:** *"La pagina Professioni"* verwijst naar ons eigen tabblad,
niet naar een naam van Blizzard. Dat is een andere vraag (vertalen wij onze eigen tabnamen in itIT?)
en die hoort niet in deze reparatie thuis.
## ✅ 8 sep — GEBOUWD: Codex-artikel "Starting the Midnight campaign"

Rob: *"bouw die vier maar in de codex."* Gedaan — `midnight_campaign_start`, categorie **start**,
sort 4, met `searchKeys` zodat hij ook te vinden is op woorden die iemand op level 80 intypt vóór
hij weet hoe dit heet ("skip", "liadrin", "scouting map", "abandon", de vijf zonenamen).

**Wat erin staat, en elke regel is vanochtend in Robs client gemeten:**
1. op 80 komt de quest **vanzelf**; onder 80 kun je al wél reizen maar valt er niets aan te nemen
2. de **Image of Lady Liadrin** staat in **meerdere hoofdsteden** (Dornogal, Stormwind, Orgrimmar)
3. de **skip kost niets** — je komt in Silvermoon uit en krijgt de vervolgquest meteen
4. de **Scouting Map** heeft vijf ingangen, kijken is gratis, en **abandon opent ze weer**

🔴 **Robs correctie zit erin verwerkt.** Ik had "Lady Liadrin, Dornogal" genoteerd; hij meldde dat ze
óók in Stormwind en Orgrimmar staat. Die ene regel zou de tip fout hebben gemaakt voor iedereen die
niet toevallig in Dornogal inlogt.

✅ **GERENDERD EN GECONTROLEERD 8 sep** — Rob opende de Codex na een reload: koppen, kleuren,
opsommingen en regelafbrekingen doen het allemaal. Geen kale sleutels, geen zichtbare markup.

### ✅ Alle zeven talen, en Rob wees de weg naar het antwoord

Ik wilde eerst bij enUS + nlNL stoppen omdat ik de stadsnamen voor pt en it niet had. Rob: *"we
hadden toch de namen al een keer laten checken zodat we zeker weten wat Blizzard gebruikt?"* Ja —
[[wago-tools-gamedata]], zo is de ptBR-Valeera-kwestie beslecht. Ik stelde voor te gokken terwijl de
methode er lag.

⚠️ **wago.tools is vanaf hier NIET bereikbaar.** `WebFetch` geeft **403**, `web_fetch_exa` geeft
`CRAWL_UNEXPECTED_CONTENT_TYPE` op de CSV-endpoints. Nieuw feit voor de volgende keer; de meting van
augustus is dus met ander gereedschap gedaan.

✅ **Maar het antwoord stond in de repo zelf, en het verschilt per taal:**

| taal | Silvermoon | bron |
|---|---|---|
| deDE | **Silbermond** | ons eigen pack, meerdere plaatsen |
| frFR | **Lune-d'Argent** | idem |
| esES | **Lunargenta** | idem |
| ptBR | **Silvermoon** | de gewoonte van het pack — **14×** in `ptBR.lua` |
| itIT | **Silvermoon** | de kop van `itIT.lua` zegt letterlijk dat zonenamen Engels blijven |

📌 **Dat is coherent en niet willekeurig:** de/fr/es/pt zijn echte client-talen, dus daar staat
Blizzards eigen naam op het scherm. Voor Italiaans en Nederlands bestaat geen client, dus ziet die
speler sowieso Engels — dezelfde redenering als de "Kampioen crest" van 28 aug.

🔴 **BIJVANGST — een echte fout in het Italiaanse pack**, apart gerepareerd (zie hieronder).

⚠️ **Eén ding bewust uit alle vijf de vertalingen weggelaten: de opsomming van hoofdsteden.** Onze
packs hebben "Stormwind" nog nooit in een van die talen geschreven, dus dat zou alsnog een gok zijn.
Er staat nu "in meerdere hoofdsteden, dus ook in de jouwe" — even waar en niets verzonnen. De vijf
zonenamen en `Adventuring in Midnight` blijven overal Engels (eigennamen van Blizzard).
## 🔴 8 sep — reizen naar Midnight is NIET op level gesloten, en dat weerlegt onze eigen reden

Rob op TwelveInchy (Ret paladin), level 78: *"ik kon er al heen vanaf lvl 70 ofzo maar kan er nog
niks aannemen of doen."*

✅ **Daarmee is de openstaande vraag van 3 sep beantwoord — en het antwoord valt in tweeën:**

| | |
|---|---|
| **reizen** | **niet gesloten**. GEMETEN op 78; Robs herinnering zegt "vanaf ~70", maar dat is niet precies, dus de harde meting is **≤ 78** |
| **inhoud** | **wél gesloten**. Op 78 valt er niets aan te nemen en niets te doen |

🔴 **De reden onder onze gate is daarmee ONWAAR.** `ns.MidnightFloorMet()` blokkeert routes onder 80,
en die is er gekomen doordat Rob op 3 sep vroeg: *"kan ik nog niet naar dat gebied want ik ben <80,
toch"*. Nee dus — hij kan er wél heen.

📌 **Een gate mag zijn reden overleven en tóch goed zijn**, maar hij mag geen reden blijven aanhalen
die gemeten onwaar is. Dat is precies hoe een verkeerde overtuiging blijft leven — en het is dezelfde
val als [[never-assume-always-factcheck]] punt 1: een aantekening is een claim mét datum, geen bewijs.

⚠️ **Het getal blijft voorlopig 80, met opzet.** We weten nu dat het geen *reis*-grens is. Of het de
juiste *inhouds*-grens is wordt nog gemeten — Rob levelt naar 79 om te zien of er iets eerder
opengaat. Het nu verzetten zou één ongemeten getal door een ander vervangen.

### ✅ 79 gemeten — 80 staat, en nu op de client in plaats van op onszelf

Rob op 79: nog steeds niets. En daarvóór al de hardste bron die we tot nu toe hebben — **het spel
zelf**: bij een verzamelnode in het gebied zegt het *"vanaf level 80"*.

📌 **Dat is het eerste bewijs voor 80 dat niet van ons komt.** Tot vandaag leunde het getal op onze
eigen gidstekst `"Leveling (80-90)"` — een claim gestut door een andere claim van onszelf.

| level | reizen | inhoud |
|---|---|---|
| 78 | ✅ kan | ❌ niets aan te nemen |
| 79 | ✅ kan | ❌ nog steeds niets, spel zegt "vanaf 80" |
| **80** | ✅ kan | ✅ **de Midnight-quest komt automatisch binnen** |

🎯 **Daarmee is de grens van drie kanten dichtgetimmerd**, en niet één ervan is onze eigen tekst:
niets op 78, niets op 79, en op het moment dat 80 valt komt de quest **vanzelf**. Precies wat een
harde inhoudsgrens hoort te doen.

⚠️ **Eén nuance die de 79-meting nodig maakte:** een verzamelnode kan een eigen leveleis dragen, los
van waar het questen begint. De weigering bij de bloemen bewees dus alleen iets over *plukken*. Pas
samen met "op 78 én 79 niets aan te nemen" wordt het een uitspraak over het gebied.

✅ **`MIDNIGHT_FLOOR_LEVEL = 80` blijft dus staan, nu mét een bron die niet van onszelf is.** De
route-blokkade blijft ook — er valt daar echt niets te doen.

✅ **Eén tekst gerepareerd, en het was de Nederlandse.** `SMC_LOCKED_FMT` in `nlNL` eindigde op
*"De kaart blijft staan voor als je er wel kunt komen"* — dat beweert dat je er niet kunt komen, en
dat is nu gemeten onwaar. De zes andere talen zeggen alleen *"gaat open op level %d"* en *"een kaart
voor later"* en hadden deze fout niet.
🔴 **Precies daarom is dit het moeilijkste soort fout om te vinden:** de zin was niet kapot, hij was
*onwaar*, en geen enkele controle kan dat zien. Alleen iemand die het in het spel probeert.

### 🔴 OPEN — wij weten niets van de Midnight-intro

Op 80 komt de quest vanzelf binnen en stuurt je naar **het beeld van de Lady in Dornogal**. Gegrepd
op `Dornogal` en op intro-varianten: **de addon noemt die keten nergens.** Eén treffer in
`Addons/Guide.lua:356`, en dat is een Zygor-lijst, geen uitleg van ons.

📌 **Dat is een echt gat en het zit precies in onze niche.** De markt-aantekening zegt dat MH's
kracht **uitleggen** is, niet tracken — en dit is het allereerste moment van de uitbreiding, voor
een speler die net 80 wordt en niet weet waar hij heen moet. Wij zeggen daar op dit moment niets
over.

⚠️ **Nog niets gebouwd, en de quest-ID is niet gemeten.** `/mh questsnap` staat klaar om dat te
doen zodra iemand die keten loopt.

#### ✅ GEMETEN 8 sep — het gespreksvenster zelf (Robs screenshot, vóór aannemen)

| | |
|---|---|
| NPC | **Image of Lady Liadrin** — 🔴 **staat in MEERDERE hoofdsteden**, niet alleen Dornogal. Rob, 8 sep: *"ook in Stormwind en Orgrimmar"*. Deze regel zei eerst "Dornogal" en zou de tip fout hebben gemaakt voor iedereen die daar niet staat. |
| quest | **"Midnight"** |
| aanleiding | *"Xal'atath and her Devouring Host have attacked the Sunwell on the Isle of Quel'Danas. The Light has called to you for help."* |
| optie 1 | `(Play Movie) What has happened at the Sunwell?` |
| optie 2 | `I have heard this tale before.` → *"Skip the Midnight introduction and travel to the Sanctum of Light."* |

🎯 **ER IS EEN OFFICIËLE SKIP, en dat is precies wat een alt-speler zoekt.** Dit is het soort ding
waar deze addon voor bestaat: het staat er, maar alleen als je het gespreksvenster helemaal leest in
plaats van op de eerste optie te klikken.

✅ **EN DE SKIP KOST NIETS — GEMETEN 8 sep, meteen erna.** Dit was de vraag die ertoe deed: onze hele
weekroutine staat op map 2393 (Silvermoon City), dus als de skip die toegang zou overslaan, gaven wij
een week lang advies dat niet op te volgen is. Rob heeft het direct nagemeten:

| | |
|---|---|
| waar je uitkomt | **Silvermoon City** |
| Silvermoon-pin daarna | ✅ **zet gewoon een route** |
| en er komt meteen | een vervolgquest |

✅ **Vervolgquest: "Adventuring in Midnight"** — *"The Void encroaches on Azeroth from all sides.
Visit the Scouting Map in the Sanctum of Light and choose where you will make your stand."* Doel:
*Review the Scouting Map and choose where to begin the Midnight campaign.* Beloning 3g 9s en 1.812
XP.

🎯 **DAARMEE IS DIT EEN TIP DIE WE MOGEN GEVEN**, en dat was hij een half uur geleden nog niet.
*"Er is een skip"* is de halve waarheid; *"er is een skip, hij kost je niets, en je komt in
Silvermoon uit met een quest die je je startgebied laat kiezen"* is de hele. Het verschil is één
meting die Rob deed in twee minuten.

#### ✅ GEMETEN 8 sep — de Scouting Map biedt VIJF startpunten

Robs screenshot van de kaart. Elk met een eigen questmarkering:

| keuze | waar op de kaart |
|---|---|
| **Arator's Journey** | bij Silvermoon City |
| **Eversong** | onder Silvermoon |
| **Zul'Aman** | zuidoost, de trollruïnes |
| **Voidstorm** | noord, het paarse voidgebied |
| **Harandar** | noordoost, apart eiland |

📌 **De addon kent die vijf gebieden ruim** — 980 treffers over 84 bestanden aan delves, rituals,
rares en tips. Wat hij níét kent is deze **keuze**: `grep "Scouting Map"` geeft alleen de regels die
vandaag in dit bestand zijn geschreven. We hebben de campagne (`CampaignLeadIn.lua`, en
`LVL8090_PATH_1` zegt *"17 chapters"*) maar niets over de vijfsprong waar hij mee begint.

🔴 **EN DE VRAAG DIE BEPAALT OF HIER ADVIES BIJ HOORT, IS NOG NIET GEMETEN: is dit een KEUZE of een
VOLGORDE?**
- Doe je uiteindelijk alle vijf en kies je alleen waar je *begint*, dan is "advies" hier dun — hooguit
  een zin dat het niets vastlegt.
- Is het **exclusief**, dan is dit de eerste onomkeerbare beslissing van de uitbreiding, en dan is het
  precies waar deze addon voor bestaat.

⚠️ **Niet afleiden uit "17 chapters".** Dat wij ergens schrijven dat de campagne 17 hoofdstukken
heeft, suggereert dat je ze allemaal doet — maar dat is onze eigen tekst als bron gebruiken voor een
vraag die hij nooit beantwoord heeft. Zelfde val als de 80 die op `"Leveling (80-90)"` leunde.

#### ✅ GEMETEN — de tooltip, en klikken legt niets vast

Robs hover op **Eversong**:

> **Eversong** — *"Join Arator as he investigates threats to the home of the Blood Elves."*
> *"Click to view the scouting report"*

📌 **Twee dingen, en het tweede is het belangrijkste.** Elke pin draagt een eigen regel uitleg, én
klikken **opent een rapport** in plaats van de keuze te maken. Rondkijken kost dus niets — precies
de zorg die een nieuwe speler bij zo'n scherm heeft.

✅ **Robs oordeel was:** *"ik kan gewoon kiezen waar ik wil beginnen."*
⚠️ Dat stond hier als **AFGELEID**, want de tooltip zegt niets over exclusiviteit — met de meting
erbij geschreven die het hard zou maken.

#### 🔴 EN DIE METING WEERLEGDE HET, binnen het uur

Rob koos **Eversong** en keek meteen: **de andere vier staan niet meer open.**

📌 **Kiezen doet dus wél iets** — anders dan kijken, dat gratis is. De regel *"klikken opent alleen
een rapport"* blijft waar; het is de keuze dáárna die de rest sluit.

🎯 **Dit is de tweede keer vandaag dat het als AFGELEID markeren zich terugbetaalde.** Eerst de
level-80 die op onze eigen gidstekst leunde, nu dit. Beide keren was de bewering plausibel, beide
keren van een expert, en beide keren zou hij als feit in de addon zijn beland. **De markering is
geen wantrouwen maar een schuld die je later kunt innen.**

#### ✅ BEANTWOORD — het is een VOLGORDE, en hij is terug te draaien

Rob, uit eerder spel op een ander karakter (dus **ROBS RAPPORT**, niet in deze sessie gemeten):

- de andere vier **komen terug** — je hoeft Eversong niet af te maken om dat te weten, hij heeft de
  keten eerder gelopen;
- **en abandon je de quest, dan komen ze óók meteen terug.**

📌 **Herkomst eerlijk gemarkeerd**, want vanochtend gleed een herinnering nog ("vanaf lvl 70 ofzo",
bleek 80). Deze is niet gehedged en gaat over gedrag dat hij zelf heeft gezien; volgens
[[trust-robs-domain-expertise]] telt zo'n rapport. Hard te maken zonder kosten is hij niet — de
enige controle is je eigen lopende quest weggooien, en dat is een echte prijs voor een detail.

🎯 **EN HIERMEE KANTELT WAT WE ZOUDEN BOUWEN, van een waarschuwing naar een uitweg.** Er is geen
onomkeerbare fout om voor te waarschuwen. Wat er wél is, en wat nergens op dat scherm staat:

> **Verkeerd gekozen? Abandon de quest en de kaart gaat weer helemaal open.**

⚠️ **Dat is een betere tip dan "pas op".** Een waarschuwing vóór de klik zou hier bangmakerij zijn
geweest voor een keuze die niets kost; een uitweg ná de klik is wat iemand écht zoekt op het moment
dat hij hem nodig heeft. **De vorm van het advies volgde uit de meting, niet andersom** — en tussen
de eerste versie hiervan en deze zit precies één zin van Rob.

🎯 **En dat maakt de bouwvraag klein en concreet.** Wat een speler hier mist is niet "welke moet ik
kiezen" maar "**wat ís dit en kan ik het verkeerd doen**". Daar hebben we nu genoeg voor: vijf
ingangen, kijken kost niets, **kiezen sluit de rest**, en wij weten van alle vijf de gebieden al veel
meer dan Blizzards ene regel — 980 treffers aan delves, rares en rituals liggen er al.

✅ **En het antwoord op "kan ik het verkeerd doen" is: nee.** Kiezen sluit de rest alleen zolang de
quest loopt; abandon en de kaart is weer open. Wat MH hier hoort te zeggen is dus geen waarschuwing
maar een **uitweg** — en die hoort te staan waar iemand hem zoekt: nádat hij gekozen heeft en twijfelt,
niet ervoor.
## ✅ 7 sep — Suffering is gemeten, en de meting vond er een fout bij

Rob logde in op zijn warlock, Voidwalker eruit, twee keer `/mh pet`:

```
autocast aan  →  5. Suffering  autoAllowed=true  autoEnabled=true   spellID=17735
autocast uit  →  5. Suffering  autoAllowed=true  autoEnabled=false  spellID=17735
```

✅ **17735 klopt en de waarde BEWEEGT.** Suffering gaat van kandidaat naar gemeten; de
pet-waarschuwing dekt nu ook warlocks.

🔴 **En de lijst zelf bleek een valse alarmbel te bevatten.** `7812` (Sacrifice) stond in
`PET_TAUNTS` mét als eigen label *"not a taunt but often confused"*. Die tabel is geen woordenlijst
— **elke id erin laat `ShouldWarn` waarschuwen**. Een rij die in zijn eigen tekst zegt dat hij er
niet hoort, is een valse melding die stond te wachten tot iemand Sacrifice op autocast zet. Eruit;
de notitie blijft als commentaar staan.

📌 Gevonden doordat de meting de héle balk print in plaats van alleen het gezochte. Dat was ook de
bedoeling van dat ontwerp, maar dit is de eerste keer dat het zich terugbetaalt.

✅ **BESLOTEN met Robs eigen tooltips, dezelfde avond.** Drie van de vier Voidwalker-abilities
staan op autocast, en "staat standaard aan" is niet hetzelfde als "hoort in deze tabel":

| id | tooltip | oordeel |
|---|---|---|
| 17735 Suffering | *"taunts the target… "*, autocast *"taunts any target who attacks its master"* | ✅ erin |
| 112042 Threatening Presence | *"increasing threat generation"*, autocast *"always keep this effect active"* | ❌ eruit |
| 3716 Consuming Shadows | *"drains health from all nearby enemies"* | ❌ eruit |
| 17767 Shadow Bulwark | *"increases health by 30%"* onder 20% | ❌ eruit |

📌 **Threatening Presence is degene die uitleg verdient**, want hij is echt verleidelijk: meer
pet-dreiging draagt wél bij aan Robs klacht. Hij blijft eruit om drie redenen, en de eerste is op
zichzelf genoeg — **het is geen taunt, en onze zin beweert van wel**. Daarna: zijn eigen
autocast-tekst zegt hem aan te laten, dus waarschuwen zou bij élke warlock met een Voidwalker
afgaan; en het gedrag dat Rob meldde staat letterlijk in Sufferings autocast-regel.

## ✅ 7 sep — de route eindigde wél, de pins niet

Rob op de isle, mét pijl op het scherm, `/mh arrow`:

```
route owner: none            ← de route is netjes geëindigd
onze pijl getekend: nee      ← onze pijl is weg
TomTom actief: ja · zijn pijl zichtbaar: ja
Blizzard-waypoint gezet: ja
```

📌 **Dat is een schone splitsing.** Onze kant klopte volledig; wat hij zag was TomTom's pijl, gevoed
door twee pins die hun route hadden overleefd.

🔴 **En het opruimen zat op de verkeerde plek — de plek die ik er vanmiddag zelf in zette.** De
aankomstcontrole ruimde de pins alleen op als de eigenaar op dát moment nog `waypoint` of `delve`
was. Vandaag stond hij al op `none` — iets anders had de route eerder beëindigd — dus sloeg de
guard over, en precies de guard die voor veiligheid bedoeld was werd het lek.

📌 **Waaróm de teardown ze niet kende:** `NativeArrow` ruimt alleen pins op die het **zelf** gezet
heeft (`mhOwnedKey`). De Silvermoon-route zet ze bewust zelf, want de deur-overdracht stuurt ze
aan. Twee boekhoudingen, en de ene wist niets van de andere.

✅ **Gerepareerd met één vlag.** `SetSMCWaypoint` zet `ns._mhSmcPinsSet`; `NativeArrow`'s teardown
ruimt ze op zodra de eigenaar weg is en wist de vlag. Dat hangt aan **het enige signaal dat elke
manier van eindigen deelt** — de eigenaar die verdwijnt — in plaats van aan één specifieke waarde
op één specifiek moment. De opruiming in `Delves.lua` is weggehaald: één plek, geen twee.

✅ **BEVESTIGD 7 sep, twee runs, allebei schoon.** Rob ging **vanuit de kamer** door het portaal —
geen pijl — en daarna nog een keer **van buiten de kamer**, dus mét de deur-overdracht erin — ook
geen pijl. *"Voorlopig kunnen we hem aftekenen."*

📌 **Twee runs, niet één, en dat is wat het een meting maakt.** De twee paden zetten `lastTarget` op
verschillende momenten (direct, of pas bij de overdracht), en vandaag is precies zo'n verschil drie
keer de oorzaak geweest. Eén schone run had alleen het pad bewezen dat toevallig gekozen werd.

---

### 📌 De portaalroute in het kort — vier fouten op één dag, en waarom ze niet eerder gevonden waren

1. **De pijl werd nooit vrijgegeven** — `lastTarget` nillen stopt hem niet, alleen de eigenaar doet
   dat. De eigen afsluiting van de pijl vuurt binnen 20 yard van het doel, en een portaalroute is
   juist klaar door van zijn coördinaat wég te lopen.
2. **De deur-overdracht was onmogelijk** — Silvermoon geeft geen wereldcoördinaten, dus de afstand
   was `nil` bij elke tik en een drempel die niet bereikt kán worden werd nooit bereikt.
3. **Vanuit de kamer stuurde hij je terug naar de deur** — de uitzondering herkende alleen iemand
   op de drempel, niet iemand die er al voorbij was.
4. **De pins overleefden hun route** — het opruimen hing aan een eigenaar-waarde op één moment in
   plaats van aan het verdwijnen van de eigenaar.

🔴 **Alle vier waren onzichtbaar om dezelfde reden: er was geen manier om te zien wat er beslóten
werd.** Fout 2 en 4 zijn pas gevonden nadat `/mh arrow` het deurwachtertje en `arrivesOn` ging
printen — en dat is dezelfde les als [[silence-is-not-absence]] en de Spec 30-regel in CLAUDE.md,
maar nu vier keer op één middag betaald. **Bouw de diagnose vóór de derde gok, niet erna.**

## 🔴 7 sep — OPEN: binnen in de kamer wijst de pijl terug naar de deur

Rob, direct nadat de portaalroute werkte: *"wanneer ik buiten de kamer in Silvermoon City sta en ik
kies de weg naar de Coiled Isle-portal, stuurt MH me de kamer in. Daar loop ik in, en dan wijst ons
eigen pijltje terug naar het begin van die kamer. Ik weet dat ik rechtdoor moet, maar voor een
gebruiker is dat heel verwarrend."*

📌 **Dit is de tweestapsroute (`TwoStepRoute.lua`) die zijn tweede stap niet neemt.** Stap 1 is de
deur (54.99/63.30), stap 2 is het portaal zelf (56.74/67.30). `Arrive()` hoort binnen 22 yard van
de deur over te dragen. Doet hij dat niet, dan blijft de pijl op de deur staan — en zodra je die
deur binnenloopt ligt hij achter je.

✅ **GEMETEN 7 sep, `/mh arrow` binnen in de kamer mét de route actief:**

```
route owner: waypoint
doel: Entrance — Portal to The Coiled Isle is inside  (map 2393  55.0, 63.3)
jij: map 2393        doel: map 2393
```

📌 **Dat sluit twee dingen uit.** De route leeft nog (dus hij wordt niet voortijdig beëindigd), en
het doel is nog steeds de **deur** — dus de overdracht naar stap 2 heeft nooit plaatsgevonden. En
`jij: map 2393` is dezelfde kaart als `SMC_CITY_MAP_ID`, dus **verklaring 1 hieronder is dood**:
het interieur is geen aparte kaart en je positie is daar in principe leesbaar.

🔴 **WAAROM hij niet overdraagt is nog steeds niet te zien, en dat is de echte fout.** Alles wat
`TwoStepRoute.lua` doet gebeurt in een closure: of de ticker leeft, wat hij als laatste gemeten
heeft, of hij al opgegeven heeft. Drie verschillende storingen geven identieke stilte.

✅ **`ns.SmcTwoStepStatus()` gebouwd en in `/mh arrow` gezet.** Print of de deurwachter actief is,
de laatst gemeten afstand (of **ONMEETBAAR**, wat het interessante antwoord is), hoeveel van de 300
seconden op is, en waar hij daarna heen zou gaan. Dit is de regel uit CLAUDE.md over modules waarvan
zwijgen de normale uitkomst is.

## ✅ 7 sep — en de diagnose gaf antwoord in één regel

```
twee-staps deurwachter: actief · deur 54.99/63.30 op map 2393
   afstand nu: ONMEETBAAR
   verstreken: 16 s van 300 · daarna naar: Portal to The Coiled Isle (56.74/67.30)
```

🔴 **De ticker leefde, de route leefde, de speler stond op de kaart die de route gebruikt — en de
afstand was niet te lezen.** `C_Map.GetWorldPosFromMapPos(2393, …)` geeft niets terug voor
Silvermoon, dus `SmcYardsToPoint` gaf elke tik `nil`. Een drempel die nooit bereikt kán worden,
wordt nooit bereikt. De overdracht was hier niet wankel — hij was **onmogelijk**.

📌 **Zelfde vorm als de aura-regel:** `nil` betekende *"niet te lezen"*, de code las het als *"nog
niet"*, en dat zijn niet dezelfde antwoorden. Het kostte een middag omdat een pijl die niet
doorschuift er van buiten identiek uitziet als een pijl die naar het verkeerde ding wijst.

✅ **Gerepareerd: de afstand wordt nu op drie manieren gevraagd, beste eerst**, en `/mh arrow` zegt
welke geantwoord heeft:
1. **wereld-yards** — exact, werkt buiten;
2. **`C_Map.GetMapWorldSize`** — de kaart kent zijn eigen maat in yards, ook waar hij geen
   wereldpositie kan geven;
3. **kaartpercentage** — grof, en de enige met een eigen drempel (1,2%).

⚠️ **Nummer 3 is geen afstand en doet ook niet alsof.** Een percentage rekt anders in x dan in y op
elke kaart die niet vierkant is, dus het kan alleen "dichtbij genoeg" betekenen, nooit "22 yard".
De diagnose noemt de eenheid daarom bij naam — een getal dat liegt over wat het is, is erger dan
geen getal. En zakt hij ooit stilletjes naar 3 op een kaart waar 1 of 2 het eerst deed, dan is dát
een bevinding.

✅ **BEVESTIGD 7 sep.** Rob liep naar binnen en de pijl schakelde over naar *Portal to The Coiled
Isle*. De deur-overdracht werkt.

### 🔴 OPEN — en nu stopt hij niet aan de ANDERE kant van het portaal

Rob, na de geslaagde overdracht: hij stapt door het portaal, staat op de isle, en de pijl wijst
terug naar *Portal to The Coiled Isle*, **6 km 941 m** ver. *"Hij ziet blijkbaar niet dat we
aangekomen zijn. Wanneer ik kies voor een rare of een delve, dan ziet hij het wél."*

🔴 **En dit is precies het stuk dat vanmiddag als GEMETEN WERKEND is opgeschreven** (`route owner:
none` op de isle). Het verschil: toen was het doel de **deur**, nu het **portaal** — het enige dat
ertussen zit is de overdracht van stap 1 naar stap 2.

📌 **Twee kandidaten, en van buiten zien ze er hetzelfde uit:**
1. `arrivesOn` (2512) overleeft de overdracht niet — `SetSMCWaypointDirect` maakt een ondiepe kopie
   en die hoort hem mee te nemen, maar dat is gelezen en niet gemeten;
2. hij overleeft wél, maar de kaart waar het portaal je neerzet is niet 2512.

✅ **`/mh arrow` print nu `portaal-einde (arrivesOn)` naast `jij nu`, mét het oordeel of ze
overeenkomen.** Dat scheidt de twee in één regel. `GEEN` = kandidaat 1, twee verschillende getallen
= kandidaat 2.

✅ **BEVESTIGD 7 sep, na een zekere reload: de pijl is weg op de isle.** De hele keten loopt nu —
buiten → deur → portaal → aan de overkant stoppen. 📌 De mislukte run hierboven was dus opnieuw een
sessie zonder de nieuwe code; dat is vandaag **twee keer** gebeurd en beide keren kostte het een
ronde. Vraag voortaan expliciet of er gereload is vóór je een meting als bewijs behandelt.

### ✅ 7 sep — en vanuit de kamer stuurde hij je eerst terug naar de deur

Rob: *"als ik al in de kamer sta en vraag de weg, stuurt ie me eerst terug naar de deur en dan weer
naar de portal."*

📌 De bestaande uitzondering herkende alleen iemand die **op de drempel** stond
(`d <= limit`). Vijf passen verder naar binnen ben je die drempel in beide betekenissen voorbij, en
de route marcheerde je weer naar buiten.

✅ **Gerepareerd zonder nieuw getal:** ligt het doel dichter bij dan zijn eigen deur, dan is die deur
achter je. Beide afstanden komen uit `DoorProximity`, dus ze staan in dezelfde eenheid welke van de
drie methoden ook geantwoord heeft — precies waarom die functie zijn eenheid teruggeeft.

⚠️ **Het is meetkunde, geen deursensor.** Sta je **buiten** maar pal achter het gebouw, dan is het
portaal echt dichterbij dan de ingang en krijg je de pijl door een muur — de bug van 3 sep. Bewuste
ruil: die plek is smal en het foute antwoord daar is precies het gedrag dat iedereen vóór 3 sep had,
terwijl naar buiten gestuurd worden élke keer gebeurde als je het vanuit de kamer vroeg.

<details><summary>De drie verklaringen van vóór deze meting (verklaring 1 was het niet)</summary>

🔴 **DRIE VERKLARINGEN, NOG NIET GESCHEIDEN.** Ze zien er van buiten identiek uit, en dit is precies
het punt waarop deze sessie al twee keer verkeerd geraden heeft:

1. **Binnen is je positie op de STADSKAART onleesbaar.** De ticker vraagt
   `GetPlayerMapPosition(<stadskaart>, "player")`; is het interieur een eigen uiMap, dan komt daar
   `nil` uit, wordt de afstand nooit berekend en vuurt de overdracht nooit. Dit past het beste bij
   Robs beschrijving.
2. **Hij rijdt de bel van 22 yard voorbij.** `TICK = 1` seconde, en op een mount in de stad haal je
   ~28 yard per seconde. Dan kán de meting hem simpelweg missen.
3. **De overdracht vuurde wél** en het portaalcoördinaat leest binnen net zo slecht als de deur.

⚠️ **MEET DIT VOORDAT JE IETS BOUWT.** Eén commando scheidt alle drie: **`/mh arrow` terwijl je
BINNEN in de kamer staat.**
- `doel:` = de deur → verklaring 1 of 2 (overdracht vuurde niet); is `doel:` het portaal → 3.
- `jij: map …` anders dan de stadskaart → verklaring 1 bevestigd.
- Zelfde kaart én `doel:` de deur → verklaring 2.

📌 De chatregel `SMC_ENTRANCE_ARRIVED_FMT` is een tweede, gratis onderscheid: die wordt geprint op
het moment van overdragen. Kwam hij niet, dan heeft `Arrive()` niet gedraaid.

</details>

## 🔴 7 sep — "route beëindigd" zei het wél, maar de pijl ging niet weg

Rob, mét screenshot, staand op de Coiled Isle: de pijl wees nog steeds naar de deur in Silvermoon,
**7 km** achter hem. *"Ik denk dat er iets ingebouwd moet worden waarbij hij ziet dat hij op Coiled
Isle aangekomen is, en dan die pijl afkapt."*

📌 **En het herkennen zat er al in** — `arrivesOn = 2512` is op 5 sep gebouwd, en de controle in
`Delves.lua` deed precies wat hij moest: hij zag de aankomst, zette `ns.lastTarget = nil` en printte
"route beëindigd". Dat is de helft van het werk, en die helft was al af.

🔴 **`ns.lastTarget` nillen stopt de pijl niet, en dat is met opzet zo.** `NativeArrow` houdt een
eigen `activeLead` bij en breekt alleen af op `ns._mhRouteOwner`, omdat een handvol zone-handlers
`lastTarget` midden in een jacht leegmaakt (staat in zijn eigen kop). Dus stond er "route beëindigd"
in de chat terwijl de pijl waar die regel over ging gewoon bleef wijzen.

🔴 **De pijl heeft wél een eigen afsluiting, en die kán hier niet helpen** (`NativeArrow.lua:1030`):
hij laat los zodra je binnen ~20 yard van het doel komt. Een portaalroute is klaar door van zijn
coördinaat **weg** te lopen — dus de enige uitgang was precies de uitgang die deze route nooit
neemt. Dat verklaart ook Robs eigen waarneming dat een **rare**-route hier géén last van heeft:
eigenaar `rare` haalt elke tik een nieuwe lead op en overschrijft de verouderde vanzelf.

✅ **Gerepareerd:** de aankomstcontrole geeft de pijl nu ook echt vrij — `_mhRouteOwner` los, TomTom
en de Blizzard-pin weg, en de deur-ticker van de tweestapsroute gestopt.

⚠️ **Alleen voor eigenaar `waypoint` en `delve`.** rare/treasure/reset/achievement doen hun eigen
levensloop, en `RouteLead()` kan een **rare**-lead teruggeven — daarop wissen zou een lopende jacht
beëindigen.

⚠️ **De pins moeten mee, niet alleen onze eigen pijl.** Deze route zet zelf een Blizzard-waypoint
én een TomTom-waypoint (`SetSMCWaypoint` in `UI.lua`). Alleen onze pijl opruimen repareert het
dus voor precies de mensen die geen van beide draaien — en dat is niemand met wie we testen.
Zelfde vorm als de rare-aankomsttips op 19 aug.

✅ **GEMETEN 7 sep, `/mh arrow` op de isle na een portaalroute:**

```
route owner: none
target: NONE — no route has published one
arrow frame exists: nee   shown: nee
Blizzard-waypoint gezet: nee     TomTom … zijn pijl zichtbaar: nee
```

📌 De diagnose was uit de code gelezen (`Delves.lua` ~3538 → `NativeArrow.lua` 878/1030) en pas
daarna in het spel bevestigd. **`arrow frame exists: nee` is de regel die het beslist**: niet alleen
het doel is weg, het frame is afgebroken — dus dit is echt de eigenaar die losgelaten is en niet een
pijl die toevallig niets te wijzen heeft. En de twee pin-regels bevestigen dat de TomTom- en
Blizzard-waypoint ook mee zijn.

✅ **HERMETEN 7 sep, en dat was nodig.** Tussendoor stond er één meting die zei dat de TomTom-pin
bleef staan (`TomTom actief: ja · zijn pijl zichtbaar: ja` terwijl `route owner: none`). Rob wist
zelf niet meer of hij toen gereload had, en dat bleek het antwoord: ná een zekere reload liep de
portaalroute schoon. 🔴 **Die tussenmeting is dus GEEN uitspraak over deze fix** — hij is niet als
bewijs bruikbaar en staat hier alleen zodat niemand hem later terugvindt en gaat repareren wat niet
stuk is. Zelfde val als op 6 sep met de verouderde SavedVariables: het meetinstrument klopte, de
toestand waarin gemeten werd niet.

⚠️ **Wat deze meting NIET dekt:** `/mh arrow` meldt ook `WaypointUI aanwezig: ja`. Als er ooit
tóch nog een pijl blijft staan terwijl deze diagnose `arrow frame exists: nee` zegt, dan tekent
WaypointUI hem en is dat een ánder spoor dan dit. Vandaag niet aan de hand — genoteerd zodat de
volgende waarneming niet opnieuw in deze sectie belandt.

## ✅ 7 sep — de waarschuwing gaat weg zodra je hem opvolgt

Rob, nadat de gecentreerde toast werkte: *"op het moment dat ik de Growl weer uitzet, kan die dan
automatisch weggaan, of is dat te lastig?"*

Niet lastig — het gereedschap lag er al. `PET_BAR_UPDATE` staat sinds de eerste versie in de
watcher (de autocast-schakelaar is precies wat dat event meldt), en `ns.DismissMidnightToast()`
bestond al voor de sluitknop. Wat ontbrak was een deur om **één specifieke** kaart terug te nemen.

✅ **`ns.RetractMidnightToast(id)`** in `MidnightToast.lua`. `PetTauntProbe.Check()` roept hem aan
met `"pet_taunt_on"` zodra de reden verdwijnt.

⚠️ **Hij haalt de kaart uit TWEE plekken**, anders zou hij alleen werken als de timing toevallig
goed valt: van het scherm (`activeSpec`) én uit de wachtrij erachter. Zet je de taunt een halve
seconde vóór de toast opkomt uit, dan verscheen de waarschuwing anders alsnog.

🔴 **Alleen op `false`, nooit op `nil`.** Dit is dezelfde driedeling als bij `TankInGroup()`.
`nil` betekent dat we de situatie niet konden lézen, en een waarschuwing van het scherm trekken
omdat wíj blind werden is dezelfde fout als hem nooit tonen — de speler ziet de kaart verdwijnen en
leest dat als "opgelost". Bij `nil` blijft hij staan tot zijn eigen timer afloopt.

📌 **Er zit ~2 seconden tussen**, want de watcher stelt élke controle 2 s uit (bij het inladen is de
petbalk nog leeg, en te vroeg lezen geeft "geen taunt" — stilte die op een veilig antwoord lijkt).
Bewust niet twee paden gebouwd: één weg naar één antwoord.

✅ **BEVESTIGD 7 sep in een delve.** Rob: `/mh pet test`, kaart komt op, Growl uit, niets doen —
de kaart gaat vanzelf weg. *"dit werkt goed!!!!"*

📌 **Daarmee is de negatieve helft van de pet-waarschuwing rond**: opkomen, geluid, knipperen,
midden op het scherm, en weggaan zodra je hem opvolgt.

### ✅ 8 sep — EN DE POSITIEVE HELFT OOK: hij vuurt uit zichzelf

Rob, in een **follower dungeon**: *"hij vuurt"*. De trigger is daarmee voor het eerst uit zichzelf
gezien — niet via `/mh pet test`, maar doordat de situatie zich voordeed.

📌 **Het was Robs eigen idee** (7 sep, vlak voor het slapen: *"mag ik de pet waarschuwing morgen in
een follower dung doen?"*) en het is een slimmere test dan degene waar ik om vroeg. Ik wachtte op een
dungeon met Carola of Cisca — dus op andere mensen — terwijl de volgers-NPC's dezelfde vier
voorwaarden vervullen: er is iemand, je zit in een instance, jij bent geen tank, en er tankt iemand.
**Een test die niemand anders nodig heeft is er een die je vandaag kunt doen.**

⚠️ **Wat hiermee NIET bewezen is: de rol-uitlezing bij een échte speler.** Volgers dragen hun rol
netjes; bij mensen kan 12.1 een secret teruggeven zodra de identiteit verborgen is, en dát is de
reden dat `TankInGroup()` drie antwoorden heeft in plaats van twee. Vuurt hij ooit **niet** in een
mensen-dungeon, dan is `nil` de eerste verdachte — en die valt bewust door naar wél waarschuwen, dus
zelfs dan zou hij moeten komen. Eén dungeon met Carola of Cisca sluit het af; het is geen blokkade
meer, alleen de laatste onbekende.

## ✅ 7 sep — "je Growl staat nog aan" — GEMETEN EN GEBOUWD

Robs meting op zijn BM-hunter, en de **tweede** run is wat het een meting maakt in plaats van een
waarneming:

```
Growl aan   ->  6. Growl  autoAllowed=true  autoEnabled=true   spellID=2649
Growl uit   ->  6. Growl  autoAllowed=true  autoEnabled=false  spellID=2649
```

De waarde **bewoog**. Eén aflezing van `true` had alleen bewezen dat het veld bestaat.

📌 **Diezelfde run besliste ook de rol-vraag:** solo gaf `UnitGroupRolesAssigned` **`NONE`** terwijl
`GetSpecializationRole` **`DAMAGER`** gaf. De unit-route is dus niet alleen secret-gevoelig maar
gewoon leeg zolang niemand je iets toegewezen heeft — en dat is meestal. De spec-route weet het
altijd.

✅ **GEBOUWD** in `Modules/PetTauntProbe.lua`: chatregel + toast, één keer per instance-bezoek,
alleen in een groep, alleen als je zelf geen tank bent, en alleen als een taunt daadwerkelijk op
autocast staat. Zeven talen. Twee seconden vertraging na `PLAYER_ENTERING_WORLD`, want bij het
inladen is de petbalk nog leeg en dat leest als "geen taunt" — stilte die op een veilig antwoord
lijkt.

🔴 **Wat de tekst BEWUST NIET beweert: dat iemand anders tankt.** Er staat alleen wat waar en
gemeten is — *jij* bent de tank niet en *jouw* pet taunt. Die formulering blijft, ook nu de
tank-check er wél is (zie hieronder), want hij kan `nil` teruggeven.

### ✅ 7 sep — de tank-check is er alsnog, en Rob had gelijk dat ik te voorzichtig was

Rob, met een screenshot van zijn party-frame: *"waarom zien we daar wel dat ik DPS ben en Valeera
een tank is?"* Terechte vraag, en hij corrigeerde een aanname van mij.

📌 **Ik had `UnitGroupRolesAssigned` als onbruikbaar behandeld** omdat Blizzards 12.1-notities
zeggen dat hij een secret teruggeeft *zodra de identiteit van die unit verborgen is*. Dat is een
gedocumenteerde **mogelijkheid**, en ik had er een categorisch verbod van gemaakt — terwijl Robs
eigen `/mh pet` diezelfde middag twee keer gewoon `DAMAGER` printte, in een delve én in een raid.

⚠️ **De regel is niet "niet lezen" maar "een secret niet VERGELIJKEN".** `role == "TANK"` is wat
gooit, niet de aanroep zelf. Met een guard is de lezing gewoon bruikbaar.

✅ **`TankInGroup()` toegevoegd.** Leest de rol van elk groepslid, slaat secrets over, en geeft
**drie** antwoorden: `true` (er tankt iemand), `false` (niemand), `nil` (niemands rol was leesbaar).

🔴 **`nil` valt met opzet door naar het oude gedrag.** Niet-kunnen-lezen is niet hetzelfde als
niemand-tankt, en zwijgen op een lezing die we niet hebben kunnen doen zou een echte fout verbergen
op grond van onze eigen blindheid. En omdat de zin nooit beweerde dát er een tank is, blijft hij
waar in álle drie de gevallen — dus geen nieuwe teksten en geen tweede vertaalronde.

📌 **En dit beantwoordt Robs duo-delve-vraag meteen:** Valeera dráágt de TANK-rol, dus followers
tellen hier bewust mee. Een pet die van háár wegtrekt is dezelfde fout als bij een speler.
### 🔴 7 sep — en toen bleek "solo = zwijgen" gewoon fout, met een reden uit het spel

Rob: *"ik merk dat wanneer mijn pets Growl aan hebben staan, dat ze heel snel doodgaan als er
meerdere adds zijn. Ik wil het graag in een delve hebben."*

📌 **Dat is geen voorkeur maar een gemeten gevolg.** Mijn `>= 2 echte spelers`-eis hield delves stil
op mijn aanname dat solo betekent "niemand om aggro van weg te trekken". Valeera **is** iemand, ze
leest als `TANK` (gemeten diezelfde middag), en zijn pet gaat er dood aan.

✅ **`AnyGroupMember()` vervangt de spelerstelling.** Voorwaarde is nu: er is iemand — speler of
follower — én er tankt iemand én jij niet én er staat een taunt aan.

⚠️ **"Iemand" moet wel écht iemand zijn.** Alleen in een oude dungeon zonder groep is je pet de
tank en hoort Growl juist aan; een lege party blijft dus stil. Dat is een ánder geval dan "groep
bestaat maar rollen onleesbaar", en die twee worden apart beantwoord.

📌 De nieuwe logica is in beide richtingen scherper dan de oude: hij zwijgt waar de pet zelf tankt
(ook al ben je in een groep) en spreekt waar iemand anders tankt (ook al ben je alleen).

### 🔊 En een toast met geluid, niet een regel in de chat

Rob: *"met een duidelijke waarschuwing, niet alleen maar een regel beneden in mijn chat."* Zelfde
antwoord als de levelpoort op 5 sep kreeg, en om dezelfde reden — niemand leest chat midden in een
pull. 20 seconden zichtbaar (dit wordt uitgevoerd, niet aangekeken).

🔊 **Geluid: `SOUNDKIT.RAID_WARNING`, door Rob met zijn oren gekozen** uit de acht kandidaten van
`/mh pet sounds`. Deze regel zei eerst `READY_CHECK` "omdat de rest van de addon dat gebruikt" —
dat was mijn keuze vóór hij kon luisteren, en ik kan zelf niets horen. De galerij bestond juist om
die keuze bij iemand te leggen die dat wél kan.

✅ **En hij knippert nu ook** — Rob, direct nadat hij hem voor het eerst zag werken: *"kan ie
flashen??"* Nieuwe optie `spec.flash` in `MidnightToast.lua` (zie hieronder voor de vorm die het
uiteindelijk kreeg — de eerste poging met alpha-pulsen is vervangen).

⚠️ **Opt-in, en dat blijft zo.** Elke toast die knippert is elke toast die schreeuwt, en de
volgende daarna is niemand die nog kijkt. Alleen een toast die erom vraagt krijgt het, en deze
vraagt erom omdat je hem uitvoert vóór de pull in plaats van naleest.

🔴 **De eerste poging pulseerde de ALPHA en Rob zag het amper:** *"ik zag heel snel iets knipperen.
Ik bedoelde meer dat die gaat rood-wit knipperen of zoiets, dat het echt goed opvalt."* Een donkere
kaart doorzichtiger maken tegen een donker spel is een verandering van bijna niets, en drie tellen
ervan waren voorbij voor hij opkeek.

✅ **Nu KLEUR in plaats van doorzichtigheid:** de rand wisselt **rood ↔ wit** en de achtergrond
kleurt op de rode tel mee. 10 tellen van 0,35 s ≈ 3,5 seconde, dus hij is te vangen midden in een
pull en niet alleen als je toevallig in die hoek staat te kijken.

📌 Het is een `SetBackdrop`, dus dat kost twee aanroepen per tel — geen textuur, geen animatiegroep,
en geen gevecht met de fade die de alpha al bezit. `flashGen` breekt een lopende flash af als er een
nieuwe toast komt, en de goudkleur wordt aan het eind hersteld zodat de vólgende toast niet rood
blijft staan.

⚠️ **Geen `UnitIsUnit` om jezelf over te slaan**: die geeft een secret BOOLEAN en ernaar vragen
gooit. Ook niet nodig — we komen hier alleen als de speler zélf geen tank is.

🔴 **DEZE REGEL STOND HIER EN IS ONWAAR** — ze zei *"zwijgt solo, en dat is een feature; in een
delve wíl je Growl aan hebben, Valeera tankt niets."* Beide helften zijn diezelfde dag gemeten en
weerlegd: Valeera **draagt** de TANK-rol, en Robs pet gaat er dood aan. Zie de sectie hierboven over
`AnyGroupMember()`. Blijft staan als correctie, niet als status.

⚠️ Alleen **Growl (2649)** is gemeten. `Suffering` (17735, Voidwalker) staat als kandidaat in de
tabel — die moet een warlock bevestigen.

### 🔴 En de eerste versie zou in ELKE DELVE gewaarschuwd hebben

Rob draaide `/mh pet` in een delve met Growl aan:

```
instance: true (scenario)   group size: 2   pet out: true
Growl  autoAllowed=true  autoEnabled=true  spellID=2649
```

**Valeera telt mee als groepslid.** Mijn `GetNumGroupMembers() >= 2`-eis stond er juist om delves
stil te houden, en beschermde precies niets: alle vier de voorwaarden waren vervuld in de één plek
waar de melding nooit mag komen.

✅ **BEVESTIGD 7 sep**, twee runs in dezelfde delve (Growl uit én aan), allebei:
`would warn: false (solo (1 real player in the group))`. Valeera wordt niet meer meegeteld.
📌 Dat Growl aan/uit geen verschil maakte klopt: de check stopt bij de eerste voorwaarde die faalt
en kijkt dan niet meer naar de petbalk. De reden die hij noemt is dus ook de reden die telde.
⚠️ **Nog NIET getest: de positieve kant.** Dat een echte groep mét Growl aan de melding wél geeft,
is nooit gezien — daar is een dungeon met Carola of Cisca voor nodig. Tot dan is alleen bewezen dat
hij zwijgt waar hij moet zwijgen, en dat is de helft die iedereen zou irriteren, niet de helft die
de feature waarmaakt.

✅ **Gerepareerd met `RealPlayersInGroup()`** — tel de *mensen*, niet de party-slots. Een follower is
geen speler. ⚠️ **Niet opgelost door `scenario` uit te sluiten:** Broken Throne-rituals zijn óók
scenarios, en dat zijn echte groepen waar de melding juist wél moet komen. En `UnitIsPlayer` gaat
door een guard, want een secret boolean overleeft `pcall` en bijt pas bij de vergelijking.

### 🔴 En ik had het gebouwd zonder testknop

Rob, staand in die delve: *"hebben we een commando om hem op te roepen??"* Terecht — hij kon niet
zien of de melding kapot was of het bestand simpelweg niet geladen. `CLAUDE.md` eist sinds Spec 30
precies dat van alles wat kan zwijgen, en ik heb die regel bij het bouwen overgeslagen.

✅ **`/mh pet test`** roept de echte melding op, debounce genegeerd. Vuurt hij niet, dan print hij
**waaróm** (*"solo (1 real player)"*, *"you ARE the tank"*, *"no known taunt on autocast"*). En
`/mh pet` toont die live-beslissing nu ook, zodat "hij zei niks" nooit meer een raadsel is.
⚠️ Geen `if testMode`-tak: de test loopt door dezelfde functie als het spel.

📌 Lintcheck **[6]** ving onderweg een echte bug — ik riep twee locale functies aan die pas
verderop gedeclareerd staan, wat op dat moment een nil-global is. Zelfde val als `FitFoot` op 6 sep,
en opgelost zoals het hoort: via `ns.`-namen, die pas bij het uitvoeren opgezocht worden.

Robs idee: *"het komt regelmatig voor dat ik Carola of Cisca in een instance zitten met een tank en
dan vergeten we onze Growl uit te zetten — kunnen we dat melden?"* Een pet die taunt terwijl iemand
anders tankt trekt mobs weg, en het spel zegt er niets over.

🔴 **De voor de hand liggende versie kan NIET.** *"Zit er een tank in de groep"* vraagt
`UnitGroupRolesAssigned` op **andere** units, en 12.1 geeft daar een **secret** terug zodra de
identiteit verborgen is. `role == "TANK"` op een secret is precies de vergelijking die gooit — zie
`DelveCuriosAdvisor.lua:40`, waar dat al beschreven staat na vier GUID-reads in juli die er wél op
sneuvelden.

✅ **Dus de vraag is omgedraaid: "ben ík niet de tank?"** Dat beantwoordt `GetSpecializationRole` —
die vraagt naar je **spec** en nooit naar een unit, dus geen secret komt erbij.
`DelveCuriosAdvisor.GetPlayerRoleKey` doet dit al, guard en al.

❓ **Wat ECHT onbekend is, en de enige reden dat er een probe is:** of de autocast-stand van de
pet-actiebalk leesbaar is op 12.1. Niets in deze addon heeft ooit `GetPetActionInfo` aangeroepen.

✅ **`/mh pet` gebouwd** (`Modules/PetTauntProbe.lua`). Print je rol via **beide** routes naast
elkaar (unit vs spec, zodat het verschil zichtbaar is), de hele pet-actiebalk met `autoAllowed` /
`autoEnabled` / `spellID` per slot, en een oordeel. 📌 **Solo te draaien** — de groepshelft is
wegontworpen, dus alleen een pet uit hebben volstaat.

⚠️ De taunt-id's (`Growl` 2649, `Suffering` 17735) zijn **kandidaten, geen meting**. De probe print
elk slot, dus een ontbrekende verschijnt als onherkende regel in plaats van als stilte.

🔴 **Pas bouwen na die meting.** Leest `autoEnabled` als SECRET of nil, dan kan de melding niet op
deze manier en zoeken we een andere route of laten we het.

## ⛔ 7 sep — DE DISPEL-HELPER IS DICHT, en dit is de meting waarom

Rob vroeg PIHelper (CurseForge, 1,9K downloads) te beoordelen voor onze party-kant. Conclusie:
**de feature niet bouwen, en de dispel-helper sluiten.** Niet uit voorzichtigheid — uit een meting
die we zelf al twee keer gedaan hadden en die ik bijna over het hoofd zag.

🔴 **De route waar alles op zou rusten geeft ZELFVERZEKERD FOUTE ANTWOORDEN in gevecht.**
`Modules/Auras.lua:107-148`, gemeten 12 aug en **gereproduceerd op 31 aug**: Rob had acht buffs en
vroeg in gevecht naar diezelfde acht id's — **zeven kwamen terug als `nil`**. Geen fout, geen
weigering, een rustig verkeerd antwoord. En op 31 aug was het bewijs in plaats van gevolgtrekking:
voor id 462854 gaven twee aanroepen op hetzelfde moment tegengestelde antwoorden, waarvan er één de
aura wél zag.

📌 **Dat is precies de techniek van PIHelper** — *"tracks a configurable list of buff IDs"*, dus
gericht vragen op id in plaats van opsommen. Voor hén is dat goedkoop: een gemiste Power Infusion
betekent dat een frame een keer niet oplicht. Voor een dispel-helper is een gemiste debuff de hele
feature, en een helper die er drie van de vijf mist zonder het te weten is **slechter dan geen**.

⚠️ **`Aura.HasUnitBuff` heet gericht maar somt óók op** (`Auras.lua:186`, een `GetAuraDataByIndex`-
lus). We hebben nergens een echte vraag-op-id voor een ánder character. Dat is geen omissie om te
repareren zolang de route zelf onbetrouwbaar is.

### 🔓 Wat het kan HEROPENEN — één meting, en die heeft Cisca nodig

Onze meting ging over `GetPlayerAuraBySpellID` op **jezelf**. PIHelper vraagt naar **anderen**, met
een andere functie (`GetUnitAuraBySpellID`). **Dat verschil is nooit getest.** Twee verklaringen,
allebei bruikbaar:

1. Ze accepteren de missers (goedkoop voor PI, dodelijk voor dispel).
2. De unit-route gedraagt zich anders dan de player-route.

Is 2 waar, dan gaat alles weer open. `/mh dispelprobe` bestaat al en heeft zelfs een `watch`-variant
— maar die somt **op**, dus hij beantwoordt deze vraag níét. Er zou een arm bij moeten die per id
vraagt, en dan één run in een groep.

🔴 **Niet bouwen vóór die meting.** Anders staat er code op een route waarvan we weten dat hij liegt.

⏰ **Hercontrole gepland: rond 7 okt 2026** — is de aura-route verbeterd (patch/hotfix), en wat doet
PIHelper inmiddels. Rob: *"check hem over een maand nog eens of ie verbeterd is"*.

📌 **Mijn eerste advies hierover was FOUT en is binnen het uur teruggenomen.** Ik las de indexregel
in memory (*"opsommen mag niet, gericht vragen wel"*) en niet het bestand waar die naar wijst — waar
sinds 12 aug staat dat gericht vragen in gevecht stil verkeerde antwoorden geeft. Tweede keer die
dag dat ik op een kop afging in plaats van op de inhoud; zie de regel bovenaan dit bestand.

## ✅ 7 sep — Spec 32 is af voor alle drie de klassen, plus een linter die dit soort bug vangt

De onderzoek-sessie breidde Spec 32 uit naar drie klassen. **Twee van de drie waren vandaag al
gedaan** (Priest-hernoeming + zeven spells, Druid-vijf); alleen de Hunter lag er nog.

🔴 **HUNTER — `Multi-Shot` is voor Beast Mastery VERVANGEN door `Wild Thrash`** (1264359, en Beast
Cleave komt daar sinds Midnight vandaan). Onze entry stond op `specs = { 253, 254 }`, dus voor BM
bleef **Shift+1 — de AoE-tweeling — gewoon leeg**, terwijl dat de knop is waar de hele AoE-rotatie
om draait. Nu `{ 254 }` voor Multi-Shot en een eigen entry voor Wild Thrash op `{ 253 }`.

📌 **De waarschuwing van de spec is opgelost in plaats van doorgegeven.** Die zei: controleer eerst
of Marksmanship Multi-Shot nog heeft, want dat is op een BM-hunter niet te meten. Dat hoeft niet:
253 eruit halen is veilig ongeacht het antwoord. Heeft MM hem nog, dan klopt de entry; heeft MM hem
ook niet meer, dan is hij **inert** — de pijplijn loopt over de live spellbook, dus een regel voor
een spell die niet bestaat matcht nooit. Dat is §2's eigen asymmetrie, toegepast.

### 🔑 De rode draad, en wat we eraan gedaan hebben

Drie klassen, één oorzaak: Blizzard hernoemt of vervangt een knop en onze **naam-gesleutelde**
tabel volgt niet. En alle drie faalden **stil** — `0 did not fit` in elke dump, want er valt niets
om als er niets geplaatst wordt.

✅ **Nieuwe lintcheck [20]** (Spec 32 §5c): een entry die een spell-id in zijn eigen commentaar
noemt maar het niet als `id` draagt. Bij de priester stond het juiste getal (228260) letterlijk op
dezelfde regel als de kapotte naam-sleutel; met een `id` had de hernoeming niets gebroken.
**Eerste run: 200 entries in 11 bestanden.** SOFT, want de migratie is bewust stapsgewijs.

🔴 **En in de check staat waarom je die 200 NIET machinaal mag invullen:** dat getal in een
commentaar is een *kandidaat*, geen id. Er staan ook talent-id's, cooldowns in milliseconden en
id's van verwante spells tussen ("JustAC SpellCooldowns 5217=30s"). Het eerste grote getal pakken
en wegschrijven is precies de plausibele gok die dit project verbiedt — en een fout id is erger dan
géén, want dan matcht hij iets ánders in plaats van terug te vallen op de naam. Vullen gaat zoals
vandaag bij Druid, Priest en Hunter: uit een client-dump, klasse voor klasse.

✅ **HERMETEN 7 sep, en de negatieve helft is het bewijs.** Rob draaide `/mhautomap` + `/reload` op
zijn hunter, dus de dump staat weer op HUNTER. Controles in dezelfde uitlezing: Kill Command 34026
en Barbed Shot 56641 komen terug. Dan het punt zelf:

- **`Wild Thrash` = 1264359** — exact wat de spec zei.
- **`Multi-Shot` staat er NIET in.** Dat is de meting die telt. Het id bevestigen zegt alleen dat de
  nieuwe entry klopt; dat Multi-Shot ontbreekt zegt dat het weghalen van 253 terecht was. Zonder die
  tweede helft was het een halve controle geweest.

✅ **EN HET WERKT, gemeten in de dump zelf:**

```
["placed"] = { { ["key"] = "Shift+1", ["category"] = "main_rotation",
                 ["id"] = 1264359, ["name"] = "Wild Thrash" }, ...
```

`unmatched` van 11 naar 10, `unplaced` leeg, en `layoutSpecKeys` bevat nu `Shift+1` waar dat er in
de vorige run niet in stond. Het lege AoE-slot is gevuld.

🔴 **TWEE LEESFOUTEN OP RIJ ONDERWEG, en de tweede is de leerzame.**
1. Mijn eerste parse las de velden op **volgorde** (`id`/`name`/`key`/`category`), maar Lua legt die
   volgorde niet vast: 11 van de 19 regels kwamen door, en de controle slaagde omdat Kill Command
   toevallig bij die 11 zat. Gevangen door de telling tegen het getal te zetten dat de dump zélf
   noemt. **Een controle die alleen de makkelijke gevallen raakt, is geen controle.**
2. Daarna las ik een dump die nog van de vórige run was en concludeerde "de reparatie werkt niet".
   **SavedVariables landt pas bij een `/reload`**, en Rob had ná zijn reload de automap gedraaid —
   zijn 10 stond in het geheugen, de 11 op schijf. Het signaal lag er: het getal in het bestand
   klopte niet met wat hij op zijn scherm zag. Dat verschil was de vondst, niet iets om overheen te
   lezen.
📌 Voor de volgende keer: **lees een `autoMapDump` nooit zonder eerst zijn eigen tellingen tegen
Robs scherm te leggen**, en draai de volgorde om — `/mhautomap` en dán `/reload`.

⚠️ **Wat er ná deze reparatie nog `unmatched` staat, opgeschreven zodat niemand het opnieuw
uitzoekt:** `Wing Clip` (195645) is de enige die een echte afweging waard is — Spec 32 zet hem op
lage prioriteit. `Eyes of the Beast`, `Make Camp`, `Return to Camp`, `Rummage Your Bag` zijn
gemaks-/kampeer-knoppen; `Auto Attack`, `Auto Shot`, `Revive Battle Pets`, `Anomaly Detection Mark I`
en `Mechanism Bypass` zijn ruis.

⚠️ **SCOPE: drie specs gemeten** (Guardian, Shadow, Beast Mastery) van de veertig. De rest kan
alleen op een personage dat Rob heeft.

### ✅ 7 sep — §1e GEBOUWD: `/mh binds` meldt nu wat wij niet kennen

Rob: *"doe dat unclassified getal maar in /mh binds"*. `ns.KeybindUnclassified()` in
`KeybindAutoMap.lua`, geprint door `ShowKeybindExport` naast de bestaande "lege slot"-regel — dus
wáár de speler toch al kijkt, en **alleen als er iets te melden is**.

🔴 **Het ruwe getal zou misleiden geweest zijn, en dat is waarom dit meer werd dan één regel.**
Robs BM-hunter had er tien, waarvan **negen ruis**: auto-attacks, kampeerknoppen, pet battles,
Warband-speelgoed. *"10 abilities have no key"* tonen slaat alarm over niets, en een teller die
roept bij nul leert de speler hem negeren.

📌 **De ruisfilter is op ID, niet op naam.** Namen zijn gelokaliseerd: een naamfilter zou op een
Duitse client niets uitsluiten en het getal weer opblazen — precies de bug die alleen niet-Engelse
spelers treft. De twaalf id's zijn GEMETEN in Robs eigen dumps van 6-7 sep (Guardian, Shadow,
Beast Mastery). Twijfelgevallen staan er bewust NIET in: liever één regel te veel dan een echte
omissie die we zelf wegfilteren.

📌 **En de namen staan erbij, niet alleen het getal** — "3 abilities" is een raadsel, drie namen
zijn een melding. De tekst vraagt de speler het te zeggen als er iets tussen staat dat een toets
verdient; dat is precies hoe we een hernoeming zoals `Void Eruption` → `Voidform` te horen krijgen
zonder dat iemand `/mhautomap` draait.

### 🗄️ Uit het onderzoek-overzicht van 7 sep — al af, niet opnieuw doen

De onderzoek-sessie noemt vier openstaande punten uit Spec 32; **drie waren op dat moment al
gedaan**:
- ✅ linter-regel §5c → lintcheck **[20]**, eerste run 200 entries in 11 bestanden (`9a18f82`)
- ✅ `tools/keybind_sheet/` opnieuw gedraaid, artifact bijgewerkt
- ✅ Marksmanship/Multi-Shot → **opgelost in plaats van open**: 253 weghalen is veilig ongeacht het
  antwoord, want een entry voor een spell die MM niet meer heeft is inert
- ✅ en nu ook het `unclassified`-getal hierboven

## 🔑 7 sep — DE ANDERE HELFT IS GEMETEN, en de Dundun-regel is nu een ANTWOORD

Rob sprak de **eerste** Dundun van de week aan op zijn hunter, met de sniffer aan:

| | gossipOptionID's |
|---|---|
| **eerste van de week** | **140123** *Make my delve Abundantly Bountiful!* · 140497 *No thank you.* |
| **daarna** | 140126 · 140496 · 140495 · 140513 (de vier keuzes) · 140514 |

**Nul overlap.** En de controle die telt: de vijf kwamen van zijn **druid**, deze twee van zijn
**hunter** — ander character, andere delve. Waren die id's per instantie of per character geweest,
dan hadden ze niet zo netjes uit elkaar mogen vallen.

✅ **GEBOUWD.** `DUNDUN_GOSSIP_IDS` + `ns.DundunGossipCase()` in `Modules/DundunShrine.lua`, met een
`GOSSIP_SHOW`-handler die één regel print op het moment dat het venster opengaat — precies wanneer
je moet beslissen of je een tweede key uitgeeft. Twee nieuwe teksten (`DUNDUN_GOSSIP_FIRST` /
`DUNDUN_GOSSIP_BOON`) in alle zeven talen.

📌 **Dit is de regel uit `CLAUDE.md` over "zet de uitleg in dezelfde kamer als de knop".** Tot
vandaag dreunde de addon de algemene regel op omdat hij niet kon zien welk geval je had. Nu zegt hij
wélk geval het is, waar je staat.

⚠️ **Herkennen we geen enkel id, dan zwijgt hij.** Er kan een derde variant zijn die niemand gemeten
heeft; de algemene regel staat nog steeds in de delve-intro, dus niemand blijft met lege handen
achter. En de "No thank you"-id's staan er bewust NIET in — weigeren zegt niets over welk geval je
had, en twee id's die hetzelfde betekenen zijn twee kansen om het mis te hebben.

✅ **Negatieve test gedaan, op de lastigste NPC die er is.** Rob sprak Dundun ná het accepteren
opnieuw aan: het venster gaat wél open maar met **nul opties** (*"Be on your way, then. Adventure
awaits does it not?"*). `DundunGossipCase` geeft dan nil en er komt geen regel. De handler kan dus
alleen vuren bij het **eerste** venster, vóór je kiest — precies het moment waarop de beslissing
valt. 📌 Opgeschreven zodat niemand later "waarom print hij niet als ik hem nog eens aanspreek" als
bug gaat onderzoeken: dat is het spel, niet onze code.

## ✅ 7 sep — de diagnose-uitvoer is Engels, want hij wordt meegeleverd

Rob, kijkend naar `/mh sniff`: *"klein detail, wanneer het alleen voor mij is en niet voor de
users, de teksten zijn in het nederlands in de chat haha"*. Terecht, en het was groter dan die ene
tool: **35 Nederlandse chatregels in 12 bestanden**, waarvan ik er 8 diezelfde ochtend zelf had
toegevoegd. Een gewoonte die erin geslopen was, geen uitschieter.

📌 **En het maakt uit, want deze commando's wórden meegeleverd.** Ze staan in
`MH_UNLISTED_ON_PURPOSE` — niemand ziet ze in de commandolijst — maar een Spanjaard die `/mh sniff`
typt kreeg gewoon Nederlands.

**Engels, géén `ns:L`-keys**, en dat is een bewuste keuze: dit is diagnostiek, geen speler-feature.
Locale-keys zouden zeven talen, drift-administratie en `check_drift`-onderhoud kosten voor uitvoer
die alleen bestaat om een bug te vinden. Engels is bovendien de conventie voor addon-diagnostiek.

⚠️ **De veeg was heuristisch, niet uitputtend.** Twee patronen op Nederlandse functiewoorden binnen
`print(`; alles wat ze vonden is om, en de laatste ronde vindt niets meer in geladen code. Een zin
zonder die woorden kan er nog staan. `docs/parked/GroundSafety.lua` is bewust overgeslagen (staat
niet in de `.toc`, wordt nooit geladen) en `tools/*.py` blijft Nederlands — dat draait alleen hier.

## 🌅 7 sep, ochtendronde — twee dingen uit de wachters, één ervan raakt onze data

Alle vier de wachters gedraaid. GitHub schoon (0 issues, 0 PR's). Verder niets nieuws: hotfixes
staan nog op 4 sep (dag 3 bevestigd, mét onafhankelijke tegencontrole tegen de cache-val), PTR nog
steeds build 69594.

### ✅ AFGESLOTEN — `C_Item.GetItemCooldown` bestaat, en al op 12.1.0

Stond sinds 5 sep als open vraag ("gecíteerd, niet gemeten"). De API-wachter heeft het dichtgemeten
tegen Blizzards eigen gegenereerde documentatie (`wow-ui-source`, branch `12.1.0`,
`ItemDocumentation.lua`, `Namespace = "C_Item"`, regel 412): één argument, drie returns
(`startTimeSeconds`/`durationSeconds`/`enableCooldownTimer`) — exact de drie die
`DelveItemsPopup.lua:278` uitpakt. De comment in `Delves.lua` die nog *"has NOT been verified in a
client"* zei is vandaag rechtgezet. ⚠️ Het is het documentatiebestand dat mét de build meekomt, geen
`/dump`; sterk, en nog steeds papier.

### 🔴 NIEUW EN ONGEREPAREERD — de Venomous Abyss heeft een Raid Skip, en onze bosvolgorde is vast

De data-wachter (Wowhead 382759, 6 sep, bevestigd door een tweede site, **live gedrag geen PTR**):
wie *"The Venomous Abyss: Deception Unmasked"* voltooit — 3× The Coiled Altar over 3 verschillende
weken, per moeilijkheidsgraad een eigen quest — mag daarna rechtstreeks door naar The Coiled Altar.

📌 **Waarom dat ons raakt:** `Modules/RaidCoachData.lua:89-95` draagt één vaste volgorde
(Nek'zali → Entombed Sentinels → Lost Explorers → Vashnik → Sszorak → Twin Fangs → Coiled Altar →
Ula'tek), op 27 jul uit de journal zelf gehaald. Voor een speler mét de skip klopt die niet meer:
die gaat van Nek'zali naar Twin Fangs/Coiled Altar. Een coach die dan *"volgende boss: Entombed
Sentinels"* zegt, adviseert iets dat die speler heeft overgeslagen.

⚠️ **NIET GEREPAREERD, met opzet: questID 98226 is een KANDIDAAT.** Hij komt van een PTR-questpagina
op Wowhead, niet uit de live-hotfixtekst. Hardcoden zonder meting is precies wat dit project niet
doet.
🔴 **En let op de valkuil bij het meten:** `IsQuestFlaggedCompleted(98226)` geeft `false` zowel als
het id fout is als wanneer Rob de skip simpelweg niet heeft — dat onderscheidt niets. De bruikbare
probe is `C_QuestLog.GetTitleForQuestID(98226)`: komt daar een titel uit, dan bestáát het id.
📌 En dat is de zwakke variant: ook mét een geldig id blijft ongemeten of onze *volgorde-aanname*
klopt voor iemand die de skip heeft. Zonder een speler met die quest is dit niet dicht te maken.

## 🚀 3.9.0 — LIVE EN GOEDGEKEURD op CurseForge, 7 sep 2026 (tag `v3.9.0` op `5ed095d`)

Rob: *"hij staat er goed op en goedgekeurd"*. Changelog schoon gerenderd door de packager, geen
handmatige reparatie op de CF-pagina nodig. 57 commits boven `v3.8.0`.

**Robs beslissing, tegen mijn advies in, en dat is genoteerd omdat het uitmaakt.** Ik adviseerde te
wachten tot de reset van woensdag; hij zei *"zet maar klaar en go"*. Dat is zijn keuze en die staat.

📌 **Waarom het verantwoord is, en niet alleen toegestaan.** Het enige dat aan woensdag hing was of
band B wekelijks reset. Zelfs als het antwoord slecht uitvalt is 3.9.0 **niet slechter dan wat er
nu live staat**: band A verbergt aantoonbaar rares waar een alt voor betaald wordt (Rob mat 50
shards), en band B is in de eerste week strikt beter en daarna hooguit gelijk. Er stond dus geen
schade op het spel, alleen de juistheid van een claim.

⚠️ **De release-tekst is bewust zo geschreven dat hij niet van die meting afhangt.** Nergens staat
dat band B wekelijks reset; er staat dat de shards die vlag volgen, en dat is gemeten.

🔴 **Wat woensdag alsnog moet: `/mh rarequests` ná de reset.** Band B hoort dan terug op `--` te
staan. Is dat niet zo, dan is er één zin te corrigeren — `RARES_TIP_DONE` zegt *"(reset woensdag)"*
— en die staat in zeven talen. Geen code, wel tekst.

📌 **Versie: minor, geen patch.** Ik zei gisteren nog 3.8.1; dat klopte toen. Sindsdien zijn er
drie dingen bijgekomen die nieuw *gedrag* zijn (Dundun kiest zelf welk geval hij toont, `/mh binds`
meldt iets dat het nooit meldde, en twee nieuwe commando's). Nieuw gedrag = minor, dezelfde regel
waar 3.2.0 op besloten is.

✅ **Yberamos staat met naam in de changelog én in de CF-notities**, op Robs uitdrukkelijke verzoek.
Eerste Discord-bugmelding van dit project, en hij leverde een tweede paneel met dezelfde fout op.

## 📅 MORGEN — vier dingen, in deze volgorde

Afgesloten op 6 sep 's avonds. Werkmap schoon, linter 0 hard, `luac` schoon over 252 bestanden.

1. 🔴 **`/mh rarequests` ná de reset van woensdag.** Staat band B dan weer op `--`, dan reset hij
   wekelijks en is het rare-verhaal compleet. Staat hij nog aan, dan is band B **permanent** en
   hebben we de achievement-criterium-bug van 15 aug in nieuwe kleren — dan biedt de addon een
   eenmaal gekilde rare nooit meer aan. **Dit blokkeert de release**, zie punt 4.
2. **`/mh sniff` in een Bountiful delve**, vóór je Dundun aanspreekt. Dit wordt Robs *tweede*
   Dundun van de week op dat character (het keuzescherm-geval); hij verwacht zelf dat de melding
   anders is dan bij de eerste. Volgorde: `/reload` → `/mh sniff` → delve in → `/mh sniff dump`.
   Let op de gele `gossipOptionID`-regels: een getal overleeft een vertaling, een zin niet.
3. ✅ **AF (7 sep).** Rob draaide `/mhautomap` + `/reload` op zijn Shadow Priest; alle acht ID's zijn
   geverifieerd en zeven ervan staan nu in `KeybindRoles_Priest.lua` — zie de sectie hieronder.
4. **Dan pas beslissen over 3.8.1.** Er ligt genoeg: een gemelde Discord-bug plus een tweede
   exemplaar ervan, en een rare-tabblad dat aantoonbaar het verkeerde vinkje las — dat laatste is
   een echte gedragsverandering voor iedereen die alts speelt. ⚠️ **Niet uitbrengen vóór punt 1**:
   valt die meting verkeerd, dan wil je die versie niet buiten hebben.

📌 Kleiner en zonder haast: Szarith is de enige rare die niemand ooit gekilld heeft (id 96030
ongetest), de 25 rares in Val/Naigtal hebben maar één bron voor hun id, en de keybind-coach leest
geen macro's — een toonkwestie, geen datafout.

## 🔴 DIT BESTAND BIJWERKEN HOORT BIJ DE WIJZIGING, NIET ERNA

Rob, 2 sep 2026: *"dit moet eigenlijk altijd gebeuren als er iets verandert, vind je niet?"*

Ja. En de reden dat het tóch misgaat is dat bijwerken aan het *eind* komt, als het werk al klaar
voelt — dan is het optioneel geworden. **Verandert de status van iets dat hier staat, dan gaat de
regel mee in dezelfde commit als de code.** Niet "straks even".

⚠️ Wat het kost als je het niet doet, twee keer gemeten: op 31 aug somde ik zeven beroepen op als
ongecontroleerd terwijl Rob ze diezelfde ochtend had gemeten, en op 2 sep stond `A Toxic Tour` hier
nog als open vraag terwijl hij al beantwoord was. Beide keren citeerde ik mijn eigen verouderde
aantekening als bewijs. Een aantekening is een claim mét een datum, geen meting.

🔴 **EN DE EMOJI IN EEN KOPREGEL IS DE ONBETROUWBAARSTE PLEK VAN ALLEMAAL — 6 sep, derde keer.**
Rob vroeg wat er nog openstond; ik las de 🔴-kopjes en meldde de Home-kop en de levelgrenzen als
open. Ze waren allebei al af — dat stond gewoon in de tekst erónder, die ik niet gelezen had. Een
kopregel wordt geschreven op het moment dat het probleem gevonden wordt en daarna zelden aangeraakt;
de body groeit wél mee. **De body regeert, de kop is een momentopname.** Verandert de status, draai
dan ook de emoji om — en wie een openstaande-lijst maakt, leest de bodies.

## ✅ 6 sep — Spec 32 uitgevoerd: vijf Druid-keybinds erbij, ID-migratie begonnen

`/mhautomap` op Robs Guardian schreef 16 spells als `unmatched` weg. Vijf daarvan waren echte
omissies en staan nu in `Modules/KeybindRoles_Druid.lua`, **mét een `id`** — Lunar Beam (204066,
regel 1 van de aanbevolen prioriteitslijst), Heart of the Wild (1261867), Ursol's Vortex (102793,
stond al sinds dag 1 in het bronnen-commentaar maar was nooit een entry), Mark of the Wild (1126)
en Revive (50769).

📌 **Elk id komt uit Robs eigen client** (`ns.db.autoMapDump.scannedIds`), geverifieerd mét
positieve controle. De eerste parse faalde — ik las `[id] = "Naam"` terwijl het bestand
`["Naam"] = id` schrijft — en dat is precies waarvoor die controle er is.

⚠️ **Raze blijft ontbreken**, met opzet: hij zit niet in Robs spellbook (talent niet genomen), dus
er is geen id uit de client, en van Wowhead halen mag niet.

⚠️ **Alleen Guardian is gecontroleerd.** De andere twaalf `KeybindRoles_*`-bestanden zijn niet
nagekeken; dat kan alleen personage voor personage (§3 van de spec). De elf namen die na deze
wijziging nog `unmatched` zijn, zijn stuk voor stuk verantwoord in `docs/SPEC_32_*.md` §6b — geen
enkele is een omissie.

🔴 **Openstaand uit dezelfde spec, apart uitzoeken waard:** de coach leest de spellbook en de
actiebalken, maar **niet wat er in een macro staat**. Rob heeft Lunar Beam in een macro. *"Deze
staat nog nergens"* is dus een bewering die we niet kunnen waarmaken; *"wij hebben hier geen plek
voor"* wel. Dat is een toonkwestie in de coach, geen datafout.

🔴 **En een val voor de volgende ID-migratie:** geef `Berserk` en `Incarnation: Guardian of Ursoc`
niet allebei een id. Robs client meldt `["Incarnation: Guardian of Ursoc"] = 50334` — hetzelfde id
dat de Berserk-regel noemt, want het talent overschrijft de spell. Twee entries met dat id laten er
één stil verdwijnen in `BuildIdIndex`.

📌 `tools/keybind_sheet/` is opnieuw gedraaid (HTML + XLSX) en het **gepubliceerde artifact is
bijgewerkt** (zelfde URL, zie [[keybind-cheatsheet]]).

### ✅ 6 sep — Spec 32 §1c: de Shadow-Priest-regressie is gerepareerd

`["Void Eruption"]` matchte sinds 12.0.0 nergens meer: het ID (228260) klopte, de **naam** niet.
Blizzard hernoemde de spell naar **Voidform**. De entry heet nu zo en draagt `id = 228260`.

📌 **Onafhankelijk bevestigd naast de spec:** JustAC schrijft "Voidform" bij 228260
(`SpellCooldowns.lua:646`, `SimcRotations.lua:622`) en BliZzi_Interrupts ook, terwijl oudere
addons (Details' LibOpenRaid, JustAC's eigen `SpellDB`) daar nog "Void Eruption" hebben staan. Dat
verschil tussen bronnen ís het bewijs van de hernoeming.

🔴 **Het faalde stil, en op twee plekken tegelijk** — het waren dus twee symptomen van één fout:
1. **In het spel** schoof Power Infusion (priority 2) stilletjes het F1-anker in, dus alles zag er
   normaal uit terwijl de grootste burst-knop van de spec nergens stond.
2. **Op het cheat-sheet** stond `Void Eruption` op F1 — een naam die niemand nog in zijn spellbook
   kan vinden. Dat is vanmiddag nog zo gepubliceerd en inmiddels rechtgezet.

### ✅ 7 sep — de acht Priest-spells zijn geverifieerd, zeven zijn toegevoegd

Robs eigen `autoMapDump` (Shadow Priest): **alle acht ID's kloppen**, naam voor naam. En de
positieve controle in dezelfde uitlezing deed dubbel werk — **228260 kwam terug als `Voidform`**,
wat de hernoem-reparatie van gisteren meteen ín de client bevestigt in plaats van uit andere addons.

| spell | id | waar het heen ging |
|---|---|---|
| Tentacle Slam | 1227280 | `main_rotation` p3, `{258}` — de AoE-motor, en de grootste omissie |
| Purify Disease | 213634 | `dispel_cc` **p2**, `{258}` — dezelfde plek als `Purify` voor Disc/Holy |
| Vampiric Embrace | 15286 | `cooldown` p3, `{258}` |
| Shadowform | 232698 | `utility` p8, `{258}` |
| Dispel Magic | 528 | `dispel_cc` p4, baseline |
| Shackle Horror | 9484 | `dispel_cc` p5, baseline — stond al sinds dag 1 in het commentaar op `:25` |
| Power Word: Fortitude | 21562 | `utility` p7, baseline |

📌 **Purify Disease op priority 2 is de mooiste van de zeven:** `Purify` (527) heeft die plek al
voor Disc en Holy, dus een priester houdt dezelfde reflex op dezelfde toets ongeacht zijn spec. Dat
is precies waar het v6-schema voor bestaat, en het viel hier gratis op zijn plek.

⚠️ **`Cantrips` (255661) is bewust NIET toegevoegd.** Hij staat wél in zijn spellbook, maar §1c zegt
zelf dat onbekend is wat hij in 12.1 doet. Een entry zonder rol is een gok met een toets eraan.

⚠️ **Drie staan baseline op redenering, niet op meting.** Alleen Shadow is gemeten. Dispel Magic,
Shackle Horror en Power Word: Fortitude zijn klassenbreed gezet omdat ze dát soort spell zijn, niet
omdat iemand Disc of Holy heeft opengeslagen. Blijkt er één spec-gebonden, dan is dat één `specs =`.

🗄️ **Ouder — wat er toen nog niet was gedaan:** de acht ontbrekende Priest-spells uit §1c (Tentacle Slam 1227280,
Vampiric Embrace, Shadowform, Dispel Magic, Purify Disease, Power Word: Fortitude, Shackle Horror,
Cantrips). Hun ID's staan in de spec als uit Robs client gelezen, maar `ns.db.autoMapDump` heeft
**één slot** en dat is inmiddels door de Guardian-run overschreven — ik kan ze dus niet
controleren zoals ik de vijf druïde-ID's wél heb gecontroleerd. Eén `/mhautomap` + `/reload` op de
priester zet ze terug in de dump; dan zijn ze in vijf minuten na te lopen en toe te voegen. Van
`Cantrips` zegt de spec zelf al: niet blind toevoegen.

## 🔴 6 sep — rares: een PERMANENT vinkje wordt gelezen als "deze week gedaan"

Rob stond op de Coiled Isle **letterlijk naast Hisstara** en kreeg geen alert, en de route wilde
hem er niet heen sturen. `/mh rarescan` ter plekke, met de rare springlevend op 100%:

```
[6] Hisstara the Raiser · npc=265262 · match=Hisstara · done=true
```

📌 **Oorzaak, gemeten:** vier Coiled Isle-rares (Garsecg, Destra, Hisstara, Kari'zah) hebben
**questID 0** en zijn op 15 aug aan een **achievement-criterium** gekoppeld om ze überhaupt
afvinkbaar te maken (`Rares.lua:881`, `IsRareDoneThisWeek`). Maar een achievement-criterium is
**permanent** — het reset nooit. Eén keer gedood is dus voorgoed "deze week al gedaan".

⚠️ **De reparatie van 15 aug was goed bedoeld en heeft een nieuwe fout gemaakt.** Toen konden die
vier zichzelf nooit afvinken; nu vinken ze zichzelf voor altijd af. De functie beantwoordt een
andere vraag dan zijn naam belooft.

🔴 **NOG NIET GEREPAREERD.** Elf plekken roepen `IsRareDoneThisWeek` aan, en een echte oplossing
splitst *"deze week gedaan"* van *"ooit gedood"* — dat raakt ook de kaart, de checklist en de teller
onder het tabblad. Niet iets om tussendoor te doen; zie de farm-schakelaar hieronder, die Robs
directe probleem oplost zonder die elf plekken aan te raken.

✅ **GEREPAREERD**: het criterium beantwoordt deze vraag niet meer. Voor die vier is er geen
weeksignaal, en "onbekend" hoort hier **false** te zijn — liever een rare aanbieden die al af is dan
er één verzwijgen die openstaat.
⚠️ **De prijs, hardop:** die vier vinken zichzelf niet meer af in de lijst. Dat was precies de klacht
die op 15 aug tot deze code leidde. We ruilen dus de ene onvolkomenheid voor de andere — **maar de
nieuwe is zichtbaar en de oude niet.**

✅ **GEREEDSCHAP GEBOUWD: `/mh questsnap` en `/mh questsnap diff`.** Snapshot van élke voltooide
quest tussen 84000 en 106000, rare doden, opnieuw scannen, verschil printen mét questnaam. Wat er
flipt ÍS het id — gemeten in plaats van opgezocht. De snapshot staat in SavedVariables, want hij
moet de vlucht naar de rare en een eventuele `/reload` overleven.

⚠️ **ROBS EIGEN CORRECTIE, en die staat in de instructies:** zijn drie overgebleven isle-rares zijn
open voor zijn **achievement**, wat iets anders is dan open voor **de week op dit character**. Flipt
een kill niets, dan was die weekly al gedaan — dan de volgende proberen, niet concluderen dat het
gereedschap stuk is. Precies dat onderscheid kan de addon nu niet maken, dus hij kan ook niet
voorselecteren.

🔴 **Tijdgebonden:** na de reset van woensdag zijn deze vier weer open en is de meting opnieuw te
doen — maar alleen als iemand hem dan doet.

### 🔴 6 sep — de meting is gedaan, en ze heeft onze conclusie van 13 aug omvergeworpen

Rob nam de snapshot, killde **Destra** plus twee gewone mobs, en diffte. Drie ids flipten, alle drie
zonder titel (`?` — verborgen quests, normaal voor rares):

```
88529 ?   ·   97415 ?   ·   95452 ?
```

📌 **95452 is Destra**, en dat is drievoudig vast te maken: onze eigen meting (hij flipte bij de
kill), `HandyNotes_Midnight/zones/coiled_isles.lua:193` (`quest = 95452`, mét criterium 115288 — dat
is exact wat wij al in de rij hebben staan), en `ZygorGuidesViewer/.../MID_Common_Rares.lua:844`
(`kill Destra##261142 ... 52.05,32.29` — npc-id én coördinaten identiek aan onze rij). De twee
andere ids horen bij de twee gewone mobs en zijn niet toegewezen.

🔴 **Maar daarmee is het niet opgelost, want er blijken TWEE quest-banden per rare te zijn** en
HandyNotes noemt ze allebei. Onze acht bekende ids liggen in band A (98344..98355, kaarsrecht
opeenvolgend); HandyNotes gebruikt band B als eigen afvink-vlag en zet band A ernaast als
*reputation quest*. De vier gaten in onze tabel zijn exact de ontbrekende nummers van die reeks:

| rare | band A | band B | onze tabel |
|---|---|---|---|
| Kari'zah | 98346 | 97122 | 0 |
| Hisstara | 98348 | 96464 | 0 |
| Szarith | 98349 | 96030 | 0 |
| Garsecg | 98350 | 94856 | 0 |
| Destra | 98355 | **95452 ← flipte** | 0 |

⚠️ **En hier zit de tegenspraak.** Destra's kill zette **band B** aan, niet band A. Op 13 aug
maten we het omgekeerde en schreven het als ANSWERED in `Rares.lua`: onze band vuurde, die van
HandyNotes vuurde *helemaal niet*. Beide metingen kunnen niet compleet zijn.

Drie lezingen staan nog overeind, geen enkele gemeten:
1. **Beide banden vuren**, op verschillende momenten of onder voorwaarden die we niet geïsoleerd
   hebben, en elke meting ving er één.
2. **Band A is de weekly en 98355 stond al aan** vóór de snapshot (eerdere kill deze week) — maar
   dan had diezelfde kill band B ook al moeten zetten.
3. **Het zijn geen twee banden.** HandyNotes zet Venom Lancer en Malformed Leviathan's "band A" op
   96969/96970 in plaats van 98xxx, dus de nette 98344..98355-reeks kan een toevallige volgorde
   zijn in plaats van een categorie.

✅ **Wat er wél overeind blijft van 13 aug, apart genoemd omdat de twee helften heel verschillend
onderbouwd zijn:** *band A reset wekelijks* — zes zones die de dag na een reset 0/15 lezen kan een
permanent vinkje niet. *"Band B vuurt nooit"* is **dood**; dat stond op twee kills in een zone van
twee dagen oud, precies het te-korte-historie-bezwaar dat diezelfde aantekening zelf formuleert.

✅ **GEDAAN:** `/mh rarequests` dekt nu **alle veertien** isle-rares in beide banden in plaats van
zeven in één (`RARE_QUEST_PAIRS`), en de drie plekken die de ingetrokken conclusie als bewijs
citeerden (`Rares.lua` 2×, `AtalUtekProbe.lua` 1×) zijn gecorrigeerd in dezelfde commit.

### ✅ 6 sep — OPGELOST met één kill: band A loopt achter, en de vijf nullen zijn ingevuld

Garsecg was de perfecte proef: hij stond op **beide** banden op `--`, dus een schone eerste kill
zonder iets dat al waar was. Rob nam een snapshot, killde hem, en de twee banden vuurden op
verschillende momenten:

```
/mh questsnap diff, seconden na de kill:   94856  Garsecg      (band B, alléén)
/mh rarequests, een paar minuten later:    A 98350 done · B 94856 done
```

📌 **Band A loopt achter.** Daarmee valt alles op zijn plek: Destra's band A leek 's ochtends "niet
te vuren" omdat hij al aan stond van een eerdere kill, en augustus' *"band B vuurt nooit"* was een
meting in een zone van twee dagen oud, vóór Season 2.

⚠️ **Blinde vlek in ons eigen gereedschap, en die zat er bijna in gebleven:** een `questsnap diff`
direct na de kill ziet band B en mist band A. De tool die een afleiding moest beëindigen had er
zelf bijna een gemaakt. De diff-uitvoer zegt nu zelf dat je hem een paar minuten later nóg een keer
moet draaien.

✅ **INGEVULD** in de datarijen, met per rare erbij hoe hard het is — dat staat in `Rares.lua`, niet
hier, want "ze zitten allemaal in één nette reeks" is geen bewijs over één ervan:

| rare | id | hardheid |
|---|---|---|
| Garsecg | 98350 | **GEMETEN** — `--` vóór de kill, `done` erna |
| Destra | 98355 | leest done, kill bekend. Consistent, niet gezien |
| Hisstara | 98348 | idem |
| Kari'zah | 98346 | idem |
| Szarith | 98349 | **ONGETEST** — nooit gekilld, alleen HandyNotes + de reeks |

⚠️ Venom Lancer en Malformed Leviathan blijven **0**: hun band A (96969/96970) valt buiten de
gevalideerde reeks, ze hebben geen achievement-criterium, en onze eigen aantekening noemt de
Leviathan een *event zonder eigen kill-quest*.

### 🔑 6 sep, LAATSTE STAND — band A is de account, band B is dít character, en de beloning volgt B

Drie metingen op één avond, en de derde draaide de conclusie van de tweede om:

1. Robs alt, die **nooit op de Coiled Isle geweest is**, leest band A als done voor elf rares —
   Garsecg incluis, waarvan de vlag die middag pas aanging na een kill op een ánder character.
   **Band A steekt dus over tussen characters.**
2. Op diezelfde alt leest band B done voor **precies één** rare: Siltmouth, die hij net gekilld had.
   Op de main leest band B een heel andere set. **Band B doet dat niet.**
3. 🔴 **De beloning volgt band B.** De alt killde **Siltmouth terwijl band A "done" zei** en kreeg
   gewoon **50 Coffer Key Shards**.

📌 **Punt 3 is waarom veld [1] nu band B draagt.** Band A lezen betekende: het paneel zette groen,
de route sloeg over en de scanner zweeg — voor rares waar een alt nog gewoon voor betaald wordt.
Drie symptomen van één verkeerde vraag, en precies in de weg bij wat Rob met dat tabblad deed.

✅ **De reparatie is klein gebleken.** Een audit van onze 93 rare-rijen tegen Zygor's kill-regels:
**58 van de 68 vergelijkbare droegen band B al**. Alleen de Coiled Isle stond op band A — de zone
die op 13 aug is toegevoegd, tijdens precies die verkeerde conclusie. Twaalf rijen omgezet, band A
bewaard in een nieuw `acct`-veld (niets leest dat nog; het is gemeten en het is de basis voor een
toekomstige hint *"een ander character van jou deed dit al"*). Nu 68 van 68 gelijk.

⚠️ **Venom Lancer (93722) en Malformed Leviathan (93673) zijn van 0 af**, met HandyNotes' band-B
id — maar **ongeverifieerd**, en zo gemarkeerd in de data. Ze zijn niet slechter dan de nul die er
stond: klopt het id, dan vinken ze af; klopt het niet, dan gedragen ze zich als voorheen.

🔴 **ONGEMETEN EN HET TELT OP WOENSDAG: reset band B wekelijks?** Tot de reset geven beide banden
hetzelfde antwoord, dus er staat nu niets op het spel. Maar is band B **permanent**, dan is dit de
achievement-criterium-bug van 15 aug in nieuwe kleren en wordt een eenmaal gekilde rare nooit meer
aangeboden. Eén `/mh rarequests` ná de reset beantwoordt het: band B hoort dan terug op `--`.

⚠️ **En de teksten zijn vanavond twee keer gedraaid** — eerst naar "hele account", nu terug naar
"dit character". Dat is geen slordigheid maar twee verschillende metingen: bij band A was
accountwide waar, bij band B is per-character waar. De tooltip zegt er nu bij dat een ander
character hem nog kan looten, want dát is de bruikbare helft van de ontdekking.

### ✅ 6 sep — en band A blijkt ACCOUNTWIDE. Onze tekst loog, in zeven talen

Rob logde in op een alt die **nooit op de Coiled Isle is geweest**. Die leest **11/14 done**,
identiek aan zijn main — inclusief **Garsecg**, waarvan de vlag pas diezelfde middag aanging na een
kill op de main. Een per-character vinkje kan dat niet.

📌 **Geen cache-artefact:** `IsRareDoneThisWeek` (`Rares.lua:1099`) leest uitsluitend
`C_QuestLog.IsQuestFlaggedCompleted` — geen `ns.db`, geen opgeslagen main-data. Wat de alt toont ís
dus het antwoord van de client voor dat character.

🔴 **Dus stond er een onwaarheid op het scherm, en niet sinds vandaag.** `RARES_SUBTITLE_FMT` zei
*"done on this character"*, `RARES_TIP_DONE` zei *"Done this week on this character"* en de
Info-lade zei *"green = done on this character"*. Alle drie zijn in **alle zeven talen** herschreven
naar de accountwide-formulering, en de drie keys zijn met `check_drift --mark` vastgelegd (stand
weer 0 gedrift).

⚠️ **Wat hiermee NIET gemeten is:** of de *beloning* ook accountwide is. Dat een tweede kill op
hetzelfde character niets geeft is gemeten (5 sep); of een verse alt wél een shard krijgt van een
rare die de main al deed, is dat niet. Zolang dat open staat is "af" de veilige weergave — maar wie
ooit shard-farmen over alts wil adviseren, moet dit eerst meten.

📌 **En het herschrijft de vraag van vanochtend.** *"Waarom pikt de scanner die rare niet op"* had
twee oorzaken die op elkaar leken: het permanente achievement-criterium (opgelost) én dit. Beide
lieten een openstaande rare als gedaan zien; alleen de eerste was een bug in onze code.

### ❌ 6 sep — farm-modus voor rares: GEBOUWD EN WEGGEGOOID vóór de commit

Rob wilde 600 Coffer Key Shards uit rares halen en vroeg om een schakelaar die ook al-gedane rares
aanbiedt. Gebouwd (`RareAvailable` + instelling + teksten), en toen ingetrokken.

🔴 **De premisse klopte niet, en Rob heeft hem zelf omvergeworpen.** Ik schreef "herhaalde kills
betalen" op grond van zijn *"net gekilled en de shard gekregen"*. Hij onderbrak: **het was zijn
eerste kill van een nieuwe week** — dus dat was gewoon de weekly. Daarna maat hij het echte geval:
**tweede kill in dezelfde week → geen shard.**

📌 **De functie zou dus actief schade doen:** een route naar rares die niets meer opleveren, verkocht
als farm-hulp. Weggegooid vóór de commit, niet achteraf gerepareerd.

📌 **Wat dit wél opleverde:** de vraag "waarom kreeg ik geen alert" bracht de permanente-vinkje-bug
hierboven aan het licht, die veel erger is. En het is de tweede keer op één dag dat ik een claim uit
Robs woorden afleidde in plaats van uit een meting — zie ook de Prey-catch-up hieronder.

🗄️ **Hoe hij eruitzag, mocht de spelregel ooit veranderen:** een `RareAvailable(rare)` die
`IsRareDoneThisWeek` overslaat als de schakelaar aanstaat, gebruikt in `FindNearestIncompleteRare`,
`NearestOpenRareRespectingSkips`, `BuildGreedyRareRoute` en de alert-scan — bewust **alleen aan de
aanbod-kant**. De voltooiings-kant (`IsRareHuntActive`, het doorschuiven van de pijl na een kill, de
"x gedaan"-teller) moest het echte weekvinkje blijven lezen, anders krijg je een route die nooit
doorschuift en een hunt die nooit eindigt.

⚠️ **Zou iemand dit terugwillen, dan eerst opnieuw meten of een herhaalde kill iets oplevert.** Dat
is de enige vraag die telt, en het antwoord was op 6 sep 2026 **nee**.

## 🗄️ 6 sep — de Prey-catch-up raakt Dundun NIET (ingetrokken vóór er iets gebouwd werd)

In het ochtendverslag noemde ik de 12.1.5-catch-up (*"onder rank 3: 4000 Journey progress per hunt;
rank 3-8: 2000 voor je eerste vier hunts per week"*) als iets dat **onze Dundun-tekst raakt**, omdat
die op Journey rank 3 hangt. Rob vroeg wat ik daarmee bedoelde. Nagemeten: **niets.**

* De enige rank-tekst is `DUNDUN_CHAT_RANK_UNKNOWN` — *"alleen als je Delver's Journey rank %d of
  hoger is"*. Dat is de **eis**, en de catch-up verandert alleen het **tempo** waarmee je die haalt.
* `ns.GetDelverJourneyStatus()` (`Delves.lua:2595`) leest de rank **live uit het spel**. Er staat
  nergens een rekensom over hoeveel runs een rank kost.
* Geen enkele geshipte string wordt onwaar.

📌 **De PTR-wachter was voorzichtiger dan ik**: die schreef dat de cijfers "de rekensom voor een
**eventuele** weekly-planner-regel" veranderen — een functie die niet bestaat. Ik maakte daar in het
mondelinge verslag "raakt onze Dundun-tekst" van. Zelfde fout als de regeltelling van vanochtend: de
bron zorgvuldig lezen en er dan een stelliger zin van maken.

⚠️ **Wat er wél overblijft, als aandachtspunt en niet als taak:** haalt iedereen straks veel sneller
rank 3, dan wordt de Dundun-uitleg *vaker* relevant en de "je bent er nog niet"-tak zeldzamer. Dat is
een reden om die uitleg goed te houden, geen reden om hem te wijzigen.

## 🔴 6 sep — DE EERSTE BUG UIT DISCORD, en het is dezelfde fout voor de derde keer

**Yberamos** meldde hem via `/mh report` — de eerste melding van buiten Rob en Cisca. Het rapport
bevatte alles zonder navragen: **3.8.0 · client 12.1.0 (69587) · locale enUS · Devourer Demon
Hunter 90 · party of 2 · Atal'Aman (scenario, Delves)**, plus een screenshot. Die functie is één dag
oud en heeft zich meteen terugbetaald.

**De bug:** in *"Valeera — what to pick"* loopt de voettekst dwars door de laatste slot-regels heen.

📌 **Oorzaak, gemeten:** `FOOT_H = 44` is een **constante**, en de onderkant van het scrollgebied was
eraan vastgepind (`CurioAdvicePanel.lua:135`). Maar de LENGTE van de voet wordt pas bij het tekenen
bepaald: draagt een slot een `>>`-notitie, dan komt `CURIO_NOTE_DISCLAIMER` erbij — samen ~250
tekens, op deze breedte zes à zeven regels. Alles voorbij 44 pixels groeit omhoog het scrollgebied in.

🔴 **DERDE KEER, DEZELFDE FOUT.** Professions → Overview tekende twee alinea's over elkaar om precies
deze reden (gerepareerd 30 aug, meegegaan in 3.7.3), en het changelog-venster reserveerde 100px voor
een voet die het nooit had opgemeten (`2d37151`). **Het patroon is een vast getal dat de plaats
inneemt van tekst die nog niemand heeft laten uitvloeien** — en het blijft onzichtbaar tot er een
langere zin of een langere taal langskomt.

✅ **Gerepareerd met `FitFoot(f)`**: vraagt de FontString hoe hoog hij écht geworden is, ná het zetten
van de tekst, en verschuift de onderrand van het scrollgebied mee. De lege-voet-tak geeft de ruimte
terug in plaats van een gat van 44px onder een regel tekst. Het venster is schaalbaar en de grip
draait de layout opnieuw bij loslaten, dus smaller maken hermeet vanzelf.

📌 **Yberamos noemde het mechanisme zelf**, en dat scheelde een middag: *"the text ... is anchored
to the bottom of the screen and the text 'you have: ...' ignores it. Therefore, if the window is too
short, they overlap."* Precies goed — en het voegt iets toe dat ik niet had: het gaat niet alleen om
de lengte van de voet, maar net zo goed om de **hoogte van het venster**. Vandaar ook een plafond in
`FitFoot`: past de voet niet in de helft van het venster, dan wordt hij afgekapt in plaats van dat
hij de hele inhoud opeet.

📌 **En Robs eigen test vond een gat in mijn fix:** hij herberekende alleen bij het lóslaten van de
resize-grip, niet tijdens het slepen. Nu ook op `OnSizeChanged` — `FitFoot` is één meting en één
`SetPoint`, goedkoop genoeg om live te draaien waar een volledige hertekening dat niet is.

### ✅ 6 sep — de sweep: één tweede geval, de rest schoon

Rob vroeg om de zoektocht meteen te doen in plaats van op melding vier te wachten. Gezocht op de
échte vorm — een **woordwrappende tekst verankerd aan de onderkant**, met inhoud erboven die een
vast getal als reservering gebruikt. Acht kandidaten, één echt geval:

🔴 **`DelveCuriosAdvisor.lua` — de curio-popup, `SetSize(POPUP_WIDTH, 180)`.** Vaste hoogte, met een
wrappende `hint` die naar beneden groeit en een wrappende `reason` die vanaf de onderrand omhoog
groeit. Geen van beide gemeten. Doorgerekend: `10 + 22 + 4 + hint + 6 + 60 + 8 + reason + 12`. Twee
tweeregelige teksten ≈ 170 (past); drie regels elk ≈ 194 (past niet).
📌 **Het faalgeval is een vertaalde client op de nemesis-variant** — die tekst schuift een itemnaam
in de zin, en de/fr/it lopen langer dan het Engels waarin dit ooit met het oog is afgestemd. Precies
het soort geval dat niemand hier ooit ziet.
✅ Gerepareerd met dezelfde discipline als `MidnightToast`: **alleen groeien** (`math.max(180, …)`),
dus elke popup die vandaag past houdt de maat die hij altijd had.

✅ **Schoon bevonden, met reden:** `MidnightToast` mét `GetStringHeight` (groeit al — en dat is
belangrijk, want ík heb die tekst gisteren langer gemaakt), `DelveItemsPopup` (knoplabel binnen een
host), `VaultAdvisor` (`_token`/`_voidcore` stapelen naar boven vanaf de onderrand, niet tegen
inhoud in), `UI.lua` infoBody, `ProfessionGuided`, `LayoutWizard`.

⚠️ **De linter ving een fout van míj**: `FitFoot` stond onder de resize-handler die hem aanroept, dus
daar was hij `nil`. Check [6] zag het vóór Rob het kon zien.

#### 🔴 6 sep, correctie — een plafond op de RESERVERING is geen plafond op de TEKST

Rob sleepte het paneel op zijn kleinst en de overlap kwam meteen terug, mét screenshot.

**Mijn eerste plafond was fout, en het commentaar erboven beweerde iets onwaars:** er stond dat de
voet "dan afgekapt wordt". **Een FontString kapt zichzelf niet af.** Verankerd aan de onderkant met
word wrap groeit hij gewoon door naar boven, voorbij wat het scrollgebied gekregen heeft. Ik had de
overlap dus **verplaatst**, niet weggenomen.

📊 Doorgerekend op `MIN_H`: de voet wil ~107px, mijn plafond gaf 60 — die overige 47 landden op de
slot-tekst. Precies de screenshot.

✅ **Nu wordt het REGELAANTAL begrensd** (`SetMaxLines`), en de reservering begrensd om dat te
volgen. Dan zijn de tekening én de ruimte allebei eindig, en zijn ze het met elkaar eens. Ontbreekt
`SetMaxLines` op een client, dan valt hij terug op "reserveer wat de voet vraagt" — lelijker in een
piepklein venster, maar nooit een overlap.

📌 **De les is niet "meten in plaats van reserveren"** — dat deed ik al. Het is dat een grens op de
ene helft van een paar (ruimte) niets zegt over de andere helft (tekst), en dat een commentaarregel
die "dan wordt het afgekapt" beweert zonder dat iemand dat heeft laten gebeuren, precies zo'n claim
is waar dit bestand vol waarschuwingen over staat.

✅ **BEVESTIGD in het spel** door Rob, op de kleinst mogelijke maat: de voet eindigt op *"Check them
against t…"* — afgekapt met een ellips — en de slot-tekst erboven is volledig leesbaar. Drie rondes
(reserveren → live hermeten → regels begrenzen), elk met een meting van Rob ertussen.

📌 **Voor de melder:** Yberamos vond hem, diagnosticeerde het mechanisme zelf correct, en zijn
`/mh report` bevatte alles zonder één navraag. Dat mag hij horen — het is precies het gedrag dat je
bij een tweede melding terug wilt zien.

#### 🔴 6 sep, de eigenlijke oorzaak — `GetStringHeight` ONDERRAPPORTEERT een wrappende FontString

De vorige "bevestiging" hield geen stand: Rob vond een tussenmaat waar hij tóch overlapte. Zijn
screenshot droeg het beslissende detail — de **slot-tekst** werd correct afgekapt op de scrollrand,
dus die kant klopte; het was de **voet** die eroverheen groeide.

✅ **GEMETEN met `/mh curios fit`** op precies die maat:

```
venster 287 hoog, scrollruimte 247
voet vraagt: 39 px   gereserveerd: 61 px   plafond: 124 px
regelhoogte: 9.85   max regels: 10   begrensd: ja
```

🔴 **39 ÷ 9,85 = vier regels. Er stonden er zeven op het scherm.** `GetStringHeight()` rapporteert
dus minder dan de FontString tekent, en daar kon niets stroomafwaarts van herstellen — het plafond
(124) kwam er niet eens aan te pas.

✅ **Nu telt hij de REGELS** (`GetNumLines() × GetLineHeight()`) en houdt de **grootste** van de twee
maten aan. Te weinig reserveren geeft een overlap; te veel kost alleen wat scrollruimte — dus bij
onenigheid is de grootste het veilige antwoord. Beide getallen blijven apart in `_fit` staan en
worden allebei geprint, want ze samenvatten tot één winnaar zou precies deze vondst hebben verborgen.

🔴 **EN DIE CONCLUSIE WAS ZELF FOUT — ingetrokken dezelfde ochtend.** Rob printte `/mh curios fit`
op **twee** maten in plaats van één, en dat besliste het:

```
venster 317 hoog:  GetStringHeight 39   ·   4 x 9.8 = 39
venster 160 hoog:  GetStringHeight 59   ·   6 x 9.8 = 59
```

**Beide metingen zijn het op beide maten eens.** `GetStringHeight` heeft nooit gelogen — ik had de
regels op een screenshot verkeerd geteld en die telfout als meting in dit bestand gezet. 📌 Precies
de fout waar `never-assume-always-factcheck` over gaat, en deze keer in een bestand dat pretendeert
metingen te bewaren.

✅ **De echte oorzaak stond één regel lager in diezelfde uitvoer: `max regels: 3` terwijl de voet er
6 tekent.** `SetMaxLines` klipt deze FontString gewoon niet. Daardoor reserveerde het plafond 60px
voor een voet die er 71 verft — en dát is de overlap.

✅ **Reparatie: niet de tekst kleiner maken maar het VENSTER eerlijk.** `SetResizeBounds` wordt nu
uit de meting berekend, dus het paneel kan niet kleiner gesleept worden dan titel + één leesbare
regel + zijn eigen voet. De ondergrens volgt de tekst, dus ook een taal met een langere voet. Geen
klippen, geen plafond, niets dat het met zichzelf oneens kan zijn.
⚠️ `SetMaxLines` is **verwijderd** in plaats van als extra zekerheid blijven staan: een aanroep die
aantoonbaar niets doet is erger dan geen aanroep, want de volgende lezer neemt aan dat hij werkt.
⚠️ Een opgeslagen venstermaat van vóór deze ondergrens blijft op schijf staan, en `SetResizeBounds`
verkleint een bestaand venster niet — daarom wordt de hoogte ook eenmalig bijgetrokken.

📌 **Vier pogingen, en drie ervan waren op zichzelf juist.** Meten, live hermeten, regels begrenzen —
allemaal goed, allemaal onvoldoende, omdat de fout ergens anders zat. Wat het besliste was Robs
keuze om op **twee** maten te meten in plaats van op één; één meting had elke verkeerde theorie nog
steeds gepast.

#### ✅ 6 sep, de vijfde en laatste: de voet verhuist de scroll-inhoud in

Ook de vloer hield geen stand. Robs meting: **`ondergrens 160`** — dat is gewoon `MIN_H`. De vloer
werd berekend terwijl het venster **breed** was en de voet maar 3 regels; sleep je hem smal, dan
groeit de voet en is de vloer al gezet. Weer de goede gedachte, weer de verkeerde plek.

🔴 **Alle vijf pogingen deelden één aanname: dat de voet vastgeplakt hoort aan de onderrand, en dat
de scroll dan "de rest" krijgt.** Dat is de fout. Twee helften met elk hun eigen regels, die alleen
overeenkomen als de rekensom toevallig uitkomt.

✅ **De voet is nu de LAATSTE RIJ van de scroll-inhoud.** Hij wrapt naar wat hij nodig heeft,
`content:SetHeight` telt hem gewoon mee, en het scrollvenster knipt alles op dezelfde manier af.
**Overlappen is hier geen mogelijkheid meer** — er valt niets te reserveren, dus ook niets verkeerd
te reserveren. `FOOT_H`, `SetMaxLines`, het plafond, de `OnSizeChanged`-hermeting en de berekende
vloer zijn alle vijf weg.

⚠️ **De prijs, hardop:** in een laag venster scrolt de disclaimer uit beeld in plaats van altijd
zichtbaar te zijn. Dat is de eerlijke helft van de ruil — een disclaimer waar je naartoe scrolt is
meer waard dan een die dwars door het advies erboven staat, en dat laatste is wat een eerste
gebruiker meldde.

📌 **Zes rondes op één layoutfout.** Wat elke ronde kostte was dat ik een aanname repareerde in
plaats van hem te betwijfelen. Rob dwong het af door te blijven meten op maten die ik niet had
geprobeerd.

✅ **BEVESTIGD op de kleinste maat**: inhoud netjes afgeknipt op de scrollrand, voet eronder
weggescrold, geen overlap.

#### 💡 6 sep — Robs vraag erna, en hij raakt een echt gat

*"Kan het komen dat iedereen de schermen groter en kleiner kan scrollen, net zoals de tekstgrootte?"*

📌 **Voor de oude constructie: ja, en dat was precies de reden dat hij zo bros was.** Een grotere
UI-schaal of een groter lettertype maakt de voet hoger terwijl `FOOT_H = 44` een constante bleef —
dus elke speler met een andere schaal dan de onze zat dichter bij de overlap. De nieuwe opzet is
daar ongevoelig voor: hoe hoog de voet ook wordt, hij is gewoon een rij in de inhoud.

🔴 **En het legde een aparte inconsistentie bloot. GEMETEN:** dit paneel gebruikt kale
Blizzard-fonts (`GameFontNormal`, `GameFontHighlight`, `GameFontHighlightSmall`) en **niet**
`ns.MHScalableFont`. De tekstgrootte-schuif in onze eigen instellingen doet hier dus **niets**,
terwijl het hoofdvenster hem wél volgt. Wie zijn tekst groter zet, krijgt een hoofdvenster dat
meegroeit en een curio-paneel dat blijft zoals het was.

✅ **GEREPAREERD op Robs verzoek, en de volgorde was gunstig:** vóór de verhuizing van de voet zou
een groter lettertype de overlap juist vaker hebben getriggerd; nu kost het hooguit meer scrollen.
De rijen én de voet volgen nu `ns.MHScalableFont`.

⚠️ **De TITEL bewust NIET.** `TITLE_H = 26` is een vaste reservering tussen de bovenrand en het
scrollgebied — exact dezelfde "constante die de plaats inneemt van ongemeten tekst" die vandaag zes
rondes kostte. Die string schalen zonder óók die reservering te meten zou de bug één anker hoger
opnieuw bouwen. Staat als zodanig in de code.

✅ **BEVESTIGD door Rob**: tekstgrootte verzetten laat het curio-paneel nu meegroeien, regels blijven
uit elkaar, titel ongewijzigd.

📌 **En één ding dat er nog bij hoorde:** `ns.ApplyContentFontScale` verandert het lettertype maar
niet de layout eromheen. Een paneel dat zijn rijen op gemeten hoogte stapelt moet daarna opnieuw
uitlijnen, anders staat het nieuwe font in de ruimte van het oude. De schuif ververst het
curio-paneel nu zelf (geguard, weigert netjes als het dicht is).

## ✅ 5 sep — `GetItemCooldown` afgedekt vóór 12.1.5 live gaat

De API-wachter vond het enige punt uit de hele 12.1.5-reeks dat op live een **echte Lua-fout**
geeft: `GetItemCooldown` zit in `Blizzard_DeprecatedItemScript` en wij riepen hem **drie keer kaal**
aan — `Delves.lua` 2× (hearthstone-cooldown in de reis-popup) en `DelveItemsPopup.lua:275`. Geen
guard, geen `pcall`, geen terugval.

⚠️ En `DelveItemsPopup` hád al een complete `C_Container`-terugval, direct ónder die regel — die
zou dus nooit bereikt zijn, want de fout valt erboven. **Een fallback achter de crash is geen
fallback.** Nu wel bereikbaar.

`ns.GetItemCooldownSafe(itemID)` probeert **`C_Item.GetItemCooldown` eerst**, dan de kale global,
allebei in een `pcall`, en geeft `nil` als geen van beide bestaat — wat elke caller als "onbekend"
moet lezen, nooit als "geen cooldown". Zelfde vorm als de zeven andere ItemScript-globals die al
afgedekt waren. Op 12.1.0 verandert er niets.

🔴 **NIET GEMETEN: bestaat `C_Item.GetItemCooldown`?** De migratie is letterlijk geciteerd uit
Blizzards eigen bron, maar niemand heeft hem in een client gezien. `C_Item` staat nu in de
`WATCH_TABLES` van `/mh ptr`, dus één run op de 12.1.5-PTR settelt het — en zegt tegelijk of de
kale global daar al weg is.

✅ **En één vermoeden ingetrokken:** `SocketInventoryItem` zit **niet** in
`Blizzard_DeprecatedItemSocketInfo` (de nu gepubliceerde lijst telt dertien functies en hij staat er
niet bij). Dat bevestigt wat we 4 sep op de PTR maten; het "verdacht op grond van de naam" mag weg.

## ✅ 5 sep — de level-waarschuwing is er, optie A, en opvallend

Rob koos **A** (waarschuwen, route wél zetten) met één aanvulling: *"maar opvallend waarschuwen!!"*
en *"een soort overal MH check, van hé je bent nog niet hoog genoeg om daarheen te gaan"*.

`Modules/ZoneLevelGate.lua` haakt in op **`ns.AddSmartTomTomWay`** — de deur waar vrijwel elke
route doorheen gaat, dus één plek in plaats van 29. De route wordt gewoon gezet; er komt een
**toast van 20 seconden** bij plus een chatregel om terug te vinden.

📌 **De drempel komt uit `ns.GetTargetRegionGroupID`**, dezelfde functie die 4 sep gerepareerd is —
inclusief de x-slice op canvas 2576. Geen tweede kaarttabel die van de eerste kan afdrijven.

**Wat online gemeten is (Rob vroeg erom):**
| | level |
|---|---|
| Midnight intro-questlijn | **78** (twee onafhankelijke bronnen) |
| Eversong Woods | 80-82 |
| Zul'Aman · Harandar | 82-88 |
| Voidstorm | 88-90 |
| eindlevel | 90 |

⚠️ **De drempel is per REGIO en bewust de laagste van die regio** (Quel'Thalas 80, Harandar 82,
Voidstorm 88). Een per-zone tabel zou map-ID's vereisen die we NIET rond hebben —
`GetBaseZoneName(2395)` antwoordt nog altijd "Zul'Aman" voor wat op Eversong lijkt, open sinds
augustus.

🔴 **NIET GEMETEN: houdt het spel je fysiek tegen?** Dat staat sinds 3 sep als open vraag in
`TESTLIJST.md`. Daarom zegt de tekst *"dit gebied is afgestemd op level X en jij bent Y"* en nooit
*"je kunt daar niet heen"* — dat laatste kan de speler ter plekke weerleggen door binnen te lopen.

⚠️ **Throttled per doelzone (120 s)**, want een bulk-route publiceert een dozijn waypoints tegelijk
en een dozijn identieke toasts leert je ze weg te klikken zonder te lezen.

📌 **INTREKKING van mijn eigen advies van 4 sep.** Ik noemde `CHANGELOG_260_3` "aantoonbaar onwaar"
en zei dat hij hoe dan ook opgelost moest. Bij herlezing gaat die zin over **Home / Next up** ("Home
now leads with 'Next up' … **it** never points you at endgame content"), en dáár klopt hij sinds
3 sep. Ik las er een addon-brede belofte in die er niet staat. Bovendien is het een changelog-regel
van 2.6.0 — een historisch verslag, geen lopende garantie. **Niet aanpassen.**

`/mh zonegate` toont per regio wat deze character zou krijgen, ook op max level waar hij nooit
vuurt.

### ✅ 5 sep, na Robs test op zijn 69: geluid + een schakelaar voor optie B

Twee dingen kwamen terug uit de test, en allebei zijn ze gebouwd:

1. **Geluid** (`7ea1388`). *"Kan de toast ook een duidelijk geluid spelen??"* — `SOUNDKIT.READY_CHECK`,
   dezelfde die `ShardCapAlert` gebruikt. Hergebruikt in plaats van een nieuwe keuze: die is gemeten
   hoorbaar op het Master-kanaal bij laag SFX-volume, en "Midnight Helper wil je iets zeggen" één
   geluid houden is meer waard dan een eigen deuntje per functie.
2. **Schakelaar voor optie B.** *"Maak die schakelaar maar en zet hem standaard op uit zodat mensen
   bewust kiezen om hem wel te krijgen."* → `SET_ZONEGATE_BLOCK_TITLE`, Instellingen → Route-pijl,
   **standaard uit**. Uit = wat iedereen nu al heeft (waarschuwen én routeren), dus een update
   verandert niets onder iemands handen. Aan = de route wordt geweigerd.

⚠️ **Twee dingen die de bouw stuurden, en die bij een volgende wijziging blijven gelden:**
* **De 120-seconden-throttle geldt NIET bij weigeren.** Een klik die geen route zet én niets zegt is
  van buiten precies hetzelfde als kapot — de fout die CLAUDE.md van 3 sep beschrijft. Weigeren is
  het geval dat altíjd moet spreken.
* **Bij weigeren keert `AddSmartTomTomWay` terug vóór `ns.lastTarget`.** Een route die we afwijzen
  mag geen doelwit achterlaten voor de pijl, de reisassistent of een latere refresh.

📌 **De waarschuwing zelf is niet uit te zetten.** Die is er juist gekomen omdat ze ontbrak; alleen
wat erna gebeurt is een keuze.

✅ **VERTAALD 5 sep — alle acht sleutels in zeven talen.** `ZONEGATE_TITLE_FMT`, `_BODY_FMT`,
`_STILL_ROUTED`, `_BLOCKED`, `SET_ZONEGATE_BLOCK_TITLE`, `_DESC`, `LEVELBAR_BELOW_ENTRY_FMT` en
`PLAN_DETAIL_CAPITAL_PORTAL` staan nu in `Translations2026.lua` voor de/fr/es/pt/it.
`check_drift.py`: **0 gedrift**, alle zes de talen.

📌 **Het menupad in `ZONEGATE_BLOCKED` is niet verzonnen maar opgezocht.** Er bestond geen precedent
in de vijf packs (alleen changelog-regels, en die blijven Engels), dus het woord voor "Instellingen"
komt uit `TOUR_SETTINGS_TITLE` per taal en de sectienaam uit het al vertaalde `SET_SEC_ARROW` —
zodat het pad klopt met wat de speler daadwerkelijk op zijn scherm ziet.

⚠️ **Deze vertalingen zijn van ONS**, niet van een moedertaalspreker nagekeken. Verschijnt er ooit
iemand voor een taalronde, dan is dit een van de plekken om te laten kijken. `Silvermoon` en
`Midnight Helper` blijven Engels (eigennamen).

### 🔴 5 sep, tweede testronde: één echte bug, één open meting, één nieuwe balk

**1. De eigen waypoints zetten geen route.** Rob: *"bij de omnium folio enz geen tomtom added a
waypoint"*. De level-waarschuwing kwám wél, dus de functie liep — wat níét gebeurde was het
waypoint. Diezelfde sessie zette `ns.AddSmartTomTomWay` wél een pijl naar The Darkway, in
diezelfde stad.

📌 **Niet het tweede routepad gaan repareren, maar weghalen.** `CurrencyGuide`, `OmniumFolio` en
`TierSet` gaan nu door `ns.AddSmartTomTomWay`, met hun oude `SlashCmdList["TOMTOM_WAY"]`-pad als
terugval voor als `Delves.lua` ontbreekt. Dat is precies de conclusie die de vorige commit al
opschreef en toen niet doortrok: drie privé-kopieën van de routering die elk apart alles moesten
leren, en er is er minstens één die iets nooit geleerd heeft.
⚠️ `DelveTipMarkup:668` gebruikt hetzelfde slash-pad, maar alleen als terugval wanneer
`AddSmartTomTomWay` er niet is — daar hoeft niets aan.

**2. Geen geluid, en drie mogelijke oorzaken die er identiek uitzien.** `SOUNDKIT.READY_CHECK`
bestaat niet op deze client / `PlaySound` weigert / het speelt en is onhoorbaar. **NIET GOKKEN** —
`/mh zonegate test` print nu wat elke stap teruggaf (`willPlay`, `handle`) en vuurt daarna de echte
toast door dezelfde deur, met de throttle geleegd. Antwoord verwacht van Rob.

**3. De rode balk boven in het venster.** Robs idee: *"wanneer iemand onder lvl 78 is standaard een
soort rode balk boven aan de addon."* Gebouwd in `UI.lua` (`ns.mhLevelBar`), tussen de
favorietenrij en de inhoud, ververst op `PLAYER_ENTERING_WORLD` en `PLAYER_LEVEL_UP`.

⚠️ **78 is bewust een ánder getal dan de 80 van de Silvermoon-banner.** 80 is Blizzards eigen
aankondiging (waar Eversong/Silvermoon op afgestemd zijn); 78 is waar de intro-questlijn opengaat,
uit twee gidsen plus Robs eigen lezing. Twee claims van verschillende sterkte, dus twee getallen —
`ns.MidnightEntryLevel` naast `REGION_MIN_LEVEL`.

📌 **En de balk claimt iets over ONS, niet over het spel:** "Midnight Helper is gemaakt voor 78 en
hoger." Of het spel een level-70 fysiek tegenhoudt is nog steeds ongemeten, en deze zin hangt daar
niet van af. Er wordt niets verborgen of uitgezet.

### ✅ GEMETEN 5 sep — de ontbrekende TomTom-pijl was géén bug, en ik zei twee keer het tegendeel

Rob, vanuit **The Azure Span** (Dragon Isles), klikte de Catalyst aan en meldde *"geen tomtom
pijlen !!"*. `/mh arrow` gaf het antwoord in vier regels:

```
jij:  map 2024 (continent 2444)
doel: map 2393 (continent 0)      een ligt in de ander: nee
TomTom actief: ja   zijn pijl zichtbaar: nee
wij sturen: ja      onze pijl getekend: ja      zichtbaar: ja
```

**TomTom weigert een pijl naar een ander continent**; onze eigen pijl neemt het dan over, precies
zoals bedoeld, en Rob bevestigde met een screenshot dat die er stond. Continent `0` is trouwens
gewoon Eastern Kingdoms' instance-id, geen leesfout.

🔴 **Twee keer op rij een verkeerde diagnose, met dezelfde vorm.** Eerst *"echte bug, gevonden"*
over Omnium Folio/TierSet — het ontbreken van de pijl had niets met die knoppen te maken. Daarna
*"volgens de meting hoort er een reispopup te zijn"* — de diagnoseregel zegt alleen dat regiogroep
0 de popup niet ONDERDRUKT; hij heeft nog steeds een portaal- of Hearthstone-knop nodig om iets te
tónen, en die zijn er hier geen van beide. **Een regel die zegt "dit blokkeert het niet" is geen
regel die zegt "dit gebeurt".**
📌 Beide keren stond het bewijs al in Robs eerdere screens: *"is not on this continent"* verscheen
vanochtend al bij The Darkway, mét een werkende route.

⚠️ **De verhuizing naar `ns.AddSmartTomTomWay` blijft goed** (één routepad in plaats van drie, en
ze krijgen de reishulp mee) — maar hij heeft niets gerepareerd, en zo hoort hij ook beschreven te
worden.

### 🔴 OPEN — hoe kom je überhaupt IN Midnight als je er niet bent?

`MIDNIGHT_PORTALS` bevat **uitsluitend** portalen ín Midnight (2393/2405/2413/2576). Sta je op de
Dragon Isles, dan is er dus geen enkel antwoord: geen popup, geen knop, en een chatregel *"head for
Sanctum of Light first"* die niet vertelt hóé. Dat is correct gedrag van code die de weg niet kent
— en het is precies de situatie van elke levelende speler, dus van iedereen die de nieuwe rode balk
te zien krijgt.

📌 **Rob stelde deze vraag al op 3 sep, vanaf dezelfde plek**: *"kan die daar al heen dan, en hoe
dan?"* (zie `ResetRoutine.lua:304`). Toen is de weekly-kop gerepareerd, niet de reisvraag.

#### ✅ 5 sep — uitgezocht, en het is géén portaal maar een quest

Rob: *"zoek maar uit waar de portals zijn via Zygor denk ik, en anders moet er online wel een list
zijn toch?"* Beide gedaan. Wat er nu vaststaat, met de bron erbij:

| wat | waar | bron | hard? |
|---|---|---|---|
| Start van de campagne | **Stormwind 53.26, 54.32** (A) · **Orgrimmar 53.43, 77.32** (H) | `ZygorLevelingCommonMID.lua:8-44` | ✅ GEMETEN in bestand |
| De NPC | Image of Lady Liadrin (241677), quest **Midnight ##91281** → **A Voice from the Light ##88719** | idem | ✅ |
| Hoe je er kómt | item **Light's Summon ##239151** — "Travel to Quel'Danas" | `:46-47` | ✅ |
| Intro overslaan | gossip 138201, alleen met achievement **42045** | `:23, :42` | ✅ |
| Silvermoon → hoofdstad | SMC **53.33, 66.24** (portaalkamer rechts van Wayfarer's Rest) | method.gg | ✅ extern |
| Hoofdstad → Silvermoon | *"in the capital's portal room"* — **coördinaat ONBEKEND** | idem, zonder cijfers | 🔴 NIET GEMETEN |

🔴 **DE BELANGRIJKSTE VONDST: de weg naar binnen is geen portaal.** Het is een questlijn die
automatisch start in je hoofdstad, met een summon-item. Voor precies de speler waar de rode balk op
mikt — onder 78, ergens in oude content — is *"loop naar Lady Liadrin in Stormwind"* het juiste
antwoord, en een portaal-coördinaat zou dat niet eens zijn.
📌 Dat betekent ook dat `MIDNIGHT_PORTALS` waarschijnlijk de verkeerde tabel is voor dit probleem:
de eerste stap is een quest-gever, geen portaal.

#### ✅ 5 sep, een uur later: Rob heeft het gemeten, en het beantwoordt óók de vraag van 3 sep

Drie metingen van zijn eigen client, op een **level-70** Horde-paladin:

| meting | uitkomst |
|---|---|
| `/mh coord` bij het portaal | **map 85 (Orgrimmar) 56.25, 88.57 → Silvermoon** |
| Image of Lady Liadrin | **map 85, 53.37, 77.35**, npc **241677** — bevestigt Zygors 53.43/77.32 |
| Biedt zij de campagne aan op 70? | **NEE** — alleen een filmpje, geen quest |
| Kon hij door het portaal? | 🔴 **JA. Hij liep Silvermoon binnen op level 70.** |

🔴 **DAARMEE IS DE VRAAG VAN 3 SEP BEANTWOORD: het spel houdt je NIET tegen.** Die stond als
"NIET GEMETEN" in `ZoneLevelGate.lua`, in `TESTLIJST.md` en in twee van mijn eigen antwoorden.
De voorzichtige formulering — *"dit gebied is afgestemd op level X en jij bent Y"* en nooit *"je
kunt daar niet heen"* — blijkt dus niet alleen netjes maar ook **waar**. Was het andersom
geschreven, dan had Rob het vanmiddag met één portaalsprong onderuit gehaald.
⚠️ **Nooit terugdraaien.** De comment in `ZoneLevelGate.lua` legt uit waarom.

📌 **Twee verschillende poorten, en dat verschil moet zo blijven.** De GROND is open voor iedereen
die er kan komen; de CAMPAGNE is gelevelgated (op 70 geen quest). Laat een toekomstig "de intro
vraagt 78" nooit weglekken in een zin over een zone binnenlopen.

✅ **Portaal toegevoegd** aan `MIDNIGHT_PORTALS` (`Delves.lua`), het eerste item in die tabel dat
niet zélf al in Midnight ligt. Vanuit Orgrimmar krijgt een speler nu wél reishulp naar elk
Midnight-doel — als hub-portaal ook naar Harandar en Voidstorm.

⚠️ **Nog te meten: de Stormwind-kant.** Rob is Horde, dus die coördinaat heeft niemand. Geen entry
tot iemand hem meet; het paar "netjes" maken door de Alliance-kant te raden is precies de fout waar
dit bestand vol commentaar over staat.

#### ✅ 5 sep, direct erna: de reisplanner kende het hub-portaal niet, de popup wél

Rob stond in Orgrimmar, klikte een delve in **Eversong Woods** aan. De popup had gelijk (*"Use:
Portal to Silvermoon (105yd)"*) — **de pijl stuurde hem 354 m naar de flight master van
Orgrimmar**. Vanuit Orgrimmar kun je niet naar Eversong vliegen.

📌 **Twee antwoorden op één vraag op één scherm, en de verkeerde tekende de pijl.** Oorzaak: de
popup in `Delves.lua` accepteert al een portaal naar de **hub** als er geen portaal recht naar het
doel gaat (`hubPortal`); `BuildTravelPlan` deed dat niet — die eist `p.toID == outermost`, en niets
gaat naar Eversong. Plan leeg → `RouteFirstToFlightPoint` zag geen eerste stap om voor te wijken →
vlieg-heuristiek won.

✅ **Gerepareerd in `TravelPlan.lua`**: als geen portaal rechtstreeks naar het doel gaat, telt een
portaal op je huidige kaart naar **Silvermoon (2393)** ook als stap — maar alleen als het doel écht
in Midnight ligt, gevraagd aan `ns.GetTargetRegionGroupID` (regio 0 = onbekend = geen portaal).
Dezelfde functie die de levelwaarschuwing en de reisonderdrukking al gebruiken, geen tweede idee
van waar Midnight ligt.

⚠️ **Dit is dezelfde vorm als de fout van vanmiddag**: twee implementaties van één vraag, waarvan de
kortste het slechtere antwoord uitstuurt. Staat als waarschuwing al in `DelveTipMarkup.lua:274`.

#### ✅ 5 sep — de bovengrens uit de waarschuwing gehaald, op Robs vraag

Rob las zijn eigen toast: *"waarom tot lvl 88, terwijl je die ook kunt doen als je lvl 90 bent? En
82 is advies denk ik en geen harde eis toch?"* Twee keer raak.

🔴 **"80-88" is de LEVEL-band** — het bereik waarin de zone meeschaalt terwijl je omhoog gaat — en
op 90 speel je er nog elke week. Een zin die op 88 eindigt leest als een houdbaarheidsdatum op
content die er geen heeft. **`REGION_BAND` is verwijderd, niet gecorrigeerd:** alleen de ondergrens
was ooit dragend (de beslissing gebruikte altijd al `REGION_MIN_LEVEL`), de band was decoratie op de
tekst en precies de helft die verkeerd te lezen was.

✅ **En het "geen harde eis" staat er nu ronduit**, want dat is sinds vanmiddag gemeten in plaats
van vermoed: *"Niets houdt je tegen om er in te lopen — maar de vijanden daar zijn ver boven je."*
Dat verving *"Kijken kan gewoon"*, dat het alleen suggereerde.

⚠️ `ZONEGATE_BODY_FMT` wisselde van `%s / %s / %d` naar `%s / %d / %d` — bij een vertaling naar
de/fr/es/pt/it moet dat middelste veld een **getal** blijven, geen bereik.

#### ✅ 5 sep — de portaalknop-test klopt, maar mijn verklaring ervoor was fout

Rob, bij stap 5: *"welke waarschuwing bedoel je?"* Terechte vraag: hij krijgt géén nieuwe
waarschuwing van de portaalknop, en dat is precies goed.

🔴 **Maar de reden die ik op 5 sep in de commit `e707298` opschreef klopt niet.** Daar stond dat
`Delves:3682` (de portaalknop) *"deliberately excluded via `_mhTravelLegBusy`"* was. Nagemeten:
die vlag wordt **uitsluitend** in `DelveTipMarkup` gezet. De knop roept `TomTom:AddWaypoint`
**rechtstreeks** aan en komt dus nooit bij de bewaakte deur — hij hoeft er niet van uitgezonderd te
worden, hij bereikt hem niet. Zelfde uitkomst, verkeerd mechanisme.
📌 En een verkeerd mechanisme is waar een latere wijziging over struikelt: wie `_mhTravelLegBusy`
ooit opruimt zou denken dat hij hiermee de portaalknop raakt. De juiste reden staat nu bij de knop
zelf (`Delves.lua`, boven `portalBtn:SetScript("OnClick", …)`).

⚠️ **Voor de test betekent dit:** de toast die Rob zag hoort bij de **delve** waarop hij klikte,
niet bij de knop. Wil je het zuiver zien, wacht dan >2 minuten (de throttle) na die klik en druk
dán pas op de portaalknop — er hoort niets te komen.

### ✅ 5 sep — Dornogal, en Robs ontwerpvraag beantwoord zonder één nieuwe coördinaat

Rob liep *"even eigenwijs"* met zijn 70 naar **Dornogal** en vroeg een delve-route. Zelfde
doodlopende antwoord als in The Azure Span: *"head for Sanctum of Light"*. En hij stelde meteen de
goede vraag: *"kunnen we dit soort problemen niet afhandelen zonder allerlei testen te doen voor
coords ed, of wordt de addon dan wel heel erg belast?"*

**Nee, dat kost niets, en meer coördinaten was ook het verkeerde antwoord.** Twee reparaties, allebei
zonder nieuwe data:

1. 🔴 **De vlieg-terugval vroeg nooit of je er wel héén kunt vliegen.** Sanctum of Light is een echte
   flight point en volstrekt onbruikbaar vanuit Dornogal of de Dragon Isles. `ns.IsCrossContinentTarget`
   bestond al en was al gemeten; de terugval riep hem simpelweg niet aan. Nu wel — en dit is de
   werkelijke oorzaak van *beide* meldingen van vandaag.
2. ✅ **"Ga naar je hoofdstad" is het enige antwoord dat géén kaartdata nodig heeft.** Elke weg naar
   Midnight loopt via een hoofdstad, iedereen kan zijn eigen hoofdstad al bereiken, en zodra je er
   staat neemt `MIDNIGHT_PORTALS` het over. De stap is dus een **naam**, geen plek: geen rij per
   expansie-hub, niets te hermeten als Blizzard een portaal verplaatst.

📌 **De naam komt uit `C_Map.GetMapInfo`**, dus hij klopt in alle zeven talen zonder eigen vertaling.
Faliekant misgaan kan niet: lukt de lookup niet, dan komt er **geen** stap — zwijgen is wat dit
bestand sowieso verkiest boven een geraden hop.

#### ✅ 5 sep — de zwarte pijl die altijd omhoog wees

Rob, meteen na de reparatie hierboven: *"het is een statische pijl die altijd naar boven wijst, is
dat niet fout??"* Ja, en het was een echte bug — niet de weigering om een richting te tekenen, maar
wat er bleef staan.

🔴 **Onze pijl bestaat uit DRIE texturen** (`f.tex` gekleurd, plus `f.texOutline` en `f.texGlow`,
alle drie `MinimapArrow`), en de "ander continent"-tak verstopte er **één**. De outline bleef dus
staan op de rotatie die hij toevallig had — recht omhoog als er nooit een richting was.

📌 **Een pijl is een bewering over richting.** Niet berekenen over continenten heen is bewust en
juist; een vorm laten staan die er tóch uitziet als het antwoord haalt precies die zorgvuldigheid
weer onderuit, en leest voor de speler als "naar het noorden".

⚠️ **Zelfde vorm als de waarschuwing die al in `Delves.lua` staat**: een gate op één van meerdere
identieke broertjes geeft een deel van de tijd het verkeerde antwoord. Komt er ooit een vierde
textuur bij deze pijl, dan moet die hier óók verborgen worden — dat staat nu bij de code.

#### ✅ 5 sep — de hele keten bevestigd in het spel (Horde)

Rob liep hem af en meldde per stap:

1. **Dornogal**, delve-route → geen pijl meer, alleen *"The Gulf of Memory (ander continent — reis
   terug) head for Orgrimmar"*. De zwarte omhoog-pijl is weg.
2. **Orgrimmar**, zelfde route → reis-popup mét portaalknop, en de pijl naar het portaal
   (56.25/88.57). *"En die werkt :)"*

📌 Daarmee is de vraag waar de dag mee begon — *"ik krijg routes voor dingen die ik nog niet kan
doen"* — van klacht naar werkende keten gegaan: waarschuwen, niet blokkeren, en zeggen hóé je er
komt. Alle drie zonder één extra tabelrij behalve het gemeten Orgrimmar-portaal.

#### 🔴 OPEN — Alliance komt één stap tekort, en dat is te meten

Robs vraag: *"en wat als ik een alliance ben?"* Eerlijk antwoord, per stap:

| waar | Horde | Alliance |
|---|---|---|
| Buiten Midnight (bv. Dornogal) | *"Go to: Orgrimmar"* ✅ | *"Go to: Stormwind City"* ✅ (naam uit de client) |
| In de hoofdstad zelf | portaal-stap + pijl, 105 yd ✅ | **niets** — geen rij in `MIDNIGHT_PORTALS` 🔴 |

✅ **Het portaal bestáát**: Wowhead kent `object=584668` *Portal to Silvermoon City* met Stormwind
City in de vindplaatsenlijst. **Maar geen enkele bron geeft een coördinaat**, en Method noemt alleen
*"the capital's portal room"*. Dus geen rij tot iemand het meet — één `/mh coord` van een
Alliance-character.

⚠️ **En let op de tweede helft:** Stormwind en Silvermoon zitten allebei op Eastern Kingdoms
(continent 0), dus daar is `crossContinent` **false** en valt de planner terug op de vlieg-tip —
precies de "Sanctum of Light"-onzin die we vandaag elders juist hebben afgevangen. Bij Orgrimmar
speelt dat niet (Kalimdor vs EK). **Niet blind repareren:** of je van Stormwind naar Quel'Thalas kán
vliegen is ongemeten, en dat bepaalt of die tip daar fout is of juist goed.

✅ **Wel meteen afgedekt:** de hoofdstad-stap vuurt niet meer als je er al staat
(`capitalMap == here`). Zelfde fout als 3 sep, toen iemand in Harandar naar het Portal to Harandar
werd gestuurd.

⚠️ **Alleen 84 en 85 staan in `FactionCapitalMap()`.** 85 (Orgrimmar) is gemeten uit Robs eigen
`/mh coord`; 84 (Stormwind City) is het bekende partner-id en **niet** los gemeten — daarom leest de
aanroeper de naam terug en laat de stap vallen als die leeg is. Een fout id kost dan een ontbrekende
hint, nooit een verkeerde bestemming. Neutrale pandaren krijgen niets.

### ✅ 5 sep — The Den: gevonden, en het was NIET de sub-map-hypothese

Rob deed `/mh arrow` in The Den. Twee regels naast elkaar spraken elkaar tegen:

```
hub-slice op canvas 2576: jij Harandar (x 62.1)
basiszone volgens ons: Silvermoon
```

🔴 **`ns.GetBaseZoneName` gaf voor héél canvas 2576 "Silvermoon".** Regel 959: `if mid == 2393 or
mid == 2576 then return "Silvermoon"`. Terwijl 2576 juist de gedeelde kaart is die Silvermoon,
Voidstorm én Harandar naast elkaar draagt, `ResolveHubOnMap2576` bestaat om hem te snijden, en
`GetRegionGroupID` dat op 4 sep al geleerd heeft. Deze functie is toen overgeslagen.

📌 **Dat is de drift achter "The Den is een drama":** alles wat vroeg waar de speler is, kreeg
"Silvermoon" te horen terwijl hij in Harandar stond — inclusief de onderdrukking van de reispopup
(`ShouldSuppressTravelPopup`) en de zin in de levelwaarschuwing zelf.

⚠️ **Mijn hypothese van vanmiddag was fout** en het is goed dat we niet gebouwd hebben: ik dacht aan
een sub-map (Harandar verdieping 2) en aan `MHResolveWaypointMap`. De client meldt in The Den
gewoon **2576**. Eén meting was genoeg om een dag bouwen op de verkeerde plek te voorkomen.

✅ **Gerepareerd:** `ns.GetBaseZoneName(mapID, xPct)`. Zonder x op 2576 komt er **""** terug en geen
gok — elke aanroeper in deze repo heeft een coördinaat, en "" betekent daar al "onbekend".
Bijgewerkt op drie plekken: `ShouldSuppressTravelPopup` (heeft `targetX` in zijn eigen signatuur),
`ZoneLevelGate` (heeft `xPct`) en de `/mh arrow`-diagnose zelf, zodat die zichzelf niet meer kan
tegenspreken.

✅ **BEVESTIGD door Rob na de reload:** `basiszone volgens ons: Harandar`, en de route hervat nu wél
door het portaal heen (*"You are there — the arrow is now on Rhazul"*, pijl op 477 m in The Den).
Was daarvoor `doel: GEEN`.

### 🔴 OPEN, maar nu GEMETEN — TomTom verliest zijn pijl in The Den, wij niet

Twee `/mh arrow`-metingen, dezelfde character, één minuut uit elkaar:

| | in The Den | buiten The Den |
|---|---|---|
| `jij: map` | **2576** (canvas) | **2413** (Harandar) |
| TomTom-pijl | ❌ onzichtbaar | ✅ *Rhazul 423m* |
| onze pijl | ✅ *Rhazul 477 m* | wij wijken (by design) |
| Blizzard map pin | ✅ 522 yds | ✅ 464 yds |

📌 **De oorzaak staat vast:** binnen meldt de client je op de gedeelde canvas **2576**, terwijl de
rare-waypoints op **2413** staan. TomTom rekent tussen die twee niet om en verbergt dan zijn pijl.
Buiten sta je op 2413 en klopt alles.

✅ **Niet dringend:** onze eigen pijl én de Blizzard-pin dekken het gat al, met het juiste doel en de
juiste afstand. De speler staat nooit zonder pijl. Alleen TomTom-gebruikers zien binnen een andere
pijl dan buiten.

⚠️ **Als iemand dit ooit repareert:** het waypoint moet worden gezet op de kaart waar de SPELER op
staat, dus 2413 → 2576 omrekenen via wereldcoördinaten. `C_Map.GetMapPosFromWorldPos` is daarvoor de
kandidaat en is **NIET gemeten** — en 2576 is een gedeelde canvas, dus of die überhaupt een eigen
wereldruimte heeft is de eerste vraag. Meten met `/mh ptr` vóór er code komt.

### ✅ 5 sep — de 2576-sweep, en hij was de moeite waard

Alle 2576-gebruiken nagelopen in plaats van te wachten op de volgende melding. **Twee echte bugs, de
rest schoon.**

🔴 **1. De rare-alerts keken naar de verkeerde lijst.** `Rares.lua` had
`MAP_TO_ZONE_KEY[2576] = "harandar"` — één antwoord voor drie gebieden. Die sleutel bepaalt **tegen
welke rare-lijst** de vignettes in de buurt gematcht worden, dus wie op het Silvermoon- of
Voidstorm-derde van de canvas stond vergeleek met Harandars rares en matchte niets. **Geen alert,
geen fout, van buiten niet te zien.** Precies de stille fout waar CLAUDE.md voor waarschuwt.
✅ `ZoneKeyForMap()` snijdt nu op x, en alleen voor de kaart waar de speler zélf op staat — voor
elke andere kaart blijft de tabel gelden. Is de positie onleesbaar, dan valt hij terug op de tabel
en niet op `nil`: een verouderde standaard scant nog een echte lijst, `nil` zou de alerts uitzetten.

🔴 **2. De Hearthstone-knop dacht dat heel 2576 Silvermoon was.** `isHub = (currentMap == 2393 or
currentMap == 2576)`, in **beide** kopieën van de Travel Assistant. Sta je in Harandar of Voidstorm
op diezelfde canvas, dan telde je als "al thuis" en werd de HS-knop weggelaten precies wanneer hij
wat waard was. ✅ Nu `PlayerIsInSilvermoonHub()`, die de gesneden regio vraagt.

✅ **Schoon bevonden, met reden:** de scan-lijsten (`DelveBossShowcase`, `EncounterCapture`,
`WorldBoss`, `WorldBossProbe`) lopen kaarten af zonder te vragen wáár op de kaart — daar is geen x
nodig. `MIDNIGHT_OVERWORLD_MAPS[2576]` beantwoordt alleen "is dit Midnight-buitenwereld".
`PrintPortalAccess` sneed al. En de enige overgebleven kale `GetRegionGroupID`-aanroep zit ín
`GetEffectiveRegionGroupID` zelf, waar hij hoort.

🔴 **3. En meteen daarna de zesde, door Rob gemeten: de reis-overdracht kwam niet af in The Den.**
Route vanuit Silvermoon naar **The Gulf of Memory** (map 2413), keurig via het Portal to Harandar,
en dan in The Den **helemaal geen pijl** — `/mh arrow` zei `doel: GEEN`. Vloog hij The Den uit, dan
verscheen hij meteen mét *"You are there — the arrow is now on The Gulf of Memory"*.

📌 **Oorzaak:** `ArrivedOnTargetMap()` vergelijkt met 2413, maar de client meldt je binnen op
**2576**. Beide tests faalden daardoor — de id-test, én de flight-point-test, want
`GetNearestFlightPoint(2576)` heeft geen rijen (de vliegdata kent 2413, niet de canvas). De etappe
werd dus nooit "af" en het doel nooit teruggegeven, tot hij eruit vloog.

✅ **Bewust smal gerepareerd:** vergelijken op REGIO zou de voor de hand liggende fix zijn en zou de
Vaults-bug terugbrengen die daar in het commentaar staat (Silvermoon en Eversong delen regio 1, dus
een etappe daartussen zou "aangekomen" heten vóór je een stap zet). De test vraagt nu alleen: *sta
ik op de canvas, in het derde dat de bestemmingskaart ís?* Nieuwe gedeelde tabel
`ns.MIDNIGHT_HUB_MAP_BY_NAME` — de inverse van `ResolveHubOnMap2576`.

### 🔴 OPEN — geen reispopup vanuit Harandar naar het Coiled Isle-portaal, en ik weet niet waarom

Rob, vanuit Harandar op zijn mage: pijl **en** chatregel (*"…is not on this continent. Head for
Portal to Silvermoon first"*), maar **geen popup**, dus ook geen portaalknop en geen mage-teleport.

🔴 **INGETROKKEN, mijn eigen verklaring van tien minuten eerder.** Ik zei dat de twee-staps-route
"door een andere deur" gaat. Onwaar: `ns:SetMapWaypoint` (`DelveTipMarkup:685`) roept gewoon
`ns.AddSmartTomTomWay` aan, net als alles. Daarna elke poort met de hand nagelopen —
`IsMidnightTravelComplete`, `ShouldSuppressTravelPopup`, `MHSameZoneOrSub`, de regio-vergelijking
(Harandar 2 vs Silvermoon 1), de kaart-ongelijkheid en de portaal-lus (2413 hééft een rij naar
2393) — en **allemaal zeggen ze dat de popup eruit had moeten komen.** Ik kan het uit de bron niet
verklaren.

✅ **Dus geen reparatie op een verkeerde diagnose, maar het instrument gebouwd: `/mh travelwhy`.**
Print per poort of hij de popup tegenhoudt, plus de portalen op je huidige kaart mét hun
bruikbaarheidsvlag. Zes poorten beslisten dit en geen enkele zei ooit iets — precies het geval
waarvoor CLAUDE.md die regel heeft.
⚠️ Het vraagt de **echte** functies, geen nagebouwde logica. Een diagnose die zijn eigen versie van
de code meet is het eens met zichzelf en liegt over de code — de fout die `/mh arrow` op 4 sep
maakte toen hij de kale regiofunctie aanriep en de routering de schuld gaf.

✅ **OPGELOST, en het instrument wees het aan.** Robs `/mh travelwhy` in Harandar: **alle zes poorten
groen**, beide Harandar-portalen bruikbaar. Het besluit klopte dus — de popup werd nooit *gevraagd*.

📌 **De Silvermoon-pins hebben hun eigen routepad** (`UI.lua`, `RouteSmcPoint`): `SetUserWaypoint`
plus de TomTom-slash, `ns.lastTarget` met de hand, en **nooit** `ns.AddSmartTomTomWay` — waar de
reishulp woont. Dat is de **zevende** omweg om die deur; de audit van vanochtend vond er zes en
miste deze, omdat ik op de waypoint-aanroepen greppte en dit pad de zijne achter
`TriggerTomTomWaySlash` verstopt.

🔴 **En ik ben hier twee keer van mening gewisseld.** Eerst zei ik "die route gaat door een andere
deur" (juist), toen trok ik dat in als onwaar (fout — ik keek naar `ns:SetMapWaypoint` in
`DelveTipMarkup`, een ánder pad met dezelfde soort naam), en nu blijkt de eerste versie te kloppen.
📌 **De les is niet "vertrouw je eerste ingeving".** Beide keren was het een greep zonder meting.
Wat het besliste was `/mh travelwhy` — en dat had ik ook meteen kunnen bouwen.

✅ **Reparatie:** `ns.ShowTravelAssistFor` erachteraan, niet omschakelen naar `AddSmartTomTomWay`.
Dit pad bezit zijn waypoint bewust (de deur-overdracht in `TwoStepRoute.lua` stuurt hem), en dat
afpakken om iets anders te repareren is precies het soort collateral waar deze dag al vol van staat.
De assistent is exact de ontbrekende helft, en hij verbergt zichzelf als het doel dichtbij of in
dezelfde regio ligt.

### 🔴 5 sep — de Harandar-portalen wezen naar open zee, en niemand had ze ooit gemeten

Rob vloog in Harandar richting *"Portal to Silvermoon 370 m"* en hing boven **water**, terwijl de
addon zei *"You are at Portal to Silvermoon — go through"*.

📌 **Oorzaak:** de rijen voor 2413 en 2576 droegen **exact dezelfde x/y**. Twee kaarten, twee
coördinatenruimtes — dus één van de twee moest fout zijn.

✅ **Rob mat ze allebei ter plekke:** Portal to Silvermoon **2576 64.33/70.63**, Portal to Voidstorm
**2576 61.75/73.01**. Binnen een vijfde punt van de canvas-rijen, dus die waren goed en de
2413-rijen waren de kopie.

🔴 **En het kaart-id is het echte nieuws: beide portalen staan ÍN The Den**, dat de gedeelde canvas
meldt. Een speler buiten in open Harandar (2413) kan de portaalpositie dus helemaal niet krijgen —
die bestaat niet in die ruimte. Wat hij eerst nodig heeft is **de ingang van The Den**, en die had
Rob een uur eerder al gemeten: 2413 **54.72/53.10**.

✅ **Gerepareerd zonder nieuw mechanisme:** de 2413-rijen wijzen nu naar The Den, de 2576-rijen naar
de portalen zelf. De speler stapt naar binnen, de client zet hem op 2576, en de tweede rij neemt het
over. Twee etappes die vanzelf uit de kaart-id's rollen.
⚠️ Ook hernoemd naar *"The Den (portals are inside)"* — anders zegt het scherm "You are at Portal to
Silvermoon" bij een grotingang, dezelfde leugen een niveau hoger.

🔴 **Herkomst nagelopen op Robs vraag "hadden we dat niet al?":** `git log -S"64.15"` geeft **één**
commit, een bulk-import van **15 mei 2026**, en niets daarna. Nooit gemeten, nooit aangeraakt. Zijn
gevoel dat we hier al mee bezig waren klopte wel — Orgrimmar, de Coiled Isle-ingang en The Den zijn
alle drie deze week gemeten — maar juist deze was overgeslagen. **Vier portalen aangeraakt, de
vijfde vergeten**, en hij viel pas op nu dit pad een uur geleden zijn reishulp kreeg.

✅ **BEVESTIGD in het spel** door Rob, direct na de reload: route vanuit open Harandar werkt.

⚠️ **De andere duplicaten in `MIDNIGHT_PORTALS` zijn NIET nagemeten.** Silvermoon (2393 ↔ 2576) en
Voidstorm (2405 ↔ 2576) dragen dezelfde verdachte vorm: identieke x/y op twee kaarten. Bij Silvermoon
werkt het in de praktijk, dus daar is 2393 vermoedelijk wél de goede — maar vermoedelijk is niet
gemeten. Twee `/mh coord`-metingen per hub sluiten dit af.

#### 💡 BANK — "eerst The Den uit" als eerste etappe (gemeten, niet gebouwd)

Rob: *"je moet eerst de den uitvliegen, kunnen we de route dan in 2 dingen opsplitsen?"* Kan, en het
mechanisme ligt er al: `point.entrance` + `ns.StartSmcTwoStepRoute`, gebouwd op 3 sep voor precies
het spiegelbeeld (eerst naar de ingang van een gebouw).

✅ **Gemeten door Rob, 5 sep, allebei bevestigd:**
* uitgang van The Den: **map 2413, 54.72 / 53.10** — vlak bij de flight master die
  `FlightPointsData` al kent (`The Den`, 54.10 / 53.23), twee onafhankelijke metingen die elkaar
  dekken;
* de detector: **binnen = 2576, buiten = 2413**, ook pal bij de uitgang én van bovenaf. Rob heeft er
  expliciet omheen gevlogen om te kijken of 2576 ergens buiten opdook. Nee.

🔴 **DE ADDER, en waarom dit niet zomaar winst is:** de uitgang ligt op **2413** terwijl de speler op
**2576** staat. Een waypoint daarheen heeft dus exact het probleem dat we vandaag gemeten hebben —
**TomTom tekent niks over die twee ids heen**. Voor TomTom-gebruikers zou de eerste etappe dus
onzichtbaar zijn, en dat is precies de fout uit de rare-hints van 19 aug in een nieuw jasje.

📌 **Dus als dit gebouwd wordt, is de CHATREGEL het product** ("ga eerst The Den uit") en de pijl een
bonus voor wie geen TomTom draait. Niet andersom. Rob zei zelf "niet noodzakelijk hoor" — dit staat
hier als afgemeten voorstel, niet als taak.

#### ✅ 5 sep — Coiled Isle rare-alerts: gemeten, en ze wérken

Robs melding *"op de coiled island krijg ik ook geen rare alerts"* is met `/mh rarescan` ter plekke
nagegaan:

```
playerMap=2512  zoneKey=coiled_isle  zone=ok   vignettes nearby = 4
 [1] Vul'zahn's Smuggled Treasure   atlas=VignetteLootElite  -> match=NONE
 [2] Malformed Leviathan            atlas=VignetteKillElite  -> match=Malformed Leviathan
 [3] Zul'jarra's Forces Decor Specialist  atlas=housing-decor-vendor -> match=NONE
 [4] Zul'jarra's Forces Renown Quartermaster  atlas=Quartermaster -> match=NONE
```

📌 **De zone komt door de Season 2-poort, en de enige échte rare in de buurt matchte.** De drie
NONE's horen NONE te zijn: een schatkist en twee vendors. Er is dus niets kapot aan de dekking.

⚠️ **Wat dan wél bepaalt of je hem hoort:** `RARE_ALERT_MAX_YARDS = 500` en 15 minuten stilte per
spawn (`RARE_ALERT_TTL`). "Er toevallig overheen vliegen" op hoogte kan makkelijk buiten die 500
yard vallen. Dat is een afweging, geen bug — maar als Rob vaker meldt dat hij er langs vloog zonder
ping, is die 500 het getal om te bespreken en niet de matcher.

### ✅ 5 sep — Dundun is niet altijd een boom, en dat stond in zeven talen fout — HERSCHREVEN

Carola, via Rob: *"de DUNDUN in haar delve was niet een boom maar een Paal."* Geen screenshot, wel
een eigen waarneming in het spel.

📌 **Onze tekst zei "een houten nepboom", in alle zeven de talen, op gezag van één wiki-regel.** Eén
tester die het zélf ziet weegt zwaarder dan dat — en het is bovendien logisch: een prop die opgaat
in zijn omgeving kán niet in een grot hetzelfde ding zijn als in een bos.

✅ **Herschreven naar het KENMERK in plaats van de vorm:** planken en schroeven, verf in plaats van
bast, "dat heeft iemand gemaakt" — met beide waarnemingen als voorbeeld. Dat is sowieso de betere
instructie: wie op één silhouet jaagt loopt het andere straal voorbij.
Aangepast in `DUNDUN_CHAT_WHAT` en `DUNDUN_PANEL_BODY` (7 talen), plus de `/mh dundun`-uitvoer en de
module-header. `check_drift.py`: 0 gedrift.

⚠️ **Wat we NIET weten:** of de vermomming per delve verschilt, per zone, of willekeurig is. Twee
waarnemingen (Rob, Carola) is geen patroon. De tekst claimt daarom niets over waarom.

#### 🟡 OPEN, klein — de pijl draait om bij aankomst op de Coiled Isle

Rob vroeg de route naar het Coiled Isle-portaal, kreeg hem netjes, en bij aankomst óp het eiland
sprong de pijl naar *"Portal to Silvermoon, 2 m away"* — het portaal terug, waar hij naast stond.

📊 **`/mh arrow` op het eiland:** `route-eigenaar: waypoint`, `doel: Portal to Silvermoon (map 2512
58.2, 48.5)`. Die coördinaat komt **exact** overeen met `{WAY:2512:58.12:48.48:Portal to Silvermoon}`
— een klikbare link in ons **Codex-artikel** over de Coiled Isle (`Codex.lua:75`, en dezelfde tekst
in `SMC_PIN_PORTAL_ISLE`).

🔴 **Maar Rob heeft de Codex niet aangeklikt.** En de enige code die zo'n link omzet in een route is
`OnHyperlinkClick` (`DelveTipMarkup:784`), die een klik nodig heeft. De pin zelf
(`UI.lua:879`) draagt geen enkele 2512-coördinaat. **Ik kan de dader niet vinden door te lezen.**

✅ **Dus geen vijfde verhaal maar een instrument.** Zeven plekken in de addon zetten `ns.lastTarget`
en hun resultaat is van buiten identiek. Elk van de zeven stempelt nu een `via`, en `/mh arrow`
print een regel **`gezet door:`**. Blijft die op *onbekend* staan, dán is dat zelf de vondst: er is
een achtste plek, of iets zet het doel buiten die zeven om.

📌 Zelfde patroon als `/mh travelwhy` een half uur eerder: als lezen het niet oplost, meet dan wie
het deed. Dat kostte vandaag drie keer minder dan de gok.

🔴 **CORRECTIE, en het was mijn vierde misser in dit ene spoor: `MIDNIGHT_PORTALS` HÉÉFT een rij op
2512.** `Delves.lua:285` — *"The way back, from Tokka's Landing"*, `x = 58.25, y = 48.46`, precies de
coördinaat uit Robs TomTom-regel. Ik had ernaar gegrept, kreeg een lijst die op de limiet afkapte
vóór die regel, en concludeerde "geen rij". **Een afgekapt zoekresultaat is geen leeg
zoekresultaat** — dezelfde val als [[silence-is-not-absence]], nu met een `head_limit` als oorzaak.
Zet een limiet nooit op een zoektocht waarvan de conclusie "hij bestaat niet" kan zijn.

🔴 **EN DE ECHTE VONDST, uit Robs "dit was met een actieve route":** bij aankomst op het eiland staat
er `doel: GEEN`. De aankomstcontrole besluit dus dat hij ER IS en gooit de route weg — **volledig
stil**. Daarna doet de reishulp gewoon zijn werk en wijst naar de terugweg, wat er van buiten
uitziet als "de pijl draait om".

✅ **Gebouwd: die beslissing praat nu.** `ROUTE_FINISHED_FMT` in enUS + nlNL, geprint op het moment
dat de route wordt opgeruimd, mét de naam van het doel én de uitnodiging om het te melden als het
niet klopt. Hij verschijnt óók als het oordeel fout is — dat is juist de bedoeling: een onterechte
"je bent er" is dan een zichtbare claim in plaats van een pijl die zomaar verdwijnt.

⚠️ **Waaróm hij "aangekomen" zegt is NIET gemeten.** Vermoeden (niet meer dan dat): Silvermoon City
en de Coiled Isle melden allebei continent 0 terwijl ze elk hun eigen coördinatenruimte hebben, dus
`GetYardsToMapWaypoint` kan een klein getal opleveren dat niets betekent. Eerst de nieuwe regel in
het spel zien, dan pas daar kijken.
⚠️ **`ROUTE_FINISHED_FMT` staat alleen in enUS + nlNL** — de/fr/es/pt/it volgen zodra hij bewezen is.

#### ✅ 5 sep — en de nieuwe regel wees de dader aan in één woord

Rob deed de reis opnieuw en las: *"reads you as arrived at **Portal to Silvermoon**"*. **Niet** het
Coiled Isle-portaal waar hij om vroeg. Daarmee lag de volgorde open:

1. klik → route naar *Portal to The Coiled Isle*, een plek **in Silvermoon**
2. hij stapt erdoor en staat op het eiland
3. `legRetry` (`DelveTipMarkup:649`) draait **0,7 s** na het laadscherm, ziet een doel dat in
   Silvermoon ligt, vindt het terugportaal twee meter verderop en routeert hem daarheen
4. `runZoneNavCheck` draait op **1 s**, ziet hem er bovenop staan en meldt "aangekomen"

🔴 **Elke stap is lokaal correct en de som loopt achteruit door de deur die hij net gebruikte.** De
fout zit in wat een portaal-route BETEKENT: hij wordt bewaard als de positie van het portaal, dus
zodra je hem gebruikt zijn we de draad kwijt en beginnen we aan de thuisreis.

✅ **`arrivesOn` toegevoegd.** De pin die het portaal kent zegt nu waar het uitkomt (2512), en
aankomen daar beëindigt de route in plaats van er een nieuwe te beginnen. Gecontroleerd op **twee**
plekken, en de volgorde is de reden: in `legRetry` (0,7 s) omdat die het eerst draait en anders de
schade al is aangericht, én in `runZoneNavCheck` (1 s) zodat de route netjes wordt afgesloten met
de nieuwe melding.

📌 **Alleen deze ene pin heeft `arrivesOn`.** Andere portaal-pins krijgen hem zodra iemand meet
waar ze uitkomen — geen raadwerk, zoals de rest van vandaag.

📌 **De sweep kostte minder dan de vier losse meldingen samen.** Waard om te onthouden voor de
volgende keer dat één fout zich drie keer herhaalt.

🔴 **De vierde 2576-vondst op één dag was** (doel-regio 4 sep, `GetBaseZoneName`, de
mage-knoppen, nu TomTom zelf). Het patroon is inmiddels duidelijk genoeg om vooruit te kijken in
plaats van achteraf: **elke plek die een positie of een kaart-id op 2576 gebruikt is verdacht tot
hij de x kent.** Een gerichte zoektocht daarnaar is waarschijnlijk goedkoper dan de volgende drie
losse meldingen.

### 🗄️ De oude hypothese (5 sep, ingetrokken) — The Den als sub-map

Rob, 5 sep, opnieuw: *"The Den is nog een drama, alleen als ik eruit vlieg gaat de pijl weer terug
komen, en als ik in The Den een delve in SMC wil doen raakt ie weer van slag."*

📌 **Hypothese, NIET gemeten:** The Den is een sub-area op **verdieping 2 van Harandar**
(`FlightPointsData.lua:977` — `fpath The Den |goto Harandar/2 70.74,53.23`). `MHResolveWaypointMap`
in `Core.lua:646` klimt al omhoog wanneer het **DOEL** op zo'n sub-map ligt, maar er is niets dat
hetzelfde doet wanneer **DE SPELER** erop staat: `currentMap` wordt dan de sub-area, en daar hangen
regiodetectie, reispopup-onderdrukking en de pijl allemaal vanaf.

⚠️ **Eén `/mh arrow` vanuit The Den settelt dit.** De keten-regels laten meteen zien welk mapID
`currentMap` is en of hij als "ander continent" gelezen wordt — precies zoals de Azure
Span-meting vandaag de TomTom-vraag in vier regels afdeed. Niet gaan bouwen vóór die regel er is.

## 🗄️ AFGEHANDELD 5 sep — MH stuurt lage levels naar dingen die ze niet kunnen doen

Rob, 4 sep laat, expliciet gevraagd om te onthouden: *"ik kan met lagere levels in mh toch routes
krijgen voor dingen die ik nog helemaal niet kan doen — dit onthouden, doe er nu niks mee."*

**Dus: niet bouwen tot hij het zegt.** Wat er ligt is een keuze, geen taak.

📊 **GEMETEN 4 sep:** 29 modules kunnen een route zetten, **2** kennen de level-gate
(`ResetRoutine`, `UI`). Wat op 3 sep gebouwd is dekt This Week en het Silvermoon-tabblad; rares,
delves, treasures, achievements, events en professies routeren ongefilterd.

✅ **Goedkoper dan het lijkt:** `ns.AddSmartTomTomWay` is de gedeelde deur (Rares 9×, Achievements
16×, Delves 8×, RitualSites 4×), met vrijwel geen directe `SetUserWaypoint`-omwegen. Eén functie,
geen 29 bestanden.

⚠️ **En het raakt een GESHIPTE belofte:** `CHANGELOG_260_3` zegt dat MH *"never points you at endgame
content you cannot do yet"*. Dat staat in een uitgebrachte versie en is aantoonbaar onwaar. Dat
moet hoe dan ook opgelost — repareren of intrekken — ook als de rest wacht.

**De keuze die aan Rob voorligt (nog niet gemaakt):**
- **A** — waarschuwen bij de klik, route wél zetten. Aanbevolen: bij een rare is de coördinaat nog
  steeds nuttig, maar een route naar een zone waar je niet komt is verkeerd advies.
- **B** — route weigeren met de reden op de knop, zoals de Silvermoon-pins nu.
- **C** — niets doen en alleen de changelog-belofte intrekken (tien minuten).

## ✅ DUNDUN-WAARSCHUWING — AF (4 sep gebouwd, 6 sep beslecht en in 7 talen)

Rob, 3 sep laat: *"zet maar op de lijst voor morgen."*

1. ✅ **AF, 4 sep.** De lijst is gevonden en het antwoord was een correctie: Dundun is geen
   modifier maar de Shrine of Abundance in Bountiful delves. Zie de sectie hieronder.
2. ✅ **GEBOUWD 4 sep** — `Modules/DundunShrine.lua`. Geen affixen nodig: (a) Bountiful komt uit
   `ns.IsDelveBountiful`, (b) rank uit `ns.GetDelverJourneyStatus` (drempel 3), (c) sleutels uit
   currency `3028`. `ns.GetDundunStatus()` levert één oordeel mét reden, zodat de chatregel en de
   diagnose niet uit elkaar kunnen lopen.
3. ✅ **GEBOUWD** — de chatregels haken aan `DelveCoach`'s `inDelve and not wasInDelve`, met 2
   seconden vertraging omdat de kaart-POI op de entree-tick nog niet altijd rond is.
4. ✅ **GEBOUWD** — de macro-tip staat in dezelfde regelgroep.

⚠️ **Stap 3 niet zonder stap 2.** Een sleutelwaarschuwing in een delve zonder Dundun is precies het
soort zelfverzekerde onzin waar 3 sep over ging. Daarom zwijgt hij bij `bountiful ~= true` én bij
een leesbare rank onder 3, en zegt hij bij een ONleesbare rank de voorwaarde hardop in plaats van
te doen alsof hij hem gecontroleerd heeft.

✅ **HET RISICO IS WEG — GEMETEN 4 sep in The Darkway (tier 11, Bountiful, live 12.1).**
`ns.IsDelveBountiful` antwoordt van **binnen** de delve `true`, op naam, op zone én op zone+map. De
kaart-POI blijft dus leesbaar; die zorg was ongegrond.

🔴 **Wat er wél mis was, waren twee fouten van mij, en ze kostten Rob vier runs in een delve.**
1. `ActiveDelveName` deed `return entry.name or entry.title`, dus als de roster-entry bestond maar
   geen van beide velden had, gaf hij `nil` **en sloeg de fallback over** die daar juist voor was
   toegevoegd. In diezelfde run zei `IsKnownDelveName("The Darkway")` gewoon `true`.
2. De roster is gesleuteld op id's (`the_darkway`), de zone is een weergavenaam (`The Darkway`);
   die rauw vergelijken gaf "nee" terwijl het item er stond.
📌 Eén keer de roster printen had beide getoond. Zelfde les als het werkende voorbeeld hélemaal
lezen, maar dan toegepast op een lijst die we zélf bezitten.

📌 **Nevenmetingen, zodat niemand ze opnieuw hoeft af te leiden:** `HasActiveDelve` = true is een
schoon in-delve-signaal · `GetActiveDelveTier` geeft binnen alleen nullen (entrance-side) ·
`GetDelvesAffixSpellsForSeason(2)` is **leeg**, dus dat is níét de route naar een modifierlijst ·
spell **430253** (Bountiful, uit het entree-scherm) is **geen speler-aura** ·
`GetTieredEntranceOptionalAffixTraitTreeID` en de entrance-strings geven binnen niets.

✅ **Shards zitten er nu in.** Het entree-scherm zegt dat 100 Coffer Key Shards bij binnenkomst
automatisch een Restored Coffer Key worden. "Je hebt 0 keys" was dus waar én nutteloos toen Rob er
84 had — de regel oordeelt op keys plus shards en zegt hoeveel shards er nog nodig zijn.

🗄️ **"Nog te vertalen" — DAT WAS AL AF en de regel stond hier te verouderen.** Gemeten 6 sep:
`Translations2026.lua` bevat alle 15 `DUNDUN_*`-keys in de/fr/es/pt/it, inclusief de herschreven
"gezimmert statt gewachsen"-tekst van 5 sep. Rob vroeg om die vertaling; het antwoord was dat er
niets te doen was. Vierde verouderde eigen aantekening op één dag — zie de regel bovenaan dit
bestand over kopregels en bodies.

✅ **BESLECHT 6 sep — Rob heeft het gemeten, en de as is PER CHARACTER PER WEEK.**

> *"de eerste DUNDUN per character per week geeft een extra kist, elke andere daarna dat scherm met
> die opties, maar geen Bountiful koffer meer (ik kies tot nu toe dan voor extra xp voor Valeera)"*

Daarmee valt de tegenspraak weg die deze regel maandenlang openhield: de wiki zei "eerste van de
week geeft de keuze-trunk", masterofwarcraft.net zei "eerste geeft de tweede koffer". Beide hadden
de helft; de as is niet *eerste ooit* maar *eerste per character per week*.

📌 **Verwerkt in de tekst, 7 talen.** Nieuwe key `DUNDUN_CHAT_AFTER_FIRST` plus een aangevulde
`DUNDUN_PANEL_BODY`. ⚠️ **De chatregel staat er ALTIJD**, want de addon kan niet zien de hoeveelste
Dundun van de week dit is — hij vertelt de regel en laat de speler zelf bepalen waar hij staat. Dat
is beter dan een sleutelwaarschuwing die op de tweede delve van de week gewoon onjuist is.

### 🟡 OPEN, goed afgebakend — de banner zou dat "altijd" kunnen wegnemen

Robs bewijs-screenshot toont de spelmelding *"Additional Bountiful Rewards Will Manifest Upon Delve
Completion"* bij de **eerste** Dundun van de week. Kán de addon die lezen, dan hoeft hij de regel
niet meer op te dreunen maar kan hij zeggen wélk geval dít is.

### ✅ 7 sep — de sniffer heeft gevangen wat we zochten, en het zijn getallen

Rob sprak zijn **tweede** Dundun van de week aan met `/mh sniff` aan. Uit `ns.db.sniffLog`:

| id | keuze |
|---|---|
| 140126 | Grant me some Undercoin! |
| 140496 | Grant me some Voidlight Marl! |
| 140495 | Grant Valeera some experience! |
| 140513 | Grant me a piece of housing decor! |
| 140514 | No thank you. |

📌 **De banner is `DISPLAY_EVENT_TOASTS`** (07:31:07, één seconde vóór `GOSSIP_CLOSED`) — maar
**zonder argumenten**, dus de tekst zit niet in de payload. Dat maakt niet uit: de gossip-id's zijn
beter, want een getal overleeft een vertaling. En de banner verschilt óók inhoudelijk: bij de eerste
stond er *"Additional **Bountiful Rewards**"*, nu *"Additional **Voidlight Marl** Reward"* — hij
noemt dus de gekozen beloning.

🔴 **NIETS OP GEBOUWD, want dit is de helft.** Van de EERSTE Dundun (het kist-geval, één aanbod:
*"Make my delve Abundantly Bountiful!"*) is het id nooit gelezen. Zonder dat kan een controle op
deze vijf niet uitsluiten dat ze óók bij de eerste verschijnen — en dan zegt de addon "lesser boon"
tegen iemand die de kist krijgt.

✅ **En dat hoeft NIET tot woensdag te wachten — Robs idee, en het is beter dan het mijne.** Ik had
"na de reset" opgeschreven omdat ik aan zíjn character dacht. Maar de as is *per character per
week*, dus **elke andere character heeft zijn eigen eerste Dundun van de week nog openstaan.** Hij
doet het op zijn **priester**, en dan kan `/mhautomap` (punt 3 hieronder) in dezelfde run mee.
📌 Waard om te onthouden: de beperking zat in mijn aanname, niet in het spel.

🔴 **En het gereedschap had een echt gebrek, gemeten in zijn eerste run.** Het logboek zat vol op
400 regels waarvan **80% `UI_ERROR_MESSAGE` + `CRITERIA_UPDATE`** was — "Spell is not ready yet"
tijdens het vechten. De Dundun-gossip stond er nét in; een halve minuut later was hij eruit
geschoven, zonder één foutmelding. Er is nu een cap **per event** (30) naast het totaal, dus een
schreeuwend event kan een zeldzaam event niet meer overschrijven. Bewust géén kandidaten geschrapt.

⚠️ **En diezelfde twee events maakten zijn chat onbruikbaar** (*"echt veel spam in mijn chat nu
haha"*). Nieuw: **`/mh sniff quiet`** — die vier stille events worden niet meer geprint maar wél
gelogd, want wegfilteren bij de bron is een aanname en dit gereedschap bestaat juist om te vangen
wat je niet verwacht. De schakelaar noemt bij het aanzetten welke events hij dempt, anders is
"stil" van buiten niet te onderscheiden van "kapot".

### ⚠️ 7 sep — "zonder kist" was te grof, en Robs screenshot liet het zien

Hij stuurde wat de tweede Dundun opleverde: een object **Abundant Spoils** aan het eind, en
**+120 Voidlight Marl** (de keuze die hij maakte). Onze tekst zei *"zonder kist, dus zonder key"* —
en er stáát dus wél iets om te looten.

📌 **De bewering was niet fout maar te grof, en dat is hier hetzelfde.** Wat de eerste Dundun geeft
is een tweede **Bountiful Coffer**, en díé kost een Restored Coffer Key. Het keuzegeval geeft een
Abundant Spoils, en dat is geen coffer. Alle zeven talen zeggen dat nu zo, met de naam erbij zodat
een speler herkent wat hij ziet staan.

⚠️ **Niet gemeten en dus niet beweerd:** of die Abundant Spoils zelf helemaal gratis is. Rob heeft
niet gemeld dat hij een key kwijtraakte, maar "niet gemeld" is geen meting. De tekst zegt daarom
alleen wat we weten — het is géén tweede Bountiful Coffer — en niet "hij is gratis".

### De twee open vragen van gisteren, bijgewerkt


1. ✅ **GEBOUWD 6 sep: `/mh sniff`** (`Modules/EventSniffer.lua`). Registreert 18 kandidaten
   defensief — elk door een `pcall`, en wat de client weigert wordt gemeld in plaats van
   stilgehouden — logt naar `ns.db.sniffLog` én naar chat, en stopt zichzelf na 30 minuten.
   `/mh sniff dump` en `/mh sniff clear` erbij.
   📌 **De grootste vangst is waarschijnlijk niet de banner maar `GOSSIP_SHOW`:**
   `C_GossipInfo.GetOptions()` geeft per keuze een `gossipOptionID`, en dat is een GETAL. Biedt
   Dundun de eerste keer een andere optie-id dan de tweede, dan is het onderscheid taalonafhankelijk
   zonder ooit naar een zin te kijken.
2. **Of hij ook bij de tweede+ Dundun verschijnt.** Zo ja, dan onderscheidt hij niets en is de hele
   route dood. Eén Dundun later in dezelfde week op hetzelfde character beantwoordt dat — Rob
   verwacht zelf dat de zin dán anders is.

🔴 **En de voor de hand liggende kortsluiting is een val: NIET op de Engelse tekst matchen.** Deze
banner is gelokaliseerd, dus een string-vergelijking werkt op zes van de zeven clients niet — en
faalt daar stil, wat precies het soort bug is dat alleen niet-Engelse spelers treft en dat wij nooit
zien. Alleen een event + payload, of een GlobalString-sleutel die de client zelf vertaalt, is bruikbaar.

## 🔑 4 sep — de aura-regel op 12.1.5 is GEMETEN: opsommen mag niet, gericht vragen wel

Zeven runs op **12.1.5.69594**, de beslissende gevangen door `/mh ptr watch` (sweep 8, 10:26:18, in
gevecht met Dame Bloodshed, speler in leven). **In één en dezelfde tick**, op `player` én `target`:

| aanroep | uitkomst |
|---|---|
| `GetUnitAuraInstanceIDs` | 🔴 REFUSED |
| `GetAuraDataByIndex` | 🔴 REFUSED |
| `GetAuraSlots(… "HARMFUL\|DISPELLABLE" …)` | 🔴 REFUSED |
| `GetAuraSlots(… "HARMFUL" …)` | 🔴 REFUSED |
| `GetAuraDispelTypeColor` | 🔴 REFUSED |
| **`GetUnitAuraBySpellID`** | ✅ **ok** |
| **`GetPlayerAuraBySpellID`** | ✅ **ok — gaf een table** |

Elke weigering luidt: *"Auras cannot be accessed when secret while tainted by 'MidnightHelper'"*.
Geen secret value meer dus, maar een **harde fout**.

🔴 **`ns.AllyHasRemovableAura` (`DispelHelper.lua:379`) overleeft dit NIET.** Die was juist zo
geschreven dat hij geen aura-data leest — alleen of er een dispelbaar slot is. Dat helpt niet; ook
`GetAuraSlots` weigert. De geshipte dispel-helper is geblokkeerd in precies de toestand waarvoor hij
bedoeld is.

✅ **Maar de regel is coherent en gunstig voor ons.** Alles wat **opsomt** wordt geweigerd; de twee
aanroepen die vragen naar een **spell-ID die je al kent** komen door. Blizzard blokkeert ontdekken,
niet verifiëren. En deze addon bestáát uit lijsten: een dispel-helper kan vragen *"zit een van deze
twaalf bekende debuffs van deze encounter erop"* in plaats van *"wat staat er op mijn maat"*. Meer
werk in de data, minder in de code — en de data hebben we grotendeels al.

⚠️ **De toestand is CONTEXTUEEL, niet permanent.** Vijf eerdere runs lazen alles gewoon, inclusief
een Polymorph op een ándere unit met `dispelName`, `spellId` en caster-GUID alle drie leesbaar. Wat
de omschakeling aanzet is **niet vastgesteld**; gevecht met deze elite is de enige waarneming. De
sweep legt combat/dood/targetnaam vast, dus de volgende waarneming versmalt het.

❓ **NIET gemeten:** of de velden **binnenin** die table leesbaar zijn of secret. Een table vol
secrets ziet er van hieraf identiek uit. Dat is de volgende vraag, en een kleinere.

📌 Weegt mee: `Auras.lua:128` noteert dat dezelfde `GetPlayerAuraBySpellID` op **live 12.1** in
gevecht zeven van acht buffs als `nil` gaf — het kalme verkeerde antwoord. Hier gaf hij een table.
Mogelijk beter in 12.1.5; één meting is geen patroon.

✅ **Geen crashrisico.** Alle 14 aura-aanroepen in 6 bestanden zitten in een `pcall` — gemeten met
positieve controle. Het faalt dus stil, en dat is precies waarom `/mh ptr watch` moest bestaan.

## 🔴 4 sep — de CAST-muur is hermeten op 12.1.5 en is ONVERANDERD dicht

De aantekening van 18 aug zei "bouw hier niets meer op; hermeet bij 12.2". Hermeten op **12.1.5
build 69594**, gevangen door `/mh ptr watch` op het `UNIT_SPELLCAST_START`-event zelf (peilen mist
de helft van de casts; langer peilen mist alleen vaker). Doelwit `Lightbloom Monstrosity`,
`UnitCastingInfo` gaf **11 slots**:

```
[1] SECRET  [2] SECRET  [3] SECRET  [4] SECRET  [5] SECRET
[6] boolean false   [7] SECRET  [8] SECRET  [9] SECRET
[10] "CastBar-803752C3BCEB3D2A"   [11] number 0
```

Negen van de elf secret. Naam, tekst, icoon, begin- en eindtijd, castID en spell-ID: allemaal dicht.
Alleen `castBarID` (slot 10) is leesbaar, en die bewijst enkel **dát** er gecast wordt.

🔴 **NIEUW en beslissend: `notInterruptible` (slot 8) is óók secret.** We kunnen dus niet eens
vaststellen of een cast te onderbreken is. Dat sluit interrupt-assistentie af op een niveau onder
"welke spell is het" — de vraag "valt hier iets mee te doen" is zelf niet te beantwoorden.

⚠️ **NIET geclaimd:** er kwamen twee verschillende castBarID's langs (via `nameplate1` en via
`target`), wat mooi zou passen bij Blizzards mededeling dat castbar-ID's per unit-token uniek zijn.
Er zaten vijf seconden tussen, dus het kunnen twee casts zijn geweest. Geen bewijs.

📌 **Wat de schakelaar omzet:** alle drie de aura-vangsten (10:26, 10:37, 10:40) hebben
`inCombat = true`; één ervan had geen target en weigerde toch. De cast van de mob kwam binnen op
`inCombat = false`, vijf seconden vóór de weigering. **Het gevecht zet het om — niet de
tegenstander, niet het hebben van een target.** Drie waarnemingen, geen bewijs van het mechanisme.

📌 `C_UnitAuras.GetAuraDispelTypeColor` neemt **`(auraInstance, curve)`** — gemeten uit de
foutmelding van een verkeerde aanroep, niet uit documentatie. Buiten de secret-toestand is dat het
"engine rekent, wij lezen niet"-patroon; erbinnen weigert ook deze.

## ✅ 4 sep — wat 12.1.5 wél heeft beslecht

Alles hieronder is GEMETEN op **12.1.5 build 69594, interface 120105**, met MH 3.7.3, via
`/mh ptr` (`Modules/PtrProbe.lua` → `ns.db.ptrProbe`). Elke meting draagt sindsdien zijn eigen
client, omdat er die ochtend twee `/dump`-uitkomsten binnenkwamen en niemand kon zeggen uit wélke
van de twee geïnstalleerde PTR's ze kwamen.

- ✅ **`SocketInventoryItem` bestaat** — de gem-knop in `GearEnchantCheck.lua` overleeft 12.1.5.
  🔴 En de redenering van de API-wachter was fout, niet alleen de conclusie: **alle tien
  `Blizzard_Deprecated*`-addons zijn écht verdwenen**, `ItemSocketInfo` incluis, en de functie is
  tóch aanwezig. "Addon weg, dus functie weg" gaat niet op. `Blizzard_DeprecatedChatInfo` — waar
  onze `SendChatMessage`-fallback op leunt — staat er nog wel.
- ✅ **De tegenspraak in Blizzards eigen bron is beslecht.** `StringContains` = **absent**,
  `string.contains` = **function**. De blue post beweert dat er aliassen behouden zijn "to prevent
  addon breakage"; voor deze ene naam is dat onwaar en had de wiki-tabel gelijk. De andere veertien
  verplaatste globals zijn er allemaal nog. Raakt ons niet (0 treffers).
- 🔴 **INTREKKING: `UIModeUtil.IsModeActive` is NIET verwijderd.** Dat beweerde ik 4 sep 's ochtends
  na het lezen van Zygors crash (`PetBattle.lua:27`); de client zegt dat de functie er is, met vier
  buren. Wat er wél weg is, is **`IsFrameLockActive`** — de andere naam op diezelfde regel, en die
  staat **niet** in Blizzards verwijderlijst. ⚠️ Dat verklaart hun crash nog steeds niet, want hun
  `and`-guard hoort een ontbrekende functie juist op te vangen. Oorzaak blijft open; het is hun bug.
  Wij gebruiken geen van beide namen (0 treffers, positieve controle in dezelfde run).
- ✅ **Op de speler is elk aura-veld leesbaar** — `spellId` 1459, `name`, `dispelName "Magic"`,
  `sourceUnit`, `expirationTime`, `icon`. Niets secret. Maar eigen auras waren nooit de vraag.
- 📌 `C_UnitAuras` heeft **39 functies**, waaronder `GetAuraDispelTypeColor`, `GetUnitAuraBySpellID`,
  `AuraIsPrivate` en `IsAuraFilteredOutByInstanceID`. Nieuw en aanwezig: `C_Weather`, `C_Intl`,
  `CreateFrameWithOptions`, `GetScriptBucketThrottleLimits`. Afwezig: `TimedSignalMap`, `C_TableUtil`.
- 🔧 **`tools/copy_to_ptr.bat` voedde alleen `_ptr_`** (12.1.0.69587) terwijl de nieuwe build in
  **`_xptr_`** zit (12.1.5.69594) — alles wat voor 12.1.5 bedoeld was landde stil op de verkeerde
  client. Doet nu elke geïnstalleerde PTR, slaat over wat er niet is, en blijft één vaste
  commandoregel zonder argumenten.

## 📌 3 sep (avond) — wat "Dundun" is, en het gat dat het blootlegt

Rob, in The Gulf of Memory: *"in het begin zei die, zoek de verborgen DunDun, wat is dat en waar
vonden we dat"*. Uiteindelijk **GEMETEN op zijn eigen entree-scherm** (Twilight Crypts, Tier 11):

> **Dundun** — *"Dundun will hide within this Delve. Finding him will provide additional rewards at
> the end of this Delve."* Spell ID **1299072**

🔴 **CORRECTIE 4 sep: hij is GEEN delve-modifier.** Deze regel stond hier een dag als feit en klopte
niet. De Warcraft Wiki heeft een categorie `Delve affixes` met 17 leden (Aquatic Hex, Artillery Fire,
Explosive Spores, Goblin Problems, Grasping Shadows, Haunted, Mole Machine, Nemesis Strongbox,
Nerubian Webs, Reactive/Smothering/Suffocating…, Strange Creatures, Web Spreaders, Zekvir's
Influence) — **Dundun staat er niet bij**, en die lijst is bovendien nog grotendeels The War Within.
Hij is de **Shrine of Abundance**: een NPC (wiki-NPC-ID **266751**) vermomd als een **nepboom**.

Dat hij op het entree-scherm verschijnt maakt hem geen affix. 📌 De les is dezelfde als die van
gisteren, één laag dieper: ik zocht eerst op de délve in plaats van op de modifier, corrigeerde dat,
en nam vervolgens klakkeloos aan dat het ding dat ik zocht wél een modifier wás.

⚠️ En hij zit **niet in élke delve**: alleen in **Bountiful** delves, elke tier, en pas na
**Delver's Journey rank 3 ("Treasure Hunter")**. Dat maakt het bouwwerk veel kleiner — zie hieronder.

✅ **HET SPELL-ID IS BESLECHT — 4 sep, GEMETEN op Robs eigen entree-scherm** (The Darkway, Tier 11):
de tooltip van de Dundun-eigenschap zegt letterlijk **`Spell ID: 1299672 (CDPulse)`**. Wowhead had
gelijk; de **1299072** die hier stond was mijn overtypfout van een screenshot. Verschil van één
cijfer, en precies daarom stond het als onbevestigd genoteerd in plaats van als feit.
📌 We gebruiken het nergens — de waarschuwing hangt op Bountiful + rank 3 + sleutelvoorraad — maar
een getal dat in een aantekening staat moet kloppen, want de volgende lezer neemt het over.

### ✅ Rob heeft de hele keten gemeten — en mijn gok was fout

Ik had geraden dat de vondst een **Shard of Dundun** oplevert, op grond van de naam en die weekcap
van 8. **Dat is het niet.** Zijn vijf screenshots, van begin tot eind:

1. Dundun **vermomt zich als een decorstuk** — een prop die er net iets te vreemd uitziet
2. Aanspreken geeft gossip: *"Would you like to revel in abundance?"* → **"Make my delve Abundantly Bountiful!"**
3. Melding: *"Additional Bountiful Rewards Will Manifest Upon Delve Completion"*
   📸 **6 sep opnieuw vastgelegd, en nu mét context die hij op 4 sep niet had:** Rob schoot deze
   banner op een **vers character bij zijn eerste Dundun van de week**. Daarmee hangt stap 3 aan
   de kist-kant van de as die hij diezelfde dag mat (eerste = kist, daarna = keuzescherm).
4. De prop verandert in een gouden wezen
5. Aan het eind staat er **een tweede Bountiful Coffer**

🔴 **EN DE PRIJS STAAT NERGENS: die tweede koffer kost een tweede Restored Coffer Key.** Robs eigen
tooltip: `Bountiful Coffer / Locked / Restored Coffer Key 2 / 1`. Hij had er één. Dundun's aanbod is
dus **geen gratis loot maar een ruil**, en wie het aanneemt met één sleutel op zak houdt een kist
over die niet open kan.

📌 Hij is met het blote oog niet te vinden — hij staat er als prop. De macro die Rob via YouTube
vond, en die het probleem oplost:
```
/cleartarget
/target dundun
/ping [@target] assist
```

⚠️ **De "Shard of Dundun" is dus vermoedelijk iets ANDERS dat toevallig naar dezelfde NPC heet** —
`Profession.lua` telt hem als beroepen-weekly (item `258901`, cap 8) en `AltOverview.lua` filtert
erop. Niet uitgezocht hoe die twee zich verhouden; wat nu vaststaat is alleen dat de delve-modifier
een **koffer** geeft, geen shard. Nergens in de addon staat waar die shards vandaan komen — dat blijft
een teller zonder oorzaak.

⚠️ **En de handvatten verschillen tussen addons**: wij hangen het aan **item 258901**, Broker_MidnightEvents
en Plumber gebruiken **currency 3376**. Beide noemen cap 8. Niet uitgezocht welke de juiste is; de
opmerking boven `Config.lua:25` waarschuwt precies voor dit soort id-verwarring.

### Het echte gat: wij lezen delve-modifiers helemaal niet

GEMETEN met positieve controle (`grep C_DelvesUI` over `Modules/` geeft ~80 treffers, dus het patroon
werkt): we roepen `GetActiveDelveTier`, `GetDelveEntranceTiers`, `GetTieredEntranceType`,
`GetDelvesFactionForSeason` en de hele companion-traits-familie aan — **maar nergens iets dat de
modifiers van de huidige delve uitleest**. `Knowledge.lua:383` probeert wel
`GetTieredEntranceOptionalAffixTraitTreeID` in een sweep, puur als bestaanscontrole.

📌 Dit is precies waar deze addon voor bestaat: DBM vertelt je wélke spell, Zygor wat je moet doen,
maar niemand zegt *"deze delve heeft Dundun, ga hem zoeken"* — en vooral niemand zegt **wat het
kost**. Wij tellen de Restored Coffer Keys al (`3028`, `Delves.lua`), dus we kunnen als enige de zin
schrijven die er werkelijk toe doet:

> *"Deze delve heeft Dundun. Vind hem voor een extra Bountiful Coffer — je hebt er dan **twee**
> sleutels voor nodig en je hebt er **één**."*

Voorstel voor een volgende sessie, in deze volgorde:
1. **De modifiers van de actieve delve uitlezen** — dat doen we nu nergens; `GetTieredEntranceOptionalAffixTraitTreeID`
   is de kandidaat en staat al in de sweep.
2. **De sleutelwaarschuwing**, want die is het hele punt en niemand anders geeft hem.
3. **De macro aanbieden** als kant-en-klare regel — sluit aan op het al gebankte
   *"handige chat-regels / snelacties"*-idee.
⚠️ Bouw 2 niet zonder 1: een sleutelwaarschuwing voor een delve die Dundun helemaal niet heeft, is
precies het soort zelfverzekerde onzin waar deze dag over ging.

## 🔴 3 sep (avond) — de routes: drie agenten, vier fouten, en één die geen datafout is

Rob stond **in Harandar**, klikte een route naar Twilight Crypts, en kreeg in één handeling:

```
TomTom: Added a waypoint (Twilight Crypts …) in Zul'Aman
MH:     Fly from Har'alnor to Torntusk Overlook.
TomTom: Added a waypoint (Flight master: Har'alnor …) in Harandar
MH:     Flight master: Har'alnor is not on this continent. Head for Portal to Harandar first.
```

Zijn pijl las tegelijk **"Har'alnor — 1km 180m"**. Drie agenten erop; ze corrigeerden elkaar op een
belangrijk punt.

⚠️ **EERST EEN CORRECTIE OP MIJN EIGEN TUSSENRAPPORT.** Ik gaf door dat het regiomodel de SMC-omweg
verklaarde. **GEMETEN: onwaar.** Harandar (2413) én Har'alnor zitten allebei in regiogroep 2; geen
enkele opzoeking geeft daar een verkeerde waarde. Ik had één agent geciteerd voordat de tweede hem
weersprak — precies wat ik zelf een uur eerder had aangekondigd niet te doen.

### ✅ Gerepareerd

**1. De portaalzoeker vroeg nooit waar je staat.** `TravelPlan.lua` matchte alleen `p.toID ==
outermost` en nam de eerste treffer; de eerste rij naar Harandar ligt in **Silvermoon**. Vandaar
"neem het portaal naar Harandar" terwijl je in Harandar staat. Nu ook `p.mapID == here`.
📌 Streng met opzet: een portaal op een dérde kaart is geen stap maar een stap die zelf een plan
nodig heeft, en die bouwt deze planner niet. Het bestand zei het al twee regels verderop: *"Silence
beats a guessed hop."*

**2. `ns.lastTarget` deed twee banen tegelijk.** Het is waar de pijl naar wijst — dus het moet de
tussenstap worden, anders is de leg niet te routeren — én het is wat `AnnounceUnreachable` als
*de bestemming* behandelt. Toen de leg het overschreef, vroeg die functie "hoe reis ik naar
Har'alnor" over een punt dat juist gekozen was omdat het het dichtstbij is. Legs dragen nu
`leg = true` (`_mhTravelLegBusy` bestond al) en zijn uitgesloten van het onbereikbaar-verdict.
⚠️ Een **label**, geen onderdrukking: de leg houdt de pijl. Een leg is per constructie nooit
onbereikbaar — het is een vliegpunt op je eigen kaart of een portaal waar je naartoe kunt lopen.

**3. Drie foute rijen in `FlightPointsData.lua`**, alle drie tegen Zygors LibTaxi gemeten:
- **The Den** droeg x=70.74, een **verdieping-2-aflezing op de verdieping-0-kaart**. Op 2413 is het
  54.10 (zelfde y). ✅ Zelf nagerekend in plaats van op rapport aangenomen: de andere vier
  Harandar-punten komen exact overeen met LibTaxi, dus deze rij is de uitbijter.
  ⚠️ En het bereikte de speler wél, wat de header van dat bestand ontkent.
- **The Royal Exchange** stond op `"B"` en is **Horde-only** → Alliance werd naar een onbruikbare
  flight master gestuurd. **Silverglade Refuge** stond op `"B"` en is **Alliance-only** → spiegelbeeld.
  Precies de fout die die factieletter hoort te voorkomen.

### ✅ Punt 4 dezelfde avond gebouwd — en Robs `/mh arrow` corrigeerde twee dingen

**`/mh arrow` in Harandar (GEMETEN):** `jij: map 2413 (continent 2694)` en `doel: map 2413
(continent 2694)`, zelfde ouderketen, *"een ligt in de ander: ja"*. 🔴 **Mijn 2576-hypothese is dus
niet bevestigd** — beide uitlezingen gaven 2413. ⚠️ En uit die meting is *niet* af te leiden of de
melding wegbleef door mijn leg-label of doordat de kaart deze keer consistent was; die twee zien er
van buiten identiek uit.

🔴 **En zijn tweede screenshot ontkrachtte mijn eigen fix van een uur eerder.** Hij haardsteende naar
Silvermoon en kreeg *"The Den is not on this continent. Head for Portal to Harandar first."* Daar was
die zin **waar en nuttig** — en ik had hem net onvoorwaardelijk het zwijgen opgelegd. Mijn
rechtvaardiging (*"een leg is per constructie nooit onbereikbaar"*) geldt op het **moment dat de leg
gemaakt wordt** en geen seconde langer. De guard test nu of de leg nog op je huidige kaart ligt.
📌 Dezelfde les als het Vaults-blok van vanochtend: een feit dat één keer gemeten is, is geen feit
dat waar blíjft.

**`Modules/FlightNetworkData.lua`** (gegenereerd door `tools/build_flight_network.py`) draagt nu
verbonden-componentnummers uit Zygors taxi-graaf. GEMETEN: 804 knopen, **38 componenten**;
Har'alnor / Har'athir / The Den = **35**, Torntusk Overlook / Sanctum of Light / Tokka's Landing =
**1**. Dus `FlightPathExists("The Den", "Torntusk Overlook")` = **false**, bewijsbaar.

📌 **Componenten, niet Zygors root-sleutels.** "Zelfde root = verbonden" was de verleidelijke
aanname; niets belet een root twee losse clusters te bevatten. De graaf wordt globaal doorlopen en de
componenten worden echt uitgerekend. Twee ingebouwde controles laten de generator falen als
Har'alnor niet aan The Den grenst, óf als Har'alnor en Torntusk Overlook in dezelfde component
belanden — dan zou de tabel juist de instructie zegenen waarvoor hij gebouwd is.

📌 **En het levert een beter antwoord op**: vanuit Silvermoon zit *Sanctum of Light* in component 1,
net als Torntusk Overlook. Er ís dus een vlucht — de hele Harandar-omweg was nergens voor nodig.

⚠️ **Dekking is 129 van onze 649 punten.** Daarom is de poort zo geschreven dat alleen een harde
`false` iets tegenhoudt; `nil` betekent *onbekend* en laat de hint gewoon door. Zou `nil` blokkeren,
dan verdween het vliegadvies vrijwel overal en dat is van buiten niet te onderscheiden van kapot.
⚠️ De poort zit op **beide** helften — de chatregel én de leg. Ze verschillend gaten geven is precies
hoe Rob vier tegenstrijdige regels in één handeling kreeg.

### 🔴 Wat NIET gerepareerd is, en niet te repareren valt met een rij-correctie

**Dat vliegadvies bestaat niet.** GEMETEN in Zygors `flightcost`: Harandars netwerk is een **gesloten
eiland van vijf punten met nul uitgaande verbindingen**; Torntusk Overlook hangt aan Eastern Kingdoms.
Er is geen taxipad Har'alnor → Torntusk Overlook.

📌 **En onze tabel kán dat niet weten**: 155 platte per-kaart-lijsten, **zonder één verbinding**. Wie
"dichtstbijzijnde hier" aan "dichtstbijzijnde daar" plakt blijft onmogelijke vluchten produceren.
Rob: *"kijken we daarna wel naar 4"* — de kandidaat is Zygors `flightcost`-graaf importeren.

⚠️ Verder open uit de audit, niet aangeraakt: **Founder's Point** (2352, 8 Alliance-huisvestingspunten)
ontbreekt volledig terwijl de Horde-tegenhanger compleet is; `FLIGHT_POINTS` heeft geen `[2576]`
terwijl zes andere tabellen die map wél hebben; en `GetBaseZoneName(2395)` noemt Eversong "Zul'Aman".

⚠️ **Nog steeds afgeleid, niet gemeten:** dat de client hem als 2576 én 2413 door elkaar teruggeeft.
De twee chatregels zijn onder geen enkele waarde allebei waar, wat het sterk maakt — maar `/mh arrow`
in Harandar zou het beslechten en dat is nog niet gedraaid.

## ✅ 3 sep (avond) — Zygor is nu een tweede bron, maar NIET in `tip_audit`

Rob: *"ja doe zygor als tweede bron voor raid tips."* Gebouwd als `tools/zygor_tips.py`
(`_probe.py run zygor_tips`), en de meting die vooraf ging heeft het ontwerp bepaald.

🔴 **Zygor draagt géén spell-ID's.** Grep op vier van onze raid-ID's (`1300530`, `1284483`,
`1301510`, `1292188`) in `ZygorDungeonCommonMID.lua` geeft **nul**, terwijl datzelfde bestand
**619** `|grouprole`-tips heeft. Positieve controle geslaagd, dus die nul is echt. Zygor kan dus
geen enkel nummer bevestigen of ontkennen — precies de taak van `tip_audit`. Hem daar toevoegen
had een bron opgeleverd die het met niets eens is.

📌 **Wat hij wél heeft is wat DBM níét heeft.** DBM geeft ID's en een alarmsoort (`watchfeet`,
`justrun`, `breaklos`) — dat zegt wat voor **soort** ding iets is. Zygor geeft zinnen voor een
speler: *"Split into two groups for phase 2 to soak Spectral Coils."* Dat is de laag waarvoor deze
addon bestaat, en we hadden hem nooit gelezen.

### ✅ De harde bevinding: 13 rollen waar Zygor advies schrijft en wij niets leveren

Dit is een **structurele** vergelijking (onze `TIPS`-tabel tegen Zygors `_TANK_`/`_HEALER_`/
`_DAMAGE_`-secties) en vereist geen enkele tekstinterpretatie:

| boss | rol |
|---|---|
| Imperator Averzian | TANK, DPS |
| Vorasius | TANK |
| Fallen-King Salhadaar | TANK, HEALER |
| Nek'zali the Soulcoiler | HEALER, DPS |
| Vashnik the Malignant | HEALER, DPS |
| Sszorak | DPS |
| **Ula'tek** | **TANK, HEALER, DPS** |

Ula'tek heeft bij ons alléén een `steps`-regel en bij Zygor alle drie de rollen — de eindboss van de
huidige tier is onze dunste.

⚠️ **De tekst ernaast is om te LEZEN, geen verdict.** Bewust geen automatische "wij missen X": onze
tips schrijven abilities als `{SPELL:id}` en Zygor als naam, dus een zin die in onze bron ontbreekt
kan op het scherm van de speler wél staan. Een checker die dat niet kan zien zou vrijwel elke ability
als ontbrekend melden en er vrijwel altijd naast zitten.

### 📌 Twee koppelingen, en de tweede bevestigde iets

Namen matchen exact (`RaidCoachData.lua` spelt ze zoals de client, geverifieerd met Robs `/mh ej
save`). Daarnaast draagt Zygor `kill <Naam>##<npcID>` en wij `seedCreatureId`: **3 vergeleken, 3
gelijk, 0 verschil.** Imperator Averzian is 240435 in beide bestanden — een onafhankelijke
bevestiging van onze creature-ID's die we niet hadden.

⚠️ Zygor heeft geen stap voor 12 van onze bosses (o.a. Entombed Sentinels, The Lost Explorers, The
Twin Fangs, The Coiled Altar) — hij splitst sommige encounters anders op dan de journal. Geen
bevinding, wel de reden dat de dekking geen 100% is.

### ⚠️ En het gereedschap had zelf twee bugs in vijf minuten, de tweede door de eerste te repareren

Het waard om te onthouden, want het is het patroon van de hele dag: v1 gebruikte `\s*` en `\s` dekt
nieuwe regels, dus het patroon matchte ook de **raid**-entries en zette vijf instances in de lijst
"bosses waar Zygor niets voor heeft". v2 eiste `encounterID` direct achter de naam en liet daarmee
**élke Season 1-boss vallen** — die dragen `seedCreatureId` ertussen. **Een patroon aanscherpen is
niet gratis.** v3 staat andere velden toe maar verbiedt een nieuwe regel.

### ✅ En daarna gevuld — Rob: *"ja doe die 13 gaten maar"*

91 nieuwe regels (13 keys × 7 talen). `zygor_tips` meldt nu **0 gaten**.

📌 **Twee bronnen per regel waar het kon:** het WAT uit Zygors `|grouprole`-tips, het WELKE SPELL uit
DBM. Een `{SPELL:}`-link staat er alleen waar DBM dezelfde ability kent — `1241836` Shadowclaw Slam,
`1246175` Entropic Unraveling, `1297630` Restless Amani, `1301118` Grasping Fangs. **Blackening
Wounds, Dig In en Venomous Heart kennen DBM noch enige ID-bron**, dus die staan als gewone Engelse
naam zónder link, in plaats van een nummer dat er compleet uitziet.

🔴 **En de linter ving meteen een fout in mijn eigen aura-parser van vanmiddag.** `1301118` kwam
binnen als `1 new / HARD`. Oorzaak: DBM schrijft `AddAuraSoundOption(1301118, true, -36292, …)` en
die parent is **negatief** — een encounter-journal-sectie die DBM leent voor de optienaam, geen
andere cast. Mijn parser eiste cijfers, gaf op, en het ID viel terug op WEAK. Een negatieve parent
telt nu als **self**: de AURA-OF-val heeft aan de andere kant een écht spell-ID nodig. Derde
positieve controle toegevoegd zodat het niet stil terug kan komen.
📌 Dit is de check die precies deed waarvoor hij bestaat: hij hield een nieuw geschreven regel tegen,
en de fout zat niet in de regel maar in het gereedschap dat hem beoordeelde.

⚠️ **En één stijlfout van mezelf:** ik schreef *"Tank: …"* in de nieuwe raid-tankregels, want zo doet
`DungeonTips` het. `RaidTips` doet dat níét — daar komt de rol uit **kleur** (`DungeonBossWindow.lua:961`)
of een **rol-icoon** (`DungeonGuide.lua:277`). 28 regels teruggedraaid. Volg de buren in het bestand
dat je bewerkt, niet die je het laatst gelezen hebt.

🔴 **WAT DIT NIET IS.** Niemand hier heeft deze gevechten gedaan — Rob zei het met zoveel woorden
over Ula'tek. De tekst is een getrouwe weergave van een gids die spelers volgen, geen ervaring. Dat
is een **zwakkere basis dan de DBM-gedekte spell-ID's ernaast**, en het staat als zodanig in
`RaidCoachData.lua` boven de tabel. Komt er ooit een melding dat een van deze regels niet klopt:
waarschijnlijk, niet verrassend.

## ✅ 3 sep (avond) — Zygor 9.6 opnieuw gelezen: onze conclusie klopte, onze volgorde niet

Rob vroeg de addon-updates na te lopen; Zygor had die middag een nieuwe build gezet (gidsbestanden
gestempeld 18:59) en meldde iets over Ula'tek.

**1. `A Toxic Tour` — classificatie bevestigd, met beter bewijs dan we hadden.** `98515` staat nu
**zes keer** in `ZygorDailiesCommonMID.lua`, waar het op 2 sep nul keer stond. Dat lijkt een
ommekeer en is het niet: de échte dailies beginnen in dat bestand pas bij `label
"Begin_Daily_Quests"`, en die lijst noemt acht ID's — `96644, 96640, 96643, 98420, 98419, 96641,
96642, 96639`. 98515 zit er niet bij. Het staat in de **intro-keten** die de gids ervóór doorloopt.
📌 Precies de val van 2 sep, één laag dieper: *"het staat in het dailies-bestand"* was toen waar en
betekende niets, en is nu opnieuw waar en betekent nog steeds niets.

🔴 **2. Maar de SPEELVOLGORDE klopte niet, en dat is nu gerepareerd.** Zygors gids:
98388 inleveren → **97640 én 98515 samen aannemen** → 97640 inleveren, 98428 aannemen → 98428
inleveren → dan pas 98515 inleveren, na vier `stickystart`-objectives. Dus 98515 wordt **als tweede
opgepakt en als laatste ingeleverd**; wij zetten hem op plek 3. Een speler die de keten juist volgt
zag stap 4 groen worden terwijl stap 3 open bleef — een checklist die er kapot uitziet juist wanneer
je hem goed doet. Chain is nu `98388 → 97640 → 98428 → 98515`.
⚠️ Zygors eigen `QuestDBData.lua` draagt **beide** volgordes in verschillende rijen en kan het dus
niet alleen beslechten. De gids is de speelvolgorde en is eenduidig. Spreekt een bron zichzelf tegen,
neem dan het deel dat beschrijft hoe je het dóét.

**3. Ula'tek: Zygor bevestigt onze bewuste WEAK.** Zijn raid-gids (`kill Ula'tek##268956`, patch
120100) zegt *"Split into two groups for phase 2 to soak Spectral Coils"*. Onze regel zegt soak
`1300530` maar niet met `1300685` erop, en DBM's commentaar bij `1300685` zegt *"can't soak Spectral
Coils"*. **Twee onafhankelijke bronnen, hetzelfde antwoord** — dat ene twijfelgeval in de baseline is
extern bevestigd.

⚠️ **OPEN, en bewust niet gebouwd:** dezelfde gids zegt *"Run opposite of the wing that is pulled
back for Caustic Waves"* (= `1292188`, dat wij alleen *"a raid-damage window"* noemen) en *"Grab the
eggs on the pull and keep them away from anything green"*, wat wij helemaal niet noemen. Rob kent
deze fight niet (*"ik weet niets meer van die fight sorry"*), dus niemand hier kan het verifiëren.
Raid-strategie in 7 talen uitrollen op gezag van één gids is precies wat deze dag drie keer heeft
afgestraft. Ligt klaar zodra er iemand is die het gedaan heeft.

📌 **En de grotere vondst: Zygor heeft per-rol strategie voor élke raid-boss en wij gebruiken die
niet.** `tip_audit` kijkt alleen naar DBM, en DBM geeft ID's en cues maar niet wat een speler moet
DOEN. Zygor geeft precies dat, lokaal en machinaal leesbaar — dezelfde eis waaraan MythicDungeonTools
voldeed. Kandidaat voor een tweede bron in de audit.

## ✅ 3 sep — de Home-kop beval endgame aan op een level 68 — GEREPAREERD, drie kleine resten onderaan

Rob, op een level-68 Paladin: *"onze MH laat dingen zien die we nog helemaal niet kunnen doen
(toch??)"*. Ja. Vier agenten erop gezet — één die alleen mat, twee die het oneens moesten zijn, één
die de andere ~50 addons afliep — en alle vier kwamen op dezelfde eerste prioriteit uit.

**De oorzaak, gemeten:** `ResetRoutine.lua:911` koos de kop met `s.open and s.heroEligible ~= false`
— hero-waardig **tenzij** een stap nee zegt. Van de elf stap-constructors in dat bestand zei er
**twee** nee (Ritual Sites, Void Assaults). De rest was hero-waardig op elk level. Zo werd Halduron
Brightwing de kop op level 68, mét een "Take me there"-knop.

### 📌 De scheidslijn waar alles om draait

> **Aanwezigheid is een kaart. De kop en elke routeknop zijn een aanbeveling.**

Een endgame-weekly in de lijst *tónen* leert een levelende speler hoe de week eruitziet — precies
waar deze addon voor bestaat. Hem *aanbevelen* kost die speler een echte vlucht naar een NPC zonder
uitroepteken, waar hij niet kan zien of de addon fout zit of hijzelf.

⚠️ **Daarom is verbergen afgewezen**, hoewel dat de eerste ingeving was. Een level 68 die This Week
opent en een leeg paneel ziet concludeert niet "netjes gefilterd" maar "kapot" — en een verborgen
regel is niet te onderscheiden van een bug die niemand op max level ooit kan reproduceren. Dat is
letterlijk de regel uit `CLAUDE.md` waar `/mh arrow` voor bestaat, en we hebben er vanmorgen nog een
levend voorbeeld van gevonden (het Vaults-blok dat Rob op geen enkel character kan bereiken).

### ✅ Wat er gebouwd is

1. **`heroEligible` faalt nu dicht.** `== true` in plaats van `~= false`, en elke open stap zegt
   zelf wat hij weet. Een stap die niemand annoteert verliest voortaan de kop in plaats van hem
   stilzwijgend op te eisen — de volgende weekly kan deze bug dus niet herhalen dóór vergeetachtigheid.
2. **`CanActAt(minLevel)`** — en het addertje zit in `nil`. Dat betekent **niet** "op elk level goed"
   maar "niemand heeft het gemeten". Halduron draagt `minLevel = nil` met opzet (een level-80 warlock
   kreeg zijn level-variant `95468` op 11 jun) — maar **level 68 is nooit getest**, en twee van zijn
   drie quests zijn max-level dungeon-weeklies. Op max level is een ongemeten eis onschadelijk;
   daaronder kost hij de aanbeveling en behoudt hij de regel.
3. **De teller telt wat je kunt doen.** Hij sloot alleen `dim` uit, waardoor Robs "3 of 8" de Ritual-
   en Void-stappen meetelde — de twee die hetzelfde bestand tien regels eerder als endgame markeert.
   De kennis was er, en werd toegepast op de kop maar niet op het getal eronder.
   📌 `done` blijft álles tellen wat af is, ook wat dit character vandaag niet kon starten: een
   account-wide weekly die af is, ís af, en aftrekken zou het getal op een alt laten dalen.
4. **De "Start route"-knop deed het ook.** `ComputeOpenPins` testte alleen `open and pin`, dus die
   stuurde een level 68 dwars door de endgame Bazaar-hub en noemde de stops in chat. Alleen de kop
   repareren had de dúúrdere versie van dezelfde fout laten staan.
5. **Twee groepen in de lijst** — het actievoerbare deel genummerd 1..n (de nummering liep eerst
   1,2,3,4,5,6,7,10,11 omdat hij de rauwe array-index gebruikte), daaronder *"Later, als je verder
   levelt:"* met de rest, klikbaar maar ongenummerd. Een nummer leest als een plek in de rij.
6. **`/mh resetdebug` zegt nu waaróm** een stap is overgeslagen (`hero=NO (out of reach)`), plus cap,
   level en de tally. Verplicht, want de filter vuurt nooit op Robs eigen max-level characters.

### ⚠️ Wat hier NIET mee opgelost is

- **`CHANGELOG_260_3` (`enUS.lua:1890`) belooft al sinds 2.6.0:** *"While you are levelling it never
  points you at endgame content you cannot do yet."* Die zin was onwaar en is nu grotendeels waar
  gemaakt — maar hij is nooit ingetrokken toen hij het níét was. Rob beslist of hij blijft staan.
- 🔴 **Halduron op level 68 is nog steeds ongemeten.** Wij weten alleen dat een level 80 zijn
  level-variant kreeg. Of een 68 daar iets krijgt kan alleen Rob vaststellen door erheen te lopen.
  Zolang dat niet gemeten is, is `minLevel = nil` het eerlijkste dat we hebben — het kost hem nu de
  kop, niet zijn regel.
- **`ns.GetDelveCapLevel()` valt terug op een hardgecodeerde `80`** (`DelveWeeklyTrackers.lua:248`),
  drie niveaus diep ná twee API's. ⚠️ Een agent meldde dit als *"dus elk character van 80-89 telt als
  max level"* — **dat klopt niet zoals het er stond**: die val-terug vuurt alleen als beide API's
  falen. Het is een verouderde valstrik die stil de verkeerde kant op faalt, geen bewezen actieve bug.
  Niet aangeraakt; het waard om bij te werken naar 90 of te laten falen in plaats van te gokken.
- **Een ingeklapt blok** wilden beide agenten liever dan een kopregel. Bewust niet gedaan: dat vraagt
  de collapse-machinerie erbij en vandaag is er al één layout-bug geweest die precies daar zat.

### 🔴 En de eerste gate was nog niet goed: ik keek naar de quest, niet naar de bestemming

Robs volgende test, inmiddels level 69 in de Azure Span op de Dragon Isles: de kop koos de
**Herbalism-weekly**, en de vlieghint zei *"Take Sanctum of Light"*. Zijn vraag: *"kan die daar al
heen dan, en hoe dan??"*

Ik had die stap `heroEligible = true` gegeven met de redenering dat profession-weeklies **skill**-gated
zijn en niet level-gated. Dat klopt, en het is gemeten. **Maar de beschikbaarheid van de QUEST is een
andere vraag dan de bereikbaarheid van de TRAINER**, en ik heb de verkeerde gecontroleerd.

📌 **GEMETEN, en dit feit beslecht het hele "This Week"-ontwerp:** élke stop in `ResetRoutine.lua`
ligt op map **2393, Silvermoon City** — `VAULT_MAP`, `STATION_MAP`, `GIVERS_MAP`, `HUB_MAP` en alle
`TRAINER_PINS`. De weekroutine is geen lijst die toevallig wat endgame bevat; **hij ís Midnight-
endgame, in zijn geheel, in één stad.** Midnight loopt van 80 tot 90 (`TAB_GUIDE = "Leveling (80-90)"`).

`MidnightFloorMet()` gate nu de vault- en trainer-stappen. ⚠️ **80 is een content-feit, geen API-feit**
— er bestaat geen aanroep die de ondergrens van een expansie geeft, alleen de bovengrens — dus het
staat één keer opgeschreven naast het bewijs in plaats van als los getal door het bestand.

⚠️ **En "all done" zou hier een leugen zijn geworden**, precies de faalvorm waar ik Rob 's ochtends
voor waarschuwde: niets is actievoerbaar, dus de kop viel door naar de felicitatie.
`HOME_HERO_NONE_YET_FMT` zegt nu wát er aan de hand is en op welk level het opengaat.

✅ **De grens is diezelfde avond bevestigd, en niet door ons.** Rob: *"er staat vast ergens online
vanaf wanneer je daar naartoe kan?!?"* Ja: Blizzards eigen aankondiging en twee gidsen zeggen dat
**Eversong Woods opengaat op level 80** en dat Midnight van 80 tot 90 loopt met Silvermoon als hub.
Dat is een derde bron naast onze eigen `TAB_GUIDE = "Leveling (80-90)"` en Robs scherm. `MIDNIGHT_FLOOR_LEVEL = 80` staat.

⚠️ **Nog steeds niet gemeten, en het is een andere vraag:** of het spel een level 69 fysiek
tegenhoudt bij het portaal. 80 is de grens waarop de *content* begint; of de *deur* dichtzit is iets
wat alleen iemand die er doorheen loopt kan zeggen. Voor onze gate maakt het niet uit — wij bevelen
het hoe dan ook niet aan — maar schrijf het niet op als bewezen.

🔴 **En dat "geen bug"-antwoord van mij was te snel — Rob had gelijk.** Zijn screenshot toonde
*"Cuzoth — Item Upgrades (other continent — travel back) head for Portal to Silvermoon"*. Ik zei: dat
is een pin uit het Silvermoon-tabblad (`UI.lua:811`) waar hij zelf op klikte, dus werkt het. Zijn
weerwoord: *"eigenlijk zou dit soort adviezen niet moeten kunnen, tenslotte kan ik nog niet naar dat
gebied want ik ben <80. toch"*

Ja. Dat hij erop klikte **verklaart waarom de regel verschijnt en rechtvaardigt niet dat we een pijl
zetten** naar een gebied waar hij niet in kan. Precies dezelfde fout als de weekly-kop, één scherm
verderop: ik keek naar wat hij vroeg in plaats van naar wat hij kan.

`SetSMCWaypoint` staat nu achter `ns.MidnightFloorMet()`. 📌 **De kaart blijft** — opzoeken waar
Cuzoth staat is naslag, en een stadsgids die onder 80 leeg wordt is precies het verbergen dat we 's
ochtends hebben afgewezen. Wat stopt is de **route**: geen waypoint, geen pijl, geen reisplan, plus
een regel die zegt waarom. ⚠️ *Nearest flight point* en *world_tab* zijn bewust niet gegate: de
eerste leest waar je staat en werkt overal, de tweede opent alleen een tabblad.

⚠️ **En de routeknop stond er ook nog.** Robs screenshot toonde onder de lijst nog *"Set TomTom route
along the open stops (vault, hub, station)"* — die drie liggen allemaal in Silvermoon en stonden op
dat moment allemaal in de *"Later"*-groep. De **pins** waren gefilterd, de **knop** niet, dus zijn
eigen label adverteerde exact wat onbereikbaar was. `ns.CountOpenResetPins()` gate hem nu.
📌 Het patroon van de hele dag in één zin: **een filter is pas af als élke plek die eruit put hem
kent.** Vier keer nu — de hero, de teller, de route-pins, en de knop erboven.

### 🔴 En meteen daarna: de Hearthstone werd aangeboden zonder te kijken waar hij heen gaat

Robs eerste test van de nieuwe kop koos de profession-weekly — dat werkte. Maar de reis-popup bood
hem een **Hearthstone naar Silvermoon City** aan, terwijl die van hem op **Pinewood Post** staat.

`Delves.lua`, op **twee** identieke plekken:

```lua
local isHSVisible = (hsStartTime == 0 and not isHub and not isNearPortal)
```

Drie voorwaarden — niet op cooldown, niet in een hub, geen portaal dichtbij — en **nergens** de
vraag waar die steen landt. Er is nooit iemand geweest die het vroeg.

📌 **Derde keer op één dag dezelfde vorm**: een zelfverzekerde aanbeveling gebouwd op iets dat we
nooit gemeten hebben (de tip-ID's, de level-68-kop, en nu dit). Deze is de ergste van de drie, want
een verkeerde pijl loop je terug — een verbruikte Hearthstone-cooldown niet.

`HearthstoneGoesTo(targetZoneName)` staat nu naast `PortalUsable`, en beide aanroepplekken hebben de
gate (het commentaar dáár waarschuwt al dat een gate op één van twee identieke lussen het halve
antwoord geeft).

⚠️ **Bewust conservatief, en de ruil is echt.** `GetBindLocation` geeft een **herbergnaam**
("Pinewood Post"), het doel een **zonenaam** ("Silvermoon City"). Wie in een herberg bínnen de
doelzone gebonden is onder een andere naam, krijgt nu geen Hearthstone aangeboden terwijl die wél
had gewerkt. Een gemiste sluiproute kost een vlucht; een verkeerde kost de cooldown én het
vertrouwen. Robs tegenproef op de testlijst is precies deze: bind in Silvermoon en kijk of hij
terugkomt.
🔴 En hij faalt **dicht**: geen `GetBindLocation`, of een leeg antwoord, betekent *we weten het niet*
— en dat is exact de toestand die deze bug maakte, dus die mag niet doorlaten.
📌 `/mh portals` print nu ook je Hearthstone-bestemming en waarom hij wel of niet wordt aangeboden.
Zonder popup is "terecht stil" niet te onderscheiden van "kapot", en dit onderdrukt vaker dan het
toont.

### 📎 Wat de andere addons doen (gemeten, geen consensus geforceerd)

Het splitst per soort UI, niet per smaak. **Inhoudslijsten tonen het in rood mét de eis** — Zygor
zet *"Required level: 90"* in rood en verbergt zo'n gids nóóit; de HandyNotes-familie zet "toon
ontoegankelijk" zelfs **standaard aan**. **Score- en rostersystemen zwijgen** (RaiderIO, DBM
Keystones). Eén addon verbergt een weekly-regel, en die is mogelijk van dezelfde schrijver als wij —
dus geen onafhankelijke stem, en te weinig om een conventie op te bouwen.
📌 Eén gewoonte is het overnemen waard en nu nog niet gedaan: **rood = nog niet, grijs = voorbij.**
Wij gebruiken grijs voor allebei.

## 🔴 3 sep — 31 van onze 105 raid-spell-ID's houden geen stand tegen DBM

Rob liep een encounter op de Coiled Isle en snapte niets van onze aanwijzingen. Ula'tek met de hand
nagekeken: van onze vier ID's dreef er één een echte DBM-waarschuwing, één stond alleen in een
aura-geluidsoptie (de DoT van een ándere cast, terwijl wij zeggen *"dodge"*), één stond alleen in
een `--TODO`-commentaar, en één bestaat in geen enkele geïnstalleerde addon.

Rob koos DBM als maatstaf en zijn argument is het juiste: **DBM's ID's worden elke week in echte
pulls uitgeoefend door mensen die het meteen horen als een waarschuwing op het verkeerde ding
afgaat.** De onze komen uit datamining, in dit geval van vóór de boss bestond — onze eigen tiptekst
zegt dat zelfs, in de laatste bullet, ná vier regels die als feit lezen.

`tools/raid_tip_audit.py` (via `_probe.py run raid_tip_audit`). **GEMETEN over alle raids:**

| | |
|---|---:|
| spell-ID's in onze raid-tips | 105 |
| **ABSENT** — staat in géén DBM-mod | **21** |
| **WEAK** — staat er wel, maar DBM waarschuwt er nooit op | **10** |
| tipregels met minstens één van beide | **15 van 28** |

Ergste regels: `BELOREN_STEPS` (5), `VANGUARD_STEPS` (4), `ULATEK_STEPS` en `AVERZIAN_STEPS` en
`CROWN_STEPS` (3). Volledig schoon: Twin Fangs, Coiled Altar, Lost Explorers (op één na), Vashnik,
Lura, en beide Vaelgor-rolregels.

### 🔴 En de checker zelf was twee keer fout, in tegengestelde richtingen

Het waard om te bewaren, want beide versies zagen er overtuigend uit:

- **v1** accepteerde elke `mod:Iets(id` als waarschuwing. `AddAuraSoundOption(1292403, …)` matchte,
  dus precies het ID dat met de hand fout bleek kreeg een vinkje. **Te ruim.**
- **v2** eiste dat het ID het *eerste* argument was van een zelf opgesomde lijst constructors.
  Allebei die aannames zijn onwaar: DBM schrijft `NewCDCountTimer(20.5, 1284483, …)` mét de duur
  vooraan, en `NewCountAnnounce` staat in geen enkele lijst die ik zou verzinnen. **Te streng** —
  24 WEAK-meldingen waarvan er met de hand meteen drie onterecht bleken.
- **v3** classificeert per **regel**: staat `mod:New` op de regel die het ID draagt, dan handelt DBM
  erop; staat er `AddAuraSoundOption`/`RegisterAltSpellName`, of alleen een commentaar, dan kent hij
  het nummer slechts. Geen namenlijst, geen aanname over argumentvolgorde.

📌 De positieve controle draagt nu ook `1305959` en `1284483` — juist de twee waar v2 op stukliep.
Een controle die alleen makkelijke gevallen bevat, bevestigt de bug die je erin hebt zitten.

⚠️ **Nog steeds geen bewijs.** DBM waarschuwt alleen op wat het wíl bewaken, dus ABSENT is een sterk
signaal en geen verdict. Wat het wél bewijst: dat ID is nooit tegen de mod gelegd van het team dat
deze boss elke week doodt.

### ✅ Lint-check [19] staat erin, mét een baseline in plaats van een muur

31 ID's falen vandaag. Een check die daar allemaal op stukloopt wordt binnen een week uitgezet en
vangt daarna niets; een die zwijgt is even nutteloos. Dus: de gemeten achterstand staat in
`tools/raid_tip_baseline.json` en is **SOFT**; alles wat er **niet** in staat is nieuw en **HARD**.
Hij kan de bestaande rommel niet repareren, maar wel voorkomen dat het volgende ID zo geschreven
wordt als `1290779` — en het bestand hoort te krimpen.

⚠️ Verwijder je een regel uit de baseline zonder de tip te repareren, dan valt de build om. Dat is
de bedoeling.
✅ Repareer je een tip, dan meldt [19] zelf dat de baseline-regel weg mag.

📌 **Bewezen dat de HARD-tak vuurt**, niet aangenomen: één baseline-regel tijdelijk weggehaald
(`1290779`, het ID waar dit mee begon) → `1 new`, `HARD issues: 1`, exit-code 1, daarna hersteld.
Een check die niemand ooit heeft zien falen, is een check waarvan niemand weet dat hij werkt.

### ✅ The Venomous Abyss is herschreven uit DBM — 31 → 23, 15 → 10 regels

Robs eigen raid eerst. Zes gevlagde regels daar, nu **nul**. Het werkwoord komt telkens uit DBM's
eigen audio-cue in plaats van uit onze interpretatie: `justrun` = rennen, `helpsoak` = soaken,
`watchstep` = ontwijken, `bigmob` = switchen. Waar DBM geen mening heeft, zegt de regel niets.

| regel | wat er mis was |
|---|---|
| **Ula'tek** | 4 ID's → 12. `1292403` was de DoT van een ándere cast (wij: "dodge"), `1287265` stond in een `--TODO`, `1290779` bestond nergens. DBM waarschuwt op twaalf dingen; wij noemden er nul bij naam. |
| **Nek'zali** | `1294933` werd nooit gewaarschuwd. Vervangen door de echte set, inclusief `1305421` (group soak) die wij als losse Engelse naam in de tekst hadden staan. |
| **Entombed Sentinels** | `1284590` → `1284588` (Vitriolic Stasis, DBM's "MATHPUZZLE"). `1284485` is door DBM zélf uitgezet als *"Possibly unused"* — geschrapt, vervangen door `1288232` (group soak) en `1284251` (big adds). |
| **Lost Explorers** | `1295886` → `1292104` Mushroom Toss. 📌 En DBM **beslecht onze eigen open vraag**: onze tekst zei *"onze twee bronnen zijn het oneens — run out of stack up"*; DBM's cue is `justrun`. |
| **Vashnik** | `1294994` is een sub-ability die DBM bewust níét bewaakt; de ouder is `1282114`. Wij zeiden "dodge" tegen een debuff-fase. |
| **Sszorak (tank)** | `1285430` bestond nergens; de tank-combo is `1277025`. Onze zin klopte al — alleen het ID niet. |

⚠️ Eén bewuste WEAK toegevoegd: `1300685` (Soul Constrictor) bij Ula'tek. DBM waarschuwt er niet op,
maar documenteert in een commentaar *"can't soak Spectral Coils"* — precies wat onze regel zegt.
Staat als zodanig in de baseline; het is geen slordigheid maar een keuze.

🔴 **En het herschrijfscript loog over zijn eigen garantie.** `rewrite_abyss.py` zei in zijn
docstring dat het "weigert een gedeeltelijk resultaat te schrijven" en schreef het bestand vóór de
telling: 17 van 21 toegepast, daarna exit 1. Er ging niets stuk, maar de garantie was decoratief.
De vervolgscripts zoeken eerst alle vervangingen en raken het bestand pas daarna aan.

### ✅ De oudere raids: **0 ABSENT** — en het patroon dat alles verklaarde

Pas toen alle 28 regels naast elkaar lagen viel het op: **elke gevlagde tip eindigde op een staart**
`"• Key casts: … (EXBoss timeline — confirm in-game.)"`. Dat is een **tweede bron**, aangeniet aan
een handgeschreven bullet-lijst, en daar zat vrijwel elk fout ID in. De staart zei het zelf —
*"confirm in-game"* — en dat is nooit gebeurd.

Dus geen prose herschreven op gevoel, maar weggehaald wat we niet kunnen onderbouwen: elke bullet
met een ID waar DBM niet op waarschuwt, plus de geïmporteerde staart. **56 regels, 84 bullets weg**,
in zeven talen tegelijk — een lijst-operatie, geen vertaalklus, dus er is in geen enkele taal een
zin verzonnen.

| | vóór | na |
|---|---:|---:|
| spell-ID's die nergens in DBM staan | 21 | **0** |
| ID's die DBM kent maar nooit waarschuwt | 10 | **1** |
| tipregels met minstens één | 15 | **1** |

Die ene is Ula'teks Soul Constrictor, de bewuste keuze uit de vorige sectie.

⚠️ **DAT KOSTTE OOK GOED ADVIES, en dat is een keuze geweest.** Vanguards staart droeg
`1276368` (Execution Sentence, DBM's GROUP SOAKS) en `1246485` naast drie ID's die nergens bestaan;
de bullet schrappen gooit alle vijf weg. Chimaerus ging van 6 ID's naar 1, Crown van 7 naar 1,
Beloren van 9 naar 1. De prose-bullets overleefden en de teksten lezen nog steeds als advies, maar
ze zijn **dunner**. Verkeerd advies weghalen weegt zwaarder dan goed advies bewaren — en de helft
die goed was hoort terug als een geschreven bullet, niet als restant van een tijdlijn.

### ✅ En teruggevuld uit DBM — alle 28 tipregels staan nu op DBM

De vier dunste regels zijn opnieuw gevuld uit DBM's eigen waarschuwingslijsten: **Chimaerus 1 → 8
ID's, Vanguard 3 → 10, Crown 1 → 9, Beloren 1 → 8.** Execution Sentence (`1276368`) is terug als
geschreven bullet in plaats van als tijdlijn-restant.

📌 **Aangevuld, niet herschreven.** De overgebleven bullets waren met de hand geschreven en
beschrijven het gevecht in woorden — dat is de goede helft. Aanvullen laat die ongemoeid en houdt
de diff precies gelijk aan wat nieuw is, waardoor een fout hier geen tekst kan beschadigen die al
klopte.

**Eindstand van de dag: 105 spell-ID's over 28 tipregels, 0 ABSENT, 1 bewuste WEAK.**
Begonnen bij 31 twijfelgevallen over 15 regels.

⚠️ **Wat dit NIET is.** Dat elk ID nu door een DBM-waarschuwing gedekt wordt, zegt dat het bestaat
en dat DBM erop reageert — **niet** dat onze zin eromheen klopt. De werkwoorden komen uit DBM's
audio-cues (`justrun`, `helpsoak`, `watchstep`, `bigmob`, `colorchange`), wat sterk is maar geen
vervanging voor iemand die de boss echt doet. Rob komt naar eigen zeggen niet snel in een raid; de
eerste die dit in een pull leest, leest het ongetest.

## 🔴 3 sep — de audit uitgebreid naar dungeons, delves en rituals: 410 ID's, 160 tipregels

Rob: *"kunnen we de dungeons en Delves ook met DBM data checken en dicht timmeren?"* Ja — en de
raid-map bleek maar een derde van het geheel. `tools/tip_audit.py` (hernoemd van
`raid_tip_audit`) dekt nu `RaidTips`, `DungeonTips`, `DelveTips` en `RitualTips`.

| | ID's | twijfel | regels |
|---|---:|---:|---:|
| raids | 105 | 1 | 1 |
| **dungeons** | 240 | **23** | **19** |
| delves | 44 | 40 → zie hieronder | 11 |
| **rituals** | 21 | **9** | **4** |

### 🔴 Twee keer bijna een crisis verzonnen uit andermans TODO-lijst

**Eén: delves gebruiken geen nummers.** `DelveTips.lua` schrijft `{SPELL:@shadow_bolt}`. Mijn
numerieke patroon vond nul van de 154 placeholders, en de eerste uitvoer had **geen delve-regel** —
een heel contenttype ontbrak en zag er precies uit als een contenttype zonder problemen. Gevangen
doordat de telling zei dat er 154 te vinden waren. De tokens lossen op via
`Modules/DelveSpellIds.lua` en zijn dus wél te controleren.

**Twee: DBM is voor delves geen maatstaf.** Na het oplossen meldde de tool **40 van 44 delve-ID's
ABSENT** — dat leest als "onze delve-tips zijn vrijwel helemaal fout". Eén mod met de hand
opengeslagen zei het tegendeel: `DBM-Delves-Midnight/Encounters/Antenorian.lua` is een **stub** met
alleen `SetEncounterID` en `RegisterCombat`, en `--mod:SetCreatureID(0)--TODO` er nog in. Hydrangea
en Gladius Slaurna idem.

**GEMETEN dekking**, nu vast onderdeel van het rapport:

| DBM-pakket | mods mét waarschuwingen |
|---|---|
| DBM-Raids-Midnight | 17 / 17 |
| DBM-Party-Midnight | 31 / 36 |
| DBM-Lairs-Midnight | 2 / 2 |
| **DBM-Delves-Midnight** | **4 / 30** |

📌 Dus ABSENT op een delve-ID betekent **DBM heeft geen mening**, niet dat wij fout zitten. Zonder
die controle had ik een ramp gerapporteerd die in werkelijkheid iemand anders' TODO-lijst was.

### ✅ Robs tweede vraag gaf het antwoord: een onafhankelijke tegenmeting

*"er zijn toch ook speciale delve addons en sites?"* Geen enkele geïnstalleerd (geen Delve
Companion, DelveGuide of Everything Delves), maar **GTFO** wel — een spell-ID-database van
grondeffecten, 7815 ID's.

⚠️ *"Onze delve-ID's staan niet in GTFO"* bewijst op zichzelf niets: GTFO catalogiseert alleen waar
je uit moet lopen, en wij noemen ook interrupts, buffs en fasewissels. Dus **vergelijkend** gemeten,
met de raids als ijkpunt omdat die inmiddels volledig DBM-gedekt zijn:

| content | in GTFO | totaal | overlap |
|---|---:|---:|---:|
| raids | 13 | 105 | 12,4% |
| dungeons | 55 | 240 | 22,9% |
| **delves** | 7 | 44 | **15,9%** |
| rituals | 2 | 21 | 9,5% |

**Delves zitten midden in het normale bereik — hóger dan de raid-ID's.** Er is dus geen enkele
aanwijzing dat de delve-ID's kapot zijn, en zeven ervan zijn nu onafhankelijk bevestigd.

### ✅ Robs tweede tegenvraag repareerde de checker zélf

*"er zijn toch ook sites en addons op cf voor alles"* — ja, en het landde precies op de zwakste
plek. **MythicDungeonTools** staat geïnstalleerd en heeft per-dungeon spell-tabellen voor Midnight:
een **tweede lokale maatstaf**.

⚠️ De eis is *lokaal en machinaal leesbaar*, niet gezag in het algemeen. Een website kan een linter
niet elke run opnieuw controleren, en de gidsen waar dit project al op verbrand is waren juist
zelfverzekerd fout. Een addon op schijf kun je morgen opnieuw parsen.

🔴 **En het legde een echte fout in mijn eigen classifier bloot.** Commentaar strippen was twee keer
goed en één keer fout: het houdt een `--TODO` tegen, maar DBM legt in commentaar óók **beslissingen
over echte spells** vast — en die lazen als ABSENT:

| onze ID | wat DBM's commentaar zegt |
|---|---|
| `1296219` | *"isn't in journal but has encounter event… Possibly not needed"* |
| `1251813` | *"has a private aura but it doesn't need an alert"* |
| `1214352` | *"ENCOUNTER_WARNING intercept is used instead"* |

Alle drie echte spells, alle drie ook in MythicDungeonTools, en ik had Rob op pad gestuurd om drie
correcte regels te "repareren". Er is nu een derde verdict: **`noted`**.

**dungeons 23 → 19 · rituals 9 → 7 · delves 40 → 33**, puur door beter te kijken.

📌 **Eindstand van de dag: 407 ID's over 160 tipregels — raids 1 (bewust), dungeons 0, rituals 0,
delves 33 (geen maatstaf).** De 410 in de kop hierboven is de meting op het moment van uitbreiden,
niet de stand nu. ⚠️ De dungeon-nul komt maar voor een klein deel uit herschrijven: 13 van de 19
waren nooit fout, zie *"de laatste 14"* verderop.

### ✅ Rotmire herschreven — 6 van 8 ID's klopten met niets

Zijn regel eindigde op *"(Datamined — confirm in-game at launch.)"*: dezelfde vorm als de
EXBoss-staart bij de raids, vóór de launch gedumpt en daarna nooit gecontroleerd. DBM-Lairs dekt
2/2, dus hier bewijst ABSENT wél iets.

📌 En één correctie die de speler direct raakt: onze tekst noemde `1221637` **"de wipe"**. DBM's cue
is `carefly` — het is een **knockback**. Wie op de rand stond en dat las, verwachtte het verkeerde.

Nu uit DBM: knockback (1221637), adds (1221622), raid-damage (1221787), pool op jou (1222088) en
de tank-klap (1221781).

### ✅ Taz'Rah en Nalorakk herschreven — de ID's zaten er telkens náást

Rob: *"ja doe Taz'Rah en Nalorakk ook nog."* Vijf gevlagde ID's over drie regels, nu **nul**.

📌 **Het patroon is hier anders dan bij de raids, en interessanter: onze zínnen klopten.** Bij
Taz'Rah beschreven alle drie de bullets een mechaniek die DBM ook kent — alleen droeg elke bullet
het verkeerde nummer. "Sleurt iedereen naar zich toe" is echt, dat is `1300259` Black Hole (DBM-cue
`watchorb`) en niet `1222274`. "Ontwijk dit" is echt, dat is `1296963` Umbral Rupture (`watchstep`).
De tank-defensive is echt, dat is `1297017` Void Blast. Wie de tekst las kreeg goed advies; wie op
de spell-link klikte kreeg iets anders te zien dan de zin beschreef.

| onze regel | oud ID | wat DBM waarschuwt |
|---|---|---|
| Taz'Rah, "trekt je naar binnen" | `1222274` | `1300259` Black Hole — ORBS, `watchorb` |
| Taz'Rah, "ontwijk" | `1225011` WEAK | `1296963` Umbral Rupture — POOLS, `watchstep` |
| Taz'Rah, tank | `1222085` | `1297017` Void Blast — TANKBUSTER, `defensive` |
| Taz'Rah, "na elke teleport" | `1262901` | *niets* — zie hieronder |
| Nalorakk, "duwt iedereen weg" | `1255385` | *geen knockback op deze boss* |

⚠️ **Eén bullet heeft nu géén ID, met opzet.** De Ethereal Shades na de teleport staan nergens in
DBM — geen teleport, geen adds op deze boss. De zin staat er nog als prose, want hij kan waar zijn
en hij staat op eigen benen; een nummer dat niemand kan bevestigen maakt hem niet beter, alleen
klikbaar naar het verkeerde.

🔴 **En Nalorakks knockback is er waarschijnlijk een van de buurman.** DBM kent op Nalorakk geen
enkele pushback; de dichtstbijzijnde die het wél heeft is `1235656` op de **Sentinel of Winter**, een
andere encounter in dezelfde dungeon. Zo komt een mechaniek van de boss ernaast in de verkeerde tip
terecht — het waard om op te letten bij de resterende regels. Vervangen door `1242860` Echoing Maul
(SPREAD DEBUFFS), dat DBM wél bewaakt en dat wij nooit noemden. Ook `1222098` Nether Dash (LINES,
`lineyou`) is erbij gekomen bij Taz'Rah, om dezelfde reden.

⚠️ Het herschrijfscript adresseerde op **locale-blok**, niet op vertaalde tekst: `esES` en `ptBR`
hebben een byte-identieke TANK-regel, en een marker-tabel had ze stilzwijgend tot één sleutel
samengevouwen — één taal zou onaangeraakt zijn gebleven en niets had dat gemeld. 21 regels, 7 talen,
0 drift.

### 🔴 `tools/tip_audit.py` slikte elk argument dat je verzon

Bij het bijwerken van de baseline draaide ik `--write-baseline`. Het printte een compleet, schoon
rapport en **schreef niets** — die vlag bestond niet en de tool negeerde hem. `--help` gaf exact
hetzelfde rapport. Dat is dezelfde vorm als de onjuiste regel in `CLAUDE.md` van vanochtend: **een
instructie die fout is, is erger dan een die ontbreekt, want hij laat je ophouden met kijken.**
Gevangen doordat `git status` het bestand niet als gewijzigd toonde, niet doordat de uitvoer iets
verried. De tool weigert nu argumenten en zegt waar de baseline dan wél vandaan komt (met de hand,
uit check `[19]`).

📌 Zelfde ochtend, derde keer: `Glob` met een absoluut `path` gaf **nul** treffers op `tools/*.py` in
een map waar `_probe.py` aantoonbaar draait. Positieve controle ving het; zonder die controle had ik
geconcludeerd dat het bestand niet bestond.

### 🔴 De laatste 14 dungeon-ID's: **allemaal goed**, en de classifier was voor de dérde keer fout

Rob: *"ga door met die laatste 14."* Elke mod met de hand opengeslagen, en dat was maar goed ook,
want de uitkomst is het omgekeerde van wat de lijst beweerde: **dertien van de veertien waren
correct.** Ze staan alle dertien in

```lua
mod:AddAuraSoundOption(1246753, true, 1246753, 1, 2, "watchfeet", 8)  -- Lightsap
```

— **aan by default, mét een benoemde stem-cue**. In 12.x is een private aura onleesbaar, dus dit is
niet DBM die weigert te waarschuwen: het is de **enige manier waaróp DBM kan waarschuwen**. Ons
verdict luidde *"only mentioned, never warned on"* en zei daarmee het tegenovergestelde van de
waarheid over dertien regels.

📌 **De echte scheidslijn zit ín de aanroep, niet in de aanroep zelf.** Argument 1 is de aura,
argument 3 is de **cast waar hij bij hoort**:

| | |
|---|---|
| `AddAuraSoundOption(1246753, true, **1246753**, …, "watchfeet")` | het ding zelf |
| `AddAuraSoundOption(1292403, true, **1292188**, …, "dotyou")` | de DoT van een **ándere** cast |

Die tweede is Ula'teks `1292403` — het ID waar deze hele audit mee begon, waar onze tekst *"dodge"*
bij zei terwijl DBM's cue `dotyou` is. Dus: **parent == id is de ability; parent ≠ id betekent dat
we een bijwerking citeren en hem als de cast presenteren.** Dat is machinaal te controleren, en
"staat het in AddAuraSoundOption" was dat nooit. Nieuwe verdicts: `aura` (geen bevinding) en
`AURA-OF` (wél).

⚠️ **Wat het gereedschap nog steeds niet kan** — en dat staat nu ook onderaan het rapport: het kan
niet zien of ons **werkwoord** bij DBM's cue past. Daarvoor wordt de cue voortaan uitgeprint.

### ✅ Vier ID's die alleen mét de hand te vinden waren — en onze zinnen klopten al

| regel | oud | nieuw | waarom |
|---|---|---|---|
| Zaen STEPS + HEALER | `474545` | `1218347` | DBM: `NewSpecialWarningCount(1218347, …, "breaklos")` + CD-timer. Onze tekst zegt al *"break line of sight, hide behind the crates"* — dat ís de cue, letterlijk. `474545` is een aura zónder cue. |
| Zaen STEPS | `1214352` | `1214357` | DBM gebruikt overal `1214357` voor Fire Bomb (`bombyou`); onze `1214352` is de aura-variant, en DBM's regel dáárvoor staat uitgecommentarieerd. |
| Kystia STEPS + TANK | `1253813` | `1253811` | DBM: `RegisterAltSpellName(1253811, FRONTAL)` + `specWarnFelSpray(…, "frontal")`. `1253813` is de grond die het achterlaat. Beide regels praten over de **kegel**, en de tank-regel zegt *"keep the cone pointed away"* — iets wat je richt, dus de cast. |

🔴 **Die laatste kan het gereedschap nóóit vinden**: `1253813` parseert als een keurige
zelf-verwijzende aura en is dus per geen enkele machineregel een bevinding. Alleen *"cone"* naast de
cue *"watchfeet"* leggen brengt je er.

📌 **Nul vertaalwerk**, met opzet: alle vier zijn zuivere nummerwissels omdat de zinnen al klopten.
30 wissels over 28 regels in 7 talen, geen woord aangeraakt.
⚠️ En het script ving een aanname: `DGN_TIP_MR_ZAEN_HEALER` linkt `474545` **alleen in enUS en
itIT** — de andere vijf schrijven *"het schot"* als gewone tekst. Verwacht 7, gevonden 2, niets
geschreven tot ik het per sleutel had gemeten (9 / 7 / 14 = 30).

### ⚠️ Twee eigen fouten in dezelfde ronde, allebei van de stille soort

1. **De cue kwam leeg terug.** Twee regex-pogingen faalden identiek: een gulzige filler eet de
   argumenten tot vlak vóór het aanhalingsteken, de **optionele** cue-groep matcht dan leeg, de
   match slaagt en er wordt niet teruggekrabbeld. Het rapport printte `cue "no cue"` voor ID's die
   er één hebben — wat de lezer uitnodigt te concluderen dat DBM niets zei. Nu wordt de
   argumentenlijst gesplitst, mét een **derde positieve controle** die faalt als `1246753` niet als
   `watchfeet` en `1292403` niet als `dotyou`/parent `1292188` parseert.
2. **De linter kende het nieuwe verdict niet.** `bad = [... if v in ("ABSENT", "WEAK")]` — `AURA-OF`
   stond er niet bij, dus de énige bevinding waarvoor het verdict gebouwd was verdween uit de
   lint-uitvoer terwijl het rapport hem nog printte. **Een nieuw verdict waar de consument niets van
   weet, maakt de check stiller in plaats van strenger.**
   ✅ Bewezen dat de HARD-tak nu vuurt: Ula'teks regel tijdelijk uit de baseline → `1 new`,
   `HARD RAID_BOSS_ULATEK_STEPS 1300685 AURA-OF`, exit 1, daarna hersteld.

### Wat er wél te doen staat

**Dungeons, rituals en raids staan op nul echte bevindingen.** `tools/tip_baseline.json` is van 53
via 48 naar **34** gekrompen: 33 delve-regels (geen maatstaf — zie `_delve_caveat`) plus Ula'teks
`1300685`, de bewuste keuze, nu correct als `AURA-OF` met cue `debuffyou`.

⚠️ Er is dus **geen open lijst meer** tegen DBM. Wat overblijft is precies wat DBM niet kan
beantwoorden: de delves, waar 26 van de 30 mods stubs zijn. Daar is geen gereedschap voor — alleen
iemand die ze speelt.

## ✅ 3 sep — de pijl stuurde je door een muur; nu eerst naar de deur

Rob stond op 94 yard van het Coiled-Isle-portaal met de pijl er dwars doorheen: *"onze pijl stuurt
ons naar de plek op de kaart maar niet naar de ingang van het gebouw."* Een kaartcoördinaat is geen
route — binnen een stad zijn juist de laatste dertig meter het probleem, en dat is precies wat één
waypoint niet kan oplossen.

`Modules/TwoStepRoute.lua`: een pin mag nu een `entrance = { x, y }` dragen. De pijl gaat eerst
daarheen, met een label *"Ingang — X staat binnen"* en een chatregel die het echte coördinaat noemt,
en schakelt **vanzelf** door zodra je binnen 22 yard van de deur bent.

📌 **En de deur stond al in het bestand, weggeschreven als fout.** De opmerking boven de portal-pin
zegt dat de Codex mensen naar 55.00 / 63.40 stuurde en noemt dat *"bijna vier punten mis"*. Robs
eigen aflezing van de ingang vandaag: **54.99 / 63.30** — op een tiende na hetzelfde punt, twee
onafhankelijke metingen vijf weken uit elkaar. Dat coördinaat was nooit fout; het was de **deur**.
Op 19 aug hebben we het *vervangen* door de bestemming in plaats van het ernaast te zetten.
⚠️ Een coördinaat corrigeren is niet hetzelfde als begrijpen waar het naar wees.

⚠️ Nog open: de pin **`astalor`** (`UI.lua`) staat óók op 55.00 / 63.40 — de deur dus, niet bij
Astalor, die volgens diezelfde opmerking op 56.74 / 67.30 binnen staat. Niet aangeraakt; het is
dezelfde deur-versus-binnen-vraag en verdient dezelfde behandeling, maar of Astalor werkelijk binnen
staat is niet ópnieuw gemeten.

⚠️ Ontwerpkeuzes die het waard zijn te kennen: de ticker draait alleen zolang er een tweestapsroute
loopt (1×/s, stopt bij aankomst, na 5 minuten, of zodra een andere route de pijl claimt), en
`ns.SetSMCWaypointDirect` bestaat zodat stap twee niet opnieuw in stap één kan vallen — met de
originele pin zou hij `entrance` weer zien en je terug naar buiten sturen.

## ✅ 3 sep — de cache-busterregel staat in alle vier de cloud-routines

De ochtendronde van 3 sep vond een methodefout die zwaarder weegt dan wat hij die dag opleverde:
**Exa serveerde een week oude kopie van news.blizzard.com**, met een titel die er volstrekt normaal
uitzag. De meting staat in `CLAUDE.md`, bovenaan bij de wachterstabel.

De API-wachter schreef de les in zijn eigen logboek — een bestand dat geen enkele routine als
instructie leest. Morgen had niemand hem gehad. Hij staat nu in de **prompts** van alle vier.

⚠️ **Verificatie was hier het echte werk, niet het schrijven.** Vier prompts van 5-7K tekens gaan
als één string door een API-aanroep; HTTP 200 bewijst alleen dát de aanroep geaccepteerd is, niet
dat de tekst heel is aangekomen. Eén weggevallen regel in een wachter-prompt is onzichtbaar tot die
wachter stilletjes een stap overslaat. Daarom: prompts eerst naar schijf, blok met een script
ingevoegd op een anker dat er al stond, daarna teruggelezen en **byte-voor-byte vergeleken**. Alle
vier identiek (7532 / 5748 / 5624 / 6918 tekens), alle vier `enabled`, crons ongemoeid.

📌 Bijvangst: er bestaat een **vijfde** routine, *"Midnight Helper — API-wachter"*
(`trig_017Y76mMzXq6oopFJPFpV9dX`), de oude die op 2 sep vervangen is. GEMETEN: `enabled = false`,
laatst gevuurd 2 sep, status `ABANDONED`. Hij draait dus niet mee, en verklaart **niet** waarom er
vanochtend twee verschillende API-rapporten waren — dat vermoeden van mij was fout. Waar de tweede
vandaan kwam is nog onbekend; niet dringend, want origin had de betere.

## 🔴 2 sep (avond) — de gifadviseur toonde 3 van de 6, en dat kwam door onze eigen meting

Rob draaide `/mh valeera save` op de **live** client. Node 110784 heeft **zes** entries; wij hadden
er drie, uit de PTR-meting van 27 juli. De drie nieuwe zitten in het 1305xxx-bereik — Bursting Toad
Toxin (1305904), Frostheart Venom (1305912), Phantasmal Spore Toxin (1305924) — en bestonden op die
PTR-build simpelweg nog niet.

Er gingen **twee** dingen mis en alleen het eerste was zichtbaar:

1. `GetDelvePoisonRows` loopt over `choices`, dus het adviesscherm liet de helft van de opties weg
   die het bestaat om te vergelijken.
2. `GetEquippedDelvePoison` matcht de geslote entry tegen `choices` en geeft `nil` bij geen match.
   Wie één van de ontbrekende drie op had staan, zag **geen enkele "equipped"-markering** — niet te
   onderscheiden van "we kunnen je tree niet lezen".

📌 **De les is niet "we hadden beter moeten meten", want de meting was goed toen hij gedaan werd.**
Een hardcoded lijst van de opties van een keuzenode is een bewering dát de node precies die opties
heeft, en niets hercontroleerde die na de patch. `/mh valeera save` hoort dus bij elke patch die de
companion aanraakt, niet pas als er iets raars opvalt.

### En daarna: vier van de zes hadden geen beschrijving

Robs screenshot van de reparatie liet zes namen zien, waarvan vier zonder tekst. Niets kapot: namen
komen uit de statische spell-data, **beschrijvingen moeten opgehaald worden**, en tot ze binnen zijn
geeft `C_Spell.GetSpellDescription` een lege string. `GetDelvePoisonInfo` weigerde die lege string te
printen — precies goed — maar daarmee werd een onzichtbare laadtoestand een zichtbare leugen: een gif
zonder tekst leest als een gif dat niets doet.

Nu: `ns.RequestDelvePoisonData()` vraagt de teksten op (bij het verversen van de adviseur én bij
`/mh poisons` zelf), en waar er nog geen is staat er wát er mist in plaats van niets.
🔴 **Dit is de derde vorm van dezelfde regel uit `CLAUDE.md`: bouw je iets dat kan zwijgen, bouw dan
een manier om te zien dát het zweeg.** Correct zwijgen en kapot zijn zien er van buiten identiek uit.

### ✅ Het curio-scherm: sterren mét de controle die de gidsen overslaan

`Modules/CurioExplain.lua` (`/mh curios`) bestond al en deed álles wat ik wilde bouwen — het leest
elke keuzenode uit de boom, vraagt de teksten op mét retries, en niets is hardcoded. Het weigerde
alleen bewust te ranken, en dát is wat Rob nu voor de derde keer vroeg.

**De redenering achter die weigering was goed en is bewaard, want ze is precies wat de ster veilig
maakt:** de populaire "beste Season 2 curios"-artikelen noemen Sanctum's Edict en Time Lost Edict —
Brann-curios uit The War Within die **nergens in Valeera's venster staan**. Dat is geen
meningsverschil, dat is een artikel over iets wat de lezer niet kan vinden.

Dus de oplossing was nooit *"niet aanraden"*, maar *"niet aanraden zonder de controle die die
artikelen oversloegen"*. Wat er nu staat:

- een ster bij de twee picks waar de gidsen het over eens zijn (Corrosive Bilespear 1248877,
  Soul-Cracking Dreamcatcher 1248896 — **beide gemeten in Robs eigen client**, 2 sep);
- bij élke render een positieve controle dat de gesterde spell écht in de boom zit;
- een pick die er niet in zit wordt **genoemd aan de voet**, nooit stilletjes weggelaten — want
  "de ster is verdwenen" en "deze node heeft geen aanbeveling" zien er identiek uit;
- een voettekst die in zoveel woorden zegt: dit is waar de gidsen het over eens zijn, **wij hebben
  het niet getest**.

⚠️ De koptekst van het bestand zei in hoofdletters *"EXPLAIN, DO NOT RANK"* en regel 19 zei
*"NOTHING IS HARDCODED"*. Allebei bijgewerkt in dezelfde wijziging — een bestand dat zichzelf
verkeerd beschrijft is de volgende val.

### ✅ Robs screenshot van Valeera's venster maakte het AFGELEIDE punt hieronder GEMETEN

Haar venster noemt vier rijen: **Combat Role** (Tank), **Poisons** (Bursting Toad Toxin),
**Combat Curio** (Corrosive Bilespear), **Utility Curio** (Soul-Cracking Dreamcatcher). Daarmee
staan de slot-namen vast — de geslote pick staat er telkens naast, en die drie spells zitten in
precies die drie nodes:

| node | slot |
|---|---|
| 110784 | Poisons |
| 110786 | Combat Curio |
| 110785 | Utility Curio |

🔴 **En dat maakte een opmerking in `CurioExplain.lua` onwaar die er al maanden stond:** *"the game
does not name these slots in a way we can read, so they are numbered rather than guessed at."*
Nummeren was goed zolang dat gold. Het gold niet meer zodra iemand naar het venster keek — en
niemand had gekeken. Sinds vanavond staat de naam boven elk blok, gekoppeld aan de **nodeID** (nooit
aan de volgorde), en valt een onbekende node terug op het oude genummerde label: een slot zonder
naam is dan naamloos, niet verkeerd benoemd.

⚠️ De labels blijven **Engels**. Nederlands heeft geen client, dus dit is wat een Nederlandse
speler écht ziet. De vijf echte clienttalen vertalen ze wél, maar wij hebben die vensters niet
gelezen — "Kampf-Kuriosität" zou ónze bewoording zijn voor een label dat Blizzard al heeft.
Vastgelegd in `KeepEnglish.lua` mét die reden.

### 🔴 En dezelfde lus zat óók in de tekst: `/mh curios` stuurde je naar `/mh curios`

Robs screenshot toonde: *"Valeera — no ranking for this season. Use /mh curios to see what each of
her options does."* Maar `/mh curios` opende juist de **adviseur** die dat zei. Je werd
teruggestuurd naar het scherm dat je net verteld had niets te weten.

Dit is exact de vorm van de bug die op 2 sep 's middags in `CommandList.lua` gerepareerd is (een
alias die naar een alias wees). **Twee keer dezelfde lus op één dag, één keer in de commandolijst
en één keer in een zin.** Verwacht een derde.

Opgelost: `/mh curio` en `/mh curios` kiezen nu zelf. Heeft de adviseur data — op een
12.0.7-client is dat zo — dan de adviseur; anders de uitlegger, die live uit de tree leest en de
sterren draagt. De adviseur gaat er dus **niet** uit; hij kan alleen nooit seizoen-2-data krijgen.

### ✅ Het scherm dát naast Valeera hoort — `Modules/CurioAdvicePanel.lua`

Rob vroeg dit in drie stukken over weken: een adviesscherm "zoals in serienummer 1", dat zegt "wat
volgens de meerderheid online het beste is", en dat **naast haar venster** verschijnt. De eerste
twee waren de sterren in `/mh curios`; dit is de derde, en de enige die hij kón zien ontbreken —
hij opende haar venster en kreeg een chatregel.

Wat het toont, per keuzeslot: de slotnaam, wat de guides kiezen, en of jij dat al op hebt.
Geankerd aan `DelvesCompanionConfigurationFrame` (TOPLEFT aan haar TOPRIGHT), dus het verschuift mee
als zij verschuift; valt terug op het scherm-midden als haar venster dicht is.

⚠️ **Bewust géén effectteksten.** Naast haar venster ben je aan het kiezen, niet aan het studeren;
drie slots vol tooltips is een muur. `/mh curios` blijft daarvoor.

📌 **En de oude regel klopte, maar trok de verkeerde conclusie.** *"Deze popup heeft niets"* is
nooit hetzelfde geweest als *"wij hebben niets"*. De item-popup kán seizoen 2 niet dragen (trait-
entries, geen items) — maar antwoorden met het ding dát het weet is beter dan weigeren met het ding
dat het niet weet. Alle drie de slots komen uit `GetCompanionChoices()`; het enige wat wij leveren
is de ster, en die wordt tegen diezelfde boom gecontroleerd.

### 🔴 De linter las commentaar als code en liet de build vallen op documentatie

`CurioAdvicePanel.lua` legt de `and`-valstrik uit door de fóute regel boven de goede te citeren —
het nuttigste wat je naast een reparatie kunt schrijven. Check **[12]** maakte daar een HARD failure
van.

📌 Dat is niet alleen een vals alarm maar een verkeerde prikkel: een checker die het documenteren
van zijn eigen onderwerp bestraft, leert mensen de uitleg weg te halen. Commentaar wordt nu
overgeslagen. ⚠️ De skip is een kale `--`-zoekactie, dus een `--` binnen een string eerder op de
regel zou een echte treffer verbergen — een vals negatief op een regelvorm die hier niemand
schrijft, geruild tegen een vals positief dat zojuist een build stopte.

### ✅ `/mh poisons` was de zwakkere kopie van `/mh curios` — opgeruimd

`GetCompanionChoices()` leest álle keuzenodes uit de boom, inclusief de gifnode, **zonder enige
hardcoded lijst**. De statische `DELVE_POISONS_BY_SEASON` die vanavond verouderd bleek, was dus
nooit nodig geweest. Sterker: `CurioExplain.lua` regel 157-166 beschrijft **exact** het probleem dat
ik vanavond opnieuw ontdekte, gemeten op 25 aug — Frostheart Venom (1305912) en Phantasmal Spore
Toxin (1305924) komen leeg terug na één seconde en hebben bij hoveren wél volledige tekst. Daar
lost een retry-lus van 4× ~1s het op; in `/mh poisons` staat nu alleen een "probeer het nog eens".

📌 **Derde keer deze week dat het antwoord al in de code stond.**

✅ **Rob koos: alias.** ~150 regels gif-apparaat zijn weg uit `DelveCuriosAdvisor.lua`
(`GetDelvePoisonInfo`, `GetEquippedDelvePoison`, `GetDelvePoisonRows`, `RequestDelvePoisonData`,
`PrintDelvePoisons`), plus `DELVE_POISONS_BY_SEASON` en elf locale-sleutels in zeven talen.
`/mh poisons` en `/mh poison` staan nu in `MH_UNLISTED_ON_PURPOSE` en openen `/mh curios`.
⚠️ `/mh poisons` stond in de commandolijst onder de **ROUTE**-groep, wat het nooit was.

### ⚠️ Het curio-plan van vanmiddag was op een verkeerde aanname gebouwd

Het plan was `DELVE_CURIOS_BY_SEASON[2]` te vullen met Corrosive Bilespear en Soul-Cracking
Dreamcatcher. **GEMETEN: dat zijn geen items.** Het zijn trait-entries in Valeera's boom, met
spellIDs (1248877 en 1248896) in keuzenodes 110786 en 110785. Die tabel bevat itemIDs en tekent via
`C_Item.GetItemInfo`, dus het scherm had `#1248877` getoond.

**AFGELEID, niet gemeten:** dát deze twee nodes zijn wat men online "curios" noemt. In de hele boom
van 49 nodes zijn er precies drie keuzenodes — de gifnode en deze twee. Sterk signaal, geen bewijs.
Of er in seizoen 2 óók curio-*items* bestaan is van buiten de client niet te zien.

Nog op te lossen: de curio-kant moet dus op de gif-structuur (spell-naam + clienttekst) in plaats van
op het item-pad. En node **110817** staat op `ranksPurchased = 1` met een **lege** entries-lijst —
één gekochte node waarvan de client ons de inhoud niet gaf; onbegrepen, laag geprioriteerd.

### 🔴 En `tools/git_stage.py` maakte in dezelfde commit exact dezelfde fout

Bij het committen van het bovenstaande stageerde het script **de verkeerde bestanden** — een lijst
uit een sessie die al was afgelopen. De oorzaak: het negeerde het pad dat op de commandoregel stond
en viel terug op een **hardcoded sessie-UUID**, met de opmerking erboven dat dat pad *"stabiel is
voor dit project"*. Dat is het niet; een scratchpad-pad is per sessie.

Het faalde niet. Het meldde succes en printte de verouderde lijst — de enige reden dat het opviel,
is dat die namen zichtbaar niet klopten. Opgelost: eerst het argument, dan `CLAUDE_SCRATCHPAD`, dan
de nieuwste op schijf, en het zégt welke het gebruikte.

📌 Dat is dezelfde vorm als de gif-bug die het aan het committen was: **een vastgelegde momentopname
van iets dat beweegt, met niets dat hem hercontroleert.** Twee keer op één avond, in twee bestanden
die niets met elkaar te maken hebben.

## ✅ Gif-advies: een TWEEDE soort markering, bewust los van de ster

Rob koos (2 sep): niet de ster gebruiken, maar een eigen markering `>>` met per gif één regel over
wanneer het nuttig is. Daarmee blijft de ster betekenen wat de voettekst belooft — *"hier zijn de
guides het over eens"* — en staat er los van wat wíj eruit lezen.

⚠️ **Alle zes regels zijn AFGELEID uit de speltekst die er drie regels boven staat.** Geen run, geen
log, geen guide. Dat is precies waarom dit publiceerbaar is en een stil oordeel niet zou zijn: de
lezer kan elke regel zelf tegen de beschrijving houden.

Wat de zes teksten opleverden, nu alle zes gelezen zijn:

| gif | wat het onderscheidt |
|---|---|
| Phantasmal Spore Toxin | **onderbreekt** (+1 sec fear) — de enige met een interrupt |
| Frostheart Venom | -20% melee-, ranged- **én** cast-snelheid, -30% movement |
| Bloodcrypt Toxin | -10% schade en -10% Haste |
| Soulthirst Venom | +10% Leech/Avoidance/Speed voor jezelf |
| Bursting Toad Toxin | AoE natuurschade |
| Forgotten Master | tot +25% schade, **maar alle stacks weg zodra de drager schade krijgt** |

📌 Die laatste voorwaarde is de enige echte in de set en de reden dat het "sterkste damage-gif"
misleidend is. Robs Valeera staat op **Tank**.

⚠️ Waar het paneel de notitie toont: **alleen bij een slot zonder ster**, en dan over wat de speler
nú op heeft. Twee meningen op één regel is hoe een lezer niet meer kan zien welke van wie is. De
voettekst draagt de disclaimer alleen wanneer de markering ook echt op het scherm staat.

⚠️ Eén percent-teken in die notities, geen twee: ze zijn nooit een format-*string* (ze worden
geconcateneerd of als argument doorgegeven), dus `%%` zou letterlijk verschijnen.

## ~~OPEN~~ BEANTWOORD: waarom had de Poisons-slot geen aanbeveling?

Rob, 2 sep, kijkend naar het werkende paneel: *"hebben we geen poisons??"* Nee, en dat is een
**bewuste** keuze uit juli die nu aan haar houdbaarheidsdatum zit.

De reden staat in `DelveCuriosData.lua`: de gif-ID's die we van Wowhead hadden waren **alle drie
fout**, dus de effectbeschrijvingen die erbij hoorden waren net zo onbewezen. Geen aanbeveling doen
was toen precies goed.

✅ **Die blokkade is weg.** We hebben nu zes gemeten gif-ID's en de client geeft zijn eigen teksten.
Wat er nog niet is, is een grond om er één aan te wijzen: de ster betekent *"hier zijn de guides het
over eens"*, en voor gif heb ik dat **niet gecontroleerd**. Er nu zelf een kiezen zou de ster iets
anders laten betekenen dan de voettekst belooft.

Vier van de zes teksten staan al in Robs screenshots: Soulthirst (Leech/Avoidance/Speed +10%),
Forgotten Master (+5% schade, stapelt tot 5, valt weg bij schade), Bloodcrypt (-10% schade en -10%
Haste op de vijand), Bursting Toad (AoE natuurschade). **Frostheart Venom en Phantasmal Spore Toxin
zijn nog ongelezen.** Volgende stap: `/mh curios` toont ze nu; daarna kiezen Rob en ik samen, en dan
moet de voettekst zeggen dat dít onze keuze is en niet die van de guides.

## ✅ De "Nothing slotted"-bug: het was timing, en dat is de gevaarlijkere uitkomst

Na een reload klopte het paneel — mét **onaangeroerde** active-detectie. Het was dus niet fout maar
**te vroeg**: `activeEntry` is leeg tot de trait-config geladen is, en één retry op 1s haalde dat
niet altijd.

⚠️ **Dat is de slechtste soort groen.** "Het werkt nu" na drie ongerelateerde wijzigingen is geen
reparatie maar een toevalstreffer die nog niet gefaald heeft — en een adviespaneel dat af en toe
beweert dat je niets op hebt is erger dan eentje die zwijgt, want de speler gelooft het en kiest
opnieuw.

Nu hangt het niet meer aan het moment van openen: het ververst op `TRAIT_CONFIG_UPDATED`,
`TRAIT_TREE_CHANGED`, op de `OnShow` van haar venster, én op een laddertje van 0,3 / 1 / 3 seconden.
Elk daarvan is genoeg.

⚠️ **En `/mh valeera save` faalde in diezelfde run**: *"probe stopped: no trait tree"*. De probe
hangt aan `DelvesCompanionConfigurationFrame.playerCompanionID` en heeft haar venster dus **open**
nodig. Dat staat nergens in de foutmelding. Niet dringend meer — het paneel beantwoordde de vraag —
maar de melding hoort te zeggen wát je moet doen.

## ~~OPEN~~ OPGELOST: het adviespaneel zei "Nothing slotted yet"

Robs screenshot van 2 sep zet de twee vensters naast elkaar: haar venster toont **Bursting Toad
Toxin, Corrosive Bilespear én Soul-Cracking Dreamcatcher** geslote — ons paneel zegt drie keer
"Nothing slotted yet". Beide lezen dezelfde boom.

`GetCompanionChoices` bepaalt dat uit `node.activeEntry.entryID`. **Dat is niet uitgesloten dat het
werkt:** het oude `GetEquippedDelvePoison` las hetzelfde veld en zette die avond wél een `>` bij
Bursting Toad Toxin in `/mh poisons`. Dus óf het veld gedraagt zich anders per aanroep, óf er zit
iets anders in de weg.

⚠️ **NIET GAAN GOKKEN.** `/mh valeera save` legde `ranksPurchased` en `entries` vast maar **nooit
`activeEntry`** — precies het veld dat nu verdacht is. Een diagnose die het verdachte veld weglaat
stuurt je terug naar raden, en dat is het enige wat hij hoort te voorkomen. De probe schrijft het nu
weg mét het `type()`, zodat een dump kan zeggen óf het nil is, óf een getal in plaats van een tabel,
óf secret.

**Volgende stap:** Rob doet `/mh valeera save` + `/reload` met haar venster open; dan de drie
keuzenodes in het SV-bestand lezen.

## ✅ Het adviespaneel: volgorde, scrollen, en slepen

Robs twee opmerkingen zodra het naast haar frame stond, allebei terecht:

1. **De volgorde klopte niet.** De boom geeft 110784, 110785, 110786 → Poisons, Utility, Combat;
   haar venster leest Poisons, **Combat**, Utility. Twee lijstjes van dezelfde drie dingen in
   verschillende volgorde, naast elkaar, en de lezer mag matchen. Nu via
   `ns.DELVE_CURIO_SLOT_ORDER`; een node zonder bekende positie wordt **achteraan toegevoegd** in
   boomvolgorde, niet weggelaten en niet vooraan geforceerd.
2. **Te klein om te lezen.** Vaste 320px met het kleine lettertype is genoeg voor een blik, niet om
   te lezen. Nu: sleepbaar aan de rechteronderhoek (240×160 tot 620×900), een echte ScrollFrame
   eronder, groter lettertype, en de maat wordt onthouden in `ns.db.curioAdvicePanel`.
   ⚠️ `StartSizing` laat het frame op eigen punten achter, dus na het slepen wordt opnieuw aan
   haar venster geankerd — anders volgt het haar na één keer verslepen nooit meer.

## ✅ 2 sep (avond) — de weekroutine liet je vallen zodra je een quest oppakte — GEMETEN OPGELOST

✅ **Rob in het spel, dezelfde avond: "DIE PIJL DEED HET NET."** Bevestigd op de echte trigger — een
weekly die af was en nog ingeleverd moest worden — en niet op een nagebouwde toestand. Dat is het
enige bewijs dat telt voor deze reparatie, want de bug bestond juist in de overgang tussen twee
toestanden die je niet kunt forceren.

Rob: *"ik heb een quest opgehaald en die moet ik weer inleveren, maar ik krijg nu geen pijl (als ik
de questgiver weer aanklik)."* Gemeten in `ResetRoutine.lua` en het is precies dat.

`GiverState` gaf `"inlog"` zodra een quest in je log stond, en die tak bouwde een stap **zonder
`pin`, zonder `open` en zonder `onClick`**. `ComputeOpenPins` neemt alleen `step.open and step.pin`,
dus de halte verdween uit de route en de regel was dood voor de klik. Hetzelfde gold voor de
trainer-weeklies. In Robs screenshot stonden er **vier** tegelijk zo: Halduron, Aethas, Riftblade
Maella en Blacksmithing.

📌 **De vorm van de fout: het oppakken van een quest liet de addon ermee stoppen — precies op het
moment dat de speler zich eraan gecommitteerd heeft.** De giver was nooit verplaatst; alleen onze
reden om erheen te lopen was veranderd, en die hadden we niet ingevuld.

⚠️ **Maar "in mijn log" is niet "klaar om in te leveren".** Routeren op het eerste zou de zelfverzekerd
verkeerde antwoord zijn waar dit bestand al twee keer voor waarschuwt: je staat dan voor een NPC die
niets voor je heeft, terwijl het werk buiten ligt. Er is dus een aparte staat `"turnin"`, die
`C_QuestLog.ReadyForTurnIn` gebruikt — de client zegt het, wij raden niet.

Nu: **af → echte halte met pijl** (`open`, `pin`, eigen tekst); **opgepakt maar niet af → wel
klikbaar, geen halte**, want wie naar de giver wíl kijken hoort geen nee te krijgen. Bij de
trainer-weeklies is de coördinaatberekening uit de pickup-tak omhoog gehaald zodat inleveren
dezelfde plek gebruikt; dat haalde meteen een duplicaat van de `isService`-tak weg.

Twee nieuwe sleutels (`HOME_ROUTINE_GIVER_TURNIN_FMT`, `HOME_ROUTINE_TRAINER_TURNIN_FMT`) in alle
zeven talen, 0 drift.

## Stand 2 sep 2026 (ochtend)

**Alle vier de wachters draaien nu in de cloud** en pushen zelf, tussen 05:30 en 06:00 Robs tijd —
API, PTR/roadmap, blue post/data, content. Niets hangt meer aan Robs pc. Zie de tabel bovenaan
`CLAUDE.md`. De drie oorzaken die dat blokkeerden (repo niet als bron ingesteld, twee logboeken in
`.gitignore`, en een connector-toestemming waar een onbeheerde run op bleef wachten) staan in de
commits van die ochtend.

📌 En de regel die daaruit volgde en breder geldt dan wachters: **een onbeheerd proces mag nooit op
een goedkeuring blijven wachten.** 4 van de 10 laatste API-runs waren zo stilgevallen. Kan iets niet,
schrijf op wát niet kon en ga door — een halve meting die aankomt is meer waard dan een volledige
die nooit komt.

## ✅ 3.7.3 LIVE en approved op CurseForge — 31 aug 2026 (tag `v3.7.3` op `945e17d`)

De adviseur zweeg voor hele beroepen (12 routestappen in 5 beroepen noemden een node alsof het een
tabblad was), vier talen bleken machinaal vertaald, Valeera heet Valira in het Portugees, vijf
spell-links werkten niet, en de Vaults-keten was drie quests terwijl het er vier zijn.

✅ **Vertalen is AF**: zeven talen, nul drift, alle 43 placeholders lossen op.

### 🔴 Wat morgen als eerste telt

**Wacht op iemand anders:**

1. ✅ **`cmd:req` GEBOUWD op de avond van 2 sep — de test is overgeslagen, met reden.**
   Rob: *"het is niet meer voorgekomen dat ik de andere niet meer zie, dus dat heeft niet veel zin
   meer om te testen."* Klopt, maar niet omdat het over is: **een symptoom dat wegblijft zegt
   alleen dat de timing niet ongelukkig viel.** De code bewijst het gat wél, en dat is sterker dan
   de test ooit had kunnen zijn — uitzenden gebeurt alleen op `GROUP_ROSTER_UPDATE` en
   `PLAYER_ENTERING_WORLD`, en er bestond **geen enkel bericht dat om data vroeg**. Met
   `STALE = 600` verdwijnt bovendien elke ontvangen rij na tien minuten zonder dat iets hem ophaalt.
   ⚠️ Cisca hoefde dus nooit iets anders te typen dan `/reload`; `cmd:req` is een protocolbericht,
   geen commando.

   🔴 **En bij het bouwen bleek de helft van de reparatie al nodig zonder cmd:req:** de
   ontvangst zette de rij in `received` en **hertekende het bord niet**. Een antwoord dat binnenkwam
   terwijl het bord openstond was pas zichtbaar bij de volgende keer openen — hetzelfde symptoom als
   de bug zelf. `ns.RefreshConsumableBoard` bestond al, deed precies het juiste, en werd daar nooit
   aangeroepen. Derde keer deze week dat het antwoord al in de code lag.

   📌 Wat het voor de ander betekent (Robs vraag): **niets zichtbaars.** Geen venster, geen geluid,
   geen chatregel. Hun client krijgt een verborgen berichtje en stuurt dezelfde tellingen terug die
   hij nu al ongevraagd rondstuurt. Geen nieuw gegeven, dus geen nieuwe privacyvraag; spelers zonder
   MH negeren het prefix volledig.
   ⚠️ Bewust **niet** achter `IsAutoPopupEnabled("consumables")`, anders dan `cmd:show`: die
   instelling betekent "open geen venster bij mij", en dit opent niets. Hem hier toepassen zou
   iemand die alleen de popup uitzette stil uit andermans bord laten verdwijnen.
   ⚠️ Antwoorden worden **uitgesteld** in plaats van weggegooid als de 3s-throttle in de weg zit —
   anders verliest een verzoek stilzwijgend zijn antwoord, precies de vorm van de bug die dit
   repareert. Verzoekkant throttlet zelf op 5s.
   **Nog niet in het spel bevestigd** — het vraagt twee mensen in een groep.
   Volledige analyse: `docs/NEXT_SESSION_ARCHIVE.md` regel 456 e.v.
2. ✅ **Wago staat er — 2 sep.** Project aangemaakt, versie 3.7.3 handmatig geüpload (Wago's
   "Upload your Addon!" leidt naar *Create Version*, dus een zip is nodig om te beginnen), en
   `## X-Wago-ID: rNky4wKa` staat in de `.toc` onder het CurseForge-ID. `release.yml` gaf
   `WAGO_API_TOKEN` al door aan de packager, dus vanaf de volgende release gaat het vanzelf naar
   CurseForge **én** Wago. Dit was SPEC_31 B7.
   ⚠️ **Nog niet bewezen:** of de automatische upload werkt. Het GitHub-secret `WAGO_API_TOKEN`
   staat er wél in (Rob bevestigd, 2 sep), maar of de packager er daadwerkelijk mee uploadt blijkt
   pas bij de eerste release ná vandaag — kijk dan of Wago de nieuwe versie krijgt zonder handwerk.
   🔴 **DOODLOPEND SPOOR, niet opnieuw onderzoeken: Wago's downloadcijfers zitten achter Patreon.**
   Rob wilde er een teller voor in Home Assistant, naast die voor CurseForge, en heeft daarvoor een
   tweede API-token aangemaakt. Dat token is weer ingetrokken: de statistieken zijn betaald en dat
   is geen plan. Er is dus **geen** Wago-downloadteller, en de reden is een prijskaartje en geen
   ontbrekend eindpunt — zoeken naar de juiste API levert niets op.
   ✅ **Uitgezocht dezelfde ochtend, en het was geen bug maar onze eigen keuze.** `release.yml`
   zei het zelf: GitHub-releases waren bewust uit, *"one new shop at a time"*. Die reden is nu
   vervallen (CF werkt al maanden, Wago staat er), dus aangezet met `GITHUB_API_TOKEN:
   ${{ secrets.GITHUB_TOKEN }}` plus `permissions: contents: write`. **Geen nieuw secret nodig** —
   Actions levert die token zelf.
   ⚠️ Onbewezen tot de eerste release hierna: of het Release-object echt verschijnt.
   📌 Bijvangst die een schrik bespaarde: de packager-README noemt `CF_API_TOKEN` terwijl wij
   `CF_API_KEY` doorgeven. `release.sh` accepteert **allebei** (gemeten in de broncode, niet in de
   README). Onze werkende opzet was dus nooit in gevaar en moet **niet** "gerepareerd" worden.

**Gemeten open op 2 sep** (met positieve controle in dezelfde run):

3. ✅ **B5 — `/mh report` GEBOUWD, 2 sep.** `Modules/SupportReport.lua`, via het bestaande
   `ns.ShowShareCopyDialog` zoals de spec voorschreef — bedrading, geen nieuw scherm. Bevat
   versie, clientbuild, taal (client én MH), klasse/spec/level, groepsgrootte en instantie, plus
   wat de speler achter het commando typt. Beide bestemmingen erin, Discord én GitHub.
   Lint: 173 gerouteerd / 65 vermeld (was 172/64), dus hij staat in de commandolijst én in
   NavSearch. ✅ **Door Rob getest en afgetekend** (`docs/TESTLIJST.md` punt 11) — hij vond binnen
   twintig minuten twee uitvoerfouten die geen controle kón zien omdat de wáárden klopten:
   `MAGE Frost` en `Eastern Kingdoms (open world)` in plaats van de zone. Beide gerepareerd.
   📌 Twee keuzes die Rob mag terugdraaien: **geen personagenaam of realm** in het rapport (het is
   bedoeld om openbaar geplakt te worden, en die twee helpen niet bij reproduceren), en het
   **rapportblok blijft Engels** terwijl de chrome eromheen in zeven talen staat — het is aan de
   maker gericht, zoals een logbestand.
4. ✅ **B10b — beroepen-scène TOEGEVOEGD, 2 sep.** `{ name = "10-professions-advice", tab =
   "profoverview" }` in `Modules/DevShots.lua`. De meting van die ochtend is precies omgedraaid:
   `prof` gaf nul treffers in dat bestand, nu vier.
   📌 **Waarom juist deze scène en niet een willekeurige elfde:** op 31 aug is over ~20 addons
   gemeten dat **geen enkele** vertelt wáár je Knowledge uitgeeft. Het enige dat deze addon doet
   en niemand anders, was dus het enige dat een bezoeker van de CF-pagina niet kon zien.
   ⚠️ `profoverview`, niet `professions` — die oude id landt op Treasures & Books, wat Rob op
   22 juli kreeg toen hij op een Knowledge-regel klikte.
   ⚠️ Deze scène hangt als enige aan het **ingelogde personage**: draai `/mh shots` op iemand met
   Midnight-beroepen en punten te besteden, anders fotografeert hij een eerlijke lege pagina.
5. **De INHOUD van de Engineering-, Jewelcrafting- en Inscription-routes.** Hun *structuur* is
   geverifieerd (0 afwijkingen over alle 11 beroepen), maar of `Recycling` het juiste eerste punt
   is, is nooit tegen gamedata gelegd. ⚠️ Dat verschil is echt en is op 31 aug één keer verward.
   Drie beslissingen liggen bij Rob: de `points`-semantiek (Recycling zegt "mik op 10" maar de stap
   voltooit pas bij 30), JC stap 1 (alle gidsen zeggen ~5, wij eisen een volle root), en of
   Inscriptions vierde boom `Darkmoon Curiosity` erbij moet.

**Niet opnieuw gemeten, overgenomen uit de meting van 31 aug:**

6. ✅ **B6 — GEBOUWD 2 sep, op DRIE plekken en bewust niet op vijf.** De spec noemde vijf doelen;
   de toets die ik erop legde is *heeft de speler de informatie die wij missen?*
   - ✅ `MPLUS_AFFIX_UNMEASURED` — zijn keystone toont de affixen eerder dan wij ze meten.
   - ✅ `HAZARD_SOURCE_NOTE` — hij wordt geraakt door iets dat niet in de lijst staat.
   - ✅ `DELVE_REWARDS_UNMEASURED` — hij ziet zijn eigen kist. ⚠️ Dit is de **tooltip**, dus kort
     en met `/mh report` in plaats van een uitnodiging — precies waarom B5 eerst moest.
   - ❌ `DELVE_CHEST_LEARNED` — een API-beperking. De speler kan ons niets vertellen dat dit
     oplost, dus een vraag daar is zuivere ruis.
   - 🔴 `DELVE_TIP_UNMEASURED` — **dode tekst**: hij staat in zeven talen in de taalbestanden en in
     géén enkel codepad. Geen speler heeft hem ooit gezien; waarschijnlijk overbodig geworden toen
     alle veertien delves tips kregen. **Niet aangevuld — opruimen of aansluiten is een aparte
     keuze.**
   21 toevoegingen (3 sleutels × 7 talen) met een script dat weigert te schrijven bij een ander
   aantal; drift gemarkeerd, lint 0/0.
   📌 De spec waarschuwde dat dit het snelst een zeurpiet wordt. Drie vragen op drie schermen is
   het antwoord daarop, en de toets hierboven is waarom het er drie zijn.

6c. 🔍 **Hermeting van 2 sep, ter herinnering:** het "vertel het ons"-model bestond exact één keer:
   `RITUAL_BOSS_MINDBREAKER_STEPS` (*"If you fight it, tell us what it did on Discord and it goes
   in"*). Dat was tegelijk de positieve controle — mijn zoekvorm vindt een vraag waar er één is.
   De vijf plekken waar de addon toegeeft iets níét te weten dragen er géén: `DELVE_TIP_UNMEASURED`
   (enUS:1456), `DELVE_REWARDS_UNMEASURED` (enUS:1459), `MPLUS_AFFIX_UNMEASURED`
   (`Locales/MythicPlus.lua:32`), `DELVE_CHEST_LEARNED` (enUS:547), `HAZARD_SOURCE_NOTE`
   (enUS:1674).
   ✅ **De blokkade is weg:** de spec zei *"waar het een tooltip is noemt de tekst `/mh report` —
   daarom moet B5 eerst"*, en B5 bestaat sinds 2 sep.
   ⚠️ De spec waarschuwt dat dit het voorstel is dat het snelst een zeurpiet wordt: alleen op
   teksten die iemand bewust léést, nooit op een tooltip die de muis volgt, nooit met een knop die
   terugkomt.
6b. ✅ **B10 — CF-bovenkant HERSCHREVEN, 2 sep.** GEMETEN vóór en na: *"Just hit 90…"* stond op
   regel 9 en staat nu op 3; **Professions 101 stond op regel 117 en staat nu op 15**.
   🔴 En de meting legde bloot dat ik het die ochtend zélf erger had gemaakt: mijn site-blokcitaat
   werd het derde bovenaan en duwde de pitch nog twee regels omlaag — precies het probleem dat de
   spec beschrijft. De links staan er nog, nu ná "Start with these three".
   📌 Het eenmansproject-briefje is samengevoegd met de Discord-regel en naar de voet van het
   eerste scherm verhuisd: eerlijkheid die vertrouwen *sluit* hoort niet vóór de pitch te staan.
   ⏳ Rob moet de omschrijving hiervoor opnieuw plakken (tweede keer op 2 sep).

**Nieuw, 2 sep — en dit is nu het dringendst:**

0. ✅ **World boss — GEMETEN EN OPGELOST, 2 sep.** Rob zag het S1-world-boss-artikel binnen een
   uur na publicatie op de site staan als actueel advies, draaide `/mh worldboss` op live, en dat
   besliste alles in één keer: **Lu'ashal `taskActive = true`, 9904 min resterend**, de andere
   drie idle. De vier bosses roteren gewoon door in Season 2.
   🔴 **"12.1 verving world bosses door Lairs" was FOUT** — dezelfde probe geeft `hasLairs = true`
   én actieve world bosses: Lairs bestaan ernáást. Die claim kwam van Icy Veins en een techsite en
   was op weg naar onze publieke site. Twee secundaire bronnen die elkaar bevestigen zijn geen
   meting.
   Gedaan: de S2-poort is uit `Modules/WorldBoss.lua` gehaald, het artikel staat weer op de site,
   en `SKIP_ARTICLES` in `tools/build_site.py` is weer leeg — het mechanisme blijft.
   🔴 **Correctie op mezelf, dezelfde ochtend.** Hier stond eerst dat die poort "twee weken lang
   een boss verzweeg die er gewoon stond". Rob weerlegde dat vanuit het spel binnen een kwartier:
   Lu'ashal stond er **vóór** de reload al. `GetActiveWorldBoss` probeert eerst de client-scan, dan
   de cache, en pas dán deze functie — de poort zat alleen op die laatste. De echte kosten zijn
   dus smaller: in een week waarin de client niet antwoordt bleef het paneel leeg in plaats van de
   boss te noemen. Nog steeds terecht weggehaald, maar niet wat ik beweerde.
   ⏳ **Rob moet nog bevestigen** dat de boss in-game terug is: `docs/TESTLIJST.md` punt 10.
   📌 Blijvende les die groter is dan dit item: **de sitegenerator kopieert teksten, maar niet de
   voorwaarden waaronder de addon ze toont.** Die poort stond in Lua, de generator leest data.
   Alles wat de addon afhankelijk maakt van seizoen, patch of speler-toestand publiceert de site
   onvoorwaardelijk tenzij iemand het opmerkt. Staat als regel boven `SKIP_ARTICLES`.

**Nieuw, 2 sep (middag) — Valeera-advies bestond al, maar was onvindbaar:**

8. ✅ **`/mh poisons` is nu vermeld.** Rob vroeg onderweg of er ergens Valeera-advies over poisons
   en curios te vinden was. Gemeten: `PrintDelvePoisons` bestaat al (`DelveCuriosAdvisor.lua:1401`,
   een nette spelerprint met de omschrijvingen van de client en een markering op wat ze aan heeft)
   maar stond in `MH_UNLISTED_ON_PURPOSE`. 🔴 De rechtvaardiging daar was circulair: de comment
   noemde `poisons` een alias van `/mh poison` — en `poison` stond zelf óók in die lijst, dus er
   was geen primaire naam. Nu vermeld, met `poison` als echte alias.
9. ✅ **`/mh curio` opent eindelijk de adviseur.** De commandolijst beloofde twee dingen
   (`CMDLIST_CURIOS` = uitlegger, `CMDLIST_CURIO` = adviseur) terwijl `Core.lua` beide naar de
   uitlegger stuurde; het adviseur-blok was dode code. ⏳ Robs keuze open: enkelvoud/meervoud is
   een slechte scheidslijn — samensmelten tot één commando is eerlijker maar groter.
   Zie `docs/TESTLIJST.md` punt 12.
10. ✅ **GEREPAREERD — twee blinde vlekken in de linter, gevonden door één toeval.** De pariteitscontrole zag
    `fill("deDE", { KEY = "..." })` op één regel niet: het contextpatroon zette de taal en
    `KEY_BARE_RE` is verankerd met `^`, dus de sleutel achter de accolade werd nooit gelezen.
    GEMETEN door alleen de opmaak te veranderen: zes vertalingen per taal doken op (deDE 3102 →
    3108). ⚠️ **Dezelfde fout zat in `collect_locale_values`, en dáár is hij gevaarlijk:** die
    voedt [13] markup en [15] must-stay-English, dus een eenregelige fill met een kapotte
    `|cff…|r` gaf een **vals sein-veilig**. Beide gerepareerd; [13]/[15] blijven 0, nu voor het
    eerst gemeten in plaats van ongezien.

## ✅ Valeera-curio's Season 2 — GEBOUWD op de avond van 2 sep

⚠️ **Alles hieronder is het ONDERZOEK van die middag en blijft staan omdat de redenering klopt.
Twee conclusies erin zijn 's avonds door meting in Robs client omvergegooid; die staan hier.**

🔴 **"Corrosive Bilespear = 249223" IS FOUT.** Het is geen item. Het is een trait-entry in
Valeera's boom: **spellID 1248877, entryID 137797, node 110786**. Hetzelfde geldt voor
Soul-Cracking Dreamcatcher (**1248896**, entry 137817, node 110785). Punt 1 hieronder vroeg om
"item-ID's meten"; het antwoord op die meting was dat het geen items zijn. Had `DELVE_CURIOS_BY_
SEASON[2]` die ID's gekregen, dan had het scherm `#1248877` getoond — die tabel tekent via
`C_Item.GetItemInfo`.

✅ **De lijst van zes klopt exact.** Vierde en hardste bevestiging: de drie keuzenodes uit Robs
eigen client geven precies de zes namen uit de tabel hieronder, in twee bakjes van drie —
Combat = node 110786, Utility = node 110785. Het onderzoek van die middag had het goed.

✅ **Punt 2 is beslist:** vullen mét herkomstregel. Uitgevoerd als een **ster** op de twee
consensus-picks, die bij élke render tegen de boom van de speler wordt gecontroleerd, plus een
voettekst die zegt dat wij het niet getest hebben. De gif-slot kreeg een **aparte** markering
(`>>`) omdat we voor gif níét weten wat de guides zeggen — zie de sectie bovenaan.

📌 De alinea hieronder over "de vijfde stem die één build napraat" is precies waarom het zo
gebouwd is: de ster zegt wát de bron is, en de controle tegen de boom is wat geen van de vier
andere stemmen doet.

### Het onderzoek van 2 sep (middag) — ongewijzigd bewaard

Rob vroeg onderweg om "zo'n adviesscherm zoals we in seizoen 1 hadden". **Dat scherm bestaat nog**
(`Modules/DelveCuriosAdvisor.lua`: paneel op de Delves-tab én popup bij de reparateur, per rol,
combat + utility, met aparte Nemesis-set). 🔴 **Alleen: `ns.DELVE_CURIOS_BY_SEASON` heeft een `[1]`
en geen `[2]`.** Sinds 18 aug heeft het niets te zeggen.

### De zes S2-curio's — LIJST DRIEDUBBEL BEVESTIGD

| Combat | Utility |
|---|---|
| Corrosive Bilespear | Soul-Cracking Dreamcatcher |
| Essence Trap | Dundun's Favor |
| Ouroboric Curse | Venom Infusion |

Bronnen van drie verschillende soorten, onafhankelijk: warcraft.wiki.gg (scheidt S1 en S2
expliciet), een datamining-blog van juni (PTR, geeft bewust géén advies), en de boost-sites.
✅ **Twee ervan staan in Blizzards eigen hotfixnotities** — Corrosive Bilespear (17 aug,
proc-fix) en Dundun's Favor (18 aug, lootbug). Beide staan al in `docs/PTR_12.1_WATCH.md`; de
17-aug-regel schreef er zelfs bij "raakt onze Codex-tekst niet maar wel het advies", en daar is
toen niets mee gedaan omdat er geen S2-tabel was om bij te werken.

📌 Positieve controle: de wiki zet onze drie S1-items (Porcelain Blade Tip = combat, Mandate of
Sacred Death + Overflowing Voidspire = utility) in precies de bakjes waar ons databestand ze heeft.

### De AANBEVELING — veel dunner dan de lijst

Iedereen zegt hetzelfde: **Corrosive Bilespear + Soul-Cracking Dreamcatcher voor alle drie de
rollen**, alleen de poison verschilt (Bloodcrypt voor tank/heal, Forgotten Master voor dps).

🔴 **Maar er is voor S2 GEEN eerstelijnsbron.** Wowhead schreef wél een "Best Valeera Curio
Loadout" voor Season 1 — waarschijnlijk waar onze S1-data vandaan komt — en **niets voor Season 2**.
Icy Veins evenmin. Alles komt van boost-/carry-sites die elkaar aantoonbaar overschrijven.
⚠️ Dat het advies voor alle drie de rollen identiek is, is verdacht simpel: dat kan betekenen dat
die twee domineren, of dat iedereen één build heeft gekopieerd. Niet vast te stellen.

### De concurrentie doet dit al — en zegt er niets bij

| addon | downloads | bijgewerkt | noemt zijn bron? |
|---|---:|---|---|
| Delve Companion | 516.500 | — | n.v.t. (geen advies) |
| **DelveGuide** | 151.154 | 29 aug | 🔴 nee |
| **Everything Delves** | 25.881 | 1 sep | 🔴 nee |

Everything Delves noemt letterlijk "Corrosive Bilespear for Combat and Soul-Cracking Dreamcatcher
for Utility, across all three companion roles" — een vierde stem, en een addon in plaats van een
verkooppagina, wat de consensus echter maakt.
⚠️ DelveGuide claimt "spec-by-spec curio recommendations for every class and specialization". Er
bestaat geen gepubliceerde S2-bron die zo fijnmazig gaat, en de addon noemt er geen. Niet te
controleren zonder hun data te lezen — dus **niet beweren dat het verzonnen is**, wel vaststellen
dat niemand het kán onderbouwen.

📌 **Dus: een kale "dit is de beste"-tabel maakt ons de vijfde stem die één build napraat.** Wat
niemand doet is zeggen wáár het vandaan komt en hoe zeker het is. Dat is precies deze addons
eigen stelregel, naar buiten gekeerd — en het is de enige hoek hier die van ons is.

### ~~Wat nog moet gebeuren~~ — beide punten afgehandeld op de avond van 2 sep

1. ✅ **Gemeten, en de meting weersprak de vraag.** Er zijn geen item-ID's: het zijn trait-entries
   met spellIDs (zie de correctie bovenaan deze sectie). **249223 stond hier als "hard, twee
   bronnen" en is onjuist** — een goed voorbeeld van twee bronnen die elkaar bevestigen en samen
   naast de client zitten.
   ⚠️ De probe stopt inderdaad als haar venster dicht is; dat gebeurde Rob die avond ook
   (*"probe stopped: no trait tree"*) en de foutmelding zegt niet dát je het venster moet openen.
   Nog te verbeteren.
2. ✅ **Beslist: vullen mét herkomst.** Een ster op de twee consensus-picks, gecontroleerd tegen de
   boom van de speler, plus een voettekst die zegt dat wij niets getest hebben. Voor gif een
   aparte markering, omdat daar geen guide-consensus van bekend is.

**Nieuw, 2 sep:**

7. **Delve-trinkets droppen minder sinds de hotfix van 1 sep.** Onze tips claimen geen droprate,
   dus er wordt niets onwaar — maar de PTR-wachter stelt voor het in het "wat farm ik hier"-advies
   te noemen. Robs keuze.
15. 🔴 **`DELVE_TIP_UNMEASURED` is dode tekst.** Gemeten 2 sep bij B6: hij staat in zeven talen in
    de taalbestanden en in **geen enkel codepad**. Geen speler heeft hem ooit gezien. Vermoedelijk
    overbodig geworden toen alle veertien delves echte tips kregen. **Opruimen of aansluiten** —
    dat is een keuze, geen bug, en daarom hier en niet stilzwijgend weggehaald.
    ✅ **GEMETEN, 2 sep: hij staat inderdaad niet alleen.** Lintcheck **[18]** is gebouwd — de
    spiegelvraag van [1], net zoals [16] de spiegel van [10] is. Uitkomst: **226 enUS-sleutels
    worden nergens in code genoemd**, en na groeperen blijven er **34 eenlingen** over; de rest
    zijn 40 families (`DELVE_CHAT_<slug>_ROUTE` ×46 enz.) die duidelijk uit een slug worden
    opgebouwd. `DELVE_TIP_UNMEASURED` staat in die eenlingenlijst — precies waar hij hoort.
    ⚠️ Het blijft een **kandidatenlijst**: een naam die tijdens het draaien wordt samengesteld
    ziet er identiek uit als een dode. Daarom SOFT en daarom groepeert hij: een familie van 46 is
    machinerie, een eenling is verdacht. De lijst nalopen is werk voor een keer; **34 × 7 talen**
    is de omvang van wat er mogelijk nooit iemand bereikt.
    📌 De eerste versie printte gewoon 226 namen op een rij. Dat is een lijst die niemand leest —
    en hij begroef juist de sleutel waarvoor de check gebouwd was.
    🔴 **En de tweede les is scherper.** Ik had de dynamische prefixen met de hand geraden:
    `CHANGELOG_`, `LANG_LABEL_`, `BINDING_`. `collect_references()` zag ze al bij het tellen van
    de blinde vlek van [1] en gooide de literal weg; hij geeft ze nu terug. De **gemeten** lijst is
    `ACH_KIND_`, `DISPEL_SCHOOL_`, `ENCHANT_STAT_`, `KEYBIND_TAG_`, `PLAN_KIND_`, `PROFACAD_GOAL_`
    — **nul overlap met mijn gok.** Alle zes gemist, alle drie van mij zaten er niet bij. De meting
    haalde 22 kandidaten weg (226 → 204); mijn gok haalde er nul weg.
    📌 Het antwoord lag al in de code, in de functie die het weggooide. Dat is bij deze linter nu
    drie keer gebeurd: [16], de fill-schaduw, en dit.
11. ✅ **Crest-rangen es/pt/it — GEMETEN EN GESLOTEN, 2 sep. Uitkomst: afblijven.** Alle drie de
    clients vertalen de rang wél, dus onze packs hebben het goed. Uit Wowheads gelokaliseerde
    currency-pagina's: esES *"Blasón del alba de héroe"*, ptBR *"Brasão Auroral do Herói"*, itIT
    *"Emblema dell'Alba del Campione"* (currency 3343). Spiegelbeeld van nlNL, precies zoals de
    comment in `KeepEnglish.lua` al voorspelde voor echte clienttalen.
    📌 `itIT.lua` zegt `"Champion"` en dat lijkt een besluit maar is er geen: de packs kopiëren
    het Engels voor elke sleutel zonder eigen vertaling, en de fill vervangt die kopie door
    `"Campione"` juist omdát hij gelijk is aan enUS. Deterministisch nagelopen in `fill()`.
    🔴 De vraag stond stil sinds 28 aug omdat het bestand hem naar **#translations** stuurde — een
    kanaal dat op 30 aug is opgeheven. Hij lag dus nergens. En hij had daar nooit hoeven liggen:
    Blizzards eigen data beantwoordde hem in twintig minuten. **Een vraag die bij de verkeerde
    eigenaar geparkeerd staat, blijft staan.**

### ✅ Robs drie beroepsbeslissingen — genomen én verwerkt op 2 sep

12. ✅ **`points`-semantiek → de VOORWAARDE wint.** 🔴 Bij het uitvoeren bleek Robs "30" een
    symptoom en niet de regel: `ProfessionAcademy.lua:204` vinkt een stap af bij
    `t.active >= t.max` — **tak vól**, met `max` uit de client. Er bestaat geen drempel van 30;
    30 is Recycling's maximum. `points` wordt alleen getóónd en stuurt niets.
    Dus niet een ander getal ingevuld, maar de voorwaarde uitgesproken:
    `PROFACAD_ADVISE_NEXT_POINTS_FMT` zegt nu *"about %d gets it working; this step only ticks off
    once the branch is full"*, in zeven talen, drift gemarkeerd.
    📌 Zo blijft Zygors feit (10 punten = recepten ontdekken) staan zonder te liegen over wanneer
    de stap afvinkt.
13. ✅ **Jewelcrafting stap 1 → `points = 5`**, zoals de gidsen zeggen.
14. ✅ **Inscription → `Darkmoon Curiosity`** toegevoegd als vierde boom, achteraan.
    ⚠️ Achteraan is voorzichtigheid, geen onderzoek: de volgorde van de eerste drie is gemeten,
    waar de vierde thuishoort niet. Wie dat uitzoekt mag hem verplaatsen.
    ✅ Naam geverifieerd met `_probe.py run audit_routes_vs_client` tegen Robs eigen capture:
    client zegt TAB, wij schrijven `tree`, **0 afwijkingen over alle 11 beroepen**. Een verkeerde
    naam was stil overgeslagen — de fout die op 31 aug twaalf stappen onzichtbaar maakte.

✅ **AF op 2 sep — `A Toxic Tour` (98515) is verhaal, geen daily.** Gemeten in Zygor 9.6: zijn eigen
dailies-gids noemt acht daily-ID's en 98515 zit er niet bij. De Codex zei nog "een keten van drie
quests" terwijl `CampaignLeadIn.lua` er al vier had; in zeven talen rechtgezet.

✅ **AF op 2 sep — B3 en B4.** Beide gemeten aanwezig: de milestone-poort in `DiscordNudge.lua:178`
en `CHANGELOG_ASK` in vier bestanden. Dit lijstje noemde ze nog als open — precies de fout die de
sectie bovenaan dit bestand beschrijft.

### 📌 Twee dingen die vandaag als werkwijze zijn vastgelegd

- **Niets aannemen, altijd meten** — óók voor "is dit al af?". Rob vroeg het twee keer en had
  twee keer gelijk. Een doc citeren is geen controle; een lege grep bewijst niets zonder
  positieve controle. Zie de nieuwe sectie in `CLAUDE.md`.
- **Nieuw gereedschap via de voordeur**: `python "<repo>/tools/_probe.py" run <tool> [args]`.
  Elk nieuw scriptpad kost Rob anders een prompt bij élke run.


## 📌 Ouder, maar nog niet af — staat in `docs/NEXT_SESSION_ARCHIVE.md`

De historie is op 2 sep afgesplitst. Deze secties lezen daar nog als OPEN, dus ze staan
hier bij naam — een openstaand punt mag niet verdwijnen door oud te zijn.

✅ **Alle negentien kandidaten zijn diezelfde middag één voor één nagelopen** (Rob: *"waarom niet
nu nalopen, ik ben toch onderweg"*), en elf bleken af. Het oordeel staat per stuk mét reden in
`KNOWN_DONE` in `tools/split_handoff.py`, zodat het na te lezen is in plaats van te geloven.
Onder de opgeloste: de dispel-aankondiging (staat in `docs/CURSEFORGE_3.7.0.md`), `fill()` die
eigennamen terugdraaide (nu `Locales/KeepEnglish.lua` + lintcheck [15]), de Season 1-tiersettabel
(op 29 aug verwijderd, leest nu de tooltip van je gedragen stuk) en de gehardcodeerde S1-ilvl's in
de delve-tooltip (weg uit `Modules/Delves.lua`).
⚠️ Eén blijft er staan die ik **niet** heb kunnen verifiëren: *MORGEN 19 AUG* (quest 96466).
Onverifieerd is niet hetzelfde als open, maar ook niet hetzelfde als af.
📌 Herclassificeren gaat met `python "<repo>/tools/_probe.py" run split_handoff --reindex --write`.

- 🆕 30 aug — waar komen onaangeleerde recepten vandaan? (OPEN)
- 🔵 OPEN 29 aug — de SMC-pin zet TWEE waypoints, plus één die niemand vroeg
- 💡 ROB-VERZOEK 19 AUG — "dit soort info moeten wij ook gaan bieden!!!"
- 🎯 MORGEN 19 AUG — PRIORITEIT: de EU-seizoensstart
- ⚠️ OPEN, en het raakt alle vertaalwerk
- 🌅 MORGENVROEG — twee dingen, en Rob brengt data mee
- 🔴 De grootste openstaande vraag (Rob, 11 aug)
- ⏳ Wacht op Rob

📌 Al het afgeronde werk staat in het archief; daar wordt niets meer aan
toegevoegd. Nieuwe regels horen bovenaan dit bestand.
