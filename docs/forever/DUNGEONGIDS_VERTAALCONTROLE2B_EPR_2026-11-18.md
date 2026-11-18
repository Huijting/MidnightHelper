# Vertaalcontrole bazengids stap 2b: esES, esMX, ptBR, ruRU (controleur EPR, 18 nov 2026)

Gecontroleerd: alle 445 sleutels van ST, BRD, DIRE, BRS, BMAW, SHAPER, SCHOLO, STRAT en de 7 nieuwe `FDGP_*`, regel
voor regel tegen `enUS.lua` r. 5861-6305. Packs: `ForeverClassQuests_esES.lua` r. 762-1206, `_ptBR.lua` r. 716-1160,
`_ruRU.lua` r. 531-975 (elk 445 regels, zelfde volgorde) en de 40 overlayregels in `_esMX.lua` r. 158-199. Daarnaast de
naamplaatje-check (`dg2_plate_changes.tsv`) over ALLE `FDG_*`-regels. Repo niet aangeraakt, `probe_job.txt` niet gebruikt.

Verbeterde regels: `dg2y_esES.txt` (7), `dg2y_esMX.txt` (8), `dg2y_ptBR.txt` (5), `dg2y_ruRU.txt` (4).

## Telling

| taal | FOUT (bevindingen / regels) | RISICO | in dg2y |
|---|---|---|---|
| esES | 3 / 5 | 2 (+2 info) | 7 |
| esMX (overlay) | 4 / 8 | 2 (geen wijziging) | 8 |
| ptBR | 3 / 3 | 2 | 5 |
| ruRU | 1 / 1 | 2 | 4 |

## esES

- **FOUT, `FDG_BRD_12_D1` "Espera en El Taller".** De esES-client noemt de Manufactory "La Fábrica": WMOAreaTable Forever
  1.60.1.70959 esES rij 26781 (WMO 2213, de klassieke BRD, ook in Classic Era 1.15.9.70576) en rij 147926 (WMO 21773,
  alleen in Forever) zeggen allebei "La Fábrica" (GEMETEN). Alleen WMO 12700 (ook in retail) zegt "El Taller", en dat is
  de esMX-naam (esMX 26781, 100232, 147926: "El Taller", GEMETEN). Nieuw: "Espera en La Fábrica; …".
  Let op: esMX erft deze regel. Wordt esES aangepast, dan is de esMX-overlay `FDG_BRD_12_D1` met "El Taller" nodig
  (staat in `dg2y_esMX.txt`).
- **FOUT, `FDG_STRAT_17_D2` wie-doet-wat.** Engels: "open the Service Gate and he runs to a spot just before the
  Slaughter Square". esES: "abre la Entrada de Servicio y corre a un sitio …": na de gebiedende wijs "abre" leest "corre"
  ook als gebiedende wijs, dus "ren jij" (AFGELEID, taalkennis). ptBR ("ele corre") en ruRU ("он убежит") zijn wel goed.
  Nieuw: "… y él corre a un sitio justo antes de la Plaza Degolladero."
- **FOUT, "coger" in 3 regels: `FDG_BRD_16_D2` "coger demasiadas jarras", `FDG_BRD_19_D1` "coge antorchas",
  `FDG_DIRE_8_D3` "coge esa llave".** De addon-CLAUDE.md zegt: "The esES pack itself avoids "coger" (vulgar in Mexico)", en
  esMX-spelers krijgen deze esES-regels (GEMETEN: dit zijn de enige drie "coger"-vormen in het hele Forever-esES-pack;
  grep, positieve controle = deze drie treffers). Nieuw: "tomar"/"toma". (`FDG_BRD_19_D1` staat ook in de esMX-overlay,
  zie daar.)
- **RISICO, `FDG_DIRE_3_D2` "Se divide en pequeños elementales de agua".** Engels "Splits off small water elementals": hij
  blijft zelf staan en laat kleintjes los. "Se divide en" = hij valt uiteen in kleintjes (AFGELEID). ptBR "Solta" en ruRU
  "Отделяет от себя" zeggen het goed. Nieuw: "Desprende pequeños elementales de agua que hieren más que él."
- **RISICO (laag), `FDG_BRS_4_D2` "por los diseños de un hacha rara".** Engels: één plan ("a rare axe plan"); "los
  diseños" is meervoud. Nieuw: "por un diseño raro de hacha." (AFGELEID)
