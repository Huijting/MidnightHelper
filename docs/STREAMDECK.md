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

## Als een knop niets doet

- **Zit hij wel écht vast?** Het keybinding-scherm toont de toets naast de regel. Staat daar
  niets, dan is de druk nooit aangekomen — kijk of de Stream Deck-knop op *Hotkey* staat.
- **Doet Alt+M het nog?** Zo niet, dan ligt het niet aan deze bindings maar aan het addon of
  het profiel.
- **Werkt het buiten combat wel en erin niet?** Dan botst hij met een spelactie op dezelfde
  toets; kies een andere.
