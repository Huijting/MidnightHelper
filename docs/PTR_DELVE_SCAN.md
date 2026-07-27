# Midnight delves — measured on the 12.1 PTR

**Captured 2026-07-27 from build 120100 (RC 68914) via `/mh delvescan save`.**

Ten delves, each with its area-POI id and the coordinates it appears at per zone.
Read out of `C_AreaPoiInfo.GetDelvesForMap`, so this is the client's own answer.

## ⚠️ None of the three datamined Season 2 delves appeared

Wowhead named **The Ring of Glory**, **Gnarldor Isle** and **Venomfall Deeps** back on
20 June. None of them are in this scan.

**That is not evidence they do not exist.** `GetDelvesForMap` returns what a map is
currently OFFERING, not a catalogue, and Season 2 opens roughly a week AFTER the patch.
Delves arriving with the season would be absent from a pre-season PTR exactly like this.
Re-run the scan once Season 2 is live before drawing any conclusion.

What this scan does prove: these ten exist and these are their real names and positions.

## A delve can appear on more than one map

Fifteen rows, ten unique poi ids. Eversong Woods (2395) lists delves that also show
under Silvermoon City (2393) and Zul'Aman (2437), and Sunkiller Sanctum appears in both
Slayer's Rise and Voidstorm. De-duplicate on poi id, not on name plus map.

```
delve scan: build 120100, 15 rows

-- Silvermoon City (map 2393) --
   Collegiate Calamity                poi=8425      40.8,  54.2  delves-regular
        Delve
   The Darkway                        poi=8439      39.3,  31.7  delves-regular
        Delve
-- Zul'Aman (map 2437) --
   The Shadow Enclave                 poi=8437       5.5,  59.2  delves-regular
        Delve
   Twilight Crypts                    poi=8441      25.4,  84.4  delves-regular
        Delve
   Atal'Aman                          poi=8443      24.8,  52.9  delves-regular
        Delve
-- Eversong Woods (map 2395) --
   Collegiate Calamity                poi=8425      49.1,  22.4  delves-regular
        Delve
   The Shadow Enclave                 poi=8437      45.5,  86.0  delves-regular
        Delve
   The Darkway                        poi=8439      48.7,  15.7  delves-regular
        Delve
   Atal'Aman                          poi=8443      63.8,  80.0  delves-regular
        Delve
-- Isle of Quel'Danas (map 2424) --
   Parhelion Plaza                    poi=8427      46.4,  40.6  delves-regular
        Delve
-- Slayer's Rise (map 2444) --
   Sunkiller Sanctum                  poi=8429      60.7,  96.8  delves-regular
        Delve
-- Harandar (map 2413) --
   The Grudge Pit                     poi=8433      70.5,  64.9  delves-regular
        Delve
   The Gulf of Memory                 poi=8435      36.3,  49.1  delves-regular
        Delve
-- Voidstorm (map 2405) --
   Sunkiller Sanctum                  poi=8429      54.8,  47.1  delves-regular
        Delve
   Shadowguard Point                  poi=8431      37.2,  49.0  delves-regular
        Delve
```
