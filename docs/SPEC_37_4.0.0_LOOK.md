# Spec 37 — 4.0.0: layout, vormgeving en iconen

**Van:** ONDERZOEK-sessie, 10 sep 2026
**Aanleiding:** Rob wil een 4.0.0 met *"supergave layout en iconen"*, ook op CF, Wago en Discord.
**Randvoorwaarde van Rob:** *"het moet wel realistisch zijn, dus bv geen addon van 25 MB"*. Alles gratis.
**Bron:** vier onderzoeksagenten (techniek, layout, vormgeving/beleid, lancering), daarna door mij
nagemeten waar ze elkaar tegenspraken. Tags: **G** = gemeten, **A** = afgeleid.

---

## 0. In één alinea

We kunnen alles tekenen, maar **de mooie grote plaatjes mogen niet de addon in** — dat is precies
de 25 MB. Wat wél past: dezelfde kunst op **128 px als PNG** (~1–2 MB erbij), gebruikt waar ruimte
is (een kopbalk per scherm, een kaartjesrooster per kamer), en **zonder tekst erop**, omdat de
addon zeven talen spreekt. Randen, knoppen en lijsten blijven Blizzard-textures: 0 KB en ze passen
vanzelf bij het spel. Eerst de kleinste versie (concept A), pas daarna beslissen over een grotere
verbouwing.

---

## 1. Techniek en budget

### 1a. Formaat
- **PNG werkt** sinds patch 10.0.7, mits het pad de extensie `.png` bevat. **G:** Plumber
  (`## Interface: 120100`) levert 512×512 PNG's en laadt ze met `SetTexture("...png")`.
  ⇒ **Geen omzetting naar TGA/BLP nodig.** ComfyUI levert al PNG. (Dit corrigeert mijn eigen
  aantekening van 10 sep, die zei "MH gebruikt TGA, dus omzetten".)
- **Machten van twee:** de wiki eist het nog; verkeerde maten tonen als **groen blok**. Niet
  hermeten op 12.1. ⇒ Alles op **64, 128 of 256**. Onze `deck_144` is dat níet.
- ⚠️ **Nieuwe texturebestanden vragen een volledige herstart van het spel**, niet `/reload`
  (**A**, uit forummeldingen). Anders zie je groen en denk je dat het kapot is.

### 1b. Wat MH nu weegt (G)
- Laatste release-zip `MidnightHelper-3.7.3.zip`: **3,31 MB**. Uitgepakt ~10,8 MB.
- `Media/` is ~2,0 MB, waarvan **1,95 MB de drie Platynator-screenshots** zijn, als ruwe TGA.
- 🔴 **Bijvangst:** die drie zijn **629×342, 392×256 en 676×256** — géén machten van twee. Als de
  regel nog geldt, tonen ze nu als groene blokken. **Rob kan dat in tien seconden zien:**
  Addons → Platynator. Niemand heeft het ooit gecontroleerd.

### 1c. Rekensom, 28 iconen (G voor TGA, rest A)

| | 64 px | 128 px | 256 px |
|---|---|---|---|
| PNG | ~0,28 MB | ~1,1 MB | ~4,2 MB |
| TGA 32-bit | 0,46 MB | 1,84 MB | 7,3 MB |
| BLP DXT5 | 0,18 MB | 0,64 MB | 2,5 MB |
| **de `groot`-set (~900 px)** | | | **~35 MB** ← dit is de "25 MB-addon" |

### 1d. Budget
- **`Media/` ≤ 5 MB uitgepakt, zip hooguit +2 MB** (3,3 → ≤ 5,5 MB). Verwacht voor 28×128 +
  28×64 + 16×64 PNG: **~1,6 MB**. Daarmee blijft MH onder WaypointUI (8 MB) en ver onder
  Plumber (14 MB) en Details (45 MB) — alle drie **G**, hier op schijf gemeten.
- **Terugverdienen:** de drie Platy-screenshots als 2-machts-PNG opnieuw opslaan scheelt
  vermoedelijk ~1,5 MB — meer dan de nieuwe iconen kosten.
