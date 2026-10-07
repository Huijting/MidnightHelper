# Tanken en healen, derde lezing door iemand die nooit speelde (7 okt 2026, avond)

Ronde 1: `ROLE_SWITCH_REVIEW_NEWCOMER_2026-10-07.md` (tanken 3, healen 5).
Ronde 2: `ROLE_SWITCH_REREAD_NEWCOMER_2026-10-07.md` (tanken 6, healen 7).
Daarna is de Role Academy weer aangepast. Ik las hem opnieuw, in het Nederlands, in de volgorde van het scherm.

**Wie las dit.** Een lezer die World of Warcraft nooit speelde. Geen eigen spelkennis, niets online opgezocht.
Ik weet alleen wat de teksten zelf uitleggen.

**Hoe betrouwbaar is dit rapport.**
- Wat een tekst zegt en op welke regel: **GEMETEN** in de bestanden op 7 okt 2026.
- De volgorde op het scherm: **GEMETEN** in `Modules/RoleAcademy.lua`.
- Welke spreuken een Prot Paladin ziet: **GEMETEN** in de tabellen (`TankToolkit.lua`, `HealerCooldowns.lua`,
  `KeybindRoles_Paladin.lua`). Of ze écht op zijn scherm staan, hangt af van zijn talenten: **AFGELEID**.
- "Dit snap ik niet": **mijn oordeel als beginner**, geen meting.
- Of de spelinformatie klopt: **NIET gecontroleerd**. Dat mocht ik niet.
- Alle teksten stonden in `Locales/nlNL.lua`. Ik hoefde niet naar `enUS.lua` terug te vallen (**GEMETEN**: elke key uit
  `BASICS_KEYS`, het stappenplan, `BASICS_AFTER_KEYS`, de toolkits en `SECTION_KEYS` heeft een regel in nlNL, zie hieronder).

---

## Het korte antwoord

**Weer beter.** De drie grootste winsten:
- De tank-toolkit noemt nu **je taunt en je interrupt, mét de toets** waar ze op staan.
- Er is een nieuw hoofdstuk **"Zo zie je een grote klap aankomen"**, in beide tracks.
- De oude checklist is nu een **stappenplan in de leestekst**, ná "Wat is een tank/healer?" en de woordenlijst.

Drie botsingen uit ronde 2 zijn weg (Druid stap 3, Divine Toll, de drie "bewaar"-restjes).

Wat nog wringt:
- **De kaart en de toolkit zeggen op drie plekken iets anders**: pull met taunt of niet; grote defensive bewaren of
  vooraf drukken; Avenging Wrath en Divine Toll meteen of wachten.
- **Het stappenplan zegt wát, maar vaak niet hóé**: een venster openen, een spreuk op een toets zetten, een dummy vinden.
- **Het label "Zuinig" staat op de grote heal**, en de uitleg ernaast zegt dat het per spec verschilt.

**Nieuwe cijfers: tanken 7/10, healen 8/10.**

---

## Wat het scherm nu toont, in deze volgorde (GEMETEN)

1. Kop, ondertitel `ACADEMY_SUBTITLE` (nlNL:2105), drie trackknoppen, klasregel `ACADEMY_CLASS_FMT` (nlNL:2109).
   Het oude vaste blok is verborgen (`RoleAcademy.lua:1128`); het leesvak begint direct onder de klasregel (`:1130`).
2. Basis (`RoleAcademy.lua:53-62`): *Wat is een tank?* / *Wat is een healer?* → *Woorden die je gaat horen*.
3. Stappenplan *Rol wisselen, stap voor stap* (`:943`, getekend in `:248-329`): 7 vinkjes + een hint.
4. Basis-erna (`:64-77`):
   - **Tank:** Tank-mindset → Zo zie je een grote klap aankomen → Angst-ladder.
   - **Heal:** Heal-mindset → Triage → Zo zie je een grote klap aankomen → Angst-ladder.
5. Knop *"Zo speel je <spec> >"* en de toolkit (`:949-959`).
6. De rest van de hoofdstukken (`SECTION_KEYS`, `:79-99`).

