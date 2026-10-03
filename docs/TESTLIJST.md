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

## 🆕 3 okt — 8 overige dungeons: nieuwe korte tips (7 talen)

- [ ] Group Finder → Dungeons: kun je **Windrunner Spire** en **Maisara Caverns** nog op Heroic of Mythic kiezen, of
  alleen Normal/Followers? (Wowhead zegt alleen Normal.)
- [ ] Seat of the Triumvirate op Normal of Heroic: heeft Saprish echt maar **één** pet (geen Shadewing)?
- [ ] Open de dungeontips van een van deze bazen in MH: staan de korte tips er netjes, met maximaal 3 regels?

## 🆕 3 okt — delve-foutjes (in `main`, nog niet uitgebracht)

- [ ] Delve-tooltip: hover in het Delves-tabblad over een delve die **niet** Bountiful is. Staat er bij de tiers géén
  "End …" meer, en onderaan een blauwe regel *"End-chest numbers only apply to Bountiful delves…"*?
- [ ] Delve-tooltip: hover over een **Bountiful** delve. Staat "End 266 … End 295" er nog wel, en is de blauwe regel weg?
- [ ] Delve-tooltip: staat er in de Vault-kolom overal "Vault ?" (geen "Vault 305*" meer bij Tier 1)?
- [ ] Weekoverzicht (This Week / Account snapshot): is de regel *"Delver's Call incomplete on alts"* weg? De regel
  *"Delver's Call banked on alts"* mag blijven als een alt quests bewaart.
- [ ] Collegiate Calamity: zegt de route-regel in chat nu **Luminbulb** (zonder i)?

## 🆕 2 okt avond — 4.5.0: delves + Valeera, solo-schakelaar, Speed Grade weg

Rob: *"delfpagina's is goed, want ik vertrouw op jou"*. 54 teksten (enUS/nlNL; 162 vertalingen waar al een
vertaling bestond — delves die in de/fr/es/pt nooit vertaald waren blijven Engels, zoals vóór vandaag).
- [ ] `/reload` zonder fout (BugSack leeg).
- [ ] **Instellingen → Window → "Ik speel vooral solo"** aan: op Home verdwijnen de blokken Mythic+ en Raids, en
      er staat een grijze regel *"Solo-stand: Mythic+ en raids zijn verborgen…"*. Uit: alles weer terug.
- [ ] Delve-tooltip (Delves-tab, hover een rij): géén *"MidnightHelper: Speed Grade"* meer.
- [ ] Survey-uitnodiging zegt nu *acht* vragen; op de site staat vraag 8 *"Anything else you want to tell us?"*.
      Stuur hem één keer zelf in en kijk of de mail een blok *"Verder nog:"* heeft.
- [ ] Kaartlabels in `{WAY:}`: in de/fr/it staat nu het Engelse label (bv. *Sturdy Chest 1*), in es/pt vertaald.
      Alleen als het een Duitse/Franse speler stoort.
