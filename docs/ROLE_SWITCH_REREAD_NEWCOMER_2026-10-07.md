# Tanken en healen, opnieuw gelezen door iemand die nooit speelde (7 okt 2026, middag)

Dit is de tweede lezing. De eerste staat in `ROLE_SWITCH_REVIEW_NEWCOMER_2026-10-07.md` (tanken 3/10, healen 5/10).
Daarna is de Role Academy herschreven. Ik las hem opnieuw.

**Wie las dit.** Een lezer die World of Warcraft nooit speelde. Geen eigen spelkennis, niets online opgezocht.
Ik weet alleen wat de teksten zelf uitleggen.

**Hoe betrouwbaar is dit rapport.**
- Wat een tekst zegt en op welke regel: **GEMETEN** in de bestanden op 7 okt 2026.
- De volgorde op het scherm: **GEMETEN** in `Modules/RoleAcademy.lua` en `Modules/PlayCardWindow.lua`.
- "Dit snap ik niet": **mijn oordeel als beginner**, geen meting.
- Of de spelinformatie klopt (6 seconden, 8 seconden, welke heal zuinig is): **NIET gecontroleerd**. Dat mocht ik niet.
- Alle teksten bestaan in `Locales/nlNL.lua`. Ik hoefde nergens naar `enUS.lua` terug te vallen (**GEMETEN**: elke
  key uit `BASICS_KEYS` en `SECTION_KEYS` staat in nlNL).

---

## Het korte antwoord

**Veel beter.** Bovenaan staat nu *"Wat is een tank?"* en *"Wat is een healer?"*, en er is een woordenlijst.
De beste zinnen uit de eerste lezing staan nu wél in de Academy: "een vijand die jou aanvalt heet aggro"
en "klik op de balk van die persoon en druk dan je heal".

Wat nog wringt:
- De **checklist staat nog steeds bovenaan**, vóór alle uitleg. Die zit in een vast blok boven het scrollvak
  (`RoleAcademy.lua:1014-1047`, scrollvak hangt eronder op `:1047`). Dus het eerste wat ik lees is nog steeds
  "Interrupt-macro", "Flask / pot", "taunt-toets".
- De **woordenlijst komt als laatste** van de basisteksten (`RoleAcademy.lua:45` en `:52`). Ik lees "pack",
  "debuff" en "Delves" dus vóór de uitleg ervan.
- **Hoe ik zie dat er een grote klap of een gevaarlijke spell aankomt**, staat nergens. Toch zeggen zes teksten
  "druk vóór de grote klap".
- Bij healen spreken een paar teksten elkaar nog tegen (zie deel 3).

**Nieuwe cijfers: tanken 6/10, healen 7/10.**

---

## Wat het scherm nu toont, in deze volgorde (GEMETEN)

1. Kop, ondertitel `ACADEMY_SUBTITLE` (nlNL:2105), drie trackknoppen, klasregel `ACADEMY_CLASS_FMT` (nlNL:2109).
2. Vast blok: *Pre-flight checklist* met 4 vinkjes en de hint (nlNL:2112-2121).
3. Scrollvak, eerst de basis (`BASICS_KEYS`, `RoleAcademy.lua:40-54`):
   - **Tank:** Wat is een tank? → Tank-mindset → Angst-ladder → Woorden die je gaat horen.
   - **Heal:** Wat is een healer? → Heal-mindset → Triage → Angst-ladder → Woorden die je gaat horen.
4. Knop *"Zo speel je <spec> >"* (`RoleAcademy.lua:872`, `:876`), dan de toolkit (`:874`, `:878`).
5. De rest van de hoofdstukken (`SECTION_KEYS`, `RoleAcademy.lua:56-76`).
   - **Tank:** Tijdens een pull, Als het misgaat, Je eerste dungeon, Raids en LFR, Party chat, Ook heal of DPS leren?
   - **Heal:** Mana, Waar je gaat staan, Grote cooldowns, Beginnersfouten, Als het misgaat, Iemand verliezen mag,
     Eerste dungeon, Raids en LFR, Party chat, Ook tank of DPS leren?

