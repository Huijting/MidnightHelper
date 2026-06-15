# Datamine-oogst 15 juni (web + geïnstalleerde addons)

Doel (Rob): meer kunnen bieden zonder alles zelf uit te vinden. Hieronder de
oogst van (A) web-research en (B) jouw geïnstalleerde addons. **Posture: alleen
feitelijke IDs/coords/spells overnemen (geen auteursrecht), nooit code of teksten;
alles in-game bevestigen — never-lie.** Addon-licenties: DBM/HandyNotes/
MidnightRoutine = leer de *feiten*, niet de code.

---

## A. Web-research

### Turbulent Timeways V (NIEUW feature-kandidaat, 12.0.7)
- Event **1425**; loopt **30 jun – 11 aug** (6 weken). Achievement = Mastery in
  4/6 weken: **61463** "Master of the Turbulent Timeways V".
- Buffs: **Knowledge of Timeways 423860** (stapelt → +30% XP), bij 4 stacks →
  **Mastery of Timeways 423861** (week-credit). Currency: **Timewarped Badge 1166**.
- **NIEUW: Dragonflight Timewalking-pool (6):** Algeth'ar Academy 14032, Halls of
  Infusion 14082, Neltharus 14011, Ruby Life Pools 13954? (check), The Azure
  Vault 13954, Brackenhide Hollow 13991. (zone-IDs Wowhead — in-game bevestigen.)
- Mount **Spawn of Vyranoth item 258884** (achievement-gated). Weekly = 5 TW-
  dungeons → gear-cache.

### Omnium Folio (power-systeem)
- UI via **minimap-icoon**; runen kosten geen slot, vrij wisselbaar buiten combat.
- Feeder **Mote of Omnial Inquiry** = item (1/weekly via Seeking Knowledge
  96410/96441-96444); **item-ID nog niet gevonden**. Meta-ach **63325**.
  Decor-beloning "Sunstrider Omnium Simulacrum" (ID nog niet gevonden).
- Rune-keuzes (rijen 1-5) volledig beschreven (Icy Veins/Blizzard-preview) — voor
  een evt. Folio-gids; geen IDs nodig voor uitleg.

### Microholiday + UI-pass
- **Darkspear Dash** event **1793** (27-28 jun; Echo Isles → Silvermoon). Titel/
  tabard/toy (item-IDs nog niet gevonden).
- UI-pass: **Personal Resource Display**-overhaul + **ingebouwde damage meters**
  (let op: mogelijke overlap met addons). Specifieke CVars/API nog niet bekend.

### Reward-item-IDs ⭐ (voor de hook A reward-preview-gallery)
- **Stormarion Assault** → mount **Reins of the Contained Stormarion Defender =
  item 257180** (summon-spell 1261334); pet **Kai = item 265030**. (Caches 260979/260940.)
- **Sporefall/Rotmire** → mount **Luminous Sporeglider = item 269240** (summon
  1284973); Delicious Sporesnack 269245 (4 → mount); trinket 268292; neck 268291;
  ring 268290; helm-transmog 268280; toys 264313 / 264367.
- **Showdowns** → Tortured Gorger 275664 (summon 1297427), Silento 275663,
  Frosticus Maximus 275662, Cappy 270989 (summon 1288380), Arsenal: Lightforged
  Armaments 276364; bonus-mounts Netherforged Nullframe 274650, Voidmancer's
  Starcarver 274649; pet Fishstick Keith 252195.
- **Legends of the Haranir** decor: item-IDs niet op web blootgelegd (alleen
  Wowhead-decor-IDs + quest-koppelingen 88993-88999) — in-game via House Chest.

### Boss-abilities (voor coach-tips + cast-alerts)
- **Faithbreaker Ger'lok**: **Shadowbolt Volley 1273031** (2.5s cast, AoE — de
  interrupt-waardige cast), **Shadow Blast 1279186** (LoS-baar achter pilaren).
  Minion-immuniteit bevestigd; "wildfire" is het add-channel, **geen aparte
  spell-ID** (klopt met onze "nog te bevestigen").
