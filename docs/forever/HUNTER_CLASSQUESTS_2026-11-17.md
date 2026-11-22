# Hunter class-quests in WoW Forever — feiten voor `Modules/ForeverClassQuests.lua`

Onderzoek: mh-research, 17 nov 2026. Client: Forever 1.60.1.70938. Alleen gelezen, niets in het spel gezien.
Bij elke bewering staat **GEMETEN** (gezien in een bron, met regel of URL) of **AFGELEID** (beredeneerd).
De voordeur (`_probe.py` / `run gamedata`) is NIET gebruikt (opdracht). DB2 kwam via het web: wago.tools-CSV met filter.

## 0. Kort

- Hunter heeft in Forever **zes routes voor de pet op level 10** (Night Elf, Dwarf, **Human = nieuw**, Orc/Troll, Tauren,
  **Skyborne = nieuw**). Elke route: 3x *Taming the Beast* (tem een beest met een Taming Rod) en dan 1x *Training the Beast*.
- De derde *Taming the Beast* leert **Tame Beast 1515, Call Pet 883, Dismiss Pet 2641**. *Training the Beast* leert
  **Beast Training 5149, Feed Pet 6991, Revive Pet 982**. De zes spells in `ns.FOREVER_QUEST_FIRST` kloppen dus.
- Item-ketens: level 50 *The Hunter's Charm* (4 quests, Azshara + Sunken Temple) en level 60 *The Ancient Leaf*
  (Rhok'delar / Lok'delar / pijlkoker, 5 quests, raids). De level 60-keten past niet in de huidige vorm (begint met een item).
- Geen 98xxx-hunterquests in Spoken (positieve controle: dezelfde zoekopdracht vond druid 98393).

## 1. Bronnen

| # | Bron | Datum / versie | Gebruikt voor |
|---|---|---|---|
| Z-A | Zygor Forever `ZygorLevelingAllianceCLASSIC.lua` r.22145-22465 (Hunter Class Quests) en r.1008-1062 (Human, leveling) | Zygor Viewer (Forever) 1.6, bestand gelezen 17 nov 2026 | quest-id's, rods, plekken, volgorde |
| Z-H | Zygor Forever `ZygorLevelingHordeCLASSIC.lua` r.23566-23877 (Hunter Class Quests), r.2259-2406 en r.3804-3892 (leveling) | idem | idem |
| Z-C | Zygor Forever `ZygorLevelingCommonCLASSIC.lua` r.93, r.121, r.1165-1241 (Skyborne) | idem | Skyborne-keten |
| Z-L | Zygor `Localization-Forever/NPCs_enUS.lua` r.27256, 27318 en `NPCs_<taal>.lua` r.25, 571 | idem | npc-id's van 2 beesten; naamcontrole |
| SP-C | Spoken `Spoken_Quests/Data/Compendium.lua` (kop: client-tabellen Forever 1.60.1.70450 + Era 1.15.9.69109) | Spoken 3.9.0 | prev, ender, races, classes |
| SP-L | Spoken `SpokenQuestsAudioShared/generated/quest_id_lookups.lua` r.570-630 (accept), r.6504-6553 en r.7305-7312 (complete), r.1414-1420 | idem | wie geeft / wie neemt in |
| SP-T | Spoken `Spoken_Quests/Data/QuestText.lua` r.10459-10466, 16946-16957, 17129-17155, 17188-17195 | idem | questtekst (wat je leert) |
| SP-N | Spoken `Spoken_Quests/Locale/Names/<taal>.lua` | idem | tweede bron npc-namen |
| HN | `HandyNotes_ClassTrainers/Data.lua` (kop: Forever 1.60.1.70532) | versie 1.1.0 | trainer-coördinaten |
| DB2 | wago.tools CSV build 1.60.1.70938: `CharBaseInfo`, `SpellEffect`, `SpellName`, `UiMap` (URL-vorm `https://wago.tools/db2/<Tabel>/csv?build=1.60.1.70938&filter[Kolom]=exact:<waarde>`) | opgehaald 17 nov 2026 | wie kan hunter zijn, leerspells, UiMap-id's |
| WH-Q | Wowhead Forever questpagina's `https://www.wowhead.com/forever/quest=<id>` | opgehaald 17 nov 2026 | reeks, doel, rod-item, "You will learn" |
| WH-T | Wowhead Forever tooltip-JSON `https://nether.wowhead.com/forever/tooltip/npc/<id>` en per taal `https://nether.wowhead.com/forever/<de|fr|es|mx|pt|ru>/tooltip/npc/<id>` | opgehaald 17 nov 2026 | npc-naam, spawns, namen per taal |
| IV | Icy Veins "World of Warcraft: Forever Hunter Class Quests Guide" `https://www.icy-veins.com/wow-forever/hunter-class-quests` | laatst bijgewerkt 4 nov 2026 | welke beesten per ras, breadcrumb is vrijwillig |
| WW | Warcraft Wiki `https://warcraft.wiki.gg/wiki/Josephine_Carson` | "Added in patch 1.60.1 (2026-11-04)" | Josephine Carson bestaat alleen in Forever |

Beperking: het vak "Quick Facts" op Wowhead (minimumlevel, kant, start-NPC) komt niet mee met WebFetch. Wie een quest
geeft komt daarom uit Spoken (SP-L) en Zygor, niet van Wowhead.

Controles in dezelfde run:
- npc 233 = "Bauer Saldean" in deDE: GEMETEN in WH-T (`/forever/de/tooltip/npc/233`), SP-N `deDE.lua` r.14 en Z-L `NPCs_deDE.lua` r.25.
  Ook fr "Saldean le fermier", es/mx "Granjero Saldean", pt "Fazendeiro Saldanha", ru "Фермер Сальден" (WH-T = SP-N).
- Spoken-zoekopdracht `\[9\d{4}\] = \{.*classes = ` vond druid 98393 (r.4785) én de hunter-id's hieronder. Hunter-quests
  boven 90000 in Spoken: 92482, 94007, 94013, 94050, 94792, 94793, 94863, 94864, 94978, 94979. Geen 98xxx. GEMETEN.
- DB2-filter: `CharBaseInfo` gaf ook de druid-rijen (ClassID 11: ras 4, 6, 95, 96), dus het filter raakt.

## 2. Wie kan hunter zijn

GEMETEN in DB2 `CharBaseInfo` 1.60.1.70938 (rijen met ClassID 3):

| RaceID | Ras | raceFile | Kant |
|---|---|---|---|
| 1 | Human (rij 887, nieuw in Forever) | `Human` | Alliance |
| 3 | Dwarf | `Dwarf` | Alliance |
| 4 | Night Elf | `NightElf` | Alliance |
| 95 | Skyborne (High Order) | `Skyborne` | Alliance |
| 2 | Orc | `Orc` | Horde |
| 6 | Tauren | `Tauren` | Horde |
| 8 | Troll | `Troll` | Horde |
| 96 | Skyborne (Windshaper) | `Skyborne` | Horde |

- **Geen Gnome (7) en geen Undead (5)** als hunter: GEMETEN (geen rij). Past bij HN: geen hunter-trainer in Tirisfal Glades of Undercity.
- Welk ras bij welk RaceID hoort: klassieke nummering + de bestaande code (`RaceToken`, 95/96 = Skyborne). AFGELEID voor 1-8.

## 3. Spells: welke quest leert wat

| Spell | Id | Komt uit | Bewijs |
|---|---|---|---|
| Tame Beast | 1515 | de **derde** *Taming the Beast*: 6102 (Night Elf), 6085 (Dwarf), 6082 (Orc/Troll), 6088 (Tauren), 94013 (Skyborne) | GEMETEN WH-Q: "You will learn: Tame Beast" (link spell=1515) op alle vijf |
| Call Pet | 883 | dezelfde quest | GEMETEN DB2 `SpellEffect`: leerspell 1579 "Tame Beast" = Effect 36 (leer spell) x3: 1515, 883, 2641. GEMETEN SP-T 6102 complete: "the power to tame a beast, as well as call it and dismiss it". Dát de quest spell 1579 gebruikt: AFGELEID |
| Dismiss Pet | 2641 | dezelfde quest | idem |
| Beast Training | 5149 | *Training the Beast*: 6103, 6086, 6081, 6089, 94050 | GEMETEN WH-Q: "You will learn: Beast Training" (spell=5149) op alle vijf |
| Feed Pet | 6991 | dezelfde quest | GEMETEN DB2: leerspell 5300 "Beast Training" = 5149, 6991, 982. GEMETEN SP-T 6103 / 94793 / 94050 complete: "teach your pet new abilities … feed your pet, as well as revive it". Dát de quest spell 5300 gebruikt: AFGELEID |
| Revive Pet | 982 | dezelfde quest | idem |

