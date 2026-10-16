# MountRunData.lua: `boss =` → Dungeon Journal encounter ID (JournalEncounter.ID)

Source file: `E:\World of Warcraft\_retail_\Interface\AddOns\MidnightHelper\Modules\MountRunData.lua` (read whole, 16 Oct 2026).
`boss = ` occurs on 107 lines: 1 comment line (15), 47 instance-level entries, 59 mount lines.

## Source and method (all lookups GEMETEN 16 Oct 2026)

- **wago.tools DB2, build `12.1.5.70391`** = the live `wow` product per `wago.tools/api/builds/latest`
  (created 2026-10-13). The site default is 12.1.7.70424 (PTR), so every request explicitly pinned
  `build=12.1.5.70391`; each response confirmed `currentVersion = 12.1.5.70391`.
- **JournalEncounter** filtered on `JournalInstanceID`. ⚠️ wago's filter is a substring match (filter 67 also
  returns instances 767 and 1267), so the rows were filtered again on exact `JournalInstanceID`.
- **JournalInstance** by ID: every journalID in the file resolves to the expected instance and its MapID
  matches the entry's `instanceID` (44/44).
- **Cross-check for every mount line:** Mount.SourceSpellID → ItemEffect.SpellID → ItemXItemEffect.ItemID →
  **JournalEncounterItem.JournalEncounterID**. This shows which journal encounter Blizzard puts the mount item
  under. It agreed with the chosen ID on 56 of 59 mount lines; the 3 exceptions are Smoldering Ember Wyrm and the
  Bronze Drake (no JournalEncounterItem row), plus "all 4 bosses" (the item sits under all four bosses).
  Mount.SourceText_lang was also read for every mountID.
- Positive control in the same run: name search `JournalEncounter Name_lang=Mal'Ganis` → 614 and
  `DungeonEncounter Name_lang=Nightbane` → 662, 2031. So the empty results for "Infinite Corruptor" and for a JE
  "Nightbane" were real searches that came back empty.
- Qualifier = the text after the first comma, verbatim, with only the single leading space removed. "—" = no comma.

## Main table (107 lines)

Status: an ID in the "encounter id" column is **GEMETEN** (the JE row was seen in DB2) unless the note says AFGELEID. The *choice* of
encounter for text that is not a single boss name is always AFGELEID and says so.

