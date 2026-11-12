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
| O21 | **Accountoverzicht in Forever** (al je characters op een rij). | V | F | Rob, 11 nov: *"we missen ons account overzicht in forever"* | GEMETEN 11 nov: `AltOverview.lua`, `AccountWeeklyChecklist.lua` en `CurrencyAccount.lua` staan alleen in `MidnightHelper.toc`, niet in `MidnightHelper_Camelot.toc` (tegencontrole: ForeverWeek/ForeverTravel wél gevonden). Wat Forever erin wil zien (level, goud, beroepen, raid-locks?) is nog niet bepaald. | middel? |
| O22 | **Forever: de tooltip zegt "dit heb je niet meer nodig, omdat…"** Bijvoorbeeld: recept ken je al, jouw class kan het nooit dragen, eten is te zwak voor je level. Eén extra regel naast "Used for …". | N + V | F | Rob, 12 nov, na het bekijken van de addon Keep or Toss: Forever (Aquary, CurseForge, All Rights Reserved: alleen het idee, geen code of data): *"Zet inderdaad punt 1 en 2 maar als idee in onze ideeënbox."* | GEMETEN 12 nov: `ReagentUse.lua` zegt alleen waar een item vóór is ("Used for"), nooit dat je het niet meer nodig hebt; grep op `already known` en `ITEM_SPELL_KNOWN` in `Modules/` gaf niets (tegencontrole: "Used for" wél gevonden, 3 keer in `ReagentUse.lua`). NIET GEMETEN: welke van de redenen de Forever-client zelf prijsgeeft (bekend recept, draagbaarheid per class, eten per level). Eerst meten, per reden. Geen `/mh`-diagnose bedacht; `/mh usedfor` ligt voor de hand. | klein tot middel? |
| O23 | **Forever: de tooltip zegt dat een item nodig is voor een quest in je log.** Alleen de quests die je hebt, zonder Questie. Keep or Toss doet ook "quest die je nog niet hebt", maar leest dat uit Questie; dat deel nemen we niet over. | N + V | F | Rob, 12 nov, zelfde bron en zelfde zin als O22. | GEMETEN 12 nov: geen tooltip-module leest quest-doelen. `GetQuestLogLeaderBoard` en `C_QuestLog.GetQuestObjectives` komen alleen voor in `LayoutWizard.lua`, `AtalUtekProbe.lua` en `Achievements.lua` (zelfde grep, zelfde tegencontrole als O22). NIET GEMETEN: of de Forever-client bij een quest-doel het item-id geeft of alleen een naam, en of Blizzards eigen tooltip dit al zegt ("Quest Item"). Eerst in de client meten. | klein? |
| O24 | **Forever: een knop met een oude rank licht op, op de balk zelf.** Nu zegt MH het in de chat en met een knop onder het trainervenster; Rob: "niemand kijkt in de chat", en *"niet iedereen zal onze Keys layout gebruiken"*. Oplichten op de eigen knop bereikt iedereen, welke balken iemand ook heeft. | N + V | F | Rob, 12 nov, na het bekijken van de addon Glowing Bars (vattiss, CurseForge, MIT): *"inderdaad ook onze ideeën die je geeft, doe maar."* Alleen oude ranks; de rest van Glowing Bars (procs, cooldowns, wapenbuffs, groepsbuffs, reagents) bouwen we niet na. | GEMETEN 12 nov: `ForeverRanks.lua` weet al welke knoppen het zijn (loopt plek 1 t/m 180 langs, volgens zijn eigen kop; de hele code niet nagelopen). Grep op `ShowOverlayGlow`, `LibCustomGlow` en `ActionButtonSpellAlertManager` in alle `.lua` en `.toc` gaf niets; ⚠️ zonder goede tegencontrole, dus dit bewijst niet dat er geen gloed-code is. Hoe `/mh glow` in Midnight tekent is NIET nagelopen, en of dat in Forever kan ook niet. NIET GEMETEN: hoe je in Forever bij de knop van een balk-addon (Bartender4, Dominos, ElvUI) komt. Diagnose: `/mh ranks` bestaat al. | klein tot middel? |
| O25 | **Forever: MH zwijgt over oude ranks als Glowing Bars aan staat.** Anders melden twee addons hetzelfde. Hoort bij O24. | V | F | Rob, 12 nov, zelfde bron en zelfde zin als O24. | GEMETEN 12 nov: `ForeverRanks.lua` vraagt nergens of een andere addon geladen is (grep op `IsAddOnLoaded("` in dat bestand: niets; geen tegencontrole in dezelfde run). AFGELEID: de map heet `GlowingBars` (uit de naam van hun zip, `GlowingBars-3.0.0.zip`); in Robs addon-map meten. Een speler moet het terug kunnen zetten (CLAUDE.md, de WaypointUI-les): zwijgen mag niet stil, `/mh ranks` moet zeggen dat en waarom. | klein |

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

