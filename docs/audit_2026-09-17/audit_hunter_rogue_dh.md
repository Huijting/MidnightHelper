# Audit klasse-advies — Hunter, Rogue, Demon Hunter (12.1, 17 sep 2026)

Alleen gelezen, niets aan de addon gewijzigd. Wat "de kaart" hieronder toont heb ik AFGELEID uit de code:
`SurvivalPlan.lua` + `KeybindRoles_<Klasse>.lua`, gesorteerd per stap en dan op `priority`. Of een rij
echt verschijnt hangt ook af van `IsPlayerSpell`. Dat heb ik niet in het spel gemeten.

Verdict-labels: **OK / FOUT / TWIJFEL**, en daarachter **BRON** (een genoemde, actuele bron bevestigt
het) of **AFGELEID** (alleen mijn eigen redenering).

Belangrijkste bronnen (allemaal 12.1, bijgewerkt 10 aug – 5 sep 2026):
- IV-SV = https://www.icy-veins.com/wow/survival-hunter-pve-dps-spell-summary
- IV-BM = https://www.icy-veins.com/wow/beast-mastery-hunter-pve-dps-spell-summary
- IV-MM = https://www.icy-veins.com/wow/marksmanship-hunter-pve-dps-spell-summary
- IV-SVguide = https://www.icy-veins.com/wow/survival-hunter-pve-dps-guide (hoofdstuk "Survivability Changes")
- M-BM = https://www.method.gg/guides/beast-mastery-hunter/introduction ; hackmd BM-wijzigingen https://hackmd.io/mh-L--A4RFWYLRSJOlPXNw
- M-SV = https://www.method.gg/guides/survival-hunter/introduction ; M-MM = https://www.method.gg/guides/marksmanship-hunter/introduction
- WH-SV = https://www.wowhead.com/guide/classes/hunter/survival/overview-pve-dps ; murlok-SV = https://murlok.io/hunter/survival/talents
- IV-ASN / IV-OUT / IV-SUB = https://www.icy-veins.com/wow/{assassination,outlaw,subtlety}-rogue-pve-dps-spell-summary
- murlok-ROG = https://murlok.io/rogue/{outlaw,subtlety,assassination}/talents
- M-SUB / M-OUT / M-ASN = https://www.method.gg/guides/{subtlety,outlaw,assassination}-rogue/introduction
- IV-SUBrot = https://www.icy-veins.com/wow/subtlety-rogue-pve-dps-rotation-cooldowns-abilities
- IV-HAV / IV-VEN / IV-DEV = https://www.icy-veins.com/wow/{havoc-demon-hunter-pve-dps,vengeance-demon-hunter-pve-tank,devourer-demon-hunter-pve-dps}-spell-summary

Devourer (specID 1480) **bestaat** als derde DH-spec in 12.x: een Int-caster op afstand (IV-DEV, BRON).

---

## HUNTER — gemeenschappelijke kaart (BM 253 / MM 254 / SV 255)

Zo ziet de kaart eruit (AFGELEID):
1. Survival of the Fittest — "keep this up, put it on BEFORE you pull"
2. Aspect of the Turtle — "when your health drops fast"
3. Roar of Sacrifice — "when your health drops fast"
4. Exhilaration — "to heal yourself"
5. (alleen SV) Harpoon — "to get away"
6. Counter Shot (BM/MM) of Muzzle (SV) — "when it is casting something"