---

## Deel 1: de top-5 uit ronde 2

| # | Punt uit ronde 2 | Nu | Waar (key, regel) |
|---|---|---|---|
| 1 | Uitleg vóór gebruik: woordenlijst naar voren, checklist ná de basis | **opgelost** (klein restje) | Woordenlijst is tekst 2: `RoleAcademy.lua:56`, `:60`. Stappenplan na de basis: `:942-944`. Vaste blok weg: `:1128`. |
| 2 | Eén tekst "zo zie je dat er iets groots aankomt" | **opgelost** | `ACADEMY_SEE_BODY` nlNL:2150, in beide tracks (`RoleAcademy.lua:68`, `:74`). De interrupt-regel verwijst ernaar: `TANKKIT_TK_KICK` nlNL:3593. |
| 3 | Taunt en interrupt in de tank-toolkit; pull-start eenduidig | **half** | Taunt + interrupt: opgelost (`TANKKIT_TK_*` nlNL:3591-3594; `RoleAcademy.lua:663-679`). Pull-start: de kaart zegt nog iets anders (zie hieronder). |
| 4 | Heal-botsingen weghalen | **grotendeels** | 4 van de 5 deelpunten opgelost; "grote vs zuinige heal" half. |
| 5 | Woordenlijst aanvullen; chat-stap afmaken | **half** | 7 nieuwe woorden in `ACADEMY_WORDS_BODY` nlNL:2146. Chat-stap onveranderd. |

**Telling: 2 opgelost, 1 grotendeels, 2 half, 0 niet.**

### Punt 1: uitleg vóór gebruik
- Opgelost: ik lees nu eerst wat een tank of healer is, dan de woorden, dan pas de vinkjes.
- Restje 1: stap 6 noemt *"follower dungeon"* (`ACADEMY_STEP_FOLLOWER` nlNL:2137). Wat dat is, staat pas in de
  Angst-ladder (nlNL:2167, 2184). Die komt ná het stappenplan (`RoleAcademy.lua:944`).
- Restje 2: *"training dummy"* (`ACADEMY_STEP_TANK_DUMMY` nlNL:2135) wordt nergens uitgelegd.

### Punt 2: zo zie je een grote klap aankomen
- Opgelost. Boss Warnings met pad, de balk onder de health-balk, de gloed, en Shift+J of `/mh bosswin` om vooraf te lezen.
  (`/mh bosswin` bestaat: **GEMETEN** `Core.lua:3210`.)
- Restje: hoe ik zie of een klap **fysiek of magisch** is, staat er niet. De toolkit maakt dat onderscheid wel
  (`TANKKIT_MITDESC_BLOCK` nlNL:3602 "fysieke klappen", `TANKKIT_CDDESC_MAGIC` nlNL:3614 "magische schade").
- Zie ook deel 2, punt C1: de zin "Dát is je moment" kan ik verkeerd lezen.

### Punt 3: taunt, interrupt, pull-start
- **Opgelost:** de toolkit toont *"Je taunt en je interrupt"*, met per knop de toets, of *"(nog niet op een toets)"*.
  Voor Prot Paladin: Hand of Reckoning en Rebuke (`TankToolkit.lua:144`). Stap 3 van het plan vinkt zichzelf af als
  beide op een toets staan (`RoleAcademy.lua:182-191`). Dit is precies wat ik vroeg.
- **Niet opgelost: hoe begin ik een pull?** De Academy is nu eenduidig:
  - `ACADEMY_TANK_WHAT_BODY` (nlNL:2142): *"Een hele pack pak je met je aanvallen die veel vijanden tegelijk raken (AoE), niet met taunt."*
  - `ACADEMY_TANK_PULL_BODY` (nlNL:2155): *"Taunt alleen de vijand die naar iemand anders loopt."*
  - Maar de kaart zegt nog: `PLAYCARD_66_S5` (nlNL:1151) *"Trek met Hand of Reckoning"*. Dat is de taunt.
  Begin ik nu met mijn taunt of niet?

