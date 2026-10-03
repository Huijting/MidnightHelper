# AggroCaller / "Vanguard" — analyse

Doel: ideeën oogsten voor Midnight Helper. Gemeten op 2026-10-03, map
`E:\World of Warcraft\_retail_\Interface\AddOns\AggroCaller\`.
Strikt read-only gelezen; niets gewijzigd.

**Markering**: elke bewering is **GEMETEN** (gelezen in hun code, met file:line) of
**AFGELEID** (mijn gevolgtrekking). Huisregel: een andere addon is een bron van
KANDIDATEN, nooit bewijs van hoe een game-API zich gedraagt. Waar hun code een
spelfeit impliceert, staat er expliciet dat het **niet tegen de client geverifieerd** is.

---

## 0. LICENTIE — correctie op de opdracht

**GEMETEN** (`LICENSE.txt:1-21`): het bestand is een **MIT License**, niet
All Rights Reserved. Exacte kop: `MIT License` (regel 1),
`Copyright (c) 2026 TripleX` (regel 3). Daarna de standaard MIT-tekst:
toestemming "to use, copy, modify, merge, publish, distribute, sublicense,
and/or sell" (regel 8), met als enige voorwaarde dat de copyright- en
permissie-mededeling meegaat in alle kopieën (regel 12-13), plus de
gebruikelijke AS-IS-garantiedisclaimer (regel 15-21).

### Tweede, tegenstrijdige licentiebewering?
Ik heb de hele map doorzocht op licentietermen (`licen[cs]`, `copyright`,
`all rights reserved`, `MIT`, `GPL`, `droits réservés`).

- **GEMETEN**: er is **GEEN** tegenstrijdige claim. `LICENSE.txt` is de enige
  plek in de hele map waar een licentie voor de addon-code staat.
- **GEMETEN** (`AggroCaller.toc:1-11`): er is **geen** `## X-License`-veld.
  De .toc noemt alleen Interface/Title/Notes/Author/Version/SavedVariables/
  OptionalDeps/Category/IconTexture/AddonCompartmentFunc.
- **GEMETEN**: geen enkel `.lua`-bestand heeft een licentiekop. De
  bestandskoppen zijn technische commentaren (bijv. `Markers.lua:11`,
  `SpecInfo.lua:2`), nooit juridisch.
- **GEMETEN** (`README.md:1-19`): noemt geen licentie.
- **GEMETEN** (`CHANGELOG.md`, 121 KB): noemt alleen een derde-partij-licentie,
  namelijk `CHANGELOG.md:496` — "Replaced mixed typography with bundled Lato
  Regular and Bold … SIL Open Font License included."

### Media / Sounds — herkomst
- **GEMETEN**: `Media\Fonts\` bevat `Lato-Regular.ttf`, `Lato-Bold.ttf` en
  `OFL.txt` (4500 bytes). De fonts zijn dus onder de SIL Open Font License
  meegeleverd, mét licentiebestand. Consistent met `CHANGELOG.md:496`.
- **GEMETEN**: `Media\Icons\` bevat 56 `.tga`-iconen plus
  `LICENSE-lucide.txt` (895 bytes). De bestandsnamen zijn letterlijk
  Lucide-iconennamen (`chevron-right`, `shield-half`, `heart-pulse`,
  `wand-sparkles`, …). Lucide-iconen worden dus onder hun eigen licentie
  meegeleverd, mét licentiebestand.
- **GEMETEN**: `Media\` bevat verder `CornerMask.tga`, `Halo.tga`,
  `Shadow.tga`, `MinimapIcon.tga` — geen herkomstvermelding gevonden.
- **GEMETEN**: `Sounds\` bevat 4 mp3's: `aggro_pulse.mp3`,
  `aggro_recovered.mp3`, `healer_danger.mp3`, `mob_lost.mp3`. **Geen**
  herkomst-, auteurs- of licentievermelding gevonden in de map of in
  CHANGELOG/README. **AFGELEID**: herkomst van de 4 geluiden is
  ongedocumenteerd — dat is het enige echte licentiegat.

### Conclusie en werkwijze
**AFGELEID**: de licentiesituatie is intern consistent (MIT voor de code, OFL
voor de fonts, Lucide-licentie voor de iconen, onbekend voor de 4 mp3's). Het
precedent uit dit project (Friend Finder: "MIT" op CurseForge terwijl de code
All Rights Reserved was) doet zich hier **niet** voor; hier is het omgekeerd
mild: de opdracht vermoedde strenger dan de map zegt.

**Ik heb me alsnog aan de voorzichtige lijn gehouden**, zoals gevraagd: dit
rapport beschrijft **gedrag, API-gebruik en architectuur**. Er staat **geen
overgenomen code** in, geen codeblok langer dan een losse API-naam of
attribuutnaam die nodig is om een techniek te benoemen, en **nergens een
"port dit bestand"-advies**. **Wij nemen IDEEËN over, geen code.** Rob beslist
later wat de licentie betekent; ik meld alleen de feiten.

---

## 1. Metadata en laadorde (.toc)

**GEMETEN** (`AggroCaller.toc`):
- `## Interface: 120100` — één TOC-waarde, alleen 12.1. Geen tweede TOC-bestand
  in de map (geen `_Mainline`/`_Vanilla`-varianten).
- `## Title: Vanguard |cff888888(ex-AggroCaller)|r` — de addon is herdoopt naar
  **Vanguard**; de mapnaam en de SavedVariables bleven `AggroCaller`.
- `## Version: 4.3.1`, `## Author: TripleX`.
- `## SavedVariables: AggroCallerDB` — één account-brede tabel, **geen**
  `SavedVariablesPerCharacter`.
- `## OptionalDeps: LibSharedMedia-3.0, SharedMedia, SharedMedia_Causese,
  SharedMedia_Yukero, BigWigs, WeakAuras` — geen harde afhankelijkheden, geen
  ingebouwde libs (`#@no-lib-strip@`-achtige embedded Ace-stack ontbreekt).
- `## Category: Chat & Communication`, `## IconTexture:` eigen TGA,
  `## AddonCompartmentFunc: AggroCaller_OnAddonCompartmentClick`.
