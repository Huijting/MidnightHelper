# Raid + Mythic+ datamine (15 jun 2026)

Bron-posture: **never-lie**. IDs hieronder zijn gekruist tussen (a) Robs geïnstalleerde
**DBM-Raids-Midnight** (encounter-IDs = autoritatief, want het is de live mod) en
(b) Wowhead/Method/Icy-Veins boss-guides (spell-IDs + NPC-IDs + mechanics). Spell-IDs
zijn 7-cijferig (12xxxxx). Alles "confirm in-game" tot Rob/anderen het live draaien.

## Raids — encounter-IDs (DBM NewMod, autoritatief) + journalInstanceID + boss-NPC

| Raid | journalInstanceID | Boss | DungeonEncounterID (DBM) | Boss NPC (Wowhead) |
|---|---|---|---|---|
| The Dreamrift | 1314 | Chimaerus, the Undreamt God | 2795 | 256116 |
| The Voidspire | 1307 | Imperator Averzian | 2733 | 240435 |
| The Voidspire | 1307 | Vorasius | 2734 | 240434 |
| The Voidspire | 1307 | Vaelgor & Ezzorak | 2735 | Vaelgor 242056 / Ezzorak 244552 |
| The Voidspire | 1307 | Fallen-King Salhadaar | 2736 | 240432 |
| The Voidspire | 1307 | Lightblinded Vanguard | 2737 | War Chaplain Senn 250589 |
| The Voidspire | 1307 | Crown of the Cosmos | 2738 | Alleria 244761 |
| March on Quel'Danas | 1308 | Belo'ren, Child of Al'ar | 2739 | 240387 |
| March on Quel'Danas | 1308 | Midnight Falls (L'ura) | 2740 | 240391 |
| Sporefall | 1305 | Rotmire | 2711 | 254176 |

Let op: DBM-encounterID-volgorde zet Vaelgor&Ezzorak (2735) vóór Fallen-King (2736),
terwijl Wowhead-guides Fallen-King als boss 3 en Vaelgor&Ezzorak als boss 4 nummeren.
Voidspire heeft waarschijnlijk flexibele middenbosses — volgorde in-game bevestigen.

## Sleutel-spell-IDs per boss (voor de coach-steps)

**Chimaerus (Dreamrift):** interrupt {SPELL:1249017} (DBM-interrupt). Mechanics (Icy-Veins,
namen zonder bevestigde IDs): Alndust Upheaval (up/down-split soak), energie→Consume (add
bereikt boss = +100% dmg, 100 energie = add wordt opgegeten = wipe), Fearsome Cry (interrupt-
prio op Haunting Essence) + Essence Bolt, Rending Tear (tank-bleed+knockback), Corrupted
Devastation/Ravenous Dive (intermission), Colossal Horror (tank-add kill-prio). Mythic:
Dissonance + Rift Madness. DBM specials: 1245396 1245404 1245451 1245844 1246621.

**Imperator Averzian (Voidspire):** Umbral Collapse {SPELL:1249262} (group-soak), March of
the Endless {SPELL:1251583} (wipe als 3 portals elkaar empoweren), interrupt {SPELL:1255702}
(DBM). Adds: Abyssal Voidshaper 252918. DBM specials: 1249251 1249265 1258880 1260203 1262776.

**Vorasius (Voidspire):** Void Breath {SPELL:1256855} (block met crystal-walls). Adds:
Blistercreep 255418 (kite in walls om ze te breken). Boss-dmg rampt per wall-set (soft enrage).
DBM specials: 1241836 1254112 1260046.

**Fallen-King Salhadaar (Voidspire):** Void Convergence {SPELL:1247738} (spawnt orbs),
Concentrated Void adds 246665 (kill voor ze de boss raken), Entropic Unraveling {SPELL:1246175}
(dodge beams; boss +25% dmg-taken 20s = burn-window). DBM specials: 1243453 1250686 1253024 1254081.

**Vaelgor & Ezzorak (Voidspire, council):** Dread Breath {SPELL:1244221} (run out), Gloom
{SPELL:1245391} (soak orb voor het een wall raakt), Twilight Bond {SPELL:1270189} (verdeel
dmg gelijk over beide of ze krijgen grote buff = de-facto enrage), Nullbeam {SPELL:1262623}
(tank-soak), Radiant Barrier {SPELL:1248847} (sta erin tijdens intermission). DBM specials:
1244917 1245645 1249748 1265131 1277470 1277471 1277473 1280458.

**Lightblinded Vanguard (Voidspire, 3 paladins):** Judgment {SPELL:1246736} (tank-swap),
Execution Sentence {SPELL:1248983} (gevaarlijke cast). Bij 100 energie cast 1 paladin een
aura die de andere 2 buft — sleep bosses eruit: Aura of Wrath {SPELL:1248449}, Aura of
Devotion {SPELL:1246162}, Aura of Peace {SPELL:1248451}. DBM specials: 1246749 1246765
1248674 1249130 1251857 1255738 1272310 1276639.