### Punt 4: heal-botsingen
| Deelpunt | Nu | Waar |
|---|---|---|
| Druid stap 3 tegen de grootste fout | **opgelost** | S3 *"Iemand bijna dood: Regrowth mag altijd"* (nlNL:1264); fout is nu *"je gewone heal maken zonder 5 Rejuvenation"* (nlNL:1267). |
| Divine Toll tegen "vijand gekozen = heal op jezelf" | **opgelost** | `ACADEMY_HEAL_WHAT_BODY` (nlNL:2144) noemt Holy Shock en Divine Toll als uitzondering. |
| "Je kaart zegt welke heal zuinig is" | **opgelost** | `ACADEMY_HEAL_MANA_BODY` (nlNL:2192) wijst nu naar de tooltip. (Toolkit-regels tonen de tooltip bij muis erover: **GEMETEN** `RoleAcademy.lua:476-483`. Wat erin staat: niet gecontroleerd.) |
| Drie "bewaar"-restjes | **opgelost** | `HEALCD_TITLE` (nlNL:3549) "gebruik ze op het goede moment"; `HEALCD_WHEN_RAID` (nlNL:3557) zonder "bewaar"; `ACADEMY_TANK_WIPE_BODY` (nlNL:2157) "Drukte ik een defensive vóór de grote klap?". |
| Grote heal tegen snelle heal | **half** | Triage is nu helder (nlNL:2174): bijna dood = snel; veel schade = groot; rustig = zuinig. Maar het label "Zuinig" botst (deel 2, punt A4). |

Let op: buiten de Academy staat nog één "bewaar": `HEALLENS_RAIDCD_FMT` (nlNL:3586), in het baas-venster. Niet erg,
wel om te weten. En op de kaart staat er een nieuwe (deel 2, punt A1).

### Punt 5: woordenlijst en chat-stap
- **Erbij gekomen** (nlNL:2146): Trash, Boss, DPS, Spec, HP, Buff, Normal/Heroic/Mythic, LFR, M+. Fijn.
- **Nog niet in de lijst**, wel in de tracks: *overheal* (2172, 2198), *troep* (2194, 2198), *cast* (2146, 2174, 2194),
  *stun* (2146), *raid* (2146, 2161, 2180), *instance* (2167, 2184), *HoT* (3644), *bereik/range* (2178, 2194),
  *rotation/rotatie* (2153, 2169, 2186), *chain* (2159), *repair* (2157), *pug* (2169, 2186), *queue* (2186),
  *Keystone* (2146), *Gear* (2129, 2142).
  (Macro, flask/pot en mouseover zijn minder erg geworden: de tank- en heal-stappen noemen ze niet meer.)
- **Chat-stap onveranderd:** `ACADEMY_CHAT_HINT` (nlNL:2163) zegt nog steeds alleen "Ctrl+C". Hoe open ik party chat,
  hoe plak ik, en wat zet ik op de plek van *"[spell]"* (`ACADEMY_TANK_CHAT_BODY` nlNL:2165)?

---

## Deel 2: nieuwe struikelpunten

### A. Tegenstrijdigheden (GEMETEN als tekst; of het in het spel klopt weet ik niet)

**A1. Grote defensive: bewaren tot je laag staat, of vooraf drukken? (Prot Paladin)**
- Tank-toolkit: Ardent Defender, Guardian of Ancient Kings en Sentinel krijgen alle drie
  *"Druk 'm vóór een grote klap ..., niet pas als je health al laag is."* (`TANKKIT_CDDESC_DR` nlNL:3612; `TankToolkit.lua:105-107`).
- Kaart, tab *Blijf leven*: Guardian of Ancient Kings en Sentinel staan daar als
  *"een grote: bewaar hem voor als je health snel zakt"* (`SURVIVAL_STEP_BIG` nlNL:1523).
  **GEMETEN** in de code: `KeybindRoles_Paladin.lua:69` en `:218` (survival = "big"), `SurvivalPlan.lua:122`,
  getoond in `PlayCardWindow.lua:735-739`.