- **Laadorde**: 46 bestanden. Eerst `Locales.lua`, dan `SpecInfo.lua`, dan de
  kern (`AggroCaller.lua`), dan UI-laag, dan features, dan data
  (`GearData.lua`, `SpecGuideData.lua`), dan `OptionsV3.lua`, dan `MenuKit.lua`,
  en als laatste de 28 `Coach\`-bestanden.

**GEMETEN** (`MenuKit.lua:1-12`): de laadorde is een expliciet contract —
`MenuKit.lua` wordt ná `OptionsV3.lua` geladen (dat `AC.UI` exporteert) en vóór
de Coach-bestanden, die zich bij het laden registreren.

**AFGELEID**: dit is een "registry"-architectuur: `AC.menuRegistry` met
`pages`, `tabs` en `today` (`MenuKit.lua:11-12`), waar elke featurefile zijn
eigen pagina/tab bij het laden inschrijft. De menu-UI leest het register pas
bij het bouwen. Dat is schoon en is een goed idee voor MH's eigen schermen.

**GEMETEN** (`Bindings.xml`): 6 bindings.
1. `AGGROCALLER_CALLOUT` (header `AGGROCALLER`) → roept
   `AggroCaller_OnCalloutBinding()`.
2-7. Zes **`CLICK <framenaam>:LeftButton`**-bindings zonder body, voor
   `AggroCallerMouseMarker8/7/4` en `AggroCallerQuickMarker8/7/4`.

**AFGELEID**: die lege `CLICK`-regels zijn er alleen om de drie skull/cross/
triangle-knoppen in het WoW-keybind-paneel zichtbaar te maken. Belangrijk idee:
een secure knop krijgt pas een nette regel in Blizzards keybind-UI als je hem
in `Bindings.xml` declareert — de addon zet zelf geen toets.

---

## 2. Wat de addon voor de speler doet, per onderdeel

### AggroCaller.lua (47 KB) — de aggro-detector en het alarm
**GEMETEN**: dit is de kern. Voor een **niet-tank** in een 5-man dungeon
detecteert hij of vijanden op jóu slaan en toont dan een schermalarm + geluid.

- `AggroCaller.lua:4-5`: `AC.VERSION = "4.3.1"`, chatprefix "Vanguard".
- `AggroCaller.lua:30-131`: één grote `AC.defaults`-tabel met ~100 instellingen
  (afmetingen, kleuren, posities, scales, cooldowns, thema's,
  toegankelijkheid). `schemaVersion = 29`.
- `AggroCaller.lua:872-891` (`ShouldDetectAggro`): detectie draait **alleen**
  als: addon aan, speler in combat, in een groep, binnen een instance van type
  `"party"`, en de speler **geen** TANK is. Vier harde poorten.
- `AggroCaller.lua:893-935` (`CheckAggro`): bij de overgang "geen aggro → aggro"
  wordt het alarm afgevuurd; `AC.db.cooldown` (standaard 6 s) onderdrukt alleen
  geluid/bericht, nooit het visuele alarm.
- `AggroCaller.lua:743-752` (`FireAlert`): expliciet commentaar dat er **geen**
  automatische chat is, omdat het alarm in combat valt waar addons niet mogen
  chatten. Dit is een bewuste 4.1.4-verwijdering.
- `AggroCaller.lua:1010-1012`: slashcommando's `/aggrocaller`, `/aggrocall` en
  (nieuw) `/vanguard`; `AggroCaller.lua:1014-1092`: ~28 subcommando's
  (`guide`, `marks`, `editor`, `setup`, `diagnostic`, `recognition`, `meter`,
  `tp`, `news`, …).

**Threat-lezing (dit is de kern-API)**:
- **GEMETEN** `AggroCaller.lua:759`: `pcall(UnitThreatSituation, "player", unit)`.
- **GEMETEN** `AggroCaller.lua:760-769`: de uitkomst wordt geclassificeerd in
  een **reden**: `"error"` (pcall faalde), `"secret"` (waarde is geheim),
  `"missing"` (geen number). Alleen bij geen van die drie is de status geldig.
  Bij falen wordt `lastThreatUnavailableAt` + `lastThreatFailure` gezet en een
  teller `combatEvidence.unavailable` verhoogd; bij succes
  `combatEvidence.readable`.
- **GEMETEN** `AggroCaller.lua:772-775`: aggro = status `2` of `3`.
- **AFGELEID**: dit is precies het MH-patroon "nil = onleesbaar ≠ afwezig",
  maar zij gaan een stap verder: ze **tellen** leesbare vs. onleesbare
  metingen per gevecht en zeggen in de UI letterlijk "GEEN LEESBARE MENACE" /
  "GEDEELTELIJKE DATA" / "LEESBARE STEEKPROEVEN — volledige pull niet
  gegarandeerd" (`Experience.lua:76`). **Dat is het sterkste idee in de hele
  addon**: positieve controle in dezelfde run, aan de gebruiker zichtbaar
  gemaakt.
- ⚠️ **NIET GEVERIFIEERD tegen de client**: dat `UnitThreatSituation` in 12.1
  een secret kan teruggeven is hún aanname/afdekking, geen bewijs. MH moet dit
  zelf meten.

**Unit-sweep en performance**:
- **GEMETEN** `AggroCaller.lua:780-782`: vooraf gebouwde unit-tokenlijsten
  `nameplate1..40` en `boss1..5` (geen stringconcat per frame).
- **GEMETEN** `AggroCaller.lua:810-840` (`GatherAggroInfo`): scant de
  bijgehouden nameplates (of alle 40 als fallback), plus `target`, `focus` en
  `boss1..5`. Tabellen worden **hergebruikt**, niet opnieuw gealloceerd
  (`AggroCaller.lua:811-813` leegt ze in plaats van ze te vervangen).
- **GEMETEN** `AggroCaller.lua:793-800`: dedupe op GUID, omdat dezelfde mob
  onder meerdere unit-tokens kan verschijnen (nameplate + target + boss).
- **GEMETEN** `AggroCaller.lua:844-859` (`AnyAggroUnit`): een snelle variant
  die bij de eerste treffer stopt, gebruikt zolang de speler aggro **houdt** en
  er geen alarm staat dat namen nodig heeft.
- **GEMETEN** `AggroCaller.lua:863-870` (`GetAggroInfo(maxAge)`): één scan per
  tick, gedeeld tussen detector en alarmframe via een leeftijdscheck.
- **GEMETEN** `AggroCaller.lua:1165-1192`: de OnUpdate-loop throttelt op
  **0.20 s**, of **0.10 s** als er een "dirty"-vlag staat. De loop stapt er
  direct uit als de speler niet in combat is.
- **GEMETEN** `AggroCaller.lua:1149-1160`: `UNIT_THREAT_LIST_UPDATE`,
  `UNIT_THREAT_SITUATION_UPDATE`, `NAME_PLATE_UNIT_ADDED/REMOVED` doen
  **geen** scan; ze zetten alleen `threatDirty = true` en returnen. Het
  commentaar zegt dat die events in M+-packs tientallen keren per seconde
  kunnen vuren.
- **GEMETEN** `AggroCaller.lua:426-461`: het alarmframe had een OnUpdate die
  elk frame scande (~45 pcalls × 60 fps); nu geklemd op 10 Hz.
- **GEMETEN** `AggroCaller.lua:444-448, 1187-1191`: ze meten hun eigen kosten
  met `debugprofilestop()` en boeken dat in buckets ("alert", "detector").

**AFGELEID**: dit event-dirty-flag + vaste throttle-patroon is direct
bruikbaar voor MH overal waar we op hoogfrequente events zitten. Het
"meet je eigen ms met debugprofilestop en toon het in een diagnose" is ook
een goed idee.

### TankMode.lua (44 KB) — de tank-assistent
**GEMETEN**: spiegelbeeld van de aggro-detector, voor wie wél tank is.

- `TankMode.lua:57-73` (`ShouldShowTankMode`): alleen als rol = TANK, in
  combat, binnen een instance, en instancetype **niet** raid/pvp/arena.
- `TankMode.lua:21-24`: drie toestanden per vijand: `secure` / `warning` /
  `lost`. `TankMode.lua:129-141`: threat-status 3 → secure, 2 → warning,
  anders lost; **status `nil` → geen toestand** (dus niets tonen).
- `TankMode.lua:100-127` (`GetDetailedThreat`): naast
  `UnitThreatSituation` ook **`UnitDetailedThreatSituation`** via pcall, voor
  het percentage. **GEMETEN** `TankMode.lua:112-122`: zowel `detailedStatus`
  als `scaledPercentage` worden apart op secret + type gecontroleerd; het
  percentage wordt geklemd op 0..999.
- `TankMode.lua:30-40` (`PlayPrioritizedTankSound`): geluidsprioriteit
  healer(3) > lost(2) > recovered(1), met cooldown; een hogere prioriteit mag
  de cooldown doorbreken.
- `TankMode.lua:9-19`: telt per gevecht hoeveel mobs je kwijt was, hoeveel
  herstel, langste verlies, hoe vaak een **healer** de aggro kreeg, en hoeveel
  units **onleesbaar** waren (`tankUnknownCount`).
- `TankMode.lua:353-357`: de nameplate-indicator is een **gewoon** frame,
  parent `UIParent`, strata HIGH, level 1000, cross-anchored naar de Blizzard-
  nameplate. Commentaar zegt expliciet: UIParent-parenting vermijdt
  composite-layer-conflicten met moderne nameplate-addons.
- `TankMode.lua:610-660`: een "Tank View"-testvenster met voorbeeldrijen.

**AFGELEID**: de keuze "parent op UIParent, anker naar de nameplate" is de
reden dat zij overlays in combat mogen maken en verplaatsen — een
UIParent-kind is niet protected. Dat is het bruikbare idee voor MH-overlays.

### Callout.lua (18 KB) — de "roep de tank"-knop
**GEMETEN**: een knop/keybind waarmee de **speler zelf** één bericht naar de
groep stuurt ("ik heb aggro"), met een per-rol instelbare tekst.

- `Callout.lua:274-284`: de knop is een `SecureActionButtonTemplate` +
  `BackdropTemplate`, strata MEDIUM, `SetToplevel(false)` zodat Blizzard-
  panelen erboven blijven, `RegisterForClicks("LeftButtonUp")`.
- `Callout.lua:144-165` (`RefreshCalloutMacro`): zet `type1 = "macro"` en
  `macrotext1` op een `/p`- of `/i`-regel. Ook de generieke `type`/`macrotext`
  als fallback voor UI-replacements. `useOnKeyDown = false`.
- **GEMETEN** `Callout.lua:146-149`: in lockdown wordt de refresh **uitgesteld**
  (`pendingMacroRefresh = true`) en bij `PLAYER_REGEN_ENABLED` ingehaald
  (`Callout.lua:419-423`).
- **GEMETEN** `AggroCaller.lua:254-260` (`GetGroupChannel`): kiest
  `INSTANCE_CHAT`/`/i` als je in een instance-groep zit, anders `PARTY`/`/p`.
- `AggroCaller.lua:26-28`: `Enum.LePartyCategory.Instance` met de oude globale
  `LE_PARTY_CATEGORY_INSTANCE` en hardcoded `2` als dubbele fallback.

**AFGELEID**: dit is dé manier om in 12.x toch een groepsbericht te kunnen
sturen: niet `SendChatMessage` uit Lua, maar een secure macro-knop die de
speler zelf indrukt. Idee voor MH's "handy chat-lines"-plan (memory:
`handy-chat-lines-idea.md`) — dat plan kan hiermee wél werken.

### Markers.lua (13 KB) — raid-markers (dit is het belangrijkste idee)
**GEMETEN**: twee dingen. (a) een palet om markers op je target te zetten,
(b) een badge boven de nameplate die zegt wat een marker **betekent**.

**(a) Het zetten van markers — de techniek**:
- **GEMETEN** `Markers.lua:132-140` (`Configure`): een knop krijgt
  `RegisterForClicks("AnyUp","AnyDown")` en de attributen
  `type` = `"raidtarget"`, `unit` = `"target"`, `marker` = index,
  `action` = `"set-unmarked"` of `"clear"`, `shift-action` = `"set"`.
- **GEMETEN** `Markers.lua:90-94` (`MarkPriorityTarget`): het slashcommando
  `/aggrocaller mark <n>` zet **géén** marker; het print een boodschap en opent
  het palet. Commentaar `Markers.lua:88-89`: "Native marking must execute
  through a hardware-driven secure action. Never call SetRaidTarget from
  scans, slash commands or insecure callbacks."
- **GEMETEN**: `SetRaidTarget` wordt **nergens** in de hele addon aangeroepen.
  `PlaceRaidMarker` komt **nergens** voor. Ik heb de hele map gegrepeerd.

**Antwoord op de vraag "secure `type="macro"` /tm-knoppen of iets anders?":**
**GEMETEN — iets anders, en beter.** Zij gebruiken het **native secure
actietype `raidtarget`** op een `SecureActionButtonTemplate`, met de
attributen `marker` en `action`. Geen `/tm`-macrotekst, geen `SetRaidTarget`.
De `action`-waarden `"set"`, `"set-unmarked"` en `"clear"` doen het werk
binnen Blizzards eigen secure handler.
⚠️ **NIET GEVERIFIEERD tegen de client**: dat `type="raidtarget"` met
`action="set-unmarked"` bestaat en in 12.1 werkt, is hún code — een
**kandidaat** voor MH, geen bewijs. Dit moet MH zelf in het spel meten
voordat we erop bouwen.

- **GEMETEN** `Markers.lua:202-220` (`PrepareMarkerBindings`): drie onzichtbare
  1×1 secure knoppen `AggroCallerMouseMarker8/7/4` op `UIParent`, met
  `unit` = `"mouseover"`, `*harmbutton1` = `"markenemy"` en
  `type-markenemy` = `"raidtarget"`. Ze zetten ook
  `_G["BINDING_NAME_CLICK <naam>:LeftButton"]` voor een leesbare naam in het
  keybind-paneel.
- **AFGELEID**: het `*harmbutton1` → `type-markenemy`-trucje is de manier om de
  actie **alleen** te laten vuren op een vijandig doel; op een vriendelijke
  mouseover gebeurt niets. Elegant, en een kandidaat-techniek voor MH.
- **GEMETEN** `Markers.lua:203`: de knoppen worden alleen buiten lockdown
  gemaakt, en `Markers.lua:221-223` probeert het opnieuw op `PLAYER_LOGIN` en
  `PLAYER_REGEN_ENABLED`.
- **GEMETEN** `Markers.lua:160`: expliciet commentaar dat het palet **niet** in
  `UISpecialFrames` gaat, omdat Escape een insecure `Hide()` gebruikt en het
  palet een protected ancestor is (door de secure knoppen erin).

**(b) Het lezen van markers — het secret-patroon**:
- **GEMETEN** `Markers.lua:11-13`: commentaar zegt dat `GetRaidTargetIndex`
  **SecretReturns** is volgens `RaidMarkersDocumentation` uit
  wow-ui-source 12.1.0, en dat het spel de marker tijdens een key kan
  verbergen.
- **GEMETEN** `Markers.lua:14-21` (`MarkIndex`): retourneert **twee** waarden —
  de index, én een boolean "verborgen". Secret → `nil, true`.
  Niet-nummer of buiten 1..8 → `nil, false`.
- **GEMETEN** `Markers.lua:38-47`: als de marker verborgen is, houdt de badge de
  **laatst gelezen** marker voor diezelfde nameplate vast, gedimd op alpha 0.7.
  Voor een vijand waarvan de marker **nooit** leesbaar was wordt **niets**
  getoond — commentaar: "nothing is invented".
- **GEMETEN** `Markers.lua:23-26, 172-178`: de onthouden toestand wordt vergeten
  bij `NAME_PLATE_UNIT_REMOVED` en `PLAYER_ENTERING_WORLD`, omdat
  nameplate-tokens worden hergebruikt.

**AFGELEID**: dit "laatst leesbare waarde, gedimd, en nooit iets tonen wat we
nooit konden lezen"-patroon is het beste antwoord op secret values dat ik in
deze addon zie. Direct bruikbaar voor MH's `ns.Aura`-façade en voor alles waar
we 3 toestanden hebben.

- **GEMETEN** `Markers.lua:95-103` (`GetMarkerStatus`): de UI zegt zelf waarom
  markeren nu niet kan — in combat, of in een **raid** zonder leider/assistent-
  rechten (`UnitIsGroupLeader` / `UnitIsGroupAssistant`).
- **GEMETEN** `Markers.lua:183-194`: de badge-polling staat op **0.2 s** en
  stopt volledig (`pollingActive = false`) als de feature uit is of er geen
  nameplates zijn.

### QuickMark.lua + QuickMarkUI.lua + RunMarkerBar.lua — markeren in de pull
**GEMETEN** `QuickMark.lua`: drie toetsen (toets / SHIFT+toets / CTRL+toets)
die skull / cross / triangle op je **mouseover** zetten, zonder menu.

- `QuickMark.lua:85-109` (`PrepareQuickMarkers`): dezelfde drie onzichtbare
  secure knoppen (`AggroCallerQuickMarker8/7/4`), zelfde
  `*harmbutton1`/`type-markenemy`/`raidtarget`-opzet.
- **GEMETEN** `QuickMark.lua:56-68, 98-102`: ze wrappen de OnClick met
  **`SecureHandlerWrapScript`**, en in dat restricted snippet gebruiken ze
  **`SecureCmdOptionParse`** met macro-condities (`[@mouseover,harm,nodead]`,
  met optioneel een `[@target,harm,nodead]`-terugval). Als de parse geen
  bruikbare unit geeft, wordt `unit` op `"none"` gezet en de klik afgebroken.
  Commentaar `QuickMark.lua:56-57`: "Executed by Blizzard's restricted handler
  at the hardware click, not by insecure OnUpdate/PreClick."
- **GEMETEN** `QuickMark.lua:89, 98-101, 72, 80`: de wrap zit in een `pcall`;
  als `SecureHandlerWrapScript` niet bestaat valt de feature **terug op simpele
  mouseover** en de optionele target-fallback wordt **geweigerd** in plaats van
  stil versoepeld.
- **GEMETEN** `RunMarkerBar.lua:96-99`: als de wrap mislukte, worden de knoppen
  **uitgezet** (`type-markenemy` op nil, `Disable()`, alpha 0.35) met
  commentaar "Never silently fall back to a weaker target filter."

**AFGELEID**: dit is het sterkste technische idee na het marker-actietype —
je kunt macro-condities **binnen** de secure omgeving evalueren en zo een
keybind laten werken op "de vijand onder mijn muis", zonder ooit zijn naam of
GUID te lezen. Precies wat in 12.x nodig is nu identiteit secret kan zijn.
⚠️ **NIET GEVERIFIEERD tegen de client**.

**Keybind-transactie (los idee, relevant voor MH's keybind-werk)**:
- **GEMETEN** `QuickMark.lua:12-18` (`KeyValid`): accepteert alleen
  `^[A-Z0-9]+$`, max 20 tekens, en weigert ESCAPE, PRINTSCREEN, alle
  modifier-toetsen, en alle `BUTTON*` behalve BUTTON4/BUTTON5.
- **GEMETEN** `QuickMark.lua:110-123` (`PreviewQuickMarkKey`): checkt eerst
  `GetBindingAction(key)` **en** `GetBindingAction(key, true)` (effectief) voor
  alle drie varianten, en weigert bij elk conflict met een melding welke toets
  al bezet is.
- **GEMETEN** `QuickMark.lua:126-153` (`Transaction`): legt eerst elke te
  wijzigen binding vast, zet dan `SetBindingClick`, verifieert na élke stap dat
  `GetBindingAction` het verwachte resultaat geeft, en **rolt alles terug** bij
  de eerste fout. Commentaar `QuickMark.lua:139`: "Never persist a partial
  restoration." Pas aan het eind `SaveBindings(set)`.
- **GEMETEN** `QuickMark.lua:24-45`: per-account (`set==1`) of per-character
  (`set==2`) bindingsets; de eigenaarssleutel voor een character is de
  **player-GUID**, met commentaar `QuickMark.lua:27`: "Player identity only…
  Never an enemy ID." Een oude 2.21-sleutel zonder character wordt alleen
  geadopteerd als het hele actieve trio bewijst dat hij hier hoort.
- **GEMETEN** `QuickMark.lua:46-55` (`Ready`): weigert in lockdown, en weigert
  als `GetCurrentBindingSet`/`SetBindingClick`/`SetBinding`/`GetBindingAction`/
  `SaveBindings` niet alle vijf bestaan — met de boodschap "gebruik dan het
  WoW-keybindpaneel".

**AFGELEID**: dit is een volwassen antwoord op "de addon zet geen binds" uit
MH's eigen keybind-schema (memory: `keybind-scheme-v7-direction.md`). Zij zetten
ze wél, maar alleen na een expliciete klik, met conflictweigering en met
volledige rollback. Dat is een middenweg die MH zou kunnen overwegen.

**GEMETEN** `RunMarkerBar.lua`: een klein 330×112-balkje met alle 9
markerknoppen (8 markers + wissen) voor je **huidige target**, bedoeld om
tijdens een run open te laten staan.
- `RunMarkerBar.lua:15-31` (`RefreshRunMarkerStatus`): één statusregel die
  precies zegt waarom het nu niet werkt — client ondersteunt het niet, wijziging
  wacht op het einde van het gevecht, raid zonder rechten, of "selecteer een
  levende vijand".
- `RunMarkerBar.lua:42-58`: **alleen de koptekst** is versleepbaar, als apart
  frame, zodat de sleepzone nooit over de markerknoppen ligt. Slepen is
  geblokkeerd in lockdown.
- `RunMarkerBar.lua:119-129`: in lockdown wordt de gewenste eindtoestand
  **in de wachtrij** gezet (`runMarkerBarPending`) en de bestaande secure
  acties blijven bruikbaar; niets wordt geometrisch veranderd.
- `RunMarkerBar.lua:115-117`: commentaar dat de secure knoppen hun **ancestor
  protected maken**, dus: geen `UISpecialFrames`, geen `PresentWindow`, geen
  state-driver-churn, geen insecure combat-geometrie.

**GEMETEN** `RunTools.lua:3-12`: markers krijgen een **betekenis** die de speler
zelf kiest — `focus1/focus2/focus3/interrupt/cc/none`, standaard skull=focus1,
cross=focus2, triangle=focus3, moon=cc. Die betekenis wordt in de badge boven de
nameplate getoond.
**AFGELEID**: dit is een "spelers kiezen, niet wij"-ontwerp (memory:
`players-choose-not-us.md`) en past bij MH.

### Recognition.lua + RecognitionDiagnostic.lua — vijandherkenning
**GEMETEN** `Recognition.lua:27-77` (`GetUnitGuideEntry`): probeert een vijand
te matchen aan een gidsregel, in deze volgorde:
1. `UnitExists` en `UnitCanAttack` (beide via de secret-veilige `Read`).
2. `UnitGUID` → regex op het GUID-formaat, pakt de **creature-id** eruit,
   alleen voor `Creature`/`Vehicle`. Een `Player-`/`Pet-`GUID → meteen
   "unknown".
3. Alleen als er geen NPC-id is: `UnitName` → **exacte** match in een
   per-dungeon, per-locale naamtabel. Commentaar `Recognition.lua:67`: "Exact
   match: no case folding, substring or guessed translation."
- **GEMETEN** `Recognition.lua:59-61`: commentaar "An explicit unknown NPC ID
  must never be overridden by a matching name" — als het id leesbaar is maar
  onbekend, mag de naam het niet overrulen.
- **GEMETEN** `Recognition.lua:68`: een naam die in de tabel op `false` staat
  betekent **ambigu** (meerdere npc-id's delen die naam) → geweigerd.
- **GEMETEN** `Recognition.lua:8-17`: de `Read`-helper gooit secrets weg
  **vóór** élke typeconversie, vergelijking of tabel-lookup, en geeft een van
  vijf redenen terug: `api_missing`, `error`, `restricted`, `unavailable`,
  `readable`. Commentaar: live namen en GUID's worden **nooit** gecached of in
  diagnostiek/SavedVariables opgeslagen.
- **GEMETEN** `Recognition.lua:72-76`: bij falen wordt de **meest informatieve**
  fout bewaard, zonder de waarde zelf te bewaren.

**GEMETEN** `RecognitionDiagnostic.lua:1-13`: een diagnosevenster dat per
veld (GUID / naam) in gewone taal zegt wat de staat is: *exploitable,
protégé, absent, API absente, erreur API, format invalide, non lu, aucun
ennemi, reconnu, hors catalogue, nom ambigu : refusé, langue du jeu non
couverte, donjon non reconnu*.
- **GEMETEN** `RecognitionDiagnostic.lua:81-85`: luistert op
  **`ADDON_RESTRICTION_STATE_CHANGED`**, `PLAYER_TARGET_CHANGED`,
  `UPDATE_MOUSEOVER_UNIT`, nameplate-events, regen-events, zone-events.

**AFGELEID**: dit "laat de speler zien wat we wél en niet konden lezen"-venster
is precies wat MH mist waar wij nu stil falen (memory:
`silence-is-not-absence.md`). Sterk idee.
⚠️ `ADDON_RESTRICTION_STATE_CHANGED` is **NIET GEVERIFIEERD tegen de client** —
hun code is een kandidaat dat dit event bestaat, geen bewijs.

### AutoGuidance.lua — de automatische tactiek-HUD
**GEMETEN**: optioneel (standaard **uit**, `AggroCaller.lua:93`). Als je in een
erkende S2-dungeon bent, toont hij voor je target/mouseover een HUD met de
categorie (FOCUS / INTERROMPRE / CONTRÔLE / DISSIPATION / …) en wat je moet
doen, plus kleine badges boven de nameplates.

- **GEMETEN** `AutoGuidance.lua:20-41` (`GetActiveDungeonGuide`): identificeert
  de dungeon in drie stappen: (1) `IsInInstance()` moet `"party"` geven,
  (2) `GetBuildInfo()` moet met `^12%.1%.` matchen — **de hele feature zet
  zichzelf uit op een andere patch**, (3)
  `C_ChallengeMode.GetActiveChallengeMapID()` als er een key loopt, anders
  `C_Map.GetBestMapForUnit("player")`.
- **GEMETEN** `AutoGuidance.lua:32`: commentaar "An unknown active key must
  never fall back to a parent zone."
- **GEMETEN** `AutoGuidance.lua:38`: de zone-match slaat **index 1** van de
  zonelijst over, met commentaar "MDT's first zone is an outdoor parent: never
  use it as dungeon evidence."
- **GEMETEN** `AutoGuidance.lua:88-105`: de HUD toont **per faalreden** een
  eigen uitlegtekst — "Identiteit verborgen door WoW … geen prioriteit wordt
  afgeleid", "Naam gedeeld door meerdere id's", "Geen geverifieerde namen voor
  de taal van de client", "Doel staat buiten de 32 fiches".
- **GEMETEN** `AutoGuidance.lua:112`: een regel met `review == "disputed"` krijgt
  **géén** nameplate-badge (alleen de HUD), omdat de bron zichzelf tegenspreekt.
- **GEMETEN** `AutoGuidance.lua:190-196`: OnUpdate op **0.25 s**, met een
  `dirty`-vlag; als er niets vies is en de feature uit staat, meteen eruit.
- **GEMETEN** `AutoGuidance.lua:173-188`: fijnmazige invalidatie — een
  nameplate-event reset alleen zijn **eigen** badge; een nieuwe mouseover wist
  de HUD alleen als de HUD de vórige mouseover toonde. Commentaar zegt dat het
  eerder flikkerde.

**AFGELEID**: de patch-gate op `^12%.1%.` is een hard en eerlijk idee: data die
aan een patch hangt, zet zichzelf uit zodra de patch verandert. MH zou dat
kunnen overwegen voor onze S2-tips.

### NativeSignals.lua — Blizzards eigen signalen (het secret-passthrough-idee)
**GEMETEN**: optioneel (standaard **uit**, `AggroCaller.lua:89`). Twee dingen
boven de nameplate: (a) een categorie, (b) een "SORT IMPORTANT"-balk.

**(a) Categorie** — `NativeSignals.lua:15-26`: probeert
`UnitIsBossMob`, dan `UnitIsLieutenant`, dan `UnitClassification`
(`worldboss` → BOSS, `elite`/`rareelite` → ÉLITE). Commentaar
`NativeSignals.lua:14`: "These are Blizzard categories, never inferred
identities or a kill order." Als alle drie `restricted` zijn → `nil, "restricted"`.
⚠️ `UnitIsBossMob` en `UnitIsLieutenant` zijn **NIET GEVERIFIEERD tegen de
client**; hun bestaan in 12.1 is een kandidaat.

**(b) Important cast — dit is het meest interessante secret-idee**:
- **GEMETEN** `NativeSignals.lua:29-38` (`ReadCastID`): leest het spell-id uit
  `UnitCastingInfo` (return-slot 9) of `UnitChannelInfo` (slot 8). Commentaar
  `NativeSignals.lua:33`: "A secret is passed ONLY to Blizzard's accepting
  display APIs below." Een secret id wordt dus **niet** weggegooid maar
  doorgegeven met status `"available"`.
- **GEMETEN** `NativeSignals.lua:47`: vereist `C_Spell.IsSpellImportant`.
- **GEMETEN** `NativeSignals.lua:49`: vereist dat élke doelregio een
  **`SetAlphaFromBoolean`**-methode heeft, anders stopt het als
  `"display_unavailable"`.
- **GEMETEN** `NativeSignals.lua:54-62`: het verdict van `IsSpellImportant`
  (dat zelf een secret boolean mag zijn) wordt **rechtstreeks** aan
  `SetAlphaFromBoolean(region, important, 1, 0)` gegeven. Commentaar
  `NativeSignals.lua:57-58`: "No truth test, ordering, sound, mark,
  GetAlpha/IsShown readback or logging of this verdict."
- **GEMETEN** `NativeSignals.lua:63`: de functie retourneert voor `true`,
  `false` **en** secret exact dezelfde string `"display_only"` — bewust, zodat
  de addon zelf niet kan weten wat er getoond werd.
- **GEMETEN** `NativeSignals.lua:103`: commentaar "Visibility here depends on
  the accessible plate, never on the cast verdict."
- **GEMETEN** `NativeSignals.lua:126-129`: op
  `ADDON_RESTRICTION_STATE_CHANGED` worden alle badges verborgen en wordt er
  **niet** gelezen; commentaar zegt dat de nieuwe restrictie pas ná dit event
  geldt, dus lezen gebeurt op een latere tick.
- **GEMETEN** `NativeSignals.lua:137-146`: OnUpdate op **0.5 s**, en nul werk
  als de feature uit is of er geen nameplates zijn.

**AFGELEID — dit is het grootste idee voor MH**: je kunt een **onleesbare**
waarde toch nuttig maken door hem aan een Blizzard-setter te geven die secrets
accepteert, zolang je hem nooit terugleest en er geen gedrag aan hangt. MH's
eigen memory zegt dat `IsSpellImportant` **smal** is (3 van 29 eigen bosstips,
`isspellimportant-is-narrow.md`) — dus dit idee is technisch mooi maar de
dekking is bij ons al gemeten als klein. Het patroon
"`SetAlphaFromBoolean` met een secret" is desondanks breed herbruikbaar.
⚠️ **NIET GEVERIFIEERD tegen de client**: dat `SetAlphaFromBoolean` bestaat en
secrets accepteert, is hún aanname. MH moet het zelf meten.

Zie ook MH-memory `enemy-casts-unidentifiable-12-1.md`: wij hebben gemeten dat
spell-id, icoon, tijden én `notInterruptible` van vijandelijke casts secret
zijn. Hun aanpak is consistent met die meting — zij lezen het id niet, ze
**sluizen het door**. Dat is de enige route die onze eigen meting toelaat.

### DungeonGuide.lua / DungeonGuideData.lua / DungeonIdentity.lua / DungeonNames.lua
**GEMETEN** `DungeonGuideData.lua:3-9`: `AC.dungeonGuides` = 8 dungeons × 4
regels = **32 fiches**, plus 8 handmatige tips (zie §5). Elke regel heeft:
`id`, `enemy` (EN-naam), `spell` (EN-naam), `kind` (focus/interrupt/summon/
control/utility/situational/uncertain), `reason` en `action` als
`{frFR=…, enUS=…}`, en `review` (`"documented"` of `"disputed"`).
**GEMETEN**: elke dungeon-tabel draagt zijn eigen `season = "Midnight S2"`,
`patch = "12.1"`, `checked = "2026-09-28"`, `sourceUpdated = "2026-08-11"` en
een `source`-URL.

**AFGELEID**: data die haar eigen houdbaarheidsdatum **en** de datum van de
bron meedraagt, is een beter model dan één globale datum. MH's
content-wachter zou hier per fiche op kunnen draaien in plaats van per bestand.

**GEMETEN** `DungeonIdentity.lua:2-13`: per dungeon een `challengeMap`-id, een
`zones`-lijst en een `npcs`-map van **4** creature-id's naar fiche-id's.
Commentaar regel 2-3: "Factual NPC and map IDs checked against installed
MDT 6.2.19 on 2026-09-23. No routes, coordinates or MDT executable code are
included."
**GEMETEN** `DungeonNames.lua:2`: "Exact factual NPC names cross-checked against
installed MDT 6.2.19, 2026-09-23."

**AFGELEID**: zij gebruiken een geïnstalleerde andere addon (MDT) **alleen** als
feitenbron voor id's en namen, en zeggen expliciet dat ze geen routes,
coördinaten of code overnemen. Dat is dezelfde grens die MH aanhoudt bij Zygor
(memory: `zygor-guide-data-source.md`) en bij Friend Finder.

**GEMETEN** `DungeonGuide.lua:1-3`: sinds 3.0 is de gids een **pagina van het
hoofdmenu**; dit bestand houdt alleen nog de data-API (lookup, zoeken, labels,
bronnen).

**GEMETEN** `AggroCaller.lua:716`: hun eigen diagnoseregel is eerlijk:
`"guide=32 identity entries + 8 manual tips; review 2026-09-28; no in-game
validation"`. Ze zeggen dus zelf dat het **niet in het spel** is gevalideerd.

