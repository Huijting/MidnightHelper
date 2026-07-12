# PTR 12.0.7 — data nog te verzamelen (Rob, in-game)

## 🔴 RELEASE BEVESTIGD: 16 JUNI 2026 (Wowhead-news; web-check 11 juni)

→ Bij release: `120005` uit de TOC (zie RELEASE_CHECKLIST); Showdowns-code
activeert vanzelf via de ≥120007-gate.

## Web-research 12 juni avond — Showdown-zones + Sporefall BEVESTIGD

- **Portaal-coords gevonden** (open punt ✅): instabiel portaal bij
  **Screaming Ridge, Voidstorm 51.42 71.30** (korte intro-questlijn
  vereist); **tweede, statisch portaal in Silvermoon, benedenverdieping
  onder de Ritual Sites-vendors**. Portaal wisselt wekelijks van
  bestemming: **Val of Naigtal**.
- **Naigtal** (de tweede zone naast Val): fungal/arcane wereld, bezet
  door ethereal-factie **Hal'hadar**, aangevoerd door **Nexus-Captain
  Leth'ir** (world boss-kandidaat). Zelfde structuur als Val: WQ's,
  rares, events, world boss; HWT-loop = boss op Normal, dan Heroic.
- ⚠️ Gemini-claim "eigen Ritual Sites in Naigtal/Val + grotere
  ritual-rotatie" = NIET ondersteund door bronnen (verwart Showdowns met
  Ritual Sites) — rotatie blijft Eversong/Zul'Aman, afgekeurd.
- **Sporefall bevestigd compleet**: 1-boss-raid **Rotmire** (fungal
  giant) in **Harandar**; RF/Normal/Heroic/Mythic alle vier op dag 1;
  Mythic = eerste **flex 15-25**; loot = "Sporefused"-tag (pre-upgraded,
  Mythic ilvl 298 = Ascendant Voidcore-plafond). Single-target met
  add-druk, vaste tank-swap, harde energy-timer (Wowhead cheat sheet
  beschikbaar voor boss-steps t.z.t.).

## Web-research 12 juni — Ritual Sites Tier 6 (12.0.7) BEVESTIGD

Wowhead-news 381499 + MrGM, onafhankelijk van elkaar:

- **Tier 6 Ritual Sites** nieuw in 12.0.7: **6 challenges vereist**,
  aanbevolen ~ilvl 270.
- Beloningen per T6-run: **5 Myth Dawncrests** (geen weekly cap gemeld —
  anders dan de Delve Gilded Chest!), plus Hero Dawncrests, Field
  Accolades, Voidlight Marl én Coffer Key Shards.
- Vault: T6 telt nog steeds als "Tier 13" → **World-rij ilvl 269 (Hero
  4/6)**, zelfde als T5.
- **Nieuwe weekly questlijn bij de site-ingang**: 6 weken lang, elke week
  2× Tier 6 met specifieke challenges. ⬜ Quest-IDs dumpen zodra live.
  - ✅ **IN-GAME BEVESTIGD (Rob, 17 jun):** questlijn **"Ritual Site Studies"** (titel zei
    **"Week 1 of 3"**, dus ≥3-weken-keten), gegeven door **Lady Darkglen**. Wk1-doel:
    **disrupt 2× Tier 6 terwijl de "Reinforcements"-challenge actief is**. Eind-beloning:
    **Nebulous Voidcore** (bonus-roll) + **Voidlight Marl ×300** + ~68g 32s.
    → **Quest-IDs (Rob 17 jun, /mh questlog-scan):** wk1 **"Ritual Site Studies: Week 1 of 3" = 96728** ✅;
    gerelateerd **"Midnight: Ritual Sites" = 95843** (vermoedelijk zone-/intro-quest). Wk2/wk3-IDs volgen
    bij de volgende resets. Bevestigt ook Gemini's "Void Cores"-weekly (zie PATCH_12_0_7_ADVICE.md).
    → ✅ **WK2 BEVESTIGD (Rob in-game, 24 jun):** "Ritual Site Studies: **Week 2 of 3**" (Lady Darkglen).
    Doel: **disrupt 2× Tier 6 terwijl de "Malevolent Boons"-challenge actief is** (wk1 = Reinforcements →
    wk2 = Malevolent Boons; bevestigt de 3-weken-keten + Darkglens challenge-rotatie). Beloning identiek:
    Nebulous Voidcore + Voidlight Marl ×300 + ~68g 32s. ✅ **Wk2-quest-ID = 96729** (Rob /mh questscan,
    24 jun) — opeenvolgend op wk1 = 96728. Wk3 vermoedelijk 96730 (PATROON, niet bevestigd → bij reset scannen).
    → ✅ **CORRECTIE (Blizzard-hotfix 18 jun, via ochtend-news-scan):** **Nebulous Voidcore is een
    CURRENCY**, niet een los bonus-roll-"item" — staat in het currency-window met **Season Maximum 2**
    (hotfix: spelers met 2 in "Season Maximum 1/2" konden niet veilig verder; nu opgelost). → **MH-impact:**
    kandidaat om als currency te tracken (zoals Field Accolades/Marl); ⬜ currency-ID nog te dumpen
    (`/dump` in het currency-window of bagscan "Voidcore"). De "bonus-roll"-omschrijving hierboven blijft
    de functie, maar de vorm = currency met cap 2/seizoen.
- MH-impact: RitualCoach-tierinfo uitbreiden (T6-regel), Codex-tip "Myth
  Dawncrests soloable via T6 rituals", weekly-questlijn evt. tracken.
- ⬜ Nog te bevestigen (Gemini/Wowhead-gids, niet hard gecheckt): Field
  Accolades ≈ 1 per 10 Spoils (330→32, 507→50).

### Ritual Site challenges — gevers + coords (Method-gids + Rob in-game 17 jun)

Bron: Method "How to Unlock All Ritual Site Challenges" (12 mei) — **8 challenges, namen matchen
exact onze lijst** (Tendrils, Malevolent Boons, Reinforced, Patrols, Manifestations, Embers, Magical
Alarm Bells, Tainted Corpses). Op T6 draaien er 6 tegelijk. Unlock-gevers (Silvermoon Bazaar, uiMapID 2393):

- **Lady Darkglen — 2393 47.74/49.76** (Rob zag haar als "Image of Lady Darkglen" bij de ritual + als
  gever van de **"Ritual Site Studies"-weekly 96728**). Geeft: **Malevolent Boons** (na T2),
  **Magical Alarm Bells** (na T4), **Patrols** ("Misappropriated Treasures", na T3). ⚠️ De Method-gids
  noemt haar bij Patrols abusievelijk "Lady Glendark" — zelfde NPC/coords (gids-typo).
- **Ranger Captain Lilatha — 2393 48.23/49.64.** Geeft: **Reinforced** (na T2), **Manifestations** (na T3).
- **Tendrils:** geen NPC — loot de eindchest → quest-item "Ritual Site Challenge Report: Tendrils" → inleveren.
- **Embers:** loot een **Ember of Power** in een T4-site → start-quest (meer Embers looten).
- **Tainted Corpses:** loot een **Tainted Bone Pile** in T2+ (Eversong 66.09/62.58, Zul'Aman 47.91/36.52) → quest.

In-game on-screen-trackers (Rob 17 jun) bevestigen de actieve-challenge-UI: **"Embers of Power Remaining:
x/4"** (Embers-loot-objectief) en **"Kills Until Magical Alarm Bells: N"** (aftelteller → bel = alert/
reinforcements). MH-impact (latere batch): RitualCoach-waypoints naar Darkglen/Lilatha + korte uitleg
per challenge; "Ritual Site Studies"-weekly (96728) evt. in de account-checklist.

### Ritual Sites RENOWN-track ("Journeys") — 8 ranks, compleet (Rob in-game 17 jun, alle tooltips)

