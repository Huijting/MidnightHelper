# Feiten, ronde 2: grote klap zien, heal-botsingen, woordenlijst (7 okt 2026)

Onderzoek bij `ROLE_SWITCH_REREAD_NEWCOMER_2026-10-07.md` (punt 2, 4 en 5 van de top-5).
Alleen gelezen en gemeten. Niets aan code of locale veranderd.

**Legenda**
- **GEMETEN** = gezien in een bron met naam en datum of build.
- **AFGELEID** = mijn eigen redenering. Niet gemeten.
- Niets hiervan is in de client getest. Robs `/reload` blijft de echte test.

**Bronnen (alle op 7 okt 2026 gelezen)**
- **wago.tools DB2 + GlobalStrings**, build **12.1.0.69933** (live). Eigen tab, Inertia-JSON-truc.
- **Blizzards UI-code**: GitHub `Gethe/wow-ui-source`, commit `09b9db79` = "12.1.0 (69933)", 22 sep 2026.
- **warcraft.wiki.gg** (via de wiki-API, datum = laatste bewerking):
  *Console variables/Complete list* (4 sep 2026; de pagina zegt zelf: bijgewerkt tot PTR 12.1.5 build 69594, 28 aug 2026),
  *Adventure Guide* (7 sep 2026), *Midnight Season 2* (24 sep 2026), *Raid Finder* (29 aug 2026),
  *Mythic+* (23 apr 2026), *Dungeon difficulty* (3 mrt 2025).
- **Icy Veins** Holy Paladin rotatie 12.1 en Resto Druid rotatie 12.1, beide "Last Updated: Aug 10, 2026".
- **Wowhead** *UI Hub for Midnight*, "Updated: 2026/08/10".
- **Blizzard** *Midnight Pre-Expansion Content Update Notes* (live 21 jan 2026). Ouder dan Season 2; alleen gebruikt
  waar de 12.1-code of -data hetzelfde zegt.
- **De repo zelf** (gelezen, niet veranderd): `Locales/enUS.lua`, `Locales/nlNL.lua`, `Modules/DungeonBossWindow.lua`,
  `Modules/HealerCooldowns.lua`, `Modules/CombatSafety.lua`, `Modules/EncounterJournalSidePanel.lua`.

---

## 1. Hoe zie je dat er een grote klap of een gevaarlijke spreuk aankomt?

### 1a. Blizzard heeft zelf boss-waarschuwingen. Naam: "Boss Warnings"

- **De officiële naam is "Boss Warnings".** Er zijn twee delen: **"Boss Abilities"** (een tijdlijn met aftellende icoontjes)
  en **"Text Warnings"** (tekst midden in beeld). — **GEMETEN** (GlobalStrings 12.1.0.69933):
  - `COMBAT_WARNINGS_LABEL` = "Boss Warnings"
  - `COMBAT_WARNINGS_ENABLE_LABEL` = "Enable Boss Warnings"
  - `COMBAT_WARNINGS_ENABLE_ENCOUNTER_TIMELINE_LABEL` = "Enable Boss Abilities"; tooltip: belangrijke boss-aanvallen in een
    apart HUD-element.
  - `COMBAT_WARNINGS_ENABLE_ENCOUNTER_WARNINGS_LABEL` = "Enable Text Warnings"; tooltip: waarschuwingen **in het midden van
    het scherm**.
  - In Edit Mode heet de tijdlijn `HUD_EDIT_MODE_SYSTEM_ENCOUNTER_TIMELINE` = "Boss Abilities". De tekstvakken heten
    "Boss Warning - Critical", "Boss Warning - Medium" en "Boss Warning - Minor".
  - 📌 "Boss Timeline" en "Encounter Timeline" zijn **geen** namen op het scherm. Gidsen gebruiken "Boss Timeline"
    (Blizzard zelf in de notes van jan 2026); in de client staat "Boss Abilities".
