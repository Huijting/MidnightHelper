# Ideeën — de ene lijst

Gemaakt 10 nov 2026 (Rob: *"ja, voor de ideeënlijst"*). Dit is vanaf nu de enige plek voor ideeën.
De toets en de vaste vorm staan in `docs/PLAN_WERKWIJZE_2026-11-10.md`.

**Hoe het werkt**

- Een nieuw idee komt in **Open**, in de vaste vorm. Rob zegt ja, nee of later.
- **Ja** = wordt gebouwd. Is het gebouwd, dan gaat het naar **Af**.
- **Nee** blijft staan, mét de reden. Zo komt het niet steeds terug.
- De oude lijsten blijven als geschiedenis: `IDEEEN_OPEN_2026-10-08.md`, `PLAN_IDEEEN_2026-11-05.md`.

**Hoe deze eerste versie is gemaakt**

- De open punten uit de twee oude lijsten, de wensen uit `SURVEY_RESULTS.md` (31 antwoorden) en de "Later"-regel
  bovenaan `NEXT_SESSION.md`. Het archief en de plan- en specbestanden zijn NIET doorgelopen.
- **GEMETEN** = vandaag met grep in de code gezien, met een tegencontrole die in dezelfde run wél iets vond.
  **NIET GEMETEN** = overgenomen uit de oude lijst.
- Gemeten wordt alleen of het in de code staat. Niet of het in een release zit, en niet of het in het spel werkt.
- "Voor wie" en "Werk" zijn mijn inschatting (AFGELEID), geen meting.
- Nog niet getoetst aan de vijf vragen. Dat doet Rob met een ja, nee of later per regel.

Kolom *Voor wie*: N = nieuweling, V = veteraan. Kolom *Spel*: M = Midnight, F = Forever.

---

## Open — wacht op Rob

### Uit de vragenlijst (echte spelers) — naast de toets gelegd, 10 nov

**Uitkomst: drie van de vijf wensen zijn al gebouwd.** GEMETEN in de code (niet in het spel). Ze staan nu onder "Af".
Wat overblijft:

| # | idee | voor wie | spel | bron | stand in de code | werk | mijn advies |
|---|---|---|---|---|---|---|---|
| S1 | **Onderdelen beter vindbaar maken.** Geteld in de 31 antwoorden, kolom "nooit / onbekend": keybind-coach 14, M+ 12, site 12, beroepen 10, "Zo speel je" 9, kaarten 9, brez 9, gear 8. (Die kolom zegt "nooit óf onbekend": wie solo speelt en M+ niet gebruikt, mist niets.) | N + V | M + F | vragenlijst | Er is al: Start Here, de rondleiding (`Tour.lua`), de zoekbalk, de kamers met kaartjes. | middel | **Ja.** Zie de drie vormen hieronder. |
| S4 | **Zichtbare route om een delve sneller te doen.** | V | M | vragenlijst #27 (29 okt) | GEMETEN: er is een kisten-route (`DelveCoach.lua:1066-1073`). Een "snelste pad" bestaat niet. | groot | **Later.** Zakt op vraag 4 van de toets: de snelste weg door een delve is niet te meten in het spel. We zouden hem moeten verzinnen of overnemen. Wat wel kan: je eigen tijden per kamer tonen (bestaat al voor de Labyrinth). |

**S1 in drie vormen (mijn voorstel, Rob kiest):**

1. **"Je bent 90. Dit is wat je nu doet."** Eén keer, op het moment dat je het hoogste level haalt: een kort venster
   dat naar "My gear: what now?" en Start Here wijst. Precies de vraag van vragenlijst #24. GEMETEN: niets in de addon
   doet nu iets op dat moment behalve een balk verversen (`ZoneLevelGate.lua:349`). Toets: nieuweling, moment is
   aanwijsbaar, bron is een speler, data is meetbaar (je level), bouwt op bestaande vensters. Werk: klein.
