# Tanken en healen, herlezing 4 door een nieuweling (7 okt 2026, nacht)

Eerdere rondes: tanken 3 → 6 → 7 → 8, healen 5 → 7 → 8 → 9. De vorige staat in
`ROLE_SWITCH_REREAD3_NEWCOMER_2026-10-07.md`. Daarna is de Role Academy weer aangepast.

**Wie las dit.** Iemand die al een tijd DPS speelt, ingelogd als Prot Paladin (tweede spec), en nog nooit tankte of
healde. Dat is een andere lezer dan in ronde 3 (die had WoW nooit gespeeld). Woorden als *cooldown* of *Holy Power*
weegt deze lezer dus lichter. De lat is dezelfde: een 10 = zonder vragen je eerste dungeon tanken of healen.

**Hoe betrouwbaar is dit rapport.**
- Wat een tekst zegt en op welke regel: **GEMETEN** in de bestanden op 7 okt 2026 (nlNL-regelnummers van vandaag; ze
  liggen ongeveer 10 regels lager dan in ronde 3).
- De volgorde op het scherm: **GEMETEN** in `Modules/RoleAcademy.lua:53-110` en `:991-1025`:
  wat is een tank/healer → woordenlijst → stappenplan → mindset (+ triage) → grote klap zien → angst-ladder →
  knop *"Zo speel je ..."* → toolkit → de overige hoofdstukken.
- Welke knoppen een Prot Paladin ziet: **GEMETEN** in de tabellen. Of ze écht op zijn scherm staan, hangt af van zijn
  talenten (`OwnedOnly`, `IsPlayerSpell`): **AFGELEID**.
- Elke key die ik citeer staat **één keer** in `Locales/nlNL.lua` (GEMETEN voor de 10 belangrijkste; `Translations2026.lua`
  raakt alleen de/fr/es/pt/it). `Locales/Codex.lua` heeft **geen** Academy-, kaart- of toolkit-keys (GEMETEN: 0 treffers
  op `ACADEMY_|PLAYCARD_|TANKKIT_|HEALTOOLKIT_|SURVIVAL_|HEALCD_|HEALCORE_`; hetzelfde patroon vond er tientallen in nlNL).
  De Codex komt in deze twee tracks dus niet voor.
- "Dit snap ik niet": **mijn oordeel als lezer**, geen meting. Of de spelinformatie klopt: **NIET gecontroleerd**.
  Waar ik een spelvraag heb, staat er "vraag" bij, geen bewering.

---

## Het korte antwoord

**De drie grote punten van ronde 3 zijn opgelost.**
- De toolkit noemt nu de AoE-knoppen, één keer uitgelegd, met je toets erachter.
- Blessing of Protection en Divine Shield zeggen op de tank-kaart nu *"vijanden gaan naar iemand anders"*.
- Stap 7 en de dungeon-hoofdstukken geven één advies, met uitnodigen en het rol-icoontje.

Wat nog wringt, de drie grootste:
- **Het schild.** De Academy zegt dat een Prot Paladin een schild nodig heeft, maar niet waar je er een haalt. Een
  DPS-paladin heeft er geen.
- **De kaart zegt nog *"je AoE"*** zonder naam, en *"Taunt ermee"* lijkt naar die AoE te wijzen. De kaart lees je vóór
  de toolkit.
- **Heal: geen gear-stap** in het stappenplan, terwijl de tekst zegt dat je Intellect nodig hebt.

**Nieuwe cijfers: tanken 9/10, healen 9/10.**

---

## Deel 1: de punten uit Deel 4 van ronde 3

### Tank

