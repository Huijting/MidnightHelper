# Midnight Helper — waar we staan

## ▶▶ 26 nov (Bouwchat 26-11): reisplanner STAP 4 GEBOUWD (`/reload`) — rij: "na je dood", dan rare-model + loot

- ForeverTravel.lua: ritdetectie (ticker 1 s): bewegen terwijl GetUnitSpeed 0 binnen 120 yd van een boot/zeppelin-eind =
  vertrek (GetServerTime, per realm, laatste 6 in ns.db.foreverDepartures[realm][linkId..eind]); stilstand 5 s aan de
  andere kant = ritduur (foreverRideTimes). Periode = kleinste gat 1-30 min; ns.ForeverLinkCost = wachten tot het volgende
  vertrek + eigen ritduur, anders COST. /mh travel: regel "boats/zeppelins learned". AFGELEID: periode, 1,5 min
  gemiddelde wachttijd.
- Liften NIET gebouwd: DB2 TransportAnimation heeft timing maar geen plek → bewust weggelaten.
- /mh walkrec on|off|clear (onvermeld meetgereedschap): punten elke 4 yd in ns.db.foreverWalkRec[map]; routeert nog niets.
- flight_test 33/33.

## ▶▶ 26 nov (Bouwchat 26-11): klikkaart GEBOUWD (HERSTART: nieuw bestand ClickCard.lua) — daarna stap 4, dan "na je dood"

Rob: *"Het moet grafisch tof zijn"*; keuze *"Ik volg jouw advies."* (één grote laag + strook, Alt/heal-laag standaard);
*"Wordt dan het plaatje automatisch dynamisch aangepast?"* → ja.
- Modules/ClickCard.lua (beide toc's): leest LIVE het actieve DandersFrames-profiel (ClickCast:GetClassData().profiles[
  GetActiveProfileName()].bindings, velden die MH zelf schrijft; DF 6.1.0-bron), anders MH's indeling (ForeverClickRows /
  ClickLayoutRows) met regel FCARD_SOURCE_MH. Grote laag = vastgehouden modifier (MODIFIER_STATE_CHANGED) > aangeklikte
  pil > laag met de meeste spells. Muis = ellips via TempPortraitAlphaMask + CreateLine-lijntjes (ook naar het wieltje).
  Strook: andere lagen + ForeverClickMissing (grijs, "level N"/"talent"/"via quest", AFGELEID: geen trainer + geen
  talent = quest). Ticker 2 s met signatuur; schakelaars in ForeverClickCast verversen meteen. See-through 100/85/70/50,
  FCARD_FADE_SW (uit). Openen: /mh clickcard [why], Quiet helpers, Midnight PlayCardWindow (eigen pool _cardBtn).
- card_test 14/14, click_test 25/25. Niet in het spel gezien: maskers/lijnen in Forever (pcall-bewaakt).
- Wachtrij van Sparring: reisplanner stap 4, daarna "na je dood" (afstand lijk/Spirit Healer, resurrection sickness meten).

## ▶▶ 26 nov (Bouwchat 26-11): reisplanner STAP 3 GEBOUWD (`/reload`) — daarna klikkaart, dan stap 4

- ForeverTravel.lua: lopen = afstand × DETOUR 1,4 / eigen run-snelheid (GetUnitSpeed, 7-21 yd/s; AFGELEID factor) via
  WalkFactor op elke loop-kant; vluchttijd eigen meting (hooksecurefunc TakeTaxiNode → landing, ns.db.foreverFlightTimes
  "van>naar", gemiddeld) wint van yd/30. Routepaneel MidnightHelperForeverRoutePanel (zelfde Plan als de pijl, ticker 2 s,
  icoon/tekst/minuten, totaal + afstand, kruisje per doel, FROUTE_SW aan), ring + "MH: fly here" op TaxiButton<slot>
  (nooit TakeTaxiNode). /mh travel: loopsnelheid, getimede vluchten, paneelregel (fouten zichtbaar).
- FlightMapHint.lua (Midnight): GetAllTaxiNodes(GetTaxiMapID()) i.p.v. zonder uiMapID.
- flight_test 30/30. Rob koos de klikkaart (*"Ik volg jouw advies."*) → nu bouwen, live met DF-profiel (zie Sparring).

## ▶▶ 26 nov (Bouwchat 26-11): /mh clickheal — 2 fixes uit Robs screenshot; klikkaart-ontwerp wacht op Robs keuze

Rob via Sparring: Alt-klik werkt (*"alt-click heb ik al geprobeerd en dat werkt dus"*). Fixes: (1) "not learned yet"
noemde Middle Mouse = Healing Touch terwijl die op Alt+Middle stond: met "keep left-click" tellen alleen de Alt/Ctrl-vakken,
en een vak waarvan je de spell al kent is niet "not learned"; (2) "…5187eep": "|k" is een chat-escape → signatuur nu
" /keep" / " /heal". Klikkaart (*"Het moet grafisch tof zijn"*): mock `<scratchpad>/clickcard_mock.png` naar Sparring;
pas bouwen na Robs keuze. Reisplanner stap 3 staat stil tot daarna (nog niets gewijzigd).

## ▶▶ 26 nov (Bouwchat 26-11): reisplanner STAP 2 — rare-in-zicht-venster GEBOUWD (`/reload`)

- ForeverRares.lua (onderaan): NAME_PLATE_UNIT_ADDED / PLAYER_TARGET_CHANGED / UPDATE_MOUSEOVER_UNIT; telt als
  UnitClassification rare/rareelite óf npc-id (UnitGUID) in FOREVER_RARES_ALL/_WORTH, levend, aanvalbaar; 10 min per rare.
  Venster MidnightHelperForeverRareAlert (RegisterMidnightDialogPopup, verplaatsbaar, 60 s), knoppen: Target = secure
  macro /targetexact op UIParent, alleen buiten gevecht over het venster gelegd (nooit eraan geankerd), Show in Find
  (ns.ShowForeverFind("rare", "z<map>")), Waypoint. Schakelaar FRALERT_SW (aan), /mh rares [why|test|on|off].
- AFGELEID: UnitGUID/UnitName zijn voor nameplates in Forever leesbaar (anders: geen Target-knop, wel het venster).
  rare_test 15/15.

## ▶▶ 26 nov (Bouwchat 26-11): Forever-reisplanner "leren van Polestar" — STAP 1 van 4 GEBOUWD (`/reload`)

Rob via Sparring: *"Ik volg sowieso jouw advies, dus ik zeg ja, denk ik. En gaan we door tot jullie eigenlijk klaar
zijn."* Volgorde: 1 flight-point-kennis, 2 rare-venster, 3 echte seconden + stappenpaneel + vliegkaart, 4 transport/liften/
Undercity. 🔴 Licentie: Polestar GPL-3 → alleen de METHODE gelezen, geen code/tabellen/getallen overgenomen.
- ForeverTravel.lua: leren bij TAXIMAP_OPENED via GetAllTaxiNodes(GetTaxiMapID()) ÉN de slot-lijst (NumTaxiNodes/
  TaxiNodeGetType/TaxiNodeName: CURRENT/REACHABLE/UNREACHABLE = bekend; naam → node via clientnamen + Engels, per kant);
  een geziene vliegkaart = dat continent "seen", ontbrekende punten vergeten. Ook ERR_NEWTAXIPATH (UI_INFO_MESSAGE) en
  landing (PLAYER_CONTROL_GAINED na UnitOnTaxi) → master binnen 60 yd. Wereldkaartlijst alleen nog voor namen
  (GEMETEN door Rob: alles "discovered").
- Nighthaven 62 (A) / 63 (H), druid-only, altijd bekend voor druids; paden 62→27, 63→22 (DB2 315/316). x,y AFGELEID uit de
  wereldpositie via nodes 49/69; Wowhead 11798/11800 binnen 0,2 (GEMETEN). StaticGraph-cache per kant + class.
- Eén advies: de start die een plan koos blijft 10 min staan tenzij een andere ≥ 1,5 min sneller is (SWITCH; de
  Hearthstone-cooldown liet het plan heen en weer flippen). /mh travel: taxi-API-regel + "seen" per continent.
- Open voor stap 3: FlightMapHint.lua:82 (GetAllTaxiNodes zonder uiMapID).

## ▶▶ 26 nov (Bouwchat 26-11): klik-heals op DandersFrames in Forever — GEBOUWD, wacht op test (HERSTART: nieuw bestand)

Rob via Sparring: *"2 ja"* (*"Kunnen wij dat in Forever ook? En zo niet, waarom niet? En kunnen we het wel maken?"*).
- Waarom de Midnight-versie niet werkte (GEMETEN): ClickCast.lua staat niet in de Forever-toc; retail spec-id's en
  spell-id's. DandersFrames _forever_ = v6.1.0 met dezelfde import + ClickCast-functies; Core/API.lua:309-328: import mét
  profielnaam overschrijft dat profiel (geen kopieën) → automatisch bijwerken is veilig.
- Nieuw: Modules/ForeverClickCast.lua (Camelot-toc na ForeverSmartBuff). Per class (Druid/Priest/Paladin/Shaman) een
  healer-indeling met per klik een lijst Engelse namen; de eerste die het character kent wint (ns.ForeverKnownSpell =
  hoogste rank, ids uit ForeverSpellIds.lua, alle 34 namen GEMETEN aanwezig). Binding draagt de CLIENTnaam. Dubbele
  spells overgeslagen. Schakelaar FCLICK_SW (uit) + FCLICK_KEEP_SW (aan: L/R = target/menu, heals op Alt/Ctrl).
  SPELLS_CHANGED/login → stil bijwerken als de indeling veranderde (signatuur), buiten gevecht. Uit = Undo (eerste
  "vóór" bewaard). /mh clickheal [why|on|off|heal|offheal] (foreverOnly in de lijst).
- AFGELEID, niet in het spel: klik castt de hoogste rank; GetCurrentSpec geeft in Forever een index; Forever-vormnamen
  in de de/fr-teksten niet nagemeten. click_test 25/25 (nep-DF).

## ▶▶ 26 nov (Bouwchat 26-11): Midnight-commando's weg uit Forever — GEBOUWD, wacht op test (`/reload`)

Rob via Sparring: *"3 ja"* (*"heel veel commando's die we alleen maar kunnen gebruiken in de Midnight versie"*).
- CommandList.lua: MIDNIGHT_ONLY (63 woorden) zet `midnightOnly` op die rijen; ns.CommandItemShown verbergt ze in
  Forever (lijst, Forever-venster, NavSearch). ns.IsMidnightOnlyCommand + Core.lua bovenaan de slash-handler: in Forever
  zegt zo'n commando CMD_MIDNIGHT_ONLY_FMT (7 talen) i.p.v. niets.
- GEMETEN per commando (scratch cmd_games.py): elke ns-functie die de Core-tak aanroept staat alleen in bestanden die niet in
  MidnightHelper_Camelot.toc staan. Beide houden (tak raakt een Forever-bestand): o.a. enchant, board, partytargets,
  play, survey, move, block, mark, arrow, bar, fps, mbuff, cleanup. Na de hand nagelopen: skip, mouse, goto, lang, new,
  pickup, alttip, thanks (Core of Forever-bestand). Geen tweede Forever-tak voor die woorden in Core (grep).
- cmd_test 13/13: 39 rijen in Forever, 63 alleen Midnight.

## ▶▶ 26 nov (Bouwchat 26-11): 5 instellingen in Forever Quiet helpers — GEBOUWD, wacht op test (`/reload`)

