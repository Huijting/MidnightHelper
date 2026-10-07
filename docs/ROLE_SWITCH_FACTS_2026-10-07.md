# Feiten voor de lessen "Wat is een tank / wat is een healer" (7 okt 2026)

Onderzoek voor de nieuwe beginnerslessen. Alleen gelezen en gemeten; niets aan code of locale veranderd.

**Legenda**
- **GEMETEN** = gezien in een bron met naam en datum of build.
- **AFGELEID** = mijn eigen redenering of rekensom. Niet gemeten.
- Niets hiervan is in de client getest. Rob's `/reload` blijft de echte test.

**Bronnen die ik gebruikte (alle op 7 okt 2026 gelezen)**
- **wago.tools DB2**, build **12.1.0.69933** (live). Waar dat ertoe doet ook **12.1.5.70077**. Via het browservenster, eigen tab.
- **Blizzards eigen UI-code**: GitHub `Gethe/wow-ui-source`, tak `live`, commit "12.1.0 (69933)" van 22 sep 2026.
  Dat is dezelfde build als de DB2. Hieruit komen de menupaden.
- **Icy Veins Tanking Guide**, "Last Updated: Sep 21, 2026".
- **Icy Veins Resto Druid rotatie 12.1**, "Last Updated: Aug 10, 2026".
- **warcraft.wiki.gg**. De datum van de laatste bewerking heb ik via de wiki-API gemeten:
  Midnight Season 2 (24 sep 2026), Celestial Brew (26 aug 2026), Final Stand (11 aug 2026),
  Divine Shield (20 apr 2026), Follower Dungeons (27 mrt 2026), Taunt (21 jun 2025).
- **Wowhead**, spell 355, spell 1241059, quest 93850 en 86543. Via Exa; de pagina toont geen datum.
- Kleinere bronnen staan bij het punt zelf, met datum.

📌 **Eerlijk:** mijn eerste grep (op `1241059|322507|Celestial`) had een glob die `docs/` níét uitsloot. Ik zag daardoor
een paar regels uit `docs/audit_2026-09-17/`, `docs/id_round_2026-10-05/`, `docs/NEXT_SESSION.md` en `docs/TESTLIJST.md`.
Ik heb die **niet** als bron gebruikt. Alles hieronder komt uit de bronnen hierboven.

---

## 1. Healers kiezen hun doel

### Click Casting: waar staat het?
- **Pad: Esc → `Options` → `Gameplay` → `Keybindings` → knop `Click Casting`.** — **GEMETEN**
  - UI-code 12.1.0: `KeybindingsOverrides.lua:43` maakt een knop met tekst `CLICK_BIND_MODE`. Die knop sluit het
    Options-venster en opent het Click Casting-venster (`:38-39`). De categorie `Keybindings` hangt onder `Gameplay`
    (`Keybindings.lua:247` en `:294`).
  - Letterlijke namen (GlobalStrings, 12.1.0.69933): `GAMEMENU_OPTIONS` = "Options", `SETTING_GROUP_GAMEPLAY` = "Gameplay",
    `SETTINGS_KEYBINDINGS_LABEL` = "Keybindings", `CLICK_BIND_MODE` = "Click Casting".
  - Het venster zelf heet `CLICK_CAST_BINDINGS` = "Click Cast Bindings". De knoppen erin heten "Add Binding" en "Save".
- **De knop is te vinden met het zoekvak van Options** (bijvoorbeeld "Click"). — **GEMETEN** in de code (`addSearchTags = true`,
  `:42`). Dat het zoekvak hem echt toont: **AFGELEID**.
- **Er is geen aan/uit-schakelaar voor Click Casting.** Het werkt zodra je een spreuk aan een muisknop koppelt en op Save drukt.
  - **GEMETEN:** het venster heeft maar één vinkje, en dat is "Mouseover Cast" (`Blizzard_ClickBindingUI.xml:193-213`).
    Een zoekactie naar `CVar|Enable|Checkbox` in dat bestand vond alleen dat vinkje. Positieve controle: hetzelfde patroon vond wél
    `enableMouseoverCast` (`.lua:789-850`).
  - **AFGELEID:** "aanzetten" = één binding toevoegen.
