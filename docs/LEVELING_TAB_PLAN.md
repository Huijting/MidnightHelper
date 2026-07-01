# Leveling Guide — herontwerp-plan (review vóór code)

**Status:** voorstel ter review (Rob). Geen code gewijzigd. Aanleiding: Rob's gevoel dat
de Leveling Guide "er eigenlijk niet in hoort, zeker niet in deze vorm". Drie expert-
brainstorms (product / player-experience / engineering) + code-verificatie hieronder.

> ## ✅ BESLISSING (Rob, 2026-07-01)
> De huidige per-class/spec-gids gaat **eruit** en wordt vervangen door een
> **class-agnostische Midnight 80→90 leveling-helper met handige tips**, in een
> **eigen tab op de plek van de huidige Leveling Guide**. Rationale: past bij Midnight
> (dít leveltraject), tips i.p.v. coach (geen concurrentie met RestedXP/Zygor), en
> class-agnostisch = géén per-class×spec×level onderhoudsmonster. Stroomt op 90 over in
> de weekly-loop. Content wordt **web-onderzocht + door Rob in-game bevestigd** (never-lie).
> Vorm/plaatsing-vragen (§5.1/§5.2) hiermee beantwoord; blijft open: tips/stats behouden
> (§5.3) en Beta-eerst (§5.4).

---

## 1. Diagnose (waarom de huidige vorm wringt)

MH's identiteit = **actiegerichte, Midnight-specifieke, live endgame/weekly-loop-tooling**
(routes, trackers, waypoints, reset-routine). De Leveling Guide is **generiek, statisch,
cross-expansion, en link-naar-buiten** (Icy Veins). Dat botst met 3 van de 4 identiteits-
pijlers. Concreet:

- **Vrijblijvend/passief:** linkt vooral uit en toont statische tips i.p.v. iets te *doen*.
- **Concurreert** met toegewijde tools (RestedXP / Zygor / Icy Veins) die dit beter doen.
- **Onderhoudslast (gekwantificeerd):** ~12.160 `GUIDE_*` locale-key-voorkomens over 9
  talen. De twee grootste kostenposten:
  - `Locales/GuideAdvisor.lua` = **5.152** keys (per-level rotation/defensive/talent-
    brackets) — veruit het grootste patch-onderhoud.
  - `Locales/GuideTips.lua` = **2.787** keys (spell-tips).

### Code-verificatie (grounding)
- **Lage koppeling:** `ns.GuideData` heeft **geen consumers** buiten `Addons/Guide.lua`
  zelf + `.toc` + UI-plumbing + docs/tools. Verwijderen is dus laag-risico.
- **Consumables zijn een dubbele, verouderde kopie:** GuideData's platte
  `consumables = {feast,food,flask,potion,rune}` wordt overtroffen door de endgame-bron
  `ns.ConsumablesWowheadByClassSpec` (`Modules/ConsumablesWowheadData.lua`, 12.0.5 /
  "Midnight Season 1", met best/alternates, flask/combat-/healing-potion/augment-rune/
  feast/food + noteKeys), die al z'n eigen paneel + ready-check heeft.
- **Bouwstenen voor een max-level-onboarding bestaan al:** `GetMaxLevelForPlayerExpansion`
  (al gebruikt in DelveWeeklyTrackers), `PLAYER_LEVEL_UP`, `Modules/StartHere.lua`
  (never-lie auto-afvinkende stappen), `Modules/GearEnchantCheck.lua`,
  `Modules/VaultReminder.lua` + `Modules/VaultAdvisor.lua`, `Modules/RoleAcademy.lua`,
  en de giver-`minLevel`-logica in `ResetRoutine.lua`.

---

## 2. Wat de drie brainstorms zeiden (convergentie)

- **Niemand** wil het houden zoals het is; **niemand** wil een live leveling-coach bouwen
  (verloren gevecht vs RestedXP/Zygor).
- Product + player-experience wijzen onafhankelijk naar dezelfde unieke plek: **de
  overgang van "ding op max" → de weekly endgame-loop** die MH al beheerst. Geen enkele
  leveling-addon dekt "het eerste uur op max" — die stoppen juist dan. Bonus: dit lost
  MH's **funnel** op (een uitgelevelde speler ontdekt precies dan waar MH goed in is).
- Engineering: sloop sowieso het onderhoudsmonster (`GuideAdvisor.lua` + de dubbele
  consumables); dat is 80% van de pijn voor 20% van het werk.

---

## 3. Aanbevolen aanpak — twee fasen

### Fase 1 — Opschonen (doe dit sowieso; laag risico, hoge winst)
Onafhankelijk van welke eindrichting we kiezen:

1. **Verwijder de per-level advisor-brackets.** Weg: `Locales/GuideAdvisor.lua` (5.152
   keys) + de `leveling = { [10]/[30]/[60]/[80] = {rotation/defensives/talentFocus} }`-
   blokken in `Addons/GuideData.lua` en de bijbehorende render-code in `Addons/Guide.lua`.
