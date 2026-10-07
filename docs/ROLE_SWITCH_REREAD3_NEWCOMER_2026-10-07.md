# Tanken en healen, vierde lezing door iemand die nooit speelde (7 okt 2026, nacht)

Ronde 1: `ROLE_SWITCH_REVIEW_NEWCOMER_2026-10-07.md` (tanken 3, healen 5).
Ronde 2: `ROLE_SWITCH_REREAD_NEWCOMER_2026-10-07.md` (tanken 6, healen 7).
Ronde 3: `ROLE_SWITCH_REREAD2_NEWCOMER_2026-10-07.md` (tanken 7, healen 8).
Daarna is de Role Academy weer aangepast. Ik las hem opnieuw, in het Nederlands, in de volgorde van het scherm.

**Wie las dit.** Een lezer die World of Warcraft nooit speelde. Geen eigen spelkennis, niets online opgezocht.
Ik weet alleen wat de teksten zelf uitleggen.

**Hoe betrouwbaar is dit rapport.**
- Wat een tekst zegt en op welke regel: **GEMETEN** in de bestanden op 7 okt 2026.
- De volgorde op het scherm: **GEMETEN** in `Modules/RoleAcademy.lua:53-110` en `:942-970`. Onveranderd sinds ronde 3:
  basis (wat is een tank/healer, woordenlijst) → stappenplan → mindset / triage / grote klap / ladder → knop
  *"Zo speel je ..."* + toolkit → de overige hoofdstukken.
- Welke spreuken een Prot Paladin ziet: **GEMETEN** in de tabellen (`TankToolkit.lua`, `HealerCooldowns.lua`,
  `KeybindRoles_Paladin.lua`, `SurvivalPlan.lua`). Of ze écht op zijn scherm staan, hangt af van zijn talenten: **AFGELEID**.
- "Dit snap ik niet": **mijn oordeel als beginner**, geen meting.
- Of de spelinformatie klopt: **NIET gecontroleerd**. Dat mocht ik niet.
- Terugvallen op `enUS.lua` was niet nodig. **GEMETEN:** elke key uit de basis, het stappenplan, de hoofdstukken en
  de toolkits staat in `Locales/nlNL.lua`, en steekproeven (7 keys) vonden elk precies één definitie in nlNL, dus
  niets overschrijft ze later.
- Regelnummers in nlNL zijn bijna gelijk aan ronde 3. Alleen het blok HEALTOOLKIT/TANKKIT/HEALCORE schoof 2 regels op.

---

## Het korte antwoord

**Alle drie de punten uit de top-3 van ronde 3 zijn opgelost.**
- De kaart en de Academy zeggen nu hetzelfde over de pull, over de grote defensives en over Avenging Wrath en Divine Toll.
- Het stappenplan zegt bij elke stap hóé: waar de knop zit, wat je sleept, waar de dummy staat, welk pad in de Group Finder.
- "Zuinig" is "Groot" geworden, de woordenlijst is compleet, de chat-stap is af, en "Dát is je moment" is eenduidig.

Wat nog wringt, de drie grootste:
- **"Bij een pack begin je met je AoE."** Welke knop is mijn AoE? Geen tekst noemt er een.
- **Blessing of Protection** staat op de *Blijf leven*-kaart van een tank als grote defensive. De tab *Groep* zegt:
  *"niet op een tank, vijanden laten hem dan los"*.
- **Stap 7 stuurt me naar een willekeurige groep.** Het hoofdstuk zegt *"Start normal met vrienden of guildies"*. En
  nergens staat dat ik de Group Finder moet vertellen dat ik tank of healer ben.

**Nieuwe cijfers: tanken 8/10, healen 9/10.**

---

## Deel 1: de top-3 uit ronde 3

| # | Punt uit ronde 3 | Nu | Waar (key, regel) |
|---|---|---|---|
| 1 | Kaart en Academy hetzelfde laten zeggen (3 plekken) | **opgelost** | zie 1a-1c |
| 2 | Het "hoe" bij elke stap van het stappenplan | **opgelost** (kleine restjes) | zie 2 |
| 3 | "Zuinig" weg; woordenlijst; chat-stap; "Dát is je moment" | **opgelost** (één restje bij de Druid) | zie 3 |

**Telling: 3 opgelost, 0 half, 0 niet.**

### 1a. Pull met taunt of niet
- Kaart nu: *"Bij één vijand of een baas mag je beginnen met [Hand of Reckoning]. Bij een pack begin je met je AoE.
  Taunt ermee zodra een vijand iemand anders slaat."* (`PLAYCARD_66_S5` nlNL:1151).
