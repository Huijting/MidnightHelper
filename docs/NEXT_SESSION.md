# Midnight Helper — waar we staan
**Bijgewerkt 2026-08-15 (avond, na de tweede werkdag).** Dit is het eerste wat een nieuwe
sessie leest. Alles onder "Historie" is oud logboek; alleen dit kopstuk is bijgehouden.

## 📌 15 aug, tweede helft — Codex-pagina, achievements, en de Corrosive Codex gemeten

**v2.15.0 staat live op CF.** Daarna ~13 commits op `main`, nog niet uitgebracht.

**De Vaults-pagina in de Codex is af** (Robs "grote brei aan tekst"): witregels tussen de
bullets, drie secties (Om te beginnen / Wat je hier doet / Coin and Soul), de
Temple-Strike-uitleg van onderaan naar plek 4 verplaatst, en alle tien repeatables bij
naam. **Alle tien quest-ids zijn tegen Robs client geverifieerd.**

⚠️ **De les van die tien:** id 98232 gaf op de eerste `/mh atal` géén titel en op de tweede
wél. `GetTitleForQuestID` leest een cache — een stille titel is een cache-misser, geen fout
id. Er staat nu een `RequestLoadQuestByID`-stap in de probe die dat onderscheid maakt.

**Layout-bug gevonden en gerepareerd:** de Codex reserveerde regels × (fontH + 2) voor een
EditBox die zichzelf niet kan opmeten. Die "+2" is een gok per regel en groeide mee met de
lengte → een gat van ruim honderd pixels onder een lang artikel. Er staat nu een onzichtbare
FontString als meetlat, met de oude schatting als vangnet (meten faalde hier op 15 jul met
overlappende artikelen, en dat is altijd VEEL te klein — dus de meting telt alleen als ze
binnen de helft van de schatting valt).

**`/mh ach check` is nieuw en heeft meteen twee dingen gevonden.** Hij houdt élke hunt tegen
de client en scheidt twee fouten: een criterium dat niet bij het achievement hoort (id fout)
versus minder nodes dan criteria (data incompleet). Uitslag: **0 verkeerde criteria** in alle
hunts, en één te korte — Showdown Slugger: Naigtal had 8 nodes voor 10 criteria. Dat gat is
gedicht via `assetID` (de NPC-id), want de náám hielp niet: de client geeft voor criteria
8, 9 én 10 de string "Slaipaan". Uitvoer gaat naar `ns.db.achCheck`, niet naar chat.

**#6 (eiland op niveau) is AF.** Toegevoegd: 63395 The Coiled Isles Glyph Hunter (11 nodes)
en 63662 Student of Hissstory (10). ⚠️ **Bewust NIET toegevoegd:** 62601 en 63601 — hun
HandyNotes-coördinaten zijn 10.00/10.00, 10.00/20.00, 10.00/30.00, wat hún manier is om
"onbekend" te schrijven. Die overnemen geeft een pijl de zee in. Niet opnieuw proberen
zonder echte metingen.

### 🔴 De Corrosive Codex-spec: de helft die niet kan, is bewezen

Rob leverde `MHDelvesCorrosiveCodexspec.md` aan (Delves-tab-module). **Lees
`docs/CORROSIVE_CODEX_MEASURED.md` vóór je er iets mee doet.** Kort:

- **Corrosive Soul is een ITEM (273000), geen currency.** Coin is currency 3448. De spec
  vraagt om een currency-id voor Souls; die bestaat niet. Balans = `C_Item.GetItemCount`.
- **De Codex is GEEN `C_Traits`-boom** — 19 bomen gesweept, 18 met bijna alle node-namen
  leesbaar, controles aanwezig (1186 Runes of Power, 1151/1168/1223 companions). Geen van
  de 12 power-namen, geen van onze 4 discovery-nodes, geen "corrosi/Ula'tek/Atal". Dus
  §3.1 (actieve powers, 2e slot) en §3.3 (X/12) zijn **niet te bouwen** zoals beschreven.
- **Wat wél kan:** de checklist-helft, op geverifieerde quest-ids. Behalve de kolom
  "souls per bron" (2/2/1/6 uit gidsen) — daar loopt nu een **soul-grootboek** voor:
  `ns.db.soulLedger` schrijft elke verandering van item 273000 weg mét de seconden sinds de
  laatste quest-turn-in. Het schrijft géén oorzaak op; die attributie is leeswerk.
  **Kijk daar als eerste — na een week spelen staan de echte getallen erin.**
- **Bijvangst:** tree **1223 = "12.1 Valeera Sanguinar"** (1168 = 12.0). Bevestigt op live
  de drie PTR-poison-ids (1250826 / 1249934 / 1251120) waar Wowhead er drie fout had. En
  `ranksPurchased` leest zonder dat haar venster open staat → de curio-advisor kan tonen
  wat Rob al gekozen heeft.
- **Nog onbenoemd:** tree **1191**, 22 nodes waarvan er maar 2 een naam geven (Volatility
  Overflowing 1307833, Venomous Hunt 1307823). 12.1-band, currency-type 3, spent 2. Niet
  gebruiken tot het een naam heeft.

## ⭐ v2.15.0 GETAGD 15 aug laat (`149078d`, tag gepusht — packager uploadt)

"The Coiled Isle, for real": beide 12.1-delves compleet (routes, bosses, modellen),
Venomous Abyss-coach met 8 bosstips + geverifieerde 3D-modellen, Coiled Isle-plank in
de Codex met klikbare waypoints en een routeknop, crest-cap-uitleg, hasLoot.

**Direct na de release checken:** (1) CF-changelog schoon gerenderd? (regel: kort, geen
bullets — 13 regels, zou de 9e schone moeten zijn); (2) Rob plakt CURSEFORGE_DESCRIPTION.md
(bijgewerkt: delves, Codex-plank, 4 raids/17 bosses); (3) nieuwe screenshots stonden nog
open van 12 aug.

## 🔴 EERST: de rechterkolom van de Layout-tab toont geen toetsen (Rob, 15 aug laat)

Twee screenshots, Frost Mage. De linker- en middenkolom tonen hun binds netjes
(`Frostbolt 2`, `Shift+1`, `Ice Barrier Z`, …). De **rechterkolom niet**: Interrupts /
stops, Movement en CC / Dispel tonen wél de spell-namen maar **bij geen enkele een
toets** — en Counterspell hoort daar `E` te zijn.

Rob: *"ineens"* — dus een regressie, niet iets dat er altijd zo uitzag.

⚠️ **Nog niet gediagnosticeerd. De meest waarschijnlijke oorzaak, en dus het eerste dat
je moet uitsluiten in plaats van aannemen:** op screenshot 2 loopt het paneel **voorbij
de rechterrand van het spelvenster**. De toetsen staan rechts uitgelijnd in hun rij, dus
als de kolom deels buiten beeld valt is de tekst er wél maar zie je hem niet. Dat is een
heel andere fout dan "de bind wordt niet toegekend", en de reparatie is ook een andere.

Manier om het te scheiden zonder te gokken: kijk in `keybinds.json` (net opnieuw
gegenereerd) of Frost Mage's Counterspell/Shimmer/Frost Nova een toets hébben. Staat hij
daar wél, dan is het layout/clipping; staat hij daar níet, dan zit het in de allocator.
De consumables-rij rechtsonder mist ook zijn labels — waarschijnlijk hetzelfde.

## 🔍 Addon-ronde 16 aug (07:40-update) — drie dingen die ertoe doen

**1. HandyNotes_Midnight 151 heeft de eiland-data NIET gewijzigd.** Zelfde zeven
achievements, zelfde aantallen, en 62601/63601 staan nog steeds op `10001000` /
`10002000` / `10003000`. De beslissing van 15 aug om die niet over te nemen houdt dus
stand — een dag later weten zij het nog steeds niet.

**2. ⚠️ `canaccessvalue` is GEEN aanroepbare global. Niet "upgraden".**
SpellPilot schrijft `if canaccessvalue then return canaccessvalue(value) end` als
voorkeur boven `issecretvalue`. DandersFrames zegt er letterlijk bij waarom dat niet
werkt: *"canaccessvalue is not a callable global — it's only a documented return-field
name"* (`Features/Dispel.lua:445`). Bij SpellPilot valt de guard dus altijd door naar
`issecretvalue` en merken ze het niet.

MH gebruikt al `issecretvalue` — **dat is de juiste.** Dit staat hier zodat een volgende
sessie het niet "verbetert" na het in SpellPilot te hebben zien staan. Precies de val uit
CLAUDE.md: een andere addon is een kandidaat, geen bewijs.

**3. SpellPilot (0.11.19) overlapt MH breed — maar niet op de dispel-helper.**
Nieuwe naam in de lijst, Interface 120100. Modules: Interrupts, Removals, Debuffs,
HealthAssist, PetStatus, ConsumableCheck, FolioGuide, StatGuide, MythicPlusTimer,
ReputationTracker, GearAudit, Hearthstones. Dat raakt een flink deel van MH's terrein.

✅ **Maar `Removals.lua` is OFFENSIVE dispel:** het leest `"HELPFUL|DISPELLABLE"` op
**target** en meldt afneembare *vijandelijke buffs* (purge/spellsteal). Friendly dispel —
schadelijke debuffs van je groep halen — zit er nergens in (grep op DISPELLABLE/Cleanse/
dispelName raakt alleen dat ene bestand). **De niche uit [[mh-market-position]] staat dus
nog open.**

📌 En het is meteen een werkend voorbeeld van de nieuwe 12.1-filtersyntax op live:
`C_UnitAuras.GetBuffDataByIndex(unit, i)` naast een filterstring `"HELPFUL|DISPELLABLE"`.
Bruikbaar wanneer de dispel-helper gebouwd wordt.

## 🎯 MORGEN ALS EERSTE — drie dingen, in deze volgorde (Rob, 15 aug laat)

1. **Rechterkolom-fix** (zie hierboven). Data is goed, tekenen is fout.
2. **Sheet uit Robs eigen spellbook** i.p.v. uit het schema. Zie de waarschuwing bij
   het cheatsheet hieronder — hij gaat er anders iets uit leren dat niet klopt.
3. **⭐ WAT HIJ ECHT WIL: zijn eigen indeling kunnen EXPORTEREN.**

Zijn woorden: *"ik wil eigenlijk gewoon de mogelijkheid dat ik de indeling die ik nu heb,
met eventuele aanpassing die ik voor mezelf maak, kunnen exporteren."*

⚠️ **Dat is een derde ding, niet een variant op de eerste twee.** Nu bestaan er:
- het **schema** (roldata → wat MH aanraadt) — dat is de huidige sheet;
- de **auto-map** (zijn spellbook → wat MH voor hém zou voorstellen).

Wat hij vraagt is **wat er feitelijk op zijn toetsen zit**, inclusief wijzigingen die hij
zelf met de hand maakt en die MH nergens kent. Dat komt uit de client (`GetBindingKey` /
de action bars aflopen), niet uit onze data. Bouw dit dus niet als "de sheet maar dan
anders" — het is een andere bron.

Praktisch punt: de addon **zet geen binds** (Rob-approved, `keybind-scheme-v7-direction`).
Exporteren van wat hij zelf gemaakt heeft past daar goed bij; het is lezen, niet schrijven.

## 📄 Keybind-cheatsheet opnieuw gegenereerd (15 aug)

Rob wil de binds kunnen **printen of op een tweede scherm** zetten om ze te leren; het
in-game paneel kan hij niet verplaatsen. Dat gereedschap bestond al en stond een week
stil. `tools/keybind_sheet/gen_keybinds.py` → `build_outputs.py` → HTML + XLSX, 39 specs.
**Draai die twee opnieuw na elke KeybindRoles-wijziging**, anders leert hij iets anders
dan de addon toont.

**Openstaande taken:** #3 Codex-herontwerp (plan in docs/CODEX_REDESIGN.md — S1/S2-schoonmaak
heeft DEADLINE 18 aug), #8 3.0-release: de zes Cowork-features (na 18 aug, één voor één,
elk apart getest). #4, #5, #6 en #7 zijn af.

**Op 18 aug (S2 opent):** raid-tips live verifiëren (pre-release-noot weg mét meting),
`/mh atal` voor Venomfall Deeps, delve-ilvl-tooltips (S1-getallen!), Showdown-gate,
Mistcrest-ids, seizoensnummers-sweep uit CODEX_REDESIGN punt 3.

Op 27 juli stuurde de verouderde versie van dit bestand een sessie de verkeerde kant op
(hij wees nog naar de Achievements-tab en beweerde dat de WoW-map geen git-repo is).
Werk dit kopstuk bij, of laat het weg -- maar laat het niet verouderen.

---

## Waar we staan

| | |
|---|---|
| Uitgebracht | **v2.14.0** op CurseForge (12 aug, tag op `99855ea`) — changelog schoon gerenderd én approved. 2.13.0 stond op 414 downloads |
| Nu | **12.1 is live** (NA 11 aug, EU 12 aug). **Season 2 opent 18 aug** — de poort wacht op die datum, niet op de patch |
| Sindsdien | ~20 commits op `main`, nog niet uitgebracht. Versie **niet** bumpen tot Rob "af" zegt |
| Daarna | **v3.0.0** = Season 2 |
| Branch | alleen `main` |

⚠️ **Deze kop stuurde op 13 aug voor de tweede keer een sessie de verkeerde kant op** —
hij beweerde toen dat de Silvermoon-stadsgids nog hardcoded Nederlands was, terwijl die
's avonds ervoor volledig vertaald was (43 pins + 7 kopjes, nul letterlijke strings).
Werk dit blok bij aan het eind van elke sessie, of laat het weg.

## 🔴 EERST MORGEN (15 aug) — Rob zag het zelf, avond 14 aug

**De delve-tooltip toont Season 1-ilvls.** Op de nieuwe Gnarldor Isle-tooltip staat
Tier 1 `End 210 | Vault 216` t/m Tier 8 `End 246 | Vault 259`. Rob: *"ik denk dat we
andere gear krijgen"* — en dat is bijna zeker zo: **Season 2 opent 18 aug** en dan
verschuift de hele Delve-rewardtabel.

Waarom dit vóór alles gaat: het is de eerste keer dat MH een **verkeerd getal** toont in
plaats van niets. Een lege tabel is eerlijk; `End 246` is een belofte. En het gaat over
drie dagen fout, niet ooit.

Te doen: waar die tabel vandaan komt opzoeken (hardcoded of `C_WeeklyRewards`), en
beslissen of hij bij S2 leeg moet staan tot hij gemeten is — dat is de lijn die deze
repo verder overal aanhoudt.

⚠️ Niet uit een datamine invullen. De S2-ilvltabellen staan in `docs/PTR_12.1_WATCH.md`
als derdepartij-kandidaten; die gaan er pas in als de client ze bevestigt.

**Ook morgen, kleiner:**
- Twee nieuwe delves staan erin (Gnarldor Isle, The Ring of Glory) maar hebben **geen
  tips-, curios- of boss-entry**. De lookups zijn nil-safe, dus niks breekt; ze zijn
  alleen leeg. `DelveTipsData.lua` / `DelveCuriosData.lua`.
