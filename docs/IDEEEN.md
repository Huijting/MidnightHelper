# Ideeën — de ene lijst

Gemaakt 10 nov 2026 (Rob: *"ja, voor de ideeënlijst"*). Dit is vanaf nu de enige plek voor ideeën.
De toets en de vaste vorm staan in `docs/PLAN_WERKWIJZE_2026-11-10.md`.

**Hoe het werkt**

- Een nieuw idee komt in **Open**, in de vaste vorm. Rob zegt ja, nee of later.
- **Ja** = wordt gebouwd. Is het gebouwd, dan gaat het naar **Af**.
- **Nee** blijft staan, mét de reden. Zo komt het niet steeds terug.
- De oude lijsten blijven als geschiedenis: `IDEEEN_OPEN_2026-10-08.md`, `PLAN_IDEEEN_2026-11-05.md`.

**Hoe deze eerste versie is gemaakt**

- De open punten uit de twee oude lijsten, de wensen uit `SURVEY_RESULTS.md` (31 antwoorden) en de "Later"-regel
  bovenaan `NEXT_SESSION.md`. Het archief en de plan- en specbestanden zijn NIET doorgelopen.
- **GEMETEN** = vandaag met grep in de code gezien, met een tegencontrole die in dezelfde run wél iets vond.
  **NIET GEMETEN** = overgenomen uit de oude lijst.
- Gemeten wordt alleen of het in de code staat. Niet of het in een release zit, en niet of het in het spel werkt.
- "Voor wie" en "Werk" zijn mijn inschatting (AFGELEID), geen meting.
- Nog niet getoetst aan de vijf vragen. Dat doet Rob met een ja, nee of later per regel.

Kolom *Voor wie*: N = nieuweling, V = veteraan. Kolom *Spel*: M = Midnight, F = Forever.

---

## Open — wacht op Rob

### Forever: Warlock-stats zonder Stamina als hoofdstat (keuze van Rob, 25 nov) — ✅ JA, GEBOUWD 25 nov, wacht op test
- Bron: Sparring-voorstel (a), letterlijk: *"Voor alle drie de richtingen hetzelfde: spell damage eerst, dan Intellect en
  Spirit even belangrijk. Stamina noemen we niet meer als hoofd-stat."*; Rob: *"Ik volg jouw advies."*
- Gebouwd: klasse-rij + 3 bomen gelijk; tooltip-rekensom volgt; zin in "Which weapon?" (8 talen).
- Spel: F. Voor wie: N + V (AFGELEID).

### Forever: "How you play" in tabbladen (wens van Rob, 25 nov) — ✅ AF: GEBOUWD 25 nov (5d0f24e) en GETEST (Rob via Sparring: *"Verder ziet overigens how to play beter uit op deze manier. Wat minder druk voor mijn gevoel."*)
- Bron: Rob via Sparring 25-11, letterlijk: *"En dan open ik het en het is zo'n lange lap tekst. Kunnen we dat venster niet
  beter indelen? Met tabbladen van mijn part of in ieder geval iets waarbij het overzichtelijker is."*; op het voorstel:
  *"Ja, je mag het zo sturen."*
- Gebouwd: tabbladen Start · Your keys · Weapon & stats · Group · Levels links op de pagina, kopjes van het open tabblad
  eronder; lege tab = geen tab; laatste tab onthouden; 8 talen; `/mh howtotabs` telt de regels. Alle ingangen (`/mh play`,
  toetsenblok stap 4, Do this now) openen nu deze pagina.
- Niet gedaan: tekst ingekort. De blokken "Levels 1-10: your buttons" zijn 10-13 regels (meer dan ±5); ontdubbelen vond
  niets (offline `/mh howtotabs`: 0 dubbele lange regels per klas; alleen rollen onderling delen regels, en je ziet er één). Inkorten = herschrijven = aparte vraag aan Rob.
  → BESLIST 25 nov, NIET inkorten. Rob: *"Hoewel het veel tekst is, denk ik niet dat we het veel korter kunnen maken,
  want dan gaan we misschien weer heel veel informatie missen."*
- Getest 25 nov (Druid 12 Feral, 2 screenshots): tabs + kopjes te zien, laatste tab blijft na `/reload`, `/mh howtotabs
  mine` = 72/72, 0 double, nothing missing. Niet apart genoemd: alle tabs langs, kopje klikken, Your direction/All roles,
  Shift+scroll, de andere ingangen.
- Spel: F. Voor wie: N (AFGELEID).

### Forever: Gear check — per vakje zien of er een enchant op zit (wens van Rob, 25 nov) — ✅ JA, GEBOUWD 25 nov, wacht op test
- Bron: Rob via Sparring 25-11, letterlijk: *"ik heb ook enchanting, maar ik zie helemaal niet of ik al iets enchant heb, ja
  of nee, in mijn overzichtje. Kunnen wij dat maken?"*; op het voorstel 1-3: *"Ja, het gaat om forever. En het is goed zo
  met 1, 2 en 3."*
- Gebouwd: (1) venster naast het character-venster, per vakje de enchant of "no enchant"; (2) een regel onder Now;
  (3) voor een enchanter "you can make this yourself". Schakelaar + `/mh enchant`.
- 25 nov: venster GETEST (Robs screenshots). De knop Character gaf een taint-fout → knop weg; de regel noemt nu je toets
  ("Character window: C."). Armor kits tonen nu hun naam (enchant 15 = Light Armor Kit).
- 25 nov: a178459 GETEST (Rob: *"Ja, test is goed gegaan."*, screenshot Hands/Feet "Armor +8, Stamina +1"). Niet apart
  gemeld: de Now-regel met de toets, geen BugSack-fout meer, en "you can make this yourself" op de enchanter.