### Forever: Priest-tip "Shadowform" klopt weer met de hotfix van 11 nov
- Voor wie:      allebei (Gnome-Priest)
- Moment:        How you play → Priest → Beginner mistakes
- Spel:          Forever
- Bron:          content-wachter 12 nov [RAAKT ONS]; Blizzard-hotfix 11 nov: Confounding Flash werkt nu in Shadowform
- Bouwt op:      `ForeverHowToPlay.lua` + 7 `Locales/ForeverHowToPlay_*.lua`
- Data:          GEMETEN in Blizzards hotfixtekst; Chastise/Fear Ward NIET GEMETEN (zin blijft daar zoals hij was)
- Vindbaar:      vanzelf, in de Priest-kaart
- Werk:          klein
- Site:          nee (tekstfix)
- Rob zegt:      ja (*"Ja, doe allebei"*, 12 nov). **Gebouwd 12 nov.** Wacht op Robs blik (TESTLIJST 12 nov).

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

### `/mh selftest` en de vensterregel (opdracht 7, stap c)
- Voor wie:      wij (Rob test niet meer óf iets bestaat, alleen of het goed voelt); later misschien spelers
- Moment:        na een patch of een grote wijziging; Rob typt het, `/reload`, de bouwchat leest het rapport
- Spel:          Midnight + Forever
- Bron:          plan deel 4b stap 7 (sparring-chat); Rob 11 nov: *"Ja, bouw het"* (in de bouwchat)
- Bouwt op:      `tools/data_check.py` (dezelfde scanner, één lijst), `DialogPopup.lua` SCALABLE_WINDOWS
- Data:          GEMETEN in Blizzards API-documentatie: DoesSpellExist / DoesItemExistByID / GetMapInfo; quest en
                 achievement hebben geen betrouwbare "bestaat niet"
- Vindbaar:      `/mh`-commandolijst + zoekbalk
- Werk:          middel
- Site:          nee (hulpmiddel)
- Rob zegt:      ja. **Gebouwd 11 nov** (zelftest + lint [25] vensters + [26] lijst actueel). Wacht op Robs eerste run.
                 Later: fase 2, per venster "heeft zijn tekst".

### De buff-melding wordt een zin
- Voor wie:      allebei (nieuweling: "wát mis ik?"; veteraan: in één blik zien welke)
- Moment:        als er een buff, aura, stance, pet of wapen-buff ontbreekt
- Spel:          Midnight + Forever (Rob, 11 nov: *"Ja, met jouw advies"*: beide spellen, icoon blijft waar de speler het zette)
- Bron:          Rob, 11 nov 2026, na PaladinPlan (GPL-3.0: alleen het idee, geen code of tekst)
- Bouwt op:      `MissingBuff.lua` (icoon + klik), `ForeverBuffs.lua` (Forever-lijst)
- Data:          spellnaam uit de client (dus altijd in de taal van die client)
- Vindbaar:      vanzelf, onder het icoon; `/mh buffs` (Forever) en `/mh mbuff` tonen dezelfde zin
- Werk:          klein
- Site:          ja (`docs/SITE_SEIN.md`)
- Rob zegt:      ja. **Gebouwd 11 nov**, met drie reparaties: Greater Blessings tellen mee (Forever), de onware zin
                 "de onze kun je in gevecht aanklikken" is weg, `/mh mbuff` bestaat altijd (2237696).
                 ✅ Forever gezien door Rob, 11 nov (blessing + aura, `/mh buffs`). Nog open: Midnight, in een gevecht,
                 Greater Blessing. Daarna naar **Af**.

