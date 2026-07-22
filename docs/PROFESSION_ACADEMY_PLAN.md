# Profession Academy — designplan (pilot: Enchanting & Alchemy)

Status: design, 7 juni 2026. Doel: professions begrijpelijk maken voor beginners,
in de geest van MH ("never lie", waypoints, checklists, 6 talen). Pilot met
Enchanting en Alchemy; daarna uitbreidbaar per professie via data-modules.

## Probleem

Het Midnight-professionsysteem is voor nieuwelingen ondoorzichtig: Knowledge
Points zijn **permanent** (geen respec!), trees unlocken op verschillende
skill-levels, recepten komen uit vijf verschillende bronnen, en de wekelijkse
KP-bronnen verschillen per professie. Het spel legt hier vrijwel niets van uit.

## Researchfeiten (Wowhead/Method/wow-professions, maart-juni 2026)

### Systeem (12.0, "TWW-achtig met wendingen")

- **Knowledge Points (KP)**: per crafting/gathering-professie een spec-tree;
  Cooking/Fishing/Archaeology hebben er geen. **KP zijn permanent — geen
  respec, ook niet via unlearn.** (Datamining hintte op spec-resets in 12.0.5,
  niet bevestigd live — verifiëren.)
- **Artisan's Moxie** vervangt Acuity en is **professie-specifiek** (bijv.
  currency 3256 Alchemist's, 3258 Enchanter's). Koopt recepten, mat-zakken en
  KP-boeken. Vuistregel: ±5x Moxie per verdiende KP (first crafts: 10x).
- **First crafts**: +1 KP + 10x Moxie per recept, eenmalig — elke nieuwe recipe
  minstens één keer craften.
- **Eenmalige KP**: 8 Knowledge Treasures per professie (+3 elk) verspreid over
  de zones; +10 KP-boek bij renown 6/9 (Enchanting/JC/Tailoring → Silvermoon
  Court 6; Alchemy/BS/Eng → The Singularity 9; LW/Mining/Skinning → Amani 6;
  Herb/Inscription → Hara'ti 6); Abundance-event-boek +10 (alleen Ench, Herb,
  Mining, Skinning; vendor Chel the Chip, npc 241928).
- **Wekelijkse KP**: trainer-weekly (via intro-quest bij Captain Flaresworn,
  npc 243283, Work Order-station Silvermoon; Enchanting vereist skill 25);
  2 treasure-drops per craftprof (+2 elk); Thalassian Treatise (+1, warbound,
  via Inscription); Darkmoon Faire +3 KP +15 Moxie (maandelijks); patron orders
  (craftprofs **behalve Enchanting**).
- **Enchanting is uniek**: KP via disenchanten — 5x Swirling Arcane Essence
  (item 267654, +1 elk) → daarna 1x Brimming Mana Shard (item 267655, +4) =
  +9/week. Catch-up via Glimmering Powder (item 267653). Geen patron orders.
- **Catch-up**: bestaat; activeert pas nadat de gewone weeklies gedaan zijn.

### Goudmijn voor "never lie"-tracking

Weekly treasure-drops hebben **per-professie quest-flags** (bron:
Wowhead-comment, te verifiëren op PTR/live met
`/run print(C_QuestLog.IsQuestFlaggedCompleted(ID))`):
Alchemy: Lightbloomed Spore Sample 93528, Aged Cruor 93529 ·
BS: 93530/93531 · **Enchanting: Voidstorm Ashes 93532, Lost Thalassian
Vellum 93533** · Eng: 93534/93535 · Inscription: 93536/93537 ·
JC: 93538/93539 · LW: 93540/93541 (Amani Tanning Oil/?) — let op: 93541 is
volgens de bron Thalassian Mana Oil; mapping LW/Tailoring exact verifiëren ·
Tailoring: 93542/93543.

### Enchanting — 4 trees (unlock-volgorde verifiëren)

Elevating Equipment · Disenchanting Delegate · Spellbound Shatterer ·
Transitories, Tonics & Tools. Consensus-advies beginners: **Spellbound
Shatterer eerst** (Shatter Essence-buff: Resourcefulness/Ingenuity/Multicraft),
daarna Elevating Equipment (30 in root, dan 20 in subspec; Weapon/Ring/Chest
populairst), Disenchanting Delegate voor mat-zelfvoorziening.

