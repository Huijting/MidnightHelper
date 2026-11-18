# fable_G3 — nakijkronde Forever-bazengids, 8 dungeons

Sunken Temple (109), Blackrock Depths (230), Dire Maul (429), Blackrock Spire (229), Blackmaw Hold (2974),
The Shaper's Terrace (3001), Scholomance (289), Stratholme (329). Nagekeken op 18 nov 2026, onafhankelijk
(geen rapporten of notes van anderen gelezen; alleen code, teksten en bronnen).

Reparatie-regels per taal staan klaar in `fable_G3_<taal>.txt` (enUS, nlNL, deDE, frFR, esES, esMX, ptBR, ruRU),
vorm `<tab>KEY = "tekst",`. Getest met `g3_verify.py`: 86 regels, 0 vormfouten, cijfers gelijk aan het Engels.

## 1. Wat ik gemeten heb (en hoe)

Alles DB2 = wago.tools, Forever build **1.60.1.70959**; Wowhead = `nether.wowhead.com/forever/tooltip`, 18 nov 2026.

| Wat | Hoe | Uitkomst |
|---|---|---|
| 119 baas-rijen: npc-id + Engelse naam | Wowhead Forever npc-tooltip per id (`g3_names.py`) | GEMETEN: alle id's kloppen |
| Namen per taal (6 talen x 119) | Wowhead Forever npc-naam per locale, naast DB2 DungeonEncounter | GEMETEN: 2 gaten (F7, R5), verder volgens de regel |
| encounter-id's (+ encounterAlt van ST) | DB2 DungeonEncounter | GEMETEN: alle gelijk |
| 39 loot-rijen: "Dropped by" + cijfers in de rol | volledige Wowhead Forever item-tooltip (`g3_items.py`) | GEMETEN: 39 x goed, elk cijfer in de roltekst klopt |
| Rare/Elite | Wowhead-tooltip (`g3_names.py --cls`) | GEMETEN: gelijk aan de `rare`-vlaggen, op 2 bekende MEASURE-punten na (Timmy, Tsu'zee) |
| Plaats-, item-, npc-, object-, questnamen in 6 talen | DB2 WMOAreaTable/AreaTable/SpellFocusObject/GroupFinderActivity/ItemSparse/SkillLine/CreatureType + Wowhead-tooltips (`g3_terms.py`) | GEMETEN: zie F1-F6 |
| Vertalingen | alle 445 sleutels in nl, de, fr, es, pt, ru + de 33 esMX-regels helemaal gelezen; `g3_loc.py`: 0 ontbrekend, 0 cijferverschillen | zie hoofdstuk 2-3 |
| Engelse does/tip | tegen Forever-gidsen (lijst onderaan) | geen harde fout; zie R1-R4 |

## 2. FOUT (zeker)

### F1 — deDE: 22 regels met een Engelse plaatsnaam terwijl de Duitse client een naam heeft
GEMETEN in WMOAreaTable (nieuwste rij per naam; de es/pt/ru-packs gebruiken precies deze clientnamen al, de/fr niet).
Regel van Rob (20 okt): elke spelnaam = wat die client toont.

| Engels in het pack | Duitse client (WMOAreaTable-id) | sleutels |
|---|---|---|
| Pit of Refuse | Die Grube der Weigerung (131883) | FDG_ST_1_D1 |
| East Garrison / West Garrison | Die Ostgarnison (147900) / Die Westgarnison (147932) | FDG_BRD_4_D3, FDG_BRD_11_D1 |
| Shrine of Thaurissan | Der Schrein von Thaurissan (147899) | FDG_BRD_5_D1, FDG_BRD_9_D3 |
| Black Vault | Das schwarze Gewölbe (147935) | FDG_BRD_7_D1, FDG_BRD_8_D1 |
| Hall of Crafting | Die Halle des Handwerks (147913) | FDG_BRD_9_D1 |
| Dark Iron Highway | Die Dunkeleisenstraße (147901) | FDG_BRD_10_D1 |
| Manufactory | Die Manufaktur (147928) | FDG_BRD_12_D1 |
| Grim Guzzler | Zum Grimmigen Säufer (147908) | FDG_BRD_13_D1, 15_D1, 16_D1, 17_D1 |
| Summoners' Tomb | Die Gruft der Beschwörer (147929) | FDG_BRD_18_D1 |
| Lyceum | Das Lyzeum (147930) | FDG_BRD_19_D1 |
| Imperial Seat | Der Kaiserliche Sitz (147923) | FDG_BRD_21_D1 |
| Scarlet Bastion | Die Scharlachrote Bastion (143720) | FDG_STRAT_6_D3, FDG_STRAT_7_D1 |
| Slaughter Square / Slaughter House | Der Schlächterplatz (143664) / Das Schlachthaus (143700) | FDG_STRAT_17_D2, 18_D1, 18_D3 |

Reparatie: `fable_G3_deDE.txt` (alle 22 uitgeschreven, naamvallen aangepast).
AFGELEID: dat de client de NIEUWSTE rij toont. Onderbouwing: de WMO's van BRS/Strat/BRD (21069/21107/21773) zijn nieuwer
dan die van de Forever-dungeon Hall of Thanes (20708). Twee namen verschillen tussen oude en nieuwe rij: deDE
"Beschwörer-Grabmal" (oud) / "Die Gruft der Beschwörer" (nieuw). Bij twijfel: in het spel naar de zonetekst kijken.

### F2 — frFR: zelfde fout, 21 regels
| Engels in het pack | Franse client | sleutels |
|---|---|---|
| Pit of Refuse | La Fosse aux ordures | FDG_ST_1_D1 |
| East/West Garrison | Garnison de l’Est / Garnison de l’Ouest | FDG_BRD_4_D3, 11_D1 |
| Shrine of Thaurissan | Sanctuaire de Thaurissan | FDG_BRD_5_D1, 9_D3 |
| Black Vault | La Voûte noire | FDG_BRD_7_D1, 8_D1 |
| Hall of Crafting | Chambre de l’Artisanat | FDG_BRD_9_D1 |
| Dark Iron Highway | Grand-route des Sombrefer | FDG_BRD_10_D1 |
| Manufactory | La Manufacture | FDG_BRD_12_D1 |
| Grim Guzzler | Le Sinistre écluseur (nieuwste rij 147908; oude rij: "Le Sinistre dévoreur") | FDG_BRD_13_D1, 15_D1, 16_D1, 17_D1 |
| Summoners' Tomb | Tombe des invocateurs | FDG_BRD_18_D1 |
| Imperial Seat | Le Siège impérial | FDG_BRD_21_D1 |
| Scarlet Bastion | Le Bastion écarlate | FDG_STRAT_6_D3, 7_D1 |
| Slaughter Square / House | Place du Massacre / L’Abattoir | FDG_STRAT_17_D2, 18_D1, 18_D3 |

Reparatie: `fable_G3_frFR.txt`. ("Lyceum" stond al goed: client "Le Lyceum".)
⚠️ "Sinistre écluseur" vs "dévoreur": de nieuwste rij wint volgens dezelfde afleiding als bij F1; één blik in het spel beslist.

### F3 — "Black Anvil" staat in ALLE vertaalde packs in het Engels (FDG_BRD_6_D1)
GEMETEN: DB2 SpellFocusObject 623 "Black Anvil": deDE Schwarzer Amboss, frFR Enclume noire, esES Yunque Negro,
esMX Yunquenegro, ptBR Bigorna Negra, ruRU Черная наковальня. (Geen rij in WMOAreaTable/AreaTable: het is een object.)
Reparatie: FDG_BRD_6_D1 in de/fr/es/mx/pt/ru (in de taalbestanden).

### F4 — ptBR: "dragonicos" is geen clientwoord (6 regels)
GEMETEN: DB2 CreatureType 2 Dragonkin = ptBR **Draconiano**. Het pack schrijft "dragonico(s)" (ook geen goed Portugees).
Sleutels: FDG_ST_6_T, FDG_ST_7_T, FDG_ST_8_D1, FDG_ST_8_T, FDG_BRS_12_D1, FDG_BRS_15_D1 → `fable_G3_ptBR.txt`.
(de "Drachkin", fr "draconiens", es "dragonantes" kloppen met de client.)

### F5 — ruRU: Relic Coffer heet in de client "Реликварий", het pack zegt "древних сундуков"
GEMETEN: Wowhead Forever object 160836, ruRU-naam "Реликварий" (de andere vijf talen gebruiken de clientnaam wel).
Sleutels: FDG_BRD_8_D1 en FDG_BRD_8_T ("последний сундук") → `fable_G3_ruRU.txt`.

### F6 — data: Watchman Doomgrip mist `esMX` in `names`
`Modules/ForeverDungeonGuideData.lua:1204` — names heeft deDE, frFR, esES, ptBR, ruRU, geen esMX. `BossName()`
(`ForeverDungeonGuide.lua:108`) valt dan terug op het Engels: een esMX-speler ziet de kop "Watchman Doomgrip", terwijl
de tekst eronder (FDG_BRD_8_D2, geërfd van esES) "Vigía Presaletal" zegt.
GEMETEN: Wowhead esMX geeft "[Watchman Doomgrip]" (= geen eigen naam); regel: esMX zonder eigen naam = esES.
Reparatie (in de generatorbron, het bestand is gegenereerd): `esMX = "Vigía Presaletal"` toevoegen.

### F7 — enUS + nlNL: "Crusader's Square" heet in de client "Crusaders' Square"
GEMETEN: WMOAreaTable 143682 (ook 32319, 42668, 92112) enUS = "Crusaders' Square". De vijf vertaalde packs gebruiken de
goede clientnaam al (Kreuzzüglerplatz, Place des Croisés, Plaza de los Cruzados, Praça dos Cruzados, Площадь рыцарей).
Reparatie: FDG_STRAT_6_D1 = "Shows up in Crusaders' Square after you clear all mobs there." (+ nlNL, zie bestand). Klein.

## 3. RISICO

### R1 — FDG_STRAT_8_D1 / FDG_STRAT_15_D1: "armorsmith plans" is te stellig
GEMETEN (Wowhead Forever "Dropped by", 18 nov): Crimson Hammersmith dropt *Crimson Hammersmith's Apron* (13351,
quest-item) en *Bottom Half of Advanced Armorsmithing: Volume II* (18781, 24,83%); Black Guard Swordsmith dropt
*Insignia of the Black Guard* (13350) en *Bottom Half ... Volume III* (18783, 24,24%). De bovenste helften komen van
Rattlegore (18782) en Urok Doomhowl (18784). Het is dus geen plan maar een half boek; de quests Sweet Serenity en
Corruption zijn bovendien voor hammer-/swordsmiths (conquestcapped, Stratholme-quests, 18 nov 2026).
Nieuwe tekst: `... he is for blacksmiths (a quest item, and half of an armorsmithing book).` — beide sleutels, in alle
8 bestanden uitgeschreven.