**Crown of the Cosmos (Voidspire, eindboss):** 3 stages met intermissions, 3 mini-bosses
(Xal'atath + Turalyon/Arator/Alleria, NPC Alleria 244761). Geen schone spell-ID-namen op de
bron — steps blijven structureel + "confirm in-game". DBM specials: 1233787 1237035 1238843
1243743 1246461 1261339 1283236.

**Belo'ren, Child of Al'ar (March on Quel'Danas):** start-split Light Feather {SPELL:1241162}
/ Void Feather {SPELL:1241163} (interacteer alleen met je eigen kleur). Bij 0 HP → Rebirth
{SPELL:1241313} als ei in't midden = de echte HP-balk, burst het. Cyclus herhaalt. DBM
specials: 1241282 1242792 1242981 1246709 1260763.

**Midnight Falls / L'ura (March on Quel'Danas, tier-eindboss):** P1 Death's Dirge (5 spelers
krijgen Dark Rune-symbolen in volgorde; roterende laser moet ze in die volgorde raken).
Tank-swap: Heaven's Lance stapelt naar 5 → Impale (+50% dmg 25s) → swap per cyclus. P2 Void
Cores: Galvanize zet beams op 4 spelers → richt op Void Cores; Cosmic Fission (beschadigde
core opent + pull). The Darkwell (midden) = instant-death; Total Eclipse pull naar't midden;
Starsplinter (glasspikes + splash); Iris of Oblivion (buitenring doodt wie eruit gaat).
Namen zonder bevestigde IDs → "confirm in-game". DBM specials: 1249620 1249796 1250898
1253915 1266388 1266897 1267049 1273158 1276202 1279420 1281194 1282047 1282249 1282412 1284980.

**Rotmire (Sporefall):** al gebouwd (RAID_BOSS_ROTMIRE_* in RitualTips.lua). encounterID 2711.

## Mythic+ Season 1 (Wowhead S1-overview, autoritatief; method.gg per-dungeon)

**Pool (8, bevestigd):** Maisara Caverns (33:00), Magisters' Terrace (34:00), Nexus-Point
Xenas (30:00), Windrunner Spire (33:30) [Midnight native] + Algeth'ar Academy (31:00),
Seat of the Triumvirate (34:00), Skyreach (28:00), Pit of Saron (30:00) [legacy].

**Affix-systeem 12.0 (begint bij +2, niet +4):**
- **+2** Lindormi's Guidance (affix 165) — markeert/verzwakt vijanden (Temporal Sands) +
  **verwijdert de death-penalty**. Beginner-helper.
- **+5** Xal'atath's Bargain — 1 van 4 varianten, wekelijks roterend (zie onder). Actief +5..+11.
- **+6** Lindormi's Guidance verdwijnt.
- **+7** Tyrannical (affix 9: bosses +30% HP/+15% dmg) **OF** Fortified (affix 10: non-bosses
  +20% HP/+~20% dmg) — wisselt wekelijks.
- **+10** Tyrannical **EN** Fortified, elke week.
- **+12** Bargain weg → Xal'atath's Guile (affix 147): elke dood = **-15 sec** timer (komt niet terug).

**Xal'atath's Bargain — 4 wekelijkse "kiss-curse" varianten:**
1. **Ascendant** (148) — Orbs casten Cosmic Ascension {SPELL:461904}; stop ze (kick/CC/purge)
   voor party-buff move/haste, anders mob-buff.
2. **Voidbound** (158) — Void Emissary buft mobs met Dark Prayer {SPELL:462508}; kill = party
   +30% CD-rate/+20% Vers, fail = mob-buff.
3. **Pulsar** (162) — soak Void Pulsar {SPELL:1216815} voor expiry = +Mastery/+Leech, fail = mob-buff.
4. **Devour** (160) — Devouring Rift {SPELL:440313} op alle 5 (shield-debuff + 10% slow);
   verwijder via heal/dispel → Rift Essence {SPELL:465136} buff. Fail = mobs 10% geheald.

**Systeem:** rating heet "Mythic+ Rating". Resilient Keystones (time alle 8 op +12 → key zakt
nooit onder +12). Dungeon Waystones (mid-dungeon checkpoints, respawn bij laatste). Crests:
Champion Dawncrest (3344), Hero Dawncrest (3346), Myth Dawncrest (3348). HP/dmg-scaling:
+2 +0% … +10 +84% … +12 +122% … +15 +196%.

**Per-dungeon must-kick (method.gg, namen "confirm in-game", geen gepubliceerde spell-IDs):**
- Maisara Caverns (zwaarste): kick Hex (Ritual Hexxer) / Reanimation (Reanimated Warrior, "elke
  cast of wipe") / Shrink (Umbral Shadowbinder). Rak'tul: kick elke Malignant Soul op de brug.
- Pit of Saron: kick Icy Blast (Dreadpulse Lich) > Shadow Bolt (Gloombound) > Death Bolt (Krick).
  Garfrost: Glacial Overload = LoS achter Ore Chunk.
- Algeth'ar Academy: Healing Touch (Ancient Branch) "elke cast of wipe".
- Seat of the Triumvirate: kick Dread Screech (Shadewing).
- Skyreach: kick Repel (Driving Gale-Caller).
- Magisters'/Nexus-Point/Windrunner Spire: 2-5 kicks elk, geen schone lijst gevonden — in-game
  via method.gg ability-trackers / DBM-Party-Midnight aanvullen.

## Bronnen
Wowhead Voidspire boss-pages, Icy-Veins Chimaerus/Midnight Falls, Method March on Quel'Danas,
Wowhead M+ S1-overview, method.gg dungeon ability-trackers, warcraft.wiki.gg, npc=256116.
DBM-Raids-Midnight (Robs install) voor alle encounter-IDs + spell-ID-verificatie.