**Vragen uit de delve-review — niets veranderd, jij bent de meting:**
- [ ] The Shadow Enclave: Shadow Enclave, Infiltrate and Ameliorate: zie je daar ook zwevende Eyes of Antenorian? Ja = de Eyes-regel mag voor alle varianten behalve Mirror Shine gelden; nee = zo laten.
- [ ] The Shadow Enclave: Shadow Enclave, Traitor's Due of Shadowy Supplies: heet de zware shadow-cast van de Twilight Ogre Mage 'Sullen Shadowball' en kun je hem kicken? Ja = regel klopt; andere naam = die naam doorgeven.
- [ ] Collegiate Calamity: Collegiate Calamity, Academy Under Siege: zegt de tracker 'Arcane Wards activated 0/4'? Ja = nieuwe ROUTE klopt; staat er iets over portals = melden.
- [ ] Collegiate Calamity: Collegiate Calamity, Faculty of Fear: vallen onthulde studenten je zelf aan ('ambush')? Ja = regel blijft; nee = 'vóór de ambush' kan weg.
- [ ] Collegiate Calamity: Collegiate Calamity, boss: helpen de studenten in 12.1 nog mee, en zitten ze bij Garand aan het begin vast in een paarse cirkel? Ja = nieuwe BOSS-regels kloppen; nee = die twee regels schrappen.
- [ ] The Darkway: The Darkway: wie cast Twilight Seekers, trash of alleen Infiltrator Gulkat? Alleen Gulkat = 'Twilight Seekers' kan uit de TRASH-regel; ook trash = zo laten.
- [ ] The Darkway: The Darkway, Eggsplosive Growth: verdwijnen er eieren als je een Venom Clogged Ley Line reinigt, en zegt de tracker 7 / 45? Ja = nieuwe ROUTE klopt.
- [ ] The Darkway: The Darkway: moet je bij Shadowfuse Sentinels een cast kicken (Method noemt Discharge, een grote cirkel)? Ja = naam van de cast doorgeven, dan komt er een TRASH-regel bij.
- [ ] Parhelion Plaza: Parhelion Plaza, Caustic Crush: wat gebeurt er aan het eind? Alleen de Ritual Pillar = MH klopt; verschijnt er ook Replicating Venomborne (Icy Veins zegt dat) = dan krijgt BOSS de Venomborne-regels die al bij The Darkway staan.
- [ ] Parhelion Plaza: Parhelion Plaza, Caustic Crush: heeft de Ritual Pillar zelf aanvallen (het is in de DB2 een eigen 'encounter')? Ja = beschrijf wat je zag, dan komt er een BOSS-regel bij.
- [ ] Parhelion Plaza: Parhelion Plaza: klopt de ingang (torengebouw, tweede verdieping, trap omlaag)? Ja = nieuwe OVERVIEW-regel blijft.
- [ ] Atal'Aman: Ritual Interrupted: komt er na het redden van de furbolgs een stap bij Nalorakk's Shrine met golven vijanden? Ja = nieuwe ROUTE-regel 2 klopt. Nee = die regel eruit.
- [ ] Atal'Aman: Totem Annihilation: zie je bliksemcirkels op de grond die snel afgaan? Ja = nieuwe TRASH-regel klopt. Nee = eruit.
- [ ] Atal'Aman: Jin'Ma: loop meteen na Flaying Knife naar je spirits. Gaan ze dood of krijgt Jin'Ma een buff? Ja = de 6-secondenregel klopt.
- [ ] Atal'Aman: Disciple of Vashnik: ga achter een schedelbeeld staan als hij Toxic Froth doet. Krijg je het gif toch = 'helpt niet meer' klopt. Krijg je het niet = die zin moet eruit.
- [ ] Atal'Aman: Toadly Unbecoming: vallen beesten de gehexte Amani aan? Nee = TRASH-regel 'Beasts weg van NPCs' schrappen.
- [ ] Atal'Aman: Venomous Vapors: DB2 heeft een stap 'Tunnels exited' (CriteriaTree 222621) die de tip niet noemt. Wat moet je daar doen (springen met de Springstep Rune?)? Zeg het, dan komt er een route-regel bij.
- [ ] Twilight Crypts: Blademaster Darza: blijf op een lage tier vlak bij haar staan als ze Bask in the Twilight doet. Raakt het je hard = nieuwe regel 'ren 10 yards weg' klopt. Raakt het je niet = de regel moet anders.
- [ ] Twilight Crypts: Loosed Loa: zie je Mot'amra rood door de muren heen, en maakt het Evasive Elixir je 4 seconden een pot? Ja = nieuwe ROUTE-regels kloppen.
- [ ] Twilight Crypts: Party Crasher: casten de Twilight Summoners iets dat je kunt onderbreken? Nee = TRASH-regel 3 aanpassen.
- [ ] Twilight Crypts: Zie je in de crypten Fleshwarped Abominations die zich healen (Reconstitution) en Hexbound Necrowraiths met Necrotic Bolt? Ja = nieuwe TRASH-regels kloppen.
- [ ] The Gulf of Memory: Stap in een cirkel op de vloer (geen kaarslicht). Word je opgetild en gestund door een Sapstick Lurker? Ja = nieuwe TRASH-regel klopt.
- [ ] The Gulf of Memory: Mul'tha'ul: zet Valeera op healer. Haalt ze Hopeless Curse van je af? Ja = nieuwe regel klopt. Nee = regel eruit.
- [ ] The Gulf of Memory: Kies in de coach Mul'tha'ul (Descent of the Haranir): staan de Searing Light- en Sporbit-regels er nog tussen? Met de nieuwe tekst horen ze weg te zijn; staan ze er wel, dan is het filter de oorzaak.
- [ ] The Grudge Pit: Fungal Pharmacon: welke stappen toont je tracker? DB2 (live) heeft twee versies: (a) 3 Ula'tek Burrows in + 4 Lesser Ritual Pillars + slangen killen, of (b) 10 Pharmacon verzamelen + 4 pillars + vijanden. Zeg welke, dan maken we de route precies. Staan de pillars níét in de burrows, dan moet 'go down into the Ula'tek Burrows' anders.
- [ ] The Grudge Pit: Lightbloom Invasion: blaas je de 3 Unstoppable Thornmaws op door op Bomb Spores (of tonnen) te klikken? Ja = nieuwe regel klopt. Blazen bevrijde fighters ook spawn points op (zoals Icy Veins zegt), dan komt dat er weer bij.
- [ ] The Grudge Pit: Dastardly Rotstalk: werkt taunten alleen in een van de bewegende spotlights? Ja = nieuwe regel klopt.
- [ ] The Grudge Pit: Dastardly Rotstalk: doen de Angry Fans pijn als je ze negeert? Nee = TRASH-regel 3 aanpassen.
- [ ] The Grudge Pit: Zie je ooit een Disciple of Vashnik in de Grudge Pit? DB2 heeft daar een encounter (3522), maar geen verhaal eindigt bij hem; waarschijnlijk ongebruikt. Nee = niets doen.
- [ ] Sunkiller Sanctum: Esuritus: lees de castbalk van de bolt die hij op je richt. Heet hij Calling Bolt of Singular Bolt, en lukt een interrupt? Lukt het = de bullet 'Interrupt Calling Bolt' blijft, maar check of de tooltip in de coach 'Instant' zegt (dan hoort er een andere id bij). Lukt het niet = de bullet moet weg.
- [ ] Sunkiller Sanctum: Esuritus: onderbreek of stun een Voidcaller terwijl hij channelt. Gaat hij meteen dood? Ja = waardevolle tip om toe te voegen (alleen de video van Roguery zegt dit). Nee = niets doen.
- [ ] Sunkiller Sanctum: Gravitational Effect: zijn het precies 5 coils in de lucht en 5 Stabilizers op de grond? Ja = nieuwe ROUTE-tekst klopt. Ander getal = getal aanpassen.
- [ ] Shadowguard Point: Chief-Arcanist Patram: hoe heet de add die na Dark Communion verschijnt (Icy Veins: Void Emissary, Method: Dark Harbinger)? Naam gezien = die naam in de BOSS-bullet zetten.
- [ ] Shadowguard Point: Chief-Arcanist Patram: lukt een interrupt op Submit to the Void? Ja = nieuwe bullet klopt. Nee = 'Interrupt it' weghalen; de tooltip zegt Magic, kijk dan of een dispel hem weghaalt.
- [ ] Shadowguard Point: Disciple of Vashnik: ga tijdens Toxic Froth achter een muur of pilaar staan. Krijg je toch de volle 8 seconden schade, en liggen er daarna healing orbs? Allebei ja = bullet blijft. Muur helpt wel = die zin schrappen. Geen orbs = 'pak daarna de healing orbs' schrappen.
- [ ] Shadowguard Point: Disciple of Vashnik op Tier 11: vind jij hem de zwaarste delve-baas van dit seizoen? Nee = de zin over 'many players' schrappen (Icy Veins noemt hem 'not too bad').
- [ ] Shadowguard Point: Captured Wildlife: krijg je na de kooien echt aas van Lysikas, met een extra knop bij de Void Researchers? Ja = nieuwe ROUTE-bullet klopt.
- [ ] Torment's Rise: Vlieg naar de ingang van Torment's Rise in Voidstorm (61.2, 71.3) en loop de rookmuur in. Kom je binnen bij Nullaeus? Ja = de nieuwe BOSS-tekst is nuttig en de kaart blijft. Je wordt naar Silvermoon gezet (zoals een speler op 13 aug meldde) = de hele kaart is seizoen 1-geschiedenis; kies dan of hij weg mag of alleen de OVERVIEW houdt.
- [ ] Torment's Rise: Heb je nog een Beacon of Hope in je tassen: kun je hem in een delve nog gebruiken? Ja = de ROUTE-bullet moet zeggen wat hij nu oproept. Nee = de nieuwe ROUTE-tekst klopt.
- [ ] Torment's Rise: Alleen als je binnenkomt: probeer Devouring Essence te onderbreken. Lukt het = je kunt 'Dispel it' aanvullen met 'or interrupt it' (Icy Veins zegt ja, Method zegt nee).
- [ ] Venomfall Deeps: Ga solo naar binnen in Venomfall Deeps en typ /mh mark vóór de pull. Verschijnt de markerbalk en kun je 4 world markers neerzetten? Ja: de tip klopt zoals hij staat. Nee: de balk wacht op een groep (FastMark.lua vraagt IsInGroup), en de BOSS-tip moet dan Blizzards eigen world markers noemen in plaats van /mh mark.
- [ ] Venomfall Deeps: Klik de nieuwe waypoint 51.2, 31.0 op de Coiled Isle. Kom je bij de deur van Venomfall Deeps uit? Ja: waypoint mag erin. Nee: noteer waar de deur echt staat (/mh here buiten de deur).
- [ ] Venomfall Deeps: Haal Blessing of Potency uit een zware kist en lees de tooltip van de buff. Staat er 'all of your stats'? Dan klopt de nieuwe tekst. Staat er 'secondary stats'? Dan was de oude tekst goed en vervalt deze correctie.
- [ ] Gnarldor Isle: Sturdy Chest 3 in Gnarldor Isle: staat de kist bij onze pijl (28.67, 41.69) of zo'n 3 eenheden noordelijker (rond 28.4, 38.2, 'achter blokken links van de trap naar boven' volgens Icy Veins)? Bij onze pijl: laten staan. Noordelijker: waypoint aanpassen naar wat /mh here bij de kist zegt.
- [ ] Gnarldor Isle: Minchi's Osseous Adventure: wat staat er in het doel bij de bottenhopen, 0/4 of 0/6? 0/4: de nieuwe tekst klopt (hotfix eind augustus). 0/6: de hotfix is teruggedraaid en de oude tekst was goed.
- [ ] Gnarldor Isle: Gralka met Valeera op DPS: onderbreekt ze Purging Breath, en wat gebeurt er dan? Onderbreekt ze hem en ga je dood of komt er iets ergs: de nieuwe Healer-regel klopt en verdient misschien de reden erbij. Onderbreekt ze hem niet: de nieuwe regel kan weg.
- [ ] Gnarldor Isle: Bij Scrollmaster Ruma bij de ingang: geeft ze It's a Satchel, Not a Bag, en ligt Ruma's Satchel binnen op 25.40, 34.73? Ja: de nieuwe OVERVIEW-regel klopt. Nee: noteer welke quest ze wél geeft.
- [ ] The Ring of Glory: Crushfoot (Open Night): zie je in de toren noordoost en zuidwest een blauw gloeiende bol die je naar de andere toren teleporteert, en stopt het zijn charge als je erin stapt? Ja: de zin 'dat hebben wij zelf niet getest' mag eruit. Nee: laten staan zoals hij is.
- [ ] The Ring of Glory: Gnok, eerste fase (Adopt-a-thon): wat doet Pulverize? Gooit hij je weg en vertraagt hij je (Icy Veins), of is het alleen een klap (Method)? Wegslaan: er hoort een regel bij ('vecht hem waar de knockback je niet in een pack gooit'). Alleen een klap: niets toevoegen.
- [ ] Valeera/systeem: Delves-tabblad, beweeg over een delve-rij: staat er bij Tier 1, 6 of 7 'Vault 305*'? Volgens Wowhead hoort dat 279, 298 en 302 te zijn. Kijk ook wat de drie vault-vakjes tonen ('Tier X (ilvl Y)') in een week waarin je een Nightmare Prey-hunt deed.
- [ ] Valeera/systeem: In een delve met Valeera's venster open: dood één vijand en loot NIETS. Gaat 'XP tot nu toe' omhoog? (test voor 'doden telt ook')
- [ ] Valeera/systeem: Doe een Tier 11-delve die NIET Bountiful is, met levens over, op Delver's Journey rank 4 of hoger. Verschijnt er een Gilded Stash in de schatkamer?
- [ ] Valeera/systeem: Doe een gewone (niet-Bountiful) delve op Tier 4 of hoger en kijk naar het item level uit de eindkist. Blijft dat op het Tier 3-niveau (272 of lager), zoals Icy Veins zegt?
- [ ] Valeera/systeem: Hover bij de ingang van een delve op Tier 11 over het Gilded Stash-icoon: staat er 'x/4' per week?
- [ ] Valeera/systeem: Kijk op de kaart hoeveel Special Assignments je deze week kunt doen, over alle zones samen. Klopt 3?
- [ ] Valeera/systeem: Kill een rare in Eversong of Zul'Aman (niet Coiled Isle) en lees /mh shards: hoeveel shards gaf hij (25, 50 of 75)?

