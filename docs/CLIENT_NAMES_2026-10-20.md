# Clientnamen, gemeten 20 okt 2026

Bron: wago.tools DB2, build **12.1.5.70448** (live), per locale. mh-research, alles GEMETEN tenzij AFGELEID erbij staat.
PTR 12.1.7.70424 gaf voor currency/achievement/upgrade-rijen geen verschil. Geen hotfixes op deze rijen.

## Nebulous Voidcore (CurrencyTypes 3418, ook 3513)
de Nebulöser Leerenkern · fr Noyau du Vide nébuleux · esES Núcleo de Vacío nebuloso · **esMX Núcleo del Vacío nebuloso** ·
pt Núcleo Caótico Nebuloso · it Nucleo del Vuoto Nebuloso · ru Туманный сердечник Бездны
→ beide Spaanse spellingen kloppen, elk voor zijn eigen client.

## "… of the Mist" (Achievement.Title_lang; 62413 bestaat niet, 62415 = DNT)
| ID | de | fr | esES | esMX | pt | it | ru |
|---|---|---|---|---|---|---|---|
| 62410 | Abenteurer des Nebels | Aventure de la brume | Aventurero de la bruma | Aventurero de la niebla | Aventureiro da bruma | Avventuriero della nebbia | Туманный искатель приключений |
| 62411 | Veteran des Nebels | Vétéran de la brume | Veterano de la bruma | Veterano de la niebla | Veterano da bruma | Veterano della nebbia | Ветеран туманов |
| 62412 | Champion des Nebels | Champion de la brume | Campeón de la bruma | Campeón de la niebla | Campeão da bruma | Campione della nebbia | Защитник туманов |
| 62414 | Held des Nebels | Héroïsme de la brume | Héroe de la bruma | Héroe de la niebla | Herói da bruma | Eroe della nebbia | Герой туманов |
| 62416 | Mythos des Nebels | Mythe de la brume | Mito de la bruma | Mito de la niebla | Mítico da bruma | Mito della Nebbia | Сказания туманов |

## Spoorwoord in de tooltip (ItemNameDescription, "Upgrade Level: <track> n/m")
| | de | fr | esES | esMX | pt | it | ru |
|---|---|---|---|---|---|---|---|
| Adventurer 14044 | Abenteurer | aventurier/aventurière | aventurero | Aventurero | Aventureiro | Avventuriero | искатель приключений |
| Veteran 14061 | Veteran | vétéran/vétérane | veterano | Veterano | Veterano | Veterano | ветеран |
| Champion 14053 | Champion | champion/championne | campeón | Campeón | Campeão | Campione | чемпион |
| Hero 14085 | Held | héros/héroïne | héroe | Héroe | Herói | Eroe | герой |
| Myth 14091 | Mythos | mythique | mito | Mito | Mito | Mito | легендарный герой |

Let op: ru-crests zeggen "защитника" (Champion) en "эпохи" (Myth); fr-crests "mythique"; fr gebruikt ’ en spatie vóór ":".
Mistcrest-namen (CurrencyTypes 3437–3441): fr Écu de brume d’aventure …/mythique; it Emblema della Nebbia dell'Avventuriero …
del Mito; ru Маревый герб искателя приключений … эпохи; de Nebelwappen des Abenteurers … der Mythen; esES Blasón de bruma de
…; esMX Niebloemblema de … / Niebloemblema mítico; pt Brasão Brumoso do … / Brasão Brumoso Mítico.

## Corrosive
| | de | fr | es(ES=MX) | pt | it | ru |
|---|---|---|---|---|---|---|
| Corrosive Codex (item 276142) | Ätzender Kodex | Codex corrosif | Códice corrosivo | Códice Corrosivo | Codice Corrosivo | Разъедающий кодекс |
| Corrosive Soul (item 273000, géén currency) | Ätzende Seele | Âme corrosive | Alma corrosiva | Alma Corrosiva | Anima Corrosiva | Разъедающая душа |
| Corrosive Coin (currency 3448) | Korrosive Münze | Pièce corrosive | Moneda corrosiva | Moeda Corrosiva | Moneta Corrosiva | Разъедающая монета |

