# Ritual Coach — designplan (idee 0b)

Status: design, 8 juni 2026. Doel: een Coach voor Ritual Sites in de geest van
de Delve Coach — overzicht, fases, per-mechanic tips en party-share — met
"never lie", waypoints, 6 talen. **Nog niet bouwen: eerst dit plan reviewen
(Rob), dan fasering afspreken.** Research-batch-aanpak zoals de prof-hoofdstukken:
Claude levert geverifieerde feiten + datamodel, Rob verifieert in-game en levert
de praktijk-nuances.

## Probleem / kans

Ritual Sites (12.0.5) zijn schaalbare 1–5-speler-instances (Delve-achtig) die
meetellen voor de World-rij van de Great Vault. De diepte zit in de **tier- en
challenge-keuze bij de Curious Obelisk**: 8 modifiers, elk met een eigen
mechanic en een eigen unlock-pad, en een Spoils/death-scoresysteem dat bepaalt
hoeveel je overhoudt. Het spel legt de mechanics en de optimale challenge-mix
niet uit. Dat is precies het gat dat een Coach vult — en de 8 challenges zijn
perfecte tip-eenheden (1 mechanic per kaart), net als de Delve-secties.

## Wat MH hier al voor heeft (inventaris)

### `RitualSites.lua` (bestaat, 571 r.) — de "waar/wanneer"-helft

Al aanwezig en herbruikbaar:
- Twee roterende sites met coords + actieve-site-detectie (AreaPOI-scan rond de
  obelisk; valt veilig terug op "beide tonen" als de API niets geeft).
- Weekly meta-quest `95843` (`IsRitualWeeklyDone`), Field Accolade currency
  `3405`, renown-faction `2792` (major-faction én classic-rep fallback).
- TomTom-routing naar de actieve site + hub (Bazaar 2e verdieping, 2393/48.2/49.4),
  inclusief re-assert-na-revive.
- Publieke API die Home en WorldContent al consumeren: `ns.GetActiveRitualSite`,
  `ns.IsRitualWeeklyDone`, `ns.GetRitualSites`, `ns.RouteRitualSite`,
  `ns.RouteRitualHub`, `ns.GetRitualAccoladeInfo`, `ns.GetRitualRenownText`,
  `ns.RitualSiteZoneName`.

Wat ontbreekt (= de Coach): **alle content** — fases, mechanics, challenge-uitleg,
tier-advies, en de share-knoppen.

> ⚠️ Coords-check: `RitualSites.lua` heeft Daggerspine op **37.59/65.20**; de
> guides noemen **34.9/65.4** voor de obelisk-ingang (Goldenmist Village, westkust).
> Broken Throne 29.7/78.2 matcht wél. Eén van beide is de site-marker vs. de
> obelisk zelf — in-game verifiëren welke we voor routing willen.

### Delve Coach-infra (bewezen patroon, te spiegelen)

- **`DelveTipsData.lua`** — datamodel: entries met `id` / `rosterName` / `nameKey`
  / `poiId` / optionele `zoneAliases` / `sections[] = {titleKey, bodyKey}`.
  Body-tekst staat in `Locales/DelveTips.lua` (per taal).
- **`DelveCoach.lua`** (1662 r.) — paneel + live content-refresh.
- **`DelvePartyShare.lua`** — `BuildDelvePartyShareLines(entryId, mode)` bouwt de
  share-regels uit de eigen locale-pack; `DoSendLines` verstuurt + roept de sync aan.
- **`DelveShareSync.lua`** (v2) — prefix `MHDelve`, payload
  `"1|<chatLocale>|<mode>|<entryId>"`, cross-locale ontvangst (tekst nooit over de
  lijn, alleen IDs). Dit is de infra die de notes willen generaliseren.
- **`DelveTipMarkup.lua`** — markup-helpers voor de tip-tekst.

## Researchfeiten (Blizzard-nieuwspost 14 apr + Wowhead/Method/Skycoach/Overgear/wow.gg, apr–mei 2026)

### Kernmechaniek

- 1–5 spelers, instanced, Delve-achtig; telt voor de **World-rij van de Great
  Vault** (naast Delves en Prey). Solo volledig ondersteund.
- **Twee sites, wekelijkse rotatie** (één actief): **Daggerspine Point**
  (Eversong Woods, **naga**) en **Broken Throne** (Zul'Aman, **Twilight's Blade-
  cultisten**). Actieve site krijgt een paarse map-icon.
