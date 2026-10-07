# Onderzoek 7 okt 2026 — Moxie in de clienttalen + Tormented Tantalum

Alleen onderzoek. Er is geen code, geen locale en geen git aangeraakt.
Labels: **GEMETEN** = zelf gezien in een bron met naam en datum. **AFGELEID** = mijn redenering.
**KANDIDAAT** = wat een externe bron (gids, forum, reactie) beweert, niet in de client of DB2 bevestigd.

---

## Kort

- **Moxie heet in geen enkele clienttaal "Moxie".** de *Tatkraft*, fr *Aplomb*, esES *Arrojo*, esMX *Energizante*,
  ptBR *Marra*, itIT *Grinta*. GEMETEN in DB2.
- **"Tatkraft des Handwerkers" (de) en "Grinta dell'Artigiano" (it) kloppen.** Dat is letterlijk Blizzards eigen naam
  voor het item *Artisan's Moxie* (237505) in die talen. Geen verzinsel. GEMETEN.
- **15 keys, 61 taal-regels** moeten nog naar het clientwoord. Lijst in tabel 3.
- **Spaans is één pack voor twee clients.** Spanje ziet *Arrojo*, Latijns-Amerika ziet *Energizante*. Eén vaste tekst is
  voor één van de twee altijd fout. Rob kiest (opties in §1.5).
- **Tormented Tantalum (251283)** komt volgens alle bronnen uit de **beloningskist van een Prey-jacht**, als kans. En uit
  het Auction House. Er is maar één ID, geen rangen. Zin voor de speler in §2.5.

---

## Vraag 1 — Moxie in de clienttalen

### 1.1 Bron en build

- Bron: wago.tools, DB2-tabel `CurrencyTypes`, kolom `Name_lang`, filter `CategoryID=280`, per `locale=`.
  Gelezen 7 okt 2026 in het browservenster. GEMETEN.
- Build **12.1.0.69933**. Volgens wago.tools/builds is dat branch `wow` (= live), gezien op 2026-09-22.
  De nieuwere 12.1.5.70077 is branch `wowxptr` (PTR). GEMETEN.
- Met én zonder *Use Hotfixes*: in alle 7 talen dezelfde namen. GEMETEN.
- Positieve controle: de enUS-namen zijn precies de 11 namen die Rob in zijn client mat. GEMETEN.

### 1.2 De 11 valuta's per taal (Name_lang, 12.1.0.69933)