| # | Punt uit ronde 3 | Nu | Bewijs |
|---|---|---|---|
| 1 | AoE-knoppen noemen, met toets | **opgelost in de toolkit, niet op de kaart** | GEMETEN: `TankToolkit.lua:149` (`aoe = { 26573, 31935, 204019 }`), `RoleAcademy.lua:699-723` (één uitlegregel, daaronder één regel per knop, toets via `WithLiveKey`). Tekst: `TANKKIT_TK_HEAD` nlNL:3603, `TANKKIT_TK_AOE` nlNL:3604. Kaart: `PLAYCARD_66_S5` nlNL:1152 zegt nog *"je AoE"*, `PLAYCARD_66_AOE` nlNL:1153 *"Zelfde knoppen"*. |
| 2 | Blessing of Protection op de tank-kaart; waarschuwing bij Divine Shield | **opgelost** | GEMETEN: `KeybindRoles_Paladin.lua:76` geeft Prot `SURVIVAL_NOTE_PHYSICAL_TANK` (nlNL:1533: *"vijanden gaan naar iemand anders: als tank alleen in nood, en taunt ze meteen terug"*). `:66` geeft Prot `SURVIVAL_NOTE_FORBEARANCE_TANK` (nlNL:1631). Past nu bij de tab Groep (`GROUP_NOTE_BOP` nlNL:1544, `GroupPlan.lua:48`). Restje: T4 hieronder. |
| 3 | Eén dungeon-advies, vrienden meenemen, rol kiezen | **opgelost** | GEMETEN: `ACADEMY_STEP_NORMAL` nlNL:2148 (vrienden als het kan, anders willekeurig; `/inv`; *"vink het Tank- of Healer-icoontje aan"*; *"in een groep drukt de groepsleider"*). `ACADEMY_TANK_DUNGEON_BODY` nlNL:2169 en `ACADEMY_HEAL_DUNGEON_BODY` nlNL:2188 zeggen hetzelfde. Restje: T8. |
| 4 | "Op cooldown" uitleggen | **opgelost** | GEMETEN: `ACADEMY_WORDS_BODY` nlNL:2156: *"Op cooldown (zoals in "druk hem op cooldown"): druk hem opnieuw zodra hij klaar is."* Staat vóór alle teksten die het gebruiken. |
| 5 | Toolkit-defensives klein/groot; welke achter de hand; Shield of the Righteous één boodschap | **half** | Shield of the Righteous: **opgelost**, toolkit *"Houd hem bijna altijd aan in een gevecht"* (`TANKKIT_MITDESC_BLOCK` nlNL:3616) = kaart *"Houd hem bijna altijd aan"* (nlNL:1149). "Achter de hand": **opgelost**, nu *"houd een grote achter de hand voor de hardste klap"* (nlNL:2165). Klein/groot: de toolkit **verwijst** naar de kaart (`TANKKIT_CDDESC_DR` nlNL:3626) maar zegt het niet zelf, en dezelfde lange zin staat 3× onder elkaar (`TankToolkit.lua:105-107`, alle drie `kind = "dr"`). Zie T3. |
| 6 | Gear-stap: hoe zie je of je spullen kloppen | **half** | GEMETEN: `ACADEMY_STEP_TANK_GEAR` nlNL:2139 zegt nu waar *"Primary Stat"* staat en dat je karakterscherm de hoofdstat van je huidige spec toont. Niet: hoe je op één item ziet of het die stat heeft, en waar je een schild haalt. Zie T1. |
| 7 | Fysiek of magisch: hoe zie je het | **opgelost (voor bazen)** | GEMETEN: laatste alinea van `ACADEMY_SEE_BODY` nlNL:2160 (Adventure Guide → baas → Overview → Tanks/Healers; *"Physical"* tegen een school zoals Fire of Shadow). Voor trash staat er niets; voor een eerste dungeon vind ik dat geen probleem. |
| 8a | Ondertitel en klasregel | **opgelost** | GEMETEN: `ACADEMY_SUBTITLE` nlNL:2115 zonder *"prep-vinkjes"* en *"parse-guide"*; `ACADEMY_CLASS_FMT` nlNL:2119 zonder de Tools-zin. |
| 8b | *Draai vijanden af* | **half** | GEMETEN nlNL:2165: het *waarom* staat er nu (*"sommige vijanden raken alles wat vóór ze staat"*). Het *hoe* niet. Klein. |
| 8c | Losse woorden (rotation, damage meter, chain, Repair, pug, open world, boss-taunt, grote hit, try) | **opgelost in de tank-track** | GEMETEN: in nlNL:2151-2179 vindt een zoekopdracht op al deze woorden niets meer, alleen *"hardop"* (2163). Positieve controle: dezelfde zoekopdracht vond *"damage meter"* (2844) en *"open world"* (3369) elders. *Portret* en *elites* worden nu ter plekke uitgelegd (2152, 2177). |
| 8d | Kopje boven de hero-regels op kaart 66 | **niet opgelost** | GEMETEN: het kopje *"Later, als de stappen hierboven makkelijk gaan:"* (`PLAYCARD_LATER_HEAD` nlNL:1133) komt alleen als de kaart een `EASY`-tekst heeft (`PlayCardWindow.lua:1073`). `PLAYCARD_66_EASY` bestaat niet (enUS heeft er 7, alle 7 voor healers). Templar en Lightsmith (nlNL:1155-1156) staan dus nog als losse bolletjes. |
| 8e | Chat-hint: naar wie | **opgelost** | GEMETEN: `ACADEMY_CHAT_HINT` nlNL:2173 (Say = alleen mensen vlak bij je; `/p` voor je groep; `/i` in een Group Finder-dungeon). |

