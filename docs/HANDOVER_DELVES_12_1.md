# Handover — delve-tiers & Bountiful in 12.1

**Van:** sessie 19 aug 2026 (Rob + Claude, onderzoeksronde met 3 research-agents)
**Voor:** de andere Claude Code-sessie op deze repo
**Status van de code:** ⚠️ **ER IS GEEN REGEL ADDON-CODE GEWIJZIGD IN DEZE SESSIE.**
Geen commits, geen edits in `Modules/`. Je bent dus niet geblokkeerd — maar lees §4
voordat je delve-data aanraakt.

---

## 1. Wat deze sessie heeft opgeleverd

Onderzoeksvraag van Rob: *wat levert een Bountiful delve op t.o.v. een gewone, en wat is
het verschil tussen tier 8/9/10/11 — **buiten de loot om**?*

Volledige uitwerking staat in het geheugen: `delve-tiers-12-1.md`
(in `~/.claude/projects/E--World-of-Warcraft--retail--Interface-AddOns/memory/`).
Dit document is de korte versie voor coördinatie.

### Kernbevindingen

| | |
|---|---|
| **Loot T8-T11** | **Identiek.** Gemeten in Robs eigen client: tiers 8-11 delen één reward-context (37/121/107). Eindkist 295, Trovehunter's Bounty 305 op alle vier. Staat al in `Modules/Delves.lua` → `DELVE_LOOT_TABLE_S2`. |
| **Officiële tier-drempels** | Er bestaan er maar **twee**: **T6+ Bountiful** (Afflicted/Tormented Souls → Nightmare Hunt + bonus Champion-/Hero-gear, 1×/week/char) en **T11 Bountiful** (Ascendant Venomstone — aangekondigd, nog **niet actief**). T8/T9/T10 komen in geen enkele officiële 12.1-bron voor als drempel. |
| **Bountiful vs gewoon** | Bountiful = enige bron van Delver's Journey-voortgang én Valeera-XP boven lvl 15, plus Souls/curio-upgrades. **Voor de Great Vault maakt het niets uit.** |
| **Tier-unlock** | Alleen **Tier 4** is officieel gegate (level 90 + Midnight-campagne op je warband). Nergens staat dat je N moet clearen voor N+1. |
| **Great Vault** | World-rij: **2/4/8** completions → 1/2/3 slots. Ilvl = **de laagste tier van je BESTE N runs** (top-N, niet laatste-N). Eerste vault van S2 is gecapt op **Champion 3/6**, daarna max **Hero 1/6**. |

### Belangrijke nuance die makkelijk misgaat

Een wereldactiviteit kan een **al verdiend** vault-slot **niet** omlaag trekken. 2× T11 +
een world quest houdt slot 1 op T11-niveau; de world quest bepaalt alleen het slot dat hij
zelf ontgrendelt (bij 4 resp. 8 completions). Rob vroeg hier expliciet naar.

---

## 2. Wat NIET waar is (circuleert wel)

- ❌ *"Tiers 8-11 kwamen pas vrij op 18 augustus."* Onjuist. Kaivax 1 aug: "During the
  pre-season week, Delve difficulties **1-11** will be available." Op 18 aug kwamen alleen
  **bountiful, keys en de "??" Nemesis** vrij. De patch notes zeggen "push into the upper
  tiers … beyond Tier 7" — dat is marketingtekst die Blizzards eigen blue post tegenspreekt.
- ❌ *"Rank 4 ontgrendelt de Gilded Stash."* Support 000374685: de stash valt ook daaronder,
  maar geeft dan **Hero- i.p.v. Myth-crests**. Frequentie is **4×/week** (niet 3×).
- ❌ *"Valeera's cap is 60."* Armory-achievement "Buddy System VII: raise Valeera to level
  **70**". De veelgenoemde 80 is onbevestigd.
- ❌ *"Tank-Valeera schaalt van 45% naar 29% schadereductie over T1-T11."* Ingetrokken —
  bestond alleen in een zoekmachine-samenvatting.