- **Waar: Esc → Options → Gameplay → Gameplay Enhancements → kopje "Boss Warnings".** — **GEMETEN**
  - UI-code 12.1.0: `Blizzard_SettingsDefinitions_Frame/AdvancedOptions.lua:101` maakt het kopje; de categorie heet
    `ADVANCED_OPTIONS_LABEL` = **"Gameplay Enhancements"** (`:7`) en hangt onder "Gameplay" (`:406`).
  - Wowhead UI Hub (10 aug 2026) geeft hetzelfde pad.
- **Staat standaard aan.** — **GEMETEN** in twee bronnen:
  - CVar-lijst (wiki, 12.1.5-PTR-data): `combatWarningsEnabled` = 1, `encounterTimelineEnabled` = 1,
    `encounterWarningsEnabled` = 1.
  - Blizzard, notes van jan 2026: "Boss Warnings are enabled by default".
  - Dat het op Robs of een speler-pc nog aan staat: **niet te weten**. Iemand kan het uitgezet hebben.
- **De tijdlijn verschijnt alleen tijdens een baasgevecht.** — **GEMETEN**: in de standaard-indeling
  (`Blizzard_EditMode/Mainline/EditModePresetLayouts.lua`) staat Visibility = "Active Encounter"
  (`HUD_EDIT_MODE_SETTING_ENCOUNTER_EVENTS_VISIBILITY_IN_ENCOUNTER`).
- **Standaard zie je icoontjes met een timer, maar géén spreuknaam.** — **GEMETEN** (zelfde bestand: ShowSpellName = 0,
  ShowTimer = 1, Orientation = Vertical). Muis erop = tooltip (TooltipAnchor = Cursor).
  - Naam erbij: Esc → Edit Mode → klik "Boss Abilities" → vinkje **"Show Spell Name"**. — **GEMETEN** dat de instelling
    bestaat (`HUD_EDIT_MODE_SETTING_ENCOUNTER_EVENTS_SHOW_SPELL_NAME`). Dat je in Edit Mode op het vak moet klikken: **AFGELEID**
    (zo werkt Edit Mode; Wowhead 10 aug 2026 beschrijft het zo).
- **Plek op het scherm:** links van het midden, in de onderste helft. — **AFGELEID** uit het anker
  (BOTTOMRIGHT aan BOTTOM, x −457, y 336). Niet in de client bekeken.
- **Handige extra's** (alle standaard **uit**, **GEMETEN** CVar-lijst): "Hide Countdowns for Other Roles"
  (`encounterTimelineHideForOtherRoles` = 0), "Hide Long Countdowns" (= 0), "Hide Queued Countdowns" (= 0).
  Tekst-niveau `encounterWarningsLevel` = 0. Dat 0 = "All Warnings" is: **AFGELEID** (de keuzelijst zet "Low/All Warnings"
  als eerste; de enum-waarde zelf niet gezien).
- **Waar het werkt:** Blizzard zegt "boss encounters in both dungeons and raids" (notes jan 2026). — **GEMETEN** in die bron.
  Follower dungeons en delves: **niet gemeten**. Er bestaat een melding "This feature is not currently available"
  (`COMBAT_WARNINGS_NOT_AVAILABLE`), dus het kan per plek ontbreken. — **AFGELEID**.

### 1b. De cast bar: een balk onder de vijand

- **Vijandelijke nameplates staan standaard aan, maar alleen in gevecht.** — **GEMETEN**:
  - CVar-lijst: `nameplateShowEnemies` = 1, `nameplateShowAll` = 0.
  - GlobalStrings: `OPTION_TOOLTIP_UNIT_NAMEPLATES_AUTOMODE` zegt dat nameplates standaard alleen in combat te zien zijn.
    Vinkje om ze altijd te tonen: **"Always Show Nameplates"** (Options → Gameplay → **Nameplates**).
  - Er is een toets "Show Enemy Nameplates" (`BINDING_NAME_NAMEPLATES`). Welke toets standaard: **niet gemeten**.
- **Je doelwit toont zijn cast bar onder zijn portret.** — **GEMETEN** dat het standaard aan staat: `showTargetCastbar` = 1
  ("Show the spell your current target is casting"), CVar-lijst.