- Academy: *"Een hele pack pak je met je aanvallen die veel vijanden tegelijk raken (AoE), niet met taunt."*
  (`ACADEMY_TANK_WHAT_BODY` nlNL:2142) en *"Taunt alleen de vijand die naar iemand anders loopt."* (`ACADEMY_TANK_PULL_BODY` nlNL:2155).
- **Opgelost.** Pack = AoE, in alle drie. Eén vijand of een baas: alleen de kaart zegt iets, maar dat botst niet.
- Nieuw restje: wélke knop is mijn AoE? Zie deel 2, T1.

### 1b. Grote defensive: vooraf of als je zakt
- Kaart *Blijf leven*: *"een grote: druk hem net vóór de hardste klap die je ziet aankomen (een immuniteit mag ook als je
  bijna dood bent)"* (`SURVIVAL_STEP_BIG` nlNL:1523). Klein: *"druk hem vaak, net vóór een harde klap"* (nlNL:1522).
- Tank-toolkit: *"Druk 'm vóór een grote klap of aan het begin van een grote pull, niet pas als je health al laag is."*
  (`TANKKIT_CDDESC_DR` nlNL:3614). Divine Shield: *"Druk hem net vóór een klap die je zou doden, of als je bijna dood bent."*
  (`TANKKIT_CDDESC_IMMUNITY` nlNL:3615).
- Heal-toolkit: *"Druk hem net vóór een grote klap op jou. Een immuniteit mag ook als je bijna dood bent."*
  (`HEALTOOLKIT_DEF_DESC` nlNL:3574).
- **Opgelost.** Overal "vooraf", en de uitzondering voor een immuniteit staat er overal bij. Divine Shield heeft geen
  drie verschillende uitleggen meer.
- De oude zin *"als je health snel zakt"* bestaat nog (`SURVIVAL_STEP_HURTS` nlNL:1518), maar alleen in het plan voor
  klassen zonder eigen indeling (`SurvivalPlan.lua:128-137`). Alle 13 klassen staan in de lijst mét indeling
  (`SurvivalPlan.lua:102-116`). **AFGELEID:** niemand ziet die zin nog.

### 1c. Avenging Wrath en Divine Toll (Holy Paladin): meteen of wachten
- Toolkit nu: *"Gebruik hem vaak, bijna op cooldown. Houd hem alleen een paar seconden vast als je weet dat er zo een
  grote klap komt."* (`HEALCD_WHEN_OFTEN` nlNL:3565). **GEMETEN** dat beide spreuken die regel krijgen:
  `HealerCooldowns.lua:105-106` (`when = "often"`).
- Kaart: *"zodra ze klaar zijn"* (`PLAYCARD_65_S1` nlNL:1197), *"Druk Divine Toll op cooldown"* (`PLAYCARD_65_HERO1` nlNL:1203).
- **Opgelost.** Restje (klein, deel 2, H1): de kop erboven heet *"Je grote cooldowns"* en het hoofdstuk zegt dat grote
  cooldowns *"voor de grote momenten"* zijn.

### 2. Het "hoe" bij elke stap
| Gevraagd in ronde 3 | Nu | Waar |
|---|---|---|
| Talents & Spellbook openen | **opgelost** | *"(rechtsonder)"* in stap 1 (nlNL:2128, 2131) + de hint *"houd je muis op een knop in het rijtje kleine knoppen rechtsonder in beeld"* (`ACADEMY_STEP_HINT` nlNL:2127) |
| Spreuk op een toets zetten | **opgelost** | *"Talents & Spellbook -> Spellbook, sleep elke spreuk met de linkermuisknop naar je actiebalk"* (nlNL:2130, 2133) |
| Training dummy: wat en waar | **opgelost** | Woordenlijst (nlNL:2146) + *"in Silvermoon (westkant, bij Falconwing Square; de MH-tab Silvermoon City heeft een pin)"* (nlNL:2135). **GEMETEN:** die pin bestaat, `UI.lua:1317` (`training_dummies`, onder *Questhubs*); de tab heet echt *Silvermoon City* (`TAB_SMC` nlNL:2081). Of de plek klopt: niet gecontroleerd. |
| Group Finder openen | **opgelost** | *"Group Finder, rechtsonder -> Dungeon Finder -> Follower Dungeons -> Find Group"* (nlNL:2137) |
| Pad voor stap 7 | **opgelost** | *"Group Finder -> Dungeon Finder -> Random Dungeon (Midnight) -> Find Group"* (nlNL:2138) |
| Waar typ ik `/mh ...` | **opgelost** | *"druk Enter, typ /mh play, druk Enter"* (`ACADEMY_STEP_CARD` nlNL:2134), vóór de andere `/mh`-teksten |
| "Follower dungeon" vóór gebruik uitleggen | **opgelost** | In de woordenlijst (nlNL:2146), die vóór het stappenplan staat |
| Kaart: typen of klikken | **opgelost** | *"de knop "Zo speel je" hieronder, of ..."* (nlNL:2134) |

