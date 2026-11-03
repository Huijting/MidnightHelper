# Plan: een betere zoekbalk (3 nov 2026)

Rob, 3 nov 2026: onder de indruk van de instellingen en het zoeken in **MF Nameplates 1.2.5**
(`AddOns/MFNameplates/Config/Search.lua`, `Designer.lua`, `Widgets.lua`); *"pluis hem uit"* → *"Ja, maak een plan"*.
Nog niets gebouwd. Elke stap wacht op Robs go.

## 🔴 Licentie

MF heeft geen open licentie voor hun eigen code: README en THIRD-PARTY-NOTICES zeggen alleen "original work by
Marcelian & Flame". Dus alle rechten bij hen, net als Friend Finder. **Alleen ideeën overnemen, elke regel zelf schrijven,
niets kopiëren, ook niet de synoniemenlijst.**

## Wat MH nu heeft (GEMETEN 3 nov in de code)

- `Modules/NavSearch.lua`: live lijst onder de zoekbalk, 8 rijen + muiswiel, `@categorie`-filter, `/`-commando's,
  tiers (actie > tab > inhoud). Index = handgeschreven tab-lijst + content + `ns.MH_COMMANDS`.
- Matchen in `FilterIndex`: de héle zoektekst als één stuk (`label begint met` > `label bevat` > `keyword bevat`).
  Geen woordvolgorde-vrijheid, geen tikfouten, geen synoniemen. ("size arrow", "arow" → niets; AFGELEID, niet in het spel.)
- Instellingen: alleen de pagina's (`settings`, `screens`, `allsettings`). Geen losse instelling vindbaar, terwijl
  `Modules/SettingsDefs.lua` ze allemaal als data heeft (name/tip = locale-keys, sectie-header, kind, rec).
- Klik op een resultaat opent het tabblad; geen scroll naar de regel, geen markering.
- Geen pijltjestoetsen in de lijst (geen `OnArrowPressed` in de hele repo; zelfde grep vond `OnKeyDown` elders).
- Bij 0 resultaten verdwijnt de lijst zonder uitleg; Enter valt door naar Codex en daarna `Addons/Guide.lua`.
- `Addons/Guide.lua` (`ApplyGuideSearchQuery`) heeft nog TWW-woorden: Brann, Zekvir, Undercoin, Dornogal, Stormstout …

## De stappen

Elke stap is los te testen en los terug te draaien. Aanbevolen volgorde = deze volgorde.

### Stap 1 — elke instelling vindbaar, en je landt erop
- NavSearch leest `ns.GetSettingsDefs()` en voegt per instelling een regel toe (`cat = "setting"`): label = vertaalde
  naam, context = "Instellingen › <sectie>", zoekwoorden = vertaalde tip.
- Klik → pagina "Alle instellingen" open, scrollen tot die regel, regel licht een paar seconden op (eigen knipper).
- Nieuw in SettingsPage.lua: één functie "ga naar instelling X" (op `var`), die ook `/mh` of de tour kan gebruiken.
- Later in deze stap of los: Screens-lijst (verbergbare schermen) ook vindbaar.
- Test: typ een woord uit een instelling → regel → klik → juiste regel knippert.

### Stap 2 — vergevingsgezind zoeken
- Zoektekst in woorden knippen; elk woord apart zoeken; volgorde maakt niet uit.
- Kleurcodes en hoofdletters (al via `ULower`) en accenten eruit; "m+" en "%" als woord.
- Kleine tikfouten: vanaf 4 letters 1 fout, vanaf 7 letters 2 (eigen afstandsfunctie).
- Weging: treffer in de naam telt meer dan in context of zoekwoorden; een gemist woord kost punten.
- De bestaande tiers blijven: "rares" moet nog steeds eerst de Rares-tab geven.
- Bij niets gevonden: één grijze regel "Niets gevonden — probeer een ander woord. Enter zoekt verder in de Codex."
- Risico: meer valse treffers. Daarom een drempel, en testen met Robs eigen zoekwoorden.

### Stap 3 — toetsenbord
- Pijl op/neer en Tab lopen door de lijst; Enter kiest de gemarkeerde regel (nu: alleen een sterke treffer).
- 🔴 Escape moet het toetsenbord blijven loslaten (regel in `UI.lua` bij `OnEscapePressed`: anders loop je niet meer).
  MF wist bij Escape eerst alleen de tekst en houdt de focus; dat nemen we dus NIET over.

### Stap 4 — andere woorden per taal (synoniemen)
- Eigen lijst, per taal (MF heeft alleen Engels + Roemeens): "hp" → health, "kick" → interrupt, "pijl" → arrow …
- Spelwoorden = wat die client toont (regel van 20 okt); nl: altijd "spells". Opstellen door mh-writer, nalopen per pack.

### Stap 5 — oude TWW-woorden uit `Addons/Guide.lua`
- Brann, Zekvir, Undercoin, Dornogal, Stormstout, enz. eerst nameten (bestaan ze in 12.1 nog?), dan weg of vervangen.

### Stap 6 (keuze voor Rob) — kleine dingen in het instellingenscherm
- Ctrl+klik = terug naar de aanbevolen stand (`rec` bestaat al in SettingsDefs); tooltip zegt het.
- Een instelling die nu niets doet grijs maken + tooltip "werkt alleen als X aan staat" (i.p.v. verbergen).

## Bij elke stap mee

Vertalingen in 8 packs + `locale_probe`, syntax + lint, `docs/TESTLIJST.md`, deze file en `NEXT_SESSION.md` bijwerken,
site-hoofdpagina (regel "site volgt elke functie"), changelog-regel bij de volgende versie.