- **Human (nieuw)**: WH-Q toont bij 94864 "You will learn: Taming Lesson" (spell 23356) en bij 94793 "Training Lesson"
  (spell 23357). GEMETEN. In DB2 hebben 23356 en 23357 alleen Effect 3 (dummy): wat ze leren regelt de server. Dat het
  dezelfde zes spells zijn: AFGELEID (sterk: SP-T 94793 accept "You now have the power to tame a pet" en dezelfde
  complete-tekst als 6103; Zygor Z-A r.1056-1061 laat je daarna "Cast Tame Beast" doen).
- Er bestaat nog een leerspell 1584 "Feed Pet" (leert 6991), GEMETEN DB2. Wie die gebruikt: niet gemeten.
- **`ns.FOREVER_QUEST_FIRST`** (`Modules/ForeverTrainer.lua` r.38-39) noemt 1515, 883, 2641 en 5149, 6991, 982: GEMETEN in
  het bestand. Die zes kloppen met het bovenstaande. Level 10 klopt (Zygor "ding 10"; IV "unlocks your pet at Level 10").

## 4. De ketens

Level 10 = Zygor "ding 10" (Z-A r.22149, Z-H r.23570) + IV. Questlevel 10 op elke Wowhead-pagina (link experience-calculator?level=10). GEMETEN.
Volgorde binnen een route: GEMETEN in Zygor, in de "Series" op Wowhead en in Spoken `prev`.
In elke *Taming the Beast* krijg je een **Taming Rod** (staat al in je tas, "Provided item"); het enige doel is
"Tame a …" = **objective 1**. Na het temmen lever je de quest in bij dezelfde trainer.

### 4.1 Night Elf (Alliance) — Teldrassil

| q | Naam | Gever | Inleveren | Doel |
|---|---|---|---|---|
| 6063 | Taming the Beast | Dazalar (3601), Dolanaar | Dazalar | rod **15921**, tem een Webwood Lurker (obj 1) |
| 6101 | Taming the Beast | Dazalar | Dazalar | rod **15922**, tem een Nightsaber Stalker (obj 1) |
| 6102 | Taming the Beast | Dazalar | Dazalar | rod **15923**, tem een Strigid Screecher (obj 1). Leert Tame Beast |
| 6103 | Training the Beast | Dazalar | Jocaste (4146), Darnassus | geen. Leert Beast Training |

GEMETEN: Z-A r.22150-22197; WH-Q 6063/6101/6102/6103; SP-C r.2665, 2688-2690 (races 8, classes 4, 6103 ender 4146);
SP-L r.586-590, 607, 7308.

### 4.2 Dwarf (Alliance) — Dun Morogh

| q | Naam | Gever | Inleveren | Doel |
|---|---|---|---|---|
| 6064 | Taming the Beast | Grif Wildheart (1231), Kharanos | Grif Wildheart | rod **15911**, tem een Large Crag Boar (obj 1) |
| 6084 | Taming the Beast | Grif Wildheart | Grif Wildheart | rod **15913**, tem een Snow Leopard (obj 1) |
| 6085 | Taming the Beast | Grif Wildheart | Grif Wildheart | rod **15908**, tem een Ice Claw Bear (obj 1). Leert Tame Beast |
| 6086 | Training the Beast | Grif Wildheart | Belia Thundergranite (10090), Ironforge | geen. Leert Beast Training |

GEMETEN: Z-A r.22198-22242; WH-Q 6064/6084/6085/6086; SP-C r.2666, 2682-2684; SP-L r.571-575, 604, 7309.
Opvallend: SP-C geeft 6085 het rassenmasker "alle Alliance" (4294967373), de andere drie alleen Dwarf (4). Geen gevolg.

### 4.3 Human (Alliance) — Elwynn Forest — NIEUW in Forever

| q | Naam | Gever | Inleveren | Doel |
|---|---|---|---|---|
| 94792 | Taming the Beast | Josephine Carson (251507), Goldshire | Josephine Carson | rod **266158**, tem een Rockhide Boar (obj 1) |
| 94863 | Taming the Beast | Josephine Carson | Josephine Carson | rod **266253**, tem een Gray Forest Wolf (obj 1) |
| 94864 | Taming the Beast | Josephine Carson | Josephine Carson | rod **266254**, tem een Young Forest Bear (obj 1). Wowhead: "Taming Lesson" |
| 94793 | Training the Beast | Josephine Carson | Isaac Chan (258930), Goldshire | geen. Wowhead: "Training Lesson" |

GEMETEN: Z-A r.1008-1050 (leveling guide; staat NIET in Zygors "Hunter Class Quests"); WH-Q 94792/94863/94864/94793
(reeks van vier, geen breadcrumb ervoor); SP-C r.4500-4501, 4505-4506 (94793 ender 258930); SP-L r.591-595, 608, 7310; WW.
- Rassen: SP-C geeft masker 4294967373 = Human + Dwarf + Night Elf + Gnome + Alliance-Skyborne. GEMETEN. Zygor zegt
  alleen "only if Hunter" in de Elwynn-gids. Dat ik de keten aan **Human** hang: AFGELEID (de andere rassen hebben een
  eigen route thuis). Of een Dwarf of Night Elf hem ook mag doen: niet gemeten.

### 4.4 Orc en Troll (Horde) — Durotar

| q | Naam | Gever | Inleveren | Doel |
|---|---|---|---|---|
| 6062 | Taming the Beast | Thotar (3171), Razor Hill | Thotar | rod **15917**, tem een Dire Mottled Boar (obj 1) |
| 6083 | Taming the Beast | Thotar | Thotar | rod **15919**, tem een Surf Crawler (obj 1) |
| 6082 | Taming the Beast | Thotar | Thotar | rod **15920**, tem een Armored Scorpid (obj 1). Leert Tame Beast |
| 6081 | Training the Beast | Thotar | Ormak Grimshot (3352), Orgrimmar | geen. Leert Beast Training |

Let op de volgorde: 6062 → **6083** → **6082** → 6081 (niet oplopend). GEMETEN: Z-H r.23571-23620; WH-Q 6062/6083/6082/6081;
SP-C r.2664, 2679-2681 (races 130 = Orc + Troll); SP-L r.581-585, 606, 7307.

### 4.5 Tauren (Horde) — Mulgore

| q | Naam | Gever | Inleveren | Doel |
|---|---|---|---|---|
| 6061 | Taming the Beast | Yaw Sharpmane (3065), Bloodhoof Village | Yaw Sharpmane | rod **15914**, tem een Adult Plainstrider (obj 1) |
| 6087 | Taming the Beast | Yaw Sharpmane | Yaw Sharpmane | rod **15915**, tem een Prairie Stalker (obj 1) |
| 6088 | Taming the Beast | Yaw Sharpmane | Yaw Sharpmane | rod **15916**, tem een Swoop (obj 1). Leert Tame Beast |
| 6089 | Training the Beast | Yaw Sharpmane | Holt Thunderhorn (3039), Thunder Bluff | geen. Leert Beast Training |

GEMETEN: Z-H r.23621-23668; WH-Q 6061/6087/6088/6089; SP-C r.2663, 2685-2687 (races 32); SP-L r.576-580, 605, 7306.

### 4.6 Skyborne (Alliance én Horde) — Zephras Isle — NIEUW in Forever

| q | Naam | Gever | Inleveren | Doel |
|---|---|---|---|---|
| (94007) | Taming the Beast (breadcrumb) | Elayaa Easewind (254084) | Quel'ana Quickgale (252389), Valanaar | "Report to Quel'ana Quickgale in Valanaar". Vrijwillig, zie 4.8 |
| 94978 | Taming the Beast | Quel'ana Quickgale (252389) | Quel'ana Quickgale | rod **267272**, tem een Windsong Crawler (obj 1) |
| 94979 | Taming the Beast | Quel'ana Quickgale | Quel'ana Quickgale | rod **267298**, tem een Ornery Galestrider (obj 1) |
| 94013 | Taming the Beast | Quel'ana Quickgale | Quel'ana Quickgale | rod **264163**, tem een Vuldren Alpha (obj 1). Leert Tame Beast |
| 94050 | Training the Beast | Quel'ana Quickgale | Quel'dora Quickgale (254411), Valanaar | geen. Leert Beast Training |