### Buff "bijna afgelopen", met de tijd erbij
- Voor wie:      allebei
- Moment:        buiten een gevecht, als een buff bijna afloopt (rood = weg, geel = loopt af)
- Spel:          Forever eerst
- Bron:          Rob, 11 nov 2026, na PaladinPlan
- Bouwt op:      de buff-melding hierboven
- Data:          NIET GEMETEN: of `expirationTime` via `ns.Aura` leesbaar is in Forever. Eerst meten.
- Vindbaar:      vanzelf, dezelfde plek als de buff-melding
- Werk:          middel
- Site:          ja, als het uit is
- Rob zegt:      ja (later; via de sparring-chat, door Rob bevestigd in de bouwchat 11 nov)

### Forever: venstertje "Doe dit nu / Alles bij / Komt eraan"
- Voor wie:      vooral nieuweling
- Moment:        tijdens het levelen: wat nu te doen, en welke spells de volgende 3 levels komen (bij naam)
- Spel:          Forever
- Bron:          Rob, 11 nov 2026, na PaladinPlan
- Bouwt op:      ForeverTrainer, ForeverRanks, de wapenteller, GetMissingBuffs; met een schakelaar
- Data:          AFGELEID: alles bestaat al in die modules; niets nieuw gemeten
- Vindbaar:      nog te bepalen
- Werk:          middel tot groot
- Site:          ja, als het uit is
- Rob zegt:      ja (later). Eerst met de sparring-chat doorpraten wat erin moet, voor alle classes; nog niet ontwerpen.

### Eén schakelaar "Verplaatsen" voor alle MH-onderdelen op het scherm
- Voor wie:      allebei
- Moment:        als je je scherm inricht: alles zichtbaar met "sleep mij"
- Spel:          Midnight + Forever
- Bron:          Rob, 11 nov 2026, na PaladinPlan
- Bouwt op:      de losse sleep-functies die elk onderdeel al heeft (bv. het buff-icoon)
- Data:          niet nodig
- Vindbaar:      instellingen + een `/mh`-commando
- Werk:          middel
- Site:          ja, als het uit is
- Rob zegt:      ja (later)

### Alle ontbrekende buffs tonen, en uitleggen welke MH kiest
- Voor wie:      allebei
- Moment:        als er meer dan één buff ontbreekt (nu toont MH alleen de eerste, `MissingBuff.lua` UpdateMissingBuff)
- Spel:          Midnight + Forever
- Bron:          Rob, 11 nov 2026, na PaladinPlan
- Bouwt op:      de buff-melding; de keuze "laatst gecast wint" (`ForeverBuffs.lua` PickChoice) in de tooltip uitleggen
- Data:          niet nodig
- Vindbaar:      vanzelf
- Werk:          klein tot middel
- Site:          ja, als het uit is
- Rob zegt:      ja (later)

### Vlak voor een gevecht: je mist iets wat aan moet staan (bv. geen seal)
- Voor wie:      vooral nieuweling
- Moment:        je hebt een vijand als doel, buiten een gevecht
- Spel:          Forever (Midnight: Rob nog niet gevraagd)
- Bron:          Rob, 11 nov 2026, na PaladinPlan (*"deze melding vond ik ook briljant"*; GPL-3.0: alleen het idee)
- Bouwt op:      ForeverWarnings (de rust-waarschuwing bij een vijandig doel) en de lijst per class in ForeverBuffs
- Data:          GEMETEN 11 nov: "Seal" komt niet voor in `ForeverBuffs.lua`. Nog te meten: wat per class aan moet staan
                 (seal, aspect, poison, wapen-buff, schild …) en of een seal in Forever leesbaar is via `ns.Aura`
- Vindbaar:      een zin op de plek van de andere waarschuwingen, met een schakelaar
- Werk:          nog te schatten na het uitzoeken
- Site:          ja, als het gebouwd is
- Rob zegt:      ja (via de sparring-chat, 11 nov; nog te bevestigen in de bouwchat)