| spell | id | wat de addon zegt | verdict | wat het moet zijn | bron |
|---|---|---|---|---|---|
| Survival of the Fittest | 264735 (naam-keyed, Hunter:80) | defensive_1 → "keep this up, BEFORE you pull" | **FOUT** (BRON) | 30% minder schade gedurende 8 s, 2 charges, 1,5 min cooldown. Druk hem als er een grote klap aankomt; je houdt hem niet de hele tijd aan. Wel een goede eerste knop onder "when your health drops fast". | IV-BM/IV-MM/IV-SV |
| Aspect of the Turtle | 186265 | defensive_3 → "health drops fast" | OK (stap), **TWIJFEL** (volgorde) | Klopt als noodknop. In 12.x lenkt hij de meeste aanvallen af en geeft 30% minder schade (met talenten 50%), cooldown 2,5 min (met talenten 2 min). Een beginner zou hem ná SotF moeten zien. Dat gebeurt nu, maar alleen omdat SotF in een andere stap staat. | IV-SV, IV-SVguide |
| Roar of Sacrifice | 53480 | category defensive, prio 2 → "health drops fast" | OK (BRON), volgorde **FOUT** (AFGELEID) | In Midnight mag je hem op jezelf casten (IV-SVguide: "can be used on yourself or any friendly target"). Het is maar 15% minder schade en je pet vangt 50% op. Dat is de kleinste knop, maar hij staat ná de Turtle. Beter bovenaan "hurts", of als hulp voor een groepsgenoot. | IV-SVguide |
| Exhilaration | 109304 | heal_quick → "to heal yourself" | OK (BRON) | 30% heal (SV krijgt er 16% over 8 s bij), cooldown 1 min | IV-SV |
| Harpoon (SV) | 190925 (Hunter:73) | role mobility → **"to get away"** | **FOUT** (BRON) | Harpoon trekt je **naar** een vijand toe. Het is een gap-closer en geen ontsnapping. De ontsnapping is **Disengage** ("Leaps you backwards", 20 s). | IV-SV |
| Counter Shot (BM/MM) | 147362 | interrupt | OK (BRON) | cooldown 24 s | IV-BM, IV-MM |
| Muzzle (SV) | 187707 | interrupt | OK (BRON) | cooldown 15 s | IV-SV |

**Ontbreekt op de kaart (alle Hunter-specs):**
- **Disengage** (781): de echte ontsnapping. Hij staat als `utility_primary` (Hunter:72) en de kaart toont alleen `mobility`. Daardoor verschijnt hij nooit. (BRON: IV-*, "Leaps you backwards")
- **Aspect of the Cheetah** (186257): wegrennen (+90% snelheid, cooldown 3 min). Staat ook als `utility_primary` (Hunter:74). (BRON)
- **Feign Death** (5384): laat alle aggro vallen, cooldown 30 s. Voor een beginner die door een rare wordt achtervolgd is dit de belangrijkste "overleef"-knop. Hij staat als `utility` (Hunter:85). (BRON)
- **Camouflage**: 2% heal per seconde in stealth, buiten gevecht (IV). Kleine heal, lage prioriteit. (BRON)
- **Mend Pet / Revive Pet**: pet in leven houden, zeker voor BM. Lage prioriteit. (BRON)
- Fortitude of the Bear hoeft er **niet** bij. Die is in Midnight een passieve 3% DR geworden (IV-SVguide, BRON).

### Hunter — damage-cooldownlijst (DpsToolkit.lua:36-38)