### Alchemy — 4 trees

Potion Prowess (potions, Light/Void-split) · Fluent in Flasks (flasks/phials +
group-cauldron) · Transmutation Authority (transmutes + multicraft) ·
Alchemical Mastery (resourcefulness). Unlocks op skill 25/50/60/75. Advies
beginners: eerste 20-30 KP in **Fluent in Flasks of Potion Prowess** (meest
waardevolle recepten; flasks verkopen het hele jaar). Dag-1 potentieel: ±40-50
KP uit first crafts + treasures.

## Drie concepten (gefaseerd, hergebruiken elkaar)

### A. Profession Academy (fase 1) — begrijpen

RoleAcademy/Codex-patroon: korte hoofdstukken mét in-game praktijkopdracht die
de addon zelf detecteert (vinkje verschijnt vanzelf):

1. "Wat is Knowledge?" → opdracht: open je spec-UI (`C_ProfSpecs`-events).
2. "Trees kiezen zonder spijt" (KP = permanent!) → opdracht: bekijk de
   aanbevolen tree (nog geen punt zetten — eerst lezen).
3. "Waar komen recepten vandaan?" → bronnenkaart trainer/renown/vendor/drop/
   first-craft met TomTom-waypoints (Flaresworn, Chel the Chip, trainers).
4. "Moxie & first crafts" → opdracht: doe een first craft (KP-currency-delta).
5. "Je wekelijkse routine" → professie-specifiek; intro op de weekly-checklist
   (concept B).
6. Prof-hoofdstukken: Enchanting (disenchant-economie, vellums, shatter-buff),
   Alchemy (flasks vs potions, transmutes, experimenteren).

Voortgang per character in SavedVariables; tekst via Codex-render; 6 locales.

### B. Weekly KP-checklist (fase 2) — quick win, hoogste waarde/effort

In AccountWeeklyChecklist-stijl, per professie van de speler:
treasure-drops (quest-flags 935xx — live checkbaar!), trainer-weekly,
treatise gebruikt (item-flag/buff verifiëren), Darkmoon (maandelijks),
Enchanting-essences (bagscan 267654/267655-progressie), patron orders
(niet-Ench). Elke regel: status + waypoint waar relevant. Data-only module
per professie (patroon ShowdownsData).

### C. Tree Advisor (fase 3) — kiezen

VaultAdvisor-patroon: kies doel (Goud / Zelfvoorziening / Goedkoop levelen) →
aanbevolen tree-volgorde + "volgende X punten hier" + één zin waarom.
Gewichten-tabellen per prof per doel (curated uit guides, transparant).
Leest huidige tree-state via `C_ProfSpecs` (configID/treeID per professie).

### (Later) D. Profession Coach — Delve Coach-patroon, max 3 acties "nu doen",
gevoed door A+B+C-data. Pas na validatie van de eerste drie.

## Eigen addon?

Nee: start als MH-onderdeel (hergebruik locales/waypoints/checklist/Codex én
bestaand publiek). Data-modules zo schrijven dat afsplitsen later kan
("Midnight Profession Coach") zonder herschrijven.

## Geverifieerde API & IDs (7 juni, Rob live + Wowhead)

### C_ProfSpecs (vraag 3 ✅, live op Robs main)

- Child-skillLine nodig, niet base (333 → config 0). **Midnight child-IDs**
  (Wowhead skill=2906-2918; 2909 ook in-game): Alch 2906, BS 2907, Ench 2909,
  Eng 2910, Herb 2912, Insc 2913, JC 2914, LW 2915, Mining 2916, Skin 2917,
  Tailor 2918 (Cooking 2908/Fishing 2911 = secondary, geen tree). Staat nu in
  `ProfessionAcademyData.specSkillLines`.
- `GetConfigIDForSkillLine(2909)` = 52497993 (pas geldig na openen
  Specializations-tab? — login-gedrag nog checken).
- `GetSpecTabIDsForSkillLine(2909)` → 1152 Spellbound Shatterer, 1153
  Disenchanting Delegate, 1154 Transitories, 1155 Elevating Equipment
  (namen via `GetTabInfo(tab).name`).
- `C_Traits.GetTreeCurrencyInfo(cfg, tab, false)[1]` = { quantity=onbesteed,
  spent=besteed } — profession-breed (identiek per tab).