Restjes (nieuw, in deel 2): stap 2 *Gear* heeft nog geen "hoe" (T7); stap 5-heal *vriend healen* zegt niet hoe je een
vriend in je groep krijgt (H5); stap 7 zegt niet dat je een rol kiest (T4).

### 3. Zuinig, woordenlijst, chat, "Dát is je moment"
- **Label:** *"Groot"* (`HEALCORE_TAG_BIG` nlNL:3645). Triage zegt nu *"je snelle heal"*, *"je grote heal"* en *"een heal
  die weinig mana kost (de tooltip toont de kosten)"* (nlNL:2174). Labels en Triage passen. **Opgelost.**
  Restje: een Resto Druid heeft geen enkele heal met *Groot* (`HealerCooldowns.lua:169-175`), dus *"je grote heal"*
  wijst bij hem nergens naar (H2).
- **Woordenlijst:** alle zeven gevraagde woorden staan erin: Gear, Cast (+ Instant), HoT, Overheal, Raid, Instance,
  Troep (nlNL:2146). **Opgelost.**
- **Chat-stap:** *"Klik op een regel ... Ctrl+C. Druk dan Enter om de chat te openen, Ctrl+V om te plakken, en Enter om
  te versturen. Zet de naam van de spreuk van de vijand op de plek van [spell]."* (`ACADEMY_CHAT_HINT` nlNL:2163). **Opgelost.**
  Restje: naar wie gaat het? De kop heet *Party chat*, maar de hint zegt alleen *"de chat"* (T10).
- **"Dát is je moment":** nu *"terwijl de balk nog volloopt - zodra je hem ziet is prima. Een volle balk is te laat."*
  (`ACADEMY_SEE_BODY` nlNL:2150). En de interrupt-regel in de toolkit wijst naar dezelfde balk (`TANKKIT_TK_KICK` nlNL:3595). **Opgelost.**

---

## Deel 2: wat nog struikelt

Gesorteerd van groot naar klein. Alles is **GEMETEN als tekst**; of het in het spel klopt weet ik niet.

### Tank

**T1. Welke knop is mijn AoE?** (groot)
- *"Bij een pack begin je met je AoE"* (`PLAYCARD_66_S5` nlNL:1151); *"aanvallen die veel vijanden tegelijk raken (AoE)"*
  (nlNL:2142, 2155).
- De kaart noemt Judgment, Blessed Hammer, Avenger's Shield en Consecration (nlNL:1149-1150), maar zegt bij geen enkele
  "dit raakt veel vijanden". De tab *Meer vijanden* zegt *"Zelfde knoppen"* (`PLAYCARD_66_AOE` nlNL:1152).
- **GEMETEN:** "AoE" staat in nlNL in de Academy/kaart alleen op 1151, 2142 en 2155 (positieve controle: de zoekopdracht
  vond precies die drie, plus vijf regels buiten de Academy).
- Dit is de eerste knop van elke pull. Ik weet niet welke het is.

**T2. Blessing of Protection en Divine Shield op de tank-kaart.** (middel)
- Op de *Blijf leven*-kaart staat Blessing of Protection als *"een grote: druk hem net vóór de hardste klap"*, met
  *"alleen tegen fysieke schade"* (`KeybindRoles_Paladin.lua:76`, geen spec-beperking, dus ook Prot; nlNL:1523, 1524).
- De tab *Groep* zegt over dezelfde knop: *"niet op een tank, vijanden laten hem dan los"* (`GROUP_NOTE_BOP` nlNL:1535).
  Ik bén de tank. Mag ik hem op mezelf drukken of niet?
- Divine Shield: de tank-toolkit waarschuwt *"Zolang hij aan staat, slaan vijanden meestal iemand anders: wees klaar om te
  taunten als hij afloopt."* (nlNL:3615). De kaart zegt alleen *"geeft Forbearance ..."* (`KeybindRoles_Paladin.lua:66`,
  nlNL:1621). Op de kaart mis ik die waarschuwing.
