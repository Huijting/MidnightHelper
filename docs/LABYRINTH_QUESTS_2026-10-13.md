# The Labyrinth of Kindo'jan — de weg naar binnen (GEMETEN door Rob, PTR 12.1.5.70340, 13 okt 2026)

Bron: Robs screenshots van elk questvenster. Quest-ID's nog NIET gemeten (wago gaf 503); opzoeken op naam zodra
wago terug is. Zygor (live 9.6 en PTR) heeft nog geen gids, alleen de ingang in LibRover.

**Ingang:** Eversong Woods (uiMapID 2395), **62.9, 72.0 — GEMETEN door Rob bij de ingang**. Zygor LibRover: 63.08, 72.35.
`/way #2395 63.1 72.4` werkt; `/way Eversong Woods ...` is dubbelzinnig in TomTom (3 kaarten heten zo).

| # | Quest | Gever / waar | Doel | Beloning |
|---|---|---|---|---|
| 1 | The Labyrinth of Kindo'jan | Amani Tablet op de deur (Eversong) | Speak to Kul'amara in Swiftclaw Terrace (Atal'Aman, Zul'Aman; "?" linksboven op de Atal'Aman-kaart) | 3g 41s |
| 2 | The Labyrinth | Kul'amara the Fierce (Swiftclaw Terrace) | Meet Valeera Sanguinar at the entrance to the Labyrinth of Kindo'jan in Eversong Woods (inleveren bij Valeera: "No sign of the culprits here. We'll have to follow them inside.") | 500 Undercoin |
| 3 | Dangers Untold and Hardships Unnumbered | Valeera Sanguinar (bij de ingang) | Make the necessary preparations, then enter the Labyrinth of Kindo'jan | 500 Undercoin |

| 3b | (inleveren) Dangers Untold… | **Kinduru <Herald of de Loa>** (vogel, binnen, eerste ruimte) | tracker binnen eerst "0/1 Follow Valeera"; inleveren bij Kinduru: "It is good to be seein' you again, hash'ura … your uncle?" | 500 Undercoin |
| 4 | You Remind Me of the Bird | Kinduru (na kamer 1) | Open the path to the Reliquary to continue your labyrinth run. ("Akil'zon isn't done with dis old troll"; hij wijst naar de verslagen Vilebranch necromancer) | 500 Undercoin |

## Binnen (Rob, Tier 1, 13 okt) — volgorde AFGELEID uit de inhoud, niet uit tijdstempels

- **Binnenkaart** "The Labyrinth of Kindo'jan" (onder Eversong Woods): binnenkomst onderaan op **44.4, 96.5**, bij
  *Chamber of Rites*. Vleugels op de kaart: **Akil'zon's Roost** (boven), **Nalorakk's Rest** (rechtsboven),
  **Halazzi's Lair** (links), **The Cave Towers** (rechts), midden een ronde centrale hal. Veel slot-icoontjes op de
  deuren = nog dichte kamers.
- **Kamer 1 = scenario "A Foul Presence"** (tracker "The Labyrinth of Kindo'jan", stap-icoon "1"). Doelen die Rob zag:
  `0/12 Undead defeated` → `0/4 Clues investigated` → `0/1 Examine the Effigy` → `0/1 Jun'ala slain`.
  ⚠️ Volgorde AFGELEID (logisch verloop), Rob kan het bevestigen.
  - **Jun'ala** (baas van kamer 1) cast **Forbidden Ritual** (castbalk, onderbreekbaar schild-icoon zichtbaar).
- Melding na de kamer: **"Chamber Complete. The treasure room's contents swell."**
- Daarna tracker **"Choose Your Path"**: `0/1 Path chosen` en `0/1 (Optional) Talk to Kinduru to end the run and
  receive your rewards`. Je kunt dus na elke kamer stoppen bij Kinduru.
- Volgende deur = groene energiedeur met sleutel-icoon; klik geeft venster **"Continue into the Reliquary?"** —
  "The chamber ahead is eerily silent.", een icoon met "1" (kosten/sleutel? niet gemeten) en knop **Enter Chamber**.

## MH binnen

- **Combat Safety (CombatSafety.lua)** gaf "DANGEROUS CAST / Targeting you — move / interrupt" op Jun'ala's cast —
  maar de kop was afgekapt tot "DANGEROUS C…". Gerepareerd 13 okt (frame groeit mee met de tekst).

**Het ingangsvenster** (Rob, screenshot): kop "Delve", naam "The Labyrinth of Kindo'jan", tier-keuze (stond op
**Tier 11** bij Robs PTR-character), vijf "Map Properties"-icoontjes, knop **Enter**. "Chance to receive": Kindo'jan's
Reward, Heroic Soul fragment, Zah'ran, Trovehunter's Bounty (lijst scrolt verder). Omschrijving: oud Amani-
grafcomplex, eeuwen verzegeld, nu doorzocht door Relic Raiders en Vilebranch, de geesten verdedigen het.
