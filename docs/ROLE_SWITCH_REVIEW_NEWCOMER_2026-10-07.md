# Tanken en healen, gelezen door iemand die nooit speelde (7 okt 2026)

Rob vroeg: *"Hebben we makkelijke uitleg over healen en tanken voor iemand die het echt niet begrijpt?"*

**Wie las dit.** Een lezer die World of Warcraft nooit speelde. Ik gebruikte geen eigen spelkennis en zocht
niets online op. Ik weet alleen wat de teksten zelf uitleggen. Ik las de Nederlandse tekst (`Locales/nlNL.lua`),
behalve waar alleen Engels bestaat.

**Hoe betrouwbaar is dit rapport.**
- Wat een tekst zegt, en op welke regel: **GEMETEN** in de bestanden op 7 okt 2026.
- De volgorde op het scherm: **GEMETEN** in de Lua (`Modules/RoleAcademy.lua`, `Modules/PlayCardWindow.lua`).
- "Dit snap ik niet": dat is **mijn oordeel als beginner**, geen meting.
- Of de spelinformatie klopt: **NIET gecontroleerd**. Dat mocht ik niet weten.
- Spellnamen vult het spel zelf in. Ik noem de namen uit de commentaren in de repo (**GEMETEN** in
  `TankToolkit.lua`, `HealerCooldowns.lua`, `HealerSolo.lua`, `KeybindRoles_Paladin.lua`, `KeybindRoles_Druid.lua`).
  Eén id (275779) heeft in de repo geen naam; daar staat "[275779]".

---

## Het korte antwoord

**Nee, nog niet.** Er staat veel goede, vriendelijke tekst. Maar nergens staat in gewone woorden wat een tank
**is** of wat een healer **is**. De teksten beginnen meteen met vakwoorden (pull, pack, taunt, threat, cooldown,
interrupt, defensive, frames, debuff). En het scherm toont eerst een checklist en een gereedschapslijst vol
vakwoorden, en pas dáárna het hoofdstuk "Tank-mindset" of "Heal-mindset".

De twee beste uitleg-zinnen staan op een andere plek dan je zou zoeken:
- *"Aggro betekent dat een vijand jou aanvalt. De tank wil dat; een DPS of healer die het trekt, gaat vaak dood."*
  Dat staat in de **Codex** (`Codex.lua:415`), niet in de tank-track van de Academy.
- *"Zo heal je: klik op de balk van de vriend die je wilt healen … en druk dan de toets."* Dat staat alleen in
  het **kaart-venster** (`nlNL.lua:689` + `:703`, getoond in `PlayCardWindow.lua:985`), niet in de heal-track.

Cijfers (uitleg onderaan): **tanken 3/10, healen 5/10.**

---

## Wat het scherm toont, in deze volgorde (GEMETEN)

**Tank-track** (`RoleAcademy.lua:782-798` en `:39-48`):
1. Kop *Role Academy* + ondertitel `ACADEMY_SUBTITLE` (nlNL:2103)
2. Knoppen *Tank-track / Heal-track / DPS-track* (nlNL:2104-2106)
3. Klasregel `ACADEMY_CLASS_FMT` (nlNL:2107)
4. *Pre-flight checklist* met 4 vinkjes (nlNL:2110-2115)
5. Knop *"Zo speel je <spec> >"* (opent de kaart in een eigen venster)
6. Tank-toolkit: active mitigation, personal defensives, dispel (`RoleAcademy.lua:562-603`)
7. Acht hoofdstukken: Tank-mindset, Tijdens een pull, Als het misgaat, Je eerste dungeon, Raids en LFR,
   Party chat, Angst-ladder, Ook heal of DPS leren?

**Heal-track** (`RoleAcademy.lua:782-785` en `:50-62`): punt 1 t/m 5 hetzelfde, dan de healer-toolkit
(`RoleAcademy.lua:470-535`), dan dertien hoofdstukken: Heal-mindset, Triage, Mana, Waar je gaat staan,
Cooldowns, Beginnersfouten, Als het misgaat, Iemand verliezen mag, Eerste dungeon, Raids en LFR, Party chat,
Angst-ladder, Ook tank of DPS leren?

📌 Op Robs Prot Paladin toont de heal-track een **voorbeeld van Holy Paladin** (`RoleAcademy.lua:475`, `:783-784`),
niet de Resto Druid-kaart (105) die ik hieronder las. De labels en uitleg-zinnen van de toolkit zijn voor elke
spec dezelfde; alleen de spellnamen verschillen.

---

## Deel 1: wat je ziet vóór er iets wordt uitgelegd

### `ACADEMY_SUBTITLE` (nlNL:2103)
> "Korte masterclass voor tanken, healen en DPS in groups - mindset, prep-vinkjes en een rustige opbouw naar dungeons. Geen parse-guide."

