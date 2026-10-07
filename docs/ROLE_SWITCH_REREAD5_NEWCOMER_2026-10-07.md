# Tanken en healen, herlezing 5 door een nieuweling (7 okt 2026)

Eerdere rondes: tanken 3 → 6 → 7 → 8 → 9, healen 5 → 7 → 8 → 9 → 9. De vorige staat in
`ROLE_SWITCH_REREAD4_NEWCOMER_2026-10-07.md`.

**Wie las dit.** Dezelfde lezer als ronde 4: speelt al een tijd DPS, ingelogd als Prot Paladin (tweede spec), nooit
getankt of geheald. De lat: een 10 = zonder vragen je eerste dungeon tanken of healen.

**Hoe betrouwbaar.**
- Tekst en regelnummer: **GEMETEN** in de bestanden op 7 okt 2026 (nlNL-regels van vandaag).
- Volgorde op het scherm: **GEMETEN** in `Modules/RoleAcademy.lua:15-19` (stappen), `:54-111` (blokken) en `:992-1026`
  (wat is het → woorden → stappenplan → mindset/triage → grote klap zien → ladder → kaartknop → toolkit → rest).
- De 11 nieuwe of gewijzigde keys staan elk één keer in `nlNL.lua` (GEMETEN: 11 patronen, 11 treffers).
  `Translations2026.lua` vult nlNL niet (GEMETEN: `nlNL` komt daar alleen in commentaar voor). `Locales/Codex.lua` heeft
  0 Academy-, kaart- of toolkit-keys (GEMETEN; hetzelfde patroon vond er 264 in nlNL).
- Of een knop echt op je scherm staat, hangt af van je talenten (`OwnedOnly`, `IsPlayerSpell`): **AFGELEID**.
- "Dit snap ik niet" = **mijn oordeel als lezer**. Of de spelinformatie klopt: **NIET gecontroleerd**. Bij een
  spelvraag staat "vraag", geen bewering.

---

## Het korte antwoord

**De drie grote punten van ronde 4 zijn opgelost.**
- Het schild: de gear-stap zegt nu waar je er een haalt (`ACADEMY_STEP_TANK_GEAR` nlNL:2139), en *Wat is een tank?*
  verwijst ernaar (nlNL:2153).
- Kaart 66 noemt de AoE-knoppen bij naam en taunt *"met Hand of Reckoning"* (`PLAYCARD_66_S5` nlNL:1152).
- Het heal-stappenplan heeft een gear-stap (`RoleAcademy.lua:17`, `ACADEMY_STEP_HEAL_GEAR` nlNL:2142).

Wat nog wringt, de drie grootste:
- **Bijna dood: Divine Shield of Lay on Hands?** Beide heten "voor als je bijna dood bent". De tekst zegt nu dat Lay
  on Hands niet werkt na Divine Shield, maar niet welke je kiest.
- **Blessing of Protection: nog twee opdrachten in één regel** (vooraf drukken, en "alleen in nood").
- **Heal: de gear-stap zegt wat, niet waar** je Intellect-spullen haalt. De tank-stap zegt dat wel.

**Nieuwe cijfers: tanken 9/10, healen 9/10.** Beide hoger binnen de 9: wat overblijft is klein, maar het zijn nog
vragen.

---

## Deel 1: de punten uit herlezing 4

### Tank