### R2 — nergens staat dat Blackrock Spire voor 10 spelers is
GEMETEN: DB2 MapDifficulty rij 24 (map 229, DifficultyID 1) MaxPlayers = **10**; alle andere van deze dungeons 5.
De tips rekenen erop ("Bring a second tank", "both tanks", FDG_BRS_15_T / 17_D3 / 17_T), maar een nieuwe speler leest
dat als een groep van 5. Voorstel (AFGELEID, niet in de taalbestanden gezet): FDG_BRS_11_D1 laten beginnen met
"Upper Spire takes up to 10 players. Its door only opens if ...". Tweede bron: wowfdb.com ("Upper is set for 10
players"), mmonster (22 sep), forever-hub (9 nov).

### R3 — loot ST: Fist of the Damned krijgt geen "van ..."
`{ item = 10804, boss = 5711 }` (regel 1156): 5711 = Ogom the Wretched is een `extraNpc`; `byNpc` in
`ForeverDungeonGuide.lua:146` bevat alleen `b.npc`, dus `byNpc[5711]` is nil en de regel toont geen baas. Het is de enige
van de 39 loot-rijen. Keuze: (a) zo laten, (b) in de lus op regel 143-150 ook de extraNpc-id's op de baas laten wijzen
(dan staat er "Jammal'an the Prophet", het gevecht waarin Ogom meedoet). GEMETEN in de code, niet in het spel.

### R4 — de vlag `optional` wordt nergens getoond
`ForeverDungeonGuide.lua` rendert alleen `rare` en `one`. Bij bijna elke optionele baas zegt de tekst zelf "Optional:",
maar niet bij **Pyromancer Loregrain** (FDG_BRD_5_D1) en niet bij Princess Moira (daar volgt het uit de tekst).
Voorstel: FDG_BRD_5_D1 met "Optional: " laten beginnen, of de vlag tonen. AFGELEID uit de code.

### R5 — Tor'Rel & Izha'Rel: geen namen in esES/esMX/ptBR/ruRU
Regel 1609 heeft alleen deDE en frFR. GEMETEN: Wowhead geeft in die vier talen "[Tor'Rel]" (geen vertaling), DB2 3499
heet "Ravasaur Hunters" (es "Ravasaurios cazadores", pt "Ravassauros Caçadores", ru "Равазавры-охотники"). Nu valt het
terug op het Engels en staat er in de Russische tip "сначала Tor'Rel". Staat al als MEASURE in de data; blijft open.

### R6 — Service Gate: esES en ruRU gebruiken een andere clientnaam dan de Group Finder
GEMETEN: GroupFinderActivity 1603 "Stratholme (Service Gate)": de Dienstbotentor, fr porte de service,
**es puerta de servicio**, mx Entrada de Servicio, pt entrada de serviço, **ru боковые врата**. Het esES-pack zegt
"Entrada de Servicio", het ruRU-pack "Черный ход" (dat zijn de namen van het gebiedje "Service Entrance", WMOAreaTable
32323). Main Gate klopt overal. Reparatie in `fable_G3_esES.txt` en `_ruRU.txt` (FDGP_SERVICE_GATE, FDG_STRAT_17_D1,
17_D2). ⚠️ Neem je de esES-regels over, dan MOETEN de drie regels in `fable_G3_esMX.txt` mee (anders krijgt Mexico de
Spaanse naam). Welke naam de MH-dungeonlijst zelf toont heb ik niet gemeten.

### R7 — esES: Roughshod Pike staat Engels in FDG_BRS_6_D1
GEMETEN: ItemSparse 12533 esES is **leeg** (deDE Beschlagene Pike, esMX Pica férrea, ptBR Pique da Brutalidade); Wowhead
esES geeft "[Roughshod Pike]". Er is dus geen Spaanse clientnaam; Engels laten staan is verdedigbaar. Niet gewijzigd.

### R8 — deur-eisen klinken zekerder dan de Forever-bronnen
- Seal of Ascension (FDG_BRS_11_D1): conquestcapped (15 okt) en forever-hub (9 nov) zeggen ja; mmonster (22 sep):
  "Whether the door still asks for the seal, Blizzard has not said"; wowforeverguides (9 nov): "Reported".
- Key to the City (FDG_STRAT_17_D1): conquestcapped 18 nov zegt ja; staat al als MEASURE in de data.
- Skeleton Key (FDG_SCHOLO_1_D1): GEMETEN DB2 Lock 1159 = item 13704, Lockpicking 280, opblazen 300 → klopt met de tekst.
- Scarlet Key (FDG_STRAT_6_D3): tekst zegt zelf "In Classic"; GEMETEN DB2 Lock 299 = item 7146 of Lockpicking 175.
- Crescent Key (FDG_DIRE_1_D3): alle Dire Maul-gidsen zijn Classic-gebaseerd (Warcraft Tavern zegt dat zelf).
Niemand meldt een Forever-run waarin de deur getest is. Geen tekstwijziging; wel een punt voor Robs testlijst.

### R9 — kleine taalpunten
- nlNL FDG_SCHOLO_5_D2: "blaast iedereen bij hem weg" maakt van "blasts" een knockback; Engels en de andere talen
  zeggen alleen "raakt met een explosie" → regel in `fable_G3_nlNL.txt`.
- nlNL FDG_BRS_17_T: "Gewoon plan" (= "Usual plan") → "Gebruikelijk plan".
- deDE FDG_DIRE_12_D2: "sprich mit Mizzle der Gewiefte" → "mit Mizzle dem Gewieften" (naamval).
- esMX FDG_DIRE_16_D1: erft "Magíster Kalendris"; esMX-naam is "Magister Kalendris" (Wowhead esMX).
- ruRU schrijft "дракониды" voor dragonkin; het client-type heet "Дракон" (CreatureType 2). "Драконид" is wel een
  clientwoord (npc-namen), dus niet gewijzigd; alleen gemeld.
- Urok Doomhowl is bij Wowhead "Rare Elite", in de gids `optional` (hij wordt opgeroepen): goed zo.

### R10 — "Archival Panel" en "Titan Panel" staan in alle talen Engels
Ik kon geen object-id vinden (niet in DB2 GameObjects, niet via Wowhead-zoeken), dus de clientnaam per taal is NIET
gemeten. Blijft open tot iemand het paneel in het spel aanwijst.

### R11 — twee DB2-gevechten staan niet in de gids
DB2 DungeonEncounter kent ook 2793 Lord Hel'nurath (Dire Maul) en 3070 Lord Valthalak (Blackrock Spire); allebei
opgeroepen bazen. Kormok (ook opgeroepen) staat wél in de gids. Keuze van de bouwer, geen fout.

### R12 — Scholomance: Headmaster's Study in ptBR/ruRU
Pack: "Estúdio do Diretor" / "Кабинет Директора" = de rij van de oude Scholomance (WMO 3293); de nieuwste rij (WMO 6746,
de verbouwde Scholomance) zegt "Gabinete do Diretor" / "Кабинет ректора". Forever gebruikt de oude indeling (bazen =
Classic), dus het pack is waarschijnlijk goed. AFGELEID.

## 4. Gecontroleerd en in orde

- **Bazen en id's** (GEMETEN): 119 rijen, elke npc-id geeft bij Wowhead Forever de verwachte naam; encounter-id's = DB2.
  Waar Wowhead alleen Engels geeft en DB2 een vertaling heeft, staat de DB2-naam (Fineous Dunkelader, Zevrim
  Sabot-de-Ronce, Instructora Malicia ...), precies volgens de namenregel.
- **Loot** (GEMETEN): 39 items, "Dropped by" 39 x gelijk aan de baas in de data; alle cijfers in de 39 rolteksten
  staan zo in de Forever-tooltip (ook de Forever-waarden die van Classic afwijken: Hand of Justice +12 AP,
  Headmaster's Charge +90, Robes of the Exalted +40).
- **Sunken Temple**: schrijn-volgorde, zes verdedigers → barrière, Ogom, draken-volgorde (Hazzas/Morphaz pas na
  Dreamscythe/Weaver), Shade roept alle dragonkin, Avatar (ei of scroll, vier vlammen): Wowhead Forever-gids (bijgewerkt
  4 nov 2026) + conquestcapped (15 okt 2026). Totem dat skeletten oproept = Zolo's Skeleton Summoning Totem (Wowhead).
- **Blackrock Depths**: Ring of Law = twee golven + één van zes (Wowhead Forever, Warcraft Tavern, wowfdb); Roccor in de
  gang om de ring, Grebmar tussen twee hondengroepen (Wowhead, undying.app). Rest gelijk aan Classic-gedrag; geen
  Forever-bron die het tegenspreekt.
- **Dire Maul**: tribute-run stap voor stap (Kreeg slaapt, Fengus' kist, val met Frost Oil + Thorium Widget, Ogre Suit,
  Cho'Rush leeft, Mizzle): warcraftmaps (4 nov), wowforever.be, Warcraft Tavern, wowforeverguides (9 nov). Binnendeur
  zonder sleutel = Lockpicking 300 / Seaforium / Truesilver Skeleton Key → "rogue, engineer of blacksmith" klopt.
- **Blackrock Spire**: zegel + drie edelstenen, runen-hal, altaar, Father Flame, golven + Gyth, kite bij Drakkisath:
  conquestcapped UBRS (15 okt), forever-hub (9 nov), wowforeverguides (9 nov).
- **Blackmaw Hold** (nieuw): alle zeven bazen + drie rares tegen Warcraft Tavern Forever, Mobalytics (uncas), MMONerds
  (17 nov), wowfdb (18 nov), undying.app: geen tegenspraak met de teksten. (MMONerds noemt een vierde rare, Mopes.)
- **Shaper's Terrace** (nieuw): 15 kristallen per paneel, kleuren → bazen, grot achter de linker waterval, Tor'Rel
  eerst, Titan Panel: Warcraft Tavern Forever + conquestcapped (5 nov) + gametruth (13 nov) + Blizzard-hotfix 9 nov.
  Het bekende verschil (Nanaya na "panelen gebruikt" of na "vier bazen dood") staat al als MEASURE in de data.
- **Scholomance**: deur (zie R8), Blood of Innocents, fakkel naar Jandice, Viewing Room Key, zes leraren → Gandling:
  wowforeverguides (9 nov), azeroth.wiki, fextralife-wiki, worstguidesever (16 sep).
- **Stratholme**: tabaksdoos, brievenbussen, Timmy na het plein, Malor's strongbox, ziggurats + Acolytes, Slaughter
  Square, 45 minuten: conquestcapped Stratholme-quests (**18 nov 2026**), warcraftmaps (30 okt).
- **Vertalingen**: 445 sleutels x 6 talen aanwezig, geen cijferverschil, geen lege of Engelse regels behalve de
  bewuste (nlNL-rollen/vleugels). Item-, npc-, object- en questnamen in de/fr/es/mx/pt/ru kloppen met Wowhead Forever
  per locale (o.a. Schmiedekunstpläne, Reliktkasten, Krähenhorstbrutwächter, "Trastos wow de torio" en "Taje ogro de
  Gordok" — dat zijn echt de esES-clientnamen, ItemSparse 15994/18258). Vleugelnamen East/North/West/Lower/Upper/
  Main Gate = GroupFinderActivity, op R6 na. esMX-overlay: alle esMX-afwijkingen die ik kon meten zijn afgedekt.
- **nlNL**: Engelse spelnamen, overal "spells".

## 5. Niet kunnen meten (dus niet "in orde")

- Wat de client écht als zonetekst toont (F1/F2 steunen op de nieuwste WMOAreaTable-rij).
- Clientnamen van Archival Panel / Titan Panel (R10) en van Seal of Ascension (12344 ontbreekt in ItemSparse; Wowhead
  geeft "[Seal of Ascension]" in elke taal — afwezig in ItemSparse ≠ bestaat niet).
- Of de deuren in Forever nog de Classic-sleutels vragen (R8).
- Elke vaardigheid van elke Classic-baas apart tegen een Forever-run: de meeste Forever-gidsen zeggen zelf dat ze op
  Classic steunen ("not accessible in the WoW Forever Beta"). Ik vond geen bron die een tekstregel tegenspreekt.

## 6. Bronnen (opgehaald 18 nov 2026)

wowhead.com/forever/guide/the-temple-of-atalhakkar-... (bijgewerkt 4 nov) · conquestcapped.com: Sunken Temple (15 okt),
UBRS (15 okt), Shaper's Terrace (5 nov), Stratholme-quests (18 nov) · warcrafttavern.com/forever: Sunken Temple,
Blackrock Depths, Dire Maul North, Blackmaw Hold, Shaper's Terrace · wowfdb.com (18 nov) · undying.app ·
wowforeverguides.com: UBRS, DM North, Scholomance (8-9 nov) · warcraftmaps.com: Sunken Temple (17 nov), DM tribute
(4 nov), Stratholme (30 okt) · forever-hub.com UBRS (9 nov) · mmonster.co UBRS (22 sep) · mmonerds.com Blackmaw Hold
(17 nov) · mobalytics.gg (uncas) Blackmaw Hold + Shaper's Terrace · gametruth.com Shaper's Terrace (13 nov) ·
azeroth.wiki, wowforever.wiki.fextralife.com, worstguidesever.com (Scholomance) · wowhead.com/forever/news hotfixes
9 nov. Lokaal: ForeverDungeonJournal alleen gebruikt om te zien dat het vooral loot/quests bevat (niets overgenomen).

## 7. Hulpscripts in de scratchpad (alleen lezen, opnieuw te draaien)

`g3_names.py` (namen/id's; `--cls` = Elite/Rare), `g3_items.py` (loot), `g3_loc.py` (teksten per taal + controles),
`g3_terms.py` (clientnamen in de teksten; `--only=object`), `g3_wmo.py` / `g3_db2names.py` (DB2-naam in 7 talen),
`g3_verify.py` (controle van de reparatiebestanden).