### GearGuide.lua + GearData.lua — equipment-doelen
**GEMETEN** `GearData.lua:1-12`: `AC.gearGuide` met
`checked = "2026-09-30"`, `season = "Midnight S2"`, `patch = "12.1"`.
Veldnamen zijn kort gehouden: `s` = slot, `id` = item, `k` = bron-soort
(raid/dungeon/craft/tier/mplus/unknown), `z` = zone (AreaTable), `b` =
boss-index, `sk` = beroepslijn, `tier`, `orig` (item om te catalyseren),
`u` = aantal top-spelers dat het draagt op Murlok, `alt`/`altU` = meest
gedragen alternatief als `u` 0 is.
**GEMETEN** `GearData.lua:2-4`: gegenereerd uit Wowhead BiS-gidsen én
Murlok.io (gear van top-M+-spelers).
**GEMETEN** `GearData.lua:14-25`: fallback-zonenamen FR/EN, met commentaar dat
de **eigen gelokaliseerde naam van het spel** de voorkeur heeft.
**GEMETEN** `GearData.lua:1218`: een tweede blok met upgrade-tracks
(bonus-id's en item-levels, "Wowhead tooltips, 2026-09-30").

**GEMETEN** `GearGuide.lua:1-12`: leest klassen en specs **uit het spel**, de
itemstaat uit je uitrusting en tassen. `GearGuide.lua:9-12`: de derde
Demon-Hunter-spec wordt bewust op de string `"devourer"` gesleuteld "so no
unverified spec ID is stored".
**GEMETEN** `GearGuide.lua:95-96`: eigen cache-invalidatie op
`PLAYER_EQUIPMENT_CHANGED`, `BAG_UPDATE_DELAYED`, `PLAYER_ENTERING_WORLD`,
`PLAYERBANKSLOTS_CHANGED`.
**GEMETEN** `CHANGELOG.md:98`: `EstimateItemSwap` vergelijkt **kale** items
(zonder enchant/gems), haalt je huidige gems en enchant eraf (de enchant
geparseerd uit de `ENCHANTED_TOOLTIP_LINE`-tooltipregel) en zet ze terug op het
nieuwe item.

**AFGELEID**: het "liever de naam van het spel dan onze eigen tabel, en een
string-sleutel in plaats van een verzonnen id" is dezelfde discipline die MH
aanhoudt. De enchant-uit-tooltip-parse is een kandidaat-techniek maar
breekbaar bij locale-wijzigingen.

### SpecGuideData.lua — gems, enchants, consumables, talent-codes
**GEMETEN** `SpecGuideData.lua:1-20`: `AC.specGuide`, `checked = "2026-09-30"`,
per spec-id (bijv. `[250]` = blood DK) de Wowhead-URL's, `players = 50`, en per
slot een rij met `wh` (Wowheads keuze) en `mu` (`{ref, aantal}` op Murlok).
Refs zijn `i<id>` voor item en `s<id>` voor spell.
**GEMETEN** `SpecGuideData.lua:787-825`: **talent-importcodes** als lange
strings, per hero-talent en per content-soort (Raid / M+ / Gouffres=Delves),
met `best = true` op de aanbevolen variant en een `top`-getal.
**GEMETEN** `CHANGELOG.md:87`: gegenereerd door eigen tooling
(`guide_fetch.sh`, `guide.py`, `guidelua.py`); FR/EN-namen uit
Wowhead-tooltips; `MergeSpecGuideRow` kruiscontroleert op de **Engelse** naam.
**GEMETEN** `SpecGuideData.lua:1395`: een `names`-tabel met geverifieerde
FR/EN-itemnamen per id.

**AFGELEID**: talent-importcodes als platte string opslaan en laten kopiëren is
goedkoop en robuust — geen talent-API nodig. Kandidaat-idee voor MH's
"Zo speel je"-kaarten (memory: `spec-play-cards-eli10.md`).

### Stats.lua + Experience.lua — statistieken per key
**GEMETEN** `Stats.lua:3-5`: per key de context, DPS/healer-threat-observaties,
en schade/genezing per seconde aan het eind. Commentaar regel 5: "Everything
stays local to this character; nothing is sent to anyone."
**GEMETEN** `Stats.lua:22-23, 47`: `CaptureRunContext` legt keystone-level,
spec, rol en item-level vast bij de start; `CaptureRunCompletion` het officiële
resultaat (level en timer) "if WoW gives it".
**GEMETEN** `Stats.lua:58-61`: één "aggro" wordt geteld elke keer dat vijanden
op je beginnen te slaan; de tijd loopt tot niemand dat meer doet.
**GEMETEN** `Stats.lua:80-130`: meter-bronnen worden **op volgorde** geprobeerd
en de eerste die antwoordt levert **beide** waarden, "so a key never mixes
numbers from two meters". Bronnen: `ReadBlizzardMeter` (`Stats.lua:82-83`, via
**`C_DamageMeter`**) en `ReadDetails` (`Stats.lua:101`, Details!).
**GEMETEN** `Stats.lua:134-135`: `/aggrocaller meter` laat zien wat elke bron
**nu** antwoordt, expliciet "to check in game".
**GEMETEN** `Stats.lua:147-149`: de meter wordt pas **een paar seconden ná** het
einde van de key gelezen, omdat meters hun laatste segment nog moeten sluiten.
**GEMETEN** `Stats.lua:171-173`: elke metriek geeft een getal **of nil** als die
key hem niet gemeten heeft — "never a guessed zero".
**GEMETEN** `Stats.lua:230-232`: omdat `AggroCallerDB` account-breed is, draagt
elk keyrapport de character die het speelde (`run.char`).
**GEMETEN** `CHANGELOG.md:30`: oudere rapporten zonder bekende eigenaar worden
alleen getoond aan een character van **dezelfde klasse** als de spec van het
rapport, en nooit als eigen geboekt. Retentie: 30 rapporten per character,
240 in totaal.

**GEMETEN** `Experience.lua:6-12` (`PresentWindow`): utility-vensters gaan naar
`FULLSCREEN_DIALOG`, `SetToplevel(true)`, en de laatst geopende wint.
Commentaar regel 5: secure marker-paletten roepen dit **alleen** na hun eigen
combat-guard.
**GEMETEN** `Experience.lua:14-27`: een "minimal"-modus waarin per gebeurtenis
(healer / lost / recovered) apart instelbaar is of er een indicator én of er
een geluid komt.
**GEMETEN** `Experience.lua:68-88` (`BuildCombatHistoryText`): de
gevechtsgeschiedenis **opent** met een disclaimer dat het lokale observaties
zijn, geen volledig combatlog, en dat de tellers **gebeurtenissen** meten, geen
unieke vijanden. Per gevecht komt er een dekkingsregel: `readable == 0` →
"GEEN LEESBARE MENACE", `unavailable > 0` → "GEDEELTELIJKE DATA", anders
"LEESBARE STEEKPROEVEN — volledige pull niet gegarandeerd". Bij `readable == 0`
worden verliezen/herstel **helemaal niet** gerapporteerd.

**AFGELEID**: dit is de beste uitwerking van "stilte is geen afwezigheid" die ik
in een addon heb gezien, en het is een los overneembaar idee: **sla naast elke
meting op hoeveel reads lukten en hoeveel niet, en laat de UI dat zeggen.**