- Het stappenplan stuurt me naar die kaart (`ACADEMY_STEP_CARD` nlNL:2134). Dus ik lees allebei.
- **AFGELEID:** of beide regels op Robs scherm staan, hangt af van zijn talenten.

**A2. Divine Shield krijgt drie verschillende uitleggen.**
- Tank-toolkit: *"Paniekknop — overleeft een dodelijke klap. ..."* (`TANKKIT_CDDESC_IMMUNITY` nlNL:3613).
- Heal-toolkit (Holy Paladin): *"Druk hem net vóór een grote klap op jou, niet erna."* (`HEALTOOLKIT_DEF_DESC` nlNL:3572;
  `HealerCooldowns.lua:223`).
- Kaart *Blijf leven*: *"bewaar hem voor als je health snel zakt"* (nlNL:1523; `KeybindRoles_Paladin.lua:66`).
Vooraf, in paniek, of als ik zak?

**A3. Avenging Wrath en Divine Toll: meteen of wachten? (Holy Paladin; dit ziet een Prot Paladin in de heal-track)**
- Kaart: *"zodra ze klaar zijn"* (`PLAYCARD_65_S1` nlNL:1197) en *"Druk Divine Toll op cooldown"* (`PLAYCARD_65_HERO1` nlNL:1203).
- Toolkit: *"Zet in tijdens zware, aanhoudende schade"* (`HEALCD_WHEN_FLOW` nlNL:3563), onder de kop
  *"Je cooldowns (voor de grote momenten)"* (nlNL:3567). **GEMETEN** dat beide spells die regel krijgen:
  `HealerCooldowns.lua:102-103`.

**A4. Het label "Zuinig" op de grote heal.**
- Label: *"Zuinig"* (`HEALCORE_TAG_BIG` nlNL:3643). In het Engels ook: *"Efficient"* (enUS:4139).
- Uitleg ernaast: *"Of hij zuinig is, verschilt per spec."* (`HEALCORE_DESC_BIG` nlNL:3650; enUS:4146).
  Het label zegt dus "zuinig" en de zin ernaast zegt "misschien".
- Mana: *"bij de ene is de trage heal de zuinige, bij de andere de snelle"* (nlNL:2192).
- Triage: *"Veel schade en tijd om te casten: je grote heal. Rustig: je zuinige heal."* (nlNL:2174).
  - Holy Paladin: Holy Light is zowel "de grote" als "[Zuinig]" (`HealerCooldowns.lua:161`). Twee situaties, één knop?
  - Resto Druid: geen enkele heal heeft het label Zuinig (`HealerCooldowns.lua:166-172`: HoT, Snel, Groep).
    Dus "je grote heal" en "je zuinige heal" wijzen bij een Druid nergens naar.

**A5. Mijn eerste dungeon: follower of normal?**
- Titels: *"Je eerste dungeon (normal)"* (`ACADEMY_TANK_DUNGEON_TITLE` nlNL:2158, `ACADEMY_HEAL_DUNGEON_TITLE` nlNL:2177).
- Stappenplan en ladder: eerst een follower dungeon, dán normal (nlNL:2137-2138, 2167, 2184).

**A6. Normal dungeon met wie? (klein)**
- Stap 7: *"met echte spelers"* (nlNL:2138). Ladder: *"met mensen die je vertrouwt"* (2167) of *"geduldige vrienden"* (2184).
  Hoofdstuk: *"met vrienden of guildies"* (2159). Mag ik me aanmelden bij vreemden, of liever niet?

### B. Stappen zonder "hoe" (vooral het stappenplan)
- **Talents & Spellbook:** hoe open ik dat venster? (nlNL:2128, 2131, 2142, 2144). **GEMETEN:** dat pad staat in nlNL
  alleen in deze vier regels; nergens staat hoe je het opent. (Positieve controle: de zoekopdracht vond deze vier.)