- `GetRootPathForTab(tab)` → nodeID; `C_Traits.GetNodeInfo(cfg, node)
  .activeRank`: 1 = unlocked/onaangeroerd, >1 = punten erin (maxRanks 31).

### KP-treasures: waypoints + quest-flags (vraag 7 ✅, Wowhead-comment Tenebrarum)

Alle one-time treasures per prof met `/way`-coords én quest-flag-IDs (reeks
**89067-89184**) staan in de comment op wowhead.com/skill=2906 (en kopieën op
2907/2910). Per prof 7-8 stuks, zones 2393/2395/2405/2413/2437/2444/2536.
Voorbeeld Enchanting: Sin'dorei Enchanting Rod 89107, Everblazing Sunmote
89103, Loa-Blessed Dust 89106, Enchanted Amani Mask 89100, Primal Essence Orb
89105, Entropic Shard 89104, Pure Void Crystal 89102. Tailoring: 89078-89085.
Alchemy: 89112-89118. → Direct bruikbaar voor concept B-checklist (flags zijn
in-game checkbaar). **Let op:** BS "Rutaani Floratender's Sword" staat in de
ene kopie als 89182, in de andere als 80416 — in-game verifiëren. Volledige
lijst scrapen bij bouw van B.

## Open vragen / PTR-verificatie (Rob)