GEMETEN: Z-C r.1165-1241 (Zygor begint bij 94978, zonder 94007); WH-Q 94007/94978/94979/94013/94050; SP-C r.4451-4453,
4515-4516 (races 12884901888 = beide Skyborne-rassen; 94978 prev 94007; 94050 ender 254411); SP-L r.596-601, 609, 7311;
SP-T r.16946-16957, 17188-17195.
- 94049 "zzOLD Training the Beast" staat nog op Wowhead in de reeks: een oude, vervallen versie. GEMETEN (WH-Q 94049). Niet bouwen.
- Beide kanten doen dezelfde quests: GEMETEN (één masker, Zygor Common-gids). 

### 4.7 Wat `needs` moet zijn

*Training the Beast* opent pas na de derde *Taming the Beast*. GEMETEN in SP-C `prev`: 6103 ← 6102, 6086 ← 6085,
6081 ← 6082, 6089 ← 6088, 94793 ← 94864, 94050 ← 94013.

### 4.8 Breadcrumb "The Hunter's Path" (niet bouwen)

Een andere hunter-trainer stuurt je naar de level 10-trainer. Vrijwillig: Zygors class-gids pakt *Taming the Beast*
direct (GEMETEN Z-A r.22150-22152, Z-H r.23571-23574) en IV zegt "You can also pick up a breadcrumb quest". Dat hij
echt niet verplicht is: AFGELEID (Spoken noemt hem wel als `prev`).

| Naar | Quest-id's (gever volgens SP-L r.611-629) |
|---|---|
| Dazalar (Night Elf) | 6071 Jocaste, 6072 Ayanna Everstride, 6073 Einris Brightspear, 6721 Regnus Thundergranite, 6722 Grif Wildheart |
| Grif Wildheart (Dwarf) | 6074 Olmin Burningbeard, 6075 Tristane Shadowstone (11807), 6076 Einris Brightspear |
| Thotar (Orc/Troll) | 6068 Sian'dur, 6069 Kali Remik (11814), 6070 Kary Thunderhorn |
| Yaw Sharpmane (Tauren) | 6065 Kary Thunderhorn, 6066 Lanka Farshot, 6067 Thotar |
| Quel'ana Quickgale (Skyborne) | 94007 Elayaa Easewind |
| Josephine Carson (Human) | geen gevonden (94792 heeft geen `prev`; Wowhead-reeks begint bij 94792) |

GEMETEN: SP-C r.2667-2678, 2832-2833, 4451; SP-L. Advies: weglaten. Zou je hem als eerste stap zetten, dan stuurt de pijl
een speler die al naast de level 10-trainer staat eerst naar een andere trainer.

### 4.9 Level 50 — The Hunter's Charm (item-keten)

| q | Naam | Gever | Inleveren | Doel |
|---|---|---|---|---|
| 8151 | The Hunter's Charm | hunter-trainer in een hoofdstad (zie onder) | Ogtinc (8405), Azshara | geen ("Speak to Ogtinc in Azshara") |
| 8153 | Courser Antlers | Ogtinc | Ogtinc | 2x Perfect Courser Antler (item 20017) van Mosshoof Courser (8761). obj 1 |
| 8231 | Wavethrashing | Ogtinc | Ogtinc | 6x Wavethrasher Scale (item 20087), in het water. obj 1 |
| 8232 | The Green Drake | Ogtinc | Ogtinc | Tooth of Morphaz (item 20019) van Morphaz (5719), dungeon Sunken Temple. obj 1 |

- GEMETEN: Z-A r.22243-22326, Z-H r.23669-23739; WH-Q 8151/8153/8231/8232 (reeks van vier); SP-C r.3289-3290, 3334-3335 (geen rassenmasker).
- Gevers van 8151, GEMETEN SP-L r.1414-1420: **Dorion** (Darnassus), **Olmin Burningbeard** (Ironforge), **Ulfir Ironbeard**
  (Stormwind), **Ormak Grimshot** (Orgrimmar), **Holt Thunderhorn** (Thunder Bluff). Zygor gebruikt Dorion (Alliance) en Ormak (Horde).
- Level: Zygor "ding 50" (52 op hardcore). Questlevel 52 (WH-Q). Minimumlevel 50: GEMETEN in Zygor, niet op Wowhead te zien.
- Beloning 8232, GEMETEN WH-Q: Devilsaur Eye (19991), Devilsaur Tooth (19992), Hunting Spear (20083). Wowhead toont
  dezelfde drie onder "choose one of these rewards" én onder "You will also receive". Alle drie of kiezen: niet gemeten.
- ⚠️ IV (4 nov 2026): "we were never able to confirm this during the Beta. The Beta ended at Level 30". Dat de keten
  in Forever live staat is dus niet door een gids bevestigd; hij staat wel in Wowhead Forever, Zygor Forever en Spoken.

### 4.10 Level 60 — The Ancient Leaf (Rhok'delar, Lok'delar, pijlkoker) — raids

| q | Naam | Gever | Inleveren | Doel |
|---|---|---|---|---|
| 7632 | The Ancient Leaf | **item** Ancient Petrified Leaf (18703), buit bij Majordomo Executus (12018) in Molten Core | Vartrus the Ancient (14524), Felwood | "Find the owner of the Ancient Petrified Leaf" |
| 7633 | An Introduction | Vartrus the Ancient | Vartrus the Ancient | geen (alleen een completion-tekst) |
| 7636 | Stave of the Ancients | Vartrus the Ancient | Vartrus the Ancient | obj 1 Simone's Head (18952), obj 2 Klinfran's Head (18953), obj 3 Solenor's Head (18954), obj 4 Artorius's Head (18955). Meegegeven: Petrified Bark (18708). Beloning: Ancient Rune Etched Stave (18707) |
| 7635 | A Proper String | Stoma the Ancient (14525) | Stoma the Ancient | Mature Black Dragon Sinew (18705), Onyxia (10184). obj 1. Beloning: Enchanted Black Dragon Sinew (18724) |
| 7634 | Ancient Sinew Wrapped Lamina | Hastat the Ancient (14526) | Hastat the Ancient | Mature Blue Dragon Sinew (18704). obj 1. Beloning: Ancient Sinew Wrapped Lamina (18714, pijlkoker) |

- GEMETEN: Z-A r.22327-22464, Z-H r.23740-23876; WH-Q 7632-7636; SP-C r.3011-3015 (7633 heeft `prev` 7632; 7634, 7635 en 7636 hebben `prev` 7633; 7632 en 7633 ender 14524).
- Eind-items volgens Zygor (Z-A r.22461-22463): Rhok'delar, Longbow of the Ancient Keepers (18713) en Lok'delar, Stave of the Ancient Keepers (18715). GEMETEN in Zygor.
- De vier demonen (Zygor): Simone the Inconspicuous (14527), Un'Goro Crater, loopt rond; Franklin the Friendly (14529) → Klinfran the Crazed (14534), Burning Steppes;
  Nelson the Nice (14536) → Solenor the Slayer (14530), Silithus 26.00, 81.20; Artorius the Amiable (14531) → Artorius the Doombringer (14535), Winterspring 58.20, 15.60. "Must be done alone."
- Waar de Mature Blue Dragon Sinew vandaan komt: niet gemeten.
- **Past niet in de huidige vorm**: quest 7632 begint met een item, er is geen gever met een plek. `Step()` geeft dan
  `place = e.from` = nil en `StepWhat` roept `Where(nil)` aan → fout. Eerst een keuze van de bouwchat nodig. Daarom niet in de Lua-schets.

### 4.11 Geen keten (ter info)

- Level 1-brieven, geen spell: 3117 Etched Sigil (Night Elf), 3108 Etched Rune (Dwarf), 3087 Etched Parchment (Orc), 3082 Etched Tablet (Troll),
  3092 Etched Note (Tauren). GEMETEN SP-C r.1797-1831.
- Human: 92479 "A Scribbled Letter", inleveren bij Tordrin Sternblade (248415, hunter-trainer Northshire). GEMETEN Z-A r.204, 278-280 ("only if Hunter") en HN r.95.
  Spoken zet er `sort = 81, classes = 1` (warrior) bij: dat lijkt een fout in Spoken.