| # | Punt uit ronde 4 | Nu | Bewijs |
|---|---|---|---|
| T1 | Waar haal ik een schild? | **opgelost** (één nieuwe vraag, N1) | GEMETEN nlNL:2139: *"Nog geen schild? Op level 90: Auction House -> Armor -> Miscellaneous -> Shield, plus een eenhandig wapen met je hoofdstat ... Onder level 90: zet je Loot Specialization op je tank-spec ... en doe dungeons."* nlNL:2153: *"Waar je er een haalt, staat bij de gear-stap hieronder."* Of het AH-pad in 12.1 zo heet: NIET door mij gecontroleerd. |
| T2 | Kaart 66: *"je AoE"* en *"ermee"* | **opgelost** | GEMETEN nlNL:1152: *"Bij een pack begin je met je AoE: [Consecration] en [Avenger's Shield]. Slaat een vijand iemand anders, taunt hem dan met [Hand of Reckoning]."* |
| T3 | Drie keer dezelfde defensive-zin | **opgelost** | GEMETEN: `TankToolkit.lua:107-109` geeft `size = "small"/"big"`, `:210-217` kiest de tekst. Ardent Defender: *"Een kleine: druk hem vaak ..."* (nlNL:3627); Guardian of Ancient Kings en Sentinel: *"Een grote: bewaar hem voor de hardste klap ..."* (nlNL:3628). Geen verwijzing naar de kaart meer nodig. |
| T4 | Blessing of Protection: twee opdrachten; Lay on Hands na Divine Shield? | **half** | Lay on Hands: **opgelost**, GEMETEN nlNL:1631: *"geeft Forbearance: 30 s lang werken je andere immuniteit en Lay on Hands op jezelf niet."* Blessing of Protection: **niet opgelost**. De regel is nog steeds `SURVIVAL_STEP_BIG` (nlNL:1531, *"druk hem net vóór de hardste klap"*) + noot nlNL:1533 (*"als tank alleen in nood"*), aan elkaar geplakt door `SurvivalPlan.lua:769-773`. |
| T5 | Hammer of the Righteous in de AoE-lijst | **opgelost** | GEMETEN `TankToolkit.lua:151`: `aoe = { 26573, 31935, 204019, 53595 }`. Je ziet alleen de hamer die je kent (`RoleAcademy.lua:701-711`). |
| T6 | Kleine woorden in de toolkit | **half** | Opgelost: *"houd deze aan"* (`TANKKIT_MIT_HEAD` nlNL:3603), *"Je eigen defensives"* (`TANKKIT_CDS_HEAD` nlNL:3610). Niet: label *[Block]* nergens uitgelegd (nlNL:3612); kop *"Je taunt, je interrupt en je AoE"* (nlNL:3604) noemt de stun nog niet. |
| T7 | Twee routes (stappenplan en ladder) | **niet opgelost** | GEMETEN: stappenplan nlNL:2149 (*"anders een willekeurige groep"*), ladder nlNL:2178 (*"Normal dungeon met mensen die je vertrouwt"*, *"Blijf bij elke stap tot hij saai voelt"*). |
| T8 | Rol kiezen als je niet de leider bent | **opgelost** | GEMETEN nlNL:2149 en 2170: *"Niet de leider? ... dan krijg je "Confirm your role:" - vink je rol aan en klik Accept"*. Of het spel die woorden zo toont: NIET gecontroleerd. |
| T9 | Kleine restjes | **grotendeels open** | Kopje boven Templar/Lightsmith: **niet** (GEMETEN: `PlayCardWindow.lua:1073` vraagt `card.easy`; `PLAYCARD_66_EASY` bestaat niet in enUS of nlNL, positieve controle: 7 andere `_EASY`-keys gevonden). Pull-hoofdstuk zonder Shield of the Righteous: **niet** (nlNL:2166). Stap 3 zonder AoE: **niet** (nlNL:2140). *"Let op mana van de healer"*: **niet** (nlNL:2170). Venster onthoudt laatste tab: **niet** (`PlayCardWindow.lua:258-262`; AFGELEID). Holy Power: kaart zegt nu *"punten die oplopen tot 5"* (nlNL:1147); voor deze lezer genoeg. |

### Heal