- **AFGELEID:** of Blessing of Protection op Robs kaart staat, hangt af van of hij hem kent (`SurvivalPlan.lua:233-243`).
- Let op: de tab *Groep* lag buiten mijn opdracht. Ik vond de regel via een zoekopdracht op de knopnaam.

**T3. "Op cooldown" kan ik verkeerd lezen.** (middel, raakt beide tracks)
- De woordenlijst zegt: *"Cooldown: de wachttijd voor je een knop weer kunt drukken."* (nlNL:2146).
- Dan lees ik *"[Judgment] en [Blessed Hammer] op cooldown"* (nlNL:1149) als "die zitten in hun wachttijd". Bedoeld is
  vast "druk ze zodra ze weer kunnen".
- Dezelfde kaart zegt het een regel later anders: *"zodra hij klaar is"* (nlNL:1150). Ook *"Druk Divine Toll op
  cooldown"* (nlNL:1203), *"[Swiftmend] op cooldown"* (nlNL:1263), *"bijna op cooldown"* (nlNL:3565).
- **GEMETEN:** "op cooldown" staat ruim 35 keer in nlNL, "zodra hij/ze klaar" ruim 45 keer (vooral op de kaarten).
- Ter vergelijking (**GEMETEN**): de Franse `HEALCD_WHEN_OFTEN` zegt *"dès qu'il est prêt"* (Translations2026.lua:14363).

**T4. Stap 7 tegen het hoofdstuk: vreemden of vrienden? En welke rol?** (middel)
- Stap 7: *"met echte spelers (Group Finder -> ... -> Random Dungeon ...)"* (`ACADEMY_STEP_NORMAL` nlNL:2138).
- Hoofdstuk: *"Start normal met vrienden of guildies."* (`ACADEMY_TANK_DUNGEON_BODY` nlNL:2159). Ladder: *"met mensen die
  je vertrouwt"* (nlNL:2167), heal: *"met geduldige vrienden"* (nlNL:2184).
- Ga ik dan met vrienden via dat pad? Hoe neem ik ze mee? Dat staat nergens.
- **En de rol:** de woordenlijst zegt *"in de Group Finder heet die rol Damage"* (nlNL:2146). Er is dus een rol te kiezen.
  Maar geen stap zegt "kies Tank" of "kies Healer". Als ik dat vergeet, kom ik als DPS binnen? (vraag, niet gecontroleerd)

**T5. De drie grote defensives in de toolkit zijn nog drie gelijke regels.** (klein)
- Ardent Defender, Guardian of Ancient Kings en Sentinel krijgen allemaal dezelfde zin (nlNL:3614; `TankToolkit.lua:105-107`).
- De kaart maakt wél onderscheid: Ardent Defender is *"een kleine: druk hem vaak"* (`KeybindRoles_Paladin.lua:168`),
  de andere twee zijn *"een grote"* (`:69`, `:218`). Geen botsing meer, maar de toolkit helpt niet kiezen.
- En welke houd ik *"achter de hand voor "help""* (nlNL:2155)? Wie roept "help", en waar zie ik dat?

**T6. Shield of the Righteous: timen of altijd aan?** (klein)
- Toolkit: *"Druk 'm vóór grote fysieke klappen — hou 'm omhoog tijdens een pull."* (`TANKKIT_MITDESC_BLOCK` nlNL:3604).
- Kaart: *"Houd hem bijna altijd aan."* (nlNL:1148) en *"houd deze aan, vóór de pull en het hele gevecht"* (nlNL:1517).
- Twee verschillende boodschappen voor één knop. En het pull-hoofdstuk (nlNL:2155) noemt active mitigation helemaal niet.
- Het label *[Block]* (nlNL:3599) staat op een Paladin-knop; de toolkit deelt die zin met de Warrior (`TankToolkit.lua:74`, `:77`).

**T7. Stap 2, Gear: nog geen "hoe".** (klein)
- *"Gear met de hoofdstat van je tank-spec (Protection Paladin en Warrior: ook een schild)"* (nlNL:2129).
- De stat-naam vind ik nu (*"Primary Stat"* onder de spec, nlNL:2142). Maar hoe zie ik of mijn eigen spullen die stat
  hebben? En waar haal ik een schild als ik er geen heb?