- **Standaard doet links klikken "Target Unit Frame" en rechts klikken "Open Context Menu".**
  - **GEMETEN:** die twee "(Default)"-regels staan in de code (`Blizzard_ClickBindingUI.lua:124-137`), met de teksten
    `CLICK_BINDING_TARGET_UNIT` = "Target Unit Frame" en `CLICK_BINDING_OPEN_MENU` = "Open Context Menu".
  - Dat **links** = target en **rechts** = menu: **GEMETEN** in een Blizzard-forumpost van 13 jun 2025. Niet in de code gezien.
  - **Gevolg (AFGELEID):** zet je een heal op links klikken, dan moet je "Target Unit Frame" naar bijvoorbeeld Alt+links verplaatsen.
- Niet elke spreuk mag op een muisknop. — **GEMETEN** dat de melding bestaat: `CLICK_BINDING_NOT_AVAILABLE` =
  "Not available for Click Cast Binding". Welke spreuken: niet gezocht.

### Raid-style party frames: waar staat het?
- **Pad: Esc → `Edit Mode` → klik op de party frames → vinkje `Use Raid-Style Party Frames`.** — **GEMETEN**
  - De knop "Edit Mode" staat in het Esc-menu (`GameMenuFrame.lua:184-185`, `HUD_EDIT_MODE_MENU` = "Edit Mode").
  - Het vinkje is een Edit Mode-instelling van de unit frames (`EditModeSettingDisplayInfo.lua:222-227`),
    tekst `HUD_EDIT_MODE_SETTING_UNIT_FRAME_RAID_STYLE_PARTY_FRAMES` = "Use Raid-Style Party Frames".
  - Het vak voor de party frames heet in Edit Mode "Party Frames" (`HUD_EDIT_MODE_PARTY_FRAMES_LABEL`).
  - Een tweede ingang: rechtsklik op je eigen portret heeft ook "Edit Mode" (`UnitPopupMenus.lua:21`). — **GEMETEN**
  - Dat je op het vak moet klikken om het vinkje te zien: **AFGELEID** (zo werkt Edit Mode; niet in de client bekeken).
- Ik vond dit vinkje **niet** in Options zelf. Een zoekactie naar `RAID_STYLE` in alle Options-bestanden vond niets; in Edit Mode wel.
  — **GEMETEN** (positieve controle: dezelfde zoektocht vond wel `raidFramesDisplay…` in `InterfaceOverrides.lua`).
- De opties van de raid frames zelf (bv. "Display Aggro Highlight") staan in **`Options` → `Gameplay` → `Interface`**,
  onder het kopje **`Raid Frames`**. — **GEMETEN** (`Interface.lua:11, 144, 162`; `InterfaceOverrides.lua:33-34`). Dat klopt
  met wat de kaart al zegt (`nlNL.lua:1111`, volgens het newcomer-rapport).

### Werkt "klik op het frame, druk de heal" nog? En heal je jezelf als niemand gekozen is?
- **Ja.** — **GEMETEN** voor de instelling, **AFGELEID** voor het gedrag op het scherm.
  - Links klikken op een frame kiest die speler als doel (de standaard-binding hierboven). Een heal gaat naar je doel.
  - **Self Cast staat standaard op "Auto and Key Press".** In `Combat.lua:115` is de standaardwaarde `4` =
    `SELF_CAST_AUTO_AND_KEY_PRESS` = "Auto and Key Press". De instelling heet "Self Cast" en staat in
    **`Options` → `Gameplay` → `Combat`** (`COMBAT_LABEL`).
  - Uitleg van Blizzard zelf (`OPTIONS_TOOLTIP_SELF_CAST_AUTO`): je heal gaat naar jezelf als je **geen vriendelijk doel** hebt.
    Dus ook als je een **vijand** als doel hebt (`OPTION_TOOLTIP_AUTO_SELF_CAST`: "non friendly target or no target").
  - Met "Key Press" erbij heal je jezelf ook door een toets ingedrukt te houden. Standaard is dat **Alt** (`Combat.lua:127`).
- **Mouseover Cast** is een andere manier: muis op een frame, toets drukken, en de heal gaat naar die speler zonder dat je hem kiest.
  Hij staat in `Options` → `Gameplay` → `Combat` en in het Click Casting-venster. — **GEMETEN** (`Combat.lua:46-63`,
  tooltip `OPTION_TOOLTIP_ENABLE_MOUSEOVER_CAST`). **Of hij standaard aan of uit staat: niet gevonden.**
- 📌 Voor de les: de checklist zegt "hover-heal" en de kaart zegt "klik". Beide bestaan. Klikken werkt zonder iets in te stellen;
  hover is Mouseover Cast of Click Casting en moet je eerst instellen. — **AFGELEID**

---

## 2. Follower dungeons in Midnight Season 2