| ID | enUS | deDE | frFR | esES | esMX | ptBR | itIT |
|---|---|---|---|---|---|---|---|
| 3256 | Artisan Alchemist's Moxie | Tatkraft des Alchemiefachmanns | Aplomb d’artisanat en alchimie | Arrojo de alquimista artesano | Energizante de alquimista artesano | Marra do Alquimista Artífice | Grinta da Alchimista Artigianale |
| 3257 | Artisan Blacksmith's Moxie | Tatkraft des Schmiedefachmanns | Aplomb d’artisanat de la forge | Arrojo de herrero artesano | Energizante de artesano herrero | Marra do Ferreiro Artífice | Grinta da Fabbro Artigianale |
| 3258 | Artisan Enchanter's Moxie | Tatkraft des Verzauberungsfachmanns | Aplomb d’artisanat en enchantement | Arrojo de encantador artesano | Energizante de artesano encantador | Marra do Encantador Artífice | Grinta da Incantatore Artigianale |
| 3259 | Artisan Engineer's Moxie | Tatkraft des Ingenieursfachmanns | Aplomb d’artisanat en ingénierie | Arrojo de ingeniero artesano | Energizante de artesano ingeniero | Marra do Engenheiro Artífice | Grinta da Ingegnere Artigianale |
| 3260 | Artisan Herbalist's Moxie | Tatkraft des Kräuterkundefachmanns | Aplomb d’artisanat en herboristerie | Arrojo de herborista artesano | Energizante de artesano herborista | Marra do Herborista Artífice | Grinta da Erbalista Artigianale |
| 3261 | Artisan Scribe's Moxie | Tatkraft des Inschriftenfachmanns | Aplomb d’artisanat en calligraphie | Arrojo de escriba artesano | Energizante de artesano escriba | Marra do Escriba Artífice | Grinta da Runografo Artigianale |
| 3262 | Artisan Jewelcrafter's Moxie | Tatkraft des Juwelierfachmanns | Aplomb d’artisanat en joaillerie | Arrojo de joyero artesano | Energizante de artesano joyero | Marra do Joalheiro Artífice | Grinta da Orefice Artigianale |
| 3263 | Artisan Leatherworker's Moxie | Tatkraft des Lederverarbeitungsfachmanns | Aplomb d’artisanat de travail du cuir | Arrojo de peletero artesano | Energizante de artesano peletero | Marra do Coureiro Artífice | Grinta da Conciatore Artigianale |
| 3264 | Artisan Miner's Moxie | Tatkraft des Bergbaufachmanns | Aplomb d’artisanat en minage | Arrojo de minero artesano | Energizante de artesano minero | Marra do Minerador Artífice | Grinta da Minatore Artigianale |
| 3265 | Artisan Skinner's Moxie | Tatkraft des Kürschnereifachmanns | Aplomb d’artisanat en dépeçage | Arrojo de desollador artesano | Energizante de artesano desollador | Marra do Esfolador Artífice | Grinta da Scuoiatore Artigianale |
| 3266 | Artisan Tailor's Moxie | Tatkraft des Schneiderfachmanns | Aplomb d’artisanat en couture | Arrojo de sastre artesano | Energizante de artesano sastre | Marra do Alfaiate Artífice | Grinta da Sarto Artigianale |

Alles in deze tabel: GEMETEN (wago DB2, 12.1.0.69933, 7 okt 2026).

Let op bij het overnemen (GEMETEN):
- **frFR gebruikt de krullende apostrof ’ (U+2019)**, niet `'`. Kopieer de naam letterlijk.
- **esMX heeft een andere woordvolgorde dan esES**: "de artesano herrero", behalve 3256 ("de alquimista artesano").

### 1.3 Het losse woord "Moxie" per taal

Blizzard heeft één generieke naam: het item **237505 "Artisan's Moxie"** (ItemSparse, Midnight, Rare).
Beschrijving enUS: *"A mysterious reagent beyond mortal comprehension that is bestowed upon master crafters."*
Dat item geeft per taal de generieke naam. GEMETEN (wago ItemSparse `Display_lang`, 12.1.0.69933, 7 okt 2026).

| taal | generieke naam (item 237505) | los woord | lidwoord (AFGELEID) |
|---|---|---|---|
| enUS | Artisan's Moxie | Moxie | — |
| deDE | Tatkraft des Handwerkers | Tatkraft | die (v) |
| frFR | Aplomb artisanal | Aplomb | l'Aplomb / de l'Aplomb (m) |
| esES | Arrojo de artesano | Arrojo | el (m) |
| esMX | Energizante de artesano | Energizante | el (m) |
| ptBR | Marra do Artífice | Marra | a (v) |
| itIT | Grinta dell'Artigiano | Grinta | la (v) |

- Naam en los woord: GEMETEN. Het lidwoord is AFGELEID (taalkennis). Steun: de pt- en it-beschrijvingen van 3256 beginnen
  met "Usada" / "Usata" (vrouwelijk). GEMETEN.
- **Een UI-tekst met alleen "Moxie" bestaat niet.** wago `GlobalStrings` enUS, filter "Moxie": 0 rijen. Positieve controle in
  dezelfde run: filter "Knowledge" gaf wél rijen (KNOWLEDGE_BASE, UNLEARN_SKILL …). GEMETEN.
  De speler ziet het woord dus alleen in de 11 valutanamen en in de naam van item 237505.