- **Een spreuk op een toets zetten:** stap 3 (`ACADEMY_STEP_TANK_KEYS` nlNL:2130, `_HEAL_KEYS` nlNL:2133) en de toolkit
  (*"(nog niet op een toets)"*, nlNL:3594) vragen het, maar niets in de Academy zegt hoe.
  (Elders in MH staat het wel: `MACROS_COPY_SUFFIX` nlNL:2294, "sleep het ... icoon naar een plek op je actiebalk".)
- **Training dummy:** wat is het, en waar staat er een? De plek-hint *"in Silvermoon staan ze"* zat in
  `ACADEMY_PREF_TANK_TAUNT` (nlNL:2117). **GEMETEN:** de tank-track toont die key niet meer (`RoleAcademy.lua:22-30`).
  Ook mijn vraag: kan ik een dummy interrupten? Cast een dummy iets? (Niet gecontroleerd.)
- **Group Finder:** hoe open ik die? (nlNL:2137, 2146, 2167).
- **Stap 7** (normal dungeon, nlNL:2138) heeft geen pad. Stap 6 heeft er wel een.
- **Waar typ ik `/mh ...`?** Gevraagd in nlNL:2109, 2134, 2150, 2196. Geen Academy-tekst zegt "in het chatvenster".
- **`/mh healcds` op een tank-spec:** het hoofdstuk zegt *"voor de cooldowns van jouw spec"* (nlNL:2196). Op een Prot
  Paladin print het spel *"Wissel naar je heal-spec om het te zien"* (`HEALCD_NOT_HEALER` nlNL:3550;
  **GEMETEN** `HealerCooldowns.lua:554-557`). Voor wie de heal-track leest vóór hij wisselt, voelt dat als een fout.
- **Kaart: typen of klikken?** Stap 4 zegt *"(/mh play)"* (nlNL:2134). Verderop staat ook de knop *"Zo speel je ... >"*
  (nlNL:1095). Welke moet ik gebruiken? (klein)

### C. Woorden en zinnen
1. **"Dát is je moment"** (`ACADEMY_SEE_BODY` nlNL:2150): *"Is de balk vol, dan komt de spreuk. Dát is je moment om te
   interrupten ..."*. Ik lees: wacht tot de balk vol is, dan interrupten. Maar de woordenlijst zegt dat een interrupt werkt
   *"terwijl hij hem cast"* (nlNL:2146). **AFGELEID:** bedoeld is "terwijl de balk volloopt". In het Engels staat hetzelfde (enUS:2226).
2. **SEE, verder:** *"de tijdlijn Boss Abilities"*: waar op mijn scherm? *"als hij je doel is"*: hoe maak ik een vijand mijn doel?
3. **Gear** (nlNL:2129, 2142): *"Gear met de hoofdstat van je tank-spec"*. Welke stat is dat bij een tank? De heal-tekst
   noemt Intellect (nlNL:2144), de tank-tekst noemt niets. En *Gear* zelf staat niet in de woordenlijst.
4. **Drie gelijke regels:** Ardent Defender, Guardian of Ancient Kings en Sentinel hebben precies dezelfde zin
   (nlNL:3612). Welke eerst? Welke houd ik *"achter de hand voor help"* (nlNL:2155)?
5. **Twee namen voor hetzelfde soort knop:** in de tank-toolkit heet een defensive *[Schadereductie]* (nlNL:3607), in de
   heal-toolkit *[Defensive]* (`DPSKIT_TAG_DEF` nlNL:3624). Nog meer Engels als label: *[Block]* (3597), *personal*
   (3571, 3595), *Extern*, *Utility* (3554-3555), *Channel* (3647).
6. **"hou deze omhoog"** (`TANKKIT_MIT_HEAD` nlNL:3590, nlNL:3602) blijft beeldspraak. Met de woordenlijst raad ik het nu wel.
7. **"Draai vijanden van de group af"** (nlNL:2155): waarom, en hoe draai ik een vijand? Onveranderd sinds ronde 1.
8. **Gif of Poison?** De woordenlijst zegt *"Debuff: ... zoals een gif"* (nlNL:2146). De dispel-regel zegt *"Poison"*
   (nlNL:3577). Is dat hetzelfde?