- **Losse bestanden, geen atlas.** Een atlas scheelt geen schijfruimte en moet bij elke
  icoonwijziging opnieuw uitgerekend.
- **Wat het budget opblaast:** de `groot`-set meeleveren · 256 px-TGA voor alles (~11,5 MB) ·
  2048²-atlassen · een schilderij als achtergrond per tabblad (4 MB per stuk) · tekst in het
  plaatje × 7 talen.

---

## 2. Layout

### 2a. Hoe het nu zit (G)
- Venster 795×600 standaard. Zijbalk 132 px met **vier kamers** (Me / Codex / Tools /
  Settings, iconen 16 px) en daaronder de tabbladen als **alleen tekst** — `TAB_DEFS` heeft
  geen icoonveld (`UI.lua:1929`). Er zijn er **24**, niet 25; met de 4 Toolbox-subtabs erbij 28.
- **Kamer "Me" is een muur:** 15 tabbladen in 5 secties. De zijbalk wordt dan ~784 px hoog en
  het venster groeit zelf voorbij zijn 600 px (`UI.lua:3233-3261`, **A** uit de constanten).
- Dubbele thuizen: Delves, Dungeons en World zijn zowel een tabblad als een Codex-categorie.
- Duitse en Franse labels worden kleiner gezet om in 132 px te passen.
- Het Home-dashboard bevat **geen enkel plaatje** (`HomeDashboard.lua`). Voor een addon die
  sterk is in *uitleggen* verkoopt dat zichzelf tekort.

### 2b. Wat goede UI's doen (G, bronnen in de agentverslagen)
Blizzard (Adventure Guide, Great Vault, Journeys in 12.0), Plumber, Zygor, BtWQuests: een
**landingspagina met kaartjes** (status + één klik erheen), **tekstlijst + zoeken** zodra het veel
pagina's worden, en **kunst in kaarten en koppen, nooit in navigatielijsten**.

### 2c. Drie concepten

**A — "Gilded Rooms". Klein tot middel. ← aanbevolen als 4.0.0**
Zijbalk en kamers blijven precies zoals ze zijn. Drie toevoegingen:
1. **Een kopbalk op elk scherm:** het icoon (128 px), de naam, en één zin *waar dit scherm voor is*.
   Dat is MH's sterkte in één regel.
2. **Klik op een kamerknop → een kaartjesrooster** van die kamer: plaatje, naam, één regel status.
3. De pop-out-kaarten in Tools groeien van 34 naar 64 px met de nieuwe kunst.
```
┌ MH ─ Me > Rares ───────────────────── [Codex][?] ┐
│ [zoeken…………………………]   ★Delves ★Enchants ★Currency │
├────────┬────────────────────────────────────────┤
│[i] Me  │ ╔════╗  RARES                           │
│[i]Codex│ ║kunst║ Welke rares staan er, en de route│
│[i]Tools│ ╚════╝ ────────────────────────────────  │
│  Home  │   …bestaand paneel, ongewijzigd…        │
│  Rares │                                         │
└────────┴────────────────────────────────────────┘
```
Raakt: `UI.lua` (kopstrook, kamerknop → launcher), nieuw `Modules/RoomLauncher.lua`,
`ToolsLaunchpad.lua`, `Media/Icons/`, een tab→icoon-tabel, één Tour-stap.
✅ Tab-id's onaangeroerd, in stappen te leveren, zichtbaar nieuw. ❌ De Me-muur blijft.

**B — Iconenrail + launcher. Middel.** De tekstzijbalk wordt een smalle rail van 56 px. Lost de
muur op, maar labels verhuizen naar tooltips — slecht voor beginners en voor zeven talen, en in
strijd met het besluit van 23 jun (*iconen **plus** labels*, `REDESIGN_5_ROOMS.md:111`).

**C — Journeys-achtige hub. Groot, 3 releases.** 5–6 tabs onderaan, This Week wordt een
Vault-achtig bord met kaarten, dubbele thuizen samengevoegd. Grootste wow, lost de schuld echt op —
en het hoogste risico voor één onderhouder.