- Info, geen wijziging: "Santuario de Thaurissan" (`FDG_BRD_5_D1`, `_9_D3`) en "Bastión Escarlata" (`FDG_STRAT_6_D3`,
  `_7_D1`, `_8_D1`) kloppen met de Forever-only WMO's (21773 "Santuario de Thaurissan", 21107 "El Bastión Escarlata"),
  maar de klassieke WMO's zeggen "Ruinas de Thaurisan" (2213) en "La Basílica Escarlata" (3454) (alle GEMETEN, Forever
  WMOAreaTable esES). Dat Forever de nieuwe WMO's gebruikt is AFGELEID: 21773/21107 staan alleen in Forever, niet in Classic
  Era 1.15.9 en niet in retail 12.1.5 (GEMETEN). Zelfde reden voor "El Lyceum" (2213) tegen "Lyceum" (21773): onschuldig.
- Gecontroleerd, géén fout: "Trastos wow de torio" en "Taje ogro de Gordok" (`FDG_DIRE_9_D2`, `_10_D3`) zijn echt de
  esES-clientnamen (ItemSparse 15994, 18258, GEMETEN), ook al lezen ze vreemd. "Llave Sombratiniebla" (item 11000) naast
  "Vigilantes de la Llama Forjatiniebla" (npc 9956) is ook echt zo in de client (GEMETEN). "Roughshod Pike" blijft Engels:
  esES ItemSparse 12533 is leeg (GEMETEN), dus niet te meten.

## esMX (overlay)

- **FOUT, "mazmorra" in 3 overlayregels: `FDG_BRS_6_D1`, `FDG_SCHOLO_1_D2`, `FDG_SCHOLO_7_D1`.** esMX zegt "calabozo":
  GlobalStrings Forever esMX LFG_TYPE_DUNGEON / CALENDAR_TYPE_DUNGEON "Calabozo", DUNGEONS "Calabozos"; esES "Mazmorra(s)"
  (GEMETEN). Het esMX-bestand zegt het zelf (r. 155): "esMX says "calabozo" where esES says "mazmorra"". Nieuw: "Antes en el
  calabozo", "al principio del calabozo", "conjunto de calabozo 2".
- **FOUT, 3 esES-regels met "mazmorra" zonder overlay: `FDG_BRD_8_D1`, `FDG_BRS_L3`, `FDG_BMAW_1_D1`.** esMX-spelers
  zien nu "mazmorra" (GEMETEN: grep esES-pack "mazmorra" in FDG-regels = precies deze 6 sleutels + FDG_NONE/HINT, die al
  een overlay hebben). Drie nieuwe overlayregels met "calabozo".
- **FOUT, `FDG_BRD_19_D1` overlay "coge antorchas".** Zelfde "coger"-regel als bij esES; in Mexico grof. Nieuw: "toma
  antorchas" (de rest van de regel ongewijzigd, ook de Engelse placeholder-naam).
- **FOUT (voorwaardelijk), `FDG_BRD_12_D1`.** Alleen nodig als de esES-fix ("La Fábrica") wordt toegepast: dan overlay
  "Espera en El Taller; …" (esMX-client "El Taller", GEMETEN, zie esES).
- **RISICO, Engelse placeholder-namen in 11 overlayregels:** `FDG_BRD_8_D2` (Watchman Doomgrip), `FDG_BRD_14_D1`
  (Private Rocknot), `FDG_BRD_19_D1` (Shadowforge Flame Keepers), `FDG_DIRE_5_D1` (Old Ironbark), `FDG_BRS_12_D2` en
  `_12_T` (Rookery Hatcher), `FDG_STRAT_5_D1` (Stratholme Courier), `FDG_STRAT_9_D1` (Crimson Riflemen), `FDG_STRAT_13_T`,
  `_14_T`, `_16_T` (Thuzadin Acolyte). Wowhead esMX geeft voor al deze npc's "[Engelse naam]" (GEMETEN), dus de esMX-naam
  is niet te meten. Maar de kop van `ForeverClassQuests_esMX.lua` (r. 15-16) zegt: "A name Wowhead shows [bracketed] in
  esMX is not measured: the esES name stays in the line." Stap 2a deed het ook al met Engels (ZF_6_D1, ZF_8_D1). Twee
  regels in één bestand die elkaar tegenspreken: één keuze maken. Extra bij de drie Acolyte-regels: het Engels zegt alleen
  "every Acolyte" en esES "cada Acólito" (gewoon Spaans woord, geen naamclaim); daar maakt de overlay de tekst
  Engelser dan nodig. Niet aangepast in dg2y.