| spec | spell | id | addon cd | verdict | wat het moet zijn | bron |
|---|---|---|---|---|---|---|
| BM | Bestial Wrath | 19574 | 90 | **FOUT** (BRON) | Sinds Midnight een vaste **30 s**-cooldown, +20% schade | IV-BM, M-BM |
| BM | Call of the Wild | 359844 | 120 | **FOUT** (BRON) | **Verwijderd** in Midnight ("Call of the Wild removed") | M-BM, hackmd |
| BM | Bloodshed | 321530 | 60 | **FOUT** (BRON) | Is nu een passieve bleed die meekomt met Bestial Wrath en geen knop meer | M-BM, hackmd |
| MM | Trueshot | 288613 | 120 | OK (BRON) | 2 min | IV-MM |
| MM | Rapid Fire | 257044 | 16 | OK (BRON) | 16 s | IV-MM |
| MM | Explosive Shot | 212431 | 30 | cd OK (BRON), id **TWIJFEL** | In 12.1 terug als herwerkte DoT-spell, cooldown 30 s. Het id kan bij de rework veranderd zijn: niet bevestigd. | IV-MM, M-MM |
| SV | Coordinated Assault | 360952 | 120 | **FOUT** (BRON) | **Verwijderd** in Midnight | M-SV, IV-SV (de eigen klassekop Hunter:22-30 zegt het ook) |
| SV | Spearhead | 360966 | 90 | **FOUT** (BRON) | **Verwijderd** | Hunter:24-26 citeert IV |
| SV | Wildfire Bomb | 259495 | 18 | OK (BRON) | 2 charges, 18 s recharge | IV-SV |
| SV | Fury of the Eagle | 203415 | 45 | **FOUT** (BRON, maar indirect) | Niet meer in de 12.1-spelllijst. Wowhead: Boomstick "combines the use of Butchery, Flanking Strike, and Fury of the Eagle" | WH-SV, IV-SV |

**Ontbreekt in de lijst:**
- **SV Takedown**: de belangrijkste cooldown van SV (IV: "Your primary cooldown"), 1,5 min (1 min met Savagery). Het id is **TWIJFEL**. Kandidaten: 1250646 (JustAC SpellCooldowns, 90000 ms) en 1253859 (Wowhead-pagina). Niet in de client gemeten. (BRON: IV-SV, murlok-SV)
- **SV Boomstick**: tweede verplichte cooldown (M-SV-rotatiepagina: "3 DPS cooldowns … Takedown and Boomstick"). Kandidaat-id 1261193 (JustAC SpellCooldowns 60 s) of 1261215 (classifier). TWIJFEL. Flamefang Pitch is optioneel.
- **SV Aspect of the Eagle**: 1 min, Raptor Strike op afstand (IV-SV). Nuttig maar geen burst.
- **MM Volley**: cooldown 45 s, "excellent short-term burst" (IV-MM). Staat niet in de lijst.
- Door `toolkitHas` (RoleAcademy.lua:636-645) vallen verwijderde spells stil weg. Een SV-speler ziet nu **alleen Wildfire Bomb** en een BM-speler alleen Bestial Wrath "90 s". (AFGELEID)

### Hunter — `DPS_DEFENSIVES` (DpsToolkit.lua:80-82, rendert nu niets)
- Turtle cd 180 → **150** (120 met talenten). Exhilaration cd 120 → **60**. **FOUT** (BRON: IV-*, IV-SVguide: "Exhilaration's cooldown is now a 1-minute flat").

---

## ROGUE — gemeenschappelijke kaart (Assassination 259 / Outlaw 260 / Subtlety 261)

Zo ziet de kaart eruit (AFGELEID):
1. Feint — "keep this up, put it on BEFORE you pull"
2. Cloak of Shadows — "when your health drops fast"
3. Evasion — "when your health drops fast"
4. Crimson Vial — "to heal yourself"
5. Kick — "when it is casting something"
(Geen "to get away"-regel: Sprint, Shadowstep en Grappling Hook staan allemaal als `utility_primary`.)