| # | Punt uit ronde 4 | Nu | Bewijs |
|---|---|---|---|
| H1 | Geen gear-stap | **half** | GEMETEN: stap 2 bestaat (`RoleAcademy.lua:17`, nlNL:2142): *"Gear met Intellect ... Vooral een wapen met Intellect. Een Paladin houdt zijn plate: er is plate met Intellect."* Niet: wáár je dat haalt. De tank-stap noemt Auction House en Loot Specialization; deze niet. |
| H2 | Voorbeeldkaart belooft toetsen | **opgelost** | GEMETEN nlNL:703: *"...; die zie je pas als je in deze spec staat."* Restje, AFGELEID: de klasregel *"De kaart van je spec: /mh play"* (nlNL:2119) opent in Prot-spec de Protection-kaart (`Core.lua:3250-3253` → `TogglePlayCardWindow()` zonder spec). Na stap 1 klopt het. |
| H3 | "Grote cooldowns" tegen "vaak" | **opgelost** | GEMETEN: titel *"Gebruik je cooldowns op het goede moment"* (nlNL:2206); tekst *"Sommige zijn voor de grote momenten ... Andere gebruik je juist vaak, bijna op cooldown."* (nlNL:2207); `/mh healcds` *"Jouw cooldowns — gebruik ze op het goede moment:"* (nlNL:3560). Positieve controle: *"grote cooldown"* vond wel 3 regels buiten deze tracks (629, 1403, 1594). |
| H4 | Kaart 65 zegt twee keer hetzelfde | **niet opgelost** | GEMETEN: `PLAYCARD_65_EASY` punt 2 en 3 (nlNL:1198) = stap 3 en 4 (nlNL:1201-1202), bijna woord voor woord. |
| H5 | Woorden | **niet opgelost** | GEMETEN: *raid-wide damage*, *speler-bar*, *"tank en raid cooldowns eerst"* (2191); *buffen* (2189); *Tank is prio* (2193); *kleine group* (2195); *ally* (3569); *single-target*, *dipt* (3666); *[Extern]* (3565); *fatale debuff* (2185). |
| H6 | Triage bij specs zonder *[Groot]* | **niet opgelost** (raakt de Prot Paladin niet) | GEMETEN: Regrowth nog *[Snel]* (`HealerCooldowns.lua:172`), triage noemt hem *"je grote heal"* (nlNL:2185). |

### Beide

| # | Punt | Nu | Bewijs |
|---|---|---|---|
| B1 | Toetsen in twee schrijfwijzen | **niet opgelost** | GEMETEN: Academy gebruikt Blizzards korte vorm (`LiveKeys.lua:62-65`, `GetBindingText(key, true)`; `RoleAcademy.lua:465-466`), kaart schrijft uit (`PlayCardWindow.lua:318-326`). Woordenlijst legt de korte vorm niet uit (nlNL:2157). |
| B2 | "Cooldown" als knop | **half** | GEMETEN: het heal-hoofdstuk zegt nu *"Je heal-cooldowns zijn knoppen met een lange wachttijd"* (nlNL:2207). Maar dat hoofdstuk staat ná de toolkit-kop *"Je cooldowns"* (nlNL:3580; volgorde `RoleAcademy.lua:1002-1026`). De woordenlijst kent alleen de wachttijd (nlNL:2157). |
| B3 | Boss Abilities: waar op mijn scherm? | **niet opgelost** | GEMETEN nlNL:2161. Klein. |

**Telling: tank 5 opgelost (T1, T2, T3, T5, T8), 2 half (T4, T6), 2 open (T7, T9). Heal 2 opgelost (H2, H3), 1 half
(H1), 3 open (H4, H5, H6). Beide: 0 opgelost, 1 half, 2 open.**

---

## Deel 2: de tracks in schermvolgorde

✔ = verder zonder vraag, ? = vraag (staat in Deel 3).

### Tank-track (Prot Paladin, toolkit met toetsen)
1. ✔ Kop, ondertitel, klasregel (nlNL:2115, 2119).
2. ✔ *Wat is een tank?* (2153). Schild: nu met verwijzing.
3. ✔ *Woorden die je gaat horen* (2157).
4. ? Stappenplan (2138-2149). Stap 2 gear: N1. Stap 7 normal: nu compleet, wel erg lang voor één vinkje.
5. ✔ *Tank-mindset* (2164), ✔ *Zo zie je een grote klap* (2161).
6. ? *Angst-ladder* (2178): T7.
7. ? Knop *"Zo speel je Protection >"* → kaart 66. ✔ S5 nu helder. ? N3 (Avenging Wrath/Sentinel), N5 (Blessed Hammer).
8. ✔ Toolkit: Shield of the Righteous, taunt, interrupt, stun, één AoE-regel met knoppen, defensives **klein/groot per
   knop**, dispel. ? *[Block]*, ? N4 (Spellwarding).
9. ✔ *Tijdens een pull* (2166), *Als het misgaat* (2168), *Je eerste normal dungeon* (2170), *Raids* (2172), *Party chat*
   (2174-2176), *Ook heal of DPS* (2180). ? N6 (de route).
10. Kaart, tab *Blijf leven*: ? N2 (Divine Shield of Lay on Hands), ? T4 (Blessing of Protection), ? N7 (vóór de pull).