**Telling tank (12 regels): 8 opgelost (1, 2, 3, 4, 7, 8a, 8c, 8e), 3 half (5, 6, 8b), 1 niet (8d).** Punt 1 reken
ik als opgelost, want de vraag "welke knop" heeft nu een antwoord; het kaart-restje staat in Deel 3 (T2).

### Heal

| # | Punt uit ronde 3 | Nu | Bewijs |
|---|---|---|---|
| 1 | Triage voor elke spec ("je grote heal") | **half** | GEMETEN: `ACADEMY_HEAL_TRIAGE_BODY` nlNL:2184 zegt nu *"(Resto Druid: Regrowth, je directe heal)"*. Maar: de toolkit noemt Regrowth *[Snel]*, niet *[Groot]* (`HealerCooldowns.lua:172`). En ook Preservation Evoker, Discipline en Holy Priest hebben geen enkele heal met *Groot* (`:176-201`). Voor de Holy Paladin klopt het wel: Holy Light is *[Groot]* (`:164`). |
| 2 | Kop boven de cooldowns | **opgelost in de toolkit** | GEMETEN: `HEALTOOLKIT_CDS_HEAD` nlNL:3579 = *"Je cooldowns"*. Restje: het hoofdstuk heet nog *"Gebruik je grote cooldowns op het goede moment"* en zegt *"Je grote heal-cooldowns zijn voor de grote momenten"* (nlNL:2205-2206); `/mh healcds` print *"Jouw grote cooldowns"* (`HEALCD_TITLE` nlNL:3559). Daaronder staat bij Avenging Wrath en Divine Toll *"Gebruik hem vaak, bijna op cooldown"* (nlNL:3575). |
| 3 | `/mh healcds` werkt pas in je heal-spec | **opgelost** | GEMETEN nlNL:2206: *"Dat werkt als je in je heal-spec staat."* |
| 4 | Divine Shield *[Immuniteit]* in de heal-toolkit | **opgelost** | GEMETEN: `HealerCooldowns.lua:227` (`immune = true`), `RoleAcademy.lua:614-616` kiest dan `TANKKIT_CD_IMMUNITY` (nlNL:3622). Divine Protection houdt *[Defensive]*. |
| 5 | Stap 5: hoe krijg ik een vriend in mijn groep | **opgelost** | GEMETEN: `ACADEMY_STEP_HEAL_FRIEND` nlNL:2146 (*"rechtsklik op zijn naam in de chat -> Invite, of typ /inv en zijn naam"*). |
| 6 | Kleine woorden; *"Licht ... op?"* | **grotendeels** | *"Zodra [Flash of Light] oplicht op je balk: cast hem"* (`PLAYCARD_65_S2` nlNL:1200): opgelost. Gif/Poison: *"zoals Poison (gif)"* (nlNL:2156): opgelost. Instant: *"de tooltip zegt dan "Instant""* (nlNL:2184): opgelost. *In fire* en *fight-timer*: weg (GEMETEN, 0 treffers in nlNL; positieve controle *"dungeon-queue"* gevonden op 2198, DPS-track). *In range* wordt nu uitgelegd (2188). Blijft: zie H5. |
| — | Boss Abilities-tijdlijn: waar op mijn scherm (beide tracks) | **niet opgelost** | GEMETEN nlNL:2160: zegt wat hij doet en dat hij aan staat, niet waar hij staat. Klein. |