## Codex-gaven
"Corrosive Gifts" (spell 1310675): de **Ätzende Gaben** · fr Cadeaux corrosifs · es Dones corrosivos · pt Dádivas Corrosivas ·
it Doni Corrosivi · ru Разъедающие дары. Ula'tek's Gift = de Ula'teks Geschenk. Insidious Venom = de Heimtückisches Gift
(hier betekent "Gift" echt vergif). → de: Codex-gaven = "Gaben", nooit "Gift".
AFGELEID: spells 1303467–1303478 zijn de 12 opties van PlayerChoice 1076 (wago heeft geen PlayerChoice-tabel).


## Ronde 2 (20 okt)

**Bron:** wago.tools DB2-CSV, build **12.1.5.70448** (expliciet `&build=12.1.5.70448`), gelezen 20 okt 2026 in het ingebouwde browservenster. Elke cel in de tabellen is **GEMETEN** (letterlijk uit de CSV-rij gelezen, tabel + rij-ID staan erbij). Alles wat geen tabelcel is, staat apart gemarkeerd als GEMETEN of AFGELEID.

- deDE is in deze ronde niet opnieuw gemeten.
- Ronde 1 hierboven is door deze agent **niet gelezen** (agentregel: niets onder `docs/` lezen). Er kan dus overlap zijn.
- Hotfix-controle (GEMETEN): alle 39 rijen × 7 locales opnieuw opgehaald met `&useHotfixes=1` → 0 verschillen. AFGELEID: niet positief gecontroleerd of die parameter op het CSV-eindpunt echt hotfixes toepast.
- Strings met `’` (frFR) zijn een typografisch apostrof, geen `'`. Zo staat het in de client.

### 1. Corrosive Codex — de 12 gift-keuzes (SpellName.Name_lang)

GEMETEN: zes enUS-namen wijken af van de gok in de opdracht. 1303469 = "Gorgoneion Gaze" (niet "Gaze of the Gorgoneion"), 1303471 = "Viperine Grasp" (niet "Grip of the Viperling"), 1303472 = "Ophidian Maw" (niet "Serpent's Maw"), 1303473 = "Virulent Mucus" (niet "Contagious Slime"), 1303474 = "Accursed Poison" (niet "Cursed Venom"), 1303475 = "Plague of Corrosion" (niet "Plague of Decay").

| SpellName ID | enUS | frFR | esES | esMX | ptBR | itIT | ruRU |
|---|---|---|---|---|---|---|---|
| 1303467 | Lithic Plumage | Plumage lithique | Plumaje lítico | Plumaje lítico | Plumagem Lítica | Piumaggio Litico | Каменное оперение |
| 1303468 | Ouroboric Cycle | Cycle d’Ouroboros | Ciclo de uróboros | Ciclo de uróboros | Ciclo Ourobórico | Ciclo Uroborico | Цикл Уробороса |
| 1303469 | Gorgoneion Gaze | Regard gorgonéion | Mirada de gorgoneion | Mirada de gorgona | Olhar Gorgoneico | Sguardo delle Gorgoni | Взгляд Горгоны |
| 1303470 | Mephitic Cloud | Nuage méphitique | Nube mefítica | Nube mefítica | Nuvem Mefítica | Nube Mefitica | Кислотное облако |
| 1303471 | Viperine Grasp | Étreinte vipérine | Yugo viperino | Yugo viperino | Agarrão Viperino | Presa Viperina | Хватка виперина |
| 1303472 | Ophidian Maw | Gueule ophidienne | Fauces de ofidio | Fauces de ofidio | Gorja Ofídica | Fauce Ofidica | Змеиный зев |
| 1303473 | Virulent Mucus | Mucus virulent | Mucosidad virulenta | Moco virulento | Muco Virulento | Muco Virulento | Заразная слизь |
| 1303474 | Accursed Poison | Poison maudit | Veneno maldito | Veneno maldito | Veneno Amaldiçoado | Veleno Maledetto | Проклятый яд |
| 1303475 | Plague of Corrosion | Peste corrosive | Plaga de corrosión | Plaga de corrosión | Peste da Corrosão | Piaga della Corrosione | Чума коррозии |
| 1303476 | Miasma Geyser | Geyser de miasmes | Géiser de miasma | Géiser de miasma | Gêiser de Miasma | Geyser del Miasma | Гейзер миазмов |
| 1303477 | Ula'tek's Gift | Don d’Ula’tek | Don de Ula'tek | Don de Ula'tek | Dádiva de Ula'tek | Dono di Ula'tek | Дар Ула'тек |
| 1303478 | Insidious Venom | Venin insidieux | Veneno insidioso | Veneno insidioso | Peçonha Insidiosa | Veleno Insidioso | Коварный яд |