- **Wat op de nameplate-cast-bar kan staan:** "Spell Name", "Spell Icon", "Spell Target", **"Highlight Important Casts"**,
  **"Highlight When Targeted By Enemy"** (Options → Gameplay → Nameplates → "Cast Bar Information"). — **GEMETEN**
  (GlobalStrings + `Nameplates.lua:644-648`).
  - Welke daarvan standaard aan staan: **niet gemeten** (de CVar `nameplateCastBarDisplay` staat niet in de wiki-lijst).
    Wowhead (2 sep 2025, alpha) schreef "Important Casts Highlighted By Default". Te oud om op te bouwen.
  - Volgens Wowhead (UI-gids, Midnight) is een belangrijke cast een felle gloed rond de balk, en een cast op jou een rode rand.
    — **GEMETEN** in die bron (geen datum op de gidspagina).
- ⚠️ **Geen gloed betekent niet "veilig".** MH mat op 11 aug 2026 dat `C_Spell.IsSpellImportant` maar 3 van 29 echte
  boss-spreuken als belangrijk ziet (memory `isspellimportant-is-narrow`). Dat Blizzards gloed op dezelfde vlag leunt:
  **AFGELEID** (niet in de code gezien).
- "De spreuk komt als de balk vol is": **AFGELEID** (zo werkt een cast bar; niet apart gemeten).

### 1c. Het Adventure Guide (Dungeon Journal)

- **Openen: Shift+J.** — **GEMETEN** (warcraft.wiki.gg *Adventure Guide*, 7 sep 2026: standaardtoets Shift+J, open vanaf level 11).
  De toets heet in de client "Toggle Adventure Guide" (`BINDING_NAME_TOGGLEENCOUNTERJOURNAL`); het venster heet
  "Adventure Guide" (`ADVENTURE_JOURNAL`). — **GEMETEN**.
- **Per baas vier tabs: "Overview", "Loot", "Abilities", "Model".** De aanvallen staan onder **"Abilities"**. — **GEMETEN**
  (`Blizzard_EncounterJournal.xml:1649-1735`, tooltips `OVERVIEW`, `LOOT_NOUN`, `ABILITIES`, `MODEL`). Dungeons en raids zijn
  tabs onderaan: "Dungeons", "Raids" (`:2331`, `:2336`).
- **De aanvallen hebben icoontjes met betekenis**, o.a. "Deadly", "Important", "Interruptible", "Tank Alert", "Healer Alert",
  "Damage Dealer Alert", "Magic Effect", "Poison Effect", "Enrage". — **GEMETEN** (`ENCOUNTER_JOURNAL_SECTION_FLAG0..12`).
  Dat ze als icoon naast de aanval staan: **AFGELEID** (de strings bestaan; de weergave niet in de client gezien).
- MH zet naast het Adventure Guide een eigen paneel met de MH-tips voor de gekozen baas. — **GEMETEN**
  (`Modules/EncounterJournalSidePanel.lua:3-8`; `CHANGELOG_290_1`).

### 1d. MH's eigen boss-venster (`/mh bosswin`)

**GEMETEN** in `Modules/DungeonBossWindow.lua`:
- Toont de stappen per baas van je huidige dungeon (kop `:2-4`). `/mh bosswin` opent/sluit hem overal; buiten een dungeon
  toont hij de dungeon-van-de-week (`:22-23`).
- Opent vanzelf als de baas gepulld wordt (ENCOUNTER_START, `:1908-1939`) en als je **buiten gevecht** een dungeon-baas
  als doel neemt (alleen 5-mans, `:2173-2182`).
- **Gaat dicht zodra het gevecht begint** (`:2155-2171`, "PRE-PULL-referentie"). Tijdens een baasgevecht komt er een klein
  knopje om hem terug te halen; bij trash niet (`:2132-2136`). Het knopje verdwijnt na zo'n 10 seconden (comment `:67-75`).