| spell | id | wat de addon zegt | verdict | wat het moet zijn | bron |
|---|---|---|---|---|---|
| Feint | 1966 | defensive_1 → "keep this up, BEFORE you pull" | **FOUT** (BRON + AFGELEID) | Korte knop die je vlak vóór een klap indrukt: minder schade van AoE, met Elusiveness ook 20% van gewone aanvallen. Kost energie en kan 2 charges hebben (Graceful Guile). Je "houdt hem niet aan" vóór de pull. Hoort als eerste bij "when your health drops fast" / "vlak voor een grote klap". | IV-ASN ("reduces damage taken from area-of-effect"), murlok-ROG (Elusiveness, Graceful Guile) |
| Cloak of Shadows | 31224 | defensive_3 → "health drops fast" | OK (BRON), maar onvolledig | Werkt **alleen tegen magie** (immuun + debuffs weg), cooldown 2 min. De kaart zegt niet dat hij niets doet tegen fysieke klappen. | IV-*, murlok-ROG |
| Evasion | 5277 | defensive_3 → "health drops fast" | OK (BRON), maar onvolledig | +100% ontwijken gedurende 10 s, cooldown 2 min. Werkt alleen tegen aanvallen van vóren. Met Elusiveness ook 20% DR. | IV-*, murlok-ROG |
| Crimson Vial | 185311 | heal_quick → "to heal yourself" | OK (BRON) | 20% heal over 4 s, cooldown 30 s | IV-ASN |
| Kick | 1766 (naam-keyed) | interrupt | OK (BRON) | cooldown 15 s | IV-ASN |

**Volgorde:** in "hurts" staat Cloak vóór Evasion, puur op prio. Voor een beginner hoort Feint (klein, vaak) eerst te komen. Kies daarna Cloak of Evasion op basis van **magie of fysiek**, niet op volgorde. (AFGELEID)

**Ontbreekt op de kaart:**
- **Vanish** (1856): laat aggro vallen en breekt snares, cooldown 2 min. Voor solo en rares dé ontsnapping. Staat als `category="cooldown"` (Rogue:121) en valt daardoor buiten de kaart. (BRON: IV-*)
- **Sprint** (2983), **Shadowstep** (36554, Assa/Sub), **Grappling Hook** (195457, Outlaw): de beweegknoppen. Allemaal `utility_primary` (Rogue:76, 105, 106), dus nooit onder "to get away". (BRON: IV-*)
- **Cheat Death**: passief, maar een beginner moet weten dat het bestaat. Het is een keuze-node met Elusiveness. (BRON: IV, murlok)
- **Blind / Gouge / Kidney Shot**: een rare uitschakelen om te herstellen. Bewust weggelaten (SurvivalPlan.lua:55-58). Dat is een keuze, geen fout.
- Classifier-randfouten (keybind, niet de kaart): `Mark for Death` (Rogue:91) bestaat alleen als Deathstalker-heldenknop die je mark verplaatst (murlok-ROG). `Crimson Tempest` (Rogue:58) is in Midnight een **generator** en geen spender (M-ASN, murlok-ASN). Beide AFGELEID uit BRON.

### Rogue — damage-cooldownlijst (DpsToolkit.lua:45-47)

| spec | spell | id | addon cd | verdict | wat het moet zijn | bron |
|---|---|---|---|---|---|---|
| Assa | Deathmark | 360194 | 120 | OK (BRON) | 2 min | IV-ASN, murlok |
| Assa | Kingsbane | 385627 | 60 | OK (BRON) | 1 min | murlok |
| Assa | Shiv | 5938 | 30 | **TWIJFEL** | IV noemt 25 s. Murlok toont geen cooldown. M-ASN: "Gone are Indiscriminate Carnage, Shiv, and stealth effects". Waarschijnlijk is de oude Shiv-burst weg en is hij nu vooral een enrage-dispel. Geen burst-cooldown meer. | IV-ASN, M-ASN, murlok |
| Outlaw | Adrenaline Rush | 13750 | 180 | OK (BRON) | 3 min | murlok |
| Outlaw | Killing Spree | 51690 | 180 | OK (BRON) | 3 min. Het is een **finisher** (kost combo points). | murlok, M-OUT |
| Outlaw | Blade Flurry | 13877 | 30 | **TWIJFEL** | Het commentaar zegt "(talent)", maar IV zet hem onder de **basis**-abilities. De cooldown heb ik niet kunnen bevestigen. Het is een AoE-knop en geen burst-cooldown. | IV-OUT |
| Outlaw | Blade Rush | 271877 | 60 | OK (BRON) | 1 min | murlok |
| Sub | Shadow Dance | 185313 | 20 | OK (BRON) | 1 charge (2 met talent), 20 s recharge | IV-SUBrot |
| Sub | Shadow Blades | 121471 | 90 | OK (BRON) | 90 s | murlok, M-SUB |
| Sub | Flagellation | 323654 | 90 | **FOUT** (BRON) | **Verwijderd** in Midnight ("Flagellation has been removed"). 323654 was bovendien het oude covenant-id. | M-SUB, IV-SUB-guide |
| Sub | Goremaw's Bite | 426591 | 45 | **TWIJFEL** | Bestaat nog, maar is in 12.1 **volledig herwerkt** ("now a completely different spell"). Id en cooldown niet bevestigd. Controleer of 426591 nog het speler-id is. | IV-SUB-guide, WH-SUB |