## 🆕 2 okt middag — Mythic+ voor beginners (Codex + `/mh mplus`, enUS + nlNL)

Rob: *"ik keur het goed"* (pagina `mplus_review.html`). Nu in 7 talen; knopnamen komen uit de client zelf (Rob koos
"uit het spel zelf"): `{UI:NAAM}` in de tekst wordt Blizzards eigen woord, Engels als terugval.
- [ ] `/reload` zonder fout (BugSack leeg).
- [ ] **`/mh uinames`**: 10 regels. Staat er achter elke naam het Engels dat je op je scherm ziet (Dungeons & Raids,
      Premade Groups, Start a Group, List Group, Sign Up, Mythic+ Dungeons, Activate, Guild Finder, Mythic+ Rating,
      **Learning**)? Rood "missing" = die naam bestaat niet in jouw client. ⚠️ Vooral **Learning**: dat
      `GROUP_FINDER_GENERAL_PLAYSTYLE1` Learning is (en niet Relaxed) is AFGELEID uit de volgorde, niet gemeten.
- [ ] `/mh codex` → **Dungeons & M+**: staat bovenaan *"Mythic+, vanaf je eerste key"*, en staan de knopnamen er netjes
      in (geen `{UI:…}` meer zichtbaar)?
- [ ] Niet-getokeniseerde schermwoorden zijn in de/fr/es/pt/it door de vertalers gekozen, NIET in een client gezien:
      *Find a Community*, het venster *Guild & Communities*, de categorie *Dungeons* en de moeilijkheid *Mythic*. Pas
      als iemand met zo'n client meekijkt.