### Welke dungeons?
**GEMETEN** (DB2 `LFGDungeons`, `DifficultyID = 205`, build 12.1.0.69933): er zijn **9 Midnight follower dungeons**
(`ExpansionLevel 11`):

| LFG-ID | Dungeon |
|---|---|
| 2745 | Windrunner Spire |
| 3055 | Den of Nalorakk |
| 3059 | Nexus-Point Xenas |
| 3067 | Magisters' Terrace |
| 3075 | The Blinding Vale |
| 3089 | Murder Row |
| 3101 | Maisara Caverns |
| 3110 | Voidscar Arena |
| 3190 | Altar of Fangs |

- Dat klopt met warcraft.wiki.gg *Midnight Season 2* (bewerkt 24 sep 2026): alle negen Midnight-dungeons bestaan in normal
  en als follower dungeon. — **GEMETEN**
- Icy Veins *Follower Dungeons Guide* (zonder datum) noemt er acht. Altar of Fangs ontbreekt daar; die kwam in 12.1. — **GEMETEN**,
  maar die pagina loopt dus achter.
- Er zitten ook nog follower-versies van Dragonflight- en TWW-dungeons in de DB2 (18 stuks). Die zijn voor lagere levels. — **GEMETEN**

### Op welk level? Ook op 90?
- **Level 80 tot en met 90. Dus ook op 90.** — **GEMETEN**
  - Elke Midnight follower dungeon heeft een ContentTuning van **80-90** (bv. 5102, 5130, 6668).
  - De toegangsvoorwaarde (`PlayerCondition`) van elk van de negen eist óók een ContentTuning van **80-90**.
  - Icy Veins (zonder datum) zegt hetzelfde: Midnight 80-90; boven je bracket kun je niet meer queuen.