- Of item 237505 ooit in een tas verschijnt, is **niet gemeten**. Voor de vertaling maakt dat niet uit: het is Blizzards
  eigen vertaling van "Artisan's Moxie".
- **Antwoord op de vraag van de site-chat:** *Tatkraft des Handwerkers* en *Grinta dell'Artigiano* zijn goed. De fout zit
  in de plekken die nog "Moxie" zeggen. GEMETEN.

### 1.4 Wat staat er nu in de packs, en wat zegt de client

Gemeten met `tools/locale_probe.lua --dump`, gedraaid via `_probe.py`. Dat is wat `ns:L` echt teruggeeft per taal, na
alle `fill()`- en `merge()`-stappen. Plus een grep op de bestanden voor de regelnummers. Positieve controle:
`ALT_TOOLTIP_PROF_MOXIE_FMT` gaf 7 rijen (alle talen). GEMETEN.

Gezocht op: Moxie, Tatkraft, Grinta, Aplomb, Arrojo, Energizante, Marra.
Bestanden: deDE, frFR, esES, ptBR, itIT, nlNL, enUS, Translations2026, TranslationsS2, Codex, KeepEnglish en de rest van `Locales/`.
- **TranslationsS2.lua: 0 treffers.** Positieve controle: `fill("deDE"` e.a. op r. 31/115/199/283/367 wel gevonden. GEMETEN.
- **KeepEnglish.lua: geen Moxie-key.** Het bestand heeft wel 11 keys (controle). GEMETEN.

#### 🔴 Waar je het moet aanpassen — anders gebeurt er niets

- `fill()` in Translations2026 overschrijft **alleen** een waarde die `nil` is of gelijk aan enUS
  (`Translations2026.lua:43-45`). GEMETEN in de code.
- De meeste Moxie-regels hieronder zijn al een vertaling (bv. "Moxie, dein Einkaufsgeld"). **Een nieuwe `fill()` doet daar
  dus niets.** Pas die regel aan op de plek zelf (kolom "waar"). AFGELEID uit de code hierboven.
- `Codex.lua` gebruikt `merge()` en die overschrijft altijd (`Codex.lua:16-23`). Pas daar de regel zelf aan. GEMETEN in de code.
- Alleen `ALTBOARD_MOXIE` en `CURACC_USE_MOXIE` kunnen via een nieuwe `fill()`: daar staat nu een enUS-kopie of `nil`. GEMETEN.

#### Tabel 3 — te corrigeren keys

✓ = klopt al met de client, niets doen. "Nu" = de huidige tekst (ingekort). "Moet" = het clientwoord of de clientnaam.
Kolom "moet" is voor het **woord** GEMETEN (tabellen 1.2/1.3). De zinnen eromheen zijn een voorstel: AFGELEID.
Er heeft geen moedertaalspreker naar gekeken.

**1. `ALT_TOOLTIP_PROF_MOXIE_FMT`** (tooltip Account snapshot, `AltOverview.lua:1835`) — 3 regels

| taal | nu | moet | waar |
|---|---|---|---|
| de | Tatkraft des Handwerkers: %s | ✓ | Translations2026.lua:5980 |
| fr | Moxie de l'artisan : %s | Aplomb artisanal : %s | frFR.lua:675 |
| es | Moxie del artesano: %s | Arrojo de artesano: %s (esMX: Energizante de artesano) | esES.lua:679 |
| pt | Moxie do Artesão: %s | Marra do Artífice: %s | ptBR.lua:677 |
| it | Grinta dell'Artigiano: %s | ✓ | Translations2026.lua:7643 |

**2. `ALTBOARD_MOXIE`** (label onder elk beroep, `AltBoardView.lua:323`) — 5 regels, via `fill()`

| taal | nu | moet |
|---|---|---|
| de/fr/es/pt | "Moxie" (enUS-kopie) | Tatkraft / Aplomb / Arrojo (esMX: Energizante) / Marra |
| it | `nil` → toont "Moxie" | Grinta |