**METING 22 juli 2026 (Rob, live, via `/mh kp`) — DISENCHANT-BRON SLUIT NIETS AAN.**
Brimming Mana Shard (item 267655, "Use: Study to increase your Midnight Enchanting
Knowledge by 4") uit disenchanten. Gemeten **vóór** gebruik: alle 16 vlaggen false.
**Ná** gebruik: alle 16 nog steeds false, terwijl de onbestede KP wél opliep van
10 naar 14 — dus het studeren werkte aantoonbaar. Conclusie: noch het oprapen,
noch het studeren van een KP-item uit disenchanten raakt deze reeks.

Wat daarmee NIET is uitgesloten: de reeks heet in de bron "weekly treasure-drops",
en een echte open-wereld-schat is nog steeds niet getest. Dat blijft de enige
openstaande meting. Levert die ook niets op, dan is deze reeks niet wat we dachten
en vervalt het idee van een leesbare wekelijkse KP-voortgang — zie
`Modules/ProfessionNextStep.lua`, dat daar bewust al niets over beweert.

1. Quest-flag-IDs 93528-93543 verifiëren (welke flipt na welke drop, reset
   woensdag?) — `/run for i=93528,93543 do if C_QuestLog.IsQuestFlaggedCompleted(i) then print(i) end end`
   na een drop. **Nulmeting (Rob, main Tailor+Ench, zo 7 juni): alle 16
   false** — consistent met "nog geen drop deze week". **Extra datapunt
   (zelfde dag):** trainer-weekly Splintered Radiance ingeleverd + Folio
   (+3 KP-studie-item) ontvangen → reeks blijft leeg; 935xx is dus écht
   exclusief voor de open-wereld-treasure-drops. Volgende datapunten:
   (a) direct na een +2 KP-item-drop (noteer itemnaam!), (b) woensdag na
   reset. Voor de checklist-regel volstaat: paar hoort bij prof + reset
   wekelijks. Open: gelden drops ook onder max level (82-alt mag meetesten)?
2. Treatise-gebruik detecteerbaar? (quest-flag of alleen item-verbruik.)
3. ~~`C_ProfSpecs`-API~~ ✅ — zie hierboven; alleen login-gedrag (config 0
   vóór openen spec-tab?) nog checken.
4. Spec-reset uit 12.0.5-datamining: live gekomen of niet? (Bepaalt toon van
   hoofdstuk 2: "permanent!" vs "duur respeccen".)
5. Trainer-weekly quest-IDs (questlog-dump zoals bij Showdowns).
   **Deels ✅ (Rob, live 7 juni): Enchanting = "Splintered Radiance" 93698**
   (10 Radiant Shards → Dolothos; beloning Thalassian Enchanter's Folio +
   Fused Vitality + ~34g). Let op: de weekly komt van de PROFESSIE-TRAINER
   (Dolothos), niet van Flaresworn — Flaresworn is alleen de intro/Work
   Orders. Flag-check 93698 na inleveren: ⬜ (verwacht true; woensdag-reset
   ⬜). Tailoring-ID via Belspa: ⬜. Overige profs: zelfde patroon
   verwachten, per trainer dumpen.
6. Renown-KP-boeken: exacte vendor + kosten in Moxie (Wowhead-tabel toonde
   0 Marl + 5 Moxie — klopt dat in-game?).
7. ~~KP-treasures~~ ✅ — coords + flags 89067-89184 gevonden (zie hierboven);
   alleen de BS-discrepantie (89182 vs 80416) in-game checken.

## Concept D — "Nu doen"-kaart (build-spec, 20 juni 2026)

Doel: het Overview-paneel opent met één klein kaartje dat alle losse data
samenvat tot **max 3 concrete acties voor déze week** — zodat een verwarde
speler niet hoeft te lezen/puzzelen ("wat moet ik nú doen?"). Geen nieuwe tab
of module: het kaartje wordt bovenaan de **bestaande** Overview gerenderd
(`ProfessionsHub.lua` → `RefreshOverview`).

### Waar precies

- Nieuwe FontString `hub._phNowCard`, geankerd **boven** `hub._phOverviewText`
  (of als eerste regel ín de bestaande `ot`-tekst — voorkeur: aparte FS met
  eigen kleur/kader zodat 'm visueel opvalt).
- Gevuld in `RefreshOverview()` vlak vóór `BuildWeeklyText()`/`BuildAccessoryHint()`.
- Refresh hangt al aan de juiste events (de ev-frame in `BuildProfessionsHubPanel`
  luistert op SKILL_LINES_CHANGED/TRAIT_CONFIG_UPDATED/QUEST_LOG_UPDATE/BAG_UPDATE).

### Data — alles bestaat al, niets nieuws scrapen

| Actie-bron | Herkomst (bestaand) |
|------------|---------------------|
| Trainer-weekly open? | `weekly.trainerQuests[skillLine]` + `C_QuestLog.IsQuestFlaggedCompleted` (zie `BuildWeeklyText`) |
| Enchanting-essences X/5 → Brimming | `weekly.enchantingEssences` + `C_Item.GetItemCount` (zie `BuildWeeklyText`) |
| Volgende tree-punt | `BuildAdviceLine` / `GetAdviceForProf` + `GetSpecSummary` (ProfessionAcademy.lua) |
| KP-treasure dichtbij/open | `MIDNIGHT_DATA`/treasure-flags 89067-89184 (Profession.lua) — alleen als al ontsloten in code |
| Prof-tool ontbreekt | `AllProfToolsEquipped` (ProfessionAcademy.lua) |

> Niets verzinnen: een actie verschijnt **alleen** als de onderliggende
> bron 'm hard kan bevestigen (quest-flag false, bagcount < need, tool-slot leeg,
> advies-node niet maxed). Anders valt de regel weg — net als de rest van MH.

### Prioriteitsregels (max 3 regels)

Vaste volgorde, stop na 3:
1. **Tool ontbreekt** (blokkeert craften) — hoogste urgentie.
2. **Trainer-weekly open** (per prof) — grootste KP-bron.
3. **Enchanting-essences** nog niet op 5/5 (alleen Ench).
4. **Volgende tree-punt** (alleen tonen als er onbesteed KP is: `summary.unspent > 0`).
5. **Dichtstbijzijnde open KP-treasure** (alleen als treasure-data al in code zit).

Edge cases:
- **Geen prof**: kaartje verbergen (Overview toont al de pick-advice).
- **Alles klaar deze week**: groene regel `PROFNOW_ALL_DONE` ("Je bent bij deze week — kom woensdag terug.").
- **2 profs**: acties per prof prefixen met profnaam (zoals `BuildWeeklyText` al doet).

### Format (voorstel, met kleur/icoon-conventie van de hub)

```
|cffffd966Deze week|r
▸ Enchanting: trainer-weekly open  (/way Silvermoon — Dolothos)
▸ Enchanting: essences 2/5 → disenchant 3 items
▸ Alchemy: zet je volgende KP-punt in Fluent in Flasks (12/30)
```

Iconen: hergebruik `ICON_OPEN`/`ICON_DONE` (al gedefinieerd in ProfessionsHub).

### Nieuwe locale-keys (6 talen, enUS+nlNL echt; de/fr/es/pt via SafeL → EN)

- `PROFNOW_HEADER` = "Deze week" / "This week"
- `PROFNOW_ALL_DONE` = "Je bent bij deze week — kom woensdag terug."
- `PROFNOW_TRAINER_FMT` = "%s: trainer-weekly open"
- `PROFNOW_ESSENCE_FMT` = "%s: essences %d/%d → disenchant"
- `PROFNOW_TREE_FMT` = "%s: zet je volgende KP-punt in %s (%d/%d)"
- `PROFNOW_TOOL_FMT` = "%s: rust een tool uit (geen craften zonder tool)"
- `PROFNOW_TREASURE_FMT` = "%s: KP-treasure open in %s"
  (laatste alleen als treasure-bron betrouwbaar is — anders key weglaten in v1)

### Build-checklist (klein, veilig, in één commit + in-game test)

1. Locale-keys toevoegen in `enUS.lua` + `nlNL.lua` (rest valt via SafeL terug).
2. Helper `BuildNowCardText()` in `ProfessionsHub.lua` (leunt op bestaande
   `weekly`-data + `ns.MH_*`-advies-API; voeg evt. een kleine getter toe in
   ProfessionAcademy als de advies-node-data nog niet publiek is).
3. FontString `_phNowCard` aanmaken in `BuildProfessionsHubPanel`, ankers
   herzien (card boven `ot`; `ot` dan onder de card ankeren — let op de
   anchor-chain van Overview).
4. `RefreshOverview` vult de card; verbergen wanneer leeg.
5. `luac`-syntaxcheck (`tools\lua_syntax_check.py`) + `/reload` + per prof checken.
6. In-game verifiëren op een char mét en zónder open weekly; daarna commit.

> v1-scope bewust klein: regels 1-4 (tool/trainer/essence/tree). Treasure-regel
> (5) pas toevoegen als de treasure-"open + dichtbij"-bron hard te lezen is.

### Verificatie tegen de code (Claude, 20 juni) — spec is build-klaar, met 1 randje

Alle genoemde haakjes bestaan en zijn geverifieerd: `RefreshOverview`,
`_phOverviewText`, `BuildWeeklyText`, `BuildAccessoryHint`,
`BuildProfessionsHubPanel`, `ICON_OPEN/ICON_DONE` (ProfessionsHub.lua); de
events SKILL_LINES_CHANGED/TRAIT_CONFIG_UPDATED/QUEST_LOG_UPDATE/BAG_UPDATE zijn
geregistreerd; `_phNowCard` is terecht nieuw. De advies-API
(`GetSpecSummary`/`GetAdviceForProf`/`BuildAdviceLine`/`AllProfToolsEquipped`,
`summary.unspent`) bestaat in ProfessionAcademy.lua.

**Eén concrete bouwstap erbij (anders blokkeert de build):** die vier helpers
zijn **`local function`** in ProfessionAcademy.lua — de hub kan ze nu níét
aanroepen. De trainer-weekly + essences komen wél uit de hub-eigen `weekly`-data
(geen getter nodig). Dus v1 heeft **2 kleine publieke getters** nodig in
ProfessionAcademy.lua, vóór stap 2 van de checklist:

- `ns.GetProfSpecSummary(baseSkillLine)` → wrappt `GetSpecSummary` (voor de
  tree-regel: `summary.unspent`, huidige/volgende node + naam).
- `ns.AreProfToolsEquipped()` → wrappt `AllProfToolsEquipped` (voor de tool-regel).

(De tree-tekst zelf kan via `ns.GetProfSpecSummary` in de hub samengesteld
worden, of voeg optioneel `ns.GetProfAdviceLine(skillLine)` toe als we exact
dezelfde zin als de Overview willen.) Read-only wrappers, taint-veilig — geen
gedragswijziging aan de bestaande Academy-tab.

## Bronnen

- wowhead.com/guide/midnight/professions/knowledge-points-artisans-moxie
  (incl. comment Tzui002888 met quest-flag-IDs)
- wowhead.com/guide/midnight/professions/enchanting-specializations
- wowhead.com/guide/midnight/professions/alchemy-specializations
- wow-professions.com/midnight/enchanting-specialization-guide-and-builds
- wow-professions.com/midnight/alchemy-specialization-guide-and-builds
- method.gg/guides/all-profession-knowledge-point-sources-in-midnight
- icy-veins.com/wow/professions