- Vanzelf openen kan uit: Settings → "Open automatically" (`SettingsPage.lua:91-92`).
- In een instance verbergt hij tips voor een zwaardere stand dan de jouwe, en zegt dat onderaan (`:1072-1077`).
- 📌 Dus: het venster is om **vóór** de pull te lezen, niet om tijdens het gevecht te waarschuwen. — **AFGELEID** uit de code.
- Extra: MH's **Combat Safety** toont een rood icoon met aftelling als een vijand een *belangrijke* spreuk op jou cast.
  Staat standaard aan (`CombatSafety.lua:43-49`: aan tenzij uitgezet). Leunt op `IsSpellImportant`, dus ziet maar een klein deel
  (zie 1b). — **GEMETEN** de code, **AFGELEID** de beperking.

### 1e. Voorstel: 4 korte, ware zinnen voor een beginner (Rob kiest)

**EN**
1. "In a boss fight the game warns you itself: icons count down on the Boss Abilities timeline, and big warnings appear in the
   middle of your screen. Both are on by default (Esc -> Options -> Gameplay -> Gameplay Enhancements -> Boss Warnings)."
2. "When an enemy casts a spell, a bar fills up under its health bar (and under its portrait if it is your target). When the bar is
   full, the spell lands: that is your moment to interrupt, step away or press a defensive."
3. "A glowing bar means an important cast. No glow does not mean it is safe."
4. "Before you pull, read the boss: Shift+J -> the boss -> Abilities, or /mh bosswin. The MH window closes when the fight starts,
   so read it first."

**NL**
1. "Bij een baas waarschuwt het spel zelf: op de tijdlijn Boss Abilities tellen icoontjes af, en grote waarschuwingen komen midden
   in beeld. Beide staan standaard aan (Esc -> Options -> Gameplay -> Gameplay Enhancements -> Boss Warnings)."
2. "Cast een vijand een spreuk, dan loopt er een balk vol onder zijn health-balk (en onder zijn portret als hij je doel is). Is de
   balk vol, dan komt de spreuk: dát is je moment om te interrupten, weg te stappen of je defensive te drukken."
3. "Gloeit de balk, dan is de cast belangrijk. Geen gloed betekent niet dat hij veilig is."
4. "Lees de baas vóór de pull: Shift+J -> de baas -> Abilities, of /mh bosswin. Het MH-venster gaat dicht als het gevecht begint,
   dus lees hem eerst."

Gemeten/afgeleid per zin: 1 = **GEMETEN** (naam, pad, standaard). 2 = **GEMETEN** dat balken standaard te zien zijn
(`nameplateShowEnemies`, `showTargetCastbar`); "vol = de spreuk komt" en "jouw moment" = **AFGELEID**. 3 = **GEMETEN** dat de
optie bestaat; de waarschuwing = **AFGELEID** uit de IsSpellImportant-meting. 4 = **GEMETEN**.
Tip voor de les (optioneel): "Zet in Edit Mode bij Boss Abilities 'Show Spell Name' aan, dan zie je ook de naam." — **GEMETEN**
dat het standaard uit staat.

---

## 2. Heal-botsingen in de repo

### 2a. "Grote heal na grote damage" tegenover de toolkit-tekst bij "big"

**De teksten** (**GEMETEN**):
- `ACADEMY_HEAL_TRIAGE_BODY` (enUS:2232, nlNL:2170): "Big heal after big damage; small heals between events."
- `HEALCORE_DESC_BIG` (enUS:4124, nlNL:3646): "Bigger, slower heal — use when you have a breather (easier on mana)."
- `HEALCORE_DESC_FAST` (enUS:4123): "your reactive button when someone dips".
- Het label "big" hangt op Holy Light, Enveloping Mist en Healing Wave (`HealerCooldowns.lua:161, 185, 202`).

**Wat de data zegt** (DB2 12.1.0.69933, **GEMETEN**):