---

## Deel 1: de 20 vragen uit de eerste lezing

| # | Vraag (kort) | Nu? | Waar |
|---|---|---|---|
| 1 | Wat is een tank, bovenaan? | **ja** | `ACADEMY_TANK_WHAT_BODY` nlNL:2129, eerste hoofdstuk (`RoleAcademy.lua:42`). Wel: checklist staat er nog boven. |
| 2 | Wat is threat? Is taunt één knop, welke bij mij? | **half** | Threat en taunt uitgelegd (nlNL:2129, 2133). Wélke knop: niet in de Academy, niet in de toolkit (**GEMETEN**: `TankToolkit.lua:73-109` heeft voor spec 66 geen taunt). Alleen de kaart, stap S5 (nlNL:1151). |
| 3 | Wat is een pull, hoe begin ik, wanneer klaar? | **half** | "Pull: een gevecht met een pack beginnen" (nlNL:2133). Hoe begin ik: alleen de kaart zegt "Trek met [taunt-knop]" (nlNL:1151). Wanneer klaar: staat nergens. |
| 4 | Pack, chain, wipe? | **half** | Pack en wipe in de woordenlijst (nlNL:2133). "Chain" niet (staat nog in nlNL:2142). |
| 5 | Cooldown, en is "(1.5 min)" duur of wachttijd? | **ja** | Woordenlijst: het is de wachttijd (nlNL:2133). |
| 6 | Bewaren of drukken? | **grotendeels** | Koppen zeggen nu "voor de grote momenten" (nlNL:3550) en "druk vóór de grote klap" (nlNL:3574). Hoofdstuk heet "Gebruik je grote cooldowns op het goede moment" (nlNL:2178). Restjes: zie deel 3. |
| 7 | Hoe zie ik iets gevaarlijks aankomen, welke knop stopt het? | **half** | Interrupt is uitgelegd (nlNL:2133). Hoe ik het zie en welke knop het is: nee. |
| 8 | Active mitigation, "omhoog houden", "aanhouden"? | **half** | Uitgelegd: "een tankknop die je steeds opnieuw drukt" (nlNL:2133). Daarmee raad ik nu wat "hou deze omhoog" (nlNL:3573) betekent. Gezegd wordt het niet. |
| 9 | Debuff? Hoe zie ik Poison of Magic? | **half** | Debuff en dispel uitgelegd (nlNL:2133). Hoe je het ziet: niet in de Academy. Wel in het kaart-venster, tab Dispel (nlNL:1112). |
| 10 | Frames, waar op mijn scherm? | **ja** | nlNL:2131 (met het pad via Edit Mode) en nlNL:2133. |
| 11 | Wat is "Oom"? | **ja** | Nu "OOM: out of mana" (nlNL:2133, 2175, 2161). |
| 12 | Welke heal is goedkoop? | **half** | Mana-hoofdstuk: verschilt per spec, "je kaart zegt het" (nlNL:2175). Maar zie deel 3: de kaart zegt het niet altijd. |
| 13 | Waar zijn "Guides" en "In groups"? | **ja** | Verwijzingen gaan nu naar de kamer Tools en `/mh play -> Blijf leven` (nlNL:2109, 2113, 2115, 2119). **GEMETEN** dat die bestaan: kamer *Tools* (nlNL:218), tab *Blijf leven* (`PlayCardWindow.lua:902`), `/mh play` (`Core.lua:3250`). |
| 14 | Normal, heroic, Mythic, M+, LFR? | **nee** | Niet in de woordenlijst. Alleen "Follower dungeon" is nu uitgelegd (nlNL:2150). |
| 15 | Hoe wissel ik als healer naar een vijand en terug? | **half** | "Een vijand gekozen? Dan komt de heal op jezelf" (nlNL:2131). "Klik op de vijand" (nlNL:692, kaart). Ik raad: klikken. Gezegd wordt het niet. |
| 16 | Templar, Lightsmith, Wildstalker, Keeper of the Grove? | **nee** | Nog steeds onder een bolletje zonder kop (`PlayCardWindow.lua:1054-1056`). |
| 17 | Hoe plak ik een chatregel in party chat? | **nee** | `ACADEMY_CHAT_HINT` (nlNL:2146) is onveranderd. |
| 18 | Wat doe ik als een vijand mij aanvalt als healer? | **half** | Niet direct. Ik kan het nu afleiden: triage "1. Jij" (nlNL:2157), je defensive "vóór een grote klap op jou" (nlNL:3555), en de tank taunt (nlNL:2129). |
| 19 | Hoe zet ik een dungeon op Mythic? | **nee** | Niet in de Academy. (Die vraag kwam uit de Codex; die las ik niet opnieuw.) |
| 20 | "Meer vijanden" boven een healer-blok? | **ja** | Nieuwe kop "Veel mensen tegelijk geraakt:" (nlNL:1132), alleen voor healers (`PlayCardWindow.lua:1052`). |

