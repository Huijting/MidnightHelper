# Wah'du en Mythical Soul Fragment: onderzoek 14 okt 2026

Build: 12.1.5.70391 (EU-live). Labels: GEMETEN = zelf gezien in een genoemde, gedateerde bron. AFGELEID = mijn redenering.
Bronnen die ik las: wago.tools DB2 (build 70391, met en zonder hotfixes), Wowhead (live + ptr-2), Icy Veins, Method, Wowhead-nieuws, een paar gidssites, en lokale Zygor (ZygorGuidesViewer 9.6).
NIET gelezen: `MidnightHelper/docs/LABYRINTH_QUESTS_2026-10-13.md`. Mijn agentregel verbiedt alles onder `docs/`. Laat dat nalezen door mh-sweep of door de bouwchat zelf (zoek "Wah").

---

## 0. De tekst die Rob zag, komt uit spell 1319741

- GEMETEN (wago Spell, 70391, **met hotfixes**): spell **1319741**. De tekst is precies Robs tooltip. Er staat **"Myth 2/6"**.
- GEMETEN (wago Spell, 70391, **zonder hotfixes**): dezelfde spell zegt **"Myth 1/6"**. Een hotfix heeft dus 1/6 in 2/6 veranderd.
- GEMETEN: het Wah'du-stuk staat achter `$?pc164754[...]`. Je ziet die zin alleen als je aan PlayerCondition 164754 voldoet.
- GEMETEN (wago PlayerCondition 164754): `PrevQuestID_0 = 98834`. Dat is de intro-quest "The Way Forward..." (Zygor-gids, regel 2650). Er hangt ook ModifierTree 466900 aan, met 6 takken. Elke tak noemt één van de 6 Wah'du-quests (98951, 98963, 98962, 98961, 98960, 98959).
- AFGELEID: de zin over Wah'du verschijnt pas na de intro-keten. De 6 takken passen bij "één stap per week". De betekenis van de modifier-types (110 en 289) heb ik niet gecontroleerd.
- AFGELEID: de map-POI is AreaPOI 9035/9037 ("The Labyrinth of Kindo'jan", "Bountiful Delve", UiWidgetSet 2316). Dat de tooltip daar via spell 1319741 binnenkomt, leid ik af uit de tekst. De koppeling heb ik niet in een tabel gezien.

## 1. Wie is Wah'du, waar staat hij, wat betekent "assist"?

**Wie**
- GEMETEN (Wowhead live + ptr-2, 14 okt): NPC **264886 "Wah'du"**, titel **<Servant of de Loa>**, Elite, type Elemental, toegevoegd in 12.1.5. Wowhead zegt: "The location of this NPC is unknown."
- GEMETEN (wago Vignette, 70391): geen vignette met de naam "Wah". Positieve controle in dezelfde zoekronde: "Kinduru" geeft vignettes 8048 en 8065.
- GEMETEN (lokale Zygor): "Wah'du" komt nergens voor. Quest-ID's 98951 tot 98963 komen ook niet voor. Positieve controle: "Kindo'jan" staat wel in Zygor.

**Waar**
- Coördinaten op uiMap 2647: **geen enkele bron geeft ze.** Wowhead niet, Zygor niet, en de gidsen ook niet.
- GEMETEN (Wowhead-nieuws 7 okt 2026, PTR): "at the entrance".
- GEMETEN (wowsaga.com, 9 okt 2026, PTR-video): "Wah'du stands in the Chamber of Rites, south", "the southern entryway".
- GEMETEN (buyboost.com, 7 okt): "near the entrance or within the Chamber of Rites".
- GEMETEN (Icy Veins, 10 okt, bijgewerkt 12 okt): "Wah'du appears weekly in the Labyrinth". Geen plek genoemd.
- Ter oriëntatie, GEMETEN (Zygor, map 2647 = "The Labyrinth of Kindo'jan/0"): ingang 44.41,91.95. Kinduru en Valeera na de intro rond 44.37,84.58 en 44.17,84.65. Chamber of Rites rond 44.36,70.44.
- AFGELEID: hij staat bij de ingang, in of vlak voor de Chamber of Rites (zuidkant). Dat zijn PTR-waarnemingen. Een exacte coördinaat moet Rob in het spel meten.

