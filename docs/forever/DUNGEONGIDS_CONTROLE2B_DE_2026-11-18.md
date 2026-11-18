# Controle stap 2b, deel D + E (18 nov 2026)

Gecontroleerd: `dg2b_D.lua` (Sunken Temple 109, Blackrock Depths 230) en `dg2b_E.lua` (Dire Maul 429 East/North/West,
Blackrock Spire 229 Lower/Upper). Code niet bekeken (hoefde niet). Repo niet aangeraakt, geen `probe_job.txt`.
GEMETEN = gezien in een genoemde bron met datum. AFGELEID = mijn redenering. `_notes.md` pas gelezen NA dit oordeel.

## Uitkomst

**1 FOUT, 11 RISICO** (waarvan 4 laag). Id's, encounters, buit en namen: geen fouten gevonden.

Bronnen die ik zelf las (alle 18 nov 2026):
- WHT = Wowhead Forever tooltip-JSON via `run gamedata npc/item ... --game forever [--locale]`; WHTC = idem `--game classic`.
- DB2 = wago.tools DungeonEncounter, build 1.60.1.70959 (Forever), enUS/deDE/ruRU/esMX.
- WH = Wowhead Forever-gidsen (volledige tekst via Exa): Warpwood Quarter, Capital Gardens, Gordoks Commons, BRD,
  Temple of Atal'Hakkar ("Updated: 2026/11/04"); LBRS, UBRS ("Updated: 2026/11/06"); Sunken Temple Class Quests
  (Serenal, "Updated: 2026/11/16").
- CQ = conquestcapped Blackrock Depths ("Updated 17 Nov 2026"), plus CQ-zoekfragmenten Dire Maul en UBRS.
- WTC = Warcraft Tavern Forever BRD en DM West (Classic-gebaseerd, zeggen ze zelf); WMC = warcraftmaps BRD (Classic).

---

## FOUT

### F1. Dire Maul North, Guard Mol'dar + tribute run: de binnendeur zit dicht
- Nu: Mol'dar "Drops the key to the inner door further on." en "Tribute run: leave him alive and walk past him."
  Nergens staat hoe een tribute-groep dan door die deur komt.
- Bewijs (GEMETEN): WH Gordoks Commons (4 nov 2026): Mol'dar "drops Gordok Inner Door Key, required to get to the final
  part of Dire Maul North. Rogues can Pick Lock the door (300 Lockpicking required), Engineers can open the door with
  Large Seaforium Charge, and Blacksmiths can open the door with Truesilver Skeleton Key." Tweede bron: wowforeverguides
  (8 nov) citeert WTC met dezelfde drie manieren (Lockpicking 300, een Seaforium Charge, Truesilver Skeleton Key).
- Gevolg (AFGELEID): een groep die de gids volgt, staat zonder sleutel voor de deur naar Kromcrush.
- Reparatie, Mol'dar regel 3:
  `"Tribute run: leave him alive; then a rogue, an engineer or a blacksmith must open the inner door without his key."`
  src: `tribute + binnendeur 2x WH+WTC (via wowforeverguides)`.

---

## RISICO

### R1. King Gordok: de klik-stap (Mizzle) ontbreekt
- Nu: "the ogres crown you, the guards give buffs and a tribute chest appears." Dat klinkt alsof het vanzelf gaat.
- GEMETEN: WH Gordoks Commons: na Gordoks dood "talk to Mizzle the Crafty ... Mizzle will coronate your entire group
  ... and spawn a Gordok Tribute"; buffs: "talk to each Guard you kept alive". CQ Dire Maul: "Kill King Gordok, leave
  Cho'Rush the Observer alive, then talk to Mizzle the Crafty."
- Reparatie, regel 2 en 3:
  `"Kill only him and leave every named ogre alive (a tribute run), then talk to Mizzle the Crafty: he crowns the group and the tribute chest appears."`
  `"Talk to each guard still alive for a buff; the more guards alive, the better that chest."`

### R2. Upper Blackrock Spire: de runen-hal voor Emberseer ontbreekt
- Nu: deur + Seal of Ascension, daarna meteen "Start the fight at the altar in his hall".
- GEMETEN: WH UBRS (6 nov): "After extinguishing each of the seven runes located within each alcove, the doors ... will
  open up into a small hallway. This hallway will lead to the Hall of Binding." CQ UBRS: "a hall with side chambers,
  each lit by a glowing rune: kill the pack in every chamber, the runes fade and the double door at the back opens to
  Pyroguard Emberseer." Twee Forever-bronnen.