- **Curious Obelisk** = ingang + UI: kies **Tier 1–5** + challenges, preview de
  rewards. Groepsleider kiest voor de hele party.
- **Tier-gating:** elke tier moet eerst gecleard zijn voor de volgende.
  Tier 3 vereist **1** challenge actief, Tier 4 **2**, Tier 5 **4**.
- **Spoils = score.** Verslagen vijanden droppen Spoils i.p.v. normale loot; aan
  het eind een **Ritual Chest** waarvan de inhoud meeschaalt met Spoils.
- **Deaths:** eerste **2** doden zijn gratis; elke dood daarna **−5%** Spoils,
  tot **max −50%**. UI toont Spoils + Deaths + eind-performance-score.
- **Wekelijkse tier-decay:** de vereiste tier om een challenge te *unlocken* zakt
  elke week met 1 — zo unlockt iedereen op termijn alles. (Je kunt dus **niet**
  alle 8 in één week unlocken.)
- **Fases:** objectives/trash → (mini-boss) → eindboss → Ritual Chest.
- **Regeneration Orbs** (Renown 1): in combat manifesteren orbs die **15%** HP
  healen; **Orb Potency** (Renown 4) verdubbelt dat naar 100% meer healing.

### De 8 Challenges (modifiers) — tip-eenheden

Mechanic + unlock zijn redelijk consistent over bronnen; de **Spoils-% verschillen
tussen bronnen** (zie verificatie-blok). Hieronder de **Blizzard-nieuwspost-waarden
als primair**:

| Challenge | Mechanic (wat doe je ertegen) | Unlock | Spoils % (Blizzard) |
|---|---|---|---|
| **Tendrils** | Grijpende tendrils met groene cirkel — eruit lopen (root + schade) | Loot uit een Ritual Chest (quest "Ritual Site Challenge Report: Tendrils"), direct inleveren | 10% |
| **Manifestations** | Geesten casten spells — **interrupten** | Clear Tier 3, praat met **Ranger Captain Lilatha** (Silvermoon) | 15% |
| **Magical Alarm Bells** | Kills summonen adds; grotere/heroïschere pull = sterkere reinforcements | Clear Tier 4, praat met **Lady Darkglen** | 13% |
| **Malevolent Boons** | Obelisks buffen vijanden — **vernietig de obelisks** | Clear Tier 2 → quest Lady Darkglen → **investigeer 5 Dark Obelisks** in-site | 20% |
| **Tainted Corpses** | Gedode vijanden laten void-zones achter — vermijden | **Tainted Bone Pile** lootem in een Tier 2+-site (Eversong 66.09/62.58, Zul'Aman 47.91/36.52) | 10% |
| **Reinforced** | Extra vijanden door de hele site | Clear Tier 2, praat met **Ranger Captain Lilatha** | 15% |
| **Patrols** | Elite-patrouilles — **vermijden** waar kan | "Procure" unieke treasures uit een Tier 3+-site | 15% |
| **Embers** | Random vijanden **én de eindboss** empowered (zwevende orb) | Loot **Ember of Power** in een Tier 4-site (start quest) | 25% |

Optimaliseringsadvies uit de guides (voor het Coach-advies later): de hoogste-%
challenges stapelen additief — Embers (25) + Malevolent Boons (20) + een 15%-er
geeft de beste Spoils, mits de groep ze schoon aankan. Schone clears > snelle
pulls (doden kosten direct Spoils).

### Renown-track (8 rangen) — bonussen, niet alleen cosmetics

1 Regeneration Orbs · 2 Ritual Treasures · 3 Ritual Decor · 4 Outlying Dangers +
Orb Potency · 5 Shrines of Power + Additional Spoils · 6 Corrupted Menagerie +
Orbs Aplenty · 7 Revered Treasures + Dark Obelisk + Shrines of Power II ·
8 Corrupted Transport + Elite Dangers.

Renown-boosters: **Ritual Site Reports** (extra renown o.b.v. behaalde Spoils),
**Ritual Tablet Fragment** (+500 renown, 2e site v.d. week), **Ritual Tablet**
(+750 renown, 1e site v.d. week). Renown ook via Void Assaults (gedeeld).

### Currencies & vendors (2e verdieping Bazaar, Silvermoon)

- **Field Accolades** (currency 3405, al in `RitualSites.lua`) = hoofdcurrency,
  ook uit Void Assaults + weeklies. Champion/Hero-gear caches via **Maren
  Silverwing** (48.2/49.6).
- **Tweede currency:** ✅ **geverifieerd = Voidlight Marl** (currency-tab Rob,
  8 juni; niet "Dark Particles"/"Duskglow Marl"). Wisselbaar naar Field Accolades.
  Currency-ID nog te dumpen als we 'm willen tonen.
- Quest/turn-in-NPC's: Ranger Captain Lilatha, Lady Darkglen, Rae'ana,
  Maren Silverwing, Sergeant Vornin, Kul'amara the Fierce (spelling/locaties wisselen
  per bron → verifiëren). Renown-unlock zit achter de **Ritual Interest**-quest in
  de Void-Assaults-lijn (start "Ranger Captain's Summons", Lilatha 48.0/49.6).

