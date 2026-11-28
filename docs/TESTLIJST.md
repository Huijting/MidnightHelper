# Testlijst — wat wacht er op Rob

📱 **Deze lijst staat ook als afvinkpagina op Robs telefoon:**
<https://claude.ai/artifact/2SbQS4EfWH1BCxDuHut2C4> (21 sep 2026, 20 open punten na de tweede verhuizing).
Bouwen/bijwerken: `python tools/_probe.py run testlist_page`, daarna de Artifact-tool met die URL
(`capabilities {db:{}}`). Robs vinkjes en notities staan in de db van die pagina, in `state/checks`;
deze markdown blijft de bron — de pagina wordt eruit gegenereerd, nooit andersom.
**Vinkjes terugzetten** (16 sep, Rob: *"zijn er wel heel veel"*): lees `state/checks`, zet de id's met
`"s":"ok"` in een bestand, en `python tools/_probe.py run testlist_page apply <bestand> "<wie, datum>"`.
Dat zet ze hier op `[x]` en bouwt de pagina opnieuw; een "niet goed" blijft open. De pagina opent
standaard op *Nieuwste* (de twee jongste datums in de koppen).

**Lopende lijst.** Rob, 27 aug 2026: *"we gaan later alles proberen, onthoud dit en dan maken
we straks een lijstje wat ik in een keer kan testen"*. Alles wat gebouwd maar niet in het spel
gezien is, komt hier te staan tot hij het afvinkt.

⚠️ **Bouwen is niet testen.** Een module die laadt zonder foutmelding heeft alleen bewezen dat
hij laadt. Zet niets hieronder op ✅ omdat het "zou moeten werken".

📦 **Oudere rondes staan in [`TESTLIJST_ARCHIEF.md`](TESTLIJST_ARCHIEF.md)** (afgesplitst 17 sep 2026,
op Robs verzoek; 21 sep volgden de rondes van 16 en 17 sep). Deze lijst houdt de jongste testrondes;
er is niets weggegooid.
⏹️ **20 nov 2026, derde verhuizing** (Rob via sparring: *"Beide ja"*): alle secties met een kopdatum vóór 10 nov staan
nu in het archief, hun open punten als `[vervallen, niet getest]` (1068 punten; NIET getest, NIET goedgekeurd). Hier
bleven 697 open punten. Blijven staan: "9 nov — Deze week in Forever" (noemt ook latere datums) en de kop zonder datum
"EERST, thuis … Beter dan wat je draagt" (19 nov).

## 28 nov — FOREVER het levende blok: "Low on health?" en de wand los

`/reload` is genoeg. Offline getest (live_test: Robs priest-situatie), NIET in het spel.
- [ ] Je Undead Priest (Holy, level 6): "Order now" = Power Word: Shield (**Z**) → Shadow Word: Pain (**2**) → Smite
      (**1**). Daaronder "Low on health? Lesser Heal (**C**)." en "Low on mana? Shoot (**4**) with your wand."
- [ ] Op level 8 met Renew: "Low on health? Renew (**…**) or Lesser Heal (**C**)."
- [ ] Paladin, Druid (caster), Shaman onder 10: hun heal (Holy Light / Rejuvenation, Healing Touch / Healing Wave) staat
      niet in de rij maar in een losse "Low on health?"-regel. Warlock: géén wand-regel (Shoot staat niet op het blok).

## 28 nov — FOREVER het levende blok: voor iedereen onder 10, en Auto Shot / Raptor Strike los

`/reload` is genoeg. Offline getest (live_test: o.a. Priest Holy 6, Paladin Ret 6, Warrior Arms 6, Druid zonder richting
6, Hunter 6, Fury 15, level 10 = weg), NIET in het spel.
- [x] Je Undead Priest (Holy, level 6): bovenaan Start nu ook "Until level 10", met "Your keys right now, and what comes
      next:" en daaronder Now / Order now / Next. De Holy-rol staat eronder. ✅ Rob in-game, 28 nov (screenshot, via
      Sparring: Now Smite 1, SW:P 2, Shoot 4, PW:S Z, Lesser Heal C, Will of the Forsaken Shift-E; Next 8 Fade, Renew).
- [x] (✅ Rob in-game, 28 nov, screenshot) Hunter (level 6): "Order now" eindigt bij Arcane Shot (**3**). Daaronder "Auto Shot starts by itself when you press
      **2**, **3**. Stopped? **Shift-Z**." en "Enemy next to you? Raptor Strike (**Shift-X**), with a melee weapon in
      your hand."
- [ ] Mage (onder 10, met Frost Nova): Frost Nova staat niet in de rij maar los: "Enemy close to you? Frost Nova (**V**),
      then step away."
- [ ] Op level 10 is het blok weg (behalve Cat- of Fury-richting: die houden het tot 20).

## 28 nov — FOREVER Skill up Enchanting: geen gat meer bij skill 1-5

`/reload` is genoeg. Offline: de route-generator (controles OK, Enchanting zonder gaten tot 300). NIET in het spel.
- [ ] Een character met Enchanting op skill 1-20: `/mh skillup` → Enchanting → Route to 300. De eerste stap is nu
      "make … Runed Copper Rod" (tot 7), daarna Enchant Bracer - Minor Health (tot 22). Niet meer "Skill 1 to 5: MH knows
      no recipe here".

## 28 nov — FOREVER toetsenplan, laatste stap: Mage Frost (Frostbolt op 1)

`/reload` is genoeg. Offline getest (swap3_test 5/5, beide indelingen), NIET in het spel. Op een mage met het blok:
- [ ] How you play → richtingknop → kies **Frost**: één keer de melding "Key 1 is now Frostbolt. Fireball moved to 2."
      (vanaf level 4); toets 1 = Frostbolt, 2 = Fireball. Onder level 4: 1 = Fireball, 2 leeg.
- [ ] Kies een andere richting (Fire of Arcane): 1 = Fireball (of Arcane Blast met dat talent), 2 = Frostbolt.
- [ ] Schakelaar "Swap keys …" uit: 1 = Fireball, 2 = Frostbolt, ook met Frost.
- [ ] Met 12x4 en Frost: How you play noemt "Frostbolt (1)" en "Fireball (2)".

## 28 nov — FOREVER How you play: het "Until level 10"-blok leeft mee

`/reload` is genoeg. Offline getest (live_test: hunter level 6 en 8, alle classes x richtingen x level 1-20), NIET in
het spel. Op je hunter (level 6-7), How you play → tab Start, bovenaan "Until level 10":
- [ ] **Now (level 6):** alleen de toetsen die nu iets doen, bv. "**1** = Hunter's Mark · **2** = Serpent Sting · **3** =
      Arcane Shot · **Shift-Z** = Auto Shot · **Shift-X** = Raptor Strike". Niets wat je nog niet hebt.
- [ ] **Order now:** "Hunter's Mark (**1**) → Serpent Sting (**2**) → Arcane Shot (**3**) → Auto Shot (**Shift-Z**) →
      Raptor Strike (**Shift-X**)".
- [ ] **Next:** "at level 8 you get Concussive Shot (key Shift-Q), Parry."
- [ ] Ding naar 8 en leer Concussive Shot: binnen een seconde staat **Shift-Q** = Concussive Shot bij Now, en Next zegt
      level 10 (Aspect of the Hawk op Shift-R).
- [ ] Op level 10 is het hele blok weg.

## 28 nov — FOREVER toetsenplan stap (b): Mage Arcane, Rogue, Shaman Enhancement

`/reload` is genoeg. Offline getest (swap2_test 5/5: beide indelingen, vóór/na het talent, schakelaar uit, de melding,
How you play in 12x4), NIET in het spel. Alleen te zien op een character MET dat talent (en het blok geplaatst):
- [ ] Mage met Arcane Blast (talent, vanaf 20): één keer de melding "Key 1 is now Arcane Blast. Fireball moved to
      Ctrl-2."; toets 1 = Arcane Blast, Ctrl-2 = Fireball. Mage zonder dat talent: niets verandert (1 = Fireball).
- [ ] Rogue met Hemorrhage (30) of Mutilate (40): melding "Key 1 is now Hemorrhage/Mutilate. Sinister Strike moved to 3.";
      1 = dat talent, 3 = Sinister Strike, Shift-3 = Shank. Combat-rogue zonder die talenten: niets verandert (1 =
      Sinister Strike, 3 = Shank in 12x4). In Stealth blijft 1 Garrote.
- [ ] Shaman met Stormstrike (25): melding "Key 1 is now Stormstrike. Lightning Bolt moved to 3."; 1 = Stormstrike,
      3 = Lightning Bolt. Zonder dat talent: niets verandert.
- [ ] Schakelaar "Swap keys when you learn a better spell" uit: bij alle drie de oude toetsen terug.
- [ ] How you play bij die classes: de talentspell op **1**, en in 12x4 de verschoven spell op zijn nieuwe toets.

## 28 nov — FOREVER toetsenplan stap (a): Hunter's Mark op 1, Auto Shot op Shift-Z

`/reload` is genoeg. Offline getest (swap_test 5/5: beide indelingen, level 5 en 6, schakelaar aan/uit, de melding),
NIET in het spel. Voor jou: je level-6 hunter met 12x4 (je kent Hunter's Mark al).
- [x] Na `/reload`, buiten een gevecht: in het midden van je scherm één grote melding "Key 1 is now Hunter's Mark. Auto
      Shot moved to Shift-Z." en dezelfde regel in de chat. Je hoeft niets te doen (je Shift-Z-macro bestond al).
      ✅ Rob in-game, 28 nov: *"de Hunt gaf inderdaad groot in beeld. Key 1 is nou Hunt mark, Outshot move to shift set."*
- [x] Je balk: toets **1** toont Hunter's Mark, **Shift-Z** toont Auto Shot. ✅ Rob, 28 nov: *"Shift set staat Outshot klopt ook."*
- [ ] Druk 1 op een vijand: Hunter's Mark, en je gaat NIET schieten. Druk 2 (Serpent Sting) of 3 (Arcane Shot): Auto Shot
      start vanzelf. Shift-Z start Auto Shot; nog een keer Shift-Z stopt hem niet.
- [x] Nog een `/reload`: de melding komt NIET nog een keer. ✅ Rob, 28 nov: *"Na de reload komt hij inderdaad niet terug"*.
- [ ] Toetsen & macro's → Schakelaars: "Swap keys when you learn a better spell". Zet hem uit: 1 = Auto Shot, Shift-Z =
      Hunter's Mark (zoals vroeger). Weer aan: terug naar de wissel.
- [x] (✅ Rob, 28 nov: *"Ook in How to Play staat het goed."*) How you play → Start en Your keys: "Hunter's Mark (1)" en "Auto Shot (Shift-Z)" in de volgorde, de rollen en "Levels
      1-10"; bij "What comes later" de regel "- 6: Hunter's Mark takes key 1 …".
- [ ] (Als je een nieuwe hunter maakt, onder level 6): toets 1 = Auto Shot, Shift-Z is leeg. Op level 6, na het leren van
      Hunter's Mark: de melding, met erbij "Open /mh block and press Update (add new spells) once" als Shift-Z nog geen
      macro had.

## 28 nov — FOREVER Fable-feitencheck: munitie, Death Mark, Prayer of Fortitude, 3 teksten

`/reload` is genoeg. Offline getest (fable9_test, lvl_test 16/16), NIET in het spel.
- [ ] Hunter met munitie die NIET in de winkel ligt (bv. Thorium Shells, zelfgemaakte kogels, of Forever's Swiftfeather
      Arrow): Do this now zegt niet meer "Out of ammo (0 left)" en je krijgt geen grote melding zolang je er genoeg hebt.
- [ ] Rogue met Death Mark (talent op 40), in Stealth: Q werkt nu (Death Mark breekt Stealth niet). Met Adrenaline Rush
      doet Q in Stealth nog steeds niets.
- [ ] Priest op level 60 met Prayer of Fortitude rang 2: geen "You have no Holy Candle" meer; alleen Sacred Candle telt.
- [ ] Warrior, How you play: bij Sunder Armor staat niet meer "(every stance)"; bij Concussion Blow staat alleen "(a stun)".
- [ ] Shaman, How you play → "Totems and weapon buffs": "Searing (**5**)" is een vette toets, geen "(lvl 5)".

## 28 nov — FOREVER drie kleine fixes: Lacerate, grijze "Not learned yet"-regel, Priest Shield

`/reload` is genoeg. Offline getest (fix3_test), NIET in het spel.
- [ ] Druid op level 34 of hoger ZONDER het talent Lacerate: de trainer-lijst noemt Lacerate niet meer (ook niet onder
      "Needs something else first"). MET het talent: Lacerate rang 2 staat er op 34 gewoon bij.
- [ ] Druid, How you play → Simple order: de grijze regel "Not learned yet" noemt nooit een losse "Heal".
- [ ] Priest onder level 6: de volgorde begint met "Power Word: Shield (Z)", en de grijze regel noemt "Power Word: Shield
      (level 6)". Geen losse "Heal" (alleen "Lesser Heal" als je die nog niet hebt).

## 28 nov — FOREVER How you play: "(lvl 4)" en Raptor Strike heeft een melee-wapen nodig

`/reload` is genoeg. Offline getest (lvl_test: 8 talen x 2 indelingen, aantal levels per class gelijk aan het Engels),
NIET in het spel.
- [ ] How you play → Start en Your keys: levels tussen haakjes staan er nu als "(lvl 1)", "(lvl 4)", "(lvl 10)" — ook de
      eerste. Toetsen tussen haakjes ("Raptor Strike (Shift-X)" in de volgorde) hebben géén "lvl".
- [ ] Hunter, "Levels 1-10": bij Raptor Strike staat dat je een **melee weapon** in je main hand nodig hebt (je begin-bijl
      of -dolk telt, een Skinning Knife niet).
- [ ] De volgorde zegt "Raptor Strike (…), with a melee weapon in your hand".
- [ ] Beginner mistakes (tab Start) heeft een nieuwe regel: Raptor Strike, Wing Clip, Mongoose Bite, Counterattack en
      Disengage doen niets zonder melee-wapen.
- [ ] Met 12x4: in Beginner mistakes staat nu ook de 12x4-toets ("use Raptor Strike (Shift-X)"), niet meer "(5)".
- [ ] Rogue (als je er een hebt): "Eviscerate (**4**) … Rupture (**5**)" zijn vetgedrukte toetsen; Paladin: "first (**3**)".

## 28 nov — MIDNIGHT Codex: Venomstones met aantallen

`/reload` is genoeg. Alleen tekst veranderd.
- [ ] Codex → Raid → **Ascendant Venomstones (12.1.5)**. Onder "Where they drop" staat nu een lijstje: Mythic raid boss 4,
      Heroic raid boss 2, Mythic+ +10: 1, +14: 2, +18: 3, een Bountiful Coffer in een Tier 11-delve: 1, een Nightmare
      Prey-kist: 1. Staat alles netjes onder elkaar?

## 28 nov — FOREVER How you play: blokje "Until level X" onder het startlevel van je rol

`/reload` is genoeg. Op een character ONDER level 10, het liefst je hunter. Offline getest (early_test, 8 talen; alle
classes x richtingen x level 1-60 zonder fout), NIET in het spel.
- [ ] Hunter onder 10, richting Beast Mastery (of geen richting): open How you play → tab **Start**. Bovenaan staat
      **Until level 10**, met "Your role (Beast Mastery …) starts at level 10" en daaronder je toetsen van nu
      ("Levels 1-10: your buttons") en een volgorde zonder pet.
- [ ] De volgorde van de hunter (ook in tab Start, onder het blokje) begint nu met Hunter's Mark, en pas aan het eind:
      "From level 10: Aspect of the Hawk on … send your pet in (Ctrl-1)". Geen "Pet in first" meer.
- [ ] Met 12x4: bij Call Pet staat **Ctrl-4** (niet Ctrl-2). Ctrl-2 is alleen "follow you".
- [ ] Ding naar level 10 met het venster open: binnen een seconde is het blokje weg. (Of na het opnieuw openen.)
- [ ] Ook goed om te zien (als je zo'n character hebt): Warrior met richting Protection onder 10, Mage Frost op level
      1-3 ("Until level 4"). Een Warrior of Druid ZONDER richting krijgt géén blokje (Arms en Balance beginnen op 1).

## 28 nov — FOREVER reputatie: Cenarion Circle-tip klopt weer

`/reload` is genoeg. Alleen tekst veranderd.
- [ ] Open het Forever-overzicht → **Reputation & currency** en zoek Cenarion Circle. Bij "How:" staat nu: "Quests in Silithus. Handing in
      Encrypted Twilight Text over and over is switched off in Forever (Blizzard, 25 Nov)." De oude tekst over "level
      55-60" is weg.

## 27 nov — FOREVER Skill up: de route eenvoudiger

`/reload` is genoeg. Open `/mh skillup`, kies een beroep en klik links op **Route to 300**. Offline getest
(simple_test, 416 toestanden), NIET in het spel.
- [ ] Bovenaan een blauwe balk met "<beroep>: 62 / 300" (jouw skill), met gele streepjes en de getallen 50, 125 en 200
      eronder. Streepjes die je al voorbij bent zijn grijs. Staat alles netjes, of loopt er iets door elkaar?
- [ ] Daaronder één grote regel met wat je NU doet. Bijvoorbeeld "Now: make about 14x … You have everything for it." of
      "Now: you are missing 42 … " met daaronder waar je het krijgt. Klopt dat met je tassen?
- [ ] Zit je skill op je maximum (bv. 75/75), dan zegt de grote regel: naar je trainer voor de volgende rang.
- [ ] Een regel "What comes next:", bv. "at skill 50, visit your trainer for the next rank."
- [ ] Onderaan in gewone woorden: de kleuren (oranje = altijd een punt … grijs = nooit) en wat "Rank" is.
- [ ] Links een nieuwe knop **Show the whole route**: dan komt de lange lijst met de boodschappenlijst eronder. Nog een
      klik (Hide the whole route) en hij is weer weg. Na `/reload` blijft je keuze staan.
- [ ] Muisaanwijzer op een recept of spul in de grote regel: de gewone tooltip van het spel.
- [ ] Knop **Next step**: het oude scherm, zonder balk.

## 27 nov — FOREVER toetsblok: vormen/standen-ronde (warrior, druid, rogue) + 4 testjes vooraf

`/reload` is genoeg voor wie de Undo + Place van vandaag al deed; anders eerst die (zie de druid-sectie hieronder).
Offline getest (stance_test 5 van 5, guard_test, swipe_test), NIET in het spel.
- [ ] Warrior 12x4, Defensive Stance: toets **4** = Sunder Armor. In Battle en Berserker blijft 4 Execute. Shift-C is nu
      leeg. (In Battle/Berserker staat Sunder dus niet meer op het blok in 12x4 — zeg het als je dat mist.)
- [ ] Warrior 12x4, Berserker Stance: Shift-V = Concussion Blow (als je het talent hebt).
- [ ] Druid 12x4 als beer: **X** = Demoralizing Roar; als kat en caster blijft X Nature's Grasp. Shift-2 als beer doet
      niets meer (als caster Wild Growth).
- [ ] Rogue in Stealth: Z (Evasion), Shift-1 (Blade Flurry) en Q (Adrenaline Rush) doen niets; je blijft in Stealth.
      Buiten Stealth werken ze gewoon. Keys-tab: schakelaar "Rogue: Evasion, Blade Flurry and Adrenaline Rush do nothing
      in Stealth" uit = het oude gedrag. (Q doet dan in Stealth ook geen Death Mark.)
- [ ] How you play in 12x4 noemt bij de druid "Frenzied Regeneration (**C**)", "Nature's Grasp (**X**)" en
      "Demoralizing Roar (**X**)"; bij de warrior "Sunder Armor (**4**)" en "Berserker Rage (**Z**)".
**De 4 testjes VÓÓRDAT we de rest bouwen** (zeg per stuk wat er gebeurt):
- [ ] (1) Night Elf druid in Bear Form: druk Shift-E (Shadowmeld). Blijf je beer, of ga je uit je vorm?
- [ ] (2) Druid in Moonkin Form: druk C (Healing Touch). Ga je uit Moonkin, of krijg je alleen een foutmelding?
- [ ] (3) Shadow priest in Shadowform: druk C (een heal). Ga je uit Shadowform, of alleen een foutmelding? En werkt Fear
      Ward in Shadowform wel of niet?
- [ ] (4) Druid in Cat Form met Prowl aan: werkt Shred (3) nog, en verandert je balk (bonusbar 2)? `/dump GetBonusBarOffset()`
      in Prowl zegt het getal.

## 27 nov — FOREVER Druid: Ferocious Bite als kat op C (niet meer Shift-4)

`/reload` is genoeg (na de Undo + Place van de sectie hieronder). Offline getest (swipe_test, beide indelingen).
- [ ] Druid in Cat Form, vanaf 24: toets **C** = Ferocious Bite. Als beer blijft C Frenzied Regeneration, als caster
      Healing Touch.
- [ ] Shift-4 is als caster Swiftmend (een talent) en doet in een vorm niets.
- [ ] How you play → Cat: "Ferocious Bite (**C**, from 24)" en "Ferocious Bite (**C**) at 24".

## 27 nov — FOREVER Druid: caster-toetsen doen niets in beer/kat + eigen macro's per character

`/reload`, daarna ÉÉN keer per character met het toetsblok: `/mh keyblock` → Undo → "Place it on bars 5, 6 and 7"
(zo komen de eigen macro's op je balk; de oude gedeelde "MH 4" enz. blijven staan maar MH raakt ze niet meer aan).
Offline getest (guard_test, swipe_test), NIET in het spel.
- [ ] Druid in Bear Form, druk 2: er gebeurt NIETS, je blijft beer (het knopje toont een "?"). Buiten een vorm: Moonfire.
- [ ] Hetzelfde voor C (Healing Touch), Shift-X, Shift-Z, Shift-C, Shift-Q en Ctrl-R (Revive/Rebirth) in beer en kat.
- [ ] Blijven werken in beer: Ctrl-1/2/3 (vormen), R (Travel/Aquatic Form), X (Nature's Grasp), Z (Barkskin), Shift-F
      (Faerie Fire), Shift-E (race-spell), en 1-4 met hun beer-spells.
- [ ] Toets 4 op de druid: Swipe als beer (NIET meer Fire Blast van de mage). Log daarna op de mage in en weer terug:
      de druid-toets blijft Swipe.
- [ ] Keys-tab van het overzicht: schakelaar "Druid: caster keys do nothing in Bear and Cat Form" uit = het oude gedrag.
- [ ] `/mh keyblock` → "Why these keys?": onderaan "Druid: a ? in Bear or Cat Form" met de uitleg en de autoUnshift-tip.

## 27 nov — FOREVER Druid: Swipe als beer op 4 (niet meer Shift-1)

`/reload` is genoeg: MH schrijft je bestaande blok-macro's ("MH 4") bij het inloggen opnieuw. Offline getest
(swipe_test, beide indelingen), NIET in het spel.
- [ ] Druid, Bear Form, minstens level 16: toets **4** = Swipe. Als kat blijft 4 Rip, als caster Insect Swarm.
- [ ] Shift-1 doet als beer niets meer; als caster (vanaf 40) Hurricane. Heb je nog geen Hurricane, dan houdt de oude
      Shift-1-macro voorlopig ook Swipe — geen probleem.
- [ ] How you play → Bear: "Swipe (**4**, from 16)" en "Swipe (**4**) at 16".

## 27 nov — BEIDE GAMES: één MH-venster tegelijk, met Terug en Home (keuze B)

HERSTART het spel één keer (nieuw bestand). Offline getest (stack_test), NIET in het spel.
- [ ] Midnight: open MH, kies Dungeons en open een dungeon (het Bosses-venster). Het MH-hoofdvenster gaat DICHT; boven op
      het nieuwe venster staan de knoppen "< Back" en "Home".
- [ ] Open vanuit dat venster de kaart (Bosses / map): het vorige venster gaat dicht. "< Back" brengt je terug naar het
      vorige venster, nog een keer "< Back" naar het hoofdvenster. "Home" gaat meteen naar het hoofdvenster.
- [ ] Een venster dat je zelf "Dock to window" gaf (Midnight): het hoofdvenster blijft ernaast open.
- [ ] Forever: open het overzicht, kies bv. Skill up of Vendors: het overzicht gaat dicht, "Home" brengt het terug.
- [ ] Kleine helpers blijven staan: Do this now, de klikkaart, de Move-balk, meldingen, Bags full, het toetsblok.
- [ ] Settings → "Keep several windows open" aan: alles blijft open zoals vroeger. `/mh windows` zegt wat MH ziet.
- [ ] Staan de knoppen "< Back"/"Home" ergens lelijk of half buiten beeld (venster helemaal bovenaan)? Zeg welk venster.

## 27 nov — FOREVER: grote melding als munitie of reagents bijna op zijn

`/reload` is genoeg (na de herstart voor de sectie hieronder). Offline getest (cvend_test), NIET in het spel.
- [ ] Hunter met een boog: schiet tot je 50 pijlen of minder hebt. Midden in beeld "Ammo: only 50 left!" met een
      geluidje, en in de chat de dichtstbijzijnde verkoper. Schiet verder: GEEN tweede melding.
- [ ] Koop pijlen (boven de 50), schiet weer tot 50: weer één melding.
- [ ] Zakt het tijdens een gevecht onder de 50: de melding komt pas direct NA het gevecht.
- [ ] Mage/shaman/paladin/druid: 3 of minder van een reagent voor een spell die je kent (bv. 3 Rune of Teleportation):
      "Rune of Teleportation: only 3 left!".
- [ ] `/mh vendor alert ammo 100`: de grens is 100. `/mh vendor alert`: wat MH besliste en waarom.
- [ ] Quiet helpers → "Alert when ammo or reagents run out" uit (of `/mh vendor alert off`): geen melding meer; de
      regel in Do this now blijft (die heeft zijn eigen schakelaar).

## 27 nov — FOREVER: class reagents en munitie, met de dichtstbijzijnde verkoper

HERSTART het spel één keer (nieuwe bestanden). Offline getest (cvend_test), NIET in het spel.
- [ ] Een mage vanaf 20 met Teleport en GEEN Rune of Teleportation: Do this now "You have no Rune of Teleportation for
      Teleport: …; nearest seller: … (zone, yd). /mh vendor reagent". Heb je er 1-4: een tip "Only 3 … left". 5 of meer:
      niets. (Zelfde voor Ankh bij een shaman, Symbol of Divinity bij een paladin, seeds bij een druid.)
- [ ] Een druid met twee rangen Rebirth: MH noemt het zaad van je HOOGSTE rang, niet Maple Seed.
- [ ] Een hunter met een boog en minder dan 200 pijlen: tip "Ammo: … left, less than one stack. Best for your level:
      Razor Arrow (op 25+) …". Geen pijlen: in Do this now "Out of ammo". Een geweer: kogels.
- [ ] Gebruikt Forever munitie echt op? (Zygor zegt ja, MH heeft het niet gemeten.) Schiet een paar keer en kijk of het
      aantal pijlen in je tas zakt.
- [ ] Find (of `/mh vendor reagent`, `/mh vendor arrows`): een lijst "Reagent" / "Arrow" / "Bullet" met verkopers aan
      jouw kant, dichtstbijzijnde eerst, met de pijl-knop. Bij pijlen alleen verkopers met pijlen voor jouw level.
      Een warrior ziet geen "Reagent", een mage geen "Arrow".
- [ ] Bij die verkoper: verkoopt hij het echt? (De lijst komt uit Zygor.) `/mh vendor check` zegt wat MH besliste.
- [ ] Quiet helpers → "Class reagents and ammo in Do this now" uit: de regels zijn weg (Find blijft).

## 27 nov — FOREVER: melding voor een bruikbare of grotere tas

`/reload` is genoeg. Offline getest (bag_test: omdoen, wisselen, niet leeg, niets bij kleiner/pijlkoker, schakelaar,
Not this one, tooltip, 7 talen), NIET in het spel.
- [ ] Lege tasplek + een losse gewone tas (zoals de Small Green Pouch op Ima Hunterdude), tassen NIET vol: Do this now
      gaat vanzelf open met "Bag: Small Green Pouch (6 slots). You have an empty bag slot. [Put it on] [Not this one]".
      Klik Put it on: de tas zit om, de regel is weg.
- [ ] Geen lege tasplek, wel een grotere losse tas: "Bag: … (10 slots) is bigger than your … (6). [Swap]". Zit er nog
      iets in die kleine tas: "Empty your … first (3 items in it), then Swap." en Swap doet niets behalve die zin.
- [ ] Is de kleine tas leeg: Swap. De grote zit om, de kleine ligt in je tas. (Dit is het spannende stuk: MH doet wat
      slepen op die tasknop doet; in het spel nog nooit gezien.)
- [ ] Muis op een gewone tas (ook bij een verkoper): "MH: 4 slots more than your smallest bag (…, 6)." Een kleinere
      tas, een pijlkoker of ammo-zak: geen regel.
- [ ] Quiet helpers → "Tell me about a usable or bigger bag" uit: de regel en de tooltipregel zijn weg.

## 27 nov — FOREVER: de hele route 1-300 in Skill up

HERSTART het spel één keer (nieuw bestand). Offline getest (route_test: 56 teksten, 8 beroepen), NIET in het spel.
- [ ] `/mh skillup` → links onder de beroepen een knop **Whole route 1-300**. Klik: rechts staat "<beroep>: the whole
      route to 300", met groen `>>` voor de stap waar je nu bent. Nog een klik ("Next step"): het oude venster.
- [ ] De stappen beginnen bij JOUW skill (niets eronder). Ranglijnen staan op 50 / 125 / 200 ("Train the next rank").
- [ ] Bij een recept dat je nog niet kent: "Learn …" met eronder waar je het haalt. Ken je het al: geen Learn-regel.
- [ ] Onderaan "Shopping list for the rest of the route": per ding nodig / je hebt / nog zoveel. Tellen tas + bank mee?
- [ ] Cooking of First Aid boven 150: "Next rank … from a book or a quest, not a trainer".
- [ ] Belangrijk: zegt het spel bij een stap dat het recept al GRIJS is? Zeg welke. (MH rekent met Blizzards eigen
      Forever-kleuren; die klopten 3 van 3 met jouw beroepsvenster.)

## 27 nov — FOREVER: waarschuwing bij Dual Spec (je balken na een wissel)

`/reload` is genoeg. NIET in het spel getest. Hoort NIET bij 5.11.0 (komt in de volgende versie).
- [ ] Een Forever-character van level 40 of hoger zonder Dual Spec: Do this now noemt Dual Spec, en direct daarachter
      staat "Careful: players report that switching can change your action bars … Check them after your first switch."
- [ ] `/mh play` (How you play) → tabblad **Group** → stuk "Talents: reset and Dual Spec": een nieuwe regel "Your bars
      after a switch", tussen "Switching" en "Why".
- [ ] Heb je Dual Spec al? Wissel één keer en kijk of het spel spells op je balken zette. Dan weten wij of de meldingen
      kloppen.

## 26 nov laat — FOREVER: "ongeveer gelijk" in plaats van "Upgrade" (Robs riemen)

`/reload` is genoeg. Offline getest (side_test 8/8), NIET in het spel. Hoort NIET bij 5.11.0 (komt in de volgende versie).
- [ ] Muis op de Handstitched Leather Belt terwijl je de Aquarius Belt draagt: een GELE regel "MH: about equal to what
      you wear: +1 Strength, -2 Stamina, -2 Intellect, -9 Armor (main stats for a Druid (Feral Combat)). No need to
      swap." Geen groene "Upgrade"-regel, en Do this now zegt niet meer "Upgrade … Wear it" voor die riem.
- [ ] Een echte upgrade (duidelijk meer Strength/Agility) blijft groen, en noemt nu "Druid (Feral Combat)".
- [ ] Wil je healen: `/mh direction` → Restoration. Dan telt MH Intellect, Spirit en healing.

## 26 nov — 5.11.0 in MIDNIGHT (vanavond, vóór de release)

HERSTART het spel één keer (nieuwe bestanden). Dit is het Midnight-deel; het Forever-deel staat in de secties hieronder.
- [x] Inloggen zonder rode foutmelding. ✅ Rob, 26 nov (Holy Paladin): *"verder geen fout melding verder"*.
- [ ] De "what's new"-popup toont 5.11.0 met 8 regels.
- [x] Een healer: `/mh clickcard` opent de klikkaart met je klikken. ✅ Rob, 26 nov (screenshot: Plain Holy Shock / Word of
      Glory / Flash of Light, other layers, "Print (website)", See-through): *"De eerste is goed"*.
- [ ] Knop "Print (website)" op de klikkaart: het kopieervenster opent. Plakken op midnighthelper.com (Key block) geeft je
      toetsen en het vak met klikken.
- [x] `/mh move` (OPNIEUW, na de fix van 26 nov avond): de EERSTE keer meteen de balk én alle groene vakken; Done stopt
      hem; Escape ook. Geen "Dock to window" meer op de balk (over Done heen) en niet op de klikkaart naast het kruisje.
      ❌ eerder: eerste keer alleen de balk (Move zette zichzelf meteen uit), Done deed toen niets.
      ✅ Rob, 26 nov (via Sparring): *"ik had de extra testen op midnight al gedaan, vandaar de release"* (ce0ad85).
- [ ] Toetsblok: knop Undo zegt eerst wat hij doet; iets wat je zelf op een knop zette, blijft staan.

## 26 nov — Je hele naam op de spiekbrief ("Ima Druiddude")

`/reload` is genoeg. Offline getest (undo_test 42/42, cq_test 36/36), NIET in het spel.
- [ ] `/reload`, plak de spiekbrief opnieuw: bovenaan staat "Which click heals what · Ima Druiddude".
- [ ] Muis op Earthroot (of een ander quest-item): je eigen character staat niet in de lijst; je Horde-alts staan bij "can
      mail it to you", niet bij "other realm".

## 26 nov — Druid: de latere klik-spells (Rebirth, Innervate, Wild Growth)

`/reload` is genoeg. Offline getest (click_test 38/38), NIET in het spel.
- [ ] `/mh clickcard`: onder "Other layers" staan grijs: Shift + middle = Rebirth "level 20", Shift + right = Innervate
      "level 40", middle = Wild Growth "talent".
- [ ] Zodra je level 20 bent en Rebirth hebt: Shift + middelste knop op een groepsframe cast Rebirth.

## 26 nov — Spiekbrief: de spells achter je Forever-toetsen

`/reload` is genoeg. Offline getest (undo_test 39/39), NIET in het spel.
- [ ] `/reload` op je druid, dan de spiekbrief opnieuw plakken op midnighthelper.com (Key block). Bij 1, 2, Q, F … staan nu
      spells (zoals Wrath), niet een leeg vak.

## 26 nov — Bedanken voor een buff ná het gevecht

`/reload` is genoeg. Offline getest (thanks_test 10/10), NIET in het spel. Alleen als "thanks for a buff" aan staat.
- [ ] Krijg tijdens een gevecht een buff van een vreemde. Tijdens het gevecht gebeurt niets. Is het gevecht binnen een
      minuut voorbij, dan zie je in chat "You thank <naam>."
- [ ] `/mh thanks` zegt dan bij "last decision": "… thanked after combat by …". Duurde het gevecht langer dan 60 s, dan
      staat er "the fight lasted too long".

## 26 nov — Klik-heals op papier (Forever en Midnight)

`/reload` is genoeg. Offline getest (undo_test 34/34, card_test 26/26), NIET in het spel. Het printblad zelf komt pas als de
site-chat /keyblock/ heeft bijgewerkt.
- [ ] Open de klikkaart (`/mh clickcard`). Onderaan staat een knop "Print (website)". Klik erop: het bekende kopieervenster
      van het toetsblok gaat open.
- [ ] In die code staan onderaan regels die beginnen met `K|MOUSE-`, één per klik (bv. `K|MOUSE-ALT-L|…|Rejuvenation|Rank 3`).
- [ ] `/mh clickcard export` doet hetzelfde.
- [ ] Zodra de site klaar is: plak de code op midnighthelper.com (Key block-pagina). Op het blad staat een vak met je klikken
      per laag (gewoon, Alt, Ctrl, Shift). Print het op A4 en kijk of het zwart-wit leesbaar is.

## 26 nov — FOREVER: gear-% onderaan "Do this now", reistijden in min:sec, "binnen, boven"

`/reload` is genoeg. Offline getest (dur_test 10/10, flight_test 62/62, cq_test 33/33, card_test 22/22), NIET in het spel.
- [ ] Open "Do this now". Onderaan, links van de vrije tasvakjes en het goud: een hamer-icoon met "gear NN%". Groen vanaf
      50%, geel tussen 25% en 50%, rood onder 25%. Het getal is je meest versleten item (hetzelfde als de waarschuwing).
- [ ] Muis erop: de drie meest versleten items met hun %, en "repair at …" met de afstand. Klik erop: de pijl gaat naar
      die verkoper.
- [ ] Vecht of sterf een keer: het getal loopt mee zonder dat je het venster opnieuw opent.
- [ ] Routepaneel (bv. naar Dendrite Starblaze): elke stap en het totaal staan nu als "0:30", "1:10", "about 1:40". Het
      totaal is precies de som van de stappen.
- [ ] Teleport: Moonglade is nu ongeveer 0:30 (10 s cast + laadscherm), geen 2 min meer. Na een keer teleporteren meet MH
      jouw laadscherm (`ns.db.foreverTpLoad`) en gebruikt hij dat.
- [ ] Een vlucht Nighthaven → Thunder Bluff één keer vliegen: MH onthoudt jouw eigen tijd (verwacht rond 9 min).
- [ ] Class-questkaartje bij Dendrite Starblaze: achter "Moonglade" staat "· binnen, boven" (Engels: "upstairs, inside").

## 26 nov — FOREVER: de zalf bij "Curing the Sick" (Rob verloor hem op 9/10)

`/reload` is genoeg. Offline getest (cq_test 26/26), NIET in het spel.
- [ ] Neem "Curing the Sick" opnieuw bij Tonga Runetotem. Het class-questkaartje zegt onder de stap (oranje): "Use the
      salve only when you are NOT in combat … 10 doses, no refill. Lost one? Abandon the quest and take it again from Tonga
      Runetotem." en groen "Doses left: 10, still needed: 10."
- [x] Heb je minder doses dan nog nodig: de regel wordt rood met "Not enough". ✅ Rob, 26 nov: *"En dit ziet er keurig uit."*
      (screenshot: "9/10 Sickly Gazelle cured", rood "Doses left: 0, still needed: 1. Not enough …"). De opgeven-zin stond
      toen twee keer: nu bij rood maar één keer (oranje = alleen de gevechtsregel).
- [ ] Als je knoppen weer leeg lijken (vóór je herstart): typ `/mh block look` en stuur de chatregels. Daarmee zien we of het
      spel ze nog heeft en alleen de balk ze niet toont.
- [ ] Alliance (Sickly Deer, Darkshore): hetzelfde, met Alanndarian Nightsong.

## 26 nov — toetsblok: terugzetten wat ontbreekt, plekken in gewone woorden, eerst zeggen wat Undo doet

`/reload` is genoeg. Offline getest (undo_test 20/20), NIET in het spel.
- [ ] Toetsblokvenster → "Update (add new spells)": zet nu ook War Stomp terug (Action Bar 1, knop 9). Er gaat niets weg.
      Of typ `/mh block restore`: de chat zegt per ding waar het terugkwam.
- [ ] `/mh block slots`: geen "slot 9" meer, maar "Action Bar 1, button 9 (key …)". Onderaan staat hoe je terugzet.
- [ ] Zie je bij het inloggen de melding over de andere indeling: onder de tekst staat nu "Undo first takes N of MH's
      buttons off your bars and leaves M of your own there: …" — vóór je op Fix klikt. Hetzelfde bij de indeling-knop.
- [ ] Eten en drinken komen NIET vanzelf terug (MH heeft ze nooit onthouden): sleep ze zelf terug.

## 26 nov — FOREVER: "zieke gazelles" en elk groot gebied: de pijl naar de dichtstbijzijnde plek

`/reload` is genoeg (het bestand bestond al; wel één keer herstart als je die nog niet deed voor de Kodo-gebieden).
Offline getest (cq_test 22/22), NIET in het spel.
- [ ] Druid, "Curing the Sick" (10 Sickly Gazelles): "Show the way" wijst naar een gazelle-plek dicht bij jou in The Barrens,
      niet naar één vaste plek. Loop een stuk: binnen 20 seconden kiest hij een plek die nu dichterbij is.
- [ ] Sluit het kaartje met het kruisje en loop rond: het blijft dicht (het is dezelfde stap).
- [ ] Alliance: "Sickly Deer" in Darkshore werkt net zo.

## 26 nov — BUG: eten/drinken weg van je balken na "Fix"/Undo van het toetsblok → Undo laat jouw spullen nu staan

`/reload` is genoeg. Offline getest (undo_test 13/13), NIET in het spel.
- [ ] Eerst herstellen: sleep je eten en drinken (en wat er verder weg is) zelf weer uit je tassen op de vrije plekken.
      MH had niet onthouden wat daar stond, dus het kan ze niet terugzetten.
- [ ] Typ `/mh block slots`: per vakje "MH left … · now … · undo: lift off / KEEP (yours)". Je eten en drinken staan op
      KEEP.
- [ ] (alleen als je wilt testen) `/mh block undo`: je eten en drinken blijven staan, en de chat zegt "Left on your bars
      (you put these there yourself …): N — Shiny Red Apple, …". Zet daarna het blok weer neer (venster → Place it).

## 26 nov — FOREVER: class quest wijst naar het dichtstbijzijnde gebied (Rob: "meer gebieden … Kodo Horns")

⚠️ NIEUW BESTAND (ForeverClassQuestAreas.lua, in beide toc's): Forever één keer HELEMAAL herstarten. Offline getest
(cq_test 18/18), NIET in het spel.
- [ ] Druid op "Kodo Horns": het kaartje zegt onder The Barrens "· 3 areas, this one is nearest". Sta je bij Crossroads,
      dan wijst hij naar het grote gebied ten zuiden (52.4, 42.9); sta je noordelijk (bij 55, 14), dan naar het noorden.
- [ ] "Show the way": de pijl gaat naar datzelfde gebied. In de chat staat de zin ook met "3 areas, this one is nearest".
- [ ] Een ander doel met meerdere gebieden: Helboar (Blasted Lands, Warrior), Scarlet-plannen (Paladin,
      Tirisfal), Mosshoof Courser (Azshara). Een doel met één gebied: alles zoals eerst.

## 26 nov — FOREVER: tooltip op "5 Earthroot" + alleen jouw eigen Nighthaven

`/reload` is genoeg. Offline getest (cq_test 12/12, flight_test 48/48), NIET in het spel.
- [x] Druid op "Gathering the Cure": muis op de regel "you also need 5 Earthroot …" in het class-questkaartje. Je ziet de
      tooltip van Earthroot zelf, en eronder "MH: you have 2 of the 5 you need" en "MH: on your other characters: Ima 3".
      ✅ Rob, 26 nov: *"Ja, de tooltip werkt netjes. Staat ook keurig bij waar ik het [kan] krijgen, dus daar ben ik heel
      blij mee."* (screenshot: Syndicator-blok "Joey Whatever Bags: 6, Ima Warlocky Bags: 3" + MH "you have 0 of the 5",
      "Ima Warlocky 3"). Joey ontbrak in MH's regel: MH vroeg Syndicator alleen je eigen factie → nu iedereen, met reden.
- [ ] Nu: onder "MH: on your other characters:" eerst "Ima Warlocky 3 (can mail it to you)", dan grijs "Joey Whatever 6
      (Alliance: cannot mail it to you)", en "MH: by mail you can get 3 of the 5".
- [ ] Hetzelfde in het overzicht bij "Do this now" (muis op de class-questregel).
- [ ] Laat Syndicator/Baganator zijn eigen regels ook zien (zijn tooltip-instelling)? Dan staan ze er misschien dubbel.
      Zeg het, dan haal ik de MH-regel weg.
- [ ] `/mh travel` als Horde-druid: alleen "Nighthaven, Moonglade (63)", niet meer (62).

## 26 nov — Move: knop "Close", balk met "Done", Escape stopt; label castbalken erboven; klikkaart 3 per rij

`/reload` is genoeg. Offline getest (move_test 19/19, card_test 22/22), NIET in het spel.
- [ ] Forever → Tools → "Move MH on your screen" → Open: de knop heet nu "Close". Bovenaan je scherm een groene balk "Move is
      on: drag the green boxes. Done or Escape stops it." met een knop Done.
- [ ] Druk Escape: Move gaat uit (groene vakken weg, balk weg), en de knop in Tools heet weer "Open". Zo ook met Done.
- [ ] Het vak van de castbalken: "Drag me: dangerous cast bars" staat nu BOVEN de balken, op een donker strookje.
- [ ] Midnight: Instellingen → "Move MH elements on your screen": het vinkje volgt (ook als je met Escape stopt).
- [ ] Klikkaart, Other layers: 3 per rij; "Cure Poison  via quest" en "Remove Curse  level 24" staan er helemaal.

## 26 nov — klikkaart: tooltips en grotere letters (Rob, tweede screenshot)

`/reload` is genoeg. Offline getest (card_test 22/22), NIET in het spel.
- [x] Muis op Rejuvenation / Regrowth / Healing Touch: de tooltip van het spel zelf, met eronder bv. "Alt + left click on
      a group frame". ✅ Rob, 26 nov (screenshot Healing Touch: 110 Mana, 40 yd, "Heals a friendly target for 180 to 225."
      + "ALT + middle click (wheel) on a group frame").
- [ ] Ook op de kleine iconen onder "Other layers"; een grijze: "Not learned yet: level 24".
- [x] De kleine teksten zijn groter. ✅ Rob, 26 nov (screenshot). Wel: "Cure Poison via que…" en "Remove Curse level…"
      werden afgekapt → Other layers nu 3 per rij, breder (zie bovenaan).
- [x] Het lichtere rechthoekje links in het lichaam van de muis is weg. ✅ Rob, 26 nov (screenshot).

## 26 nov — FOREVER: loot die MH zelf leert van een rare (Rob: "kunnen we ook zien wat die dropt?")

`/reload` is genoeg. Offline getest (rare_test 38/38), NIET in het spel.
- [ ] Dood een rare uit de lijst en loot hem. Daarna `/mh rares why`: regel "loot: GetLootSourceInfo yes/no; rares with
      learned loot: 1; last: learned … from <naam>". (Zegt hij "no": dan werkt het via je target, dus loot met hem in target.)
- [ ] Find → Rares (of de zone): bij die rare staat "Your loot (1 kill): [icoon] …". Het rare-venster toont dezelfde regel.
- [ ] Hetzelfde lijk nog eens openen telt niet dubbel.
- [ ] `/mh ghost`: regel "client's own sickness duration" — staat daar een tijd (levend of dood)? Zeg wat er staat.

## 26 nov — FOREVER: de rare in 3D (Rob: "Een animatie.")

`/reload` is genoeg. Offline getest (rare_test 27/27), NIET in het spel.
- [ ] Find → Rares: zet de muis op de naam van een rare. Naast het venster draait de rare in 3D, met zijn naam eronder.
      Muis weg: het model is weg.
- [x] `/mh rares test`: het rare-venster heeft links de rare in 3D, de tekst staat ernaast. ✅ Rob, 26 nov (via Sparring,
      screenshot Strider Clutchmother, model links zichtbaar): *"de MHR-test is ook geslaagd"*.
- [ ] Geen model (een rare waar je nog nooit was?): geen zwart vak; het venster/model gaat vanzelf weg. `/mh rares why` →
      regel "3D model: …" zegt waarom.

## 26 nov — FOREVER: venster na je dood blijft weg als je het sluit (Rob: "hij blijft nu terugkomen")

`/reload` is genoeg. Offline getest (flight_test 45/45), NIET in het spel.
- [ ] Dood/geest → venster → kruisje: het komt NIET terug bij het aftellen, na release, na een laadscherm.
- [x] Knop "Arrow to my corpse": de pijl staat, het venster gaat vanzelf dicht. ✅ Rob, 26 nov (via Sparring).
- [ ] (nieuw, `/reload`) Weer levend op afstand van je lijk (30+ yd): de lijk-pijl is meteen weg. Liep er vóór je dood een
      route (trainer, quest), dan wijst de pijl daar weer naar. `/mh ghost`: regel "corpse arrow: alive again: …".
- [ ] Weer levend en opnieuw dood: het venster komt weer één keer. `/mh ghost test` toont het altijd.

## 26 nov — FOREVER: venster na je dood (Rob: "weer nuttige info")

Alleen bestaande bestanden gewijzigd: `/reload` is genoeg. Offline getest (flight_test 36), NIET in het spel.
✅ Rob, 26 nov (Druid 15, echt dood): venster + "Arrow to my corpse" werken ("dat geeft helemaal keurig"). Sickness-duur
✅ GEMETEN: Blizzards eigen Spirit Healer-popup op Robs Druid 15 zegt "5 minutes" en "25% durability damage (equipped and
inventory)", gelijk aan MH's venster (screenshot via Sparring). Polestars "10 min" was een vaste terugval.
- [ ] `/mh ghost test`: venster "YOU DIED" met een voorbeeld (889 m), advies en wat de Spirit Healer op jouw level kost.
- [ ] Echt dood, nog niet released: "Release: you appear … from your corpse; the run back takes about …".
- [ ] Als geest: "Your corpse: … away, about … as a ghost." telt af terwijl je loopt; knop "Arrow to my corpse" zet de pijl.
- [ ] Level 14: "Spirit Healer: 4 min Resurrection Sickness (-75% …) and 25% durability". Onder level 11: geen sickness.
- [ ] Weer levend: het venster gaat weg. Quiet helpers → "Window after you die" uit: geen venster.
- [ ] `/mh ghost`: of de corpse- en release-API er zijn (meting).

## 26 nov — FOREVER: boten en zeppelins op hun eigen klok (reisplanner stap 4)

Alleen bestaande bestanden gewijzigd: `/reload` is genoeg. Offline getest (flight_test 33), NIET in het spel.
Zo klein mogelijk voor Rob:
- [ ] Neem één keer een zeppelin of boot (bv. Orgrimmar ↔ Tirisfal). Daarna `/mh travel`: regel "boats/zeppelins
      learned: H1a: 1 departure(s), ride … s".
- [ ] Neem dezelfde nog een keer (een andere dag mag): nu staat er ook "every … s"; de route rekent dan met de echte
      wachttijd tot het volgende vertrek.
- [ ] (Alleen als je in Undercity bent en zin hebt) `/mh walkrec on`, loop de gangen die je gebruikt, `/mh walkrec off`,
      `/reload`. Dat is meetdata voor later; er verandert nog niets aan de pijl.

## 26 nov — BEIDE: de klikkaart "Which click heals what" (Rob: "Het moet grafisch tof zijn")

⚠️ NIEUW BESTAND (ClickCard.lua, in beide toc's): Forever én Midnight één keer HELEMAAL herstarten. Offline getest
(card_test 14, click_test 25), NIET in het spel.
- [ ] Forever: Quiet helpers → Click heals → "Show the click card" (of `/mh clickcard`). Een grote kaart met een
      getekende muis; links groen, rechts blauw, wieltje goud; jouw drie Alt-heals eromheen met een lijntje naar hun knop
      (ook naar het wieltje). Bovenaan pillen Plain / Alt / Ctrl / Shift; Alt is goud.
- [x] Houd Shift ingedrukt: de kaart toont meteen de Shift-laag ("live: Shift is held"). Loslaten: terug. ✅ Rob, 26 nov:
      *"als ik shift ingedrukt houd, springt het mooi over."*
- [ ] Onderaan "OTHER LAYERS": gewone klik = Target/Menu, en wat je nog niet kent grijs met "level 24", "talent" of
      "via quest" (Cure Poison).
- [ ] Zet "Keep left-click for targeting" uit: binnen 2 seconden staan de heals op Plain en is Plain de grote laag; zet
      hem weer aan: terug naar Alt. Verander iets in `/df` → Click Casting: de kaart volgt.
- [x] Shift+scroll: groter/kleiner. ✅ Rob, 26 nov: *"En ik kan inderdaad shift scrollen groter en kleiner maken."*
- [ ] Slepen; de knop "See-through" wisselt 100/85/70/50%.
- [ ] Quiet helpers → "Click card see-through outside a group" aan: solo bijna doorzichtig.
- [ ] Midnight (healer-spec met de klik-indeling): How you play → klikken → knop "Show the click card".
- [ ] `/mh clickcard why`: waar de klikken vandaan komen (DandersFrames-profiel of MH's indeling).

## 26 nov — FOREVER: routepaneel, echte minuten, ring op de vliegkaart (reisplanner stap 3)

Alleen bestaande bestanden gewijzigd: `/reload` is genoeg. Offline getest (flight_test 30), NIET in het spel.
- [x] Zet een pijl naar iets ver weg (trainer, class quest). Rechts in beeld: paneel "ROUTE: <doel>" met "(about N
      min) · afstand" en genummerde stappen met icoon en minuten (vlieg, boot, teleport, laatste stap "walk to …").
      ✅ Rob, 26 nov (/mh travel, Orgrimmar → Tonga Runetotem): "route panel: on; shown: 2 step(s) to Tonga Runetotem";
      "1. the flight master: fly to Crossroads … about 2.4 min / then walk to the target, about 0.4 min / total: about 2.9
      min"; "flights you timed yourself: 3"; alleen "Nighthaven, Moonglade (63)" (de Alliance-knoop is weg).
      Twee tekstjes in `/mh travel` daarna eerlijker gemaakt: per stap de bron van de minuten, en bij de Hearthstone alleen
      de echte reden.
- [ ] Doe een stap (bv. de vlucht): na de landing staat die stap niet meer in het paneel.
- [ ] Open de flight master uit de route: de stop waar je heen moet heeft een gouden ring en "MH: fly here". Klik zelf.
- [x] Na een vlucht: `/mh travel` zegt "flights you timed yourself: 1" en de volgende keer klopt die tijd beter. ✅ Rob,
      26 nov (screenshot): "walking speed used: 7.0 yd/s (run speed, with a detour factor 1.4); flights you timed
      yourself: 2". (Of de tijd daarna beter klopt: nog niet gezien.)
- [ ] Op een mount worden de loopminuten korter (`/mh travel`: "walking speed used: … yd/s").
- [ ] Kruisje op het paneel: weg tot je een ander doel kiest. Quiet helpers → "Route steps next to the arrow" uit: weg.
- [ ] Midnight: de hint op de vliegkaart (FlightMapHint) weet weer of een stop op de kaart staat.

## 26 nov — FOREVER: /mh clickheal netter (na Robs screenshot)

Alleen bestaande bestanden gewijzigd: `/reload` is genoeg.
- [ ] `/mh clickheal` met "keep left-click" aan: geen "not learned yet: Middle Mouse = Healing Touch" meer.
- [ ] De laatste regel eindigt op "… /keep" (niet "…eep").

## 26 nov — FOREVER: venster als er een rare in zicht is (reisplanner stap 2; Rob: "een eigen venstertje voor [rares]")

Alleen bestaande bestanden gewijzigd: `/reload` is genoeg. Offline getest (rare_test 15), NIET in het spel.
- [x] `/mh rares test`: het venster "RARE IN SIGHT" met naam, level, zone en drie knoppen (Target, Show in Find,
      Waypoint). ✅ Rob, 26 nov: *"de MHR-test is ook geslaagd"* (screenshot: Strider Clutchmother, level 20, Darkshore,
      "Drops the Tallstrider Hatchling pet (about 1 in 3)", de drie knoppen).
- [ ] Sleep het venster; Shift+scroll = groter/kleiner.
- [ ] Een echte rare in je buurt (nameplate, target of muis erop): het venster komt vanzelf, met een geluidje. Klik Target:
      de rare is je target. Klik Show in Find: het overzicht opent bij de rares van die zone. Waypoint: de pijl.
- [ ] In een gevecht: geen Target-knop, wel de tekst "Target: after the fight"; na het gevecht is de knop terug.
- [ ] Dezelfde rare binnen 10 minuten: geen nieuw venster. Na een minuut gaat het venster vanzelf weg.
- [ ] Quiet helpers → "Window when a rare is in sight" uit: geen venster meer. `/mh rares` zegt wat hij zag en waarom.
- [ ] Target een rare en typ `/mh rares`: regel "your target: classification rare…" (dat is ook test T3).

## 26 nov — FOREVER: MH leert welke flight points je kent + Nighthaven + één advies (reisplanner stap 1)

Alleen bestaande bestanden gewijzigd: `/reload` is genoeg. Offline getest (flight_test 27, trainroute_test 6), NIET in het spel.
- [x] Praat met een flight master (de vliegkaart gaat open) en typ daarna `/mh travel`. Regel "flight points you know: N"
      noemt nu jouw punten, en "flight map seen on Kalimdor: yes". De regel "taxi API: …" zegt welke functies je client
      heeft. ✅ Rob, 26 nov (screenshot, Tauren Druid, The Barrens): "flight points you know: 8 — learned: 6; flight map
      seen on Kalimdor: yes" (de 6 = Camp Taurajo, Crossroads, Orgrimmar, The Sepulcher, Thunder Bluff, Undercity) en
      "taxi API: GetTaxiMapID yes, C_TaxiMap.GetAllTaxiNodes yes, … GetTaxiNodesForMap yes" → T1: GetTaxiMapID BESTAAT in
      Forever (GEMETEN). Wel: beide Nighthaven-knopen (62 en 63) in de lijst → gerepareerd (Horde alleen 63, zie bovenaan).
- [ ] Ontdek een nieuw flight point: `/mh travel` noemt het meteen ("last learned: new flight path").
- [ ] Na een vlucht: "last learned: landed".
- [ ] Druid in Moonglade, doel in The Barrens: de route begint bij de flight master in Nighthaven (vlieg naar Thunder
      Bluff …), niet in Winterspring.
- [ ] Het kaartje en de chat noemen nu dezelfde route (niet eerst de flight master en dan "first use your Hearthstone").

## 26 nov — FOREVER: heals met een klik op DandersFrames (Rob: "2 ja")

⚠️ NIEUW BESTAND (ForeverClickCast.lua, in beide toc's): Forever én Midnight één keer HELEMAAL herstarten, `/reload` is
niet genoeg (in Midnight doet het bestand niets, maar de toc veranderde). Offline getest
(click_test 25), NIET in het spel.
- [ ] Tauren Druid, Forever-venster → Quiet helpers → kopje CLICK HEALS (DANDERSFRAMES): zet "Heals on a click on your
      group frames" aan. Chat: "Click heals on: N spells on your DandersFrames frames."
- [ ] Typ `/mh clickheal`. Je ziet per klik wat hij doet, bv. Alt+Left = Rejuvenation, Alt+Right = Regrowth, Ctrl+Left =
      Cure Poison, en "not learned yet: …" voor wat nog komt. Stuur me die regels.
- [ ] Gewone linksklik op een groepsframe target nog steeds; rechtsklik opent het menu (schakelaar "Keep left-click for
      targeting" staat standaard aan). Werkt dat ook in Cat Form en Bear Form?
- [ ] Alt+linksklik op een groepslid: Rejuvenation op die speler, de hoogste rank die je kent?
- [ ] Zet "Keep left-click for targeting" uit: nu doet een gewone linksklik Rejuvenation, Shift+linksklik target.
- [ ] Leer een nieuwe rank of spell bij de trainer: na een paar seconden staat hij vanzelf in het profiel (`/mh clickheal`).
- [ ] Zet de hoofdschakelaar uit: chat "Click heals off: DandersFrames has your previous click-cast profile back." en
      `/df` → Click Casting heeft weer je oude profiel actief.
- [ ] Een Warrior of Rogue die de schakelaar aanzet: korte zin "Your class has no click heal layout", schakelaar blijft uit.

## 26 nov — FOREVER: alleen commando's die in Forever werken (Rob: "3 ja")

Alleen bestaande bestanden gewijzigd: `/reload` is genoeg. Offline getest (cmd_test 13), NIET in het spel.
- [x] Forever-venster → All commands: geen /mh crests, /mh folio, /mh weeklies, /mh wishlist, /mh ach, /mh mount,
      /mh nodes meer. Wel o.a. /mh move, /mh block, /mh enchant, /mh donow, /mh alts, /mh board. ✅ Rob, 26 nov (voor
      crests): *"Zie je hem ook niet meer terug in het overzichtje, dus dat is goed."*
- [x] Typ in Forever `/mh crests`: chat zegt "/mh crests only works in World of Warcraft: Midnight, not in WoW Forever."
      ✅ Rob, 26 nov: *"geeft inderdaad deze keurige melding."*
- [ ] De zoekbalk in Forever vindt die Midnight-commando's ook niet meer.
- [ ] Midnight: de commandolijst is onveranderd (alles staat er, zonder de Forever-commando's).

## 26 nov — FOREVER: vijf instellingen erbij in Quiet helpers (Rob: "1 ja")

Alleen bestaande bestanden gewijzigd: `/reload` is genoeg. NIET in het spel getest.
- [ ] Quiet helpers, kopje ON YOUR SCREEN: Show missing buff icon, Notice when an upgrade lands in your bags, Route
      arrow size (een getal), Show route distance in meters, Show minimap icon, Quick bar.
- [ ] Klik op het getal bij Route arrow size: de pijl wordt groter (een paar seconden voorbeeld). Rechtsklik = kleiner.
- [ ] Elke schakelaar doet wat hij zegt (minimap-icoon weg en terug, quick bar aan en uit, meters in plaats van yards).
- [ ] Zoek op "minimap", "quick bar", "arrow" of "buff": je vindt de schakelaar en hij licht op.

## 26 nov — FOREVER (en Midnight): castbalken verplaatsen + de cast-waarschuwing vindbaar (Rob: "ja doe maar, en waarom kan ik het niet zoeken ?")

Alleen bestaande bestanden gewijzigd: `/reload` is genoeg. Offline getest (move_test 12), NIET in het spel.
- [ ] Forever: zet Move aan (venster → Tools → Move, of `/mh move`). Geen foutmelding meer (was MoveMode.lua:144
      "secret number").
- [x] (slepen) ✅ Rob, 26 nov: *"de casts kan ik nu verslepen, dus daar ben ik heel blij mee."* Wel: het label stond
      dwars over de middelste balk → gerepareerd (zie bovenaan), en Escape/Open-knop van Move → gerepareerd.
- [ ] Er staat een groen vak "dangerous cast bars" met drie voorbeeldbalken. Sleep het vak: de balken gaan mee. Zet
      Move uit: de voorbeeldbalken zijn weg. Bij de volgende cast op jou staan de echte balken op de nieuwe plek.
- [ ] Ook het icoon (combat safety) is te slepen en verdwijnt weer na Move uit.
- [ ] Zoek in het Forever-venster op "cast bars": je vindt "Also show cast bars". Klik = de schakelaar licht op.
- [ ] Quiet helpers heeft een kopje COMBAT WARNINGS met: Show dangerous cast warning, Also show cast bars, Only
      "important" casts, Speak the cast name, en een knop "Preview / position".
- [ ] `/mh move why` noemt "dangerous cast bars".
- [ ] Midnight: Move aan/uit werkt nog zoals eerst (de balken staan er ook bij als ze aan staan).

## 26 nov — FOREVER: de pijl vliegt mee, en het class-questkaartje zegt hoe je er komt (Rob: "Waarom alleen maar een pijl die kant op en niet hoe ik kom?")

Alleen bestaande bestanden gewijzigd: `/reload` is genoeg. Offline getest (flight_test 19, trainroute_test 6), NIET in
het spel.
- [ ] Eerst: typ `/mh travel`. Regel "flight points you know: N". Klopt die lijst met je flight map? Staat er
      "learned at flight masters: 0" en "not trusted"? Praat dan één keer met een flight master (kaart open = MH
      leert welke je kent) en typ het nog eens. Stuur me beide regels.
- [ ] Je Tauren Druid bij de zeppelintoren buiten Orgrimmar, class quest naar Turak in Thunder Bluff: het kaartje zegt
      onder "Thunder Bluff" iets als "The way there: the flight master in Orgrimmar: fly to Thunder Bluff, Mulgore.
      (about 11 min)".
- [ ] Show the way: de pijl wijst eerst naar de flight master in Orgrimmar (niet 4405 m rechtdoor). Daar staat hij stil
      met de tekst "the flight master: fly to Thunder Bluff, Mulgore". Na de landing wijst hij naar Turak.
- [ ] Tijdens de vlucht doet de pijl geen rare dingen (hij wijst gewoon naar het doel).
- [x] Een plek waar lopen sneller is: het kaartje zegt "The way there: walk (about N min)." ✅ Rob, 26 nov (screenshot
      "Gathering the Cure": "The way there: walk (about 3 min).")
- [ ] Ook de andere "Show the way"-knoppen (trainer, vendor, dungeon, Find) kunnen nu een vlucht in de route zetten.
- [ ] Je Hearthstone op cooldown: de route stuurt je er niet heen (dat deed hij al; nu ook naast vluchten).

## 26 nov — FOREVER: Oath of Light duurt nu 1 uur (Blizzard-hotfix 25 nov; Rob: "Ja, ik zeg ja op 1 en 2.")

Alleen bestaande bestanden gewijzigd: `/reload` is genoeg. NIET in het spel getest.
- [ ] Paladin: How you play → de Holy-volgorde, stap 1. Daar staat nu "It lasts 1 hour" (was "5 minutes").
- [ ] Cast Oath of Light op iemand en kijk naar de buff: duurt hij echt 60 minuten? (Wowhead zegt ja.)

## 26 nov — FOREVER: trainerpijl kiest op reistijd, met Teleport: Moonglade (Rob: "4493 meter verderop … dat moet beter kunnen haha")

Alleen bestaande bestanden gewijzigd: `/reload` is genoeg. Offline getest (trainroute_test 6), NIET in het spel.
- [ ] Druid (level 10+, kent Teleport: Moonglade) in Orgrimmar → "Show the way" / trainerpijl. Chat: "arrow set to
      Loganaar (trainer), about N min" en "The way there: cast Teleport: Moonglade. (about N min)". De pijl zegt eerst de
      teleport te casten; na het laden wijst hij naar Loganaar.
- [ ] Na die eerste teleport onthoudt MH waar je landt (de volgende keer klopt de tijd beter).
- [ ] Druid ZONDER Teleport: Moonglade (onder 10): de pijl kiest de trainer met de kortste reistijd (Thunder Bluff) en
      zegt "about N min" in plaats van een rechte afstand.
- [ ] Een andere class op een ander continent dan zijn trainers: de pijl geeft nu de route (zeppelin/boot) in plaats van
      "no trainer known on this continent".
- [ ] `/mh trainer check` toont "chosen: Loganaar by travel time: about … min (plan, … places compared)" en "route: …".
- [ ] Nieuwe trainers in de lijst: Loganaar (Moonglade, beide facties), Jannos Lighthoof (Feralas, Horde), Golhine
      (Felwood, Alliance) en 15 trainers in het veld (Swamp of Sorrows, Stranglethorn, Ashenvale, Loch Modan, Hinterlands,
      Dustwallow) voor Hunter, Paladin, Rogue, Shaman, Warlock en Warrior.

## 26 nov — FOREVER: "Your race" in How you play (Rob: "ik zag bv ook dat deze druid ook Cultivation heeft :)")

Alleen bestaande bestanden gewijzigd: `/reload` is genoeg. Offline getest (race_test: elk ras × elke class × 8 talen),
NIET in het spel.
- [ ] Tauren Druid: How you play → tab **Start** → onderaan het blok **Your race: Tauren**. Eerst de zin "Your race
      abilities are free …", dan War Stomp, Plainsrunning, Endurance en Cultivation, met de spellnamen zoals jouw spel ze
      schrijft.
- [ ] Daaronder **For you as a Druid:** met de regel over Plainsrunning in Bear Form en Cat Form. Geen regels voor
      Hunter of Shaman.
- [ ] Links onder de tabbladen staat het kopje "Your race: Tauren"; klik erop = de tekst springt erheen.
- [ ] Met het 12 × 4-blok: "Shift-E" in de eerste zin is de toets van je race spell in díe indeling.
- [ ] Ander character (ander ras of class): alleen dat ras, en alleen de regels van die class. `/mh howtotabs mine`
      noemt "Your race: …" onder Start.
- [ ] (na de Fable-controle) Gnome Rogue: druk Eureka! terwijl je in Stealth bent. Blijf je in Stealth? (DB2 zegt ja;
      daarom staat "Not in Stealth" er niet meer.)
- [ ] (Fable) High Order Skyborne: kun je Read Leyline casten terwijl je loopt? (DB2 zegt nee: de tekst zegt het niet
      meer.) Windshaper: Skysight lopend casten moet wél kunnen.
- [ ] (Fable) Skyborne Druid: in het toetsenblok staat Walk on Air nu op Shift-E. Gnome Warrior/Rogue/Mage/Warlock: de
      Eureka!-macro staat nu bij de macro's.

## 26 nov — FOREVER: Gear check: enchants — Legs erbij, en het venster werkt vanzelf bij (Rob: "Ik mis hier … mijn legs")

Alleen bestaande bestanden gewijzigd: `/reload` is genoeg. Offline getest (ench_test 30), NIET in het spel.
- [ ] Open je character-venster. In "Gear check: enchants" staat nu ook **Legs**: met de naam van je armor kit, of
      "no enchant".
- [ ] Head, Shoulder, Waist en Ranged staan er alleen als er al iets op zit (die enchants komen pas laat).
- [ ] Laat het character-venster open en zet een armor kit (of enchant) op je broek of een ander gedragen item: de regel
      wordt binnen een seconde groen, zonder het venster dicht en weer open te doen.
- [ ] Do this now telt het vakje Legs mee bij "N slots of your gear have no enchant".
- [ ] `/mh enchant` noemt "last live refresh: UNIT_INVENTORY_CHANGED" (of PLAYER_EQUIPMENT_CHANGED) na die enchant.
      Staat er "none" terwijl de regel wél bijwerkte? Meld het: dan vuurde een ander event.

## 25 nov — FOREVER: Warlock-stats: spell damage, dan Intellect en Spirit even belangrijk (Rob: "Ik volg jouw advies.")

Alleen bestaande bestanden gewijzigd: `/reload` is genoeg. Offline getest (wadv_test 107, gearench_test 25), NIET in het spel.
- [ ] Op een Warlock: Do this now zegt bij de stats eerst spell damage, dan Intellect en Spirit (even belangrijk). Stamina
      staat er niet meer als hoofdstat; alleen "Equal? Take the one with more Stamina."
- [ ] How you play → Weapon & stats → "Which weapon? (Warlock)": de laatste zin zegt dat Stamina alleen beslist tussen twee
      gelijke items.
- [ ] Ga op een item met alleen Stamina staan: geen groene "better"-regel meer. Een item met meer Spirit (of Intellect)
      dan wat je draagt: wél.

## 25 nov — FOREVER: "How you play" in tabbladen (Rob: "zo'n lange lap tekst … Met tabbladen van mijn part")

Alleen bestaande bestanden gewijzigd: `/reload` is genoeg. Offline getest (153 controles: 9 klassen × 8 talen, regels
vóór = na). ✅ 25 nov GETEST door Rob (via Sparring, 2 screenshots, Druid 12 Feral): *"Ik heb reload gedaan en dan blijft
hij staan. … Verder ziet overigens how to play beter uit op deze manier. Wat minder druk voor mijn gevoel."* Niet apart
genoemd (dus open): alle tabs langsklikken, klikken op een kopje, de knoppen, Shift+scroll, de andere ingangen.
- [x] Open "How you play" (overzicht → Your class → How you play, of `/mh play`). Links staan nu tabbladen: **Start ·
      Your keys · Weapon & stats · Group · Levels**. Rechts staat alleen de tekst van het gekozen tabblad.
      *(Rob 25 nov, screenshot: tab Start open met Bear: tank / Cat: damage up close)*
- [ ] Onder de tabbladen staan (iets ingesprongen) de kopjes van dat tabblad. Klik op een kopje = de tekst springt erheen.
      *(kopjes te zien op Robs screenshot; het klikken niet genoemd)*
- [ ] **Start**: de rol van je richting (uitleg, simpele volgorde, beginnersfouten) + "What it does" + de simpele
      volgorde en fouten van je klas. **Levels**: per 10 levels van je rol + "What comes later". **Weapon & stats**: je
      richting (armor, wapen), "Which weapon?" en "Which stats count". **Group**: tanken (Druid/Paladin/Warrior) en Dual
      Spec. Een klas zonder tank-plan heeft alleen Dual Spec in Group.
- [x] Een tabblad zonder tekst staat er niet. Kies een tabblad, sluit het venster, `/reload`: hij opent op hetzelfde tabblad.
      *(Rob 25 nov: "Ik heb reload gedaan en dan blijft hij staan." Het onthouden = OK; een leeg tabblad kwam bij de
      Druid niet voor, dat deel is dus niet gezien)*
- [ ] De knoppen "Your direction" en "All roles" werken nog. Met "All roles" open staan de andere rollen ook in Start en Levels.
- [ ] Shift+scroll maakt het venster groter/kleiner. Key block stap 4 en de knop in "Do this now" openen nu ook deze pagina
      (het oude losse venster is alleen nog reserve).
- [x] `/mh howtotabs` toont per klas welk blok in welk tabblad staat, en "role lines X/X" (moet gelijk zijn) en onderaan
      "nothing missing". 📸 Screenshot: het venster op tabblad Start, en de chat na `/mh howtotabs mine`.
      *(Rob 25 nov, screenshot: "DRUID: OK, role lines 72/72, total 127 lines, 0 double … nothing missing")*

## 25 nov — FOREVER: spell damage telt mee in "beter dan wat je draagt" (Robs /dump: GetItemStats geeft spell power)

Alleen bestaande bestanden gewijzigd: `/reload` is genoeg. Offline getest (20 controles), NIET in het spel.
- [ ] Caster of healer (Mage, Priest, Warlock, of een Paladin/Druid/Shaman met een caster- of healrichting): ga op een item
      met "Equip: Increases damage and healing done by magical spells" staan. Meer spell damage dan wat je draagt = de
      groene regel noemt "+N spell damage". Minder = "-N spell damage" in de regel als het item toch beter is, of geen regel.
- [ ] Prot Paladin: een item met 1 Stamina meer maar veel minder spell damage heet NIET meer "better".
- [ ] `/mh questhint check` toont "spell damage weight" en per beloning "spell=…". `/mh geartip`: bij "not better" staat
      "spell damage +N x W".
- [ ] (bijgewerkt na Robs dumps) Healer: een item met "healing" (bv. Truefaith Gloves 7049) telt als "Spell Healing".
      Damage-caster: alleen de damage-helft telt. Een school-regel (Inferno Robe 2231, Fire) telt alleen voor een spec die
      die school cast (Fire Mage, Destruction, Elemental); anders zegt MH niets. `/mh questhint check` toont "spell weight
      … (healing/damage; schools: …)".

## 25 nov — FOREVER: "Which weapon?" na de Fable-controle (alle 9)

Alleen bestaande bestanden gewijzigd: `/reload` is genoeg. Offline getest (104 controles), NIET in het spel.
- [ ] Titel op een vrouwelijk character in de/fr/es/ru: de vrouwelijke classnaam (UnitClass).
- [ ] Caster: de groene regel staat er nu in de woorden van JOUW client ("Equip: Increases damage and healing done by
      magical spells and effects by up to 12."), en "Players call this spell damage or spell power". Wands staat bij "You
      can already use". Boven level 20 geen "First wand"-regel meer. Mage: de regel over scrolls noemt Scroll of Imbue
      Lesser Flame.
- [ ] Druid op level 40+: "Dire Bear Form" in plaats van Bear Form. Onder 10: geen armor-regel voor de beer.
- [ ] Paladin tank (richting Protection of "When you tank"): "Stamina, then spell damage" (geen Intellect meer).
- [ ] Do this now: tanks (Warrior, Druid) beginnen niet meer met "weapon damage per second first". Survival Hunter: onder
      30 "ranged weapon damage per second", vanaf 30 "weapon damage per second". Druid zonder richting: Strength en Agility
      even zwaar.
- [ ] /mh weapons met richting Feral: "take the weapon with the most damage per second, whatever its kind …".
- [ ] Shaman: Mail via de item-naam van je client; de Earth/Fire/Water/Air Totem-items apart uitgelegd.

## 25 nov — FOREVER: "Which weapon?" voor de Warlock (9 van 9)

Alleen bestaande bestanden gewijzigd: `/reload` is genoeg. Offline getest (92 controles), NIET in het spel.
- [ ] Ima Warlocky (level 8): How you play → **Which weapon? (Warlock)**: de gedeelde caster-regels; geen wand-talent;
      Create Firestone (28) / Create Spellstone (36) op je wapen; Life Tap en Spirit; Stamina voor jou en je demon.
      Onderaan wat je kunt en wat je nog kunt leren (Staves, One-Handed Swords). Geen `<` of `#`.
- [ ] Richting (elke boom): "the kind matters little, look at what is on it …".
- [ ] Do this now: "bonus damage and healing for spells first, then …"; Affliction "… Spirit and Intellect count the
      same".

## 25 nov — FOREVER: "Which weapon?" voor de Priest

Alleen bestaande bestanden gewijzigd: `/reload` is genoeg. Offline getest (87 controles), NIET in het spel.
- [ ] Ima Priesterman (level 6): How you play → **Which weapon? (Priest)**: de gedeelde caster-regels; wand kiezen op
      DPS, Wand Specialization (Discipline); Shadow-stats en de healing-regel. Onderaan geen swords, axes of two-handed
      maces om te leren. Geen `<` of `#`.
- [ ] Richting (elke boom): "the kind matters little, look at what is on it …".
- [ ] Do this now: geen richting / Shadow "bonus damage and healing for spells first …"; Holy en Discipline "bonus healing
      for spells first …".

## 25 nov — FOREVER: "Which weapon?" voor de Mage

Alleen bestaande bestanden gewijzigd: `/reload` is genoeg. Offline getest (79 controles), NIET in het spel.
- [ ] Ima Magieman (level 10): How you play → **Which weapon? (Mage)**: je vecht met spells (wapen-DPS helpt niet); de
      groene "Equip: … damage and healing … spells"-regel; staf of eenhandig + Held In Off-hand; wand (Shoot, stilstaan);
      wand kiezen op DPS, Wand Specialization (Arcane); eerste wand via Enchanting; Mage-scrolls. Onderaan wat je kunt en
      wat je nog kunt leren. Geen `<` of `#`.
- [ ] Gekozen richting (elke Mage-boom): het blok bovenaan zegt "the kind matters little, look at what is on it …".
      /mh weapons met een richting zonder wapensoort: "… the weapon kind matters little here; look at what is on it."
- [ ] Do this now: "bonus damage and healing for spells first, then Intellect and Spirit count the same …".

## 25 nov — FOREVER: "Which weapon?" voor de Rogue

Alleen bestaande bestanden gewijzigd: `/reload` is genoeg. Offline getest (72 controles), NIET in het spel.
- [ ] Een Rogue (bv. Ima Roquedude of Ima Tinyroque): How you play → **Which weapon? (Rogue)**: alleen eenhandig (ook
      axes); Dual Wield vanaf 10, Backstab/Ambush met de main hand, Shank geeft Energy; langzaam in de main hand;
      Mutilate; Assassination/Subtlety/Combat en Hack and Slash; Poisons vanaf 20; ranged slot met Throw; stats. Onderaan
      geen tweehanders om te leren. Geen `<` of `#`.
- [ ] Do this now: "main-hand weapon damage per second first, then Agility, then Strength …".
- [ ] How you play → rol Subtlety: bij Hemorrhage staat nu "… with any weapon, but with a dagger it hits harder."

## 25 nov — FOREVER: "Which weapon?" voor de Hunter

Alleen bestaande bestanden gewijzigd: `/reload` is genoeg. Offline getest (64 controles), NIET in het spel.
- [ ] Een Hunter (bv. Ima Hunterdude of Test Girlie): How you play → **Which weapon? (Hunter)**: bow/gun/crossbow als
      hoofdwapen (Auto Shot, Arcane Shot, Aimed Shot, Multi-Shot), de langzamere bij gelijke DPS, Ammo en Quiver, 8 yards,
      een wapen voor dichtbij (Raptor Strike; geen maces), Beast Mastery/Marksmanship vs Survival, stats met Careful Aim.
      Onderaan wat je kunt en wat je nog kunt leren (geen maces). Geen `<` of `#`.
- [ ] Gekozen richting Survival: het blok bovenaan zegt "… one slow two-handed weapon or, from level 20, a weapon in each
      hand (no maces)" (was "not known yet").
- [ ] Do this now: zonder richting / BM / MM "ranged weapon damage per second first, then Agility, then Spirit …";
      Survival "weapon damage per second first, then Agility, then Strength …".

## 25 nov — FOREVER: "Which weapon?" voor de Shaman

Alleen bestaande bestanden gewijzigd: `/reload` is genoeg. Offline getest (54 controles), NIET in het spel.
- [ ] Ima Shammydude (level 17): How you play → **Which weapon? (Shaman)**: Enhancement met een tweehander (geen wapen
      in elke hand); Staves, Two-Handed Axes en Maces; Stormstrike / Windfury Weapon / Flametongue Weapon; de wapenbuffs
      met hun level; stats; casten en healen (Elemental / Restoration); rol wisselen; Mail vanaf 40 en een Totem (Totem
      of Charged Flames). Onderaan alleen de tweehanders die je nog kunt leren. Geen `<` of `#` in de tekst.
- [ ] Gekozen richting Elemental of Restoration: het blok bovenaan zegt "a one-handed weapon and a shield".
- [ ] Do this now: Enhancement / geen richting "weapon damage per second first, then Strength, then Intellect";
      Elemental "bonus damage and healing for spells first …"; Restoration "bonus healing for spells first, then Intellect,
      then Spirit" (was: Intellect en Spirit even zwaar).

## 25 nov — FOREVER: "Which weapon?" voor de Paladin

Alleen bestaande bestanden gewijzigd: `/reload` is genoeg. Offline getest (42 controles), NIET in het spel.
- [ ] Ima Pallie (level 15): How you play → **Which weapon? (Paladin)**: Retribution met een tweehander; Seal of Command
      en Holy Strike; tanken (Protection) met een Shield en Righteous Fury, Seal of Fury, Holy Shield, Judgement; healen
      (Holy); stats; alles doen; Libram. Onderaan wat je kunt en welke wapens je nog kunt leren (geen staves of daggers:
      die kan een Paladin niet). Geen `<` of `#` in de tekst.
- [ ] Gekozen richting Holy: het blok bovenaan zegt "a one-handed weapon with a shield or an off-hand item".
- [ ] Do this now: Retribution / geen richting: "weapon damage per second and spell damage first, then …"; Holy: "bonus
      healing for spells first, …". Protection: ongewijzigd (Stamina, then Intellect).

## 25 nov — FOREVER: "Which weapon?" voor de Warrior (Rob: "Maak ze maar een voor een compleet af daarna de controle")

Alleen bestaande bestanden gewijzigd: `/reload` is genoeg. Offline getest (30 controles), NIET in het spel.
- [ ] Een Warrior: How you play → blok **Which weapon? (Warrior)**: damage per second; Arms (Mortal Strike, Overpower,
      Slam); Fury met Dual Wield vanaf 20; tanken met Defensive Stance en een Shield; Rage; stats; Weaponmaster; ranged
      slot. Onderaan wat je al kunt en welke wapens je nog kunt leren, met de leraar van jouw kant. Geen `<` of `#` in de
      tekst (dan ontbreekt een naam).
- [ ] Do this now: "Best stats for you now: weapon damage per second first, then Strength, then Agility …"; "When you
      tank: weapon damage per second first, then Stamina, then Armor, then Agility."

## 25 nov — FOREVER: "Which weapon?" voor de Druid + betere stats-zin (Rob: "Zoek het eens eventjes goed uit en begin maar met de Druid")

Alleen bestaande bestanden gewijzigd: `/reload` is genoeg. Offline getest (20 controles), NIET in het spel.
- [ ] Druid (level 11): overzicht → **How you play** (of `/mh play`). Onder "Level and tank as a Druid" staat een blok
      **Which weapon? (Druid)**. Bij level 11: "In Bear Form your attacks do the damage per second of your weapon …",
      nog niets over Cat Form. Onderaan wat je al kunt gebruiken en welke tweehanders je nog kunt leren, met de leraar
      van jouw kant (Ima Druiddude is Horde, GEMETEN in je SV: Two-Handed Maces bij Ansekhwa in Thunder Bluff, Polearms
      vanaf level 20 bij Archibald in Undercity — tenzij je ze al kent). Op een Alliance-Druid (Joey Whatever): Buliwyf
      Stonehand (Ironforge) en Woo Ping (Stormwind).
- [ ] Gekozen richting Feral: het blok bovenaan zegt "Weapon: the one with the most damage per second …" en de bronregel
      noemt de gegevens van het spel en Blizzards artikel (niet "player guides"). Balance/Restoration: "the type does not
      matter, only the stats on it".
- [ ] **Do this now** → "Best stats for you now": bij Feral "weapon damage per second first, then Agility and Strength
      count the same …"; "When you tank: weapon damage per second first, then Stamina, then Armor, then Agility."
      Balance: "bonus damage and healing for spells first, then Intellect, then Spirit". Restoration: "bonus healing for
      spells first, …".
- [ ] Een ander class (bv. je Paladin): geen blok "Which weapon?".
- [ ] 🔧 25 nov gerepareerd: de regel over de caster-staf zegt nu "about a quarter less damage per second … hits softer in
      a form … Compare the damage per second on the item." (was fout: "hits about as hard").

## 25 nov — BEIDE GAMES: bank-characters uit "who can wear this" (Rob: "Wat betreft de bankkarakters ga ik mee met je advies. A.")

Alleen bestaande bestanden gewijzigd: `/reload` is genoeg. Offline getest (55 controles; de knop zelf NIET offline).
- [ ] Forever overzicht → **Characters**: elke rij heeft rechts een knopje **Bank: no**. Klik bij Ima Banklady: het wordt
      **Bank: yes**. Klik nog eens: terug naar no.
- [ ] Met Banklady op "yes": ga op een item staan dat zij kan dragen. Ze staat niet meer in "your other characters who
      can wear this". Bij een recept of materiaal staat ze er nog wel (als ze dat beroep heeft).
- [ ] `/mh alttip`: bij Ima Banklady staat "bank character, skipped for gear".
- [ ] Midnight (geen knop): `/mh alttip bank <naam>` zet het aan en weer uit; chat zegt wat er gebeurde.

## 25 nov — FOREVER: de enchant op wat je draagt telt mee + de alt-regel noemt alleen wie je kunt mailen (Rob: "Ja, op 1 en 2." / "kan ik überhaupt wel sturen?")

Alleen bestaande bestanden gewijzigd: `/reload` is genoeg. Offline getest (14 + 48 + 24 controles), NIET in het spel.
- [ ] Druid met de Nomadic Gloves (Light Armor Kit) aan: ga op de grijze **Worn Leather Gloves** in je tas staan. Geen groene
      regel "MH: +1 Armor over what you wear" meer (wisselen kost je de kit: −7 Armor, −1 Stamina). Geen alt-regel
      "your other characters who can wear this" (grijs item). `/mh geartip` zegt "not better (… armor -7 … lose: 15)".
- [ ] Een item dat écht beter is dan je handschoenen mét kit: de groene regel eindigt op **"You lose the enchant on what
      you wear: Armor +8, Stamina +1."** Ook in de melding "You picked up an upgrade" als je zo'n item oppakt.
- [ ] Draag je een wapen met een enchant die MH niet kan wegen (bv. Fiery Weapon): MH noemt een ander wapen niet "beter".
- [ ] Een wit item (bv. andere handschoenen): de alt-regel staat er nog wel.
- [ ] War Torn Cape (of een ander item om te versturen): **Ima Bankgirl** (Alliance) staat niet meer tussen de namen,
      maar achteraan: "· other faction, can't mail: Ima Bankgirl …". Ima Lockie, Ima Magymage en Ima
      Warman (factie nog niet opgeslagen) staan erin met "(faction ?)" — log één keer op ze in, dan verdwijnt dat.
- [ ] Zelfde bij een recept en een materiaal (bv. Peacebloom).
- [ ] `/mh alttip`: onderaan per character "counts", "apart at the end" of "left out", met de reden.
- [x] Kun je in Forever naar de andere factie mailen? ✅ GEMETEN door Rob 25 nov (via Sparring), letterlijk: *"Post naar
      de andere kant (Ima Bankgirl) --. target is unfriendly :)"* = de client-melding ERR_PLAYER_WRONG_FACTION "Target is
      unfriendly." Dus NEE. De regel zegt nu "other faction, can't mail" (was "probably not possible"); `/reload`.

## 25 nov — FOREVER: Gear check: enchants naast je character-venster (Rob: "ik zie helemaal niet of ik al iets enchant heb")

🔴 Nieuwe bestanden: sluit het spel helemaal af en start opnieuw (een `/reload` is niet genoeg). Offline getest (24
controles). Ook met CharacterScape aan.
✅ Venster GETEST 25 nov (Robs screenshots via Sparring, Druid lvl 11 met CharacterScape): Back/Chest/Wrist "no enchant",
Hands/Feet "enchanted", Main Hand "no enchant"; geen fout bij het openen.
🐞 De knop **Character** onder Now gaf een taint-fout (TextStatusBar.lua:110 "secret number value … tainted by
'MidnightHelper'"). GEREPAREERD (`/reload` genoeg): geen knop meer; de regel noemt nu je toets, bv. "Character window: C."
- [x] Open je character-venster (C). Rechts ernaast staat een klein venster **Gear check: enchants**, met per vakje dat een
      enchant kan krijgen (nek, mantel, borst, pols, handen, voeten, wapen, off-hand) de naam in groen, of rood
      **no enchant**. Lege vakjes, ringen, trinkets, hoofd, schouders en benen staan er niet in (daar kan Enchanting niets op).
- [x] Na de reparatie (`/reload`): je Druid toont op handen en voeten nu **Armor +8, Stamina +1** (een Light Armor Kit,
      GEMETEN: enchant 15 = spell 2831) in plaats van "enchanted".
      ✅ GETEST 25 nov (a178459), Rob via Sparring: *"Ja, test is goed gegaan."* + screenshot: Back/Chest/Wrist/Main Hand
      "no enchant", Hands en Feet "Armor +8, Stamina +1" (groen).
- [ ] Op je enchanter: onder een vakje zonder enchant staat grijs "you can make this yourself: …" met de enchants die je
      kent en die daar passen. (MH kent je recepten zodra je één keer je beroepsvenster hebt geopend.)
- [ ] Trek iets aan of uit: het venster past zich aan. Shift+scroll maakt het groter of kleiner; Escape sluit het.
- [ ] Overzicht → **Now**: een regel "N slots of your gear have no enchant … Character window: C." (je eigen toets). Geen
      knop meer. Daarna: geen BugSack-fout van TextStatusBar.
      ⚠️ Na a178459 niet apart gemeld: Rob noemde de Now-regel en het uitblijven van de BugSack-fout niet. Nog open.
- [ ] Stille helpers: **Gear check: enchants next to your character window**: uit = het venster en de regel zijn weg.
- [ ] `/mh enchant`: per vakje wat MH ziet (enchant-id en naam).

## 25 nov — toetsenblok: de zin bovenin klopt nu als het blok al op je balken staat

Alleen bestaande bestanden gewijzigd: `/reload` is genoeg. NIET in het spel getest.
- [ ] `/mh block` met het blok geplaatst: bovenin staat nu "… This is the block as it is on your bars now." (niet meer
      "Nothing on your bars changes until you choose to place it").
- [ ] Na **Undo** (blok eraf): weer de oude zin "This is a picture of where this character's spells would go …".

## 25 nov — BEIDE GAMES: de tooltip noemt je andere characters bij een wapen of harnas (Rob: "Zeg je ja? JA")

🔴 Herstart nodig als je de vorige ronde (recept/materiaal) nog niet met een herstart hebt getest; anders is `/reload`
genoeg. Offline getest (36 controles), NIET in het spel.
⚠️ In Forever onthoudt MH de gear van een character pas als je er na deze update één keer op hebt ingelogd. Log dus eerst
op elk character even in.
- [ ] Ga met je muis op een BoE wapen of harnas in je tas (niet soulbound). Er staat bijvoorbeeld
      **MH: your other characters who can wear this: Ima (item level 10 -> 20), Bob (from level 40), Cid**.
      Ima draagt in dat vakje nu item level 10; Bob is nog te laag; Cid kan het dragen maar het is niet hoger.
- [ ] Bij een ring of trinket vergelijkt MH met de laagste van je twee. Staat er niets in dat vakje: "(empty slot)".
- [ ] Forever: Plate bij een Warrior of Paladin onder level 40, of Mail bij een Hunter of Shaman onder 40: "(from level 40)".
- [ ] Meer dan 3 characters: de 3 met de grootste winst, dan "and N more".
- [ ] Een soulbound item: geen regel. MH zegt nergens "beter": alleen of het item level hoger is.
- [ ] Zelfde schakelaar als bij de recepten ("Your other characters in item tooltips"); `/mh alttip` toont de beslissing.

## 25 nov — BEIDE GAMES: de tooltip noemt je andere characters bij een recept of materiaal (Rob: "zodat ik weet naar wie ik het moet gaan sturen")

🔴 Nieuw bestand: sluit het spel helemaal af en start opnieuw (een `/reload` is niet genoeg). Offline getest (27 controles),
NIET in het spel. Een character telt pas mee als je er na deze update één keer op hebt ingelogd.
Forever (je Druid, met "Recipe: Elixir of Minor Agility" in je tas):
- [x] Ga met je muis op het recept staan. Onder "MH: Alchemy - yellow …" staat nu bijvoorbeeld
      **MH: your other characters with Alchemy: Ima (14, needs 50)**. Bij een character dat het recept al kent staat
      "knows it", bij een die het kan leren "can learn it" (dat weet MH pas als je op dat character één keer het
      beroepsvenster hebt geopend).
      ✅ GETEST 25 nov (Robs screenshot via Sparring, zonder tekst): Druid, Recipe: Elixir of Minor Agility, "Requires
      Alchemy (50)" → *"MH: your other characters with Alchemy: Ima Warlocky (18, needs 50)"*; klopt met Characters
      (Alchemy 18/75). ⚠️ Niet getoond, nog open: "knows it" / "can learn it".
- [x] Ga op een materiaal staan (bijvoorbeeld Peacebloom): **MH: on your other characters: Alchemy: Ima**.
      ✅ GETEST 25 nov (Rob via Sparring): *"MH: on your other characters: Blacksmithing: Ima Pallie · Leatherworking:
      Ima Shammydude · Tailoring: Ima Magieman"*. Recept- en gear-tooltip niet apart gemeld: nog open.
- [ ] Een soulbound item, of een recept dat bindt als je het oppakt: geen regel (dat kun je niet versturen).
Midnight:
- [ ] Een recept: **MH: your other characters with Alchemy: Naam (22)**: alleen naam en skill, geen "can learn".
- [ ] Een Midnight-materiaal: welke andere characters een beroep hebben dat het gebruikt.
Beide:
- [ ] Uitzetten: Forever overzicht → stille helpers "Your other characters in item tooltips"; Midnight: instellingen
      (bij de tooltip-schakelaars); of `/mh alttip off`. `/mh alttip` toont wat MH bij het laatste item besliste.

## 25 nov — FOREVER: taunt op de muis (Rob: "Ik zou graag ook een macro van willen hebben voor een mouse over") — ✅ GETEST

Alleen een bestaand bestand gewijzigd: `/reload` is genoeg. Offline getest (1128 toetsen, Engels en Russisch).
✅ 25 nov, Rob via Sparring, letterlijk (ruw, Willow; "tang" = taunt): *"De tangtesten is gelukt."* Welke class noemde hij
niet; de test hieronder was de Druid in beervorm. Warrior, Hunter en "mouseover off" niet apart genoemd.
- [x] `/mh mouseover on`. Druid in beervorm: ga met je muis op een vijand staan (niet je target) en druk **F**: Growl gaat
      naar die vijand. Zonder muis op een vijand: naar je target, zoals eerst.
- [ ] Warrior: hetzelfde met **F** (Taunt in Defensive Stance, Mocking Blow in Battle Stance).
- [ ] Hunter: Distracting Shot (oude blok **F**, 12 × 4 **Ctrl-E**) gaat ook naar de vijand onder je muis.
- [ ] `/mh mouseover off`: F gaat weer alleen naar je target.

## 25 nov — spiekbrief-code weet nu welke indeling je hebt (voor de site)

Alleen een bestaand bestand gewijzigd: `/reload` is genoeg. Niet in het spel getest.
- [ ] `/mh block export` (of de knop in `/mh block`): op de tweede regel staat achteraan `;layout=12x4;game=forever`
      (of `layout=old`, of `game=midnight` in Midnight). Plak hem op midnighthelper.com zodra de site-chat zegt dat het
      12 × 4-raster live is.

## 25 nov — FOREVER: geen "runs out soon" als een ander je een HOGERE rank gaf (Rob: "dat moet natuurlijk niet")

Alleen een bestaand bestand gewijzigd: `/reload` is genoeg. Offline getest (12 controles), NIET in het spel.
- [ ] Laat een andere mage (met een hogere rank dan jij) Arcane Intellect op je zetten. Als hij bijna op is (laatste
      5 minuten), komt er GEEN "Arcane Intellect … runs out soon" meer in beeld.
- [ ] `/mh buffs`: bij Arcane Intellect staat "runs out soon, but a higher rank from someone else is on you (rank …, you
      know rank …)".
- [ ] Is zijn buff helemaal op: dan komt de gewone melding dat Arcane Intellect ontbreekt, en de knop zet jouw eigen rank.
- [ ] Je eigen Arcane Intellect (of een even hoge/lagere van een ander) die bijna op is: "runs out soon" komt wél, zoals eerst.
- [ ] (ook, Rob op (a): *"Ik volg uiteraard jouw advies"*) Een GROEPSBUFF van een ander (Arcane Brilliance, Prayer of
      Fortitude, Gift of the Wild) die bijna op is, terwijl jij de losse buff alleen in een lagere rank kent: GEEN "runs
      out soon". `/mh buffs` zegt "a group buff from someone else is on you (…, as strong as rank …; you know rank …)".
      Is hij op: de gewone melding, en jouw eigen rank.
- [ ] Ken je de losse buff in de hoogste rank (Arcane Intellect rank 5 tegen Arcane Brilliance): dan komt "runs out soon"
      wél, en de knop zet je eigen Arcane Intellect.

## 25 nov — FOREVER: Ctrl+Shift+klik op een item in je tas = Disenchant (Rob: "we beginnen inderdaad met digijant eerst") — ✅ GETEST

Alleen bestaande bestanden gewijzigd: `/reload` is genoeg. Offline getest (36 controles).
✅ 25 nov, Rob via Sparring, letterlijk (ruw, Willow; "mates" = zijn Mage): *"Shift-Ctrl ingedrukt houden en dan klikken
naar het disenchant en dan gooit het netjes in mijn tas. Dus daar ben ik blij mee."* Afgevinkt: het paarse vakje en de
klik. Niet apart genoemd: de tooltipregel, welke tas (Blizzard of Baganator), gewone klik, gevecht, schakelaar.
Op je enchanter, met een groen of blauw wapen of armor in je tas:
- [ ] Ga met de muis op dat item staan (Blizzard-tas én Baganator). Onder "MH: Disenchantable" staat nu een regel
      **Ctrl+Shift+click: disenchant this item** (Nederlands: "Ctrl+Shift+klik: disenchant dit item").
- [x] Hou **Ctrl+Shift** ingedrukt: het vakje kleurt paars, met een klein Disenchant-icoon. Klik: je disenchant dát item.
      Laat de toetsen los vóór de loot komt (anders kan Shift je auto-loot omdraaien; dat is niet gemeten).
- [ ] Zonder Ctrl+Shift doet klikken op het vakje precies wat het altijd deed (oppakken, gebruiken, Shift-klik = link).
- [ ] Een item dat niet kan (grijs, een tas, een quest-item): geen regel, en Ctrl+Shift+klik doet het gewone.
- [ ] In een gevecht: geen regel, en het paarse vakje komt niet.
- [ ] Op een character zonder Enchanting: niets nieuws.
- [ ] Overzicht → stille helpers: de schakelaar **Ctrl+Shift+click disenchants**. Uit: de regel en het vakje zijn weg.
- [ ] `/mh disenchant`: onderaan een regel "Ctrl+Shift+click: on; last: …" met wat MH het laatst besliste.

## 25 nov (nacht) — MIDNIGHT Prot Paladin 12 × 4: nog te doen vóór 5.9.1 — ✅ GETEST

Gemeten in je SavedVariables: alles staat goed, behalve toets 1 (daar staat waarschijnlijk Blizzards "Single-Button
Assistant", die MH nooit bedekt).
- [x] Sleep de knop van toets 1 (de Single-Button Assistant: hij toont steeds een ander icoon) weg, bv. naar een Alt-plek.
      Dan `/mh block` → **Update (add new spells)**: Judgment komt op toets 1.
- [x] Ga in `/mh block` op Ctrl-V / Ctrl-X staan: de tooltip noemt je trinket. Zeg welke het is (heeft hij een Use:?).
      ✅ 25 nov, Rob via Sparring, letterlijk: *"ik heb geen trinkets met een use. Dus ja, die komen daar niet. Ik heb op
      3 verschillende gekeken."* Leeg is dus juist.
✅ Toets 1, 25 nov, Rob via Sparring, letterlijk: *"Sorry, ja, toets 1 was ook gelukt. Judgment zit nu op toets 1."*

## 25 nov (nacht) — toetsenblok: trinket-plekken eerlijk op het plaatje (Rob's Prot Paladin: Ctrl-X/Ctrl-V leeg)

Alleen bestaande bestanden gewijzigd: `/reload` is genoeg. NIET in het spel getest.
- [x] `/mh block`: staat er op Ctrl-V / Ctrl-X (12 × 4) of G (oude blok) GEEN icoon, ga er dan met de muis op staan. De
      tooltip noemt je trinket en zegt dat hij geen effect heeft dat je kunt gebruiken; daarom blijft de knop leeg.
      Staat er wel een icoon, dan zet "Place it"/Update die trinket echt op de knop.
- [x] Noem de trinket uit die tooltip aan de bouwchat: dan kijken we of hij echt geen Use:-effect heeft.
      ✅ 25 nov (Rob, zie hierboven): geen trinket met een Use:, op 3 characters gekeken. Welke trinkets het waren: niet genoemd.

## 24 nov (avond, 13) — FOREVER: het icoon volgt je vorm (Rob: "de icoontjes zijn hetzelfde als die van niet in beer vorm") — ✅ GETEST

Rob via Sparring, letterlijk: *"forever test ook gelukt met de druid, en nu weltrusten"* (de beervorm-iconen). De andere
punten hieronder heeft hij niet apart genoemd.
- [x] `/reload` op de Druid. Ga in beervorm (Ctrl-1): op toets **1** staat nu het icoon van **Maul**, op **F** dat van
      **Growl**, op **2** Lacerate (als je die hebt). Uit beervorm: weer Wrath, Rejuvenation, Moonfire.
- [ ] Ook bij kattenvorm, en op andere characters met states (Warrior-stances, Rogue Stealth): het icoon toont wat de
      toets NU doet. (Elk character repareert zijn knoppen één keer bij de eerste keer bijwerken na de update.)
- [ ] Trainervenster ("New at your trainer"): bij een spell die alleen in een vorm op een toets zit staat de vorm erbij,
      bv. "Maul -> 1 (Bear Form)". Met 12 × 4 noemt het venster de toetsen van 12 × 4 (Regrowth = Shift-C, niet F2).
- Oude melding (vervalt, was hetzelfde): "krijg deze spells niet op mijn keys". De spells werkten wel; alleen het icoon niet.
⚠️ Op versie 5.9.0 (zonder de fix van de Lua-fout KeyBlock.lua:1527) liep de vraag "New for your key block" op deze Druid
vast. Test dit dus met de versie van main.
- [ ] Druid die net Bear Form (met Growl en Maul) leerde: binnen een paar seconden vraagt MH "New for your key block …
      Bear Form -> Ctrl 1". Druk **Place it**. Komt de vraag niet: `/mh block` → "Update (add new spells)".
- [ ] Druk **Ctrl-1**: je wordt beer. In beervorm: **1** = Maul, **F** = Growl. Uit beervorm: weer Wrath op 1,
      Rejuvenation op F.
- [ ] Ook zonder inloggen: leer een nieuwe spell, en de knop klopt meteen (geen /reload nodig).

## 24 nov (avond, 12) — MIDNIGHT: toetsenblok "12 × 4" (Rob: "En ja, ik zou dit ook graag in Midnight willen", "A A A", "a ja")

🔴 Nieuw bestand: sluit het spel eerst helemaal af en start opnieuw. Offline getest (40 specs × 2 indelingen, 2688
controles), NIET in het spel. Het oude blok blijft de standaard. Op je Prot Paladin:
✅ 25 nov, Rob via Sparring, letterlijk (ruw, Willow): *"Ik heb overigens daar ook, en het was in Midnight, alle key
bindings gezet zoals de nieuwe versie doet. En dat werkt ook keurig. De wisselknop, die zat er netjes in."* Ook GEMETEN
in zijn SV (keyBlockProbe 25 nov 00:07), zie NEXT_SESSION. Afgevinkt: de wisselknop en de knoppen. De rest heeft hij
niet apart genoemd.
- [x] `/mh block`: rechtsboven de knop **Layout: the old block (switch)**. Klik, **Switch**: het blok gaat eraf, wordt
      12 × 4 en gaat weer op je balken. (Daarna kan de vraag over de extra toetsen komen.)
- [x] Op de knoppen (toets 1 na het wegslepen van de Single-Button Assistant, zie bovenaan): **1** Judgment, **2** Avenger's Shield, **3** Hammer of the Righteous, **4** Shield of the
      Righteous, **Q** Avenging Wrath, **E** Rebuke, **R** Divine Steed, **F** Hand of Reckoning, **Z** Ardent Defender,
      **X** Divine Shield, **C** Guardian of Ancient Kings, **V** Cleanse Toxins. Met Shift o.a. Blessed Hammer of
      Consecration (Shift-1/2), Divine Toll (Shift-Q), Word of Glory (Shift-C). **Ctrl-R** Redemption. Ctrl-1/2/3 = je
      aura's (als je ze hebt). Lay on Hands en een paar andere staan op blok D (Alt).
- [x] (25 nov, Rob via Sparring: *"de control rij midnight zag er allemaal goed uit zo te zien, heel snel"*: snel
      gekeken; de trinkets blijven leeg, want hij heeft geen Use:-trinket) Ctrl-F combat potion, Ctrl-Z health potion,
      Ctrl-C healthstone, Ctrl-V trinket, Ctrl-X tweede trinket: staat er
      een icoontje als je het in je tas of om hebt?
- [ ] Geen 5, T, G of F1-F4 meer op je blokknoppen.
- [ ] "Why these keys?" in `/mh block`: de Midnight-tekst (healers: noodheal op C, gewone heals op 1/2/3; de Ctrl-rij
      met combat potion en twee trinkets; Shift+Spatie = willekeurige favoriete mount).
- [ ] Extra toetsen: 5 = interact (tweede toets), Shift+Spatie = Blizzards willekeurige favoriete mount. Nog eens drukken
      = afstijgen, maar NIET in de lucht.
- [ ] How you play / speelkaart: de toetsen volgen nu je nieuwe blok (die lezen je echte balken).
- [ ] Een ander character (zelfde account): bij inloggen de vraag "Fix it now" (je toetsen gelden voor het hele account).
- [ ] Terug: knop Layout → Switch: weer het oude blok.

## 24 nov (avond, 11) — FOREVER: de buff-knop cast op JEZELF (Rob, Thorns: "moet ik eerst mezelf aanklikken")

Alleen bestaande bestanden gewijzigd: `/reload` is genoeg. Offline getest (9 controles), NIET in het spel.
✅ 25 nov, Rob via Sparring, letterlijk (ruw, Willow): *"De toonsknop in Forever Druid, die werkt goed."* ("toonsknop" =
Thorns-knop, lezing van Sparring.) De andere buffs en Revive Pet heeft hij niet apart genoemd.
- [x] Druid: target een vijand (of een ander), wacht tot "Thorns runs out soon" in beeld komt, en klik op het icoon:
      Thorns komt meteen op JOU. Je hoeft jezelf niet eerst aan te klikken.
- [x] Hetzelfde met een buff die je mist (Mark of the Wild, Arcane Intellect, Demon Skin …): één klik = op jezelf.
      (25 nov, Rob via Sparring: *"de andere buffknoppen … zag er allemaal goed uit zo te zien, heel snel"*)
- [x] Hunter met een dode pet: Revive Pet werkt zoals vroeger. ⚠️ Rob keurde "punt 2" goed (andere buffknoppen + Revive
      Pet), maar noemde Revive Pet niet bij naam en keek "heel snel".

## 24 nov (avond, 10) — FOREVER: knop "Layout" in het toetsenblok (Rob: "Ja, er moet een knop komen")

Alleen bestaande bestanden gewijzigd: `/reload` is genoeg. Offline getest (16 controles), NIET in het spel.
✅ 25 nov, Rob via Sparring, letterlijk: *"De wisselknop, de andere buffknoppen en de control rij midnight zag er allemaal
goed uit zo te zien, heel snel."* Afgevinkt: de knop en het wisselen heen en terug. Niet apart genoemd: een character
zonder neergezet blok, en de knop in een gevecht.
- [x] Open `/mh block`. Rechtsboven, onder "New spells: …", staat een knop **Layout: the old block (switch)**
      (of "Indeling: het oude blok (wisselen)" in het Nederlands). Staat er geen tekst over elkaar met de uitleg links?
- [x] Klik erop: er komt eerst een vraag "Switch your key block to 12 x 4?" met uitleg. Druk **Cancel**: er gebeurt niets.
- [x] Klik nog eens en druk **Switch**: MH haalt het blok van je balken, wisselt naar 12 × 4 en zet het meteen weer neer.
      De knop zegt nu "Layout: 12 x 4". (Daarna kan de vraag over de extra toetsen komen.)
- [x] Nog eens klikken + Switch: terug naar het oude blok, weer neergezet.
- [ ] Een character waar het blok NIET staat: de vraag zegt dat alleen het plaatje verandert; je balken blijven zoals ze zijn.
- [ ] In een gevecht: de knop doet niets en zegt waarom.
- Midnight: de knop is er nog niet, want 12 × 4 bestaat daar nog niet (dat komt in de volgende stap).

## 24 nov (avond, 9) — FOREVER: Lua-fout KeyBlock.lua:1527 bij inloggen (Druid, na een harde uitval van de pc)

Alleen een bestaand bestand gewijzigd: `/reload` is genoeg. Offline getest met Robs geval (6 controles), NIET in het spel.
- [ ] Log in op de Druid (of `/reload`): GEEN foutmelding meer van KeyBlock.lua.
- [ ] MH vraagt "New for your key block … -> Shift Z" (of druk "Update (add new spells)" in `/mh block`): druk "Place it".
      Daarna staat er weer een werkende knop op Shift-Z. (Die macro "MH SHIFT-Z" was weg door de uitval.)
- [ ] `/mh block why`: geen regel meer met een lege of kapotte macro op Shift-Z.
- [ ] (ook in deze ronde) Druid zonder Cat Form of Moonkin Form: MH stelt een nieuwe spell NOOIT voor op Ctrl-1, Ctrl-2
      of Ctrl-3. Die blijven leeg tot je de vorm leert. Staat de eigen toets van een spell vol met iets van jezelf, dan
      wacht hij (geen "-> Ctrl 1" meer).

## 24 nov (avond, 8) — FOREVER: groepsbord, de titel loopt niet meer onder het sluitkruisje (Rob: "Het afsluitknopje loopt door de tekst heen.")

Alleen een bestaand bestand gewijzigd: `/reload` is genoeg. Offline getest (44 controles), NIET in het spel.
- [ ] `/mh readyboard` (alleen, buiten een gevecht): de titel "Groepscheck: buffs en consumables" staat helemaal links
      van het kruisje. Het venster is zo breed als nodig. Het venster meet de titel zelf, dus het werkt in elke taal.
- [ ] Klik daarna op je eigen buff (Mark of the Wild bij de Druid): de klik zit nog op de goede plek.
- Ter info, geen fout: solo op de Druid is er geen healthstone-kolom. Die kolom komt alleen als er een Warlock in de
  groep zit, ook als jij dat zelf bent. Op de Warlock blijft hij rood tot je Create Healthstone geleerd hebt en een steen
  in je tas hebt.

## 24 nov (avond, 7) — FOREVER: 12 × 4 extra toetsen: 5 = interact, Shift+Spatie = je mount (Rob: "Ja, ik volg advies dus A")

🔴 Nieuwe bestanden: sluit het spel eerst helemaal af en start opnieuw (een `/reload` is niet genoeg).
Offline getest (26 controles goed), NIET in het spel. Alleen in Forever, alleen met 12 × 4.
- [ ] Een character met 12 × 4 neergezet: ongeveer 12 seconden na het inloggen vraagt MH "Two extra keys for 12 x 4?".
      In het venster staat ook wat 5 en Shift+Spatie NU doen. Druk "Set them".
- [ ] Ga voor een NPC staan, target hem en druk **5**: je praat met hem (of je loot / pakt op wat je target). Je
      numpad-punt doet nog steeds hetzelfde.
- [ ] Heb je een mount: druk **Shift+Spatie**, je stijgt op. Nog eens: je stijgt af. In de chat staat welke mount MH
      koos (de snelste die je hebt). Spatie springt nog gewoon.
- [ ] Een character zonder mount: in de chat "This character has no mount yet …". Shift+Spatie doet niets nieuws.
      Leer je een mount, dan zet MH hem vanzelf op Shift+Spatie (zonder /reload).
- [ ] `/mh block extras`: wat MH ziet (5 nu, Shift+Spatie nu, je snelste mount) en waarom.
- [ ] `/mh block extras off`: 5 en Shift+Spatie doen weer wat ze eerst deden. `/mh block extras on`: terug.
- [ ] Open "Why these keys?" (in `/mh block`): onderaan een stuk "Two extra keys", over 5 en Shift+Spatie.
- [ ] Druk je bij de vraag "No thanks": MH vraagt het niet meer. Later toch: `/mh block extras on`.
- [ ] (na de fix van 24 nov laat, `/reload` genoeg) Rob zag: *"het is nederlands (dat klopt) met engelse set them en no
      thanks eronder"*. Nu: de knoppen zijn **Zet ze** / **Nee, dank je**. Ook "Fix it now"/"Later" bij inloggen heet nu
      **Nu rechtzetten** / **Later**, en het venster "Your layout is set" (`/mh mylayout`) is nu Nederlands.

## 24 nov (avond, 6) — FOREVER: "Do this now" krijgt een knop How you play en je vrije tasplekken — ✅ GETEST

Rob via Sparring, letterlijk: *"Ja, beide zijn helemaal goed."* (de knop en de tasplekken), en later: *"En de tas werkt
inderdaad ook zoals de melding erop. Gaat ook helemaal goed. En zo speel ik knop, ben ik ook blij mee."*
- [x] Open "Do this now". Onderaan, achter "Open overzicht": een knop **How you play**. Klik: de speelkaart van dit
      character gaat open.
- [x] Onderste regel, links van je goud: een tas-icoon met "**N vrij**". Klopt N met de lege plekken in je gewone tassen?
      Een pijlkoker of soul bag telt niet mee.
- [x] Raap iets op of verkoop iets: het getal verandert meteen.
- [x] 5 of minder vrij: het getal is **oranje**. 0 vrij: **rood**. Anders wit.

## 24 nov (avond, 5) — FOREVER: How you play noemt de toetsen van JOUW indeling (Rob: "de oude keyblock staan er nog in") — ✅ GETEST

Rob via Sparring, letterlijk: *"en in how to play staat get nu goed"*. De punten hieronder heeft hij niet apart genoemd:
mag meegenomen worden als je er toch langskomt.
- [x] Warlock met 12 × 4: open How you play. Bij "Simpele volgorde": Bane of Agony (**3**), Immolate (**Shift-2**), Health
      Funnel (**Ctrl-R**), Life Tap (**F**), Soul Fire (**Q**). Geen 5, F2, F3 of F4 meer. Searing Pain blijft "(blok D)".
- [ ] "Voor je begint": de vaste toetsen zijn nu **Ctrl-Z** = potion, **Ctrl-C** = healthstone, **Ctrl-V** = trinket.
- [ ] "Wat komt later": ook daar de nieuwe toetsen ("Health Funnel op Ctrl-R", "Inferno op Ctrl-E").
- [ ] Een character met het oude blok: How you play is precies zoals vroeger (5, F2, T …).
- [ ] Zelfde in het overzicht (tab How you play).

## 24 nov (avond, 4) — FOREVER: trainerpijl stuurt niet meer weg bij je eigen trainer (Rob: "hij stuurt me een heel andere kant op")

Alleen bestaande bestanden gewijzigd: `/reload` is genoeg. Offline getest met jouw eigen opgeslagen trainerdata (10
gevallen goed), NIET in het spel.
- [ ] Warlock in Razor Hill, bij Dhugru Gorelust: `/reload`, dan de trainerpijl (knop of `/mh trainer go`). De pijl wijst
      naar Dhugru Gorelust (vlakbij), niet meer naar Mirket in Orgrimmar.
- [ ] `/mh trainer check`: de regel "short lists" noemt nu bij "arrow skipped" welke trainer en waarom (cap, bron). Dhugru
      staat daar niet meer tussen.
- [ ] Een beginnerstrainer (bijv. Nartok, cap 6) blijft overgeslagen zodra je spells boven level 6 kunt leren.

## 24 nov (avond, 3) — FOREVER: terugval zonder dubbele + "Later" onthoudt het (Rob: "Beetje verwarrend.")

Alleen bestaande bestanden gewijzigd: `/reload` is genoeg. Offline getest (16 gevallen per class/level goed), NIET in het spel.
- [ ] Warlock zonder Agony: na `/reload` vraagt MH NIET meer "Immolate -> Shift 2". Toets 3 = Immolate. Staat er nog een
      oude Immolate op Shift-2 (van eerder neergezet)? Sleep hem eraf; MH vraagt er niet meer om.
- [ ] Leer Agony bij de trainer: toets 3 wordt Agony, en MH vraagt één keer "Immolate -> Shift 2". Druk "Place it".
- [ ] Druk je bij zo'n vraag "Later": dezelfde vraag komt op dit character niet terug, ook niet als je iets anders van je
      balk sleept. Een echt nieuwe spell vraagt wel weer. De knop "Update (add new spells)" zet alles alsnog neer.
- [ ] Combat-Rogue: toets 3 = Shank, Shift-3 leeg. Paladin 24-43: toets 4 = Exorcism, Shift-4 leeg; zonder Repentance
      V = Turn Undead en Shift-F leeg.

## 24 nov (avond, 2) — FOREVER: uitlegblad "Why these keys?" voor 12 × 4 (Rob: "Dat gewoon voor iedereen weet …")

Alleen bestaande bestanden gewijzigd: `/reload` is genoeg. Offline getest (het venster bouwt en klapt open/dicht).
✅ GETEST door Rob (via Sparring 24-11, letterlijk: *"JA ZIET ER GOED UIT"*). Dat dekt de knop, het venster en de tekst;
Shift+scroll en dichtklikken zegt het citaat niet, die regel blijft open.
- [x] Forever, met 12 × 4 gekozen: open `/mh block`. Bovenin, rechts van "Hide the steps", staat een knop
      "Why these keys?". (Met het oude blok is die knop er niet.)
- [x] Klik erop: een venster "Why these keys? (12 x 4)". Bovenaan waarom dezelfde 12 toetsen en waarom elke class
      dezelfde toets voor dezelfde taak heeft (ook: C = grote heal, Shift-C = snelle heal). Daaronder vier stukken:
      zonder modifier, Shift, Ctrl, Alt. Geen spellnamen, wel per toets de taak.
- [x] Lees de tekst: staat er iets over elkaar of valt er tekst weg? Scroll naar beneden: komt het stuk "With Alt" helemaal?
- [ ] Shift+scroll op het venster: groter en kleiner. Slepen verplaatst het. Klik nog eens op de knop: het gaat dicht.

## 24 nov (avond) — FOREVER: één indeling voor al je characters (Rob: "advies a")

Alleen bestaande bestanden gewijzigd: `/reload` is genoeg. Offline getest, NIET in het spel.
Waarom: je toetsen gelden voor al je Forever-characters (GEMETEN: één bindingsbestand voor het account), maar wat op de
knoppen staat is per character. Een character dat nog het oude blok heeft, drukt nu op verkeerde knoppen.
- [ ] Warlock: `/reload`. Als MH vraagt "New for your key block … -> 3" of je drukt "Update (add new spells)": toets 3 =
      Immolate (zolang je geen Agony hebt).
✅ "Fix it now" GETEST op een Druid (Rob via Sparring, letterlijk: *"Mijn andere forever karakter. Ik heb net een druid
verder gedaan en fixit werkte. Dus dat is ook goed."*). De andere punten van deze sectie heeft hij niet apart genoemd.
- [x] Log in op een ander Forever-character dat het oude blok heeft. Na ongeveer 8 seconden: een rode regel in de chat
      en een venster "Your key block on this character is placed as the old block, but your keys now follow 12 x 4 …"
      met de knoppen "Fix it now" en "Later".
- [x] Druk "Fix it now": MH haalt het blok eraf en zet het opnieuw neer als 12 × 4. Op de knoppen alleen nog 1-4 Q E R F
      Z X C V (met s- en c-). Daarna komt het venster niet meer terug op dat character.
- [ ] Drukte je "Later": typ `/mh block fix` wanneer je wilt; dat doet hetzelfde. `/mh block why` zegt
      "placed on this character: old — the other layout: /mh block fix".
- [ ] `/mh block style 12x4` (of `old`) zegt nu ook: "Your keys count for all your characters …".
- [ ] Paladin zonder Repentance, vanaf level 24: toets **V** = Turn Undead (crowd control).

## 24 nov (later) — FOREVER: 12 × 4 reparatie na Robs Warlock-test (oude toetsen bleven op de knoppen)

Alleen bestaande bestanden gewijzigd: `/reload` is genoeg. Offline getest (de 9 toetsen van Robs screenshots worden
gevonden en losgemaakt; een toets die iets anders doet blijft), NIET in het spel.
Zo krijg je je balken goed (de oude toetsen 5, T, G, F1-F4, Shift-T en Shift-F1 raak je hiermee kwijt):
- [ ] `/reload`. Typ `/mh block why`: bovenaan "layout: 12x4" en een rode regel "keys of the other layout still bound to
      block buttons: 5 -> …, T -> …" (dat zijn de oude toetsen).
- [ ] `/mh block undo`, dan opnieuw `/mh block` en "Zet het op balk 5, 6 en 7". In de chat staat nu ook
      "9 keys of the other layout … are free now: 5, T, G, F1, …".
- [ ] Kijk naar de knoppen van balk 5, 6 en 7: alleen nog 1-4 Q E R F Z X C V, met Shift (s-) en Ctrl (c-). Geen 5, T,
      G of F1-F4 meer. `/mh block why` zegt nu "keys of the other layout on block buttons: none".
- [ ] Warlock: Ctrl-1/2/3 heten op het plaatje "Pet: Attack / Follow / Stay" met hun eigen icoon (niet meer 3× Summon
      Imp). Summon Imp staat nog één keer, op block D (Alt).
- [ ] De rode regel "Not in MH's list: Summon Demon" is weg.
- [ ] Ga je terug naar het oude blok (`undo`, `/mh block style old`, neerzetten): dan worden de 12×4-toetsen (zoals
      Ctrl-Q, Ctrl-4) op dezelfde manier losgemaakt.
- [ ] Warlock onder level 8 (nog geen Agony): toets **3** = Immolate (ook nog op Shift-2). Vanaf Agony: 3 = Agony.
- [ ] Rogue zonder Mutilate of Hemorrhage (Combat), vanaf level 24: toets **3** = Shank.
- [ ] Paladin level 20-43: toets **4** = Exorcism; vanaf 44 (Hammer of Wrath) wordt 4 Hammer of Wrath.
      (Na het leren van een nieuwe spell: `/mh block update` of de vraag van MH, zodat de knop meeschuift.)

## 24 nov — FOREVER: toetsenblok "12 × 4" (Rob: "laat een agent uitzoeken welke spells logisch zijn per class")

Alleen bestaande bestanden gewijzigd: `/reload` is genoeg. Offline getest (alle 9 classes, 2247 controles goed), NIET in
het spel. Het oude blok blijft de standaard: zonder het commando hieronder verandert er niets.
- [ ] Is je toetsenblok neergezet? Typ eerst `/mh block undo`. Typ dan `/mh block style 12x4`. In de chat staat
      "key block layout: 12 x 4". (Zonder undo zegt MH dat je eerst undo moet doen.)
- [ ] Open `/mh block`. Je ziet vier blokken met steeds dezelfde 12 toetsen: 1 2 3 4, Q E R F, Z X C V. Blok A zonder
      modifier, B met Shift, C met Ctrl, D met Alt (je eigen balk). Geen 5, T, G of F1-F4 meer.
- [ ] Blok C (Ctrl): Ctrl-Z health potion, Ctrl-X mana potion, Ctrl-C healthstone, Ctrl-V trinket en Ctrl-F bandage.
      Heb je zo'n item in je tas, dan staat het icoontje er.
- [ ] Druk op "Zet het op balk 5, 6 en 7". Probeer daarna in een gevecht: 1 = je hoofdknop, E = je interrupt (als je
      class er een heeft), R = beweging (Charge, Sprint, Blink …), Z/X/C = defensives, V = crowd control.
- [ ] Typ `/mh block why`: bovenaan "layout: 12x4", en bij elke toets een korte reden ("12x4: …").
- [ ] Terug: `/mh block undo`, dan `/mh block style old`, dan opnieuw neerzetten: alles staat weer zoals vroeger.
- [ ] Ook in het oude blok (vanaf vandaag): T = health potion en Shift-T = healthstone gebruiken nu Forever-items.

## 24 nov — FOREVER: groepsbord met buffs en consumables (Rob: "Ja maak maar", optie A) — ⏸️ LATER TESTEN, op een hoger level

⏸️ Van de lijst af, NIET getest (Rob via Sparring, letterlijk: *"De groepsport gaan we later testen als ik een hogere level
heb. Dus die mag van de lijst af."*; "groepsport" = groepsbord). De punten staan als `[later]` tot hij het oppakt.
🔴 Nieuw bestand: sluit het spel eerst helemaal af en start opnieuw (een `/reload` is niet genoeg).
Offline getest (43 van 43 gevallen goed), NIET in het spel. Alles in Forever.
- [later] Alleen, buiten een gevecht: typ `/mh readyboard`. Er komt een venster "Group check: buffs and consumables" met
      één rij (jij). Bovenaan staan kleine icoontjes per kolom; ga erop staan voor de naam.
- [later] Jouw rij: een vinkje (groen) bij wat je hebt of op je hebt, oranje bij wat alleen in je tas zit, een rood kruis
      bij wat ontbreekt. Ga op een icoontje staan: de tooltip zegt wat het is en waarom. Klopt dat met je tas?
- [later] Eet iets met een buff (Well Fed) of drink een elixer: binnen een seconde wordt die kolom groen.
- [later] Ben je een Mage, Priest, Druid of Paladin: rechts staat je eigen buff. Klik erop: je cast hem op jezelf.
- [later] Shift+scroll op het venster maakt het groter/kleiner; slepen verplaatst het. Klik daarna nog eens op je buff:
      de klik zit nog op de goede plek.
- [later] In een groep: elke speler een rij. Bij de anderen staat alleen een vraagteken bij de spullen (ga erop staan:
      "MH kan niet in hun tas kijken") en hun buffs: groen = heeft hem, rood = mist hem. Ga op een buff staan: je ziet
      wie hem kan geven.
- [later] Als jij de buff geeft: klik op de buff bij een groepslid → je cast hem op die speler.
- [later] Iemand start een ready check: het venster gaat vanzelf open. `/mh readyboard auto off` → niet meer;
      `/mh readyboard auto on` → weer wel.
- [later] Begin een gevecht: het venster gaat dicht. In een gevecht zegt `/mh readyboard` dat het nu niet kan.
- [later] Na de test: `/mh readycheck` en `/reload`. Dan leest de bouwchat `foreverReadyProbe` uit je SavedVariables.

## 24 nov — FOREVER: twee kleine fixes na de hotfix van 23 nov (Sparring 24-11: "ga door met de kleine dingen") — GEACCEPTEERD, niet apart getest

✔️ Rob via Sparring, letterlijk: *"Toets 3 van de warrior en de priestgids, die volg jouw advies."* (de rest van de Warrior
blijft zoals hij is). Geaccepteerd, NIET apart in het spel getest: de punten staan als `[geaccepteerd]`.
Alleen bestaande bestanden gewijzigd: `/reload` is genoeg. Offline getest (toets 3: 9 van 9 gevallen goed), NIET in het spel.
- [geaccepteerd] Warrior zónder het talent Mortal Strike (bijvoorbeeld Fury or Protection, of een lage Warrior): toets **3** in je
      toetsenblok doet Bloodthirst of Shield Slam, niet Mortal Strike. Typ `/mh block why`: staat Mortal Strike in je
      spellbook, dan zie je onderaan een grijze regel "Mortal Strike: talent not bought: skipped".
- [geaccepteerd] Warrior mét het talent Mortal Strike (Arms): toets 3 doet gewoon Mortal Strike, zoals altijd.
- [geaccepteerd] (Wie het kan) Koop of reset het talent Mortal Strike buiten een gevecht: binnen een paar seconden wisselt toets 3 mee.
- [geaccepteerd] Priest, venster "How you play", sectie met beginnersfouten, regel "Healing in Shadowform": er staat nu alleen
      "Fear Ward does not work in it either". Chastise (de Dwarf-spell) staat er niet meer in, want die werkt sinds de
      hotfix wél in Shadowform. Andere taal: dezelfde regel, ook zonder Chastise.

## 23 nov — FOREVER: layer-meting (Rob: "Ik ga uiteraard weer voor jullie advies." = A + D), de 3 metingen

Nieuw bestand: sluit het spel eerst helemaal af en start opnieuw. MH laat nog NIETS zien; het schrijft alleen op.
◐ 23 nov, Rob: *"ook de layer test gedaan en reload gedaan"* en *"Nee, ik ben niet uitgenodigd of naar andere legen gegaan."*
GEMETEN in `layerProbe` (SV 16:37): één `/reload` in Durotar (1411), 23 s later `/mh layer` = 2 spelers, 9 NPC's, 0 getagd.
Geen zonewissel, geen verplaatsing, geen uitnodiging in het log. Meting 3 dus één keer gedaan (in een rustig gebied);
meting 1 + 2 open. BugGrabber: niets van MH.
- [ ] Meting 3 (drukte): ga in een druk gebied staan en typ `/mh layer`. De eerste regel telt spelers en "already tagged"
      monsters om je heen. Klopt dat ongeveer met wat je ziet? (Zie je "Friendly player nameplates are OFF", dan telt hij
      alleen spelers van de andere factie; dat is een spelinstelling.)
- [ ] Meting 1 + 2 (wisselen): laat je één keer uitnodigen door iemand op een andere layer (een vriend, of met een
      wissel-addon zoals LayerSwap aan) en accepteer. Wissel ook één keer gewoon van zone. Daarna `/mh layer` en `/reload`.
      De bouwchat leest `MidnightHelperDB.layerProbe` en ziet dan of "je wordt verplaatst" alleen bij het wisselen komt.

## 23 nov — FOREVER: teller in het class-questkaartje (Rob: "kunnen we dat daar ook niet gewoon in hetzelfde schermpje erbij plaatsen met hoeveel ik op dat moment heb?")

Alleen bestaande bestanden gewijzigd: `/reload` is genoeg.
⏸️ 23 nov, Rob: *"ik had de quest al afgemaakt dus we gaan er van uit dat het werkt"*: NIET in het spel gezien. Alleen de
offline-test is gemeten. Bij de eerstvolgende class-quest met een teller kijken.
- [ ] Een class-quest in je log met iets te verzamelen (bv. Vile Familiars, warlock): het kaartje toont onder de opdracht in
      groen de stand uit het spel, bijvoorbeeld "Vile Familiar Head: 4/6".
- [ ] Verzamel er nog één: binnen een seconde staat er 5/6, zonder dat je iets doet.
- [ ] Alles verzameld: het kaartje zegt "lever in bij <NPC>" (zoals altijd al).
- [ ] Dezelfde stand staat ook in "Do this now" en in het overzicht (tab Now), tussen haakjes achter de opdracht.

## 23 nov — FOREVER: oude weetjes in de class-quests gerepareerd (Rob: "Ja, 1, 2 en 3")

Alleen bestaande bestanden gewijzigd: `/reload` is genoeg. Alleen te zien met de juiste class; heb je die niet, sla over.
- [ ] Rogue, level 23 of hoger, Dead Drop-ketens nog niet gedaan: de class-questregel zegt eerst "wait for a letter from C in
      your mailbox, then go to the Dead Drop" (en niet meer "get the quest").
- [ ] Rogue, level 30, The Horn al ingeleverd: de Eye-regel zegt "wait for a letter from C: it comes once you are level 30 and
      visit a capital city …". Hij verschijnt pas als de betaling (78307) gedaan is, niet al na de eerste Horn-quest.
- [ ] Mage, de coffers-stap: de zin eindigt op "You need 3" (de "5 minutes" is weg). Warlock, de sjaal: geen "1 in 20" meer.

## 23 nov — FOREVER: upgrades aantrekken vanuit "Do this now" (Rob: "Ja, doe maar OR-B.")

✅ **GOEDGEKEURD** (Rob 23 nov via sparring, letterlijk: *"ORB is goedgekeurd. Alles doet hij wat hij moet doen."*;
"ORB" = Willow voor wear B). Een goedkeuring voor het geheel; welke punten hij los zag, zei hij niet.
Nieuw bestand: sluit het spel eerst helemaal af en start opnieuw (`/reload` is hier niet genoeg).
- [x] Geen rode fout bij inloggen.
- [x] Leg een stuk uitrusting in je tas dat beter is (de tooltip heeft de groene regel "MH: …"). "Do this now" gaat
      **vanzelf open** (Rob: *"Opvallen A."*; in de stand "alleen als er iets is"). Bovenaan, onder een eventuele
      talentregel, staat in groen met een pijltje omhoog: "Upgrade: [item] · <vak> · <wat beter is>  [Wear it]  [Not this
      one]". Muis op [Wear it]: de tooltip van het item.
- [x] Klik het kruisje zonder te kiezen: het venster blijft dicht. Het gaat pas weer vanzelf open als er een NIEUWE upgrade
      in je tas komt.
- [x] Pak een upgrade op in een gevecht: het venster komt pas na het gevecht.
- [x] Twee upgrades in je tas: twee regels. Klik [Wear it] bij één: hij gaat aan (bij een Bind on Equip-item vraagt het spel
      eerst zelf of het mag). De andere regel blijft staan, tenzij hij nu geen upgrade meer is.
- [x] Klik [Not this one]: die regel verdwijnt en komt niet terug. `/mh wear reset` haalt hem terug.
- [x] In een gevecht staat er "after the fight" in plaats van [Wear it]. (Het venster verdwijnt in een gevecht; dit zie je
      alleen als je het opnieuw opent met `/mh donow`.)
- [x] Overzicht (`/mh overview`, tab Now): dezelfde upgrade staat er met een knop "Wear it".
- [x] Instellingen → AddOns → Midnight Helper → "On-screen buttons": "Show upgrades in "Do this now"" uit → de regels weg; aan → terug.
- `/mh wear why` = per stuk uitrusting in je tassen MH's oordeel en waarom (voor ons).

## 23 nov — FOREVER: QuestieDB stap B (Rob: "Ik volg jullie advies weer.") — wat MH ermee doet

Nieuwe en gewijzigde bestanden: sluit het spel eerst helemaal af. QuestieDB moet aan staan (dat deed je al).
✅ Punt 1-3: Rob 23 nov via sparring, letterlijk: *"1 tot en met 3 is goed."* Bij 4 stuurde hij een screenshot van
Wailing Caverns: daar heeft geen gever een gat, dus terecht geen "(QuestieDB)" (GEMETEN in de data). Opnieuw met
`/mh dungeons quests SM_GY` ("Vorrel's Revenge") of `/mh dungeons quests RFD` ("Scourge of the Downs").
- [x] Geen rode fout bij inloggen en na `/reload`.
- [x] Maak een quest af, maar lever hem nog NIET in. Open "Do this now" (`/mh donow`) of het overzicht, tab Now. Je
      ziet een regel "Ready to turn in: "<quest>" at <NPC>, <zone> (QuestieDB)." en een knop **Turn in**.
- [x] Klik **Turn in**: de pijl wijst naar die NPC en de chat zegt "arrow set to … (QuestieDB)". Klopt de plek?
- [ ] Lever de quest in: de regel verdwijnt (binnen een seconde).
- [x] ✅ na 5c8233d (Rob 23 nov via sparring, letterlijk: *"ennuh, een reload was genoeg, zoals zo vaak :)"* + screenshot:
      "Inside: Vorrel Sengutz (QuestieDB)" onder "You get these inside the dungeon"; RFD niet apart getest). Was ❌
      (Rob 23 nov, screenshot SM_GY: "Vorrel's Revenge" bleef "our source gives no place", geen (QuestieDB)). GEMETEN:
      QuestieDB heeft Vorrel alleen als "in een instance" (-1,-1), geen plek voor een pijl; zo ook 6 van 10 nagekeken
      gevers. Gerepareerd: zo'n quest staat nu onder **"You get these inside the dungeon"** met "Inside: Vorrel Sengutz
      (QuestieDB)". Opnieuw: herstart, `/mh dungeons quests SM_GY` → staat Vorrel's Revenge daar zo?
- [x] ✅ (Rob 23 nov via sparring, letterlijk: *"Stap 5 uit en aan, die werkte."*) Instellingen: Esc → Options → tab **AddOns** → **Midnight Helper** → kopje **"On-screen buttons"**, onder
      ""Do this now" window" en "Small group panel": schakelaar **"Use QuestieDB if you have it"** staat aan. Zet hem uit: de "Ready to turn in"-regel en de (QuestieDB)-plekken verdwijnen. Weer aan: ze komen terug.
- [ ] Een gevecht: geen "action blocked" op naam van MidnightHelper.
- `/mh questiedb why` = wat MH besloot en waarom (voor ons).
- [x] ✅ (Rob 23 nov via sparring, screenshot: WC "Done already: 1 of 15", één "The Glowing Shard · Inside: Disciple of
      Naralex") **Eén Glowing Shard**: `/reload` → `/mh dungeons quests WC`.
- [ ] ⏸️ Niet te testen op dit character (Rob 23 nov: RFC "Done already: 9 of 10", de Hidden Enemies-keten al af) — keten
      met één naam blijft zichtbaar: alleen offline gecontroleerd.
- [ ] 🆕 (Rob: *"En nightmares, ja,"*) "In Nightmares" (WC) komt nu ook vrij na de ándere Glowing Shard. Alleen te zien
      nadat je The Glowing Shard hebt ingeleverd: dan staat In Nightmares onder "Pick these up first". Offline getest.
- [x] ✅ (Rob 23 nov via sparring, letterlijk: *"Stap 6, gevecht gedaan en geen errors gekregen."*) Stap 6: gevecht zonder
      fout. **Stap B is daarmee helemaal getest.**

## 23 nov — FOREVER: meting "quest A" (kan MH QuestieDB lezen?) — `/mh questiedb`

Alleen een meting: spelers zien niets en er verandert niets in het spel. Het is een nieuw bestand, dus sluit het spel
eerst helemaal af.
- [x] ✅ (Rob 23 nov via sparring: *"klaar"*; GEMETEN in de SV: geladen) Characterscherm → knop **AddOns** → vink
      **QuestieDB** aan → spel starten. ◐ Laadtijd: Rob zei niets, ook niet "trager".
- [x] ✅ (GEMETEN in de SV + BugGrabber: 0 leesfouten, geen rode fout) Typ `/mh questiedb`. Je ziet 5 of meer regels in
      de chat (versie, tijd van de vragen, geheugen, trainerplekken). Daarna `/reload`.
- [x] ✅ (GEMETEN: NPC 5817, Orgrimmar, 0,21) Optioneel, de sterkste test: ga naast een NPC staan, bijvoorbeeld een
      trainer, en klik hem aan (target). Typ `/mh questiedb here`. Een getal onder 1.0 = goede plek. Daarna `/reload`.
- Daarna zegt Rob "klaar" via sparring; de bouwchat leest `MidnightHelperDB.questieDbProbe` en zegt of B kan.

## 23 nov — PTR 12.1.7 (draaiboek §3, `_ptr_` = 12.1.7.71087, MH 5.8.0)

- [x] ✅ (Rob 23 nov via sparring, letterlijk: *"Alle 5 tests gaat goed."*) Laden zonder rode fout, toetsenblok neer en
      terug, `/mh apply` dry run → go → undo, Options → Keybindings, balken op hun plek. "Simple Keybinds" stond er NIET op 12.1.7.71087 (Rob, letterlijk:
      *"nee, stond er niet simple keybinds"*).
- [ ] Patchdag (2 dec): Options → Keybindings nog eens kijken of "Simple Keybinds" er nu wel staat. Zo ja: NIET aanzetten,
      melden.
- [ ] Een Talebound-character: `/mh` → MH hoort daar NIET te laden. Niet getest: Rob heeft geen Talebound-character
      (*"Ik heb geen tailbound character, dus daar kan ik niet zoveel mee."*).

## 22 nov — vóór een go voor 5.8.0 (Rob: "Zerlt klaar , ik log straks nog in")

Sluit het spel eerst helemaal af: het versienummer en de nieuwe bestanden laden pas na een herstart.

- [x] ✅ (Rob 22 nov via sparring, stand VÓÓR het weghalen van Platynator, letterlijk: *"Ik zit nu in World of Warcraft
      Midnight. Daar staat alles op. Ik kan Midnight helpen openen. En ik zie geen foutmeldingen komen."*) Midnight:
      inloggen geeft geen Lua-fout. (Pijl en gevecht niet gemeld.)
- [x] ✅ (Rob 22 nov via sparring, op fac9074, letterlijk: *"midnight goed tekst goed"*) Midnight, NA "platy weg": spel
      helemaal afsluiten en starten → MH openen, tab Addons: alleen de knop Details!, die pagina staat open en er komt geen
      Lua-fout.
- [x] ✅ (zelfde melding; sparrings stap met "als nog niet gedaan") Midnight: de pijl bij rares.
- [x] ✅ (zelfde melding; sparrings stap met "als nog niet gedaan") Midnight: één gevecht zonder "action blocked".
- [ ] Midnight: tooltip op een ingrediënt. (Mocht hij overslaan zonder ingrediënt: niet als gezien gemeld.)
- [x] ✅ (zelfde melding: *"tekst goed"*) De releasetekst van 5.8.0 zoals op fac9074, met de Platynator-regel. Waylaid Crates
      blijft eruit (Rob: *"crates zwijgen en go voor 5.8.0"*).
- [x] ✅ (Rob 22 nov via sparring: *"de drie testjes zie screens"*; screenshot nagelezen) Forever: Quests bij een dungeon →
      Way › meldt "arrow set to Rahauro (Thunder Bluff) for "Testing an Enemy's Strength"", gelijk aan de data (q 5723, npc
      11833); die regel komt pas als de waypoint gezet is (code).
- [ ] Vervolg: de pijl zelf zien en bij die questgever aankomen. (Stond niet op het beeld.)
- [x] ✅ (zelfde melding, screenshot) Forever: `/mh rest off` → de chat zegt dat de waarschuwing uit is; `/mh rest on` → weer
      aan. Beide regels gelijk aan enUS.
- [x] ✅ (zelfde melding, screenshot) Forever: `/mh bagfull show` → bij drie grijze dingen staat de prijs los van de tekst.

## 22 nov — Forever: trainerplekken in de class quests, Zygor + HandyNotes live (Rob: "Plekken b")

Typ eerst `/reload`. Het handigst met een character dat een briefje moet inleveren (bv. een Night Elf hunter). De
kaartjetest van 22 nov ("kaartje goed") dekt dit niet: de bron van de plek zat niet in die stappen.

- [ ] `/mh classquest` → onder de open stap staat "place of Ayanna Everstride from: …". Met HandyNotes: Class Trainers
      aan: "HandyNotes: Class Trainers (read live)". Sprak je die trainer al eens, dan "seen: …": die plek wint.
- [ ] Show the way → de pijl komt bij de trainer uit, niet in een muur ernaast.
- [ ] Zet HandyNotes: Class Trainers uit + `/reload` → dezelfde regel zegt "Zygor (…not installed, switched off …)" en de
      pijl werkt nog (tenzij "seen"). Zet de addon daarna weer aan.
- [ ] Bij Dark Cleric Duesten of Aramis: altijd "Rob measured", ook met HandyNotes aan.
- [ ] Doe daarna een gevecht: geen melding "action blocked".

## 22 nov — Forever: class-queststap als kaartje + de briefjes van level 1 (Rob: "b")

Afgevinkt = Rob 22 nov via sparring, verse Tauren hunter, met screenshot, letterlijk: *"kaartje goed, hebben we dit voor
meerdere classes ?"* Alleen de 8 stappen van sparring.

- [x] ✅ (Rob 22 nov) `/reload`; vóór "The Hunt Begins" is ingeleverd: geen kaartje over het briefje.
- [x] ✅ (Rob 22 nov) Ingeleverd → kaartje "Get it from Grull Hawkwind".
- [x] ✅ (Rob 22 nov) Aangenomen → "Hand it in to Lanka Farshot". GEMETEN op zijn screenshot van die stap: icoon,
      "HUNTER · LEVEL 1", "Etched Note", "Mulgore", de onderregel, groene rand, dicht, Show the way.
- [x] ✅ (Rob 22 nov) Show the way → de pijl komt bij Lanka uit.
- [x] ✅ (Rob 22 nov) Ingeleverd → het kaartje is weg.
- [x] ✅ (Rob 22 nov) Een beestje verslaan → geen melding "action blocked".
- [ ] Andere classes en rassen (alle 9 classes, 56 briefjes): bv. een Night Elf (1 quest, 11 monsters), een warlock (Imp
      gaat vóór het briefje), een Skyborne (pas op level 2).
- [ ] Show the way bij de stap "Get it from …" → de pijl naar wie het briefje geeft.
- [ ] Een bestaand character boven level 5: geen briefje. Heb je een class-queststap open, dan is dat nu een kaartje met
      de questnaam, bij wie, waar en waar het voor is ("teaches you …" of "for: …"). Geen stap = geen kaartje
      (`/mh classquest` zegt waarom, onderste regel).
- [ ] Kruisje → weg tot de volgende stap. Escape → weg tot de volgende quest-update. Slepen → na `/reload` op dezelfde
      plek. Shift+scroll = groter en kleiner.
- [ ] Quiet helpers → "Small window with your class quest step" uit → het kaartje is weg; aan → het is terug.

## 22 nov — Forever: 11 vensters dicht in stijl A (Rob: "Doe maar vensters A")

Typ eerst `/reload`. Ga bij nameplates staan. Vier vensters kun je openen:
Afgevinkt = Rob 22 nov via sparring, letterlijk: *"Nee, dit was mijn fout. Ik was vergeten nog te reloaden. Dus de vensters
zijn goed. Dat kan je goedkeuren."* Alleen wat in de stappen van sparring stond.
- [x] ✅ (Rob 22 nov) `/mh bagfull show` (Bags full): dicht, tekst past.
- [x] ✅ (Rob 22 nov) `/mh crates test` (Crates): dicht, tekst en knop passen.
- [x] ✅ (Rob 22 nov) `/mh durability test` (Durability): dicht, tekst past.
- [x] ✅ (Rob 22 nov) `/mh play` (How to play): dicht, tekst past.
- [x] ✅ (Rob 22 nov) In elk van de vier: Escape sluit.
- [x] ✅ (Rob 22 nov) Daarna een gevecht: geen "action blocked" op naam van MidnightHelper.
- [ ] Bags full: Destroy vraagt eerst, Equip werkt (als die er staat).
- [ ] Crates: muis op de naam = tooltip. Durability: muis op het item = tooltip.
- [ ] Durability: de rode kop blijft rood.
- [ ] How to play: scrollen tot onderaan, niets valt weg.
- [ ] In elk van de vier: een knop die uit staat is vaag, Shift+scroll maakt groter of kleiner.
- [x] ✅ (Rob 22 nov: *"de drie testjes zie screens"*) Bags full: de prijs loopt niet door "Poor (grey): junk, only worth its
      vendor price." (GEMETEN op zijn screenshot: drie rijen, los van elkaar).
- [ ] ❓ Controlepunt (niet repareren): dezelfde rij met een langere uitlegregel, of in een andere taal. GEMETEN in de code:
      `r.why` loopt tot aan de knop, dus tot onder de prijs (`r.value`). Dat het dan botst, is AFGELEID.
- [niet te testen] Characters, Dungeons, Macros, Profession trainers, Trainer, Vendors en Weapons zijn ook aangepast, maar
      openen niet meer: elk commando en elke knop gaat naar het overzicht (GEMETEN in de code). Alleen buiten het spel getest.

## 22 nov — Forever: Skill up-venster gerepareerd (Rob: "venster ja")

- [x] ✅ (Rob 22 nov via sparring: *"Venster is goed"*) Typ `/reload`, dan `/mh skillup`, met nameplates of mobs achter het venster: het is dicht, er loopt niets door de tekst.
- [x] ✅ (Rob 22 nov via sparring: *"Venster is goed"*) Klik een ander beroep: je ziet welk beroep gekozen is.
- [x] ✅ (Rob 22 nov via sparring: *"Venster is goed"*) De knop onderin noemt het beroep ("Show the way to a Leatherworking trainer").
- [ ] De tekst past erin, ook "… an Alchemy trainer". Klik: de pijl gaat naar een trainer van dat beroep.
- [x] ✅ (Rob 22 nov via sparring: *"Venster is goed"*) Een recept zonder bekende persoon: "MH doesn't know which trainer yet" of "… which vendor yet".
- [ ] Diezelfde zin in de tooltip.
- [ ] Muis op een itemnaam = de tooltip; scrollen schuift de tekst; Shift+scroll maakt het venster groter of kleiner;
      Escape sluit het.

## 22 nov — ronde 1 gedaan, dit staat nog open (Rob via sparring, letterlijk: *"ronde 1 klopt"*)

Ronde 1 was: herstart zonder rode fout; elk eigen beroep open met een kloppend aantal (alleen het character waar hij op
zat); in Bags full niets wat hij wil houden + één grijs ding met Destroy; voorwaardelijk Equip, vrij talentpunt en pet;
daarna een gevecht zonder "action blocked". Niet los getest: elke soort bewaard item, bijna vol + schakelaar, grijs zonder
waarde, gelinkt venster, Equip in gevecht, andere characters. Ronde 2 = ingrediënten, recept-pijl, dungeon-quests, XP per
uur: open, in de secties hieronder.

- [x] ✅ (Rob 22 nov via sparring, op fac9074: *"midnight goed tekst goed"*) Midnight: inloggen, geen rode foutmelding.

## 22 nov — Forever: huisdieren en rijdieren nooit weggooien (Rob: "dieren ja")

- [ ] Typ `/reload`, dan `/mh bagfull show`: een huisdier (Cat Carrier, Parrot Cage …) of rijdier in je tas staat er niet in.
      `/mh bagfull` noemt het bij "left out".
- [x] ✅ (Rob 22 nov via sparring: *"ronde 1 klopt"*) Een gewoon grijs ding staat er nog wel in.
- [ ] ◐ (zat voorwaardelijk in ronde 1; Rob zei niet of het zich voordeed) De Equip-regel voor een reservetas werkt nog.

## 22 nov — Forever: waar haal ik dit recept? (Rob: "1 b", "plek ja", "alles advies")

- [x] ✅ (Rob 22 nov via sparring: *"ronde 1 klopt"*) **Sluit het spel helemaal af en start opnieuw** (nieuwe bestanden). Open eerst elk eigen beroep 3 seconden
      (gedaan op één character).
- [ ] Muis op een receptitem (Pattern:, Plans:, Recipe: …) of iets maakbaars dat je NIET kent: onder "You do not know this
      recipe" staat waar je het haalt. Ken je het wel: geen bronregel.
- [x] ✅ (Rob 22 nov via sparring, screenshot ronde 2) Bij sommige staat "Needs: …" (reputatie, munt, specialisatie) of "Classic data, not yet seen in
      Forever" (gezien in Skill up: reputatie + de Classic-zin; munt en specialisatie niet).
- [x] ✅ (Rob 22 nov via sparring, screenshot ronde 2) `/mh skillup`: onderaan per beroep hooguit drie recepten die je nu kunt leren, met waar.
- [ ] Daar een knop "The way to <naam>" als er iemand bekend is (bij Robs drie niet, klopt met de data). Een ingrediënt
      dat je tekortkomt gaat op die knop voor.
- [ ] Klik de knop, loop erheen: staat die persoon daar, en heeft hij dat recept? Zo niet: welk recept en wie.
- [ ] **Daarna een gevecht**: geen "action blocked" op naam van MidnightHelper.
- [ ] `/mh skillup probe` zegt bij "where you get a recipe" waarom, en noemt Polestar met CC BY 4.0.

## 22 nov — Forever: Bags full bewaart nog meer (Rob: "alles advies", tassen B)

- [ ] Typ `/reload`, dan `/mh bagfull show`: gif, drankjes, elixers, flasks, verband, scrolls, sleutels, tassen, recepten
      en leerboeken staan er NIET in. `/mh bagfull` noemt ze bij "left out".
- [ ] ◐ (zat voorwaardelijk in ronde 1; Rob zei niet of het zich voordeed) Leeg tasvakje + losse gewone tas: de Equip-regel staat er nog en werkt.
- [x] ✅ (Rob 22 nov via sparring: *"ronde 1 klopt"*) Een gewoon grijs ding staat er nog wel in, met Destroy.

## 22 nov — Forever: "bekende recepten" gerepareerd (Rob: "Recepten ja")

- [ ] Typ `/reload`, wacht 15 seconden, typ `/mh skillup probe`: "copy of the lists … kept" en bij "professions you do not
      have" hoeveel er weg zijn. Een character zonder Blacksmithing kent geen Blacksmithing-recepten meer.
- [x] ✅ (Rob 22 nov via sparring: *"ronde 1 klopt"*) Open elk eigen beroep 3 seconden, typ `/mh skillup probe`: "<BEROEP> replaced: … known". Dat aantal
      klopt met wat je echt kent. **Alleen het character waar hij op zat** (GEMETEN in de SV: 1 lijst 40 → 25, kopie aanwezig).
- [ ] Hetzelfde op elk ander character, per beroep (hun lijsten staan nog zoals ze waren).
- [ ] Muis op iets wat je NIET kunt maken in dat beroep: de tooltip zegt dat je het recept niet kent.
- [ ] Klik een beroep-link van iemand anders: `/mh skillup probe` zegt "nothing written", je aantal blijft gelijk.
- [ ] `/reload` en log opnieuw in: je echte recepten staan er nog.

## 22 nov — Forever: hulp bij bijna vol + grijs zonder waarde (tassen, punt c en d)

- [ ] Typ `/reload`. Vul je tassen tot 2 plekken vrij (of `/mh bags 8` om het sneller te zien): het venster opent vanzelf
      met de titel "Bags almost full". Niet in gevecht: dan komt het erna. Eén keer per keer vollopen, en nog eens bij 0.
- [ ] Is er niets om aan te bieden, dan blijft het stil; `/mh bagfull` zegt bij "almost full" waarom.
- [ ] Quiet helpers → "Help when your bags are almost full" uit (of `/mh bagfull early off`): het venster komt pas bij
      echt vol.
- [ ] Een grijs ding zonder verkoopwaarde staat bovenaan met "Grey and worth nothing at a vendor." Destroy vraagt eerst.
      Wit zonder waarde, quest-items en gereedschap staan er niet in. "Sell MH junk" laat het staan.
- [ ] **Daarna een gevecht**: geen "action blocked" op naam van MidnightHelper.

## 22 nov — Forever: reservetas eerst aantrekken (tassen, punt b)

- [ ] Typ `/reload`. Zorg voor een leeg tasvakje en een losse gewone tas in je tas. `/mh bagfull show`: de bovenste regel is
      die tas, met de knop "Equip" (het woord van het spel). Bij meer tassen staat de grootste eerst.
- [ ] ◐ (zat voorwaardelijk in ronde 1; Rob zei niet of het zich voordeed) Klik Equip: de tas zit in het vakje, er is niets weg, en het venster werkt zichzelf bij.
- [ ] In gevecht op Equip klikken: rood "You can't do that while in combat", er verandert niets.
- [ ] ◐ (zat voorwaardelijk in ronde 1; Rob zei niet of het zich voordeed) **Na het aantrekken een gevecht**: geen "action blocked" op naam van MidnightHelper.
- [ ] Geen leeg tasvakje: geen Equip-regel. `/mh bagfull` zegt bij "spare bag" waarom.

## 22 nov — Forever: Bags full gooit geen voorraad weg (tassen, punt a)

- [ ] Typ `/reload`, dan `/mh bagfull show`. Eten, drinken, pijlen, kogels en class-reagentia (bv. Rune of Teleportation,
      Ankh, Symbol of Kings) staan er NIET in.
- [ ] `/mh bagfull`: bij "left out" staat "food or drink", "ammunition" of "class reagent" met het aantal.
- [x] ✅ (Rob 22 nov via sparring: *"ronde 1 klopt"*) Een gewoon grijs ding staat er nog wel in, met Destroy. **Daarna een gevecht**: geen "action
      blocked" op naam van MidnightHelper (GEMETEN in BugGrabber, 12:22: sessie 338, nieuwste fout uit 335).
- [ ] (niet apart bevestigd in ronde 1) Destroy vraagt eerst "weet je het zeker?"; klik Yes: het ding is weg.

## 22 nov — Forever: waar haal ik dit ingrediënt? (Rob: "1 b", "plek ja", "overnemen, ja")

- [x] ✅ (Rob 22 nov via sparring: *"ronde 1 klopt"*) Sluit Forever helemaal af en start opnieuw (nieuwe bestanden), geen foutmelding.
- [ ] Muis op Copper Ore: onder "MH: Used for …" staat "MH: Gathered with Mining". Op Silverleaf: "… with Herbalism".
- [ ] Muis op Coarse Thread of Empty Vial: "MH: Sold by <naam> (<zone>, afstand)". Klopt die verkoper, en verkoopt hij het?
- [x] ✅ (Rob 22 nov via sparring, screenshot ronde 2) Muis op Linen Cloth: "MH: Dropped by monsters".
- [x] ✅ (Rob 22 nov via sparring, screenshot ronde 2) Light Leather: "MH: Gathered with Skinning" (gezien in Skill up, niet in de tooltip).
- [ ] Muis op Light Hide: géén "waar"-regel (één bron, dus MH zwijgt).
- [ ] (22 nov later, *"alles advies"*) Muis op Crisp Spider Meat: "MH: Dropped by monsters". Op Heavy Stock: een verkoper.
- [ ] Alliance, muis op Green Dye: een verkoper met zone (die was er eerst niet).
- [ ] `/mh skillup`, een beroep waar je een te kopen ingrediënt tekortkomt: de regel staat eronder en onderin een knop
      "The way to <naam>". Klik: de pijl gaat naar die verkoper.
- [ ] `/mh usedfor off`: alle regels weg; `/mh usedfor` zegt waarom de laatste regel er wel of niet stond.

## 22 nov — Forever: talentpunt valt op in Do this now (Rob: "talent b", later "knop weg")

- [x] ✅ (Rob 22 nov via sparring: *"talent goed"*) De regel staat bovenaan: goud, ster, witregel, blauwe naam met tooltip.
- [x] ✅ (Rob 22 nov via sparring: *"talent goed"*) Geen vrij punt meer: de regel is weg.
- [vervallen] De knop Talents en zijn gevecht-punt: de knop is weg (*"knop weg"*, na "action blocked").
- [ ] ◐ (zat voorwaardelijk in ronde 1; Rob zei niet of het zich voordeed) Typ `/reload`. Met een vrij punt eindigt de gouden regel op "Open Talents with <jouw toets>." en er is geen knop
      Talents meer, ook niet bij die regel in `/mh overview`.
- [ ] ◐ (zat voorwaardelijk in ronde 1; Rob zei niet of het zich voordeed) Druk je eigen toets, zet het punt, Apply.
- [x] ✅ (Rob 22 nov via sparring: *"ronde 1 klopt"*) **Daarna een gevecht**: geen "action blocked" op naam van MidnightHelper.
- [ ] ◐ (zat voorwaardelijk in ronde 1; Rob zei niet of het zich voordeed) Dat gevecht met een pet die komt of gaat: geen "action blocked".

## 22 nov (ochtend) — Forever: meting "Waar haal ik dit vandaan?" (Rob: "1 b")

- [x] ✅ (Rob 22 nov via sparring: *"meting gedaan"*; uitslag: 0 van 132 Cooking-recepten met een bron. De chat zei twee keer
      "closed" door CharacterForever; gerepareerd, niet opnieuw nodig) Forever: typ `/reload`. Open een beroep waarin je nog niet alles kent (bv. Cooking) en laat het venster open.
      Typ `/mh skillup source`. In chat: "recipe source test: window open, N recipes listed" en daaronder twee regels met aantallen.
- [x] ✅ (Rob 22 nov: *"meting gedaan"*) Sluit het venster, typ het nog eens: "window closed". Typ daarna `/reload` (dan staat de uitslag in het bestand).

## 22 nov (ochtend) — Forever: `/mh rest off` werkt weer

- [x] ✅ (Rob 22 nov via sparring: *"de drie testjes zie screens"*) Forever: typ `/mh rest off`. In chat: "no more message about low mana or health…". `/mh rest on` zet hem terug.
- [ ] `/mh rest test show`: twee regels op je scherm (mana en health; een class zonder mana krijgt alleen health).
- [ ] `/mh rest` print twee blokjes: "rested XP tip…" en "rest warning…". `/mh rest go` zet nog steeds de pijl naar de inn.

## 21 nov (nacht) — Forever: XP per uur + tijd tot je volgende level

- [x] ✅ (Rob 22 nov via sparring, screenshot ronde 2) Forever, niet op max level: speel ruim 5 minuten en haal wat XP (kill of quest). Open `/mh overview`: onder de
      XP-balk staat nu een tweede regel "level N in X h Y min" (gezien: "level 14 in 1 h 0 min").
- [ ] Muis op die balk: "About … XP per hour".
- [ ] Klopt het ongeveer? Na een tijdje spelen hoort de tijd te zakken als je doorspeelt, en te stijgen als je stilstaat.
- [ ] `/reload` of uit- en inloggen: het getal blijft (MH telt alleen ingelogde tijd op dit character).
- [ ] Quiet helpers → "XP per hour and time to the next level" uit: de regel en de tooltipregel zijn weg.
- [ ] `/mh rest xp` print het getal en waarom (of waarom nog niet).

## 21-22 nov — Forever: dungeon-quests (terug op 22 nov, Rob: "overnemen, ja")

- [x] ✅ (Rob 23 nov via sparring, ronde 2, letterlijk: *"een test : een dungeon-quest , werkt"*) Eén dungeon-quest werkt.
      Welke quest en welke stappen hieronder hij zag: nog niet bekend (sparring vroeg het). De losse punten blijven open.

- [ ] **Sluit het spel helemaal en start het opnieuw** (nieuwe bestanden; `/reload` is niet genoeg).
- [ ] Forever: `/mh overview` → tab Dungeons. Bij een dungeon voor je level staat onder "Way ›" (en "Bosses") een knop
      "Quests N". Muis erop: hoeveel nu op te halen, in je log, in de dungeon, later, gedaan.
- [ ] Klik "Quests N": een venster "Quests for <dungeon>". Groen bovenaan = "Pick these up first" met questgever en zone;
      "Way ›" zet de pijl naar de questgever en zegt het in chat. Klopt de plek (Zygors coördinaten, nog nooit gezien)?
- [ ] Een quest die je al hebt staat geel onder "Already in your quest log"; een gedane quest telt mee in "Done already".
      Pak er één op terwijl het venster open is: hij springt vanzelf naar "in je log".
- [ ] Questnamen in je eigen taal (de client); staat er toch Engels, dan wist de client de quest nog niet. Even sluiten en
      opnieuw openen hoort dat op te lossen.
- [ ] Shift+scroll maakt het venster groter/kleiner, Escape sluit het.
- [ ] Daarna een gevecht: geen "action blocked" op naam van MidnightHelper.
- [ ] `/mh dungeons quests check` print per quest wat MH besloot en waarom.

## 🚦 Minimaal vóór 5.7.0 (21 nov; Rob is ziek, alleen dit)

- [x] ✅ (Rob in het spel, Midnight, 21 nov: geen foutmeldingen) Midnight (retail): inloggen en `/reload` zonder foutmelding.
- [ ] ❌ (Rob, 21 nov: alleen "The Labyrinth of Kindo'jan 0", tooltip ~30 facties uit alle uitbreidingen, allemaal "not unlocked
      yet") in het alt-overzicht de regel "Renown (whole account)" met de Midnight-facties. Meting gedaan (21 nov).
- [x] ✅ (Rob in het spel, Midnight, 21 nov: *"Zo is het goed."* — "7 of 10 at max · lowest: Preyhunter's Journey 1") Alt-overzicht: één korte regel "Renown (whole account): N of 11 at max · lowest: … — point here
      for all"; muis erop = alleen de Midnight-facties, eerst die nog niet op max staan. Direct na inloggen eventueel even
      "the game is still loading this", daarna vanzelf de echte regel.
- [x] ✅ (Rob in het spel, 21 nov: *"Ik heb gekeken naar het overzicht voor Forever. En dat zag er goed uit"*; eerder de
      Now-tab) Forever: `/mh overview` — de tabbladen rechts openen allemaal.
- [x] ✅ (Rob in het spel, 21 nov: *"reload gedaan, melding is weg"*) Mage: "Do this now" zegt niets meer over "Comprehend Scroll Rank …". Andere spells met echte rangen
      (bv. Frostbolt) worden nog wel gemeld als er een oude rang op een knop staat.
- [x] ✅ (Rob in het spel, Forever/Undercity, 21 nov, screenshot "Destroy [Tough Jerky]? It is gone for good. Yes/No": *"En
      ook dit werkt."*) Forever: Tas vol (`/mh bagfull test`) → *Destroy* op een grijs item: eerst "weet je het zeker?".
- [ ] Forever: muis op een Waylaid Crate: de regels van MH in de tooltip (bundels, of waar je inlevert).
- [ ] (21 nov, reparatie) Tas vol: de regel "Repair & sell: …" staat onderaan naast de knop, niet meer door de derde rij heen.

✅ **Rob, 17 nov (nacht), via sparring, letterlijk: *"Midnight zelf werkt helemaal goed."*** Retail (Midnight) nagelopen na
alle wijzigingen van vandaag aan gedeelde bestanden (KeysHub, FastMark, instellingen, Core): `/mh`, Alt+M, minimapknop,
snelbalk, instellingen — geen foutmeldingen. Forever wordt nu getest (uitslagen via sparring).

📝 **Waarneming Rob, 16 nov (nacht), Forever mage, via sparring:** *"mouse over werk"* — `/mh mouseover on`, Shift+X
(Arcane Intellect) op een voorbijganger onder de muis werkt.

✅ **Rob, 18 nov, via sparring, letterlijk: *"1 tot en met 4 gaat goed, 5 gedaan. Wat ik wel niet kon is zoeken op AH ,
een logische afkorting voor de action house. 6 komt later"*** (Willow: "action house" = Auction House). Zoekbalk stap 1 +
stap 2 werken in Forever; `/mh repprobe` gedaan. De Midnight-check van de zoekbalk komt later.

✅ **Rob, 18 nov, via sparring, letterlijk: *"1 is goed gekeurd"*** (sparring: "zijn Forever-test van de testlijst is OK").
Sparring legde uit: punt 1 was *"Forever: sluit WoW één keer helemaal af en start opnieuw. Loop dan de testlijst door: de
zoekbalk, de reputaties, de rares, de muntjes, de Now-kaart, het ronde plaatje en de schakelaars."* Afgevinkt met
"(Rob, 18 nov, punt 1)". NIET afgevinkt: Midnight, Travel (nieuw), en wat niet in die zin stond (druid-vorm, leeg vakje,
achternaam, "Step aside"-instelling, Your path, Set focus). Daarna vond Rob nog: "scroll for more" over de tekst
(gerepareerd, zie Travel) en het boek bij de mage-quest "Study" (in bouw).

✅ **Rob, 19 nov, via sparring, letterlijk: *"de testen 1 tot en met 5 zijn allemaal goed en goedgekeurd"*** (sparring:
1 trainer-pijl, 2 Comprehension-rij, 3 Recipes-regel, 4 rares bij het huidige gebied, 5 lichtblauw + goud). Test 6, het
rank-lijstje: werkt (screenshot: "You just learned", Conjure Water rank 1 -> 2 en Frost Armor rank 1 -> 2, met de knoppen
Upgrade / Not now / Never). Afgevinkt met "(Rob, 19 nov)". De hulpregels ("typ /mh … als het niet werkt") blijven open.

## 📚 21 nov — Forever, mage: waar je Study kunt doen

`/reload` is genoeg. Forever, mage met Study.
- [ ] Overzicht → Professions → Comprehension-kaartje: regel "Library for Study: Garion Wendell, Stormwind City, …"
      (Alliance) of "Owen Thadd, Undercity, …" (Horde), en "Light Feather: you have N. Not sold by vendors …".
- [ ] Find → In town → "Library (Study)": één regel voor jouw kant, Show the way zet de pijl naar de bibliothecaris.
      (Andere klassen zien deze regel niet.)
- [ ] Muis op Study in je spellbook: dezelfde twee regels onder de tooltip van het spel.
- [ ] Is Study klaar (geen cooldown): in Do this now bij de tips "Study is ready. Library for Study: …". Klopt de plek:
      werkt Study als je bij die bibliothecaris staat?

## ⛏️ 21 nov — Forever: de ster bij kruiden en erts kleurt mee als je dichterbij loopt

`/reload` is genoeg. Forever, gloed-schakelaar aan.
- [x] ✅ (Rob in het spel, 21 nov, 2 screenshots) Loop naar een Peacebloom: ver weg grijze ster + grijs bloem-icoon,
      dichtbij GROENE ster + gekleurd icoon. → Rob koos daarna optie C (hieronder).
- [x] ✅ (Rob in het spel, Forever, 21 nov, via /mhtest; hij meldde ook "de ster was groen") Optie C, na `/reload`: met Herbalism blijft de ster bij een Peacebloom GROEN, ook van ver. Een kruid of ader die je
      niet kunt (geen beroep, of je skill te laag, bv. Mageroyal 50 met Herbalism onder 50): ROOD.
- [x] ✅ (Rob in het spel, 21 nov, Paladin zonder Herbalism, screenshot: rode ster) Zonder beroep: rood. → Rob daarna:
      *"eigenlijk zouden we die dingen alleen maar moeten kunnen zien op het moment dat we het ook echt hebben"*, en
      *"Van heb je beroep wel mijn skill te laag, dan blijft hij rood. En zo hoort het ook."*
- [ ] (21 nov, na Robs wens) Zonder het beroep: GEEN gloed van MH meer (ook geen rode). `/mh sparkle`: "reason: skipped:
      no Herbalism".
- [x] ✅ GEMETEN (Rob in het spel, Forever, 21 nov, Paladin met lage Mining, ertsader, waarschijnlijk Tin): MH-ster ROOD +
      houweel-icoon, en het spel zelf zegt in rood "Requires Mining 65". Klopt met de tabel (Tin 65).
- [ ] (21 nov) Forever-overzicht → Dungeons: de regel "The way there: …" (bv. bij Ragefire Chasm, Wailing Caverns,
      Deadmines, Ruins of Lordaeron) breekt af vóór de knoppen "Way ›" en "Bosses" en loopt er niet meer onder door.
- [ ] (21 nov) Smart Buff op een Priest en een Druid: zelfde stappen als hieronder (alleen de mage is getest).
- [x] ✅ (Rob 22 nov via sparring, Forever, mage: *"smart buff goed"*) (21 nov) Mage, Priest of Druid: Quiet helpers → "Smart Buff macro" aan. Het macrovenster gaat open met de macro
      "MH Smart Buff"; sleep hem naar een balk. Muis op een vriendelijke speler, druk: hij krijgt Arcane Intellect /
      Power Word: Fortitude / Mark of the Wild. Geen muis op iemand, wel een doelwit: het doelwit krijgt hem. Niemand: in
      chat "MH Smart Buff: put your mouse on a friendly player …". `/mh smartbuff` toont de macrotekst.
- [ ] (21 nov) Warrior, Rogue, Hunter, Warlock of Shaman: dezelfde schakelaar aan → de melding "Your class has no long
      buff for other players …", en de schakelaar blijft uit.
- [ ] (21 nov) Shaman met ongebruikte talentpunten (Rob: level 11, 2 punten): Do this now zegt "You have 2 unused talent
      points. Next: Thundering Strikes (1/5)." (of het eerste talent uit de Enhancement-volgorde dat je nog niet hebt).
      Geen richting gekozen: "(You chose no direction …)" erachter. Op level 25-39: biedt MH Stormstrike aan, en kun je hem
      echt kiezen? Zo niet: zegt MH dan het volgende talent? `/mh talent` toont het.
- [ ] (21 nov) Priest met een vrij talentpunt: MH volgt Shadow (eerste talent: Wand Specialization, dan Spirit Tap);
      richting Holy: Holy Specialization. Mage: Frost (Improved Frostbolt). Warlock: Affliction (Improved Corruption);
      richting Destruction: Bane. Priest op 27-29: biedt MH Vampiric Embrace aan, en kun je hem kiezen?
- [ ] (21 nov) Hunter met een vrij talentpunt: MH volgt Beast Mastery (eerste talent: Deadly Aspects). Rogue: Combat
      (eerste talent: Remorseless Attacks, dan Efficient Strikes).
- [ ] (21 nov) Warrior met een vrij talentpunt: zonder richting volgt MH Protection (eerste talent: Shield
      Specialization); met richting Arms: Improved Rend. Druid: zonder richting Feral (eerste: Ferocity); met richting
      Restoration: Heart of the Wild. `/mh talent` noemt de bron en waar de gidsen het oneens zijn ("about this order").
- [ ] (21 nov) Paladin met een ongebruikt talentpunt: Do this now zegt "Talent point: put it in <talent> (n/max)". Met
      de muis op de naam zie je de tooltip van het talent. Zonder gekozen richting volgt MH Retribution (eerste talent:
      Deflection) en staat er "(You chose no direction …)" achter. Zet het punt: de regel verdwijnt. Typ `/mh talent`:
      je ziet hoeveel vrije punten MH leest, de hele volgorde met jouw punten, en "<- next".
- [ ] (21 nov) Quiet helpers → schakelaar "Next talent point in Do this now" uit: de talentregel is weg.
- [ ] (21 nov) Paladin, Warrior of Druid: open How you play (tab Your class). Bovenaan staat een blok "Level as
      Retribution, tank as Protection" (Paladin) of "Level and tank as a …", altijd helemaal open. Onderaan staat het
      stuk "Talents: reset and Dual Spec".
- [ ] (21 nov) Paladin (Undead), level 18-19, Two-Handed Swords nog niet geleerd: Do this now heeft een tip "Wolfsbane …
      Learn Two-Handed Swords first, from Archibald in Undercity". Vanaf 20 staat hij bij de taken. De knop "Show the way"
      opent Find op Two-Handed Swords en zet de pijl.
- [ ] (21 nov) Een character op level 40 of hoger zonder Dual Spec: tip "Dual Spec: from level 40 …". Na het kopen moet de
      tip weg zijn. Blijft hij staan? `/mh donow check` → regel "Dual Spec switch (63644) known:" — zeg wat er staat.
- [ ] (21 nov) Paladin met de richting Protection: de stat-regel zegt nu "Stamina, then Intellect" (was Strength).
- [x] ✅ (Rob in het spel, Forever, 21 nov: *"zoeken naar de schakelaar is ook gelukt"*) Zoekbalk in het Forever-overzicht: typ `spar`, klik "Quest items sparkle …". De pagina Quiet helpers gaat
      open, de schakelaar staat in beeld en licht 2 seconden goud op. Typ ook `ore`, `herb` en `glow`: je ziet de twee
      erts/kruiden-schakelaars (het icoon van het spel en de gloed van MH).
- [x] ✅ (Rob in het spel, Forever, 21 nov: *"staat er ook in. Dus dat is ook goedgekeurd"*) Onder "MIDNIGHT HELPER" linksboven staat klein "for WoW Forever". Ook in de oude layout (tabs bovenaan):
      de tekst raakt de tabs niet.
- [x] ✅ GEMETEN (Rob in het spel, Forever, 21 nov, Paladin met Mining, ertsader, 2 screenshots) Schakelaar "the game's
      icon" UIT, gloed AAN: geen game-icoon én geen MH-ster. Beide AAN: houweel-icoon + gouden MH-ster. De gloed heeft het
      icoon van het spel dus nodig; teruggedraaid (gloed zet het icoon weer zelf aan).
- [ ] (21 nov, na de terugdraai) Schakelaar "the game's icon" UIT, gloed AAN, bij een ader die je kunt mijnen: je ziet
      weer het houweel-icoon van het spel én de gouden MH-ster. De uitleg bij de gloed zegt dat het icoon meekomt.
- [x] ✅ (Rob in het spel, Forever, 21 nov, via /mhtest) Sta bij een kruid en typ `/mh sparkle`: regel "last node: Peacebloom (object 1618), kind herb, colour green, reason:
      …". Screenshot.

## ✨ 21 nov — Forever: slimme zegen ook op je doelwit

`/reload` is genoeg. Forever, je paladin, slimme zegen-knop aan (`/mh blesstip button on`), macro "MH Smart Bless" op een balk.
- [x] ✅ (Rob in het spel, Forever, 21 nov, na 71521af: *"Ja, hij kreeg werkelijk wat ik gaf. Zowel iemand die niet getarget
      was, als iemand die wel getarget was."*) Selecteer een vriendelijke speler (klik erop), haal je muis weg en druk de knop: hij krijgt de zegen voor zijn klasse.
      Ook als hij wegloopt, zolang hij binnen bereik is.
- [x] ✅ (Rob in het spel, Forever, 21 nov, zie hierboven; macrovenster toonde "#showtooltip / /cast [@mouseover,help,nodead]
      Blessing of Wisdom") Muis op een ándere vriendelijke speler terwijl je iemand geselecteerd hebt: de knop zegent die onder de muis (muis gaat voor).
- [ ] Niemand onder de muis en geen vriendelijk doelwit: de knop doet niets (geen zegen op jezelf).
- [ ] `/mh blesstip`: regels "target now: …" en "the key runs: /cast [@mouseover,help,nodead] …; [@target,help,nodead] …".
      Typ het met een speler geselecteerd. Screenshot.
- [ ] In een gevecht: de knop werkt met de laatste keuze van vóór het gevecht (MH kan hem dan niet bijwerken).
- [x] ✅ (Rob in het spel, Forever, 21 nov: eerst ❌ na 5213ee8, na reparatie 2 (71521af) werkt het; *"Oh, dat is
      dynamisch. Dat is tof zeg."*) MH schrijft de /cast-regel IN de macro "MH Smart Bless" zelf; je toets/muisknop met de
      macro geeft de zegen. Macrovenster toont de regel (62/255 tekens).
- [ ] Geen doelwit en niemand onder de muis: chatregel "MH Smart Bless: no friendly player …".
- [ ] `/mh blesstip`: regel "macro "MH Smart Bless" now: #showtooltip | /cast …".

## 🛩️ 21 nov — Forever: welke zeppelin bij een toren met twee platforms

`/reload` is genoeg. Forever, Horde, bij de toren buiten Orgrimmar (Durotar).
- [x] ✅ (Rob in het spel, 21 nov: nam het ZUIDELIJKE platform en kwam goed aan in Tirisfal) Tirisfal = zuidelijk platform.
- [ ] Route naar Tirisfal Glades: de pijl wijst naar Frezza, en de zin zegt "the zeppelin to Tirisfal Glades (the
      south platform, with Frezza)". Naar Stranglethorn/Grom'gol: "(the north platform, with Snurk Bucksquick)".
- [ ] "You are at …" komt pas als je vlak bij DIE meester staat, niet bij het andere platform.
- [ ] Find → Travel: beide zeppelins in Durotar staan er met de naam van hun meester. Show the way wijst naar hem.
- [ ] Ook in Undercity (Zapetta naar Orgrimmar, Hin Denburg naar Grom'gol) en Grom'gol (Nez'raz naar Orgrimmar, Squibby
      Overspeck naar Undercity).

## 🔑 21 nov — Forever: elk character zijn eigen opslag (twee Ima's)

Nieuw bestand → **WoW helemaal herstarten**. Forever. Je oude gegevens worden alleen gekopieerd, nooit gewist.
- [x] ✅ (Rob in het spel, 21 nov) Log in op een eerste Ima (bv. Ima Pallie). Typ `/mh charkey`: per onderdeel staat "key Player-…" en "copied from …"
      (of "already there"). Screenshot. — Ima 1 = Player-6944-0118CB4F; kopie GEMETEN in de SV.
- [ ] Doe iets dat per character onthouden wordt: zet in Ranks (je spell-ranks) een balk of knop op "never touch". Log uit.
- [x] ✅ (Rob in het spel, 21 nov; Ranks-deel overgeslagen: dat character heeft niets met ranks) — Ima 2 = Player-6944-0120ED18,
      poleGear "copied from Ima-", toolTip + ranks "copied from Ima-CAMWOW EU4 Realm 10 RP + Ima-", copies so far 9.
      Log in op een tweede Ima (bv. Ima Lockie). `/mh charkey`: een ANDER "Player-…"-nummer. De keuze van de eerste Ima
      staat hier ook (dat is de kopie van de oude gedeelde data), maar verander je hem hier, dan blijft hij bij de eerste
      Ima zoals hij was. Log terug op de eerste Ima en kijk.
- [ ] Een character met een unieke naam (Joey, Inchy, …): `/mh charkey` zegt "copied from "Joey-…"", en zijn oude
      dingen (bv. Ranks-keuzes, de vis-uitrusting die MH onthield) zijn er nog.
- [ ] Speltoets-indeling (key block): op elke Ima eigen codes na het inloggen (die maakt MH zelf opnieuw).

## 📦 21 nov — Forever: Waylaid Crates

Nieuwe bestanden → **WoW helemaal herstarten**. Forever, een character van level 10 of hoger.
- [ ] `/mh crates`: de chat noemt je Merchant's Favor, je rang bij Azeroth Commerce Authority (Alliance) of Durotar Supply
      and Logistics (Horde), of je eerste Shipping Label al gedaan is, en bij wie je inlevert. Daarna `/reload` en zeg het
      tegen de sparring: Claude leest dan wat de game in de tooltip van je kratten zet.
- [ ] Muis op een krat met een soort erachter (bv. "Waylaid Crate: Apprentice Herbs"): een gele regel "fill it with ONE of
      these bundles", dan elke bundel met "you have N" en een groen vinkje als je genoeg hebt, rood kruisje als niet.
      Kloppen de aantallen met je tassen (en bank)? Screenshot.
- [ ] Muis op een lege "Waylaid Crate": "Right-click to read the label …".
- [ ] Muis op een verzegelde krat of een Shipping Label: "Deliver it to Marcy Baker / Dokimi (zone, afstand)". Bij een
      Shipping Label, als je de eerste nog niet deed: een blauwe regel "Your first shipping label gives once …".
- [ ] Krijg je een verzegelde krat of Shipping Label in je tas: een klein venster "…: ready to deliver" met
      "Show the way". Zet de knop de pijl naar Marcy Baker (Redridge) of Dokimi (The Barrens)? Klopt de plek? Test zonder
      krat: `/mh crates test`.
- [ ] Find -> In town -> "Deliver crates": één regel (jouw kant), bovenaan je Favor en rang. Show the way werkt.
- [ ] Quiet helpers → "Help with Waylaid Crates" uit = geen regels en geen venster meer.

## 📋 20 nov — De testlijst in het spel (alleen voor Rob)

Nieuwe addon → **WoW helemaal herstarten** (in retail én in Forever). In de addonlijst staat "MH Testlist (Rob only)".
- [x] ✅ (Rob in het spel, Forever, 21 nov: *"Hij komt inderdaad in te staan in de chat."*) Na het inloggen zegt de chat
      "MH Testlist: … testpunten. Typ /mhtest".
- [x] ✅ (Rob in het spel, Forever, 21 nov: *"het fancy dat werkt"*) Typ `/mhtest`: een venster met links de testrondes (de nieuwste) en rechts de punten als kaartjes. Screenshot.
- [x] ✅ (Rob in het spel, Forever, 21 nov: 3 antwoorden + een opmerking gezet; commando-knop en tellers niet apart genoemd)
      Per punt: Goed / Fout / Overslaan (nog een keer klikken = weg), een opmerkingenveld, en een knop per commando die
      het in je chatregel zet (dan Enter). De tellers bovenaan en links lopen mee.
- [ ] "Nieuwste" / "Alles" bovenaan, Shift + muiswiel = groter/kleiner, slepen aan de titelbalk, Escape sluit.
- [x] ✅ (Rob in het spel, Forever, 21 nov; GEMETEN: `run testlist_ingame read` las 3 resultaten uit de Forever-SV)
      Klaar: knop "Reload". Zeg het dan tegen de sparring; Claude leest je vinkjes en opmerkingen uit en zet ze hier.

## 🏅 20 nov — Midnight: Renown in je alt-overzicht (O14)

`/reload` is genoeg. Midnight (retail), het alt-overzicht (Account snapshot).
- [x] ✅ (Rob in het spel, Midnight, 21 nov, na de reparatie: *"Zo is het goed."*, screenshot) Bovenaan, onder de titel:
      één regel "Renown (whole account): …" met de renown-facties van Midnight.
- [x] ✅ (Rob, 21 nov, screenshot: 11 regels, niet-max eerst) Muis op die regel: tooltip met elke factie, rang en voortgang.
      (Sindsdien: een track die je nog niet hebt valt weg zolang de rest leesbaar is.)
- [ ] Er is GEEN renown-kolom per character bijgekomen (renown is voor je hele account).

## 🛡️ 20 nov — Forever: waarschuwing versleten uitrusting

Nieuw bestand → **WoW helemaal herstarten**. Forever.
- [ ] `/mh durability test`: een klein rood venster "Your gear is at N% - repair before you pull!", je meest versleten item,
      en "Repair & sell: <naam>, <zone>, <afstand>" met een knop. Zet de knop de pijl? Screenshot.
- [ ] Echt: speel tot je meest versleten item onder 25% zakt (of sterf een paar keer). Het venster komt één keer, niet in
      een gevecht (dan erna). Na repareren en weer zakken komt hij opnieuw.
- [ ] Quiet helpers → "Warn when your gear is worn" uit = geen venster meer. `/mh durability` zegt wat MH zag.

## 🔧 20 nov — Forever: Repair & sell

Nieuw databestand → **WoW helemaal herstarten**. Forever.
- [ ] Find → "What am I looking for?" → onder "In town" staat **Repair & sell**: verkopers die repareren, dichtstbijzijnde
      eerst (op een Engelse client met hun ondertitel, bv. <Armorer>), elk met Show the way. Klopt de eerste?
- [ ] Find → "Which city?" → een stad: ook een regel "Repair & sell" met de dichtstbijzijnde daar.
- [ ] Tas vol-venster (`/mh bagfull show`): onderaan "Repair & sell: <naam>, <zone>, <afstand>" en een knop die de pijl
      zet. Werkt de pijl?
- [ ] Praat met een verkoper die repareert die NIET in de lijst stond, en met een verkoper die niet repareert. Daarna
      `/mh vendor check`: "repair: … learned …, … dropped" telt mee.

## 🗑️ 20 nov — Forever: Tas vol, stap 2 (Destroy, loot, verkopen)

`/reload` is genoeg (geen nieuw bestand). Forever.
- [ ] `/mh bagfull show`: elke regel heeft een knop **Destroy**. Klik: een venster vraagt "Destroy <item>? It is gone for
      good." Ja = het item is weg, de chat zegt "destroyed …" en de lijst ververst. Probeer het op iets grijs.
- [ ] Zegt de chat "the game did not allow this"? Dan ligt het item weer in je tas. Screenshot (dan weten we dat het spel
      vernietigen met een echt item strenger behandelt dan de test).
- [ ] Met een volle tas looten: Destroy, dan de knop **Pick up the loot** onder het lootregeltje. Komt de loot in je tas?
- [ ] Bij een verkoper met grijze spullen: onder het verkoopvenster een knop **MH: sell junk (N)**. Klik: alleen grijze
      items worden verkocht (max 12), de chat noemt het bedrag. Je hengel, questitems en niet-grijze spullen blijven.
- [ ] `/mh bagfull test` nog één keer, nu BIJ een verkoper (er gaat niets weg). Komt er geen rode BugGrabber-fout meer?

## 🎒 20 nov — Forever: Tas vol, stap 1 (idee 1)

Nieuw bestand → **WoW helemaal herstarten**. Forever.
- [ ] **Eerst de test voor stap 2:** typ `/mh bagfull test`, klik de knop midden in beeld één keer. Er gaat GEEN item weg
      (hij probeert vernietigen en verkopen op een lege cursor en een leeg tasvak). Screenshot van de chat-uitslag, ook als
      er een rode melding "blocked" van het spel komt. Liefst één keer bij een verkoper en één keer ergens anders.
- [ ] `/mh bagfull show`: venster "Bags full" met de drie goedkoopste dingen, hun waarde en waarom ze weg kunnen. Klopt
      het? Staat er iets in dat je zeker wilt houden? Screenshot.
- [ ] Echt: loop met een volle tas en loot iets dat niet past. Het venster komt vanzelf, met onderaan "Loot: … is worth
      …, your cheapest item …" en of ruilen loont.
- [ ] Nooit in de lijst: questitems, je gereedschap, spullen voor je eigen beroepen, gear die beter is dan wat je draagt,
      Rare en beter, je Hearthstone.
- [ ] **Gerepareerd na Robs test (20 nov):** je Fishing Pole (en elke andere hengel, Mining Pick, Skinning Knife,
      Blacksmith Hammer, runed rods …) staat er NIET meer in, ook als je dat beroep niet hebt. `/mh bagfull show`
      met de hengel in je tas: staat hij er niet in? `/mh bagfull` zegt dan "profession tool" bij "left out".
- [ ] `/mh bagfull` (zonder iets) zegt wat MH zag en wat hij wegliet. `/mh bagfull off` zet het automatische venster uit.

## 🔨 20 nov — Forever: Skill up voor je beroepen (idee 6)

Nieuw bestand → **WoW helemaal herstarten** (niet alleen /reload). Forever, een character met een maakberoep.
- [ ] **Eerst de meting:** open je beroepsvenster (bv. Cooking of Blacksmithing), sluit het, typ `/mh skillup probe`.
      Screenshot van de chat. (Zegt welke API Forever heeft en of de client zelf een receptkleur geeft.)
- [x] ✅ (Rob in het spel, Forever, 21 nov, Tailoring 32/75, screenshot: "make about 12x Linen Cloak (skill 32 to 42)",
      "Then: Simple Linen Pants", 3 zekerste oranje ~100%, "Bolt of Linen Cloth: need 12, you have 3 · 9 more", Coarse
      Thread groen) `/mh skillup` (of Overzicht → Professions → knop **Skill up**): links je beroepen, rechts "Next step:
      make about Nx … (skill A to B)", "Then: …", drie "Surest points now" met kleur en %, en "What you need".
- [ ] Klopt het recept met wat jij zou maken? (niet genoemd)
- [x] ✅ (Rob in het spel, Forever, 21 nov, screenshot) In Skill up zijn alle recept- en itemnamen gekleurde [links].
- [ ] Muis op een naam = de tooltip van het spel. Scrollen met het muiswiel werkt nog, Shift + wiel maakt het venster
      groter/kleiner. (niet genoemd)
- [x] ✅ (Rob in het spel, Forever, 21 nov, screenshot: "make 9 [Bolt of Linen Cloth] first (needs 18 [Linen Cloth], you
      have 3)") Onder een tekort dat je zelf kunt maken met een recept dat je kent: "make … first".
- [ ] (21 nov, later) "needs …" staat nu op een eigen, ingesprongen regel onder "make … first".
- [ ] (21 nov) Tooltip op de naam ook in: het venster versleten uitrusting ("Lowest: …"), het krat-venster, en de
      loot-regel van Tas vol.
- [ ] Knop "Show the way to your trainer" zet de pijl naar je beroepstrainer.
- [ ] Overzicht → Professions → jouw beroep: bovenaan de kaart een blauwe regel "Skill up: next, make about …".
- [ ] Tooltip van iets dat je maakt (bv. Rough Sharpening Stone): "MH: Blacksmithing - yellow 15, green 35, grey 55" en
      "Your skill N: <kleur>, about N% chance of a point (estimate)". Klopt de kleur met de kleur in je beroepsvenster?
- [ ] Tooltip van een Plans:/Pattern:-item dat je nog niet kent: de grenzen + "You do not know this recipe (yet)."
- [ ] Tooltip van een ingrediënt (bv. Rough Stone): "MH: a skill point now with … (about N%)".
- [ ] Nog nooit een beroepsvenster open gehad op dit character? Dan zegt het venster "Open your … window once".
- [ ] `/mh skillup off` haalt de tooltip-regels weg, `/mh skillup on` zet ze terug.

## 🛏️ 20 nov — Forever: alle herbergen (ook Ratchet en de dorpen)

`/reload` is genoeg. Forever.
- [ ] Find → "Which city?" → onder "OTHER TOWNS" staan nu ook dorpen, bv. Ratchet, en als Horde Razor Hill en
      The Crossroads (Alliance: Goldshire, Lakeshire …). Dichtstbijzijnde bovenaan. Klik Ratchet: rechts Inn
      (Innkeeper Wiley) en wat er verder in Ratchet staat, niet dat van The Crossroads.
- [ ] Find → "What am I looking for?" → Inn: ook de dorpsherbergen, dichtstbijzijnde eerst.
- [ ] Hearthstone in een dorp gezet (bv. Razor Hill)? Dan staat achter dat dorp "Hearthstone", en de route-regel
      ("The way there: …") rekent met je Hearthstone naar dat dorp.
- [ ] Rested XP-venster bij uitloggen buiten een rustplek: noemt nu ook een dorpsherberg als die het dichtst is.
- [ ] Staat een herberg op een verkeerde plek? Zeg welke; Rog'Mar, Powderfuse Port en Farholde Keep (Riverglades)
      zijn het minst zeker, en Light's Hope Chapel (omgerekend) en Lakeshire (verschoven).
- [ ] Mount Hyjal: Summit of Eternity (Alliance), en in het westen een Alliance- en een Horde-herberg (die heten in de
      lijst "Mount Hyjal"). Kun je als Horde ook bij Sebelia (Summit of Eternity) binden? Dat weten we niet.

## 🏙️ 20 nov — Forever: Find, stap 3 ("Which city?")

`/reload` is genoeg. Forever, `/mh` → tab Find.
- [ ] Bovenaan de linkerkaart twee knoppen: "What am I looking for?" en "Which city?", daaronder een zoekveld
      ("search..."). Staat de tekst op de knoppen er helemaal op? Screenshot.
- [ ] "What am I looking for?" = de oude lijst. Typ in het zoekveld bv. "bank": alleen Bank blijft over, onder zijn kopje.
- [ ] "Which city?": links "YOUR CITIES" (je eigen hoofdsteden) en "OTHER TOWNS" (Booty Bay, Gadgetzan, Everlook,
      Valanaar; als Alliance ook Dalaran). Achter de stad waar je Hearthstone staat: het woord Hearthstone.
- [ ] Klik Orgrimmar (Horde) of Stormwind (Alliance): rechts Inn, je class trainer, Bank, Auction House, Mailbox,
      Flight master en de boten/zeppelins, elk met "Show the way". Bovenaan een blauwe regel "The way there: …"
      (bv. Hearthstone + "about N min"), of "You are here." als je in de stad staat.
- [ ] Knop rechtsboven "Route to <stad>" zet de pijl naar de herberg.
- [ ] Sluit en open het overzicht: MH weet nog welke knop en welke stad je koos.
- [ ] Een knop elders (bv. "Find" op de trainerpagina) springt terug naar "What am I looking for?" met het goede ding.
- [ ] Mist er iets in een stad, of staat er iets van ver buiten de stad? Zeg welke stad.

## 🖼️ 20 nov — Forever: nieuw overzicht, stap 1 (tabbladen rechts)

`/reload` is genoeg. Forever, `/mh` of Alt+M.
- [ ] Het overzicht is groter (1100×600) en de tabbladen staan als hoge knoppen RECHTS. Bovenaan, in het midden, staat
      de naam van de open pagina. Screenshot.
- [ ] Now en Class zien er van binnen hetzelfde uit als eerst (kaarten even breed, niets afgekapt).
- [ ] Class: onder "Class" staan How you play / Class quests / Camping als kleine tabjes. Characters: zijn 4 tabjes.
- [ ] Tandwiel: Quiet helpers / Tools / Commands staan onderaan de kolom.
- [ ] Shift+scroll maakt het groter/kleiner; het venster blijft op je scherm. Slepen werkt. Escape sluit.
- [ ] Knoppen elders die een pagina openen (bv. "Find" bij de trainer, "Show all" in Find) komen op de goede pagina.
- [ ] Quiet helpers → "New layout: tabs on the right" uit → chat zegt "/reload" → na /reload het oude overzicht
      (tabbladen bovenaan). Weer aan + /reload = nieuw.
- [ ] Loop alle pagina's even langs: is er tekst afgekapt of ligt iets over de tabkolom? Screenshot van wat niet klopt.

## 🧙 20 nov — Forever: Hearthstone en teleports in de route, met tijd

`/reload` is genoeg (geen nieuw bestand).
- [ ] Zet een pijl naar iets ver weg (bv. een trainer in een andere hoofdstad, via Find). Is je Hearthstone klaar en
      ligt je herberg dichtbij het doel? Dan staat in de CHAT één keer "Way to <doel>: first use your Hearthstone (about
      N min)." — ook met TomTom aan. (Zonder TomTom zegt ook het label van onze pijl het.) Screenshot.
- [ ] Mage/shaman/druid met een teleport (en een Rune of Teleportation voor de mage): het label zegt "cast Teleport: …"
      als dat sneller is. De spellnaam staat in jouw taal.
- [ ] Na de teleport wijst de pijl vanaf waar je geland bent verder.
- [ ] In Find / Dungeons / Weapons staat achter de route "(about N min)". Die tijd is een ruwe schatting.
- [ ] Een korte wandeling krijgt GEEN teleport-advies.
- [ ] Twijfel? Typ `/mh travel` (met een pijl aan): per teleport waarom wel/niet (spell niet bekend, cooldown, geen
      rune, bindplek onbekend), en per stap de tijd. Screenshot.
- [ ] Eerste keer: gebruik je Hearthstone één keer. Daarna weet MH waar je bindplek ligt (`/mh travel`: "landed here
      before").

## 😴 20 nov — Forever: rested XP, uitloggen op de goede plek

⚠️ **Nieuw bestand: sluit WoW helemaal af en start opnieuw.** Met een character dat nog geen max level is.
- [ ] Ga ergens buiten een herberg of stad staan en log uit (Esc → Log Out). Tijdens de 20 seconden komt een klein
      venster "Rested XP": je bent niet in een inn of stad, de dichtstbijzijnde plek om uit te rusten, en de knop
      **Show the way**. Screenshot.
- [ ] Is je Hearthstone klaar? Dan staat er ook: "Your Hearthstone is ready: use it to go to <je herberg> …".
- [ ] **Show the way**: de pijl wijst naar die plek. Annuleer het uitloggen: het venster gaat weg.
- [ ] In een herberg of hoofdstad uitloggen: GEEN venster (je logt meteen uit).
- [ ] Overzicht → muis op de XP-balk: onderaan staat "You are resting here …" of "Not resting here. Nearest place …".
- [ ] Ben je in een dorpsherberg geweest (bv. Goldshire, Razor Hill)? Dan kent MH die daarna ook.
- [ ] Quiet helpers → "Rested XP tip when you log out" uit → geen venster meer.
- [ ] Twijfel? Typ `/mh rest`: rust je nu, rested XP, Hearthstone, de 3 dichtstbijzijnde plekken en "last decision".
      Screenshot.

## 🧹 20 nov — Forever: geen "Dock to window" meer

`/reload` is genoeg.
- [ ] Forever: open een paar MH-vensters (class-quest-venster, "New in this version", de richting-vraag, trainer,
      dungeons, macro's, How you play). Nergens staat nog "Dock to window" rechtsboven.
- [ ] De titels staan netjes: links of in het midden, vóór het kruisje, zonder over iets heen te lopen.
- [ ] Midnight: daar staat "Dock to window" er nog wel (bv. in de bazengids of Keys). Klikken werkt als vroeger.

## 🚢 20 nov — Pijl bij een zeppelin, boot of tram

`/reload` is genoeg. Forever (Carola's geval) en Midnight.
- [ ] Forever: zet een route over het water (bv. een trainer of class-quest aan de overkant) en loop naar de
      zeppelintoren of de boot. Staat je pijl erop, dan zegt hij: "You are at the zeppelin to … Wait here and get on
      when it arrives; the arrow carries on where you get off." Niet meer "go through". Screenshot.
- [ ] Forever: bij het roze portaal in Rut'theran zegt hij nog wel "go through" (dat klopt daar).
- [ ] Midnight: een route met een zeppelin of de Deeprun Tram (bv. naar een oude dungeon): op de stap zegt hij
      "Take the zeppelin to … Wait here and get on when it arrives …". Bij een portaal: "Take the portal to … The arrow
      carries on where you come out."

## ⛏️ 20 nov — Forever: erts en kruiden, twee schakelaars

`/reload` is genoeg. Een karakter met Mining of Herbalism, waarop **Lueur UIT staat**.
- [ ] Overzicht → tandwiel → Quiet helpers: twee nieuwe regels, "Ore and herbs: the game's icon above the nearest one"
      en "Ore and herbs glow (drawn by MH)". Beide staan uit.
- [ ] Zet de eerste aan. Loop naar een ertsader of kruid: komt er een houweel of kruidje boven? Screenshot.
- [ ] Zet de tweede aan. Gloeit de ader (goud) of het kruid (groen)? Staat de gloed OP de ader, of zweeft hij erboven of
      ernaast? Screenshot. (De plek is een gok van mij; jouw screenshot beslist.)
- [ ] Loop een stukje weg: wordt de gloed grijs? Te ver weg: verdwijnt hij?
- [ ] Zet allebei uit: in de chat "ore and herbs: off. Your old settings are back." Het icoon is weg.
- [ ] Twijfel? Typ `/mh sparkle`: onderaan per instelling de waarde nu, die van MH en die van vroeger, plus wat MH ziet.
- [ ] Op een karakter MET Lueur: zet een schakelaar aan. Dan zegt MH dat Lueur dit al doet, en verandert hij niets.

## ⛏️ 20 nov — Forever: meting voor kruiden en erts (`/mh sparkle nodes`)

✅ Gedaan door Rob (20 nov, "Ima", Copper Vein): houweel boven de ader. Uitslag gelezen; zie NEXT_SESSION.

`/reload` is genoeg. Neem een karakter waarop **Lueur UIT staat** (bv. Midnight-Helper of Ima-Pallie), met Mining of
Herbalism.
- [ ] Ga op een paar meter van een ertsader of kruid staan (binnen ongeveer 10 meter), niet in een gevecht.
- [ ] Typ `/mh sparkle nodes`. In de chat: "node probe: soft-target values set …".
- [ ] Kijk 30 seconden naar de ader of het kruid: verschijnt er een icoontje (houweel of kruidje) boven? Ja of nee.
      Loop er gerust even omheen. Screenshot als er iets verschijnt.
- [ ] Na 30 seconden in de chat: "… 6 setting(s) put back". Alles staat dan weer zoals het was.
- [ ] Doe daarna `/reload`. De uitslag staat dan in de SavedVariables; de bouwchat leest hem.

## ✨ 20 nov — Forever: questitems glinsteren in plaats van een rand

⚠️ **Nieuw bestand: sluit WoW helemaal af en start opnieuw** (`/reload` is niet genoeg).
- [ ] Zet het aan: Overzicht → tandwiel → Quiet helpers → "Quest items sparkle instead of an outline" (of `/mh sparkle
      on`). In de chat: "quest items sparkle: on … (N setting(s) changed)".
- [ ] Loop naar een questitem dat je kunt looten: het glinstert, zonder rand. Screenshot. (Rob, 20 nov: eerst *"we
      hebben sparkles"*, daarna *"o wacht sparkle stond nog uit ?!?"* — die glinstering kwam NIET van MH, waarschijnlijk
      van de addon Lueur. Opnieuw testen met MH-sparkle AAN.)
- [ ] Ook kruiden en erts? Die doet MH (nog) NIET. Zeg wel wat je ziet.
- [ ] Kies in de grafische instellingen een andere preset: na ongeveer een seconde is de rand weer weg.
- [ ] Zet het uit: in de chat "your old settings are back". Komt de rand terug? Zo niet: WoW herstarten, en dan wel?
- [ ] Twijfel? Typ `/mh sparkle`: per instelling de waarde nu, die van MH en die van vroeger, plus "last decision".
      Screenshot.

## 🙏 19 nov — vreemden bedanken voor een buff (Forever + Midnight)

⚠️ **Nieuw bestand: sluit WoW helemaal af en start opnieuw** (`/reload` is niet genoeg).
- [x] Zet het aan: Forever → Overzicht → tandwiel → Quiet helpers → "Thank strangers for a buff". (Midnight: in de
      instellingen van MH, onder Screen.) Of typ `/mh thanks on`. (Rob, 20 nov)
- [ ] Staat Thanks for the Buff aan? Dan doet MH niets (anders bedank je dubbel). Zet TFTB voor deze test even uit.
- [x] **Meting 1:** target een vriendelijke speler en typ `/mh thanks test`. In de chat staat "You thank <naam>." Screenshot.
      (Rob, 20 nov: *"thaanks test werkt ook"*)
- [x] (Rob, 20 nov: *"dit was een echte speler 🙂"* / *"en ja ik kreeg de buff van een echte speler zelf"*) **Meting 2:** laat je door een vreemde buffen (buiten je groep, buiten een gevecht, buiten een dungeon). Er komt
      "You thank <naam>." Typ daarna `/mh thanks`: de regel "last decision" zegt wat MH zag. Screenshot.
- [ ] Dezelfde speler buft je nog eens binnen 5 minuten: geen tweede bedankje. Na 5 minuten wel weer (sinds 20 nov;
      was 1 uur). `/mh thanks` zegt dan "already thanked <naam> N min ago".
- [ ] Kwam er niets? Ook dan `/mh thanks` + screenshot: de reden staat erin.

## 🔀 19 nov — Forever: toetsenblok-vraag en "You just learned" na elkaar

`/reload` is genoeg. Bij de trainer, met een nieuwe spell die op je toetsenblok hoort én een nieuwe rank.
- [x] Eerst komt alleen "New for your key block" (Place it / Later). Pas als je die wegklikt, komt (binnen een seconde)
      het lijstje "You just learned". (Rob, 20 nov)
- [x] Nooit allebei tegelijk op je scherm. (Rob, 20 nov)
- [ ] Twijfel? Typ `/mh ranks`: de regel "just-learned list" zegt waarom het lijstje wacht of kwam.

## 📣 19 nov — Midnight: "MH werkt ook in WoW Forever" één keer bij de login

`/reload` is genoeg. Retail (Midnight).
- [x] This Week: de kop zegt nu "New: Midnight Helper now works in WoW Forever too" (geen "5.0" meer). (Rob, 20 nov)
- [x] Heb je die melding nog NIET weggeklikt? Na `/reload` (of bij de volgende login) komt het venster "New in this
      version" met een kaartje over WoW Forever, en de knop "Got it, hide this". Klik → het kaartje en de melding in This
      Week zijn weg, ook na een volgende login. (Rob, 20 nov)
- [ ] Had je hem al weggeklikt in This Week? Dan komt het kaartje niet.
- [ ] Snel opnieuw zien: `/mh new` toont alle kaartjes die gelden.

## 🪟 19 nov — Forever: klein venster met je class-quest-stap

`/reload` is genoeg. Met je mage, midden in de class quest.
- [x] Er staat een klein venster (links op je scherm) met de naam van de quest en alleen de stap waar je bent, in
      grotere letters. Dezelfde zin als in **Do this now**. (Rob, 20 nov)
- [x] Sleep het waar je wilt. Na `/reload` staat het nog daar. Shift+scroll maakt het groter of kleiner. (Rob, 20 nov)
- [x] **Show the way** zet de pijl naar de plek van de stap. (Rob, 20 nov)
- [x] Doe de stap (bv. de Ju-Ju Heaps): het venster gaat vanzelf naar de volgende stap. (Rob, 20 nov)
- [x] Kruisje: weg tot de volgende stap. Escape: weg tot de volgende quest-update (dan komt het terug). (Rob, 20 nov)
- [x] Quiet helpers → "Small window with your class quest step" uit → het venster is weg. (Rob, 20 nov)
- [ ] Komt er niets? Typ `/mh classquest` en maak een screenshot: de laatste regel zegt waarom.
- [ ] **(20 nov, gerepareerd)** Een lange titel (bv. "Study (scrolls from the library, once an hour)") loopt NIET meer
      onder "Dock to window": hij stopt ervoor en gaat zo nodig naar een tweede regel. De tekst eronder schuift mee
      omlaag en het venster wordt hoger; niets valt over elkaar. Screenshot. (`/reload` is genoeg.)

## 🧳 19 nov — Midnight: tooltip op de reisknop

`/reload` is genoeg. Retail (Midnight).
- [ ] Zet een route waarbij MH de knop "gebruik je Hearthstone / toy / teleport" laat zien (bv. een route naar een
      hoofdstad met de mount-run of de reisplanner). Muis op het icoontje → de tooltip van het spel (van de Hearthstone,
      de toy of de mage-teleport). Klikken werkt nog net als eerst.

## 🧭 19 nov — Forever: de pijl slaat trainers over die jou niets kunnen leren

`/reload` is genoeg. Met je Troll mage (level 10), in Durotar.
- [x] Overzicht → de trainer-knop ("breng me naar de trainer"). De pijl wijst nu NIET naar Mai'ah in Valley of Trials,
      maar naar Un'Thuwa (Sen'jin Village) of Orgrimmar. (Rob, 19 nov)
- [ ] Loop toch even naar Mai'ah en praat met haar. In de chat staat: "Mai'ah only teaches spells up to level 6; yours
      need level 10. Go to …".
- [x] Bij de goede trainer: Frost Nova, Conjure Water (rank 2) en Frost Armor (rank 2) staan erbij. (Rob, 19 nov; het
      rank-lijstje toonde Conjure Water en Frost Armor 1 -> 2)
- [ ] Typ `/mh trainer check`, maak een screenshot: de regel "short lists" zegt wat MH bij de trainer las.

## 🧾 19 nov — "Used for" noemt nu het recept (Forever + Midnight)

`/reload` is genoeg.
- [x] Ga met je muis op **Linen Cloth** staan (tas of verkoper). Onder "MH: Used for …" staat een grijze regel:
      "Recipes: Bolt of Linen Cloth, SAF-T Dynamite (+10 more)". (Rob, 19 nov: de Recipes-regel)
- [ ] Een **Scroll of Protection** zegt: "Recipes: Tenets of the Silver Hand".
- [x] Mage: Overzicht → **Professions**. Onderaan de lijst staat nu **Comprehension**. Klik erop: het kaartje komt.
      (Rob, 19 nov)
- [ ] Geen recept-regel? Typ `/mh usedfor` en maak een screenshot.

## 🙏 19 nov — Forever (paladin): slimme zegen-knop

`/reload` is genoeg. Met je paladin, buiten een gevecht.
- [ ] Overzicht → tandwiel → Quiet helpers → "Button: smart blessing on the player under your mouse" aan. In de chat:
      "smart blessing ON …" en het macrovenster gaat open. Sleep de macro **MH Smart Bless** naar een balk.
- [ ] Ga met je muis over een vriendelijke speler (bv. een warrior) en druk op die macro: hij krijgt de zegen die de
      tooltip-tip noemt (warrior = Might, mage = Wisdom, enz.).
- [ ] Werkt de knop niet? Typ `/mh blesstip` en maak een screenshot: de regel "smart button" zegt wat erop staat.
- [ ] Uit in Quiet helpers → de macro doet niets meer.

## 📜 19 nov — Forever (mage): Comprehension uitgelegd + regel in "Do this now"

`/reload` is genoeg. Met je mage.
- [x] (Rob, 19 nov) Overzicht → **Professions**: onderaan de lijst staat "Comprehension". Klik → het kaartje legt uit wat het is,
      of je de spell kent, waar hij in je spellboek staat, de drempels 1/15/50/175 en Study.
- [ ] Draag je een onvertaalde scroll (bv. "Scroll: KWYJIBO")? Dan staat er in **Do this now**: "You carry 1
      untranslated scroll(s): use Comprehend Scroll on it (General tab of your spellbook)." Muis op de spellnaam →
      tooltip.
- [ ] Klopt de tabnaam ("General") met jouw spellboek?

## 🌀 19 nov — Forever: Windshaper-shaman en The Tempest's Weapons

- [ ] Een Windshaper (Skyborne, Horde) shaman op level 30 met Call of Air gedaan: "Your class" / "Do this now" noemt
      nu The Tempest's Weapons. Kan hij een stap NIET aannemen in het spel? Zeg welke — dan haal ik Skyborne weer weg.

## ⏳ 19 nov — Forever: buff-melding "runs out soon"

`/reload` is genoeg. Buiten een gevecht.
- [x] Wacht tot een eigen buff (bv. Arcane Intellect of Frost Armor) minder dan 5 minuten over heeft: het buff-icoontje
      verschijnt met "Arcane Intellect (4 min left) runs out soon." Klik → hij wordt ververst en het icoontje gaat weg.
      (Rob, 19 nov, screenshot: *"En dit werkt ook. Juppie."* Het "( 1 min" op de screenshot is geen spatie in de tekst —
      GEMETEN in de code — maar AFGELEID de ruimte die het lettertype links van een "1" laat.)
- [ ] In een gevecht komt die melding NIET (de tijd is daar niet leesbaar).
- [ ] Het venster "Do this now" springt er NIET voor open.
- [ ] `/mh buffs` zegt per buff hoeveel seconden hij nog heeft.

## 🔴 19 nov — METING (5 minuten): hoe lang je buffs nog duren + of MH een seal ziet

✅ Mage gedaan (Rob, 19 nov, 2 screenshots): buiten een gevecht alles leesbaar, in een gevecht niets. Nog open: de
paladin met seal en een wapen met poison/olie/steen.
Voor twee ideeën met jouw ja: "buff bijna afgelopen, met de tijd erbij" en "vlak voor een gevecht: je mist iets (bv.
geen seal)". Eerst meten, dan bouwen. `/reload` is genoeg.
- [ ] **Paladin** met een seal op (bv. Seal of Righteousness), buiten een gevecht: typ `/mh buffs time`, screenshot.
- [ ] Dezelfde paladin **in een gevecht** (seal op): typ nog eens `/mh buffs time`, screenshot.
- [ ] Een character met een **poison, olie of steen** op het wapen (of een shaman met een weapon-imbue): `/mh buffs time`,
      screenshot. (Geen bij de hand? Sla over en zeg het.)
De regels zeggen per buff: naam, id, duur, wanneer hij afloopt en hoeveel seconden nog ("SECRET" = onleesbaar).

## 🧩 19 nov — Forever: macro's met een chip, Copy-knop en melding

`/reload` is genoeg. Overzicht → Keys & macros.
- [ ] Naast elke macro staat een chip: **Made** (gemaakt), **Ready** (kan nu), **Level N** of **Trainer** (nog niet).
- [ ] **Copy** (onder Make/Update): een vakje met de macrotekst; Ctrl+C kopieert hem. Niets overlapt in de rij.
- [ ] Na de trainer, als er een macro bij komt die je nog niet hebt: één chatregel "a new macro you can make now: …".

## 🔧 19 nov — Forever: "Simple order" zegt welke spells je nog niet hebt

`/reload` is genoeg. Your class → How you play (of het venster).
- [ ] Mage onder level 10: onder "Simple order" staat grijs "Not learned yet: Frost Nova (level 10)."
- [ ] Op level 10, na de trainer: die regel is weg.
- [ ] Een andere class (bv. paladin of druid op een laag level): de grijze regel noemt alleen spells die je echt nog
      niet hebt, met het juiste level. Klopt een level niet? Zeg welke spell.

## 🧭 19 nov — Forever: tooltip zegt of een wapen bij je richting past

`/reload` is genoeg. Je moet een richting gekozen hebben (`/mh direction`).
- [ ] Muis op een wapen dat je richting gebruikt (bv. een tweehander bij Arms): lichtgroene regel "MH: Fits your
      direction (…)".
- [ ] Muis op een wapen dat je richting niet gebruikt: oranje regel "MH: Your direction (…) does not use this kind of
      weapon (player guides)."
- [ ] Bij een questbeloning waar MH "neem deze" zegt en het is een wapen: dezelfde zin staat erachter.
- [ ] Een wand, een vishengel of een niet-wapen: géén richting-regel.

## 📋 19 nov — Forever: lijstje "You just learned" na de trainer + meting "met de hand neergezet"

`/reload` is genoeg. Bij je class trainer, met een spell die je al op een balk hebt (zodat je een nieuwe rank leert),
en liefst ook een helemaal nieuwe spell.
- [x] Na het trainen komt een klein lijstje "You just learned". Een nieuwe rank: "Frostbolt: rank 2 -> 3 (2 buttons)"
      met **Upgrade / Not now / Never**. (Rob, 19 nov, screenshot: Conjure Water en Frost Armor rank 1 -> 2) Een nieuwe spell: "…: new, not on a bar yet" met **On my bar / Not now / Never**.
- [ ] **Upgrade** zet die knoppen op de nieuwe rank. **On my bar** zet de spell op een vrije knop van je balken.
      **Never** laat die knoppen voortaan met rust (zie ook /mh ranks choose). **Not now** haalt de regel weg.
- [ ] Muis op een naam → de spell-tooltip. Passen de knoppen om hun tekst (ook in een andere taal)?
- [ ] In een gevecht is het lijstje weg; na het gevecht komt het terug. `/mh ranks list` opent het opnieuw.
- [ ] Quiet helpers → "Ask after the trainer: which spells go on your bars" uit → geen lijstje meer.
- [ ] **Meting (2 minuten)**: typ `/mh ranks watch`. Sleep dan een spell uit je spellbook op een knop — ook een
      LAGERE rank (in het spellbook staan de oude ranks ook). Laat MH ook één knop upgraden (Upgrade in het lijstje of
      bij de trainer). Maak een screenshot van de chatregels "MH ranks watch". Daarmee bouw ik "een knop die je zelf met de
      hand neerzet, wordt niet vanzelf omhoog gezet".

## 💰 19 nov — Forever: rijen class quests, blauwe namen, je goud in "Do this now"

`/reload` is genoeg.
- [ ] Your class → **Class quests**: een rij met een lange stap (bv. "Study (scrolls from the library, once an h…)") en
      een plaatsregel eronder: niets valt meer over de volgende rij heen. Elke rij is zo hoog als zijn tekst.
- [x] Namen met een tooltip zijn **lichtblauw** (de kleur van een spell-link in het spel): in "Do this now", bij
      "Coming up", op de trainer-pagina (spells van later blijven grijs) en bij class quests met een spell-beloning.
      (Rob, 19 nov)
- [x] **Do this now**: rechtsonder staat je goud (goud, zilver, koper met muntjes). Koop of loot iets: het getal
      verandert meteen. De knoppen staan erboven, niets overlapt. (Rob, 19 nov)

## 📍 19 nov — Forever: Find → Rares begint bij het gebied waar je bent

`/reload` is genoeg.
- [x] Overzicht → Find → Rares: bovenaan staat het gebied waar je nu bent, met "(you are here)" erachter. Daaronder
      "Worth the trip", dan de rest. In het gebied staat de dichtstbijzijnde rare eerst. (Rob, 19 nov)
- [ ] Ga naar een ander gebied (met het overzicht open of daarna opnieuw open): het nieuwe gebied staat bovenaan.
- [ ] In een stad of grot: ook dan staat het gebied eromheen bovenaan.

## 🧸 19 nov — Forever bazengids: 3D-model bij de muis op een baasnaam

`/reload` is genoeg. Open de bazengids (bv. Deadmines).
- [x] Zet de muis op een baasnaam (bv. "Captain Greenskin"): rechts naast de gids komt een klein kader met de baas,
      draaiend, en zijn naam eronder. Muis weg → kader weg. (Rob, 19 nov, screenshots: Sneed en Captain Greenskin.)
- [ ] Komt er bij een baas niets, of een leeg kader? Zeg welke baas (dan kent de client dat model nog niet; bekend risico).
- [ ] De tekst van de gids ziet er verder hetzelfde uit als eerst (regels, kleuren, afstand).

## 🃏 19 nov — Forever: klein baaskaartje als je een baas target

`/reload` is genoeg. In een dungeon, met de grote bazengids DICHT.
- [ ] Target een baas (bv. Captain Greenskin in Deadmines): er komt een klein kaartje met zijn naam, wat hij doet en de
      tip. Target iets anders (geen baas): het kaartje gaat weg.
- [ ] De knop op het kaartje opent de grote bazengids op die dungeon.
- [ ] Verslepen kan; Shift+scroll maakt het groter/kleiner; Escape sluit het.
- [ ] Overzicht → tandwiel → Quiet helpers: "Small boss card when you target a boss" uit → geen kaartje meer.
- [ ] Komt er niets? Typ `/mh bosses check` en maak een screenshot: de laatste regel zegt waarom.

## 🗺️ 19 nov — Forever bazengids: lange namen in de lijst

`/reload` is genoeg.
- [x] De lijst links: "Excavation Site: Wetlands" (en elke andere lange naam) past nu in zijn knop: kleinere letter,
      zo nodig op twee regels. Ook als je hem kiest (de knop wordt dan grijs). (Rob, 19 nov, na 2b17133: *"Ja, het past
      er nu netjes in. Dat ziet er goed uit."*)
      ❌ Rob, 19 nov: de eerste poging (2cc98f6) werkte NIET ("staat nog steeds buiten zijn grenzen"). Tweede poging:
      opnieuw testen. Past hij nog steeds niet? Open de gids, typ `/mh bosses check` en maak een screenshot: de
      "list:"-regels zeggen hoe breed MH de naam mat en welke lettergrootte hij koos.
- [ ] Wissel een paar keer van dungeon (ook naar een met veel loot, zoals Deadmines): lange loot-regels lopen netjes op
      twee regels en niets ligt over elkaar.

## 🎚️ 19 nov — Forever: het rank-keuzevenster is makkelijker te vinden

`/reload` is genoeg.
- [x] Overzicht → tandwiel → **Quiet helpers**: onder "Edge on buttons with an old rank" staat "Choose which spells get
      a new rank" met een knop **Open**. Klik → het venster om te kiezen welke knoppen en balken een nieuwe rank krijgen.
      (Rob, 19 nov: het venster opent, "no buttons with an old rank" — er was niets oud, dus de inhoud is niet getest.)
- [ ] Overzicht → **Keys & macros**: links staat een vierde knop met dezelfde naam. Klik → hetzelfde venster.
- [ ] Zoekbalk: typ "rank" (of "ranks") → de regel "Choose which spells get a new rank" staat erbij; klik → het venster.
- [ ] Shift-klik op de knop bij de trainer en `/mh ranks choose` werken nog zoals altijd.

## 🖱️ 19 nov — Forever: tooltips op de Now-kaart, bij class quests, verkopers en wapens

`/reload` is genoeg. Alles in het overzicht, tenzij anders gezegd.
- [ ] **Now-kaart**: staat er "new spell(s) on no bar"? Onder die regel staan kleine spell-icoontjes. Muis erop →
      de gewone spell-tooltip.
- [x] **Your class → Class quests**: muis op de naam van een keten → de spell-tooltip van de beloning. (Rob, 19 nov:
      Study, met reagents.) De rest van dit punt (stap-regel → quest-tooltip) nog niet gemeld: Muis op de regel
      eronder (de stap) → de quest-tooltip van het spel, of onze eigen tekst als het spel er geen geeft. Zeg welke van
      de twee je ziet.
- [ ] **Find**: muis op een gereedschap (Mining Pick, Skinning Knife …) → de item-tooltip. Muis op een wapen →
      de tooltip van die wapenvaardigheid (met "+" ervoor: ook de regel over je richting eronder).
- [ ] Het losse wapenvenster (`/mh weapons`) en het losse verkopersvenster: dezelfde tooltips op de knoppen links.

## 🖱️ 19 nov — Forever: tooltips in "Do this now" en op de trainer-pagina

`/reload` is genoeg.
- [x] Het kleine venster **Do this now**: muis op een spellnaam (bij "coming up", "new spell on no bar" of de
      talentregel) → de gewone spell-tooltip van het spel. Shift-klik → de spell staat in je chat. (Rob, 19 nov,
      screenshot: Frost Armor; *"dat ging helemaal goed"*. Shift-klik niet apart gezien.)
- [ ] Het overzicht, pagina **Now**, kaart "Coming up": muis op de NAAM (niet alleen het icoontje) → spell-tooltip.
- [ ] Het overzicht, pagina **Trainer**: muis op een spellnaam → eerst de spell-tooltip van het spel, daaronder in
      blauw welke toets of waar je hem hebt. Muis op een kopje → géén spell-tooltip.
      (Rob, 19 nov: spell-tooltip kwam, de blauwe regel NIET. Nu heeft ook het icoontje die regel. Zie je hem nog steeds
      niet, zeg dan of je op het icoontje of op de naam stond.)

## 🖱️ 19 nov — Forever: tooltip op de loot in de bazengids

`/reload` is genoeg. Open de bazengids van een dungeon (bv. Deadmines) en scroll naar de loot onderaan.
- [x] Muis op een item: de gewone tooltip van het spel verschijnt (zoals in je tas), en de regel licht een beetje op.
      (Rob, 19 nov, screenshot Deadmines: Cruel Barb met de "Equipped"-vergelijking.)
- [ ] Shift-klik op een item: de link staat in je chat. Ctrl-klik: de paskamer opent.
- [ ] De grijze regel onderaan (de opmerking over de loot) licht NIET op en heeft geen tooltip.
- [ ] Wissel een paar keer van dungeon: de loot-rijen staan steeds netjes onder de tekst, niet erdoorheen.

## 🔴 EERST, thuis (2 minuten): meting voor "Beter dan wat je draagt" (optie B)

Rob via sparring: *"Ja"* (optie A nu, B later in stappen; deze meting beslist hoe B gebouwd wordt). Forever, in de stad.
⚠️ **De shift-klik-vorm werkt NIET** (Rob, 19 nov, twee keer: zonder aanhalingstekens "unexpected symbol near '|'",
mét aanhalingstekens viel het laatste teken weg: "unfinished string"). **Werkende vorm** (Rob, 19 nov): trek het item
AAN en typ, met het nummer van het vak:
`/dump C_Item.GetItemStats(GetInventoryItemLink("player",16))`
Vakken: 1 hoofd, 2 nek, 3 schouders, 5 borst, 6 riem, 7 benen, 8 voeten, 9 polsen, 10 handen, 11-12 ringen,
13-14 trinkets, 15 cape, 16 hoofdhand, 17 off-hand, 18 afstandswapen. Een leeg vak geeft "bad argument #1" (geen MH-fout).
- [ ] (a) een item met alleen gewone stats (Strength/Agility/Stamina…). (Handschoenen, vak 10, gaven alleen armor:
      `{ RESISTANCE0_NAME = 4 }` — dat telt nog niet als (a).)
- [ ] (b) een caster-item met een groene "Equip: Increases damage and healing…"-regel.
- [x] (c) een wapen — Rob, 19 nov, vak 16: `{ ITEM_MOD_DAMAGE_PER_SECOND_SHORT = 2.58… }`. GetItemStats vult DPS in
      Forever (dat was een open punt van optie A).
- [ ] (d) een groen item met "of the …" in de naam (bv. "… of the Bear").
Geen item van een soort bij de hand? Sla die over en zeg welke.

## 🗡️ 18 nov (nacht) — Forever: wapenquests per class

`/reload` is genoeg. Ze verschijnen in *Do this now* en bij *Your class* zodra je het level hebt (en de vorige quest).
- [ ] **Warrior level 10** (na je Defensive Stance-quest): "Your first warrior weapon" met de route van jouw startgebied
      (Human: Marshal Haggard; Dwarf/Gnome: Tormus Deepforge; Night Elf: Elanaria/Mathiel; Orc/Troll/Tauren: Thun'grim;
      Undead: Coleman Farthing, de wapenrekken in de crypte van Agamand Mills).
- [ ] **Warlock 20**: Orb/Staff of Soran'ruk (Doan Karhan, Barrens; BFD + SFK). **35**: Orb/Staff of Orahil (Menara
      Voidrender; kies één van de twee shard-quests). **50**: An Imp's Request (neem 1 Felcloth mee).
- [ ] **Shaman 30** (na Call of Air): The Tempest's Weapons. ⚠️ **Horde**: klopt bij elke stap "hand in to …"? De bronnen
      zijn het oneens over Rau Cliffrunner / Prate Cloudseer / Bath'rah. Zeg welke npc het écht was.
- [ ] Klopt een stap niet (verkeerde npc, plek of aantal)? Zeg welke quest.

## ⚔️ 18 nov (nacht) — Forever: "beter dan wat je draagt" bij wapens (optie A) + de Cozy Sleeping Bag

`/reload` is genoeg.
- [ ] Draag je een **tweehander**: een eenhandig wapen met minder stats krijgt GEEN groene regel "MH: … over what you
      wear" meer (vroeger wel). Een schild of off-hand-ding ook niet.
- [ ] Een wapen met dezelfde stats maar meer schade: de groene regel zegt "+x.x damage per second".
- [ ] Een class zonder twee wapens (paladin, priest, mage, warlock, druid) met 1H + schild: een eenhandig wapen wordt nu
      alleen met je hoofdhand vergeleken.
- [ ] Bij een questbeloning en bij "Upgrade in your bags": hetzelfde oordeel.
- [ ] **Slaapzak**: leg je Cozy Sleeping Bag neer en ga erbij staan. *Do this now* zegt "lie down in it … you have 0 of
      3". Op een mount: "get off first". `/mh camp` toont of MH de aura's kan lezen (`bagRest` 1331671, `wellRested`
      429959) — maak een screenshot als hij "unreadable" zegt.

## 🗺️ 18 nov (laat) — Forever: bazengids, stap 2b (alle dungeons tot 60) + namen van het naamplaatje

Geen nieuw bestand: `/reload` is genoeg.
- [ ] `/mh bosses`: de lijst heeft nu **28 dungeons** (tot Stratholme). Scroll naar onderen: alles bereikbaar.
- [ ] Ook bij Sunken Temple, Blackrock Depths, de drie Dire Maul-rijen, Lower/Upper Blackrock Spire, Scholomance, de twee
      Stratholme-rijen, Blackmaw Hold en The Shaper's Terrace een knop **Bosses**.
- [ ] **Dire Maul**: kopjes "— East —", "— North —", "— West —". **Blackrock Spire**: "— Lower —", "— Upper —".
      **Stratholme**: "— Main Gate —", "— Service Gate —".
- [ ] Blackmaw Hold en Shaper's Terrace: bovenaan "New in WoW Forever … check these lines again later".
- [ ] Scholomance, eerste baas: de regel over de **Skeleton Key** (hoe je binnenkomt).
- [ ] Dire Maul North: bij Guard Mol'dar en King Gordok staat wat je doet voor een **tribute run** (Mizzle).
- [ ] Kloppen de tips? Een regel die niet klopt: zeg welke (dungeon + baas).
- [ ] **Meetpunten**: Sunken Temple `/mh bosses check` bij een baas (welke encounter-set vuurt); Stratholme: moet de
      deur van de Scarlet Bastion open met The Scarlet Key / lockpicking?; Dire Maul: King Gordok en Cho'Rush, welk id.
- [ ] **Namen (alleen te zien met een Duitse, Franse, Spaanse of Russische client)**: de bazennaam in de gids is nu de naam boven het
      hoofd van de baas. Klopt dat? (bv. Duits: Deadmines "Captain Greenskin", SM "Hochinquisitor Fairbanks").

## 🗺️ 18 nov (avond) — Forever: bazengids, stap 2a (11 dungeons ~28-55)

Geen nieuw bestand: `/reload` is genoeg (doe eerst de herstart van stap 1 hieronder, als je die nog niet deed).
- [ ] `/mh bosses`: de lijst links heeft nu 20 dungeons en **scrollt** (muiswiel). Het venster is iets breder.
      Klik een dungeon onderaan (bv. Alcaz Prison): rechts komt die gids.
- [ ] Overzicht → Dungeons & group: ook bij Gnomeregan, Razorfen Kraul, de vier Scarlet Monastery-rijen, Razorfen
      Downs, Uldaman, Zul'Farrak, Maraudon, City of Dalaran, The Drowned City, Krol'dok en Alcaz een knop **Bosses**.
      Klik bij een dungeon laag in de lijst: het venster opent op die dungeon en de lijst links scrolt mee.
- [ ] **Scarlet Monastery**: één pagina met tussenkopjes "— Graveyard —", "— Library —", "— Armory —", "— Cathedral —";
      bovenaan level **30-46**. Onderaan bij de items staat de vleugel ervoor ("Library: …").
- [ ] **Maraudon**: kopjes "— Orange side —", "— Purple side —", "— Poison Falls —", "— Earth Song Falls —".
- [ ] De 4 nieuwe dungeons (Dalaran, Drowned City, Krol'dok, Alcaz): bovenaan "New in WoW Forever … check these lines
      again later".
- [ ] Uldaman (Horde): target Baelog, Eric of Olaf → alle drie markeren "The Lost Dwarves" als "(your target)".
- [ ] Kloppen de tips met wat je ziet? Een regel die niet klopt: zeg welke (dungeon + baas).
- [ ] **Meetpunten** (als je er toch bent):
      - SM Cathedral: opent een fakkel in het kleine zijkamertje de verborgen kamer van Fairbanks?
      - Maraudon: staat Tinkerer Gizlock bij Earth Song Falls of aan de paarse kant? En Celebras?
      - Uldaman Archaedas: hoeveel spelers moeten de altaren aanklikken?
      - Razorfen Downs: is Ragglesnout er elke keer, of maar soms (rare)?
      - Alcaz: Katerina — veel vuur op de hele groep, of niet?
      - `/mh bosses check` bij Mograine (SM): welk target npc ziet MH?

## 🗺️ 18 nov (nacht) — Forever: bazengids, stap 1 (9 dungeons tot ~32)

⚠️ **Twee nieuwe bestanden: WoW helemaal herstarten.**
- [ ] Overzicht → Dungeons & group: bij Ragefire Chasm, Hall of Thanes, Ruins of Lordaeron, Wailing Caverns, Deadmines,
      Shadowfang Keep, Stockade, Blackfathom Deeps en Excavation Site een knop **Bosses** (onder Way). Klik: een venster
      met links de 9 dungeons, rechts per baas wat hij doet + een tip, onderaan 2-3 items "Worth knowing".
- [ ] In een van die dungeons: `/mh bosses` opent meteen op die dungeon. Target een baas: hij krijgt "> … (your target)".
- [ ] Bij de 3 nieuwe dungeons staat bovenaan "New in WoW Forever … check these lines again later".
- [ ] Kloppen de tips met wat je ziet? Een regel die niet klopt: zeg welke (dungeon + baas).
- [ ] **Meetpunten** (als je er toch bent):
      - Shadowfang Keep, Baron Silverlaine: zet hij zijn "healing 75% minder"-debuff op één speler of op iedereen dichtbij?
      - Hall of Thanes: heet de vuurbaas in het spel **Magmatus** of **Infurnus**? Ruins of Lordaeron: **The Baron** of
        **The Butcher**? (Speldata en Wowhead zeggen het verschillend.)
      - `/mh bosses check` in Blackfathom Deeps: welk "target npc" en welke map ziet MH?

## 📦 18 nov (nacht) — Forever: knop "doos openen"

⚠️ Openables.lua staat nu ook in de Forever-toc: **WoW helemaal herstarten** (samen met disenchant hierboven).
- [ ] Raap een doos, zakje of schelp op (bv. een Small Barnacled Clam): links in beeld een knop met het icoon. Klik =
      hij gaat open. Meer dan één: een getal op de knop; het pijltje rechtsboven klapt de lijst uit.
- [ ] Een lockbox die nog op slot zit, komt NIET op de knop (eerst Pick Lock of een sleutel).
- [ ] In een gevecht is de knop weg; rechts-slepen verplaatst hem, Shift+scroll maakt hem groter/kleiner.
- [ ] Tandwiel → stille helpers → "Open-box button" uit: de knop is weg. `/mh open` zegt wat MH ziet.
- [ ] (Meting, als je een lockbox op slot hebt) `/mh open` noemt hem bij "locked". Twee dezelfde dozen, één al
      opengepikt: de knop opent de goede (niet "Item is locked").

## 🎚️ 18 nov (nacht) — Forever: zelf kiezen welke knoppen een hogere rank krijgen + Study lager

Geen nieuw bestand (maar de ronde hieronder wel: herstart WoW één keer, dan is alles mee).
- [ ] `/mh ranks choose` (of Shift-klik op de rank-knop onder het trainervenster): een venster met per balk de knoppen die
      een lagere rank hebben ("Action Bar 2: button 3: Healing Wave, rank 2 -> 5"), elk met een vinkje.
- [ ] Vink er één uit en klik "Upgrade checked": alleen de aangevinkte gaan omhoog.
- [ ] "never touch this bar" bij een balk, en "never" bij één knop: die blijven ook bij `/mh ranks fix`, bij "auto" en
      bij de knop onder de trainer met rust, en krijgen geen oranje rand meer. Na /reload nog steeds zo.
- [ ] `/mh ranks`: een regel "never touched: bars … ; buttons …".
- [ ] Mage vanaf level 6: "Study" staat niet meer bovenaan de Now-kaart; het is een tip onderaan. In Class quests en de
      zoekbalk staat hij nog gewoon.

## ✨ 18 nov (nacht) — Forever: disenchanten + inklapbare kopjes in Find

⚠️ **Twee nieuwe bestanden: WoW helemaal afsluiten en opnieuw starten** (/reload is niet genoeg).
- [ ] Overzicht → Find: elk kopje (TRAINER, PROFESSIONS …) heeft een plus/min-knopje. Klik: open/dicht; een dicht kopje
      toont tussen haakjes hoeveel erin zit. Na een /reload staat alles nog zoals je het liet.
- [ ] Zoekbalk: zoek iets uit een dicht kopje (bv. `zep` of de naam van een rare) en klik: dat kopje klapt vanzelf open.
- [ ] Enchanter: muis op een groen wapen of armor → "MH: Disenchantable" (paars). Op een grijs/wit wapen: "MH: Cannot be
      disenchanted (only green, blue and purple items)". Op een drankje: niets.
- [ ] Je tassen (Baganator): linksboven op wat kan een klein Disenchant-icoontje. (Verplaatsen/uitzetten kan in
      Baganator → Customise.) Blizzard-tassen: hetzelfde icoontje.
- [ ] Tandwiel → stille helpers → "Disenchant next button" aan: een knop met het volgende item. Klik = Disenchant op dat
      item. Rechtsklik = overslaan. Alt+slepen = verplaatsen. In een gevecht is hij weg.
- [x] `/mh disenchant`: in chat hoeveel items "yes / not sure / cannot" in je tassen, en "spell 13262 known: true/false"
      (zeg wat er staat: dat is een meting). ✅ Rob 18 nov (screenshot, Ima Magieman, na herstart): "Enchanting learned:
      true; spell 13262 known (spellbook): true" en "Baganator: registered". Tassen leeg (0/0/0), dus tooltip en icoontjes
      nog niet gezien. "skipped: FDE_WHY_KIND" was de ruwe code (geen fout: geen wapen/armor onder de muis); toont nu
      "skipped: only weapons and armor (FDE_WHY_KIND)".
- [ ] (Als je die hebt) een enchanter-wand (Lesser Magic Wand): "Cannot be disenchanted (this item never can)". Klopt dat?
      En een item met lage skill disenchanten lukt? (Dan heeft Forever geen skill-drempel; AFGELEID.)

## 📚 18 nov (nacht) — Forever: eerst wat je nodig hebt, dán de reis (class quests)

Geen nieuw bestand: een `/reload` is genoeg.
- [ ] Mage zonder boek, nog geen Research Access (bv. Ima Magieman): Now-kaart / Class quests zegt "first get a library
      book: <naam>" en "Show the way" wijst naar dat BOEK (Human: Tower of Azora in Elwynn; Gnome: Ironforge; Undead:
      Brill; Orc/Troll: een tablet in Orgrimmar, plek uit een gids). NIET meer naar de bibliothecaris.
- [ ] Klik het boek aan (het ligt op een tafel/plank). Nu zegt de kaart: "you have a library book: hand it in to Garion
      Wendell" (Alliance) / "Owen Thadd" (Horde), en de pijl gaat naar de bibliothecaris.
- [ ] Lever het boek in. Biedt de bibliothecaris nu meteen Research Access aan? (Dat één boek genoeg is, is NIET gemeten.)
- [ ] (Wie er toevallig is) Paladin met de charger-quest en minder dan 150 goud: de kaart zegt eerst 150 goud halen
      (bij Rohan, en bij Grimand pas als de Stratholme-spullen binnen zijn). Warlock Dreadsteed in de Burning Steppes
      zonder Shadowy Potions: eerst kopen, en 150 goud meenemen; voor het ritueel eerst de drie spullen van Gorzeeki.
      Priest-robe zonder Lesser Heal (Rank 2): eerst leren — klopt dat, of zegt hij het ook als je hem al hebt?
      (AFGELEID hoe het spel een rank meldt.)
- [ ] Mage "Items of Power": hij gaat pas verder na 10 Witherbark Totem Sticks (was: na 1).

## 🧭 18 nov (laat) — Forever: Find → Travel (zeppelins, boten, flight masters)

Geen nieuw bestand: een `/reload` is genoeg.
- [ ] Overzicht → Find: onderaan een kopje **Travel** met "Boats, zeppelins & portals" en "Flight Masters".
- [ ] Horde in Orgrimmar: "Boats, zeppelins & portals" → de twee zeppelins in Durotar ("The zeppelin to Tirisfal Glades" en
      "… to Stranglethorn Vale"). Eronder de uitleg: hoofdpoort uit, links, omhoog naar de toren. Klopt die uitleg?
- [ ] Klik "Show the way" bij een zeppelin: de pijl gaat naar de toren. Sta je er, dan verdwijnt hij.
- [ ] "Flight Masters": alleen die van jouw kant (plus Ratchet, Marshal's Refuge, Mount Hyjal), dichtstbijzijnde eerst.
      Klik er een: pijl erheen. Staat hij op de goede plek?
- [ ] Zoekbalk: typ `zep`, `fp`, `flight master`, `boat`, `tram`, `wind rider` of `gryphon`: bovenaan het juiste kopje
      en de dichtstbijzijnde plekken, elk met "Show the way".
- [ ] Nakijken als je er toch bent (niet in het spel gemeten): de flight masters van **Light's Hope Chapel** (Eastern
      Plaguelands), en of de zeppelin **Grom'gol ↔ Undercity** en de **Feathermoon-veerboot** echt varen.
- [ ] Lange lijsten (bv. This week, de dungeonlijst): de oranje woorden "scroll for more" staan nu in een eigen strookje
      ONDER de lijst, niet meer over de laatste regel of een knop. Korte lijst: geen strookje, geen woorden.
- [ ] (18 nov nacht) Boot- en zeppelinpunten zijn nu onze eigen waarden (speldata). Bij de halte: verdwijnt de pijl
      als je op de steiger/het platform staat (binnen 25 yd)?
- [ ] Horde in Thunder Bluff: "Boats, zeppelins & portals" → onder de skycutter in Mulgore staat "Thunder Bluff has
      none: fly to Orgrimmar with Tal …".

## 🧪 18 nov (avond) — MIDNIGHT: aura-code las andermans buffs altijd als "onleesbaar"

Geen nieuw bestand: een `/reload` is genoeg. Buiten een gevecht testen (in een gevecht blijft het bewust "onbekend").
- [ ] Groep (of je Delve-companion) zonder jouw bondgenoot-buff (bv. Beacon of Light als Holy Paladin): de herinnering
      BUFF ALLY verschijnt nu wél. Geef de buff: hij verdwijnt. (Was: kwam nooit.)
- [ ] Raid-buffs ("x van y gebufft", GroupBuffs): in een groep buiten een instance telt hij nu echt mee, in plaats van
      "het spel verbergt groepsaura's".
- [ ] Ready check-bord / consumables: zonder flask of rune staat er nu een rood kruis i.p.v. "?"; met flask groen.
- [ ] Geen valse meldingen: in een gevecht of in een instance waar het spel aura's verbergt, blijft het "?" / stil.
- [ ] (Nog open van eerder) De Midnight-zoekbalk werkt nog als vanouds: typ `rares` en klik.

## 🔁 18 nov (avond) — twee instellingen die niet uit konden

Geen nieuw bestand: een `/reload` is genoeg.
- [ ] Forever: Esc → Options → AddOns → Midnight Helper: "Step aside for the Forever Leveling Guide" gaat uit en blijft
      uit na een /reload.
- [ ] Midnight: zelfde plek: "Fill in the amount when buying" gaat uit en blijft uit na een /reload.

## 🧩 18 nov (avond) — Forever: Now-kaart zonder overlap, portret standaard rond

Geen nieuw bestand: een `/reload` is genoeg.
- [x] Overzicht: linksboven weer het ronde plaatje (Moving portrait staat nu standaard UIT). Zet je hem aan: het
      3D-model, beter op het gezicht gericht dan eerst. (Rob, 18 nov, punt 1)
- [x] Now-kaart met een class quest (bv. Ima Magieman, "Study"): titel, uitleg en plek staan helemaal (tot 3 regels),
      en de lijst eronder ("You can learn 2 new weapon skills now.") begint pas daaronder - niets over elkaar. (Rob, 18 nov, punt 1)
- [x] Muis op de titel van de Now-kaart: de hele tekst in een tooltip. (Rob, 18 nov, punt 1)

## 🎭 18 nov (laat) — Forever: bewegend portret linksboven

Geen nieuw bestand: een `/reload` is genoeg.
- [x] Overzicht: linksboven je character in 3D in een vierkant vakje met gouden rand (niet rond: een 3D-model laat zich
      niet rond afknippen). Hij ademt en knippert. Steekt er niets buiten het vakje? (Rob, 18 nov: *"Het bewegende werkt
      keurig"*; hij vindt het ronde plaatje stiekem mooier - standaardstand vraagt sparring hem.)
- [ ] Wissel van uitrusting of vorm (druid): het model past zich aan.
- [x] Tandwiel → stille helpers → "Moving portrait" uit: het oude ronde plaatje komt METEEN terug (zonder /reload). Weer
      aan: het model. (Rob, 18 nov: werkte niet → gerepareerd, zie hieronder.) (Rob, 18 nov, punt 1)
- [x] Zelfde reparatie: "Which quest reward to take" en "Better than what you wear" bij de stille helpers gaan nu ook
      echt uit (ze bleven eerst ook aan). (Rob, 18 nov, punt 1)
- [ ] Blijft het vakje leeg/zwart? Zeg het: dan staat in `foreverPortraitProbe` (SavedVariables, na /reload) waarom.

## 🪙 18 nov (laat) — Forever: altijd goud, zilver én koper + Now-regels helemaal leesbaar

Geen nieuw bestand: een `/reload` is genoeg (na de herstart voor de rares).
- [x] Links: "Gold: 0 [goud] 3 [zilver] 14 [koper]" - alle drie de muntjes, ook bij 0. Zo ook "Costs …" op de Now-kaart,
      de Characters-regels, het totaal en de trainerpagina. (Rob, 18 nov, punt 1)
- [x] Now-lijst: "You can learn 8 new weapon skills now. (fitting Beast Mastery, according to …)" staat er helemaal; de rij
      wordt zo hoog als nodig. Geen enkele regel in die lijst eindigt nog op "…". (Rob, 18 nov, punt 1)

## 🗺️ 18 nov — Forever: alle rares per zone (stap B)

⚠️ Nog een nieuw bestand: WoW helemaal herstarten (/reload is niet genoeg).
- [x] Find → Rares: onder "Worth the trip" een regel per zone met levels, bv. "The Barrens (13-36)". Klik er een: alle
      rares van die zone, de dichtstbijzijnde eerst, met level (of "level ??") en Show the way (rode pijl). (Rob, 18 nov, punt 1)
- [x] Zoekbalk: typ de naam van een rare die je kent, of een zone-naam → de rare of de zonelijst. (Rob, 18 nov, punt 1)
- [x] Merk je bij het typen dat het spel hapert? (Offline max 0,06 s per letter, nu ~1400 regels per character.) (Rob, 18 nov, punt 1)

## 🧽 18 nov — Forever: goud en 6 schermfouten van Robs screenshots (daarna nieuwe screenshots voor de site)

Zit in dezelfde ronde als de rares (nieuw bestand): WoW eerst helemaal herstarten.
- [x] Links onder je character: "Gold: 3 silver 14 copper" (met muntjes), niet "Gold: 314". Now-kaart: "Costs 10
      copper" met muntje, niet "Costs 10". (Rob, 18 nov, punt 1)
- [x] Characters: "All your gold together: … (14 characters)" — het getal is al je characters samen, ook die je pas
      ziet als je naar beneden scrollt. (screenshot Rob 18 nov: "0g 98s 22c (15 characters)", gemeten door sparring)
- [x] Now-kaart: "DO THIS NOW" staat vrij, de knoppen Details en Show the way liggen er niet meer overheen. (Rob, 18 nov, punt 1)
- [x] Knoppen in de Now-lijst: "Weapon trainer" en "Profession trainer" helemaal leesbaar. (Rob, 18 nov, punt 1)
- [x] Your path: "Aspect of the Monkey" heel, eventueel op twee regels. (screenshot Rob 18 nov: mage-pad level 7-13 toont
      netjes zonder afkappen, gemeten door sparring; de hunter-naam zelf niet gezien)
- [ ] Elke lijst die verder gaat (Now-lijst, This week, dungeons, macro's) zegt onderaan in oranje "scroll for more";
      aan het eind van de lijst verdwijnt dat.
- [ ] Keys & macros, "Set focus": de gele regel blijft binnen zijn eigen rij.

## 🐉 18 nov — Forever: rares die de moeite waard zijn (stap A)

⚠️ Nieuw bestand: eerst WoW helemaal afsluiten en opnieuw starten (/reload is niet genoeg).
- [x] Overzicht → Find: onderaan de lijst links het kopje **RARES** met "Worth the trip". Rechts de rares die jouw kant
      kan aanvallen, de dichtstbijzijnde eerst, met level (en "elite") en onder elke naam één zin waarom. (Rob, 18 nov, punt 1)
- [x] "Show the way" bij een rare: een **rode** pijl met het rare-icoon. Als je er bent (binnen ~20 m) gaat hij weg.
      Klopt de plek? (Sommige rares lopen rond.) (Rob, 18 nov, punt 1)
- [x] Zoekbalk: `@rare` toont ze allemaal; `pet` vindt de rares met een huisdiertje; `tame` de nieuwe hunter-beesten. (Rob, 18 nov, punt 1)
- [x] Horde ziet Dalaran Spellscribe en Aean Swiftriver wél en Sewer Beast niet; Alliance andersom. (Rob, 18 nov, punt 1)

## 🪙 18 nov — Forever: kaart "Reputation & currency"

Geen nieuw bestand: een `/reload` is genoeg.
- [x] Overzicht → tab Characters → knop **Reputation & currency** (vierde knop). Bovenaan je 5 munten met aantal (en
      maximum: Honor 25000, Real 165). Daaronder de groepen van jouw kant: naam, rang, punten (bv. 200 / 3000),
      "Next: …" en "How: …". Onderaan "Other groups you know" (je steden) en een grijze regel over de bronnen. (Rob, 18 nov, punt 1)
- [x] Geen groepen van de andere kant (Horde ziet geen Kirin Tor, Alliance geen Earthen Ring). (Rob, 18 nov, punt 1)
- [x] Zoekbalk: typ `honor` of de naam van een groep (bv. `argent`) → klik → deze pagina opent. (Rob, 18 nov, punt 1)
- [x] Haal wat reputatie (een quest of een kill): de pagina past zich aan terwijl hij open is. (Rob, 18 nov, punt 1)
- [ ] (Alleen als je veel Honor hebt) This week zegt bij 90% "almost full".

## 🔤 18 nov — Forever: zoeken op afkortingen (na Robs test)

Geen nieuw bestand: een `/reload` is genoeg.
- [x] Typ `ah` (of `AH`): bovenaan Auction House, daaronder de veilingmeesters, de dichtstbijzijnde eerst. (Rob, 18 nov, punt 1)
- [x] Ook: `hearth` (herberg), `mail` (brievenbus), `banker` (bank). (Rob, 18 nov, punt 1)

## 🧭 18 nov — Forever: zoekbalk stap 2, elke plek met "Show the way"

Geen nieuw bestand: een `/reload` is genoeg.
- [x] Typ `bank`: onder "Bank" staan de bankiers zelf, de dichtstbijzijnde eerst, met zone · afstand · Show the way.
      Klik er een: Find opent op Bank én de pijl gaat naar die bankier. Klopt de plek? (Rob, 18 nov)
- [x] Hetzelfde met de naam van een trainer of verkoper die je kent, een herbergier, en `auction`. (Rob, 18 nov)
- [x] Een dungeon-naam: twee regels; de ene opent de dungeon-tab, de andere ("· Show the way") zet de pijl naar de
      ingang. (Rob, 18 nov)
- [x] `@quest`: per class quest ook een regel "· Show the way" die de pijl naar de volgende stap zet. (Rob, 18 nov)
- [x] Merk je bij het typen dat het spel even hapert? (Gemeten offline: max 0,04 s per letter.) (Rob, 18 nov: goed)

## 📏 18 nov — Forever: meting valuta en reputaties (`/mh repprobe`)

Geen nieuw bestand: een `/reload` is genoeg. Het liefst op je hoogste Forever-character.
- [x] Typ `/mh repprobe`. In chat: vijf regels met yes/no, je Honor, Rank Points, Merchant's Favor, Tarnished Undermine
      Real en Darkmoon-tickets (aantal / maximum), en hoeveel facties leesbaar zijn. (Rob, 18 nov)
- [x] Daarna `/reload` (dan staat alles in het SavedVariables-bestand) en zeg het tegen de sparring-chat. Ik lees het
      bestand zelf; geen screenshot nodig. (Rob, 18 nov; uitslag in NEXT_SESSION)

## 🔍 18 nov — Forever: zoekbalk bovenin het overzicht (stap 1)

Geen nieuw bestand: een `/reload` is genoeg.
- [x] `/mh` (overzicht): in de titelrij, tussen MIDNIGHT HELPER en het tandwiel, staat een zoekvak met grijze tekst
      "Search everything: …". Muis erop: uitleg. (Rob, 18 nov)
- [x] Typ `bank`: een lijst onder het vak, bovenaan "Bank  In town". Klik erop → tab Find opent op Bank. (Rob, 18 nov)
- [x] Probeer ook: `mining` (of je eigen beroep), een dungeon-naam, `mouseover`, `macro`, `/move`, en een typfout
      (`banck`). Elke klik opent de juiste tab of pagina; een /mh-regel voert dat commando uit. (Rob, 18 nov)
- [x] `@quest` toont je class quests, `@dungeon` de dungeons. Pijltjes omlaag/omhoog + Enter werken ook. (Rob, 18 nov)
- [x] `zzzz`: één grijze regel "Nothing found…", klikken doet niets. Escape maakt het vak leeg en je kunt weer lopen.
      (Rob, 18 nov, in "1 tot en met 4". ⚠️ Sinds stap 2 vindt `zzzz` via de typfout-ronde de visser "Zizzek"
      (offline gemeten); wat Rob bij `zzzz` zag, weten we niet precies.)
- [x] De lijst heeft de warme kleuren en letters van het overzicht. (Rob, 18 nov)
- [ ] Midnight (retail): de zoekbalk in het grote MH-venster werkt nog precies als eerst (typ `rares`, klik). Komt later
      (Rob, 18 nov: *"6 komt later"*).

## 🪪 18 nov — Forever: naam + achternaam in Characters

- [ ] Forever: log één keer in op een character met achternaam, dan `/mh alts` (tab Characters). De naam staat er net zo
      als het spel hem zelf schrijft (bv. "Ima Pallie"), zonder rare tekens of dubbele spatie.

## 🏦 17 nov (laat) — Forever: bank, veilinghuis, brievenbus en herberg in Find

Eerst WoW helemaal afsluiten en opnieuw starten (er is een nieuw bestand; /reload is niet genoeg).
- [ ] `/mh overview` → tab Find: onderaan de lijst links een kopje **IN TOWN** met Bank · Auction House · Mailbox · Inn.
- [ ] Klik Bank in een hoofdstad: bovenaan de bankiers van díe stad, met afstand. "Show the way" zet de pijl; die
      verdwijnt als je er bent. Klopt de plek?
- [ ] Auction House: de neutrale (Gadgetzan, Booty Bay, Everlook) staan erbij met "<neutral>" achter de naam.
- [ ] Mailbox: de dichtstbijzijnde brievenbus staat bovenaan en staat echt daar. (Een brievenbus die we missen: zeg
      waar, dan voegen we hem toe.)
- [ ] Inn: de herbergier van je stad bovenaan. In Dalaran (Alliance) staan er twee.
- [ ] Forever: typ `/mh settings` → Midnight Helper opent in de instellingen van het spel (Esc > Options > AddOns), niet
      het overzicht. (Gerepareerd 17 nov: dit ging waarschijnlijk mis; niet in het spel gezien.)
- [ ] Valanaar (Zephras Isle): bank, AH en herberg staan erin. Opent die AH het neutrale of het gewone veilinghuis?
      (Weten we niet: zeg het als je er komt.)

## 🎨 17 nov (avond) — Forever: stijlkit onder het overzicht (`/mh overview`)

Eerst WoW helemaal afsluiten en opnieuw starten (er is een nieuw bestand; /reload is niet genoeg).
- [ ] `/mh overview` opent zonder foutmelding en ziet er precies hetzelfde uit als ronde 5 (zelfde letters, kleuren,
      knoppen, NOW/LATER-labels onder Jouw pad).

## 🎨 17 nov (nacht) — Forever: de losse vensters in dezelfde stijl als het overzicht

- [ ] Open: het kleine "Do this now"-venster (`/mh donow`), "Your direction" (`/mh direction`), "New in this version"
      (`/mh new`), het toetsenblok (`/mh block`). Allemaal: warme donkere achtergrond met gouden rand, dezelfde letters
      als het overzicht, knoppen in de kleur van je class. Niets valt over de rand, alles is leesbaar.
- [ ] Shift+scroll maakt ze nog steeds groter/kleiner; Escape sluit ze.
- [ ] Een knop die grijs/uit staat (bv. Make bij een macro die nog niet kan): leesbaar?
- [ ] In Midnight (retail) zien deze vensters er nog precies zo uit als eerst.

## 🧹 17 nov (nacht) — Forever: geen oud venster meer, geen Dock-knop, tandwiel met Tools en commando's

- [ ] Rechtsboven in het overzicht alleen nog het tandwiel en het kruisje (geen "Dock", geen "All tools").
- [ ] Tandwiel: bovenaan drie knoppen — Quiet helpers · Tools · All commands. Tools: elke andere MH-tool met "Open"
      (o.a. Move MH, Quick bar, New in this version, Changelog, All settings; met MF Nameplates ook de kleurkaart).
      All commands: alle /mh-commando's; typ in het zoekvak, de lijst wordt korter.
- [ ] Het oude MH-venster komt in Forever nergens meer tevoorschijn: niet via /mh, Alt+M, de minimapknop, de snelbalk
      of `/mh settings`. Rechtsklik op de minimapknop en `/mh settings` openen MH in de instellingen van het spel.
- [ ] De achtergrond van het overzicht is ook bovenin helemaal dicht.

## 🩹 17 nov (nacht) — Forever: 4 reparaties na Robs eerste test van het overzicht (3 screenshots)

Eerst WoW helemaal afsluiten en opnieuw starten (de fout zat juist in de eerste keer openen).
- [ ] Open het overzicht meteen na het inloggen (`/mh` of Alt+M): alle 7 tabs en "All tools" hebben tekst, en bij
      "Your path" staan de namen. (Was: lege roze vakjes tot een /reload.) Na een /reload: in
      `WTF/.../SavedVariables/MidnightHelper.lua` staat `foreverFontProbe` met per opening hoeveel teksten leeg waren
      vóór en na het opnieuw zetten (emptyAfter hoort 0 te zijn).
- [ ] Kaart DO THIS NOW: geen regels meer over elkaar (de dungeon-tip met "The Hall of Thanes" en "Best stats for you
      now" staan netjes onder elkaar). Een lange hoofdregel staat als korte titel met de rest eronder, niet afgekapt.
- [ ] Kaart THIS WEEK (en elke lijst die scrolt): onderaan geen halve regel meer maar een zachte overgang; aan het eind
      van de lijst verdwijnt die.
- [ ] Geen vaag tekstje meer achter de titel: het venster is nu helemaal dicht (het was het naamplaatje van een monster
      in de wereld dat erdoor scheen).

## 🧪 17 nov (nacht) — Forever: handige macro's pakken je hoogste rang (Fable-controle)

- [ ] Rogue met **Stealth rang 2** (of hoger) en een druid met **Prowl rang 2**: in Keys & macros staat de Stealth-/
      Prowl-rij met "Make" (niet grijs "Learn this spell at your class trainer first"). Maak hem en druk hem: je gaat in
      stealth/prowl.
- [ ] Rogue met Eviscerate rang 2+ en Vanish rang 2: de rijen "Finisher" en "Vanish + Sprint" zijn ook te maken.
- [ ] (Alleen als je een Braziliaanse/Mexicaanse client hebt) Mage-Intellect / warlock-Healthstone: de macro gebruikt je
      hoogste rang.
- [ ] Priest-Fortitude-rij: de uitleg noemt nu ook de Sacred Candle voor rang 2 op level 60.

## ⚙️ 17 nov (nacht) — Forever: tandwiel "What Midnight Helper does quietly for you" (plan-stap 9)

- [ ] Rechtsboven, links van "All tools", een knopje met een tandwiel. Klik: een pagina met alles wat MH stil voor je
      doet, in vier groepjes (bij de vensters van het spel, in tooltips, waarschuwingen, op je scherm), elk met één zin
      en een AAN/UIT-labeltje. Nog een keer op het tandwiel = terug naar Now.
- [ ] Zet er een uit en weer aan (bv. "Bags almost full"): het labeltje wisselt; `/mh bags` zegt hetzelfde.
- [ ] Knop "All settings ›" opent Midnight Helper in de instellingen van het spel.

## 👥 17 nov (nacht) — Forever: tab "Characters" in het overzicht (plan-stap 8)

- [ ] De tab **Legacy** is weg; op zijn plek staat **Characters** met bovenaan drie knoppen: Your characters · Legacy ·
      This week.
- [ ] Your characters: elk character van je account (na één keer inloggen) met Horde/Alliance-tekentje, naam in
      klassekleur, level, goud, richting, wanneer laatst gespeeld, spells klaar bij de trainer, en je beroepen. Bovenaan
      rechts het totale goud. "x" vergeet een ander character (je eigen heeft geen x).
- [ ] Legacy: dezelfde pagina als eerst, nu onder Characters. This week: de hele lijst (resets, evenementen, raids, PvP).
- [ ] `/mh alts` en de tegel "Your characters" openen deze tab (nog een keer = dicht).

## 🏰 17 nov (nacht) — Forever: tab "Dungeons & group" in het overzicht (plan-stap 7)

- [ ] Tab **Dungeons & group**: links DUNGEONS, laagste eerst, met een labeltje "13-18" (klassekleur = past nu, oranje
      = bijna, grijs = te laag/later), naam, zone van de ingang, bij een paar de reisstap, en "Way ›" (pijl naar de
      ingang). Een dungeon met de ingang in een stad van de andere kant zegt dat in oranje.
- [ ] Rechtsboven het schakelaartje "Only for my level": uit = alle dungeons, aan = alleen wat nu (of bijna) past.
- [ ] Rechts RAIDS (je raid-lockouts of "raids open on …") en GROUP: hoogste level in je groep, de XP-regel (rood als
      iemand te hoog is voor je target of deze dungeon), en schakelaars voor het groepspaneel en de markeerbalk.
- [ ] `/mh dungeons` en de knop in Do this now openen deze tab (nog een keer = dicht).

## 🧪 17 nov (nacht) — Forever: tab "Professions" in het overzicht (plan-stap 6)

- [ ] Tab **Professions**: links alle 12 beroepen, jouw beroepen bovenaan in goud met je skill (bv. 140/150).
- [ ] Klik een beroep: rechts de kaart (wat het doet, hoofd/bij, gereedschap, past bij, rangen, je volgende rang), een
      balk met je skill, en een regel of je het gereedschap bij je hebt (groen ja / rood nee).
- [ ] Knop "Trainers" → tab Find op dat beroep. Knop "Where to buy" (alleen bij een beroep met gereedschap) → de verkopers.
- [ ] Onderaan "HELP AROUND PROFESSIONS" met drie AAN/UIT-schakelaars: extra regels in item-tooltips (Used for …),
      waarschuwen voor je laatste gereedschap, en de tip "gereedschap kwijt? hier te koop". Uitzetten werkt meteen.
- [ ] De tip "Room for a main profession" in Do this now opent nu deze tab.

## ⌨️ 17 nov (nacht) — Forever: tab "Keys & macros" in het overzicht (plan-stap 5)

- [ ] Tab **Keys & macros**: links YOUR KEYS met drie knoppen (1. Set up my keys → het toetsenblok-venster, 2. Which
      spells do I press?, 3. Show my keyboard), elk met een regel uitleg. Staat tellen uit, dan zegt regel 2 dat in oranje.
- [ ] Daaronder SWITCHES: Mouseover on the key block, de oranje rand bij een oude rang, en "Offer the MH bar layout on
      new characters". Klik op het AAN/UIT-labeltje: het wisselt. Mouseover zegt het ook in de chat.
- [ ] Rechts HANDY MACROS: dezelfde rijen als het oude venster, met Make/Update (opent het macrovenster) en, als een
      andere toets je Shift/Ctrl/Alt pakt, "Free key". Onderaan "Undo freed keys" als er iets terug te zetten is.
- [ ] `/mh macros`, `/mh mykeys` en de tegels "Handy macros" / "Your keys" openen nu deze tab (nog een keer = dicht).

## 🔎 17 nov (nacht) — Forever: tab "Find" en tab "Your class" in het overzicht (plan-stap 4)

- [ ] De tabrij: Now · Your class · Find · Professions · Dungeons & group · Keys & macros · Characters. "Your class" heeft bovenaan drie knoppen: How you play · Class quests
      · Camping. Klik ze alle drie; de tab blijft oplichten. Klik Now en weer Your class: je komt terug op de laatste.
- [ ] Tab **Find**: links "WHAT ARE YOU LOOKING FOR?" met Trainer, Professions (jouw beroepen bovenaan in goud, met je
      skill), Weapon skills (bekend = grijs "(known)", groene + = past bij je richting) en Shops. Je kunt erin scrollen.
- [ ] Klik je class trainer: rechts alle trainers van je class aan jouw kant, dichtstbijzijnde eerst, met zone en
      afstand. Bij een trainer verder weg (bv. in Ironforge) staat een gouden regel "The way there: …".
- [ ] "Show the way ›" achter een rij: de pijl wijst naar DIE trainer/verkoper/wapenmeester.
- [ ] Een beroep met gereedschap (Mining, Fishing …): knop "Where to buy" rechtsboven springt naar de verkopers.
- [ ] Oude ingangen landen op Find: `/mh trainers`, `/mh vendor fishing`, `/mh weapons`, de knoppen "Weapon trainers" en
      "Profession trainers" in Do this now, en de tegels op de startpagina. Nog een keer hetzelfde = overzicht dicht.
- [ ] `/mh trainer` opent nu de trainer-pagina van het overzicht (nog een keer = dicht). Daar staat een knop "All
      trainers" → Find.

## 🧑‍🏫 17 nov (laat) — Forever: trainer-pagina in het overzicht

- [ ] Heb je iets te leren bij je trainer: op de Now-kaart staat naast "Show the way" een knop "Details". Klik: een
      pagina met je geld, wat alles kost, en per spell de prijs en de toets op je MH-toetsenblok (bv. "Shift-Z").
- [ ] Muis op een icoon: de spell-tooltip. Muis op het toets-label: uitleg.
- [ ] Ga een level omhoog (met nieuwe spells): het overzicht gaat vanzelf open op deze pagina (als "automatisch
      openen bij level-up" aan staat, zoals het trainervenster deed).
- [ ] ~~`/mh trainer` opent nog het oude trainervenster~~ — vervallen 17 nov (plan-stap 4): `/mh trainer` opent nu de
      trainer-pagina (zie het blok hierboven).

## 📋 17 nov (laat) — Forever: de hele "Do this now"-lijst in het overzicht

- [ ] Open het overzicht én het kleine "Do this now"-venster: de kaart DOE DIT NU noemt dezelfde dingen (bovenaan de
      belangrijkste, daaronder de rest — oude rangen, wapens, buffs, gereedschap, tips), en je kunt erin scrollen.
- [ ] Achter een regel staat dezelfde knop als in het kleine venster (bv. "Fix all", "Weapon trainers").
- [ ] Rechts staat nu de kaart THIS WEEK (resets, evenementen van vandaag, raids). Links onder je XP: je goud.
- [ ] In het kleine venster: knop "Open overview" opent het overzicht.

## 🚪 17 nov (laat) — Forever: /mh, Alt+M en de minimapknop openen het overzicht

- [ ] Typ `/mh` (of druk Alt+M, of klik links op de minimapknop, of op MH in het addon-menu rechtsboven, of de MH-knop
      op de snelbalk): het nieuwe overzicht gaat open/dicht, niet het oude venster.
- [ ] De tabs staan nu op een eigen rij onder "MIDNIGHT HELPER" en passen (ook in het Duits).
- [ ] Rechtsboven: knop "All tools" opent het oude venster met alles wat nog geen tab heeft.
- [ ] Middenklik op de minimapknop: het venster "Do this now". Muis op de knop: de tooltip zegt dat ook.
- [ ] Rechtsklik op de minimapknop: nog steeds de instellingen.

## 🛡️ 17 nov (avond) — Forever paladin: zegen-tip in de tooltip (`/mh blesstip`)

WoW eerst helemaal herstarten (nieuw bestand). Staat standaard UIT.
- [ ] Typ `/mh blesstip on`. Ga met je muis over een vriendelijke speler (een warrior, een mage …): onderaan de tooltip
      staat "Midnight Helper: give Blessing of …" (met "(Shift+Z)" e.d. als je MH-toetsenblok staat).
- [ ] Warrior/rogue = Might; mage/warlock/priest = Wisdom; hunter/druid/shaman/paladin = Kings (vanaf 20; daarvoor Wisdom).
- [ ] Muis op een speler en typ `/mh blesstip`: de chat zegt welke zegen en waarom. Daarna `/reload` (ik lees
      `foreverBlessTipProbe`: werkt de tooltip-hook in Forever?).
- [ ] Zie je géén regel in de tooltip? Typ `/mh blesstip` en zeg wat er bij "hook" en "fired" staat.

## 🎨 17 nov (avond) — Forever: knoppen in het overzicht (`/mh overview`)

- ~~Knop "Style A/B", ontwerp B, instelling, /mh overview style~~ VERVALLEN: Rob, *"Ja, B mag eruit."* — weer weggehaald.
- [ ] De knop "Your direction: Protection" past nu binnen zijn rand (tekst krimpt).
- [ ] Zie je op How you play nog het vage tekstje links naast "CONTENTS"? Graag een screenshot.

## 📖 17 nov (avond) — Forever: tab How you play als pagina (`/mh overview`)

- [ ] Tab "How you play": links "CONTENTS" met alle kopjes (je eigen rol in je klassekleur). Klik er een: de tekst rechts
      springt naar dat kopje.
- [ ] Rechts de hele uitleg met grote koppen in goud, scrollen met het wiel.
- [ ] Knop "Direction: …" opent de richting-keuze; kies je een andere richting, dan past de pagina zich aan.
- [ ] Knop "Other roles" klapt de andere rollen open en weer dicht.

## 🏕️ 17 nov (avond) — Forever: tabs Kamperen en Legacy als pagina + je hele naam (`/mh overview`)

- [ ] Tab "Camping": links "YOUR CAMP NOW" met vijf rijen (Campfire Nearby, Welcoming Campfire, Camp Benefits, Boosted
      Rest, Camping) en ja / nee / ?. Rechts de uitleg over kamperen (scrollen met het wiel).
- [ ] Ga bij een kampvuur staan en ga zitten: de rijen springen binnen 2 seconden om (ja), en onderaan staat wat je moet
      doen. Een "?" betekent: het spel laat MH dat niet lezen.
- [ ] Tab "Legacy": vijf rijen (verdiend, ongebruikt, uitgegeven, max per character, Talented-rang) met getallen, en de
      Legacy-uitleg rechts.
- [x] Je naam links: "IMA PALLIE" (Rob, screenshot via sparring, 17 nov). Nog open: na een `/reload` lees ik in je
      SavedVariables (`foreverNameProbe`) welke functie de achternaam geeft.

## 📜 17 nov (avond) — Forever: tab Class quests als pagina (`/mh overview`)

- [ ] Klik op de tab "Class quests": de rechterkant wordt één kaart met al je class-quests op volgorde van level. Je
      portret en level links blijven staan. Klik "Now" en je bent terug.
- [ ] Per regel: level-bolletje, spell-icoon (muis erop = de spell), naam, een label KLAAR (groen) / NU (klassekleur) /
      LATER (grijs), wat je moet doen, de plek eronder, en een knop "Show the way" die de pijl zet.
- [ ] Bij LATER: "Get the quest from <naam> · from level N" en de knop wijst naar die persoon.
- [ ] Lange lijst (mage, warlock): met het muiswiel scrollen; Shift+wiel maakt het venster nog steeds groter/kleiner.
- [ ] Rechtsboven in de kaart: "x of y done".

## 🆕 17 nov — Forever: nieuwe handige macro's (`/mh macros`)

Open `/mh macros`, klik "Maak" bij een nieuwe rij, sleep de macro naar een balk en druk. Ctrl = de tweede functie.
- [ ] Iedereen: "Eat and drink" — eet en drinkt tegelijk het beste uit je tassen. Mage: Ctrl + druk maakt water.
      Zonder eten of water: de rij zegt dat.
- [ ] Mage: Intellect (Ctrl = Arcane Brilliance, 56), Mana Gem (geen gem → maakt er een; Ctrl = Evocation).
- [ ] Priest: Fortitude (Ctrl = Prayer of Fortitude, 48), Spirit (30), Resurrect, Shackle (zet zelf een focus).
- [ ] Warlock: Healthstone en Soulstone (Ctrl = maken), Shadow Bolt (demon valt mee aan; Ctrl = demon terug).
- [ ] Hunter: Aspects (gevecht = Hawk, daarbuiten Cheetah vanaf 20, Ctrl = Monkey).
- [ ] Druid: Prowl vanuit Bear/Travel: eerste druk Cat Form, tweede Prowl. Hibernate (zet zelf een focus).
- [ ] Rogue: Stealth (Ctrl = ook Sprint), VanishSprint, Finisher (Ctrl = Slice and Dice).
      Rogue level 6+: typ `/dump IsPlayerSpell(1752), IsSpellKnown(1752)` en zeg wat er staat (rank-vraag).
- [ ] Shaman: Resurrect, Fire Totem (Ctrl = Magma, 26). Paladin: Resurrect.

## 🎨 17 nov (ronde 5) — Forever: ontwerp A als er niets dringends is (`/mh overview`)

- [ ] Geen taak meer (zoals jij na Redemption): de grote titel is "All caught up" met eronder "Nothing urgent: keep
      levelling. Next new spell: … at level …". De dungeon-tip staat eronder als gewone regel, niet als titel.
- [ ] De rechterkaart toont "Your class quests" (klaar / vanaf level N) ook als er nu niets open staat.
- [ ] Jouw pad, bolletje "Now": eronder "All caught up" of je taak, nooit de dungeon-tip.

## 🔎 17 nov — Forever paladin 52+: Greater Blessing via mouseover op een vreemde? (meetklus)

Pas vanaf level 52 (Greater Blessing of Might). Niets veranderd; eerst meten.
- [ ] In een groep, muis op een voorbijganger die NIET in je groep zit, druk Shift+Z (blok): krijgt hij Greater
      Blessing of Might (kost een Symbol of Kings) of de gewone? Gewone = goed; Greater = fout.
- [ ] Zelfde, muis op een groepslid: Greater is dan goed.

## 🎨 17 nov (ronde 4) — Forever: ontwerp A, afgekapte teksten (`/mh overview`)

- [ ] Binnenkort is weer breder; de rank staat op de tweede regel ("level 18 · Rank 3"), de naam past.
- [ ] De dungeon-tip in "Doe dit nu" mag nu drie regels gebruiken.
- [ ] Hall of Thanes (jouw keuze c, "Ik volg jouw advies"): op een Horde-character van 13-20 zegt de dungeon-tip nu
      "The Hall of Thanes (entrance in Ironforge: you travel through Alliance territory)". Op Alliance gewoon "(Ironforge)".

## 🎨 17 nov (ronde 3) — Forever: ontwerp A, kleine puntjes (`/mh overview`)

- [x] Ronde 2 GEDAAN (Rob): *"alle tooltips komen netjes, wauw"*.
- [x] Redemption-pijl volgt de keten (Undead paladin): Rob, *"ik ben die questline aan het uitlopen … Dat klopt."*
- [ ] Rechterkaart "Your class quests" is breder; met je muis op een regel zie je de volledige naam (bv. "Wolfsbane: the
      Kor Gem" = de gem-quest, "Wolfsbane (a two-handed sword)" = de wapenketen).
- [ ] "Doe dit nu": de dungeon-tip mag nu over twee regels.
- [ ] Binnenkort: een spell die je al hebt staat er met de rank achter, bv. "Seal of Righteousness (Rank 3)" op 18.

## 🎨 17 nov (ronde 2) — Forever: ontwerp A na jouw opmerkingen (`/mh overview`)

Jouw oordeel op ronde 1: *"Ja, ik ben onder de indruk. … dit is de weg waar ik graag heen wil. Absoluut."* `/reload` is nu
genoeg (geen nieuwe bestanden).
- [ ] "Dock to window" staat nu naast de titel "MIDNIGHT HELPER", niet meer over de tab Legacy.
- [ ] Tooltips: ga met je muis over de tabs, de knoppen, de spell-icoontjes (spell-tooltip), de kaartkopjes (DOE DIT
      NU …), de bolletjes in Jouw pad, de chips NU/LATER, het levelzegel, je portret en de XP-balk.
- [ ] Jouw pad: de laatste kolom blijft nu binnen het kader.
- [ ] Class quest staat niet meer dubbel: staat hij al bij "Doe dit nu", dan toont het rechterkaartje "Jouw class-quests"
      (klaar / nu open / vanaf level N).
- [ ] Links onder je naam: een XP-balk met procent (en rested als je dat hebt).
- [ ] "Doe dit nu" is voller: ook de tips voor beroepen en dungeons staan eronder.
- [ ] Chips: alleen NU (jouw kleur) en LATER (grijs), dezelfde kleuren als de bolletjes.

## 🎨 17 nov — Forever: ruwe versie van ontwerp A (`/mh overview`)

- [x] GEDAAN 17 nov (Rob, Undead Paladin Prot 14): "Ja, ik ben onder de indruk." Opmerkingen → ronde 2 hierboven.

⚠️ Nieuwe bestanden (venster + lettertypes): sluit WoW helemaal af en start opnieuw; `/reload` is niet genoeg.
- [ ] Typ `/mh overview`. Zie je het venster met de mooie letters (sierlijke koppen, zoals de mockup)?
- [ ] Links: je portret in een rondje, je naam, ras · class, en het rode levelzegel met jouw level.
- [ ] "Doe dit nu": een titel, eronder wat je moet doen, daaronder klein de plek. Knop "Show the way": staat de pijl?
- [ ] Binnenkort: de spells van de komende levels met icoon. Class quest: titel, NPC, plek en een eigen knop.
- [ ] Jouw pad: bolletjes met levels. Shift+scroll op het venster maakt het groter/kleiner, Escape sluit.
- [ ] Wat vind je ervan? Wat moet anders? (Screenshot graag.)

## 🔓 17 nov — Forever: knop "Free key" in het macrovenster (jouw keuze B)

- [ ] `/mh macros`: staan de rijen netjes onder elkaar (geen tekst meer over de volgende rij)?
- [ ] Bij "Holy Light" (op toets 5) staat in rood: "Shift+5 is taken by Action Page 5 …" en een knop **Free key**.
- [ ] Klik Free key. Chat: "Shift+5 is free now". Druk Shift+5: krijg je nu Flash of Light?
- [ ] Onderaan staat **Undo freed keys**. Klik: Shift+5 is weer Action Page 5 (of typ `/mh macros keys undo`).

## ⌨️ 17 nov — Forever: werkt Shift/Ctrl/Alt in de handige macro's op je toetsen?

- [x] GEDAAN 17 nov (Rob, paladin 14): Holy Light op toets 5 → "SHIFT-5 is taken by Action Page 5"; Shift+5 deed niets.
      Eat and drink: eet en drinkt tegelijk, geen fout.

Het MH-toetsenblok gebruikt zelf Shift+1, Shift+Q enz. Zet je een MH+-macro met een Shift-deel op toets 1, dan doet
Shift+1 waarschijnlijk de blokknop en niet de macro. Dat meten we nu.
- [ ] Forever-character met het toetsenblok en een paar MH+-macro's op je balken: typ `/mh macros keys`. Per macro zie
      je de toets en bv. "Shift+1 is taken by …" (rood) of "Shift+1 free" (groen). Screenshot graag.
- [ ] Kies één macro met een rode regel en druk de combinatie (bv. Shift+1). Doet hij de andere knop i.p.v. het
      Shift-deel van de macro? Klik je hem met de muis + Shift, dan doet hij wél het Shift-deel?
- [ ] Daarna `/reload` (dan staat de meting in je SavedVariables, `foreverMacroKeysProbe`).

## 🐞 17 nov — Forever: talents komen eerder met de Legacy-perk Talented

MH rekende overal met "eerste talentpunt op level 10". Met de Legacy-perk Talented krijg je ze tot 5 levels eerder.
🔑 **EERSTE TEST (belangrijkst):** op een Forever-character, met én zonder Talented gekocht: `/reload`, dan
`/mh donow check`, en daarna nog een `/reload` (dan staat de meting in je SavedVariables-bestand, onder
`foreverTalentedProbe`: activeEntry, currentRank, ranksPurchased, entryIDs). Zeg wat je rang in het Legacy-venster is.
Daarmee weten we of MH de rang goed leest (DB2 GEMETEN: elke rang is een eigen entry; welk veld de client invult niet).
- [ ] Heb je Talented (deels) gekocht? `/reload`, dan `/mh donow check`: de regel "Legacy perk Talented: rank …" moet
      jouw rang tonen. Staat er "rank nil", dan kan MH hem niet lezen: zeg wat er tussen haakjes staat.
- [ ] Zonder Talented: zegt `/mh donow check` "rank 0" (of "nil")? Zegt hij "rank 1", dan telt MH de eerste trede al
      mee terwijl je niets kocht: zeg het.
- [ ] "Do this now" → "Coming up": het volgende talent staat op het juiste (eerdere) level. Kan MH je rang niet lezen,
      dan staat erachter "tot 5 levels eerder met de Legacy-perk Talented".
- [ ] How you play (`/mh play`): onder de class-tekst een grijze regel over Talented, met jouw rang als MH die leest.
- [ ] Macro's-venster: een talent-macro zegt "(from level X)" met het eerdere level.

## 🆕 17 nov — Forever: Mage class-quests in "Do this now" (jouw class, Rob)

Mage, `/reload`. Uitgezocht met Fable; niets in het spel gezien.
- [ ] Level 10: je eerste staf of orb (Human: Zaldimar Wefhellt, Gnome: Magis Sparkmantle, Orc: Uthel'nay, Troll:
      Un'Thuwa, Undead: Cain Firesong; Skyborne eerst de Windbough Wand op Zephras Isle).
- [ ] Vanaf 6: "Study" bij de bibliothecaris. Eerst zegt MH: breng een bibliotheekboek. Klopt dat?
- [ ] 15 en 26: robe en garment. Orc- of Skyborne-mage: krijg je die quest echt? (Bronnen zijn het oneens.)
- [ ] 30: Mage's Wand en Items of Power (Tabetha, Dustwallow). 35: Celestial Power. 42: A Lesson in Literacy (nieuw).
- [ ] 60: Conjure Water Rank 7 en Polymorph: Pig. Heet jouw pig-quest "Scalebeard" of "Warlord Krellian"?
- [x] Rank-test level 6 (Fireball Rank 2) — GEDAAN 17 nov (Rob, troll mage 6): rank kwam van de trainer, tooltip toont
      Fireball Rank 2. Geen oranje "oude rank"-rand gezien: dit character heeft het toetsenblok (MH-macro's zetten
      zelf de nieuwste rank neer, Rob). Oranje rand zonder toetsenblok: nog niet getest.
- [ ] Level 50 Sunken Temple-quests (druid, hunter, warrior, shaman, paladin, priest, mage): krijg je echt het voorwerp
      dat MH noemt? (Wowhead Forever toont ze; onze lokale speldata-tabel mist ze, dat bewijst niets.)

## 🆕 17 nov — Forever: Paladin class-quests in "Do this now"

Paladin, `/reload`. Uitgezocht met Fable; niets in het spel gezien.
- [ ] Human/Dwarf 12: Redemption. Krijg je een boek (Tome of Divinity), dan zegt "Do this now": gebruik het boek in je
      tassen. Klopt dat, en heet het boek in jouw taal goed?
- [ ] Alliance 20: Verigan's Fist (Duthorian Rall). Na Jordan Stilwell komen ook "Bailor's ore" en "de Kor Gem" in beeld.
- [ ] Alliance 40/60: Warhorse en Charger. Verdwijnt de regel als je het paard hebt? (In Forever is het misschien een
      mount uit je verzameling.)
- [ ] Undead-paladin (nieuw in Forever): Holy Light op 2, Bandarion Keep op 8, Redemption op 12, Wolfsbane op 20,
      Warhorse op 40. Klopt de volgorde van de plekken?
- [ ] Undead 60, Forsaken Charger: staat er nog NIET in (een speler meldt dat de keten vastliep na 97177). Zie je hem in
      het spel, zeg tot waar je kwam.

## 🆕 17 nov — Forever: Priest class-quests (ras-spells) in "Do this now"

Priest, `/reload`. Uitgezocht met Fable; niets in het spel gezien.
- [ ] Level 10 en 20: "Do this now" stuurt je naar de hogepriester van je ras (Human: Laurena in Stormwind, Dwarf: Rohan
      en Gnome: Mims in Ironforge, Night Elf: Alathea in Darnassus, Troll: Ur'kyo in Orgrimmar, Undead: Aelthalyste in
      Undercity). Kreeg je de quest van een andere trainer, dan zegt MH "ga naar …".
- [ ] Heb je je level 10-spell al? Typ `/run print(C_QuestLog.IsQuestFlaggedCompleted(5627), C_QuestLog.IsQuestFlaggedCompleted(5629))`
      (Night Elf) en zeg wat er staat. Verwacht: twee keer true.
- [ ] Level 5-15: "Your first priest robe" (een wacht healen). Na level 15 verdwijnt hij uit "Do this now".
- [ ] Undead level 10: geeft Aelthalyste de Touch of Weakness-quest, of Father Lankester naast haar?

## 🗂️ 17 nov — Forever: uitleg Kamperen en Legacy Points in "How to play"

- [ ] `/mh play`: bovenaan, na "Before you start", twee nieuwe stukken: "Camping" en "Legacy Points". Snap je ze?
  Klopt wat er staat met wat je in het spel ziet (Basic Campfire Kit, Welcoming Campfire, Camp Benefits, de Legacy-knop)?

## 🏛️ 17 nov — Forever: Legacy Points, stap 1 (kan MH je punten lezen?)

- [ ] Typ `/mh legacy`. Staan er getallen bij "earned", "available now", "spent" en "cap per character" (16)? Of
  "? (unreadable)"? Screenshot graag. Kloppen ze met wat Blizzards Legacy-venster zegt?
- [ ] Heb je ongebruikte punten: zegt "Do this now" "You have N unused Legacy Points. Open Legacy…"? Geef er één uit:
  het getal gaat omlaag; bij 0 is de regel weg.
- [x] Eerste meting GEDAAN 17 nov (Rob, account zonder Legacy): camp alles "no" (geen vuur in de buurt = nog geen
  positieve controle; volgende test BIJ een vuur met Camp Benefits aan); legacy earned/available/spent/cap = 0,
  Talented rank 1 → FOUT gevonden: een tiered node wijst zonder aankoop naar zijn eerste vakje (activeEntry 136852,
  maar ranksPurchased/currentRank/activeEntry.rank 0). Gerepareerd: rang telt alleen als er iets gekocht is.
- [ ] Na de fix: `/mh legacy` zegt "Talented rank: 0" en "Legacy not unlocked yet". Talent-levels in "Do this now"
  zijn weer de gewone (niet 1 te vroeg).
- [ ] Daarna `/reload` (dan staat de meting in je SavedVariables).

## 🔥 17 nov — Forever: kamperen, stap 1 (kan MH je kampbuffs lezen?)

- [ ] Typ `/mh camp` ergens zonder vuur. Elke regel zegt "yes", "no" of "? (unreadable)". Screenshot graag.
- [ ] Bij een gewoon kookvuur in de wereld (geen speler-kamp): MH toont GEEN "ga zitten" in Doe dit nu, en `/mh camp`
      zegt "nearby: no". (Sparring 17 nov; je laatste meting in de SV zei nearby=false, maar niet waar je stond.)
- [ ] Zet een kampvuur (of ga bij dat van een ander staan) en typ `/mh camp` nog eens. Staat "nearby" op yes?
- [ ] Nog niet zitten: verschijnt in "Do this now" de regel "There is a campfire near you: sit down…"?
- [ ] Ga zitten. Na 1 minuut: Camp Benefits. Typ `/mh camp`: "benefits" yes, en de "Do this now"-regel is weg.
- [ ] Daarna `/reload` (dan staat de meting in je SavedVariables).

## 🧭 17 nov — Forever: MH gaat opzij voor de Forever Leveling Guide

Jouw keuze: een schakelaar, standaard gaat MH opzij. MH kijkt alleen naar een REISROUTE van de gids (op een plek
klikken, "Travel"), niet naar quest-markeringen of de groene cirkel.
- [ ] Start een reisroute in de Forever Leveling Guide. Klik daarna in MH op "Show the way" (bv. class-quest of trainer).
  Je ziet in de chat: "the Forever Leveling Guide is running a route, so Midnight Helper sets no pin…". De pijl van de
  gids blijft staan.
- [ ] Andersom: start eerst een MH-route, dan een reisroute in de gids. Chat: "…started a route, so Midnight Helper
  stopped its own." NIET meer: "you removed the TomTom arrow".
- [ ] `/mh arrow`: regels "Forever Leveling Guide: reisroute actief ja/nee" en "wijken voor de Forever Leveling Guide".
- [ ] `/mh arrow guide` (of de schakelaar "Step aside for the Forever Leveling Guide" in de instellingen): daarna stuurt
  MH weer zelf, ook naast de gids. Nog een keer typen = terug naar opzij gaan.
- [ ] Zonder reisroute in de gids (alleen quest-markeringen): MH-routes werken gewoon.

## 🌍 17 nov — Forever: rollen in het Duits, Frans, Spaans, Portugees en Russisch

- [ ] Een character op een niet-Engelse client: "How to play" → rollen. Staan ze in jouw taal, met de spellnamen
  van jouw spel? (Niet nagekeken door een moedertaalspreker.)

## 🧭 17 nov — Forever: rollen voor Rogue en Hunter (+ hunter-pet-zin)

- [ ] Rogue of Hunter: open "How to play". Zie je drie rollen? Kloppen de toetsen?
- [ ] Hunter, level 10: leer je Revive Pet pas bij de quest ná het temmen (zoals de tekst nu zegt)?
- [ ] Hunter Survival: krijg je Counterattack op 25 of op 30?
- [ ] Warlock: zie je drie rollen (Affliction, Demonology, Destruction)? Voidwalker: dwingt Torment de vijand echt
  om de Voidwalker aan te vallen (taunt), of trekt hij alleen wat aandacht?
- [ ] Paladin: zie je drie rollen (Holy, Protection, Retribution)?
- [ ] Paladin: staat er bij level 30 nu de waarschuwing dat Divine Intervention (F3 in een gevecht) jezelf doodt?
- [ ] Paladin bij de trainer: kun je op 20 Voice of Truth en op 40 Hammer of the Righteous leren?
- [ ] Shaman: zie je drie rollen (Elemental, Enhancement, Restoration)? Enhancement: hoe lang is de cooldown van
  Stormstrike echt (6 of 8 seconden)? Tooltip kan nog oud zijn, dus graag timen.

## 🧭 17 nov — Forever: rollen per 10 levels voor Warrior, Mage en Priest

In "How to play" staan nu bij deze drie classes, net als bij de druid, per rol: een simpele volgorde, wat je per 10
levels krijgt en 3 beginnersfouten (Engels en Nederlands).
- [ ] Warrior, Mage of Priest: open "How to play". Zie je de rollen (bv. "Protection: tank", "Frost: damage from a
  distance")? Kloppen de toetsen met jouw balken?
- [ ] Priest: krijg je Vampiric Embrace op 25 of op 30?

## 🌍 17 nov — Forever: class-quests in het Duits, Frans, Spaans, Portugees en Russisch

Alle class-quest-regels (warlock t/m mage) staan nu ook in de/fr/es/pt/ru (en een Mexicaans-Spaanse laag). Spelnamen
komen uit Blizzards eigen data per taal. Niet nagekeken door een moedertaalspreker.
- [ ] Een character op een niet-Engelse client: zijn de namen in "Do this now" die van jouw spel? Klinkt de zin goed?
- [ ] Spaans/Russisch: bij de shaman-fakkel staat "Eternal Flame" nog Engels. Hoe heet die vlam in jouw spel?

## 🆕 17 nov — Forever: Shaman, nagekeken door Fable (gerepareerd + twijfels)

Gerepareerd: Elemental Mastery vanaf 50 (was 52); Air Totem verdwijnt nooit uit "Do this now"; Skyborne Earth vanaf 3;
ritueel-tekst (fakkel gebruiken, Olariaan loopt nergens heen); Kuramaa (alleen vuur doet schade); waterzakken (put van
Tarren Mill, fontein, meer onder Hervdana's grot). Twijfels voor het spel:
- [ ] Level 50 Sunken Temple-quests (alle classes): krijg je alle beloningen of kies je er één? MH zegt nu neutraal
      "voorwerpen als beloning".
- [ ] Dwarf-shaman Earth: met de quest "Find Teo" (96243) i.p.v. 98581 — kun je bij Teo dan verder, of mis je de Archaic Rune?
- [ ] Water: verschijnt de water-geest pas na een tijdje (Silverpine en Westfall)? Dan voegen we een wacht-zin toe.
- [ ] Skyborne (Windshaper) en Elemental Mastery bij Bath'rah: krijg je die quest?

## 🆕 17 nov — Forever: Shaman class-quests (totems) in "Do this now"

Shaman, `/reload`. Niets in het spel gezien.
- [ ] Level 4: Earth-totem-quest (Orc/Troll: Canaga Earthcaller, Tauren: Seer Ravenfeather, Dwarf: Sten Stoutarm,
      Skyborne: Rorian the Dayseeker). Bij de Sapta-stap: blijft de regel staan tot je met de geest gepraat hebt?
- [ ] Level 10: Fire. Level 20: Water. Level 30: het Air Totem. Horde 52: Bath'rah (Elemental Mastery).
- [ ] Bij een vuurpot (Brazier of the Dormant Flame) zegt de regel de naam van die pot in jouw taal?
- [ ] Dwarf-shaman, Water: kloppen de drie waterzak-plekken (Wetlands onder de waterval, Stonewatch Falls in Redridge,
      het meer bij Astranaar)? Ze komen uit één gids; twee gidsen verschillen een paar punten.
- [ ] Portugese client: heet de Earth-trainer van de Orcs echt "Ranago Arauto da Terra"? En Windshaper Boro?

## 🆕 17 nov — Forever: Hunter en Rogue class-quests in "Do this now"

Uitgezocht met Fable; uit Zygor, Wowhead en Spoken; niets in het spel gezien. `/reload`.
- [ ] Hunter level 10: drie keer "Taming the Beast" bij je trainer (Night Elf: Dazalar, Dwarf: Grif Wildheart, Human:
      Josephine Carson in Goldshire, Orc/Troll: Thotar, Tauren: Yaw Sharpmane, Skyborne: Quel'ana Quickgale). Elke keer
      wijst de pijl naar het beest dat je moet temmen. Daarna "Training the Beast" naar de pet-trainer.
- [ ] Human-hunter: leer je met die nieuwe quests ook echt Tame Beast en Beast Training? (Wowhead noemt "Taming Lesson".)
- [ ] Hunter 50: The Hunter's Charm (Ogtinc in Azshara).
- [ ] Rogue 10: Blade of Cunning per ras. Rogue 16: Thieves' Tools. Rogue 20: Poisons (Alliance: Mathias Shaw, Horde:
      Shenthul). Wordt de regel weg als je Poisons kent?
- [ ] Rogue 23 en 30 (nieuw in Forever): de Dead Drop in Silverpine. Na de eerste opdracht zegt "Do this now": wacht op
      een brief van C. Klopt dat, en hoe lang duurde het?
- [ ] Skyborne-rogue (Alliance): stuurt MH je naar de Human-route (Keryn Sylvius)? Is dat goed?

## 🆕 17 nov — Forever: Druid, nagekeken door een tweede helper (Fable)

Drie tekstfouten zijn hersteld (Horde-druid: geen grot bij Lunaclaw; Moonfire pas op 4; terug IN Moonkin Form kost
mana). Deze punten kan alleen het spel beslissen (Carola of Rob):
- [ ] Horde-druid, Bear Form-quest bij Lunaclaw: staat de Moonkin Stone buiten, achter het eerste hutje (Barrens 42.0, 60.9)?
- [ ] Cat Form: waar staat de Great Cat Spirit precies? Wij wijzen 54.5, 75.0 in Moonglade (Wowhead Forever); oude sites
      zeggen 58.4, 73.5.
- [ ] Spaanse client: heet Gennia "Gennia Runatótem" of "Gennia Tótem de Runa"?
- [ ] Aquatic Form: heeft alleen de Agility-helft van het hangertje een "Use"? (Dan klopt "gebruik een half hangertje" maar half.)
- [ ] Enrage: 27% minder armor in Bear Form, maar in Dire Bear Form 16%?
- [ ] Balance-opener Starfire en de Cat-opener Ravage vanaf 32: de gidsen zijn het oneens; voelt het goed?

## 🆕 17 nov — Forever: Warrior class-quests in "Do this now"

Warrior, `/reload`. Uit Zygor, Wowhead en Spoken; niets in het spel gezien.
- [ ] Level 10+: Defensive Stance-quest van je ras. Human: Lyria Du Lac (Elwynn) → Harry Burlguard → Bartleby (vecht).
      Dwarf/Gnome: Granis Swiftaxe → Muren Stormpike (Ironforge). Night Elf: Kyra Windblade → Elanaria (Darnassus).
      Orc/Troll: Tarshaw Jaggedscar, Tauren: Krang Stonehoof → Uzzek (Barrens). Undead: Austil de Mon → Dillinger.
      Skyborne: Seena Skybreaker (Zephras Isle).
- [ ] Skyborne-warrior: leer je met die quest ook Taunt en Sunder Armor, of alleen Defensive Stance? Na de quest:
      `/run print(IsPlayerSpell(71), IsPlayerSpell(355), IsPlayerSpell(7386))` — drie keer true = alle drie.
- [ ] Neem je de route van een ander ras (bv. Night Elf-warrior in Goldshire), dan volgt "Do this now" die route.
- [ ] Whirlwind: telt MH de charms goed (pas klaar bij 8 van elk)? En The Affray heeft een tijdslimiet: zag je die?
- [ ] Level 30+: The Affray (Klannoc Macleod, Fray Island). Pas daarna noemt "Do this now" het Whirlwind-wapen.
- [ ] Bij The Affray: blijft de regel op "step on the grate …" staan tot alles klaar is, en zegt hij dan "go to Klannoc"?
- [ ] Level 50+: The Fallen Hero (Swamp of Sorrows).

## 🆕 17 nov — Forever: Warlock class-quests in "Do this now"

Warlock, `/reload`. Alles komt uit Zygor, Wowhead en de addon Spoken; niets is in het spel gezien.
- [ ] Nieuwe warlock (level 1-9): "Do this now" noemt de eerste quest van je ras (Human: Drusilla La Salle, Gnome: Alamar
      Grimm, Orc/Troll: Ruzan, Undead: Venya Marthand). Ken je de Imp al, dan staat er niets over de Imp.
- [ ] Level 10+: Voidwalker-quests. Human begint bij Remen Marcot (Goldshire), Gnome bij Lago Blackwrench (Ironforge),
      Orc/Troll bij Ophek (Razor Hill), Undead bij Ageron Kargal (Brill). Wijst "Show the way" de goede plek aan?
- [ ] Level 20+: Succubus én Incubus (je kunt ze allebei halen). `/mh play` → "Your class quests" toont ze apart.
- [ ] Level 30+: Felhunter (Strahad Farsan in Ratchet). Level 40+: Felsteed. Level 60: Dreadsteed.
- [ ] Troll-warlock op 20, 30 en 40: biedt Orgrimmar je de quest echt aan? (Wowhead noemt alleen Orc en Undead.)
      📝 17 nov: MH stuurt een troll daar nu NIET meer heen (keuze bouwchat na de Fable-controle). Zie je de quest wel,
      zeg het: dan zetten we het terug. `/mh classquest` met een troll van 20+ helpt.
- [ ] Warlock 50: Inferno via Niby the Almighty en Impsy (Felwood). Ritual of Doom (60) staat er nog niet in.
- [ ] Dreadsteed (60): heb je bij Mor'zul drie quests tegelijk, dan noemt "Do this now" ze één voor één (eerst de
      elixirs). Pas als alle drie ingeleverd zijn, komt Arcanite.
- [ ] Twijfels (Fable-controle): geeft Martha Strain (Undercity) de Dreadsteed-start, of alleen Kurgul? Valt de Withered
      Scarf echt ongeveer 1 op 20? Avelina's/Isaac's Heart: moet je iemand verslaan? Moet je voor Lord Banehollow een
      Shadowy Potion drinken?
- [ ] Item-ketens (wapens, sieraden) verdwijnen uit "Do this now" als je meer dan 10 levels voorbij hun start bent;
      `/mh classquest` zegt dan waarom. Voelt 10 goed?
- [ ] Duitse/Franse/Spaanse/… client: NPC-namen in je eigen taal (stap-teksten nog Engels, vertaling volgt).
- [ ] `/mh classquest`: per quest "done / in log / complete". Klopt dat met je questlog?

## 🆕 16 nov (nacht, 2) — Forever: druid-quests in je eigen taal + Skyborne

- [ ] Duitse/Franse/Spaanse/… client: in "Do this now" staan de NPC-namen zoals jouw spel ze toont (bv. Spaans
      "Mathrengyl Garroso", Russisch "Матренгил Медвежья Лапа"). Engelse client: niets veranderd.
- [ ] Skyborne-druid op level 10: "Do this now" stuurt je naar Lotheluum Starbreeze en Urs'endris op Zephras Isle (niet
      naar Darnassus/Thunder Bluff). Op 20: Cat Form via de Avatar of Saeyleenan in Moonglade.
- [ ] Night Elf/Tauren-druid: nog steeds de gewone Bear- en Cat-quests (niets van Skyborne).

## 🆕 16 nov (nacht) — Forever: Druid per rol in How you play

Druid, `/reload`, `/mh play`:
- [ ] Met een richting (bv. Feral): bovenaan "Bear: tank" en "Cat: damage up close" helemaal; daaronder "Other roles"
      met alleen de namen (Balance, Restoration).
- [ ] Knop "All roles" rechtsboven (naast de richting-knop): klik → alle vier de rollen; de knop heet dan "My role".
      Staat de knop niet over de titel heen?
- [ ] Zonder richting: alle vier ingeklapt; de knop klapt ze uit en heet dan "Fold up".
- [ ] Kloppen de toetsen in de volgordes met je balk (bv. Maul op 1, Growl op F)?

## 🆕 16 nov (laat) — Forever: Druid, meer class-quests (Cure Poison, Aquatic Form, Torwa)

Druid, `/reload`:
- [ ] `/mh play`: bovenaan (onder je richting) een blok "Your class quests" met per quest-keten het level, de naam en
      "Done." / "Now: …" / "Later. It starts at …".
- [ ] Level 14+, Bear Form klaar, Cure Poison nog niet: "Do this now" noemt de Cure Poison-quest; na elke stap schuift hij
      door (sampler, paddenstoelen of kodo-hoorns, Earthroot, zieke herten of gazelles). Bij Earthroot geen pijl, alleen de regel.
- [x] Level 16+: Aquatic Form. Eerst de mand onder water, dan het altaar, dan Tajarri, dan twee kistjes onder water
      (A: Darkshore + Westfall, H: Silverpine + Barrens), dan het hangertje bij het altaar.
      ✅ Rob (Druid 16, Horde), 26 nov avond, via Sparring: tijdens het spelen *"wij doen het op dit moment beter dan
      polestar met de aqua class quest :)"*, en na afloop *"de aqua keten is goed :)"*. Alliance-kant niet gespeeld.
- [ ] Level 20+: Cat Form (nieuwe Forever-quest, niet in Zygor). Trainer → Dendrite → Great Cat Spirit (heuvel boven de
      brug, Moonglade) → drie relikwieën in de Stormrage Barrow Dens (Claw, Fang, Silent Shadow) → geest → Dendrite →
      trainer. Wijst de pijl ongeveer naar de goede plek? (De plekken komen van Wowhead, niet uit het spel.)
- [ ] Ken je Teleport: Moonglade, dan staat bij een plek in Moonglade "(Teleport: Moonglade in your spellbook …)".
- [ ] `/mh classquest`: per quest "done / in log / complete" en per stap true/false. Klopt dat met je questlog?

## 🆕 16 nov (avond) — Forever: Druid, Bear Form-quest stap voor stap (eerst Carola)

Druid van level 10+ die Bear Form nog niet heeft, `/reload`:
- [ ] "Do this now" heeft een regel "Bear Form (from level 10), class quest: get the quest from … / go to … / talk to the
      Great Bear Spirit …", met een knop "Show the way". Klik: de pijl wijst de plek aan.
- [ ] Na elke stap (quest aannemen, gesprek met de geest, Lunaclaw, inleveren) schuift de regel door naar de volgende plek.
- [ ] Na het inleveren van Body and Heart (Bear Form geleerd): de regel is weg.
- [ ] `/mh classquest` zegt per quest "done / in log / objective done" en welke stap MH kiest. Klopt dat met je questlog?
      (Quest-nummers komen uit Zygor en zijn pas zeker als het spel ze afvinkt.)

## 🐞 16 nov (nacht) — Midnight-test camera + "You are 90" (Rob via sparring, screenshots)

📝 `/mh camera` gaf "… back to 1.900000 when off" terwijl Robs account al op 2.6 stond (Details). Fout GEMETEN in de
code: bij "aan" onthield MH de oude waarde niet als die al 2.6 was → "uit" zou 1.9 zetten. Gerepareerd: altijd de waarde
van vóór "aan" onthouden; getallen als "1.9". "You are 90"-venster (`/mh maxlevel popup`): tekst en knoppen passen ✅.
Macrovenster Elemental Shaman: Wind Shear zonder modifier → terecht geen gele regel.
- [ ] Midnight, account op 2.6: vinkje "Camera further away" aan en weer uit → `/mh camera` zegt "off … now 2.6" (blijft
      jouw 2.6, niet 1.9).
      📝 Rob, 16 nov (via sparring, screenshot, 5.4.0): "Camera further away: off. The game's zoom limit is now 2.6 (on =
      2.6; back to 2.6 when off)." → eigen 2.6 blijft, getal netjes. Rob vinkt zelf af.

## 🐞 16 nov (nacht) — melding "upgrade in je tas" bij zelfgemaakte spullen (onderzoek)

Rob (via sparring): gecrafte blacksmithing- en leather-items gaven geen melding; `/mh pickup` noemde alleen een Skinning
Knife. Oorzaak NIET gemeten: MH onthield maar één beslissing. Nu onthoudt hij de laatste 10.
- [ ] `/reload`, maak één stuk uitrusting met een beroep, typ meteen `/mh pickup`. Onder "last 10" staat wat er in je
      tas kwam en wat MH besloot (bv. "not better", "red line …", "shown"). Staat het gemaakte item er NIET bij, dan ziet
      MH het craften helemaal niet → screenshot naar de bouwchat.
📝 Uitslag Rob (via sparring, shaman, screenshot): "You create: [Handstitched Leather Pants]" → "Upgrade in your bags: … +31
Armor …" + de pop-up; `/mh pickup`: "last item: [Handstitched Leather Pants]: shown". Craften wordt dus WEL gezien
(GEMETEN). De eerdere gemiste meldingen waren waarschijnlijk "not better", overschreven door de Skinning Knife
(AFGELEID). Geen reparatie nodig. De lijst "last 10" verschijnt pas vanaf 2 regels (zo gebouwd, GEMETEN in de code);
na één item na een /reload zie je dus alleen "last item".

## 🆕 16 nov (nacht) — Forever: "Best stats for you now" in "Do this now"

📝 Waarneming Rob, 16 nov (via sparring, screenshots, 3 characters) — richting → boom klopte bij alle drie:
Paladin 14, richting 2 = Protection → rol tank, "Stamina, then Strength" (tank-regel gelijk, dus geen tweede regel);
Mage, richting 2 = Fire → "Intellect and Spirit count the same. Equal? Take the one with more Stamina.";
Shaman, richting 1 = Elemental → "Intellect, then Spirit. Equal? …". Overal "new spells on no bar: none; key block
placed: true". Andere classes/bomen nog niet gezien. Rob vinkt zelf af.

📝 Waarneming Rob (via sparring): *"ik heb mijn keyblock staan dus de regel bleef keurig weg"* — "New, but on no bar yet"
kwam niet, zoals bedoeld. De regel zelf (zonder toetsenblok) nog niet gezien.
- [ ] "Do this now" (`/mh donow`): onderaan bij de tips "Best stats for you now: …". Klopt het met je richting? (bv.
      Frost-mage: "Intellect and Spirit count the same. Equal? Take the one with more Stamina.")
- [ ] Warrior, Paladin of Druid: een tweede regel "When you tank: Stamina, then …".
- [ ] `/mh donow check`: regel "stats: class …, role …, from direction N (boomnaam); order …". Is de boomnaam de juiste
      voor je gekozen richting? (De volgorde van de bomen is AFGELEID.)
- [ ] Muis op uitrusting: de groene regel "MH: +3 … over what you wear" volgt nu dezelfde stats (bv. een Resto Shaman
      ziet Intellect, niet meer Strength).

## 🆕 16 nov (nacht) — vuurwerk bij een level-up (Midnight én Forever)

📝 Waarneming Rob, 16 nov (via sparring, spel niet gezegd, AFGELEID Forever): *"firework werkt maar het geluid is een
tik, maar wow zelf geeft natuurlijk al een DING geluid dus geluid is niet nodig en mag weg"* → geluid + schakelaar weg.
- [ ] `/mh fireworks test`: drie korte bossen gekleurde sterretjes, ±2,5 s, nu ZONDER geluid. Klik je er doorheen?
- [ ] Echt een level omhoog (buiten een gevecht): het vuurwerk komt vanzelf. In een gevecht: pas na het gevecht.
- [ ] Opties → Midnight Helper: alleen nog "Fireworks when you level up" (geen geluid-schakelaar meer); uit → geen vuurwerk.
- [ ] Midnight, 89 → 90: eerst het vuurwerk, daarna (na ±3 s) het venster "You are 90 now".

## 🆕 16 nov (nacht, laatst) — Forever: mouseover ook voor blessings en Arcane Brilliance

`/mh mouseover on`, toetsenblok neergezet:
- [ ] Paladin, solo: muis op een voorbijganger, Shift+Z/X/V → Blessing of Might/Kings/Wisdom gaat naar hem, niet naar
      jou. Zonder iemand onder de muis: zoals altijd.
- [ ] Paladin in een groep: zelfde toetsen geven de Greater-versie op wie onder je muis staat.
- [ ] Mage met Arcane Brilliance (level 56): Shift+X op iemand onder de muis.

## 🆕 16 nov (nacht, laat) — Forever: nieuwe spell op geen balk + twee tooltipregels

📝 Waarneming Rob, 16 nov (via sparring, mage ~lvl 4, na /reload): bij de trainer vuurde het seintje voor elke nieuwe
spell ("LEARNED_SPELL_IN_SKILL_LINE 5504 Conjure Water false", "… 116 Frostbolt false"). Nog open: een nieuwe RANK
(kan pas op lvl 6), en of "Do this now" de regel "New, but on no bar yet" liet zien (niet gezien). Geen "key block
updated" in de chat: AFGELEID dat dit character geen toetsenblok heeft.

- [ ] Toetsenblok NIET neergezet. Leer bij de trainer een nieuwe spell (geen nieuwe rank). "Do this now" zegt: "New, but
      on no bar yet: <spell>. Drag it …". Sleep hem op een balk: de regel verdwijnt. Met een lagere rank al op een balk
      komt deze regel niet (dat is de oranje rand van "oude rank").
- [ ] Met het toetsenblok neergezet: geen regel (het blok vraagt het zelf). `/mh donow check` zegt welke spells op geen
      balk staan en of het blok staat.
- [ ] Muis op plate, mail, een schild of een wand die jouw class NOOIT kan gebruiken: rode regel "MH: a Mage can never
      use this." Op iets dat je pas later mag (bv. mail voor een hunter vóór 40): geen MH-regel.
- [ ] Muis op een quest-item (bv. Riptear's Heart): gele regel "MH: needed for your quest "Rear Guard Patrol" (0/1)".
      Johaan's Findings: "MH: needed for your quest "Delivery to Silverpine Forest"." Is de quest klaar: geen regel.
- [ ] `/mh usedfor`: onderaan "class/quest lines: item …" met wat MH besloot bij het laatste item.

## 🧪 16 nov (nacht) — drie metingen in Forever, vóór we 1-3 bouwen (plak elke regel in de chat, screenshot de uitvoer)

- [x] **Nieuwe spell** — GEDAAN 17 nov (Rob, troll mage 6, screenshots via sparring): het seintje vuurt OOK voor een
      nieuwe RANK ("LEARNED_SPELL_IN_SKILL_LINE 143 Fireball false" na "You have learned a new spell: Fireball (Rank 2)");
      eerder 1296017 Comprehend Scroll, 587 Conjure Food, 2136 Fire Blast (alle false). Regel was:
      `/run local f=CreateFrame("Frame") f:RegisterEvent("LEARNED_SPELL_IN_SKILL_LINE") f:SetScript("OnEvent",function(_,e,id) print(e,id,C_Spell.GetSpellName(id),C_Spell.IsSpellPassive(id)) end)`
- [x] **Quest-doelen** — GEDAAN 16 nov (Rob, screenshot via sparring, Engelse client): item-doelen komen als type
      "item" met tekst "0/N <itemnaam>" (bv. "item 0/1 Riptear's Heart", "item 0/1 Dargol's Skull"); monsters als
      "monster 0/8 Wailing Ancestor slain"; leveren als "log". Andere talen: niet gezien. Regel was:
      `/run for i=1,C_QuestLog.GetNumQuestLogEntries() do local q=C_QuestLog.GetInfo(i) if q and not q.isHeader then for _,o in ipairs(C_QuestLog.GetQuestObjectives(q.questID) or {}) do print(q.title,o.type,o.text) end end end`
- [x] **Tooltip-regels** — GEDAAN 16 nov (Rob via sparring; Baganator, dus een eigen /run over alle tassen op classID
      12): Johaan's Findings → "Quest Item" / "Unique" / omschrijving. Blizzard zegt dus NIET voor welke quest. De bijbehorende
      leverquest heeft geen item-doel; de naam staat in het "log"-doel ("Take Apothecary Johaan's findings to …", kleine f).
      Kale GetItemInfoInstant gaf "attempt to call a nil value", C_Item.GetItemInfoInstant werkte. Regel was:
      `/run local d=C_TooltipInfo.GetBagItem(0,1) for i,l in ipairs(d.lines) do print(i,l.type,l.leftText) end`

## 🆕 16 nov (nacht) — kleine ideeën: toetsenblok-knoppen, gids-paneel, "Je bent 90"

Forever, venster "Your key block" (`/mh block`):
- [ ] Rechtsboven raken "Dock to window" en "New spells: ask me" elkaar niet meer. Ook "Show bars 2 and 3" (als die er
      staat) botst niet met "Getting started".
- [ ] Het paneel "Getting started, step by step" erboven is dicht: de gele buff-zin ("… is not on you") schijnt er niet
      meer doorheen.
Midnight (retail):
- [ ] `/mh maxlevel` → zegt voor dit character wat MH zou doen (bv. "already at the top level: it only shows at the
      moment you reach it").
- [ ] `/mh maxlevel popup` → het venstertje "You are 90 now. What next?" met de knoppen "My gear", "Later" en
      "Start Here". "My gear" opent "My gear: what now?", "Start Here" opent Start Here. Passen de knoppen?
- [ ] Echt: een character dat 90 wordt krijgt het één keer vanzelf, een paar seconden na het level-up-geluid (niet in
      een gevecht; dan na het gevecht). Een tweede keer niet.

📝 **Waarneming Rob, 16 nov (later), Forever, via sparring.** Letterlijk: *"ja gevonden en werkt :)"* (het camera-vinkje,
onder On-screen buttons) en *"1 t/5 werken goed"* voor: 1 camera + `/mh camera` (Forever houdt 4), 2 Screens + de
opgeruimde opties, 3 kaartje "Dungeons in Forever", 4 de gele Self Cast-regel (weg met Self Cast op "Auto"), 5 de
wapensteen (knop weg na de klik, terug na 30 min). ⚠️ AFGELEID dat "terug na 30 min" en "weg met Auto" in zijn "goed"
zitten; niet apart nagevraagd. Midnight-kant van deze punten: niet gezien. Rob vinkt zelf af.

## 🆕 16 nov (laat) — Forever: buffknop voor steen, olie of poison op je wapen

📝 Waarneming Rob, 16 nov (via sparring, op zijn screenshots, ~level 12; Rob vinkt zelf af): de /run-regel gaf
"function … 1 function …" = de oude GetWeaponEnchantInfo bestaat, loadDeprecationFallbacks = 1, en
C_Item.GetWeaponEnchantInfo bestaat ook. Mace in de hand: geen steen aangeboden. Zwaard: de knop toont de Rough
Sharpening Stone met de juiste zin, en Rob: *"en de knop werkt"* (de klik zet de steen erop). Nog niet gezien: knop weg
na het klikken, `/mh buffs`, de 30 minuten, weightstone op de mace, rogue en shaman.

Op een Forever-character met een Rough Sharpening Stone in de tas en een zwaard, bijl of dolk in je hand:
- [ ] Eerst één regel, dan weten we welke manier van uitlezen werkt:
      `/run print(GetWeaponEnchantInfo, C_CVar.GetCVar("loadDeprecationFallbacks"), C_Item.GetWeaponEnchantInfo)`
- [ ] Zonder iets op je wapen: de buffknop toont de steen, met eronder "Nothing on your main-hand weapon yet: Rough
      Sharpening Stone is in your bags. Click the icon to put it on."
- [ ] Klik (buiten een gevecht): zet hij de steen meteen op je wapen (3 seconden casten), zonder dat je zelf nog op het
      wapen hoeft te klikken? Daarna verdwijnt de knop.
- [ ] `/mh buffs`: onderaan "weapon items … read via …", per hand het wapentype en de beslissing.
- [ ] Een knots of staf in je hand: de Rough Sharpening Stone wordt NIET aangeboden (die past niet). Met een Rough
      Weightstone wel.
- [ ] Als de steen na 30 minuten afloopt: komt de knop vanzelf terug?
- [ ] Rogue met poisons (vanaf level 20): main hand en off hand allebei, de knop biedt eerst main hand aan, het kleine
      icoontje ernaast off hand.
- [ ] Shaman met een steen: eerst de Shaman-spell voor je main hand (die kost niets), geen steen voor de main hand.

## 🆕 16 nov (avond) — Forever: opties opgeruimd + waarschuwing Self Cast Key

Op een Forever-character, Options → AddOns → Midnight Helper:
- [ ] De koppen "Dungeon help" en "Vault" staan er niet meer. Onder "Gear" staat alleen nog "Notice when an upgrade lands
      in your bags" (aan). Zet hem uit, pak een betere uitrusting op: geen melding. Weer aan: wel een melding.
- [ ] Weg zijn o.a.: party targets, Death Recap, action prompt, dispel alert, rare alerts, toasts, openables-knop, Codex-tip,
      "I mostly play solo", Leveling Guides. Mis je er een die je in Forever wél gebruikte? Zeg het.
- [ ] In Midnight (retail): de pagina is precies als eerst (alle koppen er nog).
- [ ] Macrovenster (`/mh macros` of het kaartje "Macros"): bij macro's met een toets én mouseover staat een gele regel
      "Your Self Cast Key is ALT …". Bij macro's zonder mouseover niet. Zet in de opties "Self Cast" op "Auto" (nu staat
      hij op "Auto and Key Press"), open het venster opnieuw: is de gele regel weg? (Zo meten we of "Auto" de toets echt
      uitzet; de lijst "Self Cast Key" zelf heeft geen "None".) Daarna mag je hem terugzetten zoals jij wilt.

~~De 11 "weet niet"-schakelaars~~ — **VERVALLEN op Robs woord, 16 nov** (via sparring, letterlijk: *"laat deze tests maar
achterwege, mocht iemand het melden dan is het vroeg genoeg"*). De 11 blijven staan zoals ze zijn; alleen bij een
melding van een speler kijken we weer. De regels hieronder blijven als naslag, niet als open punt:
- [ ] **Dangerous cast warning** (+ cast bars, speak cast name, only "important"): vijandelijke naamplaatjes aan, typ
      `/mhcsdebug`, vecht met een vijand die spells cast. Zie je per cast een chatregel, en een icoon als de cast op
      jou gericht is? Cast bars aan: komt er een balk? Uitspreken aan (in een gevecht): hoor je de naam? "Only important"
      aan: blijft alles stil? Daarna `/mhcsdebug` weer uit.
- [ ] **Count which spells you press**: na 5+ casts in een gevecht `/mh presses why`. Lege lijst = werkt niet in Forever.
- [ ] **Say where a new ability goes** (+ popup): toetsenblok NIET neergezet, leer een nieuwe spell bij de trainer. Komt
      er binnen een paar seconden een chatregel (of popup)?
- [ ] **Let WaypointUI drive the arrow**: staat WaypointUI in je Forever-addonlijst? Zo nee: deze doet niets.
- [ ] **Keep key 1 for the Assisted Combat button / mouse buttons (3)**: `/mh apply` in Forever. Geeft hij een plan? Zo ja:
      verandert het plan als je de schakelaar omzet?

## 🆕 16 nov (middag) — Forever: kaartje "Dungeons" + Screens zonder "TAB_CODEX: Basics"

Op een Forever-character:
- [ ] MH-venster → kamer "Me": er staat een kaartje "Dungeons in Forever" (icoon met een dungeon-poort). Klik: de
      dungeonlijst gaat open. Muis erop: "Which dungeons fit your level …".
- [ ] Options → AddOns → Midnight Helper → Screens: de regel "TAB_CODEX: Basics" is weg. Ook in MH's eigen Settings → Screens.
- [ ] Midnight (retail): onder Codex staat "Codex: Basics" nog gewoon.
- [ ] Alleen met een Paladin of Priest die Blessing of Protection / Power Infusion heeft: macro uit het MH-macrovenster,
      muis op een groepslid ZONDER toets → gaat hij naar dat groepslid? Met Alt erbij → naar jezelf? (Self Cast Key = ALT.)

## 🆕 16 nov — Forever: lijst "Screens" opgeschoond

Op een Forever-character:
- [ ] Options → AddOns → Midnight Helper → Screens: staan er nu alleen schermen die je in Forever ook in de zijbalk of
      de kamers ziet? Geen Delves & Vault, Rares, Trading Post, Tier Sets meer, en geen TAB_START_HERE / TAB_OMNIUM.
- [ ] Zelfde lijst in MH's eigen venster (Settings → Screens).
- [ ] Een vinkje weghalen werkt nog: dat scherm verdwijnt uit de zijbalk/kamers. Vinkje terug: het komt terug.
- [ ] In Midnight (retail): de lijst is hetzelfde als eerst (alle schermen staan er nog).

## 🆕 16 nov — schakelaar "Camera verder weg" (Midnight én Forever)

Eerst, in elk spel één keer (zo zien we of het spel de waarde houdt):
`/run C_CVar.SetCVar("cameraDistanceMaxZoomFactor","4") print(C_CVar.GetCVar("cameraDistanceMaxZoomFactor"))`
→ welk getal print hij? (Midnight verwacht: 2.6 of 4; Forever: 4?) Daarna gewoon verder:
- [ ] `/mh camera` → een regel met "off", de huidige zoomgrens en wat "on" zou zetten (Midnight 2.6, Forever 4).
- [ ] Options → AddOns → Midnight Helper: vinkje "Camera further away" aanzetten. In chat: "zoom limit set to …, the
      game now reads …". Scroll uit met je muiswiel: kun je verder uitzoomen dan eerst?
- [ ] Muis op het vinkje: de uitleg zegt dat de camera niet vanzelf uitzoomt.
- [ ] Vinkje uit: de oude afstand komt terug (`/mh camera` laat het getal van daarvoor zien).
- [ ] In een gevecht aanzetten (`/mh camera on`): "you are in combat, so this waits", en na het gevecht komt de regel
      met het nieuwe getal.
- [ ] Forever: zet Blizzards eigen schuif "Max Camera Distance" terug, `/reload`: staat hij weer op 4 (`/mh camera`)?

## 🆕 15 nov — Forever: dungeonlijst per zone + vinkje "alleen voor mijn level"

Op een Forever-character, `/mh dungeons` (of de knop "Dungeons" in "Do this now"):
- [ ] Bovenaan staat een vinkje "Only dungeons for my level (also up to 2 levels higher) …", en het staat AAN.
- [ ] Je ziet kopjes per zone: "[-] zonenaam (aantal dungeons)". Alleen zones met iets voor jouw level staan er.
- [ ] Klik op een kopje: het klapt dicht ([+]). Nog een klik: weer open.
- [ ] Een dungeon die 1 of 2 levels te hoog is, staat er oranje bij met "(+1)" of "(+2)" achter het level. Groen = past nu.
- [ ] Haal het vinkje weg: nu staan ALLE zones er, de lage eerst. Alleen de zones met iets voor jou staan open, de rest
      is dicht.
- [ ] `/reload` en open het venster weer: je keuze (vinkje aan of uit) is onthouden.
- [ ] Laag character (onder level 11), vinkje aan: er staat een regel dat er nog geen dungeon past.
- [ ] `/mh dungeons check`: een regel "window: shows only the ones for your level …" met de "net te hoge" dungeons.
- [ ] Schuift het venster nog met Shift+scroll groter/kleiner, en past de onderste tekst?
- [ ] De kolom "Entrance" toont nu de plek als getallen (bv. "42.5, 71.7"), niet meer de zonenaam. Muis op "Route" noemt
      de zone nog wel.

## 🆕 15 nov (avond) — Forever: "geen XP" als iemand meer dan 12 levels boven de vijanden zit

Alleen met een groep waarin één speler veel hoger is (bv. je level-60 vriend helpt je level-20 alt):
- [ ] Groepspaneel (`/mh partytargets`): neem een vijand als doelwit die meer dan 12 levels lager is dan de hoogste in
      de groep. Onder het paneel staat een rode regel "No XP for this enemy: … more than 12 levels above it …".
      Doelwit weg of een vijand dichterbij: de regel verdwijnt.
- [ ] In een dungeon die veel te laag is voor de hoogste: zonder doelwit staat er "Probably no XP here: …".
- [ ] `/mh dungeons` in die groep: dungeons waar de hoogste meer dan 12 levels boven het maximum zit, hebben een rood
      `*`, en onderaan staat wat het betekent.
- [ ] `/mh dungeons check` → een regel "no-XP rule (> 12 levels …): top of group …".
- [ ] Klopt het met wat je echt krijgt? (Blizzard: 12 levels hoger geeft nog XP, 13 niet.)

## 🆕 15 nov (avond) — Edit Mode-back-up kent zijn spelversie

- [ ] Midnight: zet het toetsenblok neer en haal het weer weg ("Your key block" → terug). Werkt het terugzetten nog
      gewoon? (Zelfde spelversie, dus het mag NIET geweigerd worden.)
- [ ] Na de patch 12.1.7 (2 dec): een oude back-up terugzetten moet een oranje regel geven: "This copy of your layout
      was made on another game version …" en niets veranderen.
- [ ] Na 12.1.7: het Codex-artikel over de Aqir Invasions is weg.

## 🆕 15 nov (middag) — Forever: uitnodiging voor de Forever-vragenlijst

Op een Forever-character:
- [ ] `/mh survey` → een venster met de link `https://midnighthelper.com/survey/forever/?from=game` (Nederlands:
      `/nl/survey/forever/`). Ctrl+C, plakken in de browser: opent de Forever-vragenlijst?
- [ ] `/mh survey why` → zegt hoeveel dagen MH al gebruikt is ("used on 1 day(s), the popup waits for 2").
- [ ] `/mh survey popup` → de pop-up met "Show the link" / "Later" / "No thanks". Klopt de tekst?
- [ ] Morgen (tweede dag), ongeveer een minuut na het inloggen: komt de pop-up één keer vanzelf? Niet in een dungeon.

## 🆕 15 nov (middag) — talen: Renown, Raid, Great Vault en Dungeon in het woord van het spel

Alleen met een buitenlandse client (of Cisca):
- [ ] Duits: "Schlachtzug" in plaats van "Raid", "Schatzkammer" in plaats van "Vault" (bv. "Vault: Dungeons" →
      "Schatzkammer: Dungeons" in de accountoverzicht-kolommen). "Dungeon" blijft, want het Duitse spel zegt dat ook.
- [ ] Frans "chambre forte" / "donjon", Spaans "Gran cámara" / "mazmorra" / "Banda", Mexicaans "Gran bóveda" /
      "calabozo", Portugees "Grande Cofre" / "masmorra" / "Raide", Italiaans "Gran Banca" / "spedizione" / "Incursione".
- [ ] Italiaans: past het tabblad "Scorribande & Gran Banca" nog op de knop?
- [ ] Ook (groep 2): Heroic/Mythic heten zoals in het spel (Duits "auf Heroisch", Frans "Héroïque", Spaans "Heroica",
      Portugees "Heroico"), Season = "Saison"/"temporada"/"Série" (Portugees)/"stagione", de sleutel = "Schlüsselstein"/
      "clé"/"piedra angular"/"pedra-chave"/"Chiave del Potere", ilvl = "Gegenstandsstufe" enz. Passen de korte kolomkoppen
      (bv. "St." in het Duits) nog?

## 🆕 15 nov (later) — talen: Mythic+ in es/pt/it en het toetsenmenu

Alleen te zien met een Spaanse, Mexicaanse, Portugese, Italiaanse of Duitse client (of laat het Cisca zien):
- [ ] Het Mythic+-tabblad heet in het Spaans "Mítica+", Mexicaans "Mítico+", Portugees "Mítico+", Italiaans "Mitica+".
      Italiaans: de kop zegt "Mitica+ — Stagione 2" (niet "Season").
- [ ] Waar MH zegt waar je een toets instelt (bv. de toetsen voor drankjes, of het welkomstvenster), heet het menu zoals
      in het spel: Duits "Tastaturbelegung", Italiaans "Assegnazione tasti", Spaans "Atajos de teclado", Mexicaans
      "Atajos", Portugees "Atalhos do teclado". Klopt dat met Esc → Opties in jouw client?

## 🆕 15 nov — talen: "Mythisch+" / "Mythique +" en de kamers in de rondleiding

Alleen te zien met een Duitse, Franse, Spaanse, Portugese of Italiaanse client (of laat het Cisca zien):
- [ ] Duits: het Mythic+-tabblad heet "Mythisch+"; Frans: "Mythique +". Ook in de dungeontips.
- [ ] De rondleiding (stap "kamers") noemt de vier knoppen zoals ze links echt heten (bv. Duits: Ich, Codex, Werkzeuge,
      Einstellungen). Nederlands: "Ik, Codex, Tools en Instellingen".

## 🆕 14 nov (avond, laat) — Forever: Horde/Alliance-tekentje in "Your characters"

- [ ] `/mh alts`: vóór het character waarop je nu speelt staat het Horde- of Alliance-embleem.
- [ ] Characters waar je sinds deze versie nog niet op inlogde: een grijs "?" en rechts onderin "? = Horde or Alliance
      not known yet …". Log er één keer op in: daarna staat er het embleem.
- [ ] Past de naam nog in de kolom (het embleem neemt wat ruimte)?

## 🆕 14 nov (avond, laat) — Forever: dungeons voor jouw level + pijl naar de ingang (stap 1)

Op een Forever-character van level 13 of hoger:
- [ ] "Do this now" heeft een regel "Dungeons for your level (N): …" met hoogstens 3 namen (en de zone erachter), en
      een knop "Dungeons". (Het venster komt hier niet vanzelf door; staat het al open, dan zie je de regel.)
- [ ] De knop (of `/mh dungeons`) opent "Dungeons in Forever": alle dungeons met level en ingang. Groen = past nu, grijs
      = onder je level. Klopt de naam van elke dungeon?
- [ ] Muis op "Route": de zone en de plek, en zo nodig de reis ("The way there"). Klik: de pijl wijst naar de ingang,
      ook als je eerst een boot of zeppelin moet nemen. Bij de ingang gaat de pijl weg.
- [ ] ~~Krol'dok, Alcaz, Blackmaw en Shaper's Terrace hebben een `*`~~ (15 nov: de `*` is weg; HandyNotes-dungeons 1.02
      heeft die vier nu ook, en de Stockade-ingang is verplaatst naar 50.3, 66.1 in Stormwind). Ben je er toevallig:
      klopt de plek? Vooral de Stockade: wijst de pijl naar de echte ingang?
- [ ] `/mh dungeons check` → level, kant, wat past en de regel voor "Do this now".

## 🆕 14 nov (avond) — Forever: "Do this now" zegt WELKE knop een oude rank heeft (komt in de release ná 5.3.0)

Op je shaman (of een character met een lagere rank op een knop), open "Do this now":
- [x] Eén knop: de regel noemt de spell, bv. "1 button on your bars casts Lightning Bolt rank 1; you know rank 2."
      (dus "1 button", niet "1 buttons"). ✅ Rob 14 nov (shaman, screenshot via sparring): "Healing Wave rank 1; you
      know rank 2".
- [ ] Daarachter de PLEK: "It is on Action Bar 4, button 3 (key …)." Klopt dat met waar de knop echt zit? Zit hij op
      een balk die je nu niet ziet: "(that bar is hidden now)". `/mh ranks` zegt per knop hetzelfde.
- [ ] Zie je op die plek de oranje rand met het pijltje? (14 nov NIET gezien, ook niet op de goede knop, toets C.)
      Sinds 14 nov avond is de rand dik en fel voor elke lagere rank. Test: zet een lage rank op een knop (spellbook,
      rank 1 slepen), kijk of de rand komt. Zie je hem niet: `/mh ranks` → "drawn on <knop> (alpha …)" en stuur dat.
- [ ] Twee of meer: eerst "N buttons …", dan "Which: … rank 1 (you know 2), …". Dezelfde regel staat op de startpagina
      (Me / Home).

## ✅ 13 nov (nacht, 5) — "gezien" pas als JIJ het venster sluit (uitgebracht in 5.3.0)

- [x] Eén schone `/reload`: GEEN rode melding (BugSack) meer over NewChoices.lua ("attempt to index upvalue 'win'").
      ✅ GEMETEN 14 nov in `_forever_/…/SavedVariables/!BugGrabber.lua`: de enige NewChoices-fout is van 13 nov 23:04:56
      (sessie 174, vóór fix d6c0d31). Daarna geen nieuwe, terwijl Rob 14 nov 06:37 en 19:58 inlogde (die openingen
      staan in newChoicesShowLog). Tegencontrole: andere, oudere fouten staan wél in hetzelfde bestand.

Eén `/reload` op een bestaand Forever-character (bijv. de mage van vanavond):
- [x] Het venster komt, "New in this version: your choice", met de schermpjes (quick bar, Fast Mark, buff-icoon,
      minimap, groepspaneel, Do this now). Sluit het zelf (Close, X of Esc).
      ✅ GEMETEN in newChoicesShowLog: 13 nov 23:04:56, 1 s na reparatie 2 (`newChoicesFix2` 23:04:55), mode "update",
      7 kaartjes (donow#2, partypanel#2, keyblock, quickbar, fastmark, missingbuff, minimap), closedAfter 228,8 s.
- [x] Nog een `/reload`: het komt NIET terug. `/mh new check` → "one-time repairs: 1 done, 2 done (…)" en een regel
      "opening … closed after X s; counted as seen: yes".
      ✅ GEMETEN: daarna geen "update"-opening meer in het log (alleen twee Welcome-openingen op nieuwe characters);
      Robs filmpje 14 nov 19:58: `/mh new check` → "6 apply, 0 not seen yet", "counted as seen: yes".
- [ ] Laat het venster open staan en log uit (of `/reload`): bij de volgende login komt het WEL terug ("counted as
      seen: no").

## 🆕 13 nov (nacht, 4) — "gezien" alleen als het echt in beeld stond (Rob: "geen venster, na reload")

Op het character van vanavond (de Frost-mage zonder bar layout), gewoon `/reload`:
- [ ] WERKT HET: het venster komt één keer, "New in this version: your choice", met het toetsenkaartje ("A fixed key
      for every spell") en de schermpjes (quick bar, Fast Mark, buff-icoon, minimap, groepspaneel, Do this now).
      Laat het minstens 2 seconden staan en sluit. Nog een `/reload`: het venster komt NIET nog eens.
- [ ] `/mh new check` → regel "last automatic opening: … N card(s) really in the window: … ; counted as seen: yes".
      Het aantal moet gelijk zijn aan wat je in het venster zag.
- [ ] Sluit je het venster binnen 1 seconde, dan komt het bij de volgende `/reload` terug ("counted as seen: no").

## 🆕 13 nov (nacht, 3) — schermpjes en balken in het overzicht (Rob: "alleen voor nieuwe spelers en één keertje bij een volgende update")

Gewoon `/reload` op een bestaand character (jij bent nu een "bestaande speler" die de nieuwe ronde voor het eerst ziet).
- [ ] Het venster komt één keer vanzelf, titel "New in this version: your choice", met kaartjes Aan/Uit voor: "Quick
      bar" (reload, uit de groep, MH-logo), "Show Fast Mark bar" (iconen op spelers in een groep), "Show missing buff
      icon", "Show minimap icon", en opnieuw het groepspaneel (+ in Forever "Do this now"). Het pijltje ">" staat op
      je huidige stand. Is het venster te hoog: schuifbalk.
- [ ] Zet de quick bar Aan: de balk verschijnt meteen. Nog een `/reload`: het venster komt NIET nog eens.
- [ ] Nieuw character daarna: alleen de character-kaartjes (richting, bar layout of toetsenblok), niet de schermpjes.

## 🆕 13 nov (nacht, 2) — titel + hoogte van het overzicht (Rob: "Ja, jouw advies")

- [x] Nieuw character (Forever of Midnight): titel "Welcome: set up Midnight Helper", intro "A few things to set up
      for this character…". Na een update met iets nieuws voor iedereen: "New in this version: your choice".
      ✅ Rob 13 nov (Forever, nieuwe mage, screenshot door sparring gezien): Welcome-titel, richting Arcane/Fire/Frost
      met zinnen, bar-layout met Yes. *"Ik heb ten eerste gekozen dat ik vast wilde. Toen dat ik inderdaad de keys
      wilde. Daarna deed ik reload. En hebben we de keys en dergelijke neergezet. Het protocol verder afgevolgd."*
- [x] Forever, nieuw character op een standaard-layout: het kaartje "Midnight Helper bar layout" staat er, het kaartje
      "A fixed key for every spell" NIET. ✅ zelfde screenshot. Kies je niets op het bar-kaartje, dan komt het toetsenkaartje bij je volgende
      login (of /reload) wél.
- [ ] Past het venster niet meer, dan krijgen de kaartjes een schuifbalk rechts (scrollen met het muiswiel werkt).
      `/mh new check` → "window size last shown: … (fits / scroll bar on)".

## 🆕 13 nov (nacht) — FOREVER: één overzicht bij de eerste login (Rob: "Als kaartjes erin")

Maak een nieuw Forever-character en wacht na het inloggen (intro-filmpje mag eerst).
- [x] WERKT HET: er komt maar ÉÉN venster: het keuzevenster. Daarin onder andere de kaartjes "Which way do you want
      to go?" (drie knoppen, één per boom) en "Midnight Helper bar layout" (knop Yes). De richtingvraag en de
      bar-layout-vraag komen NIET meer los. WERKT HET NIET: een tweede venster, of een kaartje ontbreekt → typ
      `/mh new check`, `/mh direction check` en `/mh mylayout check` en stuur een screenshot van de chat.
      ✅ Rob 14 nov (Forever, gloednieuwe mage, code d6c0d31; 20.png gezien door Sparring 13-11): *"deze drie kreeg ik
      na een nieuwe char, nu ga ik werken"*. "Welcome: set up Midnight Helper" met precies die twee kaartjes.
- [ ] Het kaartje "Which way do you want to go?": drie knoppen onder elkaar, even breed, met RECHTS ernaast de zin over
      die boom, zonder dat je iets hoeft te doen (Rob: "Laat de uitleg zichtbaar bij elke knop"). Klik er één: in de
      chat "direction for this character: …", en op de knop staat ">" voor je keuze.
      ½ Rob 14 nov (20.png): Arcane / Fire / Frost, elk met zijn zin ernaast = gezien. De klik en de chatregel: niet gezien.
- [ ] Het hele venster past op je scherm (niets valt onder of boven weg). Is het breder dan eerst, dan is dat expres:
      het wordt breder in plaats van hoger. `/mh new check` → regel "window size last shown" (breedte x hoogte, en of
      het past).
- [x] Klik Yes op het bar-layout-kaartje: het venster gaat dicht, je ziet alleen de reload-vraag, in de chat staat hoe
      je terugzet. Reload now → het toetsenblok opent.
      ✅ Rob 14 nov (22.png + 21.webp, zelfde woorden): alleen de reload-vraag, daarna "Your key block" met "Getting
      started" erboven. De chatregel over terugzetten: niet op de screenshots, dus NIET gezien.
- [ ] Een oud character dat al een richting koos en al een eigen layout heeft: GEEN venster bij het inloggen.

## 🆕 13 nov (laat, 3) — FOREVER: geen doorklik meer van de richtingvraag naar "Yes" (Rob: "ik klikte alleen in de keuze")

Nieuw Forever-character. Kies een richting met een snelle dubbelklik (expres).
- [ ] WERKT HET: de richting is gekozen, en ±1,5 s later komt de bar-layout-vraag, nog steeds open — je tweede klik
      deed niets. De knoppen zijn de eerste ±0,7 s grijs.
- [ ] Klik dan bewust **Yes**: in de chat staat nu ook "not what you wanted? /mh block, then "Bars back as they were"
      puts your bars back."
- [ ] `/mh mylayout check`: een regel "last "Yes": … question on screen X s, previous question closed Y s before".
      Een doorklik zou daar < 1 s laten zien.

## 🆕 13 nov (laat, 2) — FOREVER: na "Yes" op de bar layout geen keuzevenster eronder (Rob, 6.png)

Nieuw Forever-character. Richtingvraag beantwoorden, dan bij de bar layout op **Yes**.
- [x] Je ziet alleen de vraag "Your MH bar layout is set. Reload now? …". Het keuzevenster komt er NIET onder.
      ✅ Rob 14 nov (22.png, gezien door Sparring 13-11): *"deze drie kreeg ik na een nieuwe char, nu ga ik werken"*.
      Alleen de reload-vraag, geen tweede venster eronder.
- [ ] Klik **Reload now**: na het laden opent het toetsenblok vanzelf. Het kaartje "A fixed key for every spell" komt
      daarna niet meer als los venster (ook niet als je het toetsenblok sluit zonder iets te doen).
      ½ Rob 14 nov (21.webp): het toetsenblok opende vanzelf = gezien. Of het kaartje daarna wegblijft: niet getest.
- [ ] (Ander nieuw character) klik **Later**: deze sessie komt het keuzevenster niet meer. Bij je volgende login (of
      /reload) komt het wél, met het kaartje "A fixed key for every spell".

## ~~13 nov (laat) — FOREVER: vragen bij de eerste login één voor één~~ VERVALLEN: Rob koos daarna "Als kaartjes erin" (zie 13 nov nacht)

Maak een nieuw Forever-character en wacht na het inloggen (intro-filmpje mag eerst).
- [ ] WERKT HET: eerst alleen "Which way do you want to go?". Pas als je die sluit of kiest, komt (na ±2 s) "Set up the
      Midnight Helper bar layout on this character?". Daarna pas "New in this version: your choice". Nooit twee tegelijk.
      WERKT HET NIET: twee vensters tegelijk, of er komt er één niet → typ `/mh direction check` en `/mh mylayout check`
      (regels "this login") en stuur een screenshot van de chat.

## 🆕 13 nov (avond) — FOREVER: "Dock to window" vrij van de tekst (Rob: "1 fixen")

Nieuw Forever-character (of `/mh mylayout check` laat zien of de vraag komt). 
- [ ] Vraag "Set up the Midnight Helper bar layout on this character?": de eerste regel staat ONDER "Dock to window",
      niets raakt elkaar. Het venster is iets hoger; de drie knoppen staan nog onderaan.
- [ ] Vraag "Which way do you want to go?": de titel loopt niet onder "Dock to window".
- [ ] (Als je hem ziet) "Use your layout … here?" (`/mh mylayout`): tekst ook onder "Dock to window".

## 🆕 13 nov (avond) — keuzevenster komt vanzelf op een character zonder toetsenblok (Rob: "Dat zou wel moeten")

- [ ] Midnight: maak een nieuw character (of log in op een character dat het toetsenblok nooit kreeg). Niets typen,
      gewoon ~20 seconden wachten. WERKT HET: het venster "New in this version: your choice" komt vanzelf, met het
      kaartje "A fixed key for every spell". WERKT HET NIET: na 20 s nog niets → typ `/mh new check` en stuur een
      screenshot van de chat (regels "last login" en "key card now").
- [x] Forever: hetzelfde op een character zonder toetsenblok.
      ✅ Rob 13 nov (nieuwe hunter, via sparring): na de richting- en bar-layout-vraag *"Ja, kwam vanzelf"*.

## 🆕 13 nov — keuzevenster gaat dicht na kiezen (Rob, via sparring: "Ja, dicht na kiezen")

Na je dungeonrun: `/reload`, dan `/mh new` (toont het venster opnieuw, ook als je het al zag).
- [x] Midnight, één kaartje "Show party targets": klik On (of Off). WERKT HET: het venster gaat meteen dicht en in de
      chat staat "on"/"off". WERKT HET NIET: het venster blijft staan. Stuur een screenshot.
      ✅ Rob 13 nov (via sparring): *"o en na de keuze was ie inderdaad weg"*.
- [x] De titel "New in this version: your choice" staat links en loopt NIET meer onder "Dock to window" rechtsboven.
      Is hij te lang, dan breekt hij af naar een tweede regel, en de tekst eronder schuift mee omlaag.
      ✅ Rob 13 nov, screenshot 5.png (Midnight, /mh new; gezien door Sparring 13-11): titel links, Dock vrij ernaast.
- [ ] Forever (meer kaartjes, o.a. "Do this now" en het groepspaneel): na één keuze blijft het venster staan; pas als
      elk kaartje een keuze kreeg, gaat het dicht. (Het toetsen-kaartje "Show me" sluit, net als eerst, meteen.)

## 🧪 12 nov (laat) — PROEF: eigen toetsenlijst in Forever (Rob, via sparring: "Ja, eerst de proef")

Sluit WoW helemaal af (niet alleen /reload) en start Forever opnieuw.
- [x] Esc → Options → Keybindings → kopje "Midnight Helper". WERKT HET: precies 4 regels — "Toggle main window"
      (ALT-M), "Clear active route / arrow", "Open: Forever", "Your characters". WERKT HET NIET: nog steeds de lange lijst
      van 14 (Rares, Delves, TAB_CODEX, drankjes …). Stuur een screenshot.
      ✅ Rob 13 nov (screenshot, gezien door Sparring 13-11): precies die 4 regels. `Bindings_Camelot.xml` blijft.
- [ ] ALT-M opent MH nog gewoon.
- [x] In Midnight (retail): de lijst onder "Midnight Helper" is precies als altijd (14 regels, met "Open: This Week").
      ✅ Rob 13 nov (screenshot, gezien door Sparring 13-11): 14 regels, "Open: This Week" op ALT-M.

## 🆕 12 nov (laat) — FOREVER: tegel "Your characters" (Rob, via sparring: "Ja, een tegel (Recommended)")

- [x] `/reload`, open MH → kamer "Me": een nieuwe tegel "Your characters" naast Weapon trainers, Vendors enz. Klik →
      het venster met al je characters opent. Staat het icoon er (een plaatje, geen groen vierkant)?
      ✅ Rob 12 nov (33.png, ":)"): tegel met icoon, venster open, vier characters met hele naam.

## 🆕 12 nov (laat) — FOREVER: toets voor "Your characters" (Rob, via sparring: "Ja, zonder toets")

- [ ] `/reload`. Esc → Options → Keybindings → kopje "Midnight Helper" → regel "Your characters", zonder toets. Kies er
      een → drukken opent het venster, nog een keer drukken sluit het.
- [x] In het venster: alleen het character waarop je zit zegt "now"; een character waar je net vanaf kwam "1 min ago".
      ✅ Rob 12 nov (33.png): "now" alleen bij de Paladin, de Druid "1 min ago".

## 🆕 12 nov (laat) — BEIDE SPELLEN: toetsen-kaartje per character (Rob, via sparring: "Ja, per character")

- [ ] `/reload`, log in op een character zonder toetsenblok → het keuzevenster komt met alleen "A fixed key for every
      spell". Op een volgend character zonder blok weer één keer. Op een character mét blok niet.

## 🔁 12 nov (laat) — FOREVER: "Your characters" na de reparatie (Robs 24-26.png)

`/reload`, en log daarna op elk character één keer in (de oude, lege foto's worden dan vervangen).
- [ ] De namen zijn heel: "Ima Pallie", "Ima Shammydude", "Ima Warman" … en daarachter "level 11 Paladin" zonder "…".
- [ ] Een character waar je níet op zit, toont zijn eigen goud en beroepen; "All your gold together" telt alles op.
- [ ] "Last played": je eigen character "now", een ander "N min ago", "today", "yesterday" of "N days ago".
- [ ] De servernaam staat er niet meer bij (al je characters zitten op één server).

## 🆕 12 nov (laat) — FOREVER: een oude rank licht op, op je knop (Rob, via sparring: "ja bouw oude reank")

Geen nieuw bestand: `/reload` is genoeg.
- [x] Een knop op je gewone balken met een lagere rank (bv. Holy Light Rank 1 terwijl je Rank 2 kent) heeft een dunne,
      zachte oranje rand met een pijltje omhoog rechtsboven. ✅ Rob 12 nov (27.png, via sparring): de rand staat er;
      het pijltje is op het plaatje NIET te zien.
- [ ] Leer bij de trainer een nieuwe rank → binnen een paar seconden krijgt de knop met de vorige rank een FELLE, dikkere
      rand. Klik "Update bars" (of `/mh ranks fix`) → de rand verdwijnt.
- [ ] `/mh ranks` → onderaan "edge on the button: on: N button(s) …".
- [ ] `/mh ranks glow off` → alle randen weg; in Options staat "Edge on buttons with an old rank" uit. `/mh ranks glow on`
      → terug.
- [ ] Valt de rand op zonder te lijken op een proc (het gele "druk nu"-licht van het spel)? En is het pijltje te zien
      (het plaatje is AFGELEID, niet gemeten in Forever)?

## 🆕 12 nov (laat) — FOREVER: "Your characters" (Rob, via sparring: "De vijf van het advies, bouwen (Recommended)")

Nieuw bestand (`ForeverChars.lua`): WoW opnieuw starten. Een character staat er pas in na één login met deze versie.
- [ ] `/mh alts` → venster "Your characters". Bovenaan het character waarop je nu speelt: naam in classkleur, server,
      level en class, goud, je richting, "now", en in groen hoeveel spells klaarliggen bij de trainer. Op de tweede regel
      in grijs je beroepen met skill (bv. "Mining 75/150").
- [ ] Log in op een tweede character en weer terug → beide staan erin. "Last played" van de ander zegt "today".
- [ ] Onderaan "All your gold together" = alles bij elkaar.
- [ ] Het kruisje rechts op een ANDER character → die verdwijnt, de chat zegt "forgot …". Op je eigen rij staat geen kruisje.
- [ ] `/mh alts check` → hoeveel characters er bewaard zijn en wat er van dit character staat.

## 🆕 12 nov (laat) — MIDNIGHT: kaartje "Party targets" in het keuzevenster

- [ ] In Midnight komt het keuzevenster nu ook met een kaartje "Show party targets" (On / Off). On → de chat zegt
      "Party targets ON"; in Options staat "Show party targets" dan ook aan.

## 🆕 12 nov (laat) — BEIDE SPELLEN: venster "Nieuw in deze versie" (Rob, via sparring: "Ja, bouw het (Recommended)")

⚠️ Er is een nieuw bestand bij gekomen (`NewChoices.lua`). Voor de zekerheid: **sluit WoW helemaal af en start
opnieuw**, in Forever (of `/reload` een nieuw bestand oppikt: AFGELEID, niet gemeten).
- [ ] Na het inloggen (en na de vraag "Welke kant?" als die komt) verschijnt één venster "New in this version: your
      choice". De changelog komt dan NIET. Drie kaartjes: "Do this now" window (drie knoppen), Group panel (On / Off), en
      "A fixed key for every spell" (alleen als je op dit character het toetsenblok nog niet hebt neergezet).
- [ ] De knop van je huidige stand heeft een groen pijltje ervoor. Klik een andere → het pijltje springt mee en de chat
      zegt wat je koos. Groepspaneel in een gevecht → de chat zegt "not in combat", er verandert niets.
- [ ] "Show me" → het venster gaat dicht en het toetsenblok-venster opent (het plan; er wordt NIETS neergezet).
- [ ] "What else is new?" → de changelog opent. Daar staat rechtsonder, boven Close, een knop "Choices" → het
      keuzevenster komt terug.
- [ ] Sluit het venster met het kruisje zonder te kiezen → alles blijft zoals het was. Na `/reload` komt het niet
      terug (de changelog wel weer, zoals altijd).
- [ ] `/mh new` → het venster komt terug. `/mh new check` → per kaartje of het geldt en of je het al zag.
- [ ] In Midnight: het kaartje "Show party targets", en het toetsenkaartje als je het blok daar nog niet hebt.

## 🆕 12 nov (avond) — FOREVER: "Welke kant wil je op?" (Rob, via sparring: "De vraag 'Welke kant?'")

Eerst `/reload` in Forever, op je Paladin.
- [x] Een paar seconden na het inloggen komt een venster "Which way do you want to go?" met drie knoppen: **Holy**,
      **Protection**, **Retribution**, elk met één zin eronder. Onderaan: wat je talentpunten tot nu toe zeggen (of "je eerste
      talentpunt krijg je op level 10"). Komt eerst de vraag over de balkenindeling, dan komt deze pas daarna.
      ✅ Rob, 12 nov (via sparring, 15.png, op een Rogue): "dit werkt".
- [ ] Klik er een → het venster gaat dicht en de chat zegt welke richting je koos.
- [x] `/mh play` → rechtsboven een knop "Your direction: <naam>". Klik erop → het venster komt terug, met een vinkje bij je
      keuze. "No choice" haalt de keuze weg. ✅ Knop gezien (16.webp) en wisselen werkt (20.webp); "No choice" niet gemeld.
- [ ] Na `/reload` vraagt MH het niet nog eens (je hebt al gekozen).
- [ ] Op een ander character zonder keuze: "Later" → deze sessie niet meer; na `/reload` weer wel.
      "Never ask again" → niet meer; in Options → AddOns → Midnight Helper staat "Ask which way you want to go" dan uit.
- [ ] `/mh direction check` → twee regels: je keuze, of hij vraagt en waarom, en je talentpunten per boom.

## 🆕 12 nov (avond) — BEIDE SPELLEN: alle ontbrekende buffs (Rob, via sparring: "Alle ontbrekende buffs")

Eerst `/reload`. Het beste op je Paladin in Forever zonder blessing én zonder aura (rechtsklik ze weg).
- [ ] Het grote icoon staat er zoals altijd en cast de eerste. Ernaast, rechts, staan kleine icoontjes voor wat er nog meer
      mist.
- [ ] Muis op het grote icoon → in de tooltip: "Why <blessing>: …" (die heb je het laatst gecast, of: de eerste die je
      kent) en "Also missing:" met de rest.
- [ ] Muis op een klein icoontje → de spell, en "Also missing. Click the big icon first; this one comes next."
- [ ] Klik het grote icoon → de buff gaat aan, het volgende kleine icoontje wordt het grote.
- [ ] `/mh buffs` zegt nu per keuze "[cast last]" of "[none cast yet: first one known]".

## 🆕 12 nov (avond) — BEIDE SPELLEN: knop "Verplaatsen" (Rob, via sparring: "Knop 'Verplaatsen'")

Eerst `/reload`, buiten een gevecht.
- [x] `/mh move` → alle MH-onderdelen op je scherm krijgen een groen vakje "Drag me: …", ook het buff-icoon als er niets
      mist. De chat zegt hoeveel. ✅ Rob, 12 nov (via sparring): "mh move werkt :)"
- [ ] Sleep er een paar (buff-icoon, snelbalk, routepijl) → ze gaan mee. Klik daarna nog eens het buff-icoon: cast hij nog?
      Waarschijnlijk goed: Rob zei nog eens "mh move werkt" toen hem dit gevraagd werd, maar niet los per punt.
- [ ] Nog eens `/mh move` → de vakjes weg, alles blijft op de nieuwe plek; na `/reload` ook. (Idem: waarschijnlijk goed.)
- [ ] Hetzelfde via Options → AddOns → Midnight Helper → "Move MH elements on your screen".
- [ ] Een gevecht beginnen met de vakjes aan → ze gaan vanzelf weg, met een regel in de chat.
- [ ] `/mh move why` → per onderdeel: op je scherm, nu verborgen, of uit.

## 🆕 12 nov (avond) — BEIDE SPELLEN: knoppen zo breed als hun tekst (Rob, via sparring: "Alle 18 repareren")

Het ging vooral om Frans, Spaans, Duits, Italiaans en Russisch; in het Engels zie je weinig verschil.
- [ ] `/reload`. Kijk of niets over elkaar valt: het modelvoorbeeld (Spin en Reset onderaan), het dungeon-bazenvenster
      (Chat/Share rechtsonder), de Great Vault-melding (de knop rechtsonder en de grijze zin ernaast), Consumables
      (de knoppen bovenaan), het beroepenvenster (de twee route-knoppen onderaan).
- [ ] Wie MH in een andere taal speelt (bv. Cisca of een tester): passen de teksten in de knoppen?

## 🆕 12 nov (avond) — FOREVER: uitleg per beroep (Rob, via sparring: "A, eerst klein")

Eerst `/reload`.
- [ ] `/mh trainers` (Profession trainers) → kies links een beroep, bv. Skinning. Boven de trainers staat een kaartje: wat
      het doet, "Main profession: you may have 2. You have N now.", "Tool: Skinning Knife." met een knop "Where to buy",
      "Player guides pair it with Leatherworking.", de rangen (75/150/225/300, volgende vanaf 50/125/200), jouw skill, en
      het level per rang volgens spelersgidsen. Onderaan grijs: de titel van een trainer noemt één rang hoger.
- [x] Kies Cooking, First Aid of Fishing → "Secondary profession…" en "Trainers teach this up to skill 150 …".
      ✅ Rob, 12 nov (via sparring, screenshot): kaartje staat er en leest goed. ❌ "Tool: (loading...)." bij Fishing.
      Gerepareerd: het kaartje wacht nu op de naam (zoals de verkopers-tip). Opnieuw kijken: binnen een paar seconden
      "Tool: Fishing Pole.". (De half zichtbare onderste trainer is de rand van het scrollvak: scroll verder.)
      ✅ Rob (via sparring): "ja de fishing pole staat er, en ja ik kon nog verder scrollen dus hij werd net afgesneden".
- [ ] "Where to buy" → de verkoperslijst opent op dat gereedschap.
- [ ] De lijst met trainers staat netjes onder het kaartje (niet eroverheen).
- [ ] Heb je minder dan 2 hoofdberoepen en staat "Do this now" open: "You can still learn 1 main profession." met een
      knop "Profession trainers". (Die regel laat het venster NIET vanzelf opengaan.)

## 🆕 12 nov (avond) — FOREVER: venster "Doe dit nu" (Rob, via sparring: "Venster 'Doe dit nu'")

Eerst `/reload` op je Protection-paladin (een paar seconden wachten).
- [ ] Is er iets te doen, dan staat rechtsboven een venstertje "Do this now" met:
      "Do this now" (bv. spells bij je trainer met de prijs, oude ranks op je balken, een ontbrekende buff, een beroep
      zonder gereedschap) en "Coming up (next 3 levels)": per level de trainer-spells bij naam, en "For Protection: Holy
      Shield (a talent, at the earliest at level 30)" zolang je onder 30 bent.
- [x] Het venster staat er en werkt. ✅ Rob, 12 nov (via sparring, 21.png): "Het venster staat er, werkt".
- [x] Knoppen onderaan alleen als het past: "Show the way" (naar je trainer), de ranks-knop, "Weapon trainers".
      ✅ 22.png: "Weapon trainers" past nu in de knop. ("Show the way" en de ranks-knop nog niet gezien.)
      ❌ 21.png: "Weapon trainers" stak buiten de knop uit. Gerepareerd: elke knop zo breed als zijn tekst, en een
      nieuwe rij als ze niet naast elkaar passen. Opnieuw kijken.
- [x] Nieuw 12 nov (Rob: "Ja, alle drie"): (1) geen tweede "Do this now" meer onder de titel; (2) bij een spell die je al
      hebt staat de rank erbij, bv. "Level 12: Blessing of Might (Rank 2), Holy Strike"; (3) "You can learn 2 new weapon
      skills now. (fitting Protection, according to player guides: 1)".
      ✅ Rob, 12 nov (via sparring, 22.png): "Het venster en de startpagina kloppen nu". Rank bij elke spell die hij al
      kent (ook Holy Strike en Seal of the Crusader: die kende hij al).
- [x] Nieuw 12 nov (Rob: "Ja, ook netjes"): de startpagina van MH (Forever) zegt nu ook "You can learn 1 new weapon skill
      now." / "… 2 new weapon skills now." (zonder het stukje over je richting). ✅ Rob: "… de startpagina kloppen nu".
- [ ] Niets te doen → het venster is weg (standaard). In Options → AddOns → Midnight Helper → "\"Do this now\" window" op
      "always" → het blijft staan en zegt "All caught up". "off" → nooit.
- [ ] Begint een gevecht → het venster gaat weg; na het gevecht komt het terug.
- [ ] Kruisje → weg tot je volgende login. `/mh donow` → weer in beeld.
- [x] Nieuw 12 nov (Rob: "Tandwieltje"): naast het kruisje een tandwieltje. ✅ Rob (via sparring): "Het tandwieltje
      staat er, werkt" (het plaatje bestaat dus in Forever; tooltip, standen en chatregel niet apart gemeld). Muis erop → uitleg. Klik → menuutje met
      "only when there is something to do", "always", "off" (een groen > bij de huidige stand). "off" → het venster weg
      en de chat zegt hoe je het terugkrijgt (/mh donow auto of de instelling). Dezelfde stand staat dan ook in Options.
- [ ] Slepen, Shift+scroll = grootte; na `/reload` staat het nog daar. Ook in `/mh move`.
- [ ] `/mh donow check` → de stand, getoond of niet en waarom, en de lijst.

## 🆕 12 nov (avond) — FOREVER: wat jouw richting nodig heeft (Rob, via sparring: "1 en 2, de wapens er meteen bij")

Eerst `/reload`, op je Protection-paladin.
✅ Rob, 12 nov (via sparring): *"De blog geeft redelijk antwoord op wat nu … voorlopig wat we nu hebben, daar ben ik heel
erg blij mee."* Screenshots 19.webp (Protection) en 20.webp (Retribution).
- [x] `/mh play` → bovenaan staat nu een blok "Your direction: Protection": zwaarste pantser (Mail, Plate vanaf level 40),
      wapen volgens spelersgidsen (een eenhandig wapen en een schild), "Holy Shield only works with this in your hands:
      Shields (a talent: at the earliest at level 30)", dat je elk wapen mag gebruiken, en een grijze bronregel. ✅ 19.webp
- [x] `/mh weapons` → bij One-Handed Maces, Axes en Swords staat een groen +. Onderaan: "Your direction Protection: player
      guides pair it with … , Shields". Je two-handed sword staat er gewoon nog, zonder +. ✅ 19.webp
- [x] Wissel van richting (knop in `/mh play`, of `/mh direction`) → het blok en de + in `/mh weapons` veranderen mee
      (bv. Retribution: + bij de tweehandige wapens). ✅ 20.webp: + bij Two-Handed Maces/Axes/Swords en Polearms.
- [ ] "No choice" → het blok is weg, de + ook.

## 🆕 12 nov (avond) — FOREVER: klein groepspaneel (Rob, via sparring: "A, eerst klein")

Eerst `/reload` in Forever. Het staat standaard UIT.
- [ ] `/mh partytargets` → chat "group panel: on …". Buiten een groep zie je nog niets.
- [x] In een groep (2 is genoeg): een paneeltje "Group" met een rij per speler: naam in class-kleur, rol rechts (als die er
      is). Lege plekken staan grijs met "-". ✅ Rob, 12 nov (via sparring, 18.png): "Het groepspaneel staat er, de rijen
      kloppen". Vraag van sparring: de 3 lege rijen; bewust (vaste maat i.v.m. de klikknoppen). Voorstel "zo hoog als je
      groep" ligt bij Rob.
- [x] Nieuw 12 nov (Rob: "Ja, doe dat"): na `/reload` in een groep van 2 heeft het paneel nog maar 2 rijen, geen "-" meer.
      ✅ Rob, 12 nov (via sparring): "Het paneel heeft nu twee rijen, klopt". Nog niet gemeld: dezelfde plek, en
      groeien/krimpen bij een groepswissel (de zinnen hieronder).
      De bovenkant staat waar hij stond. Komt er iemand bij (buiten een gevecht), dan groeit het paneel naar onder. Komt
      iemand erbij IN een gevecht, dan verschijnt die rij pas na het gevecht. Klik daarna een rij: klopt het doelwit nog?
- [x] Linksklik op een rij → die speler wordt je doelwit. ✅ Rob, 12 nov (via sparring): "Linkslikken lukt, dan selecteer
      ik." (In een gevecht: niet apart gemeld.)
- [ ] ⏳ LATER (Rob: "dan moeten we een keertje on the fly testen"): zijn twee characters zijn te laag voor een dispel
      (Rogue), en zijn Paladin (Horde) kan niet met Cisca (Alliance) groeperen. Test met een class die een dispel kent.
      Rechtsklik op een rij → je dispel op die speler (Paladin: Cleanse of Purify; Priest: Dispel Magic, Shift+rechtsklik
      Cure/Abolish Disease; Druid: Remove Curse, Shift: Cure/Abolish Poison; Shaman: Cure Poison, Shift: Cure Disease;
      Mage: Remove Lesser Curse).
- [ ] 🔑 Het echte doel, in een dungeon of met 3+ man: krijgt iemand iets wat jij kunt weghalen, dan wordt die rij ROOD
      (Blizzards eigen rand). Dat is in Forever nog nooit gezien. Wordt hij nooit rood terwijl je wel kon dispellen: zeg het.
- [ ] Slepen aan de titelbalk "Group", Shift+scroll = groter/kleiner; na /reload staat het nog daar. Klikken werkt daarna nog.
- [ ] `/mh partytargets check` → wat MH ziet: getoond of niet en waarom, je dispels, hoeveel rode randen gebouwd.
- [ ] Nog eens `/mh partytargets` → uit, paneel weg. Ook via Options → AddOns → Midnight Helper → "Group panel".

## 🆕 12 nov (avond) — FOREVER: gereedschap vergeten → MH zegt waar je het koopt (Rob, via sparring: "Ja, laat hem dat uitzoeken en bouwen")

Eerst `/reload`, op een character met Skinning en zonder Skinning Knife (Cisca's situatie).
- [x] Probeer een dood beest te skinnen → het spel zegt "Requires Skinning Knife". Meteen daarna komt het venstertje
      "For this you need a Skinning Knife. The nearest seller: …" met "Show the way", en dezelfde zin in de chat.
      ✅ Rob, 12 nov (via sparring, 17.png): venster met Brighid Stormflayer in Dun Morogh (149 meters).
- [ ] Nieuw 12 nov: de chatregel eindigt nu met "Type /mh vendor skinning for the list of sellers." (of mining, fishing,
      hammer). Zo vind je de verkopers terug als het venstertje weg is.
- [ ] "Show the way" → de pijl gaat naar die verkoper.
- [ ] Nog eens proberen binnen 10 minuten → geen nieuw venstertje (geen spam).
- [ ] Komt er niets? Typ `/mh vendor check`. De laatste twee regels zeggen welke foutmelding MH hoorde en wat hij deed.
      Stuur die regels door: dan zie ik of de tekst van het spel anders is.
- [ ] Hetzelfde kan met Mining zonder Mining Pick, of vissen zonder hengel in je hand.
- [ ] Uitzetten: `/mh vendor tip off`, of Options → AddOns → Midnight Helper → "Show where to buy a missing tool".

## 🆕 12 nov (avond) — MIDNIGHT: start de wachttijd van je dispel? (Rob, via sparring: "Ja, bouw dat")

Niets zichtbaars. Hoeft niet vandaag.
- [ ] `/reload`, een dungeonrun met het Party targets-paneel aan, dispel zoals altijd, daarna `/reload`. Dan lees ik in
      `dispelTryLog` bij elke geslaagde cast een `cd`: "started" (de 8 s wachttijd liep → er ging iets weg), "not started"
      (er ging niets weg), of "unreadable" (het spel liet het in het gevecht niet zien).

## 🆕 12 nov (later) — MIDNIGHT: MH legt je dispel-pogingen zelf vast (O27 optie A, Rob: "Optie A, dispel-pogingen")

✅ Gelezen 12 nov (sparring): 5 casts, 1 failed, 2× "Spell is not ready yet", rij bleef rood. Vervolg hierboven.
Niets zichtbaars; jij hoeft niets te typen.
- [ ] `/reload`, een dungeonrun met het Party targets-paneel aan. Dispel jezelf of anderen zoals altijd (rechtsklik op de
      linkerhelft van een rij, of je eigen toets). Daarna `/reload`. Dan lees ik `dispelTryLog`: elke Cleanse Toxins
      (gelukt of mislukt), elke foutmelding van het spel terwijl je muis op een dispel-helft stond ("Nothing to
      dispel", out of range, not ready), welke rij, wanneer, in gevecht ja/nee.

## 🆕 12 nov — MIDNIGHT: MH legt een rode rij zelf vast (O27, Rob: "Ja, bouw het") — ❌ vervangen door optie A hierboven

Niets zichtbaars; dit meet alleen. Jij hoeft niets te typen.
- [ ] `/reload`, een dungeonrun (follower mag) met het Party targets-paneel aan, daarna `/reload`. Dan lees ik
      `dispelRowLog` uit je SavedVariables: welke rij rood werd, hoe lang, in gevecht ja/nee, je casts en fouten op dat
      moment, en wat er 1 s na het gevecht nog op je zat. ⚠️ Werkt het seintje in een gevecht niet, dan staat er
      "signals: show 0"; dan stop ik en krijg je een nieuw voorstel. ❌ Run 12 nov: het seintje mat iets anders (alle
      5 rijen tegelijk bij de opbouw, nooit in een gevecht). Gestopt; nieuw voorstel ligt bij Rob.

## 🆕 12 nov — MIDNIGHT: `/mh prompt test` (Rob: "Ja, laat hem dat bouwen")

Eerst `/reload`. In Midnight, buiten een gevecht (de actie-hint mag aan of uit staan):
- [ ] `/mh prompt test` → de twee icoontjes (je interrupt en je purge, of een vraagteken als je die niet hebt) staan
      20 seconden in beeld, met een regel in de chat. ❌ Rob, 12 nov (via sparring, screenshot): de woorden onder de
      icoontjes liepen door elkaar ("INTERRRWRGE"). Gerepareerd: INTERRUPT staat nu links van het eerste icoon, het
      purge-woord rechts van het tweede. Opnieuw kijken: twee losse, leesbare woorden.
- [x] In die 20 seconden: slepen werkt, en Shift+scroll maakt het groter en kleiner. ✅ Rob, 12 nov (via sparring):
      "Het slepen, het shift-scrollen. … Werkt."
- [ ] Na `/reload` staat het nog op die plek en op die maat. (Niet gehoord.)
- [ ] Na 20 seconden verdwijnen ze weer (of blijven ze alleen staan als de actie-hint aan staat en er iets te doen is).
- [ ] In een gevecht: "Not in combat: try again after the fight." Begint een gevecht tijdens het voorbeeld, dan stopt het
      voorbeeld meteen.

## 🆕 12 nov — MIDNIGHT: `/mh partytest` doet weer de solotest (Rob: "Ja, doe allebei")

Eerst `/reload`. In Midnight, solo:
- [x] `/mh partytest` → het Party targets-paneel verschijnt met testregels (en nog eens = weg). Niet meer "is for WoW:
      Forever". In Forever doet `/mh partytest` nog steeds de groepsmeting. ✅ Rob, 12 nov (via sparring): "De partytest
      is goed. Er staat niks in de chat van WoW Forever".

## 🆕 12 nov — MIDNIGHT: groepspaneel, rechtsklik op het doelwit (Rob: "Optie 1, jouw advies")

Eerst `/reload`. Op je Prot Paladin, in een groep (een dungeon of follower dungeon), met het Party targets-paneel:
- [x] `/mh glow` zegt "no purge, so your stop-spell: spell 96231" en "target halves armed" is 1 of meer. ✅ Rob, 12 nov
      (follower dungeon, screenshot via sparring): precies die regel, "target halves armed: 5", "rows armed to dispel: 5"
      (Cleanse Toxins 213644). Paneel: rijen "staan keurig in rij".
- [ ] Rechtsklik op de rechterhelft van een rij (het doelwit van een groepslid) terwijl die vijand iets cast → Rebuke
      gaat op die vijand. Sta je te ver: het spel zegt "out of range" (Rebuke is melee). 👀 Rob, 12 nov: "out of range,
      dat klopt" (het half). Een Rebuke die RAAKT: nog niet gezien. In `/mh glow` "recent casts" stond geen Rebuke-regel
      (kan eruit gescrold zijn); wel 2× "There is nothing to attack." (oorzaak NIET GEMETEN).
- [ ] Op een Priest, Mage, Shaman of Hunter: daar blijft het de purge, zoals voorheen.

## 🆕 12 nov — `/mh selftest` niet meer in de commandolijst (Rob: "Ja, haal hem weg")

Eerst `/reload`. In beide spellen:
- [x] Typ "selftest" in de MH-zoekbalk, of open de commandolijst: hij staat er niet meer tussen. ✅ Rob, 12 nov (via
      sparring, Midnight): "De zelftest vind ik inderdaad niet in Midnight Helper".
- [x] `/mh selftest` zelf werkt nog wel (alleen voor ons). ✅ Rob, 12 nov (via sparring).

## 🆕 12 nov — Forever: Priest-tip over Shadowform (Rob: "Ja, doe allebei")

Eerst `/reload`. Op een Forever-character: MH → How you play → Priest → "Beginner mistakes":
- [ ] De eerste regel noemt nog Fear Ward en Chastise, maar **niet meer Confounding Flash** (die werkt sinds de
      hotfix van 11 nov wél in Shadowform).

## 🆕 11 nov — Forever: twee Paladin-macro's (Rob: "Ja, alleen klein")

Eerst `/reload`. Op je Forever-Paladin (level 8 of hoger), `/mh macros`:
- [ ] Bij de Paladin-macro's staan twee nieuwe: **Hammer of Justice** ("… It is a stun …") en **Purify**.
- [ ] Hammer of Justice: muis op een vijand en druk → die vijand krijgt de stun, ook als je iets anders als target hebt.
      Zonder vijand onder je muis: je target. 👀 Rob, 11 nov: "de stun werkt met mouse over een target en niet mijn
      target" (= de vijand onder de muis, zoals bedoeld). Nog niet gezien: zonder muis-vijand → je target.

## 🆕 11 nov — Forever: meting voor het groepspaneel (Rob: "maak die meting maar")

Niets zichtbaars; dit meet alleen. Eerst `/reload`.
- [x] **Solo:** typ `/mh partytest` → een paar regels in de chat (events die ontbreken, de rode gloed, focus). Daarna
      `/reload`, dan staat alles in je SavedVariables (`partyProbe`) en lees ik het. ✅ Rob, 11 nov 22:59, GEMETEN in
      `_forever_\…\MidnightHelper.lua`: alle 15 events "valid"; AuraContainer-gloed bouwt; FocusFrame bestaat en
      `[@focus,exists]` → yes; secure button bouwt; UnitGroupRolesAssigned/C_UnitAuras/issecretvalue bestaan. Solo,
      buiten gevecht: target en focus helemaal leesbaar.
- [ ] **In een groep (dungeon):** typ `/mh partytest` als de groep compleet is. De eerste 5 gevechten meet hij vanzelf,
      2 seconden na de start. Na de dungeon `/reload`. Er komen geen namen van andere spelers in het bestand.
- [ ] Zet ook eens iemand op focus (`/focus` op een vijand) vóór `/mh partytest`: dan meet hij of focus werkt.
- [ ] Purify: muis op een groepslid (of jezelf als target) → Purify op die speler. Niets onder je muis: op jezelf.
- [ ] Het woord *focus* in de uitleg: of `[@focus]` in Forever werkt, is NIET gemeten. Werkt het niet, dan valt de macro
      vanzelf door naar je target.

## 🆕 11 nov — MIDNIGHT: "Used for …" in de tooltip van ingrediënten (Rob: "Ja, bouw het")

Eerst `/reload`. In Midnight, alleen Midnight-ingrediënten (oudere uitbreidingen zitten er bewust niet in):
- [ ] Muis op een Midnight-vis of -vlees, bv. **Practically Pork**: "MH: Used for Cooking". Groen met "(you have it)" als
      je Cooking hebt.
- [ ] Muis op **Eversong Trout**: "MH: Used for Alchemy, Enchanting, Cooking", met "(you have …)" voor wat je hebt.
- [x] Muis op een Midnight-erts, -kruid of -stof (de ingrediënten met kwaliteitssterren): ook een regel. ✅ Rob, 12 nov
      (via sparring, screenshots): Azeroot (236774) groen "MH: Used for Alchemy, Enchanting, Cooking, Inscription (you
      have Inscription)"; Argentleaf (236776) grijs "MH: Used for Alchemy, Cooking".
- [x] ❓ Zegt de gewone Midnight-tooltip zelf al voor welk beroep iets is? ✅ 12 nov: Blizzard niet; een ANDERE addon van
      Rob toont "Profession: …" + "Expansion: …" erboven. Rob: "niet iedereen heeft dat" → onze regel blijft.
- [x] Muis op iets uit een oudere uitbreiding: géén regel. ✅ 12 nov: Mycobloom (210796, The War Within) zonder regel
      (bewust). ❓ Rob vroeg zich af of oudere ingrediënten óók een regel moeten krijgen: vraag ligt bij hem (sparring).
      Gear apart: NIET gezien.
- [x] `/mh usedfor` → "Midnight build 12.1.5.70783", 296 items, je beroepen met hun line-nummer, en het laatste item.
      ✅ 12 nov: "Tooltip hook: yes … 296 items … INSCRIPTION (line 773)" en item 274476 met "(you have Inscription)":
      de retail-line 773 wordt dus herkend (GEMETEN via Robs screenshot). `/mh usedfor off`/`on`: niet gezien.

## 🆕 11 nov — Forever: "Used for …" in de tooltip van ingrediënten (Rob: "Ja, met probe-fix")

✅ **Af volgens Rob, 11 nov ("Ja, af").** De punten met 👀 zag hij; de rest blijft open voor als hij ze tegenkomt.

Eerst `/reload`. In Forever:
- [ ] Muis op **Stringy Wolf Meat** of **Meaty Bat Wing** (tas of verkoper): onderaan de tooltip "MH: Used for Cooking".
      Groen met "(you have it)" als je Cooking hebt; grijs zonder als je het niet hebt. 👀 Rob, 11 nov: Stringy Wolf Meat
      groen "MH: Used for Cooking (you have it)". Nog niet gezien: de grijze regel (character zonder het beroep).
- [ ] Muis op **Linen Cloth**: meerdere beroepen achter elkaar, bv. "MH: Used for Blacksmithing, Engineering, Tailoring,
      First Aid (you have First Aid)". 👀 Rob, 11 nov (screenshot, Ima Pallie, Baganator-tas): groen "MH: Used for
      Blacksmithing, Engineering, Tailoring, First Aid (you have Blacksmithing, First Aid)". De gewone tooltip zegt
      zelf "Crafting Reagent" (blauw) maar niet waarvoor: onze regel leest dus niet dubbel.
- [ ] Muis op **Copper Ore**: "MH: Used for Mining" (omsmelten).
- [ ] Muis op iets wat geen ingrediënt is (Hearthstone, gear): géén "Used for"-regel. 👀 Rob, 11 nov: Hearthstone zonder
      regel; `/mh usedfor` zei "item 6948: not an ingredient in our list".
- [x] ❓ Zegt de gewone tooltip zelf al "Crafting Reagent"? Ja (GEZIEN bij Linen Cloth, 11 nov), maar niet waarvoor.
      Onze regel voegt het beroep toe; geen dubbele regel.
- [ ] `/mh usedfor` → aan/uit, hoeveel items in de lijst (524), welke beroepen de client van je ziet (met "line"-nummer:
      dat meet meteen of de beroepsnummers kloppen), en wat hij bij het laatste item besloot. `/mh usedfor off` / `on`.
      👀 Rob, 11 nov: "list: 524 items, Forever build 1.60.1.70888 … FIRSTAID (line 129), COOKING (line 185),
      BLACKSMITHING (line 164), MINING (line 186)". Daarmee zijn die vier skill-line-nummers GEMETEN in de client.
      Nog niet gezien: `off` / `on`.

## 🆕 11 nov — Melding: je pakte net een upgrade op (stap d, Forever én Midnight)

Eerst `/reload`. Gewoon spelen en spullen oppakken (loot, questbeloning):
⏳ Midnight, 12 nov: niet te testen op Robs Prot Paladin (gear al "heel erg hoog niveau", er viel niets beters). Beter op
   een alt die nog levelt.
- [ ] Komt er gear in je tas die **duidelijk beter** is dan wat je draagt: een kort bericht midden-onder op je scherm,
      bv. "Upgrade in your bags: [Snow Boots] — +3 Strength over what you wear (main stats for a Paladin)." Het
      verdwijnt na ~7 seconden; muis erop houdt het vast; slepen en Shift+scroll werken. Ook één regel in de chat.
      👀 Door Rob gezien in Forever, 11 nov ~21:00 (Ima Pallie, screenshot via de sparring-chat): "Upgrade in your bags:
      [Loose Chain Gloves] — +13 Armor over what you wear (more armor, no stat difference)." Rob zei "FYI :)"; of het
      zo goed is, nog niet gevraagd. Niet gezien: verdwijnen, vasthouden, slepen, de chatregel.
- [ ] Géén bericht bij: slechtere gear, gear die je niet kunt dragen (rode tekst), iets wat je bij een verkoper koopt,
      iets wat je zelf uittrekt.
- [ ] In een gevecht: het bericht komt pas als het gevecht voorbij is.
- [ ] Midnight: alleen bij hoger item level én betere score: "… item level 236 (+7) over <je oude item>."
- [ ] `/mh pickup` → wat MH bij het laatste item besloot en waarom. `/mh pickup off` / `on`.

## 🆕 11 nov — Forever: twee reparaties bij de verkoper (Rob: "Ja, allebei")

- [x] Bij een verkoper, muis op de **Blacksmith Hammer in de lijst van de verkoper** (kopen): GEEN rode regel
      "Right-click sells this…" meer. ✅ Rob, 11 nov (screenshot, Samuel Van Brunt). Nog niet gezien: met één hamer al in
      je tas, en het Buyback-tabblad.
- [x] Heb je precies één hamer en ga je met je muis op die hamer **in je eigen tas** (ook Baganator): de rode regel
      staat er wél. ✅ Rob, 11 nov (screenshot, Baganator, "Bags: 1").
- [ ] Een nieuw beroep leren zonder het gereedschap: de tip noemt het gereedschap bij naam (bv. "Blacksmith Hammer"),
      binnen een paar seconden, niet "(loading...)". Ook de chatregel komt dan met de naam.

## 🆕 11 nov — `/mh selftest`: MH loopt zijn eigen spelnummers na (stap c)

Eerst `/reload`, buiten een gevecht. Doe het één keer in **Forever** en één keer in **Midnight**:
- [x] Forever, eerste run (Rob, 11 nov): liep, maar de item-controle faalde (Forever zei "ja" tegen een verzonnen item).
      Gerepareerd: andere item-vraag, en een soort die faalt wordt alleen zelf overgeslagen.
- [x] Forever, tweede run (Rob, 11 nov, GEMETEN in SV): alle drie de controles OK, 0 ontbrekend van 1164.
- [x] Midnight (Rob, 11 nov, GEMETEN in SV, build 70783): 1093 nagelopen, alle drie de controles OK, 0 ontbrekend,
      0 uit gedeelde bestanden. Je ziet "selftest: checking … game numbers…" en
      daarna één regel: "all … numbers exist" of "… do not exist in this game: spell 123, …". Staat er "Not checked:
      item …", dan vertrouwt hij ook de nieuwe item-vraag niet — zeg het me. Daarna `/reload` zodat ik het rapport lees.
- [ ] Het scherm hapert niet (hij werkt in stukjes van 400).
- [ ] In een gevecht: "selftest: not during a fight."
- [ ] Doe daarna `/reload` en zeg het mij: dan lees ik het hele rapport uit je SavedVariables (`selftest`).
- [ ] `/mh prompt` (het kick/dispel-icoon): nu ook groter/kleiner met Shift+scroll (gevonden door de nieuwe vensterregel).
      ⚠️ 12 nov: niet te testen (Rob: "het is een soort switch … ik kan niet makkelijk even testen"). Daarom gebouwd:
      `/mh prompt test`, zie de testregel van 12 nov bovenaan.

## 🆕 11 nov — Forever: groene regel in de tooltip van gear (stap b)

Eerst `/reload`. In Forever, met gear in je tas die je kunt dragen:
- [ ] Muis op een stuk dat béter is dan wat je draagt: onderaan de tooltip een groene regel, bv. "MH: +3 Strength,
      +2 Stamina over what you wear (main stats for a Paladin)." (Pawn zet er misschien ook een regel bij; die van MH
      begint met "MH:".) 👀 Door Rob gezien in Forever, 11 nov ~21:00: "MH: +13 Armor over what you wear (more armor, no
      stat difference)." bij Loose Chain Gloves; klopt met de tooltip (48 tegen 35 Armor).
- [ ] Muis op iets slechters, op wat je al draagt, of op iets dat je (nog) niet kunt dragen (rode tekst): géén MH-regel.
- [ ] Werkt ook in je Baganator-tassen (het is de tooltip, niet de tas).
- [ ] `/mh geartip` → "gear tooltip line: on; last item you hovered: …" met de reden. `/mh geartip off` → regel weg;
      `/mh geartip on` → terug.

## 🆕 11 nov — De buff-melding is een zin (Forever én Midnight)

Eerst `/reload`. Op je paladin in Forever, zonder blessing:
- [x] Onder het buff-icoon staat in **goud, kleiner dan vroeger**: "Blessing of Might is not on you. Click the icon to cast
      it." Geen rood "MISSING" meer. ✅ Rob, 11 nov (screenshot, Forever paladin).
- [x] Het icoon staat op dezelfde plek als eerst. ✅ Rob, 11 nov.
- [x] Zonder aura: "No aura active: Devotion Aura. Click the icon to cast it." ✅ Rob, 11 nov (screenshot).
- [x] `/mh buffs` → "line under the icon: Blessing of Might is not on you. Click the icon to cast it." ✅ Rob, 11 nov.
- [ ] In een gevecht (alleen bij aura/pet): de zin eindigt op "Cast it from your bars." in plaats van "Click the icon".
      ❌/❓ Rob, 12 nov (Midnight, follower dungeon, Prot Paladin): in het gevecht verdween de melding helemaal, geen
      andere zin. Code (GEMETEN): `MissingBuff.lua:819` verbergt alles als `ns.Aura.Trusted()` false is
      (`C_Secrets.ShouldAurasBeSecret`). AFGELEID: in een dungeon-gevecht is dat zo. Rob koos *"Eerst meten"*.
- [x] 🆕 **Gebouwd 12 nov na Robs meting** ✅ Rob, 12 nov: "Het icoon blijft staan" (screenshot: "No aura active: Devotion
      Aura. Cast it from your bars.") (auras-trusted=false, GetShapeshiftForm=0 secret=false, in gevecht):
      `/reload`, dungeon (follower mag), Devotion Aura UIT, gevecht → het icoon BLIJFT staan met "Devotion Aura … Cast it
      from your bars." Gewone buffs (bv. een flask of Arcane Intellect) blijven daar wél zwijgen. Warrior: idem voor de
      stance. `/mh mbuff` in het gevecht zegt "only aura/stance reminders show".
- [x] 📏 **Meting (12 nov):** ✅ Rob, screenshot via sparring: "auras-trusted=false" en "GetShapeshiftForm=0
      secret=false inCombat=true". `/reload` eerst. In een dungeon (follower mag), aura UIT, en tijdens een gevecht `/mh mbuff`
      typen. Maak een screenshot van de chat. Belangrijk zijn twee regels: "→ icoon: … ShouldAurasBeSecret=… auras-trusted=…"
      en (nieuw) "→ form: GetShapeshiftForm=… secret=… inCombat=true". Geen `/reload` erna nodig.
- [ ] Krijg je ooit een **Greater Blessing** van een andere paladin: dan mag het icoon NIET om een blessing vragen.
- [x] Midnight (gewone WoW), een character dat een buff mist: dezelfde soort zin, met de naam van die buff. ✅ Rob, 12 nov
      (via sparring): "die is goed" (welke buff en welk character: niet gezegd).
- [ ] `/mh mbuff` doet iets (ook meteen na het inloggen).

## 🆕 11 nov — Forever: de pijl naar trainers en verkopers klopt beter

- [x] Undead Paladin, pijl naar **Aramis Hammerhand** (Deathknell): klopte pas nadat je hem had aangesproken (Rob, 11 nov).
      De eerste keer won de HandyNotes-plek ([stond in HandyNotes]) het nog van jouw meting; gerepareerd, zie hieronder.
- [ ] **Hertest (11 nov, ronde 2):** "Take me to my trainer" → de pijl wijst naar Aramis. ⚠️ Dat de reparatie zelf werkt, is
      bij Aramis niet meer te zien: zijn plek is al geleerd (voor het hele account) en die wint toch. Offline getest.
      Echt bewijs = een ándere trainer die je nog nooit sprak en die ook in HandyNotes staat: wijst de pijl goed?
- [ ] `/mh travel` in Forever zegt nu iets (eerst bleef hij stil): "travel: you are on …", hearthstone, "NPC places learned …".
- [ ] Binnen ~18 m van een trainer, wapentrainer of verkoper zegt de pijl erachter: "Je bent er: kijk om je heen, het is
      hier vlakbij."
- [ ] **Leren:** praat met een trainer of verkoper (venster open). Zet daarna (ook op een ander character) de pijl naar
      dezelfde NPC: hij wijst naar de plek waar jij toen stond. `/mh travel` → regel "NPC places learned …: <aantal>".
- [ ] 🔴 Meten voor later: na een speelavond kan ik de geleerde plekken uit je SavedVariables in de addon zetten.

## 🆕 11 nov — Forever: Paladin-Judgement en Druid-Claw

- [ ] Paladin, `/mh` → How you play: bij **Judgement** staat nu "werkt alleen als er een seal aan staat: zet eerst je
      seal aan (3)". 🔴 Meten: zonder seal op Judgement drukken → zegt het spel "You can't do that yet"? Met seal: werkt hij?
- [ ] Druid rond level 28 bij de trainer: Claw rank 2 vraagt nu om **Claw** (rank 1), niet meer om "Sharpened Claws".
- [ ] 🆕 **Spells uit een class-quest.** Trainervenster, blok "Eerst iets anders nodig": staat er een spell waarvan je de
      eerste rank nog niet hebt én die van een quest komt (bv. Paladin 24 zonder Redemption, Warrior 22 zonder Sunder
      Armor, Shaman 14 zonder Stoneskin Totem), dan staat erachter "(uit een class-quest, niet bij de trainer)".
- [ ] How you play: Paladin "Redemption (uit een quest)", Druid "Aquatic Form (uit een quest)", Priest: de twee
      ras-spells "krijg je uit een quest, niet bij de trainer".

## 🆕 11 nov — Forever: Enhancement Shaman blijft op Strength

- [ ] Forever, Shaman met het talent **Mental Dexterity**: bij een questbeloning wijst de tip nu het stuk met
      **Strength** aan, niet meer Intellect. (Zonder dat talent was het al Strength; dat blijft zo.)

## 🆕 11 nov — spelnamen in de zes talen (C4)

Alleen te zien op een Duitse, Franse, Spaanse, Portugese, Italiaanse of Russische client (Cisca of een tester). Op een
Engelse client verandert er niets.
- [ ] Duits: drankjes-soort heet nu **Heiltrank** (was "Gesundheitstrank"); de L00T RAID-R heet **Mini-B3U13RÄUB-R**.
- [ ] Duits: de achievement-groep heet **Das Labyrinth von Kindo'jan**. De delve-naam zelf blijft "Labyrinth von
      Kindo'jan" (die staat ook in een zin; bewust).
- [ ] Frans: tabblad **Comptoir**, kop **Boss hors instance**, drankje **Potion de soins**.
- [ ] Spaans: tabblad **Puesto comercial** en **Folio del Omnium**; drankje **Poción de sanación**.
- [ ] Portugees: **Chefe Mundial**, **Posto Comercial**, mount-plekken zonder lidwoord ("Terra Podre").
- [ ] Russisch: Field Accolades en drie ritueel-uitdagingen nu in het Russisch.
- [ ] Zoeken in het Duits op **Portalkammer** vindt de portaalkamer.

## 🆕 10 nov (avond) — Forever: de pijl kent boten, zeppelins, de tram en het roze portaal

- [ ] Forever, `/reload`, in Darkshore: `/mh weapons` → Two-Handed Maces → **Arrow** bij Buliwyf Stonehand (Ironforge).
      Verwacht: de pijl wijst naar de **boot naar Stormwind** in Auberdine (niet meer "travel back first"). Het venster zegt
      bij "The way there": *the boat to Stormwind City in Darkshore, then the Deeprun Tram to Ironforge in Stormwind City.*
- [x] **Horde, eerste stap** (Rob, 11 nov, Paladin in Tirisfal → Hanashi/Sayoc in Orgrimmar): pijl "the zeppelin to Durotar
      1162 m", venster "The way there: the zeppelin to Durotar in Tirisfal Glades". MH-doel 60.70, 58.76; zeppelin-pin op
      Robs kaart 60.04, 59.46 (< 1 kaartpunt, zelfde toren). Verder niet gereisd (geen Hearthstone).
- [ ] Horde verder: op de toren / in Durotar springt de pijl door naar Orgrimmar. (Rob: later, met een character mét Hearthstone.)
- [ ] 🆕 **Zonder Hearthstone** (11 nov gebouwd): Arrow naar iets over het water → één chatregel "This route crosses the
      water and you have no Hearthstone…"; het wapenvenster zegt het achter "The way there". `/mh travel` toont
      "hearthstone (item 6948): 0" en "no-hearthstone warning: YES". Mét Hearthstone: niets van dit alles.
- [ ] `/mh travel` → print waar MH denkt dat je bent ("land KAL"), het doel en de stappen. Stuur de regels bij twijfel.
- [ ] Op de boot / aan de overkant in Stormwind Harbor: de pijl schuift door naar de **tram-ingang** (Dwarven District).
      🔴 Meten: `/mh travel` op de pier in Stormwind — welke kaart zegt hij (verwacht Stormwind City 1453)?
- [ ] In Ironforge: de pijl wijst gewoon naar Buliwyf.
- [ ] Darnassus → iets in Darkshore: pijl naar het **roze portaal**, dan de boot in Rut'theran.
- [ ] Optioneel bij Menethil: is er een boot die **rechtstreeks** naar Auberdine gaat, of alleen die via Southshore?
- [ ] Fix "(loading...)" in het hengel-tipvenster: bij het volgende beroep zonder gereedschap (op een ander character)
      moet de naam van het gereedschap na een tel verschijnen, en de chatregel pas dan komen.

## 🆕 10 nov (middag) — Midnight: Macro's-tabblad met "Top" + knop Maken

- [x] Retail, `/reload`, MH → tabblad **Macro's**: eerste knop is nu **"Top"**. Bovenaan 5 knoppen = de 5 populairste
      macro's van je spec (Prot Paladin: kijk of ze kloppen bij wat je speelt). Titel = spellnaam in je clienttaal.
      ✅ Rob, 12 nov (via sparring): "is ook goed". Of de 5 bij zijn spel passen: niet gezegd.
- [ ] Kies er een: uitleg + de macrotekst met spellnamen. Klik **Maken** → chat "Macro "MH+ …" staat in de macrolijst";
      het macrovenster opent. 🔴 Werkt de macro? (niemand heeft deze al in het spel getest)
- [ ] De knop Maken werkt ook bij Interrupt en de andere soorten. Sinds 10 nov laat MH daar de spellnamen van je client
      zien (op een Engelse client verandert er niets; een Duitse/Franse tester zou "Zuschlagen" e.d. moeten zien).
- [ ] Een rij met een talent dat je niet hebt, verschijnt niet. Een spell die je nog niet kent: "Deze spell ken je nog
      niet …" en Maken staat uit.
- [ ] In gevecht op Maken: "Niet in gevecht …". Wissel van spec: de lijst wisselt mee.
- [ ] `/mh macrocheck` → onderaan per Top-macro "known/not known" + de tekst die hij zou maken.

## 🆕 10 nov (middag) — Forever: spec-macro's in Handige macro's (`/mh macros`)

- [ ] 🔴 Eerst meten (spec-herkenning is AFGELEID): typ in Forever
      `/run local T,c,p=C_Traits,C_ClassTalents.GetActiveConfigID(),{0,0,0} for _,n in ipairs(T.GetTreeNodes(T.GetConfigInfo(c).treeIDs[1])) do local i=T.GetNodeInfo(c,n) local b=min(3,floor(i.posX/4e3)+1) p[b]=p[b]+(i.ranksPurchased or 0) end print(unpack(p))`
      → drie getallen = je talentpunten per boom, links→rechts. Kloppen ze met je talentvenster?
- [ ] `/mh macros check` → regel "spec: 3 = Restoration (points per tree 0/0/5)" (of "none … [no points]" zonder talenten).
- [ ] `/mh macros`: onder het klasse-blok "Voor jouw spec: <naam>" met de macro's van je spec eerst, dan talent-macro's
      uit andere bomen die je hebt. Zonder talentpunten: geen spec-blok (of "Voor je talenten").
- [ ] Zet een talentpunt dat een spec-macro opent (bv. druid Restoration → Nature's Swiftness): de rij verschijnt vanzelf.
- [ ] Onder de kop staat grijs "Sommige teksten: classicwowforever.com (CC BY 4.0)."

## 🆕 10 nov — Forever: klasse-macro's in Handige macro's (`/mh macros`)

- [ ] Forever, `/mh macros`: onder de algemene macro's staat **"Voor jouw klasse: <klasse>"** met 5 macro's (Priest en
      Paladin: 4, tot je het talent Penance / Holy Shock hebt). De titel is de spellnaam in de taal van je client.
- [ ] Wat je nog niet kunt is grijs met "(vanaf level N)" of "Leer deze spell eerst bij je klassentrainer", en de knop is
      uit. Druid lvl 10: Healing Touch, Rejuvenation en Wild Buffs aan; Travel "(vanaf level 30)", Innervate "(vanaf level 40)".
- [ ] Klik **Maken** bij Healing Touch: in je macrolijst staat "MH+ Heal Touch". 🔴 Werkt hij op jezelf, op een vriend
      onder je muis, en met Ctrl de goedkopere Rank 4? (Niemand heeft deze macro's al in Forever getest.)
- [ ] Bij Travel (later, lvl 30): gele regel over de actiebalk na het wisselen van form. Blijft je gewone balk staan?
- [ ] Warrior: gele regel "twee keer drukken" bij Taunt/Overpower/Execute/Charge. Klopt dat in het spel?
- [ ] `/mh macros check` → "class DRUID: 5 class macros in the data" en per macro de tekst die hij zou schrijven.

## 🆕 10 nov — Forever: Wapentrainers (`/mh weapons`)

- [ ] Druid (Night Elf, lvl 10): `/mh weapons` opent "Wapentrainers". Links: Maces, Two-Handed Maces, Polearms
      "(level 20)", Staves, Daggers, Fist Weapons — in de taal van je client. Wat je al kent (Staves, Daggers?) is grijs
      met "(ken je)". 🔴 Klopt "ken je" bij elk wapen? (AFGELEID dat MH dat kan lezen) — zo niet: `/mh weapons check`.
- [ ] Klik Maces: rechts **Buliwyf Stonehand**, Ironforge, "andere continent", en eronder "Zo kom je er: … portal …
      boot … boot … Deeprun Tram". Bovenaan "Het kost 10 zilver".
- [ ] Klik "Pijl": de pijl wijst naar Ironforge (en een kruis boven hem als je er bent). Praat met hem: pijl weg.
- [ ] Bij Buliwyf (of een andere weapon master): open zijn menu, dan `/mh weapons check` → "measured Buliwyf Stonehand
      … N rows". Zo leert MH wat hij écht leert.
- [ ] Startpagina (Forever): onder de trainer-knoppen "Je kunt nu 2 nieuw(e) wapen(s) leren" + knop Wapentrainers.
- [ ] Ik-kamer en Tools → Losse vensters: tegel/kaart "Wapentrainers" (icoon: een mace).
- [ ] Na het leren van Maces: het venster zet Maces op grijs "(ken je)".

## 🆕 10 nov — Forever: tegels voor Handige macro's en Waar koop ik dit?

- [ ] Forever, MH open, klik **Ik** in de zijbalk: twee nieuwe tegels **"Handige macro's"** (briefje) en **"Waar koop ik
      dit?"** (muntje), na Beroepstrainers. Muis erop = een zin uitleg; klik = het venster gaat open.
- [ ] Klik **Tools** in de zijbalk, dan de tegel **"Losse vensters"**: dezelfde twee kaarten staan erin, met `/mh macros` en
      `/mh vendor` erbij. "Open" opent het venster.
- [ ] Retail: de Ik-kamer en "Losse vensters" zien er hetzelfde uit als gisteren (geen nieuwe tegels).

## 🆕 9 nov — Forever: "Deze week in Forever"

- [ ] Forever, MH open, startpagina: links in de zijbalk en in de Ik-kamer heet hij nu **"Forever"**, niet "Deze week".
      De kaart in de Ik-kamer zegt "Reset over …".
- [ ] Op de startpagina een blok **"Deze week in Forever"**: "Nieuwe week over …" en "Nieuwe dag over …" met tijden
      die kloppen (woensdag ochtend?), de Darkmoon Faire (tot 16 nov) met een zin uitleg, "De raids gaan open op
      9 december", en de regels over PvP en writs.
- [x] Typ `/mh week`: hij print de resettijden, de kalender van vandaag (titel, type, id) en de raids. ✅ 9 nov: week
      en dag rond 05:00 servertijd, Darkmoon Faire + Call to Arms: Arathi Basin, 0 raids.
- [ ] Woensdag 11 nov na de reset: telt "Nieuwe week" weer van ~7 dagen af?
