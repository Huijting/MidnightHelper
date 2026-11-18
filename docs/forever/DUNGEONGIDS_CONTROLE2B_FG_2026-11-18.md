# Tweede controle, stap 2b, deel F + G (18 nov 2026)

Gecontroleerd: `dg2b_F.lua` (Scholomance 289, Stratholme 329 Main Gate/Service Gate) en `dg2b_G.lua` (Blackmaw Hold
2974, The Shaper's Terrace 3001). Code niet bekeken (niet gevraagd). Repo en `probe_job.txt` niet aangeraakt.
Mijn eigen oordeel stond klaar vóór ik `dg2b_F_notes.md` en `dg2b_G_notes.md` las (onderaan: wat daar staat).
G = GEMETEN (gezien in de genoemde bron, gelezen 18 nov 2026), A = AFGELEID.

## Uitslag

**1 FOUT, 13 RISICO.** Geen enkele npc-id, encounter-id, item-id, "Dropped by" of naam per taal is fout.
De FOUT is een tekstfout (Tor'Rel). De belangrijkste RISICO's: Scholomance zegt de speler nergens dat hij een
Skeleton Key nodig heeft; de Scarlet Bastion-deur wordt de speler niet gemeld; drie `src`-regels noemen een bron
die het niet zegt (Nanaya-tip, Ramstein-volgorde, Malown-postmannen).

## 1. Namen per taal (regel B: naamplaatje = Wowhead Forever npc-tooltip per locale)

G: ik heb niet 20 maar **alle** namen nagemeten: 34 npc's van F en 22 van G, elk in deDE, frFR, esES, esMX, ptBR,
ruRU (`run gamedata npc ... --game forever --locale X`, 18 nov 2026), samen 336 namen. **Alle 336 gelijk aan wat in
de Lua staat.** Ook de `nil`'s kloppen: Black Guard Swordsmith esMX = placeholder "[Black Guard Swordsmith]";
Tor'Rel esES/esMX/ptBR/ruRU = placeholder "[Tor'Rel]". Engelse `name` = WHT enUS voor alle 56 (G).

Opvallend, geen fout (G):
- WHT Classic geeft dezelfde vreemde namen als WHT Forever: frFR "Baron Rivendare" en "Hearthsinger Forresten"
  (DB2: "Baron Vaillefendre", "Chanteloge Forrestin"); ruRU Timmy "Тайлер" (DB2 "Тимми Беспощадный"; WHT retail
  zegt wél "Тимми Беспощадный"). Regel B is dus gevolgd; of de client dat ook toont, is niet gemeten (staat al
  in `measure` bij Timmy).
- ruRU Jandice: WHT "Джандис Баров", DB2 "Джандис Барова" (staat in de notes, niet in het Lua-commentaar).
- Bij 4 G-namen (esMX Moontouched Wanderer, Tunnelweb Matriarch, Direhorn Matriarch; ptBR Unbound Spirit) staat in
  de tooltip-HTML nog de Engelse naam, terwijl het naamveld vertaald is. Voor Direhorn (esMX) en Unbound Spirit
  (ptBR) is die vertaling gelijk aan DB2 (G), dus dat is goed. Voor de twee rares bestaat geen DB2-rij: niet te
  toetsen.
- Tor'Rel & Izha'Rel: in ruRU kent WHT Izha'Rel wel ("Изха'рел"); de Russische speler krijgt nu de Engelse naam
  "Tor'Rel & Izha'Rel". Staat al als keuze in de notes en in `measure`.

## 2. Id's (allemaal G, 18 nov 2026)

- **Encounters**: DB2 DungeonEncounter Forever 1.60.1.70959, MapID 289 (14 rijen), 329 (19), 2974 (7), 3001 (11).
  Elke `encounter` hoort bij de juiste baas; `encName` klopt voor Kirtonos, Ras Frostwhisperer en Ravasaur Hunters.
  De Blackmaw-rares hebben echt geen rij (de query geeft wel alle 7 bazen = positieve controle).
- **Npc's**: alle 56 npc-id's geven bij WHT Forever de juiste naam; Skul, Forresten, Timmy, Stonespine, de drie
  Blackmaw-rares en King Op = "Rare Elite"; Tor'Rel en Izha'Rel = "Normal"; Blood Steward of Kirtonos (14861) =
  Demon (dus "a demon" bij Kirtonos klopt).
- **Items** (volledige tooltip via `scratch dg_items.py`): alle 15 items hebben de juiste "Dropped by" en de stats
  uit de `role`. Wapentypes kloppen (Bonechill Hammer en Scarlet Malice One-Hand Mace, Skullforge Reaver One-Hand
  Sword, stafen Two-Hand Staff, Tuskblade Two-Hand Polearm, Hammer of Thundering Hooves Two-Hand Mace). Klein (A):
  Robes of Dark Summons heeft ook "+1.8% chance to hit" (geen "with spells"), dat is waarschijnlijk melee-hit; de
  rol caster/healer blijft juist door de +21.

## 3. Hoe kom je binnen

- **Scholomance** (G): Skeleton Key (WHT 13704 "Quest Item, Unique"), Lockpicking 280, Powerful Seaforium Charge
  (Engineering 275), of iemand binnen gebruikt de fakkel: WH Forever (2026/11/06), CQ, FX, LFC, WFG zeggen het
  allemaal. Extra meting (G): DB2 `Lock` Forever rij 1159 = item 13704, lockpicking 280, blasting 300 (dat is een
  Powerful Seaforium Charge). Commentaar in de Lua klopt.
- **Stratholme Service Gate** (G): Key to the City (WHT 12382 "Dropped by: Magistrate Barthilas"); DB2 `Lock` rij
  879 = item 12382, lockpicking 300, blasting 300. Klopt met de Lua. WT(C) voegt toe: de sleutel opent ook de
  Gauntlet-poort en King's Square Gate.
- **Scarlet Bastion-deur** (G voor de data, open voor het spel): DB2 `Lock` rij 299 = The Scarlet Key (7146),
  lockpicking 175, blasting 175 bestaat in Forever. Welke deur die lock gebruikt, staat niet in de client (GameObjects:
  0 rijen voor map 329, zie notes). Forever-sites die het WEL noemen: WT Forever "Stratholme Living" (Classic-basis):
  "someone in your party must have The Scarlet Key ... opens three doors: the Bastion Door, the Hoard Door, and the
  door to the Hall of High Command"; MM(C); wowforever.be (28 okt, Classic-basis); wowforever.ninja ("datamined",
  Lockpicking 175 = gelijk aan mijn DB2-meting). De `measure` bij Willey is terecht. Zie RISICO R2.

