# Testlijst — wat wacht er op Rob

📱 **Deze lijst staat ook als afvinkpagina op Robs telefoon:**
<https://claude.ai/artifact/2SbQS4EfWH1BCxDuHut2C4> (21 sep 2026, 20 open punten na de tweede verhuizing).
Bouwen/bijwerken: `python tools/_probe.py run testlist_page`, daarna de Artifact-tool met die URL
(`capabilities {db:{}}`). Robs vinkjes en notities staan in de db van die pagina, in `state/checks`;
deze markdown blijft de bron — de pagina wordt eruit gegenereerd, nooit andersom.
**Vinkjes terugzetten** (16 sep, Rob: *"zijn er wel heel veel"*): lees `state/checks`, zet de id's met
`"s":"ok"` in een bestand, en `python tools/_probe.py run testlist_page apply <bestand> "<wie, datum>"`.
Dat zet ze hier op `[x]` en bouwt de pagina opnieuw; een "niet goed" blijft open. De pagina opent
standaard op *Nieuwste* (de twee jongste datums in de koppen).

**Lopende lijst.** Rob, 27 aug 2026: *"we gaan later alles proberen, onthoud dit en dan maken
we straks een lijstje wat ik in een keer kan testen"*. Alles wat gebouwd maar niet in het spel
gezien is, komt hier te staan tot hij het afvinkt.

⚠️ **Bouwen is niet testen.** Een module die laadt zonder foutmelding heeft alleen bewezen dat
hij laadt. Zet niets hieronder op ✅ omdat het "zou moeten werken".

📦 **Oudere rondes staan in [`TESTLIJST_ARCHIEF.md`](TESTLIJST_ARCHIEF.md)** (afgesplitst 17 sep 2026,
op Robs verzoek; 21 sep volgden de rondes van 16 en 17 sep). Deze lijst houdt de jongste testrondes;
er is niets weggegooid.

## 🆕 10 okt — controle van alle specs (docs/SPEC_AUDIT_2026-10-10/): wat jij kunt zien

Ongeveer 25 fouten gerepareerd tegen Blizzards speldata; niets daarvan in het spel gezien. Alleen wat je character heeft:
- [ ] Warlockie: roep een Felhunter op, stuur hem weg, `/reload`. De knop biedt nu de Felhunter (je laatste demon).
- [ ] Een Holy Paladin (als je die hebt): geen Rebuke-macro meer; met Beacon of Virtue geen "Beacon of Light"-melding.
- [ ] Een Frost DK met Breath of Sindragosa: die staat nu NIET grijs op de kaart en wel in de toolkit.
- [ ] Een Shaman: Flame Shock niet meer grijs op de kaart; Enhancement vraagt Flametongue op het linker wapen.
- [ ] Heb je een character dat niet hier staat: open de Zo-speel-je-kaart en zeg het als iets grijs staat dat je wél hebt.

## 🆕 10 okt — beroepen: bij elke node staat nu op welk tab hij zit (Profession.lua + ProfessionAcademy.lua)

- [ ] Op je Jewelcrafter met punten over: Tools > Professions. Onder "Individual nodes…" staat nu bv.
      "Calculated Concentration (0/30) - tab Thoughtful Throughput, opens once Thoughtful Throughput has points".
      Klopt dat tab als je het in het spel opent? En staan de nodes die je NU kunt kopen bovenaan?
- [ ] Rob 10 okt GEMETEN: 5 punten in Thoughtful Throughput openen Calculated Concentration, de andere twee blijven
      dicht. Nu moet MH zeggen "Thoughtful Throughput has 5 points: the next choice in this tab is open…", met
      Calculated Concentration zonder "not open yet" en de andere twee mét "not open yet".

## 🆕 10 okt — Demonology: pet-knop roept Felguard op i.p.v. Imp (MissingBuff.lua)