- Na **18 aug**: `/mh atal` opnieuw voor **Venomfall Deeps** (S2-nemesis, boss Azta'rec).
  Verwacht op 2512, maar dat is een aanname — de meting van 14 aug gaf daar exact twee.
- Open uit `docs/VAULTS_MEASUREMENTS.md`: het dode snelpad in kolom 1 van de elf oude
  delves, Robs vierde kaartpijl, en dat 2613 nul map-links heeft.

## 📍 Morgen op live, in deze volgorde

Alles hieronder is op de PTR gemeten en moet op live opnieuw, want de PTR is sinds
vanavond "Incompatible" (client loopt achter op de realms; 12.1.5 komt eraan).

1. **`/mh worldboss`** — zijn de vier Season 1-bossen echt vervangen door Lairs? De scan
   werkte niet meer op 12.1 en is gerepareerd, dus nu telt het antwoord pas.
2. ~~**`/mh api12`**~~ — ✅ **GEMETEN 12 aug op de PTR, interface 120100 (= echt 12.1).**
   14 aanwezig, 4 afwezig. Van de vijf die we op 12.1 verwachtten kwamen er **twee**:
   `SetOnUpdateMode` en `AddRoleset`. **Drie kwamen niet:** `HasAnyForbiddenAspect`,
   `SetTextFromSecret`, `SetShownFromBoolean` — plus `SetFormattedTextFromSecret`.
   Gevraagd aan een echt Frame en een echte FontString, dus voor de widgets die wij
   zouden gebruiken bestaan ze niet.

   ⚠️ **Geen enkel gevolg voor MH.** Van deze familie gebruiken wij alleen
   `SetAlphaFromBoolean` (ActionPrompt + CombatSafety), en die is aanwezig. De andere
   vier stonden nergens in de code. Niet opnieuw uitzoeken; wél niet meer aannemen dat
   een aangekondigde 12.1-helper er ook is.

   🔻 **DIE "KWAMEN NIET" IS TE STELLIG — gecorrigeerd 13 aug na DandersFrames 5.1.2.**
   Wat we maten is "afwezig op een kaal Frame, onder déze naam", en allebei die helften
   blijken te smal. DandersFrames noemt de check `HasAnyForbiddenAspect**s**` (meervoud,
   uit Blizzards eigen SecureTemplates), en roept `SetShownFromBoolean` aan op een
   **StatusBar**, niet op een Frame. `/mh api12` vraagt nu beide spellingen én een
   StatusBar. Dat bewijst niet dat ze bestaan — DandersFrames guardt zijn eigen aanroep —
   maar wél dat onze vraag te nauw was.

   `C_Spell.IsSpellImportant` bestaat ook op 12.1 — bevestigt de meting van 11 aug, en
   verandert niets: te smal om onze lijsten te vervangen.
3. **`/mh editmode preset`** — de bar-preset is geëxporteerd op 12.0.7. Overleeft
   Blizzards layout-formaat een patch? Zo niet: opnieuw exporteren, één constante in
   `Modules/BarPreset.lua` vervangen.
4. **De Codex** — Season 2-content is season-gated en hoort pas 18 aug te verschijnen.
   Controleren dat de gate doet wat hij belooft.

## 📐 GEMETEN 13 aug — Vaults of Atal'Utek, uit de client

`/mh atal` + `/mh zone` binnen de Vaults. Dit is meting, geen gids meer:

| | |
|---|---|
| uiMapID | **2509** (parent 2512, The Coiled Isle) — de gok uit de opdracht klopte |
| Questketen | **98388 → 97640 → 98428**, alle drie voltooid |
| Titels | het spel zet er een prefix voor: *"Vaults of Atal'Utek: One Coin Too Many"* |
| Currency | **Corrosive Coin = 3448**, header "Zones" |

Beschrijving die het spel geeft: *"Spirits of the Amani within the Vaults of Atal'Utek
deal exclusively in this phantasmal token."*

✅ **En de ontbrekende helft is óók gemeten.** De Corrosive Codex vraagt om *Corrosive
Souls*, en geen enkele currency-route vond die — omdat het er geen is. De tassenscan
gaf het antwoord: **Corrosive Soul = item 273000**, elf in bezit.

**Drie namen, drie verschillende dingen. Niet door elkaar halen:**

| naam | wat het is | gemeten |
|---|---|---|
| Corrosive Coin | currency van de zone | **3448**, duizenden in bezit |
| Corrosive Soul | **item** dat je offert in de Codex | **273000**, 11 in bezit |
| Spirit Corrosion | de Altar of Corrosion-boom | teller stond op 0 |

De gidsen noemen de eerste twee bij elkaars naam. De client niet. Dat een currency-sweep
een item nooit kon vinden was precies de reden om er niet uit te concluderen dat het niet
bestond.

⏭️ **Wat er nog niet gemeten is:** de twaalf gifts in de Codex (Ophidian Maw, Insidious
Venom, Viperine Grasp, Virulent Mucus, Mephitic Cloud, Accursed Poison, Gorgoneion Gaze,
Plague of Corrosion, Lithic Plumage, Miasma Geyser, Ouroboric Cycle, Ula'tek's Gift) —
die namen komen van een screenshot, niet van de client. En wat de Altar-boom precies
uitgeeft.

### 🗺️ En het "wat kan ik daar dóen" ligt al klaar — HandyNotes 150, 14 aug

Rob vroeg 13 aug: *"ik heb geen idee wat ik er allemaal kan doen en vooral waar"*.
HandyNotes_Midnight dekt de Vaults wél, met 22 nodes over twee kaarten:

**The Honored Dead — achievement 63610, twaalf memorials, ALLE met echte coords.**
Quests 98029-98040, criteria 116407-116418. Dat is een verzamel-hunt zoals onze
Achievements-tab er al meer heeft:

| quest | criteria | naam | coords (2509) |
|---|---|---|---|
| 98029 | 116407 | To a daughter | 49.50, 56.59 |
| 98030 | 116408 | To a lover | 52.21, 45.12 |
| 98031 | 116409 | To parents | 55.31, 48.45 |
| 98032 | 116410 | To a dream | 55.62, 40.60 |
| 98033 | 116411 | To a captain | 52.91, 33.90 |
| 98034 | 116412 | To sons | 42.91, 41.23 |
| 98035 | 116413 | To Failure | 45.81, 61.79 |
| 98036 | 116414 | To a father | 47.22, 28.77 |
| 98037 | 116415 | To a sister | 46.79, 7.51 |
| 98038 | 116416 | To Comrades | 38.50, 47.66 |
| 98039 | 116417 | To a stranger (onder de brug) | 42.57, 33.18 |
| 98040 | 116418 | To a shield-bearer | 56.49, 22.88 |

⚠️ 63610 stond al sinds 19 juli als gedatamined in de watch-log. Nu heeft hij twaalf
gemeten punten.

**Verder in de Vaults:** de ingang naar de Underbelly op **47.30, 11.20**, en drie
rare elites (Congealed Malice, Khu'tulak, Susarikk — achievement **63601**) waarvan
HandyNotes de locatie zelf nog niet weet (10.00/10.00 placeholders).

**En een derde kaart: de Underbelly = 2613**, kind van 2509. Eén rare (Szarith the
Fanged, quest 96030, 38.40/17.69) plus vijf "Soft Underbelly"-nodes voor achievement
**62601**, waarvan drie nog placeholder.

Dat is samen met wat we zelf maten (Corrosive Coin 3448, Corrosive Soul 273000, de
Codex, de Altar-boom) genoeg voor een echte uitleg-pagina.

### ✅ GEBOUWD 14 aug — die uitleg-pagina staat er, in zeven talen

Codex-artikel `vaults_atalutek`, categorie **world**, sort 12, met `currencyId = 3448`
zodat je eigen Corrosive Coins boven het artikel staan (3448 is ook aan
`CODEX_TRACKED_CURRENCY_IDS` toegevoegd). De twaalf gedenktekens staan er als één
looproute, van boven op de kaart naar beneden, plus de Underbelly-ingang en Szarith.

Vier dingen staan er **met opzet niet** in, en dat hoort zo te blijven: de twaalf
gift-namen uit de Corrosive Codex (screenshot, geen client), wat de Altar-boom uitgeeft
(ongemeten, teller stond op 0), coördinaten voor de drie rare elites (bestaan niet), en
elke zin waarin Corrosive Coin en Corrosive Soul in elkaar kunnen schuiven. De redenen
staan als commentaar bij de registry-entry in `Modules/MidnightCodexData.lua`.

⚠️ **Nog niet in het spel gezien.** `lint_addon.py` gaf 0 HARD/0 SOFT en `luac5.1`
parseerde alle 223 bestanden in een cloud-sessie, maar niemand heeft het artikel open
zien gaan. Rob's `/reload` is de eerste echte test. Wat er nog ligt als hij het opent:
klopt de saldo-regel voor Corrosive Coin, en past de coördinatenregel in de panelbreedte
of loopt hij lelijk af.

### ✅ GEBOUWD 14 aug — en er staat nu een hele Vaults-laag omheen

Rob vroeg wat er nog meer kon voor iemand die er nooit geweest is. Vier dingen erbij,
alle vier op gemeten data:

1. **The Honored Dead is een echte hunt.** Eén entry in `Modules/AchievementsData.lua`
   (63610, twaalf nodes op 2509) levert de kaart, de vinkjes, de Route-knop, de pijl,
   per-punt waypoints, auto-doorschuiven en NavSearch-regels op — nul nieuwe code. De
   kaart draagt `nameKey = "ACH_LORE_HONORED_DEAD"`, dus tag `[Lore]` en `feedsMeta`
   blijft false: of 63610 een meta voedt is nooit gemeten.
2. **De Underbelly.** Szarith the Fanged staat in de Rares-tab op 2613 met een **honest
   zero** als quest-id — HandyNotes geeft 96030 en die band is op dit eiland aantoonbaar
   niet de vlag die vuurt. Kaarten 2509 en 2613 zijn aan `COILED_ISLE_MAPS` toegevoegd,
   zodat de tab niet leeg valt precies waar een nieuwe speler het meest verdwaald is.
3. **`CampaignLeadIn.lua` draagt nu twee ketens.** Ula'tek ongewijzigd; erbij de
   Vaults-keten 98388 → 97640 → 98428. Elke campagne brengt eigen locale-keys mee voor
   kop en tekst, en `ns.GetCampaignLeadInStates()` is nieuw naast de oude enkelvoudige
   functie. `HomeDashboard` loopt er nu overheen.
4. **`/mh atal` vraagt de client nu ook naar 63610, 63601 en 62601** en zegt per
   criterium of wij hem verschepen.

⚠️ **De Vaults-keten heeft met opzet GEEN startcoördinaat**, dus geen routeknop tot je
de keten hebt opgepakt. De ingang is nooit gemeten en Zygors 47.24/60.79 gaat hier niet
in — dezelfde bron zat op 12 aug 13m naast de Crafting Orders-pin.

⚠️ **De criteria-ids 116407..116418 zijn nog HandyNotes, niet client.** Als ze fout zijn
blijft de kaart stil op 0/12 staan in plaats van te liegen. **`/mh atal` beslist het nu
zelf** — het nieuwe Achievements-blok zet er groen of rood bij. Dat is meting nummer één.

📋 **`docs/VAULTS_MEASUREMENTS.md`** is nieuw: acht dingen die nog ongemeten zijn, met
per punt het commando. Eén ronde door de Vaults met die lijst sluit vrijwel alles af.

### 🔎 NIEUW GEREEDSCHAP — `tools/locale_probe.lua`, en waarom het er moest komen

Rob vroeg op 14 aug of de vertalingen die we beloven er ook echt zijn. Dat is precies de
vraag waar deze repo op 30 juli op stukliep: 346 van de 438 fills per taal deden al
maanden niets, terwijl elke audit ze als klaar telde. Statisch tellen beantwoordt de
vraag dus niet.

    lua5.1 tools/locale_probe.lua KEY [KEY ...]

Het laadt de locale-bestanden in `.toc`-volgorde met een echte Lua-interpreter en zegt
per taal wat `ns:L` zou opleveren: OK, "still English (a copy, not a translation)", of
nil. Geen WoW nodig.

⚠️ **Het draait één keer per taal, en dat is de hele truc.** De packs zijn
locale-gated — `Locales/deDE.lua` doet `if GetLocale() ~= "deDE" then return end`. Eén
run ziet dus alleen enUS en nlNL, en een probe die dat niet weet meldt vrolijk dat vijf
talen ontbreken terwijl ze prima staan. Dat is de eerste versie van dit script letterlijk
overkomen.

✅ **Gemeten met dit script:** alle acht nieuwe Vaults-keys komen in alle zeven talen
door. `ACH_LORE_HONORED_DEAD` blijft met opzet Engels — de achievementkaart pakt sowieso
de naam uit de client.

## 🔴 GEREPAREERD 14 aug — vier dingen die op 18 aug stil zouden liegen

Uit `docs/PROPOSAL_ONMISBAAR.md` deel 0. Alle vier zaten in de categorie "toont met
overtuiging iets wat niet klopt", en dat is voor deze addon de duurste soort fout.

**1. `seasonStats` rolde om op patchdag, niet op seizoensdag.** `RollSeasonIfNeeded` las
de kale `C_MythicPlus.GetCurrentSeason()`, en dat getal ging 11/12 aug van 17 naar 18.
Het blok dat straks "Season 2" heet bevatte dus al een week Season 1 — en het zou op 18
aug niet nog eens omrollen, want het droeg het nieuwe id al. Nu poort de roll óók op
`ns.IsSeason2Live()`, en er zit een eenmalige reparatie voor: een blok dat vóór
`seasonStartsAt` geopend is wordt teruggezet op Season 1 en samengevoegd met het te vroeg
gearchiveerde blok. Tellers worden opgeteld, niet overschreven — beide helften zijn echte
gebeurtenissen van deze speler.

⚠️ **`tools/test_seasonstats.lua` test dit op de échte code**, niet op een kopie van de
logica: hij stubt `CreateFrame`, vangt de `PLAYER_ENTERING_WORLD`-handler en vuurt hem af.
Vier toestanden: vroeg omgerold (samenvoegen), na patchdag geïnstalleerd (herlabelen), het
seizoen opent echt (nu wél archiveren), en een echt Season 2-blok (afblijven).

**2. De M+-tab zou de S1-affixladder naast de S2-dungeonpool tonen.** `MPLUS_AFFIX_LADDER`
en `MPLUS_BARGAINS` zijn Season 1-data zonder S2-variant, en ze werden zonder poort
gerenderd terwijl de pool eronder wél omklapt — onder een kop die belooft uit te leggen
hoe keys dit seizoen werken. Half goed is erger dan zichtbaar verouderd. Beide blokken
verdwijnen nu zodra `IsMythicSeason2()` waar is, met `MPLUS_AFFIX_UNMEASURED` ervoor in de
plaats (zeven talen).

**3. Het curio-venster ging open met titel en niets erin.** `GetDelvesSeasonNumber` viel
terug op `return 1` — precies om de "NO fallback to season 1"-garantie tien regels lager
heen. Geeft nu `nil`. Nieuw: `ns.HasDelveCurioAdvice()`, gebruikt door alle drie de
oppervlakken. Het ingebouwde paneel klapt dicht tot één eerlijke regel, de auto-popup
blijft weg, en `/mh curio` zegt het hardop — een commando dat stil niets doet leest als
kapot.

**4. De world-boss-planner gokt niet meer vanaf 12.1.** `GetScheduledWorldBoss` deelde de
weken sinds 18 mrt door de S1-roster en had dus altijd een antwoord, ook nu 12.1 die
bossen door Lairs vervangen zou hebben. De gok stopt bij de patchgrens; de client-scan en
de weekcache blijven gewoon werken, en elke consument had de nil-tak al.

⚠️ **Punt 4 is een gok minder, geen meting meer.** `/mh worldboss` op live is nog steeds
punt 1 van de lijst hierboven. Staan die vier bossen er nog en roteren ze nog, dan kan de
poort weg. Zijn het Lairs, dan moet de roster zelf vervangen — niet de poort.

⚠️ **Nog niets hiervan is in het spel gezien.** Linter 0 HARD/0 SOFT, `luac5.1` schoon over
223 bestanden, de vier seizoenstoestanden groen, en beide nieuwe strings resolven in zeven
talen via `tools/locale_probe.lua`. Robs `/reload` is de eerste echte test.

## ✅ AFGESLOTEN 13 aug — de per-instance aura-route is dicht in gevecht

JustAC's per-instance route (`GetUnitAuraInstanceIDs` + `ShouldUnitAuraInstanceBeSecret`)
leek een uitweg voor MissingBuff. Hij is het niet. Gemeten met alle vijf filters die
JustAC zelf gebruikt:

| | HELPFUL | HELPFUL\|PLAYER | BIG_DEFENSIVE | HARMFUL | CROWD_CONTROL |
|---|---|---|---|---|---|
| staand | 7 | 5 | 0 | 0 | 0 |
| in gevecht | threw | threw | threw | threw | threw |

Plus de vijf-argumentvorm: ook geweigerd. **Zes weigeringen.**

⚠️ De staande rij maakt dit pas betrouwbaar: 7 → 5 → 0 betekent dat de tokens
**gehonoreerd** worden, dus de weigering in gevecht is geen artefact van een filter dat
de engine niet kent. Waren het vijf keer 7 geweest, dan bewees de hele run niets
(JustAC waarschuwt daar expliciet voor: een onbekend token faalt OPEN).

**Wat blijft:** onze defensieve fix van 12 aug (`nil` in plaats van `false`) is het
enige antwoord, niet een tijdelijke. JustAC volgt buffs in gevecht via een
**cast→instance-brug** — `UNIT_SPELLCAST_SUCCEEDED` leest plain voor de speler, en
`IsAuraFilteredOutByInstanceID` is een leesbare bool. Dat beantwoordt MissingBuffs vraag
niet (die gaat over een buff die je juist NIET gecast hebt), maar zou wél een feature
kunnen voeden die we niet hebben: een buff die je zelf opzette zien aflopen.

## 🆕 GEVONDEN 12 aug (avond) — twee dingen uit Robs screenshots

### 1. De Vaults of Atal'Utek: nóg een 12.1-systeem dat we niet kennen

Rob liep er in en stuurde het "Altar of Corrosion"-venster: een boomstructuur met
nodes, plus een eigen currency. Uit Zygor (vertrouwde bron, 12.1-versie):

- Quest-keten: `98388` "Into the Vaults of Atal'Utek" → `97640` "One Coin Too Many"
  → `98428` "The Altar of Corrosion"
- Eigen map: **Vaults of Atal'Utek**, ingang ~47.24 / 60.79
- Eigen currency: **Corrosive Coin**; de gossip "Corrode Spirit" kost er **1000**
  (gossip-id 141688, object `Altar of Corrosion##269485` op 51.16 / 62.80)

Dit staat naast Curse Surges op dezelfde Zygor-pagina en is even groot. Beide zijn
12.1-content die vandaag al leeft, dus geen seizoenspoort nodig.

### 2. Waarom het 3D-model ontbreekt bij Altar of Fangs — en waarom dat GOED is

Rob: "missen de animatie (allemaal trouwens in die dung)". Klopt, en het is opzet.

`CREATURES` in `DungeonBossWindow.lua` heeft geen enkele `altaroffangs:*`-regel. Die
tabel komt uit DBM's `SetCreatureID`, en de drie Altar of Fangs-mods hebben die regel
**uitgecommentarieerd** — alle drie met dezelfde waarde:

    --mod:SetCreatureID(231631)

⚠️ **231631 is Kroluk uit Windrunner Spire.** Dat weten we omdat het getal in onze
eigen tabel staat, twintig regels hoger. DBM heeft daar een sjabloon gekopieerd en de
placeholder laten staan. Hadden we DBM hier "vertrouwd", dan hadden alle drie de
Altar of Fangs-bossen Kroluks model getoond — een plausibel, aanwezig en aantoonbaar
fout id. Precies waar de regel voor bestaat.

**De fix is meten, niet overnemen.** Volgende keer in Altar of Fangs: elke boss
targeten en `/mh capture <naam>` draaien. Drie targets, drie npcID's, klaar.

## 🔴 GEVONDEN 12 aug — de Silvermoon-stadsgids is hardcoded NEDERLANDS

Rob (taal op auto, dus Engels) zag Nederlandse tooltips op de SMC-pagina. Klopt:
**alle 43 pins in `SMC_CATEGORIES` (UI.lua:759) hebben een hardcoded Nederlandse
`description`** — geen enkele `ns:L()`-sleutel. Plus de voetregel in de tooltip
("Klik: native pin + /way #2393 (TomTom indien beschikbaar)", UI.lua ~1485).

Elke gebruiker in elke taal krijgt dit. Het staat er sinds de pagina gebouwd is, dus
geen regressie — maar wel de grootste onvertaalde plek die we hebben. **Ik heb er op
12 aug onbedoeld een 44e aan toegevoegd** (Theremis) door het patroon van de buren te
volgen; dat is precies hoe zoiets zich vermenigvuldigt.

⚠️ **NIET om middernacht in één klap doen.** 43 × 7 = ~300 strings, en dat is exact het
soort massa-bewerking dat op 22 juli drie locale-bestanden brak.

**De slimme reductie, want de meeste beschrijvingen zijn een sjabloon.** Ongeveer dertig
zijn letterlijk "Zet een waypoint naar de X trainer/portal/bank". Eén sleutel met een
argument dekt die allemaal:

    SMC_PIN_GOTO_FMT = "Set a waypoint to %s."   -- %s = het label van de pin

Dan blijven er ~10 pins over die écht inhoud dragen (Maren Silverwing, Triam Dawnsetter,
Theremis, ritual/void-hub) en die krijgen een eigen sleutel. Zo is het ~17 sleutels in
plaats van 43, en de labels zelf zijn al grotendeels eigennamen die niet vertaald hoeven.

Doe het in twee stappen: eerst de sjabloon-pins omzetten en Rob laten kijken, dán de tien
met eigen tekst.

## 🔴 De grootste openstaande vraag (Rob, 11 aug)

**Hoe weet een gebruiker dat `/mh setup` bestaat?** Rob's eigen woorden: als hij morgen
tegen Carola zegt dat ze haar spells automatisch kan laten instellen -- waar gaat zij dan
heen? Een changelog leest niemand, de CF-beschrijving lees je één keer vóór installatie.

Hij merkte hetzelfde bij zichzelf: de addon is zo groot geworden dat hij zijn eigen
dingen niet terugvindt. Vanavond bleek dat letterlijk -- "details" en "platynator"
gaven geen zoekresultaat, terwijl hij die pagina's zelf gebouwd heeft (gefixt in
`ce76b3b`).

Drie richtingen, alle drie door Rob goedgekeurd, nog niet gebouwd:

1. **Een overzicht dat zichzelf uit de code genereert**, gesorteerd op *moment* (je gaat
   een delve in / je staat voor een boss) in plaats van op feature. Handgeschreven
   veroudert; de commandolijst laat zien hoe het wel moet.
2. **De addon wijst zichzelf aan wanneer het uitmaakt.** Het nudge-framework (Spec 15)
   bestaat al en doet dit voor twee dingen. Uitbreiden is registratiewerk, geen nieuwe
   machinerie. **Dit is het directe antwoord op de Carola-vraag.**
3. **Zoeken op intentie**, niet op naam. Vanavond gedaan voor commando's (beschrijving
   staat nu vooraan) en voor de Addons-pagina's.

## ✅ Vandaag gebouwd (11 aug), kort

Setup-paneel `/mh setup` met tien knoppen; snelbalk `/mh bar` (MH · reload · groep
verlaten · balken); potion-toetsen als bindbare secure buttons (`T` is vrij);
`/mh fps` (leest alleen, met Blizzards eigen labels); duimtoetsen naar balk 8;
bar-preset uit Rob's Hunter; Details!-profielpagina; shift+scroll schaalt elk
dialoogvenster; shift+klik op het minimap-icoon herlaadt.

**12.1-reparaties:** `C_TaskQuest.GetQuestsForPlayerByMapID` bestaat niet meer →
`GetQuestsOnMap`; task-POI-coördinaten horen bij de OPGEVRAAGDE kaart, niet bij
`poi.mapID`; The Coiled Isle (2512) toegevoegd aan de regiogroep zodat er geen
reisadvies meer komt bij 954 yard.

**Gemeten en vastgelegd:** `C_Spell.IsSpellImportant` kan onze interrupt/dispel-lijsten
NIET vervangen (3 van 29) -- staat als do-not-retry in `ApiProbe.lua`.

## ⏳ Wacht op Rob

* Details!-pagina: nieuwe profielstring + screenshots (hij past zijn layout nog aan)
* `/mh bar` shift+klik in een delve: werkt "leave delve"? De uitkomst landt in
  `ns.db.leaveDelveProbe`
* De professie-reset van 12.1 (eenmalig per beroep, en je zou recepten verliezen) --
  Codex-materiaal, maar het komt van PTR-gidsen: **VERIFY vóór we het opschrijven**

---

# Historie

## 📍 Waar we gebleven zijn (7 aug 2026, pauze)

**Twee toetsen dragen het halve schema, en dat is het echte probleem — niet de muis.**

De Python-harness in `tools/keybind_sheet/` liep achter op `KeybindSchema.lua` en is
gelijkgetrokken (`5191534`). Zes verschillen; de belangrijkste was dat de harness de
globale terugval nog had, waardoor niets ooit als "past niet" werd gemeld. Nu wel, en
het getal is groot:

    63 spells over 22 specs krijgen GEEN toets   (standaard 2-knops muis)
    27                                            (4 duimknoppen)
     8                                            (6 duimknoppen — Robs Naga)

⚠️ **Alle 63 komen uit twee categorieën, en die hebben allebei exact één toets:**

| categorie | slots | plekken met Shift+Ctrl | spells zonder toets |
|---|---|---|---|
| `dispel_cc` | `V` | 3 | **44** |
| `cooldown` | `F1` | 3 | **19** |

Rogue/Druid/Paladin hebben vijf tot zeven CC-spells voor drie plekken. Wat eruit valt is
niet alleen klein grut: Bloodlust, Heroism, Empower Rune Weapon, Spellsteal, Primal Rage.

**De muisknoppen zijn dus een pleister, geen oplossing.** De allocator probeert een vrije
duimknop ná Shift en vóór Ctrl, en dat verbergt precies hoe smal die twee categorieën
zijn. Rob vroeg (7 aug) of MMO-muisbezitters hun knoppen niet gewoon zelf in de
muissoftware moeten koppelen — het antwoord is dat dat het probleem zou VERGROTEN: dan
valt de ontsnappingsklep weg en staan we terug op 63. **Eerst `dispel_cc` en `cooldown`
breder maken, dan pas over de muis praten.** Niet gedaan, wel gemeten.

### Wat er verder ligt na deze sessie
- `/mh mbuff always` is weg — restant van de EllesmereUI-stand-down die Rob afblies. Het
  schreef `ns.db.missingBuffAlways`, wat niets las, en meldde gedrag dat niet bestond.
- **Bar-layout aan Rob getekend**: 5 nummers / 9 letters / 9 shift / 4 F-rij / 6 duimpad
  = 33 vakjes. Gemeten vraag per spec: min 20 (Brewmaster), mediaan 27, max 35 (MM- en
  Survival Hunter). 33 dekt 37 van de 39 specs; een zesde balk voor de Ctrl-laag maakt 39.
- **Zonder bar-addon werkt dit gewoon.** Balk 1 t/m 8 zijn Blizzards eigen Edit Mode-balken;
  EllesmereUI verzet ze alleen. `EUI_BAR9`/`EUI_BAR10` zijn extra en blijven buiten het schema.
- **Robs plan voor de keuze** (7 aug): óf MH zet het compleet neer (bars + binds + spells),
  óf de user krijgt het overzicht en doet Edit Mode zelf. GEVERIFIEERD dat dit kan zonder
  dat MH een bar-addon wordt: `C_EditMode.ConvertStringToLayoutInfo`/`GetLayouts`/
  `SaveLayouts`/`SetActiveLayout` (zo doet EllesmereUI het), `SetBinding`+`SaveBindings`
  (zo doet KeyUI het), en spells plaatsen doet `/mh apply` al. Voorwaarden uit
  EllesmereUI's eigen code: buiten combat, `EditModeManagerFrame.accountSettings` moet
  gevuld zijn, `/reload` er direct achteraan, en NIET `EditModeManagerFrame:ImportLayout`
  gebruiken. ⚠️ De exportstring is patch-gebonden — elke grote patch opnieuw maken.