### Features.lua — presets en de diagnose-waarom
**GEMETEN** `Features.lua:3-13`: drie presets — `discreet`, `standard`,
`assistance` — die elk ~10 instellingen in één klik zetten.
**GEMETEN** `Features.lua:24-25`: het kiezen van een preset laat een
**voorbeeld** zien en stuurt nooit chat en speelt nooit geluid.
**GEMETEN** `Features.lua:29-49` (`GetDetectionReason`): één functie die in
gewone taal zegt **waarom er nu niets gebeurt** — addon uit, verkeerde content,
tank-modus uit, geen groep, wacht op combat, data onbeschikbaar, data
gedeeltelijk, geen nameplates, geen data, alarm actief, geen verlies. Twaalf
onderscheiden redenen, in volgorde van specifiek naar algemeen.
**GEMETEN** `Features.lua:70-75`: als de laatste threat-leesfout jonger dan 2 s
is, wordt de **reden** getoond: "valeur protégée par WoW" (secret), "erreur de
lecture de l'API", of "aucune valeur exploitable".

**AFGELEID**: deze `GetDetectionReason` is een los, goedkoop en zeer waardevol
idee voor MH — één functie die altijd kan uitleggen waarom een feature stil is.
Dat sluit direct aan op MH's marktpositie "MH's kracht is **uitleggen**"
(memory: `mh-market-position.md`).

### Systems.lua — export/import, log, performance, geluid, minimap
**GEMETEN** `Systems.lua:29-193`: een instellingen-**export/import** als tekst,
met eigen encode/decode, een `IsFinite`-check, een `ValidScalar`-whitelist per
sleutel en een `ParseImportedTable`. **AFGELEID**: import wordt dus
gevalideerd per sleutel, niet blind ingeladen — belangrijk, want een
SavedVariables-import is anders een injectiepad.
**GEMETEN** `Systems.lua:227-248`: een intern logboek (`LogInternal`,
`GetInternalLogText`, `ClearInternalLog`), begrensd op **20** regels
(`AggroCaller.lua:708` rapporteert `internalLog=<n>/20`).
**GEMETEN** `Systems.lua:250-292`: `AC.performance` met `RecordPerformance`,
buckets en een `GetPerformanceText`.
**GEMETEN** `Systems.lua:294-330`: LibSharedMedia-integratie voor geluiden, met
`GetSharedMediaSoundCount` zodat de diagnose kan zeggen hoeveel er beschikbaar
zijn.
**GEMETEN** `Systems.lua:445-467`: `ApplyAccessibilityMode`.
**GEMETEN** `Systems.lua:469-493`: `RunMigrations`.
**GEMETEN** `Systems.lua:495-530`: `BuildSelfTestReport` / `RunSelfTest`.
**GEMETEN** `Systems.lua:519-529`: **de taint-monitor** — een frame op
`ADDON_ACTION_BLOCKED` en `ADDON_ACTION_FORBIDDEN`; als de addonnaam
`"AggroCaller"` is, wordt het in het interne log geschreven als
`ERROR: <event>: <action>`.
**GEMETEN** `Systems.lua:553-564`: `IsMinimapButtonCollected` leest
`_G._EBS_CachedAddonButtons` van **EllesmereUI** om te weten of de
minimap-knop door een andere addon is opgeslokt.

**AFGELEID**: de taint-monitor is een klein maar scherp idee — je addon merkt
zélf wanneer hij geblokkeerd wordt en schrijft dat in een log dat de speler kan
kopiëren. Direct relevant voor MH's open CLEU-taint-onderzoek (memory:
`cleu-taint-investigation.md`): zo'n monitor zou die vraag kunnen beantwoorden.
Let op de EllesmereUI-koppeling: MH-memory zegt dat Rob EllesmereUI **niet**
gebruikt (`savedvariables-is-not-in-use.md`), dus die tak is bij hem dood.

### Profiles.lua — profielen per spec en per rol
**GEMETEN** `Profiles.lua:5-15`: een **whitelist** `profileKeys` van ~30
sleutels die in een profiel meegaan (posities, scales, afmetingen, kleuren,
toegankelijkheid, minimal-modus). Niet de hele db.
**GEMETEN** `Profiles.lua:212-217`: reageert op `ADDON_LOADED`,
`PLAYER_SPECIALIZATION_CHANGED`, `PLAYER_ROLES_ASSIGNED`,
`GROUP_ROSTER_UPDATE`, `PLAYER_LOGOUT`, `PLAYER_REGEN_ENABLED`.
**GEMETEN** `AggroCaller.lua:48-51`: twee onafhankelijke schakelaars —
`perSpecProfiles` (uit) en `autoRoleProfiles` (aan), plus
`roleLayoutProfiles` (`AggroCaller.lua:80`).
**AFGELEID**: het wisselen gebeurt op `PLAYER_REGEN_ENABLED` erbij, dus
profielwissels wachten tot buiten combat.

### Setup.lua — de installatiewizard
**GEMETEN** `Setup.lua:1-11`: een eenvoudige wizard met gestapelde knoppen en
een `RefreshWizardStatus`. **GEMETEN** `AggroCaller.lua:47`:
`setupComplete = false` als default; `AggroCaller.lua:1062-1063`:
`/aggrocaller setup`. **GEMETEN** `Setup.lua:95`: eigen `ADDON_LOADED`-loader.

### Editor.lua — de layout-editor
**GEMETEN** `Editor.lua:4-11`: **5** verplaatsbare elementen, elk met een
`position`-, `scale`- en `visible`-db-sleutel: `alert`, `callout`, `counter`,
`markers` (absolute coördinaten), `guide` (absolute coördinaten).
**GEMETEN** `Editor.lua:9`: commentaar dat de twee HUD's hun coördinaten in
**UIParent-eenheden** bewaren, anders dan de drie oudere frames.
**GEMETEN** `Editor.lua:387`: registreert `PLAYER_REGEN_DISABLED` — de editor
sluit/blokkeert zich dus bij het begin van een gevecht.
**GEMETEN**: `Editor.lua` heeft **14** `InCombatLockdown`-checks, de meeste van
alle bestanden na `WindowSizing.lua` (9).
**GEMETEN** `AggroCaller.lua:44-45`: `editorSnap = true`,
`editorGridSize = 20` — raster met snapping.
**GEMETEN** `AggroCaller.lua:713-714`: drie opslagbare layouts
(`savedLayouts[1..3]`) plus een `previousLayout` voor ongedaan maken.

### Locales.lua — localisatie (zie §6)
### UI.lua / MenuKit.lua / Dimensions.lua / WindowSizing.lua / OptionsV3.lua
**GEMETEN** `UI.lua:3-4`: eigen fonts, `AC.fontBody` = Lato-Regular,
`AC.fontHeading` = Lato-Bold, als pad naar het meegeleverde ttf.
**GEMETEN** `UI.lua:6-13`: `ReloadInterface` weigert in lockdown met een
nette boodschap.
**GEMETEN** `UI.lua:403`: `hooksecurefunc(frame, "SetScale", Sync)` — één
secure hook om schaalwijzigingen te spiegelen.
**GEMETEN** `CHANGELOG.md:159`: `AC:RoundCorners` tekent niet-overlappende
stukken (middenband, twee strips, vier kwartcirkels uit `CornerMask.tga`) en
doorgeeft positie, kleur, gradient, alpha en zichtbaarheid.

**GEMETEN** `MenuKit.lua:1-12`: pagina/tab-registry (zie §1).
**GEMETEN** `MenuKit.lua:3-4`: expliciet contract — "Components are created
once and updated with setters: nothing here creates a texture or a mask on
refresh."
**GEMETEN** `MenuKit.lua:135`: een `SetSources`-component die per kaart een
lijst `{label, url, checked}` toont — **de bron en de controledatum staan in de
UI**.
**GEMETEN** `MenuKit.lua:204-207`: item-namen/kwaliteit via
`Item:CreateFromItemID(id):ContinueOnItemLoad(...)` — asynchroon, geen
tooltip-scrape.

**GEMETEN** `Dimensions.lua:3-9`: één tabel `AC.dimensionDefs` met voor elk van
de 5 frames de db-sleutels plus `width/height/minW/minH/maxW/maxH`.
`NormalizeDimensions` (`Dimensions.lua:10-13`) klemt en rondt af.
**AFGELEID**: één tabel als enige waarheid over afmetingen is een goed klein
idee; MH heeft dit nu verspreid.

**GEMETEN** `WindowSizing.lua:3`: `AC.windowScaleKeys` — een **whitelist** van
13 framenamen die een schaalgreep mogen krijgen.
**GEMETEN** `WindowSizing.lua:6-8`: `AddScaleGrip` weigert in lockdown.
**GEMETEN** `WindowSizing.lua:5`: een `Finite`-check tegen NaN/inf uit
SavedVariables.
**GEMETEN** `WindowSizing.lua:91`: reageert op `PLAYER_REGEN_DISABLED`,
`PLAYER_REGEN_ENABLED`, `DISPLAY_SIZE_CHANGED`, `UI_SCALE_CHANGED`.
**GEMETEN** `CHANGELOG.md:297, 309`: het hoofdvenster heeft echte
twee-assige resizing, 640–2000 breed en 540–1600 hoog in UI-eenheden; smalle
vensters herordenen de navigatie naar één kolom en verbergen de sessie-sidebar.

**GEMETEN** `OptionsV3.lua:1` (318 KB): "AggroCaller NOCTURNE. Horizontal
navigation, session companion and editorial home." Dit is het hele
instellingen- en inhoudsmenu in één bestand.
**Structureel gesampled** (niet integraal gelezen):
- `OptionsV3.lua:10-12`: eigen themakleurtokens (`BG`, `BG_DEEP`, `ROW_BG`,
  `TXT`, `TXT_DIM`) uit `AC.theme`.
- `OptionsV3.lua:234`: een droplist registreert `GLOBAL_MOUSE_DOWN` bij OnShow
  om buiten-klik te sluiten.
- `OptionsV3.lua:2381-2383, 2587-2588`: itemdata asynchroon via
  `Item:CreateFromItemID` + `C_Item.DoesItemExistByID`.
- `OptionsV3.lua:2835-2836`: `hooksecurefunc` op **zowel**
  `ChatEdit_InsertLink` als `ChatFrameUtil.InsertLink` — oud en nieuw pad, voor
  shift-klik-items in een invoerveld.
- `OptionsV3.lua:3069-3070, 3230, 3399, 3711`: per tab een eigen eventframe met
  precies de events die die tab nodig heeft (`PLAYER_EQUIPMENT_CHANGED`,
  `BAG_UPDATE_DELAYED`, `UNIT_STATS` (unit-filtered op "player"),
  `COMBAT_RATING_UPDATE`, `PLAYER_SPECIALIZATION_CHANGED`).
- `OptionsV3.lua:4986-4987`: `PLAYER_REGEN_DISABLED/ENABLED`,
  `PLAYER_SPECIALIZATION_CHANGED`, `PLAYER_ROLES_ASSIGNED`.
**AFGELEID**: `RegisterUnitEvent("UNIT_STATS", "player")` in plaats van
`RegisterEvent` is de goedkope variant — MH zou dit overal moeten doen waar we
maar één unit volgen.

**GEMETEN** `ReleaseNotes.lua` (46 KB): een in-game "nieuw in deze versie"-
venster, per versie een titel en gerangschikte wijzigingen, FR/EN
(`ReleaseNotes.lua:163-164, 176, 184, 195, 202`), opgeroepen met
`/aggrocaller news`.
**AFGELEID**: in-game release notes met rang per punt is een net idee dat MH
niet heeft.

### Coach\ (28 bestanden, ~750 KB) — de "coach"-helft van de addon
**GEMETEN**: dit is inmiddels het grootste deel van de addon en staat los van
aggro. Het is een M+/raid-coach. Per bestand, uit de koppen gemeten:

| Bestand | Wat het doet (GEMETEN, file:line van de kop) |
|---|---|
| `PrepareLogic.lua` | Checks "is mijn key-voorbereiding klaar", **zonder UI**, offline testbaar. Groepen `gear`/`consumables`/`talents`/`dungeon`; staten `ok`/`warn`/`bad`/`unknown`/`info` (`:1-7`) |
| `Prepare.lua` | De pagina `prepare`, tab "Moi", en een "Aujourd'hui"-kaart (`:1-3`) |
| `Week.lua` | "Wat is mijn volgende key?" uit `C_WeeklyRewards`, `C_ChallengeMode`, `C_MythicPlus` + ontbrekende gear-doelen. "Aucune table de niveaux d'objet recopiée, aucune projection de score" (`:1-8`) |
| `Debrief.lua` | Na elke key **3** punten i.p.v. 30 cijfers: de 3 grootste afwijkingen t.o.v. de eigen mediaan (zelfde spec, ≥3 eerdere keys) (`:1-9`) |
| `LearnData.lua` + `Learn.lua` | Korte, gesourcede lesjes; affixen van de week uit het spel; "gelezen" per character (`LearnData.lua:1-6`, `Learn.lua:1-5`) |
| `InterruptData.lua` | Interrupt van elke klasse+spec, per spell-id, FR/EN-naam en basis-cooldown; "een spec zonder interrupt is `false`" (`:1-9`) |
| `Group.lua` | "Wie interrumpeert wat" — **alleen buiten combat**, inspectie één-voor-één, niets verzonden zonder klik (`:1-5`) |
| `UpgradeData.lua` + `Upgrades.lua` | Welk stuk eerst upgraden met je crests; crests uit `C_CurrencyInfo.GetCurrencyInfo`, high watermark uit `C_ItemUpgrade.GetHighWatermarkForItem`; verborgen waarde = "unknown" (`Upgrades.lua:1-9`) |
| `CrestConvert.lua` | Paneel bij de crest-ruilhandelaar; "Convert"-knop koopt bundels, één klik = één aankoop; bundels openen via een **secure** knop omdat een tas-item alleen door een klik gebruikt kan worden (`:1-9`) |
| `BonusRoll.lua` | Bij Blizzards bonus-roll-venster: kan deze boss jouw doel geven, en hoeveel Voidcores heb je. **Eerste klik vraagt alleen "Confirm?"**, tweede klik binnen 5 s rolt. "Nothing is rolled by the add-on" (`:3-8, :16`) |
| `CraftShop.lua` | Boodschappenlijst voor craften op het AH; reagentia uit `C_TradeSkillUI.GetRecipeSchematic`, bezit uit `C_Item.GetItemCount` (tas/bank/reagent/warband). "Nothing is bought, nothing happens in combat" (`:1-8`) |
| `LootData.lua` + `Loot.lua` | Loot van de 8 M+-dungeons en de raid uit het **Avonturengids** (`EJ_*` / `C_EncounterJournal`), gefilterd op spec en slot, item-levels per keylevel/difficulty, favorieten + schermalarm, teleportknop per dungeon. "Aucun taux de butin" (`Loot.lua:1-8`) |
| `GroupTeleport.lua` | Als de groep volloopt (5 spelers, buiten instance, buiten combat) een frame "teleporteren?"; dungeon uit `C_LFGList.GetActiveEntryInfo` of de listing waar je op solliciteerde, anders je eigen key als je leider bent (`:1-8`) |
| `Raid.lua` | Registreert alleen de `raid`-pagina en de overzichtstab (`:1-6`) |
| `RaidPrep.lua` | "Bereid mijn raid voor"; `READY_CHECK`-paneel buiten combat; consumables in tas + actieve effecten; "masqué ou pas encore reçu : jamais ok" (`:1-8`) |
| `RaidBossData.lua` + `RaidBosses.lua` | Per boss wat jouw **rol** aangaat, volledig uit de Avonturengids (`EJ_GetEncounterInfo`, `C_EncounterJournal.GetSectionInfo/GetSectionIconFlags`). "nothing is written by the add-on"; de iconflag-indexen zijn **bitposities van `Enum.JournalEncounterIconFlags`**, gelezen uit het spel, nooit eigen getallen (`RaidBosses.lua:1-8`, `RaidBossData.lua:1-8`) |
| `RaidGroupData.lua` + `RaidGroup.lua` | Raidsamenstelling en wat die dekt (buffs, debuffs, heroism, combat-res, dispels per type, interrupts); buiten combat, één inspectie per keer; **niets opgeslagen** — gelezen specs blijven alleen in geheugen, per GUID (`RaidGroup.lua:1-7`) |
| `RaidProgress.lua` | Boss-kills per difficulty via `C_RaidLocks.IsEncounterComplete`, locks via `GetSavedInstanceInfo`, vault via `C_WeeklyRewards` (`:1-8`) |
| `GroupMeter.lua` | **Bilan du groupe**: aan het eind van een key, buiten combat, één keer `C_DamageMeter` lezen — interrupts, dispels, ontvangen vermijdbare schade, deaths per speler; voor jezelf de duurste vermijdbare spells en de laatste klap van elke dood via `C_DeathRecap` (`:1-19`) |
| `Keys.lua` | Keys van groep en gilde; spreekt het **LibKeystone**-protocol (prefix `"LibKS"`, payload `"level,challengeMap,score"`, request `"R"`, kanalen PARTY en GUILD, max één zending per 3 s per kanaal); als de lib al door een andere addon geladen is, **abonneert** hij zich erop i.p.v. dubbel te antwoorden (`:1-9`) |
| `ReadyCheck.lua` | Consumable-check bij de ready-check in een dungeon; **hergebruikt** `RaidPrep.lua` zonder het raidgedrag te wijzigen (`:1-8`) |
| `DungeonCoverage.lua` | Groepsdekking in dungeon (heroism, combat-res, dispels per type); **hergebruikt** `RaidGroupData/RaidGroup`, `Group.lua` en `Loot.lua` zonder ze te wijzigen (`:1-8`) |