- **RISICO (laag), `FDG_SCHOLO_1_D1` overlay is letterlijk gelijk aan esES.** "Llave esqueleto", "La llave de Scholomance",
  "Carga de seforio potente", "Ganzúa" zijn in esMX gelijk aan esES (GEMETEN). Onschuldig, wel tegen "geen kopie van esES".
- Verder klopt elke overlayregel met de esMX-client (GEMETEN): Segasueños, Maestro de canes Grebmar, Santuario de
  Thaurissan + Llave de Forjatiniebla, Condena'rel, abalorio, Zevrim Pezuñahendida, Aceite de Escarcha + Trasto de torio,
  Disfraz de ogro Gordok, mano derecha (3×), Cumbre de Roca Negra superior/inferior (LFGDungeons 31/43), Gizrul el
  Esclavista, Llama paternal (object 175245), Rend (npc 10429/10339), Pica férrea, Cabeza de Omokk, Sangre inocente,
  Administradora de sangre de Kirtonos, Bolsa de los horrores de Krastinov, Marduk, Libro de Memorias del Alma, Ras
  Murmuhielo, Gassol, Medallón de fe, Bastión Escarlata.
- Volledigheid (GEMETEN + AFGELEID): alle esES-namen in 2b-teksten die in esMX anders zijn, hebben een overlay. Waar esMX
  dezelfde naam heeft (Mizzle el Astuto, Guardia de élite cromático, Vigilasangre Hakkari, Ogom el Desdichado, Gran Cruzado
  Dathrohan, Eva Sarkhoff, Smokey LaRue, Llave creciente, Llave de la ciudad, Llave de la Sala de visión, Gambito del
  Alba, La súplica de un muerto, Tragapenas, Sala Rectoral, Plaza Degolladero, enz.) is geen overlay nodig.

## ptBR

- **FOUT, `FDG_STRAT_6_D1` "Quadra do Cruzado".** Clientnaam "Praça dos Cruzados" in alle drie de Stratholme-WMO's
  (WMOAreaTable Forever ptBR rij 32319, 92112, 143682, GEMETEN). Nieuw: "Aparece na Praça dos Cruzados …".
- **FOUT, `FDG_SCHOLO_8_D1` "Gabinete do Diretor".** De klassieke Scholomance-WMO 3293 zegt "Estúdio do Diretor"
  (rij 31739 en 32581, GEMETEN). "Gabinete do Diretor" komt uit WMO 6746 (rij 57510), de MoP-versie met Hall of
  Illusions, Headmaster's Retreat en Butcher's Sanctum (GEMETEN enUS). Dat Forever (klassieke bazen, map 289) WMO 3293
  gebruikt is AFGELEID. Nieuw: "… ao redor do Estúdio do Diretor …".
- **FOUT, `FDG_SCHOLO_6_T` aanspreekvorm.** "Limpe …, interrompam …, mantenha-o": "interrompam" is vocês midden in een
  você-zin. In alle `FDG_*`-regels van het pack staat dit meervoud maar 1× (deze), de você-gebiedende wijs 95× (grep,
  GEMETEN). Nieuw: "interrompa os feitiços de gelo dele por turnos" (zoals esES "interrumpe … por turnos").
- **RISICO, `FDG_BRS_13_D3` "usam uma estaca".** Het questitem heet in ptBR "Pique Manchado de Sangue" (ItemSparse 12848,
  GEMETEN), en `FDG_BRS_6_*` zegt ook "pique". Nieuw: "usam um pique no corpo dele".
- **RISICO (laag), `FDG_DIRE_13_D1` "Uma árvore gigante; quando você o puxa".** Na het vrouwelijke "árvore" leest "o" als
  een fout (AFGELEID). Nieuw: "quando você a puxa".
- Gecontroleerd, géén fout: "Leandro Leonardo" (Smokey LaRue, npc 11033), "Diabretão" (Pimgib), "Fera" (Ferra),
  "Ruine'rel", "Recruta Pedroso", "Ez'Magg", "Janice": dat zijn echt de ptBR-naamplaatjes (GEMETEN).

