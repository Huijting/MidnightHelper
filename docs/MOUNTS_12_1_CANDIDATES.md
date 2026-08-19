# 12.1-mounts — kandidatenlijst

**Bron:** één YouTube-gids (The Drowsy Dragon, "25 NEW Mounts in Patch 12.1"),
transcript door Rob aangeleverd op 2026-08-19. Geparkeerd op zijn verzoek.

⚠️ **DIT IS GEEN DATA OM UIT TE SHIPPEN.** Drie redenen, en ze stapelen:

1. Het is één bron, en een video. Geen enkele **item-ID** wordt genoemd.
2. De maker zegt zelf *"discovered so far on the 12.1 PTR"* — het is PTR-materiaal,
   en 12.1 is inmiddels live. Namen en bronnen kunnen verschoven zijn.
3. Hij speculeert hardop op minstens drie plekken en zegt dat er ook bij
   (*"I might be wrong here"*, *"we don't actually know the source"*).

Wij hebben al **13 Midnight-mounts met geverifieerde ids** in de mounts-tab. Alles
hieronder moet diezelfde behandeling krijgen — id uit de client via
`C_MountJournal` / `/mh mount <tekst>` — vóór het ergens in beeld komt.

## Wat hier het meest waard is

Niet de mountnamen, maar de **bronnen**. Verschillende daarvan raken systemen die we
al hebben, en díé kant is verifieerbaar:

| mount | bron volgens de video | wat wij al hebben |
|---|---|---|
| Apophic Soul Crusher | Azta'rec solo op `??` | item **275657** staat al in `PTR_12.1_WATCH.md` |
| Corroded Soul Crusher | Delver's Journey rang 5 (S2), bij **Telemancer Astrandis**, 10 Voidlight Marl | die NPC staat in `SeasonTransitionData.lua`; Marl = currency **3316**, geverifieerd |
| Caustic Venomfang | **Er'inye**, 10.000 Corrosive Coin | Er'inye staat al in de Codex als bestemming van Corrosive Coins |
| Indigo Coiled Horror | Zul'jara's Forces renown **17**, bij Jansari op Tokka's Landing, 6k Marl | Tokka's Landing kennen we; deze factie **niet** |
| Violet-Backed Skyfang | zelfde factie, renown **19**, 8k Marl | idem |
| Emerald Skyfang | achievement: **250** patrols in de Vaults | Vaults-content hebben we uitgebreid |
| Venomous Coiler | meta "Assault the Vault", 10 achievements | idem |
| Prey Hunter Courser | 2250 Remnants of Anguish, na Prey Journey **10** | Prey-systeem kennen we |

⚠️ **Zul'jara's Forces is een renown-factie die wij niet hebben.** Onze factie-ids zijn
Amani 2696 / Hara'ti 2704 / Silvermoon 2710 / Singularity 2699 / Ritual 2792. Als die
factie echt bestaat, missen we hem in het hele renown-systeem — dat is een groter gat
dan een mount. **Eerst dát controleren**, met de client.

Gecheckt 19 aug: de enige treffer op "Zul'jarra" in onze hele codebase is een **NPC** in
de Den of Nalorakk-bosstips, niet een factie. Twee mogelijkheden, allebei open:
- de factie bestaat en wij missen hem volledig, of
- het is een verhaspeling in het transcript (het is een automatisch ondertiteld gesproken
  woord; "Zuljara" en "Tucker's Landing" — dat laatste is vrijwel zeker **Tokka's
  Landing** — laten zien hoe betrouwbaar die spelling is).

De renown-tab van de client beslist het in vijf seconden. Doe dat vóór er iets gebouwd
wordt op de aanname dat er een factie ontbreekt.

## De rest, puur als namen

**Seizoensbeloningen:** Umbral Ashes (S1, top 1% keystone — dus verlopen bij de flip),
Breath of Blight (KSM S2, 2000), Breath of Ruin (Keystone Legend, 3000), Crimson
Venomfang (Glory of the Venomous Abyss Raider), Primeval Skyfiend (Mythic Ula'tek —
model nog zonder skin op de PTR), Vicious Lightbloom Bulls (vicious saddle, per
factie), Venomous Gladiator's Gorge (S2 gladiator).

**Quest:** Dusk Grimlynx — hoofdstuk 1 van de 12.1-campagne, quest *"History Lesson"*,
start in Silvermoon City. Volgens de video vrijwel gratis.

**Dungeon:** Writhing Brood — hangt aan The Writhing Coil (tweede baas van de nieuwe
dungeon), maar valt **niet** uit die baas en staat niet in zijn loot table. De maker
vermoedt een NPC in de buurt. Speculatie.

**Onbekende bron:** Amani Hex Bear (misschien een questlijn op de Coiled Isle),
Hexflame Reaver (van **Ral'kala** — die kennen we uit de Prey-track van 17 aug, waar
hij bij Haunted Braziers gesummond wordt), Spirit of Tok'jara (placeholder, niemand
weet het).

**Trading Post / shop:** Crested Leaf Mimic in vier kleuren, Horse with Hat
(placeholdernaam), Badlands Buzzard, Pygmy Owl (in-game shop).

## Volgorde als dit opgepakt wordt

1. **Bestaat Zul'jara's Forces?** Grootste gat, en het gaat niet over mounts.
2. `/mh mount <naam>` per kandidaat → echte mount-id uit Robs client.
3. Pas daarna de mounts-tab uitbreiden, met de bron erbij zoals de 13 bestaande.
4. Umbral Ashes hoort bij de **seizoensovergang**, niet bij de mountlijst: het is een
   S1-beloning die verdwijnt.