**GEMETEN** — notabele punten in Coach:
- `GroupMeter.lua:7-12`: de regels staan in de kop: alleen lezen buiten combat;
  **secret = onbekend, nooit geraden**; **geen rangorde en geen "goed/slecht"-
  kleur tussen spelers**; voor jezelf vergelijken met je eigen mediaan
  (≥3 eerdere keys); namen van anderen alleen als ze niet secret zijn, en alleen
  voor de duur van de sessie, **nooit opgeslagen**; niets wordt verzonden.
- `GroupMeter.lua:36-42`: aparte veilige lezers `Number`, `Bool`, `Str`, elk met
  een secret-check én een type/NaN/inf-check.
- `GroupMeter.lua:72-80`: commentaar dat `classFilename` en `isLocalPlayer`
  **NeverSecret** zijn en `name` **ConditionalSecret**; als er geen naam is,
  wordt een sleutel uit klasse + spec-icon gebouwd.
  ⚠️ **NIET GEVERIFIEERD tegen de client** — die NeverSecret/ConditionalSecret-
  classificatie komt uit Blizzards documentatiebestanden zoals zij die lazen.
- `GroupMeter.lua:65-69, 101-110`: elke `C_DamageMeter`-call in een `pcall`, en
  **ook de teruggegeven tabel en haar velden** worden op secret gecontroleerd.
- `GroupMeter.lua:52-61` (`Available`): vraagt eerst
  `C_DamageMeter.IsDamageMeterAvailable()` en geeft de **reden van het spel**
  terug als het niet kan.
- `Group.lua:370, 423-424` en `Keys.lua:170, 212`: addon-berichten gaan alleen
  als `C_ChatInfo.AreOutgoingAddonChatMessagesRestricted` bestaat én toestaat;
  het resultaat van `SendAddonMessage` wordt vergeleken met
  `Enum.SendAddonMessageResult.Success`.
- `Group.lua:487`, `Keys.lua:194-195`: `RegisterAddonMessagePrefix` in een
  `pcall`.
- `BonusRoll.lua:16, 439-441`: puur **`hooksecurefunc`** op
  `BonusRollFrame_StartBonusRoll`; de addon rolt zelf nooit.
- `GroupTeleport.lua:1-8` + `CHANGELOG.md:32`: de secure teleportknop wordt op
  `UIParent` geparent en **over** een slot van het frame gelegd op een absolute
  positie; geen drag in combat; het frame sluit op `PLAYER_REGEN_DISABLED`.
- `DungeonCoverage.lua:35-39`: de iconflag-betekenis is tegen
  **warcraft.wiki.gg** gecheckt op 2026-10-02, mét URL en datum in de code.

**AFGELEID**: drie Coach-ideeën die MH direct raken.
1. **`C_DamageMeter` + `C_DeathRecap`** zijn Blizzards eigen, native bronnen
   voor interrupts, dispels, vermijdbare schade en doodsoorzaak. MH heeft een
   open **death-recap-popup-plan** (memory) en een open **CLEU-taint-vraag**:
   als `C_DamageMeter` werkt, hebben we misschien geen combatlog nodig. Dit is
   de belangrijkste meetopdracht die uit deze analyse volgt.
2. **De scheiding logica/UI** (`PrepareLogic.lua` naast `Prepare.lua`, met
   offline tests) is precies wat MH's grote modules missen.
3. **Hergebruik zonder wijzigen** (`ReadyCheck.lua` en `DungeonCoverage.lua`
   bouwen op bestaande modules en zeggen in hun kop dat ze die niet veranderen)
   is een nette discipline.

---

## 3. Techniek: API's en events (volledige inventarisatie)

### COMBAT_LOG_EVENT_UNFILTERED — het antwoord
**GEMETEN**: **nergens.** Ik heb de hele map gegrepeerd op
`COMBAT_LOG_EVENT`, `CombatLogGetCurrentEventInfo` — **nul treffers in alle
46 `.lua`-bestanden**. De addon registreert de combat log **niet**.

**AFGELEID — en dit is belangrijk voor MH**: AggroCaller levert een complete
aggro-, tank-, marker- en statistiek-addon **zonder** combatlog. Alles komt uit:
- threat-API's (`UnitThreatSituation`, `UnitDetailedThreatSituation`),
- `UNIT_THREAT_LIST_UPDATE` / `UNIT_THREAT_SITUATION_UPDATE`,
- nameplate-events + unit-tokens,
- en voor de nabeschouwing `C_DamageMeter` / `C_DeathRecap` **ná** het gevecht.

Dit maakt het hele CLEU-taint-probleem (memory:
`cleu-taint-investigation.md`) voor dit soort features **omzeilbaar**. Dat is
het antwoord op de vraag in de opdracht: ze doen het niet met CLEU, en ze
hebben het niet nodig.

### Geregistreerde events — volledige lijst (GEMETEN)
Uniek over de hele addon, met waar ze vandaan komen:

**Levenscyclus / zone**
`ADDON_LOADED` (`AggroCaller.lua:1098`, `TankMode.lua:1026`, `Systems.lua:522`,
`Profiles.lua:212`, `Setup.lua:95`, `Coach\CraftShop.lua:794`,
`Coach\Loot.lua:1188`), `PLAYER_LOGIN` (`QuickMark.lua:208`,
`Markers.lua:222`, `RunMarkerBar.lua:158`, `Coach\BonusRoll.lua:448`,
`Coach\GroupTeleport.lua:178`), `PLAYER_LOGOUT` (`Profiles.lua:216`,
`RunTools.lua:226`), `PLAYER_ENTERING_WORLD` (`AggroCaller.lua:1099`,
`Markers.lua:169`, `GearGuide.lua:96`, en 6 andere),
`ZONE_CHANGED_NEW_AREA` (`AggroCaller.lua:1100`, `AutoGuidance.lua:161`,
`NativeSignals.lua:117`, `RunTools.lua:226`),
`ZONE_CHANGED_INDOORS` (`AutoGuidance.lua:161`),
`PLAYER_DEAD` (`AggroCaller.lua:1104`, `TankMode.lua:1031`)

**Combat-lockdown**
`PLAYER_REGEN_DISABLED` / `PLAYER_REGEN_ENABLED` — in **12** bestanden:
`AggroCaller.lua:1102-1103`, `TankMode.lua:1029-1030`, `Callout.lua:394-395`,
`Editor.lua:387`, `Markers.lua:197-198`, `QuickMark.lua:208`,
`QuickMarkUI.lua:127-128`, `WindowSizing.lua:91`, `RunMarkerBar.lua:158`,
`AutoGuidance.lua:161`, `OptionsV3.lua:4986`, `Profiles.lua:217`,
`Coach\Group.lua:469`, `Coach\RaidGroup.lua:370`, `Coach\Loot.lua:558`,
`Coach\GroupTeleport.lua:182`

**Threat**
`UNIT_THREAT_LIST_UPDATE` (`AggroCaller.lua:1107`),
`UNIT_THREAT_SITUATION_UPDATE` (`AggroCaller.lua:1108`)

**Nameplates**
`NAME_PLATE_UNIT_ADDED` / `NAME_PLATE_UNIT_REMOVED` — in **5** bestanden:
`AggroCaller.lua:1105-1106`, `TankMode.lua:1027-1028`, `Markers.lua:166-167`,
`AutoGuidance.lua:161`, `NativeSignals.lua:117`,
`RecognitionDiagnostic.lua:83`

**Casts** (alleen `NativeSignals.lua:117-120`)
`UNIT_SPELLCAST_START`, `_STOP`, `_FAILED`, `_INTERRUPTED`,
`_CHANNEL_START`, `_CHANNEL_STOP`, `_CHANNEL_UPDATE`,
`_EMPOWER_START`, `_EMPOWER_STOP` — negen stuks.
Plus `UNIT_CLASSIFICATION_CHANGED` (`NativeSignals.lua:118`).

**Restricties / taint**
`ADDON_RESTRICTION_STATE_CHANGED` (`NativeSignals.lua:118`,
`AutoGuidance.lua:161`, `RecognitionDiagnostic.lua:81`),
`ADDON_ACTION_BLOCKED` + `ADDON_ACTION_FORBIDDEN` (`Systems.lua:520-521`)

**Groep / rol / spec**
`GROUP_ROSTER_UPDATE` (7 bestanden), `PLAYER_ROLES_ASSIGNED`
(`Profiles.lua:214`, `OptionsV3.lua:4987`), `PLAYER_SPECIALIZATION_CHANGED`
(6 bestanden), `INSPECT_READY` (`Coach\Group.lua:466`,
`Coach\RaidGroup.lua:367`), `READY_CHECK` (`Coach\ReadyCheck.lua:93`),
`CHAT_MSG_ADDON` (`Coach\Group.lua:470`)

**Target / mouseover**
`PLAYER_TARGET_CHANGED` (`AutoGuidance.lua:161`, `RunMarkerBar.lua:158`,
`RecognitionDiagnostic.lua:82`), `UPDATE_MOUSEOVER_UNIT`
(`AutoGuidance.lua:161`, `RecognitionDiagnostic.lua:82`),
`RAID_TARGET_UPDATE` (`Markers.lua:168`)

**Uitrusting / tassen / stats**
`PLAYER_EQUIPMENT_CHANGED` (5×), `BAG_UPDATE_DELAYED` (5×),
`PLAYERBANKSLOTS_CHANGED` (`GearGuide.lua:96`),
`UNIT_STATS` (**unit-filtered** op "player": `OptionsV3.lua:3069, 3711`),
`COMBAT_RATING_UPDATE` (`OptionsV3.lua:3070, 3711`),
`CURRENCY_DISPLAY_UPDATE` (`Coach\Upgrades.lua:618`),
`SPELL_UPDATE_COOLDOWN` (`Coach\Loot.lua:558`),
`GET_ITEM_INFO_RECEIVED` (`Coach\Week.lua:301`,
`Coach\RaidProgress.lua:357` — **pas aangezet wanneer nodig**)

**Keys / dungeon / loot**
`CHALLENGE_MODE_START`, `CHALLENGE_MODE_COMPLETED`, `CHALLENGE_MODE_RESET`
(`RunTools.lua:226`, `AutoGuidance.lua:161`),
`MYTHIC_PLUS_CURRENT_AFFIX_UPDATE` (`Coach\Learn.lua:426`),
`BONUS_ROLL_STARTED`, `BONUS_ROLL_FAILED`, `EJ_LOOT_DATA_RECIEVED`
(`Coach\BonusRoll.lua:449-451`),
`LFG_LIST_APPLICATION_STATUS_UPDATED` (`Coach\GroupTeleport.lua:180`)

**Unit-filtered (RegisterUnitEvent)**
`UNIT_STATS`/"player" (`OptionsV3.lua:3069, 3711`),
`UNIT_FLAGS`/"target" (`RunMarkerBar.lua:159`),
`UNIT_AURA`/"player" (`Coach\RaidPrep.lua:877`)

**UI**
`GLOBAL_MOUSE_DOWN` (`OptionsV3.lua:234`, alleen tijdens OnShow van een
droplist), `UPDATE_BINDINGS` (`QuickMarkUI.lua:127`),
`DISPLAY_SIZE_CHANGED`, `UI_SCALE_CHANGED` (`WindowSizing.lua:91`)

⚠️ **NIET GEVERIFIEERD tegen de client**: dat al deze events in 12.1 bestaan en
vuren zoals hun code aanneemt. Met name
`ADDON_RESTRICTION_STATE_CHANGED`, `UNIT_THREAT_SITUATION_UPDATE` en
`EJ_LOOT_DATA_RECIEVED` (let op de spelfout in Blizzards eigen eventnaam) zijn
kandidaten die MH zelf moet nameten.

### Unit-aura-lezingen
**GEMETEN**: zeer beperkt. De enige aura-lezing in de hele addon:
`Coach\RaidPrep.lua:140-144` — `C_UnitAuras.GetAuraDataByIndex("player", i,
"HELPFUL")` in een `pcall`, met een bestaanscheck op de namespace
(`:141`). Plus `RegisterUnitEvent("UNIT_AURA", "player")` (`:877`) en een
filter dat niet-player-units weggooit (`:890`).

**GEMETEN**: **geen** `UnitAura`, **geen** `AuraUtil`, **geen** `GetAuraSlots`,
**geen** `GetUnitAuraBySpellID` in de hele addon.

**AFGELEID**: zij lezen alleen de **eigen** buffs, en alleen om te checken of
een consumable actief is. Ze doen bewust geen vijandelijke aura's. Dat is
consistent met MH's eigen gemeten regel: *opsommen mag niet, gericht vragen wel*
(memory: `aura-facade-12-1.md`). Hun `GetAuraDataByIndex`-aanpak op `"player"`
is een **opsomming**, en past dus **niet** bij wat MH gemeten heeft voor
vijanden — maar voor de eigen speler mag het blijkbaar.
⚠️ **NIET GEVERIFIEERD**: of `GetAuraDataByIndex` op "player" in 12.1 ook voor
MH werkt. MH-memory zegt dat `GetAuraSlots` een **harde fout** gooit; zij
vermijden die functie.

### C_Timer en OnUpdate-loops
**GEMETEN**: ze gebruiken overwegend **OnUpdate met handmatige throttle**, niet
`C_Timer`. De loops die ik gemeten heb:

| Bestand:regel | Interval | Vroege uitstap |
|---|---|---|
| `AggroCaller.lua:1165-1192` (detector) | 0.20 s, 0.10 s als dirty | geen db, addon uit, niet in combat |
| `AggroCaller.lua:426-438` (alarmframe) | 0.10 s | editmode, niet getoond |
| `Markers.lua:183-194` (marker-badges) | 0.20 s | feature uit, geen nameplates |
| `AutoGuidance.lua:190-196` (gids-HUD) | 0.25 s | niet dirty én feature uit |
| `NativeSignals.lua:137-146` (signalen) | 0.50 s | feature uit, geen nameplates |
| `TankMode.lua` (updater, `elapsedSinceUpdate`) | 0.2 s (per `TankMode.lua:507` commentaar) | — |

