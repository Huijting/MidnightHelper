# Legacy Points in Forever — onderzoek 17 nov 2026 (overgenomen uit het bericht van Sparring 17-11)

Onderzoek door mh-research (Opus, alleen gelezen) in de sessie van Sparring 17-11, letterlijk overgezet door de bouwchat
zodat het niet in een chat verdwijnt. **Niet door de bouwchat nagemeten**, behalve waar dat er later bij staat.

Rob, letterlijk (via sparring): *"legacy points. Wat zijn het? Waar krijg ik het? Hoe krijg ik het? En hoe zet ik het
in?"* Op het onderzoek: *"Legacy ook bouwen en het gat met talented als fout laten repareren. Want we willen gewoon een
goed product leveren, toch?"*

Bronnen (volgens sparring): DB2 wago-cache 1.60.1.70938, Wow.exe-strings, Blizzard-nieuws 23 sep (24307383), hotfixlijst
t/m 16 nov, Wowhead-gids Nodge 15 nov, Icy Veins 8 okt (deels oud), wowfdb, warcraft.wiki, Mobalytics 12 nov.

## De Talented-fout (eerst repareren)
ForeverDoNow (opmerking r.22), ForeverMacros (r.478 "16th talent point = level 25"), ForeverDirection en ForeverHowToPlay
rekenen met "eerste talentpunt op 10" en negeren de Legacy-perk Talented. DB2 GEMETEN (sparring): TraitCurrencySource
37163-37167 "Talented Rank 1 (Level 9)" … "Rank 5 (Level 5)" op currency 3820 (klasse-talentpunten, SourcedMax 51), elk
1 punt bij PlayerLevel 9/8/7/6/5; alle vijf → spell 1225474 = node 110298 in boom 1188 (tiered).
AFGELEID: punten op level L = min(51, L − 9 + rang); talent-levels dus tot 5 eerder. Rang lezen:
C_Traits.GetNodeInfo(cfg, 110298).currentRank (AFGELEID; eerst in de client meten via ns.db + /reload). Zonder leesbare
rang: tekst "op level X, of eerder met de Legacy-perk Talented".

## Legacy
- Punten account-breed, perks per character. Max 16 uitgeven per character (TraitCurrency 4225 SourcedMax 16; spelzin
  "seasonal cap"). Bomen 1187/1188/1189 = Professions / Adventure / Resourcefulness. Clientnamen GEMETEN in GlobalStrings:
  LEGACY_BUTTON "Legacy", LEGACY_CHALLENGE_FRAME_TITLE, LEGACY_TREE_FRAME_TITLE, LEGACY_TRACK_FRAME_TITLE,
  BINDING_NAME_TOGGLELEGACYSYSTEM; deDE Vermächtnispunkte, frFR Points d'héritage, esES Puntos de legado, ptBR Pontos de
  Legado, ruRU Очки старинных наград, itIT Engels. Gebruik de client-globals voor namen.
- Verdienen (65 regels TraitCurrencySource, Amount 1): class eerste keer 25/45/60 (27); Alch/BS/Ench/Eng/LW/Tailoring
  150/225/300 (18; verzamelberoepen tellen niet); PvP 12; Explorer + Valthalak-keten 2; Novice/Experienced/Master
  Spelunker 3; Onyxia, Hyjal, Barrow Deeps 3. Elke challenge = achievement "Earn 1 Legacy Point." (categorieën
  15585/15593/15594/15596). Venster: Blizzard zegt vanaf het eerste punt, de knop-tooltip "when your first character
  reaches level 25" — niet beslist.
- Uitgeven: Legacy-knop in het micromenu / toets; Apply. Kolom 2 open bij 5 punten in die boom, kolom 3 bij 10
  (TraitCond). Terugdraaien: class-trainer, alles tegelijk (spelzinnen GEMETEN, ook de Talented-tekortmelding).
  Kosten per rang 1 (wowfdb, niet gemeten), reset-prijs niet gemeten.