**Ontbreekt:**
- **Sub Secret Technique** (280719): cooldown-finisher van 25 s (korter met Haste), draait mee met elke Shadow Dance. (BRON: IV-SUBrot, M-SUB "Subtlety basically only has 3 cooldowns")
- **Outlaw Keep It Rolling** (cooldown volgens murlok 6 min, TWIJFEL) en **Roll the Bones**: bewust weggelaten is verdedigbaar.
- `DPS_DEFENSIVES` (Cloak 120 / Evasion 120) klopt (BRON murlok).

---

## DEMON HUNTER — HAVOC (577)

Zo ziet de kaart eruit (AFGELEID):
1. Blur — "keep this up, put it on BEFORE you pull"
2. (Netherwalk — alleen als het spel hem kent; zie hieronder)
3. Darkness — "when your health drops fast"
4. Disrupt — "when it is casting something"
(Geen heal-regel en geen "to get away": Fel Rush en Vengeful Retreat staan als `utility_primary`.)

| spell | id | wat de addon zegt | verdict | wat het moet zijn | bron |
|---|---|---|---|---|---|
| Blur | 198589 (DH:85) | defensive_1 → "keep this up, BEFORE you pull" | **FOUT** (BRON) | "Reduces all incoming damage by 25% for 10 seconds, with a 1-minute cooldown." Een knop die je op het juiste moment indrukt, niet iets om aan te houden. Hoort bovenaan "when your health drops fast". | IV-HAV |
| Netherwalk | 196555 (DH:89) | category defensive → "hurts" | **FOUT/dood** (AFGELEID) | Komt niet voor in de volledige 12.1-lijst van Havoc (class- en spec-tree). Waarschijnlijk bestaat hij niet meer. Hij verschijnt niet op de kaart zolang `IsPlayerSpell` false geeft, maar het is dode data. | IV-HAV (afwezig; positieve controle: Eye Beam/Essence Break wél gevonden in dezelfde pagina) |
| Darkness | 196718 (DH:87) | category defensive → "hurts" | OK-ish (BRON) | Koepel op de grond, 8 s, 15% kans (30% buiten raids) dat schade mist, cooldown 5 min. Het is een **groeps**-knop die je neerzet vóór een klap. Voor een beginner hoort erbij: "zet hem op de grond en blijf erin staan". | IV-HAV |
| Disrupt | 183752 | interrupt | OK (BRON) | cooldown 15 s | IV-HAV |

**Ontbreekt (Havoc):**
- **Vengeful Retreat** (198793, 25 s, "vaults you back 15 yards", haalt snares weg) en **Fel Rush** (195072, 10 s): de ontsnappingen. `utility_primary` (DH:51, 53), dus nooit op de kaart. (BRON: IV-HAV)
- **Chaos Nova** (179057): AoE-stun van 3 s, cooldown 45 s. Bewust weggelaten (dispel_cc).
- **Self-heal**: geen actieve knop. Soul Rending (leech) en de heal uit Soul Fragments zijn passief. Dat "leeg" klopt. (BRON: IV-HAV)
- Met het talent **Desperate Instincts** wordt Blur sterker. Info, geen knop.