9. **"instant heal"** (Triage, nlNL:2174): welke van mijn heals is instant? De toolkit zegt het niet.
10. **Oude restjes bovenaan:** de ondertitel noemt nog *"prep-vinkjes"* en *"parse-guide"* (nlNL:2105). De klasregel
    noemt *Macro's en Consumables* (nlNL:2109), terwijl geen tank- of heal-stap ze nog vraagt.
11. **Kleinigheden die bleven:** *"Licht Flash of Light op?"* (nlNL:1198); Engels midden in de zin: *"in fire"* (2176),
    *"grote hit"* (2155), *"try"* (2165); drie woorden voor hetzelfde: *health*, *HP*, *levenspunten*.

### D. Wat nu echt goed is
- *"Je taunt en je interrupt"* met de toets erachter. Daar kan ik direct mee oefenen.
- *"Zo zie je een grote klap aankomen"*: kort, met een pad in het menu, en met een eigen MH-commando.
- Triage met drie situaties (bijna dood / veel schade / rustig).
- *"Spreuken die ook vijanden kunnen raken ... gaan dan naar de vijand"*: lost de Divine Toll-vraag op.
- Het stappenplan als route van "wissel je spec" naar "eerste normal dungeon". Dat is de vorm die ik miste.

---

## Deel 3: nieuwe cijfers

- **Tanken: 7/10** (was 6). Nu weet ik welke knop mijn taunt en mijn interrupt is en hoe ik een grote klap zie aankomen,
  maar de kaart zegt bij de pull en bij de grote defensives iets anders dan de Academy, en het stappenplan zegt niet hoe ik
  een spreuk op een toets zet of waar een dummy staat.
- **Healen: 8/10** (was 7). Wie ik heal, hoe ik klik, wie eerst gaat en hoe ik een klap zie aankomen is nu helder en
  bijna zonder botsingen; wat overblijft is het label "Zuinig" en de vraag of ik Avenging Wrath en Divine Toll meteen of
  later druk.

---

## Deel 4: top-3 wat nu het meest zou helpen

Ideeën over tekst en volgorde, geen spelfeiten. Rob kiest.

1. **Laat de kaart en de Academy hetzelfde zeggen.** Drie plekken:
   pull met taunt (`PLAYCARD_66_S5` tegen nlNL:2142/2155);
   grote defensives "bewaar tot je zakt" (`SURVIVAL_STEP_BIG` op de kaart) tegen "druk vooraf" (`TANKKIT_CDDESC_DR`,
   `HEALTOOLKIT_DEF_DESC`);
   Avenging Wrath/Divine Toll "zodra klaar" (`PLAYCARD_65_S1`) tegen "tijdens zware schade" (`HEALCD_WHEN_FLOW`).
   Wat in het spel klopt, eerst laten meten (`mh-research`).
2. **Zet bij elke stap van het stappenplan het "hoe".** Hoe open je Talents & Spellbook en de Group Finder; hoe zet je een
   spreuk op een toets (ook als de toolkit "(nog niet op een toets)" zegt); waar staat een training dummy (de oude
   Silvermoon-hint terug); een pad voor stap 7; en één zin "typ `/mh ...` in het chatvenster".
   En zet "follower dungeon" kort uitgelegd in stap 6 zelf, of de ladder vóór het plan.
3. **Haal "Zuinig" van de grote heal af** (bijvoorbeeld *Groot* of *Traag*), zodat Triage, Mana en de toolkit hetzelfde
   zeggen. Vul de woordenlijst aan met *overheal, troep, cast, raid, instance, HoT, Gear*. Maak de chat-stap af (party
   chat openen, plakken, wat op "[spell]" komt). En maak de zin "Dát is je moment" eenduidig: *terwijl* de balk volloopt.

---

**Niet gelezen** (buiten de opdracht): de DPS-track, de Codex, de tab *Basis*, de kaart-tabs *Groep*, *Consumables* en
*Dispel*. Van de kaart-tab *Blijf leven* las ik alleen de code en de teksten die Prot Paladin raken, niet het venster zelf.