- **Maar er is per dungeon nog een extra voorwaarde.** — **GEMETEN** dat hij bestaat, **niet** helemaal ontcijferd.
  - Acht van de negen hebben een `WorldStateExpression` plus een `ModifierTree` met "minstens één van twee" voorwaarden.
  - Bij Windrunner Spire is één van die twee quest 93850 (*Windrunner Spire: Haunting Melodies*); bij Magisters' Terrace
    quest 86543 (*Magisters' Terrace: Homecoming*). Namen **GEMETEN** op Wowhead. Wat de tweede voorwaarde is, kon ik niet ontcijferen.
  - Altar of Fangs heeft alleen een WorldStateExpression, geen ModifierTree.
  - Een andere site (rpgstash.com, zonder datum) noemt per dungeon een level vanaf wanneer normal opengaat
    (Windrunner 81, Murder Row 83, Maisara 85, Blinding Vale en Den 88, de rest 90). **Niet zelf nagemeten.**
  - **AFGELEID:** op level 90 met de campagne gedaan zouden alle negen open moeten staan. **In de client op 90 niet gecontroleerd.**
- Daarmee is de tegenspraak uit het expert-rapport (F6) opgelost: "tijdens het levelen 80-90" en "altijd" kloppen allebei,
  want 90 is het maximum en valt binnen 80-90. — **AFGELEID** uit de DB2-meting.
- Maximaal **50 follower dungeons per dag per account** (warcraft.wiki.gg *Follower Dungeons*, bewerkt 27 mrt 2026). — **GEMETEN**.
  De foutmelding bestaat in 12.1.0: `ERR_FOLLOWER_DUNGEON_LIMIT_REACHED` = "You've entered too many follower dungeons recently."
- Buit: normal en follower dungeons geven in Season 2 item level **253** (warcraft.wiki.gg *Midnight Season 2*, 24 sep 2026). — **GEMETEN**

### Hoe meld je je aan? (letterlijke namen)
**GEMETEN** in de UI-code 12.1.0 en GlobalStrings 12.1.0.69933:
1. Open de **Group Finder**. De knop in het micromenu heet `DUNGEONS_BUTTON` = "Group Finder". Het venster en de eerste tab
   heten `GROUP_FINDER` = "**Dungeons & Raids**" (`PVEFrame.lua:362`, `PVEFrame.xml:165`).
   Sneltoets **I**: volgens Icy Veins (zonder datum). Niet in de code gezien.
2. Links: **"Dungeon Finder"** (`LOOKING_FOR_DUNGEON_PVEFRAME`, `PVEFrame.lua:189`).
3. In de keuzelijst bovenaan: **"Follower Dungeons"** (`LFG_TYPE_FOLLOWER_DUNGEON`, `LFDFrame.lua:394`). Uitleg eronder:
   "Complete dungeons with NPC teammates" (`LFD_FOLLOWER_EXPLANATION`).
4. Kies de dungeon(s) in de lijst en je rol, en druk op **"Find Group"** (`FIND_A_GROUP`, `LFDFrame.xml:319`).
- Kun je geen enkele follower dungeon doen, dan is de keuze grijs met de tooltip "You may not queue for this."
  (`LFDFrame.lua:407-413`). — **GEMETEN**
- Je rol kiezen en NPC's vullen de rest aan: Icy Veins (zonder datum). — **GEMETEN** in die bron; in de code alleen dat er een rolkeuze is.
- Het kan ook bij een NPC bij de ingang van de dungeon (warcraft.wiki.gg *Follower Dungeons*; Wowhead-reacties bij quest 86543).
  — **GEMETEN** in die bronnen.

---

## 3. Celestial Infusion (Brewmaster)

- **1241059 = Celestial Infusion. Ja, dat is het juiste ID.** — **GEMETEN** (DB2 `SpellName`, 12.1.0.69933 en 12.1.5.70077)
  - Er bestaat nog een spell met dezelfde naam: **367907**. Die zit in geen enkel talent (geen `TraitDefinition`). — **GEMETEN**
  - **AFGELEID:** 367907 is een oud of intern ID. Niet gebruiken.
- **Het is een keuze-talent tegenover Celestial Brew (322507).** — **GEMETEN** (DB2, beide builds)
  - Talentknoop **101067** in talentboom **1000** is van `Type 2` (een keuzeknoop) en bevat precies twee keuzes:
    Celestial Brew (322507, positie 100) en Celestial Infusion (1241059, positie 200).
  - Boom 1000 is een Monk-boom (loadouts voor 268, 269 en 270). — **GEMETEN**. Dat het de huidige boom is: **AFGELEID**.
  - warcraft.wiki.gg *Celestial Brew* (bewerkt 26 aug 2026) zegt het ook: een "exclusive choice node" met Celestial Infusion,
    sinds patch 11.2.0. — **GEMETEN**
- Wat ze doen (DB2 12.1.0.69933, **GEMETEN**):

| | Celestial Brew 322507 | Celestial Infusion 1241059 |
|---|---|---|
| Wat | schild dat een vaste hoeveelheid schade opvangt | vangt **30%** van alle inkomende schade op, tot een maximum |
| Duur | 8 sec (SpellDuration 31) | 16 sec (SpellDuration 387) |
| Lading | delen dezelfde lading: categorie 2293 "Monk - Celestial Brew", 1 lading, **90 sec** herlaadtijd | (dezelfde) |

  - De 30% staat in de Wowhead-tooltip van 1241059. — **GEMETEN** (pagina zonder datum).
- **Wat de repo nu heeft** (**GEMETEN**): `TankToolkit.lua:90` kent alleen 322507. `KeybindRoles_Monk.lua:108` heeft
  Celestial Infusion 1241059 met `specs = {}` (alleen voor de kaart). De kaart noemt beide (`enUS.lua:1478`).
  **AFGELEID:** een Infusion-speler mist hem in de toolkit en in de pull summary (zoals het expert-rapport F5 al zei); het ID is nu bevestigd.

---

## 4. Taunt

### Wat doet een taunt?
**GEMETEN** (DB2 12.1.0.69933), voor alle zes de taunts hetzelfde:
- **Het doel moet jou aanvallen.** Effect 114 = "attack me". De tooltip: *"Taunts the target to attack you…"*.
- **Je maakt 6 seconden lang veel meer threat op dat doel.** Effect met waarde 800, duur 6 sec (SpellDuration 32).
  Wowhead rendert dat bij Taunt (355) als "by 800% for 6 sec". — **GEMETEN**
- **Herlaadtijd 8 seconden.** Taunt, Dark Command en Growl delen categorie 82 "Taunt/Detaunt" met 8 sec. Hand of Reckoning en
  Torment hebben een eigen lading van 8 sec. Provoke heeft 8 sec. — **GEMETEN**
- **Eén doel.** Alle zes zeggen "the target". — **GEMETEN** (tekst). Uitzonderingen: Challenging Shout (1161, Prot Warrior-talent)
  taunt alles binnen een straal, 2 min herlaadtijd; Provoke op je Black Ox Statue raakt alles rond het beeld. — **GEMETEN** (tekst).
- **Threat:** Icy Veins (21 sep 2026) zegt dat een taunt je **evenveel threat geeft als wie het doel had**, plus de extra threat voor
  6 sec. En: val je daarna niet aan, dan gaat het doel na de 6 sec terug naar de vorige. — **GEMETEN** in die bron.
  In de DB2 zie ik alleen de "attack me" en de 800%; het gelijktrekken van threat zit niet zichtbaar in de data (waarschijnlijk
  serverkant). — **AFGELEID**
- Een taunt werkt **niet op spelers**. — **GEMETEN** (warcraft.wiki.gg *Taunt*, bewerkt 21 jun 2025)

### De taunt per tankspec (vergeleken met de repo)
Alle zes ID's in de repo kloppen met de DB2-naam. — **GEMETEN** (DB2 12.1.0.69933 + repo)

| Spec | Taunt | ID | DB2-naam | Repo |
|---|---|---|---|---|
| Protection Warrior (73) | Taunt | 355 | Taunt | `KeybindRoles_Warrior.lua:144` |
| Blood Death Knight (250) | Dark Command | 56222 | Dark Command | `KeybindRoles_DeathKnight.lua:79` |
| Vengeance Demon Hunter (581) | Torment | 185245 | Torment | `KeybindRoles_DemonHunter.lua:85` |
| Brewmaster Monk (268) | Provoke | 115546 (taunt-effect via 116189) | Provoke | `KeybindRoles_Monk.lua:114` |
| Guardian Druid (104) | Growl | 6795 | Growl | `KeybindRoles_Druid.lua:188` |
| Protection Paladin (66) | Hand of Reckoning | 62124 | Hand of Reckoning | `KeybindRoles_Paladin.lua:167` |

- Growl werkt alleen in Bear Form; voor Blood is Death Grip ook een taunt. — **GEMETEN** (warcraft.wiki.gg *Taunt*, 21 jun 2025)
- Taunt, Dark Command, Growl en Provoke zitten **niet** op de global cooldown (`StartRecoveryTime 0`). Voor Torment en Hand of
  Reckoning staat geen rij in `SpellCooldowns`; dat kon ik dus niet zien. — **GEMETEN**

### Wanneer taunt je NIET?
- **Om een hele groep vijanden te pakken.** Een taunt pakt één vijand. Voor een pack heb je je AoE nodig.
  — **AFGELEID** uit "the target" (**GEMETEN**). Dat past bij het expert-rapport F11.
- 📌 **"Nooit een gevecht met taunt beginnen" is te streng.** Icy Veins (21 sep 2026) zegt juist: heb je moeite met threat aan het
  begin, dan mag je met je taunt openen. — **GEMETEN**. Het expert-rapport noemt "taunt om een gevecht te beginnen" een valkuil;
  dat klopt alleen voor een **pack**, niet voor één doel. — **AFGELEID**
- **Niet van de andere tank afpakken als dat niet de bedoeling is.** Icy Veins (21 sep 2026): weet waarom en wanneer je taunt;
  bij een geplande wissel ga je eerst op dezelfde plek staan als de andere tank, zodat de baas niet draait. Ben jij weggetaunt,
  doe dan een paar seconden rustig met je threat. — **GEMETEN** in die bron.
  - **AFGELEID:** in een 5-mans dungeon is er maar één tank, dus dit speelt vooral in raids.
- **Niet taunten en dan niets doen.** Het doel gaat na 6 sec terug (Icy Veins, 21 sep 2026). — **GEMETEN**
- **Wél taunten:** zodra een vijand iemand anders slaat. Icy Veins zegt ook: taunten is geen schande; een goede tank gebruikt hem veel.
  — **GEMETEN**. Dat is precies kaart-stap S5 van Prot Paladin.

---

## 5. Defensives voor tanks: vooraf drukken of bewaren?

- **Icy Veins Tanking Guide (21 sep 2026)**, kort samengevat — **GEMETEN**:
  - Voorkomen is beter dan genezen. Moet je niet sparen voor één bepaald moment in het gevecht, gebruik ze dan vaak.
  - Knoppen die **schade verlagen**: altijd **vóóraf**, als je weet dat er een zware klap of zware periode aankomt.
    Op 5% leven is het te laat.
  - Knoppen die je **leven geven of healen** mogen vooraf én achteraf; bewaar ze liefst voor een plotselinge diepe dip.
  - **Niet stapelen.** Als je alles tegelijk nodig hebt, was het waarschijnlijk niet de bedoeling dat je dat overleeft.
  - Vraag de healer om hulp-cooldowns als het zelf niet lukt.
- BoostRoom (27 jan 2026, vóór Season 2): op een grote pull één defensive aan het begin, een tweede als de healer het druk heeft,
  en **houd er één achter de hand** voor als het misgaat. — **GEMETEN**
- **Eén regel die voor alle zes de tankspecs klopt** — **AFGELEID** uit de twee bronnen:
  > Druk een knop die schade verlaagt **vóór** de grote klap of aan het begin van een grote pull, niet pas als je laag staat.
  > Gebruik ze vaak en **één tegelijk**. Houd er één achter de hand voor als het misgaat.
- Wat dit betekent voor MH (**GEMETEN** de teksten, **AFGELEID** het oordeel):
  - `TANKKIT_CDS_HEAD` = "Your personal defensives (save these)" (`enUS.lua:4061`) botst met Icy Veins.
  - `ACADEMY_TANK_PULL_BODY` "Use one defensive if damage spikes - save the second for "oh no"" (`enUS.lua:2205`) klopt
    half: "één achter de hand" past, maar "if damage spikes" is net te laat; het moet "vóór".

---

## 6. Mana voor healers: is de snelle of de trage heal zuiniger?

### Het korte antwoord
**Het hangt af van de klasse. Er is geen regel die voor alle healers klopt.** — **GEMETEN** (tooltips en kosten) + **AFGELEID** (rekensom)

Blizzard zegt het zelf in de tooltips (DB2 `Spell`, 12.1.0.69933, **GEMETEN**):

| Klasse | Snelle heal (1,5 sec) | Trage heal | Blizzard noemt de trage | Kosten snel → traag (Resto/Holy-spec) |
|---|---|---|---|---|
| Holy Priest | Flash Heal ("A fast spell") | Heal, 2,5 sec | "**An efficient spell**" | 2,61% → 2,28% |
| Resto Shaman | Healing Surge ("A quick surge") | Healing Wave, 2,0 sec | "**An efficient wave**" | 4,40% → 2,38% |
| Holy Paladin | Flash of Light ("Quickly heal") | Holy Light, 2,0 sec | "**A powerful but expensive spell**" | 0,60% → 7,00% |

(Kosten = `PowerCostPct` in `SpellPower`, de rij voor die healspec. Cast-tijden uit `SpellCastTimes`.)

- **Rekensom (AFGELEID):** heal-coëfficiënt × spec-aura gedeeld door de kosten, **zonder** talenten, mastery en crit:
  - Priest: Heal geeft ongeveer 10-25% meer heal per mana dan Flash Heal.
  - Shaman: Healing Wave geeft ongeveer 2,5 keer zoveel heal per mana als Healing Surge.
  - Holy Paladin: andersom. Flash of Light geeft ongeveer 1,6 keer zoveel heal per mana als Holy Light.
- **Mistweaver en Evoker:** niet uitgerekend. De formules zitten in variabelen die ik niet kon uitlezen. **Niet gevonden.**

### Resto Druid: is Regrowth duur?
**Ja, zónder het talent Abundance. Mét Abundance is hij goedkoop.** — **GEMETEN**

| Spell (Resto Druid) | ID | Kosten | Wat |
|---|---|---|---|
| Lifebloom | 33763 | 1,28% | HoT, 15 sec |
| Swiftmend | 18562 | 1,40% | directe heal, met herlaadtijd |
| Rejuvenation | 774 | 1,89% | HoT, 12 sec, instant |
| **Regrowth** | 8936 | **2,52%** | directe heal + korte HoT, 1,5 sec cast |
| Wild Growth | 48438 | 4,37% | groeps-HoT, 1,5 sec cast |

- **Abundance** (talent 207383, in de Druid-boom): met **minstens 5 Rejuvenations** actief kost Regrowth **60% minder** en heeft
  hij **60% meer** kans op een crit (effect-spell 207640: −60 en +60). Dan kost Regrowth ongeveer **1,0%**. — **GEMETEN**
  - Method (12.1, zonder datum) zegt ook 60%. Maxroll (12.1, zonder datum) zegt 50%; de DB2 zegt 60%. **De DB2 wint.**
- Icy Veins Resto Druid 12.1 (10 aug 2026), samengevat — **GEMETEN**:
  - Wild Growth is erg duur; daar gaat het meeste mana naartoe.
  - De meeste manaproblemen komen door Regrowth **zonder** Abundance.
- **Rekensom (AFGELEID, zonder talenten en mastery):** per punt heal is een kale Regrowth ongeveer even zuinig als, of iets zuiniger
  dan, Rejuvenation. Het "duur" zit in de prijs per cast en in casten zonder Abundance.

### Wat dit betekent voor de drie teksten in MH
**GEMETEN** de teksten, **AFGELEID** het oordeel:
- `ACADEMY_HEAL_MANA_BODY` (`enUS.lua:2242`): "cheap, fast heals … save your big, expensive heals". **Fout** voor Priest en Shaman
  (Blizzard noemt de trage juist "efficient"). **Klopt** voor Holy Paladin.
- `HEALCORE_DESC_BIG` (`enUS.lua:4116`): "Bigger, slower heal … (easier on mana)". Dit label staat op Holy Light, Enveloping Mist en
  Healing Wave (`HealerCooldowns.lua:161, 185, 202`). **Klopt** voor Healing Wave. **Fout** voor Holy Light. Enveloping Mist:
  **niet gemeten**.
- `PLAYCARD_105_MISTAKE` (`enUS.lua:1317`): "Regrowth without 5 Rejuvenation … costs a lot of mana". **Klopt** (Abundance).
  En `PLAYCARD_105_S3` ("Someone drops low: Regrowth") botst er **niet** mee: in nood mag het; de fout is Regrowth spammen
  zonder Abundance.
- **Voorstel (AFGELEID, Rob kiest):** geen algemene regel "snel = goedkoop" in de Academy. Wel: "Blizzard zet het in de tooltip.
  Staat er *efficient*, dan is dat je zuinige heal."

---

## 7. Spec wisselen, loot spec en gear

### Spec wisselen
- **Waar:** micromenu **"Talents & Spellbook"** (`PLAYERSPELLS_BUTTON`) → tab **"Specialization"** (`TALENT_FRAME_TAB_LABEL_SPEC`)
  → knop **"Activate"** (`TALENT_SPEC_ACTIVATE`, `Blizzard_ClassSpecializationsFrame.xml:311`). — **GEMETEN**
- **Kost het iets? Nee.** De wissel-spell "Activating Specialization" (200749) heeft geen kostenregel in `SpellPower`. — **GEMETEN**
- **Hoe lang:** een cast van **5 seconden** (CastTimes 6 = 5000 ms). — **GEMETEN**
- **Buiten combat:** de spell heeft attribuutbit `0x10000000` in `Attributes_0`. — **GEMETEN**. Dat die bit "niet in combat"
  betekent: **AFGELEID** (bekende betekenis uit server-emulators, niet uit een Blizzard-bron).
- Of het in een lopende Mythic+ key of een raid mag: **niet gezocht.**

### Loot spec
- **Waar:** rechtsklik op je **eigen portret** → **"Loot Specialization"** (`SELECT_LOOT_SPECIALIZATION`). — **GEMETEN**
  (`UnitPopupMenus.lua:11`, het menu `UnitPopupMenuSelf`).
  - De standaardkeuze heet "Current Specialization ( … )" (`LOOT_SPECIALIZATION_DEFAULT`). Na een keuze zegt het spel
    "Loot Specialization set to: …" (`ERR_LOOT_SPEC_CHANGED_S`).
  - Blizzards eigen uitleg (`SELECT_LOOT_SPECIALIZATION_TOOLTIP`): de spec die bepaalt welke buit je krijgt; "Default" is je huidige spec.
- Een andere plek vond ik niet in de UI-code. — **GEMETEN** (zoektocht in 168 bestanden; positieve controle: dezelfde zoektocht vond
  de `UnitPopup`-regels wel).

### Gear: hoofdstat
- **Het spel zegt het zelf:** in de tab Specialization staat onder elke spec "**Primary Stat: …**" (`SPEC_FRAME_PRIMARY_STAT`,
  `Blizzard_ClassSpecializationsFrame.lua:348-349`). — **GEMETEN**. 📌 Goede tip voor de les: kijk daar.
- De DB2 (`ChrSpecialization.PrimaryStatPriority`, **GEMETEN**) deelt de specs in groepen in. Met de bekende waarden ingevuld
  (**AFGELEID**, de getallen zelf hebben geen naam):

| Klasse | Tank | Healer | DPS |
|---|---|---|---|
| Paladin | Prot: Strength | Holy: Intellect | Ret: Strength |
| Druid | Guardian: Agility | Resto: Intellect | Feral: Agility, Balance: Intellect |
| Monk | Brewmaster: Agility | Mistweaver: Intellect | Windwalker: Agility |
| Shaman | — | Resto: Intellect | Enhancement: Agility, Elemental: Intellect |
| Priest | — | Disc/Holy: Intellect | Shadow: Intellect |
| Evoker | — | Preservation: Intellect | Devastation/Augmentation: Intellect |
| Warrior, Death Knight | Prot/Blood: Strength | — | Strength |
| Demon Hunter | Vengeance: Agility | — | Havoc: Agility (Devourer: in de DB2 in de Intellect-groep) |

### Schild voor Prot Paladin en Prot Warrior
- **Zonder schild werken je belangrijkste knoppen niet.** — **GEMETEN** (DB2 `SpellEquippedItems`: item-klasse 4 = armor,
  subklasse-masker 64 = schild):
  - Prot Paladin: **Shield of the Righteous** (53600) en **Avenger's Shield** (31935).
  - Prot Warrior: **Shield Block** (2565) en **Shield Slam** (23922).
- De spec-omschrijving in het spel noemt het ook: "Preferred Weapon: … and Shield" bij Prot Paladin, Prot Warrior, Holy Paladin,
  Elemental en Resto Shaman. — **GEMETEN** (`ChrSpecialization.Description`)
- Blood DK gebruikt een tweehandig wapen ("Two-Handed Axe, Mace, Sword"). — **GEMETEN** (zelfde tabel)

---

## 8. Divine Shield: verlaagt het threat?

- **Nee, je threat blijft. Vijanden gaan alleen zolang iemand anders slaan.** — **GEMETEN** in warcraft.wiki.gg *Divine Shield*
  (bewerkt 20 apr 2026):
  - Vijanden negeren je zolang er iemand anders op hun threat-lijst staat.
  - De threat zelf blijft staan. Maar na afloop komen ze niet altijd terug ("threat inertia").
  - Voor tanks: alleen gebruiken als je de vijanden bewust aan iemand anders geeft, of de schild meteen weer weghalen en taunten.
- **DB2 (12.1.0.69933):** Divine Shield (642) heeft vier effecten: twee keer immuniteit, één tegen wegduwen, en één effect 136.
  **Geen threat-effect.** — **GEMETEN**. ⚠️ Een leeg resultaat bewijst niets: dit gedrag kan aan de serverkant zitten.
- **Uitzondering: het talent Final Stand** (204077, in de Paladin-boom). Tijdens Divine Shield worden alle vijanden binnen **15 meter
  getaunt**. — **GEMETEN** (DB2-tekst en talentknoop 81504). Dan blijven ze dus wél bij jou.
  - Kleine tegenspraak: de wiki (11 aug 2026) zegt dat die taunt sinds 12.0 **6 sec** duurt; de DB2 geeft spell 204079
    SpellDuration 31 = **8 sec**. Niet opgelost.
- **Voor MH (AFGELEID):** `enUS.lua:4076` "hij dropt je threat" klopt in de praktijk, niet in het woord. Beter: "vijanden gaan iemand
  anders slaan zolang hij aan staat (tenzij je Final Stand hebt)". Dat is expert-rapport F7, nu met datum.

---

## Wat ik niet vond of niet kon meten

- **Niets in de client getest.** Menupaden komen uit Blizzards UI-code van dezelfde build, niet uit een screenshot.
- Of **Mouseover Cast** standaard aan of uit staat.
- Dat **links = Target, rechts = Menu** in Click Casting: alleen uit een forumpost (13 jun 2025), niet uit de code.
- De tweede **unlock-voorwaarde** per follower dungeon (ModifierTree-type 86) kon ik niet ontcijferen.
- Of je in een lopende **Mythic+ key** of in een raid van spec mag wisselen.
- De **naam** bij elk getal van `PrimaryStatPriority`; ik heb de tabel ingevuld met bekende waarden.
- **Mistweaver en Evoker**: heal per mana niet uitgerekend.
- Mijn heal-per-mana-sommen tellen **geen** talenten, mastery, crit of overheal mee. Ze zijn een richting, geen meting.
- Dat een taunt je threat **gelijktrekt** met wie het doel had: alleen Icy Veins zegt het; in de DB2 zie ik het niet.
- Wowhead-pagina's (via Exa) tonen geen datum. Exa kan een oude kopie geven (zie CLAUDE.md, 3 sep).
- warcraft.wiki.gg gaf in het browservenster een Cloudflare-controle. Die heb ik **niet** omzeild; de bewerkingsdatums komen uit
  de openbare wiki-API.
- De Icy Veins-tankgids heet nog "Midnight Season 1" in de titel, maar is bijgewerkt op 21 sep 2026 (na de start van Season 2).
