# Opdracht voor de HA-chat: MH HQ live maken (2 okt 2026)

> Plak alles onder de streep in de Home Assistant-chat. Geschreven door de MH-bouwchat; de site-kant is al klaar
> en live. Deze opdracht raakt **alleen Home Assistant** (helpers, automatisering, REST-sensoren, dashboard).

---

Hoi! Rob wil op zijn dashboard **MH HQ** (`url_path: mh-hq`, view `hq`) een zo live mogelijk overzicht van zijn
WoW-addon Midnight Helper. De website-kant is klaar; jij bouwt de HA-kant. Volg je eigen HA-best-practices-skill.
Laat Rob vóór je iets wijzigt in één korte lijst zien wat je gaat aanmaken, en bouw pas na zijn ja.

## Wat er al staat (gelezen op 2 okt, niet aan breken)

- Automatisering `automation.mh_website_cijfers_en_feedback_ontvangen` met webhook-triggers
  `mh-GJIyEdRpPPbEAvaR6AukKZ0s-stats` (elk uur, bezoekerscijfers) en `mh-GJIyEdRpPPbEAvaR6AukKZ0s-feedback`.
- Dashboard MH HQ met secties *Website vandaag*, *Verloop*, *Feedback*, *Snel naar*.
- De stats-stap "Top 5 pagina's" wachtte op een veld `top_pages`. **De site stuurt dat sinds 2 okt mee**
  (lijst van max. 5 `{"path": "/nl/", "views": 7}`, aflopend). Niets aan doen: alleen na het eerstvolgende hele
  uur kijken of `input_text.mh_pagina_s_vandaag` gevuld raakt.

## 1. Vragenlijst — nieuw, live per antwoord

De site stuurt bij elke ingevulde vragenlijst al een webhook naar **`mh-GJIyEdRpPPbEAvaR6AukKZ0s-survey`**, maar
niets in HA luistert ernaar. Sinds 2 okt bevat hij dit (POST, JSON):

```json
{
  "score": "4",                 // "1".."5" of "" (niet ingevuld)
  "lang": "de", "lang_name": "Duits",
  "from": "game",               // waar de speler vandaan kwam, of ""
  "since": "weeks",             // "new" | "weeks" | "long" | ""
  "role": "dps",                // "tank" | "healer" | "dps" | "mixed" | ""
  "country": "DE",
  "use":   ["maps", "delves", "weekly"],   // "gebruik ik vaak"
  "never": ["boss", "mplus", "keys"],      // "nooit / wist niet dat het bestond"
  "has_annoy": false, "has_miss": false    // alleen óf er tekst getypt is; de tekst zelf staat in Robs Gmail
}
```

De 13 onderdelen (sleutel → Nederlandse naam):
`play` Zo speel je · `maps` Kaarten van instances · `boss` Bazentips · `delves` Delve-coach · `mplus` Mythic+-feedback ·
`weekly` Weekplan en Great Vault · `prof` Beroepencursus · `keys` Keybind-coach · `brez` Battle res en Hero ·
`route` Route en pijl · `collect` Verzamelen · `gear` Gear check · `site` De website.
"use" en "never" sluiten elkaar sinds 2 okt uit.

**Gewenst:**
- Een telling die een herstart overleeft: aantal antwoorden, cijferverdeling 1–5 (+ gemiddelde), per onderdeel
  hoe vaak "vaak" en hoe vaak "nooit", rollen. Hoe je het opslaat kies jij (counters zijn prima, 13×2 is veel maar
  simpel; iets slimmers mag ook).
- Een regel *Laatste vragenlijst*: bv. `cijfer 4 · Duits · dps · 02-10 06:16` (+ "✍️ heeft iets getypt" als
  `has_annoy` of `has_miss` waar is).
- Een pushbericht naar `notify.mobile_app_rob_ultra` (kanaal "Midnight Helper", net als bij feedback), met een tik
  naar Gmail.