**Telling: 6 ja, 10 half (waarvan 1 grotendeels), 4 nee.**

---

## Deel 2: woorden en stappen die ik nog niet snap

In schermvolgorde. Woorden die nu in de woordenlijst staan, noem ik niet meer.

### Bovenaan (vast blok, vóór alle uitleg)
- `ACADEMY_SUBTITLE` (nlNL:2105): *DPS*, *groups*, *parse-guide*, *prep-vinkjes*. **DPS** staat nergens uitgelegd,
  ook niet in de woordenlijst (nlNL:2133).
- `ACADEMY_CLASS_FMT` (nlNL:2109): *Macro's*, *Consumables*, *spec*. Waar typ ik `/mh play`? Dat het in het
  chatvenster moet, staat er niet.
- `ACADEMY_PREF_TANK_INTERRUPT` (nlNL:2114): *Interrupt-macro*, *bar*. De woordenlijst zegt dat een interrupt een
  **knop** is. Hier is het een **macro**. Wat is het verschil?
- `ACADEMY_PREF_TANK_CONSUMABLES` (nlNL:2116), `_HEAL_CONSUMABLES` (nlNL:2120): *Flask*, *pot*, *Mana pot*.
- `ACADEMY_PREF_TANK_TAUNT` (nlNL:2117): *training dummy*. Wat is dat, en **waar** in Silvermoon? (**GEMETEN**:
  "dummy" staat in nlNL alleen in drie Academy-regels, 2117, 2125, 2199; geen route of plek.)
- `ACADEMY_PREF_HEAL_MACROS` (nlNL:2118): *Mouseover*, *focus*. Klikken op een frame snap ik nu. Maar "mouseover"
  klinkt nog steeds als zweven met de muis.
- Kleinigheid: de vinkjes zeggen "Macros-tab", de tab heet "Macro's" (nlNL:2084).

### Wat is een tank? (`ACADEMY_TANK_WHAT_BODY`, nlNL:2129)
- *"op wie hij het **boost** is"*: ik las eerst het Engelse woord "boost". "Het meest boos" leest makkelijker.
- *Gear*, *hoofdstat*, *Primary Stat*: wat doe ik ermee? De zin "Gear: de hoofdstat van je tank-spec" heeft geen
  werkwoord. Moet ik spullen met die stat kiezen?
- *Spec*, *Talents & Spellbook*: hoe open ik dat venster? *Loot spec*, *buit*.

### Tank-mindset (`ACADEMY_TANK_INTRO_BODY`, nlNL:2136)
- *run*, *damage meter*, *rotation*, *group*. "Zeg pulls hardop": in een microfoon of in de chat?

### Angst-ladder tank / heal (nlNL:2150, 2167)
- *Open world elites*, *instance*, *NPC's*, *Heroic*, *LFR*.
- *Group Finder*: hoe open ik die? De rest van het pad staat er wel.