**Telling heal: 3 opgelost (3, 4, 5), 3 half of grotendeels (1, 2, 6), 1 niet (Boss Abilities).**

---

## Deel 2: de twee tracks in schermvolgorde

Kort per blok: ✔ = ik kan verder zonder vraag, ? = ik heb een vraag (staat in Deel 3).

### Tank-track (als Prot Paladin, toolkit "live" met toetsen)
1. ✔ Kop, ondertitel, *"Ingelogd: Paladin - Protection. De kaart van je spec: /mh play"* (nlNL:2115, 2119).
2. ✔ *Wat is een tank?* (2152). Aggro, threat, taunt (6 s / 8 s), AoE, tempo, loot spec. Wel: ? schild (T1).
3. ✔ *Woorden die je gaat horen* (2156). Lang (35 regels) maar volledig voor deze track.
4. ? *Rol wisselen, stap voor stap* (2137-2148). Stap 1 en 3 vinken zichzelf af (`RoleAcademy.lua:175-193`). Stap 2
   gear: T1. Stap 7: T8.
5. ✔ *Tank-mindset* (2163).
6. ✔ *Zo zie je een grote klap aankomen* (2160). Duidelijk, ook het stuk over fysiek/magisch.
7. ? *Angst-ladder* (2177): een tweede route naast het stappenplan (T7).
8. ? Knop *"Zo speel je Protection >"* → kaart 66. ? *"je AoE"* en *"ermee"* (T2); ? geen kopje boven Templar/Lightsmith.
9. ✔ Toolkit: Shield of the Righteous, taunt, interrupt, stun, **AoE met drie knoppen en toets**, dan de defensives.
   ? drie keer dezelfde zin (T3); ? Hammer of the Righteous (T5).
10. ✔ *Tijdens een pull* (2165), *Als het misgaat* (2167), *Je eerste normal dungeon* (2169), *Raids en LFR* (2171),
    *Party chat* met hint (2173-2175), *Ook heal of DPS leren?* (2179).

### Heal-track (als Prot Paladin: voorbeeld van Holy, zonder toetsen)
1. ✔ *Wat is een healer?* (2154). Frame klikken, dan heal; Edit Mode; Click Casting; Intellect. ? gear (H1).
2. ✔ Woordenlijst (2156).
3. ? Stappenplan (2141-2148): spec, frames, toetsen, kaart, vriend, follower, normal. Geen gear-stap (H1).
4. ✔ *Heal-mindset* (2182), ✔ *Triage* (2184), ✔ grote klap zien (2160), ✔ ladder (2194, op *"group"* na).
5. ? Knop *"Zo speel je Holy >"* → kaart 65 als voorbeeld (H2, H4).
6. ✔ Toolkit-voorbeeld: *"Voorbeeld van je Holy-toolkit — je zit nu in een andere spec."* (3581); dagelijkse heals,
   *Je cooldowns*, personal defensives met *[Immuniteit]*, dispel. ? *ally*, *dipt*, *[Extern]* (H5).
7. ✔ *Mana* (2202), *Waar je gaat staan* (2204). ? *Gebruik je grote cooldowns* (2205-2206, Deel 1 heal-2).
   ✔ *Beginnersfouten* (2208), *Als het misgaat* (2186), *Iemand verliezen mag* (2210), *Je eerste normal dungeon* (2188).
   ? *Raids en LFR* (2190, H5). ✔ *Party chat* (2192). ✔ *Ook tank of DPS leren?* (2196).

---

## Deel 3: wat nu nog struikelt

Gesorteerd van groot naar klein. Tekst = GEMETEN; of het in het spel klopt = niet gecontroleerd.

### Tank

**T1. Waar haal ik een schild?** (groot, voor deze lezer)
- *"Protection Paladin en Protection Warrior hebben een schild nodig: zonder schild werken hun belangrijkste knoppen niet."*
  (`ACADEMY_TANK_WHAT_BODY` nlNL:2152); stap 2 zegt *"ook een schild"* (nlNL:2139).
- Als DPS-paladin heb ik er geen. MH's eigen code zegt dat ook: een Ret draagt een tweehander, en Shield of the Righteous
  toont dan *"Requires Shield"* in het rood (`KeybindRoles_Paladin.lua:136-140`, gemeten op Robs Ret, 7 sep).