**GEMETEN**: élke loop heeft een expliciete vroege uitstap die het werk tot
**nul** terugbrengt als de feature uit staat. `Markers.lua:184-187` en
`NativeSignals.lua:138-141` doen bovendien één laatste opruimronde
(`pollingActive`/`wasEnabled`) en zetten dan de teller op 0.
**GEMETEN** `Stats.lua:147-149`: `ScheduleRunMeter` is wél een uitgesteld
eenmalig iets (enkele seconden na het einde van een key).
**AFGELEID**: dit "staggered throttling" — 0.1 / 0.2 / 0.25 / 0.5 s naar
urgentie — plus de "als uit, dan echt nul werk"-regel is een direct
overneembaar performancemodel voor MH.

### Secure frames en macro-knoppen — samenvatting (GEMETEN)
| Waar | Template | Actietype |
|---|---|---|
| `Callout.lua:274-278` | `SecureActionButtonTemplate,BackdropTemplate` | `type1="macro"` + `macrotext1` (`/p` of `/i`) |
| `Markers.lua:132-138` (palet, 9 knoppen) | via `CreateFlatButton` | `type="raidtarget"`, `unit="target"`, `marker`, `action`, `shift-action` |
| `Markers.lua:206-216` (3 mouseover-binds) | `SecureActionButtonTemplate` | `*harmbutton1="markenemy"` → `type-markenemy="raidtarget"`, `unit="mouseover"` |
| `QuickMark.lua:91-102` (3 quickmark-binds) | `SecureActionButtonTemplate` | idem + `SecureHandlerWrapScript` met `SecureCmdOptionParse` |
| `RunMarkerBar.lua:71-83` (9 knoppen) | via `CreateFlatButton` | idem + wrap met `[@target,harm,nodead]` |
| `Coach\CrestConvert.lua` (bundel-opener) | `SecureActionButtonTemplate,UIPanelButtonTemplate` (`CHANGELOG.md:42`) | item gebruiken |
| `Coach\GroupTeleport.lua` | secure spell-knop, buiten combat gemaakt (`:1-8`) | teleport-spell |
| `Coach\RaidPrep.lua` | secure consumable-knoppen, buiten combat gemaakt (`CHANGELOG.md:20`) | item gebruiken |

**GEMETEN**: **`RegisterStateDriver` en `RegisterAttributeDriver` komen nergens
voor** in de hele addon. `RunMarkerBar.lua:115-116` zegt expliciet waarom:
"No UISpecialFrames, PresentWindow, state-driver churn or insecure combat
geometry changes."
**AFGELEID**: zij vermijden state drivers volledig en lossen zichtbaarheid op
met `SetShown` buiten combat + een wachtrij in combat. Dat is simpeler en
veiliger dan wat veel addons doen.

### SavedVariables-layout
**GEMETEN** `AggroCaller.toc:7`: één variabele, `AggroCallerDB`, **account-breed**
(geen per-character-variant).
**GEMETEN** `AggroCaller.lua:153-194` (`ApplyDefaults`): bij elke load wordt
`AggroCallerDB` aangevuld met `CopyDefaults` (`:137-149`, recursief, alleen
`nil`-sleutels), krijgt hij `version` en `schemaVersion` (nu 29), en wordt
`self.db` erop gezet.

Structuur zoals gemeten:
- **Plat, op topniveau**: de ~100 sleutels uit `AC.defaults`
  (`AggroCaller.lua:30-131`) — schakelaars, kleuren (`{r,g,b}`), posities
  (`{x,y}`), afmetingen, scales, cooldowns, thema.
- `specProfiles = {}` (`:52`), `roleProfiles = {}` (`:81`),
  `customThemes = {}` (`:68`), `windowScales = {}` (`:71`) — tabellen.
- `combatHistory = {}` (`:53`) — gevechtsgeschiedenis.
- `internalLog = {}` (`:54`) — begrensd op 20 (`AggroCaller.lua:708`).
- `savedLayouts[1..3]` + `previousLayout` (`AggroCaller.lua:713-714`).
- `runReports` (`AggroCaller.lua:715`) — keyrapporten, 30 per character /
  240 totaal (`CHANGELOG.md:30`).
- `quickMarkOwners` (`QuickMark.lua:34-35, 176-177`) — per account/character
  de gekozen toets; legacy `quickMarkKey` + `quickMarkBindingSet`
  (`QuickMark.lua:39-40`).
- `markerMeaning<1..8>` (`RunTools.lua:10`) — de betekenis per marker.
- **`AggroCallerDB.coach.<module>`** — een eigen subboom per Coach-module:
  `coach.groupmeter` (`Coach\GroupMeter.lua:18, 238-239`),
  `coach.group` (`Coach\Group.lua:5, 34-35`),
  `coach.craftshop.recipes` (`Coach\CraftShop.lua:9, 104-110`),
  `coach.debrief.owners` (`CHANGELOG.md:30`),
  plus `GroupTeleport`, `Learn` e.a. (`Coach\GroupTeleport.lua:27-34`,
  `Coach\Learn.lua:30-36`).

**GEMETEN** `AggroCaller.lua:151, 163` (`RETIRED_SETTINGS`): vier oude sleutels
(`chat`, `whisperTank`, `message`, `tankMessage`) worden **bij elke load
gewist**. `CHANGELOG.md:28`: `ImportSettings` accepteert ze nog in oude
exporttekst en **negeert** ze.
**GEMETEN** `AggroCaller.lua:167-174`: twee eenmalige migratievlaggen
(`autoGuideOptInInitialized`, `autoRoleInitialized`) die zorgen dat bestaande
installaties hun keuze houden.
**GEMETEN** `AggroCaller.lua:177-190`: een zeer specifieke migratie die alleen
afvuurt als **zeven** waarden exact de oude 2.6.0-defaults zijn.

**AFGELEID**: het `coach.<module>`-namespacing en de `RETIRED_SETTINGS`-lijst
zijn twee kleine, nette ideeën. MH's SV is 4 MB met oude debug-dumps (memory:
`rob-pc-performance.md`) — een `RETIRED_SETTINGS`-mechanisme zou daar helpen.
**AFGELEID (risico)**: hun SV kan groeien: 240 keyrapporten plus
`combatHistory` plus `coach.*` per module, allemaal account-breed. Zij begrenzen
expliciet (20 / 30 / 240), wat MH niet overal doet.

---

## 4. 12.x "secret values" — hoe zij ermee omgaan

### De enige directe aanroep
**GEMETEN** `AggroCaller.lua:204-206`: er is **één** `issecretvalue`-aanroep in
de hele addon, in een centrale helper `AC:IsSecret(value)`. Hij checkt eerst
`type(issecretvalue) == "function"` en geeft anders `false`. Alle andere code
gaat via die helper.
**GEMETEN**: `AC:IsSecret` wordt in **12 bestanden** gebruikt
(`AggroCaller.lua` 5×, `NativeSignals.lua` 2×, `Coach\CrestConvert.lua` 3×,
`Coach\GroupMeter.lua` 4×, en 1× in `TankMode.lua`, `Stats.lua`,
`GearGuide.lua`, `Features.lua`, `Markers.lua`, `Coach\Week.lua`,
`Coach\Upgrades.lua`). Via de lokale `Read`/`SafeCall`-wrappers bereikt hij
feitelijk de hele addon.

### Het patroon: één `Read`-wrapper per bestand
**GEMETEN**: minstens **zes** bestanden definiëren een eigen lokale wrapper met
dezelfde vorm — `Recognition.lua:10-17`, `NativeSignals.lua:5-12`,
`AutoGuidance.lua:6-13`, `Markers.lua:5-10` (`SafeCall`),
`QuickMark.lua:6-11`, `RunMarkerBar.lua:3-8`, `Stats.lua:11-12`,
`Coach\GroupMeter.lua:36-42`.
De vorm: bestaat de functie → `pcall` → secret-check → nil-check → waarde.

**GEMETEN**: twee varianten.
- **Rijk** (`Recognition.lua:10-17`, `NativeSignals.lua:5-12`,
  `AutoGuidance.lua:6-13`): geeft **waarde + reden** terug, met vijf redenen
  `api_missing` / `error` / `restricted` / `unavailable` / `readable`.
- **Arm** (`Markers.lua:5-10`, `QuickMark.lua:6-11`, `RunMarkerBar.lua:3-8`):
  geeft alleen de waarde of `nil`.

### Wat ze doen als een waarde onleesbaar is — vijf strategieën (GEMETEN)
1. **Niets tonen, en zeggen waarom.** `AutoGuidance.lua:91`: bij
   `state == "restricted"` staat er in de HUD "Identiteit verborgen door WoW.
   Bekijk de gids; er wordt geen prioriteit afgeleid."
2. **Laatst leesbare waarde vasthouden, gedimd.** `Markers.lua:38-47`: de
   markerbadge houdt de laatst gelezen marker voor diezelfde nameplate, op
   alpha 0.7; voor een vijand die **nooit** leesbaar was: niets.
3. **Doorsluizen naar een Blizzard-setter, zonder terug te lezen.**
   `NativeSignals.lua:34, 54-63`: een secret spell-id en een secret boolean
   gaan rechtstreeks naar `C_Spell.IsSpellImportant` en
   `SetAlphaFromBoolean`; de addon leest het resultaat **niet** terug en
   retourneert voor true/false/secret dezelfde string.
4. **Geen sleutel bouwen uit een onleesbare identiteit.**
   `AggroCaller.lua:220-227` (`GetCharKey`): als naam of realm secret of
   onbekend is, geeft hij `nil`, en `CHANGELOG.md:29` zegt dat de aanroeper
   zijn data dan in een **wegwerptabel** houdt in plaats van onder een
   verkeerde of gedeelde sleutel.
5. **"unknown", nooit "ok".** `Coach\PrepareLogic.lua:5-6` en
   `Coach\RaidPrep.lua:8`: een verborgen of nog niet ontvangen waarde krijgt
   de staat `"unknown"` — expliciet **nooit** `"ok"`.

### Secret-checks op velden van tabellen
**GEMETEN** `Coach\GroupMeter.lua:66-68, 102`: niet alleen de teruggegeven
tabel wordt op secret gecheckt, maar **ook** de geneste lijsten
(`session.combatSources`, `src.combatSpells`) **en** de individuele velden via
`Number`/`Bool`/`Str` (`:37-41`).
**AFGELEID**: dat is het grondigste dat ik gezien heb — een secret kan dus ook
diep in een tabel zitten.
⚠️ **NIET GEVERIFIEERD tegen de client**.

### Rol en identiteit
**GEMETEN** `AggroCaller.lua:229-241` (`GetPlayerRole`): leest
`UnitGroupRolesAssigned("player")`; als die secret is wordt het `"NONE"`; dan
pas valt hij terug op `GetSpecializationRole`, ook met secret-check. Als beide
falen: `"NONE"` — en dan draait de hele detectie niet.
**GEMETEN** `Recognition.lua:28`: zelfs het **unit-token** wordt op secret
gecheckt voordat er iets mee gebeurt.
**GEMETEN** `NativeSignals.lua:130`, `AutoGuidance.lua:166`: de `unit`-parameter
uit een event wordt op secret én op patroon (`^nameplate%d+$`) gecheckt voordat
hij als tabelsleutel wordt gebruikt.

**AFGELEID**: dit "een secret mag nooit een tabelsleutel of een vergelijking
in" is de strengste regel in hun code, en de meest overneembare. MH-memory's
"DE REGEL: opsommen mag niet, gericht vragen wel" is er het aura-equivalent van.

⚠️ **Generieke waarschuwing**: alles in dit hoofdstuk is hún **afdekking**
tegen secrets. Dat zij iets afdekken is **geen bewijs** dat die waarde in 12.1
daadwerkelijk secret is, en het ontbreken van een afdekking is geen bewijs dat
een waarde leesbaar is. Alles hier is kandidaat, niets is meting-van-de-client.

---

## 5. Combat lockdown en protected acties

### `InCombatLockdown()`
**GEMETEN**: **97 aanroepen** verspreid over **29 bestanden**. Topgebruikers:
`Editor.lua` (14), `WindowSizing.lua` (9), `Markers.lua` (6),
`Profiles.lua` (6), `OptionsV3.lua` (6), `Coach\Loot.lua` (6),
`Coach\RaidPrep.lua` (6), `Callout.lua` (5), `RunMarkerBar.lua` (5),
`Coach\CrestConvert.lua` (5), `QuickMark.lua` (4).
**GEMETEN** `AggroCaller.lua:208-212`: er is een centrale helper
`AC:IsInCombatLockdown()`, met commentaar dat die logica eerder in
`Callout.lua`, `Editor.lua` en `TankMode.lua` gedupliceerd stond.
**AFGELEID**: de helper bestaat wel, maar de meeste bestanden roepen nog direct
`InCombatLockdown()`. Inconsistent, maar functioneel gelijk.

### Vier verschillende reacties op lockdown (GEMETEN)
1. **Weigeren met een nette boodschap.**
   `Markers.lua:110-113` (`ShowMarkerPalette`) print de status en returnt
   `false`. `Markers.lua:96-97`: "EN COMBAT — gebruik het al geopende palet.
   Openen, verplaatsen en sluiten na het gevecht."
   `QuickMark.lua:47`, `QuickMark.lua:78`, `UI.lua:7-9` idem.
2. **In de wachtrij zetten en inhalen op `PLAYER_REGEN_ENABLED`.**
   `Callout.lua:146-149` zet `pendingMacroRefresh = true`;
   `Callout.lua:419-423` haalt het in.
   `RunMarkerBar.lua:119-129` zet `runMarkerBarPending` en vergelijkt de
   gewenste eindtoestand met de toegepaste, zodat er na het gevecht precies
   één keer wordt bijgewerkt.
3. **Preventief maken, buiten combat.** `Markers.lua:203, 221-223` en
   `QuickMark.lua:86, 207-209` maken de secure knoppen op `PLAYER_LOGIN` en
   opnieuw op elke `PLAYER_REGEN_ENABLED`, zodat ze er in combat gewoon zijn.
   Idem `Coach\GroupTeleport.lua` en `Coach\RaidPrep.lua`
   (`CHANGELOG.md:20, 32`).
4. **Alleen de niet-secure delen bijwerken.** `TankMode.lua:506`: de
   geometrie van de tankteller wordt alleen buiten lockdown herschikt, maar de
   **inhoud** (tekst, kleur) wel in combat — want het frame is niet protected.

### Raid markers — het antwoord op de vraag
De opdracht vraagt of ze secure `type="macro"` `/tm`-knoppen gebruiken of iets
anders, omdat `SetRaidTarget`/`PlaceRaidMarker` sinds 12.0 protected zijn.

**GEMETEN — iets anders.** Zie §2 `Markers.lua`. Samengevat:
- `SetRaidTarget` wordt **nooit** aangeroepen (0 treffers).
- `PlaceRaidMarker` komt **nergens** voor (0 treffers).
- Geen `/tm`-macrotekst. De `macrotext`-route gebruiken ze **alleen** voor chat
  (`Callout.lua:158-161`).
- Ze gebruiken het **native secure actietype `raidtarget`**
  (`Markers.lua:134`, `Markers.lua:213`, `QuickMark.lua:96`,
  `RunMarkerBar.lua:73`) met de attributen `marker` (1..8 of 0) en `action`
  (`"set"` / `"set-unmarked"` / `"clear"`), plus `shift-action` voor de
  vervang-variant.
- De unit komt uit het attribuut `unit` (`"target"` of `"mouseover"`), en voor
  de keybinds uit een `SecureHandlerWrapScript`-snippet dat
  `SecureCmdOptionParse` met `[@mouseover,harm,nodead]` evalueert
  (`QuickMark.lua:58-68`).
- `*harmbutton1="markenemy"` + `type-markenemy="raidtarget"` maakt dat de actie
  alleen op een vijandig doel bestaat (`Markers.lua:212-213`).
- `Markers.lua:88-89`: harde regel in commentaar — nooit markeren vanuit scans,
  slashcommando's of insecure callbacks.