### Woordenlijst (`ACADEMY_WORDS_BODY`, nlNL:2133)
Goed lijstje. Er gebruikt zelf nog twee onbekende woorden: *stun* (bij CC) en *cast* (bij interrupt).
**Woorden die in de tracks staan maar níét in de lijst:** DPS, spec, HP, buff/buffen, HoT, range/bereik, raid,
instance, normal/heroic/LFR/M+, pug, queue, macro, flask/pot, mouseover, troep, repair, chain, rotation.

### Tank-toolkit (nlNL:3573-3595)
- *personal* (in "personal defensives", nlNL:3574).
- *fysieke* klap (nlNL:3581) tegenover *magische* schade (nlNL:3593): hoe zie ik welke soort eraan komt?
- "Druk 'm vóór een grote klap" (nlNL:3591): **hoe weet ik dat er een grote klap aankomt?**
- *Poison*, *Disease* (bij dispel): welke soorten bestaan er, en hoe zie ik ze?

### Healer-toolkit (nlNL:3549-3557, 3621-3634, 3535-3546)
- *tikken* (HoT, 3630), *single-target* en *dipt* (3628), *Gechannelde* (3633), *allies* en *proactief* (3634).
- *Extern* (3537) en *Utility* (3538) als label: wat betekent dat?
- *raid-brede* klap en *schampschade* (3540).
- "Zet 'm neer net vóór de schade binnenkomt" (3632): zelfde vraag, hoe zie ik dat?
- De nieuwe uitleg bij de defensive (3555) is goed: "daarmee krijg JIJ minder schade".

### Tank-hoofdstukken
- `ACADEMY_TANK_PULL_BODY` (nlNL:2138): stap 1 is nu helder. Stap 2 *"Draai vijanden van de group af"*: waarom,
  en hoe draai ik een vijand? *ability*, *spammen*.
- `ACADEMY_TANK_WIPE_BODY` (nlNL:2140): "te ver vooruit" snap ik nu (de groep volgt mij, nlNL:2129).
  *Repair* en waarom *eten*: nog niet.
- `ACADEMY_TANK_DUNGEON_BODY` (nlNL:2142): *normal*, *guildies*, *chain*. Hoe zie ik de mana van de healer?
- `ACADEMY_TANK_RAID_BODY` (nlNL:2144): *boss-taunt timings*, *Mythic*, *heroic*. (Voor later, niet erg.)
- `ACADEMY_TANK_CHAT_BODY` + `ACADEMY_CHAT_HINT` (nlNL:2146-2148): na Ctrl+C, hoe plak ik? Wat zet ik op "[spell]"?
- `ACADEMY_TANK_BOTH_BODY` (nlNL:2152): *M+ pug*, *dungeon-queue*. (Is nu gelijk aan het Engels.)

### Heal-hoofdstukken
- `ACADEMY_HEAL_INTRO_BODY` (nlNL:2155): *HP*, *paniek-overheal*.
- `ACADEMY_HEAL_TRIAGE_BODY` (nlNL:2157): *fatale debuff*: hoe zie ik dat hij fataal is? Het taalfoutje "healt" is weg.
- `ACADEMY_HEAL_MANA_BODY` (nlNL:2175): wat drink ik, en waar haal ik het? Is "drinken" hetzelfde als "Mana pot"?
- `ACADEMY_HEAL_POSITION_BODY` (nlNL:2177): *bereik* (hoe ver? hoe zie ik dat ik te ver sta?), *de troep*.
- `ACADEMY_HEAL_MISTAKES_BODY` (nlNL:2181): *vermijdbare schade*. "Om een interrupt vragen": aan wie, en hoe?
- `ACADEMY_HEAL_WIPE_BODY` (nlNL:2159): *in fire* (Engels midden in de zin), *efficiëntere spells* (welke?).
- `ACADEMY_HEAL_DUNGEON_BODY` (nlNL:2161): *range*, *mana spuit*, *buffen*.
- `ACADEMY_HEAL_RAID_BODY` (nlNL:2163): *fight-timer*, *speler-bar*, *raid cooldowns*.
- `ACADEMY_HEAL_CHAT_BODY` (nlNL:2165): *prio*, *HP*.