- Nergens staat waar ik een schild (en een eenhandig wapen) vandaan haal, of hoe ik op een item zie of het de juiste
  stat heeft. Zonder schild kan ik mijn eerste dungeon niet tanken.

**T2. Kaart 66: *"je AoE"* en *"ermee"*.** (middel)
- *"Bij één vijand of een baas mag je beginnen met [Hand of Reckoning]. Bij een pack begin je met je AoE. Taunt ermee
  zodra een vijand iemand anders slaat."* (`PLAYCARD_66_S5` nlNL:1152).
- *"Ermee"* staat direct na *"je AoE"*. Ik las eerst: taunt met je AoE. Bedoeld is vast Hand of Reckoning.
- De kaart noemt de AoE-knoppen niet bij naam. De toolkit wel, maar de knop naar de kaart staat bóven de toolkit
  (`RoleAcademy.lua:1007-1011`), dus ik lees de kaart eerst.
- Kleine wrijving: de toolkit zegt *"Begin elke pull hiermee"* (nlNL:3604), de kaart *"Bij één vijand of een baas mag
  je beginnen met"* taunt. Geen echte botsing ("mag"), wel twee zinnen die ik moet samenleggen.

**T3. De drie grote defensives: drie keer dezelfde lange zin.** (middel)
- Ardent Defender, Guardian of Ancient Kings en Sentinel krijgen elk `TANKKIT_CDDESC_DR` (nlNL:3626; `TankToolkit.lua:105-107`).
  Die zin is nu langer (met de verwijzing naar de kaart), dus het blok is drie keer twee regels hetzelfde.
- Voor de AoE-zin is dit al opgelost: één keer bovenaan (`RoleAcademy.lua:716`). Hier nog niet.
- Welke klein is en welke groot, staat alleen op de kaart (`KeybindRoles_Paladin.lua:168` klein; `:69`, `:218` groot).
  Ik moet dus een tweede venster en een tweede tab openen.

**T4. Blessing of Protection: twee opdrachten in één regel.** (klein)
- De regel op *Blijf leven* is stap-tekst + noot: *"een grote: druk hem net vóór de hardste klap die je ziet aankomen
  (een immuniteit mag ook als je bijna dood bent)"* (`SURVIVAL_STEP_BIG` nlNL:1531) + *"als tank alleen in nood"* (nlNL:1533).
- Vooraf drukken of alleen in nood? De noot wint vast, maar dat moet ik raden.
- Vraag (geen bewering): de tab Groep zegt dat Lay on Hands *"niet werkt vlak na een Blessing of Protection op diegene"*
  (`GROUP_NOTE_LOH` nlNL:1547). Op *Blijf leven* staat bij Divine Shield alleen *"dan kan je andere immuniteit even niet"*
  (nlNL:1631), en Lay on Hands komt een paar regels later als *"laatste redmiddel"* (nlNL:1632). Mag ik Lay on Hands
  drukken vlak na Divine Shield? De code-notitie noemt Forbearance ook bij Lay on Hands (`KeybindRoles_Paladin.lua:92`).
  Laten meten.

**T5. Hammer of the Righteous ontbreekt in de AoE-lijst.** (klein, vraag)
- De AoE-lijst van Prot is Consecration, Avenger's Shield, Blessed Hammer (`TankToolkit.lua:149`).
- `KeybindRoles_Paladin.lua:134-135` noemt Hammer of the Righteous (53595) een *"AoE-cleave builder"* en Blessed Hammer
  het talent-alternatief ervoor.
- **AFGELEID:** wie Hammer of the Righteous heeft, ziet in de AoE-lijst geen hamer (de lijst toont alleen wat je kent).
  Of dat zo bedoeld is, weet ik niet. Laten checken.

**T6. Kleine woorden in de tank-toolkit.** (klein)
- *"Je active mitigation (hou deze omhoog)"* (`TANKKIT_MIT_HEAD` nlNL:3602). *"Omhoog"* is letterlijk vertaald; de kaart
  zegt *"houd deze aan"* (nlNL:1525).
