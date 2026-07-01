# Midnight 80 → 90 leveltips — content-draft (class-agnostisch)

Bron: web-research (Wowhead/Icy Veins e.a.), juli 2026. **Labels:** ✅ = bron-bevestigd ·
🟡 = waarschijnlijk · ⚠️ = **door Rob in-game bevestigen** vóór het in de tab gaat
(never-lie). Dit is de bron voor de nieuwe **Leveling (80→90)**-tab.

---

## 1. Snelste pad 80 → 90
- ✅ De **Midnight-campaign** (17 hoofdstukken) brengt je bijna tot 90; world quests maken het af.
- ✅ **Eerste char moet de campaign doen** — dat unlockt de eindzone **Voidstorm** (tot dan gelocked).
- ✅ Zone-/level-volgorde: **Eversong (80–82) → Zul'Aman/Harandar (~82–88) → Voidstorm (88–90)**.
- ✅ Na de campaign op één char: **Adventure Mode** voor alts (start Sanctum of Light, Silvermoon; zones in willekeurige volgorde, geen lineaire 17 chapters).
- ✅ **Alt-snelroute:** loop alle 8 delves op **Tier 1** op laag level, pak elke *Delver's Call*-quest maar **lever niet in**; quest tot ~87–88; lever dán alle 8 in; eerste-keer-profession-crafts maken het af.
- ✅ Campaign is voor **alts minder XP-efficiënt** dan gewoon questen; dungeon-quests zijn traag → op alts skippen.
- ✅ Totaal 80→90 = **4.963.065 XP**.
- 🟡 Eerste keer casual ≈ 8–10 u; geoptimaliseerde alt ≈ 3–5 u met volle buffs.

## 2. XP-boosts & account-perks
- ✅ **Five Warband Mentors: Midnight** — elke char naar 90 = **+5% account-brede level-XP**, tot **+25%** bij vijf level-90's.
- ✅ **Rested XP** (uitloggen in inn/stad = dubbele XP tot je banked hebt).
- ✅ **Delver's Call-XP schaalt met je level** → laat inleveren (~88) = veel meer XP.
- 🟡 **Heirlooms** geven nog steeds account-brede level-XP-bonus.
- ✅ **Darkmoon Faire** (eerste volle week vd maand): **WHEE!** (carousel) óf **Darkmoon Top Hat** = **+10% XP** (stacken níét onderling; XP-deel werkt in Midnight, rep-deel is eruit gehotfixt).
- ✅ **War Mode** = de **Enlisted**-buff → **+15% XP**, alléén **open-world** (niet in steden/instances). In feb 2026 vlak-generfd naar 15% (was schalend 25–40%). Let op: de War Mode-knop kan een oud/hoger getal tonen — effectief is 15%.
- 🟡 **Battle Standard / gildevlag** in groep = extra XP.
- ❌ **Géén** gilde-"Fast Track"-XP-perk meer (verwijderd in Warlords; in de baseline verwerkt) — niet als losse buff vermelden.

## 3. Unlocks per level (80 → 90)
- ✅ **Skyriding meteen beschikbaar** vanaf de start van Midnight (geen Pathfinder/rep; alleen de basis level-30-license).
- ✅ **Chromie Time** in Midnight dekt **10–70** (Dragonflight default); op 70 versnelde TWW-catch-up.
- ✅ **Adventure Mode** pas voor alts ná campaign op één char.
- ✅ **Delves zijn sub-90 gecapt op Tier 3**; op **90** unlocken alle tiers + **Bountiful Delves**. (Rob in-game bevestigd + zit al in MH: `GetDelveCapLevel` / `DELVE_WEEKLY_UNDERLEVEL_HINT`.)
- ✅ **Professions** kun je tijdens levelen oppakken (Mining/Herbalism voor goud; eerste crafts geven XP).
- ✅ **Ritual Sites** zitten niet op een vast level maar achter **renown (warband-breed)** + een **per-char intro-chain** (*Ritual Interest*, quest 94383). MH trackt dit al op de Void & Rituals-tab (locked/intro/pickup). → tip: "opent via renown + intro-questlijn, niet op een vast level".
- ⚠️ Overige per-level feature-unlocks tussen 80–90 (naast skyriding). **Bevestigen.**

