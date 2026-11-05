# Wat een Forever-release nodig heeft (nacht 5→6 nov 2026)

Rob, 5 nov: *"Is het iets om uit te brengen? … Inderdaad geen release maken."* Dit is alleen onderzoek (mh-research, met
één punt zelf nagemeten). **Er is niets uitgebracht, getagd of geüpload.**

## Het belangrijkste eerst: een val, en die is dicht

- **GEMETEN (zelf, BigWigsMods packager `v2/release.sh` regels 1424-1430, 6 nov):** de packager neemt
  `MidnightHelper_Camelot.toc` mee zodra het bestand in de repo **bestaat**. De `ignore`-lijst in `.pkgmeta` geldt pas
  later, bij het inpakken. Gevolg (AFGELEID): de volgende gewone release was op CurseForge en Wago ook als
  **Forever (1.60.1)** gemarkeerd, terwijl de zip het Forever-bestand mist en daar dus niet laadt.
- Het bestand stond sinds 5 nov (commit 88e9dae) op GitHub. **Opgelost in de nacht:** uit git gehaald (`git rm
  --cached`), in `.gitignore`, en op schijf laten staan. Robs Forever laadt het nog steeds via de koppeling. Een kopie
  voor de geschiedenis: `docs/forever/MidnightHelper_Camelot.toc.txt` (die gaat nooit mee in de zip, `docs/` is
  uitgesloten).

## Wat er bestaat (bronnen 6 nov, mh-research)

- **CurseForge** heeft een Forever-versie "1.60.1" (type 88568). Eén project kan beide: één bestand met beide labels
  (EllesmereUI 9.7.6, Waypoint UI 1.7.5, BugSack) of een apart `-Forever.zip` (Pawn). Waypoint UI doet precies wat wij
  hebben: `WaypointUI.toc` + `WaypointUI_Camelot.toc` in één bestand.
- **Packager** (`BigWigsMods/packager@v2`, wat wij gebruiken): Forever sinds v2.6.0 (18 sep 2026). Herkent `_Camelot.toc`
  (niet `_Forever`), maakt van 16001 "1.60.1", één zip met beide labels. **Geen wijziging aan `release.yml` nodig.**
- **Wago** kent Forever ("1.60.1", `_Camelot`/`_Forever`).
- **De CurseForge-app** installeert in `_forever_` (Robs eigen log, 5 nov: "Instance detected: Forever (88568)").
- **Regels:** geen aparte Forever-addonregels gevonden (dat bewijst niets); Forever = zelfde API en secrets als retail.

## Wat we moeten doen om het WEL uit te brengen (als Rob "go" zegt)

1. `MidnightHelper_Camelot.toc` weer in git: de regel uit `.gitignore` halen, en uit `.pkgmeta` (`ignore`) en
   `tools/package.ps1` (`$xf`).
2. De naam `_Camelot.toc` houden (de packager kent `_Forever` niet).
3. In die TOC alleen `## Interface: 16001`; `## Version` bij elke release in **beide** TOC's ophogen
   (in `RELEASE_CHECKLIST` zetten).
4. Optioneel: `## X-Curse-Project-ID: 1528577` en `## X-Wago-ID: rNky4wKa` ook in de Camelot-TOC.
5. Na de eerste tag nakijken: Actions-log zegt "multi-version" en 1.60.1; het CurseForge-bestand heeft 1.60.1; Wago
   toont Forever.
6. 🔴 Op Robs pc **nooit** MH via de CurseForge-app in `_forever_` installeren: daar staat de koppeling naar de repo.
7. Huisregel: Forever noemen in de release notes, de CurseForge-beschrijving en op de site (site-chat).

## Wat er inhoudelijk nog moet vóór een release (AFGELEID, Robs keuze)

- Toetsenblok-tabellen voor de andere 8 classes: voorstellen staan in `docs/forever/` (nacht 5-6 nov), Rob keurt per class.
- In het spel testen: beer/kat op 10/20 (Druid), en minstens één tweede class.
- EllesmereUI-gebruikers: "EllesmereUI Action Bars" uit + `/reload` (Robs ervaring) — dat moet in de uitleg.