### 2. "Warbound" in tooltips (GlobalStrings.TagText_lang) en de Warbound-pakketten (ItemSparse.Display_lang)

GEMETEN: de tooltipregel "Warbound" heeft twee keys met dezelfde tekst: `ITEM_ACCOUNTBOUND` en `ITEM_BNETACCOUNTBOUND`. "Warbound until equipped" = `ITEM_ACCOUNTBOUND_UNTIL_EQUIP`. De "Binds to…"-varianten staan erbij voor de volledigheid. Een key `ITEM_WARBOUND…` of `ACCOUNT_BOUND` bestaat niet in enUS GlobalStrings van deze build (GEMETEN: regex op de hele tabel; dezelfde zoekactie vond wel de 6 keys hieronder).

| GlobalStrings key (ID) | enUS | frFR | esES | esMX | ptBR | itIT | ruRU |
|---|---|---|---|---|---|---|---|
| ITEM_ACCOUNTBOUND (19379) | Warbound | Lié au bataillon | Ligado a la banda guerrera | Ligado a la tropa | Vinculado ao Bando | Vincolato alla Brigata | Привязано к отряду |
| ITEM_BNETACCOUNTBOUND (21885) | Warbound | Lié au bataillon | Ligado a la banda guerrera | Ligado a la tropa | Vinculado ao Bando | Vincolato alla Brigata | Привязано к отряду |
| ITEM_ACCOUNTBOUND_UNTIL_EQUIP (51857) | Warbound until equipped | Lié au bataillon jusqu’à être équipé | Ligado a la banda guerrera hasta que te equipas con ello | Ligado a la tropa hasta equiparse | Vinculado ao Bando até ser equipado | Vincolato alla Brigata fino all'equipaggiamento | Этот предмет привязан к отряду до тех пор, пока его не используют. |
| ITEM_BIND_TO_ACCOUNT (19452) | Binds to Warband | Lié au bataillon | Se liga a la banda guerrera | Se liga a la tropa | Vincula ao Bando de Guerra | Si vincola alla Brigata | Привязывается к отряду |
| ITEM_BIND_TO_BNETACCOUNT (21886) | Binds to Warband | Lié au bataillon | Se liga a la banda guerrera | Se liga a la tropa | Vincula ao Bando de Guerra | Si vincola alla Brigata | Привязывается к отряду |
| ITEM_BIND_TO_ACCOUNT_UNTIL_EQUIP (51855) | Binds to Warband until equipped | Se lie au bataillon jusqu’à être équipé | Se liga a la banda guerrera hasta que te equipas con ello | Se liga a la tropa hasta equiparse | Vinculado ao Bando de Guerra até ser equipado | Si vincola alla Brigata fino all'equipaggiamento | Привязывается к отряду до тех пор, пока этот предмет не используют. |