**3. `CURACC_USE_MOXIE`** (uitlegregel in het valutaoverzicht) — 5 regels, via `fill()`

- Nu: alleen enUS (`enUS.lua:2107`) en nlNL (`nlNL.lua:2033`). In de 5 talen ontbreekt hij, dus de speler ziet Engels.
  GEMETEN.
- De 9 broertjes (`CURACC_USE_KEYS` … `_CRESTS`) staan wél in alle 5 talen: Translations2026.lua de 8787-8795,
  fr 8815-8823, es 8843-8851, pt 8871-8879, it 8899-8907. Zet hem daar bij. GEMETEN.
- De zin bevat het woord Moxie niet. Wel "Knowledge books". Blizzards eigen woorden daarvoor staan in de beschrijving van
  3256 (GEMETEN): de *Folianten des Wissens*, fr *tomes de connaissance*, esES *tomos de conocimiento*
  (esMX *escritos sobre conocimiento*), pt *tomos do Conhecimento*, it *tomi della conoscenza*.
- Bijzaak: "It stays on the character that earned it" past bij de DB2. `WarbondTransferPercentage` is 0 voor 3256-3266
  (bij Coiled Filament 3546 is het 100). Het veld is GEMETEN. Dat het daarom niet overdraagbaar is, is AFGELEID.

**4. `PROFACAD_CH_MOXIE_TITLE`** — 5 regels, op de plek zelf

| taal | nu | voorstel | waar |
|---|---|---|---|
| de | Moxie, dein Einkaufsgeld | Tatkraft, dein Einkaufsgeld | deDE.lua:255 |
| fr | La Moxie, ton argent de poche | L'Aplomb, ton argent de poche | frFR.lua:253 |
| es | Moxie, tu dinero para compras | Arrojo, tu dinero para compras | esES.lua:256 |
| pt | Moxie, seu dinheiro de compras | Marra, seu dinheiro de compras | ptBR.lua:253 |
| it | Moxie, i tuoi soldi per gli acquisti | Grinta, i tuoi soldi per gli acquisti | itIT.lua:324 |

**5. `PROFACAD_CH_MOXIE_TASK`** — 5 regels, op de plek zelf

| taal | nu | voorstel | waar |
|---|---|---|---|
| de | Finde deine Moxie im Währungs-Tab … | Finde deine Tatkraft im Währungs-Tab … | deDE.lua:257 |
| fr | Trouve ta Moxie dans l'onglet … | Trouve ton Aplomb dans l'onglet … | frFR.lua:255 |
| es | Busca tu Moxie en la pestaña … | Busca tu Arrojo en la pestaña … | esES.lua:258 |
| pt | Encontre seu Moxie na aba … | Encontre sua Marra na aba … | ptBR.lua:255 |
| it | Trova il tuo Moxie nella tab … | Trova la tua Grinta nella tab … | itIT.lua:326 |

Waarom dit telt (AFGELEID): in het valutatabblad staat "Tatkraft des Verzauberungsfachmanns" enz. Wie naar "Moxie" zoekt,
vindt daar niets.

**6. `PROFACAD_CH_MOXIE_BODY`** — 1 regel

- de/fr/es/pt: ✓ (gebruiken al Tatkraft / Aplomb / Arrojo / Marra, 5× elk). GEMETEN.
- it (`itIT.lua:325`): "L'Artisan's Moxie è …", "il tuo Moxie di Incantamento", "5x Moxie", "forziere di Moxie",
  "costano Moxie" → 5× Grinta. Begin: "La Grinta dell'Artigiano è …", "la tua Grinta di Incantamento".
  Controleer de bijvoeglijke naamwoorden: Grinta is vrouwelijk (AFGELEID).

**7. `PROFACAD_CH_RECIPES_BODY`** — 5 regels, 2 plekken per taal

