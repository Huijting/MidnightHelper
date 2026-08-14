# Opdracht: Codex-artikel over de Vaults of Atal'Utek

Geschreven 14 aug 2026 zodat Rob dit vanaf zijn telefoon kan laten bouwen. Lees eerst
`CLAUDE.md` en het kopstuk van `docs/NEXT_SESSION.md`.

⚠️ **Deze sessie kan het spel niet zien.** Geen SavedVariables, geen geïnstalleerde
addons, geen `/reload`. Alles wat je nodig hebt is al gemeten en staat hieronder of in
`NEXT_SESSION.md`. **Meet niets bij, verzin niets bij.**

## Wat er gebouwd moet worden

Eén Codex-artikel, categorie `world` of `start` (kijk wat er past in
`Modules/MidnightCodexData.lua`), dat een speler vertelt **wat de Vaults zijn, wat je er
kunt doen, en waar**. Rob's eigen woorden waren: *"ik heb geen idee wat ik er allemaal
kan doen en vooral waar"*.

Volg het patroon van het `prof_reset`-artikel dat op 12 aug is toegevoegd: entry in
`ns.CODEX_ARTICLES`, `titleKey` + `bodyKey`, `searchKeys` in het Engels, en de tekst in
`Locales/Codex.lua` voor **alle zeven talen** (dat bestand heeft één `merge(...)`-blok
per taal).

## De gemeten feiten — dit is de hele bron

| | |
|---|---|
| Vaults of Atal'Utek | uiMapID **2509**, kind van 2512 (The Coiled Isle) |
| De Underbelly | uiMapID **2613**, kind van 2509 |
| Questketen | **98388 → 97640 → 98428** |
| Titels van het spel | *"Into the Vaults of Atal'Utek"*, *"Vaults of Atal'Utek: One Coin Too Many"*, *"Vaults of Atal'Utek: The Altar of Corrosion"* |
| Currency | **Corrosive Coin = 3448** — *"Spirits of the Amani within the Vaults of Atal'Utek deal exclusively in this phantasmal token."* |
| Offergave | **Corrosive Soul = ITEM 273000**, geen currency |

**The Honored Dead — achievement 63610**, twaalf gedenktekens, allemaal met coördinaten
op map 2509 (bron: HandyNotes_Midnight 150):

| quest | criteria | naam | x, y |
|---|---|---|---|
| 98029 | 116407 | To a daughter | 49.50, 56.59 |
| 98030 | 116408 | To a lover | 52.21, 45.12 |
| 98031 | 116409 | To parents | 55.31, 48.45 |
| 98032 | 116410 | To a dream | 55.62, 40.60 |
| 98033 | 116411 | To a captain | 52.91, 33.90 |
| 98034 | 116412 | To sons | 42.91, 41.23 |
| 98035 | 116413 | To Failure | 45.81, 61.79 |
| 98036 | 116414 | To a father | 47.22, 28.77 |
| 98037 | 116415 | To a sister | 46.79, 7.51 |
| 98038 | 116416 | To Comrades | 38.50, 47.66 |
| 98039 | 116417 | To a stranger (onder de brug) | 42.57, 33.18 |
| 98040 | 116418 | To a shield-bearer | 56.49, 22.88 |

Verder: **ingang naar de Underbelly op 47.30, 11.20**. In de Underbelly één rare
(Szarith the Fanged, quest 96030, 38.40/17.69) en achievement **62601**. En drie rare
elites op 2509 (Congealed Malice, Khu'tulak, Susarikk — achievement **63601**) waarvan
**niemand de locatie weet**, ook HandyNotes niet.

## Wat NIET in het artikel mag

- **De twaalf gift-namen uit de Corrosive Codex.** Die komen van een screenshot, niet van
  de client. Noem dát de Codex bestaat en wat hij kost (Corrosive Souls), niet welke
  twaalf er in staan.
- **Wat de Altar of Corrosion-boom uitgeeft.** Ongemeten. De tooltip zei "Spirit
  Corrosion" en de teller stond op 0 — dat is te weinig om iets over te beweren.
- **Coördinaten van de drie rare elites.** Bestaan niet; 10.00/10.00 in HandyNotes is een
  placeholder.
- **Corrosive Coin en Corrosive Soul door elkaar halen.** Het zijn twee dingen. De gidsen
  verwarren ze, de client niet.

## Verificatie vóór de commit

    python tools/lint_addon.py

⚠️ `tools/lua_syntax_check.py` heeft een lokale `luac` nodig en werkt in een cloud-sessie
waarschijnlijk niet. Draait hij niet, zeg dat dan in de commit-melding — dan weet Rob dat
zijn `/reload` de eerste echte syntaxcontrole is, en test hij het artikel vóór iets anders.

Versie **niet** bumpen. Rob haalt dit thuis op met `git pull`, **met WoW dicht**.