### Havoc — damage-cooldownlijst (DpsToolkit.lua:31)

| spell | id | addon cd | verdict | bron |
|---|---|---|---|---|
| Metamorphosis | 191427 | 120 | OK (BRON), 2 min | IV-HAV |
| The Hunt | 370965 | 90 | OK (BRON), 1,5 min (Eternal Hunt-apex −15 s/punt) | IV-HAV |
| Eye Beam | 198013 | 30 | OK (BRON) | IV-HAV |
| Essence Break | 258860 | 40 | OK (BRON) | IV-HAV |

`DPS_DEFENSIVES[577]`: Blur zonder cd → moet **60** zijn. Darkness 300 is OK. (BRON: IV-HAV)

---

## DEMON HUNTER — VENGEANCE (581, tank)

Zo ziet de kaart eruit (AFGELEID; die verschijnt op de DPS-track-pagina voor de huidige spec):
1. Demon Spikes — "keep this up, BEFORE you pull"
2. Fiery Brand — "when your health drops fast"
3. ~~Metamorphosis~~ → **valt stil weg**, zie hieronder
4. Darkness — "when your health drops fast"
5. Fel Devastation — "when your health drops fast"
6. Disrupt — interrupt

| spell | id | wat de addon zegt | verdict | wat het moet zijn | bron |
|---|---|---|---|---|---|
| Demon Spikes | 203720 | defensive_1 → keep up | OK (BRON) | Actieve mitigatie die je steeds opnieuw indrukt (12 s, 20 s recharge). Voor een tank is "houd dit op" juist. | IV-VEN |
| Fiery Brand | 204021 | defensive_3 → hurts | OK (BRON) | 40% minder schade gedurende 12 s | IV-VEN |
| Metamorphosis (Vengeance) | geen `id` (DH:112) | defensive_3 → hurts | **FOUT** (AFGELEID uit code) | De key `"Metamorphosis (Vengeance)"` is **geen spellnaam**: in het spel heet 187827 gewoon "Metamorphosis". `LiveName` zoekt op naam (SurvivalPlan.lua:153-157), krijgt nil terug, en de rij **verdwijnt zonder melding**. De grootste noodknop van de tank (+40% HP, +200% armor, 15 s, 2 min) staat dus niet op de kaart. Oplossing: `id = 187827` toevoegen. | IV-VEN (effect/cd) |
| Darkness | 196718 | hurts | OK-ish (BRON) | zie Havoc | IV-VEN |
| Fel Devastation | 212084 (DH:114) | category defensive → "health drops fast" | **TWIJFEL** (BRON) | Vooral een damage-knop die je **heal** tijdens het kanaliseren (Roaring Fire en Ruinous Bulwark maken er een heal/schild van), cooldown 40 s. Hoort eerder bij "to heal yourself" dan bij "health drops fast". Hij staat hier alleen omdat prio 4 alfabetisch achter Darkness valt. | IV-VEN |
| Disrupt | 183752 | interrupt | OK (BRON) | | IV-VEN |

**Ontbreekt (Vengeance):**
- **Metamorphosis** (187827), zie de FOUT hierboven.
- **Soul Cleave** als heal: bewust niet opgenomen (DH:20-23). Verdedigbaar, maar voor een beginnende tank is "Soul Cleave heelt je" de kernles. (BRON: IV-VEN "heals you")
- **Infernal Strike** (189110) als beweegknop: `utility_primary` (DH:54). Vengeful Retreat idem.
- **Last Resort**: passieve cheat-death. Info.
- `Fel Eruption` (DH:120) staat niet in de 12.1-lijst van Vengeance (TWIJFEL, AFGELEID; inert).