### Kaart-venster (healer)
- `PLAYCARD_HEAL_HOW` (nlNL:704): helder. *raidframes* snap ik nu via "frames".
- `PLAYCARD_65_S2` (nlNL:1198): *"Licht Flash of Light op?"*: wat betekent "oplichten"?
- Drie woorden voor hetzelfde: *health* (nlNL:2131), *HP* (nlNL:2155), *levenspunten* (nlNL:1199).

---

## Deel 3: tegenstrijdigheden die er nog zijn

Alles hieronder is **GEMETEN** als tekst. Of het in het spel klopt, weet ik niet.

**1. Grote heal: bij nood of bij rust?**
- Triage: *"Grote heal na grote damage; kleine heals ertussen."* (nlNL:2157)
- Toolkit, label Zuinig: *"Grotere, tragere heal — gebruik als je even lucht hebt"* (nlNL:3629).
- Toolkit, label Snel: *"je reactieknop als iemand dipt"* (nlNL:3628).
De ene tekst zegt: na een grote klap de grote heal. De andere: de grote heal als het rustig is, de snelle als
iemand zakt. Welke druk ik als iemand bijna dood is?

**2. "Je kaart zegt welke heal zuinig is" — niet altijd.**
- Mana-hoofdstuk: *"Je kaart zegt het voor jouw spec (/mh play)"* (nlNL:2175).
- Holy Paladin-kaart (`PLAYCARD_65_*`, nlNL:1196-1204): geen woord over zuinig, goedkoop of veel mana.
  (Positieve controle: dezelfde zoekopdracht vond die woorden wél in `PLAYCARD_105_AOE` en `_MISTAKE`.)
- Op een Prot Paladin opent de heal-track juist de Holy Paladin-kaart (`RoleAcademy.lua:872-873`).
- De toolkit noemt bij Holy Paladin wél een Zuinig-heal (`HealerCooldowns.lua:161`, label nlNL:3622).
  Die heal komt op de kaart niet voor.

**3. Resto Druid-kaart: stap 3 tegen de grootste fout (onveranderd).**
- S3: *"Zakt iemand diep weg: Regrowth."* (nlNL:1264)
- Grootste fout: *"Regrowth casten zonder 5 Rejuvenation uit. Dat kost veel mana"* (nlNL:1267).
Iemand gaat dood en ik heb geen 5 Rejuvenations. Mag ik Regrowth drukken of niet?

**4. Een vijand gekozen: heal op mij, of raak ik de vijand?**
- Wat is een healer: *"Niemand gekozen, of een vijand gekozen? Dan komt de heal op jezelf."* (nlNL:2131)
- Holy Paladin-kaart, grootste fout: *"Divine Toll met een vijand als doel: dan raakt hij vijanden in plaats van
  dat hij je vrienden healt."* (nlNL:1202)
Is Divine Toll een uitzondering? Dat staat er niet.

**5. Bewaren tegen drukken: bijna weg, drie restjes.**
- Toolkit-regel bij Tranquility en Aura Mastery: *"Bewaar voor een grote raid-brede klap"* (nlNL:3540;
  `HealerCooldowns.lua:104`, `:110`).
- Het hoofdstuk stuurt je naar `/mh healcds`. Die print als kop *"bewaar ze voor het juiste moment"*
  (nlNL:3532, `HealerCooldowns.lua:559`). Het hoofdstuk zegt juist: vasthouden "voor het geval dat" is zonde (nlNL:2179).
- Tank, Als het misgaat: *"Had ik een defensive bewaard?"* (nlNL:2140). Naast "druk vóór de grote klap" (nlNL:3591)
  lees ik dat als "had ik hem moeten vasthouden?". Bedoeld is denk ik "had ik er één over voor 'help'"
  (nlNL:2138). **AFGELEID.**