### Heal-track (Prot Paladin: voorbeeld van Holy, zonder toetsen)
1. ✔ *Wat is een healer?* (2155), ✔ woordenlijst.
2. ? Stappenplan (2141-2149): nu met gear-stap, maar zonder "waar" (H1). ? N9 (geen vriend).
3. ✔ *Heal-mindset* (2183), ✔ *Triage* (2185), ✔ grote klap zien, ✔ ladder (op *"group"* na).
4. ✔ Knop *"Zo speel je Holy >"* → kaart 65: belooft geen toetsen meer. ? dubbele stappen (H4), ? N8 (Holy Light).
5. ✔ Toolkit-voorbeeld. ? *personal defensives* (3584), ? *ally*, *dipt*, *[Extern]* (H5), ? N2 (bijna dood).
6. ✔ *Mana*, *Waar je gaat staan*, ✔ *Gebruik je cooldowns* (nu goed), ✔ *Beginnersfouten*, *Als het misgaat*,
   *Iemand verliezen mag*, *Je eerste normal dungeon*. ? *Raids* (H5). ✔ *Party chat*, *Ook tank of DPS*.

---

## Deel 3: nieuw, of nu pas zichtbaar

Groot naar klein. Tekst = GEMETEN; of het in het spel klopt = niet gecontroleerd.

### Tank

**N1. "Onder level 90 ... doe dungeons": als wat?** (middel)
- nlNL:2139: zonder schild, onder 90, *"zet je Loot Specialization op je tank-spec ... en doe dungeons"*.
- Maar zonder schild kan ik niet tanken (nlNL:2153). Dus doe ik die dungeons als DPS (Ret)? Dat staat er niet.
- En het stappenplan zegt twee stappen later dat je éérste dungeons (follower, normal) nog moeten komen. Ik lees het
  als een kringetje. **AFGELEID** (mijn lezing van de tekst).

**N2. Bijna dood: Divine Shield of Lay on Hands?** (middel; ook in de heal-track)
- *Blijf leven* (Prot): Divine Shield = *"een grote ... (een immuniteit mag ook als je bijna dood bent)"* (nlNL:1531);
  Lay on Hands = *"laatste redmiddel"* (nlNL:1632); en na Divine Shield werkt Lay on Hands 30 s niet (nlNL:1631).
- De kaart is genummerd *"in de volgorde die een gevecht nodig heeft"* (nlNL:1524), en Divine Shield staat vóór Lay on
  Hands (`SurvivalPlan.lua:119-126`: stap *big* vóór *heal*). Volg ik de nummers, dan blokkeer ik mijn laatste redmiddel.
- Welke druk ik als ik bijna dood ben? Dat moet ik raden. Of het omgekeerd ook geldt (na Lay on Hands geen Divine
  Shield): staat nergens, vraag.

**N3. Avenging Wrath op de kaart, Sentinel in de toolkit.** (middel, vraag)
- Kaart S1: *"[Avenging Wrath] en [Divine Toll] als ze klaar zijn"* (nlNL:1148).
- Toolkit en *Blijf leven*: Sentinel is *"een grote: bewaar hem voor de hardste klap"* (nlNL:3628; `KeybindRoles_Paladin.lua:218`).
- Vraag (geen bewering): vervangt Sentinel in 12.1 Avenging Wrath op je balk? Zo ja, dan zegt de kaart "druk zodra
  klaar" en de toolkit "bewaar" over dezelfde knop. Laten meten (`mh-research`).

**N4. Blessing of Spellwarding: halve uitleg.** (klein, vraag)
- Toolkit: alleen *"tegen zware magische schade"* (nlNL:3631), zonder wachttijd (`TankToolkit.lua:110`, geen `cd`).
- De tab Groep zegt *"zelfde cooldown als Blessing of Protection"* (nlNL:1545) en dat hij Forbearance geeft
  (nlNL:1547). *Blijf leven* zegt dat niet. En: *"je andere immuniteit"* (nlNL:1631): welke is dat bij mij?
- Bij Blessing of Protection staat *"vijanden gaan naar iemand anders"*; bij Spellwarding niets. Geldt het daar ook?
  Laten meten.