### Later die avond GEDAAN (7 aug, 20:00-21:00)
- **`dispel_cc` = V,X,C en `cooldown` = F1,F3,F2** (`07785ca`). 63 zonder toets → 3.
- **`T` is het consumable-anker** — uit de spell-verdeling gehaald. Daarvóór had 18 van de
  39 specs GEEN vrije toets voor een healing potion; nu alle 39 wel. Tweede consumable
  valt terug op een Shift-laag.
- **Mage**: spec-grendels van Arcane Explosion en Dragon's Breath weg (Robs Frost mage kent
  beide via de Frostfire-heldenboom), Slow Fall toegevoegd, en **Spellsteal gaat vóór
  Dragon's Breath** (`90fb048`) — Rob: "voor een goede speler onmisbaar".
- **`/mh sba`** (`30b3f23`) — houdt ALLEEN de kale `1` vrij voor Blizzards Assisted Combat.
  Gated op `C_AssistedCombat.IsAvailable()`. Shift+1 blijft de AoE-tweeling. Kost 0.
- ⚠️ **GEEN MUISKNOPPEN MEER AANNEMEN** (`37377a8`). `MouseSlots()` viel terug op "twee
  duimknoppen heeft bijna elke muis" — dat zette **52 bindings** over de specs op knoppen
  die niemand bevestigd had. Nu 0. Kost 3 → 17 zonder toets, en dat is de eerlijke prijs.
  **Rob moest dit TWEE KEER zeggen voor het gerepareerd werd; de eerste keer beaamde ik
  het alleen.** De harness spiegelt het (`MOUSE_SLOTS = []`).
- **`scannedIds` in de automap-dump** (`8b4dec7`) — spell-IDs uit de eigen spellbook, want
  grep over de andere addons gaf 22271 voor Arcane Explosion (dat is een *mob*).

### Balkenplan GEDAAN (7 aug, laat) — en wat er nog open staat
`6faeb63` geeft elke toetsgroep een vaste balk én een vaste plek. Getest op Robs Frost
mage met een volledige `apply full go` + `apply go`: **24 van de 24 toetsen correct,
niets vermist.** Vakje 1 blijft leeg (SBA), nummers op balk 1, letters op balk 2, Shift
gesplitst over 3 en 4, F-rij op 5, reserve op 6.

    balk 1  nummers 1-5              slots 1-5
    balk 2  letters Q E R T F Z X C V  slots 61-69
    balk 3  Shift+nummers + Shift+F   slots 49-57
    balk 4  Shift+letters             slots 25-33
    balk 5  F-rij F1-F4               slots 37-40
    balk 6  Ctrl + duimknoppen        slots 145-156 (vulvolgorde)
    balk 7/8 = van de speler, wij komen er niet

**Nog te doen aan het balkenplan:**
1. **Spells die al op balk 7/8 staan blijven daar.** `/mh apply` verplaatst niets dat al
   werkt, dus Counterspell (157), Ice Cold (160) en Remove Curse (161) staan nog op Robs
   eigen balk terwijl ze op `E`, `C` en `Shift+V` van balk 2/4 horen. Alleen een volledige
   herbouw zet ze goed, en die haalt balk 7/8 bewust niet leeg. Keuze maken.
2. **Frozen Orb staat op vakje 121** — dat is de skyriding-/voertuigbalk, niet balk 1-8.
   `Shift+1` wijst daarheen. Werkt alleen zolang die balk zichtbaar is.
3. ⚠️ **`/mh bars` gaf `nil` als naam voor vakjes die wél een spell bevatten** (157/160/161).
   Dat kostte een half uur en twee verkeerde diagnoses. `NameForAction` in
   `Modules/BarInventory.lua` nakijken.

### Nacht van 7 op 8 aug — uit ChatGPT's technische brief
Rob leverde `Midnight_Helper_WoW_12.1_ActionBars_Keybindings_Technical_Brief.md` aan
(staat in zijn Downloads, niet in de repo). Het meeste beschreef wat we al hadden. Vier
dingen waren nieuw; drie zijn gebouwd.

- ✅ **Eigenaarschap per vakje** (`769d509`, `Modules/SlotOwnership.lua`). We onthouden wat
  wij plaatsen; verandert de speler het, dan is dat vakje voorgoed van hem en raken we
  het nooit meer aan. Terug met `/mh apply reclaim`. **Bewust NIET via
  `ACTIONBAR_SLOT_CHANGED`** — dat event vuurt tijdens onze eigen plaatsingen, bij login
  en bij talentwissels, en elke valse positief laat MH stil stoppen met beheren. We
  vergelijken op het moment dat een plan gebouwd wordt.
- ✅ **Assistent detecteren** (`a851991`). `C_ActionBar.IsAssistedCombatAction(slot)` +
  `GetBindingKey` zeggen wélke toets de Assisted Combat-knop drukt. `/mh sba` blijft voor
  wie een toets vrij wil hóuden vóór de knop op een balk staat.
- ✅ **Lantaarn-tip** (`1123989`, `Modules/LayoutGrowth.lua`). Leer je iets waar de layout
  een toets voor heeft, dan één regel in chat. Plaatst niets. Uit met `/mh tips`.
- ⏸ **`SetBindingSpell` / `SetBindingItem`** — zou de spells zonder vakje alsnog een toets
  geven, maar dan zie je niet meer wat je drukt. Ontwerpkeuze voor Rob, niet gebouwd.

**Twee adviezen uit de brief bewust NIET overgenomen:** `SaveBindings(2)` forceert
personage-bindings (wij doen al `SaveBindings(GetCurrentBindingSet())`, dat respecteert de
keuze van de speler), en de voorgestelde mappenstructuur van zes nieuwe bestanden.
`C_ActionBar.HasAction` en `IsCurrentAction` uit de brief bestaan niet.

⚠️ **`LEARNED_SPELL_IN_TAB` bestond niet meer** (`dc6021b`). Ik registreerde hem omdat de
naam vier keer in Robs andere addons stond — dat bewijst alleen dat iemand hem ooit
opschreef. **Grep over andere addons is GEEN verificatie van een game-API.** Vraag het de
client. Robs eerstvolgende reload gaf meteen "Attempt to register unknown event".