| taal | nu | waar |
|---|---|---|
| de | "Moxie-Händler", "10x Moxie" → Tatkraft-Händler, 10x Tatkraft | deDE.lua:253 |
| fr | "les vendeurs Moxie", "10x Moxie" → vendeurs d'Aplomb, 10x Aplomb | frFR.lua:251 |
| es | "los vendedores de Moxie", "10x Moxie" → de Arrojo | esES.lua:254 |
| pt | "os vendedores de Moxie", "10x Moxie" → de Marra | ptBR.lua:251 |
| it | "i vendor Moxie", "10x Moxie" → Grinta | itIT.lua:322 |

**8. `PROFACAD_CH_RECIPES_TASK`** — 5 regels: "(… = +1 KP + Moxie)" → clientwoord.
de deDE.lua:254, fr frFR.lua:252, es esES.lua:255, pt ptBR.lua:252, it itIT.lua:323.

**9. `PROFACAD_CH_WEEKLY_BODY`** — 1 regel
- de/fr/es/pt: ✓ (Tatkraft / Aplomb / Arrojo / Marra).
- it (`itIT.lua:328`): "non è chiaro se dia anche Moxie" → "… anche Grinta".

**10. `PROFGUIDE_LVL_ALCHEMY`** — 5 regels: "pay some Moxie" → clientwoord.
de "zahlst etwas Moxie" (deDE.lua:261), fr "paies un peu de Moxie" (frFR.lua:259; dan "un peu d'Aplomb"),
es "pagas algo de Moxie" (esES.lua:262), pt "paga um pouco de Moxie" (ptBR.lua:259), it "paghi un po' di Moxie" (itIT.lua:330).

**11. `PROFGUIDE_LVL_TAILORING`** — 5 regels: "(for Artisan Tailor's Moxie)" → de naam van **3266** uit tabel 1.2.
de deDE.lua:264, fr frFR.lua:262 (nu "pour l'Artisan Tailor's Moxie" → "pour l’Aplomb d’artisanat en couture"),
es esES.lua:265, pt ptBR.lua:262, it itIT.lua:333.

**12. `PROFGUIDE_LVL_BLACKSMITHING`** — 5 regels: "(for Artisan Blacksmith's Moxie)" → de naam van **3257** uit tabel 1.2.
de deDE.lua:266, fr frFR.lua:264, es esES.lua:267, pt ptBR.lua:264, it itIT.lua:335.

**13. `PROFGUIDE_SEC_101_BODY`** — 1 regel
- de/fr/es/pt: ✓ (Translations2026.lua:635 / 654 / 673 / 692 gebruiken al het clientwoord, 5× elk).
- it (`itIT.lua:1033`): kopje "Moxie" + "Il Moxie è una valuta", "Il Moxie di Alchimia", "un po' di Moxie", "(e Moxie)"
  → Grinta (5×), met "La Grinta è …".

**14. `CODEX_PROF_BODY`** (Codex.lua, `merge()`) — 5 regels, op de plek zelf

| taal | nu | moet | waar |
|---|---|---|---|
| de | \|cffffffffArtisan's Moxie\|r: Alchemie-Moxie kauft … | Tatkraft des Handwerkers … Alchemie-Tatkraft | Codex.lua:561 |
| fr | Artisan's Moxie : le Moxie d'Alchimie … | Aplomb artisanal : l'Aplomb d'Alchimie … | Codex.lua:694 |
| es | Artisan's Moxie: el Moxie de Alquimia … | Arrojo de artesano: el Arrojo de Alquimia … | Codex.lua:827 |
| pt | Artisan's Moxie: o Moxie de Alquimia … | Marra do Artífice: a Marra de Alquimia … | Codex.lua:960 |
| it | Artisan's Moxie: l'Alchemy Moxie … | Grinta dell'Artigiano: la Grinta di Alchimia … | Codex.lua:281 |

Bijvangst it, buiten deze vraag: in die regel staat ook "Alchemy" in het Engels. In de itIT-client heet het beroep *Alchimia*
(zie de beschrijving van 3256: "ricette di Alchimia"). GEMETEN.