Eigen renown/voortgangstrack (UI "Journeys → Ritual Sites"), max **rank 8**, alle nodes zijn
**Warband Reward** (account-breed). Volledige lijst (vervangt de eerdere boost-site-gok):

- **Rank 1 — Ritual Magic: Regeneration Orbs:** Regeneration Orbs verschijnen in Ritual Sites, healen je voor **15% HP**.
- **Rank 2 — Ritual Treasures:** kleine treasures rond Ritual Sites te vinden.
- **Rank 3 — Ritual Decor:** koop void-themed desk-accessoires bij **Rae'ana** in Silvermoon (housing-decor).
- **Rank 4 — Outlying Dangers** (rare enemies spawnen → extra ritual spoils) **+ Ritual Magic: Orb Potency** (Regen-Orb-heal **+100%**).
- **Rank 5 — Shrines of Power** (magische buff-shrines in de sites) **+ Additional Spoils** (extra kleine treasures).
  - ✅ **IN-GAME BEVESTIGD (Rob, 20 jun):** een "Loa Shrine" aanklikken in een ritual geeft een **60-minuten stat-buff**; verschillende shrines = verschillende stats (alle CDPulse, spell-IDs rond 1285xxx). Gevangen:
    - **Accuracy** = spell **1285688** (icon 7090841) → **+10% critical strike**.
    - **Hardiness** = spell **1285637** (icon 7263309) → **+20% maximum health**.
    - **Expedience** = spell **1285691** (icon 7390435) → **+25% movement speed**.
    - **Guile** = spell **1285692** → effect **nog te bevestigen** (alleen in auradump gezien; tooltip nog te screenen).
    - (Reeks ligt rond **1285637–1285692** (Hardiness 637, Accuracy 688, Expedience 691, Guile 692); haste/mastery/vers/leech-varianten waarschijnlijk nog niet gevangen. Wowhead-PTR-probe timede uit, dus in-game `/mh auradump` is de betrouwbaarste bron.)
- **Rank 6 — Corrupted Menagerie** (koop select pets bij **Sergeant Vornin**, Silvermoon) **+ Ritual Magic: Orbs Aplenty** (hogere kans op Regen-Orb uit kills).
- **Rank 7 — Revered Treasures** (grote treasures → extra spoils) **+ Dark Obelisk** (koopbaar bij **Rae'ana**, Silvermoon) **+ Shrines of Power II** (nieuwe buff-shrines).
- **Rank 8 — Corrupted Transport** (koop de **Void-Touched Hawkstrider**-mount bij **Sergeant Vornin**, Silvermoon) **+ Elite Dangers** (rare ELITE enemies spawnen → extra spoils).

Patroon: de track maakt de sites geleidelijk rijker (orbs/heal → rares → shrines → treasures → elites)
en ontgrendelt vendor-spullen (decor rank 3, pets rank 6, mount rank 8). Currency overal = Field
Accolades/Voidlight Marl (MH trackt die al). Vendors: **Rae'ana** (decor/Dark Obelisk), **Sergeant Vornin**
(pets/mount) — Silvermoon (coords nog te dumpen).

**MH-impact (latere batch, geen 1.8.2-blocker):** (1) renown-rank + voortgang tonen (HomeDashboard /
Void & Rituals) — `C_MajorFactions`/Journeys-API uitzoeken; (2) Codex/RitualCoach-tip "wat ontgrendelt
elke rank + de mount/pets/decor-doelen"; (3) evt. de gameplay-modifiers (rank 8 = elites, rank 4/7 =
rares/treasures) in de RitualCoach noemen zodat spelers weten waarom een hogere-rank-site meer oplevert.

## Web-research 11 juni (Wowhead news 381787 + gidsen) — nieuw bevestigd

- **HWT aanbevolen ilvl 274** + extra modifiers (o.a. rondzwervende elites);
  géén unlock-vereiste (bevestigt PTR-bevinding §6).
- **Flow:** Riftblade Maella (Silvermoon) start de questlijn → **portaal in
  Voidstorm, subzone Howling Reach** (Voidstorm uiMapID = **2405**, Zygor-
  zonetabel; exacte portaal-coords nog dumpen) → moeilijkheidskeuze
  Normal/Heroic bij het portaal.
