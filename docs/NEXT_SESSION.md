# Next session — Midnight Helper

**Laatste update:** 2026-07-01 (tweede sessie)
**Huidige versie in de repo:** **2.2.0-beta.1** (code klaar; **nog niet gebouwd/geüpload** — als **Beta** bedoeld)
**Vorige live versie:** 2.1.1 (Release), daarvoor 2.1.0

> Start hier morgen in een nieuwe chat. Dit bestand vat samen waar we staan, hoe we
> werken, en wat er nog ligt. Lees ook `CHANGELOG.md` [2.2.0-beta.1] voor de details.

---

## Deze sessie (2026-07-01, deel 2) — standalone route-pijl (2.2.0-beta.1)

**Aanleiding:** Rob logde in op **Cisca's PC** — óók met 2.1.1 verdween daar de pijl.
Cisca **heeft** TomTom (geen "TomTom is not loaded"-melding), dus 2.1.1's fix (puur
TomTom) hielp haar niet. Root cause: de hele "pijl overleeft aankomst / schuift door"-
machinerie zat vast aan TomTom; zonder (of met een haperende) TomTom kreeg je één
Blizzard-waypoint zónder keepalive → verdwijnt bij aankomst. Ook: `HereBeDragons`
werd geléénd van TomTom/HandyNotes (niet gebundeld) → cross-map re-pin brak op een
oude/afwezige HBD.

**Gebouwd (code klaar, niet in-game getest):**

| Wat | Bestand |
|-----|---------|
| Generieke native keepalive op Blizzard-waypoint + SuperTrack (volgt `ns.lastTarget`, her-zet bij aankomst, schuift door) — werkt zónder TomTom én als vangnet als TomTom's crazy arrow wég is | **NIEUW** `Modules/NativeArrow.lua` |
| **Eigen on-screen richtingspijl** (draait naar target, live afstand, versleepbaar, positie in `MidnightHelperDB.nativeArrowPos`) — want retail heeft géén ingebouwde draaipijl. Rob (2e sessie): native pin alleen was niet genoeg. `ROTATION_OFFSET` = één-regel-fix als de pijl omgekeerd wijst | idem `Modules/NativeArrow.lua` |
| TOC: module geregistreerd (na Delves) + versie → 2.2.0-beta.1 | `MidnightHelper.toc` |
| `ForceArrowToLead`: HBD-vertaling vervangen door lib-vrije `C_Map`-vertaling (`TranslateToMap`) | `Modules/Achievements.lua` |
| Changelog (in-game `CHANGELOG_220_*` in enUS, CHANGELOG.md, CF-doc) | `Modules/Changelog.lua`, `Locales/enUS.lua`, `CHANGELOG.md`, `docs/CURSEFORGE_2.2.0.md` |

**Ontwerpkeuze (belangrijk):** NativeArrow staat **volledig stil** zolang TomTom's
crazy arrow zichtbaar is (`_G.TomTomCrazyArrow:IsShown()`), dus Robs werkende setup
regresseert niet. Alleen bij **geen TomTom** of **arrow-down** stuurt het de native
waypoint. Het ruimt alleen de waypoint op die het zélf zette (nooit een handmatige).

**Zone-robuustheid (het terugkerende bug-patroon — NIET meer aan `ns.lastTarget`
koppelen!):** meerdere modules wissen `ns.lastTarget` in hun zone-handlers (bv.
`Delves.lua` runZoneNavCheck → `IsMidnightTravelComplete` → `ns.lastTarget = nil`),
waardoor de pijl verdween bij de stad/zone uitvliegen. NativeArrow leunt daarom op de
**stabiele** `ns._mhRouteOwner` (die enkel wist als de route écht klaar is) en houdt
een **eigen gecachete lead** (`activeLead`). Een tijdelijke `ns.lastTarget = nil` kan
de pijl dus niet meer doden — alleen owner→nil doet dat. Herbouw dit nooit op
`ns.lastTarget` alleen.

**Resize (Rob's verzoek):** slider in **Settings > General** (`SET_ARROWSIZE_*` in
en/nl) + `/mh arrowsize <28-160>`; opgeslagen in `MidnightHelperDB.nativeArrowSize`,
live via `ns.SetNativeArrowSize`. `ns.PreviewNativeArrow(sec)` flitst de pijl bij het
slepen/schalen. Pijl-textuur = `Interface\MinimapArrow` (basaal; mooiere .tga kan later).

