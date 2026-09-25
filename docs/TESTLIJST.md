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

## 🆕 25 sep — "Zo speel je" in een eigen venster, en kaarten voor álle specs

- [ ] 🆕 **4.1.0: de gouden knop** — `/reload`, open MH (`/mh`). Rechts in de zoekbalk, naast *My character*, staat een
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