### Welke kant ga ik op? (idee 7, hoort bij het "Doe dit nu"-venster)
- Voor wie:      de nieuweling (Rob: *"als newbie weet ik nu helemaal niks"*)
- Moment:        zodra je kunt kiezen (eerste talentpunt), en elke keer dat je iets krijgt waarvan je niet weet of het
                 bij je past (een wapen, gear). Robs voorbeeld: een two-handed sword; is het nu al de lange loop naar de
                 wapentrainer waard?
- Spel:          Forever (Midnight: Rob nog niet gevraagd)
- Bron:          Rob, 11 nov 2026, paladin level 5 (via de sparring-chat)
- Bouwt op:      ForeverHowToPlay (uitleg per class), ForeverWeapons (`/mh weapons`), de upgrade-rekenaar (questbeloning
                 + tooltipregel), en het "Doe dit nu"-venster (moet weten wat de speler wil worden)
- Data:          GEMETEN 11 nov (bouwchat): `ForeverHowToPlay.lua` noemt losse talent-spells (Seal of Command, Shadowform …)
                 maar legt nergens de keuze tussen de richtingen uit. Nog te meten, alle classes: de richtingen in gewone
                 woorden, wat elke richting nodig heeft, vanaf welk level de keuze telt, wat opnieuw kiezen kost.
- Vindbaar:      op het moment van de keuze, op het scherm, niet via een commando
- Werk:          groot; samen met het "Doe dit nu"-venster als één ontwerp
- Site:          ja, als het gebouwd is
- Rob zegt:      ja, eerst doorpraten in de sparring-chat (via de sparring-chat, 11 nov; nog te bevestigen in de bouwchat)

### Spelnamen in de zes talen zoals die client ze toont (C4)
- Voor wie:      allebei, in de/fr/es/pt/it/ru (Engels en Nederlands veranderen niet)
- Moment:        overal waar MH een spelnaam toont: titel, delve, mount-plek, Trading Post, World Boss, drankje
- Spel:          Midnight
- Bron:          de C4-controle (`run data_check --c4 --all`), 65 namen op 10 nov
- Bouwt op:      de regel "clientnaam wint altijd" (CLAUDE.md, Localization)
- Data:          GEMETEN — elke naam uit Blizzards DB2 van die taal (wago, live 12.1.5.70783)
- Vindbaar:      vanzelf, het is de tekst zelf
- Werk:          klein
- Site:          nee
- Rob zegt:      ja (*"Ja, alle drie"*, 11 nov). **Gebouwd 11 nov:** 41 waarden herschreven (mh-writer), 8 op de negeerlijst
  met reden, 3 bewust open (de Duitse/Spaanse delve-naam staat ook midden in een zin). C4 nu 3 nakijken. Wacht op een
  tester met een niet-Engelse client (TESTLIJST 11 nov).
- Nog open:      dezelfde oude namen staan nog in ~70 andere zinnen per taal (`docs/C4_OUDE_NAMEN_2026-11-11.md`). Rob kiest.

### Spell geleerd maar nog op slot: MH zegt welke quest je moet doen
- Voor wie:      vooral de nieuweling
- Moment:        zodra je een spell krijgt of ziet die je pas na een class-quest kunt gebruiken
- Spel:          Forever (Rob bevestigde in de bouwchat: "Ja, dat was in Forever")
- Bron:          Rob, 11 nov 2026, Paladin level 4, Judgement ("Als ik er geen ervaring mee had, snapte ik er niks van");
                 doorgegeven door de sparring-chat
- Bouwt op:      ForeverTrainer (questtabel), ForeverHowToPlay
- Data:          wordt uitgezocht (mh-research, 11 nov): bij welke classes en spells, questnaam en quest-ID per geval.
                 GEMETEN door de sparring-chat: MH zegt nu Judgement = level 4 bij de trainer, zonder quest
                 (`ForeverTrainerData.lua:523`, `ForeverHowToPlay.lua:80`). Klopt dat niet, dan is het ook een fout.