- [ ] Zoekvak: typ *first key* of *premade* → vindt hij het hoofdstuk?
- [ ] Op een personage **zonder** M+-runs dit seizoen: `/mh mplus` toont onder "Nog geen keystone-runs" een gele regel
      *"Nog nooit een key gelopen? Typ /mh codex en open Dungeons…"*. Met runs hoort die regel er NIET te staan.
- [ ] `/mh mplus` onderaan: de gear-regel zegt nu *"De kist aan het eind gaat van Champion naar Hero; alleen de Great Vault
      geeft Myth, vanaf +10."*
- [ ] Group Finder → Start a Group: heet het keuzevak echt **"Select Playstyle (required)"** met **Learning** erbij?
      (Naam komt uit build 12.1.5 op wago.tools, niet uit live 12.1.0.)
- [ ] Silvermoon: waar staat **Lindormi** precies? Bronnen zeggen 42.1, 58.8 (wiki) óf 53.3, 66.1 (Icy Veins). Het
      hoofdstuk zegt nu alleen "naast het portaal naar The Timeways".

## 🆕 2 okt middag — 8 M+-dungeons (korte tips) + lange raidtips (7 talen)

Rob keurde beide pagina's goed. Dungeons: VA, BV, AF, TS, RL (13 tips) + DN, MR, KR (10 tips). Raid: 29 lange teksten
(`_STEPS`/`_TANK`/`_HEALER`/`_DPS`).
- [ ] `/reload` zonder fout.
- [ ] Bij je volgende M+-run: klopt de korte tip van die dungeon? Zeg per baas wat niet klopte.
- [ ] **Den of Nalorakk, Nalorakk op Heroic:** springt Zul'jarra achter de tank met een schild, en raken de drie klappen
      dan iedereen? (De 12.1-journal zet dit deel alleen op Mythic. Ja = tip klopt overal; nee = er komt "Op Mythic:" voor.)
- [ ] **Kings' Rest, Mchimba (de-/fr-/es-/pt-/it-client, als je iemand kent):** hoe heet de knop om uit de kist te komen?
      Alle vijf vertalingen zeggen nu "Struggle" in het Engels.
