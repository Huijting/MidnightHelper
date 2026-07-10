# Release checklist — Midnight Helper

Doel: nooit meer een release met een **stale in-game changelog** (zoals 1.8.0 die t/m
1.5.5 toonde), en nooit meer verkeerde tekst op de CurseForge-pagina.

Releases zijn **geautomatiseerd**: een `v*`-tag pushen laat de BigWigs-packager de zip
bouwen (volgens `.pkgmeta`) en uploaden naar CurseForge. Alles hieronder gaat dus vóór
de tag.

## 1. De vijf artefacten (allemaal bijwerken)

1. **`MidnightHelper.toc`** → `## Version:` bumpen.
2. **`Modules/Changelog.lua`** → de in-game "what's new"-popup. Nieuw blok BOVENAAN
   `CHANGELOG_ENTRIES` met `version = "<nieuw>"` + `lines = { "CHANGELOG_<ver>_1", ... }`.
3. **`Locales/enUS.lua`** → de `CHANGELOG_<ver>_*`-keys. **Alleen enUS.** De in-game
   changelog is Engels-only sinds 2.4.0; de andere packs vallen terug op de enUS-fallback.
   (nlNL bevat nog oude vertalingen t/m 1.8.6 — niet uitbreiden.)
4. **`RELEASE_NOTES.md`** (root) → **de CurseForge-releasenotitie.**
5. **`CHANGELOG.md`** → de volledige geschiedenis (dev/GitHub).

Plus: archiveer een kopie in **`docs/CURSEFORGE_<ver>.md`**, en check of
**`CURSEFORGE_DESCRIPTION.md`** (evergreen paginabeschrijving) nog klopt met de nieuwe
tabs/features.

### ⚠️ RELEASE_NOTES.md — de valkuil

De packager uploadt dit bestand **letterlijk en volledig** (`.pkgmeta` →
`manual-changelog`). Daarom:

- Het bevat **alleen de huidige release**. Het ooit op `CHANGELOG.md` richten zou 700+
  regels geschiedenis op elke releasepagina plakken. (Die fout stond klaar en is bij
  v2.6.0 net op tijd gevangen — de `manual-changelog`-regel had tot dan nooit gedraaid.)
- **Overschrijf het bij elke versie-bump.**
- Elke notitie-voor-onderhoud moet in een `<!-- HTML-commentaar -->` staan, anders
  rendert 'ie bovenaan de publieke pagina. (Dat is bij 2.6.0 misgegaan.)

> Zelfcheck: zet `MidnightHelperDB.changelogDevCheck = true` op je dev-install. Bij login
> waarschuwt de addon als de TOC-versie nieuwer is dan het bovenste changelog-blok.

## 2. Verifiëren vóór de tag

- `luac -p` (of luacheck) op elk gewijzigd Lua-bestand.
- Controleer dat elke gebruikte locale-key bestaat (een ontbrekende key toont de rauwe
  key-naam, geen error).
- `/reload` op een schone install: geen Lua-errors bij login, óók direct in combat.
- Nieuwe features openen (tabs renderen, taal wisselen = geen blokjes).
- Bij een grote release: **eerst Beta** (`v<ver>-beta1`) voor Cisca, dan pas Release.

## 3. Taggen (dit publiceert)

```
git tag -a v<ver> -m "Midnight Helper <ver> — <samenvatting>"
git push origin v<ver>
```

- Een schone tag (`v2.6.0`) → **Release**. Een tag met `-beta` → **Beta**.
- De packager leest `X-Curse-Project-ID` uit de TOC en gebruikt het GitHub-secret
  `CF_API_KEY`. Dat **moet een legacy CF-token** zijn (UUID, via
  legacy.curseforge.com/account/api-tokens) — een Core/Eternal-key faalt met
  "Error fetching game version info" en slaat de upload stil over.
- Run controleren zonder `gh` CLI: `https://api.github.com/repos/Huijting/MidnightHelper/actions/runs?per_page=3`.

## 4. Screenshots (als er nieuwe features zijn)

1. Ga in-game op een **donkere, vlakke plek** staan. Dat is het enige wat de rig niet
   voor je kan doen: de wereld achter het venster is niet weg te poetsen.
2. Zet de tekstgrootte van MH een stap hoger — leesbaarheid wint van informatiedichtheid
   in een thumbnail.
3. `/mh shots` → de rig parkeert het venster op een vaste maat, loopt door zeven scènes,
   schiet elke scène en onthoudt de bijbehorende bijsnij-rechthoek.
4. `/reload` (WoW schrijft SavedVariables pas dan weg).
5. `powershell -ExecutionPolicy Bypass -File tools\Crop-Shots.ps1` → identiek uitgesneden
   PNG's in `Screenshots\mh-shots\`.

Volgorde in de galerij is de bestandsvolgorde. Shot 1 (This Week, met "Nu doen") is de
thumbnail en bepaalt of iemand doorklikt; shot 2 (mounts + 3D-preview) is het enige beeld
met kleur en beweging. De rest is bewijs van diepgang.

Het boss-venster staat níét in de rig — dat is een zwevend venster; schiet dat met de hand.

## 5. Wat de packager NIET doet

De **projectpagina-beschrijving**. Plak `CURSEFORGE_DESCRIPTION.md` daar handmatig als
die is bijgewerkt.

## 6. Vaste werkafspraak

**Elke feature-batch werkt de in-game changelog in dezelfde commit bij** (Changelog.lua +
de enUS-keys). Dan staat het bij release altijd actueel en hoeft het niet als losse stap
"onthouden" te worden.

## Handmatig bouwen (fallback)

`powershell -ExecutionPolicy Bypass -File tools\package.ps1` → `dist/MidnightHelper-<ver>.zip`.
De zip-root moet exact `MidnightHelper/` zijn; geen `.bat/.cmd/.ps1/.py/.exe`, geen
docs/tools/dev-bestanden. Het script faalt de build als er iets doorglipt.
