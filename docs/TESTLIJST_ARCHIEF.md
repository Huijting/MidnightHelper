# Testlijst — archief

Afgesplitst op 17 sep 2026 (Rob: de telefoonpagina had 196 punten, *"zijn er wel heel veel"*).
Alles hieronder stond in `docs/TESTLIJST.md` en is **niet** weggegooid: het is alleen weg van de
afvinkpagina, die nu de laatste twee testrondes toont. Wil je hier alsnog iets van nalopen, zet de
sectie dan terug bovenaan `TESTLIJST.md` en bouw de pagina opnieuw.

Tweede verhuizing op 21 sep 2026: de rondes van 16 en 17 sep (Rob: *"ja doe maar"*).

## ⏹️ Derde verhuizing, 20 nov 2026 — alles van vóór 10 nov: VERVALLEN, NIET GETEST

Rob, 20 nov 2026 (via sparring), letterlijk: *"Beide ja"* op de vraag *"De testlijst: de oude punten van vóór
10 november naar een archief 'vervallen, niet getest', in plaats van een gewoon vinkje."* Hieronder staan de
secties waarvan de kop een datum vóór 10 nov heeft. `[vervallen, niet getest]` = stond open, is NIET door Rob
getest en ook niet goedgekeurd. `[x]` = wél getest (zoals het was). Een sectie die ook een datum van 10 nov of
later noemt, is in TESTLIJST.md blijven staan. 1068 open punten verhuisd.

## 🆕 9 nov (nacht) — Forever: "Waar koop ik dit?" (winkeliers met pijl)

- [vervallen, niet getest] `/mh vendor` opent het venster: links Fishing Pole, Strong Fishing Pole, Mining Pick, Skinning Knife, Blacksmith
      Hammer, Flint and Tinder, Thieves' Tools, General Goods, Trade Supplies (itemnamen in de taal van je client).
      Rechts de verkopers aan jouw kant, dichtstbijzijnde bovenaan, met zone en afstand.
- [vervallen, niet getest] Klik "Pijl" bij een verkoper: de pijl wijst ernaartoe. Open onderweg een ándere winkel: pijl blijft. Open de winkel
      van die verkoper (of sta op 5 m): pijl weg.
- [vervallen, niet getest] Leer een beroep zonder gereedschap (bv. Mining zonder Mining Pick, op een alt): er komt een venstertje "Je hebt
      Mining geleerd, maar je hebt nog geen Mining Pick. De dichtstbijzijnde verkoper: …" met "Wijs de weg" en "Alle
      verkopers". Beroepen die je al had komen NIET.
- [vervallen, niet getest] `/mh vendor check` toont per soort hoeveel verkopers en de dichtstbijzijnde. `/mh vendor fishing` opent meteen de
      hengel-lijst.
- [vervallen, niet getest] Redridge: klopt de plek van een verkoper in Lakeshire (bv. Amy Davenport)? Wowhead en Zygor verschillen daar ~5.

## 🆕 9 nov (nacht) — Forever: Handige macro's + mouseover in het toetsenblok

- [vervallen, niet getest] `/mh macros` in Forever opent het venster "Handige macro's": Heal, Verband, Vijand kiezen en aanvallen, Focus,
      Doodshoofd, Trinkets, en je racials (Night Elf: Shadowmeld + Elune's Light). Shift+scroll maakt het groter.
- [vervallen, niet getest] Klik "Maak" bij Heal: de macro "MH+ Heal" staat in je macrolijst (tab van je karakter), het macrovenster gaat open.
      Sleep hem op een balk. Druk = healthstone, Shift + druk = healing potion. 🔴 Werkt `/use item:<nummer>` in
      Forever? (AFGELEID) — gebeurt er niets, zeg het: dan bouw ik het om.
- [vervallen, niet getest] Verband: met je muis op een groepslid = verband op hem; zonder = op jezelf, en je houdt je target.
- [vervallen, niet getest] Gebruik je laatste healthstone op: "MH+ Heal" wordt vanzelf alleen de potion (MH werkt hem bij na het gevecht).
- [x] Vijand kiezen + aanvallen (melee): ✅ 9 nov Rob — target werkt, `/startattack` = slaan met je wapen (hij verwachtte
      afstand; de uitleg zegt dat nu).
- [vervallen, niet getest] Attack per klasse: Hunter = Auto Shot op afstand; Mage/Priest/Warlock MET wand = schieten met de wand; zonder wand
      of andere klasse = slaan. Wand aantrekken → "MH+ Attack" wordt vanzelf de wand-versie (druk "Bijwerken" als niet).
- [vervallen, niet getest] Doodshoofd, Focus (Shift = weg), Trinkets: doen ze wat de regel zegt?
- [vervallen, niet getest] Shadowmeld-macro: stopt je aanval en cast, dan Shadowmeld.
- [vervallen, niet getest] Retail: `/mh macros` opent nog steeds het oude Macros-tabblad.
- [vervallen, niet getest] `/mh mouseover on` (Druid met toetsenblok): Healing Touch (C), Regrowth, Rejuvenation, Innervate, Remove Curse en
      Mark of the Wild gaan naar wie onder je muis staat; Roots (V, in normale vorm) en Faerie Fire naar de vijand onder je
      muis. Niets onder je muis: zoals altijd. Beer- en kattoetsen veranderen niet. `/mh mouseover` toont de macro's met
      mouseover; `/mh mouseover off` zet alles terug.

## 🆕 9 nov (laat) — Forever: waarschuwing "je hebt je vishengel nog in je handen"

- [vervallen, niet getest] Doe eerst je mace + schild aan (MH onthoudt ze), pak dan de hengel en klik een vijand aan: grote melding
      "Let op: je hebt je vishengel nog in je handen!" en in de chat "Zet terug: [mace] + [schild]".
- [vervallen, niet getest] Zelfde vijand nog eens aanklikken: geen tweede melding. Binnen 30 s een andere vijand: ook stil.
- [vervallen, niet getest] Al vissend aangevallen worden: de melding komt bij het begin van het gevecht.
- [vervallen, niet getest] Met je wapen in de hand: nooit een melding. `/mh pole` toont hand, onthouden spullen en de laatste beslissing;
      `/mh pole off` zet hem uit, `/mh pole on` weer aan.

## 🆕 9 nov (laat) — Forever: geen "WEAPON BUFF" met een hengel in je hand

- [vervallen, niet getest] Shaman met de Fishing Pole in de hand: de knop "WEAPON BUFF" verdwijnt meteen. Weer een wapen erin: hij komt
      terug (als er geen weapon buff op zit). `/mh buffs` zegt "fishing pole in hand".

## 🆕 9 nov (laat) — Forever: trainerpijl blijft staan bij een andere trainer

- [vervallen, niet getest] Zet een pijl naar een beroepstrainer (bv. leatherworking). Praat onderweg met een ándere trainer (vissen,
      eerste hulp, je klassetrainer): de pijl moet blijven staan.
- [vervallen, niet getest] Praat daarna met de goede trainer: nu gaat de pijl weg (en het kruisje boven zijn hoofd ook).

## 🆕 9 nov (avond) — Midnight: kaarten, Talebound, Codex

- [x] 🔴 Retail `/reload`: MH laadt gewoon (nieuwe TOC-regel `AllowLoadGameType: standard`). ✅ 9 nov Rob: retail
      ingelogd + getest, geen foutmelding. Forever laadt ook (zijn `/mh week` + `/mh ranks` werkten).
- [vervallen, niet getest] Op een paar specs `/mh play`: geen "{SPELL:" in beeld, nieuwe regels kloppen. Vooral Outlaw (S1/S2), Devastation (S1),
      Demonology (S4), Mistweaver (HERO1/S4), Holy Priest (S2/HERO1). Quiz-tab: vragen werken nog.
- [x] Balance Druid: "Solar Eclipse" blijft op de kaart (Rob koos A, 9 nov).
- [vervallen, niet getest] Na 12.1.7: Codex → Weekly heeft "Turbulent Timeways VI (12.1.7)", World heeft "Lorewalking (12.1.7)".

## 🆕 9 nov — Forever: oude ranks op je balken

- [x] Typ `/mh ranks` op een character met een paar spells op de balk: hij noemt het aantal spell-knoppen en welke een
      lagere rank hebben dan je kent. ✅ 9 nov: 6 knoppen, 2 met bekende ranks, 0 te laag.
- [vervallen, niet getest] Bij de trainer een nieuwe rank leren (Train all of los): onder het trainervenster komt **"Balken bijwerken (N)"**,
      en in de chat één regel. Hover = welke spells. Klik = de knop gebruikt daarna de nieuwe rank (tooltip van de knop).
- [vervallen, niet getest] Startpagina: staan er knoppen met een lagere rank, dan een gele regel + knop "Zet de nieuwste rank erop".
- [vervallen, niet getest] (Als je wil) `/mh ranks auto on`: na het trainen gebeurt het vanzelf.

## 🆕 9 nov — Midnight: Turbulent Timeways VI (pas na patch 12.1.7)

- [vervallen, niet getest] Nu op live: bij Mounts staat **geen** Markeet of the Infinite (hij hoort verborgen te zijn tot 12.1.7).
- [vervallen, niet getest] Na 12.1.7: Markeet of the Infinite staat erbij met "X van 4" of "X van 5" weken (het getal komt uit het spel).

## 🆕 9 nov — Midnight: Zo speel je-kaart Devourer Demon Hunter

- [vervallen, niet getest] Op een Devourer DH, `/mh play` (How you play): de Void-Scarred-regel
      noemt Voidblade, dan The Hunt vóór Void Metamorphosis, en als demon Pierce the Veil + Predator's Wake vóór elke
      Collapsing Star. Alle spell-namen en icoontjes kloppen, geen "{SPELL:" in beeld.
- [vervallen, niet getest] Onder de kaart staan nu ook weer de "waarom"-regels (W1-W5) en de uitleg van souls.

## 🆕 9 nov — Forever: NPC-nummer uit de GUID

- [vervallen, niet getest] Klik in Forever een NPC aan en typ `/dump UnitGUID("target")`. Stuur wat er staat (bv. "Creature-0-...-12345-...").
      Zo zien we of Blizzard daar al letters of rare tekens gebruikt.
- [vervallen, niet getest] Sta bij een trainer, klik hem aan en typ `/mh trainer here alchemy` (of je eigen beroep). Daarna `/mh trainer mark`
      na een "go": bij die trainer staat een npc-nummer, niet "npc nil".

## 🆕 8 nov (laat) — Forever: kaarten in de kamer "Me" + pijlknop op de startpagina

- [vervallen, niet getest] BugSack-fout van 8 nov ("attempt to concatenate local 'prof' (a table value)"): klik op de startpagina op de knop
      voor de pijl naar je klassetrainer. Geen fout meer, en de pijl gaat naar je klassetrainer.
- [vervallen, niet getest] Open MH en klik op **Me**. Je ziet nu kaarten, net als in Tools: de startpagina, What can I learn?, Profession
      trainers, How you play, Your key block, Keys (en Nameplate colours als MF Nameplates aan staat). Let op: MH opent nu
      eerst op die kaarten in plaats van meteen op de startpagina.
- [vervallen, niet getest] Elke kaart heeft een plaatje en opent het goede venster. Muis erop → korte uitleg.
- [vervallen, niet getest] De kaart What can I learn? zegt eronder "N to learn now" of "next at level N".
- [vervallen, niet getest] Rechtsklik op een kaart → verbergen; onderaan komt dan "Hidden: 1", daar haal je hem terug. Slepen verplaatst.

## 🆕 8 nov (avond) — Forever: venster "Profession trainers"

- [vervallen, niet getest] Open het venster op drie manieren: `/mh trainers`, de knop "Profession trainers" op de Forever-startpagina (onder je
      klassetrainer), en de kaart in de Tools-kamer. Alle drie openen hetzelfde venster.
- [vervallen, niet getest] Links staan 12 beroepen. Jouw eigen beroepen staan bovenaan, in goud, met je skill erbij (bv. "Herbalism 75/150").
      Het gekozen beroep licht op.
- [vervallen, niet getest] Klik op Alchemy. Rechts staat "Alchemy: N trainers for your side". Daaronder de trainers, de dichtstbijzijnde
      bovenaan: naam, "up to skill …", gebied en afstand. Trainers op een ander continent staan onderaan
      ("other continent").
- [vervallen, niet getest] Klik bij een trainer op **Arrow**: de pijl en het kruis gaan naar precies die trainer, ook als hij niet de
      dichtstbijzijnde is.
- [vervallen, niet getest] `/mh trainers herbalism` opent het venster meteen op Herbalism.
- [vervallen, niet getest] Bijna aan je grens (bv. Herbalism 70/75)? Bovenaan staat dan welke skill je trainer moet leren. Trainers die dat
      niet kunnen, zijn grijs en zeggen "cannot teach your next rank".
- [vervallen, niet getest] Shift+scroll maakt het venster groter en kleiner; Escape sluit het.

## 🆕 8 nov — Forever: pijl naar een beroepstrainer

- [vervallen, niet getest] Forever, eerst: `/mh trainer check`. In de chat moet staan: je eigen beroepen met nummer en rang (bv. Herbalism
      182, 75/150). Daarna een regel per beroep met hoeveel plekken er voor jou zijn en de dichtstbijzijnde trainer.
      Staat er bij jouw beroep een ander nummer dan 182 (Herbalism), meld het: dan klopt de koppeling niet.
- [vervallen, niet getest] `/mh trainer alchemy`: de pijl en het kruis gaan naar de dichtstbijzijnde alchemietrainer van jouw kant. In de chat
      staat de naam met "(Alchemy)" erachter. Bij de trainer stopt de route vanzelf als je hem aanspreekt.
- [vervallen, niet getest] Trainervenster (`/mh trainer`): onderaan een rijtje "Profession trainers:" met 12 knoppen. Jouw eigen beroepen
      staan vooraan, in goud. Muis erop → wie het dichtst bij is, hoe ver, en tot welke rang hij leert.
      Klik → pijl, en de regel boven de knoppen zegt "Arrow (…): naam, about … yards".
- [vervallen, niet getest] Sta naast een beroepstrainer en typ `/mh trainer here alchemy` (of je eigen beroep). Daarna wint die plek.
      `/mh trainer forget alchemy` haalt hem weer weg.
- [vervallen, niet getest] Bijna aan je rang-grens (bv. Herbalism 70/75)? Dan moet de pijl een trainer kiezen die de volgende rang leert,
      niet een "Junior"-trainer. Cooking, First Aid of Fishing boven 125/150: "no trainer in MH's list teaches your
      next rank" (op Wowhead leert niemand die rang; volgens gidsen is het een boek of een quest).
- [vervallen, niet getest] Redridge: staat Crystal Boughman echt op ongeveer 17.6, 43.6 (`/way` of je kaart)? Zygor zegt 5 verder.

## 🆕 8 nov — Midnight: vaste Forever-regel onderaan de startpagina

- [vervallen, niet getest] Midnight, `/mh`: helemaal onderaan de startpagina een grijze regel "Also playing WoW Forever? ...". (Alleen als je
      de 5.0-banner al had weggeklikt.) Klik erop → de grote banner met de installatie-uitleg staat weer bovenaan.

## 🆕 8 nov — Forever: tassen bijna vol, weinig mana/leven, buff-knop

- [x] (Rob 8 nov: melding gezien, "heel snel weg" → nu 6 s i.p.v. 2 s; opnieuw kijken) Tassen: zorg dat je nog 3
      plekken vrij hebt, raap 1 ding op → grote melding "Only 2 free bag slots left" midden
      in beeld + chatregel met je grijze spullen en hun waarde. Raap nog iets op: geen nieuwe melding. Bij 0: "Your
      bags are full". `/mh bags` zegt wat MH ziet en besloot.
- [x] (Rob 8 nov, screenshot) Mana/leven (nieuwe manier, 8 nov): eerst `/mh rest test show` → "Low mana: drink first" en "Low health: eat
      first" staan 4 s in beeld. Niet? Dan werkt de omweg niet in Forever: stuur de chatregel.
- [vervallen, niet getest] Daarna: zak onder 40% mana (of 50% leven), klik buiten een gevecht een vijand aan → de regel verschijnt, zonder
      getal. Met volle mana en leven: niets te zien. — Rob 8 nov: werkt, maar "de ene keer wel, de andere keer
      niet". Gerepareerd: geen 30-s-pauze meer op dit pad, en na een gevecht kijkt MH nog eens naar je doelwit.
      Opnieuw testen: meerdere vijanden achter elkaar met weinig mana. — Rob 8 nov: "zie ik nu elke keer". ✅
- [vervallen, niet getest] Weinig leven (onder 50%): nog niet gezien, Rob kwam zo laag nog niet.
- [vervallen, niet getest] Warrior of rogue: alleen de leven-melding, nooit mana.
- [x] (Rob 8 nov: *"Buff knop werkt"*) Buff-knop: priest zonder Fortitude → het icoontje (zelfde als in Midnight). Klik → cast je HOOGSTE rank. Krijg
      je Fortitude van een andere priest: icoontje weg. `/mh buffs` per buff: geleerd, op je, wat de knop zou casten.
- [vervallen, niet getest] Paladin/mage/shaman: cast zelf een andere blessing/armor/shield; laat hem aflopen → de knop kiest díe.
- [vervallen, niet getest] BugSack na `/reload`: geen "unknown event"-fout van MissingBuff.lua.

## 🆕 8 nov — kleurenkaart MF Nameplates (Midnight én Forever) + pijl tot bij de trainer (Forever)

- [x] (Rob 8 nov, screenshot Forever) `/mh colors`: een venster "What the colours on your nameplates mean". Elke
      regel heeft een vakje in de kleur. — Titel liep onder de knop "Dock to window": gerepareerd, opnieuw kijken.
- [vervallen, niet getest] Kloppen de kleuren met wat je in het spel ziet?
- [x] (Rob 8 nov, Forever) Profiel "Default", geen "An important cast", DPS/healer-blok op de priest.
- [vervallen, niet getest] Midnight: daar staat "An important cast" er wél bij.
- [vervallen, niet getest] Zet MF Nameplates uit op een character, `/reload`: in de gereedschapskamer staat nu de tip-kaart "Nameplate
      colours (MF Nameplates)". Open → uitleg + "TwelveInchy ... gebruikt het zelf" + een vak met de CurseForge-link
      (Ctrl+C kopieert). `/mh colors` staat niet meer in de commandolijst of de zoekbalk.
- [vervallen, niet getest] Aggro: op een tank-character zie je het tank-blok, anders het DPS/healer-blok.
- [vervallen, niet getest] De knop: Midnight → gereedschapskamer (kaart "Nameplate colours"); Forever → startpagina, onder "spelen".
- [vervallen, niet getest] Shift + scrollen maakt het venster groter/kleiner; Escape sluit het.
- [vervallen, niet getest] Forever: `/mh trainer go`, loop naar de trainer. De pijl blijft nu tot ~4,5 m (was ~18 m). Praat je met de
      trainer, dan zijn pijl én kruis weg.

## 🆕 8 nov — kruis boven je trainer (Forever)

- [x] (Rob 8 nov: *"ja het werkt"*) `/mh trainer go` (of de knop in het trainer-venster), loop erheen. Zodra je dichtbij bent, staat er een **kruis**
      boven het hoofd van je trainer — ook met MF Nameplates op "Friendly plates: only target & mouseover".
- [vervallen, niet getest] Geen kruis? Typ `/mh trainer mark` en stuur de regels: daar staat of het NPC-nummer leesbaar is en welke
      naamplaatjes MH zag.
- [vervallen, niet getest] Praat met de trainer (zijn venster gaat open): het kruis verdwijnt.
- [vervallen, niet getest] `/mh trainer mark off`, dan opnieuw `go`: geen kruis. `/mh trainer mark on` zet het terug.

## 🆕 8 nov — toetsenblok zegt welke spel-toetsen het overneemt (Midnight én Forever)

Op een character waar het blok al staat, zie je eerst niets nieuws: die plaatsing is van vóór vandaag.
- [vervallen, niet getest] Toetsenblok-venster → **Undo**. Onder het plaatje staat nu een oranje regel: *"These game keys get a spell from the
      block: C (…Character…), … "Undo" gives them back. A new key for one: Esc > Options > Keybindings."* De naam
      tussen haakjes is die van je eigen spel. Klopt het pad Esc > Options > Keybindings in Forever?
- [vervallen, niet getest] **Place it**: in de chat dezelfde lijst, en in het venster blijft hij staan ("These game keys now press the block").
- [vervallen, niet getest] Je ~ voor het character-venster blijft gewoon werken (dat is geen toets van het blok).
- [vervallen, niet getest] Undo: C opent weer je character-venster.

## 🆕 8 nov — melding "er is een nieuwere MH" (Midnight én Forever)

Jij hebt altijd de nieuwste, dus jij ziet de melding zelf nooit. Testen met je zusje (oudere MH) in één groep.
- [vervallen, niet getest] `/reload`, wacht 15 seconden, `/mh version`: "version notice: on", "this copy: 5.0.1", en "this session: sent 1"
      (of 2 als je ook in een groep zit). Geen guild en geen groep → "sent 0" is goed.
- [vervallen, niet getest] Nodig je zusje uit in een groep. Bij háár (oudere MH) verschijnt in de chat: *"Midnight Helper: version 5.0.1 is out
      (you have …). Update it in the CurseForge app."* Eén keer, niet bij elke nieuwe speler.
- [vervallen, niet getest] Bij jou daarna `/mh version`: "heard 1" of meer, en géén regel "newer than yours".
- [vervallen, niet getest] Logt zij opnieuw in zonder bij te werken: de regel komt nog één keer (binnen 3 dagen).
- [vervallen, niet getest] `/mh version off`: geen meldingen meer en er wordt niets meer verstuurd; `/mh version on` zet het terug.
- [vervallen, niet getest] BugSack blijft leeg, ook bij inloggen en bij een groep vormen.

## 🆕 7 nov (avond) — Forever: waarschuwing voor je laatste gereedschap

Met één Skinning Knife (of Mining Pick) in je tassen. Een nieuwe kost bij een verkoper weinig.
- [vervallen, niet getest] `/reload`, `/mh toolguard`: hij noemt je knife met "warned about", en "vendor tooltip line: hooked".
- [x] ✅ Rob 7 nov (screenshot, Mining Pick bij een verkoper, met Baganator): rode regel "Right-click sells this, and it
      is your last one. You need it as a tool." staat in de tooltip.
- [x] ✅ Rob 7 nov (screenshot, "het werkte"): na verkopen venster "You just sold your last Mining Pick…" met Buy back /
      Close. Het label "Dock to window" viel over de tekst → tekst 16 px lager, venster 112 hoog (7 nov).
- [vervallen, niet getest] Opnieuw verkopen: de tekst staat nu ónder "Dock to window", niets overlapt.
- [x] ✅ Rob 7 nov ("en ja de buyback werkte"): Buy back vanaf onze knop zet de pick terug — BuybackItem mag dus.
- [vervallen, niet getest] Zonder verkoper: géén rode regel.
- [vervallen, niet getest] Sleep de knife uit je tas (vernietigen): onder het venster "Delete?" van de game staat een rood MH-vak
      "Careful: this is your last Skinning Knife… A vendor sells a new one." Klik **Nee** in het venster van de game.
- [vervallen, niet getest] Verkoop de knife (rechtsklik bij de verkoper): venster "You just sold your last Skinning Knife" met knop
      **Buy back**. Klik erop: de knife zit weer in je tassen. Zegt BugSack iets ("blocked")? Stuur het me.
- [vervallen, niet getest] Na dit alles: een drankje of quest-voorwerp uit je tas gebruiken werkt nog gewoon; BugSack blijft leeg.
- [vervallen, niet getest] Twee knives in je tassen: geen rode regels en geen venster.

## 🆕 7 nov (avond) — Forever: Shaman-totems zonder totem-voorwerp

Op de Tauren Shaman, VÓÓR je de quest "Call of Earth" afmaakt.
- [vervallen, niet getest] `/reload`, `/mh trainer`: bovenaan staat "Totems you know but cannot place yet" met Earthbind Totem en een
      oranje regel "needs the Earth Totem, from a class quest at level 4 (starts at Seer Ravenfeather, Camp Narache)".
- [vervallen, niet getest] Na de quest (Earth Totem in je tassen): `/mh trainer` → dat kopje is weg.
- [vervallen, niet getest] Een andere class (bijv. de Warlock): nooit zo'n regel.

## 🆕 7 nov (avond) — Forever: knop "Train all" onder het trainer-venster van de game

Test op een character ZONDER Talents Forever (of typ eerst `/mh trainer button on`), met geld en iets te leren.
- [x] ✅ Rob 7 nov (screenshot, Shaman bij Meela Dawnstrider, `/mh trainer button on`): de knop staat onder de eigen
      Train-knop; niets meer te leren → "Train all", grijs. Met Talents Forever óók aan ligt onze knop over die van hen
      heen (niet eronder); Rob: "maakt niet uit", in stand auto zie je er maar één.
- [vervallen, niet getest] Met iets te leren: de knop zegt "Train all (3, 1g 20s)" (aantal en prijs van wat je nu kunt betalen).
- [vervallen, niet getest] Muis op de knop: per spell de prijs, onderaan het totaal; heb je te weinig geld, dan een rode regel "X more than
      your money covers".
- [x] ✅ Rob 7 nov ("de knop bij de trainer werkt, ik had de andere addon uit gezet"): met Talents Forever uit leerde
      ONZE knop de spells; Forever laat een addon dus kopen bij de class trainer.
- [vervallen, niet getest] Details nog niet gezien: de knop zegt "Training...", de spells worden één voor één geleerd, in de chat staat
      "learned X at the trainer for …". Daarna zegt de knop "Train all" en is hij grijs.
- [vervallen, niet getest] Zegt de chat "the game did not let the addon buy here"? Zeg het mij: dan blokkeert Forever het kopen door addons.
- [vervallen, niet getest] Met Talents Forever aan: alleen hún knop, de onze niet (`/mh trainer button` zegt waarom).
      `/mh trainer button on`: beide knoppen, de onze onder die van hen, niet erover heen.
- [vervallen, niet getest] Profession trainer (bijv. Mining) en Hunter Beast Training: geen MH-knop.
- [vervallen, niet getest] Niets te zien bij een class trainer? Typ `/mh trainer button` met het venster open en stuur me de regels.

## 🆕 7 nov (avond) — Forever: de trainer als draaiend 3D-model

- [x] ✅ Rob 7 nov (screenshot, "mooi, beide werken"). `/reload`, open "New at your trainer" op de Warlock: rechts staat Drusilla La Salle in 3D, ze draait langzaam rond,
      haar naam eronder. Het venster is breder dan eerst; de spelllijst links is niet smaller geworden.
- [vervallen, niet getest] Venster dicht en weer open: het model staat er weer (niet leeg).
- [vervallen, niet getest] Zie je een zwart vak of helemaal niets rechts? Zeg het: dan laadt het model niet in Forever (het vak hoort dan
      na 1,5 s weg te gaan en het venster weer smal te worden).

## 🆕 7 nov (avond) — Forever: tooltips in het trainervenster

- [x] ✅ Rob 7 nov ("beide werken"). `/reload`, open "New at your trainer" (startscherm of `/mh trainer`): muis op een spellregel (bijv. Immolate) →
      de gewone spell-tooltip van het spel verschijnt; muis eraf → weg. Ook bij "Next, at level X".
- [vervallen, niet getest] Het venster ziet er verder hetzelfde uit (regelafstand, lege regels) en scrollen werkt nog, ook met de muis op een spell.
- [vervallen, niet getest] Geld erbij krijgen of uitgeven met het venster open: de geldregel past zich aan, tooltips blijven werken.

## 🆕 7 nov (avond) — Forever: melding "New for your key block" noemt de spell

- [vervallen, niet getest] Forever, een character met het toetsenblok geplaatst: leer een nieuwe spell (trainer of level-up) → de melding toont
      de **spellnaam** (bijv. `Sinister Strike -> 2`), niet `macro -> 2`, met daaronder in grijs *"Placed as a small
      macro, so the key always uses your highest rank."* Op Nederlands: *"Als kleine macro geplaatst…"*.

## 🆕 7 nov (avond) — volgende release: twee bestanden (Retail + Forever)

Geen speltest, wel een blik na de volgende tag. Ik meet het ook zelf (CF-API).
- [vervallen, niet getest] **CurseForge → Files:** twee nieuwe bestanden: `vX.Y.Z` (Retail) en `vX.Y.Z-forever` (alleen Forever 1.60.1).
- [vervallen, niet getest] **CurseForge-app, Forever-tab:** MH biedt de `-forever`-versie aan als update; de Retail-tab de gewone.

## 🆕 7 nov (nacht, laat) — 5.0.0: toetsenblok op spellnummers, Forever in 6 talen

Rob: *"Nee, tag maar"* — dit test hij na de release, niet ervoor. Alleen offline getest.
- [vervallen, niet getest] **Eigen Engelse client (regressie):** `/mh block` → Bijwerken → alle toetsen hebben nog hun spell; een nieuwe rank
      leren → de macro blijft goed.
- [vervallen, niet getest] Iemand met een **Duitse/Franse/Spaanse/Portugese/Russische Forever-client** (Cisca? een CF-speler?): toetsenblok
      gevuld, macro's met namen in die taal, How you play in die taal.
- [vervallen, niet getest] Retail op een Italiaanse client (als iemand dat heeft): de Forever-kaart in het Italiaans.

## 🆕 7 nov (nacht) — 5.0.0: retail-melding, vertaalbare Forever-teksten, Nederlandse How you play

Alleen offline gecontroleerd (syntax + lint). Eerst `/reload` (het "Wat is er nieuw"-venster voor 5.0.0 hoort te openen).
- [vervallen, niet getest] **Retail:** "Wat is er nieuw" toont 5.0.0 met 10 regels, Forever eerst.
- [vervallen, niet getest] **Retail:** bovenaan Home een goudkleurige kaart *"New in 5.0: Midnight Helper now works in WoW Forever too"* met
      knop *"Got it, hide this"* → weg, en komt niet terug (ook niet na `/reload`).
- [vervallen, niet getest] **Retail:** ~8 seconden na het inloggen één chatregel over Forever. Na de volgende `/reload` niet meer.
- [vervallen, niet getest] **Forever, taal Nederlands:** `/mh play` → How you play in het Nederlands, spellnamen Engels, toetsen kloppen.
- [vervallen, niet getest] **Forever, Automatisch:** `/mh play` → weer Engels.
- [vervallen, niet getest] **Forever:** questbeloning-tip in het Nederlands (*"Neem …"*) bij een quest met keuze.
- [vervallen, niet getest] **Forever, nieuw character:** de balken-vraag met **Ja / Nu niet / Nooit meer vragen**; na Ja het venster *"Nu
      herladen?"*.
- [vervallen, niet getest] Vastplakken-knop: wissel van taal, open een venster opnieuw → knop in de nieuwe taal.

## 🆕 7 nov (avond, laat) — Forever: je geld in het trainervenster + schoonheidsfoutjes

Rob: *"Ja, dat klopt"*. Alleen offline gecontroleerd (syntax + lint). Taal op Nederlands:
- [vervallen, niet getest] Trainervenster (`/mh trainer`): bovenaan **Je geld:** met de muntjes. Te weinig voor wat je nu kunt leren → rood
      *"(… te weinig)"*. Koop iets of raap geld op terwijl het venster open is → het bedrag verandert mee.
- [vervallen, niet getest] Het hele trainervenster in het Nederlands: titel *"Nieuw bij je trainer - level N"*, *"Volgende, op level N"*, de
      regel onderaan, de knop *"Breng me naar mijn trainer"*, en ernaast *"…, ongeveer 22 meter (HandyNotes)"*.
- [vervallen, niet getest] Startscherm: *"Volgende op level 4: 2 spells."* (niet meer "(2)"), een regel **Je geld:**, en de titel
      **Midnight Helper Forever** in goud.
- [vervallen, niet getest] Bovenin het venster: *"Ik > Forever"* (niet meer "Deze week").

## 🆕 7 nov (avond) — Forever: eigen startscherm + kaarten in Tools

Rob: *"Ja, graag gedaan"*. Alleen offline gecontroleerd (syntax + lint). Taal op Nederlands (`/mh lang nl`):
- [vervallen, niet getest] `/mh` → Home: titel **Midnight Helper Forever**, eronder *"Level N <class>"* (niet meer de weekreset).
- [vervallen, niet getest] Blok **Je trainer**: *"N nieuw om nu te leren (prijs)"* of *"Nog niets nieuws. Volgende op level X"*. Knop
      **Wat kan ik leren?** opent het trainervenster; regel met de dichtstbijzijnde trainer; knop **Breng me naar mijn
      trainer** zet de pijl.
- [vervallen, niet getest] Blok **Je class spelen**: knoppen **Zo speel je**, **Je toetsenblok**, **Je toetsen** openen elk hun venster.
- [vervallen, niet getest] Daaronder nog het blok "vroege test" met de nieuwe tekst.
- [vervallen, niet getest] Tab **Tools**: bovenaan kaarten **Zo speel je** (`/mh play`) en **Je trainer** (`/mh trainer`); Open werkt.
- [vervallen, niet getest] Bovenin het venster: niet meer twee knoppen "Info" (nu **Over MH** + Info).
- [vervallen, niet getest] Retail (Midnight): Home en Tools zien er hetzelfde uit als vóór vandaag (geen trainer-kaarten).
- ⚠️ In de/fr/es/pt/it/ru staan deze nieuwe teksten nog in het Engels — dat komt in de vertaalronde.

## 🆕 7 nov (avond) — Forever: nieuwe characters krijgen de vraag "Set up the Midnight Helper bar layout?"

Rob: *"Bouw het maar"*. Alleen offline getest.
- [vervallen, niet getest] Maak een nieuw character. Na het intro-filmpje: komt de vraag met **Yes / Not now / Never ask again**? (Niet meer
      de vraag over "Inchy Hunter".)
- [vervallen, niet getest] **Yes** → venstertje **Reload now** → na de reload: blokken, balken aan, menu en tassen rechtsonder, griffioenen
      weg, XP-balk boven blok A, én het toetsenblok-venster staat open voor stap 1.
- [vervallen, niet getest] Ander nieuw character → **Not now**: daar geen vraag meer; op een volgend nieuw character wel.
- [vervallen, niet getest] **Never ask again** → nergens meer een vraag. Daarna in Opties → AddOns → Midnight Helper: de schakelaar *"Offer the
      MH bar layout on new characters"* staat uit; zet hem aan → het volgende nieuwe character krijgt de vraag weer.
- [vervallen, niet getest] Vraag kwam niet: `/mh mylayout check` en stuur de regel *"bar layout question at login: …"*.

## 🆕 7 nov (middag) — Toetsenblok stap 2 zet ook de balken aan (retail + Forever)

Rob: *"ja begin met a"*. Niet offline te testen; alleen in het spel.
- [vervallen, niet getest] Een character dat nog op Modern staat (of een nieuw): `/mh block` → stap 2 (de layout-knop). Komt er in de chat
      een regel *"7 action bars were switched off on this character; MH switched them on."*, en staan na de reload
      balk 4-8 als blok (en 2-3 alleen zichtbaar met je spellboek open)?
- [vervallen, niet getest] "Zet mijn layout terug" in het toetsenblok-venster: staan de balk-knopjes daarna weer zoals ervoor?
- [x] Forever, een character MET achternaam op Modern: stap 2 maakt een layout met de hele naam, bv. *"Ima Shamandwarf
      Shaman"* (Edit Mode → het lijstje bovenaan).
      ✅ Rob 7 nov: *"De naam opslaan is goed gegaan"* — "Ima Priestman Priest" (GEMETEN in de SV).
- [x] 🐛 Forever na stap 2: staan het **menu en de tassen rechtsonder** (niet meer over blok C) en zijn de **twee
      griffioenen weg**? Op "Ima Priestman": eerst *"zet mijn layout terug"*, dan stap 2 opnieuw.
      ✅ Rob 7 nov: *"Ja, dit werkte beter"*.
- [vervallen, niet getest] XP-balk na stap 2 (Forever): recht boven blok A, zoals op je Hunter? Een class met een stance-balk (Warrior, Druid):
      staat die er boven, niet eroverheen?
- [vervallen, niet getest] Geen BugSack-fout bij stap 2.

## 🆕 7 nov (middag) — Forever: je layout naar elk nieuw character (`/mh mylayout`)

Alleen offline getest.
- [vervallen, niet getest] Op je Hunter (layout "Inchy Hunter" actief, `/reload` eerst): `/mh mylayout remember`. Groene regel *"remembered
      "Inchy Hunter""*?
- [vervallen, niet getest] Log in met een ander character dat nog op Modern staat. Komt na een paar seconden de vraag *"Use your layout Inchy
      Hunter here?"*? (Bij een nieuw character: pas na het intro-filmpje.) Klik **Yes**, daarna in het tweede venstertje
      **Reload now**: na de reload staan je balken zoals op de Hunter, en de balken die je aanzette staan ook aan?
      🐛 7 nov eerste poging: "Yes, and reload" gaf een BugSack-fout (Reload geblokkeerd) en de vraag kwam niet vanzelf;
      gerepareerd, opnieuw testen. Geen BugSack-fout meer bij "Reload now"?
- [x] 🔧 Balken aan (7 nov, na `/mh bars`): eerst op de **Hunter** opnieuw `/mh mylayout remember` (de regel zegt nu
      *"bars on: 7 of 7"*). Dan op de **Shaman** `/mh mylayout` → **Yes** (chat: *"Bars switched on: 7 of 7"*) →
      **Reload now**. Staan balk 2 t/m 8 er nu, en geen BugSack-fout?
      ✅ Rob 7 nov (screenshot Shaman): *"Ja, dit keer wel"* — balk 2-8 zichtbaar met de toetslabels. Spells staan nog niet
      op hun plek: dat is het toetsenblok (per character, `/mh block` stap 1-2), niet de layout.
- [vervallen, niet getest] Een character dat al een eigen layout heeft, krijgt de vraag NIET.
- [vervallen, niet getest] **Not on this character**: daarna geen vraag meer op dat character. `/mh mylayout` vraagt het toch opnieuw.
- [vervallen, niet getest] Geen vraag terwijl het zou moeten: `/mh mylayout check` en stuur de regel.

## 🆕 7 nov (middag) — Forever: welke quest-beloning neem je? (`/mh questhint`)

Alleen offline getest. De stats-lijst per class staat erin (7 nov middag).
- [vervallen, niet getest] Klopt de stat die MH voor jouw class noemt? `/mh questhint check` toont de lijst (bv. Hunter: AGILITY, SPIRIT).
- [x] 🐛 Gerepareerd 7 nov (Robs Snow Boots): een beloning met alleen méér armor hoort nu een **groen kader** te krijgen
      met *"+5 Armor over what you wear (more armor, no stat difference)"*. En bij "sells for the most" staat een munt.
      Gaat het mis: `/mh questhint check` direct daarna, er staat nu ook *armor=* per beloning.
      ✅ Rob 7 nov (screenshot, "A New Threat", 3 beloningen): groen kader om Snow Boots, zin precies zo; GearQuest wijst
      dezelfde aan. GEMETEN dus: armor wordt op Forever gelezen, en de knopnaam klopt. Munt bij "sells" nog niet gezien.
- [x] Lever een quest in met 2 of meer beloningen om uit te kiezen. Krijgt één beloning een **groen kader**, en staat
      er onder het questvenster een zin als *"Take …: +3 Agility … over what you wear"*?
      ✅ Rob 7 nov: groen kader + zin onder het venster (armor-geval, zie hieronder). Een stats-geval nog niet gezien.
- [vervallen, niet getest] Is geen enkele beter: een **geel kader** op wat het meest oplevert, met die uitleg.
- [vervallen, niet getest] MH klikt nooit zelf een beloning aan: kies je zelf iets anders, dan gebeurt er niets geks.
- [vervallen, niet getest] Na inleveren verdwijnen kader en zin.
- [vervallen, niet getest] `/mh questhint check` direct na zo'n quest: één regel per beloning. Stuur die mee als de keuze vreemd is.
- [vervallen, niet getest] `/mh questhint off` zet het uit, `/mh questhint on` weer aan.

## 🆕 7 nov (middag) — Dock-knop, Serpent's Bite

- [x] Open een MH-venster met **Dock to window** rechtsboven (bv. `/mh play` in Forever): staat de knop nu los van het
      kruisje? Klik hem: wordt hij *Undock*, en past die tekst ook?
      ✅ Rob 7 nov (screenshot trainer-venster): knop los van het kruisje. *Undock* nog niet gezien.
- [vervallen, niet getest] Midnight, raidtips Ula'tek fase 3: Serpent's Bite zegt nu *"two players"* (nl: *"twee spelers"*). Klopt dat met
      het aantal cirkels dat je in de raid ziet?

## 🆕 7 nov — Forever: pijl naar je trainer (`/mh trainer go`)

Rob: *"alle drie"*. Alleen offline getest, met jouw echte HandyNotes_ClassTrainers-lijst.
- [x] `/mh trainer`: onderaan het venster de knop **Take me to my trainer**, met ernaast welke trainer en hoe ver.
      Klik: komt de pijl, en wijst hij naar je class-trainer?
      ✅ Rob 7 nov (Dwarf Hunter, level 2, screenshot): *"en de pijl komt :)"*; knop toont "Thorgas Grimson, about 237 yards
      (HandyNotes)".
- [vervallen, niet getest] Zet in HandyNotes (`/classtrainers`) **Only my class** UIT: MH moet tóch alleen jouw class kiezen.
- [vervallen, niet getest] Sta naast een trainer, klik hem aan (target) en typ `/mh trainer here`. Groene regel met zijn naam?
      Daarna `/mh trainer go` elders in die stad: kiest hij jouw plek als die dichterbij is? `/mh trainer forget` haalt
      hem weer weg.
- [vervallen, niet getest] `/mh trainer check`: de regel *"trainer places: yours …, HandyNotes …"* en *"nearest: …"*. Stuur hem mee bij twijfel.
- [vervallen, niet getest] Ander continent dan je trainers (bv. een Night Elf in Stormwind): netjes *"none on this continent"*, geen fout.
- [x] Nieuw (7 nov, later): MH's eigen lijst (218 trainers). Zet HandyNotes_ClassTrainers één keer UIT in de addonlijst,
      `/reload`, en klik **Take me to my trainer**: komt er nog steeds een pijl? Achter de naam staat dan *"MH list"*.
      ✅ Rob 7 nov (screenshot): met HandyNotes uit wijst de pijl naar *"Thorgas Grimson (trainer) 141 yd"*.
- [x] Meters: zet in de MH-instellingen **Route-afstand in meters** aan (Esc → Opties → AddOns → Midnight Helper, bij de
      route-pijl). Zegt de pijl nu *"m"*, en de regel naast de trainer-knop *"… meters"*?
      ✅ Rob 7 nov (screenshot): *"Thorgas Grimson, about 236 meters (HandyNotes)"*; Track Beasts zegt *"not on the block
      (on purpose)"*. Het venster ging ook open op level 3 (Track Beasts nog niet geleerd).

## 🆕 7 nov — De route-pijl laat jouw eigen kaartspeld staan (retail én Forever)

Rob: *"Ja, repareer"*. Alleen offline getest. Vroeger haalde MH aan het einde van een route ook een speld weg die jij
intussen zelf had gezet.
- [vervallen, niet getest] Start een MH-route (bv. een rare of `/mh goto`). Zet daarna zelf een speld op de kaart, ergens anders (Ctrl-klik
      op de wereldkaart). Laat de route eindigen (aankomen of stoppen). Staat jouw eigen speld er nog?
- [vervallen, niet getest] Een gewone MH-route zonder eigen speld: verdwijnt de speld van MH aan het einde nog steeds, zoals altijd?
- [vervallen, niet getest] `/mh arrow` heeft een nieuwe regel *"einde vorige route, de speld: …"*. Noem wat er staat als iets niet klopt.

## 🆕 7 nov — Forever: nieuw bij de trainer (`/mh trainer`)

Rob: *"Ja, A + pijl"*. Dit is stap A; de pijl naar de trainer komt later. Alleen offline getest (7 classes nagebootst).
- [vervallen, niet getest] In Forever: `/mh trainer`. Er opent een venster *"New at your trainer - level X"*. Staan daar de spells die je bij
      de trainer kunt leren, met hun prijs en de toets erachter (bijvoorbeeld *Lay on Hands -> Q*)?
- [x] Klopt het met wat de trainer zelf laat zien? Mist er iets, of staat er iets dat de trainer niet heeft: noem het.
      ✅ Rob 7 nov (screenshot trainer Thorgas Grimson, Dwarf Hunter level 3): Track Beasts 10c nu; Aspect of the Monkey
      en Serpent Sting R1 1s op 4; Arcane Shot en Hunter's Mark R1 1s op 6 — gelijk aan MH's venster (level, prijs).
      De knop "Train all" daar is van TalentsForeverBook, niet van MH (GEMETEN met grep).
- [x] Ga een level omhoog (een even level, bv. 10 of 12): komt er een regel in de chat, en gaat het venster vanzelf open?
      In combat hoort het pas open te gaan als het gevecht voorbij is.
      ✅ Rob 7 nov: venster opende vanzelf bij level 2 (Track Beasts 10c, "you have 0" in rood; volgende: level 4,
      Aspect of the Monkey → block D, Serpent Sting → 2). De combat-regel is niet apart gezien.
- [vervallen, niet getest] Een oneven level: alleen een chatregel *"nothing new … Next: level X"*.
- [vervallen, niet getest] Nieuw (Rob: *"Ja, alleen nieuw"*): heb je iets nog niet geleerd, dan gaat het venster op het volgende level NIET
      opnieuw open; je krijgt *"nothing new, still N to learn"* in de chat. Op een level met iets nieuws gaat het wel open.
- [vervallen, niet getest] `/mh trainer auto off`: het venster gaat niet meer vanzelf open (de chatregel blijft). `/mh trainer auto on` zet het terug.
- [vervallen, niet getest] `/mh trainer check`: een paar regels met tellingen. Stuur die mee als iets niet klopt.
- [vervallen, niet getest] Spells die al in je spellboek staan, horen er NIET in te staan. Zie je er toch een: noem hem.

## 🆕 6 nov (nacht, later) — Forever: How you play voor alle 9 classes

Rob: *"Ja, schrijf ze"*. Alleen offline getest. Op een Warrior, Rogue, Priest, Shaman of Warlock: `/mh play`.
- [vervallen, niet getest] Je ziet de uitleg van jouw class (niet meer *"Not written yet"*).
- [vervallen, niet getest] Klopt wat er bij level 1-10 staat met de toetsen op je blok?
- [vervallen, niet getest] Tekst die je niet snapt of die niet klopt met wat je ziet: noem de zin.
- [vervallen, niet getest] Mage: bij de wand staat nu *"once you have one"*.

## 🆕 6 nov (nacht) — Forever: How you play alleen je eigen class; de familieknop

Rob: *"ja"*. Alleen offline getest. Herstart WoW (er laadt een extra bestand).
- [vervallen, niet getest] `/mh play`: alleen **How you play Paladin**, zonder knoppen bovenin.
- [vervallen, niet getest] Je familie overzetten (Midnight en Forever hebben elk hun eigen opslag), één keer typen:
      `/mh mark me star`, `/mh mark friend carola#2875 circle`, `/mh mark friend sizzle#21918 diamond`.
      Elke regel geeft een groene bevestiging in de chat. `/mh mark friends` laat zien wat MH ziet.
- [vervallen, niet getest] In een groep met Carola en/of Cisca: `/mh mark` (balk aan), dan de **vriendenknop** (het groene poppetje). Krijgt
      iedereen zijn eigen icoon? Werkt dat niet, meld dan wat `/mh mark friends` zegt.

## 🆕 6 nov (late avond) — Forever: How you play in de addon

Rob: *"doe b en dan a"*. Alleen offline getest. `/reload` in Forever.
- [x] ✅ GEMETEN Rob 6 nov (screenshot): venster **How you play Paladin** open, 4 knoppen bovenin (Paladin grijs = actief),
      toetsen en termen in goud, kopjes, scrollbalk rechts, *Dock to window* aanwezig.
- [x] ✅ Rob 6 nov: scrollen met het muiswiel en sluiten met Esc werken (*"ja beide werken"*).
- [vervallen, niet getest] `/mh play` opent en sluit hetzelfde venster.
- [vervallen, niet getest] Klopt wat er bij jouw Paladin staat met wat je ziet? (3 = seal, C = Holy Light, Ctrl-1 = Devotion Aura.)
- [vervallen, niet getest] Midnight: stap 4 en `/mh play` openen nog de gewone How you play-kaart.

## 🆕 6 nov (avond) — Forever: de Quick bar (`/mh bar`)

Rob: *"ja doe maar"*. `/reload` in Forever, dan `/mh bar`.
- [x] ✅ Rob 6 nov: *"De MHBar die werkt, die heb ik al gekeken."* (Losse punten hieronder niet apart gemeld.)
- [vervallen, niet getest] Er verschijnt een klein balkje met **4 knoppen**: MH, Reload, Leave group en Your key block.
- [vervallen, niet getest] Klik op MH: het venster gaat open. Rechtsklik: de instellingen.
- [vervallen, niet getest] Klik op Your key block: het blokvenster gaat open.
- [vervallen, niet getest] Reload herlaadt (niet in een gevecht).
- [vervallen, niet getest] Het balkje is te verslepen en staat na `/reload` nog op dezelfde plek. `/mh bar` nog eens = weg.
- [vervallen, niet getest] Midnight: `/mh bar` heeft nog alle knoppen zoals altijd.

## 🆕 6 nov (eind middag) — Forever: wand voor de Mage, pet-toetsen voor Hunter en Warlock

Rob: *"Doe maar"* op de twee keuzes uit de How to play. Alleen offline getest. Werkwijze: `/reload`, `/mh block` →
*Preview* → *Place it*.
- [vervallen, niet getest] **Mage, level 1:** **Ctrl-3** = Shoot (je wand). Twee keer drukken: de wand blijft schieten.
- [vervallen, niet getest] **Hunter, vanaf level 10 (Call Pet):** **Ctrl-1** = pet valt aan, **Ctrl-2** = pet volgt, **Ctrl-3** = pet blijft
      staan. **Shift-R** = Aspect of the Hawk. Monkey, Beast en Strider Kick staan bij *"zet op je eigen balk"* (blok D).
- [vervallen, niet getest] **Warlock, level 1 (met je Imp):** Ctrl-1/2/3 doen hetzelfde voor je demon.
- [vervallen, niet getest] Wat zie je op die drie macro-knoppen: een eigen plaatje of een vraagteken? (Vraagteken = het plaatje bestaat
      niet in Forever; de knop werkt dan nog wel.)
- [vervallen, niet getest] Extra, als je wilt: Esc → Key Bindings → *Pet Action Bar*. Welke toetsen staan daar? (Dan weten we wat Blizzard
      in Forever zelf doet.)

## 🆕 6 nov (middag) — Forever: de andere 5 classes, de Tools-lijst; Midnight: Epu en Nema

Zelfde werkwijze als hieronder: `/reload`, niet in gevecht, `/mh block` → *Preview* → *Place it*. Alleen de classes die je
wilt proberen; op level 1 staan er maar een paar toetsen, dat is normaal. De beginspells komen uit Blizzards data
(GEMETEN); dat MH ze op die toetsen zet is alleen offline getest.
- [vervallen, niet getest] **Warrior, level 1:** **1** Heroic Strike, **Ctrl-1** Battle Stance, **Shift-E** je racial. Na de trainer: **Shift-X**
      Battle Shout. Extra (als je wilt): `/run print(GetBonusBarOffset(), GetShapeshiftForm())` in Battle Stance geeft `1 1`.
- [vervallen, niet getest] **Rogue, level 1:** **1** Sinister Strike, **4** Eviscerate. Later in Stealth (level 1 al, **Shift-R**): **1** wordt
      Garrote pas vanaf level 14; daarvoor blijft 1 Sinister Strike.
- [vervallen, niet getest] **Priest, level 1:** **1** Smite, **C** Lesser Heal, **5** Shoot (staf/wand).
- [vervallen, niet getest] **Shaman, level 1:** **1** Lightning Bolt, **C** Healing Wave.
- [vervallen, niet getest] **Warlock, level 1:** **1** Shadow Bolt, **Shift-Z** Demon Skin; na de trainer **3** Immolate. Summon Imp komt op
      blok D (je eigen balk), niet op het blok.
- [vervallen, niet getest] Geen rode regel *"Not in Midnight Helper's list yet"*. Staat hij er wel, noem dan de spell.
- [vervallen, niet getest] **Forever, Tools:** `/mh` → Tools. Je ziet nu alleen knoppen die in Forever werken: *Your keys*, *Key block*, *FPS*.
      Geen Delve Coach, Valeera, Mount run en zo meer. (De lijst met commando's daaronder noemt nog wel alles: bekend.)
- [vervallen, niet getest] **Midnight, The Venomous Abyss** (raid-tips, baas *Lost Explorers*): de tekst noemt **Epu** en **Nema**, niet meer
      Iku en Nama. Klopt de naam in het spel? Blizzard noemde ze in de hotfix niet letterlijk.
- [vervallen, niet getest] **Midnight, Tools:** alle knoppen staan er nog (niets weg in Midnight).

## 🆕 6 nov — Forever: Paladin, Mage en Hunter (nieuw character, level 1)

Eerst `/reload` in Forever. Niet in een gevecht. Dan `/mh block` (of *Set up my keys*), eerst *Preview*, dan *Place it*.
Op level 1 is het blok bijna leeg; dat is normaal. Elke nieuwe spell komt er vanzelf bij.
- [x] ✅ **GEMETEN Rob 6 nov (2 screenshots, Human Paladin level 1):** stap 1 + stap 2 (eigen layout) → blok D-A-B-C
      naast elkaar, **3** MH 3 Seal of Righteousness, **C** MH C Holy Light, **Shift-E** Will to Survive, Perception op
      Alt-1; *"ze werken allemaal"*. Geen rode regel. Holy Light blijft op C (grote heal), F2 = Flash of Light later:
      Rob *"we houden het op a"*. ✅ Devotion Aura na de trainer op **Ctrl-1**: Rob 6 nov *"ctrl 1, die devotion aura
      werkt en werd goed geplaatst"* (de "nieuw voor je blok"-vraag werkt dus ook in Forever).
      ⚠️ Volgorde voor de volgende class: `/mh block` → stap 1 *Do it* → stap 2 *Do it* (eigen layout, andere
      characters blijven zoals ze zijn) → reload → toetsen proberen.
- [x] ✅ **Mage, level 1:** **1** Fireball, **Shift-Z** Frost Armor. Rob 6 nov: *"op de mage lijkt ook alles te werken"*.
- [vervallen, niet getest] **Hunter, level 1:** **1** Auto Shot, **5** Raptor Strike, **Shift-E** je racial.
- [vervallen, niet getest] 🔑 **Hunter-test:** druk twee keer op **1** bij een doel. Hij blijft schieten (de macro is `/cast !Auto Shot`). Stopt
      hij bij de tweede keer, dan meld je het.
- [vervallen, niet getest] Geen rode regel *"Not in Midnight Helper's list yet"* bij een nieuwe spell. Staat hij er wel, noem dan de spell.
- [vervallen, niet getest] Je Druid werkt nog precies als gisteren.

## 🆕 5 nov (nacht) — Forever: het Druid-blok met macro's

Eerst `/reload` in Forever, met je Night Elf Druid. Niet in een gevecht.
- [vervallen, niet getest] `/mh block` (of `/mh mykeys` → *Set up my keys*): de afbeelding toont op **1** Wrath, **2** Moonfire, **C** Healing
      Touch, **F4** Rejuvenation, **Shift-Z** Thorns, **Shift-X** Mark of the Wild, **Shift-E** Shadowmeld.
- [vervallen, niet getest] Eerst de proefrun (`/mh block place` zonder go, of de knop *Preview*): de chat zegt per toets "place MH 1" enz.
- [x] **GEMETEN 5 nov (Robs screenshot, "whoohoo het werkt"):** geplaatst met EllesmereUI Action Bars UIT + stap 1 en 2.
      Balk 5: MH 1 Wrath, MH 2 Moonfire, MH C Healing Touch, MH V Entangling Roots; balk 6: MH F4 Rejuvenation;
      balk 7: Shadowmeld, Thorns, Mark of the Wild; balk 4 (D): Elune's Light. Vorm D-A-B-C naast elkaar, 1-4 boven.
- [x] Na `/reload`: de rode regel *"Not in Midnight Helper's list yet …"* is weg (GEMETEN, Robs screenshot 5 nov). Het
      venster zegt nu alleen "No place on blocks A, B and C (1): Elune's Light" en "Nothing new to add".
- [vervallen, niet getest] Dan echt plaatsen (*Place it* / `/mh block go`). Daarna staan er macro's **"MH 1", "MH 2", …** in je macrolijst
      (Esc → Macros → tab van je character), en op balk 5/6/7 knoppen met het icoon van de spell.
- [vervallen, niet getest] Werken de toetsen? 1 = Wrath (Rank 2), 2 = Moonfire, C = Healing Touch. ⚠️ Met EllesmereUI: zie je de knoppen op
      jouw balken 5-7, en reageren ze op de toetsen? (Niet zeker of EllesmereUI MH's toetskoppeling overneemt.)
- [vervallen, niet getest] Wrath en Moonfire zijn van **balk 1** gehaald (anders had je ze dubbel).
- [vervallen, niet getest] Level 8: je leert Healing Touch Rank 2 en Entangling Roots. Na het leren (buiten gevecht) toont de tooltip van C
      Rank 2, en MH vraagt of Entangling Roots op **V** mag.
- [vervallen, niet getest] Level 10 (beer): in Bear Form doet **1** Maul. Dat is de echte test of de macro je vorm herkent.
- [vervallen, niet getest] `/mh block undo` zet alles terug (de macro's blijven in je lijst staan; die mag je zelf weggooien).

## 🆕 5 nov (avond) — Midnight Helper Forever, stap 1 (laadt de motor?)

Eerst moet MH in je Forever-map staan (koppeling of kopie, zie de chat).
- [vervallen, niet getest] **Retail eerst:** `/reload` in gewoon WoW. MH laadt zoals altijd, geen nieuwe fout in BugSack. (Het nieuwe
      Forever-bestand mag retail niet raken.)
- [vervallen, niet getest] **Forever:** in de addon-lijst bij het karakterscherm staat **Midnight Helper Forever**. Zet hem aan, log in.
- [vervallen, niet getest] BugSack leeg na inloggen en na `/reload`? Zo niet: stuur de eerste fout, met regelnummer.
- [x] `/mh` opent het venster (Rob, screenshot 5 nov: ja — maar met alle Midnight-tegels en `TAB_START_HERE`).
- [vervallen, niet getest] Na de fix van 5 nov (WoW helemaal opnieuw starten of `/reload`): links alleen **Me**, **Tools** en **Settings**
      (geen Codex). Onder Me alleen *This Week*; geen `TAB_START_HERE`, geen Delves & Vault/Rares/Void-tegels, en
      bovenin geen Delves & Vault-snelknop. Onder Tools: *Your keys* en de tools-lijst. Wat staat er op This Week?
- [vervallen, niet getest] **Retail-controle:** in gewoon WoW zijn alle kamers en tegels er nog, zoals altijd.
- [vervallen, niet getest] Forever, na `/reload`: **This Week** toont alleen het blok *"Midnight Helper Forever (early test)"* met een korte
      uitleg en de knop **Your keys** (opent het toetsenvenster). Geen Great Vault, World Boss, Ritual Sites enz.
- [vervallen, niet getest] Forever, **Settings**: onder *Quick actions* alleen *Report a problem* en *What's new*; onder *Advanced* alleen
      *Reset popup position* en *Side panels back in place*. Geen gaten tussen de knoppen.
- [vervallen, niet getest] Gewoon WoW: This Week en Settings zien er uit zoals altijd (alle knoppen er nog).
- [vervallen, niet getest] **Meting voor het Druid-blok:** in Forever, met je Night Elf Druid: `/mh spellbook`, dan `/reload`. In de chat
      staat *"Saved: … spells …"*. Zeg het mij; ik lees het bestand zelf.
- [vervallen, niet getest] `/mh mykeys` opent het toetsenvenster. **Nog niet** op "zet neer" drukken: de lijsten zijn nog van Midnight.
- [vervallen, niet getest] Log uit en weer in: zijn MH-instellingen (bv. de venstergrootte) bewaard? (In de beta ging dat mis.)

## 🆕 5 nov (middag) — "Wat past in 20 minuten?" en het bewaren per run

Eerst `/reload`.
- [vervallen, niet getest] Tab **Home**, blok *Your week*: onder de TomTom-knop staat een nieuwe knop **"I have a few minutes: what fits?"**.
      Klik erop. Er opent een venster *"What fits in 20 minutes?"* met drie knoppen **10 min / 20 min / 40 min**.
      De knop van je keuze licht op. Werkt Shift+scroll (groter/kleiner) en slepen?
- [vervallen, niet getest] In dat venster, kopje *Delves and rituals, with your own times*: staan daar delves die je op dit character
      gedaan hebt, met "about N min (your average of N runs)"? Klopt de tijd ongeveer met wat jij gewend bent?
      De Labyrinth hoort er NIET bij. Klik **10 min**: de lijst wordt korter, of hij noemt je snelste.
- [vervallen, niet getest] Kopje *Quick stops this week*: dezelfde open stappen als in *Your week* (vault, wekelijkse quests). Klik er één:
      zet hij een route, net als op de Home-tab?
- [vervallen, niet getest] Op een alt zonder delves: staat er *"No times yet on this character…"*?
- [vervallen, niet getest] `/mh time 40` opent hem meteen op 40. Typ "20 min" in de zoekbalk van MH: vindt hij het?
- [vervallen, niet getest] Doe één gewone delve (niet de Labyrinth) en daarna `/mh season stats`. Onderaan staan drie nieuwe regels:
      *Delves finished*, *Labyrinth runs*, *Rituals finished*, elk met *"(since 05/11/2026)"* erachter. Delves finished = 1?
- [vervallen, niet getest] Na die delve, in de SavedVariables (stuur mij het bestand): heeft de nieuwste run een `story` (het verhaal) en een
      `role` (dps/heal/tank van Valeera)? Dat kan ik zelf nakijken, jij hoeft alleen het bestand te sturen.

## 🆕 5 nov — zoekbalk-tekst en de kwartiermeester-knoppen

Eerst `/reload`.
- [vervallen, niet getest] De lege zoekbalk van MH zegt nu *"Find a tab, setting, tool, boss, mount, rare or treasure…"*. Staat de hele zin
      erin, of valt het eind weg (…)? Probeer ook een smal MH-venster.
- [vervallen, niet getest] Tab **Currency**, onderaan *Renown Quartermaster waypoint:*. De knoppen heten nu **Silvermoon Court**, **Amani
      Tribe**, **Hara'ti**, **The Singularity** en **Zul'jarra's Forces**. Passen ze netjes (eventueel op twee regels),
      zonder over de tekst erboven te vallen? Muis op een knop → de naam en de NPC. Klik → de pijl gaat erheen.
- [vervallen, niet getest] Zoekbalk: **catalyst**, **crest exchange**, **training dummy** en **portal room** → de pin in Silvermoon.
      **alchemy trainer** werkt nog zoals vroeger.
- [vervallen, niet getest] (Niet bij jou te zien: op een Duitse client vindt *Auktionshaus* nu het Auction House.)

## 🆕 4 nov — TomTom 4.4.0: één pijl weghalen stopt de route

Met TomTom aan. Na `/reload`.
- [vervallen, niet getest] Typ **ah** in de zoekbalk en klik op Auction House. Rechtsklik op de TomTom-pijl → **Remove waypoint**. Je hoort
      in de chat te zien: *"Route stopped: you removed the TomTom arrow."* Na een zonewissel komt de pijl niet terug.
- [vervallen, niet getest] Doe een route met meerdere stappen (een rare-route, of een reis naar een andere zone). Bij aankomst op een tussenstap
      gaat de route gewoon door. Je ziet dan **geen** "Route stopped".
- [vervallen, niet getest] Tijdens een MH-route: `/tomtom` → Waypoint Arrow. Bij "set closest" staat *Controlled by MidnightHelper*. Na de
      route niet meer.
- [vervallen, niet getest] `/mh arrow` laat zien: "TomTom-meldingen: ja", een regel "laatste: …" en "'set closest' tegengehouden".
- [vervallen, niet getest] "Clear all" via de TomTom-pijl werkt nog zoals vroeger (route stopt, maar je ziet géén tweede chatregel).

## 🆕 3 nov (7) — zoeken vindt nu de pins van de Silvermoon-stadsgids

✅ **Rob 3 nov: "Ik heb alles getest, de lijst en alles werkt zoals het moet doen."** — alles hieronder.

Eerst `/reload`. Typ in de zoekbalk van MH:
- [x] **ah** → *Auction House* (en *Horde Auction House*), met grijs *"Silvermoon City — …"* erachter. Klik → de pijl gaat
      naar de veilingmeesters, net als een klik op de pin.
- [x] **bank**, **mail**, **inn**, **catalyst**, **transmog**, **alchemy** → de pin van die plek.
- [x] **arrow** → bovenaan nog steeds de pijl-instellingen, niet een lange lijst stadspins.
- [x] **Top 4 (Rob: "Ja, top 4"):**
      - **frost** → *Frost Mage* en *Frost Death Knight* (grijs: *How you play*). Klik → de speelkaart van die spec.
        Ook **retribution**, **how to play** of **rotation** werken.
      - **trading post** → de tab Trading Post.
      - **world boss** → de vier world bosses (bv. *Lu'ashal*, grijs de zone). Klik → de pijl gaat erheen.
      - **showdown** of **naigtal** → *Showdowns* (World-tab), de portaal-route en de start bij Riftblade Maella.
- [x] **De rest van de lijst (Rob: "Ja, dat klopt"):**
      - **overview** of **knowledge points** → *Overview* van de beroepen-hub; **treasures** → *Treasures & Books*.
      - **curio** → het curios-venster én elke curio bij naam (bv. *Porcelain Blade Tip*). Klik → het curios-venster.
      - **mount run** of **old raids** → het venster *Mount run: old raids*.
      - Een schat of glyph **zonder** plek op de kaart is nu ook te vinden; klik → de Achievements-tab (geen pijl).

## 🆕 3 nov (6) — key block: waarom zette hij niets neer?

Eerst `/reload`. Op een character mét key block (je Evoker):
- [x] `/mh block why` → onderaan een regel **"new spells: …"** met de stand van de knop (ask me / place automatically /
      never ask) en wat er klaarstaat, bv. *"Return -> F"*. Staat de knop op never ask, dan zegt de regel waar de knop zit.
- [x] ✅ Rob 3 nov (screenshot): *"new spells: place automatically — waiting: none"* (Return staat er dus op). De regel
      met de stand + wachtlijst werkt.
- [x] Zet de knop op **place automatically**, druk Update, en `/mh block why` opnieuw → *"waiting: none"*.
- [x] ✅ Rob 3 nov ("het staat allemaal goed") — **Nieuw in All settings:** MH → All settings, zoek **"key block"** of **"new spells"** → *"Key block: new spells"* (onder
      On-screen buttons), een keuzelijst met ask me / place automatically / never ask. Kies er een, open het key block-venster:
      de knop rechtsboven zegt hetzelfde. En andersom.

## 🆕 3 nov (5) — de drie site-chat-punten

Eerst `/reload`.
- [x] **Raid-boodschappenlijst** (`/mh ready`, of de knop onder het Auction House-venster): muis op een gear-regel (enchant). Alleen bij een regel met
      *"(a choice)"* achter de naam zegt de tooltip *"For this slot there is a choice …"*. Bij de andere regels alleen de naam.
      ✅ Rob 3 nov (screenshot): **Head (a choice)** toont de zin. ❌ **Legs (a choice)** (Spellthread, een echt item) toonde
      alleen de spel-tooltip → gerepareerd: de zin staat nu onderaan die tooltip. ✅ Rob 3 nov (screenshot): Legs mét zin, Chest zonder.
- [vervallen, niet getest] **Silvermoon City-gids:** klik de pin **Auction House** → de pijl wijst nu naar binnen, bij de veilingmeesters
      (51.35 / 75.81), niet meer naar ~1,3 ervoor. Klopt de plek? Anders `/mh here` bij de veilingmeester.
- [vervallen, niet getest] (Alleen te zien op een de/fr/es/pt/it-client, dus niet bij jou: daar staat nu de stadsnaam in plaats van "SMC".)

## 🆕 3 nov (4) — doorklikken, voetregel en "Back to recommended"

Eerst `/reload`. Open MH → All settings.
- [x] ✅ Rob 3 nov — **Notice after a delve** → vergrootglas, **vier keer** klikken: de melding laat telkens iets anders zien — nieuw record
      (groen), langzamer (rood), eerste keer op deze Tier, even snel. Tooltip van het vergrootglas: blauwe regel *"Click
      again to see another situation."*
- [x] ✅ Rob 3 nov — **Rare nearby alerts** → vergrootglas, **twee keer**: eerst de gewone rare-melding, daarna die van Szarith met de
      regel over de elite-wachters.
- [x] ✅ Rob 3 nov — Onderaan de pagina, onder de lijst, een grijze regel: *"Magnifier: show what it does · Ctrl+click: back to
      recommended · Changes work at once."* Valt niet over de lijst heen.
- [x] ✅ Rob 3 nov — Naast de kopjes (bv. *Combat warnings*) een klikbare tekst **"Back to recommended"**. Niet bij *Language* (daar is
      geen aanbevolen stand). Klik → een vraag met het aantal instellingen. **Yes** → het blok staat op aanbevolen; **No**
      → er verandert niets. Er springen daarbij géén vijf meldingen tegelijk op.

## 🆕 3 nov (3) — "Show me": het echte ding laten zien vanuit de instellingen

Eerst `/reload`. Open MH → All settings.
- [x] ✅ Rob 3 nov ("staat er allemaal goed op") — Op 17 regels staat rechts een klein **goud vergrootglas** (bij een vinkje helemaal rechts, bij een schuif of keuze
      net links ervan). Muis erop: tooltip *"Show me"*. Op andere regels staat niets.
- [x] ✅ Rob 3 nov — **Route arrow size (no-TomTom mode)** → vergrootglas: de route-pijl verschijnt 3 seconden.
- [x] ✅ Rob 3 nov — **Show dangerous cast warning** → vergrootglas: het waarschuwingsicoon verschijnt (sleepbaar). Nog een
      keer klikken → weg.
- [vervallen, niet getest] **Rare nearby alerts (sound + popup)** → vergrootglas: de rare-melding met geluid.
- [x] ✅ Rob 3 nov — **Notice after a delve** → vergrootglas: de melding midden in beeld ("Test Delve · Tier 5", record).
- [vervallen, niet getest] **Battle res & Hero panel** → vergrootglas: het paneel verschijnt even.
- [x] ✅ Rob 3 nov (Accessible danger alert) — **Vanzelf (stap 2):** zet **Accessible danger alert** uit en weer **aan** → de
      grote melding verschijnt meteen. Uitzetten laat niets zien.
- [vervallen, niet getest] Nog open: hetzelfde vanzelf-tonen bij *Notice after a delve*, *Show the shard cap popup*, *Rare nearby alerts* en het
      *Battle res & Hero panel*.
- [vervallen, niet getest] Niets van dit alles wordt bewaard: geen nieuw record in je Delve Log, geen route gezet.
- [vervallen, niet getest] Een paar tests zetten een regel in de chat (bv. *"raretest fired for …"*). Stoort dat? Zeg het, dan haal ik het weg.

## 🆕 3 nov (2) — zoekbalk stap 4-6: andere woorden, oude woorden weg, Ctrl+klik en grijs

Eerst `/reload`.
- [x] ✅ Rob 3 nov (*audio*) — Zoekbalk: typ **audio** of **noise** → de geluid-instellingen (bv. *Rare sound*) komen in
      de lijst, ook al staat dat woord er niet in.
- [vervallen, niet getest] Nog open: **alert** → waarschuwings-instellingen; **hotkey** → de keybind-dingen.
- [x] ✅ Rob 3 nov — Typ **rare**: de **Rares-tab** staat nog steeds bovenaan (niet *Rare sound*).
- [x] ✅ Rob 3 nov (*valeera*) — Enter-zoeken zonder lijst-treffer: typ **valeera** + Enter → Delves-tab.
- [vervallen, niet getest] Nog open: **aztarec** + Enter → Delves-tab; **coiled** + Enter → Rares-tab; *brann* en *zekvir* doen niets meer.
- [x] ✅ Rob 3 nov (beide) — **sporefall** (of **rotmire**) + Enter → het **baas-venster van Rotmire** gaat open, niet meer de Delves-tab.
- [x] ✅ Rob 3 nov — All settings, blok *Combat warnings*: zet **Show dangerous cast warning** **uit**. Drie regels in dat
      blok (spreken, balken, alleen belangrijke casts) staan een stukje **ingesprongen** en worden **grijs**. Muis erop:
      oranje regel *"Does nothing right now: …"*.
- [vervallen, niet getest] Nog open: Great Vault: **Enable vault reminders** uit → de 4 regels eronder grijs.
- [x] ✅ Rob 3 nov — Muis op een instelling met een aanbevolen stand: onderaan de tooltip een blauwe regel *"Ctrl+click:
      back to the recommended setting (…)."* Verander iets, dan **Ctrl+klik** → terug naar die stand.
- [vervallen, niet getest] Een instelling **zonder** aanbevolen stand (bv. *Death card: how long it stays*): geen Ctrl+klik-regel, en Ctrl+klik doet gewoon
      wat een klik doet.
- [vervallen, niet getest] In het Nederlands (MH op Nederlands): typ **alarm** → *geluid*-instellingen. Weet: *taal* vindt ook *Totaal…*
      (een stukje van een woord telt mee, stap 2), maar lager in de lijst.

## 🆕 3 nov — zoekbalk: instellingen vinden, tikfouten, pijltjes

Eerst `/reload`. Open MH en klik in de zoekbalk bovenaan.
- [x] Typ **arrow size** (of in je eigen taal een woord uit een instelling): de lijst toont die instelling, met erachter
      grijs *"All settings > …"* (de sectie waar hij staat). ✅ Rob 3 nov
- [x] Klik erop: de pagina **All settings** gaat open, **scrolt naar die regel**, en de regel **knippert**. ✅ Rob 3 nov
      (3 keer, "mag 2 keer zo lang").
- [vervallen, niet getest] Het knipperen duurt nu **twee keer zo lang**: zes keer, ongeveer 6 seconden. Goed zo, of te lang?
- [x] ✅ Rob 3 nov — Typ de woorden **andersom** (*size arrow*): zelfde resultaat.
- [x] Typ met een **tikfout** (*arow*, *setings*): je vindt het toch. ✅ Rob 3 nov (*arow*)
- [x] ✅ Rob 3 nov — Typ **rares**: de **Rares-tab** staat nog steeds bovenaan, niet een losse rare.
- [x] ✅ Rob 3 nov — Typ **Deutsch**: de taalinstelling komt naar boven.
- [x] ✅ Rob 3 nov — Typ onzin (*zzzq*): er staat één grijze regel *"Nothing in this list. Press Enter to search the Codex and guides
      too."* (de lijst verdwijnt niet meer zomaar). Enter zoekt dan verder, zoals vroeger.
- [x] ✅ Rob 3 nov (pijltjes + Enter) — **Pijl omlaag / omhoog** en **Tab** lopen door de lijst (de regel licht op);
      **Enter** opent de gekozen regel.
- [x] ✅ Rob 3 nov — **Escape** sluit de lijst én laat het toetsenbord los: daarna kun je meteen weer **lopen met WASD**.
- [x] ✅ Rob 3 nov (gevoel, geen meting) — Voelt het typen **traag of hapert het spel** bij elke letter? Buiten het spel
      gemeten was het 15-50 ms per letter met een lijst van 1500 regels.
- [vervallen, niet getest] **In het Nederlands:** zet MH op Nederlands (Instellingen → taal → Nederlands; dat werkt ook op een Engelse client)
      en typ **pijl**: *"Route-pijl grootte (zonder TomTom)"* komt in de lijst. Typ ook **pjil** (tikfout). Daarna de taal
      terugzetten. (Duits, Frans enz. kun je niet testen: die talen laden alleen op een client in die taal — GEMETEN in
      `Locales/deDE.lua:19`, `itIT.lua:26`.)
- [x] ✅ Rob 3 nov — `/mh settings` en de oude zoekwoorden (*delves*, *consumables*, `/` voor commando's, `@mount`) werken nog als vroeger.

## 🆕 2 nov — rare-route op The Coiled Isle

✅ **Rob 3 nov (gesproken, via Willow):** *"vandaag al een rare-route gedaan, [Coiled Isle]. Die ging helemaal goed."* Een
algemeen oordeel; welke punten hieronder hij precies zag, is niet gezegd. Daarom blijven ze open staan.

Eerst `/reload`. Rares-tab → The Coiled Isle → Generate Route.
- [vervallen, niet getest] De pijl **blijft bij één rare** tot je hem gedood hebt, of tot je er ~8 s buiten gevecht staat en hij er niet is
      (dan gaat hij naar de volgende). Rondrijden of een rare op de minimap zien laat hem **niet** meer wisselen.
- [vervallen, niet getest] Gaat de route naar **Szarith the Fanged** (onder de Vaults): bij de eerste stap staat er nu *"the way into Vaults of
      Atal'Utek"*, niet meer *"the way through"*.
- [vervallen, niet getest] Bij die ingang springt de route **niet meer terug** naar stap 1 als je even heen en weer loopt (chat zegt niet twee
      keer "step 1 of 4"). Loop je echt weer naar buiten, dan mag hij wel opnieuw plannen.
- [vervallen, niet getest] Let op: Szarith is nooit gedood, ook niet door jou. Staat er niets op zijn plek, maak dan `/mh here` + een screenshot.
- [vervallen, niet getest] **Szarith komt als laatste:** de route doet eerst alle open rares bovenop het eiland (en Nar'zira), en gaat pas
      daarna naar beneden naar Szarith.
- [vervallen, niet getest] **Skip** (`/mh skip` of de toets) slaat de rare over **waar de pijl op staat**, niet een andere.
- [vervallen, niet getest] Bij Szarith zegt de chat (en de tooltip in de Rares-tab): *"not elite himself, but elite guards stand around him —
      a group helps; no rare star on the minimap"*.

## 🆕 30 okt — vensters per character + coach-knop op het kaartje

Eerst `/reload`.
- [vervallen, niet getest] Instellingen → Venster & weergave: nieuw vinkje "Window place and size per character", standaard **uit**. Uit = alles
      zoals nu (alle characters delen plek en grootte).
- [vervallen, niet getest] Vinkje aan (of `/mh windows perchar`, chat zegt "every character now keeps its own …"). Sleep op character A een
      venster en maak hem met Shift+scroll groter. Log in op character B: daar staat het venster nog op de gedeelde plek
      en grootte. Verplaats hem op B; terug op A staat hij weer waar A hem liet.
- [vervallen, niet getest] Vinkje weer uit: alle characters gebruiken weer de gedeelde plek en grootte (zonder /reload, bij het volgende openen).
- [vervallen, niet getest] Labyrinth: op een kamerkaartje met een baas (bv. "Returning the Bounty" → Pit Boss) of een baaskaartje op "Open the
      delve coach" drukken. De coach opent op **die baas** (niet 1/19), zijn stuk bovenaan, en de lange lijst met kamers is
      ingekort tot hem. Een kamer zonder baas: coach opent zoals vroeger.

## 🆕 29 okt (avond) — vensters onthouden hun plek + kamerkaartje blijft open (Italiaanse vragenlijst, cijfer 4)

Eerst `/reload`.
- [x] ✅ GEMETEN Rob 30 okt: een versleept venster kwam na uit- en inloggen terug op zijn plek, ook op een ander character
      (de plek geldt voor het hele account, `MidnightHelperDB`).
- [vervallen, niet getest] Aan de rechterkant vastgezette vensters ("dock") volgen nog steeds het hoofdvenster.
- [vervallen, niet getest] `/mh windows reset` + `/reload`: alle vensters weer op hun eigen plek en grootte.
- [x] ✅ Rob 30 okt ("vink maar af", screenshot): op het kamerkaartje op "Open the Delve Coach" gedrukt. Het kaartje bleef
      staan naast de coach. Niet apart gemeld: of je het kaartje weer ziet na het sluiten van de coach.

## 🆕 29 okt — nieuw Delve Log + melding na een delve (ontwerp C + D)

Eerst `/reload`.
- [x] ✅ GEMETEN Rob 29 okt (screenshot): `/mh scorecard test` → "Test Delve · Tier 5", "4:12", gele ster + groen "New
      record: 0:18 faster than 4:30".
- [x] ✅ GEMETEN Rob 29 okt (screenshot): tabblad Delve Log met vier vakjes (Runs 10, Time in delves 7h 27m, Records 5
      groen, Deaths 19), kolomkoppen, 6 delves met T11 + record, Labyrinth "splits ->", Rituals eronder, voetregel.
      Records 5 = de 5 delves zonder de Labyrinth; Runs 10 = 9 delve-runs + 1 ritual (nagerekend).
- [vervallen, niet getest] Klopt "Record there" met je snelste run op T11? (Alle runs op het scherm zijn T11, dus een lage-Tier-run kan het
      hier niet verstoren; dat deel is bij jou niet te zien.)
- [x] ✅ GEMETEN Rob 29 okt (screenshot): openklappen werkt; "T11 21:40", de kop, ster bij het record, rood "+10:03"
      (31:43 - 21:40, nagerekend). ⚠️ De notities liepen eraf ("Deaths: 1 · Oct 06…") → gerepareerd, zie hieronder.
- [vervallen, niet getest] Na `/reload` dezelfde delves openklappen: nu "1 death" en een korte datum ("Oct 06"), en past de hele regel ook bij
      "Replicating Venomborne"? Nieuwe runs krijgen "(ster) -0:52" of "first T11".
- [vervallen, niet getest] De regel "The Labyrinth of Kindo'jan" zegt rechts "splits ->"; daarop klikken opent het splitsvenster (B).
- [vervallen, niet getest] Onderaan de uitlegregel over records per Tier; rituals staan er nog onder.
- [vervallen, niet getest] Na een echte gewone delve: de melding met de naam, Tier, je tijd en groen/rood/"First time on Tier …".
- [vervallen, niet getest] Instellingen: "Notice after a delve" uit → na `/mh scorecard test` geen melding meer (chatregel wel).

## 🆕 29 okt — splitsvenster (ontwerp A + B)

Eerst `/reload` (nieuw bestand: bij een fout eerst een volledige herstart van WoW).
- [x] ✅ GEMETEN Rob 29 okt (screenshot): `/mh labsplits` → "Labyrinth best times", knop "Tier 11", 8 kamers met beste
      tijd en "Set on" "-", "All your bests added up 86:38" (= zijn run van 27 okt), "No finished run yet", "Show last
      run" grijs, vinkje aan, "Wipe Tier 11...".
- [vervallen, niet getest] Shift+scroll maakt het venster groter/kleiner; slepen werkt; Escape sluit hem.
- [x] ✅ Rob 30 okt: bij het verlaten van de Labyrinth (29 okt avond, met Carola) ging venster A vanzelf open.
      Nagemeten in de SavedVariables (`labSplits.lastRun`): 5 kamers T11, samen 52:03 (som klopt), 1 record (The
      Catacombs 7:53, was 10:05; alleen daar `bestAt` gezet), de andere 4 bests onaangetast. Rob 30 okt over de klok
      (start ~21:14, kamer 5 klaar 22:06, weg 22:28): *"qua tijden klopt het wel"*.
- [x] ✅ Inhoud van venster A — Robs screenshot 31 okt (T11, volle run van 9 kamers): Tier 11, Total 99:23, New bests 2;
      per kamer tijd + "first time" / groen "-3:45 faster" met ster / "+5:49 slower"; onderin "If every room went like
      your best: 75:20"; chatlijstje staat er ook. GEMETEN uit de screenshot: som van de 9 kamers = 99:23, som van de
      teruggerekende bests = 75:20, chat = venster. Rob: "alleen laten zien" (geen fout).
- [vervallen, niet getest] "My best times" → venster B, nu met datum bij nieuwe records en "Last run (…)"; "Show last run" → terug naar A.
- [vervallen, niet getest] Vinkje "Show this window after every run" uit → na de volgende run alleen het chatlijstje.
- [vervallen, niet getest] "Wipe Tier 11..." → vraag "Wipe your best Labyrinth times on Tier 11?" → Nee laat alles staan. (Ja wist echt!)

## 🆕 25 okt — tabblad Solo voor healers

`/reload`, op een healer: `/mh play` → tabblad **Solo** (naast Klikken).
- [vervallen, niet getest] Vier blokken (Before the fight / Attack / Heal / When it goes wrong), onderaan de gouden regel en Valeera. Iconen,
      gouden namen, je klik tussen haakjes; spells die je niet hebt grijs. Past de tab-rij nog (7 tabs)?
- [vervallen, niet getest] Resto Druid met Starsurge: aanval = Sunfire/Moonfire/Starsurge/Wrath/Starfire. Zonder Starsurge maar mét Rake:
      Cat Form/Rake/Rip/Shred/Swipe. (Kat niet gezien: Rob heeft Starsurge.)
- [vervallen, niet getest] Your buttons: in plaats van de lijst "How you fight alone" één regel die naar het tabblad Solo wijst.
- [x] ✅ GEMETEN Rob 25 okt: Symbiotic Relationship op Valeera duurt 3600 s (aura-duration); op jezelf kan niet.

## 🆕 25 okt — Valeera voor healers

- [vervallen, niet getest] Op een healer (bv. de Resto Druid): `/mh curios`. Staat onder de uitleg over de sterren de regel "You heal: which
      role for Valeera? …"? Op een DPS- of tank-character hoort die regel er NIET te staan.

## 🆕 25 okt — rare-route blijft in de gekozen zone

- [vervallen, niet getest] `/reload`, in Silvermoon: Rares-tab → Coiled Isle → Generate Route. Wijst de pijl nu eerst naar de portal naar de
      Coiled Isle (niet naar een rare in Eversong), en daar naar de dichtstbijzijnde open rare? Na `/reload` midden in de
      hunt: blijft hij op de Coiled Isle?

## 🆕 25 okt — schouders zonder enchant

- [x] ✅ GEMETEN Rob 26 okt (3 screenshots): Gear check "Shoulders: geen enchant" rood, Enchants-tab "Shoulders — ONTBREEKT"
      met Akil'zon's Swiftness voorop, en de boodschappenlijst toont "Shoulders (a choice) — Akil'zon's Swiftness — Buy 1".

## 🆕 26 okt — Labyrinth-splits (race tegen je beste tijd per kamer)

Eerst `/reload`, dan BUITEN de Labyrinth de run beginnen (anders telt de eerste kamer niet: MH zag de start niet).
- [x] ✅ GEMETEN Rob 27 okt (video 07-39-48 + SavedVariables): na kamer 1 onder het midden "Chamber of Rites: 14:14. Your
      first time on Tier 11: this is now the time to beat." en dezelfde regel in de chat; ns.db.labSplits.best[11]["Chamber
      of Rites"] = 854. /reload daarna: geen fouten. (Kamer = de plek; de taak was Taken Antiquities.)
- [vervallen, niet getest] Een tweede keer dezelfde kamer: "… 0:38 faster than your best … New record!" of "… slower …".
- [x] ✅ **Tier-reparatie** GEMETEN Rob 27 okt avond (screenshot): `/mh labsplits move 6 11` → Tier 11 met Chamber of
      Rites 8:12, Tier 6 weg; daarna "tier 11" in de status en in elke kamer.
- [x] ✅ Kindo'jan (platform) GEMETEN 27 okt: map 2648, kamer 'De Empire's Rest', chatregel "De Empire's Rest: 18:36 …"
      (split = vanaf de vorige kamer; de kill zelf 2:42 volgens DBM). ⚠️ De melding op het scherm zag Rob daar NIET —
      oorzaak onbekend (buit/DBM/Blizzard-banner tegelijk?); video zou het laten zien.
- [vervallen, niet getest] Volgende Labyrinth-run: **film de kill van Kindo'jan** (Rob, 28 okt: "ik film hem de volgende keer"). Kijk of de
      melding rechtsonder verschijnt (daar heb je hem neergezet), tegelijk met de chatregel "De Empire's Rest: …".
- [x] ✅ Na het verlaten GEMETEN 27 okt: "Labyrinth, Tier 11: 8 rooms in 86:38, 0 new record(s)" + 8 kamers; som klopt.
- [vervallen, niet getest] Na de reparatie van 27 okt laat: bij 0 records staat er géén "0 new record(s)" meer ("… 8 rooms in 86:38. Per
      room:"), bij 1 "1 new record", bij meer "3 new records".
- [vervallen, niet getest] Run-scorekaart met `/mh scorecard detail` aan: de grijze regel zegt "vs avg -36m 13s", geen "-2173s".
- [x] ✅ `/mh labsplits` GEMETEN 27 okt: beste tijden per Tier + de grijze statusregel.
- [vervallen, niet getest] Instellingen → "Labyrinth splits" uit → geen regels meer.

## 🆕 26 okt — delve-verhalen in elke taal

De vertalingen zelf kun jij niet zien (taalpakketten werken alleen op die client). Wel, op je Engelse client:
- [vervallen, niet getest] In Atal'Aman of Twilight Crypts: noemt de coach nog het verhaal van vandaag met Blizzards zin eronder, en heeft
      de baaskaart (Jin'Ma / Vashnik / Darza / Venomborne) nog zijn tips? (De zoekcode is vandaag veranderd.)

## 🆕 26 okt — Instellingen: aantal invullen bij het kopen

- [vervallen, niet getest] Instellingen → Midnight Helper → Venster & weergave: staat er "Fill in the amount when buying" (aan)? Zet hem uit:
      een regel in de boodschappenlijst aanklikken + gouden variant → het aantal blijft 1. Weer aan → het aantal klopt.

## 🆕 26 okt — veilinghuis: "Internal auction error." meten

- [vervallen, niet getest] Klik op Buy Now (iets goedkoops) en klik méteen een regel in MH's lijst, terwijl het koopvenster nog open is: komt
      bovenin "Finish or cancel this purchase first, then click the next row."? Er wordt dan niet gezocht.
- [vervallen, niet getest] Zie je de rode "Internal auction error." toch: let op of hij bovenin het scherm staat of in de resultatenlijst, en
      wat je vlak ervoor klikte. Daarna `/reload`: ik lees ns.db.raidShopProbe (search-, Cancel- en foutregels).

## 🆕 26 okt — boodschappenlijst: aantal in het koopscherm

Eerst `/reload`, dan naar het veilinghuis.
- [vervallen, niet getest] Klik in MH's lijst een regel met "Buy 16" (bv. Combat Pot), dan in de resultaten de zilveren of gouden variant: staat
      bij het aantal **16** (niet 1)? Binnen een seconde ook prijs en totaal ingevuld?
- [vervallen, niet getest] "Back" en de andere kwaliteit kiezen: weer 16? Een gear-regel met "Buy 2" (ring, Peridot): 2?
- [vervallen, niet getest] Kopen zoals altijd. Let op rode tekst "Internal auction house error" en BugSack. (Na de aankoop zet Blizzard het
      zelf weer op 1; dat is normaal.)
- [vervallen, niet getest] Zelf iets anders zoeken en aanklikken: blijft 1. Ook in het tabblad Profession werkt het.
      Na afloop `/reload`: ik lees de "qty: …"-regels in ns.db.raidShopProbe.

## 🆕 26 okt — boodschappenlijst: taal van de knoppen

- [x] ✅ Rob 26 okt na /reload: tabs en "Everything to Auctionator" staan goed. (Taalwissel zónder /reload niet apart getest.)
      Was: Zet de MH-taal om (bv. Nederlands → Engels) zónder `/reload`, sluit de boodschappenlijst en open hem weer: staan de
      tabs (Raid | Profession) en "Everything to Auctionator" nu in de nieuwe taal? (Was: "Beroep" en "Alles naar
      Auctionator" bleven Nederlands op de Engelse raid-lijst.)

## 🆕 25 okt — "How do I buy this?" (boodschappenlijst stap voor stap)

Eerst `/reload`.
- [x] ✅ Rob 25 okt: "ik heb het inmiddels in het spel gezien en het ziet er zeker goed uit". Was: karaktervenster (C),
      Gear check-paneel: onder "Buy what's missing" staat "How do I do this? Step by step". Klik:
      opent een venster met 9 stappen? Goed te lezen? Bij stap 3 een zilver- én een goud-icoontje?
- [vervallen, niet getest] Klik "Buy what's missing": staat de knop "How do I buy this?" netjes boven het venster (rechts, naast de tabs
      Raid | Profession), en opent hij hetzelfde venster? Shift+scroll maakt het groter/kleiner?
- [vervallen, niet getest] In het veilinghuis, bij een enchant of gem uit je lijst: staat er achter de naam een zilver/goud-icoontje, net als bij
      potions? (Niet gemeten; als het er niet staat, klopt stap 3 niet voor die spullen.)

## 🆕 25 okt — Paladin: regel over Blessing of Dawn

- [x] ✅ GEMETEN Rob 25 okt (screenshot, Twelveinchy Holy): de grijze regel staat onderaan Stay alive, onder Divine Steed
      en boven de site-link → IsPlayerSpell(183416) is true met het talent. Zonder het talent niet getest.

## 🆕 25 okt — Labyrinth: Hexmask-melding (als je er toch bent)

De kamer wordt nu ook herkend aan de naam die het spel zelf geeft (voor spelers met een andere taal).
- [x] ✅ GEMETEN Rob 25 okt (screenshot, nl): in Jan'alai's Refuge kwam de melding ("… is een van de vijf Hexmask-plekken …").
      Probleem gezien: hij viel over de grote kamernaam van het spel en was niet te verslepen → gerepareerd (hieronder).
- [vervallen, niet getest] Met alle drie de maskers bij je: een maskerkamer in lopen → GEEN melding meer. `/mh hexmask` zegt "masks with you
      3/3 · hint: all three Hexmasks are with you". Met 1 of 2 maskers komt de melding wel.
- [vervallen, niet getest] Na `/reload`: de korte melding (Hexmask, kistenroute) staat nu onder het midden van je scherm, blijft 14 s (Hexmask),
      blijft staan zolang je muis erop staat, en is te verslepen; na een `/reload` staat hij waar je hem liet.

## 🆕 24 okt — flask-advies op Carola's character (als het rustig is)

Rob zag bij Carola (remote, geen screenshot) dat de flask in een dungeon niet dezelfde was als in het consumables-
overzicht. Op Robs eigen Hunter klopte alles. GEMETEN in de code: tabblad Consumables en `/mh ready` nemen allebei
best[1] uit ConsumablesWowheadByClassSpec; het dungeon-bord toont in de TOOLTIP de flask die je al in je tassen hebt
(zo bedoeld). ⚠️ Rob daarna: het bord zei juist dat ze hem NIET in haar tassen had. GEMETEN: BagTier telt alleen de
tassen, wel alle 4 Midnight-flasks (beide rangen + Fleeting; voor Frost staan ze alle 4 in best/alternates). Vermoeden
(AFGELEID): flask op bank/post, of een flask buiten de lijst (oud/TWW), of een andere spec.
- [vervallen, niet getest] Op Carola's character: noteer de flask in (1) `/mh play` → Consumables (welke spec staat bovenin?),
      (2) `/mh ready`, (3) de tooltip van het flask-icoon op het dungeon-bord, en welke flask(s) ze heeft: naam, en in
      de tassen of op de bank/post?

## 🆕 24 okt — tabblad Klikken (healers) + knop naar DandersFrames

Eerst `/reload`. Op een healer: `/mh play`, tabblad **Klikken** (rechts).
- [x] ✅ GEMETEN Rob 24 okt (Twelveinchy, screenshot): oranje DF-regel bovenaan, 12 regels kloppen, "Clicks" past als
      zesde tabblad. Tekstgrootte 1.5 niet apart getest.
- [x] ✅ GEMETEN Rob 24 okt (4 screenshots): vooraf `/mh klikken` alles "ja" (actief was "Holy Paladin - Klikken" uit het
      pakket); bevestigingsvraag met "MH - Holy Paladin"; DandersFrames zei zelf "Switched to profile: MH - Holy
      Paladin"; `/mh klikken` daarna: "on, profiel MH - Holy Paladin, indeling Holy", ongedaan maken: ja; knop Undo
      verschijnt. ✅ Groene regel "Done: DandersFrames now uses "MH - Holy Paladin" for your talent loadout "Holy"…"
      staat er (screenshot).
- [x] ✅ Rob 24 okt: "de icoontjes zijn goed" (Shift + Left rood vizier, Shift + Right briefje).
- [x] ✅ Rob 24 okt: "de knoppen al geprobeerd, dus die zijn goedgekeurd" (Holy Paladin).
- [x] ✅ GEMETEN Rob 25 okt (screenshots): na `/reload` blijft "MH - Holy Paladin" actief (DF-venster: Profile MH - Holy
      Paladin, Active Bindings 12; `/mh klikken`: actief DF-profiel MH - Holy Paladin).
- [x] ✅ GEMETEN Rob 24 okt: "Undo" zet terug naar het vorige profiel; daarna nog eens "Put in DandersFrames" werkt ook.
- [x] ✅ GEMETEN Rob 25 okt (screenshot): `/mh klikken` geladen/importfunctie/LibSerialize/zelf aanzetten allemaal "ja",
      "DandersFrames laatste keer: spec 65, on". De enige "nee" is "Blizzard ongedaan maken", terecht (al ongedaan).
- [x] ✅ Rob 25 okt: "Priest werkt alles goed" (andere spec bekijken, rechter Shift-toets). Was: op een andere spec
      bekijken (spec-icoon bovenaan): geen knop, wel "Wissel naar deze spec …". ⚠️ Kan NIET op de
      Paladin: Prot/Ret hebben geen tabblad Klikken (GEMETEN Rob 25 okt, zo gebouwd). Testen op de Priest: Holy actief,
      Discipline bekijken.
- [x] ✅ GEMETEN Rob 24 okt (screenshot, DF uit): oranje regel blijft, geen knop, wel de zin over Cell, VuhDo, Clique.
- [x] ✅ GEMETEN Rob 24 okt: `/mh klikken blizz` → pcall geen fout, geen meldingen, indeling gelijk: MAG.
- [x] ✅ GEMETEN Rob 25 okt (screenshots, Twelveinchy): met DF aan twee blokken, bij Blizzard de waarschuwing "You use
      DandersFrames, so you do not need this…"; met DF uit alleen het Blizzard-blok + de zin "You do not have
      DandersFrames…". Blizzard-knop op de Paladin: "Done: … these 12 clicks"; daarna Undo → `/mh klikken` "nu 2 regels
      (0+LeftButton:3/1 0+RightButton:3/2)" = Blizzards standaard terug, "Your old Blizzard click layout is back."
- [x] ✅ Rob 25 okt: "De nieuwe bovenste zin is goed zoals hij staat." Was: is de nieuwe bovenste zin goed ("These clicks only work with the addon DandersFrames or with Blizzard's own
      party and raid frames. Other frame addons (Cell, VuhDo, Clique): copy the table by hand.")? Gezien, nog niet bevestigd.
- [x] ⚠️ GEMETEN Rob 24 okt (Holy Priest): eerste versie → alleen klikken zonder toets werkten. Oorzaak gemeten
      (MakeModifiers: Shift 3, Ctrl 12) en gerepareerd. Opnieuw testen hieronder.
- [x] ✅ GEMETEN Rob 24 okt (Holy Priest, na de reparatie 3/12/48): "alle knoppen werken nu"; `/mh klikken` toont 10
      regels met 0/3/12/48. Shift + rechter muisknop (menu) werkt ook (Rob). Rechter Shift-TOETS en Undo nog niet gemeld.
- [vervallen, niet getest] (oud, ter info) Zet DandersFrames UIT, `/reload`, en druk (opnieuw) "Zet in Blizzards klikken" → bevestigen → groene regel "… %d klikken".
      Esc → Options → Gameplay → Keybindings → Click Casting: staan ze erin? In Blizzards groepsvakjes: Ctrl + links = Cleanse, Shift + links = doelwit
      (probeer ook de RECHTER Shift). Dan "Ongedaan maken": je oude (2 regels: doelwit/menu) is terug. `/mh klikken` laat
      onderaan de Blizzard-regels zien.
- [x] ✅ Rob 25 okt: Mistweaver Monk (level 11), knop gezet in DandersFrames, "dat werkt". ⚠️ Op level 11 kent hij nog
      lang niet alle 9 spells; of de latere klikken (bv. Life Cocoon) werken zodra hij ze leert, is niet gezien.
- [vervallen, niet getest] Preservation Evoker: nog niemand (Carola en Cisca hebben er geen). Tabblad Klikken, 9 klikken + 3 vrij,
      knop → "MH - Preservation Evoker" actief in DandersFrames.
- [x] ✅ GEMETEN Rob 25 okt (Earthshammy, DandersFrames): Ctrl + middelste knop geeft Nature's Swiftness ("het werkt
      zoals we willen, ik had gewoon niet goed opgelet"). `/run` gaf `true false 378081 0.001`: NS gekend, geen
      Ancestral Swiftness, geen override, klaar. Was: de Shaman, knop, en werkt Ctrl + middelste knop?
- [vervallen, niet getest] Open (niemand kan het nu): een Farseer-Shaman mét Ancestral Swiftness (443454 overschrijft 378081). Cast de
      DF-klik op de naam "Nature's Swiftness" dan Ancestral Swiftness? NIET GEMETEN (mh-research 25 okt).

## 🆕 24 okt — changelog voor de volgende versie

- [x] ✅ GEMETEN Rob 24 okt (screenshot): `/mh changelog` toont bovenaan "Version 4.11.3" met de twee Labyrinth-regels,
      daaronder 4.11.2; venstertitel zegt nog "Version 4.11.2" (TOC, zoals bedoeld).

## 🆕 23 okt — spelkaarten: vijf regels nagelopen

- [vervallen, niet getest] Fire Mage (Iceicebaby kan wisselen): `/mh play`, stap "4 or more enemies": staat Flamestrike in **kleur** (niet grijs),
      ongeacht welke van de twee Flamestrikes je koos?
- [vervallen, niet getest] Frost Mage met het talent Comet Storm: `/run print(IsPlayerSpell(153595), IsPlayerSpell(1247777))` — stuur de regel.
      (Is de eerste "false", dan kleurt de kaart Comet Storm onterecht grijs.)
- [vervallen, niet getest] Affliction Warlock (Warlockie): stap 5 begint nu met Shadow Bolt.

## 🆕 23 okt — Paladin: Forbearance 20 sec met Holy Reprieve

- [x] ✅ GEMETEN Rob 23 okt (Twelveinchy, Holy, mét Holy Reprieve): `/run … GetPlayerAuraBySpellID(25771) … a.duration`
      gaf **20**. Zonder het talent (30) niet getest.
- [vervallen, niet getest] `/mh survival` of de Stay alive-kaart noemt nu "30 sec (20 with the Holy Reprieve talent)" (tekst nog niet gezien).

## 🆕 23 okt — Venomstones in het karaktervenster

Eerst `/reload`, op een max-level character.
- [x] ✅ GEMETEN Rob 23 okt (Twelveinchy, screenshot): maxed-zin nieuw ("1 slot is maxed on Veteran - … also with
      Venomstones"); 0 stenen en geen kandidaat → geen Venomstones-regels, zoals bedoeld. `/mh tracks`: Champion = track
      973, Hero = 974 → MH filtert kandidaten nu op track ≥ 974. Myth-nummer nog niet gezien (geen Myth-stuk).
- [x] ✅ GEMETEN Rob 23 okt (Iceicebaby, Frost Mage, screenshot): "Ascendant Venomstones: 0 of 10" en "Can go higher with
      them (Hero or Myth only): Main Hand (Hero 6/6)" — kandidaatregel + Hero-filter (974) werken.
- [vervallen, niet getest] Karaktervenster open (zodra je een steen hebt): in MH's zijpaneel staat "Ascendant Venomstones: x of 10" (klopt het getal met je tassen?
      ligt er een steen op je bank: telt die mee?). Met 10 of meer: groene regel "take 10 to the Catalyst …".
- [vervallen, niet getest] Heb je een wapen, trinket of neck helemaal opgewaardeerd: regel "Can go higher with them (Hero or Myth only): …"
      met slotnaam en track. Staat er een stuk bij dat al Ascendant is? Dan klopt dat niet (niet gemeten).
- [vervallen, niet getest] De maxed-regel zegt nu "… and a weapon, trinket or neck on Hero or Myth also with Venomstones".
- [vervallen, niet getest] `/mh tracks`: elke regel eindigt op "(track N)". Stuur de regels van een Hero- en een Myth-stuk; dan kan MH
      zelf filteren op Hero/Myth. Onderaan staat de Venomstones-telling en een extra route-regel.

## 🆕 23 okt — Assassination Rogue: Crimson Tempest op Shift+3

- [vervallen, niet getest] Assassination Rogue, `/reload`, toetsenblok: Crimson Tempest staat bij de gewone aanvalsknoppen (niet bij de
      spenders) op Shift+3; Poisoned Knife blijft op Shift+2, Fan of Knives op Shift+1; Shift+5 is leeg.

## 🆕 23 okt — Labyrinth: Kinduru als uitweg bij 0 levens

- [vervallen, niet getest] Alleen als het je overkomt (vast bij Kindo'jan met 0 levens): staat Kinduru in de voorkamer van De Empire's Rest
      (AFGELEID: de kamer achter de Kindo'jan-deur, met waystone en Altar of Corrosion)? Brengt praten met hem je naar
      de schatkamer, mét beloningen? Zo niet: werkt het touw nog? Delve-tip en Codex zeggen nu "eerst Kinduru, anders het touw".

## 🆕 22 okt — kaarten: wat alleen in het spel te beslissen is

Eerst `/reload`. Elk punt beslist of een zin op de kaart klopt; alleen doen met een character dat je toch speelt.
- [x] ✅ GEMETEN Rob 22 okt: vóór drukken "Holy Bulwark" (toetsenblok F1), na één keer drukken "Sacred Weapon"
      (tooltip: "Becomes Holy Bulwark after use"). → PLAYCARD_65_HERO2 omgedraaid in alle talen.
- [vervallen, niet getest] Feral Druid 90 met Frantic Frenzy i.p.v. Focused Frenzy: `/mh play` stap 2: staat er "Feral Frenzy" of "Frantic
      Frenzy", goud of grijs? Klopt de toets?
- [vervallen, niet getest] Shadow Priest, solo, dummy, niet vol leven, geen DoTs op de dummy: Mind Blast zonder en mét Vampiric Embrace.
      Gaat je leven mét VE duidelijk meer omhoog?
- [vervallen, niet getest] Rogue: Evasion, 3 melee-mobs, eerst aankijken, dan rug toe. Zie je "Dodge" alleen zolang je ze aankijkt?
- [vervallen, niet getest] Affliction Warlock met Grimoire of Sacrifice + Felhunter opgeofferd: `/run print(C_Spell.GetOverrideSpell(119898))`
      en `/mh survival`. Stuur beide regels.
- [vervallen, niet getest] Arms, Fury of Prot Warrior met Impending Victory: `/mh survival`. Staat er "+ Victory Rush … order 1" of
      "- Victory Rush … not known (34428)" + "+ Impending Victory"? En staat "only right after a kill" achter Impending Victory?
- [vervallen, niet getest] Op een healer-kaart staat nu ook "Every line checked … on 22 Oct 2026."
- [vervallen, niet getest] Holy Priest met Holy Fire: in "Fight alone" staat Shadow Word: Pain niet meer; Holy Nova zegt "for four or more enemies".
- [vervallen, niet getest] Disc Priest: Power Infusion in de heal-cooldowns zegt "Give it to a damage dealer …".
- [vervallen, niet getest] "Stay alive" eigen zinnen: Vengeance DH Demon Spikes "keep it rolling as much as you can …"; Devastation Evoker
      Deep Breath "press it on cooldown …"; Hunter Survival of the Fittest "just before each big hit; it comes back after
      1.5 min …"; Rogue Evasion heeft nog zijn "dodges hits from the front …"-noot.

## 🆕 22 okt (avond) — Rite of Adjuration in het toetsenblok

- [x] ✅ GEMETEN Rob 22 okt (terug naar Lightsmith): Rite of Adjuration staat op Shift+R, de "Not in … list"-regel is weg.
- [x] ❌ Rob: "Cheat sheet (code for the website)" viel buiten zijn knop → knoppen onderaan maken hun tekst passend.
- [x] ✅ Rob 22 okt (screenshot): "past nu" — Cheat sheet en "Put 'Twelveinchy Holy' back" binnen hun knop.

## 🆕 22 okt (avond) — quiz: geen dubbele gaten meer

- [x] ❌ Rob 22 okt (Holy Paladin): "______ (not with Lightsmith) and Avenging Wrath … ______ fills your Holy Power" —
      het antwoord stond 2× in de zin. GEMETEN: 14 stappen op 13 kaarten hadden dat.
- [x] ❌ Rob 22 okt: `/mh play` opende op de quiz (vorige keer open gelaten) i.p.v. "Your buttons"; en "Group" viel
      buiten het venster (tekstgrootte 1,5). → quiz wordt bij openen teruggezet op de kaart; tabbladen passen zich aan
      (minder ruimte ertussen, zo nodig kleinere letters).
- [x] ✅ Rob 22 okt: "/mh play opent op Your buttons en Group past."
- [x] ✅ Rob 22 okt (screenshot): vraag 1 heeft één gat, antwoord Avenging Wrath. Holy Paladin verder ✅: Intercession
      "costs 2% of your base Mana" (tooltip 5,000 Mana); Dispel = Magic zonder, Magic/Poison/Disease mét Improved Cleanse.
      Steekproef op een andere kaart (Feral, Survival Hunter, Affliction, Assassination): nergens twee gaten.

## 🆕 22 okt — Codex: ons advies licht op

Eerst `/reload`, dan de Corrosive Codex openen.
- [vervallen, niet getest] Op de gele MH-kaart staat bovenaan "Click a situation: its gifts light up in the Codex."
- [x] ✅ Rob 22 okt (na 2 fixes: witte regel → zachte kleur; rand nu aan Blizzards knop): "de gouden rand is nu zichtbaar".
      Klik "Groups of enemies take too long": Plague of Corrosion en Ophidian Maw krijgen in Blizzards venster een
      knipperende gouden rand. De regel op de kaart krijgt een lichte achtergrond. Nog eens klikken = uit.
- [vervallen, niet getest] Een gift die je al hebt (vinkje) krijgt GEEN rand.
- [vervallen, niet getest] Je kunt de opgelichte knop gewoon zelf aanklikken (de rand zit niet in de weg).
- [vervallen, niet getest] Geen rand te zien? Typ `/mh gifts` en stuur de regel "glow: …".

## 🆕 22 okt — karaktervenster: kleur per enchant

Eerst `/reload`, op een level-90, karaktervenster open (C).
- [vervallen, niet getest] Het MH-paneel naast je karaktervenster heeft één regel per stuk met een enchant-plek (helm, schouders, borst,
      broek, laarzen, 2 ringen, wapen). Groen = ons advies, oranje = een andere enchant, rood = geen enchant, geel =
      weten we niet. Onderaan staat die uitleg.
- [vervallen, niet getest] De namen zijn de namen die je eigen tooltip toont. Bij een rang-1-enchant staat "(rank 1; rank 2 is stronger)".
- [vervallen, niet getest] Schouders zonder enchant: grijs "(optional)", niet rood.
- [vervallen, niet getest] Een lege socket: een rode regel met het stuk erbij.
- [x] ✅ Rob 22 okt: kleuren per slot kloppen (stap 1-3 van de testronde). Klik gaf het advies in de chat (screenshot).
- [x] ✅ Rob 22 okt (screenshot): klik opent het Enchants-venster. ❌ Onderaan liepen de socket-knop en het zoekveld over
      de Neck/Wrist-regels → het rapport staat nu in een scrollvak boven de knop; kop "Crit / Mastery" bij gelijkspel.
- [x] ✅ Rob 22 okt (screenshot): Enchants-venster scrolt, onderaan niets meer over elkaar, kop "Crit / Mastery".
- [x] ✅ Rob 22 okt (screenshot karaktervenster): "Buy what's missing: shopping list" staat erin; Mastery-wapen en
      -ringen nu GROEN (gelijkspel-fix); namen zonder "Enchant Weapon -"; "1 slot is maxed on Hero" (enkelvoud).
- [x] ✅ Rob 22 okt (screenshot): "Buy what's missing" opent het boodschappenvenster; "Your gear" toont Chest (Enough),
      Head + Feet (Buy 1) en Empty sockets (Enough).
- [vervallen, niet getest] (eerder) NIEUW (Rob: "handiger … in een mooie venster … aanklikken om te kopen"): klik op een regel opent nu het
      Enchants-venster van MH (geen chat meer). Mist er iets, dan staat onderaan "Buy what's missing: shopping list":
      dat opent het /mh ready-venster met je ontbrekende enchants en gems; klik daar = zoeken in het veilinghuis.
- [vervallen, niet getest] Op een alt onder level 90: nog de oude regels ("x slots without an enchant").

## 🆕 22 okt — "How you play"-venster: scrollen en geen regels meer over elkaar

✅ Rob 22 okt (screenshot, Elemental): geen regels meer over elkaar, scrollbalk zichtbaar. ❌ De tabbladen scrolden mee
weg → nu vast bovenaan:
- [x] ✅ Rob 22 okt (Frost-screenshot): de spec-icoontjes en de tabbladen blijven bovenaan staan.
- [vervallen, niet getest] Onderaan de kaart (Frost, Elemental, …): na "From the guides: …" staat nu "Every line checked against the guides
      and Blizzard's game data on 21 Oct 2026." Op een healer-kaart (Holy Paladin, Resto Druid …) met "22 Oct 2026".

✅ Rob 22 okt: stap 1-3 van de testronde (How you play, karaktervenster, kleiner maken) kloppen allemaal.
Eerst `/reload`. Op je Elemental Shaman, tekstgrootte zoals je hem nu hebt (1,5).
- [x] ✅ Rob 22 okt: `/mh play` scrolt met het muiswiel, nooit hoger dan het scherm.
- [x] ✅ Rob 22 okt: na Shift+scroll lopen de regels niet meer over elkaar.
- [x] ✅ Rob 22 okt: spell-tooltips op de gele namen werken, ook na scrollen.
- [vervallen, niet getest] Klik een andere tab ("Stay alive") en terug: de kaart begint weer bovenaan.

## 🆕 22 okt — alle vensters kleiner (Shift+scroll tot 0,5)

Eerst `/reload`.
- [x] ❌ Rob 22 okt: kleiner gaat, maar dan te klein om te lezen, en regels lopen over elkaar. → morgen: opnieuw
      opbouwen na schalen + scrollen (zie NEXT_SESSION).
- [x] ✅ Rob 22 okt (stap 3 van de testronde): ook de andere vensters gaan tot 0,5.

## 🆕 22 okt — Codex: wat je met overgebleven Corrosive Souls doet

- [x] ✅ Rob 22 okt (screenshot). `/mh codex` → Corrosive Codex-kaart (gifts): nieuw stuk "All twelve unlocked? What your spare souls are for" met
      Er'inye (Satchel of Corrosive Coins) en Naleidea Rivergleam (Pouch of Undercoin), elk 1 soul.
- [vervallen, niet getest] Ruil 1 soul bij Er'inye: kost het echt 1 soul, en hoeveel coins zitten erin met jouw Altar-bonus?

## 🆕 22 okt — Gilded Stash telt het Labyrinth mee

- [x] ✅ Rob 22 okt (screenshot): "Gilded Stash (this character): 1 / 4" na het verlaten van het Labyrinth.
- [-] "A Gnawing Void of Curiosity" = 2000 Journey-punten: NIET TE METEN bij Rob. De Labyrinth Journey is warbound en
      staat al op rank 9, 2100/2100 (Rob, 22 okt). Blijft "volgens Wowhead".

## 🆕 22 okt — Codex-advies niet meer doorzichtig
- [x] ✅ Rob 22 okt (screenshot): het gele venster heeft een dichte, effen achtergrond. (Overlap met Party Targets zelf
      niet in beeld; zie hieronder.)
- [x] ✅ Rob 22 okt (screenshot): "You have: Miasma Geyser + Ula'tek's Gift", vinkjes bij Ula'tek's Gift.
      Na `/reload`, Codex open: het gele venster zegt "Your gifts: Miasma Geyser + Ula'tek's Gift" (groen) en zet een
      vinkje achter Ula'tek's Gift in de adviesregels. Was "You have no gift picked yet": Blizzard nummert de knoppen
      sinds kort 49-60 i.p.v. 13-24 (GEMETEN in Robs `/mh gifts`-dump), MH telt nu de plek van de knop.

- [vervallen, niet getest] Open het Corrosive Codex-venster terwijl het doelwit-lijstje (Party Targets) erachter staat: het gele MH-advies is
      nu dicht, de tekst "— no target —" schijnt er niet meer doorheen.

## 🆕 21 okt (laat) — laatste kaart-klusjes

Eerst `/reload`. `/mh survival` laat per regel zien waarom hij er wel of niet staat.
- [x] Shaman: Earth Elemental staat op de kaart (Rob, Elemental, 21 okt: `/mh survival` → "[big] order 2").
- [vervallen, niet getest] Shaman mét Healing Stream Totem: de regel "heals an injured player near you…" (Rob heeft het talent niet: "not known
      (5394)", dus terecht weg). En de Earth Elemental-regel "it taunts and tanks for you…" zelf nog op de kaart bekijken.
- [vervallen, niet getest] Windwalker met **Combat Wisdom**: Expel Harm staat NIET meer op de kaart (`/mh survival`: "talent 121817 takes this
      button away"). Zonder dat talent staat hij er wel.
- [vervallen, niet getest] Priest zonder **Translucent Image**: Fade staat niet op de kaart; mét het talent wel.
- [vervallen, niet getest] Quiz op level 90, Affliction Warlock met Improved Shadow Bolt (geen Drain Soul): geen vraag met Drain Soul als
      antwoord. Zelfde voor Frost DK zonder Frostscythe, Demonology met Power Siphon (geen Implosion).

## 🆕 21 okt (laat) — Labyrinth: het touw naar de schatkamer

Eerst `/reload`.
- [x] ✅ Rob 22 okt (screenshot). `/mh coach labyrinth` → Kindo'jan-tip: de regel "Out of lives before he dies?" noemt nu het opgerolde touw bij de
      dichte deur aan het begin, en zegt dat je de delve niet moet verlaten.
- [vervallen, niet getest] `/mh codex` → Delves → The Labyrinth of Kindo'jan: bij Kindo'jan de regel "Stuck near him with 0 lives…", en
      onderaan "every Bountiful Coffer needs a Restored Coffer Key, one per coffer". "Not known yet" noemt geen sleutel meer.
- [vervallen, niet getest] Flooded Chamber, ijsmuur (Elemental Shaman, eerst `/combatlog`): val het ijs eerst ALLEEN met Lightning Bolt aan
      (geen vuur). Smelt het? Dan werkt elke aanval. Zo niet: daarna alleen Flame Shock. Zeg welke het deed.
- [x] Coördinaten touw: Rob 21 okt, 44.31/80.61 (map 2647).
- [vervallen, niet getest] Codex-kaart Labyrinth: de link "Rope" bij het touw zet een pijl naar 44.31, 80.61 (naast Wah'du).

## 🆕 21 okt (avond) — alle 35 overige "How you play"-kaarten nagelopen

Eerst `/reload`. Steekproef op een paar characters:
- [vervallen, niet getest] Elke kaart heeft bovenaan (ook op level 90) de regel "This card follows the talents most players pick. Missing a
      button? Then it is a talent you did not choose." Onder level 90 staat die achter de grijs-uitleg.
- [vervallen, niet getest] Balance Druid: de Eclipse-knop heet nu "Solar Eclipse" en heeft een toets (was een passieve spell zonder toets).
- [vervallen, niet getest] "Blijf leven" (Stay alive): Brewmaster Purifying Brew "when your Stagger bar turns yellow or red"; Prot Warrior
      Shield Block/Ignore Pain "press it right after the fight starts …", Shield Block "only against melee hits"; DK
      Lichborne "against fear, charm or sleep …"; Rogue Feint "only against area damage"; Evoker Zephyr bij de grote.
- [vervallen, niet getest] Mistweaver: dispel alleen Magic, met Improved Detox ook Poison/Disease.
- [vervallen, niet getest] Prot Paladin (jij): S3, W3, TERMS en de Forbearance-regels lezen of ze kloppen met wat jij weet (Light's Revocation).

## 🆕 21 okt — Healer-speluitleg rechtgezet

Eerst `/reload`.
- [vervallen, niet getest] Holy Paladin of Disc/Holy Priest ZONDER Improved Cleanse/Purify: het dispel-stuk ("Zo speel je" / Dispel) noemt
      alleen Magic. Met dat talent: Magic + Poison + Disease (Paladin) of Magic + Disease (Priest).
- [vervallen, niet getest] "How you play" Resto Druid: Swiftmend-regel noemt de twee talents; Efflorescence "3 hurt friends … each tick".
- [vervallen, niet getest] Holy Paladin stap 4: "Judgment … for Holy Power, then Shield of the Righteous up close … Mana back".
- [vervallen, niet getest] Disc Priest Voidweaver: "rift that follows the enemy … Smite becomes Void Blast … You may move".
- [vervallen, niet getest] Resto Shaman: dispel noemt alleen Magic, met Improved Purify Spirit ook Curse. "How you play": Lava Burst "(if you
      have that talent)", Stormstream "lasts a minute", Unleash Life ook voor Riptide, Healing Rain "whenever it is ready".

## 🆕 21 okt — This Week: solo-stand (delves voorop)

Eerst `/reload`, op een level-90.
- [vervallen, niet getest] This Week: bovenaan (onder de oranje nieuwsbanner) een blauwe regel "Mostly solo? Click here: …". Klik → regel
      wordt "Solo mode is on: …" en het scherm verandert meteen. Nog eens klikken → alles terug zoals eerst.
- [vervallen, niet getest] Met solo AAN: geen Mythic+, Raids, World Boss en groepsbuffs; de Great Vault staat over de hele breedte.
      In "Your week" geen Halduron (dungeon). Grijze regel zegt wat er verborgen is.
- [vervallen, niet getest] Direct onder "Your week": "Weekly chores" staat OPEN, met "Restored Coffer Keys: N · Coffer Key Shards: N",
      "Valeera: level N (click …)" (klik → haar venster) en een link naar Delves.
- [vervallen, niet getest] "Next up": heb je een Restored Coffer Key, dan staat er "You have N Restored Coffer Key(s): use one on a Bountiful
      delve …" met knop "Show delves" (→ Delves-tab). Staat je Great Vault klaar, dan blijft die bovenaan.
- [vervallen, niet getest] Instellingen → "I mostly play solo" staat gelijk met de regel bovenaan.
- [vervallen, niet getest] Op een laag character (bv. level 24): in "Your week" staat i.p.v. 12 losse regels één regel "Later, as you level:
      N weeklies (click to show)". Klik → de lijst verschijnt, regel zegt "(click to hide)". Blijft zo na `/reload`.
- [vervallen, niet getest] Onderaan This Week (solo aan én uit): na Ritual Sites / Void Assaults één dichte kop "+ Also handy (story, rares,
      mounts, tip)". Klik → campagne (Promise of Tomorrow), Rares, Mount wishlist, Collectible mounts en de tip
      verschijnen eronder. Nog eens klikken → weer dicht; blijft zo na `/reload`.

## 🆕 21 okt — Loa-Spirit Conduits (Labyrinth)

Eerst `/reload`.
- [vervallen, niet getest] Codex → Labyrinth-kaart, onder "Help along the way": de vier conduits (Wind, Earth, Fire, Mist) met wat elk doet,
      en een oranje regel "Since 20 October they no longer work in Kindo'jan's fight".
- [vervallen, niet getest] `/mh coach labyrinth` → Overview: regel "From Journey rank 6: four Loa-Spirit Conduits …".
- [x] ✅ GEMETEN Rob 23 okt (2 screenshots, Valeera's buffs vóór/na een conduit gelijk): Valeera krijgt de buff NIET.
      "Voor de hele groep" blijft weg; Codex zegt nu "gives you (not Valeera)".
- [vervallen, niet getest] Klik een conduit vlak vóór Kindo'jan: valt de buff weg zodra het gevecht begint?

## 🆕 21 okt — "Your keys": één ingang voor alles over toetsen

✅ Rob 21 okt: venster, knoppen 1-3, More/Less en `/mh mykeys` goed. ❌ → gerepareerd, opnieuw testen (eerst `/reload`):
- [x] ✅ Rob 21 okt: "De juiste key licht nu op". Klik op een spell in "Which spells do I press?" → de toets die IN DIE REGEL staat licht op (Rob 21 okt: eerst
      lichtte de plan-toets op, "een andere key"). Shift/Ctrl/Alt-toets → de toets zelf licht op. Numpad of geen toets →
      chatregel "<spell> is not on a key this keyboard shows".
- [x] ✅ Rob 21 okt: zoekbalk "keys" netjes.
- [x] ✅ Rob 21 okt: "mh coach labyrinth werkt". (`/mh coach blabla` → melding in chat: niet getest.)

Eerst `/reload`. Liefst op een level-90 én op een laag character.
- [x] ✅ Rob 21 okt. Tools-kamer: de EERSTE kaart heet "Your keys". Klik → klein venster met 3 grote knoppen en onder elke knop een
      zin. Venster sleepbaar, Shift+scroll maakt het groter/kleiner, kruisje sluit.
- [x] ✅ Rob 21 okt (knoppen 1-3 goed). Knop 1 "Set up my keys" → het toetsenblok-venster opent.
- [x] ✅ Rob 21 okt. Knop 2 "Which spells do I press?" → het presses-venster opent. (De gele "Counting is off"-regel niet
      apart gezien: tellen staat nu standaard aan.)
- [x] ✅ Rob 21 okt. Knop 3 "Show my keyboard" → een eigen venster met het hele toetsenbord, OOK op level 90.
- [vervallen, niet getest] Tools-launchpad: bovenste tegel "Your keys" met Open-knop. Zoekbalk: typ "keys" of "keybinds" → "Your keys: …".
      `/mh mykeys` opent het venster; `/mh keybinds` opent nog steeds de export.
- [x] ✅ Rob 21 okt (More/Less goed). Layout (in het venster van knop 3, en op een laag character ook in Leveling → Layout): onder het toetsenbord een
      knop "More: colours and filters". Kaarten staan direct eronder, zonder kleurenuitleg en filterknoppen. Klik →
      uitleg + 4 filterknoppen verschijnen, knop heet "Less". Na `/reload` blijft je keuze staan.
- [vervallen, niet getest] Iets dat over elkaar heen valt of buiten het venster loopt? Screenshot.
- [vervallen, niet getest] Tellen staat nu vanzelf AAN: op een character waar je het nooit aanzette, na een paar gevechten staat er iets
      in "Which spells do I press?", zonder gele "Counting is off"-regel. Uitzetten met de schakelaar blijft uit na `/reload`.
- [x] ✅ Rob 21 okt: klik → juiste toets licht op (zie bovenaan deze ronde); de tooltip zelf niet apart genoemd.
      In "Which spells do I press?": muis op een spellregel → tooltip "Click: show this spell on your keyboard".
      Klik → het toetsenbordvenster opent met één toets opgelicht (die van MH's layout), en scrolt ernaartoe.

## 🆕 21 okt — Kindo'jan: Claws of the Empire + Mojo-wegslag

Eerst `/reload`. Delve-coach → Labyrinth → Boss-deel (of het End boss-venster van Kindo'jan):
- [x] ✅ Rob 21 okt (screenshot, in de Labyrinth): de Claws-regel staat er. Slotzin daarna rechtgezet ("a knockback off
      the platform and the bears did" i.p.v. "the ground effects did") → na `/reload` even nakijken.
- [vervallen, niet getest] Bij Eruption of Mojo: "the edge is a good spot, but not close to Kindo'jan. There a hit from Kindo'jan himself
      threw us off the platform …, not the circle". (Rob 21 okt: als tank aan de rand vlak bij de baas, zijn klap.)
- [vervallen, niet getest] Bij je volgende Kindo'jan: klopt het dat Claws je niet echt pijn doet? Slaan ook de gewone grondcirkels je weg?
- [vervallen, niet getest] **Kindo'jan-venster vanzelf:** loop na de laatste kamer naar Kindo'jan. Zodra de tracker "Enemy of the Labyrinth"
      zegt (Den'zara), opent rechts vanzelf "End boss: Kindo'jan" met het hele Boss-deel. Sluit je hem, dan komt hij bij
      "Soul of the Labyrinth" (Kindo'jan zelf) nog één keer terug. Boekje op de markeerbalk → ook dit venster.
      Opent hij niet? `/mh roomcard why` → screenshot.
- [vervallen, niet getest] Op een Duitse/Franse/… client (of Cisca): staat de Claws-regel er ook, in die taal?

## 🆕 20 okt (laat) — Flooded Chamber: ingang onder water in de kistenroute

Eerst `/reload`. In de Labyrinth, als alleen de 5 Flooded Chamber-kistjes over zijn (of je ze als eerste krijgt):
- [x] ✅ Rob 20 okt (paladin): alle kistjes gehaald; de ingang zit inderdaad onder water; met de Fiery Hexmask door het ijs.
      Vuurspells NIET getest (paladin heeft er geen) → nog op een mage/shaman proberen.
- [vervallen, niet getest] (rest) Klik Chests → het pijltje wijst naar "Underwater entrance (Flooded Chamber)" bij ongeveer 56.9, 44.1, en de melding
      zegt: onder water, ijsmuur, Fiery Hexmask OF eigen vuurspells. Ligt de ingang echt daar? (bron: HandyNotes)
- [vervallen, niet getest] Bij de ingang (binnen ~1 kaarteenheid) of verder: melding "You are at the underwater entrance …" en het pijltje
      springt naar het kistje.
- [x] ✅ Rob 21 okt (Elemental Shaman): het ijs ging weg door het aan te vallen, zonder Hexmask. Welke spell: zie de
      Flooded Chamber-test bij "Labyrinth: het touw".

## 🆕 20 okt (avond) — markeerbalk: 2 gelijke rijen + Labyrinth-knop

Eerst `/reload`.
- [x] ✅ Rob 20 okt (screenshot, in de Labyrinth): 2 rijen van 12, boekje rechtsonder zichtbaar.
- [vervallen, niet getest] (rest) Bovenste rij: 8 grondmarkeringen + wissen + ready check + rollen-check + klok (12). Onderste rij: 8 doelmarkeringen
      + wissen + rol + vrienden + boekje (12). Beide rijen even lang, niets valt buiten de balk.
- [x] ✅ Rob 21 okt: "het boekje op de markeerbalk werkt". Het boekje staat er ALLEEN in de Labyrinth. Linksklik → het kaartje van deze kamer (herkent MH hem niet → de
      bazenlijst). Rechtsklik → altijd de bazenlijst. Tooltip zegt dat.
- [vervallen, niet getest] Ready check / rollen-check / klok werken nog zoals eerst (alleen als leider/assist).

## 🆕 20 okt (avond) — kamerkaart (Labyrinth)

Eerst `/reload`.
- [x] ✅ Rob 20 okt: na `/reload` IN een kamer opende de kamerkaart meteen ("dus dat werkt") → de taaknaam is leesbaar
      (GEMETEN). Nog te zien: bij het binnenlopen van een volgende kamer.
- [x] ✅ Rob 20 okt: na het toevoegen van "Soul Survivor" + `/reload` in die kamer: "ja hij doet het".
- [x] ✅ Rob 21 okt: "hij opent automatisch die kamer kaart". Loop een nieuwe kamer binnen → het kleine venster opent vanzelf met "Room: <taak>" (bv. "Room: Fools and Curses":
      relic raiders, 5 Cursed Energy naar de sarcofaag, plus de Pit Boss-tip).
- [vervallen, niet getest] Opent hij niet? Typ `/mh roomcard why` en stuur een screenshot: "scenario texts" is wat MH van het spel leest.
- [vervallen, niet getest] In een kamer met een taak die MH nog niet bij naam kent (Hexbound Defenders, Head ritualists, Ritual items, Golden
      lever, Trial gates): `/mh roomcard why` → de echte naam staat bij "scenario texts" → dan voegen wij hem toe.
- [vervallen, niet getest] `/mh roomcard fools` → het venster voor Fools and Curses, ook buiten de delve.

## 🆕 20 okt (avond) — venster per kamerbaas (Labyrinth)

Eerst `/reload`. Kan ook buiten de delve: `/mh bosscard 5` toont het venster van Sha'Kuro.

- [x] ✅ Rob 20 okt (screenshot): `/mh bosscard 5` → venster "Room boss: Sha'Kuro" met 4 regels, knop, schuifbalk.
      Daarna: zijn eigen regel ("Sha'Kuro: …") staat nu BOVENAAN, de kamertaken eronder → na `/reload` nakijken.
- [x] ⚠️ Rob 20 okt, voor Cynthra: target opent het venster NIET (verwacht: naam/GUID zijn secret in een delve, 16 aug).
- [x] ✅ Rob 20 okt (screenshot): lijstvenster met 19 knoppen in 2 kolommen. ⚠️ Kindo'jan NIET oranje (kleurcode in de
      knoptekst wordt overschreven); laten zo tenzij Rob anders wil.
- [vervallen, niet getest] (rest) `/mh bosscard` → lijstvenster; klik → dat bazenvenster. `/mh bosscard cynthra`
      → meteen haar venster. Zoekbalk "Cynthra" → klein venster. Knop "All bosses" in elk bazenvenster.
- [vervallen, niet getest] Begint het gevecht met een kamerbaas: opent het venster dan wel vanzelf? (`ns.db.delveRoomBossLog` in de SV)
- [vervallen, niet getest] `/mh bosscard why`: een lijst van 19 bazen, elk met "N line(s)" in groen (geen rode 0).
- [vervallen, niet getest] In de Labyrinth: target een kamerbaas (of begin het gevecht) → rechts een klein venster "Room boss: <naam>" met
      ALLEEN zijn tips. Kindo'jan: "End boss: Kindo'jan" met het hele Boss-deel (scrollen). Knop "Open the delve
      coach" werkt. Gewonnen → venster gaat vanzelf dicht. Shift+scroll maakt het groter/kleiner, slepen kan.
- [vervallen, niet getest] Instellingen → "A small window per room boss" uit → weer de oude knop van 5 seconden.

## 🆕 20 okt (middag) — "In the game now" (spelnieuws)

Eerst `/reload`.

- [x] ✅ Rob 20 okt: blok staat er, maar "valt helemaal niet op" → nu een oranje banner HELEMAAL bovenaan (vóór Next up).
- [x] ✅ Rob 20 okt (screenshot): oranje banner bovenaan This Week, grote kop, 3 meldingen, "8 day(s) left".
- [x] ✅ Rob 20 okt (screenshot, level 22): oranje "News (1)" links naast Classic — "die ziet er dus goed uit".
- [x] ✅ Rob 20 okt (screenshot): na klikken op level 22, op een level-90 weer oranje "News (3)" — "ja dat gaat goed".
- [vervallen, niet getest] Na `/reload` op een level-90: News weer oranje (Fabled-melding is nieuw), en de Fabled-regel noemt nu de mount
      Loa-Blessed Wayfarer "until the end of Season 2". Mounts → Loa-Blessed Wayfarer: uitleg met kist, Season 2, Kinduru.
- [vervallen, niet getest] Klik op News → de knop wordt rustig (gewone paarse knop, iets doorzichtig), ook na `/reload` en op een ander
      character. `/mh news` zegt "(seen)" achter elke melding. `/mh news reset` → weer oranje.
- [vervallen, niet getest] (oud) Bovenin het venster, links naast Classic: een oranje knop "News (3)". Muis erop → de drie meldingen in een
      tooltip. Klik → This Week opent met de banner bovenaan. Schakelaar uit in de instellingen → knop weg.
      Klik Classic → knop blijft oranje (Blizzard-knop). Verdwijnt hij als er geen meldingen meer zijn?
- [vervallen, niet getest] Delve-coach Kindo'jan, Boss-deel: Akil'zon "After every gust the dark and light slices swap places"; Nalorakk "two
      walls of bears come from opposite edges … turn around"; Juggernaut "a fifth enemy … Phalanx Charge". Codex →
      Labyrinth-kaart: Crushing Blow "(go to the middle of the platform …)".
- [vervallen, niet getest] Delve-coach / Codex bij Kindo'jan, Halazzi-stuk: "All four aim a white line at Valeera, but only one moves …".
- [vervallen, niet getest] (oud) This Week: helemaal bovenaan een oranje banner "In the game now" (grotere kop, witte tekst, oranje streep) met drie regels: Fabled Kindo'jan ("… N day(s) left"), de
      Voidcore-bug en Valeera. Op een character onder 90 alleen de Valeera-regel.
- [vervallen, niet getest] `/mh news`: per melding "shown" of "hidden" met de reden en de einddatum (Fabled EU: wo 28 okt 03:00 UTC).
- [vervallen, niet getest] Instellingen → "In the game now" uit → het blokje verdwijnt; weer aan → terug.
- [vervallen, niet getest] Na wo 28 okt: de Fabled-regel is vanzelf weg.

## 🆕 20 okt (middag) — Vaeli's housing-weekly

Eerst `/reload`. Op een level-90.

- [vervallen, niet getest] Your week: een regel "Weekly (Vaeli): a housing quest by the bank …" met 20 Hero / 40 Champion / 60 Veteran. Klik → de
      pijl gaat naar Vaeli bij de bank in Silvermoon (49.6, 66.0). Staat ze daar echt?
- [vervallen, niet getest] Neem haar quest aan → de regel wordt "in your log". Klaar en ingeleverd → groen "done".
- [vervallen, niet getest] `/mh weeklies`: een blok "Housing weekly (Vaeli, once per account)" met de vier quests en achter elke quest
      `account:true/false`. 🔴 Belangrijk om te meten: deed een ander character hem deze week, wat zegt dat blok dan op
      een alt? (dan weten we of MH "al gedaan op je account" kan zeggen)
- [vervallen, niet getest] `/mh gear` (level 90, iets kan nog omhoog): onderaan stap 1 de regel "Extra crests every week: Vaeli …".
- [vervallen, niet getest] In een andere taal (als je die client hebt): de/fr/es/pt/it/ru-teksten, en "… of the Mist", Avventuriero, Mythos.

## 🆕 20 okt — ochtend

Eerst `/reload`.

- [vervallen, niet getest] Codex → Currencies → Nebulous Voidcore: onderaan een oranje regel "Right now (Oct 2026): a known Blizzard bug …".
- [vervallen, niet getest] `/mh raidbots` naast de export van de SimulationCraft-addon zelf (`/simc`): is de `talents=`-regel gelijk?
- [vervallen, niet getest] Codex → Coiled Isle → "Corrosive Codex — which gift do I take first?": het stuk "two kinds of poison" (you /
      the enemy) en het voorbeeld Lithic Plumage + Insidious Venom.
- [vervallen, niet getest] Delve-coach in de Labyrinth, Rooms-deel: taaknamen (Graverobbers, Reigns of the Warlord …), Grukk "locks that spell
      school for about 4 seconds", een regel over The Undead Trollbunal. Boss-deel: Den'zara "about 15 seconds … about 40
      seconds before you can attack him", "Shadow of Halazzi".
- [vervallen, niet getest] Codex → Labyrinth-kaart (bij Kindo'jan) en de delve-coach in de Labyrinth (Boss-deel): oranje regel "Fabled, only
      until the week of 27 October …". Na 28 okt moet hij weer weg.

## 🆕 19 okt (laat) — Mijn gear rekent de korting zelf uit

Eerst `/reload`. Op Umbrion (Adventurer of the Mist = true, trinket-watermark 269 / account 308).

- [x] ✅ Rob 19 okt, Umbrion: MH "Adventurer … 11 at half price, You can do 5 steps" (54 crests); Cuzolth: Cosmic Bell
      2/6 → 6/6 = **40** crests (4 × 10) — klopt. Champion 4 crests → "need 6 more" (10 per stap) klopt. ✅ Na uitgeven
      ging het venster vanzelf naar 4 crests (Rob).
      ✅ Rob 19 okt, tweede bewijs: Hex Loop Veteran 2/6 → 5/6 = 30 crests (3 × 10); MH vooraf "Veteran 30 crests, You can
      do 3 steps right now!". Daarna zonder verversen "Finger 5/6, 0 crests, need 10 more" = Blizzards volgende stap (10).
- [vervallen, niet getest] `/mh gear` **zonder** eerst bij Cuzolth te zijn: bij Adventurer staat **geen** "at least" meer, maar
      "You can do N steps right now!", met eronder "Your discounts here: X steps free, Y at half price." De trinket-
      stappen 2/6 → 6/6 horen half price (10) te zijn.
- [vervallen, niet getest] Onderaan staat de uitleg "The prices above include your discounts …".
- [vervallen, niet getest] Vergelijk met Cuzolths venster voor één ander item: klopt de prijs (20, 10 of 0)? Een gratis stap (0) is nog
      nooit in het spel gezien — als je er een tegenkomt: screenshot.
- [vervallen, niet getest] Op een character zonder de prestatie: alles 20, behalve waar dat character zelf al hoger zat (gratis).

## 🆕 19 okt (laat) — mounts uit de Mount run in de zoekbalk

Eerst `/reload`.

- [vervallen, niet getest] Typ in de zoekbalk "Black Drake" → een rij "Black Drake" met "The Obsidian Sanctum" ernaast. Klik → het Mount
      run-venster opent op het tabblad Evening 1 (Northrend) en het pijltje gaat naar de ingang.
- [vervallen, niet getest] Ook "Invincible", "Mimiron", "Ashes" (Al'ar) en een dungeon-mount vinden.
- [vervallen, niet getest] Staat het Mount run-venster al open, dan blijft het open (klik sluit het niet).

## 🆕 19 okt (laat) — Mijn gear: echte prijs + waar elke crest vandaan komt

Eerst `/reload`.

- [vervallen, niet getest] `/mh gear` zonder bij Cuzolth te zijn geweest: onder elke soort met open stappen een blauwe regel "Get these crests
      from: …" (de tekst van het spel). Groen staat er nu "at least N steps", en onderaan "A step costs 20 crests, often
      less…".
- [vervallen, niet getest] Ga naar Cuzolth, leg één item (bv. je Veteran-handschoenen) in zijn venster. Kijk of de prijs groen is, en ga erop
      staan: welke reden geeft het spel? (Dat zegt ons of jouw 10 een korting was.)
- [vervallen, niet getest] Laat `/mh gear` open terwijl je dat doet → de telling voor die soort past zich aan aan de echte prijs.
      ✅ Rob 19 okt, twee screenshots: Serpentine Talisman Hero 2/6→3/6 kost **20** crests + 40 goud; Rob heeft 0 →
      MH's "You need 20 more crests for the next Hero step" klopt. (De bouwchat las op de eerste screenshot ten onrechte
      "0" — een tooltip lag over de rode 20 — en bouwde een "gratis stap"-regel; die is teruggedraaid.)
      ✅ Rob 19 okt (Umbrion, Shadow Priest): Cosmic Bell Adventurer 2/6→3/6 = **10** (groen). GEMETEN in
      SavedVariables: `lastNPCRead` cost 10, discounted true, currUpgrade 2 = curFromLink 2, 1 currency row; het venster
      telde 10+20+20 ≤ 54 → "at least 3 steps" (zonder geleerde prijs 2). trackKey geleerd: 971 adventurer, 972 veteran,
      973 champion, 974 hero. Reden van de korting nog niet gelezen → MH slaat nu ook `accountWide`/`watermark`/
      `thisCharacter` op; volgende keer: ga op het groene getal zelf staan (niet op het crest-icoon).
      ✅ Rob 19 okt: blauwe "Get these crests from: …"-regel staat er (Hero), "at least"-uitleg onderaan staat er.
- [vervallen, niet getest] Na de upgrade: klopt de nieuwe stand (bv. 3/6)?

## 🆕 19 okt (avond) — "Mijn gear: wat nu?" voor beginners (Carola)

Eerst `/reload`. Liefst ook op een character met crests en items die nog omhoog kunnen.

- [vervallen, niet getest] **`/mh gear`** (of karakterscherm C → zijpaneel → "My gear: what now?") opent een venster:
      je item level; per soort item (Champion, Hero …) hoeveel items, hoeveel stappen nog open en hoeveel crests je hebt;
      groen "You can do N steps right now!" als je genoeg crests hebt; een grijze regel met de slots (bv. "Head 2/6").
      Klopt het aantal crests met je Currency-tabblad? Klopt "2/6" met de tooltip van het item?
      ✅ Rob 19 okt, screenshot: venster opent zonder fouten (ilvl 285, 4 soorten, slots kloppen in beeld). Twee
      foutjes gerepareerd: vierkantje i.p.v. "→" in de voetregel (nu "Codex > Start Here > …"), en bij gelijkspel
      (4 Adventurer / 4 Champion) koos "2." de lagere soort — nu de hogere (Hero). Opnieuw kijken na `/reload`.
      De Codex-kaart is geen eigen tegel: hij staat ín de tegel **Start Here**.
- [vervallen, niet getest] Onder "2." staat de tekst van het spel zelf over waar de volgende soort crest vandaan komt.
- [vervallen, niet getest] Wissel een item of upgrade er een → het venster past zich vanzelf aan.
- [vervallen, niet getest] **Codex** → zoek "gear" of "crest" → kaart "Why does my gear not go up? In small steps", met 6 stappen.
- [vervallen, niet getest] Laat Carola het lezen. Snapt ze het? Wat mist ze?

## 🆕 19 okt (avond) — hulp bij Hexmasks en kist 14

Eerst `/reload`. In de Labyrinth (Journey-rang 2 of hoger).

- [vervallen, niet getest] **Maskerkamer-hint.** Loop een van deze kamers in: Chamber of Rites, The Cave Towers, Akil'zon's Roost, Jan'alai's
      Refuge, Nalorakk's Rest. Je krijgt één regel in beeld én in chat: "… is one of the five Hexmask spots …". Per
      kamer één keer per run. Andere kamers: niets.
- [vervallen, niet getest] **`/mh hexmask`** in zo'n kamer → pijltje op de plek in die kamer. In een andere kamer → de dichtstbijzijnde van de
      vijf. Buiten de Labyrinth → een lijstje van de vijf. Onderaan een grijze regel met rang/kamer/beslissing.
- [vervallen, niet getest] **Zoekbalk:** typ "hexmask" (of "locked door", "keeper") → vijf rijen met de kamernamen; klik → pijltje.
- [vervallen, niet getest] **Kistenroute:** de vijf Flooded Chamber-kisten (#3 #11 #12 #14 #25) komen nu als **laatste**. Wijst het pijltje
      er toch naar, dan staat in beeld de uitleg over de ijsmuur en de Fiery Hexmask.
- [vervallen, niet getest] Instellingen → "Labyrinth: tell me when a room has a Hexmask spot" uit → geen hint meer.

## 🆕 19 okt (middag) — vier fouten uit de Labyrinth-video

Eerst `/reload`. Alles in de Labyrinth.

- [vervallen, niet getest] **Kamerbaas-knop.** Begint een kamerbaas (bv. Sha'Kuro, Grukk) → klik "Room boss: … — show tips?". De Coach gaat open
      met **"Rooms" bovenaan** (alleen de regels van die baas + de algemene), niet met "Overview". Bij Kindo'jan zegt de
      knop **"End boss: Kindo'jan — show tips?"** en staat het **Boss-deel** bovenaan.
- [vervallen, niet getest] **Kistenknop.** Klik op Chests tot alle kisten die over zijn overgeslagen zijn. Je krijgt dan één melding (in beeld
      en in chat) dat de route stopt. Liggen ze allemaal in de Flooded Chamber, dan noemt de melding de ijsmuur en de
      Fiery Hexmask. Nog één klik → de route begint opnieuw. Geen eindeloos "Skipped Sturdy Chest 11" meer.
- [vervallen, niet getest] **Gear check** (karakterscherm): met één lege socket staat er "1 empty socket" (enkelvoud).
- [vervallen, niet getest] **Kindo'jan-tip** (Coach, Boss-deel): "Phase 1, the first 90 seconds or so" en "After about 90 seconds (a timer, not
      his health)…". Zet bij je volgende Kindo'jan `/combatlog` aan, dan meet ik het precieze moment.
- [vervallen, niet getest] **Valeera-venster, Poisons:** in plaats van "No recommendation" staat er "Bursting Toad Toxin — Guides: the top poison
      for Kindo'jan…". Heb je hem zelf aan, dan is de regel eronder groen.

## 🆕 19 okt — Codex-advies, it/de-spelnamen

Eerst `/reload`.

- [vervallen, niet getest] **Corrosive Codex-advies.** Open de Codex (bij een Altar of Corrosion of aan het begin van een delve). Rechts
      naast het venster hoort een kaartje: "Corrosive Codex — what to pick", met "You have:" en je twee gifts in groen,
      vijf situaties met gifts (een ✓ achter wat je hebt) en een voetregel. Heb je Insidious Venom zonder Ula'tek's
      Gift of Ouroboric Cycle, dan staat er een oranje regel dat hij niets extra doet. Sluit de Codex → kaartje weg.
- [vervallen, niet getest] 🔴 In de run van 19 okt zei het kaartje "no gift picked yet" terwijl er twee vinkjes stonden (video A 09:04, D
      10:28). Gerepareerd in code: kies met de Codex open een andere gift → binnen een halve seconde moet "You have:" mee
      veranderen. Daarna `/mh gifts` + `/reload`, dan lees ik `codexAdvice.lastDump` uit (welk signaal klopte).
- [vervallen, niet getest] `/mh gifts` met de Codex open: twaalf regels 13–24 met namen, "(have)" bij jouw twee. Zonder Codex: "no choice open".
- [vervallen, niet getest] Instellingen → "Advice beside the Corrosive Codex" uit → Codex openen → geen kaartje.
- [vervallen, niet getest] (alleen met een Italiaanse of Duitse client, dus niet voor Rob) "Siti Rituali/Fama/Reperto" en "Ritualstätten/
      Ruhm/Kuriosität" in plaats van de Engelse woorden.

## 🆕 17 okt — Ritual site op nummer, GUID-patroon

Eerst `/reload`. Twee kleine dingen uit de ochtendronde (HandyNotes 161 en de 12.1.7-API-pagina).

- [x] ✅ Rob 17 okt 08:18, screenshot: de /run gaf precies één regel, `2437 8614` → Broken Throne is open, en
      het POI-nummer klopt (GEMETEN). ✅ Rob 19 okt, screenshot Void & Rituals: "Active this week: Broken Throne —
      Zul'Aman" en de knop "Broken Throne — Zul'Aman [Active]".
      **Welke ritual site is actief?** Typ in de chat:
      `/run for _,m in ipairs({2395,2437}) do for _,p in ipairs(C_AreaPoiInfo.GetAreaPOIForMap(m) or {}) do if p==8614 or p==8615 then print(m,p) end end end`
      Je hoort **één** regel te zien: `2395 8615` (Daggerspine Point) of `2437 8614` (Broken Throne). Open daarna `/mh`
      → tegel **Void & Rituals** (het oude "Home" bestaat niet meer): de ritual-regel noemt **dezelfde** site, niet "rouleert wekelijks". Twee regels of geen regel → zeg het,
      dan klopt de aanname van HandyNotes niet (alleen de open site heeft een pin).
- [vervallen, niet getest] **Weekly-gevers herkennen (ResetRoutine).** Niets te zien als het goed gaat: praat met een weekly-gever in
      Silvermoon zoals altijd, en de This Week-lijst hoort hem net zo te herkennen als gisteren. Alleen het patroon dat
      het NPC-nummer uit de GUID leest is ruimer gemaakt, voor 12.1.7. Buiten het spel getest op 5 voorbeelden (alle 5 goed).
      Hetzelfde patroon zit nu ook in de kistenregistratie (DelveChestData), EncounterCapture en SpotLog — ook daar
      hoort niets te veranderen.
- [x] ✅ Rob 17 okt, screenshots: "one of 41 spots (HandyNotes + Wowhead)", nummers 1-41; klik op 16 → TomTom
      "Added a waypoint (16 - 43.66, 83.98) in The Labyrinth of Kindo'jan". 🐞 Vanuit Silvermoon zei MH daarna óók
      "16 is not on this continent" en de pijl "(other continent — travel back)" — fout, de Labyrinth ligt in Eversong.
- [x] ✅ Rob 17 okt, screenshot vanuit Silvermoon: "Route, step 1 of 2: The Labyrinth of Kindo'jan", TomTom-pin op
      Eversong 62.90/72.00, geen "not on this continent" meer; Rob: *"ik krijg keurig een pijl"*.
      **Pijl naar de Labyrinth-ingang (repareert de 🐞 hierboven).** `/reload`, ga in **Silvermoon** staan, Codex →
      Labyrinth → klik op **16**. Je hoort GEEN "not on this continent" meer te zien. Onze pijl wijst naar de ingang in
      Eversong (62.90/72.00) met als naam "The Labyrinth of Kindo'jan". Ga naar binnen: de pijl wijst dan naar 16 zelf.
      (Gebruik je TomTom, dan kan TomTom's pijl het overnemen zodra je binnen bent.) Zie je toch "other continent" →
      screenshot + `/mh arrow`.
      **Mislaid Treasures: 41 plekken.** `/mh` → Codex → The Labyrinth of Kindo'jan → kopje Mislaid Treasures. Je hoort
      "one of **41** spots" te zien en de nummers 1 t/m 41. Klik op **16**: de pijl wijst naar 43.66/83.98 (vlak bij
      Wah'du). Kom je in de Labyrinth een Mislaid Treasure tegen op een plek die NIET in de lijst staat → zeg het.

## 🆕 19 okt — Locked Door in de Labyrinth

⚠️ Bijgewerkt 19 okt (2 mh-research-rondes): de vijf plekken zijn gedeeld — elke run drie Hexmasks, de deur en één lege
plek, willekeurig. De links heten nu naar de kamer (Chamber of Rites, The Cave Towers, Akil'zon's Roost, Jan'alai's
Refuge, Nalorakk's Rest). Klopt het in het spel (een masker of de deur op een van die vijf, wisselend per run)? Zeg het.
- [vervallen, niet getest] Codex → "The Labyrinth's own Journey" → Rank 2: vijf genummerde links naar de deur op slot. Klik er één in de
      Labyrinth: de pijl hoort erheen te wijzen. Vind je de deur op een plek die niet in de lijst staat → zeg het.

## 🆕 18 okt — Routezoeker naar plekken buiten Midnight (TravelGraph.lua)

Uit de cloud-chat (docs/HANDOFF_2026-10-18_TRAVELGRAPH.md). Eerst `/reload`.

- [x] ✅ Rob 19 okt: *"7 gaat goed"* (eerste in-game test van de routezoeker).
      In Silvermoon: Dungeons-tab → **Algeth'ar Academy** → route. De pijl hoort naar de portal room te wijzen (→ Orgrimmar
      → Valdrakken), NIET naar de vluchtmeester in Silvermoon.
- [vervallen, niet getest] `/mh plan` op **Pit of Saron**: 3 stappen en een regel "About N min by the fastest way".
      🐞 Rob 19 okt, screenshot: de route zelf klopte ("Route, step 1 of 3: Go to the portal room …"), maar `/mh plan` zei
      "Nothing to plan — it is on the map you are standing on". Oorzaak (GEMETEN in Core.lua): `/mh plan` plande naar
      `ns.lastTarget`, en tijdens een route is dat de HUIDIGE stap (de portal room). Nu: loopt er een route, dan plant hij
      naar haar einddoel. Opnieuw testen: `/reload`, route naar Pit of Saron starten, dan `/mh plan`.
      ✅ Rob 19 okt na de reparatie, screenshot: "How to reach Pit of Saron, step by step: About 1 min by the fastest way
      (an estimate; 52 places compared). 1. Portal: portal room → Orgrimmar 2. Portal: Dalaran 3. Arrive at: Pit of
      Saron". ⚠️ "1 min" is te optimistisch voor die tocht (de kosten zijn GEKOZEN, niet gemeten) — de route klopt.
- [x] ✅ Rob 19 okt: *"11 en 12 werken oke"*.
      In Orgrimmar: zet een pin in **Mount Hyjal** → de pijl hoort naar het Hyjal-portaal te wijzen, niet "fly to Nordrassil".
- [x] ✅ Rob 19 okt (zie hierboven), screenshot: Valdrakken → The Coiled Isle, popup "HS on Cooldown! Take the portal
      to Orgrimmar.", pin op 56.6/38.3, pijl 25 m — de oude WayHome-route, ongewijzigd.
      Een Midnight-delve vanuit Valdrakken: gedrag zoals altijd (Hearthstone/portaal naar Silvermoon).
- [vervallen, niet getest] Silvermoon → een doel in Eversong met een vluchtmeester ertussen: hoort er nog steeds een vluchtmeester-stap te
      geven (zoals 17 okt). Zo niet → zeg het (dan raakte de nieuwe continent-regel toch Midnight).
- [x] ✅ Rob 19 okt: *"13 is oke"* — geen FPS-daling met onze pijl naar een ander continent (de 3 s-cache werkt).
      FPS: volg een route naar een plek op een ander continent met onze pijl in beeld. Je FPS hoort niet te zakken.

## 🆕 18 okt — Curio-advies: ster voor elke rang, "wanneer", nieuwe curios

Eerst `/reload`, open Valeera's venster één keer.

- [x] ✅ Rob 19 okt, /mh curios geplakt: ster op Corrosive Bilespear, Dundun's Favor én Soul-Cracking Dreamcatcher, elk
      met hun "Guides:"-regel. Dreamcatcher-tekst "25% … for 60 sec, stacking up to 2 times" = **rang 5** (wago) → de
      ster werkt op rang 5 (GEMETEN). Geen "Recommended elsewhere"-regel. Viperwind "Players:" + ">>", Dusty Loa ">>".
      Typ `/mh curios`. **Bilespear** hoort een ster te hebben, wélke rang je ook hebt (ook rang 5). Bij Utility horen
      **Dreamcatcher én Dundun's Favor** een ster te hebben, met eronder een regel "Guides: …" die zegt wanneer.
- [x] ✅ zie hierboven. Onderaan hoort GEEN regel "Recommended elsewhere but NOT in your companion's tree" te staan.
- [x] ✅ zie hierboven. Heb je **Viperwind Idol** of **Dusty Loa Totem**? Dan hoort er een regel ">> …" onder te staan.
- [x] ✅ Rob 19 okt, screenshot: bij Utility twee regels "Guides pick: … — Guides: …", en "You have this one." onder
      Dundun's Favor (zijn actieve curio). Het kleine paneel naast Valeera's venster.
- [x] ✅ Rob 19 okt, screenshots: Corrosive Codex (Venom Infusion, altaar, Kindo'jan-duo), Labyrinth (rang 5-curio in
      de kist), Journey rang 2 (vijf deur-links), Valeera & delve curios ("klopt"). Rob vroeg: *"je mag toch op een
      moment 2 tegelijk kiezen?"* — ja; de kop zei "one of them" → kop aangepast (tweede vak na 8 gifts).
      Codex → Delve curios / Corrosive Codex / Labyrinth: de nieuwe regels over rang 5, Venom Infusion en Kindo'jan.

## 🆕 17 okt — Kindo'jan-tip herschreven (twee videogidsen)

- [vervallen, niet getest] Delve Coach → The Labyrinth of Kindo'jan → baas-tip. Hoort te zeggen: tussenfase **op 70% health** (niet meer
      "1:30"), de zakjes oppakken, de oranje melding over Valeera's extra schade (18 okt), de opstelling (curios/poison/Codex), de Juggernaut met platform achter je, donkere
      vloerstukken bij de wind, één kat die beweegt, en bij de twee cirkels: **neem de cirkel die Valeera NIET markeert**.
      Klopt iets niet met wat je in het gevecht ziet → zeg welk stuk.

## 🆕 17 okt — Sha'Kuro: na de laatste Soul even verdoofd

- [vervallen, niet getest] In de Labyrinth, kamer met **Sha'Kuro**: dood alle Unfortunate Souls tijdens zijn Soul Storm. Je hoort te zien dat de
      storm stopt en Sha'Kuro even stilstaat (verdoofd). Hoe lang? Dat weet geen enkele bron — tel het als je kunt.
      De tip in de Delve Coach zegt het nu ook ("Killing the last Soul stops the storm and stuns him for a moment").

## 🆕 17 okt — Delve Log: een Labyrinth-run = één run

Rob: de Delve Log zei "17 runs" na twee avonden (= 17 kamers). Eerst `/reload`.

- [x] ✅ Rob 19 okt, screenshot: "Runs: 2", T11 2h 11m Rooms: 8 (16 okt) en T11 2h 14m Rooms: 9 Sha'Kuro (15 okt).
      Open de **Delve & Ritual Log**. De Labyrinth hoort nu **2 runs** te tonen: 15 okt met "Rooms: 9" en 16 okt met
      "Rooms: 8" (buiten het spel getest op jouw echte gegevens: 17 → 2).
- [vervallen, niet getest] Doe een paar kamers en **verlaat** de Labyrinth. Daarna hoort er één nieuwe run bij te komen met het aantal kamers,
      niet één per kamer. (Tussen de kamers telt hij niets — de run wordt pas geteld als je naar buiten gaat.)

## 🆕 17 okt — Zoekbalk: "take me there" voor delves, dungeons en raids

Rob: *"niet even een snelle knop … naar de labyrinth zelf, maar ook niet naar andere delves dungeons of raids"*.
Eerst `/reload`.

- [x] ✅ Rob 17 okt: *"ja werkt"*.
      `/mh` → typ `laby` in de zoekbalk. Bovenaan hoort **"The Labyrinth of Kindo'jan"** te staan met grijs erachter
      **"Eversong Woods — take me there"**. Klik: de route start (zoals de knop op het Delves-tabblad).
- [x] ✅ Rob 19 okt, screenshots: "Maisara Caverns  Zul'Aman — take me there" en "The Voidspire  Voidstorm — take me
      there" bovenaan, de bazen eronder. (Op de klik zelf nog niet getest.)
      Typ een dungeon (bv. `maisara`) en een raid (bv. `voidspire`): ook daar een regel "… — take me there", en de
      klik zet de route naar de ingang. De bazen en de Delve Coach staan er gewoon nog onder.

## 🆕 17 okt — Vluchtmeester in routes: loslaten + schakelaar

Rob: *"blijft de pijl eigenwijs naar de FP wijzen"* en *"hou er wel rekening mee, dat users en ik soms eerst naar een fp
moet vliegen"*. Eerst `/reload`.

- [x] ✅ Rob 17 okt: *"gedaan, incl een rare onderweg 🙂 en alles ging goed"*. Log 08:43:13 "step 1/2 fly: Flight
      master: Sanctum of Light" → 08:44:06 "flight master let go (nearer the target …): 123 yd to it, 2956 yd to the
      target, it is 2973 yd from the target" → rare-omweg Cre'van → verder naar de Labyrinth. Marge daarna op 150 yd gezet
      (was 17 yd verschil — te vroeg voor wie van de doelkant naar de vluchtmeester vliegt); dat stukje is niet opnieuw getest.
      **Loslaten.** Zet een route die een vluchtmeester voorstelt (de pijl zegt "fly from …"). Vlieg er NIET heen maar
      rechtstreeks naar je doel. Zodra je dichter bij je doel bent dan die vluchtmeester (of duidelijk van hem
      wegvliegt, richting je doel), hoort de pijl naar je doel te springen. Doe daarna `/reload`: dan lees ik in het
      routelog "flight master let go (…)".
- [vervallen, niet getest] **Niet te vroeg.** Vlieg wél eerst naar de vluchtmeester: de pijl hoort op hem te blijven wijzen tot je instapt.
- [x] ✅ Rob 17 okt: *"schakelaar werkt"*.
      **Schakelaar.** Esc → Options → AddOns → Midnight Helper: **"Routes without flight masters"** (staat uit). Zet hem
      aan en zet dezelfde route: geen vluchtmeester meer, de pijl wijst meteen naar je doel.

## 🆕 16 okt (nacht) — Plekken zoeken in de zoekbalk (Dalaran enz.)

Rob: *"kunnen we niet ook zoeken in MH naar bv dalaran …"*. Eerst `/reload`.

- [x] ✅ Rob 16 okt, screenshot: `dala` toont "Dalaran  Northrend — take me there". Toen stond "Dazar'alor" er twee
      keer (kaart 1163 + 1165, zelfde naam) → nu één regel per naam + werelddeel. ✅ Rob 16 okt, screenshot na /reload: `daza` → één regel "Dazar'alor  Zandalar".
- [vervallen, niet getest] **Zoeken.** `/mh` → typ `dala` in de zoekbalk. Je hoort een regel **"Dalaran"** te zien met grijs erachter
      **"Northrend — take me there"**. Ook `@place` (alle plekken, ~31) en bv. `shatt`, `oribos`, `valdrakken`, `tanaan`.
- [x] ✅ Rob 16 okt: *"gelukt"*. GEMETEN in `travelRouteLog` 23:17:52-23:18:29: start in Silvermoon (2393), 3 stappen;
      deur portaalkamer gepasseerd, Orgrimmar (85) → stap 2 "Take the portal to Dalaran", 23:18:29 "stop (finished):
      Dalaran", pijl vrij. Klein: na het laadscherm eerst kaart 12 (Kalimdor), stap 1 nog 2× opnieuw gewezen — onschuldig.
      **Klik op Dalaran, ergens buiten Orgrimmar** (bv. in Silvermoon). Chat: *"Route, step 1 of 2: …"* — eerst de weg
      naar Orgrimmar (portaal, Hearthstone of mage-teleport), daarna *"step 2: Portal to Dalaran"* bij het portaal in
      Orgrimmar. Door het portaal → chat *"Route finished … Dalaran"* en de pijl is weg.
- [x] ✅ Rob 16 okt, screenshot: *"Midnight Helper: You are already in Dalaran."* **Klik op een plek waar je al bent** (bv. Silvermoon terwijl je in Silvermoon staat) → chat *"You are already in
      Silvermoon City."*, geen pijl.
- [x] ✅ Rob 16 okt: *"done en gelukt"*. GEMETEN in `travelRouteLog` 23:23:37-23:25:06: vanuit Dalaran (125), 4 stappen —
      portaal Orgrimmar → "Portal to Shattrath City (lower room)" → in Shattrath "Portal to Isle of Quel'Danas" →
      "stop (finished): Isle of Quel'Danas". **Een plek met twee stappen**, bv. Isle of Quel'Danas (via Shattrath) of Tanaan Jungle (via Warspear). Klopt
      elke stap? Zo niet: screenshot + `/mh travel` (onderaan staat nu de lijst plekken met hun stappen).

## 🆕 16 okt (avond) — Mount run: een tegel en een knop bovenaan (release 4.8.0)

Rob: *"Wel mis ik een knop of een tegel iN MH voor onze mountrun"*. Eerst `/reload`.

- [x] ✅ Rob 16 okt: *"nu zie ik hem en hij werkt"*. **Tegel in de Tools-kamer** (`/mh` → **Tools**, naast Consumables/Professions/Macros): een tegel **"Mount run: old
      raids"** met het Mounts-icoon. Muis erop → uitleg. Klik → het Mount run-venster opent (geen tab). Rechtsklik →
      verbergen kan, en de regel onder de tegels biedt hem weer aan. (Rob 16 okt, screenshot: de eerste versie zat
      alleen ín "Pop-out windows".)
- [vervallen, niet getest] **Ook in "Pop-out windows"** (`/mh` → Tools → Pop-out windows): daar staat dezelfde kaart met **Open**.
- [vervallen, niet getest] **Knop bovenaan de Mounts-tab** (`/mh` → Mounts): de knop *"Old raids for mounts (mount run)"* staat nu als éérste,
      boven de mountlijst (niet meer helemaal onderaan). Klik → het Mount run-venster opent. Onderaan staat alleen nog de
      tip over de verzamel-addon.
- [vervallen, niet getest] **In het Nederlands** (`/mh lang nl`): tegel heet *"Mount run: oude raids"*, knop *"Oude raids voor mounts (mount
      run)"*.
- [x] ✅ Rob 16 okt (screenshot: *"Blue Proto-Drake (Skadi the Ruthless, Heroic, 1.2%)"*, Engelse client).
      **Mount run: baasnamen uit de client** (16 okt, Rob: *"Repareer de baasnamen en de weekcontrole eerst"*). Open de
      Mount run (tegel in Tools), loop de tabbladen langs. Hoort: achter elke mount die je mist de baas zoals de Dungeon
      Journal hem noemt, vaak voluit (*"Chrome King Gallywix, Mythic"*, *"Yogg-Saron, 0 keepers"*); Vault of Archavon
      *"each of the 4 bosses"*, Bronze Drake *"in time, Heroic"*, Nightbane gewoon *"Nightbane"*, Quantum Courser met
      zijn voorwerpnaam. Nergens *"?"* of een getal waar een naam hoort.
- [x] ✅ Rob 16 okt: *"De 3D-animatie in de Mount run werkt na /reload"*. **Mount run: muis over een mount** (Rob 16 okt: *"de andere hebben een animatie"*). Ga met de muis over een mount-
      regel in het Mount run-venster. Hoort: tooltip bij de muis (zoals in de Mounts-tab) en rechts naast het Mount
      run-venster het draaiende 3D-model. Muis eraf → beide weg. Venster dicht → 3D-model ook weg. Quantum Courser
      (Dungeons-tab, Dawn of the Infinite): voorwerp-tooltip, geen model. Scrollen met het wieltje werkt nog.
- [vervallen, niet getest] **Weekcontrole**: doe één oude raid waar een mount-baas in zit (bijv. Onyxia of Ulduar), open daarna de Mount run.
      Hoort: die moeilijkheid *"done"* met de resettijd. Een raid die je helemaal leeg hebt: altijd *"done"*.
      ⚠️ Op een Duitse/Franse client is dit het eigenlijke doel (naam uit de client); dat kunnen wij niet testen
      (taalpakketten zijn client-gebonden) — een speler met zo'n client moet het bevestigen.
- [vervallen, niet getest] **Changelog-venster na de update naar 4.8.0**: bovenaan staat 4.8.0 met negen regels, de eerste over de Mount run.
- [vervallen, niet getest] **Eigen opgeslagen TomTom-punt blijft** (na de oorzaak-fix in `MH_TomTomClearAll`): zet zelf een TomTom-punt
      (`/way 50 50 test`), start een MH-route met meerdere stappen, `/reload`. Hoort: jouw "test"-punt staat er nog.
      En een route met deur/orb of portal geeft geen *"TomTom's point was gone"* meer in het log (de fix bij de bron).
- [x] ✅ Rob 16 okt: *"ja nu werkt ie goed"* (vangnet). **Dalaran → The Ring of Glory, met TomTom** (Rob: *"tot aan de portal naar de isle ging het goed, daar aangekomen
      kreeg ik onze blauwe pijl"*). Zelfde route nog eens. Hoort: op het eiland (Coiled Isle) na een paar tellen weer de
      **TomTom-pijl**, niet de blauwe. Na `/reload` staat in het log *"TomTom's point was gone (old uid map … ): set again"*
      met het oude punt erbij; dat vertelt ons de oorzaak. Zie je tóch de blauwe pijl: log lezen.

## 🆕 16 okt (laat) — onze pijl nam het over van TomTom bij de rare

- [vervallen, niet getest] **Route met een rare-omweg, met TomTom** (Rob: *"hij gebruikt onze eigen arrow na een tijdje … voor de rare"*): loop
      naar de rare en blijf daar even staan of vecht. Hoort: de TomTom-pijl tot je er bent, daarna géén pijl van ons (TomTom
      haalt zijn punt zelf weg op 15 yd). Ook bij de ingang van een delve: geen eigen pijl meer op het laatste stukje.
      Zie je onze pijl tóch: `/reload`, dan staat in het log *"our arrow takes over from TomTom"* met de reden.
- [vervallen, niet getest] **Doel op een ander continent met TomTom** (controle dat de reservepijl blijft werken): daar mag onze pijl wél komen
      (TomTom kan dan niet meten maar houdt zijn punt).

## 🆕 16 okt (middag) — Travel fase 4: de zes "beheerde" routes via de routeloper

Eerst `/reload` en BugSack leeg. Wat anders is: rares, prestaties (achievement-schatten), beroepsschatten, de weekroutine,
delve-kisten en rituals zetten de pijl niet meer zelf; de routeloper doet dat en vraagt de route steeds *"wat is je
volgende doel?"*. Bij twijfel: **`/mh travel`** — onderaan staat nu ook **"paused: …"** (een route die wacht) en in het
log regels als `lead (treasure) → …`, `pause (…)`, `resume treasure`. Een `/reload` zet het log in de SavedVariables.

Elke routeknop één keer — je moet zien: pijl naar het eerste doel, en na het pakken/doden de pijl naar het volgende.
- [x] ✅ 16 okt GEMETEN (Rob, ná fix 357a980): pas na de kill van de rare naar de volgende (Malfunctioning Construct).
      Eerste keer (vóór de fix) sprong hij midden in het gevecht met Banuran door. *Find Nearest* ook ✅ (Rob: "daar had
      ik hem mee gevonden").
      **Rares:** *Generate Route* (hele zone) — pijl naar de dichtstbijzijnde rare; vlieg over een lege spawn (rare niet
      op) → binnen een paar seconden pijl naar de volgende. Daarna *Find Nearest* (één rare): pijl blijft op die ene tot
      hij dood is.
      🐞 Rob 16 okt middag (screenshot): vechtend met **Banuran** (65%) stond de pijl al op **Bad Zed (875 m)**. AFGELEID:
      de "lege spawn"-regel schoof door in de eerste seconde binnen 40 yd, vóór de pull. Gerepareerd, opnieuw testen:
      tijdens een gevecht, tot 8 s erna en zolang je een levende rare als doelwit hebt, blijft de pijl op de rare. Een
      lege spawn telt pas na **8 s stilstaan buiten gevecht**. `/mh skip` werkt altijd. In het log: `rare: hold …` en
      `rare: … not up after 8 s out of combat — next`. Graag daarna een `/reload`, dan lees ik het log.
- [vervallen, niet getest] **Prestatie-schatten** (Achievements-tab → Route): startregel in chat, pijl op de eerste schat (of eerst de urn/orb),
      de andere schatten als losse pinnen op de kaart; schat pakken → *"next: …"* en pijl verder. `/mh skip` → volgende.
      ⚠️ Anders dan vroeger: de 2 s-tikker die TomTom's pijl bij elke subzone opnieuw zette is weg. Verdwijnt de TomTom-pijl
      bij een subzone-wissel? Zeg het, dan weet ik dat die tikker toch nodig was.
- [vervallen, niet getest] **Beroepsschatten** (Profession → *Generate treasures* of *books*): pijl naar de dichtstbijzijnde; pakken → volgende;
      alles gepakt → *"All … collected — arrow cleared."*
- [vervallen, niet getest] **Weekroutine** (Home → route): pijl naar de eerste stop; ~6 s op een stop staan → volgende stop + *"Next stop: …"*;
      alles klaar → *"done"*-regel. Na een portaal (bv. naar Voidstorm en terug) moet de pijl er nog zijn.
- [x] ✅ 16 okt GEMETEN (Rob: "werkt goed"). **Delve-kisten** (in een delve, kistenknop): pijl naar kist 1; nog eens klikken = overslaan → volgende kist; kist
      geopend → volgende. Delve uit → route stopt vanzelf.
- [vervallen, niet getest] **Ritual** (ritual-site kiezen): pijl naar de obelisk, ook na doodgaan + herrijzen weer terug. Weekly klaar → route
      weg. (Nieuw: ónze eigen pijl is nu **paars**, de ritual-kleur; was goud. TomTom's pijl verandert niet.)
- [vervallen, niet getest] **🔑 Rare-omweg tijdens een schattenjacht** (het oude gat, travel map §1b-4): start beroepsschatten, klik dan op een
      rare-melding (toast) → pijl naar de rare. Rare dood → chat **"Back to your route: <schat>"** en de pijl weer op de
      schat. Ook: ga naar de rare maar laat hem staan als hij er niet is → na ~10 s stilstaan (niet in gevecht) gaat de
      pijl ook terug.
- [vervallen, niet getest] **Gewone klik tijdens een jacht:** schattenjacht aan, klik een delve of een Codex-link → pijl daarheen. Aangekomen
      → *"Route finished"* en daarna *"Back to your route: …"* met de schat-pijl.
- [vervallen, niet getest] **`/mh clear`** tijdens elk van de zes, en één keer tijdens een rare-omweg over een schattenjacht: alles weg (pijl,
      pinnen) en er komt **niets** terug — ook niet na een zonewissel of een paar seconden wachten.
- [vervallen, niet getest] **Silvermoon-pin zónder deur** (bv. *Portal to Voidstorm*) en **`/mh goto 47 62`**: pijl, en na een laadscherm komt
      hij terug; door het portaal → *"Route finished"*.
- Niet in het spel getest, wel GEMETEN buiten het spel: een proefbank met nagebootste WoW-functies (scratchpad
  `runner_test.lua`) liep 7 scenario's door — omweg + terugkeer, gewone klik + terugkeer, aankomst → volgend doel,
  `/mh clear` met een gepauzeerde route, een nieuwe route vervangt de oude, module stopt zichzelf, zonewissel → nieuw
  doel: 28/28 goed. Dat bewijst de logica van de stapel, niet het gedrag van TomTom of de client.

## 16 okt — Travel fase 3: één routeloper voor élke route (TravelRoute.lua)

Eerst `/reload` en BugSack leeg. Bij twijfel: **`/mh travel`** toont onderaan "route runner": welke route, welke stap
(met een `>`), en de afstand tot die stap + hoe gemeten. Maak daar een screenshot van als iets niet klopt.

- [vervallen, niet getest] **Delve vanuit de oude wereld** (bv. in Uldum of Orgrimmar, een delve in Eversong kiezen op het Delves-tabblad):
      chat zegt *"Route, step 1 of N: …"*. Is stap 1 een hearthstone/toy/magiër-teleport → er verschijnt een **knop**
      bovenin (dezelfde als bij de Mount run) en géén pijl. Klik → je reist → na het laden *"Route, step 2 of N"*
      met de pijl naar het portaal / de delve. Komt er nu ook nog het oude reisvenster met een tweede hearthstone-knop?
      Dat hoort NIET meer.
      ✅ Rob 16 okt avond (screenshot): **wereldbaas vanuit Shattrath** op zijn mage → knop *"Cast Teleport: Silvermoon
      City; it takes you to Silvermoon City."*. Open: wat er ná de teleport kwam, en of het reisvenster nog een tweede
      knop gaf.
      🐞 Rob 16 okt avond, Thunder Bluff → Atal'Aman (mage): na de teleport ónze pijl i.p.v. TomTom's, en geen "step 2"-regel.
      GEMETEN in `travelRouteLog`: na de teleport eerst kaart **2537**, dan 2393; de pijl werd op 2537 gezet en TomTom
      verbergt zijn pijl als hij niet kan meten (GEMETEN in TomTom_CrazyArrow.lua). Gerepareerd → opnieuw testen:
- [vervallen, niet getest] **Teleport/hearthstone naar Silvermoon tijdens een route:** na het laden *"Route, step 2 of 2: …"* (of meer stappen,
      bv. een vliegmeester) en de **TomTom-pijl**, niet de onze.
      Rob 16 okt avond, rare Lady Liminus vanuit Thunder Bluff: ✅ knop + "step 2 of 2", ❌ nog ónze pijl. GEMETEN: TomTom
      kán Silvermoon → Eversong meten (Robs /run: HereBeDragons 2393, 3796 yd); het log had na de teleport maar één
      moment, nog op 2537. Nu kijkt de loper 2,5 s na een laadscherm nog eens (log: "map settled"). Opnieuw testen, met
      een rare én een delve.
      ✅ Rob 16 okt avond, rare Lady Liminus vanuit Thunder Bluff: "het lijkt erop dat ie nu werkt". GEMETEN in het log:
      teleport → 2393 → opnieuw gepland → vliegmeester Sanctum of Light, eigenaar bleef "rare". De poging daarvóór stopte
      ("owner"); wie de eigenaar toen veranderde is niet gemeten — de meter (eigenaar-wissels met bestand:regel in
      `travelRouteLog`) bestond toen nog niet en blijft staan. Een delve via teleport is nog niet opnieuw getest.
      🐞 Rob 16 okt avond, delve Shadowguard Point via teleport + portaal naar Voidstorm: route ✅ (log: 2393 → portaal →
      2405 → doel), maar na het portaal weer ónze pijl. Nu een wachter: elke seconde, zolang een route de pijl heeft —
      heeft TomTom zijn punt, kan hij het meten en is zijn pijl toch verborgen → TomTom's pijl weer aan (log: "TomTom's
      arrow was hidden while it can measure … shown again"). Opnieuw testen: delve via teleport + portaal.
- [x] ✅ Rob 16 okt avond: Mount run (2), Silvermoon-pin met deur (3) en "andere route kiezen tijdens een route" (4) gaan
      goed.
- [vervallen, niet getest] **Na het portaal in Silvermoon:** de route plant opnieuw vanaf daar: pijl naar de vliegmeester (*"Flight master: …"*)
      of meteen naar de delve. Op de vlucht stappen → pijl springt naar de delve. Bij de delve: *"Route finished — …"*.
- [x] ✅ Rob 16 okt avond: "beide werken" (van buiten én vanuit de hal). **Coiled Isle-delve vanuit Silvermoon** (16 okt avond opnieuw gebouwd na Robs melding "hij stuurde me niet naar de
      ingang"): pijl naar de **boog** van Astalor's Sanctum (55.02/63.56) en hij blijft daar staan tot je **door de boog
      bent** — niet meer ~20 m ervóór. Binnen → pijl naar de **orb** (55.80/65.02) + chat *"Portal to The Coiled Isle:
      click the orb to go down to it"*. Orb aangeklikt, beneden → pijl naar het portaal. Door het portaal → volgende stap
      of de delve. Klopt iets niet: `/mh travel` → onderaan "route runner log" (of gewoon `/reload`, dan lees ik
      `travelRouteLog` zelf uit je SavedVariables).
  ✅ Rob 16 okt avond: boog → orb → portaal werkt (en vanuit binnen ook). Wel: bij de boog en bij de orb even ónze pijl
  i.p.v. die van TomTom. GEMETEN in `travelRouteLog`: overdracht op 7.5 yd, TomTom wiste die punten zelf al op 15 yd.
- [x] **Geen eigen pijl meer bij boog en orb** (TomTom-gebruikers): de TomTom-pijl blijft de hele weg; tussenpunten
      wist TomTom niet meer zelf, MH haalt ze weg als je verder bent. ✅ Rob 16 okt avond: "ja ging dit keer goed".
      (Losse oude punten op de kaart na afloop: niet apart genoemd.)
- [x] **Zelfde vanuit binnen**: sta al in de hal (na de boog) en kies de delve → pijl meteen naar de orb, niet terug naar de
      boog. Sta je al beneden bij het portaal → pijl meteen naar het portaal.
- [vervallen, niet getest] **Mount run** (zelfde gedrag als gisteren): "Route" bij een raid → *"Mount run, step 1 of N"*, knop bij een
      hearthstone-stap, portaalkamer-deur → portaal, verder bij elke zonewissel, in de raid stopt hij. Throne of Thunder nog
      een keer als controle. Het knopvenster heet nu anders; stond hij verschoven, dan staat hij weer bovenin.
      ✅ Rob 16 okt avond: Mount run vanuit Shattrath → "keurig de portal naar Orgrimmar" (eerste stap). Rest van de run
      nog niet gemeld.
- [vervallen, niet getest] **Silvermoon-pin met deur** (City-tabblad → "Portal to The Coiled Isle"): pijl naar de boog; door de boog → orb
      (met chatregel); beneden → portaal. Door het portaal → *"Route finished"*.
- [x] ✅ Rob 16 okt avond: "mh clear werkte ook". **`/mh clear` midden in een route** (vooral tijdens een hearthstone-stap of vlak voor een vliegmeester): knop weg,
      pijl weg, en na de volgende zonewissel komt er **niets** terug. `/mh travel` zegt *"no route (last: …, stopped: clear)"*.
- [vervallen, niet getest] **Andere route kiezen tijdens een route** (bv. een rare of een `{WAY}`-link in de Codex): de oude route stopt, geen
      chatregels meer van de oude.
- [vervallen, niet getest] **Rare / schat / achievement** (fase 4 nog niet gedaan, moet gewoon blijven werken): na een portaal komt de TomTom-pijl
      terug zoals vroeger.

## 🆕 15 okt — Nieuw uit 12.1.5 (Rob: "alles") — mounts, campagne, achlist, J'imothy, Aqir-beloningen

- [vervallen, niet getest] **Mounts-tabblad:** 5 nieuwe regels: Corrupted Swarmer, Loa-Blessed Wayfarer, Sporebearer Fungal Strider (met
      route naar Showena in The Den: klopt de plek?), Indigo Coiled Horror en Violet-Backed Skyfang (renown-balk bij
      Zul'jarra's Forces, alleen als je daar renown hebt).
- [vervallen, niet getest] **Home:** blok "New in 12.1.5: The Promise of Tomorrow" (als je de campagne nog niet af hebt) met "Route to
      Lor'themar". Heb je hem al af, dan is het blok er terecht niet.
- [x] **`/mh achlist`:** onderaan twee nieuwe groepen: "The Labyrinth of Kindo'jan" en "Patch 12.1.5: Aqir Invasions,
      Keystone Myth and more". ✅ Rob 15 okt: beide staan er (2/25 en 0/6). Openklikken nog niet gezien.
- [vervallen, niet getest] **Codex → J'imothy:** de kaart met 3 pijl-links in Silvermoon.
- [vervallen, niet getest] **Codex → Aqir Invasion:** nieuw stuk "Rewards from Estelia Archtender" (3 pets, toy, mount, titel).
- [x] **`/mh ach id 63657`** → ✅ Rob 15 okt: "criteria = none listed" — geen getal uit de achievement.
- [vervallen, niet getest] **Mounts-tabblad → Corrupted Swarmer:** heeft nu een balk **X / 5000** uit je reputatie bij de Aqir Research Enclave
      (verschijnt pas als je daar reputatie hebt). Klopt X met je reputatievenster?

## 🆕 15 okt — Labyrinth-kistenroute: 39 kisten uit HandyNotes (DelveChestData.lua)

- [vervallen, niet getest] **Coach → "Chests" in de Labyrinth:** de pijl kiest nu uit 39 kisten (was 20), ook die achter de loa-zegels.
      31 hebben een quest-ID: een kist die je al geopend hebt, slaat de route over. Wijst de pijl naar een plek waar geen
      kist staat, noteer de kamer + `/mh capture`.
- [vervallen, niet getest] **Combat log-lampje** (nieuw 15 okt, CombatLogLamp.lua): typ `/combatlog` → binnen ~2 s bovenaan je scherm een klein
      rood knipperend lampje "Combat log". Nog een keer `/combatlog` → lampje weg. `/mh combatlog` zegt ON/OFF + waarom.
      Slepen = verplaatsen; Shift+scroll = groter/kleiner. Uit te zetten in Settings ("Show a lamp while the combat log is on").
- [vervallen, niet getest] **Kamerbaas targeten vóór de pull** (Rob 15 okt, Grukk): target de baas → coach dicht: knop *"Room boss: Grukk — show
      tips?"*; coach open: het bossvak springt naar Grukk. Gebeurt er niets: `/reload` → ik lees `delveRoomBossLog`
      ("target name is secret here" = de game verbergt de naam ook buiten het gevecht).
- [vervallen, niet getest] **Zegelkisten:** na `/reload` + Chests staat in de chat *"N chest(s) left out: behind a loa seal …"* en wijst de pijl niet
      meer naar een rode zegel. Kist 39 (Jan'alai's Refuge) is GEEN zegel maar een deur om aan te klikken: lukt dat?
- [vervallen, niet getest] **Kisten per kamer:** loop een kamer in → de pijl kiest een kist in díe kamer (de naam van de kamer staat boven je
      minimap). Kamer leeg → chat: *"No chests left in <kamer> that I know of. The next one is in <kamer>…"*. Klopt de kamernaam
      boven je minimap met wat MH zegt? Vooral bij Catacombs, Reliquary, Nalorakk's Rest, Flooded Chamber, Cave Towers.
- [vervallen, niet getest] **Mount run** (nieuw 15 okt): `/mh mountrun` of de knop onderaan het Mounts-tabblad. Per raid groen "open" / grijs
      "done this week (resets in …)", per mount groen vinkje (heb je al) of rood kruis. Na een kill: venster opnieuw openen →
      klopt "done this week"? Vergelijk met `/raidinfo`. Heroic-dungeons (Utgarde Pinnacle, Sethekk, Magisters' Terrace,
      Culling) staan misschien altijd op "open" (onbekend of het spel die lockout doorgeeft). "Arrow to the entrance" in het
      goede gebied → wijst de pijl naar de ingang?
- [vervallen, niet getest] **Mounts-tabblad → Hexed Vilefeather Eagle** (nieuw 15 okt): balk *X / 1000* (je Vile Essence) + Route-knop naar de
      Abandoned Ritual Skull in Zul'Aman (44.72, 44.09). Klopt de plek?
- [vervallen, niet getest] **Codex → World → "Hidden treasures without an achievement"**: klik een paar links (boek in Silvermoon, Voidhoarder's
      Corpse) → zet de pijl op de goede plek?
- [vervallen, niet getest] **Kist overslaan** (Rob 15 okt: "hij stuurt me ergens naartoe waar ik niet heen kon"): staat de pijl op een kist achter een
      dichte deur, klik dan nog een keer op **Chests** in de coach. In de chat: *"Skipped Sturdy Chest N — it comes back last"*,
      en de pijl gaat naar de volgende. Na de andere kisten komt de overgeslagen kist als laatste terug.
- [x] Na een kist: `/reload` → ik lees `questDiff.found`: klopt het quest-ID van HandyNotes met wat de game afvinkt?
      ✅ 15 okt GEMETEN, 2 van 2: kist #1 = 97131 (46.9/64.2), kist #2 = 98602 (37.1/69.8). Route liep door naar 3 of 39.
- [vervallen, niet getest] **Codex → Journey-kaart, rang 2:** links naar de 3 Hexmasks (Thundering, Fiery, Frozen). Klik → pijl in de Labyrinth.
- [vervallen, niet getest] **Codex → Labyrinth-kaart, "Mislaid Treasures"** (16 okt hernoemd, was "Mislaid Oddities"; HandyNotes 159 + jouw
      tooltip van 13 okt): links 1 t/m 15. Klik de dichtstbijzijnde → ligt er een kistje dat in de tooltip *Mislaid Treasure* heet?
- [vervallen, niet getest] **Mount run → tabbladen** (16 okt, `/mh mountrun`): bovenaan een rij tabs (Avond 1 … Avond 5, Dungeons, Groep), met tussen
      haakjes hoeveel mounts je daar nog mist. Klik een tab → alleen dat blok staat eronder, lijst begint bovenaan. Venster dicht,
      `/reload`, weer open → dezelfde tab. Op een ander character → die heeft zijn eigen laatste tab. Passen de tabs netjes
      (eventueel in twee rijen) en staat de lijst er niet overheen?
- [vervallen, niet getest] **Mount run → pijl in stappen** (16 okt). Sta in Stormwind of Orgrimmar, `/mh mountrun`, klik bij een raid
      **Arrow to the entrance**. In de chat: *"Mount run, step 1 of 2: Take the portal to Dalaran."* en de pijl staat op dat
      portaal. Ga erdoor → na het laden zegt de chat *"step 2 of 2: Go to the entrance of …"* en de pijl springt naar de ingang.
      Probeer er een paar:
      - **Ulduar** (1 portaal): 2 stappen.
      - **Sepulcher** (Oribos → Ring → Zereth Mortis): 4 stappen.
      - **Nerub-ar Palace** (Dornogal → tunnel): de oude fout *"Head for Wildcamp Ul'ar"* mag NIET meer komen.
      - **Horde, Shattrath of Caverns of Time:** zegt hij *"(lower room)"*, en staat het portaal echt beneden?
      - **Culling of Stratholme:** de pijl wijst nu naar het portaal BINNEN de Caverns, niet naar de grotmond.
      Klopt een portaal-plek niet? Zeg welke raid en welke stap; dan meet je hem met `/mh coord`.
- [vervallen, niet getest] **Spawn of Vyranoth** (16 okt): Mounts-tab / This Week. Heb je hem nog niet? Dan geen *"X / 4"* meer, maar de uitleg
      *"The Turbulent Timeways event … ended on 11 August …"*.
- [x] ✅ 16 okt GEMETEN (Rob, Dalaran → rares in Eversong): popup zegt *"Take the portal to Orgrimmar."* en TomTom wijst naar
      dat portaal (43 m). Toy-knop in de popup nog niet gezien. "HS on Cooldown!" stond er ook (bekend, nog open).
      **Travel fase 2 deel 2 — de reispopup** (16 okt). Kies buiten Midnight een route naar een Midnight-doel (bv. een delve
      in Eversong) met **een toy-hearthstone** (gewone op cooldown of niet in je tas): de hearthstone-knop in de popup hoort
      nu het **toy-icoon** te hebben en de toy te gebruiken. Met je **mage**, zonder portaal in de buurt: de popup toont nu
      een regel met de eerste stap van het plan (bv. *"Cast Teleport: Silvermoon City …"*), ook als er geen hearthstone-knop
      is. Komt er "HS on Cooldown!" terwijl je geen hearthstone hebt? Dat is bekend en nog niet aangepast.
- [vervallen, niet getest] **Travel fase 2 — weg naar huis overal** (16 okt). Met je **mage**, buiten de stad (bv. Uldum of Pandaria):
      - **Mount run → een raid:** stap 1 hoort nu *"Cast Teleport: Orgrimmar; it takes you to Orgrimmar."* te zijn, met een
        knop die de teleport cast. (Werkt dat niet: dan kloppen mijn spell-ID's nog niet — zie de `/dump`.)
      - **Een gewone route naar Midnight** (een delve in Eversong/Zul'Aman, of een Codex-link) vanuit de oude wereld: de chat
        en het pijl-label zeggen nu een hele stap, bv. *"… is not on this continent. First: Cast Teleport: Silvermoon City …"*
        of *"First: Use your Hearthstone; it takes you to Silvermoon City."*, in plaats van alleen *"head for Orgrimmar"*.
      - Met een **niet-mage** (hearthstone in Silvermoon): dezelfde route → *"First: Use your Hearthstone …"*.
- [x] ✅ 16 okt GEMETEN: **Mount run Throne of Thunder van begin tot eind gehaald** (Rob's mage: Elsia-quest → vlucht →
      "Go to the entrance" 1,4 km → binnen in de raid). Isle of Thunder = niet vliegen (Zygor Node.lua:569); Rob sprong
      van de boot en liep. Instap-sprong zelf nog niet gezien (Rob vloog al vóór de fix).
- [vervallen, niet getest] **Instappen = volgende stap** (16 okt, jouw vlucht met Elsia wees de pijl nog 252 m terug). Neem de quest, laat Elsia
      je vliegen: binnen ~1 seconde na het opstijgen hoort de chat *"step 4 of 4: Go to the entrance of Throne of
      Thunder"* te zeggen en wijst de pijl vooruit. Geldt ook voor boten, zeppelins en de Deeprun Tram.
- [x] ✅ 16 okt GEMETEN (Rob's screenshot): pijl op Elsia, 14 m, met de quest-zin. **Throne of Thunder zonder de Isle of
      Thunder-quest** (16 okt, jouw mage). Mount run → Throne of Thunder. In Townlong
      Steppes moet stap 3 nu zijn: *"Talk to Scout Captain Elsia and accept the quest "The Storm Gathers"; the first time,
      this is how you reach Isle of Thunder."* met de pijl op Elsia (50.80/73.39). Zij vliegt je erheen; daarna stap 4.
      En: `/mh travel` → onderaan nu *"no place stored twice"* (het vals alarm is weg)?
- [vervallen, niet getest] **Travel fase 1 — `/mh travel`** (16 okt). Typ `/mh travel`: je ziet hoeveel reispunten MH kent per tabel, op welke
      kaart en welk continent je staat, en je hoofdstad. Onderaan moet staan: *"no place stored twice with different
      numbers"*. Staat er een lijst? Stuur hem me. Verder hoort er **niets** anders te werken dan gisteren, behalve deze
      vijf verbeterde plekken (klik ze eens aan):
      - Silvermoon-kaart: **Portal Room**, **Astalor (entrance)** en **Ritual Site / Void Assault hub** (nu op Lilatha).
      - Een route naar de **Underbelly** (Kith'ix): de ingang ligt nu op 47.30/11.20, en de Windcaller op 50.03.
      - Coiled Isle-portaal vanuit een delve-route: het eindpunt binnen is nu jouw meting 56.74/67.30.
- [vervallen, niet getest] **PTR 12.1.7 (build 70424, map `_ptr_`)** — 16 okt gekopieerd: MH (main, `.toc` met 120107), BugSack v12.1.7 en
      BugGrabber (die waren al gelijk). Bij het karakterscherm: *AddOns → "Load out of date AddOns"* aan laten (BugSack
      declareert 120107 nog niet). Test met BugSack open:
      - **Laadt MH zonder fouten?** `/dump select(4, GetBuildInfo())` → verwacht `120107`.
      - **Bekend PTR-probleem, niet van ons:** bij het kopiëren van je personage komt een Lua-fout (Blizzard dev notes).
      - **Edit Mode:** de "Personal Resource Display" is nu doorklikbaar; doet MH's Edit Mode-backup nog normaal?
      - **Omnium Folio:** tel de rijen (verwacht 7), en `/mh questscan` voor 99508/99509.
      - **Turbulent Timeways VI:** `/mh ach id 64207` → vraagt het criterium 4 of 5 weken?
      - **Talebound** (als hij speelbaar is): start een verhaal met BugSack open. Fout van MH, of een Delve Coach/Delve
        Log-regel die er niet hoort? (Talebound gebruikt hetzelfde systeem als delves.)
- [vervallen, niet getest] **Mount run → hearthstone-KNOP** (16 okt, jouw "ik mis de knop"). Bij *"Use your Hearthstone …"* verschijnt bovenaan
      je scherm een klein venster met het hearthstone-icoon (of je toy) en dezelfde zin. Klik het icoon → je hearthstone
      start. Na het laden verdwijnt het venster vanzelf. Te verslepen; Shift+scroll maakt het groter/kleiner. In gevecht
      verschijnt het pas na het gevecht. Met een toy: werkt de klik ook?
- [vervallen, niet getest] **Mount run → hearthstone als eerste stap** (16 okt, jouw Uldum-test). Sta ergens buiten Silvermoon en Orgrimmar
      (bv. Uldum) met je hearthstone klaar (gebonden aan Wayfarer's Rest, Silvermoon). Kies een raid in Pandaria. Stap 1 hoort
      nu te zijn: *"Use your Hearthstone; it takes you to Silvermoon City."* (geen pijl). Na het laden: stap 2 de portaalkamer →
      Orgrimmar, stap 3 *"Take the portal to The Jade Forest"*, enz. Hearthstone op cooldown? Dan stap 1:
      *"In Orgrimmar: Take the portal to The Jade Forest."*
- [vervallen, niet getest] **Mount run → geen gestoorde stappen meer** (16 okt, jouw Throne of Thunder-test). Doe dezelfde route nog eens vanuit
      Silvermoon. Na elk portaal mag de chat alleen *"Mount run, step N of 4: …"* zeggen: GEEN *"Nearest flight point there:
      Sanctum of Light"*, GEEN *"is not on this continent"*, GEEN *"Route finished"* en geen vlucht naar Honeydew Village.
      Daarna: kies een gewone route (bv. een delve) → werkt het reisadvies dan weer zoals vroeger?
- [vervallen, niet getest] **Mount run → eerst naar huis** (16 okt, jouw vraag in Silvermoon). Sta in **Silvermoon**, klik bij Firelands
      *Arrow to the entrance*. Stap 1 moet nu zijn: *"Go to the portal room and take the portal to Orgrimmar."* met de pijl op
      MH's eigen Portal Room-pin. Daarna Orgrimmar → Hyjal-portaal → ingang (3 stappen).
      Probeer ook: **Dornogal** of **Valdrakken** (portaal naar huis staat daar zelf), **Voidstorm/Coiled Isle** (eerst naar
      Silvermoon, dan naar huis) en **Eversong of Zul'Aman** (*"Fly to Silvermoon City and take the portal to Orgrimmar there."*).
      Krijg je in Silvermoon tóch weer *"other continent — travel back"*? Doe dan `/mh here` en geef me het mapnummer:
      sommige gebouwen in Silvermoon melden kaart 2576 in plaats van 2393.
- [vervallen, niet getest] **Delve op de Coiled Isle, vanuit Silvermoon: eerst de deur** (16 okt, jouw melding). Sta in Silvermoon, buiten het
      gebouw. Kies een Coiled Isle-delve (bv. Gnarldor Isle) en klik op de route. De pijl moet eerst naar de **deur** wijzen
      (54.99/63.30), en zodra je daar bent (binnen ~25 yd) naar het **portaal binnen**. Sta je al binnen, bij het portaal?
      Dan meteen het portaal. Ook bij de Mount run → Venomous Abyss / Altar of Fangs: eerst de deur, dan het portaal.
- [vervallen, niet getest] **Minder geheugen bij het inloggen** (16 okt). Na `/reload` meteen, zonder op te ruimen:
      `/run UpdateAddOnMemoryUsage() print(GetAddOnMemoryUsage("MidnightHelper"))` — vóór de wijziging was dat **48.137**.
      Het zou nu veel lager moeten zijn (dichter bij de 23.592 die je na `collectgarbage()` zag). En: staat MH nog gewoon in
      het **Nederlands**, en de Codex-kaarten ook? (Duits/Frans enz. kun je op een Engelse client niet zien; die zijn
      buiten het spel byte voor byte vergeleken.)
- [vervallen, niet getest] **Szarith the Fanged verplaatst** (16 okt, HandyNotes 159: 38.40/17.69 → **39.50/27.40** in de Underbelly, kaart 2613).
      Rares-tab, Coiled to Strike-kaart of de Codex-kaart over de Vaults of Atal'Utek: klik Szarith → pijl. Staat hij daar écht?
      Method zegt nog de oude plek; niemand heeft hem ooit gezien, dus dit is de eerste echte meting.

## 🆕 14 okt — Delve-lijst eerlijk verdeeld (Delves.lua)

- [x] **Midnight Delves (hoofdpagina):** links en rechts staan nu evenveel delves (8 + 8), in plaats van 5 links en 11
      rechts. Links eindigt met The Grudge Pit, rechts begint met Sunkiller Sanctum. Klopt het ook als je het venster
      smaller of breder maakt? ✅ Rob 14 okt, screenshot (8 + 8). Smaller/breder niet apart gezien.

## 🆕 14 okt — Kamerbaas-knop in de Labyrinth (DelveCoach.lua) — Rob: "doe B maar, met C als schakelaar"

- [vervallen, niet getest] **Coach dicht, een kamerbaas begint** (bv. Jun'ala): bovenin je scherm verschijnt ~5 s een knop
      *"Room boss: Jun'ala — show tips?"*. Hij blijft staan als het gevecht begint. Klik → de coach opent op díe baas.
- [vervallen, niet getest] **Coach al open**: geen knop; het bossvak springt naar die baas.
- [vervallen, niet getest] **Instellingen → "Labyrinth: open the coach for each room boss" AAN**: geen knop meer, de coach gaat vanzelf open.
- [vervallen, niet getest] Na elke kamerbaas: `/reload` → ik lees `delveRoomBossLog` (wat MH besloot en waarom). Kwam er niets, dan staat
      daar of de game géén signaal gaf, of dat MH de baas niet herkende.

## 🆕 14 okt — Labyrinth Journey op de Delves-pagina (Delves.lua)

- [x] **Midnight Delves:** onder "Delver's Journey: Rank 10 …" staat nu een tweede regel
      *"The Labyrinth of Kindo'jan: Rank 1 (900 / 2100)"* — dezelfde getallen als je Journeys-venster (Shift-J).
      ✅ Rob 14 okt: "Rank 1 (1900 / 2100)", gelijk aan het Journeys-venster.
- [x] Na de klik op een kamerbaas-knop: opent de coach nu op díe baas (niet meer op Jun'ala 1/19)?
      ✅ 15 okt GEMETEN (video 17:45 + log 08:52:07 "via encounter id"): coach opende op The Undead Trollbunal, 3/19.
- [vervallen, niet getest] **Codex → Delves → "The Labyrinth's own Journey (ranks 1-9)":** wat elke rang doet, wat er achter de zegels ligt,
      hoe je punten haalt. Klopt het met je Journeys-venster?
- [vervallen, niet getest] **Meten (graag):** noteer je Labyrinth-punten vóór en ná een run (Delves-pagina) — hoeveel geven de kisten?
      En kijk op een alt of de Journey dezelfde rang heeft (= gedeeld door je Warband).
      ◐ 15 okt: kist #1 gaf 700, kist #2 maar 150 (+2500 Amani Tribe). Waarom het verschilt weten we niet. Warband: ja (chatregel).
- [vervallen, niet getest] **Coach-tips per kamerbaas** (nieuw, 14 okt): target/vecht een kamerbaas → in de coach staat een regel met zijn
      aanvallen (bv. Grukk: Interrupting Shout, Ground Smash). Klopt wat je ziet?

## 🆕 14 okt — Wah'du in de Labyrinth-kaart (Codex.lua)

- [vervallen, niet getest] **Codex → Delves → The Labyrinth:** onder "Wah'du and the Mythical Soul Fragment" staat *"Wah'du stands here:
      Wah'du"* — klik de link → de pijl wijst naar 44.36, 79.57 in de Labyrinth.

## 🆕 14 okt — Kith'ix bij de raids van nu (RaidCoachData.lua)

- [x] **Raids-pagina:** The Unbinding of Kith'ix staat nu bovenaan bij de raids van dit seizoen (na The Venomous
      Abyss), niet meer onder "Older raids (Season 1)". ✅ Rob 14 okt, screenshot.
- [x] **Kith'ix openklappen:** er staan nu knoppen **Route** en **Map**. Route → pijl naar de ingang in The Underbelly
      (onder de Vaults of Atal'Utek). Map → de plattegrond van de raid. ✅ Rob 14 okt: beide knoppen; Map toont 2 verdiepingen
      (The Tomb of Ula'tek + Kith'ix' Prison, Kith'ix als schedel). De Route-pijl zelf nog niet gevolgd.
- [vervallen, niet getest] **Route naar Kith'ix vanaf de Coiled Isle:** de pijl heette "PLAN_STEP_DOOR" (Rob 14 okt). Nu hoort er
      *"the way through (nearest of the ones your client knows)"* te staan.
- [vervallen, niet getest] **Route naar Kith'ix, de hele weg:** de pijl stopte in de Vaults (Rob 14 okt). Nu: in de Vaults aangekomen springt de
      pijl binnen ~2 s naar de doorgang naar The Underbelly (≈45.2, 11.2), en daarbinnen naar de raid-ingang (74.3, 5.9).
      Blijft hij hangen: `/mh arrow` en zeg wat er staat.
      ◐ Rob 14 okt: in de Vaults wees hij naar de Amani Windcaller ✅, en het label is goed ✅. Maar in de gang tussen eiland
      en Vaults wees hij eerst terug en daarna niets. Fix: bij de doorgang (binnen 25 m) springt de pijl nu meteen naar
      de volgende stap (de Windcaller). Opnieuw proberen.
- [vervallen, niet getest] **Bij de Amani Windcaller** (Rob: "ik weet als noob nu niet wat ik moet doen"): de pijl heet nu *"Amani Windcaller:
      pick "Fly me to the Northern Amani Bulwark""*. Praat met hem, kies die optie; daarna wijst de pijl naar de
      doorgang naar The Underbelly.
      ✅ Rob 14 okt: opnieuw "Route" bij de Northern Bulwark → "Way into the Underbelly (the only one) 233m".
- [vervallen, niet getest] **Na de Windcaller-vlucht** springt de pijl nu vanzelf naar de volgende stap (zonder opnieuw op Route te klikken):
      bij de Windcaller (binnen 25 m) wijst hij al naar waar de vlucht heen gaat, en dat blijft zo tijdens het vliegen.
- [vervallen, niet getest] **Route naar The Venomous Abyss vanuit het zuiden van de Vaults** (bij de Amani Foothold): de pijl stuurt je nu
      eerst naar de **Amani Windcaller** (*pick "Fly me to the Northern Amani Bulwark"*) in plaats van dwars door de Vaults
      te lopen. Alleen vanaf de Foothold-Windcaller (van de andere twee weten we niet welke vluchten ze hebben).

## 🆕 14 okt — Party targets: geen losse streepjes meer (PartyTargets.lua)

- [vervallen, niet getest] **In een groep van 2-4:** onder het "Party targets"-venster hangen geen losse stippellijntjes meer waar de lege rijen
      zouden staan (Rob + Carola 14 okt). De lijn tussen naam en doelwit staat alleen nog bij echte groepsleden.

## 🆕 14 okt — FastMark: twee fouten uit BugGrabber (FastMark.lua)

- [vervallen, niet getest] Geen "secret boolean"-fout meer van FastMark.lua:105 (kwam bij markers zetten / RAID_TARGET_UPDATE). Het gouden
      ringetje "ligt al" kan in een instance nu soms wegblijven — dat is de eerlijke stand als de game het verbergt.
- [vervallen, niet getest] De FastMark-balk loslaten tijdens een gevecht geeft geen ADDON_ACTION_BLOCKED meer; hij zet zich na het gevecht vast.

## 🆕 14 okt — Toetsen op het Dispel-tabblad (PlayCardWindow.lua)

- [x] **How you play → Dispel** (bv. Frost Mage): rechtsboven op het icoon van Remove Curse en Spellsteal staat nu de
      toets waar die spell op zit, net als bij "Your buttons". Staat hij niet op een balk, dan een grijs streepje "-".
      ✅ Rob 14 okt, Resto Druid: Soothe toont "S-V". (Nature's Cure zonder toets — niet op een Blizzard-balk? Niet nagevraagd.)

## 🆕 13 okt — Kamerbaas in de coach (DelveBossShowcase.lua + DelveCoach.lua)

Rob: "ik had verwacht dat we bij elke kamer met een minibaas een venster zouden krijgen" → keuze 1.
- [x] **Coach open in de Labyrinth, nog geen baas:** bovenin het bossvak staat "Target a room boss: its model and
      tips show here." (niet meer "hover the delve icon for today's story"). ✅ Rob 14 okt EU-live, screenshot (1 / 19).
- [vervallen, niet getest] **Neem een kamerbaas in je doelwit** (bv. Grukk, Sullied Revenant, King of Souls): het bossvak toont zijn
      naam + 3D-model, en onder "Trash & mechanics" staat alleen nog de regel van díé baas (plus de algemene regels).
- [vervallen, niet getest] Met ◀ ▶ kun je door alle 19 bazen bladeren (incl. Den'zara en Kindo'jan). Laadt een model niet, meld welke.
      Shadowhunter Jo'din en Treasure Hunter Taltrois hebben sinds 14 okt een NPC-nummer van Wowhead (275050,
      274554): bij bladeren hoort er nu ook een model te staan. Geen model = meld het (dan klopt het nummer niet).
- [vervallen, niet getest] **Kistenroute in de Labyrinth (14 okt, 20 kisten van Wowhead/Method):** klik "Chests" in de coach. De pijl
      wijst de dichtstbijzijnde kist aan. **Open die kist** → binnen ~2 s springt de pijl naar de volgende.
      Ligt er géén kist waar de pijl wijst, noteer de kamer + `/dump C_Map.GetPlayerMapPosition(2647,"player")`.
      ⚠️ Na een `/reload` midden in een run begint het "bezocht"-lijstje opnieuw (zo gebouwd).
- [vervallen, niet getest] **Coach-overzicht Labyrinth:** onderaan staan 3 nieuwe regels: niet uit de delve gaan tijdens een run,
      na Kindo'jan nog eens met Kinduru praten, en de bug op de eerste dag (kill telt niet bij 6 kamerbazen).
      ◐ 14 okt: de eerste ("Do not leave the delve") GEZIEN op Robs screenshot; de andere twee vielen buiten beeld.
- [vervallen, niet getest] **Kom je Jo'din of Taltrois tegen: target hem.** Dan hoort het bossvak zijn naam + model + zijn tipregel te tonen,
      en onthoudt MH zijn NPC-nummer. Daarna `/reload` → ik lees `delveBossLearnedIds` uit de SavedVariables. Graag
      een filmpje van het gevecht: we weten van Taltrois nog niets, van Jo'din alleen Soul Shatter.

## 🆕 13 okt — Labyrinth-coach: alle opdrachten + Kindo'jan (uit de nieuwe Zygor-gids)

- [vervallen, niet getest] **Coach → "Trash & mechanics":** twee kopjes, "Tasks with a boss" en "Tasks without a boss", samen ~20 soorten
      opdrachten. Klopt wat je in je volgende kamer krijgt met wat er staat?
- [vervallen, niet getest] **Coach → "Final boss":** Kindo'jan met Den'zara ervoor, en de vier loa-testen op 70% (Akil'zon, Halazzi,
      Nalorakk, Jan'alai). Dit hebben we zelf nog niet gezien; tactiek komt uit Zygor.

## 🆕 13 okt — Oude item-functies (12.1.5 haalt ze weg) → eerst C_Item

Site-chat meldde (warcraft.wiki.gg "Patch 12.1.5/API changes", NIET zelf in de client gemeten) dat 12.1.5 de oude
item-globals weghaalt. Vier plekken hadden geen C_Item-route en zouden stil falen; nu eerst C_Item, oud als terugval.
Op de PTR (70340) testen — daar zou het verschil zichtbaar zijn:
- [vervallen, niet getest] **Gear check (GearEnchantCheck):** gems in je gear staan als klikbare links.
- [vervallen, niet getest] **`/mh export`:** veld 20 (gem-kwaliteit) is niet leeg bij een item met een gem (Armory-"Rank").
- [vervallen, niet getest] **Speelkaart-venster:** item-namen hebben hun kwaliteitskleur (paars/blauw), niet wit.
- [vervallen, niet getest] **Delve-items-popup:** een al gebruikt delve-item (grijs in je tas) wordt herkend als "al gebruikt".
- [x] Even op de PTR: `/dump GetItemGem, IsUsableItem` — zijn de oude globals echt weg (nil)? ✅ Rob 13 okt, PTR 70340
      (= live build): "empty result" → beide nil, GEMETEN weg. Positieve controle `/dump C_Item.GetItemGem, C_Item.IsUsableItem`
      → 2× `<function>` ✅. Bewezen: oude globals weg, C_Item-route bestaat.

## 🆕 13 okt — Coach zonder gat, en de eerste Labyrinth-kist (DelveCoach.lua, DelveChestData.lua)

- [x] Delve Coach opent in de Labyrinth als Labyrinth. ✅ Rob 13 okt, screenshot.
- [x] **Geen leeg vlak meer** tussen de knoppen en "Overview:" in de Labyrinth. ✅ Rob 13 okt. (Gewone delve met
      baasmodel nog niet opnieuw bekeken.)
- [x] **Chests-knop in de Labyrinth:** pijl naar de Sturdy Chest op 37.2, 69.7. ✅ Rob 13 okt — maar hij wijst ook ná het
      looten nog: quest-ID onbekend. Volgende kist: `/mh questdiff` → kist openen → `/mh questdiff now` → `/reload`.
- [x] **Geen "Today's story: Bountiful Delve"** meer. ✅ Rob 13 okt.
- [vervallen, niet getest] **Geen "Final boss — open the Delve Coach?"-knop meer in de Labyrinth** (bij elke kamer-eindfase, zoals Akil'zon's
      Roost, ten onrechte). In gewone delves komt hij nog wél bij de eindbaas.
      ◐ 14 okt: bij binnenkomst geen knop (screenshot). De echte test is het einde van een kamer — nog niet gezien.
- [vervallen, niet getest] **"Copy" valt niet meer over "Overview:"** als de knoppen op twee regels staan (smal coach-venster). Ook in een
      gewone delve met baasmodel: het model staat onder de knoppen, niet eroverheen.
      ◐ 14 okt: Copy netjes in de rij (screenshot), maar de knoppen stonden op ÉÉN regel — de twee-regels-situatie nog niet gezien.

## 🆕 13 okt — Geen omweg via vliegpunten meer (DelveTipMarkup.lua)

Rob 13 okt (PTR): route van Kul'amara (Atal'Aman) naar de Labyrinth stuurde hem naar een vliegpunt, dan naar een ander,
en van dat tweede was de deur verder weg dan van zijn startplek. Nu vergelijkt MH eerst de afstanden (in yards):
lopen naar het vliegpunt + van het tweede vliegpunt naar het doel moet duidelijk korter zijn (onder 75%) dan direct.
- [vervallen, niet getest] **Vanaf Kul'amara** de Labyrinth-route kiezen: de pijl wijst meteen naar de deur, niet naar een vliegpunt.
- [vervallen, niet getest] **Een echte verre route** (bv. Silvermoon → Voidstorm-delve): de vliegpunt-stap komt nog wél.

## 🆕 13 okt — Delve Coach voor de Labyrinth (DelveTipsData.lua + 4 sleutels in 8 talen + esMX)

- [vervallen, niet getest] **Delves-tabblad:** achter "The Labyrinth of Kindo'jan" staat nu het boekje. Klik → Delve Coach met drie
      stukken: Overzicht (eerste keer, Kinduru, schatkamer), Trash & mechanics (de 3 gespeelde kamers + andere
      kamerbazen) en Final boss (Kindo'jan, met "nog niet bekend").
- [vervallen, niet getest] **In de Labyrinth zelf:** opent de Delve Coach nu vanzelf als Labyrinth (niet als Darkway), en verschijnt bij een
      baas de knop "Final boss — open the Delve Coach?" weer — nu met de goede coach erachter.

## 🆕 13 okt — Labyrinth in de delve-lijst + "De eerste keer" in de Codex (Delves.lua, Codex.lua, 8 talen)

- [x] **Delves-tabblad:** rechts onderaan staat "The Labyrinth of Kindo'jan". Klik → route naar Eversong 62.9, 72.0
      (de deur). Op de testserver; op live pas na de patch (EU woensdag). ✅ Rob 13 okt: "labyrinth staat in de lijst".
- [vervallen, niet getest] **Codex → Labyrinth-kaart:** nieuw kopje "The first time" / "De eerste keer": tablet → Kul'amara in Atal'Aman →
      Valeera bij de deur → korte eerste run van 3 kamers → Kinduru → schatkamer → terug naar Kul'amara (toy).
      De routelink in "Getting in" wijst naar 62.9, 72.0.
- [vervallen, niet getest] Hoort de Labyrinth als *Bountiful* geel te worden in de lijst als hij dat op de kaart is? (POI 9036/9037,
      alleen via de naam herkend — op een niet-Engelse client misschien niet.)

## 🆕 13 okt — Labyrinth is geen Darkway meer (DelveTipsData.lua)

Rob 13 okt (PTR): bij Jun'ala opende het bossvenster als "The Darkway". Oorzaak GEMETEN in de code: binnen een
instance liep MH de bovenliggende kaarten af, vond "Eversong Woods", en "Eversong" is een bijnaam van the_darkway.
- [vervallen, niet getest] **In de Labyrinth** (na `/reload`): bij een baas opent geen Darkway-venster meer. (MH kent de Labyrinth nog
      niet, dus er komt nu géén bossvenster — dat is goed.)
- [vervallen, niet getest] **In The Darkway zelf** (live, later): de Delve Coach en het bossvenster kennen de Darkway nog gewoon.
- [vervallen, niet getest] **Labyrinth, bij een kamerbaas:** géén knop "Final boss — open the Delve Coach?" meer (MH heeft geen coach voor
      deze delve). In een gewone delve die MH kent komt die knop nog wél (DelveCoach.lua).

## 🆕 13 okt — "DANGEROUS CAST" niet meer afgekapt (CombatSafety.lua)

- [vervallen, niet getest] Bij een gevaarlijke cast (of `/mh` testknop van Combat Safety): de kop staat er helemaal, "DANGEROUS CAST",
      niet "DANGEROUS C…". Het vak is breder geworden waar nodig.
- [vervallen, niet getest] 🔴 **Geen BugSack-fout meer** "attempt to perform numeric conversion on a secret number value" (CombatSafety.lua:216,
      98× in Robs run 13 okt). Oorzaak: de breedte werd bij élke weergave gemeten, in combat geeft 12.x die als
      secret terug. Nu één keer bij het aanmaken, met secret-check.

## 🆕 13 okt — Delves-tabblad in een smal venster (UI.lua + Delves.lua)

Rob 13 okt, PTR-screenshot: link over de versie en "Read in Codex"; Valeera-regel, Dundun-blok en sleutelregel rechts
afgekapt; ">", kaart- en boek-knopjes van de linkerkolom over de eerste letter van de rechterkolom ("wilight Crypts").
- [vervallen, niet getest] **Titelbalk, Delves-tabblad:** "midnighthelper.com" staat tussen de versie en "Read in Codex", over niets heen.
      Maak het venster smaller: de link schuift op, en verdwijnt als er geen plek is (hij staat ook bij Over).
- [vervallen, niet getest] **Delves-tabblad:** de Valeera-regel, het Dundun-blok en "You have 0 Restored Coffer Keys…" lopen niet meer
      rechts het venster uit maar breken af naar de volgende regel. Ook na het venster smaller/breder slepen.
- [vervallen, niet getest] **Delve-lijst:** rechts staan de namen weer heel ("Twilight Crypts", "Shadowguard Point"); de ">", kaart- en
      boek-knopjes van de linkerkolom staan aan het eind van hun eigen rij.

## 🆕 13 okt — Nek'zali: welke naam hoort bij DBM's nieuwe add-ID?

- [x] Typ in het spel `/dump C_Spell.GetSpellName(1295397)` en `/dump C_Spell.GetSpellName(1297630)`. Wat staat er?
      ✅ Rob 13 okt (PTR 70340): 1295397 = "Restless Amani", 1297630 = "Vessel of Awakening" → tip staat nu op 1295397.
- [vervallen, niet getest] Codex → Raids → Nek'zali, stappen: de eerste regel noemt nu "Restless Amani"-adds (klikbaar).
      (Achtergrond: DBM 12.1.13 waarschuwt voor de adds nu met 1295397, volgens DBM "Restless Amani"; onze tip linkt
      1297630, dat op 4 sep "Vessel of Awakening" bleek. Is 1295397 echt "Restless Amani", dan zet ik de tip op die ID.)

## 🆕 12 okt — Boss-tactiek naar één speler fluisteren (DungeonBossWindow.lua + DungeonLiveCoach.lua)

- [vervallen, niet getest] **Bossvenster, muis op "Share":** tooltip zegt linksklik = hele groep, rechtsklik = één speler.
- [x] **Rechtsklik op Share** in een groep: lijstje met je groepsleden (niet jijzelf). Klik een naam → die speler krijgt
      de tactiek als fluisterbericht; in je chat staat "Steps for <boss> whispered to <naam>." De groep ziet niets.
      ✅ Rob 12 okt "fluisteren werkt" — maar Valeera stond in het lijstje en er kwam 4× "number of messages … limited".
- [x] **Na de fix (12 okt avond):** in een delve staat Valeera NIET meer in het rechtsklik-lijstje. En een share (groep
      of fluisteren) komt regel voor regel binnen, ~1 per seconde, zonder "number of messages … limited".
      ✅ Rob 14 okt (EU-live): "die werken ook goed, die komen nu helemaal over. Naar de persoon die ik wil."
      (Valeera-in-lijstje niet apart genoemd.)
- [vervallen, niet getest] **Rechtsklik zonder groep:** regel in je chat dat er niemand is, met de tip `/mh bossshare <naam>`.
- [vervallen, niet getest] **`/mh bossshare Naam`** (ook iemand buiten je groep): alleen die speler krijgt het.
- [vervallen, niet getest] **Linksklik en kale `/mh bossshare`** gaan nog steeds naar de hele groep — óók direct ná een fluister-share.
- [vervallen, niet getest] **In een gevecht** fluisteren: melding "in combat", en het fluisterbericht gaat vanzelf na het gevecht, naar
      dezelfde speler.

## 🆕 12 okt — Links naar midnighthelper.com

- [vervallen, niet getest] **Over** (knop rechtsboven in MH): onder de tekst staat "Website: midnighthelper.com (klik voor de link)"; klik →
      kopieervak met het adres.
- [x] **Codex:** naast elke artikeltitel een klein blauw "Website" (bij de 12.1.5-kaarten "Patchpagina"); klik →
      kopieervak met de link naar dat artikel. Staat het knopje niet over de titel heen? ✅ Rob 12 okt "knopjes staan goed".
- [x] **Titelbalk:** "midnighthelper.com" groot en blauw in het midden van de titelbalk; klik → kopieervak.
      ✅ Rob 12 okt (na 3 rondes: achter de versie → achter "Me", groter → gecentreerd).
- [vervallen, niet getest] **Role Academy:** helemaal onderaan een grijze regel "Deze cursus staat ook op midnighthelper.com …"; klik →
      kopieervak.
- [vervallen, niet getest] Plak `CURSEFORGE_DESCRIPTION.md` op CurseForge (nieuw website-blok, Russisch bij de talen).

## 🆕 12 okt — "Which spells you press": geen dubbele regels, en een regel over het toetsenblok

- [x] `/mh presses` op je DH: Chaos Strike en Felblade staan er nog maar **één keer** in (Chaos Strike ±60×, niet
      3 regels). Onder de swap-tips staat in oranje dat een swap de vaste plek van je toetsenblok op dit character
      verandert. ✅ Rob 12 okt (screenshot).
- [x] Na `/reload`: de tip "swap Glide with Recuperate" is weg. ✅ Rob 12 okt (screenshot; nieuwe tip Glide ↔ Sigil of
      Misery — CC beschermen? vraag aan Rob).
- [x] Na `/reload`: geen tip meer met Sigil of Misery (of een andere CC/dispel). ✅ Rob 12 okt. Rob 12 okt: "zet CC ook bij de vaste
      spells". Op je DH blijft alleen de tip Felblade ↔ Torment over (of een andere zonder CC/heal/interrupt). Recuperate is een heal en blijft op zijn plek (zoals
      jouw regel van 10 okt: heals schuiven nooit).

## 🆕 12 okt — Doodskaart: tip past bij hoe je doodging

- [vervallen, niet getest] Bij je volgende dood (of meteen `/mh death`): er staat "1 hit" i.p.v. "1 hits", niet meer "from <jijzelf>", en
      de "Next time"-zin past bij wat er gebeurde (melee → wegstappen/defensive; vaak hetzelfde → eruit stappen;
      één grote klap → defensive vlak ervoor). `/mh death` zegt achter `tip=` welke hij koos.

## 🆕 12 okt — Mana Potion bij consumables (healers)

- [vervallen, niet getest] Op een **Holy Paladin, Preservation Evoker, Mistweaver Monk of Resto Druid**: het Consumables-tabblad (en de
      consumables-rij op de speelkaart) toont nu een regel **Mana Potion** (Lightfused Mana Potion) met de uitleg dat hij
      zijn wachttijd deelt met je combat potion. Op andere specs hoort die regel er NIET te staan.

## 🆕 12 okt — Tabblad "Leveling (10-90)"

- [vervallen, niet getest] Het tabblad heet nu **Leveling (10-90)**, met bovenaan het nieuwe blok **"1. Level 10 to 80, for every class"**
      (10 punten). Leest het goed, en is elk spelwoord uitgelegd (Timewalking Campaigns/Chromie Time, War Mode,
      Rested, Heirlooms, Skyriding, Steady Flight, Warband Bank, Knowledge, Adventure Mode)?
- [vervallen, niet getest] **War Mode-getal meten** (op een character van 20+): zet War Mode aan in een hoofdstad en beweeg je muis over de
      buff **Enlisted**. Wat staat er: 10% of 15%? Dan zet ik het getal erin.

## 🆕 12 okt — Toetsenblok: nieuwe spell komt op de verkeerde plek (DH, level 11)

- [x] Op je DH: `/reload`, `/mh block why`, `/reload`. ✅ Rob 12 okt — gelezen; oorzaak gevonden (het oude
      "You learned … Place it"-venster bond 11 toetsen om).
- [x] **Herstel op je DH:** `/reload`, dan `/mh apply undo`. Daarna moeten 1, 2, 3, 4, Q, E, R, F en F4 weer een
      label op het blok hebben, en is de Eye Beam helemaal links weg. ✅ Rob 12 okt (screenshot): alle labels terug,
      Eye Beam op A-3, balk 1 zonder toetsen.
- [x] Bij de volgende level-up met een nieuwe spell: komt de spell op de goede toets? ✅ 12 okt, GEMETEN in SV:
      Throw Glaive op 4, Sigil of Misery op Shift-V; het oude venster heeft niets meer omgezet.
- [x] Kreeg je daarbij maar **één** vraag ("Zet neer")? Het oude "You learned … Place it" hoort weg te blijven.
      ✅ Rob 12 okt: per geleerde spell één vraag van het toetsenblok (Engels "New for your key block: … Place it");
      geen nieuwe bindSnapshot in SV, dus het oude venster deed niets.
- [x] `/mh apply go` op je DH zegt nu dat het toetsenblok je toetsen beheert, en doet niets. ✅ Rob 12 okt (screenshot).

## 🆕 12 okt — Twee zinnen in de levelgids, en Frans "Outil Raids"

- [vervallen, niet getest] **Gids "Midnight leveling (80 naar 90)":** de Prey-zin zegt nu *Astalor Bloodsworn in Astalor's Sanctum (ingang in
      Murder Row)*, telt mee voor de Great Vault, en na een Nightmare-hunt kun je een Nebulous Voidcore uitgeven. De
      Voidforge staat er niet meer in. De XP-zin begint met *Five Warband Mentors: Midnight* (de achievementnaam).
      Klopt de plek als je erheen loopt?
- [vervallen, niet getest] *(Alleen als iemand Frans speelt)* de raidteksten zeggen "Outil Raids" in plaats van "Recherche de raid".

## 🆕 11 okt — Codex-kaart "Bonus rolls with Nebulous Voidcores" (MidnightCodexData.lua)

- [vervallen, niet getest] **Midnight Codex → Currencies → "Bonus rolls with Nebulous Voidcores":** de kaart legt uit hoe je vrijspeelt
      (Decimus → Orin), hoe je Voidcores krijgt (Orin per week, Great Vault) en waar je ze uitgeeft. Bovenaan staat
      hoeveel Voidcores je nu hebt (currency 3418).
- [x] **Klopt je balk?** Je zag "Nebulous Voidcores transmuted: 1/1". Wil je het weten:
      `/dump C_CurrencyInfo.GetCurrencyInfo(3418)` → zeg wat er bij quantity / maxQuantity / totalEarned staat.
      ✅ Rob 11/12 okt (via de research-chat): quantity 1, totalEarned 1, maxQuantity 1, useTotalEarnedForMaxQty
      true, isAccountWide false. Kaart bijgewerkt op 12 okt.
- [x] **Over een week nog eens dezelfde `/dump`** (rond 19/20 okt): is maxQuantity dan 2? Dat bewijst of de grens
      elke week 1 omhoog gaat (nu nog AFGELEID uit Wowhead).
      ✅ Rob 14 okt (EU, na de weekreset, Iceicebaby): balk 1/2; `/dump` maxQuantity 2, quantity 1, totalEarned 1,
      quantityEarnedThisWeek 0, maxWeeklyQuantity 0. Kaarttekst "most likely once a week" → "by one at every weekly reset".
- [vervallen, niet getest] De twee pijl-links in de kaart (Decimus, Orin Straylight) zetten een pijl.

## 🆕 11 okt — Season 1-raids kennen hun nummer (RaidCoachData.lua)

- [vervallen, niet getest] **In The Voidspire, The Dreamrift of March on Quel'Danas, VÓÓR de eerste baas:** open het baasvenster (de
      dungeon-hulp). Het hoort nu meteen de goede raid te tonen, niet "de dungeon van de week". Tot nu toe kon dat
      alleen in The Venomous Abyss.
- [vervallen, niet getest] **Recepten-route naar een dungeon- of raid-ingang** (beroepen → boodschappenlijst → "Route"): de pijl noemt de
      ingang met de naam uit het spel.

## 🆕 11 okt — Battle res & Hero-paneel: ook wie BUITEN combat kan ressen (GroupRezLust.lua)

- [vervallen, niet getest] **In een groep in een dungeon/delve** (of `/mh lust test`): onder "Can revive in combat" staat nu een regel
      **"Can revive out of combat:"** met iedereen die een gewone res heeft (Priest, Paladin, Shaman, Druid, Monk,
      Evoker), met hun spell. In je groep van de screenshot: jij (Druid - Revive) en Sizle (Shaman - Ancestral Spirit).
      De Mage staat er terecht niet bij: die heeft geen res.

## 🆕 11 okt — Russisch taalpakket (Locales/ruRU.lua) + Delve/Bountiful-woord in de/fr/es/pt/it

- [vervallen, niet getest] **Gewone /reload (Engelse client): geen Lua-fout.** Het nieuwe bestand laadt wel, maar stopt meteen (alleen
      een Russische client bouwt het). Zie je in BugSack iets met `ruRU.lua`, meld het.
- [vervallen, niet getest] **Instellingen → Midnight Helper → Taal:** onderaan staat nu "Русский". Op een Engelse client doet kiezen
      niets zichtbaars (net als Deutsch: packs laden alleen op hun eigen client).
- [vervallen, niet getest] *(alleen als je ooit Russisch in Battle.net zet — niet nodig)* MH-venster in het Russisch; let op knoppen
      die te breed zijn: "Найти ближайшую многообещающую вылазку" (tabblad Вылазки и хранилище) en de groepstag
      "РАЗВЕИВАНИЕ".
- [vervallen, niet getest] **Zoekbalk bovenin MH:** typ `delves` → het tabblad "Delves & Vault" staat bovenaan. Typ ook eens iets met
      een hoofdletter erin, bv. `THIS week`: vindt nog steeds "This Week" (de zoekfunctie maakt nu ook Ü/Ä en
      Russische hoofdletters klein).
- [vervallen, niet getest] **Waarom-regels na de patch (14 okt):** 39 kaarten tonen ze nog; alleen de Devourer niet
      (`/mh playcards check` op een Devourer zegt "hidden until rechecked").

## 🆕 11 okt — waarom-regels + quiz + "Goed om te weten" op ALLE 40 kaarten (PlayCards.lua)

- [vervallen, niet getest] Kies per character "Zo speel je": onder elke stap een blauwe "Waarom:"-regel, bovenaan "Goed om te weten:"
      (behalve Elemental/Frost: die hadden het al). Test jezelf: elke vraag heeft het antwoord tussen de 3 knoppen.
- [vervallen, niet getest] Healers (Holy/Disc Priest, Holy Pal, Resto Druid/Shaman, Mistweaver, Preservation): onder de "•"-regel van
      de groepsstap staat nu ook een "Waarom:".
- [vervallen, niet getest] Gouden spellnamen in de nieuwe teksten (niet grijs). Grijs = die spell heb je niet als talent. Opvallend
      nieuw: Balance "Eclipse", Devastation "Azure Sweep", Preservation "Merithra's Blessing", Arms "Heroic Strike",
      Unholy "Festering Scythe", Devourer "Pierce the Veil / Predator's Wake / Reaper's Toll".
- [vervallen, niet getest] Namen zoals Hot Streak, Killing Machine, Surge of Light staan nu als gouden spellnaam (in je eigen spel-taal).
      Grijs terwijl je het talent hebt? Meld welke. Extra check op een Ret Paladin: `/run print(IsPlayerSpell(24275), IsPlayerSpell(1241288))`.
- [vervallen, niet getest] Kaartfouten die verbeterd zijn (lees ze een keer): zie de commits van 11 okt en `docs/WHY_*_2026-10-11.md`.

## 🆕 11 okt — Frost Mage: "Goed om te weten" legt Freezing uit (PlayCards.lua + PlayCardWindow.lua)

- [vervallen, niet getest] Op je Frost Mage, `/reload`, "Zo speel je": direct onder de bovenste zin staat in blauw **"Goed om te weten:"**
      met wat Freezing is (Frostbolt 1, Flurry 3, Ray of Frost 8, max 20; Ice Lance breekt er 4).
- [vervallen, niet getest] De waarom-regel bij Ice Lance zegt nu "breekt 4 Freezing tegelijk", niet meer "al het Freezing".
- [vervallen, niet getest] Op je shamaan staat géén "Goed om te weten"-regel (alleen Frost heeft er een).
- [vervallen, niet getest] Op Frost: in de waarom-regel van stap 1 staat **Icicles** en in "Goed om te weten" **Shatter** als gouden
      spellnaam (niet grijs). Op Elemental: **Lava Surge** in de waarom-regel van stap 3, goud. Grijs? Doe dan
      `/run print(IsPlayerSpell(1246769), IsPlayerSpell(1246832), IsPlayerSpell(77756))` en stuur me de uitkomst.
- [vervallen, niet getest] Frostfire-regel (onderaan, heldentalenten) eindigt nu met "Hou één Fingers of Frost vast: gebruik hem alleen als
      **Thermal Void** actief is, of zodra je er 2 hebt." Thermal Void staat als gouden spellnaam met tooltip.

## 🆕 11 okt — waarom-regels + quiz voor Elemental Shaman (PlayCards.lua)

✅ **Rob 11 okt: "de shamaan goed gekeurd".**
- [x] Op een Elemental Shaman: open "Zo speel je". Onder elke stap en onder AOE staat een blauwe regel "Waarom:".
      `/mh playcards check` zegt "why lines SHOWN" en "quiz: 6 questions".
- [x] Klik "Test jezelf". Stap 3 vraagt naar **Lava Burst** (niet Flame Shock), stap 4 naar **Elemental Blast**, AOE naar
      **Earthquake**. Na elk antwoord staat de waarom-regel eronder.

## 🆕 10 okt — toetsenblok op een nieuw character onder level 10 (KeybindAutoMap.lua)

- [vervallen, niet getest] Op de nieuwe Demon Hunter (level 8): `/reload`, toetsenblok openen. Chaos Strike, Demon's Bite en Fel Rush staan
      NIET meer op de Alt-toetsen als "Not in Midnight Helper's list", maar op hun eigen plek (rotatie, beweging).
      Klik "Update (add new spells)" of "Undo" + opnieuw plaatsen, want het blok staat al op je balken.

## 🆕 10 okt — weeklijst ("This Week") gerepareerd (docs/WEEKLY_CHECK_2026-10-10.md)

- [vervallen, niet getest] Op een level 90 die "Umbral Blessings of the Catalyst" deed: This Week toont **Orin Straylight** (extra Voidcore,
      pin bij de Catalyst). Na kopen: `/run for _,q in ipairs({97981,98012,98015,98016}) do print(q, C_QuestLog.IsQuestFlaggedCompleted(q)) end`
- [vervallen, niet getest] Wie "Into the Vaults of Atal'Utek" deed: **Warleader Abdumati — Purging the Vaults** met pin in de Vaults.
- [vervallen, niet getest] Vereesa zegt nu "Not offered every week…". In een week dat ze niets heeft: `/run print(C_QuestLog.IsQuestFlaggedCompleted(98172))`
- [vervallen, niet getest] Ritual Sites-regel zegt nu "Lady Liadrin … only in some weeks" en wijst naar de givers, niet naar de Bazaar.
- [vervallen, niet getest] Na Halduron's dungeon: `/run for _,q in ipairs({93751,93754,93761,93164}) do print(q, C_QuestLog.IsQuestFlaggedCompleted(q)) end`

## 🆕 10 okt — Death Recap-les: MH zegt zelf wat je doodde (Retrospective.lua)

- [vervallen, niet getest] Val ergens dood (buiten een instance mag). Na 1 s: kaartje met de schedel + chatregel "You fell too far…".
- [vervallen, niet getest] Ga dood door een vijand, het liefst in een **dungeon of delve** (met Carola/Cisca). Het kaartje zegt nu bv.
      "Most of the damage: Shadow Bolt from X (3 hits). The last hit: …" + een tip. Staat er alleen "Open the Death
      Recap…" → dan zijn de gegevens daar geheim; doe dan `/mh death` en `/reload` (dan zie ik waarom).
- [vervallen, niet getest] `/mh death` toont nu ook een regel `lesson: …` = wat het kaartje zou zeggen over je laatste dood.
- [vervallen, niet getest] Nieuw: **Instellingen → Midnight Helper**, schuif "Death card: how long it stays" (5–60 s, standaard nu 20 s,
      was korter). Zet hem op 40, val dood: het kaartje blijft ~40 s staan.
- [vervallen, niet getest] Laatste klap door een gewone mep: er staat nu "The last hit: a melee hit." (was "melee hits").
- [x] GEMETEN 10 okt (Rob): void-sprong geeft nu de "instantly"-tekst. Spring in het niets (Twisting Nether, DH-startgebied). Eerst gaf het kaartje de lava en klappen van dáárvoor
      (Rob, 10 okt). Nu hoort er te staan: "Nothing hit you at the moment you died: something killed you
      instantly…". Doe daarna `/mh death`: de regel "last hit was N s ago" moet meer dan 3 zijn.
- [x] Gewoon doodgaan door een vijand geeft nog steeds "Most of the damage…" (niet per ongeluk "instantly").
      GEMETEN 10 okt (Rob, Mo'arg Brute, 8 hits; `/mh death` "last hit was 22 s ago" = getypt 22 s na de dood).

## 🆕 10 okt — controle van alle specs (docs/SPEC_AUDIT_2026-10-10/): wat jij kunt zien

Ongeveer 25 fouten gerepareerd tegen Blizzards speldata; niets daarvan in het spel gezien. Alleen wat je character heeft:
- [vervallen, niet getest] Warlockie: roep een Felhunter op, stuur hem weg, `/reload`. De knop biedt nu de Felhunter (je laatste demon).
- [vervallen, niet getest] Een Holy Paladin (als je die hebt): geen Rebuke-macro meer; met Beacon of Virtue geen "Beacon of Light"-melding.
- [vervallen, niet getest] Een Frost DK met Breath of Sindragosa: die staat nu NIET grijs op de kaart en wel in de toolkit.
- [vervallen, niet getest] Een Shaman: Flame Shock niet meer grijs op de kaart; Enhancement vraagt Flametongue op het linker wapen.
- [vervallen, niet getest] Heb je een character dat niet hier staat: open de Zo-speel-je-kaart en zeg het als iets grijs staat dat je wél hebt.

## 🆕 10 okt — beroepen: bij elke node staat nu op welk tab hij zit (Profession.lua + ProfessionAcademy.lua)

- [vervallen, niet getest] Op je Jewelcrafter met punten over: Tools > Professions. Onder "Individual nodes…" staat nu bv.
      "Calculated Concentration (0/30) - tab Thoughtful Throughput, opens once Thoughtful Throughput has points".
      Klopt dat tab als je het in het spel opent? En staan de nodes die je NU kunt kopen bovenaan?
- [vervallen, niet getest] Rob 10 okt GEMETEN: 5 punten in Thoughtful Throughput openen Calculated Concentration, de andere twee blijven
      dicht. Nu moet MH zeggen "Thoughtful Throughput has 5 points: the next choice in this tab is open…", met
      Calculated Concentration zonder "not open yet" en de andere twee mét "not open yet".

## 🆕 10 okt — Demonology: pet-knop roept Felguard op i.p.v. Imp (MissingBuff.lua)

- [x] ✅ Rob 10 okt: Warlockie (Demonology) krijgt nu de Felguard.
- [vervallen, niet getest] Zelfde soort fout, ook gerepareerd: Warrior zonder stance → Arms ziet Battle Stance, Fury Berserker Stance,
      Prot Defensive Stance. Rogue zonder gif → Assassination ziet Deadly Poison (Outlaw/Sub blijven Instant).
      (Heb je zo'n character: stance/gif uit, `/reload`, kijk welke knop er staat.)

## 🆕 10 okt — meten voor de Knowledge-teller en de Death Recap-les (`/mh kp weekly`, `/mh death`)

- [vervallen, niet getest] Typ `/mh kp weekly` (NIET `/mh kp`: dat is een andere meting) en `/reload`. Haal je deze week nog een treatise
      of een Knowledge-drop? Doe dan direct daarna nog eens `/mh kp weekly`: een regel die van "none" naar een getal
      gaat is precies wat ik zoek.
- [x] ✅ Rob 10 okt: val van een klif buiten een instance → recap leesbaar, 0 geheime velden.
- [vervallen, niet getest] Nog een keer, maar dan door een **vijand in een dungeon of delve**: `/mh death`, `/reload`. Daar zit de spell
      en de naam van wie je raakte in, en Blizzard is daar strenger.
- [vervallen, niet getest] Klik bij dat sterven op het MH-kaartje met de schedel: opent Blizzards Death Recap nu wél het venster?

## 🆕 10 okt — healer-cooldowns: Celestial Conduit en Tip the Scales (HealerCooldowns.lua)

- [vervallen, niet getest] Op een Mistweaver met de hero-talenten Conduit of the Celestials: `/mh healcds` noemt Celestial Conduit.
      Op een Preservation-evoker: Tip the Scales. (Heb je die niet: overslaan.)

## 🆕 10 okt — Trading Post: "already own" ook voor transmog, speelgoed en sets (TradingPost.lua)

- [vervallen, niet getest] Loop in Silvermoon naar de Trading Post en open hem één keer. Daarna het Trading Post-tabblad in MH.
      Wat je al hebt (ook transmog en toys, niet alleen mounts en pets) staat grijs met "(already own)".
- [x] ✅ Rob 10 okt: `/mh tp why` + reload. Transmog-check en set-check zeggen allebei "ja" bij gekochte spullen
      (Horseman's schild en ensemble). Daarna erbij: de exacte appearance-check (itemModifiedAppearanceID).
- [vervallen, niet getest] Zie je iets als "already own" dat je NIET hebt? Zeg welk item: dat zou een fout zijn.

## 🆕 10 okt — speelkaart Frost Mage: waarom-regels + quiz (PlayCards.lua + PlayCardWindow.lua)

✅ **Rob 11 okt: "getest op de frost mage en keur het goed, ook de site"** (screenshot: vraag 3 van 6, fout gekozen →
rood/groen, "Net niet: het is Ice Lance." + waarom-regel). Afgevinkt wat dat dekt; de rest is niet apart gezien.
- [x] Op je Frost Mage: `/reload`, `/mh play`. Onder elke stap staat een blauwe regel **"Waarom:"**, ook onder "Meer vijanden".
- [vervallen, niet getest] `/mh playcards check`: de laatste regel zegt `why lines SHOWN` en `quiz: 6 questions`.
- [x] Onder de kaart staat de knop **"Test jezelf: quiz"**. Klik: vraag 1 van 6, een zin met een open plek, drie knoppen met icoon.
- [x] Kies fout: jouw knop rood, de goede groen, "Net niet: het is …" en de waarom-regel. Kies goed: "Goed!".
- [vervallen, niet getest] Na vraag 6: score, "Opnieuw" en "Terug naar de kaart" werken. Het tabblad "Hoe je speelt" blijft onderstreept tijdens de quiz.
- [vervallen, niet getest] Op een andere spec (bv. Arcane via het spec-icoontje): géén quizknop en geen waarom-regels.
- [vervallen, niet getest] Carola: laat haar de quiz doen en kijk of ze de zinnen snapt (dat is de echte test).

## 🆕 10 okt — `/mh export`: realm en regio erbij (GearExport.lua)

- [x] Typ `/run print(GetCurrentRegion())`. Je moet **3** zien (EU). ✅ Rob 10 okt: 3.
- [vervallen, niet getest] `/reload`, `/mh export`. De tweede regel eindigt nu op `;realm=Khadgar;region=eu` (of je echte realm).
- [vervallen, niet getest] Plak het op midnighthelper.com/armory/: je ziet je eigen character als plaatje (site-kant).
- [x] ✅ Rob 10 okt, Earthshammy (Elemental): tier = setnummer 2065 op hoofd, schouders, borst en benen, leeg op de
      rest; gems/enchants per regel (`g1/1e1` op de ringen, `g0/1e0` op de nek = lege socket); effect `e` op trinkets
      en het wapen. Geen embellished item op dat character (embellishment nog niet gemeten).
- [x] ✅ Rob 10 okt (Warlockie + Theexodus): `level=83` / `level=90`; ring `7997/240910|Enchant Ring - Nature's
      Fury|2/2`; ruwe regel heeft `|A:Professions-ChatIcon-Quality-12-Tier2:20:20|a`. Alles werkt.
- [vervallen, niet getest] (oud, gedaan via Theexodus) Welke enchant en gem + kwaliteit + level: `/reload`, `/mh export` op Earthshammy. Stuur me de char-regel
      (eindigt nu op `;level=90` of je echte level) en één ringregel: na `g1/1e1` staan
      `<enchantnummer>/<gemnummer>`, de enchant-naam, en de kwaliteit (`2/2` o.i.d.). Daarna `/reload`: dan lees ik
      de ruwe enchant-regels (gearExportEnchantRaw) om te zien of het kwaliteitsicoon er echt in staat.
- [vervallen, niet getest] Gems en enchants: in dezelfde export eindigt elke regel nu op iets als `g1/1e1` (1 van 1 socket gevuld,
      enchant erop). Een item met een lege socket of zonder enchant moet dat laten zien (bv. `g0/1e0`).
- [vervallen, niet getest] Tier en embellishment: `/mh export` op een character met een **tier-stuk** (hoofd/schouders/borst/handen/benen
      uit de raid-set) en een **embellished** item. Stuur me die twee regels: de tier-regel eindigt op een setnummer,
      de embellished-regel heeft `cEmbellished:2` (verwacht). De site-chat wil echte regels om tegen te testen.
- [vervallen, niet getest] Rode eis: leg iets in je tas dat je NIET mag dragen (te hoog level, andere class: de tooltip toont een rode
      regel). `/mh export`, `/reload`. Het staat niet in de export, en ik lees in je bestand waarom (gearExportSkips).
- [vervallen, niet getest] (Alleen als je zo'n character hebt, NIET speciaal aanmaken.) Op een Fury Warrior, Enhancement Shaman of Frost DK met een één-hands wapen in de tas: in de export eindigt
      dat wapen op `|a|` (mag in beide handen). Op Warlockie blijft het `|1|`.
- [x] ✅ Rob 10 okt: geen schild meer. Op Warlockie (Steelbark Bulwark in de tas): `/mh export` heeft GEEN regel `B|offhand|…|Steelbark Bulwark` meer,
      en de site raadt geen schild meer aan. Wapens die je class niet kan dragen vallen ook weg.

## 🆕 10 okt — vrienden markeren: ieder zijn eigen icoon (FriendMarks.lua + FastMark.lua)

Gebouwd, niet getest. Rob: "ik ben altijd Ster, Carola oranje rondje, Cisca de paarse diamond". Rob koos beide routes.
- [vervallen, niet getest] **Jezelf:** `/mh mark me star` → chat "Jouw icoon: 1". Geldt voor al je characters (account).
- [vervallen, niet getest] **Route B (alleen jij hebt MH nodig):** `/mh mark friend <Carola's BattleTag> circle` en
  `/mh mark friend <Cisca's BattleTag> diamond`. In een groep met hen → `/mh mark friends`: staat er
  "Battle.net friends in WoW right now: N" met hun character? (0 terwijl ze online zijn = Blizzard geeft het niet → zeg het.)
- [vervallen, niet getest] **Route A (zij hebben de nieuwe MH, dus pas na de volgende build):** zij typen zelf `/mh mark me circle` /
  `diamond`; jouw `/mh mark friends` toont "via MH: …".
- [vervallen, niet getest] **Knop:** markeerbalk, na het schild: een vriendjes-knop. Muis erop → wie welk icoon krijgt. Klik → iedereen zijn
  icoon. Niemand bekend → grijs + uitleg.
- [x] ✅ Rob 10 okt GEMETEN: de Battle.net-route WERKT (`/mh mark friends` zag magedobby-khadgar = carola#2875 en
  sizle-lightbringer = sizzle#21918). Dobby kreeg geen marker omdat de ingetypte tags fout waren (dobby#8274, sizzle#0617).
- [x] ✅ Rob 10 okt: met de juiste BattleTag krijgt Dobby (MageDobby, carola#2875) het rondje via de vriendenknop.
- [vervallen, niet getest] Nu ook met een charactername: `/mh mark friend MageDobby circle` → chat noemt carola#2875. Oude foute links weg:
  `/mh mark friend dobby#8274 off` en `/mh mark friend sizzle#0617 off`. `/mh mark friends` zet "(not in WoW right now -
  or a typo?)" achter een link die niet klopt.
- [vervallen, niet getest] **Met Carola en Cisca (Rob, 10 okt: "in een delve, raid of dungeon"):** in een **delve** en een **dungeon**
  (party: iedereen mag markeren) één klik → jij ster, Carola rondje, Cisca diamant. In een **raid** werkt het alleen
  als jij leider of assistent bent; anders is de knop grijs en zegt de tooltip waarom.

## 🆕 10 okt — Codex "De Midnight-campagne beginnen" aangevuld (Codex.lua)

Rob vroeg een artikel "Midnight beginnen op een alt" — het bestond al (8 sep, door Rob gemeten); hij koos aanvullen.
- [vervallen, niet getest] Codex → Start → "De Midnight-campagne beginnen": nieuw zijn "Kwijt? Loop Stormwind of Orgrimmar binnen…" en het
  punt "Die skip-regel verschijnt pas als een personage op je account de achievement Midnight heeft".
- ✅ GEMETEN Rob 10 okt: `GetAchievementInfo(42045)` = "Midnight", true op zijn account.
- Weggelaten tot gemeten: de level-90-skip bij Soridormi (Silvermoon, Wayfarer's Rest). Meten bij haar met
  `/run for _,o in ipairs(C_GossipInfo.GetOptions()) do print(o.gossipOptionID,o.name) end`.

## 🆕 10 okt — vijf instellingen erbij (SettingsDefs.lua, idee B4)

Gebouwd, niet getest. Instellingen (`/mh` → Instellingen, of Blizzards paneel).
- [vervallen, niet getest] **Waarschuwingen:** "Korte meldingen (toasts)", "Toast: ongebruikte Trovehunter's Bounty", "Geluid als er iets nieuws
  in je tassen open kan", "Delve-itemsvenster vanzelf openen". Alle vier staan AAN (zoals altijd al). Zet er één uit →
  `/reload` → staat nog uit, en het ding zelf doet het niet meer.
- [vervallen, niet getest] **Geavanceerd:** schuifje "Hoeveel extra muisknoppen…" 0-6 (= `/mh mouse N`).
- Kick-alarm staat er bewust NIET bij: toont op 12.1 niets (`SettingsDefs.lua`, regel bij Geavanceerd).

## 🆕 10 okt — markeerbalk: tank en healer met één klik (FastMark.lua)

Gebouwd, niet getest. `/mh mark` (balk aan) in een groep.
- ✅ Rob 10 okt: markeren werkt, ook in een follower dungeon. ❌ Icoon was hetzelfde als de rollen-check ernaast
  (uitsnede faalde) → nu een gewoon schild-icoon (`Ability_Defend`). **Hertest:** twee verschillende icoontjes.
- [x] Onderste rij, na het rode kruisje: een **schild-knop**. Muis erop → tooltip met wie de tank en de healer is.
- [vervallen, niet getest] **Klik** → blauw vierkant op de tank, groene driehoek op de healer. (Komt er "You can't do this right now" of
  maar één markering? Zeg het: dan staan twee markeringen in één klik te snel achter elkaar.)
- [vervallen, niet getest] **Alleen een tank of alleen een healer** in de groep → alleen die krijgt een markering, niets loopt vast
  (Rob: "mag niet vastlopen"). **Niemand met een rol** → knop grijs, tooltip zegt waarom, klik doet niets.
- [vervallen, niet getest] Buitenlandse client (als iemand dat heeft): de knop gebruikt de vertaalde `/tm`.

## 🆕 10 okt — toetsenblok: alle personages in één keer naar de site (KeyBlock.lua)

Gebouwd, niet getest. Site-chat op Robs verzoek: "al je karakters in één keer naar de site".
- [vervallen, niet getest] **Bewaren:** log in op een personage MET het toetsenblok geplaatst (of klik Plaatsen/Bijwerken) → zijn code wordt
  bewaard. Ongedaan maken haalt hem weg. Doe dit op 2-3 personages.
- [vervallen, niet getest] **Knop:** `/mh block` → Cheat sheet → linksonder **"Alle personages"** → één kopieervak met alle codes, dit
  personage eerst, boven elke code "# naam - spec - updated <datum>".
- [vervallen, niet getest] **Site:** plakken op midnighthelper.com/keyblock/ zodra de site-chat meldt dat hun kant live is.
- (Geen personage met het blok? Dan zegt de knop in de chat dat er nog niets bewaard is.)

## 🆕 10 okt — `/mh presses` in een venster + SimC-ras (KeyPresses.lua, SimcExport.lua)

Gebouwd, niet getest. Rob, 9 okt: "in een chat is het onoverzichtelijk".
- [vervallen, niet getest] **Venster:** typ `/mh presses` → een venster "Welke spells je drukt" (niet meer de chat). Per regel: icoon, spell,
  aantal, [toets], makkelijk/gaat/lastig. Daaronder de ruil-tip (of "al op makkelijke toetsen") en de regel in grijs.
- [vervallen, niet getest] **Knoppen:** "Tellen uitzetten"/"Tellen aanzetten" wisselt (en zegt het in de chat). "Wis deze spec" vraagt eerst
  "Klik nog eens om te wissen"; na de tweede klik is de lijst leeg.
- [vervallen, niet getest] **Na een gevecht:** laat het venster open staan, vecht → na het gevecht staan de nieuwe tellingen er vanzelf.
- [vervallen, niet getest] **Shift+scroll** maakt het venster groter/kleiner, slepen werkt, Escape sluit.
- [vervallen, niet getest] `/mh presses why` geeft nog steeds de lijst in de chat (diagnose).
- [vervallen, niet getest] **SimC (`/mh raidbots`):** alleen te zien met een personage van ras-id 95/96 (SimC noemt ze "skyborne"; welk ras dat in het spel
  heet is NIET gemeten). Heb je dat niet: overslaan.
  Op elk ander personage: de `race=`-regel is hetzelfde als vóór vandaag.
- ✅ Rob 10 okt: ruil-knop werkt (niet in gevecht geprobeerd). Twee wensen → gebouwd, hertest open:
  - ✅ Rob: ruilen + "terugdraaien (2)" + "alles terugdraaien (2)" werken; Flash Heal weg uit de tips.
  - [vervallen, niet getest] **0x-spells als ruilplek** (Rob: "maar 2 adviezen"; hij koos ja): vanaf 5 gevechten mag een drukke spell ook
    naar een makkelijke toets waarvan je de spell NOOIT drukte; tip toont dan "(0x, on …)". Max 3 tips. Heals,
    interrupts en Blijf leven blijven ook dan staan.
  - [x] **Heals ruilen nooit**, en interrupts/Blijf leven-spells ook niet — in géén richting (Flash Heal stond als
    "druk" in een tip). Priest → `/mh presses`: geen tip meer met Flash Heal. (Potions/items konden al nooit: LiveKeys
    leest alleen spells en macro's.)
  - [vervallen, niet getest] **Meer dan één terugdraaien:** MH onthoudt alle ruilen (max 20). "Laatste ruil terugdraaien (N)" gaat er één
    terug, nieuwste eerst; "Alles terugdraaien (N)" zet alles terug. Ook na "Wis deze spec" blijven ze terug te draaien.
- [x] **Ruil-knop (Rob koos: knop per tip + terugdraaien):** Priest → `/mh presses` → achter elke tip een knop "Ruil".
  Klik er één (buiten gevecht) → groene regel "Geruild: X staat nu op …, Y op …" (ook in de chat), en de twee spells
  staan echt verwisseld op je balk; de lijst toont meteen de nieuwe toetsen. Knop "Laatste ruil terugdraaien" zet het
  terug (ook na `/reload`). In gevecht: oranje "Niet tijdens een gevecht". Lukt een ruil niet, dan zegt hij dat (oranje)
  en is er niets veranderd.
- [x] **Venster met tellingen** ✅ Rob 10 okt: BM Hunter (7 regels, "al op makkelijke toetsen") en Shadow Priest
  (8 regels, 3 ruil-tips). ❌ Priest-tip "ruil Mind Flay met **Silence**": een interrupt hoort niet naar een lastige
  toets → gerepareerd: interrupts (role "interrupt") en alles met een Blijf leven-regel (`survival`) uit
  KeybindRoleClassifier worden nooit als "rustige" ruilpartner gekozen. **Hertest:** Priest → `/mh presses`: geen
  Silence meer in de tips.
- [x] **Leeg venster** (Rob, Warlock 82, 10 okt): opent ✅. Tekst zei "turn it on" terwijl tellen aan stond → nu
  `PRESSES_NONE_ON` ("tellen staat aan, de lijst vult zich vanzelf") en "Wis deze spec" alleen als er iets geteld is.
- [x] **Bartender/ElvUI (LiveKeys.lua) — bij Rob mag NIETS veranderen** ✅ Rob 10 okt, Warlock: "sources: Blizzard 24,
  Bartender4 0, ElvUI 0, other LibActionButton 0", elke spell "Blizzard". (hij heeft geen van beide): `/mh playkeys` →
  regel 2 "sources: Blizzard N, Bartender4 0, ElvUI 0, other LibActionButton 0", en dezelfde toetsen als gisteren op de
  "Zo speel je"-kaart en in `/mh presses`. (CooldownManagerCentered laadt LibActionButton, maar maakt alleen
  flyout-knoppen zonder toets — GELEZEN in zijn code.)
- [vervallen, niet getest] **Iemand MET Bartender4 of ElvUI** (Cisca/beta-speler): `/mh playkeys` → "Bartender4 N" of "ElvUI N" > 0, en de
  toetsen op de kaart kloppen met de balk. Klopt het niet: de 5 `/run`-regels onderaan
  `docs/BAR_ADDONS_LIVEKEYS_2026-10-09.md` en een screenshot.

## 🆕 9 okt — welke spells druk je het vaakst (`/mh presses`, KeyPresses.lua)

Gebouwd, niet getest. Rob: "ik ga van 1 naar Ctrl 5 naar Shift 2 …".
- [vervallen, niet getest] **Aanzetten:** typ `/mh presses on` → chat: "Tellen staat AAN …". Of: Instellingen → Gevecht → "Tel welke spells
  je drukt" (staat standaard UIT).
- [vervallen, niet getest] **Tellen:** speel 3-4 gevechten (een delve of dungeon is genoeg), typ dan `/mh presses`. Je ziet maximaal 8 regels:
  spell, aantal keer, `[toets]` en makkelijk/gaat/lastig. Klopt de toets met wat er op je balk staat?
- [vervallen, niet getest] **Tip:** staat een spell die je vaak drukt op een lastige toets (Ctrl/Alt), dan staat eronder "Tip: ruil X met Y".
  Voelt die ruil logisch? (Er verplaatst NIETS vanzelf.)
- [vervallen, niet getest] **Per personage/spec:** wissel van spec of personage → `/mh presses` zegt "Nog niets geteld" (eigen lijst).
- [vervallen, niet getest] **Niets raars erin:** staan er spells in die je nooit drukt (passieve dingen, procs)? Typ dan `/mh presses why` en
  maak een screenshot — dan zie ik wat er geteld is.
  ❌→🔧 Rob 9 okt avond, BM Hunter: "1. Auto Shot 16x not on a key" bovenaan. Gerepareerd: Auto Shot (75) en Auto
  Attack (6603) tellen niet meer mee (soort "auto" in `/mh presses why`). Rest van zijn lijst klopte (toetsen,
  makkelijk/gaat; Bestial Wrath op [0] = duimknop = makkelijk). **Hertest:** na `/reload` → `/mh presses` op de Hunter:
  geen Auto Shot meer. Staat hij er tóch: `/mh presses why` → welk id? ✅ Hertest Rob: Auto Shot weg.
- [vervallen, niet getest] **Duimknoppen:** jouw 6 7 8 9 0 - op balk 8 moeten "makkelijk" heten (MH weet van je pad via de bar-8-knop).
  Staat er "gaat"/"lastig" bij, zeg het.

## 🆕 9 okt — knop bij het veilinghuis (AuctionShopButton.lua)

Gebouwd. Rob, aan het veilinghuis: "hoe maakte ik ook alweer mijn raid lijstje voor ah?"
✅ **Rob 9 okt avond: "deze werkt".** Screenshot: nlNL-tekst "Boodschappen: 4 te kopen", rechtsonder, naast de
Auctionator-tab en er niet overheen.
- [x] **Veilinghuis openen:** onder het venster, rechtsonder, een knop "Shopping list (MH)" — of "Shopping list: N to buy"
  als je raid- of beroepenlijst iets mist. Staat hij niet over iets heen (Auctionator-tabs, Blizzards eigen knoppen)?
- [x] **Klik:** het venster "Klaar voor de raid?" gaat open, met de tabs Raid | Beroep.
- [vervallen, niet getest] **Koop iets van de lijst:** het getal op de knop zakt vanzelf. ❌ Rob 9 okt avond: zakte pas na mail ophalen
  (het venster zette het wél meteen "in de mail"). Gerepareerd dezelfde avond: de aankoop werkt nu ook de knop bij
  (`ns.RefreshAhShopButton`). ❌ Hertest (met /reload): stond op 2 vóór de Amethyst, bleef 2 erna. Screenshot
  erna: raid-venster 1× Koop (Head), Beroep 1× "Pluk 1" (Nocturnal Lotus telt als te kopen) → 2 klopt ná de koop;
  vóór de koop had het dus 3 moeten zijn. Onopgelost. Nu: tooltip toont "Raid: X · Beroep: Y" en elke hertelling
  schrijft naar `ns.db.ahShopProbe` (reden open/bags/purchase). **Test:** veilinghuis open → muis op knop (noteer X/Y)
  → koop 1 ding van de lijst → muis erop → `/reload` → zeg het mij, ik lees de SV.
  ✅ Meting Rob (zelfde avond): Raid 1 → koop Head-enchant → Raid 0, meteen. **Raid-deel werkt.** Maar Beroep sprong
  0 → 1 zonder dat er iets veranderde: `CraftShopTerms` slaat een item over waarvan de naam nog niet geladen is
  (Nocturnal Lotus). Dat verklaart ook de "2 vóór en 2 ná" van eerder. Gerepareerd: knop telt via
  `ns.CraftShopToBuyCount` (zonder naam). **Hertest:** na `/reload` meteen veilinghuis open → muis op knop: Beroep
  moet direct goed staan (niet eerst 0).
  📌 Rob koos dezelfde avond: **"Pluk" telt niet mee.** Beroep telt nu alleen rijen met rode "Koop N" (niet Pluk, Maak,
  Handelaar). **Test:** Beroep in de tooltip = aantal rode "Koop" in de tab Beroep.

## 🆕 9 okt avond — Discovery-recepten: hoe, niet alleen waar (CraftShoppingList.lua)

Rob koos (a + b). Gebouwd, niet getest.
- [vervallen, niet getest] **Flask of the Magisters op je lijst (Alchemy):** onder "Discovery: Camberon's Cauldron" staat een gele regel:
  maak eerst 10 Sin'dorei Flasks, daarna 50 Artisan Alchemist's Moxie, specialisatie Fluent in Flasks -> Sin'dorei
  Specialist. ⚠️ Bronnen uit 12.0.x: **ga bij de ketel staan en kijk of de opdracht klopt** (10×? 50 Moxie? nog meer?).
- [vervallen, niet getest] **Een ander Discovery-recept op je lijst:** gele regel "Zo: ga naar die ketel en doe zijn opdracht …".
- ⚠️ Op een niet-Engelse client zie je alleen de Magisters-regel (de algemene regel zoekt het Engelse woord
  "Discovery"). de/fr/es/pt/it vertaald door mh-writer (namen als Fluent in Flasks bleven Engels).

✅ **Barkskin** (Rob, Resto Druid, 9 okt avond): Academy heal-route toont "(1 min)" = 60 s.
✅ (hertest Rob, screenshot: netjes onder elkaar) **Academy "Rol wisselen, stap voor stap":** lange stapteksten liepen over elkaar (tekst gecentreerd op het
hokje). Gerepareerd: tekst hangt nu linksboven naast het hokje. **Test:** `/mh academy` → Tank-track → die lijst
leest netjes onder elkaar, links uitgelijnd.
✅ **Earth Elemental MET Primordial Bond** (Rob, Elemental, 9 okt avond): staat als grote knop op Blijf leven.
(Dat hij het talent heeft is afgeleid uit de tooltip "+15% max health"; "zonder" niet getest.)
- [x] **Instellingen → Venster → "Boodschappenknop bij het veilinghuis" uit:** knop weg (ook bij een open veilinghuis).

## 🆕 9 okt — twee schakelaars erbij, en Kith'ix staat klaar voor patchdag

Gebouwd, niet getest.
- [vervallen, niet getest] **Instellingen → Geavanceerd:** twee nieuwe schakelaars: "Houd toets 1 vrij voor de Assisted Combat-knop" (= `/mh sba`)
  en "Laat de toetsindeling mijn muisknoppen gebruiken" (= `/mh mouse fill`). Beide standaard UIT. Zet er één aan, dan
  `/reload` en `/mh apply` (alleen kijken, niet uitvoeren): verandert de voorgestelde indeling zoals de uitleg zegt?
- [x] **NU (12.1):** Raids-pagina → "The Unbinding of Kith'ix" staat er NIET (verborgen tot 12.1.5). Staat hij er wél, zeg het.
  ✅ Rob 9 okt avond.
- [x] **Schakelaars in Geavanceerd** staan er; `/mh apply`-proefrun gaf de normale "bar te kort"-melding. ✅ Rob 9 okt avond.
- [vervallen, niet getest] **Patchdag 13/14 okt:** Kith'ix verschijnt vanzelf, met bovenaan de grijze notitie "Geschreven vóór patch 12.1.5…".
  Kloppen de spell-links (namen)? Daarna: `/mh ej save` in de raid → journalInstanceID + ingang toevoegen; DBM-module
  checken; zwakke regels nalopen (lijst in `docs/KITHIX_TIPS_DRAFT_2026-10-09.md`).

## 🆕 9 okt — Barkskin 60 s, Earth Elemental alleen met Primordial Bond (docs/SMALL_FACTS_2026-10-09.md)

Gebouwd, niet getest.
- [vervallen, niet getest] **Resto Druid, Role Academy (heal-route) → je defensives:** Barkskin zegt **(60s)**, niet meer (45s).
- [vervallen, niet getest] **Shaman, Zo speel je → Blijf leven:** ZONDER het talent Primordial Bond staat Earth Elemental er NIET meer bij;
  MET Primordial Bond wel (als grote knop). Heb je geen Shaman met/zonder het talent: overslaan en zeggen.

## 🆕 9 okt — healer-cooldowns: 4 erbij, Salvation eruit (docs/HEALER_CDS_FACTS_2026-10-09.md)

Gebouwd, niet getest. Typ `/mh healcds` op de healer.
- [x] **Holy Priest:** Holy Word: Salvation staat er NIET meer (bestaat al sinds 11.1 niet). Bovenaan staat nu Divine Hymn.
  ✅ Rob 9 okt avond, screenshot.
- [x] **Resto Druid:** Innervate staat erbij (onderaan). ✅ Rob 9 okt avond, screenshot `/mh healcds`.
- [x] **Holy Paladin:** Avenging Crusader staat onder Avenging Wrath (het is een keuze: je hebt er één van).
  ✅ Rob 9 okt avond, screenshot (Wrath 2 min, Crusader 1 min, Divine Toll 1 min).
- [vervallen, niet getest] **Mistweaver / Preservation** (alleen als je die hebt): Restoral onder Revival; Zephyr bij de Evoker.

## 🆕 9 okt — schat-stappen vinken nu af (Gift of the Cycle, Brine-Crusted Chest)

Gebouwd, niet getest. Alleen voor een personage dat de schat nog NIET heeft.
- [vervallen, niet getest] **Harandar, Gift of the Cycle:** (Rob 9 okt avond: al gedaan op zijn personage → hier niet te testen) zet de schat-route aan (Achievements → Treasures of Harandar). De pijl gaat eerst
  naar het kussen, dan het altaar van Wisdom, dan het mes, enz. — nooit naar een altaar vóór je het voorwerp hebt. Na elk
  altaar vinkt die stap af in het hint-venster.
- [vervallen, niet getest] **Coiled Isle, Brine-Crusted Chest:** eerst de clam (pijl), en na het plaatsen van de parel vinken beide stappen af.
  Rob 9 okt avond: pijl ging naar de kist, maar via de knop "-> the chest" in het hint-venster (die stuurt direct
  naar de kist = goed). GEMETEN: quest 96001 false, parels 0. **Opnieuw:** start de route via Achievements.
  ⏸ Rob: overgeslagen (moet op de Isle eerst nog veel doen); blijft open, niet blokkerend voor 4.7.5.

## 🆕 8 okt — "grote defensive"-zin en de heal-soorten (docs/ROLE_SWITCH_FACTS8)

Gebouwd, niet getest.
- [vervallen, niet getest] **Paladin (elke spec), Zo speel je → tab Blijf leven:** onder Divine Shield staat "een grote: druk hem net vóór de
  hardste klap die je ziet aankomen" — zónder "(een immuniteit mag ook als je bijna dood bent)". De Lay on Hands-noot
  staat er nog achter.
- [vervallen, niet getest] **Holy Priest, zelfde tab:** onder Guardian Spirit een eigen zin: "als je health blijft zakken: ga je dood, dan redt
  hij je één keer …". **Frost Mage:** onder Cold Snap "na je grote (Ice Block of Ice Cold): hij maakt die weer klaar …".
- [vervallen, niet getest] **Healer, Role Academy → heal-toolkit (Holy Paladin):** Holy Shock en Word of Glory hebben het label [Instant],
  Flash of Light [Korte cast], Holy Light [Groot]. Resto Druid: Swiftmend [Instant], Regrowth [Korte cast]. Geen rauwe
  sleutel (HEALCORE_…) te zien.
- [vervallen, niet getest] **Holy Paladin, heal-toolkit:** volgorde Holy Shock, Word of Glory (of Eternal Flame), dan Flash of Light, Holy Light.
  **Holy Priest:** Holy Word: Serenity staat er nu, met [Instant], vóór Flash Heal.
- [vervallen, niet getest] **Holy/Ret Paladin, Blijf leven:** achter Blessing of Protection staat "… Geeft Forbearance: 30 s geen Divine Shield of
  Lay on Hands op jezelf". Prot met Spellwarding: zelfde zin bij Spellwarding. Rogue (Evasion, Cloak) zegt nog gewoon
  "alleen tegen fysieke schade" / "alleen tegen magie", zonder Forbearance.

## 🆕 7 okt — 12.1.5 Codex-kaartjes (pas zichtbaar vanaf 12.1.5)

- [vervallen, niet getest] **(8 okt) Patchdag, `/mh codex` → Dungeons:** nieuw kaartje "Keystone Myth is back (12.1.5)". Live vóór de patch: NIET
  zichtbaar. Klopt 3600 in je eigen Achievements-venster (de testdata zei "[PH]")?
- [vervallen, niet getest] **(8 okt) Labyrinth, Kindo'jan:** moeten de 4 Amani Headhunters dood of niet? (Wowhead 7 okt: niet nodig, en hun bijlen
  tellen niet voor Disgraceful Display.) Ons kaartje zegt nu alleen "4 Amani Headhunters appear". En: ben je je kamers kwijt
  als je het Labyrinth verlaat? (bronnen spreken elkaar tegen)
- [vervallen, niet getest] **(8 okt) Events-scherm (PTR of na de patch):** Aqir Invasion staat maar 1× in "Coming up".

Gebouwd, niet getest. Op de **live** client horen ze NIET te bestaan; op de **PTR** (12.1.5) wel.
- [vervallen, niet getest] **Live, `/mh codex`:** Delves heeft géén "The Labyrinth of Kindo'jan", Raid & crests géén Kith'ix/Venomstones,
  World content géén Aqir Invasion. Zoekvak "labyrinth" vindt niets.
- [vervallen, niet getest] **PTR (na copy_to_ptr), `/mh codex`:** alle vier staan er; de pijl-link in het Labyrinth-kaartje (Eversong 62.99, 72.18)
  zet een waypoint bij het portaal. Staat de ingang daar écht? Kith'ix-link (Underbelly 74.27, 5.91) idem.
- [vervallen, niet getest] **PTR, in het Labyrinth:** klopt "elke 3 kamers 2 Heavy Trunks + 1 Bountiful Coffer"? Vraagt de coffer een Restored
  Coffer Key? Zegt de delve-coach iets (of niets) — screenshot.
- [vervallen, niet getest] **PTR, Labyrinth binnenlopen:** na ~3 sec één chatregel "…: Midnight Helper has no delve tips for this one yet …"
  plus de Codex-verwijzing. Komt hij NIET, dan ziet MH het Labyrinth niet als delve (ook goed om te weten).
  Daarna `/reload` → ik lees `ns.db.delveCoachUnknown` (instance-ID).
- [vervallen, niet getest] **Live, gewone delve (bv. een Coiled Isle-delve):** die regel mag NIET verschijnen.
- [vervallen, niet getest] **Live, Hearthstone + portaal:** Hearthstone in Silvermoon gebonden en niet op cooldown? Ga ver van een portaal
  staan (bv. Zul'Aman) en zet een route naar iets in Voidstorm of Harandar (rare/schat). Het reisvenster moet de
  Hearthstone-knop tonen + "Faster: Hearthstone to Silvermoon, then Portal to …". Typ ook `/mh portals`: bovenste
  regel = je Hearthstone-plek + yes/no. Staat er "no" terwijl je wél in Silvermoon gebonden bent → noem de plek die
  er staat (dan voeg ik die naam toe).
- [x] ✅ Rob 7 okt: Grudge Pit, Collegiate Calamity én Coiled Isle geven de knop. (Voidstorm niet apart gemeld.)
  **Live, Hearthstone-route per bestemming** (Hearthstone klaar, gebonden in Wayfarer's Rest, NIET in Silvermoon staan):
  route naar (a) iets in Harandar (Grudge Pit ✅ label 7 okt, knop nog testen), (b) iets in Voidstorm, (c) een Coiled
  Isle-delve (Gnarldor Isle / Ring of Glory) — alleen als je de Coiled Isle-portal hebt (quest 96004). Reisvenster met
  Hearthstone-knop + "Sneller: Hearthstone naar Silvermoon, dan …"? (d) iets in Eversong/Zul'Aman: daar GEEN aanbod
  (geen stadsportaal erheen) — dat is bewust. (e) 7 okt laat: Collegiate Calamity (in Silvermoon) vanuit Atal'Aman →
  reisvenster met alleen de Hearthstone-knop. Komt er iets niet: `/reload` en zeg het, dan lees ik `ns.db.travelWhy`.
- [x] **Live, Shift+scroll op elk venster (7 okt laat):** ✅ boodschappenvenster + ✅ "de andere vensters werken" (Rob, 7 okt). Was: open het boodschappenvenster (Beroep én Raid), het reisvenster,
  de changelog en de beroepscursus. Houd Shift in en scroll met de muis BOVEN de lijst/tekst: het venster wordt groter
  of kleiner. Zonder Shift scrolt de lijst gewoon. Na `/reload` houdt elk venster zijn eigen grootte. In gevecht doet
  Shift+scroll bewust niets. Mist er een venster: noem het, dan zet ik het erbij.
- [x] ✅ Rob 7 okt: "het werkt". **Live, consumables-bord sluiten (7 okt laat, Rob vond het):** open het bord, sluit het met het kruisje. Ga met je
  muis over de plek waar de vakjes stonden: GEEN tooltip meer ("Niet in je tas"), geen oplichtend vierkantje. Ook na een
  gevecht niet. Open het bord opnieuw: klikken op een flask/oil werkt nog?
- [x] **Live, Holy Paladin: Infusion of Light** — ✅ Rob 7 okt (screenshot): buff bij je buffs, 10 s, tooltip "Flash of
  Light healing increased by 200% and becomes instant cast". Kaart 65 zegt nu "bij je buffs, 10 seconden" (7 talen).
  Of de knop óók oplicht: niet gezien.
- [vervallen, niet getest] **Live, Holy Paladin heal-toolkit:** Divine Shield heet nu *[Immuniteit]*, Divine Protection blijft *[Defensive]*.
- [vervallen, niet getest] **Live, in Silvermoon City:** route naar iets in Harandar of Voidstorm. De pijl wijst naar het portaal; de
  portaalKNOP mag nu NIET meer verschijnen (was dubbel). Ver van een portaal (andere zone) moet de knop er wél nog zijn.
- [vervallen, niet getest] **Live, 6 speelkaarten (`/mh play`):** Resto Shaman, Demonology, Survival, Prot Warrior, Windwalker, Discipline.
  De nieuwe zin staat erin, en Nature's Swiftness / Summon Doomguard / Execute / Zenith Stomp / Shadow Mend zijn
  klikbare spreuken met tooltip (ID's GEMETEN in wago.tools SpellName 12.1.5.70077, 7 okt).
- [vervallen, niet getest] **Live, `/mh academy tank` en `/mh academy heal`:** de Academy opent op die track. Bovenaan nu eerst "What is a
  tank?" / "What is a healer?", de mindset, de oefenroute (met follower dungeon) en "Words you will hear"; pas dáárna de
  knop "How you play …" en de toolkit. Geen verwijzing meer naar "Guides" of "In groups". Brewmaster: Celestial
  Infusion staat in de toolkit als je dat talent hebt. Zoekbalk "leren tanken" → Academy.
- [vervallen, niet getest] **Live, Academy-stappenplan:** het vaste vinkblok bovenaan is weg; onder "What is a tank?" + "Words you will hear"
  staat "Switch role, step by step" met 7 vinkjes. Op je Prot Paladin: "spec" staat vanzelf aan; "taunt en interrupt op
  een toets" ook, als Hand of Reckoning en Rebuke op je balk staan. In de tank-toolkit: Hand of Reckoning [toets] en
  Rebuke [toets]. Tikken/ontvinken werkt en blijft na /reload. Daaronder "How you see a big hit coming".
- [vervallen, niet getest] **Live, healer-kaart (`/mh play` op een healspec):** de kop boven groepsschade heet nu "Many people hurt at once".
- [vervallen, niet getest] **PTR, Aqir Invasion:** Void & Rituals-tab → event-regel van de invasie: hover → uitleg + beloning?

## 🆕 6 okt — knoppen voor commando's die alleen via /mh gingen (Rob: alle 4 groepen + de 5 reparaties)

Gebouwd, niet getest (`docs/COMMANDS_AUDIT_2026-10-06.md`). Na `/reload`:
- [vervallen, niet getest] **All settings** (Settings → All settings): bij "In combat" Action prompt, Action prompt sound (Off/Spoken/Chime:
  kiezen speelt het geluid), Dispel alert; nieuw kopje **Gear** met upgrade-regel in tooltips en upgrade-pijltjes; bij
  Meldingen Scorecard + detail; bij Dungeon de 3 tank-samenvattingen; bij Route-pijl "Let WaypointUI drive". Zelfde
  stand als je `/mh`-commando's? Ook in Blizzards eigen Options → AddOns → Midnight Helper?
- [x] Rob 6 okt ✅ ("de rest opent netjes"; screenshot toont alle 5 kaarten) **Pop-out windows**: 5 nieuwe kaarten.
  ✅ Ook "Your graphics settings" (/mh fps) opent (Rob 6 okt: "graphics opent ook netjes").
- [x] Rob 6 okt ✅ (screenshot) **Settings-startpagina**: knoppen Report a problem, What's new, Side panels back in place staan er.
- Rob 6 okt: "Open Midnight Helper settings" → hernoemd naar **All settings**; "Help translate" gaf alleen chat (en
  zei op een Engelse client "enUS needs its first pack") → nu een kopieervenster; "Show me" opende zonder uitleg de
  balken-wizard → in Settings heet hij nu "Set up your bars and keys".
- [x] Rob 6 okt ✅ ("ja klopt allemaal") Na `/reload`: knop heet All settings? Help translate opent een venster met de
  links? Knop "Set up your bars and keys"? Nieuwe schakelaars staan bij All settings (of ze elk ook wérken: niet apart
  gemeld).
- [x] Rob 6 okt ✅ (2 screenshots: tooltips "Nearest flight master" en "Your route" met klik/rechtsklik/Shift-klik)
  **Snelbalk**: met een route (bv. een rare-route) een kaartknop: klik = overslaan, rechtsklik = stoppen, Shift-klik =
  plan. Verdwijnt hij binnen ~2 s na stoppen? Buiten instances een vluchtmeester-knop.
- [x] Rob 6 okt ✅ (screenshot "Debug mode ON") Reparaties: `/mh debug` zegt nu "debug mode" (niet arrow-debug; dat is `/mh arrowdebug`). In de zoekbalk/lijst
  zeggen delves/scorecard/size nu wat ze echt doen.

## 🆕 6 okt — Tools → Pop-out windows: knoppen voor Ready en Key block; de hele pagina schuift

- [x] Rob 6 okt ✅ (screenshot, v4.7.3) beide knoppen staan erbij en werken.
- GEMETEN (screenshot): "All commands" eronder platgedrukt, niet te lezen of te scrollen. Gerepareerd: kaarten + lijst
  in één schuifvak (ToolsLaunchpad.lua, CommandList.lua `flat`). NIET in de beta-zip van 65ddccf.
- [x] Rob 6 okt ✅ ("scrollen werkt, alles goed te lezen") `/reload` → Tools → Pop-out windows: hele pagina scrollt?

## 🆕 6 okt — Boodschappen voor je beroep (`/mh craftshop`, Cisca's wens; Rob: eigen venster, keer maken, per personage)

Gebouwd, niet getest. Bron: mh-research 6 okt (Blizzard UI 12.1.0.69933). Reagents worden bij het toevoegen gelezen
en opgeslagen (`ns.db.craftShop[guid]`), dus de lijst heeft het beroepsvenster daarna niet meer nodig.
- [vervallen, niet getest] Open Alchemy (of een ander beroep), klik op een recept. Staat in het MH-paneel ernaast "+ <recept> op je
  boodschappenlijst" en "Open je boodschappenlijst (0)"? Verandert de eerste regel als je een ander recept kiest?
- [vervallen, niet getest] Klik "+ …" → vraag "Hoe vaak?" → 20 → OK. Chatregel "op je boodschappenlijst: 20× …"?
- [vervallen, niet getest] Open de lijst (paneel, `/mh craftshop` of Tools → Pop-out windows): recept met "20×" (en "ongeveer N gemaakt"
  als het recept er meer geeft), daaronder elke reagent met heb/nodig, "+N in je post / op de bank", Koop/Ophalen.
  Kloppen de aantallen met je tassen? Telt een reagent in zilver én goud samen?
- [x] Rob 6 okt ✅ ("ja, keurig"; screenshot Auctionator-lijst "MH craft - Purlymixanox" met "Fantastic Fur" [x1])
  Naar Auctionator → lijst "MH craft - <naam>". Paneel volgt het gekozen recept na de reparatie (Rob: "gaat nu goed").
- [vervallen, niet getest] Kruisje bij een recept haalt het weg; "Lijst leegmaken" werkt?
- [vervallen, niet getest] Iets mis: `/mh craftshop why` (beroep open, recept gekozen) → screenshot van de chat.
- [vervallen, niet getest] (alleen met een de/fr/es/pt/it-client, of Cisca) Vertaald 6 okt: past "Vaciar la lista"/"Svuota la lista" op de
  knop "Lijst leegmaken"? Lopen de paneelregels netjes over twee regels bij een lange receptnaam?

## 🆕 6 okt — boodschappenlijst v2: recept-bron, handelaar, farmplekken, zelf maken (Rob: "laten we gewoon die punten doen")

Gebouwd, niet getest. Teksten alleen enUS + nlNL (vertaalronde volgt). Muis op een reagent = de lange uitleg.
- [vervallen, niet getest] **Recept-bron:** zet een recept op je lijst dat je NOG NIET kent (grijs in je beroepsvenster). Staat eronder in
  het rood "Dit recept ken je nog niet. Hier haal je het:" + Blizzards tekst (Drop/Quest/Vendor … Zone …)?
- [vervallen, niet getest] Een recept dat je wél kent: géén rode regel?
- [vervallen, niet getest] **Handelaar:** recept met Sunglass Vial / Silverleaf Thread / Luminant Flux e.d. Regeltje "Handelaar, naast je
  trainer" en status geel "Handelaar N" (niet "Koop")? Naar Auctionator: staat dat item er NIET in?
- [vervallen, niet getest] **Farmen:** een kruid / erts / leer: "Herbalism - alle vier de gebieden" e.d.? Groen als je dat beroep zelf hebt?
- [vervallen, niet getest] **Zelf maken** (Alchemy is de beste test, bv. iets met Composite Flora): open eerst je beroep één keer. Staat bij
  zo'n reagent "Maak je zelf: <recept>" en een knop **+ Maken**? Klik → komt dat recept op je lijst, met zijn eigen
  reagents erbij, en wordt de status van de reagent blauw "Je maakt het"?
  ⚠️ Bij Robs Leatherworking-lijst vond de meting GEEN tussenproduct; dit deel is dus nog nergens positief gezien.
- GEMETEN Rob 6 okt (screenshot, Leatherworking): rode regel "Quest: The Medicine Loa's Shrine, Zone: Zul'Aman" ✅;
  Skinning-regels groen ✅. Zonder regeltje: Mote of Wild Magic, Peerless Plumage, Dusk-Shrouded Stone (mh-research zoekt).
- GEMETEN Rob 6 okt (screenshot, Alchemy): **+ Make** staat bij Silvermoon Health Potion (18/25, recept op de lijst maakt
  ~5 → 2 tekort) ✅ — eerste positieve zichting van "zelf maken". Bron "Vendor: Second Mate Sluggs, Zone: The Coiled Isle"
  ✅, Sunglass Vial "Vendor, next to your trainer" ✅. Zonder regeltje: Cursebound Globe, Neutralized Venom Clot.
  Knop toont nu het aantal ("+ Maken 1×").
- [x] Rob 6 okt ✅ (2 screenshots: "+ Make 2×" bij 18/25 → "2× Silvermoon Health Potion (about 10 made)", eronder Sunglass
  Vial 10 + Tranquility Bloom 12, potion blauw "Crafting") Klik **+ Maken N×**: recept erbij, status blauw?
- GEMETEN Rob 6 okt (screenshot): na het maken werkt het venster live bij ✅; tooltip met kruid-uitleg + "You have
  this gathering profession" ✅. Maar het recept bleef "2×" staan → nu: aftellen.
- [vervallen, niet getest] **Aftellen:** recept 2× op de lijst, maak er één → chat "… gemaakt: nog 1× op je boodschappenlijst"? Tweede →
  "klaar, van je lijst af" en het recept is weg? Gebeurt er niets: `/mh craftshop why` → regel "craft NOT on your list".
- [x] Rob 6 okt ✅ (screenshot: Tranquility Bloom "Pick 1", Azeroot "Pick 3", Nocturnal Lotus "Pick 1", groen)
  **Pluk N:** kruid te kort en jij hebt Herbalism → groene status "Pluk 23" in plaats van "Koop 23"? (Erts: "Delf",
  leer: "Vil".)
- [vervallen, niet getest] **Wijs de weg naar 39 plekken** (Rob: "bouw die pijlen maar naar 39 plekken"; `Modules/CraftShopPlaces.lua`, 266
  recepten): zet Potion of Recklessness / Alluring Nostrum / Blessed Pango Charm (niet geleerd) op je lijst → knop
  "Wijs de weg" → pijl naar Void Researcher Anomander (Voidstorm) / Second Mate Sluggs (Coiled Isle) / quest in Zul'Aman
  (+ chatregel over een eerdere quest)? `/mh craftshop why` met dat recept gekozen noemt de plek.
- GEMETEN Rob 6 okt avond (screenshot, Leatherworker, 4.7.4-beta1): knop "Show the way" bij Blessed Pango Charm (quest) ✅,
  geen knop bij een spec-recept ✅; regeltjes ronde 2 zichtbaar: Peerless Plumage groen + "Skin 2", Mote of Wild Magic,
  Dusk-Shrouded Stone, Mote of Pure Void ("Pick it up", 36 op de bank), Sin'dorei Armor Banding "You make this" ✅.
  ✅ Rob 6 okt avond (screenshot chat): klik → "This recipe comes from a quest…" + TomTom "Quest: The Medicine Loa's
  Shrine - 38.78, 44.85 in Zul'Aman", plus tussenstap "Portal to Silvermoon" (stond op de Coiled Isle). Quest-pijl werkt.
  Nog niet gezien: pijl naar een handelaar, trainer of ingang.
- [vervallen, niet getest] **Regeltjes voor meer reagents** (6 okt, uit het tweede onderzoek): Motes ("Wild-kruiden & erts - vooral Zul'Aman"
  e.d.; groen + "Verzamel N" met Herbalism óf Mining), Thalassian Lumber, Dazzling Thorium, Petrified Root ("Delve-kisten"),
  Cursebound Globe / Neutralized Venom Clot (Coiled Isle), Peerless Plumage, Skinning-spul, prospect-stenen ("Prospect N"
  met Jewelcrafting), disenchant-stof, stof, vlees. Kloppen ze met wat je weet? (Motes/Cursed/Petrified = Wowhead, KANDIDAAT.)
- [vervallen, niet getest] **Nalopen in het spel** (KANDIDAAT, tooltip op de knop zegt dat): Lyrendal 2393 44.96/55.40, Mirvedon 2393 34.01/81.25,
  Gelanthis 2393 48.01/55.03, Navigator Otoola 2512 57.2/48.2, Jennara Sunglow 2393 39.54/51.00 (boven), Sylann (koken)
  2393 56.36/69.83, questgevers 2395 46.93/35.58 · 2437 38.78/44.85 · 2413 49.69/23.31, ingang Venomous Abyss (MH 20.51
  vs DB2 22.86), ingang Altar of Fangs 2509 47.24/68.13. Herbataur (Stabilized Derivate?) 2393 45.2/80.4.
- [vervallen, niet getest] **Wijs de weg** (Rob: "kunnen we de weg wijzen?"): een NIET-geleerd recept van de trainer → knop "Wijs de weg"
  rechts op de receptregel → pijl naar je trainer in Silvermoon? Handelaar-spul → knop "Handelaar N" → pijl naar de
  handelaar naast je trainer (koken: de herberg)? Ook met TomTom aan?
- [vervallen, niet getest] Het nep-recept "Knowledge" (geen reagents) toevoegen → chat zegt dat het niet op de lijst komt?
- [vervallen, niet getest] `/mh craftshop why`: regel "items you can make … N" met een getal boven 0 (na het openen van je beroep)?

## 🆕 7 okt — "één winkelvenster" (Rob koos het): tabbladen + alles naar Auctionator

Gebouwd, niet getest. De twee vensters bestaan nog, maar delen nu tabbladen BOVEN het venster.
- [vervallen, niet getest] `/mh ready` → boven het venster twee tabbladen **Raid | Beroep**. Klik Beroep → het boodschappenvenster opent op
  dezelfde plek en het raid-venster gaat dicht? En terug?
- [vervallen, niet getest] Met Auctionator: onderaan beide vensters een knop **Alles naar Auctionator** → chat "lijst MH - <naam> met N"?
  In Auctionator → Shopping één lijst met de raid-spullen én de beroeps-reagents (handelaar-spul niet)?
- [vervallen, niet getest] Vallen de tabbladen niet van je scherm als het venster helemaal bovenaan staat?

## 🆕 7 okt — raid-herinnering (Rob koos hem)

Gebouwd, niet getest. Staat standaard AAN; `/mh ready remind off` zet hem uit, `/mh ready remind` zegt de stand + laatste check.
- [x] ✅ Rob 7 okt: "deed het toen ik in een raid ging". Ga een raid-instance binnen (of laat de raidleider een ready check doen in een raidgroep) terwijl je iets mist →
  na ~3 s een toast "Klaar voor de raid? Je mist N ding(en) voor vanavond"? Klik → het venster opent?
- [vervallen, niet getest] Niets missen → geen toast (`/mh ready remind` zegt dan "last check …: 0 missing").
- [vervallen, niet getest] Niet vaker dan één keer per raid-bezoek, en bij ready checks hooguit eens per 10 minuten.

## 🆕 7 okt — keypad-commando's: één per scherm (Rob: "/mhrares", veilige vorm)

Gebouwd, niet getest (`Modules/KeypadCommands.lua`). 27 commando's: 24 schermen + /mhcraftshop, /mhready, /mhblock.
- [vervallen, niet getest] `/mh keypad` → lijst in de chat (/mhrares Rares · /mhdelves … )?
- [x] ✅ Rob 7 okt: "meerdere /mh geprobeerd en die werken". `/mhrares` (of via je keypad) → MH-venster opent op Rares? Ook `/mhaccount`, `/mhprofessions`, `/mhcraftshop`.
- [vervallen, niet getest] Botst er iets met een andere addon (een /mh…-commando dat iets anders doet)?

## 🔍 7 okt — meting: welke kwaliteit met zilver of goud? (`/mh craftshop quality`)

Voor de keuze "welke kwaliteit kopen" (`docs/CRAFTSHOP_QUALITY_2026-10-07.md`, varianten a/b/c — Rob kiest daarna).
- [vervallen, niet getest] `/reload`, beroepsvenster NIET openen, recepten op je lijst (bv. de Smuggler's Shoulderguards) → `/mh craftshop quality`.
  Per recept een chatregel "none = … | silver = quality … | gold = quality …". Daarna nog eens met het venster OPEN.
- [vervallen, niet getest] `/reload` → ik lees `craftShopQuality`. Zeg erbij of je het gouden leer/de schubben zelf hebt (de regel noemt ook
  "you own N" per gouden reagent).
- [x] ✅ Rob 7 okt (screenshot): "Codified Azeroot: Kwaliteit 1 met zilver of goud: koop zilver (van 2)" en "Hobbyist
  Alchemist's Mixing Rod: met zilver 2 · met goud 4 · alleen Azeroot in goud 3 (van 5)". **Variant b, al gebouwd** (Rob: "waarom niet ook b nu?"): onder een recept dat je kent een blauw regeltje
  "Kwaliteit met zilver: 2 · met goud: 4 · alleen <reagent> in goud: 3 (van 5)", of "… met zilver of goud: koop zilver".
  Antwoordt het spel niet, dan staat er NIETS (zo bedoeld) — dan zegt `/mh craftshop quality` waarom.
- [vervallen, niet getest] **Variant a:** Academy → hoofdstuk Kwaliteit, onderaan "Welke koop je dan? …".

## 🆕 7 okt — boodschappenlijst: "+N op alts" (Rob koos het, onderweg)

Gebouwd, niet getest. Elk personage onthoudt bij inloggen (en als de tassen veranderen, max. 1× per 5 s) hoeveel het
heeft van de reagents op ALLE boodschappenlijsten: tassen + bank, níet de Warband-bank (die telt al mee).
- [x] Log één keer in op een alt die iets heeft van een reagent op je lijst (bv. Tranquility Bloom), terug naar je
  alchemist → bij die reagent "+N op alts" (alleen als je tekortkomt)? Muis erop: "Op je andere personages … Iceicebaby 50"?
  ✅ Rob 7 okt (screenshot): Tranquility Bloom 3/28 "+31 op alts", tooltip "Theexodus 31. Stuur het per post …".
- [x] "Koop N" blijft gelijk (alts tellen niet als "heb je al", het is een tip om te posten). ✅ zelfde screenshot: "Pluk 25".

## 🆕 7 okt — dispel-hercontrole: A, B, C (Rob koos alle vier; D pas na 14 okt)

Achtergrond: `docs/DISPEL_RECHECK_2026-10-07.md`. De deur voor zelf debuffs lezen blijft dicht; dit zijn kleine metingen.
- [vervallen, niet getest] **A (jij/Cisca, niets gebouwd):** een dungeon in een groep met `/mh partytargets` aan. Licht je eigen of andermans
  rij rood op ("DISPEL")? Screenshot van de MH-rij én Blizzards raid frame op hetzelfde moment. Niet rood terwijl er iets
  op zit: `/mh glow`.
- [vervallen, niet getest] **B (gebouwd, niet getest):** na elk gevecht in een groep (met `/mh partytargets` aan) bewaart MH je eigen debuffs door
  drie filters: raid (= de rode rij), rpd (iemand in je groep kan het), any (heeft een dispel-type). Na een dungeon:
  `/reload` → ik lees `dispelSelfLog` en zie welk filter de valse alarmen (Magic op een Prot Paladin) niet geeft.
- [vervallen, niet getest] **C (gebouwd, staat UIT):** `/mh dispelsound test` → hoor je een klok? `/mh dispelsound on` → chat "N of M spells
  registered"? Dan in een dungeon: piept het als JIJ een debuff krijgt die je zelf kunt weghalen? `/mh dispelsound why`.
  Werkt alleen met debuffs die MH al eens zag (dispelCapture, gevuld in dungeons). Uitzetten: `/mh dispelsound off`.

## 🆕 6 okt avond — Moxie zichtbaar (alle 11 nummers door het spel bevestigd, `/mh moxie`)

Deze regels stonden sinds 19 jul bewust UIT (alle geraden nummers waren fout). Nu voor het eerst aan:
- [x] Rob 6 okt ✅ (screenshot: "Artisan Alchemist's Moxie 25", "Artisan Herbalist's Moxie 460") MH-hoofdvenster → tabblad **Professions** ("Profession Treasures and Books"; NIET het paneel naast je beroepsvenster,
  GEMETEN in Profession.lua:707/1180): regel "Artisan Alchemist's Moxie  25" (jouw saldo)?
- [vervallen, niet getest] Recept-tooltip bij een Moxie-recept (Camberon's Cauldron / renown-handelaar): kosten tegen je saldo — klopt het?
- [vervallen, niet getest] Alt-overzicht: muis over een personage → Moxie-regel in de tooltip?
- GEMETEN Rob 6 okt (2 screenshots): rijen "Artisan Alchemist's..." 25 en "Artisan Herbalist's M..." 460 stonden er,
  maar tussen de Mistcrests en afgekapt — Rob: "ik zie het niet zo snel die moxie hier". Nu: Moxie uit Valuta (in de
  snapshot), en een gouden regel **"Moxie"** direct onder elk beroep bij Beroepen.
- [x] Rob 6 okt ✅ ("ja die vallen direct op") `/reload` → Account snapshot → Beroepen: onder Alchemy een gouden "Moxie"-regel met 25 bij dit personage, onder
  Herbalism 460? Alts met dat beroep: "?" tot ze één keer ingelogd zijn. Geen Moxie-regel onder Cooking/Fishing.
- [vervallen, niet getest] **Account snapshot** (Rob: "Moxie-rij erbij"): onder Currencies een rij per Moxie-soort die iemand op je account heeft
  (bv. "Artisan Herbalist's Moxie" met 460 bij dit personage)? Een alt laat pas een getal zien nadat hij één keer
  ingelogd is na deze versie (tot dan een streepje). Ook in Tools → Currencies, met de uitleg "De eigen valuta van dat beroep…".

## 🆕 6 okt avond — healers: "Zo vecht je alleen" (Rob, Resto Druid: "hoe weet ik welke knop ik moet gebruiken?")

Gebouwd, niet getest. Volgorde = Blizzards eigen Single-Button Assistant (`docs/HEALER_SOLO_DAMAGE_2026-10-06.md`).
- [vervallen, niet getest] Resto Druid → `/mh play`: onder "Zo heal je" een blokje **"Zo vecht je alleen:"** met 1. Sunfire [toets] 2. Moonfire
  [toets] 3. Starsurge 4. Wrath [5] 5. Starfire (alleen spells die je hebt)? Staat er "(niet op je balken)" bij iets?
- [vervallen, niet getest] `/mh block` op de healer: schade-spells met een **rode rand**, en onderaan de regel "Rode rand = een schade-spell"?
- [vervallen, niet getest] Een andere healer (Holy Paladin / Disc / Resto Shaman …): klopt de lijst daar ook?
  GEMETEN Rob 6 okt (screenshot Earthshammy, Resto Shaman): kaart "Zo vecht je alleen: 1. Flame Shock [Ctrl 2] 2. Lava Burst
  [5] 3. Lightning Bolt [Ctrl 1] 4. Chain Lightning [Shift 4]" ✅; legenda-regel onder het blok ✅. ✅ Rob: "de damage spells
  hebben een rode rand". Print (site /keyblock/): site-chat gevraagd om een zwart-wit-bestendige markering.

## 🆕 6 okt avond — "welke van je personages kennen dit recept?" (Rob: "neem wel het idee over", zonder MyRecipeTracker)

Stap 1 gebouwd, niet getest: bij het openen van een beroep onthoudt MH per personage welke recepten het kent
(`ns.db.craftShopKnown`, account-breed). De tooltip zelf komt na het onderzoek (welk item leert welk recept).
- [vervallen, niet getest] Log op een paar personages in en open op elk één keer hun beroep(en). `/mh craftshop why` → regels "known recipes
  noted for <naam>: N" voor elk personage dat je zo langs ging?
- [vervallen, niet getest] **Tooltip** (stap 3 gebouwd: 314 recept-items uit Blizzards data, `Modules/CraftShopRecipeItems.lua`): muis op een
  Midnight-recept (tas, veilinghuis, of een link in de chat) → groen "MH Kennen dit al: <namen in klassekleur>" en/of geel
  "MH Hebben het beroep, dit recept nog niet: <namen>"? Bij een recept van een beroep dat niemand heeft: geen MH-regel.
  Voorbeeld uit het onderzoek: item 256636 = Pattern: Row Walker's Deflectors (Leatherworking).

## 🔍 6 okt — meting vóór boodschappenlijst v2 (`/mh craftshop probe`; Rob: "maak die meetcontrole maar")

Voor: recept-bron, tussenproducten (en later kwaliteit). Schrijft naar `ns.db.craftShopMeasure` (open + closed).
- [vervallen, niet getest] Zet 1-2 recepten op je lijst. Beroepsvenster OPEN → `/mh craftshop probe`. Chatregel met "window OPEN"?
- [vervallen, niet getest] Beroepsvenster DICHT → `/mh craftshop probe` opnieuw ("window CLOSED"). Dan `/reload` → ik lees het bestand.

## 🆕 6 okt — Holy Paladin: Hand of Reckoning + Shield of the Righteous op blok D (Rob: "laat ze maar op de D blok staan")

GEMETEN (screenshot 15-key-block, Twelveinchy Holy): rode regel "(2): Hand of Reckoning, Shield of the Righteous".
Nu `blockAs[65].onlyD` (geen rode regel meer, wel een Alt-toets op D); SotR's survival alleen voor Prot (tabel).
keyblock_specs: A/B/C van 65/66/70 ongewijzigd (GEMETEN).
- [vervallen, niet getest] Holy `/reload` → `/mh block`: rode regel weg, de twee op een vrije Alt-toets van D? Stay alive-kaart van Holy zonder SotR?

## 🆕 6 okt — Mage (Iceicebaby) na de blok-D-reparatie

- [x] Rob 6 okt ✅ (2 screenshots) Frost: Blizzard op Shift 2; Fire: Flamestrike op Shift 4; blok D alleen eigen spul
  (items, portal-macro's), geen vreemde spreuk.
- GEMETEN: rode regel noemde 30/31 Portals en Teleports (komen uit de flyout-scan) + bij Fire "Cone of Cold".
  Gerepareerd: spreuken uit een flyout tellen niet als "onbekend" (`ns._mhFlyoutSpells`). Cone of Cold bij Fire: Rob kiest.
- [x] Rob 6 okt ✅ (screenshot Fire: rode regel "(1): Cone of Cold") Mage `/reload` → rode regel zonder Portals/Teleports.
- GEMETEN (SV, Fire-snapshot): de laatste Place raakte D niet; de 5 losse portals stonden er al (eerdere Place/4.7.2,
  AFGELEID). Rob: "het uitschuif-icoontje gebruiken". Gebouwd, NIET getest: flyouts zonder geclassificeerde of
  bewust-toetsloze spreuk → het uitklapknopje op een vrije Alt-plek van D (PickupSpellBookItem); losse kopieën van
  hun spreuken gaan van balk 1 en D af zoals dubbelen (Undo zet terug). Cone of Cold Fire/Arcane = alleen D.
- [x] Rob 6 okt ✅ (2 screenshots) Undo → neerzetten: losse portals weg, Portal (Alt E) en Teleport (Alt C) als
  uitklapknop (klappen open), Cone of Cold Alt Q. Undo zette alles terug.
- GEMETEN zelfde screenshot: "no place"-regel noemde ook "Frostbolt of Ages" en "Word of Recall (OLD)" → AFGELEID
  General-tab-flyouts; nu alleen flyouts buiten de General-lijn.
- [vervallen, niet getest] Mage `/reload` → `/mh block`: noemt de regel onderaan die twee nog?

## 🔴 6 okt — Prot Paladin: verkeerde spreuk op blok D (Warband Map op Alt 1)

GEMETEN in SV: namen gesorteerd, ids niet → elk onbekend id hoorde bij een andere naam. Gerepareerd (56bab86).
Robs screenshot daarna: nog steeds Warband Map / Lift Off / Aerial Halt op Alt 1/3/4 — AFGELEID: test vóór `/reload`.
- [x] Rob 6 okt ✅ (screenshot na `/reload`: Concentration/Crusader/Devotion Aura + 3 Overload-herbs op D, juiste
  iconen) `/reload` → staan de onbekende spreuken zelf op D?
- Rob: "ja doe maar geen toets" → auras en Overload-herbs in NO_KEY_ON_PURPOSE.
- [x] Rob 6 okt ✅ (screenshot: D leeg op zijn macro DUNDUN na, "Every spell Midnight Helper knows for this spec has a
  place", geen rode regel) Prot Paladin `/reload` → Undo → neerzetten: blok D zonder auras/herbs?

## 🆕 6 okt — `/mh ready`: "Je gear" (enchants + lege sockets) en "onderweg" (Rob: "1 en het onderweg-trucje ook")

Gebouwd, niet getest. Onder de consumables een kopje met alleen wat ONTBREEKT: per slot zonder enchant de eerste keus
van de Enchants-tab ("(keuze)" als er meer opties zijn), en lege sockets (Eversong Diamond als je er geen draagt + de
gem voor je stats). Zelfde klik/shift-klik/Auctionator. Onderweg: wat je op de AH koopt telt meteen als "+N in je post".
- [vervallen, niet getest] Personage met een ontbrekende enchant of lege socket: staat het kopje er, met de goede naam en "Koop 1"?
- [vervallen, niet getest] Klik bij het veilinghuis op een enchant-rij → zoekt "Enchant Ring - Eyes of the Eagle" (bv.)?
- [vervallen, niet getest] Naar Auctionator: staan de enchants/gems ook in de lijst?
- GEMETEN Rob 6 okt (screenshot): gear-kopje staat er (8 rijen, "(a choice)", Buy 1/2/3) ✅, Auctionator-lijst met
  enchants en gems ✅. Maar Enchant Weapon - Arcane Mastery gekocht → NIET als "+1 in je post". Tweede weg gebouwd
  (Confirm/StartCommoditiesPurchase onthouden, tellen bij COMMODITY_PURCHASE_SUCCEEDED) + meting `ns.db.raidShopProbe`.
- [vervallen, niet getest] Koop iets op de AH en kijk METEEN (zonder brievenbus) in `/mh ready`: "+N in je post"? Daarna `/reload` → ik lees
  `raidShopProbe`.
- [vervallen, niet getest] Alles in orde → is het kopje weg?

## 🆕 6 okt — `/mh ready`: brievenbus en bank tellen mee (Rob: "ja doe maar allebei")
- [x] Rob 6 okt ✅ (screenshot Hunter Redisch: "+30 in mail" bij beide potions, "+7 in bank" bij Food, status "Pick it
  up"; Flask "Enough") brievenbus en bank.

Gebouwd, niet getest. Per rij een klein regeltje "+N in je post" / "+N op de bank" (bank = bank + Warband-bank). Ligt
genoeg klaar, dan staat er geel **Ophalen** in plaats van **Koop**. De post kent MH pas na één bezoek aan de brievenbus.
- [vervallen, niet getest] Koop iets op de AH, open de brievenbus (niet ophalen), dicht → `/mh ready`: "+N in je post"? Status "Ophalen"?
- [vervallen, niet getest] Haal het op: verdwijnt "+N in je post" en telt het bij je tas?
- [vervallen, niet getest] Iets op de bank / Warband-bank, bank DICHT, na `/reload`: "+N op de bank"? (Niet gemeten of dat dicht werkt.)
- [vervallen, niet getest] Naar Auctionator koopt alleen nog wat écht ontbreekt?

## 🆕 6 okt — `/mh ready`: items klikbaar (Rob: "ik wil ze alle 4")

Gebouwd, niet getest. Onderaan het venster staat nu een regel die het uitlegt.
- GEMETEN Rob 6 okt (screenshot): klikken bij het veilinghuis zoekt meteen ✅; "Naar Auctionator" maakt de lijst
  (Concentrated Silvermoon Health Potion x30, Potion of Recklessness x30, Hearty Royal Roast x4) ✅. Maar: Hearty Royal
  Roast niet gevonden, en Food + Healthstone bleven "…" (klik deed dan niets). Gerepareerd: venster luistert nu ook naar
  ITEM_DATA_LOAD_RESULT; Healthstone-rij reageert bewust niet op klikken.
- GEMETEN Rob 6 okt: "royal roast" → Royal Roast + Impossibly Royal Roast, géén Hearty Royal Roast; Void-Touched Augment
  Rune wel op de AH maar niet in de Auctionator-lijst (optioneel → bewust overgeslagen). Gerepareerd: Hearty-eten zoekt
  zonder "Hearty " (Auctionator niet-exact), rune gaat mee in de lijst.
- [x] Rob 6 okt ✅ (screenshot: lijst met 4 regels, Royal Roast niet-exact → Royal + Impossibly Royal Roast, rune x29)
  Naar Auctionator: 4 regels (ook de rune), food niet-exact?
- Rob: "andere char → wat gebeurt er met de lijst?" Gerepareerd: lijst heet nu "MH raid - <naam>" (zelfde naam wist
  de oude lijst). De oude lijst "Midnight Helper raid" mag je zelf weggooien.
- [vervallen, niet getest] Op een tweede personage `/mh ready` → Naar Auctionator (zonder veilinghuis): eigen lijst "MH raid - <naam>",
  en de lijst van het eerste personage staat er nog?
- [vervallen, niet getest] **Bij het veilinghuis** (Blizzards eigen tab): klik op een rij → zoekbalk krijgt de naam en hij zoekt meteen?
  Ook als je op het Auctionator-tabblad stond (hij moet dan naar Buy springen)?
- [vervallen, niet getest] **Zonder veilinghuis:** klik op een rij → onderaan "Ctrl+C om te kopiëren:" met de naam geselecteerd? Ctrl+C en
  plakken in de AH-zoekbalk werkt?
- [vervallen, niet getest] **Shift-klik** op een rij → link in de chat?
- [vervallen, niet getest] Knop **Naar Auctionator** (alleen te zien met Auctionator): bij het veilinghuis → Auctionator zoekt alles wat je nog
  moet kopen, met het aantal? Zonder veilinghuis → lijst "Midnight Helper raid" in Auctionator → Shopping?
- [vervallen, niet getest] Worden potions gevonden, of filtert iets ze weg (een gekozen categorie links, je eigen filters)?

## 🐛 6 okt — Hunter: "New for your key block: Primal Rage -> F1" bij elke huisdierwissel

GEMETEN (Robs screenshot via site-chat). Oorzaak AFGELEID: de knop houdt Command Pet 272651, met een Ferocity-huisdier
wordt die Primal Rage 272678, en MH zag 272678 als "nog niet op het blok". Gerepareerd in `MissingRows`: wat een knop
wórdt (override) telt ook als aanwezig.
- [x] Rob 6 okt ✅ ("de popup bij de hunter komt niet meer terug") `/reload` op je Hunter, wissel een paar keer tussen
  Ferocity en Cunning: komt de popup nog?

## 🆕 4 okt middag — Stay alive: elke rij heeft nu een spell-id (verzoek site-chat)

Wat er veranderde: 113 rijen kregen `id = …`, Ignore Pain (Prot) ook; Blink, Roll en Dash kregen `survivalId`
(zodat je toetsen niet verschuiven). Paladin en Warlock veranderden niet. Het spel zoekt de spell nu op **nummer**
in plaats van op naam. Een fout nummer laat een rij **stil verdwijnen** — daarom deze test vóór de release.

Per personage (hoe meer klassen, hoe beter; vooral **Druid, Mage, Monk, Warrior, Priest, Evoker, Shaman, Demon Hunter**):
- [vervallen, niet getest] `/mh play` → **Stay alive**: staan dezelfde rijen er als gisteren? Niets weg dat je wél hebt?
- [vervallen, niet getest] `/mh survival`: kijk naar de **rode `-`-regels**. Staat er `not known (<getal>)` of `not found by id <getal>` bij
  een spreuk die je **wel** op je balk hebt? Dan is dat nummer fout → stuur me die regel (screenshot mag).
- [vervallen, niet getest] **Mage:** met Shimmer gekozen: staat er **één** Shimmer-regel (niet ook Blink)? Mirror Image alleen met
  Refractive Images.
- [vervallen, niet getest] **Monk** met Chi Torpedo / **Druid** met Tiger Dash: één regel, niet twee.
- [vervallen, niet getest] **Warrior** met Impending Victory: één heal-regel, niet Victory Rush én Impending Victory.
- [vervallen, niet getest] **Demon Hunter Devourer** (als je die hebt): staat **Shift** er nu (id 1234796, uit Blizzards data, nooit in
  het spel gezien)?
- [vervallen, niet getest] **Toetsen:** `/mh apply` dry run op een Mage, Monk of Druid: zelfde voorstel als vóór vandaag? (De ids mogen
  geen toets verschuiven; AFGELEID, niet gemeten.)
- [vervallen, niet getest] Alles goed → zeg het, dan mag de site-chat de bouwer draaien (37 nieuwe "Blijf leven"-blokken).

## 🆕 4 okt middag — toetsenblok: het plaatje (`/mh block`) en de Edit Mode-proef

Rob: "Je mag gaan bouwen." Gebouwd: alleen het **plaatje**. Er verandert niets op je balken.
- [vervallen, niet getest] `/mh block`: opent een venster met **3 balken van 3×4**, elke plek met toets, icoon en naam. Klopt het met het
  plan (1 hoofdknop, E kick, Z/X/C verdediging, T potion, G trinket)? Muis over een plek = tooltip met de taak.
- [vervallen, niet getest] Onderaan: "Geen plek in het blok (…)": wat staat daar? (Verwacht: hulp-spells zoals Mark of the Wild of Revive.)
- [vervallen, niet getest] **Druid:** staan Bear/Cat/Moonkin Form op **Ctrl 1/2/3**?
- [vervallen, niet getest] **Q = grote cooldown.** Komt pas goed als het onderzoek per spec erin zit (zie NEXT_SESSION). Tot dan staat er de
  eerste cooldown van de spec.
- [vervallen, niet getest] `/mh block why`: één regel per plek met de reden. Schrijft ook naar je SavedVariables (`keyBlockProbe`).

**Edit Mode-proef** (vóór MH ooit zelf balken op 3 rijen zet; zorg dat je NIET in een gevecht bent):
1. Esc → Edit Mode: staat bovenaan **jouw eigen** layout (niet "Modern" of "Classic")? Sluit Edit Mode.
2. `/mh editmode export` → er opent een vak met een tekst. Kopieer die (Ctrl+C).
3. `/mh editmode import` → plak dezelfde tekst (Ctrl+V) → knop **Apply bars**. Dan `/reload`.
4. [ ] Staan al je balken nog precies waar ze stonden? Bestaan "Modern" en "Classic" nog in de lijst van Edit Mode?
   Foutmelding? (Je hebt je eigen balken teruggezet, dus er hoort **niets** te veranderen.)
5. Als er wél iets veranderde: `/mh editmode restore` en `/reload`, en stuur me een screenshot.

## 🆕 5 okt laat — wat op A/B/C geen plek heeft, gaat naar een VRIJE Alt-toets op blok D (Rob: "ja, bouw het zo")

Rob: "het zijn inderdaad 2 macros" (Moonfire/Dispel op D = macro's, MH laat macro's staan). Gebouwd in `PlacePlan`:
na het opzij zetten krijgen spreuken zonder plek (Mark of the Wild, Revive, Arcane Intellect, rez...) een LEGE plek op D;
staat de spreuk al op D, dan niet nog eens. Undo haalt ze eraf. Tekst onderaan zegt het nu ("komen op een vrije Alt-toets").
- GEMETEN 5 okt (chat-probe op Robs Guardian): "block D: nothing placed — Mark of the Wild: no free place left on D
  (free on D: 0)". Oorzaak: bij het plannen zit D nog vol (Undo zette alles terug); de 14 dubbelen gaan pas eraf bij
  Place. Gerepareerd: een D-plek met een kopie van een blokspreuk telt als vrij.
- [x] Rob 5 okt ✅ (chat: "block D: Mark of the Wild -> ALT-Q, Revive -> ALT-E (free on D: 7)") Guardian: Undo → Zet het
  op balk 5, 6 en 7 → staan Mark of the Wild en Revive nu op een Alt-toets in D?
- GEMETEN: Mark of the Wild daarna TWEE keer (Alt Q + Alt X): hij werd ook als oude knop van balk 6 naar Alt X geparkeerd.
  Gerepareerd: een spreuk die naar D geparkeerd wordt, telt als "al op D".
- [x] Rob 5 okt ✅ (screenshot: Mark of the Wild alleen Alt X, Revive Alt Q) Guardian nog eens Undo → neerzetten: Mark of
  the Wild nog maar één keer?
- [vervallen, niet getest] Je eigen spul op D (macro's, Healthstone, Flask) blijft gewoon staan?
- [vervallen, niet getest] Undo: verdwijnen ze weer van D?

## 🆕 5 okt nacht — Warlockie: nieuwe spreuken aangeboden; gedeelde layout niet meer "klaar"

GEMETEN (Rob, inloggen op Warlockie, lvl 82): venster "Grimoire: Fel Ravager -> Shift 3, Shadowfury -> Shift F, Demonic
Circle -> Shift C". Rob: "als we vaker twelve retro tegen komen op een andere character dan moeten we dat zien te
voorkomen!!" → stap 2 van het stappenplan is op een preset of GEDEELDE layout nooit meer afgevinkt, ook niet als die
layout al een blok is; de knop biedt dan "Eigen layout + blok".
- [x] Rob 5 okt ✅ (screenshot: knop "Put "Warlockie Demonology" back", blok met Fel Ravager Shift-3, Summon Doomguard
  F1, Shadowfury Shift-F, Demonic Circle; geen rode regel) Warlockie: eigen layout + blok.

## 🆕 5 okt nacht — onbekende spreuken gaan vanzelf naar een vrije Alt-plek op blok D (Rob: "ja, bouw het zo")

- [vervallen, niet getest] Op een personage met een rode regel: `/reload` → Undo → neerzetten. Staan de genoemde spreuken nu op Alt-toetsen?
  Chat "block D: …" noemt ze. Komt er rommel op D (skyriding, Warband)? Dan screenshot.
- [vervallen, niet getest] Of zonder Undo: komt het venster "Nieuw voor je toetsenblok: … -> Alt …" en werkt Place it?

## 🆕 5 okt laat — Resto Druid: blok goed; Heart of the Wild + Stampeding Roar alleen op blok D

GEMETEN (Robs Resto): heals 1-4, Wild Growth/Nature's Swiftness, Moonfire Shift-2, Sunfire Shift-C, Innervate F3, Revive
Alt 1. Rode regel: 7 bewust weggelaten spreuken. Gebouwd: `blockAs[spec].onlyD` (KeyBlockAllocate) = nooit A/B/C, meteen
naar een vrije Alt-plek op D; Heart of the Wild + Stampeding Roar krijgen dat voor 105. Cat/bear-aanvallen en Starfire in
`NO_KEY_ON_PURPOSE`. Standaardblok Resto: nog steeds 29 plekken (niets weggeduwd).
- [x] Rob 5 okt ✅ (nieuwe-spreuk-venster "Stampeding Roar -> Alt 2, Heart of the Wild -> Alt 3", daarna op het blok)
  Resto: Heart of the Wild en Stampeding Roar op een Alt-toets?
- Rode regel noemde nog Frenzied Regeneration → nu ook onlyD voor 102 en 105 (staat op hun Stay alive-kaart).
- [vervallen, niet getest] Resto en Balance na /reload: Frenzied Regeneration aangeboden voor een Alt-toets? Rode regel weg?

## 🔍 5 okt laat — Robs Guardian Druid (Purlymixanox): blok goed, 2 zonder plek, 5 "onbekend"

GEMETEN (screenshot): bear-rotatie op 1-4, Barkskin/Ironfur/Survival Instincts, Prowl F3, Dash Shift-F1 — goed.
Rode regel: "geen plek (2): Mark of the Wild, Revive" terwijl 5, Shift-2 en Ctrl-3 leeg zijn (overloop kent alleen vaste
plekken; ontwerpvraag aan Rob, 2e keer gesteld). "Onbekend (5): Rake, Regrowth, Sharpen Your Knife, Shred, Wrath" →
bewust zonder toets voor Guardian → in `NO_KEY_ON_PURPOSE`. Moonfire staat ook op D Alt 2: Undo gedaan? (gevraagd)
- [vervallen, niet getest] Guardian na `/reload`: rode "onbekend"-regel weg?

## 🔍 5 okt laat — Reddish (BM): dubbelen op blok D + ruis in de rode lijst

GEMETEN (screenshot): D (Alt) houdt kopieën van blokspreuken (Exhilaration Alt 3 + F2, Bestial Wrath Alt 1 + Q, Mend
Pet, Recuperate, Flare ...): blok neergezet vóór de opruim-reparatie van vanavond → Undo + opnieuw neerzetten.
De rode lijst noemde nog skyriding/Warband (General-tab-filter ving ze NIET, of Rob had nog niet herladen — onbekend) en
Hunter-dingen die bewust geen toets krijgen. Nu ook een namenlijst `NO_KEY_ON_PURPOSE` (KeybindAutoMap.lua).
Rob 5 okt: demonen/curses/buffs/out-of-combat **"laat zoals het is"** (mijn advies).
- [x] Rob 5 okt ✅ (screenshot: D houdt alleen eigen spul — flyouts, Healthstone, Disenchant) Reddish: Undo → Zet het op
  balk 5, 6 en 7 → staan Exhilaration, Bestial Wrath enz. nog maar één keer?
- [x] Rob 5 okt ✅ ("Every spell Midnight Helper knows for this spec has a place", geen rode regel) Rode regel na
  `/reload`: geen skyriding, Warband of Feed Pet meer?
- [x] Rob 5 okt ✅ Nieuwe-spreuk-venster na reload: "Wing Clip -> Shift Z" (Wing Clip kwam uit de gatenronde). Na Undo +
  opnieuw neerzetten staat hij op Ctrl 1: Bijwerken zet een nieuwe spreuk op de eerste vrije overloopplek, een volledige
  plaatsing rekent alles opnieuw. Verwacht gedrag.

## 🆕 5 okt laat — gatenronde alle klassen: ~100 spreuken erbij, ~20 oude eruit

AFGELEID uit het standaardblok (alle talenten tegelijk); in het spel heeft een speler maar één kant van elke keuze.
- [vervallen, niet getest] Op elk personage dat je hebt: Terugzetten → Zet het op balk 5, 6 en 7. Staat de rode regel "MH kent deze nog
  niet" er nog? Welke namen? (Verwacht: alleen dingen die we bewust lieten liggen, zoals Summon Felguard.)
- [vervallen, niet getest] Is er een BELANGRIJKE spreuk van je blok verdwenen die er eerst wél op stond? (Kijk vooral: Feral Prowl/Dash,
  Destruction Havoc, Mistweaver Mana Tea, Resto Shaman Ghost Wolf.)
- [vervallen, niet getest] Je Warlock (Demonology): Summon Doomguard, Grimoire: Fel Ravager/Imp Lord, Power Siphon, Demonic Circle,
  Shadowfury op het blok?

## 🔍 5 okt avond — Robs Warlock (Demonology, level 82, "twelve retro"): "Put twelve retro back" + 30 onbekende spreuken

GEMETEN (screenshot): de rode regel werkt al lokaal: "Not known to Midnight Helper yet (30)". De helft is ruis uit het
algemene tabblad (Auto Attack, skyriding, Warband, Revive Battle Pets); de rest zijn echte Warlock-gaten: o.a. **Summon
Felguard**, Shadowfury, Curse of Weakness/Tongues/Exhaustion, Fel Domination, Grimoire: Fel Ravager, Demonic Circle,
Summon Imp/Felhunter/Sayaad, Subjugate Demon, Unending Breath, Ritual of Summoning/Doom, Eye of Kilrogg.
Gebouwd: de rode lijst slaat het eerste spellbook-tabblad (General) over (AFGELEID: regel 1 = General).
"Put twelve retro back": geen fout van Rob — twelve retro is een gedeelde layout die zijn Paladin al als blok had gezet;
de knop zegt nu **(alle personages)**.
- [vervallen, niet getest] Warlock na `/reload`: rode regel zonder skyriding/Auto Attack/Warband? Alleen echte Warlock-spreuken?
- [vervallen, niet getest] Knop heet nu "Zet "twelve retro" terug (alle personages)".

## 🐛 5 okt avond — Fury of Elune (Balance) kreeg geen plek; het blokvenster zei toch "elke spell heeft een plek"

GEMETEN (Rob, Carola's pc, tooltip): Fury of Elune staat in de Single-Button Assistant, maar niet in
`KeybindRoles_Druid.lua` → geen rol → geen plek. Gebouwd: het blokvenster noemt nu onderaan in het rood welke spreuken MH
nog niet kent (`KEYBLOCK_UNKNOWN_FMT`, zelfde lijst als `/mh binds`). mh-research zoekt alle ontbrekende Balance-spreuken.
- GEBOUWD (mh-research, wago 12.1.0.69933): Balance kreeg Fury of Elune, New Moon, Force of Nature, Wild Mushroom, Solar
  Eclipse, Symbiotic Relationship; Convoke, Mass Entanglement, Incapacitating Roar, Stampeding Roar en Heart of the Wild
  (op het blok als defensive) gelden nu ook voor 102. Bewust niet: Hibernate, en heals (Regrowth/Rejuvenation/Wild
  Growth/Frenzied Regeneration) die in Bear/Cat werken of al op de Stay alive-kaart staan.
  ⚠️ Het site-standaardblok rekent met ALLE talenten (ook beide kanten van 6 keuzes): 10 zonder plek. Een echte Balance
  Druid heeft er ~6 minder. AFGELEID.
- Stampeding Roar voor 102 weer eruit: hij pakte Shift-X en Revive viel van het blok (doorgerekend met Carola's spreuken).
  Doorgerekend (`ns.KeyBlockAllocate`, haar spreuken uit `/mh binds` + Fury of Elune): **Fury of Elune → F1**, **Heart of
  the Wild → X**, rest gelijk (Revive F3). Met Solar Eclipse: **Shift-3**. ⚠️ Met Solar Eclipse + Force of Nature valt
  Revive van het blok terwijl C, F2 en Shift-2 leeg blijven (de overloop gebruikt alleen vaste plekken) — ontwerpvraag Rob.
  Rob zet het vanavond met de hand op Carola's pc (geen update daar).
- [vervallen, niet getest] Na de volgende update, Carola: Terugzetten → opnieuw neerzetten. Staat **Fury of Elune** nu op het blok
  (verwacht F3 of een andere cooldown-plek)? En staan Revive, Dash, Prowl er nog?
- [vervallen, niet getest] Op Carola's pc (4.7.1): `/mh binds` → de regel met de spreuken die MH niet kent → screenshot.
- [vervallen, niet getest] Na de volgende update: `/mh block` op een Balance Druid → rode regel onderaan met Fury of Elune (tot hij erin staat).

## 🆕 5 okt avond — `/mh ready` = venstertje "Klaar voor de raid?" (Rob: "ja doe maar")

Nieuw: `Modules/RaidShoppingList.lua`. Bovenaan twee knoppen **Nieuwe baas leren** / **Farm (bekende bazen)**. Per rij:
icoon, het item voor jouw spec, *wat je hebt / wat je nodig hebt*, en rood **Koop N**. Aantallen (4 uur, AFGELEID):
leren = healing 30, combat 30, flask 4, food 4, rune 30 (optioneel); farm = 15 / 16 / 4 / 4 / 0. Healthstone: "gratis
van een Warlock". De oude chatregels: `/mh readycheck`. Ook: ketel-flasks (Fleeting) en Demonic Healthstone tellen nu mee.
- [vervallen, niet getest] `/mh ready`: opent het venster? Klopt het aantal healing potions met je tas?
- [vervallen, niet getest] Wissel **Farm** ↔ **Nieuwe baas leren**: veranderen de aantallen? Onthoudt hij je keus na `/reload`?
- [vervallen, niet getest] Muis op een rij: tooltip van het item dat je moet kopen (beste kwaliteit)?
- [vervallen, niet getest] Escape sluit het venster; slepen werkt.
- [vervallen, niet getest] 6 okt vertaald (de/fr/es/pt/it). Op een andere taal (alleen als je zo'n client hebt): past "gratis vom
  Hexenmeister" in de kolom, en wordt "Noch keine Empfehlung…" niet afgekapt?

## 🐛 5 okt avond — mounts op balk 7 bleven staan (Carola's Duckiesan, 4.7.0)

GEMETEN (Robs screenshot van de balken): op blok C staan nog Carola's **mounts** waar het plaatje Revive (F3), War Stomp,
Starfall, Prowl, Dash, Ursol's Vortex en Remove Corruption zet. Oorzaak (code): alleen spell/item/macro mochten opzij;
een mount gaf "left alone". Nu mag alles opzij (een gewone sleep), Undo ruilt het terug. Ook bar 8 vol mounts = haar eigen.
Werkt pas na een update op haar pc. Tot dan: Terugzetten → mounts zelf van balk 7 af slepen → opnieuw neerzetten.
- [x] Rob 5 okt ✅ (Carola's Duckiesan op 4.7.1, `/mh binds`-venster: balk 7 = Revive F3, Prowl, Dash, Ursol's Vortex,
  Remove Corruption, Starfall, War Stomp; mounts op Alt 2/3/4 = blok D) Een personage met een **mount** (of toy) op balk
  5, 6 of 7: Terugzetten → Zet het op balk 5, 6 en 7. Gaat de mount naar blok D en komt de spreuk op zijn plek?
- [vervallen, niet getest] En **Terugzetten**: staat de mount weer waar hij stond?

## 🔍 5 okt avond — Druid Balance (Duckiesan, pc van Robs zusje): Revive op F3? Kaart zei "F8"

Rob las op de speelkaart (tabblad Groep) "Revive [F8]", terwijl het blok Revive op **F3** zet. Mijn eerste gok ("een 3
in klein font") was FOUT: Rob keek van dichtbij, er staat echt **F8**. Waar F8 vandaan komt is NIET gemeten. Gerepareerd
wat zeker fout was: met het blok neergezet won een kopie op balk 1 (ACTIONBUTTON, rang 0) van het blok; nu blok eerst,
dan balk 1, dan de rest (`LiveKeys.lua`). Of dat de F8 verklaart, zegt alleen `/mh playkeys`.
AFGELEID na de balk-screenshot: op F3 staat een MOUNT, niet Revive (zie hierboven). Revive staat dus alleen op een
eigen knop van Carola met F8 — de kaart had gelijk. Ook open: **G** (trinket)
lijkt op de echte balk leeg terwijl het plaatje een trinket toont.
- GEMETEN 5 okt (Rob op Carola's Duckiesan, `/mh playkeys`): **Wrath** "not on a bound button of the standard bars",
  terwijl het blok Wrath op 1 heeft. Gerepareerd (`LiveKeys.lua`): laatste terugval = dezelfde spreuknaam in deze client.
  Revive-regel stond niet op de screenshots.
- [vervallen, niet getest] Na de volgende update op Duckiesan: Wrath **[1]** op de kaart? En `/mh playkeys`, de regel bij **Revive**?
- [vervallen, niet getest] (oud) Op Duckiesan: `/mh playkeys` → screenshot. Bij Revive staat de toets, het knopnummer (slot) en de balk (cmd).
  Zegt hij nu F3, dan was het de balk-1-kopie. Zegt hij nog F8, dan staat Revive niet echt op F3 → `/mh block why`.
  ⚠️ Haar pc heeft deze reparatie pas na de volgende release (of als ze MH van GitHub haalt).
- [vervallen, niet getest] `/mh block why` → regel bij **C G**: welk trinket, en heeft ze een trinket met Use: aan?

## 🆕 5 okt avond — id-ronde: 361 spreuken kregen een nummer, en de addon zoekt nu eerst op NAAM

Wat er veranderde: 361 regels in `KeybindRoles_*.lua` kregen `id = …` (wago.tools 12.1.0.69933 + Wowhead, 3 × mh-research).
En de volgorde in `KeybindAutoMap.lua`: eerst naam, dan nummer (was: eerst nummer). Op een Engelse client hoort er dus
NIETS te veranderen. AFGELEID, niet gemeten.
- [x] Rob 5 okt ✅ (screenshot: A 1 Judgment, A 2 Avenger's Shield, A 3 Blessed Hammer (35395)) Paladin **Prot**: `/mh block why` — staat **Blessed Hammer** nog op zijn plek (de oude valkuil met id 35395)?
- [vervallen, niet getest] Op 2-3 andere personages: `/mh block` → zelfde plaatje als vóór vanavond? Iets verdwenen of verschoven?
- [vervallen, niet getest] Druid (als je die hebt) met **Incarnation**: staat hij als Incarnation, niet als Berserk / Celestial Alignment?

## 🆕 5 okt — speelkaart noemt de bloktoets, niet de reservekopie op balk D

GEMETEN op Robs screenshot (Discipline, Umbrion): Flash Heal op blok **3** én op D **Alt C**; de kaart zei [Alt C].
Ook Power Word: Shield (2 / Alt X) en Evangelism (Shift 4 / Alt E). Nu: met het blok neergezet tellen balk 1 en de
blokbalken A/B/C eerst.
- [x] Rob 5 okt ✅ (screenshot) `/reload`, "Zo speel je Discipline": Flash Heal **[3]**, Power Word: Shield **[2]**, Evangelism **[Shift 4]**?

## 🆕 5 okt — geen dubbele kopieën meer op balk D (Rob: "laat die dubbele kopieën gelijk opruimen")

Bij neerzetten: een spreuk die het blok zelf krijgt wordt niet meer naar D geparkeerd, en dubbelen die al op D stonden
gaan eraf (alleen spreuken; macro's en items blijven). Undo zet alles terug.
- [x] Rob 5 okt ✅ (screenshot: D houdt alleen Resurrection, Mass Resurrection, Healthstone, Plea) Discipline: **Undo** → **Zet het op balk 5, 6 en 7**. Staan Flash Heal, Power Word: Shield, Evangelism, Desperate
  Prayer, Angelic Feather, Psychic Scream, Mass Dispel en Recuperate nu maar **één** keer (in het blok, niet ook op D)?
- [vervallen, niet getest] Chat: "… doubles off bar 1 and block D" met een getal.
- [x] Rob 5 okt ✅ **Undo** daarna: staat balk D weer zoals vóór het neerzetten?
- [x] Rob 5 okt ✅ Priest **Holy**: blok neergezet, heals op 1-4, niets dubbel op D, speelkaart-toetsen kloppen.
- [vervallen, niet getest] Zonder blok (ander personage): dezelfde toetsen als vóór vandaag.

## 🆕 5 okt — `/mh export` geeft nu ook het item-nummer (voor Wowhead-tooltips op de Armory)

- [x] Rob 5 okt ✅ `/mh export`: elke regel eindigt nu op een nummer, bv. `…|0|0|||250123:12345:6789`. Geen foutmelding?
- [x] Rob 5 okt ✅ ("ik krijg het keurig te zien") Plak het op de Armory (oude site-versie): rekent hij nog precies zoals gisteren? (Hij hoort het nieuwe veld te negeren.)
- [vervallen, niet getest] Pas als de site-kant er is: muis over een item → toont Wowhead **hetzelfde** item, met jouw item level?

## 🆕 5 okt avond — na "Nu herladen" opent het blokvenster vanzelf weer (Rob)

- [x] Rob 5 okt (Reddish): "alles goed gegaan". ✅ Druk een layout-knop → **Nu herladen** (in het venstertje of rechtsonder). Na het laden opent `/mh block` vanzelf,
  met het stappenplan, zodat je bij de volgende stap verder kunt. Een gewone `/reload` opent hem níet.

## 🆕 5 okt avond — gedeelde layout krijgt ook een eigen kopie (Rob, Reddish op "twelve retro")

- [x] Rob 5 okt ✅ Reddish (op "twelve retro", een account-layout): de middelste knop heet nu **Eigen layout + blok**. Druk →
  "Redisch Beast Mastery" (kopie van twelve retro), alleen voor Reddish/BM; je Paladin merkt niets. Nu herladen.
- [x] Rob 5 okt ✅ Je Cooldown Manager blijft bij zo'n kopie waar jij hem had (alleen kopieën van Modern/Classic tillen hem op).
- [x] Rob 5 okt ✅ Stappenplan: groene **vinkjes** zijn nu echte plaatjes (geen "|TI…").
- [x] Rob 5 okt ✅ (Ctrl+C werkte meteen, zonder klikken) Spiekbrief: klik eerst in de tekst, dan Ctrl+A, Ctrl+C (deed Ctrl+C iets anders, dan had het vak de focus niet).

## 🆕 5 okt avond — stappenplan boven het blokvenster (Rob: "waar moet ik beginnen?")

- [x] Rob 5 okt ✅ `/mh block` op Reddish: boven het venster een paneel **"Zo begin je, stap voor stap"** in grote letters, 6 stappen.
  De eerstvolgende stap is wit met een gouden cijfer; gedane stappen krijgen een groen vinkje en een grijze knop.
- [x] Rob 5 okt ✅ **Doe dit** bij stap 1 = hetzelfde als "Zet het op balk 5, 6 en 7"; stap 2 = layout-knop (+ Nu herladen-venster);
  stap 3 = muistoetsen; **Open** bij 4 = "Zo speel je"; bij 5 = spiekbrief.
- [x] Rob 5 okt ✅ Knop **Stappenplan verbergen** (bovenaan het venster) → paneel weg, venster weer in het midden; **tonen** → terug.
- [x] Rob 5 okt ✅ Past alles op je scherm (venster onderaan, paneel erboven)?

## 🆕 5 okt avond — healer-blok: elke spreuk van de speelkaart heeft een toets (Rob: "ja, advies")

Doorgerekend (data/keyblock_specs.json): Holy Pal 1 Holy Shock, 2 Flash of Light, 3 Holy Light, 4 Word of Glory, 5 Judgment,
Shift 1 Beacon, Shift 4 Light of Dawn, F1 Divine Toll, Q Avenging Wrath, F3 Holy Bulwark, F Beacon of Faith, F2 Lay on Hands.
- [vervallen, niet getest] Holy: **Terugzetten → Zet het op balk 5, 6 en 7**. Klopt dit in het spel? `/mh block why`: krijgt **Holy Bulwark** F3
  (of meldt het spel hem onder Holy Prism's id 114165?), en **Beacon of Virtue** Shift 1? (AFGELEID, nog niet gemeten.)
- [vervallen, niet getest] Speelkaart Holy: staat achter elke gele naam nu een [toets]?
- [vervallen, niet getest] Het oude `/mh apply` geeft single-target heals nu ook een toets (bewust, Rob akkoord).

## 🆕 5 okt avond — speelkaart: toets achter elke spreuk + "Zo heal je" (Rob: "ik snap er helemaal niks van")

- [x] Rob 5 okt: Holy- en Prot-blok staan goed. ✅
- [vervallen, niet getest] Holy: "Zo speel je Holy" → **Jouw knoppen**: staat achter elke gele spreuknaam de toets, bv. *Holy Shock [1]*,
  *Divine Toll [Shift 3]*, *Word of Glory [Alt E]*? Spreuken die niet op je balken staan: geen toets.
- [vervallen, niet getest] Bovenaan bij een healer: groene regel **"Zo heal je:"** (klik op de balk van je vriend, dan de toets; niemand
  gekozen = jezelf). Niet bij Prot/Ret.
- [vervallen, niet getest] Een andere spec bekijken (niet je actieve): geen [toetsen] achter de namen.
- Nieuwe teksten PLAYCARD_HEAL_HOW* alleen enUS + nlNL.

## 🆕 5 okt avond — terugzet-geheugen per spec (balken zijn per spec)

GEMETEN: Prot had het blok op de balken, Holy niet — actiebalken zijn per spec. Het geheugen is nu per personage + spec.
- [vervallen, niet getest] Holy: `/reload`, `/mh block`. Staat er "Zet het op balk 5, 6 en 7" of "Bijwerken"? (Het oude geheugen gaat naar
  de spec waarvan de balken het bewijzen.) Wissel naar Prot: zegt het venster daar iets anders, passend bij Prot's balken?
- [vervallen, niet getest] Per spec: blok neerzetten + Terugzetten raakt alleen de balken van die spec.

## 🆕 5 okt avond — volgende stap groot in beeld (Rob: "een noob weet niet wat hij nu moet doen")

- [vervallen, niet getest] Na **Eigen layout + blok**, **Zet mijn balken als blok**, **Zet "…" terug** of **Toon/Verberg oude balken**: komt er
  midden in beeld een venstertje "Je balken zijn opgeslagen. Druk op Nu herladen …" met **Nu herladen** / **Later**,
  bovenop het toetsenblok-venster? Werkt **Nu herladen** daarin?
- Nieuwe tekst KEYBLOCK_RELOAD_POPUP alleen enUS + nlNL; vertalen in de volgende vertaalronde.

## 🆕 5 okt avond — muistoetsen op balk 8 als 3 × 2 (Rob: "6 7 / 8 9 / 0 -")

- [x] Rob 5 okt: layout op Holy goed (balk 1 zonder versiering, balk 8 rechts van C als 3 × 2). ✅
- [x] Rob 5 okt (screenshot): balk 8 toont 6 7 / 8 9 / 0 -; "4 toetsen wijzen nu naar balk 8". ✅ Meeverhuizen van
  spreuken niet te zien geweest (zijn knoppen waren leeg). Cooldown Manager staat boven het blok. ✅
- [vervallen, niet getest] (oud) `/mh padkeys` (plan, verandert niets): 6 -> knop 5, 7 -> 6, 8 -> 3, 9 -> 4; 0 en - staan al goed.
  Dan `/mh padkeys go`: bovenaan **6 7**, midden **8 9**, onder **0 -**? En staat onder elke toets nog dezelfde spreuk
  als ervoor (de spreuken verhuizen mee)?

## 🆕 5 okt avond — healers: schade op het blok (Rob: "ik volg jouw advies")

Onderzoek mh-research (wago.tools build 12.1.5.70077 + Icy Veins 12.1): alleen Resto Shaman heeft nog een kick; E blijft
leeg bij de andere zes, bewust. Doorgerekend (data/keyblock_specs.json):
- Holy Paladin: 1 Holy Shock, 2 Judgment, 3 Consecration, 4 Shield of the Righteous (Holy), 5 Holy Prism.
- Disc: 1 Penance, 2 Smite, 3 Mind Blast, 4 SW:Death, 5 SW:Pain, Shift 1 Radiance, Shift 2 Holy Nova.
- Holy Priest: 1 Smite, 2 Holy Fire, 4 SW:Death, Shift 1 Sanctify, Shift 2 Holy Nova, 5 Prayer of Healing.
- Resto Shaman: 1 Lava Burst, 2 Lightning Bolt, 3 Flame Shock, Shift 1 Chain Lightning, 5 Chain Heal, E Wind Shear.
- Mistweaver: + Spinning Crane Kick Shift 2; Resto Druid: + Starsurge 4; Preservation: + Disintegrate 4.
- [vervallen, niet getest] TwelveInchy **Holy**: Terugzetten → Zet het op balk 5, 6 en 7. Staat Holy Shock op 1, Judgment 2, Consecration 3?
  En **4 = Shield of the Righteous**? (AFGELEID: lukt alleen als het spellboek id 415091 meldt.) Holy Shock is nu geen
  klik-heal meer.

## 🆕 5 okt avond — BUFF ALLY bleef staan (Holy, Beacon op Valeera)

GEMETEN: `/mh mbuff` gaf "Beacon of Light [ally]: pass=true active=false" terwijl Rob hem gaf. AFGELEID oorzaak: een
verborgen (secret) spell-id op een ander werd overgeslagen en daarna als "afwezig" gerekend. Nu: verborgen = "weet niet".
- [x] Rob 5 okt: BUFF ALLY weg; `/mh mbuff` "per unit: Twelveinchy=false  Valeera Sanguinar=nil" → GEMETEN: Valeera's
  buffs zijn onleesbaar (geheim), dus de oorzaak klopte. Keerzijde, bewust: zonder Beacon blijft de melding bij een
  onleesbare groepsgenoot óók weg (nooit iets beweren wat MH niet ziet).
- [vervallen, niet getest] (oud) `/reload`, Beacon op Valeera, `/mh mbuff`: onder Beacon of Light staat nu "per unit: <jij>=… Valeera=…". Wat staat
  er bij Valeera (true / false / nil)? Is BUFF ALLY weg? Stuur de regel als hij er nog staat.

## 🆕 5 okt avond — oud vlaggetje weg + balk 8 als 3 × 2 rechts van C

GEMETEN in de SV: na terug naar Modern en opnieuw "Eigen layout + blok" werd "Twelveinchy Holy" wel actief, maar niet
aangepast (balk 1 nog 6=0): een oud account-vlaggetje noemde hem nog "al een blok". Gerepareerd.
- [vervallen, niet getest] Holy: `/reload` → **Zet "Twelveinchy Holy" terug** → Nu herladen → **Eigen layout + blok** → Nu herladen.
  Balk 1 zonder versiering? **Balk 8** (je muistoetsen) rechts naast C als **3 rijen van 2**, even groot?
  (Het spel vult van onder: 6 7 onderaan, 8 9 midden, 0 - boven.) Cooldown Manager boven het blok?

## 🆕 5 okt avond — eigen layout: Rob getest + twee reparaties

- [x] Rob 5 okt: "Twelveinchy Holy" gemaakt, actief in Edit Mode, melding klopt. ✅
- [vervallen, niet getest] Reparatie 1: balk 1 zonder versiering (griffioenen, pijltjes). Reparatie 2: in een layout die MH net uit Modern/
  Classic maakte, gaat de Cooldown Manager boven het blok. Test: **Zet "Twelveinchy Holy" terug** → herladen →
  **Eigen layout + blok** (hergebruikt de layout) → herladen. Balk 1 zonder versiering, Cooldown Manager boven het blok?

## 🆕 5 okt avond — eigen layout per spec (Rob: "12-inch prot … voor tank")

GEMETEN door Rob: WoW onthoudt de layout per spec (Prot 5, Ret 7, Holy 1 = Modern). Niet in een gevecht, Edit Mode dicht.
- [vervallen, niet getest] TwelveInchy **Holy** (staat op Modern): `/mh block` → de knop heet **Eigen layout + blok**. Druk → melding "Deze
  spec heeft nu een eigen Edit Mode-layout "TwelveInchy Holy" (een kopie van "Modern" …)" → **Nu herladen**.
- [vervallen, niet getest] Na het herladen: Esc → Edit Mode: staat "TwelveInchy Holy" bovenaan bij de personage-layouts en is hij actief?
  Staan de vijf blokken er?
- [vervallen, niet getest] Wissel naar Prot en terug naar Holy: houdt Prot zijn eigen layout, en komt Holy weer op "TwelveInchy Holy"?
- [vervallen, niet getest] Holy: **Zet "TwelveInchy Holy" terug** → Nu herladen → Holy staat weer op **Modern**; "TwelveInchy Holy" staat
  nog in de lijst van Edit Mode (zelf weggooien mag).
- [vervallen, niet getest] Nog eens **Eigen layout + blok**: maakt hij geen tweede kopie, maar gebruikt hij "TwelveInchy Holy" opnieuw?

## 🆕 5 okt avond — trinkets: alleen te gebruiken, en allebei (Rob op TwelveInchy)

- [vervallen, niet getest] `/mh block` (Terugzetten → opnieuw neerzetten): staat op **G** een trinket met een **Use:**-effect, niet de
  passieve? Heb je er twee met Use:, dan staat de tweede op de eerste vrije plek van blok C (muis erop = welke).
  Twee passieve trinkets: G blijft leeg, en de tooltip zegt "no trinket with a Use: effect equipped".
- Tip: OPie op Shift G werkt; G blijft voor de trinket.

## 🆕 5 okt avond — elke layout zijn eigen weg terug (Rob op TwelveInchy: "Oak staat al als blok")

- [vervallen, niet getest] Paladin: `/reload`, `/mh block`. De knop heet nu **Zet "<jouw layout>" terug** (grijs zolang MH die layout niet
  als blok zette) — niet meer "Oak". **Zet mijn balken als blok** werkt, ook al staat Oak op de Hunter als blok.
- [vervallen, niet getest] Daarna **Zet "<jouw layout>" terug** → herladen: alles terug? En op de Hunter staat Oak nog steeds als blok?

## 🆕 5 okt avond — spiekbrief: code voor de site (Rob: route 1 + 3)

- [vervallen, niet getest] `/mh block` → knop **Spiekbrief (code voor de site)** (of `/mh block export`): een kopieervak met een tekst die
  begint met `MH-KEYBLOCK 1`, daarna één regel per plek (48 plekken: D, A, B, C). Staan de namen goed, ook bij macro's?
- [vervallen, niet getest] De site-pagina om hem te plakken bouwt de site-chat (opdracht verstuurd); pas daarna te testen.

## 🆕 5 okt avond — balk 1 als blok, links van D (Rob: "drie rijen van vier, links ernaast")

- [x] Rob 5 okt: Terugzetten → opnieuw neerzetten deelt alles netjes in (Mend Pet op zijn plek). ✅
- [vervallen, niet getest] **Zet "Oak" terug** → herladen → **Zet mijn balken als blok** → herladen. Vijf blokjes van 3 × 4 naast elkaar:
  **1, D, A, B, C**, met A in het midden? Balk 1 even groot als de rest, lege plekken zichtbaar?
- [x] Rob 5 okt: na afstijgen werken 1-4 gewoon weer op het blok. ✅ Tijdens het vliegen liep de volgorde door elkaar
  (oude toets-indeling uit de snapshot) → nu altijd 1 = knop 1, 2 = knop 2 … 5 = knop 5.
- [x] (Rob 5 okt: "in principe werkt het"; knop 1 linksonder, zo gelaten) Skyriding-mount: doen 1-5 nu de skyriding-knoppen **in volgorde**? (Knop 6 en hoger: geen blok-toets, dus geen
  toets — jouw 6-0 zijn je muistoetsen op balk 8.)

## 🆕 5 okt avond — pet-spreuken (Mend Pet, Revive Pet, Call Pet) in het blok

Oorzaak (mh-research): ze zitten in de spellboek-groepjes "Pet Utility" en "Call Pet"; MH las zo'n groepje niet uit.
- [x] (Rob 5 okt, screenshots) Venstertje "Mend Pet -> Ctrl 2, Call Pet 1 -> Shift V", knoppen "Zet neer / Later";
  na Zet neer staan ze op het blok. Revive Pet niet gevraagd: stond al in blok D (Alt R). ✅
- [vervallen, niet getest] (oude regel) Hunter: `/reload`. Komt het venstertje "Nieuw voor je toetsenblok: Mend Pet -> …, Revive Pet -> …"? (Call Pet
  alleen als je hem kent; MM pas met het talent Unbreakable Bond.) Zet neer → staan ze op het blok en werkt de toets?
- [vervallen, niet getest] Optioneel, als het niet komt: plak deze in de chat en stuur me de uitkomst:
  `/run for i=1,6 do print(GetFlyoutSlotInfo(103,i)) end`

## 🆕 5 okt avond — blok D, oude balken weg, Blizzard zet niets meer bij (Rob: 1 ja, 2 ja, 3 ja, D links van A)

Op de Hunter, niet in een gevecht. Eerst `/reload`.
- [vervallen, niet getest] **Bijwerken** (blok staat al): toets **3** drukt nu op Rapid Fire in blok A (niet meer op balk 1)? En Alt 1-4,
  Alt Q/E/R/F, Alt X/C/V/G zijn gekoppeld aan blok D?
- [vervallen, niet getest] Voor een schone proef: **Terugzetten**, `/reload`, **Zet het op balk 5, 6 en 7**. Chat noemt "doubles off bar 1":
  zijn de dubbele spreuken van balk 1 weg? Spullen die opzij gingen staan nu eerst in **blok D** (balk 4)?
- [vervallen, niet getest] Daarna een nieuwe spreuk leren: zet Blizzard hem NIET meer op balk 1? (`AutoPushSpellToActionBar` = 0.)
- [vervallen, niet getest] `/mh block`: vier blokken, **D links**, met wat er echt op je balk 4 staat; het venster past op je scherm.
- [vervallen, niet getest] **Zet "Oak" terug** → herladen → **Zet mijn balken als blok** → herladen: D links naast A, de vier samen in het midden?
  Balk 2 en 3 weg (te zien als je spellboek open is)? De uitleg over "spellboek / blok D" staat in de melding.
- [vervallen, niet getest] Knop **Toon mijn oude balken 2 en 3** → Nu herladen → ze staan er weer; knop heet dan "Verberg …".
- [vervallen, niet getest] **Terugzetten**: dubbelen terug op balk 1, en Blizzards "nieuwe spreuk op balk 1" weer aan.
- [x] (Rob 5 okt, screenshot) Vier blokken D-A-B-C naast elkaar, D met Revive Pet op Alt R. ✅
- [vervallen, niet getest] Balk 1 (de rij boven het blok): na **Terugzetten → Zet het op balk 5, 6 en 7** zijn de dubbelen eraf; na opnieuw
  **als blok zetten** zijn de lege knoppen van balk 1 onzichtbaar. Blijft er alleen over wat níet op het blok staat
  (bv. de Single-Button Assistant)? Op een skyriding-mount verschijnen daar de skyriding-knoppen?
- Alt-Z is bewust niet gebruikt: dat is Blizzards toets om de hele interface te verbergen (AFGELEID, niet gemeten).

## 🆕 5 okt avond — skyriding, voertuig, petbattle: toetsen even terug naar balk 1

Rob: op een vliegmount kregen de skyriding-knoppen op balk 1 geen toetsen meer. Nu: zolang balk 1 door het spel wordt
vervangen (skyriding, voertuig, override, possess, petbattle), drukken de blok-toetsen die vroeger op balk 1 zaten weer
op balk 1. Na afstijgen weer het blok. Nagekeken in Blizzards 12.1-code (mh-research), NIET in het spel.
- [vervallen, niet getest] `/reload`, `/mh block why`: onderaan "bar 1 keys during skyriding…: armed, N key(s)". Hoeveel?
- [vervallen, niet getest] Skyriding-mount, op de grond en in de lucht: doen 1-5 de skyriding-knoppen? (Het cijfer op de knop kan ontbreken.)
- [vervallen, niet getest] Afstijgen: drukt 1 weer op het blok?
- [vervallen, niet getest] Opstijgen ná een pull (in gevecht): werkt het ook dan?
- [vervallen, niet getest] Cat Form / stealth (als je die hebt): 1-5 blijven op het blok.
- [vervallen, niet getest] Een voertuig-quest of een petbattle, als je er een tegenkomt.
- [vervallen, niet getest] `/reload` terwijl je op de mount zit.

## 🆕 5 okt avond — nieuwe spreuken: Bijwerken, vraagje, schakelaar (Rob: "Ik volg jouw voorstel")

Op de Hunter (blok staat al neer):
- [vervallen, niet getest] `/mh block`: de eerste knop heet nu **Bijwerken (nieuwe spreuken erbij)**. Rechtsboven een knop **Nieuwe spreuken: vraag
  het me**; klikken wisselt naar "zet ze vanzelf neer" en "vraag het nooit". Zet hem terug op "vraag het me".
- [vervallen, niet getest] Level 12 gehaald: kwam er (na een paar seconden, buiten gevecht) een venstertje **"Nieuw voor je toetsenblok: … → toets"**?
  Zo niet: druk **Bijwerken** — komt de nieuwe spreuk dan op het blok? Bleef al het andere op zijn plek?
- [vervallen, niet getest] "Later" in het venstertje: vraagt hij het daarna niet steeds opnieuw (pas weer bij een volgende nieuwe spreuk)?
- [vervallen, niet getest] Na Bijwerken **Terugzetten**: gaat ook de nieuwe spreuk eraf en komt alles van vóór het blok terug?
- [vervallen, niet getest] In een gevecht levelen: het venstertje komt pas ná het gevecht.

## 🆕 5 okt avond — optie C: balk 1-4 blijven staan

- [vervallen, niet getest] **Zet "…" terug** → herladen → **Zet mijn balken als blok** → herladen. Balk 1-4 staan nog waar ze stonden (geen
  kolommen meer over je questlijst)? Lag een van die balken over het blok, dan staat hij nu als rij boven het blok, en de
  melding noemt hem.

## 🆕 5 okt avond — blok C verborgen en kleiner op de Hunter (layout Oak)

GEMETEN in de SV: in "Oak" stond balk 7 op Visible = Hidden (alleen te zien met het spellboek open) en de drie balken
hadden icoongrootte 3/2/0. "Zet mijn balken als blok" zet nu alle drie op "altijd zichtbaar" en op de grootste van de drie.
- [vervallen, niet getest] Hunter: **Zet "Oak" terug** → Nu herladen → **Zet mijn balken als blok** → Nu herladen. Is blok C nu altijd zichtbaar,
  en zijn A, B en C even groot?

## 🆕 5 okt avond — alle 36 toetsen horen bij het blok, ook lege plekken

- [vervallen, niet getest] Hunter: **Terugzetten**, dan **Zet het op balk 5, 6 en 7**. Staan de labels Shift Z/X/C/V, Shift 4, Shift F1 nu op
  de lege plekken van blok C (en niet meer op de kolommen rechts)? Doet een lege toets niets?

## 🆕 5 okt avond — waarschuwing in het venster als balk 5/6/7 uit staat

- [vervallen, niet getest] Hunter (balk 5-7 niet te zien): `/mh block` toont bovenaan de voetregel in **rood** "Actiebalk 5, 6, 7 staat uit …".
  Klopt de weg "Options > Gameplay > Action Bars"? (AFGELEID, niet nagekeken in 12.1.) Na aanzetten: rode regel weg?

## 🆕 5 okt avond — het oude paneel "Je balken inrichten" is kort (Rob: optie A)

- [vervallen, niet getest] `/mh setup` (of de MH-knop "Je balken inrichten"): nog maar 3 knoppen: **Je toetsenblok** (opent `/mh block`),
  **Toetsen handmatig zetten**, **Terugdraaien**. Bovenaan: "Je keybindings zijn account-breed: het toetsenblok geeft elk
  personage dezelfde toetsen." Past alles in het (kleinere) venster?

## 🆕 5 okt avond — toetsenblok: macro's gaan opzij, het blok is overal compleet

Rob: "Blok C is absoluut anders dan wat wij voorgesteld hebben … die macro's moeten dan maar ergens anders komen."
Nu: wat op een blokplek staat (ook een macro) gaat eerst naar een **vrije knop op balk 2, 3 of 4**, dan komt het blok.
Niet in een gevecht.
- [vervallen, niet getest] Eerst **Terugzetten** (de oude stand), dan `/reload`.
- [vervallen, niet getest] `/mh block`: blok C heeft nu **oranje** randen waar je macro's staan, geen rode meer. Muis erop: "Keys gaat naar
  actiebalk 2, knop 5" (of zoiets). Klopt dat?
- [vervallen, niet getest] **Zet het op balk 5, 6 en 7.** Staat blok C nu zoals op het plaatje? Staan je macro's (Justice, Hands, Clean, Keys,
  Rebuke, Taunt, Prot …) op balk 2, 3 of 4? Werken ze nog als je erop klikt?
- [vervallen, niet getest] **Terugzetten**: staan je macro's weer precies op hun oude plek op balk 7?
- Let op: een macro die opzij gaat, houdt zijn oude toets niet. De toets hoort nu bij het blok.
- [vervallen, niet getest] **Per personage** (5 okt, Rob op een laag alt): het terugzetten-geheugen is nu per personage. Op het alt: `/mh block`
  laat de randen zien (niet "staat al op je balken"), en "Terugzetten" zegt "nothing to undo". Terug op de Paladin:
  `/mh block` zegt "staat op je balken", en "Terugzetten" zet zijn macro's terug op balk 7.
- [vervallen, niet getest] (Rob "1 ja") Plekken waar MH niets voor heeft (Paladin: Shift 1, Shift 2, Shift 3, 4, Shift 4, Shift T) worden nu
  **echt leeg**: wat er stond (het blaadje, Clean) gaat ook naar balk 2-4. Oranje rand op het plaatje vóór het neerzetten.

## 🆕 5 okt avond — toetsenblok stap 2b: de balken als blok op je scherm (Rob: "1 advies, 2 advies, 3 advies")

Niet in een gevecht, Edit Mode dicht. Eerst `/reload` (je screenshot van 5 okt toonde nog de oude versie).
- [vervallen, niet getest] `/mh block`: de toets staat nu op een **eigen donker strookje** bovenin elk vakje; niets loopt meer door het icoon.
  Namen zijn minder vaak afgekapt.
- [vervallen, niet getest] Onderaan staan nu **4 knoppen**: Place it · Undo · **Arrange my bars as a block** · **Bars back as they were**.
- [vervallen, niet getest] Druk **Arrange my bars as a block**. Onderaan komt een uitleg + knop **Reload now**. Druk die.
- [vervallen, niet getest] Na het herladen: balk **5, 6, 7** staan als **drie blokjes van 3 × 4** naast elkaar onderaan in het midden?
  Balk **1-4** als kolommen rechts? Stance boven blok A, pet bar boven C, extra knop boven B?
- [vervallen, niet getest] **Balk 8** (je muistoetsen) staat nog precies waar hij stond, en het blok ligt er niet overheen?
- [vervallen, niet getest] Je **cooldown-balken** (Essential/Utility/Buffs) en de rest staan nog waar ze stonden? (Eén ervan hing aan balk 4;
  MH zet die eerst vast op zijn plek.)
- [x] Rob 5 okt: blok, kolommen en terugzetten werken. GEMETEN: het spel vult van **onder** naar boven (knop 1 linksonder),
  dus het blok stond ondersteboven t.o.v. het plaatje. Gerepareerd: plek 1-4 van het plaatje gaat nu op knop 9-12.
- [x] (Rob 5 okt, screenshot: klopt) **Na de reparatie:** eerst **Terugzetten**, `/reload`, dan **Zet het op balk 5, 6 en 7**. Staat nu **1 2 3 4 bovenaan** en
  **Z X C V onderaan**, net als op het plaatje (en je toetsenbord)?
- [x] (Rob 5 okt, screenshot: lege knoppen zichtbaar) Daarna ook **Balken terug zoals ze waren** → herladen → **Zet mijn balken als blok** → herladen: zijn de **lege
  knoppen** in het blok nu zichtbaar, zodat elk blok een strak 3 × 4 is?
- [vervallen, niet getest] Zijn balk 6 en 7 zichtbaar? Zo niet: Options → Action Bars → Action Bar 6 en 7 aanzetten.
- [vervallen, niet getest] Daarna **Bars back as they were** → Reload now → alles weer zoals vanochtend?

## 🆕 5 okt — toetsenblok: de proefrit staat nu op het plaatje

Rob 5 okt over de vorige versie: Place en Undo werken ✅; de proefrit was "een lange lijst in de chat en eigenlijk geen idee
wat ik daar op zou moeten letten". Nu: geen lijst-knop meer, de randen op het plaatje tonen het.
- [vervallen, niet getest] `/reload`, `/mh block` (niet neergezet): randen **groen** (komt hier), **oranje** (vervangt iets — muis erop zegt
  wat), **rood** (blijft ongemoeid, bv. een macro), **grijs** (staat al goed / leeg). Onderaan de uitleg van de kleuren.
- [vervallen, niet getest] Na "Place it": randen weer gewoon, onderaan "The key block is on your bars". Na "Undo": kleuren terug.

## 🆕 5 okt — toetsenblok stap 2a: neerzetten (Rob: "A1 B1 C1") — ✅ Rob: "de rest werken" (Place + Undo)

Niet in een gevecht. Begin met je **Paladin** (zijn balken ken je het best).
- [vervallen, niet getest] `/mh block`: onderaan staan 3 knoppen. Daarboven een regel "Place it would put N buttons on your bars…". Klopt
  die met wat je verwacht?
- [vervallen, niet getest] Klik **"Show what would change"**: in de chat per toets wat er gebeurt (place / already there / left alone / free).
  Staat er "action bar 6 is hidden"? Zet die balken dan aan (Options → Action Bars) en kijk opnieuw.
- [vervallen, niet getest] Klik **"Place it on bars 5, 6 and 7"**. Staan de spreuken op balk 5-7 zoals op het plaatje? Werken de toetsen
  (1 = Judgment, E = Rebuke, Q = Sentinel, T = je potion als je er een hebt, G = je trinket)?
- [vervallen, niet getest] Klik **"Undo"**: staat alles weer zoals het was (balken én toetsen, ook Shift 1-6 en Ctrl 1-3)? Een macro die op
  balk 5-7 stond hoort er nooit afgehaald te zijn ("left alone").
- ⚠️ Balken staan nog in hun oude vorm (1 rij van 12); 3 rijen × 4 naast elkaar is stap 2b.

## 🆕 5 okt — voor 4.6.1: healers/DPS op Stay alive (Rob: "advies volgen")

- [x] **Druid Balance/Feral/Resto:** Stay alive heeft **Bear Form** als grote noodknop ("no cooldown, but you deal almost
  no damage in it"). Guardian NIET. ✅ Rob 5 okt: Resto regel 3 Bear Form (vóór Heart of the Wild), Guardian zonder.
- [vervallen, niet getest] **Feral:** **Regrowth** bij de heals ("when it is free and instant, after a finisher").
- [x] Rob 5 okt ✅ (Disc zonder talent: "needs talent 193063, which you do not have", rij weg) **Priest (Disc/Holy/Shadow) MET het talent Protective Light:** **Flash Heal** als kleine verdediging. Zonder het
  talent: niet op de kaart, en `/mh survival` zegt "needs talent 193063". Heb je het talent en staat hij er tóch niet?
  Dan meldt het spel het talent anders (niet gemeten) → screenshot van `/mh survival`.
- [vervallen, niet getest] **Devastation Evoker MET Stretch Time:** **Deep Breath** als grote noodknop. Zelfde test als bij de Priest
  (talent 410352).

## 🆕 5 okt middag — laatste twee voor 4.6.0

- [x] `/reload`, `/mh play` → **Consumables** (Prot Paladin): Health Potion zegt nog maar één keer "Silvermoon Health
  Potion" bij "Also"? ✅ Rob 5 okt (screenshot).
- [x] Op **Stay alive**, **Consumables**, **Dispel** en **Group** staat nu onderaan ook de blauwe regel "This card on
  the website". Klik op Stay alive: eindigt de link op **`#alive`**? ✅ Rob 5 okt: "beide goed, go".

## ✅ 5 okt middag — Rob testte (Mage, Druid, achievement-lijst)

- [x] Mage (Frost): Stay alive 7 regels, Shimmer één keer, `/mh survival` geen "not found by id" (Cold Snap "not known"
  = niet getalenteerd, Mirror Image = geen Refractive Images). Nieuwe ids werken.
- [x] Guardian: Stay alive 10 regels, **Thrash** regel 2 met Rend and Tear-note, geen rode regels. `/mh block`: Q =
  Incarnation, Bear/Cat op Ctrl 1/2. 🐛 Ctrl 3 kreeg Remove Corruption (Guardian kent Moonkin Form niet) → gerepareerd:
  Druids houden Ctrl 1-3 voor vormen, ook leeg. → na `/reload`: Ctrl 3 leeg?
- [x] Guardian na fix: Ctrl 3 leeg ✅; Remove Corruption kwam op Shift C (overloop), Mark of the Wild + Revive "no room".
  ⚠️ Open voor stap 2: overloop zet knoppen op plekken met een andere taak (Shift C = "big def., second").
- [x] Prot Paladin: Stay alive regel 2 = Consecration (note klopt); Consumables flask = Blood Knights ✅. Cosmetisch:
  "Silvermoon Health Potion / Silvermoon Health Potion" (twee rangen) bij Health Potion → later.
- [x] `/mh achlist`: 🐛 eerst geen venster (geen ankerpunt) → gerepareerd; venster werkt: 284 van 435, groepen klappen
  open, tooltip klopt (screenshot).

## 🆕 5 okt — consumables-wissels en tank-regels op Stay alive

- [vervallen, niet getest] **Prot Paladin** `/mh play` → **Consumables**: flask = **Flask of the Blood Knights** (was Shattered Sun).
- [vervallen, niet getest] **Prot Paladin** → **Stay alive**: nieuwe regel 2 **Consecration** ("put it on the ground and stay inside"), onder
  Shield of the Righteous. Geen rode regel in `/mh survival`.
- [vervallen, niet getest] Andere tanks als je ze hebt: Blood DK **Marrowrend** bovenaan; Brewmaster **Blackout Kick** + **Keg Smash**;
  Guardian **Thrash**; Vengeance **Soul Cleave** bij de heals. Verschijnen ze (ids van Wowhead, niet in het spel gemeten)?
- [vervallen, niet getest] Een DPS met een gewisselde potion (Balance, Shadow, Demonology, Devastation, Augmentation → Potion of Recklessness).

## 🆕 5 okt — "Midnight-achievements die je nog mist" (wens #16)

- [vervallen, niet getest] `/reload`, open MH → **Achievements**: naast "Route nearest open" staat een knop **"Midnight achievements you
  miss"**. Klik: er opent een venster met 10 groepen (Delves, Quests, Exploration, Reputation, Midnight Dungeon,
  Midnight Raid, Prey, Void Assaults, Ritual Sites, Housing), elk met "x / y".
- [vervallen, niet getest] Klik een groep: klapt hij open met de achievements die je mist (+ voortgang, bv. 3/8)? Klopt het getal met
  Blizzards eigen achievement-venster (bv. Delves > Midnight 43/51)?
- [vervallen, niet getest] Klik een achievement: opent Blizzards venster op die plek?
- [vervallen, niet getest] `/mh achlist why`: één regel per groep in de chat.

## ✅ 5 okt ochtend — Rob testte (Prot Paladin, screenshots)

- [x] Stay alive Prot: 11 rijen, geen rode regel in `/mh survival`. ⚠️ Paladin-rijen kregen 4 okt GEEN nieuwe id (hadden
  ze al) → dit bewijst de nieuwe ids nog niet. Nog nodig: minstens Mage (Shimmer/Blink, Mirror Image) en liefst
  Druid/Monk/Warrior/Priest.
- [x] `/mh block` Prot: venster klopt; Q = Sentinel (Rob: "q staat hier goed"), Shift-E = Arcane Torrent, Consecration op 5,
  toets 4 leeg (SotR = defensief op X, bewust), "Every spell … has a place". `/mh block why`: regels komen.
- [x] **Edit Mode-proef geslaagd**: export → import (Umbrion, account-layout) → `/reload`: "alles staat nog op zijn plek".
- [x] Achievements: Ula'tek Uncoiled 2/4 en Assault the Vault 3/10 als meta-rij (goede namen), Coiled to Strike 11/12,
  Treasures of the Coiled Isle toont "Reward: Auriferous Venomfang".
- [x] `/mh ach cats`: 169 categorieën, 6 × "Midnight" (Delves 15571, Reputation 15600, Quests 15547, Exploration 15553,
  Midnight Dungeon 15541, Midnight Raid 15566) — GEMETEN in SV `achCatProbe`.
- [x] `/mh changelog`: 4.6.0 bovenaan met 6 regels.
- [x] `/mh shots` (08:30, ultrawide 5120x1440): 14 shots; 10 en 14 zonder zoeklijst/coach (GEMETEN, plaatjes bekeken).

## 🆕 4 okt middag — achievements (Coiled Isle) en Q voor Windwalker

- [vervallen, niet getest] **Achievements-tab**, bovenaan bij de meta's: staan er twee nieuwe uitklapbare rijen, **Ula'tek Uncoiled** en
  **Assault the Vault**, met een teller (x/y)? (Alleen zichtbaar zolang ze niet af zijn.) Klopt de naam? Een rare naam
  = fout nummer.
- [vervallen, niet getest] Kaart **Treasures of the Coiled Isle**: staat er nu een beloningsregel **Auriferous Venomfang**, met "collected"
  als je hem al hebt?
- [vervallen, niet getest] Nieuwe kaart **Coiled to Strike** (12 rares): klopt je teller met wat het spel zegt? Route-knop: wijst de pijl
  naar de dichtstbijzijnde rare die je nog mist? Szarith zit in de Underbelly (eerst de ingang).
- [vervallen, niet getest] **Windwalker Monk** (als je die hebt): `/mh block` → staat **Zenith** op Q?
- [vervallen, niet getest] **Meting voor "Midnight-achievements die je nog mist"** (wens van de Franse speler, #16): typ `/mh ach cats`.
  In de chat: hoeveel categorieën, en een lijstje "… > Midnight" met tellers. Dan `/reload` en zeg "gedaan"; ik lees
  het bestand (`achCatProbe`). Er verandert niets.

## 🆕 4 okt middag — 4.6.0 klaargezet (NIET gepusht, NIET getagd)

- [vervallen, niet getest] `/reload`, open de changelog (`/mh changelog`): staat **4.6.0** bovenaan met 6 regels?
- [vervallen, niet getest] Lees `RELEASE_NOTES.md` (= de CurseForge-tekst). Klopt het voor jou? Pas daarna "go".

## ✅ 4 okt — Rob testte live (7 screenshots, Prot Paladin)

- [x] `/mh play` Prot: 5 tabs passen (Your buttons/Stay alive/Consumables/Dispel/Group); stap 5 = Hand of Reckoning;
  Lightsmith "one button with 2 charges"; Stay alive: WoG met Shining Light-zin, géén Divine Protection; Group: alle 9
  rijen met icoon, toets en uitleg.
- [x] This Week: "Done this week: 7 (click to show)" klapt open en dicht, en blijft na `/reload` onthouden.
- [x] Account snapshot: "Silvermoon quest givers (this character): 3 / 5 done" en "Professions: fewer than 8 Dundun
  shards this week: 10 (…)". ⚠️ AFGELEID: die 10 kan nog oude nullen van vóór 3 okt bevatten (alts die sinds de reset
  maar vóór de fix inlogden; de oude code las een junk-item). Klopt pas zeker na de volgende reset.
- 🐛 **Gevonden en gerepareerd:** Stay alive met 11 rijen toonde "…" i.p.v. **10** (nummerkolom 18 px). Rij 10+ krijgt nu
  het normale lettertype (`PlayCardWindow.lua`, StepRow). ✅ Rob 4 okt na `/reload`: "de tien past nu wel".
- [vervallen, niet getest] Liadrin: "Your week" zegt **"Weekly (Lady Liadrin): done this week"** (screenshot 4 okt), terwijl Rob eerder die
  dag haar keuzescherm kreeg. Rob: nee, nog niets bij haar ingeleverd → **bug**. GEMETEN (`/run`, 4 okt): geleerde
  verhaalquest **92916 = true** (flag wist nooit), door de leer-opslag onder Liadrin gezet. 🐛 Gerepareerd in
  `ResetRoutine.lua`: alleen quests die de client "weekly" noemt worden nog geleerd en mogen "done" maken; oude geleerde
  ids alleen nog voor "in je log". `/mh weeklies` toont nu ook de geleerde ids.
  ✅ Rob 4 okt na `/reload`: Liadrin "picked up — finish and turn it in" (hij koos een quest), ritual-regel grijs.
  GEMETEN: Void Assaults-weekly `frequency` = 3 = `ResetByScheduler` (Weekly = 2) → het leren werkt.
  ❌ Daarna viel **Halduron** terug op "pick it up" (hij leverde wo 20:48 in; oude geleerde ids telden niet meer).
  🐛 Gerepareerd: een inlevering deze week (turn-in log) maakt een gever "done", tenzij er daarna nog een aanbod is
  gezien (Aethas: aanbod en inlevering allebei wo 11:39). ✅ Rob 4 okt na `/reload`: Halduron én Aethas "done this
  week", Liadrin "picked up", 7 of 12. (Aethas stond 's ochtends, vóór alle wijzigingen, ook al ten onrechte op
  "pick it up" — die fout is mee opgelost.)
- [x] Void & Rituals-tab (screenshot 4 okt): weekly-regel noemt Lady Liadrin ✅. Maar hij was **geel** terwijl de quest
  niet in de log staat: de grijs/geel-regel zat alleen in `RitualSites.lua`, niet in `WorldContent.lua` (dit tabblad).
  🐛 Gerepareerd. → Na `/reload`: is de regel nu **grijs**?
- [x] Lor'themar Theron: "pick it up next to the vault" was fout. Rob vond hem 4 okt boven in zijn gebouw (2393
  45.4/70.3), zonder quest. mh-research: 95245 "Midnight: World Tour" is **eenmalig**, geen weekly; Lor'themar geeft
  in S2 geen weekly. Rob koos **A: uit de lijst**. Weg uit ResetRoutine + WeeklyHubProbe.
- [vervallen, niet getest] Na `/reload`: staat Lor'themar niet meer in "Your week"?
- [vervallen, niet getest] **Nieuw: twee Spark-gevers** in "Your week" (ids van Wowhead + Blizzard-hotfixes, coördinaten NIET in het spel
  gemeten):
  - **Zerella** — "Sparks of War", elke week een andere zone. Klik de regel: zet de pijl haar op **Silvermoon 36.2,
    81.0**? Staat ze daar echt? Biedt ze een Sparks of War aan (War Mode aan)?
  - **Talon Commander Zela** — "Turn Back the Surge" op de **Coiled Isle 58.7, 45.8**. Staat ze daar?
  - `/mh weeklies full`: het blok "Spark givers" geeft per id de titel uit het spel. Klopt elke titel met het label?
  - Telling bovenaan wordt nu "x of 13" (−Lor'themar, +2).
  - ✅ Rob 4 okt: "7 of 13", Lor'themar weg, Zerella + Zela in de lijst. **Zerella staat op de pin** en bood "Sparks
    of War: Eversong Woods" aan (= 93423). ✅ **Zela staat op de pin** (Coiled Isle) en biedt "Turn Back the Surge"
    (Spark of Tides + Venom-Covered Chest + 1K Zul'jarra's Forces); MH ziet hem in je log na aannemen. Open: titels in
    `/mh weeklies full`.
- [vervallen, niet getest] Dundun-regel zit niet in het alt-overzicht maar in **MH → beroepen-overzicht** (Knowledge-blok bovenaan, dit
  personage): "Shards of Dundun: N / 8 earned this week". Mijn testvraag noemde de verkeerde plek.
- [vervallen, niet getest] Liadrin bood Rob 4 okt: World Quests, Saltheril's Soiree, **Vaults of Atal'Utek**, Dungeons (screenshot). Kies
  Vaults → zegt "Your week" dat hij in je log staat?

## 🆕 4 okt — link van de kaart naar de site (Rob: "do the link to the site")

- [x] ✅ Rob 4 okt (Guardian): onder de bronregel op "Your buttons" staat **"This card on the website: click for the
  link."**; eerst te klein (raw font) → nu normale grootte; klikken opent het kopieervenster.
- [vervallen, niet getest] Plak de link in je browser: opent `midnighthelper.com/play/<spec>/` de juiste pagina? (Slugs GEMETEN uit de live
  sitemap; op een Duitse/Franse… client wordt het `/de/play/…` enz.)

## 🆕 4 okt — Delve Coach: vinkje "vanzelf openen" (Rob: "bouw die knop maar")

- [x] ✅ Rob 4 okt (screenshot All settings): **"Open the Delve Coach by itself"** staat er, aangevinkt.
- [vervallen, niet getest] Zet hem uit en loop een delve in: gaat de coach níét vanzelf open, en ook geen "open coach?"-knopje bij de baas?
  `/mh coach` opent hem dan nog wel. Daarna weer aan.

## 🆕 3 okt laat — "Stay alive" nagelopen + Liadrin/Stormarion (niet uitgebracht)

`/mh play` → tab **Stay alive**. Alleen kijken op de klassen die je hebt:
- [x] ✅ Rob 4 okt (Guardian Purlymixanox, alle 4 specs via de knopjes): Guardian zonder HotW en zonder Wild Charge;
  Feral zonder Wild Charge; Balance + Resto met Frenzied Regeneration en Regrowth. NIET te zien vanaf een Guardian
  (de kaart kijkt in het eigen spellbook): Wild Charge op Balance, Ironbark op Resto — pas op een Balance/Resto-druid.
- [x] ✅ Rob 4 okt (Purlymixanox, Skinning 100/100): Skinning-advies "Lasting Leather (0/40), Superb Scales (0/40)" klopt.
  🐛 Maar "Skinning: trainer weekly **(needs skill 25 first)**" bij skill 100: de zin werd ALTIJD achter de
  gatherer-weekly gezet. Gerepareerd in `ProfessionsHub.lua` (alleen als de Midnight-skill < 25 of onleesbaar).
- [x] ✅ Rob 4 okt na tweede poging: Skinning nu zónder die zin. (Eerste poging las `C_TradeSkillUI` → zei niets bij
  gesloten beroepenvenster. GEMETEN `/run`: GetProfessionInfo geeft "Skinning 100 100 393" → die bron gebruikt.)
  Zelfde bron nu ook in `ProfessionNextStep.lua` (This Week, gatherer-weekly onder 25 verbergen).
- [x] ✅ Rob 4 okt: This Week op Purlymixanox toont nog "Trainer weekly (Skinning): pick it up at your profession
  trainer" (skill 100 = hoort te blijven).
- [vervallen, niet getest] Op een alt met een verzamelberoep ónder skill 25: valt die regel in This Week weg?
- [x] ✅ Rob 4 okt (Redisch, Blacksmithing + Enchanting): overzicht met advies per beroep, Enchanting-weekly afgevinkt.
- [x] Rob 4 okt, Redisch (BM Hunter 90): Group-tab leeg op alle 3 specs ("None of these buttons…"). GEMETEN met `/run`:
  `C_Spell.GetSpellInfo("Misdirection")` en `("Roar of Sacrifice")` = **nil**, IsPlayerSpell 34477/53480 false → hij heeft
  ze niet (talenten niet gekozen); Primal Rage/Master's Call: pet niet van het juiste type. **MH klopt.** Niet te testen
  op deze hunter: Group-rijen en de pet-note van Roar of Sacrifice — wacht op een hunter mét die talenten.
- [vervallen, niet getest] (oud punt, deels afgevinkt hierboven) **Druid:** Guardian heeft géén Heart of the Wild meer en géén Wild Charge bij "wegkomen". Balance heeft nu
  **Frenzied Regeneration** en **Regrowth** bij heal, en Wild Charge met "jumps you backwards". Resto: Ironbark staat
  bij de kleine knoppen, ná Barkskin.
- [vervallen, niet getest] **Evoker:** Obsidian Scales staat bij de **grote** knop, Zephyr bij de kleine.
- [vervallen, niet getest] **Brewmaster:** staat **Celestial Infusion** erop als je dat talent hebt (anders Celestial Brew)? En verandert
  er níéts aan je toetsen (Layout-tab)?
- [x] Mirror Image: Rob 4 okt (Frost) `IsPlayerSpell(1309497)` = **false**, maar de Arcane-kaart toonde Mirror Image
  toch. 🐛 Gerepareerd: nieuw veld `survivalRequires` — alleen met Refractive Images, elke spec. ✅ Na `/reload`:
  `/mh survival` "needs talent 1309497, which you do not have". Open: iemand MÉT het talent ziet hem wel.
- [vervallen, niet getest] **Death Knight:** Lichborne bij de kleine knoppen. **Demon Hunter:** geen Darkness meer. **Rogue:** geen Shadowstep.
- [vervallen, niet getest] **Marksmanship:** Roar of Sacrifice zonder "your pet takes part of the damage".
- [x] ✅ Rob 4 okt, Demonology lvl 82: Axe Toss ontbrak ("not found by name"). GEMETEN: Command Demon 119898 →
  override 119914, IsPlayerSpell 119898 true / 119914 false / 89766 false. Gebouwd: `survivalId` = 119898 +
  `survivalOverride` (alleen tonen als de override echt Axe Toss is). Na `/reload`: **Axe Toss staat er als 7**, `/mh
  survival` zegt "+". Spell Lock (Affli/Destro, override 119910 AFGELEID) nog niet gezien.
- [x] ✅ Rob 4 okt, Affliction: **Spell Lock staat erop** (rij 6) → override 119910 daarmee GEMETEN.
- [x] ✅ Rob 4 okt, Elemental (Horde): Group-tab toont alleen **Bloodlust**, geen Heroism (+ Wind Rush Totem,
  Ancestral Spirit).
- [x] ✅ Rob 4 okt: "Shards of Dundun: 0 / 8 earned this week" in Tools → Professions → Treasures & Books (Engineering +
  Jewelcrafting-alt). Currency 3376 + naamcontrole werkt. **Devourer** — staat Shift erop? **Windwalker** met Combat Wisdom — is Expel Harm weg?
- [vervallen, niet getest] Liadrin: pak je **Arcantina, Offworld Showdowns, Raid** of **Vaults of Atal'Utek**, zegt "Your week" dan dat
  hij in je log staat (niet "ga ophalen")? `/mh weeklies` noemt hem dan niet meer als onbekend.
- [vervallen, niet getest] Void & Rituals-tab: heeft de Stormarion-regel nu in **elke** fase een tooltip (ook bij "bouwen" en "verdedigen")?

## 🆕 3 okt avond — kaarten, achievements, gear, wereld

- [x] ✅ Rob 4 okt: Arcane Mage-kaart 5 stappen, stap 3 = **Prismatic Bolt** met icoon. Frost- en Fire-kaart ook gezien,
  in orde. (Opgevallen: "Arcane Pulse" en "Arcane Soul" niet geel/gelinkt in de Arcane-tekst — geen fout, wel een
  mogelijke verbetering.)
- [vervallen, niet getest] Achievements: staan de **Slugger**-kaarten nu op klaar als je ze echt hebt (eerst 6/10 en 15/19)?
- [vervallen, niet getest] Ready-check op een DK: vraagt hij nu om **weapon oil**? Op Enhancement niet meer. Telt hij een flask/potion van de
  andere kwaliteit (278 i.p.v. 295) als "heb je"?
- [vervallen, niet getest] Wapen-enchantadvies op een DK: geen voorstel meer. Op andere specs staat **Rite of the Hash'ey** als laatste optie.
- [x] ✅ **GEMETEN door Rob 4 okt (Redisch):** Maella bood eerst de intro "Through the Cold Rift"; de portal toonde Val
  (Normal/Heroic); op Val bood ze **"Showdown on Val"** (Riftstalker's Cache) + "Surveying the Frozen Wastes". De
  S2-blokkade in `Showdowns.lua` is weg → Maella is weer een gewone stop in "Your week" en de Showdowns-sectie toont
  weer. ✅ Rob 4 okt (Purlymixanox na `/reload`): **Riftblade Maella staat weer in "Your week"** (stap 7, portaltekst),
  naast Zerella en Zela; "3 of 14". Void & Rituals-regel nog niet bekeken.
  🌐 Online 3 okt (mh-research, `scratchpad\online\answers.json`): **waarschijnlijk ja** — Wowhead 3 aug + Icy Veins 15 aug/29 sep;
  de hotfix waar de blokkade op rust ging over *Sparks of War* (96725/96726, Zerella), niet over Maella. AFGELEID: geen
  spelersreactie na 18 aug gevonden. Eén blik in het spel beslist het.
- [x] 🌐 Online 3 okt, GEMETEN (Wowhead-questtype + wago AreaPOI): Stormarion weekly = **90962**, 94581 = herhaalbaar.
  POI 8419/8421/8422 = één event in drie fases. ✅ Gebouwd 3 okt laat (`EventInfoData.lua`), test staat hierboven.
- [vervallen, niet getest] Rares: dood een rare op een niet-resetdag, typ de volgende dag `/mh rarequests`: staat hij weer op "--"? Dan is het dagelijks.

## 🆕 3 okt avond — beroepen

- [vervallen, niet getest] Alt-overzicht → tooltip van een personage met beroepen: staat er een **Dundun**-regel met een echt getal? (MH leest
  nu de valuta, mét naamcontrole.) Staat er géén Dundun-regel, typ dan `/dump C_CurrencyInfo.GetCurrencyInfo(3376)` en
  stuur me de naam die eruit komt.
- [vervallen, niet getest] Professions → boeken-kaart: tooltip van een **Anomander/Caeris/Magovu**-boek zegt nu "Voidlight Marl: 750" + renown;
  een **Echo of Abundance**-boek nog steeds Abundance.
- [vervallen, niet getest] Beroepen-wizard: zegt de "open je venster"-stap **K**? Vinkt de weekly-stap zichzelf af als je de weekquest hebt
  ingeleverd (en volgende week weer open)?
- [vervallen, niet getest] Herbalism-advies: noemt het eerst **Midnight Overload openen (0 punten)**? Skinning: eerst 10 in Thorough Tanning,
  dan Lasting Leather of Superb Scales?
- [vervallen, niet getest] This Week op een alt met een verzamelberoep onder skill 25: géén "weekly nog niet opgepakt"-regel meer.

## 🆕 3 okt avond — world boss

- [x] 🌐 Online 3 okt, GEMETEN (Wowhead): Liadrin-ids Arcantina 93767, Offworld Showdowns 96727, Raid 93912, Vaults of
  Atal'Utek 98232 (+ World Boss 93913, Stormarion 93892). ✅ Gebouwd 3 okt laat (ResetRoutine + WeeklyHubProbe).
- [x] 🌐 Online 3 okt: Nymrissa 279/292/305/318 (GEMETEN); Pertinax/Leth'ir houden S1-buit (±259, AFGELEID); de vier oudere
  bazen onbeslist (246 of 256).
- [vervallen, niet getest] Codex "World boss (Midnight)": staat Liadrins quest erin?

## 🆕 3 okt avond — Ritual Sites nagelopen

- [vervallen, niet getest] Ritual-tab (Silvermoon → Ritual Sites): de weekly-regel noemt nu **Lady Liadrin** en is grijs als de quest niet
  in je log staat, geel als hij er wél in staat.
- [vervallen, niet getest] Op een alt die de intro nog niet af heeft: noemt de hint na **Void Strike** nu **Ritual Interest** als volgende
  stap (eerst Ritual Problems)?
- [vervallen, niet getest] In Daggerspine Point, fase 2: heet de baas in het MH-venster **Void-Infused Mindbreaker**, en staan er nu korte
  tips (ook bij Lady Selen'vjar)? Kloppen ze met wat je ziet?
- [x] 🌐 Online 3 okt (AFGELEID): nebula en spiegels alleen met Malevolent Boons.
- [x] 🌐 Online 3 okt, GEMETEN: npc 257498 heet **"Selen'vjar"**; scenario-tekst en kist zeggen "Lady Selen'vjar".

## 🆕 3 okt middag — "Zo speel je": vijfde tab "Group" (eerst Prot Paladin)

Op je **Prot Paladin**, `/mh play`:
- [vervallen, niet getest] Er is een vijfde tab **Group** (nl "Groep"). Past de rij tabs nog in de breedte?
- [vervallen, niet getest] Group toont: Blessing of Sacrifice, Blessing of Protection, Blessing of Spellwarding, Word of Glory, Lay on Hands,
  Blessing of Freedom, Devotion Aura, Intercession, Redemption — elk met icoon, je toets, en een korte uitleg. Een talent
  dat je niet hebt, hoort weg te vallen. Onderaan een bronregel met datums.
- [vervallen, niet getest] `/mh group`: per knop + of − en waarom. Staat **Intercession** op + (id 391054)?
- [vervallen, niet getest] Nu hebben bijna alle specs een Group-tab. Kijk ook even op een **alt van een andere klasse** (vooral een
  hunter met pet: staat **Primal Rage** erbij met een Ferocity-pet? Master's Call met een Cunning-pet?). Een shaman
  hoort alleen Bloodlust (Horde) óf Heroism (Alliance) te zien, niet allebei.
- [vervallen, niet getest] Demon Hunter en Rogue horen **geen** Group-tab te hebben (`/mh group` zegt dan "no group list yet").
- [vervallen, niet getest] Bekijk je via de spec-knoppen een andere spec en heb je die knoppen niet: dan staat er "Geen van deze knoppen
  zit nu op dit personage…", geen lege lijst.
- [vervallen, niet getest] In het Duits/Frans: passen vijf tabs nog naast elkaar?
- [vervallen, niet getest] Rez/Bloodlust-paneel (`/mh lust test`) op je **Prot Paladin**: staat Intercession er nog met je toets? (het
  oude nummer 461622 is eruit, alleen 391054 blijft).
- [vervallen, niet getest] Op een **Marksmanship-hunter**: toont het paneel Harrier's Cry als jouw Bloodlust-knop, zonder "(met de juiste pet)"?
- [vervallen, niet getest] Op een **Survival-hunter**: krijgt Primal Rage nu een plek in het toetsenschema (eerst alleen Beast Mastery)?

## 🆕 3 okt middag — "Zo speel je": 4 kaarten bijgewerkt

- [vervallen, niet getest] Resto Shaman (AOE): Ascendance-regel + Healing Rain; S3 zegt "als je Unleash Life hebt".
- [vervallen, niet getest] Outlaw Rogue (S4): Pistol Shot pas bij 6 stacks. Subtlety (S2 + MISTAKE) en Augmentation (S3: Breath of Eons op
  cooldown) — lees ze één keer als je die specs speelt; de bronregel onderaan elke kaart heeft nu nieuwere datums.

## 🆕 3 okt middag — "Zo speel je": Prot Paladin + interrupt-macro's

Op je **Prot Paladin**, `/mh play` (of de knop "How you play"):
- [vervallen, niet getest] Tab "Your buttons" heeft nu **5** stappen; de vijfde: *"Pull with Hand of Reckoning, and taunt with it whenever an
  enemy hits someone else."* Met het taunt-icoon.
- [vervallen, niet getest] De Lightsmith-regel zegt nu dat het **één knop met 2 charges** is (Holy Bulwark ↔ Sacred Weapon).
- [vervallen, niet getest] Tab "Stay alive": bij **Word of Glory** staat *"uses the same Holy Power as Shield of the Righteous: press it when
  it is free (Shining Light)"*. Op je Ret/Holy hoort die opmerking NIET te staan.
- [vervallen, niet getest] "Stay alive" toont op Prot geen **Divine Protection** meer (die heeft Prot niet in 12.1).
- [vervallen, niet getest] Interrupt-macro's (Macros-tab): op een **Resto Druid**, **Preservation Evoker** of **Mistweaver** wordt geen
  kick-macro meer aangeboden (die specs hebben er geen in 12.1). Op Feral/Guardian/Dev/Aug/BM/WW wel.

## 🆕 3 okt middag — drie kleine dingen (Account snapshot / This Week)

- [vervallen, niet getest] Account snapshot: de regel heet nu **"Silvermoon quest givers (this character): N / M done"** (was "SMC weekly
  checklist"), en **"Professions: fewer than 8 Dundun shards this week: …"** (was "Profession Dundun weekly below 8").
- [vervallen, niet getest] "Gilded Stash (this character): N / 4 Bountiful delves on Tier 11" (was "T11 bountiful runs").
- [vervallen, niet getest] Een alt die je deze week nog niet hebt ingelogd: "Needs a relog since the weekly reset" (geen "Wednesday" meer).
- [vervallen, niet getest] Zet in de MH-instellingen de **Vault-herinnering uit** en open This Week: klopt het Great Vault-blok nog (staat er
  iets klaar, dan hoort het dat te zeggen)? Daarna weer aanzetten.

## 🆕 3 okt middag — This Week stap A + SMC-teller

- [vervallen, niet getest] "Your week": de groene vinkjes zijn weg en er staat één regel **"Done this week: N (click to show)"**. Klik erop:
  komen de vinkjes terug en wordt het "(click to hide)"? Blijft je keuze na `/reload`?
- [vervallen, niet getest] "Next up" en "N of M weekly things done" kloppen nog (die telling is niet aangeraakt).
- [vervallen, niet getest] Weekly chores op This Week: de regel "SMC weekly checklist" is weg (de quest-gevers staan al in "Your week").
- [vervallen, niet getest] **Account snapshot**: "SMC weekly checklist (this character)" telt nu de quest-gevers zoals "Your week"
  (bv. 4 / 6 als Liadrin, Halduron, Vereesa en Maella klaar zijn). Klopt het getal met wat je in "Your week" ziet?

## 🆕 3 okt middag — This Week korter (optie C)

Na `/reload`, op This Week:
- [vervallen, niet getest] Volgorde: Next up → Your week → Professions → Great Vault | World Boss → Weekly chores → Rares/Ritual/Void, en pas
  **onderaan** Mount wishlist → Collectible mounts → Raids → de dagtip.
- [vervallen, niet getest] **Get ready for Season 2** is weg (alles was afgevinkt).
- [vervallen, niet getest] **Professions** toont alleen nog "Knowledge unspent"; de trainer-weekly staat alleen in "Your week".
- [vervallen, niet getest] **Weekly chores** heeft alleen regels voor dít personage (SMC, Delver's Call, Gilded, Trove, Special Assignments) +
  "Open Account snapshot". Geen alt-namen meer. Staan ze nog wel op de **Account snapshot**?
- [vervallen, niet getest] Ritual Sites en Void Assaults: geen "Weekly: done / not yet" meer.
- [vervallen, niet getest] Hoeveel korter voelt het? (Voor: ±68 regels.)
- [x] ✅ Rob 3 okt (3 screenshots na reload): volgorde, Professions alleen Knowledge, Weekly chores alleen dit personage +
  link, Void zonder "Weekly", naslag onderaan — alles zoals bedoeld. Seizoenskaart-top niet in beeld.

## 🆕 3 okt middag — aggro: wegwijzer naar Blizzards eigen opties (threat-optie 1)

- [x] `/mh aggro`: vier regels, menunamen uit de client, geen "unknown" — Rob 3 okt live (screenshot): Aggro Display on,
  Aggro Highlight on, Combat Audio Alerts off, frame-gloed on. Nog niet naast het Settings-paneel gelegd.
- [x] ✅ Rob 3 okt na `/reload`: tip toont de titel goed. Solo-stand aan: grijze regel + geen Mythic+/Raids (screenshot).
  Solo-stand uit: Raids-blok terug, grijze regel weg (Mythic+-blok ontbreekt omdat er voor dit personage niets te melden
  is). ✅ Solo-schakelaar (4.5.0) daarmee GEMETEN door Rob.
  Na `/reload`: zegt de dagtip "Today's tip: Aggro: who is the enemy hitting?" (Rob zag eerst de ruwe sleutel
  `CODEX_AGGRO_TITLE` — AFGELEID: zijn client laadde in het gat tussen het Codex-item en de teksten; tekst staat GEMETEN
  in alle 7 Codex-blokken). Staat er na een reload nog een sleutel: echte bug.
- [vervallen, niet getest] Codex > Dungeons & M+ > **Aggro: who is the enemy hitting?**: staan de menunamen er netjes in (geen `{UI:…}`)?
- [vervallen, niet getest] Zet Aggro Display > Flash aan en trek in een dungeon als DPS een mob: flitst de nameplate? (Zo weten we dat de uitleg klopt.)
- [vervallen, niet getest] **Meting voor optie 2** (staat op de voorstelpagina): de twee `/run`-regels op een trainingspop en in een dungeon
  (trash én baas). SECRET of `true` = optie 2 kan daar niet.

## 🆕 3 okt middag — spec-functies via de nieuwe Blizzard-naam (31 modules)

Niets hoort er anders uit te zien; dit is onderhoud zodat MH de volgende uitbreiding overleeft.
- [x] Na `/reload` op de 12.1.5-PTR: BugSack "You have no bugs, yay!" — Rob 3 okt (screenshot). (BugSack + BugGrabber
  stonden niet in `_xptr_`; gekopieerd uit live.) Live nog te zien.
- [x] `/run print(C_CVar.GetCVar('loadDeprecationFallbacks'),GetSpecialization==C_SpecializationInfo.GetSpecialization,C_SpecializationInfo.GetSpecialization())`
  — Rob 3 okt, 12.1.5-PTR, Frost Mage: "true" en 3. ✅
- [x] *Zo speel je*-kaart (Frost) en `/mh stats` (mastery "Freeze and Shatter" met tekst uit het spel) werken op de PTR —
  Rob 3 okt (screenshot + plak). ✅ Tank-toolkit op live als Prot Paladin (Rob 3 okt, screenshot Role Academy): "Logged in:
  Paladin - Protection", SotR + 5 defensives, geen preview-regel.
- [x] `/mh simc`: `role=spell` staat erin — Rob 3 okt. Daarbij gezien: `region=` was leeg op de PTR → gerepareerd
  (lege regionaam telt nu als ontbrekend). ✅ Daarna `region=us` — Rob 3 okt.

## 🆕 3 okt middag — valuta, crests en Great Vault (7 talen, nog niet uitgebracht)

- [vervallen, niet getest] Crests-tab (Dawncrest-gids): staat onderaan de regel *«…of the Mist» achievements halve the crest cost…*? En
  heb je een «…of the Mist»-achievement, staat die dan als "gehaald" bij de juiste tier (de NAAM komt uit het spel —
  klopt hij)? ID's 62410/62411/62412/62414/62416 komen van Wowhead.
- [vervallen, niet getest] Valuta-gids: past de **vijfde** knop *Zul'jarra* nog op de rij, en zet hij de pijl bij **Jan'sari the Watchful**
  op Tokka's Landing (Coiled Isle)?
- [x] ✅ Rob 3 okt (screenshot): de NPC heet in het spel **Cuzolth** <Item Upgrades>. Klikbare naam in de crests-tekst nog niet gezien.
- [x] ✅ Rob 3 okt: valuta-gids noemt Jan'sari the Watchful (Tokka's Landing, Coiled Isle) als vijfde QM; de knop zelf nog niet gezien.
- [x] ✅ Rob 3 okt: Codex-hoofdstuk Aggro toont alle menunamen netjes.
- [vervallen, niet getest] Vault-adviseur als **Resto Druid/Holy Paladin/Disc/Holy Priest/Mistweaver** met profiel M+: staat er "M+ stat
  profile" en een M+-volgorde (Resto Druid: Mastery > Haste > Vers > Crit)?
- [vervallen, niet getest] `/mh curscan` op een character dat crests heeft **uitgegeven**: is "totalEarned" het getal uit de tooltip
  *Current Season Maximum*? (Daarna pas de crest-telling in `CurrencyAccount.lua:495` ombouwen.)
- [vervallen, niet getest] **21 okt (EU)**, na het wegvallen van de crest-cap: `/mh curscan` en `/mh crests save` — zakt het crest-maximum
  naar 0? Zo niet, dan toont MH nog een cap die niet meer bestaat.
- [x] 🌐 Online 3 okt, GEMETEN (wago ChrSpecialization): Devourer = **1480** → eigen stat-gewichten is een code-punt.

## 🆕 3 okt — 8 overige dungeons: nieuwe korte tips (7 talen)

Antwoorden van een helper via Wowhead (GEMETEN op de site, niet in het spel): Windrunner Spire en Maisara Caverns
alleen Normal; Saprish heeft op Normal/Heroic alleen Darkfang, Shadewing alleen Mythic/M+.
- [x] ✅ Rob 3 okt (screenshot): "Midnight Heroic: Season 2" = DN, MR, BV, AF, VA, KR, RLP, TS — Windrunner Spire en
  Maisara Caverns staan er niet bij. GEMETEN.
- [vervallen, niet getest] Encounter Journal (Shift-J) → Saprish: verschijnt Shadewing alleen bij Mythic? (Rob 3 okt: op **Heroic** staat
  Shadewing niet in het overzicht ✅; Mythic nog bekijken. Seat heeft in het journal alleen Heroic en Mythic.)
- [vervallen, niet getest] Na `/reload`: het MH-zijpaneel naast het Adventure Guide toont bij Saprish een spreuknaam i.p.v. `{SPELL:1263523}`
  (bug gezien door Rob 3 okt, gerepareerd in `EncounterJournalSidePanel.lua`).
- [vervallen, niet getest] Open de dungeontips van een van deze bazen in MH: staan de korte tips er netjes, met maximaal 3 regels?

## 🆕 3 okt — delve-foutjes (in `main`, nog niet uitgebracht)

- [x] ✅ Rob 3 okt (screenshots Torment's Rise / Gnarldor Isle): niet-Bountiful = geen End + blauwe regel; Bountiful =
  End 266…295 zonder blauwe regel; overal "Vault ?". De drie tooltip-vragen hieronder zijn daarmee beantwoord.
- [vervallen, niet getest] Delve-tooltip: hover in het Delves-tabblad over een delve die **niet** Bountiful is. Staat er bij de tiers géén
  "End …" meer, en onderaan een blauwe regel *"End-chest numbers only apply to Bountiful delves…"*?
- [vervallen, niet getest] Delve-tooltip: hover over een **Bountiful** delve. Staat "End 266 … End 295" er nog wel, en is de blauwe regel weg?
- [vervallen, niet getest] Delve-tooltip: staat er in de Vault-kolom overal "Vault ?" (geen "Vault 305*" meer bij Tier 1)?
- [x] ✅ Rob 3 okt (screenshots This Week): alleen "Delver's Call banked on alts" staat er, "incomplete on alts" is weg.
  Weekoverzicht (This Week / Account snapshot): is de regel *"Delver's Call incomplete on alts"* weg? De regel
  *"Delver's Call banked on alts"* mag blijven als een alt quests bewaart.
- [vervallen, niet getest] Collegiate Calamity: zegt de route-regel in chat nu **Luminbulb** (zonder i)?

## 🆕 2 okt avond — 4.5.0: delves + Valeera, solo-schakelaar, Speed Grade weg

Rob: *"delfpagina's is goed, want ik vertrouw op jou"*. 54 teksten (enUS/nlNL; 162 vertalingen waar al een
vertaling bestond — delves die in de/fr/es/pt nooit vertaald waren blijven Engels, zoals vóór vandaag).
- [vervallen, niet getest] `/reload` zonder fout (BugSack leeg).
- [vervallen, niet getest] **Instellingen → Window → "Ik speel vooral solo"** aan: op Home verdwijnen de blokken Mythic+ en Raids, en
      er staat een grijze regel *"Solo-stand: Mythic+ en raids zijn verborgen…"*. Uit: alles weer terug.
- [vervallen, niet getest] Delve-tooltip (Delves-tab, hover een rij): géén *"MidnightHelper: Speed Grade"* meer.
- [vervallen, niet getest] Survey-uitnodiging zegt nu *acht* vragen; op de site staat vraag 8 *"Anything else you want to tell us?"*.
      Stuur hem één keer zelf in en kijk of de mail een blok *"Verder nog:"* heeft.
- [vervallen, niet getest] Kaartlabels in `{WAY:}`: in de/fr/it staat nu het Engelse label (bv. *Sturdy Chest 1*), in es/pt vertaald.
      Alleen als het een Duitse/Franse speler stoort.
**Vragen uit de delve-review — niets veranderd, jij bent de meting:**
- [vervallen, niet getest] The Shadow Enclave: Shadow Enclave, Infiltrate and Ameliorate: zie je daar ook zwevende Eyes of Antenorian? Ja = de Eyes-regel mag voor alle varianten behalve Mirror Shine gelden; nee = zo laten.
- [vervallen, niet getest] The Shadow Enclave: Shadow Enclave, Traitor's Due of Shadowy Supplies: heet de zware shadow-cast van de Twilight Ogre Mage 'Sullen Shadowball' en kun je hem kicken? Ja = regel klopt; andere naam = die naam doorgeven.
- [vervallen, niet getest] Collegiate Calamity: Collegiate Calamity, Academy Under Siege: zegt de tracker 'Arcane Wards activated 0/4'? Ja = nieuwe ROUTE klopt; staat er iets over portals = melden.
- [vervallen, niet getest] Collegiate Calamity: Collegiate Calamity, Faculty of Fear: vallen onthulde studenten je zelf aan ('ambush')? Ja = regel blijft; nee = 'vóór de ambush' kan weg.
- [vervallen, niet getest] Collegiate Calamity: Collegiate Calamity, boss: helpen de studenten in 12.1 nog mee, en zitten ze bij Garand aan het begin vast in een paarse cirkel? Ja = nieuwe BOSS-regels kloppen; nee = die twee regels schrappen.
- [vervallen, niet getest] The Darkway: The Darkway: wie cast Twilight Seekers, trash of alleen Infiltrator Gulkat? Alleen Gulkat = 'Twilight Seekers' kan uit de TRASH-regel; ook trash = zo laten.
- [vervallen, niet getest] The Darkway: The Darkway, Eggsplosive Growth: verdwijnen er eieren als je een Venom Clogged Ley Line reinigt, en zegt de tracker 7 / 45? Ja = nieuwe ROUTE klopt.
- [vervallen, niet getest] The Darkway: The Darkway: moet je bij Shadowfuse Sentinels een cast kicken (Method noemt Discharge, een grote cirkel)? Ja = naam van de cast doorgeven, dan komt er een TRASH-regel bij.
- [vervallen, niet getest] Parhelion Plaza: Parhelion Plaza, Caustic Crush: wat gebeurt er aan het eind? Alleen de Ritual Pillar = MH klopt; verschijnt er ook Replicating Venomborne (Icy Veins zegt dat) = dan krijgt BOSS de Venomborne-regels die al bij The Darkway staan.
- [vervallen, niet getest] Parhelion Plaza: Parhelion Plaza, Caustic Crush: heeft de Ritual Pillar zelf aanvallen (het is in de DB2 een eigen 'encounter')? Ja = beschrijf wat je zag, dan komt er een BOSS-regel bij.
- [vervallen, niet getest] Parhelion Plaza: Parhelion Plaza: klopt de ingang (torengebouw, tweede verdieping, trap omlaag)? Ja = nieuwe OVERVIEW-regel blijft.
- [vervallen, niet getest] Atal'Aman: Ritual Interrupted: komt er na het redden van de furbolgs een stap bij Nalorakk's Shrine met golven vijanden? Ja = nieuwe ROUTE-regel 2 klopt. Nee = die regel eruit.
- [vervallen, niet getest] Atal'Aman: Totem Annihilation: zie je bliksemcirkels op de grond die snel afgaan? Ja = nieuwe TRASH-regel klopt. Nee = eruit.
- [vervallen, niet getest] Atal'Aman: Jin'Ma: loop meteen na Flaying Knife naar je spirits. Gaan ze dood of krijgt Jin'Ma een buff? Ja = de 6-secondenregel klopt.
- [vervallen, niet getest] Atal'Aman: Disciple of Vashnik: ga achter een schedelbeeld staan als hij Toxic Froth doet. Krijg je het gif toch = 'helpt niet meer' klopt. Krijg je het niet = die zin moet eruit.
- [vervallen, niet getest] Atal'Aman: Toadly Unbecoming: vallen beesten de gehexte Amani aan? Nee = TRASH-regel 'Beasts weg van NPCs' schrappen.
- [vervallen, niet getest] Atal'Aman: Venomous Vapors: DB2 heeft een stap 'Tunnels exited' (CriteriaTree 222621) die de tip niet noemt. Wat moet je daar doen (springen met de Springstep Rune?)? Zeg het, dan komt er een route-regel bij.
- [vervallen, niet getest] Twilight Crypts: Blademaster Darza: blijf op een lage tier vlak bij haar staan als ze Bask in the Twilight doet. Raakt het je hard = nieuwe regel 'ren 10 yards weg' klopt. Raakt het je niet = de regel moet anders.
- [vervallen, niet getest] Twilight Crypts: Loosed Loa: zie je Mot'amra rood door de muren heen, en maakt het Evasive Elixir je 4 seconden een pot? Ja = nieuwe ROUTE-regels kloppen.
- [vervallen, niet getest] Twilight Crypts: Party Crasher: casten de Twilight Summoners iets dat je kunt onderbreken? Nee = TRASH-regel 3 aanpassen.
- [vervallen, niet getest] Twilight Crypts: Zie je in de crypten Fleshwarped Abominations die zich healen (Reconstitution) en Hexbound Necrowraiths met Necrotic Bolt? Ja = nieuwe TRASH-regels kloppen.
- [vervallen, niet getest] The Gulf of Memory: Stap in een cirkel op de vloer (geen kaarslicht). Word je opgetild en gestund door een Sapstick Lurker? Ja = nieuwe TRASH-regel klopt.
- [vervallen, niet getest] The Gulf of Memory: Mul'tha'ul: zet Valeera op healer. Haalt ze Hopeless Curse van je af? Ja = nieuwe regel klopt. Nee = regel eruit.
- [vervallen, niet getest] The Gulf of Memory: Kies in de coach Mul'tha'ul (Descent of the Haranir): staan de Searing Light- en Sporbit-regels er nog tussen? Met de nieuwe tekst horen ze weg te zijn; staan ze er wel, dan is het filter de oorzaak.
- [vervallen, niet getest] The Grudge Pit: Fungal Pharmacon: welke stappen toont je tracker? DB2 (live) heeft twee versies: (a) 3 Ula'tek Burrows in + 4 Lesser Ritual Pillars + slangen killen, of (b) 10 Pharmacon verzamelen + 4 pillars + vijanden. Zeg welke, dan maken we de route precies. Staan de pillars níét in de burrows, dan moet 'go down into the Ula'tek Burrows' anders.
- [vervallen, niet getest] The Grudge Pit: Lightbloom Invasion: blaas je de 3 Unstoppable Thornmaws op door op Bomb Spores (of tonnen) te klikken? Ja = nieuwe regel klopt. Blazen bevrijde fighters ook spawn points op (zoals Icy Veins zegt), dan komt dat er weer bij.
- [vervallen, niet getest] The Grudge Pit: Dastardly Rotstalk: werkt taunten alleen in een van de bewegende spotlights? Ja = nieuwe regel klopt.
- [vervallen, niet getest] The Grudge Pit: Dastardly Rotstalk: doen de Angry Fans pijn als je ze negeert? Nee = TRASH-regel 3 aanpassen.
- [vervallen, niet getest] The Grudge Pit: Zie je ooit een Disciple of Vashnik in de Grudge Pit? DB2 heeft daar een encounter (3522), maar geen verhaal eindigt bij hem; waarschijnlijk ongebruikt. Nee = niets doen.
- [vervallen, niet getest] Sunkiller Sanctum: Esuritus: lees de castbalk van de bolt die hij op je richt. Heet hij Calling Bolt of Singular Bolt, en lukt een interrupt? Lukt het = de bullet 'Interrupt Calling Bolt' blijft, maar check of de tooltip in de coach 'Instant' zegt (dan hoort er een andere id bij). Lukt het niet = de bullet moet weg.
- [vervallen, niet getest] Sunkiller Sanctum: Esuritus: onderbreek of stun een Voidcaller terwijl hij channelt. Gaat hij meteen dood? Ja = waardevolle tip om toe te voegen (alleen de video van Roguery zegt dit). Nee = niets doen.
- [vervallen, niet getest] Sunkiller Sanctum: Gravitational Effect: zijn het precies 5 coils in de lucht en 5 Stabilizers op de grond? Ja = nieuwe ROUTE-tekst klopt. Ander getal = getal aanpassen.
- [vervallen, niet getest] Shadowguard Point: Chief-Arcanist Patram: hoe heet de add die na Dark Communion verschijnt (Icy Veins: Void Emissary, Method: Dark Harbinger)? Naam gezien = die naam in de BOSS-bullet zetten.
- [vervallen, niet getest] Shadowguard Point: Chief-Arcanist Patram: lukt een interrupt op Submit to the Void? Ja = nieuwe bullet klopt. Nee = 'Interrupt it' weghalen; de tooltip zegt Magic, kijk dan of een dispel hem weghaalt.
- [vervallen, niet getest] Shadowguard Point: Disciple of Vashnik: ga tijdens Toxic Froth achter een muur of pilaar staan. Krijg je toch de volle 8 seconden schade, en liggen er daarna healing orbs? Allebei ja = bullet blijft. Muur helpt wel = die zin schrappen. Geen orbs = 'pak daarna de healing orbs' schrappen.
- [vervallen, niet getest] Shadowguard Point: Disciple of Vashnik op Tier 11: vind jij hem de zwaarste delve-baas van dit seizoen? Nee = de zin over 'many players' schrappen (Icy Veins noemt hem 'not too bad').
- [vervallen, niet getest] Shadowguard Point: Captured Wildlife: krijg je na de kooien echt aas van Lysikas, met een extra knop bij de Void Researchers? Ja = nieuwe ROUTE-bullet klopt.
- [vervallen, niet getest] Torment's Rise: Vlieg naar de ingang van Torment's Rise in Voidstorm (61.2, 71.3) en loop de rookmuur in. Kom je binnen bij Nullaeus? Ja = de nieuwe BOSS-tekst is nuttig en de kaart blijft. Je wordt naar Silvermoon gezet (zoals een speler op 13 aug meldde) = de hele kaart is seizoen 1-geschiedenis; kies dan of hij weg mag of alleen de OVERVIEW houdt.
- [vervallen, niet getest] Torment's Rise: Heb je nog een Beacon of Hope in je tassen: kun je hem in een delve nog gebruiken? Ja = de ROUTE-bullet moet zeggen wat hij nu oproept. Nee = de nieuwe ROUTE-tekst klopt.
- [vervallen, niet getest] Torment's Rise: Alleen als je binnenkomt: probeer Devouring Essence te onderbreken. Lukt het = je kunt 'Dispel it' aanvullen met 'or interrupt it' (Icy Veins zegt ja, Method zegt nee).
- [vervallen, niet getest] Venomfall Deeps: Ga solo naar binnen in Venomfall Deeps en typ /mh mark vóór de pull. Verschijnt de markerbalk en kun je 4 world markers neerzetten? Ja: de tip klopt zoals hij staat. Nee: de balk wacht op een groep (FastMark.lua vraagt IsInGroup), en de BOSS-tip moet dan Blizzards eigen world markers noemen in plaats van /mh mark.
- [vervallen, niet getest] Venomfall Deeps: Klik de nieuwe waypoint 51.2, 31.0 op de Coiled Isle. Kom je bij de deur van Venomfall Deeps uit? Ja: waypoint mag erin. Nee: noteer waar de deur echt staat (/mh here buiten de deur).
- [vervallen, niet getest] Venomfall Deeps: Haal Blessing of Potency uit een zware kist en lees de tooltip van de buff. Staat er 'all of your stats'? Dan klopt de nieuwe tekst. Staat er 'secondary stats'? Dan was de oude tekst goed en vervalt deze correctie.
- [vervallen, niet getest] Gnarldor Isle: Sturdy Chest 3 in Gnarldor Isle: staat de kist bij onze pijl (28.67, 41.69) of zo'n 3 eenheden noordelijker (rond 28.4, 38.2, 'achter blokken links van de trap naar boven' volgens Icy Veins)? Bij onze pijl: laten staan. Noordelijker: waypoint aanpassen naar wat /mh here bij de kist zegt.
- [vervallen, niet getest] Gnarldor Isle: Minchi's Osseous Adventure: wat staat er in het doel bij de bottenhopen, 0/4 of 0/6? 0/4: de nieuwe tekst klopt (hotfix eind augustus). 0/6: de hotfix is teruggedraaid en de oude tekst was goed.
- [vervallen, niet getest] Gnarldor Isle: Gralka met Valeera op DPS: onderbreekt ze Purging Breath, en wat gebeurt er dan? Onderbreekt ze hem en ga je dood of komt er iets ergs: de nieuwe Healer-regel klopt en verdient misschien de reden erbij. Onderbreekt ze hem niet: de nieuwe regel kan weg.
- [vervallen, niet getest] Gnarldor Isle: Bij Scrollmaster Ruma bij de ingang: geeft ze It's a Satchel, Not a Bag, en ligt Ruma's Satchel binnen op 25.40, 34.73? Ja: de nieuwe OVERVIEW-regel klopt. Nee: noteer welke quest ze wél geeft.
- [vervallen, niet getest] The Ring of Glory: Crushfoot (Open Night): zie je in de toren noordoost en zuidwest een blauw gloeiende bol die je naar de andere toren teleporteert, en stopt het zijn charge als je erin stapt? Ja: de zin 'dat hebben wij zelf niet getest' mag eruit. Nee: laten staan zoals hij is.
- [vervallen, niet getest] The Ring of Glory: Gnok, eerste fase (Adopt-a-thon): wat doet Pulverize? Gooit hij je weg en vertraagt hij je (Icy Veins), of is het alleen een klap (Method)? Wegslaan: er hoort een regel bij ('vecht hem waar de knockback je niet in een pack gooit'). Alleen een klap: niets toevoegen.
- [vervallen, niet getest] Valeera/systeem: Delves-tabblad, beweeg over een delve-rij: staat er bij Tier 1, 6 of 7 'Vault 305*'? Volgens Wowhead hoort dat 279, 298 en 302 te zijn. Kijk ook wat de drie vault-vakjes tonen ('Tier X (ilvl Y)') in een week waarin je een Nightmare Prey-hunt deed.
- [vervallen, niet getest] Valeera/systeem: In een delve met Valeera's venster open: dood één vijand en loot NIETS. Gaat 'XP tot nu toe' omhoog? (test voor 'doden telt ook')
- [vervallen, niet getest] Valeera/systeem: Doe een Tier 11-delve die NIET Bountiful is, met levens over, op Delver's Journey rank 4 of hoger. Verschijnt er een Gilded Stash in de schatkamer?
- [vervallen, niet getest] Valeera/systeem: Doe een gewone (niet-Bountiful) delve op Tier 4 of hoger en kijk naar het item level uit de eindkist. Blijft dat op het Tier 3-niveau (272 of lager), zoals Icy Veins zegt?
- [vervallen, niet getest] Valeera/systeem: Hover bij de ingang van een delve op Tier 11 over het Gilded Stash-icoon: staat er 'x/4' per week?
- [vervallen, niet getest] Valeera/systeem: Kijk op de kaart hoeveel Special Assignments je deze week kunt doen, over alle zones samen. Klopt 3?
- [vervallen, niet getest] Valeera/systeem: Kill een rare in Eversong of Zul'Aman (niet Coiled Isle) en lees /mh shards: hoeveel shards gaf hij (25, 50 of 75)?

## 🆕 2 okt middag — Mythic+ voor beginners (Codex + `/mh mplus`, enUS + nlNL)

Rob: *"ik keur het goed"* (pagina `mplus_review.html`). Nu in 7 talen; knopnamen komen uit de client zelf (Rob koos
"uit het spel zelf"): `{UI:NAAM}` in de tekst wordt Blizzards eigen woord, Engels als terugval.
- [vervallen, niet getest] `/reload` zonder fout (BugSack leeg).
- [vervallen, niet getest] **`/mh uinames`**: 10 regels. Staat er achter elke naam het Engels dat je op je scherm ziet (Dungeons & Raids,
      Premade Groups, Start a Group, List Group, Sign Up, Mythic+ Dungeons, Activate, Guild Finder, Mythic+ Rating,
      **Learning**)? Rood "missing" = die naam bestaat niet in jouw client. ⚠️ Vooral **Learning**: dat
      `GROUP_FINDER_GENERAL_PLAYSTYLE1` Learning is (en niet Relaxed) is AFGELEID uit de volgorde, niet gemeten.
- [vervallen, niet getest] `/mh codex` → **Dungeons & M+**: staat bovenaan *"Mythic+, vanaf je eerste key"*, en staan de knopnamen er netjes
      in (geen `{UI:…}` meer zichtbaar)?
- [vervallen, niet getest] Niet-getokeniseerde schermwoorden zijn in de/fr/es/pt/it door de vertalers gekozen, NIET in een client gezien:
      *Find a Community*, het venster *Guild & Communities*, de categorie *Dungeons* en de moeilijkheid *Mythic*. Pas
      als iemand met zo'n client meekijkt.
- [vervallen, niet getest] Zoekvak: typ *first key* of *premade* → vindt hij het hoofdstuk?
- [vervallen, niet getest] Op een personage **zonder** M+-runs dit seizoen: `/mh mplus` toont onder "Nog geen keystone-runs" een gele regel
      *"Nog nooit een key gelopen? Typ /mh codex en open Dungeons…"*. Met runs hoort die regel er NIET te staan.
- [vervallen, niet getest] `/mh mplus` onderaan: de gear-regel zegt nu *"De kist aan het eind gaat van Champion naar Hero; alleen de Great Vault
      geeft Myth, vanaf +10."*
- [vervallen, niet getest] Group Finder → Start a Group: heet het keuzevak echt **"Select Playstyle (required)"** met **Learning** erbij?
      (Naam komt uit build 12.1.5 op wago.tools, niet uit live 12.1.0.)
- [vervallen, niet getest] Silvermoon: waar staat **Lindormi** precies? Bronnen zeggen 42.1, 58.8 (wiki) óf 53.3, 66.1 (Icy Veins). Het
      hoofdstuk zegt nu alleen "naast het portaal naar The Timeways".

## 🆕 2 okt middag — 8 M+-dungeons (korte tips) + lange raidtips (7 talen)

Rob keurde beide pagina's goed. Dungeons: VA, BV, AF, TS, RL (13 tips) + DN, MR, KR (10 tips). Raid: 29 lange teksten
(`_STEPS`/`_TANK`/`_HEALER`/`_DPS`).
- [vervallen, niet getest] `/reload` zonder fout.
- [vervallen, niet getest] Bij je volgende M+-run: klopt de korte tip van die dungeon? Zeg per baas wat niet klopte.
- [vervallen, niet getest] **Den of Nalorakk, Nalorakk op Heroic:** springt Zul'jarra achter de tank met een schild, en raken de drie klappen
      dan iedereen? (De 12.1-journal zet dit deel alleen op Mythic. Ja = tip klopt overal; nee = er komt "Op Mythic:" voor.)
- [vervallen, niet getest] **Kings' Rest, Mchimba (de-/fr-/es-/pt-/it-client, als je iemand kent):** hoe heet de knop om uit de kist te komen?
      Alle vijf vertalingen zeggen nu "Struggle" in het Engels.
- [vervallen, niet getest] **Afgeleid, niet gemeten** (de helper zei het zelf): de nieuwe Mythic-regel bij **Vaelgor** (*"de draken vliegen nog
      op, Astral Reflection-klonen blijven casten"*) en de DPS-zin bij **Averzian** (*"de soak stopt twee Voidshapers"*).
**Vragen uit de lange raidtips — niets veranderd, jij bent de meting:**
- [vervallen, niet getest] Entombed Sentinels, Normal, pauze: twee spelers raken elkaar aan onder de 4 groene bollen — worden ze alleen uit
      elkaar geduwd (tekst klopt), smelten de bollen samen (zin anders), of gaat er iemand dood (zin eruit)?
- [vervallen, niet getest] Vashnik, Caustic Explosion na een dispel: zelfde schade dichtbij en ver weg (dan mag "step away" weg) of minder ver
      weg (tekst klopt)? Kijk in Details.
- [vervallen, niet getest] Vashnik, Dripping Fangs (tank): staat er 100% (klopt "verdubbelt") of 200% meer fysieke schade?
- [vervallen, niet getest] Twin Fangs, Normal, Ravenous Feast: straf als er minder dan drie in een klap staan? Geen straf = die zin kan weg.
- [vervallen, niet getest] Twin Fangs, Normal, Ravenous Feast: tel je Eternal Venom-stacks vóór en na alle drie de klappen (1 minder = per
      Feast, 3 minder = per klap).
- [vervallen, niet getest] Coiled Altar, Normal, Gloombomb: laten óók niet-gemarkeerde geraakte spelers zielkopieën vallen (Gravebound)?
- [vervallen, niet getest] Coiled Altar, Normal, Eternal Nightfall: stopt de cast vanzelf als het schild breekt, of moet er nog een kick?
- [vervallen, niet getest] Vorasius: staat de stack Primordial Power na een Roar op JOU (raid-DoT) of alleen op de BAAS?
- [vervallen, niet getest] Vaelgor & Ezzorak, Normal: krijgt iemand Shadowmark in de intermission? Ja = hoort bij alle moeilijkheden.
- [vervallen, niet getest] Vaelgor & Ezzorak, Normal: grote klap op de raid bij de laatste Nullzone-tether (oude tekst klopte) of kleine tik?
- [vervallen, niet getest] Crown of the Cosmos, Normal, eerste tussenfase: debuff na een pijl (8 s, meer pijlschade)? Ja = geldt ook op Normal.
- [vervallen, niet getest] Belo'ren, healer: krijgt IEDEREEN de heal absorb + DoT, of maar een paar spelers?
- [vervallen, niet getest] Belo'ren, tank: krijgt de baas een stack als de frontal de tank van de VERKEERDE kleur raakt?
- [vervallen, niet getest] Chimaerus, healer: duurt Caustic Phlegm ±12 s (tekst klopt) of ±20 s?
- [vervallen, niet getest] Chimaerus, Consume (100 energie): heeft dicht op elkaar staan nut?
- [vervallen, niet getest] Chimaerus, na de soak: blijf je in dezelfde zaal (dan worden "boven/omlaag" herschreven) of ga je echt omlaag?

## 2 okt — 17 raidbazen: nieuwe korte tips (extra high-ronde, `RaidTips.lua`, 7 talen)

Rob: *"alles goed, zet ze er maar in"* (beoordeeld op https://claude.ai/artifact/CWjDGP9K3dqGtsjoZGMgCz).
- [vervallen, niet getest] `/reload` zonder fout (BugSack leeg).
- [vervallen, niet getest] Bij je volgende raid: staat in het tipvenster bij de pull het nieuwe korte blok? Herkenbaar voorbeeld:
      Chimaerus begint met *"Soak: A circle appears on the tank. When it is your group's turn, all of you stand in it
      at once."* De Twin Fangs-tip is ook herschreven.
- [vervallen, niet getest] Klopt het advies in het gevecht zelf? Zeg per baas wat niet klopte — jij bent de meting.
- [vervallen, niet getest] Past het blok nog in het venster? De nieuwe tips zijn soms langer (tot 2 zinnen per regel).

## 1 okt — Twin Fangs-tip: de draaiende gifstraal (`RaidTips.lua`)

- [vervallen, niet getest] Open de tips van de Twin Fangs (Raids → Venomous Abyss, of het tipvenster bij de pull): staat er onderaan
      *"Middle (at full energy): … The orbs spinning around her head show which way it turns. Walk against it…"*?
- [x] ✅ (Rob, 1 okt, Normal: "Hij gaat niet helemaal 360 graden rond") de straal gaat **niet** helemaal rond —
      Method had gelijk, de tip ("achter de straal ben je veilig") klopt zo.

## 🆕 1 okt — karakteroverzicht als kolommen (`AltBoardView.lua`, idee van AltBoard)

- [x] ✅ (Rob, 1 okt, screenshot: "kolommen werken") kolommen naast elkaar met kopjes; knop *Rows* rechts.
- [x] ✅ (Rob, idem) klik op een naam → kaart met gear (icoontjes, namen in kleur, ilvl rechts).
      ⚠️ Zijn klacht: de kolommen kregen maar een smal strookje onder het weekblok → gerepareerd, zie hieronder.
- [x] ✅ (Rob, 1 okt: "kolommen en big window werken, ben ik ook blij mee") `/reload`: het blok *This week* klapt **één keer** vanzelf in zodra de kolommen verschijnen (daarna blijft jouw
      eigen +/- staan). Krijgen de kolommen nu de ruimte?
- [x] ✅ (Rob, idem) Knop **Big window** boven de kolommen → een groot venster van bijna je hele scherm met alle kolommen en rijen in
      één keer. Meer characters naast elkaar? In het hoofdvenster staat dan een korte zin. *Back here* of Esc sluit het,
      en de kolommen staan weer in het hoofdvenster.
- [vervallen, niet getest] Goud, rested XP, spec en gear verschijnen pas bij een character nadat je er **één keer op hebt ingelogd** (oudere
      records tonen een streepje). Klopt dat bij een alt die je nog niet opnieuw opende?
- [x] ✅ (Rob, 1 okt: "die kloppen") **Beroepen:** de getallen uit `GetProfessionInfo` komen overeen met het
      beroepenvenster — GEMETEN.
- [vervallen, niet getest] Veel characters: verschijnen < en > met "1-5 van 9", en bladert het?

## 🆕 1 okt — vragenlijst: uitnodiging in het spel (`SurveyInvite.lua`)

- [vervallen, niet getest] `/reload`, dan `/mh survey` → het kopieervenster met **midnighthelper.com/survey/?from=game** (in het Nederlands
      `/nl/survey/`). Plak de link in je browser: opent de vragenlijst?
- [x] ✅ (Rob, 1 okt, screenshots: "alles goed") `/mh survey popup` → de pop-up zoals spelers hem zien, met drie knoppen: *Show the link* / *Later* / *No thanks*.
      Doen alle drie wat ze zeggen? (Later = chatregel; No thanks = kaartje op This Week weg.)
- [vervallen, niet getest] `/mh survey why` → zegt het of de pop-up zou verschijnen en waarom niet. Open This Week: staat er een kaartje
      *"Two minutes for Midnight Helper?"*?
- [x] ✅ (Rob, 1 okt 23:09, screenshot) Zelf ingevuld via de link uit het spel → mail *"[MH vragenlijst] cijfer 5 ·
      en · via game"* met alle antwoorden en de `DATA:`-regel; site toont *"Thank you!"*. Hele keten GEMETEN.

## 🆕 1 okt — debug-regel weg (CurseForge-reactie)

- [vervallen, niet getest] Log in (of `/reload`) op een character **zonder beroepen**, of open MH → beroepen: er staat géén
      *"Debug: Found profession …"* meer in de chat.

## 🆕 30 sep laat — Armory-knop + "snel of precies" in beide vensters

- [x] ✅ (Rob, 30 sep laat: "reload gedaan, beide knoppen werken") 🆕 `/reload`, karakterscherm (C) → onderaan het MH-paneel nu **twee** knoppen: eerst *"Quick advice: Armory
      website"*, dan *"Best set from your bags: Raidbots (test)"*. Klik de eerste → het export-venster; bovenaan staat
      **midnighthelper.com/armory** en de regel *"Want the exact answer … /mh raidbots (test phase)"*. Staat de tekst
      eronder nog in beeld?
- [x] ✅ (Rob, idem; of alles in het venster past is niet apart genoemd) Klik de Raidbots-knop → onderaan de uitleg een nieuwe regel *"Rather a quick answer … /mh export and
      midnighthelper.com/armory"*. Past alles nog in het venster?

## 🆕 30 sep — `/mh raidbots`: tekst voor Raidbots Top Gear (`SimcExport.lua`)

- [x] ✅ (Rob, 30 sep avond, screenshot: "beide werken") 🆕 `/reload`, open je karakterscherm (C) → onderaan het MH-paneel ernaast: *"Best set from your bags: Raidbots
      (test)"*. Klik → het Raidbots-venster opent, bovenaan een **oranje** testfase-regel en 5 stappen. Past alles erin?
- [vervallen, niet getest] Site: midnighthelper.com/raidbots (en /nl/raidbots) → 7 stappen met gouden nummers en een oranje testfase-blok;
      Armory → Best set → knop *Step by step* gaat erheen.

- [vervallen, niet getest] `/reload`, `/mh raidbots` → venster *"For Raidbots Top Gear"*, chat *"Raidbots text ready, with N item(s)…"*.
      Bovenaan `paladin="Twelveinchy"`, `spec=protection`, een regel `talents=…` (lange code), dan per slot
      `head=,id=…,bonus_id=…`, onder *### Gear from Bags* de tas-items met `# ` ervoor, onderaan `# Checksum: …`.
- [x] ✅ (Rob, 30 sep avond, screenshot) Raidbots leest het: Twelveinchy, 90 Blood Elf Protection Paladin, Khadgar (EU),
      talenten, gear-iconen, ilvl 282, set *Radiance of the Consecrated Flame*, Omnium Folio-sectie. Labels: *Unverified
      Input* (tekst komt niet van de SimC-addon zelf — we doen bewust niet alsof) en *Tank* (Raidbots' eigen tank-waarschuwing).
      ⏳ Nog: tas-items aanklikken → Find Top Gear (eerste poging: "requires at least two combinations" = niets aangeklikt).
- [vervallen, niet getest] Ctrl+C → raidbots.com/simbot/topgear → plakken. **Dé test:** leest Raidbots hem zonder foutmelding? Klopt je
      karakter (naam, spec, talenten, item levels)? Staan je tas-items als keuze klaar? Screenshot, of plak de
      foutmelding van Raidbots letterlijk.
- [vervallen, niet getest] Zelfde op de Shaman (staf) en op een alt met een crafted item (dan staat er `crafted_stats=` in de regel).
- [vervallen, niet getest] Site → Armory → Best set: onderaan het blok *"Want the exact answer…"* met de knop *Open Raidbots Top Gear*.

## 🆕 30 sep — paneel battle res & Bloodlust (`GroupRezLust.lua`)

- [x] ✅ (Rob, 30 sep, screenshot op Shaman "Earthshammy": "deze werkt") `/mh lust test` → paneel met *"Battle res:
      shared charges only in a Mythic+ key…"*, geel *"Nobody in your group can revive in combat."*, groen
      *"Bloodlust: ready"*, *"Can cast Bloodlust: Earthshammy (Shaman)"* in klassekleur.
- [x] ✅ (Rob, 30 sep, Twelveinchy) *"Can revive in combat: Twelveinchy (Paladin)"*.
- [x] ✅ (Rob, 30 sep: "toets klopt") 🆕 (Rob, 30 sep: "ook de knop erbij") `/reload`, `/mh lust test` op Twelveinchy → onder *Can revive* een regel
      *"Intercession: Your key: <toets>"* (of oranje *"Not on a key on your action bars yet."*). Klopt de toets? Sleep
      Intercession naar een andere knop terwijl het paneel open is → de toets verandert mee. Op de Shaman: dezelfde regel
      onder *Can cast Bloodlust* met Bloodlust/Heroism.
- [x] ✅ (Rob, 30 sep avond: "de toets bij Redemption klopt ook, ook de andere toetsen voor de Battle Res")
      Redemption (out of combat) + Intercession tonen de juiste toets.
- [x] ✅ (Rob, 30 sep avond, screenshot in een echte groep) *"Battle res: no shared charges here…"*, *"Twelveinchy
      (Paladin) - Intercession"*, Intercession toets R, Redemption (out of combat) toets s-R, **"Hero: used - ready again
      in 0:41"** zonder "~" (= echte eindtijd van de Sated-debuff GEMETEN leesbaar), *"Sizle (Shaman) - Bloodlust,
      Magedobby (Mage) - Time Warp"* in klassekleur (Horde → Bloodlust klopt). ✅ Log gelezen na `/reload`: Sated in
      gevecht leesbaar mét eindtijd (841×); raidbaas-pot 99/99 (→ nu "no real limit in this fight").
- [x] ✅ **Raid, GEMETEN 1 okt (Rob, Normal Venomous Abyss, log + 2 screenshots):** difficulty 14 = **9 ladingen**,
      herladen **330 s**; paneel *"1 of 9 left · next in 1:58"*, op nul **rood** *"0 of 9 left · next in 3:23"* (898
      metingen, alle "ok"). LFR gaf eerder 99/99, 108 s. Hero herkent Sated (57724) én Exhaustion (57723).
- [vervallen, niet getest] **In een M+-key** (de echte krappe pot): *"Battle res: 1 of 1 left"* of zo, en na een brez *"next in m:ss"*. Daarna
      `/mh lust` + `/reload`. En: welke raid/difficulty gaf 99 ladingen? (vanaf nu staat de difficulty in de log)
- [x] ✅ (Rob, 1 okt, screenshot in LFR op de Shaman) titel *"Battle res & Hero"*, spreuknaam per speler
      (Intercession, Rebirth, Primal Rage), **gemengde factie GEMETEN**: Earthshammy (Horde) *Bloodlust*, Ferosta
      (Alliance) *Heroism*; eigen regels *Ancestral Spirit (out of combat): 0* en *Bloodlust: 5*.
      Oorspronkelijke test: (Rob, 30 sep avond: "wordt gewoon hero genoemd … voor elke spec zijn eigen naam") `/reload`, `/mh lust test`
      → titel *"Battle res & Hero"*, regels *"Hero: ready"*, *"Can cast Hero: Twelveinchy…"* ontbreekt (Paladin kan geen
      Hero) maar *"Can revive in combat: Twelveinchy (Paladin) - Intercession"* staat er met de spreuknaam. Op de Shaman:
      *"Earthshammy (Shaman) - Heroism"* (Alliance) of *Bloodlust* (Horde). Beweeg erover: uitleg begint met *"Hero (Bloodlust,
      Heroism, …)"*.
- [vervallen, niet getest] 🆕 (Rob, 30 sep: "waarom niet in een delve als we met meerdere zijn … en de normale res buiten combat")
      Nu in **elke groep** in een dungeon, delve of raid. Test: ga met iemand een **delve** of **normale dungeon** in →
      het paneel staat er vanzelf, met *"Battle res: no shared charges here - everyone has their own cooldown."* Op
      Twelveinchy staat nu ook *"Redemption (out of combat): Your key: …"* onder Intercession. Klopt die toets?
- [vervallen, niet getest] Instellingen → Dungeon-hulp → **Only in Mythic+ keys and raids** aan → in de delve/normale dungeon verdwijnt het
      paneel, `/mh lust` zegt *"…the setting says Mythic+ keys and raids only"*. Weer uit → het is terug.
- [x] ✅ (Rob, 30 sep avond, screenshot: X rechtsboven zichtbaar, "beide werken"; het wegblijven tot de volgende
      instance nog niet apart gezien) 🆕 (Rob, 30 sep: "sluit knop") Rechtsboven op het paneel een **X**. Muis erop → uitleg. Klik in een dungeon → het
      paneel is weg, ook na `/reload` in dezelfde dungeon; `/mh lust` zegt *"closed with the X for this instance"*.
      Dungeon uit en een nieuwe in → het staat er weer.
- [vervallen, niet getest] Beweeg erover → uitleg over beide. Slepen → het blijft daar staan na `/reload`.
- [vervallen, niet getest] Instellingen → Dungeon-hulp → **Paneel battle res & Bloodlust** uit → `/mh lust` zegt *setting off*.
- [vervallen, niet getest] **In een M+-key of raid, in een groep** (hier zit de echte meting): het paneel staat er vanzelf. In de key:
      *"Battle res: 1 of 1 left"* (of meer), en na een brez *"… next in m:ss"*. Kreeg de groep Bloodlust → *"used -
      ready again in 9:5x"* en dat telt af. Na afloop `/mh lust` → onderaan regels `brez combat:key …` en
      `lust combat:seen …` → `/reload` zodat ik ze uit het bestand kan lezen. Dáármee zijn de twee reads GEMETEN.
      Rob gebruikt EllesmereUI nu níét (30 sep) → `/mh lust` hoort *EllesmereUI shows: battle res no, Bloodlust no*
      te zeggen en alle regels staan er. Zegt hij "yes", dan is EllesmereUIQoL tóch geladen — meld het.
- [vervallen, niet getest] Iemand in de groep is Druid/DK/Warlock/Paladin → staat bij *Can revive*; Shaman/Mage/Evoker/Hunter → bij
      *Can cast Bloodlust* (Hunter met *(with the right pet)*).

## 🆕 27 sep — metingen: plattegronden, zwevende iconen, dispel

- [x] ✅ (Rob, 27 sep: The Venomous Abyss, map 2606, met Nek'zali) `/mh mapprobe show <getal>` tekent een plattegrond
      met doodshoofdjes bij de bazen.
- [x] ✅ (Rob, 27 sep, screenshot) `/mh mapprobe`: bij de dungeons "map 0" → daarvoor is een tweede weg gebouwd.
- [x] ✅ (Rob, 30 sep: "deze werkt ook") 🆕 **Kaartvenster**: Codex → Raids → klap een raid open → naast *Route to* staat **Map**. Klik: plattegrond,
      knoppen per verdieping (als die er zijn), doodshoofden met bazennamen. Beweeg over een baas → tooltip; klik →
      MH's tips voor die baas.
- [x] ✅ (Rob, 27 sep) dungeon-kaarten werken. 🆕 De knop **Map** staat nu náást *Route to …*, zoals bij de raids.
- [x] ✅ (Rob, 27 sep, impliciet: "de kaarten werken") The Voidspire, The Dreamrift, March on Quel'Danas.
- [x] ✅ (Rob, 27 sep) Raids én Dungeons: *Route to …* en **Map** staan nu direct **onder de bewegende bazen**.
- [x] ✅ (Rob, 27 sep, screenshot "-> Pit of Fangs") meting overgangen: 57 in totaal.
- [x] ✅ (Rob, 27 sep: "de overgangen werken") In het echte kaartvenster (**Map**-knop), bv. The Venomous Abyss of Windrunner Spire: groene labels met de naam
      van een verdieping bij de trappen/portalen. Beweeg erover → tooltip; klik → die verdieping verschijnt.
- [x] ✅ (Rob, 27 sep) Delves-pagina: kaart-icoontje werkt "meestal". 6 zonder kaart: The Shadow Enclave, The Gulf
      of Memory, The Grudge Pit, The Ring of Glory, Venomfall Deeps (Zul'Aman) en (The Coiled Isle).
- [x] ✅ (Rob, 27 sep: "alle delves hebben nu de map werkend") na de ruimere naamvergelijking.
- [vervallen, niet getest] In een dungeon: `/mh map` opent de verdieping waar je staat.
- [vervallen, niet getest] Zwevende iconen op de Paladin: als ze er staan `/mh whatis 5`, muis erop, daarna `/reload`.
- [x] ✅ (Rob, 27 sep, Nexus-Point Xenas) rechtsklik castte Cleanse Toxins (castlog), maar de rode kleur bleef. Zijn
      debuff: Blistering Smite, **zonder type** in de tooltip.
- [vervallen, niet getest] 🆕 **Solo testen:** `/mh partytest` (buiten gevecht) → alleen je eigen regel, zonder groep. Laat een rare of mob
      je een Poison geven (Venomous Infusion) → regel rood → rechtsklik op je naam → gaat het rood weg? Ook een mob
      met een Magic-debuff proberen: wordt de regel dan óók rood (= vals alarm voor Prot)?
- [vervallen, niet getest] 🆕 **Automatisch (niets typen):** gewoon spelen in een groep (of met `/mh partytest`). Na elk gevecht kijkt MH
      welke van jouw debuffs het spel nog "wegneembaar" noemt. Is dat iets wat jouw spec níét kan weghalen, dan
      komt er één chatregel *"dispel check: your row is red for X (type: …)"*. Na de sessie: `/reload`.
- [vervallen, niet getest] Als **je eigen** regel rood is: `/mh glow` → nieuwe regel *"your own debuffs now: naam [type]"*. Screenshot.
      Staat daar alleen Magic of "no type" terwijl de regel rood is, dan kleurt het spelfilter op klasse, niet op spec.

## 🆕 29 sep — crests (na de vergelijking met Gandalin)

- [x] ✅ (Rob, 29 sep) `/reload`, Codex → Currencies → **Crests**: de 3e regel zegt nu dat de cap telt wat je deze season hebt
      **verdiend** (niet wat je hebt), en elke week omhooggaat.
- [vervallen, niet getest] Doe je een **Tier 11 Bountiful Delve**: wat geeft de **Gilded Stash** aan crests? Staat daar **Myth**, dan
      klopt de zin "Myth haal je solo niet" in MH niet meer. Screenshot van de loot of de crest-tooltip.

## 🎬 28 sep — opnames voor de website (Rob: "doe twee maar")

Drie korte filmpjes uit het spel voor midnighthelper.com. Elk ± 10 seconden; ik knip er het mooiste stuk uit.
**Opnemen met Win+Alt+R** (start én stop), die neemt je hele scherm scherp op. Discord-clips kan ook, maar zet dan
de kwaliteit op de hoogste stand: je huidige Discord-clips zijn 1920×540 (GEMETEN), te klein om het MH-venster uit
te knippen op jouw brede scherm. Zet het MH-venster **midden** op je scherm en beweeg rustig.
- [x] ✅ (29 sep, online) **Speel-kaart:** `/mh play`, even stil laten staan zodat je de toetsen op de icoontjes ziet, dan één keer
      naar een ander tabblad (bv. Stay alive) en terug.
- [x] ✅ (29 sep, online) **Kaart:** open een raid in MH → knop **Map** → wacht 2 tellen → klik op een doorgang (overgang) zodat hij van
      verdieping wisselt. (In een dungeon kan ook: `/mh map`.)
- [vervallen, niet getest] **Slijtage** (als je gear echt laag is; start de opname via **Win+G** → rode knop, niet Win+Alt+R): `/mh durability test` → de grote waarschuwing verschijnt (geluid doet er niet toe, de site speelt
      zonder geluid).
Klaar? Zeg het me: ik snijd bij (`tools/make_clip.py` in de site-repo, via de voordeur `scratch make_clip.py`), en
zet ze in een concept dat je eerst ziet voordat het online gaat.

## 🆕 28 sep — `/mh export` (Armory-website)

`/reload`, dan `/mh export`.
- [x] ✅ (Rob, 28 sep, 2e poging) venster opent, Ctrl+C werkt. 1e poging: `|h |r |n |t` werden door het tekstvak als
      WoW-codes opgegeten ("Eead", "are") → nu als `||` in het venster, kopieert als één `|`.
- [x] ✅ Regel 2 `char=Twelveinchy;class=PALADIN;spec=Protection`; 16 regels `E|…`.
- [x] ✅ Helm `str` 116, `sta` 2142: STR/STAMINA-keys werken (VERIFY afgevinkt voor Strength; Agility nog op een agi-klasse).
- [x] ✅ 28 tas-items als `B|…`, geen potions/reagents.
- [vervallen, niet getest] Chat zegt *"Gear export: N items."* Zegt hij dat items nog laden, dan werkt de tekst zich binnen een paar tellen bij.
- [x] ✅ (Rob, 29 sep) Zoek in de MH-zoekbalk op "export": de regel `/mh export` verschijnt.
- [x] ✅ (Rob, 30 sep, Shaman) Plak de tekst op de site → "Calculate best set": werkt, 37 items gelezen. MAAR hij
      adviseerde een schild (Wailing Bulwark, +561) naast zijn **staf** → gerepareerd (export veld 12 `hands`, site kiest
      wapens als paar). ⏳ Opnieuw: `/reload`, `/mh export` → wapenregels eindigen op `|2` (staf) of `|1`; plakken →
      geen schild meer, off hand-regel weg (of *"Leave empty: … takes both hands"*).
- [x] ✅ (Rob, 30 sep, 2e export) staf-fix: geen schild meer, *Lightgrasp Worldroot — Keep*, off hand-regel weg.
- [x] ✅ (Rob, 30 sep) de Ouroboric Signet-tooltip zegt **Unique-Equipped** → gebouwd: export veld 13 `unique`
      (`i<itemID>:1` of `c<categorie>:<n>`, uit de tooltip), site kiest nooit meer dan toegestaan.
- [x] ✅ (Rob, 30 sep, Twelveinchy-export) GEMETEN: tooltip-route werkt — Ouroboric Signet `||i272150:1`, alle 4
      gedragen ringen/trinkets en de tas-ringen/trinkets dragen een `i…:1`; wapen en schild eindigen op `|1`.
- [x] ✅ (Rob, 30 sep, Twelveinchy geplakt) staf/ringen goed, maar trinket-advies fout: Lost Idol (295, geen stats,
      alleen effect) → Keepsake 272 (+101 Str). Gerepareerd: export veld 14 `e` (Use:/Equip:/proc in de tooltip), en
      de site wisselt een effect-trinket nooit en stelt er geen voor; trinket zonder één stat = effect, ook in oude exports.
- [vervallen, niet getest] ⏳ `/reload`, `/mh export` → Lost Idol eindigt op `||i251783:1|e` (en Effigy ook op `|e` als hij een effect heeft).
      Plakken → Trinket-regels *Keep* met *"Its effect can't be scored here…"*, geen wissel naar de Keepsake.
- [vervallen, niet getest] ⏳ (plakken nog te doen) `/reload`, `/mh export` → de Ouroboric Signet-regels eindigen op `||i<getal>:1`; ringen/trinkets zonder
      Unique-Equipped eindigen gewoon op het 11e getal. Plakken → nooit twee dezelfde unieke ring/trinket.
      Staat er bij de Signet géén `i…:1`, dan leest MH de tooltip niet — zeg het.
- [x] ✅ (Rob, 29 sep) Regel 2 eindigt nu op `;primary=Strength` (Prot Paladin). Staat er `primary=?`, dan kon MH
      je hoofdstat niet lezen en telt hij nog alles op — screenshot.
- [x] ✅ (Rob, 29 sep: 19 i.p.v. 28; Bonedust Pestle, Snapdragon Pantaloons en Void-Reaper's Libram weg) Er staan **minder** `B|…`-regels dan de 28 van vanochtend: geen stof/leer/maliën-pantser meer, en geen
      items met alleen Agility of Intellect. Staat er een item bij dat je als paladin tóch niet kunt dragen: naam noemen.
- [x] ✅ (Rob, 29 sep, BM Hunter "Redisch") `primary=Agility`; de boog (Recurve Wisp-Shooter) staat als `E|mainhand`.
      Nog open: een boog/geweer in de TASSEN (`INVTYPE_RANGED*` → mainhand) en een int-alt (`primary=Intellect`).

## 🆕 27 sep — kaartvenster: je echte toets op elk icoon

`/reload`, `/mh play`.
- [x] ✅ (Rob, 27 sep: "de toetsen staan erop") **Your buttons**: rechtsboven op elk icoon staat de toets waar die spreuk nu op staat (`1`, `Z`, `S-2`…), gelijk
      aan wat je actiebalk toont.
- [vervallen, niet getest] Een spreuk die niet op een toets staat: grijs `-`, en de tooltip zegt *"Not on a key on your action bars yet."*
- [x] ✅ (Rob, 27 sep) **Stay alive**: ook daar je echte toets op het icoon; de oude `[toets]` achter de naam is weg.
- [vervallen, niet getest] Venster open laten, een spreuk naar een andere knop slepen: het label verandert mee.
- [vervallen, niet getest] Een andere spec aanklikken bovenin: daar staan géén labels (die spreuken staan niet op je balken).
- [vervallen, niet getest] Klopt een toets niet: `/mh playkeys` en stuur de regels.

## 🆕 27 sep — meting: wat ziet MH van je groep binnen een dungeon/raid?

Waarom: Cisca vond na doodgaan in een raid haar groep niet terug (meerdere verdiepingen).
- [x] ✅ (Rob, 27 sep, Nexus-Point Xenas) eerste meting: kaart per lid leesbaar, posities van niemand.
- [vervallen, niet getest] Nog één keer in een raid/dungeon met **meerdere verdiepingen**, als iemand op een andere verdieping staat.
      Typ `/mh groupmap`, en daarna
      `/reload`. Ik lees de uitkomst uit het SavedVariables-bestand; een screenshot mag ook.
      Liefst op een moment dat een groepslid op een **andere verdieping** staat dan jij.

## 🆕 27 sep — waarschuwing bij versleten uitrusting

`/reload`.
- [vervallen, niet getest] `/mh durability` → een regel met *warning on, limit 30%*, je laagste item met percentage, en per versleten slot
      een regel. Klopt het laagste percentage met wat je karakterscherm (tooltip van dat item) zegt?
- [x] ✅ (Rob, 27 sep: "tekst is groot en geluid werkt") `/mh durability test` → midden in beeld de grote tekst
      *"Your gear is at N% - repair before you pull!"* (eigen frame, 34 px, raid-warning-geluid), en in chat
      dezelfde regel met *Lowest:* en een item-link.
- [vervallen, niet getest] Instellingen → Midnight Helper → *Dungeon help*: **Warn about worn gear** (aan) en de schuif **Warn below** (30%).
      Zet de schuif hoger dan je laagste item en start een ready check of ga een delve in: komt de waarschuwing?
- [vervallen, niet getest] Onder de grens, en na het repareren: géén waarschuwing bij binnengaan.

## 🆕 26 sep — kaartvenster: tabblad Dispel

`/reload`, `/mh play`, tabblad **Dispel**.
- [x] ✅ (Rob, 26 sep, screenshot Prot Paladin) Passen de vier tabbladen naast elkaar (venster is iets breder geworden)?
- [x] ✅ (Rob, 26 sep: Cleanse Toxins, Poison + Disease) **Bij je groep**: klopt wat er staat met je spreuken?
- [vervallen, niet getest] **Bij vijanden**: op een Shaman staat Purge, op een Mage Spellsteal, op een Hunter Tranquilizing Shot, op een
      Druid Soothe. Klopt dat, en staat bij een spec zonder zo'n spreuk *"This spec cannot take buffs off enemies"*?
- [x] ✅ (Rob, 26 sep: alle zes met naam, "you can" bij de 5 poison/disease, niet bij de boss-buff) **Waar het telt**:
      staan de dungeon- en baasnamen er echt (geen "?")? Staat "you can" bij de dingen die jij kunt?
- [vervallen, niet getest] Muis op een spreuknaam: komt de uitleg?

## 🆕 26 sep — kaartvenster: tabblad Consumables

`/reload`, dan `/mh play` (of de gouden knop). Rob: *"het tabbladje voor onze consumables ... zonder in een lange lijst te
moeten zoeken"*.
- [x] ✅ (Rob, 26 sep: *"het werkt"*) Derde tabblad **Consumables**. Staan er flask, potions, wapenolie (niet bij elke spec), rune en food, elk met
      icoon en de naam in de kleur van het item?
- [vervallen, niet getest] Achter elk item: **×aantal** als je het (of een alternatief) in je tassen hebt, anders *Not in your bags*. Klopt dat?
- [vervallen, niet getest] Muis op een naam of icoon: komt de item-tooltip? Staan er eerst "..." in plaats van namen, verschijnen ze dan
      binnen een seconde?
- [vervallen, niet getest] Wissel met de icoontjes bovenin naar een andere spec: wisselen de consumables mee?

## 🆕 25 sep — "Zo speel je" in een eigen venster, en kaarten voor álle specs

- [x] ✅ (Rob, 25 sep, screenshot Resto Druid: *"het grijs werkt, goed"*) **4.1.0: lage levels** — op je level 26 Druid `/reload`, `/mh play`. Bovenaan staat in lichtblauw *"Written for
      level 90. Grey: you don't have that spell yet."* Spreuken die je nog niet hebt zijn grijs (naam en icoon), die je
      wel hebt goud. Klopt dat met je spellbook? Zelfde op het tabblad Stay alive. (Op een andere spec via de icoontjes
      bovenin wordt niets grijs, alleen de regel "Written for level 90".)
- [x] ✅ (Rob, 25 sep: *"knop staat er en werkt"*) **4.1.0: de gouden knop** — `/reload`, open MH (`/mh`). Rechts in de zoekbalk, naast *My character*, staat een
      **gouden "How you play"-knop met het icoon van je spec**, die zacht oplicht. Klik: het kaartvenster opent en het
      oplichten stopt (ook na `/reload`). Past alles nog in de zoekbalk, ook met een smal MH-venster?
- [vervallen, niet getest] 🆕 **4.1.0: Academy zonder schakelaar** — op een account/alt waar je nooit `/mh playcards` typte: staat de knop
      "How you play …" bovenaan de Academy?

⚠️ **WoW helemaal afsluiten en opnieuw starten** (er is een nieuw bestand; `/reload` laadt dat mogelijk niet).
Rob: *"ze zijn nu veel te verstopt en lastig te lezen"* → hij koos een eigen venster met iconen.
- [x] ✅ (Rob, 25 sep, screenshot op zijn **Elemental Shaman**) **Typ `/mh play`**. Komt er een los venster met bovenin
      3 spec-icoontjes (je eigen spec met een gouden rand), het idee, en de stappen **met een icoon ervoor**?
      (Tooltip bij het aanwijzen van een stap nog niet bevestigd.)
- [x] ✅ (Rob, 25 sep, screenshot Elemental: 7 knoppen met icoon) **Tabblad "Stay alive"** (Rob: *"ik mis eigenlijk de
      defense dingen"*): twee tabs, **Your buttons** en **Stay alive**; je verdedigingsknoppen in volgorde met icoon.
      (Of het tabblad onthouden wordt na sluiten en openen: nog niet bevestigd.)
- [x] ✅ (Rob, 25 sep: *"de tooltips werken"*) **Uitleg bij élke spreuknaam** (Rob, Shadow Priest: *"de andere spells geven geen tooltip, bv vampire
      touch"*): `/reload`, `/mh play`, en wijs met de muis naar een gouden naam midden in een zin (bv. Shadow Word:
      Pain, of een naam in "More enemies" of een hero-regel). Komt de uitleg van **die** spreuk? Het icoon vooraan
      toont de eerste spreuk van de stap. En sleept het venster nog, ook als je een stap-regel vastpakt?
- [x] ✅ (Rob, 25 sep: *"slepen werkt nu"*) **Verslepen** (Rob: *"ik kan alleen het scherm niet verslepen"*): `/reload`, dan het venster pakken aan de
      titel, de tabs of een lege plek, en slepen. Na `/reload` hoort het op dezelfde plek terug te komen.
      (Op een stap-regel zelf slepen gaat niet: die regels vangen de muis voor de tooltip.)
- [vervallen, niet getest] **Klik op het Holy- of Retribution-icoon** bovenin: wisselt de kaart naar die spec? Nog een keer `/mh play`
      sluit het venster.
- [vervallen, niet getest] **Leesbaarheid:** is het nu goed te lezen? Te groot, te klein, te breed? (Shift + muiswiel maakt het venster
      groter of kleiner.) Slepen aan de titel, Escape sluit.
- [vervallen, niet getest] **Academy** (Tank, Heal én DPS): bovenaan staat nu één knop **"How you play …  >"**, en de lange kaarttekst
      is weg. Opent de knop het venster met die spec?
- [vervallen, niet getest] **Andere klassen:** op elke alt `/mh play`. Staat er een kaart (niet "isn't written yet")? Klopt hij met hoe
      jij die spec speelt? Vooral: staan er **nergens rare namen of "spell 12345"**?

## 🆕 22 sep — Curse Surge: "nu" en "volgende" met de naam van de baas

`/reload`. Rob: *"ja doe dat vervolg maar"*. De koppeling plek → baas komt van HandyNotes; 2 van de 5 zijn door
jou gemeten (Leviathan, Vassti).
- [vervallen, niet getest] **Typ `/mh surge`** (op of vlak bij de Coiled Isle). Je krijgt *"Curse Surge nu: <baas> — nog X min"* en
      *"Volgende Curse Surge: <baas> om HH:MM"*. **Klopt de baas met wat je op de kaart ziet?** Vooral de drie
      die we nog niet zelf zagen: Looming Mutagenitor, Ori'kassi, Ss'akrithos.
- [vervallen, niet getest] **Events-scherm van MH:** de lopende surge heet nu *Curse Surge: <baas>* en is **klikbaar** (zet een route
      naar die plek). Bij *Coming up* staat de volgende, ook met naam.

## 🆕 22 sep — Events-scherm: een lopende surge heet niet meer "komt eraan"

`/reload`. Gevonden met Robs Leviathan-meting: een Curse Surge die al liep, stond bij *Coming up — in 21 min*;
die 21 minuten waren de tijd tot het **einde**.
- [vervallen, niet getest] **Sta op Coiled Isle tijdens een surge** en open het Events-scherm van MH (of `/mh eventspy`). De surge hoort
      nu bij **NU bezig** te staan, met de resterende tijd; bij *Coming up* staat de **volgende** plek, met de
      tijd tot hij **begint**.
- [vervallen, niet getest] **Controle met een ander event** (bv. *Abundance*): klopt "over X min" nu met wanneer hij echt begint?

## 🆕 21 sep — interrupt-kaart kent drie extra "kan ook een cast stoppen"-spreuken

`/reload`. Uit de JustAC-update van 20 sep, id's apart nagekeken.
- [x] ✅ (Rob, 24 sep) **Prot Warrior** (als je er een hebt): **Disrupting Shout** heeft nu een toets (**Ctrl+V**; had er
      eerst geen) en staat op de interrupt-kaart met het label **AoE interrupt**.
- [x] ✅ (Rob, 24 sep) **Demon Hunter, Vengeance of Havoc**: **Sigil of Misery** staat op de interrupt-kaart met **fear**.
- [x] ✅ (Rob, 24 sep) **Devourer Demon Hunter**: **Void Nova** heeft een toets en staat op de interrupt-kaart met **stun**.
      **Chaos Nova** hoort bij Devourer **niet** meer te staan (die spec heeft hem niet).

## 🆕 20 sep — markeerbalk: wissen gerepareerd + je ziet welke vlaggen al liggen

`/reload`, dan `/mh mark` (de balk komt alleen in een groep). Geleerd uit wMarker en EllesmereUIQoL.
- [x] ✅ **Rob, 20 sep, `/mh mark check`:** jouw client gebruikt `/tm` en `/cwm All`, en
      **`IsRaidMarkerActive` bestaat** — de gouden ring kan dus werken.
- [x] ✅ (Rob, 24 sep) **Nieuw: drie groepsknoppen** rechts op de onderste rij — ready check, **rollen-check** en een
      **aftelklok** (linksklik 10 seconden, rechtsklik stopt hem). Ze zijn **gedimd** als je geen leider of
      assistent bent, en de tooltip zegt dat dan ook. Klopt dat allebei?
- [x] ✅ (Rob, 24 sep) **Zet een paar wereldmarkers** (bovenste rij). Krijgen die knoppen een **gouden ring** zolang de
      vlag op de grond ligt? Wist je er één met rechtsklik, dan hoort de ring weg te gaan.
- [x] ✅ (Rob, 24 sep) **Zet iemand anders in de groep een marker**, dan hoort jouw ring ook mee te veranderen.
- [x] ✅ (Rob, 24 sep) **De rode X op de bovenste rij** (alles wissen): werkt die nu? Hij gebruikte `/cwm 9`, wat buiten
      een Engelse client sowieso niet werkte, en mogelijk helemaal niet meer.
- [x] ✅ (Rob, 24 sep) **Markeer een paar keer snel achter elkaar.** Krijg je nog "You can't do this right now"? De knop
      vuurde eerst twee keer per klik; dat is nu één keer.

## 🆕 19 sep — Z, X en C zijn nu altijd een defensive (of leeg)

`/reload`. Rob koos optie B: *"doe b maar"*. Op de kale Z, X en C komt alleen nog een defensive; dispels en CC
schuiven naar Shift/Ctrl. 107 verschuivingen in 27 specs; **Prot Paladin blijft gelijk**.
- [x] ✅ (Rob, 24 sep) **Ret of Holy Paladin**: in de toetsindeling van MH staat nu **Blessing of Protection op X** en
      **Cleanse Toxins op Shift+V** (was X). Klopt dat in het scherm met de toetsen?
- [x] ✅ (Rob, 24 sep) **Een alt van een andere klasse** (Shaman, Warlock, Rogue of Druid): staat er op X een defensive of niets,
      en géén Purge / Fear / Shiv / CC meer? Shaman hoort nu **Earth Elemental op Z** te hebben, Rogue **Evasion op X**.
- [x] ✅ (Rob, 24 sep) Gebruik je `/mh apply` om de indeling echt op je balken te zetten: doe dat pas na de reload, anders zet hij
      nog de oude.

## 🆕 19 sep — proef: "Zo speel je"-kaart (Ret, Prot, Arcane, Elemental)

`/reload`. Rob: *"Ik wil dat mh dat soort uitleg ook gaat geven … maar wel in eli10 formaat"*. Eerst vier
specs; pas als de vorm goed voelt volgen de andere en de vijf andere talen (nu Engels + Nederlands).
📌 **Sinds 25 sep staat de kaart niet meer in de Academy-tekst maar in een eigen venster** (zie de sectie van 25 sep
bovenaan); de open punten hieronder test je dus in dat venster.
⚠️ **Sinds 4.0.2 standaard verborgen.** Typ eerst **`/mh playcards`** (zet ze aan voor jouw account), dan de Academy
opnieuw openen. Zie je hem niet: **`/mh playcards check`** zegt of de Academy hem getekend heeft, en waarom niet.
- [x] ✅ (Rob, 24 sep, screenshot) **Op je Prot Paladin**: Academy → **Tank**-tab. Onder de tank-toolkit staat **How you play Protection**:
      het idee, 4 knoppen, "More enemies", "Biggest mistake", twee hero-regels (Templar / Lightsmith) en de bron.
      (Gezien t/m de Templar-regel; Lightsmith en bron vielen buiten de screenshot.)
- [vervallen, niet getest] Academy → **DPS**-tab op dezelfde Paladin: onder "Stay alive" staat de kaart voor **Retribution** (voorbeeld).
- [vervallen, niet getest] **Staan alle spellnamen er als naam** (goud), en nergens "spell 123456"? Let vooral op Judgment,
      Sacred Weapon (Lightsmith-regel). Beweeg over een stap: komt de tooltip van die spell?
- [x] ✅ (Rob, 24 sep: *"Ziet er goed uit"*) **Voelt het eli10?** Te lang, te kort, onduidelijke woorden? Dit is de vraag waar de rest op wacht.
- [vervallen, niet getest] (Mage- of Shaman-alt) DPS-tab: **Arcane** en **Elemental** kaarten. Bij Arcane staat **Arcane Orb niet
      meer** in "Your damage cooldowns" (het is een rotatieknop, geen burst).

## 🆕 19 sep — werkt Bubble Cancel nog? (forummelding over /cancelaura)

Spelers melden sinds 17 sep dat `/cancelaura` bij sommige spells stil niets meer doet (Subterfuge, Shadow
Dance). Geen reactie van Blizzard. Of een buff weg te klikken is, beslist de server; dat kan ik niet meten.
MH levert acht van zulke macro's (`Modules/TeamMacrosData.lua`): Bubble Cancel (Paladin, 2×), Ice Block
Cancel (Mage, 3×), Turtle Cancel + Aimed Shot (Hunter), Hover Cancel (Evoker).
- [x] ✅ (Rob, 30 sep, Prot) Bubble Cancel stond **niet** bij Protection (alleen Holy + Ret) → toegevoegd aan Prot.
- [x] ✅ (Rob, 30 sep avond) Bubble Cancel werkt — maar pas nadat **Press and Hold Casting** uit stond. GEMETEN
      `ActionButtonUseKeyHeldSpell "1"` in config-cache.wtf: toets vasthouden draaide de macro twee keer, de tweede
      `/cancelaura` haalde de bubbel meteen weg (en Shimmer ging twee keer). Alle 8 cancel-macro's zeggen dat nu erbij.
- [vervallen, niet getest] **Paladin**: Macros → Utility → **Bubble Cancel**, op een knop zetten. Klik: Divine Shield gaat aan.
      Klik nog een keer: **verdwijnt de bubbel?** Zo niet, dan is de macro stuk en haal ik hem eraf.
- [vervallen, niet getest] (Als je een Mage of Hunter langsloopt) hetzelfde met **Ice Block Cancel** of **Turtle Cancel**.

## 🆕 19 sep — Coiled Altar: Guillotine vraagt nu 3 man, niet 5

`/reload`. Blizzard verlaagde op 1 sep het minimum voor Guillotine naar **3 spelers** op LFR, Normal en
Heroic. Onze tip zei nog 5. Bij Mythic staat nu "5"; dat is afgeleid, want de hotfix noemt Mythic niet.
- [x] ✅ (Rob, 24 sep) **Raids → The Venomous Abyss → The Coiled Altar**: de Guillotine-regel zegt *"at least 3 players (5 on Mythic)"*.
- [vervallen, niet getest] **In het gevecht (Normal of Heroic)**: staan er 3 of meer in de Guillotine, dan krijgt de raid geen
      straf-schade. Klopt dat met wat je ziet?


## 🆕 17 sep — geen "openen?"-knopje meer bij trash

`/reload`. Rob: *"ik krijg vaak bij trash een bosswindow, of de vraag of ik hem open wil doen"*. Het venster
verdween bij **elk** gevecht en liet het knopje achter, ook bij trash.
- [ ] **Raid of dungeon, trash pullen** met het boss-venster open: het venster gaat dicht (dat hoort), maar
      het knopje **"openen?"** hoort er nu níét te komen.
- [ ] **Een baas pullen**: het venster gaat dicht en het knopje komt wél, zoals eerst.
- ✅ **Rob, 17 sep:** *"het venster ging niet open bij trash, het was de knop"* — het venster zelf deed het
      dus goed; alleen het knopje kwam te vaak. Precies wat deze reparatie aanpakt.

## 🆕 17 sep — Deel-knop in het boss-venster werkt nu ook in een raid

`/reload`. Rob, 17 sep: *"wanneer ik in een raid zit geeft de share alleen in party"* — in een raid is
het party-kanaal leeg, dus de tips kwamen nergens aan.
- [x] **In een raid** (Sporefall, Venomous Abyss of een world boss met een groep): open het boss-venster,
      druk **Deel**. Komen de regels in de **raidchat**? ✅ **Rob, 17 sep: "dit werkt nu".**
- [x] ✅ (Rob, 19 sep) **In een dungeon met vier man**: nog steeds partychat.
- [x] ✅ (Rob, 19 sep) **In een LFG/LFR-groep**: instance-chat.
- [x] ✅ (Rob, 19 sep) **Alleen**: geen groep, dan print hij de regels alleen voor jezelf. Dat hoort zo.

## 🆕 17 sep — "Blijf leven"-kaart opnieuw gebouwd (Paladin eerst)

`/reload`. Academy → DPS-tab → **Blijf leven**. De kaart volgt niet meer je toetsen maar een keuze per spell.
- [ ] **Ret Paladin** (lvl < 90): verwacht ongeveer *klein:* Divine Protection · *groot:* Blessing of Protection
      (alleen fysiek), Divine Shield (Forbearance) · *heal:* Word of Glory, dan Lay on Hands (laatste redmiddel)
      · *wegkomen:* Divine Steed · *onderbreken:* Rebuke. **Blessing of Sacrifice staat er niet meer op.**
      Klopt de volgorde voor jou?
- [ ] **Prot Paladin**: *houd aan:* Shield of the Righteous · *klein:* Ardent Defender · *groot:* Guardian of
      Ancient Kings, Sentinel, Blessing of Spellwarding (magie), Blessing of Protection, Divine Shield · heal,
      wegkomen, onderbreken als bij Ret.
- [ ] **`/mh survival`** print nu per spell een regel: groen **+** = op de kaart (met volgorde), rood **−** met
      de reden (niet bekend, passief, geen tag). Staat er iets met "no spell found", stuur me die regel.
- [ ] Holy Paladin (als je er een hebt): staat **Divine Protection** er nu wél? (Holy heeft een eigen id, 498.)
- [ ] **Alle andere klassen staan nu ook op het nieuwe model.** Op elke alt die je langsloopt: Academy → DPS-tab →
      Blijf leven, en `/mh survival`. Let vooral op: staat er een rij **"no spell found"**? Dan vindt de kaart die
      spell niet op naam. Bekende kandidaten: Shift (Devourer), Spell Lock / Axe Toss (pet-spells), alle Warrior-
      en DK-spells (die hebben geen id).
- [ ] **Tank- en healerlijsten** (Academy → Tank- of Heal-tab, op je eigen spec) tonen alleen nog wat je kent.
      Verdwenen hoort: Last Stand, Zen Meditation, Dampen Harm, Heal, Renew, Spiritbloom, Essence Font, Mana Tide.
- [ ] **In het spel te meten** (uit de audit, niemand heeft het gezien):
      - Enhancement Shaman: staat **Ascendance** in je DPS-lijst? (Nu id 114051; was 114050.)
      - Windwalker: staat **Zenith** erin (1249625)? Resto/Balance/Feral: **Convoke the Spirits** (391528)?
      - Unholy: **Dark Transformation** (1233448) en **Putrefy** (1247378)? Subtlety: **Secret Technique** (280719)?
      - Devourer: krijg je nu een eigen lijst (Void Metamorphosis, The Hunt, Soul Immolation, Voidblade) en niet
        meer die van Havoc?
      - Vengeance DH: heeft **Metamorphosis** nu een toets (Shift+C)? Die viel voorheen stil weg; dit is de enige
        toets die door deze ronde echt verandert.
      - Tegenstrijdige cooldowns (Ardent Defender 90 s of 2 min, Spell Reflection 25 of 20 s, Barkskin 45 s,
        Combustion 60 s met Kindling, Bestial Wrath 30 s): wat zegt de tooltip?

## 🆕 17 sep — Codex-kaarten met een kopje, en delves vindbaar zoals dungeons

`/reload` is genoeg. Na Carola's verwarring tussen "Raids" en "Raid & crests".
- [x] ✅ (Rob, 19 sep) **Open de Codex-kamer.** Staat onder elk handboek-hoofdstuk (Delves, Dungeons & M+, Raid & crests,
      …) klein **Codex-handboek**? En staat onder **Raids** nog steeds **Bazen: 17**?
- [ ] **Typ in de zoekbalk een delvenaam** (bv. *Shadowguard Point* of *Sunkiller Sanctum*). Komt hij in de
      lijst, met *Delve Coach* eronder, en opent een klik de **Delve Coach** voor die delve (met "voorbeeld"
      in de titel)?
- [ ] **Typ een delvebaas** die in de Coach staat (bv. *Gnok* of *Drakta*). Opent de Coach op **die** baas
      (naam en model boven de tips zijn die van Gnok, niet van de eerste baas)?
- [ ] **Delves-scherm → de lijst met delves**: staat rechts op elke rij met tips een **boekje**? Klik erop:
      opent de Coach voor die delve? En zet een klik op de rij zelf nog steeds alleen de route?
- [ ] **Bountiful-rijen**: staan het gele **>** en het boekje netjes naast elkaar, zonder over de naam heen?
- [ ] **Boss-knop op de snelbalk in een delve** (Rob, 17 sep: hij gaf Emberdawn uit Windrunner Spire). Nu opent
      die knop (en `/mh bosswin`) in een delve de **Delve Coach** van díé delve; nog een klik sluit hem. In een
      dungeon blijft het gewone boss-venster. ⚠️ Staat de Delve Coach uit in de instellingen, dan gebeurt er
      in een delve niets — zeg het als je dat tegenkomt.
- [ ] **The Shadow Enclave, variant Infiltrate and Ameliorate** (Rob, 17 sep, screenshot: "0/5 Ula'tek Summoners
      kicked", "Oddball Ingredients added to Cauldrons"). MH kent de variant en de eindbaas **Abominable Blunder**,
      maar de tips zeggen **niets** over die twee opdrachten (GEMETEN: "summoner", "cauldron" en "ingredient"
      komen in geen enkele delvetip voor). ❓ Kijk tijdens de run: toont de Coach Abominable Blunder? En vertel
      wat je moet doen: waar vind je de "Oddball Ingredients", en is "kicked" gewoon onderbreken
      (interrupt)? Dan schrijf ik er een regel voor.
      ✅ **Tekstvraag achterhaald (GEMETEN 25 sep, na een melding van de content-wachter):** de tips noemen nu
      beide opdrachten (`DELVE_TIP_SHADOW_ENCLAVE_ROUTE`: "kick 5 Ula'tek Summoners into the abyss", "sabotage 4
      cauldrons by adding odd ingredients"). Open blijft alleen: **toont de Coach Abominable Blunder?**

## 🆕 16 sep — alle instellingen nu ook ín MH ("nummer 3", de settings-branch)

`/reload` is genoeg. Samengevoegd, nog niet in het spel gezien.
- [ ] **Open in MH het scherm Settings** en klik de grote knop bovenaan, **Open Midnight Helper
      settings**. Je komt op de pagina **All settings**, in de MH-look. Staan daar dezelfde kopjes als in
      Blizzards scherm (Taal, Gevecht, Meldingen, Dungeon-hulp, Schermknoppen, Route-pijl, Venster,
      Great Vault, Geavanceerd)?
- [ ] **Zet op die pagina één ding om** (bv. *Daily tip*), en open dan Blizzards instellingen →
      Midnight Helper: staat het vinkje daar ook om? En andersom?
- [ ] **Onder Dungeon-hulp** horen **Short tips in the boss window** en **Only tips for my difficulty**
      te staan. Die twee zijn tijdens het samenvoegen verhuisd; zonder die verhuizing waren ze weg geweest.
- [ ] **Boss-venster → knop Moeilijkheid → zet hem op Alles.** Open daarna de instellingen: staat
      *Only tips for my difficulty* nu **uit**? Dat hoort, want *Alles* ís die instelling uit.
- [ ] **Beweeg over *Quick bar*** (All settings of Blizzards scherm): de uitleg noemt nu ook de twee
      knoppen die erbij komen — het Consumable Ready Board in een groep, de bosstips in een instance.
- [ ] **Recommended-knop**: zet Classic aan, druk op Recommended. Blijft Classic aan? (Die fix van
      14 sep is meeverhuisd; dit bewijst dat hij het nog doet.)

## 🆕 16 sep — negen nieuwe rares en drie vragen uit de Season 2-sweep

`/reload` is genoeg. Alle negen komen uit HandyNotes + Zygor, die het over alles eens zijn — maar
**niemand van ons heeft ze in het spel gezien**, en Zygor noemt ze nog `|future`.
- [ ] **Rares → Voidstorm**: er staan er nu 21 in plaats van 14. Vijf nieuwe liggen dicht bij elkaar
      in de Blackcore-hoek (rond 24-30 / 66-70): **Nullspiral, The Many-Broken, Abysslick, Voidseer
      Orivane, Blackcore**. Loop er één keer langs: staan ze daar echt, en klopt de route ernaartoe?
      - ✅ Rob 16 sep, 's avonds: **het alarm voor Blackcore ging af** — de eerste van de zeven die we in het
        spel zien. De andere vier nog niet gevonden.
      - [ ] 🆕 **Blackcore moet je oproepen**, en het alarm zegt dat nu zelf (`/reload`): dood de vijanden
        rond **28.9 / 70.3** tot je er 3 van hun buit hebt, en gebruik dan de **Singularity Lens**. ❓ Klopt
        dat, en komt hij dan?
      - ✅ Rob, 's avonds: *"ik herinner me deze bazen namelijk wel"* — de vijf in de Blackcore-hoek bestaan.
      - ✅ Rob op Slayer's Rise: **Hardin Steellock gevonden**, maar hij is **niet solo te doen** — dus of
        hij samen met Gar'chak afvinkt, blijft open tot iemand hem in een groep doodt.
- [ ] 🆕 **Boss-venster, na Robs screenshot van Nymrissa** (16 sep). `/reload`.
      - De knop **Moeilijkheid** staat niet meer onderin maar **bovenin rechts**, onder de `>`-knop. ❓ Botst
        hij nergens meer mee, ook niet met **Route** en niet met de naam van de instance?
      - Regels die met **"Normal and Heroic:"** beginnen, blijven nu staan op Normal. Bij Nymrissa hoort de
        tank-regel over zijn harde klappen er dus weer te staan.
      - ❓ Onderaan stond *"World: lines for harder difficulties are hidden"*. Typ daar **`/mh bossdiff`** en
        stuur me wat hij zegt: dan weet ik wat de Tidebound Grotto als moeilijkheid doorgeeft.
      - ❓ Je zag **korte tips tijdens het gevecht**, maar Nymrissa heeft er in de code geen. Maak er een
        screenshot van als je hem weer doet.
- [ ] 🆕 **Elite-rares zeggen het nu zelf** (Rob: *"ja doe die elite-regel er maar bij"*). `/reload`.
      - In **Rares** staat achter 16 rares een oranje **Elite** (o.a. Hardin Steellock, Gar'chak, de vijf
        in de Blackcore-hoek, Stumpy, Oro'ohna, Annulus, Glacial Broodmother). Een rare die je al gedood
        hebt, laat het weg.
      - Beweeg erover: de tooltip zegt *(elite — neem een groep mee)* (in jouw client in het Engels).
      - Blackcore zegt nu **beide**: hoe je hem oproept én dat hij elite is.
      - ❓ Staat het woord **Elite** er in de taal van je spel? Het komt uit je client zelf.
- [ ] **Rares → Voidstorm, Slayer's Rise**: **Hardin Steellock** en **Gar'chak Skullcleave**.
      ❓ Belangrijkste vraag van deze ronde: ze delen kill-quest 94461, dus als je er één doodmaakt
      horen ze **allebei** afgevinkt te worden. Klopt dat, of wil de weekly er twee?
- [ ] **Rares → Eversong**: onderaan staan nu **Tarhu the Ransacker** en **Dripping Shadow** op de
      **Isle of Quel'Danas**. Klik op de route: stuurt hij je naar het eiland en niet naar de raid?
- [ ] ❓ **Twee coördinaten die ik expres níét heb aangepast.** Wij en HandyNotes verschillen bij
      **Tremora** (Voidstorm, wij 35.7/81.1 — zij 36.2/83.5) en **Nar'zira** (2,4 uit elkaar). Sta je
      er toch: waar staat hij écht? Loopt hij rond, zoals Coin-Eye Skully, dan hebben we allebei gelijk.
- [ ] ❓ **World bosses:** typ één keer `/mh worldboss`. Noemt de client nog steeds alleen Lu'ashal,
      Cragpine, Thorm'belan en Predaxas, of is er in Season 2 een vijfde bijgekomen? Er is geen enkele
      bron op je pc die dat kan beantwoorden — alleen jouw client.
- [ ] 🆕 **Heroic Slugger staat bij Achievements** (Rob: *"bouw die er ook maar in"*). Een kaart met 19
      rares uit Val en Naigtal, met route en afvinklijst.
      ❓ Typ **`/mh ach check`**: zegt hij dat 63348 er **19** heeft, of **20**? Bij 20 mist er één en
      weet ik waar ik moet zoeken.
      ❓ Heb je een rare alleen op **Normal** gedood: blijft die rij bij Heroic dan **open**? Dat hoort zo.
- [ ] ❓ **Prey, drie beweringen uit onze eigen uitleg** (Codex → Prey hunts): zijn er nog steeds
      **drie moeilijkheidsmodi**, telt een hunt mee voor de **Great Vault**, en tellen **War Mode**-hunts
      apart? Alle drie staan er zo in sinds augustus.

## 🆕 14 sep — blok "Dungeons & Raids" in het Silvermoon-tabblad (C)

`/reload` is genoeg. Gebouwd, nog niet in het spel gezien.
- [x] ✅ (Rob, telefoon 16 sep) **Codex → Silvermoon City**: direct onder *Travel* (de portals) staat een nieuw blok **"Dungeons &
      Raids"**. Het heeft een knop per raid (Dreamrift, Voidspire, March on Quel'Danas, Venomous Abyss) en per
      Midnight-dungeon (o.a. Maisara Caverns, Windrunner Spire, Murder Row, Den of Nalorakk). Raids hebben een
      raid-icoon, dungeons een dungeon-icoon.
- [x] ✅ (Rob, telefoon 16 sep) **Beweeg over zo'n knop**: de tooltip noemt de **zone** van de ingang (niet "Map 2393") en *"Route to …"*.
- [x] ✅ (Rob, telefoon 16 sep) **Klik** → de pijl of TomTom wijst naar de ingang, net als de knop op de Dungeons- en Raids-pagina.
- [x] ✅ (Rob, telefoon 16 sep) **Zoekvak**: typ *voidspire* → het zoekvak springt naar die knop in het tabblad.

## 🆕 14 sep — consumables nagelopen tegen Season 2 (B)

`/reload` is genoeg. Alleen het eten van drie tanks is veranderd.
- [x] ✅ (Rob, telefoon 16 sep) **Tools → Consumables**, kies bij de specs **Vengeance Demon Hunter**, **Guardian Druid** of
      **Brewmaster Monk**: bij *Feast* staat nu **Hearty Silvermoon Parade** voorop, met de uitleg *"Primary-stat
      feast is the safe group default."* De Blooming Feast staat er nog, als tweede keus.
- [x] ✅ (Rob, telefoon 16 sep) **Een willekeurige andere spec** (bv. je eigen Protection Paladin): daar is niets veranderd.

## 🆕 14 sep — routeknop naar de raid-ingangen (Rob: "doe allebei, eerst A")

`/reload` is genoeg. Gebouwd, nog niet in het spel gezien.
- [x] ✅ (Rob, telefoon 16 sep) **Codex → Raids → klap een raid open**: onder de naam staat nu *"Route to The Voidspire"* (enz.).
      Klik → de pijl (of TomTom) wijst naar de ingang, net als bij de dungeons. Dicht geklapt is de knop weg.
- [ ] **Meet de ingangen in het spel.** Plak dit in je chat en stuur me de regels die je krijgt:
      ```
      /run for _,m in ipairs({2413,2405,2424,2509,2512}) do for _,e in ipairs(C_EncounterJournal.GetDungeonEntrancesForMap(m) or {}) do local x,y=e.position:GetXY() print(m,e.name,x and floor(x*1e4)/100,y and floor(y*1e4)/100) end end
      ```
      ⚠️ **Nieuwe versie, 16 sep.** De vorige gaf in BugGrabber (sessie 3849, 10:26) *"bad argument #2 to
      'format' (number expected, got nil)"* en brak af voordat hij iets had laten zien — `format` accepteert
      geen lege waarde. Deze drukt bij een ingang zonder positie gewoon `nil` af en gaat door.
      Onze getallen (uit Zygor): Dreamrift **2413 61.33 63.01**, Voidspire **2405 45.21 64.79**, March on
      Quel'Danas **2424 52.60 85.11**, Venomous Abyss **2509 47.25 20.51**. Controle: bij 2413 hoort ook de
      dungeon in Harandar te staan, ongeveer **26.24 78.09**. Staat die er, dan geeft het spel eerlijke
      getallen. Bij **2512** (The Coiled Isle) hoort ook The Tidebound Grotto; die staat bij ons op **59.99
      66.20**, want daar stond Rob zelf op 11 aug.
- [x] ✅ (Rob, telefoon 16 sep) 🆕 **The Tidebound Grotto** staat nu **onderaan de Raids-pagina**, met *"Route to The Tidebound Grotto"*
      als je hem openklapt, en ook in het blok *Dungeons & Raids* in het Silvermoon-tabblad. Het zwevende
      boss-venster toont hem nog steeds **één** keer, niet twee.
- [x] ✅ (Rob, telefoon 16 sep) 🆕 **Nieuwe tips voor Nymrissa (Tidebound Grotto).** Raids-pagina → The Tidebound Grotto, en het
      boss-venster tijdens het gevecht. Er staat nu:
      - murlocs doden vóór ze bij de bel zijn;
      - in het gat tussen de draaikolken staan;
      - bij de knal niet het water in;
      - ijsbollen op Normal niet aanraken;
      - tank: defensive op Iceblade Flurry.
      Klopt dat met wat je zag? Wat mist er, of wat is fout? Het komt uit de live-gidsen en DBM; wij zijn het
      nog niet zelf gelopen.
- [x] ✅ Rob 15 sep: klopt. **Knop Classic / Modern rechtsboven** (Rob, 15 sep). Een `/reload` is genoeg, want er zijn geen
      nieuwe plaatjes.
      - Naast *About* staat nu een knop. In de nieuwe look zegt hij *Classic*.
      - Klik erop: alles gaat terug naar 3.x, en de knop zegt nu *Modern*. Klik weer: de nieuwe look.
      - Zet je het om in Settings, dan volgt de knop ook.
      - Beweeg erover: de tooltip legt uit wat hij doet.
      - Staat hij in de weg, of past de tekst niet? Zeg het; we besluiten later of hij daar blijft.
- [x] ✅ (Rob, telefoon 16 sep) 🆕 Silvermoon: de kaart heet nu **Theremis — Reset specializations** (er stond "…resetten").
- [x] ✅ Rob 15 sep: klopt. **About leest nu tot het eind** (Robs screenshot, 15 sep: de tekst stopte bij "locatio…"). Klik op
      *About*: het venster is nu zo hoog als de tekst. Je hoort de hele dankregel te zien, tot en met "…no code
      from these addons is used." Klik ook op *Info* bij een paar tabbladen: ook daar mag niets meer afgekapt
      zijn, en een kort Info-venster blijft even groot als eerst.
- [x] ✅ **Rob 15 sep: "deze werkt"**, met een screenshot van Farthik in de nieuwe look: violette kaart, lila rand,
      model en gele hint. ✅ Rob, 15 sep: het model beweegt ("ja"), en de Classic-popup is "ook goed".
- [x] ✅ (Rob, telefoon 16 sep) 🆕 **De popup "Rare nearby" in de nieuwe look** (Rob, 15 sep: "eerst de popup"). `/reload` en typ
      **`/mh raretest farthik`**. Die gaat door dezelfde deur als een echte rare.
      - Nieuwe look: een effen violette kaart met een dunne lila rand, die bij het verschijnen twee keer goud
        oplicht. De titel is lichtgoud en de tekst wit.
      - **Het 3D-model beweegt nu**: het ademt of wiebelt, en staat niet meer stil.
      - Klik rechtsboven op *Classic* en typ het nog eens: dan zie je weer het oude gouden kader, met het
        model dat óók beweegt.
      - Het geldt voor álle popups, want ze delen één venster, dus ook de shard- en bounty-popups.
      - ❓ Mooi zo, of te druk? Klopt de ruimte rond het model met de dunne rand?
- [ ] 🆕 **Sporefall: gaat het boss-venster vanzelf open bij Rotmire?** (gerepareerd 15 sep). Bij de
      volgende Sporefall-pull hoort het venster vanzelf open te springen, met Rotmires model erin. Op een
      Engelse client deed het dat al; de reparatie is vooral voor spelers met een andere taal. Blijft het
      dicht, of staat er een verkeerd model: zeg het.
- [x] ✅ (Rob, telefoon 16 sep) 🆕 **Nieuwe tips voor alle 8 bazen van The Venomous Abyss** (15 sep, na Robs "absoluut incompleet").
      Raids-pagina → The Venomous Abyss, en het boss-venster tijdens het gevecht.
      - Bovenaan staat een nieuwe regel: *"Rewritten on 15 Sep ..."*.
      - Elke baas heeft nu een regel voor tank, healer en DPS.
      - Normal staat voorop; regels voor Heroic en Mythic beginnen met *"On Heroic and Mythic:"* of
        *"On Mythic:"*.
      - **Twin Fangs:** staan de gifstapels erin, de drie Feast-groepen, de groene Caustic Globules en de
        Spawn-adds?
      - **Coiled Altar:** staan de groene bollen erin (naar de marker, de klap van de tank ruimt ze op) en de
        spookjes (aankijken, dan staan ze stil)?
      - ✅ **Coiled Altar: drie fases** (DBM + alle gidsen, ook op Normal). Rob, 15 sep: *"geen idee, niet zover
        gekomen denk ik"*. De tekst houdt dus drie fases plus de pauze. ✅ Rob zag daarna in het korte voorbeeld dat
      zijn groep wél in fase 3 kwam: drie fases klopt. Zijn vraag "ik kon de bol daar achterlaten" is het ontwerp:
      de bol valt na ~5 s vanzelf neer waar je staat (AFGELEID, gidsen); het korte blok zegt "leave it there".
      - Klikbare spell-namen: staat er ergens *[Spell 1234567]* in plaats van een naam? Noem de baas.
- [x] ✅ (Rob, telefoon 16 sep) 🆕 **Ook de Season 1-raids herschreven** (15 sep, blok 2): The Dreamrift, The Voidspire en March on
      Quel'Danas, samen 9 bazen. Elke baas heeft steps, tank, healer en DPS, met dezelfde kopjes. Kijk vooral naar:
      - **Vorasius:** de muren moet je kapotmaken, niet erachter schuilen;
      - **Crown of the Cosmos:** de mini-bazen heten Demiar, Morium en Vorelus;
      - **Midnight Falls:** je staat IN de Dawnlight Barrier.
      De interne "EXBoss"-notitie is weg.
- [x] ✅ Rob 15 sep: klopt. **About: EXBoss is weg en DBM staat erbij, in alle 7 talen.** In het Duits ontbraken ook de regeleinden.
- [x] ✅ Rob 15 sep: "ook goed" (wens: rol kiezen, zie onderaan). **Korte tips (B + C)** (Rob, 15 sep: "eli10 versie"). Een `/reload` is genoeg.
      - **Boss-venster:** open het bij een raidbaas, bijvoorbeeld The Coiled Altar via de Raids-pagina of `/mh`.
        - Je ziet 3 korte regels met een lila label ("Phase 1", "Walls" …), en daaronder één regel voor jouw rol:
          *"You (tank): …"*.
        - Linksonder staat **Show all tips**. Klik erop: de volledige tekst. De knop heet dan **Show short tips**.
      - **Bij een pull:** het venster gaat dicht zoals altijd. Haal je het terug met het knopje, dan staat het korte
        blok er weer.
      - **Raids-pagina:** per baas eerst "In short" met de korte regels, daaronder "All tips".
      - **Settings** → *Short tips in the boss window*: zet hem uit. Het venster toont dan altijd alles, en de knop
        linksonder verdwijnt.
      - **Dungeons** hebben (nog) geen korte tips: daar verandert niets.
      - ❓ Snap je de korte regels in het gevecht? Welke is nog te moeilijk?
      - ❓ Overlapt de knop linksonder de Route-knop als het venster smal is?
- [x] ✅ (Rob, telefoon 16 sep) 🆕 **Raids-pagina: oudere raids onderaan** (Rob, 15 sep: "Doe maar"). Een `/reload` is genoeg.
      - Codex → Raids. Bovenaan staat **The Venomous Abyss** (open), daaronder **The Tidebound Grotto**.
      - Dan een gouden kop **Older raids (Season 1)**, met daaronder The Dreamrift, The Voidspire en March on
        Quel'Danas.
      - Silvermoon-tabblad → blok *Dungeons & Raids*: dezelfde volgorde (Venomous Abyss eerst), zonder kop.
      - ❓ Staat de kop niet tegen de knop eronder geplakt?
- [x] ✅ (Rob, telefoon 16 sep) 🆕 **Bewegende bazen bij alle raids en dungeons, en klikbaar** (Rob, 15 sep). Een `/reload` is genoeg.
      - Codex → Raids: klap The Dreamrift open. Je ziet nu ook daar een rij bewegende bazen.
      - Codex → Dungeons: klap een dungeon open, bijvoorbeeld Murder Row. Boven de tips staat de rij bazen.
      - Ga met de muis op een baas: een tooltip zegt *Click: open the tips window for this boss*.
      - Klik: het tips-venster opent op die baas.
      - ❓ Staat er een baas zonder model (een leeg vakje met alleen de naam)? Welke? Klap dicht en weer open; dan
        vraagt hij het nog eens.
- [x] ✅ Rob 15 sep: goed. **Nieuwe dungeon-tips (blok 3 en 4)** (Rob, 15 sep). Een `/reload` is genoeg.
      - Codex → Dungeons → Murder Row. Bij Kystia staat nu "kill Nibbles first" (was precies andersom), met
        bovenaan **In short**.
      - Kings' Rest, Temple of Sethraliss en Ruby Life Pools hebben nu tips (die hadden er geen).
      - In een dungeon: het boss-venster toont de korte tips en **Show all tips**, net als bij raids.
      - ❓ Klopt er iets niet met wat je in het gevecht zag? Zeg welke baas.
- [x] ✅ (Rob, telefoon 16 sep) 🆕 **Sporefall en de ritual-bazen opnieuw** (Rob, 15 sep). Een `/reload` is genoeg.
      - Boss-venster voor Rotmire (Sporefall): korte tips bovenaan ("Adds", "Shrooms", "Vines"), en je rol-regel.
      - Boss-venster voor de Corrupted Amani Dragonhawk en Ger'lok (Broken Throne): ook korte tips.
      - Mindbreaker en Selen'vjar (Daggerspine Point) hebben géén korte tips: er is nog te weinig bekend.
      - ❓ Doe je Daggerspine Point: wat deden de Mindbreaker en Selen'vjar? Dan gaat het erin.
- [x] ✅ (Rob, telefoon 16 sep) 🆕 **De 8 oudere dungeons opnieuw** (Rob, 15 sep). Een `/reload` is genoeg.
      - Codex → Dungeons → bijvoorbeeld Maisara Caverns: bij Vordaza staat nu dat je de phantoms tegen elkaar laat
        botsen (was: "kill the phantoms"). Bovenaan elke baas **In short**.
      - Windrunner Spire, Nexus-Point Xenas en Magisters' Terrace idem; die draai je ook op Normal/Heroic.
      - ❓ Klopt er iets niet met wat je in het gevecht zag? Zeg welke baas.
- [x] ✅ Rob 15 sep: "helemaal goed", Classic goedgekeurd (wens: meters in het Nederlands, gebouwd). **De Rares-pagina in de nieuwe look** (Rob, 15 sep: "begin maar aan de moderne rare pagina"). Een
      `/reload` is genoeg. Codex → Rares:
      - De rijen zijn vlak violet (geen rode Blizzard-knoppen meer). Een rare die nu leeft: groen **UP** en een
        gouden naam. Open: een streepje en een witte naam. Gedood deze week: gedempt, met het woordje **done**.
      - Rechts in elke open rij staat de afstand, bijvoorbeeld *340 yd*, en die loopt mee als je beweegt.
      - Links: de actieve zone heeft een lila streepje, net als de zijbalk.
      - Muis op een rij: in de tooltip staat nu ook de hint van die rare (bijv. dat je eerst een kist opent).
      - **Classic look:** alles zoals vroeger, alleen is "gedood" nu grijs in plaats van groen.
      - ❓ Leest de afstand goed, of zit hij de naam in de weg bij lange namen?
- [x] ✅ (Rob, telefoon 16 sep) 🆕 **Na Robs testronde van 15 sep 's avonds.** Een `/reload` is genoeg.
      - **Silvermoon:** maak het MH-venster smaller en weer breder. De kaarten schuiven mee; bij smal worden het
        2 kolommen (of 1). Er valt rechts niets meer weg: Enchanting en Jewelcrafting staan er weer.
      - **Raids:** alle raids beginnen ingeklapt. (Heb je er zelf een open- of dichtgeklikt, dan blijft die zo.)
      - **Tidebound Grotto:** klap open → Nymrissa heeft nu een bewegend model.
      - **Rares in het Nederlands:** de afstand eindigt op *m* (op een Engelse client zie je nog *yd*).
      - **Rol kiezen:** open het tips-venster van een raidbaas. Naast *Show all tips* staan drie icoontjes (tank,
        healer, dps). Klik de healer: de laatste korte regel wordt *"You (healer): …"*. Klik dezelfde nog eens:
        terug naar je eigen spec. Op de Raids-pagina geldt dezelfde keuze.
      - **Moeilijkheid:** typ `/mh bossdiff normal` en open een raidbaas in het tips-venster, klik *Show all tips*.
        De regels "On Heroic and Mythic…" en "On Mythic…" zijn weg, en onderaan staat een grijze regel dat ze
        verborgen zijn. `/mh bossdiff heroic`: de Heroic-regels komen terug. `/mh bossdiff off`: weer alles.
      - In een echte dungeon of raid gaat dat vanzelf. `/mh bossdiff` zonder woord zegt welke moeilijkheid MH ziet.
      - **Settings:** *Only tips for my difficulty* staat aan; zet hem uit en het venster toont altijd alles.
      - ❓ Zitten de drie rol-icoontjes de knoppen rechtsonder in de weg als het venster smal is?
      - ✅ Rob 15 sep: Silvermoon en Raids oké, rol-icoontjes oké, `/mh bossdiff normal` werkt, Settings-schakelaar
        werkt (korte tips blijven bewust ongefilterd). 🐛 In een delve, bij een raidbaas: "Delves: lines for harder
        difficulties are hidden" → gerepareerd: het filter werkt nu alleen in een dungeon of raid, en alleen voor
        bazen van dat soort plek. Controleer: in een delve een raidbaas openen → geen grijze regel meer.
- [x] ✅ (Rob, telefoon 16 sep) 🆕 **Disciple of Vashnik in de Delve Coach** (Rob, 15 sep: "een baas die we volgens mij niet hebben"). Een
      `/reload` is genoeg.
      - Ga Atal'Aman in met het verhaal **Venomous Vapors**. De Delve Coach noemt nu *Disciple of Vashnik* als
        eindbaas (met model), en bij Route/Trash/Boss staan zijn regels in plaats van die van Jin'Ma.
      - Boss-tips: onderbreek **Malignance** zelf (Valeera doet het niet altijd), **Toxic Froth** = zware gifschade
        die je kunt cleansen, **Living Venom** = knockback + slijm doden.
      - Doe je een ander Atal'Aman-verhaal: dan staat alleen Jin'Ma er, zoals eerst.
      - Shadowguard Point met **Basilisk Blitz** heeft dezelfde baas.
      - ✅ Beantwoord door Rob (15 sep): 2 kisten in de eerste kamer openen, daaruit o.a. **Fireball** (spell
        1298792) oppakken en die in een Toxic Cloud gooien; het tweede gereedschap laat je heel hoog springen.
        ✅ Rob 15 sep, later (screenshots): het spring-ding heet **Springstep Rune** (uit de *Rune Chest*), de Fireball
        komt uit de **Fire Gauntlet** (*Gauntlet Chest*), en eerst praat je met **Marla**. De route staat nu zo in drie
        regels, en de Springstep Rune heeft een tooltip. Kijk bij de volgende run of het zo leest als je het ziet.
      - ❓ Staat zijn model er, en klopt het?
- [x] ✅ (Rob, telefoon 16 sep) 🆕 **Delves bijgewerkt voor Seizoen 2** (Rob, 15 sep: "doe de delve-audit maar"). Een `/reload` is genoeg.
      Open de Delve Coach (of loop de delve in) en kijk:
      - **The Shadow Enclave**, verhaal *Infiltrate and Ameliorate*: eindbaas is nu **Abominable Blunder**. De route
        noemt Scout Lok'aemon, 5 Ula'tek Summoners en 4 ketels. ❓ Staat er een model, en klopt het?
      - **Twilight Crypts**, *Why'd it have to be snakes?*: eindbaas **Replicating Venomborne**, niet Darza.
      - **Parhelion Plaza**, *Caustic Crush*: volgens Blizzards data is de laatste stap een **Ritual Pillar**, geen
        baas. ❓ Wat stond er in jouw doelen aan het eind?
      - **Shadowguard Point**, *Basilisk Blitz*: de route staat er nu (Energy Distributor, Waygate, 4 Power
        Generators, 4 Energized Basilisks), in plaats van "no route notes yet".
      - **Gnarldor Isle** en **The Ring of Glory**: nieuwe blokken *Trash* en *Boss*. Klik met ◀ ▶ door de bazen:
        de kisten-waypoints blijven bij élke baas staan.
      - **The Grudge Pit**, *Arena Champion*: onder Gyrospore staat nu dat DBM en je delve-geschiedenis dit gevecht
        *Spinshroom* noemen.
      - **Venomfall Deeps** (Azta'rec): op ?? staat nu dat je de Echo of Azta'rec in elke pauze moet doden.
      - ❓ Kom je een verhaal tegen waar de tips niet kloppen? Zeg welke delve en welk verhaal.
- [x] ✅ (Rob, telefoon 16 sep) 🆕 **`/mh weeklies` is niet meer een muur tekst** (Rob, 16 sep: "dit zijn weer heel veel regels").
      Een `/reload` is genoeg.
      - Typ `/mh weeklies`: je krijgt nu **3 of 4 regels** — hoeveel weeklies in je log staan, hoeveel
        completed, hoeveel givers iets te halen hebben, wanneer het laatste gossip-venster openging, en
        hoeveel regels er zijn opgeslagen.
      - Wil je toch alles zien: `/mh weeklies full` print de hele lijst zoals vroeger.
      - ❓ Staat er iets in de samenvatting dat niet klopt met de volledige lijst?
- [x] ✅ **Meting gedaan (Rob, 16 sep 07:02):** alle vijf de Curse-Surge-plekken geven 1800 seconden, en de
      starts liggen 1800 uit elkaar. Blizzards 30 minuten klopt, en de client geeft het getal zelf.
- [x] ✅ (Rob, telefoon 16 sep) 🆕 **Lor'themar staat nu in je weekroutine** (Rob, 16 sep: "ja doe Lor'themar er maar bij").
      Een `/reload` is genoeg.
      - Home → de routine na de reset: er hoort nu een stap **Lor'themar Theron** bij te staan. Heb je
        *Midnight: World Tour* al in je log, dan moet die stap meteen als "opgepakt" tellen en je niet meer
        vragen hem te halen.
      - `/mh weeklies` toont hem als eigen blokje, met de titel die het spel zelf teruggeeft.
      - ❓ Klopt die regel met wat je in het spel ziet? En krijg je 'm echt bij Lor'themar in Silvermoon?
- [x] ✅ Rob 16 sep: `/mh questscan time` gaf **93611 "A Shattered Path Through Time"**. Die staat nu vast bij
      Aethas (hij zat al in jouw leergeheugen, maar niet in wat we meeleveren).
- [x] ✅ (Rob, telefoon 16 sep) 🆕 **Timewalking telt nu mee bij Aethas.** Een `/reload` is genoeg. Kijk in de routine: zolang die quest
      in je log zit, hoort de stap bij **Aethas Sunreaver** als "opgepakt" te staan en je niet meer te vragen
      hem te halen. ❓ Klopt dat?
- [x] ✅ (Rob, telefoon 16 sep) 🆕 **Boss-venster: delen, rollen en moeilijkheid** (Rob, 16 sep). Een `/reload` is genoeg.
      - [x] ✅ Rob 16 sep: *"de dumps zijn wel goed"* — **Deel / Chat volgen nu wat je ziet.**
      - [x] ✅ De rol-icoontjes blijven staan bij de volledige lijst.
      - [x] ✅ (Rob, telefoon 16 sep) 🆕 **De knop Moeilijkheid was onzichtbaar** (Rob: *"ik zie geen moeilijkheid opties"*). GEMETEN in
        je SavedVariables: `diffFilter = false` — jij had *Only tips for my difficulty* uit staan, en precies
        dáár verstopte de knop zich. Nu doet die ene knop alles: klikken loopt rond **Alles → Auto → Normal →
        Heroic → Mythic → Alles**, en *Alles* ís die instelling uit. Hij staat er altijd zodra je de volledige
        lijst bekijkt. ❓ Zie je hem nu, en gaan de regels "On Heroic and Mythic…" weg op **Normal** en terug
        op **Mythic**? (Het vinkje in Settings verandert mee; het scherm ververst pas als je het opnieuw opent.)
      - [ ] 🆕 **De knop staat nu ook bij de korte lijst, maar grijs** (Rob: *"hij staat bij full en niet bij
        short"* → *"doe A maar"*). Klikken doet daar niets, want de korte tips gelden op elke moeilijkheid.
        ❓ Beweeg erover: zegt de tooltip dat ook, in het rood, onder de gewone uitleg?
      - [x] ✅ (Rob, telefoon 16 sep) 🆕 **Je eigen rol is nu te zien in de volledige lijst** (Rob: *"bij de full versie blijft de tekst
        op dps staan"*). Vóór jouw rol-blok staat nu het rol-icoontje. Klik een andere rol aan → het icoontje
        verspringt. ❓ Verspringt het?
      - [ ] 🆕 **In de chat staat nu vóór de rolregel wie het is** (Rob: *"kan er bij de role tip ook voor komen
        welke role het is"*): *Jij (tank): …*. Geldt voor **Chat** én **Deel**.
      - [ ] 🆕 Bij **Chat** met de volledige lijst komt nu ook het **DPS**-blok mee. Dat ontbrak er gewoon.
- [ ] 🆕 **Randjes om de iconen, tweede poging** (Rob, 16 sep, met screenshots waarop *Rares* en *Account
      snapshot* hun randje misten en de buren niet). Ze worden nu als vier lijntjes op de kaart zelf getekend
      in plaats van als los venstertje erbovenop. Een `/reload` is genoeg.
      - Loop alle kamers langs: **Ik**, **Codex**, **Tools**. Heeft élke kaart zijn gouden randje, meteen,
        zonder te schalen?
      - Maak het venster een paar keer groter en kleiner, en klap tussen **Klassiek** en **Modern**. Blijven
        ze staan?
      - Ook het icoon in de **balk bovenin** (naast de uitleg) is zo omgebouwd. ❓ Staat dat randje er ook?
- [ ] 🆕 **Twee extra knoppen op de snelbalk** (Rob, 16 sep). Een `/reload` is genoeg. Staat de balk uit, zet
      hem aan met `/mh bar` (of Settings → Quick bar).
      - **In een groep** komt er een knop bij met het consumables-icoon. Klik → het Consumable Ready Board
        komt op; klik nog eens → weg. Verlaat je de groep, dan verdwijnt de knop en krimpt de balk.
      - **In een dungeon, raid of delve** komt er een knop bij met het dungeon-icoon. Klik → het boss-venster
        aan/uit, ook midden in een gevecht.
      - ✅ Rob 16 sep: *"de extra knoppen in een instance werken goed trouwens"* — de boss-knop is gezien en
        doet wat hij moet doen.
      - ❓ Nog open: de **board-knop in een groep** (verschijnt/verdwijnt hij met de groep?), en of hij ook
        tijdens een gevecht werkt — dichtgaan mag dan pas ná het gevecht.
- [ ] 🆕 **De lijntjes om de kaart-iconen blijven nu staan** (Rob, 16 sep). Open Codex, en maak het venster
      een paar keer groter en kleiner. De gouden randjes om de iconen horen er meteen te staan, ook zonder
      slepen. ❓ Zie je er nog een verdwijnen?
- [ ] 🆕 **Codex in Modern: de secties zijn nu kaarten** (Rob, 16 sep: "doe C maar"). Een `/reload` is genoeg.
      - Klik in de zijbalk op **Codex**. Je ziet nu een kaart per sectie van het handboek — Start Here,
        Weeklijkse loop, Currencies, Delves, Dungeons & M+, Raid & crests, Wereldcontent, Coiled Isle,
        Professions — plus Dungeons, Raids, Leveling en Silvermoon City.
      - Klik een sectiekaart: je komt meteen in díé sectie van het handboek, niet op de eerste.
      - Slepen werkt ook hier: sleep een kaart naar voren, en rechtsklik → *Reset de volgorde*.
      - ❓ Staat de volgorde van de kaarten gelijk aan de knoppenbalk bovenin het handboek?
      - ❓ Is het zo handiger, of wil je er juist minder kaarten?
- [x] ✅ (Rob, telefoon 16 sep) 🆕 **Classic ↔ Modern laat je niet meer op een half scherm staan** (Rob, 16 sep, screenshots 2-4).
      Een `/reload` is genoeg.
      - Zet **Klassiek** aan, open **Codex → Midnight Codex**, klik dan op **Modern**: je hoort nu het
        kaartoverzicht van de Codex te zien (de vijf kaarten), niet de oude pagina met een banner erboven.
      - Andersom: sta in Modern op het kaartoverzicht en klik **Klassiek** → je komt op het eerste scherm van
        die kamer, want kaarten bestaan daar niet.
      - ❓ Doet hij dat ook bij **Ik** en **Tools**? En blijft **Instellingen** gewoon staan (één scherm)?
- [x] ✅ Rob 16 sep: staat er, en zegt 30. **Curse Surge: de cyclus komt nu uit het spel.** Een `/reload` is genoeg.
      - Codex → Achievements → **Turn the Surge**, en beweeg over een van de vijf bazen (of open zijn kaart).
        Onder de bekende notitie staat nu een tweede zin: *"Your client says this event moves on to the next
        spot every 30 minutes."*
      - ❓ Staat dat er, en zegt hij **30**? Staat er geen tweede zin, dan gaf je client op dat moment geen
        schema — dat is de bedoeling, we verzinnen er dan geen getal bij. Zeg het wel even.
      - Ook meegepakt: bij de Peculiar Cauldron (het verzamel-doel) toonde het toastvenster de interne
        sleutel in plaats van de tekst. Kijk of daar nu gewoon Nederlands/Engels staat.
- [ ] 🆕 **Het Silvermoon-tabblad in kaarten** (alleen in de nieuwe look). ⚠️ **Sluit WoW eerst helemaal af
      en start opnieuw**: nieuwe plaatjes laadt het spel niet met een `/reload` (GEMETEN op 12 sep).
      Dan: Codex → Silvermoon City. Je ziet kaarten met jouw plaatjes: portaal, dragonhawk, keystone
      (M+ Teleports), kistje, weegschaal, pul en pijl. En uit ronde 2: envelop (Mailbox), paspop
      (Transmog), kristal in een kooi (Catalyst), vleugel-crest (Crest Exchange), questrol (Weekly Quest
      Givers) en gekruiste zwaarden (PvP Hub). Ritual Site en Void Assault tonen het Rituals-icoon,
      "World boss this week" het raid-icoon. Raids en dungeons hebben hun eigen icoon, met de
      zone eronder. En uit ronde 3 (de 13 lege vakjes van Robs screenshot):
      fles (Alchemy), hamer + tang (Blacksmithing), kristal boven stof (Enchanting), stofbril (Engineering),
      veer in inktpot (Inscription), ring met blauwe steen (Jewelcrafting), armbeschermer (Leatherworking),
      klos goudgaren (Tailoring), vis aan een haak (Fishing), bosje kruiden (Herbalism), ertsbrok (Mining),
      mes op een vacht (Skinning) en stropop (Training Dummies). En uit ronde 4 (15 sep): kist met hamer
      (Crafting Orders), twee pijlen rond een kristal (Theremis), jachthoorn (Prey Hub) en een gouden boek
      (Astalor). ⚠️ Ook deze vragen een **volledige herstart** van WoW. Beweeg over een kaart →
      hij licht op; klikken zet de route zoals altijd.
      ❌ Zie je een **leeg vakje** waar een plaatje hoort, dan is WoW niet helemaal herstart geweest.
- [x] ✅ (Rob, telefoon 16 sep) 🆕 Zet **Classic** aan (Settings) en ga terug naar het Silvermoon-tabblad: de oude rode knoppen staan
      er weer, zoals in 3.x. **Nieuw:** de beroepen, verzamelberoepen en Training Dummies tonen daar nu ons
      eigen plaatje, klein; in 3.x was dat vakje leeg (Rob: "ja, doe Classic ook maar"). Alle andere knoppen
      houden Blizzards symbool. Terug naar de nieuwe look → weer kaarten, zonder `/reload`.
- [ ] 🆕 Typ **bank** in de zoekbalk en kies de Bank-pin: het tabblad springt naar die kaart en die licht
      even op.
- [ ] 🆕 Typ **`/mh smcicons`** (na een `/reload`). Je ziet drie dingen: hoeveel pins ons eigen plaatje hebben,
      hoeveel Blizzard-symbolen het spel kent, welke pins in beide looks leeg zijn ("Empty in both looks"),
      en waar Classic ons plaatje toont ("Classic shows our picture"). Verwacht onder *both looks*: **0**.
      Onder *Classic shows our picture* staan in elk geval de 13 uit ronde 3, want daar bestaat Blizzards
      symbool niet. Staat er iets onder *both looks*, dan is dat een kaart die nog een plaatje mist. Plak
      de lijst of maak een screenshot.
- [ ] 🆕 **"Recommended" laat je eigen keuzes staan.** Zet Classic aan, maak de tekst groter en verberg één
      achievement (Achievements-tab). Druk dan op Settings → *Set everything to recommended*: Classic blijft
      aan, de tekst blijft groot en die achievement blijft verborgen. Open daarna een
      boss-venster: het grote model van de baas staat uit. (Blizzards eigen *Defaults*-knop zet wél alles
      terug; dat is bedoeld.)

## 🆕 13 sep — geen onterechte "That area starts at level 82" meer (levels uit het spel zelf)

Rob, level 81 in Harandar, kreeg *"the enemies there are well above you"*, terwijl de mobs daar
meeschalen. Zijn `/run`-meting (C_Map.GetMapLevels): Eversong, Zul'Aman, Harandar en Voidstorm allemaal
**80 90**, Coiled Isle **90 90**, Silvermoon en Slayer's Rise **0 0**. `/reload` is genoeg.
- [x] **Op de level-81**: zet een route naar iets in Harandar (bv. een schat) → **geen** melding meer.
      ✅ **Rob, 13 sep, na `/reload`: "goed gegaan".**
- [ ] **`/mh zonegate`** → vijf regels, per gebied *"game says 80-90"* (Coiled Isle *90-90*). Op level 81
      waarschuwt alleen The Coiled Isle.
- [ ] **Een route naar The Coiled Isle** op die 81 → de melding komt nog wel, en eindigt nu op *"above your
      level"* in plaats van *"well above you"*.

## 🆕 13 sep — twee Inscription-schatten in Harandar omgedraaid

Rob had de Intrepid Explorer's Marker opgepakt, maar MH toonde hem met een rood kruis en gaf de
Pigment een vinkje. De twee quest-ID's stonden omgewisseld. `/reload` is genoeg.
- [ ] **Tools → Professions → Treasures & Books**: *Intrepid Explorer's Marker* heeft nu een ✓, en
      *Leftover Sanguithorn Pigment* een rood ✗.
- [x] ✅ **Rob, 13 sep: de Pigment lag er nog, en hij pakte hem op** (screenshot *"You received Leftover
      Sanguithorn Pigment"*). Vóór de reparatie toonde MH hem als opgepakt, dus de omwisseling is nu
      in het spel GEMETEN.
  - [ ] Nog even kijken: heeft de Pigment nu een ✓, en telt *Midnight Inscription* 7/8?

## 🆕 13 sep — 4.0.0: kaarten verslepen (Rob: "bouw het slepen maar")

`/reload` is genoeg (geen nieuwe bestanden). Gebouwd, nog niet in het spel gezien.
- [ ] **Beweeg over een kaart**: de tooltip zegt nu ook *"Drag to move this card."*
- [x] **Pak een kaart** (linkermuis ingedrukt houden en bewegen): de kaart gaat met de muis mee en is
      iets doorzichtig. De andere kaarten schuiven opzij naar de plek waar hij zou landen.
      ✅ **Rob, 13 sep: "wauw, dat we dat niet eerder hadden bedacht"**.
- [x] **Laat los** → de kaart staat op zijn nieuwe plek. ✅ Zelfde test. Niet apart genoemd: dat het
      scherm daarbij níét opent.
- [ ] **Gewoon klikken** op een kaart opent het scherm nog, net als eerst.
- [x] **Na `/reload`** staat je volgorde er nog. Elke kamer (Me, Codex, Tools) heeft zijn eigen volgorde.
      ✅ **Rob, 13 sep: "ja ze blijven staan".**
- [x] **Rechtsklik op een kaart** in een kamer die je hebt omgegooid → *"Reset the order"*. Klik →
      de standaardvolgorde is terug. In een kamer die je niet hebt aangeraakt staat die regel er niet.
      ✅ **Rob, 13 sep: "beide werken goed"** (Reset the order en Classic).
- [ ] **This Week** kun je ook verslepen, en met rechtsklik krijg je daar nu ook een menu (zonder
      "Hide", want This Week kan niet weg).
- [x] **Classic look aan**: de lange lijst staat in de oude volgorde; de kaarten zijn er dan niet. De
      knopjes bovenin (hieronder) kun je ook in Classic slepen. ✅ Rob, 13 sep: "beide werken goed".

### 🆕 13 sep, daarna — ook de knopjes bovenin (Rob: "doe het slepen ook maar voor de knopjes bovenin")

`/reload` is genoeg. Gebouwd, nog niet in het spel gezien.
- [ ] **Beweeg over een knopje** (bv. *Rares*): de tooltip zegt nu ook *"Drag to change the order."*
- [x] **Sleep een knopje** opzij: het gaat mee met de muis, de andere schuiven opzij, en de **+** schuift
      mee naar het eind. ✅ **Rob, 13 sep: "ja dit werkt ook".**
- [x] **Laat los** → het knopje staat op zijn nieuwe plek. ✅ Zelfde test.
- [ ] **Gewoon klikken** opent nog, en **rechtsklik** haalt het knopje nog weg.
- [x] **Na `/reload`** staat je volgorde er nog. ✅ **Rob, 13 sep: "ik test de knopjes ook even na een
      reload en ook dat gaat goed".**

## 🆕 13 sep — 4.0.0: schermen zelf verstoppen (Rob: "bouw het voor 4.0.0, allebei de plekken")

`/reload` is genoeg (geen nieuwe bestanden). Alles gebouwd, niets in het spel gezien.
- [ ] **Beweeg over een kaart** (bv. Trading Post in Me): onderaan de tooltip staat *"Right-click: hide
      this screen."* Bij **This Week** staat die regel er niet: This Week en Settings kunnen niet weg.
- [x] **Rechtsklik op die kaart** → een menuutje met de naam en *"Hide this screen"*. Klik erop → de
      kaart is weg, en onder de kaarten staat *"Hidden: 1 — show again"*. ✅ **Rob, 13 sep: "de
      rechtermuis klik werkt"** — dus MenuUtil werkt op 12.1 (was AFGELEID).
- [x] **Klik op "Hidden: 1 — show again"** → een menuutje met het verstopte scherm (bij twee of meer
      ook *"Show all"*). Klik → de kaart is terug. ✅ **Rob: "het terug halen ook".**
- [x] **Instellingen**: Esc → Options → AddOns → Midnight Helper → **Screens**. ✅ **Rob: "ook in de
      settings staat screens met vinkjes".**
  - [ ] Nog niet genoemd: staan de kopjes **Me, Codex en Tools** erboven, en onder Codex *"Codex:
        Basics"*? En haalt een vinkje weg het scherm echt uit de kaarten?
- [ ] **Verstop via rechtsklik, kijk dan in Screens**: dat vinkje staat uit.
- [ ] **Een verstopt scherm opent nog via het zoekvak** bovenin (typ bv. *trading*).
- [ ] **Verstop alle vijf de Codex-schermen** en klik op de kamer Codex → een lege kamer met alleen de
      regel *"Hidden: 5 — show again"*. Via die regel kun je alles terugzetten.
- [ ] **Classic look aan**: verstopte schermen staan ook niet in de lange lijst.
- [ ] **De oude Beta-vinkjes** (Codex, Guide, Macros, Academy) staan niet meer op de hoofdpagina van
      de instellingen. Had jij er een uit staan, dan is dat scherm nu verstopt, en kun je het terugzetten.
- [ ] **Na `/reload`** blijven je keuzes staan.

### 🆕 13 sep, daarna — dezelfde lijst in MH zelf (Rob: "doe maar nummer 2")

`/reload` is genoeg (geen nieuwe bestanden).
- [ ] **Settings in MH** (kamerknop Settings): onder de grote knop staat nu **"Choose your screens"**.
      De rest van de pagina schuift een knop omlaag.
- [x] **Klik erop** → een scherm *Screens* in onze kleuren. Kopjes **Me, Codex en Tools**, en per
      scherm een vakje, het plaatje en de naam. Een aan-scherm heeft een paars gevuld vakje; een
      verstopt scherm is grijs en heeft een leeg vakje. De titelbalk zegt *Settings > Screens*.
      ✅ **Rob, 13 sep: "ja dat ziet er goed uit".**
- [x] ✅ **Rob, 13 sep, na `/reload`: "ja het is opgelost".** **Maak het venster laag** (sleep de hoek omhoog) en ga naar Settings: de pagina **schuift**
      nu. Er komt een schuifbalk rechts, en geen knop steekt meer onder MH uit. Maak het venster
      weer groot: de schuifbalk verdwijnt. Rob zag op 13 sep dat de knoppen eronder uitstaken;
      dat was al zo vóór de nieuwe knop.
- [ ] **Klik een regel** → het vakje wisselt, en de kaart verdwijnt uit (of komt terug in) die kamer.
- [ ] **"Show all"** naast de titel staat er alleen als er iets verstopt is, en zet alles terug.
- [ ] **Rechtsklik op een kaart** → het menuutje heeft onderaan **"All screens..."**. Dat opent deze
      pagina. Dezelfde regel staat in het menu onder *"Hidden: N — show again"*.
- [ ] **Zoekvak**: typ *hide* of *screens* → de Screens-pagina staat in de lijst.
- [ ] **Verstop iets op deze pagina, kijk dan in Blizzards Settings → Screens**: daar staat het vinkje
      ook uit.

## 🆕 12 sep — 4.0.0: de nieuwe regels vertaald (de/fr/es/pt/it)

- 📌 **Niet door Rob te testen**: zijn client is Engels, en `/mh lang de` doet daar niets (de
  taalpacks laden alleen op een client in die taal). Een speler met een Duitse, Franse, Spaanse,
  Portugese of Italiaanse client zou de kopregels, kamerregels en tegelregels nu in zijn taal moeten
  zien. Speelt Cisca in een andere taal, dan is dat de test.
- [ ] **Wel te zien voor Rob:** de regel onder een tegel mag nu over twee regels lopen. In het Engels
      past alles op één regel, dus er hoort niets te veranderen.

## 🆕 12 sep — 4.0.0 stap 4: geen lange lijst meer, openen op de tegels

Rob, na stap 2 en 3 (*"alle 3 de vragen oke, ik vind het echt gaaf"*): de tegels zag hij pas na een klik
op Me, en *"dan is die lange lijst aan de linker zijde in mijn ogen overbodig"*. `/reload` is genoeg.
- [x] **Open MH na `/reload`:** je ziet meteen de **Me-tegels**, niet This Week. ✅ **Rob, 12 sep,
      screenshot: "zoals ik wilde".**
- [x] **De zijbalk** heeft alleen nog de **vier kamerknoppen**, groter en met onze eigen plaatjes. De
      lange lijst met schermen is weg. ✅ Zelfde screenshot.
- [x] **Statusregels kloppen** (screenshot): *9 of 13 weekly things done*, *Great Vault 2 / 9*,
      *Weeklies done: 2 / 2*, *Live now: 3*, *Missing enchants: 7*, *Tier set 1 / 5*, *Characters: 12*.
      Rob controleerde de 7: *"er staan er ook 7"* op het Enchants-scherm.
- [ ] 🆕 **De schuifbalk rechts van de tegels** is weg als alle tegels passen, en komt terug als het
      venster te klein is (maak het venster lager of zet Compact mode aan).
- [ ] **Klik een tegel** → dat scherm. **Klik op de kamerknop** → terug naar de tegels. Settings opent
      meteen Settings.
- [ ] **Je venster wordt niet kleiner** dan het was.
- [ ] **Sneltoetsen en Stream Deck-knoppen** naar een scherm werken nog gewoon.
- [ ] **Rondleiding** (Start Here → de rondleiding): stap 1 heet nu *"The rooms"* en zegt dat een klik
      op een kamer de tegels opent.
- [ ] **Classic look aan:** de lange lijst en de kleine knoppen met Blizzard-plaatjes zijn terug. Na
      `/reload` opent MH weer op This Week.

## 🆕 12 sep — 4.0.0 stap 3: kleuren C "Schemerlantaarn" (Rob: "Het wordt C")

`/reload` is genoeg (geen nieuwe bestanden). Vergelijk met het voorbeeld `_kleuren_A_B_C.png`, rechts.
- [ ] **De zijbalk** is effen donker violet. De **rode knoppen zijn weg**: de rijen zijn plat, het
      scherm waar je bent heeft een lichtere violette balk met een paars streepje links, en met je
      muis erover wordt een rij iets lichter.
- [ ] **De titelbalk, de zoekbalk en de favorietenrij** zijn ook donker violet; de knoppen *About*,
      *Info*, *Search* en *My character* (en *Read in Codex*) zijn violette blokjes met goudkleurige
      tekst.
- [ ] **Het scherm zelf** heeft een effen violette achtergrond en is minder doorzichtig dan eerst
      (95%). Staat er ergens nog een bruin of rood stuk **binnen** een scherm (bijvoorbeeld de
      knoppen bovenaan Toolbox of Addons, of de Settings-pagina), dan klopt dat: die volgen later.
      Zeg welke je het meest stoort.
- [ ] **Leesbaar?** Vooral de Duitse/Franse knoppen niet: jouw client is Engels. Kijk of de
      zijbalkteksten nog in hun rij passen.
- [ ] **Classic look aan:** alles is weer precies bruin/rood zoals in 3.11.1, zonder `/reload`. Weer
      uit: meteen weer violet.
- [ ] De kop en de tegels hebben dezelfde kleuren (zacht goud voor namen, lichtpaars voor regels).

## 🆕 12 sep — 4.0.0 stap 2: tegels per kamer (Rob: "doe maar 1 en 2")

⚠️ **WoW helemaal opnieuw starten**: er is een nieuw Lua-bestand (`RoomLauncher.lua`), en dat laadt
het spel pas na een volledige herstart.
- [ ] **Klik op de kamerknop "Me"** (bovenaan de zijbalk). Je krijgt nu een rooster met tegels in
      plaats van meteen This Week: 15 tegels, elk met plaatje, naam en soms een regel eronder.
- [ ] **Codex** geeft 4 of 5 tegels, **Tools** 6 (Pop-outs, Consumables, Macros, Academy, Professions,
      Addons). **Settings** heeft maar één scherm en opent dat meteen, net als eerst.
- [ ] **Muis op een tegel:** een tooltip met de naam en de regel over waar dat scherm voor is.
      **Klik:** dat scherm opent, en in de zijbalk staat de goede kamer aan.
- [ ] **Kloppen de regels onder de tegels?** Vergelijk ze met het scherm zelf:
      - This Week: *"x of y weekly things done"*, hetzelfde als op This Week;
      - Delves & Vault: *"Great Vault x / 9"*, hetzelfde als de Vault-kolom in Account snapshot;
      - Void & Rituals: *"Weeklies done: x / 2"*; Events: *"Live now: x"*;
      - Enchants & Gems, Tier Sets, Account snapshot (*"Characters: x"*), Raids (*"Bosses: x"*) en
        Professions (*"Knowledge to spend: x"*).
      Een lege regel bij de andere tegels is expres: daar rekent MH (nog) niets goedkoop uit.
- [ ] **Classic look aan:** de kamerknoppen doen weer precies wat ze in 3.11.1 deden, dus het eerste
      scherm openen. Zet je Classic aan terwijl er een rooster openstaat, dan spring je naar het
      eerste scherm van die kamer.
- [ ] **Compact mode** met een rooster open: de tegels schuiven in minder kolommen en je kunt
      scrollen.
- 📌 Het plaatje in de kop van het Me-rooster is de zandloper van This Week. Wil je daar liever een
  ander plaatje, zeg het.

## 🆕 12 sep — 4.0.0 stap 1: de schermkop met icoon, en de knop "Klassiek"

⚠️ **Eerst WoW HELEMAAL afsluiten en opnieuw starten**: er zijn 56 nieuwe plaatjes, en die ziet het
spel pas na een volledige herstart, niet na `/reload`.
- [x] **Open MH.** Boven elk scherm staat nu een donkerblauwe strook: links het icoon van dat scherm,
      rechts één regel over waar het scherm voor is. ✅ **Rob, 12 sep (screenshot Events):** het werkt;
      *"er valt niets weg, en de classic knop werkt"*.
- [ ] 🆕 **Goudrandje rond het icoon** (Robs keuze: *"vierkant met een goud randje"*): na `/reload`
      staat er een dun gouden kader om het plaatje in de kop, en de harde rand van het blauwe vlak
      valt weg.
- [ ] **Klik de schermen langs**, ook de vier in Toolbox (Consumables, Macros, Academy, Professions):
      elk scherm hoort zijn eigen icoon en zijn eigen regel te krijgen. Staat er ergens het icoon van
      Home of een lege regel, zeg welk scherm.
- [ ] **Past alles nog?** Door de strook is er ~64 px minder ruimte. Kijk vooral bij **Settings**, de
      **Tools-kaarten** (Pop-outs) en **Codex**: valt er onderaan iets weg dat eerst wel paste?
- [ ] **De knop terug:** Esc → Options → AddOns → Midnight Helper → *Venster & weergave* →
      **Classic look (no screen header)** aan. De strook verdwijnt en alles staat weer precies zoals in
      3.11.1. Weer uit: de strook komt terug. Na `/reload` blijft je keuze staan.
- [ ] **Compact mode** aan en uit met de strook zichtbaar: de strook wordt iets lager (54 px) en
      schuift mee met de smallere zijbalk.
- [ ] **Info-laatje (ⓘ) bij Mounts, Trading Post en Raids:** daar stond de uitleg van Home. Nu hoort
      de eigen ondertitel van dat scherm er te staan.
- 📌 De regels zijn in het Engels en Nederlands. In het Duits, Frans, Spaans, Portugees en Italiaans
  staan ze voorlopig in het Engels; de vertaling is de volgende stap. Jouw client is Engels, dus
  daar zie je dat niet.

## ✅ 12 sep — `/mh texturetest`: de eerste meting voor de 4.0.0-look (Spec 37 §5)

GEMETEN door Rob op 12 sep, na een volledige herstart; alle vier zichtbaar (screenshot):
- [x] **PNG 128×128** (het MH-schild): zichtbaar. PNG uit `Media/` werkt.
- [x] **PNG 144×144**: zichtbaar. **De 2-machtsregel geldt niet meer op 12.1**; elke maat kan.
- [x] **TGA 629×342** (Platynator-screenshot): zichtbaar. De Platy-plaatjes zijn dus niet kapot.
- [x] **Blizzard-icoon** (vraagteken, de controle): zichtbaar, dus het venster zelf werkt.

## 🆕 12 sep — Twee hotfix-feiten van Blizzard (10 sep) in de tips

- [ ] **Raid coach → The Venomous Abyss → The Lost Explorers:** de laatste regel luidt *"Mor'zahi:
      interrupt Final Ascension whenever you can — since the 10 Sep hotfix that resets his rising
      damage."*
- [ ] **Delve Coach → Twilight Crypts → Route:** de tweede regel noemt *Explorer's League Supplies*
      en een *Abandoned Restoration Stone* in *Loosed Loa*. Wat die doen, staat nergens. Kom je ze
      tegen, vertel dan wat ze doen, dan zet ik dat erbij.

## 🆕 12 sep — Routes naar Slayer's Rise en andere subzones (A + B + C)

De planner vraagt nu net als de reis-popup aan het spel in welke zone een kaart ligt.
- [x] **In Silvermoon, route naar *Vial of Voidstorm Oddities*** (Slayer's Rise): de pijl gaat naar
      **Portal to Voidstorm**, niet naar *Flight master: Sanctum of Light*. Pijl en popup zeggen nu
      hetzelfde. ✅ Rob, 12 sep: *"de vial in voidstorm werkte nu perfect"*.
- [x] **Door die portal:** in Voidstorm wijst de pijl naar de schat, en er komt **geen** *"You are at
      Portal to Silvermoon"* meer. ✅ Zelfde run.
- [ ] **Dezelfde fix, andere submaps** (GEMETEN 12 sep in Blizzards UiMap-data: 10 van de 20
      Midnight-kaarten in MH zijn submaps). Vanuit Silvermoon een route naar een **rare in Val of
      Naigtal** (Voidstorm, 10 rares elk) en naar een **Zul'Aman-schat in Atal'Aman** (*Measured
      Ladle*): de pijl gaat naar de juiste portal, niet naar een vliegpunt of Orgrimmar.
- [ ] **Vanuit Slayer's Rise of Voidstorm een Harandar-schat** (*Vial of Rootlands Oddities*):
      **geen "head for Orgrimmar"** meer, maar de Portal to Harandar.
      ⚠️ Staat er nog *"(other continent — travel back)"* vóór, dan heeft Slayer's Rise vermoedelijk
      een eigen continent-nummer. Dat meet `/mh zone` hieronder; de instructie zelf hoort te kloppen.
- [ ] 📌 **Binnen Voidstorm** kan de pijl je nog naar het vliegpunt *Master's Perch* sturen. Dat is
      bestaand gedrag, net als in de Vaults. Zeg het als je dat daar niet wilt.
- [ ] **`/mh zone`** in Slayer's Rise, elders in Voidstorm en in Harandar: `uiMapID`, `parent` en
      `continent`.
- [ ] **Quel'Danas-portal (niet ingebouwd):** alleen MapNotes noemt een portal in Voidstorm bij
      **45.4, 63.8** naar Isle of Quel'Danas. Staat daar echt een portal? Dan voeg ik hem toe.
- [ ] *(Optioneel, alleen zonder TomTom)* **Generate Route Treasures**: na het looten schuift de pijl
      door naar de volgende schat. Voorheen bleef hij op de eerste staan.

## 🆕 11 sep — Fout bij een route vragen in combat (Hearthstone-knop)

Rob kreeg `ADDON_ACTION_BLOCKED … MidnightHelperHSClick:ClearAllPoints()` toen hij een alchemy-route
vroeg (Profession → `AddSmartTomTomWay`). Die knop is beveiligd en mag in combat niet bewegen.
- [x] **Vraag in combat een route aan** (bijvoorbeeld een beroepsschat): **geen foutmelding**, en de
      TomTom-pijl staat gewoon op het doel. De reis-popup met portal/Hearthstone blijft in combat weg.
      ✅ **Rob, 12 sep (vóór 3.11.1):** *"stap 1, geen foutmelding gezien, stap 2 reload gedaan en geen
      foutmeldingen"*.
- [ ] **Buiten combat**, voor een doel in een ander gebied: de reis-popup verschijnt zoals altijd.
      ⚠️ Een route die je in combat vroeg, krijgt die popup niet vanzelf. Klik na het gevecht nog
      een keer.

## 🆕 11 sep — Replicating Venomborne in de Delve Coach (Grudge Pit + Darkway)

Rob stond in de Grudge Pit tegenover een baas die de coach niet kende. MH had hem al vier keer
gelogd in The Darkway, zonder dat de coach er iets mee deed.
- [ ] **Volgende *Fungal Pharmacon* (Grudge Pit) of *Eggsplosive Growth* (Darkway):** de coach noemt
      de story en *"Replicating Venomborne"* als eindbaas. Onder **Boss** staat de regel over
      Serpentogenesis, Venom Splash en Hydra Strike.
- [x] ~~Het 3D-model in de bossplek~~, **Rob 11 sep, vlak na zijn kill: "het model staat er en
      klopt".** Het Wowhead-id 269179 is daarmee met eigen ogen bevestigd.
- [x] ~~Spell-links in de coach, geen "?"~~, **Rob 11 sep, drie screenshots (The Darkway, 2/2):**
      de hover-tooltips tonen Venom Splash **1303316** (*"The glob forms into a Venomborne"*),
      Hydra Strike **1289224** en Serpentogenesis **1311500**, met CDPulse-ID's. De client kent alle
      drie. ⚠️ Dat bewijst dat de links werken, niet dat de baas precies deze ID's cast. Dat meet de
      volgende regel.
- [ ] **Volgende Venomborne-run, de debuff-tooltips** (CDPulse toont de Spell ID). De spell-ID's
      zijn gekozen op tooltiptekst, niet via een koppeling aan de NPC. Dit meet het:
      - Hydra Strike-DOT hoort **1289223** te zijn.
      - Sta je in zijn gifplas, dan hoort de vertraging **1303318** (30%) te zijn. Zie je **1289620**
        (60%), dan is het de andere Venom Splash-familie en klopt onze keuze niet.
- [ ] **Na de kill** staat er niet meer *"(Optional) Exit Delve with Leave-O-Bot…"* als story.
- [ ] **Zolang de story onbekend is,** tonen Route, Trash en Boss álle regels, niet alleen die van de
      laatst bekeken baas (in je screenshot stond onder Route alleen de Mycomight-regel).
- [x] ~~**Darkway met Gulkat**: alle oude tips staan er nog~~, **Rob 11 sep, coach buiten de delve,
      ◀ ▶ door The Darkway: "alles staat er, bij zowel 1/2 als 2/2".** Het filter per baas gooit
      niets van Gulkat weg, en 2/2 toont Venomborne met zijn regel.

## 🆕 11 sep — Liadrin-logboek (meetfase, de vinkjes veranderen nog niet)

- [x] ~~Na een `/reload`: `/mh weeklies`~~, **Rob 11 sep (hunter): "last login Fri 16:55: 0 turn-in
      event(s) ignored in the first 10s", "0 quest(s) handed in since the reset".** Eén meetpunt: bij
      deze reload kwamen er geen valse meldingen. ⚠️ Dat bewijst niet dat ze nooit komen; misschien
      alleen bij de eerste login van een nieuwe week. En het logboek telt pas vanaf 11 sep, dus
      inleveringen van eerder deze week kent het niet.
      📌 **Dat getal is een meting op zich.** Is het groter dan 0, dan stuurt het spel bij het
      inloggen echt valse inlever-meldingen, zoals Midnight Chores beweert. Is het 0, dan (nog) niet.
- [x] ~~Lever een weekly in en doe `/mh weeklies`~~, **Rob 11 sep:** *"halduron handed in Fri 17:27"*,
      *"vereesa handed in Fri 17:27"*, 2 quests. Rob bevestigt: twee verschillende NPC's. **GEMETEN
      in het bestand** (17:30): het was **Redisch (Lv90)**, niet Twelveinchy. Halduron **93756** (om
      17:27:22), Vereesa **98172** (om 17:27:45).
- [ ] **Nog open:** geeft Halduron onder level 90 echt 95468 *"Hope in the Darkest Corners"*? Dat is
      te meten als Twelveinchy een weekly bij hem inlevert.
- [ ] 🔴 **DE BELANGRIJKSTE: woensdag 16 sep, resetochtend, VÓÓR je iets doet: `/mh weeklies`.**
      Staan Liadrins quests weer op *"completed"* terwijl het blok *"nothing handed in … since the
      reset"* zegt, dan klopt het: die vlaggen resetten nooit, en dan schakel ik de vinkjes over op
      het logboek.

## 🆕 11 sep — Edit Mode-backups: geen kopie meer als er niets veranderd is

- [x] ~~`/mh editmode` zegt "unchanged"~~, Rob 11 sep. ⚠️ **Dat bewees te weinig:** het vergeleek
      twee kopieën uit dezelfde sessie. In het bestand bleek dat elke login tóch een kopie bijzette,
      doordat getallen afgerond in de SavedVariables staan. Gerepareerd met een marge van 0,01.
- [x] ~~Twee keer `/reload`, en ik meet het bestand~~, **GEMETEN 11 sep 13:22 (na het uitloggen):**
      nog **2** backups. #1 is van 13:01, en daarna is er geen kopie meer bijgekomen. #2 is de oude set
      met *"Bell 1080"*, *"MH V1.0"* en *"MH Hunter BM"*. Het bestand is 0,64 MB (vanochtend 4,05).
- [ ] **Verander iets kleins in Edit Mode**, bijvoorbeeld een balk een stukje verschuiven, en doe
      `/reload`. Dan hoort er wél een nieuwe backup bij te komen, en blijft die van vóór je wijziging
      staan.

## 🆕 11 sep — `/mh cleanup`

- [x] ~~`/mh cleanup` toont een lijst met meetdumps en hun grootte~~, **Rob 11 sep: 38 dumps,
      about 248 KB, met de "Kept on purpose"-regel.**
- [x] ~~`/mh cleanup yes`, tweede ronde~~, **Rob 11 sep:** *"Cleared 1 dump(s) … turned off: kicks
      probe"*, en na `/reload`: *"No measurement dumps …, and no recorder left on."* Het bestand is
      nagemeten: `ejCapture`, de instellingen en het accountoverzicht zijn er nog.
- [ ] **`/mh commands`** (of het Commands-scherm): `/mh cleanup` staat in de groep met de
      meetcommando's.

## 🆕 11 sep — Trovehunter's Bounty: MH kijkt nu naar de Season 2-kaart

✅ Gemeten door Rob (`/mh item 274374 252415`): 274374 is de Season 2-kaart, 252415 die van
Season 1. MH keek tot nu toe alleen naar de oude.
- [x] ~~`/mh finditem trovehunter`~~, **Rob 11 sep: "Trovehunter's Bounty id 274374"** in zijn tas.
- [x] ~~`/mh spell 1293799 1254631`~~, **Rob 11 sep: allebei "Trovehunter's Bounty".**
- [x] ~~De delve-popup toont de kaart~~, **Rob 11 sep: "Delve items" met Radar en "Bounty ×1".**
- [x] ~~Mag de kaart buiten een delve?~~ **Ja — Robs tooltip-screenshot 11 sep: "Use: At any time",
      trove aan het eind van je volgende delve vanaf Tier 4, inhoud hangt af van die tier.** De
      "actief"-regel zei "active in delve"; die zegt nu in 7 talen *"active — Hidden Trove after
      your next Tier 4+ delve"*.
- [x] ~~Welke buff geeft de S2-kaart?~~ **Rob 11 sep, buff-tooltip na gebruik: "Spell ID: 1293799".**
      Config's hoofd-ID staat nu op 1293799 (1254631 blijft in de lijst).
- [x] ~~Toont MH het in de Account snapshot?~~ **Rob 11 sep, screenshot (Earthshammy, buiten een
      delve): "Trovehunter's Bounty (this character): active — Hidden Trove after your next Tier
      4+ delve", in groen.**
- [ ] **Nog alleen: in de delve, met de buff op.** Staat de popup-knop van de kaart op "actief"?
      (Eerder gezien: de popup verschijnt en toont "Bounty ×1".)
- [ ] **Account snapshot → This week:** de regel *Trovehunter's Bounty* klopt met je tas: *"map in
      bags"* als je hem hebt en nog niet gebruikt.

## 🆕 11 sep — Account snapshot, optie B punt 4 en 6 (Robs keuze)

Tabblad **Account snapshot**, na één `/reload`.

- [ ] **Levelende characters staan onder één regel** onder de rest: *"+ Leveling characters (n) —
      below level 90, the max level"*. Klik erop: ze klappen open (*"−"*), en nog een klik klapt ze
      weer in. Na `/reload` blijft je keuze staan. Met je muis erop zie je hun namen en levels.
      ⚠️ **Het criterium is "onder de max-level van het spel"**, niet dat uit de spec. Dat zou
      niemand inklappen, want je level-15 had op je screenshot gewoon "0/9". Dus ook je level 80 en
      82 staan in die groep. Is dat wat je wilt?
- [ ] **Je huidige character klapt nooit in**, ook niet als het aan het levelen is.
- [ ] **Onder de tabel staat een uitlegregel**: klokje = niet ingelogd sinds de reset, groen = klaar
      of op de cap, en dat de tooltips uitleggen.
- [ ] **Met je muis over een character** begint de tooltip met *"Still open this week:"*, met
      hooguit drie punten: een Vault-beloning om te kiezen, Catalyst charges vol, Shards tot de
      weekcap, de Vault-rij het dichtst bij een volgende keuze, keys om te gebruiken. Klopt het met
      wat je van dat character weet?
- [ ] **De kolomkoppen** leggen nu uit wat het is, **Why** het ertoe doet en **Resets** wanneer het
      reset. Het muntje en het kristal gebruiken dezelfde uitleg als het tabblad Currencies.

## 🆕 11 sep — Currencies: het blok "Your characters" (Spec 39)

Tabblad **Currencies** (zijbalk, onder Resources), na één `/reload`. ⚠️ **Alleen als WoW mag**: niet
zolang ComfyUI de videokaart gebruikt.

- [x] ~~Eerst `/mh curscan`, dan `/reload`~~, **GEMETEN 11 sep 14:58 op Twelveinchy (Lv80)**, uit het
      bestand gelezen. De uitkomst staat in `docs/NEXT_SESSION.md`. Het blok is erop aangepast: de
      crest-rij kent nu ook een gewone cap, en de tooltip zegt welke currencies je tussen je
      characters kunt verplaatsen.
- [x] ~~Op een max-level character nog één keer `/mh curscan`~~, **Rob 11 sep, 5 screenshots.** Mana
      Crystals hebben daar een weekcap van 250, de crest-vlag gaat aan zodra er iets verdiend is, en
      Field Accolade heeft ook daar geen weekcap. Details in `docs/NEXT_SESSION.md`.
- [x] ~~Twee kolommen "You" en "Total"~~, **Rob 11 sep, screenshot:** de kopjes *You · Total · What to
      do with it*, de hint *"You = this character · Total = all your characters added up"*, en
      bijvoorbeeld Shards *201 · 914*, Marl *23982 · 92419*.
- [ ] **De tooltip van Voidlight Marl noemt het verplaatsen nog maar één keer**: *"You can move this
      between your characters in Blizzard's currency window."*
- [x] ✅ **Rob 11 sep, screenshot:** het blok staat er, met negen rijen, iconen, de clientnamen, de
      totalen (onder andere Coffer Key 27, Shards 914, Undercoin 7374, Marl 92419) en de uitlegregels
      (afgekapt met "…"; de hele zin staat in de tooltip). Geen oranje regels. Nog te zien: de tooltips.
- [ ] ~~Bovenaan het tabblad staat een blok "Your characters"~~ (zie hierboven) met negen rijen: Restored Coffer Key,
      Coffer Key Shards, Venomblight Manaflux, Undercoin, Mana Crystals, Corrosive Coin, Voidlight
      Marl, Field Accolade en Crests. Per rij zie je het icoon, de naam zoals WoW hem noemt, het
      totaal over al je characters, en één regel die zegt wat je ermee kunt of moet doen.
- [ ] **Oranje regel = er gaat iets verloren als je niets doet**, bijvoorbeeld *"Full on
      Earthshammy-Khadgar — nothing more comes in there until you spend some"* bij Manaflux 8/8.
      Klopt dat met wat jij weet van die characters?
- [ ] **Ga met je muis over een rij**: je ziet elk character met zijn aantal, jijzelf in geel, en een
      klokje bij characters die sinds de reset niet ingelogd zijn. Een character dat sinds vandaag
      nog niet is ingelogd, staat er als *"not seen yet — log in once"*, niet als 0.
- [ ] **De rij Crests**: in de tooltip de vijf tiers, met per tier het totaal en wie de meeste heeft.
- [ ] **Het "−"-knopje** klapt het blok in; de gids eronder krijgt dan de ruimte terug. Na `/reload`
      blijft het ingeklapt.
- [ ] **In de gids eronder, bij Field Accolade**, staat nu *"Season 2: Veteran gear, 500 random or 750
      for a slot you choose"* in plaats van de oude *"Champion 75 / Hero 500"*. Klopt dat met wat
      Maren Silverwing je aanbiedt?
- [ ] **Hoe heet de crest-upgrader in de Bazaar echt?** MH schrijft *Cuzoth*, Wowhead *Cuzolth*.
      Lees het van zijn naambord.

## ✅ 10 sep avond — Account snapshot, Spec 38 §3 + optie A (nieuwe kolommen) — Rob: alles goed

Rob, na de tweede ronde: *"Verder zijn alle punten goed afgewerkt."* Vault blijft "0/9" bij een
relog-rij, geen streepje.

- [x] ~~Blok *This week*: de laatste regel plakt niet meer tegen de regel erboven~~, **Rob 10 sep:
      "ziet er goed uit"**.
- [ ] **Open, 11 sep eerst:** *"Sort: Shards"* sorteert niet goed (Rob). Wat hij precies zag staat
      nog niet vast; zie bovenaan `docs/NEXT_SESSION.md`.

Tabblad *Account snapshot*, na één `/reload`. §3 en optie A zitten in één ronde, dus je ziet
meteen de nieuwe indeling. Van links naar rechts: **naam · Vault · Keys · Shards · Week ·
[muntje] · [kristal]**.

- [ ] **Niets loopt meer door elkaar**, ook niet aan het eind van de rij. Alle getallen staan op één
      regel, en de rijen zijn iets hoger (20 px in plaats van 17).
      ⚠️ Is iets te breed voor zijn kolom, dan wordt het **afgekapt** in plaats van dat het over twee
      regels loopt. Zie je ergens een afgekapt getal, zeg dan welke kolom en welke taal.
- [ ] **Geen beroepen meer in de rij.** Die staan nog wel in de tooltip als je over een naam gaat.
- [ ] **Vault toont nu "1/9"**: alle drie de rijen bij elkaar opgeteld. *CLAIM!* en *LIKELY* staan
      er nog, net als het pulseren op resetdag. Met de muis op de kop **Vault** lees je wat het getal is.
- [ ] **Shards en Week zijn twee kolommen.** Shards is je wallet, Week is bijvoorbeeld "354/600".
      Op de cap staat **"600/600" met een groen vinkje**. Een character dat sinds de reset niet
      ingelogd is, toont **"—"** bij Week.
- [ ] **De laatste twee koppen zijn icoontjes**: het Undercoin-muntje en het Mana Crystal-kristal.
      Met de muis erop zie je de **naam van de currency** zoals WoW hem noemt. Klikken op het muntje
      sorteert op Undercoins, net als vroeger de kop "Under / Mana".
- [ ] **Het ×-knopje verschijnt pas als je met de muis over een rij gaat.** Het werkt nog steeds
      hetzelfde: een bevestigingsvraag, en je eigen character kun je niet verwijderen.
- [ ] **Relog-rijen:** grijs, met een **klokje** achter de naam in plaats van het oranje "(relog)".
      Ga je erover, dan staat bovenaan de tooltip waarom en wat je moet doen.
- [ ] **Namen worden per teken afgekapt**, dus niet meer midden in een ü.
- [x] ~~De tooltip van een relog-rij noemt eerst waarom en wat je moet doen~~, **Rob 10 sep: klopt**
      (Warlockie).
- [ ] **Tweede ronde, na Robs screenshot:** level en ilvl staan in een **eigen kolom "Lv · ilvl"**
      tussen de naam en Vault, bijvoorbeeld "90 · 269" in lichtblauw. *Purlymixanox-Bloodhoof* wordt
      nu hooguit in de naam afgekapt, nooit meer in de getallen. Klik op de kop om op level te
      sorteren.
- [ ] **De tooltip van een relog-rij zegt het maar één keer**: het gele zinnetje onder Shards
      ("Weekly count not updated…") is weg.

## 🆕 10 sep avond — nieuwe macro's in de Macros-tab (Spec 33 + Hunter's Mark)

Rob: *"dat soort macro's moet bij ons in de macro set komen"*. De Macros-tab toont macro's voor de
spec waarin je nu zit, dus kijk per personage.

- [ ] **Hunter, Beast Mastery** (Redisch): bovenaan **Kill Command + Pet Attack**, precies de
      "method"-macro die je al gebruikt. Daarnaast nieuw: **Mouseover Barbed Shot**, **Cursor Traps**
      en **Mouseover Hunter's Mark**.
- [ ] **Hunter, Marksmanship**: nieuw **Cursor Traps**, **Mouseover Hunter's Mark** en *Shot without
      breaking Rapid Fire*. ⚠️ **Rob heeft geen Watchmenow meer.** Die naam kwam uit een oude
      `WTF`-map, en zo'n map blijft staan als een personage weg is. Zet dus **Redisch op
      Marksmanship** en doe daar `/mh macrocheck`.
- [ ] **Mouseover Hunter's Mark doen:** muis op een tweede vijand, druk. Het teken hoort op die vijand
      te komen terwijl je doel blijft wie het was.
- [ ] **Druid, Guardian:** nieuw **Mouseover Growl**.
- [ ] **Priest, Shadow:** drie nieuwe, die Void Torrent niet afbreken: *Madness*, *Voidform* en
      *Mind Blast without breaking Void Torrent*. ⚠️ Alleen gecontroleerd tegen onze spelldata,
      niet gespeeld.
- [ ] **Pet-macro met Hunter's Mark** (Redisch, BM). Kopieer *Kill Command + Pet Attack* opnieuw, want
      hij is veranderd. **Buiten gevecht:** doel een vijand en druk; Hunter's Mark hoort erop te komen.
      **In gevecht** hoort hij alleen nog Kill Command en je pet te doen. Doet de eerste druk alléén het
      teken, dan deelt Hunter's Mark de global cooldown. Meld het, dan weten we dat ook.
- [ ] **Marksmanship: *Shot without breaking Rapid Fire*.** Drukken tijdens Rapid Fire hoort niets te
      doen; de channel loopt gewoon door.
- [ ] **Zoeken:** typ `pet`, `trap` of `mouseover`. Je hoort de macro zelf te vinden, en klikken hoort
      de Macros-tab te openen **op die macro**, niet op de eerste.
- [ ] **`/mh macros`** opent de Macros-tab, en in de Tools-zaal staat een kaart *Macros*.
- [ ] **`/mh macrocheck`** op elke klasse die je langsloopt. Bovenaan staat een controleregel met je
      interrupt; die hoort **known** te zeggen. Stuur de regels met **not found**, vooral bij Warrior
      (*Spear of Bastion*), Paladin (*Final Reckoning*), Priest (*Shadow Crash*), Shaman (*Windfury
      Totem*), Warlock (*Guillotine*), Monk (de standbeelden) en Evoker (*Rescue*).
  - ✅ **Hunter BM (Redisch), 10 sep.** De controle *Counter Shot* staat op known, dus de meting werkt.
    Alles is known, behalve:
    - **Misdirection: not found** (in *Smart Misdirection*)
    - Bite en Smack: dat zijn pet-aanvallen, en zijn pet gebruikt Claw, dat wél known is. Zo hoort het.

    ⚠️ Onze `KeybindRoles_Hunter.lua` noemt Misdirection *baseline*, maar de client zegt dat dit
    personage hem niet kent. Is het een talent dat Rob niet gekozen heeft, of is hij weg in 12.1?
    **Rob gevraagd.**
  - ✅ **Hunter MM (Redisch op Marksmanship), 10 sep.** De controle staat op known. Volley, Freezing
    Trap, Hunter's Mark en Aimed Shot (uit de Rapid Fire-macro) zijn known, **alleen Misdirection is
    weer not found**.
    📌 Verklaring (online, murlok.io): Misdirection is in Midnight een **talent in de class-boom**, en
    die boom delen alle drie de specs. Dat past bij "in twee specs weg". De uitleg van *Smart
    Misdirection* zegt het nu. Rob kan het zelf nakijken: talenten (N), dan de class-boom.
    ✅ **Nagekeken door Rob:** zijn talentboom toont Misdirection als node, *Rank 0/1*, Spell ID
    34477. Het is dus een class-talent dat hij niet gekozen had.
- [ ] **Na de online-ronde (10 sep): drie macro's vervangen, check ze op je eigen klassen.** Rob heeft
      geen Warrior, Monk of Evoker, dus die rusten op bronnen. Doe `/mh macrocheck` in deze specs:
      - **Paladin, Retribution:** *Mouseover Execution Sentence* vervangt *Cursor Execution*, want
        Final Reckoning bestaat niet meer. Mijn voorspelling was **known**, en die was fout.
        ✅ **GEMETEN 10 sep:** de controle *Rebuke* staat op known, Divine Shield is known, maar
        **Execution Sentence is not found**. Het is een talent in de Retribution-boom (Maxroll 12.1,
        Zygors Ret-build), hetzelfde patroon als Misdirection. De uitleg van de macro zegt dat nu. Rob kan
        het zelf nakijken: talenten (N), de spec-boom.
        ⚠️ **Rob: "deze is lvl 80".** Het talent kan dus ook nog buiten bereik liggen, in plaats van
        niet gekozen. Macrocheck ziet dat verschil niet; de onderste regel zegt dat nu ook.
      - **Priest, Shadow:** *Mouseover Tentacle Slam* vervangt *Cursor Shadow Crash*, en hoort **known**
        te zeggen. De drie Void Torrent-macro's zeggen nu dat Void Torrent alleen bij **Voidweaver**
        bestaat.
      - **Shaman, Enhancement:** *Cursor Totems* gebruikt **Windfury Totem**. Die vond ik niet terug in
        de gidsen voor 12.1. Zegt macrocheck **not found**, meld het dan.
      - **Warlock, Demonology:** *Cursor Guillotine*. Bestaat volgens de bronnen nog (Wowhead 12.1),
        meestal als talent.

## 🆕 10 sep avond — Dundun-macro met een maan

- [x] ✅ **GEZIEN 10 sep avond, Rob: *"hij werkt goed"*.** De Find Dundun-macro zet nu ook een 🌙
      maan boven hem. De ping verdwijnt na een tijdje;
      de game bepaalt dat en er is geen instelling voor. Een raid-teken blijft staan.
      ⚠️ **Je bestaande macro verandert niet vanzelf.** Macros-tab → *World* → de nieuwe tekst over je
      oude macro heen zetten. Hij eindigt nu op `/tm 0` en `/tm 5`.
      **Test in de volgende Bountiful delve:** komt de maan boven Dundun te staan, zie je hem van een
      afstand, en blijft hij staan als je de macro twee keer drukt? Niet gemeten zijn: of het werkt
      met alleen Valeera in je groep, en of het teken zichtbaar is op een vermomd voorwerp.
- [x] ✅ **Grondmarkeringen werken in een delve met alleen Valeera. GEMETEN 10 sep:** Rob typte
      `/wm [@cursor] 7` en de maan lag er. Volgens de wiki kan het alleen in een groep; een delve telt
      dus als groep.
- [x] ❌ ***Moon on the ground*: getest en weer weggehaald (10 sep).** Met `[@cursor]` komt de maan
      waar je muis staat (*"dat is niet handig"*). Met `[@target]` en `[@player]` vraagt de game nog
      steeds om een klik op de grond. Rob: *"vergeet die world marker"*. Alleen Find Dundun met de maan
      boven zijn hoofd blijft. 📌 **Verwijder je eigen *Moon on the ground*-macro zelf** via `/macro`.

## 🆕 10 sep middag — na de test: vier kleine dingen

- [x] ✅ **Kaartsoorten: GEZIEN.** [Event] voor Oppose the Foes en Turn the Surge, [Pet battle] voor
      de Safari, [Mixing] voor Mix Master. (Rob vroeg *"deze dingen staan onder Rare kopjes, klopt
      dat??"*, en het antwoord was nee.)
- [x] ✅ **Mix Master: GEZIEN, 10 sep.** Hover boven *Choleric Offering*: de voorwaarden staan onder
      de notitie, en daaronder in groen *"Your Renown with Zul'jarra's Forces: 8 (needs 3)"*, live
      gelezen. Robs eerste voorwaarde is dus binnen. Doet de ketel niets, dan is het de altar-node of
      het ontbreken van ingrediënten. Hieronder de oorspronkelijke tekst:
- 🔁 **Mix Master: waarom er niets te doen is. OPNIEUW, nu met een instructie die kán.**
      Mijn eerste instructie (*"klik een Waypoint bij een offering"*) was niet uit te voeren. De tien
      offerings hebben geen eigen Waypoint-knop; ze delen er één in de kop, en die opent geen popup.
      Rob hield de muis boven *Eerie Offering* en kreeg de notitie en het recept, maar niet de
      voorwaarden, want die stonden alleen in de popup. **Nu staan ze ook in het muis-vakje.**
      Dus: `/reload` en **de muis boven een offering**. Tussen de uitleg en *"Needs: …"* hoort in
      oranje te staan: Renown 3 bij Zul'jarra's Forces plus de node Ofi's Offerings op de Altar of
      Corrosion. Daaronder komt *"Your Renown with …: N (needs 3)"*, groen of rood. ⚠️ De altar-node
      kan de addon niet lezen.
- [x] ✅ **Ketel-waypoint: GEZIEN**, *"The cauldron at Tokka's Landing — 1m away"* (was 20 m).
- [x] ✅ **Deck-iconen: GEZIEN.** Rob: *"Ik vind ze er supergaaf uitzien. En mijn zusje Carola vindt
      ze ook mooi."*

## ✅ 10 sep — Curse Surges: GETEST en gezien (Rob, middag)

Rob koos *"doe maar allebei"*: A (achievement-kaart) én B (uit de rares-lijst).

- [x] ✅ **Rares-tab, Coiled Isle**: *"0/12 done this week"*, Ori'kassi en de Leviathan weg.
- [x] ✅ **Kaart Turn the Surge**: vijf rijen met *(Elite)*, een grijze **No route** en vijf
      Waypoints. Hij staat op **2/5** (Leviathan en Ori'kassi afgevinkt), dus criteria 111353 en 115371
      zijn nu ook in het spel bevestigd.
- [x] ✅ **Waypoint-popup**: titel *Looming Mutagenitor*, de uitleg, een knop met de baasnaam en de
      pijl erheen.
- [x] ✅ **Tegenproef Mix Master**: titel *Balanced Offering* (niet "Treasure"), een knop *"The
      cauldron at Tokka's Landing"* en de pijl liep erheen. **De bug van vanochtend is echt weg.**
- [x] ✅ **Zoek `kassi`**: de popup, plus de TomTom-waypoint *"Venom Lancer Ori'kassi - 67.16, 77.52"*.
- 💸 De prijs blijft: geen *"rare nearby"*-melding voor deze twee.

**De metingen:**

- [x] 🔎 **`/mh rarequests`**:
  - Ori'kassi: **A 96969 done / B 93722 --**
  - Leviathan: **A 96970 done / B 93673 --**

  Een surge-kill zet dus de account-vlag (A), niet die van het personage (B). ✅ Gemeten op
  **Earthshammy**, het personage dat de surge de avond ervoor deed (Rob bevestigde het).
- [ ] 🔎 **`/mh atal`, gedraaid 10 sep rond 12:03: GEEN surge-POI.** Op 2512 stond precies één
      area-POI: 8927 *Special Assignment: Wraith Wrath*. Dat is de positieve controle: de probe leest
      die kaart wél. Er stond geen surge tussen, niet 8887–8891 (Zygor) en niet 8936–8940
      (HandyNotes). Twee lezingen blijven over: er liep er toen geen, of een surge is geen area-POI.
      **Volgende keer: `/mh atal` terwijl je een surge-icoon op je kaart ZIET.** Tot dan blijft C dicht.
- [ ] **Hoe vaak ze wisselen.** HandyNotes zegt 45 minuten, een forumdraad ~20. Nog ongemeten.

## 🆕 9 sep — vóór de volgende release: vier dingen die niemand op een scherm gezien heeft

Rob vroeg op resetdag: *"is er niets meer echt open voor deze release?"* Dit is het gemeten
antwoord. **Niets hiervan is fout of onwaar** — het is alles wat gebouwd is en nog nooit
gerenderd. Bouwen is niet testen.

- [x] ✅ **DE ZOEK-FIX (9 sep) — beroepsgids GEZIEN EN GOED.** Rob 9 sep: *"1 en 2 kloppen nu ... en
      punt 4 is goed"*. Zoeken op `azeroot` landt op stap 1, `umbral tin` op Mining, en `/mh
      profguide` opent nog steeds gewoon op je eigen stap. Geen regressie.
- [x] ✅ **De Catalyst-vraag — GEMETEN 9 sep, onze claim klopt.** Robs tooltip: *"Total Maximum: 1/8"*,
      **All Characters: 19**, uitgesplitst per personage (2, 2, 2, 2 en 1). Verschillende getallen per
      character ⇒ **per character, cap 8**. Meerdere webgidsen zeiden account-wide en zaten ernaast.
- [x] ✅ **Valeera-tip: de machinerie is bewezen (9 sep).** `/mh curiodebug` gaf `resolved role: tank`,
      `node 110818 taken= true`, `heal tip: silent — your role is dps, not healer`. **Twee van de drie
      voorwaarden waren écht waar**, dus de node- en rol-lezing zijn allebei positief bevestigd.
- [x] ✅ **De kop van This Week feliciteert niet meer over een halve week — GEMETEN 9 sep.** Robs
      scherm: *"Nothing left to pick up — but 5 weekly things are still unfinished. They are in the
      list below."* boven *"8 of 13"*, en de **5** komt overeen met zijn vijf genummerde regels.
- [x] ✅ **De kist-hint op de rare-toast — GEMETEN 9 sep, met zijn eigen controle erin.** Farthik gaf
      *"(open the chest to summon him)"*, Coin-Eye Skully *"(roams — look around)"*. **Twee
      verschillende hints op twee rares** is precies de tegenproef die als aparte stap op deze lijst
      stond: een vastgeplakte tekst had twee keer hetzelfde getoond. Kaarten groeiden mee.
      📌 `/mh raretest <naam>` werkt dus ook — gebouwd omdat rares weekly zijn en Rob Farthik net
      gedood had.
- [ ] ⚠️ **Kleinigheid, alleen kijken als je hem toch tegenkomt:** op Coin-Eye Skully's kaart bleef
      de modelplek **leeg**, terwijl Farthik zijn portret kreeg. Zijn npcID (257906) staat wél in de
      data, dus dit is waarschijnlijk gewoon een model dat nog niet geladen was. **Niet gemeten**, en
      het raakt de hint niet. Zie je het vaker, dan is het een echt puntje.
- [x] ✅ **De giver-waarneming: keten bewezen, en de grens ervan gemeten (9 sep).** Bankier gaf
      `npc=Ceera  giver=not matched` — event vuurt, naam leesbaar, terecht niet als giver gezien.
      Liadrin daarna aanklikken liet het spoor op Ceera staan: **een NPC zonder aanbod opent geen
      gesprekvenster.** Dus *"had iets"* is te zien, *"had niets"* niet.
- [x] ✅ **De acht scherm-toetsen — GEMETEN 9 sep, werkt.** Rob: *"ja en het werkt"*.
- [x] ✅ **De acht icoontjes — GEZIEN 9 sep, werken op de deck.** (Rob laadde ze als hernoemde SVG;
      zie hieronder waarom dat vervangen is.)
- [ ] 🆕 **Vervang de hernoemde SVG's door de ECHTE PNG's.** In `docs/streamdeck-icons/` staan nu
      `mh-*.png` naast `mh-*.svg` — 288×288, echt PNG. Laad die.
      🔴 **Waarom dit niet cosmetisch is:** een `.svg` die `.png` heet werkt alleen zolang je
      software naar de inhoud kijkt. Bij een update of op een andere machine kan dat stoppen, en dan
      lijkt er iets kapot terwijl het de bestandsnaam is.
      📌 Kijk meteen of de kleuren op de deck genoeg van elkaar verschillen; ik koos ze op een
      monitor, niet op jouw hardware. Lijken er twee te veel op elkaar, zeg welke.
- [ ] 🆕 **De shard-waarnemer (9 sep) — hij hoort de eerste keer NIETS te weten.**
      **`/reload`, dan meteen `/mh shards`.** Verwacht onderaan een gele regel: *"per pickup = 50
      still the wiki figure — no payout observed yet"*. ⚠️ **Dat is de goede uitkomst** — hij heeft
      nog niets gezien. Staat er meteen "MEASURED", dan telt hij iets mee wat geen uitbetaling was.
      **Dood daarna drie rares** (mag verspreid over de avond). Na de derde hoort er te staan:
      *"per pickup = 75 MEASURED in your game (3 of 3 payouts)"*, en *"nog ongeveer N rares"* rekent
      vanaf dan met 75 in plaats van 50.
      📌 **Zit je bijna aan de cap, dan hoort hij die uitbetaling over te slaan** en dat te melden
      (*"1 payout(s) ignored: they landed against the weekly cap"*). Dat is precies de valkuil die
      jouw eigen meting had kunnen bederven.
- [x] ✅ **Wat betaalt één rare op rank 10? GEMETEN 9 sep: 75, niet 50.** Verse character, 600
      weekruimte, niets anders geloot ertussen, rank 10 bevestigd. `quantity` 447→522 en
      `quantityEarnedThisWeek` 0→75 — beide tellers eens. 🔴 Het paneel zei *"about 11 rares"* waar
      het er **7** zijn. Zie `NEXT_SESSION.md`: de 50 blijft voorlopig staan, want 75 is alleen goed
      op rank 10 en zou een bekende fout inruilen voor een verborgen.
- [x] ✅ **Bijvangst: shards zijn PER CHARACTER, allebei de tellers.** Twee characters binnen een uur,
      niets uitgegeven: `quantity` 45 tegenover 447, `quantityEarnedThisWeek` 517 tegenover 0. De
      rank-10-bonus is accountbreed, de shards die hij oplevert niet — elke alt heeft zijn eigen 600.
- [ ] ~~Wat betaalt één rare op Delver's Journey rank 10?~~ (afgevinkt; instructie blijft als naslag) Onze code rekent met **50 per
      rare**, en dat is een **wiki-cijfer dat nooit in het spel gemeten is**. Rank 10 zegt dat alle
      bronnen meer uitbetalen, dus die 50 is nu verdacht.
      **Meting:** `/mh shards` → noteer `quantity` → **één rare doden** → `/mh shards` opnieuw.
      🔴 **DRIE DINGEN DIE DEZE METING STIL BEDERVEN** — de eerste instructie hier noemde er nul,
      en de eerste levert een getal op dat er écht uitziet:
      1. **De weekcap knipt de winst af.** Rob stond op 517/600 verdiend, dus 83 over. Betaalt de
         rare meer dan 83, dan meet je 83 en dat lijkt het tarief. **Kijk dus eerst naar
         `quantityEarnedThisWeek`** en meet alleen met genoeg ruimte.
      2. **Alleen die ene kill ertussen.** Chests, treasures en een afgemaakte delve betalen ook
         shards; anders meet je de som.
      3. **Noteer de Delver's Journey-rank van díé character** (Delves-tab). Rank 10 meet de
         verhoogde uitbetaling, lager meet de basis — allebei bruikbaar, maar we moeten later weten
         welke van de twee het was.
      ⚠️ De rank komt uit `C_MajorFactions`, een renown-track. Die zijn normaal accountbreed, maar
      dat is **afgeleid en niet gemeten** — de tab op die char zegt het zeker.
      📌 Klopt de 50 niet meer, dan is *"nog ongeveer N rares"* scheef voor precies de spelers die
      het verst zijn, en niemand meldt dat: je zit gewoon eerder aan je cap dan voorspeld.
- [ ] 🔴 **DE ECHTE METING STAAT VOLGENDE WEEK, en kost één commando.** Draai **vóór je iets doet**,
      na de reset: `/mh weeklies`. Kijk naar Liadrins dertien ID's.
      | uitkomst | conclusie |
      |---|---|
      | een paar staan op `-` | de vlaggen resetten wél; het scherm had toevallig gelijk |
      | alle dertien nog `completed` | 🔴 die vlaggen zijn structureel onbruikbaar voor "deze week" |
      📌 Dit is de enige meting die de openstaande vraag van vandaag beantwoordt. Eén regel, vóór je
      begint — daarna is hij een week lang niet meer te doen.
- [ ] 🆕 **De giver-waarneming (9 sep) — drie stappen, en stap 1 hoort NIETS te doen.**
      1. **`/reload`, dan meteen `/mh weeklies`.** Verwacht een nieuw blok *"What each giver actually
         offered when you last stood there"* met bij alle vier de givers **"not visited since this
         was built"**. ⚠️ Dat is de goede uitkomst: we hebben nog nergens gestaan. Staat er meteen
         een getal, dan schrijft hij iets op wat hij niet gemeten heeft.
      2. **Praat met Lady Liadrin** (gewoon aanklikken, niets aannemen), loop weg, `/mh weeklies`.
         Verwacht: *"nothing on offer this week"* met dag en tijd erachter — want jij zag vanmiddag
         dat ze niets had.
      3. **Praat met een giver die je wél iets te bieden heeft** — Halduron of Aethas, want die
         quests staan in je log, dus die hebben er nu niets. Dan liever **Vereesa**: ook al in je
         log. 📌 Kom je er deze week eentje tegen die wél iets aanbiedt, kijk dan of This Week hem
         op **"pick it up"** zet in plaats van "done". Dát is waar dit voor gebouwd is.
      ⚠️ **Werkt er iets niet: NPC's aanspreken mag nooit stukgaan.** De lezing zit in een `pcall`,
      dus als er iets fout is hoor je hooguit een lege regel te zien, geen foutmelding.
- [ ] ⚠️ **De ANDERE kant van diezelfde fix, nog ongetest.** Is je week wél helemaal af (13 van 13),
      dan hoort *"You're all caught up this week. Nice."* gewoon terug te komen. **Zonder die meting
      is alleen bewezen dat de nieuwe regel verschijnt, niet dat de oude nog kan verschijnen** — en
      een guard die de goede uitkomst per ongeluk uitsluit, ziet er van buiten identiek uit.
      📌 Geen werk: het valt vanzelf op zodra je een week afmaakt.
- [x] ✅ **Trailing Xal'atath — GEMETEN 9 sep, goed.** *"3. Weekly (Vereesa Windrunner): picked up —
      finish and turn it in."* Precies het verwachte geval, niet "pick it up next to the vault".
- [ ] ~~Trailing Xal'atath in de weeklijst~~ (afgevinkt; instructie blijft als naslag): Open **This Week**. Omdat je de
      quest al **in je log** hebt, hoort er te staan: *"Weekly (Vereesa Windrunner): picked up —
      finish and turn it in."* **Niet** "pick it up next to the vault" — dat was precies de bug bij
      Liadrin, waar de routine je een quest liet halen die je al had.
      ⚠️ **Tweede controle, ná het inleveren:** dan hoort dezelfde regel *"done this week"* te zeggen.
- [x] ✅ **Spec 35 — de twee scope-regels: GEMETEN 9 sep, goed.** Rob: *"de this week regels kloppen"*.
- [ ] ~~Spec 35 — de twee scope-regels~~ (afgevinkt hierboven): Open **This Week**. Onderaan het blok *"Your week
      — do these in order"*, ónder de routeknop, hoort een grijze regel te staan: *"Dit is de week van
      dít personage ... klik om de Account snapshot te openen."* **Klik erop** — je hoort op de
      Account snapshot te landen. Daar hoort onderaan de weekly-lijst de omgekeerde regel te staan,
      die je terugbrengt naar This Week.
      ⚠️ **Controle:** de regel hoort er ook te staan als je week al helemaal af is. Hij gaat over
      dekking, niet over voortgang.
- [ ] 🆕 **Alleen nog: de groene regel zélf zien.** Op een healer, met Valeera op Tank en
      Blood-Stained Blades gekozen: onderaan het curio-paneel op de Delves-tab hoort een groene regel
      te staan (*"blijf Valeera healen ... en dat stapelt"*), **zonder percentage, expres**. Geen
      haast — de lezing eronder is al bewezen.
- [x] ✅ **De rode regel — GEMETEN 9 sep, op twee beroepen.** Rob zocht op `inscription` én op
      `alchemy` op een personage dat ze niet heeft; beide gaven de regel. Op een personage dát
      Inscription heeft blijft hij terecht weg en rendert het hoofdstuk met de nieuwe Treatise-zin.
- [x] ✅ **De opgeschoonde Codex-plank — GEMETEN 9 sep.** Rob: *"de codexen zijn goed"*.
- [ ] ~~Zoek op `inscription`~~ (afgevinkt hierboven; instructie blijft als naslag): Kies de bovenste
      optie. Verwacht: het cursusvenster opent en er staat **bovenaan in rood** dat je om het
      Inscription-hoofdstuk vroeg, dat dit personage dat beroep niet heeft, en dat je daarom je
      eerstvolgende onafgeronde hoofdstuk ziet. **Voorheen kreeg je stilzwijgend hoofdstuk 4
      ("Quality") zonder dat het woord Inscription ergens stond.**
      ⚠️ **Controle:** klik daarna een hoofdstuk in de linkerkolom. Die rode regel hoort dan weg te
      zijn — hij geldt alleen voor het hoofdstuk dat je vroeg en niet kreeg.
- [x] ✅ **De Codex-sprong — GEMETEN 9 sep, goed.** Rob: *"mephitic werkt nu goed"*.
- [ ] ~~De Codex-sprong, tweede poging~~ (afgevinkt hierboven — oude tekst hieronder als naslag): Eerste meting (Rob, 9 sep, zoekterm `mephitic`): hij
      sprong wél, maar **te kort** — de kop van *"Corrosive Codex — which gift do I take first?"*
      stond onderaan het venster in plaats van bovenaan. Oorzaak: de pagina groeit ná de sprong
      (EditBox-hoogtes, hergebruikte blokken, en de eerste breedte-sync). De sprong wordt nu een
      halve seconde lang herhaald. **Zoek opnieuw op `mephitic`.** Verwacht: de kop *"Corrosive
      Codex — which gift do I take first?"* staat **bovenaan** het leesvenster.
      ⚠️ **Tweede controle in dezelfde beurt:** klik daarna een categorieknop (bv. **Delves**).
      Verwacht: die opent gewoon **bovenaan**. De sprong mag alleen gelden voor een zoekresultaat.
- [ ] 🆕 **De Codex-plank is opgeschoond (9 sep) — controleer wat er wég is.** Open Codex →
      **Weekly loop**. Verwacht: **geen** *"Turbulent Timeways V (Jun 30 - Aug 11)"* meer (dat
      evenement is op 11 aug afgelopen) en **maar één** Omnium Folio-artikel, namelijk het lange met
      de vijfwekenketen. Kijk ook onder **World content**: daar stond een tweede Timeways, die hoort
      ook weg te zijn.
- [ ] 🆕 **De Inscription-tekst (Spec 34).** Professions → cursus → hoofdstuk Inscription. Verwacht:
      *"so your Treatise gives 2 Knowledge instead of the usual 1"*. De oude zin beweerde dat
      Inscription het als **enige** beroep heeft, en dat was door geen enkele bron gestaafd.
- [ ] 🔴 **De Azeroot-tekst is nog STEEDS nooit gezien, en nu weten we waaróm.** GEMETEN 9 sep:
      Rob zocht op "azeroot", klikte het resultaat, en landde op **stap 6 van 9** — precies zoals
      8 sep. Niet toevallig: `ns.MH_OpenProfessionGuide` eindigt op `AdvanceToCurrent()`, dus de
      gids springt altijd naar de stap waar je zélf staat. Robs Herbalism is voorbij 30, dus de
      stap met de Azeroot-tekst schuift onder hem weg.
      📌 **Dit is de derde ronde van dezelfde bug.** Eerst was het antwoord er niet, toen was het
      er maar onvindbaar, nu is het vindbaar maar brengt de zoekactie je niet bij het antwoord.
      Een zoekresultaat dat het juiste vénster opent en de verkeerde bladzijde toont, is van
      buiten hetzelfde als geen antwoord. Zie het voorstel in `NEXT_SESSION.md`.
      ⚠️ Tot dat gebouwd is: open de gids en klik **Back** tot stap 1 van 9.
- [x] ✅ **`/mh souls` — GEZIEN 9 sep.** Kop leest *"7 in this character's bags"*, eronder de
      Warbound-regel en *"do not subtract"*, en het grootboek groepeert per bron met de
      flicker-teller eronder (4 rijen overgeslagen).
      🔴 **MAAR de Warbound-regel zelf is nooit gemeten** — zie `NEXT_SESSION.md` 9 sep.
- [x] ✅ **`/mh profguide` als kaal commando — GEZIEN 9 sep.** Opent Guided mode op **Alchemy**,
      stap 8 van 11. Correct: `DefaultGuideSkillLine()` kiest het eerste beroep dat je écht hebt.
- [x] ✅ **Het zoeklabel — GEZIEN 9 sep.** Zoeken op "azeroot" geeft **"Guided mode — Herbalism
      inside Professions"**. Gelijk aan de titel van het venster dat opengaat.

✅ **Wel al gezien en goed bevonden** (dus niet opnieuw testen): het Codex-artikel over de
Midnight-campagne, het Corrosive-Codex-artikel, de Dundun-flamingo in drie vormen, de
pet-waarschuwing die vanzelf vuurt, en de portaalroute van buiten naar de isle.

## 🆕 4 sep — Dundun, de Shrine of Abundance (ONGETEST, op LIVE)

De enige zin die niemand anders geeft: deze delve is Bountiful, dus Dundun zit erin, en zijn
aanbod kan een **tweede** Restored Coffer Key kosten.

- [ ] 🔴 **`/mh dundun` buiten een delve.** Verwacht een tabel met `in a delve: could not read` of
      `false`, en een **verdict `quiet`** met de reden erbij. Dit is de belangrijkste test: zwijgen
      is hier de normale uitkomst, en het moet te zíén zijn dát hij zweeg en waarom.
- [ ] **`/mh dundun` in een gewone (niet-Bountiful) delve.** Verwacht `Bountiful: false` en
      `verdict: quiet — this delve is not Bountiful`.
- [x] ✅ **`/mh dundun` in een BOUNTIFUL delve — GEMETEN 4 sep, The Darkway tier 11.**
      `Bountiful: true` van binnenuit, op naam/zone/zone+map. De zorg dat de kaart-POI binnen
      onleesbaar zou zijn was ongegrond; het waren twee bugs in `DundunShrine.lua` zelf.
- [ ] **Loop een Bountiful delve in en wacht 2 seconden.** Er hoort vanzelf een blok van drie of
      vier regels in de chat te komen: dat hij er is, dat hij zich als een boom vermomt, de
      sleutelwaarschuwing met **jouw** aantal keys, en de macro-tip.
      📌 Heb je minder dan 2 keys, dan hoort die regel **oranje** te zijn en anders te klinken.
- [ ] **Klopt het aantal keys** dat hij noemt met wat je Currency-tab zegt?
- [ ] Werkt de macro (`/cleartarget` + `/target Dundun`) als hij er is?

⚠️ **Wat ik NIET weet en wat de tekst daarom niet belooft:** of de eerste vondst van de week een
tweede Coffer geeft (jouw eigen meting) of een keuze-trunk (de wiki). De regel zegt daarom "kan
kosten", nooit "kost". Zie je in het spel welke van de twee het is, dan kan die zin scherper.
⚠️ Ook niet gemeten: dat rank 3 de drempel is. Dat komt van webbronnen. Zit je onder rank 3 en zegt
MH tóch iets, dan klopt de drempel niet.

## ✅ 4 sep — RONDE 2 GEDAAN: vier echte bugs, en drie ervan zaten in mijn eigen diagnose

Rob testte de routes vanuit The Den (de grot in Harandar) en vanuit SMC. Alles hieronder is
GEMETEN op zijn scherm, niet afgeleid.

**Wat er kapot was, in volgorde van vinden:**

1. 🔧 **Sub-kaarten vielen door naar regiogroep 0** — en 0 is precies de waarde die "ander
   continent" betekent. In de grot verdween de route; buiten kwam hij terug. `GetRegionGroupID` en
   `GetBaseZoneName` klimmen nu naar de ouderkaart (max 6 stappen, guarded). Meer ID's toevoegen
   was de verkeerde reflex: Blizzard maakt sub-kaarten sneller dan wij ze meten.
2. 🔧 **Het DOEL werd niet door de hub-slice gehaald, de speler wel.** Canvas 2576 draagt
   Silvermoon, Voidstorm én Harandar naast elkaar; kaal geeft `GetRegionGroupID(2576)` altijd 1
   (Silvermoon-default). Een delve in de Harandar-sliver las dus als "andere regio" terwijl Rob
   ernaast stond. `ns.GetTargetRegionGroupID` slicet nu beide kanten. De doel-x zat al ín beide
   aanroepen — hij werd nooit doorgegeven.
3. 🔧 **"Ben ik er al?" was drie keer verschillend beantwoord.** `ReportTravelHintForWaypoint`
   vergeleek kale kaart-ID's, dus 2576-met-doel-2413 las als twee plekken, en MH bood een portaal
   aan naar de zone waar Rob stond. Eén helper nu: `ns.SameTravelRegion`. ⚠️ Eerlijk: de twee
   reispopup-checks hebben de vergelijking nog inline (ze hergebruiken hub en x verderop) — ze
   rekenen wél met dezelfde functies eronder.
4. 🔧 **De reisplanner nam de EERSTE passende portaalrij, niet de dichtstbijzijnde.** `/mh portals`
   toont zes rijen "Portal to Silvermoon" en vijf "Portal to Harandar"; op 2576 delen er meerdere
   een mapID. Rob stond naast een portaal en kreeg "Use: Portal to Silvermoon (882yd)" met een pijl
   naar eentje een kilometer verderop. Nu wint de kleinste afstand in kaart-eenheden.
5. 🔴 **De portaal-poort vroeg het CHARACTER; de Prey-unlock is WARBAND-WIDE.** Rob: *"die is
   account wijd"*. Op een alt die de Season 2 Prey-questlijn niet zelf deed verborg MH het Coiled
   Isle-portaal en bood een tragere vlucht aan. `PortalUsable` vraagt nu eerst
   `IsQuestFlaggedCompletedOnAccount`. 📌 Drie plekken in deze addon wisten dit al —
   `WorldBoss.lua:240` heeft dezelfde helper sinds de Omnium-Folio-altbug in juni, en
   `CampaignLeadIn.lua:156` bewaart Blizzards eigen "ACCOUNT COMPLETION"-zin sinds 31 aug.

**Wat er nu klopt (GEMETEN in SMC op 54.95, 62.81):** het Coiled Isle-portaal op afstand 0.048,
de andere twee op 0.181 en 0.190 — de dichtstbijzijnde wint, en de zone-kolom leest het `zone`-veld.

⚠️ **De les die drie keer terugkwam: een diagnose ontsnapt niet aan de bug die hij diagnosticeert.**
De regiogroep-regel in `/mh arrow` riep de KALE functie aan en beschuldigde daarmee de routing van
een fout die van hemzelf was. De zonekolom in `/mh portals` leidde de zone af uit de x en overreed
daarmee het expliciete `zone`-veld — voor een coördinaat die binnen een gebouw ligt en dus niet in
de sliver van zijn eigen voordeur hoeft te vallen. Rob wees dat laatste aan met één vraag:
*"hadden wij niet juist de coordinaten op de ingang gezet ipv precies op de portal?"*

**Nog te testen in deze hoek:**
- [ ] Vanuit The Den naar The Grudge Pit: er hoort **geen** portaal-omleiding meer te komen.
- [ ] Vanuit The Den naar een delve in Eversong: daar mag wél een reisadvies komen.
- [ ] Op een alt die de Prey-lijn niet deed: `/mh portals` hoort `quest 96004 completed (warband)`
      te tonen in plaats van het portaal te verbergen.
- [ ] ⚠️ Nog onverklaard: de suggestie *"head for Tranquillien"* vanuit de grot. Komt die terug,
      dan is dat een aparte fout in de hub-keuze.

## 🆕 3 sep — de routes vanuit Harandar (ONGETEST)

Je stond in Harandar, klikte Twilight Crypts, en kreeg vier regels die elkaar tegenspraken.

- [ ] **Zelfde klik, opnieuw.** Ga in Harandar staan en route naar **Twilight Crypts**. Verwacht:
      **géén** *"Head for Portal to Harandar first"* meer, en **géén** *"…is not on this continent"*
      over een flight master waar je naast staat.
- [ ] 🆕 **De onmogelijke vlucht hoort nu wég te zijn.** *"Fly from The Den to Torntusk Overlook"*
      mag niet meer verschijnen: Zygors taxi-graaf zegt dat Harandar een gesloten eiland is
      (component 35) en Torntusk Overlook op Eastern Kingdoms zit (component 1).
      ⚠️ **Vanuit Silvermoon hóórt er wél een vlucht te komen** — *Sanctum of Light* zit in dezelfde
      component als Torntusk Overlook. Krijg je daar géén vliegadvies, dan is de poort te streng en
      wil ik het horen.
      📌 Onze dekking is 129 van 649 punten, dus voor veel zones weten we het niet en zwijgt de
      poort bewust. Onbekend blokkeert niets.
- [ ] 🆕 **En de tegenproef op mijn eigen correctie:** vanuit Silvermoon hoort *"The Den is not on
      this continent"* er wél te mogen staan als de route je daar nog heen stuurt — die zin was
      dáár waar. Ik had hem eerst onvoorwaardelijk gesmoord; nu zwijgt hij alleen als de tussenstap
      op je eigen kaart ligt.
- [ ] 🔴 **De meting die het laatste stuk hard maakt:** typ **`/mh arrow`** terwijl je in Harandar
      staat. Die print welke map de client teruggeeft en welk continent hij eraan hangt. Mijn
      diagnose zegt dat je soms als map **2576** en soms als **2413** wordt gezien binnen één
      seconde — dat is nu afgeleid uit jouw chat, niet gemeten.
- [ ] **The Den.** Onze coördinaat stond 17 kaarteenheden ernaast (een aflezing van de verkeerde
      verdieping). Route er eens heen: de pijl hoort nu naar de grot te wijzen, niet ernaast.
- [ ] 📌 **Voor Cisca of een Alliance-alt, niet voor jou:** *The Royal Exchange* stond bij ons op
      "beide facties" en is **Horde-only**, *Silverglade Refuge* andersom. Een Alliance-speler werd
      dus naar een flight master gestuurd die hij niet mag gebruiken. Nu gecorrigeerd — maar
      niemand hier kan dat op een Alliance-character controleren.

## 🔴 4 sep — RONDE 1 GEDAAN, en hij legde een veel groter gat bloot

Rob liep de level-68-lijst af. Wat werkt, werkt. Wat niet werkt is groter dan de lijst.

- [x] ✅ **Stap 1-3 werken.** De kop zegt *"This week's routine happens in Silvermoon — it opens
      up at level 80"*, de teller staat op *3 of 3 · 8 more open up as you level*, en de lijst is
      in tweeën met "Later, as you level:" eronder. Geen *"Everything is done"*.
- [x] ✅ **Stap 5 werkt** — Silvermoon-tabblad met de rode regel bovenaan.
- [x] 🔧 **GEREPAREERD tijdens de ronde:** "Get ready for Season 2" telde 1 → ✓ → ✓ → **4**.
      Dezelfde raw-index-fout als de routinelijst, in het blok ernaast, en hij overleefde de fix
      van 3 sep omdat toen maar één van de twee is bekeken. **Beide sites** nummeren nu alleen wat
      nog open staat. ⚠️ De tweede site (`now`-lijst) telde afgevinkte regels óók mee, dus het
      eerste openstaande item zou nummer 4 hebben gekregen zodra er eentje open stond.
- [~] ⛔ **Punt 6 (Halduron Brightwing) INGETROKKEN — de test was onmogelijk.** Rob: *"kan ik
      überhaupt wel daar naar toe al om te gaan kijken"*. Nee: Halduron staat bij de vault in
      Silvermoon en Silvermoon opent op 80. Ik vroeg om een meting op een plek waar hij niet mag
      komen. Zijn `minLevel` blijft dus onbekend tot iemand daar op een lage character komt.

### 🔴 Het gat dat ronde 1 blootlegde — GEMETEN, en het raakt een geshipte belofte

Rob: *"Ook dingen als rares en delves geven allemaal een route?!?"*

| | aantal |
|---|---|
| modules die een route kunnen zetten | **29** |
| modules die de level-gate kennen | **2** (`ResetRoutine`, `UI`) |

Wat op 3 sep gebouwd is dekt **This Week** en het **Silvermoon-tabblad**. Rares, delves, treasures,
achievements, events en professies zetten allemaal ongefilterd een route.

⚠️ **En `CHANGELOG_260_3` belooft al dat we dit doen** — *"never points you at endgame content you
cannot do yet"*. Die zin staat in een uitgebrachte versie en is aantoonbaar onwaar. Dat moet hoe dan
ook opgelost worden: repareren of intrekken.

✅ **Goedkoper dan het lijkt: er is één deur.** `ns.AddSmartTomTomWay` wordt overal gebruikt
(Rares 9×, Achievements 16×, Delves 8×, RitualSites 4×) en er zijn vrijwel geen directe
`SetUserWaypoint`-omwegen (alleen `Delves.lua` 4×). Eén functie dekt dus bijna alles.

**Voorgelegd aan Rob, nog niet gekozen:** (A) waarschuwen bij de klik maar de route wel zetten,
(B) route weigeren met de reden op de knop zoals de Silvermoon-pins, (C) niets nu en de
changelog-belofte intrekken. Aanbeveling was A — bij een rare is de coördinaat nog steeds nuttig,
maar een route naar een zone waar je niet komt is verkeerd advies.

## 🆕 3 sep — This Week op je level-68 Paladin (ONGETEST)

🔴 **Dit kun jij testen en ik niet**, want op max level vuurt de nieuwe filter nooit. Log in op de
**level 68** en open This Week.

- [ ] **"Next up" mag geen endgame meer aanbevelen.** 🔴 **Bijgesteld na Robs vraag van 15:xx** —
      eerst stond hier dat de **profession-weekly** de nieuwe kop zou worden. Dat was fout: die
      quest is skill-gated, maar de **trainer staat in Silvermoon**, net als élke andere stop in
      deze routine. Op een 69 hoort er nu **helemaal geen kop** te staan, maar de regel *"De
      weekroutine speelt zich af in Silvermoon — die gaat open op level 80."*
      ⚠️ Staat er *"Everything on this week's list is done"*? Dán is het mis — dat is precies de
      leugen die deze regel moet voorkomen.
- [ ] **De teller.** Stond op *"3 of 8"*. Hoort nu veel lager te zijn — op een 69 blijft er
      vrijwel niets over dat je kunt doen — met daaronder *"Er komen er nog N bij naarmate je
      levelt."*
- [x] ✅ **Kan je 69 in Silvermoon komen? — BEANTWOORD, online.** Blizzards eigen aankondiging plus
      twee gidsen: **Eversong Woods gaat open op level 80**, Midnight loopt 80→90 met Silvermoon als
      hub. Derde bron naast onze eigen tabtitel *"Leveling (80-90)"*. De grens van 80 staat.
      ✅ **EN NU OOK IN DE CLIENT GEMETEN — 5 sep 2026: het spel houdt je NIET tegen.** Rob nam op
      een level-**70** paladin het portaal in Orgrimmar (85, 56.25/88.57) en liep Silvermoon
      binnen. De 80 is dus een aanbeveling, geen deur. Dat maakt onze formulering *"afgestemd op
      level X"* — nooit *"je kunt daar niet heen"* — achteraf de enige die stand had gehouden.
      📌 Wat wél gelevelgated is: de **campagne**. Dezelfde character kreeg bij Image of Lady
      Liadrin (85, 53.37/77.35) alleen een filmpje en geen quest. Grond open, verhaal dicht.
      📌 De regel *"Cuzoth — Item Upgrades (other continent — travel back)"* die je zag is **geen
      bug**: dat is een pin uit het Silvermoon-tabblad waar je zelf op klikte. Een stadsgids
      raadplegen is iets anders dan advies krijgen.
- [ ] **De lijst is in tweeën.** Bovenaan genummerd 1, 2, 3… **zonder gaten** (hij sprong eerst van
      7 naar 10). Daaronder een grijze kop *"Later, als je verder levelt:"* met de rest, met
      streepjes in plaats van nummers. Alles blijft klikbaar.
- [ ] **De "Start route"-knop.** Die stuurde je door de endgame Bazaar-hub. Nu hoort hij alleen
      langs stops te gaan die je op level 68 echt kunt doen — en zegt hij *"Nothing open to route
      to"* als er niets overblijft, wat een geldige uitkomst is.
- [ ] 🔴 **De meting die alleen jij kunt doen:** loop naar **Halduron Brightwing** bij de vault en
      kijk of hij je op level 68 **iets aanbiedt**. Wij weten alleen dat een level 80 zijn
      level-variant kreeg (`95468`); 68 is nooit getest. Biedt hij iets aan → hij hoort geen
      level-eis te krijgen. Biedt hij niets aan → dan weten we eindelijk zijn echte `minLevel`.
- [ ] **Niets veranderd op level 90?** Log daarna op een max-level character in: kop, teller, lijst
      en route horen er **exact hetzelfde** uit te zien als vanmorgen. Dit mag alleen onder max
      level iets doen.

- [ ] 🔴 **De Hearthstone-knop mag niet meer verschijnen als je HS ergens anders heen gaat.** Rob
      werd naar Silvermoon gestuurd terwijl zijn HS op **Pinewood Post** stond, en kreeg hem tóch
      aangeboden. Nu wordt gecontroleerd waar hij landt.
      **Wat je nu hoort te zien:** géén Hearthstone-knop in de reis-popup zolang je HS niet op het
      doel staat. Staat er ook geen portaal in de buurt, dan verschijnt de popup **helemaal niet**
      — dat is een geldige uitkomst, geen bug.
      ⚠️ **De tegenproef:** zet je HS op een herberg in Silvermoon en laat je opnieuw daarheen
      routeren. Dan hoort hij er wél te staan. Doet hij dat niet, dan is de naamvergelijking te
      streng en wil ik het horen — `GetBindLocation` geeft een herbergnaam, geen zonenaam.
      📌 `/mh portals` zegt nu onderaan waar jouw Hearthstone heen gaat en waarom hij wel of niet
      wordt aangeboden.

- [ ] 🆕 **De routeknop hoort weg te zijn.** Onder de lijst stond nog *"Set TomTom route along the
      open stops (vault, hub, station)"* — die drie liggen allemaal in Silvermoon. De stops waren al
      gefilterd, de knop niet, dus zijn eigen label noemde precies wat je niet kunt bereiken. Nu
      verschijnt hij alleen als er echt iets te routeren valt.
- [ ] 🆕 **Silvermoon-tabblad: de kaart blijft, de pijl niet.** Klik weer op *Cuzoth — Item
      Upgrades*. Verwacht **geen pijl en geen "travel back"-regel** meer.
      🔴 **En nu bovenaan het tabblad zelf**, in rood, vóór je iets aanklikt: *"Silvermoon gaat open
      op level 80. Alles hieronder is een kaart voor later — de pins werken nog, maar erop klikken
      zet nog geen route."* De chatregel blijft er ook, maar die is niet meer waar het antwoord
      hoort te staan.
      ⚠️ De pins zelf horen gewoon zichtbaar en klikbaar te blijven — opzoeken wáár Cuzoth staat is
      naslag, en dat halen we niet weg. Alleen de route stopt.
      📌 *"Nearest flight point"* is bewust **niet** gegate: die leest waar je staat en werkt overal.

📌 Zie je iets raars: `/mh resetdebug`. Die print nu per stap `hero=yes / NO (out of reach)`, plus je
level, de cap en de tally — dat is precies de toestand die ik hier niet kan bereiken.

## 🆕 3 sep — de nieuwe spell-ID's uit DBM moeten in het spel een náám worden (ONGETEST)

Vandaag zijn er tips herschreven met ID's die uit DBM komen in plaats van uit datamining: alle 28
raid-regels, Rotmire, en Taz'Rah + Nalorakk. Statisch is alles gecontroleerd, maar `{SPELL:id}`
wordt pas in de client een naam. **Een ID dat 12.1 niet kent, rendert als een kaal nummer of als
niets** — en dat is precies wat geen enkele controle hier kan zien.

Eén blik per boss is genoeg; je hoeft er niet heen te reizen.

- [x] ✅ **Voidscar Arena → Taz'Rah.** Vier nieuwe ID's: Black Hole, Umbral Rupture, Nether Dash en
      (bij Tank) Void Blast. Alle vier horen een spelnaam te tonen.
      ⚠️ Bullet 3 noemt de **Ethereal Shades** bewust zónder spell-link — dat is geen fout.
- [x] ✅ **Den of Nalorakk.** Nieuw: **Echoing Maul** in bullet 2.
- [x] ✅ **Murder Row → Zaen Bladesorrow.** Bullet 1 en 4 wijzen nu naar andere spells: **Murder in a
      Row** en **Fire Bomb**. De tekst is niet veranderd, alleen waar de link heen gaat.
- [x] ✅ **Murder Row → Kystia Manaheart.** Bullet 3 en de Tank-regel noemen nu **Fel Spray** (de
      kegel zelf) in plaats van de brandende grond die hij achterlaat.
- [x] ✅ **Sporefall → Rotmire** (ritual). Vijf ID's, allemaal nieuw.
      📌 Bullet 1 zei tot vandaag dat `1221637` *"de wipe"* was; het is een **knockback**. Als je
      hem ooit doet: klopt dat nu met wat er gebeurt?
- [x] ✅ **Een raid-boss naar keuze** — alle 28 regels zijn aangeraakt.
- [ ] 🆕 **Zeven raid-bosses hebben er 's avonds rol-regels bij gekregen** (Averzian, Vorasius,
      Salhadaar, Nek'zali, Vashnik, Sszorak, Ula'tek). Codex → Raids. **Ula'tek is de interessantste:
      die had alléén een stappenregel en heeft nu tank, healer én dps.**
      ✅ **GETEST 4 sep — The Venomous Abyss volledig, alle links tonen namen, geen kale nummers.**
      Ula'tek heeft nu tank, healer én dps, met *Grasping Fangs* in de healer-regel.
      🔴 **DE OPDRACHT DIE HIER STOND WAS FOUT EN KOSTTE ROB EEN ZOEKTOCHT.** Er stonden vier namen
      in om op te letten — *Shadowclaw Slam* (Vorasius), *Entropic Unraveling* (Salhadaar),
      *Restless Amani* (Nek'zali), *Grasping Fangs* (Ula'tek) — en **alleen de laatste bestaat**.
      Onze data heeft daar alleen ID's: `NEKZALI_DPS` gebruikt `1297630`, dat in de client
      **Vessel of Awakening** heet; `VORASIUS_TANK` gebruikt `1241836`, `SALHADAAR_TANK` `1246175`.
      De drie andere namen zijn nergens gemeten.
      📌 Dat is de nooit-liegen-regel, toegepast op een TESTINSTRUCTIE in plaats van op de addon.
      **Noem geen spreuknaam die je niet gemeten hebt.** Wij bewaren ID's; de naam komt uit de
      client van de speler. Beschrijf dus de regel en laat de naam aan het spel — of meet hem eerst.
      ⚠️ **En zeg in welke raid iets staat.** Averzian, Vorasius en Salhadaar zitten in **March on
      Quel'Danas**, niet in The Venomous Abyss. Rob klapte de Abyss open; die drie stonden een raid
      hoger. Dat leest als "ontbreekt" terwijl het "verkeerd doorverwezen" is.
- [ ] **Nog te doen: March on Quel'Danas** — Averzian, Vorasius en Salhadaar, dezelfde vraag
      (toont elke link een naam of een kaal nummer?).
      ⚠️ *Blackening Wounds*, *Dig In* en *Venomous Heart* staan er **bewust zonder link** — die kent
      DBM niet, en een verzonnen nummer is erger dan geen nummer.
      🔴 **En lees ze als een gids, niet als ervaring.** Deze regels komen uit Zygor; niemand hier
      heeft deze gevechten gedaan. Zie je er ooit een die niet klopt met wat er in de pull gebeurt,
      dan is dat precies wat we willen horen.

🔴 **Wat dit NIET test.** Dat een ID een naam krijgt bewijst dat het bestaat, niet dat onze zin
eromheen klopt. De werkwoorden komen uit DBM's audio-cues; dat is sterk, maar niemand van ons heeft
deze gevechten gedaan.

## 🆕 1 sep — Spec 31 B3 en B4 (ONGETEST)

- [ ] **B4 — de regel onderaan het changelog-venster.** Open het met `/mh changelog` (of wacht
      op de volgende versiewissel). Boven de twee vinkjes hoort te staan: *"Something in this
      list wrong, or missing for your class? One person writes this addon…"*, in grijs.
      ⚠️ Loopt hij over de vinkjes heen of valt hij buiten het venster? Dat is dezelfde
      layoutfout als bij Professions → Overview: alles groeit naar beneden en niets begrenst het.
- [ ] **B3 — de Discord-kaart mag pas verschijnen als MH iets voor je gedaan heeft.**
      Op Robs eigen account staat er allang een milestone, dus hij hoort er gewoon te zijn.
      🔴 **De echte test kan Rob niet doen**: een vers account zonder milestones. Wat hij wél
      kan zien is dat de kaart NIET verdwenen is — verdwijnt hij, dan leest de check zijn
      milestones niet en is de voorwaarde te streng.
      📌 Wij kozen eerst "door minstens één update heen"; dat bleek onmeetbaar met wat we
      opslaan (`lastSeenVersion` wordt al op dag één gezet). Zie het commentaar in
      `DiscordNudge.lua` voor waarom een installatiedatum een leeftijdsgok zou zijn.

## ⛔ 31 aug — de Vaults-keten (INGETROKKEN 3 sep, niet testbaar)

🔴 **INGETROKKEN 3 sep — Rob kan dit niet testen, en dat was op 31 aug al gemeten.** Zijn eigen
vraag: *"dit kon toch niet als je op 1 character het al gedaan hebt??"* Klopt, en het is erger dan
per character: `/mh campaign` op **Warlockie, level 82** gaf `done=true` voor alle vier de
ketenquests, en een level-82 character kán geen level-90 quest hebben afgerond. **De keten is
account-wide.** Er bestaat dus geen character waarop dit blok nog verschijnt — een alt helpt niet.

Die meting stond al in `CampaignLeadIn.lua` (bij `gateKey`), compleet met de opmerking dat de regel
*"permanently unverifiable by the person who signs it off"* is. En tóch stond hij hier nog als
afvinkbare testregel. ⚠️ Dat is precies de val waar dit project een regel over heeft: een
aantekening is een claim mét een datum, en deze was drie dagen onwaar.

- [x] ~~De grijze eis-regel, de twee beloningsregels, en of het blok verdwijnt zodra je begint.~~
      **Niet te bereiken.** Wat Rob wél kan: `/mh campaign` print de zin uit én zegt erbij wie hem
      zou zien. Zo is de tekst te lezen zonder de toestand te kunnen halen — dat is waarvoor die
      diagnose gebouwd is.
- [x] ~~Telt de keten vier quests, met `98515 A Toxic Tour` ertussen?~~ **BESLECHT 2 sep**, niet in
      het spel maar in Zygor 9.6's eigen dailies-checklijst: die noemt acht ID's en 98515 zit er
      niet bij. Het is een **verhaalstap**, geen daily. De Codex sprak zichzelf tegen ("drie
      quests") en is in 7 talen gerepareerd.
      ✅ **HERBEVESTIGD 3 sep** op een nieuwere Zygor-build, mét een correctie: de **volgorde** was
      fout. 98515 wordt als **tweede** aangenomen (samen met 97640) en als **laatste** ingeleverd,
      ná 98428. Keten staat nu als `98388 → 97640 → 98428 → 98515`.
- [ ] 🆕 **Dit kun je onderweg zien:** loop je de Vaults-keten ooit, kijk dan of dat klopt — vier
      objectives van A Toxic Tour lopen op de achtergrond mee terwijl je de andere quests doet, en
      je levert hem als laatste in bij Warleader Abdumati.

## ✅ AF 31 aug — beide Engelse vragen beslecht in de gamedata, jij hoeft niets te testen

Ik zei dat hier een run voor nodig was. **Dat was fout** — het stond allebei in Blizzards eigen
DB2, alleen niet op de plek waar de eerste agent keek.

- ✅ **`rifle` is een GEWEER.** `CriteriaTree` 212485 is een echt scenario-doel: *"Galvanic Rifle
  acquired"*, onder `Ethereals02` = Shadowguard Point. De ability is `Spell` 1246359
  **Galvanic Blast**, en Blizzards eigen tooltip zegt *"Destroys mana containers"* — **"mana
  containers" is dus Blizzards term, niet de onze**. Ons *"until boss opens"* is het doel
  *"Arcane Barrier destroyed"* (`CriteriaTree` 212750).
  ⚠️ Waaróm beide vertalers hem niet vonden: het is **geen voorwerp**. Ze zochten in `Item` en
  `ItemSparse`; het is een action-bar-override-spell. Net als `Improvised Arcane Device` en
  `Evasive Elixir`, die ook spells blijken te zijn.
  → Engels herschreven, en de 6 vertalingen van die 2 keys staan nu als gedrift.
- ✅ **Deatholme, met één `h`.** *"Ruins of Deatholme"* bestaat wél: `AreaTable` **16056**, een
  direct kind van het vernieuwde **Eversong Woods** (15968). Onze zone was dus goed en alleen
  de spelling fout — in 14 regels hersteld. Blizzards eigen interne token is
  `12EversongDeathholme` **mét** dubbele h, wat vermoedelijk onze bron is.
  📌 Ingang gemeten: `AreaPOI` 8437 → **Eversong Woods 45.5, 86.0**. Methode gecontroleerd op
  Shadowguard Point, dat exact onze opgeslagen `37.18, 49.16` reproduceert.

## ❓ 31 aug — twee vragen over ons EIGEN Engels die alleen in het spel te beslechten zijn

Geen bug in de vertaling: twee dingen in de **enUS**-bron blijken onhoudbaar, gevonden doordat
vier taalexperts los van elkaar over dezelfde regels struikelden.

- [ ] **Shadowguard Point → Stolen Mana: krijg je daar een geweer?**
      Onze regel is *"Stolen Mana: rifle destabilizes mana containers"*. De Spaanse vertaler las
      `rifle` als **werkwoord** (doorzoeken), de Portugese als **zelfstandig naamwoord** (een
      wapen dat je krijgt) — onafhankelijk van elkaar, tegengesteld. De grammatica wijst naar
      het naamwoord (`rifle` stuurt een enkelvoudig werkwoord aan), maar **geen van beiden vond
      een voorwerp met die naam in DB2**. Spaans heeft het woord daarom wéggelaten.
      🔴 Twee moedertaalsprekers die één zin tegengesteld lezen = de zin is stuk. Kijk bij je
      volgende Stolen Mana-run of je een voorwerp in je actiebalk krijgt, dan herschrijven we
      het Engels en vertaalt de rest mee.

- [ ] **"Ruins of Deathholme" bestaat niet.** Die string staat in 12.1 `AreaTable` in geen enkele
      taal. Het dichtstbijzijnde echte gebied is **Deatholme** (één `h`, id 3500) en dat ligt in
      **Ghostlands**, niet in zuidwest Eversong. Klopt onze plaatsbepaling van The Shadow Enclave
      wel? Portugees liet het Engels staan in plaats van een gok vast te leggen.

## ✅ AF 31 aug — Earthshammy-ronde gedaan en geverifieerd

Rob draaide hem diezelfde middag. `tools/_probe.py` leest **Herbalism 40, captured on
Earthshammy** — de vangst is dus hersteld én draagt nu een eigennaam. De andere tien staan op
`|before the fix|`, wat klopt: die zijn vastgelegd vóór de reload met de nieuwe code.

📌 Eén vraag blijft open en lost zichzelf op: Alchemy staat op 20 zonder eigenaar. Zodra iemand
daar een keer het venster opent, staat er een naam bij.

<details><summary>De oorspronkelijke instructies</summary>

Rob draaide `/mh profids` over meer personages dan gevraagd en legde daarmee een ontwerpfout
bloot: de vangst overschreef per beroep, dus een alt met Herbalism op nul wiste Earthshammy's
**Botany 40/40** uit het bestand. Drie van zijn alts hebben Herbalism; de laatste won gewoon.

De fix (`ab11f2b`) laat een vangst vastleggen **van wie** hij komt en vervangt alleen bij
hetzelfde personage of méér rangen. Wat er al kapot is, repareert dat niet.

**Log in op Earthshammy, open Herbalism (en Alchemy als die er staat), `/reload`, dan:**

```
/mh profids
```

- [ ] Herbalism staat weer op **40** — controleer met `python tools/_probe.py`
- [ ] De regel noemt nu rangen én blijft staan als je 'm daarna op een alt draait:
      verwacht `|cffff9900(kept Earthshammy's 40 instead)|r`
- [ ] ⚠️ **Open vraag die alleen deze ronde kan beantwoorden:** Alchemy sprong van 0 naar 20.
      Dat is óf Rob die punten uitgaf, óf een tweede Alchemy-personage dat erover heen ging.
      De oude dump legde geen eigenaar vast, dus dit is niet uit het bestand te halen.

</details>

## 🔴 30 aug — beroepen-adviseur zweeg voor een heel beroep. Fix ligt klaar, ONGETEST.

Rob zat vast: Disenchanting Delegate op 30/30, 235 Knowledge in de hand, en géén groene
adviesregel onder "Enchanting". Oorzaak: stap 2 van de route noemde `Shard Supplier` /
`Crystal Collector` als `anyOf` — maar dat zijn **nodes**, en `anyOf` wordt opgezocht tussen de
vier **tree**-tabbladen. Geen match → `return nil` → geen advies, ook niet voor stap 3 en 4.

**Na een `/reload`, met je Enchanting op 30/30:**

### 🆕 30 aug, laat — overlappende tekst onderaan Professions → Overview (ONGETEST)

Rob's screenshot: de reset-alinea (*"Changed your mind? Theremis in Silvermoon…"*) en de
legenda-regel eronder (*"Treasures & Books: … Course (101): … Weekly KP: …"*) tekenden over
elkaar heen, allebei onleesbaar.

**Oorzaak:** de legenda hing aan `BOTTOMLEFT` van het paneel terwijl alles erboven naar beneden
groeit en niets dat begrenst. Dat ging alleen goed zolang de tekst kort was. Mijn adviesregel
groeide die middag van één naar drie regels (hij noemt nu drie takken in plaats van er stil één
te kiezen) en dat was genoeg om de speling op te eten. **De bug zat er altijd al; ik heb alleen
de marge opgemaakt die hem verborg.**

**Te controleren na `/reload`:** Toolbox → Professions → Overview, helemaal naar beneden. De
legenda hoort nu **onder** de "Route to Theremis"-knop te staan, met ruimte ertussen, en niets
mag meer over elkaar lopen.

⚠️ Bewuste keuze: er is hier geen scrollframe, dus bij een héél lange pagina kan die legenda nu
onder de onderrand vallen en onzichtbaar worden. Dat is de betere storing — het is de minst
belangrijke tekst op de pagina, en onzichtbaar is beter dan dwars door de tekst die je nodig
hebt. Zie je hem helemaal niet meer, meld het dan; dan is een scrollframe de echte oplossing.

### 🆕 30 aug, laat — de drie enchant-families in de addon (ONGETEST)

Na een `/reload`, Toolbox → Professions → **Course (101)** → hoofdstuk **Enchanting**:

1. **Onderaan het hoofdstuk staat een nieuw blok** "The three families, and why the choice
   matters" met de stat-tabel per familie. Staat het er niet, dan wordt `familiesKey` niet
   gerenderd.
2. **De adviesregel noemt nu drie namen.** Met je tree-route af hoort er te staan: *"je volgende
   punten gaan in ÉÉN hiervan — Zul'Aman Zeal, Azerothian Arms, Silvermoon's Spellpower"*, elk
   met `(0/20)`. ⚠️ Stond er eerst alleen `Silvermoon's Spellpower`; dát was de stille keuze.
3. **`/mh profadvice`** — step 2 van de node-route moet nu drie namen tonen in plaats van één.
4. ⚠️ **Zie je bij een van de drie `NOT FOUND`?** Dan bestaat die node-naam niet zoals wij hem
   schrijven. `Zul'Aman Zeal` en `Azerothian Arms` komen uit de DB2 van de agents, níét uit jouw
   client — alleen `Silvermoon's Spellpower` is ooit door jou bevestigd.
5. **Nog steeds waar:** de addon controleert niet of je een node kúnt kopen. Staat er een naam
   die in het spel op slot zit, dan is dat deze bekende beperking en geen nieuwe bug.

✅ **Ronde 1 al bevestigd op Robs scherm:** de adviesregel was terug en `/mh profadvice` gaf
`step 2 [node] Shard Supplier 0/30 | Crystal Collector 0/30` → `verdict: advise Shard Supplier`.
Geen `NOT FOUND`, dus de namen bestaan echt in 12.1. Zijn tooltips brachten daarna twee dingen
aan het licht die we níét wisten, en die zijn hierna verwerkt — **dat deel is nog ongetest:**

1. **Er staan nu DRIE opties, geen twee.** De adviesregel hoort te luiden: *"je volgende punten
   gaan in ÉÉN hiervan — Dust Deliverer (0/30), Shard Supplier (0/30), Crystal Collector
   (0/30)"*. `Dust Deliverer` ontbrak volledig in onze data.
2. **Hij mag niet meer vóór je kiezen.** Er stond *"advise Shard Supplier"* alsof dat hét
   antwoord was, terwijl de drie op verschillende gear werken (Uncommon / Rare / Epic). Zie je
   nog één naam met "next points into", dan werkt de keuzeregel niet.
3. **`/mh profadvice`** moet bij step 2 nu drie namen tonen.
4. **Tailoring mag niet veranderd zijn** — die regel (Nimble Needlework, aim 20) stond goed en
   de fix raakt alleen routes met node-stappen.
5. **Zet een punt en kijk opnieuw.** De regel hoort mee te lopen (`1/30`), en zodra de node vol
   is hoort het advies door te schuiven naar **Elevating Equipment**. Dat stuk was vóór vandaag
   helemaal onbereikbaar.

📌 Welke van de drie is **Robs keuze, niet de onze** — we hebben nooit gevraagd wat hij sloopt.
Blizzards eigen tooltips: Dust Deliverer = Uncommon, Shard Supplier = Rare, Crystal Collector =
Epic; elk +1 Skill per punt op díé kwaliteit, +5 bij het leren.

## 📍 STAND 28 aug (avond) — alles met een dwingende reden is af

Afgevinkt vandaag: de rechtsklik-dispel én de purge, de range-fade, de eigen rij,
`/mh dispeltest` (alle drie de takken), de gele balk, `/mh stats probe` (alle drie de
beslissingen), `/mh curios`, de Catalyst-meting, `/mh setline`, en Andy's PR #2b.

**Twee dingen staan nog open, allebei "als je er toch bent" en geen van beide een klus:**

1. **PR #1 — de vijf vensters die stil kunnen stoppen met verversen** (punt 7 hieronder).
   ⚠️ Dit is het enige punt met een echt risico erin: het faalt **stilzwijgend**. Een scherm
   met verouderde cijfers ziet er precies zo uit als een dat klopt. Doe het een keer terloops:
   getal onthouden, venster dicht, iets laten veranderen, weer open.
2. **Een professie-route helemaal lopen** (punt 6) — Enchanting 22 punten op de shadow priest.

Alles daarboven en daaronder met een ✅ is in het spel bevestigd, niet beredeneerd.

---

## ✅ AF 28 aug — de rechtsklik-dispel werkt

Rob bevestigde het in het spel. Oorzaak: de knop kreeg het spell-**ID** mee; hij moest de
**naam** hebben, zoals HexBreak doet. Zie `docs/NEXT_SESSION.md` bovenaan voor waarom dat een
bewuste uitzondering op onze ID-regel is, en wat de vier uur eromheen kostte.

✅ **En de purge op de rechterhelft ook** — Rob bevestigde Dispel Magic (528) met de
rechtermuisknop op de doelwit-helft, direct erna. De naam-fix repareerde dus **beide** knoppen,
niet alleen de dispel.

✅ **Range-fade en de eigen rij ook af (28 aug, in het spel bevestigd).** Wegloplopen vervaagt
een naam; heen en weer switchen tussen Holy en Shadow laat de vijfde rij komen en gaan. Rob:
*"het werkt perfect"*. Niets meer open aan deze feature — de tekst voor CurseForge staat
bovenaan `docs/NEXT_SESSION.md`.

<details><summary>De oorspronkelijke opdracht (voor herhaling)</summary>

### één schone rechtsklik (2 seconden, beslist de rest)

**Rechtsklik op een RODE naam in het party-paneel. Verder niets indrukken** — geen shift, geen
ctrl, geen alt, en niet tegelijk je eigen dispel-toets. Kijk of de dispel afgaat.

| Wat je ziet | Wat we daarna doen |
|---|---|
| de dispel gaat af | klaar — het hele HexBreak-onderzoek hieronder vervalt |
| er gebeurt niets | ik zet `*spell2` erbij (één regel), dan casten-op-naam, dan de dubbele klik |

📌 **Doe dit vóór al het andere op deze lijst.** Er liggen drie mogelijke reparaties klaar op
basis van hoe HexBreak het doet. Werkt de klik gewoon, dan zijn alle drie overbodig.

🔴 **Waarom het nog niet beslist is, en dat is mijn fout.** Ik las in de castlijst van
`/mh glow` een regel `Dispel Magic (528)` en concludeerde dat de klik op de rechterhelft
landde. Die lijst legt **élke** spreuk vast die je cast, ongeacht waar hij vandaan komt — in een
bossfight druk je van alles in. Die meter kan dat verschil niet zien; hij bewijst dus niets.

⚠️ **Verzin geen vierde verklaring vóór deze klik.** Drie hypotheses zijn al gesneuveld op
gemeten getallen (overlappende helften, combat die de layout bevriest, de gloed die de rij
afdekt). Geometrie, lagen en knop-attributen zijn allemaal ✅ gemeten en goed.

</details>

---

## 🟣 `/mh stats` — meegegaan in 3.6.0 (28 aug)

✅ **Niet meer "ongecommit".** De kop hierboven zei tot 28 aug dat deze feature alleen in Robs
spelmap stond; dat is achterhaald. `Modules/StatCoach.lua` én `Modules/DispelTest.lua` zitten
allebei in de tag `v3.6.0` en staan dus bij iedereen op de schijf. Ongetest blijft het wél —
uitgebracht is niet hetzelfde als gezien.

### 0a. `/mh stats` — leest het als jip-en-janneke?

Een venster met je hoofdstat, je vier secondaries in **jouw** volgorde, en je eigen live
percentages. De kop zegt met opzet dat hoger item level bijna altijd wint en stats pas de
doorslag geven bij twee stukken die dicht bij elkaar liggen — anders gaat een beginner hogere
ilvl weigeren om een kleurtje na te jagen.

### 0b. ✅ AF 28 aug — `/mh stats probe`, alle drie beslist

Gedraaid op Robs Frost Mage (Iceicebaby, ilvl 295) en naast toets C gelegd:

| probe | characterscherm |
|---|---|
| `GetCritChance` 17,065 · `GetSpellCritChance(2)` 17,065 | Critical Strike **17%** |
| `GetHaste` 21,177 | Haste **21%** |
| `GetMasteryEffect` 46,843 | Mastery **47%** |
| `GetCombatRatingBonus(vers)` 6,444 | Versatility **6%** |
| `primaryStat = 4` | **Intellect** bovenaan |

1. **Mastery-API:** `GetSpecializationMasterySpells` OK, `C_SpecializationInfo.GetMasterySpells`
   MISSING — nu op een tweede class bevestigd (27 aug Elemental Shaman, 28 aug Frost Mage).
   De verliezer was al verwijderd; dit is de tweede meting die dat bevestigt.
2. **`primaryStat` is echt de 6e return**, en `PRIMARY_BY_STAT` mapt 4 → Intellect
   (`StatCoach.lua:94-98`). ⚠️ Bevestigd voor Intellect; 1/Strength en 2/Agility zijn nog
   nooit gezien — een melee-alt zou dat afmaken, maar de mapping is Blizzards eigen
   `LE_UNIT_STAT_*`, dus dit is geen open risico.
3. **De crit-vraag is dood.** Beide functies gaven hetzelfde getal, en dat getal staat op zijn
   scherm. Er was geen caster/niet-caster-splitsing om omheen te bouwen.

<details><summary>De oorspronkelijke opdracht (voor herhaling)</summary>

### `/mh stats probe` — drie dingen die niemand buiten het spel kan weten

De probe print elke API die hij probeert, of hij antwoordde, en wat hij zei. Plak de uitvoer
hierheen; er zijn drie dingen te beslissen:

1. **Welke mastery-API bestaat.** Er staan er twee in als kandidaat
   (`C_SpecializationInfo.GetMasterySpells` en `GetSpecializationMasterySpells`). De verliezer
   moet daarna weg — niet laten staan "voor de zekerheid". Op 8 aug ging op precies die manier
   een niet-bestaande event-naam mee.
2. **Of `primaryStat` echt de 6e waarde van `GetSpecializationInfo` is.** Staat als
   `primaryStat=1` in de uitvoer. Klopt het niet, dan vervalt alleen de hoofdstat-regel.
3. **De vier percentages tegen je characterscherm (toets C).** Vooral crit: casters lezen een
   andere functie dan de rest, en dat is de regel die niet te bewijzen was. De probe print ze
   allebei, dus één blik volstaat.

</details>

### 0c. ✅ AF 28 aug — `/mh curios`, de opgegeten letters zijn terug

Een echte bug in `CurioExplain.lua`: het kleurcode-patroon `|c%x+` is gulzig en a–f zijn
hex-cijfers, dus het at de eerste letters van het gemarkeerde woord op — buiten het spel
bewezen: `Blood Shield` werd `lood Shield`, `deflect` werd `lect`. Gerepareerd naar exact
acht cijfers (`CurioExplain.lua:134`).

Rob plakte 28 aug de volledige uitvoer van Valeera's twaalf keuzes. **Geen enkel afgeknot
woord** — "Haste reduced", "Leech, Avoidance, and Speed", "Horrifying", "Corrosive Bilespear",
alles heel. Twee dingen tegelijk bevestigd: het patroon knipt goed, en de beschrijvingen komen
inderdaad live uit de client (de tekst bevat Blizzards eigen "stacking up to 1 times", dat
zouden wij nooit zo schrijven).

---

## ✅ Bevestigd 27 aug (avond)

Alles staand in een ritual site op Robs Elemental Shaman, één reload:

- **Bossvenster blijft uit in rituals** — Andy's PR #2a doet wat hij belooft.
- **BUFF ALLY weg.** Een ritual zet je in een instance-groep, dus `IsInGroup()` zei terecht
  "ja" terwijl er niemand stond. We tellen nu of er iemand ín een party-slot zit.
- **Valeera-venster weg.** Rituals zijn scenario's; na een delve hield elk ritual het venster
  open. De instance wordt nu vastgepind bij de start.
- **Geen zwevende pijl meer.** Verborgen binnen, en hij komt terug als je naar buiten loopt —
  de route wordt níét losgelaten.
- **De A-toets is Rob nooit kwijt geweest.** De focus-bug zat er wel (vier plekken,
  gerepareerd), maar heeft hem niet geraakt: het waren dialogen die hij zelden opent.

---

## 🔴 Eerst: één reload, dan alles achter elkaar

Deze twee kunnen staand in Silvermoon, geen dungeon nodig.

### 1. ✅ AF 28 aug — `/mh dispeltest`, alle drie de takken

Rob draaide ze allemaal. `decide`: **5 passed, 0 failed**, inclusief de SECRET-regel die
netjes zegt dat een secret value niet na te bouwen is en dus niet getest wórdt. `show`: de
gele balk kwam ("Testitis - you can dispel this"). `combat`: eerst **`in combat = false`** —
hij vuurde terwijl Rob stilstond, dus die run testte hetzelfde als `show`. Tweede poging,
slaand op iets: **`in combat = true, fired = true`**.

📌 Die eerste combat-run is het bewaren waard: het commando meldde eerlijk dát het buiten
gevecht landde, in plaats van "fired = true" te printen en de indruk te wekken dat de zware
helft getest was. Dat is precies waarvoor `InCombatLockdown()` in die regel staat.

<details><summary>De oorspronkelijke opdracht (voor herhaling)</summary>

| commando | wat je hoort te zien |
|---|---|
| `/mh dispeltest decide` | een rijtje PASS-regels met per geval een reden erbij |
| `/mh dispeltest show` | de grote gele balk bovenin, met geluid |
| `/mh dispeltest combat` | melding "firing in 5s", dan ga je een oefenpop slaan |

Let op bij `decide`: staat het dispel-alarm **uit**, dan zegt hij dat en is de uitkomst
waardeloos. Eerst aanzetten.

Bij `combat` is de chatregel het bewijs, niet de balk — hij meldt of hij in combat was en of
hij is afgegaan. Een alarm dat je gemist hebt en een alarm dat nooit kwam zien er hetzelfde
uit.

</details>

### 2. ✅ AF 28 aug — de gele balk op jezelf, ná de wijzigingen

Meegekomen met de test hierboven: `dispeltest show` en `combat` vuren door **dezelfde deur**
als het echte alarm (`ns.FireAccessibleAlert`), en die balk kwam allebei de keren op Robs
scherm. De vraag was of hij ná de wijzigingen aan `AccessibleAlerts.lua` nog komt — ja, en in
gevecht ook.

📌 Dat de test dezelfde deur gebruikt is geen detail: een test met een eigen `if testMode`-tak
slaagt juist op de build waar de echte weg stuk is.

### 3. ✅ AF 28 aug — de Catalyst zegt het zélf, en dat is sterker dan onze bron

Rob kreeg geen borststuk in het slot en probeerde een **cloak**. Dat bleek genoeg, want het
antwoord staat in de kop van het venster, in Blizzards eigen woorden:

> *"Transform an item into a set item. Only Head, Shoulder, Chest, Hand, and Legs provide
> bonus… **Secondary stats are inherited.**"*

Het voorbeeld bevestigde het: het resultaat droeg **+37 Haste / +63 Versatility**, hetzelfde
als wat erin ging. `TIER_GUIDE_BODY` stond op een blue post en een tooltip; die claim rust nu
op de client.

📌 **Drie dingen die er gratis bij kwamen:**
- **Costs: 1 charge, en Rob heeft er 0** — en het voorbeeld rendert tóch. De aanname dat deze
  meting geen charge kost is daarmee niet alleen waar maar ook verklaard.
- **Een cloak mag erín**, hij geeft alleen geen setbonus. Onze zin "cloaks zijn nooit deel van
  een set" klopt over de bónus; het spel weigert het stuk niet.
- Het venster somt de vijf bonusslots zelf op — dezelfde vijf als `ns.TIER_SLOTS`.

✅ **En het item level gaat óók mee — gemeten, niet aangenomen.** Ik had dit eerst als
onbewezen weggezet omdat het ilvl van het ingelegde stuk niet op de screenshot stond. Rob wees
erop dat het er wél stond: hij legde de cloak in die hij **aan had**, dus de "Equipped"-tooltip
naast het voorbeeld ís de invoer. Invoer **305** → uitvoer **305**, en de twee tooltips lopen
regel voor regel gelijk (Armor 65, Stamina 1.572, Intellect 81, Haste 37, Versatility 63).
Beide helften van de zin in `TIER_GUIDE_BODY` staan nu op de client.

📌 **Ook uit de patch notes** (news.blizzard.com, Curse of Ula'tek): *"Class set armor now
inherits the secondary and tertiary stats as well as certain special cantrip effects."* Dat is
**meer** dan onze tekst belooft — tertiair en cantrips staan er nog niet in.

<details><summary>De oorspronkelijke opdracht (voor herhaling)</summary>

### De catalyst-tekst kloppend maken — en de meting is gratis

De tier-uitleg zegt nu dat het nieuwe stuk je secundaire stats overneemt. **Twee primaire
bronnen zeggen dat** (blue post 18 juni + de tooltip van Venomblight Manaflux), maar we hebben
het zelf nooit gezien.

⚠️ Dit hoeft **geen** charge te kosten. De Catalyst-UI toont een voorbeeld vóór je bevestigt.

1. Pak een **borststuk** dat NIET Mastery + Haste heeft — bijvoorbeeld Crit + Versatility.
   Schrijf de stats op, inclusief een eventuele Leech/Speed/Avoidance en socket.
2. Leg het in het Catalyst-slot in Silvermoon (Bazaar). **Niet bevestigen.**
3. Ga met je muis over het voorbeeld.

| Wat je ziet | Wat het betekent |
|---|---|
| Mastery + Haste | de stats liggen vast — onze tekst is fout en moet terug |
| Crit + Versatility (wat jij erin legde) | de stats gaan mee — bevestigd |

🔴 **Kijk apart naar het tertiair en de socket.** Die konden vroeger al meekomen, dus "mijn
Leech bleef staan" bewijst **niets** over de secondaries. Dat is precies het soort halve
conclusie waar deze week over ging.

</details>

---

## 🔵 In een dungeon: Maisara Caverns, eerste baas

### 2b. ✅ AF (27 aug): de gloed vult nu de hele regel

Bevestigd op Robs scherm, staand in Silvermoon: vier volledig rode regels met DISPEL erin.
Het glow-test-commando blijft bestaan — draai het na elke wijziging aan `PartyTargets.lua`,
want dit is drie keer stuk geweest zonder dat iemand het zag tot er een baas aan te pas kwam.

⚠️ **Wat hiermee NIET bewezen is:** of het spel dat aura-vakje ooit tóónt. Dat blijft de
dungeon-test hieronder.

<details><summary>De oorspronkelijke opdracht (voor herhaling)</summary>

### `/mh glow test` — staand in Silvermoon

Zet `/mh partytargets` aan en typ `/mh glow test`. Zes seconden lang worden de rijen
geschilderd alsof er iets te dispellen valt.

**Waarom dit vóór de dungeon komt.** Alle drie de mislukte pogingen van 26 aug gingen over
**waar** de kunst tekende — icoon-formaat, daarna aan een vakje van nul bij nul, daarna ónder
de achtergrond van het paneel. Geen van de drie ging over of de gloed vuurt. Dat deel kost dus
geen dungeon en geen baas die toevallig iets moet casten.

Vult het rood hier de hele regel met DISPEL erin, dan doet het dat in een dungeon ook. Doet het
dat hier niet, dan hoef je niet te gaan.

⚠️ **Wat het NIET test:** of het spel dat vakje ooit tóónt. Dat is Blizzards beslissing op een
filter dat wij nooit lezen — precies het enige deel dat we niet in de hand hebben. Een schone
uitkomst hier plus stilte in een dungeon betekent dus nog steeds "er kwam niks langs".

</details>

### 3. ✅ AF — de rode gloed op een groepsregel

🔴 **Deze sectie stond tot 31 aug op "ongetest" en dat was fout.** De gloed die de hele regel
vult is 27 aug bevestigd (punt 2b), en de STAND van 28 aug hierboven vinkt de rechtsklik-dispel
én de purge af. Rob wees me erop toen ik het als openstaand opsomde; hij had gelijk.

⚠️ **De les zit in de vórm van de fout, niet in deze twee regels.** Dit bestand heeft een
statusregel bovenaan die alles eronder overschrijft, en ik las de detailsectie zonder die
statusregel. Een kop die "ongetest" zegt is dus geen bewijs — zoek de nieuwste STAND-regel.
Wie hierna secties toevoegt: werk de oude kop bij in plaats van er een nieuwe onder te zetten.

<details><summary>De oorspronkelijke testinstructies (bewaard, niet meer nodig)</summary>

**Ga naar Murojin, de eerste baas.** Onze eigen tips zetten de dispel daar
(`DGN_TIP_MC_MUROJIN_HEALER`: disease, zware groepsschade). Bij de laatste baas kwam 26 aug
niets langs — dat was géén bewijs tegen de reparatie.

Neem een **Holy Priest** (Purify pakt Magic én Disease). Niet je mage: Remove Curse doet alleen
curses en die komen hier niet voor.

Drie dingen apart bekijken, want ze kunnen los van elkaar stuk zijn:

1. **Vult het rood de hele regel?** Op 26 aug zag je alleen een dun streepje. Oorzaak was frame
   level — het vakje tekende ónder de achtergrond van ons paneel. Nu gelijkgetrokken met
   HexBreak.
2. **Staat het woord DISPEL erin?**
3. **Werkt de rechtermuisknop nog?** Een tussenversie brak álle klikken op het paneel. Dat is
   teruggedraaid, maar niet in het spel bevestigd.

Werkt er iets niet: `/mh glow` en de uitvoer hierheen plakken.

### 4. ✅ AF 28 aug — rechtsklik-dispel op de Priest

Eerst bewezen op Robs **mage** (25 aug: Remove Curse 475, Spellsteal 30449), daarna op de
priest bevestigd — zie "AF 28 aug" hierboven: de dispel én Dispel Magic (528) op de
doelwit-helft werkten allebei na de naam-fix.

</details>

---

## ⚪ Als je toch bij een beroep bent

### 6. Een gecorrigeerde route vanaf nul lopen (Spec 28, §5)

De tien routes zijn 20 aug herschreven en gedeeltelijk op je scherm bevestigd (Enchanting
leidt nu met `Disenchanting Delegate`, Tailoring toont de drempel van 20 met de
tooltip-waarschuwing). Wat nooit gedaan is: er één **helemaal** volgen en kijken of het advies
blijft kloppen terwijl je punten uitgeeft.

Je shadow priest heeft **Enchanting 22** onbestede punten — dat is de bruikbare testcase.

⚠️ **Tailoring werkt daar niet voor:** je skill staat onder 25, dus alle specialisaties zitten
op slot en je kunt er niets uitgeven. Dat is geen bug meer (gerepareerd 21 aug), maar het maakt
Tailoring wel ongeschikt als test.

---

## 🟠 Andy's twee PR's — GEMERGED 27 aug, nu in je client

Beide zaten sinds 7 augustus open en zijn vandaag binnengehaald. Ze raken **zeventien**
bestanden, en dat is meteen het risico: als er iets raars gebeurt met een venster, is dit de
eerste verdachte.

### 7. PR #1 — vensters die dicht stonden bleven rekenen

Vier onderdelen deden werk terwijl hun scherm dicht was. Andy meet dat de addon van 0,060 naar
0,003 ms per beeldje gaat als je stilstaat met alles gesloten.

**Wat je test: dat alles nog steeds bijwerkt.** Dit is een optimalisatie, dus je zoekt niet
naar iets dat stuk is maar naar iets dat **stopt met verversen**. Dat is een stil soort falen:
een scherm dat verouderde cijfers toont ziet er precies zo uit als een scherm dat klopt.

**De scherpste test — doe dit met minstens één van de vijf:**

1. Open het venster en onthoud een getal.
2. Sluit het.
3. Doe iets waardoor dat getal moet veranderen: een currency oppikken, een quest inleveren,
   een delve afmaken.
4. Open het weer. Staat het bij?

Langs deze vijf:

- Great Vault-advies
- delve-curio's
- wereldbaas
- de weekchecklist en de account-checklist
- het consumables-bord

⚠️ **Andy's eigen voorbehoud, dus géén bug:** de twee checklists verversen niet meer terwijl hun
venster dicht is. Heropen je hetzelfde tabblad, dan kunnen ze een paar seconden achterlopen tot
de volgende quest- of currency-gebeurtenis.

### 8. PR #2 — vensters die zichzelf openden zonder te vragen

Twee stukken. Het tweede heb je **iemand anders** voor nodig.

**a) Het bossvenster.** De aan/uit-knop werd alleen gelezen op de dungeon-route, dus het venster
ging in **rituals en raids** gewoon open terwijl jij hem uit had staan.

Ga naar **Settings → Midnight Helper**. Waar één schakelaar stond, staan er nu drie. Robs
client is Engels, dus dit zijn de labels zoals ze op zijn scherm staan:

| Schakelaar | Waarvoor |
|---|---|
| `Open automatically` | dungeons |
| `Open automatically for rituals` | rituals |
| `Open automatically for raids` | raids |

1. Zet **`Open automatically for rituals`** uit.
2. Ga een **ritual site** in. Blijft het bossvenster dicht? Dát is de bug die hier gerepareerd
   is — vóór deze PR ging hij daar open ook al stond hij uit.
3. Zet hem weer aan en kijk of hij dan wél komt.

⚠️ **Niet melden als bug:** de allereerste keer dat je de **dungeon**-schakelaar aanraakt,
neemt hij de andere twee mee. Dat is met opzet — je oude instelling gold voor álles, dus die
wordt eerst voor alle drie overgenomen (`DungeonBossWindow.lua:1195-1207`). Daarna staan ze los
van elkaar en gebeurt het niet meer.

**b) ✅ AF 28 aug — het consumables-bord respecteert nu jouw eigen schakelaar.**

Met Carola in de groep, en in de **strengere volgorde** dan hier oorspronkelijk stond:

| Robs `Allow group consumable check` | Carola typt | Robs scherm |
|---|---|---|
| **AAN** | `/mh readyall` | bord **komt** |
| **UIT** | `/mh readyall` | bord **blijft dicht** ✅ |

📌 **Die volgorde was Robs keuze en hij is beter dan mijn opdracht.** Ik schreef "zet hem uit
en kijk of er niets gebeurt". Hij deed eerst AAN — en daarmee staat vast dát het verzoek
aankomt en het bord kán openen. Zonder die positieve controle vooraf is "er gebeurde niets"
niet te onderscheiden van een kapotte functie. Dezelfde les als bij `/mh setline` diezelfde dag.

⚠️ **Praktisch, voor een volgende keer:** in een **party** bestaan geen assistenten, alleen een
leider. Rob moest Carola dus eerst de leiding geven (`/leader <naam>`) — en die kun je zelf
niet terugpakken, de ander moet hem teruggeven. Beide helften van dit commando zitten in
`v3.6.0`, dus de tester heeft genoeg aan de CurseForge-versie.

Ook hernoemd: **`Show consumable check on entry`**. Stond eerst "on dungeon entry", terwijl die
melding ook in rituals en delves komt — de tooltip eronder zei dat al.

### 9. ✅ OPGELOST — gemeten 31 aug, en niet doordat we het repareerden

`lua tools/locale_probe.lua SET_CONSREADY_TOGGLE_TITLE` geeft nu voor fr/es/pt/it
`nil -> shows English`. De foute "dungeon"-regels zijn dus weg uit die vier packs; ze vallen
terug op het Engels, wat klopt. Duits en Nederlands hebben een eigen goede vertaling.

📌 Waarschijnlijk meegenomen in een van de drift-rondes van 30/31 aug zonder dat iemand het
apart afvinkte. **Dat is precies waarom dit gemeten is en niet aangenomen** — deze regel had
anders nog maanden als openstaande fout in de lijst gestaan.

<details><summary>De oorspronkelijke melding</summary>

Andy hernoemde het label `SET_CONSREADY_TOGGLE_TITLE` omdat de tekst "bij binnenkomst in de
dungeon" zei terwijl de melding óók in rituals en delves komt. Het Engels is nu *"Show
consumable check on entry"*.

**Frans, Spaans, Portugees en Italiaans zeggen nog steeds "dungeon".** Duits en Nederlands zijn
goed. Dit is geen achterstand maar een onjuistheid, en hij staat in `docs/TRANSLATION_DRIFT.md`
bij de andere zeven.

Niets voor Rob om te testen — genoteerd zodat het niet als bugmelding terugkomt.

</details>

### 10. World boss weer zichtbaar in Season 2 — na `/reload`

**Wat je moet zien:** op **This Week** (home) en bovenaan **Delves & Vault** staat weer een world
boss, en deze week hoort dat **Lu'ashal** te zijn, in Eversong Woods, met routeknop.

**Waarom dit er staat:** de addon verzweeg de world boss sinds 18 aug. Een poort in
`Modules/WorldBoss.lua` zette hem uit zodra Season 2 zichtbaar werd, uit voorzorg — het vermoeden
was dat 12.1 world bosses had vervangen door Lairs.

✅ Dat vermoeden is op 2 sep weerlegd met `/mh worldboss` op Robs eigen client: **Lu'ashal
`taskActive = true`, 9904 minuten resterend**, de andere drie idle. De vier bosses roteren gewoon
door, en Lairs bestaan ernáást (`hasLairs = true`, `tieredEntranceType.Lairs = "4"`). Poort eruit.

⚠️ **Wat de moeite van een tweede blik waard is:** de rekenkundige terugval is teruggezet, en die
klopte deze week precies (18 maart + 24 weken → index 1 → Lu'ashal). Dat is corroboratie, geen
bewijs dat hij volgende week ook klopt. Kijk op **9 sep** of er **Cragpine** staat; klopt dat, dan
doet de rotatie het over een seizoensgrens heen.

📌 Zie je vandaag niets? Dan is dat geen kleinigheid maar dezelfde bug opnieuw — stuur dan weer de
uitvoer van `/mh worldboss`.

### 11. ✅ AFGETEKEND — `/mh report` werkt, 2 sep

Rob testte het binnen twintig minuten na uitbrengen en vond twee dingen die geen enkele controle
had kunnen zien, omdat de *waarden* klopten en alleen de **uitvoer** niet deugde:
`MAGE Frost` (het ruwe klassetoken, en in omgekeerde volgorde) en `Eastern Kingdoms (open world)`
— `GetInstanceInfo` geeft buiten de continent, niet de zone. Allebei gerepareerd; de tweede ronde
gaf `Frost Mage, level 90 . solo . Silvermoon City, The Bazaar`.

📌 De `issecretvalue`-guards zijn dus óók bevestigd: taal, spec, zone én subzone kwamen allemaal
door zonder een `?` of `somewhere`.

<details><summary>De oorspronkelijke testopdracht</summary>

**Wat je moet zien:** `/mh report` opent het bestaande kopieervenster met een blok dat begint met
`Midnight Helper report`, en daaronder je versie, clientbuild, taal, klasse/spec/level, groep en
waar je staat. In de chat komt één regel eronder.

**Probeer ook:** `/mh report de vault zei 3 slots maar ik had er 4` — die zin hoort in het blok te
staan onder *"What I saw:"*, in plaats van de standaardtekst.

⚠️ **Waar ik het meest benieuwd naar ben:** de regel `locale ... client / ... in MH` en de plek
waar je staat. Die twee lees ik uit het spel en dat is precies waar 12.x waarden geheim kan maken.
Staat er `somewhere` of een `?` waar iets hoorde te staan, dan wil ik dat weten — dat is dan geen
schoonheidsfoutje maar een `issecretvalue`-guard die aanslaat.

📌 **Wat er bewust NIET in staat:** je personagenaam en realm. Die identificeren jou, ze helpen
niet bij het reproduceren, en dit blok is bedoeld om ergens openbaar geplakt te worden. Klasse,
spec, groep en locatie zijn genoeg. Als jij vindt dat je naam er wél in moet, zeg het — het is
jouw addon — maar dit is de veiligere kant om op te beginnen.

📌 Het blok zelf is **Engels**, ook op een Duitse client, terwijl de venstertitel en de chatregel
wél vertaald zijn. Dat is een keuze: het rapport is aan de maker gericht, zoals een logbestand.
Vind je dat verkeerd voelen, dan draaien we het om.

</details>

### 13. De drie beroepsbeslissingen — `/mh profadvice`, na `/reload`

**Waar te kijken:** Professions → Overview, of `/mh profadvice`.

- **Jewelcrafting** — de eerste stap (*Thoughtful Throughput*) hoort nu een getal te noemen:
  *"about 5 gets it working"*. Stond er eerst geen.
- **Inscription** — na *Perfected Products* hoort er een vierde stap te komen:
  **Darkmoon Curiosity**. ✅ De naam is al tegen jouw eigen client-capture gecontroleerd (0
  afwijkingen), dus als hij er níét staat is er iets ánders mis dan de naam.
- **Engineering / alle routes met een getal** — de adviesregel zegt er nu bij *"this step only
  ticks off once the branch is full"*.

🔴 **Wat ik onderweg vond en wat je moet weten:** jouw "de stap voltooit pas bij 30" was een
symptoom. Er is geen drempel van 30 — de code vinkt af bij **tak vol**, en 30 is toevallig
Recycling's maximum. Ik heb dus geen ander getal ingevuld maar de voorwaarde opgeschreven, want
een verzonnen 30 was net zo fout geweest als de 10.

📌 Zie je bij Inscription vier stappen maar staat *Darkmoon Curiosity* op een rare plek in de
volgorde: dat klopt met wat we weten. De eerste drie zijn gemeten, waar de vierde hoort niet — ik
heb hem achteraan gezet omdat dat niets kapotmaakt aan wat al klopte.

### 14. `/mh shots` — er is een tiende scène bij

**Wat je moet doen:** log in op een personage **met Midnight-beroepen** (Iceicebaby of Umbrion —
Tailoring/Enchanting), dan `/mh shots`, dan **`/reload`** (zonder reload worden de
SavedVariables niet weggeschreven en snijdt `tools\Crop-Shots.bat` verkeerd), dan die bat.

**Wat er nieuw is:** `10-professions-advice` — de Overview met de adviesregel erop.

🔴 **Waarom deze scène er toe doet en de andere negen niet vervangt:** op 31 augustus is over
zo'n twintig addons gemeten dat **geen enkele** je vertelt wáár je je Knowledge uitgeeft. Ze
tellen punten, ze simuleren crafts, ze maken boodschappenlijstjes. Het enige dat deze addon doet
en niemand anders, stond dus niet op je CurseForge-pagina.

⚠️ **Deze scène hangt als enige aan het ingelogde personage.** Draai je hem op je Warlock die de
beroepen weer heeft laten vallen, dan krijg je een eerlijke lege pagina — geen bug, wel een
waardeloze screenshot.

### 12. Valeera: `/mh poisons` en het verschil tussen `/mh curio` en `/mh curios`

**Wat je moet zien, na `/reload`:**

- `/mh poisons` — Valeera's poisons met per stuk de omschrijving die de client geeft, en een
  groene `>` bij degene die ze aan heeft. **Dit bestond al maanden maar stond nergens vermeld**,
  dus geen speler kon het vinden. Staat nu in `/mh` en in de zoekbalk.
- `/mh curios` — de **uitlegger**: wat elke curio doet.
- `/mh curio` (enkelvoud) — de **adviseur-popup**. ⚠️ Die deed het tot nu toe niet: beide namen
  gingen naar de uitlegger, terwijl de commandolijst ze als twee dingen aanbood. De adviseur was
  alleen via de Tools-lade en de zoekbalk te bereiken.

🔴 **De vraag die ik aan jou teruggeef:** enkelvoud tegenover meervoud is een beroerde scheiding
tussen twee functies — niemand onthoudt dat `/mh curio` iets anders doet dan `/mh curios`. Ik heb
nu alleen hersteld wat de lijst al beloofde. Wil je liever dat ze samensmelten (één commando dat
de adviseur opent, met de uitleg erin), zeg het dan — dat is een grotere maar eerlijkere ingreep.

✅ **AFGEHANDELD op de avond van 2 sep.** Rob koos samensmelten, en daarna nog een ronde: `/mh
poisons` is nu een **alias van `/mh curios`** (het gif is gewoon één van de drie keuzeslots), en
`/mh curio`/`/mh curios` kiezen zelf tussen adviseur en uitlegger. Alles hierboven is dus
achterhaald behalve als geschiedenis. Getest en goedgekeurd door Rob dezelfde avond.

---

### 15. ☑️ AFGEVINKT OP ROBS GEZAG 3 sep — het consumables-bord haalt nu zélf op

⚠️ **Dit is NIET in het spel gezien.** Rob, 3 sep: *"de cisca consumable test mag je van mij
afvinken, ik meld me als het later toch niet goed blijkt te zijn."* Dat is zijn keuze en die telt —
maar de status is *"aanvaard zonder proef"*, niet *"werkt"*. Komt hier ooit een melding over
`(bag unknown)` die blijft staan, begin dan hier en niet bij iets nieuws.

De testinstructie hieronder blijft staan, want zij is de enige manier om het alsnog te bewijzen.

**Waarom dit er is:** iedereen stuurde zijn tas-tellingen alleen **uit zichzelf** rond, bij een
roster-wijziging of een zone-wissel. Zat je op dat moment in een laadscherm, dan miste je dat
bericht **voorgoed** — er was geen enkel bericht dat er ooit opnieuw om vroeg. Nu vraagt het bord
erom zodra het opengaat.

⚠️ **Cisca hoeft niets te typen en ziet niets.** Geen venster, geen geluid, geen chatregel. Haar
client krijgt een verborgen berichtje en stuurt dezelfde tellingen terug die hij nu al ongevraagd
rondstuurt. Merkt zij er iets van, dan is dát de bug.

**De schoonste proef is de kapotte situatie, en die heb jij zelf in de hand:**

1. Jullie zitten samen in een groep, allebei op deze versie.
2. **Jij** doet `/reload`. (Dat wist jouw ontvangen gegevens; ze worden niet bewaard.)
3. Wacht rustig tien seconden — niet zonewisselen, niet uitnodigen. Er gebeurt nu niets dat
   Cisca's client aan het praten krijgt. **Precies dit was de kapotte toestand.**
4. Open het bord: `/mh board`.

**Wat je moet zien:** Cisca's regel vult zich met echte tas-iconen (flask, rune, potions, food,
hearthstone) in plaats van *"(bag unknown)"*. Dat mag een fractie later gebeuren — het verzoek gaat
uit, haar antwoord komt terug, en het bord hertekent **terwijl het openstaat**.

🔴 **Let juist op dat laatste**, want dat was een tweede bug die ik bij het bouwen vond: een
antwoord dat binnenkwam terwijl het bord openstond werd wél opgeslagen maar **niet getekend** — je
zag het pas als je het bord sloot en opnieuw opende. Moet je nog steeds sluiten-en-openen, dan
werkt dat stuk niet.

**Tegenproef (bewijst dat het niet toevallig was):** doe stap 2 t/m 4 nog eens, maar open het bord
**niet**. Vraag Cisca iets uit haar tassen te gooien of bij te kopen. Zolang jouw bord dicht blijft
verandert er niets — het verzoek gaat pas bij het openen.

⚠️ **Niet in de war laten brengen:** ontvangen regels verlopen sowieso na tien minuten
(`STALE = 600`). Duurt jullie sessie langer, open het bord dan opnieuw in plaats van te concluderen
dat er iets stukging.