- Label *[Block]* op Shield of the Righteous (nlNL:3611), nergens uitgelegd.
- *"Je personal defensives"* (nlNL:3609): Engels in een Nederlandse kop.
- De kop *"Je taunt, je interrupt en je AoE"* (nlNL:3603) noemt de stun (Hammer of Justice) niet, die staat er wel onder.

**T7. Twee routes op één pagina.** (klein)
- Stappenplan: spec → gear → toetsen → kaart → dummy → follower → normal (nlNL:2138-2148).
- Angst-ladder, twee blokken later: elites → delves → follower → normal → heroic/LFR (nlNL:2177).
- Ze botsen niet, maar welke volg ik? Het stappenplan zegt *"Eén follower dungeon gedaan"*, de ladder *"Blijf bij elke
  stap tot hij saai voelt"*. En stap 7 zegt *"willekeurige groep"* mag, de ladder *"met mensen die je vertrouwt"*.

**T8. Ik ben niet de groepsleider: waar vink ik mijn rol aan?** (klein, vraag)
- *"Vink vóór Find Group het Tank-icoontje aan ... Daarna drukt de groepsleider op Find Group."* (nlNL:2169, 2148).
- Als een vriend de leider is, druk ik zelf niet op Find Group. Waar kies ik dan Tank? Laten meten hoe het spel dat vraagt.

**T9. Kleine restjes.**
- Kaart 66: Templar en Lightsmith zonder kopje (Deel 1, 8d).
- Waar zie ik mijn Holy Power (kaart 66, nlNL:1147-1149)? Als DPS-paladin weet ik het wel; een echte nieuweling niet.
- *"Let op mana van de healer"* (nlNL:2169): waar zie ik die?
- Het pull-hoofdstuk (nlNL:2165) noemt Shield of the Righteous niet, terwijl de kaart zegt *"bijna altijd aan"*.
- Stap 3 (nlNL:2140) vraagt alleen taunt en interrupt op een toets, niet de AoE-knoppen die de toolkit nu noemt.
- **AFGELEID:** het kaartvenster onthoudt de laatste tab (`PlayCardWindow.lua:258-262`). Wie eerder op *Dispel* stond,
  klikt *"Zo speel je Protection"* en ziet de tab *Dispel*, niet de kaart.

### Heal

**H1. Geen gear-stap in het heal-stappenplan.** (middel, voor deze lezer)
- Tank-plan: `spec, gear, keys, card, dummy, follower, normal`. Heal-plan: `spec, frames, keys, card, friend, follower,
  normal` (GEMETEN `RoleAcademy.lua:15-19`).
- Wel in de tekst: *"Gear: de hoofdstat van je heal-spec (voor healers: Intellect)."* (nlNL:2154).
- Als Prot/Ret-paladin heb ik vast andere gear. Moet ik nieuwe spullen? Waar haal ik ze? Het stappenplan, dat mijn route
  is, slaat het over. Hetzelfde gat als T1.

**H2. Het voorbeeld van kaart 65 belooft toetsen die er niet staan.** (klein)
- *"De [toets] achter een spellnaam is waar hij op jouw balken staat."* (`PLAYCARD_HEAL_HOW` nlNL:703).
- In mijn Prot-spec is kaart 65 een voorbeeld: er komen geen toetsen (`PlayCardWindow.lua:953`, `live` alleen voor je
  actieve spec). Ik zoek dus naar [toetsen] die er niet zijn.
- Ook de klasregel stuurt me een andere kant op: *"De kaart van je spec: /mh play"* (nlNL:2119) opent de **Protection**-kaart
  (`Core.lua:3250-3253` → actieve spec), terwijl de knop in de heal-track **Holy** opent. Na stap 1 (spec wisselen) klopt
  het weer. **AFGELEID** uit de code.

**H3. "Grote cooldowns" tegen "gebruik hem vaak": het hoofdstuk.** (klein)
- Zie Deel 1, heal-2. De toolkit-kop is opgelost; het hoofdstuk en `/mh healcds` zeggen nog *"grote"*, en het hoofdstuk
  zegt dat ze *"voor de grote momenten"* zijn. Kaart 65 zegt *"zodra ze klaar zijn"* (nlNL:1199).