| Spec | Snel | Groot / traag | Kosten snel → groot |
|---|---|---|---|
| Holy Paladin | Flash of Light, 1,5 s | Holy Light, 2,0 s ("A powerful but expensive spell") | **0,6% → 7%** |
| Resto Shaman | Healing Surge, 1,5 s | Healing Wave, 2,0 s ("An efficient wave") | 4,4% → 2,38% |
| Mistweaver | Vivify | Enveloping Mist, 2,0 s, een HoT | 3% → 3,6% |

- Dus "easier on mana" is **fout voor Holy Light**, **klopt voor Healing Wave**, en is voor Enveloping Mist niet waar per cast
  (heal per mana niet uitgerekend). — **GEMETEN** de kosten, **AFGELEID** het oordeel.
- ⚠️ Healing Surge heeft in de DB2 nog een kostenrij voor Resto Shaman, maar `HealerCooldowns.lua:97` zegt "Healing Surge is gone
  for Restoration". Of hij nog in het Resto-talentpakket zit, heb ik **niet** gecontroleerd. Vivify: cast-tijd niet opgezocht.
- Icy Veins Holy Paladin 12.1 (10 aug 2026): Holy Light heelt enorm maar kost heel veel mana; gebruik hem als er veel heal nodig
  is en je het kunt betalen, en soms ook als je het niet kunt betalen om iemand in leven te houden. — **GEMETEN** (samengevat).
- Icy Veins Resto Druid 12.1 (10 aug 2026): bij een plotselinge harde klap op één speler: Regrowth, liefst samen met
  Nature's Swiftness. — **GEMETEN** (samengevat).

**Antwoord: wat is juist als algemene beginnersregel?** — **AFGELEID** uit de metingen hierboven.
De twee teksten gaan over twee verschillende dingen: **tijd** (hoe snel landt de heal) en **mana** (wat kost hij).
Ze botsen omdat ze die door elkaar halen. Een regel die voor alle healers klopt:
1. **Bijna dood: eerst een heal die nú landt** (instant of je snelle heal). Een trage heal kan te laat zijn.
2. **Veel schade op één persoon, en er is tijd: je grote heal mag.**
3. **Rustig, kleine schade: je zuinige heal.** Welke dat is, verschilt per spec.

Voorstel-teksten (Rob kiest):
- Triage, laatste regel — EN: "Someone about to die: first a heal that lands now (instant or your fast heal). Lots of damage and
  time to cast: your big heal. Calm moments: your thrifty heal." NL: "Iemand bijna dood: eerst een heal die nú landt (instant of
  je snelle heal). Veel schade en tijd om te casten: je grote heal. Rustig: je zuinige heal."
- `HEALCORE_DESC_BIG` — EN: "Bigger, slower heal — heals a lot, but takes time to cast. Whether it saves mana depends on your
  spec." NL: "Grotere, tragere heal — heelt veel, maar kost tijd om te casten. Of hij zuinig is, verschilt per spec."
  (Dus "(easier on mana)" en "als je even lucht hebt" eruit; het eerste is fout bij Holy Light.)
- `HEALCORE_DESC_FAST` mag blijven. — **AFGELEID**.

### 2b. Resto Druid: S3 tegenover de grootste fout

**De teksten** (**GEMETEN**): `PLAYCARD_105_S3` (enUS:1314, nlNL:1264) "Zakt iemand diep weg: Regrowth. Druk eerst
Nature's Swiftness als die klaar is." `PLAYCARD_105_MISTAKE` (enUS:1317, nlNL:1267) "Regrowth casten zonder 5 Rejuvenation
uit. Dat kost veel mana en je raakt leeg."

**Wat de data zegt** (DB2 12.1.0.69933, **GEMETEN**):
- Regrowth (8936): 1,5 s cast, **2,52%** mana voor Resto (rij met aura 137012 = "Restoration Druid").
- Abundance (207383): met **minstens 5** Rejuvenations actief kost Regrowth **60% minder** en krijgt hij **60% meer** critkans
  (effect-spell 207640: −60 en +60).