**N5. Kaart S3 noemt Blessed Hammer, ook als je Hammer of the Righteous hebt.** (klein, AFGELEID)
- nlNL:1150 noemt alleen 204019. De toolkit toont nu de hamer die je kent (`TankToolkit.lua:151`).
- Op level 90 wordt niets grijs (`PlayCardWindow.lua:297-301`), dus wie Hammer of the Righteous heeft, leest op de kaart
  een knop die niet op zijn balk staat, zonder toets.

**N6. "Jij loopt voorop": maar waarheen?** (klein voor deze lezer, groot voor een echte nieuweling)
- nlNL:2153 en 2164: jij bepaalt het tempo en loopt voorop. Nergens: wat als je de weg niet weet.
- Deze lezer deed dungeons als DPS, dus kent ze een beetje. Toch de eerste vraag van elke nieuwe tank.

**N7. Shield of the Righteous: "vóór de pull"?** (klein)
- *Blijf leven*: *"houd deze aan, vóór de pull en het hele gevecht"* (`SURVIVAL_STEP_KEEPUP` nlNL:1525).
- Toolkit: *"zolang vijanden je slaan"* (nlNL:3617). Kaart: *"3 of meer Holy Power"* (nlNL:1149).
- Moet ik hem vóór de pull drukken, zonder Holy Power? De stap-tekst is algemeen (geldt ook voor Consecration), maar
  op deze regel lees ik iets anders dan in de toolkit.

**N8. Kleintjes.**
- *"Druk hem als hij gratis is (Shining Light)"* (nlNL:1616): hoe zie ik dat hij gratis is?
- Kaart 66: *"Je knoppen, belangrijkste eerst"* (nlNL:1129) en dan staat Avenging Wrath op 1 en de pull-start op 5.
  Ik lees "belangrijkste" als "het belangrijkst", niet "als er meer klaar staan".
- Stap 7 (nlNL:2149) is nu vijf zinnen in één vinkje. Klopt, maar lang.

### Heal

**N9. Stap 6: "een vriend geheald" — en als ik geen vriend online heb?** (klein)
- nlNL:2147. Geen alternatief. Ook ladder stap 1 vraagt een vriend (nlNL:2195).

**N10. Holy Light: toolkit en triage wel, kaart niet.** (klein, AFGELEID)
- Triage: *"Veel schade en tijd om te casten: je grote heal"* (nlNL:2185) → toolkit Holy Light *[Groot]*
  (`HealerCooldowns.lua:164`).
- Kaart 65 noemt Holy Light nergens (nlNL:1197-1206). Moet ik hem gebruiken of niet?

**N11. Flash of Light: altijd, of alleen als hij oplicht?** (klein)
- Toolkit: *[Snel]* *"je reactieknop als iemand dipt"* (nlNL:3666). Kaart: *"Zodra [Flash of Light] oplicht op je balk:
  cast hem"* (nlNL:1200). Twee verschillende momenten voor één knop.

**N12. Twee "bijna dood"-knoppen, geen Forbearance.** (klein; zelfde als N2)
- Heal-toolkit: Lay on Hands *"zodra iemand (of jij) bijna doodgaat"* (nlNL:3570) en Divine Shield *"Een immuniteit mag
  ook als je bijna dood bent"* (nlNL:3585). Forbearance staat hier niet.
- Tab Groep: Prot zegt bij Lay on Hands Divine Shield, Blessing of Protection én Spellwarding (`GroupPlan.lua:51`,
  nlNL:1547); Holy alleen Blessing of Protection (`GroupPlan.lua:331`, nlNL:1603). Twee kaarten van één klasse,
  twee antwoorden.

**N13. Engels in een kop.** *"Je personal defensives"* (nlNL:3584), terwijl de tank-toolkit nu *"Je eigen defensives"*
zegt (nlNL:3610).

### Wat nu echt goed is
- De tank-toolkit is nu zelfstandig: per defensive klein of groot, één AoE-regel met knoppen, elke knop met toets.
- Kaart 66 en de toolkit zeggen hetzelfde over de pull en de taunt.
- Het schild heeft een antwoord, met een verwijzing vanaf de plek waar je de vraag krijgt.
- Rol kiezen werkt nu ook als je niet de leider bent.
- De heal-track zegt nergens meer "grote cooldowns" waar "gebruik vaak" bedoeld is.

---

## Deel 4: nieuwe cijfers