- [x] ✅ Rob 10 okt: Warlockie (Demonology) krijgt nu de Felguard.
- [ ] Zelfde soort fout, ook gerepareerd: Warrior zonder stance → Arms ziet Battle Stance, Fury Berserker Stance,
      Prot Defensive Stance. Rogue zonder gif → Assassination ziet Deadly Poison (Outlaw/Sub blijven Instant).
      (Heb je zo'n character: stance/gif uit, `/reload`, kijk welke knop er staat.)

## 🆕 10 okt — meten voor de Knowledge-teller en de Death Recap-les (`/mh kp weekly`, `/mh death`)

- [ ] Typ `/mh kp weekly` (NIET `/mh kp`: dat is een andere meting) en `/reload`. Haal je deze week nog een treatise
      of een Knowledge-drop? Doe dan direct daarna nog eens `/mh kp weekly`: een regel die van "none" naar een getal
      gaat is precies wat ik zoek.
- [x] ✅ Rob 10 okt: val van een klif buiten een instance → recap leesbaar, 0 geheime velden.
- [ ] Nog een keer, maar dan door een **vijand in een dungeon of delve**: `/mh death`, `/reload`. Daar zit de spell
      en de naam van wie je raakte in, en Blizzard is daar strenger.
- [ ] Klik bij dat sterven op het MH-kaartje met de schedel: opent Blizzards Death Recap nu wél het venster?

## 🆕 10 okt — healer-cooldowns: Celestial Conduit en Tip the Scales (HealerCooldowns.lua)

- [ ] Op een Mistweaver met de hero-talenten Conduit of the Celestials: `/mh healcds` noemt Celestial Conduit.
      Op een Preservation-evoker: Tip the Scales. (Heb je die niet: overslaan.)

## 🆕 10 okt — Trading Post: "already own" ook voor transmog, speelgoed en sets (TradingPost.lua)

- [ ] Loop in Silvermoon naar de Trading Post en open hem één keer. Daarna het Trading Post-tabblad in MH.
      Wat je al hebt (ook transmog en toys, niet alleen mounts en pets) staat grijs met "(already own)".
- [x] ✅ Rob 10 okt: `/mh tp why` + reload. Transmog-check en set-check zeggen allebei "ja" bij gekochte spullen
      (Horseman's schild en ensemble). Daarna erbij: de exacte appearance-check (itemModifiedAppearanceID).
- [ ] Zie je iets als "already own" dat je NIET hebt? Zeg welk item: dat zou een fout zijn.

## 🆕 10 okt — speelkaart Frost Mage: waarom-regels + quiz (PlayCards.lua + PlayCardWindow.lua)

- [ ] Op je Frost Mage: `/reload`, `/mh play`. Onder elke stap staat een blauwe regel **"Waarom:"**, ook onder "Meer vijanden".
- [ ] `/mh playcards check`: de laatste regel zegt `why lines SHOWN` en `quiz: 6 questions`.
- [ ] Onder de kaart staat de knop **"Test jezelf: quiz"**. Klik: vraag 1 van 6, een zin met een open plek, drie knoppen met icoon.
- [ ] Kies fout: jouw knop rood, de goede groen, "Net niet: het is …" en de waarom-regel. Kies goed: "Goed!".
- [ ] Na vraag 6: score, "Opnieuw" en "Terug naar de kaart" werken. Het tabblad "Hoe je speelt" blijft onderstreept tijdens de quiz.
- [ ] Op een andere spec (bv. Arcane via het spec-icoontje): géén quizknop en geen waarom-regels.
- [ ] Carola: laat haar de quiz doen en kijk of ze de zinnen snapt (dat is de echte test).

## 🆕 10 okt — `/mh export`: realm en regio erbij (GearExport.lua)

- [x] Typ `/run print(GetCurrentRegion())`. Je moet **3** zien (EU). ✅ Rob 10 okt: 3.
- [ ] `/reload`, `/mh export`. De tweede regel eindigt nu op `;realm=Khadgar;region=eu` (of je echte realm).
- [ ] Plak het op midnighthelper.com/armory/: je ziet je eigen character als plaatje (site-kant).
- [x] ✅ Rob 10 okt, Earthshammy (Elemental): tier = setnummer 2065 op hoofd, schouders, borst en benen, leeg op de
      rest; gems/enchants per regel (`g1/1e1` op de ringen, `g0/1e0` op de nek = lege socket); effect `e` op trinkets
      en het wapen. Geen embellished item op dat character (embellishment nog niet gemeten).
- [ ] Welke enchant en gem + kwaliteit + level: `/reload`, `/mh export` op Earthshammy. Stuur me de char-regel
      (eindigt nu op `;level=90` of je echte level) en één ringregel: na `g1/1e1` staan
      `<enchantnummer>/<gemnummer>`, de enchant-naam, en de kwaliteit (`2/2` o.i.d.). Daarna `/reload`: dan lees ik
      de ruwe enchant-regels (gearExportEnchantRaw) om te zien of het kwaliteitsicoon er echt in staat.
- [ ] Gems en enchants: in dezelfde export eindigt elke regel nu op iets als `g1/1e1` (1 van 1 socket gevuld,
      enchant erop). Een item met een lege socket of zonder enchant moet dat laten zien (bv. `g0/1e0`).
- [ ] Tier en embellishment: `/mh export` op een character met een **tier-stuk** (hoofd/schouders/borst/handen/benen
      uit de raid-set) en een **embellished** item. Stuur me die twee regels: de tier-regel eindigt op een setnummer,
      de embellished-regel heeft `cEmbellished:2` (verwacht). De site-chat wil echte regels om tegen te testen.
- [ ] Rode eis: leg iets in je tas dat je NIET mag dragen (te hoog level, andere class: de tooltip toont een rode
      regel). `/mh export`, `/reload`. Het staat niet in de export, en ik lees in je bestand waarom (gearExportSkips).
- [ ] (Alleen als je zo'n character hebt, NIET speciaal aanmaken.) Op een Fury Warrior, Enhancement Shaman of Frost DK met een één-hands wapen in de tas: in de export eindigt
      dat wapen op `|a|` (mag in beide handen). Op Warlockie blijft het `|1|`.
- [x] ✅ Rob 10 okt: geen schild meer. Op Warlockie (Steelbark Bulwark in de tas): `/mh export` heeft GEEN regel `B|offhand|…|Steelbark Bulwark` meer,
      en de site raadt geen schild meer aan. Wapens die je class niet kan dragen vallen ook weg.

## 🆕 10 okt — vrienden markeren: ieder zijn eigen icoon (FriendMarks.lua + FastMark.lua)

Gebouwd, niet getest. Rob: "ik ben altijd Ster, Carola oranje rondje, Cisca de paarse diamond". Rob koos beide routes.
- [ ] **Jezelf:** `/mh mark me star` → chat "Jouw icoon: 1". Geldt voor al je characters (account).
- [ ] **Route B (alleen jij hebt MH nodig):** `/mh mark friend <Carola's BattleTag> circle` en
  `/mh mark friend <Cisca's BattleTag> diamond`. In een groep met hen → `/mh mark friends`: staat er
  "Battle.net friends in WoW right now: N" met hun character? (0 terwijl ze online zijn = Blizzard geeft het niet → zeg het.)
- [ ] **Route A (zij hebben de nieuwe MH, dus pas na de volgende build):** zij typen zelf `/mh mark me circle` /
  `diamond`; jouw `/mh mark friends` toont "via MH: …".
- [ ] **Knop:** markeerbalk, na het schild: een vriendjes-knop. Muis erop → wie welk icoon krijgt. Klik → iedereen zijn
  icoon. Niemand bekend → grijs + uitleg.

## 🆕 10 okt — Codex "De Midnight-campagne beginnen" aangevuld (Codex.lua)

Rob vroeg een artikel "Midnight beginnen op een alt" — het bestond al (8 sep, door Rob gemeten); hij koos aanvullen.
- [ ] Codex → Start → "De Midnight-campagne beginnen": nieuw zijn "Kwijt? Loop Stormwind of Orgrimmar binnen…" en het
  punt "Die skip-regel verschijnt pas als een personage op je account de achievement Midnight heeft".
- ✅ GEMETEN Rob 10 okt: `GetAchievementInfo(42045)` = "Midnight", true op zijn account.
- Weggelaten tot gemeten: de level-90-skip bij Soridormi (Silvermoon, Wayfarer's Rest). Meten bij haar met
  `/run for _,o in ipairs(C_GossipInfo.GetOptions()) do print(o.gossipOptionID,o.name) end`.

## 🆕 10 okt — vijf instellingen erbij (SettingsDefs.lua, idee B4)

Gebouwd, niet getest. Instellingen (`/mh` → Instellingen, of Blizzards paneel).
- [ ] **Waarschuwingen:** "Korte meldingen (toasts)", "Toast: ongebruikte Trovehunter's Bounty", "Geluid als er iets nieuws
  in je tassen open kan", "Delve-itemsvenster vanzelf openen". Alle vier staan AAN (zoals altijd al). Zet er één uit →
  `/reload` → staat nog uit, en het ding zelf doet het niet meer.
- [ ] **Geavanceerd:** schuifje "Hoeveel extra muisknoppen…" 0-6 (= `/mh mouse N`).
- Kick-alarm staat er bewust NIET bij: toont op 12.1 niets (`SettingsDefs.lua`, regel bij Geavanceerd).

## 🆕 10 okt — markeerbalk: tank en healer met één klik (FastMark.lua)

Gebouwd, niet getest. `/mh mark` (balk aan) in een groep.
- ✅ Rob 10 okt: markeren werkt, ook in een follower dungeon. ❌ Icoon was hetzelfde als de rollen-check ernaast
  (uitsnede faalde) → nu een gewoon schild-icoon (`Ability_Defend`). **Hertest:** twee verschillende icoontjes.
- [x] Onderste rij, na het rode kruisje: een **schild-knop**. Muis erop → tooltip met wie de tank en de healer is.
- [ ] **Klik** → blauw vierkant op de tank, groene driehoek op de healer. (Komt er "You can't do this right now" of
  maar één markering? Zeg het: dan staan twee markeringen in één klik te snel achter elkaar.)
- [ ] **Alleen een tank of alleen een healer** in de groep → alleen die krijgt een markering, niets loopt vast
  (Rob: "mag niet vastlopen"). **Niemand met een rol** → knop grijs, tooltip zegt waarom, klik doet niets.
- [ ] Buitenlandse client (als iemand dat heeft): de knop gebruikt de vertaalde `/tm`.

## 🆕 10 okt — toetsenblok: alle personages in één keer naar de site (KeyBlock.lua)

Gebouwd, niet getest. Site-chat op Robs verzoek: "al je karakters in één keer naar de site".
- [ ] **Bewaren:** log in op een personage MET het toetsenblok geplaatst (of klik Plaatsen/Bijwerken) → zijn code wordt
  bewaard. Ongedaan maken haalt hem weg. Doe dit op 2-3 personages.
- [ ] **Knop:** `/mh block` → Cheat sheet → linksonder **"Alle personages"** → één kopieervak met alle codes, dit
  personage eerst, boven elke code "# naam - spec - updated <datum>".
- [ ] **Site:** plakken op midnighthelper.com/keyblock/ zodra de site-chat meldt dat hun kant live is.
- (Geen personage met het blok? Dan zegt de knop in de chat dat er nog niets bewaard is.)

## 🆕 10 okt — `/mh presses` in een venster + SimC-ras (KeyPresses.lua, SimcExport.lua)

Gebouwd, niet getest. Rob, 9 okt: "in een chat is het onoverzichtelijk".
- [ ] **Venster:** typ `/mh presses` → een venster "Welke spells je drukt" (niet meer de chat). Per regel: icoon, spell,
  aantal, [toets], makkelijk/gaat/lastig. Daaronder de ruil-tip (of "al op makkelijke toetsen") en de regel in grijs.
- [ ] **Knoppen:** "Tellen uitzetten"/"Tellen aanzetten" wisselt (en zegt het in de chat). "Wis deze spec" vraagt eerst
  "Klik nog eens om te wissen"; na de tweede klik is de lijst leeg.
- [ ] **Na een gevecht:** laat het venster open staan, vecht → na het gevecht staan de nieuwe tellingen er vanzelf.
- [ ] **Shift+scroll** maakt het venster groter/kleiner, slepen werkt, Escape sluit.
- [ ] `/mh presses why` geeft nog steeds de lijst in de chat (diagnose).
- [ ] **SimC (`/mh raidbots`):** alleen te zien met een personage van ras-id 95/96 (SimC noemt ze "skyborne"; welk ras dat in het spel
  heet is NIET gemeten). Heb je dat niet: overslaan.
  Op elk ander personage: de `race=`-regel is hetzelfde als vóór vandaag.
- ✅ Rob 10 okt: ruil-knop werkt (niet in gevecht geprobeerd). Twee wensen → gebouwd, hertest open:
  - ✅ Rob: ruilen + "terugdraaien (2)" + "alles terugdraaien (2)" werken; Flash Heal weg uit de tips.
  - [ ] **0x-spells als ruilplek** (Rob: "maar 2 adviezen"; hij koos ja): vanaf 5 gevechten mag een drukke spell ook
    naar een makkelijke toets waarvan je de spell NOOIT drukte; tip toont dan "(0x, on …)". Max 3 tips. Heals,
    interrupts en Blijf leven blijven ook dan staan.
  - [x] **Heals ruilen nooit**, en interrupts/Blijf leven-spells ook niet — in géén richting (Flash Heal stond als
    "druk" in een tip). Priest → `/mh presses`: geen tip meer met Flash Heal. (Potions/items konden al nooit: LiveKeys
    leest alleen spells en macro's.)
  - [ ] **Meer dan één terugdraaien:** MH onthoudt alle ruilen (max 20). "Laatste ruil terugdraaien (N)" gaat er één
    terug, nieuwste eerst; "Alles terugdraaien (N)" zet alles terug. Ook na "Wis deze spec" blijven ze terug te draaien.
- [x] **Ruil-knop (Rob koos: knop per tip + terugdraaien):** Priest → `/mh presses` → achter elke tip een knop "Ruil".
  Klik er één (buiten gevecht) → groene regel "Geruild: X staat nu op …, Y op …" (ook in de chat), en de twee spells
  staan echt verwisseld op je balk; de lijst toont meteen de nieuwe toetsen. Knop "Laatste ruil terugdraaien" zet het
  terug (ook na `/reload`). In gevecht: oranje "Niet tijdens een gevecht". Lukt een ruil niet, dan zegt hij dat (oranje)
  en is er niets veranderd.
- [x] **Venster met tellingen** ✅ Rob 10 okt: BM Hunter (7 regels, "al op makkelijke toetsen") en Shadow Priest
  (8 regels, 3 ruil-tips). ❌ Priest-tip "ruil Mind Flay met **Silence**": een interrupt hoort niet naar een lastige
  toets → gerepareerd: interrupts (role "interrupt") en alles met een Blijf leven-regel (`survival`) uit
  KeybindRoleClassifier worden nooit als "rustige" ruilpartner gekozen. **Hertest:** Priest → `/mh presses`: geen
  Silence meer in de tips.
- [x] **Leeg venster** (Rob, Warlock 82, 10 okt): opent ✅. Tekst zei "turn it on" terwijl tellen aan stond → nu
  `PRESSES_NONE_ON` ("tellen staat aan, de lijst vult zich vanzelf") en "Wis deze spec" alleen als er iets geteld is.
- [x] **Bartender/ElvUI (LiveKeys.lua) — bij Rob mag NIETS veranderen** ✅ Rob 10 okt, Warlock: "sources: Blizzard 24,
  Bartender4 0, ElvUI 0, other LibActionButton 0", elke spell "Blizzard". (hij heeft geen van beide): `/mh playkeys` →
  regel 2 "sources: Blizzard N, Bartender4 0, ElvUI 0, other LibActionButton 0", en dezelfde toetsen als gisteren op de
  "Zo speel je"-kaart en in `/mh presses`. (CooldownManagerCentered laadt LibActionButton, maar maakt alleen
  flyout-knoppen zonder toets — GELEZEN in zijn code.)
- [ ] **Iemand MET Bartender4 of ElvUI** (Cisca/beta-speler): `/mh playkeys` → "Bartender4 N" of "ElvUI N" > 0, en de
  toetsen op de kaart kloppen met de balk. Klopt het niet: de 5 `/run`-regels onderaan
  `docs/BAR_ADDONS_LIVEKEYS_2026-10-09.md` en een screenshot.

## 🆕 9 okt — welke spells druk je het vaakst (`/mh presses`, KeyPresses.lua)

Gebouwd, niet getest. Rob: "ik ga van 1 naar Ctrl 5 naar Shift 2 …".
- [ ] **Aanzetten:** typ `/mh presses on` → chat: "Tellen staat AAN …". Of: Instellingen → Gevecht → "Tel welke spells
  je drukt" (staat standaard UIT).
- [ ] **Tellen:** speel 3-4 gevechten (een delve of dungeon is genoeg), typ dan `/mh presses`. Je ziet maximaal 8 regels:
  spell, aantal keer, `[toets]` en makkelijk/gaat/lastig. Klopt de toets met wat er op je balk staat?
- [ ] **Tip:** staat een spell die je vaak drukt op een lastige toets (Ctrl/Alt), dan staat eronder "Tip: ruil X met Y".
  Voelt die ruil logisch? (Er verplaatst NIETS vanzelf.)
- [ ] **Per personage/spec:** wissel van spec of personage → `/mh presses` zegt "Nog niets geteld" (eigen lijst).
- [ ] **Niets raars erin:** staan er spells in die je nooit drukt (passieve dingen, procs)? Typ dan `/mh presses why` en
  maak een screenshot — dan zie ik wat er geteld is.
  ❌→🔧 Rob 9 okt avond, BM Hunter: "1. Auto Shot 16x not on a key" bovenaan. Gerepareerd: Auto Shot (75) en Auto
  Attack (6603) tellen niet meer mee (soort "auto" in `/mh presses why`). Rest van zijn lijst klopte (toetsen,
  makkelijk/gaat; Bestial Wrath op [0] = duimknop = makkelijk). **Hertest:** na `/reload` → `/mh presses` op de Hunter:
  geen Auto Shot meer. Staat hij er tóch: `/mh presses why` → welk id? ✅ Hertest Rob: Auto Shot weg.
- [ ] **Duimknoppen:** jouw 6 7 8 9 0 - op balk 8 moeten "makkelijk" heten (MH weet van je pad via de bar-8-knop).
  Staat er "gaat"/"lastig" bij, zeg het.

## 🆕 9 okt — knop bij het veilinghuis (AuctionShopButton.lua)

Gebouwd. Rob, aan het veilinghuis: "hoe maakte ik ook alweer mijn raid lijstje voor ah?"
✅ **Rob 9 okt avond: "deze werkt".** Screenshot: nlNL-tekst "Boodschappen: 4 te kopen", rechtsonder, naast de
Auctionator-tab en er niet overheen.
- [x] **Veilinghuis openen:** onder het venster, rechtsonder, een knop "Shopping list (MH)" — of "Shopping list: N to buy"
  als je raid- of beroepenlijst iets mist. Staat hij niet over iets heen (Auctionator-tabs, Blizzards eigen knoppen)?
- [x] **Klik:** het venster "Klaar voor de raid?" gaat open, met de tabs Raid | Beroep.
- [ ] **Koop iets van de lijst:** het getal op de knop zakt vanzelf. ❌ Rob 9 okt avond: zakte pas na mail ophalen
  (het venster zette het wél meteen "in de mail"). Gerepareerd dezelfde avond: de aankoop werkt nu ook de knop bij
  (`ns.RefreshAhShopButton`). ❌ Hertest (met /reload): stond op 2 vóór de Amethyst, bleef 2 erna. Screenshot
  erna: raid-venster 1× Koop (Head), Beroep 1× "Pluk 1" (Nocturnal Lotus telt als te kopen) → 2 klopt ná de koop;
  vóór de koop had het dus 3 moeten zijn. Onopgelost. Nu: tooltip toont "Raid: X · Beroep: Y" en elke hertelling
  schrijft naar `ns.db.ahShopProbe` (reden open/bags/purchase). **Test:** veilinghuis open → muis op knop (noteer X/Y)
  → koop 1 ding van de lijst → muis erop → `/reload` → zeg het mij, ik lees de SV.
  ✅ Meting Rob (zelfde avond): Raid 1 → koop Head-enchant → Raid 0, meteen. **Raid-deel werkt.** Maar Beroep sprong
  0 → 1 zonder dat er iets veranderde: `CraftShopTerms` slaat een item over waarvan de naam nog niet geladen is
  (Nocturnal Lotus). Dat verklaart ook de "2 vóór en 2 ná" van eerder. Gerepareerd: knop telt via
  `ns.CraftShopToBuyCount` (zonder naam). **Hertest:** na `/reload` meteen veilinghuis open → muis op knop: Beroep
  moet direct goed staan (niet eerst 0).
  📌 Rob koos dezelfde avond: **"Pluk" telt niet mee.** Beroep telt nu alleen rijen met rode "Koop N" (niet Pluk, Maak,
  Handelaar). **Test:** Beroep in de tooltip = aantal rode "Koop" in de tab Beroep.

## 🆕 9 okt avond — Discovery-recepten: hoe, niet alleen waar (CraftShoppingList.lua)

Rob koos (a + b). Gebouwd, niet getest.
- [ ] **Flask of the Magisters op je lijst (Alchemy):** onder "Discovery: Camberon's Cauldron" staat een gele regel:
  maak eerst 10 Sin'dorei Flasks, daarna 50 Artisan Alchemist's Moxie, specialisatie Fluent in Flasks -> Sin'dorei
  Specialist. ⚠️ Bronnen uit 12.0.x: **ga bij de ketel staan en kijk of de opdracht klopt** (10×? 50 Moxie? nog meer?).
- [ ] **Een ander Discovery-recept op je lijst:** gele regel "Zo: ga naar die ketel en doe zijn opdracht …".
- ⚠️ Op een niet-Engelse client zie je alleen de Magisters-regel (de algemene regel zoekt het Engelse woord
  "Discovery"). de/fr/es/pt/it vertaald door mh-writer (namen als Fluent in Flasks bleven Engels).

✅ **Barkskin** (Rob, Resto Druid, 9 okt avond): Academy heal-route toont "(1 min)" = 60 s.
✅ (hertest Rob, screenshot: netjes onder elkaar) **Academy "Rol wisselen, stap voor stap":** lange stapteksten liepen over elkaar (tekst gecentreerd op het
hokje). Gerepareerd: tekst hangt nu linksboven naast het hokje. **Test:** `/mh academy` → Tank-track → die lijst
leest netjes onder elkaar, links uitgelijnd.
✅ **Earth Elemental MET Primordial Bond** (Rob, Elemental, 9 okt avond): staat als grote knop op Blijf leven.
(Dat hij het talent heeft is afgeleid uit de tooltip "+15% max health"; "zonder" niet getest.)
- [x] **Instellingen → Venster → "Boodschappenknop bij het veilinghuis" uit:** knop weg (ook bij een open veilinghuis).

## 🆕 9 okt — twee schakelaars erbij, en Kith'ix staat klaar voor patchdag

Gebouwd, niet getest.
- [ ] **Instellingen → Geavanceerd:** twee nieuwe schakelaars: "Houd toets 1 vrij voor de Assisted Combat-knop" (= `/mh sba`)
  en "Laat de toetsindeling mijn muisknoppen gebruiken" (= `/mh mouse fill`). Beide standaard UIT. Zet er één aan, dan
  `/reload` en `/mh apply` (alleen kijken, niet uitvoeren): verandert de voorgestelde indeling zoals de uitleg zegt?
- [x] **NU (12.1):** Raids-pagina → "The Unbinding of Kith'ix" staat er NIET (verborgen tot 12.1.5). Staat hij er wél, zeg het.
  ✅ Rob 9 okt avond.
- [x] **Schakelaars in Geavanceerd** staan er; `/mh apply`-proefrun gaf de normale "bar te kort"-melding. ✅ Rob 9 okt avond.
- [ ] **Patchdag 13/14 okt:** Kith'ix verschijnt vanzelf, met bovenaan de grijze notitie "Geschreven vóór patch 12.1.5…".
  Kloppen de spell-links (namen)? Daarna: `/mh ej save` in de raid → journalInstanceID + ingang toevoegen; DBM-module
  checken; zwakke regels nalopen (lijst in `docs/KITHIX_TIPS_DRAFT_2026-10-09.md`).

## 🆕 9 okt — Barkskin 60 s, Earth Elemental alleen met Primordial Bond (docs/SMALL_FACTS_2026-10-09.md)

Gebouwd, niet getest.
- [ ] **Resto Druid, Role Academy (heal-route) → je defensives:** Barkskin zegt **(60s)**, niet meer (45s).
- [ ] **Shaman, Zo speel je → Blijf leven:** ZONDER het talent Primordial Bond staat Earth Elemental er NIET meer bij;
  MET Primordial Bond wel (als grote knop). Heb je geen Shaman met/zonder het talent: overslaan en zeggen.

## 🆕 9 okt — healer-cooldowns: 4 erbij, Salvation eruit (docs/HEALER_CDS_FACTS_2026-10-09.md)

Gebouwd, niet getest. Typ `/mh healcds` op de healer.
- [x] **Holy Priest:** Holy Word: Salvation staat er NIET meer (bestaat al sinds 11.1 niet). Bovenaan staat nu Divine Hymn.
  ✅ Rob 9 okt avond, screenshot.
- [x] **Resto Druid:** Innervate staat erbij (onderaan). ✅ Rob 9 okt avond, screenshot `/mh healcds`.
- [x] **Holy Paladin:** Avenging Crusader staat onder Avenging Wrath (het is een keuze: je hebt er één van).
  ✅ Rob 9 okt avond, screenshot (Wrath 2 min, Crusader 1 min, Divine Toll 1 min).
- [ ] **Mistweaver / Preservation** (alleen als je die hebt): Restoral onder Revival; Zephyr bij de Evoker.

## 🆕 9 okt — schat-stappen vinken nu af (Gift of the Cycle, Brine-Crusted Chest)

Gebouwd, niet getest. Alleen voor een personage dat de schat nog NIET heeft.
- [ ] **Harandar, Gift of the Cycle:** (Rob 9 okt avond: al gedaan op zijn personage → hier niet te testen) zet de schat-route aan (Achievements → Treasures of Harandar). De pijl gaat eerst
  naar het kussen, dan het altaar van Wisdom, dan het mes, enz. — nooit naar een altaar vóór je het voorwerp hebt. Na elk
  altaar vinkt die stap af in het hint-venster.
- [ ] **Coiled Isle, Brine-Crusted Chest:** eerst de clam (pijl), en na het plaatsen van de parel vinken beide stappen af.
  Rob 9 okt avond: pijl ging naar de kist, maar via de knop "-> the chest" in het hint-venster (die stuurt direct
  naar de kist = goed). GEMETEN: quest 96001 false, parels 0. **Opnieuw:** start de route via Achievements.
  ⏸ Rob: overgeslagen (moet op de Isle eerst nog veel doen); blijft open, niet blokkerend voor 4.7.5.

## 🆕 8 okt — "grote defensive"-zin en de heal-soorten (docs/ROLE_SWITCH_FACTS8)

Gebouwd, niet getest.
- [ ] **Paladin (elke spec), Zo speel je → tab Blijf leven:** onder Divine Shield staat "een grote: druk hem net vóór de
  hardste klap die je ziet aankomen" — zónder "(een immuniteit mag ook als je bijna dood bent)". De Lay on Hands-noot
  staat er nog achter.
- [ ] **Holy Priest, zelfde tab:** onder Guardian Spirit een eigen zin: "als je health blijft zakken: ga je dood, dan redt
  hij je één keer …". **Frost Mage:** onder Cold Snap "na je grote (Ice Block of Ice Cold): hij maakt die weer klaar …".
- [ ] **Healer, Role Academy → heal-toolkit (Holy Paladin):** Holy Shock en Word of Glory hebben het label [Instant],
  Flash of Light [Korte cast], Holy Light [Groot]. Resto Druid: Swiftmend [Instant], Regrowth [Korte cast]. Geen rauwe
  sleutel (HEALCORE_…) te zien.
- [ ] **Holy Paladin, heal-toolkit:** volgorde Holy Shock, Word of Glory (of Eternal Flame), dan Flash of Light, Holy Light.
  **Holy Priest:** Holy Word: Serenity staat er nu, met [Instant], vóór Flash Heal.
- [ ] **Holy/Ret Paladin, Blijf leven:** achter Blessing of Protection staat "… Geeft Forbearance: 30 s geen Divine Shield of
  Lay on Hands op jezelf". Prot met Spellwarding: zelfde zin bij Spellwarding. Rogue (Evasion, Cloak) zegt nog gewoon
  "alleen tegen fysieke schade" / "alleen tegen magie", zonder Forbearance.

## 🆕 7 okt — 12.1.5 Codex-kaartjes (pas zichtbaar vanaf 12.1.5)

- [ ] **(8 okt) Patchdag, `/mh codex` → Dungeons:** nieuw kaartje "Keystone Myth is back (12.1.5)". Live vóór de patch: NIET
  zichtbaar. Klopt 3600 in je eigen Achievements-venster (de testdata zei "[PH]")?
- [ ] **(8 okt) Labyrinth, Kindo'jan:** moeten de 4 Amani Headhunters dood of niet? (Wowhead 7 okt: niet nodig, en hun bijlen
  tellen niet voor Disgraceful Display.) Ons kaartje zegt nu alleen "4 Amani Headhunters appear". En: ben je je kamers kwijt
  als je het Labyrinth verlaat? (bronnen spreken elkaar tegen)
- [ ] **(8 okt) Events-scherm (PTR of na de patch):** Aqir Invasion staat maar 1× in "Coming up".

Gebouwd, niet getest. Op de **live** client horen ze NIET te bestaan; op de **PTR** (12.1.5) wel.
- [ ] **Live, `/mh codex`:** Delves heeft géén "The Labyrinth of Kindo'jan", Raid & crests géén Kith'ix/Venomstones,
  World content géén Aqir Invasion. Zoekvak "labyrinth" vindt niets.
- [ ] **PTR (na copy_to_ptr), `/mh codex`:** alle vier staan er; de pijl-link in het Labyrinth-kaartje (Eversong 62.99, 72.18)
  zet een waypoint bij het portaal. Staat de ingang daar écht? Kith'ix-link (Underbelly 74.27, 5.91) idem.
- [ ] **PTR, in het Labyrinth:** klopt "elke 3 kamers 2 Heavy Trunks + 1 Bountiful Coffer"? Vraagt de coffer een Restored
  Coffer Key? Zegt de delve-coach iets (of niets) — screenshot.
- [ ] **PTR, Labyrinth binnenlopen:** na ~3 sec één chatregel "…: Midnight Helper has no delve tips for this one yet …"
  plus de Codex-verwijzing. Komt hij NIET, dan ziet MH het Labyrinth niet als delve (ook goed om te weten).
  Daarna `/reload` → ik lees `ns.db.delveCoachUnknown` (instance-ID).
- [ ] **Live, gewone delve (bv. een Coiled Isle-delve):** die regel mag NIET verschijnen.
- [ ] **Live, Hearthstone + portaal:** Hearthstone in Silvermoon gebonden en niet op cooldown? Ga ver van een portaal
  staan (bv. Zul'Aman) en zet een route naar iets in Voidstorm of Harandar (rare/schat). Het reisvenster moet de
  Hearthstone-knop tonen + "Faster: Hearthstone to Silvermoon, then Portal to …". Typ ook `/mh portals`: bovenste
  regel = je Hearthstone-plek + yes/no. Staat er "no" terwijl je wél in Silvermoon gebonden bent → noem de plek die
  er staat (dan voeg ik die naam toe).
- [x] ✅ Rob 7 okt: Grudge Pit, Collegiate Calamity én Coiled Isle geven de knop. (Voidstorm niet apart gemeld.)
  **Live, Hearthstone-route per bestemming** (Hearthstone klaar, gebonden in Wayfarer's Rest, NIET in Silvermoon staan):
  route naar (a) iets in Harandar (Grudge Pit ✅ label 7 okt, knop nog testen), (b) iets in Voidstorm, (c) een Coiled
  Isle-delve (Gnarldor Isle / Ring of Glory) — alleen als je de Coiled Isle-portal hebt (quest 96004). Reisvenster met
  Hearthstone-knop + "Sneller: Hearthstone naar Silvermoon, dan …"? (d) iets in Eversong/Zul'Aman: daar GEEN aanbod
  (geen stadsportaal erheen) — dat is bewust. (e) 7 okt laat: Collegiate Calamity (in Silvermoon) vanuit Atal'Aman →
  reisvenster met alleen de Hearthstone-knop. Komt er iets niet: `/reload` en zeg het, dan lees ik `ns.db.travelWhy`.
- [x] **Live, Shift+scroll op elk venster (7 okt laat):** ✅ boodschappenvenster + ✅ "de andere vensters werken" (Rob, 7 okt). Was: open het boodschappenvenster (Beroep én Raid), het reisvenster,
  de changelog en de beroepscursus. Houd Shift in en scroll met de muis BOVEN de lijst/tekst: het venster wordt groter
  of kleiner. Zonder Shift scrolt de lijst gewoon. Na `/reload` houdt elk venster zijn eigen grootte. In gevecht doet
  Shift+scroll bewust niets. Mist er een venster: noem het, dan zet ik het erbij.
- [x] ✅ Rob 7 okt: "het werkt". **Live, consumables-bord sluiten (7 okt laat, Rob vond het):** open het bord, sluit het met het kruisje. Ga met je
  muis over de plek waar de vakjes stonden: GEEN tooltip meer ("Niet in je tas"), geen oplichtend vierkantje. Ook na een
  gevecht niet. Open het bord opnieuw: klikken op een flask/oil werkt nog?
- [x] **Live, Holy Paladin: Infusion of Light** — ✅ Rob 7 okt (screenshot): buff bij je buffs, 10 s, tooltip "Flash of
  Light healing increased by 200% and becomes instant cast". Kaart 65 zegt nu "bij je buffs, 10 seconden" (7 talen).
  Of de knop óók oplicht: niet gezien.
- [ ] **Live, Holy Paladin heal-toolkit:** Divine Shield heet nu *[Immuniteit]*, Divine Protection blijft *[Defensive]*.
- [ ] **Live, in Silvermoon City:** route naar iets in Harandar of Voidstorm. De pijl wijst naar het portaal; de
  portaalKNOP mag nu NIET meer verschijnen (was dubbel). Ver van een portaal (andere zone) moet de knop er wél nog zijn.
- [ ] **Live, 6 speelkaarten (`/mh play`):** Resto Shaman, Demonology, Survival, Prot Warrior, Windwalker, Discipline.
  De nieuwe zin staat erin, en Nature's Swiftness / Summon Doomguard / Execute / Zenith Stomp / Shadow Mend zijn
  klikbare spreuken met tooltip (ID's GEMETEN in wago.tools SpellName 12.1.5.70077, 7 okt).
- [ ] **Live, `/mh academy tank` en `/mh academy heal`:** de Academy opent op die track. Bovenaan nu eerst "What is a
  tank?" / "What is a healer?", de mindset, de oefenroute (met follower dungeon) en "Words you will hear"; pas dáárna de
  knop "How you play …" en de toolkit. Geen verwijzing meer naar "Guides" of "In groups". Brewmaster: Celestial
  Infusion staat in de toolkit als je dat talent hebt. Zoekbalk "leren tanken" → Academy.
- [ ] **Live, Academy-stappenplan:** het vaste vinkblok bovenaan is weg; onder "What is a tank?" + "Words you will hear"
  staat "Switch role, step by step" met 7 vinkjes. Op je Prot Paladin: "spec" staat vanzelf aan; "taunt en interrupt op
  een toets" ook, als Hand of Reckoning en Rebuke op je balk staan. In de tank-toolkit: Hand of Reckoning [toets] en
  Rebuke [toets]. Tikken/ontvinken werkt en blijft na /reload. Daaronder "How you see a big hit coming".
- [ ] **Live, healer-kaart (`/mh play` op een healspec):** de kop boven groepsschade heet nu "Many people hurt at once".
- [ ] **PTR, Aqir Invasion:** Void & Rituals-tab → event-regel van de invasie: hover → uitleg + beloning?

## 🆕 6 okt — knoppen voor commando's die alleen via /mh gingen (Rob: alle 4 groepen + de 5 reparaties)

Gebouwd, niet getest (`docs/COMMANDS_AUDIT_2026-10-06.md`). Na `/reload`:
- [ ] **All settings** (Settings → All settings): bij "In combat" Action prompt, Action prompt sound (Off/Spoken/Chime:
  kiezen speelt het geluid), Dispel alert; nieuw kopje **Gear** met upgrade-regel in tooltips en upgrade-pijltjes; bij
  Meldingen Scorecard + detail; bij Dungeon de 3 tank-samenvattingen; bij Route-pijl "Let WaypointUI drive". Zelfde
  stand als je `/mh`-commando's? Ook in Blizzards eigen Options → AddOns → Midnight Helper?
- [x] Rob 6 okt ✅ ("de rest opent netjes"; screenshot toont alle 5 kaarten) **Pop-out windows**: 5 nieuwe kaarten.
  ✅ Ook "Your graphics settings" (/mh fps) opent (Rob 6 okt: "graphics opent ook netjes").
- [x] Rob 6 okt ✅ (screenshot) **Settings-startpagina**: knoppen Report a problem, What's new, Side panels back in place staan er.
- Rob 6 okt: "Open Midnight Helper settings" → hernoemd naar **All settings**; "Help translate" gaf alleen chat (en
  zei op een Engelse client "enUS needs its first pack") → nu een kopieervenster; "Show me" opende zonder uitleg de
  balken-wizard → in Settings heet hij nu "Set up your bars and keys".
- [x] Rob 6 okt ✅ ("ja klopt allemaal") Na `/reload`: knop heet All settings? Help translate opent een venster met de
  links? Knop "Set up your bars and keys"? Nieuwe schakelaars staan bij All settings (of ze elk ook wérken: niet apart
  gemeld).
- [x] Rob 6 okt ✅ (2 screenshots: tooltips "Nearest flight master" en "Your route" met klik/rechtsklik/Shift-klik)
  **Snelbalk**: met een route (bv. een rare-route) een kaartknop: klik = overslaan, rechtsklik = stoppen, Shift-klik =
  plan. Verdwijnt hij binnen ~2 s na stoppen? Buiten instances een vluchtmeester-knop.
- [x] Rob 6 okt ✅ (screenshot "Debug mode ON") Reparaties: `/mh debug` zegt nu "debug mode" (niet arrow-debug; dat is `/mh arrowdebug`). In de zoekbalk/lijst
  zeggen delves/scorecard/size nu wat ze echt doen.

## 🆕 6 okt — Tools → Pop-out windows: knoppen voor Ready en Key block; de hele pagina schuift

- [x] Rob 6 okt ✅ (screenshot, v4.7.3) beide knoppen staan erbij en werken.
- GEMETEN (screenshot): "All commands" eronder platgedrukt, niet te lezen of te scrollen. Gerepareerd: kaarten + lijst
  in één schuifvak (ToolsLaunchpad.lua, CommandList.lua `flat`). NIET in de beta-zip van 65ddccf.
- [x] Rob 6 okt ✅ ("scrollen werkt, alles goed te lezen") `/reload` → Tools → Pop-out windows: hele pagina scrollt?

## 🆕 6 okt — Boodschappen voor je beroep (`/mh craftshop`, Cisca's wens; Rob: eigen venster, keer maken, per personage)

Gebouwd, niet getest. Bron: mh-research 6 okt (Blizzard UI 12.1.0.69933). Reagents worden bij het toevoegen gelezen
en opgeslagen (`ns.db.craftShop[guid]`), dus de lijst heeft het beroepsvenster daarna niet meer nodig.
- [ ] Open Alchemy (of een ander beroep), klik op een recept. Staat in het MH-paneel ernaast "+ <recept> op je
  boodschappenlijst" en "Open je boodschappenlijst (0)"? Verandert de eerste regel als je een ander recept kiest?
- [ ] Klik "+ …" → vraag "Hoe vaak?" → 20 → OK. Chatregel "op je boodschappenlijst: 20× …"?
- [ ] Open de lijst (paneel, `/mh craftshop` of Tools → Pop-out windows): recept met "20×" (en "ongeveer N gemaakt"
  als het recept er meer geeft), daaronder elke reagent met heb/nodig, "+N in je post / op de bank", Koop/Ophalen.
  Kloppen de aantallen met je tassen? Telt een reagent in zilver én goud samen?
- [x] Rob 6 okt ✅ ("ja, keurig"; screenshot Auctionator-lijst "MH craft - Purlymixanox" met "Fantastic Fur" [x1])
  Naar Auctionator → lijst "MH craft - <naam>". Paneel volgt het gekozen recept na de reparatie (Rob: "gaat nu goed").
- [ ] Kruisje bij een recept haalt het weg; "Lijst leegmaken" werkt?
- [ ] Iets mis: `/mh craftshop why` (beroep open, recept gekozen) → screenshot van de chat.
- [ ] (alleen met een de/fr/es/pt/it-client, of Cisca) Vertaald 6 okt: past "Vaciar la lista"/"Svuota la lista" op de
  knop "Lijst leegmaken"? Lopen de paneelregels netjes over twee regels bij een lange receptnaam?

## 🆕 6 okt — boodschappenlijst v2: recept-bron, handelaar, farmplekken, zelf maken (Rob: "laten we gewoon die punten doen")

Gebouwd, niet getest. Teksten alleen enUS + nlNL (vertaalronde volgt). Muis op een reagent = de lange uitleg.
- [ ] **Recept-bron:** zet een recept op je lijst dat je NOG NIET kent (grijs in je beroepsvenster). Staat eronder in
  het rood "Dit recept ken je nog niet. Hier haal je het:" + Blizzards tekst (Drop/Quest/Vendor … Zone …)?
- [ ] Een recept dat je wél kent: géén rode regel?
- [ ] **Handelaar:** recept met Sunglass Vial / Silverleaf Thread / Luminant Flux e.d. Regeltje "Handelaar, naast je
  trainer" en status geel "Handelaar N" (niet "Koop")? Naar Auctionator: staat dat item er NIET in?
- [ ] **Farmen:** een kruid / erts / leer: "Herbalism - alle vier de gebieden" e.d.? Groen als je dat beroep zelf hebt?
- [ ] **Zelf maken** (Alchemy is de beste test, bv. iets met Composite Flora): open eerst je beroep één keer. Staat bij
  zo'n reagent "Maak je zelf: <recept>" en een knop **+ Maken**? Klik → komt dat recept op je lijst, met zijn eigen
  reagents erbij, en wordt de status van de reagent blauw "Je maakt het"?
  ⚠️ Bij Robs Leatherworking-lijst vond de meting GEEN tussenproduct; dit deel is dus nog nergens positief gezien.
- GEMETEN Rob 6 okt (screenshot, Leatherworking): rode regel "Quest: The Medicine Loa's Shrine, Zone: Zul'Aman" ✅;
  Skinning-regels groen ✅. Zonder regeltje: Mote of Wild Magic, Peerless Plumage, Dusk-Shrouded Stone (mh-research zoekt).
- GEMETEN Rob 6 okt (screenshot, Alchemy): **+ Make** staat bij Silvermoon Health Potion (18/25, recept op de lijst maakt
  ~5 → 2 tekort) ✅ — eerste positieve zichting van "zelf maken". Bron "Vendor: Second Mate Sluggs, Zone: The Coiled Isle"
  ✅, Sunglass Vial "Vendor, next to your trainer" ✅. Zonder regeltje: Cursebound Globe, Neutralized Venom Clot.
  Knop toont nu het aantal ("+ Maken 1×").
- [x] Rob 6 okt ✅ (2 screenshots: "+ Make 2×" bij 18/25 → "2× Silvermoon Health Potion (about 10 made)", eronder Sunglass
  Vial 10 + Tranquility Bloom 12, potion blauw "Crafting") Klik **+ Maken N×**: recept erbij, status blauw?
- GEMETEN Rob 6 okt (screenshot): na het maken werkt het venster live bij ✅; tooltip met kruid-uitleg + "You have
  this gathering profession" ✅. Maar het recept bleef "2×" staan → nu: aftellen.
- [ ] **Aftellen:** recept 2× op de lijst, maak er één → chat "… gemaakt: nog 1× op je boodschappenlijst"? Tweede →
  "klaar, van je lijst af" en het recept is weg? Gebeurt er niets: `/mh craftshop why` → regel "craft NOT on your list".
- [x] Rob 6 okt ✅ (screenshot: Tranquility Bloom "Pick 1", Azeroot "Pick 3", Nocturnal Lotus "Pick 1", groen)
  **Pluk N:** kruid te kort en jij hebt Herbalism → groene status "Pluk 23" in plaats van "Koop 23"? (Erts: "Delf",
  leer: "Vil".)
- [ ] **Wijs de weg naar 39 plekken** (Rob: "bouw die pijlen maar naar 39 plekken"; `Modules/CraftShopPlaces.lua`, 266
  recepten): zet Potion of Recklessness / Alluring Nostrum / Blessed Pango Charm (niet geleerd) op je lijst → knop
  "Wijs de weg" → pijl naar Void Researcher Anomander (Voidstorm) / Second Mate Sluggs (Coiled Isle) / quest in Zul'Aman
  (+ chatregel over een eerdere quest)? `/mh craftshop why` met dat recept gekozen noemt de plek.
- GEMETEN Rob 6 okt avond (screenshot, Leatherworker, 4.7.4-beta1): knop "Show the way" bij Blessed Pango Charm (quest) ✅,
  geen knop bij een spec-recept ✅; regeltjes ronde 2 zichtbaar: Peerless Plumage groen + "Skin 2", Mote of Wild Magic,
  Dusk-Shrouded Stone, Mote of Pure Void ("Pick it up", 36 op de bank), Sin'dorei Armor Banding "You make this" ✅.
  ✅ Rob 6 okt avond (screenshot chat): klik → "This recipe comes from a quest…" + TomTom "Quest: The Medicine Loa's
  Shrine - 38.78, 44.85 in Zul'Aman", plus tussenstap "Portal to Silvermoon" (stond op de Coiled Isle). Quest-pijl werkt.
  Nog niet gezien: pijl naar een handelaar, trainer of ingang.
- [ ] **Regeltjes voor meer reagents** (6 okt, uit het tweede onderzoek): Motes ("Wild-kruiden & erts - vooral Zul'Aman"
  e.d.; groen + "Verzamel N" met Herbalism óf Mining), Thalassian Lumber, Dazzling Thorium, Petrified Root ("Delve-kisten"),
  Cursebound Globe / Neutralized Venom Clot (Coiled Isle), Peerless Plumage, Skinning-spul, prospect-stenen ("Prospect N"
  met Jewelcrafting), disenchant-stof, stof, vlees. Kloppen ze met wat je weet? (Motes/Cursed/Petrified = Wowhead, KANDIDAAT.)
- [ ] **Nalopen in het spel** (KANDIDAAT, tooltip op de knop zegt dat): Lyrendal 2393 44.96/55.40, Mirvedon 2393 34.01/81.25,
  Gelanthis 2393 48.01/55.03, Navigator Otoola 2512 57.2/48.2, Jennara Sunglow 2393 39.54/51.00 (boven), Sylann (koken)
  2393 56.36/69.83, questgevers 2395 46.93/35.58 · 2437 38.78/44.85 · 2413 49.69/23.31, ingang Venomous Abyss (MH 20.51
  vs DB2 22.86), ingang Altar of Fangs 2509 47.24/68.13. Herbataur (Stabilized Derivate?) 2393 45.2/80.4.
- [ ] **Wijs de weg** (Rob: "kunnen we de weg wijzen?"): een NIET-geleerd recept van de trainer → knop "Wijs de weg"
  rechts op de receptregel → pijl naar je trainer in Silvermoon? Handelaar-spul → knop "Handelaar N" → pijl naar de
  handelaar naast je trainer (koken: de herberg)? Ook met TomTom aan?
- [ ] Het nep-recept "Knowledge" (geen reagents) toevoegen → chat zegt dat het niet op de lijst komt?
- [ ] `/mh craftshop why`: regel "items you can make … N" met een getal boven 0 (na het openen van je beroep)?

## 🆕 7 okt — "één winkelvenster" (Rob koos het): tabbladen + alles naar Auctionator

Gebouwd, niet getest. De twee vensters bestaan nog, maar delen nu tabbladen BOVEN het venster.
- [ ] `/mh ready` → boven het venster twee tabbladen **Raid | Beroep**. Klik Beroep → het boodschappenvenster opent op
  dezelfde plek en het raid-venster gaat dicht? En terug?
- [ ] Met Auctionator: onderaan beide vensters een knop **Alles naar Auctionator** → chat "lijst MH - <naam> met N"?
  In Auctionator → Shopping één lijst met de raid-spullen én de beroeps-reagents (handelaar-spul niet)?
- [ ] Vallen de tabbladen niet van je scherm als het venster helemaal bovenaan staat?

## 🆕 7 okt — raid-herinnering (Rob koos hem)

Gebouwd, niet getest. Staat standaard AAN; `/mh ready remind off` zet hem uit, `/mh ready remind` zegt de stand + laatste check.
- [x] ✅ Rob 7 okt: "deed het toen ik in een raid ging". Ga een raid-instance binnen (of laat de raidleider een ready check doen in een raidgroep) terwijl je iets mist →
  na ~3 s een toast "Klaar voor de raid? Je mist N ding(en) voor vanavond"? Klik → het venster opent?
- [ ] Niets missen → geen toast (`/mh ready remind` zegt dan "last check …: 0 missing").
- [ ] Niet vaker dan één keer per raid-bezoek, en bij ready checks hooguit eens per 10 minuten.

## 🆕 7 okt — keypad-commando's: één per scherm (Rob: "/mhrares", veilige vorm)

Gebouwd, niet getest (`Modules/KeypadCommands.lua`). 27 commando's: 24 schermen + /mhcraftshop, /mhready, /mhblock.
- [ ] `/mh keypad` → lijst in de chat (/mhrares Rares · /mhdelves … )?
- [x] ✅ Rob 7 okt: "meerdere /mh geprobeerd en die werken". `/mhrares` (of via je keypad) → MH-venster opent op Rares? Ook `/mhaccount`, `/mhprofessions`, `/mhcraftshop`.
- [ ] Botst er iets met een andere addon (een /mh…-commando dat iets anders doet)?

## 🔍 7 okt — meting: welke kwaliteit met zilver of goud? (`/mh craftshop quality`)

Voor de keuze "welke kwaliteit kopen" (`docs/CRAFTSHOP_QUALITY_2026-10-07.md`, varianten a/b/c — Rob kiest daarna).
- [ ] `/reload`, beroepsvenster NIET openen, recepten op je lijst (bv. de Smuggler's Shoulderguards) → `/mh craftshop quality`.
  Per recept een chatregel "none = … | silver = quality … | gold = quality …". Daarna nog eens met het venster OPEN.
- [ ] `/reload` → ik lees `craftShopQuality`. Zeg erbij of je het gouden leer/de schubben zelf hebt (de regel noemt ook
  "you own N" per gouden reagent).
- [x] ✅ Rob 7 okt (screenshot): "Codified Azeroot: Kwaliteit 1 met zilver of goud: koop zilver (van 2)" en "Hobbyist
  Alchemist's Mixing Rod: met zilver 2 · met goud 4 · alleen Azeroot in goud 3 (van 5)". **Variant b, al gebouwd** (Rob: "waarom niet ook b nu?"): onder een recept dat je kent een blauw regeltje
  "Kwaliteit met zilver: 2 · met goud: 4 · alleen <reagent> in goud: 3 (van 5)", of "… met zilver of goud: koop zilver".
  Antwoordt het spel niet, dan staat er NIETS (zo bedoeld) — dan zegt `/mh craftshop quality` waarom.
- [ ] **Variant a:** Academy → hoofdstuk Kwaliteit, onderaan "Welke koop je dan? …".

## 🆕 7 okt — boodschappenlijst: "+N op alts" (Rob koos het, onderweg)

Gebouwd, niet getest. Elk personage onthoudt bij inloggen (en als de tassen veranderen, max. 1× per 5 s) hoeveel het
heeft van de reagents op ALLE boodschappenlijsten: tassen + bank, níet de Warband-bank (die telt al mee).
- [x] Log één keer in op een alt die iets heeft van een reagent op je lijst (bv. Tranquility Bloom), terug naar je
  alchemist → bij die reagent "+N op alts" (alleen als je tekortkomt)? Muis erop: "Op je andere personages … Iceicebaby 50"?
  ✅ Rob 7 okt (screenshot): Tranquility Bloom 3/28 "+31 op alts", tooltip "Theexodus 31. Stuur het per post …".
- [x] "Koop N" blijft gelijk (alts tellen niet als "heb je al", het is een tip om te posten). ✅ zelfde screenshot: "Pluk 25".

## 🆕 7 okt — dispel-hercontrole: A, B, C (Rob koos alle vier; D pas na 14 okt)

Achtergrond: `docs/DISPEL_RECHECK_2026-10-07.md`. De deur voor zelf debuffs lezen blijft dicht; dit zijn kleine metingen.
- [ ] **A (jij/Cisca, niets gebouwd):** een dungeon in een groep met `/mh partytargets` aan. Licht je eigen of andermans
  rij rood op ("DISPEL")? Screenshot van de MH-rij én Blizzards raid frame op hetzelfde moment. Niet rood terwijl er iets
  op zit: `/mh glow`.
- [ ] **B (gebouwd, niet getest):** na elk gevecht in een groep (met `/mh partytargets` aan) bewaart MH je eigen debuffs door
  drie filters: raid (= de rode rij), rpd (iemand in je groep kan het), any (heeft een dispel-type). Na een dungeon:
  `/reload` → ik lees `dispelSelfLog` en zie welk filter de valse alarmen (Magic op een Prot Paladin) niet geeft.
- [ ] **C (gebouwd, staat UIT):** `/mh dispelsound test` → hoor je een klok? `/mh dispelsound on` → chat "N of M spells
  registered"? Dan in een dungeon: piept het als JIJ een debuff krijgt die je zelf kunt weghalen? `/mh dispelsound why`.
  Werkt alleen met debuffs die MH al eens zag (dispelCapture, gevuld in dungeons). Uitzetten: `/mh dispelsound off`.

## 🆕 6 okt avond — Moxie zichtbaar (alle 11 nummers door het spel bevestigd, `/mh moxie`)

Deze regels stonden sinds 19 jul bewust UIT (alle geraden nummers waren fout). Nu voor het eerst aan:
- [x] Rob 6 okt ✅ (screenshot: "Artisan Alchemist's Moxie 25", "Artisan Herbalist's Moxie 460") MH-hoofdvenster → tabblad **Professions** ("Profession Treasures and Books"; NIET het paneel naast je beroepsvenster,
  GEMETEN in Profession.lua:707/1180): regel "Artisan Alchemist's Moxie  25" (jouw saldo)?
- [ ] Recept-tooltip bij een Moxie-recept (Camberon's Cauldron / renown-handelaar): kosten tegen je saldo — klopt het?
- [ ] Alt-overzicht: muis over een personage → Moxie-regel in de tooltip?
- GEMETEN Rob 6 okt (2 screenshots): rijen "Artisan Alchemist's..." 25 en "Artisan Herbalist's M..." 460 stonden er,
  maar tussen de Mistcrests en afgekapt — Rob: "ik zie het niet zo snel die moxie hier". Nu: Moxie uit Valuta (in de
  snapshot), en een gouden regel **"Moxie"** direct onder elk beroep bij Beroepen.
- [x] Rob 6 okt ✅ ("ja die vallen direct op") `/reload` → Account snapshot → Beroepen: onder Alchemy een gouden "Moxie"-regel met 25 bij dit personage, onder
  Herbalism 460? Alts met dat beroep: "?" tot ze één keer ingelogd zijn. Geen Moxie-regel onder Cooking/Fishing.
- [ ] **Account snapshot** (Rob: "Moxie-rij erbij"): onder Currencies een rij per Moxie-soort die iemand op je account heeft
  (bv. "Artisan Herbalist's Moxie" met 460 bij dit personage)? Een alt laat pas een getal zien nadat hij één keer
  ingelogd is na deze versie (tot dan een streepje). Ook in Tools → Currencies, met de uitleg "De eigen valuta van dat beroep…".

## 🆕 6 okt avond — healers: "Zo vecht je alleen" (Rob, Resto Druid: "hoe weet ik welke knop ik moet gebruiken?")

Gebouwd, niet getest. Volgorde = Blizzards eigen Single-Button Assistant (`docs/HEALER_SOLO_DAMAGE_2026-10-06.md`).
- [ ] Resto Druid → `/mh play`: onder "Zo heal je" een blokje **"Zo vecht je alleen:"** met 1. Sunfire [toets] 2. Moonfire
  [toets] 3. Starsurge 4. Wrath [5] 5. Starfire (alleen spells die je hebt)? Staat er "(niet op je balken)" bij iets?
- [ ] `/mh block` op de healer: schade-spells met een **rode rand**, en onderaan de regel "Rode rand = een schade-spell"?
- [ ] Een andere healer (Holy Paladin / Disc / Resto Shaman …): klopt de lijst daar ook?
  GEMETEN Rob 6 okt (screenshot Earthshammy, Resto Shaman): kaart "Zo vecht je alleen: 1. Flame Shock [Ctrl 2] 2. Lava Burst
  [5] 3. Lightning Bolt [Ctrl 1] 4. Chain Lightning [Shift 4]" ✅; legenda-regel onder het blok ✅. ✅ Rob: "de damage spells
  hebben een rode rand". Print (site /keyblock/): site-chat gevraagd om een zwart-wit-bestendige markering.

## 🆕 6 okt avond — "welke van je personages kennen dit recept?" (Rob: "neem wel het idee over", zonder MyRecipeTracker)

Stap 1 gebouwd, niet getest: bij het openen van een beroep onthoudt MH per personage welke recepten het kent
(`ns.db.craftShopKnown`, account-breed). De tooltip zelf komt na het onderzoek (welk item leert welk recept).
- [ ] Log op een paar personages in en open op elk één keer hun beroep(en). `/mh craftshop why` → regels "known recipes
  noted for <naam>: N" voor elk personage dat je zo langs ging?
- [ ] **Tooltip** (stap 3 gebouwd: 314 recept-items uit Blizzards data, `Modules/CraftShopRecipeItems.lua`): muis op een
  Midnight-recept (tas, veilinghuis, of een link in de chat) → groen "MH Kennen dit al: <namen in klassekleur>" en/of geel
  "MH Hebben het beroep, dit recept nog niet: <namen>"? Bij een recept van een beroep dat niemand heeft: geen MH-regel.
  Voorbeeld uit het onderzoek: item 256636 = Pattern: Row Walker's Deflectors (Leatherworking).

## 🔍 6 okt — meting vóór boodschappenlijst v2 (`/mh craftshop probe`; Rob: "maak die meetcontrole maar")

Voor: recept-bron, tussenproducten (en later kwaliteit). Schrijft naar `ns.db.craftShopMeasure` (open + closed).
- [ ] Zet 1-2 recepten op je lijst. Beroepsvenster OPEN → `/mh craftshop probe`. Chatregel met "window OPEN"?
- [ ] Beroepsvenster DICHT → `/mh craftshop probe` opnieuw ("window CLOSED"). Dan `/reload` → ik lees het bestand.

## 🆕 6 okt — Holy Paladin: Hand of Reckoning + Shield of the Righteous op blok D (Rob: "laat ze maar op de D blok staan")

GEMETEN (screenshot 15-key-block, Twelveinchy Holy): rode regel "(2): Hand of Reckoning, Shield of the Righteous".
Nu `blockAs[65].onlyD` (geen rode regel meer, wel een Alt-toets op D); SotR's survival alleen voor Prot (tabel).
keyblock_specs: A/B/C van 65/66/70 ongewijzigd (GEMETEN).
- [ ] Holy `/reload` → `/mh block`: rode regel weg, de twee op een vrije Alt-toets van D? Stay alive-kaart van Holy zonder SotR?

## 🆕 6 okt — Mage (Iceicebaby) na de blok-D-reparatie

- [x] Rob 6 okt ✅ (2 screenshots) Frost: Blizzard op Shift 2; Fire: Flamestrike op Shift 4; blok D alleen eigen spul
  (items, portal-macro's), geen vreemde spreuk.
- GEMETEN: rode regel noemde 30/31 Portals en Teleports (komen uit de flyout-scan) + bij Fire "Cone of Cold".
  Gerepareerd: spreuken uit een flyout tellen niet als "onbekend" (`ns._mhFlyoutSpells`). Cone of Cold bij Fire: Rob kiest.
- [x] Rob 6 okt ✅ (screenshot Fire: rode regel "(1): Cone of Cold") Mage `/reload` → rode regel zonder Portals/Teleports.
- GEMETEN (SV, Fire-snapshot): de laatste Place raakte D niet; de 5 losse portals stonden er al (eerdere Place/4.7.2,
  AFGELEID). Rob: "het uitschuif-icoontje gebruiken". Gebouwd, NIET getest: flyouts zonder geclassificeerde of
  bewust-toetsloze spreuk → het uitklapknopje op een vrije Alt-plek van D (PickupSpellBookItem); losse kopieën van
  hun spreuken gaan van balk 1 en D af zoals dubbelen (Undo zet terug). Cone of Cold Fire/Arcane = alleen D.
- [x] Rob 6 okt ✅ (2 screenshots) Undo → neerzetten: losse portals weg, Portal (Alt E) en Teleport (Alt C) als
  uitklapknop (klappen open), Cone of Cold Alt Q. Undo zette alles terug.
- GEMETEN zelfde screenshot: "no place"-regel noemde ook "Frostbolt of Ages" en "Word of Recall (OLD)" → AFGELEID
  General-tab-flyouts; nu alleen flyouts buiten de General-lijn.
- [ ] Mage `/reload` → `/mh block`: noemt de regel onderaan die twee nog?

## 🔴 6 okt — Prot Paladin: verkeerde spreuk op blok D (Warband Map op Alt 1)

GEMETEN in SV: namen gesorteerd, ids niet → elk onbekend id hoorde bij een andere naam. Gerepareerd (56bab86).
Robs screenshot daarna: nog steeds Warband Map / Lift Off / Aerial Halt op Alt 1/3/4 — AFGELEID: test vóór `/reload`.
- [x] Rob 6 okt ✅ (screenshot na `/reload`: Concentration/Crusader/Devotion Aura + 3 Overload-herbs op D, juiste
  iconen) `/reload` → staan de onbekende spreuken zelf op D?
- Rob: "ja doe maar geen toets" → auras en Overload-herbs in NO_KEY_ON_PURPOSE.
- [x] Rob 6 okt ✅ (screenshot: D leeg op zijn macro DUNDUN na, "Every spell Midnight Helper knows for this spec has a
  place", geen rode regel) Prot Paladin `/reload` → Undo → neerzetten: blok D zonder auras/herbs?

## 🆕 6 okt — `/mh ready`: "Je gear" (enchants + lege sockets) en "onderweg" (Rob: "1 en het onderweg-trucje ook")

Gebouwd, niet getest. Onder de consumables een kopje met alleen wat ONTBREEKT: per slot zonder enchant de eerste keus
van de Enchants-tab ("(keuze)" als er meer opties zijn), en lege sockets (Eversong Diamond als je er geen draagt + de
gem voor je stats). Zelfde klik/shift-klik/Auctionator. Onderweg: wat je op de AH koopt telt meteen als "+N in je post".
- [ ] Personage met een ontbrekende enchant of lege socket: staat het kopje er, met de goede naam en "Koop 1"?
- [ ] Klik bij het veilinghuis op een enchant-rij → zoekt "Enchant Ring - Eyes of the Eagle" (bv.)?
- [ ] Naar Auctionator: staan de enchants/gems ook in de lijst?
- GEMETEN Rob 6 okt (screenshot): gear-kopje staat er (8 rijen, "(a choice)", Buy 1/2/3) ✅, Auctionator-lijst met
  enchants en gems ✅. Maar Enchant Weapon - Arcane Mastery gekocht → NIET als "+1 in je post". Tweede weg gebouwd
  (Confirm/StartCommoditiesPurchase onthouden, tellen bij COMMODITY_PURCHASE_SUCCEEDED) + meting `ns.db.raidShopProbe`.
- [ ] Koop iets op de AH en kijk METEEN (zonder brievenbus) in `/mh ready`: "+N in je post"? Daarna `/reload` → ik lees
  `raidShopProbe`.
- [ ] Alles in orde → is het kopje weg?

## 🆕 6 okt — `/mh ready`: brievenbus en bank tellen mee (Rob: "ja doe maar allebei")
- [x] Rob 6 okt ✅ (screenshot Hunter Redisch: "+30 in mail" bij beide potions, "+7 in bank" bij Food, status "Pick it
  up"; Flask "Enough") brievenbus en bank.

Gebouwd, niet getest. Per rij een klein regeltje "+N in je post" / "+N op de bank" (bank = bank + Warband-bank). Ligt
genoeg klaar, dan staat er geel **Ophalen** in plaats van **Koop**. De post kent MH pas na één bezoek aan de brievenbus.
- [ ] Koop iets op de AH, open de brievenbus (niet ophalen), dicht → `/mh ready`: "+N in je post"? Status "Ophalen"?
- [ ] Haal het op: verdwijnt "+N in je post" en telt het bij je tas?
- [ ] Iets op de bank / Warband-bank, bank DICHT, na `/reload`: "+N op de bank"? (Niet gemeten of dat dicht werkt.)
- [ ] Naar Auctionator koopt alleen nog wat écht ontbreekt?

## 🆕 6 okt — `/mh ready`: items klikbaar (Rob: "ik wil ze alle 4")

Gebouwd, niet getest. Onderaan het venster staat nu een regel die het uitlegt.
- GEMETEN Rob 6 okt (screenshot): klikken bij het veilinghuis zoekt meteen ✅; "Naar Auctionator" maakt de lijst
  (Concentrated Silvermoon Health Potion x30, Potion of Recklessness x30, Hearty Royal Roast x4) ✅. Maar: Hearty Royal
  Roast niet gevonden, en Food + Healthstone bleven "…" (klik deed dan niets). Gerepareerd: venster luistert nu ook naar
  ITEM_DATA_LOAD_RESULT; Healthstone-rij reageert bewust niet op klikken.
- GEMETEN Rob 6 okt: "royal roast" → Royal Roast + Impossibly Royal Roast, géén Hearty Royal Roast; Void-Touched Augment
  Rune wel op de AH maar niet in de Auctionator-lijst (optioneel → bewust overgeslagen). Gerepareerd: Hearty-eten zoekt
  zonder "Hearty " (Auctionator niet-exact), rune gaat mee in de lijst.
- [x] Rob 6 okt ✅ (screenshot: lijst met 4 regels, Royal Roast niet-exact → Royal + Impossibly Royal Roast, rune x29)
  Naar Auctionator: 4 regels (ook de rune), food niet-exact?
- Rob: "andere char → wat gebeurt er met de lijst?" Gerepareerd: lijst heet nu "MH raid - <naam>" (zelfde naam wist
  de oude lijst). De oude lijst "Midnight Helper raid" mag je zelf weggooien.
- [ ] Op een tweede personage `/mh ready` → Naar Auctionator (zonder veilinghuis): eigen lijst "MH raid - <naam>",
  en de lijst van het eerste personage staat er nog?
- [ ] **Bij het veilinghuis** (Blizzards eigen tab): klik op een rij → zoekbalk krijgt de naam en hij zoekt meteen?
  Ook als je op het Auctionator-tabblad stond (hij moet dan naar Buy springen)?
- [ ] **Zonder veilinghuis:** klik op een rij → onderaan "Ctrl+C om te kopiëren:" met de naam geselecteerd? Ctrl+C en
  plakken in de AH-zoekbalk werkt?
- [ ] **Shift-klik** op een rij → link in de chat?
- [ ] Knop **Naar Auctionator** (alleen te zien met Auctionator): bij het veilinghuis → Auctionator zoekt alles wat je nog
  moet kopen, met het aantal? Zonder veilinghuis → lijst "Midnight Helper raid" in Auctionator → Shopping?
- [ ] Worden potions gevonden, of filtert iets ze weg (een gekozen categorie links, je eigen filters)?

## 🐛 6 okt — Hunter: "New for your key block: Primal Rage -> F1" bij elke huisdierwissel

GEMETEN (Robs screenshot via site-chat). Oorzaak AFGELEID: de knop houdt Command Pet 272651, met een Ferocity-huisdier
wordt die Primal Rage 272678, en MH zag 272678 als "nog niet op het blok". Gerepareerd in `MissingRows`: wat een knop
wórdt (override) telt ook als aanwezig.
- [x] Rob 6 okt ✅ ("de popup bij de hunter komt niet meer terug") `/reload` op je Hunter, wissel een paar keer tussen
  Ferocity en Cunning: komt de popup nog?

## 🆕 4 okt middag — Stay alive: elke rij heeft nu een spell-id (verzoek site-chat)

Wat er veranderde: 113 rijen kregen `id = …`, Ignore Pain (Prot) ook; Blink, Roll en Dash kregen `survivalId`
(zodat je toetsen niet verschuiven). Paladin en Warlock veranderden niet. Het spel zoekt de spell nu op **nummer**
in plaats van op naam. Een fout nummer laat een rij **stil verdwijnen** — daarom deze test vóór de release.

Per personage (hoe meer klassen, hoe beter; vooral **Druid, Mage, Monk, Warrior, Priest, Evoker, Shaman, Demon Hunter**):
- [ ] `/mh play` → **Stay alive**: staan dezelfde rijen er als gisteren? Niets weg dat je wél hebt?
- [ ] `/mh survival`: kijk naar de **rode `-`-regels**. Staat er `not known (<getal>)` of `not found by id <getal>` bij
  een spreuk die je **wel** op je balk hebt? Dan is dat nummer fout → stuur me die regel (screenshot mag).
- [ ] **Mage:** met Shimmer gekozen: staat er **één** Shimmer-regel (niet ook Blink)? Mirror Image alleen met
  Refractive Images.
- [ ] **Monk** met Chi Torpedo / **Druid** met Tiger Dash: één regel, niet twee.
- [ ] **Warrior** met Impending Victory: één heal-regel, niet Victory Rush én Impending Victory.
- [ ] **Demon Hunter Devourer** (als je die hebt): staat **Shift** er nu (id 1234796, uit Blizzards data, nooit in
  het spel gezien)?
- [ ] **Toetsen:** `/mh apply` dry run op een Mage, Monk of Druid: zelfde voorstel als vóór vandaag? (De ids mogen
  geen toets verschuiven; AFGELEID, niet gemeten.)
- [ ] Alles goed → zeg het, dan mag de site-chat de bouwer draaien (37 nieuwe "Blijf leven"-blokken).

## 🆕 4 okt middag — toetsenblok: het plaatje (`/mh block`) en de Edit Mode-proef

Rob: "Je mag gaan bouwen." Gebouwd: alleen het **plaatje**. Er verandert niets op je balken.
- [ ] `/mh block`: opent een venster met **3 balken van 3×4**, elke plek met toets, icoon en naam. Klopt het met het
  plan (1 hoofdknop, E kick, Z/X/C verdediging, T potion, G trinket)? Muis over een plek = tooltip met de taak.
- [ ] Onderaan: "Geen plek in het blok (…)": wat staat daar? (Verwacht: hulp-spells zoals Mark of the Wild of Revive.)
- [ ] **Druid:** staan Bear/Cat/Moonkin Form op **Ctrl 1/2/3**?
- [ ] **Q = grote cooldown.** Komt pas goed als het onderzoek per spec erin zit (zie NEXT_SESSION). Tot dan staat er de
  eerste cooldown van de spec.
- [ ] `/mh block why`: één regel per plek met de reden. Schrijft ook naar je SavedVariables (`keyBlockProbe`).

**Edit Mode-proef** (vóór MH ooit zelf balken op 3 rijen zet; zorg dat je NIET in een gevecht bent):
1. Esc → Edit Mode: staat bovenaan **jouw eigen** layout (niet "Modern" of "Classic")? Sluit Edit Mode.
2. `/mh editmode export` → er opent een vak met een tekst. Kopieer die (Ctrl+C).
3. `/mh editmode import` → plak dezelfde tekst (Ctrl+V) → knop **Apply bars**. Dan `/reload`.
4. [ ] Staan al je balken nog precies waar ze stonden? Bestaan "Modern" en "Classic" nog in de lijst van Edit Mode?
   Foutmelding? (Je hebt je eigen balken teruggezet, dus er hoort **niets** te veranderen.)
5. Als er wél iets veranderde: `/mh editmode restore` en `/reload`, en stuur me een screenshot.

## 🆕 5 okt laat — wat op A/B/C geen plek heeft, gaat naar een VRIJE Alt-toets op blok D (Rob: "ja, bouw het zo")

Rob: "het zijn inderdaad 2 macros" (Moonfire/Dispel op D = macro's, MH laat macro's staan). Gebouwd in `PlacePlan`:
na het opzij zetten krijgen spreuken zonder plek (Mark of the Wild, Revive, Arcane Intellect, rez...) een LEGE plek op D;
staat de spreuk al op D, dan niet nog eens. Undo haalt ze eraf. Tekst onderaan zegt het nu ("komen op een vrije Alt-toets").
- GEMETEN 5 okt (chat-probe op Robs Guardian): "block D: nothing placed — Mark of the Wild: no free place left on D
  (free on D: 0)". Oorzaak: bij het plannen zit D nog vol (Undo zette alles terug); de 14 dubbelen gaan pas eraf bij
  Place. Gerepareerd: een D-plek met een kopie van een blokspreuk telt als vrij.
- [x] Rob 5 okt ✅ (chat: "block D: Mark of the Wild -> ALT-Q, Revive -> ALT-E (free on D: 7)") Guardian: Undo → Zet het
  op balk 5, 6 en 7 → staan Mark of the Wild en Revive nu op een Alt-toets in D?
- GEMETEN: Mark of the Wild daarna TWEE keer (Alt Q + Alt X): hij werd ook als oude knop van balk 6 naar Alt X geparkeerd.
  Gerepareerd: een spreuk die naar D geparkeerd wordt, telt als "al op D".
- [x] Rob 5 okt ✅ (screenshot: Mark of the Wild alleen Alt X, Revive Alt Q) Guardian nog eens Undo → neerzetten: Mark of
  the Wild nog maar één keer?
- [ ] Je eigen spul op D (macro's, Healthstone, Flask) blijft gewoon staan?
- [ ] Undo: verdwijnen ze weer van D?

## 🆕 5 okt nacht — Warlockie: nieuwe spreuken aangeboden; gedeelde layout niet meer "klaar"

GEMETEN (Rob, inloggen op Warlockie, lvl 82): venster "Grimoire: Fel Ravager -> Shift 3, Shadowfury -> Shift F, Demonic
Circle -> Shift C". Rob: "als we vaker twelve retro tegen komen op een andere character dan moeten we dat zien te
voorkomen!!" → stap 2 van het stappenplan is op een preset of GEDEELDE layout nooit meer afgevinkt, ook niet als die
layout al een blok is; de knop biedt dan "Eigen layout + blok".
- [x] Rob 5 okt ✅ (screenshot: knop "Put "Warlockie Demonology" back", blok met Fel Ravager Shift-3, Summon Doomguard
  F1, Shadowfury Shift-F, Demonic Circle; geen rode regel) Warlockie: eigen layout + blok.

## 🆕 5 okt nacht — onbekende spreuken gaan vanzelf naar een vrije Alt-plek op blok D (Rob: "ja, bouw het zo")

- [ ] Op een personage met een rode regel: `/reload` → Undo → neerzetten. Staan de genoemde spreuken nu op Alt-toetsen?
  Chat "block D: …" noemt ze. Komt er rommel op D (skyriding, Warband)? Dan screenshot.
- [ ] Of zonder Undo: komt het venster "Nieuw voor je toetsenblok: … -> Alt …" en werkt Place it?

## 🆕 5 okt laat — Resto Druid: blok goed; Heart of the Wild + Stampeding Roar alleen op blok D

GEMETEN (Robs Resto): heals 1-4, Wild Growth/Nature's Swiftness, Moonfire Shift-2, Sunfire Shift-C, Innervate F3, Revive
Alt 1. Rode regel: 7 bewust weggelaten spreuken. Gebouwd: `blockAs[spec].onlyD` (KeyBlockAllocate) = nooit A/B/C, meteen
naar een vrije Alt-plek op D; Heart of the Wild + Stampeding Roar krijgen dat voor 105. Cat/bear-aanvallen en Starfire in
`NO_KEY_ON_PURPOSE`. Standaardblok Resto: nog steeds 29 plekken (niets weggeduwd).
- [x] Rob 5 okt ✅ (nieuwe-spreuk-venster "Stampeding Roar -> Alt 2, Heart of the Wild -> Alt 3", daarna op het blok)
  Resto: Heart of the Wild en Stampeding Roar op een Alt-toets?
- Rode regel noemde nog Frenzied Regeneration → nu ook onlyD voor 102 en 105 (staat op hun Stay alive-kaart).
- [ ] Resto en Balance na /reload: Frenzied Regeneration aangeboden voor een Alt-toets? Rode regel weg?

## 🔍 5 okt laat — Robs Guardian Druid (Purlymixanox): blok goed, 2 zonder plek, 5 "onbekend"

GEMETEN (screenshot): bear-rotatie op 1-4, Barkskin/Ironfur/Survival Instincts, Prowl F3, Dash Shift-F1 — goed.
Rode regel: "geen plek (2): Mark of the Wild, Revive" terwijl 5, Shift-2 en Ctrl-3 leeg zijn (overloop kent alleen vaste
plekken; ontwerpvraag aan Rob, 2e keer gesteld). "Onbekend (5): Rake, Regrowth, Sharpen Your Knife, Shred, Wrath" →
bewust zonder toets voor Guardian → in `NO_KEY_ON_PURPOSE`. Moonfire staat ook op D Alt 2: Undo gedaan? (gevraagd)
- [ ] Guardian na `/reload`: rode "onbekend"-regel weg?

## 🔍 5 okt laat — Reddish (BM): dubbelen op blok D + ruis in de rode lijst

GEMETEN (screenshot): D (Alt) houdt kopieën van blokspreuken (Exhilaration Alt 3 + F2, Bestial Wrath Alt 1 + Q, Mend
Pet, Recuperate, Flare ...): blok neergezet vóór de opruim-reparatie van vanavond → Undo + opnieuw neerzetten.
De rode lijst noemde nog skyriding/Warband (General-tab-filter ving ze NIET, of Rob had nog niet herladen — onbekend) en
Hunter-dingen die bewust geen toets krijgen. Nu ook een namenlijst `NO_KEY_ON_PURPOSE` (KeybindAutoMap.lua).
Rob 5 okt: demonen/curses/buffs/out-of-combat **"laat zoals het is"** (mijn advies).
- [x] Rob 5 okt ✅ (screenshot: D houdt alleen eigen spul — flyouts, Healthstone, Disenchant) Reddish: Undo → Zet het op
  balk 5, 6 en 7 → staan Exhilaration, Bestial Wrath enz. nog maar één keer?
- [x] Rob 5 okt ✅ ("Every spell Midnight Helper knows for this spec has a place", geen rode regel) Rode regel na
  `/reload`: geen skyriding, Warband of Feed Pet meer?
- [x] Rob 5 okt ✅ Nieuwe-spreuk-venster na reload: "Wing Clip -> Shift Z" (Wing Clip kwam uit de gatenronde). Na Undo +
  opnieuw neerzetten staat hij op Ctrl 1: Bijwerken zet een nieuwe spreuk op de eerste vrije overloopplek, een volledige
  plaatsing rekent alles opnieuw. Verwacht gedrag.

## 🆕 5 okt laat — gatenronde alle klassen: ~100 spreuken erbij, ~20 oude eruit

AFGELEID uit het standaardblok (alle talenten tegelijk); in het spel heeft een speler maar één kant van elke keuze.
- [ ] Op elk personage dat je hebt: Terugzetten → Zet het op balk 5, 6 en 7. Staat de rode regel "MH kent deze nog
  niet" er nog? Welke namen? (Verwacht: alleen dingen die we bewust lieten liggen, zoals Summon Felguard.)
- [ ] Is er een BELANGRIJKE spreuk van je blok verdwenen die er eerst wél op stond? (Kijk vooral: Feral Prowl/Dash,
  Destruction Havoc, Mistweaver Mana Tea, Resto Shaman Ghost Wolf.)
- [ ] Je Warlock (Demonology): Summon Doomguard, Grimoire: Fel Ravager/Imp Lord, Power Siphon, Demonic Circle,
  Shadowfury op het blok?

## 🔍 5 okt avond — Robs Warlock (Demonology, level 82, "twelve retro"): "Put twelve retro back" + 30 onbekende spreuken

GEMETEN (screenshot): de rode regel werkt al lokaal: "Not known to Midnight Helper yet (30)". De helft is ruis uit het
algemene tabblad (Auto Attack, skyriding, Warband, Revive Battle Pets); de rest zijn echte Warlock-gaten: o.a. **Summon
Felguard**, Shadowfury, Curse of Weakness/Tongues/Exhaustion, Fel Domination, Grimoire: Fel Ravager, Demonic Circle,
Summon Imp/Felhunter/Sayaad, Subjugate Demon, Unending Breath, Ritual of Summoning/Doom, Eye of Kilrogg.
Gebouwd: de rode lijst slaat het eerste spellbook-tabblad (General) over (AFGELEID: regel 1 = General).
"Put twelve retro back": geen fout van Rob — twelve retro is een gedeelde layout die zijn Paladin al als blok had gezet;
de knop zegt nu **(alle personages)**.
- [ ] Warlock na `/reload`: rode regel zonder skyriding/Auto Attack/Warband? Alleen echte Warlock-spreuken?
- [ ] Knop heet nu "Zet "twelve retro" terug (alle personages)".

## 🐛 5 okt avond — Fury of Elune (Balance) kreeg geen plek; het blokvenster zei toch "elke spell heeft een plek"

GEMETEN (Rob, Carola's pc, tooltip): Fury of Elune staat in de Single-Button Assistant, maar niet in
`KeybindRoles_Druid.lua` → geen rol → geen plek. Gebouwd: het blokvenster noemt nu onderaan in het rood welke spreuken MH
nog niet kent (`KEYBLOCK_UNKNOWN_FMT`, zelfde lijst als `/mh binds`). mh-research zoekt alle ontbrekende Balance-spreuken.
- GEBOUWD (mh-research, wago 12.1.0.69933): Balance kreeg Fury of Elune, New Moon, Force of Nature, Wild Mushroom, Solar
  Eclipse, Symbiotic Relationship; Convoke, Mass Entanglement, Incapacitating Roar, Stampeding Roar en Heart of the Wild
  (op het blok als defensive) gelden nu ook voor 102. Bewust niet: Hibernate, en heals (Regrowth/Rejuvenation/Wild
  Growth/Frenzied Regeneration) die in Bear/Cat werken of al op de Stay alive-kaart staan.
  ⚠️ Het site-standaardblok rekent met ALLE talenten (ook beide kanten van 6 keuzes): 10 zonder plek. Een echte Balance
  Druid heeft er ~6 minder. AFGELEID.
- Stampeding Roar voor 102 weer eruit: hij pakte Shift-X en Revive viel van het blok (doorgerekend met Carola's spreuken).
  Doorgerekend (`ns.KeyBlockAllocate`, haar spreuken uit `/mh binds` + Fury of Elune): **Fury of Elune → F1**, **Heart of
  the Wild → X**, rest gelijk (Revive F3). Met Solar Eclipse: **Shift-3**. ⚠️ Met Solar Eclipse + Force of Nature valt
  Revive van het blok terwijl C, F2 en Shift-2 leeg blijven (de overloop gebruikt alleen vaste plekken) — ontwerpvraag Rob.
  Rob zet het vanavond met de hand op Carola's pc (geen update daar).
- [ ] Na de volgende update, Carola: Terugzetten → opnieuw neerzetten. Staat **Fury of Elune** nu op het blok
  (verwacht F3 of een andere cooldown-plek)? En staan Revive, Dash, Prowl er nog?
- [ ] Op Carola's pc (4.7.1): `/mh binds` → de regel met de spreuken die MH niet kent → screenshot.
- [ ] Na de volgende update: `/mh block` op een Balance Druid → rode regel onderaan met Fury of Elune (tot hij erin staat).

## 🆕 5 okt avond — `/mh ready` = venstertje "Klaar voor de raid?" (Rob: "ja doe maar")

Nieuw: `Modules/RaidShoppingList.lua`. Bovenaan twee knoppen **Nieuwe baas leren** / **Farm (bekende bazen)**. Per rij:
icoon, het item voor jouw spec, *wat je hebt / wat je nodig hebt*, en rood **Koop N**. Aantallen (4 uur, AFGELEID):
leren = healing 30, combat 30, flask 4, food 4, rune 30 (optioneel); farm = 15 / 16 / 4 / 4 / 0. Healthstone: "gratis
van een Warlock". De oude chatregels: `/mh readycheck`. Ook: ketel-flasks (Fleeting) en Demonic Healthstone tellen nu mee.
- [ ] `/mh ready`: opent het venster? Klopt het aantal healing potions met je tas?
- [ ] Wissel **Farm** ↔ **Nieuwe baas leren**: veranderen de aantallen? Onthoudt hij je keus na `/reload`?
- [ ] Muis op een rij: tooltip van het item dat je moet kopen (beste kwaliteit)?
- [ ] Escape sluit het venster; slepen werkt.
- [ ] 6 okt vertaald (de/fr/es/pt/it). Op een andere taal (alleen als je zo'n client hebt): past "gratis vom
  Hexenmeister" in de kolom, en wordt "Noch keine Empfehlung…" niet afgekapt?

## 🐛 5 okt avond — mounts op balk 7 bleven staan (Carola's Duckiesan, 4.7.0)

GEMETEN (Robs screenshot van de balken): op blok C staan nog Carola's **mounts** waar het plaatje Revive (F3), War Stomp,
Starfall, Prowl, Dash, Ursol's Vortex en Remove Corruption zet. Oorzaak (code): alleen spell/item/macro mochten opzij;
een mount gaf "left alone". Nu mag alles opzij (een gewone sleep), Undo ruilt het terug. Ook bar 8 vol mounts = haar eigen.
Werkt pas na een update op haar pc. Tot dan: Terugzetten → mounts zelf van balk 7 af slepen → opnieuw neerzetten.
- [x] Rob 5 okt ✅ (Carola's Duckiesan op 4.7.1, `/mh binds`-venster: balk 7 = Revive F3, Prowl, Dash, Ursol's Vortex,
  Remove Corruption, Starfall, War Stomp; mounts op Alt 2/3/4 = blok D) Een personage met een **mount** (of toy) op balk
  5, 6 of 7: Terugzetten → Zet het op balk 5, 6 en 7. Gaat de mount naar blok D en komt de spreuk op zijn plek?
- [ ] En **Terugzetten**: staat de mount weer waar hij stond?

## 🔍 5 okt avond — Druid Balance (Duckiesan, pc van Robs zusje): Revive op F3? Kaart zei "F8"

Rob las op de speelkaart (tabblad Groep) "Revive [F8]", terwijl het blok Revive op **F3** zet. Mijn eerste gok ("een 3
in klein font") was FOUT: Rob keek van dichtbij, er staat echt **F8**. Waar F8 vandaan komt is NIET gemeten. Gerepareerd
wat zeker fout was: met het blok neergezet won een kopie op balk 1 (ACTIONBUTTON, rang 0) van het blok; nu blok eerst,
dan balk 1, dan de rest (`LiveKeys.lua`). Of dat de F8 verklaart, zegt alleen `/mh playkeys`.
AFGELEID na de balk-screenshot: op F3 staat een MOUNT, niet Revive (zie hierboven). Revive staat dus alleen op een
eigen knop van Carola met F8 — de kaart had gelijk. Ook open: **G** (trinket)
lijkt op de echte balk leeg terwijl het plaatje een trinket toont.
- GEMETEN 5 okt (Rob op Carola's Duckiesan, `/mh playkeys`): **Wrath** "not on a bound button of the standard bars",
  terwijl het blok Wrath op 1 heeft. Gerepareerd (`LiveKeys.lua`): laatste terugval = dezelfde spreuknaam in deze client.
  Revive-regel stond niet op de screenshots.
- [ ] Na de volgende update op Duckiesan: Wrath **[1]** op de kaart? En `/mh playkeys`, de regel bij **Revive**?
- [ ] (oud) Op Duckiesan: `/mh playkeys` → screenshot. Bij Revive staat de toets, het knopnummer (slot) en de balk (cmd).
  Zegt hij nu F3, dan was het de balk-1-kopie. Zegt hij nog F8, dan staat Revive niet echt op F3 → `/mh block why`.
  ⚠️ Haar pc heeft deze reparatie pas na de volgende release (of als ze MH van GitHub haalt).
- [ ] `/mh block why` → regel bij **C G**: welk trinket, en heeft ze een trinket met Use: aan?

## 🆕 5 okt avond — id-ronde: 361 spreuken kregen een nummer, en de addon zoekt nu eerst op NAAM

Wat er veranderde: 361 regels in `KeybindRoles_*.lua` kregen `id = …` (wago.tools 12.1.0.69933 + Wowhead, 3 × mh-research).
En de volgorde in `KeybindAutoMap.lua`: eerst naam, dan nummer (was: eerst nummer). Op een Engelse client hoort er dus
NIETS te veranderen. AFGELEID, niet gemeten.
- [x] Rob 5 okt ✅ (screenshot: A 1 Judgment, A 2 Avenger's Shield, A 3 Blessed Hammer (35395)) Paladin **Prot**: `/mh block why` — staat **Blessed Hammer** nog op zijn plek (de oude valkuil met id 35395)?
- [ ] Op 2-3 andere personages: `/mh block` → zelfde plaatje als vóór vanavond? Iets verdwenen of verschoven?
- [ ] Druid (als je die hebt) met **Incarnation**: staat hij als Incarnation, niet als Berserk / Celestial Alignment?

## 🆕 5 okt — speelkaart noemt de bloktoets, niet de reservekopie op balk D

GEMETEN op Robs screenshot (Discipline, Umbrion): Flash Heal op blok **3** én op D **Alt C**; de kaart zei [Alt C].
Ook Power Word: Shield (2 / Alt X) en Evangelism (Shift 4 / Alt E). Nu: met het blok neergezet tellen balk 1 en de
blokbalken A/B/C eerst.
- [x] Rob 5 okt ✅ (screenshot) `/reload`, "Zo speel je Discipline": Flash Heal **[3]**, Power Word: Shield **[2]**, Evangelism **[Shift 4]**?

## 🆕 5 okt — geen dubbele kopieën meer op balk D (Rob: "laat die dubbele kopieën gelijk opruimen")

Bij neerzetten: een spreuk die het blok zelf krijgt wordt niet meer naar D geparkeerd, en dubbelen die al op D stonden
gaan eraf (alleen spreuken; macro's en items blijven). Undo zet alles terug.
- [x] Rob 5 okt ✅ (screenshot: D houdt alleen Resurrection, Mass Resurrection, Healthstone, Plea) Discipline: **Undo** → **Zet het op balk 5, 6 en 7**. Staan Flash Heal, Power Word: Shield, Evangelism, Desperate
  Prayer, Angelic Feather, Psychic Scream, Mass Dispel en Recuperate nu maar **één** keer (in het blok, niet ook op D)?
- [ ] Chat: "… doubles off bar 1 and block D" met een getal.
- [x] Rob 5 okt ✅ **Undo** daarna: staat balk D weer zoals vóór het neerzetten?
- [x] Rob 5 okt ✅ Priest **Holy**: blok neergezet, heals op 1-4, niets dubbel op D, speelkaart-toetsen kloppen.
- [ ] Zonder blok (ander personage): dezelfde toetsen als vóór vandaag.

## 🆕 5 okt — `/mh export` geeft nu ook het item-nummer (voor Wowhead-tooltips op de Armory)

- [x] Rob 5 okt ✅ `/mh export`: elke regel eindigt nu op een nummer, bv. `…|0|0|||250123:12345:6789`. Geen foutmelding?
- [x] Rob 5 okt ✅ ("ik krijg het keurig te zien") Plak het op de Armory (oude site-versie): rekent hij nog precies zoals gisteren? (Hij hoort het nieuwe veld te negeren.)
- [ ] Pas als de site-kant er is: muis over een item → toont Wowhead **hetzelfde** item, met jouw item level?

## 🆕 5 okt avond — na "Nu herladen" opent het blokvenster vanzelf weer (Rob)

- [x] Rob 5 okt (Reddish): "alles goed gegaan". ✅ Druk een layout-knop → **Nu herladen** (in het venstertje of rechtsonder). Na het laden opent `/mh block` vanzelf,
  met het stappenplan, zodat je bij de volgende stap verder kunt. Een gewone `/reload` opent hem níet.

## 🆕 5 okt avond — gedeelde layout krijgt ook een eigen kopie (Rob, Reddish op "twelve retro")

- [x] Rob 5 okt ✅ Reddish (op "twelve retro", een account-layout): de middelste knop heet nu **Eigen layout + blok**. Druk →
  "Redisch Beast Mastery" (kopie van twelve retro), alleen voor Reddish/BM; je Paladin merkt niets. Nu herladen.
- [x] Rob 5 okt ✅ Je Cooldown Manager blijft bij zo'n kopie waar jij hem had (alleen kopieën van Modern/Classic tillen hem op).
- [x] Rob 5 okt ✅ Stappenplan: groene **vinkjes** zijn nu echte plaatjes (geen "|TI…").
- [x] Rob 5 okt ✅ (Ctrl+C werkte meteen, zonder klikken) Spiekbrief: klik eerst in de tekst, dan Ctrl+A, Ctrl+C (deed Ctrl+C iets anders, dan had het vak de focus niet).

## 🆕 5 okt avond — stappenplan boven het blokvenster (Rob: "waar moet ik beginnen?")

- [x] Rob 5 okt ✅ `/mh block` op Reddish: boven het venster een paneel **"Zo begin je, stap voor stap"** in grote letters, 6 stappen.
  De eerstvolgende stap is wit met een gouden cijfer; gedane stappen krijgen een groen vinkje en een grijze knop.
- [x] Rob 5 okt ✅ **Doe dit** bij stap 1 = hetzelfde als "Zet het op balk 5, 6 en 7"; stap 2 = layout-knop (+ Nu herladen-venster);
  stap 3 = muistoetsen; **Open** bij 4 = "Zo speel je"; bij 5 = spiekbrief.
- [x] Rob 5 okt ✅ Knop **Stappenplan verbergen** (bovenaan het venster) → paneel weg, venster weer in het midden; **tonen** → terug.
- [x] Rob 5 okt ✅ Past alles op je scherm (venster onderaan, paneel erboven)?

## 🆕 5 okt avond — healer-blok: elke spreuk van de speelkaart heeft een toets (Rob: "ja, advies")

Doorgerekend (data/keyblock_specs.json): Holy Pal 1 Holy Shock, 2 Flash of Light, 3 Holy Light, 4 Word of Glory, 5 Judgment,
Shift 1 Beacon, Shift 4 Light of Dawn, F1 Divine Toll, Q Avenging Wrath, F3 Holy Bulwark, F Beacon of Faith, F2 Lay on Hands.
- [ ] Holy: **Terugzetten → Zet het op balk 5, 6 en 7**. Klopt dit in het spel? `/mh block why`: krijgt **Holy Bulwark** F3
  (of meldt het spel hem onder Holy Prism's id 114165?), en **Beacon of Virtue** Shift 1? (AFGELEID, nog niet gemeten.)
- [ ] Speelkaart Holy: staat achter elke gele naam nu een [toets]?
- [ ] Het oude `/mh apply` geeft single-target heals nu ook een toets (bewust, Rob akkoord).

## 🆕 5 okt avond — speelkaart: toets achter elke spreuk + "Zo heal je" (Rob: "ik snap er helemaal niks van")

- [x] Rob 5 okt: Holy- en Prot-blok staan goed. ✅
- [ ] Holy: "Zo speel je Holy" → **Jouw knoppen**: staat achter elke gele spreuknaam de toets, bv. *Holy Shock [1]*,
  *Divine Toll [Shift 3]*, *Word of Glory [Alt E]*? Spreuken die niet op je balken staan: geen toets.
- [ ] Bovenaan bij een healer: groene regel **"Zo heal je:"** (klik op de balk van je vriend, dan de toets; niemand
  gekozen = jezelf). Niet bij Prot/Ret.
- [ ] Een andere spec bekijken (niet je actieve): geen [toetsen] achter de namen.
- Nieuwe teksten PLAYCARD_HEAL_HOW* alleen enUS + nlNL.

## 🆕 5 okt avond — terugzet-geheugen per spec (balken zijn per spec)

GEMETEN: Prot had het blok op de balken, Holy niet — actiebalken zijn per spec. Het geheugen is nu per personage + spec.
- [ ] Holy: `/reload`, `/mh block`. Staat er "Zet het op balk 5, 6 en 7" of "Bijwerken"? (Het oude geheugen gaat naar
  de spec waarvan de balken het bewijzen.) Wissel naar Prot: zegt het venster daar iets anders, passend bij Prot's balken?
- [ ] Per spec: blok neerzetten + Terugzetten raakt alleen de balken van die spec.

## 🆕 5 okt avond — volgende stap groot in beeld (Rob: "een noob weet niet wat hij nu moet doen")

- [ ] Na **Eigen layout + blok**, **Zet mijn balken als blok**, **Zet "…" terug** of **Toon/Verberg oude balken**: komt er
  midden in beeld een venstertje "Je balken zijn opgeslagen. Druk op Nu herladen …" met **Nu herladen** / **Later**,
  bovenop het toetsenblok-venster? Werkt **Nu herladen** daarin?
- Nieuwe tekst KEYBLOCK_RELOAD_POPUP alleen enUS + nlNL; vertalen in de volgende vertaalronde.

## 🆕 5 okt avond — muistoetsen op balk 8 als 3 × 2 (Rob: "6 7 / 8 9 / 0 -")

- [x] Rob 5 okt: layout op Holy goed (balk 1 zonder versiering, balk 8 rechts van C als 3 × 2). ✅
- [x] Rob 5 okt (screenshot): balk 8 toont 6 7 / 8 9 / 0 -; "4 toetsen wijzen nu naar balk 8". ✅ Meeverhuizen van
  spreuken niet te zien geweest (zijn knoppen waren leeg). Cooldown Manager staat boven het blok. ✅
- [ ] (oud) `/mh padkeys` (plan, verandert niets): 6 -> knop 5, 7 -> 6, 8 -> 3, 9 -> 4; 0 en - staan al goed.
  Dan `/mh padkeys go`: bovenaan **6 7**, midden **8 9**, onder **0 -**? En staat onder elke toets nog dezelfde spreuk
  als ervoor (de spreuken verhuizen mee)?

## 🆕 5 okt avond — healers: schade op het blok (Rob: "ik volg jouw advies")

Onderzoek mh-research (wago.tools build 12.1.5.70077 + Icy Veins 12.1): alleen Resto Shaman heeft nog een kick; E blijft
leeg bij de andere zes, bewust. Doorgerekend (data/keyblock_specs.json):
- Holy Paladin: 1 Holy Shock, 2 Judgment, 3 Consecration, 4 Shield of the Righteous (Holy), 5 Holy Prism.
- Disc: 1 Penance, 2 Smite, 3 Mind Blast, 4 SW:Death, 5 SW:Pain, Shift 1 Radiance, Shift 2 Holy Nova.
- Holy Priest: 1 Smite, 2 Holy Fire, 4 SW:Death, Shift 1 Sanctify, Shift 2 Holy Nova, 5 Prayer of Healing.
- Resto Shaman: 1 Lava Burst, 2 Lightning Bolt, 3 Flame Shock, Shift 1 Chain Lightning, 5 Chain Heal, E Wind Shear.
- Mistweaver: + Spinning Crane Kick Shift 2; Resto Druid: + Starsurge 4; Preservation: + Disintegrate 4.
- [ ] TwelveInchy **Holy**: Terugzetten → Zet het op balk 5, 6 en 7. Staat Holy Shock op 1, Judgment 2, Consecration 3?
  En **4 = Shield of the Righteous**? (AFGELEID: lukt alleen als het spellboek id 415091 meldt.) Holy Shock is nu geen
  klik-heal meer.

## 🆕 5 okt avond — BUFF ALLY bleef staan (Holy, Beacon op Valeera)

GEMETEN: `/mh mbuff` gaf "Beacon of Light [ally]: pass=true active=false" terwijl Rob hem gaf. AFGELEID oorzaak: een
verborgen (secret) spell-id op een ander werd overgeslagen en daarna als "afwezig" gerekend. Nu: verborgen = "weet niet".
- [x] Rob 5 okt: BUFF ALLY weg; `/mh mbuff` "per unit: Twelveinchy=false  Valeera Sanguinar=nil" → GEMETEN: Valeera's
  buffs zijn onleesbaar (geheim), dus de oorzaak klopte. Keerzijde, bewust: zonder Beacon blijft de melding bij een
  onleesbare groepsgenoot óók weg (nooit iets beweren wat MH niet ziet).
- [ ] (oud) `/reload`, Beacon op Valeera, `/mh mbuff`: onder Beacon of Light staat nu "per unit: <jij>=… Valeera=…". Wat staat
  er bij Valeera (true / false / nil)? Is BUFF ALLY weg? Stuur de regel als hij er nog staat.

## 🆕 5 okt avond — oud vlaggetje weg + balk 8 als 3 × 2 rechts van C

GEMETEN in de SV: na terug naar Modern en opnieuw "Eigen layout + blok" werd "Twelveinchy Holy" wel actief, maar niet
aangepast (balk 1 nog 6=0): een oud account-vlaggetje noemde hem nog "al een blok". Gerepareerd.
- [ ] Holy: `/reload` → **Zet "Twelveinchy Holy" terug** → Nu herladen → **Eigen layout + blok** → Nu herladen.
  Balk 1 zonder versiering? **Balk 8** (je muistoetsen) rechts naast C als **3 rijen van 2**, even groot?
  (Het spel vult van onder: 6 7 onderaan, 8 9 midden, 0 - boven.) Cooldown Manager boven het blok?

## 🆕 5 okt avond — eigen layout: Rob getest + twee reparaties

- [x] Rob 5 okt: "Twelveinchy Holy" gemaakt, actief in Edit Mode, melding klopt. ✅
- [ ] Reparatie 1: balk 1 zonder versiering (griffioenen, pijltjes). Reparatie 2: in een layout die MH net uit Modern/
  Classic maakte, gaat de Cooldown Manager boven het blok. Test: **Zet "Twelveinchy Holy" terug** → herladen →
  **Eigen layout + blok** (hergebruikt de layout) → herladen. Balk 1 zonder versiering, Cooldown Manager boven het blok?

## 🆕 5 okt avond — eigen layout per spec (Rob: "12-inch prot … voor tank")

GEMETEN door Rob: WoW onthoudt de layout per spec (Prot 5, Ret 7, Holy 1 = Modern). Niet in een gevecht, Edit Mode dicht.
- [ ] TwelveInchy **Holy** (staat op Modern): `/mh block` → de knop heet **Eigen layout + blok**. Druk → melding "Deze
  spec heeft nu een eigen Edit Mode-layout "TwelveInchy Holy" (een kopie van "Modern" …)" → **Nu herladen**.
- [ ] Na het herladen: Esc → Edit Mode: staat "TwelveInchy Holy" bovenaan bij de personage-layouts en is hij actief?
  Staan de vijf blokken er?
- [ ] Wissel naar Prot en terug naar Holy: houdt Prot zijn eigen layout, en komt Holy weer op "TwelveInchy Holy"?
- [ ] Holy: **Zet "TwelveInchy Holy" terug** → Nu herladen → Holy staat weer op **Modern**; "TwelveInchy Holy" staat
  nog in de lijst van Edit Mode (zelf weggooien mag).
- [ ] Nog eens **Eigen layout + blok**: maakt hij geen tweede kopie, maar gebruikt hij "TwelveInchy Holy" opnieuw?

## 🆕 5 okt avond — trinkets: alleen te gebruiken, en allebei (Rob op TwelveInchy)

- [ ] `/mh block` (Terugzetten → opnieuw neerzetten): staat op **G** een trinket met een **Use:**-effect, niet de
  passieve? Heb je er twee met Use:, dan staat de tweede op de eerste vrije plek van blok C (muis erop = welke).
  Twee passieve trinkets: G blijft leeg, en de tooltip zegt "no trinket with a Use: effect equipped".
- Tip: OPie op Shift G werkt; G blijft voor de trinket.

## 🆕 5 okt avond — elke layout zijn eigen weg terug (Rob op TwelveInchy: "Oak staat al als blok")

- [ ] Paladin: `/reload`, `/mh block`. De knop heet nu **Zet "<jouw layout>" terug** (grijs zolang MH die layout niet
  als blok zette) — niet meer "Oak". **Zet mijn balken als blok** werkt, ook al staat Oak op de Hunter als blok.
- [ ] Daarna **Zet "<jouw layout>" terug** → herladen: alles terug? En op de Hunter staat Oak nog steeds als blok?

## 🆕 5 okt avond — spiekbrief: code voor de site (Rob: route 1 + 3)

- [ ] `/mh block` → knop **Spiekbrief (code voor de site)** (of `/mh block export`): een kopieervak met een tekst die
  begint met `MH-KEYBLOCK 1`, daarna één regel per plek (48 plekken: D, A, B, C). Staan de namen goed, ook bij macro's?
- [ ] De site-pagina om hem te plakken bouwt de site-chat (opdracht verstuurd); pas daarna te testen.

## 🆕 5 okt avond — balk 1 als blok, links van D (Rob: "drie rijen van vier, links ernaast")

- [x] Rob 5 okt: Terugzetten → opnieuw neerzetten deelt alles netjes in (Mend Pet op zijn plek). ✅
- [ ] **Zet "Oak" terug** → herladen → **Zet mijn balken als blok** → herladen. Vijf blokjes van 3 × 4 naast elkaar:
  **1, D, A, B, C**, met A in het midden? Balk 1 even groot als de rest, lege plekken zichtbaar?
- [x] Rob 5 okt: na afstijgen werken 1-4 gewoon weer op het blok. ✅ Tijdens het vliegen liep de volgorde door elkaar
  (oude toets-indeling uit de snapshot) → nu altijd 1 = knop 1, 2 = knop 2 … 5 = knop 5.
- [x] (Rob 5 okt: "in principe werkt het"; knop 1 linksonder, zo gelaten) Skyriding-mount: doen 1-5 nu de skyriding-knoppen **in volgorde**? (Knop 6 en hoger: geen blok-toets, dus geen
  toets — jouw 6-0 zijn je muistoetsen op balk 8.)

## 🆕 5 okt avond — pet-spreuken (Mend Pet, Revive Pet, Call Pet) in het blok

Oorzaak (mh-research): ze zitten in de spellboek-groepjes "Pet Utility" en "Call Pet"; MH las zo'n groepje niet uit.
- [x] (Rob 5 okt, screenshots) Venstertje "Mend Pet -> Ctrl 2, Call Pet 1 -> Shift V", knoppen "Zet neer / Later";
  na Zet neer staan ze op het blok. Revive Pet niet gevraagd: stond al in blok D (Alt R). ✅
- [ ] (oude regel) Hunter: `/reload`. Komt het venstertje "Nieuw voor je toetsenblok: Mend Pet -> …, Revive Pet -> …"? (Call Pet
  alleen als je hem kent; MM pas met het talent Unbreakable Bond.) Zet neer → staan ze op het blok en werkt de toets?
- [ ] Optioneel, als het niet komt: plak deze in de chat en stuur me de uitkomst:
  `/run for i=1,6 do print(GetFlyoutSlotInfo(103,i)) end`

## 🆕 5 okt avond — blok D, oude balken weg, Blizzard zet niets meer bij (Rob: 1 ja, 2 ja, 3 ja, D links van A)

Op de Hunter, niet in een gevecht. Eerst `/reload`.
- [ ] **Bijwerken** (blok staat al): toets **3** drukt nu op Rapid Fire in blok A (niet meer op balk 1)? En Alt 1-4,
  Alt Q/E/R/F, Alt X/C/V/G zijn gekoppeld aan blok D?
- [ ] Voor een schone proef: **Terugzetten**, `/reload`, **Zet het op balk 5, 6 en 7**. Chat noemt "doubles off bar 1":
  zijn de dubbele spreuken van balk 1 weg? Spullen die opzij gingen staan nu eerst in **blok D** (balk 4)?
- [ ] Daarna een nieuwe spreuk leren: zet Blizzard hem NIET meer op balk 1? (`AutoPushSpellToActionBar` = 0.)
- [ ] `/mh block`: vier blokken, **D links**, met wat er echt op je balk 4 staat; het venster past op je scherm.
- [ ] **Zet "Oak" terug** → herladen → **Zet mijn balken als blok** → herladen: D links naast A, de vier samen in het midden?
  Balk 2 en 3 weg (te zien als je spellboek open is)? De uitleg over "spellboek / blok D" staat in de melding.
- [ ] Knop **Toon mijn oude balken 2 en 3** → Nu herladen → ze staan er weer; knop heet dan "Verberg …".
- [ ] **Terugzetten**: dubbelen terug op balk 1, en Blizzards "nieuwe spreuk op balk 1" weer aan.
- [x] (Rob 5 okt, screenshot) Vier blokken D-A-B-C naast elkaar, D met Revive Pet op Alt R. ✅
- [ ] Balk 1 (de rij boven het blok): na **Terugzetten → Zet het op balk 5, 6 en 7** zijn de dubbelen eraf; na opnieuw
  **als blok zetten** zijn de lege knoppen van balk 1 onzichtbaar. Blijft er alleen over wat níet op het blok staat
  (bv. de Single-Button Assistant)? Op een skyriding-mount verschijnen daar de skyriding-knoppen?
- Alt-Z is bewust niet gebruikt: dat is Blizzards toets om de hele interface te verbergen (AFGELEID, niet gemeten).

## 🆕 5 okt avond — skyriding, voertuig, petbattle: toetsen even terug naar balk 1

Rob: op een vliegmount kregen de skyriding-knoppen op balk 1 geen toetsen meer. Nu: zolang balk 1 door het spel wordt
vervangen (skyriding, voertuig, override, possess, petbattle), drukken de blok-toetsen die vroeger op balk 1 zaten weer
op balk 1. Na afstijgen weer het blok. Nagekeken in Blizzards 12.1-code (mh-research), NIET in het spel.
- [ ] `/reload`, `/mh block why`: onderaan "bar 1 keys during skyriding…: armed, N key(s)". Hoeveel?
- [ ] Skyriding-mount, op de grond en in de lucht: doen 1-5 de skyriding-knoppen? (Het cijfer op de knop kan ontbreken.)
- [ ] Afstijgen: drukt 1 weer op het blok?
- [ ] Opstijgen ná een pull (in gevecht): werkt het ook dan?
- [ ] Cat Form / stealth (als je die hebt): 1-5 blijven op het blok.
- [ ] Een voertuig-quest of een petbattle, als je er een tegenkomt.
- [ ] `/reload` terwijl je op de mount zit.

## 🆕 5 okt avond — nieuwe spreuken: Bijwerken, vraagje, schakelaar (Rob: "Ik volg jouw voorstel")

Op de Hunter (blok staat al neer):
- [ ] `/mh block`: de eerste knop heet nu **Bijwerken (nieuwe spreuken erbij)**. Rechtsboven een knop **Nieuwe spreuken: vraag
  het me**; klikken wisselt naar "zet ze vanzelf neer" en "vraag het nooit". Zet hem terug op "vraag het me".
- [ ] Level 12 gehaald: kwam er (na een paar seconden, buiten gevecht) een venstertje **"Nieuw voor je toetsenblok: … → toets"**?
  Zo niet: druk **Bijwerken** — komt de nieuwe spreuk dan op het blok? Bleef al het andere op zijn plek?
- [ ] "Later" in het venstertje: vraagt hij het daarna niet steeds opnieuw (pas weer bij een volgende nieuwe spreuk)?
- [ ] Na Bijwerken **Terugzetten**: gaat ook de nieuwe spreuk eraf en komt alles van vóór het blok terug?
- [ ] In een gevecht levelen: het venstertje komt pas ná het gevecht.

## 🆕 5 okt avond — optie C: balk 1-4 blijven staan

- [ ] **Zet "…" terug** → herladen → **Zet mijn balken als blok** → herladen. Balk 1-4 staan nog waar ze stonden (geen
  kolommen meer over je questlijst)? Lag een van die balken over het blok, dan staat hij nu als rij boven het blok, en de
  melding noemt hem.

## 🆕 5 okt avond — blok C verborgen en kleiner op de Hunter (layout Oak)

GEMETEN in de SV: in "Oak" stond balk 7 op Visible = Hidden (alleen te zien met het spellboek open) en de drie balken
hadden icoongrootte 3/2/0. "Zet mijn balken als blok" zet nu alle drie op "altijd zichtbaar" en op de grootste van de drie.
- [ ] Hunter: **Zet "Oak" terug** → Nu herladen → **Zet mijn balken als blok** → Nu herladen. Is blok C nu altijd zichtbaar,
  en zijn A, B en C even groot?

## 🆕 5 okt avond — alle 36 toetsen horen bij het blok, ook lege plekken

- [ ] Hunter: **Terugzetten**, dan **Zet het op balk 5, 6 en 7**. Staan de labels Shift Z/X/C/V, Shift 4, Shift F1 nu op
  de lege plekken van blok C (en niet meer op de kolommen rechts)? Doet een lege toets niets?

## 🆕 5 okt avond — waarschuwing in het venster als balk 5/6/7 uit staat

- [ ] Hunter (balk 5-7 niet te zien): `/mh block` toont bovenaan de voetregel in **rood** "Actiebalk 5, 6, 7 staat uit …".
  Klopt de weg "Options > Gameplay > Action Bars"? (AFGELEID, niet nagekeken in 12.1.) Na aanzetten: rode regel weg?

## 🆕 5 okt avond — het oude paneel "Je balken inrichten" is kort (Rob: optie A)

- [ ] `/mh setup` (of de MH-knop "Je balken inrichten"): nog maar 3 knoppen: **Je toetsenblok** (opent `/mh block`),
  **Toetsen handmatig zetten**, **Terugdraaien**. Bovenaan: "Je keybindings zijn account-breed: het toetsenblok geeft elk
  personage dezelfde toetsen." Past alles in het (kleinere) venster?

## 🆕 5 okt avond — toetsenblok: macro's gaan opzij, het blok is overal compleet

Rob: "Blok C is absoluut anders dan wat wij voorgesteld hebben … die macro's moeten dan maar ergens anders komen."
Nu: wat op een blokplek staat (ook een macro) gaat eerst naar een **vrije knop op balk 2, 3 of 4**, dan komt het blok.
Niet in een gevecht.
- [ ] Eerst **Terugzetten** (de oude stand), dan `/reload`.
- [ ] `/mh block`: blok C heeft nu **oranje** randen waar je macro's staan, geen rode meer. Muis erop: "Keys gaat naar
  actiebalk 2, knop 5" (of zoiets). Klopt dat?
- [ ] **Zet het op balk 5, 6 en 7.** Staat blok C nu zoals op het plaatje? Staan je macro's (Justice, Hands, Clean, Keys,
  Rebuke, Taunt, Prot …) op balk 2, 3 of 4? Werken ze nog als je erop klikt?
- [ ] **Terugzetten**: staan je macro's weer precies op hun oude plek op balk 7?
- Let op: een macro die opzij gaat, houdt zijn oude toets niet. De toets hoort nu bij het blok.
- [ ] **Per personage** (5 okt, Rob op een laag alt): het terugzetten-geheugen is nu per personage. Op het alt: `/mh block`
  laat de randen zien (niet "staat al op je balken"), en "Terugzetten" zegt "nothing to undo". Terug op de Paladin:
  `/mh block` zegt "staat op je balken", en "Terugzetten" zet zijn macro's terug op balk 7.
- [ ] (Rob "1 ja") Plekken waar MH niets voor heeft (Paladin: Shift 1, Shift 2, Shift 3, 4, Shift 4, Shift T) worden nu
  **echt leeg**: wat er stond (het blaadje, Clean) gaat ook naar balk 2-4. Oranje rand op het plaatje vóór het neerzetten.

## 🆕 5 okt avond — toetsenblok stap 2b: de balken als blok op je scherm (Rob: "1 advies, 2 advies, 3 advies")

Niet in een gevecht, Edit Mode dicht. Eerst `/reload` (je screenshot van 5 okt toonde nog de oude versie).
- [ ] `/mh block`: de toets staat nu op een **eigen donker strookje** bovenin elk vakje; niets loopt meer door het icoon.
  Namen zijn minder vaak afgekapt.
- [ ] Onderaan staan nu **4 knoppen**: Place it · Undo · **Arrange my bars as a block** · **Bars back as they were**.
- [ ] Druk **Arrange my bars as a block**. Onderaan komt een uitleg + knop **Reload now**. Druk die.
- [ ] Na het herladen: balk **5, 6, 7** staan als **drie blokjes van 3 × 4** naast elkaar onderaan in het midden?
  Balk **1-4** als kolommen rechts? Stance boven blok A, pet bar boven C, extra knop boven B?
- [ ] **Balk 8** (je muistoetsen) staat nog precies waar hij stond, en het blok ligt er niet overheen?
- [ ] Je **cooldown-balken** (Essential/Utility/Buffs) en de rest staan nog waar ze stonden? (Eén ervan hing aan balk 4;
  MH zet die eerst vast op zijn plek.)
- [x] Rob 5 okt: blok, kolommen en terugzetten werken. GEMETEN: het spel vult van **onder** naar boven (knop 1 linksonder),
  dus het blok stond ondersteboven t.o.v. het plaatje. Gerepareerd: plek 1-4 van het plaatje gaat nu op knop 9-12.
- [x] (Rob 5 okt, screenshot: klopt) **Na de reparatie:** eerst **Terugzetten**, `/reload`, dan **Zet het op balk 5, 6 en 7**. Staat nu **1 2 3 4 bovenaan** en
  **Z X C V onderaan**, net als op het plaatje (en je toetsenbord)?
- [x] (Rob 5 okt, screenshot: lege knoppen zichtbaar) Daarna ook **Balken terug zoals ze waren** → herladen → **Zet mijn balken als blok** → herladen: zijn de **lege
  knoppen** in het blok nu zichtbaar, zodat elk blok een strak 3 × 4 is?
- [ ] Zijn balk 6 en 7 zichtbaar? Zo niet: Options → Action Bars → Action Bar 6 en 7 aanzetten.
- [ ] Daarna **Bars back as they were** → Reload now → alles weer zoals vanochtend?

## 🆕 5 okt — toetsenblok: de proefrit staat nu op het plaatje

Rob 5 okt over de vorige versie: Place en Undo werken ✅; de proefrit was "een lange lijst in de chat en eigenlijk geen idee
wat ik daar op zou moeten letten". Nu: geen lijst-knop meer, de randen op het plaatje tonen het.
- [ ] `/reload`, `/mh block` (niet neergezet): randen **groen** (komt hier), **oranje** (vervangt iets — muis erop zegt
  wat), **rood** (blijft ongemoeid, bv. een macro), **grijs** (staat al goed / leeg). Onderaan de uitleg van de kleuren.
- [ ] Na "Place it": randen weer gewoon, onderaan "The key block is on your bars". Na "Undo": kleuren terug.

## 🆕 5 okt — toetsenblok stap 2a: neerzetten (Rob: "A1 B1 C1") — ✅ Rob: "de rest werken" (Place + Undo)

Niet in een gevecht. Begin met je **Paladin** (zijn balken ken je het best).
- [ ] `/mh block`: onderaan staan 3 knoppen. Daarboven een regel "Place it would put N buttons on your bars…". Klopt
  die met wat je verwacht?
- [ ] Klik **"Show what would change"**: in de chat per toets wat er gebeurt (place / already there / left alone / free).
  Staat er "action bar 6 is hidden"? Zet die balken dan aan (Options → Action Bars) en kijk opnieuw.
- [ ] Klik **"Place it on bars 5, 6 and 7"**. Staan de spreuken op balk 5-7 zoals op het plaatje? Werken de toetsen
  (1 = Judgment, E = Rebuke, Q = Sentinel, T = je potion als je er een hebt, G = je trinket)?
- [ ] Klik **"Undo"**: staat alles weer zoals het was (balken én toetsen, ook Shift 1-6 en Ctrl 1-3)? Een macro die op
  balk 5-7 stond hoort er nooit afgehaald te zijn ("left alone").
- ⚠️ Balken staan nog in hun oude vorm (1 rij van 12); 3 rijen × 4 naast elkaar is stap 2b.

## 🆕 5 okt — voor 4.6.1: healers/DPS op Stay alive (Rob: "advies volgen")

- [x] **Druid Balance/Feral/Resto:** Stay alive heeft **Bear Form** als grote noodknop ("no cooldown, but you deal almost
  no damage in it"). Guardian NIET. ✅ Rob 5 okt: Resto regel 3 Bear Form (vóór Heart of the Wild), Guardian zonder.
- [ ] **Feral:** **Regrowth** bij de heals ("when it is free and instant, after a finisher").
- [x] Rob 5 okt ✅ (Disc zonder talent: "needs talent 193063, which you do not have", rij weg) **Priest (Disc/Holy/Shadow) MET het talent Protective Light:** **Flash Heal** als kleine verdediging. Zonder het
  talent: niet op de kaart, en `/mh survival` zegt "needs talent 193063". Heb je het talent en staat hij er tóch niet?
  Dan meldt het spel het talent anders (niet gemeten) → screenshot van `/mh survival`.
- [ ] **Devastation Evoker MET Stretch Time:** **Deep Breath** als grote noodknop. Zelfde test als bij de Priest
  (talent 410352).

## 🆕 5 okt middag — laatste twee voor 4.6.0

- [x] `/reload`, `/mh play` → **Consumables** (Prot Paladin): Health Potion zegt nog maar één keer "Silvermoon Health
  Potion" bij "Also"? ✅ Rob 5 okt (screenshot).
- [x] Op **Stay alive**, **Consumables**, **Dispel** en **Group** staat nu onderaan ook de blauwe regel "This card on
  the website". Klik op Stay alive: eindigt de link op **`#alive`**? ✅ Rob 5 okt: "beide goed, go".

## ✅ 5 okt middag — Rob testte (Mage, Druid, achievement-lijst)

- [x] Mage (Frost): Stay alive 7 regels, Shimmer één keer, `/mh survival` geen "not found by id" (Cold Snap "not known"
  = niet getalenteerd, Mirror Image = geen Refractive Images). Nieuwe ids werken.
- [x] Guardian: Stay alive 10 regels, **Thrash** regel 2 met Rend and Tear-note, geen rode regels. `/mh block`: Q =
  Incarnation, Bear/Cat op Ctrl 1/2. 🐛 Ctrl 3 kreeg Remove Corruption (Guardian kent Moonkin Form niet) → gerepareerd:
  Druids houden Ctrl 1-3 voor vormen, ook leeg. → na `/reload`: Ctrl 3 leeg?
- [x] Guardian na fix: Ctrl 3 leeg ✅; Remove Corruption kwam op Shift C (overloop), Mark of the Wild + Revive "no room".
  ⚠️ Open voor stap 2: overloop zet knoppen op plekken met een andere taak (Shift C = "big def., second").
- [x] Prot Paladin: Stay alive regel 2 = Consecration (note klopt); Consumables flask = Blood Knights ✅. Cosmetisch:
  "Silvermoon Health Potion / Silvermoon Health Potion" (twee rangen) bij Health Potion → later.
- [x] `/mh achlist`: 🐛 eerst geen venster (geen ankerpunt) → gerepareerd; venster werkt: 284 van 435, groepen klappen
  open, tooltip klopt (screenshot).

## 🆕 5 okt — consumables-wissels en tank-regels op Stay alive

- [ ] **Prot Paladin** `/mh play` → **Consumables**: flask = **Flask of the Blood Knights** (was Shattered Sun).
- [ ] **Prot Paladin** → **Stay alive**: nieuwe regel 2 **Consecration** ("put it on the ground and stay inside"), onder
  Shield of the Righteous. Geen rode regel in `/mh survival`.
- [ ] Andere tanks als je ze hebt: Blood DK **Marrowrend** bovenaan; Brewmaster **Blackout Kick** + **Keg Smash**;
  Guardian **Thrash**; Vengeance **Soul Cleave** bij de heals. Verschijnen ze (ids van Wowhead, niet in het spel gemeten)?
- [ ] Een DPS met een gewisselde potion (Balance, Shadow, Demonology, Devastation, Augmentation → Potion of Recklessness).

## 🆕 5 okt — "Midnight-achievements die je nog mist" (wens #16)

- [ ] `/reload`, open MH → **Achievements**: naast "Route nearest open" staat een knop **"Midnight achievements you
  miss"**. Klik: er opent een venster met 10 groepen (Delves, Quests, Exploration, Reputation, Midnight Dungeon,
  Midnight Raid, Prey, Void Assaults, Ritual Sites, Housing), elk met "x / y".
- [ ] Klik een groep: klapt hij open met de achievements die je mist (+ voortgang, bv. 3/8)? Klopt het getal met
  Blizzards eigen achievement-venster (bv. Delves > Midnight 43/51)?
- [ ] Klik een achievement: opent Blizzards venster op die plek?
- [ ] `/mh achlist why`: één regel per groep in de chat.

## ✅ 5 okt ochtend — Rob testte (Prot Paladin, screenshots)

- [x] Stay alive Prot: 11 rijen, geen rode regel in `/mh survival`. ⚠️ Paladin-rijen kregen 4 okt GEEN nieuwe id (hadden
  ze al) → dit bewijst de nieuwe ids nog niet. Nog nodig: minstens Mage (Shimmer/Blink, Mirror Image) en liefst
  Druid/Monk/Warrior/Priest.
- [x] `/mh block` Prot: venster klopt; Q = Sentinel (Rob: "q staat hier goed"), Shift-E = Arcane Torrent, Consecration op 5,
  toets 4 leeg (SotR = defensief op X, bewust), "Every spell … has a place". `/mh block why`: regels komen.
- [x] **Edit Mode-proef geslaagd**: export → import (Umbrion, account-layout) → `/reload`: "alles staat nog op zijn plek".
- [x] Achievements: Ula'tek Uncoiled 2/4 en Assault the Vault 3/10 als meta-rij (goede namen), Coiled to Strike 11/12,
  Treasures of the Coiled Isle toont "Reward: Auriferous Venomfang".
- [x] `/mh ach cats`: 169 categorieën, 6 × "Midnight" (Delves 15571, Reputation 15600, Quests 15547, Exploration 15553,
  Midnight Dungeon 15541, Midnight Raid 15566) — GEMETEN in SV `achCatProbe`.
- [x] `/mh changelog`: 4.6.0 bovenaan met 6 regels.
- [x] `/mh shots` (08:30, ultrawide 5120x1440): 14 shots; 10 en 14 zonder zoeklijst/coach (GEMETEN, plaatjes bekeken).

## 🆕 4 okt middag — achievements (Coiled Isle) en Q voor Windwalker

- [ ] **Achievements-tab**, bovenaan bij de meta's: staan er twee nieuwe uitklapbare rijen, **Ula'tek Uncoiled** en
  **Assault the Vault**, met een teller (x/y)? (Alleen zichtbaar zolang ze niet af zijn.) Klopt de naam? Een rare naam
  = fout nummer.
- [ ] Kaart **Treasures of the Coiled Isle**: staat er nu een beloningsregel **Auriferous Venomfang**, met "collected"
  als je hem al hebt?
- [ ] Nieuwe kaart **Coiled to Strike** (12 rares): klopt je teller met wat het spel zegt? Route-knop: wijst de pijl
  naar de dichtstbijzijnde rare die je nog mist? Szarith zit in de Underbelly (eerst de ingang).
- [ ] **Windwalker Monk** (als je die hebt): `/mh block` → staat **Zenith** op Q?
- [ ] **Meting voor "Midnight-achievements die je nog mist"** (wens van de Franse speler, #16): typ `/mh ach cats`.
  In de chat: hoeveel categorieën, en een lijstje "… > Midnight" met tellers. Dan `/reload` en zeg "gedaan"; ik lees
  het bestand (`achCatProbe`). Er verandert niets.

## 🆕 4 okt middag — 4.6.0 klaargezet (NIET gepusht, NIET getagd)

- [ ] `/reload`, open de changelog (`/mh changelog`): staat **4.6.0** bovenaan met 6 regels?
- [ ] Lees `RELEASE_NOTES.md` (= de CurseForge-tekst). Klopt het voor jou? Pas daarna "go".

## ✅ 4 okt — Rob testte live (7 screenshots, Prot Paladin)

- [x] `/mh play` Prot: 5 tabs passen (Your buttons/Stay alive/Consumables/Dispel/Group); stap 5 = Hand of Reckoning;
  Lightsmith "one button with 2 charges"; Stay alive: WoG met Shining Light-zin, géén Divine Protection; Group: alle 9
  rijen met icoon, toets en uitleg.
- [x] This Week: "Done this week: 7 (click to show)" klapt open en dicht, en blijft na `/reload` onthouden.
- [x] Account snapshot: "Silvermoon quest givers (this character): 3 / 5 done" en "Professions: fewer than 8 Dundun
  shards this week: 10 (…)". ⚠️ AFGELEID: die 10 kan nog oude nullen van vóór 3 okt bevatten (alts die sinds de reset
  maar vóór de fix inlogden; de oude code las een junk-item). Klopt pas zeker na de volgende reset.
- 🐛 **Gevonden en gerepareerd:** Stay alive met 11 rijen toonde "…" i.p.v. **10** (nummerkolom 18 px). Rij 10+ krijgt nu
  het normale lettertype (`PlayCardWindow.lua`, StepRow). ✅ Rob 4 okt na `/reload`: "de tien past nu wel".
- [ ] Liadrin: "Your week" zegt **"Weekly (Lady Liadrin): done this week"** (screenshot 4 okt), terwijl Rob eerder die
  dag haar keuzescherm kreeg. Rob: nee, nog niets bij haar ingeleverd → **bug**. GEMETEN (`/run`, 4 okt): geleerde
  verhaalquest **92916 = true** (flag wist nooit), door de leer-opslag onder Liadrin gezet. 🐛 Gerepareerd in
  `ResetRoutine.lua`: alleen quests die de client "weekly" noemt worden nog geleerd en mogen "done" maken; oude geleerde
  ids alleen nog voor "in je log". `/mh weeklies` toont nu ook de geleerde ids.
  ✅ Rob 4 okt na `/reload`: Liadrin "picked up — finish and turn it in" (hij koos een quest), ritual-regel grijs.
  GEMETEN: Void Assaults-weekly `frequency` = 3 = `ResetByScheduler` (Weekly = 2) → het leren werkt.
  ❌ Daarna viel **Halduron** terug op "pick it up" (hij leverde wo 20:48 in; oude geleerde ids telden niet meer).
  🐛 Gerepareerd: een inlevering deze week (turn-in log) maakt een gever "done", tenzij er daarna nog een aanbod is
  gezien (Aethas: aanbod en inlevering allebei wo 11:39). ✅ Rob 4 okt na `/reload`: Halduron én Aethas "done this
  week", Liadrin "picked up", 7 of 12. (Aethas stond 's ochtends, vóór alle wijzigingen, ook al ten onrechte op
  "pick it up" — die fout is mee opgelost.)
- [x] Void & Rituals-tab (screenshot 4 okt): weekly-regel noemt Lady Liadrin ✅. Maar hij was **geel** terwijl de quest
  niet in de log staat: de grijs/geel-regel zat alleen in `RitualSites.lua`, niet in `WorldContent.lua` (dit tabblad).
  🐛 Gerepareerd. → Na `/reload`: is de regel nu **grijs**?
- [x] Lor'themar Theron: "pick it up next to the vault" was fout. Rob vond hem 4 okt boven in zijn gebouw (2393
  45.4/70.3), zonder quest. mh-research: 95245 "Midnight: World Tour" is **eenmalig**, geen weekly; Lor'themar geeft
  in S2 geen weekly. Rob koos **A: uit de lijst**. Weg uit ResetRoutine + WeeklyHubProbe.
- [ ] Na `/reload`: staat Lor'themar niet meer in "Your week"?
- [ ] **Nieuw: twee Spark-gevers** in "Your week" (ids van Wowhead + Blizzard-hotfixes, coördinaten NIET in het spel
  gemeten):
  - **Zerella** — "Sparks of War", elke week een andere zone. Klik de regel: zet de pijl haar op **Silvermoon 36.2,
    81.0**? Staat ze daar echt? Biedt ze een Sparks of War aan (War Mode aan)?
  - **Talon Commander Zela** — "Turn Back the Surge" op de **Coiled Isle 58.7, 45.8**. Staat ze daar?
  - `/mh weeklies full`: het blok "Spark givers" geeft per id de titel uit het spel. Klopt elke titel met het label?
  - Telling bovenaan wordt nu "x of 13" (−Lor'themar, +2).
  - ✅ Rob 4 okt: "7 of 13", Lor'themar weg, Zerella + Zela in de lijst. **Zerella staat op de pin** en bood "Sparks
    of War: Eversong Woods" aan (= 93423). ✅ **Zela staat op de pin** (Coiled Isle) en biedt "Turn Back the Surge"
    (Spark of Tides + Venom-Covered Chest + 1K Zul'jarra's Forces); MH ziet hem in je log na aannemen. Open: titels in
    `/mh weeklies full`.
- [ ] Dundun-regel zit niet in het alt-overzicht maar in **MH → beroepen-overzicht** (Knowledge-blok bovenaan, dit
  personage): "Shards of Dundun: N / 8 earned this week". Mijn testvraag noemde de verkeerde plek.
- [ ] Liadrin bood Rob 4 okt: World Quests, Saltheril's Soiree, **Vaults of Atal'Utek**, Dungeons (screenshot). Kies
  Vaults → zegt "Your week" dat hij in je log staat?

## 🆕 4 okt — link van de kaart naar de site (Rob: "do the link to the site")

- [x] ✅ Rob 4 okt (Guardian): onder de bronregel op "Your buttons" staat **"This card on the website: click for the
  link."**; eerst te klein (raw font) → nu normale grootte; klikken opent het kopieervenster.
- [ ] Plak de link in je browser: opent `midnighthelper.com/play/<spec>/` de juiste pagina? (Slugs GEMETEN uit de live
  sitemap; op een Duitse/Franse… client wordt het `/de/play/…` enz.)

## 🆕 4 okt — Delve Coach: vinkje "vanzelf openen" (Rob: "bouw die knop maar")

- [x] ✅ Rob 4 okt (screenshot All settings): **"Open the Delve Coach by itself"** staat er, aangevinkt.
- [ ] Zet hem uit en loop een delve in: gaat de coach níét vanzelf open, en ook geen "open coach?"-knopje bij de baas?
  `/mh coach` opent hem dan nog wel. Daarna weer aan.

## 🆕 3 okt laat — "Stay alive" nagelopen + Liadrin/Stormarion (niet uitgebracht)

`/mh play` → tab **Stay alive**. Alleen kijken op de klassen die je hebt:
- [x] ✅ Rob 4 okt (Guardian Purlymixanox, alle 4 specs via de knopjes): Guardian zonder HotW en zonder Wild Charge;
  Feral zonder Wild Charge; Balance + Resto met Frenzied Regeneration en Regrowth. NIET te zien vanaf een Guardian
  (de kaart kijkt in het eigen spellbook): Wild Charge op Balance, Ironbark op Resto — pas op een Balance/Resto-druid.
- [x] ✅ Rob 4 okt (Purlymixanox, Skinning 100/100): Skinning-advies "Lasting Leather (0/40), Superb Scales (0/40)" klopt.
  🐛 Maar "Skinning: trainer weekly **(needs skill 25 first)**" bij skill 100: de zin werd ALTIJD achter de
  gatherer-weekly gezet. Gerepareerd in `ProfessionsHub.lua` (alleen als de Midnight-skill < 25 of onleesbaar).
- [x] ✅ Rob 4 okt na tweede poging: Skinning nu zónder die zin. (Eerste poging las `C_TradeSkillUI` → zei niets bij
  gesloten beroepenvenster. GEMETEN `/run`: GetProfessionInfo geeft "Skinning 100 100 393" → die bron gebruikt.)
  Zelfde bron nu ook in `ProfessionNextStep.lua` (This Week, gatherer-weekly onder 25 verbergen).
- [x] ✅ Rob 4 okt: This Week op Purlymixanox toont nog "Trainer weekly (Skinning): pick it up at your profession
  trainer" (skill 100 = hoort te blijven).
- [ ] Op een alt met een verzamelberoep ónder skill 25: valt die regel in This Week weg?
- [x] ✅ Rob 4 okt (Redisch, Blacksmithing + Enchanting): overzicht met advies per beroep, Enchanting-weekly afgevinkt.
- [x] Rob 4 okt, Redisch (BM Hunter 90): Group-tab leeg op alle 3 specs ("None of these buttons…"). GEMETEN met `/run`:
  `C_Spell.GetSpellInfo("Misdirection")` en `("Roar of Sacrifice")` = **nil**, IsPlayerSpell 34477/53480 false → hij heeft
  ze niet (talenten niet gekozen); Primal Rage/Master's Call: pet niet van het juiste type. **MH klopt.** Niet te testen
  op deze hunter: Group-rijen en de pet-note van Roar of Sacrifice — wacht op een hunter mét die talenten.
- [ ] (oud punt, deels afgevinkt hierboven) **Druid:** Guardian heeft géén Heart of the Wild meer en géén Wild Charge bij "wegkomen". Balance heeft nu
  **Frenzied Regeneration** en **Regrowth** bij heal, en Wild Charge met "jumps you backwards". Resto: Ironbark staat
  bij de kleine knoppen, ná Barkskin.
- [ ] **Evoker:** Obsidian Scales staat bij de **grote** knop, Zephyr bij de kleine.
- [ ] **Brewmaster:** staat **Celestial Infusion** erop als je dat talent hebt (anders Celestial Brew)? En verandert
  er níéts aan je toetsen (Layout-tab)?
- [x] Mirror Image: Rob 4 okt (Frost) `IsPlayerSpell(1309497)` = **false**, maar de Arcane-kaart toonde Mirror Image
  toch. 🐛 Gerepareerd: nieuw veld `survivalRequires` — alleen met Refractive Images, elke spec. ✅ Na `/reload`:
  `/mh survival` "needs talent 1309497, which you do not have". Open: iemand MÉT het talent ziet hem wel.
- [ ] **Death Knight:** Lichborne bij de kleine knoppen. **Demon Hunter:** geen Darkness meer. **Rogue:** geen Shadowstep.
- [ ] **Marksmanship:** Roar of Sacrifice zonder "your pet takes part of the damage".
- [x] ✅ Rob 4 okt, Demonology lvl 82: Axe Toss ontbrak ("not found by name"). GEMETEN: Command Demon 119898 →
  override 119914, IsPlayerSpell 119898 true / 119914 false / 89766 false. Gebouwd: `survivalId` = 119898 +
  `survivalOverride` (alleen tonen als de override echt Axe Toss is). Na `/reload`: **Axe Toss staat er als 7**, `/mh
  survival` zegt "+". Spell Lock (Affli/Destro, override 119910 AFGELEID) nog niet gezien.
- [x] ✅ Rob 4 okt, Affliction: **Spell Lock staat erop** (rij 6) → override 119910 daarmee GEMETEN.
- [x] ✅ Rob 4 okt, Elemental (Horde): Group-tab toont alleen **Bloodlust**, geen Heroism (+ Wind Rush Totem,
  Ancestral Spirit).
- [x] ✅ Rob 4 okt: "Shards of Dundun: 0 / 8 earned this week" in Tools → Professions → Treasures & Books (Engineering +
  Jewelcrafting-alt). Currency 3376 + naamcontrole werkt. **Devourer** — staat Shift erop? **Windwalker** met Combat Wisdom — is Expel Harm weg?
- [ ] Liadrin: pak je **Arcantina, Offworld Showdowns, Raid** of **Vaults of Atal'Utek**, zegt "Your week" dan dat
  hij in je log staat (niet "ga ophalen")? `/mh weeklies` noemt hem dan niet meer als onbekend.
- [ ] Void & Rituals-tab: heeft de Stormarion-regel nu in **elke** fase een tooltip (ook bij "bouwen" en "verdedigen")?

## 🆕 3 okt avond — kaarten, achievements, gear, wereld

- [x] ✅ Rob 4 okt: Arcane Mage-kaart 5 stappen, stap 3 = **Prismatic Bolt** met icoon. Frost- en Fire-kaart ook gezien,
  in orde. (Opgevallen: "Arcane Pulse" en "Arcane Soul" niet geel/gelinkt in de Arcane-tekst — geen fout, wel een
  mogelijke verbetering.)
- [ ] Achievements: staan de **Slugger**-kaarten nu op klaar als je ze echt hebt (eerst 6/10 en 15/19)?
- [ ] Ready-check op een DK: vraagt hij nu om **weapon oil**? Op Enhancement niet meer. Telt hij een flask/potion van de
  andere kwaliteit (278 i.p.v. 295) als "heb je"?
- [ ] Wapen-enchantadvies op een DK: geen voorstel meer. Op andere specs staat **Rite of the Hash'ey** als laatste optie.
- [x] ✅ **GEMETEN door Rob 4 okt (Redisch):** Maella bood eerst de intro "Through the Cold Rift"; de portal toonde Val
  (Normal/Heroic); op Val bood ze **"Showdown on Val"** (Riftstalker's Cache) + "Surveying the Frozen Wastes". De
  S2-blokkade in `Showdowns.lua` is weg → Maella is weer een gewone stop in "Your week" en de Showdowns-sectie toont
  weer. ✅ Rob 4 okt (Purlymixanox na `/reload`): **Riftblade Maella staat weer in "Your week"** (stap 7, portaltekst),
  naast Zerella en Zela; "3 of 14". Void & Rituals-regel nog niet bekeken.
  🌐 Online 3 okt (mh-research, `scratchpad\online\answers.json`): **waarschijnlijk ja** — Wowhead 3 aug + Icy Veins 15 aug/29 sep;
  de hotfix waar de blokkade op rust ging over *Sparks of War* (96725/96726, Zerella), niet over Maella. AFGELEID: geen
  spelersreactie na 18 aug gevonden. Eén blik in het spel beslist het.
- [x] 🌐 Online 3 okt, GEMETEN (Wowhead-questtype + wago AreaPOI): Stormarion weekly = **90962**, 94581 = herhaalbaar.
  POI 8419/8421/8422 = één event in drie fases. ✅ Gebouwd 3 okt laat (`EventInfoData.lua`), test staat hierboven.
- [ ] Rares: dood een rare op een niet-resetdag, typ de volgende dag `/mh rarequests`: staat hij weer op "--"? Dan is het dagelijks.

## 🆕 3 okt avond — beroepen

- [ ] Alt-overzicht → tooltip van een personage met beroepen: staat er een **Dundun**-regel met een echt getal? (MH leest
  nu de valuta, mét naamcontrole.) Staat er géén Dundun-regel, typ dan `/dump C_CurrencyInfo.GetCurrencyInfo(3376)` en
  stuur me de naam die eruit komt.
- [ ] Professions → boeken-kaart: tooltip van een **Anomander/Caeris/Magovu**-boek zegt nu "Voidlight Marl: 750" + renown;
  een **Echo of Abundance**-boek nog steeds Abundance.
- [ ] Beroepen-wizard: zegt de "open je venster"-stap **K**? Vinkt de weekly-stap zichzelf af als je de weekquest hebt
  ingeleverd (en volgende week weer open)?
- [ ] Herbalism-advies: noemt het eerst **Midnight Overload openen (0 punten)**? Skinning: eerst 10 in Thorough Tanning,
  dan Lasting Leather of Superb Scales?
- [ ] This Week op een alt met een verzamelberoep onder skill 25: géén "weekly nog niet opgepakt"-regel meer.

## 🆕 3 okt avond — world boss

- [x] 🌐 Online 3 okt, GEMETEN (Wowhead): Liadrin-ids Arcantina 93767, Offworld Showdowns 96727, Raid 93912, Vaults of
  Atal'Utek 98232 (+ World Boss 93913, Stormarion 93892). ✅ Gebouwd 3 okt laat (ResetRoutine + WeeklyHubProbe).
- [x] 🌐 Online 3 okt: Nymrissa 279/292/305/318 (GEMETEN); Pertinax/Leth'ir houden S1-buit (±259, AFGELEID); de vier oudere
  bazen onbeslist (246 of 256).
- [ ] Codex "World boss (Midnight)": staat Liadrins quest erin?

## 🆕 3 okt avond — Ritual Sites nagelopen

- [ ] Ritual-tab (Silvermoon → Ritual Sites): de weekly-regel noemt nu **Lady Liadrin** en is grijs als de quest niet
  in je log staat, geel als hij er wél in staat.
- [ ] Op een alt die de intro nog niet af heeft: noemt de hint na **Void Strike** nu **Ritual Interest** als volgende
  stap (eerst Ritual Problems)?
- [ ] In Daggerspine Point, fase 2: heet de baas in het MH-venster **Void-Infused Mindbreaker**, en staan er nu korte
  tips (ook bij Lady Selen'vjar)? Kloppen ze met wat je ziet?
- [x] 🌐 Online 3 okt (AFGELEID): nebula en spiegels alleen met Malevolent Boons.
- [x] 🌐 Online 3 okt, GEMETEN: npc 257498 heet **"Selen'vjar"**; scenario-tekst en kist zeggen "Lady Selen'vjar".

## 🆕 3 okt middag — "Zo speel je": vijfde tab "Group" (eerst Prot Paladin)

Op je **Prot Paladin**, `/mh play`:
- [ ] Er is een vijfde tab **Group** (nl "Groep"). Past de rij tabs nog in de breedte?
- [ ] Group toont: Blessing of Sacrifice, Blessing of Protection, Blessing of Spellwarding, Word of Glory, Lay on Hands,
  Blessing of Freedom, Devotion Aura, Intercession, Redemption — elk met icoon, je toets, en een korte uitleg. Een talent
  dat je niet hebt, hoort weg te vallen. Onderaan een bronregel met datums.
- [ ] `/mh group`: per knop + of − en waarom. Staat **Intercession** op + (id 391054)?
- [ ] Nu hebben bijna alle specs een Group-tab. Kijk ook even op een **alt van een andere klasse** (vooral een
  hunter met pet: staat **Primal Rage** erbij met een Ferocity-pet? Master's Call met een Cunning-pet?). Een shaman
  hoort alleen Bloodlust (Horde) óf Heroism (Alliance) te zien, niet allebei.
- [ ] Demon Hunter en Rogue horen **geen** Group-tab te hebben (`/mh group` zegt dan "no group list yet").
- [ ] Bekijk je via de spec-knoppen een andere spec en heb je die knoppen niet: dan staat er "Geen van deze knoppen
  zit nu op dit personage…", geen lege lijst.
- [ ] In het Duits/Frans: passen vijf tabs nog naast elkaar?
- [ ] Rez/Bloodlust-paneel (`/mh lust test`) op je **Prot Paladin**: staat Intercession er nog met je toets? (het
  oude nummer 461622 is eruit, alleen 391054 blijft).
- [ ] Op een **Marksmanship-hunter**: toont het paneel Harrier's Cry als jouw Bloodlust-knop, zonder "(met de juiste pet)"?
- [ ] Op een **Survival-hunter**: krijgt Primal Rage nu een plek in het toetsenschema (eerst alleen Beast Mastery)?

## 🆕 3 okt middag — "Zo speel je": 4 kaarten bijgewerkt

- [ ] Resto Shaman (AOE): Ascendance-regel + Healing Rain; S3 zegt "als je Unleash Life hebt".
- [ ] Outlaw Rogue (S4): Pistol Shot pas bij 6 stacks. Subtlety (S2 + MISTAKE) en Augmentation (S3: Breath of Eons op
  cooldown) — lees ze één keer als je die specs speelt; de bronregel onderaan elke kaart heeft nu nieuwere datums.

## 🆕 3 okt middag — "Zo speel je": Prot Paladin + interrupt-macro's

Op je **Prot Paladin**, `/mh play` (of de knop "How you play"):
- [ ] Tab "Your buttons" heeft nu **5** stappen; de vijfde: *"Pull with Hand of Reckoning, and taunt with it whenever an
  enemy hits someone else."* Met het taunt-icoon.
- [ ] De Lightsmith-regel zegt nu dat het **één knop met 2 charges** is (Holy Bulwark ↔ Sacred Weapon).
- [ ] Tab "Stay alive": bij **Word of Glory** staat *"uses the same Holy Power as Shield of the Righteous: press it when
  it is free (Shining Light)"*. Op je Ret/Holy hoort die opmerking NIET te staan.
- [ ] "Stay alive" toont op Prot geen **Divine Protection** meer (die heeft Prot niet in 12.1).
- [ ] Interrupt-macro's (Macros-tab): op een **Resto Druid**, **Preservation Evoker** of **Mistweaver** wordt geen
  kick-macro meer aangeboden (die specs hebben er geen in 12.1). Op Feral/Guardian/Dev/Aug/BM/WW wel.

## 🆕 3 okt middag — drie kleine dingen (Account snapshot / This Week)

- [ ] Account snapshot: de regel heet nu **"Silvermoon quest givers (this character): N / M done"** (was "SMC weekly
  checklist"), en **"Professions: fewer than 8 Dundun shards this week: …"** (was "Profession Dundun weekly below 8").
- [ ] "Gilded Stash (this character): N / 4 Bountiful delves on Tier 11" (was "T11 bountiful runs").
- [ ] Een alt die je deze week nog niet hebt ingelogd: "Needs a relog since the weekly reset" (geen "Wednesday" meer).
- [ ] Zet in de MH-instellingen de **Vault-herinnering uit** en open This Week: klopt het Great Vault-blok nog (staat er
  iets klaar, dan hoort het dat te zeggen)? Daarna weer aanzetten.

## 🆕 3 okt middag — This Week stap A + SMC-teller

- [ ] "Your week": de groene vinkjes zijn weg en er staat één regel **"Done this week: N (click to show)"**. Klik erop:
  komen de vinkjes terug en wordt het "(click to hide)"? Blijft je keuze na `/reload`?
- [ ] "Next up" en "N of M weekly things done" kloppen nog (die telling is niet aangeraakt).
- [ ] Weekly chores op This Week: de regel "SMC weekly checklist" is weg (de quest-gevers staan al in "Your week").
- [ ] **Account snapshot**: "SMC weekly checklist (this character)" telt nu de quest-gevers zoals "Your week"
  (bv. 4 / 6 als Liadrin, Halduron, Vereesa en Maella klaar zijn). Klopt het getal met wat je in "Your week" ziet?

## 🆕 3 okt middag — This Week korter (optie C)

Na `/reload`, op This Week:
- [ ] Volgorde: Next up → Your week → Professions → Great Vault | World Boss → Weekly chores → Rares/Ritual/Void, en pas
  **onderaan** Mount wishlist → Collectible mounts → Raids → de dagtip.
- [ ] **Get ready for Season 2** is weg (alles was afgevinkt).
- [ ] **Professions** toont alleen nog "Knowledge unspent"; de trainer-weekly staat alleen in "Your week".
- [ ] **Weekly chores** heeft alleen regels voor dít personage (SMC, Delver's Call, Gilded, Trove, Special Assignments) +
  "Open Account snapshot". Geen alt-namen meer. Staan ze nog wel op de **Account snapshot**?
- [ ] Ritual Sites en Void Assaults: geen "Weekly: done / not yet" meer.
- [ ] Hoeveel korter voelt het? (Voor: ±68 regels.)
- [x] ✅ Rob 3 okt (3 screenshots na reload): volgorde, Professions alleen Knowledge, Weekly chores alleen dit personage +
  link, Void zonder "Weekly", naslag onderaan — alles zoals bedoeld. Seizoenskaart-top niet in beeld.

## 🆕 3 okt middag — aggro: wegwijzer naar Blizzards eigen opties (threat-optie 1)

- [x] `/mh aggro`: vier regels, menunamen uit de client, geen "unknown" — Rob 3 okt live (screenshot): Aggro Display on,
  Aggro Highlight on, Combat Audio Alerts off, frame-gloed on. Nog niet naast het Settings-paneel gelegd.
- [x] ✅ Rob 3 okt na `/reload`: tip toont de titel goed. Solo-stand aan: grijze regel + geen Mythic+/Raids (screenshot).
  Solo-stand uit: Raids-blok terug, grijze regel weg (Mythic+-blok ontbreekt omdat er voor dit personage niets te melden
  is). ✅ Solo-schakelaar (4.5.0) daarmee GEMETEN door Rob.
  Na `/reload`: zegt de dagtip "Today's tip: Aggro: who is the enemy hitting?" (Rob zag eerst de ruwe sleutel
  `CODEX_AGGRO_TITLE` — AFGELEID: zijn client laadde in het gat tussen het Codex-item en de teksten; tekst staat GEMETEN
  in alle 7 Codex-blokken). Staat er na een reload nog een sleutel: echte bug.
- [ ] Codex > Dungeons & M+ > **Aggro: who is the enemy hitting?**: staan de menunamen er netjes in (geen `{UI:…}`)?
- [ ] Zet Aggro Display > Flash aan en trek in een dungeon als DPS een mob: flitst de nameplate? (Zo weten we dat de uitleg klopt.)
- [ ] **Meting voor optie 2** (staat op de voorstelpagina): de twee `/run`-regels op een trainingspop en in een dungeon
  (trash én baas). SECRET of `true` = optie 2 kan daar niet.

## 🆕 3 okt middag — spec-functies via de nieuwe Blizzard-naam (31 modules)

Niets hoort er anders uit te zien; dit is onderhoud zodat MH de volgende uitbreiding overleeft.
- [x] Na `/reload` op de 12.1.5-PTR: BugSack "You have no bugs, yay!" — Rob 3 okt (screenshot). (BugSack + BugGrabber
  stonden niet in `_xptr_`; gekopieerd uit live.) Live nog te zien.
- [x] `/run print(C_CVar.GetCVar('loadDeprecationFallbacks'),GetSpecialization==C_SpecializationInfo.GetSpecialization,C_SpecializationInfo.GetSpecialization())`
  — Rob 3 okt, 12.1.5-PTR, Frost Mage: "true" en 3. ✅
- [x] *Zo speel je*-kaart (Frost) en `/mh stats` (mastery "Freeze and Shatter" met tekst uit het spel) werken op de PTR —
  Rob 3 okt (screenshot + plak). ✅ Tank-toolkit op live als Prot Paladin (Rob 3 okt, screenshot Role Academy): "Logged in:
  Paladin - Protection", SotR + 5 defensives, geen preview-regel.
- [x] `/mh simc`: `role=spell` staat erin — Rob 3 okt. Daarbij gezien: `region=` was leeg op de PTR → gerepareerd
  (lege regionaam telt nu als ontbrekend). ✅ Daarna `region=us` — Rob 3 okt.

## 🆕 3 okt middag — valuta, crests en Great Vault (7 talen, nog niet uitgebracht)

- [ ] Crests-tab (Dawncrest-gids): staat onderaan de regel *«…of the Mist» achievements halve the crest cost…*? En
  heb je een «…of the Mist»-achievement, staat die dan als "gehaald" bij de juiste tier (de NAAM komt uit het spel —
  klopt hij)? ID's 62410/62411/62412/62414/62416 komen van Wowhead.
- [ ] Valuta-gids: past de **vijfde** knop *Zul'jarra* nog op de rij, en zet hij de pijl bij **Jan'sari the Watchful**
  op Tokka's Landing (Coiled Isle)?
- [x] ✅ Rob 3 okt (screenshot): de NPC heet in het spel **Cuzolth** <Item Upgrades>. Klikbare naam in de crests-tekst nog niet gezien.
- [x] ✅ Rob 3 okt: valuta-gids noemt Jan'sari the Watchful (Tokka's Landing, Coiled Isle) als vijfde QM; de knop zelf nog niet gezien.
- [x] ✅ Rob 3 okt: Codex-hoofdstuk Aggro toont alle menunamen netjes.
- [ ] Vault-adviseur als **Resto Druid/Holy Paladin/Disc/Holy Priest/Mistweaver** met profiel M+: staat er "M+ stat
  profile" en een M+-volgorde (Resto Druid: Mastery > Haste > Vers > Crit)?
- [ ] `/mh curscan` op een character dat crests heeft **uitgegeven**: is "totalEarned" het getal uit de tooltip
  *Current Season Maximum*? (Daarna pas de crest-telling in `CurrencyAccount.lua:495` ombouwen.)
- [ ] **21 okt (EU)**, na het wegvallen van de crest-cap: `/mh curscan` en `/mh crests save` — zakt het crest-maximum
  naar 0? Zo niet, dan toont MH nog een cap die niet meer bestaat.
- [x] 🌐 Online 3 okt, GEMETEN (wago ChrSpecialization): Devourer = **1480** → eigen stat-gewichten is een code-punt.

## 🆕 3 okt — 8 overige dungeons: nieuwe korte tips (7 talen)

Antwoorden van een helper via Wowhead (GEMETEN op de site, niet in het spel): Windrunner Spire en Maisara Caverns
alleen Normal; Saprish heeft op Normal/Heroic alleen Darkfang, Shadewing alleen Mythic/M+.
- [x] ✅ Rob 3 okt (screenshot): "Midnight Heroic: Season 2" = DN, MR, BV, AF, VA, KR, RLP, TS — Windrunner Spire en
  Maisara Caverns staan er niet bij. GEMETEN.
- [ ] Encounter Journal (Shift-J) → Saprish: verschijnt Shadewing alleen bij Mythic? (Rob 3 okt: op **Heroic** staat
  Shadewing niet in het overzicht ✅; Mythic nog bekijken. Seat heeft in het journal alleen Heroic en Mythic.)
- [ ] Na `/reload`: het MH-zijpaneel naast het Adventure Guide toont bij Saprish een spreuknaam i.p.v. `{SPELL:1263523}`
  (bug gezien door Rob 3 okt, gerepareerd in `EncounterJournalSidePanel.lua`).
- [ ] Open de dungeontips van een van deze bazen in MH: staan de korte tips er netjes, met maximaal 3 regels?

## 🆕 3 okt — delve-foutjes (in `main`, nog niet uitgebracht)

- [x] ✅ Rob 3 okt (screenshots Torment's Rise / Gnarldor Isle): niet-Bountiful = geen End + blauwe regel; Bountiful =
  End 266…295 zonder blauwe regel; overal "Vault ?". De drie tooltip-vragen hieronder zijn daarmee beantwoord.
- [ ] Delve-tooltip: hover in het Delves-tabblad over een delve die **niet** Bountiful is. Staat er bij de tiers géén
  "End …" meer, en onderaan een blauwe regel *"End-chest numbers only apply to Bountiful delves…"*?
- [ ] Delve-tooltip: hover over een **Bountiful** delve. Staat "End 266 … End 295" er nog wel, en is de blauwe regel weg?
- [ ] Delve-tooltip: staat er in de Vault-kolom overal "Vault ?" (geen "Vault 305*" meer bij Tier 1)?
- [x] ✅ Rob 3 okt (screenshots This Week): alleen "Delver's Call banked on alts" staat er, "incomplete on alts" is weg.
  Weekoverzicht (This Week / Account snapshot): is de regel *"Delver's Call incomplete on alts"* weg? De regel
  *"Delver's Call banked on alts"* mag blijven als een alt quests bewaart.
- [ ] Collegiate Calamity: zegt de route-regel in chat nu **Luminbulb** (zonder i)?

## 🆕 2 okt avond — 4.5.0: delves + Valeera, solo-schakelaar, Speed Grade weg

Rob: *"delfpagina's is goed, want ik vertrouw op jou"*. 54 teksten (enUS/nlNL; 162 vertalingen waar al een
vertaling bestond — delves die in de/fr/es/pt nooit vertaald waren blijven Engels, zoals vóór vandaag).
- [ ] `/reload` zonder fout (BugSack leeg).
- [ ] **Instellingen → Window → "Ik speel vooral solo"** aan: op Home verdwijnen de blokken Mythic+ en Raids, en
      er staat een grijze regel *"Solo-stand: Mythic+ en raids zijn verborgen…"*. Uit: alles weer terug.
- [ ] Delve-tooltip (Delves-tab, hover een rij): géén *"MidnightHelper: Speed Grade"* meer.
- [ ] Survey-uitnodiging zegt nu *acht* vragen; op de site staat vraag 8 *"Anything else you want to tell us?"*.
      Stuur hem één keer zelf in en kijk of de mail een blok *"Verder nog:"* heeft.
- [ ] Kaartlabels in `{WAY:}`: in de/fr/it staat nu het Engelse label (bv. *Sturdy Chest 1*), in es/pt vertaald.
      Alleen als het een Duitse/Franse speler stoort.
**Vragen uit de delve-review — niets veranderd, jij bent de meting:**
- [ ] The Shadow Enclave: Shadow Enclave, Infiltrate and Ameliorate: zie je daar ook zwevende Eyes of Antenorian? Ja = de Eyes-regel mag voor alle varianten behalve Mirror Shine gelden; nee = zo laten.
- [ ] The Shadow Enclave: Shadow Enclave, Traitor's Due of Shadowy Supplies: heet de zware shadow-cast van de Twilight Ogre Mage 'Sullen Shadowball' en kun je hem kicken? Ja = regel klopt; andere naam = die naam doorgeven.
- [ ] Collegiate Calamity: Collegiate Calamity, Academy Under Siege: zegt de tracker 'Arcane Wards activated 0/4'? Ja = nieuwe ROUTE klopt; staat er iets over portals = melden.
- [ ] Collegiate Calamity: Collegiate Calamity, Faculty of Fear: vallen onthulde studenten je zelf aan ('ambush')? Ja = regel blijft; nee = 'vóór de ambush' kan weg.
- [ ] Collegiate Calamity: Collegiate Calamity, boss: helpen de studenten in 12.1 nog mee, en zitten ze bij Garand aan het begin vast in een paarse cirkel? Ja = nieuwe BOSS-regels kloppen; nee = die twee regels schrappen.
- [ ] The Darkway: The Darkway: wie cast Twilight Seekers, trash of alleen Infiltrator Gulkat? Alleen Gulkat = 'Twilight Seekers' kan uit de TRASH-regel; ook trash = zo laten.
- [ ] The Darkway: The Darkway, Eggsplosive Growth: verdwijnen er eieren als je een Venom Clogged Ley Line reinigt, en zegt de tracker 7 / 45? Ja = nieuwe ROUTE klopt.
- [ ] The Darkway: The Darkway: moet je bij Shadowfuse Sentinels een cast kicken (Method noemt Discharge, een grote cirkel)? Ja = naam van de cast doorgeven, dan komt er een TRASH-regel bij.
- [ ] Parhelion Plaza: Parhelion Plaza, Caustic Crush: wat gebeurt er aan het eind? Alleen de Ritual Pillar = MH klopt; verschijnt er ook Replicating Venomborne (Icy Veins zegt dat) = dan krijgt BOSS de Venomborne-regels die al bij The Darkway staan.
- [ ] Parhelion Plaza: Parhelion Plaza, Caustic Crush: heeft de Ritual Pillar zelf aanvallen (het is in de DB2 een eigen 'encounter')? Ja = beschrijf wat je zag, dan komt er een BOSS-regel bij.
- [ ] Parhelion Plaza: Parhelion Plaza: klopt de ingang (torengebouw, tweede verdieping, trap omlaag)? Ja = nieuwe OVERVIEW-regel blijft.
- [ ] Atal'Aman: Ritual Interrupted: komt er na het redden van de furbolgs een stap bij Nalorakk's Shrine met golven vijanden? Ja = nieuwe ROUTE-regel 2 klopt. Nee = die regel eruit.
- [ ] Atal'Aman: Totem Annihilation: zie je bliksemcirkels op de grond die snel afgaan? Ja = nieuwe TRASH-regel klopt. Nee = eruit.
- [ ] Atal'Aman: Jin'Ma: loop meteen na Flaying Knife naar je spirits. Gaan ze dood of krijgt Jin'Ma een buff? Ja = de 6-secondenregel klopt.
- [ ] Atal'Aman: Disciple of Vashnik: ga achter een schedelbeeld staan als hij Toxic Froth doet. Krijg je het gif toch = 'helpt niet meer' klopt. Krijg je het niet = die zin moet eruit.
- [ ] Atal'Aman: Toadly Unbecoming: vallen beesten de gehexte Amani aan? Nee = TRASH-regel 'Beasts weg van NPCs' schrappen.
- [ ] Atal'Aman: Venomous Vapors: DB2 heeft een stap 'Tunnels exited' (CriteriaTree 222621) die de tip niet noemt. Wat moet je daar doen (springen met de Springstep Rune?)? Zeg het, dan komt er een route-regel bij.
- [ ] Twilight Crypts: Blademaster Darza: blijf op een lage tier vlak bij haar staan als ze Bask in the Twilight doet. Raakt het je hard = nieuwe regel 'ren 10 yards weg' klopt. Raakt het je niet = de regel moet anders.
- [ ] Twilight Crypts: Loosed Loa: zie je Mot'amra rood door de muren heen, en maakt het Evasive Elixir je 4 seconden een pot? Ja = nieuwe ROUTE-regels kloppen.
- [ ] Twilight Crypts: Party Crasher: casten de Twilight Summoners iets dat je kunt onderbreken? Nee = TRASH-regel 3 aanpassen.
- [ ] Twilight Crypts: Zie je in de crypten Fleshwarped Abominations die zich healen (Reconstitution) en Hexbound Necrowraiths met Necrotic Bolt? Ja = nieuwe TRASH-regels kloppen.
- [ ] The Gulf of Memory: Stap in een cirkel op de vloer (geen kaarslicht). Word je opgetild en gestund door een Sapstick Lurker? Ja = nieuwe TRASH-regel klopt.
- [ ] The Gulf of Memory: Mul'tha'ul: zet Valeera op healer. Haalt ze Hopeless Curse van je af? Ja = nieuwe regel klopt. Nee = regel eruit.
- [ ] The Gulf of Memory: Kies in de coach Mul'tha'ul (Descent of the Haranir): staan de Searing Light- en Sporbit-regels er nog tussen? Met de nieuwe tekst horen ze weg te zijn; staan ze er wel, dan is het filter de oorzaak.
- [ ] The Grudge Pit: Fungal Pharmacon: welke stappen toont je tracker? DB2 (live) heeft twee versies: (a) 3 Ula'tek Burrows in + 4 Lesser Ritual Pillars + slangen killen, of (b) 10 Pharmacon verzamelen + 4 pillars + vijanden. Zeg welke, dan maken we de route precies. Staan de pillars níét in de burrows, dan moet 'go down into the Ula'tek Burrows' anders.
- [ ] The Grudge Pit: Lightbloom Invasion: blaas je de 3 Unstoppable Thornmaws op door op Bomb Spores (of tonnen) te klikken? Ja = nieuwe regel klopt. Blazen bevrijde fighters ook spawn points op (zoals Icy Veins zegt), dan komt dat er weer bij.
- [ ] The Grudge Pit: Dastardly Rotstalk: werkt taunten alleen in een van de bewegende spotlights? Ja = nieuwe regel klopt.
- [ ] The Grudge Pit: Dastardly Rotstalk: doen de Angry Fans pijn als je ze negeert? Nee = TRASH-regel 3 aanpassen.
- [ ] The Grudge Pit: Zie je ooit een Disciple of Vashnik in de Grudge Pit? DB2 heeft daar een encounter (3522), maar geen verhaal eindigt bij hem; waarschijnlijk ongebruikt. Nee = niets doen.
- [ ] Sunkiller Sanctum: Esuritus: lees de castbalk van de bolt die hij op je richt. Heet hij Calling Bolt of Singular Bolt, en lukt een interrupt? Lukt het = de bullet 'Interrupt Calling Bolt' blijft, maar check of de tooltip in de coach 'Instant' zegt (dan hoort er een andere id bij). Lukt het niet = de bullet moet weg.
- [ ] Sunkiller Sanctum: Esuritus: onderbreek of stun een Voidcaller terwijl hij channelt. Gaat hij meteen dood? Ja = waardevolle tip om toe te voegen (alleen de video van Roguery zegt dit). Nee = niets doen.
- [ ] Sunkiller Sanctum: Gravitational Effect: zijn het precies 5 coils in de lucht en 5 Stabilizers op de grond? Ja = nieuwe ROUTE-tekst klopt. Ander getal = getal aanpassen.
- [ ] Shadowguard Point: Chief-Arcanist Patram: hoe heet de add die na Dark Communion verschijnt (Icy Veins: Void Emissary, Method: Dark Harbinger)? Naam gezien = die naam in de BOSS-bullet zetten.
- [ ] Shadowguard Point: Chief-Arcanist Patram: lukt een interrupt op Submit to the Void? Ja = nieuwe bullet klopt. Nee = 'Interrupt it' weghalen; de tooltip zegt Magic, kijk dan of een dispel hem weghaalt.
- [ ] Shadowguard Point: Disciple of Vashnik: ga tijdens Toxic Froth achter een muur of pilaar staan. Krijg je toch de volle 8 seconden schade, en liggen er daarna healing orbs? Allebei ja = bullet blijft. Muur helpt wel = die zin schrappen. Geen orbs = 'pak daarna de healing orbs' schrappen.
- [ ] Shadowguard Point: Disciple of Vashnik op Tier 11: vind jij hem de zwaarste delve-baas van dit seizoen? Nee = de zin over 'many players' schrappen (Icy Veins noemt hem 'not too bad').
- [ ] Shadowguard Point: Captured Wildlife: krijg je na de kooien echt aas van Lysikas, met een extra knop bij de Void Researchers? Ja = nieuwe ROUTE-bullet klopt.
- [ ] Torment's Rise: Vlieg naar de ingang van Torment's Rise in Voidstorm (61.2, 71.3) en loop de rookmuur in. Kom je binnen bij Nullaeus? Ja = de nieuwe BOSS-tekst is nuttig en de kaart blijft. Je wordt naar Silvermoon gezet (zoals een speler op 13 aug meldde) = de hele kaart is seizoen 1-geschiedenis; kies dan of hij weg mag of alleen de OVERVIEW houdt.
- [ ] Torment's Rise: Heb je nog een Beacon of Hope in je tassen: kun je hem in een delve nog gebruiken? Ja = de ROUTE-bullet moet zeggen wat hij nu oproept. Nee = de nieuwe ROUTE-tekst klopt.
- [ ] Torment's Rise: Alleen als je binnenkomt: probeer Devouring Essence te onderbreken. Lukt het = je kunt 'Dispel it' aanvullen met 'or interrupt it' (Icy Veins zegt ja, Method zegt nee).
- [ ] Venomfall Deeps: Ga solo naar binnen in Venomfall Deeps en typ /mh mark vóór de pull. Verschijnt de markerbalk en kun je 4 world markers neerzetten? Ja: de tip klopt zoals hij staat. Nee: de balk wacht op een groep (FastMark.lua vraagt IsInGroup), en de BOSS-tip moet dan Blizzards eigen world markers noemen in plaats van /mh mark.
- [ ] Venomfall Deeps: Klik de nieuwe waypoint 51.2, 31.0 op de Coiled Isle. Kom je bij de deur van Venomfall Deeps uit? Ja: waypoint mag erin. Nee: noteer waar de deur echt staat (/mh here buiten de deur).
- [ ] Venomfall Deeps: Haal Blessing of Potency uit een zware kist en lees de tooltip van de buff. Staat er 'all of your stats'? Dan klopt de nieuwe tekst. Staat er 'secondary stats'? Dan was de oude tekst goed en vervalt deze correctie.
- [ ] Gnarldor Isle: Sturdy Chest 3 in Gnarldor Isle: staat de kist bij onze pijl (28.67, 41.69) of zo'n 3 eenheden noordelijker (rond 28.4, 38.2, 'achter blokken links van de trap naar boven' volgens Icy Veins)? Bij onze pijl: laten staan. Noordelijker: waypoint aanpassen naar wat /mh here bij de kist zegt.
- [ ] Gnarldor Isle: Minchi's Osseous Adventure: wat staat er in het doel bij de bottenhopen, 0/4 of 0/6? 0/4: de nieuwe tekst klopt (hotfix eind augustus). 0/6: de hotfix is teruggedraaid en de oude tekst was goed.
- [ ] Gnarldor Isle: Gralka met Valeera op DPS: onderbreekt ze Purging Breath, en wat gebeurt er dan? Onderbreekt ze hem en ga je dood of komt er iets ergs: de nieuwe Healer-regel klopt en verdient misschien de reden erbij. Onderbreekt ze hem niet: de nieuwe regel kan weg.
- [ ] Gnarldor Isle: Bij Scrollmaster Ruma bij de ingang: geeft ze It's a Satchel, Not a Bag, en ligt Ruma's Satchel binnen op 25.40, 34.73? Ja: de nieuwe OVERVIEW-regel klopt. Nee: noteer welke quest ze wél geeft.
- [ ] The Ring of Glory: Crushfoot (Open Night): zie je in de toren noordoost en zuidwest een blauw gloeiende bol die je naar de andere toren teleporteert, en stopt het zijn charge als je erin stapt? Ja: de zin 'dat hebben wij zelf niet getest' mag eruit. Nee: laten staan zoals hij is.
- [ ] The Ring of Glory: Gnok, eerste fase (Adopt-a-thon): wat doet Pulverize? Gooit hij je weg en vertraagt hij je (Icy Veins), of is het alleen een klap (Method)? Wegslaan: er hoort een regel bij ('vecht hem waar de knockback je niet in een pack gooit'). Alleen een klap: niets toevoegen.
- [ ] Valeera/systeem: Delves-tabblad, beweeg over een delve-rij: staat er bij Tier 1, 6 of 7 'Vault 305*'? Volgens Wowhead hoort dat 279, 298 en 302 te zijn. Kijk ook wat de drie vault-vakjes tonen ('Tier X (ilvl Y)') in een week waarin je een Nightmare Prey-hunt deed.
- [ ] Valeera/systeem: In een delve met Valeera's venster open: dood één vijand en loot NIETS. Gaat 'XP tot nu toe' omhoog? (test voor 'doden telt ook')
- [ ] Valeera/systeem: Doe een Tier 11-delve die NIET Bountiful is, met levens over, op Delver's Journey rank 4 of hoger. Verschijnt er een Gilded Stash in de schatkamer?
- [ ] Valeera/systeem: Doe een gewone (niet-Bountiful) delve op Tier 4 of hoger en kijk naar het item level uit de eindkist. Blijft dat op het Tier 3-niveau (272 of lager), zoals Icy Veins zegt?
- [ ] Valeera/systeem: Hover bij de ingang van een delve op Tier 11 over het Gilded Stash-icoon: staat er 'x/4' per week?
- [ ] Valeera/systeem: Kijk op de kaart hoeveel Special Assignments je deze week kunt doen, over alle zones samen. Klopt 3?
- [ ] Valeera/systeem: Kill een rare in Eversong of Zul'Aman (niet Coiled Isle) en lees /mh shards: hoeveel shards gaf hij (25, 50 of 75)?

## 🆕 2 okt middag — Mythic+ voor beginners (Codex + `/mh mplus`, enUS + nlNL)

Rob: *"ik keur het goed"* (pagina `mplus_review.html`). Nu in 7 talen; knopnamen komen uit de client zelf (Rob koos
"uit het spel zelf"): `{UI:NAAM}` in de tekst wordt Blizzards eigen woord, Engels als terugval.
- [ ] `/reload` zonder fout (BugSack leeg).
- [ ] **`/mh uinames`**: 10 regels. Staat er achter elke naam het Engels dat je op je scherm ziet (Dungeons & Raids,
      Premade Groups, Start a Group, List Group, Sign Up, Mythic+ Dungeons, Activate, Guild Finder, Mythic+ Rating,
      **Learning**)? Rood "missing" = die naam bestaat niet in jouw client. ⚠️ Vooral **Learning**: dat
      `GROUP_FINDER_GENERAL_PLAYSTYLE1` Learning is (en niet Relaxed) is AFGELEID uit de volgorde, niet gemeten.
- [ ] `/mh codex` → **Dungeons & M+**: staat bovenaan *"Mythic+, vanaf je eerste key"*, en staan de knopnamen er netjes
      in (geen `{UI:…}` meer zichtbaar)?
- [ ] Niet-getokeniseerde schermwoorden zijn in de/fr/es/pt/it door de vertalers gekozen, NIET in een client gezien:
      *Find a Community*, het venster *Guild & Communities*, de categorie *Dungeons* en de moeilijkheid *Mythic*. Pas
      als iemand met zo'n client meekijkt.
- [ ] Zoekvak: typ *first key* of *premade* → vindt hij het hoofdstuk?
- [ ] Op een personage **zonder** M+-runs dit seizoen: `/mh mplus` toont onder "Nog geen keystone-runs" een gele regel
      *"Nog nooit een key gelopen? Typ /mh codex en open Dungeons…"*. Met runs hoort die regel er NIET te staan.
- [ ] `/mh mplus` onderaan: de gear-regel zegt nu *"De kist aan het eind gaat van Champion naar Hero; alleen de Great Vault
      geeft Myth, vanaf +10."*
- [ ] Group Finder → Start a Group: heet het keuzevak echt **"Select Playstyle (required)"** met **Learning** erbij?
      (Naam komt uit build 12.1.5 op wago.tools, niet uit live 12.1.0.)
- [ ] Silvermoon: waar staat **Lindormi** precies? Bronnen zeggen 42.1, 58.8 (wiki) óf 53.3, 66.1 (Icy Veins). Het
      hoofdstuk zegt nu alleen "naast het portaal naar The Timeways".

## 🆕 2 okt middag — 8 M+-dungeons (korte tips) + lange raidtips (7 talen)

Rob keurde beide pagina's goed. Dungeons: VA, BV, AF, TS, RL (13 tips) + DN, MR, KR (10 tips). Raid: 29 lange teksten
(`_STEPS`/`_TANK`/`_HEALER`/`_DPS`).
- [ ] `/reload` zonder fout.
- [ ] Bij je volgende M+-run: klopt de korte tip van die dungeon? Zeg per baas wat niet klopte.
- [ ] **Den of Nalorakk, Nalorakk op Heroic:** springt Zul'jarra achter de tank met een schild, en raken de drie klappen
      dan iedereen? (De 12.1-journal zet dit deel alleen op Mythic. Ja = tip klopt overal; nee = er komt "Op Mythic:" voor.)
- [ ] **Kings' Rest, Mchimba (de-/fr-/es-/pt-/it-client, als je iemand kent):** hoe heet de knop om uit de kist te komen?
      Alle vijf vertalingen zeggen nu "Struggle" in het Engels.
- [ ] **Afgeleid, niet gemeten** (de helper zei het zelf): de nieuwe Mythic-regel bij **Vaelgor** (*"de draken vliegen nog
      op, Astral Reflection-klonen blijven casten"*) en de DPS-zin bij **Averzian** (*"de soak stopt twee Voidshapers"*).
**Vragen uit de lange raidtips — niets veranderd, jij bent de meting:**
- [ ] Entombed Sentinels, Normal, pauze: twee spelers raken elkaar aan onder de 4 groene bollen — worden ze alleen uit
      elkaar geduwd (tekst klopt), smelten de bollen samen (zin anders), of gaat er iemand dood (zin eruit)?
- [ ] Vashnik, Caustic Explosion na een dispel: zelfde schade dichtbij en ver weg (dan mag "step away" weg) of minder ver
      weg (tekst klopt)? Kijk in Details.
- [ ] Vashnik, Dripping Fangs (tank): staat er 100% (klopt "verdubbelt") of 200% meer fysieke schade?
- [ ] Twin Fangs, Normal, Ravenous Feast: straf als er minder dan drie in een klap staan? Geen straf = die zin kan weg.
- [ ] Twin Fangs, Normal, Ravenous Feast: tel je Eternal Venom-stacks vóór en na alle drie de klappen (1 minder = per
      Feast, 3 minder = per klap).
- [ ] Coiled Altar, Normal, Gloombomb: laten óók niet-gemarkeerde geraakte spelers zielkopieën vallen (Gravebound)?
- [ ] Coiled Altar, Normal, Eternal Nightfall: stopt de cast vanzelf als het schild breekt, of moet er nog een kick?
- [ ] Vorasius: staat de stack Primordial Power na een Roar op JOU (raid-DoT) of alleen op de BAAS?
- [ ] Vaelgor & Ezzorak, Normal: krijgt iemand Shadowmark in de intermission? Ja = hoort bij alle moeilijkheden.
- [ ] Vaelgor & Ezzorak, Normal: grote klap op de raid bij de laatste Nullzone-tether (oude tekst klopte) of kleine tik?
- [ ] Crown of the Cosmos, Normal, eerste tussenfase: debuff na een pijl (8 s, meer pijlschade)? Ja = geldt ook op Normal.
- [ ] Belo'ren, healer: krijgt IEDEREEN de heal absorb + DoT, of maar een paar spelers?
- [ ] Belo'ren, tank: krijgt de baas een stack als de frontal de tank van de VERKEERDE kleur raakt?
- [ ] Chimaerus, healer: duurt Caustic Phlegm ±12 s (tekst klopt) of ±20 s?
- [ ] Chimaerus, Consume (100 energie): heeft dicht op elkaar staan nut?
- [ ] Chimaerus, na de soak: blijf je in dezelfde zaal (dan worden "boven/omlaag" herschreven) of ga je echt omlaag?

## 2 okt — 17 raidbazen: nieuwe korte tips (extra high-ronde, `RaidTips.lua`, 7 talen)

Rob: *"alles goed, zet ze er maar in"* (beoordeeld op https://claude.ai/artifact/CWjDGP9K3dqGtsjoZGMgCz).
- [ ] `/reload` zonder fout (BugSack leeg).
- [ ] Bij je volgende raid: staat in het tipvenster bij de pull het nieuwe korte blok? Herkenbaar voorbeeld:
      Chimaerus begint met *"Soak: A circle appears on the tank. When it is your group's turn, all of you stand in it
      at once."* De Twin Fangs-tip is ook herschreven.
- [ ] Klopt het advies in het gevecht zelf? Zeg per baas wat niet klopte — jij bent de meting.
- [ ] Past het blok nog in het venster? De nieuwe tips zijn soms langer (tot 2 zinnen per regel).

## 1 okt — Twin Fangs-tip: de draaiende gifstraal (`RaidTips.lua`)

- [ ] Open de tips van de Twin Fangs (Raids → Venomous Abyss, of het tipvenster bij de pull): staat er onderaan
      *"Middle (at full energy): … The orbs spinning around her head show which way it turns. Walk against it…"*?
- [x] ✅ (Rob, 1 okt, Normal: "Hij gaat niet helemaal 360 graden rond") de straal gaat **niet** helemaal rond —
      Method had gelijk, de tip ("achter de straal ben je veilig") klopt zo.

## 🆕 1 okt — karakteroverzicht als kolommen (`AltBoardView.lua`, idee van AltBoard)

- [x] ✅ (Rob, 1 okt, screenshot: "kolommen werken") kolommen naast elkaar met kopjes; knop *Rows* rechts.
- [x] ✅ (Rob, idem) klik op een naam → kaart met gear (icoontjes, namen in kleur, ilvl rechts).
      ⚠️ Zijn klacht: de kolommen kregen maar een smal strookje onder het weekblok → gerepareerd, zie hieronder.
- [x] ✅ (Rob, 1 okt: "kolommen en big window werken, ben ik ook blij mee") `/reload`: het blok *This week* klapt **één keer** vanzelf in zodra de kolommen verschijnen (daarna blijft jouw
      eigen +/- staan). Krijgen de kolommen nu de ruimte?
- [x] ✅ (Rob, idem) Knop **Big window** boven de kolommen → een groot venster van bijna je hele scherm met alle kolommen en rijen in
      één keer. Meer characters naast elkaar? In het hoofdvenster staat dan een korte zin. *Back here* of Esc sluit het,
      en de kolommen staan weer in het hoofdvenster.
- [ ] Goud, rested XP, spec en gear verschijnen pas bij een character nadat je er **één keer op hebt ingelogd** (oudere
      records tonen een streepje). Klopt dat bij een alt die je nog niet opnieuw opende?
- [x] ✅ (Rob, 1 okt: "die kloppen") **Beroepen:** de getallen uit `GetProfessionInfo` komen overeen met het
      beroepenvenster — GEMETEN.
- [ ] Veel characters: verschijnen < en > met "1-5 van 9", en bladert het?

## 🆕 1 okt — vragenlijst: uitnodiging in het spel (`SurveyInvite.lua`)

- [ ] `/reload`, dan `/mh survey` → het kopieervenster met **midnighthelper.com/survey/?from=game** (in het Nederlands
      `/nl/survey/`). Plak de link in je browser: opent de vragenlijst?
- [x] ✅ (Rob, 1 okt, screenshots: "alles goed") `/mh survey popup` → de pop-up zoals spelers hem zien, met drie knoppen: *Show the link* / *Later* / *No thanks*.
      Doen alle drie wat ze zeggen? (Later = chatregel; No thanks = kaartje op This Week weg.)
- [ ] `/mh survey why` → zegt het of de pop-up zou verschijnen en waarom niet. Open This Week: staat er een kaartje
      *"Two minutes for Midnight Helper?"*?
- [x] ✅ (Rob, 1 okt 23:09, screenshot) Zelf ingevuld via de link uit het spel → mail *"[MH vragenlijst] cijfer 5 ·
      en · via game"* met alle antwoorden en de `DATA:`-regel; site toont *"Thank you!"*. Hele keten GEMETEN.

## 🆕 1 okt — debug-regel weg (CurseForge-reactie)

- [ ] Log in (of `/reload`) op een character **zonder beroepen**, of open MH → beroepen: er staat géén
      *"Debug: Found profession …"* meer in de chat.

## 🆕 30 sep laat — Armory-knop + "snel of precies" in beide vensters

- [x] ✅ (Rob, 30 sep laat: "reload gedaan, beide knoppen werken") 🆕 `/reload`, karakterscherm (C) → onderaan het MH-paneel nu **twee** knoppen: eerst *"Quick advice: Armory
      website"*, dan *"Best set from your bags: Raidbots (test)"*. Klik de eerste → het export-venster; bovenaan staat
      **midnighthelper.com/armory** en de regel *"Want the exact answer … /mh raidbots (test phase)"*. Staat de tekst
      eronder nog in beeld?
- [x] ✅ (Rob, idem; of alles in het venster past is niet apart genoemd) Klik de Raidbots-knop → onderaan de uitleg een nieuwe regel *"Rather a quick answer … /mh export and
      midnighthelper.com/armory"*. Past alles nog in het venster?

## 🆕 30 sep — `/mh raidbots`: tekst voor Raidbots Top Gear (`SimcExport.lua`)

- [x] ✅ (Rob, 30 sep avond, screenshot: "beide werken") 🆕 `/reload`, open je karakterscherm (C) → onderaan het MH-paneel ernaast: *"Best set from your bags: Raidbots
      (test)"*. Klik → het Raidbots-venster opent, bovenaan een **oranje** testfase-regel en 5 stappen. Past alles erin?
- [ ] Site: midnighthelper.com/raidbots (en /nl/raidbots) → 7 stappen met gouden nummers en een oranje testfase-blok;
      Armory → Best set → knop *Step by step* gaat erheen.

- [ ] `/reload`, `/mh raidbots` → venster *"For Raidbots Top Gear"*, chat *"Raidbots text ready, with N item(s)…"*.
      Bovenaan `paladin="Twelveinchy"`, `spec=protection`, een regel `talents=…` (lange code), dan per slot
      `head=,id=…,bonus_id=…`, onder *### Gear from Bags* de tas-items met `# ` ervoor, onderaan `# Checksum: …`.
- [x] ✅ (Rob, 30 sep avond, screenshot) Raidbots leest het: Twelveinchy, 90 Blood Elf Protection Paladin, Khadgar (EU),
      talenten, gear-iconen, ilvl 282, set *Radiance of the Consecrated Flame*, Omnium Folio-sectie. Labels: *Unverified
      Input* (tekst komt niet van de SimC-addon zelf — we doen bewust niet alsof) en *Tank* (Raidbots' eigen tank-waarschuwing).
      ⏳ Nog: tas-items aanklikken → Find Top Gear (eerste poging: "requires at least two combinations" = niets aangeklikt).
- [ ] Ctrl+C → raidbots.com/simbot/topgear → plakken. **Dé test:** leest Raidbots hem zonder foutmelding? Klopt je
      karakter (naam, spec, talenten, item levels)? Staan je tas-items als keuze klaar? Screenshot, of plak de
      foutmelding van Raidbots letterlijk.
- [ ] Zelfde op de Shaman (staf) en op een alt met een crafted item (dan staat er `crafted_stats=` in de regel).
- [ ] Site → Armory → Best set: onderaan het blok *"Want the exact answer…"* met de knop *Open Raidbots Top Gear*.

## 🆕 30 sep — paneel battle res & Bloodlust (`GroupRezLust.lua`)

- [x] ✅ (Rob, 30 sep, screenshot op Shaman "Earthshammy": "deze werkt") `/mh lust test` → paneel met *"Battle res:
      shared charges only in a Mythic+ key…"*, geel *"Nobody in your group can revive in combat."*, groen
      *"Bloodlust: ready"*, *"Can cast Bloodlust: Earthshammy (Shaman)"* in klassekleur.
- [x] ✅ (Rob, 30 sep, Twelveinchy) *"Can revive in combat: Twelveinchy (Paladin)"*.
- [x] ✅ (Rob, 30 sep: "toets klopt") 🆕 (Rob, 30 sep: "ook de knop erbij") `/reload`, `/mh lust test` op Twelveinchy → onder *Can revive* een regel
      *"Intercession: Your key: <toets>"* (of oranje *"Not on a key on your action bars yet."*). Klopt de toets? Sleep
      Intercession naar een andere knop terwijl het paneel open is → de toets verandert mee. Op de Shaman: dezelfde regel
      onder *Can cast Bloodlust* met Bloodlust/Heroism.
- [x] ✅ (Rob, 30 sep avond: "de toets bij Redemption klopt ook, ook de andere toetsen voor de Battle Res")
      Redemption (out of combat) + Intercession tonen de juiste toets.
- [x] ✅ (Rob, 30 sep avond, screenshot in een echte groep) *"Battle res: no shared charges here…"*, *"Twelveinchy
      (Paladin) - Intercession"*, Intercession toets R, Redemption (out of combat) toets s-R, **"Hero: used - ready again
      in 0:41"** zonder "~" (= echte eindtijd van de Sated-debuff GEMETEN leesbaar), *"Sizle (Shaman) - Bloodlust,
      Magedobby (Mage) - Time Warp"* in klassekleur (Horde → Bloodlust klopt). ✅ Log gelezen na `/reload`: Sated in
      gevecht leesbaar mét eindtijd (841×); raidbaas-pot 99/99 (→ nu "no real limit in this fight").
- [x] ✅ **Raid, GEMETEN 1 okt (Rob, Normal Venomous Abyss, log + 2 screenshots):** difficulty 14 = **9 ladingen**,
      herladen **330 s**; paneel *"1 of 9 left · next in 1:58"*, op nul **rood** *"0 of 9 left · next in 3:23"* (898
      metingen, alle "ok"). LFR gaf eerder 99/99, 108 s. Hero herkent Sated (57724) én Exhaustion (57723).
- [ ] **In een M+-key** (de echte krappe pot): *"Battle res: 1 of 1 left"* of zo, en na een brez *"next in m:ss"*. Daarna
      `/mh lust` + `/reload`. En: welke raid/difficulty gaf 99 ladingen? (vanaf nu staat de difficulty in de log)
- [x] ✅ (Rob, 1 okt, screenshot in LFR op de Shaman) titel *"Battle res & Hero"*, spreuknaam per speler
      (Intercession, Rebirth, Primal Rage), **gemengde factie GEMETEN**: Earthshammy (Horde) *Bloodlust*, Ferosta
      (Alliance) *Heroism*; eigen regels *Ancestral Spirit (out of combat): 0* en *Bloodlust: 5*.
      Oorspronkelijke test: (Rob, 30 sep avond: "wordt gewoon hero genoemd … voor elke spec zijn eigen naam") `/reload`, `/mh lust test`
      → titel *"Battle res & Hero"*, regels *"Hero: ready"*, *"Can cast Hero: Twelveinchy…"* ontbreekt (Paladin kan geen
      Hero) maar *"Can revive in combat: Twelveinchy (Paladin) - Intercession"* staat er met de spreuknaam. Op de Shaman:
      *"Earthshammy (Shaman) - Heroism"* (Alliance) of *Bloodlust* (Horde). Beweeg erover: uitleg begint met *"Hero (Bloodlust,
      Heroism, …)"*.
- [ ] 🆕 (Rob, 30 sep: "waarom niet in een delve als we met meerdere zijn … en de normale res buiten combat")
      Nu in **elke groep** in een dungeon, delve of raid. Test: ga met iemand een **delve** of **normale dungeon** in →
      het paneel staat er vanzelf, met *"Battle res: no shared charges here - everyone has their own cooldown."* Op
      Twelveinchy staat nu ook *"Redemption (out of combat): Your key: …"* onder Intercession. Klopt die toets?
- [ ] Instellingen → Dungeon-hulp → **Only in Mythic+ keys and raids** aan → in de delve/normale dungeon verdwijnt het
      paneel, `/mh lust` zegt *"…the setting says Mythic+ keys and raids only"*. Weer uit → het is terug.
- [x] ✅ (Rob, 30 sep avond, screenshot: X rechtsboven zichtbaar, "beide werken"; het wegblijven tot de volgende
      instance nog niet apart gezien) 🆕 (Rob, 30 sep: "sluit knop") Rechtsboven op het paneel een **X**. Muis erop → uitleg. Klik in een dungeon → het
      paneel is weg, ook na `/reload` in dezelfde dungeon; `/mh lust` zegt *"closed with the X for this instance"*.
      Dungeon uit en een nieuwe in → het staat er weer.
- [ ] Beweeg erover → uitleg over beide. Slepen → het blijft daar staan na `/reload`.
- [ ] Instellingen → Dungeon-hulp → **Paneel battle res & Bloodlust** uit → `/mh lust` zegt *setting off*.
- [ ] **In een M+-key of raid, in een groep** (hier zit de echte meting): het paneel staat er vanzelf. In de key:
      *"Battle res: 1 of 1 left"* (of meer), en na een brez *"… next in m:ss"*. Kreeg de groep Bloodlust → *"used -
      ready again in 9:5x"* en dat telt af. Na afloop `/mh lust` → onderaan regels `brez combat:key …` en
      `lust combat:seen …` → `/reload` zodat ik ze uit het bestand kan lezen. Dáármee zijn de twee reads GEMETEN.
      Rob gebruikt EllesmereUI nu níét (30 sep) → `/mh lust` hoort *EllesmereUI shows: battle res no, Bloodlust no*
      te zeggen en alle regels staan er. Zegt hij "yes", dan is EllesmereUIQoL tóch geladen — meld het.
- [ ] Iemand in de groep is Druid/DK/Warlock/Paladin → staat bij *Can revive*; Shaman/Mage/Evoker/Hunter → bij
      *Can cast Bloodlust* (Hunter met *(with the right pet)*).

## 🆕 27 sep — metingen: plattegronden, zwevende iconen, dispel

- [x] ✅ (Rob, 27 sep: The Venomous Abyss, map 2606, met Nek'zali) `/mh mapprobe show <getal>` tekent een plattegrond
      met doodshoofdjes bij de bazen.
- [x] ✅ (Rob, 27 sep, screenshot) `/mh mapprobe`: bij de dungeons "map 0" → daarvoor is een tweede weg gebouwd.
- [x] ✅ (Rob, 30 sep: "deze werkt ook") 🆕 **Kaartvenster**: Codex → Raids → klap een raid open → naast *Route to* staat **Map**. Klik: plattegrond,
      knoppen per verdieping (als die er zijn), doodshoofden met bazennamen. Beweeg over een baas → tooltip; klik →
      MH's tips voor die baas.
- [x] ✅ (Rob, 27 sep) dungeon-kaarten werken. 🆕 De knop **Map** staat nu náást *Route to …*, zoals bij de raids.
- [x] ✅ (Rob, 27 sep, impliciet: "de kaarten werken") The Voidspire, The Dreamrift, March on Quel'Danas.
- [x] ✅ (Rob, 27 sep) Raids én Dungeons: *Route to …* en **Map** staan nu direct **onder de bewegende bazen**.
- [x] ✅ (Rob, 27 sep, screenshot "-> Pit of Fangs") meting overgangen: 57 in totaal.
- [x] ✅ (Rob, 27 sep: "de overgangen werken") In het echte kaartvenster (**Map**-knop), bv. The Venomous Abyss of Windrunner Spire: groene labels met de naam
      van een verdieping bij de trappen/portalen. Beweeg erover → tooltip; klik → die verdieping verschijnt.
- [x] ✅ (Rob, 27 sep) Delves-pagina: kaart-icoontje werkt "meestal". 6 zonder kaart: The Shadow Enclave, The Gulf
      of Memory, The Grudge Pit, The Ring of Glory, Venomfall Deeps (Zul'Aman) en (The Coiled Isle).
- [x] ✅ (Rob, 27 sep: "alle delves hebben nu de map werkend") na de ruimere naamvergelijking.
- [ ] In een dungeon: `/mh map` opent de verdieping waar je staat.
- [ ] Zwevende iconen op de Paladin: als ze er staan `/mh whatis 5`, muis erop, daarna `/reload`.
- [x] ✅ (Rob, 27 sep, Nexus-Point Xenas) rechtsklik castte Cleanse Toxins (castlog), maar de rode kleur bleef. Zijn
      debuff: Blistering Smite, **zonder type** in de tooltip.
- [ ] 🆕 **Solo testen:** `/mh partytest` (buiten gevecht) → alleen je eigen regel, zonder groep. Laat een rare of mob
      je een Poison geven (Venomous Infusion) → regel rood → rechtsklik op je naam → gaat het rood weg? Ook een mob
      met een Magic-debuff proberen: wordt de regel dan óók rood (= vals alarm voor Prot)?
- [ ] 🆕 **Automatisch (niets typen):** gewoon spelen in een groep (of met `/mh partytest`). Na elk gevecht kijkt MH
      welke van jouw debuffs het spel nog "wegneembaar" noemt. Is dat iets wat jouw spec níét kan weghalen, dan
      komt er één chatregel *"dispel check: your row is red for X (type: …)"*. Na de sessie: `/reload`.
- [ ] Als **je eigen** regel rood is: `/mh glow` → nieuwe regel *"your own debuffs now: naam [type]"*. Screenshot.
      Staat daar alleen Magic of "no type" terwijl de regel rood is, dan kleurt het spelfilter op klasse, niet op spec.

## 🆕 29 sep — crests (na de vergelijking met Gandalin)

- [x] ✅ (Rob, 29 sep) `/reload`, Codex → Currencies → **Crests**: de 3e regel zegt nu dat de cap telt wat je deze season hebt
      **verdiend** (niet wat je hebt), en elke week omhooggaat.
- [ ] Doe je een **Tier 11 Bountiful Delve**: wat geeft de **Gilded Stash** aan crests? Staat daar **Myth**, dan
      klopt de zin "Myth haal je solo niet" in MH niet meer. Screenshot van de loot of de crest-tooltip.

## 🎬 28 sep — opnames voor de website (Rob: "doe twee maar")

Drie korte filmpjes uit het spel voor midnighthelper.com. Elk ± 10 seconden; ik knip er het mooiste stuk uit.
**Opnemen met Win+Alt+R** (start én stop), die neemt je hele scherm scherp op. Discord-clips kan ook, maar zet dan
de kwaliteit op de hoogste stand: je huidige Discord-clips zijn 1920×540 (GEMETEN), te klein om het MH-venster uit
te knippen op jouw brede scherm. Zet het MH-venster **midden** op je scherm en beweeg rustig.
- [x] ✅ (29 sep, online) **Speel-kaart:** `/mh play`, even stil laten staan zodat je de toetsen op de icoontjes ziet, dan één keer
      naar een ander tabblad (bv. Stay alive) en terug.
- [x] ✅ (29 sep, online) **Kaart:** open een raid in MH → knop **Map** → wacht 2 tellen → klik op een doorgang (overgang) zodat hij van
      verdieping wisselt. (In een dungeon kan ook: `/mh map`.)
- [ ] **Slijtage** (als je gear echt laag is; start de opname via **Win+G** → rode knop, niet Win+Alt+R): `/mh durability test` → de grote waarschuwing verschijnt (geluid doet er niet toe, de site speelt
      zonder geluid).
Klaar? Zeg het me: ik snijd bij (`tools/make_clip.py` in de site-repo, via de voordeur `scratch make_clip.py`), en
zet ze in een concept dat je eerst ziet voordat het online gaat.

## 🆕 28 sep — `/mh export` (Armory-website)

`/reload`, dan `/mh export`.
- [x] ✅ (Rob, 28 sep, 2e poging) venster opent, Ctrl+C werkt. 1e poging: `|h |r |n |t` werden door het tekstvak als
      WoW-codes opgegeten ("Eead", "are") → nu als `||` in het venster, kopieert als één `|`.
- [x] ✅ Regel 2 `char=Twelveinchy;class=PALADIN;spec=Protection`; 16 regels `E|…`.
- [x] ✅ Helm `str` 116, `sta` 2142: STR/STAMINA-keys werken (VERIFY afgevinkt voor Strength; Agility nog op een agi-klasse).
- [x] ✅ 28 tas-items als `B|…`, geen potions/reagents.
- [ ] Chat zegt *"Gear export: N items."* Zegt hij dat items nog laden, dan werkt de tekst zich binnen een paar tellen bij.
- [x] ✅ (Rob, 29 sep) Zoek in de MH-zoekbalk op "export": de regel `/mh export` verschijnt.
- [x] ✅ (Rob, 30 sep, Shaman) Plak de tekst op de site → "Calculate best set": werkt, 37 items gelezen. MAAR hij
      adviseerde een schild (Wailing Bulwark, +561) naast zijn **staf** → gerepareerd (export veld 12 `hands`, site kiest
      wapens als paar). ⏳ Opnieuw: `/reload`, `/mh export` → wapenregels eindigen op `|2` (staf) of `|1`; plakken →
      geen schild meer, off hand-regel weg (of *"Leave empty: … takes both hands"*).
- [x] ✅ (Rob, 30 sep, 2e export) staf-fix: geen schild meer, *Lightgrasp Worldroot — Keep*, off hand-regel weg.
- [x] ✅ (Rob, 30 sep) de Ouroboric Signet-tooltip zegt **Unique-Equipped** → gebouwd: export veld 13 `unique`
      (`i<itemID>:1` of `c<categorie>:<n>`, uit de tooltip), site kiest nooit meer dan toegestaan.
- [x] ✅ (Rob, 30 sep, Twelveinchy-export) GEMETEN: tooltip-route werkt — Ouroboric Signet `||i272150:1`, alle 4
      gedragen ringen/trinkets en de tas-ringen/trinkets dragen een `i…:1`; wapen en schild eindigen op `|1`.
- [x] ✅ (Rob, 30 sep, Twelveinchy geplakt) staf/ringen goed, maar trinket-advies fout: Lost Idol (295, geen stats,
      alleen effect) → Keepsake 272 (+101 Str). Gerepareerd: export veld 14 `e` (Use:/Equip:/proc in de tooltip), en
      de site wisselt een effect-trinket nooit en stelt er geen voor; trinket zonder één stat = effect, ook in oude exports.
- [ ] ⏳ `/reload`, `/mh export` → Lost Idol eindigt op `||i251783:1|e` (en Effigy ook op `|e` als hij een effect heeft).
      Plakken → Trinket-regels *Keep* met *"Its effect can't be scored here…"*, geen wissel naar de Keepsake.
- [ ] ⏳ (plakken nog te doen) `/reload`, `/mh export` → de Ouroboric Signet-regels eindigen op `||i<getal>:1`; ringen/trinkets zonder
      Unique-Equipped eindigen gewoon op het 11e getal. Plakken → nooit twee dezelfde unieke ring/trinket.
      Staat er bij de Signet géén `i…:1`, dan leest MH de tooltip niet — zeg het.
- [x] ✅ (Rob, 29 sep) Regel 2 eindigt nu op `;primary=Strength` (Prot Paladin). Staat er `primary=?`, dan kon MH
      je hoofdstat niet lezen en telt hij nog alles op — screenshot.
- [x] ✅ (Rob, 29 sep: 19 i.p.v. 28; Bonedust Pestle, Snapdragon Pantaloons en Void-Reaper's Libram weg) Er staan **minder** `B|…`-regels dan de 28 van vanochtend: geen stof/leer/maliën-pantser meer, en geen
      items met alleen Agility of Intellect. Staat er een item bij dat je als paladin tóch niet kunt dragen: naam noemen.
- [x] ✅ (Rob, 29 sep, BM Hunter "Redisch") `primary=Agility`; de boog (Recurve Wisp-Shooter) staat als `E|mainhand`.
      Nog open: een boog/geweer in de TASSEN (`INVTYPE_RANGED*` → mainhand) en een int-alt (`primary=Intellect`).

## 🆕 27 sep — kaartvenster: je echte toets op elk icoon

`/reload`, `/mh play`.
- [x] ✅ (Rob, 27 sep: "de toetsen staan erop") **Your buttons**: rechtsboven op elk icoon staat de toets waar die spreuk nu op staat (`1`, `Z`, `S-2`…), gelijk
      aan wat je actiebalk toont.
- [ ] Een spreuk die niet op een toets staat: grijs `-`, en de tooltip zegt *"Not on a key on your action bars yet."*
- [x] ✅ (Rob, 27 sep) **Stay alive**: ook daar je echte toets op het icoon; de oude `[toets]` achter de naam is weg.
- [ ] Venster open laten, een spreuk naar een andere knop slepen: het label verandert mee.
- [ ] Een andere spec aanklikken bovenin: daar staan géén labels (die spreuken staan niet op je balken).
- [ ] Klopt een toets niet: `/mh playkeys` en stuur de regels.

## 🆕 27 sep — meting: wat ziet MH van je groep binnen een dungeon/raid?

Waarom: Cisca vond na doodgaan in een raid haar groep niet terug (meerdere verdiepingen).
- [x] ✅ (Rob, 27 sep, Nexus-Point Xenas) eerste meting: kaart per lid leesbaar, posities van niemand.
- [ ] Nog één keer in een raid/dungeon met **meerdere verdiepingen**, als iemand op een andere verdieping staat.
      Typ `/mh groupmap`, en daarna
      `/reload`. Ik lees de uitkomst uit het SavedVariables-bestand; een screenshot mag ook.
      Liefst op een moment dat een groepslid op een **andere verdieping** staat dan jij.

## 🆕 27 sep — waarschuwing bij versleten uitrusting

`/reload`.
- [ ] `/mh durability` → een regel met *warning on, limit 30%*, je laagste item met percentage, en per versleten slot
      een regel. Klopt het laagste percentage met wat je karakterscherm (tooltip van dat item) zegt?
- [x] ✅ (Rob, 27 sep: "tekst is groot en geluid werkt") `/mh durability test` → midden in beeld de grote tekst
      *"Your gear is at N% - repair before you pull!"* (eigen frame, 34 px, raid-warning-geluid), en in chat
      dezelfde regel met *Lowest:* en een item-link.
- [ ] Instellingen → Midnight Helper → *Dungeon help*: **Warn about worn gear** (aan) en de schuif **Warn below** (30%).
      Zet de schuif hoger dan je laagste item en start een ready check of ga een delve in: komt de waarschuwing?
- [ ] Onder de grens, en na het repareren: géén waarschuwing bij binnengaan.

## 🆕 26 sep — kaartvenster: tabblad Dispel

`/reload`, `/mh play`, tabblad **Dispel**.
- [x] ✅ (Rob, 26 sep, screenshot Prot Paladin) Passen de vier tabbladen naast elkaar (venster is iets breder geworden)?
- [x] ✅ (Rob, 26 sep: Cleanse Toxins, Poison + Disease) **Bij je groep**: klopt wat er staat met je spreuken?
- [ ] **Bij vijanden**: op een Shaman staat Purge, op een Mage Spellsteal, op een Hunter Tranquilizing Shot, op een
      Druid Soothe. Klopt dat, en staat bij een spec zonder zo'n spreuk *"This spec cannot take buffs off enemies"*?
- [x] ✅ (Rob, 26 sep: alle zes met naam, "you can" bij de 5 poison/disease, niet bij de boss-buff) **Waar het telt**:
      staan de dungeon- en baasnamen er echt (geen "?")? Staat "you can" bij de dingen die jij kunt?
- [ ] Muis op een spreuknaam: komt de uitleg?

## 🆕 26 sep — kaartvenster: tabblad Consumables

`/reload`, dan `/mh play` (of de gouden knop). Rob: *"het tabbladje voor onze consumables ... zonder in een lange lijst te
moeten zoeken"*.
- [x] ✅ (Rob, 26 sep: *"het werkt"*) Derde tabblad **Consumables**. Staan er flask, potions, wapenolie (niet bij elke spec), rune en food, elk met
      icoon en de naam in de kleur van het item?
- [ ] Achter elk item: **×aantal** als je het (of een alternatief) in je tassen hebt, anders *Not in your bags*. Klopt dat?
- [ ] Muis op een naam of icoon: komt de item-tooltip? Staan er eerst "..." in plaats van namen, verschijnen ze dan
      binnen een seconde?
- [ ] Wissel met de icoontjes bovenin naar een andere spec: wisselen de consumables mee?

## 🆕 25 sep — "Zo speel je" in een eigen venster, en kaarten voor álle specs

- [x] ✅ (Rob, 25 sep, screenshot Resto Druid: *"het grijs werkt, goed"*) **4.1.0: lage levels** — op je level 26 Druid `/reload`, `/mh play`. Bovenaan staat in lichtblauw *"Written for
      level 90. Grey: you don't have that spell yet."* Spreuken die je nog niet hebt zijn grijs (naam en icoon), die je
      wel hebt goud. Klopt dat met je spellbook? Zelfde op het tabblad Stay alive. (Op een andere spec via de icoontjes
      bovenin wordt niets grijs, alleen de regel "Written for level 90".)
- [x] ✅ (Rob, 25 sep: *"knop staat er en werkt"*) **4.1.0: de gouden knop** — `/reload`, open MH (`/mh`). Rechts in de zoekbalk, naast *My character*, staat een
      **gouden "How you play"-knop met het icoon van je spec**, die zacht oplicht. Klik: het kaartvenster opent en het
      oplichten stopt (ook na `/reload`). Past alles nog in de zoekbalk, ook met een smal MH-venster?
- [ ] 🆕 **4.1.0: Academy zonder schakelaar** — op een account/alt waar je nooit `/mh playcards` typte: staat de knop
      "How you play …" bovenaan de Academy?

⚠️ **WoW helemaal afsluiten en opnieuw starten** (er is een nieuw bestand; `/reload` laadt dat mogelijk niet).
Rob: *"ze zijn nu veel te verstopt en lastig te lezen"* → hij koos een eigen venster met iconen.
- [x] ✅ (Rob, 25 sep, screenshot op zijn **Elemental Shaman**) **Typ `/mh play`**. Komt er een los venster met bovenin
      3 spec-icoontjes (je eigen spec met een gouden rand), het idee, en de stappen **met een icoon ervoor**?
      (Tooltip bij het aanwijzen van een stap nog niet bevestigd.)
- [x] ✅ (Rob, 25 sep, screenshot Elemental: 7 knoppen met icoon) **Tabblad "Stay alive"** (Rob: *"ik mis eigenlijk de
      defense dingen"*): twee tabs, **Your buttons** en **Stay alive**; je verdedigingsknoppen in volgorde met icoon.
      (Of het tabblad onthouden wordt na sluiten en openen: nog niet bevestigd.)
- [x] ✅ (Rob, 25 sep: *"de tooltips werken"*) **Uitleg bij élke spreuknaam** (Rob, Shadow Priest: *"de andere spells geven geen tooltip, bv vampire
      touch"*): `/reload`, `/mh play`, en wijs met de muis naar een gouden naam midden in een zin (bv. Shadow Word:
      Pain, of een naam in "More enemies" of een hero-regel). Komt de uitleg van **die** spreuk? Het icoon vooraan
      toont de eerste spreuk van de stap. En sleept het venster nog, ook als je een stap-regel vastpakt?
- [x] ✅ (Rob, 25 sep: *"slepen werkt nu"*) **Verslepen** (Rob: *"ik kan alleen het scherm niet verslepen"*): `/reload`, dan het venster pakken aan de
      titel, de tabs of een lege plek, en slepen. Na `/reload` hoort het op dezelfde plek terug te komen.
      (Op een stap-regel zelf slepen gaat niet: die regels vangen de muis voor de tooltip.)
- [ ] **Klik op het Holy- of Retribution-icoon** bovenin: wisselt de kaart naar die spec? Nog een keer `/mh play`
      sluit het venster.
- [ ] **Leesbaarheid:** is het nu goed te lezen? Te groot, te klein, te breed? (Shift + muiswiel maakt het venster
      groter of kleiner.) Slepen aan de titel, Escape sluit.
- [ ] **Academy** (Tank, Heal én DPS): bovenaan staat nu één knop **"How you play …  >"**, en de lange kaarttekst
      is weg. Opent de knop het venster met die spec?
- [ ] **Andere klassen:** op elke alt `/mh play`. Staat er een kaart (niet "isn't written yet")? Klopt hij met hoe
      jij die spec speelt? Vooral: staan er **nergens rare namen of "spell 12345"**?

## 🆕 22 sep — Curse Surge: "nu" en "volgende" met de naam van de baas

`/reload`. Rob: *"ja doe dat vervolg maar"*. De koppeling plek → baas komt van HandyNotes; 2 van de 5 zijn door
jou gemeten (Leviathan, Vassti).
- [ ] **Typ `/mh surge`** (op of vlak bij de Coiled Isle). Je krijgt *"Curse Surge nu: <baas> — nog X min"* en
      *"Volgende Curse Surge: <baas> om HH:MM"*. **Klopt de baas met wat je op de kaart ziet?** Vooral de drie
      die we nog niet zelf zagen: Looming Mutagenitor, Ori'kassi, Ss'akrithos.
- [ ] **Events-scherm van MH:** de lopende surge heet nu *Curse Surge: <baas>* en is **klikbaar** (zet een route
      naar die plek). Bij *Coming up* staat de volgende, ook met naam.

## 🆕 22 sep — Events-scherm: een lopende surge heet niet meer "komt eraan"

`/reload`. Gevonden met Robs Leviathan-meting: een Curse Surge die al liep, stond bij *Coming up — in 21 min*;
die 21 minuten waren de tijd tot het **einde**.
- [ ] **Sta op Coiled Isle tijdens een surge** en open het Events-scherm van MH (of `/mh eventspy`). De surge hoort
      nu bij **NU bezig** te staan, met de resterende tijd; bij *Coming up* staat de **volgende** plek, met de
      tijd tot hij **begint**.
- [ ] **Controle met een ander event** (bv. *Abundance*): klopt "over X min" nu met wanneer hij echt begint?

## 🆕 21 sep — interrupt-kaart kent drie extra "kan ook een cast stoppen"-spreuken

`/reload`. Uit de JustAC-update van 20 sep, id's apart nagekeken.
- [x] ✅ (Rob, 24 sep) **Prot Warrior** (als je er een hebt): **Disrupting Shout** heeft nu een toets (**Ctrl+V**; had er
      eerst geen) en staat op de interrupt-kaart met het label **AoE interrupt**.
- [x] ✅ (Rob, 24 sep) **Demon Hunter, Vengeance of Havoc**: **Sigil of Misery** staat op de interrupt-kaart met **fear**.
- [x] ✅ (Rob, 24 sep) **Devourer Demon Hunter**: **Void Nova** heeft een toets en staat op de interrupt-kaart met **stun**.
      **Chaos Nova** hoort bij Devourer **niet** meer te staan (die spec heeft hem niet).

## 🆕 20 sep — markeerbalk: wissen gerepareerd + je ziet welke vlaggen al liggen

`/reload`, dan `/mh mark` (de balk komt alleen in een groep). Geleerd uit wMarker en EllesmereUIQoL.
- [x] ✅ **Rob, 20 sep, `/mh mark check`:** jouw client gebruikt `/tm` en `/cwm All`, en
      **`IsRaidMarkerActive` bestaat** — de gouden ring kan dus werken.
- [x] ✅ (Rob, 24 sep) **Nieuw: drie groepsknoppen** rechts op de onderste rij — ready check, **rollen-check** en een
      **aftelklok** (linksklik 10 seconden, rechtsklik stopt hem). Ze zijn **gedimd** als je geen leider of
      assistent bent, en de tooltip zegt dat dan ook. Klopt dat allebei?
- [x] ✅ (Rob, 24 sep) **Zet een paar wereldmarkers** (bovenste rij). Krijgen die knoppen een **gouden ring** zolang de
      vlag op de grond ligt? Wist je er één met rechtsklik, dan hoort de ring weg te gaan.
- [x] ✅ (Rob, 24 sep) **Zet iemand anders in de groep een marker**, dan hoort jouw ring ook mee te veranderen.
- [x] ✅ (Rob, 24 sep) **De rode X op de bovenste rij** (alles wissen): werkt die nu? Hij gebruikte `/cwm 9`, wat buiten
      een Engelse client sowieso niet werkte, en mogelijk helemaal niet meer.
- [x] ✅ (Rob, 24 sep) **Markeer een paar keer snel achter elkaar.** Krijg je nog "You can't do this right now"? De knop
      vuurde eerst twee keer per klik; dat is nu één keer.

## 🆕 19 sep — Z, X en C zijn nu altijd een defensive (of leeg)

`/reload`. Rob koos optie B: *"doe b maar"*. Op de kale Z, X en C komt alleen nog een defensive; dispels en CC
schuiven naar Shift/Ctrl. 107 verschuivingen in 27 specs; **Prot Paladin blijft gelijk**.
- [x] ✅ (Rob, 24 sep) **Ret of Holy Paladin**: in de toetsindeling van MH staat nu **Blessing of Protection op X** en
      **Cleanse Toxins op Shift+V** (was X). Klopt dat in het scherm met de toetsen?
- [x] ✅ (Rob, 24 sep) **Een alt van een andere klasse** (Shaman, Warlock, Rogue of Druid): staat er op X een defensive of niets,
      en géén Purge / Fear / Shiv / CC meer? Shaman hoort nu **Earth Elemental op Z** te hebben, Rogue **Evasion op X**.
- [x] ✅ (Rob, 24 sep) Gebruik je `/mh apply` om de indeling echt op je balken te zetten: doe dat pas na de reload, anders zet hij
      nog de oude.

## 🆕 19 sep — proef: "Zo speel je"-kaart (Ret, Prot, Arcane, Elemental)

`/reload`. Rob: *"Ik wil dat mh dat soort uitleg ook gaat geven … maar wel in eli10 formaat"*. Eerst vier
specs; pas als de vorm goed voelt volgen de andere en de vijf andere talen (nu Engels + Nederlands).
📌 **Sinds 25 sep staat de kaart niet meer in de Academy-tekst maar in een eigen venster** (zie de sectie van 25 sep
bovenaan); de open punten hieronder test je dus in dat venster.
⚠️ **Sinds 4.0.2 standaard verborgen.** Typ eerst **`/mh playcards`** (zet ze aan voor jouw account), dan de Academy
opnieuw openen. Zie je hem niet: **`/mh playcards check`** zegt of de Academy hem getekend heeft, en waarom niet.
- [x] ✅ (Rob, 24 sep, screenshot) **Op je Prot Paladin**: Academy → **Tank**-tab. Onder de tank-toolkit staat **How you play Protection**:
      het idee, 4 knoppen, "More enemies", "Biggest mistake", twee hero-regels (Templar / Lightsmith) en de bron.
      (Gezien t/m de Templar-regel; Lightsmith en bron vielen buiten de screenshot.)
- [ ] Academy → **DPS**-tab op dezelfde Paladin: onder "Stay alive" staat de kaart voor **Retribution** (voorbeeld).
- [ ] **Staan alle spellnamen er als naam** (goud), en nergens "spell 123456"? Let vooral op Judgment,
      Sacred Weapon (Lightsmith-regel). Beweeg over een stap: komt de tooltip van die spell?
- [x] ✅ (Rob, 24 sep: *"Ziet er goed uit"*) **Voelt het eli10?** Te lang, te kort, onduidelijke woorden? Dit is de vraag waar de rest op wacht.
- [ ] (Mage- of Shaman-alt) DPS-tab: **Arcane** en **Elemental** kaarten. Bij Arcane staat **Arcane Orb niet
      meer** in "Your damage cooldowns" (het is een rotatieknop, geen burst).

## 🆕 19 sep — werkt Bubble Cancel nog? (forummelding over /cancelaura)

Spelers melden sinds 17 sep dat `/cancelaura` bij sommige spells stil niets meer doet (Subterfuge, Shadow
Dance). Geen reactie van Blizzard. Of een buff weg te klikken is, beslist de server; dat kan ik niet meten.
MH levert acht van zulke macro's (`Modules/TeamMacrosData.lua`): Bubble Cancel (Paladin, 2×), Ice Block
Cancel (Mage, 3×), Turtle Cancel + Aimed Shot (Hunter), Hover Cancel (Evoker).
- [x] ✅ (Rob, 30 sep, Prot) Bubble Cancel stond **niet** bij Protection (alleen Holy + Ret) → toegevoegd aan Prot.
- [x] ✅ (Rob, 30 sep avond) Bubble Cancel werkt — maar pas nadat **Press and Hold Casting** uit stond. GEMETEN
      `ActionButtonUseKeyHeldSpell "1"` in config-cache.wtf: toets vasthouden draaide de macro twee keer, de tweede
      `/cancelaura` haalde de bubbel meteen weg (en Shimmer ging twee keer). Alle 8 cancel-macro's zeggen dat nu erbij.
- [ ] **Paladin**: Macros → Utility → **Bubble Cancel**, op een knop zetten. Klik: Divine Shield gaat aan.
      Klik nog een keer: **verdwijnt de bubbel?** Zo niet, dan is de macro stuk en haal ik hem eraf.
- [ ] (Als je een Mage of Hunter langsloopt) hetzelfde met **Ice Block Cancel** of **Turtle Cancel**.

## 🆕 19 sep — Coiled Altar: Guillotine vraagt nu 3 man, niet 5

`/reload`. Blizzard verlaagde op 1 sep het minimum voor Guillotine naar **3 spelers** op LFR, Normal en
Heroic. Onze tip zei nog 5. Bij Mythic staat nu "5"; dat is afgeleid, want de hotfix noemt Mythic niet.
- [x] ✅ (Rob, 24 sep) **Raids → The Venomous Abyss → The Coiled Altar**: de Guillotine-regel zegt *"at least 3 players (5 on Mythic)"*.
- [ ] **In het gevecht (Normal of Heroic)**: staan er 3 of meer in de Guillotine, dan krijgt de raid geen
      straf-schade. Klopt dat met wat je ziet?