## 4. G: paneel-bazen, Nanaya, Ravasaur Hunters

- Kleur ↔ baas (G): WT Forever Shaper's Terrace: rood = Cinder, blauw = Snowtalon (grot achter de linker
  waterval), groen = Vitrix, geel = Bolt (bij Venomridge). CQ (Dmitro, ca. 13 nov): rood, blauw, geel gelijk;
  groen = Vitrix "not confirmed directly". BLZ hotfix 9 nov: "Cinder should now correctly spawn after players use
  the Archival Panel". Lua klopt.
- Nanaya (G): WT: na alle vier panelen de **Titan Panel** op de Pillar of Assimilation gebruiken; Vitrix hoeft
  niet dood. CQ (en gametruth, die volgt CQ): pas na de vier console-bazen. De Lua-tekst "once all four Archival
  Panels have been used" is waar onder beide lezingen: goede keuze. `measure` terecht.
- Volgorde: DB2 OrderIndex 0 ... 8000, Nanaya laatst (G). Lua volgt die exact.
- Ravasaur Hunters (G): twee npc's, Tor'Rel 261811 en Izha'Rel 253218, beide "Normal"; Raptorscale Bulwark
  "Dropped by: Tor'Rel". `npc`/`extraNpc` kloppen. WT: Tor'Rel = vuur, Izha'Rel = ijs met Frost Armor, Tor'Rel
  eerst; bij laag leven komen Ravasaur Stalkers. CQ: niet elite, CC werkt. Tekst klopt, op één zin na (FOUT 1).

## 5. Bevindingen

### FOUT

**F1. Tor'Rel & Izha'Rel, `does[1]`: "Two raptors fought together; they are not elite."** (G)
Verleden tijd: leest als "twee raptors vochten samen". En het staat bijna letterlijk in CQ's tabel ("A pair fought
together", conquestcapped Shaper's Terrace, ca. 13 nov 2026).
Reparatie: `"You fight two raptors at the same time; they are not elite."`