| file line | boss text verbatim | journalID | encounter id | EJ Name_lang (enUS) | qualifier verbatim | note |
|---|---|---|---|---|---|---|
| 15 | `nil: no usable encounter name (Bronze Drake, Vault of Archavon's four bosses) → a full clear counts as done.` | — | n/a | — | — | Comment in the file header, not data. Listed only because the count is 107. |
| 23 | `"Sartharion"` | 755 | 1616 | Sartharion | — | GEMETEN. Only encounter in JI 755. |
| 26 | `"Sartharion, 10"` | 755 | 1616 | Sartharion | 10 | GEMETEN. JEI: item 43986 (Black Drake) → JE 1616, DifficultyMask 1. |
| 27 | `"Sartharion, 25"` | 755 | 1616 | Sartharion | 25 | GEMETEN. JEI: item 43954 (Twilight Drake) → JE 1616, DifficultyMask 2. |
| 29 | `"Malygos"` | 756 | 1617 | Malygos | — | GEMETEN. Only encounter in JI 756. |
| 32 | `"Malygos"` | 756 | 1617 | Malygos | — | GEMETEN. JEI item 43952 → 1617. Mount source text: "Drop: Alexstrasza's Gift" (the chest after Malygos). |
| 33 | `"Malygos"` | 756 | 1617 | Malygos | — | GEMETEN. JEI item 43953 → 1617. Same chest. |
| 35 | `nil` | 753 | none | — | — | The instance-level boss is nil on purpose (full clear). JI 753 has 4 encounters: 1597 Archavon the Stone Watcher, 1598 Emalon the Storm Watcher, 1599 Koralon the Flame Watcher, 1600 Toravon the Ice Watcher (GEMETEN). |
| 38 | `"all 4 bosses"` | 753 | none | — | — | No single encounter. GEMETEN: JEI puts item 43959 under **all four**: 1597, 1598, 1599, 1600. Mount source text: "Drop: Boss Drop". If one ID is needed, use the set {1597,1598,1599,1600} (AFGELEID). |
| 39 | `"all 4 bosses"` | 753 | none | — | — | Same as line 38. JEI puts item 44083 (Horde version) under 1597, 1598, 1599 and 1600. |
| 41 | `"The Lich King"` | 758 | 1636 | The Lich King | — | GEMETEN. |
| 44 | `"The Lich King, 25 Heroic"` | 758 | 1636 | The Lich King | 25 Heroic | GEMETEN. JEI item 50818 (Invincible) → 1636, DifficultyMask 8. |
| 46 | `"Yogg-Saron"` | 759 | 1649 | Yogg-Saron | — | GEMETEN. |
| 49 | `"Yogg-Saron, 0 keepers"` | 759 | 1649 | Yogg-Saron | 0 keepers | GEMETEN. JEI item 45693 (Mimiron's Head) → 1649. |
| 51 | `"Skadi the Ruthless"` | 286 | 643 | Skadi the Ruthless | — | GEMETEN. |
| 54 | `"Skadi, Heroic"` | 286 | 643 | Skadi the Ruthless | Heroic | GEMETEN. JEI item 44151 → 643, DifficultyMask 2. |
| 61 | `"Kael'thas Sunstrider"` | 749 | 1576 | Kael'thas Sunstrider | — | GEMETEN (The Eye). Not the same as JE 533 (Magisters' Terrace). |
| 64 | `"Kael'thas"` | 749 | 1576 | Kael'thas Sunstrider | — | GEMETEN. JEI item 32458 (Ashes of Al'ar) → 1576. |
| 66 | `"Anzu"` | 252 | 542 | Anzu | — | GEMETEN. |
| 69 | `"Anzu, Heroic"` | 252 | 542 | Anzu | Heroic | GEMETEN. JEI item 32768 → 542, DifficultyMask 2. |
| 71 | `"Kael'thas Sunstrider"` | 249 | 533 | Kael'thas Sunstrider | — | GEMETEN (old Magisters' Terrace, JI 249; the Midnight Magisters' Terrace is JI 1300). |
| 74 | `"Kael'thas, Heroic"` | 249 | 533 | Kael'thas Sunstrider | Heroic | GEMETEN. JEI item 35513 → 533, DifficultyMask 2. |
| 76 | `"Attumen the Huntsman"` | 745 | 1553 | Attumen the Huntsman | — | GEMETEN (old Karazhan). |
| 79 | `"Attumen"` | 745 | 1553 | Attumen the Huntsman | — | GEMETEN. JEI item 30480 (Fiery Warhorse) → 1553. |
| 81 | `"Nightbane"` | 860 | none | — | — | GEMETEN: **Nightbane has no JournalEncounter row** (not in JI 860, and no JE anywhere has that name). It does exist as **DungeonEncounter 2031** "Nightbane", map 1651. JI 860 has 10 rows: Shade of Medivh, Mana Devourer, Opera Hall ×3, Maiden of Virtue, Attumen, The Curator, Moroes, Viz'aduum. |
| 84 | `"Nightbane"` | 860 | none | — | — | Same as line 81. JEI has no row for item 142552 (Smoldering Ember Wyrm). Mount source text has only "Zone: Return to Karazhan". The only usable DB2 handle is DungeonEncounter 2031. |
| 85 | `"Attumen"` | 860 | 1835 | Attumen the Huntsman | — | GEMETEN (Return to Karazhan). JEI item 142236 (Midnight) → 1835. Do not confuse it with 1553 (old Karazhan). |
| 87 | `nil` | 279 | none | — | — | The instance-level boss is nil on purpose. JI 279 has 4 rows: 611 Meathook, 612 Salramm the Fleshcrafter, 613 Chrono-Lord Epoch, 614 Mal'Ganis (GEMETEN). |
| 92 | `"in time, Heroic"` | 279 | 614 (doubt) | Mal'Ganis | Heroic | ⚠️ 614 is the caller's rule (end boss of the timed run), **AFGELEID**. GEMETEN against it: Mount 248 SourceText = "Drop: **Infinite Corruptor**", and Infinite Corruptor has **no** JournalEncounter or DungeonEncounter row (map 595 has only 4 DE rows: 2002, 2003, 2004, 2005). JEI has no row for item 43951. So no encounter kill drops this mount in DB2; strictly the answer is "none", and 614 only marks "the run is over". |
| 94 | `"Madness of Deathwing"` | 187 | 333 | Madness of Deathwing | — | GEMETEN. |
| 98 | `"Deathwing, Heroic"` | 187 | 333 | Madness of Deathwing | Heroic | GEMETEN. JEI item 77069 → 333, DifficultyMask 12. Source text: "Drop: Elementium Fragment" (the chest). JE 318 Spine of Deathwing is a different encounter. |
| 99 | `"Deathwing"` | 187 | 333 | Madness of Deathwing | — | GEMETEN. JEI item 77067 → 333, DifficultyMask 15. |
| 100 | `"Ultraxion"` | 187 | 331 | Ultraxion | — | GEMETEN. JEI item 78919 → 331. Source text: "Drop: Lesser Cache of the Aspects". |
| 102 | `"Onyxia"` | 760 | 1651 | Onyxia | — | GEMETEN. |
| 105 | `"Onyxia"` | 760 | 1651 | Onyxia | — | GEMETEN. JEI item 49636 → 1651. |
| 112 | `"Ragnaros"` | 78 | 198 | Ragnaros | — | GEMETEN (Firelands). Not JE 1528, the Molten Core Ragnaros. |
| 115 | `"Alysrazor"` | 78 | 194 | Alysrazor | — | GEMETEN. JEI item 71665 → 194. |
| 116 | `"Ragnaros"` | 78 | 198 | Ragnaros | — | GEMETEN. JEI item 69224 → 198. |
| 118 | `"Al'Akir"` | 74 | 155 | Al'Akir | — | GEMETEN. |
| 122 | `"Al'Akir"` | 74 | 155 | Al'Akir | — | GEMETEN. JEI item 63041 → 155. |
| 124 | `"Ji-Kun"` | 362 | 828 | Ji-Kun | — | GEMETEN. |
| 127 | `"Horridon"` | 362 | 819 | Horridon | — | GEMETEN. JEI item 93666 → 819. |
| 128 | `"Ji-Kun"` | 362 | 828 | Ji-Kun | — | GEMETEN. JEI item 95059 → 828. |
| 130 | `"Elegon"` | 317 | 726 | Elegon | — | GEMETEN. |
| 133 | `"Elegon"` | 317 | 726 | Elegon | — | GEMETEN. JEI item 87777 → 726. Source text: "Drop: Cache of Pure Energy". |
| 135 | `"Garrosh Hellscream"` | 369 | 869 | Garrosh Hellscream | — | GEMETEN. |
| 138 | `"Garrosh, Mythic"` | 369 | 869 | Garrosh Hellscream | Mythic | GEMETEN. JEI item 104253 → 869. |
| 145 | `"Archimonde"` | 669 | 1438 | Archimonde | — | GEMETEN. |
| 148 | `"Archimonde, Mythic"` | 669 | 1438 | Archimonde | Mythic | GEMETEN. JEI item 123890 → 1438. |
| 150 | `"Blackhand"` | 457 | 959 | Blackhand | — | GEMETEN. |
| 153 | `"Blackhand, Mythic"` | 457 | 959 | Blackhand | Mythic | GEMETEN. JEI item 116660 → 959. |
| 155 | `"Gul'dan"` | 786 | 1737 | Gul'dan | — | GEMETEN. |
| 158 | `"Gul'dan, Mythic"` | 786 | 1737 | Gul'dan | Mythic | GEMETEN. JEI item 137575 → 1737. The mount's other item, 116770, has no JEI row. |
| 160 | `"Gul'dan"` | 786 | 1737 | Gul'dan | — | GEMETEN. JEI item 137574 (Felblaze Infernal) → 1737. |
| 162 | `"Lady Jaina Proudmoore"` | 1176 | 2343 | Lady Jaina Proudmoore | — | GEMETEN. |
| 165 | `"Jaina, Mythic"` | 1176 | 2343 | Lady Jaina Proudmoore | Mythic | GEMETEN. JEI item 166705 → 2343. |
| 167 | `"Fyrakk the Blazing"` | 1207 | 2519 | Fyrakk the Blazing | — | GEMETEN. |
| 170 | `"Fyrakk, Mythic"` | 1207 | 2519 | Fyrakk the Blazing | Mythic | GEMETEN. JEI item 210061 → 2519. |
| 172 | `"The Jailer"` | 1195 | 2464 | The Jailer | — | GEMETEN. |
| 175 | `"The Jailer, Mythic"` | 1195 | 2464 | The Jailer | Mythic | GEMETEN. JEI item 190768 → 2464. |
| 187 | `"Mistress Sassz'ine"` | 875 | 1861 | Mistress Sassz'ine | — | GEMETEN. |
| 190 | `"Mistress Sassz'ine, any difficulty"` | 875 | 1861 | Mistress Sassz'ine | any difficulty | GEMETEN. JEI item 143643 → 1861, DifficultyMask -1. |
| 192 | `"Felhounds of Sargeras"` | 946 | 1987 | Felhounds of Sargeras | — | GEMETEN. |
| 195 | `"Felhounds, any difficulty"` | 946 | 1987 | Felhounds of Sargeras | any difficulty | GEMETEN. JEI item 152816 → 1987. Source text says "Drop: Shatug", which is one of the two Felhounds. |
| 197 | `"Argus the Unmaker"` | 946 | 2031 | Argus the Unmaker | — | GEMETEN. ⚠️ JE 2031 = Argus; **DungeonEncounter** 2031 = Nightbane. These are two tables, so do not mix them. |
| 200 | `"Argus, Mythic"` | 946 | 2031 | Argus the Unmaker | Mythic | GEMETEN. JEI item 152789 → 2031. |
| 202 | `"Sylvanas Windrunner"` | 1193 | 2441 | Sylvanas Windrunner | — | GEMETEN. |
| 205 | `"Sylvanas, Mythic"` | 1193 | 2441 | Sylvanas Windrunner | Mythic | GEMETEN. JEI item 186642 → 2441. The source text says "Lady Sylvanas Windrunner". |
| 207 | `"N'Zoth the Corruptor"` | 1180 | 2375 | N'Zoth the Corruptor | — | GEMETEN. |
| 210 | `"N'Zoth, Mythic"` | 1180 | 2375 | N'Zoth the Corruptor | Mythic | GEMETEN. JEI item 174872 → 2375. |
| 213 | `{ "Mekkatorque", "High Tinker Mekkatorque" }` | 1176 | 2334 | High Tinker Mekkatorque | — | GEMETEN. **One encounter**: the JE name is "High Tinker Mekkatorque", and the DungeonEncounter name (DE 2276) is "Mekkatorque". |
| 216 | `"Mekkatorque, Normal/Heroic/Mythic"` | 1176 | 2334 | High Tinker Mekkatorque | Normal/Heroic/Mythic | GEMETEN. JEI item 166518 (G.M.O.D.) → 2334 **and also → 2343 (Lady Jaina)**. The journal lists it under both. Mount source text: "Drop: High Tinker Mekkatorque". |
| 225 | `"Lord Aurius Rivendare"` | (none in file) | 456 | Lord Aurius Rivendare | — | GEMETEN. The file has no journalID here. The encounter is in **JI 1292 "Stratholme - Service Entrance"** (map 329). JI 236 is "Stratholme - Main Gate" and does not contain him. |
| 228 | `"Rivendare"` | (none in file) | 456 | Lord Aurius Rivendare | — | GEMETEN. JEI item 13335 → 456 (JI 1292). |
| 230 | `"Altairus"` | 68 | 115 | Altairus | — | GEMETEN. |
| 234 | `"Altairus"` | 68 | 115 | Altairus | — | GEMETEN. JEI item 63040 → 115. |
| 236 | `"Slabhide"` | 67 | 111 | Slabhide | — | GEMETEN. |
| 239 | `"Slabhide"` | 67 | 111 | Slabhide | — | GEMETEN. JEI item 63043 → 111. |
| 241 | `"High Priestess Kilnara"` | 76 | 181 | High Priestess Kilnara | — | GEMETEN. |
| 244 | `"Mandokir, Heroic"` | 76 | 176 | Bloodlord Mandokir | Heroic | GEMETEN. JEI item 68823 → 176. |
| 245 | `"Kilnara, Heroic"` | 76 | 181 | High Priestess Kilnara | Heroic | GEMETEN. JEI item 68824 → 181. |
| 247 | `{ "Lord Harlan Sweete", "Harlan Sweete" }` | 1001 | 2095 | Harlan Sweete | — | GEMETEN. **One encounter**: the JE name is "Harlan Sweete", and the DungeonEncounter name (DE 2096) is "Lord Harlan Sweete". |
| 250 | `"Harlan Sweete, Mythic"` | 1001 | 2095 | Harlan Sweete | Mythic | GEMETEN. JEI item 159842 → 2095. |
| 252 | `"Unbound Abomination"` | 1022 | 2158 | Unbound Abomination | — | GEMETEN. |
| 255 | `"Unbound Abomination, Mythic"` | 1022 | 2158 | Unbound Abomination | Mythic | GEMETEN. JEI item 160829 → 2158. |
| 257 | `"Chrono-Lord Deios"` | 1209 | 2538 | Chrono-Lord Deios | — | GEMETEN. |
| 261 | `"Deios, Mythic"` | 1209 | 2538 | Chrono-Lord Deios | Mythic | GEMETEN. JEI item 208216 ("Reins of the Quantum Courser", ItemSparse) → 2538. The line has mountID nil. |
| 268 | `"Queen Ansurek"` | 1273 | 2602 | Queen Ansurek | — | GEMETEN. |
| 271 | `"Ansurek, any difficulty"` | 1273 | 2602 | Queen Ansurek | any difficulty | GEMETEN. JEI item 224147 → 2602. |
| 272 | `"Ansurek, Mythic"` | 1273 | 2602 | Queen Ansurek | Mythic | GEMETEN. JEI item 224151 → 2602. |
| 274 | `"Chrome King Gallywix"` | 1296 | 2646 | Chrome King Gallywix | — | GEMETEN. |
| 277 | `"Gallywix, any difficulty"` | 1296 | 2646 | Chrome King Gallywix | any difficulty | GEMETEN. JEI item 236960 → 2646. |
| 278 | `"Gallywix, Mythic"` | 1296 | 2646 | Chrome King Gallywix | Mythic | GEMETEN. JEI item 235626 → 2646. |
| 280 | `"Dimensius, the All-Devouring"` | 1302 | 2691 | Dimensius, the All-Devouring | — (the comma is part of the name; a split would give `the All-Devouring`) | GEMETEN. ⚠️ A parser that splits on the first comma cuts this instance-level name in half. |
| 283 | `"Dimensius, Mythic"` | 1302 | 2691 | Dimensius, the All-Devouring | Mythic | GEMETEN. JEI item 243061 → 2691. |
| 285 | `"Midnight Falls"` | 1308 | 2740 | Midnight Falls | — | GEMETEN. JI 1308 has 2 rows: 2739 Belo'ren, Child of Al'ar, and 2740 Midnight Falls. |
| 288 | `"Midnight Falls, Mythic"` | 1308 | 2740 | Midnight Falls | Mythic | GEMETEN. JEI item 246590 → 2740. |
| 290 | `"Ula'tek"` | 1320 | 2895 | Ula'tek | — | GEMETEN. |
| 293 | `"Ula'tek, Mythic"` | 1320 | 2895 | Ula'tek | Mythic | GEMETEN. JEI item 275658 → 2895. The mount's source text has its labels swapped ("Drop: The Venomous Abyss / Location: Ula'tek"), a Blizzard data quirk. |
| 295 | `"Zul'jan"` | 1322 | 2880 | Zul'jan | — | GEMETEN. |
| 298 | `"Zul'jan, Mythic or M+ chest"` | 1322 | 2880 | Zul'jan | Mythic or M+ chest | GEMETEN. JEI item 276804 → 2880. The mount's second item, 279208, has no JEI row; it is probably the M+-chest copy (AFGELEID). |
| 300 | `{ "Restless Heart", "The Restless Heart" }` | 1299 | 2658 | The Restless Heart | — | GEMETEN. **One encounter**: the JE name is "The Restless Heart", and the DungeonEncounter name (DE 3059) is "Restless Heart". |
| 303 | `"The Restless Heart, Mythic"` | 1299 | 2658 | The Restless Heart | Mythic | GEMETEN. JEI item 262914 → 2658. |
| 305 | `"Degentrius"` | 1300 | 2662 | Degentrius | — | GEMETEN (the Midnight Magisters' Terrace, JI 1300, map 2811). |
| 308 | `"Degentrius, Mythic"` | 1300 | 2662 | Degentrius | Mythic | GEMETEN. JEI item 260231 → 2662. |
| 310 | `"The Darkness"` | 1210 | 2561 | The Darkness | — | GEMETEN. |
| 313 | `"The Darkness, Mythic or M+ chest"` | 1210 | 2561 | The Darkness | Mythic or M+ chest | GEMETEN. JEI item 225548 → 2561. |

## Per instance entry: order and DungeonEncounter (optional part)

JE OrderIndex = JournalEncounter.OrderIndex (the position in the journal). DE ID / DE OrderIndex = the linked
DungeonEncounter row (`JournalEncounter.DungeonEncounterID` → `DungeonEncounter.OrderIndex`). All values are GEMETEN.
⚠️ DungeonEncounter.OrderIndex is **not** a 1..n boss number: the values are things like -125, -1015, 4000 and 14000, sometimes negative.
Use JE OrderIndex if you want "boss N of the instance".

| file line | instance (JournalInstance.Name_lang) | JE id | JE OrderIndex | DE id | DE Name_lang | DE OrderIndex |
|---|---|---|---|---|---|---|
| 23 | The Obsidian Sanctum | 1616 | 0 | 1090 | Sartharion | 4000 |
| 29 | The Eye of Eternity | 1617 | 0 | 1094 | Malygos | 0 |
| 35 | Vault of Archavon | none | — | — | — | — |
| 41 | Icecrown Citadel | 1636 | 11 | 1106 | The Lich King | 14000 |
| 46 | Ulduar | 1649 | 12 | 1143 | Yogg-Saron | -125 |
| 51 | Utgarde Pinnacle | 643 | 3 | 2029 | Skadi the Ruthless | 500 |
| 61 | The Eye | 1576 | 3 | 733 | Kael'thas Sunstrider | 3000 |
| 66 | Sethekk Halls | 542 | 2 | 1904 | Anzu | 2000 |
| 71 | Magisters' Terrace (JI 249) | 533 | 4 | 1894 | Kael'thas Sunstrider | 1000 |
| 76 | Karazhan | 1553 | 1 | 652 | Attumen the Huntsman | 0 |
| 81 | Return to Karazhan | none | — | 2031 | Nightbane | 9000 |
| 87 | The Culling of Stratholme | none | — | — | — | — |
| 94 | Dragon Soul | 333 | 8 | 1299 | Madness of Deathwing | 1000 |
| 102 | Onyxia's Lair | 1651 | 0 | 1084 | Onyxia | 0 |
| 112 | Firelands | 198 | 7 | 1203 | Ragnaros | 2000 |
| 118 | Throne of the Four Winds | 155 | 2 | 1034 | Al'Akir | 0 |
| 124 | Throne of Thunder | 828 | 6 | 1573 | Ji-Kun | -500 |
| 130 | Mogu'shan Vaults | 726 | 5 | 1500 | Elegon | 2500 |
| 135 | Siege of Orgrimmar | 869 | 14 | 1623 | Garrosh Hellscream | 3750 |
| 145 | Hellfire Citadel | 1438 | 13 | 1799 | Archimonde | 6000 |
| 150 | Blackrock Foundry | 959 | 10 | 1704 | Blackhand | 5000 |
| 155 | The Nighthold | 1737 | 10 | 1866 | Gul'dan | 3000 |
| 162 | Battle of Dazar'alor | 2343 | 9 | 2281 | Lady Jaina Proudmoore | -1003 |
| 167 | Amirdrassil, the Dream's Hope | 2519 | 9 | 2677 | Fyrakk the Blazing | 0 |
| 172 | Sepulcher of the First Ones | 2464 | 11 | 2537 | The Jailer | 2000 |
| 187 | Tomb of Sargeras | 1861 | 5 | 2037 | Mistress Sassz'ine | 2000 |
| 192 | Antorus, the Burning Throne | 1987 | 2 | 2074 | Felhounds of Sargeras | -2000 |
| 197 | Antorus, the Burning Throne | 2031 | 11 | 2092 | Argus the Unmaker | 4000 |
| 202 | Sanctum of Domination | 2441 | 10 | 2435 | Sylvanas Windrunner | 7000 |
| 207 | Ny'alotha, the Waking City | 2375 | 12 | 2344 | N'Zoth the Corruptor | 7000 |
| 213 | Battle of Dazar'alor | 2334 | 7 | 2276 | Mekkatorque | -1015 |
| 225 | Stratholme - Service Entrance (JI 1292) | 456 | 7 | 484 | Lord Aurius Rivendare | 12000 |
| 230 | The Vortex Pinnacle | 115 | 2 | 1041 | Altairus | 0 |
| 236 | The Stonecore | 111 | 2 | 1059 | Slabhide | 250 |
| 241 | Zul'Gurub | 181 | 7 | 1180 | High Priestess Kilnara | 2000 |
| 247 | Freehold | 2095 | 4 | 2096 | Lord Harlan Sweete | 3000 |
| 252 | The Underrot | 2158 | 4 | 2123 | Unbound Abomination | 2000 |
| 257 | Dawn of the Infinite | 2538 | 8 | 2673 | Chrono-Lord Deios | 7000 |
| 268 | Nerub-ar Palace | 2602 | 8 | 2922 | Queen Ansurek | 5000 |
| 274 | Liberation of Undermine | 2646 | 8 | 3016 | Chrome King Gallywix | 7000 |
| 280 | Manaforge Omega | 2691 | 8 | 3135 | Dimensius, the All-Devouring | 7000 |
| 285 | March on Quel'Danas | 2740 | 1 | 3183 | Midnight Falls | 1000 |
| 290 | The Venomous Abyss | 2895 | 8 | 3492 | Ula'tek | 4000 |
| 295 | Altar of Fangs | 2880 | 3 | 3458 | Zul'jan | 2000 |
| 300 | Windrunner Spire | 2658 | 3 | 3059 | Restless Heart | 3000 |
| 305 | Magisters' Terrace (JI 1300) | 2662 | 4 | 3074 | Degentrius | 3000 |
| 310 | Darkflame Cleft | 2561 | 4 | 2788 | The Darkness | 7000 |

Other DE IDs for the mount-line encounters (GEMETEN): Mandokir 1179, Horridon 1575, Alysrazor 1206,
Ultraxion 1297, Attumen (Return to Karazhan) 1960, Mal'Ganis 2005 (DE name "Mal'ganis", lower-case g).

## Doubts and open points

1. **Line 92 (Bronze Drake)**: the DB2 data says the drop is "Infinite Corruptor", and that NPC has no JE or DE row. Mal'Ganis 614
   is only a proxy for "the run is done" (AFGELEID, the caller's rule). It is not the encounter that drops the mount.
2. **Lines 81 and 84 (Nightbane)**: no JournalEncounter exists. The only DB2 handle is DungeonEncounter 2031. If MountRun needs
   a JE ID, there is none; the choice is DE 2031 or a full-clear rule like the one for Vault of Archavon.
3. **Lines 38 and 39 (Vault of Archavon)**: the JEI table puts the item under all four bosses (1597 to 1600), so no single ID fits.
4. **Lines 225 and 228 (Stratholme)**: no journalID in the file. The encounter is in JI 1292 (Service Entrance), not in JI 236
   (Main Gate). The file comment says DB2 puts the Service Entrance's journal entrance on the Main Gate; I did not re-check that.
5. **Line 216 (G.M.O.D.)**: the JEI table lists the item under both Mekkatorque 2334 and Jaina 2343. The Mount source text names
   only Mekkatorque.
6. Not checked: anything in the game client itself (EJ_GetEncounterInfo). Everything here is DB2 on wago, live build 12.1.5.70391.