- Skyborne: 92482 "The Way of the Hunter" (Rorian the Dayseeker → Tai'ree Farsight 251376; lees de Scribbled Note 282421; questlevel 2; geen spell). GEMETEN Z-C r.93, 121; WH-Q 92482; SP-C r.4348.

## 5. Plekken (voor `HU_P`)

UiMap-id's: GEMETEN in DB2 `UiMap` 1.60.1.70938: Teldrassil 1438, Dun Morogh 1426, Durotar 1411, Mulgore 1412, Elwynn Forest 1429,
Zephras Isle 2521, Felwood 1448, **Azshara 1447 (nieuw voor dit bestand)**, Silithus 1451. Uit de bestaande P/WL_P/WR_P en HN-koppen:
Darnassus 1457, Ironforge 1455, Stormwind City 1453, Orgrimmar 1454, Thunder Bluff 1456, Swamp of Sorrows 1435.
Regel: trainers uit HandyNotes (net als `WR_P.lyria` = HN `[41106563]`), de rest uit Zygor. Niets in het spel gezien.

### 5.1 NPC's

| Sleutel | NPC (id) | UiMap | x | y | Bron (gekozen) | Andere bronnen |
|---|---|---|---|---|---|---|
| dazalar | Dazalar (3601) | 1438 | [stond in HandyNotes] | [stond in HandyNotes] | HN r.237 | Zygor 56.68, 59.49; WH-T 56.6, 59.4 |
| jocaste | Jocaste (4146) | 1457 | 40.38 | 8.55 | HN r.30 | Zygor 40.38, 8.56; WH-T 40.2, 8.4 |
| grif | Grif Wildheart (1231) | 1426 | 45.81 | 53.04 | HN r.49 | Zygor 45.81, 53.04; WH-T 45.8, 53.0 |
| belia | Belia Thundergranite (10090) | 1455 | 70.86 | 85.83 | HN r.126 | Zygor 70.87, 85.80; WH-T 70.8, 85.4 |
| josephine | Josephine Carson (251507) | 1429 | [stond in HandyNotes] | [stond in HandyNotes] | HN r.94 | Zygor 41.15, 66.23; WH-T 41.2, 66.2; WW 41.1, 66.2 |
| isaac | Isaac Chan (258930) | 1429 | [stond in HandyNotes] | [stond in HandyNotes] | HN r.96 | Zygor 41.79, 66.37; WH-T 41.8, 66.4 |
| thotar | Thotar (3171) | 1411 | [stond in HandyNotes] | [stond in HandyNotes] | HN r.70 | Zygor 51.85, 43.49; WH-T 51.8, 43.4 |
| ormak | Ormak Grimshot (3352) | 1454 | [stond in HandyNotes] | [stond in HandyNotes] | HN r.170 | Zygor 66.05, 18.54; WH-T 66.2, 18.2 |
| yaw | Yaw Sharpmane (3065) | 1412 | [stond in HandyNotes] | [stond in HandyNotes] | HN r.157 | Zygor 46.92, 59.69; WH-T 46.8, 59.4 |
| holt | Holt Thunderhorn (3039) | 1456 | [stond in HandyNotes] | [stond in HandyNotes] | HN r.256 | Zygor 57.31, 89.76; WH-T 57.2, 89.6 |
| quelana | Quel'ana Quickgale (252389) | 2521 | [stond in HandyNotes] | [stond in HandyNotes] | HN r.316 | Zygor 59.57, 72.64; WH-T 59.6, 72.6 |
| queldora | Quel'dora Quickgale (254411) | 2521 | [stond in HandyNotes] | [stond in HandyNotes] | HN r.318 | Zygor 59.60, 72.53; WH-T 59.6, 72.4 |
| dorion | Dorion (4205) | 1457 | [stond in HandyNotes] | [stond in HandyNotes] | HN r.28 | Zygor 42.21, 7.26; WH-T 42.0, 7.4 |
| olmin | Olmin Burningbeard (5116) | 1455 | [stond in HandyNotes] | [stond in HandyNotes] | HN r.124 | - |
| ulfir | Ulfir Ironbeard (5516) | 1453 | [stond in HandyNotes] | [stond in HandyNotes] | HN r.201 | - (Stormwind-kaart is in Forever groter, HN-kop) |
| ogtinc | Ogtinc (8405) | 1447 | 42.40 | 42.62 | Zygor Z-A r.22257 | WH-T 42.4, 42.6 |
| (vartrus) | Vartrus the Ancient (14524) | 1448 | 48.99 | 24.44 | Zygor Z-A r.22346 | WH-T 48.8, 24.2 |
| (stoma) | Stoma the Ancient (14525) | 1448 | 48.31 | 24.43 | Zygor Z-A r.22353 | WH-T 48.6, 23.2 (wijkt af, zie §10) |
| (hastat) | Hastat the Ancient (14526) | 1448 | 48.2 | 24.4 | WH-T (48.2, 24.2 en 48.2, 24.6) | niet in Zygor |
| (elayaa) | Elayaa Easewind (254084) | 2521 | [stond in HandyNotes] | [stond in HandyNotes] | HN r.315 | WH-T 45.2, 44.2 |

Namen en id's: GEMETEN in WH-T (Engelse tooltip, naam komt overeen) voor alle rijen. Mulgore: de Forever-kaart is groter
(HN-kop); Zygor (46.92, 59.69) en HN ([stond in HandyNotes]) zitten in dezelfde nieuwe kaartruimte, Wowhead toont ook nog het oude
punt 47.8, 55.6. GEMETEN.

### 5.2 Tem-plekken en doelen (geen NPC)

| Sleutel | Wat | UiMap | x | y | Bron (gekozen) | Tweede Zygor-plek (leveling guide) | Controle Wowhead-spawns |
|---|---|---|---|---|---|---|---|
| webwood | Webwood Lurker (1998) | 1438 | 59.81 | 59.06 | Z-A r.22157 | 61.40, 58.55 (r.3925) | ja: 59.8, 59.6 / 60.0, 58.9 |
| nightsaber | Nightsaber Stalker (2043) | 1438 | 55.95 | 71.98 | Z-A r.22169 | 61.80, 73.00 (r.3946) | ja: 56.0, 71.6 / 55.6, 72.6 |
| screecher | Strigid Screecher (1996) | 1438 | 43.99 | 51.16 | Z-A r.22182 | 64.00, 66.20 (r.3958) | ja: 43.4, 51.5 / 43.6, 50.4 (questtekst: "found west of here") |
| cragboar | Large Crag Boar (1126) | 1426 | 48.26 | 56.81 | Z-A r.22205 | 49.80, 53.40 (r.2401) | ja: 48.2, 57.5 / 48.4, 57.3 |
| snowleopard | Snow Leopard (1201) | 1426 | 48.68 | 58.93 | Z-A r.22217 | 48.20, 57.40 (r.2419) | ja: 48.4, 58.6 / 49.0, 59.0 |
| iceclaw | Ice Claw Bear (1196) | 1426 | 49.06 | 62.12 | Z-A r.22229 | 50.20, 53.00 (r.2433); Zygor noemt ook 50.11, 53.57 | ja: 49.0, 62.1 |
| rockhide | Rockhide Boar (524) | 1429 | 46.04 | 77.92 | Z-A r.1018 | - | dichtstbij 43.3, 77.4 (ruim 2,5 ernaast) |
| graywolf | Gray Forest Wolf (1922) | 1429 | 65.73 | 63.52 | Z-A r.1029 | - | dichtstbij 68.8, 62.5 en 65.6, 58.4 (3-5 ernaast) |
| forestbear | Young Forest Bear (822) | 1429 | 46.92 | 78.34 | Z-A r.1040 | - | dichtstbij 45.7, 75.9 (ruim 2,5 ernaast) |
| direboar | Dire Mottled Boar (3099) | 1411 | 51.84 | 47.23 | Z-H r.23579 | 51.40, 48.00 (r.3809) | NEE: Wowhead toont dit beest onder zone 1637, dichtstbijzijnde punt 52.3, 57.0 |
| surfcrawler | Surf Crawler (3107) | 1411 | 59.01 | 27.64 | Z-H r.23593 | 57.80, 28.00 (r.3828) | ja: 58.7, 27.0 / 59.1, 26.2 |
| scorpid | Armored Scorpid (3126) | 1411 | 45.21 | 45.77 | Z-H r.23606 | 55.00, 38.20 (r.3843) | ja: 44.8, 44.8 / 46.2, 46.1 |
| plainstrider | Adult Plainstrider (2956) | 1412 | 43.58 | 56.46 | Z-H r.23628 | 41.91, 58.61 (r.2269); Zygor noemt ook 40.11, 57.35 | deels: 42.4, 58.1 / 43.4, 52.8 |
| stalker | Prairie Stalker (2959) | 1412 | 45.81 | 54.16 | Z-H r.23641 | 46.91, 55.45 (r.2314) | ja: 46.0, 54.0 / 45.8, 55.8 |
| swoop | Swoop (2970) | 1412 | 45.81 | 54.16 | Z-H r.23653 | 44.74, 54.95 (r.2377) | ja: 45.1, 54.2 |
| windsong | Windsong Crawler (254588) | 2521 | 53.72 | 77.80 | Z-C r.1184 | - | ja: 53.9, 76.9 / 54.3, 77.5 |
| galestrider | Ornery Galestrider (251707) | 2521 | 57.30 | 71.27 | Z-C r.1210 | - | ja: 57.5, 71.4 / 57.0, 70.8 |
| vuldren | Vuldren Alpha (id niet gemeten) | 2521 | 56.63 | 67.74 | Z-C r.1223 | - | niet te controleren |
| coursers | Mosshoof Courser (8761) | 1447 | 49.47 | 17.62 | Z-A r.22264 | - | niet gecontroleerd |
| wavethrashers | Wavethrashers | 1447 | 52.61 | 41.87 | Z-A r.22282 | meer plekken: 59.77, 37.36; 67.20, 33.08; 72.19, 35.39 | niet gecontroleerd |
| (P.sunken) | ingang Sunken Temple | 1435 | 69.36 | 56.89 | bestaat al in `P` | Z-A r.22306 = hetzelfde punt | - |

Npc-id's van de beesten: GEMETEN, de Wowhead-tooltip van dat id geeft die naam (1998, 2043, 1996, 1126, 1201, 1196, 524, 1922,
822, 3099, 3107, 3126, 2956, 2959, 2970, 254588, 251707). De twee Skyborne-id's komen uit Z-L. Dat de quest precies dít id telt: AFGELEID.
Bij Wowhead staan ook punten vlak bij de trainer (bv. Strigid Screecher op 56.6, 59.5): dat zijn getemde quest-pets, geen spawns. AFGELEID.