- **Rotatie = wekelijks** ("Each area rotates weekly, available for one week
  at a time") → open punt §7 beantwoord; VoidAssaults-weekly-patroon
  herbruikbaar. ✅
- **Beloningen:** rares droppen "Lost Armaments" → Champion 1/6 (Normal) /
  Champion 4/6 (Heroic) warband-gear; world boss → Champion (N) / Hero (H)
  item; Showdown-weekly → Riftstalker's Cache (275690 ✓) + vault World-rij ✓.
- **Decimus** (nieuwe NPC): quest gekoppeld aan HWT-bosses → **Myth-track
  gear**. ⬜ Quest-ID dumpen op PTR/live.
- **Toy "Lightveil Recall Beacon"** — recall naar Umbral Base Camp, 15 min
  CD, vroeg in de questlijn → mooie Codex/info-tip.
- **Vendors Umbral Base Camp:** Fieldsmith Ventem (Response Team-transmogset;
  30/60 Field Accolades + 300/500 **Voidlight Marl**) en Zuronar <Lightveil
  Artificer> (wapens + housing decor). ✅ CORRECTIE (Rob, 12 jun): Voidlight
  Marl is GEEN nieuwe valuta — het is de bestaande Midnight-renown-munt
  (warband-transferable; MH trackt hem al: AltOverview-snapshot +
  RitualCoachData "2nd currency confirmed"). De 12.0.7-vendors prijzen er
  alleen óók in. → Codex/hint-kandidaat: "je bestaande Marl-voorraad is
  vanaf 16 juni te besteden bij de nieuwe Umbral Base Camp-vendors
  (transmog 300-500 per stuk)".
- Drop-quest **95069 "Torn Twilight Missive"** (drop bij de actieve ritual
  site, inleveren Silvermoon; Rob 12 jun) beloont o.a. Voidlight Marl —
  leuke lore-breadcrumb (Ger'lok/Broken Throne), geen verdere addon-actie.
- **Omnium Folio:** Mote of Omnial Inquiry komt uit weekly "Seeking
  Knowledge" (week 1 = 96410 ✓); 5 keuze-nodes over 5 weken; **Folio-weekly
  is warband/account-breed** — 1× per account per week volstaat →
  checklist-semantiek: account-regel, géén per-char regel!
- Val-flavor: ijswereld, Pertinax zit in de "Void Acropolis"; Naigtal:
  Hal'hadar-ethereals met Mana-Forge.
- Achievement "Showdown Success: Val" = **62880** (PTR-tak); quest-ID van
  "Showdown on Val" zelf nog steeds niet via web vindbaar (nether-tooltip
  96718 leeg) → blijft PTR/live-dump (§2).
- Let op (Zygor-events-guide): "Imperator Pertinax npc 252308" in een
  Eversong-scenario is een ándere Pertinax dan world boss 263670.

Reeds geverifieerd (Wowhead/Blizzard, juni 2026):

| Wat | ID |
|---|---|
| Naigtal zone | 16943 (Wowhead-zone; uiMapID nog nodig) |
| Val zone | 16900 (idem) |
| Nexus-Captain Leth'ir (world boss Naigtal) | npc 263843, killquest 96472 |
| Imperator Pertinax (world boss Val) | npc 263670 |
| Rotmire (Sporefall) | npc 254176, raid zone 16279 |
| Omnium Folio week 1-quest "Seeking Knowledge" | quest 96410 |
| Field Accolade | currency 3405 (bestaand) |
| Spawn of Vyranoth (Timeways-mount) | item 258884, achievement 61463 |
| Darkspear Dash | event 1793 (27-28 juni) |
| API | TOC 120007; `GetInstanceInfo()` ret11 `hasWorldTier`; `Enum.TieredEntranceType.WorldTier`; geen C_WeeklyRewards-wijzigingen |

## Nog nodig — run dit op de PTR

**1. uiMapID van Naigtal en Val** (voor waypoints/zone-detectie)
Sta in de zone en run:
```
/dump C_Map.GetBestMapForUnit("player")
```
…of (nieuw, 13 jun) gewoon **`/mh eventspy`** — de Event Scheduler-module
print per actief event naam · zone · **uiMapID** rechtstreeks, dus zodra Val
in de event-rotatie zit komt z'n uiMapID er vanzelf uit.
- ✅ **Naigtal = uiMapID 2600** (gemeten in Umbral Base Camp, PTR 6 juni 2026)
- ✅ **Val = uiMapID 2599** (PTR-verified 16 juni 2026, Rob stond in Val; kaart-pad EK >
  Quel'Thalas > Voidstorm > Val). Naast Naigtal 2600. → `ShowdownsData.lua` val.uiMapID = 2599.
- ℹ️ **Showdown-intro = Voidstorm Screaming Ridge** (`portalVoidstorm` 2405, 51.42/71.30): de
  beacon in Silvermoon ("Lightforged Beacon") is inactief tot je daar de expeditie-questlijn doet.
  De SMC "Riftblade Maella" op 27.48/76.51 = **Decor Duels-NPC** (housing), NIET de Showdown-intro
  — zelfde naam, andere NPC (Rob, PTR 16 juni). `introNpc` in ShowdownsData hierop gecorrigeerd.
- ℹ️ **Live zone-uiMapIDs geverifieerd via `/mh eventspy` (13 jun, 12.0.5):**
  Voidstorm = **2405** (bevestigt de Zygor-waarde), **Harandar = 2413**
  (= Legends of the Haranir; matcht ook Brokers Void-Incursion-zone),
  **Eversong Woods = 2395** (zone-cache vulde de geplande events correct).
  Speler-map bij meting: 2395 (Eversong) / 2393 (Silvermoon-portaal-area).
  Zul'Aman uiMapID nog onbekend (pas leerbaar zodra Zul'Aman een actief event
  is). Val/Naigtal niet zichtbaar op live — oogsten op de PTR met `/mh eventspy`.
- ✅ Vast Silvermoon-portaal = **2393, 47.93, 48.09** (exact midden; zelfde verdieping als de quest-hub in de Bazaar, iets verderop — PTR 7 juni)

**2. Showdown weekly quest-IDs** ("Showdown on Naigtal" / "Showdown on Val", + evt. Heroic-variant)
Pak de weekly aan en run:
```
/run for i=1,C_QuestLog.GetNumQuestLogEntries() do local q=C_QuestLog.GetInfo(i) if q and not q.isHeader then print(q.questID, q.title) end end
```
Zoek de Showdown-regels in de chat.
- ✅ **"Showdown on Naigtal" = quest 96717** (PTR, 6 juni 2026)
- ✅ Zijquest "Surveying the Mana-Bog" = quest 96054 (Naigtal)
- ✅ **"Showdown on Val" = quest 96713** — IN-GAME BEVESTIGD 16 juni 2026 (Rob accepteerde 'm bij
  de Val-Outpost-Maella; questlog toonde "96713 Showdown on Val"). ⚠️ Web-datamine zei 96716 (en
  noemde 96713 een "thinner variant") → **in-game wint: 96713**. `ShowdownsData.lua` val.weekly = 96713.
  Heroic-variant nog open. Ook bevestigd: "The Nexus-Captain" = 96472 ✅.
- 🌐 Heroic Naigtal = **96718**, variant 96720 (web-datamined).
- ⚠️ **"Disruptions Continue" / "Dangerous Enemies"**: agent-research (14 jun) vond GEEN aparte quest-IDs hiervoor op Wowhead — waarschijnlijk gids-terminologie; de weekly "Showdown on Val/Naigtal" (96716/96717) bundelt WQ's+rares+events in één quest. In-game checken of het keuzedialoog echt aparte quests geeft.

**3. Rare NPC-IDs Naigtal/Val** (Interminable Uarn, Indomitable Mk. XII, Glacial Broodmother, The Horror Below, + wat je verder tegenkomt)
- ✅ Naigtal: **Voidwarped Sporebat = npc 265698** (PTR 6 juni)
- ✅ Naigtal: **Indomitable Mk XII = npc 264571** (PTR 6 juni — stond op de research-lijst)
- ✅ Naigtal: **Lomelith = npc 263955** (PTR 6 juni)
- ✅ Naigtal: **Slaipaan = npc 264576** (PTR 6 juni)
- ✅ Naigtal: **Interminable Uarn = npc 263947** (PTR 6 juni — stond op de research-lijst)
- ✅ Naigtal: **Swalewing Matriarch = npc 263954** (PTR 6 juni)
- ✅ Naigtal: **Warbringer Thal'kuur = npc 267422** (PTR 7 juni)
- ✅ Naigtal: **Auredar's Chassis = npc 264569** (PTR 7 juni)
- 🌐 **Val (web-datamined 14 jun, ConquestCapped — IN-GAME BEVESTIGEN):**
  **Glacial Broodmother = npc 261716**, **The Horror Below = npc 264870**.
  Showdown Slugger: Val = 6 rares (ach 62881). Meeste Val-rares spawnen in
  **Glacial Reservoir**; Blackstar Legion-elites patrouilleren de wastes.
  Volledige Val-rarelijst nog niet gevonden.
- ✅ **Val IN-GAME (Rob, 16 juni 2026):** rare **Krilkan = npc 264866** (Val 2599, ~45.9/44.6,
  ROAMT → coords benaderend). Zijquest **"Surveying the Frozen Wastes" = 96053** (tegenhanger van
  Naigtal 96054 → `ShowdownsData.valSideQuests`). Val-weekly %-objectief = "Domanaar Operations
  Disrupted" (96713). Sub-zone **Forgotten Depths / "Lower Depths"** (portaal binnen Val) — uiMapID
  niet gemeten; niet nodig (rares/WQ's draaien op 2599).
- ✅ **Glacial Broodmother** (web npc 261716) in-game gezien op Val 2599 **~66.4/42.0** (NO van
  Glacial Reservoir, bij Frost Chitter Grotto). Volledige Val+Naigtal-rarelijst wordt van Wowhead
  getrokken (agent 16 jun) i.p.v. handmatig jagen — in-game vooral nuttig voor coords + kill-quests.

#### ✅ COMPLETE RARE-ROSTERS (Wowhead achievement-criteria, agent 16 juni — voor Rares.lua)

Bron: Showdown Slugger Val **62881** (10 criteria) / Naigtal **62883** (8 criteria) = de volledige
pool (de "defeat 6" is gewoon 6-van-de-lijst). Coords = `/way`-waypoints uit de officiële
Wowhead-gids (CONFIRMED). ⚠️ **Per-rare kill-credit-quest-IDs: ALLE UNCONFIRMED** (JS-rendered,
niet te scrapen) → in-game capturen óf Rares.lua op vignette/npcID laten werken zonder kill-quest.

**VAL (uiMapID 2599):** Sleet-Rune 261965 (54,67) · Glacial Broodmother 261716 (in-game ~66.4/42.0,
roamt) · Xirah 264864 (28,73) · Opprimius 264868 (33,42) · The Horror Below 264870 (23,41) · Atomus
262421 (37,76) · Mercilus 264865 (49,78) · Krilkan 264866 (in-game ~45.9/44.6, roamt) · Nelgothar
264869 (33,57 — Forgotten Depths, via portaal 42,71) · Shadowguard Destroyer 265269 (Blackstar-
patrouille, roamt 39,39↔49,93). **World boss: Imperator Pertinax 261072** @ 49,90 Void Acropolis
Interior (portaal 49,97) — GEEN rare. (Lost de npc-discrepantie op: 261072, niet 263670.)

**NAIGTAL (uiMapID 2600):** Interminable Uarn 263947 (38,63) · Swalewing Matriarch 263954 (77,38) ·
Auredar's Chassis 264569 (29,63; criteria-naam "Auredar") · Indomitable Mk XII 264571 (53,50) ·
Broxion 263950 (45,52) · Lomelith 263955 (65,60) · Warp Agent Xi'grivr 264574 (70,76) · Slaipaan
264576 (57,63). ⚠️ **Niet in de achievement** (extra's, met caveat): Warbringer Thal'kuur 267422
(29,18) en Voidwarped Sporebat 265698 — niet als Showdown-rare hardcoden zonder check.
Target de rare en run:
```
/run local g=UnitGUID("target") print(g and select(6,strsplit("-",g)), UnitName("target"))
```

**3b. Voor opname in Rares.lua zijn per rare ook nodig (entry-vorm
`{ questId, mapID, x, y, naam }`):**
- **Coords:** sta bij de rare en run
  `/run local m=C_Map.GetBestMapForUnit("player") local p=C_Map.GetPlayerMapPosition(m,"player") print(m, ("%.1f, %.1f"):format(p.x*100, p.y*100))`
- **Kill-quest-ID (flipt bij kill, reset dagelijks/wekelijks?):** scan vóór
  en direct ná de kill een blok rond de bekende 12.0.7-quest-reeks:
  `/run local n=0 for i=96000,97000 do if C_QuestLog.IsQuestFlaggedCompleted(i) then n=n+1 end end print("flags true:", n)` —
  beter: noteer per kill welke ID erbij komt met
  `/run MH_T=MH_T or {} for i=96000,97000 do local f=C_QuestLog.IsQuestFlaggedCompleted(i) if f and not MH_T[i] then MH_T[i]=true print("NIEUW:",i) end end`
  (eerste run = baseline vullen, na de kill nogmaals = print het nieuwe ID).
- Verzamelde npc-IDs (8) staan hierboven ✅; met coords + questIds erbij
  gaan ze in Rares.lua (build-gate ≥120007).

**4. Riftstalker's Cache item-ID**
- ✅ **Riftstalker's Cache = item 275690**; weekly turn-in verhoogde de Great Vault World-rij (type 6) — Blizzard-claim bevestigd (PTR 6 juni) — shift-klik het item in de chat of run met het item in je tas:
```
/run for b=0,4 do for s=1,C_Container.GetContainerNumSlots(b) do local i=C_Container.GetContainerItemInfo(b,s) if i and i.hyperlink and i.hyperlink:find("Riftstalker") then print(i.itemID, i.hyperlink) end end end
```

**5. Mote of Omnial Inquiry** — zelfde bagscan, zoekterm "Omnial". Check ook of het een currency is:
```
/dump C_CurrencyInfo.GetCurrencyInfo(3405)
```
(en kijk in je currency-tab of er een nieuwe Omnium-valuta staat — hover + `/dump GameTooltip:GetPrimaryTooltipData()`)

**6. Heroic World Tier status** — klopt het dat er géén unlock-vereiste meer is? En:
```
/dump select(11, GetInstanceInfo())
```
in een Showdown-zone (verwacht: `hasWorldTier = true`).
- ✅ **`hasWorldTier = true` bevestigd in Naigtal** (PTR, 6 juni 2026)
- ✅ Geen unlock-vereiste: portaal bood direct twee opties (Normal / Heroic World Tier) op een verse PTR-kopie

**7. Portaalrotatie** — ✅ **wekelijks** (Blizzard-blog via Wowhead, 11 juni): "Each area rotates weekly, becoming available for one week at a time" → VoidAssaults-weekly-aanpak herbruikbaar.

**8. Sporefall Great Vault** — telt een Rotmire-kill mee in de bestaande Raids-rij? Na een kill:
```
/dump C_WeeklyRewards.GetActivities(3)
```

## 📥 Web-research 14 juni (ConquestCapped/Wowhead-datamining — IN-GAME BEVESTIGEN)

PTR offline vanmorgen; daarom vast research. Bron: ConquestCapped "Void Assault
Escalations Guide" (09 jun) + Wowhead PTR-links. **Never-lie: alles hieronder is
web-gedataminet, pas hard maken na in-game bevestiging.**

**Zones (Wowhead zone-ID ≠ uiMapID!):** Voidstorm 16648 · Naigtal 16943
(uiMapID 2600 ✅) · Val 16900 (**uiMapID nog steeds open**). Val-subzones:
Void Acropolis (capital/world boss), Steam Ravine, Glacial Reservoir (rares).

**World bosses — ⚠️ npc-ID-discrepanties (Robs in-game waarde wint):**
- Naigtal: Nexus-Captain **Leth'ir** — web npc **260875**, maar Rob mat **263843**
  in-game. Co-boss **Adjutant Mertei = npc 263620** (nieuw; Arcane Missiles
  negeren aggro). Kill-quest "The Nexus-Captain" = **96472** ✅ (matcht doc).
- Val: **Imperator Pertinax** — web npc **261072**, doc had **263670**. Zit in
  Void Acropolis; dropt trinket **Singularian Cryocore = item 274620**.
- → npc-discrepanties checken: web-DB-entry vs. gespawnde creature kunnen
  verschillen; voor Rares.lua hebben we de gespawnde-GUID-npcID nodig (= Robs
  meting). Beide genoteerd, in-game herbevestigen.

**Achievements (Void Assaults-categorie, 12.0.7):**
- Prepared for a Showdown **63384** (intro → portaal) · Heroic Tendencies
  **63323** (world boss → Heroic unlock, account-breed)
- Showdown Slugger: Naigtal **62883** / Val **62881** (6 rares) · Showdown
  Success: Naigtal **62882** / Val **62880** (8 WQ's)
- Climate Strange: Naigtal **62904** / Val **62903** · Heroic-varianten
  **62919** / **62917** (5 storms) · Heroic Slugger **63348** (15 rares heroic)
- Ultradon Carnage **63349** · Pain of Command **62905** (beide bosses) ·
  **meta Heroic Showdowns 63264** → mount Tortured Gorger (item 275664)
- Movement-unlocks: Bouncy Mushrooms 62944, Naigtal Spores 62949 (Naigtal),
  Grapple Skiffs 62945 (Val)

**Quests:** The Nexus-Captain **96472** (Naigtal WB) · "Until It Is Done"
**95395** (Val-WQ, Ultradon Slayer → pet Frosticus Maximus 275662).

**Vendor & currency:** Kifaan = npc **261474** (Voidstorm; cosmetics) ·
Voidlight Marl = currency **3316**. Beloningen: Tortured Gorger (mount, item
275664, 100 Marl), Silento (pet 275663), Frosticus Maximus (pet 275662), Cappy
(pet 270989), Arsenal: Lightforged Armaments (transmog 276364).

**⚠️ Rotatie-cadans tegenstrijdig:** deze gids zegt **"every few days"**
(few-day cadence), terwijl doc §7 "wekelijks" (Blizzard-blog) noteert. Belangrijk
voor onze actieve-zone-detectie — **in-game verifiëren** of het echt wekelijks is
of vaker rouleert.

**Nog steeds open na research (echt PTR-only):** Val **uiMapID** · "Showdown on
Val" **weekly-quest-ID** (Naigtal = 96717 ✅) · Heroic-weekly-variant-ID ·
follow-up-weekly-IDs (Disruptions Continue / Dangerous Enemies) · **Mote of
Omnial Inquiry** item/currency-ID (rol = wekelijkse Omnium-Folio-stap-beloning,
"Seeking Knowledge" 96410, account-breed, 5 stappen) · Sporefall-vault-gedrag.

## 📥 Web-research 14 juni — diepe datamining (4 agents; ALLES in-game bevestigen)

PTR offline; daarom breed gedataminet via Wowhead (PTR-2) + gidsen. **Never-lie:
alles hieronder is web-gedataminet, hard maken pas na in-game bevestiging.**

### A. Sporefall-raid + Rotmire (12.0.7)
- **Sporefall = zone 16279**, in **Harandar**, **1-boss-raid**, min level 90.
  Difficulties **LFR/Normal/Heroic/Mythic**, dag 1. **Mythic = flex 15-25**
  (uniek; eerste flex-Mythic-raid). Release week van **16 juni**.
- **Rotmire = npc 254176.** Kill-achievements: any **63237**, Heroic 63240,
  Mythic 63241. Energy-bar-fight; bij 100 energy **Fungal Bloom** = wipe-conditie.
- Abilities (spell-IDs): Awaken Fungi 1221622 · Fungal Bloom 1221637 · Fungal
  Frenzy 1221644 · Bursting Shroom 1221965 · Putrid Fist 1221781 (tank-swap) ·
  Bursting→Rotting Pustules 1221787/1222176 (soft enrage) · Festering Vines
  1222088 → Writhing Vines 1222129 · Mythic: Cross Fertilization 1222684 →
  Bursting Doom Shroom 1222495. Adds: Shroomling 238696, Fungling 239020,
  Sporecap 238699 (Poison Burst 1221714, Blightshot 1221717).
- Loot **"Sporefused"** (geen upgrade-track): LFR 259 / N 272 / H 285 / M 298.
  Trinket **Sporelord's Mycelial Insignia item 268292**. Mount **Luminous
  Sporeglider** (spell 1284973) via 4× Delicious Sporesnack (item 269245, 1/kill).
  Intro-quest **Sporefall: Rotmire = quest 96746** → Void-Twisted Sporbit
  (269258) → 1 Nebulous Voidcore (bonus-roll-currency).
- ⚠️ **Great Vault Raid-rij**: NIET datamine-bevestigd dat een Rotmire-kill de
  Raid-rij vult (standaardgedrag = waarschijnlijk wél, maar in-game checken).
- Lockout: standaard weekly per char per difficulty.

### B. Ritual Sites-bosses (bevestigt + breidt onze data uit)
- **Broken Throne = zone 16796.** Stages **Void Reversal / Corrupted Beast /
  Corruptor's End** (web-bevestigd). **Ger'lok npc 257284** ✅ (matcht ons;
  chest-object 650051). **Corrupted Amani Dragonhawk npc 255653** ✅.
  ⬜ Ger'loks/Dragonhawks exacte spell-namen niet in datamined tekst (Wowhead JS).
- **Daggerspine Point = zone 16939.** Stages **Ritual Roles / Beast From the
  Deep / Summoner's Fall** — **nu WEB-BEVESTIGD** (waren Gemini-gok). Stage 2 =
  empowered **Mindbreaker = Void-Infused Mindbreaker npc 260022** ✅ (Wowhead 24 jun;
  al de stage-2 model-seed in DaggerspineCoach). **Eindboss Lady Selen'vjar npc 257498** ✅
  (chest-object 602746 ✅ matcht ons). → Beide Daggerspine-bosses geseed, idem Broken Throne.
  - ✅ **Scenario-trigger COMPLEET (Rob in-game 17 jun):** **SCENARIO_ID = 3267**;
    stage 2 "Beast From the Deep" (Empowered Mindbreaker) = **stepID 16532**; stage 3
    "Summoner's Fall" (Lady Selen'vjar) = **stepID 16533**. → `DaggerspineCoach.lua` heeft nu de
    auto-open-trigger (zelfde stage-patroon als RitualBossCoach: step→boss-venster + meebladeren,
    per-boss suppress, npc-leren met secret-guard). Klaar voor 1.8.3.
- **Spell-IDs die Rob in z'n Dragonhawk-run zag** (voor de emote-listener/coach):
  **Binding Nebula = spell 1284125** (live) / 1284106 (PTR), nebula-npc 260719,
  debuff 1284102. **Dissonant Reflections = spell 1284081** (live) / 1284085
  (PTR), missile 1284080. (Wowhead plaatst ze thematisch bij void/Daggerspine,
  maar Robs in-game death-recaps zagen ze op de Broken-Throne-Dragonhawk → Robs
  observatie wint voor attributie.)
- **Derde scenario in Zul'Aman (zone 16796): "Speaker's Rest"** (6 stages),
  eindboss **Warlord Gurrtack** (npc ⬜ — Wowhead 24 jun doorzocht, nog niet
  geïndexeerd; lore: leidt Twilight's Blade daar. Géén MH-coach voor dit scenario,
  en onduidelijk of 't een ritual-rotatie of Void-Assault-locatie is → niet wiren).
  Plus zone "Ritual Site Outskirts" 16748.
- **Challenges (8, compleet, met Spoils%):** Tendrils +10 · Manifestations +15 ·
  Magical Alarm Bells +13 · Malevolent Boons +20 · Tainted Corpses +10 ·
  Reinforced +15 · Patrols +15 · **Embers +25**. Tier-gating: T3=1, T4=2, T5=4.
- Field Accolades = item 271787; ritual-renown 1e weekly = 750 rep; tier-ilvls
  1-5 = 215/231/244/257/264.

### C. Showdown / Omnium Folio / Voidforge (IDs)
- **Showdown-weeklies:** Val N **96716** / H **96714**; Naigtal N **96717** ✅ /
  H **96718**. Belonen Riftstalker's Cache → Great Vault World-rij.
- **Omnium Folio "Seeking Knowledge"-keten** (storyline 6307): wk1 **96410**,
  wk2 **96441**, wk3 **96442**, wk4 **96443**, wk5 **96444**. Meta-achievement
  **63325**. **Mote of Omnial Inquiry = een ITEM** (geen currency), 1 per weekly;
  exacte item-ID ⬜ (nog niet geïndexeerd).
- **Voidlight Marl = currency 3316** ✅.
- **Voidforge:** "Building the Voidforge" = **quest 94623** (Decimus @ Voidstorm
  51.20 68.41), 3× Elementary Voidcore Shard (item 265695) → leert Transmute
  Elemental Voidcore (spell 1276894). 6-weken-keten, warband-breed. Nilhammer/
  Ascendant-vervolgquest-IDs ⬜.

### D. Wereld-events — weekly-quest-IDs (voor "weekly-status per event")
- **Stormarion Assault** → weekly **"Stand Your Ground" = quest 94581** (event-
  quest 90962; meta 93892).
- **Legends of the Haranir** → weekly **"Lost Legends" = quest 89268** (meta 93891).
- **Void Assaults:** Zul'Aman = quest 94386; Void Strike = quest 96080
  (Eversong-variant ⬜).
- **Saltheril's Soiree / Runestone Defense** → "Fortify the Runestones" per
  subfactie: Magisters 90573 · Blood Knights 90574 · Farstriders 90575 ·
  Shades of the Row 90576. Subfacties: Magisters/Blood Knights/Farstriders/
  Shades of the Row. Currency: Brimming Arcana (charge = Latent Arcana).
- **The Abundance:** currency **Unalloyed Abundance**; Loa = Dundun; Abundant
  Harvest rouleert elke 8u; vendor Chel the Chip.
  - ⚠️ **Naam-discrepantie:** Method-gids noemt de grotten Watha'nan Crypts
    (Eversong) / Loaknit Den (Zul'Aman) / Floaret Grotto (Harandar) / Abundant
    Voidburrow (Voidstorm), terwijl Brokers in-game-tooltip "Mining Voidburrow /
    Herbalism Grotto / Enchanting Crypt / Skinning Den" toont. Voor ÓNS maakt het
    niet uit: wij tonen de API-naam (clienttaal) live — geen hardcode nodig.
- **Bountiful-delve story-achievements:** **61724 = "The Grudge Pit Stories"**
  bevestigd; reeks 61724-61733 plausibel maar niet volledig geënumereerd (JS).

### ⚠️ Open discrepanties (in-game beslissen)
- World-boss-npc's: Leth'ir web 260875 vs Rob 263843; Pertinax web 261072 vs doc
  263670 → Robs in-game-meting wint (gespawnde-GUID-npcID voor Rares.lua).
- Rotatie-cadans: "wekelijks" (Blizzard-blog) vs "few-day cadence" (gids).

## 📥 Addon-kruischeck 17 juni (Zygor 9.6 localisatie-DB — feitelijke ID→naam, geen guide-tekst)

Bron: `ZygorGuidesViewer/Localization-Retail/NPCs_enUS.lua` + `Quests_enUS.lua` (Interface
120007). Dit zijn pure ID→naam-tabellen (factual), gebruikt als kruisreferentie — never-lie:
geen Zygor-guide-prose overgenomen.

**Bevestigd / opgelost:**
- **Pertinax (Val world boss) = npc 261072** ✅ (Zygor: `[261072] = "Imperator Pertinax"`).
  → **Lost de 261072-vs-263670-discrepantie op: 261072 is correct; 263670 bestaat NIET in
  Zygor** = was een foute waarde. (Tabel-rij "world boss Val | npc 263670" hierboven is
  hiermee achterhaald → gebruik 261072.)
- **Scenario-Pertinax = npc 252308** ✅ (`[252308] = "Imperator Pertinax"`) — bevestigt de
  caveat dat de Eversong-scenario-Pertinax een ándere npc is dan de world boss.
- **Pertinax kill-quest = quest 96473** ✅ NIEUW (`[96473] = "Imperator Pertinax"`) — was een
  open punt ("Pertinax-killquest nodig"). Naast Leth'ir/Nexus-Captain 96472 ✅ (bevestigd).
- **Leth'ir DB-npc = 260875** (Zygor) — Robs gespawnde-meting 263843 blijft de Rares.lua-waarde
  (DB-entry ≠ gespawnde creature; geen wijziging nodig).
- **Omnium Folio:** `[96410] = "Seeking Knowledge Week 1 of 5: The Omnium Folio"` ✅ bevestigt
  96410 + de "1 van 5"-cadans. Intro-keten ervoor: `96226 Omnium Anomalies`, `96232 Return to
  the Omnium`, `96233 The Omnium Reawakens` (in The Lycaneum). (96441-96444 staan NIET in Zygor
  → blijven web-gedataminet.)
- **Side-quests:** `96053 Surveying the Frozen Wastes` (Val) ✅, `96054 Surveying the Mana-Bog`
  (Naigtal) ✅ — matchen MH.

**Plumber (12.0.7-current, `Modules/.../Retail/TraitFrame.lua`) — Omnium Folio-UI:**
- **Mote of Omnial Inquiry = spell 1294322** ✅ **IN-GAME BEVESTIGD (Rob, 17 jun):**
  `C_Spell.GetSpellName(1294322)` → "Mote of Omnial Inquiry". Bag-scan ("Omnial") + currency-lijst-scan
  gaven op dat moment NIETS → geen tel-baar tas-item / geen currency-regel; het is een spell-handle
  (zoals Plumber 'm op de Folio "points"-header gebruikt). ⚠️ Caveat: de bag-scan vindt 'm alleen als je
  'm net vasthebt (na inleveren weg) — dus "geen item" is niet hard. Voor MH niet nodig: Folio-voortgang
  loopt via de quest-flags (96410 + keten), niet via de Mote. Geen code-actie.
- Plumber hardcodet de rune-spell-IDs NIET (haalt de traits live op), dus geen kruischeck van onze
  13 rune-IDs daar — die blijven op ConquestCapped/Wowhead (sectie OmniumFolioData). Plumber noemt het
  systeem intern o.a. "The Empowered Folio".
- **Unlock-start "The Magister's Call" = Silvermoon uiMapID 2393, 47.89/51.73** ✅ IN-GAME GEMETEN
  (Rob, 17 jun). → klikbare {FOLIOSTART}-waypoint in de Omnium-tab (`OmniumFolio.lua` `FOLIO_START`).

**NIET te bevestigen via de geïnstalleerde addons (blijven PTR/live-dump):**
- **Heroic Showdown weekly-quest-IDs** (96714/96718/96720 web) — Zygor indexeert de
  "Showdown on Val/Naigtal"-weeklies niet onder die naam.
- **Nalorakk (Den of Nalorakk-eindboss) model-creature-ID** — blijft nil (never-lie, niet gokken):
  MDT dekt de dungeon niet (niet in de M+-pool), Zygor heeft alleen sub-units (Zadu "Fist of Nalorakk"
  246942/253902, "Voice of Nalorakk" 248350, "Nalorakk's Chosen" 255171, + de oude TBC-Nalorakk 23576),
  en EXBoss heeft enkel naam-strings. Geen schone "Nalorakk"-boss-npcID → in-game capturen.
- (Bonus: Zygor's Naigtal/Val-dailies-guide bevat tientallen losse WQ-IDs + coords — bruikbaar als we
  ooit per-WQ-tracking willen; niet nu nodig.)

## Wat hiermee gebouwd wordt

- `VoidAssaults.lua`/`WorldContent.lua`: Showdowns-sectie (actieve zone-detectie via weekly quest-flag, zelfde patroon als 12.0.5 Void Assaults) — nodig: 1, 2, 7
- `WorldBoss.lua`: Leth'ir/Pertinax-entries — nodig: 1, 2 (kill-quests: Leth'ir/Nexus-Captain **96472** ✅, Pertinax **96473** ✅ (Zygor 17 jun); Heroic-varianten nog open)
- `Rares.lua`: nieuwe zone-rares — nodig: 1, 3
- `AccountWeeklyChecklist`: Folio-mote (⚠ account/warband-breed — 1 regel voor het hele account!) + Showdown-weekly — nodig: 2, 5
- Codex-artikelen: al geschreven (geen IDs nodig) ✔

## 🤖 Auto-captured (dagelijkse news-scan)

- [2026-06-18] Great Vault "World"-row toonde foutief ilvl 272 voor Tier 5 Ritual Site; bedoelde/gecorrigeerde waarde = ilvl 269 (Hero 4/6) — bron: https://news.blizzard.com/en-us/article/24276957/hotfixes-june-18-2026 (auto, in-game verifiëren)
- [2026-06-18] Ritual Site-rares schalen niet langer foutief in een party — bron: https://news.blizzard.com/en-us/article/24276957/hotfixes-june-18-2026 (auto, in-game verifiëren)
- [2026-06-18] Naigtal-rares zijn ~3 min na spawn in schaduw gehuld en niet aanvalbaar (extra aanlooptijd) — bron: https://news.blizzard.com/en-us/article/24276957/hotfixes-june-18-2026 (auto, in-game verifiëren)
- [2026-06-17] Naigtal-unlocks "Bouncy Mushrooms", "Aerospores" en "The Grappler" zijn nu account-wide — bron: https://news.blizzard.com/en-us/article/24276957/hotfixes-june-18-2026 (auto, in-game verifiëren)
- [2026-06-17] Leth'ir/Nexus-Captain Leth'ir liet quest-item voor "Knocking Off the Top (Heroic)" niet droppen; gefixt — bron: https://news.blizzard.com/en-us/article/24276957/hotfixes-june-18-2026 (auto, in-game verifiëren)
- [2026-06-18] Midnight Keystone Myth – Season One ontgrendeld bij M+ rating ≥ 3400 in S1 — bron: https://news.blizzard.com/en-us/article/24276957/hotfixes-june-18-2026 (auto, in-game verifiëren)
- [2026-06-22] Upgrade-Crest cap is volledig verwijderd vanaf de weekly reset (week van 16 jun); Crests zijn nu ongecapt voor de rest van Season 1 → MH Crest-cap-tracking is voor S1 obsolete/altijd "uncapped" — bron: https://www.wowhead.com/news/crest-caps-removed-starting-this-week-381670 (auto, in-game verifiëren)
- [2026-06-22] Conquest-cap is verwijderd voor de rest van Season 1 (geen weekly Conquest-cap meer) → MH Conquest-cap-tracking voor S1 obsolete — bron: https://news.blizzard.com/en-us/article/24276957/hotfixes-june-18-2026 (auto, in-game verifiëren)
- [2026-06-22] Tier 6 Ritual Site-weekly van Lady Darkglen kan nu ook opgepikt worden in de Silvermoon-hub (naast buiten de actieve Ritual Site) → MH Ritual-Site/Tier 6 quest-pickup heeft nu 2 locaties (NPC Lady Darkglen, Silvermoon-hub) — bron: https://www.wowhead.com/blue-tracker/news/eu/hotfixes-june-22-2026-world-of-warcraft-blizzard-news-24276957 (auto, in-game verifiëren)
- [2026-06-23] Turbulent Timeways V gaat live op 30 jun 2026 en loopt 6 weken t/m 11 aug 2026; Dragonflight Timewalking-dungeonpool: Algeth'ar Academy, Halls of Infusion, Neltharus, Ruby Life Pools, The Azure Vaults, Brackenhide Hollow → MH Turbulent-Timeways-feature: concrete startdatum + dungeonlijst om te tonen — bron: https://www.wowhead.com/news/wow-weekly-midnight-mists-of-pandaria-classic-turbulent-timeways-and-more-381806 (auto, in-game verifiëren)
- [2026-06-23] Val world-quest "Until it is Done" aangepast: meer quest-credit + hogere creature-respawn-rate → raakt Val-Showdown-zone (tracked), geen ID-wijziging maar WQ-gedrag veranderd — bron: https://news.blizzard.com/en-us/article/24276957/hotfixes-june-23-2026 (auto, in-game verifiëren)
- [2026-06-25] Omnium Folio: vanaf Week 2 zijn de prerequisites van de weekly "Seeking Knowledge"-quest account-wide; alts moeten nog wel de Sunstrider Omnium-unlock-questline doen vóór toegang tot de weeklies → MH Folio weekly-tracking: prereq is account-wide vanaf wk2, unlock-questline blijft per-char — bron: https://www.bluetracker.gg/wow/topic/us-en/2296045-world-of-warcraft-midnight-hotfixes-june-25/ (auto, in-game verifiëren)
- [2026-06-25] Alle quests die nodig zijn voor de Omnium Folio en om Val of Naigtal te unlocken/betreden zijn nu gemarkeerd als "Important"-quests → MH quest-tracking: deze quest-IDs hebben nu de Important-flag — bron: https://www.bluetracker.gg/wow/topic/us-en/2296045-world-of-warcraft-midnight-hotfixes-june-25/ (auto, in-game verifiëren)
- [2026-06-25] Val world-quest "Aberration Liberation": objective-count verlaagd naar 10 (was 12); kills geven nu party-brede credit → raakt Val-Showdown-zone (tracked), concrete count-wijziging — bron: https://www.bluetracker.gg/wow/topic/us-en/2296045-world-of-warcraft-midnight-hotfixes-june-25/ (auto, in-game verifiëren)
- [2026-06-26] Showdown Reward Changes (live 26 jun): "Dark Particles" droppen nu in zowel Val als Naigtal en stacken tot 1000 → mogelijk nieuwe trackbare currency/item met cap 1000 in de tracked Showdown-zones (item/currency-ID nog onbekend, in-game capturen) — bron: https://www.bluetracker.gg/wow/topic/us-en/2320707-showdown-reward-changes-june-26-and-june-30/ (auto, in-game verifiëren)
- [2026-06-26] Showdown Reward Changes (live 26 jun): rare enemies in Val/Naigtal kunnen nu Heroic Warbound-until-equipped items droppen + verhoogde rare-spawnfrequentie in beide zones → raakt Rares.lua-loot/spawn-gedrag in tracked zones — bron: https://www.bluetracker.gg/wow/topic/us-en/2320707-showdown-reward-changes-june-26-and-june-30/ (auto, in-game verifiëren)
- [2026-06-30] Showdown Reward Changes (bij weekly maintenance 30 jun): world bosses droppen Warbound Heroic 1/6 (Normal) / 4/6 (Heroic) item; elke char kan daarnaast een Champion 4/6 Soulbound (Normal) / Heroic 1/6 Soulbound (Heroic) item krijgen → raakt loot-tiers van tracked world bosses Leth'ir/Pertinax (WorldBoss.lua) — bron: https://www.bluetracker.gg/wow/topic/us-en/2320707-showdown-reward-changes-june-26-and-june-30/ (auto, in-game verifiëren)
- [2026-06-30] Turbulent Timeways V is LIVE (30 jun–11 aug 2026); de "Mastery of the Timeways"-XP-buff is dit seizoen account-wide en blijft door de dood heen (was per-char) → MH Turbulent-Timeways-feature: buff-gedrag gewijzigd (account-wide + persist-through-death) — bron: https://www.wowhead.com/news/experience-buff-now-account-wide-during-turbulent-timeways-june-30-to-august-11-381788 (auto, in-game verifiëren)
- [2026-06-30] "Mastery of Timeways"-buff spell-ID = 1229050 (na 4 Timewalking-dungeons; 30% XP); "Knowledge of the Timeways" = start-stack 5% XP → MH Turbulent-Timeways: trackbare buff-spellID — bron: https://www.wowhead.com/news/experience-buff-now-account-wide-during-turbulent-timeways-june-30-to-august-11-381788 (auto, in-game verifiëren)
- [2026-06-30] Turbulent Timeways weekly-reward = Heroic "Cache of Quel'Thalas Treasures", item-level 259–276 → MH Turbulent-Timeways: concrete weekly-cache ilvl-range om te tonen — bron: https://www.wowhead.com/news/experience-buff-now-account-wide-during-turbulent-timeways-june-30-to-august-11-381788 (auto, in-game verifiëren)
- [2026-06-30] Nieuwe Turbulent-Timeways-mount "Spawn of Vyranoth" via achievement "Master of the Turbulent Timeways V" (handhaaf Mastery of the Timeways gedurende 4 weken in het event) → MH Turbulent-Timeways: achievement/mount-doel om te tonen — bron: https://www.wowhead.com/news/experience-buff-now-account-wide-during-turbulent-timeways-june-30-to-august-11-381788 (auto, in-game verifiëren)
- [2026-06-30] Nieuwe Dragonflight-Timewalking-vendor "Xydan" in de Bronze Enclave, Valdrakken (naast Timewarped-badge-vendor) → MH Turbulent-Timeways: vendor-NPC-naam/locatie (npcID nog onbekend, in-game capturen) — bron: https://www.wowhead.com/news/experience-buff-now-account-wide-during-turbulent-timeways-june-30-to-august-11-381788 (auto, in-game verifiëren)
- [2026-07-03] Omnium Folio weekly deze week = "Seeking Knowledge Week 2 of 5: Ritualized Arcana": loot 8× **Ritualized Arcana** (droppen van objective-mobs) + voltooi een Ritual Site; volledig te doen in één Tier 1-run (geen challenge/hogere tier nodig) → MH Folio weekly-tracking: concrete week-2 quest-naam + requirement (8 Ritualized Arcana, 1 Tier 1 Ritual Site) om te tonen; quest-ID in-game capturen — bron: https://www.icy-veins.com/wow/news/this-weeks-omnium-folio-upgrade-takes-one-ritual-site-run/ (auto, in-game verifiëren)
- [2026-07-04] Patch 12.1 "Curse of Ula'tek" story lead-in opent de week van 7 jul 2026; de volledige 12.1-content-patch wordt breed ~augustus verwacht en Midnight Season 2 start één week ná de patch (dus geen 7/14-jul-livegang zoals sommige fansites melden — lead-in ≠ patch) → bij S2 worden MH's S1-tracked data stale (Great Vault-ilvls, currency-caps, crest-/M+-seizoen); plan een MH-seizoensupdate — bron: https://www.wowhead.com/news/wow-weekly-turbulent-timeways-curse-of-ulatek-july-trading-post-and-more-382072 (auto, in-game verifiëren)
- [2026-07-04] 12.1 "Curse of Ula'tek" QoL-preview: account-wide UI-settings, Auction House-verbeteringen, eenmalige Profession Knowledge-reset, en fixes voor veelvoorkomende combat-/travel-problemen → account-wide UI-settings kan raken hoe addon-/CVar-settings persisten, en combat-/travel-fixes kunnen secure/taint-gedrag beïnvloeden — bron: https://www.wowhead.com/news/quality-of-life-improvements-coming-in-curse-of-ulatek-profession-knowledge-382059 (auto, in-game verifiëren)
- [2026-07-07] Patch 12.1 "Curse of Ula'tek" story lead-in is nu LIVE (week van 7 jul, US-reset 7 jul): fog licht op bij het eiland ten oosten van Zul'Aman, questlijn met Zul'jarra/Zul'jan naar de Coiled Isle → nieuwe live story-chapter-quests (quest-IDs in-game capturen); volledige 12.1-patch + Season 2 blijven ~augustus — bron: https://news.blizzard.com/en-us/article/24280285/watch-the-latest-wowcast-and-learn-about-the-curse-of-ulatek (auto, in-game verifiëren)
- [2026-07-07] (12.1 PTR, NOG NIET LIVE) Coiled Isle-zone datamined: exploration-achievement "Explore the Coiled Isle" = achievementID 63640; storyline "The Coiled Isle - World Quests/Repeatables" = ID 6228 → relevant voor MH achievement-hunt/route-features bij S2-livegang, nu enkel PTR — bron: https://www.wowhead.com/ptr/achievement=63640/explore-the-coiled-isle (auto, in-game verifiëren)
- [2026-07-08] Hotfix 7 jul: Delves Nemesis liet kort geen **Magical Primessence** droppen voor de Omnium Folio-weekly "Seeking Knowledge Week 4 of 5: Magical Primessence"; gefixt → bevestigt week-5-serie een week-4-quest ("Magical Primessence" via Delves Nemesis-drop) voor MH Folio weekly-tracking; quest-ID + item-ID in-game capturen — bron: https://news.blizzard.com/en-us/article/24287397/hotfixes-july-7-2026 (auto, in-game verifiëren)
- [2026-07-09] Omnium Folio weekly deze week (reset 7 jul) = "Seeking Knowledge Week 3 of 5: Leyline Assaults": pak op bij de Sunstrider Omnium Folio in Magister's Terrace; loot 5× **Dark-Ley Coalescence** (uit Field Pouches [Void Strikes] en Field Satchels [finale Void Incursion]) door 5 Void Strikes/Incursions te doen; week-3-unlock is de enige zónder choice-node (vaste amplifier die Core Rune-effect over tijd uitbreidt) → MH Folio weekly-tracking: concrete week-3 quest-naam + requirement (5 Dark-Ley Coalescence via Void Strikes/Incursions) om te tonen; quest-ID + item-ID in-game capturen — bron: https://www.icy-veins.com/wow/omnium-folio-guide (auto, in-game verifiëren)
- [2026-07-10] (12.1 PTR, NOG NIET LIVE) PTR Build 68569 (8 jul): Midnight Season 2 gear-rewards zijn opgeschoven met +7 extra ilvl → totale S2-verhoging nu **46 ilvl** t.o.v. S1 (was 39) → bij S2-livegang worden MH's S1 Great Vault-/gear-ilvl-waarden stale; dit is de tentatieve PTR-delta om de S2-update mee te plannen (waarde nog niet definitief) — bron: https://www.wowhead.com/news/full-patch-12-1-curse-of-ulatek-ptr-development-notes-381914 (auto, in-game verifiëren)
- [2026-07-11] Omnium Folio weekly deze week (live sinds reset 7 jul) = **"Seeking Knowledge Week 4 of 5: Magical Primessence"** — **questID 96443** (op te pikken bij de Sunstrider Omnium Folio in Magister's Terrace). Vereist 1× **Magical Primessence**, te krijgen van: eindboss van elke Midnight-dungeon of -delve, Rotmire (Sporefall-raid), of de **Illustrious Contender's Strongbox** (3.500 Honor, Captain Dawnrunner in Silvermoon; Honor is Warband-bound). Week-4-unlock = keuze uit 4 secondary-stat-runes (Rune of Critical Power / Burning Haste / Masterful Cunning / the Versatile Warrior). ⚠️ Corrigeert de log-regel van [2026-07-09] die week 3 als de actieve week noemde — de live weekly is week 4 → MH Folio weekly-tracking: questID 96443 als huidige weekly; item-ID van Magical Primessence in-game capturen — bron: https://www.icy-veins.com/wow/news/omnium-folio-week-4-just-added-its-strongest-talent-effect-yet/ · https://www.wowhead.com/quest=96443/seeking-knowledge-week-4-of-5-magical-primessence (auto, in-game verifiëren)
- [2026-07-12] Omnium Folio **week 5 van 5 = "Seeking Knowledge Week 5 of 5: Off-World Magic" — questID 96444** (live bij de reset van 14 jul). Vereist: 1× **Fragment of Alien Magic** van **Imperator Pertinax** (Val) of **Nexus-Captain Leth'ir** (Naigtal) + **3 world quests** in diezelfde zone. Beloning: Mote of Omnial Inquiry + **500 Voidlight Marl**. Alle 5 weeklies afgerond → achievement **"Omnium Folio Studies"** (unlockt housing-decor "Sunstrider Omnium Simulacrum"). Bevestigde questIDs van de keten: wk1 96410, wk2 96441, wk4 96443, wk5 96444 (wk3 nog onbekend — niet gokken) → MH Folio weekly-tracking: laatste week + koppeling met tracked world bosses (WorldBoss.lua) — bron: https://www.wowhead.com/quest=96444/seeking-knowledge-week-5-of-5-off-world-magic · https://www.icy-veins.com/wow/omnium-folio-guide (auto, in-game verifiëren)
- [2026-07-12] Patch 12.1-lead-in chapter 1 "Legacy of the Amani" (live sinds 7 jul) start met quest **"Hagar's Invitation" — questID 92895**, op te pikken bij **Orweyna, Sanctum of Light, Silvermoon City (uiMapID 2393, 45.45 / 70.26)**; vervolgquest "The Preparations Are Complete" = questID 92897. Beloningen: mount **Dusk Grimlynx** + pet **Akiki**. Bijbehorend achievement **"The Curse of Ula'tek" = achievementID 62413** → MH: concrete start-waypoint + questIDs voor een story-chapter-route (zelfde patroon als FOLIO_START in OmniumFolio.lua) — bron: https://www.wowhead.com/quest=92895/hagars-invitation · https://www.wowhead.com/news/chapter-1-of-curse-of-ulatek-patch-12-1-campaign-now-live-382105 (auto, in-game verifiëren)
- [2026-07-12] (12.1 PTR, NOG NIET LIVE) Great Vault in 12.1: de **World-row** wordt naast Delves en Prey óók gevuld door **Ritual Sites**, en **Field Accolades** worden dan verdiend uit zowel Void Assaults als Ritual Sites (nu alleen Void Assaults); raid-ilvls uit de Vault gaan omhoog en gear-upgrades gaan naar een vlakke **20 crests per rank (6 ranks, 120 crests voor 6/6)** → bij 12.1/S2-livegang worden MH's Great Vault-bronlogica (World-row) en crest-kosten stale — bron: https://www.wowhead.com/news/massive-changes-to-end-game-gearing-in-patch-12-1-raid-item-levels-buffed-and-381915 (auto, in-game verifiëren)
