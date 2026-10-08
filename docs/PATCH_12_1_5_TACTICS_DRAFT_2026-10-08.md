# 12.1.5 tactieken — KLAARSTAAND CONCEPT (8 okt 2026)

> Niets hiervan zit in de addon. Op patchdag (13 okt VS / 14 okt EU) eerst tegen het spel, DBM en BigWigs leggen.
> Geschreven door een onderzoekshelper; geen code of locale aangeraakt, niet gecommit.

## Samenvatting (5 regels)

1. **Kith'ix staat stevig.** Journaal-teksten, ruim 30 spell-ID's en de getallen per moeilijkheid komen uit DB2 70077. **Let op: DBM heeft WÉL een Kith'ix-module.** `DBM-Lairs-Midnight\UnbindingofKithix\Kithix.lua`, revisie 14 sep, lokaal 12.1.12. Hij laadt pas vanaf TOC 120105, dus op live 12.1.0 blijft hij stil. Van zijn 15 spell-ID's kloppen er 14 met DB2; de 15e (1304434) is een losse Fixate, en DBM zet er zelf "verify ID" bij. BigWigs heeft alleen een leeg skelet (16–19 sep).
2. **Kindo'jan: 13 aanvallen met spell-ID en tooltip in DB2.** Wat je ertegen doet (ontwijken, Valeera redden, sigil) staat maar in één gids (Wowhead, 7 okt). DBM, BigWigs en LittleWigs hebben niets voor de Labyrinth. Gecontroleerd op 8 okt op GitHub én lokaal.
3. **Kamers: 23 soorten opdrachten, met tekst uit DB2 (ScenarioStep).** Welke opdracht in welke kamer valt, staat nergens. Van de 11 kamerbazen hebben er 4 een spell met hun naam in DB2 (Grukk, Cynthra, Drill Sergeant, Jo'din). Bij een 5e (Sullied Revenant) past een spell "the revenant", maar die koppeling is AFGELEID. Van de andere 6 kennen we geen aanvallen.
4. **Aqir: alle 8 affixen hebben een DB2-spell en Blizzard-tekst.** Voor 5 affixen is er een concrete tip die MH nog niet geeft. Per scenario is er alleen een titel. Van de eindbaas kennen we geen aanvallen.
5. **Ontbreekt:** alles wat we in het spel zelf zien. Verder: de aanvallen van Den'Zara, de enrage-tijd van Kindo'jan (alleen een gids zegt "10 min"), en wat Valeera zelf doet buiten twee gids-regels. 🔴 Eén conflict met MH: de Headhunters ("kill them fast" tegenover Wowhead "hoeven niet dood"). Zie §1.3.

## Bronnen (met datum)

| code | bron | datum |
|---|---|---|
| **W** | wago.tools DB2, build **12.1.5.70077** (wowxptr, gezien 29 sep, nog de nieuwste 12.1.5-build op 8 okt). Tabellen: Spell, SpellName, SpellEffect, SpellMisc, SpellDuration, JournalEncounterSection, ScenarioStep, Scenario, DungeonEncounter, Difficulty. SpellEffect-rijen met én zonder "Use Hotfixes" vergeleken: gelijk. | gelezen 8 okt 2026 |
| **WH-L** | Wowhead, *The Labyrinth of Kindo'jan Patch 12.1.5 Megadelve Guide* (Sinzhu) | "Updated 2026/10/07" |
| **WH-DB** | Wowhead ptr-2 database (npc 266500, 259664, 267861) | geen paginadatum; gelezen 8 okt |
| **JH** | JudgeHype, *Guide du Labyrinthe de Kindo'Jan* | bijgewerkt 8 okt 2026 |
| **WGE-K / WGE-A** | worstguidesever.com, Kith'ix-gids / Aqir-gids | 4 okt 2026 |
| **BLZ** | Blizzard 12.1.5 Content Update Notes, affixenlijst (mirror warcraft-secrets.com) | 1 okt 2026 |
| **DBM** | lokaal `DBM-Lairs-Midnight` 12.1.12, `Kithix.lua` rev `20260914201948`. GitHub: één commit `cf3ae1760f`, 14 sep 2026. | gelezen 8 okt |
| **BW** | GitHub BigWigsMods/BigWigs `TheUnbindingOfKithix/Kithix.lua` (commits 16–19 sep 2026) | gelezen 8 okt |
| **LW** | GitHub BigWigsMods/LittleWigs master (laatste commit 7 okt 2026) | gelezen 8 okt |
| **MH** | `Locales/Codex.lua` (CODEX_LABYRINTH_BODY, CODEX_KITHIX_BODY), `Locales/enUS.lua:1794` (EVENT_INFO_AQIR_DESC) | gelezen 8 okt |

**Hoe je de labels leest:** "GEMETEN W" betekent dat de DB2-tekst of -waarde het zegt. "GEMETEN WH-L" betekent dat alleen die gids het zegt, zonder bevestiging in DB2. "AFGELEID" betekent dat ik het zelf heb beredeneerd. De tip achter een mechaniek is meestal AFGELEID, ook als de mechaniek zelf GEMETEN is.

### Boss-mods (de beste toets)

- **DBM Kith'ix: bestaat.** `Kithix.lua:1` heeft `if DBM:GetTOC() < 120105 then return end`. Encounter 3513, creature 267861. GEMETEN DBM. Dat spreekt "DBM heeft nog geen module (GEMETEN 8 okt)" tegen. Waarschijnlijk is in het spel gekeken op 12.1.0, waar de module zichzelf uitzet. Dat laatste is AFGELEID.
  - Spell-ID's in DBM: 1304930, 1301511, 1302951, 1304424, 1303681, 1304045, 1304046, 1303406, 1308873, 1318467, 1304040, 1302334, 1304434 ("verify ID"), 1303257, 1301479. 14 daarvan horen in DB2 bij deze baas. 1304434 heeft een algemene Fixate-tekst; het journaal gebruikt `1302295` voor de Bomber Beetle-fixate. GEMETEN W+DBM.
  - Timeline-events (Blizzard EncounterEvent): 838 Unspeakable Horrors, 858 Dark Devastation, 859 Voidswarm, 860 Suffocating Darkness, 861 Extinguish, 862 Twisted Appendage, 903 Null Gate, 951 Divine Radiance, 1002 Negation, 1003 Eightfold Eclipse. 864 = Abyssal Grasp staat alleen in een DBM-opmerking. GEMETEN DBM `Kithix.lua:16,63-86`.
  - ⚠️ Een DBM-slordigheid: `specWarnDivineRadiance` en `timerDivineRadianceCD` gebruiken spell **1303406**. Dat is Abyssal Grasp. Divine Radiance is **1303169**. GEMETEN DBM r31/r40 + W.
- **BigWigs Kith'ix: alleen een skelet.** Encounter 3513, `RegisterEnableMob(259664)`, één placeholder-optie en geen spell-ID's. GEMETEN BW. ⚠️ BigWigs gebruikt NPC **259664**, DBM gebruikt **267861**. Wowhead kent beide als "Kith'ix" (259664 is "toegevoegd in 12.1.0"). Welke de echte baas is, is niet vastgesteld.
- **Labyrinth/Kindo'jan:** geen module. Gekeken op:
  - LittleWigs `Midnight/Delves`: 12 delve-mappen, geen Labyrinth. In de kaartlijst van `Trash.lua` ontbreekt map **3043**.
  - DBM-Dungeons GitHub `DBM-Delves-Midnight/Encounters`: 16 bestanden, geen Kindo'jan. Laatste commit 19 sep.
  - Lokaal grep `Kindo|Labyrinth|3548|1299117`: alleen Shadow Labyrinth (BC). Positieve controle: het patroon vond die BC-treffer wél.
  - Alles GEMETEN 8 okt.
- **Aqir Invasion:** geen module in de lokale DBM, BigWigs of LittleWigs. Positieve controle: `Aqir` vond wel de BfA-modules. BigWigs `MidnightWorld` bevat alleen Cragpine, Luashal en Thormbelan. GEMETEN 8 okt.

---

## 1. The Labyrinth of Kindo'jan

### 1.1 Basis (aanvulling op wat MH al zegt)

- Kindo'jan kun je alleen bevechten vanaf **tier 8**, en pas als je **alle 9 kamers in één run** hebt gehaald. GEMETEN WH-L (7 okt) + JH (8 okt).
- Vóór Kindo'jan komt **Den'Zara**, een Vilebranch-necromancer. Je moet haar eerst stoppen. GEMETEN W (ScenarioStep 3444: "Enemy of the Labyrinth") + WH-L. Haar aanvallen: **onbekend**.
- 🔴 **Ga je de delve uit, dan ben je je gehaalde kamers kwijt.** GEMETEN WH-L + JH. WGE (4 okt) zegt het omgekeerde ("run saves"). Twee recentere bronnen zeggen "kwijt". Op patchdag nakijken.
- Stoppen kan bij Kinduru in een gehaalde kamer, of met de toy Kinduru's Spiriting Quill `1320854`. GEMETEN W (tooltip) + JH.
- **Loa-Spirit Conduits** verschijnen pas vanaf **Labyrinth Journey niveau 6**. Er zijn er 4 per run, één per loa. Elke boon duurt **2 minuten**: gebruik hem dus meteen.
  - Niveau-6-eis: GEMETEN WH-L + JH.
  - 2 minuten: GEMETEN W (SpellDuration 120000 ms).
  - De 4 boons:
    - Wind `1314332`: +25% "combat speed". GEMETEN W.
    - Earth `1314346`: −50% schade. GEMETEN W.
    - Fire `1314350`: elke 2,5 s vuur om je heen. GEMETEN W.
    - Mist `1314353`: gewone vijanden onder 20% gaan meteen dood. GEMETEN W.
  - MH zegt nu alleen "4 conduits, klik voor een boon". Dat klopt, alleen minder precies.
- Er lopen vijanden rond in de gangen, en je trekt makkelijk extra vijanden mee. GEMETEN JH (8 okt).

### 1.2 Kamers — per soort opdracht

Welke opdracht in welke kamer komt, staat niet in DB2 en in geen enkele gids. Overgear (10 sep) noemt alleen "Soul Catcher" in de Nalorakk-kamer. ⚠️ Die gids noemt de kamer "Nalorakk's **Den**", maar DB2 AreaTable 17032 zegt "Nalorakk's **Rest**". GEMETEN W.

De opdrachtteksten zijn allemaal GEMETEN W (ScenarioStep, build 70077). Scenario-ID's staan tussen haakjes. De tip is AFGELEID, tenzij er iets anders staat.

| opdracht | wat er gebeurt (DB2) | wat je doet | gevaar / baas |
|---|---|---|---|
| **Vile Intruders** (3413, 3430, 3510, 3538, 3540–3544) | Vilebranch-trollen vechten, daarna de baas **Sullied Revenant** | Dood de trollen, dan de baas | Mogelijk *Necrotic Anguish* `1299467`/`1299466`: "the revenant" slokt genezing op en doet Shadow-schade zolang het blijft hangen → loop eruit. De koppeling aan Sullied Revenant is AFGELEID (ID ligt tussen de Labyrinth-spells). |
| **Graverobbers** (3468, 3511, 3546–3552) | Relic Raiders plunderen; daarna hun leider | Dood de plunderaars, dan de leider | Wie de leider is, is onbekend. Treasure Hunter Taltrois (encounter 3642)? AFGELEID, niet gemeten. |
| **Taken Antiquities** (3402, 3615, 3617–3623) | Zoek gestolen artefacten en breng ze terug. Daarna komt **Sha'Kuro**, **Cynthra Buttonsmasher**, **Sullied Revenant** of **Jun'ala** | Spullen terugbrengen, dan de baas | **Cynthra**: *Mine Go Boom* `1317950` (+ *Mine All Mines* `1317928/1317935/1317937`). Mijnen ontploffen als je ze aanraakt en duwen je weg → **raak de mijnen niet aan**. Mechaniek GEMETEN W, tip AFGELEID. Jun'ala en Sha'Kuro: geen spells bekend. |
| **Reliquary Ritual** (3349) | Breek de besmette Spirit Reliquaries; overleef de ondoden van **Sha'Kuro**; "versla hem terwijl hij nog verzwakt is" | Eerst de reliquaries, dan snel en hard op Sha'Kuro | Te traag = hij is niet meer verzwakt. AFGELEID uit de tekst. |
| **Spirit Thieves** (3345) | Stop de rituelen; draag de Spirit Reliquaries naar de open sarcofagen | Draag en loop; vechten is bijzaak | — |
| **Restless Dead** (3426) / **A Foul Presence** (3699) | Gebonden zielen en relieken; daarna "Confront the Necromancer!" / zoek aanwijzingen, bekijk de effigy | Relieken terugbrengen of aanwijzingen zoeken, dan de necromancer | *Necromantic Interrogation* `1300856` ("use the mask to interrogate a dead hex master") hoort er vermoedelijk bij. AFGELEID. **Shadowhunter Jo'din** (3646) is misschien deze necromancer (AFGELEID). Zijn *Soul Shatter* `1317484`: 3 stapels schade, en elke stapel maakt een zielsscherf → **raap de scherven op**, elke scherf haalt een stapel weg. GEMETEN W. |
| **Soul Catcher** (3409, 3674, 3679) | Verdrijf de verloren zielen → barrière omlaag; dood **Malakk**, dan de **Vile Wraith** | Zielen eerst, dan de twee bazen | Geen spells bekend. |
| **Soul Survivor** (3484, 3580–3589) | Versla de Hexbound Defenders, dan de **King of Souls** (3648) | Verdedigers eerst | Geen spells bekend. |
| **Malicious Masks** (3464, 3470–3482) | Reinig de besmette maskers; daarna **Grukk** (3636) | Maskers, dan Grukk | *Chaotic Impact* `1315287` (+ *Chaotic Frenzy* `1315278/1315279/1315293`): Grukk springt rond en raakt iedereen bij zijn landingsplek → **ga weg waar hij landt**. GEMETEN W, tip AFGELEID. |
| **Raging Spirits** (3605–3613) | Kalmeer woedende geesten; daarna "het oordeel van de geesten" | Geesten kalmeren | "Oordeel" → misschien **The Undead Trollbunal** (3632). AFGELEID, niet gemeten. |
| **Ritual Ruination** (3504) | Onderbreek het ritueel; daarna **Spirit of Retribution** en **Riv'iki** | Onderbreken (interrupt) | Geen spells bekend. |
| **Setting Things Right** (3512, 3663, 3664) | Help de Ancestral Shaman zijn ritueel opnieuw te starten en bescherm hem; daarna **Enraged Death Steward** en **Enraged Ancestral Shaman** | Shaman beschermen, dan twee bazen | Geen spells bekend. |
| **Containment Breach** (3524) | Dood de cultisten die de vuren van Jan'alai doven; steek ze weer aan met **Jan'alai Tears**; dan de **Prisoner** | Vuren aansteken, dan de gevangene | Dat dit in Jan'alai's Refuge is, is AFGELEID uit de naam. |
| **Bear's Burden** (3403) | Steek de wierook aan; draag Nalorakks last door de Gates of Trial naar zijn sokkel; vecht dan met "Nalorakk's champion" | Dragen, dan vechten | *Lighting Incense* `1300835` hoort er vermoedelijk bij. AFGELEID. Of de champion **Drill Sergeant** (3622) is, is onbekend. Drill Sergeant (GEMETEN W): *Glitching Shield* `1312409` (minder schade; "botsen met grote objecten kan het schild breken"), *Overcharge Engine* `1312418` + *Engine Fire* `1312420` (vuur om hem heen → **afstand**), *Seismic Detonation* `1312423`/`1313027` (ontploffing + rotsen die wegduwen → **wegstappen**). |
| **Encroaching Darkness** (3483, 3658, 3659) | Stemmen in de gangen; zoek een licht; verdrijf de duisternis; dood de Rage Specters | Fakkel pakken, duisternis wegbranden | *Lit Torch* `1299520` ("pick up the torch") en *Cave Light* `1301271/1301279` horen er vermoedelijk bij. AFGELEID. |
| **Fools and Curses** (3537, 3554–3561) | Relic Raiders openden een vervloekte sarcofaag; zoek de vervloekte raiders en breng de Cursed Energy terug | Raiders zoeken, energie terugbrengen | DNT-spells *Cursed Sarcophagus Aura* `1309087` en *Curse Energy Deposit* `1309095`. Koppeling AFGELEID. |
| **Reins of the Warlord** (3562, 3570–3577) | Praat met Warlord Kaz'kara; verstoor de raptorbotten en tem de geest van Daakajin | Praten, dan temmen | — |
| **Returning the Bounty** (3442, 3446, 3666) | Hamsterende "hoarder weeds"; als hun wortel bloot ligt, kun je ze opruimen | Hakken, dan de wortel | — |
| **A Golden Opportunity** (3443, 3447) | Trek aan de Golden Lever; raap zoveel mogelijk schat vóór de tijd op is | Snel rapen | Geen gevecht genoemd. |
| **The Wandering** (3628, 3719, 3720) | Blijf dicht bij een verdwaalde geest; daarna trekt hij vijanden en "voedt zich met jou" voor zijn schild; breng hem naar zijn vat | Dichtbij blijven, beschermen | De geest vreet aan jou → let op je leven. AFGELEID uit de tekst. |
| **Choose Your Path** (3342) / **Empty Halls** (3721) | Kies de volgende kamer of praat met Kinduru / alles gehaald | — | — |
| **Heart / Enemy / Soul of the Labyrinth** (3444, 3678) | De Empire's Rest → Den'Zara → Kindo'jan | Zie §1.3 | — |

Bazen volgens DB2 DungeonEncounter, map 3043 (GEMETEN W, 8 okt):
- Jun'ala 3526
- Sullied Revenant 3527
- Sha'Kuro 3528
- **Kindo'jan 3548**
- Den'Zara 3556
- Drill Sergeant 3622
- The Undead Trollbunal 3632
- Grukk 3636
- Treasure Hunter Taltrois 3642
- Shadowhunter Jo'din 3646
- King of Souls 3648
- Cynthra Buttonsmasher 3653

Kamerbeschrijvingen volgens WH-L (7 okt):
- Chamber of Rites = ingang.
- Reliquary of Catacombs = altijd je tweede keus.
- Central Chamber = verbindt bijna alles; plunderaars of geesten.
- Catacombs = de doden blijven niet dood.
- Halazzi's Lair = rituelen.
- Jan'alai's Refuge = vechten + bewegen.
- Nalorakk's Rest = necromancers.
- Cave Towers = proeven.
- Akil'zon's Roost = ingang naar de Speaker's Chamber met Kindo'jan.

### 1.3 Kindo'jan — alle aanvallen

Volgorde volgens WH-L (7 okt): eerst **90 s zijn eigen aanvallen**. Dan trekt hij zich terug en roept hij vier loa-sprekers op, kort na elkaar. Daarna komen beide soorten **door elkaar**, soms tegelijk. Hij teleporteert af en toe over het platform. **Enrage na ruim 10 min** (alleen WH-L, niet in DB2 gevonden).

🔴 **De echte vijand is Disgraceful Display** `1303494`.
- Elke treffer van een ontwijkbare aanval geeft je een stapel. **Bij 3 stapels ben je dood**, ook als tank.
- De stapels blijven **5 minuten**.
- Tekst + 3 stapels: GEMETEN W. 5 min: GEMETEN W (SpellDuration 300000 ms). "Ontwijkbare treffers": GEMETEN WH-L.
- MH zegt dit al ("at 3 stacks the loa find you unworthy"). Dat klopt.

**Zijn eigen aanvallen**

- **Eruption of Mojo** `1300491` (ook `1298635`, `1298637`, `1300479`, `1300480`, `1301288`, `1301294`, `1301303`).
  - Cirkels ontploffen en gooien je weg. Eén variant houdt je **4 s vast** (`1298637`).
  - `1301288` heeft de aura "Targeted by Kindo'jan".
  - Alles hierboven: GEMETEN W.
  - Tip: **loop uit de cirkels.** GEMETEN WH-L.
- **Erratic Mojo** `1300767`: elke Eruption laat een plas achter waar je stond. Daarin verlies je **33% van je leven per 1,5 s**. GEMETEN W (SpellEffect).
  - Tip: **leg plassen aan de rand en blijf er nooit in staan.** WH-L zegt "use the space, don't linger". De rand-tip zelf is AFGELEID.
- **Hash'ey's Command** `1298647` (ook `1298656`): roept **4 Amani Headhunters** op voor 5 min. GEMETEN W.
  - Hun *Axe Barrage* `1298765` werpt rijen bijlen. GEMETEN W.
  - 🔴 **Conflict met MH.** MH zegt "kill them fast". WH-L (7 okt) zegt: ze **hoeven niet dood**, en een treffer van Axe Barrage telt **niet** mee voor Disgraceful Display.
  - Mijn voorstel, AFGELEID: "Ontwijk hun bijlen; dood ze als dat makkelijk gaat." Dat beslis jij, Rob. Niet tegenspreken zonder test.
- **Whirling Axes** `1301203` (tekst in `1300768`): vier kringen spookbijlen gaan in een boog over het platform en komen terug. Wie geraakt wordt, verliest **66% leven per 0,5 s**. GEMETEN W. Er zit ook een vertraging in, waarde 33. Hoeveel trager je echt loopt, heb ik niet uitgezocht.
  - Tip: **ontwijken.** GEMETEN WH-L.
- **Crushing Blow** `1299117` (ook `1299144`): slag op de grond plus een **Amani Juggernaut** voor 5 min. GEMETEN W. WH-L: de slag raakt dicht bij de baas en de Juggernaut verschijnt midden op het platform.
  - Juggernaut, *Phalanx Charge* `1298834` (ook `1298842/1298973/1300466`): stormt op je af en duwt je weg. GEMETEN W.
  - Juggernaut, *Amani Aegis* `1301380` (ook `1301376/1301394`): schild, bondgenoten dichtbij krijgen minder schade. GEMETEN W.
  - WH-L: niet te stunnen of te CC'en, en **hoogste prioriteit**.
  - MH zegt "step out of the impact; an Amani Juggernaut appears". Dat klopt.

**Loa-sprekers** (Kindo'jan gebruikt hun krachten later zelf)

- **De Rising Storm** `1300374` (ook `1304644`; storm = *Furious Gale* `1299561`).
  - Spreker Ahn'Joli (npc 269447, WH-DB). Een beeld van Akil'zon blaast windstoten die je wegduwen. GEMETEN W.
  - Tip: **ga in de kleine veilige plekken staan.** GEMETEN WH-L.
- **Gambit in de Shadows** `1304837` (ook `1304638`; basis *Predator's Guile* `1300206`).
  - Spreker Zen'Toka (npc 269444, WH-DB). Het doel wordt **verdoofd**. Er verschijnen **1 echte en 3 nep-Shadows of Halazzi** (npc 268152). Na **6 s** springt de echte. Raakt hij eerst iemand anders, dan krijgt die de schade. Raakt hij het doel, dan is dat **dodelijk**. GEMETEN W.
  - WH-L: het doel is **Valeera**. Ga in de baan van de echte Shadow staan: dat is de Shadow waar de cirkel onder vastzit.
- **Ursine Rampage** `1304641` (ook `1300045`, `1299828`, `1299955`, `1299959`, `1300769`).
  - Spreker Bindu (npc 269445, WH-DB). Meerdere Furies of Nalorakk stormen vooruit en duwen weg. GEMETEN W.
  - Tip: **zoek het gat tussen de beren**, anders vlieg je van het platform. GEMETEN WH-L.
- **Cleansing Flame** `1299201` (ook `1304640`; tekst `1299249`).
  - Spreker Rotahn (npc 269449, WH-DB). Vlammen van Jan'alai raken wie dichtbij staat. **Staat er niemand bij, dan ontploffen ze over het hele platform.** GEMETEN W.
  - WH-L: er komen **twee sigils**; sta erin als ze aflopen. **Valeera pingt welke zij neemt.**
  - Tip: **neem jij de andere.** AFGELEID.
  - WH-L: als Kindo'jan dit later zelf doet, komt er ook een Juggernaut met Phalanx Charge. Na de knockback heb je maar even om je sigil te halen.

**Solo-advies (met Valeera).** Alles AFGELEID uit het bovenstaande.

1. Speel rustig. Elke vermeden treffer is winst; drie fouten in 5 min = dood.
2. Plassen aan de rand, nooit erin blijven staan.
3. Juggernaut eerst; Headhunters alleen als het makkelijk gaat (zie het conflict hierboven).
4. Bij Gambit: jij staat in de baan van de echte Shadow, anders valt Valeera weg.
5. Bij Cleansing Flame: Valeera pingt haar sigil, jij neemt de andere.
6. Neem de conduits en Hexmasks onderweg mee. JH en WH-L raden dat aan vóór Kindo'jan.

**Groepsadvies.** AFGELEID, niet getest.

- Disgraceful Display staat op "you": vermoedelijk telt het **per speler**.
- Cleansing Flame: elke sigil heeft minstens één speler nodig.
- Gambit kiest volgens DB2 "an enemy". In een groep is dat misschien een speler in plaats van Valeera: **onbekend**.
- Headhunters: met AoE meenemen.
- Amani Aegis is volgens WH-L een *cast*. Of je hem kunt onderbreken, is **niet gemeten**.

### 1.4 Wat Valeera daar doet

- Bij Gambit in de Shadows is zij het doelwit. Ze wordt verdoofd en jij moet de echte Shadow opvangen. GEMETEN WH-L. Het mechaniek zelf: GEMETEN W (`1300206`).
- Bij Cleansing Flame pingt ze welke sigil zij neemt. GEMETEN WH-L.
- Het handschoen-enchant *Eye of the Lynx* (Halazzi-zegel, journey 9) kan ook Valeera Haste + Leech geven. GEMETEN WH-L + JH.
- Kinduru en het Amani-masker kunnen je beschermen: *Kinduru* `1284399`, minder schade + leech. Wanneer dat gebeurt, is onbekend. GEMETEN W (tooltip).
- In DB2 staat **niets Labyrinth-specifieks voor Valeera**. Gezocht in Spell-teksten met "Valeera": 58 treffers, alleen haar gewone delve-spells (Rupture, Fan of Knives, enz.). Die vondsten zijn meteen de positieve controle. GEMETEN W.

---

## 2. The Unbinding of Kith'ix

**ID's:** JournalInstance 1324, JournalEncounter 2896, DungeonEncounter 3513, map 3095. GEMETEN W. Op Mythic is het **15–25 spelers** ("Mythic - Flexible Raiding", difficulty 233). GEMETEN W.

De journaal-teksten zijn GEMETEN W (JournalEncounterSection 35706–37530). Tooltips en getallen zijn GEMETEN W (Spell, SpellEffect, SpellDuration).

### Fase 1 — Darkness' Domain

- **Voidswarm** `1301511`: portalen gedurende 6 s, raid-schade en aqir-adds.
  - Adds: Venomous Hulk (*Venom Roar* `1302884`, een frontale kegel met knockback), Voidweaver (*Voidweave* `1302333`/`1302334` op willekeurige spelers, *Nightfall* `1302705` op iedereen, stapelt) en Bomber Beetle.
- **Suffocating Darkness** `1302951` (op 100 energie): de duisternis sluit zich om de raid.
  - Wie erin staat krijgt *Suffocation* `1303257`: kan niet aanvallen ("pacify"), loopt 30% trager en krijgt schade.
  - Aqir die nog leven krijgen *Dark Frenzy* `1303260`: +100% aanvals- en loopsnelheid, immuun voor CC, en raid-schade.
  - → **Adds dood vóór 100 energie; sta in Liadrins Refulgent Bulwark `1302952`.** Dit zegt MH al, en het klopt.
- **Divine Radiance** `1303169`: Liadrin verbrandt de duisternis en **verdooft Kith'ix 8 s**. Dat is je burst-moment (AFGELEID).
  - Daarna krijgt Liadrin **Exhausted** `1307662`: Bulwark en Light's Embrace worden zwakker, en Suffocating Darkness doet **+10% per stapel**. → Hoe langer fase 1 duurt, hoe zwaarder het wordt.
- **Extinguish** `1304424`: schokgolf over de hele raid; haalt Light's Embrace weg.
  - **Light's Embrace** `1304508`/`1304526`: −90% Shadow-schade, 8 s (op Mythic −80%).
  - → **Pak vóór elke Extinguish een lichtbolletje.** Dit zegt MH al.
- **Abyssal Grasp** `1303406`: een heal-absorb van 9 s (Heroic 8 s). Wie hem dan nog heeft, wordt **de duisternis in getrokken**. Dit zegt MH al.
- **Unspeakable Horrors** `1304045` → **Overwhelming Fear** `1304046`: na 6 s angst. Bij het aflopen of weghalen volgt een gil: **minder schade hoe verder je weg staat.**
  - → **Ga uit elkaar; dispel alleen spelers die al ver weg staan.** Mechaniek GEMETEN W. De dispel-tip komt uit WGE-K (4 okt).
  - ❗ MH zegt dit nog niet.
- **Twisted Appendage** `1303681`: tentakels raken spelers dichtbij. Dit zegt MH al ("dodge").
- **Bomber Beetle**: *Fixate* `1302295` (achtervolgt een speler). *Gut Reaction* `1302117`: ontploft na 30 s of bij aanraking en geeft iedereen *Digestive Juices* `1302319` (stapelt, 4 s).
  - → **Laat ze niet vlak na elkaar ontploffen.** Het journaal zegt zelf dat snel achter elkaar "heavy damage" geeft.
  - ❗ MH zegt dit nog niet.
- **Commanding Presence** `1305008`: aqir dicht bij de baas nemen minder schade. Eieren niet. Dit zegt MH al ("pull the aqir away").
- **Dark Devastation** `1304930` → **Devastated** `1304948`: stapelt, 25 s, meer Physical- en Shadow-schade. → **Tank wissel.** Dit zegt MH al.
- **Heroic + Mythic:**
  - *Incubation* `1307407`: dode aqir laten **Mindstingers** los. Die verdoven een speler met *Mindsting* `1304040` (5 s).
  - Dark Devastation laat een **Voidscar** `1304950` achter: schade + knockback bij aanraking.
  - Tijdens Suffocating Darkness worden die *Eclipse Fragments* `1308674`. Ze drijven langzaam naar Liadrin. Een speler die er een raakt, krijgt een stapelende DoT. Bereikt een fragment Liadrin, dan volgt *Lost Refulgence* `1308675`: raid-schade, en de **Bulwark krimpt**.
  - → **Vang de fragmenten op vóór ze bij Liadrin zijn; wissel van vanger.** Het mechaniek is GEMETEN W. Het "wisselen" komt uit WGE-K (AFGELEID).
  - ⚠️ WGE-K noemt dit een Mythic-mechaniek. Het journaal (IconFlags 8 = Heroic-icoon) en de tekst "In Heroic and Mythic difficulty, Dark Devastation leaves behind a Voidscar" (sectie 37431) zeggen **Heroic + Mythic**. GEMETEN W.

### Fase 2 — Last Light (op **25%** leven)

- **Stygian Howl** `1301110` (triggert op 25%: `1301108`): de hele raid verdooft. Kith'ix slokt zijn eigen adds op en begint **Eightfold Eclipse** `1301479`.
  - De eclipsen doen raid-schade. Na de laatste gaan ze naar Liadrin en **is iedereen dood**. → Het is een race.
- **Last Light** `1305427` (Liadrin): heelt iedereen vol en geeft **Luminous Grace** `1305428` tot het eind: meer schade en genezing.
  - → **Bloodlust en alle cooldowns hier.** Burst-moment AFGELEID; Lust staat in WGE-K.
  - Dit zegt MH al ("burst window").
- **Null Gate** `1308873`: een speler krijgt 5 s een markering. Daarna gaat er een poort open op zijn plek: schade + **Nullify** `1308875` voor wie dichtbij staat.
  - → **Gemarkeerd: ga weg van de anderen.** Mechaniek GEMETEN W. De tip is AFGELEID; WGE-K zegt hetzelfde.
- **Nullshards** `1308881`: scherven uit de poorten. Aanraken = Nullify.
  - **Nullify doodt bij een aantal stapels:** LFR 8, Normal 6, Heroic 5, **Mythic 3**, Story 20. GEMETEN W (SpellEffect per difficulty).
  - ⚠️ mythic-store.com (8 sep) zegt "4 stacks". Dat klopt met geen enkele DB2-rij.
- **Negation** `1318467` (tank, 8 s; op Mythic 12 s en meerdere stapels): **na afloop sterft de tank.**
  - **Een Null Gate aanraken haalt hem weg.** Dat geeft een ontploffing, *Explosive Restabilization* `1318472`, die poorten en scherven in de buurt opruimt.
  - → **Tank met Negation loopt een Null Gate in; de andere tank taunt.** Mechaniek GEMETEN W. De taunt is AFGELEID; WGE-K zegt hetzelfde.
  - DBM-geluid: "movetogate" (GEMETEN DBM).
  - ❗ MH zegt fase 2 nu alleen "Stygian Howl → Last Light → race". Null Gate en Negation ontbreken nog.

### Getallen per moeilijkheid (GEMETEN W, SpellEffect)

| | LFR (17) | Normal (14) | Heroic (15) | Mythic (233) | Story (220) |
|---|---|---|---|---|---|
| Commanding Presence: schade op aqir | −50% | −75% | −75% | −90% | standaard −75% |
| Nullify: dood bij | 8 | 6 | 5 | 3 | 20 |
| Light's Embrace | −90% | −90% | −90% | −80% | −90% |
| Devastated per stapel | +100% | Shadow +150% | Physical +150% | Shadow +250% | +100% |

- ⚠️ Een cel is alleen GEMETEN als DB2 een **eigen rij** voor die moeilijkheid heeft. Eigen rijen:
  - Commanding Presence: LFR, standaard, Mythic.
  - Nullify: alle vijf.
  - Light's Embrace: standaard en Mythic.
  - Devastated: standaard, Normal, Heroic, Mythic.
  - De andere cellen zijn de standaardwaarde. Dat die gebruikt wordt, is AFGELEID.
- Abyssal Grasp-absorb (de eenheid weet ik niet): LFR 30, standaard 60, Heroic 90, Mythic 110.
- Normal en Heroic hebben bij Devastated **elk maar één eigen rij**: Normal Shadow 150, Heroic Physical 150. Hoe de andere helft terugvalt, weet ik niet. Zeg in de tip dus alleen "veel meer schade".
- WGE-K zegt Commanding Presence "90% op Heroic". DB2 heeft geen Heroic-rij, dus daar geldt de standaardwaarde van 75%. De uitkomst is AFGELEID.

### Per rol (concept bossvenster-tip, kort)

- **Iedereen:**
  - adds dood vóór de duisternis;
  - in de Bulwark staan;
  - lichtbolletje vóór Extinguish;
  - uit elkaar bij angst;
  - weg van anderen als je een Null Gate-markering hebt;
  - scherven ontwijken.
  - Op 25%: alles erin. Na 8 eclipsen is het voorbij.
- **Tank:** wissel na Dark Devastation. Trek de aqir weg van de baas. In fase 2: met Negation een Null Gate in, de ander taunt.
- **Healer:**
  - Abyssal Grasp-absorb meteen weghealen (8–9 s).
  - Cooldowns voor Extinguish en de duisternis. Die wordt elke keer zwaarder (Exhausted +10%).
  - Nooit bombers vlak na elkaar laten knallen.
- **DPS:** adds eerst. Op Heroic/Mythic: fragmenten opvangen vóór Liadrin. Burst in de 8 s stun en bij Luminous Grace.

⚠️ "Onderbreek de Voidweaver" (WGE-K) staat **niet** in het journaal. Voidweave en Nightfall hebben geen interrupt-vlag gekregen (IconFlags 0 en 4). Dus niet in de tip zetten zonder test. AFGELEID uit IconFlags.

---

## 3. Aqir Invasion — alleen wat MH nog niet zegt

MH zegt nu: "Interrupt the Webweaver and kill the Voidweaver first". Dat klopt:
- *Void Protection* `1296408`/`1308126`: de andere aqir worden **immuun voor alle schade**. GEMETEN W.
- *Web Weave* `1307368`: als de channel afloopt, **kan het doel niets meer doen**. GEMETEN W.

Nieuw, per affix. Effect GEMETEN W + BLZ (1 okt); de tip is AFGELEID, tenzij er iets anders staat.

- **Aqir Burrowers** `1308083`: gravende aqir lanceren iedereen die ze raken. → **Blijf uit hun pad.** WGE-A zegt hetzelfde.
- **Void Sphere** `1308085`: rondzwervende bollen beschadigen wie in de buurt blijft. BLZ: "proberen je te vangen". → **Blijf bewegen, weg van de bollen.**
- **Astalor's Anguish** `1308082`; kristallen `1296460`/`1296463`/`1296470`. Als een aqir met een kristal sterft, **trekt het kristal iedereen naar zich toe en ontploft dan**. → **Ren weg na zo'n kill.**
  - *Erratic Anguish* `1305727`: bliksems op inslagplekken → stap opzij.
  - *Astalor's Mark* `1296474` beschermt je een tijdje tegen het trekken. GEMETEN W.
  - Aura-tekst bij `1296460`: "Movement slowed dramatically. **Jump** to clear off the Void." Mogelijk een spring-tip. Context onduidelijk, dus AFGELEID.
- **Void Infestation** `1307016`/`1306869`; stapels `1306868`. Besmette aqir worden sterker, **ontploffen bij 10 stapels**, raken wie dichtbij staat en **besmetten andere aqir**. → **Dood besmette aqir snel, en weg van andere aqir.**
- **Swarms!** `1307010` (veel kleine aqir) → AoE. **Aqir Elites** `1307015` (weinig, sterk) → één doel tegelijk, defensives. Het effect is GEMETEN W; de tip is AFGELEID.
- Scenario-opdrachten volgens DB2 ScenarioStep (GEMETEN W):
  - *Kill Swarms!* "Disrupt the aqir invasion" (3343)
  - *Whack the Aqir* "Eject attacking aqir from the invasion point" (3390)
  - *Aerial Assault* "Defeat attacking aqir aerial forces" (3394)
  - *Reinforce Defenses* "Help defenders prepare for an impending aqir attack" (3397)
  - *Aggressive Expansion* (3355), *Aid Defenders!* (3365), *Aqir Nesting Grounds* (3366) en *Aqir Monstrosity* (3369): **geen tekst**.
- Losse spells die er waarschijnlijk bij horen. De koppeling is AFGELEID:
  - *Aqir Rage* `1286619`: een aqir-ei kapotmaken geeft je meer leven en schade. Nesting Grounds?
  - *Anguish Grenade* `1288878`/`1288881`: je houdt een stuk kristal vast. "Gooi het snel voor het ontploft." GEMETEN W.
- **Eindbaas:** mechanieken **onbekend**. Kandidaten zonder gemeten koppeling:
  - *Swarmstorm* `1309352` ("the Hivekeeper"…)
  - *Call Swarm* `1296473`
  - *Charging Aqir* `1290412`
- Apart, niet de invasion zelf: *Aqir Attack* op Silvermoon (scenario 3361): burgers redden, Lor'themar helpen tegen de Aqir General. GEMETEN W.

---

## 4. Wat MH nu zegt tegenover deze bronnen

| MH-tekst | oordeel |
|---|---|
| Labyrinth: Crushing Blow "step out of the impact; Juggernaut appears" | klopt (W + WH-L) |
| Labyrinth: Hash'ey's Command "kill them fast" | 🔴 **conflict**: WH-L 7 okt zegt "hoeven niet dood". Rob beslist; eerst in het spel zien. |
| Labyrinth: Disgraceful Display, 3 stapels | klopt (W); aanvullen: "5 min" en "elke ontwijkbare treffer" (WH-L) |
| Labyrinth: Conduits "strong boon for the whole group" | klopt (W); aanvullen: 2 min, vanaf journey 6 |
| Kith'ix: alle regels | kloppen met W. Ontbreekt: angst/gil (spreiden), Bomber Beetles, Null Gate/Nullify, Negation→poort, H/M-fragmenten |
| Aqir: Webweaver/Voidweaver | klopt (W); 5 affix-tips ontbreken (§3) |

## 5. Op patchdag nakijken (volgorde)

1. **DBM 12.1.5:** laadt `Kithix.lua`, en welke waarschuwingen geeft hij? Komt er een Labyrinth-module bij (DBM-Delves-Midnight)? En BigWigs/LittleWigs?
2. **Headhunters:** moeten ze dood, of niet?
3. **Gambit in een groep:** wie wordt het doelwit?
4. **Kindo'jan:** enrage-tijd, en de aanvallen van Den'Zara.
5. **Run-progressie** bij het verlaten van de Labyrinth: kwijt of niet?
6. **Eindbaas van de Aqir-invasie:** naam en mechanieken.
7. **Kith'ix-NPC:** is het 259664 of 267861? (Alleen nodig als MH op NPC gaat filteren; encounter 3513 is genoeg.)