**Advies:** A als 4.0.0. Over B of C beslissen ná reacties van spelers.

### 2d. Wat niet mag breken (G)
`Bindings.xml`-namen (ALT-M, de 8 `MIDNIGHTHELPER_TAB_*`, skip/clear, 2 potion-`CLICK`s) ·
tab-id's en de legacy-routering in `SelectTab` (`UI.lua:3457`) · alles in `ns.MH_COMMANDS` ·
opgeslagen vensterstand en -maat, compact-modus, Esc sluit · de 14 pop-outs met hun eigen positie ·
minimap/LDB en addon-compartiment · **de Tour: een verplaatst doel wordt stil overgeslagen**
(`Tour.lua:17-38`), dus na elke verschuiving nagaan dat élke stap nog verschijnt · zeven talen.

---

## 3. Vormgeving

### 3a. Wat werkt en wat botst
- MH gebruikt **al** Blizzards gouden dialoogrand (`UI.lua:139-143`). Goud is voor MH niet nieuw.
- ⚠️ **28 dikke geklonken lijsten naast elkaar ogen als een mobiele-gamewinkel**, en botsen met
  platte UI's als ElvUI. Blizzard zelf ging sinds Dragonflight juist naar minder omlijsting.
- ⚠️ **De kleuren wijken af van het merk.** Het logo (`docs/art/MH_Logo_source_2048.png`) is
  indigo, violet, goud en zilver — Light tegen Void, precies Midnight. De nieuwe iconen zijn
  warm bruin-goud. **G**, beide bekeken.

### 3b. Richtlijn
1. **Eén lijst, in code getekend** — niet in elk icoon gebakken. Een instelling
   *Klassiek / Plat* wisselt alleen die ene lijst om voor de 1 px-rand die MH al heeft (`UI.lua:1513`).
2. **Kunst alleen waar ruimte is:** kopbalken, het welkom in Start Here, lege toestanden, het
   kaartjesrooster (≥ 64 px), en CurseForge.
3. **Kunst níét in:** lijsten, tooltips, gevechtswidgets, raid-markers, en elk vak ≤ 24 px.
   Onder ~40 px wordt geschilderde kunst een gouden vlek (**A**, algemene icoonrichtlijnen).
4. **Geen tekst in de kunst in het spel.** De naam komt uit `ns:L("TAB_*")` als FontString.
   De versies mét naambalk blijven voor de Stream Deck en marketing.
5. **Randen, knoppen, scrollbalken, sluitknop: Blizzard-textures en -atlassen.** 0 KB, passen
   vanzelf. Atlasnamen kunnen per patch veranderen: in `pcall` zoals `UI.lua:1819` al doet, en
   elke naam in de client bevestigen met `C_Texture.GetAtlasInfo`, niet van een lijst op internet.
6. **Palet:** nachtindigo van het logo als grond, het bestaande accentgoud (`ffe8c36a`), zilver
   als tweede accent, void-violet alleen voor highlights. De statuskleuren in `ns.UI_COLORS` blijven.
7. **Raid-markers in het spel: Blizzards eigen.** Direct herkennen wint van mooi. De 16 geschilderde
   zijn voor de deck.

### 3c. Wat dat betekent voor de set die er al ligt
De 28 van 10 sep hebben de lijst **en** het naambalkje in het plaatje. Voor in het spel is een
**tweede ronde** nodig: zelfde onderwerpen, **zonder lijst en zonder balk**, op een
**indigo/void-grond** zodat ze bij het logo passen. Dat is 28 ComfyUI-runs, ~10 s per stuk —
een avond, geen project. De huidige set blijft voor deck en marketing.

---

## 4. Beleid en eerlijkheid

- **Geen platform verbiedt AI-kunst.** **G:** Blizzards UI Add-On Policy (8 regels, niets over AI),
  CurseForge (alleen: AI-bewerkte *showcase-afbeeldingen* die de mod verkeerd kunnen voorstellen
  moeten een disclaimer), Wago (eigen werk of gelicenseerd; geen AI-clausule gevonden).