**Auto-advance bij niet-gespawnde rare (Rob: geen /mh skip laten tikken):** in
`NativeArrow` latcht `UpdateArrow` (~30x/s) of je binnen `RARE_ARRIVAL` (40 yd) van de
lead kwam (vangt snelle fly-overs). De 1s-tick roept `ns.MHRareTryAutoAdvance(reached)`
(Rares.lua): is de rare bereikt maar z'n **vignette niet up** (= niet gespawned) en je
bent **niet in combat** → skip 'm naar achteren; de pijl gaat naar de volgende. Een
geskipte rare komt vanzelf terug zodra z'n vignette verschijnt (spawn) of als de rest
klaar is. Nooit de laatste open rare wegskippen. Geverifieerd via web dat vignette-
detectie de standaard is (RareScanner) mét de kanttekening "niet elke rare heeft een
vignette" → daarom terug-cyclen.

**UNIVERSALITEIT + CONVENTIE (belangrijk voor toekomstige routes):** NativeArrow werkt
generiek voor élke route die de gedeelde conventie volgt:
1. claim de arrow met `ns._mhRouteOwner = "<type>"` (en zet 'm op nil als de route echt
   klaar is — NOOIT bij zonewissel),
2. houd de huidige lead in `ns.lastTarget` (of, als je module `ns.lastTarget` nilt zoals
   Rares/Professions, expose een `ns.GetNearestIncomplete<X>Lead()` en laat NativeArrow
   die volgen — zie de rare/treasure-blokken in `NativeArrow.lua` Tick).
Nu gedekt: **Achievements, Rares, Professions/Treasures (deze sessie toegevoegd via
`ns.GetNearestIncompleteTreasureLead`), Reset-routine.** Een nieuwe route die de
conventie volgt krijgt pijl + zone-robuustheid + keepalive + doorschuiven gratis mee.
Rolt 'ie z'n eigen (TomTom-only) systeem zoals Professions ooit deed → dan valt 'ie
buiten de boot; sluit 'm dan aan op dezelfde backbone.

**Nog te doen (volgende sessie):**

1. **In-game test** (zie `docs/CURSEFORGE_2.2.0.md` testlijst) — mét én zónder TomTom,
   en op Cisca's PC.
2. Bevestigen dat Cisca's geval nu écht opgelost is. Zo niet: `/mh arrowdebug` aan op
   haar PC en de output bekijken (welke tak faalt) — dán pas verder.
3. Build + CF-upload (Rob doet dit; **Release type = Beta**).
4. Daarna pas terug naar taak #65 (Leveling-tab herzien).

---

## Werkafspraken (BELANGRIJK — lees dit eerst)

- **Taal:** antwoord in het **Nederlands**, kort en direct.
- **never-lie:** nooit ID's, coördinaten of criteria verzinnen. Verifieer altijd:
  in-game macro-dump, of kruis-check via HandyNotes_Midnight / Zygor / Wowhead.
  Liever "ik weet het niet, laten we dumpen" dan gokken.
- **Git & CurseForge doet Rob/Cursor**, niet de assistent. De assistent **geeft** het
  commit-commando en de CF-checklist, maar triggert nooit zelf een upload. Pas
  handelen op "ga".
- **Mount-truncatie:** bewerk addonbestanden ALTIJD met de host-tools (Read/Edit/
  Write/Grep). **Niet** via bash/python — de mount levert verouderde/afgekapte kopieën
  en grote bestanden lezen via bash is onbetrouwbaar. Verifieer balans via host-Grep;
  Rob's `/reload` in-game is de finale syntaxcheck.
- **Web:** alleen WebSearch / web_fetch. Nooit curl/bash/python om URLs te halen.
- **Releases:** de **volgende belangrijke versie eerst als Beta** op CF zetten, zodat
  Rob het bij Cisca kan testen vóór het naar iedereen gaat. (2.1.0/2.1.1 waren Release
  zonder beta — dat willen we niet meer bij grote wijzigingen.)

---

## Deze sessie (2026-07-01) — gedaan, zit in 2.1.1

De hele dag is gegaan naar het robuust maken van de **TomTom-route-pijl** op de
Achievements-tab, plus de **Light Up the Night**-meta. Alles in `Modules/Achievements.lua`.

| Onderwerp | Status |
|-----------|--------|
| Pijl verdween bij aankomst / na detour-kill / bij **sub-zone-kaartwissel** | Opgelost |
| Checklist-leesbaarheid (zebra + hover-highlight) | Klaar |
| `/mh skip` respecteren in de pijl-herstel | Klaar |
| Light Up the Night: live uitsplitsing 4 zone-meta's (header + rijen) | Klaar |
| Accurate tooltips per zone-meta (echte groen/rood, zelf opgebouwd) | Klaar |
| Petalwing-mount-preview op klik (via `ns.PreviewItem`) | Klaar |
| `/mh arrowdebug` diagnostics-toggle | Klaar |
| Changelog (in-game `CHANGELOG_211_*`, CHANGELOG.md, CF-doc) | Bijgewerkt |