- **Selen'vjar / Empowered Mindbreaker / Warlord Gurrtack**: abilities NIET
  gedataminet (Wowhead-stubs). ⚠️ Twijfel: "Speaker's Rest"/Gurrtack is mogelijk
  GEEN apart scenario — Zul'Aman = Broken Throne (Ger'lok). Onze Daggerspine
  (Eversong, Selen'vjar) blijft kloppen; de "derde scenario"-aanname schrappen
  tot bewijs.
- **Base-Midnight world bosses (12.0.5) — volledige spell-IDs** (voor WorldBoss-
  coaching): Cragpine (Zul'Aman) 1235131/1235134/1235144/1257906; Lu'ashal
  (Eversong) 1243963/1243988/1258427/1258426/1276247/1276436; Predaxas
  (Voidstorm) 1276193/1276320/1276884/1277711/1277829; Thorm'belan (Harandar)
  1257825/1258639/1257320/1258136.

---

## B. Geïnstalleerde addons (lokaal gemijnd)

### DBM-Raids-Midnight ⭐
- **Rotmire** (`Sporefall/Rotmire.lua`): **creature 254176 bevestigt onze seed**;
  spell-IDs bevestigd (1221622, 1221637, 1221781, 1221787, 1222088, 1222129) +
  **nieuw: 1221639, 1262289, 1299508** (extra abilities — in-game labelen). DBM
  triggert op combat met de creature (geen journal-encounterID) → onze
  ENCOUNTER_START/naam-aanpak is prima; eventueel ook op npcID 254176 triggeren.
- **NIEUW ONTDEKT — er zijn meer Midnight-raids met DBM-mods** (toekomstige
  coach-doelen!):
  - **VoidSpire** (multi-boss): Crown of the Cosmos, Fallen-King Shalhadaar,
    Imperator Averzian, Lightblinded Vanguard, Vaelgor & Ezzorak, Vorasius.
  - **The Dreamrift**: Chimaerus the Undreamt God.
  - **Marchon Quel'Danas**: Beloren Child of Alar, Midnight Falls.
  → Creature/encounter/spell-IDs per boss staan in hun .lua's; te oogsten als we
  de raid-coach willen uitbreiden (zelfde patroon als Rotmire).

### HandyNotes_Midnight
- Zone-data voor **live** zones: eversong_woods, harandar, voidstorm, zul_aman
  (+ abundance, arcantina, delves). **Nog GEEN naigtal/val** (12.0.7-zones nog
  niet toegevoegd).
- Formaat: `Rare({...})`-nodes met **kill-quest-IDs** (bv. Voidstorm 90805/91048/
  91050…) en coords gepackt in de node-key; map-id **2405 = Voidstorm bevestigt
  onze waarde** (+ subzones 2444 Slayer's Rise, 2527 Lair of Predaxas).
  → Bruikbaar als kruisreferentie voor Rares.lua (live rare-coords + quest-IDs).

### MidnightRoutine
- Weekly-quest-IDs bevestigd: **89268** (Lost Legends), **90573-90576** (Fortify
  the Runestones / Soiree), **90962** (Stormarion Assault-event) — matchen onze
  datamining. **Nieuw te onderzoeken:** 89289, 91966, 93744, 94835 (weitere
  weeklies — labelen voor de weekly-status-feature).

---

## ✅ Actiepunten — "dit kunnen we nu/zo toevoegen" (geprioriteerd)

1. **Hook A reward-gallery vullen** (klein, hoge zichtbaarheid): zet in
   `EVENT_INFO.rewards`: Stormarion (8419) → {257180, 265030}; (Haranir wacht op
   decor-item-IDs). Sporefall/Showdown-rewards in een aparte gallery zodra die
   content-tabs bestaan. → shift-klik op het Stormarion-event toont dan mount+pet
   roteerbaar.
2. **Ger'lok-coach verfijnen** met de echte spells: Shadowbolt Volley 1273031
   (interrupt!) + Shadow Blast 1279186 (LoS). En **cast-alert toevoegen** voor
   Shadowbolt Volley (interrupt-waarschuwing), naast Binding Nebula/Dissonant.
3. **Rotmire-tips** aanvullen met de DBM-extra-spells (1221639/1262289/1299508)
   zodra we weten wat ze doen (in-game labelen bij launch).
4. **Rares.lua-kruisreferentie**: live rare-quest-IDs/coords uit HandyNotes voor
   eversong/harandar/voidstorm/zulaman (optioneel; Val/Naigtal komen later).
5. **Toekomst-scope (groot):** Turbulent Timeways-tracker (dungeon-pool + week-
   teller), en raid-coaches voor VoidSpire/Dreamrift/Marchon (data ligt klaar in
   DBM). Backlog.