| ItemSparse ID | enUS | frFR | esES | esMX | ptBR | itIT | ruRU |
|---|---|---|---|---|---|---|---|
| 280732 | Warbound Pack of Hero Mistcrests | Paquet de bataillon d’écus de brume héroïques | Mochila de blasones de bruma de héroe ligada a la banda guerrera | Paquete de niebloemblemas de héroe ligado a la tropa | Pacote Vinculado ao Bando de Brasões Brumosos do Herói | Pacchetto Guerrafondaio di Emblemi della Nebbia dell'Eroe | Привязанный к отряду комплект маревых гербов героя |
| 280734 | Warbound Pack of Champion Mistcrests | Paquet de bataillon d’écus de brume de champion | Mochila de blasones de bruma de campeón ligada a la banda guerrera | Paquete de niebloemblemas de campeón ligado a la tropa | Pacote Vinculado ao Bando de Brasões Brumosos do Campeão | Pacchetto Guerrafondaio di Emblemi della Nebbia del Campione | Привязанный к отряду комплект маревых гербов защитника |
| 280737 | Warbound Pack of Veteran Mistcrests | Paquet de bataillon d’écus de brume de vétéran | Mochila de blasones de bruma de veterano ligada a la banda guerrera | Paquete de niebloemblemas de veterano ligado a la tropa | Pacote Vinculado ao Bando de Brasões Brumosos do Veterano | Pacchetto Guerrafondaio di Emblemi della Nebbia del Veterano | Привязанный к отряду комплект маревых гербов ветерана |

Let op (GEMETEN, uit de twee tabellen hierboven):
- itIT zegt op de tooltip "Brigata", maar in de itemnaam "Guerrafondaio". Een itIT-tekst die "Warbound" vertaalt, moet dus kiezen welke van de twee hij volgt.
- frFR heeft één tekst voor zowel "Warbound" als "Binds to Warband": "Lié au bataillon".
- ptBR zegt op de tooltip "Vinculado ao Bando" (kort), maar bij "Binds to…" "Bando de Guerra" (lang).
- esES zegt "banda guerrera", esMX zegt "tropa".

### 3. Voidcore-transmutatie: "Nebulous Voidcores transmuted" (UiWidgetStringSource.Value_lang)

GEMETEN: de voortgangstekst staat **niet** in GlobalStrings, QuestObjective, CurrencyTypes, CriteriaTree, Achievement of PlayerCondition (CurrencyTypes 3418/3513 hebben wel "…have been transmuted." in hun omschrijving, maar dat is een andere zin). Dezelfde zoekactie (enUS, regex `transmut`) vond hem wel in UiWidgetStringSource. Er zijn twee identieke widgets: 7843 (de lange tekst noemt Decimus) en 8315 (noemt Orin). ReqID = 19 bij beide.

| UiWidgetStringSource ID | enUS | frFR | esES | esMX | ptBR | itIT | ruRU |
|---|---|---|---|---|---|---|---|
| 22045 (widget 7843, Decimus) | Nebulous Voidcores transmuted: | Noyaux du Vide nébuleux transmutés : | Núcleos de Vacío nebulosos transmutados: | Núcleos del Vacío nebulosos transmutados: | Núcleos Caóticos Nebulosos transmutados: | Nuclei del Vuoto Nebulosi trasmutati: | Трансмутировано туманных сердечников Бездны: |
| 23612 (widget 8315, Orin) | Nebulous Voidcores transmuted: | Noyaux du Vide nébuleux transmutés : | Núcleos de Vacío nebulosos transmutados: | Núcleos del Vacío nebulosos transmutados: | Núcleos Caóticos Nebulosos transmutados: | Nuclei del Vuoto Nebulosi trasmutati: | Трансмутировано туманных сердечников Бездны: |
| 22047 zin 1 (Decimus) | %3420c Nebulous Voidcores transmuted. | %3420c \|4noyau du Vide nébuleux transmuté:noyaux du Vide nébuleux transmutés;. | %3420c núcleos de Vacío nebulosos transmutados. | %3420c núcleos del Vacío nebulosos transmutados. | %3420c Núcleos Caóticos Nebulosos transmutados. | %3420c Nuclei del Vuoto Nebulosi trasmutati. | Трансмутировано туманных сердечников Бездны: %3420c. |
| 23614 zin 1 (Orin) | %3420c Nebulous Voidcores transmuted. | %3420c \|4noyau du Vide nébuleux transmuté:noyaux du Vide nébuleux transmutés;. | %3420c núcleos de Vacío nebulosos transmutados. | %3420c núcleos del Vacío nebulosos transmutados. | %3420c Núcleos Caóticos Nebulosos transmutados. | %3420c Nuclei del Vuoto Nebulosi trasmutati. | Трансмутировано туманных сердечников Бездны: %3420c. |