- [ ] **Afgeleid, niet gemeten** (de helper zei het zelf): de nieuwe Mythic-regel bij **Vaelgor** (*"de draken vliegen nog
      op, Astral Reflection-klonen blijven casten"*) en de DPS-zin bij **Averzian** (*"de soak stopt twee Voidshapers"*).
**Vragen uit de lange raidtips — niets veranderd, jij bent de meting:**
- [ ] Entombed Sentinels, Normal, pauze: twee spelers raken elkaar aan onder de 4 groene bollen — worden ze alleen uit
      elkaar geduwd (tekst klopt), smelten de bollen samen (zin anders), of gaat er iemand dood (zin eruit)?
- [ ] Vashnik, Caustic Explosion na een dispel: zelfde schade dichtbij en ver weg (dan mag "step away" weg) of minder ver
      weg (tekst klopt)? Kijk in Details.
- [ ] Vashnik, Dripping Fangs (tank): staat er 100% (klopt "verdubbelt") of 200% meer fysieke schade?
- [ ] Twin Fangs, Normal, Ravenous Feast: straf als er minder dan drie in een klap staan? Geen straf = die zin kan weg.
- [ ] Twin Fangs, Normal, Ravenous Feast: tel je Eternal Venom-stacks vóór en na alle drie de klappen (1 minder = per
      Feast, 3 minder = per klap).
- [ ] Coiled Altar, Normal, Gloombomb: laten óók niet-gemarkeerde geraakte spelers zielkopieën vallen (Gravebound)?
- [ ] Coiled Altar, Normal, Eternal Nightfall: stopt de cast vanzelf als het schild breekt, of moet er nog een kick?
- [ ] Vorasius: staat de stack Primordial Power na een Roar op JOU (raid-DoT) of alleen op de BAAS?
- [ ] Vaelgor & Ezzorak, Normal: krijgt iemand Shadowmark in de intermission? Ja = hoort bij alle moeilijkheden.
- [ ] Vaelgor & Ezzorak, Normal: grote klap op de raid bij de laatste Nullzone-tether (oude tekst klopte) of kleine tik?
- [ ] Crown of the Cosmos, Normal, eerste tussenfase: debuff na een pijl (8 s, meer pijlschade)? Ja = geldt ook op Normal.
- [ ] Belo'ren, healer: krijgt IEDEREEN de heal absorb + DoT, of maar een paar spelers?
- [ ] Belo'ren, tank: krijgt de baas een stack als de frontal de tank van de VERKEERDE kleur raakt?
- [ ] Chimaerus, healer: duurt Caustic Phlegm ±12 s (tekst klopt) of ±20 s?
- [ ] Chimaerus, Consume (100 energie): heeft dicht op elkaar staan nut?
- [ ] Chimaerus, na de soak: blijf je in dezelfde zaal (dan worden "boven/omlaag" herschreven) of ga je echt omlaag?

## 2 okt — 17 raidbazen: nieuwe korte tips (extra high-ronde, `RaidTips.lua`, 7 talen)

Rob: *"alles goed, zet ze er maar in"* (beoordeeld op https://claude.ai/artifact/CWjDGP9K3dqGtsjoZGMgCz).
- [ ] `/reload` zonder fout (BugSack leeg).
- [ ] Bij je volgende raid: staat in het tipvenster bij de pull het nieuwe korte blok? Herkenbaar voorbeeld:
      Chimaerus begint met *"Soak: A circle appears on the tank. When it is your group's turn, all of you stand in it
      at once."* De Twin Fangs-tip is ook herschreven.
- [ ] Klopt het advies in het gevecht zelf? Zeg per baas wat niet klopte — jij bent de meting.
- [ ] Past het blok nog in het venster? De nieuwe tips zijn soms langer (tot 2 zinnen per regel).

## 1 okt — Twin Fangs-tip: de draaiende gifstraal (`RaidTips.lua`)

- [ ] Open de tips van de Twin Fangs (Raids → Venomous Abyss, of het tipvenster bij de pull): staat er onderaan
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
- [ ] Goud, rested XP, spec en gear verschijnen pas bij een character nadat je er **één keer op hebt ingelogd** (oudere
      records tonen een streepje). Klopt dat bij een alt die je nog niet opnieuw opende?
- [x] ✅ (Rob, 1 okt: "die kloppen") **Beroepen:** de getallen uit `GetProfessionInfo` komen overeen met het
      beroepenvenster — GEMETEN.
- [ ] Veel characters: verschijnen < en > met "1-5 van 9", en bladert het?

## 🆕 1 okt — vragenlijst: uitnodiging in het spel (`SurveyInvite.lua`)

- [ ] `/reload`, dan `/mh survey` → het kopieervenster met **midnighthelper.com/survey/?from=game** (in het Nederlands
      `/nl/survey/`). Plak de link in je browser: opent de vragenlijst?
- [x] ✅ (Rob, 1 okt, screenshots: "alles goed") `/mh survey popup` → de pop-up zoals spelers hem zien, met drie knoppen: *Show the link* / *Later* / *No thanks*.
      Doen alle drie wat ze zeggen? (Later = chatregel; No thanks = kaartje op This Week weg.)
- [ ] `/mh survey why` → zegt het of de pop-up zou verschijnen en waarom niet. Open This Week: staat er een kaartje
      *"Two minutes for Midnight Helper?"*?
- [x] ✅ (Rob, 1 okt 23:09, screenshot) Zelf ingevuld via de link uit het spel → mail *"[MH vragenlijst] cijfer 5 ·
      en · via game"* met alle antwoorden en de `DATA:`-regel; site toont *"Thank you!"*. Hele keten GEMETEN.

## 🆕 1 okt — debug-regel weg (CurseForge-reactie)

- [ ] Log in (of `/reload`) op een character **zonder beroepen**, of open MH → beroepen: er staat géén
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
- [ ] Site: midnighthelper.com/raidbots (en /nl/raidbots) → 7 stappen met gouden nummers en een oranje testfase-blok;
      Armory → Best set → knop *Step by step* gaat erheen.

- [ ] `/reload`, `/mh raidbots` → venster *"For Raidbots Top Gear"*, chat *"Raidbots text ready, with N item(s)…"*.
      Bovenaan `paladin="Twelveinchy"`, `spec=protection`, een regel `talents=…` (lange code), dan per slot
      `head=,id=…,bonus_id=…`, onder *### Gear from Bags* de tas-items met `# ` ervoor, onderaan `# Checksum: …`.
- [x] ✅ (Rob, 30 sep avond, screenshot) Raidbots leest het: Twelveinchy, 90 Blood Elf Protection Paladin, Khadgar (EU),
      talenten, gear-iconen, ilvl 282, set *Radiance of the Consecrated Flame*, Omnium Folio-sectie. Labels: *Unverified
      Input* (tekst komt niet van de SimC-addon zelf — we doen bewust niet alsof) en *Tank* (Raidbots' eigen tank-waarschuwing).
      ⏳ Nog: tas-items aanklikken → Find Top Gear (eerste poging: "requires at least two combinations" = niets aangeklikt).
- [ ] Ctrl+C → raidbots.com/simbot/topgear → plakken. **Dé test:** leest Raidbots hem zonder foutmelding? Klopt je
      karakter (naam, spec, talenten, item levels)? Staan je tas-items als keuze klaar? Screenshot, of plak de
      foutmelding van Raidbots letterlijk.
- [ ] Zelfde op de Shaman (staf) en op een alt met een crafted item (dan staat er `crafted_stats=` in de regel).
- [ ] Site → Armory → Best set: onderaan het blok *"Want the exact answer…"* met de knop *Open Raidbots Top Gear*.

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
- [ ] **In een M+-key** (de echte krappe pot): *"Battle res: 1 of 1 left"* of zo, en na een brez *"next in m:ss"*. Daarna
      `/mh lust` + `/reload`. En: welke raid/difficulty gaf 99 ladingen? (vanaf nu staat de difficulty in de log)
- [x] ✅ (Rob, 1 okt, screenshot in LFR op de Shaman) titel *"Battle res & Hero"*, spreuknaam per speler
      (Intercession, Rebirth, Primal Rage), **gemengde factie GEMETEN**: Earthshammy (Horde) *Bloodlust*, Ferosta
      (Alliance) *Heroism*; eigen regels *Ancestral Spirit (out of combat): 0* en *Bloodlust: 5*.
      Oorspronkelijke test: (Rob, 30 sep avond: "wordt gewoon hero genoemd … voor elke spec zijn eigen naam") `/reload`, `/mh lust test`
      → titel *"Battle res & Hero"*, regels *"Hero: ready"*, *"Can cast Hero: Twelveinchy…"* ontbreekt (Paladin kan geen
      Hero) maar *"Can revive in combat: Twelveinchy (Paladin) - Intercession"* staat er met de spreuknaam. Op de Shaman:
      *"Earthshammy (Shaman) - Heroism"* (Alliance) of *Bloodlust* (Horde). Beweeg erover: uitleg begint met *"Hero (Bloodlust,
      Heroism, …)"*.
- [ ] 🆕 (Rob, 30 sep: "waarom niet in een delve als we met meerdere zijn … en de normale res buiten combat")
      Nu in **elke groep** in een dungeon, delve of raid. Test: ga met iemand een **delve** of **normale dungeon** in →
      het paneel staat er vanzelf, met *"Battle res: no shared charges here - everyone has their own cooldown."* Op
      Twelveinchy staat nu ook *"Redemption (out of combat): Your key: …"* onder Intercession. Klopt die toets?
- [ ] Instellingen → Dungeon-hulp → **Only in Mythic+ keys and raids** aan → in de delve/normale dungeon verdwijnt het
      paneel, `/mh lust` zegt *"…the setting says Mythic+ keys and raids only"*. Weer uit → het is terug.
- [x] ✅ (Rob, 30 sep avond, screenshot: X rechtsboven zichtbaar, "beide werken"; het wegblijven tot de volgende
      instance nog niet apart gezien) 🆕 (Rob, 30 sep: "sluit knop") Rechtsboven op het paneel een **X**. Muis erop → uitleg. Klik in een dungeon → het
      paneel is weg, ook na `/reload` in dezelfde dungeon; `/mh lust` zegt *"closed with the X for this instance"*.
      Dungeon uit en een nieuwe in → het staat er weer.
- [ ] Beweeg erover → uitleg over beide. Slepen → het blijft daar staan na `/reload`.
- [ ] Instellingen → Dungeon-hulp → **Paneel battle res & Bloodlust** uit → `/mh lust` zegt *setting off*.
- [ ] **In een M+-key of raid, in een groep** (hier zit de echte meting): het paneel staat er vanzelf. In de key:
      *"Battle res: 1 of 1 left"* (of meer), en na een brez *"… next in m:ss"*. Kreeg de groep Bloodlust → *"used -
      ready again in 9:5x"* en dat telt af. Na afloop `/mh lust` → onderaan regels `brez combat:key …` en
      `lust combat:seen …` → `/reload` zodat ik ze uit het bestand kan lezen. Dáármee zijn de twee reads GEMETEN.
      Rob gebruikt EllesmereUI nu níét (30 sep) → `/mh lust` hoort *EllesmereUI shows: battle res no, Bloodlust no*
      te zeggen en alle regels staan er. Zegt hij "yes", dan is EllesmereUIQoL tóch geladen — meld het.
- [ ] Iemand in de groep is Druid/DK/Warlock/Paladin → staat bij *Can revive*; Shaman/Mage/Evoker/Hunter → bij
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
- [ ] In een dungeon: `/mh map` opent de verdieping waar je staat.
- [ ] Zwevende iconen op de Paladin: als ze er staan `/mh whatis 5`, muis erop, daarna `/reload`.
- [x] ✅ (Rob, 27 sep, Nexus-Point Xenas) rechtsklik castte Cleanse Toxins (castlog), maar de rode kleur bleef. Zijn
      debuff: Blistering Smite, **zonder type** in de tooltip.
- [ ] 🆕 **Solo testen:** `/mh partytest` (buiten gevecht) → alleen je eigen regel, zonder groep. Laat een rare of mob
      je een Poison geven (Venomous Infusion) → regel rood → rechtsklik op je naam → gaat het rood weg? Ook een mob
      met een Magic-debuff proberen: wordt de regel dan óók rood (= vals alarm voor Prot)?
- [ ] 🆕 **Automatisch (niets typen):** gewoon spelen in een groep (of met `/mh partytest`). Na elk gevecht kijkt MH
      welke van jouw debuffs het spel nog "wegneembaar" noemt. Is dat iets wat jouw spec níét kan weghalen, dan
      komt er één chatregel *"dispel check: your row is red for X (type: …)"*. Na de sessie: `/reload`.
- [ ] Als **je eigen** regel rood is: `/mh glow` → nieuwe regel *"your own debuffs now: naam [type]"*. Screenshot.
      Staat daar alleen Magic of "no type" terwijl de regel rood is, dan kleurt het spelfilter op klasse, niet op spec.

## 🆕 29 sep — crests (na de vergelijking met Gandalin)

- [x] ✅ (Rob, 29 sep) `/reload`, Codex → Currencies → **Crests**: de 3e regel zegt nu dat de cap telt wat je deze season hebt
      **verdiend** (niet wat je hebt), en elke week omhooggaat.
- [ ] Doe je een **Tier 11 Bountiful Delve**: wat geeft de **Gilded Stash** aan crests? Staat daar **Myth**, dan
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
- [ ] **Slijtage** (als je gear echt laag is; start de opname via **Win+G** → rode knop, niet Win+Alt+R): `/mh durability test` → de grote waarschuwing verschijnt (geluid doet er niet toe, de site speelt
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
- [ ] Chat zegt *"Gear export: N items."* Zegt hij dat items nog laden, dan werkt de tekst zich binnen een paar tellen bij.
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
- [ ] ⏳ `/reload`, `/mh export` → Lost Idol eindigt op `||i251783:1|e` (en Effigy ook op `|e` als hij een effect heeft).
      Plakken → Trinket-regels *Keep* met *"Its effect can't be scored here…"*, geen wissel naar de Keepsake.
- [ ] ⏳ (plakken nog te doen) `/reload`, `/mh export` → de Ouroboric Signet-regels eindigen op `||i<getal>:1`; ringen/trinkets zonder
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
- [ ] Een spreuk die niet op een toets staat: grijs `-`, en de tooltip zegt *"Not on a key on your action bars yet."*
- [x] ✅ (Rob, 27 sep) **Stay alive**: ook daar je echte toets op het icoon; de oude `[toets]` achter de naam is weg.
- [ ] Venster open laten, een spreuk naar een andere knop slepen: het label verandert mee.
- [ ] Een andere spec aanklikken bovenin: daar staan géén labels (die spreuken staan niet op je balken).
- [ ] Klopt een toets niet: `/mh playkeys` en stuur de regels.

## 🆕 27 sep — meting: wat ziet MH van je groep binnen een dungeon/raid?

Waarom: Cisca vond na doodgaan in een raid haar groep niet terug (meerdere verdiepingen).
- [x] ✅ (Rob, 27 sep, Nexus-Point Xenas) eerste meting: kaart per lid leesbaar, posities van niemand.
- [ ] Nog één keer in een raid/dungeon met **meerdere verdiepingen**, als iemand op een andere verdieping staat.
      Typ `/mh groupmap`, en daarna
      `/reload`. Ik lees de uitkomst uit het SavedVariables-bestand; een screenshot mag ook.
      Liefst op een moment dat een groepslid op een **andere verdieping** staat dan jij.

## 🆕 27 sep — waarschuwing bij versleten uitrusting

`/reload`.
- [ ] `/mh durability` → een regel met *warning on, limit 30%*, je laagste item met percentage, en per versleten slot
      een regel. Klopt het laagste percentage met wat je karakterscherm (tooltip van dat item) zegt?
- [x] ✅ (Rob, 27 sep: "tekst is groot en geluid werkt") `/mh durability test` → midden in beeld de grote tekst
      *"Your gear is at N% - repair before you pull!"* (eigen frame, 34 px, raid-warning-geluid), en in chat
      dezelfde regel met *Lowest:* en een item-link.
- [ ] Instellingen → Midnight Helper → *Dungeon help*: **Warn about worn gear** (aan) en de schuif **Warn below** (30%).
      Zet de schuif hoger dan je laagste item en start een ready check of ga een delve in: komt de waarschuwing?
- [ ] Onder de grens, en na het repareren: géén waarschuwing bij binnengaan.

## 🆕 26 sep — kaartvenster: tabblad Dispel

`/reload`, `/mh play`, tabblad **Dispel**.
- [x] ✅ (Rob, 26 sep, screenshot Prot Paladin) Passen de vier tabbladen naast elkaar (venster is iets breder geworden)?
- [x] ✅ (Rob, 26 sep: Cleanse Toxins, Poison + Disease) **Bij je groep**: klopt wat er staat met je spreuken?
- [ ] **Bij vijanden**: op een Shaman staat Purge, op een Mage Spellsteal, op een Hunter Tranquilizing Shot, op een
      Druid Soothe. Klopt dat, en staat bij een spec zonder zo'n spreuk *"This spec cannot take buffs off enemies"*?
- [x] ✅ (Rob, 26 sep: alle zes met naam, "you can" bij de 5 poison/disease, niet bij de boss-buff) **Waar het telt**:
      staan de dungeon- en baasnamen er echt (geen "?")? Staat "you can" bij de dingen die jij kunt?
- [ ] Muis op een spreuknaam: komt de uitleg?

## 🆕 26 sep — kaartvenster: tabblad Consumables

`/reload`, dan `/mh play` (of de gouden knop). Rob: *"het tabbladje voor onze consumables ... zonder in een lange lijst te
moeten zoeken"*.
- [x] ✅ (Rob, 26 sep: *"het werkt"*) Derde tabblad **Consumables**. Staan er flask, potions, wapenolie (niet bij elke spec), rune en food, elk met
      icoon en de naam in de kleur van het item?
- [ ] Achter elk item: **×aantal** als je het (of een alternatief) in je tassen hebt, anders *Not in your bags*. Klopt dat?
- [ ] Muis op een naam of icoon: komt de item-tooltip? Staan er eerst "..." in plaats van namen, verschijnen ze dan
      binnen een seconde?
- [ ] Wissel met de icoontjes bovenin naar een andere spec: wisselen de consumables mee?

## 🆕 25 sep — "Zo speel je" in een eigen venster, en kaarten voor álle specs

- [x] ✅ (Rob, 25 sep, screenshot Resto Druid: *"het grijs werkt, goed"*) **4.1.0: lage levels** — op je level 26 Druid `/reload`, `/mh play`. Bovenaan staat in lichtblauw *"Written for
      level 90. Grey: you don't have that spell yet."* Spreuken die je nog niet hebt zijn grijs (naam en icoon), die je
      wel hebt goud. Klopt dat met je spellbook? Zelfde op het tabblad Stay alive. (Op een andere spec via de icoontjes
      bovenin wordt niets grijs, alleen de regel "Written for level 90".)
- [x] ✅ (Rob, 25 sep: *"knop staat er en werkt"*) **4.1.0: de gouden knop** — `/reload`, open MH (`/mh`). Rechts in de zoekbalk, naast *My character*, staat een
      **gouden "How you play"-knop met het icoon van je spec**, die zacht oplicht. Klik: het kaartvenster opent en het
      oplichten stopt (ook na `/reload`). Past alles nog in de zoekbalk, ook met een smal MH-venster?
- [ ] 🆕 **4.1.0: Academy zonder schakelaar** — op een account/alt waar je nooit `/mh playcards` typte: staat de knop
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
- [ ] **Klik op het Holy- of Retribution-icoon** bovenin: wisselt de kaart naar die spec? Nog een keer `/mh play`
      sluit het venster.
- [ ] **Leesbaarheid:** is het nu goed te lezen? Te groot, te klein, te breed? (Shift + muiswiel maakt het venster
      groter of kleiner.) Slepen aan de titel, Escape sluit.
- [ ] **Academy** (Tank, Heal én DPS): bovenaan staat nu één knop **"How you play …  >"**, en de lange kaarttekst
      is weg. Opent de knop het venster met die spec?
- [ ] **Andere klassen:** op elke alt `/mh play`. Staat er een kaart (niet "isn't written yet")? Klopt hij met hoe
      jij die spec speelt? Vooral: staan er **nergens rare namen of "spell 12345"**?

## 🆕 22 sep — Curse Surge: "nu" en "volgende" met de naam van de baas

`/reload`. Rob: *"ja doe dat vervolg maar"*. De koppeling plek → baas komt van HandyNotes; 2 van de 5 zijn door
jou gemeten (Leviathan, Vassti).
- [ ] **Typ `/mh surge`** (op of vlak bij de Coiled Isle). Je krijgt *"Curse Surge nu: <baas> — nog X min"* en
      *"Volgende Curse Surge: <baas> om HH:MM"*. **Klopt de baas met wat je op de kaart ziet?** Vooral de drie
      die we nog niet zelf zagen: Looming Mutagenitor, Ori'kassi, Ss'akrithos.
- [ ] **Events-scherm van MH:** de lopende surge heet nu *Curse Surge: <baas>* en is **klikbaar** (zet een route
      naar die plek). Bij *Coming up* staat de volgende, ook met naam.

## 🆕 22 sep — Events-scherm: een lopende surge heet niet meer "komt eraan"

`/reload`. Gevonden met Robs Leviathan-meting: een Curse Surge die al liep, stond bij *Coming up — in 21 min*;
die 21 minuten waren de tijd tot het **einde**.
- [ ] **Sta op Coiled Isle tijdens een surge** en open het Events-scherm van MH (of `/mh eventspy`). De surge hoort
      nu bij **NU bezig** te staan, met de resterende tijd; bij *Coming up* staat de **volgende** plek, met de
      tijd tot hij **begint**.
- [ ] **Controle met een ander event** (bv. *Abundance*): klopt "over X min" nu met wanneer hij echt begint?

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
- [ ] Academy → **DPS**-tab op dezelfde Paladin: onder "Stay alive" staat de kaart voor **Retribution** (voorbeeld).
- [ ] **Staan alle spellnamen er als naam** (goud), en nergens "spell 123456"? Let vooral op Judgment,
      Sacred Weapon (Lightsmith-regel). Beweeg over een stap: komt de tooltip van die spell?
- [x] ✅ (Rob, 24 sep: *"Ziet er goed uit"*) **Voelt het eli10?** Te lang, te kort, onduidelijke woorden? Dit is de vraag waar de rest op wacht.
- [ ] (Mage- of Shaman-alt) DPS-tab: **Arcane** en **Elemental** kaarten. Bij Arcane staat **Arcane Orb niet
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
- [ ] **Paladin**: Macros → Utility → **Bubble Cancel**, op een knop zetten. Klik: Divine Shield gaat aan.
      Klik nog een keer: **verdwijnt de bubbel?** Zo niet, dan is de macro stuk en haal ik hem eraf.
- [ ] (Als je een Mage of Hunter langsloopt) hetzelfde met **Ice Block Cancel** of **Turtle Cancel**.

## 🆕 19 sep — Coiled Altar: Guillotine vraagt nu 3 man, niet 5

`/reload`. Blizzard verlaagde op 1 sep het minimum voor Guillotine naar **3 spelers** op LFR, Normal en
Heroic. Onze tip zei nog 5. Bij Mythic staat nu "5"; dat is afgeleid, want de hotfix noemt Mythic niet.
- [x] ✅ (Rob, 24 sep) **Raids → The Venomous Abyss → The Coiled Altar**: de Guillotine-regel zegt *"at least 3 players (5 on Mythic)"*.
- [ ] **In het gevecht (Normal of Heroic)**: staan er 3 of meer in de Guillotine, dan krijgt de raid geen
      straf-schade. Klopt dat met wat je ziet?
