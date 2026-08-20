# Coördinatie tussen twee Claude Code-sessies

Rob werkt met **twee sessies tegelijk** op deze repo:

- **ONDERZOEK** — zoekt uit, verifieert, schrijft specs en geheugen. Raakt geen code aan.
- **BOUW** — implementeert, refactort, commit code.

⚠️ **De live-map ÍS de git-repo.** We werken niet op kopieën maar in dezelfde working
tree. Zonder afspraken commit de één het half afgemaakte werk van de ander, of overschrijft
een edit omdat er een oudere versie in zijn context zat. Dat is geen randgeval, dat is de
standaarduitkomst.

---

## De vijf regels

### 1. Eigenaarschap per BESTAND, niet per onderwerp

| Wat | Van wie |
|---|---|
| `Modules/`, `Locales/`, `tools/`, `.toc` | **BOUW** |
| `docs/SPEC_*.md`, `docs/HANDOVER_*.md`, `docs/RESEARCH_*.md` | **ONDERZOEK** |
| `docs/` overig (`API_WATCH.md`, `NEXT_SESSION.md`, `PTR_*.md`, `VAULTS_*.md`) | **BOUW** |
| `~/.claude/.../memory/MEMORY.md` | **ONDERZOEK** (zie regel 4) |

Onderwerpen verdelen ("jij doet delves, ik doe professions") werkt **niet** — één onderwerp
raakt altijd allebei de kanten. Bestandsgrenzen werken wel.

### 2. ONDERZOEK levert specs, geen code

Output van ONDERZOEK is altijd een nieuw bestand met een eigen naam
(`docs/SPEC_NN_ONDERWERP.md`), nooit een edit in bestaande code. Sluit aan op wat er al is:
Spec 01, 05, 06, 07, 08, 22. BOUW leest de spec en implementeert.

### 3. Wie schrijft, commit meteen — en nooit `git add -A`

Niet-gecommit werk dat blijft liggen is de grootste ramp. Kleine commits, direct na het
schrijven, en **alleen je eigen bestanden bij naam**:

```
git add docs/SPEC_23_PROFESSION_ADVISOR.md      ✅
git add -A                                       ❌ pakt het werk van de ander mee
```

### 4. Eén sessie bewerkt `MEMORY.md`

ONDERZOEK houdt de geheugenindex bij, want die legt het onderzoek vast. BOUW mag losse
memory-bestanden schrijven maar raakt de index niet aan — anders wint de laatste schrijver
en verdwijnt de andere edit geruisloos.

### 5. `git status` vóór je begint

Zie je wijzigingen die niet van jou zijn, dan werkt de ander op dat moment aan die
bestanden. Pak iets anders of wacht. Raak nooit een bestand aan dat als gewijzigd
openstaat en niet van jou is.

---

## Wie claimt nu wat

Bijwerken aan het begin en einde van een klus. Eén regel per claim, direct committen.

| Sessie | Bestanden | Sinds | Status |
|---|---|---|---|
| BOUW | `Modules/GearEnchantCheck.lua`, `docs/API_WATCH.md`, `tools/_probe.py` | 20 aug 2026 | in bewerking (gezien via `git status`) |
| ONDERZOEK | `docs/COORDINATION.md`, `docs/HANDOVER_DELVES_12_1.md` | 19–20 aug 2026 | klaar |

---

## Wachtrij — klaar om gebouwd te worden

### 1. Profession Knowledge-adviseur (Alchemy + Herbalism) — spec volgt

**Wat**: MH had een "Advice goal"-knoppenrij (Allround / Gold / Self-sufficient) in
`Modules/ProfessionsHub.lua`. Die is op **22 juli verwijderd** omdat
`ns.MH_SetProfAdvisorGoal` / `ns.MH_GetProfAdvisorGoal` nooit geschreven zijn — de knoppen
deden niets terwijl de tooltips uitlegden wat ze zouden doen. `GOAL_DEFS` en de
`PROFHUB_GOAL_*`-locale keys zijn **bewust bewaard** voor de dag dat er geverifieerde
routes zijn.

**Nu is die dag er, voor twee professions.** Onderzoek 19–20 aug 2026 leverde geverifieerde
volgorde-adviezen voor Alchemy en Herbalism op, met bronnen en met de onzekerheden expliciet
benoemd.

**Twee dingen die eerst gerepareerd moeten worden:**

- 🔴 **Feitelijke fout in de Academy.** `PROFACAD_CH_TREES_BODY` (Locales/enUS.lua) zegt:
  *"Knowledge Points are permanent: there is currently no way to refund or respec them."*
  Dat is **onjuist sinds 11 aug 2026**. Correcte formulering: één reset per profession, bij
  **Theremis** in Silvermoon (`/way #2393 45.0 56.0`), en bij **Darla Fluxy** in Dornogal
  voor TWW-professions sinds 11.1. ⚠️ Schrap de zin niet zomaar — dat duwt hem van te
  streng naar te losjes, en dát is de gevaarlijkere fout. De reset **wist ook je via KP
  geleerde recepten**, en er is er maar één.
- 🟡 **Vindbaarheid.** Rob — de opdrachtgever zélf — wist niet dat de Academy al starter
  builds voor Alchemy en Herbalism bevat. Als hij het niet vindt op het moment dat hij het
  nodig heeft, vindt geen enkele beginner het.

**Scope-waarschuwing, belangrijker dan de feature zelf:** buildadvies botst met de
never-lie-regel. *"Multicraft > Ingenuity > Resourcefulness"* is geen feit maar een
economisch oordeel dat per realm en per patch verschuift. Houd de scope bij wat
verifieerbaar is: wat doet deze stat, wat ontgrendelt deze node en heb je dat al, wat is de
afweging tussen twee takken, en de waarschuwing vóór de reset. Voor een kant-en-klare
ranking: link naar Wowhead. Mechanismeuitleg veroudert traag, "beste build" veroudert per
patch — en we hebben elf professies met elk een eigen boom.

**Marktonderbouwing** (verkenning 20 aug 2026): elf profession-addons trackken knowledge
points, **nul** leggen uit wat je ermee moet. Bouw dit **niet** als losse addon —
ontdekbaarheid is de doodsoorzaak in die niche (KnowledgeLoadout 168 downloads,
MidnightGather 399, GatherBuffs 852, tegenover Myu's 2.9M en Routine 2.6M). In MH landt het
bij mensen die er al zijn.

### 2. Delve-tiers 12.1 — geen bouwopdracht, wel leesplicht

Zie `docs/HANDOVER_DELVES_12_1.md`. Bevat vier getallen die **niet geëncodeerd mogen worden**
zonder eigen meting (vault-ilvl per tier, Journey-punten per tier, levens per tier,
shard-cap), en noemt het bewust lege `vault`-veld in `DELVE_LOOT_TABLE_S2`.
