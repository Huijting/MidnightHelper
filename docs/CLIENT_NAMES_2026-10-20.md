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


## Ronde 3 (20 okt)

**Bron:** wago.tools DB2, build **12.1.5.70448** (expliciet `&build=12.1.5.70448`), gelezen 20 okt 2026 in het ingebouwde browservenster (tabelpagina's en de `data-page`-JSON van dezelfde URL's). "Use Hotfixes" stond uit. Controle met `useHotfixes=1` gaf **geen enkel verschil** (GEMETEN) op: alle 43 deDE-namen van A1-A7 (de tabellen hieronder, zonder de "extra"-rij 51855 en zonder de Reward-teksten), en in alle 8 locales op CurrencyTypes 3316 en 3441, AreaPOI 8979, SpellName 1310218, 1288781, 1296184, 1218002 en ItemSparse 279922 (64 rijen). De overige rijen zijn alleen zonder hotfixes gelezen.
Alles hieronder is **GEMETEN** (zelf gelezen, tabel + rij-ID), tenzij er **AFGELEID** bij staat.
Werkwijze-noot (GEMETEN): het ID-filter van wago is een *substring*-filter; `filter[ID]=exact:<id>` geeft precies één rij. Bij lijsten van meer dan 25 rijen is de paginering niet stabiel (dubbele rijen over pagina's), dus een lijst-zoekopdracht kan rijen missen.

### A1. Codex-geschenkspells (SpellName, kolom Name_lang)

Gevraagd: 1303467-1303476 + 1303478 (dat zijn er 11); 1303477 erbij gelezen, zodat het er 12 zijn.

| SpellName-ID | enUS | deDE |
|---|---|---|
| 1303467 | Lithic Plumage | Lithischer Federschmuck |
| 1303468 | Ouroboric Cycle | Ouroborischer Kreislauf |
| 1303469 | Gorgoneion Gaze | Blick des Gorgoneion |
| 1303470 | Mephitic Cloud | Verpestende Wolke |
| 1303471 | Viperine Grasp | Griff des Viperlings |
| 1303472 | Ophidian Maw | Schlangenmaul |
| 1303473 | Virulent Mucus | Ansteckender Schleim |
| 1303474 | Accursed Poison | Verfluchtes Gift |
| 1303475 | Plague of Corrosion | Seuche der Zersetzung |
| 1303476 | Miasma Geyser | Miasmageysir |
| 1303477 | Ula'tek's Gift | Ula'teks Geschenk |
| 1303478 | Insidious Venom | Heimtückisches Gift |

- Buur (niet gevraagd, wel gezien): 1303479 = Sanguine Rancor / Blutgroll.
- Spelling (GEMETEN): de spellnaam 1303477 is enUS `Ula'tek's Gift`, maar de beschrijving (Spell 1303477, Description_lang) schrijft `Ula'Tek's Gift` met een hoofdletter T. deDE schrijft in naam én beschrijving `Ula'teks Geschenk`.

### A2. GlobalStrings (kolom TagText_lang)

| Rij | BaseTag | enUS | deDE | Flags |
|---|---|---|---|---|
| 19379 | ITEM_ACCOUNTBOUND | Warbound | Kriegsmeutengebunden | 0x5 |
| 51857 | ITEM_ACCOUNTBOUND_UNTIL_EQUIP | Warbound until equipped | Kriegsmeutengebunden bis zum Ausrüsten | 0x1 |
| 19452 | ITEM_BIND_TO_ACCOUNT | Binds to Warband | Wird an Kriegsmeute gebunden | 0x5 |
| 51855 (extra) | ITEM_BIND_TO_ACCOUNT_UNTIL_EQUIP | Binds to Warband until equipped | Wird bis zum Ausrüsten an Kriegsmeute gebunden | 0x1 |

### A3. ItemSparse (kolom Display_lang)

| Item-ID | enUS | deDE |
|---|---|---|
| 280732 | Warbound Pack of Hero Mistcrests | Kriegsmeutengebundenes Paket mit Nebelwappen des Helden |
| 280734 | Warbound Pack of Champion Mistcrests | Kriegsmeutengebundenes Paket mit Nebelwappen des Champions |
| 280737 | Warbound Pack of Veteran Mistcrests | Kriegsmeutengebundenes Paket mit Nebelwappen des Veteranen |

### A4. Housing-woord (GlobalStrings, kolom TagText_lang)

| Rij | BaseTag | enUS | deDE |
|---|---|---|---|
| 53080 | BINDING_HEADER_HOUSING_SYSTEM | Housing | Behausung |
| 55858 | AUCTION_CATEGORY_HOUSING | Housing | Behausungen |
| 58423 | HOUSING_SETTINGS_LABEL | Housing | Behausungen |
| 53147 | HOUSING_DASHBOARD_FRAMETITLE | Housing Dashboard | Behausungsübersicht |

AFGELEID: deDE heeft geen vast enkelvoud. De sneltoetskop zegt "Behausung", het veilinghuis en de instellingen zeggen "Behausungen".

### A5. UiWidgetStringSource (kolom Value_lang)

| Rij | ParentWidgetID | ReqID | enUS | deDE |
|---|---|---|---|---|
| 22045 | 7843 | 19 | Nebulous Voidcores transmuted: | Nebulöse Leerenkerne transmutiert: |
| 23612 | 8315 | 19 | Nebulous Voidcores transmuted: | Nebulöse Leerenkerne transmutiert: |

22047 (ParentWidgetID 7843, ReqID 208) en 23614 (ParentWidgetID 8315, ReqID 208) zijn gelijk, behalve de naam: 22047 = **Decimus**, 23614 = **Orin**. Letterlijk (22047):

```
enUS: %3420c Nebulous Voidcores transmuted. |nDecimus can currently make a maximum total of %3418m Nebulous Voidcores. As their skill improves each week, they will be able to transmute more. |nNebulous Voidcores are used to obtain powerful items from raid bosses, Mythic+ dungeons, Bountiful delves, and Nightmare Prey.
deDE: %3420c nebulöse Leerenkerne transmutiert.|nDecimus kann aktuell maximal %3418m nebulöse Leerenkerne erschaffen. Da sein Können stetig zunimmt, kann er mit jeder Woche mehr transmutieren.|nNebulöse Leerenkerne werden verwendet, um mächtige Gegenstände zu erlangen, indem Ihr Schlachtzugsbosse besiegt oder Dungeons auf Mythisch+, großzügige Tiefen und Alptraumbeutejagden abschließt.
```

Let op (GEMETEN): deDE schrijft in de lopende tekst "nebulöse" met kleine n, in de kop (22045/23612) "Nebulöse" met hoofdletter.

### A6. Achievements "... of the Dawn" (Achievement, kolommen Title_lang en Reward_lang)

| Achievement-ID | enUS Title | deDE Title |
|---|---|---|
| 61809 | Adventurer of the Dawn | Abenteurer der Morgendämmerung |
| 42767 | Veteran of the Dawn | Veteran der Morgendämmerung |
| 42768 | Champion of the Dawn | **Champion der Dämmerung** |
| 42769 | Hero of the Dawn | Held der Morgendämmerung |
| 42770 | Myth of the Dawn | Mythos der Morgendämmerung |
| 61490 | Midnight Season 1: Champion of the Dawn | Saison 1 von Midnight: Champion der Morgendämmerung |

- GEMETEN: 42768 deDE is de enige zonder "Morgen" ("Champion der Dämmerung"), ook met `useHotfixes=1`. Dit is zo in Blizzards eigen data, geen leesfout.
- Reward_lang (GEMETEN):

| ID | enUS Reward | deDE Reward |
|---|---|---|
| 61809 | Character Unlock: Trade Adventurer for Veteran Dawncrests | Charakterfreischaltung: Tauscht Morgenlichtwappen des Abenteurers gegen Morgenlichtwappen des Veteranen ein |
| 42767 | Character Unlock: Trade Veteran for Champion Dawncrests | Charakterfreischaltung: Tauscht Morgenlichtwappen des Veteranen gegen Morgenlichtwappen des Champions ein |
| 42768 | Character Unlock: Trade Champion for Hero Dawncrests | Charakterfreischaltung: Tauscht Morgenlichtwappen des Champions gegen Morgenlichtwappen des Helden ein |
| 42769 | Character Unlock: Trade Hero for Myth Dawncrests | Charakterfreischaltung: Tauscht Morgenlichtwappen des Helden gegen Morgenlichtwappen der Mythen ein |
| 42770 | (leeg) | (leeg) |
| 61490 | Item Reward: Crystallized Dawnlight Manaflux | Gegenstandsbelohnung: Kristallisierter Morgenlichtmanaflux |

### A7. Crests (CurrencyTypes, kolom Name_lang)

| Currency-ID | enUS | deDE |
|---|---|---|
| 3437 | Adventurer Mistcrest | Nebelwappen des Abenteurers |
| 3438 | Veteran Mistcrest | Nebelwappen des Veteranen |
| 3439 | Champion Mistcrest | Nebelwappen des Champions |
| 3440 | Hero Mistcrest | Nebelwappen des Helden |
| 3441 | Myth Mistcrest | Nebelwappen der Mythen |
| 3383 | Adventurer Dawncrest | Morgenlichtwappen des Abenteurers |
| 3341 | Veteran Dawncrest | Morgenlichtwappen des Veteranen |
| 3343 | Champion Dawncrest | Morgenlichtwappen des Champions |
| 3345 | Hero Dawncrest | Morgenlichtwappen des Helden |
| 3347 | Myth Dawncrest | Morgenlichtwappen der Mythen |

**Bijvangst, belangrijk voor de code (GEMETEN):** er bestaat een tweede rij Mistcrests, **3442-3446**, met dezelfde namen (enUS en deDE gelezen voor alle vijf) en S2-beschrijvingen. De velden verschillen:
- 3437-3441: CategoryID 142, MaxQty 0, OrderIndex 0, MCRCurrencyID 0, Flags_0 33554434, Flags_1 0.
- 3442 en 3446 (alleen deze twee volledig gelezen): CategoryID 282, MaxQty 100, OrderIndex 1 resp. 5, MaxQtyWorldStateID 30933 resp. 30934, MCRCurrencyID 11 resp. 10, Flags_0 35913922, Flags_1 1.
- AFGELEID: 3442-3446 lijken de bijgehouden munten (met plafond en volgorde), 3437-3441 een soort sjabloon. Welke ID de client echt telt, is hier NIET gemeten. Nameten in de client met `C_CurrencyInfo.GetCurrencyInfo(3441)` en `(3446)`.

### A8. Altar of Corrosion, "Poisoned" en Venom Infusion

**Altar of Corrosion gevonden (GEMETEN, enUS-zoektocht op Name_lang/Display_lang):**
- AreaPOI **8979** (de altaar op de kaart). Description enUS: "Visit the altar to spend your Spirit Corrosion and grow your strength."
- SpellName **1310218** "Altar of Corrosion". Beschrijving: toegang om Spirit Corrosion aan traits uit te geven bij het altaar.
- ItemSparse **279922** "Altar of Corrosion" = een **decor**-item. Daarbij SpellName **1307326** "Collect Altar of Corrosion" (beschrijving "Add this Decor to your House Chest.").
- GameObjects op "Altar of Corrosion" (enUS): 0 treffers. Een lege zoektocht bewijst niets.

| Locale | AreaPOI 8979 = Spell 1310218 = Item 279922 | Spell 1307326 (decor ophalen) |
|---|---|---|
| enUS | Altar of Corrosion | Collect Altar of Corrosion |
| deDE | Altar der Korrosion | Altar der Korrosion sammeln |
| frFR | Autel de la corrosion | Récupérer un autel de la corrosion |
| esES | Altar de la Corrosión | Añadir Altar de la Corrosión |
| esMX | Altar de corrosión | Recoger altar de corrosión |
| ptBR | Altar da Corrosão | Coletar Altar da Corrosão |
| itIT | Altare della Corrosione | Raccolta Altare della Corrosione |
| ruRU | Алтарь коррозии | Получить алтарь коррозии |

(De drie namen in de middelste kolom zijn per locale letterlijk gelijk; GEMETEN.)

AreaPOI 8979 Description_lang per locale (GEMETEN; geeft ook het woord voor "Spirit Corrosion"):
- deDE: Besucht den Altar, um Eure Geistkorrosion auszugeben und Eure Stärke weiterzuentwickeln.
- frFR: Rendez-vous à l’autel pour déposer votre corrosion spirituelle et augmenter votre puissance.
- esES: Visita el altar para gastar tu corrosión espiritual y aumentar tu fuerza.
- esMX: Visita el altar para usar tu corrosión espiritual y aumentar tu fuerza.
- ptBR: Visite o altar e gaste sua Corrosão de Espírito para aumentar a sua força.
- itIT: Visita l'altare per spendere la tua Corrosione dello Spirito e aumentare la tua forza.
- ruRU: Посетите алтарь, чтобы потратить коррозию духа и получить усиление.

**"Poisoned": geen aparte Codex-spell gevonden.**
- GEMETEN: SpellName met exacte naam "Poisoned" (enUS) = 24 rijen. Alleen 1218002 en 1266711 vallen in de 12.x-reeks. Beide hebben een lege Description; 1266711 heeft AuraDescription "Injured.". Hun buren (1218000-1218009, 1266710-1266719) hebben niets met de Codex of Ula'tek te maken.
- GEMETEN: "Poisoned" staat in de Codex-teksten als **toestand**: Ula'tek's Gift (Spell 1303477) "While you are Poisoned ...", en Viperine Grasp, Gorgoneion Gaze, Lithic Plumage, Virulent Mucus, Miasma Geyser, Ophidian Maw (aura-teksten 1291723, 1291725, 1292159, 1302577, 1302600, 1291580) noemen "Poisoned enemies/units".
- GEMETEN: Insidious Venom (1303478) zegt "Chance during combat to Poison yourself ... for $1302621d". Spell **1302621** heet ook "Insidious Venom" (niet "Poisoned"); 1302624 en 1302625 heten eveneens "Insidious Venom".
- AFGELEID: in de client bestaat de toestand waarschijnlijk als label of dispel-type, niet als één debuff met de naam "Poisoned". Welke aura de client toont als je "Poisoned" bent, is niet gemeten.

Het woord zoals het in de Codex-teksten staat (GEMETEN; Spell 1303477 Description_lang en Spell 1288781 Description_lang), plus de naam van de losse spells 1218002/1266711:

| Locale | 1303477 (Ula'tek's Gift) | 1288781 (Venom Infusion) | SpellName 1218002 = 1266711 |
|---|---|---|---|
| enUS | While you are Poisoned | party members become Poisoned | Poisoned |
| deDE | Während Ihr vergiftet seid | Verbündete werden ... vergiftet | Vergiftet |
| frFR | Lorsque vous subissez un empoisonnement | subissent un empoisonnement | Empoisonnement |
| esES | Mientras te afecta un veneno | quedan envenenados | Envenenado |
| esMX | Mientras estés envenenado | quedan envenenados | Envenenado |
| ptBR | Enquanto você está Envenenado | ficam Envenenados | Envenenado |
| itIT | Quando si è Avvelenati | diventano Avvelenati | Avvelenato |
| ruRU | Если вы отравлены | отравляются | Отравление |

AFGELEID: er is geen vaste vertaalterm. frFR en esES omschrijven het ("subissez un empoisonnement", "te afecta un veneno"); ptBR en itIT schrijven het met hoofdletter, als vaste term.

Bijvangst (GEMETEN, alleen uit de **beschrijving** van Spell 1303477, niet uit SpellName): zo noemt de tekst Ula'tek's Gift per locale: frFR "Don d’Ula’tek" (typografische apostrof), esES en esMX "Don de Ula'tek", ptBR "Dádiva de Ula'tek", itIT "Dono di Ula'tek", ruRU "Дар Ула'тек". De SpellName-rij 1303477 is in deze locales NIET gelezen. Unlock-regel in dezelfde tekst: enUS "Offer 8 Corrosive Souls to unlock.", deDE "Bietet 8 ätzende Seelen zum Freischalten.".

**Venom Infusion (GEMETEN):** 19 SpellName-rijen heten "Venom Infusion": 1288781, 1288782, 1288783, 1288785, 1288786, 1289295, 1289303, 1290035, 1296184, 1296210, 1302935, 1304499, 1305686, 1305687, 1305688, 1305689, 1307817, 1315065, 1315187. In alle 8 locales hebben alle 19 rijen dezelfde naam:

| Locale | Naam (alle 19 ID's gelijk) |
|---|---|
| enUS | Venom Infusion |
| deDE | Giftinfusion |
| frFR | Imprégnation de venin |
| esES | Infusión de veneno |
| esMX | Infusión ponzoñosa |
| ptBR | Infusão de Peçonha |
| itIT | Infusione di Veleno |
| ruRU | Насыщение ядом |

- Beschrijving (GEMETEN, enUS): 1288781, 1305687, 1305688, 1305689 en 1315187 = "Upon entering combat, party members become Poisoned, suffering $s6% of their current health as Nature damage every 1 min, while gaining $s2% movement speed and $s4% haste for every $s3% of their health missing. This effect is reversed for the first $s5 sec of combat."
- 1296184 heeft als aura-tekst "Movement Speed increased by $w1% and Haste increased by $w2%. Suffering $w3% of your current health as Nature damage every $1305686t sec." (AFGELEID: dit is de buff/debuff die je op je balk ziet.)
- 1289295, 1289303, 1290035, 1296210, 1302935, 1304499 = "Being infused with the venom of Ula'tek." (AFGELEID: questvisuals/NPC-auras.) 1307817 heeft geen tekst.
- AFGELEID: welke van de 19 bij de Codex hoort, valt niet uit de DB2-tekst af te lezen; "party members" wijst eerder op een groeps- of delve-effect.

### B. Voidlight Marl (CurrencyTypes 3316, kolom Name_lang), alle locales

| Locale | Naam |
|---|---|
| enUS | Voidlight Marl |
| deDE | Leerenlichtmergel |
| frFR | Marne de Lumière du Vide |
| esES | Marga de luz del Vacío |
| esMX | Marga vacioluz |
| ptBR | Silte de Luz Caótica |
| itIT | Marna di Lucevuota |
| ruRU | Мракозарный мергель |

(Voor elke rij gaf de server de gevraagde locale terug in `filters.locale`; GEMETEN.)

### C. esES Myth Mistcrest (beslist "blasones de bruma de mito")

- GEMETEN: CurrencyTypes **3441** esES = **"Blasón de bruma de mito"** (enkelvoud, hoofdletter B). 3446 esES is precies hetzelfde.
- GEMETEN: het meervoud staat ook in de client, in een itemnaam: ItemSparse **269866** esES = "Cúmulo glorioso de blasones de bruma de mito" (enUS "Glorious Cluster of Myth Mistcrests").
- Andere esES-items met het meervoud (GEMETEN, ItemSparse): 280732 "Mochila de blasones de bruma de héroe ligada a la banda guerrera", 280734 "Mochila de blasones de bruma de campeón ligada a la banda guerrera", 280737 "Mochila de blasones de bruma de veterano ligada a la banda guerrera", 265790 "Alijo de blasones de bruma".
- Ter vergelijking, 3441 in de andere locales (GEMETEN): frFR "Écu de brume mythique", esMX "Niebloemblema mítico", ptBR "Brasão Brumoso Mítico", itIT "Emblema della Nebbia del Mito", ruRU "Маревый герб эпохи".
- AFGELEID: "blasones de bruma de mito" is dus een echte clientvorm (meervoud, kleine letters, midden in een zin). Als losse munt-naam schrijft esES "Blasón de bruma de mito".


## Ronde 4 (20 okt) — Kindo'jan-mount

**Bron**, tenzij anders gezegd: wago.tools DB2, build **12.1.5.70448** (expliciet `&build=12.1.5.70448`), gelezen 20 okt 2026 in het ingebouwde browservenster (de JSON uit de pagina zelf). Elke rij is opgehaald mét `useHotfixes=1` én zonder. De waarden waren overal gelijk. Elke ID-query gaf precies 1 rij, en de pagina gaf de gevraagde build en locale terug. Alles hieronder is **GEMETEN**, tenzij er **AFGELEID** of **NIET GEMETEN** staat.

**Let op de tekens.** frFR gebruikt `’` (U+2019) als apostrof, en een harde spatie (U+00A0) vóór de dubbele punt (erna een gewone spatie). De andere 7 talen gebruiken `'` (U+0027). In de tabellen staan de echte tekens. Andere bijzondere tekens: alleen `"` (U+0022) in esES- en ruRU-titels van 64039.

### 1. Mount 3144 en item 283363

Tabel `Mount`, rij 3144, kolom `Name_lang`. Tabel `ItemSparse`, rij 283363, kolom `Display_lang`. Per taal zijn die twee letterlijk gelijk (vergeleken).

| locale | Mount 3144 `Name_lang` = ItemSparse 283363 `Display_lang` |
|---|---|
| enUS | Loa-Blessed Wayfarer |
| deDE | Loageweihter Wanderer |
| frFR | Voyageur béni par les Loas |
| esES | Caminante bendecido por los loa |
| esMX | Caminante bendecido por los loa |
| ptBR | Viajor Abençoado pelos Loas |
| itIT | Viandante Benedetto dai Loa |
| ruRU | Благословленный лоа странник |

Extra: `Mount.SourceText_lang` van 3144 (zonder hotfixes gelezen; frFR ook mét, gelijk). Hier schrijft Blizzard de naam soms anders dan in de achievement:

```
enUS  |cFFFFD200Achievement:|r Let Me Solo Him: Kindo'Jan
deDE  |cFFFFD200Erfolg:|r Ich kann das allein: Kindo'jan
frFR  |cFFFFD200Haut fait|r<U+00A0>: Tête-à-tête<U+00A0>: Kindo<U+2019>Jan
esES  |cFFFFD200Logro:|r Déjamelo a mí: Kindo'jan
esMX  |cFFFFD200Logro:|r Déjenmelo a mí: Kindo'jan
ptBR  |cFFFFD200Conquista:|r Me Deixa Solar: Kindo'jan
itIT  |cFFFFD200Impresa:|r A lui ci penso io: Kindo'jan
ruRU  |cFFFFD200Достижение:|r "Да я его в одиночку: Киндо'джан"
```

Item 283363 heeft geen rij in `ItemSearchName` (0 rijen, enUS).

### 2. GameObject 689304 "Ancestral Bounty" — NIET GEMETEN

De naam staat niet in wago.
- `GameObjects`, ID 689304: 0 rijen (met en zonder hotfixes). `GameObjects`, `Name_lang` "Ancestral Bounty": 0 rijen. Positieve controle in dezelfde tabel en run: `Name_lang` "Bounty" gaf 11 rijen ("Earthmother's Bounty", "Runetotem's Bounty").
- Ook 0 rijen voor "Ancestral Bounty" in `Vignette` (controle: "Treasure" gaf 874), `SpellName`, `ItemSparse`, `GlobalStrings`, `CriteriaTree`, `QuestV2CliTask` en `AreaPOI`.
- Wowhead, gelezen 20 okt: object=689304 heet enUS "Ancestral Bounty", "Added in patch 12.1.5". Op de de/fr/es/mx/pt/it/ru-site staat overal `[Ancestral Bounty]` tussen haken. Dat betekent: Wowhead kent de vertaling niet.
- AFGELEID: de objectnaam komt van de server, niet uit een DB2-tabel. De vertalingen zijn alleen in het spel te meten, per client.

### 3. NPC Kinduru

Tabel `Creature`, filter `Name_lang` "Kinduru" (enUS): **7 rijen**.

| ID | enUS `Name_lang` | enUS `Title_lang` |
|---|---|---|
| 257344 | Kinduru | Loa Speaker |
| 253804, 253832, 253846, 258699, 261847, 263946 | Loa Speaker Kinduru | Devout of Akil'zon |

Per taal. De zes "Loa Speaker Kinduru"-rijen zijn per taal letterlijk gelijk.

| locale | 257344 `Name_lang` | 257344 `Title_lang` | 6 rijen `Name_lang` | 6 rijen `Title_lang` |
|---|---|---|---|---|
| enUS | Kinduru | Loa Speaker | Loa Speaker Kinduru | Devout of Akil'zon |
| deDE | Kinduru | Loasprecher | Loasprecher Kinduru | Jünger von Akil'zon |
| frFR | Kinduru | Parle-loa | Parle-loa Kinduru | Disciple d'Akil'zon |
| esES | Kinduru | Portavoz de loa | Portavoz de loa Kinduru | Devoto de Akil'zon |
| esMX | Kinduru | Portavoz loa | Portavoz loa Kinduru | Devoto de Akil'zon |
| ptBR | Kinduru | Voz-dos-loas | Voz-dos-loas Kinduru | Devoto de Akil'zon |
| itIT | Kinduru | Oratore dei Loa | Oratore dei Loa Kinduru | Devoto di Akil'zon |
| ruRU | Киндуру | Говорящий с лоа | Говорящий с лоа Киндуру | Служитель Акил'зон |

(frFR `d'Akil'zon` gebruikt hier gewoon U+0027, niet U+2019.)

**Welke Kinduru staat in het Labyrinth? NIET GEMETEN.**
- Wowhead `npcs/name:Kinduru`, gelezen 20 okt: 39 hits. 12 daarvan heten `Kinduru <Herald of de Loa>` en zijn volgens Wowhead "Added in patch 12.1.5" (build 70391): 273203, 273261, 273515, 273569, 273570, 273571, 273572, 273573, 273574, 273575, 274500, 274918. Wowhead geeft er geen locatie bij.
- Geen van die 12 staat in wago `Creature` (ID-filter: 0 rijen elk; dezelfde tabel vond de 7 hierboven).
- De 6 "Loa Speaker"-rijen + 257344 zijn volgens Wowhead uit 12.0.0/12.0.7. Wowhead zet 253804, 253832 en 253846 in Zul'Aman.
- AFGELEID: de Labyrinth-Kinduru is waarschijnlijk een van de 12 "Herald of de Loa"-NPC's (nieuw in 12.1.5). Niet bewezen.
- Wowhead-vertaling van de titel "Herald of de Loa" is onvolledig: esES `Heraldo de los loa` (11 van de 12 ID's), ptBR `Arauto dos Loas` (273203, 273571, 274918). deDE, frFR, esMX, itIT en ruRU: alleen `[Herald of de Loa]` = onbekend. Op de ru-site staat de naam in Latijnse letters "Kinduru". AFGELEID: dat is Wowheads Engelse terugval; de DB2-rij 257344 zegt ruRU `Киндуру`.
- Positieve controle Wowhead: npc=257344 geeft in alle 8 talen dezelfde naam en titel als wago.

### 4. Achievements 63715 en 64039

Tabel `Achievement`, kolom `Title_lang`.

| locale | 63715 `Title_lang` | 64039 `Title_lang` |
|---|---|---|
| enUS | Let Me Solo Him: Kindo'jan | Fabled Let Me Solo Him: Kindo'jan |
| deDE | Ich kann das allein: Kindo'jan | Ich kann das allein (sagenumwoben): Kindo'jan |
| frFR | Tête-à-tête : Kindo’jan | Tête-à-tête légendaire : Kindo’jan |
| esES | Déjamelo a mí: Kindo'jan | "Déjamelo a mí" de leyenda: Kindo'jan |
| esMX | Déjenmelo a mí: Kindo'Jan | Célebre déjenmelo a mí: Kindo'jan |
| ptBR | Me deixa solar: Kindo'jan | Me deixa solar lendário: Kindo'jan |
| itIT | A lui ci penso io: Kindo'jan | A lui ci penso io leggendario: Kindo'jan |
| ruRU | Да я его в одиночку: Киндо'джан | Легендарное достижение "Да я его в одиночку: Киндо'джан" |

Let op: esMX 63715 schrijft `Kindo'Jan` (hoofdletter J), esMX 64039 `Kindo'jan`.

enUS `Description_lang`:
- 63715: "Defeat Kindo'jan in the Labyrinth on Tier 11 without any other players in your party during Midnight Season 2."
- 64039: "Defeat Kindo'jan in his Labyrinth on Tier 11 without any other players in your party, before the first reset following his introduction."

enUS `Reward_lang`: 63715 = `Reward: Loa-Blessed Wayfarer`. 64039 = `Title: Fabled Vanquisher of The First Hash'ey`.

### 5. Titel van 64039 — CharTitles 1342

Tabel `CharTitles`, rij 1342, `Mask_ID` 801. `%s` = de naam van het character.

| locale | `Name_lang` | `Name1_lang` |
|---|---|---|
| enUS | %s, Fabled Vanquisher of The First Hash'ey | %s, Fabled Vanquisher of The First Hash'ey |
| deDE | %s, Sagenumwobene(r) Bezwinger(in) des ersten Hash'ey | (gelijk aan Name_lang) |
| frFR | %s, illustre pourfendeur du premier hash’ey | %s, illustre pourfendeuse du premier hash’ey |
| esES | %s, Legendario Vencedor del primer hash'ey | (gelijk aan Name_lang) |
| esMX | %s, Célebre vencedor del primer hash'ey | %s, Célebre vencedora del primer hash'ey |
| ptBR | %s, Subjugador Lendário do Primeiro Hash'ey | %s, Subjugadora Lendária do Primeiro Hash'ey |
| itIT | %s, Leggendario Dominatore del Primo Hash'ey | %s, Leggendaria Dominatrice del Primo Hash'ey |
| ruRU | %s, легендарный победитель первого хаш'эй | %s, легендарная победительница первого хаш'эй |

- AFGELEID: `Name_lang` is de mannelijke vorm, `Name1_lang` de vrouwelijke (uit de woorden zelf: pourfendeur/pourfendeuse, vencedor/vencedora).
- AFGELEID: dat 1342 echt de beloning van 64039 is. De koppeling staat niet in DB2. Wel is de tekst van `Achievement.Reward_lang` van 64039 in alle 8 talen dezelfde titel. Twee kleine verschillen, GEMETEN: frFR Reward_lang zegt `Titre : illustre pourfendeur ou pourfendeuse du premier hash’ey` (beide vormen in één zin), en ruRU Reward_lang begint met een hoofdletter: `Звание: Легендарный победитель первого хаш'эй`.

### 6. Plaatsnaam "The Labyrinth of Kindo'jan"

De enUS-naam begint met **"The"**. UiMap 2647 `Name_lang`, AreaTable 16913 `AreaName_lang` en Map 3043 `MapName_lang` zijn per taal letterlijk gelijk. AreaPOI 9035 `Name_lang` wijkt alleen in deDE af.

| locale | UiMap 2647 = AreaTable 16913 = Map 3043 | AreaPOI 9035 `Name_lang` |
|---|---|---|
| enUS | The Labyrinth of Kindo'jan | (gelijk) |
| deDE | Das Labyrinth von Kindo'jan | Labyrinth von Kindo'jan |
| frFR | Le labyrinthe de Kindo’jan | (gelijk) |
| esES | El laberinto de Kindo'jan | (gelijk) |
| esMX | El Laberinto de Kindo'Jan | (gelijk) |
| ptBR | O Labirinto de Kindo'jan | (gelijk) |
| itIT | Labirinto di Kindo'jan | (gelijk) |
| ruRU | Лабиринт Киндо'джана | (gelijk) |

Context, GEMETEN (alleen enUS gelezen, tenzij anders gezegd):
- UiMap 2647: Type 4, ParentUiMapID 2395. UiMap 2648 (Type 4, parent 2395) en 2671 (Type 3, parent 0) heten ook "The Labyrinth of Kindo'jan". Die twee niet per taal gelezen.
- AreaTable 16913: ZoneName `121UlaTekLabyrinth`, ContinentID 3043. Map 3043: InstanceType 5.
- AreaPOI 9035, 9036 en 9037 heten alle drie "The Labyrinth of Kindo'jan". 9035 heeft als `Description_lang` "Bountiful Delve" (per taal gelezen; deDE `Großzügige Tiefe`).
- Niet verwarren: AreaTable 16822 en UiMap 2394 heten gewoon "Labyrinth". Dat zijn andere rijen.


## Ronde 5 (20 okt) — Labyrinth-kamertaken

Bron voor alles in deze ronde: wago.tools DB2, build **12.1.5.70448**, **Use Hotfixes aan** (`useHotfixes=1`), CSV-export per tabel, gelezen 20 okt 2026.
Tabellen: Scenario, ScenarioStep (Title_lang / Description_lang, per locale via `&locale=`), CriteriaTree (Description_lang = doeltekst), Criteria.

Belangrijk (GEMETEN): in deze build heet **elk** Labyrinth-scenario in `Scenario.Name_lang` gewoon "The Labyrinth of Kindo'jan" (103 rijen). De kamertaak-naam ("Graverobbers", "Bear's Burden" …) staat in **`ScenarioStep.Title_lang`**; de zin eronder in `ScenarioStep.Description_lang`; de "0/N"-regels zijn `CriteriaTree.Description_lang` met `Amount` = N.

### SPOED: "Bear's Burden" (GEMETEN)

- Scenario-id: **3403** (enige scenario met deze titel in ScenarioStep). Scenario-rij: Type 8, Flags 144, UiScenarioDisplayInfoID 10. WidgetSetID van alle drie de stappen: 842.

| Stap (OrderIndex) | StepID | Titel | Beschrijving (enUS) | Doelen (CriteriaTree, Amount) |
|---|---|---|---|---|
| 0 | 17225 | Bear's Burden | Nalorakk's burden waits for one who proves worthy. Light the incense to begin the trial. | "Incense lit" (1) — CT 229711/229712, Criteria 115317 type 92 asset 104755 |
| 1 | 17226 | Bear's Burden | Nalorakk's burden has appeared. Carry it through the Gates of Trial to his pedestal. | "Trial gates cleared" (**5**) — Criteria 115318 type 92 asset 106184; "Hands dusted with tarsap" (1) — Criteria 116331 type 68 asset 649192; "Burden delivered" (1) — Criteria 115323 type 92 asset 104761 |
| 2 | 17577 | Bear's Burden | The burden has been carried. Now test your strength against Nalorakk's champion. | "**Nesh'ikar defeated**" (1) — CT 230357/230358, Criteria 115791 type 92 asset 105227 |

- Stap 1 heeft twee takken onder CT 229713 (Operator 8): tak 232479 (Flags 8194; daaronder "Hands dusted with tarsap" + "Burden delivered" samen in een sub-tak, plus "Trial gates cleared" 5) en tak 232478 (Flags 2; dezelfde drie doelen). Wat de vlaggen precies kiezen (moeilijkheid?) is NIET gemeten.
- Eindbaas: **Nesh'ikar** (naam GEMETEN uit de doeltekst). Creature-id: NIET gevonden — de Criteria is type 92 (asset = event-id, geen creature-id) en wago's Creature.db2 (23 167 rijen, een client-subset) bevat geen "Nesh'ikar".
- AFGELEID: type 92 = "iemand in de groep triggert een scenario-event", type 68 = "gameobject gebruiken" (TrinityCore-indeling, niet op wago gemeten). Op de tracker zal stap 1 dus als "0/5 Trial gates cleared" verschijnen.
- AFGELEID: dit is MH's naamloze beschrijving "Trial gates (The Cave Towers): light the incense, touch a white-and-gold flower for grip, carry the big rock through 5 green gates … Then Nesh'ikar" (incense = stap 0, tarsap = grip, 5 trial gates, Nesh'ikar = eindbaas).

Naam per locale (ScenarioStep 17225 Title_lang, GEMETEN):

| enUS | deDE | frFR | esES | esMX | ptBR | itIT | ruRU |
|---|---|---|---|---|---|---|---|
| Bear's Burden | Die Bürde des Bären | Fardeau de l’ours | La carga del oso | La carga del oso | Fardo do urso | Fardello dell'orso | Бремя медведя |

(frFR gebruikt een typografische apostrof ’ (U+2019); enUS en itIT een gewone '.)

### Aanvulling Bear's Burden

- Nesh'ikar = **NPC 269188** "Nesh'ikar <Chosen of Nalorakk>", Humanoid, "Added in patch 12.1.5", te vinden in The Labyrinth of Kindo'jan (GEMETEN: Wowhead npc=269188, gelezen 20 okt 2026). Wago heeft hem niet.

### Hoe te lezen (rest van ronde 5)

- Alles hieronder is GEMETEN op wago.tools (build 12.1.5.70448, useHotfixes=1, 20 okt), tenzij er AFGELEID of "Wowhead" bij staat.
- Positieve controle: het scherm toonde "1/6 Defeat Hexbound Defenders" (Soul Survivor) en "0/5 Cursed Energy returned" (Fools and Curses). Beide staan exact zo in CriteriaTree (Amount 6 en 5). Ook 3551 = Graverobbers met "Relic Raiders cleared" en "Drill Sergeant slain" klopt.
- **Kamer** komt uit de interne naam van de bovenste CriteriaTree, bv. "12.1.5 Labyrinth - Chamber 2c - Scenario B - …". Niet elke variant heeft zo'n label ("—" = geen label).
- **Creature-id**: bij Criteria type 0 is het asset het creature-id. AFGELEID uit de TrinityCore-indeling, maar één keer nagemeten: asset 262930 = Wowhead npc=262930 "Sha'Kuro". Bij type 92 (event) staat er geen creature-id in de data.
- **Balk** = doel met Amount 100 en Operator 9 (een voortgangsbalk, AFGELEID). Daaronder hangen events met gewicht 20/8/4/2 (of 10/6/4/2).
- Hotfixes: wago's hotfix-lijst (zoekterm ScenarioStep) toont voor build 70448 o.a. de pushes 112343 / 112461 (stappen 17166 / 17179, A Golden Opportunity) en 112267 (17993, Empty Halls), first seen vanaf 17 okt. De CSV mét en zónder hotfixes is voor alle 221 Labyrinth-stappen gelijk (titel, beschrijving, CriteriaTree).

### 1. Alle kamertaken (enUS)

Elke stap heeft dezelfde titel als de taak (behalve kamer 4 en het einde). Stapnummer = OrderIndex.

#### A Foul Presence — 3699 (1a, "Scenario M - Intro Quest Scenario")
| Stap | Beschrijving | Doel |
|---|---|---|
| 0 | Defeat the rampaging undead. | Undead defeated (12) |
| 1 | Search the chamber for clues. | Clues investigated (4) |
| 2 | Examine the effigy. | Examine the Effigy (1) |
| 3 | Confront the Necromancer! | Jun'ala slain — type 0, **264183** |

#### Malicious Masks — 3470 (1a), 3472 (2a), 3464 (2b), 3474 (2c), 3476 (3a), 3478 (3b), 3479 (3c), 3481 (3d), 3482 (3e)
| 0 | The presence of intruders in the Labyrinth has corrupted ceremonial masks. Cleanse the corruption from the masks. | Corrupted Masks cleansed (3) |
|---|---|---|
| 1 | The spirits have responded to your presence with a challenge. Defeat Grukk! | Grukk slain — type 0, **274331** |

#### Raging Spirits — 3605 (1a-J), 3606 (2a-H), 3607 (2b-H), 3608 (2c-H), 3609 (3a-H), 3610 (3b-J), 3611 (3c-H), 3612 (3d-J), 3613 (3e-I)
| 0 | Pacify the enraged spirits that are wreaking havoc here. | Spirits quelled (balk 100) |
|---|---|---|
| 1 | Face the judgment of the angered spirts! *(Blizzard-typo "spirts")* | Undead Trollbunal slain — type 0, **272655** |

#### Vile Intruders — 3540 (1a-F), 3541 (2a-C), 3430 (2b-A), 3413 (2c-A), 3542 (3a-D), 3510 (3b-D), 3543 (3c-C), 3544 (3d-E), 3538 (3e-D)
| 0 | Fight back the Vilebranch trolls defiling the tomb! | Balk 100: "Repel the Vilebranch" (3413, 3430, 3510, 3538) of "Vilebranch repelled" (3540–3544) |
|---|---|---|
| 1 | Defeat the Sullied Revenant that's been driven mad by the Vilebranch's desecration. | Sullied Revenant slain (3538: "Sullied Revenant Slain") — type 0, **264203** |

Balkgewichten: 20/8/4/2 bij 3413, 3510, 3538; 10/6/4/2 bij 3430, 3540–3544.

#### Reliquary Ritual — 3349 (3a-B)
| 0 | Break the corupted Spirit Reliquaries to stop Sha'Kuro's ritual. *(Blizzard-typo "corupted")* | Corrupted Reliquaries broken (9) |
|---|---|---|
| 1 | Confront the necromancer. | Sha'Kuro confronted (1) |
| 2 | Survive Sha'Kuro's undead minions. | Survive the Undead (Amount 60, Operator 9) |
| 3 | Defeat Sha'Kuro while he's still in a weakened state. | Sha'Kuro slain — type 92 (event 103929), geen creature-id |

Wowhead kent twee NPC's "Sha'Kuro": 262930 en 264495 "<Lich Ascendant>" (beide "Added in patch 12.1.5"). Welke hier vecht is NIET gemeten.

#### Reins of the Warlord / Reigns of the Warlord — twee spellingen in de data!
- "Reins of the Warlord": 3562 (—), 3570 (1A-H), 3576 (3D-H), 3577 (3E-G)
- "Reigns of the Warlord": 3571 (2A-F), 3572 (2B-F), 3573 (2C-F), 3574 (3A-G), 3575 (3B-H)

| 0 | Speak to Warlord Kaz'kara. | Warlord Kaz'kara spoken with |
|---|---|---|
| 1 | Disturb the raptor bones and tame the spirit of Daakajin. | Daakajin tamed |

Geen baas-stap (maar 2 stappen).

#### Taken Antiquities — 9 varianten
| 0 | The Vilebranch / The Relic Raiders are looting artifacts from the Labyrinth. Find and return the artifacts. | Stolen Artifacts collected (10) |
|---|---|---|
| 1 | The … have sent … to stop you. | baas per variant, zie hieronder |

- Vilebranch + Sha'Kuro (type 0, **262930**): 3402 (3b), 3617 (2a) — "The Vilebranch have sent Sha'Kuro to stop you."
- Relic Raiders + Cynthra Buttonsmasher (type 0, **275274**): 3615 (1a), 3618 (2b), 3619 (2c), 3621 (3c), 3622 (3d) — "The Relic Raiders have sent Cynthra Buttonsmasher to stop you."
- Vilebranch + Sullied Revenant (type 0, **264203**): 3620 (3a) — "The Vilebranch have sent the Sullied Revenant to stop you."
- Vilebranch + Jun'ala (type 0, **264183**): 3623 (3e) — "The Vilebranch have sent Jun'ala to stop you."

#### Graverobbers — 3546 (1a-G), 3547 (2a-D), 3552 (2b-D), 3468 (2c-B), 3548 (3a-E), 3511 (3b-E), 3549 (3c-D), 3550 (3d-F), 3551 (3e-E)
| 0 | Stop the Relic Raiders from pillaging the tomb! | Relic Raiders cleared (balk 100) |
|---|---|---|
| 1 | Defeat the Relic Raider leading the pillaging efforts in this chamber. | Drill Sergeant slain — type 0, **273069** |

#### Spirit Thieves — 3345 (2a-B)
| 0 | Put an end to the Vilebranch's necromantic rituals. | Disrupt the Vilebranch (balk 100) |
|---|---|---|
| 1 | Carry the Spirit Reliquaries to the open sarcophagi to return the spirits to rest. | Souls returned (9) |

Geen baas-stap.

#### The Wandering — 3628 (—), 3719 (2b), 3720 (3c)
| 0 | A fractured spirit drifts nearby, disoriented and searching for its resting place. Stay close to it to bring it clarity so it can keep looking. | Vessel found |
|---|---|---|
| 1 | The Remnant's course correction has drawn hostile spirits, and it's feeding on you to keep itself shielded. Keep it safe and see it to its true vessel. | True vessel found |

Geen baas-stap.

#### Returning the Bounty — 3442 (—), 3446 (2b), 3666 (—)
| 0 | That doesn't look like it belongs to them. | Investigate the Ancient Harvest Bundle |
|---|---|---|
| 1 | Such hoarding is an abomination! Cut them down! | Hoarding Looters Defeated (10); Recover Stolen Goods (5) = Old Hekra's Honeypot Recovered, Rujak's Very Large Onion Recovered, Jindara's Favorite Mushroom Recovered, Zan'ji's Wheel of Cheese Recovered, Kazrak's Grain Sack Recovered |
| 2 | With their taproot exposed, the hoarder weeds can be fully cleared out. | Pit Boss slain — type 0, **266370** (interne naam "Defeat the Looter Excavator") |
| 3 | BOUNTIFUL HARVEST FOR THE VICTORS! | Run through and collect as much as you can before time runs out |

#### Fools and Curses — 3537 (1a), 3554 (2a), 3555 (2b), 3556 (2c), 3557 (3a), 3558 (3b), 3559 (3c), 3560 (3d), 3561 (3e)
| 0 | Relic Raiders have opened a cursed Sarcophagus. Find the Cursed Relic Raiders and return the Cursed Energy to the Sarcophagus. | Cursed Energy returned (5) |
|---|---|---|

Maar 1 stap, geen baas.

#### Encroaching Darkness — 3658 (1a), 3659 (2a), 3483 (2c)
| 0 | Strange voices echo through the halls, and they don't sound friendly. | Voices investigated |
|---|---|---|
| 1 | Find a light to purge the darkness. | Found light |
| 2 | Purge the trap-released darkness. | Flames of Jan'alai lit (4) |
| 3 | Dispatch remaining trap-released Rage Specters. | Rage Specters defeated (6) — type 92 |

Geen losse baas.

#### Soul Survivor — 3484 (—), 3580 (1a-I), 3581 (2a-G), 3582 (2b-G), 3583 (2c-G), 3585 (3b-I), 3587 (3c-G), 3588 (3d-I), 3589 (3e-H)
| 0 | Defeat Hexbound Defenders to release the Soul King from bondage. | Defeat Hexbound Defenders (6) — type 0, 262929 |
|---|---|---|
| 1 | Defeat the King of Souls. (3582: "Defeat the King of Souls,") | King of Souls defeated — type 0, **269822** |

#### Bear's Burden — 3403 (geen kamerlabel) — zie SPOED hierboven.

#### Soul Catcher — 3409 ("3D - Scenario C"), 3674 (3c), 3679 (3a)
| 0 | Disperse the lost souls to cut off the ritualists' power and bring down the barrier. | Lost Souls Dispersed (7); Head Ritualist Ja'an slain (type 0, 263876); Head Ritualist Zol'go slain (type 0, 263877) |
|---|---|---|
| 1 | Slay Malakk to bring down the second barrier. | Head Ritualist Malakk slain — type 0, 263898 |
| 2 | Slay the Vile Wraith to end the dark rites bought with these souls. | Sha'Kuro slain — type 0, **262930** |

#### Restless Dead — 3426 (1a, "Scenario X")
| 0 | Something's not right here. What has stirred these souls? | Ritual Circle investigated |
|---|---|---|
| 1 | Bound souls are anchoring the ritual. | Withering Souls defeated (4) — type 0, 265041 |
| 2 | Return the relics to calm the spirits. | Relics returned (3) |
| 3 | Confront the Necromancer! | Vilebranch Necromancer defeated — type 0, **264183** (zelfde id als "Jun'ala slain") |

#### A Golden Opportunity — 3443 (3c; stap 1 heeft label "3b"), 3447 (3d)
| 0 | Pull the Golden Lever to start the challenge. | Challenge started |
|---|---|---|
| 1 | Collect as much treasure from the room before the timer expires. | Room looted |

Geen baas.

#### Ritual Ruination — 3504 (—)
| 0 | Interupt the ritual before completion. *(Blizzard-typo "Interupt")* | Stop the Ritual (andere tak: "Ritual Successful", Flags 8194) |
|---|---|---|
| 1 | Defeat Spirit of Retribution. | Defeat Spirit of Retribution — type 0, 270670 |
| 2 | Defeat Riv'iki. | Defeat **Bone-Flayer Riv'iki** — type 0, **270594** |

#### Setting Things Right — 3512 (—), 3663 (3a), 3664 (3b) (Scenario.Type 0; de andere kamers Type 8)
| 0 | Help the Ancestral Shaman restart his ritual. | Ritual items fixed (3) |
|---|---|---|
| 1 | Protect the Ancestral Shaman while he completes the ritual. | Ritual completed (andere tak: "(Hidden) Shaman takes enough damage to lose concentration") |
| 2 | Defeat the Enraged Death Steward. | Enraged Death Steward slain — type 0, **271909** |
| 3 | Defeat the Enraged Ancestral Shaman. | Enraged Ancestral Shaman slain — type 92, geen creature-id (Wowhead-zoektocht: geen NPC) |

Of stap 2 en 3 allebei komen, of dat 3 alleen volgt na de "Hidden"-tak, is NIET gemeten.

#### Containment Breach — 3524 (—)
| 0 | Defeat the cultists snuffing the flaming wards of Jan'alai. | Umbral Wardbreakers slain (4) — type 0, 271409 |
|---|---|---|
| 1 | Reveal the Prisoner by re-lighting the Flames of Jan'alai with Jan'alai Tears. | Flames re-lit (4) |
| 2 | Defeat the Prisoner. | The Prisoner vanquished — type 92. Wowhead: NPC **271525** "The Prisoner", Elite, Undead, The Labyrinth of Kindo'jan |

#### Geen kamertaak (tussenstap, kamer 4, einde)
| Titel | Scenario | Beschrijving | Doel |
|---|---|---|---|
| Choose Your Path | 3342 | Select the next chamber you wish to challenge in the Labyrinth, or speak to Kinduru if you wish to end your run. | Path chosen; (Optional) Speak to Kinduru |
| Heart of the Labyrinth | 3444 stap 0 | Approach De Empire's Rest and face the challenges ahead. | Heart of the Labyrinth approached |
| Enemy of the Labyrinth | 3444 stap 1 | The Vilebranch necromancer, Den'zara, seeks to defile the souls of the Labyrinth. Stop them at all costs. | Den'zara slain (type 92). Wowhead: NPC 266742 "Den'zara <Vilebranch Warlord>" |
| Soul of the Labyrinth | 3444 stap 2, 3678 stap 0 | Kindo'jan, the First Hash'ey, desires a worthy challenge. Prove yourself to the spirit! | Kindo'jan defeated (type 92). Wowhead: NPC 266500 "Kindo'jan <The First Hash'ey>" |
| Soul Put to Rest | 3678 stap 1, 3706 | Kindo'jan has been defeated. Claim your prize! | Kinduru spoken to (3706: Speak to Kinduru) |
| Empty Halls | 3721 | You have cleared all chambers of the labyrinth. Finish your exploring and speak to Kinduru when you're ready to leave. | Speak to Kinduru to end your run |

### 2. Taaknaam per locale (ScenarioStep.Title_lang, GEMETEN)

| enUS | deDE | frFR | esES | esMX | ptBR | itIT | ruRU |
|---|---|---|---|---|---|---|---|
| A Foul Presence | Eine faule Präsenz | Une présence malfaisante | Una presencia vil | Una presencia aberrante | Presença Putrefata | Presenza Immonda | Пагубная аура |
| Malicious Masks | Bösartige Masken | Masques malveillants | Máscaras maliciosas | Máscaras maliciosas | Máscaras maliciosas | Maschere maligne | Злобные маски |
| Raging Spirits | Wütende Geister | Esprits déchaînés | Espíritus enfurecidos | Espíritus enfurecidos | Espíritos enraivecidos | Spiriti Furenti | Разъяренные духи |
| Vile Intruders | Blutfratzen-Eindringlinge | Intrusion ignoble | Intrusos malvados | Intrusos malvados | Intrusos torpes | Intrusi vili | Гнусные захватчики |
| Reliquary Ritual | Reliquienritual | Rituel du Reliquaire | Ritual del relicario | Ritual del relicario | Ritual do relicário | Rituale del Reliquiario | Ритуал Реликвария |
| Reins of the Warlord | Zügel des Kriegsfürsten | Rênes du seigneur de guerre | Las riendas del señor de la guerra | Las riendas del señor de la guerra | Rédeas do Senhor da Guerra | Redini del Signore della Guerra | Воля вождя |
| Reigns of the Warlord | Zügel des Kriegsfürsten | Règnes du seigneur de guerre | Las riendas del señor de la guerra | El reinado del señor de la guerra | Rédeas do Senhor da Guerra | Regni del Signore della Guerra | Воля вождя |
| Taken Antiquities | Gestohlene Antiquitäten | Antiquités volées | Antigüedades arrebatadas | Antigüedades tomadas | Antiguidades roubadas | Antichità prese | Похищенные древности |
| Graverobbers | Grabräuber | Pillage de tombe | Profanadores | Profanadores | Roubacovas | Tombaroli | Грабители могил |
| Spirit Thieves | Geisterdiebe | Esprits voleurs | Ladrones espirituales | Ladrones de espíritus | Ladrões de espíritos | Ladri spirituali | Похитители духов |
| The Wandering | Die Wanderung | L’esprit errant | El espíritu errante | El errante | A errância | L'errante | Скитания |
| Returning the Bounty | Den Reichtum zurückbringen | Restituer la prime | Devolver el botín | La devolución del botín | Devolvendo a recompensa | Restituire il bottino | Возвращение сокровищ |
| Fools and Curses | Narren und Flüche | Maudits inconscients | Maldiciones e insensatos | La insensatez y las maldiciones | Tolos e maldições | Sciocchi e maledizioni | Глупцы и проклятия (3537: Глупцы и проклятья) |
| Encroaching Darkness | Übergreifende Dunkelheit | Ténèbres envahissantes | Oscuridad invasora | Oscuridad invasora | Escuridão invasora | Oscurità opprimente | Надвигающаяся тьма |
| Soul Survivor | Überlebende Seele | Âme en sursis | Alma superviviente | Sobreviviente esencial | Alma sobrevivente | Un'anima sopravvissuta | Уцелевшая душа |
| Bear's Burden | Die Bürde des Bären | Fardeau de l’ours | La carga del oso | La carga del oso | Fardo do urso | Fardello dell'orso | Бремя медведя |
| Soul Catcher | Seelenfängerin | Attrape-âmes | Atrapaalmas | Atrapaalmas | Apanhadora de Almas | Mietitrice di Anime | Ловец душ |
| Restless Dead | Ruhelose Tote | Mort sans repos | Muertos insomnes | Muerte sin descanso | Mortos inquietos | Morti irrequieti | Неупокоенные |
| A Golden Opportunity | Eine goldene Gelegenheit | Une occasion en or | Una oportunidad de oro | Una oportunidad de oro | Oportunidade de ouro | Un'opportunità d'oro | Блестящая возможность |
| Ritual Ruination | Das ruinierte Ritual | Interruption de rituel | Arruinar el ritual | Ruina del ritual | Arruinando o ritual | Distruzione del rituale | Разгром ритуала |
| Setting Things Right | Fassung bewahren | Problème à régler | Arreglando las cosas | Las cosas en orden | Acertando as contas | Mettere le cose a posto | Все на своем месте |
| Containment Breach | Eindämmungsriss | Rupture de confinement | Brecha en la contención | Falla de contención | Rompimento de contenção | Breccia del Contenimento | Брешь в защите |
| Choose Your Path | Wählt Euren Weg | Choisir sa voie | Elige tu camino | Elige tu camino | Escolha seu caminho | Scegli la tua strada | Выберите свой путь |
| Heart of the Labyrinth | Herz des Labyrinths | Le cœur du labyrinthe | El corazón del laberinto | Corazón del laberinto | Coração do Labirinto | Cuore del Labirinto | Сердце Лабиринта |
| Enemy of the Labyrinth | Feind des Labyrinths | Adversaire du labyrinthe | Enemigo del laberinto | Enemigo del laberinto | Ameaça ao Labirinto | Nemico del Labirinto | Враг Лабиринта |
| Soul of the Labyrinth | Seele des Labyrinths | L’âme du labyrinthe | Alma del laberinto | Alma del laberinto | Alma do Labirinto | Anima del Labirinto | Душа Лабиринта |
| Soul Put to Rest | Die Seele zur Ruhe betten | Âme apaisée | Alma en paz | Alma que descansa en paz | Alma em paz | Anima a riposo | Упокоенная душа |
| Empty Halls | Leere Hallen | Salles vides | Cámaras vacías | Salones vacíos | Salões Vazios | Sale vuote | Пустые залы |

frFR gebruikt soms een typografische apostrof ’ (U+2019): "L’esprit errant", "Fardeau de l’ours", "L’âme du labyrinthe".

### 3. Vergelijking met MH's huidige namen

Spelling (GEMETEN tegen enUS Title_lang):
- Alle 14 MH-namen bestaan letterlijk in de data: A Foul Presence, Malicious Masks, Raging Spirits, Vile Intruders, Reliquary Ritual, Reigns of the Warlord, Taken Antiquities, Graverobbers, Spirit Thieves, The Wandering, Returning the Bounty, Fools and Curses, Encroaching Darkness, Soul Survivor.
- **Let op "Reigns of the Warlord"**: Blizzard gebruikt ook "**Reins** of the Warlord" (scenario's 3562, 3570, 3576, 3577). MH moet beide herkennen. In frFR, esMX en itIT zijn het ook twee verschillende namen (Rênes/Règnes, riendas/reinado, Redini/Regni). In deDE, esES, ptBR en ruRU is het één naam.
- **"Rav'iki" is fout gespeld**: de data zegt "Bone-Flayer **Riv'iki**" (doel "Defeat Bone-Flayer Riv'iki", stap "Defeat Riv'iki.").
- ruRU Fools and Curses: 3537 schrijft "проклятья", de andere 8 "проклятия".

Taken die NIET in MH's lijst staan (GEMETEN dat ze bestaan): **Bear's Burden, Soul Catcher, Restless Dead, A Golden Opportunity, Ritual Ruination, Setting Things Right, Containment Breach**. Daarnaast de stappen die geen kamertaak zijn: Choose Your Path, Heart of the Labyrinth, Enemy of the Labyrinth, Soul of the Labyrinth, Soul Put to Rest, Empty Halls.

MH's naamloze beschrijvingen gekoppeld aan de echte naam. De koppeling is AFGELEID: ik heb de namen en doelen in de data naast MH's tekst gelegd.

| MH-beschrijving | Echte naam | Scenario's | Waarom |
|---|---|---|---|
| Head ritualists: kill Ja'an and Zol'go … then Malakk and Sha'Kuro | **Soul Catcher** | 3409, 3674, 3679 | doelen Head Ritualist Ja'an / Zol'go → Malakk → Sha'Kuro |
| Ritual items: put back the mask, the candle and the torch … then the Death Steward | **Setting Things Right** | 3512, 3663, 3664 | "Ritual items fixed" (3) → … → Enraged Death Steward. Let op: er is nog een 4e stap, "Enraged Ancestral Shaman slain" |
| Golden lever: pull it, then loot the room | **A Golden Opportunity** | 3443, 3447 | "Pull the Golden Lever …" → "Room looted" |
| Trial gates (The Cave Towers): incense … 5 green gates … Then Nesh'ikar | **Bear's Burden** | 3403 | Incense lit → Trial gates cleared (5) → Nesh'ikar defeated |
| Bone-Flayer Rav'iki (stop the ritual) | **Ritual Ruination** | 3504 | Stop the Ritual → Spirit of Retribution → Bone-Flayer **Riv'iki** |
| The Prisoner (kill 4 Umbral Wardbreakers, carry tears … to 4 flames) | **Containment Breach** | 3524 | Umbral Wardbreakers slain (4) → Flames re-lit (4) → The Prisoner vanquished |

Geen MH-beschrijving gevonden voor **Restless Dead** (3426: Ritual Circle → 4 Withering Souls → 3 relics → Vilebranch Necromancer).

Niet gemeten / open:
- Creature-id's van de event-bazen (Nesh'ikar, Den'zara, Kindo'jan, The Prisoner) komen alleen van Wowhead, niet uit de DB2. Voor Enraged Ancestral Shaman en voor de Sha'Kuro van Reliquary Ritual (event 103929) is er geen id.
- In welke kamer 3403 (Bear's Burden), 3442/3666, 3484, 3504, 3512, 3524, 3562 en 3628 vallen, staat niet in hun CriteriaTree-label. Kamer 3403 = The Cave Towers komt uit de opdracht (AreaTable 17033), en heb ik in deze ronde niet zelf nagemeten.
