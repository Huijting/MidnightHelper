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