## In-game verificaties

### ✅ Opgelost 8 juni (Rob, obelisk @ Daggerspine + currency-tab)

- **Spoils-% per challenge bevestigd — Blizzard-waarden kloppen, niet de
  aggregators.** Tendrils 10 · Manifestations 15 · Magical Alarm Bells 13 ·
  Malevolent Boons 20 · Tainted Corpses 10 · Reinforced 15 · Patrols 15 ·
  Embers 25. Staan nu in `spoilsPct`.
- **Spell-ID + Icon-ID per challenge** geoogst (in `RitualCoachData`): die
  IconID's geven echte in-game icoontjes in de Coach-UI; de SpellID is óók de
  schoonste **unlock-detectie** — geleerd = "Right click to unlearn"
  (`IsPlayerSpell(spellId)` true), ongeleerd = "Click to learn". **Fase 4 gebruikt
  `IsPlayerSpell` i.p.v. quest-flags** (simpeler dan de prof-flag-aanpak).
- **Tweede currency = Voidlight Marl.**
- **Daggerspine-scenario:** "A Strike From the Sea", antagonist **Selen'vjar**
  (naga-leider) — in de PHASES-tekst gezet; eindboss-kill nog te bevestigen.
- Robs char heeft Malevolent Boons / Reinforced / Patrols / Embers geleerd;
  Tendrils / Tainted Corpses / Alarm Bells / Manifestations nog niet — bewijst de
  `IsPlayerSpell`-detectie meteen.

### Nog open (geen blokker voor fase 1/2 — komen vanzelf uit runs)

1. **Tier-ilvl-vereisten** (T1-T5) — obelisk-dropdown toonde ze niet; Skycoach had
   T1 215 / T2 231 / T3 244 / T4? / T5?. Nice-to-have; verifiëren of we ilvl willen tonen.
2. **Eindboss-kill Daggerspine** — Selen'vjar als scenario-antagonist bevestigd;
   kill bevestigt of zij de eindboss is.
3. **Scenario-variatie:** kent Daggerspine naast "A Strike From the Sea" nog een
   tweede layout? (Bepaalt of route-tips per scenario of per site moeten.)