- Reparatie (3 regels; geen "seven": dat getal staat alleen in WH):
  `"Upper Spire's door only opens if someone in the group carries the Seal of Ascension, from a quest chain that starts in Lower Spire."`
  `"In the first hall, kill the pack in every side room; when all the runes go dark, the door to his hall opens."`
  `"Start the fight at the altar: weak jailers come first, then he breaks free and pulses fire around himself."`

### R3. "Seal of Ascension, a quest from Lower Spire" is te kort door de bocht
- GEMETEN: WH LBRS (6 nov): de keten begint met een Unadorned Seal of Ascension van trash, dan Vaelan, drie edelstenen
  (Omokk, Voone, Wyrmthalak), en het smeden gebeurt bij de draak Emberstrife in Dustwallow Marsh. CQ UBRS: "the two
  Seal of Ascension quests that Vaelan gives inside Lower Blackrock Spire".
- Reparatie: "a quest chain that starts in Lower Spire" (al in R2 verwerkt).

### R4. Urok Doomhowl: waar komt de piek vandaan, en tekst dicht bij WH
- Nu: "put Omokk's head on a pike at the pile of ogre heads". Dat je de Roughshod Pike eerst moet oppakken staat er niet.
  Tip "Click the pike about every 30 seconds to kill one ogre at once": WH zegt "click on the pike while targeting an
  ogre". Regel 2 "Waves of elite ogres come first, then Urok" ligt dicht bij WH "many waves of elite ogres will appear
  first, before Urok himself".
- GEMETEN: WH LBRS: Roughshod Pike oppakken bij de brug, "Combine your Omokk's Head with Roughshod Pike and place it on
  the Tribute Pile". (Plek van de piek: alleen WH gezien, daarom niet in de tekst.)
- Reparatie:
  `"Optional: needs the quest from Warosh. Loot Omokk's head and a Roughshod Pike earlier in the dungeon, join them, and set them on the pile of ogre heads."`
  `"Elite ogres attack in waves before Urok himself shows up; he fears the players around him."`
  tip: `"Target an ogre and click the pike to kill it at once (about every 30 seconds); crowd-control the rest."`

### R5. The Vault (Watchman Doomgrip): regel 2 bijna letterlijk WH, regel 3 dicht bij CQ
- WH BRD: "the stone guardians in the room will come alive and Watchman Doomgrip will spawn". Data: "Then the stone
  guardians in the room come alive and Watchman Doomgrip appears." CQ: "kill them to open the Secret Safe and reach The
  Heart of the Mountain"; data: "Beat them all to open the Secret Safe: loot and the Heart of the Mountain for a quest."
- Inhoud klopt (GEMETEN WH + CQ). Reparatie:
  `"The stone statues in the vault then wake up and attack, together with Watchman Doomgrip."`
  `"When the last one falls, you can reach the Secret Safe: loot, plus the Heart of the Mountain that a quest asks for."`

### R6. Immol'thar: regel 2 + tip dicht bij CQ
- CQ Dire Maul: "he keeps summoning eyes around the room, so assign one ranged player to kill them". Data: "Keeps
  calling eyes around the room ..." en tip "Give one ranged player the job of killing the eyes".
- Inhoud klopt (GEMETEN WH Capital Gardens + CQ). Reparatie:
  `"Eyes keep popping up along the walls; he also pulls players to the middle of the room, and a tank pulled away loses him."`
  tip: `"One ranged player hunts the eyes the whole fight; healer, save cooldowns for the second half."`

### R7. Avatar of Hakkar: wat je met het bloed doet
- Nu: "every Hakkari Bloodkeeper among them drops blood, and each blood douses one of the four flames." Dat de speler
  het bloed moet looten en op een vlam moet gebruiken, staat er niet.
- GEMETEN: WH Temple of Atal'Hakkar: "Kill it and grab the Hakkari Blood from the corpse ... Using the blood, you can
  extinguish one of the four braziers."
- Reparatie, regel 2:
  `"Waves of enemies come; loot the blood from each Hakkari Bloodkeeper and use it on one of the four flames. The Avatar arrives once all four are out."`

### R8. src-labels kloppen niet bij twee regels (inhoud wel goed)
- Ring of Law "Entering the arena locks the gate behind you": src zegt `2x WH+CQ`, maar WH en CQ zeggen dat NIET.
  GEMETEN in WTC BRD ("with the gate closing behind you") en WMC ("You step in, the gates close") = twee Classic-bronnen;
  WH/CQ spreken het niet tegen. Reparatie src: `poort dicht 2x WTC+WMC (Classic; WH/CQ niet tegen)`.