**15. `INFO_DRAWER_BODY_PROFESSIONS`** — 5 regels, het rijtje "(… , Artisan's Moxie, …)"

| taal | nu | moet | waar |
|---|---|---|---|
| de | Artisan's Moxie | Tatkraft des Handwerkers | deDE.lua:609 |
| fr | Moxie de l'artisan | Aplomb artisanal | frFR.lua:558 |
| es | Moxie del artesano | Arrojo de artesano | esES.lua:561 |
| pt | Moxie do Artesão | Marra do Artífice | ptBR.lua:558 |
| it | Artisan's Moxie | Grinta dell'Artigiano | itIT.lua:653 |

De andere namen in die zin ("Unalloyed Abundance", "Shards of Dundun") zijn **niet** gecontroleerd.

**Lage prioriteit / laten staan**
- `CHANGELOG_124_2`: de/fr/es/pt zeggen "Moxie-Zusammenfassung" e.d. Het is een changelog-regel. Volgens CLAUDE.md zijn
  `CHANGELOG_<ver>_<n>` bewust Engels. Rob kiest of hij hem aanraakt.
- `CHANGELOG_282_1`, `CHANGELOG_284_2`, `CHANGELOG_474_6`: Engels in alle talen. Bewust zo. Laten.
- **nlNL**: er bestaat geen Nederlandse client. "Moxie" blijft daar goed (regel uit CLAUDE.md).
- Commentaar `Translations2026.lua:630` zegt nog *"Game systems stay English (… Moxie …)"*. Dat klopt niet meer: de
  de/fr/es/pt-teksten er direct onder gebruiken al het clientwoord. Wie de ronde doet, past die regel aan.

**Telling:** 15 keys, 61 taal-regels (3+5+5+5+5+1+5+5+1+5+5+5+1+5+5). Al goed: ALT_TOOLTIP de/it, MOXIE_BODY de/fr/es/pt,
WEEKLY_BODY de/fr/es/pt, SEC_101_BODY de/fr/es/pt. Geteld uit de dump hierboven: GEMETEN.

### 1.5 Spaans: één pack, twee clients — opties voor Rob

- `Locale.lua:33` zet `esMX = "esES"`. De poort in `esES.lua:17-20` laat esES én esMX door. Eén Spaanse tekst voor beide.
  GEMETEN in de code.
- De client zegt in Spanje *Arrojo* en in Latijns-Amerika *Energizante*. GEMETEN.
- Nu staat er in het pack al *Arrojo* (`PROFACAD_CH_MOXIE_BODY`, `PROFGUIDE_SEC_101_BODY`, `PROFACAD_CH_WEEKLY_BODY`).
  Een esMX-speler ziet dus nu al een woord dat zijn client niet gebruikt. GEMETEN.

Opties (geen keuze van mij):
1. **Arrojo** overal. Simpel. Fout voor esMX.
2. **Energizante** overal. Fout voor esES.
3. **Beide**, bv. "Arrojo (Energizante)". Klopt voor iedereen, maar leest stroef.
4. **De naam uit de client halen in code** voor de korte labels. Per beroep: `C_CurrencyInfo.GetCurrencyInfo(id).name`.
   `CurrencyAccount.lua` doet dat al voor de rijnamen ("the row shows the client's own name"). Het generieke woord kan uit
   `C_Item.GetItemNameByID(237505)`. Dit is AFGELEID en **niet getest**. Een itemnaam kan de eerste keer `nil` zijn zolang
   het item niet in de cache staat. Werkt alleen voor labels, niet midden in lange zinnen.

---

## Vraag 2 — Tormented Tantalum (item 251283)

### 2.1 Wat de DB2 zegt (wago, 12.1.0.69933, 7 okt 2026)