### Hoe de pijl-fix werkt (zodat we het niet opnieuw hoeven uitvogelen)

**Kernprobleem:** TomTom's crazy arrow rendert alleen als de waypoint op de kaart staat
waar de speler NU is. Cross-map (sub-zone vs overworld, bv. Slayer's Rise 2444 vs
Voidstorm 2405) → pijl verbergt zich. En `TomTom:SetClosestWaypoint()` zoekt alléén op
de huidige speler-kaart, dus die vindt een cross-map node niet.

**Oplossing** (in `Achievements.lua`):
- `ForceArrowToLead()` pint de pijl op de route-**lead** (`ns.lastTarget`), en vertaalt
  die node naar de kaart waar de speler staat via **HereBeDragons**
  (`LibStub("HereBeDragons-2.0")`: `GetWorldCoordinatesFromZone` →
  `GetZoneCoordinatesFromWorld`). `cleardistance=0` (niet auto-wissen), announce gemute.
- `RepointArrowNearest()` roept eerst `ForceArrowToLead()`; alleen zonder lead valt het
  terug op TomTom's eigen `SetClosestWaypoint`.
- De keepalive-ticker (elke 2s) herpint **proactief** bij: kaartwissel (`mapChanged`),
  lead-wissel (`leadChanged`, bv. na skip), pijl-drop (`justDropped`), of weglopen van
  een node (`walkedOff`). NIET als je < 25 yd bij de lead staat (geparkeerd op een
  niet-gespawnde rare) → anders oscillatie. Plus een re-point op combat-end.
- `_G.TomTomCrazyArrow:IsShown()` = orphan-detectie (pijl-frame verborgen = gevallen).
- `/mh arrowdebug` print per beslissing de staat (owner, frameShown, playerMap vs
  leadMap, found/forced). Default uit.

**Gedeelde arrow-eigenaar:** `ns._mhRouteOwner` ("achievement"/"rare"/"treasure"/
"reset"/nil) arbitreert tussen modules (Rares.lua, ResetRoutine.lua, Profession.lua).

### Light Up the Night (meta 62386 → Brilliant Petalwing, item 252011)

- Vereist 4 **zone-meta's**: Forever Song (Eversong), Making an Amani Out of You
  (Zul'Aman), That's Aln, Folks! (Harandar), Yelling into the Voidstorm (Voidstorm).
  Elk vraagt méér dan de treasures/rares/telescopen/lore die MH trackt (ook quests,
  reputatie, world events) — die zijn niet te routen, alleen te tonen.
- `MetaDetailData()` leest de 4 criteria live; `RefreshMetaDetail()` bouwt de header-rij
  (de meta zelf) + 4 zone-rijen. Tooltip = zelf opgebouwd via `AddAchCriteriaLines`
  (NIET `SetAchievementByID` — die kleurt meta-subs ten onrechte allemaal groen).

---

## Volgende klus (afgesproken)

1. **Leveling / beta-tab herzien** (taak #65). Rob: *"ergens hoort ie er niet op deze
   manier in, hij is te summier en te vrijblijvend."* Dit was de hoofdreden om door te
   gaan na de Achievements-tab. Begin met: wat staat er nu, wat is de bedoeling, en een
   voorstel vóór we bouwen. **Doe deze als Beta-release richting Cisca.**

## Backlog (optioneel)

- `ACH_META_PREVIEW_HINT` staat nu alleen in en/nl; de/fr/es/pt/it vallen terug op EN.
  Eventueel later toevoegen in `Locales/Translations2026.lua`.
- Eventueel diepere per-zone tracking voor Light Up the Night (nu alleen tonen, niet
  routen — bewust, want quests/rep/events zijn niet waypoint-baar).

---

## Snelle commands

In-game:
```text
/reload
/mh skip          (sla de huidige route-node over)
/mh arrowdebug    (diagnostics aan/uit — default uit)
```

Build (Cursor/PowerShell, in de git-repo — de WoW-map heeft geen .git):
```powershell
git add -A
git commit -m "..."
powershell -ExecutionPolicy Bypass -File tools\package.ps1   # -> dist\MidnightHelper-<versie>.zip
```

CF-upload (Rob doet dit zelf): zip-root exact `MidnightHelper/`, geen tools/docs/.git/
scripts in de zip; display version = TOC-versie; game version Retail 120007 (12.0.7).
Changelog-tekst staat klaar in `docs/CURSEFORGE_<versie>.md`.