## ruRU

- **FOUT, `FDG_SCHOLO_8_D1` "Кабинета ректора".** Klassieke WMO 3293: "Кабинет Директора" (rij 31739, 32581, GEMETEN);
  "Кабинет ректора" is de MoP-WMO 6746 (rij 57510). Zelfde redenering als ptBR. Nieuw: "… вокруг Кабинета Директора …".
- **RISICO (laag), `FDG_BRD_5_D1` en `FDG_BRD_9_D3` "в святилище Тауриссана".** Clientnaam "Святилище Тауриссана" met
  hoofdletter (WMO 2213, 12700 en 21773 ruRU, GEMETEN); de rest van het pack schrijft plekken zoals de client (Черное
  Хранилище, Зал Ремесла, Гробница Заклинателей). Nieuw: "в Святилище Тауриссана".
- **RISICO (grammatica), `FDG_WC_2_D1` (stap 1, door de naamplaatje-ronde veranderd):** "что и у босса Повелительница
  Анакондра": na "у" hoort de genitief; de oude naam "Леди Анакондра" verboog niet, de nieuwe wel (AFGELEID). Engels:
  "Same druid spells as Anacondra." Nieuw: "Те же друидские заклинания, что и у Повелительницы Анакондры." (naam npc 3671
  ruRU "Повелительница Анакондра", GEMETEN)
- Gecontroleerd, géén fout: "древних сундуков" voor de Relic Coffers past bij de client: item 11078 ruRU "Ключ от
  древнего сундука" (GEMETEN). "Tor'Rel" blijft Engels (placeholder, bekende keuze).

## Naamplaatje-check (`dg2_plate_changes.tsv`, alle `FDG_*`)

- **esES: 0 oude namen.** Grep op Verdetez, Mamporro, Cocinitas, vigía ciego, Ward, Portavoz, Faucepeste (plus de nieuwe
  namen) gaf alleen `FDG_RFD_2_D1` en `_2_T` met de NIEUWE naam "Fauzpeste" (= positieve controle; npc 7356 esES
  "Fauzpeste el Putrefacto", GEMETEN). De andere zes bazen staan in geen enkele esES-FDG-tekst.
- **esMX: in orde.** De esMX-naamplaatjes zijn juist de OUDE esES-namen: 7356 "Faucepeste el Podrido", 647 "Capitán
  Verdetez", 646 "Don Mamporro", 645 "Cocinitas", 4279 "Odo el Vigía Ciego", 1663 "Dextren Ward", 4428 "Portavoz de la
  muerte Jargba" (Wowhead Forever esMX, GEMETEN). Alleen Faucepeste komt in een tekst voor, en die overlay
  (`FDG_RFD_2_D1`, `_2_T` met "Faucepeste") bestaat en klopt.
- **ptBR:** staat niet in de lijst; niets te doen.
- **ruRU: 0 oude namen** (grep op stammen Анакондр, Вечноживущ, Сильверлейн, Спрингвейл, Электрошокер, Анжинер, Злоклык,
  Волшебник крови, Ирод, каменный хранитель, Гидромантк, Жрец Тьмы Шезз, Песчаный Череп, Келебрас, Обвал; positieve
  controle: "Анакондр" vindt de nieuwe naam in `FDG_WC_2_D1`). Nieuwe namen 3671, 7275, 12225 ruRU GEMETEN. Wel de
  grammatica-opmerking bij `FDG_WC_2_D1` hierboven.

## Wat ik gemeten heb (18 nov 2026; Forever = build 1.60.1.70959; WHT = Wowhead Forever tooltip-JSON)

