# Nieuwe CurseForge-plaatjes voor 4.0.0

Rob, 16 sep 2026: *"wel moeten we nieuwe screens maken voor CF, dus die moet ook goed klaargezet
worden"*. Dit is de opnamelijst plus wat er vóór de eerste foto klaar moet staan.

4.0.0 is een **uiterlijk**-release. De plaatjes zijn dus niet versiering maar de release zelf: wie op
CurseForge kijkt, ziet eerst de galerij en pas daarna de tekst.

🔴 **Alles wordt echt in het spel gemaakt.** Geen montage, geen AI-plaatje van een venster. Spec 37
§6c: *"Screenshots tonen altijd de echte UI in het spel."* De AI-regel in de omschrijving gaat over de
iconen en het logo — als de galerij dan een nagemaakt venster toont, is die regel niets meer waard.

---

## 0. Eerst beslissen (Rob)

❓ **Welke wordt galerijfoto 1?** Onze eigen twee aantekeningen van 12 sep spreken elkaar tegen:
- `SPEC_37_4.0.0_LOOK.md` §6d: *"galerijfoto 1 blijft This Week — dat plaatje beslist of mensen klikken"*.
- `NEXT_SESSION.md` (12 sep, punt 3): *"galerijfoto 1 wordt het Me-rooster"*.

Beide zijn te verdedigen: **This Week** laat zien wát de addon voor je doet, het **Me-rooster** laat
zien dat 4.0 er anders uitziet. Jij kiest; de rest van de lijst verandert er niet van.

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
- **Zet het MH-venster netjes:** niet tegen de rand, en groot genoeg dat de kaarten niet inklappen.
- **Taal Engels** (dat is je client sowieso) — de galerij is voor iedereen.
- AFGELEID, even nakijken in het spel: `/console screenshotFormat png` en `/console screenshotQuality 10`
  geven de scherpste opname. Werkt dat niet, dan is de gewone JPG ook goed genoeg; niet bijsnijden of
  opschalen achteraf.
- Foto's komen in `_retail_\Screenshots\`.

## 2. De opnamelijst

Volgorde = hoe ze in de galerij komen te staan.

| # | Wat | Wat er te zien moet zijn |
|---|---|---|
| 1 | **This Week** óf **Me-rooster** (zie §0) | de keuze uit §0 |
| 2 | De andere van die twee | — |
| 3 | **Een scherm met zijn kop** (Great Vault of Delves) | het icoon bovenin, de naam en de ene uitlegregel |
| 4 | **Codex-kamer** | de secties als kaarten, elk met eigen icoon (nieuw op 16 sep) |
| 5 | **Rechtsklik op een kaart** | het menu open met *Hide this screen* — laat zien dat je zelf kiest |
| 6 | **Rares** | platte rijen, een rare in het groen, een gedode gedempt met *done*, afstand per rij |
| 7 | **Pop-up *Rare nearby*** | de nieuwe look van de pop-up, met het 3D-model erin |
| 8 | **Boss-venster in een dungeon** | korte tips, de rol-icoontjes, de knop Moeilijkheid (nieuw 15-16 sep) |
| 9 | **Klassiek naast Modern** | twee foto's van hetzelfde scherm; goed voor r/WowUI, niet per se voor CF |
| 10 | **Vel met alle 28 iconen** | pas maken ná 1-9 (Spec 37 §6d) |

## 3. Daarna

- Galerij op CurseForge bijwerken (Rob doet dit met de hand; de packager raakt de galerij niet aan).
- De omschrijving (`CURSEFORGE_DESCRIPTION.md`) plakt Rob er zelf in, mét de AI-regel over de iconen.
- Eén van deze foto's is ook de banner voor de r/WowUI-post (Spec 37 §6e).