## 6. Objective-index

| Quest | Index | Tekst (Wowhead) | Bron |
|---|---|---|---|
| 6063, 6101, 6102 | 1 | Tame a Webwood Lurker / Nightsaber Stalker / Strigid Screecher | Zygor `q <id>/1`; WH-Q (één regel) |
| 6064, 6084, 6085 | 1 | Tame a Large Crag Boar / Snow Leopard / an Ice Claw Bear | idem |
| 94792, 94863, 94864 | 1 | Tame a Rockhide Boar / Gray Forest Wolf / Young Forest Bear | Zygor Z-A r.1018, 1029, 1040; WH-Q |
| 6062, 6083, 6082 | 1 | Tame a Dire Mottled Boar / Surf Crawler / an Armored Scorpid | Zygor; WH-Q |
| 6061, 6087, 6088 | 1 | Tame an Adult Plainstrider / a Prairie Stalker / a Swoop | Zygor; WH-Q |
| 94978, 94979, 94013 | 1 | Tame a Windsong Crawler / an Ornery Galestrider / a Vuldren Alpha | Zygor Z-C; WH-Q |
| 8153 | 1 | Perfect Courser Antler (2) | Zygor `q 8153/1`; WH-Q |
| 8231 | 1 | Wavethrasher Scales (6) | Zygor `q 8231/1`; WH-Q |
| 8232 | 1 | Tooth of Morphaz (1) | Zygor `q 8232/1`; WH-Q |
| 7636 | 1 / 2 / 3 / 4 | Simone's / Klinfran's / Solenor's / Artorius's Head | Zygor `q 7636/1..4`; WH-Q zelfde volgorde |
| 7635 | 1 | Mature Black Dragon Sinew | Zygor `q 7635/1`; WH-Q |
| 7634 | 1 | Mature Blue Dragon Sinew | alleen WH-Q |

De Taming Rod is "Provided item" en telt niet als objective (WH-Q). Dat de index in `C_QuestLog.GetQuestObjectives`
dezelfde is: AFGELEID (zoals bij de andere ketens). De `items`-vorm is hier niet bruikbaar: de rod zit vanaf het begin in je tas.

## 7. NPC-namen per taal (voor `NPC_NAMES`)

Bron: WH-T per taal, 17 nov 2026. Tweede bron waar die er is: SP-N (zelfde naam, tenzij genoemd). Namen zonder
[haken] = de naam van die client; met [haken] = Wowhead heeft hem niet → weggelaten.

| Id | enUS | deDE | frFR | esES | esMX | ptBR | ruRU |
|---|---|---|---|---|---|---|---|
| 3601 | Dazalar | Dazalar | Dazalar | Dazalar | Dazalar | Dazalar | Дазалар |
| 4146 | Jocaste | Jocaste | Jocaste | Jocaste | Jocaste | Jocasta | Иокаста |
| 1231 | Grif Wildheart | Grif Wildheart | Grif Wildheart | Grif Corazón Salvaje | Grif Corazón Salvaje | Grif Selvacuore | Гриф Дикое Сердце |
| 10090 | Belia Thundergranite | Belia Thundergranite | Belia Thundergranite | Belia Tronagranito | Belia Tronagranito | Bélia Granitrondo | Белия Громовой Гранит |
| 3171 | Thotar | Thotar | Thotar | Thotar | Thotar | Thotar | Тотар |
| 3352 | Ormak Grimshot | Ormak Grimshot | Ormak Grimshot | Ormak Tirosiniestro | Ormak Tirosiniestro | Ormak Tiroatroz | Ормак Лютострел |
| 3065 | Yaw Sharpmane | Yaw Sharpmane | Yaw Sharpmane | Yaw Crinafilada ⚠️ | Yaw Crinafilada | Yaw Crina Cortante | Йо Колкая Грива |
| 3039 | Holt Thunderhorn | Holt Thunderhorn | Holt Thunderhorn | Holt Tronacuerno | Holt Tronacuerno | Holto Chifre Troante | Холь Громовой Рог |
| 251507 | Josephine Carson | Josephine Carson | Joséphine Carson | Josephine Carson | Josephine Carson | Josefina Carsom | Жозефина Карсон |
| 258930 | Isaac Chan | Isaac Chan | Isaac Chan | Isaac Chan | Isaac Chan | Isaac Chan | Исаак Чан |
| 252389 | Quel'ana Quickgale | Quel'ana Quickgale | Quel'ana Vent-Vif | Quel'ana Prestovendaval | Quel'ana Ventarrápido | Quel'ana Ventiágil | Кве'лана Быстрый Порыв |
| 254411 | Quel'dora Quickgale | Quel'dora Quickgale | Quel'dora Vent-Vif | Quel'dora Prestovendaval | Quel'dora Ventarrápido | Quel'dora Ventiágil | Кель'дора Стремительный Шторм |
| 4205 | Dorion | Dorion | Dorion | Dorion | Dorion | Dorion | Дорион |
| 5116 | Olmin Burningbeard | Olmin Burningbeard | Olmin Burningbeard | Olmin Barbanllamas | Olmin Barbardiente | Olmin Barbardente | Олмин Пламебород |
| 5516 | Ulfir Ironbeard | Ulfir Ironbeard | Ulfir Ironbeard | Ulfir Barbaférrea | Ulfir Barbaférrea | Ulfir Barbaférrea | Ульфир Железнобород |
| 8405 | Ogtinc | Ogtinc | Ogtinc | Ogtinc | (weglaten) | Ogtinc | Огтинк |
| 14524 | Vartrus the Ancient | Vartrus der Uralte | L'Ancien Vartrus | Vartrus el Ancestro | (weglaten) | Vartrus, o Anciente | Вартус Древний |
| 14525 | Stoma the Ancient | Stoma der Uralte | L'Ancien Stoma | Estoma el Anciano | (weglaten) | Stoma, o Anciente | Стома Древний |
| 14526 | Hastat the Ancient | Hastat der Uralte | L'Ancien Hastat | Hastat el Ancestro | (weglaten) | Hastat, o Anciente | Хастат Древний |

Alles GEMETEN in WH-T. Opmerkingen:
- ⚠️ **3065 esES**: Wowhead zegt "Yaw Crinafilada", Spoken `esES.lua` r.268 zegt "Guin Crinafilada" (Spoken esMX r.269: "Yaw Crinafilada"). Bronnen verschillen; Wowhead gekozen.
- **3352 deDE/frFR**: Zygor Z-L zegt "Ormak Grimmschlag" / "Ormak Trait-sinistre", Wowhead Forever zegt in beide talen "Ormak Grimshot".
  Wowhead gekozen: het past bij de rest van `NPC_NAMES` (oude NPC's houden in de/fr hun Engelse naam) en bij Spoken (1231 en 5116
  staan daar wél in ru/pt/es, niet in de/fr). Welke de Forever-client echt toont: AFGELEID.