Rob via Sparring: *"Even kijken. 1 ja. 2 ja. 3 ja."* (1 = deze, 2 = klik-heals Forever, 3 = Midnight-commando's verbergen).
- ForeverOverview QUIET (kopje Screen): missing buff icon, upgrade in je tas, pijlgrootte (nieuw: `cycle`-rij, klik =
  volgende maat, rechtsklik = vorige; FOV_TIP_CYCLE 7 talen), meters, minimap-icoon, quick bar + zoekwoorden.
  GEMETEN dat elk in Forever werkt: MissingBuff.lua:244 Forever-tak, PickupUpgrade.lua:129, NativeArrow.lua:984/1013,
  QuickBar.lua:357, Broker.lua:412.
- Tekstgrootte NIET toegevoegd: GEMETEN dat geen Forever-bestand ns.MHScalableFont gebruikt (grep; positieve controle 51
  retail-bestanden wel) → in Forever-vensters doet hij niets.
- Volgende: opdracht 3 (commando's), dan 2 (klik-heals).

## ▶▶ 26 nov (Bouwchat 26-11): Move secret-veilig + castbalken in Move + cast-waarschuwing vindbaar in Forever — GEBOUWD, wacht op test (`/reload`)

Rob via Sparring (Forever, BugSack MoveMode.lua:144 "attempt to compare a secret number value", el =
MidnightHelperCombatSafety): *"Ik kon dus niet die bars verplaatsen"* → *"ja doe maar, en waarom kan ik het niet zoeken ?"*.
Versie: Rob wil geen haast met 5.10.1 (*"misschien in de 5.11 versie"*); release alleen op zijn letterlijke zin.
- MoveMode.lua: `PlainAlpha` (pcall + issecretvalue) i.p.v. f:GetAlpha() vergelijken/opslaan. Vervaagd of secret →
  alpha 1 tijdens Move; terug: eigen waarde, of 0 als hij secret was (de volgende SetAlphaFromBoolean beslist). Ook
  ActionPrompt gebruikt SetAlphaFromBoolean en staat in ELEMENTS: dekt deze fix ook (GEMETEN: grep; andere GetAlpha
  in BriefNotice/MidnightToast zijn eigen fades, niet secret, AFGELEID).
- Nieuw element MidnightHelperCombatSafetyBars (MOVE_EL_SAFETY_BARS, 7 talen) met `preview` =
  ns.CombatSafetyBarsPreview (3 voorbeeldbalken, alleen als balken aan). CombatSafety.lua: de balkenstapel kreeg eigen
  OnDragStart/Stop (positie in ns.db.ui.combatSafetyBarsPos, zelfde als slepen van een balk).
- ForeverOverview.lua QUIET: kopje SET_SEC_COMBAT met de 4 SET_CS_*-schakelaars + actie SET_CS_PREVIEW
  (ns.TestCombatSafety); QUIET_WORDS zodat "cast bars" ze vindt. Teksten = die van de Midnight-instellingen (al vertaald).
- Offline: move_test 12/12 (scratch, nep-secret die bij vergelijken een fout geeft). 🔵 De lijst "andere instellingen die
  in Forever werken maar daar niet te vinden zijn" gaat naar Sparring (niet gebouwd).

## ▶▶ 26 nov (Bouwchat 26-11): flight paths in de Forever-reisplanner + "zo kom je er" op het class-questkaartje — GEBOUWD, wacht op test (`/reload`)

Rob via Sparring (Druid 14 bij de zeppelintoren, pijl 4405 m naar Turak in Thunder Bluff): *"Waarom alleen maar een pijl
die kant op en niet hoe ik kom?"* → voorstel → *"Ja, stuur maar."*. Mag mee in 5.10.1 (niet getagd).
- Meting: `docs/forever/VLUCHTEN_2026-11-26.md` (mh-research). GEMETEN: geen zeppelin Org ↔ TB (DB2, 18 nov); 65
  flight points + 286 vluchten (DB2 71139, Flags 0x1 A / 0x2 H); 30 yd/s uit 12 echte vluchten van Rob; API in Blizzards
  forever-UI-bron (GetAllTaxiNodes state 0/1 bij de flight map, GetTaxiNodesForMap met isUndiscovered). AFGELEID: zone
  x,y uit wereldpositie (64/65 binnen 0,44 kaart-% van Wowhead); Classic-regel "alleen INTO bekende punten".
- ForeverTravel.lua: FLIGHT_NODES/FLIGHT_PATHS; flight masters van je kant zijn punten in StaticGraph, vluchten worden in
  Plan toegevoegd alleen naar punten die je kent (KnownTaxi: geleerd bij elke flight map in `ns.db.foreverTaxiKnown`
  per character + de wereldkaartlijst als die zichtbaar filtert). Opeenvolgende vluchten = één stap ("fly to …").
  Tijdens een vlucht (UnitOnTaxi) geen plan. `/mh travel` noemt de bekende flight points en waar MH ze van weet.
  Hearthstone-cooldown zat er al in (WaitMin).
- `ns.ForeverWayLine` → class-questkaartje (nieuwe regel onder de plek) + chat bij Show the way. Ververst ook bij
  ZONE_CHANGED(_NEW_AREA)/TAXIMAP_CLOSED. Nieuwe sleutels FTRAVEL_WALK_FMT, FTRAVEL_FLY_FMT, FTRAVEL_FLY_IN_FMT (7 talen;
  it alleen WALK, Forever heeft geen itIT-pack).
- Andere "Show the way"-knoppen (punt 3): alle lopen via NativeArrow + ForeverTravelNeedsLink, dus de pijl vliegt nu
  overal mee: ForeverTrainer, Vendors, Weapons, Dungeons, DungeonQuests, Rares, RestXP, QuestieDB, Overview (Find,
  dungeons). Een zin "The way there" hadden al: Trainer, Weapons, Dungeons, DungeonQuests, Overview. Zonder zin (alleen
  de pijl): Vendors, Rares, RestXP, QuestieDB.
- Offline: flight_test 19/19, trainroute_test 6/6 (scratch). 🔵 Open: (a) of GetTaxiNodesForMap in Forever alleen
  ontdekte punten geeft: Robs `/mh travel` beslist; (b) Classic- of moderne regel voor vliegen dóór onbekende punten
  (testvoorstel in VLUCHTEN-verslag); (c) bijvangst retail: `Modules/FlightMapHint.lua:82` roept GetAllTaxiNodes() zonder
  uiMapID aan (verplicht volgens de docs), niet gerepareerd.

## ▶▶ 26 nov (Bouwchat 26-11): Oath of Light duurt 1 uur — tekst GEREPAREERD, gaat mee in 5.10.1 (`/reload`)

Rob via Sparring: *"Ja, ik zeg ja op 1 en 2."* Bron: content-wachter 26 nov (Forever-hotfix 25 nov "Oath of Light
duration increased to 60 minutes").
- GEMETEN: Wowhead Forever-tooltip 1328548 "Swear an Oath … for 1 hour". DB2 71139 SpellMisc DurationIndex 5 =
  SpellDuration 300000 ms: de hotfix staat niet in de DB2-bestanden (server-hotfix), dus DB2 is hier niet de bron.
- "It lasts 5 minutes" → "1 hour" in alle 8 bestanden (ForeverHowToPlay.lua:987 + 7 packs, Holy Paladin stap 1).
  Andere spelerstekst over de duur: geen (grep "Oath of Light" + de clientnamen in Modules/Locales).
  Onderzoeksnotitie `docs/forever/PALADIN_ROLES_2026-11-17.md` kreeg een ⚠️-regel. `KEYBLOCK12_PALADIN.md` noemt nog
  "5 minuten" als reden om Oath uit het 12 × 4-blok te laten: met 1 uur geldt die reden sterker, dus niet gewijzigd.
- Ook: handoff gesplitst (1754 → 909 + index; kop 21 nov avond en ouder naar het archief) en
  `event_snapshot --write` (forever 71091 → 71139, positieve controle ADDON_LOADED in alle drie).
- OpenXP (Forever, uit op alle 20 characters) 2.0.4 → 2.0.7: zijn eigen lijst in `UI/Welcome.lua` gelezen, uitleg
  naar Sparring. NIET aangezet.

## ▶▶ 26 nov (Bouwchat 25-11): trainerpijl op reistijd — GEBOUWD, wacht op test (`/reload`)

Rob via Sparring (Druid in Orgrimmar): *"… 4493 METER VERDEROP STUREN, dat moet beter kunnen haha"*.
- ForeverTrainer.lua Nearest(): eerst `ns.ForeverTravelMinutes` (nieuw, ForeverTravel.lua: plan-minuten of loopkosten) voor
  elke kandidaat op elk continent, laagste wint; rechte lijn alleen als terugval. 5e/6e return min/how; HowFar() → "N min"
  (FTRAIN_MIN_FMT, 8 talen) in venster, tooltip, cap-melding, chat; chat noemt ook de route (FWEAP_ROUTE_LABEL +
  ForeverTravelSentence). `/mh trainer check`: "chosen: … by travel time …" + "route: …" (ns.ForeverTrainerLastChoice).
  Distance(nil)-val op 3 plekken gedicht (andere continent = geen yards).
- ForeverTravel TELEPORTS moonglade: dest = Loganaar 1450 52.5,40.5 (AFGELEID landing; geleerd na de eerste cast).
- ForeverTrainerSpots: Loganaar 12042 (N), Jannos Lighthoof 8142 (H, Feralas), Golhine 9465 (A, Felwood) + FIELD-tabel 15
  veldtrainers. Bron Wowhead Forever-tooltips (GEMETEN), HandyNotes_ClassTrainers alleen vergeleken (ARR, niets
  gekopieerd); uiMaps GEMETEN. Weggelaten: Zayus 5994 ("High Priest"), Fahrad 6707 ("Grand Master Rogue").
- Orgrimmar heeft geen Druid-trainer (HandyNotes r.166-192, Sparring) → Thunder Bluff was correct, alleen ver.
- trainroute_test 6/6 (scratch). ⚠️ Plan() cachet 1 s per doel: Nearest rekent ~20 plannen bij een klik (geen OnUpdate).

## ▶▶ 26 nov (Bouwchat 25-11): Fable-controle "Your race" verwerkt — klaar voor 5.10.1 (NIET getagd)

Rob op "Fable vóór 5.10.1": *"ja"*. 13 punten van Sparring/Fable; zelf GEMETEN: Rogue-Eureka breekt Stealth niet
(Attributes_1 0x20), Skysight bewegend 14 / Read Leyline 15 (SpellInterrupts), Purification Potion level 47, Ghost Wolf en
Travel Form +40%, Cheetah +30%, Herbalism esES Botánica / esMX Herboristería. Code: Walk on Air in Druid-Shift-E (beide
indelingen), alle 5 Eureka!-id's in ForeverMacros RACIALS, 13462 in de item-preload. Tekst: 19 regels herschreven,
SKY_C_HUN nieuw, GNO_C_RAGE/_ENERGY en UND_C_PAL weg (66 FRACE-sleutels). Details: `docs/forever/RAS_FEITEN.md`.
🔵 Open: fr "Cooldown" → "recharge" pack-breed (nu alleen in het FRACE-blok). 5.10.1 = 133bfa6 + 6bc2d2d + deze commit;
tag pas op Robs letterlijke zin.

## ▶▶ 26 nov (Bouwchat 25-11): "Your race" in How you play, tab Start — GEBOUWD, wacht op test + Fable (`/reload`)

Rob via Sparring: *"… als extra info vermelden bij de klas"* → *"ja , ik zag bv ook dat deze druid ook Cultivation heeft :)"*.
Rob wil 5.10.1 = dit + 133bfa6 (Gear check), na Sparrings Fable-ronde.
- ForeverHowToPlay.lua: RACE_INFO (raceID → base-sleutels + class-regels), RaceSection(token) via UnitRace; kind "race",
  tab start, achteraan Start. Kop "**For you as a <class>:**" alleen als er class-regels zijn (Priest altijd:
  FRACE_PRI_OWN verwijst naar "Your race's own spells"). `<S:EUREKA>` → Eureka! van die class. Tokens via
  ns.ForeverWeaponAdviceTokens, toetsen via LiveKeys (Shift-E).
- GEMETEN (DB2 71091): alle spell-id's, ras-id's 95/96, Plainsrunning 2/5/60, Travel Form 5419 aura 31 +40% (783 zelf
  niets), Charged = 3 id's met andere Duitse namen → beschreven. Register `docs/forever/RAS_FEITEN.md`.
- Vertalingen 7 talen door mh-writer (zie commit); race_test (scratch) controleert elk ras × class, sleutels en tokens per pack.

## ▶▶ 26 nov (Bouwchat 25-11): Gear check enchants — Legs + live bijwerken — GEBOUWD, wacht op test (`/reload`)

Rob via Sparring (screenshot Druid, geen Legs): *"Ik mis hier volgens mij mijn [legs] … kan de [gear] check enchants ook
dynamisch updaten? Want nu moest ik hem eerst weer mijn karakter uitdoen en toen weer aandoen."*
- GEMETEN (DB2 1.60.1.71091, elke ENCHANT_ITEM-spell × SpellEquippedItems): legs 78 (armor kits, ook chest/robe/hands/
  feet; arcanums), head 52, shoulder 22, waist 3 (tinkers), wapens 76 (ook scopes). Geen enchant-spell zonder
  SpellEquippedItems.
- ForeverEnchantCheck SLOTS: + Legs (gewoon vakje, telt mee in Do this now) + Head/Shoulder/Waist/Ranged met `onlyOn`
  (alleen als er iets op zit; "no enchant" daar = ruis voor de meeste spelers — keuze bouwchat, AFGELEID). Volgorde =
  paperdoll.
- Live: UNIT_INVENTORY_CHANGED("player") + PLAYER_EQUIPMENT_CHANGED → Fill nu en 0,5 s later; in een gevecht `pending`,
  dan bij PLAYER_REGEN_ENABLED. Welk event in Forever vuurt bij een enchant op een gedragen item = AFGELEID (classic-API),
  `/mh enchant` noemt het laatste ("last live refresh: …").
- ench_test 30/30 (was 24). Mogelijk een 5.10.1 als Rob dat wil.

## ▶▶ 25 nov (Bouwchat 25-11): RELEASE 5.10.0 (Rob via Sparring: *"breng 5.10.0 maar uit 🙂 , mee eens ?"*)

✅ STAAT OP CURSEFORGE (GEMETEN, files-API): 9816083 `MidnightHelper-v5.10.0.zip` (12.0.7/12.1.0/12.1.5/12.1.7) en
9816110 `MidnightHelper-v5.10.0-forever.zip` (1.60.1), beide releaseType 1 (Release), status 4. Tag v5.10.0 = 154e195;
run 45688975346 groen; GitHub-release 2 zips + release.json. SITE_SEIN op "staat op CurseForge".

Gewone release, geen beta, beide games. Inhoud v5.9.1..55ba32a (35 commits). Beide toc's 5.10.0; Changelog.lua +
CHANGELOG_5100_1.._7 (enUS); `RELEASE_NOTES.md` = `docs/CURSEFORGE_5.10.0.md` (GEMETEN byte-gelijk, 73 regels, 4131
bytes), zonder de beta-zin (geen betas sinds 4.14.0-beta2), met "restart the game once" (nieuwe bestanden AltProfTip.lua
+ ForeverEnchantCheck.lua; nieuw in de notes, geen eerdere gewoonte gevonden). CURSEFORGE_DESCRIPTION.md: tabs, Which
weapon?, gear-regel met spell damage/enchant, Gear check enchants (Forever), andere characters in tooltips (beide) —
🔵 Rob plakt hem. SITE_SEIN: 7 regels → getagd. NIET in het spel getest: bank-vinkje gear-regel, "you can make this
yourself", spell/healing-vergelijking, Warlock-stats (offline wel).

## ▶▶ 25 nov (Bouwchat 25-11): Warlock-stats = keuze (a) — GEBOUWD, wacht op test (`/reload`)

Sparring (a): *"Voor alle drie de richtingen hetzelfde: spell damage eerst, dan Intellect en Spirit even belangrijk.
Stamina noemen we niet meer als hoofd-stat."* Rob: *"Ik volg jouw advies."* → open punt Warlock-Stamina GESLOTEN.
- ForeverMainStats WARLOCK klasse-rij + BY_TREE [1]/[2]/[3] = {INTELLECT, SPIRIT}, `equal`, lead "spell", spellW 1,
  stamTie true. Bronnen in de comment: dev notes 3 nov (demon 2 HP per Stamina, was 7,5), Life Tap 1454 schaalt met Spirit
  (DB2 + Blizzard 24 sep/7 okt), alle gidsen spell power eerst (BRON, niet door mij nagemeten).
- Tooltip-rekensom (AFGELEID uit Score()): was klasse-rij Int 1 + Stamina 0,5, Demo/Destro Int 1 + Stamina 1, Affliction
  Spi 1 + Int 1. Nu overal Int 1 + Spi 1 + spell damage ×1; Stamina telt alleen bij gelijke score. Gevolg: een
  Stamina-item zonder Int/Spi/spell damage heet niet meer "better"; een Spirit-item kan dat nu wel.
- FWADV_WLK_7 (8 talen): "Stamina … more health, but it only decides between two equal items: spell damage, Intellect and
  Spirit come first." wadv_test 107/107, gearench_test 25/25.

## ▶▶ 25 nov (Bouwchat 25-11): "How you play" in tabbladen — ✅ GETEST door Rob (5d0f24e)

✅ Rob via Sparring (Druid 12 Feral, 2 screenshots): tabs + kopjes te zien, laatste tab blijft na `/reload`, `/mh howtotabs
mine` = "DRUID: OK, role lines 72/72, total 127 lines, 0 double … nothing missing". *"Wat minder druk voor mijn gevoel."*
Niet apart genoemd: alle tabs langs, kopje klikken, Your direction/All roles, Shift+scroll, andere ingangen.
🔴 BESLIST: NIET inkorten (Rob: *"dan gaan we misschien weer heel veel informatie missen"*) — het open punt "blokken 10-13
regels" hieronder is daarmee dicht.

Rob via Sparring: *"zo'n lange lap tekst … Met tabbladen van mijn part"* → *"Ja, je mag het zo sturen."*
- ForeverHowToPlay.lua: `ns.ForeverHowToSections` geeft elk blok een `tab` (start/keys/gear/group/levels, volgorde
  `ns.FOREVER_HOWTO_TABS`) en sorteert erop. Klasse-blokken op hun ENGELSE titel (ClassTab); COMMON via COMMON_TAB.
  Rol-teksten geknipt op hun 3 vette subkopjes (RoleChunks; GEMETEN 84 = 28 rollen × 3 in alle 8 bestanden): intro +
  volgorde + fouten → Start, per 10 levels → Levels. Andere vorm = heel laten + `uncut` gemeld. Nieuwe kinds: `plan`
  (Group), `weapon` en `stats` (Weapon & stats; stats = `ns.ForeverStatLines` uit ForeverDoNow). Dir-blok → Weapon & stats.
- `ns.ShowPlayCardWindow`/`Toggle` openen nu de overzichtspagina "play" (oude losse venster = reserve zonder overzicht).
- ForeverOverview.lua FillPlayPage: links eerst de tabs (gekozen = goud + balk `row.sel`), dan 8 px lager de kopjes van
  dat tabblad (ingesprongen, klik = springen). `f.playTab` + `ns.db.foreverPlayTab` onthouden.
- `/mh howtotabs [mine]` (Core.lua) → `ns.ForeverHowToTabsReport`: per klas per tab de blokken + regels, "role lines
  X/Y" (moet gelijk), dubbele lange regels (rol-tegen-rol telt niet). Let op: weapon/stats/dir zijn van JOUW character,
  ook in de regels van andere klassen.
- tabs_test (scratch) 153/153: 9 klassen × 8 talen, rolregels vóór = na, elk blok een tab, gesorteerd.
- Open: blokken "Levels 1-10" zijn 10-13 regels (spec zei ±5): inkorten = herschrijven = vraag aan Rob. (Beslist: niet
  inkorten, zie boven.)

## ▶▶ 25 nov (Bouwchat 25-11): spell-rekensom AF met Robs 4 dumps — healing, scholen, mp5 (`/reload`)

GEMETEN door Rob (GetItemStats, 2e run; 1e run nil = item nog niet geladen): 7049 SPELL_HEALING_DONE 15 + SPELL_DAMAGE_DONE 5;
19395 SPELL_HEALING_DONE 66 + MANA_REGENERATION 9; 2231 FIRE_DAMAGE_DONE 23; 2311 SPELL_POWER 2 (type 45 op leer = echt).
Scholen-keys GEMETEN in GlobalStrings (HOLY/FIRE/NATURE/FROST/SHADOW/ARCANE/PHYSICAL_DAMAGE_DONE_SHORT).
ForeverQuestHint: SpellValue = healers SPELL + HEAL + 0,5·MP5, damage-rollen SPELL + SDMG + de scholen van de spec;
SpellUnweighable = onbekende key, een school die de spec niet cast, of een school-regel voor een healer → geen oordeel.
Explain noemt het clientwoord ("Spell Healing" / "Spell Damage"). ForeverMainStats `schools` (AFGELEID): Mage Arcane/Fire/
Frost per boom (zonder richting geen lijst = zwijgen), Warlock Shadow (+Fire Destruction), Priest Shadow+Holy / Shadow,
Elemental Nature+Fire, Balance Nature+Arcane, Paladin Holy. gearench_test 25/25. Volgende: "How you play" in tabbladen.

## ▶▶ 25 nov (Bouwchat 25-11): spell damage telt mee in de gear-vergelijking — GEBOUWD, wacht op test (`/reload`)

GEMETEN door Rob: `/dump C_Item.GetItemStats("item:9513")` (Ley Staff) = INTELLECT 1, SPELL_POWER 2, DPS 5.34, SPIRIT 1;
de kale GetItemStats is nil in Forever. GEMETEN in DB2: 9513 heeft in ItemSparse alleen Spirit/Intellect (de client maakt de
spell power: caster-wapen). Stattypes in ItemSparse: 45 spell power (1078 items, ook op leer: 2311), 41 healing, 42 spell
damage, 85/87/88… school.
- ForeverQuestHint.lua: Stats() → `out.SPELL`; andere SPELL/HEAL-keys → `out.spellUnknown` (lijst); Score telt
  `SPELL × curSpellW` (MainFor zet curSpellW uit def.spellW); IsBetter = false als een van beide items `spellUnknown` heeft
  (liever zwijgen); Explain noemt "+/-N spell damage"; `/mh questhint check` en `/mh geartip` tonen de som. Sum() geeft
  spellUnknown door.
- ForeverMainStats.lua `spellW`: 1 voor Mage/Priest/Warlock (klasse + bomen), Holy Paladin, Resto/Elemental Shaman,
  Balance/Resto Druid; 0,5 voor Paladin-klasse-rij, Ret, Prot. AFGELEID (voorzichtig).
- 🔵 Nog te meten (Rob, /dump): 7049 Truefaith Gloves (41+42), 19395 Rejuvenating Gem (41), 2231 Inferno Robe (85), 2311
  White Leather Jerkin (45 op leer). Tot dan: healing-only/school = geen oordeel.
gearench_test 20/20.

✅ 25 nov: restjes clientnaam (Sparring: valt onder "clientnaam wint altijd"). GEMETEN: frFR ItemSubClass 2.3 DisplayName
"Arme à feu" (VerboseName "Fusils") → fr WAR_8, ROG_7, HUN_1, PAL_5 "arme(s) à feu" (FDIRB_W_RANGED had het al; PLAYCARD_255
"coups de fusil" = schoten, retail, gelaten); ptBR item 2862 "Pedra de Afiar Rústica" → FPROFG_DOES_BLACKSMITHING "pedras de
afiar"; esMX ItemSubClass 2.4 "Maza" = esES → geen overlay nodig.
🔵 Gemeten voor Sparring (niets veranderd): Prot Paladin `BY_TREE.PALADIN[2]` = {Stamina} → de tooltip-rekensom weegt alleen
Stamina. `Stats()` (ForeverQuestHint.lua:182) leest alleen STAT_KEY (5 hoofdstats) + armor + DPS; "SPELL_POWER" komt in dat
bestand niet voor. Gevolg: een item met MINDER Stamina en veel spell damage krijgt geen regel (MH zegt nooit "worse", hij
zwijgt); een item met iets MEER Stamina krijgt "better", ook als wat je draagt veel spell damage heeft → mogelijk verkeerd
upgrade-advies. Dat gold vóór vandaag ook al (Intellect telde, spell damage nooit). Of GetItemStats op Forever spell power
teruggeeft: NIET gemeten.

## ▶▶ 25 nov (Bouwchat 25-11): "Which weapon?" — Fable-controle VERWERKT (alle 9), wacht op test (`/reload`)

Rob via Sparring: *"Maak ze maar een voor een compleet af daarna de controle"* — dit is die controle.
CODE (ForeverWeapons.lua): token `<GF:NAME|n|en>` (clientstring met voorbeeldgetal via gsub, dus %1$d werkt ook) en
`<W:c.s|en>` (item-subklasse); ru-override FWADV_DPS_WORD (ruRU ITEM_MOD_DAMAGE_PER_SECOND_SHORT = "к урону в секунду",
GEMETEN); Wands (5009) in "already use" voor casters; regels met `maxLvl` (First wand tot 20); titel via UnitClass (eerste
waarde) voor alle 9; items 247789/11287/263412/274947/20750/5175-5178 bij het laden opgevraagd; Druid Dire Bear (9634) vanaf
40, beer-armorregel pas vanaf 10; DirNoneText: Feral krijgt FWEAP_DIR_FORM_FMT. Comments: datums (Paladin 15 okt, Mage &
Shaman 7 okt), Shaman Dual Wield rij 2455 bestaat wel (overblijfsel), talentlevels "at the earliest".
STATS: Druid-klasse-rij {Strength, Agility} equal (was Agi 1 / Str 0,5 in de tooltip-rekensom; nu allebei 1); TANK.WARRIOR
en TANK.DRUID zonder DPS-lead (A7: tanks = Stamina eerst, overal); Paladin tank (TANK + BY_TREE[2]) = {Stamina} + `spell`
("Stamina, then spell damage"; Blizzard hotfix-thread 2403040 post 12, 17 nov) — Intellect weg, open punt "Prot Intellect"
OPGELOST, en de tooltip-rekensom voor Prot weegt nu alleen Stamina; Survival lead "survival" (ranged <30, melee ≥30).
TEKST (enUS): CAST_1/_2/_4, MAG_7 (Scroll of Imbue Lesser Flame 274947), WLK_7 (Wizard Oil 20750 als token), PAL_3/_4/_6/_7,
WAR_5, ROG_4/_5/_8, HUN_6/_8/_9, SHA_2/_8 (Totem-items 5175-5178), FWEAP_DIR_NONE/FORM_FMT, FDONOW_STAT_SPELLDMG; vertalingen
door mh-writer (zie de commit). wadv_test 104/104. Nog open voor Rob: Warlock-Stamina.

## ▶▶ 25 nov (Bouwchat 25-11): de ochtendwachters bewaken het wapenadvies (register + vaste stap)

Rob via Sparring: *"Zorg er ook voor dat in onze controlerondes elke dag gecontroleerd wordt of er wijzigingen zijn die hier
invloed op hebben."* + *"En dat bedoel ik natuurlijk bij patch notes en dat soort dingen allemaal."* (ook zijn ja voor
WATCHER_FOREVER.md).
- Nieuw: `docs/forever/WAPENADVIES_FEITEN.md` — per bewering bron, meetpunt, plek in de code (key/bestand) en status
  (GEMETEN/BRON/GIDS/🟠 BETWIST of NIET GEMETEN), per class, plus de trefwoorden.
- `docs/WATCHER_FOREVER.md` sectie "Weapon advice — every run": content- en datawachter lezen alle Blizzard-bronnen (patch
  notes, hotfixes, dev/beta notes, deep dives, blue posts/known issues); de API-wachter legt bij een nieuwe `wowf`-build de
  GEMETEN DB2-rijen naast de vorige; uitvoer = één regel `⚔️ Wapenadvies:` per treffer, niets zelf aanpassen.
- GEMETEN (get_trigger, alleen gelezen): de content- en datawachter eindigen met "read docs/WATCHER_FOREVER.md and do the
  section 'For all four' plus the section for YOUR file"; alle vier schrijven dagelijks een **Forever:**-regel (API_WATCH
  25 nov meldde build 71091). Ze lezen het bestand dus al; geen prompt-wijziging nodig. ⚠️ De nieuwe sectie heet niet "For
  all four" maar staat ernaast en noemt elke wachter bij naam — AFGELEID dat ze hem lezen (ze lezen het hele bestand); de
  eerste run (26 nov) laat het zien: zoek `⚔️ Wapenadvies:`.
- REGIE.md tabel 2 bijgewerkt.

## ▶▶ 25 nov (Bouwchat 25-11): "Which weapon?" — Warlock GEBOUWD: alle 9 classes klaar. Volgende: Fable-controle (Sparring) + wapenadvies-wacht

FWADV_WLK_5/_7 (8 talen). GEMETEN: Create Firestone 6366 (lvl 28), Create Spellstone 2362 (lvl 36), Life Tap 1454.
Stats: WARLOCK lead "spell" (basis + 3 bomen); Affliction {SPIRIT, INTELLECT} nu `equal` (guides verschillen; ook de
tooltip-rekensom). Life Tap-comment bijgewerkt. ForeverDirection WARLOCK = FDIRB_W_CASTER.
✅ GESLOTEN 25 nov (zie bovenaan): Warlock-Stamina = keuze (a), Rob: *"Ik volg jouw advies."* (was: klasse-rij {Intellect,
Stamina}, Demonology/Destruction {Intellect, Stamina} equal). wadv_test 92/92, tokcheck 68 sleutels 0 fouten.

## ▶▶ 25 nov (Bouwchat 25-11): "Which weapon?" — Priest GEBOUWD, wacht op test. Volgende: Warlock, dan de wapenadvies-wacht

FWADV_PRI_5/_7 (8 talen) + de gedeelde CAST-regels. Stats: PRIEST lead "spell" (basis + Shadow), Holy "heal",
Discipline "heal" (keuze bouwchat: de rij is al een healrol). ForeverDirection PRIEST = FDIRB_W_CASTER. wadv_test 87/87,
tokcheck 66 sleutels 0 fouten.

## ▶▶ 25 nov (Bouwchat 25-11): "Which weapon?" — Mage GEBOUWD (+ gedeelde caster-regels), wacht op test. Volgende: Priest, Warlock

Gedeeld FWADV_CAST_1..4 en _6, Mage FWADV_MAG_5/_7 (8 talen). GEMETEN (DB2 71091): Shoot 5019, Wand Specialization 6057,
Wands 5009; items Novice's Practice Wand 247789 (lvl 1), Lesser Magic Wand 11287 (lvl 5); GlobalStrings INVTYPE_HOLDABLE
"Held In Off-hand", ITEM_SPELL_TRIGGER_ONEQUIP "Equip:". De rest van de item-regel ("Increases damage and healing done by
magical spells") is in de/fr/es/pt/it/ru door mij vertaald, NIET de exacte clienttekst (AFGELEID) — Fable-ronde. Bronnen in
de code (Blizzard dev notes 24 sep/16 okt, DB2; Icy Veins Frost wijkt af en is niet gevolgd). Stats: MAGE lead "spell"
(basis + 3 bomen). ForeverDirection MAGE = FDIRB_W_CASTER (game, geen fit); FWEAP_DIR_NONE_FMT nieuwe tekst ("the weapon
kind matters little here; look at what is on it"). wadv_test 79/79, tokcheck 64 sleutels 0 fouten.

## ▶▶ 25 nov (Bouwchat 25-11): Druid "Which weapon?" — caster-staf-regel GEREPAREERD (`/reload`)

🔴 FWADV_STAFF_FMT zei "a caster staff hits about as hard in a form" — FOUT (ook in de opdracht van toen). De DB2-tabellen
ItemDamage*Caster zijn gelijk aan de gewone, maar echte caster-items (ItemSparse Flags_4 0x100) tonen ~74% DPS (staven) en
~66% (daggers): Sparring mat 120 staven + 31 daggers op Wowhead Forever (Ley Staff 5.34 vs 7.14 ilvl 10, Icicle Rod 12.5 vs
16.9, Staff of the Deeproar 33.48 vs 45.0); Blizzard hotfix 17 nov (Kaivax, thread 2403040). Nieuwe tekst in 8 talen; de
"(GEMETEN)"-comment in ForeverWeapons.lua gecorrigeerd. Les: een DB2-tabel is geen bewijs van wat het item toont.
Tooltip-check (alleen gelezen, niets veranderd): ForeverQuestHint `Stats()` leest alleen de 5 hoofdstats, armor en DPS
(GetItemStats + tooltipregels "%s Armor" / DPS) — spell damage/healing van een wapen telt NIET mee in "beter dan wat je
draagt" (AFGELEID uit de code; GetItemStats op Forever voor zo'n item niet gemeten). Tool-bug (Sparring): `run gamedata
item` laat tooltipregels weg (Whiteout Staff 19101: "+25 Intellect", "Equip: … spell damage"); de ruwe JSON heeft ze.

## ▶▶ 25 nov (Bouwchat 25-11): "Which weapon?" — Rogue GEBOUWD, wacht op test (`/reload`). Volgende: Mage, Priest, Warlock

FWADV_ROG_1..8 (8 talen), CLASS_LINES.ROGUE. GEMETEN (DB2 SpellName 71091): Backstab 53, Ambush 8676, Shank 1329283
(spelersversie; 15248/15617 zijn NPC-id's, AFGELEID), Stealth 1784, Mutilate 399956 (zelfde id als ForeverDirection),
Hemorrhage 16511, Ghostly Strike 14278, Hack and Slash 13960, Poisons 2842, Throw 2764. "Mutilate from 40" en "Shank from
24" uit het onderzoek (Beta Dev Notes 3 nov), niet uit de Talent-tabel. Stats: ROGUE lead "mhdps" ("main-hand weapon damage
per second first"), Agi/Str ongewijzigd. Bijvangst: How you play Subtlety-rol, Hemorrhage "… but with a dagger it hits
harder" in en + 8 vertaalbestanden (nl de fr es esMX pt ru; it heeft geen eigen bestand). wadv_test 72/72, tokcheck 57
sleutels 0 fouten.

## ▶▶ 25 nov (Bouwchat 25-11): "Which weapon?" — Hunter GEBOUWD, wacht op test (`/reload`). Volgende: Rogue, casters

FWADV_HUN_1..9 (8 talen), CLASS_LINES.HUNTER. GEMETEN (DB2 SpellName 71091): Auto Shot 75, Arcane Shot 3044, Aimed Shot
19434, Multi-Shot 2643, Raptor Strike 2973, Mongoose Bite 1495, Strider Kick 1317257, Careful Aim 1223984, Bows 264 /
Guns 266 / Crossbows 5011; GlobalStrings AMMOSLOT "Ammo", INVTYPE_QUIVER "Quiver", ENERGY "Energy". Bronnen van Sparring
in de code (DB2 SpellEquippedItems 262156, Beta Dev Notes 24 sep/16 okt, Wowhead tooltips, Icy Veins Survival 20 nov).
"Strider Kick from level 30" komt uit het onderzoek, niet uit de (verouderde) Talent-tabel.
Stats: HUNTER lead "rdps" ("ranged weapon damage per second first"), Agi/Spi + Careful Aim ongewijzigd; BY_TREE.HUNTER[3]
Survival = melee {AGILITY, STRENGTH} lead dps (nieuw: ook de tooltip-rekensom voor Survival). FDIRB_W_SURVIVAL nieuwe
tekst (8 talen, it valt terug op en); fit = ranged + axe/axe2/sword/sword2/polearm/staff/dagger/fist (geen maces).
FDONOW_STAT_RDPS_FMT en (voor de Rogue) FDONOW_STAT_MHDPS_FMT in 8 talen. wadv_test 64/64, tokcheck 49 sleutels 0 fouten.

## ▶▶ 25 nov (Bouwchat 25-11): "Which weapon?" — Shaman GEBOUWD, wacht op test (`/reload`). Volgende: Hunter, Rogue, casters

FWADV_SHA_1..8 (8 talen), CLASS_LINES.SHAMAN (`learn` = staff/mace2/axe2: alleen tweehanders). GEMETEN (DB2 71091):
Stormstrike 17364, Windfury Weapon 8232, Flametongue Weapon 8024, Rockbiter Weapon 8017, Frostbrand Weapon 8033, Mental
Dexterity 415140, Mail 8737, Totem 27763, Staves 227 / 2H Axes 197 / 2H Maces 199; item 263412 Totem of Charged Flames
(ItemSparse; naam via C_Item.GetItemNameByID, Engels zolang de client het item niet heeft). NIET gemeten: waar talent
16269 "Two-Handed Axes and Maces" vandaan komt → de regel zegt "rood? ga naar je class trainer en een weapon master".
Wapenbuff-levels 1/10/20/30 uit het onderzoek. Windshaper Skyborne-regel = de dynamische "already use".
Stats: standaard + Enhancement lead dps, Elemental spell, Restoration heal én Intellect boven Spirit (`equal` weg — dit
verandert ook de tooltip-rekensom voor Resto: Spirit telt nu half). ForeverDirection SHAMAN[1]/[3] = FDIRB_W_SHIELD (1H:
mace/axe/dagger/fist + shield), [2] fit + staff. wadv_test 54/54, tokcheck 40 sleutels 0 fouten.

## ▶▶ 25 nov (Bouwchat 25-11): "Which weapon?" — Paladin GEBOUWD, wacht op test (`/reload`)

FWADV_PAL_1..8 (8 talen), CLASS_LINES.PALADIN in ForeverWeapons.lua. Spell-id's GEMETEN (DB2 SpellName 71091): Seal of
Command 20375, Holy Strike 678, Seal of Righteousness 20154, Righteous Fury 25780, Seal of Fury 20163, Holy Shield 20925,
Judgement 20271, Two-Handed Weapon Specialization 20111, Libram 27762. De ras-regel van het onderzoek = de dynamische
"You can already use / still learn" (client + leraren). Stats: standaard en Retribution lead = "dpsspell" ("weapon damage
per second and spell damage first"), Holy lead = "heal". ForeverDirection GUIDE.PALADIN[1] (Holy) = FDIRB_W_ONEHAND_OFF,
fit 1H, shield.
🔵 OPEN VOOR ROB: Protection-stats staan op Stamina, dan Intellect (21 nov). Intellect als tweede is twijfelachtig (guides
verschillen: wowforeverbuilder Spell power/Int, Mobalytics ook Strength). NIET veranderd; Rob beslist.
wadv_test 42/42, tokcheck 32 sleutels 0 fouten.

## ▶▶ 25 nov (Bouwchat 25-11): "Which weapon?" — Warrior GEBOUWD (1 van 8 na de Druid), wacht op test (`/reload`)

Rob via Sparring: *"Maak ze maar een voor een compleet af daarna de controle"*; volgorde Warrior → Paladin → Shaman →
Hunter → Rogue → casters, één commit per class, Fable-controle als alle 9 klaar zijn. Tekst = Sparring's verbeterde
versie (mh-research + tweede check, 25 nov).
- Algemene motor in `ForeverWeapons.lua`: CLASS_LINES[class].lines = locale-keys met tokens die de client invult:
  `<S:id>` spellnaam, `<G:NAME|en>` Blizzard-global, `<I:id|en>` itemnaam, `<T:n>` talent-boom (ns.ForeverSpecName,
  DB2 TalentTab). Daarna "You can already use" + "Weapons you can still learn" (FWADV_LEARNANY_FMT; `learn` = alleen
  bepaalde soorten). Titel FWADV_TITLE_FMT met de client-classnaam. Druid blijft zijn eigen code.
- Warrior: FWADV_WAR_1..8 (8 talen). Spell-id's GEMETEN in DB2 SpellName 71091: Mortal Strike 12294, Overpower 7384,
  Slam 1464, Dual Wield 674, Defensive Stance 71, Shield Bash 72, Shield Block 2565, Shield Slam 23922, Revenge 6572,
  Shield 9116, Weaponmaster 12281, Two-Handed Weapon Specialization 12163; RAGE, SPELL_STAT1..5 (GlobalStrings).
- Stats: WARRIOR lead = dps; TANK.WARRIOR = Stamina, Armor, Agility (was Stamina = Strength "equal"; Icy Veins Prot 4 nov +
  wowhandbook: Agi vóór Str). Tooltip-rekensom ongewijzigd (TANK wordt alleen als tekst gebruikt).
- Scratch-controle `tokcheck.py`: elke FWADV-sleutel in 8 talen met dezelfde tokens en ** als het Engels (24 sleutels, 0
  fouten). wadv_test 30/30.

## ▶▶ 25 nov (Bouwchat 25-11): Forever "Which weapon?" voor de Druid + stats-zin — GEBOUWD, wacht op test (`/reload`)

Rob via Sparring: *"… begin maar met de Druid inderdaad"* → *"Ja"*. Feiten van Sparring (mh-research + tweede check, 25 nov;
Blizzard Forever Class Deep Dive Hunter & Druid 30 sep 2026 + DB2 1.60.1.71091), staan in de kop van het nieuwe stuk in
`ForeverWeapons.lua`. Zelf GEMETEN vandaag: SpellName 5487 Bear Form / 768 Cat Form / 9634 Dire Bear Form; GlobalStrings
STAT_ATTACK_POWER "Attack Power", ITEM_MOD_DAMAGE_PER_SECOND_SHORT "damage per second", ARMOR, STAT_DODGE.
- `ns.ForeverWeaponAdvice()` (ForeverWeapons.lua): titel + regels, alleen DRUID. <10 "from level 10 (Bear Form)", 10-19
  alleen Bear (geen Cat-tekst), 20+ Bear + Cat. Wat je al kunt (IsPlayerSpell op de wapenskill) en welke tweehanders je
  nog kunt leren bij de leraren van JOUW kant (TRAINERS-tabel) → volgt het ras vanzelf. Spelwoorden uit de client
  (spellnaam, item-subklasse, stat-globals) via %s; zinnen in 8 talen (FWADV_*).
- How you play: blok na "Level and tank" (venster Body() én overzicht-pagina ForeverHowToSections), via de locale-keys,
  NIET in de vertaalde lestabellen (die hebben vaste volgorde per taal).
- ForeverDirection GUIDE.DRUID: wapenregel per richting (FDIRB_W_DRUIDFORM / _DRUIDCAST), `game = true` → "Weapon: …" en
  bronregel FDIRB_SOURCE_GAME. GEEN `fit`: in een form telt het type niet, alleen DPS → tooltip zegt niets over "fits".
- Stats (ForeverMainStats `lead`/`armor`, ForeverDoNow StatSentence): Feral/standaard "weapon damage per second first,
  then …"; Bear-tank "… then Stamina, then Armor, then Agility"; Balance "bonus damage and healing for spells first";
  Resto "bonus healing for spells first". De tooltip-rekensom (`main`) is NIET veranderd.
- Niet gebouwd: Do this now-hint 1H→2H (niet zeker te meten). Fable-ronde vóór de volgende release.
Offline: wadv_test 20/20; locale-probe OK in 8 talen.

✅ 25 nov: Forever-post naar de andere factie kan NIET — GEMETEN door Rob (Horde → Ima Bankgirl): *"target is unfriendly
:)"* = ERR_PLAYER_WRONG_FACTION "Target is unfriendly." (GlobalStrings Forever 71091). FALT_OTHERFAC_FMT zegt nu "other
faction, can't mail" in 8 talen (was "probably not possible"); Reach()-reden en commentaar in AltProfTip.lua bijgewerkt;
splitsing ongewijzigd. altprof_test 55/55.

✅ 25 nov: recept-tooltip (95108e3) GETEST door Rob (screenshot via Sparring: "MH: your other characters with Alchemy:
Ima Warlocky (18, needs 50)"). Nog open: "knows it"/"can learn it", de gear-regel na 7734a0d/3c08cb6, bank-knop.

## ▶▶ 25 nov (Bouwchat 25-11): bank-characters uit de gear-regel — GEBOUWD, wacht op test (`/reload`)

Rob via Sparring: *"Wat betreft de bankkarakters ga ik mee met je advies. A."* (voorstel: één keer markeren, weg bij
gear, wel bij recepten/materialen). Opslag `ns.db.altBankChars[guid] = true` (NIET in het character-record: Midnight's
AltOverview.lua bouwt dat record bij elke snapshot opnieuw op, de vlag zou verdwijnen). AltProfTip: ns.IsAltBankChar /
ns.SetAltBankChar; OthersGear slaat ze over; `/mh alttip bank <naam>` (naam hoofdletterongevoelig) wisselt; `/mh alttip`
noemt "bank character, skipped for gear". Forever: knop "Bank: no/yes" (84 px, links van het kruisje) per rij in het
overzicht → Characters (ForeverOverview CharRow, via ForeverCharsViews v.bank/v.toggleBank). Het oude losse venster
(ForeverChars Row) heeft GEEN knop (iedereen landt op de overzicht-tab). Midnight: alleen het commando (keuze bouwchat).
Nieuwe sleutels (8 talen): FCHARS_BANK_OFF/ON/TIP, FALT_BANK_SET/UNSET/NONE_FMT. altprof_test 55/55; de knop zelf niet
offline getest.

## ▶▶ 25 nov (Bouwchat 25-11): enchant telt mee in "beter dan wat je draagt" + alt-regel alleen naar wie je kunt mailen — GEREPAREERD, wacht op test (`/reload`)

Robs screenshot (Druid): Nomadic Gloves 21 armor + Light Armor Kit (enchant 15) aan, grijze Worn Leather Gloves 22 armor
in de tas → "MH: +1 Armor over what you wear". GEMETEN op die screenshot: de item-armor (GetItemStats/tooltipregel) laat
de kit weg. Rob: *"Ja, op 1 en 2."*
1. `ForeverEnchantData.lua` krijgt `FOREVER_ENCH_STATS` (280 id's; 83 helemaal te wegen, 197 met een deel dat MH niet kan
   wegen = x). GEMETEN in DB2 SpellItemEnchantment: Effect 4 arg 0 = armor, Effect 5 = stat (3 agi, 4 str, 5 int, 6 spi,
   7 sta); Effect 3 = equip spell → SpellEffect aura 29 (stat; misc 3 = Int GEMETEN op 13825 "Intellect +7") of aura 22
   misc 1 (armor). Enchant 15 = Armor 8 + Stamina 1. `ForeverQuestHint.lua` Stats(): enchant (veld 2 van de link) telt
   mee; Lost()/LoseText(): " You lose the enchant on what you wear: …"; IsBetter: een verloren x-enchant = geen "beter".
   Eén functie (ns.ForeverGearTipText) voedt tooltip, oppak-melding (6e return), quest-tip, ForeverWear en ForeverBagFull:
   allemaal mee. Midnight PickupUpgrade = item level + score, andere code, niet aangeraakt. Alt-gear-regel (item level
   x → y) zegt alleen item level; enchant van het alt niet meegeteld (melding aan Sparring).
2. Geen alt-gear-regel bij grijs (quality 0); wit blijft (Robs Nomadic Gloves zijn wit, |cnIQ1 in zijn SV).
3. "(empty slot)" bij Banklady/Hunterdude/Roquedude: GEMETEN in Robs Forever-SV (met Lua geladen): gear opgeslagen,
   handen-vakje echt leeg (level 1-2). Klopt; niets veranderd.
4. Mailen (Rob: *"kan ik überhaupt wel sturen?"*). GEMETEN in de SV: één realm (CAMWOW EU4 Realm 10 RP); Alliance =
   Ima Bankgirl, Ima Tinyroque, Inchy Shootalot, Joey Whatever; zonder factie = Ima Lockie, Ima Magymage, Ima Warman; 2
   zonder realm (GUID-server 6944 beslist). AltProfTip Reach(): andere realm = weg; andere factie = apart achteraan
   "· other faction, mail probably not possible" (cross-faction mail in Forever NIET gemeten; in Classic niet mogelijk);
   factie onbekend = "(faction ?)". Recept, materiaal en gear. Midnight niet gefilterd (Warband bank, AFGELEID).
   Soulbound/BoP-check bestond al (ITEM_SOULBOUND-regel; een gedragen BoE toont "Soulbound", AFGELEID).
Nieuwe sleutels (8 talen): FGEAR_LOSE_FMT, FALT_FACQ_FMT, FALT_OTHERFAC_FMT. Offline: gearench_test 14/14,
altprof_test 48/48, ench_test 24/24. Volgende: bank-characters markeren (Rob: *"… ga ik mee met je advies. A."*).

## ▶▶ 25 nov (Bouwchat 25-11): taint van de knop Character GEREPAREERD + armor kits hebben een naam — ✅ GETEST (a178459)

✅ Rob via Sparring: *"Ja, test is goed gegaan."* + screenshot: Hands/Feet "Armor +8, Stamina +1" (groen), Back/Chest/
Wrist/Main Hand "no enchant". NIET apart gemeld: de Now-regel "Character window: C." en geen BugSack-fout meer. Nog open
(niet getest): recept- en gear-tooltip, "you can make this yourself" op de enchanter, de buff-fixes.

Robs BugSack (via Sparring): `TextStatusBar.lua:110: attempt to compare a secret number value (execution tainted by
'MidnightHelper')`, stack ShowUIPanel ← CharacterFrame.lua:25 ← pcall ← ForeverEnchantCheck.lua:376 ForeverOpenCharacter ←
ForeverDoNow.lua:343 ← ForeverOverview.lua:2278. Oorzaak (GEMETEN in de stack): ToggleCharacter vanuit onze knop opent het
paneel tainted; de PlayerFrame-balken vergelijken dan secret values. pcall helpt niet. Mijn eerdere "AFGELEID dat het mag"
(hieronder) was dus fout.
Fix: geen knop meer. `ns.ForeverOpenCharacter` weg; nieuw `ns.ForeverCharacterKeyText()` (GetBindingKey TOGGLECHARACTER0
→ GetBindingText); de Now-regel krijgt "Character window: C." (FENCH_KEY_FMT, 8 talen; FENCH_BTN/FENCH_COMBAT weg). MH
opent CharacterFrame nergens meer. SecureActionButton type=click overwogen en NIET gedaan: secure knop in de overzichtskaart,
offline niet te meten, meer risico.
Elders in MH (GEMETEN, grep): `Achievements.lua:340` ShowUIPanel(AchievementFrame) en `Delves.lua:3842`
ShowUIPanel(DelvesDashboardFrame), beide alleen Midnight, geen meldingen; niet aangeraakt. ToggleCharacter nergens meer.
"enchanted" op handen/voeten van de Druid lvl 11: GEMETEN in Robs SV: enchant 15 = spell 2831 "Armor +8, Stamina +1"
(Light Armor Kit; Druid heeft Leatherworking). `ForeverEnchantData.lua` mapt nu elke ENCHANT_ITEM-spell: 280 id's
(Enchanting eerst). Scratch `ench_test.lua` 24/24. Materiaal-tooltip GETEST door Rob (TESTLIJST/IDEEEN afgevinkt);
recept- en gear-tooltip nog open.

## ▶▶ 25 nov (Bouwchat 25-11): Forever Gear check: enchants naast het character-venster — GEBOUWD, wacht op test

Rob via Sparring, letterlijk: *"ik heb ook enchanting, maar ik zie helemaal niet of ik al iets enchant heb, ja of nee, in
mijn overzichtje."* → *"Ja, het gaat om forever. En het is goed zo met 1, 2 en 3."*
Nieuw: `Modules/ForeverEnchantData.lua` (gegenereerd) + `Modules/ForeverEnchantCheck.lua`, in beide toc's (herstart).
GEMETEN in wago DB2 Forever 1.60.1.71091: SkillLineAbility 333 = 273 spells, 180 met SpellEffect 53 (ENCHANT_ITEM);
SpellEquippedItems → vakjes nek (5, nieuw in Forever), borst/robe, voeten, pols, handen, mantel, schild, off-hand-item,
wapens (masker per subklasse; 2H apart). Geen hoofd/schouders/benen/ringen/trinkets/ranged. 147 enchant-id's →
recept-spell. Naam = het deel na de laatste " - " van de client-spellnaam (deDE "Armschiene - Große Willenskraft", GEMETEN);
een id zonder Enchanting-spell = "enchanted". Enchant = 2e veld van de itemlink.
Venster: eigen frame op UIParent (naam MidnightHelperForeverEnchantPanel, RegisterMidnightDialogPopup = Shift+scroll +
Escape), bij openen rechts naast CharacterFrame gezet via een HookScript OnShow/OnHide; raakt CharacterFrame zelf en
CharacterScape niet aan; niet bijgewerkt in een gevecht. (2) Do this now: tip "N slots … no enchant" (soort "enchant"; het
overzicht maakt de knop Character uit ACTS: ToggleCharacter("PaperDollFrame"), niet in een gevecht; of dat taint geeft is
NIET te meten offline, AFGELEID dat het mag; in de TESTLIJST gezet). (3) enchanter: bekende recepten (foreverKnownRecipes
of IsPlayerSpell) die op een leeg vakje passen. `/mh enchant` doet nu in Forever wat (was leeg: GearEnchantCheck laadt daar
niet). Schakelaar foreverEnchantCheck (aan) in de stille helpers. Teksten 8 talen. Offline: scratch `ench_test.lua` 19/19.

## ▶▶ 25 nov (Bouwchat 25-11): toetsenblok-intro klopt nu als het blok geplaatst is — GEREPAREERD, wacht op test

Robs screenshot (Midnight, 12 × 4, blok geplaatst): bovenin "This is a picture … Nothing on your bars changes until you
choose to place it.", onderin "The key block is on your bars." Rob via Sparring: *"ja dat mag de bouwchat"*.
`KeyBlock.lua` Refresh: geplaatst (GetSnap) → nieuwe tekst KEYBLOCK_INTRO_PLACED ("… This is the block as it is on your
bars now."), anders de oude KEYBLOCK_INTRO. 8 talen (de eerste zin per taal ongewijzigd overgenomen); locale-probe OK in
alle 8; check_drift alleen de 2 oude punten (GEARLADDER_FOOT, MBUFF_EUI_OVERLAP_HINT). `/reload` genoeg.

## ▶▶ 25 nov (Bouwchat 25-11): gear-tooltip "wie van je andere characters kan dit dragen" (beide games) — GEBOUWD, wacht op test

Rob plakte het advies van Sparring terug: *"Mijn advies: in beide games eerst "kan dragen + hoger item level". Forever gaat
dan ook de gear onthouden. Echte stats-vergelijking doen we later, als je het nog wilt."* — en schreef: *"Zeg je ja? JA"*.
`AltProfTip.lua` deel Gear: bij een te versturen wapen of harnas (Sendable() als bij recepten) de andere characters die
het kunnen dragen, max 3 (grootste winst eerst) + "and N more"; per character "(item level X -> Y)" als het hoger is dan
wat hij in dat vakje draagt (ring/trinket: de laagste van de twee; leeg vakje = "(empty slot)"), of "(from level N)"
(item-minlevel, Polearms 20, Forever Mail/Plate 40). Nooit "beter". Zelfde schakelaar altProfTip.
GEMETEN 25 nov in wago DB2 SkillRaceClassInfo (Forever 1.60.1.71091, Midnight 12.1.5.70961), unie van ClassMask per skill:
harnas Cloth/Leather/Mail/Plate/Shield, wapens per subklasse, Wands; Forever Mail (Hunter/Shaman) en Plate (Warrior/
Paladin) MinLevel 40; Forever-wapenmaskers = die van ForeverWeapons.lua (zelfde tabel, eerder gemeten). Midnight-bit 16384
hoort bij geen van de 13 classes (weggelaten). AFGELEID: libram/idol/totem = Paladin/Druid/Shaman (niet in die tabel).
Forever slaat nu de gear op: `ForeverChars.lua` Snap → `rec.gear[slot] = { l, i }` (slots 1-18 behalve 4/19, net als
Midnight), ook op PLAYER_EQUIPMENT_CHANGED. Midnight gebruikt `charCurrencies[guid].gear` (bestond al).
Fout gevangen in de offline test: `local _, link = a and t:GetItem()` geeft geen link (een `and` houdt één waarde) →
herschreven. Offline: scratch `altprof_test.lua` 36/36 (Forever + Midnight). NIET in het spel. Teksten 8 talen.

## ▶▶ 25 nov (Bouwchat 25-11): tooltip noemt je ANDERE characters bij recept/materiaal (beide games) — GEBOUWD, wacht op test

Rob via Sparring, letterlijk: *"Kunnen wij dat niet hier vermelden in de tooltip, zodat ik weet naar wie ik het moet gaan
sturen?"* → *"Ja, dat klopt zo. Kun je het voor beide versies maken, Forever en Midnight?"*
Nieuw `Modules/AltProfTip.lua` (beide toc's, na ReagentUse.lua: herstart nodig). GEMETEN vóór het bouwen:
- Recept-item = class 9, subclass → beroep (wago DB2 ItemSubClass ClassID=9: Forever 71091 0-9, Midnight 70961 0-11;
  0 = Book). Benodigde skill = de tooltipregel zelf via ITEM_MIN_SKILL (ook de vorm met positie %1$s, offline getest).
- Andere characters: Forever `foreverChars[guid].profs` {key, name, rank, max}; Midnight `charCurrencies[guid].profs`
  {n, r, m, s}; allebei gevuld in Robs SV (Midnight m = 100: de Midnight-skill). Bekende recepten alleen in Forever
  (`foreverKnownRecipes[guid]`, sleutels = GUID, gezien in Robs SV) + de spell die het item leert (nieuw:
  ns.ForeverRecipeTeaches in ForeverSkillup.lua). Materiaal: nieuw ns.ReagentUseKeys in ReagentUse.lua.
- Niet versturen = geen regel: tooltipregel ITEM_SOULBOUND / ITEM_BIND_ON_PICKUP, of bindType 1 (BoP) / 4 (quest).
  Account-/warbound mag (kan naar een eigen character). Midnight: alleen naam + skill, geen "can learn" (skill per
  uitbreiding; het recept kan van een andere zijn).
Schakelaar `altProfTip` (aan): Forever stille helpers, Midnight instellingen (SettingsDefs, alleen retail); `/mh alttip
on|off`, kaal = de laatste beslissing. Teksten 8 talen. Lint-vondst van de site-chat verwerkt (`x and false or nil`).
Offline: scratch `altprof_test.lua` 27/27 (Forever + Midnight: needs/can/knows, niet jezelf, soulbound/BoP/boek/niemand =
geen regel, materiaal, schakelaar, slash). NIET in het spel.
**Stap 2 (gear), alleen uitgezocht:** Forever bewaart per ander character class + level, GEEN gear (`foreverChars` heeft
geen gear-veld); "kan dragen" (class/harnastype/level) is te bepalen, "beter dan wat hij draagt" niet zonder eerst gear op
te slaan. Midnight bewaart per character class + `gear` (link + ilvl per slot, 19 records in Robs SV), maar geen spec;
"hoger item level dan wat hij draagt" kan, "beter" met stat-weights pas als we ook de spec opslaan. Rob beslist.

## ▶▶ 25 nov (Bouwchat 25-11): taunts op de muis + spiekbrief-code met de indeling — GEBOUWD; taunts ✅ GETEST

✅ Taunts: Rob via Sparring, letterlijk: *"De tangtesten is gelukt."* (class niet genoemd; de test was Druid in beervorm).
Spiekbrief-code: nog niet getest. Buff-fixes (hogere rank / groepsbuff): nog niet getest (Rob kreeg nog geen sterkere buff).

**Taunts** (Rob via Sparring: *"We hebben dingen als Taunt en Growl. Ik zou graag ook een macro van willen hebben voor een
mouse over."* → *"ja graag"*): `ForeverBlock.lua` MO_HARM + Growl, Taunt, Mocking Blow, Distracting Shot (de taunts op één
doel in de 9 blokken, GEMETEN: Druid F, Warrior F, Hunter F / 12×4 Ctrl-E). Niet: Challenging Roar/Shout (groep). Geen
Paladin- of Warlock-taunt in de blokken. Offline (scratch `taunt_mo_test.lua`): 9 classes × oud/12×4 × enUS/ruRU (ruRU-namen
uit DB2 SpellName Forever), 1128 toetsen allemaal ≤ 255 bytes, langste 195 (ruRU Paladin Shift-Z); de taunt-toetsen
krijgen `[@mouseover,harm,nodead,…]`; mouseover uit = zonder. Bijvangst (alleen gemeld): de Handy macro Growl staat alleen
bij spec 2 (Feral), omdat de Handy macros per spec een top 3 zijn (ForeverMacros.lua "DX3 #2"); lijkt bewust.
**Spiekbrief-code** (Rob via Sparring: *"ja op mijn advies bij 1 tot en met 4"*; contract met de site-chat, die akkoord
gaf): `KeyBlock.lua` BuildKeyBlockExport zet achteraan regel 2 `;layout=old|12x4;game=midnight|forever` (eerste regel blijft
"MH-KEYBLOCK 1"); SyncLayout() vóór de export. De rijen kwamen al uit de actieve indeling (GEMETEN in een echte
Forever-12×4-code in Robs SV, Druid Ima: A|Q, C|CTRL-F|KEYBLOCK_T_BANDAGE …). Uitleg in KeyBlock.lua: codes van 5.9.x
zonder `layout=` herkent de site aan A|Q/E/R/F of een CTRL-key behalve 1/2/3 (NIET aan Z X C V op A: die heeft het oude
blok ook — correctie op het voorstel van de site-chat). Site-chat bouwt het 12×4-raster + deel-link en leest beide
formaten, dus de site mag live vóór onze release. Een code mét layout= is offline niet gemaakt: komt na Robs /reload.

## ▶▶ 25 nov (Bouwchat 25-11): CURSEFORGE_DESCRIPTION.md herschreven na de Fable-review — Rob plakt hem op CF

Rob via Sparring, letterlijk: *"Ik zeg ja op jouw advies."* (1 Beta-zin weg, 2 Forever onder 6 kopjes en dubbele regels
samen, 3 ontbrekende functies invoegen zonder dat het langer wordt) en eerder *"indien nodig verbeteren"*.
Elk punt eerst zelf nagemeten in de code. Verbeterd: de "turning 3D figure" bij de trainer is weg (ForeverTrainer.lua:854-860:
het venster met model opent alleen nog met een level-argument, "none left in MH"; level-up opent de trainerpagina in het
overzicht, ForeverOverview.lua:450-452); "about 70 more" → *All commands* (Midnight: Tools, Forever: tandwiel); Beta-zin weg;
Midnight-healers: normale heals op 1-3, noodheal op C (enUS KEYGUIDE_INTRO_MN); E = interrupt "or the nearest thing";
missing-buff Midnight eigen regel zonder "now"; "New:" weg; eerste keer "Midnight Helper (MH)"; zoekkop "Midnight: …";
regel naar THIRD_PARTY.txt. Forever nu onder 6 kopjes (17 regels, was 29), plus een blok "In both games" (12 × 4,
upgrade-melding, macro's). Ingevoegd, allemaal GEMETEN in enUS/de code: Forever no-XP-waarschuwing, You just learned,
rested-XP-tip (standaard aan), worn gear + repairer (aan), MH: sell junk, tooltipregels class/quest, reputatie/valuta +
deze week, uitleg Dungeons & group, smart buff/bless (standaard UIT: "can switch on"); Midnight groepshulp, /mh map,
/mh export + /mh raidbots, account snapshot, /mh achlist, het level-90-venster, de play card-onderdelen. Waylaid Crates
en de Mage Study-tip bewust weggelaten (Robs keuze). Midnight-extra's (5 / Shift+Spatie) GEMETEN in de code: werken in
Midnight (ForeverKeyExtras.lua in de Midnight-toc, eigen Midnight-tak; Robs Midnight-SV keyExtras.on = true).
`MidnightHelper_Camelot.toc` Notes bijgewerkt (was nog de 5.0.x-lijst; zichtbaar na een herstart in de addonlijst).
📌 Voor de volgende release: RELEASE_NOTES.md regel 3 zegt "We put out betas regularly" (laatste beta 4.14.0-beta2,
29 okt). In 5.9.1 bewust niet aangepast (al uitgebracht); in de volgende notitie anders zeggen of weglaten.
✅ Daarna ook gedaan (Rob via Sparring: *"En ja op het opknappen van de 3 zinnetjes in de commandolijst."*): CMDLIST_LANG
+ "ru" (`/mh lang ru` bestaat, Locale.lua:81), CMDLIST_OVERVIEW noemt de 7 tabs met de tabnamen van elk pack (FOV_TAB_*;
esMX "Calabozos y grupo"), CMDLIST_BLOCK "opent het venster: neerzetten, nieuwe spells, terugdraaien". enUS, nlNL,
Translations2026 (de/fr/es/pt/it), ruRU.lua, ForeverClassQuests_de/fr/es/esMX/pt/ru. check_drift: CMDLIST_BLOCK +
CMDLIST_LANG gemarkeerd (7 talen); GEARLADDER_FOOT en MBUFF_EUI_OVERLAP_HINT stonden al gedrift, niet aangeraakt.
locale_probe: LANG en BLOCK in alle 8 talen OK. ⚠️ Blinde vlek van de probe: hij zet geen IS_FOREVER, dus de
ForeverClassQuests_*-packs laden niet (controle: FOV_TAB_NOW geeft hetzelfde "still English"). CMDLIST_OVERVIEW is daar
dus niet meetbaar, alleen syntax-gecontroleerd. Nog open: KEYBLOCK_STYLE_FOREVER_ONLY is verouderd (alleen een
terugval, komt nooit in beeld).

## ▶▶ 25 nov (Bouwchat 25-11): RELEASE 5.9.1 (Rob via Sparring, letterlijk: "release 5.9.1")

Geen beta. Versie 5.9.1 in beide toc's; CHANGELOG_591_1 t/m _6 (enUS) + Changelog.lua; `RELEASE_NOTES.md` byte-gelijk aan
`docs/CURSEFORGE_5.9.1.md` (cmp: gelijk); CHANGELOG.md; SITE_SEIN: de regels van 24-25 nov op "getagd" + een
release-regel. Alleen spelersdingen in de tekst. Bewust NIET in de spelerstekst: de InterruptMacros-icoonfix (Midnight
"MH+"; die fout is daar nooit gezien, alleen afgeleid), /mh disenchant en /mh buffs als diagnose.
NIET in het spel getest maar wel in de release (Sparring noemde het): de twee buff-fixes (offline 12/12 + 18/18) en het
trainervenster met toetsen + vorm.
✅ Tag v5.9.1 op f372713. Release-run 45578909374 geslaagd (Retail, Forever, verify). GEMETEN in de CF-API (25 nov
~08:55 UTC): v5.9.1 (id 9807222, 12.0.7-12.1.7) en v5.9.1-forever (id 9807230, 1.60.1), allebei Release, status 4; de
GitHub-release heeft beide zips. Wago: "Success!" in het run-log, niet apart nagemeten. SITE_SEIN op "staat op CurseForge".
🔴 Nog open voor Rob: kijken of de changelog op CurseForge netjes rendert (Files → het bestand → Changelog).
✅ `CURSEFORGE_DESCRIPTION.md` daarna bijgewerkt (Rob via Sparring: *"ja doe maar"*): Midnight 12 × 4 bij "Your keys",
Forever Layout-knop + iconen volgen de vorm, nieuwe regel "For enchanters" (tooltip, tas-icoon, Ctrl+Shift+klik), buffs
op jezelf + geen "runs out soon" onder een sterkere buff. 5.9.0-punten nagelopen: stonden er al. 🔴 Rob plakt hem op de
CF-projectpagina (de packager doet dat niet). Sparring laat daarna twee helpers beschrijving + site + screenshots nalopen.

## ▶▶ 25 nov (Bouwchat 25-11): Forever-buffs — geen "runs out soon" bij een HOGERE rank van een ander — GEREPAREERD, wacht op test

Rob (Forever Mage, screenshot "Arcane Intellect (1 min left) runs out soon"), via Sparring letterlijk: *"ik had van een
andere mage al een hogere rank gekregen die dus nog 2 minuten actief is, en dan blijft dit irritant in beeld, dat moet
natuurlijk niet"*; op het voorstel: *"ja"*. Voor 5.9.1.
Oorzaak GEMETEN in de code: `ForeverBuffs.lua` ExpiringLeft keek alleen naar de tijd, niet naar de rank. Fix: zit de
buff op je als rank hoger dan je eigen BestRank (positie in IDS[name], ranks van laag naar hoog: GEMETEN in
ForeverSpellIds.lua, bv. Mark of the Wild 6756 vóór 5234 = rankvolgorde), dan geen "runs out soon"; is hij op, dan de
gewone "ontbreekt"-melding met je eigen rank. Geldt voor alle Forever-buffs (buff en choice). `/mh buffs` zegt dan
"runs out soon, but a higher rank from someone else is on you (rank X, you know rank Y), N s left: wait until it is
gone". Offline: scratch `buff_rank_test.lua` 12/12 (hoger stil, eigen/lager/gelijk wel, lang geldig niets, op → missing,
alle ranks gekend → wel).
AFGELEID, niet gemeten in Forever: dat het spel je lagere rank weigert zolang een hogere actief is (klassieke regel).
✅ Daarna ook de covers-tak (groepsbuff van een ander), Rob via Sparring op (a): *"Ik volg uiteraard jouw advies"*. GEMETEN
in wago DB2 SpellEffect (Forever 1.60.1.71091, EffectBasePointsF): Arcane Brilliance 23028 = 31 Int = Arcane Intellect
rank 5; Prayer of Fortitude 21562/21564 = 56/70 = PW: Fortitude rank 5/6; Gift of the Wild 21849/21850 = Mark of the
Wild rank 6/7 (armor, stats, alle vijf resistances gelijk). Tabel COVER_EQUIV: is je eigen hoogste single rank zwakker
dan de groepsbuff, dan stil tot hij op is; even sterk of sterker = de knop biedt je single buff zoals eerst. Paladin
Greater Blessings: die tak bood al nooit iets (geen `buff` in de def, GEMETEN in de code). Offline 18/18 (ook: elk id
van de tabel staat in de spell-id-lijsten).

## ▶▶ 25 nov (Bouwchat 25-11): Forever — Ctrl+Shift+klik in de tas = Disenchant GEBOUWD — ✅ GETEST

✅ Rob via Sparring, letterlijk (ruw, Willow; "mates" = zijn Mage): *"de disenchanten met mijn mates. Ik kon gelukkig wat
zelf maken. Dat werkt ook. Shift-Ctrl ingedrukt houden en dan klikken naar het disenchant en dan gooit het netjes in mijn
tas. Dus daar ben ik blij mee."* Niet apart genoemd: Baganator of Blizzard-tas, gewone klik zonder Ctrl+Shift, de
schakelaar, gevecht, character zonder Enchanting.

Rob via Sparring, letterlijk: *"Kunnen wij een knop in de tooltip bouwen als we een item kunnen disenchanten? Zodat ik
niet eerst disenchant moet drukken, dan het ding wat ik wil disenchanten, maar dat we gewoon de tooltip daarvan kunnen
gebruiken."*; op het voorstel (Ctrl+Shift+klik, Blizzard-tassen + Baganator, eerst alleen Disenchant): *"Ja … En we
beginnen inderdaad met digijant eerst. En dan kunnen we prospecting en mailing later kijken."* Gezien in ForeverForge
Bags (niet geïnstalleerd, licentie onbekend): niets overgenomen.
Gebouwd in `ForeverDisenchant.lua` deel 4: één secure knop op UIParent (nooit aan een tasknop gehangen). Toont de tooltip
een "yes"-item in je eigen tassen (bag 0..NUM_BAG_SLOTS, link op die plek = tooltip-link), dan zet MH die knop buiten een
gevecht op schermpositie over het vakje (type spell, 13262, target-bag/slot), met state driver
`[combat] hide; [mod:ctrl,mod:shift] show; hide`: alleen zichtbaar zolang Ctrl én Shift ingedrukt zijn, dus een gewone klik
komt altijd bij de tas. Weg bij: muis van het vakje, tas dicht, ander item op die plek, BAG_UPDATE_DELAYED, begin gevecht.
Tooltipregel FDE_CLICK_HINT (alleen als het kan); tooltip op de knop FDE_CLICK_ARMED. Schakelaar foreverDisenchantClick
(aan; overzicht → stille helpers, en `/mh disenchant click on|off`); `/mh disenchant` print de laatste beslissing.
Teksten 7 talen (geen itIT: Forever heeft geen it-client).
GEMETEN: Baganator live-knoppen hebben GetBagID()/GetID() (ItemViewCommon/ItemButton.lua:628); de classic-variant houdt de
tas op de parent (:1286), daarom parent-ID alleen bij een knop met `.BGR`. Offline: scratch `de_click_test.lua` 36/36
(Blizzard + Baganator-knop, bank/bag -1 nee, ander item nee, combat nee, schaal ×2, tas veranderd, muis weg, schakelaar,
geen Enchanting, characterscherm-vakje nee). NIET in het spel getest.
NIET gemeten: of Blizzards Forever-tasknop GetBagID heeft (AFGELEID: het tas-icoontje van 18 nov gebruikt hetzelfde en
werkt); of Shift bij het openen van het lootvenster autoloot omdraait (Disenchant duurt even, dan heb je meestal al
losgelaten; AFGELEID); of de server bij een BoP-item een bevestiging vraagt.
Rob ook (via Sparring): **Sunder Armor = (a)**, niets doen en wachten op Blizzard (*"Wat Sunday Arbor betreft doe ik jou
volgen."*). Komt er Blizzard-nieuws (hotfix of bevestiging): melden aan Sparring. **5.9.1 wacht tot Disenchant erbij zit**
(*"we wachten nog heel eventjes met 5.9.1 totdat we deze ook erbij hebben"*); release blijft alleen op "release 5.9.1".
📌 Handoff gesplitst (1700 → 1176 regels) bij "20 nov — drie testpunten goedgekeurd".

## ▶▶ 25 nov nacht (Bouwchat 24-11): Midnight 12 × 4 op Robs Prot Paladin — UITKOMST (vóór 5.9.1 nog testen)

GEMETEN in keyBlockProbe (retail-SV 25 nov 00:07, spec 66, layout 12x4, slot voor slot): ALLES staat zoals het plan, op
één toets na. 2 Avenger's Shield · 3 Blessed Hammer (vervangt Hammer of the Righteous, zelfde knop) · 4 Shield of the
Righteous · Q Sentinel (vervangt Avenging Wrath) · E Rebuke · R Divine Steed · F Hand of Reckoning · Z Ardent Defender ·
X Divine Shield · C Guardian of Ancient Kings · V Cleanse Toxins · Shift-1 Consecration · Shift-3 Blessing of Sacrifice ·
Shift-Q Divine Toll · Shift-E Arcane Torrent · Shift-R Rite of Sanctification · Shift-F Hammer of Justice · Shift-Z
Blessing of Protection · Shift-X Holy Bulwark · **Shift-C Word of Glory (85673: NIET leeg)** · Shift-V Blinding Light ·
Ctrl-1/2/3 Devotion / Crusader / Concentration Aura (dus: de aura's bestaan en zijn knoppen in Midnight, GEMETEN) ·
Ctrl-4 Intercession · Ctrl-E Blessing of Freedom · Ctrl-R Redemption · Ctrl-F combat potion (241308) · Ctrl-Z health
potion (271884). Leeg: Shift-2, Shift-4, Ctrl-Q (niets voor in het plan), Ctrl-X/Ctrl-C/Ctrl-V (geen bruikbare trinket /
geen Healthstone). Alt: Spellwarding, Recuperate, een eigen macro, Flash of Light, Lay on Hands.
De afwijking: **toets 1 = "refuse", met spell 375576 (Divine Toll), dat ook op Shift-Q staat**. In de code kan dat
alleen de Single-Button Assistant van Blizzard zijn (IsAssist, KeyBlock.lua; die meldt zich als de spell die hij
voorstelt). MH bedekt of verplaatst die bewust nooit (een addon kan hem niet terugzetten). AFGELEID, niet op Robs scherm
gezien. Dus Judgment staat niet op 1. Wat Rob doet: de Single-Button Assistant van toets 1 slepen (bv. naar een Alt-plek),
dan `/mh block` → "Update (add new spells)": Judgment komt op 1. Geen code-fout. Rob: *"het ziet er nu wel goed uit"*.
✅ 25 nov GETEST (Rob via Sparring, letterlijk): *"Sorry, ja, toets 1 was ook gelukt. Judgment zit nu op toets 1."*
Trinkets: *"ik heb geen trinkets met een use"* (3 characters) → leeg is juist. Alles gezet in Midnight: *"werkt ook keurig"*.
Idee voor later (NIET gebouwd): de vraag/Update zegt het met naam als een plek de Single-Button Assistant houdt.

## ▶▶ 25 nov nacht (Bouwchat 24-11): Midnight 12 × 4 op Robs Prot Paladin — balken ≠ plaatje (eerdere stand)

Rob: *"volgens mij zet hij ze niety in mijn keyblock , ook niet na update"*, daarna *"het gaat niet om het block dat MH
laat zien maar mijn layout in game , onder dat block, dat komt niet overeen"*. Sparring zag op een klein screenshot
(NIET betrouwbaar): Shift-C (Word of Glory) leeg, Ctrl-X/Ctrl-V leeg. Robs retail-SV is van 24 nov 17:50, dus van vóór
de test: keyBlockProbe moet na zijn /reload nog gelezen worden (live knop per slot ↔ plan).
Al gerepareerd (GEMETEN in de code): het plaatje toonde bij de trinket-plekken altijd het icoon van de trinket die je
DRAAGT (slot 13/14), maar neerzetten zet alleen een trinket met een Use:-effect (UsableTrinkets, 5 okt). Nu dezelfde
regel op het plaatje (FixedWant), met een tooltip die de gedragen trinket noemt (KEYBLOCK_TRINKET_PASSIVE_FMT, 8 talen).
Of Robs trinkets echt passief zijn is NIET gemeten (de tooltip laat het zien). Open: de vergelijking slot voor slot.
⚠️ KEYBLOCK_FIXED_HINT ("you put this one on the key yourself") is verouderd: MH zet items zelf neer. Nog aanpassen.

## ▶▶ 24 nov avond (Bouwchat 24-11): Forever — macro-icoon volgde de vorm niet — ✅ GETEST (Rob: *"forever test ook gelukt met de druid, en nu weltrusten"*)

Rob: *"o wacht, het word wel maul en die andere maar de icoontjes zijn hetzelfde als die van niet in beer vorm !!"*
GEMETEN in `_forever_/WTF/.../93/Ima-Druiddude/macros-cache.txt` (23:41): de teksten kloppen ("MH 1" = `[bonusbar:3]
Maul; [nobonusbar:1/2/3] Wrath`, "MH F" Growl, "MH CTRL-1" Bear Form), maar elke herschreven MH-macro had een vast
icoon-nummer (136006 = Wrath …), de nooit herschreven nog INV_MISC_QUESTIONMARK. Oorzaak: ForeverEnsureMacro gaf bij
EditMacro het icoon van GetMacroInfo terug, en dat is bij een vraagteken-macro het icoon dat NU getoond wordt
(AFGELEID uit dat patroon) → #showtooltip bevroor. Sinds de eerste herschrijving van een blokmacro (Druid-blok 5 nov;
AFGELEID). Fix: EditMacro altijd met het gewenste icoon (cmd.icon of het vraagteken); eenmalige reparatie per character
(`ns.db.foreverMacroIconFixed[guid]`) in RefreshExisting; zelfde patroon gerepareerd in ForeverMacros.lua (handige
macro's) en InterruptMacros.lua (Midnight "MH+"-macro's). Trainervenster: KeyFor gebruikt nu de tabel van de gekozen
indeling (was altijd het oude blok → F2 i.p.v. Shift-C bij 12 × 4) en zegt "1 (Bear Form)" bij een vorm-toets (chip in
het overzicht: alleen "1", de vorm in de tooltip); dat deel is NIET offline getest. Offline: `bear_test.lua` 11/11.
De eerdere melding "krijg ze niet op mijn keys" vervalt (Sparring: was dit). De extra SPELLS_CHANGED-herschrijving blijft
(onschadelijk, vangt een spell uit een quest).

## ▶▶ 24 nov avond (Bouwchat 24-11): Forever Druid, Bear Form geleerd, toetsen volgden niet — gerepareerd, wacht op test

Rob: *"maar ik heb net mijn beer vorm gehaald maar krijg deze spells niet op mijn keys ?"* (Forever Druid ~10, 12 × 4).
Uitgezocht in de code: (1) een NIEUWE toets (Ctrl-1 = Bear Form) krijgt zijn macro alleen via de vraag "New for your
key block" (KeyBlock.lua CheckNew op SPELLS_CHANGED → MissingRows) of Update. Op 5.9.0 crashte MissingRows op deze
Druid (fout 1527, wees-macro Shift-Z; aa781a1 staat nog niet in een release), dus daar kwam géén vraag (AFGELEID; of Rob
op 5.9.0 speelde vraagt Sparring na). (2) Bestaande "MH <toets>"-macro's (1, F …) werden alleen herschreven op
LEARNED_SPELL_IN_SKILL_LINE / inloggen / na een gevecht; of dat event vuurt voor een spell uit een QUEST is niet gemeten.
Fix: ForeverBlock.lua herschrijft ook op SPELLS_CHANGED (één keer per golf, na 1 s; begint er een gevecht, dan erna).
(3) De gereserveerde Ctrl-1 (1b8a696) houdt alleen ANDERE spells weg; Bear Form zelf krijgt Ctrl-1 als eigen toets.
Offline: scratch `bear_test.lua` 6/6 (MH 1 = "[bonusbar:3] Maul; [nobonusbar:1/2/3] Wrath", MH F = Growl/Rejuvenation).

## ▶▶ 24 nov avond (Bouwchat 24-11): 12 × 4 voor MIDNIGHT (stap A2) — AF, wacht op test

Controle: 4× mh-research (scratch `review12_g1..g4.md`) + tweede Opus (`review12_final.md`, met eigen simulatie van
KeyBlockAllocate): 76 ACCEPT + HEALER A (Rob: *"a ja"*) in `Modules/KeyBlock12Exceptions.lua`, op spell-id (+ basis-id
bij vervangende talenten: het spellbook meldt die onder het id van de spell die ze vervangen). AFGEWEZEN o.a. Steady
Shot→D en Expunge→D (op id zou dat BM's Barbed Shot / Pres' Naturalize naar D sturen) → in de rol-data opgelost.
Rol-data (ook voor het oude blok, Rob: *"a ja"*): Steady Shot specs {254,255}; Expunge {1467,1473}; Resuscitate +270;
Ancestral Spirit alle Shamans; Resurrection (Priest, 2006) en Conjure Refreshment (Mage, 190336) nieuw; The Hunt +1480;
Warrior-stances (386164/386208/386196) en Paladin-aura's (465/32223/317920) als blockForm 1/2/3 (ids GEMETEN in
SpellName; castbaar in Midnight AFGELEID — zonder spellbook-treffer worden ze nooit geplaatst). Uitlegblad Midnight:
KEYGUIDE_INTRO/BAR_A/BAR_SHIFT_MN (8 talen). Offline: `keys12_mn_test.lua` 2688 controles 0 fout, plus vaste
steekproeven (Prot Paladin 4 = SotR, Z Ardent Defender, X Divine Shield, Ctrl-R Redemption; Holy C = Lay on Hands; MW
C = Life Cocoon; Pres C = Rewind; Blood Z = AMS; Enh 4 = Lightning Bolt; Disc Ctrl-R = Resurrection; Arcane Ctrl-R =
Conjure Refreshment). Oude blok verschuift alleen door de nieuwe rol-data: 1165/71 → 1171/91 (stances/aura's houden
Ctrl-1/2/3 vrij bij Warrior/Paladin, overloop gaat dan naar D).
NIET gemeten / open (review12_final.md DATA): welk id het spellbook meldt bij een spec-vervanging (Healing Wave/8004,
Mind Flay/585 …; één spellbook-dump op een Resto Shaman of Shadow Priest beslist het); ids alleen in survivalId zijn
onzichtbaar voor de id-lookup (Holy Divine Protection 498, Blink …) → op een niet-Engelse client ongeclassificeerd;
Whirlwind Arms 1680 / Templar's Verdict 85256-ids; Eternal Flame blockAs[65]; Naturalize bindKey V; Raze / Red Moon /
Rushing Wind Kick vallen waarschijnlijk via het basis-id goed (AFGELEID).

## ▶▶ 24 nov avond (Bouwchat 24-11): 12 × 4 voor MIDNIGHT (stap A2) — tabel gebouwd (eerdere stand)

Rob via Sparring, letterlijk: *"A A A"* = 1a (rol-naar-toets-tabel uit de bestaande KeybindRoles, daarna mh-research per
spec + tweede Opus-controle, uitzonderingen per spec), 2a (Ctrl-F combat potion, Ctrl-Z health potion, Ctrl-X trinket 2,
Ctrl-C healthstone, Ctrl-V trinket 1), 3a (Blizzards willekeurige favoriete mount). Keuze 1a "alleen Forever" VERVALT.
Gebouwd (`KeyBlock.lua`): LayoutName zonder Forever-poort; BLOCK_12R (Ctrl-rij Midnight); ANCHOR12/CATEGORY12/OVERFLOW12
+ ANCHOR_ORDER12_HEAL (healers: heals vóór de defensives, C = grote heal); KeyBlockAllocate schaduwt de tabellen bij 12x4
in Midnight; `free()` eist nu dat de toets in de indeling BESTAAT (bindKey "5"/"Shift+F1" lekte anders naar een
niet-bestaande toets; oud blok GEMETEN ongewijzigd: 1165 geplaatst / 71 over, voor en na); FixedWant `combatpotion`
(ConsumablesWowhead combatPotion) en `trinket2`; geen tweede-trinket-overflow als Ctrl-X vast is; login-waarschuwing,
`/mh block style`, knop Layout en "Why these keys?" nu ook in Midnight (KEYGUIDE_BAR_CTRL_MN / _EXTRA_MN).
`ForeverKeyExtras.lua` ook in Midnight: Shift+Spatie = macro `/dismount [mounted,noflying]` + `/run if not IsMounted()
then C_MountJournal.SummonByID(0) end` (nooit afstijgen in de lucht), alleen als je een bruikbare mount hebt;
NEW_MOUNT_ADDED; eigen vraagtekst KEYEXTRA_ASK_MN_FMT. Offline: scratch `keys12_mn_test.lua` 40 specs × 2 indelingen,
2734 controles 0 fout (geen spell op een oude-alleen-toets of vaste plek, interrupt op E, healer-C = heal waar
heal_sustain bestaat); totaal 12×4 1150 geplaatst / 86 naar blok D. Dump per spec: scratch `keys12_mn_dump.txt`.
GEZIEN in de dump, voor de controle: Holy Paladin C = Blessing of Protection (zijn heals zijn main_rotation, geen
heal_sustain); Lay on Hands op Ctrl-R (heal_ooc). Open: controle per spec (mh-research + tweede Opus), uitzonderingen,
itIT-vertalingen (alle 12×4-teksten missen itIT: Forever had geen it-client), TESTLIJST/IDEEEN/SITE_SEIN.

## ▶▶ 24 nov avond (Bouwchat 24-11): buff-knop cast op jezelf (stap B) — wacht op test

Rob (Druid, Thorns): *"Elke keer als die in beeld komt, moet ik eerst mezelf aanklikken en dan pas kan ik op het knopje
drukken."* Oorzaak GEMETEN in de code: `MissingBuff.lua` ApplySecureCast zette bij een spell alleen type + spell, geen
`unit`; dan cast het spel een helpful spell op je target, en wacht op een klik als dat een vijand is. Fix: de entries
van de Forever-buffs (`ForeverBuffs.lua`: ontbrekend + "runs out soon") krijgen `self = true`, en de knop zet dan
`unit = "player"`; `unit` wordt op elk pad eerst gewist. Pet-spells (Call/Revive Pet, demonen) en het ally-macropad
blijven zoals ze waren. Midnight (retail-entries) onveranderd. Groepsbord: de eigen rij zet al `unit = row.unit`
(= player), GEMETEN in `ForeverReadyBoard.lua` (CastButton unit). Offline: scratch `selfbuff_test.lua` 9/9.

## ▶▶ 24 nov avond (Bouwchat 24-11): knop "Layout" in het toetsenblok (stap A1) — wacht op test

Rob via Sparring (letterlijk in IDEEEN). `KeyBlock.lua`: `f.styleBtn` (TOPRIGHT -150,-40, 300 px, onder New spells; de
bovenste rij zit vol, de intro maakt rechts 470 px vrij), `ns.KeyBlockCanUse12` (nu: Forever + keys12),
`ns.KeyBlockAskSwitchStyle` (StaticPopup MH_KEYBLOCK_SWITCH, teksten bij het tonen, twee teksten: geplaatst / niet
geplaatst) en `ns.KeyBlockSwitchStyle` (undo als het blok stond → KeyBlockSetStyle → Place als het stond; nooit in een
gevecht; weigert SetStyle, dan wordt er niets neergezet). Hooks van ForeverKeyExtras werken mee (Place = de extras-vraag,
naar oud = extras weg). Teksten 7 talen (KEYBLOCK_STYLE_BTN_FMT, KEYBLOCK_SWITCH_*). Offline: scratch `switch_test.lua`
16/16. Midnight: knop verborgen tot stap A2 (12 × 4 voor Midnight). Daarna B (Thorns-knop), dan A2.

📌 Na 5.9.0 (site-chat, bijvangst): nlNL noemde het venster in 4 regels "Do this now" i.p.v. de nl-titel "Doe dit nu"
(SET_FOREVER_WEAR_TITLE/_DESC, FTALENT_SW/_DESC) → nu "Doe dit nu". GEMETEN: daarna 0 keer "Do this now" in nlNL.lua.
Gaat mee in de volgende release.

## ▶▶ 24 nov avond (Bouwchat 24-11): RELEASE 5.9.0 getagd (Rob via Sparring, letterlijk: "release 5.9.0")

Geen beta. Versie 5.9.0 in beide toc's; CHANGELOG_590_1 t/m _8 (enUS) + Changelog.lua; `RELEASE_NOTES.md` byte-gelijk aan
`docs/CURSEFORGE_5.9.0.md` (5476 bytes, LF, GEMETEN met een scratch-vergelijking); CHANGELOG.md; SITE_SEIN: de regels
van 23-24 nov op "getagd" + een release-regel. Alleen Forever in de spelerstekst; de Midnight-voorbereiding op 12.1.7
werkt pas op een 12.1.7-client en staat er dus niet in (Sparring: alleen noemen als spelers er nu iets aan hebben).
✅ Tag v5.9.0 op 1bdc468. Release-run 45451928608 geslaagd (Retail, Forever, verify). GEMETEN in de CF-API (24 nov 17:53
UTC): v5.9.0 (id 9795543, 12.0.7-12.1.7) en v5.9.0-forever (id 9795583, 1.60.1), allebei Release, status 4; de
GitHub-release heeft beide zips. Wago NIET apart nagemeten (de run meldt Retail en Forever geslaagd). SITE_SEIN op
"staat op CurseForge".
✅ `CURSEFORGE_DESCRIPTION.md` bijgewerkt (Forever: 12 × 4 + Why these keys? + 5/Shift-Space, groepscheck, QuestieDB,
Do this now: upgrades, tasplekken, How you play-knop; How you play noemt je toetsen; credit-regel QuestieDB).
✅ 25 nov: Rob heeft de beschrijving op de CF-projectpagina geplakt (via Sparring, letterlijk: *"En cursewords had ik de
nieuwe beschrijving geplakt."*). ✅ 25 nov: changelog op CurseForge netjes (Rob via Sparring: *"En ook de changelog was
goed."*).

## ▶▶ 24 nov avond (Bouwchat 24-11): Lua-fout KeyBlock.lua:1527 (Druid, na harde uitval) GEREPAREERD — wacht op test

Rob, Forever Druid, bij inloggen na een onverwachte herstart (de kat zette de pc uit): `KeyBlock.lua:1527: bad argument
#1 to 'tostring' (value expected)`, via 1812 (de nieuwe-spell-vraag) → MissingRows. Oorzaak GEMETEN in de locals: slot
145 (SHIFT-Z, bar B) = ("macro", 0), en `GetActionText` gaf GEEN waarde terug (geen nil: tostring() zonder argument
gooit "value expected"). De knop wil "MH SHIFT-Z" (offline, Druid 12×4); GEMETEN: die macro staat NIET in
`_forever_/WTF/.../93/Ima-Druiddude/macros-cache.txt` (17:18) noch in `.old` (17:00), wel de andere MH-macro's (MH 1, 2, C,
F, SHIFT-E, SHIFT-X). AFGELEID: die macro werd die sessie gemaakt en ging verloren bij de uitval (macro's worden pas bij
uitloggen weggeschreven); de knop wees daarna naar niets. Fix: `pcall(GetActionText)` + alleen een echte naam telt, en
een macro-knop met id 0 zonder naam telt als LEEG, zodat de nieuwe-spell-vraag/Update de goede macro terugzet
(PlaceAction wisselt de kapotte eraf). Een macro met naam maar id 0 (bv. FishFry) blijft "bezet". GEMETEN ook: dit is
de enige plek waar GetActionText in tostring() ging (de andere 8 vergelijken of geven door). Locals ook: macro's melden
in Forever de spell-id van #showtooltip als id ("macro:5185" = Healing Touch). OVERFLOW = de lijst van het oude blok, ook
bij 12×4: sleutels die 12×4 niet heeft (F3, SHIFT-F1) worden overgeslagen (byKey nil), de rest bestaat in beide; maar
MissingRows filtert de CTRL-vormtoetsen niet zoals PlacePlan (hasForms) → kan bij een Druid zonder vorm een nieuwe
spell op Ctrl-1..3 voorstellen. → ✅ DAARNA OOK GEREPAREERD (Sparring: *"neem het mee nu, vóór de release"*):
MissingRows slaat nu dezelfde toetsen over als het neerzetten (hasForms uit res.occ, zoals de tweede trinket) én, in
Forever, elke toets die de class-tabel (ClassTable().keys, huidige indeling) voor iets bedoelt; zo blijft de toets van een
onbekende vorm leeg en niet fout. Gevolg in Forever: staat de eigen toets van een nieuwe spell vol met iets van de
speler, dan wacht de spell (geen plek) in plaats van op een andere vaste toets te landen. Offline: scratch
`orphan_test.lua` 12/12, met tegencontrole (zonder de fix landt hij op CTRL-1).

## ▶▶ 24 nov avond (Bouwchat 24-11): groepsbord — titel onder het sluitkruisje GEREPAREERD — wacht op test

Rob (nl, solo op zijn Druid): *"Het afsluitknopje loopt door de tekst heen."* Oorzaak: de breedte kwam alleen uit de
kolommen (min. 300 px), en de Forever-stijl zet een groter lettertype NA de eerste Render. Fix (`ForeverReadyBoard.lua`):
breedte ≥ titelbreedte + 54 px (gemeten met GetStringWidth); 0,25 s na het tonen nog eens meten en zo nodig opnieuw
Render (het bord hangt aan zijn midden, dus breder = alle cellen schuiven; Render zet de klikknoppen opnieuw).
Langste titel per tekens: de "Gruppencheck: Buffs und Verbrauchsgüter" (39); de meting dekt elke taal. Offline 44
controles (scratch readyboard_test.lua; de stub-HookScript verving het oude script, nu rijgt hij zoals het spel).
Punt 2/3 van Sparring vervielen (Rob zat op de Druid; *"bij die andere had ik inderdaad ook nog geen Hearthstone
geleerd"*). Regel healthstone-kolom: alleen met een Warlock in de groep (jij telt mee). GEMETEN in Syndicator-SV: de
Minor Healing Potion (118, 2 stuks) zat in de tas van een Mage, niet van de Warlocks.

## ▶▶ 24 nov avond (Bouwchat 24-11): 12 × 4 extra toetsen (5 = interact, Shift+Spatie = mount) — wacht op test

📌 Fix daarna (Rob: *"het is nederlands (dat klopt) met engelse set them en no thanks eronder"*): de knoppen van een
StaticPopup die bij het LADEN met `ns:L` gevuld worden, zijn Engels, want het gekozen pack (nlNL is handmatig) is dan nog
niet actief. GEMETEN met grep op `button1 = ns:L(` (alle vensters): de vaste vorm is "teksten bij het tonen zetten"
(FirstRun, Survey, MaxLevelWelcome, KEYBLOCK_NEW). Afwijkend waren MH_KEYEXTRA_ASK en MH_KEYBLOCK_LAYOUT_MISMATCH
(beide vandaag) → nu bij het tonen. Ook MH_FOREVER_MYLAYOUT_RELOAD (7 nov) had vaste Engelse tekst + knoppen → nieuwe key
FMYLAYOUT_RELOAD_TEXT (7 talen) + bestaande KEYBLOCK_BTN_RELOAD/KEYBLOCK_NEW_LATER. Ter info: Shift-Spatie stond bij Rob
op Toggle Score Screen; de vraag liet dat zien. Test: 28 controles (ook: knoppen volgen een taal die na het laden komt).

Rob via Sparring: *"En shift spatie is op zich wel een goed idee voor de mount. En de interact toets, nou, doe maar een
voorstel."* → voorstel → *"Ja, ik volg advies dus A. Je trekt op 5 en dat punt blijft ook werken."*
GEMETEN vooraf: `INTERACTTARGET` bestaat in Forever (GlobalStrings 1.60.1.71091; ook INTERACTMOUSEOVER); Robs
`_forever_/WTF/Account/JOEYWHATEVER/bindings-cache.wtf`: `NUMPADDECIMAL INTERACTTARGET`, `5 NONE`, `` ` TOGGLECHARACTER0``
(niet door MH gezet: 0 treffers, tegencontrole 7); Spatie/Shift+Spatie niet in het bestand = spelstandaard (niet leesbaar
uit dat bestand; de module vraagt het live met GetBindingAction).
Gebouwd: `Modules/ForeverKeyExtras.lua` (nieuw, beide toc's): één vraag (StaticPopup na het neerzetten van 12 × 4 of
bij inloggen, met wat 5 en Shift+Spatie nu doen), `/mh block extras [on|off]` + diagnose. 5 = INTERACTTARGET als extra
toets; Shift+Spatie = `MACRO MH Mount`, een macro PER CHARACTER (`/dismount [mounted]` + `/cast [nomounted] <mount>`),
alleen als het character een mount kent (anders blijft Shift+Spatie staan tot SPELLS_CHANGED er een brengt). Undo zet
per toets terug wat er stond (`ns.db.keyExtras.prev`) en wist de macro; terug naar het oude blok = automatisch undo
(hook op KeyBlockSetStyle); na een blok-undo pakt 5 interact terug (de undo gaf 5 aan de oude blokknop).
Snelste mount: `Modules/ForeverMountData.lua` (GEGENEREERD uit Mount → MountTypeXCapability → MountCapability, 140
mounts; 4 AQ-tanks eruit, alleen in AQ40): snelheid 2/1 + nodige spell (racial riding). NIET gemeten: of Forever die
racial riding als bekende spell toont → valt terug op "negeer de eis" als je wel een mount kent maar er geen door de
check komt; of C_MountJournal bestaat (bewaakt; favoriet telt mee als het er is); of een binding `MACRO <naam>` een
per-character macro vindt (AFGELEID: binding op naam). Uitlegblad: deel EXTRA (KEYGUIDE_HEAD/BAR_EXTRA). Teksten 7 talen.
Offline: 26 controles (scratch `keyextras_test.lua`). Ook afgevinkt deze ronde: Fix it now (Druid), tas-getal + kleuren,
How you play-knop; groepsbord → later testen op hoger level; Warrior toets 3 + Priest-gids geaccepteerd (niet apart getest).

## ▶▶ 24 nov avond (Bouwchat 24-11): "Do this now" — knop How you play + vrije tasplekken — ✅ GETEST (Rob: *"Ja, beide zijn helemaal goed."*)

Rob via Sparring, letterlijk: *"kunnen we hier onder ook een knop how to play toevoegen en in het rijtje van gold aan de
linkerzijde het aantal open tas plaatsen :)"*, op de samenvatting *"ja"*. Gebouwd in `ForeverDoNow.lua`: `f.btnPlay`
(tekst `FOV_TAB_PLAY`, opent `ns.ShowPlayCardWindow`) als laatste knop in de rij; `BagText` links van `f.money`, ververst
op `BAG_UPDATE_DELAYED` (zelfde event-frame als PLAYER_MONEY). Telling = `ns.ForeverFreeBagSlots` (de FreeSlots van
`ForeverWarnings.lua`, bag family 0); oranje bij ≤ max(5, `ns.ForeverBagWarnAt()`), rood bij 0; niet leesbaar = leeg.
Nieuwe key `FDONOW_BAGS_FREE_FMT` (en, nl, de, fr, es, pt, ru). Offline: telling 15 bij 4 gewone tassen + een pijlkoker.

## ▶▶ 24 nov avond (Bouwchat 24-11): How you play volgt de gekozen indeling — ✅ GETEST (Rob: *"en in how to play staat get nu goed"*)

Rob, letterlijk: *"ik zie een fout in how to play , de oude keyblock staan er nog in"* (open punt 1 van vanochtend; trainer:
*"trainer gaat goed"*). Gebouwd (`ForeverHowToPlay.lua` `LiveKeys`/`KeyMap`): bij 12 × 4 worden bij het TONEN alle
blok-toetsen in de teksten (8 talen ongewijzigd) vervangen: oude toets → zijn spells in `keys` → waar die in `keys12`
staan (terugval nu = die toets; geen plek = "blok D" in de taal van de tekst); T/Shift-T/G → Ctrl-Z/Ctrl-C/Ctrl-V.
Vormen die gelezen worden: `**K**` overal, `(K)` en `(K, …)` alleen in "Simple order" (elders is "(4)" een level),
"<op> K" met het voorzetsel per taal (een kaal cijfer alleen voor een leesteken/haakje). Oud blok = tekst onveranderd.
Venster + overzichtspagina (ForeverHowToSections). Andere schermen: GEMETEN 0 vaste blok-toetsen in de schermteksten
(tegencontrole 116 in HowToPlay). Offline: 151 controles (scratch `howto_keys_test.lua`).

## ▶▶ 24 nov avond (Bouwchat 24-11): trainerpijl naar Mirket i.p.v. Dhugru GEREPAREERD — ✅ GETEST (Rob: *"trainer gaat goed"*)

Rob (Horde Warlock, Razor Hill), letterlijk: *"Ik sta op dit moment bij mijn warlock trainer, maar hij stuurt me een heel
andere kant op."* en *"ja die naam staat er"* (Dhugru Gorelust). Oorzaak GEMETEN in zijn SV: `foreverTrainerCap[3172] =
{ cap = 6, seen = 6 }`; ook Kardris 14/14, Narm 12/12, Sian'tsu 16/16, Nartok 4/4: de trainerlijst toonde alleen spells
tot zijn eigen level, dus "hoogste level in de lijst" = zijn level, geen trainer-cap. Reparatie (`ForeverTrainer.lua`
TrainerCap): een gemeten cap telt alleen als hij lager is dan het level waarop hij gemeten is (Mai'ah 6 op 10 = echt),
en nooit lager dan de vaste cap uit ForeverTrainerSpots (Lanka 1 op 2). `/mh trainer check` noemt nu welke trainers
overgeslagen zijn, met cap en bron. Offline 10 gevallen (scratch `trainercap_test.lua`, Robs eigen SV-waarden).
Open: waarom Un'Thuwa wél 60 gaf op level 10 (de lijst toonde toen hogere spells) is niet uitgezocht; de regel is er veilig voor.

## ▶▶ 24 nov avond (Bouwchat 24-11): terugval zonder dubbele + "Later"-geheugen — wacht op test

Rob (via Sparring 24-11), letterlijk: *"Waarom krijg ik deze, terwijl die ook al op 3 gezet wordt? En als ik hem daar
weghaal, even later krijg ik weer terug dat hij weer daarheen moet. Beetje verwarrend."* Gebouwd:
- `ForeverBlock.lua` `FallbackHeld`/`FirstFor`: een spell die een toets als terugval houdt (latere naam in de lijst)
  komt niet ook op zijn eigen toets; is de eerste naam geleerd, dan schuift hij terug. Geldt alleen voor de 4 terugvallen
  (GEMETEN: Warlock 3/Shift-2, Rogue 3/Shift-3, Paladin 4/Shift-4 en V/Shift-F); het oude blok heeft er geen.
- `KeyBlock.lua`: "Later" (OnCancel) onthoudt per character elk paar toets + spell (`ns.db.keyBlockDeclined`, macro's
  met de spellnaam, zodat een nieuwe rang niet opnieuw vraagt maar een nieuwe spell wel). Update wist dat geheugen.
- Offline: 16 gevallen (scratch `fallback_test.lua`), keys12 2252, stale/login 27. NIET in het spel.

## ▶▶ 24 nov avond (Bouwchat 24-11): uitlegblad "Why these keys?" (12 × 4) GEBOUWD — ✅ GETEST (Rob: *"JA ZIET ER GOED UIT"*; Shift+scroll/dichtklikken niet genoemd, open)

Rob via Sparring 24-11, letterlijk: *"kunnen we ook een soort blad even maken, waarbij we de users uitleggen waarom we welke
knop waar gezet hebben"* + *"… Dat gewoon voor iedereen weet dat een heal altijd op die knop staat …"*; heal-keuze *"a"*
(C = grote heal of grote defensive, Shift-C = snelle heal; niets verschoven). Eerlijk bij de toetsen die per class
verschillen ("vaste hulp-plek van je class": F, Shift-3/R/Z/X, Ctrl-4/Q/E). Gemeten per toets over 9 classes:
`docs/forever/KEYBLOCK12_TAKEN.md`. Gebouwd: `ns.ShowKeyBlockWhy` (KeyBlock.lua), venster `MidnightHelperKeyBlockWhy`
(in SCALABLE_WINDOWS), knop `f.whyBtn` bovenin het toetsenblok-venster (x 475; alleen Forever + 12×4), teksten
KEYGUIDE_* (en/nl zelf, de/fr/es/pt/ru mh-writer). Layout meet de hoogtes opnieuw na de Forever-stijl. Offline: venster
bouwt en klapt. Site-pagina: later via de site-chat (SITE_SEIN).

## ▶▶ 24 nov avond (Bouwchat 24-11): één indeling voor alle Forever-characters (Rob: *"advies a"*) — wacht op test

GEMETEN: Forever-toetsen gelden voor het hele account (één `bindings-cache.wtf`; `bindingSet = 1` in Robs SV; `style` ook
account-breed in MidnightHelperDB), de balken per character. Gebouwd (KeyBlock.lua): het neerzetten bewaart
`snap.layout`; bij het inloggen (Forever, 8 s, niet in gevecht, één keer) een chatregel + StaticPopup
`MH_KEYBLOCK_LAYOUT_MISMATCH` als dit character met de andere indeling staat ("Fix it now" = undo + neerzetten;
`/mh block fix` doet hetzelfde). `/mh block style` zegt erbij dat toetsen voor alle characters gelden. `/mh block why`
noemt "placed on this character". Oude snapshots zonder `layout` = het oude blok. Paladin V = Repentance, anders Turn
Undead (24); level 8-23 heeft hij geen andere CC (Hammer of Justice staat bewust op E). Offline getest (login-check:
4 gevallen, keys12 2252), NIET in het spel. Bevestigd uit de code (AFGELEID): na `/reload` zet "Update" of de
nieuwe-spell-vraag Immolate op toets 3 (lege plek met een macro-wens). Teststappen: TESTLIJST "24 nov (avond)".

## ▶▶ 24 nov (Bouwchat 24-11): 12 × 4 GEREPAREERD na Robs Warlock-test — wacht op hertest

Rob testte 12×4 op zijn Warlock (screenshots via Sparring 24-11). Fout 1: op balk 5/6/7 stonden nog de oude toetsen
(5, T, G, F1-F4, Shift-T, Shift-F1). Oorzaak (GEMETEN in de code, AFGELEID voor Robs account): neerzetten bindt alleen
de toetsen van de gekozen indeling; oude toetsen die nog naar een blokknop wijzen (account-bindingen van een eerder
neerzetten, misschien op een ander character, dus niet in de undo van de Warlock) bleven staan, en een knop toont zijn
eerste toets. Reparatie: `StaleBlockKeys()` in KeyBlock.lua; neerzetten maakt ze los en zet ze in de snapshot (undo
zet ze terug); `/mh block why` noemt ze (ook in de SV: `dump.staleKeys`). Offline: de 9 toetsen van de screenshots
gevonden, F2→kaart blijft.
Fout 2: Summon Imp 4× → pet-commando's tonen nu hun label + icoon (`spell.label/iconTex`, ook in de tooltip); de 4e
(Alt, block D) is bewust. Klein: "Summon Demon" (vermoedelijk een flyout, AFGELEID) telt niet meer als onbekend
(flyouts overgeslagen + naam in Warlock `listed`). Vraag 3 (Immolate op Shift-2, toets 3 leeg tot Agony op level 8):
voorgelegd aan Sparring, niets veranderd. Teststappen: TESTLIJST "24 nov (later)".
- 🔧 Vervolg (Sparring: *"ja, doe jouw advies … Kijk ook of hetzelfde gat … bij andere klassen voorkomt"*): terugval op
  rotatietoetsen waar de spell pas later bij de trainer komt: Warlock 3 = Agony, anders Immolate; Rogue 3 = Mutilate/
  Hemorrhage, anders Shank (24); Paladin 4 = Hammer of Wrath (44), anders Exorcism (20). Gemeten met scratch `gap_test.lua`
  (per level 1-60, alleen trainerlevels; begin-spells en talenten tellen daar als "niet geleerd", dus een deel van de
  overige meldingen is nep). Niet aangepast: Warrior 4 (4 levels, per stance), Shaman 4 (Fire Nova vraagt een fire totem,
  pas op 20), Druid 4 (4 levels, cat), en alle vaste-taaktoetsen (E R Z X C V). Te bekijken: Paladin V leeg 8-60 terwijl
  Purify op Shift-V staat (welke CC staat op V?).
- 📏 Bindingen GEMETEN: Forever heeft één `bindings-cache.wtf` op accountniveau, geen per character (25 character-mappen,
  tegencontrole: daar staan wel macros/config). Gevolg en advies: zie bericht aan Sparring; nog niets aan veranderd.

## ▶▶ 24 nov (Bouwchat 24-11): `data/keyblock_specs.json` opnieuw gemaakt — ✅ AF (open punt NEXT_SESSION_ARCHIVE r.7171)

Sparring 24-11, letterlijk: *"Ja: run keyblock_specs, commit en push"*. Het bestand was van 6 okt; 6 specs schoven door
bewuste datawijzigingen uit oktober (GEMETEN, vergeleken met de oude versie): Holy Paladin (Avenging Crusader F1, Divine
Toll Shift-3, Holy Prism Shift-F1; Redemption en Intercession nu zonder plek door de Rites van 22 okt), Prot Paladin,
Assassination, Shadow (Halo → Halo (Shadow)), Vengeance en Devourer (The Hunt niet meer in hun lijst). De indeling zelf
(`layout`) is ongewijzigd. Gebruikt door de site-spiekbrief (branch "keyblock"); Sparring seint de site-chat.

## ▶▶ 24 nov (Bouwchat 24-11): Forever-toetsenblok "12 × 4" GEBOUWD (1a + 2b) — wacht op Robs test

Rob via Sparring 24-11, letterlijk: *"ik vind namelijk zijn uitleg goed en wil onze versie ook zo hebben van keybinds qua
knoppen"* (Bellular-video) en *"uiteraard volg ik je advies e laat een agent uitzoeken welke spells logisch zijn per class
zodat dat automatisch kan worden toegepast"*. 1a = alleen Forever, 2b = schakelaar, oud blok standaard. VERVALT: Rob keurt
niet meer elke klasse-tabel goed; het onderzoek bepaalt, Rob test.
- 🧪 `KeyBlock.lua`: BLOCK_OLD + BLOCK_12, `BLOCK` wordt in place gevuld door `SyncLayout()` (in Build, Ensure, ArmBar1);
  het plaatje vindt knoppen nu op plek (`f.slotAt`), niet op toetsnaam. `/mh block style old|12x4` (`ns.KeyBlockSetStyle`;
  weigert als het blok geplaatst is, in gevecht, of zonder keys12 voor de class). `ns.db.keyBlock.style` (account-breed).
  `/mh block why` toont "layout: …" en per toets "12x4: <reden>".
- 12×4: A = 1-4 Q E R F Z X C V, B = Shift, C = Ctrl (1-4, Q, E, R + vaste items Ctrl-F bandage, Ctrl-Z health potion,
  Ctrl-X mana potion, Ctrl-C healthstone, Ctrl-V trinket), D = Alt (= block D, Alt-G i.p.v. Alt-Z; Sparring: *"akkoord"*).
  `FixedWant`: in Forever nu de gemeten lijsten (ForeverReadyBoardData hpot/mpot/hs/bandage) — geldt ook voor T/Shift-T
  van het OUDE blok (daar vond hij in Forever niets: retail-data).
- `ForeverBlock.lua`: ClassTable geeft in 12×4 een view met `keys12`; oude spells zonder 12×4-plek gaan VOOR toBlockD naar
  block D (tweede controle: anders vallen de armor-buffs eraf op 60). `why` telt niet als spellnaam.
- 9 tabellen `keys12` (onderzoek 3× mh-research, `docs/forever/KEYBLOCK12_<CLASS>.md`; tweede controle mh-research
  `KEYBLOCK12_REVIEW.md` → 3 wijzigingen doorgevoerd: Mage 4 = Fire Blast / Shift-3 = Pyroblast, Priest wand `bang`,
  Warlock 3 = Agony / Shift-2 = Immolate). Bandage-id's: `docs/forever/BANDAGES_FOREVER_2026-11-24.md` (12 algemeen;
  16 battleground-bandages bewust NIET).
- Offline 2248 controles goed (scratch `keys12_test.lua`: toetsen, namen, dubbelen, 255 tekens, niets kwijt), NIET in het spel.
- Open: How you play noemt nog de oude toetsen (5, F2, T/Shift-T/G; review r.33/153/176/311/381). Stap 2 (Sparring
  *"akkoord"*): mount Shift+Spatie, interact-toets, sit/sheathe/character na een vraag. Geen knop in het venster (geen
  ruimte bovenin): alleen het commando. Battle Shout-duur niet gemeten; Hammer of the Righteous: bron onbekend.

## ▶▶ 24 nov (Bouwchat 24-11): Forever-groepsbord GEBOUWD (optie A) — wacht op Robs test

Rob via Sparring 24-11, letterlijk: *"Ja maak maar"* en op *"Bedoel je doe jouw advies (A)?"*: *"ja"*.
- 🧪 `Modules/ForeverReadyBoard.lua` + `ForeverReadyBoardData.lua` (NIEUW, beide toc's; alleen actief in Forever = herstart).
  Neemt in Forever de namen `ns.ShowConsumableBoard` (`/mh readyboard`, `/mh board`, NavSearch, Launchpad) en
  `ns.PrintConsumableReadyCheck` (`/mh readycheck` = diagnose → `ns.db.foreverReadyProbe`) over; Midnight-bestanden
  staan niet in de Forever-toc, dus geen botsing (GEMETEN met grep). Nieuw: `/mh readyboard auto on|off` (Core.lua).
- Eigen kolommen: elixer/flask (75), eten (Well Fed + 5 andere namen; vissen/kruiden/snelheid tellen NIET), wapen
  (`ns.ForeverTempEnchant` + `ns.FOREVER_WEAPON_ITEMS`, nieuw export in ForeverBuffs.lua), hpot, mpot (mana-classes),
  hs (alleen met Warlock). Buffs: int (alleen mana-classes), fort, motw, bless (elke blessing telt; klik = laatst
  gecaste, anders de eerste die je kent). Een kolom alleen als die class in de groep zit.
- Andermans auras: één scan per speler; te ver weg / offline / geheime id / in gevecht = vraagteken, nooit rood.
  Gaat dicht bij PLAYER_REGEN_DISABLED. Klikknoppen op UIParent, met de hand geplaatst, sluiten mee (lessen
  ConsumableReadyBoard). Eigen Shift+scroll → `tools/window_check.py` EXEMPT (reden: knoppen moeten mee).
- Id's: mh-research, `docs/forever/CONSUMABLES_FOREVER_2026-11-24.md` (wowf 71037). NIET meetbaar: Battle/Guardian-
  elixers (niet in de clientdata → één kolom), welke healthstone de server maakt, of de SoD-potions bestaan.
- Offline 43/43 (scratch `readyboard_test.lua`), NIET in het spel. Vertalingen de/fr/es/pt/ru: mh-writer (niet
  nagekeken door een moedertaalspreker). GEMETEN (SpellName wowf 71037): Well Fed 1248406 = Satt / Bien nourri / Bien
  alimentado / Bem Alimentado / Сытость; flask (17626) = Fläschchen / Flacon / Frasco / Frasco / Склянка (ru was
  "настой", gerepareerd). Uit de packs, niet gemeten: Healthstone, Warlock, potions, ready check, "Paladin-blessing". Teststappen: TESTLIJST "24 nov — FOREVER: groepsbord".
- Niet gebouwd (optie B, later): andermans tassen via addon-berichten. Divine Spirit/Shadow Protection niet op het bord.

## ▶▶ 24 nov (Bouwchat 24-11): twee wachter-fixes na de Forever-hotfix van 23 nov + handoff gesplitst

Opdracht Sparring 24-11, letterlijk: *"ga door met de kleine dingen. (1) Splits NEXT_SESSION.md eerst. (2) Fix Forever
Warrior toets 3 … (3) Zet de Priest-gids recht … GEEN tag of release."* Grondslag Rob 13 nov *"ga voortaan door"*.
- 🔧 **Warrior toets 3** (API-wachter [MOET GEFIKST] 24 nov): `ForeverBlock.lua` `TALENT_GATED` — Mortal Strike telt voor
  een toets alleen als node 105941 (tree 1117) gekocht is; onleesbaar talent = oude spellbook-antwoord. Alleen de toetsen;
  `ns.ForeverKnownSpell` (trainer, Do this now …) ongewijzigd. `/mh block why` toont de beslissing; ververst nu ook op
  TRAIT_CONFIG_UPDATED (pcall). Offline 9/9 (scratch `warrior_gate_test.lua`), NIET in het spel. Rest (AFGELEID): een al
  geplaatste "MH 3" van een Warrior met alleen Mortal Strike blijft staan (nieuwe body = niets → geen herschrijving).
- 🔧 **Priest-gids Chastise** (content-wachter 24 nov): regel "Healing in Shadowform" zonder Chastise, in 8 talen
  (`ForeverHowToPlay.lua:315` + 7 locales). Fear Ward-helft blijft (niet in de hotfix; AFGELEID dat hij klopt).
- Teststappen: TESTLIJST "24 nov — FOREVER: twee kleine fixes". Party-consumablevenster: nog NIET, sparring legt het voor.


## 📌 Ouder, maar nog niet af — staat in `docs/NEXT_SESSION_ARCHIVE.md`

De historie is afgesplitst (2 sep en 6 nov). Deze secties lezen daar nog als OPEN, dus ze
staan hier bij naam — een openstaand punt mag niet verdwijnen door oud te zijn.

⚠️ Bewust te ruim: de lijst kijkt alleen naar de kop. Is een punt af, zet een stukje van de
kop met de reden in `KNOWN_DONE` in `tools/split_handoff.py` en draai
`python "<repo>/tools/_probe.py" run split_handoff --reindex --write`. Niet met de hand
bewerken: dan loopt de lijst binnen een week uit de pas met het archief.

- ▶▶ VOLGENDE BOUWCHAT (21 nov, avond): nieuwe Forever-reeks "leren van Polestar/FlowUp" — punt 4 en 2 GEBOUWD, 1 = B, 3 rust
- ▶▶ VOLGENDE BOUWCHAT: Forever-overzicht "D" — stap 1 en 3 gebouwd; stap 2 wacht op Robs screenshots (20 nov, avond)
- ⏭️ VOLGENDE BOUWCHAT (Bouwchat 17-11 (3) draagt over; laatste commit 542715e, alles gepusht, geen release)
- ▶ OPEN OPDRACHT: `/mh selftest` + vensterlijst (opdracht 7, sparring-chat; Rob: "niks later", dus al op 11 nov)
- 🔜 OPEN na 28 okt (overdracht naar de bouwchat van 29 okt)
- 🔜 OPEN na 26 okt (overdracht naar de bouwchat van 27 okt)
- 🔜 OPEN na 23 okt (overdracht naar de bouwchat van 24 okt)
- 🌅 VOLGENDE CHAT EERST (stand eind 16 okt; bouwchat gearchiveerd door Rob)
- 🌅 16 okt — MORGEN EERST (Rob, 15 okt nacht: "onthoud dit dan kunnen we morgen verder")
- (verslag) 🔴 VOOR MORGEN — Venom Lancer Ori'kassi is geen rare maar een SCENARIO
- 🔴 9 sep — de weekly-vinkjes rusten op bewijs dat niets waard is (OPEN)
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