2. **Een zesde vraag in de toets: "Hoe vindt de speler dit?"** Elk nieuw onderdeel krijgt een plek waar de speler het
   tegenkomt op het moment dat hij het nodig heeft. Geen bouwwerk, een regel.
3. **De keybind-coach apart bekijken.** Minst bekend, 1 van de 31 gebruikt hem vaak. Vraag voor Rob: is dat een
   vindbaarheidsprobleem, of is het een onderdeel voor weinig mensen? Dat is geen meting maar een keuze.

De twee bugs uit vragenlijst #27 zijn geen ideeën. GEMETEN: op 30 okt kwam er een schakelaar "vensterplek per
character" (`SettingsDefs.lua`), een dag na die melding. Of dat de bug oplost, en of het kamerkaartje nog verdwijnt:
NIET GEMETEN.

### Nooit gebouwd

| # | idee | voor wie | spel | bron | stand in de code | werk |
|---|---|---|---|---|---|---|
| O1 | **Toetsen ook op Dominos en EllesmereUI.** | V | M | oude lijst A2 | GEMETEN: half af. `LiveKeys.lua:9-11` leest sinds 10 okt Bartender4 en ElvUI; Dominos en EllesmereUI nog niet. | middel |
| O2 | **Groeps-kickscore na de run** (wie kickte wat). Werkt alleen als iedereen MH heeft. | V | M | oude lijst A4 | GEMETEN: niet gebouwd (`Comms.lua` kent geen kick; `InterruptScore.lua` zegt "Phase 2"). | groot |
| O3 | **Schat-tussenstappen apart afvinken.** | N + V | M | oude lijst A5 | NIET GEMETEN | middel |
| O4 | **Trading Post: 3D-model en vastzetten.** | V | M | oude lijst A6 | GEMETEN: "heb je al" voor transmog is gebouwd (10 okt, `TradingPost.lua:213`). 3D-model en vastzetten: NIET GEMETEN. | middel |
| O5 | **Extra healer-cooldowns** (Rapture, Spirit Shell, Symbol of Hope, Flourish, Grove Guardians). | V | M | oude lijst A7 | GEMETEN: niet gebouwd (0 treffers in `HealerCooldowns.lua`; Tranquility wel). | klein |
| O6 | **Snelle chatregels** naar je groep. | V | M | oude lijst A9 | GEMETEN: niet gebouwd. Of chat in 12.x dit toelaat is onbekend. | middel |
| O7 | **Keybind-opties** (volgorde op gebruik, "lastige toets", tweede kick). | V | M | oude lijst A10 | GEMETEN: niet gebouwd. Het toetsenblok vervangt dit mogelijk (AFGELEID). | middel |
| O8 | **Rustig overstappen**: een paar toetsen per week. | N | M | oude lijst A11 | NIET GEMETEN | middel |
| O9 | **Sneltoetsen voor alle schermen.** | V | M | oude lijst A13 | GEMETEN: `Bindings.xml` heeft er 8. De keypad-commando's dekken hetzelfde. | klein |
| O10 | **Paneel voor 12-knopsmuizen.** Mogelijk achterhaald (Rob 4 okt: muis leeg). | V | M | oude lijst A14 | NIET GEMETEN | middel |
| O11 | **Buff-herinnering noemen op CurseForge.** Geen code. | — | M | oude lijst A15 | GEMETEN: "buff" komt 1× voor in `CURSEFORGE_DESCRIPTION.md`. | klein |
| O12 | **FastMark via de nieuwere techniek.** De speler merkt niets. | — | M | oude lijst A17 | GEMETEN: gebruikt nog `/tm`. | klein |
| O13 | **Teller wekelijkse Knowledge-drops** ("1 van 2 deze week"). | V | M | oude lijst D1 (Rob 13 sep: "voor later") | GEMETEN: niet gebouwd (item 259197 komt 0× voor). | middel |
| O14 | **Renown en reputatie in het alt-overzicht.** | V | M | oude lijst D2 | GEMETEN: niet gebouwd (0 treffers in `AltOverview.lua`). | middel |
| O15 | **Flask, eten en olie met één knop.** | V | M | oude lijst D4 | NIET GEMETEN | middel |
| O16 | **Kadertje bij een gekozen rare** met portret en afstand. | N + V | M | oude lijst D5 | NIET GEMETEN | middel |
| O17 | **Meer wekelijkse klussen** (prey, Soirée, Haranir, Stormarion, World Tour, "waarom groen"). | V | M | oude lijst D6 | NIET GEMETEN. Darkmoon Faire staat alleen in Forever (`ForeverWeek.lua`). | groot |
| O18 | **"Jouw Seizoen 2"** (zoals Spotify Wrapped). Advies was: venster pas vlak voor het einde van het seizoen. | V | M | `PLAN_IDEEEN` idee A | GEMETEN: geen venster, geen `/mh wrapped`. De tellers lopen wel (`SeasonStats.lua`). | middel |
| O19 | **Valeera's dagboek**: één regel per run. | N + V | M | `PLAN_IDEEEN` idee C | GEMETEN: geen dagboek. Het verhaal per run wordt wel bewaard (`DelveHistory.lua`). | groot (vertalen) |
| O20 | **Forever: voorraad-waarschuwing, writ-helper, Omnium Folio 6/7.** | N + V | F | `NEXT_SESSION.md` regel "Later" (10 nov) | NIET GEMETEN | ? |