2. **De-dup consumables naar één bron.** Verwijder GuideData's `consumables`-veld; laat
   elke consumables-weergave live lezen uit `ns.ConsumablesWowheadByClassSpec`.
3. **Behoud (voorlopig):** spell-tips (auto-naam/icoon via `C_Spell.GetSpellInfo`), stat-
   prioriteit, gear-concept, Icy-Veins-link — als dunne "voor de details → hier"-gids,
   OF meteen mee verwijderen (zie Fase 2 / alternatieven).

**Effort:** med (mechanisch, raakt meerdere bestanden + locale-chirurgie + CI
`guide-tips-audit.yml`). **Risico:** med — grep álle `GUIDE_`, `guide`, `_mhGuide`,
`panels.guide` refs vóór het verwijderen van locale-entries (nil-errors vermijden).

### Fase 2 — Vervang door "Ding Handoff" (endgame-onboarding)
De unieke MH-feature: een **eenmalige, actiegerichte** gids die een verse max-level char
de weekly-loop in leidt. Herbruikt de StartHere/ResetRoutine-patronen; **never-lie**
(elke stap auto-afgevinkt uit een echt signaal).

- **Trigger:** char bereikt effectief max level (`GetMaxLevelForPlayerExpansion`), of
  `PLAYER_LEVEL_UP` naar max; eenmalig per char via een SavedVar-vlag (zoals de arrow-pos
  / giver-learn opslag). Ook oproepbaar via de tab en `/mh` command.
- **Inhoud (geordende, auto-afvinkende stappen — hergebruik bestaande signalen):**
  1. Gear/ilvl-startpad (crafted/catch-up piece; `GearEnchantCheck` voor enchants/sockets).
  2. Eerste **delve-tier** + wekelijkse delve-caps (DelveWeeklyTrackers).
  3. Eerste **Great Vault**-unlock (VaultReminder/VaultAdvisor-state).
  4. **Giver-unlocks** + weekly's (ResetRoutine's giver-logica, incl. `minLevel`).
  5. **Ritual Sites / Void Assaults** intro + weekly (RitualSites/VoidAssaults-state).
  6. Handoff-knoppen naar de bestaande tabs (SelectTab) + "Set reset route".
- **Plaatsing:** vervangt de content van de huidige `guide`-tab (of verhuist naar/naast
  "Start Here"; te beslissen — zie open vragen). Zichtbaarheid: standaard tonen tot de
  loop draait; daarna opvouwen (zoals StartHere z'n "hide this" al doet).
- **Effort:** med (vooral een geordende step-list à la StartHere + één trigger + SavedVar-
  vlag; plumbing/among signals bestaan al). **Risico:** laag-med (nieuwe UI, maar op
  beproefde patronen; never-lie houdt claims eerlijk).

---

## 4. Alternatieven (als Fase 2 niet gewenst is)

| Optie | Wat | Effort | Onderhoud daarna | Risico |
|------|-----|--------|------------------|--------|
| **A. Helemaal eruit** | Verwijder Guide.lua + GuideData + guide-locales + tab-gate + `guideVisibility`-setting + CI/tools. | med | ~nul | laag-med |
| **B. Slim (alleen Fase 1)** | Sloop advisor + dubbele consumables; houd dunne gids (tips+stats+links). | laag-med | matig (tip/stat/gear-tekst blijft) | med |
| **C. Ding Handoff (Fase 1 + 2)** | Opschonen + endgame-onboarding als vervanging. **Aanbevolen.** | med | eigen endgame-onderhoud (beweegt mee met wat MH al trackt) | laag-med |

**Niet doen (consensus):** een live per-class/spec leveling-coach (rotation-popups per
level). Hoog onderhoud, direct concurrerend met RestedXP/Zygor, en buiten MH's identiteit.

---

## 5. Open vragen voor Rob

1. **Eindrichting:** C (Ding Handoff, aanbevolen), B (alleen opschonen), of A (weg)?
2. **Plaatsing Ding Handoff:** eigen tab (op de plek van de huidige guide) óf integreren
   in de bestaande **Start Here**-tab (die dekt al new-player-onboarding — mogelijk logischer)?
3. **Tips/stats/gear behouden?** Als losse "spec-basics"-strip (evt. in RoleAcademy), of
   helemaal laten vallen? (Engineering: alleen doen als spelers erom vragen.)
4. **Release-vorm:** grote wijziging → conform werkafspraak eerst als **Beta** naar CF
   (Cisca-test) vóór Release?

---

## 6. Voorgestelde volgorde van uitvoeren (na akkoord)

1. Fase 1 opschonen in een aparte batch (verifieerbaar: `/reload` zonder Lua-errors,
   guide-tab toont nog steeds netjes de afgeslankte inhoud of is netjes weg).
2. Fase 2 Ding Handoff bouwen op de vrijgekomen plek.
3. Changelog + CF-doc; Beta-build; Cisca-test; daarna Release.