- **Nature's Swiftness (132158): je volgende Regrowth is instant en gratis.** (Tooltip: "instant, free".)
- Icy Veins Resto Druid 12.1 (10 aug 2026): bij een harde klap Regrowth (met Nature's Swiftness); manaproblemen komen van
  Regrowth **zonder** Abundance. — **GEMETEN** (samengevat).

**Ze botsen niet.** S3 gaat over nood, de fout over gewoonte. — **AFGELEID**.
**Eén lijn die beide waar zegt** (voorstel, Rob kiest):
- EN: "Someone about to die: Regrowth is always allowed — Nature's Swiftness first makes it instant and free. Don't make Regrowth
  your everyday heal without 5 Rejuvenations out: then it costs a lot of mana. With 5 out, it is 60% cheaper."
- NL: "Iemand bijna dood: Regrowth mag altijd — met eerst Nature's Swiftness is hij direct én gratis. Maak Regrowth niet je
  gewone heal zonder 5 Rejuvenations uit: dan kost hij veel mana. Met 5 uit is hij 60% goedkoper."

### 2c. Holy Paladin: welke heal is zuinig, welke duur?

**Kosten voor Holy Paladin** (DB2 `SpellPower`, 12.1.0.69933, rij met aura 137029 = "Holy Paladin", **GEMETEN**):

| Spell | ID | Cast | Kost |
|---|---|---|---|
| Flash of Light | 19750 | 1,5 s | **0,6%** mana — **zuinig** |
| Holy Shock | 20473 | instant | 2% mana (geeft Holy Power) |
| Word of Glory | 85673 | instant | 3 Holy Power + 0,6% mana |
| Light of Dawn | 85222 | instant | 3 Holy Power + 0,6% mana |
| Divine Toll | 375576 | instant | 3% mana |
| **Holy Light** | 82326 | 2,0 s | **7%** mana — **duur** |

- Blizzards eigen tooltip: Holy Light = "A powerful but expensive spell", Flash of Light = "Quickly heal". — **GEMETEN**.
- Icy Veins (10 aug 2026): Holy Light kost erg veel; het 12.1-tiersetje (4pc) maakt hem nog duurder. — **GEMETEN** in die bron.
- "Instant" voor Holy Shock: `CastingTimeIndex 1` = 0 ms. — **GEMETEN**. Instant voor WoG/LoD/Divine Toll: **AFGELEID** (niet opgezocht).

**Klopt het mana-hoofdstuk nu?** Nee. `ACADEMY_HEAL_MANA_BODY` (enUS:2250, nlNL:2188) zegt "Je kaart zegt het voor jouw spec".
De Holy Paladin-kaart (`PLAYCARD_65_*`, enUS:1246-1254) zegt niets over zuinig of duur, en noemt Holy Light niet eens.
— **GEMETEN** (tekst). En de toolkit noemt Holy Light juist "easier on mana" (zie 2a): **fout**.

**Twee opties (Rob kiest):**
- **A. De kaart krijgt een mana-zin.** EN: "Mana: Flash of Light is cheap, Holy Light is expensive. Use Holy Light only when
  someone really needs a lot of healing." NL: "Mana: Flash of Light is goedkoop, Holy Light is duur. Holy Light alleen als
  iemand echt veel heal nodig heeft."
- **B. Het hoofdstuk verwijst naar de tooltip in plaats van de kaart.** Dat werkt voor Holy Paladin al: de tooltip zegt het
  letterlijk. (Dit stelde de eerste FACTS-ronde ook voor.) — **AFGELEID**.
- Let op: op een Prot Paladin opent de heal-track de Holy Paladin-kaart (re-read-rapport, `RoleAcademy.lua:872-873`).

### 2d. Divine Toll op een vijand, tegenover "vijand gekozen = heal op jezelf"

**Wat Divine Toll doet** (**GEMETEN**):
- DB2 12.1.0.69933, tooltip 375576: voor Holy cast hij **Holy Shock** (op verminderde kracht) op **tot 5 doelen** binnen
  30 meter. Effect 0 heeft basiswaarde 5.
- Holy Shock (20473) tooltip: **schade aan een vijand, of heal op een vriend**.
- Icy Veins Holy Paladin 12.1 (10 aug 2026): heb je een **vijand** als doel, dan gaan de 5 Holy Shocks eerst naar vijanden;
  zijn er te weinig vijanden, dan gaat de rest naar vrienden. Wil je healen, cast hem dan op een **vriend**.
- Wowhead Holy Paladin-gids (Midnight, geen datum): vriend of vijand "depending on your initial target".
- Divine Toll en Holy Prism zijn een keuze-knoop; Lightsmith heeft hem niet (Holy Armaments). Icy Veins 10 aug 2026. — **GEMETEN**.

**Waarom "vijand gekozen = heal op jezelf" hier niet geldt:**
- Blizzards eigen uitleg (`OPTION_TOOLTIP_AUTO_SELF_CAST`): Self Cast werkt voor **"friendly target spells"** als je een vijand of
  niemand als doel hebt. — **GEMETEN**.
- Holy Shock en Divine Toll zijn geen spreuken alleen-voor-vrienden: ze kunnen ook vijanden raken. Dus Self Cast springt niet in;
  ze gaan naar de vijand. — **AFGELEID** (DB2: effect 0 van Divine Toll heeft doeltype 25, "any"; de betekenis van dat getal
  komt uit server-emulators, niet uit Blizzard).
- **Zonder doel**: wat Divine Toll dan doet, **niet gemeten**. Alleen een Blizzard-forumpost uit dec 2022 (te oud).

**Dus de kaart klopt, en de algemene zin is te breed.** Voorstel voor `ACADEMY_HEAL_WHAT_BODY` (Rob kiest):
- EN: "Nobody picked, or an enemy picked? Then a normal heal lands on yourself. Spells that can also hurt enemies (like Holy
  Shock and Divine Toll) hit the enemy instead."