### Half, of wacht op een test

| # | idee | stand |
|---|---|---|
| H1 | **Blizzards dispel-rand uitleggen** in de Codex (oude lijst B1). | GEMETEN: geen artikel; "dispel" staat alleen als zoekwoord in `MidnightCodexData.lua`. |
| H2 | **Piepje bij een dispelbare debuff** (B2). | GEMETEN: gebouwd, de kop zegt nog "NOT MEASURED". Wacht op een test in een gevecht. |
| H3 | **Heal-lens voor Season 2-bazen** (B3). | GEMETEN: `HealerCooldowns.lua:401` zegt dat S2-bazen nog moeten komen. |
| H4 | **Laatste losse instellingen in het instellingenscherm** (B4). | GEMETEN: deels. Een van de gezochte namen staat nu in `SettingsDefs.lua`; welke nog ontbreken is NIET GEMETEN. |
| H5 | **Reclamefilm, introfilm, iconen verspreiden** (B6, B7, B8). | NIET GEMETEN, staat buiten de repo. Wacht op Rob. |
| H6 | **Open keuzes uit het oude briefje** (D8): machinetekst in oude changelog-vertalingen; Raidbots-bericht. | NIET GEMETEN. |

---

## Ja — wordt gebouwd

Hier komt wat Rob goedkeurt, ook wat hij rechtstreeks in de bouwchat vraagt (Rob, 10 nov: *"ja we willen het op 1
lijst"*). Gebouwd maar nog niet door Rob in het spel gezien = blijft hier, met de commit erbij. Na zijn test naar **Af**.

### Forever: de pijl wijst de boot, zeppelin, tram of het portaal aan
- Voor wie:      allebei (nieuweling: "waar moet ik heen?"; veteraan: "welke boot ook alweer?")
- Moment:        als je een pijl zet naar iets op een ander continent, op Teldrassil, of in Ironforge vanuit Stormwind
- Spel:          Forever
- Bron:          Rob in het spel, 10 nov 2026, Darkshore → wapentrainer in Ironforge: *"waar ga ik naartoe?"*
- Bouwt op:      de route-pijl (`NativeArrow.lua`) en de vorm van de Midnight-reisplanner; het wapentrainer-venster
- Data:          GEMETEN — havens uit Blizzards Forever-DB2 (TaxiPathNode 70888), Wowhead-NPC's, Robs eigen boten in Auberdine
- Vindbaar:      vanzelf: de pijl en "The way there" in het wapenvenster; `/mh travel` alleen als diagnose
- Werk:          middel
- Site:          ja, als het uit is (`docs/SITE_SEIN.md`)
- Rob zegt:      ja (*"uitzoeken en bouwen graag"*, 10 nov). **Gebouwd: 7bb1e53.** Wacht op Robs test (TESTLIJST 10 nov avond).

---

## Af — sinds de oude lijsten gebouwd (niet opnieuw voorstellen)

GEMETEN vandaag in de code. Niet gemeten: of het in een release zit en of het in het spel werkt.

- **Death-recap-les uit Blizzards eigen recap** (oude A1) — `Retrospective.lua:312-322`, gebouwd 10 okt.
- **Codex: Midnight beginnen op een alt** (oude A3) — `MidnightCodexData.lua:165-168`.
- **Trading Post: transmog "heb je al"** (deel van oude A6) — `TradingPost.lua:213-225`.
- **Toetsen op Bartender4 en ElvUI** (deel van oude A2) — `LiveKeys.lua:9-11`.
- **Tank en healer markeren op rol** (oude D3) — `FastMark.lua:256-295`.
- **WoW Forever** (oude B5) — eigen TOC `MidnightHelper_Camelot.toc` (16001), uit sinds 5.0.0.
- **"Ik heb 20 minuten"** (`PLAN_IDEEEN` idee B) — `TimePlan.lua`.
- **Forever: macro's per spec** — `ForeverMacros.lua:367` (10 nov, top 3 per spec).
- **Vragenlijst #16: de Midnight-achievements die je nog mist** — `MidnightAchList.lua` (`/mh achlist`, 5 okt).
- **Vragenlijst #24: "wat doe ik voor gear?"** — `GearLadder.lua` (`/mh gear`, 19 okt). Zij antwoordde 21 okt en kende het niet: zie S1.
- **Vragenlijst #11: weekplan voor solo-spelers** — schakelaar `mh_homeSolo` (`SettingsDefs.lua:591`, 2 okt). Vragenlijst #13 noemt hem met lof.
- **Verhaal per delve-run bewaren** (`PLAN_IDEEEN` stap 1) — `DelveHistory.lua`.
- De 26 punten uit bak C van de oude lijst (C1 t/m C26): niet opnieuw gemeten, zie daar.

Niet opnieuw gemeten, twijfel: **Ritual Sites-mounts** (oude A8). `MountProgress.lua` noemt nu meer dan één
Ritual Sites-mount; of alle vijf erin staan is niet geteld.

---

## Nee — met reden (niet opnieuw voorstellen)

Overgenomen uit de oude lijst (X1 t/m X9), NIET opnieuw gemeten.

- Live dispel-melding voor groepsleden — 12.1 maakt die auras geheim.
- Void Assault naar de Special Assignment routeren — Rob koos de hub.
- Item level per M+-sleutelniveau — de API gaf onzin.
- CurseForge-vertaalplatform — loopt via GitHub.
- "Beste curio"-ranglijst — een andere addon doet dat al.
- De hele Ula'tek-campagne stap voor stap — Rob koos licht.
- Muisknoppen standaard vullen in het toetsenblok — Rob 4 okt: leeg laten.
- Wago-downloadteller — zit achter een betaalmuur.
- Start Here als starttabblad, Raids onder Dungeons — afgewezen door het ontwerppanel.
- FarstriderLib als reisplanner (oude A12) — het grootste gat is zelf opgelost; alleen een meetknop gebouwd. *Mijn
  voorstel voor "nee"; Rob beslist.*
- Beroepenplan exporteren naar KnowledgeLoadout (oude A18) — nooit door Rob gevraagd. *Mijn voorstel voor "nee".*
- KeyUI bestuderen (oude A16) — onderzoek, geen idee voor spelers. *Mijn voorstel voor "nee".*

---

## Voorstellen van de wachter

De wekelijkse ideeën-wachter (cloud-routine, sinds 10 nov 2026) schrijft ALLEEN hier, onderaan, hooguit drie per week
in de vaste vorm. De bouwchat verplaatst ze naar Open, of naar Nee met reden. Niemand anders schrijft in dit blok.