| bewering | status |
|---|---|
| **Maar één item heeft "Tantalum" in de naam: 251283.** Geen rangen of kwaliteiten. Ook zo met hotfixes en op PTR 12.1.5.70077. | GEMETEN (ItemSparse, filter is een deeltekst; hij vindt 251283 zelf = controle) |
| Beschrijving: *"A dense alloy rendered from tormented souls. Can be bought and sold on the Auction House."* | GEMETEN |
| Rare, stapel 1000, verkoop 2 goud (20000 koper), Midnight, niet gebonden | GEMETEN |
| Geen spreuk maakt hem (SpellEffect `EffectItemType`). Controle: 277192 vindt spreuk 1321028. | GEMETEN |
| Hij wordt niet gecraft (`CraftingData.CraftedItemID`). Controle: 237850 Farstrider's Chopper geeft 3 rijen. | GEMETEN |
| Hij zit niet in een questpakket (`QuestPackageItem`). Controle: 242260 geeft een rij. | GEMETEN |
| `CollectableSource*` gaat alleen over uiterlijk en decor (kolommen `ItemModifiedAppearanceID`, `HouseDecorID`) | GEMETEN (kolommen); dat het niet geldt voor reagents is AFGELEID |
| Lootlijsten van kisten en monsters staan niet in de DB2, die zitten op de server. De DB2 kan de bron dus niet bewijzen. | AFGELEID |

Naam per clienttaal (voor de vertaler), GEMETEN in ItemSparse 12.1.0.69933:
de *Gequältes Tantal* · fr *Tantale tourmenté* · esES *Tántalo atormentado* · esMX *Tantalio atormentado* ·
ptBR *Tântalo Atormentado* · itIT *Tantalio Tormentato*.

De vorige ronde schreef dat de beschrijving geen bron noemt. Dat klopt half: er staat "rendered from tormented souls" en
"Auction House" in. "Auction House" is dus een GEMETEN bron. Over waar hij dropt, zegt de tekst niets.

### 2.2 Wowhead (gelezen 7 okt 2026)

- Tabbladen op item=251283: *Reagent for (98)*, *Can be placed in (25)*, *Guides (1)*, *News (4)*, *Comments (5)*.
  **Geen** "Dropped by", "Sold by", "Contained in" of "Currency for". GEMETEN.
- De gelinkte gids is de **Prey Guide** (bijgewerkt 2026-08-19, dus Season 2). De tekst noemt Tantalum **niet**
  (0 treffers op "Tantalum" en op "251283"). Wel staat er: na de eerste twee jachten per moeilijkheid krijg je geen kist
  met gear meer, maar *"additional gold and professional materials"*. GEMETEN dat het er staat; dat Tantalum daaronder
  valt is AFGELEID.
- De 4 nieuwsberichten gaan alle over Prey (feb–jun 2026). GEMETEN.
- Reacties (KANDIDAAT, allemaal van vóór Season 2):
  - 2026-03-08: "a few drop from the elites in Deatholme" (zuid-Eversong). Eén persoon.
  - 2026-04-05: "You can get these when completing a Prey hunt".
  - 2026-07-06: Prey Hard in Eversong, 4 uit de kist; de dag erna 0.
  - 2026-08-06: niet uit "custom" Hunts (de Preferential Killing-quests).
  - 2025-12-10 is speculatie van vóór de release (rating −25). Genegeerd.

### 2.3 Andere bronnen