### Vengeance — TankToolkit (TankToolkit.lua:92-94, 124-128)
- Demon Spikes als "armor": OK.
- Fiery Brand cd 60: **TWIJFEL**. IV noemt de basis-cd niet. Down in Flames haalt er 12 s af en geeft 2 charges.
- Fel Devastation cd 40: OK (BRON).
- Metamorphosis 187827 zonder cd → **120** (BRON: IV-VEN "2-minute cooldown").
- Ontbreekt: **Darkness** (groeps-DR, 5 min) en **Soul Cleave** als `selfheal`-mitigatie (vergelijk Death Strike bij Blood).

---

## DEMON HUNTER — DEVOURER (1480, nieuw in Midnight, Int-caster op afstand)

Zo ziet de kaart eruit (AFGELEID):
1. Blur — "keep this up, BEFORE you pull"
2. Darkness — "when your health drops fast"
3. Disrupt — interrupt

| spell | id | wat de addon zegt | verdict | wat het moet zijn | bron |
|---|---|---|---|---|---|
| Blur | 198589 | defensive_1 → keep up | **FOUT** (BRON) | 25% DR gedurende 10 s, cooldown 1 min. Hoort bij "health drops fast". | IV-DEV |
| Darkness | 196718 | hurts | OK-ish (BRON) | | IV-DEV |
| Disrupt | 183752 | interrupt | OK (BRON) | | IV-DEV |

**Ontbreekt (Devourer):**
- **Soul Immolation** (1241937): "Heal 24% of your max hp … on a 1-minute cooldown" (30 s en 2 charges met Tempered Soul). Dit is de **echte self-heal** van Devourer. Hij staat als `category="cooldown"` (DH:147) en komt daardoor niet onder "to heal yourself". (BRON: IV-DEV; id-kandidaat uit JustAC SelfAuras/SpellCooldowns, niet in de client gemeten)
- **Shift** (Devourer-dash, 30 m, 20 s) en **Vengeful Retreat**: `utility_primary` (DH:136, 51), dus nooit op de kaart. Shift heeft nog geen id (DH:132-133 TODO). (BRON: IV-DEV)
- **Void Nova** vervangt Chaos Nova bij Devourer (IV-DEV). De classifier kent alleen `Chaos Nova`, en **Voidblade** staat er wel maar Felblade (DH:52) is voor Devourer niet van toepassing. Dat raakt de keybinds, niet de kaart. (BRON)

### Devourer — damage-cooldownlijst: **ONTBREEKT HELEMAAL** — FOUT (AFGELEID uit code)
- `DPS_SPECS` (DpsToolkit.lua:60-66) bevat **geen 1480**, en `DPS_COOLDOWNS` ook niet. Gevolg: `GetPlayerDpsSpecID()` geeft nil, waarna `GetClassDpsSpecID()` de eerste DPS-spec van de klasse pakt, en dat is **Havoc (577)**. Een Devourer-speler krijgt dus een "voorbeeld" van Havoc met Metamorphosis, Eye Beam en Essence Break. Omdat `activeID` nil is filtert `toolkitHas` niets weg (RoleAcademy.lua:621-645). Dat zijn allemaal knoppen die hij niet heeft.
- Wat erin hoort (BRON: IV-DEV): **Void Metamorphosis** (1217607; geen timer maar 50 Soul Fragments), **The Hunt** (1,5 min), **Soul Immolation** (1 min, ook resource), **Voidblade** (30 s), **Void Ray** (100-Fury-kanaal). Id's zijn kandidaten uit de classifier/JustAC en niet in de client gemeten.

---

## Structurele oorzaken