**Wat "assist" betekent**
- GEMETEN (Wowhead quest 98951, live): een gewone quest. Het is **geen escort**. Doel: "Find and purge Akil'zon's Roost of intruders on Tier 8+". Je ruimt dus één genoemde kamer (vleugel) leeg op Tier 8 of hoger. Sharable, level 80.
- GEMETEN (wago QuestLine 6385, 70391): naam "The Labyrinth of Kindo'jan". Interne omschrijving: **"6-Step Weekly Unlocked Quest Line to obtain 2 myth armor pieces of your choice"**.
- GEMETEN (wago QuestLineXQuest, 70391): volgorde 98951 → 98963 → 98962 → 98961 → 98960 → 98959.

| Stap | Quest-ID | Naam | Bron |
|---|---|---|---|
| 1 | 98951 | Akil'zon's Roost | Wowhead live (GEMETEN) |
| 2 | 98963 | Halazzi's Lair | Wowhead ptr-2 (GEMETEN); op live Wowhead "bestaat niet" |
| 3 | 98962 | The Cave Towers | Wowhead ptr-2 (GEMETEN) |
| 4 | 98961 | Jan'alai's Refuge | Wowhead ptr-2 (GEMETEN) |
| 5 | 98960 | onbekend | alleen het ID in wago; Wowhead kent hem niet |
| 6 | 98959 | onbekend | alleen het ID in wago; Wowhead kent hem niet |

- Beloning, GEMETEN (Wowhead 98951 live; 98963/98962/98961 ptr-2): **1x Mythical Soul Fragment + 2000 Undercoin** (currency 2803). Voor 98960 en 98959 is de beloning onbekend.
- Per week, AFGELEID uit "Weekly Unlocked": elke week komt één nieuwe stap vrij. Het maximum is 6 stappen, dus 6 fragmenten, dus 2 stukken. Dat klopt met de tekst "2 myth armor pieces".
- Inhalen van gemiste weken: dit zeggen alleen gidsen (skycoach.gg 14 okt, mmonster.co 11 okt, buyboost 7 okt). GEMETEN als bewering van die sites, niet bevestigd door Blizzard. AFGELEID: "Unlocked" klinkt als "blijft openstaan", maar dat is niet gemeten.
- Per run, AFGELEID: het fragment komt alleen bij het inleveren van de quest. Het komt niet per run of uit een kist. Extra runs in dezelfde week geven dus niets extra.
- Op de PTR gaf hij de quests direct achter elkaar, zonder weekslot. GEMETEN: Wowhead-nieuws 7 okt en wowsaga 9 okt. Op live verwacht iedereen een weekslot. Live-bewijs van na 13/14 okt heb ik niet gevonden.

## 2. Mythical Soul Fragment

- GEMETEN (wago ItemSparse 70391): item **285065 "Mythical Soul Fragment"**. Epic, Bind on Acquire, stapel 20, MaxCount 0 (geen unieklimiet), item level 1, verkoopprijs 100 goud. Geen beschrijving.
- GEMETEN (Wowhead item 285065): "Reward from" quest 98951. Toegevoegd in 12.1.5.
- **Combineren gaat met rechtsklik, niet bij een verkoper.**
  - GEMETEN (wago ItemEffect 237788 + ItemXItemEffect 169911): 285065 heeft een On Use-spell, **1317439** ("Mythical Soul Fragment").
  - GEMETEN (wago SpellReagents 39412): die spell kost **3x 285065**.
  - GEMETEN (wago SpellEffect 1350509): CREATE_ITEM **285044**.
- GEMETEN (wago ItemSparse): **285044 "Venerated Loa Armament"**. Epic, BoA, vereist level 90.
  - On Use (ItemEffect 237784): spell **1317337**.
  - SpellEffect 1350398 = LAUNCH_QUEST_CHOICE, PlayerChoice **1081**. Je krijgt dus een keuzescherm.
- Slotlimiet, GEMETEN (spell 1317337, 70391 met hotfixes): "Obtain a Myth 1/6 piece of **armor** of your choosing. Armor Proficiency is decided based on current player class."
  - De lijst met keuzes (PlayerChoice 1081) staat **niet** in de client-DB2. Wago heeft geen PlayerChoice-tabel.
  - Gidsen spreken elkaar tegen:
    - Geen wapens en geen trinkets: buyboost, wowsaga, skycoach.
    - "Armor or jewelry": buyboost.
    - "Including armor, cloaks and jewelry": mmonster.
    - "Equipment-slot of your choosing": Icy Veins.
  - Niets daarvan is live gemeten. AFGELEID: de officiële tekst zegt "armor". Wapens vallen er zeker buiten. Of ring, ketting en mantel meetellen, weten we niet.