- **Tanken: 9/10** (bleef 9, nu een hoge 9). De drie gaten van ronde 4 zijn dicht; wat overblijft zijn vragen over
  noodknoppen (Divine Shield of Lay on Hands, Blessing of Protection wanneer) en een gear-zin voor onder level 90 die
  in een kringetje leest.
- **Healen: 9/10** (bleef 9). Gear-stap, voorbeeldkaart en cooldown-hoofdstuk zijn beter; er blijven Engelse woordjes,
  een kaart die zichzelf herhaalt, en een gear-stap zonder "waar".

---

## Deel 5: wat er nog nodig is voor een 10

Tekstideeën, geen spelfeiten. Spelvragen eerst laten meten (`mh-research`). Rob kiest.

**Tank:**
1. **Noodknoppen (N2):** één zin op *Blijf leven* en in de toolkit: *"Bijna dood? Kies er één: Divine Shield óf Lay on
   Hands. Na Divine Shield werkt Lay on Hands 30 s niet."* Eerst laten meten of het omgekeerd ook geldt.
2. **Blessing of Protection (T4):** voor Prot de stap-tekst weglaten en alleen de noot tonen, of een eigen regel:
   *"alleen in nood: vijanden laten je los, taunt ze meteen terug."*
3. **Onder level 90 (N1):** *"doe dungeons als DPS, met je Loot Specialization op Protection"*, als dat klopt
   (laten meten). En het AH-pad laten meten.
4. **Sentinel/Avenging Wrath (N3):** laten meten of het één knop is; zo ja, kaart en toolkit één advies geven.
5. **Spellwarding (N4):** laten meten of vijanden je loslaten; dan de noot van Blessing of Protection ook hier, plus
   *"zelfde cooldown als Blessing of Protection"* en Forbearance.
6. **Opruimen:** *[Block]* uitleggen (of in de woordenlijst); kop *"Je taunt, interrupt, stun en AoE"*; kopje boven
   Templar/Lightsmith; stap 3 ook de AoE-knoppen; één zin over Shield of the Righteous in het pull-hoofdstuk;
   *"vóór de pull"* niet bij Shield of the Righteous (N7); hoe je *Shining Light* ziet (laten meten); kaart S3 de hamer
   noemen die je hebt (N5).
7. **Eén route (T7):** de ladder als "daarna" (heroic/LFR), of follower en normal eruit.
8. **De weg (N6):** één chatregel erbij: *"Eerste keer hier als tank - zeg het als ik verkeerd loop."* Als MH's
   dungeon-tab de route toont (laten checken in `Modules/`), daarheen verwijzen.

**Heal:**
1. **Gear-stap (H1):** zelfde vorm als de tank-stap: waar je Intellect haalt (AH, Loot Specialization), na meten.
2. **Kaart 65 (H4):** de dubbele stappen 3 en 4 weg, of de *"in 3 stappen"* korter.
3. **Woorden (H5, N13):** *raid-wide*, *speler-bar*, *buffen* (welke), *prio*, *group*, *ally*, *single-target*, *dipt*,
   *[Extern]*, *personal*; *"tank en raid cooldowns eerst"* in twee zinnen; *fatale debuff* uitleggen of weglaten.
4. **Noodknoppen (N12):** zelfde zin als tank 1, in de heal-toolkit; Holy's Lay on Hands-noot op de tab Groep gelijk
   maken aan die van Prot (na meten).
5. **Holy Light en Flash of Light (N10, N11):** kaart en toolkit één verhaal laten vertellen.
6. **Geen vriend (N9):** *"Geen vriend online? Sla deze stap over; de follower dungeon is ook oefenen."*

**Beide:**
1. Toetsen overal op één manier (B1), of de korte vorm in de woordenlijst.
2. Woordenlijst: *"Cooldowns (als knop): knoppen met een lange wachttijd"* (B2), zodat het vóór de toolkit staat.
3. Waar de tijdlijn Boss Abilities staat (B3, laten meten).

---

**Niet gelezen:** de DPS-track, de tab *Basis*, de kaart-tabs *Consumables* en *Dispel*, de tab *Groep* alleen voor de
paladin-rijen. Uit `docs/` las ik alleen `ROLE_SWITCH_REREAD4_NEWCOMER_2026-10-07.md`. Het venster zelf heb ik niet
gezien; alles komt uit code en teksten.