- GEMETEN: `%3420c` verwijst naar CurrencyTypes 3420 = "[DNT] Nebulous Voidcore Turn-In Tracker". De zin gaat verder met "maximum total of %3418m"; 3418 = "Nebulous Voidcore" (CurrencyTypes, enUS).
- AFGELEID: `%3420c` = de huidige hoeveelheid van die tracker-valuta en `%3418m` = het maximum van 3418. Dat volgt uit de vorm van de tekst, niet uit een meting in de client.
- GEMETEN: in frFR staat de `|4enkelvoud:meervoud;`-grammaticacode. De client kiest daarmee zelf enkelvoud of meervoud. In de tabel staat de `|` geëscaped als `\|`.
- GEMETEN: ruRU zet het getal achteraan: "Трансмутировано …: %3420c."
- GEMETEN: ptBR zegt "Núcleos Caóticos" (Caos voor Void), zoals al bekend voor ptBR.

### 4. Seizoen-1-prestaties "… of the Dawn" (Achievement.Title_lang)

GEMETEN (enUS-omschrijvingen): 61809 "Outgrow the use of Adventurer Dawncrests during Midnight Season 1.". 42767/42768/42769 zeggen hetzelfde voor Veteran/Champion/Hero. 42770 = "Obtain an average item level of 285 during Midnight Season 1.". 61490 = "Accomplished one of the following feats during Season 1 of Midnight on your current character:". Volgorde via Supercedes (GEMETEN): 61809 → 42767 → 42768 → 42769 → 42770.

| Achievement ID | enUS | frFR | esES | esMX | ptBR | itIT | ruRU |
|---|---|---|---|---|---|---|---|
| 61809 | Adventurer of the Dawn | Aventure de l’aube | Aventurero del alba | Aventurero del alba | Aventureiro da Aurora | Avventuriero dell'Alba | Искатель приключений зари |
| 42767 | Veteran of the Dawn | Vétéran de l’aube | Veterano del alba | Veterano del alba | Veterano da aurora | Veterano dell'Alba | Ветеран зари |
| 42768 | Champion of the Dawn | Héraut de l’aube | Campeón del Alba | Campeón del Alba | Campeão da Aurora | Campione dell'alba | Поборник зари |
| 42769 | Hero of the Dawn | Héroïsme de l’aube | Héroe del alba | Adalid del alba | Herói da aurora | Eroe dell'Alba | Герой зари |
| 42770 | Myth of the Dawn | Mythe de l’aube | Mito del alba | Mito del alba | Mito da aurora | Mito dell'Alba | Сказания зари |
| 61490 | Midnight Season 1: Champion of the Dawn | Saison 1 de Midnight : héraut de l’aube | Temporada 1 de Midnight: Campeón del alba | Temporada 1 de Midnight: Campeón del alba | Série 1 de Midnight: Campeão da Aurora | Stagione 1 di Midnight: Campione dell'Alba | 1-й сезон Midnight: поборник зари |

GEMETEN: hoofdletters zijn niet consequent binnen één locale (esES "Campeón del Alba" naast "Veterano del alba"; ptBR "Campeão da Aurora" naast "Veterano da aurora"; itIT "Campione dell'alba" naast "Veterano dell'Alba"). Zo staat het in de client. Wie de client-tekst wil tonen, neemt hem letterlijk over.

### 5. "Housing" (GlobalStrings) en Community Coupons (CurrencyTypes 3363)