1. **Niet gesnapt, niet uitgelegd:** *tanken*, *healen*, *DPS*, *groups*, *dungeons*, *parse-guide*.
2. **Draad kwijt:** de allereerste zin noemt drie rollen, en geen enkele wordt hier of later uitgelegd.
3. **Wat ik nu snap:** er zijn drie soorten rollen, en dit scherm gaat over samen spelen.

### `ACADEMY_CLASS_FMT` (nlNL:2107)
> "Ingelogd: %s - %s (open Macro's / Consumables / Guides via de zijbalk)"

1. **Niet gesnapt:** *Macro's*, *Consumables*. Het tweede woord wordt de spec (bv. "Protection"); wat een spec is,
   staat nergens.
2. **Draad kwijt:** ik zoek "Guides" in de zijbalk. **GEMETEN:** de zijbalk heet *Me / Codex / Tools*
   (enUS:221-223). Geen `TAB_`- of `SIDEBAR_`-label heeft de waarde "Guides"; de gidsen-tab heet
   *Leveling (80-90)* (nlNL:2081). Positieve controle: hetzelfde zoekpatroon vond wél `"Guides pick: %s"`
   (enUS:2564). **AFGELEID:** een beginner vindt "Guides" dus niet.

### Pre-flight checklist, tank (nlNL:2110-2115)
> "Interrupt-macro op mijn bar (Macros-tab)" · "Een defensive klaar (Guides -> Defensives of In groups-tab)" ·
> "Flask / pot klaar (Consumables-tab)" · "Ik ken mijn taunt-toets (1x dummy test)"

1. **Niet gesnapt:** *pre-flight*, *interrupt*, *macro*, *bar*, *defensive*, *flask*, *pot*, *taunt*, *dummy test*.
2. **Draad kwijt:**
   - Ik moet dingen afvinken die ik pas verderop (of nooit) uitgelegd krijg.
   - *"Guides -> Defensives of In groups-tab"*: **GEMETEN** dat "In groups" alleen in deze checklist en in
     `INFO_DRAWER_BODY_ACADEMY` voorkomt (nlNL:2113, 2117, 2191). De gidsen-tab heeft als subtabs alleen
     *Gids* en *Indeling* (nlNL:2192-2193). **AFGELEID:** de verwijzing leidt naar een tab die er niet is.
   - "Ik ken mijn taunt-toets": welke knop is dat? De tank-toolkit hieronder noemt geen taunt.
     **GEMETEN:** in `TankToolkit.lua:72-133` staat voor spec 66 geen taunt; die staat alleen op de kaart (S5).
   - Wat is een "dummy" en waar staat er een?

### Pre-flight checklist, heal (nlNL:2116-2119)
> "Mouseover / focus heal macro's (Macros-tab)" · "Eigen defensive op bar …" · "Mana pot / flask" · "1x hover-heal op vriend geoefend"