- **De gemeenschap is wél vijandig.** **G**, Blizzard EU-forums juli 2026: *"Content Creators and
  AI"* — meerdere spelers haken direct af bij AI. Maar in diezelfde draad verdedigt een UI-ontwerper
  verantwoord gebruik van lokale modellen zoals ComfyUI, en een draad uit 2023 toont het midden:
  prima, **als het erbij staat**.
- 🔴 **Het logo is al AI.** **G**: rechtsonder in `MH_Logo_source_2048.png` staat het
  Gemini-sterretje. Een eerlijke vermelding moet dus het logo meenemen, niet alleen de nieuwe iconen.
- **Aanpak:** één feitelijke regel in de CF-omschrijving en de README, niet verstopt en niet als kop.
  Voorstel: *"Icons and illustrations were generated locally with an open image model and finished
  by hand; no Blizzard artwork was used as input."* **Screenshots tonen altijd de echte UI in het
  spel.**
- Licentie van het model: zie §5.

---

## 5. Open punten — te meten, niet aan te nemen

1. **Laadt een 128 px-PNG uit `Media/` in 12.1?** Eén bestand, één `SetTexture`, **volledige
   herstart**. Vóór er één regel layoutcode wordt geschreven.
2. **Tonen de Platy-screenshots nu als groene blokken?** (§1b) Tien seconden.
3. ~~Licentie van Z-Image Turbo~~ — **grotendeels beantwoord, 10 sep:** meerdere pagina's
   (o.a. een GitHub-`LICENSE`, Hugging Face-kopieën, twee reviews) noemen **Apache 2.0**, uitgebracht
   26 nov 2025, commercieel gebruik toegestaan. Die licentie gaat over de modelgewichten en legt
   de gegenereerde beelden geen beperking op. ⚠️ **A:** de officiële modelkaart van Tongyi heb ik
   niet zelf gelezen — alleen kopieën en samenvattingen. Eén blik op de officiële pagina maakt dit G.
4. **Welke Blizzard-atlassen** voor kader, knoppen en koppen — per naam bevestigd in de client.

---

## 6. Lancering

### 6a. Wat spelers afstraffen is verschuiven, niet verven (G, voorbeelden)
- **TSM4 (2017–18):** eerst ontwerpblogs, dan beta in golven; TSM3 bleef de stabiele keus, en
  testers zeiden openlijk *"considering returning to TSM 3"*. Versie 4.10 bouwde de UI opnieuw om.
- **Blizzards Dragonflight-UI (2022):** harde overstap, de "Classic"-optie veranderde bijna niets →
  terugdraai-draadjes en een ClassicUI-addon.
- **Auctionator:** nieuwe Shopping-tab eerst als losse testbuild op het alpha-kanaal; een feature
  stil wegha­len gaf daarentegen een felle reactie.

⇒ **Concept A past hier precies bij:** niets verhuist, er komt alleen iets bíj. Standaard aan,
met één schakelaar *Klassiek* voor een paar releases — dat is meteen de uitweg voor wie niets met
AI-kunst wil. Aankondigen in het changelog-venster dat al bij elke update opent (Spec 31 B4):
*"Same addon, new coat of paint. Nothing moved."*

### 6b. Bèta: voor Rob en Cisca, niet voor feedback (G)
CF-bètabestanden bereiken alleen wie daar zelf voor koos; de packager maakt van een tag met "beta"
een bèta. Wago idem. **In de praktijk ziet niemand een bèta:** de alpha's van WeakAuras op Wago
haalden 0–18 downloads per stuk. Een bèta is dus een testronde, geen peiling.

### 6c. Wanneer (A, uit onze eigen watch-bestanden)
BlizzCon **12 sep** · de Spec 31-meting van de zoekpositie wordt **13 sep** gelezen · 12.1.5-PTR-test
**16 sep**. ⇒ **Bèta pas ná 13 sep taggen**, release op een rustige doordeweekse dag: geen resetdag,
niet in de 12.1.5-launchweek, en niet op dezelfde dag als een wijziging van de CF-samenvatting (Spec 31 §7).