| bron | datum | bewering | status |
|---|---|---|---|
| Blizzard-forum "Tormented Tantalum" (General) | **16 sep 2026** (S2) | "They come out of prey chests, you can do 2 on each difficulty per character for a chance at them." | KANDIDAAT |
| Blizzard-forum "Delves Reagent Drops" | **4 okt 2026** (S2) | Iemand zegt dat delves dit seizoen geen reagents meer geven. Antwoord: "Tormented Tantalum come from Prey same as last season." | KANDIDAAT |
| Blizzard-forum "Tormented Tantalum" (Professions) | 7–10 jul 2026 | Geen weekcap, wel veel geluk nodig: 8 jachten op 2 chars gaven 5 en 1 keer Tantalum. AH-prijs rond 900 goud. | KANDIDAAT |
| warcraft.wiki.gg/wiki/Tormented_Tantalum | pagina zonder datum; "Added 12.0.1 (2026-02-10)" | "a chance to drop from the caches rewarded from Prey hunts" | KANDIDAAT |
| method.gg Prey Overview | 31 mrt 2026 | "All chests have a chance to contain the Tormented Tantalum crafting reagent." | KANDIDAAT |
| conquestcapped.com Prey guide | 3 jun 2026 | Prey-kist: gear, Voidlight Marl, Veteran Dawncrest, "a chance at Tormented Tantalum". De zak (na 2 kisten) heeft dezelfde pot, zonder gear. | KANDIDAAT |

### 2.4 Conclusie

- **Bron: de beloningskist van een Prey-jacht, als kans.** Zes bronnen zeggen het onafhankelijk van elkaar, twee daarvan na de
  start van Season 2. KANDIDAAT (sterk). Niet in de client of DB2 te bewijzen: lootlijsten zitten op de server.
- **Auction House**: GEMETEN (eigen itembeschrijving).
- Of de **zak** (na de eerste 2 kisten per moeilijkheid) hem ook geeft: één bron uit juni zegt ja. KANDIDAAT, zwak.
- **Deatholme-elites** en **delve-kisten**: elk één bewering, en het delve-verhaal wordt op 4 okt tegengesproken.
  KANDIDAAT, zwak. Niet in de speler-zin zetten.
- **Verband met Prey: ja.** Alle bronnen zeggen Prey, en Wowhead linkt alleen de Prey-gids. Dat de naam
  ("tormented souls") past bij de Torments van Prey is AFGELEID.
- ⚠️ Niet verwarren met **Tormented Soul**, het nieuwe Prey-verbruiksitem uit 12.1 (uit Bountiful Delves T6+, journey rang 9).
  Dat is een ander item. KANDIDAAT (Wowhead Prey-gids 2026-08-19).
- **ID's:** alleen **251283**. Geen rangen. GEMETEN.

### 2.5 Voorstel zin voor de speler (AFGELEID)

Past in de vorm van `CraftShoppingList.lua` (korte NOTE + langere TIP, zoals `CRAFTSHOP_NOTE_DELVE` / `_TIP_DELVE`).
Daar staat nu nog geen Tantalum en geen Prey-soort. GEMETEN: grep op "Tantal" en "251283" in `Modules/` en `Locales/`
gaf 0. Controle: dezelfde grep vond `CRAFTSHOP_NOTE_*`.

- enUS NOTE: `Prey chests`
- enUS TIP: `Comes from the reward chest of a Prey hunt, on any difficulty. It is a chance, not a sure drop. Otherwise: the Auction House.`
- nlNL NOTE: `Prey-kisten`
- nlNL TIP: `Komt uit de beloningskist van een Prey-jacht, op elke moeilijkheid. Het is een kans, geen vaste drop. Anders: het Auction House.`

Bewust weggelaten: de zak, Deatholme, delves, getallen. Daar is het bewijs te zwak voor.

---

## Bijvangst (buiten de vraag, KANDIDAAT)

- **Petrified Root (251285)** staat in `CraftShoppingList.lua:138` als `"delve"`. De tip zegt "Comes from chests in delves".
  - Wowhead-reacties noemen meer bronnen: Prey-kisten, de eindkist van heroic/M0/M+ dungeons, Artisan's Consortium Payout
    en Surplus Reagents.
  - Season 2-reacties (23 aug – 6 sep 2026) melden dat delves hem veel minder vaak geven.
  - Forum 4 okt 2026: "Petrified Roots drop from M+ now."
  - Allemaal KANDIDAAT. De MH-tip kan verouderd of te smal zijn. Een eigen check waard.
