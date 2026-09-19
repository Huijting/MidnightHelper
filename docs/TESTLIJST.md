# Testlijst — wat wacht er op Rob

📱 **Deze lijst staat ook als afvinkpagina op Robs telefoon:**
<https://claude.ai/artifact/2SbQS4EfWH1BCxDuHut2C4> (17 sep 2026, 35 open punten na de archief-splitsing).
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
op Robs verzoek). Deze lijst houdt de twee jongste testrondes; er is niets weggegooid.

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
