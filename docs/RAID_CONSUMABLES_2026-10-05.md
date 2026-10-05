# Hoeveel consumables voor een raidavond — onderzoek 5 okt 2026

Voor het `/mh ready`-venster (ROADMAP: "klaar voor de raid?"). mh-research, 5 okt 2026. Bronnen: wago.tools DB2 live
12.1.0.69933 (zonder hotfix-toggle), Wowhead, Method "List of all Midnight Consumables" (6 sep), progstats.io (Mythic),
Archon (snippet), Blizzard blue post 2020 (potion-reset, oud).

## Feiten (GEMETEN tenzij anders gezegd)

- **Flask:** 1 uur, **blijft na de dood** (Rob had gelijk; WH-tooltip + DB2 death-persist op spell 1235057). Nog een
  flask = +1 uur. Ids (295/278): Thalassian Resistance 241320/241321, Magisters 241322/241323, Blood Knights
  241324/241325, Shattered Sun 241326/241327. **Fleeting**-varianten uit de ketel (zelfde buff): 245926-245933.
  Ketels: Sin'dorei Flasks 241318/241319, Voidlight Potion 241284/241285 (5 min neergezet).
- **Healing potion:** 5 min cooldown, **eigen** cooldown (categorie 30), los van combat potions (4) en healthstone
  (1711). Concentrated Silvermoon Health Potion 271884 (295) / 271883 (278), nieuw in 12.1; Silvermoon Health Potion
  241304/241305; Fleeting Silvermoon 245918/245919.
- **Combat potion:** 30 s, 5 min cooldown. Recklessness 241288/241289, Light's Potential 241308/241309, Rampant
  Abandon 241292/241293; Fleeting 245902/245903, 245897/245898, Liquid Luster 274763/274764. Reset na het gevecht:
  alleen bron uit 2020.
- **Augment rune:** Void-Touched 259085, 1 uur, **op na gebruik**, **niet** na de dood. Ook Tidesworn 274797 (herkomst
  onbekend, niet in de data).
- **Food:** Well Fed 1 uur. **Hearty**-food blijft na de dood (242747, 266996, 266985, 242745); gewone food niet (AFGELEID).
- **Healthstone:** 5512, 3 ladingen, 1 min cooldown, gratis van de Warlock. Ook **Demonic Healthstone 224464**.
- **Pulls per avond:** Mythic-progressie 10-13 per uur (progstats) → 30-45 in 3-4 uur; farm (8 bazen) 8-15 (AFGELEID).
  Normal/Heroic-casual: geen betrouwbare bron.

## Vuistregel voor 3-4 uur (AFGELEID)

Wat na de dood blijft: per uur. Wat weg is na de dood: per pull. Altijd de ilvl 295-rang.

| | progressie | farm |
|---|---|---|
| Flask | 4 | 4 |
| Food (Hearty) | 4 (0 met feast) | 4 |
| Healing potion | 30 | 15 |
| Combat potion | 30 | 16 |
| Augment rune | ~30 | 0-4 |
| Healthstone | 0 kopen | 0 kopen |

## Gevonden in de huidige `/mh ready` (AFGELEID uit de code, niet in het spel gezien)

- Telt **Fleeting** flasks/potions niet in de tas mee (alleen de 24132x-ids) → zegt "geen" terwijl je ze hebt.
- `HEALTHSTONE_IDS = { 5512 }` mist **Demonic Healthstone 224464**.
- ✅ **Concentrated** Silvermoon Health Potion (271884/271883) staat als `best` bij alle 40 specs
  (GEMETEN, `ConsumablesWowheadData.lua`). Fleeting-ids (245918, 245926) staan er NIET in (GEMETEN, 0 treffers).