**T8. Fysiek of magisch: nog steeds niet hoe je het ziet.** (klein)
- Gebruikt in nlNL:3604, 3606, 3616, 1524, 1608. Niet uitgelegd in *"Zo zie je een grote klap aankomen"* (nlNL:2150).

**T9. Kleine dingen die bleven.**
- *"Draai vijanden van de group af"* (nlNL:2155): waarom, en hoe? Onveranderd sinds ronde 1.
- Ondertitel: *"prep-vinkjes"* en *"Geen parse-guide"* (nlNL:2105). Klasregel: *"Macro's en Consumables staan bij Tools"*
  (nlNL:2109), terwijl geen stap ze nog vraagt.
- Woorden zonder uitleg: *rotation* (2153, 2169), *damage meter* (2153), *chain* (2159), *Repair* (2157), *pug* (2169),
  *elites* en *open world* (2167), *boss-taunt timings* (2161), *portret* (2142, 2150). Engels in de zin: *grote hit*
  (2155), *try* (2165).
- Kaart 66: waar zie ik mijn *Holy Power* (1146-1153)? Wat zijn *charges* (1155)?
- Kaart: *Templar* en *Lightsmith* (1154-1155) staan als losse bolletjes zonder kop (`PlayCardWindow.lua:1054-1056`).
  Dat het twee keuzes zijn, moet ik raden.

**T10. Chat: naar wie?** (klein, raakt beide tracks)
- *"Druk dan Enter om de chat te openen"* (nlNL:2163). Gaat dat naar mijn groep, of naar iedereen om me heen? De kop
  zegt *Party chat* (nlNL:2162), de hint niet. En waar lees ik de naam van de spreuk van de vijand?

### Heal

**H1. "Grote cooldowns" tegen "gebruik hem vaak".** (klein)
- Kop: *"Je grote cooldowns"* (`HEALTOOLKIT_CDS_HEAD` nlNL:3569). Hoofdstuk: *"Gebruik je grote cooldowns op het goede
  moment"*, *"voor de grote momenten ... niet voor willekeurige schrammetjes"* (nlNL:2195-2196).
- De eerste twee regels eronder (Holy): *"Gebruik hem vaak, bijna op cooldown."* (nlNL:3565).
- De zin zelf legt het uit (*"Houd hem alleen een paar seconden vast ..."*). Toch zegt de kop iets anders dan de regel.

**H2. Resto Druid: "je grote heal" bestaat niet.** (klein)
- Triage: *"Veel schade en tijd om te casten: je grote heal."* (nlNL:2174). Druid-heals: HoT, HoT, Snel, Snel, Groep
  (`HealerCooldowns.lua:169-175`). Geen *Groot*.
- Kaart 105 noemt HoTs *"langzame heals"* (nlNL:1261); de toolkit en de woordenlijst zeggen *HoT*. Twee namen.

**H3. `/mh healcds` op een tank-spec: onveranderd.**
- Hoofdstuk: *"Typ /mh healcds voor de cooldowns van jouw spec"* (nlNL:2196). Op een Prot Paladin print het spel
  *"Wissel naar je heal-spec om het te zien."* (nlNL:3550; **GEMETEN** `HealerCooldowns.lua:557-560`).

**H4. Divine Shield heeft twee labels.**
- Tank-toolkit: *[Immuniteit]* (nlNL:3610). Heal-toolkit: *[Defensive]*, net als Divine Protection (nlNL:3626;
  `HealerCooldowns.lua:226`). De regel ernaast zegt *"Een immuniteit mag ook als je bijna dood bent."* (nlNL:3574). Welke
  van de twee is de immuniteit? In de heal-track kan ik het niet zien.

**H5. Stap 5-heal: hoe krijg ik een vriend in mijn groep?**
- *"Eén keer buiten een vriend geheald door op zijn frame te klikken"* (nlNL:2136). Een frame is de balk van iemand *"van
  je groep"* (nlNL:2146). Hoe nodig ik hem uit? Staat nergens.

**H6. Kleine dingen die bleven.**
- *"Licht [Flash of Light] op?"* (nlNL:1198): opdracht of vraag? Onveranderd.
- *"in fire"* (2176), *"in range"* (2178; 2194 zegt wel *"binnen bereik"*), *"fight-timer"* (2180), *"pugs"* en
  *"dungeon-queue"* (2186).
- *"zoals een gif"* (nlNL:2146) tegen *"Poison"* in de dispel-regel (nlNL:3579).
- Triage: *"een instant heal"* (2174). Welke van mijn heals is instant? De toolkit-labels zeggen het niet; de tooltip
  misschien (niet gecontroleerd).