## 4. Consumables tijdens het levelen
- 🟡 Prioriteit: **flask + food eerst**, dan healing-potions, dan situationeel runes/DPS-potions.
- 🟡 Tijdens levelen is **flask + food meestal genoeg** → bewaar augment-runes/dure potions voor zware content.
- ⚠️ Consumable-namen (flask/food/potion/augment-rune) — de research noemde namen maar die moeten **bevestigd** worden als de líve Midnight-consumables. **MH heeft deze data al in `ConsumablesWowheadData` — dáár uit lezen i.p.v. opnieuw invoeren.**
- ✅ **Weapon oils / whetstones** (bijv. Thalassian Phoenix Oil, item 243733) geven **géén XP** — alleen combat-stats, endgame-gericht. Tijdens levelen: **skippen** (niet de moeite/goud waard sub-90).

## 5. Gear onderweg
- 🟡 Quest-greens/dungeon-blues zijn de hele weg prima — **level-gear is wegwerp**.
- 🟡 **Niet enchanten/gemmen/socketen** op level-greens (je vervangt ze constant) — bewaar enchants voor je verse-90-set.
- 🟡 **Crafted / Sparks of Midnight** = endgame catch-up, niet nodig tijdens levelen.
- ✅ Met **Enchanting**: disenchant je quest-greens onderweg (gratis mats + wat profession-XP).
- 🟡 Stop met je druk maken om gear tot 90 — echt gearen (dungeons/delves/vault) start op max.

## 6. De handoff op 90
- 🟡 Hit je 90 vóór het verhaal klaar is → **maak eerst de campaign af** (opent WQ's, renown, Adventure Mode).
- 🟡 **Prey Hunts** bij **Magister Astalor Bloodsworn, Murder Row, Silvermoon** op 90 (voedt Great Vault + Voidforge). MH kent de NPC/locatie al (`SMCChecklistData` `astalor_prey`); alleen het quest-ID nog in-game te vullen — endgame-detail, licht aanstippen.
- 🟡 Week-1 gearing: Normal → Heroic → Mythic 0 → M+/Normal raid; delves voor de weekly cache.
- 🟡 **Great Vault**: haal week 1 de delve/M+/raid-drempels (bijv. 2/4/8 delves) om vault-slots te openen.
- ➡️ **Hierna neemt MH's bestaande endgame-tooling het over** (delves/vault/rares/rituals/reset-routine). Deze sectie = korte brug + knoppen naar die tabs.

---

## ✅ Opgelost via MH's eigen data + Rob
- Delve-cap sub-90 = **Tier 3**; op 90 alles + Bountiful.
- Ritual Sites = **renown (warband) + intro-chain** (Ritual Interest 94383), geen vast level.
- Prey Hunts = Astalor, Murder Row (locatie bekend; quest-ID endgame-detail).
- Consumables = uit `ConsumablesWowheadData` lezen (niet opnieuw invoeren).

## ✅ Externe punten — opgelost (2e research-ronde, web-geverifieerd)
- **War Mode = Enlisted-buff = +15%**, open-world only (feb-2026 vlak-generfd). War Mode & "Enlisted" zijn hetzelfde — niet dubbel tellen.
- **Gilde-XP-perk bestaat niet meer** (verwijderd in Warlords) — niet vermelden.
- **Weapon oils/whetstones = geen XP** (combat-only, endgame) — tijdens levelen skippen.
- **Darkmoon = +10%** (WHEE! óf Top Hat, stacken niet; XP-deel werkt in Midnight).

## Netto stapelbare XP-boosts 80→90 (voor de tab)
Warband-mentors (**+5%/max-level-alt, tot +25%**) · War Mode/Enlisted (**+15%**, open-world) ·
Darkmoon (**+10%** als Faire open) · Rested XP · Heirlooms · (Delver's Call: laat inleveren).

## ⚠️ Enige rest voor Rob (klein, optioneel)
- Heirlooms/Battle-Standard exacte waarde (🟡, cosmetisch voor de tip).
- Prey Hunts quest-ID (endgame-detail, apart van de leveltips).

*Alle ✅/kern-tips zijn nu bron- of MH-data-geverifieerd; de tab kan hierop gebouwd worden.*