4. **Broken Throne (Zul'Aman)** — scenario/boss + Dark-Obelisk-locaties; pas
   relevant zodra die site actief is (volgende week-rotatie).
5. **Coords obelisk vs. site-marker** (Daggerspine 37.59 vs 34.9 in `RitualSites.lua`).
6. **Currency-ID Voidlight Marl** — alleen nodig als we 'm in de UI tonen.

## Voorgesteld datamodel

Twee soorten content → twee tabellen, gespiegeld op `DELVE_TIP_ENTRIES`:

**A. `RITUAL_SITE_ENTRIES`** (2 entries, per site):
```
{ id = "daggerspine", siteKey = "daggerspine", nameKey = ...,
  sections = {
    {OVERVIEW}, {PHASES}, {BOSS}, {SITE_NOTES},  -- bone pile / obelisks / coords
  } }
```
(`siteKey` linkt naar de bestaande `SITES` in `RitualSites.lua` — één bron voor
coords/detectie, geen duplicatie.)

**B. `RITUAL_CHALLENGES`** (8 entries, de tip-eenheden):
```
{ id = "embers", nameKey, spoilsPct = nil|25,  -- nil tot in-game geverifieerd
  unlockKey, unlockQuestId = nil,               -- voor never-lie "heb ik 'm?"
  sections = { {MECHANIC}, {HOWTO}, {UNLOCK} } }
```

**C. Algemene "hoe werkt het"-entry** (1): tiers, deaths/Spoils-rekenregel,
weekly tier-decay, regen-orbs. Voedt zowel het paneel als een share-mode "intro".

Backlog-consistentie: de challenge-unlock-IDs centraal houden, niet dupliceren in
WorldContent.

## Share-infra: generaliseren of parallel? (architectuurkeuze — graag Robs voorkeur)

De notes opperen het payload-content-type. Twee routes:

- **Optie 1 — generaliseren (notes-voorkeur):** payload wordt
  `"2|<locale>|<type>|<mode>|<entryId>"` met `type ∈ {delve, ritual}`; `DelveShareSync`
  wordt `MHShareSync` met een dispatch op type naar `BuildDelvePartyShareLines` /
  `BuildRitualShareLines`. Eén prefix, één ontvangstpad, proto-bump naar "2"
  (ontvangers met proto "1" negeren de nieuwe; backward-safe). **Mooist op termijn**,
  maar raakt de net-geteste Delve-share v2 (0a, klaar-voor-CF) → wil ik niet in
  dezelfde release riskeren.
- **Optie 2 — parallel `RitualShareSync.lua`:** kopie van het v2-patroon met eigen
  prefix `MHRitual`, proto "1". Geen risico voor Delve-share, sneller te bouwen;
  prijs is wat duplicatie (later samen te voegen).

**Aanbeveling:** Optie 2 nu (isoleert risico, Delve-share v2 blijft intact voor de
aankomende CF-release), Optie 1 als opruim-refactor ná die release. Open voor Robs
keuze.

## UI-voorstel

Coach-sectie/sub-tab in de **Void & Rituals-tab** (waar de Ritual-content al leeft):
boven de bestaande site-info een "Coach"-blok met (a) actieve site + fase-overzicht,
(b) een challenge-picker-lijst (mechanic-tips + jouw unlock-status), (c) tier-advies,
(d) de **share-knop** (Brief/Full) zoals de Delve Coach. Hergebruikt
`ns.GetActiveRitualSite` voor de juiste site-content.

## Locale-structuur

`RITUAL_CHAT_<ID>_<SECTIE>`-keys (zoals voorgesteld in de notes) zodat de
cross-locale-ontvangst gratis meewerkt — tekst komt nooit over de lijn, alleen
`<type>|<entryId>|<mode>`. Pilot in enUS + nlNL (zoals DelveTips), daarna de
overige 4 talen in een vervolgbatch.

## Fasering (voorstel)

1. ✅ **Datamodel + content enUS/nlNL** — `RitualCoachData.lua` + `RitualTips.lua`
   (8 juni; Spoils-%/spell/icon-IDs obelisk-verified).
2. ✅ **Coach-paneel** in Void & Rituals — `RitualCoach.lua` (logica) +
   WorldContent-blok (8 juni): actieve site + how-it-works + challenge-picker met
   icoontjes en **live unlock-status via `IsPlayerSpell`** (vervangt het
   quest-ID-plan van fase 4!). In-game-test unlock-API loopt bij Rob.
3. **Share** (Optie 2): `RitualShareSync.lua` + `BuildRitualShareLines` + knoppen.
4. **Never-lie tracking** — grotendeels al in fase 2 via `IsPlayerSpell`; rest:
   challenge-unlock-hints/voortgang fijnslijpen na Robs in-game-bevestiging.
5. **Lokalisatie** naar de 4 resterende talen + tier-advies-regel.

Eerste concrete stap zodra akkoord: fase 1 (data + EN/NL-content) bouwen; Rob
levert de 8 verificaties hierboven mee terug uit één ritual-run.

## Bronnen

- Blizzard: "Face New Challenges and Disrupt Ritual Sites in 12.0.5" (14 apr 2026) —
  worldofwarcraft.blizzard.com/en-us/news/24244461
- Wowhead ritual-sites-guide (constant, 17 apr 2026) · Method.gg (overview +
  "How to Unlock All Ritual Site Challenges") · Skycoach · Overgear · wow.gg ·
  Mythic-Store. (Onderling verschillen op Spoils-% en NPC-spelling → blok "Open
  verificaties".)