- **npc's, WHT in esES, esMX, ptBR, ruRU (40 per taal):** 8438, 5711, 9503, 9039, 9956, 11491, 14349, 14308, 14353,
  10683, 10814, 10339, 14861, 11216 (Eva Sarkhoff), 11033, 11082, 11054, 10812, 10399, 10917, 10799, 9042, en als
  steekproef op het `names`-veld 5721, 5720, 9319, 9476, 9499, 9502, 11490, 10596, 10429, 10433, 10508, 11143, 10584,
  14324, 11487, 10503, 9041, 247207. Alle namen in de esES-, ptBR- en ruRU-teksten kloppen, ook de naamvallen in ruRU
  (Огомом Презренным, Рядовому Камнеузлу, Рок'релом, со Стариком Железной Коры, Миззлом Умельцем, Дымка ЛаРу, Аурия).
  esMX-placeholders: 9503, 9956, 11491, 14349, 14308, 10683, 11082, 11054, 10399, 10917, 9476.
- **Items, DB2 ItemSparse (4 talen):** 3829, 7146, 10465, 10999, 11000, 11140, 11309, 12382, 12533, 12534, 12845, 13523,
  13624/13752, 13704, 13725, 13873, 15994, 18249, 18258, 18594, 12847/12848; Seal of Ascension 12344 heeft geen
  ItemSparse-rij en WHT geeft in alle 4 talen een placeholder: de vertalingen (Sello de ascensión, Selo da Ascensão,
  Печать Вознесения) kloppen met de gemeten zuster-items 12219/12323/12324 (AFGELEID, goed). Alles klopt.
- **Plekken, DB2 WMOAreaTable Forever (4 talen, plus WMOID):** Pit of Refuse, Hall of Blackhand, Rookery, East/West
  Garrison, Shrine of Thaurissan, Dark Iron Highway, Grim Guzzler, Black Vault, Hall of Crafting, Lyceum, Imperial Seat,
  Manufactory, Summoners' Tomb, Viewing Room, Laboratory, Headmaster's Study, Slaughter Square, Crusaders' Square,
  Scarlet Bastion, Slaughter House. Ter vergelijking Classic Era 1.15.9.70576 en retail 12.1.5.70961 (esES).
  Niet in AreaTable/WMOAreaTable (positieve controle: Blackrock Depths, Grim Guzzler wel): Ring of Law (wel DB2
  DungeonEncounter 230, klopt), Black Anvil, Immol'thar's prison.
- **Dungeon-/vleugelnamen:** LFGDungeons Forever 29, 31, 33, 35, 37, 39, 43 (Cumbre de Roca Negra Superior/Inferior,
  Pico da Rocha Negra …, Верхняя/Нижняя часть пика Черной горы; Este/Oeste/Norte, Leste, Восток …): alle FDGP-woorden
  kloppen. Main Gate / Service Gate staan niet in Forever-LFGDungeons; retail 12.1.5 LFGDungeons 40 en 274 geven
  Entrada Principal / Entrada de Servicio (es, esMX), Portão Principal / Entrada de Serviço, Главные врата / Черный ход:
  klopt.
- **Quests, WHT:** 4771 Gambito del Alba / Aposta da Aurora / Рассветный гамбит; 8945 La súplica de un muerto / Súplica de
  um morto / Просьба мертвеца; 5505 La llave de Scholomance / A chave para Scolomântia / Ключ от Некроситета: kloppen.
- **Objects, WHT:** 175245 Father Flame, 169243 Chest of The Seven, 161495 Secret Safe, 160836 Relic Coffer: kloppen.
- **Overig:** SkillLine 633 Lockpicking (Ganzúa, Arrombamento, Вскрытие замков); GlobalStrings LFG_TYPE_DUNGEON es/esMX.
- **Taal en vorm:** geen recht `"` in de tekst (grep met 3 aanhalingstekens: 0; positieve controle met 2: 445 per pack),
  geen markup in deze sleutels, getallen en volgorde (eerst/als laatste, tank/healer/ranged/melee), "optional" en "rare"
  in alle drie de talen gelijk aan het Engels. Aanspreekvorm: esES tú (geen usted/vosotros, grep), ptBR você (op
  `FDG_SCHOLO_6_T` na), ruRU вы (geen ты-vormen, grep). Item-rollen: Main Hand, trinket, two-hand overal volgens
  stat_words; Main Hand ≠ One-Hand overal goed.

## Niet te meten (dus in orde zoals het staat)

Black Anvil, Archival Panel, Titan Panel, Tor'Rel (bekende keuzes); Roughshod Pike in esES (lege ItemSparse-rij);
flesh maggots, ritualists, smoke shop, Blacksmithing Plans (gewone woorden). Welke WMO-versie de Forever-client écht
toont, is alleen in het spel te zien: de esES-info hierboven en de twee Headmaster's Study-fouten hangen daaraan.