1. **Niet gesnapt:** *mouseover*, *focus*, *mana*, *hover-heal*.
2. **Draad kwijt:** "hover-heal" klinkt als iets anders dan wat de kaart later zegt ("klik op de balk van de
   vriend"). Moet ik nu klikken of zweven met de muis?

---

## Deel 2: de toolkits (staan boven de hoofdstukken)

### Tank-toolkit (`RoleAcademy.lua:562-603`, teksten nlNL:3561-3584)
Wat ik zie op een Prot Paladin (namen uit `TankToolkit.lua:73-107`):
> **Je active mitigation (hou deze omhoog)**
> [Block] Shield of the Righteous — "Druk 'm vóór grote fysieke klappen — hou 'm omhoog tijdens een pull."
> **Je personal defensives (deze bewaren)**
> [Schadereductie] Ardent Defender (1.5 min) — "Bewaar 'm voor de enge momenten — een grote klap of als je health laag zakt."
> [Anti-magie] Blessing of Spellwarding — "Gebruik 'm tegen zware magische schade of een grote inkomende spell."
> [Immuniteit] Divine Shield (5 min) — "Paniekknop — overleeft een dodelijke klap, maar hij dropt je threat, dus voorzichtig gebruiken."
> **Wat je kunt dispellen** — "… verwijdert Poison, Disease van een teamlid."

1. **Niet gesnapt:** *active mitigation*, *hou omhoog* (een knop omhoog houden?), *fysieke* klap (tegenover wat?),
   *pull*, *personal defensives*, *health*, *threat*, *dropt*, *dispellen*, *Poison*, *Disease*, *teamlid*.
2. **Draad kwijt:**
   - **"(1.5 min)"**: is dat hoe lang hij werkt, of hoe lang ik moet wachten? Nergens uitgelegd.
   - Hoe weet ik vóóraf dat er een "grote klap" aankomt? En of die fysiek of magisch is?
   - "Dropt je threat": ik weet niet wat threat is, dus ook niet waarom dat erg is.
   - Hoe zie ik dat een teamlid Poison heeft?
3. **Wat ik nu snap:** ik heb één knop die ik vaak druk om minder pijn te krijgen, en een paar redknoppen voor
   noodgevallen.

### Healer-toolkit (`RoleAcademy.lua:470-535`, teksten nlNL:3522-3551 en 3610-3623)
Wat ik zie op een Resto Druid (namen uit `HealerCooldowns.lua:109-114`, `:167-171`, `:224`, `:245`):
> **Je dagelijkse heals**
> [HoT] Rejuvenation / Lifebloom — "Heal-over-time — zet 'm vroeg neer en laat 'm tikken terwijl je iets anders doet."
> [Snel] Regrowth / Swiftmend — "Snelle single-target heal — je reactieknop als iemand dipt."
> [Groep] Wild Growth — "Groepsheal — gebruik als meerdere mensen tegelijk schade hebben."
> **Je cooldowns (deze bewaren)**
> [Heal] Tranquility (3 min) — "Bewaar voor een grote raid-brede klap — niet voor willekeurige schampschade."
> [Extern] Ironbark (1.5 min) — "Cast op de tank of ally die zo een grote klap krijgt."
> **Je personal defensives (hou jezelf in leven)** — [Defensive] Barkskin (45s)
> **Wat je kunt dispellen** — Nature's Cure — "verwijdert Magic, Curse, Poison van een teamlid."

1. **Niet gesnapt:** *HoT* (de uitleg "heal-over-time" helpt half), *tikken*, *single-target*, *dipt*, *raid-brede*,
   *schampschade*, *Extern*, *ally*, *cast*, *dispellen*, *Magic/Curse/Poison*.
   Andere labels die ik op andere specs zou zien: *Channel* ("Gechannelde basisheal — voedt vaak je andere spells"),
   *Slim* ("springt naar gewonde allies — top om proactief te casten"), *Schild* ("zet 'm neer net vóór de schade binnenkomt").
2. **Draad kwijt:**
   - **De defensive-regel heeft geen uitleg-zin.** Alleen een naam en "(45s)". **GEMETEN:** `RoleAcademy.lua:518-519`
     maakt die regel zonder beschrijving. Het label is Engels: "Defensive" (nlNL:3592).
   - **"(deze bewaren)"** in de kop botst met het hoofdstuk Cooldowns: *"bewaren is zonde"* en met fout 4: *"Je cooldowns
     nooit indrukken"* (nlNL:2169, 2171). Wat moet ik nu?
   - "raid-brede klap": ik ben in een dungeon. Geldt dit dan niet?
   - "Zet 'm neer net vóór de schade binnenkomt": hoe zie ik dat de schade eraan komt?
3. **Wat ik nu snap:** ik heb kleine heals, groepsheals en een paar grote knoppen voor zware momenten.

---

## Deel 3: de tank-hoofdstukken

### `ACADEMY_TANK_INTRO_BODY` — Tank-mindset (nlNL:2126)
> "Jouw taak is tempo en aandacht - niet topping damage meters. Eén rustige pull is beter dan een perfecte rotation op een dode group. Zeg pulls hardop als dat helpt: "pull over 3"."

1. **Niet gesnapt:** *tempo* (van wat?), *aandacht* (van wie?), *topping damage meters*, *pull*, *rotation*, *group*.
2. **Draad kwijt:** dit is het hoofdstuk dat moet zeggen wat een tank is, en dat doet het niet. "Tempo en aandacht"
   lees ik als "let goed op". Dat een tank wil dat vijanden **hem** aanvallen, staat hier niet. (Het Engels zegt
   "hold attention", dat is iets duidelijker; het Nederlands verliest het.) "Zeg pulls hardop": in een
   microfoon? In de chat?
3. **Wat ik nu snap:** rustig aan is beter dan snel.

### `ACADEMY_TANK_PULL_BODY` — Tijdens een pull (nlNL:2128)
> "1. Pak de pack (taunt / threat). 2. Draai vijanden van de group af waar mogelijk. 3. Gebruik één defensive bij een damage spike - bewaar de tweede voor "help". 4. Interrupt de gevaarlijke cast (vaak heal of grote hit). Je hoeft niet meteen elke ability te spammen."

1. **Niet gesnapt:** *pull*, *pack*, *taunt*, *threat*, *defensive*, *damage spike*, *interrupt*, *cast*, *ability*, *spammen*.
2. **Draad kwijt:**
   - **Hoe begin ik een pull?** Lopen, schieten, een knop? Staat er niet.
   - "Pak de pack": met welke knop?
   - "Draai vijanden af": waarom? En hoe draai je een vijand?
   - "Interrupt de gevaarlijke cast": hoe zie ik dat een vijand iets doet, en welke knop is mijn interrupt?
     (De kaart zegt het ook niet; zie hieronder.)
3. **Wat ik nu snap:** er is een volgorde van vier dingen in de eerste tien seconden.

### `ACADEMY_TANK_WIPE_BODY` — Als het misgaat (nlNL:2130)
> "Een wipe is informatie, geen oordeel. … "Was ik te ver vooruit?" … Repair, eten, opnieuw."

1. **Niet gesnapt:** *wipe*, *repair*, waarom *eten*.
2. **Draad kwijt:** "te ver vooruit" — vooruit op wie? Wat moet ik repareren, en waar?
3. **Wat ik nu snap:** mislukken is niet erg. Dat is fijn om te lezen.

### `ACADEMY_TANK_DUNGEON_BODY` — Je eerste dungeon (nlNL:2132)
> "Start normal met vrienden of guildies. Rustige pulls - twee kleine packs zijn beter dan één enorme chain. Let op mana van de healer; pauze tussen pulls. Vraag gerust om CC …"

1. **Niet gesnapt:** *normal* (tegenover wat?), *guildies*, *chain*, *mana*, *CC*.
2. **Draad kwijt:** hoe zie ik de mana van de healer? Hoe kom ik in een dungeon (aanmelden, wachten)? Staat er niet.
3. **Wat ik nu snap:** kleine groepjes vijanden tegelijk; wachten op de healer.

### `ACADEMY_TANK_RAID_BODY` — Raids en LFR (nlNL:2134)
1. **Niet gesnapt:** *raid*, *LFR*, *boss-taunt timings*, *Mythic*, *heroic*.
2. **Draad kwijt:** dit hoofdstuk is voor later, dus niet erg. Maar "boss-taunt timings" is voor mij één groot raadsel.

### `ACADEMY_TANK_CHAT_BODY` + `ACADEMY_CHAT_HINT` — Party chat (nlNL:2136-2138)
> "Klik op een regel of het kopieer-icoon, daarna Ctrl+C om in party chat te plakken."

1. **Niet gesnapt:** *party chat*, *Interrupt op [spell]*, *try*.
2. **Draad kwijt:** na Ctrl+C: hoe open ik party chat, en hoe plak ik? Wat zet ik op de plek van "[spell]"?
   En (opmerking als lezer, **AFGELEID**): de regels zijn Nederlands. Spreken mijn groepsgenoten Nederlands?
3. **Wat ik nu snap:** ik mag zeggen dat ik nog leer. Dat helpt.

### `ACADEMY_TANK_LADDER_BODY` — Angst-ladder (nlNL:2140)
1. **Niet gesnapt:** *open world*, *elites*, *instance*, *Heroic / LFR*.
2. **Draad kwijt:** niet echt. Dit is helder: vier stappen, en blijf tot het saai voelt.
3. **Wat ik nu snap:** de volgorde om te oefenen. Goed hoofdstuk.

### `ACADEMY_TANK_BOTH_BODY` — Ook heal of DPS leren? (nlNL:2142)
1. **Niet gesnapt:** *M+*, *pug*.
2. **Opmerking (GEMETEN):** de Nederlandse tekst is ouder dan de Engelse. Het Engels (enUS:2217) zegt nu dat DPS de
   zachtste tweede rol is en dat healen "de grotere sprong" is; het Nederlands zegt dat niet.

---

## Deel 4: de heal-hoofdstukken

### `ACADEMY_HEAL_INTRO_BODY` — Heal-mindset (nlNL:2145)
> "Je bent niet verantwoordelijk voor iedereen op 100% HP de hele tijd. Je taak is triage: tank levend houden, degene die bijna dood is redden, dan de rest. Schade hoort erbij - paniek-overheal leegt mana."

1. **Niet gesnapt:** *HP*, *overheal*, *mana* (wordt pas twee hoofdstukken later uitgelegd).
2. **Draad kwijt:** weinig. "Triage" wordt in dezelfde zin uitgelegd.
3. **Wat ik nu snap:** een healer houdt anderen in leven, in een vaste volgorde. Dit is de beste openingszin van alle
   hoofdstukken.

### `ACADEMY_HEAL_TRIAGE_BODY` — Triage (nlNL:2147)
> "1. Jij (als jij sterft - dode healer heal niet) 2. Tank (als de pack nog op hem zit) 3. Iemand onder ~40% of met een fatale debuff 4. De rest met efficiënte heals. Grote heal na grote damage; kleine heals ertussen."

1. **Niet gesnapt:** *pack op hem*, *debuff*, *fatale debuff*, *efficiënte heals* (welke?).
2. **Draad kwijt:** hoe zie ik een fatale debuff? Taalfoutje (**GEMETEN**): "dode healer heal niet" moet "healt" zijn
   (het hoofdstuk Positie schrijft het wel goed, nlNL:2167).
3. **Wat ik nu snap:** de volgorde jij → tank → bijna dood → de rest. Heel bruikbaar.

### `ACADEMY_HEAL_MANA_BODY` — Mana en efficiëntie (nlNL:2165)
> "Mana is je échte health-bar. … Gebruik goedkope, snelle heals voor kleine dipjes; bewaar je grote, dure heals voor echte noodgevallen. … "Oom, 5 sec" zeggen is heel normaal en professioneel."

1. **Niet gesnapt:** **"Oom"**. In het Nederlands is een oom een familielid. **GEMETEN:** "out of mana" staat nergens in
   nlNL; "Oom" komt drie keer voor (nlNL:2151, 2155, 2165) zonder uitleg.
2. **Draad kwijt — tegenstrijdig (GEMETEN, drie teksten):**
   - Dit hoofdstuk: snelle heals zijn **goedkoop**, grote heals zijn **duur**.
   - De toolkit, label *Zuinig* (nlNL:3611, 3618): *"Grotere, tragere heal … (zuiniger met mana)"*. Groot = **goedkoop**.
   - De Druid-kaart (nlNL:1265): Regrowth (in de toolkit een *Snel*-heal) *"kost veel mana"*. Snel = **duur**.
   Als beginner weet ik nu niet welke knop zuinig is. (Wat in het spel klopt heb ik niet gecontroleerd.)
   Wat moet ik drinken, en waar haal ik het?
3. **Wat ik nu snap:** mana is mijn brandstof; zonder mana kan ik niets. Sterke zin.

### `ACADEMY_HEAL_POSITION_BODY` — Waar je gaat staan (nlNL:2167)
1. **Niet gesnapt:** *bereik* (hoe ver?), *boss*, *de troep* (wat is dat: iets op de grond?).
2. **Draad kwijt:** hoe zie ik dat ik buiten bereik sta?
3. **Wat ik nu snap:** achteraan staan, iedereen zien, uit gevaar stappen, niet door muren heen healen.
   Dit is het duidelijkste heal-hoofdstuk.

### `ACADEMY_HEAL_COOLDOWNS_BODY` — Bewaar je grote cooldowns (nlNL:2169)
> "… voor grote, geplande schade - een raid-brede klap van de boss … Een cooldown op 90% van het juiste moment is beter dan eentje die je nooit indrukt. Typ /mh healcds …"

1. **Niet gesnapt:** *cooldown* (wordt nergens uitgelegd), *geplande schade* (gepland door wie?), *raid-brede*.
2. **Draad kwijt:** "90% van het juiste moment" kan ik niet lezen. Bedoel je "ongeveer op tijd"?
   De titel zegt "Bewaar", de tekst zegt "bewaren is zonde". Hoe weet ik dat er geplande schade aankomt?

### `ACADEMY_HEAL_MISTAKES_BODY` — Beginnersfouten (nlNL:2171)
1. **Niet gesnapt:** *frames* ("terwijl je naar de frames staart"), *interrupt*, *vermijdbare schade*.
2. **Draad kwijt:** "om een interrupt vragen": aan wie, en hoe? "Kies er één per run" is een fijne tip.

### `ACADEMY_HEAL_WIPE_BODY` (nlNL:2149), `_CONFIDENCE_BODY` (nlNL:2173)
1. **Niet gesnapt:** *in fire* (Engels midden in een Nederlandse zin), *efficiëntere spells* (welke?).
2. **Wat ik nu snap:** iemand laten sterven hoort erbij; een kalme healer die praat is beter dan een perfecte.
   Het hoofdstuk Iemand verliezen mag is mooi en helder.

### `ACADEMY_HEAL_DUNGEON_BODY` (nlNL:2151), `_RAID_BODY` (nlNL:2153), `_CHAT_BODY` (nlNL:2155)
1. **Niet gesnapt:** *range*, *mana spuit*, *buffen*, *Oom*, *fight-timer*, *speler-bar*, *raid cooldowns*, *prio*.
2. **Draad kwijt:** "Leer de fight-timer": waar zie ik die? Wat is buffen en moet ik dat doen?

### `ACADEMY_HEAL_LADDER_BODY` (nlNL:2157), `_BOTH_BODY` (nlNL:2159)
1. **Niet gesnapt:** *Delves* (wordt nergens uitgelegd, alleen "kleinere instance" bij de tank), *kicks*, *queue*, *pugs*.
2. **Wat ik nu snap:** eerst een vriend healen buiten, dan stap voor stap groter. Goed.

---

## Deel 5: de "Zo speel je"-kaarten (eigen venster)

Het venster (`PlayCardWindow.lua:849-1066`) toont: titel, een rij spec-icoontjes, tabbladen *Jouw knoppen /
Blijf leven / Consumables / Dispel* (soms *Groep*), dan het idee, de stappen, *Meer vijanden*, *Grootste fout*,
de hero-regels en de bronregel. Voor healer-specs komen er twee blokken bij (`:979-1008`).

### Tank: `PLAYCARD_66_*` — Protection Paladin (nlNL:1144-1153)
Namen uit de repo: 53600 Shield of the Righteous, 31884 Avenging Wrath, 375576 Divine Toll, 204019 Blessed Hammer,
31935 Avenger's Shield, 26573 Consecration, 62124 Hand of Reckoning (`KeybindRoles_Paladin.lua:133-167`).

> IDEA: "Verzamel Holy Power met snelle klappen en geef het uit aan Shield of the Righteous: dat is je harnas."
> S1 "Avenging Wrath en Divine Toll als ze klaar zijn: die starten je grote moment."
> S2 "3 of meer Holy Power: Shield of the Righteous. Houd hem bijna altijd aan."
> S3 "[275779] en Blessed Hammer op cooldown: die geven Holy Power."
> S4 "Gooi Avenger's Shield zodra hij klaar is. Sta in je Consecration; leg hem opnieuw als er niets anders klaar is."
> S5 "Trek met Hand of Reckoning, en taunt ermee zodra een vijand iemand anders slaat."
> Meer vijanden / Grootste fout / Templar / Lightsmith

1. **Niet gesnapt:** *Holy Power* (wat is het, waar zie ik het?), *klaar zijn*, *grote moment*, *op cooldown*,
   *aanhouden* (bij een knop?), *Sta in je Consecration* (ligt het op de grond?), *charges*, *Templar*, *Lightsmith*,
   *hero* (de regels staan achter een bolletje zonder kop).
2. **Draad kwijt:**
   - De kop zegt *"Je knoppen, belangrijkste eerst"* (nlNL:1129). Maar stap 1 is "je grote moment", en het harnas
     (dat mij in leven houdt) is pas stap 2. Voor een beginner-tank lijkt het harnas belangrijker.
   - De Academy zegt "Interrupt de gevaarlijke cast", maar de kaart noemt geen interrupt.
     (**GEMETEN:** volgens `KeybindRoles_Paladin.lua:133` is Avenger's Shield ook een interrupt; de kaart zegt dat niet.)
   - Ben ik Templar of Lightsmith? Moet ik kiezen? Waar?
3. **Wat ik nu snap — en dit is goud:** **S5** is de duidelijkste tankregel van alles wat ik las: *slaat een vijand
   iemand anders, gebruik dan je taunt-knop*. En het idee "Holy Power uitgeven aan je harnas" is een goed beeld.

### Healer: `PLAYCARD_105_*` — Restoration Druid (nlNL:1259-1267)
Eerst de twee extra healer-blokken:
> "**Zo heal je:** klik op de balk van de vriend die je wilt healen (je groeps- of raidframes) en druk dan de toets. Heb je niemand gekozen, dan heal je jezelf. …" (nlNL:689, 703)
> "**Zo vecht je alleen:** buiten in de wereld healt of tankt niemand voor je. Klik op de vijand en werk dan deze lijst af (dezelfde volgorde als Blizzards eigen Single-Button Assistant)." (nlNL:690-699; spells uit `HealerSolo.lua:25-31`: Sunfire, Moonfire, Starsurge, Wrath, Starfire)

Dan de kaart (namen uit `HealerCooldowns.lua:110-171`, `KeybindRoles_Druid.lua:218-221`, `HealerSolo.lua:29`):
> IDEA "Zet vroeg langzame heals op mensen en vul daarna de grote gaten met Regrowth."
> S1 "Houd Lifebloom altijd aan: op de tank, of in een raid op jezelf. Efflorescence onder de groep."
> S2 "Swiftmend op cooldown, dan Rejuvenation: die Rejuvenation komt op 3 mensen."
> S3 "Zakt iemand diep weg: Regrowth. Druk eerst Nature's Swiftness als die klaar is."
> S4 "Hoeft niemand healing? Wrath op de vijand."
> Meer vijanden: "Vóór groepsschade: Rejuvenation op 5 mensen. Dan Wild Growth en Regrowth, die is nu goedkoop. Enorme schade: Tranquility."
> Grootste fout: "Regrowth casten zonder 5 Rejuvenation uit. Dat kost veel mana en je raakt leeg."

1. **Niet gesnapt:** *raidframes* (waar op mijn scherm?), *Single-Button Assistant*, *langzame heals* (= de HoT uit de
   toolkit? andere naam voor hetzelfde), *aanhouden*, *onder de groep* (hoe zet ik iets onder een groep?),
   *op cooldown*, *Wildstalker*, *Keeper of the Grove*.
2. **Draad kwijt:**
   - **Verkeerd label (GEMETEN):** het blok over groepsschade staat onder de kop *"Meer vijanden:"* (nlNL:1130,
     `PlayCardWindow.lua:1051`). Die kop is voor elke spec gelijk. Voor een healer gaat het om meer gewonde
     vrienden, niet om meer vijanden.
   - **S3 en de Grootste fout botsen:** S3 zegt "zakt iemand weg: Regrowth". De fout zegt "Regrowth zonder 5
     Rejuvenation kost veel mana". Iemand gaat dood en ik heb geen 5 Rejuvenations: mag ik Regrowth drukken of niet?
   - "Die Rejuvenation komt op 3 mensen": ik druk één keer en hij komt op drie mensen? Waardoor?
   - S4: hoe wissel ik van een vriend naar een vijand en terug?
   - "die is nu goedkoop": waarom nu ineens?
3. **Wat ik nu snap — ook goud:** **"Zo heal je"** is precies de uitleg die ik miste: *klik op de balk van een vriend,
   druk de toets; niemand gekozen = jezelf*. En "Zo vecht je alleen" is een duidelijk lijstje.

---

## Deel 6: de Codex-artikelen

### `CODEX_AGGRO_TITLE` / `_BODY` (Codex.lua:414-415, Nederlands)
> "Aggro betekent dat een vijand jou aanvalt. De tank wil dat; een DPS of healer die het trekt, gaat vaak dood. …"
> Daarna drie instellingen: Nameplates > Aggro Display > Flash · Display Aggro Highlight (raid frames) · Audio Assist > Combat Audio Alerts > Say If Targeted.
> (De Engelse woorden komen uit `MidnightCodex.lua:52-58` of uit het spel zelf.)

1. **Niet gesnapt:** *nameplate*, *raid frames*, *specialisatie*, *Plater*.
2. **Draad kwijt:**
   - Waar is het menu? De paden beginnen bij "Nameplates", zonder te zeggen hoe ik daar kom. (De kaart doet het wel:
     *"Options > Gameplay > Interface > Raid Frames"*, nlNL:1111.)
   - Bij "Display Aggro Highlight" staat geen pad, alleen de naam.
   - **Wat doe ik als ík aggro heb** en ik ben geen tank? Naar de tank lopen? Staat er niet.
   - Hoe **krijgt** een tank aggro? Het woord *threat* (uit de toolkit) komt hier niet voor.
3. **Wat ik nu snap:** **de eerste zin is de beste definitie van tanken die ik vond.** Hij hoort eigenlijk bovenaan de
   tank-track.

### `CODEX_MPLUS_START_TITLE` / `_BODY` (Codex.lua:412-413, Nederlands)
1. **Niet gesnapt:** *loot*, *Great Vault*, *Mythic 0*, *queue*, *Font of Power*, *death*, *Keystone Deserter*,
   *Raider.IO-score*, *Timeways*.
2. **Draad kwijt:**
   - *"Zet de dungeon-moeilijkheid op Mythic voordat je naar binnen loopt"*: hoe? Die stap ontbreekt.
   - Dat er een **tijdslimiet** is, moet ik zelf raden uit "Na 10 seconden aftellen loopt de timer" en "Op tijd".
     Hoeveel tijd? Staat er niet.
   - Over tanken of healen zegt dit artikel alleen "vink je rol aan". Welke rol, en wat betekent dat in een M+?
3. **Wat ik nu snap:** een stapsgewijs pad van "geen key" naar "groep vinden" naar "starten". Duidelijk en stap voor stap,
   op die ene ontbrekende stap na.

---

## Wat ik NA het lezen wel en niet aan een vriend kan uitleggen

**Tanken — dit kan ik uitleggen:**
- Een tank wil dat vijanden hem aanvallen in plaats van de anderen (alleen dankzij de Codex en kaart-stap S5).
- Slaat een vijand iemand anders: druk je taunt-knop (kaart S5).
- Rustig aan: kleine groepjes vijanden, pauze voor de healer.
- Bewaar een paar redknoppen voor enge momenten.
- Oefen eerst met een vriend buiten, dan in delves, dan in een normale dungeon.
- Mislukken is niet erg; vraag je af wat je anders kunt doen.

**Tanken — dit kan ik NIET uitleggen:**
- Wat een pull is en hoe je hem begint.
- Wat threat is, en hoe je het houdt.
- Welke knop je interrupt is, en hoe je ziet dat een vijand iets gevaarlijks doet.
- Waar je moet staan, en waarom je vijanden "wegdraait".
- Wat een cooldown is, en of "(1.5 min)" duur of wachttijd is.

**Healen — dit kan ik uitleggen:**
- Een healer houdt de anderen in leven: eerst jezelf, dan de tank, dan wie bijna dood is.
- Klik op de balk van een vriend en druk de toets (alleen in het kaart-venster).
- Mana is je brandstof. Leeg = niets meer kunnen. Drink tussen gevechten.
- Sta achteraan, uit het gevaar, en niet achter een muur.
- Iemand verliezen hoort erbij.

**Healen — dit kan ik NIET uitleggen:**
- Welke heal zuinig is (drie teksten zeggen iets anders).
- Waar de "frames" op het scherm staan.
- Wat een debuff of dispel is en hoe je hem ziet.
- Wanneer je een grote knop moet bewaren en wanneer juist indrukken.
- Wat "Oom" betekent.

---

## Mijn eerlijke vragen die overblijven

1. Wat is een tank in één zin, en waarom staat die zin niet bovenaan de tank-track?
2. Wat is "threat"? Is "taunt" één knop, en welke is het bij mij?
3. Wat is een "pull"? Loop ik naar de vijand, schiet ik, of druk ik een knop? Wanneer is hij klaar?
4. Wat is een "pack", een "chain" en een "wipe"?
5. Wat betekent "cooldown"? Is "(1.5 min)" hoe lang hij werkt, of hoe lang ik moet wachten?
6. Moet ik grote knoppen nu bewaren of juist drukken? De kop zegt "deze bewaren", het hoofdstuk zegt "bewaren is zonde".
7. Hoe zie ik dat een vijand iets gevaarlijks gaat doen, en welke knop stopt dat?
8. Wat is "active mitigation", en wat betekent "een knop omhoog houden" of "aanhouden"?
9. Wat is een debuff? Hoe zie ik dat iemand Poison of Magic heeft?
10. Wat zijn "frames" of "raidframes", en waar staan ze op mijn scherm?
11. Wat betekent "Oom"? Voor mij is dat een familielid.
12. Welke heal is goedkoop: de snelle of de grote?
13. Waar zijn de "Guides"-tab en de "In groups"-tab? Ik zie alleen Me, Codex en Tools.
14. Wat is het verschil tussen normal, heroic, Mythic, Mythic 0, M+ en LFR?
15. Hoe wissel ik als healer van een vriend naar een vijand, en weer terug?
16. Zijn Templar, Lightsmith, Wildstalker en Keeper of the Grove keuzes? Waar kies ik ze?
17. Ik heb een chatregel gekopieerd met Ctrl+C. Hoe plak ik hem nu in de party chat?
18. Wat doe ik als een vijand mij aanvalt terwijl ik healer ben?
19. Hoe zet ik een dungeon op Mythic?
20. Waarom staat bij een healer-kaart "Meer vijanden" boven een stuk over gewonde vrienden?

---

## Cijfers: "begrijpt iemand die nooit speelde dit?"

- **Tanken: 3/10.** De tank-track legt nergens uit wat een tank is of hoe je een vijand aan je bindt; de enige
  heldere zinnen daarover staan in de Codex en op de kaart, en de rest leunt op woorden als pull, pack, taunt en
  threat die nooit worden uitgelegd.
- **Healen: 5/10.** Er staan echt heldere hoofdstukken (triage, mana, waar je staat, iemand verliezen mag), maar
  "klik op de balk van een vriend" staat niet in de Academy zelf, de teksten spreken elkaar tegen over zuinige
  heals en over bewaren, en frames, debuffs en "Oom" worden niet uitgelegd.

---

## Wat zou helpen (voorstellen, Rob kiest)

Dit zijn ideeën over de **tekst en de volgorde**, geen spelfeiten.
- Zet één regel "Wat is een tank?" bovenaan de tank-track. De zin bestaat al in `CODEX_AGGRO_BODY`.
- Zet `PLAYCARD_HEAL_HOW` ("klik op de balk van de vriend…") ook bovenaan de heal-track.
- Een klein woordenlijstje op de Academy-pagina: pull, pack, taunt, threat, cooldown, interrupt, defensive, frames,
  debuff, dispel, wipe, OOM. Of: zet de toolkit en de checklist ná het mindset-hoofdstuk.
- Haal de botsing weg tussen `ACADEMY_HEAL_MANA_BODY`, `HEALCORE_DESC_BIG` en `PLAYCARD_105_MISTAKE` (welke heal is
  zuinig?). Wat in het spel klopt moet eerst iemand meten (`mh-research`).
- Haal de botsing weg tussen "(deze bewaren)" in `HEALTOOLKIT_CDS_HEAD` / `TANKKIT_CDS_HEAD` en "bewaren is zonde".
- Een uitleg-zin bij de healer-defensive (nu alleen naam + tijd, `RoleAcademy.lua:518`).
- Kijk of de verwijzingen "Guides" en "In groups" nog kloppen (`ACADEMY_CLASS_FMT`, `ACADEMY_PREF_*_DEFENSIVE`).
- Een eigen kop voor de healer-AOE-regel in plaats van "Meer vijanden".
- Kleinigheden: "dode healer heal niet" → "healt" (nlNL:2147); "Oom" uitschrijven; `ACADEMY_TANK_BOTH_BODY` in nlNL
  loopt achter op enUS.

**Niet gelezen** (buiten de opdracht): de tab *Basis* (`TAB_REFERENCE`), *Start Here*, en de tabbladen *Blijf leven*,
*Groep*, *Consumables* en *Dispel* van het kaart-venster (behalve de twee dispel-tips die ik citeer).