- Itemlevel 318 voor Myth 1/6 noemen alleen gidsen (buyboost, skycoach, expcarry). Niet gemeten.
- Een cooldown van 5 seconden op het combineren noemt alleen wowsaga (PTR-video). Niet gemeten.

### Tegenspraak: Myth 1/6 of 2/6?

| Bron | Track |
|---|---|
| Robs tooltip in het spel (screenshot, live) | **2/6** |
| wago spell 1319741 enUS **met** hotfix | **2/6** |
| wago spell 1319741 enUS zonder hotfix | 1/6 |
| wago spell 1319741 de/fr/es/mx/pt/it/ru (hotfixvlag aan) | 1/6 |
| wago spell 1317337 (Use van de Armament), met hotfix | 1/6 |
| wago spell 1317439 (combineren), met hotfix | 1/6 |
| Wowhead item 285044, Wowhead-nieuws, Icy Veins, alle gidsen (allemaal van vóór live) | 1/6 |

AFGELEID: Blizzard heeft alleen de kaart-tooltip naar 2/6 gezet. De itemteksten zeggen nog 1/6. Wat je echt krijgt, regelt de server. Dat kan ik niet meten. Advies: laat Rob de tooltip van de Venerated Loa Armament (285044) bekijken, of het stuk dat eruit komt. Tot die tijd moet MH-tekst "Myth" zeggen zonder 1/6 of 2/6, of allebei noemen.

## 3. Namen in de client (wago 70391, met hotfixes)

| Taal | Mythical Soul Fragment (item 285065) | Venerated Loa Armament (285044) | Wah'du (uit spell 1319741) |
|---|---|---|---|
| deDE | Mythisches Seelenfragment | Verehrte Loawaffe | Wah'du |
| frFR | Fragment d’âme mythique | Armement de Loa vénéré | Wah’du (krul-apostrof ’) |
| esES | Trozo de alma mítico | Armamento loa venerado | Wah'du |
| esMX | Fragmento de alma mítica | Armamento de los loa venerado | Wah'du |
| ptBR | Fragmento de Alma Mítico | Armamento do Loa Venerado | Wah'du |
| itIT | Frammento dell'Anima Mitico | Armamento Venerato dei Loa | Wah'du |
| ruRU | Эпохальный фрагмент души | Почитаемое оружие лоа | Вах'ду |

Alle GEMETEN. NPC-namen staan niet in de client-DB2. "Wah'du" komt uit de zin in spell 1319741.

Zo vertaalt de client het werkwoord "Assist" (GEMETEN, spell 1319741):
- deDE: Unterstützt Wah'du ... auf Stufe 8+
- frFR: Venez en aide à Wah’du ... au niveau 8 ou supérieur
- esES: Ayuda a Wah'du ... con nivel 8 o superior
- esMX: ... en nivel 8 o superior
- ptBR: Ajude Wah'du no Labirinto no Grau 8 ou superior
- itIT: Assisti Wah'du ... al Grado 8 o superiore
- ruRU: Помогите Вах'ду в Лабиринте 8-го уровня и выше

Bijvangst, GEMETEN (ItemSparse 70391): er zijn twee items "Heroic Soul Fragment".
- 285801: stapel 20, BoA, geen beschrijving.
- 285807: stapel 1, level 90, niet gebonden. Beschrijving: "Obtained from a delve's Bountiful Coffer. Combine three fragments to obtain a random Hero 2/6 piece of equipment."
- Welk van de twee in de Labyrinth-kist zit, heb ik niet nagegaan.

## Open punten (voor Rob in het spel)
1. Exacte plek van Wah'du op map 2647. Gebruik `/way` of `C_Map.GetPlayerMapPosition` naast hem.
2. Geeft de Armament 1/6 of 2/6? Bekijk de tooltip van 285044 of het item dat eruit komt.
3. Welke slots staan in het keuzescherm (PlayerChoice 1081)?
4. Kun je gemiste weken inhalen? Te zien vanaf de reset van 21 okt (EU).
5. Namen en beloningen van stap 5 en 6 (98960, 98959).
