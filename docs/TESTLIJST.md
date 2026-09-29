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

## 🆕 27 sep — metingen: plattegronden, zwevende iconen, dispel

- [x] ✅ (Rob, 27 sep: The Venomous Abyss, map 2606, met Nek'zali) `/mh mapprobe show <getal>` tekent een plattegrond
      met doodshoofdjes bij de bazen.
- [x] ✅ (Rob, 27 sep, screenshot) `/mh mapprobe`: bij de dungeons "map 0" → daarvoor is een tweede weg gebouwd.
- [ ] 🆕 **Kaartvenster**: Codex → Raids → klap een raid open → naast *Route to* staat **Map**. Klik: plattegrond,
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
- [ ] Plak de tekst op de site → "Calculate best set".
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
- [ ] **Paladin**: Macros → Utility → **Bubble Cancel**, op een knop zetten. Klik: Divine Shield gaat aan.
      Klik nog een keer: **verdwijnt de bubbel?** Zo niet, dan is de macro stuk en haal ik hem eraf.
- [ ] (Als je een Mage of Hunter langsloopt) hetzelfde met **Ice Block Cancel** of **Turtle Cancel**.

## 🆕 19 sep — Coiled Altar: Guillotine vraagt nu 3 man, niet 5

`/reload`. Blizzard verlaagde op 1 sep het minimum voor Guillotine naar **3 spelers** op LFR, Normal en
Heroic. Onze tip zei nog 5. Bij Mythic staat nu "5"; dat is afgeleid, want de hotfix noemt Mythic niet.
- [x] ✅ (Rob, 24 sep) **Raids → The Venomous Abyss → The Coiled Altar**: de Guillotine-regel zegt *"at least 3 players (5 on Mythic)"*.
- [ ] **In het gevecht (Normal of Heroic)**: staan er 3 of meer in de Guillotine, dan krijgt de raid geen
      straf-schade. Klopt dat met wat je ziet?
