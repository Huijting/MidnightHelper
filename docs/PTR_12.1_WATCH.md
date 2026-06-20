# PTR 12.1 watch (auto-captured) — verify in-game, subject to change

Patch **12.1 "Curse of Ula'tek"** — Midnights eerste grote content-patch ná 12.0.7. PTR-dev-notes
live ~19 juni 2026; release-window **augustus** (sterke kandidaat: week van 11 aug, naast Turbulent
Timeways V). **Alles hieronder is PTR — kan nog wijzigen; IDs/coords pas hard maken na in-game capture.**

## Inhoud (eerste research-pass, Rob + Claude 20 juni)

- **Nieuwe zone: The Coiled Isle** — eiland voor de kust van Zul'Aman; corrupt/venomous ecosysteem.
  Eigen **custom talent-trees** terwijl je op het eiland bent, **public events**, en een nieuwe activiteit
  **"Cursed Fishing"** (eigen reward-track verwacht). Knoopt aan de Zul'jan-questlijn uit 12.0.7.
- **Raid: The Venomous Abyss** (troll-thema).
- **Dungeon: Altar of Fangs.**
- **3 nieuwe Delves.**
- **Nieuw encounter-type: Lairs** — instanced single-boss, **kies difficulty vóór binnengaan + neem
  allies mee** (tussen world boss en dungeon in; geen tag-race). Mogelijk vaste cadans tussen patches.
- **Housing-overhaul:** Blueprints (layouts opslaan/delen), pet beds, vereenvoudigd dye-craften + nieuwe
  kleuren, **housing-level-cap → 12** (meer item-limit + grotere exterieurs).
- **Class/combat-overhaul:** hogere player-HP + hogere enemy-damage (healer-spikiness gladstrijken);
  cooldown-multipliers omlaag, baseline omhoog (anti-front-loading). Ruwweg damage-neutraal. ⚠️ PTR-tuning.
- **Story:** Kith'ix, Ula'tek, Xal'atath. Verder gedataminet (overige bronnen, losser): **Prey System**,
  nieuwe **tier sets (Season 2)**, M+-wijzigingen, en een leak over **Blood Elf Druids**.

Bronnen: GAMES.GG "Curse of Ula'tek Full PTR Breakdown" (19 jun)
https://games.gg/news/wow-patch-121-curse-ulatek-midnight/ · Wowhead PTR-hub https://www.wowhead.com/ptr

## MH-prep-plan (waar we MidnightHelper alvast op kunnen voorbereiden)

In-scope voor MH (world-/coach-content) — scaffolden zoals we Showdowns/Sporefall op de PTR deden:
- **The Coiled Isle** → zone-scaffold à la Val/Naigtal: uiMapID, rares-roster (`Rares.lua`), events
  (`EventScheduler`/`EventInfoData`), WQ-detectie. ⬜ IDs/coords op de PTR capturen. Codex-tip over de
  island-talent-trees + Cursed Fishing.
- **Altar of Fangs (dungeon)** → `DungeonRosterData` + boss-venster + `DungeonTipsData` (zelfde patroon
  als de bestaande dungeons). ⬜ encounterIDs/creatureIDs dumpen.
- **The Venomous Abyss (raid)** → `RaidCoachData` boss-list + journalInstanceID/encounterIDs (zoals
  Sporefall). ⬜ IDs dumpen.
- **3 nieuwe Delves** → `DelveCoach`/`DelveBossShowcase`/`DelveTipsData`-entries.
- **Lairs (nieuw type)** → kandidaat voor een eigen MH-module/Codex-artikel (single-boss, difficulty-
  select). Eerst mechaniek + IDs vaststellen.
- **Tier sets Season 2** → `TierSetData` uitbreiden met de nieuwe set-spell-IDs.
- **Cursed Fishing / Prey System** → mogelijk weekly-tracker- of Codex-kandidaten (afhankelijk van een
  reward-/voortgangs-track).

Waarschijnlijk out-of-scope: housing-overhaul (Blueprints/pet beds/dye) en class-balance-tuning — die
raken MH's data niet, tenzij een housing-vendor/currency in onze hub valt (zoals de Ritual-Decor-vendors).

## 🤖 PTR 12.1 watch (auto)