### 6d. Plaatjes voor de publieke pagina's

| Waar | Maat | Boost nodig? | Status |
|---|---|---|---|
| CF-avatar (ook Wago) | ≥ 400×400, 1:1 PNG, **eigen beeld** | — | **G** |
| CF-galerij | geen limiet gepubliceerd | — | onbekend |
| GitHub social preview | 1280×640, < 1 MB | — | **G** |
| Discord server-icoon | 512×512 (statisch) | nee | **A** |
| Discord emoji | 50 statisch, < 256 KB | nee | **G** — onze 44 passen |
| Discord stickers | 5 gratis, 320×320, ≤ 512 KB | nee | **G**/A |
| Discord banner / invite-achtergrond / rolicoontjes | — | **ja** (Level 1–2) | **G** — overslaan |
| Stream Deck-iconenpakket | precies 144×144 | — | **G** — `deck_144` klopt al |

Maken: CF-avatar (een nieuw MH-wapen, **geen** raid-marker), één galerij-vel met alle 28 iconen
**ná** de echte screenshots (galerijfoto 1 blijft This Week — dat plaatje beslist of mensen klikken),
GitHub-banner, Discord-icoon.

### 6e. Wat trekt, en wat is versiering (A)
- ✅ **r/WowUI voor/na-post** — die sub stemt op beeld; `[AddOn]`-tag (Spec 31 C3). Afsluiten met een
  vraag: *"welk icoon mist er?"* (Spec 31 C1).
- ✅ **Gratis Stream Deck-iconenpakket** als GitHub Release-bijlage. De Elgato Marketplace mag ook
  gratis, maar **alleen de 28 schermiconen** — de raid-markers zijn Blizzards ontwerpen, en
  Blizzard staat alleen niet-commercieel gebruik toe.
- ➖ **Discord-emoji en -stickers:** tien minuten poetswerk voor een server met ~2 leden. Spec 31 zegt
  al: maak Discord niet de hoofdvraag. Doen mag, verwachten niet.

### 6f. Risico
- **G:** Hearthstone-skins werden na AI-beschuldigingen per hotfix teruggetrokken; de Diablo
  Immortal × Hearthstone-promo werd als *"AI slop"* uitgemaakt; het WoW-team zegt *"very lucky and
  happy"* geen generatieve AI te gebruiken.
- Geen geval gevonden van een WoW-addon die om AI-iconen werd aangevallen — dat is een zoekresultaat,
  geen bewijs dat het niet gebeurt.
- ⚠️ **Geschilderd goud met dikke lijst is precies de stijl die mensen "Midjourney" noemen.** Nog een
  reden voor §3c: de in-game-ronde zonder lijst, in de kleuren van het logo.
- **Niet posten op r/CompetitiveWoW** — die sub zegt letterlijk "NO AI".
- De eerlijke regel (§4) dekt ook de AI-hulp bij de code, zodat hij klopt met Spec 31 C. **Nooit
  beweren dat de kunst met de hand getekend is.**

### 6g. Botsingen met Spec 31
Discord-kunst schuurt met §6 daar (Discord niet als hoofdvraag) → minimaal houden. Een banner
bovenaan de CF-omschrijving duwt de B10-tekst omlaag → niet doen. Een release in het 13-sep-venster
vertroebelt §7 → wachten.

---

## 7. Volgorde

1. **Nu, gratis, zonder addon-wijziging:** de deck-set is af. CF-/Wago-/Discord-kunst maken (§6).
2. **Meten:** de vier punten uit §5.
3. **Tweede kunstronde:** 28 onderwerpen zonder lijst/balk, indigo grond, 128 + 64 px PNG.
4. **4.0.0 = concept A**, als bèta eerst (CLAUDE.md: *"Big releases: consider Beta-first"*), met de
   *Klassiek / Plat*-schakelaar.
5. **Daarna pas** B of C, op basis van wat spelers zeggen.