---

## 3. ⛔ Open vragen — NIET ENCODEREN zonder eigen meting

Dit is het belangrijkste deel voor jou. Deze getallen zijn **onbevestigd**; als jij ze in
een tabel zet en de andere sessie meet ze, krijgen we tegenstrijdige data.

1. **Great Vault-ilvl per tier.** `DELVE_LOOT_TABLE_S2` heeft **bewust een leeg
   `vault`-veld**. Guides zeggen 305, EverythingDelves 298. `vaultIlvlByTier` in de SV was
   op 19 aug leeg. `LearnVaultIlvlByTier()` vult dit uit Robs eigen vault — **laat dat zijn
   werk doen, vul het niet met de hand.**
2. **Delver's Journey-punten per tier.** Spelermeting (12.0.1): clear 150/175/200/250 en
   coffer 200/225/250/300 voor T8/9/10/11 ≈ **57% meer Journey per run op T11**. Guides
   beweren "250 ongeacht tier". Blizzard zegt er **niets** over. Als dit klopt is het het
   enige echte argument voor T11 boven T8 — maar het is nog niet gemeten op 12.1.
3. **Levens per tier** (5/4/3/3). Eén guide-bron. Officieel bestaat alleen de frase
   "with lives remaining" in achievementteksten. Geen aantal, geen timer.
4. **Shard→key-verhouding en weekcap** (100 per key, 600/week). Alleen spelerclaims.

**Er bestaat geen officiële tier→ilvl- of tier→crest-tabel voor Season 2.** De 12.1 patch
notes hebben helemaal geen Delves-sectie. Alles wat je online in zo'n tabel ziet is
datamine, handwerk of verzinsel.

---

## 4. Coördinatie — wie raakt wat aan

**Deze sessie heeft aangeraakt:**
- `memory/delve-tiers-12-1.md` (nieuw), `memory/mh-market-position.md` (sectie toegevoegd),
  `memory/MEMORY.md` (2 indexregels).
- Scheduled task `completion-navigator-recheck` (eenmalig, 19 sep 2026) — losstaand
  concurrentie-onderzoek, raakt delves niet.
- **Geen addon-code, geen commits.**

**Als jij aan de delve-kant gaat bouwen, claim dan expliciet:**
`Modules/Delves.lua` · `Modules/DelveCoach.lua` · `Modules/DelveWeeklyTrackers.lua` ·
`Modules/MidnightCodexData.lua` (delve-/vault-entries)

**Nog niet gebouwd, wel besproken:** een Codex-onderwerp dat dit uitlegt ("bountiful koop
je voor Journey/XP/Souls, tier koop je voor crests en achievements, boven T8 verandert er
aan je gear niets"). Rob heeft dit **nog niet goedgekeurd** — vraag het hem voordat je
begint, en bouw het niet op de onbevestigde getallen uit §3.

---

## 5. Bronnenwaarschuwing

- De eerste zoekpagina over dit onderwerp is vrijwel volledig **boost-verkoopsites** met
  verzonnen mechanics.
- **"Season 2" is dubbelzinnig**: TWW S2 = 2025, Midnight S2 = aug 2026.
- **Blizzard Support is hier de rijkste officiële bron**, niet de patch notes — kijk daar
  eerst bij vervolgvragen over vault/stash/keys.
- 🚨 Eén research-agent in deze ronde **verzon citaten** (≈ een derde van één rapport,
  gereconstrueerd i.p.v. opgehaald, pas bij een eigen controleronde teruggenomen). Vraag bij
  agent-onderzoek altijd om **woordelijke citaten mét URL**, en behandel een vlot lopend
  citaat zonder ophaalbewijs als onbetrouwbaar.
- Betrouwbaar tijdssignaal: **geen enkele Midnight-bron noemt Brann** — die noemt Valeera.
  Een "Midnight"-bron die Brann noemt is gerecycled TWW-materiaal.