- Vindbaar:      waar de speler de spell tegenkomt (trainer-lijst, speelkaart), niet alleen in de chat
- Werk:          na het uitzoeken
- Site:          ja, als het gebouwd is
- Rob zegt:      ja (in de sparring-chat, 11 nov; doorgegeven), en in de bouwchat "Ja, bouw dat". **Gebouwd 11 nov:**
                 Judgement-seal-tip + Claw-fix (ebcefef); trainervenster zegt bij een ontbrekende quest-rank "(uit een
                 class-quest, niet bij de trainer)" (`ns.FOREVER_QUEST_FIRST` in `ForeverTrainer.lua`); How you play bij
                 Redemption, Aquatic Form en de Priest-rasspells. Wacht op Robs test (TESTLIJST 11 nov).

### Melding bij een upgrade die je net oppakt
- Voor wie:      allebei, vooral de nieuweling
- Moment:        direct nadat het item in je tas komt (Rob: op lage levels loop je hard rond, je krijgt dingen vanzelf in
                 je tas, en je moet nu je tas openhouden om te zien of er een upgrade bij zit)
- Spel:          Midnight en Forever (Rob koos "allebei")
- Bron:          Rob, 11 nov 2026, tijdens het spelen; doorgegeven door de sparring-chat («MidnightHelper werkwijze sparring»)
- Bouwt op:      `Modules/LootUpgrade.lua` (tooltip-regel, `/mh loot`) en `Modules/BagUpgrade.lua` (groene pijltjes,
                 `/mh bagarrows`), beide via `ns.GetLootUpgradeInfo`. Volgens de sparring-chat (GEMETEN door hen): beide
                 alleen in `MidnightHelper.toc`, niet in de Forever-toc. Nog geen melding bij het oppakken (AFGELEID door hen).
- Data:          nog te meten: (1) geeft `ns.GetLootUpgradeInfo` op lage levels een bruikbaar oordeel (gewichten per spec)?
                 (2) kan de rekenaar in Forever draaien?
- Vindbaar:      een korte melding op het scherm zelf, niet alleen in de chat (Rob: "niemand kijkt in de chat"), met een
                 schakelaar zodat spelers zelf kiezen
- Werk:          nog te schatten na het nameten
- Site:          ja, als het gebouwd is
- Rob zegt:      ja (in de sparring-chat, 11 nov; doorgegeven). Voorstel van de sparring-chat, niet van Rob: alleen melden
                 bij een duidelijke upgrade, dezelfde lat als de pijltjes. Nog niets gebouwd: eerst de twee metingen.
                 Aanvulling (Rob, 11 nov, doorgegeven): **eerst de groene pijltjes en de tooltip-regel ook in Forever**, dan
                 pas de melding. Volgorde: zie NEXT_SESSION 11 nov (stap b vóór d).
                 **Stap b, 11 nov (Rob: "Alleen tooltipregel"):** geen pijltjes in Forever (Pawn doet ze al, Baganator
                 vervangt de tassen; GEMETEN in Robs addon-lijst). Wel gebouwd: een groene "MH: … over what you wear (…)"-
                 regel in de tooltip, met de rekenaar van de questbeloning-tip, `/mh geartip`. Wacht op Robs test.
                 (2) hierboven is daarmee beantwoord: de Forever-rekenaar is die van de questbeloning-tip.
                 **Stap d, 11 nov (Rob: "Ja, allebei"): de melding zelf gebouwd**, beide spellen: `PickupUpgrade.lua`,
                 kort schermbericht + chatregel, `/mh pickup`. (1) hierboven GEMETEN: Midnight-rekenaar heeft een spec
                 nodig en kijkt niet naar draagbaarheid → rode-regel-check + alleen ilvl én score hoger. Wacht op Robs test.

### Zygor-wachter: elke ochtend wat er in Zygor veranderde
- Voor wie:      wij (bron voor questketens, coördinaten, mounts, achievements)
- Moment:        elke ochtend, in de ochtendronde
- Spel:          Midnight en Forever (beide Zygor-mappen)
- Bron:          open punt sinds 10 nov (Zygor werkte MID-mounts en -achievements bij); Rob: ja (11 nov, via de sparring-chat)
- Bouwt op:      `tools/handynotes_watch.py` (zelfde vorm: kopie, verschil per zone, via de voordeur)
- Data:          Zygor-gidsen op Robs pc; alle zones
- Vindbaar:      een stap in `docs/OCHTENDRONDE.md`
- Werk:          klein tot middel
- Site:          nee
- Rob zegt:      ja (doorgegeven; in de bouwchat 11 nov: *"Ja, door met stap e"*). **Gebouwd 11 nov:**
                 `tools/zygor_watch.py`, stap 16 van de ochtendronde. Nulmeting: Midnight Zygor 9.6 (717 gidsen), Forever
                 1.6 (104). `--selftest` bewijst dat een wijziging gezien wordt. Af zodra hij de eerste echte update meldt.

