# Season 2 encounter data — captured from the 12.1 PTR

**Captured 2026-07-27 from build 120100 (RC 68914), tier 13 "Current Season",
via `/mh ej save` + the SavedVariables on Rob's PTR install.**

This is measured data, not datamining: every id below came out of the client's own
Encounter Journal. It is written down here because the Season 2 dungeon test window
closed on 27 July and there may be no further PTR build before 12.1 goes live.

Cross-checks that passed: Altar of Fangs 3 bosses, The Venomous Abyss 8 bosses, and
an 8-dungeon Mythic+ pool — all three match what the patch notes described.

Two cautions before building on this:

- `ejCreature` is the Encounter Journal's own creature entry id, **not** an NPC id.
  Midnight NPCs sit in the hundreds of thousands; these are four digits. For a real
  NPC id, pull the boss with `/mh encounters` on, or read the combat log.
- Raid encounterIDs are **not** in fight order (2888, 2874, 2894, 2882, 2871, 2887,
  2883, 2895). Order comes from the index, never from sorting the ids.
- "Keystone Dungeons" (1319) is not a dungeon. It is the journal's Mythic+ affix
  reference page, which is why Xal'atath and the affix creatures appear under it.

The Season 2 Mythic+ pool is the eight dungeons below, minus that entry: five new
(Altar of Fangs, Den of Nalorakk, Murder Row, The Blinding Vale, Voidscar Arena)
and three legacy (Kings' Rest, Ruby Life Pools, Temple of Sethraliss).

```
capture: build 120100, tier 13 (Current Season), 11 instances

DUNGEON  id=1322  diff=23  3 bosses  Altar of Fangs
    1. encounterID=2878   Rav'i                              6210=Rav'i
    2. encounterID=2879   The Writhing Coil                  6230=The Writhing Coil
    3. encounterID=2880   Zul'jan                            6218=Zul'jan
DUNGEON  id=1311  diff=23  3 bosses  Den of Nalorakk
    1. encounterID=2776   The Hoardmonger                    5941=The Hoardmonger, 5944=Rotten Mushroom
    2. encounterID=2777   Sentinel of Winter                 5948=Sentinel of Winter, 5947=Fractured Shivercore
    3. encounterID=2778   Nalorakk                           5978=Nalorakk, 5979=Zul'jarra
DUNGEON  id=1304  diff=23  4 bosses  Murder Row
    1. encounterID=2679   Kystia Manaheart                   5847=Kystia Manaheart, 5848=Nibbles
    2. encounterID=2680   Zaen Bladesorrow                   5851=Zaen Bladesorrow, 5852=Forbidden Freight
    3. encounterID=2681   Xathuux the Annihilator            5853=Xathuux the Annihilator
    4. encounterID=2682   Lithiel Cinderfury                 5855=Lithiel Cinderfury, 5860=Furious Vilefiend, 5862=Wild Imp, 6153=Infernal
DUNGEON  id=1309  diff=23  4 bosses  The Blinding Vale
    1. encounterID=2769   Lightblossom Trinity               6106=Meittik, 6104=Lekshi, 6105=Kezkitt, 6107=Lightblossom
    2. encounterID=2770   Ikuzz the Light Hunter             6102=Ikuzz the Light Hunter, 6103=Bloodthorn Roots
    3. encounterID=2771   Lightwarden Ruia                   6100=Lightwarden Ruia, 6101=Lightwarden Ruia, 6099=Lightwarden Ruia
    4. encounterID=2772   Ziekket                            6097=Ziekket, 6096=Lightspawn Lasher
DUNGEON  id=1313  diff=23  3 bosses  Voidscar Arena
    1. encounterID=2791   Taz'Rah                            5960=Taz'Rah
    2. encounterID=2792   Atroxus                            5961=Atroxus, 6189=Toxic Creeper
    3. encounterID=2793   Charonus                           5962=Charonus
DUNGEON  id=1041  diff=23  4 bosses  Kings' Rest
    1. encounterID=2165   The Golden Serpent                 4904=The Golden Serpent
    2. encounterID=2171   Mchimba the Embalmer               4905=Mchimba the Embalmer
    3. encounterID=2170   The Council of Tribes              4907=Aka'ali the Conqueror, 4908=Zanazal the Wise, 4906=Kula the Butcher
    4. encounterID=2172   Dazar, The First King              4909=King Dazar, 6223=T'zala, 6222=Reban
DUNGEON  id=1202  diff=23  3 bosses  Ruby Life Pools
    1. encounterID=2488   Melidrussa Chillworn               5358=Melidrussa Chillworn, 5450=Infused Whelp
    2. encounterID=2485   Kokia Blazehoof                    5354=Ko'kia Blazehoof, 5355=Blazebound Firestorm
    3. encounterID=2503   Kyrakka and Erkhart Stormvein      5393=Kyrakka, 5392=Erkhart Stormvein
DUNGEON  id=1030  diff=23  4 bosses  Temple of Sethraliss
    1. encounterID=2142   Adderis and Aspix                  4710=Adderis, 4711=Aspix
    2. encounterID=2143   Merektha                           4725=Merektha, 4727=Toxic Viper, 4927=Storm Serpent
    3. encounterID=2144   Galvazzt                           4728=Galvazzt
    4. encounterID=2145   Avatar of Sethraliss               4740=Avatar of Sethraliss, 4738=Corrupted Guardian, 4739=Twisted Hexxer, 4772=Faithless Tormentor, 6238=Essence Defiler
DUNGEON  id=1319  diff=23  2 bosses  Keystone Dungeons
    1. encounterID=2869   Mythic Keystones                   6126=Lindormi
    2. encounterID=2870   Affixes                            6127=Xal'atath, 6130=Orb of Ascendance, 6132=Void Pulsar, 6131=Void Emissary, 6133=Devouring Rift
RAID     id=1317  diff=14  1 bosses  The Tidebound Grotto
    1. encounterID=2849   Nymrissa Wavecaller                6197=Nymrissa Wavecaller, 6198=Bubblefin Shorerunner, 6200=Bubblefin Frostscale, 6199=Bubblefin Berserker
RAID     id=1320  diff=14  8 bosses  The Venomous Abyss
    1. encounterID=2888   Nek'zali the Soulcoiler            6155=Nek'zali, 6190=Raised Amani, 6191=Latent Cultist, 6192=Echo of Jawae
    2. encounterID=2874   Entombed Sentinels                 6181=Breath of Ula'tek, 6180=Blood of Ula'tek
    3. encounterID=2894   The Lost Explorers                 6196=Mor'zahi, 6195=Scrollsage Iku, 6193=First Mate Nama, 6194=Trader Gebbo
    4. encounterID=2882   Vashnik the Malignant              6170=Vashnik the Malignant, 6168=Clotting Venom, 6171=Shrouded Venom, 6169=Burning Venom
    5. encounterID=2871   Sszorak                            6128=Sszorak
    6. encounterID=2887   The Twin Fangs                     6151=Vexhul, 6150=Ithraz, 6234=Spawn of Vexhul, 6237=Barbed Bulwark, 6236=Broodling of Ithraz
    7. encounterID=2883   The Coiled Altar                   6184=Zul'jan, 6182=Hex Lord Malacrass, 6183=Manifestation of Dread, 6231=Spiteful Soulcoiler, 6185=Fragment of Malacrass
    8. encounterID=2895   Ula'tek                            6186=Ula'tek, 6211=Gore Rattle, 6188=Blightscale Rawling, 6187=Blightscale Viper, 6229=Doomscale Warden, 6201=Blightscale Spawn, 6202=Blightscale Clutch, 6232=Slithering Clutch, 6239=Toxic Blightscale, 6241=Shrieking Blightscale
```