- **Startwaarden** — er zijn al 5 echte antwoorden binnengekomen vóór HA meetelde (Robs eigen test telt niet mee):
  - antwoorden **5**; cijfers: 4 → **3×**, 5 → **2×** (gemiddeld 4,4)
  - rollen: tank 2, dps 2, mixed 1; sinds: weeks 5
  - "vaak": play 1, maps 1, boss 1, delves 2, mplus 0, weekly 3, prof 2, keys 0, brez 2, route 1, collect 2, gear 3, site 0
  - "nooit": play 2, maps 2, boss 3, delves 2, mplus 3, weekly 0, prof 2, keys 4, brez 1, route 0, collect 1, gear 1, site 2
  - (één antwoord vinkte overal beide aan; dat telt alleen mee voor cijfer/rol, daarom tellen "vaak" en "nooit"
    over 4 antwoorden.)
- **Testen zonder Robs telling te vervuilen:** laat de automatisering een veld `"test": true` herkennen: dan alleen
  het pushbericht met "[TEST]" ervoor, niets optellen. Test met een POST op de webhook mét `"test": true`.

## 2. Addon-cijfers — HA haalt ze zelf op (REST-sensoren)

Door de MH-chat op 2 okt vanaf Robs pc getest (zelfde thuisnetwerk), alle drie HTTP 200 zonder sleutel:

| bron | URL | wat | waarde 2 okt |
|---|---|---|---|
| downloads | `https://api.cfwidget.com/1528577` | `downloads.total`; `download.display` (versie); `download.downloads` (downloads van die versie) | 16741 · v4.4.0 · 145 |
| CF-reacties | `https://www.curseforge.com/api/v1/mods/1528577/comments?pageIndex=0&pageSize=20` | `pagination.totalCount`; `data[]` = draadjes | 6 berichten, 2 draadjes |
| GitHub | `https://api.github.com/repos/Huijting/MidnightHelper` en `.../releases/latest` | `open_issues_count` (issues + PR's); `tag_name`, `published_at` | 0 · v4.4.0 · 1 okt 21:18Z |

- Vriendelijk pollen: cfwidget en CurseForge **1× per uur**, GitHub elke 30 min (zonder token max. 60/uur).
- ⚠️ `api/v1/mods/1528577` zélf (zonder `/comments`) geeft **403** — niet gebruiken voor downloads; cfwidget wel.
- **Downloads vandaag / deze week**: een utility meter (dagelijks/wekelijks) op `downloads.total` zou mooi zijn.
- 🔴 **"CF-reactie wacht op antwoord"** — dit is het belangrijkste: op 1 okt bleek een bugmelding 17 dagen ongezien.
  Een draadje wacht als het **laatste bericht in de keten** niet van `twelveinchy` is (Robs CF-naam). Let op:
  antwoorden kunnen genest zijn: `data[i].replies[-1].replies[-1]…` (het draadje van *gadrinonturalyon* is twee
  niveaus diep). Loop dus steeds `replies[-1]` af tot er geen `replies` meer is, en kijk naar
  `author.username` van dat laatste bericht. Een draadje zonder `replies` wacht altijd. Op 2 okt wachten er **0**.
  Wordt het aantal groter dan 0 → pushbericht met een link naar
  `https://www.curseforge.com/wow/addons/midnight-helper/comments`.

## 3. Dashboard MH HQ

Voeg twee secties toe en laat de bestaande staan:
- **Addon**: downloads totaal (+ vandaag/week), huidige versie + datum, CF-reacties *wachtend* (rood als > 0,
  anders groen) en totaal, GitHub open. Een geschiedenisgrafiek van de downloads is welkom.
- **Vragenlijst**: aantal antwoorden, gemiddeld cijfer, cijferverdeling, en per onderdeel "vaak" naast "nooit",
  gesorteerd zodat Rob in één blik ziet wat populair is en wat niemand kent (een markdown-tabel met balkjes is
  prima). *Laatste vragenlijst*, en knoppen naar
  `https://mail.google.com/mail/#search/subject%3A%22MH+vragenlijst%22` en `https://midnighthelper.com/nl/survey/`.

Rob leest graag Jip-en-Janneke-Nederlands: korte namen, geen jargon.

## Wat je níét doet

- Niets aan de website of de addon veranderen (die horen bij de MH-bouwchat). Mis je iets in een webhook, schrijf
  dan een korte opdracht terug voor de MH-chat.
- Nooit iets op CurseForge of GitHub posten; alleen lezen.