### Beide tracks
- *"de tijdlijn Boss Abilities"* (nlNL:2150): waar op mijn scherm? (klein; er staat wel dat hij standaard aan staat.)

### Wat nu echt goed is
- Het stappenplan is nu een echte route: elke stap zegt waar je klikt.
- De dummy-stap: wat het is, waar het staat, en een MH-pin erbij.
- Eén regel voor alle grote defensives (vooraf drukken, immuniteit mag ook in nood), in de kaart én beide toolkits.
- Triage, labels en de mana-tekst gebruiken nu dezelfde woorden.
- De interrupt-uitleg is eenduidig: terwijl de balk volloopt, een volle balk is te laat.

---

## Deel 3: nieuwe cijfers

- **Tanken: 8/10** (was 7). Het stappenplan brengt me nu stap voor stap van "wissel je spec" naar mijn eerste dungeon
  en de kaart botst niet meer met de Academy, maar ik weet nog niet welke knop mijn AoE is, en de tank-kaart zet
  Blessing of Protection neer terwijl de groep-tab zegt "niet op een tank".
- **Healen: 9/10** (was 8). Wie ik heal, hoe ik klik, wie eerst gaat, welke heal wanneer en wanneer ik mijn cooldowns druk
  is nu helder en zonder botsingen; wat overblijft zijn kleine restjes (Druid zonder "grote heal", `/mh healcds` op een
  tank-spec, "op cooldown").

---

## Deel 4: wat er nog nodig is voor een 10

Ideeën over tekst, geen spelfeiten. Wat in het spel klopt, eerst laten meten (`mh-research`). Rob kiest.

**Tank, voor een 10:**
1. **Noem de AoE-knoppen.** Op de kaart (S5 of *Meer vijanden*) of als eigen rij in de toolkit, met toets, zoals bij
   taunt en interrupt.
2. **Blessing of Protection op de tank-kaart:** één antwoord. Of de regel *"vijanden gaan naar iemand anders"* erbij
   (`SURVIVAL_NOTE_AGGRO` bestaat al, nlNL:1614), of hem van de Prot-kaart af. Zet die waarschuwing ook bij Divine Shield
   op de kaart, zoals in de toolkit.
3. **Stap 7 en het dungeon-hoofdstuk: één advies** (willekeurige groep of met vrienden, en hoe je vrienden meeneemt). En een
   zin "kies de rol Tank (of Healer) voordat je op Find Group drukt", als dat zo werkt.
4. **"Op cooldown"**: in de woordenlijst zetten (*"op cooldown drukken = drukken zodra hij weer kan"*), of overal
   *"zodra hij klaar is"* schrijven.
5. **Toolkit-defensives** klein/groot noemen zoals de kaart, en zeggen welke je achter de hand houdt. Shield of the
   Righteous: één boodschap ("bijna altijd aan").
6. **Gear-stap:** hoe je op je eigen spullen ziet of de stat klopt.
7. **Fysiek of magisch:** één zin hoe je het ziet, of het onderscheid weglaten voor beginners.
8. Opruimen: ondertitel en klasregel, *Draai vijanden af*, de woorden uit T9, een kopje boven de hero-regels op de
   kaart, en "naar je groep" in de chat-hint.

**Heal, voor een 10:**
1. **Triage voor elke spec:** *"je grote heal (als je spec er een heeft)"*, of de Druid-heal die het dichtst in de buurt
   komt dat label geven.
2. **Kop boven de cooldowns** laten passen bij "gebruik hem vaak", of Avenging Wrath en Divine Toll onder een eigen kop.
3. **`/mh healcds`:** in het hoofdstuk erbij zetten dat het pas werkt in je heal-spec.
4. **Divine Shield** in de heal-toolkit ook *[Immuniteit]* noemen.
5. **Stap 5:** hoe je een vriend in je groep krijgt.
6. De kleine woorden uit H6, en *"Licht ... op?"* herschrijven.

---

**Niet gelezen** (buiten de opdracht): de DPS-track, de Codex, de tab *Basis*, de kaart-tabs *Consumables* en *Dispel*.
Van de tab *Groep* las ik alleen de regel over Blessing of Protection (via een zoekopdracht). Van de tab *Blijf leven*
las ik de code en de teksten die Prot Paladin raken, niet het venster zelf. Van kaart 65 (Holy) las ik de regels die de
Prot Paladin in de heal-track tegenkomt.