### Forever: de tooltip zegt voor welk beroep een item een ingrediënt is
- Voor wie:      N + V (wie twijfelt bij de verkoper: verkopen of bewaren?)
- Moment:        elke keer dat je met je muis op een item staat (tas, verkoper, loot)
- Spel:          Forever (Midnight alleen als Rob het apart vraagt)
- Bron:          Rob, 11 nov (Stringy Wolf Meat bij de verkoper; Meaty Bat Wing leek Leatherworking)
- Bouwt op:      de tooltip-haak van ForeverQuestHint/ForeverToolGuard, `ns.ForeverMyProfessions`
- Data:          Blizzards DB2 (SkillLineAbility + SpellReagents + ItemSparse), 524 items, 7 KB, gegenereerd
- Vindbaar:      staat er vanzelf; `/mh usedfor` om te zien wat hij besloot
- Werk:          klein
- Site:          ja, één zin bij de Forever-functies (bij de volgende release)
- Rob zegt:      ja (sparring-chat: *"Ja, laat bouwen"*; bouwchat 11 nov: *"Ja, met probe-fix"*). **Gebouwd 11 nov:**
                 `Modules/ReagentUse.lua` (eerst `ForeverReagentUse.lua`) + gegenereerd `ForeverReagentData.lua`
                 (`run forever_reagents --emit`). **AF in Forever 11 nov** (Rob: *"Ja, af"*, na Linen Cloth, Stringy Wolf
                 Meat, Hearthstone en `/mh usedfor`). Niet gezien: de grijze regel en Copper Ore.
                 **Midnight erbij, 11 nov** (Rob: *"Kunnen we dit ook in de midnight versie bouwen?"* → meten → *"Ja,
                 bouw het"*): `MidnightReagentData.lua` (`--emit --midnight`), alleen Midnight-recepten, 296 items.
                 Wacht op Robs test in Midnight.

### Forever: stop-spell voor de Paladin (klein) en het groepspaneel (midden)
- Voor wie:      N + V in een groep
- Moment:        in een dungeon met een groep
- Spel:          Forever
- Bron:          Rob, 11 nov (via de sparring-chat: "zo'n mooie partyframe … kunnen we ook zoiets in deze maken"; koos
                 "Klein en midden")
- Bouwt op:      klein: `ForeverMacros.lua`; midden: `PartyTargets.lua` (nu alleen retail)
- Data:          spell-ids GEMETEN in wago (853 Hammer of Justice, 1152 Purify)
- Vindbaar:      klein: `/mh macros`; midden: `/mh partytargets`
- Werk:          klein: klein; midden: middel, en deels alleen in een echte groep te testen
- Site:          later, met het paneel
- Rob zegt:      ja. Bouwchat 11 nov: *"Ja, alleen klein"* (midden later, eerst meten). **Klein gebouwd 11 nov:** twee
                 Paladin-macro's (Hammer of Justice = stun, Purify). Midden: open. Aparte vraag voor later: krijgt het
                 Midnight-paneel ook "stop-spell op het doelwit" (nu purge)?

### CurseForge-plaatjes: echte screenshots op één vaste achtergrond
- Voor wie:      wij (CurseForge-pagina en de site); spelers zien alleen het resultaat
- Moment:        als Rob nieuwe screenshots maakt (hooguit 4-6, actueel)
- Spel:          Midnight en Forever
- Bron:          Rob, 11 nov (via de sparring-chat; achtergrond "Nummer 2" uit ComfyUI)
- Bouwt op:      niets in de addon; los gereedschap via de voordeur
- Data:          Robs eigen screenshots + `E:\ComfyMCP\output\mh_cf_achtergrond_00002_.png` (kopie in de mediamap)
- Vindbaar:      `run cf_media --help`; map `E:\MidnightHelper-media\` (input, output, shots.txt)
- Werk:          klein
- Site:          ja, de plaatjes zelf
- Rob zegt:      ja (in de bouwchat 11 nov: *"Ja, bouw het"*). **Gebouwd 11 nov:** `tools/cf_media.py`, lettertype Cinzel
                 (OFL 1.1, GEMETEN in de naamtabel van het font). **AF 11 nov:** Robs zes screenshots erdoor gehaald
                 (`E:\MidnightHelper-media\output\01-06`), 5 en 6 opnieuw gemaakt op level 8; Rob: *"Ja, goed zo"*.
                 Uploaden naar CurseForge en site doet Rob zelf.

### Forever: "je hebt geen Hearthstone" bij een reis over het water
- Voor wie:      nieuweling (Rob: "zeker in het begin")
- Moment:        als de pijl je over het water stuurt en je geen Hearthstone draagt
- Spel:          Forever
- Bron:          Rob, 11 nov, Paladin zonder Hearthstone (verkocht voor geld en tasruimte) in Tirisfal
- Bouwt op:      de reisplanner (`ForeverTravel.lua`) en het wapenvenster
- Data:          GEMETEN — item 6948 "Hearthstone" en de naam per taal in de Forever-DB2 (1.60.1.70888)
- Vindbaar:      vanzelf: chatregel + venster; `/mh travel` als diagnose
- Werk:          klein
- Site:          ja, als het uit is (`docs/SITE_SEIN.md`)
- Rob zegt:      ja (*"bouw het maar"*, 11 nov). Gebouwd 11 nov. Wacht op een test (TESTLIJST 11 nov).

### Forever: Enhancement Shaman blijft op Strength (reparatie)
- Voor wie:      Shaman-spelers in Forever met Mental Dexterity
- Moment:        bij een questbeloning
- Spel:          Forever
- Bron:          content-wachter 11 nov (Blizzard blue post 6 nov + hotfix 10 nov)
- Bouwt op:      `ForeverMainStats.lua` / `ForeverQuestHint.lua`
- Data:          via zoekmachine gelezen op meerdere sites, niet in de client
- Vindbaar:      vanzelf (de quest-tip)
- Werk:          klein
- Site:          nee
- Rob zegt:      ja (*"Ja, repareer"*, 11 nov). Gebouwd 11 nov. Wacht op een test (TESTLIJST 11 nov).

### De regisseur: één overzicht van alles
- Voor wie:      Rob (één bericht per dag in plaats van zes) en alle chats
- Moment:        elke ochtend om 06:20, en op de pc met `/regisseur`
- Spel:          allebei
- Bron:          Rob, 11 nov, in de brainstorm-chat: *"Ja op alle drie, bouw de regisseur maar"*; hier: *"Ja, bouw hem"*
- Bouwt op:      `docs/REGIE.md` (het geheugen), plan deel 8, de andere wachters
- Data:          n.v.t. (hij meet in de repo's)
- Vindbaar:      blok 0 van `docs/REGIE.md`; CLAUDE.md ochtendronde
- Werk:          klein
- Site:          nee
- Rob zegt:      ja (11 nov). **Gebouwd 11 nov:** routine `trig_017LQWJNvptK8hWLuByuEDzg`, recept `regisseur`. Af na een
  proefrun die de dingen vindt die waar zijn, en een eerste gewone ochtend (12 nov).

### De vier ochtendwachters kijken ook naar Forever
- Voor wie:      wij (de addon zegt veel over Forever, en geen wachter keek ernaar)
- Moment:        elke ochtend
- Spel:          Forever
- Bron:          brainstorm-chat 11 nov, Rob daar: *"Ja, voeg Forever toe aan de wachters"*; hier: *"Yeah"*
- Bouwt op:      de vier wachters en `docs/WATCHER_FOREVER.md`
- Data:          n.v.t.
- Vindbaar:      in de vier wachterbestanden, onder **Forever:**
- Werk:          klein
- Site:          nee
- Rob zegt:      ja (11 nov). **Gebouwd: 9ca5e32** + de vier opdrachten aangevuld. Af zodra de inhaalronde van 11 nov
  en de run van 12 nov allebei een Forever-deel hebben.

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
