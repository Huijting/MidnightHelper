# Midnight Helper — waar we staan

## ▶ Open voor 14 nov (bouwchat 13-11 sloot af met /nieuwe-chat, ±00:30)

📌 14 nov ochtend (Bouwchat 14-11): ochtendronde gedaan, niets voor Rob (0 CF-reacties, geen 🔔, HandyNotes 171 zonder
zonewijziging, Zygor onveranderd, geen site-mail, BOUW_VRAAG 0 open, Notion-inbak: dezelfde 4 regels van 12 nov).
Handoff gesplitst (1544 → ~1180, knip bij "Open na 9 nov"). SITE_SEIN kreeg een regel "alleen op main" voor het
keuzevenster van 13 nov (de regie zocht "choice" en vond de 12-nov-regel niet; die stond er wel, de 13-nov-wijzigingen niet).
✅ 14 nov ochtend, Rob (via Sparring 13-11, Forever, nieuwe mage, d6c0d31): *"deze drie kreeg ik na een nieuwe char, nu
ga ik werken"* → Welcome (richting + bar layout als kaartjes), Yes → alleen de reload-vraag (geen venster eronder),
reload → toetsenblok. Afgevinkt in TESTLIJST. Nog open vóór de release: A1 (schone /reload, BugSack) en A2 (bestaand
character: schermpjes één keer, zelf sluiten, blijft weg) + Midnight. Twee nieuwe waarnemingen (Dock raakt knop in "Your
key block"; "Getting started" doorzichtig) in IDEEEN, zonder ja.
🚚 14 nov (later in de ochtend): de app-chat "Bouwchat 14-11" verhuist naar de ingang "Master-PC MH" (Rob, letterlijk:
*"Zet de chats van vandaag ook over naar de ingang"*). Er is sinds 3a75535 niets gebouwd. De code staat nog op d6c0d31
+ docs (GEMETEN, git status schoon). Niets uitgebracht, geen bump. De ochtendronde van vandaag is al gedaan; niet overdoen.

🏰 14 nov (ingang-bouwchat): nieuwe wens via Sparring 14-11, Rob letterlijk: *"We gaan voor 2 incl de route er naar
toe"* → Forever: dungeons en raids uitleggen op MH's manier (IDEEEN "Ja"). Onderzoek (mh-research) staat in
`docs/forever/DUNGEONS_2026-11-14.md`: 30 dungeons/vleugels open sinds 4 nov, raids (Barrow Deeps, Hyjal, Onyxia) op
9 dec; levels uit DB2 GroupFinderActivity (wowf 70938); ingangen uit HandyNotes_DungeonRaidLocations-Forever (MIT,
"Copyright (c) 2025-2026 Pirson", ZELF GEMETEN in LICENSE + 2 coördinaten nagekeken); Journal-tabellen ontbreken in
Forever. Plan met opties naar sparring gestuurd; NIETS gebouwd, niet in de volgende release.
✅ Rob koos (via sparring, letterlijk): *"Voor A, beginnen we met stap 1. Meneer Bouwert na de release. … C. Ja, dat
mag."* → NA de release: stap 1 bouwen (Do this now-regel + Route + dungeonlijst), HandyNotes-ingangen mee (MIT).
✅ 14 nov avond: A1 en A2 GEMETEN in de Forever-SV (na Robs filmpje 19:58, nieuwe gnome mage: Welcome → Yes → alleen
reload-vraag → toetsenblok; terugzet-chatregel gezien). A1: !BugGrabber.lua heeft alleen de NewChoices-fout van 13 nov
23:04:56 (vóór d6c0d31), niets daarna. A2: opening 13 nov 23:04:56 (na Fix2), 7 schermpjes-kaartjes, zelf gesloten na
228,8 s, daarna geen update-opening meer. Niet getest: "venster open laten + uitloggen → komt terug" (klein).
✅ Midnight (Rob, nieuw character, screenshot: *"na de layout aanmaken (show me) en de reload kwam er niets meer"*):
GEMETEN in retail-SV: Fix2 20:11:49, opening 20:11:54 mode "update", 6 kaartjes (partytargets#2, keyblock, quickbar,
fastmark, missingbuff, minimap), closedAfter 56,9 s, alle 6 in newChoicesSeen. Alle release-tests klaar.
Release alleen op Robs letterlijke go.

Stand 14 nov nacht: laatste commit 33c45ef op main (GEMETEN, gepusht). 5.2.0 staat op CurseForge (13 nov). Alles
hieronder sinds 5.2.0 staat alleen op main, NIET uitgebracht. Eén voordeur t/m 19 nov: vragen voor Rob via de
sparring-chat van de dag.

A. **Vóór de volgende release (Rob wilde releasen zodra dit klopt):**
   1. Eén schone `/reload` zonder rode BugSack-melding over NewChoices.lua (fix d6c0d31; NIET gezien in het spel).
   2. Keuzevenster: "seen" pas als de speler het zelf sluit (fcf82a7) + reparatie 2 → Rob krijgt de schermpjes nog één
      keer. Test: TESTLIJST "13 nov (nacht, 5)". `/mh new check` toont reparaties en de laatste 3 openingen.
   3. Daarna: release-tekst + changelog + versie alleen op Robs letterlijke go (alles sinds v5.2.0, zie de 13-nov-secties).
B. **Gebouwd 13 nov, nog niet (helemaal) door Rob gezien** (TESTLIJST, bovenste secties): één overzicht met richting /
   bar layout / schermpjes als kaartjes; twee titels; schuifbalk; klikwacht 1,5 s rust + 0,7 s dode knoppen; Yes-log;
   terugzet-chatregel; Dock-label vrij in de Forever-vragen. Wél goed gezien: keuzevenster dicht na kiezen (Midnight),
   titel links (5.png), vanzelf op nieuw character (Forever), Welcome-venster met richting + bar layout (nieuwe mage).
C. **Kleine open puntjes:** bij "Do this now" valt de knop "off" op een tweede rij (19.png); andere "Votre"-plekken in
   frFR niet nagelopen; dispel "rij blijft rood" is GESLOTEN (Rob: "Stoppen met meten").

0. ✅ **13 nov: release 5.2.0 (zie de sectie hieronder). Proef Bindings_Camelot.xml geslaagd.**
1. ~~**Proef `Bindings_Camelot.xml` (a176d48): uitslag OPEN.**~~ (13 nov: geslaagd, 4 regels) Rob: WoW helemaal herstarten, Forever → Esc → Options →
   Keybindings → "Midnight Helper". Werkt = 4 regels (Toggle main window, Clear active route, Open: Forever, Your
   characters). Werkt niet (nog 14) → bestand weghalen en optie A bouwen: "(Midnight)" achter de Midnight-toetsen in
   Forever (Rob koos dat al, letterlijk: *"Naam met (Midnight)"*). Ook nakijken: retail-lijst onveranderd.
2. **Nog niet door Rob gezien (TESTLIJST bovenaan):** toets "Your characters" indrukken; toetsen-kaartje per character
   (d14884c); het pijltje op de oranje rand (6118be2; de rand zelf werkt, 27.png); drankjes-toetsnamen in Forever
   (89f55a5); "Show party targets"-kaartje in Midnight; alle ontbrekende buffs; Purify-macro; rechtsklik-dispel en rode
   rand in het Forever-groepspaneel; de 17 verbrede knoppen in Midnight. (dispelTryLog `cd`: 13 nov gesloten, zie 🔎 13 nov.)
3. **Wel gezien en goed (12 nov):** keuzevenster na reload; "Your characters" na de reparatie (28-30.png, 33.png);
   tegel "Your characters" met icoon; "now" alleen voor het eigen character; oranje rand op de knop.
4. Rob vragen (oud, NIET GEMETEN): zijn de upgrade-melding en de groene gear-regel af? Plakte hij de CF-beschrijving
   en de 5.1.0-tekst?
5. Op main sinds 5.1.0 en niet uit: alles van 11-12 nov (plan 1/2/3, Do this now, groepspaneel, beroepenkaart, richting,
   Used for, …). Release alleen op Robs letterlijke go.

## 🌐 13 nov (nacht) — vertaaltwijfels van de site-chat (Rob vroeg ze op te ruimen)

- deDE: 4× "Ironforge" in FWEAP_ROUTE_* → "Eisenschmiede" (GEMETEN wago AreaTable 1537 deDE, build 70783). Nu 0×
  Ironforge, 5× Eisenschmiede in Translations2026.lua.
- frFR: MH_SETUP_BTN_BLOCK "Votre bloc de touches" → "Ton bloc de touches" (rest van frFR zegt "tu").
- esES/esMX: GEMETEN dat de addon overal al "Ciudad de Ventormenta" zegt (wago 1519 esES én esMX); geen kale
  "Ventormenta" gevonden. Niets veranderd. Andere "Votre"-plekken in frFR NIET nagelopen.

## 🐞 13 nov (nacht, 5) — tweede ronde: "seen" pas bij zelf sluiten

- Rob (4fef65f, nieuw Forever-char): weer alleen Welcome met direction + barlayout; schermpjes op "seen".
- GEMETEN in de Forever-SV (bewaard vóór 23:00): `newChoicesFix1 = true` (reparatie liep), en `newChoicesShowLog` heeft
  één opening: 2026-11-13 22:58:02 op Player-6944-0355882C (Ima Littleone, mage), mode "update", 7 kaartjes (donow#2,
  partypanel#2, keyblock, quickbar, fastmark, missingbuff, minimap), marked = true (1,5 s zichtbaar). De code deed dus
  wat hij moest; de 23:00-Welcome met 2 kaartjes is daarna correct (alleen character-kaartjes nog over).
- Probleem = de regel: "1,5 s zichtbaar" ≠ gezien (AFGELEID: Rob logde uit / wisselde van character). Nieuwe regel:
  "seen" alleen als de speler het venster zelf sluit (OnHide, na ≥ 1 s zichtbaar) of op een knop van een kaartje
  klikt; uitloggen/`/reload` met het venster open telt niet. Log krijgt `closedAfter`. `/mh new check` toont de
  reparaties (1/2, met tijd) en de laatste 3 openingen. Eenmalige reparatie 2 (`newChoicesFix2`, met tijd) zet de 7
  schermpjes-keys weer op niet-gezien.
- luac schoon, lint 0 HARD. NIET in het spel gezien (TESTLIJST 13 nov nacht, 5). Rob wil hierna releasen: eerst deze test.
- 🐞 Rob's BugSack na reload: `NewChoices.lua:785: attempt to index upvalue 'win' (a nil value)` — de f:Hide() in
  Build vuurt de OnHide-hook vóór `win = f`. Gerepareerd: de hook en OnWindowClosed stoppen als `win` nog nil is.
  Pad nagelopen (GEMETEN, grep op `win`): CardFrame/Layout/ShownLater/TryAutoShow/NewChoicesSlash lopen allemaal na
  Build(); /mh new en de changelog-knop "Choices" gaan via NewChoicesSlash (Changelog.lua:1460, Core.lua:2671).
  Het venster kwam bij Rob toch (19.png, 7 kaartjes): de fout zat in een script-handler, die WoW apart afvangt.
  Of zijn schermpjes nu als gezien tellen: NIET gemeten (SV nog niet bewaard sinds fcf82a7); zelf gesloten ≥ 1 s =
  gezien, venster open bij reload = komen terug. `/mh new check` zegt het.

## 🐞 13 nov (nacht, 4) — kaartjes op "seen" die Rob nooit zag (Rob: "geen venster, na reload")

- GEMETEN in `_forever_/WTF/.../MidnightHelper.lua` newChoicesSeen: quickbar, fastmark, missingbuff, minimap, donow#2,
  partypanel#2 én keyblock:Player-6944-03538B8D op true; Robs 11.png toonde alleen direction + barlayout. Alleen twee
  schrijvers in de code (MarkSeen in TryAutoShow, NewChoicesMarkSeen bij "Reload now"; GEMETEN met grep). Geen tijden in
  de SV, dus welke opening het deed is NIET gemeten.
- Twee gaten in de code (GEMETEN), die samen precies dit beeld geven (AFGELEID): (1) MarkSeen liep direct bij
  win:Show(), ook als het venster niet zichtbaar was (intro-filmpje verbergt UIParent; Esc sluit het als special frame);
  (2) een tweede automatische poging mocht een OPEN venster opnieuw vullen met alleen de nog-niet-geziene rest.
- Gerepareerd in `NewChoices.lua`: nooit een open venster vervangen; niet tonen tijdens filmpje of verborgen UI;
  "seen" pas na 1,5 s echt zichtbaar (IsVisible) of bij een klik op een knop van dat kaartje (`ShownLater`); elke
  automatische opening in `ns.db.newChoicesShowLog` (max 10); `/mh new check` toont de laatste ("N card(s) really in
  the window … counted as seen"). Eenmalige reparatie `newChoicesFix1`: zet de 7 schermpjes/tweede-ronde-keys en
  keyblock:<GUID> naast elke barlayout:<GUID> terug op niet-gezien (alleen Robs SV heeft ze; niets gereleased).
- luac schoon, lint 0 HARD. NIET in het spel gezien (TESTLIJST 13 nov nacht, 4).

## 🖥️ 13 nov (nacht, 3) — schermpjes in het overzicht (Rob via sparring, letterlijk: "Ja, raad alleen voor nieuwe spelers en één keertje bij een volgende update")

- ✅ Welcome-venster getest (Forever, nieuwe mage): Rob *"…gekozen dat ik vast wilde. Toen dat ik inderdaad de keys
  wilde. Daarna deed ik reload…"* ("vast" = Frost, Willow).
- Gebouwd in `NewChoices.lua`: `ScreenCard()` → 4 account-brede Aan/Uit-kaartjes met de eigen instellingsteksten
  (al in alle talen, Locales/SettingsPage.lua + enUS): quickbar (SETTINGS_QUICKBAR, standaard uit), fastmark
  (SET_MARK_TOGGLE_*, standaard uit), missingbuff (SET_MBUFF_TOGGLE_*, standaard aan), minimap (SETTINGS_MINIMAP_ICON,
  aan). Setter = die van de instelling + SyncNativeSetting. Alle vier in beide tocs (GEMETEN). Of FastMark/QuickBar in
  Forever goed werken: NIET gemeten in deze ronde.
- "Eén keer bij de volgende update": nieuwe ids → elke bestaande speler ziet ze één keer; donow/partypanel/partytargets
  kregen `again = "2"` (SeenKey "id#2"), dus wie ze vanavond al zag, ziet ze nog één keer met de rest. Nieuwe
  characters van bestaande spelers: alleen de character-kaartjes. Nieuwe spelers: alles, titel Welcome.
- Lang venster: volgorde = character-kaartjes eerst, dan schermpjes; breedte-truc + schuifbalk (1cf57d2). Geen kolommen.
- luac schoon, lint 0 HARD. NIET in het spel gezien (TESTLIJST 13 nov nacht, 3). Geen bump/release.

## 🗂️ 13 nov (nacht) — één overzicht: richting en bar layout als kaartjes (Rob: "Als kaartjes erin")

- Rob, letterlijk: *"het laatste scherm … dat dat gewoon de allereerste is … alleen nog maar te zien is voor nieuwe
  spelers of voor nieuwe karakters. En één overzicht"*, daarna op de vraag van sparring: *"Als kaartjes erin"*.
  De volgorde van 2ef8724 (richting → bar layout → keuzevenster) VERVALT.
- `ForeverDirection.lua`: komt niet meer vanzelf (Try zet alleen loginWhy); `ns.ForeverDirectionCardApplies/Body/
  Buttons` voor het kaartje (drie bomen, uitleg bij hover). `ForeverLayoutCarry.lua`: komt niet meer vanzelf; de loop
  wacht alleen tot Edit Mode kan antwoorden (`ns.ForeverBarLayoutNotReady`); Yes is nu `ns.ForeverBarLayoutYes(src,
  from)` voor vraag én kaartje (log krijgt `from`). `NewChoices.lua`: kaartjes "direction" en "barlayout" (perChar,
  bovenaan), `bodyFn` en `tip` op knoppen, wacht op Edit Mode, neemt bij Forever de login over zolang Edit Mode laadt
  en geeft de changelog alsnog als er niets komt. Nieuwe key `NEWC_BAR_HEAD`; SET_FOREVER_BARLAYOUT_DESC en
  SET_FOREVER_DIRECTION_DESC zeggen nu "kaartje in het keuzevenster" (alle talen zelf; check_drift: 0 nieuwe drift).
- Bescherming 2e2e9ca (rust/klikwacht) en Yes-log blijven. Midnight: niets veranderd (beide bestanden returnen op
  retail, kaartjes vragen IS_FOREVER; AFGELEID uit de code).
- luac schoon, lint 0 HARD. NIET in het spel gezien (TESTLIJST 13 nov nacht).
- ✅ Daarna (Rob via sparring, letterlijk: *"Laat de uitleg zichtbaar bij elke knop"*): knoppen met `line` staan onder
  elkaar, even breed, met de zin zichtbaar rechts ernaast (tooltip blijft). Kaartje wordt hoger: AFGELEID ~200 px i.p.v.
  ~120 (zinnen 45-85 tekens, 1-2 regels). Zodat het venster niet buiten beeld valt: Render probeert breedte 440, 560,
  680 tot de hoogte ≤ 92% van het scherm is (geen schuifbalk en geen weggelaten kaartje: daar heeft Rob nog niet over
  beslist). `/mh new check` toont "window size last shown". NIET gemeten in het spel.
- ✅ Daarna (Rob via sparring, letterlijk: *"Ja, jouw advies"*): (a) twee titels — regel: "New in this version" alleen
  als er een account-breed kaartje (nieuwe functie) in staat EN dit account het venster al eens zag; anders "Welcome:
  set up Midnight Helper" (`NEWC_WELCOME_TITLE/_INTRO`, 7 talen zelf). Bepaald één keer per opening (`OpenMode`),
  vóór MarkSeen. (b) keyblock-kaartje valt weg als barlayout er staat (in Pick; NIET als gezien gemarkeerd → komt de
  volgende keer als de speler niets koos); schuifbalk: kaartjes in `f.scroll`/`f.content`, scrollen alleen als ook 680
  breed niet past. luac schoon, lint 0 HARD. NIET in het spel gezien (TESTLIJST 13 nov nacht, 2).

## 🪟 13 nov (laat) — Forever: tekst vrij van "Dock to window" (Rob: "1 fixen") + plan drie vensters ("2 ja")

- `ForeverLayoutCarry.lua`: bar-layout-vraag en "Use your layout"-vraag: tekst van −22 naar −34 (onder de Dock-knop,
  y −10..−26), vensters 12 px hoger. `ForeverDirection.lua`: titel van TOPLEFT 20 tot 8 px links van de Dock-knop,
  gecentreerd, breekt af. luac schoon, lint 0 HARD. NIET in het spel gezien. Geen bump/release.
- Drie vensters, GEMETEN in de code: bar-layout probeert 3 s na login, en opnieuw elke 2 s (max 30×) zolang Edit Mode
  niet klaar is; richting 6 s na login en wacht als de bar-layout-vraag open is; keuzevenster wacht op beide.
  ⚠️ De bar-layout-vraag wacht NIET op de richtingvraag. AFGELEID: bij Rob was Edit Mode pas na >6 s klaar → richting
  eerst, bar-layout erbovenop. Plan naar sparring: "één voor één" = bar-layout ook laten wachten (klein), of "alles in
  één venster" (groot, drie modules + reload-popup). Mijn advies: één voor één.
- ✅ Gebouwd (Rob via sparring, letterlijk: *"Eén voor één"*): richtingvraag eerst (3 s, wacht niet meer op bar
  layout); `ns.ForeverDirectionPending()`. Bar layout wacht zolang richting nog moet komen of open is (elke 2 s, tot
  ~5 min, telt niet mee voor de Edit Mode-pogingen; daarna bij volgend gevecht-einde/filmpje); `ns.ForeverBarLayoutPending()`.
  NewChoices wacht op beide pending-functies (ook in het gat tussen de twee). `/mh direction check` en `/mh mylayout
  check` tonen "this login: <reden>". luac schoon, lint 0 HARD. NIET in het spel gezien.
  ⚠️ Na "Yes" op de bar layout kwam het keuzevenster tóch onder de reload-popup (Rob, 6.png: *"na de eerste komt dit,
  ik had nog niet gekozen voor een andere keyjayout"*). Gerepareerd (zelfde ja "Eén voor één"): na Yes telt de bar
  layout als bezig tot de reload (`reloadAsked` → ForeverBarLayoutPending true, ook na "Later", rest van de sessie).
  "Reload now" markeert het keyblock-kaartje als gezien (`ns.NewChoicesMarkSeen`), want het toetsenblok opent na de
  reload zelf (KeyBlock.lua:2687, 2 s). NewChoices wacht ook op `MidnightHelperKeyBlock` (kijkt pas na 3 s).
  "Later" = kaartje blijft voor de volgende login. GEMETEN: MH_EditModeMakeOwnLayout wordt alleen aangeroepen door de
  Yes-knop en door een knop in het toetsenblok-venster (KeyBlock.lua:1946): de layout kan niet vanzelf gezet worden
  (lezing b van sparring kan dus niet via de code). luac schoon, lint 0 HARD. NIET in het spel gezien.
- ⚠️ Daarna Rob: *"ik klikte alleen in de keuze voor welke richting ga ik uit"* → doorklik (AFGELEID, sparring's som:
  Yes ligt binnen richtingband 2). Gerepareerd voor de hele rij: `DialogPopup.lua` ns.LoginQuestionClosed /
  LoginQuestionRestLeft (1,5 s rust na sluiten) + ns.GuardFreshClicks (knoppen 0,7 s dood na tonen). Richting, bar
  layout en keuzevenster stempelen hun sluiten en hebben de klikwacht. Bij Yes: chatregel `FBAR_UNDO_CHAT_FMT` (en/nl/
  de/fr/es/pt/ru zelf vertaald, it valt terug op Engels zoals alle FBAR-keys) en een logregel `foreverBarYesLog` (max
  10: tijd, char, seconden in beeld, seconden sinds vorige vraag dicht); `/mh mylayout check` toont de laatste.
  Toetsenblok (na reload) niet bewaakt: komt niet direct na een klik. luac schoon, lint 0 HARD. NIET in het spel gezien.

## 🪟 13 nov (avond) — keuzevenster kwam niet vanzelf op een nieuw character (Rob, via sparring)

- Rob: *"pas kwam toen ik /MH new deed. En niet vanaf het begin. Dat zou wel moeten"* (nieuw Midnight-char, level 10).
- GEMETEN in SV: `newChoicesSeen` = alleen `partytargets`; geen enkele `keyblock:<guid>`. Het toetsen-kaartje is dus op
  geen enkel character ooit bij het inloggen gekozen. GEMETEN in code: één check op PLAYER_ENTERING_WORLD
  (Changelog.lua:1564 → NewChoicesTakeOver); niets = nooit meer die sessie.
- NIET GEMETEN: waarom het kaartje bij het inloggen "niet van toepassing" was (spec of balken nog niet leesbaar?
  AFGELEID). Gebouwd: bij niets bij het inloggen kijkt NewChoices na 6 s en 20 s nog eens; wacht ook op een open
  changelog (één venster). `/mh new check` toont nu "key card now: <reden>" en de uitkomst van de late checks.
- luac schoon, lint 0 HARD. Geen bump/release.
- ✅ Forever getest (nieuwe hunter): Rob *"Ja, kwam vanzelf"*. Midnight nog niet opnieuw getest.
- Twee waarnemingen (geen ja) in IDEEEN Open: Dock-label bij de bar-layout-titel; drie vensters bij eerste login Forever.

## 🔎 13 nov (avond) — dispelTryLog `cd` na Robs tweede run (Voidscar Arena, Prot Paladin): meting kan het niet beslissen

- GEMETEN in SV (13 nov 20:29, regels 140143-140364): 3× cast 213644, alle drie `cd` = "unreadable", `cdWhy` = "secret".
  C_Spell.GetSpellCooldown/GetSpellCharges zijn in een gevecht dus secret: de cooldown-meting van 9f5a96c kan in een
  gevecht NIETS zeggen. Casts 20:25:23/25/27 (2 s uit elkaar), 1× failed, 10× "Spell is not ready yet", 4× "Target
  needs to be in front of you" (fout van een andere spell terwijl de muis op de rij stond; de code waarschuwt daar al
  voor). 0× "Nothing to dispel" in het hele SV (tegencontrole: de andere twee teksten wél, 16 treffers).
- AFGELEID: geslaagde casts zonder "Nothing to dispel" = er was op dat moment iets weg te halen. Casts 2 s uit elkaar
  past niet bij 8 s cooldown die start. Beide passen samen alleen als de cooldown niet start of als het gif direct
  terugkomt; niet te beslissen met wat wij in een gevecht kunnen lezen. Het rood zelf komt van de engine (niet leesbaar).
- 🔒 **GESLOTEN** — Rob via sparring, letterlijk: *"Stoppen met meten"*. Uitkomst: niet te beslissen in een gevecht.
  Niet opnieuw openen zonder nieuwe klacht. `dispelTryLog` + NoteDispelCooldown blijven in de code (mijn oordeel: alleen
  schrijven, max 40 regels, niets zichtbaars; weghalen zou de live map raken voor niets). Niemand leest het meer uit.
- ✅ Rob: keuzevenster gaat dicht na kiezen (*"o en na de keuze was ie inderdaad weg"*); titel goed (5.png).
  Retail-toetsenlijst: 14 regels (Robs screenshot). Open: Forever met meer kaartjes.

## 🪟 13 nov (middag) — keuzevenster dicht na kiezen + titel (Rob via sparring, letterlijk: "Ja, dicht na kiezen")

- `NewChoices.lua`: een keuze sluit het venster als elk getoond kaartje in deze opening een keuze kreeg (één kaartje =
  meteen dicht). Robs ja geldt voor één kaartje; meer kaartjes = advies sparring (AFGELEID). Bijhouden in `f.chosen`,
  leeg bij elke nieuwe opening (automatisch en `/mh new`).
- Titel links, rechterrand vast aan de "Dock to window"-knop (−8), breekt af als hij te lang is; de intro schuift mee.
- `luac -p` schoon, lint 0 HARD. NIET in het spel gezien (TESTLIJST 13 nov). Geen versie-bump, geen release.
- NIET GEVONDEN: waarom het venster bij Rob "later" vanzelf wegging. Geen auto-hide in `NewChoices.lua`. Mogelijk Esc
  (UISpecialFrames) of het venster vastgezet aan het hoofdvenster ("Dock"); NIET GEMETEN.

## 🚀 13 nov — RELEASE 5.2.0 (Rob via sparring, letterlijk: "je krijgt nu een go voor een release voor alles")

- Eerst de CF-beschrijving (f6631bb, Rob plakt hem zelf), dan alles van main sinds v5.1.0. Geen beta.
- Artefacten: beide toc's 5.2.0, `CHANGELOG_520_1..10` (enUS), `RELEASE_NOTES.md` = `docs/CURSEFORGE_5.2.0.md`,
  `CHANGELOG.md`. SITE_SEIN: 12 regels + release-regel op "getagd". Lint 0 HARD ([27] 0: geen eigen gereedschap in de
  spelerstekst), `luac -p` schoon op Changelog.lua + enUS.lua.
- Proef `Bindings_Camelot.xml` GESLAAGD (Robs screenshot, door sparring gezien: 4 regels). Blijft.
- ✅ Staat op CurseForge (GEMETEN in de API): 9587203 (Retail) + 9587210 (-forever), status 4. Run 43380670872 geslaagd;
  Wago + GitHub-release hebben beide zips. SITE_SEIN op "staat op CurseForge". Rob plakt de beschrijving zelf.

## 🛠️ 13 nov (ochtend) — ochtendronde + regie-opdracht aangescherpt (Rob via sparring, letterlijk: "Ja, aanscherpen")

- Ochtendronde: 0 open CF-reacties, geen site-mail, HandyNotes 170 en Zygor 9.6/1.6 onveranderd, BOUW_VRAAG 0 open.
  `event_snapshot --write` gedraaid (ptr 70892, forever 70938); `event_check` daarna schoon (GEMETEN).
- API-wachter 8871810: niets voor MH (nieuwe Forever-API `HasNoReagentCost`, 0 treffers in MH).
- Regie 13 nov had twee punten mis (GEMETEN): het keuzevenster STAAT in SITE_SEIN.md (regel 53, Nederlands; de regie
  zocht "choice"), en `ForeverHowToPlay.lua:273` noemt Confounding Flash al niet meer. `/mh partytest` = meetknop, geen
  SITE_SEIN-regel nodig (lint [27] houdt hem uit spelerstekst).
- Waarom de regie tabel 2 (grens CLAUDE.md, OCHTENDRONDE/CLAUDE_HISTORIE) en tabel 3 rij 10 oversloeg, GEMETEN in zijn
  run-log (cse_01AezjgjdGQo9Pd9h5Prv113, 13 turns, 80 s): hij schreef alleen blok 0 + tabel 5; zag "zie loopt scheef"
  niet als fout getal; zocht alleen bestanden "nieuw sinds vorig verslag" (beide zijn van 11 nov); `git log
  --diff-filter=A` gaf honderden Modules (ondiepe kloon, AFGELEID) en `head -30` kapte af; keek nooit in `tools/`.
- Hoofdstuk 6 van REGIE.md aangescherpt: getal in tabel 2, hele tabel 2 elke ronde, unshallow-check, geen `head` op
  lijsten, `ls tools/` + lintkoppen voor tabel 3, datum alleen na alle rijen, en een verplicht rijenbewijs in het
  slotbericht. De drie regels zelf NIET met de hand gezet (dat is de test). Routine-prompt en recept niet aangeraakt.
  Sparring meet 14 nov.

## 🧪 12 nov (laat) — PROEF: eigen toetsenlijst voor Forever (`Bindings_Camelot.xml`)

- Rob (via sparring, letterlijk): eerst *"Haal ze in Forever uit de lijst"*, daarna *"Ja, eerst de proef"* (optie D).
- Idee AFGELEID uit Baganator (Bindings.xml + Bindings_Mainline.xml + Bindings_Vanilla.xml, in Robs Forever-map
  gelezen): het spel leest `Bindings_<versie>.xml` in plaats van `Bindings.xml`. Forever = "Camelot" (die toc laadt).
- `Bindings_Camelot.xml`: TOGGLEMAIN (ALT-M), CLEARROUTE, TAB_HOME, ALTS — zelfde namen, dus Robs ALT-M blijft.
  `Locale.lua`: TAB_HOME heet in Forever "Open: Forever".
- Retail: geen `Bindings_Mainline.xml` in MH, dus retail leest `Bindings.xml` als altijd (AFGELEID; Rob kijkt in
  Midnight of de lijst gelijk blijft). `Bindings.xml` zelf is NIET veranderd.
- ⚠️ UITSLAG OPEN. Werkt het niet (Forever toont nog 14 regels): `Bindings_Camelot.xml` weg, en optie A bouwen
  (Rob: *"Naam met (Midnight)"*; "Open: This Week" → "Open: Forever").

## 🛠️ 12 nov (laat) — drankjes-toetsen krijgen in Forever een naam

- Rob (via sparring, letterlijk): *"Ja, geef ze een gewone naam"*. Zijn 32.png (Forever, Keybindings → Midnight Helper):
  "CLICK MidnightHelperHea…" / "…Com…". GEMETEN daarmee: Bindings.xml laadt in Forever, "Your characters" staat erin.
- Oorzaak: `PotionButton.lua` zet de namen (POTIONKEY_HEAL/COMBAT, al in 7 talen) maar laadt niet in Forever. Fix in
  `Locale.lua` ApplyBindingLabels: in Forever dezelfde naam + " (Midnight)", omdat de knoppen daar niet bestaan.
- Dubbel in het zoekresultaat (31.webp): in de lijst zelf één keer (Robs plaatje). AFGELEID: het zoekvak van het spel,
  niet van ons; na de nieuwe naam opnieuw kijken.
- Open (vraag van sparring, voorstel gestuurd, niets gebouwd): "Open: TAB_CODEX" = kale sleutel in Forever (Codex.lua niet
  geladen); de Midnight-toetsen (This Week, Rares, Delves, Codex, Achievements, Mounts, Account) openen in Forever de
  startpagina (terugval in SelectTab, UI.lua:4963).

## 🛠️ 12 nov (laat) — tegel "Your characters" (Rob bedoelde "tegel", niet "toets")

- Rob dicteerde "toets" en bedoelde "tegel": *"Het kopje Midnight Helper staat er. Maar ik bedoelde een tegel in onze
  addon"*. Keuzes (via sparring, letterlijk): *"Ja, een tegel (Recommended)"*; de toets: *"Laten staan (Recommended)"*.
- Tegel = een kaart in `ME_FOREVER_CARDS` (RoomLauncher.lua), zoals Rob op 10 nov voor macro's en verkopers vroeg
  (*"dit moet natuurlijk ook een tegel in de addon krijgen"*). Nieuw: `me_fchars` → `ns.ShowForeverChars()`, tekst
  TOOLLP_FCHARS_DESC, icoon `INV_Misc_GroupNeedMore` (pad AFGELEID). Er stond nog geen tegel of startpagina-regel voor
  (GEMETEN, grep met tegencontrole in ForeverChars.lua); er is dus niets weggehaald.
- Instellingen in Forever (vraag van sparring): één lange lijst, Esc → Options → AddOns → Midnight Helper; de
  Forever-schakelaars staan onder het kopje "On-screen buttons" (SettingsDefs.lua:472/523). Robs plaatje met alleen
  "Open Midnight Helper on login" is NIET gezien (niet in de map); AFGELEID: een zoekresultaat op "Midnight Helper".

## 🛠️ 12 nov (laat) — toets "Your characters" + "now" alleen voor jezelf

- Rob (via sparring, letterlijk): *"Ja, zonder toets"* (optie A). Bindings.xml `MIDNIGHTHELPER_ALTS`, geen standaardtoets
  → `MidnightHelper_KeybindAlts()` (Core.lua) = `/mh alts`; in Midnight een chatregel (BINDING_ALTS_FOREVER_ONLY).
  Naam = `FCHARS_TITLE` (Locale.lua ApplyBindingLabels), dus de toets heet zoals het venster.
- "now" alleen nog voor het eigen character; een ander minstens "1 min ago" (29.png). ⚠️ Sparring koppelde dit voorstel
  aan de toets en las Robs ja als ja voor beide; hij noemde de regel niet apart.
- Rob kijkt zelf of er in Forever onder Esc → Options → Keybindings een kopje "Midnight Helper" staat (of Bindings.xml
  daar laadt: AFGELEID, bindings-cache.wtf is niet leesbaar).
- GEMETEN: Bindings.xml parseert (14 toetsen), fchars_test "1 min ago". In het spel: NIET GEZIEN.

## 🛠️ 12 nov (laat) — toetsen-kaartje per character (Rob via sparring, letterlijk: "Ja, per character")

- `NewChoices.lua`: kaartje `keyblock` heeft `perChar = true`; "gezien" staat onder `keyblock:<GUID>` in
  `ns.db.newChoicesSeen`. Elk character zonder toetsenblok krijgt het venster één keer, met alleen dat kaartje.
  "Do this now", groepspaneel en party targets blijven per account. `/mh new check` zegt "(per character)".
- De oude account-sleutel `keyblock` telt niet meer: het character waarop Rob het al zag, krijgt het nog één keer.
- GEMETEN offline: newc_test geval 8 (character B: 1 kaartje, daarna niets). Lint 0 HARD.

## 🐞 12 nov (laat) — Robs test van "Your characters" (24-27.png): 4 fouten gerepareerd

- Rob (via sparring): *"doet hij alleen maar onthouden wat op dat moment ingelogd is … Geen professions … Al mijn
  voornamen zijn Ima"*. Keuzevenster: verscheen na een reload. Oranje rand: werkt (27.png); pijltje NIET GEZIEN.
- 1. Goud 0 / "no professions" bij andere characters. GEMETEN in de SV: alle drie `money = 0`, `profs = {}`. Oorzaak:
  de foto bij PLAYER_LOGOUT overschreef de echte waarden (het spel geeft dan 0 en geen beroepen). Fix: bij logout alleen
  `seen`; een lege beroepenlijst wist een bekende alleen na SKILL_LINES_CHANGED. ⚠️ De bestaande lege foto's worden pas
  goed na één login per character.
- 2. "Last played" overal "now": de drie `seen` lagen binnen 5 min (GEMETEN 1794515534/675/858) en "now" was < 5 min.
  Fix: now < 2 min (of het eigen character), daarna "N min ago" tot een uur.
- 3. Naam "Ima": Forever geeft de achternaam als 2e waarde van UnitName (al bekend sinds 7 nov, archief). Fix: naam +
  achternaam. Wordt goed na één login per character.
- 4. "level 7…" afgekapt: de servernaam (22 tekens) stond in dezelfde kolom. Fix: server alleen bij meer dan één server
  (dan op regel 2), kolom 30 px breder.
- Vraag 5 (sparring): de level-1 Warrior "Protection" is GEEN lek: `foreverDirection` per GUID, Warrior = band 3 =
  Protection (GEMETEN in de SV).
- Vraag 6: keuzevenster-gezien, Do this now-stand en groepspaneel staan account-breed in `MidnightHelperDB`; het
  toetsenblok per character + spec. Gevolg: het toetsenkaartje komt niet terug op een ander character zonder blok.
  Keuze bij Rob, niets veranderd.

## 🛠️ 12 nov (laat) — plan 3: oude rank licht op, op de knop (IDEEEN O24 + O25)

- Rob (via sparring, letterlijk): *"ja bouw oude reank"*; keuzes A1 *"Eigen rustige rand"*, B1 *"Aan"*, C1 *"Elke
  lagere rank"*; zijn meting in Forever *"1 61 table nil"* (ActionButton1.action 1, MultiBarBottomLeftButton1.action 61).
- In `ForeverRanks.lua` (geen nieuw bestand): `UpdateGlows` legt `Scan()` op de Blizzard-knoppen van 8 balken
  (`ActionButton`, `MultiBarBottomLeft/Right`, `MultiBarRight/Left`, `MultiBar5/6/7`, 1-12) via `button.action`.
  Eigen kindframe per knop: 4 oranje lijnen + `Interface\Buttons\Arrow-Up-Up` (pad AFGELEID). Fel (2 px, alpha 1) =
  net geleerd (`fresh`), zacht (1 px, 0,55) = zelf neergezet. Alleen zichtbare knoppen.
- Update 0,3 s na ACTIONBAR_SLOT_CHANGED / PAGE_CHANGED / UPDATE_BONUS_ACTIONBAR / REGEN_ENABLED, 1,5 s na
  SPELLS_CHANGED (na AfterLearn), 3 s na PEW.
- Schakelaar `ns.db.foreverRanks.glow` (nil = aan, false = uit), instelling `mh_foreverRankGlow`, `/mh ranks glow on|off`.
- O25: Glowing Bars NIET bij Rob geïnstalleerd (GEMETEN); detectie op mapnaam of titel "glowingbars" (genormaliseerd).
  Geladen → stil; `/mh ranks` zegt het met de naam; `/mh ranks glow on` zet `glowWithOther` en tekent toch.
- Bug gevangen in de offline test: `(not on) and false or nil` is altijd nil → "glow off" deed niets. Gerepareerd.
- GEMETEN offline (scratch `rglow_test.lua`): 6 gevallen goed. In het spel: NIET GEZIEN.

## 🛠️ 12 nov (laat) — plan 2: "Your characters" in Forever (IDEEEN O21) + Midnight-kaartje plan 1

- Rob (via sparring, letterlijk): *"De vijf van het advies, bouwen (Recommended)"*. Geen release.
- `Modules/ForeverChars.lua` (beide tocs, alleen Forever actief). Foto per character in `ns.db.foreverChars[guid]`:
  name, realm, class/className, level, money, profs {key,name,rank,max}, dir (boomnaam), trainerN/trainerCost, seen.
  Genomen 2 s na PEW / PLAYER_LEVEL_UP / PLAYER_MONEY / SKILL_LINES_CHANGED / SPELLS_CHANGED, en direct bij PLAYER_LOGOUT.
- Venster `MidnightHelperForeverChars`: eigen character bovenaan, dan op laatst gespeeld; tweede regel = beroepen;
  kruisje = vergeten (niet op je eigen rij); totaal goud onderaan. `/mh alts`, `/mh alts check`. In Midnight zegt
  `/mh alts` dat het voor Forever is.
- NIET gebouwd (Rob): tasplekken, rust-XP, raid-locks (later, na een meting), gespeelde tijd.
- Plan 1-gat (sparring): kaartje `partytargets` in NewChoices.lua voor Midnight, aan/uit via `ns.SetPartyTargetsEnabled`
  + `SyncNativeSetting("mh_partyTargets")`. Valt onder Robs bouw-ja voor plan 1 (zijn eerste zin noemde party targets).
- GEMETEN offline: fchars_test (2 characters, totaal, vergeten) en newc_test geval 7. In het spel: NIET GEZIEN.
- Plan 3 (oude rank op de knop): keuzes A1/B1/C1 en meting binnen (`1 61 table nil`), bouw-ja NOG NIET.

## 🛠️ 12 nov (laat) — plan 1: venster "Nieuw in deze versie: jouw keuze" (IDEEEN O29)

- Rob (via sparring, letterlijk): *"Keuzes in plaats van changelog (Recommended)"*, *"Iedereen (Recommended)"*,
  *"Niet tonen (Recommended)"*, bouw-ja *"Ja, bouw het (Recommended)"*. Geen release.
- `Modules/NewChoices.lua` (beide tocs, na ForeverDoNow). Kaartjes in `CARDS`, elk met `id`, `avail()`, `buttons()`:
  - `donow` (Forever): auto / always / off via `ns.SetForeverDoNowMode` + `SyncNativeSetting`;
  - `partypanel` (Forever): aan/uit via `ns.SetForeverPartyPanel`, geweigerd in een gevecht;
  - `keyblock` (beide): alleen als `ns.KeyBlockIsPlaced()` false is én er op geen enkele spec van dit character een
    snapshot staat (ook rust in de eerste seconden, als de spec nog niet leesbaar is). "Show me" = `ns.ShowKeyBlock()`.
- Changelog.lua vraagt bij het inloggen `ns.NewChoicesTakeOver()`: true → alleen het keuzevenster (3 s later; wacht op
  de richtings- en balkvragen en op het eind van een gevecht, max ~10 min). Knop "Choices" in de changelog (alleen als
  er een kaartje geldt). Gezien = `ns.db.newChoicesSeen[id]`, account-breed, één keer automatisch.
- Volgende versie een nieuw kaartje = één regel in `CARDS` met een nieuw id; alleen dat kaartje komt dan.
- `/mh new`, `/mh new check` (diagnose: per kaartje geldt/zag). In de commandolijst (CMDLIST_NEW).
- GEMETEN offline (scratch `newc_test.lua`): 6 gevallen goed. Lint 0 HARD. In het spel: NIET GEZIEN.
- ⚠️ Nieuw bestand in de toc → Rob voor de zekerheid WoW opnieuw laten starten (of `/reload` genoeg is: AFGELEID).
- Vertalingen de/fr/es/pt/it/ru: mh-writer.

## 🛠️ 12 nov (avond) — lint [28]: te smalle knoppen (Rob via sparring, letterlijk: "Ja, bouw dat")

- `tools/button_width_check.py`, in `lint_addon.py` als [28], SOFT.
- Wat hij leest:
  - UIPanelButtonTemplate-knoppen met een vaste breedte (≥ 30 px; ook via een hulpfunctie `local function Btn`);
  - `SetText(ns:L("KEY"))` op die knoppen;
  - per taal de tekst uit de packs (pack-bestanden + fill-blokken).
- Schatting: tekens × 6,5 px + 16 px. Knoppen die zichzelf op hun tekst afstemmen (GetStringWidth binnen 40 regels) slaat hij over.
- Proef: de 90 px-knop met FWEAP_TITLE (21.png) wordt gevangen. Tegenproef: 180 px niet. Allebei OK.
- Eerste run: 37 knoppen bekeken, 18 waarschijnlijk te smal. De ergste:
  - DelveBossCard:146 esES ~50 px;
  - TradingPost:671 frFR ~42;
  - ConsumablesPanel:182/266 esES ~32;
  - ProfessionsGuide:231 frFR ~28;
  - ModelPreview:200 deDE "Zurücksetzen" ~24.
- NIETS gerepareerd: lijst bij sparring, wacht op Robs keuze.
- ✅ Rob (via sparring, keuze letterlijk: *"Alle 18 repareren (Recommended)"*): nieuwe helper `ns.FitButtonToText(btn,
  min, max)` in `Core.lua` (beide spellen); max = de echte ruimte (buren, rand). 17 van 18 verbreed, geen vertaling
  ingekort.
  - DelveBossCard max 250 (de "all"-knop hangt eraan; 402 van 420 px).
  - ModelPreview: Spin/Reset groeien nu vanuit het midden naar buiten, max 110 (de pijlknoppen blijven vrij).
  - VaultReminder: de hint eindigt nu bij de knop.
  - DungeonBossWindow Chat/Share max 90; Route NIET (≈2 px, en in een 340 px venster zou de rij de "all"-knop kunnen raken).
  - Consumables ook bij de taalwissel; UI.lua About ook in de refresh.
- Lint [28] slaat een knop alleen over als `FitButtonToText(<diezelfde knop>` erbij staat. Na de reparatie: 1 SOFT
  (Route). Niet in het spel gezien, en niemand kan het in die talen zien: het blijft een schatting.

## 🛠️ 12 nov (avond) — Forever: uitleg per beroep, versie A (O26; Rob via sparring, letterlijk: "A, eerst klein")

- Nieuw `Modules/ForeverProfGuide.lua` (beide tocs): `ns.ForeverProfCard(key)` en `ns.ForeverPrimaryCount()`.
  Bron: `docs/forever/BEROEPEN_2026-11-12.md`.
- GEMETEN, stellig: wat het doet, hoofd/bij, gereedschap (alleen hammer/mining/skinning/fishing, naam uit de client via
  nieuw `ns.ForeverVendorItemName`), rangen 75/150/225/300 en 50/125/200, jouw skill.
- Gids, met "according to player guides": "pairs with", level per rang (10/20/35), "na 150: boek, dan quest". "Tot 150"
  zelf ook uit MH-data.
- Weggelaten (AFGELEID / niet gemeten / versie B): kosten, Fishing-rangen, gereedschap bij Leatherworking en First Aid,
  gereedschapsnamen Enchanting/Engineering (alleen "sommige recepten vragen gereedschap"), het kampvuur bij Cooking.
- Telling hoofdberoepen: (1) `GetProfessions` slot 1+2, (2) de herkende hoofdberoepen uit `ForeverMyProfessions`.
  Alleen als ze gelijk zijn, anders zwijgt MH. Slot-volgorde in Forever AFGELEID.
- `ForeverProfTrainers.lua`: kaartje + knop "Where to buy" boven de lijst (lijst hangt eronder), venster 560 hoog.
- `ForeverDoNow.lua`: "You can still learn 1/2 main profession(s)" + knop. Een tip, telt NIET mee voor het vanzelf
  openen (anders blijft het venster bij elk nieuw character open).
- Offline (scratch `profcard_test.lua`): 12/12 kaartjes zonder ontbrekende tekst; telling: gelijk → 1, oneens → nil.
- ❌→✅ Rob (screenshot, via sparring): "Tool: (loading...)." bij Fishing. `ForeverProfTrainers.lua` Fill wacht nu op de
  naam: `Item:ContinueOnItemLoad` + 10× herkijken per 0,5 s (de les van de verkopers-tip). Nieuw `ns.ForeverVendorItemId`.
  De half afgesneden onderste trainerrij = de onderrand van het scrollvak (dat hangt al onder het kaartje), geen fout.
  Lint 0 HARD.

## 🛠️ 12 nov (avond) — Forever: venster "Doe dit nu" (Rob via sparring, letterlijk: "Venster 'Doe dit nu'")

- `Modules/ForeverDoNow.lua` (beide tocs; returnt op retail). Elke regel rust op iets bestaands:
  - trainer: `ns.ForeverTrainerCompute(level).now` en de knop `ForeverTrainerGo`;
  - ranks: `ForeverRankCount` en `ForeverRankFixAll`;
  - wapens: `ForeverWeaponsLearnableCount`;
  - buff: `GetForeverMissingBuffs` en `MissingBuffSentence`;
  - gereedschap: nieuw `ns.ForeverMissingTools` in `ForeverVendors.lua`;
  - "Komt eraan": `ForeverTrainerCompute(level+3)`, spells boven je level, per level;
  - met richting: nieuw `ns.ForeverDirectionTalents` (ForeverMacros SPEC_MACROS), de eerstvolgende talent-spell. Levels AFGELEID.
- Stand: `ns.db.foreverDoNowMode` = auto (standaard, Robs keuze "Alleen als er iets is") / always / off.
  - Instelling `mh_foreverDoNowMode` (dropdown).
  - `/mh donow` (tonen/verbergen deze sessie), `/mh donow auto|always|off`, `/mh donow check`.
- In een gevecht weg, daarna terug. Standaardplek rechtsboven.
- In CommandList met `foreverOnly` (nieuw in `CommandItemShown`, dus ook de zoekbalk), in MoveMode, en EXEMPT in window_check (eigen Shift+scroll).
- Offline (scratch `donow_test.lua`): 4 punten "doe nu", 3 regels "komt eraan", de standen wisselen goed. luac schoon, lint 0 HARD. Niet in het spel gezien.
- ✅ Rob: "Het venster staat er, werkt" (21.png). ❌ De knop "Weapon trainers" was te smal (vaste 90 px). Gerepareerd:
  breedte uit de tekst, nieuwe rij als het niet past.
- ✅ Rob (via sparring, letterlijk): *"Ja, alle drie"*. Gebouwd:
  - geen kop "Do this now" onder de titel;
  - "(Rank N)" achter een spell die je al kent (`ForeverKnownSpell` + `C_Spell.GetSpellSubtext`);
  - wapenzin enkel/meervoud (`FDONOW_WEAP_*`) + "(fitting <richting>, according to player guides: n)" via nieuw
    `ns.ForeverWeaponsLearnable` (lijst) en `ForeverDirectionWeaponFit`.
  - Startpagina daarna ook (Rob via sparring: *"Ja, ook netjes"*): `HomeDashboard.lua` gebruikt `FDONOW_WEAP_ONE` /
    `FDONOW_WEAP_MANY_FMT`, zonder het richtingdeel. `FWEAP_HOME_FMT` wordt nergens meer gebruikt (lint [18] SOFT).
  - `FDONOW_HEAD_NOW` wordt niet meer gebruikt (blijft in de packs staan, onschadelijk).
- Rob over mijn twee keuzes, letterlijk: *"Laat zo, in een gevecht weg en rechtsboven"*.
- ✅ Tandwieltje (Rob via sparring, keuze letterlijk: *"Tandwieltje (Recommended)"*): `ForeverDoNow.lua` Build, knop
  naast het kruisje (`Interface\\Buttons\\UI-OptionsButton`; dat die textuur in Forever bestaat is AFGELEID), eigen
  menuutje (geen UIDropDownMenu) dat `SetMode` + `SyncNativeSetting` aanroept. Eén bron met de instelling. "off" →
  chat `FDONOW_OFF_HOW`. Het kruisje blijft "tot de volgende login".

## 🛠️ 12 nov (avond) — "Welke kant?" stap 1 + 2: blok in How you play, + in /mh weapons

- Rob (via sparring, letterlijk): *"1 en 2, de wapens er meteen bij"*. Aanleiding: zijn Protection-paladin met een
  two-handed sword ("Volgens mij moet een protection paradigma ook zo meteen een schild hebben").
- ✅ Gebouwd in `ForeverDirection.lua`:
  - `ns.ForeverDirectionBlock()` + data `ARMOR`/`GUIDE` per class en richting.
  - Pantser: GEMETEN (SkillRaceClassInfo).
  - "werkt alleen met": GEMETEN (SpellEquippedItems): Shield Slam/Block/Bash, Holy Shield, Sniper Shot, Mutilate, Backstab, Ambush.
  - Talentlevels: AFGELEID.
  - Wapenregel: gids, nooit "best/moet".
  - Geen gidsregel waar het onderzoek niets noemt: alle casters, Holy Paladin, Ele/Resto Shaman, elke Druid, Survivals melee-wapen. Dan staat er dat de gidsen niets noemen.
  - Stats bewust weggelaten (gids, level 60; hoort bij stap 3).
  - Namen uit de client: spells via C_Spell.GetSpellName, pantser/wapensoort via GetItemSubClassInfo.
- `ForeverHowToPlay.lua`: blok bovenaan (Body), ververst bij wisselen.
- `ForeverWeapons.lua`: groen + voor passende soorten, regel onderaan (FWEAP_DIR_*), niets verborgen. `ns.ForeverDirectionChanged` ververst beide.
- Offline (scratch `dirblock_test.lua`): 27/27 blokken, geen ontbrekende sleutel, zonder keuze geen blok. Niet in het spel gezien.
- Niet gebouwd: stap 3 (tooltip/upgrade-melding).

## 🔎 12 nov (avond) — Forever-groepsmeting gelezen (partyProbe, Forever-SV 15:11, regels 2053-2526)

- Groep: Rob + 1 character van Cisca's pc, open wereld (instance "none"), 1 snapshot met de hand + 5 gevechten
  (15:08:09-15:11:07), build 70888. party2-4 bestonden niet.
- GEMETEN, ook in een gevecht leesbaar: bestaat, naam, class, rol (UnitGroupRolesAssigned; allebei "DAMAGER"),
  canAttack/canAssist, voor player, party1, target, focus en party1target.
- GEMETEN, in een gevecht GEWEIGERD: debuffs lezen (C_UnitAuras.GetAuraDataByIndex → "Auras cannot be accessed when secret
  while tainted by 'MidnightHelper'"), op elke unit, in alle 5 gevechten. Buiten een gevecht: "nil" (leesbaar, niets op).
  Dat is precies de retail-situatie.
- GEMETEN: alle 15 events van PartyTargets bestaan; SecureActionButtonTemplate bouwt; Blizzards AuraContainer (de rode
  dispel-rand) bouwt met SetUnit/AddAuraSlot/SetEnabled. Focus: `[@focus,exists]` parse werkt ("no" zonder focus).
- NIET GEMETEN: casts (altijd "nil", er werd niets gecast op het moment van de foto); of de rode rand in Forever echt
  oplicht; een dungeon; 3-5 spelers. PartyTargets leunt op DispelHelper.lua (retail) en spec-API's → overzetten = werk.
- Plan met opties naar sparring gestuurd; niets bouwen zonder Robs ja.
- ✅ Rob koos (via sparring, letterlijk): *"A, eerst klein"*. Gebouwd: `Modules/ForeverPartyPanel.lua` (beide tocs; returnt
  op retail). Rijen you+party1-4 (naam/class-kleur/rol), secure knoppen op UIParent ZONDER scripts (`*type1`=target,
  `type2`/`spell2` = eerste dispel, `shift-type2`/`shift-spell2` = tweede), RegisterUnitWatch, handmatig over de rijen
  gezet buiten gevecht. Rode rand: AuraContainer per rij met vaste unit (nooit opnieuw binden), canvas als kind van de
  slot maar vast aan onze rij, zonder muis. Dispels: namen/id's uit `FOREVER_SPELL_IDS` (DB2), welke class welke is
  alleen volgorde; IsPlayerSpell beslist. Standaard UIT: `ns.db.foreverPartyPanel`, instelling `mh_foreverPartyPanel`,
  `/mh partytargets` (zelfde commando als Midnight) + `check`. In `MoveMode.lua` en `tools/window_check.py` (EXEMPT,
  eigen Shift+scroll). Geen stop-spell (optie B). NIET GEMETEN: of de rode rand in Forever oplicht → Robs dungeontest.
- ✅ Rob zag het (18.png): "Het groepspaneel staat er, de rijen kloppen". Daarna (Rob via sparring: *"Ja, doe dat"*): het
  paneel is zo hoog als de groep (`FitToGroup`, alleen buiten een gevecht; anker TOPLEFT via `PinTopLeft`, dus alleen de
  onderkant schuift). Alleen getoonde rijen krijgen een live knop (`panel._mhRowsShown`), dus wie in een gevecht
  erbij komt, krijgt rij én knop pas daarna. Geen schakelaar voor de vaste maat (sparring: "pas bij een klacht").

## 🛠️ 12 nov (avond) — Forever: gereedschap-tip ook bij de foutmelding van het spel

- Rob (via sparring): Cisca had Skinning maar geen mes; de leer-tip kwam nooit (beroep al van vóór MH). *"Ja, laat hem dat
  uitzoeken en bouwen"*.
- GEMETEN in Forever DB2 1.60.1.70888:
  - De fout is GlobalStrings SPELL_FAILED_TOTEM_CATEGORY / SPELL_FAILED_TOTEMS "Requires %s".
  - TotemCategory 162 Blacksmith Hammer, 165 Mining Pick, 166 Skinning Knife, met de namen per client in de/fr/es/esMX/pt/ru.
  - Vissen: SPELL_FAILED_EQUIPPED_ITEM_CLASS(_MAINHAND) "Must have a %s equipped".
- ✅ Gebouwd in `ForeverVendors.lua`:
  - UI_ERROR_MESSAGE → OnToolError: tekst gelijk aan format(global, naam) → dezelfde tip ("For this you need a …", tipNeed).
  - Hooguit 1× per gereedschap per 10 min; stil als er een gereedschap in je tassen zit.
  - Schakelaar `ns.db.foreverToolNeedTip`, instelling `mh_foreverToolNeedTip`, `/mh vendor tip on|off`.
  - `/mh vendor check` toont de laatste gematchte fout + de laatste fout van welke soort ook.
- AFGELEID, niet in het spel gezien: dat het bericht precies zo als 2e argument van UI_ERROR_MESSAGE binnenkomt.
- ⚠️ De oude leer-tip had nooit een uit-schakelaar (sparring dacht van wel); deze nieuwe heeft er wel een.
- ✅ Rob testte het: GOED (17.png, via sparring). Daarna (Rob via sparring, gedicteerd: *"ja, die regelt ronde maar voor het
  skinny knife ook"*, teruggelezen als "ja, die regel erbij"): de chatregel van de tip (leren én foutmelding) eindigt nu
  met `FVEND_TIP_LIST_FMT` "Type /mh vendor <key> for the list of sellers." (`TipChat` in `ForeverVendors.lua`). De
  10-minutenrem blijft (Rob: "Misschien terecht ook").
- `/mh move`: Rob "mh move werkt :)". Niet gemeld: plek na /reload, buff-icoon cast na slepen.

## 🔎 12 nov (avond) — dispelTryLog na Robs run (Voidscar Arena, Prot Paladin): uitslag, niets gebouwd

- Sparring las het (8 regels, rij 5 = player, in gevecht): 5× cast 213644, 1× failed, 2× "Spell is not ready yet".
  Rob: *"Hij bleef continu rood. Eén keer dacht ik dit wel deed, na de zoveelste keer rechtsklikken."*
  `/mh prompt test`: helemaal goed (woorden los, plek blijft na /reload).
- GEMETEN in de code: "cast" = `UNIT_SPELLCAST_SUCCEEDED` (`PartyTargets.lua:749-774`), dus echt geslaagde casts.
- GEMETEN in DB2 12.1.5.70783: Cleanse Toxins 213644 → SpellCategories ChargeCategory 1512 = "Class - Paladin - Cleanse",
  MaxCharges 1, ChargeRecoveryTime 8000; GCD 1500 (StartRecoveryCategory 133). Corrosive Essence 1289258:
  SpellAuraOptions CumulativeAura 10 (stapelt tot 10).
- Casts 2 s na elkaar kan dus niet met een cooldown van 8 s die echt start. AFGELEID: de cooldown startte niet, dus de
  cast haalde niets weg (Blizzards regel dat een dispel die niets weghaalt geen cooldown krijgt; niet in deze build
  gemeten). "Not ready yet" kan dan de GCD zijn. Andere mogelijkheid: het gif werd meteen opnieuw gezet. Voorstel aan
  sparring: een kleine meting (na elke eigen dispel 0,3 s later de charge/cooldown in `dispelTryLog`), pas op Robs ja.
- ✅ Gebouwd (Rob via sparring: *"Ja, bouw dat"*): `PartyTargets.lua` NoteDispelCooldown — 0,3 s na elke geslaagde eigen
  dispel zet hij op die logregel `cd` = "started" (duration > 2 s) / "not started" / "unreadable" (+ `cdDur`,
  `cdCharges`, `cdWhy`). LogDispelTry geeft nu zijn regel terug. luac schoon, lint 0 HARD. NIET GEMETEN: of
  C_Spell.GetSpellCooldown in een gevecht leesbaar is — daarvoor staat "unreadable" erin. Rob: één dungeonrun (niet vandaag).

## 🛠️ 12 nov (avond) — vier Forever-klussen terwijl Rob at (bouw-ja via sparring, Robs keuzes letterlijk)

Rob: *"Kunnen we daar niks van bouwen, dat dat zo meteen nog kan gaan testen"*; hij koos alle vier de opties. Geen release.
1. ✅ Gebouwd: **"Which way do you want to go?"** — `Modules/ForeverDirection.lua` (beide tocs; returnt op retail). Vraagt
   na het inloggen (6 s, wacht op gevecht/film/de balkenvraag/een StaticPopup, max ~2 min), keuze per character in
   `ns.db.foreverDirection[GUID]` (1-3 = boomband), `ns.db.foreverAskDirection == false` = uit. Boomnamen uit
   `ForeverMacros.lua` SPEC_NAMES (nu `ns.ForeverSpecName`/`ns.ForeverSpecBand` geëxporteerd). Zinnen = FDIR_<CLASS>_<n>
   (AFGELEID, uit `docs/forever/RICHTINGEN_PER_CLASS_2026-11-12.md`). `/mh direction` / `richting`, `check`, `on|off`;
   knop in het How-you-play-venster; instelling `mh_foreverAskDirection`. Nog niets leest de keuze
   (`ns.GetForeverDirection()` is er voor de volgende stap).
2. ✅ Gebouwd: **alle ontbrekende buffs** — `MissingBuff.lua` (ShowExtras: max 5 kleine icoontjes rechts, alleen tonen;
   AddTooltipExtras: "Why …" + "Also missing"), `ForeverBuffs.lua` (PickChoice geeft "last"/"first", Entry krijgt
   pickWhy/pickOthers). Zelfde filter als het grote icoon (combat, formApi).
3. ✅ Gebouwd: **"Move"** — `Modules/MoveMode.lua` (beide tocs), `/mh move` (+ `why`, `on|off`), instelling `mh_moveMode`
   (niet bewaard). 11 onderdelen op framenaam; het groene vakje roept de EIGEN OnDragStart/OnDragStop van het onderdeel
   aan (FastMark via `bar._mhDragHandle` = de grip). Vakje niet verankerd aan het onderdeel (protected-frames), maar
   2×/s erboven gezet. Verborgen onderdelen worden zolang getoond; gevecht = uit. MissingBuff verbergt het lege icoon
   niet zolang Move aan staat.
4. ✅ Uitgezocht (mh-research): `docs/forever/BEROEPEN_2026-11-12.md` (O26), tabel voor Rob bovenaan. 12 beroepen (9
   primair, kies 2; 3 secundair), ranks 75/150/225/300; nieuw: Camping (kamp-spullen bij elk beroep), healing potions bij
   First Aid. NIET gemeten: level per rank (alleen Warcraft Tavern), kosten bij 9 van de 12 trainers. Twee bijvangsten
   (AFGELEID, niet gecontroleerd): `tools/forever_reagents.py:15` noemt de Herbalism/Skinning/Fishing-recepten "housing" maar
   het zijn kamp-spullen (dus "Used for" mist ze); de open vraag in `ForeverToolGuard.lua` lijkt beantwoord door DB2
   TotemCategory (beter gereedschap dekt het lagere). Niets gebouwd.
- Teksten: en + nl zelf; de/fr/es/pt/ru (+ it voor buff/move) door mh-writer. Checks: luac -p schoon op alle 12 bestanden
  (positieve controle: een kapot bestand werd geweigerd). Testlijst: 12 nov (avond), drie blokken.

## 🔎 12 nov — Rode eigen rij in het groepspaneel: wat `dispelSelfLog` zegt (alleen gelezen, niets gebouwd)

- Rob (via sparring): zijn eigen rij wordt rood en hij kan het niet dispellen; speelt "al langer".
- GEMETEN in Robs retail-SV (bewaard 12 nov 12:15), `dispelSelfLog`, 34 regels, scratch `selflog.py`: sinds de
  drie-filter-versie (vanaf 9 okt, 27 regels) raakte `HARMFUL|RAID` (= het filter van de rode rij) ALLEEN debuffs met
  youCan=true (3 van 3) en NOOIT een met youCan=false (0 van 24; die 24 raakten alleen `HARMFUL|DISPELLABLE`). Na een
  gevecht klopt het rij-filter dus. De 4 valse Magic-regels van 27-30 sep zijn van vóór die versie.
- ⚠️ Gaten: (1) de log heeft GEEN character of spec. "Rabid Bite, disease, youCan=false" kan niet op een Prot Paladin
  (Cleanse Toxins haalt disease weg), dus dat waren AFGELEID andere characters. (2) Hij meet alleen 1 s NA het gevecht.
  Wat de rij IN het gevecht doet, kan MH niet zien (scannen wordt geweigerd). (3) Geen regel van 12 nov.
- Voorstel naar sparring: meten met de ogen + `/mh glow` (recent casts and errors) op het moment zelf. Klein voorstel om
  te bouwen: character + spec bij elke `dispelSelfLog`-regel.
- 💡 Nieuwe wens (O27 in IDEEEN): MH legt de rode rij zelf vast. ✅ Gebouwd (Rob, via sparring: "Ja, bouw het"):
  `PartyTargets.lua` — `RowSignal` (bovenin) via OnShow/OnHide op ons rode canvas (PaintDispelSlot) →
  `ns.db.dispelRowLog = { signals = {show, hide, showInCombat, hideInCombat}, events = {…max 40} }`; per moment row, unit,
  at, seconds, inCombat/endInCombat, zone, char/class/spec, castsAtStart/castsAtEnd (kopie castLog), en na het gevecht
  `afterFight` (samenvatting van de drie-filter-scan; `AfterCombatWithRowLog`). Offline 8/8 (scratch `rowlog_test.lua`),
  stop-spell-proef nog 7/7, lint 0 HARD. NIET GEMETEN: of OnShow in een gevecht vuurt — daarvoor zijn de `signals`.
  Rob: `/reload`, dungeonrun, `/reload`; dan lees ik het.
- ❌ Uitslag run 12 nov (SV 12:46, zelf gelezen, regels 140227-140366): signals show=10, hide=0, in gevecht 0; 10 events
  = 2× alle 5 rijen tegelijk (12:44:16 en 12:44:46), buiten gevecht, nooit een einde, castsAtStart leeg. char/spec
  klopt. Het seintje meet dus NIET "de rij is rood". AFGELEID: Blizzards aura-slot wordt bij de opbouw één keer getoond
  en daarna via alpha aan/uit gezet, niet via Show/Hide. `dispelSelfLog` heeft geen regel van 12 nov (niets bleef
  hangen na een gevecht). Buff-zin in gevecht: ✅ Rob, screenshot 13.png. Gestopt; nieuw voorstel naar sparring.
- ✅ Optie A gebouwd (Rob, via sparring: "Optie A, dispel-pogingen"): seintje + `RowSignal`/`afterFight`-koppeling eruit;
  `dispelRowLog` wordt bij PLAYER_LOGIN gewist. Nieuw: `ns.db.dispelTryLog` (max 40) via de bestaande `castWatch`:
  elke cast/failed van JOUW dispel (`IsMyDispel`: id of naam van `GetPlayerDispelIcon`) en elke UI_ERROR_MESSAGE terwijl
  de muis op de dispel-helft van een rij staat (`DispelRowUnderMouse`, GetMouseFoci = alleen lezen, niets op de secure
  knop). Per regel: kind, spellID, text, row, unit, at, zone, inCombat, char/class/spec. ⚠️ Een fout van een ANDERE
  toets terwijl de muis toevallig op een dispel-helft staat, telt ook mee (AFGELEID, zeldzaam; text maakt het
  herkenbaar). Offline 7/7 (scratch `rowlog_test.lua`), stop-spell 7/7, lint 0 HARD. Niet in het spel gezien.
- 🔎 Rob (via sparring): "Ja, de rij was rood bij Corrosive Essence. En ik heb toen aan de linkerkant met mijn
  rechtermuisknop proberen te dispellen." GEMETEN (DB2 SpellCategories 12.1.5.70783): Corrosive Essence 1289258
  DispelType 4 = Poison, dus het rood was terecht. Code nagelopen: eigen rij = unit "player", gebonden buiten
  gevecht, spell2 = "Cleanse Toxins" (naam) — geen harde fout gevonden. Kandidaten (AFGELEID): (1) de klikknop
  vuurt op neer én op op (`RegisterForClicks("AnyUp","AnyDown")`, FastMark.lua:18 noemt dat) → tweede poging "Spell is
  not ready yet"; (2) Cleanse Toxins heeft 8 s cooldown (ChargeCategory 1512) en de debuff komt terug. `dispelTryLog`
  moet het beslissen; niets nieuws gebouwd.
- ✅ Gebouwd (Rob, via sparring: "Ja, bouw dat"): elke nieuwe `dispelSelfLog`-regel krijgt `char` (UnitName), `class`
  (token) en `spec` (spec-ID), in `AfterCombatDispelCheck`. Alleen meten, niets zichtbaars. Oude regels blijven zonder.

## 🆕 12 nov — Robs Midnight-test deel 2 (follower dungeon, Prot Paladin, via sparring)

- ✅ Groepspaneel: rijen netjes, `/mh glow` "no purge, so your stop-spell: spell 96231", 5 rechterhelften gewapend.
  Rebuke-rechtsklik: "out of range, dat klopt"; een raak-Rebuke nog niet gezien. ✅ `/mh prompt test`: slepen en
  Shift+scroll werken (na de woordfix 3361a0b? onbekend; na-reload niet gehoord). ⏳ Upgrade-melding: niet te testen.
- ❓ Buff-zin in gevecht: de melding verdween helemaal. GEMETEN in code: `ns.UpdateMissingBuff` (MissingBuff.lua:819)
  verbergt alles als `ns.Aura.Trusted()` false is (`C_Secrets.ShouldAurasBeSecret`). Dat is bewust ontworpen (Cisca's
  schild-spam, 5 jul). Maar de Paladin-aura wordt NIET via aura's gelezen maar via de vormen-API (`InAnyForm`, :385-389,
  showCombat=true), dus die zou kunnen blijven staan. AFGELEID dat het die regel was. Voorstel naar sparring: eerst
  `/mh mbuff` in een gevecht laten meten; dan vormen/stances/aura's (vormen-API) uitzonderen op de aura-regel.
  Rob (via sparring): *"Eerst meten"*. `/mh mbuff` print nu ook "→ form: GetShapeshiftForm=… secret=… inCombat=…" (alleen
  diagnose). Bouw daarna gedekt ALS de meting auras-trusted=false én form niet-secret laat zien; anders nieuw voorstel.
- ✅ Meting binnen (screenshot 11.png, zelf gelezen): ShouldAurasBeSecret=true, auras-trusted=false,
  GetShapeshiftForm=0 secret=false inCombat=true. Gebouwd: entries van de Paladin-aura (465) en Warrior-stances krijgen
  `formApi = true`; `ns.UpdateMissingBuff` toont bij onbetrouwbare aura's alleen nog die (gewone buffs blijven zwijgen);
  `/mh mbuff` zegt het. Pets (UnitExists) bewust NIET meegenomen: Rob koos alleen aura's en stances. Lua OK. Niet in
  het spel gezien.

## 🆕 12 nov — Onderzoek: richtingen per class in Forever (Rob: "Ja, alle classes", via sparring; GEEN bouw-go)

- `docs/forever/RICHTINGEN_PER_CLASS_2026-11-12.md` (mh-research, 1 onderzoek, vaste vorm per class). GEMETEN: 9 classes
  (ChrClasses 70888), 3 TalentTab-bomen per class, geen spec-knop; eerste talentpunt level 10 (TraitCurrencySource 3820),
  Legacy-perk "Talented" vanaf 5; Dual Spec level 40 (client-strings), respec bij de class trainer. NIET gemeten: respec-
  en dual-spec-prijs (50 g = alleen Wowhead), Legacy-reset, beste wapen voor een deel van de richtingen, stats tijdens
  het levelen.
- ✅ Twee tegenstrijdigheden in ONZE code, gemeten en gelijkgetrokken (Rob, via sparring: "Ja, laat hem die twee
  spell-levels meten en gelijktrekken"). GEMETEN in DB2 wowf 70888 (TraitDefinition → TraitNodeEntry →
  TraitNodeXTraitNodeEntry → TraitNodeGroupXTraitNode → TraitNodeGroupXTraitCond → TraitCond): Stormstrike TraitCond
  42798 = 15 punten → level 25 (`ForeverMacros.lua` van 40 naar 25; HowToPlay zei al 25). Primal Bite TraitCond 42781 =
  30 punten → level 40 (addon klopte al; de beta-"16 punten" is oud). Rekenregel: eerste punt op 10, 1 per level, dus
  rij-drempel N → level 10+N (zonder de Legacy-perk "Talented", die alles 5 levels eerder maakt). Niet in de client gezien. Icy Veins zet Intellect vóór Strength bij Enhancement (ouder dan onze bron).
- ⚠️ mh-research leest niets in `docs/`: de 8 klasbestanden `docs/forever/FOREVER_<CLASS>_2026-11-06.md` zijn NIET
  vergeleken met dit onderzoek.

## 🆕 12 nov — `/mh prompt test` + Robs Midnight-test deel 1 (Rob: "Ja, laat hem dat bouwen", via sparring)

- Aanleiding: `/mh prompt` is een aan/uit-schakelaar, dus Rob kon Shift+scroll niet testen. `ns.PreviewActionPrompt()`
  (ActionPrompt.lua) houdt het ECHTE frame met beide iconen 20 s in beeld (eigen interrupt/purge-icoon, anders vraagteken
  134400), ook als de hint uit staat; `Update()` laat ze zolang met rust; een gevecht stopt het voorbeeld meteen (geen
  apart pad, dezelfde frame/plek/maat). Core.lua: `/mh prompt test`. Nieuwe sleutels PROMPT_TEST_FMT/PROMPT_TEST_COMBAT,
  7 talen (de/fr/es/pt/it/ru eigen vertaling, niet native nagekeken). Lua OK, lint 0 HARD. Niet in het spel gezien.
- 🐛 Rob, 12 nov (screenshot via sparring): onder de icoontjes liepen INTERRUPT en PURGE door elkaar. Oorzaak GEMETEN in
  de code: elk woord stond gecentreerd onder zijn eigen 34 px-icoon, maar is breder dan het icoon. Dat gebeurt ook in
  een echt gevecht als beide tegelijk oplichten. Fix in `MakeIcon`: woord 1 rechts uitgelijnd links van icoon 1, woord 2
  links uitgelijnd rechts van icoon 2. Niet opnieuw in het spel gezien. Slepen/Shift+scroll/na-reload: nog niet gehoord.
- Robs uitslag (via sparring, 12 nov), afgevinkt in TESTLIJST: selftest weg uit de lijst + werkt nog; partytest Midnight
  goed; "Used for" Midnight goed (Azeroot groen, Argentleaf grijs, Mycobloom geen regel, `/mh usedfor` herkent
  INSCRIPTION line 773 als "you have"); buff-zin Midnight goed; Macro's-tab "Top" goed. Open: of oudere ingrediënten óók
  een regel krijgen (vraag bij Rob via sparring; tot dan niets doen); groepspaneel deel 2 volgt.

## 🆕 12 nov — "Eén voordeur" vastgelegd + `/mh partytest` werkt weer in Midnight (Rob: "Ja, doe allebei", hier zelf)

- 🚪 Afspraak "één voordeur", proef t/m do 19 nov (Rob in sparring: "Ja, één voordeur, een week proef"; hier zelf "Ja,
  doe allebei"): blok bovenaan `CLAUDE.md` + regel in `~/.claude/skills/nieuwe-chat/SKILL.md` (ook in elke prompt) en
  `~/.claude/skills/verder/SKILL.md`. De recepten staan buiten de repo (niet in git). Na 19 nov beslist Rob.
- 🐛 `/mh partytest` in Midnight: de Forever-meting (Core.lua ~2564) ving elke "partytest" af en zei "is for WoW:
  Forever"; de solotest verderop werd nooit bereikt (helpers sparring, GEMETEN in de code). Nu: geen Forever-meting →
  kaal `partytest` = `ns.TogglePartyTargetsSoloTest()`; de oude dode tak (~4019) is weg. Lua-syntax OK, lint 0 HARD.
  ⚠️ Lint [16] telt nu 237 i.p.v. 238 gerouteerd: zijn patroon ziet `msg:lower() == "partytest"` niet (blinde vlek,
  [27] ziet hem wel). Niet in het spel gezien.
- Ook: commentaar `ForeverMacros.lua:245` klopte niet ("zelfde volgorde als Kick en Shield Bash"); Hammer is muis →
  focus → doelwit, net als Sap en Blind. Alleen het commentaar veranderd.

## 🆕 12 nov — Midnight-groepspaneel: stop-spell op het doelwit als je geen purge hebt (Rob: "Optie 1, jouw advies", via sparring)

- Beantwoordt punt 6 van "Open voor 12 nov". Optie 1 = "Purge blijft, en wie geen purge heeft krijgt zijn stop-spell".
- `PartyTargets.lua`: `GetPlayerStopSpell()` leest `ns.KeybindRoleClassifier[class]` (role "interrupt", mét id, spec in
  `specs` of geen `specs`, en `IsPlayerSpell`, fails closed; laagste priority). `ns.PartyTargetsTargetHalfSpell()` =
  purge, anders stop-spell, anders nil. `ApplyDispelAttributes` gebruikt dat voor de rechterhelft (zelfde regels:
  buiten gevecht, opnieuw na spec-/talentwissel). `/mh glow` zegt welke van de twee en telt de gewapende rechterhelften.
- Offline test (scratch `stopspell_test.lua`, PartyTargets echt geladen): 7/7 — Prot Paladin → Rebuke 96231, Holy Paladin
  → niets, Ret zonder Rebuke → niets, Shadow Priest → purge 528 wint, Warlock (pet-kick zonder id) → niets, Warrior →
  Pummel, Mistweaver → niets. Lua-syntax OK, lint 0 HARD. NIET in het spel gezien.
- Specs die leeg blijven (AFGELEID uit de KeybindRoles-tabellen): Holy Paladin, Mistweaver, Resto Druid, Preservation
  Evoker, alle Warlocks (Spell Lock/Axe Toss = pet, geen id). Open keuze voor Rob (via sparring): krijgt zo'n spec iets
  anders, bv. een stun? Niet gebouwd.
- Robs keuzes daarna (via sparring, letterlijk): lege specs → *"Leeg laten (Recommended)"* (geen stun); spelerstekst →
  *"Ja, een zin erbij (Recommended)"*. Gedaan: "Right-click a player to dispel them; right-click their target to purge
  it, or to interrupt it if you have no purge." achter `CMDLIST_PARTYTARGETS` en `SET_PARTYTARGETS_DESC`, in 7 talen
  (de/fr/es/pt/it/ru door mh-writer, eigen vertaling, niet native nagekeken; `check_drift --mark` gedaan). deDE: de
  helper koos "entzaubern" (uit PROMPT_WORD_PURGE), maar dat is in dit pack ook disenchanten; ik maakte er "bannen" van.
  📌 Open: PROMPT_WORD_PURGE = "ENTZAUBERN" in deDE zelf nog nakijken tegen de client. ruRU zegt voor dispel én purge
  развеять (het pack heeft geen apart woord).
- Ook van Rob (via sparring, 12 nov), alleen noteren: beroepenadvies bij idee 7 = *"Ja, misschien is het wel een goed
  idee"* (richting, geen bouw-go; ontwerp idee 3 + 7 later die dag: *"Schets klopt"*, eerst Forever, staat in IDEEEN bij
  beide regels, GEEN bouw-go); de "+37% upgrade"-regel van een andere addon stoort NIET (*"Nee, juist niet, want
  niet iedereen heeft dat"*), onze regel blijft; idee 3 + 7 als één ontwerp praat sparring eerst met Rob door. Nieuw in
  IDEEEN: O26 (Forever-beroepenuitleg); O21 kreeg de datum van 12 nov.

## 🆕 12 nov — lint [27]: geen commando's die alleen wij gebruiken in de release-tekst (Rob: "Ja, bouw dat", via sparring)

- Aanleiding: 5.1.0 noemde `/mh selftest` (Rob 11 nov: "dingen … die alleen wij doen, dat is niet handig"); eb3e22a
  haalde het al weg. Opdracht van Sparring 12-11 (plan stap 10: regels worden controles).
- `tools/release_text_check.py`: lijst `DEV_ONLY` (29 namen: selftest, partytest, probes, scans, dumps; GEMETEN: alle 29
  gerouteerd) + `dev_only_check()`. Leest RELEASE_NOTES.md, `docs/CURSEFORGE_<toc-versie>.md` en de
  `CHANGELOG_<ver>_*`-regels in enUS.lua. Niet CHANGELOG.md of de handoff. Uit-schakelaars en `/mh report`/`/mh arrow`
  horen er NIET op. Lint [27], HARD (Rob: "een fout"); blokkeert niets, want 5.1.0 op main is al schoon.
- Proef: de twee weggehaalde 5.1.0-regels → 2/2 gevangen; tegenproef (`pickup off`, `geartip off`, `report`, `trainer`)
  → 0. Nepnaam op de lijst → SOFT "stale". `run release_text_check --selftest` OK. `locale_index`/`routed_words`
  ongewijzigd (de site importeert ze).
- ✅ `/mh selftest` uit de spelerslijst (Rob: "Ja, haal hem weg"): rij weg uit `MH_COMMANDS`, naam in
  `MH_UNLISTED_ON_PURPOSE`. Het commando werkt nog; `CMDLIST_SELFTEST` (8 talen) blijft staan. Lint [16]: 92 listed /
  149 classified (was 93/148). Niet in het spel gezien.

## 🆕 12 nov — regisseur aangescherpt, hoofdstuk 6 van REGIE.md (Rob: "Ja, zet ze erin")

- Opdracht van Sparring 12-11: de ronde zag drie dingen niet (CLAUDE.md-grens 350, tabel 2 mist OCHTENDRONDE.md en
  CLAUDE_HISTORIE.md, tabel 3 rij 10 "niet begonnen"). Oorzaak GEMETEN: stap 4 noemde zelf "geen grens", en geen
  stap legde tabel 2 naast `docs/` of "niet begonnen" naast `tools/`/lint/hooks.
- Eénmalig geschreven in `docs/REGIE.md` (van de regisseur), drie regels: stap 4 grenzen uit de bron
  (`lint_addon.py` [24]), stap 5 tabel 2 naast nieuwe `docs/*.md`, stap 6 tabel 3 naast tools/lint/hooks + datum in
  de kop. De drie foute tabelregels zelf NIET gerepareerd: de proef is of de regisseur ze 13 nov zelf goed zet
  (sparring meet na). Het recept en de cloud-routine zeggen alleen "doe hoofdstuk 6" (routine-prompt NIET GELEZEN).

## 🆕 12 nov — Forever Priest-tip: Confounding Flash werkt wél in Shadowform (Rob: "Ja, doe allebei")

- Aanleiding: content-wachter 12 nov [RAAKT ONS]. Forever-hotfix 11 nov (news.blizzard.com 24315281): *"Confounding
  Flash (Gnome) can now correctly be used while in Shadowform."* Onze "Beginner mistakes"-regel zei het omgekeerde.
- Confounding Flash uit de zin gehaald in alle 8: `Modules/ForeverHowToPlay.lua:273` + `Locales/ForeverHowToPlay_`
  nlNL/deDE/frFR/esES/esMX/ptBR/ruRU. Chastise (Dwarf) en Fear Ward blijven: daar zegt de hotfix niets over
  (NIET GEMETEN of die echt niet werken). Niet in het spel gezien.
- Ook: dit bestand gesplitst (1588 regels, grens 1500), knip bij "🌙 6 nov, einde dag"; 348 regels / 21 secties
  naar `NEXT_SESSION_ARCHIVE.md`.

## 🆕 11 nov — Forever: Paladin-macro's Hammer of Justice + Purify (Rob: "Ja, alleen klein")

- `ForeverMacros.lua` CLASS_MACROS: `hammer` (853, level 8, `[@mouseover,harm,nodead][@focus,harm,nodead][]`) en `purify`
  (1152, level 8, mouseover/help/player). Uitleg zegt "stun, geen echte interrupt". 7 talen (it niet: Forever-blok).
- 👀 Rob zag de stun op mouseover werken (target bleef staan).
- ✅ Meting gebouwd (Rob: "maak die meting maar"): `Modules/ForeverPartyProbe.lua`, `/mh partytest [clear]` →
  `ns.db.partyProbe` (events, AuraContainer-gloed, focus, API's, per unit readable/secret zonder namen, plus 5
  gevechten automatisch 2 s na start, alleen in een groep).
- ✅ **Solo-meting binnen** (Rob, 11 nov 22:59, build 70888, GEMETEN in de SV): alle 15 PartyTargets-events valid
  (ook PLAYER_SPECIALIZATION_CHANGED en TRAIT_CONFIG_UPDATED); AuraContainer + CustomAuraContainerTemplate bouwt met
  SetUnit/AddAuraSlot/SetEnabled; FocusFrame bestaat, `[@focus,exists]` = yes (focus werkt); SecureActionButtonTemplate
  bouwt. Open: groep + gevecht (wat is secret bij party-leden en hun doelwit, rollen, en of de gloed echt verschijnt).
- 📌 **Midden (PartyTargets naar Forever) staat open tot de meting er is.** Eerst meten via SavedVariables: welke events
  Forever kent (PLAYER_SPECIALIZATION_CHANGED, TRAIT_CONFIG_UPDATED), of de AuraContainer-gloed werkt, wat
  UnitGroupRolesAssigned geeft, hoe secret naam/doelwit/class in een groep zijn, of `[@focus]`/`/focus` werkt. Deels
  alleen in een echte groep; solo-deel via een `/mh partytest`. Opdracht staat in de sparring-chat (11 nov).

## 🆕 11 nov — "Used for" ook in Midnight (Rob: "Ja, bouw het")

- `ForeverReagentUse.lua` → `Modules/ReagentUse.lua` (beide spellen; globals nu `ns.REAGENT_*`, eigen
  `MyProfessions` via `ns.REAGENT_LINES`, schakelaar `ns.db.usedForTip`, `ns.UsedForSlash`). Data per spel, elk
  bewaakt: `ForeverReagentData.lua` (524 items) en `MidnightReagentData.lua` (296 items, 6247 bytes).
- Midnight-regel (GEMETEN, 12.1.5.70783): recepten = SkillLineAbility met `SkillupSkillLineID` = "Midnight <beroep>"
  (2906-2918; de kolom `SkillLine` heeft 0 Midnight-rijen). Ingrediënten = SpellReagents (72) + kwaliteitsingrediënten
  via ModifiedCraftingSpellSlot → MCRSlotXMCRCategory → CraftingReagentQuality (228). 876 recepten, 9 beroepen
  (Midnight Mining heeft geen recepten met items). Controles: Practically Pork 242639 = Cooking, Eversong Trout 238383 =
  Alchemy/Cooking/Enchanting.
- itIT kreeg een eigen FUSE-blok (in Midnight is Italiaans echt). Offline test 19/19, lint 0 HARD. Niet in Midnight gezien.

## 🆕 11 nov — Forever: "MH: Used for Cooking" in de tooltip (Rob: "Ja, met probe-fix")

- `Modules/ForeverReagentUse.lua` (tooltip post-call, GameTooltip + ItemRefTooltip, altijd, ook in de tas) +
  gegenereerd `Modules/ForeverReagentData.lua` (524 items, 6955 bytes, één string `id:bits`, lazy geparsed).
  Generator `tools/forever_reagents.py` (`--report` / `--emit`, build 1.60.1.70888) met 4 positieve controles
  (Stringy Wolf Meat 2672 + Meaty Bat Wing 12223 = Cooking, Linen Cloth 2589 ∋ Tailoring, Copper Ore 2770 = Mining).
- Regel (GEMETEN aantallen): 2121 recepten tellen; 233 af (item niet in Forever-ItemSparse), 132 af (spell-id
  400000-1199999 = SoD e.d., AFGELEID uit de id-reeks), Herbalism/Skinning/Fishing (3 elk, housing-dingen) en Poisons
  (26, rogue-skill) bewust weg. 9 beroepen, Mining = omsmelten.
- Namen: eigen beroep = clientnaam (GetProfessionInfo); anders SkillLine.DisplayName_lang per taal (gegenereerd; itIT
  leeg = Engels, Forever itIT is Engels); anders Engels. Groen als je er één hebt, grijs als niet.
- Offline test (scratch `usedfor_test.lua`): 14/14 OK. ✅ AF (Rob: "Ja, af") na zijn screenshots: Linen Cloth,
  Stringy Wolf Meat (groen), Hearthstone (geen regel), `/mh usedfor`. De gewone tooltip zegt "Crafting Reagent" maar
  niet waarvoor. Skill lines 129/185/164/186 nu GEMETEN. Niet gezien: grijze regel, Copper Ore.
- Ook: `_probe.py` kijkt nu in álle scratchpad-mappen van dit sessie-ID, nieuwste job eerst (na een samenvatting
  had één sessie er twee; hits[0] las de oude).

## 🆕 11 nov — Stadsnamen = clientnaam (Rob: "volgen alles zoals het originele Blizzard-spel het geeft")

- Melding site-chat: de "Ironforge" en "Ventormenta" in de packs. GEMETEN met `gamedata db2 AreaTable` (10 plaatsen,
  8 locales, Forever 1.60.1.70888 én retail 12.1.5.70783).
- 🔑 **De Forever-client is anders dan retail.** Forever deDE zegt zelf *Ironforge*, *Undercity*, *Thunder Bluff*
  (retail: Eisenschmiede, Unterstadt, Donnerfels); Forever frFR *Thunder Bluff*; Forever itIT alles Engels; Forever ruRU
  *Дарнасс* (retail *Дарнас*). De Forever-routezinnen (`FWEAP_ROUTE_*`) klopten dus al; niets veranderd.
- Wel gerepareerd: esES/esMX retail-zinnen zeiden "Ventormenta", de client zegt "Ciudad de Ventormenta" (beide spellen).
  11 plekken: `Translations2026.lua` (LVL1080_1, 5× MOUNTRUN_HOW_*), `esMX.lua` (4), `Codex.lua` (1). Lint 0 HARD.

## 🆕 11 nov — CurseForge-plaatjes: `tools/cf_media.py` (Rob: "Ja, bouw het")

- Opdracht van de sparring-chat: hooguit 4-6 echte screenshots op één vaste ComfyUI-achtergrond (Rob koos "Nummer 2").
- `run cf_media --proef` zet `E:\MidnightHelper-media\` klaar (kopie van achtergrond, Cinzel-font, één screenshot,
  voorbeeld `shots.txt`) en tekent. `run cf_media` tekent elke regel van `shots.txt` (`bestand | titel | x,y,w,h`) naar
  `output\`. Alles buiten repo en WoW-map; het origineel in `E:\ComfyMCP\output` blijft staan.
- Vorm: 1920x1080, screenshot in vak (230,165)-(1690,935) zodat bureaurand en lantaarntop vrij blijven, rand #FFCC00
  3 px, zachte schaduw, titel Cinzel Bold 62 px goud bovenaan. GEMETEN in de proef: randpixel (255,204,0), Bold actief.
- ✅ AF (Rob: "Ja, goed zo"): zes plaatjes in `E:\MidnightHelper-media\output\` (01-04 + de nieuwe 05/06 van 200749 en
  200805; de oude 05/06 heeft Rob weggegooid, GEMETEN). Uitsnedes staan in `shots.txt`. Rob uploadde ze zelf
  naar CurseForge op 11 nov. CurseForge weigert plaatjes boven 2 MB (2: 2,08 MB, 3: 2,33 MB, GEMETEN): het script
  bewaart nu PNG als dat ≤ 1.950.000 bytes is, anders JPEG kwaliteit 95 zonder kleurverlies (2 → 0,62 MB, 3 → 0,77 MB;
  kleine tekst ingezoomd scherp). Gereedschap, niet in de release-tekst.

## 🆕 11 nov — stap a: Seal-tip en Claw-fix (Rob: "Seal-tip + Claw-fix")

- mh-research (`docs/forever/FOREVER_QUEST_LOCKED_SPELLS_2026-11-11.md`): Judgement = trainer, level 4 (MH klopt); hij
  vraagt een actieve seal (DB2 aura-state 5, GEMETEN; dat het "seal aan" betekent is AFGELEID), anders "You can't do that
  yet". "Continue Your Training" = quest 91209 (Undead Paladin), geen spell.
- How you play (Paladin, regel Judgement): zin "werkt alleen als er een seal aan staat, zet eerst je seal aan (3)" in 7
  talen; het foutbericht alleen in enUS/nlNL (Engelse client), de andere talen zonder (niet gemeten hoe hun client het zegt).
- `ForeverTrainerData.lua:86` Claw 3029 `req` 16942 (talent Sharpened Claws) → 1082 (SkillLineAbility 2077, GEMETEN).
  ⚠️ Dit bestand heet "GENERATED"; bij opnieuw genereren moet deze fix mee (commentaar staat op de regel).
- ✅ Daarna (Rob: "Ja, bouw dat"): `ns.FOREVER_QUEST_FIRST` in `ForeverTrainer.lua` (handmatig, ~45 spell-ids uit het
  onderzoek); is de ontbrekende eerste rank zo'n spell, dan `FTRAIN_NEEDS_QUEST_FMT` "(from a class quest, not from the
  trainer)". How you play: "(from a quest)" bij Redemption en Aquatic Form, Priest-rasspells "you get both from a quest".
  7 talen. Niet in het spel gezien. Stap a is hiermee af tot Robs test; volgende = stap b.

## 🆕 11 nov — Release 5.1.0 (Rob: "je krijgt een go om het live te zetten … Zowel voor forever als voor midnight")

- Rob koos release zonder testronde en zonder beta: *"Beta mensen reageren nooit. Zeker niet in de forever versie."*
  De sparring-chat adviseerde eerst een korte testronde (4 punten); Rob besliste anders. Die 4 (upgrade-melding,
  groene tooltipregel, buff-zin in Midnight/gevecht, "(loading...)") zijn NIET in het spel gezien en hebben elk een
  schakelaar. Eerste meldingen van spelers daarover = eerst kijken.
- Artefacten: beide toc's 5.1.0, `CHANGELOG_510_1..12` (enUS), `RELEASE_NOTES.md` = `docs/CURSEFORGE_5.1.0.md`,
  `CHANGELOG.md`. Tag `v5.1.0` → twee bestanden (Retail + `-forever`). Status CurseForge: zie SITE_SEIN.

## 🆕 11 nov — Stap e: Zygor-wachter (Rob: "Ja, door met stap e")

- `tools/zygor_watch.py` (`run zygor_watch`): kopie van alle gidsbestanden gzip in
  `%LOCALAPPDATA%\MidnightHelper\zygor_snapshot` (buiten repo en WoW-map), per bestand de diff. Detail met npc/quest/
  ach/goto alleen voor Midnight-bestanden met "MID" in de naam en alle Forever-bestanden; de rest alleen tellingen.
  Nieuw/weg altijd genoemd. Nulmeting 11 nov: Midnight 9.6 (717), Forever 1.6 (104); tweede run "no guide file changed".
  `--selftest`: kopie + nep-regel → gezien, precies één bestand: OK. In OCHTENDRONDE stap 16.
- Daarmee is de volgorde van 11 nov (a t/m e) gebouwd. Open: Robs tests (TESTLIJST bovenaan), selftest in Midnight.

## 🆕 11 nov — Stap d: melding bij een opgepakte upgrade (Rob: "Ja, allebei" = beide spellen)

- Nieuw `Modules/PickupUpgrade.lua` (beide toc's). BAG_UPDATE_DELAYED → links in de tassen tellen; een link die erbij
  kwam = nieuw. Niet bij: eerste telling na inloggen, verkoper/bank open, een link die je net droeg. Rode regel in
  `C_TooltipInfo.GetHyperlink` = overslaan. Oordeel Forever: `ns.ForeverGearTipText` (geeft nu ook `gains, why` terug);
  Midnight: `ns.GetLootUpgradeInfo`, alleen ilvl>0 én score>0. Melding via `ns.ShowBriefNotice` (7 s) + chatregel; in
  combat wachten tot PLAYER_REGEN_ENABLED. Item-data nog niet binnen → tot 5× elke seconde opnieuw.
  `/mh pickup [on|off]` (in de lijst). Offline getest (beter/slechter/rood/verkoper/uittrekken/gevecht, beide spellen).
- GEMETEN bij het voorstel: de Midnight-rekenaar = ilvl×8 + bijstats met spec-gewichten; zonder spec geen oordeel; hij
  kijkt zelf niet of je het kunt dragen (daarom de rode-regel-check). Niet in het spel gezien.
- Robs hamer-in-de-tas-test (verkoopwaarschuwing): ✅.
- ▶ Volgende: stap e (Zygor-wachter).

## 🆕 11 nov — Forever-verkoper: twee reparaties (Rob: "Ja, allebei")

- Selftest Forever, tweede run (GEMETEN in SV): item-controle nu OK (GetItemInfoInstant), alle drie OK, 0 ontbrekend.
  Midnight nog niet gedraaid.
- `ForeverToolGuard.lua`: "Right-click sells this…" stond ook bij de hamer in de KOOP-lijst van de verkoper (Robs
  screenshot), en bij 0 hamers (`n <= 1`). Nu alleen bij precies 1 en niet als de tooltip-eigenaar een
  `MerchantItem…`/`MerchantBuyBack…`-knop is (namen AFGELEID uit de Blizzard-verkoper; een andere verkoper-addon zou
  andere namen hebben).
- `ForeverVendors.lua`: de beroepstip bleef "(loading...)" zeggen (ook na de fix van 10 nov). Oorzaak niet gemeten.
  Nu drie wegen: tweede naamvraag (GetItemInfo), ItemMixin `ContinueOnItemLoad`, en 10× elke 0,5 s opnieuw kijken.
  Niet in het spel gezien.

## 🆕 11 nov — Stap c: `/mh selftest` + vensterregel C5 (Rob: "Ja, bouw het")

- **Eén bron:** `data_check.py` heeft nu `scan()` (C2 én de zelftest) en `--emit` → `Modules/SelftestData.lua`
  (gegenereerd; per soort komma-strings R/F/B, pas geparsed bij `/mh selftest`). Lint [26] SOFT als hij verouderd is:
  dan `run data_check --emit` en mee-committen. Stand: spell 1071, achievement 39, quest 341, item 25, map 72.
- **`Modules/Selftest.lua`** (beide toc's): spell `C_Spell.DoesSpellExist`, item `C_Item.DoesItemExistByID`, map
  `C_Map.GetMapInfo`; quest en achievement alleen geteld (geen betrouwbare "bestaat niet"-call). Controle in dezelfde run
  (6603/947/6948 moeten bestaan, 99999999 niet). Andere-spel-nummers overgeslagen; gedeelde-bestand-nummers die hier
  ontbreken apart. Stukjes van 400 per frame; niet in combat. Rapport → `ns.db.selftest` (laatste run). Offline getest
  (2 ontbrekend gevonden, "alles bestaat"-spel faalt de controle, combat geweigerd). In `/mh`-lijst + zoekbalk. 7 talen.
- **C5 = `tools/window_check.py`, lint [25] HARD:** elk benoemd frame op UIParent zit in `SCALABLE_WINDOWS`, wordt binnen
  120 regels aangemeld (`RegisterMidnightDialogPopup`/`MakeMidnightWindowScalable`), of staat in `EXEMPT` mét reden.
  Telling 11 nov: 81 frames, 54 schaalbaar, 27 uitzondering, 0 fout. Eén echt gat gevonden en gedicht:
  `MidnightHelperActionPrompt` (`/mh prompt`) → `SCALABLE_WINDOWS`. Blinde vlek: frames zonder naam.
- Lint [10] kent nu ook `msg:lower() == "x"` als route.
- **Robs eerste run, Forever (GEMETEN in zijn SV):** 1164 nagelopen, 0 spells/kaarten ontbreken; maar
  `C_Item.DoesItemExistByID(99999999)` = **true** in Forever → controle faalde (terecht). Reparatie ("Ja, repareer"):
  items via `GetItemInfoInstant` (AFGELEID, de controle beslist), en de controle per soort: een soort die faalt wordt
  overgeslagen en genoemd (`SELFTEST_UNTRUSTED_FMT`), de rest telt. Offline getest. Ook gezien: 21 kaarten + ~80 spells
  uit gedeelde bestanden ontbreken in Forever (DK-spells, nieuwe kaarten) = verwacht, staan apart.
- Niet in het spel gezien. ▶ Volgende: Robs eerste `/mh selftest` in Forever + Midnight lezen; daarna stap d (melding
  bij het oppakken van een upgrade), e (Zygor-wachter).

## 🆕 11 nov — Stap b: alleen een tooltipregel (Rob: "Alleen tooltipregel")

- GEMETEN (Robs Forever AddOns.txt, Ima-Pallie): Pawn + Baganator aan. Pawn doet al pijltjes + tooltip; Baganator
  vervangt de Blizzard-tassen waar `BagUpgrade.lua` aan hangt → retail-pijltjes overzetten heeft geen zin.
- Gebouwd in `ForeverQuestHint.lua` (zelfde rekenwerk als de questbeloning-tip; `Explain`/`IsBetter` nu gedeeld):
  `TooltipDataProcessor.AddTooltipPostCall(Item)` op GameTooltip/ItemRefTooltip → groene regel `FGEAR_TIP_FMT` alleen
  als het item beter is. Stil bij: rode regel in de tooltip (kan niet dragen; AFGELEID dat Forever rood kleurt), al
  gedragen, niet beter. `/mh geartip [on|off]` print de laatste beslissing. 6 talen (geen itIT: Forever).
- Offline getest (scratch `geartip_test.lua`). Niet in het spel gezien. NIET gemeten: of TooltipDataProcessor in
  Forever bestaat (Pawn/Auctionator/PaladinPlan gebruiken het daar = kandidaat, geen bewijs); zo niet, dan zegt
  `/mh geartip` dat.
- ▶ Volgende: stap c (`/mh selftest` + vensterlijst, opdracht 7 fase 0.3).

## 🆕 11 nov — Buff-melding wordt een zin (sparring-opdracht na PaladinPlan; Rob: "Ja, met jouw advies")

- Keuzes van Rob: beide spellen; icoon blijft op zijn plek (CENTER 0,+160 of waar de speler het sleepte).
- `MissingBuff.lua`: label GameFontNormal, goud (1, 0.82, 0.1), tekst uit `ns.MissingBuffSentence(entry, inCombat)` =
  `MBUFF_TXT_<kind>_SAY` (%s = spellnaam uit de client) + `MBUFF_SAY_CLICK` / `MBUFF_SAY_IN_COMBAT`. Onbekende soort →
  `MBUFF_TXT_MISSING_SAY`. `/mh buffs` en `/mh mbuff` printen dezelfde zin.
- Fout a (GEMETEN in de code): Forever-paladin-blessings zonder `covers` → Greater Blessings toegevoegd.
- Fout b (GEMETEN): `MBUFF_EUI_OVERLAP_HINT` + commentaar + `/mh mbuff`-regel zeiden "in combat klikbaar"; dat is
  niet zo ("[combat] hide"). Herschreven, 7 talen.
- Fout c (GEMETEN): `ns.PrintMissingBuffDebug` stond ín `EuiReminderLoaded` → losgehaald.
- Offline getest (scratch `buff_test.lua`): zinnen, Greater Blessing telt, controle gewone blessing, debug zonder C_AddOns.
  Niet in het spel gezien. Vier ideeën in IDEEEN.md (Ja, later). PaladinPlan = GPL-3.0: niets overgenomen behalve het idee.

## 🆕 11 nov — Forever: trainerplekken (Rob: "Alle drie", na zijn melding: pijl 12 m naast Aramis Hammerhand)

- GEMETEN: Wowhead geeft Aramis als "31, 66.2"; bijna alle trainer-/verkoperplekken in MH staan op één decimaal (218/217
  class, 313/313 beroep, 405/405 verkoper), met een heel getal voor x of y bij 60 class-, 98 beroeps- en 158 verkoperrijen.
- 1) `ForeverTrainerSpots.lua` Aramis → 31.11, 66.38 (Robs meting, coördinaat-regel).
- 2) Nieuw `Modules/ForeverSeenPlaces.lua` (alleen Camelot-toc): bij TRAINER_SHOW/MERCHANT_SHOW de spelerpositie onder het
  NPC-id in `ns.db.foreverSeenAt`; `ns.ForeverPlaceFix(npc, map, x, y)` gebruikt in `ForeverTrainer` (Candidates →
  FixPlaces), `ForeverWeapons` en `ForeverVendors` GoTo. Zelfde kaart only. `/mh travel` toont het aantal. Offline getest.
- 3) `FARROW_NEAR_NPC` via `nearKey/nearYards = 20` op de lastTarget (trainer, wapen, verkoper); NativeArrow kopieert ze en
  zet de zin achter het label binnen 20 yd. 7 talen.
- (correctie: het bestand staat in BEIDE toc's met IS_FOREVER-guard; anders zag de linter [2]/[9] HARD.)
- ▶ Later: geleerde plekken uit Robs SavedVariables (`foreverSeenAt`) in de spots-bestanden zetten.
- **Ronde 2 (Rob test, "Ja, repareer allebei"):** GEMETEN in zijn SV: Aramis geleerd op 31.11, 66.35 (nieuwe code draaide),
  maar de eerste pijl stond tóch 12 m ernaast. Oorzaak GEMETEN: `HandyNotes_ClassTrainers` heeft Aramis op 30.97, 66.77, en
  in `OnePerTrainer` (8 nov, Duesten) wint HandyNotes (3) van een MH-rij zonder `measured` (4). → Aramis `measured = true`,
  en `seen` = rang 0. Tweede fout: `/mh travel` bleef in Forever stil — Core.lua's retail-tak (`ns.Travel.PrintStatus`)
  ving het commando en deed `return` zonder iets; nu alleen als `ns.Travel.PrintStatus` bestaat. Offline getest
  (Aramis rang 2 zonder SV, 0 mét; controle Duesten 2). Niet in het spel gezien.

## ▶ VOLGORDE 11 nov (sparring-chat, Rob: "ja, doe het zo"; reden: Robs testtijd is het schaarste)

Eén stap af en door Rob getest, dan de volgende.
a. Judgement en de class-quests afmaken (`docs/forever/FOREVER_QUEST_LOCKED_SPELLS_2026-11-11.md`; Seal-tip, Claw-fix
   `ForeverTrainerData.lua:86`, "komt van een quest" bij de quest-spells).
b. Groene pijltjes + tooltip-regel (BagUpgrade/LootUpgrade) ook in Forever — eerst meten: kan het op de rekenaar van
   `ForeverQuestHint` (`ns.FOREVER_MAIN_STATS`), of is `ns.GetLootUpgradeInfo` daar bruikbaar; werkt de bag-hook in Forever.
   Groot werk → melden en achter c zetten.
c. Opdracht 7: `/mh selftest` + vensterlijst (hieronder).
d. De melding bij het oppakken van een upgrade.
e. Zygor-wachter (Rob: ja), zoals `handynotes_watch`, alle zones, via de voordeur, als stap in `docs/OCHTENDRONDE.md`.

## ▶ OPEN OPDRACHT: `/mh selftest` + vensterlijst (opdracht 7, sparring-chat; Rob: "niks later", dus al op 11 nov)

Volledige tekst: **`docs/OPDRACHT_SELFTEST_2026-11-11.md`**. Begin met fase 0 (meten en voorstellen, niets bouwen): de
nummerbron van `data_check.py` C2, welke client-functies betrouwbaar "bestaat" zeggen in Midnight en Forever, en of
`SCALABLE_WINDOWS` een bruikbare vensterlijst is. Vraag Rob eerst zelf of het mag (zijn ja kwam via de sparring-chat).
De Judgement-uitzoekklus (mh-research, 11 nov) gaat voor.

## 🆕 11 nov — goedemorgen-ronde uit CLAUDE.md naar `docs/OCHTENDRONDE.md` (opdracht B sparring-chat; Rob: "Ja, doe het")

- Het blok "Als Rob goedemorgen zegt" (128 regels, incl. de wachter-tabel) ongewijzigd naar `docs/CLAUDE_HISTORIE.md`
  (bovenaan; script-controle: tekst volledig aanwezig). Nieuw `docs/OCHTENDRONDE.md`: 19 stappen + harde regels, elk met één
  zin waarom; ook leesbaar voor een cloud-chat vanaf Robs telefoon. Reparaties: `run addon_updates` via `probe_job.txt`;
  `git pull --rebase` zonder `origin main` (gaf vanochtend "Cannot rebase onto multiple branches", GEMETEN).
- In CLAUDE.md een blok van 6 regels; de wachter-tabel staat alleen nog in `docs/REGIE.md` tabel 1. De SITE_SEIN-regel
  (elke nieuwe functie/tag/upload) stond alleen in het oude blok: teruggezet als één regel. **CLAUDE.md: 431 → 311 regels**
  (lint [24] nu onder 350).
- ✅ Recept `/nieuwe-chat` (`~/.claude/skills/nieuwe-chat/SKILL.md`) wijst nu naar `docs/OCHTENDRONDE.md` (Rob: "Ja, pas
  aan"). `/verder` zegt alleen "doe het ochtendritueel", zonder bestand: hoeft niet. REGIE.md tabel 2 mist OCHTENDRONDE.md en CLAUDE_HISTORIE.md
  (schrijver bouwchat): doorgegeven aan de sparring-chat/regisseur.

## 🆕 11 nov — CLAUDE.md korter: het shell-deel (opdracht A sparring-chat; Rob: "Ja, doe het")

- GEMETEN: `tools/bash_guard.py` draait als PreToolUse-hook (`AddOns/.claude/settings.json`, matcher Bash|PowerShell) en
  blokkeert `&&`, `||`, `;`, pijp, heredoc, `python -c`, `python -` en de PowerShell-tool. NIET: redirects (`2>&1`, `>`),
  argumenten achter `_probe.py`/`git_stage.py`, git met paden, directe scriptpaden, extra vlaggen.
- Het shell-deel (137 regels, "26 sep `_probe.py`" t/m de 15-aug-meting) ongewijzigd naar nieuw `docs/CLAUDE_HISTORIE.md`
  (script-controle: oude tekst daar volledig aanwezig, weg uit CLAUDE.md). Ervoor in de plaats een blok van 25 regels met de
  12 niet-afgedwongen regels + één regel over wat de guard afdwingt. **CLAUDE.md: 543 → 431 regels.**
- Lint [24]: SOFT als CLAUDE.md > 350 regels (Rob: "350 is goed"); nu 81 erboven. Volgende happen (goedemorgen-ronde naar
  een recept, overige geschiedenis) komen als aparte opdrachten van de sparring-chat.

## 🆕 11 nov — Forever: reisplanner in het spel + "geen Hearthstone" (Rob: "bouw het maar")

- Rob testte de reisplanner met een Horde-Paladin in Tirisfal → Hanashi/Sayoc (Orgrimmar): pijl en venster zeggen "the
  zeppelin to Durotar"; MH-doel 60.70,58.76 vs zeppelin-pin op zijn kaart 60.04,59.46 (GEMETEN, < 1 kaartpunt). Niet
  doorgereisd: geen Hearthstone. Rest (Durotar → Orgrimmar, Alliance, "(loading...)") later, met een character mét Hearthstone.
- Nieuw in `ForeverTravel.lua`: gaat het plan over het water (boot/zeppelin/loop/sky; tram en portaal niet) en is
  `GetItemCount(6948)` = 0 → `FTRAVEL_NO_HEARTH` achter de "way there"-zin, één chatregel `FTRAVEL_NO_HEARTH_CHAT` per
  doel per sessie (in `ns.BuildTravelPlan`, dus alleen als de pijl een plan vraagt), `/mh travel` toont het aantal en het
  oordeel. Onleesbare telling = niets zeggen. Item 6948 + namen per taal GEMETEN in de Forever-DB2. Syntax OK.
- Niet gedaan: de tip "een herbergier geeft je een nieuwe" — niet gemeten, dus niet in de tekst.

## 🆕 11 nov — Forever: Enhancement Shaman altijd Strength (Rob: "Ja, repareer")

- Vondst van de content-wachter (Forever-inhaalronde, `docs/CONTENT_WATCH.md` 11 nov): Blizzard, blue post 6 nov +
  hotfix 10 nov (Mental Dexterity terug naar 33/66/100% van Int) wil Strength als beste stat. MH's `later`-omslag naar
  Intellect bij Mental Dexterity deed het omgekeerde. `ForeverMainStats.lua`: de `later` voor SHAMAN weg, main blijft
  Strength, Intellect. Bron gelezen via zoekmachine op meerdere sites, niet in de client. Syntax OK. TESTLIJST 11 nov.
- Niet nagekeken: of de Paladin-omslag (Champion of the Light) en de Hunter-omslag (Careful Aim) nog kloppen.
- Bijwerken bij gelegenheid: `docs/forever/FOREVER_MAIN_STATS_2026-11-07.md` noemt de oude omslag nog.

## 🆕 11 nov — de regisseur (Rob: "Ja, bouw hem"; opdracht `docs/OPDRACHT_REGISSEUR_2026-11-11.md`)

- Van de brainstorm-tak naar main: `docs/REGIE.md`, de opdracht, plan deel 8. Dit bestand eerst gesplitst (1547 → 1292;
  284 regels naar het archief, kop "☀️ 5 nov — ochtendronde"). `tools/split_handoff.py` weigerde eerst: het archief
  had CRLF-regeleindes, het script zocht exact `---\n`; nu tolerant.
- Recept `C:\Users\RobHu\.claude\skills\regisseur\SKILL.md`. Routine **MH regie** `trig_017LQWJNvptK8hWLuByuEDzg`,
  06:20 Parijs, Sonnet 5.5, omgeving "Midnight Helper", bronnen MidnightHelper + midnighthelper-site (lezen), geen
  connectoren, schrijft alleen `docs/REGIE.md`. Content-wachter duurt 3–10 min (GEMETEN, list_runs), dus 06:20 is ná alle vier.
- ✅ Telefoonmelding (Rob: "Ja, ik wil wel een telefoonmelding … pas om 8 uur 's morgens"): de PushNotification-tool
  heeft geen stille stand (GEMETEN in zijn schema), dus de routine draait nu om **08:15** en meldt alleen bij iets onder
  "Raakt Rob" of een nieuw punt onder "Scheef". `PushNotification` toegevoegd aan allowed_tools (zoals "In the game now",
  geheugen site-now-news-auto). Of de melding echt aankomt: eerste run 12 nov 08:15, nog niet gezien.
  ⚠️ Zondag draait de ideeënbus om 08:00; de regisseur om 08:15 kan die run dan net missen.
- Robs ja voor de 9 wachtende site-commits ("Ja, push dat maar") letterlijk doorgegeven aan «Site chat 11-11»; die pusht zelf.
- ✅ Regisseur starten vanuit Home Assistant (Rob: "draai hem nu maar, want ik ben wakker" → "Ja, bouw het"). GEMETEN 11 nov
  09:55: HA → 200 `routine_fire`, sessie cse_01AezjghcPmsyBweoY6UXhYj.
  - Routine heeft een API-trigger; sleutel (alleen voor deze routine) door Rob gemaakt en in HA `secrets.yaml` als
    `regie_bearer: "Bearer …"`. Eerste test 401 (sleutel fout), na Robs correctie + `rest_command.reload` 200.
  - HA: `packages/regie.yaml` (door Rob geplakt: de HA-koppeling mag geen `rest_command` schrijven) →
    `rest_command.regie_nu`; `script.regisseur_nu_draaien` (bij een fout een stille melding, Android `importance: low`);
    `automation.mh_regisseur_draaien_zodra_rob_wakker_is` (rob_slapen → uit, of 06:20; alleen 06:20–08:15; dus hooguit
    één keer per ochtend); dashboard MH HQ, blok "Snel naar": knoppen "Regisseur nu" (met bevestiging) en "Regie-verslag".
  - De vaste ronde om 08:15 blijft als vangnet; een tweede ronde zonder nieuws stuurt geen melding.

## 🆕 11 nov — C4: spelnamen per taal (Rob: "Ja, alle drie")

- 65 → 3 nakijken (GEMETEN, `run data_check --c4 --all`). mh-writer herschreef 41 waarden in de/fr/es/pt/it/ru, elke naam
  uit de DB2 van die taal (live 12.1.5.70783). Lint 0 HARD, syntax OK. Niet in een client gezien → TESTLIJST 11 nov.
- `tools/data_check.py` kreeg `C4_IGNORE` (per sleutel, met reden, wordt elke run geprint): CRAFTSHOP_MAKING,
  LAYOUT_CARD_BUILDER, SETTINGS_SECTION_GENERAL, SET_BTN_TEST, TOUR_CODEX_NAV, DAWNCREST_TIER_CHAMPION (deDE client =
  "Morgenlichtwappen des Champions", CurrencyTypes 3343 GEMETEN), SMC_SEARCH_PORTALS (zoekwoorden bevatten nu de
  clientnaam), GUIDE_CONS_TYPE_HEALING (Midnight-drankjes ItemSparse 241304: Heiltrank/soins/sanación/Vida/лечебное).
- Bewust open (3): deDE DELVE_NAME_LABYRINTH / DELVE_NAME_RING_OF_GLORY, esES DELVE_NAME_RING_OF_GLORY. De clientnaam heeft
  een lidwoord, maar dezelfde sleutel gaat ook in DELVE_SHARE_CONFIRM_FMT (via ns:GetDelveChatDisplayName,
  DelvePartyShare.lua:403) → "für Das Labyrinth". Oplossing = aparte label-sleutel. ▶ Rob kiest.
- ▶ Rob kiest ook: dezelfde OUDE naam staat nog in andere sleutels van hetzelfde pack (niet aangeraakt). Grootste groepen:
  itIT "Omnium Folio" ~14×, ruRU "Field Accolades" ~17× en "Malevolent Boons" 7×, frFR/esES/ptBR Trading Post-ondertitels
  (3× elk), "L00T RAID-R" in CODEX_CUR_UNDERCOIN_BODY (6 talen), "Gesundheitstrank"/"Poción de salud"/"Зелье здоровья"
  in CONSREADY_HPOT. Volledige lijst: `docs/C4_OUDE_NAMEN_2026-11-11.md`.

## 🆕 11 nov — de vier ochtendwachters dekken ook Forever (Rob: "Yeah", op het voorstel van de brainstorm-chat)

- Nieuw `docs/WATCHER_FOREVER.md`: per wachter een Forever-deel (content toetst Forever-hotfixes aan Modules/Forever* en de
  F*-sleutels; data: "anything Classic" telt niet meer voor Forever; PTR: wat er voor Forever komt, wowf-builds; API: de
  Camelot-toc). Plus een eenmalige inhaalronde, alleen geldig op 2026-11-11 als de gewone regel van die dag er al staat.
- Elke opdracht kreeg alleen een slotalinea die naar dat bestand wijst (byte-controle: zie hieronder). CLAUDE.md: één zin.

## 🆕 10 nov (avond) — Forever: reisplanner voor de pijl (Rob: "uitzoeken en bouwen graag")

- Aanleiding: Rob in Darkshore, pijl naar Buliwyf (Ironforge) zei alleen "travel back first". `Modules/Travel/` laadt niet
  in Forever. Nieuw `Modules/ForeverTravel.lua` (beide TOC's, IS_FOREVER-guard): ns.BuildTravelPlan (zelfde vorm als
  Midnight) met 14 links uit `docs/forever/FOREVER_TRAVEL_LINKS_2026-11-10.md` (mh-research: DB2 TaxiPathNode 70888
  GEMETEN, x,y-omrekening AFGELEID, Wowhead-NPC's binnen 1 eenheid). Dijkstra over speler + link-uiteinden + doel; lopen
  = afstand/250 + 2 per zonewissel + 8 tussen Stormwind- en Ironforge-kant (dan wint de tram). Rut'theran = Teldrassil
  y ≥ 86 (AFGELEID). Weggelaten: directe boot Auberdine↔Menethil (vermoedelijk weg), Grom'gol↔Undercity, Feathermoon.
- NativeArrow: `ns.ForeverTravelNeedsLink` maakt Teldrassil/tram "unreachable" → plan; `step.forever` laat de pijl naar
  een haven in een andere zone op je eigen continent wijzen. Retail-pad onveranderd (beide hooks bestaan daar niet).
- ForeverWeapons "The way there": nu vanaf waar je staat (`ns.ForeverTravelSentence`), oude vaste teksten als terugval.
- `/mh travel` = diagnose (MH_UNLISTED_ON_PURPOSE). Teksten FTRAVEL_* enUS + nlNL; de/fr/es/pt/it/ru door mh-writer.
- Offline test (nep-wereld, scratchpad `ftravel_test.lua`): 13/13 routes goed. ⚠️ NIET in het spel getest; TESTLIJST 10 nov avond.
- Vertalingen (mh-writer, namen GEMETEN in Forever-DB2: Tiefenbahn/Tram des profondeurs/…; Rut'theran per taal; geen itIT —
  Forever heeft geen Italiaanse client). ruRU bewust zonder naamvallen ("корабль (куда: %s)").
- Bug Rob 10 nov: hengel-tip bleef op "(loading...)" — `ForeverVendors.lua` tekende de tip één keer; nu `RenderTip` ook op
  GET_ITEM_INFO_RECEIVED, en de chatregel wacht op de naam. Niet in het spel getest.
- ✅ Rob bevestigde in de bouwchat ("Ja, zo"): A) één ideeënlijst — elk verzoek, ook direct in de bouwchat, komt in
  IDEEEN.md in de vaste vorm (Ja → gebouwd met commit → Af na Robs test). Gedaan: de reisplanner staat onder Ja.
  ✅ Stap 4 (Rob: "Ja, stap 4"): `tools/data_check.py` (`run data_check [--c2|--c4] [--all] [--loose]`), lokaal/wachter,
  NIET in de GitHub-lint (heeft wago nodig; cache in %LOCALAPPDATA%). GEMETEN 10 nov:
  - C2: 1541 nummers (1070 spell, 341 quest, 71 kaart, 39 achievement, 25 item) tegen SpellName/QuestV2/UiMap/
    Achievement/Item van live 12.1.5.70783 + ptr 12.1.7.70740 + forever 1.60.1.70888 → **0 nakijken**. 4 bewuste
    nep-id's (DispelTest) op de IGNORE-lijst. Blinde vlek: 23 regels. Proef: 6603 + 947 gevonden, 99999999 niet.
    Eigen fouten onderweg: proef-kaart 1415 bestaat alleen in Forever; `--[[ ]]`-commentaar werd meegelezen.
  - C4: 121 enUS-waarden zijn precies een spelnaam (Area/Map/Achievement, spells alleen met 2+ woorden); per taal
    vergeleken met wat die client toont, fill()-overschrijving gevolgd zoals in het spel. **65 nakijken**, gemengd:
    echt (bv. "Titel: Light's Faithful" in alle 6; ruRU RITUAL_CHAL_* en CODEX_CUR_ACCOLADES nog Engels; itIT TAB_OMNIUM
    Engels; de "Das Labyrinth"/"Der Ring" en pt-lidwoorden in MOUNTRUN_R_*) en toeval (General = NPC-rang, Test,
    Builder, zoekwoorden SMC_SEARCH_PORTALS, GUIDE_CONS_TYPE_HEALING). ▶ Rob kiest of we de echte laten herschrijven.
  ✅ Stap 5 (Rob: "Eerst stap 5"): twee cloud-routines, ID's ook in CLAUDE.md:
  - **MH nachtcontrole** `trig_01EKor6SCGxyPJPurc4MML3P`, dagelijks 04:15 Parijs, omgeving "Midnight Helper"
    (env_012F4L7VcAGercf6hQDYoFai, wago toegelaten), Sonnet 5.5, géén connectoren. C1 tegen een verse lijst in /tmp
    (event_snapshot `--out`, event_check `MH_EVENT_SNAPSHOT`) + C2; schrijft alleen `docs/NACHTCONTROLE.md`.
  - **MH ideeënbus** `trig_0168w6QPWBbUob5hYf5HXFWz`, zondag 08:00, Opus 5.5, alleen Exa; schrijft alleen het blok
    "Voorstellen van de wachter" onderaan IDEEEN.md (één-schrijver-regel); drie harde regels in de opdracht.
  - Proefrun nachtcontrole 10 nov 21:15 (cse_01AezjghAscP8AAd8atJJFGh), GEMETEN: **wago.tools werkt** in die omgeving
    (200), C2 schoon (zelfde 1541 als lokaal). **api.github.com geeft 403** → C1 "NIET GEDRAAID" (correct gemeld).
    ❌ Mijn eerste advies (domeinen toevoegen) was FOUT. GEMETEN in code.claude.com/docs/en/cloud-environments: beide
    domeinen staan al in "Trusted"; al het GitHub-verkeer gaat via de GitHub-poort, die API-aanvragen alleen doorlaat
    voor repo's die AAN DE SESSIE GEKOPPELD zijn ("GitHub access to … is not enabled for this session", 403).
    ✅ Opgelost (Rob: "Ja, koppel hem"): `Gethe/wow-ui-source` als tweede bron aan de routine, sparse checkout alleen
    `Interface/AddOns/Blizzard_APIDocumentationGenerated`. Tweede proefrun: cse_01AezjgmBywxYEbFVTpsUgQr.
    📌 Les: elke cloud-routine die een andere GitHub-repo leest, moet die repo als bron koppelen.
    ✅ GEMETEN in `docs/NACHTCONTROLE.md`: de tweede proefrun (10 nov) én de geplande run van 11 nov draaien C1 en C2
    allebei, controles OK, 0 nakijken; snapshot in de repo actueel.

### ▶ Open na 10 nov (volgorde voor de volgende bouwchat)
1. Robs test van de **Forever-reisplanner** + "(loading...)"-fix (TESTLIJST 10 nov avond); daarna IDEEEN.md-regel → Af.
2. ✅ 11 nov: **C4** 65 → 3 (zie boven). Nieuw open: de 3 delve-namen in een zin, en de oude namen in andere zinnen.
3. **Zygor-vergelijking**: Zygor werkte 10 nov 20:23 de MID-mounts en -achievements bij (geen oude kopie → diff onbekend).
   Voorstel stond open: een Zygor-wachter zoals handynotes_watch + onze schatten/mounts naast Zygor leggen. Rob koos nog niet.
4. Maandag: eerste **ideeënbus**-voorstellen (zondag 15 nov) verplaatsen naar Open/Nee.
5. Later: C5 (vensterregister) samen met `/mh selftest`; plan deel 4/6.
  - C5 later met /mh selftest. De 65 C4-namen wachten op Robs keuze.

## 💡 10 nov — brainstorm werkwijze (cloud-sessie, tak `claude/midnight-helpen-brainstorm-d18bs9`)

- PLAN (Rob: "werk het hele plan maar uit"), ✅ Rob 10 nov avond: "het klopt allemaal, volgorde is goed", zesde toetsvraag ja: `docs/PLAN_WERKWIJZE_2026-11-10.md`, 7 delen +
  bouwvolgorde (prikbord → controles → wachters → recepten → selftest → nep-spel). Alleen deel 1 is af. Eerste versie: Doel als toets (5 vragen), vaste vorm van
  een idee, één ideeënlijst, prikbord voor de site-chat. Volgorde (Rob: "Ja, die volgorde aanhouden"): 1) toets +
  ideeënvorm, 2) controles "bestaat het" / "klopt de data", 3) ideeën-wachter, 4) nep-spel + `/mh selftest`.
  Niets gebouwd. ⚠️ Dit bestand zit op 1434+ regels: splitsen vóór de volgende grote toevoeging.
- ▶ **Opdracht voor de bouwchat: `docs/OPDRACHT_BOUWCHAT_2026-11-10.md`** (Rob: ja). Stap 0 tak naar main, stap 1 prikbord
  `docs/SITE_SEIN.md`, stap 2 controles C3/C5/C1. Eén stap tegelijk, na elke stap Robs ja.
  - ✅ Stap 0 (Rob: "Ja, stap 0"): 45ea9ce, main = tak byte voor byte.
  - ✅ Stap 1 (Rob: "Ja, stap 1"): `docs/SITE_SEIN.md` gemaakt: 5.0.2 = *staat op CurseForge* (GEMETEN 10 nov, CF-API: beide
    zips Release 8 nov), 11 regels *alleen op main* voor alles sinds v5.0.2 (GEMETEN `git log v5.0.2..HEAD`; knoplabels en
    commando's opgezocht in enUS.lua en Core.lua). `RELEASE_CHECKLIST.md`: seintje = regel in SITE_SEIN. CLAUDE.md
    ochtendronde 4d: lees `midnighthelper-site\drafts\BOUW_VRAAG.md` (bestaat, GEMETEN: nog geen vragen).
  - ✅ Stap 2 (Rob: "Ja, stap 2"; brainstorm-chat las mee en vulde aan): lint [22] = C3, [23] = C1, GitHub draait ze
    (addon-lint.yml triggert nu ook op RELEASE_NOTES.md, SITE_SEIN.md en de snapshot). GEMETEN 10 nov: lint 0 HARD.
    - C3 `tools/release_text_check.py`: `/mh`-woorden in RELEASE_NOTES + SITE_SEIN tegen wat de code routeert (279
      woorden: Core + modules + CommandList), SITE_SEIN-sleutels tegen Locales = HARD; *cursief* label zonder Locales-tekst
      = SOFT; elk gevonden label wordt getoond mét sleutel en bestand. Positieve controle in elke run (nep-commando,
      -sleutel, -label). 🔴 De proef van 3 nov slaagt NIET als fout: "Skip" bestaat (TOUR_CM_SKIP, de rondleiding);
      `--selftest` toont "*Skip* -> TOUR_CM_SKIP (StartHere.lua)" — zichtbaar fout voor een lezer, niet voor de check.
    - C1 `tools/event_check.py` + `tools/event_snapshot.py` → `tools/blizzard_events_snapshot.json` (Gethe/wow-ui-source,
      GEMETEN: live 12.1.5.70783 1784 events, ptr 12.1.7.70740 1818, **forever 1.60.1.70888 1816** — Forever heeft een
      eigen tak). Retail-toc tegen live+ptr, Camelot-toc tegen forever; andere-spel-bestanden overgeslagen; pcall apart.
      Uitkomst: 100 + 45 events, 0 nakijken. Proef: LEARNED_SPELL_IN_TAB staat niet in de lijst, de scanner leest hem.
      Zegt hardop STALE bij >28 dagen of als de .toc een nieuwere Interface heeft. Verversen: `run event_snapshot --write`
      (met de hand; later de vijfde wachter).
    - C5 NIET gebouwd, alleen gemeten: [10] lijst→gerouteerd, [16] gerouteerd→lijst, [4] tab→zoekbalk, NavSearch indexeert
      MH_COMMANDS. Wat ontbreekt is een lijst van VENSTERS; een heuristiek (ns.Show*/Open*/Toggle*) gaf 51 treffers, vooral
      loos (toasts, hulpfuncties, commando's die in de module zelf routeren). ▶ Rob kiest: vensterregister bouwen of niet.
- Rob daarna: toets klopt; ideeënlijst ja; prikbord ja. Nieuw: `docs/IDEEEN.md` = de ENE ideeënlijst (20 open + 2 uit de
  vragenlijst + 6 half; 3 van de 5 vragenlijst-wensen bleken al gebouwd; wat sinds 8 okt gebouwd is staat onder "Af", vandaag GEMETEN in de code, niet in het spel).
  Nieuwe ideeën alleen nog daar. Rob moet per regel nog ja/nee/later zeggen. Site-kant staat in de privé site-repo.

## 🆕 10 nov (middag) — Midnight: Macro's-tabblad "Top" + knop Maken (Rob: "maak het maar, net zoals … Forever … minimaal net zo goed")

- Drie mh-research-runs (A: DK/DH/Druid/Evoker, B: Hunter/Mage/Monk/Paladin, C: Priest/Rogue/Shaman/Warlock/Warrior)
  telden per spec de macro's in Midnight-bronnen (Wowhead UI & Macros, Icy Veins, Method; okt 2026) → top 5 per spec,
  40 specs (DH Devourer meegeteld). Notities: `docs/MIDNIGHT_TOP_MACROS_2026-11-10_A/B/C.md`. Reddit niet bereikt.
- Nieuw `Modules/RetailTopMacros.lua` (alleen retail-TOC, na InterruptMacros): `TOP_MACROS` 183 rijen (spec 0 = elke
  spec van de klasse; `dkey` = gedeelde tekst voor tweelingen), spells als `{id}` → clientnaam; talent-rij verborgen tot
  gekend; niet gekend → "train"-melding. Nieuw soort "top" vooraan in `ns.MacroPanelTypes`; standaard geselecteerd.
  `InterruptMacros.lua`: knop **Maken** naast Alles selecteren (voor elk soort; CreateMacro per karakter, "MH+ <naam>",
  uit in gevecht en in de guide-preview). `/mh macrocheck` print ook de Top-rijen. Id's GEMETEN in wago retail
  12.1.5.70783. Offline-test: 40 specs × 5, geen rest-`{`, ≤255 bytes. Niets in de client getest → TESTLIJST.
- Gevonden macro-regels 12.0 (Blizzard, 1 mrt 2026): max 3 markeringen kort na elkaar; in een encounter geen macro-chat
  buiten de groep. Spelers (niet Blizzard): `[nochanneling]` kan casten even blokkeren → waarschuwing bij die rij.
- ✅ Daarna (Rob: "Ja zet om"): de oude Utility/Interrupt-lijsten krijgen nu de clientnamen. `ns.MH_LocalizeMacroBody`
  (RetailTopMacros.lua) ruilt elke bekende Engelse naam via `NAME_IDS` (84 namen → speler-spell-id, GEMETEN retail
  12.1.5.70783, deDE e.a. gelijk voor alle speler-ids per naam) op de plek van de naam (na de laatste `]`, castsequence-
  lijst, `channeling:`). Aangeroepen in `MH_GetMacroContextForType` (niet voor "top") en in `/mh macrocheck`. Offline:
  145/145 lichamen vertaald met nep-Duitse namen, 0 Engels over, Engels = ongewijzigd. Niet getest op een echte
  niet-Engelse client. Open: "/target Dundun" (World-soort) is een NPC-naam, nog Engels.

## 🆕 10 nov (middag) — Forever: top 3 macro's per spec (Rob: "Ja, laten we maar uitzoeken" → "Ja bouw maar")

- Onderzoek (mh-research): `docs/forever/FOREVER_MACROS_SPECS_2026-11-10.md` — 27 specs × top 3, 13 bronfamilies,
  plus spec-herkenning. Gebouwd in `Modules/ForeverMacros.lua`: `SPEC_MACROS` (81 rijen, geen dubbel met de klasse-5;
  vervangingen staan in de scratchpad-notes van 10 nov), `SPEC_NAMES` (boomnamen per client uit DB2 TalentTab; deDE
  "Verstärk"/"Wiederherst" voluit geschreven, AFGELEID), `SpecBand()`: C_ClassTalents.GetActiveConfigID → C_Traits,
  punten per PosX-band (<4000 / <8000 / rest), hoogste = spec, 0 of gelijk = geen. AFGELEID (Wow.exe heeft C_Traits en
  niet GetTalentTabInfo — GEMETEN; in het spel niet gedraaid). Tonen: talent-rij zodra het talent gekend is, gewone rij
  alleen bij jouw spec; jouw spec eerst. `/mh macros check` print de spec + punten. Events SPELLS_CHANGED +
  TRAIT_CONFIG_UPDATED (pcall). 76 teksten van classicwowforever.com (CC BY 4.0) → creditregel `FMAC_SPEC_CREDIT` in het
  venster; rankedboost (All Rights Reserved) alleen als keuze, nooit als tekst. Talent-`level` = max(spell-level, 10 +
  rijpunten): +10 AFGELEID. Offline-test met stubs: spec-band goed, geen rest-`{`. Niets in de client getest → TESTLIJST
  (eerst de /run-regel).

## 🆕 10 nov — Forever: top 5 klasse-macro's in "Handige macro's" (Rob: "Top 5" → "Ja. Mooi.")

- Rob wilde "de meest gebruikte macro's per klasse" (specs later). mh-research telde het onderzoek van 9 nov na in 12
  Forever-bronfamilies + forumposts van spelers (Reddit gaf 403): `docs/forever/FOREVER_MACROS_POPULAR_2026-11-10.md`.
  Score = bronnen + shortlists + spelers (formule AFGELEID, tellingen GEMETEN). Mount-macro: maar 2/12, niemand vroeg erom.
- Gebouwd in `Modules/ForeverMacros.lua`: `CLASS_MACROS` (45 rijen, 5 per klasse), blok "Voor jouw klasse" onder de
  algemene rijen. Spells alleen als `{id}` / `{id:rank}` → `FillTpl` zet de clientnaam erin (alle talen). `need` niet
  gekend → grijs (level of "leer eerst"); `talent` (Holy Shock 1311606, Penance 402174) verborgen tot gekend; `tplShort`
  voor Taunt/Healing Touch (ruRU 258 bytes). Waarschuwingen `twopress` (warrior stance) en `formbar` (druid D2), beide
  uit forumposts. Id's GEMETEN in wago Forever 1.60.1.70862 (mh-research, bewijs in de scratchpad-notes van 10 nov).
  Bewust anders dan de bron: warlock demon-knop zonder `[pet:…]` (familienaam is vertaald), priest dispel ingekort.
  Offline-test (lua-stubs): 45/45 vullen zonder rest-`{`. Teksten enUS/nlNL zelf, de/fr/es/pt/ru mh-writer met
  spellnamen per taal uit de Forever-DB2. Niets in de client getest → TESTLIJST.
- Punt 2 van de lijst hieronder is hiermee gedaan (behalve de mount-macro: bewust niet, te weinig vraag).

## 🆕 10 nov — `tools/gamedata.py` (Rob: "Ja, bouw het") + onderzoek wapentrainers Forever

- Nieuw werktuig, via de voordeur: `run gamedata db2 <Tabel> [filters] --game forever`, `run gamedata npc <id> --game
  forever`, `run gamedata builds`, `run gamedata help`. wago.tools DB2-CSV + Wowhead-tooltip-JSON, ~0,2 s, cache in
  `%LOCALAPPDATA%\MidnightHelper\gamedata_cache`. GETEST 10 nov: npc 11865/11866 (zone + coördinaten), een onbekend id
  (404 netjes gemeld), `SkillRaceClassInfo SkillID=54,160` (13 rijen). CLAUDE.md-sectie + mh-research-agent bijgewerkt.
- Rob vroeg (Forever, Night Elf Druid lvl 10): waar leer ik maces? Antwoord: niet in Darnassus (Ilyenia Moonfire:
  staves/bows/daggers/thrown/fist), wel Buliwyf Stonehand, Ironforge ~61,89, 10 zilver. GEMETEN in de Forever-DB2:
  SkillRaceClassInfo rij 643 (Maces, druid, Night Elf) Availability 0 = niet vanaf het begin; rij 644 (Tauren) = 1.
- Rob: *"dit is trouwens ook weer zoiets voor onze guide … werk dat … uit"*. Onderzoek klaar (mh-research):
  `docs/forever/FOREVER_WEAPON_MASTERS_2026-11-10.md` — 8 wapentrainers, 14 wapen-skills met spell-id's, kosten/levels,
  klasse×wapen, Forever-wijzigingen, routes. 7 open gaten staan onderaan dat bestand (o.a. Sayoc + Staves).
  ✅ Gebouwd (plan → Rob: "Ja, bouw maar"): `Modules/ForeverWeapons.lua` (beide TOC's, na ForeverVendors). `/mh weapons
  [check]` (Core.lua). Venster "Wapentrainers": links de 14 wapens gefilterd op je klasse (bitmasks uit Forever
  SkillRaceClassInfo), "(ken je)" via IsPlayerSpell(spell-id) — AFGELEID, eerste test; rechts de 8 weapon masters aan
  jouw kant + afstand + Pijl (lastTarget via "/mh weapons", weg bij TRAINER_SHOW van díe npc, kruis via
  ForeverTrainerMark) + route-zin per stad (FWEAP_ROUTE_<stad>_FAR/_NEAR, uit de Zygor-transitdata in het onderzoek).
  Sayoc zonder Staves (betwist). Meten: TRAINER_SHOW bij een van de 8 → `MidnightHelperDB.foreverWeaponSeen[npc]`
  (rijen + filterstand). Ingangen: Ik-kamer `me_fweapons`, Tools → Losse vensters, startpagina-regel
  `FWEAP_HOME_FMT` (alleen als er iets te leren is). Plaatsen GEMETEN 10 nov met `run gamedata npc`; Sayoc en Hanashi
  staan echt samen (81,4-81,6 / 19,4-19,6). Teksten enUS/nlNL zelf, de/fr/es/pt/ru mh-writer met plaatsnamen uit
  AreaTable per taal. Lint/syntax OK; niet in de client getest → TESTLIJST.

## 🆕 10 nov — Forever: tegels voor "Handige macro's" en "Waar koop ik dit?" (Rob: "Ja, bouw maar")

- Punt 1 van de lijst hieronder is gebouwd. Twee tegels in de **Ik-kamer** (`RoomLauncher.lua` ME_FOREVER_CARDS,
  `me_fmacros` + `me_fvendors`, alleen als `ns.ShowForeverMacros`/`ns.ShowForeverVendors` geladen zijn) en twee
  kaarten in **Tools → Losse vensters** (`ToolsLaunchpad.lua`, `foreverOnly`). Retail verandert niet. Nieuwe keys
  `TOOLLP_FMAC_DESC` / `TOOLLP_FVEND_DESC`: enUS + nlNL zelf, de/fr/es/pt/ru door mh-writer (niet native nagekeken).
  Iconen `INV_Misc_Note_01` / `INV_Misc_Coin_01` (AFGELEID dat Forever ze heeft: vanilla-iconen). Niet in de client getest.
- Ochtendronde 10 nov: niets voor Rob. Wachters alle vier gedraaid, 0 [MOET GEFIKST]; CF/GitHub 0 open; geen site-mail;
  HandyNotes 170 ongewijzigd. Site-chat heet «Site chat 10-11», wacht op een sein bij de volgende release.


## 📌 Ouder, maar nog niet af — staat in `docs/NEXT_SESSION_ARCHIVE.md`

De historie is afgesplitst (2 sep en 6 nov). Deze secties lezen daar nog als OPEN, dus ze
staan hier bij naam — een openstaand punt mag niet verdwijnen door oud te zijn.

⚠️ Bewust te ruim: de lijst kijkt alleen naar de kop. Is een punt af, zet een stukje van de
kop met de reden in `KNOWN_DONE` in `tools/split_handoff.py` en draai
`python "<repo>/tools/_probe.py" run split_handoff --reindex --write`. Niet met de hand
bewerken: dan loopt de lijst binnen een week uit de pas met het archief.

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