### RISICO (twijfel; met reparatie)

**R1. Scholomance: de speler hoort nergens dat hij een sleutel nodig heeft.** (G: grep `enUS.lua` en `Modules/` op
"Skeleton": 0 treffers; positieve controle in dezelfde zoektocht: "Key to the City" wel gevonden, FDG_STRAT_17_D1.)
Het staat alleen in Lua-commentaar. Zonder sleutel, rogue of engineer staat een groep voor een dichte deur.
Reparatie: een regel op dungeonniveau (nieuw veld, bv. `entry`), of anders bij Kirtonos vooraan:
`"The door to the portal is locked: one player needs the Skeleton Key (quest chain The Key to Scholomance), or bring a rogue with Lockpicking 280 or a Powerful Seaforium Charge."`
Bronnen: WH 2026/11/06, CQ 7 nov, FX 13 nov, LFC; DB2 Lock 1159 (G).

**R2. Stratholme Main Gate: de Bastion-deur staat alleen in `measure`.** (G) Klopt Classic ook in Forever, dan
stopt een groep zonder The Scarlet Key of rogue bij Crusaders' Square: Malor, Hammersmith, Willey, Galford en
Balnazzar zijn dan onbereikbaar. De Lua-zin "Geen Forever-gids noemt het" is te stellig: WT Forever, MM, wowforever.be
en wowforever.ninja noemen het wel (allemaal op Classic gebaseerd). Reparatie: een voorzichtige regel bij Timmy
(de laatste baas vóór de deur), naast de bestaande `measure`:
`"In Classic the Scarlet Bastion door needs The Scarlet Key from the Scarlet Monastery Library, or a rogue's Lockpicking; bring one to be safe."`

**R3. Nanaya, tip "Resistance gear helps ..." heeft maar één bron.** (G) `src` zegt "2x CQ+WT", maar WT geeft geen
weerstandsadvies; WT zegt: "None of the mechanics are particularly dangerous" en noemt alleen de elementen per
kristalkleur. Alleen CQ zegt "the resistances that helped on the console bosses help again here" (gametruth en
apocanow volgen CQ). Reparatie: `one = true` bij Nanaya en `src` "weerstand 1x CQ (WT: alleen elementen)".

**R4. Nanaya, `does[1]`: wat moet je klikken?** (G) WT: "interact with the Titan Panel there". Reparatie:
`"The last boss: once all four Archival Panels have been used, click the Titan Panel at the pillar in the middle to call her."`

**R5. Ramstein, `src` "golf + wachters 2x CQ+WFG" klopt niet voor CQ.** (G) CQ (Kir, 7 nov) zet het andersom:
"When the slaughterhouse gate opens, waves of Mindless Undead rush out ... Ramstein the Gorger follows". WT(C) en
WFG (9 nov) geven de volgorde van de Lua (abominaties → Ramstein → golf → Black Guards). De tekst is dus goed;
alleen de bronregel moet zijn: "golf + wachters 2x WFG+WT(C); CQ zegt de golf vóór Ramstein".

**R6. Postmaster Malown, "ghost postmen jump out of each".** (G) Alleen WT(C) zegt "Opening the Postbox will also
spawn three Undead Postman ... When you open the third Postbox, you will also spawn Postmaster Malown". WH (4 nov)
en FX zeggen alleen dat de drie postmannen samen met Malown bij de derde bus komen; CQ noemt geen postmannen
(`src` noemt CQ wel). Reparatie (veilig voor beide): `"Optional: open three postboxes with keys from the Stratholme Courier; Malown comes out of the third, with ghost postmen."`
en `src` aanpassen.

**R7. Malor the Zealous, tip "Interrupt every heal he starts."** (G) FX: zijn volle heal (Lay on Hands) "You can't
prevent it"; alleen Holy Light is te onderbreken. Reparatie:
`"Interrupt his heals; his one full heal near death cannot be stopped, so save your big damage for after it."`