**H4. Kaart 65 zegt twee keer hetzelfde.** (klein)
- *"Zo heal je, in 3 stappen"* (`PLAYCARD_65_EASY` nlNL:1198) punt 2 en 3 staan bijna letterlijk ook als stap 3 en 4
  (nlNL:1201, 1202). Ik dacht eerst dat ik iets gemist had.

**H5. Woorden die in de heal-track bleven.** (klein)
- *"raid-wide damage"* en *"speler-bar"* (nlNL:2190); *"Raid healen = dezelfde triage - tank en raid cooldowns eerst"*
  (2190): eerst de tank, of eerst cooldowns?
- *"buffen"* (2188): welke buff zet ik als Holy Paladin?
- *"Tank is prio"* (2192), *"Delves met een kleine group"* (2194).
- Toolkit: *"ally"* (`HEALCD_WHEN_EXT` nlNL:3568), *"single-target"* en *"als iemand dipt"* (`HEALCORE_DESC_FAST` nlNL:3663),
  label *[Extern]* (nlNL:3564) zonder uitleg.
- Triage *"met een fatale debuff"* (2184): hoe zie ik dat een debuff fataal is?

**H6. Triage "je grote heal" bij andere specs.** (klein; raakt de Prot Paladin niet)
- Zie Deel 1, heal-1. Evoker, Disc en Holy Priest hebben geen *[Groot]*; de Druid-uitleg noemt Regrowth, die de toolkit
  *[Snel]* noemt.

### Beide tracks

**B1. Toetsen in twee schrijfwijzen.** (klein)
- De Academy-toolkit zet de toets zoals de client hem kort schrijft (`LiveKeys.lua:63-71`, `GetBindingText(key, true)`;
  `RoleAcademy.lua:464-465`). De kaart schrijft hem uit: *"s-3"* wordt *"Shift 3"* (`PlayCardWindow.lua:319-326`, `:339`).
- **AFGELEID:** dezelfde toets heet in de Academy *[s-3]* en op de kaart *[Shift 3]*. Wat *s-3* is, staat nergens.

**B2. "Cooldown" heeft twee betekenissen.** (klein; een DPS-speler kent het)
- Woordenlijst: *"Cooldown: de wachttijd voor je een knop weer kunt drukken."* (nlNL:2156).
- Maar *"Je cooldowns"* (3579), *"Gebruik je grote cooldowns"* (2205), *"Je cooldowns nooit indrukken"* (2208): daar is
  een cooldown een **knop** met een lange wachttijd. Die betekenis staat niet in de lijst.

**B3. Boss Abilities-tijdlijn: waar op mijn scherm?** (klein, onveranderd; nlNL:2160).

### Wat nu echt goed is
- De toolkit geeft antwoord op "welke knop": taunt, interrupt, stun en AoE, elk met de toets waar hij nú op staat, en
  rood als hij nog nergens op staat. Bij elke balk-wijziging tekent de pagina opnieuw (`RoleAcademy.lua:1213-1234`).
- Kaart en tab Groep zeggen nu hetzelfde over Blessing of Protection en Divine Shield.
- Het dungeon-advies is overal één verhaal: vrienden als het kan, uitnodigen, rol-icoontje, wie op Find Group drukt.
- De chat-hint legt Say, `/p` en `/i` uit.
- Fysiek of magisch heeft nu een plek waar je het opzoekt.
- De heal-track is bijna zonder Engels jargon, en de kaart 65 begint met drie stappen in gewone taal.

---

## Deel 4: nieuwe cijfers

- **Tanken: 9/10** (was 8). Ik weet nu welke knoppen een pull pakken, hoe ik in de rij kom en wat ik doe als het
  misgaat; wat me nog tegenhoudt is vooral praktisch: waar haal ik als DPS-paladin een schild, plus een kaartzin die ik
  verkeerd kan lezen en drie keer dezelfde defensive-zin.
- **Healen: 9/10** (bleef 9). Bijna alle restjes van ronde 3 zijn weg; wat overblijft is de ontbrekende gear-stap, een
  hoofdstuk dat nog "grote cooldowns" zegt, en een voorbeeldkaart die toetsen belooft die ik in mijn tank-spec niet zie.

---

## Deel 5: wat er nog nodig is voor een 10

Ideeën over tekst, geen spelfeiten. Wat over het spel gaat eerst laten meten (`mh-research`). Rob kiest.