**6. Pack pakken: met taunt of niet?**
- Wat is een tank: *"Een hele pack pak je met je AoE-aanvallen, niet met taunt."* (nlNL:2129)
- Prot Paladin-kaart S5: *"Trek met Hand of Reckoning"* (nlNL:1151), en die knop is volgens dezelfde zin de taunt.
Begin ik de pull nu wel of niet met mijn taunt?

**7. Interrupt: knop of macro?**
- Woordenlijst: *"Interrupt (kick): een knop die de spell van een vijand stopt"* (nlNL:2133).
- Checklist: *"Interrupt-macro op mijn bar (Macros-tab)"* (nlNL:2114).

**8. Klikken of zweven? (half opgelost)**
- Het oefen-vinkje zegt nu "op zijn frame te klikken" (nlNL:2121). Goed.
- Het vinkje erboven zegt nog *"Mouseover / focus heal macro's"* (nlNL:2118).

**9. Volgorde: uitleg na het gebruik.**
- De checklist (vast blok) gebruikt interrupt, taunt, defensive vóór alle uitleg.
- In de basis staat de woordenlijst als laatste. Triage gebruikt "debuff" en "pack"; de ladder gebruikt "Delves".
  Pas daarna komt de lijst die ze uitlegt (`RoleAcademy.lua:45`, `:52`).

---

## Deel 4: nieuwe cijfers

- **Tanken: 6/10** (was 3). Nu snap ik wat een tank doet, wat threat en taunt zijn, hoe ik een pack pak en hoe ik
  bij een eerste dungeon kom. Maar welke knop mijn taunt en mijn interrupt is, en hoe ik een grote klap zie
  aankomen, staat nog steeds nergens in de Academy.
- **Healen: 7/10** (was 5). "Klik op een frame en druk je heal", frames, OOM en de woordenlijst maken het
  basiswerk helder. Maar vier teksten spreken elkaar nog tegen over welke heal ik wanneer druk.

---

## Deel 5: top-5 wat nu het meest zou helpen

Ideeën over tekst en volgorde, geen spelfeiten. Rob kiest.

1. **Uitleg vóór gebruik.** Zet de woordenlijst als tweede basistekst (na "Wat is een ...?"), en zet de checklist
   ná de basis in plaats van in het vaste blok erboven.
2. **Eén zin: "zo zie je dat er iets groots aankomt".** Zes teksten zeggen "druk vóór de grote klap" of "interrupt
   de gevaarlijke cast", geen enkele zegt hoe je dat ziet. Wat er in het spel klopt, eerst laten meten (`mh-research`).
3. **Noem de taunt en de interrupt in de tank-toolkit**, of verwijs naar de kaartregel. Het vinkje "ik ken mijn
   taunt-toets" vraagt iets wat de pagina nergens laat zien. En maak de pull-start eenduidig (deel 3, punt 6).
4. **Haal de heal-botsingen weg:** grote vs snelle heal (triage tegen toolkit), Druid S3 tegen de grootste fout,
   Divine Toll tegen "vijand gekozen = heal op jezelf", en de belofte "je kaart zegt het" (Holy Paladin-kaart zegt
   het niet). Ook de drie "bewaar"-restjes (nlNL:3532, 3540, 2140). Feiten eerst laten meten.
5. **Vul de woordenlijst aan** met DPS, spec, HP, buff, HoT, bereik, raid, instance, normal/heroic/LFR/M+, macro,
   flask/pot, mouseover, troep. En maak de chat-stap af: hoe open je party chat, plak je, en wat zet je op "[spell]".

**Niet gelezen** (buiten de opdracht): de DPS-track, de Codex, de tab *Basis*, en de kaart-tabs *Blijf leven*,
*Groep* en *Consumables* (alleen hun bestaan gecontroleerd).