**R8. The Unforgiven: `optional` niet gezet, maar twee bronnen zeggen optioneel.** (G) WH (4 nov): "Some of the
optional bosses, like Ezra Grimm and The Unforgiven, your group may choose to skip"; wowforeveraddon.com: "Hearthsinger
Forresten, Skul, The Unforgiven, Postmaster Malown and the Crimson Hammersmith are optional". De notes zeggen "alleen
WH". Reparatie: `optional = true` (dan ook "Optional:" vooraan in `does[1]`), of in de notes zeggen waarom niet.

**R9. Malor the Zealous: `optional = true`, maar wowforeveraddon.com telt hem als gewone baas.** (G) Zelfde lijst als
R8: Malor staat er NIET bij de optionele. Steun voor optioneel: MM(C) + FDJ. Geen fout, wel tegenstrijdig; noteren of
`measure` maken.

**R10. Instructor Malicia: "A priestess who heals herself".** (A) Geen bron noemt haar een priesteres: WH noemt
Corruption, Call of the Grave, Heal, Renew, Slow; WT(C) "a heavy magic user". Reparatie:
`"A caster who heals herself, slows the tank and hurts players over time."`

**R11. Scholomance-volgorde wijkt op één plek af van wat het commentaar zegt.** (G) Commentaar: "Volgorde = DB2
OrderIndex". DB2: Kormok −46, Ras −31; de Lua zet Ras vóór Kormok. Inhoudelijk logisch (Kormok wordt in Ras' kamer
opgeroepen), maar dan het commentaar aanpassen: "OrderIndex, behalve Kormok na Ras (opgeroepen in zijn kamer)".
De notes zeggen ook dat OrderIndex "samenvalt met de route": dat klopt hier net niet.

**R12. Blackmaw Behemoth, fase 2 ontbreekt half.** (G) WT: na het opeten van Clawbert krijgt hij "Thunder Roar,
stunning everyone in a wide area. Interrupt that one as well". MOBU (16 nov): de brul en de wervelwind worden
"empowered when he enrages". Dus "hits harder" klopt, maar de stun-brul is met WT + MOBU half gedekt. Voorstel
`does[3]`: `"When the small furbolg is gone, the Behemoth heals to full, hits harder, and his roar then stuns everyone near him."`
(tip "interrupt the Behemoth's roar" dekt dan beide brullen).

**R13. King Op, tip "pull it on its own" heeft geen bron.** (G: WT en CQ noemen hem niet.) Algemeen advies, geen
mechaniek, maar de regel doet alsof. Reparatie: `"No tactics are known yet."` (of zo laten met `one = true`, staat al).

**Observatie (geen RISICO, telt niet mee).** DB2 (G, betekenis A): in Blackmaw delen bazen hun `Bit`: Withermaw + Impaan = 0, Bonesnout + Bloodmane = 1,
Behemoth + Varrox = 2, Unbound Spirit = 3. In Shaper's heeft elke baas een eigen Bit. Wat dat in het spel doet
(lockout per paar?) is niet bekend; ik zou het alleen noteren voor de recheck.

### Gecontroleerd en goed (steekproef tegen de bron zelf, G)

- Scholomance, elke `does`/`tip` tegen WH Forever (6 nov, volledig gelezen) en WT(C): Kirtonos (brazier op het
  balkon, twee vormen, knockback in gargoyle-vorm: WT(C) "Wing Flap knockback ... Swoop"), Jandice (fakkel zuidmuur:
  WH en WT letterlijk), Rattlegore, Marduk (schild doet pijn: WH), Vectus, Ras (Keepsake), Kormok, de zes leraren
  (verdiepingen kloppen: WH Ravenian/Illucia "Lower Level"), Krastinov-enrage, Alexei (twee wachters, Veil of Shadow),
  Gandling. Geen inhoudelijke fout buiten R10.
- Stratholme tegen WH Forever Live (4 nov), FX (17 nov), CQ (7 nov), WT(C) Living/Undead, WFG Service Gate (9 nov):
  Ezra (tabaksdoos, Flame Breath, Smoke Bomb), Skul, Forresten, Timmy, Willey (kogels in de kamer, interrupt),
  Galford (Burning Winds, tank-wissel), Balnazzar (rond de helft), Barthilas (WT(C): "his original spot in front of
  Alonsus Chapel ... Opening the Service Gate Entrance is what triggers him to take off"; WFG: naar de voorkant van
  Slaughter Square), ziggurats + Acolytes, Anastari (halve health), Maleki, Rivendare (45 min, Gauntlet). Goed.