| GlobalStrings key (ID) | enUS | frFR | esES | esMX | ptBR | itIT | ruRU |
|---|---|---|---|---|---|---|---|
| BINDING_HEADER_HOUSING_SYSTEM (53080) | Housing | Logis | Hogares | Viviendas | Moradia | Alloggi | Жилье |
| AUCTION_CATEGORY_HOUSING (55858) | Housing | Logis | Hogares | Viviendas | Moradia | Alloggi | Жилье |
| HOUSING_SETTINGS_LABEL (58423) | Housing | Logis | Hogares | Viviendas | Moradia | Alloggi | Дома для игроков |
| HOUSING_DASHBOARD_FRAMETITLE (53147) | Housing Dashboard | Tableau de bord des logis | Panel de hogares | Panel de viviendas | Painel de moradia | Pannello dell'Alloggio | Панель жилья |
| HOUSING_MICRO_BUTTON (53157) | Housing Dashboard | Tableau de bord des logis | Panel de hogares | Panel de viviendas | Painel de moradia | Pannello dell'Alloggio | Панель жилья |
| KIOSK_HOUSING_END_BODY2 (55085) | Player Housing | le système de logis | Hogares para jugadores | Vivienda del jugador | Moradia de jogador | Alloggi dei personaggi | Дом игрока |

- GEMETEN: in enUS hebben nog meer keys exact de tekst "Housing Dashboard": HOUSING_DASHBOARD_CATALOG_FRAMETITLE (53145), HOUSING_DASHBOARD_HOUSEINFO_FRAMETITLE (56041), HOUSING_DASHBOARD_COLLECTION_FRAMETITLE (59796), BINDING_NAME_TOGGLEHOUSINGDASHBOARD (54710). Die zijn niet per locale gemeten.
- GEMETEN: frFR 55085 is een zinsdeel ("le système de logis"), geen titel. Gebruik voor een titel 53080 of 58423.
- AFGELEID: het beste woord voor "Housing" als functienaam is 53080/58423 ("Logis", "Hogares", "Viviendas", "Moradia", "Alloggi"). Bij ruRU verschillen die twee: "Жилье" tegenover "Дома для игроков".

| CurrencyTypes ID | enUS | frFR | esES | esMX | ptBR | itIT | ruRU |
|---|---|---|---|---|---|---|---|
| 3363 | Community Coupons | Bons communautaires | Cupones de la comunidad | Cupones comunitarios | Cupons da Comunidade | Buoni della Comunità | Районные купоны |

### 6. Het gift-woord in de Codex (SpellName.Name_lang)

| SpellName ID | enUS | frFR | esES | esMX | ptBR | itIT | ruRU |
|---|---|---|---|---|---|---|---|
| 1310675 (volgens de opdracht al in ronde 1) | Corrosive Gifts | Cadeaux corrosifs | Dones corrosivos | Dones corrosivos | Dádivas Corrosivas | Doni Corrosivi | Разъедающие дары |
| 1301266 | Corrosive Gifts | Cadeaux corrosifs | Dones corrosivos | Dones corrosivos | Dádivas Corrosivas | Doni Corrosivi | Разъедающие дары |
| 1301269 | Corrosive Codex | Codex corrosif | Códice corrosivo | Códice corrosivo | Códice Corrosivo | Codice Corrosivo | Разъедающий кодекс |

- GEMETEN: in enUS SpellName (hele tabel doorzocht) dragen ook 1304849, 1306440, 1311162 en 1311607 de naam "Corrosive Gifts". Die zijn niet per locale gemeten.
- GEMETEN: geen enkele rij heet in het **enkelvoud** "Corrosive Gift". Gezocht in enUS SpellName, GlobalStrings, UiWidgetStringSource, CriteriaTree, QuestObjective, TraitDefinition en CurrencyTypes. Positieve controle in dezelfde run: het meervoud "Corrosive Gifts" werd wel gevonden. Een lege zoekactie bewijst niet dat het enkelvoud nergens bestaat (bijvoorbeeld in FrameXML-Lua of in tabellen die niet doorzocht zijn).
- GEMETEN: het enkelvoud van het gift-woord staat wel in 1303477 "Ula'tek's Gift": frFR **Don**, esES/esMX **Don**, ptBR **Dádiva**, itIT **Dono**, ruRU **Дар**.
- GEMETEN: frFR gebruikt twee verschillende woorden. Het meervoud is "Cadeaux" ("Cadeaux corrosifs"), het enkelvoud in de gift-naam is "Don" ("Don d’Ula’tek"). De andere locales gebruiken in beide gevallen hetzelfde woord (Dones/Don, Dádivas/Dádiva, Doni/Dono, дары/Дар).