- NL: "Niemand gekozen, of een vijand? Dan komt een gewone heal op jezelf. Spreuken die ook vijanden kunnen raken (zoals Holy
  Shock en Divine Toll) gaan dan naar de vijand."
- Voor de kaart volstaat: "Wil je healen met Divine Toll: klik eerst een vriend aan." — **AFGELEID**.

---

## 3. Woorden voor de woordenlijst (`ACADEMY_WORDS_BODY`)

Huidige lijst: enUS:2208. Per woord één simpele, ware zin (Rob kiest).

| Woord | EN | NL | Status |
|---|---|---|---|
| **DPS** | "DPS: the players who do the damage (the role is called Damage in the Group Finder). It also means damage per second." | "DPS: de spelers die de schade doen (in de Group Finder heet die rol Damage). Het betekent ook: schade per seconde." | **GEMETEN**: `DAMAGER` = "Damage" (GlobalStrings); "Damage per Second (DPS)" in Wowhead UI Hub (10 aug 2026). |
| **Spec** | "Spec (specialization): the direction you pick inside your class, like Holy, Protection or Retribution for a Paladin. Switch for free: Talents & Spellbook -> Specialization." | "Spec (specialization): de richting binnen je klasse, zoals Holy, Protection of Retribution bij een Paladin. Gratis wisselen: Talents & Spellbook -> Specialization." | **GEMETEN**: `SPECIALIZATION` = "Specialization"; de drie Paladin-specs als spec-aura's in DB2 (137027/28/29); pad en "gratis" uit de eerste FACTS-ronde. |
| **HP** | "HP (health): your hit points. At 0 you die." | "HP (health): je levenspunten. Op 0 ga je dood." | **GEMETEN**: `HEALTH` = "Health". "HP" als afkorting: algemeen gebruik (Icy Veins schrijft "maximum HP"). Tip: kies één woord voor de hele Academy; nu staan health, HP en levenspunten door elkaar (re-read-rapport). |
| **Buff** | "Buff: a good effect on someone, like more stats or a heal that keeps ticking. Your own buffs show as icons at the top right. Buffing: giving your group buff before the fight." | "Buff: een goed effect op iemand, zoals extra stats of een heal die blijft tikken. Je eigen buffs staan als icoontjes rechtsboven. Buffen: je groepsbuff geven vóór het gevecht." | **GEMETEN**: buff-vak standaard rechtsboven (`EditModePresetLayouts.lua`, BuffFrame TOPRIGHT). Groepsbuff vóór elke baas: Icy Veins Resto Druid (10 aug 2026, Mark of the Wild). "Extra stats" als voorbeeld: **AFGELEID**. |
| **LFR** | "LFR (Raid Finder): the easiest way to raid. Sign up in the Group Finder -> Dungeons & Raids -> Raid Finder." | "LFR (Raid Finder): de makkelijkste stand van een raid. Aanmelden: Group Finder -> Dungeons & Raids -> Raid Finder." | **GEMETEN**: `PLAYER_DIFFICULTY3` = "Raid Finder", `RAID_FINDER_PVEFRAME` = "Raid Finder"; laagste raid-stand en plek in de Group Finder: wiki *Raid Finder* (29 aug 2026). Extra (optioneel): Season 2 vraagt gemiddeld item level **276** (wiki *Midnight Season 2*, 24 sep 2026). |
| **Normal / Heroic / Mythic** | "Normal, Heroic, Mythic: the difficulty of a dungeon or raid, from easy to hard." | "Normal, Heroic, Mythic: hoe zwaar een dungeon of raid is, van makkelijk naar zwaar." | **GEMETEN**: `PLAYER_DIFFICULTY1/2/6` = Normal/Heroic/Mythic; volgorde: wiki *Dungeon difficulty* (3 mrt 2025). Extra (optioneel): Heroic dungeons vragen in Season 2 item level **266** (wiki S2, 24 sep 2026). |
| **M+** | "M+ (Mythic+): a Mythic dungeon with a Keystone. You race a timer, and every + level makes the enemies stronger." | "M+ (Mythic+): een Mythic-dungeon met een Keystone. Je speelt tegen een timer, en elk +level maakt de vijanden sterker." | **GEMETEN**: `PLAYER_DIFFICULTY_MYTHIC_PLUS` = "Mythic+"; Keystone, timer en oplopende moeilijkheid: wiki *Mythic+* (23 apr 2026); "complete a dungeon within the time limit": wiki *Midnight Season 2* (24 sep 2026). |

