# Tweede controle, bazengids Forever stap 2a, deel A (18 nov 2026)

Gecontroleerd: `dg2a_A.lua` (Gnomeregan 90, Razorfen Kraul 47, Scarlet Monastery 189, Razorfen Downs 129), de
gegenereerde `Modules\ForeverDungeonGuideData.lua` (alleen deze vier kaarten), de `FDG_*`/`FDGP_*`-regels in
`Locales\enUS.lua` en de code `Modules\ForeverDungeonGuide.lua` (punt 4 van de brief). Repo niet aangeraakt,
`probe_job.txt` niet gebruikt. G = GEMETEN (gezien in een genoemde bron, datum erbij), A = AFGELEID.
Eigen oordeel eerst; `dg2a_A_notes.md` pas daarna gelezen (laatste kop).

**Uitkomst: 0 FOUT, 11 RISICO** (3 belangrijk, 8 klein). Code: geen fout gevonden.

## Bronnen die ik zelf las (18 nov 2026)

- DB2: wago.tools `DungeonEncounter` Forever 1.60.1.70959, enUS + deDE/frFR/esES/esMX/ptBR/ruRU/itIT; ter
  vergelijking Classic Era 1.15.9.70576 (frFR); `Creature` Forever (189 rijen, G).
- WHT: Wowhead-tooltip `--game forever` voor alle 32 npc's (6 talen) en alle 21 items (volledige tooltip met
  "Dropped by"); ter vergelijking `--game classic` en `--game retail` (frFR, 5 npc's).
- IV: Icy Veins Forever (Neryssa) Gnomeregan (Last Updated 18 okt, changelog 21 okt), RFK (18 okt), SM Graveyard
  (18 okt), SM Library (18 okt), SM Armory (17 nov), SM Cathedral (17 nov).
- WH: Wowhead Forever RFK (Paryah, 2026/11/09), SM Library (Jurdi, 2026/11/10), SM Cathedral (Paryah, 2026/11/10),
  RFD (Nodge, 2026/11/14) — via Exa.
- WT: Warcraft Tavern Forever (Luxrah) Gnomeregan, RFK, SM-overzicht, SM Graveyard, SM Library, RFD; geen datum.
- MOB: Mobalytics Gnomeregan (PhaseShifter, 16 nov), RFK (Ruse_Cruize, 5 nov).
- CQ: conquestcapped Gnomeregan (Kir, "Updated 07 Nov 2026") en Scarlet Monastery (Kir, "Updated 07 Nov 2026").
- HP: hearthproof SM Cathedral (v1.7, "Compiled Nov 16 2026"), SM Library, SM Armory.
- Verder: MG (method.gg Gnomeregan en RFK, Jurdi, geen datum), UGT (urgametips Gnomeregan), WFDB (zoekfragmenten),
  WFG (wowforeverguides RFK 3 okt; citeert WH), azeroth.wiki/forever RFD (geen datum), foreverdb.net RFD (zegt zelf
  "Classic strategy, not yet checked against Forever").
- FDJ: `ForeverDungeonJournal\Data\DropRates.lua` (killtellingen "on Wowhead Forever"),
  `Localization\Content_Verified.lua` (kop r.4-7: neemt Wowhead-Forever-namen over, dus geen eigen bron).

## Id's en namen — alles klopt (G)

- **Encounters (G, DB2 Forever):** 2768-2772 Gnomeregan, 2773-2778 RFK, 444/2779/446/447/448/449/450 SM,
  2780-2785 RFD: elke id hoort bij de juiste baas en kaart. Geen rij voor Mograine: `Name_lang~Mograine` vindt alleen
  "Spirit of Mograine" (3296, kaart 2921) = positieve controle; ID 445 bestaat niet (444 wel, zelfde run).
- **Npc's (G, WHT Forever):** alle 32 id's (incl. Chomper 6215, Beast Elite, zone 721) hebben de juiste naam en zone.
  Rares (6228, 4842, 4425, 6490, 6488, 6489) = "Rare Elite"; Ragglesnout 7354 = "Elite" (zoals de data zegt).
- **Items (G, WHT Forever, volledige tooltip):** alle 21 item-id's, namen, "Dropped by" en de stats in de rol-teksten
  kloppen. Wapentypes: Hand of Righteousness = Main Hand (klopt), Glutton's Cleaver = One-Hand (klopt), Illusionary
  Rod +44 spell power (plus +1% crit), Loksey's Training Stick +28 AP, Mograine's Might +8 Str/+16 Int, Aegis 1548
  armor (Heart of Agamaggan ilvl 35 heeft 757: "extra armor" klopt, A).
- **Namen per taal (G):** alle 24 DB2-namen in `names` = DB2 per locale (deDE, frFR, esES, esMX, ptBR, ruRU), ook de
  ruRU-aanhalingstekens. De 7 namen zonder DB2-rij = WHT per locale. itIT in Forever-DB2 = Engels (G), dus de
  Engelse terugval voor itIT is juist. Maar zie RISICO 1.
- **enUS en de gegenereerde data (G):** alle FDG_GNOMER/RFK/SM/RFD-sleutels en de 4 FDGP-sleutels staan in
  `enUS.lua` met precies de tekst uit `dg2a_A.lua`; npc/encounter/rare/optional/extraNpc/part/loot in
  `ForeverDungeonGuideData.lua` gelijk aan `dg2a_A.lua`.
- **Syntax (G):** `luac -p` op `ForeverDungeonGuide.lua` en `ForeverDungeonGuideData.lua`: rc 0; positieve controle
  `dg2a_C_luac_negtest.lua`: rc 1 "'}' expected".

## RISICO's (belangrijkste eerst)

### RISICO 1 — DB2-encounternaam ≠ naam boven het npc (frFR, deDE, esES, ruRU) — raakt ook stap 1

G (DB2 Forever 70959 tegen WHT Forever, 18 nov). Waar ze verschillen (DB2 → WHT-npc):

- **frFR:** Interrogateur Vislar → Interrogateur Vishas · Disperseur de foule 9-60 → Faucheur de foule 9-60 ·
  Mekgénieur Thermojoncteur → Mekgénieur Thermaplugg · Aggem Malépine → Aggem Mantépine · Agathelos le Déchaîné →
  Agathelos l'Enragé · Hérode → Herod · Grande inquisitrice Blanchetête → Grand Inquisiteur Whitemane ·
  kleine verschillen: Électrocuteur/Electrocuteur, Grand inquisiteur/Grand Inquisiteur Fairbanks,
  Œil-de-Feu/Oeil-de-feu, Porte-Froid/Porte-froid, Tuten’kash/Tuten'kash.
- **deDE:** Charlga Klingenflanke → Charlga Razorflank · Hochinquisitor Schönufer → Hochinquisitor Fairbanks ·
  Hochinquisitorin Weißsträhne → Hochinquisitor Whitemane.
- **esES:** Portavoz de la muerte Jargba → Médium Jargba · Faucepeste el Podrido → Fauzpeste el Putrefacto.
  (esMX: gelijk aan DB2, G voor deze 6 npc's.)
- **ruRU:** "Электрошокер-6000" → Электрошокер 6000 · "Толпогон 9-60" → Толпогон 9-60 · Анжинер → Мекжинер
  Термоштепсель · Властитель Злоклык → Властитель Таранный Клык · Волшебник крови → Волшебник Крови Талнос ·
  Ирод → Герод.
- **ptBR:** geen verschil (alle 24 G).

Patroon (G): WHT-Forever frFR = WHT-Classic frFR (5 npc's), en Classic Era DB2 frFR = Forever DB2 frFR (7 rijen);
WHT-retail frFR = de DB2-namen. A: Forever gebruikt voor het npc (doelwitframe, naamplaatje) waarschijnlijk de oude
Classic-namen, terwijl `DungeonEncounter` de latere namen heeft. Een Franse speler ziet dan "Interrogateur Vishas"
boven zijn doelwit en "Interrogateur Vislar" in MH. Niet in het spel gemeten (Rob speelt enUS).
Reparatie (Rob kiest): (a) DB2 houden (huidige regel "Blizzard-data"), (b) bij verschil de npc-naam tonen (dat is wat
de speler target), of (c) beide: "Interrogateur Vishas (Vislar)". Meten kan alleen met een fr/de/es/ru-client:
target Vishas/Fairbanks en vergelijk. Geldt ook voor de stap-1-dungeons; de notes keken alleen deDE na.

### RISICO 2 — Arcanist Doan: "Now and then he starts a huge blast" (FDG_SM_7_D2)

G: CQ (07 nov): "At half health he shuts himself in an Arcane Bubble and casts Detonation"; HP Library (16 nov):
"Doan at half health: he goes immune behind Arcane Bubble, then casts Detonation". IV, WH (10 nov) en WT noemen
geen moment. Geen enkele bron zegt dat het vaker gebeurt; "now and then" is dus niet onderbouwd (A: in Classic één
keer rond 50%).
Reparatie, nieuwe Engelse tekst: **"At about half health he shields himself, then sets off a huge blast around him."**
(src: 2x CQ+HP; blast zelf IV+WH). De tip kan blijven.

### RISICO 3 — High Inquisitor Fairbanks: optioneel, en hoe kom je bij hem (FDG_SM_9_*)

- Optioneel, G: CQ (07 nov) "High Inquisitor Fairbanks is optional"; HP Cathedral (16 nov) "Fairbanks is optional: he
  waits in the hidden room, no quest needs him, and he does not join the Mograine fight"; WFG (8 nov) "No quest needs
  him". De notes zeggen "alleen WCALC"; dat klopt niet meer. Roogug en Plaguemaw hebben wél `optional`.
- Kamer openen, G: IV (17 nov) "a secret alcove accessed from interacting with a torch on a small room to the right
  of where you face Mograine and Whitemane"; HP (16 nov) "A torch on the prayer room's wall opens it". Dat zijn twee
  bronnen (de notes: "alleen IV"). FDJ zegt iets anders (deur), maar FDJ is geen eigen bron.
- Ligt als dood op de grond, G: WH Cathedral (10 nov) "he is found on the ground until you engage him"; CQ "he lies
  as if dead".
Nu ziet de speler alleen "In a hidden room on the right side of the chapel" en zoekt hij een deur die er niet is.
Reparatie: `optional = true`; D1 → **"Optional: in a hidden room on the right side of the chapel. A torch on the
wall of the small side room opens it."**; extra regel → **"He lies on the floor as if dead until you attack him."**
De `measure` kan worden: "In game: does the torch open the room?" (nog niet in het spel getest).

### RISICO 4 — Mograine-tip staat bijna letterlijk in CQ (FDG_SM_10_T)

"Clear the whole chapel first, the side rooms too." ↔ CQ SM (07 nov): "so clear the whole chapel and the side rooms
first". Reparatie: **"Before you pull him, kill every Scarlet mob in the chapel and in its side rooms."**

### RISICO 5 — Amnennar-tip lijkt op azeroth.wiki, en "down" heeft maar één bron (FDG_RFD_6_T)

"Tank: keep his tent behind you, so his knockback cannot throw you down." ↔ azeroth.wiki/forever RFD: "Tank with
your back toward the tent ... so Amnennar's Wrath cannot throw you down the spiral." WH (14 nov) en WT zeggen alleen
"naar de tent toe tanken"; foreverdb: "Pull him with a wall behind the tank". Reparatie: **"Tank: stand with your
back to his tent, so his knockback cannot push you away."** (2x WH+WT, foreverdb ook).

### RISICO 6 — Thalnos-plaats staat dicht bij IV (FDG_SM_5_D1)

"At the bottom of the crypt at the back of the graveyard." ↔ IV (18 okt): "found at the bottom level of the crypt
located on the far back of the graveyard". Klein (een plaatsaanduiding lijkt altijd op elkaar). Voorstel:
**"Waits at the lowest point of the crypt behind the graveyard."**

### RISICO 7 — Thermaplugg: "shoots" en "switches it off" (FDG_GNOMER_5_D2, _T)

Tip "everyone else shoots the bombs": melee schiet niet; CQ "the rest kill bombs that get through", UGT "Kill any
Walking Bombs that escape". Knop: WT "you can briefly stop their spawn"; CQ "he switches on the gnome faces ... one by
one". Reparatie tip: **"Before the pull, choose who presses the buttons; the others kill the bombs that still get
through."** D2 eventueel: **"A button next to each machine switches it off, until he switches it on again."**
(A uit WT + CQ; laag).

### RISICO 8 — Jargba: "their spells hit hard" (FDG_RFK_3_D1, _T)

WH (9 nov) en MOB (5 nov): twee casters die hard slaan. Maar WT: "a Death's Head Acolyte and a Razorfen
Groundshaker" (stun rondom, geen spell), MG: "If you have a Groundshaker". Reparatie (veilig voor beide):
D1 **"Two helpers fight with him and hit hard."**; tip **"Crowd-control his two helpers if you can, and interrupt
the caster's spells."**

### RISICO 9 — Plaguemaw: wat moet je doen om het event te starten (FDG_RFD_2_D1)

De speler leest "at the end of an escort" maar niet bij wie hij begint. G: WT (quests "Scourge of the Downs" en
"Extinguishing the Idol" van Belnistrasz), WH (14 nov) "When Belnistrasz begins his ritual", azeroth.wiki "If the
prisoner offers it, follow the escort". Reparatie: **"Optional: talk to the prisoner Belnistrasz and take his quest;
Plaguemaw comes at the end, while you protect Belnistrasz at the quilboar idol."**

### RISICO 10 — Spellsever Crossbow-rol "hunter" (FDG_SM_L6)

G (WHT): Ranged Crossbow, +8 AP, "Chance on hit: ... interrupting the spell being cast". A: in Forever/Classic
gebruiken ook warriors en rogues een kruisboog in het ranged-slot. Voorstel: **"ranged slot (crossbow, +8 attack
power, can interrupt a spell)"**. Laag; rollen zijn bewust AFGELEID.

### RISICO 11 — Grubbis niet als optioneel gemarkeerd

G: alleen CQ zegt letterlijk "optional event boss"; IV/WH/WT/MOB/MG/UGT: je start hem via Emi (staat in D1). A: hij
is net zo optioneel als Roogug/Plaguemaw. Laag; Rob kiest. Zo ja: `optional = true` en D1 **"Optional: only comes
in an event: talk to Blastmaster Emi Shortfuse in the cave near the entrance."**

## Aanvulling bij een `measure` (geen fout)

- **Ragglesnout rare?** A uit G-data: FDJ `DropRates.lua` (Wowhead-Forever-killtellingen): Ragglesnout 237 kills,
  tegen Tuten'kash 1666, Mordresh 1386, Glutton 1333, Amnennar 1648; andere rares: Dark Iron Ambassador 236,
  Azshir 212, Fallen Champion 222, Ironspine 247. Hij wordt dus ongeveer even weinig gedood als de echte rares:
  `rare = true` is goed onderbouwd; de `measure` mag blijven tot het in het spel is gezien.

## Inhoud die ik heb nagelopen en die klopt (G, 2+ bronnen gezien)

Gnomeregan: Grubbis-event + golven + Chomper + tip (IV, CQ, WT, MOB, MG, UGT); Viscous Fallout benedenvloer + gif
(IV, UGT, MOB, CQ); Electrocutioner bliksem, kegel, Workshop Key (IV, WT, CQ, MG); Crowd Pummeler (IV, CQ, MOB, WT,
UGT); Thermaplugg bommen, sneller bij minder leven (WT "50% ... 20%", CQ), knop, knockback + threat (IV, WT, MG);
Dark Iron Ambassador (IV, WT, UGT, CQ, MG).
RFK: alle 8 regels (IV, WH, WT, MOB, MG, WFG). Charlga "below her hut" (WH "platform below", MG "ground level").
SM: Vishas, de drie rares, Thalnos, Loksey (3 hounds, Bloodlust laag leven), Doan (schaap, silence, Scarlet Key voor
Armory + Cathedral: IV, WH, CQ, HP; let op: het WT-overzicht zegt "Armory and Library" locked — WT-fout, de WT-Library-
pagina zegt het goed), Herod (IV, CQ, HP), Mograine, Whitemane (IV, WH, CQ, HP).
RFD: Tuten'kash (WH, WT, azeroth.wiki: curse = 15% trager casten, 18% trager slaan), Mordresh, Glutton, Ragglesnout,
Amnennar (WH, WT, azeroth.wiki).
Loot: alle 21 rollen passen bij de WHT-stats.

## Code: `Modules\ForeverDungeonGuide.lua` (punt 4) — geen fout gevonden

- **Scrollende lijst** (G, code r.213-235): `UIPanelScrollFrameTemplate`, 380 px hoog, rijen van 28 px; met deel A
  erbij zijn er meer dan 13 rijen, dus scrollen is nodig. Scrollbalk rechts van de lijst (x ≈ 194-210), tekst begint
  op x = 222: geen overlap (A, uit de anchors). Shift+scroll over de lijst: G, `DialogPopup.lua` r.152-181
  (`WrapChildren`) stuurt Shift+wiel van kinderen door naar het schalen; dus geen conflict.
- **Vleugelkopjes** (G, r.148-154, r.183): kopje bij elke wisseling van `part`; `PartName` haalt `FDGP_*` via
  `ns:L`; loot krijgt "Graveyard:" ervoor. Alle vier `FDGP_*` staan in enUS (G).
- **IsBoss met extraNpc als lijst** (G, r.69-86): getal, lijst en nil goed afgehandeld; `id == nil` → false.
  Grubbis/Chomper (6215) werkt als getal.
- **Level-bereik over alle vleugels** (G, r.38-56): min van min, max van max over de 4 SM-rijen → 30-46
  (ForeverDungeons.lua r.75/76/78/80: 30-38, 33-41, 36-44, 38-46). Eén knop per kaart (`seen`).
- **Tweede Fill via C_Timer** (G, r.325-327): `Fill` stopt meteen als het venster dicht is; `view > 0`-check voorkomt
  scrollen vóór de layout. Geen nil-pad gevonden.
- **Combat** (A): alleen niet-beveiligde frames (Frame, ScrollFrame, UIPanelButtonTemplate); SetText/SetEnabled/
  SetVerticalScroll mogen in combat. `issecretvalue`-guard op de GUID staat er.
- **Taal** (G): `BossName` gebruikt `GetLocale()`; esMX heeft eigen `names`; itIT valt terug op Engels en dat is
  juist (Forever-DB2 itIT = Engels, G).
- Kleine opmerking, geen fout: rares tonen "(rare: not always there)" in de kop én "A rare: not always there." als
  eerste regel (zelfde stijl als stap 1).

## Na mijn oordeel: wat staat in `dg2a_A_notes.md` dat ik miste, of andersom

- Niets wezenlijks dat ik miste. De notes zeggen zelf al: rares achteraan bij Gnomeregan/RFK maar niet bij SM (keuze
  voor de bouwchat), Agathelos "verzegeld door mobs" alleen WT (eens), Electrocutioner/Thalnos onderbreken weggelaten
  (eens: WT zegt "cannot be interrupted"), `lua_syntax_check.py` negeert zijn argument (niet door mij nagemeten).
- Waar mijn controle verder gaat dan de notes: Fairbanks optioneel heeft wél twee bronnen (CQ + HP, niet "alleen
  WCALC") en de fakkel ook (IV + HP, niet "alleen IV") → RISICO 3; de naamverschillen gelden niet alleen deDE maar ook
  frFR (de meeste), esES en ruRU → RISICO 1; Doan "now and then" → RISICO 2; drie tekstnabijheden → RISICO 4-6;
  Ragglesnout-killtelling als steun voor `rare`.