- `Markers.lua:99-101`, `RunMarkerBar.lua:23-24`: in een **raid** wordt er
  vooraf gecontroleerd op `UnitIsGroupLeader` / `UnitIsGroupAssistant` en de
  UI zegt dat je rechten mist.

⚠️ **NIET GEVERIFIEERD tegen de client**: dat `type="raidtarget"` met deze
`action`-waarden in 12.1 werkt is hún code — een **kandidaat** voor MH, geen
bewijs. MH moet dit in het spel meten.

### Frames tonen en verplaatsen in combat
**GEMETEN** — drie verschillende regimes, naar of het frame protected is:
- **Niet-secure overlays (nameplate-badges, HUD's, tankteller)**: parent
  `UIParent`, cross-anchored naar de nameplate (`TankMode.lua:353-357`,
  `Markers.lua:52`, `AutoGuidance.lua:118`, `NativeSignals.lua:67`). Deze
  worden vrij gemaakt, getoond en verankerd, **ook in combat** — er is geen
  lockdown-check in `UpdateBadge`/`Update`.
- **Frames met secure kinderen (markerpalet, run-balk)**: niets in combat.
  `RunMarkerBar.lua:115-117` noemt expliciet: geen `UISpecialFrames`, geen
  `PresentWindow`, geen state-driver-churn, geen insecure combat-geometrie.
  `Markers.lua:160`: geen protected ancestor in `UISpecialFrames`, want
  Escape gebruikt een insecure `Hide()`.
- **Slepen**: altijd achter een lockdown-check —
  `Markers.lua:118-119`, `RunMarkerBar.lua:46, 49`, `TankMode.lua:479`,
  `AggroCaller.lua:408-412` (alleen in editmode).

**GEMETEN** `RunMarkerBar.lua:42-44`: de sleepzone is een **apart** frame over
alleen de koptekst, zodat hij nooit over de markerknoppen ligt.
**AFGELEID**: dat is een goed detail — een sleepbaar protected frame zou de
secure klikzones kunnen opeten.

### `RegisterStateDriver`
**GEMETEN**: **nul** aanroepen van `RegisterStateDriver` of
`RegisterAttributeDriver` in de hele addon. Zichtbaarheid gaat via `SetShown`
buiten combat plus een wachtrij in combat (`RunMarkerBar.lua:139-141` vs.
`:121-128`).

### `hooksecurefunc`
**GEMETEN**: **5** aanroepen, allemaal defensief.
- `UI.lua:403`: op `frame.SetScale` van een eigen frame.
- `OptionsV3.lua:2835-2836`: op `ChatEdit_InsertLink` **en**
  `ChatFrameUtil.InsertLink` — oud en nieuw pad, elk achter een
  `type(...) == "function"`-check.
- `Coach\BonusRoll.lua:439-441`: op `BonusRollFrame_StartBonusRoll`, achter een
  check dat `hooksecurefunc`, `BonusRollFrame` **en** de functie bestaan.
**AFGELEID**: geen enkele hook op een Blizzard-functie die in combat vuurt;
daarmee is het taintrisico klein.

---

## 6. Waar de data vandaan komt, en hoe vers die is

### Wat README / GUIDE_SOURCES / CHANGELOG beweren
**GEMETEN** `README.md:1-19`: de README is **in het Frans** en zegt
"AggroCaller 3.0.0" — terwijl de .toc 4.3.1 zegt. Hij noemt vijf
slashcommando's en een "Nouveautés 3.0".
**AFGELEID**: de README is **stale** (3.0.0 vs. 4.3.1, en hij noemt de
rename naar "Vanguard" niet). De `CHANGELOG.md` is wél bijgewerkt
(`CHANGELOG.md:1` = "Vanguard 4.3.1 — Rename"). De README is dus het enige
duidelijk verouderde document.

**GEMETEN** `GUIDE_SOURCES.md` — twee gelaagde documenten in één bestand:
- `:1-18` een review van **2026-09-28** voor versie 2.26.0: acht
  Petko/Icy-Veins-pagina's herlezen voor de 32 bestaande fiches plus acht
  nieuwe. De bronpagina's tonen zelf "mise à jour du 11 août 2026".
  Letterlijk: "**Pas de validation en jeu**, ni de garantie contre les
  correctifs postérieurs aux guides."
- `:5-15` een tabel met de acht nieuwe fiches, per dungeon, mét de **sectie**
  van de bron waar ze uit komen ("Notable Trash before …").
- `:16`: de acht toevoegingen staan in `manualTips`, **gescheiden** van de
  id's die de herkenning gebruikt. Expliciet: "Le total de 40 fiches ne
  signifie pas 40 ennemis reconnus automatiquement."
- `:22-31` het oudere 2.14.0-document: Midnight Seizoen 2, patch 12.1, bronnen
  geraadpleegd 2026-09-22, 32 fiches (4 per dungeon). Letterlijk: dit dekt
  **niet** alle vijanden, pulls, routes of bosses; de tips zijn **geen**
  automatische rangorde; EN-namen zijn bewaard; **geen npc- of spell-id is
  verzonnen**; "« Documenté » signifie appuyé par un guide publié, et non
  testé en jeu par nos soins."
- `:36-43` de acht Icy-Veins-URL's.
- `:45-48` kruiscontrole-bronnen: Weber's WoW Guides (eigen datum 2026-09-08),
  de Icy-Veins-dungeonrotatie (om de lijst van acht te checken), en Blizzards
  hotfix-nieuws van 2026-09-02 als officiële referentie — met de kanttekening
  dat de consultatiedatum **niet** betekent dat Blizzard hun advies bevestigt.
- `:50-54` **een bewaard meningsverschil**: voor Lightgorged Lasher /
  Lightbloom Pollination zegt Icy Veins "interrumperen" en Weber "schild
  stukslaan". De fiche krijgt daarom de categorie "À confirmer en jeu" en
  schrijft **geen** enkel antwoord voor. Ambigue route-adviezen en
  spell-koppelingen zijn uitgesloten.
- `:56-60` onderhoudsinstructie: na een hotfix de betrokken fiches vergelijken,
  **in het spel** controleren, en de datum pas bijwerken na een nieuwe
  verificatie. Plus: "Le guide fonctionne hors ligne : ses sources et
  recommandations ne se mettent pas à jour automatiquement."

**AFGELEID — dit is het beste niet-technische idee in de hele addon.** Ze
documenteren niet alleen de bron, maar ook de **grens van de bewering**
("gedocumenteerd ≠ in het spel getest"), de **dekking** ("32 fiches ≠ 32
herkende vijanden"), en ze **bewaren een meningsverschil** in plaats van er
een winnaar van te maken. Precies MH's memory `one-option-shown-as-the-answer.md`
("noem álle opties, noem de as") en `never-assume-always-factcheck.md`
("zeg per bewering GEMETEN of AFGELEID"). Dit is een model voor hoe MH's
tip-audits (`instance-tips-audit-2026-09-14.md`) hun resultaat kunnen
vastleggen.

### Hardcoded tabellen vs. gescrapete gidsen vs. live spel
**GEMETEN** — drie duidelijk gescheiden lagen:

**(a) Hardcoded, handmatig geverifieerd tegen een geïnstalleerde addon**
- `DungeonIdentity.lua:2-13`: 8 dungeons, `challengeMap`, `zones`, 4 npc-id's
  elk — "checked against installed MDT 6.2.19 on 2026-09-23".
- `DungeonNames.lua:2`: exacte npc-namen, zelfde bron en datum.
- `DungeonGuideData.lua:3-9`: de 32 fiches, met per dungeon `checked` en
  `sourceUpdated`.

**(b) Gegenereerd uit webbronnen door eigen tooling**
- `GearData.lua:1-4`: Wowhead BiS + Murlok.io, `checked = "2026-09-30"`,
  gegenereerd door `tools/gear`.
- `SpecGuideData.lua:1-8`: Wowhead "enchants-gems" + "talent-builds" +
  Murlok.io top-50, `checked = "2026-09-30"`, door `guidelua.py`.
- `Coach\InterruptData.lua:1-9`: Wowhead-tooltips
  (`nether.wowhead.com/tooltip/spell/<id>?locale=2|0`) plus de
  talentcalculator-data (`nether.wowhead.com/data/talents-dragonflight`,
  velden `abilities` en `shownForSpecs`), **2026-09-30**.
- `Coach\RaidGroupData.lua:1-8`: zelfde bronnen, **2026-10-02**, door
  `raidgroup.py`, "ne pas modifier à la main".
- `Coach\UpgradeData.lua:2-7` en `Coach\CrestConvert.lua:18-36`: Wowhead
  dawncrest-gids (`guideUpdated = "2026-08-13"`), `checked = "2026-09-30"`.
- `Coach\LootData.lua` + `CHANGELOG.md:65`: Adventure-Guide-loot + item-levels
  per keylevel, "generated by `tools/gear/loot*`".
- `Coach\CraftShop.lua:18, 67-70`: Wowhead-reagentia voor 19 recepten,
  `checked = "2026-09-30"` en `2026-10-01`.

**(c) Live uit het spel — hun eigen voorkeur**
- `Coach\RaidBosses.lua:1-8`: **alle** bosstekst komt uit de Avonturengids
  (`EJ_GetEncounterInfo`, `C_EncounterJournal.GetSectionInfo`,
  `GetSectionIconFlags`). "nothing is written by the add-on."
- `Coach\RaidBossData.lua:1-8`: de iconflag-indexen zijn **bitposities van
  `Enum.JournalEncounterIconFlags`**, gelezen uit het spel, "never numbers of
  ours".
- `GearData.lua:14`: de eigen gelokaliseerde zonenaam van het spel heeft
  voorrang boven hun fallbacktabel.
- `Coach\Week.lua:1-8`: "Aucune table de niveaux d'objet recopiée, aucune
  projection de score."
- `Coach\Upgrades.lua:1-9`: crests, track en high watermark allemaal live.

**GEMETEN**: ze noteren consequent ook de **API-bron**:
`github.com/Gethe/wow-ui-source` met **commit-hash en datum** —
`Coach\RaidProgress.lua:9` ("live, commit 09b9db7"),
`Coach\RaidBosses.lua:11`, `Coach\Loot.lua:10`,
`Coach\GroupMeter.lua:13-17` (met de precieze documentatiebestanden),
`Coach\Keys.lua:582` ("commit 09b9db7", checked 2026-09-22),
`Coach\CraftShop.lua:70`. En een lib-bron met commit:
`Coach\Keys.lua:581` ("LibKeystone v11 … commit 19801e6", checked 2026-09-19).
En `Coach\DungeonCoverage.lua:35-39`: warcraft.wiki.gg met URL en datum
2026-10-02.
**GEMETEN** `MenuKit.lua:135`: die bronlijsten worden **in de UI** getoond via
een `SetSources{ {label, url, checked}, … }`-component.

**AFGELEID**: "API-feiten tegen een vastgepinde wow-ui-source-commit, met
datum, en de bron in de UI" is strakker dan wat MH nu doet. MH-memory
`wago-tools-gamedata.md` noemt wago.tools als hardste bron met buildnummer —
dat is het equivalent, maar wij zetten het niet in de UI.

### Hoe stale ziet het eruit?
**GEMETEN** — de data is **zeer vers**:
- `DungeonIdentity.lua` / `DungeonNames.lua`: 2026-09-23
- `DungeonGuideData.lua`: `checked` 2026-09-28, `sourceUpdated` 2026-08-11
- `GearData.lua` / `SpecGuideData.lua` / `InterruptData.lua` /
  `UpgradeData.lua` / `CrestConvert.lua` / `BonusRoll.lua`: 2026-09-30
- `CraftShop.lua`: 2026-09-30 en 2026-10-01
- `RaidGroupData.lua` / `RaidBossData.lua` / `DungeonCoverage.lua`: 2026-10-02
- Vandaag is 2026-10-03. **De oudste data is 10 dagen oud, de nieuwste 1 dag.**

**GEMETEN** — **11.x-resten: geen.** Ik heb gegrepeerd op `11.`, `110xxx`,
`The War Within`, `TWW` en `Interface: 1[01]`. De enige treffers waren hun
eigen **addonversies** 2.11.0 / 2.11.1 / 2.11.2 in `ReleaseNotes.lua:217-223`.
Er is geen tweede TOC, geen 11.x-interfaceversie, en geen TWW-data.
**GEMETEN**: élke datatabel draagt `patch = "12.1"` en
`season = "Midnight S2"`.
**GEMETEN** `AutoGuidance.lua:25-26`: de tactiek-HUD **zet zichzelf uit** als
`GetBuildInfo()` niet met `12.1.` begint.
**AFGELEID**: dit is de schoonste staleness-situatie die ik in een
onderzochte addon heb gezien. Geen enkele 11.x-rest, en een ingebouwde
patch-gate.

**GEMETEN** één inconsistentie: `AutoGuidance.lua:101, 136` en
`AggroCaller.lua:716` zeggen nog "32 fiches" / "4 identifiants vérifiés",
terwijl `GUIDE_SOURCES.md:16` het totaal op **40** zet (32 + 8 handmatige).
**AFGELEID**: de UI-tekst loopt één stap achter op de data. Klein, maar het is
precies het soort drift waar MH's content-wachter op zou moeten letten.

---

## 7. Localisatie

**GEMETEN** `Locales.lua` (25 KB): **twee** talen, en niet meer.
- `Locales.lua:3`: een `EN`-tabel met platte sleutel→string-paren
  (`TANK_COUNTER_HELD`, `DIAG_DISABLED`, …), tot `Locales.lua:440`.
- Daarna een `FR`-tabel (gemeten via `Locales.lua:251`, een FR-variant van
  `DIAG_PLATES_OFF`).
- `Locales.lua:444`: `AC.L = {}` — **één** tabel, met commentaar
  `:443` dat modules `AC.L` lokaal vasthouden voordat SavedVariables geladen
  zijn.
- `Locales.lua:445-454` (`InitializeLocale`): accepteert `"frFR"`, `"enUS"` of
  `"auto"`. Bij `"auto"` wordt `GetLocale()` gelezen en is alleen `frFR`
  bijzonder — **elke andere client krijgt Engels**. Daarna wordt `AC.L`
  geleegd en opnieuw gevuld met `source[key] or value`, dus **EN is altijd de
  fallback per sleutel**.
- `Locales.lua:452-453`: zet ook `BINDING_HEADER_AGGROCALLER` en
  `BINDING_NAME_AGGROCALLER_CALLOUT` — de keybind-namen zijn dus ook vertaald.
- `Locales.lua:455`: `InitializeLocale("auto")` wordt direct bij het laden
  aangeroepen, zodat `AC.L` bestaat voordat enig ander bestand laadt.
- **GEMETEN** `AggroCaller.lua:155-156`: de keuze wordt uit
  `AggroCallerDB.language` gelezen (`"auto"`/`"frFR"`/`"enUS"`) en gevalideerd;
  alles anders wordt `"auto"`.

**GEMETEN** — een **tweede**, parallel vertaalmechanisme voor de featurefiles:
bijna elk bestand definieert bovenaan een eigen
`local function T(fr, en) return AC.locale == "frFR" and fr or en end`
(gemeten in `Markers.lua:4`, `QuickMark.lua:2`, `RunMarkerBar.lua:2`,
`AutoGuidance.lua:4`, `NativeSignals.lua:4`, `Recognition.lua`,
`RecognitionDiagnostic.lua:2`, `Editor.lua:3`, `RunTools.lua:2`,
`Experience.lua:2`, `Dimensions.lua:2`, `WindowSizing.lua:2`,
`OptionsV3.lua:5`, `GearGuide.lua:6`, `DungeonGuide.lua:4`, `Stats.lua:6`).
`MenuKit.lua` exporteert er een gedeelde versie van als `UI.T`
(`Coach\Prepare.lua:6`).
**AFGELEID**: dus twee systemen naast elkaar — een sleutelgebaseerde tabel voor
de kern, en inline FR/EN-paren in de featurefiles. Dat is pragmatisch maar het
betekent dat een derde taal **honderden** inline aanroepsites zou raken, niet
één tabel.

**GEMETEN** — de **data** is óók tweetalig, met dezelfde vorm
`{frFR = …, enUS = …}`: `DungeonGuideData.lua:4-9` (`reason`, `action`),
`GearData.lua:16-25` (zonenamen), `GearGuide.lua:132`
(beroepsnamen), `SpecGuideData.lua:787-791` (labels),
`SpecGuideData.lua:1395` (itemnamen), `RunTools.lua:5-7`
(markerlabels), `AutoGuidance.lua:14-19` (categorieën),
`DungeonGuide.lua:6-12` (categorielabels), `RecognitionDiagnostic.lua:3-13`
(diagnose-labels als `{fr, en}`-paren),
`ReleaseNotes.lua:163-202` (releasenotes).
**GEMETEN** `AutoGuidance.lua:5`, `DungeonGuide.lua:5`, `GearGuide.lua:7`:
een `Localized(value)` / `Loc(t)`-helper met `value[AC.locale] or value.enUS`.

**AFGELEID**: de addon is **Frans-eerst** gebouwd (auteur TripleX, Franse
README, Franse commentaren in het hele Coach-deel) met Engels als tweede taal
en als universele fallback. Vergelijk MH: **7** talen via losse packs
(memory: `machine-translated-packs.md`, `locale-packs-gated-by-client.md`).
AggroCaller's model is veel simpeler maar niet schaalbaar; MH's model is
schaalbaarder maar heeft kwaliteitsproblemen. Niets om over te nemen, behalve
één detail: **het `{frFR=…, enUS=…}`-paar direct in de datarij**, zodat tekst en
feit nooit uit elkaar lopen. Dat is netter dan een aparte stringtabel met id's.

---

## 8. Performance, taint en risico's

### Wat er goed is (en overneembaar)
1. **GEMETEN** — **nul CLEU.** Zie §3. De grootste structurele winst.
2. **GEMETEN** — event-dirty-flag i.p.v. werk-in-de-handler
   (`AggroCaller.lua:1149-1160`). Hoogfrequente events zetten een vlag; een
   vaste throttle doet het werk.
3. **GEMETEN** — gelaagde throttles naar urgentie: 0.10 / 0.20 / 0.25 / 0.50 s
   (§3), elk met een vroege uitstap naar **nul** werk.
4. **GEMETEN** — tabel-hergebruik i.p.v. hergebruik-door-allocatie
   (`AggroCaller.lua:783-784, 811-813`). `CHANGELOG.md:13` claimt
   **1458 → 41 KB/min** gemeten met een eigen `test_perf.lua`.
5. **GEMETEN** — vooraf gebouwde unit-tokenlijsten (`AggroCaller.lua:780-782`).
6. **GEMETEN** — alleen herschrijven bij verandering: `Markers.lua:65, 76-81`,
   `NativeSignals.lua:97-101`, `AutoGuidance.lua:83, 123`,
   `RunMarkerBar.lua:30` vergelijken eerst de nieuwe waarde met de toegepaste
   en doen anders niets. `CHANGELOG.md:202`: "Rendering updates limited to
   changes; scans stop when features are disabled or no plates are tracked."
   `TankMode.lua:507-508` noemt dit expliciet GC-churn.
7. **GEMETEN** — `MenuKit.lua:3-4`: componenten worden **één keer** gemaakt en
   daarna met setters bijgewerkt; "nothing here creates a texture or a mask on
   refresh". Idem `Coach\Prepare.lua:3`, `Coach\Learn.lua:4-5`.
8. **GEMETEN** — zelfmeting met `debugprofilestop()` in buckets
   (`AggroCaller.lua:444-448, 1187-1191`, `Systems.lua:250-292`), zichtbaar in
   de diagnose (`AggroCaller.lua:707`).
9. **GEMETEN** — `RegisterUnitEvent` waar maar één unit telt
   (`OptionsV3.lua:3069`, `RunMarkerBar.lua:159`, `Coach\RaidPrep.lua:877`).
10. **GEMETEN** — alles in `pcall`, overal, en bestaanschecks op namespaces
    voordat ze gebruikt worden (`NativeSignals.lua:47`,
    `Coach\GroupMeter.lua:54-55`, `Coach\CrestConvert.lua:158`).
11. **GEMETEN** — een **taint-monitor** (`Systems.lua:519-529`) die
    `ADDON_ACTION_BLOCKED`/`FORBIDDEN` voor zichzelf logt.
12. **GEMETEN** — offline testbaarheid: `CHANGELOG.md:90` noemt
    `tools/check/upvalues.sh` (Lua 5.1-syntax, 60-upvalue-limiet, globals),
    `test_gear.lua`, en `smoke_ui.lua` dat "loads the whole .toc with a fake
    WoW API and lays out every Gear tab". Plus per feature een test
    (`test_prepare.lua`, `test_raidprep.lua`, `test_api.lua`,
    `test_specinfo.lua`, `test_groupteleport.lua`, `test_perf.lua`).
13. **GEMETEN** — `CHANGELOG.md:988`: een statische scan (check #8) die
    `CreateFontString` zonder fonttemplate opspoort waar `SetText` vóór
    `SetFont` komt, "so this bug class cannot come back silently".

### Wat zwaar, taintgevoelig of tegen onze regels is
1. **AFGELEID (zwaar)** — **vijf** gelijktijdige OnUpdate-loops op
   nameplate-sets (detector 0.2 s, markers 0.2 s, autoguide 0.25 s,
   nativesignals 0.5 s, tankmode 0.2 s). Elke loop doet zijn eigen
   `GetNamePlateForUnit` + `IsShown` per unit. Bij 40 nameplates is dat veel
   dubbel werk. Ze mitigeren het met de "feature uit → nul"-uitstap, maar met
   alles aan is de bovengrens hoog.
2. **AFGELEID (zwaar)** — `GatherAggroInfo` doet per scan tot ~47 pcalls
   (`UnitThreatSituation`) plus per treffer een `UnitGUID` en soms een
   `UnitName`. Bij 10 Hz is dat ~470 pcalls/s in een grote pull. `pcall` is
   niet gratis. Hun eigen commentaar
   (`AggroCaller.lua:430-433`) geeft toe dat dit eerder 60 Hz was.
3. **AFGELEID (risico)** — `OptionsV3.lua` is **318 KB in één bestand** en
   `CHANGELOG.md` **121 KB**. De CHANGELOG wordt niet geladen, maar
   `OptionsV3.lua` wel, en `ReleaseNotes.lua` (46 KB) houdt de volledige
   versiegeschiedenis **in geheugen**. Samen met `GearData.lua` (118 KB) en
   `SpecGuideData.lua` (135 KB) is dat ~620 KB aan Lua-tabellen bij elke load,
   voor data die de meeste spelers nooit opvragen. Geen lazy loading, geen
   `## LoadOnDemand`-splitsing.
4. **AFGELEID (risico)** — één **account-brede** SavedVariables met
   `combatHistory`, `internalLog`, `runReports` (240), `savedLayouts` en een
   `coach.*`-boom per module. Zij begrenzen expliciet, maar het is wel het
   patroon dat MH's SV naar 4 MB bracht.
5. **GEMETEN (taint, historisch)** — `CHANGELOG.md:984-988`: vier
   `FontString:SetText(): Font not set` **taint**-fouten uit
   `CreateAlertFrame` (`AggroCaller.lua:266`), omdat een badge `SetText("!")`
   kreeg voordat er een font was. Opgelost door alle font strings een
   Blizzard-template te laten erven bij creatie, plus de statische scan (#13
   hierboven). **AFGELEID**: dit is een reële taintklasse die MH ook kan
   raken — font vóór tekst.
6. **AFGELEID (taint)** — `Markers.lua:160` en `RunMarkerBar.lua:115-117` zijn
   waarschuwingen uit ervaring: een frame met secure kinderen is zelf
   protected, en Escape (`UISpecialFrames`) gebruikt een insecure `Hide()`.
   Wie dat mist, krijgt in combat blokkades.
7. **AFGELEID (tegen onze regels)** — `QuickMark.lua:126-192` **schrijft de
   keybinds van de speler** (`SetBindingClick`, `SetBinding`, `SaveBindings`).
   MH-memory `keybind-scheme-v7-direction.md` zegt expliciet: *"de addon zet
   GEEN binds"*. Hun uitvoering is zorgvuldig (expliciete klik,
   conflictweigering, volledige rollback), maar het **idee** botst met onze
   eigen keuze. Dit is het enige punt waar ik zou zeggen: niet overnemen zonder
   dat Rob die keuze heroverweegt.
8. **AFGELEID (tegen onze regels)** — `Systems.lua:553-564` leest
   `_G._EBS_CachedAddonButtons`, een **privé** globale van EllesmereUI. Dat is
   een afhankelijkheid van een ongedocumenteerd intern detail van een andere
   addon; het breekt zodra die addon wijzigt. `CHANGELOG.md:1192` noemt zelfs
   "Preserved safe EllesmereUI accent-color and font synchronization". MH-memory
   zegt dat Rob EllesmereUI niet gebruikt — dus voor ons dubbel irrelevant én
   een voorbeeld van wat **niet** te doen.
9. **AFGELEID (onderhoud)** — twee vertaalmechanismen naast elkaar (§7). Een
   derde taal raakt honderden inline `T(fr, en)`-aanroepen.
10. **AFGELEID (drift)** — de UI zegt "32 fiches" waar de data 40 zegt (§6), en
    de README zegt 3.0.0 waar de .toc 4.3.1 zegt. Twee kleine
    documentatie-drifts.
11. **GEMETEN (licentiegat)** — de 4 mp3's in `Sounds\` hebben geen
    herkomstvermelding (§0), terwijl de fonts en iconen die wél hebben.

### Eén harde, direct bruikbare feitelijke vondst
**GEMETEN** `SpecInfo.lua:2-12`: de globals `GetSpecialization`,
`GetSpecializationInfo`, `GetNumSpecializationsForClassID` en
`GetInspectSpecialization` zijn in Midnight **alleen nog deprecated aliassen**.
Blizzard definieert ze in `Blizzard_DeprecatedSpecialization` en
`Blizzard_Deprecated` (`Deprecated_12_1_0.lua`) **achter de instelling
`loadDeprecationFallbacks`**, en zal ze bij de volgende uitbreiding verwijderen.
Hun oplossing: één bestand met helpers die **`C_SpecializationInfo` eerst**
proberen (zelfde argumenten, zelfde returns, gecheckt in wow-ui-source
`SpecializationInfoDocumentation.lua` 12.1.0) en op de oude globals terugvallen;
de functie wordt **bij elke aanroep** opgezocht, en met geen van beide
beschikbaar retourneren ze niets, net als een ontbrekende global.
**GEMETEN** `CHANGELOG.md:31`: 17 aanroepsites namen die helpers als
file-locals, en `test_specinfo.lua` **verwijdert de globals** om te bewijzen dat
het zonder werkt.

⚠️ **NIET GEVERIFIEERD tegen de client** — maar dit is een concrete,
nameetbare bewering met een exacte vindplaats. **Als** het klopt, raakt het MH
overal waar wij `GetSpecialization()` gebruiken, en is het stil kapot zodra een
speler `loadDeprecationFallbacks` uit heeft. Dit is naar mijn inschatting de
hoogste-prioriteit meetopdracht uit deze analyse, naast `C_DamageMeter`.

---

## 9. Samenvatting: de ideeën die het waard zijn (ideeën, geen code)

In volgorde van waarde voor MH.

1. **Geen CLEU nodig.** Een complete aggro/tank/marker/stats-addon zonder
   `COMBAT_LOG_EVENT_UNFILTERED`; nabeschouwing via `C_DamageMeter` /
   `C_DeathRecap` ná het gevecht. Raakt MH's open CLEU-taint-vraag én het
   death-recap-plan. **Meet `C_DamageMeter` eerst.**
2. **`GetDetectionReason`-patroon** (`Features.lua:29-49`). Eén functie die in
   gewone taal altijd kan zeggen waarom een feature nu stil is, met 12
   onderscheiden redenen. Past exact op MH's "uitleggen is onze kracht".
3. **Tel je leesbaarheid en laat het zien** (`AggroCaller.lua:760-769`,
   `Experience.lua:76`). Sla naast elke meting op hoeveel reads lukten en
   hoeveel niet, en laat de UI "geen leesbare data / gedeeltelijk / leesbare
   steekproeven" zeggen. Dit is "stilte is geen afwezigheid", uitvoerbaar.
4. **Secret-passthrough naar een Blizzard-setter** (`NativeSignals.lua:34,
   54-63`). Een onleesbare waarde aan een setter geven die secrets accepteert,
   nooit terugleggen, en voor true/false/secret hetzelfde retourneren.
5. **Laatst-leesbare-waarde, gedimd, nooit iets verzinnen**
   (`Markers.lua:38-47`). Het beste 3-toestanden-UI-patroon dat ik zag.
6. **Native secure actietype voor markers** (`Markers.lua:134, 213`) i.p.v.
   `SetRaidTarget` of `/tm`-macro's. Kandidaat, moet gemeten worden.
7. **Macro-condities binnen de secure omgeving** (`QuickMark.lua:58-68`):
   `SecureHandlerWrapScript` + `SecureCmdOptionParse` met
   `[@mouseover,harm,nodead]`, zodat een keybind op "de vijand onder mijn muis"
   werkt zonder zijn identiteit te lezen.
8. **`SpecInfo.lua`-feit**: `GetSpecialization` c.s. zijn deprecated aliassen
   achter `loadDeprecationFallbacks`. Nameten; raakt MH breed.
9. **Een recognition-diagnosevenster** (`RecognitionDiagnostic.lua`) dat per
   veld zegt: exploitable / protégé / absent / API absente / erreur / format
   invalide / ambigu / taal niet gedekt.
10. **Bronvermelding als UI-component** (`MenuKit.lua:135`): per kaart
    `{label, url, checked}`, zichtbaar voor de speler.
11. **Data draagt haar eigen datum én de datum van de bron**
    (`DungeonGuideData.lua:4`: `checked` + `sourceUpdated`), per fiche in plaats
    van per bestand.
12. **Bewaar een meningsverschil in plaats van het te beslechten**
    (`GUIDE_SOURCES.md:50-54`, `review = "disputed"`,
    `AutoGuidance.lua:112` geeft zo'n fiche geen badge).
13. **Patch-gate op de data** (`AutoGuidance.lua:25-26`): de feature zet
    zichzelf uit als `GetBuildInfo()` niet `12.1.` is.
14. **Scheiding logica/UI met offline tests** (`PrepareLogic.lua` naast
    `Prepare.lua`, `test_prepare.lua`).
15. **Event-dirty-flag + gelaagde throttles** (0.1/0.2/0.25/0.5 s) met een
    vroege uitstap naar nul werk.
16. **Keybind-transactie met rollback** (`QuickMark.lua:126-153`) — als MH ooit
    binds zou zetten, zo. Botst nu met onze eigen regel.
17. **Taint-monitor voor jezelf** (`Systems.lua:519-529`).
18. **`RETIRED_SETTINGS`** (`AggroCaller.lua:151, 163`): oude SV-sleutels bij
    elke load wissen, en in import negeren.
19. **Eén `dimensionDefs`-tabel** (`Dimensions.lua:3-9`) als enige waarheid over
    afmetingen en hun grenzen.
20. **In-game release notes met rang per punt** (`ReleaseNotes.lua`).

### Wat niet overnemen
- Het **zetten** van keybinds (botst met MH's eigen regel).
- Het lezen van `_G._EBS_CachedAddonButtons` (privé global van een andere addon).
- Twee parallelle vertaalmechanismen.
- ~620 KB datatabellen zonder lazy loading.

**Nogmaals: wij nemen IDEEËN over, geen code.** Dit rapport bevat geen
overgenomen code en geen "port dit bestand"-advies. De licentie in de map is
MIT (§0), maar die conclusie is aan Rob, niet aan dit rapport.