### 8 aug, ochtend — BALKENPLAN WERKT OP EEN SCHONE UI
Rob heeft **EllesmereUI, OakUI en KeyUI verwijderd** en een verse `Modern (Preset)`
Edit Mode gemaakt. Daarna een volledige `apply full go` + `apply go`. Gemeten resultaat:
**24 van de 24 toetsen op hun eigen balk, nul valse markeringen.**

    balk 1  4 toetsen  2 3 4 5            (vakje 1 leeg — assistent)
    balk 2  9 toetsen  C E F Q R T V X Z
    balk 3  4 toetsen  Shift+1..4
    balk 4  5 toetsen  Shift+C E V X Z
    balk 5  1 toets    F4
    balk 6  1 toets    6 (Dragon's Breath)

Dit is dus getest op precies wat Cisca heeft: kale Blizzard-balken, geen bar-addon.

**Drie bugs die dit blootlegde en die gerepareerd zijn:**
- `efdce06` **`/mh bars` gaf `nil` voor macro's, pets, mounts, flyouts en equipment sets.**
  `GetActionInfo` geeft bij een macro de SPELL die hij cast, geen macro-index. Een naamloos
  vakje las als leeg — dat kostte een verkeerde diagnose ("je Counterspell is weg").
  Onbenoembare acties melden nu hun TYPE (`<macro>`).
- `765f266` **Het balkenplan verloor van de geschiedenis.** Spells op balk 7/8 bleven daar
  omdat `apply full` die balken bewust niet leeghaalt. Nu verhuist een spell naar zijn
  eigen plek als die vrij is; de achterblijvende kopie wordt gemeld, nooit gewist.
- `038bd0c` ⚠️ **Een herbouw beschuldigde de speler van zijn eigen leeghalen.**
  "3 slot(s) you changed yourself" terwijl Rob niets deed. En dat is niet cosmetisch: zo'n
  vakje wordt vóórgoed uitgesloten, dus elke herbouw maakte MH's werkruimte kleiner.
  `full go` wist het eigenaarschapsregister nu, net als undo al deed.

Ook nieuw: `f7c1db8` **`/mh editmode`** legt vast hoe de balken staan (layout, maten,
zichtbaarheid) — read-only, drie foto's, plus één automatisch 10 s na login. Terugzetten
bewust NIET gebouwd; zie de kop van `Modules/EditModeBackup.lua` voor waarom.

### 8 aug, verder op de ochtend — opruimen en de alt-vraag
- ✅ **`/mh apply clean`** (`573da70` + `74d7e3a`). Haalt toetsen weg die naar balk 1-6
  wijzen en bij geen layout horen. Bij Rob: eerst **16 Alt-bindings**, daarna nog **14**
  losse (`F5 F6 F1 F2 F3 F7 F8 8 0 F9 9 - 7 G`). Sparen: toetsen die de layout gebruikt
  én RESERVED-toetsen (`1` drukt de assistent, dus die staat niet in de layout-lijst en
  zou er anders precies uitzien als rommel). Balk 7/8 wordt niet gelezen.
  **Wat dit bewees:** `a-F2` maskeerde een werkende `s-E` op de knop. Dode bindings zijn
  niet alleen lelijk, ze verbergen de goede.
- ✅ **Battle-pet naam** (`d479a55`). `GetPetInfoByPetID` geeft de naam op positie **8**,
  ik las 7 (`isFavorite`). Plumber en Zygor destructureren identiek.
- ✅ ⚠️ **Eigenaarschap per PERSONAGE én SPEC** (`9c21640`). `MidnightHelperDB` is
  account-breed, actiebalken niet. Robs vraag "wat als ik naar mijn Shaman ga" vond dit:
  de Mage-administratie zou tegen Shaman-balken vergeleken worden, alles zou mismatchen,
  en alle 24 vakjes zouden als "door de speler gewijzigd" voorgoed uitgesloten worden —
  óók terug op de Mage. Eén alt-bezoek had de functie overal stilgelegd.
- ✅ **Knop bij de leer-tip** (`776b91b`). "Place it" / "Not now". Uit met
  `/mh tips button`; alles uit met `/mh tips`.

**Eindstand van Robs Frost mage:** 24 toetsen, elk op zijn eigen balk, nul dode bindings,
nul valse markeringen. Balk 1 `1 2 3 4 5` (1 vrij voor de assistent), balk 2 de negen
letters, balk 3 `Shift+1..4`, balk 4 `Shift+C E V X Z`, balk 5 `F4`, balk 6 `6`.

**Balkenplan getoetst op ALLE 39 specs: 0 specs waar het niet past.** Toetsen per spec
21 (Brewmaster) tot 34 (MM Hunter). Zonder duimknoppen 17 spells zonder toets over 9
specs; met 2 knoppen 3; met 6 knoppen 0. Wat overblijft is situationeel (Scare Beast,
Steel Trap, Blessing of Freedom, Turn Evil) — nooit rotatie, interrupt of defensive.

### 10 aug — 12.1-check, verplaatsbare ankers, en de assistent-saga
**12.1 gaat 11 aug live. Gemeten op de PTR, niet gelezen:** `C_SuperTrack` heeft nog ALLE
vier zijn functies inclusief `GetNextWaypointForMap`, en `C_Navigation` bestaat ernaast.
Er is dus niets verwijderd — de digest die het tegendeel zei klopte niet. Onze 16
`C_SuperTrack`-aanroepen zijn veilig, alle 4 `C_Map`-waypointcalls bestaan, en **alle 76
events die MH registreert zijn bekend op 12.1**. `UIParentLoadAddOn` had al een fallback,
`.toc` verklaarde `120100` al.

**Gebouwd:**
- `46d0b02` **`/mh anchor`** — 14 verplaatsbare rol-ankers. Rob wilde interrupt op muisknop
  `6`. Verplaatst, dupliceert niet, geldt op elk personage, en de toets gaat uit de
  overloop. Kost 0 extra spells zonder toets, gemeten over alle 39 specs.
- `14db83d` Een anker op een onbereikbare toets valt terug op de standaard. De **meting**
  beslist, niet de instelling — anders wijst het anker naar een knop die niets stuurt.
- `ab4b036` **Muisknoppen zijn van de speler**, net als balk 7/8. MH gebruikt er alleen
  een als je er iets aan koppelt. Kost 17 zonder toets over 9 specs (allemaal
  situationeel). Terug met `/mh mouse fill`. Plus: **geen dubbelen meer op balk 1-6**.
- `0ea2b47` **Plaatsingen worden nagekeken** tegen `GetActionInfo`. `pcall` zegt alleen dat
  er geen fout kwam, niet dat het vakje veranderde.

⚠️ **DE ASSISTENT-SAGA — de les van de dag.**
`C_AssistedCombat.GetActionSpell()` geeft 1229376 "Single-Button Assistant". Ik concludeerde
dat MH hem kon plaatsen, daarna dat hij nergens stond, en bouwde op beide conclusies.
**Allebei fout.** De knop **toont de spell die hij aanraadt**, dus `GetActionInfo` op zijn
vakje antwoordt "Frozen Orb" en het id 1229376 komt nergens voor. Rob vond dit door naar
het GEDRAG te kijken: "die adviseert nu frozen orb op de plek waar ik de assist zette".

Drie stukken code zagen dat vakje als een gewone kopie, en één daarvan was gevaarlijk: de
dubbele-opruimer stond op het punt zijn assistent te wissen. Alle drie vragen nu
`C_ActionBar.IsAssistedCombatAction` (`386ee7d`) — de enige eerlijke vraag is "wat IS dit
vakje", niet "welke spell zit erin".

Ook: `83e77a9` de herbouw blijft van dat vakje af (we kunnen het niet terugzetten), en
`fb1853b` toets `1` wordt alleen vrijgehouden als de assistent **op een balk staat**, niet
als het spel zegt dat hij "beschikbaar" is.

**Eindstand Robs Frost mage: 24 van de 24 toetsen correct, niets te wijzigen.**

### WACHT OP ROB (openstaande beslissingen)
1. **Verplaatsbare rol-ankers.** Rob wil van oudsher interrupt op muisknop `6`, shield op
   `7`, taunt op `a`. Advies gegeven: niet ERBIJ maar IN PLAATS VAN — anders twee plekken
   voor één ding, en je duimknoppen zijn nu de overloop van het hele schema. Aanbod: een
   instelling die per rol zegt waar het anker zit, geldig op alle personages. **Niet
   gebouwd, wacht op zijn ja.**
2. **Gebruikt Rob muissturen?** Zo ja is `A` vrij en kan die in de pool. Nu niet.
3. **`/mh events` draaien** — schrijft nu ook `ns.db.assistedCombatApi`. Daarmee weten we
   of MH de assistent-knop zélf op `1` kan zetten. Geen spell-ID gevonden op schijf
   (EllesmereUI is verwijderd), dus alleen de client kan het zeggen.
4. **Stance bar + pet bar tegelijk?** Rob vroeg of een spec ze allebei kan hebben. Onze
   data kan het niet beantwoorden (`pet_care` wordt door geen enkele klasse gebruikt).
   Aanbod: `/mh bars` uitbreiden zodat hij beide balken meldt; dan meten we het op zijn
   Warlock/Druid. Niet gebouwd.
5. **`SetBindingSpell`** voor de spells zonder vakje — nog steeds open.
6. **Rob moet de balken nog fysiek neerzetten.** ⚠️ Edit Mode's minimum is **6** knoppen,
   dus balk 1 (5 nodig) en balk 5 (4 nodig) worden 6 met lege plekken. Maten: 6/9/9/9/6/12.

### Eerstvolgende werk
1. De zes punten hierboven.
2. Frozen Orb staat op vakje 121 — de skyriding-/voertuigbalk, niet balk 1-8.
3. Daarna de keuze-kaart (MH zet het neer / doe het zelf).
3. Optioneel: de 17 die nog zonder toets vallen zitten geconcentreerd bij Hunter
   (Scare Beast, Wyvern Sting), Paladin (Blessing of Freedom, Turn Evil) en Prot Warrior.

### Werkafspraak bij het lezen van SavedVariables
**`/mh apply` en DAN `/reload`.** Het bestand wordt bij de reload geschreven, dus andersom
lees je altijd het vorige plan. Dit heeft vanavond drie rondes gekost.

Nog open van eerder: het drievoudige buff-icoon (`docs/NEXT_UPLOAD.md`), de optionele
EllesmereUI-bar-preset, Arcane Explosion + Dragon's Breath toevoegen aan de Mage-data.

## 📍 Waar we gebleven zijn (6 aug 2026, eind van de avond)

**De Coiled Isle is in kaart gebracht, vijf dagen voordat hij op live bestaat.**
Vanochtend hadden we niets over die zone; nu staat hij in de rares-tab en vinkt
zichzelf af. Alles gemeten, niets overgenomen — HandyNotes dekt het eiland niet en
online staan geen coordinaten.

Wat er ligt (`Modules/Rares.lua`, achter `IsSeason2Visible`, dus onzichtbaar op live
tot 11 aug):

    9 rares met naam, npcID, coordinaat en 7 gemeten kill-quest-ids
    Gnarldor Isle, de delve van de zone, ingang 64.5/77.7
    map 2642 als tweede kaart van het eiland (Nar'zira staat daar)
    22 schatnamen uit de achievement, 5 met coordinaat

**Hoe de quest-ids gevonden zijn.** Een kill vlagt meer dan een quest, dus een enkele
kill kon niet zeggen welke van de rare was. Acht kills gaven acht verschillende ids in
de band 98344..98354, geen twee hetzelfde. De Malformed Leviathan vlagde er geen —
en dat is precies de enige die een EVENT is ("Defeat the Monstrosity!"). De
uitzondering landde waar een uitzondering voorspeld was; daarmee werd het een meting
in plaats van een patroon.

### Nog te meten op de PTR — kan alleen voor 11 aug

1. **De secure klik-knoppen.** Staat al sinds 5 aug op P0 en is nog steeds open. Het
   enige echte patchdag-risico dat we niet getest hebben: party targets is een
   aangekondigde functie, 12.1 brengt nieuwe taint-machinerie, en op 3 aug kostte een
   taint-fout al het complete targetten.
2. **De curio-dump.** `DelveCuriosAdvisor` loopt al door Valeera's trait-tree; de
   curio-slots zitten in dezelfde boom. Een dump geeft de hele Season 2-set in een
   commando in plaats van een screenshot per curio.
3. **Venom Lancer Ori'kassi en de negende rare** (quest 98348, gedood op 44.1/50.4,
   identiteit onbekend — er staat geen enkele vignette binnen 4% van die plek).
   Beide elites verschijnen alleen tijdens een event, dus dit is geluk hebben.

### Code repareren voor 11 aug

- **De curio-popup komt leeg op.** `DELVE_CURIOS_BY_SEASON` heeft alleen `[1]`, en de
  terugval naar seizoen 1 is er terecht uitgesloopt — maar het venster komt nog wel op,
  met een naamloos icoontje. Zwijgen als je niets weet.
- **De tier-advisor kent zes tiers.** Rob haalde de achievement "Midnight Delves:
  Tier 11 (Season 2)". Bewezen, niet afgeleid uit een dropdown.
- ~~`/mh kicks who` stond nog in de tekst die spelers lezen~~ — gedaan 6 aug.

### Wat vanavond nog meer boven kwam

- **`IsQuestFlaggedCompleted` als los globaal bestaat niet meer op 12.1.** Alles van ons
  ging al via `C_QuestLog`; ~147 kale aanroepen staan in Robs ANDERE addons en die
  gooien op patchdag een fout. Niet onze zorg, wel handig om te weten.
- **Vier onbewaakte GUID-splits gerepareerd**, waarvan twee in uitgebrachte code
  (`RaidCoachData` en `SporefallCoach` op `UnitGUID("boss1")`). Een secret string
  passeert `type()`, dus die check zei niets.
- **Season 2-crests heten Mistcrest** (Hero/Myth). Alleen namen; ids nog niet gemeten.
- Nieuw gereedschap dat blijft: `/mh goto x y [naam]`, `/mh capture <label>` schrijft
  nu weg naar SavedVariables, `/mh questdiff` met `check`/`probe`/`now`.


## 📍 Waar we gebleven zijn (4 aug 2026, eind van de avond)

**Voor Carola gebouwd: de overlevingskaart** (`Modules/SurvivalPlan.lua`), bovenaan
de DPS-track van de Role Academy. Zij speelt Frost Mage, gaat snel dood bij rares
en weet niet welke knoppen. De kaart toont haar eigen spells in de volgorde die een
gevecht vraagt, niet als lijst. Geen nieuwe spell-data: alles komt uit de
`KeybindRoles_*`-classifier, dus het werkt meteen voor alle dertien klassen.

Vier fouten uit die avond, alle vier gemeten in plaats van beredeneerd — de laatste
pas nadat ik er drie keer naast had gezeten:

| symptoom | oorzaak |
|---|---|
| Alter Time ontbrak | classifier heeft `role` **en** `category`; ik las alleen `role` |
| "Blink" beloofd, kwam nooit | Mage gebruikt `mobility` niet; Blink zit op `utility_primary` |
| Shimmer + Greater Invis dubbel | twee sleutels lossen op naar één live spell (vervangingen) |
| Ice Block ontbrak | **de naam "Ice Block" levert spell 414658 op** — een naamgenoot die Rob niet heeft. Zijn echte is 45438 |

Daaruit volgt een regel die breder geldt dan deze kaart: **naam-opzoeken is niet
uniek, en `IsPlayerSpell` op een vervangen spell zegt false.** Elke plek in MH die
zo werkt heeft hetzelfde gat — `GetKnownClassDispels` en de purge-detectie van
3 aug staan bovenaan die verdenking. Nog niet nagekeken.

Meetgereedschap dat blijft staan: `/mh survival` schrijft per spell weg wat elke
aanroep teruggeeft. Dat loste het in één run op.

Ook gerepareerd: het Nederlandse `MBUFF_TXT_MISSING` stond op **"MIST"**, wat als
nevel leest. Nu "ONTBREEKT". Rob vroeg zelf wat het betekende — Carola zou dat niet
gevraagd hebben.

**Open, met Robs eigen woorden erbij:** hij vindt zijn toetsenoverzicht "zo groot en
breed, dat is zo onoverzichtelijk". Voorstel besproken maar níet gebouwd: een kaart
van hooguit acht regels met per rol de spell én **de toets waar hij nu echt onder
zit**, inclusief "niet ingesteld" waar er geen bind is. `GetActionInfo` en
`GetBindingKey` zijn beide beschikbaar (geverifieerd). Dat "niet ingesteld" is het
punt: hij zei zelf dat hij niet alle keys heeft ingevuld.

## 📍 Waar we daarvóór gebleven waren (3 aug 2026)

Rob stopte omdat hij moe was; dit is de plek om weer op te pakken.

**Ongetest en dus het eerste wat moet gebeuren.** Er is die avond veel gebouwd dat
Rob niet meer heeft kunnen proberen:

| wat | commando | stand |
|---|---|---|
| Actie-hint: interrupt + purge in beeld | `/mh prompt` | **nooit werkend gezien.** Twee fouten al gefixt (`84d1470`): verkeerd widgettype en de verkeerde soort dispel |
| Dispel-indicator naast een groepslid | staat in het targets-paneel | gebouwd, ongetest |
| Tank bovenaan + oplichtende rij + marker rechts | idem | gebouwd, ongetest |

Testvolgorde voor `/mh prompt`, en houd hem aan — hij scheidt drie soorten fout:
1. vage gele omlijning buiten gevecht? zo niet: staat niet aan of laadt niet
2. Silence-icoon bij een onderbreekbare cast
3. Dispel Magic-icoon bij een vijand met een afneembare buff

Zie je 1 wel en 2/3 niet, dan zit de fout in de detectie en niet meer in het
tekenen.

**`ns.OFFENSIVE_PURGES` bevat alleen PRIEST (528).** Bewust: de andere klassen zijn
weggelaten in plaats van gegokt. Vul ze pas aan met geverifieerde ID's zodra Rob
bevestigt dat het Priest-icoon verschijnt.

**Nog open, los daarvan:**
- **Lag-test.** Rob merkte hapering na een kill. Nooit uitgevoerd: paneel uit via
  `/mh partytargets`, een paar pulls, blijft het? Dat is de hele test.
- **Positieve controle op de combat log** — zie het blok hieronder.
- **`DISPELLABLE`: "door jou" of "überhaupt"?** Onbeslist, en het bepaalt de
  woordkeuze van de dispel-helper.

⚠️ **Alles hierboven zit op `main` en in GEEN release.** De `.toc` staat nog op
2.11.1. Met 12.1 op 11/12 aug moet iemand beslissen wat van deze avond mee mag in
2.12.0 en wat wacht — het is allemaal ongetest gebruikersfunctionaliteit.

Achtergrond bij de dispel-doorbraak en de concurrent: `docs/SPELLPILOT_TEARDOWN.md`.

## ⚠️ 12.1-risico op wat we deze week bouwden (uit de API-wachter, 4 aug)

De API-wachter meldt "geen relevante wijzigingen deze week" — correct, want de
grote 12.1-aurawijzigingen dateren van 15–18 juni en vallen buiten zijn venster.
Maar ze staan wél in zijn controlenotities, en ze raken precies onze nieuwste code:

> "All of the UnitAura APIs will now either return full secrets or nil when
> called by addons"

Plus: `C_UnitAuras.TriggerPrivateAuraShowDispelType` **verdwijnt**, en er komt
nieuwe taint-machinerie (Forbidden Aspects, Private Script Objects,
UntrustedScriptExecution, `securecopy`, `CreateSecureDelegate`).

Twee dingen van deze week staan daarmee op losse schroeven, en beide zijn op
**live 12.0.7** gemeten, niet op de PTR:

1. **Dispel-helper** (`AllyHasRemovableAura`, het `HARMFUL|DISPELLABLE`-filter).
   "Full secrets or nil" kan het filter stil of onbruikbaar maken. Meet dit op de
   PTR vóór 11 aug, niet erna.
2. **Party-targets secure buttons.** Daar is op 3 aug al een taint-fout uitgehaald
   (`786cae1`); nieuwe taint-mechanismen zijn geen goed nieuws voor code die daar
   net doorheen is.

De aura-facade `ns.Aura` bestaat juist voor dit moment — als het filter valt, is
dat de plek waar de vervanging hoort.

## ⛔ DE COMBAT LOG IS DICHT — voor élke addon, ook DBM (gemeten 5 aug)

Dit vervangt alles wat hieronder over "wie heeft er onderbroken" staat, en het
raakt meer dan die functie.

Rob draaide **Windrunner Spire, difficulty 1** (Dungeon Normal, de meest
whitelistbare content die er is) met `/mh kicks probe` aan. Resultaat:
`ADDON_ACTION_FORBIDDEN`, nul onderbrekingen, `clogRegistered = false`. **Elke
poging die deze addon ooit heeft vastgelegd is een weigering** — Timewalking 3×,
nu Normal. Er is nooit één meting van succes geweest.

De aanname eronder was fout, en stond in onze eigen code: *"DBM registreert CLEU
en kondigt bossen aan in diezelfde dungeon, dus het kan"*. `DBM-Core.lua:1680`
zet `COMBAT_LOG_EVENT_UNFILTERED` onder **"Events that must be blocked from
registering on Midnight+"**, en regel 2532 registreert ze alleen
`if not DBM:IsPostMidnight()`. DBM kondigt bossen aan zónder combat log.

**Twee gevolgen:**
1. `/mh kicks who` kan nergens werken. Staat uit, wordt niet aangekondigd.
2. **De death recap kan sinds 12.0 geen doodsoorzaak vaststellen** — die vult zijn
   damage-ring uit dezelfde registratie. Een uitgeleverde functie die stil niet kan
   wat zijn naam belooft. De vervanging ligt voor de hand (Blizzards eigen Death
   Recap, die we in restricted content al openen) maar is een ontwerpkeuze van Rob.

Niet "de whitelist repareren". Er valt niets te whitelisten. Volledige uitleg met
regelnummers staat bovenaan `Modules/Retrospective.lua`.

**Wél mag:** reageren op het feit dát een event vuurt. `EXBoss` speelt geluid op
`UNIT_SPELLCAST_START` voor `boss1-5` — dat een gebeurtenis plaatsvindt is geen
secret, alleen de inhoud is dat. Vandaar dat `/mh prompt` wel werkt.

## ⛔ "Wie heeft er onderbroken" — de oudere analyse, achterhaald door het blok hierboven

Rob vroeg op 3 aug om hem hieraan te herinneren. De stand, gemeten:

| content | stand |
|---|---|
| Timewalking (difficulty 24) | **onmogelijk.** 3 weigeringen, 3 dungeons, 3 dagen: Dire Maul + Zul'Farrak (25 jul), The Shattered Halls (3 aug), alle `ADDON_ACTION_FORBIDDEN` |
| Delves (208), ritual scenarios, follower dungeons | onmogelijk, bij ontwerp — restricted content |
| Normaal / Heroic / M+ / raids | **zou moeten werken; NOOIT positief bevestigd** |

De functie is gebouwd (`/mh kicks who`, `Modules/InterruptScore.lua`) en de route is
juist: `SPELL_INTERRUPT` uit de combat log, meegelezen op de registratie die
`Retrospective.lua` al bezit. Het goedkope alternatief is dood gemeten — het veld
`interruptedBy` op `UNIT_SPELLCAST_INTERRUPTED` is **secret** zodra de onderbroken
caster vijandig is (40 metingen: 28 nil, 12 secret, nooit leesbaar).

Wat ontbreekt is een **positieve controle**: in elke vastgelegde meting tot nu toe
stond `clogRegistered = false`. Eén run in een gewone of Heroic dungeon met
`/mh kicks probe` aan zou dat beslissen. Doe die vóór je iets belooft — dat "de
whitelist zegt dat het mag" is precies het soort redenering dat hier al vier keer
fout ging.

En het echte open raadsel: **DBM lukt het wél op difficulty 24.** Die difficulty
meldt `hasSecretRestrictions = true`, wat de wél werkende difficulties niet doen.
Dat is nu een spoor in plaats van een vaag vermoeden.

## Laatste sessies (31 juli - 1 augustus)

**2.11.1 uitgebracht als correctierelease.** Een wekelijkse crest-cap van 100 die niet
bestaat stond in zeven talen uitgeleverd. Rob: "eerlijkheid boven alles". De claim is
eruit, en de reden dat er niets voor in de plaats komt staat met falsifiers in
`docs/CREST_SOURCES_MEASURED.md:275` -- want de watcher heeft die 100/week daarna
alweer een keer herhaald. Voeg hem niet terug omdat een gids of een watcher hem noemt.

**Vertalingen: ~400 afgemaakte strings per taal bereikten spelers nooit.** `fill()` in
`Translations2026.lua` zette een sleutel alleen als de pack hem miste, maar de/fr/es/pt
kopiëren eerst de hele enUS-pack -- dus miste er nooit een. Duits ging van 58,3% naar
72,0% na de fix (`d84722b`). Drie van mijn eigen i18n-tools hadden bovendien een
blinde vlek voor sleutels op kolom 0 (`1e37354`); de linter niet.

**Party-targets-paneel gebouwd** (`5df63ed`). In 12.x is de naam van een vijandig
doelwit secret: je mag hem **tonen** maar niet **lezen**. `UnitExists` leest wel, en
dat is de rijgate. Onderweg twee keer een conclusie ingetrokken die op een steekproef
zonder doelwit berustte -- "combat is de gate" was fout (`b9b7ad7`).

**Ritual-tier: afgesloten, met controle.** Een ritual publiceert zijn tier nergens:
gemeten binnen de content over 856 widgets in 268 sets, mét een positieve controle die
in een delve wél een tier vindt. Tier 0 in RitualLog betekent onbekend en moet dat
blijven. Volledig verhaal in `docs/RESEARCH_12_1.md`; de eerste, te stellige versie is
daar zichtbaar ingetrokken.

**De winst zat aan de delve-kant** (`f2f4061`). `DelveHistory` noteerde bij ~10 van 30
runs een tier omdat het cijfers uit `difficultyName` viste -- en in een delve is die
string "Delves", difficultyID 208, zonder cijfer. Het getal bestaat alleen als
displaytekst op widget 6183 (`tierText`), precies waar DBM het altijd al las. De fix
staat live en is bewezen tot in `activeRun` (tier 0 -> 11); **wacht nog op één
afgeronde run als eindbewijs.**

**Knowledge Runtime is gemerged en laadt** (`e9bf7f8`) -- `Modules/Knowledge*.lua`
staan in de `.toc`. Dat is het werk van de tweede sessie; werkafspraken in
`docs/TWEE_SESSIES_WERKAFSPRAKEN.md`, bestandseigendom inbegrepen. De RFC-status
hieronder is van 30 juli en beschrijft die sessie, niet deze -- vraag het daar na
in plaats van het hier te lezen als actueel.

**Voorstel klaar, niet gebouwd:** tier-advies bij de obelisk uit `suggestedILvl`
(215/231/244/257/264/274), tegen je eigen ilvl. Zie `docs/PROPOSAL_TIER_ADVISOR.md`,
inclusief de openstaande vraag of `suggestedILvl` een slot is of alleen advies.

## Laatste sessie (30 juli) -- Knowledge Runtime, RFC-002

**RFC-002 is geschreven maar NOG NIET GOEDGEKEURD.** Het document staat in
`docs/RFC-002_KNOWLEDGE_RUNTIME.md`. Het legt de grens vast tussen de upstream Knowledge
Objects (ChatGPT-eigendom) en de addon: YAML upstream -> build-time transpiler ->
gegenereerde Lua, een **pure** evaluator zonder WoW-API-calls, een request-builder als
enige clientlaag, en een debug-sink (`/mh know`) zonder frames. Er is **geen code**
geschreven: geen Lua, geen `.toc`, geen transpiler, geen fixture-runner.

Vijf deelbesluiten zijn op 30 juli bevestigd: de pipeline-orde (eerst een geldige route,
dan Timebox als gate), drie-waardige logica (`null` = onbekend, vuurt nooit automatisch),
de verplichte `copy_keys`-lintcheck (enUS **en** nlNL), O1 als blokkade, en de
fixture-08-attributiecorrectie.

**EERSTVOLGENDE BLOKKADE = O1.** De geleverde catalogus (`normalized_ko_catalog_v0.3`)
bevat drie van de zes objecten. `MH-KO-WEEKLY-POWER-1207-001`,
`MH-KO-CONFIDENCE-1207-004` en `MH-KO-PREREQUISITE-1207-005` ontbreken, terwijl twee
aanwezige objecten er via `external_output_ref` naar verwijzen -- de eigen approval-gate
"all output refs resolve" faalt dus. **Bouw geen transpiler tegen die catalogus**, en
gebruik de v0.2-versies niet als tijdelijke vervanging (schema-v0.2-vorm: geen `derived`,
geen `materiality`, `output:` i.p.v. `outputs:`). Wachten op zes v0.3-objecten van
ChatGPT. Daarna nog open: O4-O6 en O8 (zie RFC §11b).

Twee dingen die de repo-analyse hard maakte en die je niet opnieuw hoeft uit te zoeken:
een runtime YAML-loader **kan niet** (WoW-Lua heeft geen file-I/O), en de **live
aanbevolen itemlevel is nergens uit de client leesbaar** -- `DELVE_LOOT_TABLE`
(`Modules/Delves.lua:233`) is hardcoded en expliciet "UI hint only". Dat veld blijft
`null` tot een ApiProbe-achtige meting het tegendeel bewijst.
`ns.GetNextWeeklyAction()` blijft eigenaar van de This Week-headline.

## Laatste sessie (28 juli) -- wat er nu open ligt

**Aura-onderzoek: doorbraak.** Enumeratie sterft in gevecht, maar **vragen op spell-ID
niet** -- `ns.Aura.GetPlayerAura(id)` antwoordde 155x in gevecht met spellId, name en
dispelName allemaal leesbaar. De dispel-helper is daarmee weer haalbaar; de 12.1-migratie
is "stop met enumereren, ga vragen op id". Ook gemeten: `dispelName = nil` overleeft
geheimhouding, dus **secret = heeft een school, nil = heeft er geen** -- genoeg voor "er
staat iets dispelbaars op je" zonder spell of school. Volledig in `docs/RESEARCH_12_1.md`
en in de header van `Modules/DispelCapture.lua`.

**Openstaand, meet zichzelf:** de *dekking* van de lookup. De probe miste ook ~12 id's;
meeste waren korte procs, maar Warband Mentored Leveling (430191) hoort permanent te zijn.
Er draait nu automatisch een dekkingscheck buiten gevecht (enumeratie als ijkpunt tegen de
lookup). **Lees `ns.db.dispelLookupLog` uit de SavedVariables aan het begin van de sessie**
-- rijen `gap/<id>` en `coverage/idle` zijn het antwoord. Nog helemaal onaangeroerd:
**party/raid**-auras; alles hierboven gaat over je eigen auras.

**Gebouwd op 28 juli:** Great Vault-indicator voor de S2-bonusrol (3 gevulde slots,
drempel is PTR-bron en staat als een enkele constante in `VaultAdvisor.lua`); Quest
Hubs-knop gesplitst in Ritual Site + Void Assault hub (routeren nu allebei); FastMark-balk
omgedraaid (world markers boven, target icons onder). Alles gepusht, niets uitgebracht.

**Werkwijze die zich bewees:** lange diagnose niet in chat maar opnemen tijdens het spelen
-> SavedVariables -> ik lees het bestand. Rob hoeft midden in een gevecht niets te typen.

## De klok

Patch **12.1 "Curse of Ula'tek"** is een release candidate (build 68914).

**Season 2 is OFFICIEEL: 18 augustus.** Blizzard-artikel "The Shadows Deepen: Midnight
Season 2 Begins August 18" (24294369) met de volledige unlock-planning. Onze wachter
logde het op 30 juli; de publicatiedatum zelf is niet nagetrokken en staat er daarom
niet meer als feit -- Massively OP schreef er al op 29 juli over. Status
gaat daarmee van `COMMUNITY_REPORTED` naar `OFFICIAL_CONFIRMED`, en de datum **mag**
speler-zichtbaar worden getoond -- dat was de enige reden dat we zwegen.

Wat het artikel bevestigt: week van **11 aug** Heroic + Mythic 0 + de S2-dungeonrotatie
(8) + Lair op World Difficulty; week van **18 aug** M+, Great Vault S2-gear, raid The
Venomous Abyss (eindbaas Ula'tek), Bountiful delves + keys. RF-wings volgen 25 aug,
1 sep en 8 sep. Bron:
https://news.blizzard.com/en-us/article/24294369/the-shadows-deepen-midnight-season-2-begins-august-18

**De patchdatum is OOK officieel: 11 augustus.** Ik schreef hier eerst dat die een
projectie bleef "omdat het artikel weken noemt, geen patchdag". Dat kwam doordat ik
alleen het Season 2-artikel had gelezen. Blizzard publiceerde er drie, en het tweede
heet letterlijk **"Curse of Ula'tek Goes Live August 11! Journey to the Coiled Isle"**
(article 24294370), met in de tekst "One week after the content update goes live the
new season will begin". Beide datums staan dus op `OFFICIAL_CONFIRMED`.

Let op het EU-verschil: 11 aug is een Amerikaanse dinsdagreset, dus hier woensdag
**12 aug**. Vandaar dat de speler-zichtbare tekst in *weken* praat en niet in dagen --
voor een addon in zeven talen met spelers in beide regio's is dat het enige eerlijke.

Praktisch gevolg: **2.12.0 moet vóór 11 augustus klaar zijn**, patchdag vrij voor
hotfixes. En blok 12 (`/mh zone` draaien in Coiled Isle om de mapID te meten) is nu
inplanbaar op 11/12 augustus in plaats van "ooit".

Voorgestelde volgorde (Rob akkoord 2026-07-27): 2.12.0 een paar dagen **voor** patchdag,
patchdag zelf vrijhouden voor hotfixes, en 3.0.0 bij de seizoensstart -- want op patchdag
is alle S2-content nog seizoen-gated en dus onzichtbaar.

---

## Twee aparte lijsten. Verwar ze niet.

Op 27 juli beantwoordde ik "wat staat er nog open?" met alleen lijst B, terwijl Rob
lijst A bedoelde. Beide zijn echt; ze horen bij verschillende dingen.

### A. Het RELEASEPLAN -- uit `MH_HANDOFF_2026-07-24.md` (Robs zip, niet in de repo)

**2.11.0 -- AFGEROND EN UITGEBRACHT.** Blok 1, 5, 10, 2 en 16 zijn allemaal gebouwd en
zitten in de release. Blok 6 (Carola-test v2) is **niet** gedaan en was Robs werk; dat
schuift door naar 2.12.0. Deze tabel is historie -- gebruik hem niet meer als takenlijst.

**2.12.0 -- "klaar voor de patch"**

| Blok | Wat | Stand |
|---|---|---|
| -- | Roleset | **GEMETEN 27 jul, GEEN blocker.** Systeem draait al; alles `roleless`, niets gefilterd. Restrisico = een actieve allowlist zonder `roleless`; te detecteren met `Frame:IsRolesetFiltered()` |
| -- | `.toc` | **AF 27 jul.** `## Interface: 120007, 120100` — beide versies, dus geen out-of-date-melding op live én op 12.1, en geen bump nodig op patchdag |
| 12 | Coiled Isle-scaffold + lege-zone-guard | **guard AF 27 jul** (`ns.IsZoneCovered`, `/mh zone`). Het scaffold zelf KAN NIET: de mapID van Coiled Isle is nergens gedataminet. Op patchdag `/mh zone` draaien in de zone, dan is hij gemeten |
| 11 | Crest-teksten ontnamen (115 strings) | **AF 31 jul** (`907171f`). De naamgeving bleek al gedaan: geen enkele locale-string bevat "Dawncrest", namen komen live uit `C_CurrencyInfo`, zoektermen waren al additief. Het echte gat was de DATA -- `DAWNCREST_TIERS` was S1-only, dus na de flip zouden beide crest-panelen bevroren Dawncrests tonen. S2-ids (Mistcrest, PTR-gemeten) staan er nu naast, `IsSeason2Live` kiest. De currency-gids somde de vijf ids op in 7 talen; dat is nu één `{CRESTS}`-token uit dezelfde data |
| 7 | Nieuwkomer-detectie aansluiten | **AF.** Deze rij zei tot 2 aug "wordt nergens gebruikt"; dat was achterhaald. `ns.IsSeasonNewcomer` (`Modules/SeasonTransition.lua:47`) wordt gebruikt op regel 80 (zet `provenSeasonExperience` zodra M+-score bewijst dat iemand gespeeld heeft) en op 329 (`/mh seasontransition` maakt het oordeel zichtbaar -- zonder die regel is de bedrading niet waarneembaar). Let op de drie-waardigheid: `false` = aantoonbaar gespeeld, `nil` = onbekend |
| 9 | Prey: Codex-entry + probe | **AF 27 jul.** Codex-artikel `prey_hunts` (world, zonder getallen) + `/mh prey` dat je voortgang uit de achievement-criteria leest. Bodies alleen en/nl; de vijf andere talen krijgen alleen de titel en vallen voor de tekst terug op enUS — bewust, dat is werk voor vertalers |
| 6 | Carola-test v2 | **GESLAAGD 31 jul, zonder geënsceneerde test.** Carola speelt sinds 2.11.0 onafgebroken en hoeft niets te vragen. Dat is beter bewijs dan een testronde: het is gemeten onder echte omstandigheden, zonder dat er iemand meekeek. Zie de observatie hieronder voor wat het NIET aantoont |

**Losse observatie bij blok 6 — het eerste-keer-pad is nog door niemand getest.**
Carola's weken spelen bewijzen dat de addon haar dagelijkse spel niet in de weg zit.
Twee dingen bewijst het niet. Stilte is geen succes: mensen stoppen ook met vragen
als ze een omweg gevonden hebben of hebben besloten dat een onderdeel niet voor hen
is. En het first-run-pad (review F4.1) is principieel buiten haar bereik -- ze is er
allang voorbij, en haar vlag stond op "gezien" vóórdat de reparatie bestond.

Dat is precies het onderdeel dat je per persoon maar één keer kunt meten, en het
bepaalt of iemand die MH vers van CurseForge haalt blijft of na twee minuten
afhaakt. Het hoeft niet geënsceneerd: iedereen die de addon voor het eerst
installeert doet die test vanzelf, zolang niemand hem vooraf vertelt waar hij op
moet letten. Cisca, of de eerstvolgende die zich in Discord meldt.

`/mhfirstrun reset` wist de vlag en toont niets, zodat de volgende login het vanzelf
doet. `/mhfirstrun` zonder argument toont de popup meteen -- dat meet of het venster
werkt, niet of iemand het vindt. Instructie + de reden om niet te verklappen wat er
veranderd is: `docs/CAROLA_TEST_V2.md`.

**Los van releases:** blok 13+14 vertaalstatus + werkpakket 2 naar Discord -- doe dit
vroeg, iemand anders werkt in zijn eigen tempo. Blok 3 (PTR-capture-checklist) is op
27 juli grotendeels afgerond.

Nooit geland uit de handoff van 20 juli: **crest-bronnen per tier** en **spark-doel**.

### B. De FEATURE-BACKLOG -- door Rob goedgekeurd over tijd, niet tijdgebonden

- **Dispel-helper** -- sterkste volgende bouwwerk (Rob-goedgekeurd, luidste klacht,
  WeakAuras heeft niets voor Midnight, 12.1 levert `DISPELLABLE`-filters).
  `DispelCapture.lua` is alleen de dataverzamelaar; de helper zelf bestaat niet.
- Rest van het healer-initiatief: per-spec cooldown-cheatsheet, Academy-healcursus
  verdiepen, heal-lens bossmechanieken.
- **Spec 08** -- cross-listing in de interrupt-kaart. `alsoStop`-data klaar voor Paladin
  en JustAC-geverifieerd; de UI ontbreekt.
- **Openables** mist "Use: Collect X"-pakketten (bv. itemID 246752 -- komt nergens voor).
- Tank/DPS-toolkit bestaan al. Route-pijl hervat weer.
- Open onderzoek: CLEU-taint -- waarom MH geen combat log mag registreren waar DBM wel mag.
- **Edit Mode-detectie** (Rob-goedgekeurd 31 jul, NA 2.12.0). Wanneer de speler
  Blizzards Edit Mode opent, ook onze versleepbare balken hun grepen laten tonen --
  FastMark en MissingBuff. Winst is vindbaarheid: nu moet je wéten dat die balken
  te verslepen zijn.

  Let op wat dit NIET is. Blizzard heeft **geen registratie-API** waarmee een addon
  een frame in Edit Mode kan hangen; gecontroleerd in Plumber en SimplePartyTargets,
  beide geïnstalleerd. Die detecteren alleen `EditModeManagerFrame:IsEditModeActive()`
  en tonen dan hun eigen grepen. Onze sleepcode wordt dus niet vervangen -- er komt
  iets overheen. Het lost ook het combat-verbod niet op: die balken parenten secure
  buttons en blijven in gevecht onbeweeglijk, wat van Blizzards beveiliging komt en
  niet van ons.

  Na 2.12.0 omdat het precies de frames raakt waar de secure-regels het strengst
  zijn en die in juli met moeite goed kwamen. Plumber is het werkende voorbeeld om
  naast te leggen.

---

## Wat 27 juli opleverde (zit allemaal in 2.11.0)

- **12.1-blocker weg**: de CombatSafety secret-geometry-fix is bewezen in een PTR-delve
  (meerdere gevechten, BugGrabber bleef groen).
- **Aura-migratie is geen blocker**: `ShouldAurasBeSecret = false` binnen en buiten een
  delve op de RC-build. Let op: dat meet je EIGEN auras; groepsleden zijn nog ongetest.
- **S2-data compleet en machinaal geverifieerd** tegen de client: 14 ontbrekende
  encounterIDs ingevuld, raidvolgorde gecorrigeerd (stond in DBM-nummering, niet
  gevechtsvolgorde).
- **Vier Season 1-achievements automatisch**: 61797/61798/61799 + Prey-capstone 62351.
  Alle vier waren verborgen Feats of Strength.
- Nieuw gereedschap: `/mh ej`, `/mh ach`, `/mh delvescan`, `/mh valeera save`,
  `/mh poisons`, `/mh trail`.
- Metingen vastgelegd in `docs/PTR_S2_ENCOUNTERS.md`, `PTR_DELVE_SCAN.md`,
  `PTR_VALEERA_TREE.md`.

---

## Documentatie (werkafspraak met ChatGPT, 2026-07-27)

Dit bestand is het **enige** AI-handoffbestand. Maak geen `AI_HANDOFF.md` ernaast; twee
bestanden met dezelfde taak lopen uit elkaar, en dat kostte op 27 juli al een ronde.

| Bestand | Waarvoor |
|---|---|
| `docs/EVIDENCE_REGISTER.md` | Bewijsstatus per betekenisvolle claim of waarde |
| `docs/DOCUMENTATION_IMPACT.md` | Uitgaande voer voor boek/Notion — alleen speler-zichtbare kennis |
| `docs/RESEARCH_12_1.md` | Gecureerde samenvatting; de watch-docs blijven de bron |

Statussen: `OFFICIAL_CONFIRMED` / `IN_GAME_VERIFIED` / `ADDON_RESEARCH` /
`PTR_PROVISIONAL` / `COMMUNITY_REPORTED` / `UNKNOWN`. Bij seizoensdata hoort een
`source = { status, patch, checked, reference, notes }`-blok naast de waarde.

**TwelveInchy is een boekpersonage**, geen addon-systeem. In de repo staat die naam op
precies één plek: `## Author:` in de `.toc`. Geen dialoog of stem in de addon bouwen
tenzij Rob daar expliciet om vraagt.

**Datums per stuk beoordelen, niet als groep.** Dit stond hier als "datums zijn nooit
bevestigd" en dat is niet meer waar: **18 augustus voor Season 2 is officieel**
(Blizzard-artikel, zie De klok) en mag overal getoond worden. De **patchdatum 11/12 aug**
is dat niet -- het artikel noemt resetweken, geen patchdag -- en blijft dus buiten de
addon, release notes, CurseForge, Notion en Discord.

Een blanket-regel las prettig maar hield een bevestigd feit tegen. Toets de status van
de losse datum, niet de categorie.

## Werkafspraken

- **Lange diagnose-uitvoer gaat naar SavedVariables**, niet naar de chat: het commando
  krijgt een `save`-variant, Rob doet `/reload`, ik lees het bestand met `lua`.
- `tools/copy_to_ptr.bat` krijgt een **eigen** aanroep, nooit geketend achter git.
- De repo **is** de live AddOns-map -- elke edit landt meteen in Robs spel. Scripts
  atomisch schrijven (`.tmp` + `os.replace`).
- Voor afronden: `luac -p` en `python tools/lint_addon.py` (HARD moet 0 zijn).

```text
/reload
/mh ej            (bossenlijst uit de Encounter Journal; `save` schrijft naar SV)
/mh ach <tekst>   (achievement-ID zoeken; `id <n>` toont criteria en beloning)
/mh delvescan     (welke delves biedt de client aan)
```

GitHub Actions nakijken zonder `gh` (dat staat hier niet geinstalleerd; de repo is
publiek, dus de web-API is zonder inloggen leesbaar):

```bash
curl -s "https://api.github.com/repos/Huijting/MidnightHelper/actions/runs?per_page=3"
```

---
---

# Historie

Alles hieronder is oud logboek, bewaard maar niet bijgehouden.

# Next session — Midnight Helper

## ✅ FASE 4 AFGEROND (2026-07-08, Opus 4.8 — backlog 15, 19–21) → HELE REVIEW-BACKLOG DICHT

**De volledige 21-item review-backlog (Fase 1 t/m 4) is nu afgewerkt.** Fase 4-hoogtepunten:
- **TOC-metadata + README** (item 15): Author=TwelveInchy, Category, MIT, X-Website, 6-talige Notes,
  `X-Curse-Project-ID: 1528577`, AddonCompartmentFunc; README interface 120007/Italiaans/features.
- **Auto-release packager** (item 19): `.pkgmeta` + `.github/workflows/release.yml` (BigWigs) → versie-tag
  publiceert naar CF. **Dry-run gevalideerd** (`package-test.yml`): zip + uitsluitingen kloppen, CLAUDE.md eruit.
  Rob heeft `CF_API_KEY`-secret gezet. CF-omschrijving: hook + "See it in action" + versie-markers weg.
  Screenshot-scènelijst in `docs/SCREENSHOTS_WANTED.md` (Rob schiet + uploadt in CF-gallery).
- **Data-afronding** (item 20): LVL8090-tips vertaald naar de/fr/es/pt/it (225 strings → leveling-tab 7-talig);
  delve-aantal ontkoppeld (§5.6 = 10 uit MH-data); Val/Naigtal treasure/lore geverifieerd (niks toe te voegen).
- **LuaLS-basis** (item 21): `.luarc.json` + `---@class MHDB`/`MidnightHelperNS`-annotaties.

**Nog open (laag-prio, wacht op Rob in-game):** hero/Apex-keybinds (§5.4, `/mhautomap` op lvl-90 Ret);
consumables-regeneratie (Wowhead); backlog-18-rest (slash-router e.a., bewust geparkeerd); optionele
repo-hygiëne (zwerfbestanden Platy1.tga-root/PHASES.txt/Sync-bats, checklist-dedupe).

**Nog NIET gereleased** — geen versie-bump/tag gedaan. Rob bepaalt wanneer (dan: `.toc` versie bumpen +
changelog + annotated tag pushen → auto-CF). **Hierna: nieuwe ideeën** (Rob's plan).

**Rob's WIP** blijft ongemoeid: `docs/PTR_12.0.7_DATA.md` + `docs/PTR_12.1_WATCH.md` (zijn Void Showdown / PTR-planning).

**Al gedaan + gepusht (deze avond):**
- **README** geactualiseerd (interface 120007, Italiaans, feature-lijst) — `54ba082`.
- **Auto-release packager** (backlog 19): nieuw `.pkgmeta` + `.github/workflows/release.yml` (BigWigs packager) — `3ec0ad4`. CLAUDE.md blijft uit de zip.
- **TOC-metadata compleet** (backlog 15): Author=TwelveInchy, Category, MIT, X-Website, keyword-rijke Notes 6 talen, `X-Curse-Project-ID: 1528577`, + **AddonCompartmentFunc** → `MidnightHelper_OnAddonCompartmentClick` (Broker.lua) — `3dc7153`.
- **Minimap-icoon aan/uit-toggle** (declutter; MH ook via AddonCompartment/`/mh`/Alt+M) 7 talen — `c9288b0`.
- **Settings-in-combat-guard** (`OpenSettingsPanel` is protected in combat) 7 talen — `46b569e`.
- **Delve secret-crash fix** (`GetUnitSpeed` secret in delves) — `7c2111f`.
- **Eruundi/Asha (§5.2) opgelost via HandyNotes**; **§5.3 secrets-API opgelost via addon-cross-check** — `9a517e5`. Beide items 6+14 klaar, GEEN in-game meting meer nodig.
- **First-run popup** noemt nu **Alt+M** (+ /mh) 7 talen — `7ff200e`.

**⚠️ Rob's enige openstaande actie voor auto-release:** `CF_API_KEY` GitHub-secret toevoegen
(token van legacy.curseforge.com/account/api-tokens). Daarna: versie bumpen + `git tag vX.Y.Z && git push origin vX.Y.Z` → auto-upload naar CF.

**NB Rob draait EllesmereUIMinimap** → verbergt/verplaatst de default AddonCompartment-knop; daarom "niets rechtsboven". Alt+M (Bindings.xml default) is voor hem de opener.

**Nog te doen in Fase 4 (morgenavond):**
- **Item 20 — data-afronding**: Naigtal/Val treasures + lore uit HandyNotes (Rob's data-bestanden zijn schoon gecommit; z'n WIP zit alleen in `docs/PTR_12.0.7_DATA.md`); LVL8090-vertalingen (de/fr/es/pt/it via Translations2026); consumables-check. Zie [[handynotes-rare-coords-trusted]].
- **Item 21 — LuaLS-basis**: `.luarc.json` + `---@class MidnightHelperNS`/`MHDB`-annotaties (dev-only).
- **Item 19-rest**: CF-description met doelgroep-hook + "See it in action"-sectie (lever Rob 4–5 screenshot-scènes; schieten doet Rob); RELEASE_CHECKLIST-dedupe; zwerfbestanden (Platy1.tga root-dup, PHASES.txt, Sync-*.bat).

**Nog te bevestigen door Rob in-game (laag-prio):** §5.5 niet-Engelse keybind-client, §5.8 native settings, §5.10 chat-lockdown in M+.

---

## ✅ FASE 3 UITGEVOERD (2026-07-07, Opus 4.8 — backlog 11–14 + 18, fundament)

Rob's Void Showdown-WIP is eerst gecommit (4 commits: `b13f905` rares/meta's, `254537c`
/mh capture, `1683cdd` Openables knowledge-detectie, `2d2f8b1` PTR-log) zodat Core.lua schoon
was. Daarna Fase 3:

- **`811b816` — SavedVariables-schema (backlog 11, F3.2).** `db.schemaVersion` + geordende
  idempotente `MIGRATIONS`-tabel in `InitSavedVariables` (vóór MergeDefaults). Migratie v1 wist
  spookvelden (`altOverviewExpanded` — werd eeuwig her-seeded, uit DEFAULT_DB gehaald; `simpleMode`)
  en onderdrukt de first-run-popup voor terugkerende spelers (fresh-install-detectie). Array-velden
  (favourites) bewust NIET in DEFAULT_DB — MergeDefaults merget lijsten per index.
- **`d6b9af8` — NativeArrow GC (backlog 12, F3.3).** ~30 Hz-loop: continent per mapID gecachet,
  doel-wereldcoords per lead, label alleen bij wijziging. Gedrag ongewijzigd.
- **`5b7f0de` — Events scenario-gated (backlog 13, F3.4).** RitualBossCoach UNIT_SPELLCAST_*/UNIT_AURA
  register bij scenario-enter, unregister bij leave; UNIT_AURA op "player". AccessibleAlerts UNIT_AURA idem.
- **`a8409ad` — UI-hygiëne (backlog 18 DEEL, F3.7/F3.8).** Font-krimp-fix (cumulatief deDE/frFR),
  simple-mode dode code weg, OnDragStop-dedup, dungeons→delves-remap weg.

**Geparkeerd:** backlog 14 (MissingBuff secrets-API) wacht op §5.3 `/dump C_Secrets.ShouldAurasBeSecret`.
Backlog 18 grotendeels bewust geparkeerd (35-taks slash-dispatch-table = hoog risico/laag user-value;
ShareSync-factory; ns.SafeCall; SMC-teksten; micro-opts) — zie rapport-item 18 voor de volledige lijst.

**Volgende: Fase 4** (boven de rest uitstijgen — backlog 15, 19–21: TOC-metadata/README, `.pkgmeta`+packager,
CF/Wago/WoWI-descriptions + screenshots, data-afronding, LuaLS-basis). Openstaande in-game-tests: §5.2
(Eruundi), §5.3 (secrets-dump), §5.5, §5.8, §5.9, §5.10.

---

## ✅ FASE 2 UITGEVOERD (2026-07-06, Opus 4.8 — backlog 7–10 + 16–17, onboarding-excellentie)

Drie commits op `main` (Rob's WIP niet meegecommit). Rob koos **popup + chathint** voor first-run.

- **`4ce2bce` — Tour/Start Here (backlog 8 + deel 17).** Tour-ESC (F4.2): overlay vangt ESC zelf
  op (propageert niet → hoofdvenster blijft open) + `EndUITour()` bij OnHide hoofdvenster. Tekstschaal
  (F4.6): tour-bubbels + Start Here-titel volgen de fontScale-slider (`ns.MHScalableFont`). Copy (F4.6):
  Tap/Tocca/Pulsa/Toque → klik-taal; "Show me"-verwijzing weg. **Test (§5.9):** start tour, ESC → alleen
  de tour sluit.
- **`1d64bb1` — Venster/settings (deel 17).** Vensterpositie onthouden (F4.6, grootte werd al onthouden);
  expliciete defaults voor mh_openLogin/mh_compact/mh_arrowMeters (Blizzard "Standaard" reset niet meer
  naar login-waarde); AccessibleAlerts-toggle nu in native settings (nieuwe `ns.SetAccessibleAlertsEnabled`).
  **Test:** sleep het venster, /reload → blijft op plek; native settings → "Toegankelijke gevaarmelding".
- **`45828be` — Onboarding + jargon (backlog 7, 9, 10, 16).** First-run (F4.1): `Modules/FirstRun.lua`,
  chathint + popup bij allereerste login, vlag `ns.db.firstRunSeen`, standalone (raakt Core.lua niet) —
  **test: `/mhfirstrun`**. Home-blok (F4.4): Start Here-link + rondleiding-knop. Settings-tooltip (F4.3):
  slider i.p.v. A-/A+-knoppen (7 talen). Jargon (F4.5): kaartkop-tooltips (7 talen) + glossary +ilvl/BiS/
  proc/uptime/vault-slot (7 talen). NB: keybind-kaartlabels bewust op community-termen gehouden met NL-tooltip.

**Restpunt (niet gedaan, klein):** TOUR_HOME_TITLE-naamconsistentie in de/fr/es/pt/it (F4.6). **Volgende:**
**Fase 3** (fundament, backlog 11–14 + 18). Openstaande in-game-tests: §5.8 (native settings-paneel), §5.9
(tour-ESC), + de Fase 1-tests (§5.2/§5.5/§5.10).

---

## ✅ FASE 1 UITGEVOERD (2026-07-06, Opus 4.8 — backlog 2–6 uit `docs/REVIEW_2026-07.md`)

Drie commits op `main` (Rob's WIP — Core/Achievements/AchievementsData/Openables/Rares +
CLAUDE.md — is NIET meegecommit):

- **`5bfbfbd` — CI-fix (backlog 2, F5.1/F5.5).** `.github/workflows/guide-tips-audit.yml`
  → hernoemd naar `lua-syntax-check.yml` (dode audit-step die op verwijderde GuideData/
  GuideTips-bestanden hardcodete is weg; alleen de Lua-syntaxcheck blijft). `tools/audit_guide_spell_tips.py`
  verwijderd. README-"Maintainer checks" bijgewerkt. **Test:** GitHub Actions wordt bij de volgende push groen.
- **`c1b4d1a` — Comms-guard (backlog 4, F2.2).** Nieuw `Modules/Comms.lua` met `ns.MH_SendAddon`
  (leest `Enum.SendAddonMessageResult`, retry bij throttle) en `ns.MH_SendChat`, beide met een
  queue tijdens `C_ChatInfo.InChatMessagingLockdown()` (staleness-cap 30s). Alle 6 senders
  (ConsumableReadyComms, DelveShareSync, RitualShareSync, DungeonLiveCoach, DelvePartyShare,
  RitualShare) lopen er nu langs. **Test:** in een M+-run een share/broadcast proberen → komt aan
  ná de run i.p.v. stil te verdwijnen. ⚠️ `InChatMessagingLockdown` + throttle-allowance web-geverifieerd
  (report), maar exact lockdown-/queue-gedrag nog niet in-game bevestigd (§5.10).
- **`79d1405` — Paladin: Divine Toll-dupe + spellID-pilot (backlog 3+5, F1.1/F1.3).** (a) Dubbele
  `["Divine Toll"]`-key samengevoegd tot `specs={65,66,70}` (Holy/Prot kregen 'm terug). (b) KeybindAutoMap
  matcht nu primair op **spellID** (`BuildIdIndex`), naam als fallback; alle Paladin-entries + globale
  Recuperate kregen een **addon-geverifieerd** `id` (JustAC-data). **Test:** `/mhautomap` op Holy+Prot
  Paladin (Divine Toll aanwezig); op een **niet-Engelse WoW-client** een Paladin (§5.5) → map vult nu wél.

**Geparkeerd (backlog 6, F1.2):** Eruundi-mapconflict (2405 vs 2444) — wacht op Rob's in-game meting §5.2.

**Fase 1 = klaar op backlog 6 na.** Volgende: **Fase 2** (onboarding-excellentie, backlog 7–10 + 16–17)
zodra Rob de Fase 1-punten getest heeft. Openstaande in-game-vragen: §5.2 (Eruundi-mapID),
§5.5 (niet-Engelse client keybind-test), §5.10 (chat-lockdown-gedrag).

---

## 🌙 MORGEN — HIER VERDER (Rob ging slapen ~00:30, 2026-07-05)

**✅ Combat Safety — Feature A + TTS IN-GAME BEVESTIGD (Rob, Delve-test 2026-07-05):**
- ✅ Feature A (visueel: rood icoon + gloed + cooldown-swipe bij een cast die JOU target) — werkt in de
  Delve. Test-knop is een **sleepbare aan/uit-preview** ("Preview / position").
- ✅ **TTS** ("Speak the cast name", **standaard uit**): spreekt de vijandelijke cast-naam via
  `C_VoiceChat.SpeakText` (secret-safe sink), gegate op **gerichte** casts in instances/gevecht + NPC-filter
  + anti-spam 3s. **Gehoord + werkend in de Delve** (vocal warning + popup zoals bedoeld). WoW moet een
  TTS-stem actief hebben.
- **Klus 4 (= afronden Feature A + TTS) is dus KLAAR.** Volgende mijlpaal: **2.4.0 Beta** (Combat Safety
  live richting Cisca) — **pas als Rob "go" zegt**. Gekozen vervolg-volgorde: **eerst 4 (done) → dan B → dan C.**
- **Grens van Feature A (Rob's vraag beantwoord):** dekt alléén casts die JOU als unit targeten. Een cast
  op een teamgenoot → icoon stil, stem kan 'm tóch zeggen (kan "op mij?" niet zien = secret). Een
  **grond-effect op een locatie** (dingen op de grond waar je uit moet) → **niks** — dat is **Feature B**.

**✅ TargetedSpells-castbalken ONDERZOCHT (agent, 2026-07-05).** Bevindingen: elke vijandelijke cast =
eigen frame uit een pool, gestackt/gesorteerd op starttijd (meerdere tegelijk); "Party" = horizontale
balken (icoon+naam+doelwit+progressbar+interrupt-kleur), "Self" = één icoon (zoals wij). Secret-safe via
`SetAlphaFromBoolean`/`EvaluateColorValueFromBoolean`/`SetVertexColorFromBoolean` + 0,2s-delay vóór
duration-uitlezing + framepool/RepositionFrames. TTS staat er los van (zelfde trigger). Opties voor MH:
**A** = ons icoon → mini-stack van N iconen (laag-midden), **B** = volledige castbalken (hoog, vooral groep),
**C** = aparte "grond-schade/MOVE!"-feature (midden, dekt de grond-effecten die A/B NIET dekken).

**Rob's keuze-volgorde: eerst 4 (Feature A + TTS — DONE) → dan B (GEBOUWD, testen) → dan C.**
- ✅ **B = castbalken GEBOUWD (2026-07-05), NOG TE TESTEN.** Stijl-schakelaar (Rob's keuze): setting
  **"Toon als balken"** (`combatSafetyBars`, default UIT = icoon-modus onveranderd). Balken-modus = frame-pool
  van verticaal gestapelde balkjes (icoon + spellnaam via SetText-sink + aflopende progressbar via
  `SetTimerDuration` duration-object), per nameplate-unit één balk, alpha-gated via `SetAlphaFromBoolean`.
  Echte balken zijn **display-only** (geen muis → onzichtbare alpha-0 balken eten geen klikken); **Preview**
  toont 3 sleepbare sample-balken om de stapel te plaatsen. Detectie + TTS gedeeld met icoon-modus. Alles
  pcall-geguard. **Testen:** zet "Toon als balken" aan → Preview (3 balken, sleepbaar) → in Delve meerdere
  casters die je targeten = meerdere balken. Bekende beperking: niet-relevante casts = alpha-0 gaten in de
  stapel; `SetTimerDuration` nog niet 100% zeker (pcall → balk vol/statisch als 't afwijkt). Interrupt-kleur
  bewust nog niet (onzekere `SetVertexColorFromBoolean`-signatuur).
- **C = "je staat in de stront / MOVE!"** (GTFO-light) voor grond-effecten (Robs Delve-groepsvoorbeeld).
- **2.4.0 Beta** kan zodra Rob "go" zegt (Feature A + TTS af; B erbij zodra getest). ⚠️ Ook meenemen:
  **ResetRoutine taint-fix** (live bug, nu op main) — of als losse 2.3.2 hotfix.

**Git-status:** Combat Safety (Feature A + preview-toggle + TTS) is gecommit+gepusht als WIP op `main`
(nog niet gereleased; CF blijft op 2.3.1). Werkmap = live-map = de git-repo (zie workflow-blok onder).

---

## 🚑 2.3.1 HOTFIX KLAARGEZET (2026-07-04) — Rob doet git/package/CF

**Waarom:** de MissingBuff-taint (`ADDON_ACTION_BLOCKED: MidnightHelperMissingBuff:Hide()`) zat in de
**live 2.3.0** → snelle hotfix. **Combat Safety is BEWUST GEPARKEERD** (Rob: targeting-feature komt
later, niet in deze release).

**In 2.3.1 (klaar in de repo):**
- MissingBuff taint-fix (SyncSecurePos — zie sessie-7-blok hieronder).
- `.toc` → `## Version: 2.3.1`, **`Modules\CombatSafety.lua` uit de .toc gehaald**.
- Combat Safety settings-blok uit `SettingsPage.lua` gehaald.
- Changelog: `CHANGELOG_231_1` (enUS), `Changelog.lua` (2.3.1 bovenaan), `CHANGELOG.md`,
  `docs/CURSEFORGE_2.3.1.md`. Release type = **Release** (klein, geen Beta).

**Geparkeerd voor later (NIET in 2.3.1):** `Modules/CombatSafety.lua` is VERPLAATST naar
`docs/parked/CombatSafety.lua` (docs wordt uitgesloten van de zip → ship't niet; work bewaard).
`CS_*`/`SET_CS_*` locale-keys blijven staan (onschuldige wezen). **Re-activeren later = 3 dingen:**
bestand terug naar `Modules/CombatSafety.lua`, `.toc`-regel terug, settings-blok terug in
`SettingsPage.lua` (categorie "alerts"), en verder testen (secret-API's in-game).

**✅ 2.3.1 GERELEASED:** zip gebouwd + door Rob geüpload naar CurseForge. Op GitHub gecommit+gepusht
(commit 6c262f4). CF, GitHub én live staan op 2.3.1.

**✅ WORKFLOW GEWIJZIGD (2026-07-04) — GEEN Cursor / GEEN sync-script meer:**
De **live-map ZELF is de git-repo** (`E:\...\AddOns\MidnightHelper` heeft `.git`, remote =
github.com/Huijting/MidnightHelper, branch `main`). Rob werkt niet meer in Cursor aan deze addon.
**Nieuwe manier van werken:** de assistent bewerkt direct in de live-map → Rob doet `/reload` en test
meteen → assistent doet `git add/commit/push` vanuit de live-map (credentials staan in Git Credential
Manager via Windows, werken non-interactief). Eén repo, geen divergentie, geen `Sync-MidnightHelper.bat`
meer nodig. `docs/parked/` + `dist/` shippen niet (docs uitgesloten in package.ps1, dist in .gitignore).
`CLAUDE.md` is untracked (lokaal; bewust niet in de public repo) → blijft als enige in `git status`.
**Rob's enige handmatige stap bij een release:** de CF-upload (assistent kan dat niet).

---

## 🆕 SESSIE 7 (2026-07-04) — Combat Safety Feature A gebouwd (GEPARKEERD in 2.3.1), NOG IN-GAME TE TESTEN

**Nieuw:** module `Modules/CombatSafety.lua` (+ in .toc na MissingBuff). "Gevaarlijke cast op JOU"-
waarschuwing, geïnspireerd op de geïnspecteerde addons **TargetedSpells** + **GTFO** (inspectie-
rapporten + `docs/COMBAT_SAFETY_PLAN.md` + mockup `docs/mockups/combatsafety_mockup.html`).

**Wat het doet:** versleepbaar/schaalbaar icoon met rode gloed-puls + cooldown-swipe + aftel-nummer
zodra een vijand een BELANGRIJKE spell cast die de speler als doelwit heeft. Tag = "OPZIJ!/MOVE!"
(niet interruptbaar) of "INTERRUPT!" (wel). Rechts spellnaam + "gericht op jou". Verdwijnt bij
cast-eind/interrupt/nameplate-weg.

**Techniek (never-lie — Blizzard doet de zware data, GEEN eigen spell-lijst):**
- `C_Spell.IsSpellImportant(spellID)` → gevaarlijk? · `PlayerIsSpellTarget(unit,"player")` → op mij?
  (fallback: `UnitSpellTargetName` == spelernaam) · `UnitCastingInfo`/`UnitChannelInfo` → naam/icoon/
  tijd/interruptbaar. Alles pcall-geguard. API's komen uit TargetedSpells-code (retail 12.0.7).
- Bron-units = nameplates; `UNIT_SPELLCAST_START/CHANNEL_START` met 0.1s-debounce (doelwit-info soms
  1 frame later), STOP/INTERRUPTED/`NAME_PLATE_UNIT_REMOVED` ruimt op. Meest imminente cast wint.
- **GEEN zone-gate in v1** (IsSpellImportant+PlayerIsSpellTarget al zeer selectief). **CVar
  `nameplateShowOffscreen` NIET geforceerd** (minder invasief; off-screen casters worden gemist — bewust).
- Niet-secure frame → geen combat-restricties (geen secure knop nodig, puur informatief).

**Settings:** categorie "Meldingen & popups" (alerts) → `SET_CS_*` toggle + **Test-knop**
(`ns.TestCombatSafety` flitst 3s nep-cue). Exports: `ns.IsCombatSafetyEnabled`/`SetCombatSafetyEnabled`/
`RefreshCombatSafety`/`TestCombatSafety`. Default AAN.

**Locale:** `CS_*` in enUS+nlNL, `SET_CS_*` in `Locales/SettingsPage.lua` (en+nl). de/fr/es/pt/it vallen
terug op EN → **later toevoegen via `Translations2026.lua`** (Rob-wens: "later ook in onze talen").

**⚠️ CRUCIALE 12.x-LES — "secret values" (eerste versie crashte 66×, herschreven):**
Cast-info van VIJANDELIJKE units (`UnitCastingInfo`/`UnitChannelInfo`: naam/icoon/tijden/spellId/
interruptbaar) is in Midnight **SECRET**. Je mag die waarden **TONEN** maar er NIET op **rekenen**
(`(s)/1000` → "attempt to perform arithmetic on a secret number value") of met **if/vergelijking**
op **vertakken** (taint). De eerste CombatSafety-versie deed beide → 66× error in een ritual.
**Correcte aanpak (1-op-1 uit TargetedSpells):**
- Aftel/tijd: NOOIT zelf rekenen → `UnitCastingDuration(unit)`/`UnitChannelDuration(unit)` geeft een
  **duration-OBJECT** → direct in `Cooldown:SetCooldownFromDurationObject(obj)`.
- Zichtbaarheid: NOOIT `if important/targetsPlayer` → voed die secret-booleans aan de engine:
  `frame:SetAlphaFromBoolean(bool, alphaTrue, alphaFalse)` + `C_CurveUtil.EvaluateColorValueFromBoolean(bool, valFalse, valTrue)`.
  (AND-en = nesten: `SetAlphaFromBoolean(targetsPlayer, EvaluateColorValueFromBoolean(important,0,1), 0)`.)
- `SetAlphaFromBoolean`/`secretwrap`/`C_CurveUtil` = **Blizzard 12.x-API's** (niet door TargetedSpells
  gedefinieerd — geverifieerd via grep). `C_Spell.IsSpellImportant`/`PlayerIsSpellTarget` geven secret
  booleans terug.
- **Deze les geldt breder:** elke toekomstige feature die vijandelijke cast/aura-details leest moet
  dit patroon volgen (zie ook CLAUDE.md §"12.x secret values" + `issecretvalue()`).

**Herschreven CombatSafety.lua** volgt dit patroon; **alles in een pcall-vangnet** → wijkt een API af
dan toont de feature NIKS (geen spam) i.p.v. te crashen. **v1-beperkingen (bewust, secret-safe):** geen
spell-naam-tekst, geen MOVE!/INTERRUPT!-onderscheid (vergt vertakken op secret), één icoon tegelijk
(laatste relevante cast). Statische tekst "DANGEROUS CAST / Targeting you". Icoon = spell-icoon (secret,
met statische fallback). `luac -p` OK.

**NOG TE DOEN — Rob test in-game:**
1. `/reload`, Settings → Meldingen → **Test-knop** → cue verschijnt (gloed, cooldown-swipe, sleepbaar,
   Shift+scroll schaalt). Test gebruikt GEEN secret waarden → moet altijd werken.
2. Echte test in **Delve/dungeon**: caster richt gevaarlijke spell op je → **rood icoon verschijnt**
   (met swipe). **GEEN error meer** (66× spam moet weg zijn — pcall vangt alles).
3. **Als de Test werkt maar er in-game nóóit een echte cue komt:** dan geeft een van de secret-API's
   iets anders terug dan verwacht (of `SetAlphaFromBoolean` heet anders in 12.0.7). Meld het — dan
   dump ik de API-namen in-game. Geen haast: het faalt stil, niet luid.
4. Bij twijfel `/console scriptErrors 1`.

**🐛 Bugfix in dezelfde sessie — MissingBuff taint (uit 2.3.0):** in een ritual (combat) gaf het
8× `ADDON_ACTION_BLOCKED: MidnightHelperMissingBuff:Hide()` (`MissingBuff.lua:621`). Oorzaak: de
secure klik-knop was met `b:SetAllPoints(f)` AAN het reminder-frame verankerd → f werd "protected"
→ `f:Hide()` in combat geblokkeerd. Fix: nieuwe `SyncSecurePos(b)` positioneert de secure knop nu
ONAFHANKELIJK op UIParent en synct 'm alleen buiten combat met f (op create/show/drag/scale, +
`ns._mhSyncMissingSecure`). De `SetAllPoints(f)`-anchor is weg → f is niet meer protected. `luac -p`
OK. **Rob test: geen ADDON_ACTION_BLOCKED meer in combat/ritual; klik-om-te-casten werkt nog
(Hunter pet / Mage AI buiten combat).** Zit nog NIET in een release (2.3.0 heeft de bug nog).

**Daarna:** Feature B (GTFO-light "je staat in schade") als A bevalt; dan pas versie-bump/CF.

---

## ✅ 2.3.0 IS LIVE op CurseForge (bevestigd door Rob, 2026-07-04)

Sessie 6 is **gecommit én gereleased** — 2.3.0 staat live op CF (`.toc ## Version: 2.3.0`).
Alles hieronder in de sessie-6-blok zit dus in de release; het commit-commando is uitgevoerd.

**✅ Code-audit 2026-07-04: Missing Buff v2 én spell-strook fase 2/3 zijn AL GEBOUWD en zitten in 2.3.0.**
De oude "openstaand"-lijst was stale. Concreet aanwezig:
- **Missing Buff v2** — ally-target-buffs met `/cast [@mouseover][@target][@focus]` (Symbiotic Relationship
  474750, Source of Magic 369459 needHealer, Earth Shield 974, Beacon of Light 53563 + Faith 156910),
  Paladin-auras (Devotion 465), Warrior-stances, Rogue-poisons, pets, én settings-toggle (`SET_MBUFF_*`
  en/nl, `ns.IsMissingBuffEnabled`/`SetMissingBuffEnabled`). Files: `MissingBuffData.lua` + `MissingBuff.lua`.
- **Spell-strook fase 2** — hover op spell-rij → gloed op fysieke toets (goud) + verbindingslijn; 2e cyaan
  lijn+gloed naar de modifier-toets. `KeyboardLayoutPrototype.lua:475-567`.
- **Spell-strook fase 3** — filter-chips Alles/Modifier-laag/Ankers/Extras (`PassesCardFilter`,
  `LAYOUT_FILTER_*`). `KeyboardLayoutPrototype.lua:645`.

**Nog echt open (klein):**
- ~~Ebon Might (Aug Evoker)~~ — **DEFINITIEF NEE (Rob, 2026-07-04).** Bewust NIET in de data: het is een
  ~15s rollende rotatie-buff, geen permanente onderhoudsbuff (zelfde uitsluiting als Bloodlust/Voidform).
  Niet meer opnieuw opperen.
- **Breder in-game testen** Missing Buff v2 (Paladin/Evoker/Shaman/Rogue/Warrior) — Rob/Cisca-taak.
- **Utility-prioriteit-tuning** (R/T/X-verdeling per spec) — cosmetisch.
- **Omnium Folio** verfijningen — optioneel; data zelf 100% correct.

**Volgende release wordt 2.4.0** (of hoger) — Beta eerst bij Cisca bij grote wijzigingen.

---

## 🌙 SESSIE 6 (2026-07-03) — ✅ GECOMMIT & GERELEASED in 2.3.0

**Gedaan deze sessie (alles door Rob in-game getest, zit in de 2.3.0-release):**
1. **Layout "Consumables & extras"-balk:** volle breedte onderaan, korte categorielabels (afkap-fix — volle itemnaam in tooltip), ✓/✗-status uit `ConsumableReadyCheck`. Niet-klikbaar (secure botst met de verschuivende masonry-layout; klikbaar-gebruiken zit al op het Consumable Board). 4e filter-chip "Alleen extras". Files: `KeyboardLayoutPrototype.lua`, nieuw `Modules/LayoutExtras.lua`.
2. **Beta eraf:** `UI.lua` `MH_BETA_TAB_IDS = {}` (badges weg van Codex/Guide); "(concept)" uit `LAYOUT_AUTOMAP_NOTE`; NL-fix "Enkel-doel heals"; "Drums (Bloodlust)".
3. **Ritual consumable-check** detecteert nu ELK ritual/outdoor-scenario (niet meer alleen hardcoded 3236) → alle sites (Daggerspine 3267 etc.) werken. `ConsumableReadyCheck.lua` CurrentContentKey.
4. **Treasure-toast (Achievements)** blijft staan bij dezelfde treasure ook als je ver weg bent — `ArmTreasureToast` verbergt geen toast meer die al voor DIE node open staat.
5. **TomTom-clear route-fix (alle routetypes):** alle 13 interne clears lopen via nieuwe `ns.MH_TomTomClearAll()` (zet guard-flag `ns._mhSelfWaypointOp`); hook op `TomTom.ClearAllWaypoints` stopt de route (`ClearActiveRoute`) alléén bij een ECHTE spelersclear. `Core.lua` + Rares/Profession/ProfessionAcademy/ResetRoutine/DungeonRosterData/Achievements/Showdowns/RitualSites/VoidAssaults.
6. **⭐ NIEUW: Missing Buff-feature** (bedoeld om losse *MissingClassBuff*-addon te vervangen). Eigen, Wowhead-12.0.7-geverifieerde data — GEEN kopie. Files: `Modules/MissingBuffData.lua` + `Modules/MissingBuff.lua` (+ MBUFF_*-locale-keys en/nl, .toc). Doorlopend versleepbaar/schaalbaar icoon bij een missende onderhoudsbuff (raid-buff/vorm/shield/imbue/poison/stance/pet), zichtbaar óók in combat. **Klikbaar casten buiten combat** via de MCB-truc: apart NIET-secure reminder-frame + secure knop met `RegisterStateDriver(b,"visibility","[combat] hide; nil")`, strata DIALOG (boven het frame), `RegisterForClicks("AnyUp","AnyDown")`, cast op **spell-ID** (pet-naam-onafhankelijk). ✅ getest Hunter (pet) + Mage (Arcane Intellect).

**Data-verificatie (never-lie, Wowhead 12.0.7):** alle buff-IDs + alle Omnium Folio-runes bevestigd. Uitgesloten als "geen onderhoudsbuff": Voidform 194249 (cooldown), Water Elemental 31687 (weg voor Frost), Horn of Winter 57330 (rune-gen), Vengeance/Crusader Aura (passief/reis). Monk/DH/DK(non-Unholy) hebben géén trackbare buff. Naam-fix: 457481 = "Tidecaller's Guard".

**COMMIT-COMMANDO (Rob draait zelf):**
```
git add Core.lua UI.lua MidnightHelper.toc Modules/LayoutExtras.lua Modules/KeyboardLayoutPrototype.lua Modules/ConsumableReadyCheck.lua Modules/MissingBuffData.lua Modules/MissingBuff.lua Modules/Achievements.lua Modules/Rares.lua Modules/Profession.lua Modules/ProfessionAcademy.lua Modules/ResetRoutine.lua Modules/DungeonRosterData.lua Modules/Showdowns.lua Modules/RitualSites.lua Modules/VoidAssaults.lua Locales/enUS.lua Locales/nlNL.lua
git commit -m "Extras-balk, Beta eraf, ritual/treasure/TomTom-fixes, Missing Buff-reminder (klikbaar)"
git push
```

**MORGEN / openstaand:**
- **Missing Buff v2:** ally-target-buffs (Beacon of Light 53563/Faith 156910, Symbiotic Relationship 474750, Source of Magic 369459, + **Ebon Might 395152 apart verifiëren**) + Paladin-auras (Devotion 465 default). Vergt target-cast-logica (`type="macro"` `/cast [@target,help]`). Plus: **settings aan/uit-toggle** (nu alleen `ns.db.ui.missingBuff`). Test breder: Shaman (shields/imbues), Rogue (poisons), Warrior (stances).
- **Omnium Folio (optioneel, uit onderzoek sessie 6):** baseline klopt grotendeels; mogelijke verfijningen: core Orbs/Fire per archetype (healer/pet-class → Orbs), raid-capstone splitsen Echoes(single-target)/Residual(DoT-specs Affli/Shadow/Balance), stat-rij per spec (of live uit gear/sim i.p.v. statische tabel). Data zelf 100% correct — geen fix nodig.
- **Nog niet gereleased:** versie → 2.3.0 + changelog + CF (Beta eerst) — PAS als Rob "af" zegt.

---


## ⏭️ MORGEN / VOLGENDE SESSIE — direct oppakken (sessie 4/5)

**✅ Classifier SERIEUS herbouwd uit addon-data (sessie 5):** de draft-gebaseerde classifier was
incompleet (miste self-heals, soms interrupts, "lijkt-me-logisch"-keuzes). Nu **13 nieuwe per-class
bestanden** `Modules/KeybindRoles_<Class>.lua`, elk gebouwd door een agent uit **JustAC**
(InterruptAbilities/SpellCategories/DefensiveEngine/SpellArchetypes/HealingItems), **ClassCodex**
(rotaties), BliZzi/CDPulse — volledige dekking per spec (interrupt/movement/defensives/dispel/
self-heals/cooldowns/rotatie/AoE/utility). Ele/Enh Shaman + Frost Mage uit de in-game-bevestigde
hand-maps overgenomen. `.toc` laadt nu deze 13; de **oude 4 grouped-bestanden**
(`KeybindRoles_WarDkDhEvoker/RogueMonkDruid/PriestWarlockMage/HunterPaladinShaman.lua`) staan nog op
schijf maar zijn **uit de .toc** → mogen verwijderd worden (opruimen). Alle 13 syntax-gecheckt
(Warlock had 1 null-byte → gestript). **Nog te doen: VALIDATIE op chars (zie 3).**


De **auto-map + spell-strook (Plan B)** is het actieve project. Fundament + dataset + Fase 1 staan.
Openstaand:
1. **Spell-strook Fase 2 (rest):** hover op een spell-rij → gloed op de fysieke toets + **verbindingslijn**
   (`host:CreateLine()`) van de rij naar de toets. (WoW-tooltip op de rijen is al gedaan.)
2. **Spell-strook Fase 3:** filter-chips boven de kaarten — **Alles / Alleen Shift-laag / Alleen ankers**
   (mockup `docs/mockups/spellstrip_B_spellbook.html`). Toont/verbergt rijen + lege kaarten.
3. **Validatie op Robs chars:** log op meerdere specs, check auto-maps + heal-ankers (F2/F3/**F4=Recuperate**),
   meld scheve plaatsingen → dataset (`Modules/KeybindRoles_*.lua`) fijntunen. Bekende restpunten:
   naam-collisions met één rol; utility-prioriteit per spec (R/T/X-verdeling).
4. **Pas als Rob "af" zegt:** versie → **2.3.0**, changelog + CF-doc, **Beta eerst** (Cisca-test). NU NOG NIET.

Alle details van sessie 4 staan onder de ⭐-secties (2b/2c) verderop.

**✅ Healer-ondersteuning (click-cast) toegevoegd (sessie 5):** nieuw `role = "click_cast"` in de
classifier → single-target-heals krijgen GEEN toets maar verschijnen in een aparte kaart
**"Single-target heals (mouseover)"** (v6 §6: healer ST-heals via mouseover/click-cast). Raid/AoE-heals
blijven op toetsen (main_rotation/spender), heal-CD's op cooldown/F1, damage/utility/interrupt/defensive
identiek aan DPS. Code: `MH_AutoMapBuild` verzamelt click_cast apart → `spec.clickCast`; `ProtoRefreshCards`
tekent de extra kaart (`LAYOUT_CARD_STHEAL`/`LAYOUT_STHEAL_TAG` en/nl). 6 healer-specs geauditeerd
(Disc/Holy Priest, Holy Paladin, Resto Druid/Shaman, MW Monk, Pres Evoker) — ontbrekende ST-heals
toegevoegd. Ook: functionele kwaliteits-review over alle 13 classes (mitigation≠spender etc.),
AoE-Shift+N-bug gefixt (juiste Shift-nummers), shard-cap-popup dedup op dag-resolutie.

---

**Laatste update:** 2026-07-04 (2.3.0 live op CF)
**Live op CF:** **2.3.0** (Extras-balk, Beta eraf, ritual/treasure/TomTom-fixes, Missing Buff-reminder).
**Vorige live versies:** 2.2.0, 2.1.1, 2.1.0

---

## ▶️ START HIER (sessie 3 samenvatting + wat nu ligt)

### Gedaan sessie 3 (2026-07-02)
1. **Leveling-tab compleet vervangen.** De oude per-class/spec-gids (~6.900 regels + het 5.152-key
   `GuideAdvisor`-monster + dubbele consumables) is **weg**; er staat nu een **class-agnostische
   Midnight 80→90 tips-tab** ("Leveling (80-90)"). Verwijderd: `Addons/GuideData.lua`,
   `Locales/GuideTips/GuideGroups/GuideAdvisor.lua`, `Modules/GuideTipSpellNames/GuideTipText.lua`
   (+ uit `.toc`). Nieuw: compacte `Addons/Guide.lua` met `ns.GuideData80to90` (6 secties: pad/XP/
   unlocks/consumables/gear/handoff) + `LVL8090_*` keys in en/nl. Content = web-geverifieerd +
   MH-eigen data. Bron-draft: `docs/LEVELING_80_90_TIPS.md`, plan: `docs/LEVELING_TAB_PLAN.md`.
   ✅ In-game bevestigd door Rob (werkt, layout-subtab intact).
2. **Keybind-standaard v6** vastgelegd: `docs/KEYBIND_STANDARD_v6.md` (universele role→key; ankers
   E=interrupt/Q=movement/Z=kleine def/C=grote def/V=dispel-CC/F1=burst; overflow **Shift→Ctrl→Alt**
   (Alt=self-cast, laatst); AoE=Shift-tweeling van de ST-knop; geen G; deterministisch invul-algoritme).
3. **Frost Mage-layout LIVE** (Rob's char). Data toegevoegd in `Modules/KeybindingData.lua`
   (Mage-columns + `slotsMage` + `specsById.frost_mage`, alle spell-ID's in-game bevestigd),
   MAGE-branch in `Modules/KeybindLayoutSlug.lua` (spec 3=Frost), en de **stale `db.guide.preview`
   short-circuit** in `MH_GetHunterKeybindSlugForUi` verwijderd (die blokkeerde de spec-detectie).
   ✅ In-game bevestigd: binds lichten op met tooltips.

### ⏭️ EERSTE KLUSSEN SESSIE 4
1. ✅ **Enh Shaman keybind-data toegevoegd** (sessie 4, code klaar — nog in-game testen op Cisca's
   shaman). Frost-patroon gevolgd: Shaman-columns + `slotsShaman` + `specsById.enh_shaman` +
   SHAMAN-branch + `KEYBIND_SHAMAN_CAT_*` in enUS. Twee beslissingen:
   - **Spec-index = 2**, niet 1 zoals hier eerder stond (GetSpecialization-volgorde: 1=Elemental,
     2=Enhancement, 3=Restoration — geverifieerd via warcraft.wiki.gg).
   - **R = Elemental Blast 117014** (Robs keuze): de map-bind is "5", maar het prototype heeft geen
     5-toets. T/F2/F3/Alt+F1/Shift-laag wachten op het layout-systeem (klus 2).
   Bron: `docs/KEYBIND_MAP_frost-mage_enh-shaman.md` (ID's bevestigd: Voltaic Blaze vervangt
   Flame Shock; Tempest = passieve proc op Lightning Bolt; Ascendance 114050; Cisca = Stormbringer).
2. ✅ **Layout-systeem gebouwd** (sessie 4, code klaar — nog in-game testen). Bleek: het
   toetsenbord rendert al álle fysieke toetsen (ook 5/T/F2/F3) en de tooltip toonde al
   modifier-lagen via `Keybind_GetBindingsOnBase` — het gat zat in schema/data/slots. Gedaan:
   - **`KeybindSchema.lua` → v6**: overflow **Shift→Ctrl→Alt** (was Alt eerst), sort-volgorde
     idem, `baseSlotFillOrder` + categorieën met 5/T, nieuwe cats `dispel_cc`/`cooldown`,
     `columnToCategory` voor Mage/Shaman.
   - **Data map-exact**: Frost nu vol v6 (5=Glacial Spike, T=Cold Snap **terug van X**,
     Shift+1..4 AoE, Shift+Z/V) en Enh vol v6 (5=Elemental Blast **terug van R**, R weer vrij,
     T/X/F2/F3, Shift-laag, Alt+F1=Ascendance, Shift+F2=Bloodlust/Heroism per factie via
     `UnitFactionGroup` bij load).
   - **Slots**: Mage/Shaman-slots uitgebreid (5/T, Shaman ook F2/F3+X→Utility); V = nieuwe
     **CC/Dispel**-kolom (`KEYBIND_*_CAT_CC` in en). Mage X-slot weg (geen bind meer).
   - **Render**: cyaan **"+N"-badge** op toetsen met N extra modifier-binds
     (`KeyboardLayoutPrototype.lua`); subtitle + legenda uitgelegd in en/nl.
   - **Test (Rob):** /reload op Frost én Enh → 5/T (Enh ook X/F2/F3) lichten op; hover 1/4/Z/V/
     Q/T/F1/F2 toont de lagen; +N-badges zichtbaar; Hunter/Paladin ongewijzigd.
3. **Bugfix na Robs shaman-screenshot** (alles grijs + "Hunter bind map"-tooltip): twee oorzaken
   gefixt. (a) `ProtoResolveSlug` had nóg een stale `db.guide.preview`-branch (zelfde bug als
   eerder in `MH_GetHunterKeybindSlugForUi`) — weg. (b) Spec-detectie Mage/Shaman nu op **stabiel
   specID** via `GetSpecializationInfo(s)` (64=Frost, 263=Enh) i.p.v. spec-index. Plus: klassen
   zónder map vallen niet meer stiekem terug op de Hunter-map maar tonen een eerlijke oranje
   hint (`LAYOUT_NO_MAP_HINT`, en/nl); `LAYOUT_KEY_UNUSED_TOOLTIP` is niet meer Hunter-specifiek.
   **Let op test:** de map licht alleen op als de shaman óók echt Enhancement-spec is.
4. **Alle overige specs voorbereid (agents, web-research — NIET in-game bevestigd):** 35 specs
   v6-concept-maps in `docs/KEYBIND_MAP_DRAFT_warrior_dk_dh_evoker.md`, `_rogue_monk_druid.md`,
   `_priest_warlock_mage.md`, `_hunter_paladin_shaman.md`. Alle ID's 🟡/⚠️ (never-lie: eerst
   Rob/Cisca-check per spec vóór encoderen). Opvallend uit de rapporten: Disc/Holy Priest én
   MW Monk/Resto Druid hebben geen baseline-interrupt (E blijft utility); Warlock-kick loopt via
   pet; Warrior's 3e major-CD botst met het Ctrl+F1-trinket-anker (herzien bij encoderen);
   Paladin heeft geen bevestigde Q-movement; SV Hunter-kit is compleet herzien in Midnight.
5. ✅ **Heal-ankers v6-update (Rob, 2026-07-02):** F2 = snelle self-heal ín combat, F3 = heal
   out-of-combat, F4 = "Recuperate"-achtig (HoT, bv. Crimson Vial). Doorgevoerd in:
   `KEYBIND_STANDARD_v6.md` (§1/§3/§4/§5), `KeybindSchema.lua` (utility = F/R/T/X; roles
   heal_quick/heal_ooc/heal_sustain; categorie `selfheal` F2–F4), Enh-data (Healing Surge
   Z→F2 — **Z is nu leeg** bij Enh, Astral Shift op C is de def; Stormkeeper F2→R; Primordial
   Wave F3→Shift+R; Bloodlust blijft Shift+F2), `KEYBIND_SHAMAN_CAT_HEAL`/`KEYBIND_ROLE_HEAL`
   in en (+ROLE in nl). De 4 draft-docs hebben bovenaan een ⚠️-notitie dat hun F2–F4 herzien
   moet worden. Frost heeft geen heals → ongewijzigd.
6. ✅ **3 mockups voor de spell-strook** (brainstorm-input, nog NIET besproken/gekozen) in
   `docs/mockups/`: `spellstrip_A_actionbar.html` (WoW-actionbar + laag-toggle Basis/Shift/Alt),
   `spellstrip_B_spellbook.html` (categorie-kaarten + SVG-lijn naar toets + filter-chips),
   `spellstrip_C_hud.html` (radiaal wiel, ringen per modifier-laag, lightning-arcs). Alle drie
   met de echte Enh-map; onbevestigde icoonnamen = fallback-tegels. Openen in browser.

### ⏭️ OPENSTAAND (volgende sessie / Opus)
1. **In-game test door Rob** — Frost ✅ (zag er goed uit). Shaman-test: char stond in
   **Elemental** (`GetSpecializationInfo(GetSpecialization())` = 262), dus de map bleef terecht
   leeg (geen bug — map vult alleen bij Enh/263). **Nog te doen:** log in op een char in
   **Enhancement**-spec + /reload → check 5/X (Cold Snap), F2=Healing Surge, R=Stormkeeper,
   Z grijs. Blijft grijs op écht-Enh: /console scriptErrors 1 en fout melden.

   **⚠️ Layout-wijziging deze sessie (T↔X-swap, Rob):** utility-volgorde is nu **F R X T**
   (X vóór T — makkelijker reach vanaf WASD). Doorgevoerd in `KeybindSchema.lua`
   (`baseSlotFillOrder` + `categories.utility.slots`), `KEYBIND_STANDARD_v6.md` (§1/§4), en
   **Frost-data**: Cold Snap staat nu op **X** (was T); Mage-utility-kolom toont X i.p.v. T.
   Enh ongemoeid (gebruikt T én X allebei — Capacitor op T + Shift+T Wind Rush, Tremor op X).
   Rob's /reload op Frost = finale syntaxcheck.

   **✅ Elemental Shaman-map toegevoegd (sessie 4)** — Rob speelt Elemental, dus nu een eigen
   testbare map. Aangesloten: spec-detectie **262→ele_shaman** (`KeybindLayoutSlug.lua`),
   `ele_shaman` in `specsById` (hergebruikt `slotsShaman`-kolommen via
   `Keybinding_GetSlotsForSlug`), hint-tekst en/nl. Kit v6, **bewust identiek aan Enh** waar de
   spell gedeeld is (E=Wind Shear, Q=Spirit Walk, C=Astral Shift, V=Hex, Shift+V=Purge, T=Capacitor,
   X=Tremor, R=Stormkeeper, F2=Healing Surge, Shift+F2=Bloodlust). Eigen: 1=Lava Burst, 2=Voltaic
   Blaze, 3=Earth Shock, 4=Lightning Bolt, 5=Flame Shock, Shift+1=Chain Lightning, Shift+3=Earthquake,
   F=Lightning Lasso, F1=Fire Elemental. Z leeg (geen kleine def). IDs grotendeels addon-bevestigd
   (doc 4).

   **↳ Herbouwd op Robs ECHTE spellbook (in-game afgelezen 2026-07-02, Stormbringer).** De
   Midnight-Ele-kit bleek géén Earth Shock / Fire Elemental / Hex / Frost Shock / Tremor Totem /
   Spirit Walk / Lightning Lasso te hebben — die stonden ten onrechte in de eerste (Enh-parity)
   versie. Nu: 1=Lava Burst, 2=Voltaic Blaze, 3=Lightning Bolt, 4=Elemental Blast, Shift+1=Chain
   Lightning, Shift+4=Earthquake, Q=Gust of Wind, Shift+Q=Ghost Wolf, E=Wind Shear, F=Spiritwalker's
   Grace, R=Skyfury, Shift+R=Nature's Swiftness, T=Capacitor, X=Thunderstorm, C=Astral Shift,
   Shift+C=Earth Elemental, V=Purge, Shift+V=Cleanse Spirit, F1=Stormkeeper, Alt+F1=Ascendance,
   F2=Healing Surge, Shift+F2=Bloodlust. **6 pure-utility-ID's nog niet addon-bevestigd** (Gust of
   Wind 192063, Spiritwalker's Grace 79206, Skyfury 462854, Nature's Swiftness 378081, Earth
   Elemental 198103, Cleanse Spirit 51886) — in code gemarkeerd "tooltip checken"; **Robs /reload =
   bevestiging** (meld verkeerde tooltips, dan fix ik het ID).
2. ✅ **ID-verificatie via geïnstalleerde addons GEDAAN (sessie 4, 2026-07-02).** AddOns-map
   gemount; 4 parallelle agents hebben alle 🟡/⚠️-ID's in de 4 draft-docs gekruist met
   ClassCodex, JustAC, CooldownCompanion, CDPulse, Interrupt_CCAndCD_Tracker, BliZzi_Interrupts,
   TargetedSpells, MissingClassBuff. Rijkste bronnen: JustAC (`SpellArchetypes/SpellCategories/
   InterruptAbilities`), CDPulse `SpellEngine`, BliZzi `Core/Data`, ClassCodex per-class guides.
   Resultaat: **~310 ID's 🟡→🟢** (addon-bevestigd). ✅ nergens gebruikt (blijft in-game).
   - **⚠️ Vermoedelijk-foute ID's — nog in-game dumpen vóór encoderen** (addon heeft ander ID):
     Warrior Wrecking Throw 384110→**394354** (3×), Odyn's Fury 205545→**205546**, Shield Charge
     385952→**385954**, Champion's Spear 376079→**376080**, Shattering Throw 64382→**372399/394352**;
     DK Frost Remorseless Winter 196770→**196771**, DK Unholy Dark Transformation 63560→**344955**
     (mogelijk cast-vs-component); Evoker Upheaval 396286→**396288**; Druid Mighty Bash 166972→
     **5211** (Bal+Guard), Guardian-Berserk 106951→**50334**; Monk Renewing Mist 115151→**119611**;
     Warlock Doom 460551→**460555**; Hunter Black Arrow 194599→Midnight-variant **466932**, Volley
     260247 vs **260243**; Resto Shaman Ascendance 114049 vs **114050**. Patroon: veel web-draft-ID's
     liggen 1-2 naast het addon-ID → web-research pakte de verkeerde spell-variant.
   - ✅ **Mislabel in `priest_warlock_mage.md` OPGELOST:** dat doc had ~186× ✅ ("in-game
     bevestigd") terwijl die 8 specs nooit in-game zijn gecheckt (mislabel tegen never-lie).
     Alle ✅ zijn als 🟡 herbehandeld en alsnog tegen de addons gekruist → waar bevestigd 🟢,
     anders 🟡. Legenda gelijkgetrokken met de andere docs. Nu **0 ✅** als statuslabel in het
     bestand (alleen nog in de legenda-uitleg). Extra mismatch-flags hieruit: Warlock Summon
     Vilefiend 1251778→**264119**, Malefic Grasp 1261149→**1261153** (naast de al bekende Doom
     460551→460555).
   - Nog **~40 🟡 zonder enige addon-data** (niet weerlegd, alleen ongedekt — pure builders/
     spenders die de interrupt/CD-addons niet tracken). Blijven 🟡 tot in-game.
   - F2–F4-heal-herziening was hier buiten scope (blijft de ⚠️-notitie bovenaan de 4 docs).
2b. **⭐ SCHAALBARE KEYBIND-AANPAK (screenshot-vrij) — richting gekozen + prototype gebouwd
   (sessie 4).** Probleem: ID's per spec handmatig verifiëren (via Rob/Cisca-screenshots) schaalt
   niet naar 40 specs. Oplossing: de addon leest **in-game de live spellbook** (`C_SpellBook`
   geeft de ECHTE spell-ID + naam per bekende spell) → classificeert elke spell naar een
   v6-rol/categorie via een **naam→rol-tabel** (koppelen op NAAM, niet ID → variant-fouten weg) →
   de bestaande `ns.Keybind_AllocateSpells` bepaalt de toetsen. Zo bouwt de map zich per speler,
   met correcte ID's, zonder screenshots, en self-correcting (spell niet bekend = niet geplaatst).
   - **Prototype gebouwd:** `Modules/KeybindAutoMap.lua` (+ in .toc), commando **`/mhautomap`** —
     leest de live spellbook, classificeert (nu alleen SHAMAN als proof-of-concept), roept de
     allocator, print het resultaat. Alleen-lezen (raakt binds/SavedVars niet).
   - **✅ Prototype getest (Rob, /mhautomap op Elemental):** pijplijn werkt — kern staat goed met
     de ECHTE spellbook-ID's (1=Lava Burst, 4=Elemental Blast, E=Wind Shear, Q=Gust of Wind,
     Shift+Q=Ghost Wolf, C=Astral Shift, V=Purge, F1=Stormkeeper, F2=Healing Surge, F=Spiritwalker's
     Grace). **Ving meteen een ID-drift:** live Earthquake = **462620**, terwijl hand-map + addons
     nog **61882** (oud) hadden → hand-map gefixt naar 462620. Sterk argument voor de live-read.
   - **✅ Allocator-fix gebouwd + bevestigd (Rob, /mhautomap):** (a) `trySlots` is nu **modifier-major**
     — vult eerst álle base-toetsen (1,2,3) van een categorie, dán de Shift/Ctrl/Alt-lagen. (b) Nieuwe
     **`tryPreferredKey`** in `Keybind_AllocateSpells` + `bindKey`-veld op een spell → AoE landt
     expliciet als Shift-tweeling (Chain Lightning=Shift+1, Earthquake=Shift+4). Resultaat: auto-map
     landt nu net zo schoon als de handmatige Ele-map (1/2/3 rotatie, AoE op Shift-twins, alle ankers
     correct, live-ID's). Restje voor de dataset-fase: **utility-prioriteit-tuning per spec** (verdeling
     Capacitor/Skyfury/Thunderstorm over R/T/X) — cosmetisch, geen structuur.
   - **✅ Dataset gebouwd (sessie 4, 4 parallelle agents):** de volledige **naam→rol-classifier
     voor alle 12 classes / 40 specs**, geconverteerd uit de 4 draft-docs (+ KeybindingData
     hand-maps voor de bevestigde specs). 4 databestanden in `Modules/` + in .toc, geregistreerd in
     `ns.KeybindRoleClassifier`: `KeybindRoles_WarDkDhEvoker.lua` (WARRIOR 45/DK 37/DH 31/EVOKER 44),
     `_RogueMonkDruid.lua` (ROGUE 30/MONK 25/DRUID 42), `_PriestWarlockMage.lua` (PRIEST 44/WARLOCK
     45/MAGE 31), `_HunterPaladinShaman.lua` (HUNTER 35/PALADIN 30/SHAMAN 49). ~490 entries. Alle
     bestanden syntax-gecheckt (luaparser OK, 0 non-ASCII). `KeybindAutoMap.lua` leest nu de registry
     (RolesForClass: registry eerst, inline Shaman-seed als fallback).
   - **Nog te doen / testen:**
     (a) **Rob test `/mhautomap` op meerdere chars/specs** (elke class die hij/Cisca heeft) → check
     of de kern klopt. Namen die niet matchen met de live spellbook verschijnen simpelweg niet
     (geen fout) — dat is de coverage-check.
     (b) ✅ **Spec-filter toegevoegd (sessie 4):** de class-wide tabellen mengden specs (bv. Feral-
     spells op Guardian). Opgelost: `specs = { <specID> }` op elke spec-specifieke entry (~490 entries,
     4 agents), + spec-filter in `MH_AutoMapBuild` (leest live specID via GetSpecializationInfo;
     baseline-entries zonder `specs` gelden altijd). Alle 4 KeybindRoles-bestanden host-geverifieerd
     (compleet, correcte structuur; bash-mount kapt ze af → luaparser onbetrouwbaar hier). Restant-
     twijfels (single-role bij naam-collisions, bv. Druid Rebirth Feral/Guardian; Hunter Kill Shot
     alleen {254}) staan in de agent-rapporten — cosmetisch, review o.b.v. wat Rob in-game ziet.
     (c) **Utility-prioriteit-tuning** per spec (R/T/X-verdeling) blijft cosmetisch open.
     (d) ✅ **Layout-tab tekent nu de auto-map als fallback** (sessie 4). In
     `KeyboardLayoutPrototype_Refresh`: als er géén hand-map-slug is → `ns.MH_AutoMapSpecAndSlots()`
     bouwt een synthetische spec+slots uit de live spellbook en de board vult zich (blauwe subtitle-
     note `LAYOUT_AUTOMAP_NOTE` en/nl). Hand-maps blijven override (Frost/Enh/Ele/Hunter/Paladin
     tonen hun hand-map). **Live/build-bewust:** de auto-map leest de live spellbook, dus alleen
     wat je huidige loadout daadwerkelijk kan casten wordt geplaatst (M+- vs raid-build kan
     verschillen). Cache in KeybindAutoMap leeg + Layout-tab hertekent bij **SPELLS_CHANGED**
     (leveling), **TRAIT_CONFIG_UPDATED** (losse talent / loadout-swap), **ACTIVE_TALENT_GROUP_CHANGED**,
     **PLAYER_SPECIALIZATION_CHANGED**, **PLAYER_LEVEL_UP** (SPELLS/TRAIT alleen hertekenen als de tab
     open is). Dus levelen, talent-picks, loadout-swaps en spec-wissels updaten automatisch.
     **Test:** log op een char ZONDER hand-map (bv. Warrior, Rogue, niet-Frost Mage) → Layout-tab
     moet automatisch de map tonen met live tooltips. Elke class/spec is nu gedekt.

2c. **⭐ SPELL-STROOK (Plan B) — IN AANBOUW (sessie 4).** Gekozen concept
   `docs/mockups/spellstrip_B_spellbook.html`: categorie-kaarten onder het toetsenbord (icoon |
   naam | keycap), hover → toets-gloed + verbindingslijn + tooltip, filter-chips. Gebouwd in
   `Modules/KeyboardLayoutPrototype.lua` (geen apart bestand — deelt de host/scroll met het
   toetsenbord zodat de lijn ertussen kan lopen).
   - **✅ Fase 1 (kaarten):** `ProtoRefreshCards` bouwt categorie-kaarten (Builder/Spender/AoE/
     Interrupt/Movement/Utility/Defensive/CC/Cooldowns/Self-heal) uit de huidige map (hand-map
     én auto-map; categorie afgeleid uit entry.role/category of het slot). Masonry 3 koloms onder
     de legenda; host groeit mee. Locale `LAYOUT_CARD_*` en/nl. Iconen via C_Spell.GetSpellTexture.
     **Rob: visuele check + screenshot → layout finetunen.**
   - **✅ WoW-tooltip op kaart-rijen (Rob-verzoek):** hover een rij → echte in-game spell-tooltip
     (`GameTooltip:SetSpellByID`).
   - **✅ Heal-ankers geauditeerd (4 agents, scheme bevestigd door Rob):** F2 = snelle self-heal,
     F3 = 2e/OOC-heal, F4 = recuperate/HoT. Per class de dedicated self-heals op de juiste F-toets
     (o.a. Warrior/DK Victory Rush/Death Pact→F2; Rogue Crimson Vial→F4; Evoker Renewing Blaze→F4;
     Hunter Exhilaration→F2; Paladin Word of Glory→F2; Priest Desperate Prayer→F2 + PW:Life→F3 Holy;
     Shaman Healing Surge→F2). Conservatief/never-lie: geen rotatie-/defensive-ankers verplaatst,
     healers' raid-kit blijft mouseover/click-cast. **Bonus:** pre-existing mislabels opgeruimd
     (niet-heals die op heal-slots stonden: Wrecking Throw, Storm Bolt, Symbol of Hope, Soulstone,
     Mirror Image → terug naar utility/cooldown).
   - **⏳ Fase 2 (rest):** hover op een spell-rij → gloed op de fysieke toets + verbindingslijn (CreateLine).
   - **⏳ Fase 3:** filter-chips (Alles / Alleen Shift-laag / Alleen ankers).

3. ✅ **Brainstorm spell-strook — Rob koos Plan B** (`spellstrip_B_spellbook.html`:
   categorie-kaarten + SVG-lijn naar toets + filter-chips). Dat is de richting; bouwen in Lua
   in de Layout-tab (volgende stap). A (actionbar) en C (HUD-wiel) vervallen.
4. Daarna: versie → **2.3.0**, changelog + CF-doc; grote wijziging = **Beta eerst** (Cisca-test).

### Werkafspraken (blijven gelden)
- **NL, kort.** **Never-lie** (ID's/coords verifiëren; Rob/Cisca bevestigen in-game).
- **Git + CF doet Rob/Cursor**; assistant geeft alleen commando + checklist.
- **Mount-truncatie:** addonbestanden met host-tools (Read/Edit/Grep) bewerken, **niet** via bash;
  bash/lupa geeft afgekapte kopieën → syntax niet betrouwbaar te checken. **Rob's `/reload` = finale check.**
- Grote wijzigingen eerst als **Beta** op CF.

---

## ResetRoutine advance bij givers — GEBOUWD (2e sessie), nog in-game te testen

**Symptoom (Rob):** in de weekly/reset-route (vault → q givers → hub → station) schoof de
pijl **niet door bij de quest givers**, ook niet na een quest aannemen. Onze native pijl
legde dit bloot; mét TomTom bewoog 'ie visueel toch mee via "set closest".

**Oorzaak:** een **niet-getrackte** giver (geen geverifieerd quest-ID in `GIVER_WEEKLIES`)
bleef een reminder mét route-pin → `ComputeOpenPins`-signatuur veranderde niet → geen
advance. Never-lie: we mogen "opgepakt" niet claimen zonder ID.

**Oplossing (gebouwd):** `giversVisited`-vlag in `ResetRoutine.lua`. Als je een quest
**aanneemt terwijl de pijl op de givers staat** (`QUEST_ACCEPTED` + `LeadIsGivers()`),
wordt de vlag gezet; de niet-getrackte givers-reminder verliest dan z'n route-pin
(`open = (not anyGiverOpen and not giversVisited)`) → route schuift door naar de volgende
stop. De regel blijft als **tekst-reminder** staan (geen valse "done"-claim). Vlag reset
bij een nieuwe route (`StartResetRoute`). Getrackte givers werken zoals voorheen
(pickup→inlog→done via IDs).

**Nog testen (Rob, zelf):** char met niet-getrackte giver → route lopen, quest aannemen
bij givers → pijl gaat naar hub. En op char met getrackte giver (Liadrin 93766 e.a.):
oude gedrag intact. **Optioneel later:** pure-arrival fallback (doorschuiven als je er was
zonder iets aan te nemen) — nu bewust op de QUEST_ACCEPTED-trigger gehouden om niet te
vroeg te skippen in de drukke stad (vault/givers liggen naast elkaar).

> Start hier morgen in een nieuwe chat. Dit bestand vat samen waar we staan, hoe we
> werken, en wat er nog ligt. Lees ook `CHANGELOG.md` [2.2.0-beta.1] voor de details.

---

## Deze sessie (2026-07-01, deel 2) — standalone route-pijl (2.2.0-beta.1)

**Aanleiding:** Rob logde in op **Cisca's PC** — óók met 2.1.1 verdween daar de pijl.
Cisca **heeft** TomTom (geen "TomTom is not loaded"-melding), dus 2.1.1's fix (puur
TomTom) hielp haar niet. Root cause: de hele "pijl overleeft aankomst / schuift door"-
machinerie zat vast aan TomTom; zonder (of met een haperende) TomTom kreeg je één
Blizzard-waypoint zónder keepalive → verdwijnt bij aankomst. Ook: `HereBeDragons`
werd geléénd van TomTom/HandyNotes (niet gebundeld) → cross-map re-pin brak op een
oude/afwezige HBD.

**Gebouwd (code klaar, niet in-game getest):**

| Wat | Bestand |
|-----|---------|
| Generieke native keepalive op Blizzard-waypoint + SuperTrack (volgt `ns.lastTarget`, her-zet bij aankomst, schuift door) — werkt zónder TomTom én als vangnet als TomTom's crazy arrow wég is | **NIEUW** `Modules/NativeArrow.lua` |
| **Eigen on-screen richtingspijl** (draait naar target, live afstand, versleepbaar, positie in `MidnightHelperDB.nativeArrowPos`) — want retail heeft géén ingebouwde draaipijl. Rob (2e sessie): native pin alleen was niet genoeg. `ROTATION_OFFSET` = één-regel-fix als de pijl omgekeerd wijst | idem `Modules/NativeArrow.lua` |
| TOC: module geregistreerd (na Delves) + versie → 2.2.0-beta.1 | `MidnightHelper.toc` |
| `ForceArrowToLead`: HBD-vertaling vervangen door lib-vrije `C_Map`-vertaling (`TranslateToMap`) | `Modules/Achievements.lua` |
| Changelog (in-game `CHANGELOG_220_*` in enUS, CHANGELOG.md, CF-doc) | `Modules/Changelog.lua`, `Locales/enUS.lua`, `CHANGELOG.md`, `docs/CURSEFORGE_2.2.0.md` |

**Ontwerpkeuze (belangrijk):** NativeArrow staat **volledig stil** zolang TomTom's
crazy arrow zichtbaar is (`_G.TomTomCrazyArrow:IsShown()`), dus Robs werkende setup
regresseert niet. Alleen bij **geen TomTom** of **arrow-down** stuurt het de native
waypoint. Het ruimt alleen de waypoint op die het zélf zette (nooit een handmatige).

**Zone-robuustheid (het terugkerende bug-patroon — NIET meer aan `ns.lastTarget`
koppelen!):** meerdere modules wissen `ns.lastTarget` in hun zone-handlers (bv.
`Delves.lua` runZoneNavCheck → `IsMidnightTravelComplete` → `ns.lastTarget = nil`),
waardoor de pijl verdween bij de stad/zone uitvliegen. NativeArrow leunt daarom op de
**stabiele** `ns._mhRouteOwner` (die enkel wist als de route écht klaar is) en houdt
een **eigen gecachete lead** (`activeLead`). Een tijdelijke `ns.lastTarget = nil` kan
de pijl dus niet meer doden — alleen owner→nil doet dat. Herbouw dit nooit op
`ns.lastTarget` alleen.

**Resize (Rob's verzoek):** slider in **Settings > General** (`SET_ARROWSIZE_*` in
en/nl) + `/mh arrowsize <28-160>`; opgeslagen in `MidnightHelperDB.nativeArrowSize`,
live via `ns.SetNativeArrowSize`. `ns.PreviewNativeArrow(sec)` flitst de pijl bij het
slepen/schalen. Pijl-textuur = `Interface\MinimapArrow` (basaal; mooiere .tga kan later).

**Auto-advance bij niet-gespawnde rare (Rob: geen /mh skip laten tikken):** in
`NativeArrow` latcht `UpdateArrow` (~30x/s) of je binnen `RARE_ARRIVAL` (40 yd) van de
lead kwam (vangt snelle fly-overs). De 1s-tick roept `ns.MHRareTryAutoAdvance(reached)`
(Rares.lua): is de rare bereikt maar z'n **vignette niet up** (= niet gespawned) en je
bent **niet in combat** → skip 'm naar achteren; de pijl gaat naar de volgende. Een
geskipte rare komt vanzelf terug zodra z'n vignette verschijnt (spawn) of als de rest
klaar is. Nooit de laatste open rare wegskippen. Geverifieerd via web dat vignette-
detectie de standaard is (RareScanner) mét de kanttekening "niet elke rare heeft een
vignette" → daarom terug-cyclen.

**UNIVERSALITEIT + CONVENTIE (belangrijk voor toekomstige routes):** NativeArrow werkt
generiek voor élke route die de gedeelde conventie volgt:
1. claim de arrow met `ns._mhRouteOwner = "<type>"` (en zet 'm op nil als de route echt
   klaar is — NOOIT bij zonewissel),
2. houd de huidige lead in `ns.lastTarget` (of, als je module `ns.lastTarget` nilt zoals
   Rares/Professions, expose een `ns.GetNearestIncomplete<X>Lead()` en laat NativeArrow
   die volgen — zie de rare/treasure-blokken in `NativeArrow.lua` Tick).
Nu gedekt: **Achievements, Rares, Professions/Treasures (deze sessie toegevoegd via
`ns.GetNearestIncompleteTreasureLead`), Reset-routine.** Een nieuwe route die de
conventie volgt krijgt pijl + zone-robuustheid + keepalive + doorschuiven gratis mee.
Rolt 'ie z'n eigen (TomTom-only) systeem zoals Professions ooit deed → dan valt 'ie
buiten de boot; sluit 'm dan aan op dezelfde backbone.

**Nog te doen (volgende sessie):**

1. **In-game test** (zie `docs/CURSEFORGE_2.2.0.md` testlijst) — mét én zónder TomTom,
   en op Cisca's PC.
2. Bevestigen dat Cisca's geval nu écht opgelost is. Zo niet: `/mh arrowdebug` aan op
   haar PC en de output bekijken (welke tak faalt) — dán pas verder.
3. Build + CF-upload (Rob doet dit; **Release type = Beta**).
4. Daarna pas terug naar taak #65 (Leveling-tab herzien).

---

## Werkafspraken (BELANGRIJK — lees dit eerst)

- **Taal:** antwoord in het **Nederlands**, kort en direct.
- **never-lie:** nooit ID's, coördinaten of criteria verzinnen. Verifieer altijd:
  in-game macro-dump, of kruis-check via HandyNotes_Midnight / Zygor / Wowhead.
  Liever "ik weet het niet, laten we dumpen" dan gokken.
- **Git & CurseForge doet Rob/Cursor**, niet de assistent. De assistent **geeft** het
  commit-commando en de CF-checklist, maar triggert nooit zelf een upload. Pas
  handelen op "ga".
- **Mount-truncatie:** bewerk addonbestanden ALTIJD met de host-tools (Read/Edit/
  Write/Grep). **Niet** via bash/python — de mount levert verouderde/afgekapte kopieën
  en grote bestanden lezen via bash is onbetrouwbaar. Verifieer balans via host-Grep;
  Rob's `/reload` in-game is de finale syntaxcheck.
- **Web:** alleen WebSearch / web_fetch. Nooit curl/bash/python om URLs te halen.
- **Releases:** de **volgende belangrijke versie eerst als Beta** op CF zetten, zodat
  Rob het bij Cisca kan testen vóór het naar iedereen gaat. (2.1.0/2.1.1 waren Release
  zonder beta — dat willen we niet meer bij grote wijzigingen.)

---

## Deze sessie (2026-07-01) — gedaan, zit in 2.1.1

De hele dag is gegaan naar het robuust maken van de **TomTom-route-pijl** op de
Achievements-tab, plus de **Light Up the Night**-meta. Alles in `Modules/Achievements.lua`.

| Onderwerp | Status |
|-----------|--------|
| Pijl verdween bij aankomst / na detour-kill / bij **sub-zone-kaartwissel** | Opgelost |
| Checklist-leesbaarheid (zebra + hover-highlight) | Klaar |
| `/mh skip` respecteren in de pijl-herstel | Klaar |
| Light Up the Night: live uitsplitsing 4 zone-meta's (header + rijen) | Klaar |
| Accurate tooltips per zone-meta (echte groen/rood, zelf opgebouwd) | Klaar |
| Petalwing-mount-preview op klik (via `ns.PreviewItem`) | Klaar |
| `/mh arrowdebug` diagnostics-toggle | Klaar |
| Changelog (in-game `CHANGELOG_211_*`, CHANGELOG.md, CF-doc) | Bijgewerkt |

### Hoe de pijl-fix werkt (zodat we het niet opnieuw hoeven uitvogelen)

**Kernprobleem:** TomTom's crazy arrow rendert alleen als de waypoint op de kaart staat
waar de speler NU is. Cross-map (sub-zone vs overworld, bv. Slayer's Rise 2444 vs
Voidstorm 2405) → pijl verbergt zich. En `TomTom:SetClosestWaypoint()` zoekt alléén op
de huidige speler-kaart, dus die vindt een cross-map node niet.

**Oplossing** (in `Achievements.lua`):
- `ForceArrowToLead()` pint de pijl op de route-**lead** (`ns.lastTarget`), en vertaalt
  die node naar de kaart waar de speler staat via **HereBeDragons**
  (`LibStub("HereBeDragons-2.0")`: `GetWorldCoordinatesFromZone` →
  `GetZoneCoordinatesFromWorld`). `cleardistance=0` (niet auto-wissen), announce gemute.
- `RepointArrowNearest()` roept eerst `ForceArrowToLead()`; alleen zonder lead valt het
  terug op TomTom's eigen `SetClosestWaypoint`.
- De keepalive-ticker (elke 2s) herpint **proactief** bij: kaartwissel (`mapChanged`),
  lead-wissel (`leadChanged`, bv. na skip), pijl-drop (`justDropped`), of weglopen van
  een node (`walkedOff`). NIET als je < 25 yd bij de lead staat (geparkeerd op een
  niet-gespawnde rare) → anders oscillatie. Plus een re-point op combat-end.
- `_G.TomTomCrazyArrow:IsShown()` = orphan-detectie (pijl-frame verborgen = gevallen).
- `/mh arrowdebug` print per beslissing de staat (owner, frameShown, playerMap vs
  leadMap, found/forced). Default uit.

**Gedeelde arrow-eigenaar:** `ns._mhRouteOwner` ("achievement"/"rare"/"treasure"/
"reset"/nil) arbitreert tussen modules (Rares.lua, ResetRoutine.lua, Profession.lua).

### Light Up the Night (meta 62386 → Brilliant Petalwing, item 252011)

- Vereist 4 **zone-meta's**: Forever Song (Eversong), Making an Amani Out of You
  (Zul'Aman), That's Aln, Folks! (Harandar), Yelling into the Voidstorm (Voidstorm).
  Elk vraagt méér dan de treasures/rares/telescopen/lore die MH trackt (ook quests,
  reputatie, world events) — die zijn niet te routen, alleen te tonen.
- `MetaDetailData()` leest de 4 criteria live; `RefreshMetaDetail()` bouwt de header-rij
  (de meta zelf) + 4 zone-rijen. Tooltip = zelf opgebouwd via `AddAchCriteriaLines`
  (NIET `SetAchievementByID` — die kleurt meta-subs ten onrechte allemaal groen).

---

## Volgende klus (afgesproken)

1. **Leveling / beta-tab herzien** (taak #65). Rob: *"ergens hoort ie er niet op deze
   manier in, hij is te summier en te vrijblijvend."* Dit was de hoofdreden om door te
   gaan na de Achievements-tab. Begin met: wat staat er nu, wat is de bedoeling, en een
   voorstel vóór we bouwen. **Doe deze als Beta-release richting Cisca.**

## Backlog (optioneel)

- `ACH_META_PREVIEW_HINT` staat nu alleen in en/nl; de/fr/es/pt/it vallen terug op EN.
  Eventueel later toevoegen in `Locales/Translations2026.lua`.
- Eventueel diepere per-zone tracking voor Light Up the Night (nu alleen tonen, niet
  routen — bewust, want quests/rep/events zijn niet waypoint-baar).

---

## Snelle commands

In-game:
```text
/reload
/mh skip          (sla de huidige route-node over)
/mh arrowdebug    (diagnostics aan/uit — default uit)
```

Build (Cursor/PowerShell, in de git-repo — de WoW-map heeft geen .git):
```powershell
git add -A
git commit -m "..."
powershell -ExecutionPolicy Bypass -File tools\package.ps1   # -> dist\MidnightHelper-<versie>.zip
```

CF-upload (Rob doet dit zelf): zip-root exact `MidnightHelper/`, geen tools/docs/.git/
scripts in de zip; display version = TOC-versie; game version Retail 120007 (12.0.7).
Changelog-tekst staat klaar in `docs/CURSEFORGE_<versie>.md`.
