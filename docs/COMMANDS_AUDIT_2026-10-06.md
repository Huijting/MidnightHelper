# /mh-commando's zonder knop — inventaris 6 okt 2026

Rob: *"we moeten dit soort dingen ook als handige knop in de MH hebben ipv alleen maar slash mh en dan een commando"*.
mh-research, alleen lezen. "Knop" = de functie achter het commando wordt ergens vanuit een klik/kaart/instelling
aangeroepen (GEMETEN met grep, positieve controle: /mh ready, /mh block, /mh course gevonden). Zoekbalk telt niet mee.
"Nuttig voor een speler" is een oordeel (AFGELEID).

## Tellingen
| groep | aantal |
|---|---|
| Nuttig, geen knop | 25 (21 hoog, 4 laag) |
| Knop alleen buiten het MH-venster | 7 |
| Rob kiest / eerst meten / werkt niet | 9 |
| Inhoud al elders | 7 + 4 zoekcommando's |
| Knop bestaat | 35 |
| Diagnose en debug (geen knop nodig) | 121 |

## Nuttig, geen knop
**Schakelaars → All settings (SettingsDefs.lua; komen dan ook in Blizzards paneel):**
`/mh prompt` (+ `prompt sound` als keuzelijst + Test), `/mh loot`, `/mh bagarrows`, `/mh scorecard` (+detail),
`/mh pullsummary` (+boss, +popup), `/mh dispel alert`, `/mh arrow yield` (alleen met WaypointUI).

**Vensters → kaart bij Tools → Pop-out windows:** `/mh stats`, `/mh fps`, `/mh pawn` (of karakterzijpaneel),
`/mh binds` (of in het key-block-venster), `/mh curioinfo` (of in curios/Valeera-venster).

**Instellingen-pagina:** `/mh report` (bij Meldingen & tips), `/mh changelog` (bij de versieregel), `/mh panelreset`
(Geavanceerd).

**Route (snelbalk zolang een route loopt):** `/mh plan`, `/mh skip`, `/mh clear`, `/mh fp`.

**Elders:** `/mh boardall` (knop op het consumables-bord), `/mh aggro` (Codex/Tank-track).
**Laag:** `/mh season stats`, `/mh milestones`, `/mh keys`, `/mh dispel`.

## Knop alleen buiten het MH-venster
`/mh export`, `/mh raidbots`, `/mh enchant`, `/mh tracks` (karakter-zijpaneel), `/mh mplus` (ook Home), `/mh items`,
`/mh clear` (rechtsklik pijl).

## Rob kiest / eerst meten
`/mh sba`, `/mh mouse`, `/mh anchor`, `/mh apply` (oud schema naast het key block), `/mh editmode …`, `/mh bars plan`
(patch-gebonden preset), `/mh kicks` (werkt de telling in 12.1?), `/mh kicks alert` (doet niets op 12.1:
interfacecheck < 120100, InterruptScore.lua:30-33, GEMETEN).

## Fouten gevonden (GEMETEN)
1. `/mh delves`: lijst belooft "delve-geschiedenis" (enUS.lua:421), opent de Delve Coach (Core.lua:2950).
2. `/mh scorecard`: lijst belooft "scorecard van je laatste run" (enUS.lua:422), zet de regel aan/uit (Core.lua:2643) —
   via de zoekbalk zet je hem ongemerkt uit.
3. `/mh size` / `/mh framesize`: beloven schalen (enUS.lua:639-640), tonen alleen de maat (UI.lua:4505).
4. `/mh debug`: komt nooit bij Core.lua:3390 — Achievements.lua:2645 pakt het eerder (pijl-debug).
5. Dode takken: tweede `valeera` (Core.lua:2983), tweede `kp` (Core.lua:3148).