- [2026-06-20] Delves hebben nu **namen**: **The Ring of Glory**, **Gnarldor Isle**, en **Venomfall Deeps** (= de nieuwe **Nemesis Delve**). Bij S2-start komen **Bountiful Delves** terug, kun je **boven Tier 7** pushen en verschijnt een **nieuwe Nemesis-boss**; bestaande Midnight-Delves krijgen nieuwe snake/venom-varianten. → MH: `DelveCoach`/`DelveTipsData`-entries scaffolden per naam. — bron: https://www.wowhead.com/news/full-patch-12-1-curse-of-ulatek-ptr-development-notes-381914 (PTR, in-game verifiëren)
- [2026-06-20] Raid **The Venomous Abyss** = **8 boss-encounters**, eindbaas **Ula'tek** zelf; start bij Midnight Season 2. → MH: `RaidCoachData` boss-list (8) + journalInstanceID/encounterIDs dumpen. — bron: https://www.wowhead.com/news/full-patch-12-1-curse-of-ulatek-ptr-development-notes-381914 (PTR, in-game verifiëren)
- [2026-06-20] Dungeon **Altar of Fangs** = **3 bosses**, bij launch tot **Heroic**; gaat de **M+-rotatie** in zodra S2 begint (week na launch). → MH: `DungeonRosterData` + 3-boss-venster. — bron: https://www.wowhead.com/news/full-patch-12-1-curse-of-ulatek-ptr-development-notes-381914 (PTR, in-game verifiëren)
- [2026-06-20] **Lairs** verfijnd: instanced single-boss met schalende difficulty **tot flexibele Mythic 15-25 spelers**, **summoning stone** buiten de ingang, gevonden op vaste locaties net als Delves. Lair komt pas in een **latere PTR-build** testbaar. → MH: module/Codex pas hard maken na test-build. — bron: https://www.wowhead.com/news/full-patch-12-1-curse-of-ulatek-ptr-development-notes-381914 (PTR, in-game verifiëren)
- [2026-06-20] Coiled Isle-detail: **Vaults of Atal'Utek** (group content + roterende **public events** die opbouwen naar een boss); **Curse Surges** spawnen rare elites op **5 roterende locaties**; een rare killen unlockt **Cursed Fishing** op die plek. Lokale questlijn met tortollan zeekapitein **Tokka** + reputatie met zijn crew. → MH: zone-scaffold met 5-rares-roster + Tokka-rep-track + Codex over Curse Surges→Cursed Fishing. — bron: https://www.wowhead.com/news/full-patch-12-1-curse-of-ulatek-ptr-development-notes-381914 (PTR, in-game verifiëren)
- [2026-06-20] **Prey System (S2)**: nieuwe affixes, nieuwe targets en nieuwe hunts op de Coiled Isle. → MH: mogelijke weekly-tracker-/Codex-kandidaat afhankelijk van reward-track. — bron: https://www.wowhead.com/news/full-patch-12-1-curse-of-ulatek-ptr-development-notes-381914 (PTR, in-game verifiëren)
- [2026-06-20] **Gearing-overhaul 12.1**: raid-itemlevels uit de Great Vault omhoog, **bonus rolls blijven**, Catalyst-wijzigingen. **Nebulous Voidcores**: roll-kost raid-item **2→1**, Orin Straylight verhuist **naast de Catalyst in Silvermoon** en geeft vanaf **week 8** van S2 +1 voidcore/week; Voidcores worden Great-Vault-reward vanaf S2-start; S1-voidcores → goud bij seizoenseinde. Great-Vault-raidrewards schuiven op naar volgende upgrade-track-stap (Heroic-vault = Myth 1/6). → MH: catch-up/Vault-tracking en currency-IDs bijwerken. — bron: https://www.wowhead.com/news/massive-changes-to-end-game-gearing-in-patch-12-1-raid-item-levels-buffed-and-381915 (PTR, in-game verifiëren)
- [2026-06-20] **Season 2 cadans bevestigd**: seizoen start **1 week ná** de content-patch (nieuwe M+-rotatie, raid, PvP-seizoen, meer Prey, Bountiful Delves + keys). Release-window patch: **augustus 2026** (geen vaste datum). — bron: https://www.wowhead.com/news/full-patch-12-1-curse-of-ulatek-ptr-development-notes-381914 (PTR, in-game verifiëren)