- BLZ-hotfixregels (G): 9 nov "Fixed an issue that allowed players to mount inside Stratholme" en "Cinder should
  now correctly spawn after players use the Archival Panel"; 13 nov Balnazzar → Master Spelunker. Kloppen.
  Hotfixes 16 en 17 nov gelezen: niets nieuws over deze vier dungeons (wel "Cloak of the Fleshborer had no texture").
- Blackmaw tegen WT, MOBU (16 nov) en MMN (17 nov): Withermaw (maden, fear), Impaan (heuvelpad, imps), Bonesnout
  (25% per ritualist: WT + DBS 1277406 "per stack"), Unbound Spirit (MOBU: "adds will spawn that try to kill the
  npc"), Bloodmane, Varrox (WT + MOBU + DBS 1246453/1246362). Goed.
- Shaper's tegen WT en CQ: Titanosaur, Thunderhoof, Venomridge (Alliance-quest Panic at the Digsite), Direhorn
  (zijkant, niet achter), Cinder (CQ "fire raptor"), Snowtalon, Bolt, Vitrix. Goed.

## 6. Na mijn oordeel: de notes gelezen

- **Wat de notes al hadden en ik ook vond**: Timmy ruRU, Kirtonos/Ras-namen, Bastion-sleutel als `measure`, Mopes
  bewust weggelaten (alleen MMN), Behemoth-stunbrul bewust weggelaten ("alleen WT"; MOBU dekt het half, zie R12),
  Vitrix/Nanaya-tegenspraak, Tor'Rel-naamkeuze, de Engelse extra regel in de esMX/ptBR-tooltips.
- **Wat in de notes staat en ik niet had**: GameObjects-DB2 heeft 0 rijen voor map 289/329 (verklaart waarom de
  deuren niet te meten zijn); Ezra Grimm heeft nieuwe Forever-buit (276394-276396, alleen WHT + FDJ, terecht niet
  opgenomen); Deathcharger's Reins zonder "Dropped by". Niets daarvan verandert een bevinding.
- **Wat de notes missen** (staat hierboven): de Lock-DB2-meting (299/879/1159); WFA als tweede bron voor "Unforgiven
  optioneel" (R8) en de tegenspraak over Malor (R9); dat Ras/Kormok niet de OrderIndex volgen (R11); de drie
  `src`-regels die een bron noemen die het niet zegt (R3, R5, R6); de LoH-nuance bij Malor (R7); de tekstfout F1;
  en dat de speler de Skeleton Key nergens te zien krijgt (R1).

## Bronnen (alle gelezen 18 nov 2026)

- DB2 wago.tools Forever 1.60.1.70959: DungeonEncounter (enUS, deDE, ruRU, esMX, ptBR), Spell (9 id's), Lock.
- WHT nether.wowhead.com/forever/tooltip: 56 npc's × 7 talen, 15 items + 3 sleutels; ter vergelijking /classic
  (ruRU, deDE, frFR) en retail (ruRU 10808).
- Wowhead Forever: Scholomance (Updated 2026/11/06), Stratholme Live Side (Updated 2026/11/04).
- Warcraft Tavern Forever (Luxrah): Scholomance, Stratholme Living, Stratholme Undead (alle drie "based on WoW
  Classic"), Blackmaw Hold, Shaper's Terrace.
- Mobalytics: Blackmaw Hold Complete Dungeon Guide (Uncas, Updated Nov 16, 2026); Stratholme Live (highlights).
- mmonerds Blackmaw (Updated Nov 17 2026); conquestcapped Scholomance + Stratholme (Kir, 7 nov), Blackmaw (8 nov),
  Shaper's Terrace (Dmitro, toont 05 nov, tekst "nine days later"); wowforeverguides Scholomance + Service Gate
  (Updated Nov 9, 2026); fextralife Strat Main Gate ("last edited 17 November 2026") en Scholomance;
  wowforeveraddon.com Main Gate + Service Gate (geen datum); wowforever.ninja (Scarlet Key, geen datum);
  wowforever.be Strat Living (28 okt); gametruth (13 nov); wythic (geen datum).
- Blizzard news: WoW: Forever Hotfixes, versie 17 nov 2026 (bevat 9, 10, 11, 13, 16, 17 nov).