---

## Wat ik niet vond of niet kon meten

- **Niets in de client getest.** Paden en standaarden komen uit Blizzards UI-code en de CVar-lijst, niet uit een screenshot.
- De CVar-standaarden komen uit de wiki-lijst met **12.1.5-PTR-data** (28 aug 2026), niet uit live 12.1.0. Dat ze op live
  hetzelfde zijn: **AFGELEID** (de 12.1.0-UI-code heeft dezelfde instellingen).
- Welke **Cast Bar Information**-vinkjes standaard aan staan (`nameplateCastBarDisplay`): niet gevonden.
- Of **Boss Warnings** ook in follower dungeons en delves werken: niet gemeten.
- Of de nameplate-gloed ("Highlight Important Casts") dezelfde vlag gebruikt als `IsSpellImportant`: niet gezien.
- Wat **Divine Toll zonder doel** doet: niet gemeten.
- De standaardtoets voor **"Show Enemy Nameplates"**: niet gemeten (standaardtoetsen staan niet in de UI-code).
- Heal per mana voor **Enveloping Mist**: niet uitgerekend.
- De nlNL-regelnummers in het re-read-rapport zijn verschoven (bv. triage stond op 2157, nu 2170). — **GEMETEN**.
- Twee bronnen die ik zag maar **niet** gebruik: de wiki-pagina *Midnight Season 2* noemt voor normal dungeons zowel ilvl 253
  als 259 (tegenstrijdig in één pagina); de wiki-infobox van Divine Toll noemt 15% mana, de DB2 zegt 3%. De DB2 wint.