1. **`defensive_1` wordt als tekst "houd dit aan vóór de pull" gebruikt** (SurvivalPlan.lua:15, 76 + enUS `SURVIVAL_STEP_KEEPUP`). In de classifiers betekent `defensive_1` alleen "de kleine defensive op toets Z". Resultaat bij deze drie klassen: Survival of the Fittest (Hunter:80), Feint (Rogue:110), Blur (DH:85, voor Havoc én Devourer). Alle drie zijn knoppen die je op het moment zelf indrukt. Alleen Demon Spikes (DH:109) is echt "aanhouden". Dezelfde oorzaak als de Divine Shield-bug.
2. **Alleen `role="mobility"` telt als "to get away"** (SurvivalPlan.lua:81). Alle echte ontsnappingen staan als `utility_primary` (Hunter:72,74; Rogue:76,105,106; DH:51-54,136) en verschijnen dus nooit. Het ene `mobility`-item, Harpoon (Hunter:73), is juist een gap-closer naar de vijand toe. Geen van de drie klassen heeft een `survival = "escape"`-tag, en die escape-hatch (SurvivalPlan.lua:60-73) is voor Hunter, Rogue en DH nooit ingevuld.
3. **Opzoeken op naam, stil wegvallen bij nil** (SurvivalPlan.lua:153-157, 362-363). `"Metamorphosis (Vengeance)"` (DH:112) is geen spellnaam, dus de rij verdwijnt zonder foutmelding. `/mh survival` (SaveSurvivalProbe) zou dit laten zien, maar alleen als iemand erom vraagt.
4. **Heal-stap kijkt alleen naar `heal_*` en `category="selfheal"`** (SurvivalPlan.lua:79-80). Echte heals met een andere categorie vallen erbuiten (Soul Immolation DH:147 `cooldown`), en een heal-kanaal belandt onder "hurts" (Fel Devastation DH:114 `defensive`).
5. **"Wanneer"-tekst per rol in plaats van per spell** (SurvivalPlan.lua:33-35). De kaart kan niet zeggen dat Cloak alleen tegen magie werkt, Evasion alleen tegen fysieke aanvallen van voren, Darkness een grondkoepel is en Roar of Sacrifice je pet laat meebloeden.
6. **Volgorde = `priority` van het key-slot, dan alfabetisch** (SurvivalPlan.lua:351-357). `priority` is geschreven voor toetsverdeling en niet voor "klein eerst, groot laatst". Daardoor komt Turtle vóór Roar of Sacrifice, Cloak vóór Evasion (willekeurig) en Darkness vóór Fel Devastation (alfabet).
7. **Twee bronnen van waarheid, en één is TWW-data** (DpsToolkit.lua:7-10, 36-38, 45-47). De cooldownlijst is "verified" tegen JustAC SpellCooldowns, en die data loopt achter. De eigen Hunter-classifier (Hunter:22-30) weet sinds 7 aug dat Coordinated Assault en Spearhead weg zijn, maar DpsToolkit.lua:38 heeft ze nog. BM heeft nog Bestial Wrath 90 s, Call of the Wild en Bloodshed. Sub heeft nog Flagellation. Havoc-waarden kloppen wel.
8. **Stilte verbergt verouderde data** (RoleAcademy.lua:636-654). `toolkitHas` gooit spells weg die de speler niet kent. Een verwijderde spell geeft dus geen fout maar een kortere lijst: SV ziet alleen Wildfire Bomb, BM alleen een Bestial Wrath met een verkeerde cd. Precies de [[silence-is-not-absence]]-val. Omgekeerd filtert de preview-modus (geen `activeID`) níets weg.
9. **Nieuwe spec vergeten in de spec-tabellen** (DpsToolkit.lua:60-66). 1480 ontbreekt, dus Devourer valt terug op Havoc (RoleAcademy.lua:621-622).
10. **Dode `DPS_DEFENSIVES`-data met verkeerde cd's** (DpsToolkit.lua:75, 80-82). Die rendert nu niets (RoleAcademy.lua:667-679), maar staat klaar als "verified" bron voor een toekomstige cue. Exhilaration 120 moet 60 zijn, Turtle 180 moet 150, Blur zonder cd moet 60.
