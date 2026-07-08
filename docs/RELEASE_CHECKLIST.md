# Release checklist — Midnight Helper

Doel: nooit meer een release met een **stale in-game changelog** (zoals 1.8.0 die
t/m 1.5.5 toonde). Er zijn DRIE changelogs — werk ze alle drie bij vóór elke release.

## ⚠️ De drie changelogs (alle drie bijwerken!)

1. **`Modules/Changelog.lua`** → de **in-game "what's new"-popup**. Voeg een nieuw
   blok toe BOVENAAN `CHANGELOG_ENTRIES` met `version = "<nieuw>"` + `lines = { "CHANGELOG_<ver>_1", ... }`.
2. **`Locales/enUS.lua` + `Locales/nlNL.lua`** → de `CHANGELOG_<ver>_*`-keys die
   het blok hierboven gebruikt. (de/fr/es/pt vallen via `SafeL` terug op EN — bestaand patroon.)
3. **`CHANGELOG.md`** → het dev/GitHub-changelog (volledige notitie per versie).
4. **`docs/CURSEFORGE_<ver>.md`** → de tekst om op de CF-projectpagina te plakken
   (short summary + changelog + upload-checklist). En check of **`CURSEFORGE_DESCRIPTION.md`**
   (evergreen feature-omschrijving) nog klopt met de nieuwe tabs/features.

> Zelfcheck: zet `MidnightHelperDB.changelogDevCheck = true` op je dev-install. Bij
> login waarschuwt de addon als de TOC-versie nieuwer is dan het bovenste changelog-blok.

## Versie + TOC

- Bump `## Version:` in `MidnightHelper.toc` naar de nieuwe versie.
- Bij de échte 12.0.7-launch: `120005` uit de `## Interface`-regel halen (120007 blijft).

## Verifiëren

- luacheck/loadfile op de gewijzigde Lua (host-bestanden; de sandbox-mount geeft
  truncatie-false-positives — host-Read/parser is leidend).
- `/reload` op een schone install: geen Lua-errors bij login, óók direct in combat.
- De nieuwe features even openen (tabs renderen, taal wisselen = geen blokjes).

## Bouwen + uploaden

- Build: `powershell -ExecutionPolicy Bypass -File tools\package.ps1` → `dist/MidnightHelper-<ver>.zip`.
- CF-regels: geen `.bat/.cmd/.ps1/.py/.exe` in de zip; zip-root = exact `MidnightHelper/`;
  geen docs/tools/dev-bestanden; description zonder externe download-links.
- Upload als **Release**, juiste display version + game version (interface 120005,
  +120007 mag in de TOC tot 12.0.7 live is).
- Plak de changelog uit `docs/CURSEFORGE_<ver>.md`; vervang de projectpagina-description
  door `CURSEFORGE_DESCRIPTION.md` (tussen de START/END-markers) als die is bijgewerkt.

## Vaste werkafspraak (zo blijft het automatisch goed)

**Elke feature-batch werkt de in-game changelog in dezelfde commit bij** (Changelog.lua
+ enUS/nlNL keys). Dan staat 'm bij release altijd actueel en hoeft het niet als
losse stap "onthouden" te worden.
