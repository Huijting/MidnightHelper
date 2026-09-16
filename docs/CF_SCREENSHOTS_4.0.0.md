# Nieuwe CurseForge-plaatjes voor 4.0.0

Rob, 16 sep 2026: *"wel moeten we nieuwe screens maken voor CF, dus die moet ook goed klaargezet
worden"*. Dit is de opnamelijst plus wat er vóór de eerste foto klaar moet staan.

4.0.0 is een **uiterlijk**-release. De plaatjes zijn dus niet versiering maar de release zelf: wie op
CurseForge kijkt, ziet eerst de galerij en pas daarna de tekst.

🔴 **Alles wordt echt in het spel gemaakt.** Geen montage, geen AI-plaatje van een venster. Spec 37
§6c: *"Screenshots tonen altijd de echte UI in het spel."* De AI-regel in de omschrijving gaat over de
iconen en het logo — als de galerij dan een nagemaakt venster toont, is die regel niets meer waard.

---

## 0. Beslist (Rob, 16 sep 2026)

✅ **Galerijfoto 1 wordt het Me-rooster** (*"doe die me rooster maar als foto 1"*). Daarmee is de
tegenspraak van 12 sep weg: `SPEC_37_4.0.0_LOOK.md` §6d zei *"This Week blijft foto 1"*, en die regel
geldt dus niet meer. **This Week** schuift door naar foto 2 — het is nog steeds het plaatje dat zegt
wát de addon voor je doet.

---

## 1. Klaarzetten vóór de eerste foto

- **Personage:** je Paladin, midden in de week. Een scherm waarop álles afgevinkt is, laat niets zien;
  een paar open dingen maakt de statusregels op de kaarten juist interessant (*Great Vault 2 / 9*).
- **Ergens rustig en donker gaan staan** (bv. binnen in Silvermoon). Het venster is diep violet met
  goud; op een fel groen veld valt dat weg.
- **Chat leeg en veilig:** geen namen van vrienden, geen whispers, geen guildchat in beeld. Eventueel
  een leeg chatvenster naar voren halen.
- **Andere addons uit beeld:** Zygor, HandyNotes-pins, DBM-testbalken. Ze hoeven niet uit te staan,
  ze moeten alleen niet in de foto staan.
- **MH schoon:** geen `/mh`-diagnoseregels in de chat (`/mh arrow`, `/mh bossdiff` enz.), en het
  changelog-venster dicht.
- **Taal Engels** (dat is je client sowieso) — de galerij is voor iedereen.
- Het **venster zelf** hoef je niet te zetten: het script parkeert hem op een vaste maat en plek.

## 2. De foto's maakt het **script** — `/mh shots`

🔴 **Niet met de hand fotograferen.** Daar is `Modules/DevShots.lua` voor, en dat bestaat juist omdat
handwerk elke release een galerij opleverde waarin geen twee foto's even groot waren. Rob, 16 sep:
*"wacht, we hadden daar een script voor!!!"* — klopt, en deze pagina zei het niet. Nu wel.

Wat het doet: het zet het MH-venster op één vaste maat en plek, loopt de scènes af (scherm openen,
voorbeeld oppoppen), en drukt zelf af. Het onthoudt per foto de exacte rechthoek om bij te snijden, en
het verbergt de rest van de UI zodat er geen actiebalk of questtracker in de foto staat. Het zet
`screenshotFormat` voor de duur van de run op **png** en zet daarna jouw instelling terug.

**Zo draai je hem:**
1. Zet klaar wat in §1 staat en ga op je donkere plek staan. **Dat is het enige handwerk** — alle
   scènes worden vanaf diezelfde plek geschoten.
2. Typ `/mh shots`. Blijf van je muis en toetsenbord af tot hij *done* zegt.
3. `/reload` — WoW schrijft de bijsnij-rechthoeken pas dan naar schijf.
4. Draai `tools\Crop-Shots.bat`. De bijgesneden foto's komen in `Screenshots\mh-shots\`.

**Wat het script schiet (14 scènes, in galerijvolgorde):** Me-rooster, This Week, Codex-kamer,
Tools-kamer, Rares, mount-voorbeeld, Raids, zoeken op een baas, klassecoach, alts, void-rituals,
achievements, delve-coach, beroepenadvies.

⚠️ **Het script draait in de look die aan staat.** Wil je de Klassiek/Modern-vergelijking, draai hem
dan twee keer: één keer in Modern en één keer in Klassiek. In Klassiek vallen de drie kamer-scènes
automatisch terug op hun gewone scherm.

⚠️ **Het beroepenadvies hangt aan je personage.** Draai die op iemand met Midnight-beroepen en punten
om uit te geven, anders fotografeer je een eerlijke lege pagina.

### Wat het script níét kan (met de hand, ná de run)

Het kan de muis niet bewegen en het verbergt de wereld niet, dus deze vier blijven handwerk — gewoon
**Print Screen**; ze komen als `.jpg` in `E:\World of Warcraft\_retail_\Screenshots\`.

| Wat | Wat er te zien moet zijn |
|---|---|
| **Rechtsklik op een kaart** | het menu open met *Hide this screen* — laat zien dat je zelf kiest |
| **Pop-up *Rare nearby*** | de nieuwe look van de pop-up, met het 3D-model erin |
| **Boss-venster in een dungeon** | korte tips, de rol-icoontjes, de knop Moeilijkheid (nieuw 15-16 sep) |
| **Vel met alle 28 iconen** | pas maken ná alle andere (Spec 37 §6d) |

## 3. Daarna

- Galerij op CurseForge bijwerken (Rob doet dit met de hand; de packager raakt de galerij niet aan).
- De omschrijving (`CURSEFORGE_DESCRIPTION.md`) plakt Rob er zelf in, mét de AI-regel over de iconen.
- Eén van deze foto's is ook de banner voor de r/WowUI-post (Spec 37 §6e).