- Lord Roccor "walks the ring": WH zegt alleen dat hij in de tweede ring staat; "patrols the northeastern ring" staat in
  WTC (Classic). Reparatie src: `loopt rond 1x WTC (Classic) + plek WH`; of "walks" weglaten: `"An earth elemental in the ring corridor around the Ring of Law; an easy fight."`

### R9 (laag). Guard Mol'dar deDE: data en notes zeggen iets anders
- GEMETEN: WHT Forever deDE = "Wache  Mol'dar" met TWEE spaties; WHTC (Classic) ook twee. In `dg2b_E.lua` staat EEN
  spatie (Grep: "Wache  Mol" = 0 treffers, "Wache Mol'dar" = 1). De notes zeggen "zo letterlijk overgenomen".
- AFGELEID: `names` wordt alleen getoond (`ForeverDungeonGuide.lua` r.104), niet vergeleken; een spatie leest beter.
  Reparatie: kies bewust; voorstel: een spatie laten staan en de notes + het commentaar in de lua rechtzetten.

### R10 (laag). Quartermaster Zigris "Waits in the storehouse"
- GEMETEN: WH LBRS: "you'll find Quartermaster Zigris patrolling the room". Reparatie: `"In the storehouse; he walks around the room."`

### R11 (laag). Plugger Spazzring: ook mokken pakken maakt hem boos
- Nu: "he only fights if you start it". GEMETEN (alleen WH BRD): hij wordt ook vijandig "if you loot too many mugs on
  his table, or if a Rogue pickpockets him". Een bron, dus alleen als suggestie:
  `"Optional: he only fights if you start it (taking too many mugs from his table counts), and then the whole bar fights too."`

---

## (1) Namen per taal: steekproef (Rob "B" = naamplaatje)

GEMETEN, WHT Forever 18 nov 2026, `run gamedata npc ... --game forever --locale xx`. **116 naam-vergelijkingen, 0 fout.**

| taal | aantal | voorbeelden die klopten |
|---|---|---|
| deDE | 30 | Traumsense, Wirker, Verhörmeisterin Gerstahn, Pyromant Weisenkorn, Hurley Pestatem, Wachmann Stahlgriff, Captain Kromcrush, Zevrim Dornhuf, Goraluk Hammerbruch, Jed Runenblick |
| frFR | 31 | Cho'Rush l'Observateur, Tendris Crochebois, Pyrogarde Prophète ardent, Chef de guerre Rend Blackhand, Matriarche Couveuse, Grand Interrogateur Gerstahn, Phalange, Sentinelle Doomgrip |
| ruRU | 21 | Солакарский огнечервь, Ткачик, Бессмер'тер, Точень Темнострой, Аррок Смертный Вопль, Капитан Давигром, Пиростраж Созерцатель Углей, Бейл'Гор |
| ptBR | 14 | Darquimeros, Ez'Magg, o Observador, Capitão Kebrapaw, Guarda Kishutt, Birra Guardachave, Vulto de Erânicos, Ribas Parafuseta |
| esMX | 12 | Tendris Alabeo, Bannok Hacha Macabra, Jed Vigía de las Runas, Piroguardia Brasadivino, Segasueños; 9476 = "[Watchman Doomgrip]" -> `nil` klopt |
| esES | 10 | Jefe de Guerra Desgarro Puño Negro, Piroguardián brasadivino, Guadañasueños, Piromántico Cultugrano, Magister Kalendris |

- Groepsnamen uit DB2 (GEMETEN): 2954 deDE "Verteidiger der Atal'ai", esMX "Defensores de Atal'ai", ruRU "Защитники
  Атал'ай"; 230 deDE "Ring des Gesetzes", ruRU "Зал Правосудия", esMX "Círculo de la Ley"; 243 deDE "Die Sieben",
  esMX "Los siete", ruRU "Семеро". Alle gelijk aan de data.
- Engelse namen in deDE/frFR (Captain Kromcrush, Fineous Darkvire, Ribbly Screwspigot): GEMETEN dat Wowhead CLASSIC
  deDE precies hetzelfde toont (ook "Wache  Mol'dar" met twee spaties). Dus geen Forever-terugval van Wowhead, maar de
  oude servernaam. Geen actie.

## (2) Id's, encounters, buit

- Alle npc-id's in D en E (bazen, extraNpc, de zes trollen, de zes Ring of Law-bazen, de zeven geesten, Pimgib, Ferra,
  Gyth, Verek, Ogom) = juiste naam in WHT Forever (GEMETEN).