**Tank:**
1. **Schild en gear.** In stap 2 of in *Wat is een tank?* één zin waar je een schild (en eenhander) haalt, en hoe je op
   een item ziet of de stat klopt (bijvoorbeeld: muis op het item, de tooltip toont de stats). Eerst laten meten wat
   klopt in 12.1.
2. **Kaart 66, S5:** *"ermee"* vervangen door de naam (*"Taunt met [Hand of Reckoning] zodra ..."*), en *"je AoE"* laten
   volgen door de namen (*"je AoE: [Consecration], [Avenger's Shield], [Blessed Hammer]"*), of *"(zie de toolkit)"*.
3. **Defensive-zin één keer**, net als de AoE-zin: de gedeelde regel onder de kop, en per knop alleen *"klein: vaak
   drukken"* of *"groot: voor de hardste klap"*. Dan hoeft niemand naar de kaart.
4. **Blessing of Protection:** voor Prot de stap-tekst en de noot laten samenvallen (één opdracht). En laten meten of
   Lay on Hands vlak na Divine Shield werkt; zo niet, dat bij Divine Shield of Lay on Hands zetten.
5. **Hammer of the Righteous:** laten checken of hij in de AoE-lijst hoort (T5).
6. **Opruimen:** *"hou deze omhoog"* → *"houd deze aan"*; *[Block]* uitleggen of hernoemen; *personal defensives* →
   *eigen defensives*; kopje boven Templar/Lightsmith op kaart 66 (bijvoorbeeld de bestaande *"Later, als ..."*-regel
   ook zonder `EASY` tonen); stap 3 ook de AoE-knoppen laten noemen; één zin in het pull-hoofdstuk over Shield of the
   Righteous.
7. **Eén route:** het stappenplan als dé route; de ladder als "daarna, als het goed gaat" (heroic/LFR), of de dubbele
   stappen (follower, normal) uit de ladder halen.
8. **Rol kiezen als je niet de leider bent:** laten meten waar het spel dat vraagt, dan één zin erbij.

**Heal:**
1. **Gear-stap in het heal-stappenplan**, zoals bij tanks: Intellect, en waar je het ziet. Eerst laten meten of een
   paladin daar nieuwe spullen voor nodig heeft.
2. **Hoofdstuk en `/mh healcds`** laten passen bij de toolkit: *"Gebruik je cooldowns op het goede moment"*, met één zin
   dat sommige (zoals de toolkit zegt) juist vaak mogen.
3. **Voorbeeldkaart:** in een voorbeeld de zin over *[toets]* weglaten of vervangen door *"je toetsen zie je zodra je in
   deze spec staat"*. En de klasregel in de heal-track naar de heal-kaart laten wijzen (of *"/mh play toont de kaart van
   de spec waarin je nu staat"*).
4. **Kaart 65:** de dubbele regels tussen *"in 3 stappen"* en de stappen eruit halen.
5. **Woorden:** *raid-wide*, *speler-bar*, *buffen* (welke buff), *prio*, *group*, *ally*, *single-target*, *dipt*,
   *[Extern]*; en *"tank en raid cooldowns eerst"* in twee zinnen splitsen.
6. **Triage** voor de specs zonder *[Groot]* (Evoker, Disc, Holy Priest), en Regrowth hetzelfde label geven in de triage
   en de toolkit.

**Beide:**
1. Toetsen overal op één manier schrijven (*Shift 3* of *s-3*), en als het *s-3* blijft: één regel in de woordenlijst.
2. Woordenlijst: *"Cooldowns (meervoud, als knop): je knoppen met een lange wachttijd, voor grote momenten."*
3. Waar de tijdlijn Boss Abilities op je scherm staat (laten meten).

---

**Niet gelezen** (buiten de opdracht): de DPS-track, de tab *Basis*, de kaart-tabs *Consumables* en *Dispel* (alleen de
code), de tab *Groep* alleen voor Blessing of Protection, Spellwarding en Lay on Hands. Uit `docs/` las ik alleen
`ROLE_SWITCH_REREAD3_NEWCOMER_2026-10-07.md`. Het venster zelf heb ik niet gezien; alles komt uit code en teksten.