- Later, apart (eerst onderzoek): advies welke enchant de beste is.
- 26 nov, GEREPAREERD, wacht op test (Rob via Sparring: *"Ik mis hier volgens mij mijn [legs], die ik net wel geenchant
  heb. En kan de [gear] check enchants ook dynamisch updaten?"*): Legs erbij (armor kits; GEMETEN 78 enchants in DB2),
  Head/Shoulder/Waist/Ranged alleen als er iets op zit, en het venster werkt bij een enchant op een gedragen item vanzelf
  bij (UNIT_INVENTORY_CHANGED; na een gevecht).
- Spel: F. Voor wie: N + V (AFGELEID).

### Toetsenblok: de intro-zin klopt niet als het blok al geplaatst is (Robs screenshot, 25 nov) — ✅ JA, GEREPAREERD 25 nov, wacht op test
- Bron: Rob via Sparring 25-11, letterlijk: *"ja dat mag de bouwchat"*.
- Gerepareerd: geplaatst = "This is the block as it is on your bars now."; niet geplaatst = de oude zin. 8 talen.
- Spel: M + F. Voor wie: N + V (AFGELEID).

### Tooltip: welke van je andere characters een recept of materiaal kan gebruiken (wens van Rob, 25 nov) — ✅ JA, stap 1 GEBOUWD 25 nov, wacht op test; stap 2 (gear) = eerst uitzoeken
- Bron: Rob via Sparring 25-11, letterlijk: *"Kunnen wij dat niet hier vermelden in de tooltip, zodat ik weet naar wie
  ik het moet gaan sturen?"*, *"Eigenlijk wil ik het natuurlijk wel voor alles wat we eventueel kunnen versturen naar
  anderen."*; op het voorstel: *"Ja, dat klopt zo. Kun je het voor beide versies maken, Forever en Midnight?"*
- Stap 1 gebouwd (`AltProfTip.lua`): recept = je andere characters met dat beroep + skill (Forever ook "needs N", "can
  learn it", "knows it"); materiaal = welke andere characters een beroep hebben dat het gebruikt. Niet bij soulbound /
  bind-on-pickup / quest-items. Schakelaar + `/mh alttip`.
- 25 nov: materiaal-tooltip GETEST (Rob: *"MH: on your other characters: Blacksmithing: Ima Pallie · …"*). Recept en gear
  nog niet apart gemeld.
- 25 nov: recept-tooltip GETEST (screenshot: "Ima Warlocky (18, needs 50)"). Open: "knows it"/"can learn it" en de
  gear-regel na 7734a0d/3c08cb6.
- 25 nov, GEREPAREERD, wacht op test (Rob: *"Ja, op 1 en 2."*; *"Maar kan ik überhaupt wel sturen?"*): geen gear-regel
  bij grijze items (wit blijft); Forever: alleen characters op je realm; andere factie apart achteraan ("probably not");
  factie onbekend = "(faction ?)". `/mh alttip` zegt per character waarom. Midnight: niet gefilterd (Warband bank).
- Bank-characters (Rob: *"Wat betreft de bankkarakters ga ik mee met je advies. A."*) — GEBOUWD 25 nov, wacht op test:
  Forever: knop "Bank: no/yes" per rij in Characters; beide games: `/mh alttip bank <naam>`. Gemarkeerd = niet in "who
  can wear this", wel in recept/materiaal. Alleen wat de speler aanzet, nooit op naam geraden.

### Forever: welk wapen? Eerst de Druid, daarna de andere classes één voor één (wens van Rob, 25 nov) — ✅ JA, Druid GEBOUWD 25 nov, wacht op test
- Bron: Rob via Sparring, letterlijk: *"Ik ben met Druid aan het spelen. Ik wil eigenlijk alles kunnen doen met hem …
  Maar ik ben nog steeds niet helemaal duidelijk uit wat voor wapen ik moet gebruiken. … Zoek het eens eventjes goed uit
  en begin maar met de Druid inderdaad."*; op het voorstel (tweede check, dan wapenadvies + stats-tekst, daarna de andere
  classes): *"Ja"*.
- Gebouwd: blok "Which weapon? (Druid)" in How you play (level- en ras-afhankelijk, leraren van jouw kant), wapenregel in
  het richting-blok, stats-zin in Do this now met "weapon damage per second" / spell damage/healing vooraan.
- Niet gebouwd: een Do this now-hint "je draagt 1H, er is een 2H met meer DPS" (vraagt tas-DPS-vergelijking die MH niet
  zeker meet). Fable-ronde vóór de volgende release (spelerstekst).
- Volgende: de andere classes, één voor één (Rob: *"Maak ze maar een voor een compleet af daarna de controle"*):
  ALLE 9 GEBOUWD 25 nov (Warrior, Paladin, Shaman, Hunter, Rogue, Mage, Priest, Warlock na de Druid); Fable-controle
  VERWERKT 25 nov (inhoud, vertalingen, code); daarna Hunter, Rogue, de casters. Fable-controle als alle 9 klaar zijn.
- Spel: F. Voor wie: N (AFGELEID).

### Forever: spell damage telt mee in "beter dan wat je draagt" (25 nov) — ✅ JA, GEBOUWD 25 nov, wacht op test
- Bron: Sparring's voorstel aan Rob: "zie ik daar spell damage staan, dan laat ik het meetellen in de vergelijking"; Rob
  deed de meting (`/dump C_Item.GetItemStats("item:9513")` → SPELL_POWER 2) = zijn ja.
- Gebouwd: ITEM_MOD_SPELL_POWER_SHORT telt mee met `spellW` (casters/healers 1, Ret/Prot 0,5); een verloren of gewonnen
  spell damage staat in de regel; healing-only en school-regels = nog onbekend → MH zwijgt. Volgende: Robs 4 dumps.
- Spel: F. Voor wie: N + V (AFGELEID).

### Forever: de enchant op wat je draagt telt mee in "beter dan wat je draagt" (Robs screenshot, 25 nov) — ✅ JA, GEREPAREERD 25 nov, wacht op test
- Bron: Rob via Sparring, letterlijk: *"Ja, op 1 en 2."* (1 = enchant meetellen, 2 = geen alt-regel bij grijs).
- Gerepareerd: de enchant (en armor kit) van wat je draagt telt mee; gaat er een verloren, dan zegt de regel dat erbij;
  een enchant die MH niet kan wegen (proc, wapenschade) = geen "beter". Geldt voor tooltip, quest-tip, oppak-melding,
  "Wear it" en de volle-tas-lijst (één functie). Midnight: andere code (item level), niet aangeraakt.
- Spel: F. Voor wie: N + V (AFGELEID).
- Stap 2 GEBOUWD 25 nov, wacht op test (Rob op het advies "eerst 'kan dragen + hoger item level'. Forever gaat dan ook de
  gear onthouden": *"Zeg je ja? JA"*): bij BoE gear wie het kan dragen (class, harnas, wapen, level) en of het item
  level hoger is dan wat dat character in dat vakje draagt. Geen "beter" op stats. Later, als Rob het wil: echte
  stats-vergelijking (dan ook de spec opslaan).
- Spel: M + F. Voor wie: V (alts) (AFGELEID).

### Forever: taunts op de muis in het toetsenblok (wens van Rob, 25 nov) — ✅ AF: GEBOUWD 25 nov (1769f5f) en GETEST (Rob via Sparring: *"De tangtesten is gelukt."*)
- Bron: Rob via Sparring 25-11, letterlijk: *"We hebben dingen als Taunt en Growl. Ik zou graag ook een macro van willen
  hebben voor een mouse over."*; op het voorstel: *"ja graag"*.
- Gebouwd: met `/mh mouseover on` gaan Growl, Taunt, Mocking Blow en Distracting Shot naar de vijand onder je muis.
- Spel: F. Voor wie: V (tanks) (AFGELEID).

### Spiekbrief op de site ook voor 12 × 4 (advies van Sparring, 25 nov) — ✅ JA, addon-kant GEBOUWD 25 nov; site-kant bij de site-chat
- Bron: Rob via Sparring 25-11, letterlijk: *"ja op mijn advies bij 1 tot en met 4"*.
- Addon: de code zegt welke indeling en welk spel (`layout=`, `game=`). Site: het 12 × 4-raster en de deel-link.
- Spel: M + F. Voor wie: N + V (AFGELEID).

### Forever: geen "runs out soon" als een ander je een hogere rank gaf (bug van Rob, 25 nov) — ✅ JA, GEREPAREERD 25 nov, wacht op test
- Bron: Rob via Sparring 25-11 (Forever Mage, Arcane Intellect), letterlijk: *"ik had van een andere mage al een hogere
  rank gekregen die dus nog 2 minuten actief is, en dan blijft dit irritant in beeld, dat moet natuurlijk niet"*; op het
  voorstel: *"ja"*.
- Gerepareerd (`ForeverBuffs.lua` ExpiringLeft): hogere rank dan jij kent = stil tot hij op is, dan de gewone melding.
  Alle Forever-buffs. `/mh buffs` zegt waarom. Ook bij een groepsbuff van een ander (Rob op (a): *"Ik volg uiteraard
  jouw advies"*): stil als je eigen hoogste rank zwakker is (sterkte per groepsbuff GEMETEN in DB2).
- Spel: F. Voor wie: N + V (AFGELEID).

### Forever: Ctrl+Shift+klik op een tasitem = Disenchant (wens van Rob, 25 nov) — ✅ AF: GEBOUWD 25 nov (2b4a94d) en GETEST (Rob via Sparring: *"Dat werkt ook. … Dus daar ben ik blij mee."*)
- Bron: Rob via Sparring 25-11, letterlijk: *"Kunnen wij een knop in de tooltip bouwen als we een item kunnen
  disenchanten? Zodat ik niet eerst disenchant moet drukken, dan het ding wat ik wil disenchanten, maar dat we gewoon de
  tooltip daarvan kunnen gebruiken."*; op het voorstel: *"Ja, een chanter is een forever karakter. En we beginnen
  inderdaad met digijant eerst."* Gezien in ForeverForge Bags (licentie onbekend): niets overgenomen.
- Gebouwd (`ForeverDisenchant.lua` deel 4): Ctrl+Shift+linksklik op een item dat kan (verdict "yes") in Blizzard-tassen of
  Baganator = Disenchant op dát item. Alleen met Enchanting, nooit in een gevecht, zonder Ctrl+Shift werkt de tas gewoon.
  Tooltipregel als het kan. Schakelaar (aan) in de stille helpers + `/mh disenchant click on|off`.
- Spel: F. Voor wie: N + V (AFGELEID).

### Forever: Prospecting en Milling met dezelfde Ctrl+Shift+klik (wens van Rob, 25 nov) — LATER
- Bron: Rob via Sparring 25-11, letterlijk: *"En dan kunnen we prospecting en mailing later kijken. Want het hoort er wel
  bij. Hoewel ik het niet heb, maar het hoort er wel bij."* (Willow: mailing = Milling.)
- Idee: hetzelfde vakje-knopje, maar met de spell die bij het item past (erts → Prospecting, kruiden → Milling). Eerst
  meten of Forever die beroepen/spells heeft en welke items het kunnen. Niets gebouwd.
- Spel: F. Voor wie: N + V (AFGELEID).

### Toetsenblok: knop voor de indeling + 12 × 4 ook in Midnight (wens van Rob, 24 nov) — ✅ JA; stap 1 + 2 GEBOUWD; in Midnight GETEST op de Prot Paladin (25 nov)
- ✅ 25 nov, Rob via Sparring, letterlijk (ruw, Willow): *"Ik heb overigens daar ook, en het was in Midnight, alle key
  bindings gezet zoals de nieuwe versie doet. En dat werkt ook keurig. De wisselknop, die zat er netjes in."* En:
  *"Sorry, ja, toets 1 was ook gelukt. Judgment zit nu op toets 1."* Niet apart genoemd: de wisselknop in Forever.
- Bron: Rob via Sparring 24-11, letterlijk: *"Ja, er moet een knop komen, want dit was wel lastig. En anderen weten
  inderdaad de commando's ook niet zo, als ze het niet gelezen hebben. En ja, ik zou dit ook graag in Midnight
  willen."*; op de samenvatting: *"Ja, dit klopt."* Daarmee VERVALT keuze 1a (12 × 4 alleen Forever).
- Stap 1 ✅ gebouwd 24 nov, wacht op test: knop "Layout: …" in `/mh block` (onder "New spells"); één klik na een vraag =
  undo + wisselen + opnieuw neerzetten (alleen als het blok stond); nog eens klikken = terug. Commando's blijven.
- Stap 2 ✅ GEBOUWD 24 nov, wacht op test (Rob: *"A A A"*, healers *"a ja"*): 12 × 4 voor Midnight uit de rollen +
  rol-naar-toets-tabel; 4 mh-research-controles + tweede Opus-controle → 76 uitzonderingen + 10 healer-regels (op
  spell-id); Ctrl-rij Midnight (combat potion, health potion, 2 trinkets, healthstone); 5 = interact en Shift+Spatie =
  willekeurige favoriete mount; uitlegblad met Midnight-tekst; gaten in de rol-data gedicht (resurrects, stances,
  aura's, Steady Shot/Expunge per spec, The Hunt voor Devourer). Speelkaarten volgen vanzelf (lezen echte balken).
- Spel: M + F. Voor wie: N + V (AFGELEID).

### Forever: "Do this now" — knop How you play + vrije tasplekken naast je goud (wens van Rob, 24 nov) — ✅ AF: GEBOUWD 24 nov (99770bc) en GETEST (Rob via Sparring, letterlijk: *"Ja, beide zijn helemaal goed."*)
- Bron: Rob via Sparring 24-11, letterlijk: *"kunnen we hier onder ook een knop how to play toevoegen en in het rijtje van
  gold aan de linkerzijde het aantal open tas plaatsen :)"*; op de samenvatting van Sparring: *"ja"*.
- Gebouwd (`ForeverDoNow.lua`): knop "How you play" achter "Open overzicht", opent de speelkaart van dit character. Links
  van het goud: tas-icoon + "12 vrij" (later ook: *"En de tas werkt inderdaad ook zoals de melding erop. Gaat ook helemaal
  goed. En zo speel ik knop, ben ik ook blij mee."*). Oranje vanaf 5 vrij (of je eigen tas-waarschuwing als die hoger staat, `/mh bags
  <n>`), rood bij 0. Telt alleen gewone tassen (zelfde telling als de tas-waarschuwing: geen pijlkoker, ammo- of soul bag).
- Spel: F. Voor wie: N + V (AFGELEID).

### Forever: toetsenblok "12 × 4" zoals in de Bellular-video (wens van Rob, 24 nov) — ✅ JA (1a + 2b), GEBOUWD 24 nov, wacht op test
- Bron: Rob via Sparring 24-11, letterlijk: *"ik vind namelijk zijn uitleg goed en wil onze versie ook zo hebben van
  keybinds qua knoppen"*, *"maak een voorstel, in jip en janneke"*, en op het voorstel: *"uiteraard volg ik je advies e laat
  een agent uitzoeken welke spells logisch zijn per class zodat dat automatisch kan worden toegepast ipv dat ik ga gokken
  met dingen die ik nooit gespeeld heb"*. Gekozen: alleen Forever (1a), een schakelaar met het oude blok als standaard (2b).
  Daarmee vervalt de regel dat Rob elke klasse-tabel eerst goedkeurt: het onderzoek bepaalt, Rob test.
- Gebouwd: `KeyBlock.lua` BLOCK_12 + `/mh block style old|12x4`; `keys12` in de 9 `ForeverBlock_<Class>.lua`
  (onderzoek `docs/forever/KEYBLOCK12_<CLASS>.md` + tweede controle `KEYBLOCK12_REVIEW.md`); Ctrl-balk met vaste items
  (bandage, health/mana potion, healthstone, trinket; id's gemeten). Alt-balk = block D (Alt-G i.p.v. Alt-Z).
- ✅ 24 nov: uitlegblad "Why these keys?" GEBOUWD en GETEST (Rob via Sparring, letterlijk: *"JA ZIET ER GOED UIT"*) (Rob: *"kunnen we ook een soort blad even maken, waarbij we de users
  uitleggen waarom we welke knop waar gezet hebben"*, verduidelijkt *"… dat is altijd hetzelfde op welke class je ook
  speelt"*, op de samenvatting *"Ja"*; heal = C/Shift-C: *"a"*). Knop in het toetsenblok-venster (Forever, 12×4); taak per
  toets uit `docs/forever/KEYBLOCK12_TAKEN.md`. Site-pagina: later via de site-chat.
- Stap 2, deel 1 ✅ JA, GEBOUWD 24 nov, wacht op test: mount op Shift+Spatie (Rob: *"En shift spatie is op zich wel een
  goed idee voor de mount."*) en interact op 5 als tweede toets (Rob: *"Ja, ik volg advies dus A. Je trekt op 5 en dat
  punt blijft ook werken."*). `ForeverKeyExtras.lua` + `ForeverMountData.lua`: één vraag, undo `/mh block extras off`.
- Nog later: sit/sheathe/character alleen na een vraag, met undo. Downranks per toets kan de motor niet.
- ✅ 24 nov: "Fix it now" GETEST op een Druid (Rob: *"Ik heb net een druid verder gedaan en fixit werkte."*).
- ✅ 24 nov: How you play noemt de toetsen van de gekozen indeling (d5380df) — GETEST (Rob via Sparring, letterlijk:
  *"en in how to play staat get nu goed"*).
- Spel: F. Voor wie: N + V (AFGELEID). Site: pas na test en release.

### Forever: consumable-venster voor de party, zoals in Midnight (wens van Rob, 23 nov) — ✅ JA (optie A), GEBOUWD 24 nov, ⏸️ LATER TESTEN op een hoger level
- ⏸️ Rob, letterlijk: *"De groepsport gaan we later testen als ik een hogere level heb. Dus die mag van de lijst af."*
  NIET getest.
- 24 nov: Rob via Sparring 24-11, letterlijk: *"Ja maak maar"*, en op *"Bedoel je doe jouw advies (A)?"*: *"ja"*.
  Gebouwd: `Modules/ForeverReadyBoard.lua` + `ForeverReadyBoardData.lua` (nieuw, beide toc's, alleen actief in Forever).
  Eigen spullen (elixer/flask, Well Fed, iets op je wapen, health/mana potion, healthstone bij een Warlock) + class-buffs
  van iedereen (Arcane Intellect, Fortitude, Mark of the Wild, een Blessing), wie hem kan geven, eigen buff klikbaar.
  Opent bij een ready check (`/mh readyboard auto on|off`) en met `/mh readyboard`; diagnose `/mh readycheck`.
  Id's GEMETEN door mh-research (`docs/forever/CONSUMABLES_FOREVER_2026-11-24.md`); Battle/Guardian-elixers niet in
  de data → één kolom. Andermans tassen = optie B, NIET gebouwd. Offline getest (43/43), NIET in het spel.
- Bron: Rob 23 nov via sparring, letterlijk: *"oke, we gaan nu slapen, voor morgen, een consumable venster voor de party in
  forever zoals in midnight, maar nu weltrusten"*, en daarna: *"en de buffs natuurlijk, slaap lekker"*.
- 🔴 De buffs van de groep horen er nadrukkelijk bij: per groepslid welke class-buff hij mist (Arcane Intellect, Fortitude,
  Mark of the Wild, Blessings …, id's nog meten) en wie in de groep hem kan geven. Alleen vóór het gevecht (in een gevecht
  weigert het spel aura's van groepsleden te lezen, GEMETEN met /mh partytest).
- Welk Midnight-venster (GEMETEN in de code): de **Consumable Ready Check** = `ConsumableReadyCheck.lua` + `ConsumableReadyBoard.lua`
  (icoonbord: per groepslid flask/rune/weapon/combat potion/health potion/food/healthstone + raid/class-buffs, klikbaar met
  secure knoppen) + `ConsumableReadyComms.lua` (MH-spelers delen hun eigen tas-tellingen via addon-bericht "MHCons"; buffs
  komen uit aura's). Alleen in `MidnightHelper.toc` (r.152-154), NIET in de Forever-toc (GEMETEN).
- Wat in Forever anders is:
  - andere spullen: Classic-elixers en flasks (Battle/Guardian, AFGELEID), eten met "Well Fed", geen combat-runes zoals in
    Midnight; class-buffs als Arcane Intellect, Fortitude, Mark of the Wild, Blessings. Alle id's nog te meten (gamedata).
  - aura's van groepsleden: buiten een gevecht leesbaar, IN een gevecht geweigerd ("Auras cannot be accessed when secret
    while tainted by 'MidnightHelper'"; GEMETEN met /mh partytest, `docs/NEXT_SESSION_ARCHIVE.md` r.1522). Dus: alleen vóór
    het gevecht (ready check / bij binnenkomst), net als in Midnight.
  - tassen van anderen: alleen via addon-berichten van andere MH-spelers; trial-accounts mogen in Forever geen addon-berichten
    sturen (GEMETEN, Patch 1.60.1 API changes, zie `docs/forever/LAYER_SWAP_ONDERZOEK_2026-11-23.md` §5.3).
- Bruikbaar: de Midnight-opbouw (bord + ready check + comms) als basis, met een Forever-lijst van consumables en buffs;
  `ForeverPartyPanel.lua` (de kleine groepsrij) en `MissingBuff.lua` (al in de Forever-toc) zijn de aanknopingspunten.
- Spel: F. Voor wie: N + V (AFGELEID). Site: pas na bouw en release.

### Forever: teller in het class-questkaartje (vraag van Rob, 23 nov) — ✅ JA, GEBOUWD, wacht op test
- Bron: Rob 23 nov via sparring, letterlijk: *"Zie deze quest. Ik moet 6 familiar heads hebben. Ik heb er toevallig al 4
  gehaald. Maar kunnen we dat daar ook niet gewoon in hetzelfde schermpje erbij plaatsen met hoeveel ik op dat moment
  heb? Zodat ik weet hoeveel ik heb."*
- Gebouwd: `ObjProgress` in ForeverClassQuests.lua: de stand in de woorden van het spel ("Vile Familiar Head: 4/6") in het
  kaartje (groen, eigen regel), in Do this now en in het overzicht. Ververst op QUEST_LOG_UPDATE / BAG_UPDATE_DELAYED.
- Spel: F. Voor wie: N + V (AFGELEID). Site: pas na test en release.

### Forever: upgrade aantrekken vanuit "Do this now", "wear B" (23 nov) — ✅ AF: gebouwd (opvallen A) + getest (Rob: "ORB is goedgekeurd. Alles doet hij wat hij moet doen.")
- Bron: Rob 23 nov via Sparring 23-11, letterlijk: *"Ja, doe maar OR-B. Maar dan moet je wel opvallen dat hij erin staat.
  En als er meerdere zijn in je tas, dan moet het ook blijven staan."* Aanleiding: Polestar's upgrade-melding (GPL: alleen
  het idee, eigen code).
- Gebouwd: `Modules/ForeverWear.lua` + regels bovenaan Do this now met [Wear it] / [Not this one], knop in het overzicht,
  schakelaar, `/mh wear why|reset`. Oordeel = `ns.ForeverGearTipText` (de groene tooltipregel). Alleen Forever.
- Rob koos A (letterlijk: *"Opvallen A."*): een upgrade opent het venster vanzelf, niet in gevecht; kruisje = dicht tot
  er een nieuwe upgrade komt.
- Spel: F. Voor wie: N + V (AFGELEID). Site: pas na test en release.

### Forever: QuestieDB live lezen, "quest A" (23 nov) — ✅ JA, A gemeten (goed), B GEBOUWD + GETEST (Rob: "Stap 6, gevecht gedaan en geen errors gekregen.")
- Bron: Rob 23 nov via Sparring 23-11, letterlijk: *"quest a"* (onderzoek), daarna *"Ik volg jullie advies."* (= eerst
  meten A, dan pas gaten vullen B; de Questie-regels in ForeverClassQuests laten tot het GPL-besluit). GPL: *"gpl is niet
  defenitief van tafel :)"*.
- Onderzoek + opties: `docs/forever/QUESTIEDB_LIVE_2026-11-23.md`. Gebouwd: `Modules/ForeverQuestieDB.lua`,
  `/mh questiedb [here]`, alleen meten, spelers zien niets. MH levert geen QuestieDB-data mee.
- Spel: F. Voor wie: N + V (AFGELEID). Site: pas na B, bouw en release.

### Midnight-spelers tevreden houden: drie ideeën (22 nov) — ✅ JA, LATER (niet nu bouwen)
- Bron: Rob 22 nov via sparring: *"bedenk eens iets hoe we de midnight spelers ook tevreden kunen houden"*; op de drie
  voorstellen hieronder, letterlijk: *"alle 3 maar niet voor nu, straks slapen"*.
- 1. **Patchdag-kaartje 12.1.7**: één kaartje bij de eerste login op 12.1.7 met wat nieuw is: Turbulent Timeways per week,
  Vyranoth (5000 Timewarped Badges, met jouw stand), de campagne The Coreway Advance met een knop voor de weg, Folio 7
  stappen. Advies van sparring: bouwen op wo 25 nov (Midnight-dag). Feiten: `docs/PATCH_12_1_7_DRAAIBOEK.md` (patch
  waarschijnlijk 1/2 dec, AFGELEID); vóór het bouwen opnieuw meten.
- 2. **Midnight "eerste blik"** zoals het Forever-overzicht: hetzelfde idee als "Midnight: de eerste blik bij openen"
  verderop (gepauzeerd 18 nov, proefplaatje 2d25d45). Staat nu ook op ja, later.
- 3. **December-events in de weekplanning**: Delves Bonus Event wo 16 dec, Winter Veil vanaf 15 dec, Midnight Dungeon
  Event wo 23 dec (draaiboek, punt 9 in de tabel; data uit de testdata, nog niet live gezien).
- Spel: M. Voor wie: N + V (AFGELEID). Site: pas na bouw en release.

### Platynator-pagina weg vóór 5.8.0 (22 nov) — ✅ AF: gebouwd + getest (Rob: "midnight goed tekst goed")
- Bron: Rob 22 nov via sparring, op "platy weg / platy link / platy blijft", letterlijk: *"En ja, platy die mag weg."*
- Hele pagina weg, ook de link; Details! blijft. Vervalt: "releasetekst 5.8.0 ongewijzigd", alleen voor deze regel.
- Spel: M. Site: nakijken of de pagina daar genoemd wordt, pas bij de release.

### Bronnenlijst met licentieteksten in de zip (22 nov) — ✅ JA + GEBOUWD; gevonden licentiepunten wachten op Rob
- Bron: Rob 22 nov via sparring, op het voorstel "MIT blijft, één bronnenbestand, één zin erbij", letterlijk: *"Bronnenlijst, ja."*
- `THIRD_PARTY.txt` in de root + README. Vervalt: "niets voor de licentie wijzigen", alleen voor deze lijst en die zin.
- Spel: M + F (in het spel verandert niets). Site: niets.

### Forever: oude Polestar-weetjes in de class-quests nakijken (22 nov) — ✅ JA voor nakijken, GEDAAN; repareren GEBOUWD 23 nov (Rob: "Ja, 1, 2 en 3"), wacht op test
- 23 nov, weetjes A volgens het rapport: R12 (Eye wacht op 78307), wachtzin bij 78261 (R11) en 78676 (R14, level 30 +
  hoofdstad), getallen weg bij R10 (brieftijd), M21 (Cantation 5 min) en W3 (1 op 20), commentaar M1 en S6. Laten staan om te
  testen (rapport-advies): rasroutes R2, M5, M10, M11, M12, M14, W7 en tips M19, M20, M23, W2.
- Bron: Rob 22 nov via sparring, letterlijk: *"Misschien is dat wel slim, ouderwetjes nakijken. En een vraag aan mijn kant.
  Moeten wij ook iets met die licentie? Moeten wij onze licentie aanpassen? Of vind je dat zoals wij het nu hebben best wel
  goed is?"* De licentievraag beantwoordt sparring; daar niets voor gewijzigd.
- Uitkomst: `docs/forever/POLESTAR_NAKIJK_2026-11-22.md`. 5.8.0 blijft zoals het staat.
- Spel: F. Site: niets.

### Release 5.8.0 (22 nov) — ✅ klaargezet + GO voor uitbrengen
- Bron: Rob 22 nov via sparring, op "zet 5.8.0 klaar", letterlijk: *"Zerlt klaar , ik log straks nog in"*.
- Vervalt: "geen bump, releasetekst of Fable-ronde". Daarna, letterlijk: *"crates zwijgen en go voor 5.8.0"*; daarmee vervalt ook *"We doen nog geen release."*
- Spel: F (Midnight: niets nieuws). Site: pas na de upload.

### Forever: leren van Polestar/FlowUp — dungeon-quests, "waar haal ik dit vandaan?", bootwachttijd, XP per uur (wens van Rob, 21 nov) — ✅ JA, 4, 2 en 1 (B) GEBOUWD, wacht op ronde 2, 3 rust
- Bron: Rob 21 nov via sparring, letterlijk: *"ik blijf bij Zygor, Polestar probeer ik later. maar kunnen wij er iets van
  leren / verbeteren"* → *"2 en 1, doe maar, daarna 3 en 4 :)"*.
- Volgorde: (2) dungeon-quests, (1) waar haal ik dit vandaan, (3) boot/zeppelin-wachttijd, (4) XP per uur.
  Alleen het idee: Polestar is GPLv3, FlowUp-routes ARR. Plan en stand: `docs/NEXT_SESSION.md` bovenaan.
  22 nov: het vrije datadeel van Polestar uitgezocht (`docs/forever/POLESTAR_DATA_2026-11-22.md`); Rob: *"alles advies"* = A, in de recepten GEBOUWD.
- (2) Dungeon-quests: gebouwd 21 nov uit Zygor, 22 nov van main gehaald (Rob 22 nov via sparring, letterlijk: *"Zygor b"*).
  ⏸️ Herbouw gestopt 22 nov (Rob: *"wij blijven Zijgor als een informatiepunt houden"*). ▶ Rob daarna, letterlijk: *"overnemen, ja"* = plekken en nummers uit Zygor mogen
  (geen teksten, notities of code): de dungeon-quests zijn 22 nov terug op main, wacht op Robs test.
- (4) XP per uur + tijd tot level: GEBOUWD 21 nov (nacht), schakelaar FXPRATE_SW, wacht op Robs test.
- (1) Waar haal ik dit vandaan: ✅ JA, optie B. Rob 22 nov via sparring, letterlijk: *"1 b"* (op "1. A, B of C?"). B = onbekende
  recepten "Waar haal je dit" (venster + tooltip, trainer met pijl) + reagentia in de tooltip (verkoper met pijl /
  verzamelberoep / monsters zonder plek); weet MH het niet, dan zwijgen. Eerst Robs meting `/mh skillup source`.
  Reagentia onderzocht 22 nov (`docs/forever/REAGENTIA_2026-11-22.md`), keuze nu: *"overnemen, ja"* (Zygor: plekken en nummers).
  Reagentia GEBOUWD 22 nov (194 items, met Polestar A: verzameld, te koop, valt van monsters; wacht op Robs test). Recepten: GEBOUWD, wacht op test.
  Plek (Rob 22 nov: *"plek ja"*): tooltip + Skill up-venster; Blizzards beroepenvenster alleen als extra.
- (3) Bootwachttijd: ONDERZOCHT 22 nov, nu niet eerlijk te meten, niets gebouwd (`docs/forever/BOOT_ZEPPELIN_2026-11-22.md`).
  ⏹️ Rob 22 nov via sparring, letterlijk: *"Boot Rust"* = laten rusten; niet opnieuw voorstellen.
- Recepten (1) onderzocht 22 nov (`docs/forever/RECEPTEN_2026-11-22.md`): Rob: *"alles advies"* = Classic A + Polestar A, GEBOUWD, wacht op test. De
  vraag was: telt Classic-data als tweede bron?
- Meting (1) gedaan 22 nov (*"meting gedaan"*): Forever geeft bij Cooking geen bron (0 van 132), dus eigen data per recept.
- Spel: F. Site: nog niet.

### Forever: class-queststap als opvallend kaartje + de level 1-briefjes (wens van Rob, 22 nov) — ✅ JA (kaart B), GEBOUWD, ◐ goed op Tauren hunter
- Getest: Rob 22 nov via sparring, letterlijk: *"kaartje goed, hebben we dit voor meerdere classes ?"* (ja: alle 9 classes,
  56 briefjes; in het spel is alleen de Tauren hunter getest, de rest staat open in TESTLIJST).
- Bron: Rob 22 nov via sparring, met een screenshot van Polestar, letterlijk: *"We doen nog geen release. Dan kom je wat
  anders tegen. Kijk, dit plaatje. Ik vind dat gaaf. Dit valt duidelijk op dat ik als Hunter dit nog kan doen als class
  step blijkbaar. Of iets. Wat is het? Ja, het is een class quest part of your route. Dus ja, kijk maar eventjes."* →
  op de opties A/B/C: *"b"*.
- B = de briefjes van level 1 voor alle classes en rassen (pas tonen als je ze kunt aannemen, nooit vóór een spell-keten,
  niet eeuwig) + elke class-queststap in het bestaande losse venstertje als kaartje in stijl A, rand in de classkleur.
- Vervalt hiermee: "level 1-briefjes bewust weggelaten" en de ene lange zin in het venstertje.
- Polestar alleen als idee (GPL): geen code, opmaak, plaatjes of zinnen.
- Spel: F. Voor wie: N (AFGELEID). Site: nog niet.

### Forever: trainerplekken in de class quests — Zygor + HandyNotes live (22 nov) — ✅ JA (B), GEBOUWD, wacht op Robs test
- Bron: Rob 22 nov via sparring, letterlijk: *"Plekken b"*. B = overgenomen HandyNotes-plekken (All Rights Reserved)
  vervangen door die van Zygor; wie HandyNotes: Class Trainers heeft krijgt live die precieze plek (zijn keuze van 7 nov).
- Vervalt: "niet aanraken tot zijn ja", alleen voor ForeverClassQuests.lua.
- Daarna de kladjes: Rob 22 nov via sparring, letterlijk: *"kladjes ja"* = de overgenomen cijfers uit 11 docs en 2
  commentaarregels, "stond in HandyNotes" ervoor in de plaats. ✅ Gedaan; in oude git-versies blijven ze.
  Ook 5 achtergebleven regels in 3 van die docs: uitleg van sparring van dat ja, geen nieuw woord van Rob ("die 5 laten" trekt het in).
- Spel: F. Site: nog niet.

### Forever: Skill up-venster repareren (22 nov) — ✅ getest (Rob: "Venster is goed"); klik en scroll nog open
- Bron: Rob 22 nov via sparring, met screenshot, letterlijk: *"venster ja"* (dicht in stijl A; "MH weet nog niet welke
  trainer/verkoper"; de knop noemt het beroep).
- De 11 andere vensters: Rob 22 nov via sparring, letterlijk *"Doe maar vensters A"*: GEBOUWD (4 te
  openen, 7 zijn reserve achter het overzicht). ✅ De 4 goedgekeurd, Rob 22 nov: *"Dus de vensters zijn goed. Dat kan je
  goedkeuren."* (losse punten open in TESTLIJST).
- Spel: F. Site: nog niet.

### Forever: "bekende recepten" repareren (22 nov) — ◐ JA + GEBOUWD, getest op één character (Rob: "ronde 1 klopt")
- Bron: Rob 22 nov via sparring, letterlijk: *"Recepten ja"* (kopie eerst, eigen venster vervangt, beroepen die het character
  niet heeft weg, gelinkte vensters overslaan, zijn recepten in het spel veranderen niet).
- Spel: F. Site: nog niet.

### Forever: volle tassen onderweg leger maken (wens van Rob, 22 nov) — ✅ JA op 1, 2 en 3; bescherming + 1, 2, 3 GEBOUWD; ◐ "ronde 1 klopt" (lijst + grijs met Destroy), 1-3 nog testen
- Bron: Rob 22 nov via sparring: *"polestar heeft ook iets om je volle tassen onderweg leger te maken, check dat ook"* →
  op vier ideeën: *"tas 1 2 3"*.
- (1) reservetas + leeg tasvakje: eerst aanbieden om aan te trekken. (2) De hulp komt al bij bijna vol, met schakelaar.
  (3) Grijs zonder verkoopwaarde mag erbij; Destroy vraagt altijd. (4) markeren: niet gekozen.
- Bewaren: Rob 22 nov via sparring, letterlijk *"alles advies"* = B (ook gif, drankjes, elixers, flasks, verband,
  scrolls, sleutels, tassen, recepten, leerboeken): GEBOUWD, wacht op test.
- Ook huisdieren, rijdieren en alles waar je iets van leert (63): Rob 22 nov via sparring, letterlijk *"dieren ja"*:
  GEBOUWD, wacht op test.
- Eigen code; Polestar is GPL: alleen het idee.
- Spel: F. Site: nog niet.

### Forever: talentpunt opvallender in Do this now (wens van Rob, 22 nov) — ◐ regel goed, knop weg (Rob: "knop weg", na "action blocked"); ◐ "ronde 1 klopt" (gevecht goed; vrij punt + pet onzeker)
- Bron: Rob 22 nov via sparring, met screenshot: *"kunnen we de talent point meer laten opvallen"* → op opties A/B/C:
  *"talent b"*.
- B: de talentregel bovenaan, goud, met een ster en een witregel; knop Talents vooraan. Geen gloed of animatie. Geen vrij
  punt = geen regel en geen knop.
- Spel: F. Site: nog niet.

### Forever: mouseover-buffmacro voor de andere classes, zoals Smart Bless (vraag van Rob, 21 nov) — ✅ JA + GEBOUWD 21 nov (Rob 22 nov: "smart buff goed", mage)
- Bron: Rob 21 nov via sparring: *"Kunnen wij ook een soort mouse-over macro maken voor de andere buffs, voor alle andere
  classes. Zodat ik die standaard op eenzelfde plek kan zetten, terwijl als mensen langslopen, dat ik gauw op hun een buff
  kan geven."* GO, letterlijk: *"Ja, wou het maar."*
- Gebouwd: macro "MH Smart Buff" voor Mage (Arcane Intellect), Priest (Power Word: Fortitude), Druid (Mark of the Wild);
  eerst muis, anders doelwit. Andere classes hebben geen lange buff voor een ander (Paladin: Smart Bless).
- Spel: F. Site: nog niet (in bouw, niet getest).

### Forever: Do this now zegt welk talent je nu kiest (voorstel sparring, Rob 21 nov) — ✅ JA + GEBOUWD 21 nov voor Paladin (wacht op Robs test)
- Bron: Rob 21 nov via sparring, letterlijk: *"Ja, doe dat maar"* op "'Do this now' zegt bij elk nieuw level welk talent
  je nu moet kiezen ... Dan hoef je die hele lijst nooit te lezen." Aanleiding: How you play is "weer heel veel tekst".
- Gebouwd: `ForeverTalentNext.lua` (leest je echte talenten, noemt het volgende uit de volgorde van je richting),
  schakelaar in Quiet helpers, `/mh talent`. Paladin: Retribution (guided.news) en Protection (stillsixty).
- 21 nov uitgebreid naar ALLE classes. Rob via sparring, letterlijk: *"het puntensysteem, waar ga ik welk punt in
  stoppen, moet natuurlijk wel uitgebreid worden. Ik zit nu bijvoorbeeld op mijn shamaan ... Ga ermee aan de slag"*.
  Gebouwd: Shaman, Warrior, Druid, Hunter, Rogue, Priest, Mage, Warlock (levelvolgorde + waar zinnig een tweede).
  Nog: één Fable-controleronde over alle volgordes.
- Spel: F. Site: nog niet (in bouw, niet getest).

### Forever: level als X, tank als Y; respec en Dual Spec voor elke class (vraag van Rob, 21 nov) — ✅ JA + GEBOUWD 21 nov (wacht op Robs test)
- Bron: Rob 21 nov via sparring: *"Ik ben nu een paladin aan het levelen ... als tank ... Heb ik een two-handed sword
  nodig? ... een one-handed en een shield? ... welke talentpunten ... ook bij andere ... zoals een druid"*. GO, letterlijk:
  *"Ja, voeg dat maar toe en laat het maar uitvoeren ook. Ik vind dat wel iets belangrijks eigenlijk."*
- Gebouwd: blok "level en tank" voor Paladin, Warrior, Druid in How you play; sectie "Talents: reset and Dual Spec" voor
  elke class; Do this now-tips Wolfsbane (eerst Two-Handed Swords bij Archibald) en Dual Spec (vanaf 40); tankstats Paladin
  nu Stamina > Intellect. Bronnen: `docs/forever/TANK_LEVELEN_2026-11-21.md`.
- Spel: F. Site: nog niet (in bouw, niet getest).

### Forever-overzicht: zoektreffer springt naar de schakelaar + ondertitel "for WoW Forever" (wens van Rob, 21 nov) — ✅ JA + GEBOUWD 21 nov (wacht op Robs test)
- Bron: Rob 21 nov via sparring (GO), letterlijk: *"Dan moet ik eerst gaan scrollen naar beneden en kijken waar staat hij
  ook weer. ... Dat moet volgens mij beter kunnen."* en *"Iets dat duidelijk maakt dat het echt voor Forever is."*
- Gebouwd: klik op een Quiet helpers-treffer → pagina open, regel in beeld, 2 s goud oplichten; "spar/ore/herb/glow"
  vinden de schakelaars; "for WoW Forever" onder de titel (7 talen).
- Spel: F. Site: nog niet (in bouw, niet getest).

### Forever, mage: waar kan ik Study doen + waar haal ik Light Feathers (vraag van Rob, 21 nov) — ✅ JA + GEBOUWD 21 nov
- Bron: Rob 21 nov via sparring, letterlijk: *"Ja, graag"* (uitzoeken + bouwen).
- Gebouwd: bibliotheek in Stormwind (Garion Wendell) / Undercity (Owen Thadd) op het Comprehension-kaartje, in de Study-
  tooltip, in Find (alleen mages) en als tip in Do this now. Light Feathers: geen verkoper gevonden, ze vallen bij vogels en
  harpijen (zo gezegd in de tekst).
- Spel: F. Site: nog niet (in bouw, niet getest).

### Forever: Waylaid Crates — wat zijn het, en help ermee (vraag van Rob, 21 nov) — ✅ JA + GEBOUWD 21 nov (wacht op Robs test)
- Bron: Rob 21 nov via sparring, letterlijk: *"Waylaid crates zijn het ... wat zijn dat? En ik denk dat wij er ook iets
  mee moeten."* → op de opties (advies: Middel): *"Ja doe maar"*.
- Gebouwd (Middel): tooltip met de bundels + wat je hebt, waar je inlevert, een venster als er een verzegelde krat of
  Shipping Label in je tas komt, de eerste-label-tip, en "Deliver crates" in Find met Favor + rang. ForeverCrates.lua,
  schakelaar `FCRATE_SW` (standaard aan), `/mh crates`.
- Spel: F. Site: in SITE_SEIN, nog niet op de site (in bouw, niet getest).

### Forever: Repair & sell — snel naar iemand die repareert (vraag van Rob, 20 nov) — ✅ JA + GEBOUWD 20 nov
- Bron: Rob 20 nov via sparring, letterlijk: *"Hebben we al iets in onze helper staan waarbij ik aan kan klikken om zo
  snel mogelijk naar iemand of iets te gaan waarbij ik mijn spullen kan repareren en zeker verkopen?"* → op het voorstel:
  *"ja doe maar"*.
- Gebouwd: Find (In town + Which city?) en het Tas vol-venster; 359 reparateurs (Zygor + Wowhead Forever), MH leert bij
  elk verkoopvenster. Daarna (Rob: *"ja doe maar"*) ook een duurzaamheidswaarschuwing in Forever (onder 25%) met
  dezelfde knop: GEBOUWD 20 nov (ForeverDurability.lua, schakelaar standaard aan).
- Spel: F. Site: in SITE_SEIN, nog niet op de site (in bouw, niet getest).

### De testlijst in het spel, alleen voor Rob (verzoek van Rob, 20 nov) — ✅ JA + GEBOUWD 20 nov (wacht op Robs test)
- Bron: Rob 20 nov via sparring, letterlijk: *"Kunnen wij niet een soort zijstapje maken in onze add-on die alleen voor
  mij is? Die dus niet mee gepusht wordt naar de users. Waarbij we het afvinklijstje als één mooi opdrachtenlijst kunnen
  krijgen met een leuke layout in World of Warcraft zelf. Waarbij ik daar vinkjes kan zetten. Waarbij ik eventueel
  opmerkingen kan toevoegen. Waarbij eventueel commando's die ik moet gebruiken daar alvast te kopiëren zijn. In games
  dat ik niet elke keer naar een andere browser moet. En dat ik aan het einde reload kan doen. Dat jij hem kan uitlezen
  om te kijken wat er allemaal gebeurd is, goedgekeurd is. Enzovoort enzovoort. Ik vind dit een mooi project voor nu.
  Kijk maar of het gaat lukken."*
- Gebouwd: aparte addon `MidnightHelper_Testlist` (bron `tools/testlist_addon/`, nooit in de zip), `/mhtest`;
  `run testlist_ingame` bouwt + installeert (retail én Forever), `run testlist_ingame read [--write]` leest terug.
- Spel: M + F (Rob-only). Site: nee.

### Forever een eigen CurseForge-project (optie B) (vraag van Rob, 20 nov) — ⏸️ LATER / NEE VOOR NU
- Bron: Rob 20 nov via sparring, letterlijk: *"Even een vraag... word het niet tijd on de addon te splitsen in addons ??
  Hij lijkt me zo erg groot te worden... en midnight helper zal voor veel mensen nog als een midnight addon zien... of
  heb jij een beter / slimmer idee ?"* → opties A (zo laten) / B (tweede CF-project, één repo) / C (opknippen); B
  uitgezocht. Besluit, letterlijk: *"We houden het nog zoals nu"*. Niets veranderd aan release.yml of de toc's.
- Onderzoek (20 nov): GEMETEN in packager@v2 release.sh: `-p <curse-id>` (ander CF-project), `-a <wago-id>` / `-a 0`,
  `-m <pkgmeta>`. release.yml heeft al twee stappen (`-g retail`, `-g forever`), allebei naar 1528577. B = de
  Forever-stap `-p <nieuw ID>`, een tijd ook nog naar het oude project (bestaande installs volgen het oude project,
  AFGELEID; CF heeft geen verhuisknop), melding in het spel. Rob: CF-project aanmaken (goedkeuring CF, AFGELEID).
  Map MOET MidnightHelper blijven (GEMETEN: toc-namen, SavedVariables MidnightHelperDB, 12 paden in 7 bestanden).
  Titel in de addonlijst is al "Midnight Helper Forever" (GEMETEN). Site: Forever-knop naar het nieuwe adres.
- Spel: F. Site: nee.

### Forever: Find overzichtelijker + een lijst "Steden" (één klik = route) (idee van Rob, 20 nov) — ✅ JA (ontwerp)
- Bron: Rob 20 nov via sparring, letterlijk: *"Stel je voor, ik zit in het ene gebied en ik wil helemaal naar het andere
  gebied. Kan ik dan gewoon een knop indrukken en zetten, oké, ik wil naar Ogrimai. Als ik hoorde ben uiteraard. Terwijl
  ik helemaal op het andere werelddeel zit."* (Willow: Orgrimmar, Horde) en op het voorstel: *"Ja, dit kunnen we nu best
  wel gaan bedenken, denk ik. Maar dan moeten we ook iets gaan vinden op ons standblad Find. Want het is nu één lange
  lijst geworden, wat niet echt meer overzichtelijk wordt. Dus laat iemand bedenken hoe we dat grafisch beter kunnen
  vormgeven in onze model en de layout die we nu hebben in Forever."*
- GEMETEN (20 nov, code): links 6-7 inklapbare koppen (Class 1, Beroepen 12, Wapens per class, Winkels 9, In de stad 4,
  Reizen 2, Rares 2 + één per zone met rares); rechts per regel NPC-/plaatsnaam, "zone · afstand", routezin, knop.
  Stadsdiensten: 181 regels in ForeverCitySpots. Herbergen: 14 (geen Ratchet).
- Ontwerp: 3 opties (A tegels, B zoekveld + Steden-kop, C "Wat / Waar"-schakelaar) naar sparring. Wacht op Robs keuze.
- Optie D op Robs vraag (CharacterScape-stijl, map `_forever_\Interface\AddOns\CharacterForever`, v0.16.25, Amir Ahmadi;
  GEMETEN geen licentie, alleen OFL.txt voor het font → alleen het idee): venster 1040×618, middenpaneel, rechts hoge
  tabbladen 160×44.
- ✅ **Rob kiest D voor het HELE Forever-overzicht** (via sparring, letterlijk: *"Ik ga toch voor d"* en *"Dat klopt zo.
  Vooral de eerste paar die we nu standaard hebben, vind ik super gaaf. Dat moet ik zeker houden."*). Eerst schetsen +
  plan, dan zijn ja, dan stap voor stap. Schetsen (20 nov): `Temp\claude\find_mockups\` A/B/C/D + D_now/D_class/D_find.
  Voorstel: 1100×600 (niet 1040: dan wordt het middenstuk smaller dan nu en Now krapper), portret links blijft,
  inhoud 708 breed (nu 700), tabbladen rechts, subtabbladen (How you play/Class quests/Camping, Characters-groep)
  ingesprongen onder hun tab. Midnight ongewijzigd. Lay-out: geen Fable.
- Stap 1 gebouwd (0ff9d9d). Stap 3 gebouwd 20 nov: Find "What am I looking for? | Which city?" + zoekveld (wacht op
  Robs test). Stap 2 wacht op zijn screenshots. Ratchet ontbreekt nog (geen herberg in onze data).

### Forever: "Dock to window" uit alle vensters (verzoek van Rob, 20 nov) — ✅ JA + GEBOUWD 20 nov (wacht op Robs test)
- Bron: Rob 20 nov via sparring, letterlijk: *"ja haal ze maar uit alle forerver vensters"* (aanleiding: de titel van
  het class-quest-venster liep eronder; eerder, 17 nov: *"het knopje dock en undock is eigenlijk nergens meer nodig"*).
- Gebouwd: `DialogPopup.lua` maakt de knop niet meer in Forever; Midnight houdt hem. Titels in NewChoices en
  ForeverDirection krijgen in Forever een eigen rechtergrens. Spel: F. Site: nee.

### Tas vol: wat kan weg, wat verkopen, wat vernietigen of looten (idee van Rob, 20 nov — nog niet beoordeeld)
- Voor wie:      allebei (AFGELEID)
- Moment:        wanneer je tas vol zit (of bijna). AFGELEID: "inventory full"-moment of BAG_UPDATE_DELAYED; nog niet bepaald.
- Spel:          Forever (Rob 20 nov 07:07: *"Alles gaat over forever en de namen zijn addons"*)
- Bron:          Rob 20 nov 2026, letterlijk (dictaat): *"Voor de ideeënlijst in mijn Midnight Helpen. Destroy and loot.
                 Wanneer je tas vol zit, kijken wat is dan het goedkoopste. Wat is trash of wat we sowieso weg zouden
                 gooien of verkopen. En of wat je kan looten dat beter is of meer waarde heeft."* Voorbeeld van Rob:
                 de addon **All for One**, *"die overigens vreselijk veel opties heeft. Misschien moeten we nog eens een
                 keertje nakijken."*
- Wat Rob bedoelt: bij een volle tas een voorstel doen. (1) Wat is het goedkoopste om kwijt te raken? (2) Wat is trash,
                 of wat gooien/verkopen we sowieso? (3) Als je iets kunt looten (of vernietigen), is dat dan beter of
                 meer waard dan wat er nu in je tas ligt?
- UITGEZOCHT (20 nov, web, NIET in het spel gecontroleerd). Rob zegt dat de namen addons zijn. Dit zijn de beste raadpogingen
                 (AFGELEID, Rob bevestigt of corrigeert):
                 * "Destroy and loot" past op **Improved Forever: Junk** (vroeger "Improved Forever: Destroy"): vindt wat je tas niet
                   meer nodig heeft, verkoopt het bij de verkoper, en als de tas vol is vanuit het lootvenster vernietigt het
                   junk en loot het in de plaats. https://www.curseforge.com/wow/addons/improved-forever-junk
                 * **OAP Lazy Stuff**: lijst met te vernietigen items, gesorteerd op verkoopwaarde (goedkoopste eerst), en
                   markeert bij quest-beloningen de hoogste verkoopwaarde. https://www.curseforge.com/wow/addons/oap-lazy-stuff
                 * **Forever Loot Bag** en **LazyBags** verkopen een aangewezen tas, met bescherming van questitems en
                   beroepsmaterialen. https://www.curseforge.com/wow/addons/forever-loot-bag
                 * "All for One" past op **OneForAll - Forever**: een alles-in-één addon (dungeons, quests, loot, boeken,
                   beroepen, kaarten, talentcalculator), dus "vreselijk veel opties". https://www.curseforge.com/wow/addons/oneforall-forever
                 Licenties niet bekeken: eerst checken, alleen het idee overnemen.
- Bouwt op:      mogelijk `Modules/Openables.lua` (dingen openen), `BagUpgrade.lua` / `LootUpgrade.lua` (tas-blik),
                 en voor Forever het idee H9 "kan ik dit disenchanten?" (`docs/forever/DISENCHANT_2026-11-18.md`).
                 NIET GEMETEN of een deel hiervan al bestaat; dat meten we vóór we iets bouwen.
- Data:          nog te meten. Verkoopprijs per item staat in het spel; wat "meer waard" is bij looten niet zonder
                 meer (AFGELEID). Nooit zelf iets weggooien: alleen voorstellen, de speler beslist.
- Vindbaar:      op het moment dat de tas vol raakt, niet alleen via een commando (toets 6).
- Werk:          middel (AFGELEID)
- Site:          nee
- ⏳ Eerst uitzoeken: wat doet **All for One** precies, en welke van die opties zijn nuttig voor ons? (Rob: "nog eens
                 nakijken"; niet gedaan, NIET GEMETEN. Licentie checken vóór we iets overnemen, alleen het idee, eigen code.)
- Rob zegt:      nog niet beoordeeld (ja / nee / later). 20 nov: Rob koos "3" = eerst uitzoeken (bouwchat).
- UITGEZOCHT 20 nov (mh-research + zelf nagekeken):
                 Blizzards Forever-code (Gethe/wow-ui-source `forever`, 1.60.1.70959) GEMETEN: UseContainerItem zonder
                 HasRestrictions (maar retail blokkeerde MH met dezelfde docs → test), C_MerchantFrame.SellAllJunkItems +
                 knop bestaan (aan in Forever? test), DeleteCursorItem HasRestrictions = true (AFGELEID: alleen op klik),
                 Rare+ = DELETE typen, loot-"tas vol" = UI_ERROR_MESSAGE ERR_INV_FULL bij open lootvenster.
                 Addons (alleen idee): Improved Forever: Junk (MIT), OAP Lazy Stuff (MIT), OneForAll (GPL), Forever Loot
                 Bag / LazyBags / LootOptimizer / Loot Pocket (ARR). Rob heeft er geen (GEMETEN).
                 MH heeft al: ForeverWarnings (tas bijna vol + grijs), ToolGuard, ReagentUse, ItemTips, QuestHint.
                 Opties naar Sparring 20-11 (2): KLEIN (3 goedkoopste + waarom, MH doet niets zelf), MIDDEL (advies: +
                 Destroy-knop op klik en "Sell MH junk", eerst `/mh bagfull test`), GROOT (eigen junklijst, auto-verkoop).
- ✅ JA MIDDEL in twee stappen (Rob via sparring: *"Beide ja"*). Stap 1 GEBOUWD 20 nov (ForeverBagFull.lua); Rob testte:
                 venster + loot werkt, hengel stond er ten onrechte in (gerepareerd). Stap 2 GEBOUWD 20 nov na zijn test
                 (*"toch wil ik graag die knop erbij per stuk. Dat we dat kunnen destroyen."*): Destroy per item, Pick up
                 the loot, MH: sell junk — alleen op een klik. Wacht op Robs test. GROOT = niet gekozen.

### Shortest Path: de kortste weg naar een plek — uitzoeken wat die addon meer doet (idee van Rob, 20 nov — nog niet beoordeeld)
- Voor wie:      allebei (AFGELEID)
- Moment:        als je ergens heen wilt en wilt weten wat de snelste route is. Nog niet bepaald.
- Spel:          Forever (Rob 20 nov 07:07: *"Alles gaat over forever en de namen zijn addons"*)
- Bron:          Rob 20 nov 2026, letterlijk (dictaat): *"Shortest path. Een add-on die kijkt hoe je de kortste weg naar
                 ergens kan doen. Dus die wordt er ook even bij. Moet ook uitzoeken."* Rob noemt geen volledige naam.
                 AFGELEID dat hij **Shortest Path Forever** bedoelt: daar las Rob al op 18 okt over (zie hieronder).
- Wat er al is: GEMETEN in de code (20 nov): `Modules/Travel/TravelGraph.lua` is al een routezoeker (Dijkstra, goedkoopste
                 totale tijd eerst), gemaakt na Robs lezen van hoe Shortest Path Forever plant. Daarnaast `TravelPlanner.lua`
                 (weg naar huis), `TravelPlan.lua` (`/mh plan`) en `ForeverTravel.lua`. Alleen de code van die addon
                 is niet gebruikt (zijn licentie is GPL-3, die van ons MIT, zie de kop van `TravelGraph.lua`).
                 Kosten in `TravelGraph.lua` zijn AFGELEID (gekozen, niet gemeten) en dienen alleen om routes goed te ordenen.
- Wat nog moet:  UITZOEKEN (NIET GEMETEN, niet gedaan): wat die addon nu nog meer kan dan wij? Waar is onze route
                 slechter of ontbreekt hij? Bv. Midnight-doelen blijven bij `WayHome` (zo bewust gekozen op 18 okt).
                 Alleen kijken en het idee overnemen, geen code (GPL-3).
- Bouwt op:      `Modules/Travel/TravelGraph.lua` en `TravelPlan.lua`
- Data:          nog te meten
- Vindbaar:      al zo: `/mh plan`, de pijl en het wapenvenster; of het genoeg gevonden wordt is NIET GEMETEN
- Werk:          eerst klein (uitzoeken), daarna pas een inschatting
- Site:          nee
- Rob zegt:      ✅ JA, uitzoeken (20 nov via sparring, letterlijk: *"Laten we doorgaan met REST XP, shortest path. En
                 dan kijken we wel weer verder."*). Eerst alleen uitzoeken + advies; bouwen pas na Robs keuze.
- Advies (20 nov): 1 Hearthstone + class-teleports, 2 tijd per stap, 3 gevaar-straf, 4 vluchten, 5 boottijden; geen
                 loopkaarten. Rob (via sparring): *"Oké. Ik volg voorlopig eerst je advies. Dus doe inderdaad dan maar je
                 advies, als those teleports. Dan gaan we zo meteen wel kijken wat we eventueel verder doen."*
                 ✅ 1 + 2 GEBOUWD 20 nov in `ForeverTravel.lua` (wacht op Robs test).
                 ⏸️ 3, 4, 5 en loopkaarten: NIET nu (zelfde zin: "zo meteen wel kijken wat we eventueel verder doen").

### Rest XP: waar kan ik makkelijk uitloggen en toch rested XP krijgen (idee van Rob, 20 nov — nog niet beoordeeld)
- Voor wie:      nieuweling (AFGELEID: rested XP is vooral iets van levelen)
- Moment:        als je klaar bent en wilt uitloggen. Nog niet bepaald hoe de speler het ziet.
- Spel:          Forever (Rob 20 nov 07:07: *"Alles gaat over forever en de namen zijn addons"*)
- Bron:          Rob 20 nov 2026, letterlijk (dictaat): *"En dan hebben we REST XP, een add-on, die zoekt waar je makkelijk
                 kan uitloggen op een plek waar je toch REST XP krijgt en stuurt je daar naartoe."* Rob noemt de addon
                 alleen "REST XP"; de volledige naam is NIET GEMETEN.
- Wat Rob bedoelt: de addon wijst de dichtstbijzijnde plek waar je rested XP opbouwt tijdens het uitloggen (AFGELEID: een
                 herberg of hoofdstad) en stuurt je er met een pijl heen.
- Wat er al is: GEMETEN in de code (20 nov): Forever heeft al de herberg als "In town"-plek (`ForeverVendors.lua`,
                 `ForeverCitySpots.lua`, "Show the way"), en rested XP wordt al getoond (`ForeverOverview.lua`,
                 `AltBoardView.lua`). Niet gevonden: iets dat zegt "hier log je uit voor rested XP" of daar op eigen
                 initiatief heen stuurt. Voor Midnight: NIET GEMETEN.
- UITGEZOCHT (20 nov, web, NIET in het spel gecontroleerd): wat Rob beschrijft is **Fennick Rest**: toont je rested XP en
                 hoe lang tot vol, wijst de beste herberg of hoofdstad om uit te loggen, en zegt "Hearth to your inn and log
                 out" als je Hearthstone klaar is. Een pijl wijst naar de herberg. Adviseert alleen vriendelijke herbergen en
                 steden. https://www.curseforge.com/wow/addons/fennick-rest
                 Ook: **RestedAlts** (rested XP van al je alts, waarschuwt bij uitloggen buiten een herberg of stad;
                 daar bouwt rest ongeveer vier keer langzamer) https://www.curseforge.com/wow/addons/restedalts
                 en **XP Ledger** (rested XP en een XP-balk). Licenties niet bekeken.
- Bouwt op:      de herberg-plekken in Forever (`ForeverCitySpots.lua`) en de pijl (`NativeArrow.lua`)
- Data:          nog te meten. Welke plekken rested XP geven (herberg, stad, tent) staat niet in onze data (NIET GEMETEN).
                 Eerst uitzoeken, niet raden.
- Uitzoeken:     wat doet de addon precies, en hoe weet die welke plekken rested XP geven? Alleen het idee, geen code
                 (licentie eerst checken).
- Vindbaar:      zou vanzelf moeten, bv. een melding als je bijna wilt stoppen of in een stad bent. NIET uitgewerkt.
- Werk:          middel (AFGELEID)
- Site:          nee
- Rob zegt:      ✅ JA (20 nov via sparring, letterlijk: *"Laten we doorgaan met REST XP, shortest path. En dan kijken
                 we wel weer verder."*). GEBOUWD 20 nov: `Modules/ForeverRestXP.lua` (venster bij uitloggen buiten
                 een rustplek, regel in de XP-tooltip, `/mh rest [go]`, schakelaar `FREST_SW` standaard aan). Leert
                 dorpsherbergen door `IsResting()`. Fennick Rest = PolyForm (geen open source), RestedAlts = MIT:
                 alleen het idee. Wacht op Robs test.

### Forever: Loot Sparkles — questitems, kruiden en erts laten glinsteren (idee van Rob, 20 nov — Rob vindt dit interessant)
- Voor wie:      allebei (AFGELEID: nieuwelingen missen questitems, veteranen kunnen er hinder van hebben)
- Moment:        bij het inloggen en na een wissel van grafische instelling (zie "Hoe de addon het doet")
- Spel:          Forever
- Bron:          Rob 20 nov 2026, letterlijk (dictaat): *"Forever Loot Sparkle is er nog een. ... Zoek allebei ook maar uit
                 wat het precies is. Vooral die Sparkle die vind ik wel interessant."*
- UITGEZOCHT (20 nov, web, NIET in het spel gecontroleerd): de addon heet **Forever Loot Sparkles** (auteur conoar,
                 GPLv3, voor Forever 1.60.1, bijgewerkt 21 okt 2026, ~60.000 downloads):
                 https://www.curseforge.com/wow/addons/forever-loot-sparkles
                 Icy Veins schreef erover: https://www.icy-veins.com/wow-forever/news/cant-find-that-quest-item-this-addon-puts-the-sparkle-back-in-wow-forever/
- Wat hij doet:  Forever toont lootbare questitems door een uitlijning (outline mode) in plaats van de glinstering. De addon
                 zet de glinstering weer aan. Een grafische preset zet de uitlijning terug aan, dus de addon merkt dat en
                 zet het ongeveer een seconde later weer goed. Hij wacht tot na een gevecht. Optioneel: kruiden en
                 ertsaders laten glinsteren met het verzamelicoon erboven, en questobjecten (die laatste standaard uit).
                 Alles aan en uit te zetten onder Esc > Opties > AddOns.
- Hoe hij het doet: via CVars. Volgens de pagina: `outlineModeShowLootEffectWhenDisabled` = 1 plus `graphicsOutlineMode`,
                 `OutlineEngineMode`, `raidGraphicsOutlineMode` en `RAIDOutlineEngineMode` = 0; voor kruiden en erts
                 meerdere `SoftTargetInteract*` en `SoftTargetIcon*`. De addon bewaart de oude waarden en zet ze terug.
                 ⚠️ Uitzetten vraagt een volledige herstart van het spel, en de addon uitzetten zet de CVars niet terug
                 (staat op de pagina). Deze namen komen van de addon-pagina: KANDIDATEN, geen bewijs. Meten in de client.
- Wat er al is: GEMETEN in de code (20 nov): `Modules/FpsPanel.lua:50` kent al `graphicsOutlineMode` en
                 `raidGraphicsOutlineMode` (uitlijning als FPS-instelling). Geen glinstering-functie gevonden. Dit botst of
                 werkt samen met het FPS-paneel, dat moet eerst nagekeken worden. Elders zetten we al CVars
                 (`KeyBlock.lua`, `ForeverTrainer.lua`), dus het patroon bestaat, mét bewaren en terugzetten.
- Licentie:      GPLv3, wij zijn MIT: dus alleen het idee en het meten van de CVars, geen code kopiëren.
- Bouwt op:      `FpsPanel.lua` en het instellingenvenster; zelfde bewaren/terugzetten als `KeyBlock.lua`
- Data:          nog te meten in Forever: bestaan de CVars echt, en wat doet elk? Niets raden.
- Vindbaar:      één schakelaar in de instellingen, en liefst een tip bij een nieuw Forever-karakter (toets 6)
- Werk:          klein tot middel (AFGELEID), vooral meten
- Site:          misschien (nieuwe functie), `docs/SITE_SEIN.md`
- Rob zegt:      ✅ JA (20 nov via sparring, letterlijk: *"en begin met 4, loot sparkles :)"*). GEBOUWD 20 nov:
                 `Modules/ForeverLootSparkle.lua`, schakelaar `FLS_SW` (standaard uit), `/mh sparkle [on|off]`.
                 GEMETEN in Robs client (probe cvp1/cvp2): alle vijf outline-CVars en vijf SoftTarget-CVars bestaan.
                 Kruiden/erts NIET gebouwd (welke waarden: niet gemeten). Wacht op Robs test.
                 Kruiden/erts: Rob *"ja graag"* (20 nov via sparring) op "eerst uitzoeken, dan meet jij, dan bouwen".
                 UITGEZOCHT (mh-research): GEEN glinster-CVar voor nodes in Blizzards Forever-UI-code; node-addons zetten
                 soft-targeting aan (de game kiest één object bij je, "softinteract") en tekenen zelf. Meting gebouwd:
                 `/mh sparkle nodes` (30 s, daarna alles terug) → `MidnightHelperDB.nodeProbe`.
                 Rob mat het (houweel boven een Copper Vein) en zei: *"ik wil beide met idd de schakelaars"*. GEBOUWD 20 nov:
                 `FNODE_ICON_SW` (icoon van de game) en `FNODE_GLOW_SW` (gloed van MH), allebei standaard uit.
                 Wacht op Robs test.

### Pijl-zin bij een zeppelin, boot of tram: "wacht en stap in" i.p.v. "loop erdoor" (Rob, 20 nov — fout gemeld)
- Rob zegt:      *"Dat is natuurlijk technisch niet correct, want je loopt niet door de Zeppelin heen. Je neemt de
                 Zeppelin. Je komt er nergens anders uit. Dus dat moet nagekeken worden en eventueel opgelost worden."*
                 (Carola zag het op een class-training-route.) GEBOUWD 20 nov: `ns.ArrowAtStepText` in NativeArrow.lua,
                 nieuwe zinnen ARROW_AT_RIDE / _RIDE_SENTENCE / ARROW_AT_SENTENCE (7 talen). Wacht op Robs/Carola's test.

### Forever: Layer Swap — zien op welke layer je zit en wisselen (idee van Rob, 20 nov) — ✅ JA voor onderzoek (23 nov: "Ja, 1, 2 en 3, maar juist ook 3. … We moeten ook zelf kunnen swappen."); onderzoek GEDAAN; Rob koos A + D ("Ik ga uiteraard weer voor jullie advies."); stap 1 (stille meter, /mh layer) GEBOUWD, wacht op Robs 3 metingen
- 23 nov: `docs/forever/LAYER_SWAP_ONDERZOEK_2026-11-23.md`. Kern: het layernummer is in Forever niet meer te lezen (Blizzard
  versleutelt de GUID-velden sinds 16 okt/20 nov; GEMETEN ook in Robs eigen RFC-run van 23 nov: elk monster een ander
  veld 3 en 5). Wisselen naar "een andere" layer kan nog (uitnodiging van iemand op een andere layer), een layer kiezen niet.
  Advies: A (melden dát je verplaatst bent + drukte-meter) + D (knop naar een wissel-addon als die er is); B (zelf vragen
  via bestaande hosts) pas later en alleen met toestemming; C (eigen MH-netwerk) niet.
- Voor wie:      veteraan en nieuweling (AFGELEID)
- Moment:        als een zone druk is of je met vrienden op dezelfde layer wilt
- Spel:          Forever (de addon werkt ook op Classic Era en TBC Anniversary)
- Bron:          Rob 20 nov 2026, letterlijk: *"En Layer Swap. Zoek allebei ook maar uit wat het precies is."* Rob noemt
                 geen schrijver. AFGELEID dat hij **Layer-Swap** (Adam5288) bedoelt; er zijn meer addons met bijna dezelfde
                 naam, zie "Andere addons".
- UITGEZOCHT (20 nov, web, NIET in het spel gecontroleerd): **Layer-Swap** v2.5.6, All Rights Reserved, bijgewerkt
                 21 okt 2026, ~43.300 downloads: https://www.curseforge.com/wow/addons/layer
- Wat hij doet: toont op welke layer (server-kopie van de wereld) je zit, onthoudt layers waar je was, en laat je met één
                 klik een wissel vragen. Je kunt ook zelf wisselingen hosten voor anderen.
- Hoe hij het doet: de layer wordt afgelezen uit NPC's bij je in de buurt (aanwijzen of selecteren). Je vraag gaat naar het
                 kanaal `layer` met je zone en layer. Een host op een andere layer nodigt je uit; als je accepteert zit je
                 in zijn groep en op zijn layer. Doet de host het niet, dan verlaat de addon de groep en kun je opnieuw
                 vragen. Hosten nodigt alleen uit als je alleen bent of een eigen groep leidt.
- Andere addons: Abatti's Layer Swap, Forever Layer Hop (laat je zien welke layers een host hebben), GuildLayers (via gilde).
- Licentie:      All Rights Reserved: NIETS overnemen, alleen het idee.
- Hoort het bij MH? Twijfel (AFGELEID, geen meting): dit is een andere soort addon dan wegwijzers en planning. Het werkt alleen
                 als er anderen met een host-addon zijn, en het raakt chat en uitnodigingen (net als O6 "snelle chatregels",
                 waar de vraag was of chat in 12.x/Forever het toelaat). Er is al een aparte addon voor, met veel downloads.
                 Wel mogelijk: alleen "op welke layer zit ik" als kleine regel, zonder swap. NIET onderzocht.
- Bouwt op:      niets dat we al hebben (GEMETEN: niets over layers in `Modules/`)
- Data:          nog te meten (hoe Forever layers aan NPC-GUID's koppelt)
- Vindbaar:      nog niet bepaald
- Werk:          groot als swap, klein als alleen weergave (AFGELEID)
- Site:          nee
- Rob zegt:      nog niet beoordeeld (ja / nee / later)

### Skill up voor je beroepen (idee van Rob, 20 nov — nog erg kort, nog niet beoordeeld)
- Voor wie:      nieuweling (AFGELEID)
- Moment:        nog niet bepaald
- Spel:          Forever (Rob 20 nov 07:07: *"Alles gaat over forever en de namen zijn addons"*)
- Bron:          Rob 20 nov 2026, letterlijk (dictaat): *"Skill up voor je professions."* Verder niets gezegd: of het een
                 addon is, hoe die heet, en voor welk spel (Midnight of Forever) is NIET bekend. Niet ingevuld, niet geraden.
- Wat er al is: GEMETEN in de code (20 nov): veel rond beroepen. `ProfessionNextStep.lua`, `ProfessionGuided.lua`,
                 `ProfessionsHub.lua`, `ProfessionAcademy.lua`, `ForeverProfGuide.lua` (Forever-gids), `ForeverProfTrainers.lua`.
                 NIET GEMETEN of daar al een "wat moet ik maken om te skillen / wat is het goedkoopst" in zit.
- UITGEZOCHT (20 nov, web, NIET in het spel gecontroleerd): de naam "Skill up" past het best op **SkillUp Forever**: toont
                 per recept de vereiste skill, kleurgrenzen en kans op een skill-up, plus kosten per skill-up, met een
                 levelroute en boodschappenlijst in een zijpaneel. https://www.curseforge.com/wow/addons/skillup-forever
                 Er zijn meer addons met hetzelfde doel (Rob kan er een andere bedoelen): **Skillwright** (goedkoopste of
                 snelste route), **CraftForge** (route van je skill tot 300), **ProfessionsTracker** (goedkoopste skill-up),
                 **Forever Profession Master**, **Mastercraft**, **My Forever Profession** (meldt zodra je een rang kunt leren).
- Wat wij al hebben, GEMETEN: `ForeverProfGuide.lua` geeft per beroep een korte kaart (wat het doet, rangen 75/150/225/300),
                 maar GEEN skill-up-route, geen kans op een skill-up en geen kosten (kosten staan er bewust niet in omdat ze
                 niet gemeten waren). Dus dit is een echt gat. Eerst Rob vragen welke addon hij bedoelt.
- Bouwt op:      `ForeverProfGuide.lua` + de DB2-pijplijn van `tools/forever_reagents.py` (ReagentUse). ProfessionNextStep
                 en CraftShoppingList laden NIET in Forever (GEMETEN in MidnightHelper_Camelot.toc).
- Data:          GEMETEN Forever-DB2 1.60.1.70959: SkillLineAbility.TrivialSkillLineRankLow = geel, ..High = grijs
                 (Rough Sharpening Stone 2660: 15/55); SpellReagents; ItemSparse.SellPrice. Geen groen-kolom (groen =
                 midden, AFGELEID). MinSkillLineRank ≠ leer-skill (2665: Min 75, grijs 55). Forever ≠ Classic-waarden.
                 Kans (grijs − skill)/(grijs − geel) = community-formule (Wowpedia), AFGELEID. Niet in clientdata: AH-prijs,
                 welke verkoper wat verkoopt, trainerkosten, leer-skill.
- Andere addons: SkillUp Forever (GPL), Skillwright / CraftForge / ProfessionsTracker (MIT) — alleen het idee.
- Opties (20 nov naar Sparring 20-11 (2)): KLEIN kleuren + kans in tooltip; MIDDEL (advies) + kaart "Volgende stap"
                 per beroep met boodschappenlijst en route naar de trainer, zonder geld; GROOT + kosten via Auctionator,
                 route tot 300. Eerst in het spel meten of de Forever-client zelf de receptkleur geeft.
- Werk:          klein / middel / groot (AFGELEID)
- Site:          nee
- Rob zegt:      "We gaan voor idee 6 om mee te beginnen" (20 nov, via sparring); daarna op MIDDEL: *"Ja, begin daar
                 dan mee. Het geld kunnen we inderdaad later bekijken."* → ✅ JA, MIDDEL GEBOUWD 20 nov (wacht op Robs
                 test, TESTLIJST "Skill up"). ⏸️ GROOT (kosten per punt via Auctionator/verkoperprijzen, route tot 300,
                 goedkoopst/snelst) = LATER.

### Midnight: de eerste blik bij openen, zoals het Forever-overzicht (22 nov: ✅ JA, LATER, zie "drie ideeën" bovenaan)
- Bron: Rob 18 nov (via Sparring 18-11), letterlijk: *"Ik denk dat we het nooit zo mooi kunnen krijgen als de forever
  versie omdat we al zoveel hebben in midnight, we pauzeren dit tot na de Claude Code reset 🙂 , wat ik juist mooi vond
  van onze forever versie is de eerste blik die je ziet als je MH opent :)"*
- 🔑 Kern van de wens: de EERSTE BLIK bij het openen van MH — een overzicht als voordeur, zoals `/mh overview` in Forever.
  Niet per se een nieuwe jas voor het hele venster.
- Wat er al ligt: proefplaatje "Midnight in stijl A" (optie 1 = alleen de jas), commit 2d25d45,
  `docs/ontwerp/midnight_stijl_A_2026-11-18.html` + `.png`. Gemeten die dag: ForeverStyle.lua stopt in Midnight
  (r. 29 `if not ns.IS_FOREVER`); UI.lua heeft al `LOOK_PALETTE` (r. 220) + schakelaar Classic/nieuw; 4 kamers, 24
  tabbladen. Spel: M. Voor wie: N + V (AFGELEID). ⏳ Na de reset: Rob kiest opnieuw.

### Bedanken voor een buff (zoals "Thanks for the Buff") — ✅ JA + GEBOUWD 19 nov (wacht op Robs test)
- Rob 19 nov (via sparring), letterlijk: *"3 wil ik wel hebben, maar daar hebben we het dan wel over"* → *"Ik wil dan
  iets hebben als mijn naam bedankt je voor de buff naam, enjoy the game"* → na de uitleg definitief: *"Nee dan de
  manier met de vaste dingen die de andere addon ook heeft, niet in de whisper"*. Dus stand (3): automatisch de
  spel-emote THANK, geen whisper, geen eigen tekst (de "enjoy the game"-zin vervalt).
- Gebouwd: `Modules/ThanksBuff.lua` (beide spellen, NIEUW bestand → spel helemaal herstarten). Schakelaar standaard UIT
  (Midnight-instellingen `mh_thanksBuff` + Quiet helpers in Forever), `/mh thanks on|off|test`. Zwijgt als TFTB geladen
  is. TFTB-licentie: GEMETEN geen LICENSE-bestand en niets in de README → alleen het idee/de API-aanpak, eigen code.
- 20 nov: pauze per speler 1 uur → 5 minuten (Rob via sparring: *"zet die uur maar naar 5 minuten"*; 339bc8e).
- ❌ **Extra TFTB-functies NEE** (zwaaien, fluisteren, knop, Good News). Rob 20 nov via sparring, letterlijk: *"nah,
  vergeet die thanks verder maar, we houden het zo, sorry"*. Niet opnieuw voorstellen.
- Hieronder het onderzoek van 17 nov (ongewijzigd).
- Bron: Rob 17 nov (via Sparring 17-11), letterlijk: *"Wat me opvalt is, als ik sommige mensen een buff geef tijdens het
  passeren, dan bedanken ze me direct. Is dat een auto-reply of een iets? ... Kan je dat voor mij nakijken? Dat ik dat
  ook kan maken?"* en daarna: *"Ik volg jouw advies en zet dat thank you idee maar eventjes op de ideeënlijst.
  Ondertussen zet ik thanks voor de buff maar eventjes als add-on aan."*
- Onderzoek (sparring, mh-research Opus, 17 nov, alleen gelezen; bronnen in `Temp\claude\tftb_src_1117\`): addons
  "Thanks for the Buff" en Manners (MIT); Kindred/BuffBack/DriveByBuffs/BuffResponder (ARR) en BuffThanks/AutoThank
  (GPLv3): niet kopiëren. Detectie zonder CLEU: UNIT_AURA player addedAuras → aura.sourceUnit of
  C_UnitAuras.GetAuraCasterGUID + UnitNameFromGUID. Retail 12.1: payload secret als auras secret zijn → alleen buiten
  combat/instances. Terugzeggen: C_ChatInfo.PerformEmote(token, target) zonder hardware event (wiki); SAY/YELL/EMOTE
  met eigen tekst wél met hardware event; fluisteren mag; retail chat-lockdown in encounter/M+/PvP/dungeon.
  Niet gemeten: sourceUnit/CasterGUID leesbaar voor een vreemde, PerformEmote met unit-token, lockdown op PerformEmote.
- Voorstel (sparring): schakelaar standaard UIT; standen (1) alleen melding, (2) melding + klik om te bedanken
  (veiligst, ook retail), (3) automatisch gericht /thank; fluisteren apart; nooit in combat/instance/BG, niet bij secret
  auras, geen groepsleden/ignore, alleen lange klassebuffs, pauze na laadscherm, cooldown per persoon; `/mh thanks`-
  diagnose. Herbruikbaar: ns.MH_SendChat, ns.Aura.Trusted, MidnightToast, ForeverBuffs/MissingBuffData.
  Spel: F + M. ⏳ Rob kiest.

### Forever: elke class een wapenquest op het juiste level — ✅ JA + GEBOUWD 18 nov (wacht op Robs test)
- Rob via sparring, letterlijk: *"Oh en 1 t/m 3 mag ook"* (2 = wapenquests). Gebouwd: warrior "first weapon" (5 routes,
  10), warlock Soran'ruk (20) / Orahil (35) / An Imp's Request (50), shaman The Tempest's Weapons (30). Al aanwezig: o.a.
  Whirlwind, Verigan's Fist, Wolfsbane, Blade of Cunning, Mage's Wand, de level-50-ronde. Onderzoek:
  `docs/forever/WAPENQUESTS_ONDERZOEK_2026-11-18.md`. Melding bij level-up: niet apart gebouwd (Do this now ververst al
  bij PLAYER_LEVEL_UP, AFGELEID); voorstel `weapon = true` + kaartregel + schakelaar ligt open.
- ❌ **NEE: geen aparte level-up-melding** (Rob 19 nov via sparring, letterlijk: *"Ja, die mogen door"*, op het advies
  om hem niet te bouwen). Reden: "Do this now" toont de wapenquest al zodra je het level hebt en ververst bij een
  level-up; een tweede melding zegt hetzelfde nog eens. Niet opnieuw voorstellen.
- ✅ **Windshaper (Skyborne) shaman ziet nu ook The Tempest's Weapons** (Rob, zelfde ja; bronnen oneens: lfcarry ja,
  QF/FQL noemen alleen Orc/Tauren/Troll). GEBOUWD 19 nov: Skyborne in de rassen van de Horde-keten. Wacht op een test.
- (Oorspronkelijke notitie hieronder.)
- Bron: Rob 17 nov (via Sparring 17-11): idee *"Elk class krijgt op een bepaald level een quest ... voor een bepaald
  wapen"*. Onderzocht (sparring, alleen gelezen): 8/9 classes hebben wapenquests; de level-52 Sunken Temple-ronde geeft
  7/9 een wapen (niet warrior/rogue); vroege toppers Whirlwind 30, Verigan's Fist 20 (A), Wolfsbane 20-26 (Undead pal,
  nieuw), Shaman Tempest 30 (nieuw), Mage's Wand 30, Staff of Soran'ruk 1740 (20-25).
- Voorstel: reward-itemids + optional-vlag in ForeverClassQuests, melding bij level-up (schakelaar), stoppen bij beter
  wapen of ver boven het level (de eerste stap daarvan, `ITEM_CHAIN_SPAN` = 10, staat er al sinds 17 nov), koppeling
  ForeverWeapons. Spel: F. ⏳ Rob kiest.

### Uit de vragenlijst (echte spelers) — naast de toets gelegd, 10 nov

**Uitkomst: drie van de vijf wensen zijn al gebouwd.** GEMETEN in de code (niet in het spel). Ze staan nu onder "Af".
Wat overblijft:

| # | idee | voor wie | spel | bron | stand in de code | werk | mijn advies |
|---|---|---|---|---|---|---|---|
| S1 | **Onderdelen beter vindbaar maken.** Geteld in de 31 antwoorden, kolom "nooit / onbekend": keybind-coach 14, M+ 12, site 12, beroepen 10, "Zo speel je" 9, kaarten 9, brez 9, gear 8. (Die kolom zegt "nooit óf onbekend": wie solo speelt en M+ niet gebruikt, mist niets.) | N + V | M + F | vragenlijst | Er is al: Start Here, de rondleiding (`Tour.lua`), de zoekbalk, de kamers met kaartjes. | middel | **Ja.** Zie de drie vormen hieronder. |
| S4 | **Zichtbare route om een delve sneller te doen.** | V | M | vragenlijst #27 (29 okt) | GEMETEN: er is een kisten-route (`DelveCoach.lua:1066-1073`). Een "snelste pad" bestaat niet. | groot | **Later.** Zakt op vraag 4 van de toets: de snelste weg door een delve is niet te meten in het spel. We zouden hem moeten verzinnen of overnemen. Wat wel kan: je eigen tijden per kamer tonen (bestaat al voor de Labyrinth). |

**S1 in drie vormen (mijn voorstel, Rob kiest):**

1. **"Je bent 90. Dit is wat je nu doet."** Eén keer, op het moment dat je het hoogste level haalt: een kort venster
   dat naar "My gear: what now?" en Start Here wijst. Precies de vraag van vragenlijst #24. GEMETEN: niets in de addon
   doet nu iets op dat moment behalve een balk verversen (`ZoneLevelGate.lua:349`). Toets: nieuweling, moment is
   aanwijsbaar, bron is een speler, data is meetbaar (je level), bouwt op bestaande vensters. Werk: klein.
2. **Een zesde vraag in de toets: "Hoe vindt de speler dit?"** Elk nieuw onderdeel krijgt een plek waar de speler het
   tegenkomt op het moment dat hij het nodig heeft. Geen bouwwerk, een regel.
3. **De keybind-coach apart bekijken.** Minst bekend, 1 van de 31 gebruikt hem vaak. Vraag voor Rob: is dat een
   vindbaarheidsprobleem, of is het een onderdeel voor weinig mensen? Dat is geen meting maar een keuze.

De twee bugs uit vragenlijst #27 zijn geen ideeën. GEMETEN: op 30 okt kwam er een schakelaar "vensterplek per
character" (`SettingsDefs.lua`), een dag na die melding. Of dat de bug oplost, en of het kamerkaartje nog verdwijnt:
NIET GEMETEN.

### Nooit gebouwd

| # | idee | voor wie | spel | bron | stand in de code | werk |
|---|---|---|---|---|---|---|
| O1 | ⏸️ **LATER** (Rob 19 nov via sparring, geen ja; advies: pas als een speler erom vraagt). **Toetsen ook op Dominos en EllesmereUI.** | V | M | oude lijst A2 | GEMETEN: half af. `LiveKeys.lua:9-11` leest sinds 10 okt Bartender4 en ElvUI; Dominos en EllesmereUI nog niet. | middel |
| O2 | **Groeps-kickscore na de run** (wie kickte wat). Werkt alleen als iedereen MH heeft. | V | M | oude lijst A4 | GEMETEN: niet gebouwd (`Comms.lua` kent geen kick; `InterruptScore.lua` zegt "Phase 2"). | groot |
| O3 | **Schat-tussenstappen apart afvinken.** | N + V | M | oude lijst A5 | NIET GEMETEN | middel |
| O4 | **Trading Post: 3D-model en vastzetten.** | V | M | oude lijst A6 | GEMETEN: "heb je al" voor transmog is gebouwd (10 okt, `TradingPost.lua:213`). 3D-model en vastzetten: NIET GEMETEN. | middel |
| O5 | ❌ **NIETS TE BOUWEN** (Rob 19 nov *"1 en 2 ja"*; nagemeten die dag). GEMETEN 12.1.5.70961: Rapture 47536, Spirit Shell 109964, Symbol of Hope 64901 en de oude Grove Guardians 102693 zijn geen talent meer (TraitDefinition: 0; tegencontrole Tranquility 740: wel); Flourish 197721 is een talent zonder cooldown (SpellCooldowns: geen rij; Tranquility: 180 s) = passief. Zelfde uitkomst als `docs/HEALER_CDS_FACTS_2026-10-09.md`. **Extra healer-cooldowns** (Rapture, Spirit Shell, Symbol of Hope, Flourish, Grove Guardians). | V | M | oude lijst A7 | GEMETEN: niet gebouwd (0 treffers in `HealerCooldowns.lua`; Tranquility wel). | klein |
| O6 | **Snelle chatregels** naar je groep. | V | M | oude lijst A9 | GEMETEN: niet gebouwd. Of chat in 12.x dit toelaat is onbekend. | middel |
| O7 | **Keybind-opties** (volgorde op gebruik, "lastige toets", tweede kick). | V | M | oude lijst A10 | GEMETEN: niet gebouwd. Het toetsenblok vervangt dit mogelijk (AFGELEID). | middel |
| O8 | **Rustig overstappen**: een paar toetsen per week. | N | M | oude lijst A11 | NIET GEMETEN | middel |
| O9 | **Sneltoetsen voor alle schermen.** | V | M | oude lijst A13 | GEMETEN: `Bindings.xml` heeft er 8. De keypad-commando's dekken hetzelfde. | klein |
| O10 | **Paneel voor 12-knopsmuizen.** Mogelijk achterhaald (Rob 4 okt: muis leeg). | V | M | oude lijst A14 | NIET GEMETEN | middel |
| O11 | **Buff-herinnering noemen op CurseForge.** Geen code. | — | M | oude lijst A15 | GEMETEN: "buff" komt 1× voor in `CURSEFORGE_DESCRIPTION.md`. | klein |
| O12 | **FastMark via de nieuwere techniek.** De speler merkt niets. | — | M | oude lijst A17 | GEMETEN: gebruikt nog `/tm`. | klein |
| O13 | **Teller wekelijkse Knowledge-drops** ("1 van 2 deze week"). | V | M | oude lijst D1 (Rob 13 sep: "voor later") | GEMETEN: niet gebouwd (item 259197 komt 0× voor). | middel |
| O14 | ✅ **JA (Rob 19 nov: *"1 en 2 ja"*); 20 nov Rob via sparring *"1"* = één regel "Renown (hele account)" bovenaan. GEBOUWD 20 nov (AltOverview.lua), wacht op Robs test.** GEMETEN 19 nov (Faction DB2 12.1.5.70961): elke renown-factie (TWW 2590/2600, Midnight 2710) heeft Flags-bit 4, de oude per-character factie Stormwind (72) niet. AFGELEID: bit 4 = account-breed (warband), dus een renown-kolom per character toont overal hetzelfde getal. Voorstel: één regel "Renown (hele account)" bovenaan het overzicht, plus per character alleen facties zónder dat bit. Eerst Robs keuze. **Renown en reputatie in het alt-overzicht.** | V | M | oude lijst D2 | GEMETEN: niet gebouwd (0 treffers in `AltOverview.lua`). | middel |
| O15 | **Flask, eten en olie met één knop.** | V | M | oude lijst D4 | NIET GEMETEN | middel |
| O16 | **Kadertje bij een gekozen rare** met portret en afstand. | N + V | M | oude lijst D5 | NIET GEMETEN | middel |
| O17 | **Meer wekelijkse klussen** (prey, Soirée, Haranir, Stormarion, World Tour, "waarom groen"). | V | M | oude lijst D6 | NIET GEMETEN. Darkmoon Faire staat alleen in Forever (`ForeverWeek.lua`). | groot |
| O18 | **"Jouw Seizoen 2"** (zoals Spotify Wrapped). Advies was: venster pas vlak voor het einde van het seizoen. | V | M | `PLAN_IDEEEN` idee A | GEMETEN: geen venster, geen `/mh wrapped`. De tellers lopen wel (`SeasonStats.lua`). | middel |
| O19 | **Valeera's dagboek**: één regel per run. | N + V | M | `PLAN_IDEEEN` idee C | GEMETEN: geen dagboek. Het verhaal per run wordt wel bewaard (`DelveHistory.lua`). | groot (vertalen) |
| O20 | **Forever: voorraad-waarschuwing, writ-helper, Omnium Folio 6/7.** | N + V | F | `NEXT_SESSION.md` regel "Later" (10 nov) | NIET GEMETEN | ? |
| O21 | **Accountoverzicht in Forever** (al je characters op een rij). | V | F | Rob, 11 nov: *"we missen ons account overzicht in forever"*; opnieuw 12 nov (via sparring): *"Wat we ook nog open hebben staan volgens mij is de account overview."* | GEMETEN 11 nov: `AltOverview.lua`, `AccountWeeklyChecklist.lua` en `CurrencyAccount.lua` staan alleen in `MidnightHelper.toc`, niet in `MidnightHelper_Camelot.toc` (tegencontrole: ForeverWeek/ForeverTravel wél gevonden). **Ja, gebouwd 12 nov** (Rob via sparring, letterlijk: *"De vijf van het advies, bouwen (Recommended)"*): `Modules/ForeverChars.lua`, venster "Your characters", `/mh alts`. Per character level + class, goud (+ totaal), beroepen met skill, richting, laatst gespeeld, spells klaar bij de trainer. NIET: tasplekken, rust-XP, raid-locks (later, na een meting), gespeelde tijd. GEMETEN offline: foto, venster, totaal en "vergeet" goed. Wacht op Robs test. | middel |
| O22 | ✅ **GEBOUWD 16 nov, alleen reden (b)** — zie "Zes kleine ideeën" punt 2 (`ForeverItemTips.lua`, in 5.4.0). (a) en (c) vielen af na meting. Rob 19 nov opnieuw *"1 … ja"*: zie die sectie. **Forever: de tooltip zegt "dit heb je niet meer nodig, omdat…"** Bijvoorbeeld: recept ken je al, jouw class kan het nooit dragen, eten is te zwak voor je level. Eén extra regel naast "Used for …". | N + V | F | Rob, 12 nov, na het bekijken van de addon Keep or Toss: Forever (Aquary, CurseForge, All Rights Reserved: alleen het idee, geen code of data): *"Zet inderdaad punt 1 en 2 maar als idee in onze ideeënbox."* | GEMETEN 12 nov: `ReagentUse.lua` zegt alleen waar een item vóór is ("Used for"), nooit dat je het niet meer nodig hebt; grep op `already known` en `ITEM_SPELL_KNOWN` in `Modules/` gaf niets (tegencontrole: "Used for" wél gevonden, 3 keer in `ReagentUse.lua`). NIET GEMETEN: welke van de redenen de Forever-client zelf prijsgeeft (bekend recept, draagbaarheid per class, eten per level). Eerst meten, per reden. Geen `/mh`-diagnose bedacht; `/mh usedfor` ligt voor de hand. | klein tot middel? |
| O23 | ✅ **GEBOUWD 16 nov** — zie "Zes kleine ideeën" punt 3 (`ForeverItemTips.lua`, in 5.4.0; Robs client-meting 16 nov gedaan). Wacht alleen op Robs test (TESTLIJST 16 nov). **Forever: de tooltip zegt dat een item nodig is voor een quest in je log.** Alleen de quests die je hebt, zonder Questie. Keep or Toss doet ook "quest die je nog niet hebt", maar leest dat uit Questie; dat deel nemen we niet over. | N + V | F | Rob, 12 nov, zelfde bron en zelfde zin als O22. | GEMETEN 12 nov: geen tooltip-module leest quest-doelen. `GetQuestLogLeaderBoard` en `C_QuestLog.GetQuestObjectives` komen alleen voor in `LayoutWizard.lua`, `AtalUtekProbe.lua` en `Achievements.lua` (zelfde grep, zelfde tegencontrole als O22). NIET GEMETEN: of de Forever-client bij een quest-doel het item-id geeft of alleen een naam, en of Blizzards eigen tooltip dit al zegt ("Quest Item"). Eerst in de client meten. | klein? |
| O24 | **Forever: een knop met een oude rank licht op, op de balk zelf.** Nu zegt MH het in de chat en met een knop onder het trainervenster; Rob: "niemand kijkt in de chat", en *"niet iedereen zal onze Keys layout gebruiken"*. Oplichten op de eigen knop bereikt iedereen, welke balken iemand ook heeft. | N + V | F | Rob, 12 nov, na het bekijken van de addon Glowing Bars (vattiss, CurseForge, MIT): *"inderdaad ook onze ideeën die je geeft, doe maar."* Alleen oude ranks; de rest van Glowing Bars (procs, cooldowns, wapenbuffs, groepsbuffs, reagents) bouwen we niet na. | GEMETEN 12 nov: `ForeverRanks.lua` weet al welke knoppen het zijn (loopt plek 1 t/m 180 langs, volgens zijn eigen kop; de hele code niet nagelopen). Grep op `ShowOverlayGlow`, `LibCustomGlow` en `ActionButtonSpellAlertManager` in alle `.lua` en `.toc` gaf niets; ⚠️ zonder goede tegencontrole, dus dit bewijst niet dat er geen gloed-code is. Hoe `/mh glow` in Midnight tekent is NIET nagelopen, en of dat in Forever kan ook niet. NIET GEMETEN: hoe je in Forever bij de knop van een balk-addon (Bartender4, Dominos, ElvUI) komt. Diagnose: `/mh ranks` bestaat al. **Ja, gebouwd 12 nov** (Rob via sparring, letterlijk: *"ja bouw oude reank"*; keuzes *"Eigen rustige rand (Recommended)"*, *"Aan (Recommended)"*, *"Elke lagere rank (Recommended)"*; meting *"1 61 table nil"*): in `ForeverRanks.lua` een oranje rand met pijltje op Blizzards eigen knoppen (8 balken × 12), fel bij net geleerd, zacht bij een zelf neergezette lage rank. Instelling + `/mh ranks glow on/off`; `/mh ranks` zegt wat hij tekent. Geen nieuw bestand. GEMETEN offline: 6 gevallen goed. Wacht op Robs test. | klein |
| O26 | **Forever: uitleg over de beroepen**, zoals Midnight die heeft (wat elk beroep doet, hoe je het traint, wat je ervoor nodig hebt). Forever-beroepen zijn anders en volgens Rob eenvoudiger. | N + V | F | Rob, 12 nov (via sparring): *"De professions zijn dit keer uiteraard anders dan wat we hebben in Midnight. Ik denk dat ze eenvoudiger zijn. Maar we weten er helemaal niks van. Ook daar wil ik weer zoiets voor gaan maken."* "Forever" is AFGELEID uit de context (Rob zei het woord niet); *"voor de volgende keer. Of voor op de lijst."* | GEMETEN 12 nov in `MidnightHelper_Camelot.toc` (grep "prof": 3 treffers, dus het patroon werkt): Forever heeft alleen de trainerplekken (`ForeverProfTrainerSpots.lua`, `ForeverProfTrainers.lua`), de gereedschapsverkopers en de "Used for"-tooltip. Geen beroepengids; de Midnight-modules (`Profession*.lua`) staan niet in die toc. Inhoud (skill-drempels, recepten, trainers per niveau) NIET GEMETEN; `run gamedata … --game forever` is de eerste bron. 🔎 **Uitgezocht 12 nov** (Rob via sparring: *"Beroepen: uitzoeken"*): `docs/forever/BEROEPEN_2026-11-12.md`, tabel voor Rob bovenaan. **Versie A gebouwd 12 nov** (Rob via sparring: *"A, eerst klein"*): kaartje per beroep in Profession trainers + regel in "Do this now" (`ForeverProfGuide.lua`). Versie B (Camping, beroep bij richting, Comprehension/Poisons, recepten): later. | groot? |
| O27 | **Groepspaneel: MH legt een rode rij zelf vast**, zodat Rob als tank geen screenshots of `/mh glow` midden in een gevecht hoeft te doen. Na een `/reload` lezen wij het uit de SavedVariables. Alleen meten, niets zichtbaars. | V | M | Rob, 12 nov (via sparring): *"kunnen we iets bouwen waarbij dat automatisch kunnen checken? Nadat ik een reload doet of iets dergelijks. Want het is erg lastig om het allemaal in de gaten te houden. Zeker als tank zijn."* | GEMETEN 12 nov in de code: de rode gloed is een eigen frame (`canvas`) als kind van Blizzards aura-slot (`PartyTargets.lua` PaintDispelSlot), dus de engine toont en verbergt hem; `castLog` (laatste 12 casts en fouten) en de na-gevecht-scan (`dispelSelfLog`, nu met char/spec) bestaan al. NIET GEMETEN: of OnShow/OnHide van dat frame in een gevecht vuurt en of IsShown dan leesbaar is (eerste stap van het plan). Welke debuff het is, kan in een gevecht niet (scannen geweigerd). Rob (via sparring): *"Ja, bouw het"* → gebouwd 12 nov (`dispelRowLog`), maar het seintje mat de opbouw van het paneel, niet het rood (run 12 nov). Rob: *"Optie A, dispel-pogingen"* → **Gebouwd 12 nov:** `dispelTryLog` (eigen dispel-casts en fouten op een dispel-helft, met rij). Wacht op één dungeonrun + `/reload`. | klein tot middel |
| O25 | **Forever: MH zwijgt over oude ranks als Glowing Bars aan staat.** Anders melden twee addons hetzelfde. Hoort bij O24. | V | F | Rob, 12 nov, zelfde bron en zelfde zin als O24. | GEMETEN 12 nov: `ForeverRanks.lua` vraagt nergens of een andere addon geladen is (grep op `IsAddOnLoaded("` in dat bestand: niets; geen tegencontrole in dezelfde run). AFGELEID: de map heet `GlowingBars` (uit de naam van hun zip, `GlowingBars-3.0.0.zip`); in Robs addon-map meten. Een speler moet het terug kunnen zetten (CLAUDE.md, de WaypointUI-les): zwijgen mag niet stil, `/mh ranks` moet zeggen dat en waarom. **Gebouwd 12 nov, met O24.** GEMETEN: Glowing Bars staat NIET in Robs Forever-map (Glob op `Glow*/*.toc`: niets; tegencontrole: `Lueur/Lueur.toc` wél gevonden, dat is een erts/kruiden-gloed, geen balken). Daarom zoekt MH op mapnaam OF titel, zonder spaties/kleuren, naar "glowingbars": een andere mapnaam met dezelfde titel wordt toch gevonden. Zwijgt de rand, dan zegt `/mh ranks` dat met de naam; `/mh ranks glow on` tekent toch. De rest van ForeverRanks (chatregel, knop onder de trainer) blijft gewoon. | klein |
| O28 | **Lint [28]: knoppen waar de tekst niet in past.** Gebouwd 12 nov (`tools/button_width_check.py`, SOFT). De 18 knoppen: 17 verbreed op Robs keuze *"Alle 18 repareren (Recommended)"* (12 nov, `ns.FitButtonToText`); de Route-knop in het dungeonvenster bewust niet (≈2 px, geen ruimte). | wij | M + F | Rob, 12 nov (via sparring): *"kunnen we dit soort dingen niet door jou laten doen … kan je het dan niet zelf checken?"* → *"Ja, bouw dat"*. | GEMETEN: proef (21.png-knop) en tegenproef slagen; 37 knoppen bekeken, 18 gemeld (schatting, tekens × 6,5 px). | klein per knop |
| O29 | **Venster "Nieuw in deze versie: jouw keuze"** (plan 1). Na een update kaartjes om zelf te kiezen: "Doe dit nu" (3 standen, Forever), groepspaneel aan/uit (Forever), vaste toetsen ("Laat zien" opent `/mh block`, zet zelf nooit iets). Komt in plaats van de changelog als er iets te kiezen valt. `/mh new`, knop "Keuzes" in de changelog. | N + V | M + F | Rob, 12 nov (via sparring): *"Ook wanneer mensen onze keylayout nog niet hebben moet dit ook waorden laten zien en een keuze krijgen"*; keuzes letterlijk *"Keuzes in plaats van changelog (Recommended)"*, *"Iedereen (Recommended)"*, *"Niet tonen (Recommended)"*, bouw-ja *"Ja, bouw het (Recommended)"*. | **Ja, gebouwd 12 nov** (`Modules/NewChoices.lua`). Daarna (zelfde avond) een kaartje "Party targets" voor Midnight erbij: dat stond in Robs eerste zin (*"Misschien ook een idee om dit met de party targets te doen"*) en viel weg in de uitwerking; sparring meldde het gat, ik reken het onder zijn bouw-ja. GEMETEN offline: 7 gevallen goed (Forever/Midnight, blok wel/niet, wachten op de richtingsvraag en op een gevecht, knoppen via dezelfde functies als de instelling). Wacht op Robs test in het spel. | middel |

### Half, of wacht op een test

| # | idee | stand |
|---|---|---|
| H1 | **Blizzards dispel-rand uitleggen** in de Codex (oude lijst B1). | GEMETEN: geen artikel; "dispel" staat alleen als zoekwoord in `MidnightCodexData.lua`. |
| H13 | **Forever: knop "doos openen"** (Openables). Rob 18 nov via sparring: *"Ik denk dat 3 het makkelijkste is dus die kunnen we nu doen en daarna door naar 1"*. Spel: F. | Gebouwd 18 nov (Midnight-module in de Forever-toc, lockboxes op slot overgeslagen); offline 0 fouten. Wacht op Robs test. |
| H14 | **Forever: dungeon-gids** (bazen, wat ze doen, tip, buit per class). Zelfde zin van Rob ("daarna door naar 1"); bouw-ja stap 1: *"Ja bouw maar"*; daarna: *"Die nieuwe dungeons erbij. En dan later nog een keer controleren. … Uiteindelijk wil ik gewoon alle dungeons erin hebben. Tot en met het hoogste level. En ook de nieuwe raids die gaan komen."* Spel: F. | **Plan:** stap 1 = de 9 dungeons tot ~32 (incl. Hall of Thanes, Ruins of Lordaeron, Excavation Site; die met "later opnieuw controleren") — gebouwd 18 nov. Stap 2 = dungeons 32-60 (bouw-ja: *"Ga maar verder met 2"*): **2a gebouwd 18 nov** (11 dungeons ~28-55, 89 bazen; Gnomeregan, RFK, SM, RFD, Uldaman, ZF, Maraudon + nieuw Dalaran, Drowned City, Krol'dok, Alcaz); wacht op Robs test. **2b gebouwd 18 nov** (Sunken Temple t/m Stratholme + Blackmaw, Shaper's Terrace: 28 dungeons, 267 bazen) + Robs keuze *"B"* (bazennaam = naamplaatje, alle dungeons); wacht op Robs test. Stap 3 (raids, open 9 dec) nog niet. Stap 3 = de raids (open 9 dec), na de opening met verse bronnen. ForeverDungeonJournal (ARR) alleen als bron voor feiten, eigen woorden, elk feit met een tweede bron. |
| H11 | **Forever: zelf kiezen welke balk-knoppen een hogere rank krijgen** (venster, "never touch" per balk en per knop). **Van een speler** (vragenlijst in het spel, 18 nov 2026, Druid 20-39, FI, geen naam): *"at Shaman we got rank 1 earth shock in different action bar and many ranks healing spells as all healers got, I would like to choose which action bar spells I want to upgrade."* Rob via sparring: *"werk dat maar vast uit"*. Spel: F. | Gebouwd 18 nov (ForeverRanks.lua); offline 0 fouten. Wacht op Robs test. |
| H12 | **Forever: mage Study lager in "Do this now".** Rob 18 nov via sparring: *"laten we inderdaad jouw advies volgen, lager zetten"*. Spel: F. | Gebouwd 18 nov (tip na de to-do's). Wacht op Robs test. |
| H9 | **Forever: kan ik dit disenchanten?** (tooltip, icoon in tassen + Baganator, knop "Disenchant next"). Rob 18 nov via sparring: *"Hoe kan ik zien of ik iets kan disenchanten? …"* → *"ja"*. Spel: F. | Gebouwd 18 nov (`docs/forever/DISENCHANT_2026-11-18.md`); offline 0 fouten. Wacht op Robs test. |
| H10 | **Forever: inklapbare kopjes in Find.** Rob 18 nov via sparring: *"Kunnen we daar inklapbare dingen van maken? …"* → *"ja"*. Spel: F. | Gebouwd 18 nov; offline 0 fouten. Wacht op Robs test. |
| H8 | **Forever: class quests waarschuwen vóór de reis** (mage-boek, goud, drankjes, spell-rank). Rob 18 nov via sparring: *"Ik ben de halve wereld over gereisd … dan had ik een boek moeten hebben … misschien was er een waarschuwing geweest"* → *"ja"*. Spel: F. | Gebouwd 18 nov (`docs/forever/CLASSQUEST_VOORWAARDEN_2026-11-18.md`); offline 0 fouten. Wacht op Robs test (TESTLIJST). |
| H7 | **Forever: Find → Travel** (zeppelins, boten, tram, portals + alle flight masters van je kant, met "Show the way"). Rob 18 nov via sparring: *"… zeppelins in ogrimar … net zoals flight masters.... kortom ... HELP !!!"* → *"ja"*. Spel: F. | Gebouwd 18 nov (zie NEXT_SESSION, `docs/forever/REIZEN_2026-11-18.md`); offline 0 fouten. Wacht op Robs test (TESTLIJST). |
| H2 | **Piepje bij een dispelbare debuff** (B2). | GEMETEN: gebouwd, de kop zegt nog "NOT MEASURED". Wacht op een test in een gevecht. |
| H3 | **Heal-lens voor Season 2-bazen** (B3). | GEMETEN: `HealerCooldowns.lua:401` zegt dat S2-bazen nog moeten komen. |
| H4 | **Laatste losse instellingen in het instellingenscherm** (B4). | GEMETEN: deels. Een van de gezochte namen staat nu in `SettingsDefs.lua`; welke nog ontbreken is NIET GEMETEN. |
| H5 | **Reclamefilm, introfilm, iconen verspreiden** (B6, B7, B8). | NIET GEMETEN, staat buiten de repo. Wacht op Rob. |
| H6 | **Open keuzes uit het oude briefje** (D8): machinetekst in oude changelog-vertalingen; Raidbots-bericht. | NIET GEMETEN. |

---

### Waarnemingen 13 nov (sparring, op Robs screenshot)
- **Bar-layout-vraag (Forever): "Dock to window" raakt bijna het eind van de titel.** Rob: *"1 fixen"*. **Gebouwd 13
  nov**: tekst van de bar-layout- en mylayout-vraag begint onder de Dock-knop (−34), richtingtitel vast links van de
  knop. Wacht op Robs test (TESTLIJST 13 nov avond).
- **Nieuw Forever-character krijgt bij de eerste login drie vensters**: richting en bar-layout tegelijk, daarna het
  keuzevenster. Rob: *"2 ja"*, daarna via sparring letterlijk *"Eén voor één"* (gebouwd 2ef8724), en daarna bedoelde
  hij het anders: *"één overzicht, zo bedoelde ik hem eigenlijk"* → *"Als kaartjes erin"*. **Gebouwd 13 nov (nacht)**:
  het keuzevenster is het enige venster bij de login; richting en bar layout zijn kaartjes erin. Wacht op Robs test.
  Titel + hoogte: Rob *"Ja, jouw advies"* → gebouwd (1cf57d2), getest goed (nieuwe mage).
  13 nov nacht, Rob: *"alleen voor nieuwe spelers en één keertje bij een volgende update. Zodat ook oude spelers weten
  wat voor fancies we allemaal hebben"* → kaartjes voor quick bar, Fast Mark, missende-buff-icoon, minimapknop, en het
  groepspaneel / Do this now nog één keer. **Gebouwd**, wacht op Robs test.
  14 nov, Rob (via sparring): *"deze drie kreeg ik na een nieuwe char, nu ga ik werken"* → Welcome → Yes → reload →
  toetsenblok werkt (Forever, nieuwe mage). Nog niet getest: Midnight, en sluiten-reload-blijft-weg.

### Waarnemingen 14 nov (sparring, op Robs 21.webp) — geen ja, alleen genoteerd
- **"Your key block" (Forever): "Dock to window" raakt rechtsboven de knop "New spells: ask me".** Zelfde soort als de
  Dock-fix van 13 nov. Werk: klein (AFGELEID).
- **Paneel "Getting started, step by step" is deels doorzichtig**: de zin van het buff-icoon ("Frost Armor is not on
  you. Click the icon to cast it") schijnt door stap 5 heen. Werk: klein (AFGELEID; achtergrond dichter of het paneel
  hoger in de laag). NIET gemeten in de code.

### Waarnemingen 14 nov (site-chat, bijvangst vertaling) — geen ja, alleen genoteerd
Bron: site-chat (mh-research), rapport `vertaaltwijfels-14-11.md` ("Bijvangst"). Valt onder de regel "clientnaam wint
altijd" (Rob 20 okt), maar het is groot (±160 plekken), dus eerst Robs keuze.
1. **"Mythic+" in de/fr**: de-pack 82×, fr-pack 81×; de client zegt "Mythisch+" (de, GEMETEN door mij:
   GlobalStrings PLAYER_DIFFICULTY_MYTHIC_PLUS, 12.1.5.70783) en "Mythique +" (fr, volgens site-chat; door mij niet
   nagemeten). ⚠️ CLAUDE.md noemt "Mythic+" nog als term die in alle packs Engels blijft; de regel van 20 okt overrulet dat.
2. **Menupaden** wijken af van de client: it "Scorciatoie" → "Assegnazione tasti", es "Atajos" → "Atajos de teclado",
   pt "Atalhos" → "Atalhos do teclado", de "Tastenbelegung" → "Tastaturbelegung". Welke string 12.x echt in het menu
   toont: NIET gemeten.
3. **TOUR_ROOMS_BODY** (de/fr/es/pt/it) zegt "Me", terwijl de knop Ich/Moi/Yo/Eu/Io zegt.

**Rob 15 nov (via Sparring 15-11, letterlijk):** *"Taalpunten. De bouwchat mag punten 1 en 3 oplossen en punt 2
nakijken."* Uitslag (bouwchat 15-11, alleen op main, NIET in het spel gezien):
- **1 af:** "Mythic+" → deDE "Mythisch+" (85×), frFR "Mythique +" (84×), alleen in de de/fr-blokken van Codex,
  DungeonGuide, DungeonTips, MythicPlus en Translations2026. GEMETEN: wago GlobalStrings
  PLAYER_DIFFICULTY_MYTHIC_PLUS (50146), build 12.1.5.70783. locale_probe: MPLUS_VIEW de/fr OK. Nog Engels "Mythic+":
  esES, ptBR, itIT (hun clientnaam NIET gemeten; Rob vroeg alleen de/fr). ⚠️ CLAUDE.md noemt Mythic+ nog als "blijft
  Engels"; dat mag alleen Rob laten wijzigen.
- **3 af:** TOUR_ROOMS_BODY noemt nu de echte knopnamen, alle vier (ook "Tools" en "Settings" waren Engels): de Ich /
  Werkzeuge / Einstellungen, fr Moi / Outils / Paramètres, es Yo / Herramientas / Ajustes (esMX: Configuración, eigen
  regel in esMX.lua), pt Eu / Ferramentas / Configurações, it Io / Strumenti / Impostazioni. Ook nlNL zei "Me" bij de
  knop "Ik": nu "Ik … Instellingen".
- **2 gemeten, niets gewijzigd:** GlobalStrings SETTINGS_KEYBINDINGS_LABEL (49040, het menu in Options), 12.1.5.70783:
  de "Tastaturbelegung", it "Assegnazione tasti", es "Atajos de teclado", pt "Atalhos do teclado" (Forever esES 1.60.1:
  ook "Atajos de teclado"). Ons gebruik: de "Tastenbelegung" 14×, it "Scorciatoie" 3×, es/pt kaal "Atajos"/"Atalhos"
  8× (+1 esMX). Voorstel naar sparring.

**Rob 15 nov (via Sparring 15-11, doorgestuurd door addons-67, letterlijk):** *"Ja, dit open vragen toetsenmenu. Over de
naam uit het spel gebruiken. Met de plus in het Spaans, Portugees, Italiaans ook het woord uit hun spel opzoeken en
gebruiken."* Uitslag (bouwchat 15-11, alleen op main, NIET in het spel gezien):
- **2 af:** de "Tastaturbelegung" (12 plekken + 2 "Midnight-Tastaturbelegung"), it "Assegnazione tasti" 3×, es "Atajos
  de teclado" 3×, pt "Atalhos do teclado" 3× (de 4e es/pt-regel zei het al). ⚠️ esMX: die client zegt kaal **"Atajos"**
  (GEMETEN, 49040 esMX) → esMX.lua r. 30 terug naar "Atajos" en 3 eigen regels (FIRSTRUN_POPUP_TEXT, POTIONKEY_WHERE,
  PADKEYS_NO_QUICKBIND). Forever deDE: ook "Tastaturbelegung" (GEMETEN 1.60.1.70938).
- **Mythic+ es/pt/it af:** GEMETEN (GlobalStrings 50146, 12.1.5.70783): esES "Mítica+", esMX "Mítico+", ptBR "Mítico+",
  itIT "Mitica+". Vervangen: esES 87, ptBR 85, itIT 93 (+2 "Season" → "Stagione"), esMX.lua 22; plus 12 ptBR-plekken die
  al "Mítica+" zeiden → "Mítico+" ("da" → "do"), 1 esES "Mítico+" → "Mítica+". esMX.lua zet aan het eind elke
  overgebleven esES-"Mítica+" om naar "Mítico+". Proef (packs geladen zoals elke client): alleen de 16 CHANGELOG_*-regels
  zeggen nog "Mythic+" (Engels met opzet). ⚠️ CLAUDE.md zegt nog "Mythic+ blijft Engels": alleen Rob mag dat laten wijzigen.

## Ja — wordt gebouwd

Hier komt wat Rob goedkeurt, ook wat hij rechtstreeks in de bouwchat vraagt (Rob, 10 nov: *"ja we willen het op 1
lijst"*). Gebouwd maar nog niet door Rob in het spel gezien = blijft hier, met de commit erbij. Na zijn test naar **Af**.

### Forever: "Simple order" noemt geen spells meer die je nog niet hebt (bugmelding) — GEREPAREERD 19 nov
- Bron: Rob 19 nov (via Sparring 19-11), letterlijk: *"... doe Nova. Frost Nova. Maar dat krijg ik pas als ik level 54
  ben. Dus ik denk dat dit soort uitleg niet helemaal goed gaat."* Gemeten: Frost Nova = level 10 (DB2 + trainerdata).
- Gebouwd: grijze regel "Not learned yet: … (level N)" onder elk Simple order-blok, alle classes, 7 talen. Open vraag:
  Arcane Missiles (level 8) in de mage-zin opnemen? (speladvies, eerst uitzoeken). Wacht op Robs test.
- Uitgezocht 19 nov (Rob: *"ja"*, mh-research): gidsen gebruiken AM pas vanaf ~15 en alleen als een talent hem gratis
  maakt. Voorstel "only when a talent makes it free" ligt bij Rob; niet gebouwd.
- ✅ Rob koos 19 nov (via sparring), letterlijk: *"a"* = de mage-zin blijft zonder Arcane Missiles. Niets te bouwen.

### Forever: toetsenblok-vraag en "You just learned" na elkaar — ✅ JA + GEBOUWD 19 nov
- Bron: Rob 19 nov (via Sparring 19-11), letterlijk: *"Ja, ik volg jullie advies, dus het is een kleine wijziging, ja."*
  Spel: F. Voor wie: N.
- Gebouwd: het lijstje wacht tot de vraag van het toetsenblok dicht is. Wacht op Robs test.

### Midnight: "MH werkt ook in WoW Forever" zonder "5.0", één keer extra opvallend bij de login — ✅ JA + GEBOUWD 19 nov
- Bron: Rob 19 nov (via Sparring 19-11), letterlijk: *"Op zich is dat goed, alleen 5.0 dat klopt natuurlijk niet meer.
  Die melding kunnen we wel houden. En misschien dat we het een soort splashkey moeten maken als mensen opnieuw inloggen.
  Zodat het extra opvalt. Eén keer wegklikken en daarna nooit meer geven."* (Willow: "splashkey" = splash). Spel: M.
- Gebouwd: kop zonder versienummer (7 talen); een kaartje in het "New in this version"-venster (geen tweede popup),
  één keer per account; wie de melding al wegklikte, krijgt het niet. Wacht op Robs test.

### Forever: klein los venster met je class-quest-stap — ✅ JA + GEBOUWD 19 nov
- Bron: Rob 19 nov (via Sparring 19-11), letterlijk: *"ik moet heel goed lezen in Do This Now wat ik precies moet doen.
  En, ja, het valt een beetje weg. Kunnen we misschien de optie maken dat we een extra venstertje krijgen wat we los
  kunnen plaatsen. Al dan niet met een aan- en uitknop in onze settings."* → *"Doe het nu maar."* Spel: F. Voor wie: N.
- Gebouwd: venster met alleen de huidige stap, grotere letter, Show the way, verplaatsbaar; schakelaar in Quiet helpers
  (standaard aan). Wacht op Robs test.

### Forever: "breng me naar de trainer" kiest een trainer die je iets kan leren — ✅ AF 19 nov (Rob getest: *"de testen 1 tot en met 5 zijn allemaal goed en goedgekeurd"*)
- Bron: Rob 19 nov (via Sparring 19-11), letterlijk: *"Hij brengt me naar de dichtstbijzijnde trainer, maar ik kan
  helemaal niks leren. Help"*. Spel: F. Voor wie: N.
- Gebouwd: startgebied-trainers (leren tot level 6, GEMETEN) worden overgeslagen als je iets hogers moet leren; MH
  onthoudt per trainer tot welk level hij leert, en zegt het bij een trainer met een te korte lijst. Wacht op Robs test.

### Forever + Midnight: "Used for" noemt ook het recept — ✅ AF 19 nov (Rob getest, test 3; Midnight nog niet gezien)
- Bron: Rob 19 nov (via Sparring 19-11), op het voorstel "noem het recept" na de Scroll of Protection-vraag:
  *"ja graag"*. Spel: F + M. Voor wie: N + V.
- Gebouwd: onder "MH: Used for …" een grijze regel "Recipes: X, Y (+N more)". De twee makkelijkste recepten eerst
  (Forever); de naam komt uit de client, dus in de taal van de speler. Wacht op Robs test.

### Forever: Comprehension uitleggen (mage) + "Do this now" zegt het bij een scroll — ✅ JA + GEBOUWD 19 nov (rij in Professions getest door Rob; de scroll-regel nog niet)
- Bron: Rob 19 nov (via Sparring 19-11), letterlijk: *"En dat comprehensive kaartje. Ik heb inmiddels inderdaad de knop
  gevonden. Maar dit verrast mij. En ik heb het ook nergens bij ons in onze add-on gezien."* Spel: F. Voor wie: N.
- Gebouwd: regel + kaartje "Comprehension" op de Professions-pagina (alleen mage); "Do this now" bij een onvertaalde
  scroll in je tas. Alleen gemeten feiten. Wacht op Robs test.
- Ook uit dezelfde ja: FutureSpell-filter (ForeverBlock) gebouwd; slimme zegen-knop deel 2 gebouwd (zie daar).

### Forever: namen met een tooltip in een eigen kleur + je goud in "Do this now" — ✅ AF 19 nov (Rob getest, test 5)
- Bron: Rob 19 nov (via Sparring 19-11), letterlijk: *"dat we bijvoorbeeld Conjugal Water of Conjugal Food een ander
  kleurtje krijgt als het een tooltip bevat. Want nu zie ik dat niet"* (Willow: Conjure Water/Food) en *"dat ik in dat
  overzichtje rechts onderin mijn goudvoorraadje krijg ... ik doe nu heel vaak mijn tas open om te kijken hoeveel geld
  ik heb"*. Spel: F. Voor wie: N + V.
- Gebouwd: lichtblauw (de spell-link-kleur van het spel) voor namen met een spell-tooltip; goud rechtsonder in Do this
  now, ververst bij elke verandering. Wacht op Robs test.

### Forever: Find → Rares begint bij het gebied waar je bent — ✅ AF 19 nov (Rob getest, test 4)
- Bron: Rob 19 nov (via Sparring 19-11), letterlijk: *"Kunnen we het zo instellen dat we gewoon waar ik nu ben altijd
  bovenaan staat?"* → *"Ja, doe maar."* Spel: F. Voor wie: N + V.
- Gebouwd: je gebied bovenaan met "(you are here)", dan "Worth the trip", dan de rest; wisselt mee met je gebied.

### Forever bazengids: lange namen, klein baaskaartje, 3D-model — ✅ JA + GEBOUWD 19 nov (wacht op Robs test)
- Bron: Rob 19 nov (via Sparring 19-11), letterlijk: *"bij Excavation Site Wetlands, dat die niet helemaal erin past"*;
  *"als ik zo meteen een baas aanklik in een dungeon, krijg ik dan hetzelfde scherm te zien? Of ... een kleiner, wat
  makkelijker scherm ... dit vult best wel weer veel beeld"*; *"wanneer ik bijvoorbeeld op Captain Greenskin ga staan,
  dat we ook plaatjes krijgen ... dat moet geen apart groot scherm worden ... puur luxe extra"*. Op "ja op alle 3?":
  *"Ja, dat klopt uiteindelijk wel."* Spel: F. Voor wie: N + V.
- 1 lange namen passend: GEBOUWD 19 nov. 2 klein baaskaartje bij targeten (met schakelaar): GEBOUWD 19 nov. 3 model
  bij muis op een baasnaam: GEBOUWD 19 nov. Alle drie wachten op Robs test.

### Forever: na de trainer per spell kiezen + met de hand neergezette rank met rust laten — ✅ JA 19 nov (A GEBOUWD en door Rob gezien werken; B wacht op `/mh ranks watch`)
- Bron: de vragenlijst-speler (18 nov): *"I would like to choose which action bar spells I want to upgrade."* Rob 19 nov
  (via Sparring 19-11), letterlijk: *"Ik denk dat hij bedoelde allebei. Dat wanneer hij eenmaal met de hand iets ergens
  neerzet, dat hij dat voorlopig niet zomaar geüpgrade wordt, denk ik. Dat is een aanname van mij. En inderdaad, jouw
  overzicht ziet er goed uit, volg het maar en doe het maar."* Spel: F. Voor wie: N + V.
- A (lijstje "You just learned" na de trainer, met schakelaar): GEBOUWD 19 nov, wacht op Robs test.
- B (met de hand neergezet = niet vanzelf omhoog): eerst meten met `/mh ranks watch` (TESTLIJST), dan bouwen.

### Forever: het rank-keuzevenster vindbaar maken — ✅ JA + GEBOUWD 19 nov (wacht op Robs test)
- Bron: Rob 19 nov (via Sparring 19-11), letterlijk: *"Op beide vragen ja"* op: een knop in de instellingen van Forever
  + vindbaar via de zoekbalk op "rank"/"ranks" en het woord per taal. Spel: F. Voor wie: N + V.
- Gebouwd: tandwiel → Quiet helpers (knop Open onder de rank-schakelaar), een knop op Keys & macros, en de zoekbalk
  (rank-woord per taal GEMETEN in de client-data). Het venster zelf is niet veranderd. Niet in het spel gezien.

### Tooltips van het spel overal waar MH een item, spell, quest, npc of munt toont (Midnight én Forever)
- Bron: Rob 19 nov (via Sparring 19-11), letterlijk: *"Wel viel me op dat ik tooltips miste bij oa de loot in dungeons
  overal waar wen tooltip bestaat in de game wil ik ook in de addon zien :)"*; op "hele addon of eerst Forever?":
  *"Tooltip over beide"*. Spel: M + F. Voor wie: N + V.
- Stap 1 GEBOUWD 19 nov: de loot in de Forever-bazengids (`ForeverDungeonGuide.lua`): elke loot-regel is een eigen rij
  met de tooltip van het spel; shift-klik = link in de chat, ctrl-klik = paskamer (de handler van het spel). Niet in het
  spel gezien. De bazenregels hebben geen spell-id in de data, dus daar kan nog geen spell-tooltip. (Een npc-id
  hebben de bazen wél, `b.npc`; mijn eerdere "geen npc-id" was fout — gecorrigeerd 19 nov.)
- Inventaris naar de sparring (19 nov). Volgorde: Forever 1 Do this now, 2 Trainer, 3 class quests, 4 verkopers,
  5 wapentrainers; dan Midnight (achievements, rares, reisplanner) en de staart in groepjes.
- Stap 2 GEBOUWD 19 nov (Rob: *"Doe maar"* op 1 en 2): spellnamen in "Do this now" (klein venster) met tooltip;
  overzicht "Coming up" en trainer-pagina ook op de naam. Niet in het spel gezien.
- Stap 3 GEBOUWD 19 nov (Rob: *"Op beide vragen ja en ook de do now in het overzicht"*): Now-kaart (spell-icoontjes),
  class quests (spell + quest + item), verkopers (gereedschap) en wapens (vaardigheid). Niet in het spel gezien.
  Daarna: Midnight (achievements, rares, reisplanner), dan de staart in groepjes.
- Midnight 19 nov: reisplanner-knop GEBOUWD; achievements bewust zo gelaten (de spel-tooltip kleurt meta-onderdelen
  fout groen, onze eigen is eerlijk); rares hebben al een eigen tooltip + 3D-voorbeeld. Staart: na een ja.

### Forever: het overzicht wordt hét MH voor Forever (7 tabs + tandwiel)
- Bron: Rob 17 nov (via Sparring 17-11), letterlijk: *"hoe gaan we de rest van onze Midnight helpen, in ieder geval voor
  Forever al, hierin verwerken?"*, *"Je moet gewoon één mooi product maken."* Op het voorstel: *"ja doe maar"*.
- Plan + inventaris + volgorde: `docs/forever/OVERZICHT_PRODUCT_PLAN_2026-11-17.md`. Bouwchat begint met stap 1-3
  (voordeur, één Now-lijst, trainer-pagina). Spel: F; Midnight daarna als proef één scherm.
- ✅ Stand 19 nov (bijgewerkt; deze regel liep achter): het overzicht met tabs + tandwiel bestaat en wordt getest
  (`Modules/ForeverOverview.lua`, GEMETEN dat het er is; per stap zie NEXT_SESSION/TESTLIJST 17-19 nov). Midnight-proef:
  gepauzeerd (zie "Midnight: de eerste blik" bovenaan).

### Forever: bank, veilinghuis, brievenbus en herberg in de tab Find — GEBOUWD 17 nov, wacht op Robs test
- Bron: Rob 17 nov (via Sparring 17-11), letterlijk: *"Straks zocht ik de bank en de AH in grootsteden. … Kunnen we dat
  nog erin krijgen?"*; op "zullen we er ook de brievenbus en de herberg bij doen?": *"ja doe maar"*. Spel: F. Voor wie: N.
- Gebouwd: kopje "In town" in Find met Bank · Auction House · Mailbox · Inn; data `Modules/ForeverCitySpots.lua` (116
  plekken, onderzoek `docs/forever/FOREVER_CITY_SERVICES_2026-11-17.md`). Niet in het spel gezien.

### Forever: slimme zegen op mouseover (paladin) — tooltip-tip én één slimme knop
- Bron: Rob 17 nov (via Sparring 17-11), vraag: *"Kan er een macro komen of bestaat er een macro ... die kan zien wat voor
  speler het is waar ik overheen [ga] en welke ik hem dan moet geven?"* Op de opties (1 tooltip-tip, 2 één slimme knop,
  allebei, ideeënlijst), letterlijk: *"Allebei."*
- Volgorde: NA huisstijl A+B (prio 1). Eerst (1), dan (2). Spel: F. Voor wie: N + V.
- (1) Tooltip op een vriendelijke speler: "Blessing: Might (Shift+Z)"; tabel per class, door de speler aan te passen;
  schakelaar standaard UIT. Eerst meten of TooltipDataProcessor (Unit) in Forever werkt.
- (2) Eén slimme zegen-knop: SecureActionButton met unit=mouseover; een APART event-frame (UPDATE_MOUSEOVER_UNIT, buiten
  combat) zet het spell-attribuut op basis van UnitClass/UnitPowerType; in combat blijft de laatste keuze; geen script op
  de secure knop zelf (les ForeverPartyPanel.lua:12-13); `/mh`-diagnose met keuze + reden; schakelaar standaard UIT.
  Twijfel (hybrides) → Kings (vanaf 20) of de tip uit (1). Greater alleen op echte groepsleden (zie de [group]-meetklus).
- Feiten (sparring, GEMETEN DB2 wowf 70938 + Wowhead Forever): Might 19740 (4, alleen melee AP), Wisdom 19742 (14), Kings
  20217 (20, trainer) + Greater 25782/25916, 25894/25918, 25898 (52/54/60, Symbol of Kings 21177). Salvation/Sanctuary/
  Light bestaan niet. Voorstel per class = AFGELEID (Classic-kennis); MH's eigen uitleg: ForeverHowToPlay.lua:977 (Holy)
  en :1025 (Ret).
- Te meten in het spel: UnitClass/UnitPowerType("mouseover") op een vreemde, UPDATE_MOUSEOVER_UNIT bij unit frames,
  SetAttribute vanuit het event-frame + binding/klik, de speler-tooltip-hook. Kandidaten (NIET kopiëren): PallyMe (ARR),
  PaladinPlan (GPL-3.0).
- 17 nov avond: (1) tooltip-tip GEBOUWD (`ForeverBlessTip.lua`, `/mh blesstip`, standaard uit, met meting). (2) nog niet.
- 19 nov (Rob via sparring: *"Ja, die mogen door"*): (2) slimme knop GEBOUWD — macro "MH Smart Bless", schakelaar in
  Quiet helpers (standaard uit), `/mh blesstip button on|off`. Wacht op Robs test (paladin).

### Forever: tien nieuwe handige macro's (ideeën uit de Forever-gidsen, zelf geschreven)
- Bron: Rob 17 nov (via Sparring 17-11), letterlijk: *"Ja, die 10 macro-ideeën zijn een goed idee. Werk maar uit."*
  Eerder: *"Wat ik ook heel erg mooi vind overigens zijn de macro's … Die wij best wel kunnen … overnemen of zelf maken."*
- Regel: de Forever Leveling Guide is All Rights Reserved → niets overgenomen; zelf geschreven uit openbare bronnen
  (Rankedboost, Kami-labs, Conquestcapped) + standaard macrosyntax. Spells en items via id. Spel: F. Voor wie: N + V.
- Feiten (mh-research Fable, 17 nov): `docs/forever/MACRO_IDEAS_2026-11-17.md`.
- GEBOUWD 17 nov (en + nl; vertaling en Fable-controle lopen), `Modules/ForeverMacros.lua`, overal **Ctrl**:
  eten+drinken (iedereen; mage Ctrl = water maken), buffs met Ctrl = groepsversie (Arcane Intellect, Fortitude,
  Divine Spirit), Healthstone + Soulstone (warlock, Ctrl = maken), Mana Gem (mage, Ctrl = Evocation), aspects (hunter),
  Prowl vanuit elke vorm (druid, vormnummer uit de client), Shadow Bolt + demon (warlock), res op muis (priest, shaman,
  paladin), focus-CC (Shackle, Hibernate), rogue Stealth/Vanish+Sprint/Finisher, Searing/Magma (shaman).
  Bewust niet: paladin-blessings (keuze per groep), Pack in de aspect-macro (verdooft de hele groep; Rob mag omdraaien).
- Rob-test 17 nov: eten+drinken werkt (paladin 14). Bezette toets GEMETEN (Shift+5 = Action Page 5) → Rob: **"B"** =
  rode regel in het venster + knop "Free key" (alleen Blizzard-paginatoetsen) + "Undo freed keys". GEBOUWD 17 nov.
- Nog open (eigen bouw): Copy-knop, bron per rij, chips READY/level, melding "nieuwe macro" bij level-up, uitlegkaart
  modifier.
- GEBOUWD 19 nov (Rob: *"we gaan akkoord met het voorstel van het bouwadvies"*): chips Made/Ready/Level/Trainer,
  Copy-knop, melding "nieuwe macro" (na de trainer). Nog open: bron per rij, uitlegkaart modifier. Wacht op Robs test.

### Forever: Legacy Points uitleggen en helpen (+ Talented-fout repareren)
- Bron: Rob 17 nov (via Sparring 17-11), letterlijk: *"legacy points. Wat zijn het? Waar krijg ik het? Hoe krijg ik het?
  En hoe zet ik het in?"* Op het onderzoek: *"Legacy ook bouwen en het gat met talented als fout laten repareren. Want
  we willen gewoon een goed product leveren, toch?"*
- Volgorde: (a) de Talented-fout direct na de mage, vóór de vertalingen; (b) Legacy bouwen na de classes, naast
  Kamperen. Spel: F. Voor wie: N + V.
- Onderzoek (sparring, mh-research Opus, 17 nov): `docs/forever/LEGACY_RESEARCH_2026-11-17.md`. Voorstel: uitlegkaart
  Legacy, "Do this now" ongebruikte punten (alleen als gemeten), `/mh legacy`-diagnose, de Talented-fix.
- Stand 17 nov: (a) Talented-fix GEBOUWD (rang uit de actieve tier-entry, commit 369ee9d; wacht op Robs probe). (b) Legacy
  zelf nog niet gebouwd. Fable-controle KLAAR → `docs/forever/LEGACY_VERIFIED_2026-11-17.md` (79 ✅, 2 ❌, 1 ❓).
  🔑 API GEMETEN in Blizzards UI-code 70938 (spiegel Gethe/wow-ui-source, branch forever): punten =
  `C_Traits.GetTreeCurrencyInfo(C_Traits.GetConfigIDByTreeID(1187), 1187, false)[1]`, verdiend totaal =
  `C_MajorFactions.GetCurrentRenownLevel(2802)`. Blizzard gebruikt GetConfigIDBySystemID(45) NIET (onze Talented-
  code wel → nu omgedraaid: eerst boom 1188). Dedicated Study = knop (25 s cast, 23 u cooldown). Geen resetprijs noemen.
- Stap 1 GEBOUWD 17 nov (wacht op Robs test): `Modules/ForeverLegacy.lua` — `/mh legacy` (verdiend/beschikbaar/
  uitgegeven/cap + Talented-rang, bewaard in ns.db.foreverLegacyProbe) en "Do this now": "N ongebruikte Legacy Points"
  (namen uit de client: LEGACY_REWARD_TRACK_POINTS + LEGACY_BUTTON; stil als onleesbaar). Uitlegkaart: na Robs test.

### Nieuwe huisstijl / overzichtspagina, in TWEE varianten met een schakelaar
- Bron: Rob 17 nov (via Sparring 17-11), letterlijk: *"Ja, eigenlijk vind ik ze allebei wel super mooi. En misschien
  moeten we de user maar laten kiezen. Dus bouw ze allebei maar. Ik weet dat het veel werk is en waarschijnlijk heel
  veel kost."*
- Wat: A = "sfeervol boek" (spelkunst-achtergrond met sluier + vignet, serif-koppen, portret + levelzegel, doorschijnende
  kaartjes, tijdlijn "Jouw pad", chips NU/KAN AL/LATER); B = "strak en modern" (leisteen WHITE8X8, één schreefloos font,
  accentbalk 3 px, grote cijfers, tijdlijn met balkjes). Beide: accent = klassekleur, tabs Nu / How you play /
  Class-quests / Kamperen / Legacy, één grote knop bij "Doe dit nu". Mockup (Sparring): `C:\Users\RobHu\Desktop\
  mh_ontwerp.html` + `.png`. Basis: één eigen stijlkit-bestand (card/chip/label/button/timeline + thema-tabel A/B).
- 🔴 Forever Leveling Guide = ARR: aanpak leren, NIETS overnemen (code, teksten, data, Texturas\*.tga). Eigen texturen
  zelf maken. Fonts alleen OFL (bv. Cormorant SC/Philosopher of Alegreya Sans/Inter, mét Cyrillisch; NIET Cinzel) +
  OFL-.txt meeleveren; terugval op spel-fonts. Retail-spelkunst eerst meten. Resizable + Shift-scroll blijven.
- Volgorde: NA Legacy en Kamperen. Spel: F (en later M?). Advies Sparring: in een verse bouwchat. NOG NIETS GEBOUWD.
- 🔼 **Prio 1 sinds 17 nov** (Rob via Sparring, letterlijk: *"Die twee ontwerpen, die wil ik heel graag hebben. Die wil ik
  heel graag zien. Dus die krijgt zometeen na de macro's gelijk de prio 1."*) → direct na de macro's, vóór de rest van
  Kamperen. Dat vervangt de volgorde hierboven.
- 17 nov: ruwe A GEBOUWD (f1ad068, `/mh overview`). Robs oordeel (via Sparring, letterlijk): *"Ja, ik ben onder de
  indruk. Er zijn natuurlijk nog veel dingen aan veranderen of beter doen. … Zoals rechtsbovenin, een doc en doc. Dat
  knopje zit natuurlijk weer er doorheen. Ik wil graag bij alle dingen die... de tooltips overal bij. Maar verder, dit is
  de weg waar ik graag heen wil. Absoluut."* → ronde 2 GEBOUWD (dock-knop naast de titel, tooltips overal, pad-kolommen
  binnen het kader, class quest niet dubbel, XP links, tips in Doe dit nu, chips NU/LATER).
- 🔼 Ook ALLE tabbladen in deze stijl (Rob via Sparring, letterlijk: *"bij alle andere tabbladen, komt het uiteindelijk
  ook zo op deze manier eruit te zien? Want dat zou ik wel heel graag willen."*) → stap 5 in
  `docs/forever/HUISSTIJL_PLAN_2026-11-17.md`: stijlkit → Class quests → Kamperen + Legacy → How you play → B +
  schakelaar → vertalingen.
- Eis "Do this now" in de nieuwe layout (Rob via Sparring, letterlijk, bij de regel "Redemption (from level 12), class
  quest: go to Danitha Morr, Tirisfal Glades (22.1, 44.7)": *"Dit staat nu keurig bovenaan bij Do This Now. Bij een
  nieuwe layout moet dat beter. En dan moet er ook een paar [= pijl] naartoe gaan om te kijken welke kant je op gaat en
  dergelijke."*): elke regel met een plek krijgt een eigen knop/pijl die de route naar díe plek zet (NativeArrow, met
  de pijl-schakelaar voor de Forever Leveling Guide); coördinaten uit de zin naar een kleine subregel; de belangrijkste
  regel als kaartje met titel (bv. "Class quest: Redemption" / "Go to Danitha Morr" / "Tirisfal Glades · 22.1, 44.7" +
  knop).
- 17 nov avond (Bouwchat 17-11 (3)): stijlkit `ForeverStyle.lua` (77a9c6c), Class quests-pagina (3eadfdd), Kamperen +
  Legacy (0db441d), How you play (26dbf00), vertalingen de/fr/es/pt/ru (2cc0165) GEBOUWD.
- 🛑 **B VERVALLEN** (Rob via sparring, letterlijk: *"ik denk dat wij gewoon gaan voor onze eerste stijl die we gemaakt
  hebben"*, *"Ja, B mag eruit."*, *"Je moet gewoon één mooi product maken."*): B was gebouwd (25ec782) en is weer
  weggehaald. Eén look: A. Dit vervangt "laat de user kiezen" hierboven.
- **Volledige naam in de kop** (Rob via Sparring, letterlijk: *"Nog een vraag, kunnen we hier de hele naam neerzetten?
  Eventueel onder elkaar de voor- en de achternaam, als het te lang wordt."*): GEBOUWD met meting
  (`ns.db.foreverNameProbe`): achternaam alleen als de client hem geeft; één regel (krimpt tot 16), anders twee regels.
  Wacht op Robs meting welke functie de achternaam geeft.

### Forever: wie stuurt de pijl — MH of de Forever Leveling Guide (schakelaar)
- Bron: Rob 17 nov (via Sparring 17-11), na zijn test (troll mage 6: "Forever Guide: your pin stays… route paused" +
  "Midnight Helper: Route stopped: you removed the TomTom arrow"), letterlijk: *"En wat betreft de ruzie om de pijl. Doe
  inderdaad maar C met als standaard A."*
- Wat: een schakelaar (spelers kiezen). Standaard: MH wijkt als de Forever Leveling Guide een route heeft, zoals bij
  TomTom. Niet stil wijken (les WaypointUI, 5 aug): `/mh arrow` zegt dat en waarom we wijken, en de uitleg staat waar
  de speler het ziet. Spel: F. Voor wie: N + V.
- Volgorde (keuze bouwchat): direct na de vertaalronde van de rollen, vóór Legacy en Kamperen (klein, Rob merkt het
  elke speelsessie).
- GEBOUWD 17 nov (wacht op Robs test): Core.lua `ns.ArrowYieldsToForeverGuide` (vraagt `WowF.viajeEstado()`, de
  reisroute — niet `hayRutaActiva`, die is ook waar bij alleen quest-markeringen). SetBlizzardUserWaypoint zet dan niets
  en zegt waarom (ARROW_FGUIDE_YIELD); NativeArrow stopt een lopende MH-route als de gids begint (ARROW_FGUIDE_TOOK);
  de TomTom-melding noemt nu de gids i.p.v. "jij"; `/mh arrow` toont gids + schakelaar; `/mh arrow guide` en een
  schakelaar in de instellingen (SET_ARROWGUIDE_*), 7 talen + ru.
- Eerste meting (17 nov, alleen gelezen in `_forever_\Interface\AddOns\ForeverLevelingGuide`): de gids zet
  `C_Map.SetUserWaypoint` (+ `SetSuperTrackedUserWaypoint`), een TomTom-punt als TomTom er is (`wowF_Viaje.lua` 400-418)
  en een eigen pijl onder de minimap (`wowF_Panel.lua` 1096). Zijn melding "your pin stays… route paused" staat in
  `wowF_Viaje.lua` 551. Beide addons zetten dus hetzelfde Blizzard-speldje.

### Forever: Kamperen (kampvuur + kampobjecten) uitleggen en helpen
- Bron: Rob 17 nov (via Sparring 17-11), letterlijk: *"We hebben tegenwoordig kampvuurs waarbij je allerlei power-ups,
  hoe noem je dat, tijdelijke buffs kan krijgen. Onder andere bij een campchair, een sharpening wheel, incense candle,
  manual, lodestone en fishbowl. Daar hebben we volgens mij ook helemaal niks over. Ik denk dat we meer informatie kunnen
  geven, zeker als helper zijnde."* Op het onderzoek: *"Ja, het zal vast mana wel zijn. En dat kampvuuridee moeten we ook
  gaan bouwen."* ("manual" = Mana Well.)
- Volgorde: NA de classes (stap 3 + de Fable-fixes). Spel: F. Voor wie: N + V.
- Stand: onderzocht door mh-research (sparring, 17 nov), overgezet naar `docs/forever/CAMPING_RESEARCH_2026-11-17.md`
  (stond er al kort in; 17 nov de volledige tekst). Fable-controle KLAAR → `CAMPING_VERIFIED_2026-11-17.md` (70 beweringen: 57 ✅, 3 ❌, 10 ❓; fouten: 7 startzones
  i.p.v. 5 (+ Dun Morogh 96608, Teldrassil 96606), vuur = recept → Basic Campfire Kit 279981 → gebruiken, Camp Benefits
  zoekt binnen 20 yd; bouwchat steekproef GEMETEN: 279981/279962/279967 in ItemSparse, 96606/96608 in Spoken). Voorstel (details keuze bouwchat, spelers kiezen via schakelaars): uitlegkaart
  "Kamperen" (ForeverProfGuide versie B), "Do this now" ga 1 minuut zitten, hint beroep ≥20 zonder kamprecept, tooltip op
  kampobjecten, opt-in herinnering "geen kampbuff", `/mh camp`-diagnose, clientnamen per taal meten. Eerste test voor Rob:
  zijn de auras 1229741 / 1283391 leesbaar.
- Stap 1 GEBOUWD 17 nov (wacht op Robs test): `Modules/ForeverCamp.lua` — `/mh camp` (alle kamp-auras: ja/nee/
  onleesbaar + besluit + reden, bewaard in ns.db.foreverCampProbe) en "Do this now": vuur in de buurt, geen Camp
  Benefits → "ga zitten" (namen uit de client, stil als iets onleesbaar is). Uitlegkaart en de rest: na Robs test.

### 📅 Werkafspraak: woensdag = Midnight-dag (vanaf wo 18 nov 2026)
Rob, 15 nov (via Sparring 15-11, letterlijk): *"Ja, pak de woensdag maar voor de midnight."* Aanleiding (Rob): *"de
Midnight-afdeling ondersneeuwt op dit moment door de Forever"*. Elke woensdag (ook de EU-reset) gaat werk aan Midnight
voor; Forever wacht die dag, tenzij Rob anders zegt.

### Speltermen in elke taal het woord uit het spel (groep voor groep)
- Rob 15 nov (via sparring): *"doe inderdaad optie A maar. Dan werk zoveel mogelijk door."* Groep 1 3d20a27, groep 2
  9f2964c, groep 3 loopt. Daarna de nog niet gemeten namen (Follower Dungeon, Heroic World Tier, quest "Midnight:
  Dungeons", Dungeon Waystones, Mythic Keystone …). Test: TESTLIJST 15 nov (middag).

### Spelersfeedback + meer aandacht voor Midnight (4 opdrachten voor de bouwchat)
Rob 15 nov (via sparring), op zes ideeën: *"Doe ze allemaal maar."* Volgorde na de speltermen:
1. **Forever-vragenlijst, addon-kant**: uitnodiging in Forever (zelfde nudge-aanpak, eigen link; URL met de site-chat
   afstemmen), één keer, wegklikbaar, `/mh survey` ook in Forever. GEMETEN door sparring: SurveyInvite.lua en Nudges.lua
   staan niet in MidnightHelper_Camelot.toc.
2. **Downloadcijfers** ✅ gemeten 15 nov (CF-API): sinds 5.0.1 Midnight 1875, Forever 94; tabel naar sparring.
3. **Midnight klaar voor 12.1.7 / Season 3**: bronnenlijst + plan naar sparring; klein en zeker mag direct.
4. **Midnight-controle**: verouderd/kapot nalopen (stale advice, hotfixes sinds 12.1.5, open punten); lijst + voorstel.
(Idee 3, Reddit/forums, doet de sparring-chat zelf. Idee 6 = de woensdag hierboven.)
Stand 15 nov avond: 1 gebouwd (1f521e5), 2 gemeten, 3 rapport + A/B gebouwd (zie NEXT_SESSION), 4 lijst naar sparring.

### Draaiboek voor patch 12.1.7 (verwacht 1/2 dec 2026)
- Rob 15 nov, rechtstreeks in de bouwchat: *"Als op 2 dec de patch komt moetwn we wel van te voren weten wat er komt en
  wat we moeten checken en evt testen"*; op het voorstel (draaiboek + vooraf klaarzetten achter het interfacenummer +
  PTR-tests + wekelijkse herhaling): *"Klopt en stuur een aantal speur agenten het net op om alle info over de patch vast
  op te speuren"*.
- 15 nov: 5 speur-agenten (mh-research) → `docs/patch_12_1_7/1_blizzard.md` … `5_community.md`. Daarna
  `docs/PATCH_12_1_7_DRAAIBOEK.md`: wat komt / wat MH vooraf klaarzet / wat Rob op patchdag test.
- ✅ Stand 19 nov (bijgewerkt; deze regel liep achter): het draaiboek bestaat (`docs/PATCH_12_1_7_DRAAIBOEK.md`,
  GEMETEN dat het er is). Wat er nog in moet: zie het draaiboek zelf.

### Forever: lijst "Screens" in Blizzards Opties alleen met schermen die er in Forever zijn
- Voor wie:      iedereen in Forever
- Moment:        Options → AddOns → Midnight Helper → Screens (en MH's eigen Settings → Screens)
- Spel:          Forever (retail ongewijzigd)
- Bron:          Rob 16 nov (via Sparring 16-11, letterlijk: *"beide ja"*). Hij zag daar alle Midnight-schermen (Delves &
                 Vault, Rares, Trading Post, Tier Sets …) en de rauwe sleutels TAB_START_HERE en TAB_OMNIUM.
- Oorzaak:       GEMETEN (sparring + bouwchat): `ns.GetHideableScreens` (UI.lua) keek niet naar Forever; de zijbalk wel.
- Stand:         ✅ gebouwd 16 nov, alleen op main, NIET in het spel gezien (TESTLIJST 16 nov).

### Forever: class-quests en spec-dingen per class laten zien (begin: Druid)
- Bron: Rob 16 nov (via sparring), letterlijk: *"Carola is net, of die kan al beervorm krijgen, maar we weten niet hoe.
  Ik weet dat er een questlijn is en ik bedoelde meer dat soort dingen. Dat we ook dat kunnen aantonen. En later krijg je
  ook een katvorm. En zo zullen er voor meer specs dingen zijn die speciaal spec gebonden zijn. En dat bedoelde ik als
  eerste. En ja, inderdaad zoveel mogelijk. Tanken, healen en dat soort dingen allemaal. En ook inderdaad voor wat er na
  level 10, 20, 30 enzovoort komt. Maar begin inderdaad met de Druid, dan kan ze daar zo meteen alvast mee beginnen."*
- Stap 1 Druid class-quests (Bear Form lvl 10, Aquatic 16, Cat 20?, …) in "Do this now" + pijl + /mh play; stap 2 per rol
  en per 10 levels; stap 3 de andere 8 classes.
- Stand: Bear Form-keten (A + H) uit Zygor Forever naar sparring (voor Carola), 16 nov.
- Stand 16 nov (nacht): ✅ Ja (Rob). Druid stap 1 GEBOUWD (Bear 10, Cure Poison 14, Aquatic 16, Cat 20, Torwa 50; commits
  4faaaee, 0059fae, 86984a6, bb1635e) en stap 2 GEBOUWD in en/nl (dad9c38). Alleen main, NIET in het spel gezien
  (TESTLIJST 16 nov). Open: Skyborne Cat Form, NPC-namen per taal, stap 3 (8 classes). Af na Robs/Carola's test.
- Stand 17 nov: Skyborne + NPC-namen druid gedaan (f707878). Stap 3 begonnen: ✅ Warlock class-quests GEBOUWD in en/nl
  (imp 1, voidwalker 10, succubus + incubus 20, felhunter 30, felsteed 40, dreadsteed 60; per ras; NPC-namen 6 talen).
  Feiten `docs/forever/WARLOCK_CLASSQUESTS_2026-11-17.md`. NIET in het spel gezien. Open warlock: vertalingen de/fr/es/
  pt/ru, rollen per 10 levels, item-ketens (Green Flame, Imp's Request). Daarna warrior, shaman, rogue, hunter, paladin,
  priest, mage.
- ✅ Warrior class-quests GEBOUWD in en/nl (17 nov): Defensive Stance 10 (6 rasroutes + Skyborne), Berserker 30,
  Whirlwind-wapen 30 (pas na The Affray), Fallen Hero 50. Feiten `docs/forever/WARRIOR_CLASSQUESTS_2026-11-17.md`. NIET
  in het spel gezien. Open warrior: vertalingen, rollen, wapen-/pantservervolg op 10/20 (plekken onbekend).
- ✅ Hunter + Rogue class-quests GEBOUWD in en/nl (17 nov, uitgezocht met Fable): hunter pet-quests 10 (6 routes, ook
  Human en Skyborne nieuw in Forever) + Hunter's Charm 50; rogue Blade 10, Thieves' Tools 16, Poisons 20, Dead Drop-
  ketens 23/30 (nieuw), Azure Key 50. NIET in het spel gezien. Open: vertalingen, rollen; hunter 60 (begint met een item),
  rogue Zanzil-kuur (bewust niet: zou blijven staan).
- ✅ Shaman class-quests GEBOUWD in en/nl (17 nov): Earth 4, Fire 10, Water 20, Air 30 (Horde, Dwarf en Windshaper
  Skyborne; Dwarf-ketens nieuw in Forever), Elemental Mastery 52 (Horde). NIET in het spel gezien. Open: vertalingen,
  rollen, The Tempest's Weapons (plekken onbekend). Fable-nakijkronde door sparring.
- ✅ Priest class-quests GEBOUWD in en/nl (17 nov, Fable): ras-spell op 10 en 20 voor 6 rassen (Gnome nieuw), eerste
  gewaad 5, Cenarion Aid 50. NIET in het spel gezien. Open: vertalingen, rollen, Benediction (begint met een raid-item).
- ✅ Paladin class-quests GEBOUWD in en/nl (17 nov, Fable): Alliance Redemption 12, Verigan's Fist 20, Warhorse 40,
  Valorfist 50, Charger 60; Undead (nieuw in Forever) Holy Light 2, Bandarion Keep 8, Redemption 12, Wolfsbane 20,
  Warhorse 40. NIET in het spel gezien. Open: Forsaken Charger (niet gebouwd), vertalingen, rollen.
- ✅ Mage class-quests GEBOUWD in en/nl (17 nov, Fable): staf/orb 10 per ras (+ Skyborne-wand), Study 6, robe 15,
  garment 26, Mage's Wand + Items of Power 30, Celestial 35, Spellbook 42, Magecraft 50, Conjure Water 7 + Pig 60.
  Daarmee alle 9 classes stap 1. NIET in het spel gezien. Open: vertalingen alle classes, rollen per 10 levels.

### Forever: "Do this now" noemt de beste stats voor jou (solo + tank, dps/heal in gedachten)
- Bron: Rob 16 nov (eerder die dag, letterlijk): *"wat ik ook graag wil weten in het schermpje Doe This Now … wat zijn
  de beste stats voor de spec die ik heb? … moet ik nu strength nemen of moet ik nou de stamina nemen"*; op A/B
  (via sparring): *"b , maar hou ook dps en heling in je achterhoofd"*.
- Stand: onderzocht 16 nov → `docs/forever/STATS_PER_ROL_2026-11-16.md`. Tabel + 4 keuzes naar Rob (via sparring):
  rol uit de richting, tank-regel voor W/P/D, Blizzard > Icy Veins bij onenigheid, tooltip dezelfde tabel. ⏳ wacht op
  Robs keuze. Gevonden (GEMETEN): de groene tooltipregel adviseert nu Str aan Ele/Resto Shaman en Holy/Prot Paladin,
  Agi aan Balance/Resto Druid; Warlock mist Spirit.
- Rob (via sparring): *"alle 4 ja"*. ✅ gebouwd 16 nov: ForeverMainStats.lua `ns.ForeverStatDef` (rol uit de richting,
  oneens = "tellen even zwaar") + `ns.ForeverTankStatDef` (W/P/D); ForeverQuestHint (tooltip + questhint) gebruikt dezelfde
  functie; "Do this now" toont 1-2 tip-regels; `/mh donow check` print rol, bron, boomnaam en volgorde. NIET in het spel gezien.

### Vuurwerk bij een level-up (Midnight en Forever)
- Bron: Rob 16 nov (via sparring), na het effect van een andere addon in Forever, letterlijk: *"ja dat wil ik, dat
  vuurwerk, evt met geluid 🙂"*. Eigen versie, niets overgenomen (licentie van die addon niet gemeten).
- ✅ gebouwd 16 nov: `Modules/LevelUpFireworks.lua` (beide toc's). Blizzards star4-textuur (GEMETEN in Forever),
  één schakelaar, standaard aan; in een gevecht wacht hij (max 60 s). `/mh fireworks [test]`. Rob zag het werken; het
  geluid ging er dezelfde avond uit (Rob: *"het geluid is een tik … geluid is niet nodig en mag weg"*).

### Forever: mouseover ook voor blessings en Arcane Brilliance
- Bron: Rob 16 nov (via sparring, letterlijk: *"mouse over werk, en zet de andere ook maar op de lijst"*); hij buft graag
  voorbijgangers. ✅ gebouwd 16 nov (ForeverBlock.lua MO_HELP + de "pair"-toetsen kregen mouseover, die hadden het niet).
  Alleen de blessings die in ns.FOREVER_SPELL_IDS staan. NIET in het spel gezien.
- MagePlan: MH blijft ook melden (Rob: *"laat en mh en mageplan het de key maar melden"*).

### Zes kleine ideeën (Rob 16 nov, via Sparring 16-11, letterlijk: *"allemaal"*)
1. **Forever: "Do this now" zegt dat een nieuw geleerde spell op geen enkele balk staat** (wachter-voorstel 15 nov;
   passieve spells niet). Gemeten 16 nov (mh-research, Forever UI-bron bebcb6bf + DB2 70938): event
   LEARNED_SPELL_IN_SKILL_LINE, C_Spell.IsSpellPassive bestaan; Blizzard licht zo'n spell al op in het SPELLBOEK. Niet
   gemeten: of het event bij de trainer vuurt → Robs /run-test eerst. Plan: elke rank telt als "op een balk" (ook in een
   macro), zwijgen als het toetsenblok staat, `/mh donow check` uitbreiden.
2. **Forever: tooltipregel "dit heb je niet meer nodig, omdat …"** (O22). Gemeten: (a) recept al bekend → VALT AF
   (Blizzard toont "Already known" zelf, en GetItemSpell geeft het recept niet); (c) eten te zwak → VALT AF (Forever-eten
   heeft alleen een MINIMUM-level; "te zwak" zou ons eigen oordeel zijn). (b) "jouw class kan dit NOOIT dragen" is
   meetbaar (SkillRaceClassInfo 70938: mail/plate pas vanaf 40 voor sommigen, schild, wands) → alleen dat bouwen.
3. **Forever: tooltipregel "nodig voor een quest in je log"** (O23). Gemeten: GetQuestObjectives geeft GEEN item-id,
   alleen tekst → matchen op itemnaam. Hoe die tekst eruitziet: niet gemeten → Robs /run-test eerst.
   ✅ 1-3 gebouwd 16 nov na Robs drie tests: 1 in ForeverDoNow.lua (LEARNED_SPELL_IN_SKILL_LINE, elke rank/macro telt,
   stil met toetsenblok); 2b + 3 in nieuw `Modules/ForeverItemTips.lua` (zelfde schakelaar als "Used for"; quest-match =
   itemnaam als heel woord in ÁLLE open doelteksten). NIET in het spel gezien. Open keuze voor Rob: MagePlan meldt ook
   "New spell that isn't on any button" — moet MH dan zwijgen?
   📌 19 nov: Rob zei via sparring opnieuw *"1 en 2 ja"* op O22 en O23. Gemeten die dag: beide staan al in de code en in
   5.4.0 (`ForeverItemTips.lua`); er is niets nieuws te bouwen. Vraag voor Rob: wil hij (a) "recept al bekend" en
   (c) "eten te zwak" tóch, ondanks de meting? (a) zegt Blizzard zelf al ("Already known"); (c) is geen spelregel en
   zou ons eigen oordeel zijn.
4. **"Your key block" (Forever): "Dock to window" raakt "New spells: ask me"** (waarneming 14 nov). ✅ gebouwd 16 nov:
   knop 30 px naar links (KeyBlock.lua). NIET in het spel gezien.
5. **"Getting started, step by step": de buff-zin schijnt erdoorheen** (waarneming 14 nov). ✅ gebouwd 16 nov: dichte
   laag onder het paneel (KeyBlock.lua). Oorzaak AFGELEID (doorzichtige textuur). NIET in het spel gezien.
6. **Midnight: "Je bent 90. Wat nu?"** (S1 vorm 1). ✅ gebouwd 16 nov: `Modules/MaxLevelWelcome.lua`, één keer per
   character bij het bereiken van het hoogste level, knoppen "My gear" / "Start Here" / "Later"; `/mh maxlevel [popup]`.
   NIET in het spel gezien.

### Forever: buffknop meldt een steen, olie of poison die nog niet op je wapen zit
- Voor wie:      iedereen in Forever die zulke spullen bij zich heeft
- Moment:        de bestaande Forever-buffknop (ForeverBuffs.lua + MissingBuff.lua), onder hetzelfde vinkje
- Spel:          Forever
- Bron:          Rob 16 nov (via Sparring 16-11, bij een screenshot van "Rough Sharpening Stone"), letterlijk: *"kunnen we
                 daar ook een waarschuwing voor krijgen als we deze hebben en een juiste wapen hebben equiped om het te
                 gebruiken en het er nog niet op zit ?"*; op het plan ja, en op "alleen stenen of ook oils en poisons":
                 *"alles :)"*.
- Wat:           in je tas + passend wapen + nog NIETS tijdelijks op dat wapen → de knop toont het item; klik = erop
                 (buiten combat). Stenen (scherp/stomp), oils, rogue-poisons (main- en off-hand). `/mh buffs` zegt per item
                 waarom wel/niet.
- Stand:         ✅ gebouwd 16 nov laat (ForeverBuffs.lua WEAPON_ITEMS + MissingBuff.lua item-klik), alleen op main,
                 NIET in het spel gezien (TESTLIJST 16 nov laat). Feiten GEMETEN door mh-research (wago wowf 70938).
                 Keuzes van de bouwchat: Shaman = spell eerst; beste rang eerst; Blackfathom-steen, Oil of Immolation,
                 warlock-stenen en mage-scrolls niet meegenomen; consecrated/blessed (tegen undead) als laatste.

### Forever: opruimen na Robs test van 16 nov (4 opdrachten)
- Bron:          Rob 16 nov (via Sparring 16-11, letterlijk: *"ja doe maar"*).
- a) "TAB_CODEX: Basics" weg uit Screens in Forever (geen Codex daar). ✅ gebouwd 16 nov.
- b) Elke instelling op de hoofdpagina nalopen: werkt hij in Forever? Lijst (22 werkt / 63 niet / 11 weet niet).
     Rob koos *"a en ja"*: de 63 verborgen in Forever, 11 blijven tot zijn test, schakelaar voor de oppak-upgrade-melding.
     ✅ gebouwd 16 nov avond. Plus de Self Cast Key-waarschuwing bij macro's (Forever + retail).
     De 11 "weet niet" blijven staan; testen vervallen (Rob: *"laat deze tests maar achterwege, mocht iemand het melden
     dan is het vroeg genoeg"*).
- c) `[mod:alt]`-macro's tegen Self Cast Key = ALT: AFGELEID geen last (5 zonder @mouseover; 2 willen met Alt toch al op
     jezelf); NIET in het spel gemeten, test in TESTLIJST 16 nov middag.
- d) Kaartje "Dungeons in Forever" in de kamer Me. ✅ gebouwd 16 nov.
- Stand:         a en d alleen op main, NIET in het spel gezien.

### Schakelaar "Camera verder weg" (retail en Forever)
- Voor wie:      iedereen die verder wil uitzoomen
- Moment:        Opties → Midnight Helper (algemeen deel) en `/mh camera` [on|off]
- Spel:          allebei. Aan = retail 2.6, Forever 4. Uit = de oude waarde terug.
- Bron:          Rob 16 nov (via Sparring 16-11, letterlijk: *"beide ja"*), op het voorstel van één schakelaar voor
                 `/console cameraDistanceMaxZoomFactor 4`. Meetwerk mh-research (sparring): retail max 2.6, CVar niet
                 secure, scope account; Forever-schuif van Blizzard gaat 1.0-2.0; of Forever 4 echt houdt: NIET gemeten.
- Stand:         ✅ gebouwd 16 nov (`Modules/CameraZoom.lua`), alleen op main, NIET in het spel gezien (TESTLIJST 16 nov).

### Forever: waarschuwing "meer dan 12 levels boven de vijanden = niemand krijgt XP"
- Rob 15 nov (via sparring, letterlijk): *"Ja, op 12 levels, waarschuwing achterin."* = ja, achteraan de rij.
- Bron (sparring/mh-research): Blizzard (Kaivax, 14/15 nov, us.forums.blizzard.com …/2416343): zit iemand in de groep
  meer dan 12 levels boven een vijand, dan krijgt niemand XP voor die kill. In 2 dagen twee keer aangepast: datum in de
  tekst, eerst de huidige regel nameten.
- Plekken: Forever-groepspaneel ("X is more than 12 levels above these mobs") en de dungeonlijst (wie te hoog is).
- Eerst meten: UnitLevel van groepsleden en vijanden leesbaar in Forever? Diagnose `/mh …` (zwijg-regel).
- ✅ Gebouwd 15 nov avond (alleen op main, NIET in het spel gezien): regel GEMETEN ("meer dan 12", 12 = nog XP), groepspaneel-
  regel + `*` in de dungeonlijst + `/mh dungeons check`. Zie NEXT_SESSION en TESTLIJST 15 nov avond.

### Forever: Horde/Alliance-tekentje vóór elk character in "Your characters"
- Voor wie:      allebei (wie characters aan beide kanten heeft)
- Moment:        venster "Your characters" (`/mh alts`, tegel in de Me-kamer)
- Spel:          Forever
- Bron:          Rob 14 nov (via Sparring 14-11, screenshot): *"Maar ik kan niet zo 1, 2, 3 zien of het nu een horde is
                 of een alliance. Dus daar moet een horde of alliance tekentje voor."* ("voor morgen, of als het heel snel
                 kan voor nu")
- Bouwt op:      `ForeverChars.lua` (snapshot per character)
- Data:          GEMETEN: Blizzards UI-PVP-Horde/-Alliance.blp bestaan in Forever (ManifestInterfaceData 70938). De kant
                 = UnitFactionGroup bij het inloggen. Oude rijen hebben hem niet (ras werd ook niet bewaard) → "?".
- Vindbaar:      vanzelf; `/mh alts check` toont "side"
- Werk:          klein
- Site:          nee
- Rob zegt:      ja (zijn wens). **Gebouwd 14 nov:** embleem vóór de naam; "?" + zin "? = Horde or Alliance not known
                 yet: log in on that character once." rechts op de totaalregel. 7 talen (it Engels). luac + lint 0 HARD.
                 NIET in het spel gezien.

### Forever: "Do this now" noemt WELKE knop een lagere rank cast
- Voor wie:      allebei (iedereen met een oude rank op een knop)
- Moment:        "Do this now" en de startpagina, regel over oude ranks
- Spel:          Forever
- Bron:          Rob 14 nov (via Sparring 14-11, shaman, screenshot): *"Maar kan je aangeven welke het is?"*; op het
                 voorstel (spell bij naam met oude en nieuwe rank + "1 button" i.p.v. "1 buttons"): *"Ja, doe allebei
                 maar."* Rob zag die dag ook de oranje rand: *"Ze worden inderdaad oranje omringd."*
- Bouwt op:      `ForeverRanks.lua` Scan() (dezelfde lijst als de oranje rand en `/mh ranks`)
- Data:          GEMETEN in de code: Scan() geeft per knop naam, fromIdx, toIdx (al gebruikt in de tooltip "%s: %d -> %d")
- Vindbaar:      vanzelf; `/mh ranks` toont per knop slot + id
- Werk:          klein
- Site:          nee (zin in een bestaand venster)
- Rob zegt:      ja. **Gebouwd 14 nov, na de tag v5.3.0** → komt in de volgende release. `ns.ForeverRankSentence()`:
                 1 knop = "1 button on your bars casts Lightning Bolt rank 1; you know rank 2. …"; meer = de oude
                 telzin + "Which: X rank 1 (you know 2), …" (max 4, dan "and N more"; dezelfde spell één keer).
                 Zelf vertaald: nl/de/fr/es/pt/ru (it valt terug op Engels, zoals de oude zin). luac + lint 0 HARD.
                 ✅ Rob zag de zin (sparring, screenshot, shaman): *"1 button on your bars casts Healing Wave rank 1;
                 you know rank 2…"*. Maar hij vond de knop niet: *"terwijl er op mijn bar rank 2 staat … Vandaar ik ook
                 die oranje rand natuurlijk niet zag"* (zijn `/mh ranks`: slot 27, rand "on: 1 button"). Daarom
                 (zelfde vraag, "welke het is") ook de PLEK: "It is on Action Bar 4, button 3 (key X)." — Blizzards
                 eigen HUD_EDIT_MODE_ACTION_BAR_LABEL (GEMETEN in Forever GlobalStrings 70938), toets via
                 GetBindingKey, "(that bar is hidden now)" als de knop niet zichtbaar is; ook in `/mh ranks`.
                 Niet in het spel gezien. (Dit plek-deel kwam als idee van sparring ZONDER Robs ja; sparring vraagt
                 hem of het blijft. Niet terugdraaien tot hij antwoordt.)
                 Rob vond de knop (toets C) maar zag de rand NIET, terwijl `/mh ranks` "1 button(s) with an edge" zei.
                 Rob via sparring, letterlijk: *"Ja, je moet die rand duidelijker maken, dus ik volg jouw advies."* →
                 **Gebouwd 14 nov:** elke lagere rank de sterke rand (2 px, vol oranje; de zachte 1 px / 0,55 vervalt);
                 `/mh ranks` zegt nu op welke knop de rand staat en met welke alpha (een vervagende balk blijft
                 IsVisible). Instellings- en glow-teksten in 7 talen aangepast. Niet in het spel gezien.

### Forever: dungeons en raids, uitgelegd op MH's manier (richting 2 + de route erheen)
- Voor wie:      allebei (nieuweling: "welke dungeon past bij mij en hoe kom ik er?"; veteraan: "welke quests neem ik mee?")
- Moment:        als je level bij een dungeon past (bv. een regel in "Do this now": "je bent 18, deze dungeon past nu,
                 neem eerst deze quests mee"); met de pijl naar de ingang
- Spel:          Forever
- Bron:          Rob 14 nov (via Sparring 14-11, letterlijk): *"Maar met de addon wil ik graag het forever deel ook uit
                 breiden met dungeons en raids"*; op de vier punten van sparring (lijst met level en ingang, tip per baas,
                 quests vooraf, goede loot voor jouw character): *"Alle 4 die punten, er is een addon genaamt dungeon
                 journal en ik heb hem denk ik geinstalleerd"*; uit drie richtingen: *"We gaan voor 2 incl de route er
                 naar toe"*. Richting 2 = niet nabouwen wat DungeonJournal doet; MH legt uit in zijn eigen stijl, met
                 eigen gegevens uit Blizzards tabellen.
- Bouwt op:      "Do this now", de route-pijl + reisplanner (`NativeArrow.lua`, `Modules/Travel/`), raid-locks in
                 `ForeverWeek.lua`, de vorm van het Midnight-dungeonvenster (`DungeonBossWindow.lua`)
- Data:          NIET GEMETEN. ForeverDungeonJournal (Exehn, 2.0.5) staat in de Forever-map; geen licentie gevonden
                 (sparring) → niets van zijn data of code overnemen. Eerst zelf meten: welke dungeons/raids, levels,
                 ingangen, quests (wago DB2 `--game forever`, Wowhead-tooltips, Zygor, HandyNotes).
                 GEMETEN 14 nov: geen Forever-module over dungeons (grep `dungeon|instance` in `Modules/Forever*.lua`:
                 alleen raid-locks in ForeverWeek en losse vermeldingen; het patroon vond wél 31 regels).
- Vindbaar:      vanzelf, in "Do this now" op het juiste level; diagnose-commando nog te kiezen
- Werk:          groot (AFGELEID)
- Site:          ja, als het uit is
- Rob zegt:      ja, richting 2 + route. Onderzoek klaar (`docs/forever/DUNGEONS_2026-11-14.md`, f314c9f). Op het plan
                 (via sparring, letterlijk, Willow-dictee): *"Voor A, beginnen we met stap 1. Meneer Bouwert na de
                 release. … En dan hebben we C. Ja, dat mag. De ingangen van de handy notes erom meeleveren."*
                 → Stap 1 = "Do this now"-regel "past nu bij je level" + knop Route + lijst van alle dungeons (level,
                 kant, ingang). Bouwen pas NA de release ("Meneer Bouwert" = "B: bouwen", lezing sparring).
                 Ingangen uit HandyNotes_DungeonRaidLocations-Forever (MIT, copyrightregel "Pirson" mee); Krol'dok,
                 Alcaz, Blackmaw, Shaper's Terrace op "nog nameten". Stap 2-5 (quests, baastips, loot, raids): later.
                 **Stap 1 gebouwd 14 nov (na 5.3.0):** `Modules/ForeverDungeons.lua` (beide toc's, returnt in Midnight).
                 35 rijen (30 dungeons + vleugels), levels = Blizzards GroupFinderActivity, naam = de client
                 (GetRealZoneText; vleugelwoorden Engels, NIET gemeten), ingang = HandyNotes (MIT-tekst in de kop) of
                 web (4 nieuwe, `*` + zin "not checked"). "Do this now": tip "Dungeons for your level (18): …" (max 3,
                 RFC alleen Horde, Stockade alleen Alliance; laat het venster niet vanzelf komen) + knop "Dungeons".
                 Venster: groen = past, grijs = onder je, knop Route per rij (pijl via de reisplanner, tooltip met
                 "The way there"). `/mh dungeons`, `/mh dungeons check`. luac + lint 0 HARD. NIET in het spel gezien.
                 15 nov: alle ingangen nu uit HandyNotes 1.02 (de vier web-rijen en de Stockade), geen `*` meer.

### Forever: dungeonlijst per zone, met een vinkje "alleen voor mijn level"
- Voor wie:      allebei (nieuweling: niet één lange lijst; veteraan: snel alles zien)
- Moment:        het venster "Dungeons in Forever" (`/mh dungeons` of de knop in "Do this now")
- Spel:          Forever
- Bron:          Rob 15 nov (via Sparring 15-11, letterlijk): *"Kunnen we dat, die lijst aanpassen of zo updaten dat het
                 per zone is? Dat het niet meer één lange lijst wordt? ... dat we een optie geven of we alles willen zien.
                 Of alleen maar beschikbaar voor je level."* Op de drie ideeën van sparring: *"Ja, we beginnen met deel 1
                 en inderdaad net iets te hoog mag er ook bij."* (voorbeeld van sparring: 2 levels)
- Bouwt op:      `Modules/ForeverDungeons.lua` (stap 1 hierboven)
- Data:          geen nieuwe; 35 rijen, 24 zones (GEMETEN door sparring in de code)
- Vindbaar:      in het venster zelf: vinkje bovenaan, kopjes per zone; `/mh dungeons check` zegt de stand en welke
                 dungeons "net te hoog" meetellen
- Werk:          klein
- Site:          ja, als het uit is
- Rob zegt:      ja (deel 1). Niet gekozen: werelddeel-knoppen (idee 2), levelblokken (idee 3).
                 **Gebouwd 15 nov (alleen op main):** kopje per zone ([+]/[-], klik = open/dicht, met het aantal), zones
                 op hun laagste dungeon-level; vanzelf open = zones met iets voor jouw level; een klik blijft deze
                 sessie gelden, tot je level verandert. Vinkje "Only dungeons for my level (also up to 2 levels higher)",
                 standaard AAN, onthouden per account (`ns.db.foreverDungeonsAll`). Net te hoog = oranje met "(+N)",
                 groen/grijs zoals het was. Niets voor je level → een regel die zegt dat je het vinkje weg kunt halen.
                 en/nl/ru/de/fr/es/pt (eigen vertaling, niet nagekeken door moedertaalsprekers); itIT blijft Engels,
                 zoals de rest van dit venster. luac + lint 0 HARD. NIET in het spel gezien.

### Keuzevenster "New in this version: your choice": dicht na kiezen + titel vrij van "Dock to window"
- Voor wie:      allebei (iedereen die het venster na een update krijgt)
- Moment:        na een update, het keuzevenster; klik op een keuze (On/Off, een stand)
- Spel:          Midnight + Forever
- Bron:          Rob 13 nov: *"ik koos on maar het scherm bleef staan en ging later pas weg"*; via sparring, letterlijk:
                 *"Ja, dicht na kiezen"*. Titel: Robs screenshot 4.png (titel liep onder "Dock to window").
- Bouwt op:      `NewChoices.lua` (zelfde knoppen, zelfde functies als de instelling)
- Data:          GEMETEN in de code: een keuze sloot alleen bij `closes` (alleen het toetsen-kaartje)
- Vindbaar:      vanzelf; `/mh new` toont het venster opnieuw
- Werk:          klein
- Site:          nee (gedrag van een bestaand venster)
- Rob zegt:      ja voor één kaartje. Meer kaartjes: dicht als elk kaartje een keuze kreeg (advies sparring, AFGELEID,
                 niet Robs woord). **Gebouwd 13 nov (704e76b).** Midnight getest en goed (Rob: *"na de keuze was ie
                 inderdaad weg"*; titel: 5.png). Open: Forever met meer kaartjes (TESTLIJST 13 nov).
                 13 nov avond, fout van Rob: kwam niet vanzelf op een nieuw character → late check na 6 en 20 s
                 gebouwd; wacht op Robs test.
                 14 nov: getest door Rob (Forever nieuw + bestaand, Midnight nieuw) en uitgebracht in **5.3.0**.

### Midnight-groepspaneel: stop-spell op het doelwit als je geen purge hebt
- Voor wie:      allebei (vooral wie geen purge heeft: Paladin, Warrior, Rogue, DK, DH, Druid, Monk, Evoker)
- Moment:        in een groep, rechtsklik op het doelwit van een groepslid in het Party targets-paneel
- Spel:          Midnight
- Bron:          Rob 26 sep (lege klik op de Prot Paladin); Rob 12 nov via sparring: *"Optie 1, jouw advies"*
- Bouwt op:      `PartyTargets.lua` (purge-helft), `KeybindRoles_*.lua` (interrupt-id's per spec)
- Data:          GEMETEN in de KeybindRoles-tabellen (id + specs); pet-kicks zonder id bewust weg
- Vindbaar:      vanzelf (rechtsklik); `/mh glow` zegt welke spell
- Werk:          klein
- Site:          ja, als het uit is (`docs/SITE_SEIN.md` 12 nov)
- Rob zegt:      ja. **Gebouwd 12 nov**, offline 7/7. Wacht op Robs test (TESTLIJST 12 nov).

### Lint [27]: geen commando's die alleen wij gebruiken in de release-tekst
- Voor wie:      wij (spelers zien geen testknoppen meer in de release-tekst)
- Moment:        bij elke lint-run; vooral vóór een release
- Spel:          Midnight + Forever (de release-tekst is gedeeld)
- Bron:          Rob 11 nov over `/mh selftest` in 5.1.0; Sparring 12-11, Rob: *"Ja, bouw dat"* (12 nov)
- Bouwt op:      `tools/release_text_check.py` (C3, lint [22])
- Data:          GEMETEN: alle 29 namen op de lijst worden door de code gerouteerd
- Vindbaar:      lint [27]; `run release_text_check --selftest`
- Werk:          klein
- Site:          nee (hulpmiddel)
- Rob zegt:      ja. **Gebouwd 12 nov**, proef 2/2 en tegenproef 0. Niets in het spel te testen → naar Af.

### Forever: Priest-tip "Shadowform" klopt weer met de hotfix van 11 nov
- Voor wie:      allebei (Gnome-Priest)
- Moment:        How you play → Priest → Beginner mistakes
- Spel:          Forever
- Bron:          content-wachter 12 nov [RAAKT ONS]; Blizzard-hotfix 11 nov: Confounding Flash werkt nu in Shadowform
- Bouwt op:      `ForeverHowToPlay.lua` + 7 `Locales/ForeverHowToPlay_*.lua`
- Data:          GEMETEN in Blizzards hotfixtekst; Chastise/Fear Ward NIET GEMETEN (zin blijft daar zoals hij was)
- Vindbaar:      vanzelf, in de Priest-kaart
- Werk:          klein
- Site:          nee (tekstfix)
- Rob zegt:      ja (*"Ja, doe allebei"*, 12 nov). **Gebouwd 12 nov.** Wacht op Robs blik (TESTLIJST 12 nov).

### Forever: de pijl wijst de boot, zeppelin, tram of het portaal aan
- Voor wie:      allebei (nieuweling: "waar moet ik heen?"; veteraan: "welke boot ook alweer?")
- Moment:        als je een pijl zet naar iets op een ander continent, op Teldrassil, of in Ironforge vanuit Stormwind
- Spel:          Forever
- Bron:          Rob in het spel, 10 nov 2026, Darkshore → wapentrainer in Ironforge: *"waar ga ik naartoe?"*
- Bouwt op:      de route-pijl (`NativeArrow.lua`) en de vorm van de Midnight-reisplanner; het wapentrainer-venster
- Data:          GEMETEN — havens uit Blizzards Forever-DB2 (TaxiPathNode 70888), Wowhead-NPC's, Robs eigen boten in Auberdine
- Vindbaar:      vanzelf: de pijl en "The way there" in het wapenvenster; `/mh travel` alleen als diagnose
- Werk:          middel
- Site:          ja, als het uit is (`docs/SITE_SEIN.md`)
- Rob zegt:      ja (*"uitzoeken en bouwen graag"*, 10 nov). **Gebouwd: 7bb1e53.** Wacht op Robs test (TESTLIJST 10 nov avond).

### `/mh selftest` en de vensterregel (opdracht 7, stap c)
- Voor wie:      wij (Rob test niet meer óf iets bestaat, alleen of het goed voelt); later misschien spelers
- Moment:        na een patch of een grote wijziging; Rob typt het, `/reload`, de bouwchat leest het rapport
- Spel:          Midnight + Forever
- Bron:          plan deel 4b stap 7 (sparring-chat); Rob 11 nov: *"Ja, bouw het"* (in de bouwchat)
- Bouwt op:      `tools/data_check.py` (dezelfde scanner, één lijst), `DialogPopup.lua` SCALABLE_WINDOWS
- Data:          GEMETEN in Blizzards API-documentatie: DoesSpellExist / DoesItemExistByID / GetMapInfo; quest en
                 achievement hebben geen betrouwbare "bestaat niet"
- Vindbaar:      `/mh`-commandolijst + zoekbalk
- Werk:          middel
- Site:          nee (hulpmiddel)
- Rob zegt:      ja. **Gebouwd 11 nov** (zelftest + lint [25] vensters + [26] lijst actueel). Wacht op Robs eerste run.
                 Later: fase 2, per venster "heeft zijn tekst".

### De buff-melding wordt een zin
- Voor wie:      allebei (nieuweling: "wát mis ik?"; veteraan: in één blik zien welke)
- Moment:        als er een buff, aura, stance, pet of wapen-buff ontbreekt
- Spel:          Midnight + Forever (Rob, 11 nov: *"Ja, met jouw advies"*: beide spellen, icoon blijft waar de speler het zette)
- Bron:          Rob, 11 nov 2026, na PaladinPlan (GPL-3.0: alleen het idee, geen code of tekst)
- Bouwt op:      `MissingBuff.lua` (icoon + klik), `ForeverBuffs.lua` (Forever-lijst)
- Data:          spellnaam uit de client (dus altijd in de taal van die client)
- Vindbaar:      vanzelf, onder het icoon; `/mh buffs` (Forever) en `/mh mbuff` tonen dezelfde zin
- Werk:          klein
- Site:          ja (`docs/SITE_SEIN.md`)
- Rob zegt:      ja. **Gebouwd 11 nov**, met drie reparaties: Greater Blessings tellen mee (Forever), de onware zin
                 "de onze kun je in gevecht aanklikken" is weg, `/mh mbuff` bestaat altijd (2237696).
                 ✅ Forever gezien door Rob, 11 nov (blessing + aura, `/mh buffs`). Nog open: Midnight, in een gevecht,
                 Greater Blessing. Daarna naar **Af**.

### Buff "bijna afgelopen", met de tijd erbij
- Voor wie:      allebei
- Moment:        buiten een gevecht, als een buff bijna afloopt (rood = weg, geel = loopt af)
- Spel:          Forever eerst
- Bron:          Rob, 11 nov 2026, na PaladinPlan
- Bouwt op:      de buff-melding hierboven
- Data:          NIET GEMETEN: of `expirationTime` via `ns.Aura` leesbaar is in Forever. Eerst meten.
- Vindbaar:      vanzelf, dezelfde plek als de buff-melding
- Werk:          middel
- Site:          ja, als het uit is
- Rob zegt:      ja (later; via de sparring-chat, door Rob bevestigd in de bouwchat 11 nov)
                 **GEMETEN + GEBOUWD 19 nov** (volgorde: *"we gaan akkoord met het voorstel van het bouwadvies"*): Robs
                 meting zegt buiten een gevecht leesbaar, in een gevecht niet → gebouwd voor buiten een gevecht: "<buff>
                 (4 min left) runs out soon." in de buff-melding. ✅ Rob 19 nov: *"En dit werkt ook. Juppie."* → Af.

### Forever: venstertje "Doe dit nu / Alles bij / Komt eraan"
- Voor wie:      vooral nieuweling
- Moment:        tijdens het levelen: wat nu te doen, en welke spells de volgende 3 levels komen (bij naam)
- Spel:          Forever
- Bron:          Rob, 11 nov 2026, na PaladinPlan
- Bouwt op:      ForeverTrainer, ForeverRanks, de wapenteller, GetMissingBuffs; met een schakelaar
- Data:          AFGELEID: alles bestaat al in die modules; niets nieuw gemeten
- Vindbaar:      nog te bepalen
- Werk:          middel tot groot
- Site:          ja, als het uit is
- Rob zegt:      ja (later). Eerst met de sparring-chat doorpraten wat erin moet, voor alle classes; nog niet ontwerpen.
                 ✅ **Ontwerp doorgepraat 12 nov** (sparring, samen met "Welke kant ga ik op?" hieronder; daar de schets).
                 Rob: *"Schets klopt"*. Keuzes (letterlijk): spel *"Eerst Forever (Recommended)"*, Midnight later apart;
                 zonder gekozen richting *"Werkt gewoon (Recommended)"* (dan zonder "past bij jouw richting"); in beeld
                 *"Alleen als er iets is (Recommended)"*, een schakelaar zet het op "altijd". **Geen bouw-go.**
                 **Bouw-ja 12 nov** (via sparring, letterlijk: *"Venster 'Doe dit nu'"*). **Gebouwd 12 nov:**
                 `Modules/ForeverDoNow.lua`, `/mh donow` (+ `check`, `auto|always|off`), instelling. Alleen bestaande
                 onderdelen, geen nieuwe meting; met richting de eerstvolgende talent-spell. ✅ Rob: "Het venster staat
                 er, werkt" (21.png). Daarna "Ja, alle drie" (geen dubbele kop, rank erbij, nette wapenzin) en over de
                 standaard: *"Laat zo, in een gevecht weg en rechtsboven"*.

### Eén schakelaar "Verplaatsen" voor alle MH-onderdelen op het scherm
- Voor wie:      allebei
- Moment:        als je je scherm inricht: alles zichtbaar met "sleep mij"
- Spel:          Midnight + Forever
- Bron:          Rob, 11 nov 2026, na PaladinPlan
- Bouwt op:      de losse sleep-functies die elk onderdeel al heeft (bv. het buff-icoon)
- Data:          niet nodig
- Vindbaar:      instellingen + een `/mh`-commando
- Werk:          middel
- Site:          ja, als het uit is
- Rob zegt:      ja (later). **Bouw-ja 12 nov** (via sparring, keuze letterlijk: *"Knop 'Verplaatsen'"*). **Gebouwd 12 nov:**
                 `Modules/MoveMode.lua`, `/mh move` (+ `why`), instelling "Move MH elements on your screen". 11 onderdelen
                 (lijst op framenaam); slepen gaat via de eigen sleep-code van elk onderdeel. Niet in het spel gezien
                 (TESTLIJST 12 nov avond).

### Alle ontbrekende buffs tonen, en uitleggen welke MH kiest
- Voor wie:      allebei
- Moment:        als er meer dan één buff ontbreekt (nu toont MH alleen de eerste, `MissingBuff.lua` UpdateMissingBuff)
- Spel:          Midnight + Forever
- Bron:          Rob, 11 nov 2026, na PaladinPlan
- Bouwt op:      de buff-melding; de keuze "laatst gecast wint" (`ForeverBuffs.lua` PickChoice) in de tooltip uitleggen
- Data:          niet nodig
- Vindbaar:      vanzelf
- Werk:          klein tot middel
- Site:          ja, als het uit is
- Rob zegt:      ja (later). **Bouw-ja 12 nov** (via sparring, keuze letterlijk: *"Alle ontbrekende buffs"*). **Gebouwd 12 nov:**
                 kleine icoontjes naast het grote (`MissingBuff.lua` ShowExtras), tooltip "Why …" + "Also missing"
                 (AddTooltipExtras); de uitleg van de keuze alleen in Forever (Midnight heeft geen keuzelijsten). Het grote
                 icoon cast nog steeds alleen de eerste. Niet in het spel gezien.

### Gereedschap vergeten: MH zegt het als het spel het zegt, met de pijl
- Voor wie:      vooral nieuweling
- Moment:        het spel zegt "Requires Skinning Knife" (of Mining Pick, Blacksmith Hammer, een hengel)
- Spel:          Forever
- Bron:          Rob, 12 nov 2026, bij Cisca (via sparring): *"Kunnen we niet gelijk iets maken waarbij we op het moment
                 dat ze Skinning kiest, er een melding komt, hey, vergeet Skinning Knife niet. En dan ook de pijl waar we
                 het kunnen kopen."* De leer-tip bestond al; het gat was wie het beroep al had.
- Bouwt op:      de gereedschap-tip in `ForeverVendors.lua` (venster, "Show the way", verkoperslijst)
- Data:          GEMETEN in Forever DB2: foutmelding "Requires %s" + de gereedschapnamen per taal (zie handoff 12 nov)
- Vindbaar:      vanzelf, op het moment van de fout; schakelaar in de instellingen en `/mh vendor tip on|off`
- Werk:          klein
- Site:          ja, als het uit is
- Rob zegt:      ja (via sparring, letterlijk: *"Ja, laat hem dat uitzoeken en bouwen"*). **Gebouwd 12 nov**, niet in het
                 spel gezien (TESTLIJST 12 nov avond).

### Vlak voor een gevecht: je mist iets wat aan moet staan (bv. geen seal)
- Voor wie:      vooral nieuweling
- Moment:        je hebt een vijand als doel, buiten een gevecht
- Spel:          Forever (Midnight: Rob nog niet gevraagd)
- Bron:          Rob, 11 nov 2026, na PaladinPlan (*"deze melding vond ik ook briljant"*; GPL-3.0: alleen het idee)
- Bouwt op:      ForeverWarnings (de rust-waarschuwing bij een vijandig doel) en de lijst per class in ForeverBuffs
- Data:          GEMETEN 11 nov: "Seal" komt niet voor in `ForeverBuffs.lua`. Nog te meten: wat per class aan moet staan
                 (seal, aspect, poison, wapen-buff, schild …) en of een seal in Forever leesbaar is via `ns.Aura`
- Vindbaar:      een zin op de plek van de andere waarschuwingen, met een schakelaar
- Werk:          nog te schatten na het uitzoeken
- Site:          ja, als het gebouwd is
- Rob zegt:      ja (via de sparring-chat, 11 nov; nog te bevestigen in de bouwchat)

### Welke kant ga ik op? (idee 7, hoort bij het "Doe dit nu"-venster)
- Voor wie:      de nieuweling (Rob: *"als newbie weet ik nu helemaal niks"*)
- Moment:        zodra je kunt kiezen (eerste talentpunt), en elke keer dat je iets krijgt waarvan je niet weet of het
                 bij je past (een wapen, gear). Robs voorbeeld: een two-handed sword; is het nu al de lange loop naar de
                 wapentrainer waard?
- Spel:          Forever (Midnight: Rob nog niet gevraagd)
- Bron:          Rob, 11 nov 2026, paladin level 5 (via de sparring-chat)
- Bouwt op:      ForeverHowToPlay (uitleg per class), ForeverWeapons (`/mh weapons`), de upgrade-rekenaar (questbeloning
                 + tooltipregel), en het "Doe dit nu"-venster (moet weten wat de speler wil worden)
- Data:          GEMETEN 11 nov (bouwchat): `ForeverHowToPlay.lua` noemt losse talent-spells (Seal of Command, Shadowform …)
                 maar legt nergens de keuze tussen de richtingen uit. Nog te meten, alle classes: de richtingen in gewone
                 woorden, wat elke richting nodig heeft, vanaf welk level de keuze telt, wat opnieuw kiezen kost.
- Vindbaar:      op het moment van de keuze, op het scherm, niet via een commando
- Werk:          groot; samen met het "Doe dit nu"-venster als één ontwerp
- Site:          ja, als het gebouwd is
- Rob zegt:      ja, eerst doorpraten in de sparring-chat (via de sparring-chat, 11 nov; nog te bevestigen in de bouwchat)
                 ✅ **Ontwerp doorgepraat 12 nov** (sparring). Rob op de schets: *"Schets klopt"*. De schets (AFGELEID,
                 niets gemeten): (1) één keer kiezen ~~bij je eerste talentpunt~~ → **meteen, vanaf level 1** (Rob, 12
                 nov, keuze letterlijk: *"Meteen, vanaf level 1"*; overslaan en later wisselen mag; de keuze kleurt dan
                 vanaf het begin het wapen- en gear-advies. Reden: eerste talentpunt pas op 10, Robs two-handed-sword-
                 voorbeeld speelde op 5): "Welke kant wil je op?", per class twee of
                 drie richtingen in één gewone zin (paladin: klappen uitdelen, klappen opvangen, of genezen); (2) het
                 "Doe dit nu"-venster gebruikt die keuze: "Doe dit nu" (bv. 2 spells bij de trainer), "Alles bij",
                 "Komt eraan" (spells van de komende 3 levels bij naam); (3) de keuze kleurt de tooltip en de
                 upgrade-melding ("past bij jouw richting" / "past niet"); (4) beroepen als vierde soort advies (Rob:
                 *"Ja, misschien is het wel een goed idee."*, richting, geen besluit); (5) altijd wisselen, schakelaar
                 om het uit te zetten. Keuzes: zie het venster hierboven. 🔎 Uitgezocht 12 nov (Rob: *"Ja, alle
                 classes"*): `docs/forever/RICHTINGEN_PER_CLASS_2026-11-12.md` (richtingen, nodig, level 10, respec;
                 prijzen NIET gemeten). Nog te meten blijft de rest van de Data-regel hierboven;
                 of dat uitzoeken nu gebeurt, vraagt sparring aan Rob. Grens: van PaladinPlan (GPL-3.0) alleen het idee,
                 geen code, tabellen, plaatjes of teksten. **Geen bouw-go.**
                 **Bouw-ja voor stap 1, 12 nov** (via sparring; Robs vraag *"Kunnen we daar niks van bouwen, dat dat zo meteen
                 nog kan gaan testen"*, keuze letterlijk: *"De vraag 'Welke kant?'"*). **Gebouwd 12 nov:**
                 `Modules/ForeverDirection.lua`: de vraag na het inloggen (na de balkenvraag), drie knoppen met boomnaam
                 (DB2, GEMETEN) + één zin (AFGELEID), Later / Never ask again / No choice, keuze per character,
                 `/mh direction` (+ `check`), knop in het "How you play"-venster, instelling. NIET gebouwd (bewust): het
                 "Doe dit nu"-venster, "past bij jouw richting", beroepenadvies, kosten, beste wapen. Niet in het spel gezien.
                 ✅ Rob op een Rogue (via sparring): "dit werkt". **Stap 1 + 2 gebouwd 12 nov** (Rob via sparring,
                 letterlijk: *"1 en 2, de wapens er meteen bij"*): blok "Your direction" bovenaan How you play (pantser en
                 "werkt alleen met" GEMETEN; wapen = gids) en een groen + in `/mh weapons`. Stap 3 (tooltip en
                 upgrade-melding wegen mee) NIET gebouwd: de stats tijdens het levelen zijn niet gemeten.
                 **Stap 3 GEBOUWD 19 nov** (Rob via sparring: *"we gaan akkoord met het voorstel van het bouwadvies"*):
                 de stats volgden de richting al (`ns.ForeverStatDef`, 16 nov); nu zegt ook het WAPENTYPE het: tooltip
                 "MH: Fits your direction (…)" (lichtgroen) of "Your direction (…) does not use this kind of weapon"
                 (oranje), en de questbeloning-melding zegt hetzelfde. Wacht op Robs test.

### Spelnamen in de zes talen zoals die client ze toont (C4)
- Voor wie:      allebei, in de/fr/es/pt/it/ru (Engels en Nederlands veranderen niet)
- Moment:        overal waar MH een spelnaam toont: titel, delve, mount-plek, Trading Post, World Boss, drankje
- Spel:          Midnight
- Bron:          de C4-controle (`run data_check --c4 --all`), 65 namen op 10 nov
- Bouwt op:      de regel "clientnaam wint altijd" (CLAUDE.md, Localization)
- Data:          GEMETEN — elke naam uit Blizzards DB2 van die taal (wago, live 12.1.5.70783)
- Vindbaar:      vanzelf, het is de tekst zelf
- Werk:          klein
- Site:          nee
- Rob zegt:      ja (*"Ja, alle drie"*, 11 nov). **Gebouwd 11 nov:** 41 waarden herschreven (mh-writer), 8 op de negeerlijst
  met reden, 3 bewust open (de Duitse/Spaanse delve-naam staat ook midden in een zin). C4 nu 3 nakijken. Wacht op een
  tester met een niet-Engelse client (TESTLIJST 11 nov).
- Nog open:      dezelfde oude namen staan nog in ~70 andere zinnen per taal (`docs/C4_OUDE_NAMEN_2026-11-11.md`). Rob kiest.

### Spell geleerd maar nog op slot: MH zegt welke quest je moet doen
- Voor wie:      vooral de nieuweling
- Moment:        zodra je een spell krijgt of ziet die je pas na een class-quest kunt gebruiken
- Spel:          Forever (Rob bevestigde in de bouwchat: "Ja, dat was in Forever")
- Bron:          Rob, 11 nov 2026, Paladin level 4, Judgement ("Als ik er geen ervaring mee had, snapte ik er niks van");
                 doorgegeven door de sparring-chat
- Bouwt op:      ForeverTrainer (questtabel), ForeverHowToPlay
- Data:          wordt uitgezocht (mh-research, 11 nov): bij welke classes en spells, questnaam en quest-ID per geval.
                 GEMETEN door de sparring-chat: MH zegt nu Judgement = level 4 bij de trainer, zonder quest
                 (`ForeverTrainerData.lua:523`, `ForeverHowToPlay.lua:80`). Klopt dat niet, dan is het ook een fout.
- Vindbaar:      waar de speler de spell tegenkomt (trainer-lijst, speelkaart), niet alleen in de chat
- Werk:          na het uitzoeken
- Site:          ja, als het gebouwd is
- Rob zegt:      ja (in de sparring-chat, 11 nov; doorgegeven), en in de bouwchat "Ja, bouw dat". **Gebouwd 11 nov:**
                 Judgement-seal-tip + Claw-fix (ebcefef); trainervenster zegt bij een ontbrekende quest-rank "(uit een
                 class-quest, niet bij de trainer)" (`ns.FOREVER_QUEST_FIRST` in `ForeverTrainer.lua`); How you play bij
                 Redemption, Aquatic Form en de Priest-rasspells. Wacht op Robs test (TESTLIJST 11 nov).

### Melding bij een upgrade die je net oppakt
- Voor wie:      allebei, vooral de nieuweling
- Moment:        direct nadat het item in je tas komt (Rob: op lage levels loop je hard rond, je krijgt dingen vanzelf in
                 je tas, en je moet nu je tas openhouden om te zien of er een upgrade bij zit)
- Spel:          Midnight en Forever (Rob koos "allebei")
- Bron:          Rob, 11 nov 2026, tijdens het spelen; doorgegeven door de sparring-chat («MidnightHelper werkwijze sparring»)
- Bouwt op:      `Modules/LootUpgrade.lua` (tooltip-regel, `/mh loot`) en `Modules/BagUpgrade.lua` (groene pijltjes,
                 `/mh bagarrows`), beide via `ns.GetLootUpgradeInfo`. Volgens de sparring-chat (GEMETEN door hen): beide
                 alleen in `MidnightHelper.toc`, niet in de Forever-toc. Nog geen melding bij het oppakken (AFGELEID door hen).
- Data:          nog te meten: (1) geeft `ns.GetLootUpgradeInfo` op lage levels een bruikbaar oordeel (gewichten per spec)?
                 (2) kan de rekenaar in Forever draaien?
- Vindbaar:      een korte melding op het scherm zelf, niet alleen in de chat (Rob: "niemand kijkt in de chat"), met een
                 schakelaar zodat spelers zelf kiezen
- Werk:          nog te schatten na het nameten
- Site:          ja, als het gebouwd is
- Rob zegt:      ja (in de sparring-chat, 11 nov; doorgegeven). Voorstel van de sparring-chat, niet van Rob: alleen melden
                 bij een duidelijke upgrade, dezelfde lat als de pijltjes. Nog niets gebouwd: eerst de twee metingen.
                 Aanvulling (Rob, 11 nov, doorgegeven): **eerst de groene pijltjes en de tooltip-regel ook in Forever**, dan
                 pas de melding. Volgorde: zie NEXT_SESSION 11 nov (stap b vóór d).
                 **Stap b, 11 nov (Rob: "Alleen tooltipregel"):** geen pijltjes in Forever (Pawn doet ze al, Baganator
                 vervangt de tassen; GEMETEN in Robs addon-lijst). Wel gebouwd: een groene "MH: … over what you wear (…)"-
                 regel in de tooltip, met de rekenaar van de questbeloning-tip, `/mh geartip`. Wacht op Robs test.
                 (2) hierboven is daarmee beantwoord: de Forever-rekenaar is die van de questbeloning-tip.
                 **Stap d, 11 nov (Rob: "Ja, allebei"): de melding zelf gebouwd**, beide spellen: `PickupUpgrade.lua`,
                 kort schermbericht + chatregel, `/mh pickup`. (1) hierboven GEMETEN: Midnight-rekenaar heeft een spec
                 nodig en kijkt niet naar draagbaarheid → rode-regel-check + alleen ilvl én score hoger. Wacht op Robs test.

### Zygor-wachter: elke ochtend wat er in Zygor veranderde
- Voor wie:      wij (bron voor questketens, coördinaten, mounts, achievements)
- Moment:        elke ochtend, in de ochtendronde
- Spel:          Midnight en Forever (beide Zygor-mappen)
- Bron:          open punt sinds 10 nov (Zygor werkte MID-mounts en -achievements bij); Rob: ja (11 nov, via de sparring-chat)
- Bouwt op:      `tools/handynotes_watch.py` (zelfde vorm: kopie, verschil per zone, via de voordeur)
- Data:          Zygor-gidsen op Robs pc; alle zones
- Vindbaar:      een stap in `docs/OCHTENDRONDE.md`
- Werk:          klein tot middel
- Site:          nee
- Rob zegt:      ja (doorgegeven; in de bouwchat 11 nov: *"Ja, door met stap e"*). **Gebouwd 11 nov:**
                 `tools/zygor_watch.py`, stap 16 van de ochtendronde. Nulmeting: Midnight Zygor 9.6 (717 gidsen), Forever
                 1.6 (104). `--selftest` bewijst dat een wijziging gezien wordt. Af zodra hij de eerste echte update meldt.

### Forever: de tooltip zegt voor welk beroep een item een ingrediënt is
- Voor wie:      N + V (wie twijfelt bij de verkoper: verkopen of bewaren?)
- Moment:        elke keer dat je met je muis op een item staat (tas, verkoper, loot)
- Spel:          Forever (Midnight alleen als Rob het apart vraagt)
- Bron:          Rob, 11 nov (Stringy Wolf Meat bij de verkoper; Meaty Bat Wing leek Leatherworking)
- Bouwt op:      de tooltip-haak van ForeverQuestHint/ForeverToolGuard, `ns.ForeverMyProfessions`
- Data:          Blizzards DB2 (SkillLineAbility + SpellReagents + ItemSparse), 524 items, 7 KB, gegenereerd
- Vindbaar:      staat er vanzelf; `/mh usedfor` om te zien wat hij besloot
- Werk:          klein
- Site:          ja, één zin bij de Forever-functies (bij de volgende release)
- Rob zegt:      ja (sparring-chat: *"Ja, laat bouwen"*; bouwchat 11 nov: *"Ja, met probe-fix"*). **Gebouwd 11 nov:**
                 `Modules/ReagentUse.lua` (eerst `ForeverReagentUse.lua`) + gegenereerd `ForeverReagentData.lua`
                 (`run forever_reagents --emit`). **AF in Forever 11 nov** (Rob: *"Ja, af"*, na Linen Cloth, Stringy Wolf
                 Meat, Hearthstone en `/mh usedfor`). Niet gezien: de grijze regel en Copper Ore.
                 **Midnight erbij, 11 nov** (Rob: *"Kunnen we dit ook in de midnight versie bouwen?"* → meten → *"Ja,
                 bouw het"*): `MidnightReagentData.lua` (`--emit --midnight`), alleen Midnight-recepten, 296 items.
                 Wacht op Robs test in Midnight.

### Forever: stop-spell voor de Paladin (klein) en het groepspaneel (midden)
- Voor wie:      N + V in een groep
- Moment:        in een dungeon met een groep
- Spel:          Forever
- Bron:          Rob, 11 nov (via de sparring-chat: "zo'n mooie partyframe … kunnen we ook zoiets in deze maken"; koos
                 "Klein en midden")
- Bouwt op:      klein: `ForeverMacros.lua`; midden: `PartyTargets.lua` (nu alleen retail)
- Data:          spell-ids GEMETEN in wago (853 Hammer of Justice, 1152 Purify)
- Vindbaar:      klein: `/mh macros`; midden: `/mh partytargets`
- Werk:          klein: klein; midden: middel, en deels alleen in een echte groep te testen
- Site:          later, met het paneel
- Rob zegt:      ja. Bouwchat 11 nov: *"Ja, alleen klein"* (midden later, eerst meten). **Klein gebouwd 11 nov:** twee
                 Paladin-macro's (Hammer of Justice = stun, Purify). Midden: open. Aparte vraag voor later: krijgt het
                 Midnight-paneel ook "stop-spell op het doelwit" (nu purge)?
                 Midden gemeten 12 nov (partyProbe, 5 gevechten), daarna Rob via sparring, letterlijk: *"A, eerst klein"*.
                 **Gebouwd 12 nov:** `Modules/ForeverPartyPanel.lua` (rijen, klik = doelwit, rechtsklik = dispel,
                 Blizzards rode rand; standaard uit; `/mh partytargets`). Geen stop-spell-knop (= optie B, mogelijke
                 stap 2). Niet in het spel gezien; de rode rand moet in een dungeon blijken (TESTLIJST 12 nov avond).

### CurseForge-plaatjes: echte screenshots op één vaste achtergrond
- Voor wie:      wij (CurseForge-pagina en de site); spelers zien alleen het resultaat
- Moment:        als Rob nieuwe screenshots maakt (hooguit 4-6, actueel)
- Spel:          Midnight en Forever
- Bron:          Rob, 11 nov (via de sparring-chat; achtergrond "Nummer 2" uit ComfyUI)
- Bouwt op:      niets in de addon; los gereedschap via de voordeur
- Data:          Robs eigen screenshots + `E:\ComfyMCP\output\mh_cf_achtergrond_00002_.png` (kopie in de mediamap)
- Vindbaar:      `run cf_media --help`; map `E:\MidnightHelper-media\` (input, output, shots.txt)
- Werk:          klein
- Site:          ja, de plaatjes zelf
- Rob zegt:      ja (in de bouwchat 11 nov: *"Ja, bouw het"*). **Gebouwd 11 nov:** `tools/cf_media.py`, lettertype Cinzel
                 (OFL 1.1, GEMETEN in de naamtabel van het font). **AF 11 nov:** Robs zes screenshots erdoor gehaald
                 (`E:\MidnightHelper-media\output\01-06`), 5 en 6 opnieuw gemaakt op level 8; Rob: *"Ja, goed zo"*.
                 Uploaden naar CurseForge en site doet Rob zelf.

### Forever: "je hebt geen Hearthstone" bij een reis over het water
- Voor wie:      nieuweling (Rob: "zeker in het begin")
- Moment:        als de pijl je over het water stuurt en je geen Hearthstone draagt
- Spel:          Forever
- Bron:          Rob, 11 nov, Paladin zonder Hearthstone (verkocht voor geld en tasruimte) in Tirisfal
- Bouwt op:      de reisplanner (`ForeverTravel.lua`) en het wapenvenster
- Data:          GEMETEN — item 6948 "Hearthstone" en de naam per taal in de Forever-DB2 (1.60.1.70888)
- Vindbaar:      vanzelf: chatregel + venster; `/mh travel` als diagnose
- Werk:          klein
- Site:          ja, als het uit is (`docs/SITE_SEIN.md`)
- Rob zegt:      ja (*"bouw het maar"*, 11 nov). Gebouwd 11 nov. Wacht op een test (TESTLIJST 11 nov).

### Forever: Enhancement Shaman blijft op Strength (reparatie)
- Voor wie:      Shaman-spelers in Forever met Mental Dexterity
- Moment:        bij een questbeloning
- Spel:          Forever
- Bron:          content-wachter 11 nov (Blizzard blue post 6 nov + hotfix 10 nov)
- Bouwt op:      `ForeverMainStats.lua` / `ForeverQuestHint.lua`
- Data:          via zoekmachine gelezen op meerdere sites, niet in de client
- Vindbaar:      vanzelf (de quest-tip)
- Werk:          klein
- Site:          nee
- Rob zegt:      ja (*"Ja, repareer"*, 11 nov). Gebouwd 11 nov. Wacht op een test (TESTLIJST 11 nov).

### De regisseur: één overzicht van alles
- Voor wie:      Rob (één bericht per dag in plaats van zes) en alle chats
- Moment:        elke ochtend om 06:20, en op de pc met `/regisseur`
- Spel:          allebei
- Bron:          Rob, 11 nov, in de brainstorm-chat: *"Ja op alle drie, bouw de regisseur maar"*; hier: *"Ja, bouw hem"*
- Bouwt op:      `docs/REGIE.md` (het geheugen), plan deel 8, de andere wachters
- Data:          n.v.t. (hij meet in de repo's)
- Vindbaar:      blok 0 van `docs/REGIE.md`; CLAUDE.md ochtendronde
- Werk:          klein
- Site:          nee
- Rob zegt:      ja (11 nov). **Gebouwd 11 nov:** routine `trig_017LQWJNvptK8hWLuByuEDzg`, recept `regisseur`. Af na een
  proefrun die de dingen vindt die waar zijn, en een eerste gewone ochtend (12 nov).

### De vier ochtendwachters kijken ook naar Forever
- Voor wie:      wij (de addon zegt veel over Forever, en geen wachter keek ernaar)
- Moment:        elke ochtend
- Spel:          Forever
- Bron:          brainstorm-chat 11 nov, Rob daar: *"Ja, voeg Forever toe aan de wachters"*; hier: *"Yeah"*
- Bouwt op:      de vier wachters en `docs/WATCHER_FOREVER.md`
- Data:          n.v.t.
- Vindbaar:      in de vier wachterbestanden, onder **Forever:**
- Werk:          klein
- Site:          nee
- Rob zegt:      ja (11 nov). **Gebouwd: 9ca5e32** + de vier opdrachten aangevuld. Af zodra de inhaalronde van 11 nov
  en de run van 12 nov allebei een Forever-deel hebben.

---

## Af — sinds de oude lijsten gebouwd (niet opnieuw voorstellen)

GEMETEN vandaag in de code. Niet gemeten: of het in een release zit en of het in het spel werkt.

- **Death-recap-les uit Blizzards eigen recap** (oude A1) — `Retrospective.lua:312-322`, gebouwd 10 okt.
- **Codex: Midnight beginnen op een alt** (oude A3) — `MidnightCodexData.lua:165-168`.
- **Trading Post: transmog "heb je al"** (deel van oude A6) — `TradingPost.lua:213-225`.
- **Toetsen op Bartender4 en ElvUI** (deel van oude A2) — `LiveKeys.lua:9-11`.
- **Tank en healer markeren op rol** (oude D3) — `FastMark.lua:256-295`.
- **WoW Forever** (oude B5) — eigen TOC `MidnightHelper_Camelot.toc` (16001), uit sinds 5.0.0.
- **"Ik heb 20 minuten"** (`PLAN_IDEEEN` idee B) — `TimePlan.lua`.
- **Forever: macro's per spec** — `ForeverMacros.lua:367` (10 nov, top 3 per spec).
- **Vragenlijst #16: de Midnight-achievements die je nog mist** — `MidnightAchList.lua` (`/mh achlist`, 5 okt).
- **Vragenlijst #24: "wat doe ik voor gear?"** — `GearLadder.lua` (`/mh gear`, 19 okt). Zij antwoordde 21 okt en kende het niet: zie S1.
- **Vragenlijst #11: weekplan voor solo-spelers** — schakelaar `mh_homeSolo` (`SettingsDefs.lua:591`, 2 okt). Vragenlijst #13 noemt hem met lof.
- **Verhaal per delve-run bewaren** (`PLAN_IDEEEN` stap 1) — `DelveHistory.lua`.
- De 26 punten uit bak C van de oude lijst (C1 t/m C26): niet opnieuw gemeten, zie daar.
- **Forever: rares** (Rob 18 nov) — stap A + B gebouwd 18 nov (`ForeverRares.lua`; Find, zoekbalk, rode pijl; 19 nov je
  eigen gebied eerst). Door Rob getest 18 nov (*"1 is goed gekeurd"*) en 19 nov (test 4). In 5.6.0. Onderzoek:
  `docs/forever/RARES_2026-11-18.md`. (Verplaatst uit Open op 19 nov; stond daar nog als "geen bouw-ja".)
- **Forever: zoekbalk + valuta en reputaties** (Rob 18 nov) — zoekbalk stap 1 + 2 en de pagina Reputation & currency
  gebouwd 18 nov; door Rob getest 18 nov (*"1 tot en met 4 gaat goed"*; "ah" vindt het Auction House). In 5.6.0.
  Onderzoek: `docs/forever/ZOEKBALK_EN_VALUTA_2026-11-18.md`. (Verplaatst uit Open op 19 nov.)

Niet opnieuw gemeten, twijfel: **Ritual Sites-mounts** (oude A8). `MountProgress.lua` noemt nu meer dan één
Ritual Sites-mount; of alle vijf erin staan is niet geteld.

---

## Nee — met reden (niet opnieuw voorstellen)

Overgenomen uit de oude lijst (X1 t/m X9), NIET opnieuw gemeten.

- Live dispel-melding voor groepsleden — 12.1 maakt die auras geheim.
- Void Assault naar de Special Assignment routeren — Rob koos de hub.
- Item level per M+-sleutelniveau — de API gaf onzin.
- CurseForge-vertaalplatform — loopt via GitHub.
- "Beste curio"-ranglijst — een andere addon doet dat al.
- De hele Ula'tek-campagne stap voor stap — Rob koos licht.
- Muisknoppen standaard vullen in het toetsenblok — Rob 4 okt: leeg laten.
- Wago-downloadteller — zit achter een betaalmuur.
- Start Here als starttabblad, Raids onder Dungeons — afgewezen door het ontwerppanel.
- FarstriderLib als reisplanner (oude A12) — het grootste gat is zelf opgelost; alleen een meetknop gebouwd. *Mijn
  voorstel voor "nee"; Rob beslist.*
- Beroepenplan exporteren naar KnowledgeLoadout (oude A18) — nooit door Rob gevraagd. *Mijn voorstel voor "nee".*
- KeyUI bestuderen (oude A16) — onderzoek, geen idee voor spelers. *Mijn voorstel voor "nee".*

---

## Voorstellen van de wachter

De wekelijkse ideeën-wachter (cloud-routine, sinds 10 nov 2026) schrijft ALLEEN hier, onderaan, hooguit drie per week
in de vaste vorm. De bouwchat verplaatst ze naar Open, of naar Nee met reden. Niemand anders schrijft in dit blok.

- [2026-11-15] 💡 **Ideeënbus** — 2 voorstellen; gelezen: CurseForge-reacties (API via Exa, 8 berichten, nieuwste
  6 okt: niets binnen 14 dagen), GitHub-issues Huijting/MidnightHelper (0 sinds 1 nov), Blizzards hotfixpagina's
  (via `CONTENT_WATCH.md` en `PTR_12.0.7_DATA.md` van 14-15 nov, plus het forumbericht van 15 nov), Reddit/forums via
  Exa-zoeken (r/wowforever-samenvattingen, Blizzard-forum Forever, beginnersgidsen 4-14 nov). Geen Reddit-pagina zelf
  geopend; de Reddit-citaten komen uit artikelen die ze aanhalen.

### Forever: "in deze groep krijgt niemand XP" (lid meer dan 12 levels boven de dungeon)
- Voor wie:      allebei (nieuweling die door een vriend of guildie wordt meegenomen; veteraan die een alt helpt)
- Moment:        in een groep, als je het Dungeons-venster opent of "Do this now" de dungeonregel toont, en een
                 groepslid meer dan 12 levels boven die dungeon zit
- Spel:          Forever
- Bron:          Blizzard (Kaivax), forumbericht "Player-Level Dungeon XP Adjustment – November 14",
                 https://us.forums.blizzard.com/en/wow/t/player-level-dungeon-xp-adjustment-november-14/2416343 (15 nov
                 2026, 01:18 UTC): XP valt voor de groep weg zodra een speler "more than 12 levels above the level of the
                 enemies" is. Basisregel in de Forever-hotfix van 13 nov (gelogd in `CONTENT_WATCH.md` [2026-11-14]).
- Bouwt op:      `Modules/ForeverDungeons.lua` (levels per dungeon uit GroupFinderActivity, "Do this now"-tip, venster)
- Data:          regel GEMETEN (Blizzards eigen tekst, door de data-wachter zelf gelezen op NA en EU, `PTR_12.0.7_DATA.md`
                 [2026-11-15]). Nog te meten: welk getal de server als "level of the enemies" neemt (de mobs, niet het
                 dungeonbereik uit GroupFinderActivity), en of `UnitLevel("party1..4")` in Forever altijd leesbaar is.
- Vindbaar:      vanzelf: één zin in het Dungeons-venster en bij de dungeonregel van "Do this now", alleen als het speelt;
                 `/mh dungeons check` zegt welk groepslid en hoeveel levels
- Werk:          klein
- Site:          ja, als het uit is
- Bestaat al?:   grep `trivial|nullif|12 levels|LEVELS_ABOVE` in `Modules/` en `Locales/`: alleen Midnight-treffers
                 (`DelveCoach.lua:2116` UnitIsTrivial, `NameplateColors.lua`, `CombatSafety.lua`), niets in Forever.
                 grep `xp|UnitLevel|party|GetNumGroupMembers` in `ForeverDungeons.lua`: alleen `UnitLevel("player")`
                 (r. 144, 298, 340), geen groepsleden. Positieve controle zelfde ronde: `GroupFinderActivity` en "Route"
                 wél gevonden in `ForeverDungeons.lua`. Uitkomst: bestaat niet.
- Rob zegt:      (open)

### Forever: "Do this now" zegt dat een nieuwe spell op geen enkele balk staat
- Voor wie:      vooral nieuweling
- Moment:        na een trainerbezoek, als je een spell hebt geleerd die op geen enkele actieknop staat
- Spel:          Forever
- Bron:          Blizzards development notes van 2 nov 2026 (nieuwe spells komen niet meer vanzelf op je balk), samengevat
                 in https://timesaver.gg/blog/wow-forever-beginner-guide-new-players (4 nov 2026) als "the number one
                 beginner trap at launch"; Rob 12 nov: *"niet iedereen zal onze Keys layout gebruiken"* (O24).
- Bouwt op:      `Modules/ForeverDoNow.lua` (luistert al naar ACTIONBAR_SLOT_CHANGED); het "ask me"-plaatsen van het
                 toetsenblok (`ForeverBlock.lua`, `KEYBLOCK_MODE_FMT`) doet dit al, maar alleen voor wie het blok gebruikt
- Data:          nog te meten: welke Forever-functie zegt of een spell op een knop staat (`C_ActionBar.FindSpellActionButtons`
                 of de 1-180-loop van `ForeverRanks.lua`), en welke spells passief zijn (die horen niet op een balk)
- Vindbaar:      vanzelf, als regel in "Do this now" ("Fireball rank 1 is on none of your bars. Open your spellbook (P)
                 and drag it on."), met dezelfde schakelaar als dat venster
- Werk:          klein
- Site:          ja, als het uit is
- Bestaat al?:   grep op `bar` in `ForeverDoNow.lua` en de enUS-tekst: "old ranks on your bars" (`SET_FOREVER_DONOW_DESC`,
                 `NEWC_DONOW_BODY`) = de positieve controle, wel gevonden; een regel "staat op geen balk" niet.
                 grep `onbar|notOnBar|FindSpellBookSlot|HasAction` in `Modules/Forever*.lua`: alleen `ForeverBlock.lua:47`
                 (het toetsenblok). grep `not on your bars`: alleen `CARD_SOLO_NOKEY` (enUS:841, een kaarttekst). Uitkomst:
                 bestaat alleen voor gebruikers van het toetsenblok.
- Rob zegt:      (open)

- [2026-11-22] 💡 **Ideeënbus** — 3 voorstellen; gelezen: CurseForge-reacties (API via Exa, nieuwste 6-7 okt: niets
  binnen 14 dagen), GitHub-issues Huijting/MidnightHelper (0 sinds 8 nov), Wowhead Blue Tracker (Forever-hotfixes
  10-20 nov, Midnight-hotfixes 5-6 nov), Blizzard-forum Forever (US 6 en 9 nov, EU 10 nov), SenseOS-FAQ (15 nov).
  Geen Reddit-pagina zelf geopend; de zoekronde gaf alleen forum- en gidspagina's.

### Forever: "nog 3 van de 5 dungeon-resets dit uur"
- Voor wie:      veteraan (wie een dungeon farmt of steeds reset)
- Moment:        bij het betreden van een dungeon, en als je groep reset (de vijfde keer binnen een uur)
- Spel:          Forever
- Bron:          Blizzard, WoW: Forever Hotfixes 20 nov 2026, https://www.wowhead.com/forever/blue-tracker/news/us/wow-forever-hotfixes-november-20-2026-world-of-warcraft-blizzard-news-24315281
                 (20 nov 2026): "Players can now reset and enter each dungeon a maximum of 5 times per hour (was 10)."
- Bouwt op:      `Modules/ForeverDungeons.lua` (dungeonvenster, "Do this now"-dungeonregel)
- Data:          regel GEMETEN (Blizzards tekst). Nog te meten: welke foutmelding de client geeft bij nummer 6
                 (GlobalString, per taal), en of de telling per dungeon of over alle dungeons gaat; MH kan alleen eigen
                 binnenkomsten tellen (die van een ander character op het account niet)
- Vindbaar:      vanzelf: één regel bij binnenkomst ("4e binnenkomst dit uur, de 6e lukt pas om 14:32"), alleen vanaf
                 de 4e keer; `/mh dungeons resets` print de telling en waarom
- Werk:          klein
- Site:          ja, als het uit is
- Bestaat al?:   grep `per hour|instances? per|RESET_INSTANCES|ResetInstances|INSTANCE_RESET|TOO_MANY_INSTANCES|ERR_INSTANCE`
                 in `Modules/`, `Locales/enUS.lua`, `docs/IDEEEN.md`: alleen "once per hour" (Camp Tent, `ForeverHowToPlay.lua:51`)
                 en twee Midnight-teksten, niets over resets. Positieve controle zelfde ronde: `GroupFinderActivity` wél
                 gevonden in `ForeverDungeons.lua:13`. Uitkomst: bestaat niet.
- Rob zegt:      (open)

### Forever: tooltip op een wapen dat je class wél kan leren, maar jij nog niet kent
- Voor wie:      vooral nieuweling (komt van retail, weet niet dat wapens een skill nodig hebben)
- Moment:        als je over een wapen in je tas, bij een verkoper of in de buit hovert dat je nog niet kunt dragen
- Spel:          Forever
- Bron:          Blizzard-forum EU, "Completly New to Classic/Forever ..coming from Retail",
                 https://eu.forums.blizzard.com/en/wow/t/completly-new-to-classicforever-coming-from-retail/641222
                 (10 nov 2026): een level 13 hunter vraagt waarom hij geen two-handed axes en geen guns kan gebruiken,
                 en "if yes, from where and who?"
- Bouwt op:      `Modules/ForeverItemTips.lua` (zegt al "your class can never use this") + `Modules/ForeverWeapons.lua`
                 (weapon masters per wapen, dichtstbijzijnde eerst, met pijl)
- Data:          GEMETEN voor de classmaskers en weapon masters (staat in beide bestanden, wago wowf 1.60.1.70938);
                 de koppeling wapen-subclass → skill is AFGELEID (op naam, `ForeverItemTips.lua:12`)
- Vindbaar:      vanzelf, in de tooltip: "Learn Two-Handed Axes at a weapon master: Sayoc, Orgrimmar (Find → Weapons)"
- Werk:          klein
- Site:          nee
- Bestaat al?:   grep `weapon ?master` in `Modules/Forever*.lua`: `ForeverWeapons.lua` (Find + pijl) en de telling in
                 `ForeverDoNow.lua:310` = positieve controle, gevonden. grep `weapon skill|IsUsableItem|ITEM_REQ_SKILL|proficien`
                 in `Modules/Forever*.lua`: geen tooltipregel op het item zelf; `ForeverItemTips.lua:12` zegt alleen
                 "never", een "not yet" laat hij aan Blizzards rode regel. Uitkomst: de hulp bestaat, maar niet op het
                 moment dat je het wapen ziet — dit is dus "vindbaarheid van weapon skills".
- Rob zegt:      (open)

### Forever, hunter: pet-XP en waar je pet een nieuwe vaardigheid leert
- Voor wie:      nieuweling (hunter)
- Moment:        als je pet een level stijgt of je het Beast Training-venster opent
- Spel:          Forever
- Bron:          zelfde EU-forumtopic (10 nov 2026), vraag 3 ("How do i teach it dash, charge, swipe … the trainer only
                 has endurance and health") en post 9 ("Is there a way to check pet EXP … Maybe an addon?")
- Bouwt op:      `Modules/ForeverClassQuests.lua` (hunter-tamingquests, r. 616-725) en "Do this now" (`ForeverDoNow.lua`)
- Data:          nog te meten: of `GetPetExperience` in Forever werkt, en hoe pets in Forever vaardigheden leren (de
                 forumantwoorden zeggen "by taming, at least in classic" — dat is spelers-geheugen, geen Forever-meting;
                 eerst DB2/Beast Training nakijken)
- Vindbaar:      vanzelf: "Your pet: level 14, 320/1200 XP" in "Do this now" bij een hunter met pet; uitleg in de Codex
                 alleen als de leerregel gemeten is
- Werk:          middel
- Site:          ja, als het uit is
- Bestaat al?:   grep `tame|beast training|pet training|petlevel|UnitLevel("pet")` in `Modules/Forever*.lua`,
                 `Locales/enUS.lua`, `docs/IDEEEN.md`: alleen de tamingquests (`ForeverClassQuests.lua`) en spellnamen in
                 `ForeverBlock_Hunter.lua:70`. grep `GetPetExperience|pet xp|pet experience` in `Modules/` en enUS: niets.
                 Positieve controle zelfde ronde: `UnitLevel("player")` gevonden in `ForeverDungeons.lua:149`. Uitkomst:
                 bestaat niet.
- Rob zegt:      (open)
