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

## 🆕 21 sep — interrupt-kaart kent drie extra "kan ook een cast stoppen"-spreuken

`/reload`. Uit de JustAC-update van 20 sep, id's apart nagekeken.
- [ ] **Prot Warrior** (als je er een hebt): **Disrupting Shout** heeft nu een toets (**Ctrl+V**; had er
      eerst geen) en staat op de interrupt-kaart met het label **AoE interrupt**.
- [ ] **Demon Hunter, Vengeance of Havoc**: **Sigil of Misery** staat op de interrupt-kaart met **fear**.
- [ ] **Devourer Demon Hunter**: **Void Nova** heeft een toets en staat op de interrupt-kaart met **stun**.
      **Chaos Nova** hoort bij Devourer **niet** meer te staan (die spec heeft hem niet).

## 🆕 20 sep — markeerbalk: wissen gerepareerd + je ziet welke vlaggen al liggen

`/reload`, dan `/mh mark` (de balk komt alleen in een groep). Geleerd uit wMarker en EllesmereUIQoL.
- [x] ✅ **Rob, 20 sep, `/mh mark check`:** jouw client gebruikt `/tm` en `/cwm All`, en
      **`IsRaidMarkerActive` bestaat** — de gouden ring kan dus werken.
- [ ] **Nieuw: drie groepsknoppen** rechts op de onderste rij — ready check, **rollen-check** en een
      **aftelklok** (linksklik 10 seconden, rechtsklik stopt hem). Ze zijn **gedimd** als je geen leider of
      assistent bent, en de tooltip zegt dat dan ook. Klopt dat allebei?
- [ ] **Zet een paar wereldmarkers** (bovenste rij). Krijgen die knoppen een **gouden ring** zolang de
      vlag op de grond ligt? Wist je er één met rechtsklik, dan hoort de ring weg te gaan.
- [ ] **Zet iemand anders in de groep een marker**, dan hoort jouw ring ook mee te veranderen.
- [ ] **De rode X op de bovenste rij** (alles wissen): werkt die nu? Hij gebruikte `/cwm 9`, wat buiten
      een Engelse client sowieso niet werkte, en mogelijk helemaal niet meer.
- [ ] **Markeer een paar keer snel achter elkaar.** Krijg je nog "You can't do this right now"? De knop
      vuurde eerst twee keer per klik; dat is nu één keer.

## 🆕 19 sep — Z, X en C zijn nu altijd een defensive (of leeg)

`/reload`. Rob koos optie B: *"doe b maar"*. Op de kale Z, X en C komt alleen nog een defensive; dispels en CC
schuiven naar Shift/Ctrl. 107 verschuivingen in 27 specs; **Prot Paladin blijft gelijk**.
- [ ] **Ret of Holy Paladin**: in de toetsindeling van MH staat nu **Blessing of Protection op X** en
      **Cleanse Toxins op Shift+V** (was X). Klopt dat in het scherm met de toetsen?
- [ ] **Een alt van een andere klasse** (Shaman, Warlock, Rogue of Druid): staat er op X een defensive of niets,
      en géén Purge / Fear / Shiv / CC meer? Shaman hoort nu **Earth Elemental op Z** te hebben, Rogue **Evasion op X**.
- [ ] Gebruik je `/mh apply` om de indeling echt op je balken te zetten: doe dat pas na de reload, anders zet hij
      nog de oude.

## 🆕 19 sep — proef: "Zo speel je"-kaart (Ret, Prot, Arcane, Elemental)

`/reload`. Rob: *"Ik wil dat mh dat soort uitleg ook gaat geven … maar wel in eli10 formaat"*. Eerst vier
specs; pas als de vorm goed voelt volgen de andere en de vijf andere talen (nu Engels + Nederlands).
- [ ] **Op je Prot Paladin**: Academy → **Tank**-tab. Onder de tank-toolkit staat **How you play Protection**:
      het idee, 4 knoppen, "More enemies", "Biggest mistake", twee hero-regels (Templar / Lightsmith) en de bron.
- [ ] Academy → **DPS**-tab op dezelfde Paladin: onder "Stay alive" staat de kaart voor **Retribution** (voorbeeld).
- [ ] **Staan alle spellnamen er als naam** (goud), en nergens "spell 123456"? Let vooral op Judgment,
      Sacred Weapon (Lightsmith-regel). Beweeg over een stap: komt de tooltip van die spell?
- [ ] **Voelt het eli10?** Te lang, te kort, onduidelijke woorden? Dit is de vraag waar de rest op wacht.
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
- [ ] **Raids → The Venomous Abyss → The Coiled Altar**: de Guillotine-regel zegt *"at least 3 players (5 on Mythic)"*.
- [ ] **In het gevecht (Normal of Heroic)**: staan er 3 of meer in de Guillotine, dan krijgt de raid geen
      straf-schade. Klopt dat met wat je ziet?