- esMX van 8405, 14524, 14525, 14526: Wowhead geeft de Engelse naam tussen [haken] → weggelaten. Spoken heeft ze niet.
- ruRU: de zus en broer Quickgale hebben op Wowhead verschillende achternamen (Быстрый Порыв / Стремительный Шторм). Zo overgenomen.
- Tweede bron gelijk (SP-N): 1231 ru/pt/esES/esMX, 3065 ru/pt/esMX, 3171 ru, 3601 ru, 4146 ru/pt, 5116 en 5516 ru/pt/esES/esMX.
- Zygor schrijft "Vartus the Ancient"; Wowhead (alle talen) "Vartrus". Wowhead gevolgd.
- Namen van de beesten per taal: niet gemeten (id's staan in §5.2, te halen met de tooltip per taal).

## 8. Wat Forever nieuw of anders heeft

1. **Human hunters** bestaan (DB2 `CharBaseInfo` rij 887). Eigen keten in Goldshire: 94792 → 94863 → 94864 → 94793, nieuwe NPC's
   Josephine Carson (251507) en Isaac Chan (258930), nieuwe rods 266158 / 266253 / 266254. GEMETEN (Zygor, Wowhead, Spoken, WW).
2. **Skyborne hunters** (beide kanten): keten op Zephras Isle 94978 → 94979 → 94013 → 94050 met breadcrumb 94007, rods 267272 / 267298 / 264163. GEMETEN.
3. De Human-quests tonen op Wowhead "Taming Lesson" (23356) en "Training Lesson" (23357) in plaats van Tame Beast / Beast Training. GEMETEN.
4. Voor de vier oude routes (Night Elf, Dwarf, Orc/Troll, Tauren) zijn Wowhead Forever, Zygor Forever en Spoken het eens over
   id's, rods en beesten. Geen Forever-wijziging gevonden. GEMETEN.
5. Geen Gnome- of Undead-hunter. GEMETEN (DB2).
6. De "Series" op Wowhead bij de Night Elf-quests is vervuild met de Skyborne-quests (94007, 94013, 94978, 94979, 94049). Dat is
   een fout in de weergave van Wowhead, geen spelfeit. AFGELEID (Spoken en Zygor houden de reeksen gescheiden).
7. IV: het temmen met de rod is "channel the item for 10 seconds", het beest wordt vijandig. Niet zelf gemeten.

## 9. Zygor-fouten en afwijkingen (niet overnemen)

| # | Waar | Wat |
|---|---|---|
| 1 | Z-H r.23657 | `turnin Taming the Beast#6088`: één `#` in plaats van `##`. Tikfout; het id 6088 klopt. |
| 2 | Z-H r.23716 | In de hunter-gids staat `|confirm |q 8425`. 8425 is de warrior-quest Voodoo Feathers. Moet 8232 zijn (Z-A r.22303 heeft wel `|q 8232`). |
| 3 | Z-A r.22145-22465 | De gids "Hunter Class Quests" (Alliance) kent alleen Night Elf en Dwarf. De Human-keten (94792…) ontbreekt; die staat alleen in de leveling-gids r.1008-1050. |
| 4 | Z-A / Z-H / Z-C | De Skyborne-keten staat alleen in de Common-leveling-gids, niet in "Hunter Class Quests". De breadcrumb 94007 ontbreekt overal. |
| 5 | Z-A r.22344, Z-H r.23756 | "Vartus the Ancient" → Wowhead: "Vartrus the Ancient" (14524). |
| 6 | Z-A r.22353 | Stoma the Ancient op 48.31, 24.43. Wowhead: Stoma 48.6, 23.2 en **Hastat** 48.2, 24.2-24.6. Zygors punt ligt op Hastats plek. Mogelijke verwisseling; AFGELEID. |
| 7 | Z-A / Z-H | 7634 Ancient Sinew Wrapped Lamina (Hastat, pijlkoker) ontbreekt. 7633 An Introduction wordt aangenomen maar nergens ingeleverd (waarschijnlijk meteen klaar; niet gemeten). |
| 8 | Z-C r.1223 | "Tame a Vuldren", de quest zegt "Vuldren Alpha" (de tip erboven zegt het wel goed). |
| 9 | class-gids tegenover leveling-gids | Andere tem-plekken voor hetzelfde beest (bv. Armored Scorpid 45.21, 45.77 tegenover 55.00, 38.20; Strigid Screecher 43.99, 51.16 tegenover 64.00, 66.20). Beide liggen op Wowhead-spawns; geen fout, wel twee waarden. |
| 10 | Z-L `NPCs_deDE.lua` / `NPCs_frFR.lua` r.571 | 3352 "Ormak Grimmschlag" / "Ormak Trait-sinistre"; Wowhead Forever: "Ormak Grimshot". Zie §7. |

## 10. Lua-schets

Vorm als `WR_P` / `CHAINS.WARRIOR`. Twee ketens per route, omdat er twee spells zijn: "tame" eindigt zodra 1515 bekend is,
"training" opent met `needs` (zoals de warrior-keten `whirlwind` met `needs = 1719`). De ketennaam komt uit de client
(`SpellName`). Alternatief: één keten van vier quests met `spell = 5149` en een `nameKey`; dan is één extra tekst in 7 talen nodig.
Plaats: ná het warrior-blok, want `DWGN`, `NELF` en `TAUREN` worden pas rond r.483 van het bestand gemaakt (`HUM`, `ORCTROLL`
rond r.307-308, `SKYBORNE` rond r.210; het bestand schoof tijdens dit onderzoek 2 regels op, iemand werkte erin). De naam `H`
is nog vrij in het bestand (GEMETEN met grep; dezelfde grep vond `local W = WL_P` en `local R = WR_P`). Er staat nog geen
`HU_P` of `CHAINS.HUNTER` in (GEMETEN).

```lua
--[[ Hunter (17 Nov 2026). All facts: docs/forever/HUNTER_CLASSQUESTS_2026-11-17.md (mh-research): Zygor Forever "Hunter
	Class Quests" + the leveling guides (Human, Skyborne), Spoken, wago DB2 1.60.1.70938, Wowhead Forever, HandyNotes.
	GEMETEN: teach spell 1579 = Tame Beast 1515 + Call Pet 883 + Dismiss Pet 2641; 5300 = Beast Training 5149 + Feed Pet
	6991 + Revive Pet 982 (DB2); Wowhead shows "You will learn" Tame Beast on the third taming quest and Beast Training on
	Training the Beast. AFGELEID: the Human quests (Wowhead: Taming Lesson 23356 / Training Lesson 23357, dummy spells)
	teach the same six; the Elwynn chain is for Humans (Spoken: every Alliance race may take it); the objective index;
	which trainer starts the level 50 chain per race (five trainers give 8151). No Gnome or Undead hunter (CharBaseInfo).
	Not built: the breadcrumb The Hunter's Path (optional), and the level 60 chain The Ancient Leaf (starts from an item).
	Zygor mistakes not copied: |q 8425 in the Horde hunter guide (= 8232), "Vartus". Trainers: HandyNotes; the rest: Zygor. ]]
local HU_P = {
	dazalar = { npc = "Dazalar", id = 3601, m = 1438, xy = "stond in HandyNotes" },
	jocaste = { npc = "Jocaste", id = 4146, m = 1457, x = 40.38, y = 8.55 },
	grif = { npc = "Grif Wildheart", id = 1231, m = 1426, x = 45.81, y = 53.04 },
	belia = { npc = "Belia Thundergranite", id = 10090, m = 1455, x = 70.86, y = 85.83 },
	josephine = { npc = "Josephine Carson", id = 251507, m = 1429, xy = "stond in HandyNotes" },
	isaac = { npc = "Isaac Chan", id = 258930, m = 1429, xy = "stond in HandyNotes" },
	thotar = { npc = "Thotar", id = 3171, m = 1411, xy = "stond in HandyNotes" },
	ormak = { npc = "Ormak Grimshot", id = 3352, m = 1454, xy = "stond in HandyNotes" },
	yaw = { npc = "Yaw Sharpmane", id = 3065, m = 1412, xy = "stond in HandyNotes" },
	holt = { npc = "Holt Thunderhorn", id = 3039, m = 1456, xy = "stond in HandyNotes" },
	quelana = { npc = "Quel'ana Quickgale", id = 252389, m = 2521, xy = "stond in HandyNotes" },
	queldora = { npc = "Quel'dora Quickgale", id = 254411, m = 2521, xy = "stond in HandyNotes" },
	dorion = { npc = "Dorion", id = 4205, m = 1457, xy = "stond in HandyNotes" },
	olmin = { npc = "Olmin Burningbeard", id = 5116, m = 1455, xy = "stond in HandyNotes" },
	ulfir = { npc = "Ulfir Ironbeard", id = 5516, m = 1453, xy = "stond in HandyNotes" },
	ogtinc = { npc = "Ogtinc", id = 8405, m = 1447, x = 42.40, y = 42.62 },
	-- Where to tame (no NPC), Zygor. Azshara = UiMap 1447 (DB2).
	webwood = { m = 1438, x = 59.81, y = 59.06 },
	nightsaber = { m = 1438, x = 55.95, y = 71.98 },
	screecher = { m = 1438, x = 43.99, y = 51.16 },
	cragboar = { m = 1426, x = 48.26, y = 56.81 },
	snowleopard = { m = 1426, x = 48.68, y = 58.93 },
	iceclaw = { m = 1426, x = 49.06, y = 62.12 },
	rockhide = { m = 1429, x = 46.04, y = 77.92 },
	graywolf = { m = 1429, x = 65.73, y = 63.52 },
	forestbear = { m = 1429, x = 46.92, y = 78.34 },
	direboar = { m = 1411, x = 51.84, y = 47.23 },
	surfcrawler = { m = 1411, x = 59.01, y = 27.64 },
	scorpid = { m = 1411, x = 45.21, y = 45.77 },
	plainstrider = { m = 1412, x = 43.58, y = 56.46 },
	stalker = { m = 1412, x = 45.81, y = 54.16 },
	swoop = { m = 1412, x = 45.81, y = 54.16 },
	windsong = { m = 2521, x = 53.72, y = 77.80 },
	galestrider = { m = 2521, x = 57.30, y = 71.27 },
	vuldren = { m = 2521, x = 56.63, y = 67.74 },
	coursers = { m = 1447, x = 49.47, y = 17.62 },
	wavethrashers = { m = 1447, x = 52.61, y = 41.87 },
}
local H = HU_P

-- Three times Taming the Beast at one trainer: the Taming Rod is in your bags, objective 1 = tame the beast.
-- t = { { quest id, place, textKey }, ... }
local function HuTame(faction, races, trainer, t)
	local quests = {}
	for i, s in ipairs(t) do
		quests[i] = { q = s[1], from = trainer, objs = { O(s[2], s[3], 1) }, to = trainer }
	end
	return { key = "tame", spell = 1515, level = 10, faction = faction, races = races, quests = quests }
end
-- Training the Beast: opens after the third taming quest (Spoken prev, GEMETEN).
local function HuTrain(faction, races, q, needs, trainer, petTrainer)
	return { key = "training", spell = 5149, level = 10, needs = needs, faction = faction, races = races,
		quests = { { q = q, from = trainer, to = petTrainer } } }
end
-- The Hunter's Charm (level 50): an item chain. Any of the five trainers gives 8151 (Spoken).
local function HuCharm(faction, races, trainer)
	return { key = "charm", nameKey = "FCQ_CHAIN_HU_CHARM", level = 50, faction = faction, races = races, quests = {
		{ q = 8151, from = trainer, to = H.ogtinc },
		{ q = 8153, from = H.ogtinc, objs = { O(H.coursers, "FCQ_OBJ_HU_ANTLERS", 1) }, to = H.ogtinc },
		{ q = 8231, from = H.ogtinc, objs = { O(H.wavethrashers, "FCQ_OBJ_HU_SCALES", 1) }, to = H.ogtinc },
		{ q = 8232, from = H.ogtinc, objs = { O(P.sunken, "FCQ_OBJ_HU_MORPHAZ", 1) }, to = H.ogtinc },
	} }
end

CHAINS.HUNTER = {
	HuTame("Alliance", NELF, H.dazalar, {
		{ 6063, H.webwood, "FCQ_OBJ_HU_WEBWOOD" },
		{ 6101, H.nightsaber, "FCQ_OBJ_HU_NIGHTSABER" },
		{ 6102, H.screecher, "FCQ_OBJ_HU_SCREECHER" },
	}),
	HuTrain("Alliance", NELF, 6103, 6102, H.dazalar, H.jocaste),
	-- DWGN: there is no Gnome hunter (CharBaseInfo), so the extra race does nothing.
	HuTame("Alliance", DWGN, H.grif, {
		{ 6064, H.cragboar, "FCQ_OBJ_HU_CRAGBOAR" },
		{ 6084, H.snowleopard, "FCQ_OBJ_HU_SNOWLEOPARD" },
		{ 6085, H.iceclaw, "FCQ_OBJ_HU_ICECLAW" },
	}),
	HuTrain("Alliance", DWGN, 6086, 6085, H.grif, H.belia),
	-- Human: NEW in Forever. Wowhead shows Taming Lesson / Training Lesson; the same spells AFGELEID.
	HuTame("Alliance", HUM, H.josephine, {
		{ 94792, H.rockhide, "FCQ_OBJ_HU_ROCKHIDE" },
		{ 94863, H.graywolf, "FCQ_OBJ_HU_GRAYWOLF" },
		{ 94864, H.forestbear, "FCQ_OBJ_HU_FORESTBEAR" },
	}),
	HuTrain("Alliance", HUM, 94793, 94864, H.josephine, H.isaac),
	-- Orc/Troll: mind the order 6062, 6083, 6082.
	HuTame("Horde", ORCTROLL, H.thotar, {
		{ 6062, H.direboar, "FCQ_OBJ_HU_DIREBOAR" },
		{ 6083, H.surfcrawler, "FCQ_OBJ_HU_SURFCRAWLER" },
		{ 6082, H.scorpid, "FCQ_OBJ_HU_SCORPID" },
	}),
	HuTrain("Horde", ORCTROLL, 6081, 6082, H.thotar, H.ormak),
	HuTame("Horde", TAUREN, H.yaw, {
		{ 6061, H.plainstrider, "FCQ_OBJ_HU_PLAINSTRIDER" },
		{ 6087, H.stalker, "FCQ_OBJ_HU_STALKER" },
		{ 6088, H.swoop, "FCQ_OBJ_HU_SWOOP" },
	}),
	HuTrain("Horde", TAUREN, 6089, 6088, H.yaw, H.holt),
}
for _, faction in ipairs({ "Alliance", "Horde" }) do
	-- Skyborne: NEW in Forever, the same quests for both factions (Zephras Isle).
	table.insert(CHAINS.HUNTER, HuTame(faction, SKYBORNE, H.quelana, {
		{ 94978, H.windsong, "FCQ_OBJ_HU_WINDSONG" },
		{ 94979, H.galestrider, "FCQ_OBJ_HU_GALESTRIDER" },
		{ 94013, H.vuldren, "FCQ_OBJ_HU_VULDREN" },
	}))
	table.insert(CHAINS.HUNTER, HuTrain(faction, SKYBORNE, 94050, 94013, H.quelana, H.queldora))
end
-- Level 50: which trainer per race is a choice (AFGELEID); Zygor sends every Alliance hunter to Dorion, every Horde
-- hunter to Ormak. Simpler: two calls without races, HuCharm("Alliance", nil, H.dorion) and HuCharm("Horde", nil, H.ormak).
for _, c in ipairs({
	{ "Alliance", HUM, H.ulfir }, { "Alliance", DWGN, H.olmin }, { "Alliance", NELF, H.dorion }, { "Alliance", SKYBORNE, H.ulfir },
	{ "Horde", ORCTROLL, H.ormak }, { "Horde", TAUREN, H.holt }, { "Horde", SKYBORNE, H.ormak },
}) do
	table.insert(CHAINS.HUNTER, HuCharm(c[1], c[2], c[3]))
end
```

Regels voor `NPC_NAMES` (zelfde vorm als de bestaande):

```lua
	-- Hunter (17 Nov 2026, mh-research: Wowhead Forever tooltips per locale; control npc 233; Spoken agreed where it had a name).
	-- 3065 esES: Spoken says "Guin Crinafilada", Wowhead kept. 8405 esMX: not on Wowhead, left out.
	[3601] = { deDE = "Dazalar", frFR = "Dazalar", esES = "Dazalar", esMX = "Dazalar", ptBR = "Dazalar", ruRU = "Дазалар" },
	[4146] = { deDE = "Jocaste", frFR = "Jocaste", esES = "Jocaste", esMX = "Jocaste", ptBR = "Jocasta", ruRU = "Иокаста" },
	[1231] = { deDE = "Grif Wildheart", frFR = "Grif Wildheart", esES = "Grif Corazón Salvaje", esMX = "Grif Corazón Salvaje", ptBR = "Grif Selvacuore", ruRU = "Гриф Дикое Сердце" },
	[10090] = { deDE = "Belia Thundergranite", frFR = "Belia Thundergranite", esES = "Belia Tronagranito", esMX = "Belia Tronagranito", ptBR = "Bélia Granitrondo", ruRU = "Белия Громовой Гранит" },
	[3171] = { deDE = "Thotar", frFR = "Thotar", esES = "Thotar", esMX = "Thotar", ptBR = "Thotar", ruRU = "Тотар" },
	[3352] = { deDE = "Ormak Grimshot", frFR = "Ormak Grimshot", esES = "Ormak Tirosiniestro", esMX = "Ormak Tirosiniestro", ptBR = "Ormak Tiroatroz", ruRU = "Ормак Лютострел" },
	[3065] = { deDE = "Yaw Sharpmane", frFR = "Yaw Sharpmane", esES = "Yaw Crinafilada", esMX = "Yaw Crinafilada", ptBR = "Yaw Crina Cortante", ruRU = "Йо Колкая Грива" },
	[3039] = { deDE = "Holt Thunderhorn", frFR = "Holt Thunderhorn", esES = "Holt Tronacuerno", esMX = "Holt Tronacuerno", ptBR = "Holto Chifre Troante", ruRU = "Холь Громовой Рог" },
	[251507] = { deDE = "Josephine Carson", frFR = "Joséphine Carson", esES = "Josephine Carson", esMX = "Josephine Carson", ptBR = "Josefina Carsom", ruRU = "Жозефина Карсон" },
	[258930] = { deDE = "Isaac Chan", frFR = "Isaac Chan", esES = "Isaac Chan", esMX = "Isaac Chan", ptBR = "Isaac Chan", ruRU = "Исаак Чан" },
	[252389] = { deDE = "Quel'ana Quickgale", frFR = "Quel'ana Vent-Vif", esES = "Quel'ana Prestovendaval", esMX = "Quel'ana Ventarrápido", ptBR = "Quel'ana Ventiágil", ruRU = "Кве'лана Быстрый Порыв" },
	[254411] = { deDE = "Quel'dora Quickgale", frFR = "Quel'dora Vent-Vif", esES = "Quel'dora Prestovendaval", esMX = "Quel'dora Ventarrápido", ptBR = "Quel'dora Ventiágil", ruRU = "Кель'дора Стремительный Шторм" },
	[4205] = { deDE = "Dorion", frFR = "Dorion", esES = "Dorion", esMX = "Dorion", ptBR = "Dorion", ruRU = "Дорион" },
	[5116] = { deDE = "Olmin Burningbeard", frFR = "Olmin Burningbeard", esES = "Olmin Barbanllamas", esMX = "Olmin Barbardiente", ptBR = "Olmin Barbardente", ruRU = "Олмин Пламебород" },
	[5516] = { deDE = "Ulfir Ironbeard", frFR = "Ulfir Ironbeard", esES = "Ulfir Barbaférrea", esMX = "Ulfir Barbaférrea", ptBR = "Ulfir Barbaférrea", ruRU = "Ульфир Железнобород" },
	[8405] = { deDE = "Ogtinc", frFR = "Ogtinc", esES = "Ogtinc", ptBR = "Ogtinc", ruRU = "Огтинк" },
```

## 11. Teksten (voorstel enUS, stijl van de bestaande `FCQ_OBJ_*`)

| Sleutel | Voorstel enUS |
|---|---|
| FCQ_OBJ_HU_WEBWOOD | use the Taming Rod from your bags on a Webwood Lurker and stay close until it is tamed |
| FCQ_OBJ_HU_NIGHTSABER | use the Taming Rod from your bags on a Nightsaber Stalker and stay close until it is tamed |
| FCQ_OBJ_HU_SCREECHER | use the Taming Rod from your bags on a Strigid Screecher and stay close until it is tamed |
| FCQ_OBJ_HU_CRAGBOAR | … on a Large Crag Boar … |
| FCQ_OBJ_HU_SNOWLEOPARD | … on a Snow Leopard … |
| FCQ_OBJ_HU_ICECLAW | … on an Ice Claw Bear … |
| FCQ_OBJ_HU_ROCKHIDE | … on a Rockhide Boar … |
| FCQ_OBJ_HU_GRAYWOLF | … on a Gray Forest Wolf … |
| FCQ_OBJ_HU_FORESTBEAR | … on a Young Forest Bear … |
| FCQ_OBJ_HU_DIREBOAR | … on a Dire Mottled Boar … |
| FCQ_OBJ_HU_SURFCRAWLER | … on a Surf Crawler … |
| FCQ_OBJ_HU_SCORPID | … on an Armored Scorpid … |
| FCQ_OBJ_HU_PLAINSTRIDER | … on an Adult Plainstrider … |
| FCQ_OBJ_HU_STALKER | … on a Prairie Stalker … |
| FCQ_OBJ_HU_SWOOP | … on a Swoop … |
| FCQ_OBJ_HU_WINDSONG | … on a Windsong Crawler (a crab, near water) … |
| FCQ_OBJ_HU_GALESTRIDER | … on an Ornery Galestrider (a big walking bird) … |
| FCQ_OBJ_HU_VULDREN | … on a Vuldren Alpha (a winged fox) … |
| FCQ_OBJ_HU_ANTLERS | defeat Mosshoof Coursers for 2 Perfect Courser Antlers |
| FCQ_OBJ_HU_SCALES | defeat Wavethrashers in the water for 6 Wavethrasher Scales |
| FCQ_OBJ_HU_MORPHAZ | in the dungeon Sunken Temple (you need a group), defeat Morphaz for the Tooth of Morphaz |
| FCQ_CHAIN_HU_CHARM | The Hunter's Charm quests (Devilsaur trinkets and a spear) |

Achttien bijna gelijke teksten: één tekst met `%s` voor het beest kan ook, maar `O()` kent nu geen argument. Keuze van de bouwchat.
Handig voor de speler (Zygor-tips + IV): het vorige quest-beest eerst wegsturen ("Dismiss your pet first"), en het beest
valt aan terwijl je temt. De hints "a crab", "a big walking bird", "a winged fox" komen uit Zygor Z-C r.1183, 1208, 1221.

## 12. Open / niet gemeten

1. Niets is in het spel gezien: quest-id's, objective-index, coördinaten en of `IsPlayerSpell(1515)` / `(5149)` "bekend" zegt. `/mh classquest` moet het tonen.
2. Dat de derde *Taming the Beast* spell 1579 gebruikt en *Training the Beast* spell 5300: AFGELEID. Het kan zijn dat Feed Pet / Revive Pet al eerder komen.
3. Human: wat Taming Lesson 23356 en Training Lesson 23357 precies leren (dummy-spells, server). AFGELEID: dezelfde zes.
4. Human-keten: mag een Dwarf, Night Elf of Alliance-Skyborne hem ook doen (Spoken-masker zegt ja)? Sluiten routes elkaar uit? Niet gemeten.
5. Of *The Hunter's Path* / 94007 echt vrijwillig is. AFGELEID uit Zygor en IV.
6. Npc-id van **Vuldren Alpha**: niet gevonden (Wowhead-zoekpagina geeft via WebFetch niets terug; dat bewijst niets). Plek alleen uit Zygor.
7. Dire Mottled Boar: Zygors plek (51.84, 47.23) heeft geen Wowhead-spawn binnen 5; Wowhead hangt het beest aan zone 1637. Zygors twee gidsen zijn het wel eens.
8. Level 50- en level 60-keten: bestaan in Wowhead Forever, Zygor Forever en Spoken; IV kon ze in de beta niet bevestigen. Minimumlevel niet op Wowhead gezien.
9. Beloning 8232: alle drie de items of één kiezen (Wowhead toont beide koppen).
10. Level 60: bron van de Mature Blue Dragon Sinew; hoe de drie Ancients verschijnen; of 7633 zichzelf afrondt. En de vorm (item-start) vraagt een keuze.
11. esMX-namen voor 8405, 14524, 14525, 14526; esES-naam van 3065 (twee bronnen, twee namen); beestnamen per taal.
12. Wowheads "Quick Facts" (minimumlevel, kant, start-NPC) niet gelezen: gevers komen uit Spoken en Zygor.
13. Hoe lang het temmen met de rod duurt (IV: 10 seconden). Niet gemeten.