- Beloningen (verdiende punten tellen): 15 Holstered Replica Ironforge Air Rifle 276236, 25 Spectral Bear Cub 277714,
  40 Spectral Bear Tabard 277717, 55 Reins of the Spectral Bear 277718; ophalen bij Innkeeper Wiley 6791, Ratchet 62.05,
  39.41 (Zygor data_inns).
- Perks (rangen/kolom/vereiste GEMETEN DB2; getallen Icy Veins/wowfdb):
  - Adventure: Well Rested 1225478 (5, k1), Thrill of Adventure 1225472 (5, k1; niet in dungeon/raid/BG), High Alert
    1225477 (2, k2), Talented 1225474 (5, k2, vereist Well Rested 5/5), Field Guide 1225479 (3, k2, kamp-cooldown −25%),
    Field Medicine 1225475 (2, k2), Frequent Flier 1225490 (1, k3, vereist Field Guide 3/3).
  - Resourcefulness: Gourmand 1225499 (3, k1), The Quick and the Dead 1225500 (2, k1), Reinforce 1225497 (5, k1), For
    Great Honor 1225501 (5, k2), Permanence 1225502 (2, k2, vereist Gourmand 3/3; ⚠ DB2-basis 100 groepsbuff/50 kamp vs
    gidsen 50/100% voor beide — in het spel meten), Diplomat 1225485 (5, k2; esES-naam Blizzard-fout "Estudio dedicado"),
    Reagent Economy 1225503 (1, k3, vereist QatD 2/2; kamp-T1 gratis volgens gidsen, niet gemeten).
  - Professions: Working Overtime 1225451 (5, k1), Bountiful Harvest 1225435 (5, k1), Master Chef 1225457 (5, k2),
    Bartering 1225459 (2, k2), Performance Bonus 1225456 (3, k2, vereist BH 5/5), Luremaster 1225455 (2, k2), Dedicated
    Study 1225469 (1, k3, vereist Bartering 2/2).
  - Niet tonen: perk-spells zonder boom (Second Home, Personal Banking … "NYI") en "Unknown" 1317256.
- Voorbeeldbuilds (AFGELEID, spelers kiezen): start 1-4 = Thrill of Adventure; leveling = Well Rested 5 → Talented 5
  (+ Thrill 5 + 1); groep/healer = Gourmand 3, QatD 2, Permanence 2, Reinforce 3, Reagent Economy 1 + Well Rested 5;
  beroepen = Working Overtime 5, Bountiful Harvest 5, Bartering 2, Dedicated Study 1. Tank: geen perk helpt tanken.

## Bouwvoorstel
1. Uitlegkaart Legacy in ForeverHowToPlay-stijl (wat / verdienen / uitgeven / terugdraaien / 3 voorbeelden / 16-grens /
   Wiley).
2. "Do this now": "Je hebt N ongebruikte Legacy Points" + knop die het venster opent, alleen als gemeten.
3. `/mh legacy`-diagnose (zwijgregel).
4. De Talented-fix hierboven.

## API's (AFGELEID, eerst meten)
Constants.LegacyConsts.* (namen in Wow.exe: LEGACY_POINTS_TRAIT_CURRENCY_ID, LEGACY_TREE_*_ID,
LEGACY_TREE_ADVENTURE_TALENTED_NODE_ID, LEGACY_REWARD_TRACK_FACTION_ID; verwacht 4225, 1187-1189, 110298);
C_Traits.GetConfigIDBySystemID(45) / GetConfigIDByTreeID, GetTreeCurrencyInfo, GetNodeInfo; events
TRAIT_TREE_CURRENCY_INFO_UPDATED / TRAIT_CONFIG_UPDATED / TRAIT_NODE_CHANGED; open-check
C_MajorFactions.GetCurrentRenownLevel(LEGACY_REWARD_TRACK_FACTION_ID) > 0; venster LegacySystemFrame_LoadUI()
(Blizzard_LegacySystem), EventRegistry "Legacy.SelectPage" (taint niet getest). Kandidaten: TalentsForeverBook Game.lua
r.21-114, CharacterForever Embedded.lua r.562-567 — alleen als aanwijzing, licentie nakijken.
