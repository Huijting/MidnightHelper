# Stream Deck / keypad — één knop per scherm

Rob heeft een Stream Dock met **Alt+M** erop, zodat Midnight Helper opengaat zonder de muis.
Op 9 sep 2026 vroeg hij om knoppen die meteen naar **Rares** of **Delves** springen, en om
"een lijst die eigenlijk niet voor anderen bedoeld is, maar wel te vinden als leuke extra".

Dit is die lijst.

📌 **Waarom dit document intern is en de knoppen niet.** De *bindings* staan gewoon in
Blizzards eigen keybinding-scherm, dus iedereen die daar kijkt vindt ze — dat is de "leuke
extra optie" waar Rob om vroeg. Wat hier staat is de **recepteerkant**: hoe je een Stream
Deck erop aansluit. Dat is niets voor de CurseForge-pagina en alles voor iemand die dit toch
al doet. `docs/` gaat niet mee in de zip, dus dit bestand bereikt geen speler.

---

## Wat er in het spel staat

**Esc → Options → Keybindings → Midnight Helper**

| binding | doet |
|---|---|
| Toggle main window | het hoofdvenster (standaard **Alt+M**) |
| Skip current route target | volgende doel in de route |
| Clear active route / arrow | route en pijl weg |
| **Open: This Week** | 🆕 |
| **Open: Rares** | 🆕 |
| **Open: Delves & Vault** | 🆕 |
| **Open: Codex** | 🆕 |
| **Open: Professions** | 🆕 |
| **Open: Achievements** | 🆕 |
| **Open: Collectible mounts** | 🆕 |
| **Open: Account snapshot** | 🆕 |

⚠️ **Niets staat standaard gebonden** behalve Alt+M. Dat is expres: acht toetsen inpikken op
andermans toetsenbord is precies wat dit addon van andere addons niet wil.

📌 De namen in dat scherm komen uit de **tabbladen zelf**, niet uit een aparte lijst. Hernoemt
een tabblad, dan hernoemt de binding mee. Dat is niet netheid maar het voorkomen van de fout
die dit project deze week twee keer heeft gerepareerd: een label dat iets anders beweert dan
waar het heen gaat.

---

## Aansluiten op de Stream Deck

**Acht toetsen kiezen die je nergens anders gebruikt.** De makkelijkste zijn de functietoetsen
die geen toetsenbord fysiek heeft:

```
Ctrl+Shift+F13  t/m  Ctrl+Shift+F20
```

WoW accepteert die prima, en geen enkel spel of programma stuurt ze per ongeluk.

1. **In de Stream Deck-software:** maak per knop een actie van het type *Hotkey* (niet *Text*),
   en zet er één van die combinaties op.
2. **In WoW:** Esc → Keybindings → Midnight Helper → klik het vak achter *Open: Rares* → druk
   op die Stream Deck-knop. WoW neemt hem over zoals elke andere toets.
3. Herhaal per scherm.

🔴 **Gebruik "Hotkey", niet "Text" of een macro die `/mh rares` typt.** Een getypt commando
heeft het chatvenster nodig, kost een Enter, en verdwijnt in het niets als er al een tekstveld
focus heeft — precies wanneer je haast hebt. Een binding is één toetsaanslag die de client zelf
afhandelt.

⚠️ **En daarom bestaan er geen losse slash-commando's per scherm.** Dat was het eerste idee
(8 sep): `/rares`, `/delves`. Korte generieke namen zijn van wie ze het laatst claimt, dus zo'n
commando afpakken van een ander addon is onbeleefd om uit te leveren. Bindings hebben dat
probleem niet: ze staan onder onze eigen kop en botsen met niets.

---

## Icoontjes

Standaard krijgt elke knop hetzelfde plaatje, want de Stream Deck weet niets van wat een
toets doet — hij stuurt alleen een toetsaanslag.

### Klaar om te gebruiken: `docs/streamdeck-icons/`

Acht iconen in de kleuren van het addon, **als PNG én als SVG**, elk met een eigen kleur én het
woord erop:

| bestand | knop |
|---|---|
| `mh-home.svg` | WEEK |
| `mh-rares.svg` | RARES |
| `mh-delves.svg` | DELVES |
| `mh-codex.svg` | CODEX |
| `mh-professions.svg` | PROFS |
| `mh-achievements.svg` | ACHIEV |
| `mh-mounts.svg` | MOUNTS |
| `mh-account.svg` | ALTS |

**Pak de `.png`.** Sleep het bestand op de knop, of klik de knop aan → *Icon* → *Set from file*.
Zet daarna de **titel leeg** — het woord staat al in het plaatje, en twee keer dezelfde tekst is
onleesbaar op zo'n klein schermpje.

🔴 **HERNOEMEN IS NIET OMZETTEN.** Rob's software slikte een `.svg` die `.png` heette, wat
betekent dat hij naar de inhoud kijkt in plaats van naar de extensie. Dat werkt tot het niet
meer werkt — een update, een andere machine, een geëxporteerd profiel. Daarom staan de echte
PNG's er nu naast: 288×288, RGBA, doorzichtige hoeken.

📌 **Ze zijn opnieuw getekend, niet geconverteerd.** Er staat geen SVG-converter op deze machine
(gemeten: geen cairosvg, geen cairo, geen wand), dus een script tekent dezelfde vormen met PIL
uit dezelfde specificatie. De SVG's blijven staan: handig om iets aan te passen, en scherp op
elk formaat.

⚠️ **Elk woord staat er ook in tekst op**, niet alleen een symbool. Een abstract icoontje is na
een week weg-zijn een raadspelletje, en dit is precies het soort knop dat je niet dagelijks
gebruikt.

### Liever WoW-iconen

Kan ook, en dat oogt in dit rijtje misschien beter. Wowhead serveert elk spel-icoon als
plaatje op een vast adres:

```
https://wow.zamimg.com/images/wow/icons/large/<naam>.jpg
```

🔴 **Ik ga hier geen icoonnamen verzinnen.** De vier die ik met zekerheid heb zijn de namen
die dit addon zélf gebruikt voor zijn zijbalk (`UI.lua:333-336`), dus die werken gegarandeerd:

| icoon | waar wij het gebruiken |
|---|---|
| `achievement_character_human_male` | de kamer "Me" |
| `inv_misc_book_09` | de Codex |
| `trade_engineering` | Tools |
| `inv_misc_gear_01` | Settings |

De rest zoek je op Wowhead zelf (zoek een spell of item, rechtsklik het icoon → afbeelding
opslaan). ⚠️ Voor je eigen deck is dat prima; het is geen materiaal om door te verspreiden.

🔴 **Waar je op moet rekenen vóór je gaat zoeken: spel-iconen zijn KLEIN.** WoW tekent ze voor
een vakje van een paar tientallen pixels op je actiebalk. Een Stream Deck-toets is groter, dus
een rechtstreeks overgenomen icoon wordt opgeblazen en oogt zacht en korrelig naast de scherpe
tekst van de rest van je deck.

📌 **Dat is op te lossen zonder de look kwijt te raken:** zet het spel-icoon **op** het frame
hierboven in plaats van het op te rekken — icoon in het midden op zijn eigen formaat, onze
donkere achtergrond eromheen, het woord eronder. Dan blijft het scherp én herkenbaar.
Het script dat de acht PNG's tekent kan dat samenstellen; vraag erom met de gevonden
bestanden erbij, dan is het een kwestie van ze in een map zetten.

## Als een knop niets doet

- **Zit hij wel écht vast?** Het keybinding-scherm toont de toets naast de regel. Staat daar
  niets, dan is de druk nooit aangekomen — kijk of de Stream Deck-knop op *Hotkey* staat.
- **Doet Alt+M het nog?** Zo niet, dan ligt het niet aan deze bindings maar aan het addon of
  het profiel.
- **Werkt het buiten combat wel en erin niet?** Dan botst hij met een spelactie op dezelfde
  toets; kies een andere.