- Alle encounter-id's (ST 3582-3589 + encounterAlt 486-493/2814; BRD 227-244, 2789-2791; DM 343-368, 2792, 2794;
  BRS 267-275, 3062-3069) = juiste naam in DB2 Forever (GEMETEN). 2954 bestaat alleen met DifficultyID 215 (GEMETEN).
- Buit, 21 items: naam, stats, wapentype en "Dropped by" GEMETEN (dg_items.py). Alle boss-id's kloppen (o.a. Fist of the
  Damned = Ogom, Hand of Justice = Emperor, Flaming Band = Emberseer). Main Hand / One-Hand / Two-Hand klopt overal.
  Rollen passen bij de stats (AFGELEID).

## (3) Groepsgevechten (wat moet de speler doen?)

- **Atal'ai Defenders**: klopt. WH Temple (4 nov): zes mini-bazen elk op een balkon, alle zes dood = weg naar
  Jammal'an; Greater Healing Ward, Skeleton Summoning Totem, demonen. Namen/id's goed.
- **Ring of Law**: klopt. WH + CQ: Roccor en Grebmar eerst, twee golven, dan een van zes willekeurige bazen; daarna de
  tweede poort naar de East Garrison. Zie R8 voor de src.
- **The Seven**: klopt. CQ: "Talk to Doom'rel in the Summoners' Tomb and seven ghosts attack one by one"; WH: timer,
  klasse per geest, Chest of The Seven.
- **The Vault / Doomgrip**: klopt (twaalf Relic Coffers, sleutels van Dark Iron-dwergen: CQ; daarna stenen wachters +
  Doomgrip, Secret Safe + Heart of the Mountain: WH, CQ). Alleen te dicht bij de tekst: R5.
- **Cho'Rush + King Gordok**: gevecht klopt (WH: tribute = Cho'Rush levend houden, offtanken, onderbreken; hij wordt
  vriendelijk na Gordoks dood). Klik-stap Mizzle ontbreekt: R1; binnendeur: F1.

## (4) Vleugels en deuren openen

- **DM**: Crescent Key van Pusillin (WH East: "grant you access to the other Dire Maul instances"; WH West: nodig voor
  de deur naar Immol'thar; WTC West: nodig voor de ingang) = klopt. Old Ironbark na Zevrim = klopt (WH). Vijf pylonen
  = klopt (WH, CQ, WTC). Gordok Courtyard Key in Fengus' kist = klopt (WH). Binnendeur bij tribute: **F1**.
- **BRS**: Seal of Ascension = klopt (WH dungeon-overzicht + CQ). Runen-hal ontbreekt: **R2**; keten: **R3**;
  Urok-piek: **R4**. Solakar via Father Flame = klopt (WH).
- **BRD**: Prison Cell Key (Gerstahn), Ironfel op het monument in de Shrine of Thaurissan (CQ letterlijk die naam),
  Rocknot + ale -> deur + Phalanx, fakkels op twee bekkens voor Magmus, Magmus bewaakt de deur naar de troonzaal (CQ):
  alles klopt.
- **ST**: zes schreinen S, N, ZW, ZO, NW, NO (WH) = klopt; barrière Jammal'an = klopt; Egg of Hakkar uit de Tanaris-keten
  of daarna Yeh'kinya's Scroll, kamer ten westen van de Pit of Sacrifice (WH) = klopt. Morphaz-buit voor Hunter, Mage,
  Priest, Rogue = klopt (WH Class Quests 16 nov: Tooth of Morphaz, Arcane Shard, Blood of Morphaz, Azure Key).

## Overig, geen actie (ter info)

- WH BRD noemt ook Roccor, Grebmar, Fineous, Bael'Gar, Incendius, Angerforge en Argelmach "optional"; de data niet.
  De notes leggen uit waarom (regel: twee bronnen). Akkoord.
- Generieke tips die op WH lijken maar nauwelijks anders kunnen (The Seven "kill each fast", Flamelash "kill the
  spirits before they reach him"): laten staan.

## Na het lezen van de notes (dg2b_D_notes.md, dg2b_E_notes.md)

- De notes noemen F1, R1, R2, R3, R4, R5, R6 en R7 niet. Die mis ik dus ook bij de onderzoekers.
- R9: de E-notes zeggen "Wache  Mol'dar ... zo letterlijk overgenomen", maar de lua heeft een spatie.
- Wat de notes wel hebben en ik bevestig: Tsu'zee-rare twijfel, Loregrain/Stilgiss rare-vraag, Cho'Rush/Gordok twee
  DB2-rijen, verschillen naamplaatje vs DB2 (ik vond geen nieuwe), Rend-start verschilt per bron (terecht weggelaten).
- Niets in de notes wat ik anders zou beoordelen.
