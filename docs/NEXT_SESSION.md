# Midnight Helper — waar we staan

## ✅ 29 aug — beide sporen grotendeels af

**Spoor A: de tier-tabellen zijn weg.** `TierSet.lua` leest de set van het stuk dat je draagt:
naam, telling, alle vijf de stuknamen en beide bonusteksten, al vertaald door het spel. Op
Robs scherm bevestigd. `TierSetData.lua` is nu een toelichting plus `TIER_SLOTS`, met de
instructie waarom er geen nieuwe tabel mag komen. ⚠️ **Nog ongezien:** het geval "geen tier
aan" — daar hoort de nieuwe zin te staan in plaats van een setnaam.

**Spoor B: de `fill()`-bug is opgelost bij de wortel.** `Locales/KeepEnglish.lua` maakt
"bewust Engels" uitdrukbaar, beide fill-bestanden respecteren het, en **linter-check [15]**
faalt als een pack het toch vertaalt — mét positieve controle (één waarde gebroken → check
sloeg aan en noemde de key → teruggezet → weer stil, bestand byte-voor-byte terug).
De drie Dawn-achievements staan in alle zes bestanden terug op Blizzards naam, en de vijf
crest-rangen zijn in **nlNL** Engels. Alles geverifieerd via `locale_probe.lua`, niet geteld.

### 🔵 Wat er van spoor B nog ligt

1. **esES / ptBR / itIT: crest-rangen.** Zij vertalen *Champion* wél (`Campeón`, `Campeão`,
   `Campione`); deDE en frFR houden hem al Engels. **Niet van hieruit beslissen** — iemand met
   die client moet kijken wat er op het scherm staat. → #translations.
2. **De bredere nlNL-vraag.** De crest-rangen waren één vindplaats; de regel ("geen
   Nederlandse client, dus Blizzard-termen blijven Engels") geldt breder. Er is nog geen
   inventarisatie van wat er verder in `nlNL.lua` vertaald staat dat op Carola's scherm
   Engels is. Dat is een aparte, afgebakende klus.
3. ⚠️ **`locale_probe.lua` heeft dezelfde blinde vlek als `fill()` had:** hij meldt bewust
   Engels als *"still English (a copy, not a translation)"*. Voor `KEEP_ENGLISH`-keys is dat
   op te lossen; voor per-taal-beslissingen zoals de crest-rangen niet.

## 🎯 OPDRACHT 29 aug — Robs opdracht: tier sets afmaken, en talen zodat Carola het snapt

Twee sporen, en ze komen samen: de tier-pagina is precies waar Carola "Kampioen crest"
tegenkomt. Alles hieronder is al uitgezocht — **niets opnieuw meten.**

### Spoor A — tier sets: van onderzoek naar werkende pagina

1. **De twaalf resterende setnamen uit de client halen.** Mage is al bevestigd
   (`Primal Leywarden's Attire`). Twee wegen, allebei nu open: `C_Spell.GetSpellName` /
   `GetSpellDescription` op de bonus-IDs uit DB2, of `ReadItemSetLine` op de setitem-IDs —
   die functie is 28 aug bewezen werkend met `/mh setline`.
2. **Beslissen of `TierSetData.lua` als tabel blijft bestaan.** Rob heeft het advies
   overgenomen dat hij weg moet zodra de client de naam kan leveren. Die tabel is nu drie
   keer stil verrot; dit is het moment.
3. **De bonusteksten komen uit de live tooltip** — dat deel werkte altijd al en hoeft niet
   opgeslagen te worden.

### Spoor B — talen: eerst het mechanisme, dan de woorden

1. 🔴 **`fill()` repareren, want dat is de oorzaak en niet het symptoom.** Hij leest "gelijk
   aan het Engels" als "nog niet vertaald" en overschrijft een naam die iemand expres in het
   Engels liet staan (bewijs: `itIT.lua:1012` correct, `Translations2026.lua:7376` draait het
   terug). Zolang dat zo is, is elke reparatie hieronder tijdelijk. Er is een markering nodig
   die `fill()` respecteert, plus een linter-check die eigennaam-keys bewaakt.
2. **`DAWNCREST_ACH_*` terug naar het Engels** in de/fr/es/pt/nl — achievement-namen, en die
   regel stond al in CLAUDE.md. Echte naam: `Veteran of the Dawn`.
3. **Crest-rangen per taal.** Voor **nlNL is het antwoord zeker Engels** — er bestaat geen
   Nederlandse client, dus Carola ziet altijd *Champion Crest*. Dat kunnen we zelf doen.
   ⚠️ Voor esES en ptBR **niet zelf beslissen**: iemand met die client moet kijken wat er op
   het scherm staat. Naar #translations.

📌 **Waarom dit werk waard is:** het kwam niet uit een audit maar uit Carola die een woord
zocht dat nergens bestond. Dat is de enige manier waarop dit soort fouten gevonden wordt.

**Bijgewerkt 2026-08-28 (ochtend).** Dit is het eerste wat een nieuwe sessie leest.
Alles onder "Historie" is oud logboek; alleen dit kopstuk is bijgehouden.

## ✅ 3.6.0 UITGEBRACHT — tag `v3.6.0` staat op `af5ed92` (28 aug, live)

73 commits boven `v3.5.0`. Versie, changelog, release-notes, CHANGELOG.md en de CF-description
zijn bij. Linter 0/0, alle 243 bestanden compileren. Rob 28 aug: *"we zijn al een paar uur live
met 3.6.0"*.

📌 **Meegegaan, en dus niet meer "ongecommit":** `Modules/StatCoach.lua` (`/mh stats`) en
`Modules/DispelTest.lua` (`/mh dispeltest`) zitten allebei in de tag — `docs/TESTLIJST.md`
noemde ze tot vanochtend nog lokaal. Uitgebracht ≠ getest; ze staan nog steeds op de testlijst.

## 📢 MOET IN DE VOLGENDE CF-RELEASE — Rob heeft er expliciet om gevraagd

Rob, 28 aug 09:07: *"deze aanpassingen moeten duidelijk vermeld worden als we hem naar CF
doen dus incl range, dat ie nu werkt en hoe en dat er een 5e rij bij komt als je jezelf kan
dispellen"*. **Versie nog niet gebumpt** — dat is Robs "af". Dit wordt een **minor** (3.7.0,
niet 3.6.1): er komt nieuw gedrag bij, en dat is dezelfde afweging als bij 3.2.0.

Drie dingen, en het eerste is een correctie op onszelf:

1. **De rechtsklik-dispel werkt nu echt.** 3.6.0 kondigde hem aan terwijl hij op veel
   specs stilletjes niets deed. Zeg dat hardop en zeg waarom: de knop kreeg het spell-ID
   mee, en bij een spreuk die een spec vervangt — Purify op een Holy Priest — komt dat ID
   nergens op uit. Hij cast nu op naam.
2. **De rij vervaagt als je iemand niet kunt bereiken.** Gemeten met je eigen dispel, dus
   het klopt met jouw echte range, inclusief wat een talent eraan verandert.
3. **Een vijfde rij: jezelf** — maar alleen als je een dispel hebt. Geen dispel, geen rij.

⚠️ **Bij het schrijven:** de lengteregel is dood (zie CLAUDE.md), dus schrijf punt 1 als een
echte rectificatie en niet als een bulletje. Iemand heeft twee weken gedacht dat zijn knop
kapot was.

## ✅ OPGELOST 28 aug — de rechtsklik-dispel werkt: hij moest op NAAM casten

Rob, in het spel bevestigd: *"het werkt!"* De knop cast nu `C_Spell.GetSpellName(id)` in
plaats van het ID, precies zoals HexBreak (`Core.lua:1731`). Terug te vinden in
`PartyTargets.lua`, `CastableForm` + `ApplyDispelAttributes`.

✅ **Beide helften, niet alleen de dispel.** Direct erna bevestigde Rob ook de purge op de
doelwit-helft: Dispel Magic (528) met de rechtermuisknop. Eén oorzaak, twee knoppen gerepareerd
— wat achteraf klopt, want ze deelden `ApplyDispelAttributes`.

⚠️ **Dit is een bewuste uitzondering op onze eigen regel "cast op ID, nooit op naam"** — die
regel is betaald met een hernoemde pet (`MissingBuff.lua:700`) en blijft overal elders staan.
Ze dekken verschillende soorten falen: een naam breekt bij hernoemen, een basis-ID van een
spec-vervangen spreuk (Purify op een Holy Priest) lost stilletjes nergens op. **Niet
"opruimen" naar een ID.**

### Wat de vier uur kostte, want dat is het bruikbare deel

**Het antwoord stond de hele tijd in HexBreak.** Rob vroeg op dag één of we daar niet konden
kijken. Dat bestand is drie keer geopend — voor het mechanisme, voor de vormgeving, voor de
muis — en elke keer is alleen de vraag van dát moment beantwoord. Regel 1731 stond er telkens.
🔴 **Een werkend voorbeeld op de schijf lees je één keer helemaal, niet drie keer half.**

**Wat het wél oploste: uitsluiten in plaats van gokken.** Vier klikken van Rob, links/rechts ×
rood/gewoon × wel/geen gevecht, sloten in tien minuten drie verklaringen uit:

| gemeten | gevolg |
|---|---|
| links selecteert op ELKE regel, ook rood, ook in gevecht | de gloed vreet niets — spoor dood |
| idem | combat is niet de oorzaak — spoor dood |
| links werkt met alleen `*type1`, zonder kale `type1` | de ster-vorm resolvet prima — spoor dood |

Alles wat daarvóór geprobeerd is, was een verklaring bedenken voor gedrag dat niemand had
afgebakend. **Splits eerst de knop van de actie, dan pas theorieën.**

🔴 **En twee metingen waren waardeloos om dezelfde reden:** de castlijst van `/mh glow` legt
élke spreuk vast die Rob cast, uit welke bron dan ook. Twee keer is daaruit "de klik landde"
geconcludeerd. Het bewijs dat wél werkt is de **cooldown van de spreuk** — die kan zijn eigen
toets niet nabootsen als hij hem niet aanraakt.

## 🔵 HOE HEXBREAK HET WÉL DOET — drie verschillen, gelezen 27 aug (historie — verschil 1 was het)

**Rob: bij HexBreak werkt die muisknop wél om te dispellen.** Dat is waarneming, geen aanname,
en het maakt hun `ApplySecureSpellAttributes` (`Core.lua:1716`) de sterkste bron die we hebben.
⚠️ Ik had hier eerst genoteerd dat we moesten checken of ze het überhaupt doen. Dat was mijn
aanname; die van hem wint.

**1. Zij casten op NAAM, wij op ID.**
```lua
button:SetAttribute("spell1", currentSpells[1].name)   -- HexBreak
b:SetAttribute("spell2", dispelSpell)                  -- ons: het getal 527
```
📌 Dit botst met onze eigen regel "cast by spell ID, never by name" (`MissingBuff.lua:700`,
betaald met een hernoemde pet). Beide kunnen waar zijn: een ID is stabieler bij hernoemingen,
en een naam werkt waar een override-ID niet resolvet. Meten, niet kiezen op principe.

**2. Hun attribuut-paren delen hun voorvoegsel, die van ons niet.**
Zij: `type1`+`spell1`, `shift-type1`+`shift-spell1` — telkens hetzelfde voorvoegsel.
Wij: **`*type2` mét ster, `spell2` zonder.** Zoekt de resolver bij een `*`-type ook een
`*`-spell, dan vindt hij het type wel en de spreuk niet: geen cast, geen fout, niets.

**3. Zij registreren één kliksoort, wij twee.**
`GetClickRegistration()` kiest `AnyDown` óf `AnyUp` op de `ActionButtonUseKeyDown`-cvar. Wij
doen `RegisterForClicks("AnyUp", "AnyDown")`, dus onze knop vuurt twee keer per klik.
Onzichtbaar bij targetten, niet bij een spreuk.

📌 Zij hebben dispel op LINKS en targetten op rechts — omgekeerd aan ons. **Niet overnemen:**
Rob vroeg zelf om links = targetten (25 aug, "rechts klik is inderdaad raar").

⚠️ **Wat nog niet past, en dus getest moet worden in plaats van verklaard:** Robs PURGE werkt
wél, met exact dezelfde constructie als de dispel (`*type2` + `spell2`, ID). Was verschil 2 de
oorzaak, dan zou die ook moeten falen.

**Volgorde morgen, goedkoopste eerst:** eerst de schone rechtsklik hieronder — werkt die, dan
is alles hierboven overbodig. Daarna verschil 2 (één regel: `*spell2` erbij zetten), dan 1
(naam i.p.v. ID), dan 3.

## ✅ AFGEROND 28 aug — de schone rechtsklik (historie; uitkomst staat bovenaan)

**De enige meting die nooit schoon gedaan is:** één rechtsklik op een **rode** naam, zonder
tegelijk iets anders in te drukken. Twee seconden werk, en het beslist of de dispel-knop werkt.

📌 Staat sinds 28 aug **bovenaan `docs/TESTLIJST.md`**, zodat Rob hem meeneemt zodra hij inlogt.

⚠️ **Waarom het nog niet beslist is, en dat is mijn fout.** De castlijst in `/mh glow` legt
élke spreuk vast die Rob cast, ongeacht de bron. In een bossfight drukt hij van alles in; er
stonden Holy Fire, Chastise en Halo tussen, die geen enkele knop van ons kan afvuren. Uit een
rij `Dispel Magic (528)` concludeerde ik dat de klik op de rechterhelft landde. **Dat kan die
meter niet zien** — precies de fout waar ik Rob diezelfde middag voor waarschuwde bij de
kick-probe.

**Wat wél vaststaat, allemaal gemeten:**

| | |
|---|---|
| de gloed vuurt en vult de regel | ✅ Maisara Caverns, "heel veel oplichten" |
| de rechterhelft cast | ✅ `cast Dispel Magic (528)` |
| knop-attributen | ✅ `*type2=spell spell2=527 unit=party1` |
| geometrie, in én buiten gevecht | ✅ 1695..1858 en 1858..2038, geen overlap |
| lagen | ✅ knoppen DIALOG, gloed MEDIUM — de gloed ligt eronder |
| Purify zonder debuff | doet stilletjes niets: normaal, geen bug |

Drie hypotheses zijn op die getallen gesneuveld (overlappende helften, combat die de layout
bevriest, de gloed die de rij afdekt). Ga er geen vierde bedenken vóór die schone klik.

## ✅ GEREPAREERD 28 aug — de Delves-tab reageerde niet terwijl je vloog

Rob zat op een taxi tussen twee flight points en zag "Weekly Great Vault (World)" en
"Midnight Delves" als koppen **zonder inhoud**; klikken deed niets. Na de landing was het
goed. Oorzaak: `Delves.lua` stelt een **volledige** refresh uit zolang
`GetUnitSpeed("player") > 0`, plus 3 seconden nadien — en op een taxi is dat minutenlang waar.
Een klik op zo'n sectiebalk vráágt juist een volledige refresh, dus die werd elke keer
uitgesteld tot `PLAYER_STOPPED_MOVING`.

De rem blijft; hij is terecht voor achtergrond-events (currency, quest log, POI-bursts). Een
klik draagt nu een `userAction`-vlag en slaat hem over. De 0,8s-throttle blijft wél staan.
📌 De vlag wordt gezet **vóór** de `pending`-early-return, anders wordt een klik die op een al
geplande run valt stilzwijgend opgeslokt.

**Waarom dit nooit eerder opviel:** te voet sta je binnen seconden stil en lost de rem zichzelf
op. Alleen een taxi houdt je minutenlang in beweging terwijl je in de UI klikt.

### 🔵 VRAAG VOOR DE VOLGENDE RONDE — één patroon nagekeken, één nog niet

✅ **De bewegings-rem zelf is nergens anders.** Grep op `GetUnitSpeed` / `lastMoveAt` /
`PLAYER_STOPPED_MOVING` geeft alleen `Delves.lua` en `EventProbe.lua` (een sonde, geen paneel).
Dit specifieke gat is dus gedicht waar het bestond.

❓ **Niet nagekeken: andere panelen met een throttle die een KLIK kan opslokken.** Het patroon
"gebruiker klikt → refresh wordt uitgesteld → er gebeurt zichtbaar niets" hoeft geen
bewegingscheck te hebben; elke voorwaarde die lang waar blijft doet hetzelfde. Vraag voor een
volgende ronde: welke panelen laten een klik door dezelfde wachtrij lopen als hun
achtergrond-events, en kan die klik daar verloren gaan? ⚠️ Niet blind repareren — Rob heeft
één geval gemeten, de rest is vermoeden.

## 🔵 VOLGENDE KEER — vertaalde spelnamen, en een fill() die de regel terugdraait

**Rob, 28 aug, na crests checken met Carola:** zij snapte niet dat "Kampioen crest" hetzelfde
is als de *Champion Crest* op haar scherm. Zijn punt, en het is de kern: **dat het Duits het
vertaalt betekent niet dat het Nederlands het moet.**

🔴 **De regel die hieruit volgt (staat nu ook in CLAUDE.md): de toets is wat de client van
DEZE speler toont.** Er bestaat **geen Nederlandse WoW-client**, dus een Nederlandse speler
ziet altijd Blizzards Engelse termen. Vertalen we die in `nlNL`, dan benoemen we iets dat op
geen enkel scherm bestaat. Duits en Frans zijn wél clienttalen; daar kan vertalen juist goed
zijn.

### Wat er gemeten is (28 aug, zes keys)

`DAWNCREST_TIER_*` — de crest-rangen:

| taal | Champion |
|---|---|
| deDE / frFR / itIT | "Champion" — Engels gehouden |
| esES / ptBR / nlNL | "Campeón" / "Campeão" / "Kampioen" |

Niemand heeft dat verschil ooit besloten; het is per pack anders gegroeid. **Voor nlNL is het
antwoord zeker** (Engels). Voor es/pt moet iemand met die client kijken wat er op het scherm
staat — niet uit het hoofd beslissen.

### 🔴 En twee fouten die groter zijn dan crests

**1. `DAWNCREST_ACH_*` zijn ACHIEVEMENT-namen, en die worden in vijf van de zes talen
vertaald** — terwijl CLAUDE.md dat al verbiedt ("het eigen Achievements-paneel van de speler
spreekt ons dan tegen"). De echte naam staat in Robs SavedVariables:
`achievementName = "Veteran of the Dawn"`. Fout in de/fr/es/pt/nl.

**2. `fill()` DRAAIT DE REGEL ACTIEF TERUG, en dát is het systeemprobleem.** `itIT.lua:1012`
houdt `DAWNCREST_ACH_VETERAN` bewust op `"Veteran of the Dawn"` — correct — en
`Translations2026.lua:7376` overschrijft dat met `"Veterano dell'Alba"`. Oorzaak: `fill()`
leest "gelijk aan het Engels" als "nog niet vertaald" en gaat eroverheen.

⚠️ **Gevolg: een key die je expres in het Engels laat staan is niet veilig.** De regel
"vertaal eigennamen niet" is dus niet af te dwingen door hem te volgen — er is een markering
nodig die `fill()` respecteert, of een linter-check die eigennaam-keys bewaakt. Dit raakt
vrijwel zeker meer dan deze zes keys.

📌 **Niet machinaal oplossen.** Wat de client per taal toont is een vraag voor #translations
en voor mensen met die client, niet voor ons. Wat wij wél alleen kunnen: het fill-mechanisme
repareren en een check bouwen die het bewaakt.

## 📋 `docs/TESTLIJST.md` — alles wat op Rob wacht, op één plek

Rob 27 aug: *"we gaan later alles proberen, dan maken we straks een lijstje wat ik in een keer
kan testen"*. **Bouw je iets dat hij moet bevestigen, zet het daar meteen bij** — niet in een
chatbericht dat wegscrollt. Afvinken doet hij zelf.

## 🔵 EERST MORGEN: de dispel-gloed verifiëren bij Murojin

**De gloed VUURT — dat is 26 aug bewezen.** Maisara Caverns, follower dungeon, Holy Priest:
onze regel voor Shuja Grimaxe lichtte op, tegelijk met HexBreak, en niet voor de anderen.
`/mh glow` meldde 4 van 4 containers en 4 rijen bewapend met Purify (527).

**Maar hij was onleesbaar, en de oorzaak was frame level — niet het kunstwerk.** Het aura-
vakje tekende ónder de achtergrond van ons eigen paneel; het enige zichtbare was de 2px die
eroverheen stak. Drie builds lang heb ik het kunstwerk verplaatst om een stapelvolgorde te
repareren. `Modules/PartyTargets.lua` staat nu gelijk aan HexBreak (`Core.lua:1856-1859`):

```lua
slot:SetAllPoints()                                  -- geen argument = vul je OUDER
slot:SetFrameLevel(math.max(slot:GetFrameLevel(), panel:GetFrameLevel() + 8))
```

⚠️ **Nog niet in het wild gezien.** De laatste baas van 26 aug triggerde niets. Verifieer bij
**Murojin, de eerste baas** — daar staat de disease in onze eigen tips (`DGN_TIP_MC_MUROJIN_HEALER`).
Twee losse dingen om te checken: vult het rood de hele regel, én werkt de rechtermuisknop nog.

🔴 **De les, want die kostte de meeste tijd.** Rob vroeg als eerste: *"je kan toch bij HexBreak
kijken hoe het werkt?"* Dat bestand had ik al open gehad — voor het mechanisme — waarna ik
over de vormgeving ben gaan gokken terwijl het antwoord veertien regels verderop stond. Elke
gok kostte een `/reload`. Een werkend voorbeeld op de schijf lees je niet één keer voor één
vraag.

**Ook open:** wij hebben géén rij voor Rob zelf (Umbrion), HexBreak wel. Maar `DISPEL_ALERT_FMT`
in `DispelHelper.lua` roept al een gele balk mét de naam van de debuff zodra er iets op Rob
staat — voor jezelf is dat beter dan een rij. Robs keuze, geen technische; niet bouwen zonder
dat hij het vraagt.

## ✅ 26 aug — vertaal-drift is nu meetbaar (`tools/check_drift.py`)

Uit de opdracht van de andere chat. **Zeven keys staan los**: hun Engelse zin is veranderd
nadat de vertaling gemaakt was, en `ns:L` valt alleen terug op enUS als een key *ontbreekt* —
niet als hij aanwezig is. Dus blijven vijf talen de oude bewering doen. `VALEERA_RUN_FMT` is
het scherpste geval: op 20 aug corrigeerden we "XP so far" naar "kills included", en in vijf
talen staat de ingetrokken versie er nog.

Rapport: `docs/TRANSLATION_DRIFT.md` (met de Engelse én de huidige vertaling naast elkaar).
Vaste stap staat nu in CLAUDE.md: **na elke enUS-correctie `python tools/check_drift.py`.**
De lijst gaat naar #translations — niets machinaal vertalen, drift niet met `fill()`
dichtplakken.

⚠️ **De checker leest geen Lua.** Bij het bouwen gaf een statische parser drie keer op rij een
verkeerd antwoord (keys die een regel delen; de `merge()`-blokken per taal in DelveTips/Codex;
en een "bewijs" dat 1170 fills dood waren — `fill()` overschrijft juist wél een waarde die
gelijk is aan het Engels). `locale_probe.lua` sprak hem elke keer tegen en had elke keer
gelijk. Vandaar de nieuwe `--dump`-modus: de checker vraagt het de loader.

⚠️ **Nog open in de vertaalhoek:** `tools/translation_todo.py` leest alleen `Locales/enUS.lua`
(regel 105) en is dus blind voor **901 enUS-keys in elf merge-bestanden** — `--prefix
DELVE_STORY` antwoordt "geen strings gevonden" terwijl er 48 zijn. Echte gaten daarin: de
**48 delve-verhalen** van 25 aug (alleen enUS+nlNL) plus `FOLLOWER_BOSSHINT_TITLE` en
`OMNIUM_TOAST_TITLE` in itIT. En `lint_addon.py` [5] telt 3421 enUS-keys waar de loader er
3446 ziet; twee getallen voor hetzelfde, niet uitgezocht.

## ✅ 3.5.0 UITGEBRACHT — tag `v3.5.0` staat op GitHub (23 aug)

77 commits boven `v3.4.0`. De vijf talen zijn af, Valeera's voortgang in delves, portaal-
bewust reisadvies. Description bijgewerkt. Linter 0/0.

## 🔵 25 aug — GEVRAAGD DOOR ROB: een route langs ÁLLE rares, niet alleen de openstaande

Rob wil **Coffer Key Shards** farmen door rares te killen. De bestaande routeknop stuurt hem
alleen langs rares die nog **niet** afgevinkt zijn (`FindNearestIncompleteRare`,
`Rares.lua:972`). Hij wil een tweede knop die dat filter negeert en je langs **alle** rares
van de zone stuurt.

⚠️ **Eén ding uitzoeken vóór we bouwen, want het kan de knop zinloos maken.** Ons filter hangt
aan een vlag die deze repo zelf heeft **gemeten als wekelijks** (`Rares.lua:320-338`: zes
zones sprongen op 0 bij de woensdag-reset). Als de shard-drop aan diezelfde weeklock hangt,
dan stuurt een "alle rares"-route je langs spawns die niets meer geven en doet de bestaande
knop al precies het goede.

De vraag is dus niet "kunnen we het bouwen" (dat is klein — hetzelfde routepad met het filter
uit) maar: **geeft een rare die je deze week al gekild hebt nog shards?** Rob weet dat sneller
dan wij het kunnen afleiden; vraag het hem. Zegt hij ja, dan is de knop meteen terecht en is
ons filter voor dit doel gewoon het verkeerde.

## ✅ 25 aug — de vierde Collegiate-variant, en waarom onze lijst het verloor van de client

Rob stond in Collegiate Calamity met een voortgangsbalk **"Ingredients collected"** die wij
nergens kenden, en vroeg of we de scenario's überhaupt dekken. Drie agents; de uitkomst is
belangrijker dan de ene ontbrekende variant.

**De client vertelt de variant al, en wij lazen hem al.** De delve-POI op de world map heeft
een regel `Story Variant: <naam>`. In Robs SavedVariables staan **elf gemeten varianten**
(`delveCoach.storyDaily`, regel 164293). Bevestigd op zijn scherm, 25 aug:
`Story Variant: An Elementary Antidote`.

⚠️ **Onze handgeschreven lijst was dus niet "de bron" maar de achterblijver.**
`DelveBossShowcase.lua:136` kende drie varianten voor Collegiate; de client kende er een
vierde. Zesde keer dat twee plekken dezelfde vraag beantwoorden en de niet-gerepareerde de
slechtste antwoorden geeft. **Bij een volgende "wij kennen X niet": kijk eerst of de client
het al zegt en of wij het al opslaan.**

**Wat DB2 (build 12.1.0.69497) erbij gaf.** Er zijn precies **vier** varianten, niet meer;
de vierde is nieuw in 12.1 (label "12.1 Delves" tegen "12.0 Delves" voor de andere drie).
Route: Sir Finley Mrrgglton → 10 Research Tomes → ingrediënten (balk tot 400, bronnen wegen
**2 / 20 / 35**) + 7 Envenomed Denizens. **Geen eindbaas** — de kist verschijnt als het werk
klaar is. Alle zeven talen hebben de vierde regel nu in OVERVIEW en ROUTE; de/fr/es/pt zeiden
letterlijk "drie verschillende eindbazen", dat is nu "vier varianten, drie eindbazen".

🔴 **Twee namen, en dat is geen slordigheid maar twee velden.** DB2 noemt de variant
**"Academic Antitoxin"** (CriteriaTree 230848, achievement 61726); de tooltip zegt
**"An Elementary Antidote"**. Onze matching kijkt naar de **tooltip**, dus die naam telt.
Wie hier ooit "opschoont" naar de DB2-naam breekt de herkenning.

**Nog open:**
- ❓ **De 150/4-drempel is NIET geverifieerd.** DB2 heeft een aparte "Rewards Cutoff"
  (223199): **150** ingrediëntpunten + **4** denizens zou al genoeg zijn voor de beloning,
  in plaats van 400 + 7. Dat is precies het soort tip waar MH voor bestaat, maar het is
  datamining. **Bewust NIET in de tip gezet tot iemand het in-game ziet.** Meting: begin een
  run, tel tot ~150/4 en kijk of de kist al verschijnt.
- ❓ **Een variant zonder eindbaas heeft geen plek in `DELVE_BOSS_SHOWCASE`** — die tabel
  hangt alles aan een `creatureId`. Nu vindt de matcher niets en toont niets. Dat is
  technisch juist maar leest als kapot. Nog te bedenken: een expliciete "deze variant heeft
  geen boss"-vorm, zodat stilte een antwoord wordt in plaats van een gat.
- ⚠️ `DelveTipsData.lua:36` heeft `poiId = 93419` terwijl `docs/PTR_DELVE_SCAN.md:30`
  Collegiate op `poi=8425` meet. Andere id-ruimte; valt elke keer door naar het naam-pad.
  Niet aangeraakt, maar het staat er wel.

**Rechtzetting bij deze klus:** de notitie `Oddball Ingredient` (COORDINATION.md:348) is als
ondersteunend bewijs opgevoerd dat wij achterliepen op Robs delve. Fout — die hoort bij
**Shadow Enclave** (`TwilightsBlade01 - V04`), en de hotfix van 21 aug ging over een
draaglimiet. Twee 12.1-varianten gebruiken allebei "ingrediënten". De conclusie hield stand
op ander bewijs, de redenering ernaartoe niet.

## 🟡 25 aug AVOND — dispel/purge GEBOUWD, gloed nog niet in het wild gezien

**Wat af en getest is:** de rij is gesplitst in twee secure knoppen. Links de speler, rechts
zijn doelwit; linksklik doet wat het deed, rechtsklik dispelt respectievelijk purget. Rob
testte op zijn mage: **Remove Curse (475) en Spellsteal (30449) vuren allebei**.

**Wat gebouwd maar ONGEZIEN is:** de rode gloed. `/mh glow` meldt 4 van 4 containers en vindt
de juiste spells, dus de machinerie leeft — maar niemand heeft hem ooit zien oplichten.

⚠️ **Drie redenen waarom een lege test niets bewijst, en ze zien er identiek uit:**
1. Er kwam niets dispelbaars langs. Rob bevestigde dit zelf voor één run: **HexBreak zweeg
   in diezelfde run ook**, en die gebruikt hetzelfde mechanisme. Sterke controle.
2. Het landde **op de speler zelf**. 🔴 Ons paneel toont `party1-4` en heeft **geen eigen rij**.
   HexBreak heeft die wel. Dit is een echt gat, geen bug.
3. Er is werkelijk iets stuk.

**Volgende meting:** een spec met een **magic** dispel (Holy/Disc priest, Resto-specs) in
Magisters' Terrace; de shackle van Arcanotron Custos (`1214038`) is magic. Let op WIE hem
krijgt — een follower betekent iets anders dan de speler zelf.

**Gemeten onderweg, en het klopte:** Shadow Priest heeft géén Purify Disease. `IsPlayerSpell`
filterde hem terecht weg, dus de melding "this character has no dispel" was juist. Disc en
Holy hebben hem wel. Rob controleerde dit vóór hij de dungeon inging in plaats van erna.

## 🔵 25 aug — ROB-GOEDGEKEURD, VOLGENDE BOUWKLUS: dispel/purge op de rechtermuisknop + rode gloed

**Wat Rob wil, in zijn woorden:** de addon kijkt wat *jouw spec* kan — Remove Curse, Cleanse,
Purify, Dispel Magic aan de vriendelijke kant; Purge, Spellsteal aan de offensieve — en zet de
juiste op de rechtermuisknop, afhankelijk van wáár je klikt.

**Zijn layout-inzicht, en het is beter dan wat ik voorstelde.** De rij ís al visueel in tweeën
(naam links, zijn target rechts) maar er ligt **één** klikknop overheen (`PositionClicks`,
`b:SetSize(w, ROW_H)`). Splits die in twee knoppen en alles past:

```
linkerhelft  · linksklik  -> groepslid targetten     · rechtsklik -> DISPEL hem
rechterhelft · linksklik  -> zijn target targetten   · rechtsklik -> PURGE dat doelwit
```

Beide bestaande linksklikken blijven; de rechterknop komt vrij. `ns.GetPlayerDispelIcon()` en
`ns.GetPlayerPurgeIcon()` bestaan al in `DispelHelper.lua`.

### 🔴 De rode gloed — en hoe je de 12.1-muur omzeilt

Onze API_WATCH van 24 aug concludeerde: *"je kunt groeps-dispels tonen maar niet lezen, dus
geen prioriteit, geen alarm"*. Dat klopte, en het is niet het einde. HexBreak 0.6.12 doet het
wél, en hun eigen commentaar (`Core.lua:1842`) zegt hoe:

> *"HexBreak **never reads the aura payload** or turns a secret aura value into Lua logic. The
> visual warning is attached directly to Blizzard's AuraSlot."*

**Je vraagt niets. Je laat Blizzard beslissen en je decoreert.** Een eigen container op filter
`HARMFUL|RAID` (= "door mij te dispellen"); Blizzard toont het vakje of niet; jij hangt er
statische kunst op (rode wash, gloed, driehoek, het woord DISPEL). Verschijnt het vakje, dan
verschijnt de gloed mee.

⚠️ **Statische artwork, geen scripts.** `UntrustedScriptExecution` op AuraButtons maakt
OnShow/OnHide-handlers onbruikbaar — dus geen geluid, geen logica, geen prioriteit. Alleen
texturen die met het vakje meekomen.

**Het recept, letterlijk uit hun code — de volgorde is kritiek:**

```
C_AddOns.LoadAddOn("Blizzard_AuraContainer")
AuraUtil.IsValidFilterString("HARMFUL|RAID")     -- valideren, niet aannemen
CreateFrame(..., "CustomAuraContainerTemplate")

aanmaken : SetUnit -> AddAuraSlot -> Show -> SetEnabled(true) -> UpdateAllAuras
herbinden: SetUnit -> Show -> SetEnabled(true) -> UpdateAllAuras
```

🔴 **NOOIT `SetEnabled(false)` om te herbinden** — op 12.1 wist dat de eigen AuraButtons, dus
ook onze presentatie (`Core.lua:2093`). Containers blijven staan en worden hergebruikt.

⚠️ Alles in `pcall`, en bij een fout een **reden** opslaan in plaats van stil niets doen —
anders staat er straks een gloed die nooit verschijnt en weet niemand waarom.

## ✅ 25 aug — tier-gids herschreven op gemeten data, en drie dingen die nergens staan

De uitleg in het Tier-tabblad was van **Season 1** en stuurde spelers naar The Voidspire en
The Dreamrift voor hun tokens. Alles hieronder komt uit Robs client, niet van een guide-site.

| | |
|---|---|
| S2-raid | **The Venomous Abyss**, alle 4 difficulties (uit de crest-omschrijvingen) |
| Catalyst-charge | **Venomblight Manaflux**, currency **3465** |
| Opbouw | **per personage**, ~1 per 2 weken, **cap 8** |
| Catalyst Unbound | achievement **61519** = *"Unlocked your class set bonuses"* |
| Omzetting behoudt | **item level ÉN secondary stats** |

⚠️ **Die laatste twee staan nergens gedocumenteerd.** De currency-tekst noemt alleen de
secondary stats en zwijgt over item level — en zwijgen is geen "nee". Rob zette een
Champion-schouder om en kreeg dezelfde ilvl terug. Daaruit volgt het advies dat tegen de
intuïtie in gaat: **voer de Catalyst je BESTE stuk in dat slot**, want er komt hetzelfde uit.
Het goede bewaren en een restje omzetten levert een restje met een setbonus op.

Manaflux staat nu **per character** in het alt-overzicht, met een waarschuwing bij 8/8.

**Nog open, en bewust niet verzonnen:** welke boss welk tier-stuk geeft. Vijf EJ-vangsten
kregen dat niet rond — zie het kopje hieronder. En `TIER_SPEC_BONUS` is nog een 12.0.7-datamine
uit juni; de voettekst zegt dat nu eerlijk en de links tonen live tooltips.

## 🔴 25 aug — vier keer een leeg antwoord dat niets mat

Op één middag, in de EJ-loot-vangst, allemaal dezelfde vorm: een schone, stellige, lege
uitkomst van een instrument dat niets meet.

1. "loot API missing", 43×. Eén functienaam was van namespace veranderd.
2. 5-9 items per raidboss. Het **slot-filter** van de Adventure Guide stond aan.
3. Alles Leather. Het **klassenfilter** meldde `cleared = true` en was het niet: `pcall`
   slaagde, de lijst was nog niet herbouwd. **Slagen van de aanroep ≠ slagen van het effect.**
4. De setregel-test: 115 drops, 115 tooltips leesbaar, **nul** setregels — óók in The
   Voidspire, dat gegarandeerd tier had. Stond op het punt "Season 2 heeft geen tier-set" te
   worden, náást de al gevonden "geen class-tokens". **Twee bronnen die hetzelfde zeggen voelt
   als zekerheid**; de tweede was een kapotte meter.

⚠️ **Regel hieruit: voor je "niets gevonden" opschrijft, laat het instrument eerst iets vinden
waarvan je wéét dat het er is.** Linter-check [14] heeft daarom zes testgevallen in
`tools/_probe.py`. En check [14] zelf vlagde eerst 62 pijltjes die al maanden goed renderen —
62× vals alarm leert iedereen om er langs te scrollen.

## ✅ 25 aug — bossvenster in de Abyss: GEREPAREERD en door Rob getest

Rob deed zelf LFR *The Soulcoilers* en opende het venster **vóór de eerste pull**: "Nek'zali
the Soulcoiler — The Venomous Abyss", mét stappen. De kaart-`journalInstanceID` tegen
`CUSTOM_BOSS_ENTRIES` houden vindt de raid nu bij binnenkomst. **Cisca hoeft dit niet meer.**

Twee dingen die hij er los bij vond, allebei gerepareerd:
- De **"Boss pulled"-knop** had geen vervaltijd → nu 10 s, per boss opnieuw.
- **Party targets** stond open in een 25-man raid. Er was niets kapot: `party1-4` bestaan daar
  ook (je subgroep), dus het paneel werd stilletjes "vier van de vierentwintig" en bleef
  perfect werken. Verbergt zich nu bij `IsInRaid()`.

## ~~🟡 24 aug — het bossvenster wacht op de eerste pull voor het weet waar je bent~~

**Cisca, in LFR van The Venomous Abyss:** ze opent het bossvenster en ziet een andere dungeon.

🔴 **EERSTE DIAGNOSE WAS FOUT — hier laten staan omdat hij plausibel was.** Ik schreef op dat
raids helemaal niet herkend worden, op grond van `DefaultDungeon()` → dungeon van de week →
`windrunnerspire`, en `DungeonForCurrentInstance` die alleen `GetDungeonRoster()` doorzoekt.
Dat klopt als code-observatie en het is de verkeerde conclusie: raids registreren zich als
`ns.CUSTOM_BOSS_ENTRIES` (`RaidCoachData.lua:170`) en het venster springt naar de juiste boss
op **`ENCOUNTER_START`** via de encounter-id. Wat Cisca nu ziet — Nek'zali the Soulcoiler — is
dus **correct**. Rob controleerde het en zei "klopt, het is die abyss raid".

**Het echte gat, kleiner en preciezer:** tussen *binnenlopen* en *de eerste pull* weet het
venster het nog niet en toont het `DefaultDungeon()`. Dat is het moment waarop je hem juist
openslaat om te kijken wat je te wachten staat.

**De reparatie is één opzoeking.** `DungeonForCurrentInstance` haalt al de
`journalInstanceID` van je kaart op (`EJ_GetInstanceForMap`) en vergelijkt die met de
dungeon-lijst. Diezelfde id ook tegen `CUSTOM_BOSS_ENTRIES` houden vindt de raid bij
binnenkomst — `RaidCoachData.lua:57` noemt journalInstanceID **1320** voor The Venomous
Abyss, dus de data ligt er al.

⚠️ Buiten een instantie is "dungeon van de week" een prima standaard — die niet weghalen.
⚠️ En blijft er een instantie over die we écht niet kennen, dan is "deze ken ik niet" +
`GetInstanceInfo()`-naam nog steeds beter dan zelfverzekerd iets anders tonen.

## ✅ 24 aug — de Bountiful-log: vier bronnen, en de toewijzing was schoon

61 loot-momenten, 17 met winst: 8 mét chunk (positieve controle), **9 zonder**. Nul
meervoudige momenten met winst, dus niets was dubbelzinnig.

| bron | bedrag |
|---|---|
| Chunk uncommon / rare / epic | 2.437 / 4.875 / 12.188 |
| **Boons** (Vigor, Potency, Temperance, Possibilities) | 3.250 |
| **26.000-tier:** `Insect Shedding`, `Rootlight Lamppost`, `Tattered Clothes` | 26.000 |
| **`Griftah's Token of Appreciation`** | **54.600** |

📌 Die drie 26.000-items klinken als opraapbaar rommelgoed in delves. Als dat klopt is het
een categorie en geen toeval — maar dat is een vermoeden uit namen, niet gemeten.

⚠️ Niets hiervan wordt hardgecodeerd. De teller werkt op effect en vangt deze items al; een
lijst zou alleen kunnen verouderen. Dit staat hier als **kennis**, niet als data.

## ✅ 25 aug — OPGELOST: **doden geeft zelf Valeera-XP**. Vierde bron.

De +104 van gisteren is verklaard. Rob deed de schone test: delve in, **alleen gedood, niets
opgeraapt**, en haar stand ging omhoog.

✅ **De controle hield.** `/mh chunklog` stond aan, dus de sleutel `ns.db.chunkLog` bestónd
in het bestand — en er stonden **nul** loot-momenten in. Dat onderscheid is het hele punt:
"geen sleutel" betekent dat de log uitstond, "sleutel met nul rijen" betekent dat er
werkelijk niets is opgeraapt. Alleen het tweede bewijst iets.

Dus de bronnen zijn nu: **chunks · Boons · rijke vondsten · kills.**

⚠️ **De teller mist kills per definitie** — die hangt aan `CHAT_MSG_LOOT`. Dat is geen bug
om te repareren: het getal heet "opgepakt" en kills pak je niet op. Het **XP-getal** ernaast
klopt wél altijd, want dat is het verschil in haar stand.

📌 Wat er wél fout was: de tekst zei *"het is allemaal loot, dus maak alles open"*. Dat is nu
onwaar én het gaf verkeerd advies — je hoeft niet alleen op te rapen, je moet ook niet alles
voorbijlopen. Herschreven in zeven talen; de runregel zegt nu "XP tot nu toe, kills
meegerekend".

## ~~🟡 24 aug — OPEN: Valeera's stand stijgt zónder loot (+104)~~

Rob deed midden in een Bountiful een `/reload` en zag daarna zijn stand van **204.099 naar
204.203** gaan — 104 XP — terwijl de runregel "nog niets" bleef zeggen. Hij had na de reload
alleen mobs gedood en geen enkele Boon opgeraapt.

Twee verklaringen, allebei plausibel, en ze zijn te onderscheiden:

1. **Kills geven zelf XP**, los van loot. Dan mist onze teller die per definitie — hij hangt
   volledig aan `CHAT_MSG_LOOT`.
2. **Het venster van 1 seconde in de teller is te kort.** We lezen haar stand 1,0 s na de
   lootregel; landt de reputatie later, dan meten we "geen verandering" en telt het niet.

⚠️ 104 past bij geen enkel bekend bedrag (2.437 / 4.875 / 12.188 / 3.250 / 26.000), wat
pleit vóór verklaring 1 — maar dat is een vormargument, geen meting.

**De test:** dood een mob en loot *helemaal niets* — autoloot uit, lijk laten liggen. Stijgt
de stand alsnog, dan is het kills.

✅ **Raakt de release niet.** Het XP-getal in de popup komt rechtstreeks van haar stand en
klopt dus altijd; alleen de teller is conservatief, en dat staat er zo bij.

## 🔴 24 aug — OPEN: "other continent" voor een zone waar je naartoe kunt lopen

**Zit in uitgebrachte versies.** Rob stond in Silvermoon City (2393) met een delve-doel in
Eversong Woods (2395) en kreeg *"other continent — travel back, head for Portal to Harandar"*.
Silvermoon City heeft een eigen coördinatenstelsel, dus `GetWorldPosFromMapPos` geeft er
werkelijk een ander continent voor terug — en wij sturen je naar een portaal terwijl je de
stad uit moet lopen.

✅ **Wat de `/mh arrow`-uitdraaien wél bewezen:** de route is onschuldig. Het doel is vóór en
ná een portaal identiek (`Collegiate Calamity`, map 2393). `RouteNearestDelve` draait alleen
op een klik en herberekent nooit vanzelf. Wat wisselt is wie tekent: TomTom verbergt zijn
pijl zodra het doel op een andere kaart ligt, wij nemen het over, en dán valt deze zin.

🔴 **Poging 1 (`71833d6`) WERKT NIET.** `OneContainsTheOther` via
`GetMapInfo().parentMapID` zou 2393-in-2395 moeten vangen; na Robs reload was het bericht
onveranderd. De wijziging is daarmee **inert** — hij zet alleen iets uit dat kennelijk nooit
aan gaat. Niet teruggedraaid, wel als onbewezen gemarkeerd.

⚠️ **Drie kandidaten en ze zijn van buitenaf niet te onderscheiden:** (1) `parentMapID` van
2393 is niet 2395, (2) het doel in de route heeft een andere mapID dan gedacht, (3) de zin
komt uit een andere tak dan `unreachable`. Daarom drukt `/mh arrow` nu **beide kaarten, hun
continent-id én hun oudersketen** af. Eén screenshot beantwoordt welke van de drie het is.

### ✅ 28 aug — die screenshot is er, en hij wijst een VIERDE oorzaak aan

Rob draaide `/mh arrow` staand in **Silvermoon City (2393)**. Uitkomst:

- ❌ **Kandidaat 1 is dood.** De ketenregel leest `2393 -> 2395 -> 2537 -> 13 -> 947 -> 946 -> 0`:
  de ouder van Silvermoon City **is** Eversong Woods. En de containment-check zelf drukte
  "een ligt in de ander: **ja**" af, dus die werkt.
- ⚠️ **Deze run reproduceert de bug niet** — het delve-doel was de *Portal to The Coiled Isle*,
  op 2393 zelf. Geen doel in Eversong, dus geen "other continent". Geen weerlegging.

🔴 **Maar de uitdraai zegt ook: "wij staan opzij voor TomTom: geen pijl EN geen doorschuiven."**
En `ARROW_OTHER_CONTINENT` bestaat op **precies één plek**: het label van onze eigen pijl
(`NativeArrow.lua:404-409`, geverifieerd met een grep over Modules + Core + UI — geen chatregel,
geen paneel). Draait TomTom, dan tekenen wij dat label nooit, **en dan kan geen enkele
reparatie eraan iets veranderen.** Dát is waarom `71833d6` inert leek: niet omdat de fix fout
is, maar omdat de tak niet loopt.

🔴 **Dit is dezelfde fout voor de derde keer, en CLAUDE.md waarschuwt er sinds 19 aug voor:**
*"Do not hang information on the arrow's label"* — geschreven na de rare-hints, om precies
deze reden. De echte reparatie is dus **niet** een betere continent-check maar de zin uít het
pijllabel halen (chat, zoals `ns.StartRareArrivalWatch` doet). Zolang hij daar staat is hij
onzichtbaar voor iedere TomTom-gebruiker, en dat zijn bijna al Robs testers.

**Wil iemand hem tóch nog reproduceren:** TomTom uit (of `/mh arrow` tot "onze pijl getekend:
ja" leest), staand in Silvermoon, met een delve-doel in **Eversong Woods** — niet op de
Coiled Isle.

⚠️ Ook onbekend: welke kant Rob getest heeft. Vanuit **Harandar** is "travel back" correct
gedrag — dan is er niets mis en meet je niets. De test moet vanuit **Silvermoon** met een
doel in **Eversong Woods**.

## ✅ 25 aug — addon-ronde schoon, en een meetles voor de volgende keer

128 addons, 33 aangeraakt in 28 uur. Bijna alles dagelijkse ruis: 13 RaiderIO-databases,
HandyNotes-varianten, Baganator/Syndicator/Auctionator, MDT 6.2.8, SimplePartyTargets 1.3.0.1.

**JustAC 5.3.4 → 5.3.7** (drie versies op één dag) is de enige die ertoe doet — dat is onze
kandidatenbron voor interrupt- en dispel-ids. **Geen gat gevonden.** Kick, Spear Hand Strike,
Mind Freeze en Counterspell staan er allemaal, en meerdere citeren JustAC al in het
commentaar. Soothe/Devour Magic/Consume Magic staan bewust níét in `OFFENSIVE_PURGES`, elk
met eigen reden (`DispelHelper.lua:411-421`).

⚠️ **MEETLES, want dit gaat elke ronde terugkomen.** Mijn eerste vergelijking meldde 26
ontbrekende ids en dat was twee keer het verkeerde instrument:
1. **Asymmetrische regex** — JustAC op `\d{3,7}`, wij op `\d{4,7}`. Elk id van drie cijfers
   (408 Kidney Shot, 853 Hammer of Justice) kwam daardoor onterecht als ontbrekend boven.
   Ze stáán er, en 853 zelfs mét `id = 853` erbij.
2. **Onze tabellen zijn op NAAM gesleuteld**, niet op id (`["Kick"] = { role = ... }`). Een
   id-diff kan er per definitie niets in vinden.

Plus ruis: `2024` uit hun copyrightregel, acht Arcane Torrent-varianten (racial), en
pet-spells. **Vergelijk op naam, of controleer gericht — niet met een id-diff.**

## 🟡 24 aug — addon-update-ronde: GTFO 6.9 kent 20 hazards die wij niet hebben

Rob werkte de CF-addons bij. Vier vanochtend (WIM, Platynator, MidnightMountTooltip,
**GTFO 6.9**), DBM-Midnight/-Raids/-Lairs staan sinds 2 dagen op **12.1.5**.

`GTFO_Spells_MN.lua` heeft **111** Midnight-hazard-ids; **20** komen nergens voor in
`Modules/HazardData.lua`:

`1222129` Writhing Vines (Rotmire) · `1283290` Noxious Ground (Zul'jan) · `1285145` Water
Hazard · `1285733` Brambles · `1285890` Return To The Track! · `1286785` Vile Spew ·
`1290672` Clutchspew (Vassti) · `1291461` Virulent Fumes (Vashnik) · `1291780` Venom Deluge
+ `1292010` Oozing Poison (Malformed Leviathan) · `1292552` Congealed Gore + `1292807` Stir
the Depths + `1309471` Noxious Slick (The Twin Fangs) · `1296667` Caustic Residue (Sszorak) ·
`1297338` Deadly Venom · `1297650` Spreading Flames (Trader Gebbo) · `1298591` Defiled Ground
(Zul'jan) · `1301104` Noxious Spittle (Susarikk) · `1306858` Warden's Protection (Doomscale
Warden) · `1310500` Aftershock (First Mate Nama)

⚠️ **Dit is kleiner dan het lijkt, en dat moet erbij.** Sszorak en The Twin Fangs staan al in
`RaidCoachData.lua` (The Venomous Abyss), en `RAID_BOSS_SSZORAK_STEPS` gebruikt `1285733`
zelfs al. Het is dus een gat in de **hazard-lijst**, niet in onze kennis van de content.
Malformed Leviathan en Susarikk kennen we uit `Rares.lua` / de Codex.

⚠️ **GTFO is een kandidatenbron, geen bewijs** (CLAUDE.md). Deze 20 ids gaan pas de code in
nadat de client ze bevestigt. Niet overtypen.

## 🟢 24 aug — THE RING OF GLORY VOLLEDIG GELOPEN, TIER 11: de hele gauntlet gemeten

Rob liep hem uit op **Tier 11** (Frost Mage, solo, géén Bountiful). Onze tekst zei al *"one
variant is a gauntlet of duels"* en dat klopt — wat ontbrak waren **de tegenstanders**. Dit
staat voor zover bekend nergens online; Wowhead had voor Crushfoot drie spelerscomments van
6-12 dagen oud en verder niets.

**De volgorde zoals hij hem kreeg**, elk met de objective-tekst van het spel zelf:

| # | objective | tegenstander(s) |
|---|---|---|
| 1 | (terrein leegmaken) | 4 nemeses + 1 elite |
| 2 | `0/1 Crushfoot defeated` | **Crushfoot** (npc 265686) |
| 3 | `0/1 Bluegill Brothers defeated` | **Lurgle** + **Smurgle** + 3× **Bluegill Tagteam** |
| 4 | `0/1 Brinebeater defeated` | **Brinebeater** |
| 5 | `0/1 Guth'kar defeated` | **Guth'kar the Bound** |
| 6 | `0/3 Arena champions defeated` | **Hexspitter Zit'ka**, **Za'rema the Slicer**, **Ka the Mad** |
| 7 | — | **Drakta** (eindbaas) |

⚠️ Eén run, één tier, één speler. Of de volgorde vast is, of fase 1 altijd terrein-leegmaken
is, en of er meer tegenstanders in de pool zitten: **niet gemeten**. Hij kreeg wel een leven
terug onderweg (❤️ 1 → 2).

**Crushfoot — GEMETEN:** zijn charge is **te CC'en** (Rob, Frost Mage). Dat bevestigt
Wowhead-comment dlbert2000 ("You can CC him while he's casting his charge... you can also get
a lucky Valeera stun"). De twee **portals met blauwe orbs** (NO en ZW, je teleporteert naar
de andere toren) uit comments van Syrick en Tempurus: **niet getest**, hij kwam er niet aan
toe. ZW zou hoog liggen en niet voor elke klasse bereikbaar zijn.

**Drakta — geleend werd gemeten, op één punt na:**
- ✅ **Soul Cleave** bestaat, met de cirkel
- ✅ er zijn **pilaren**
- 🔴 de **pull** is er, maar Rob kon er niet op reageren — "of te laat gezien, of hij pullt
  heel snel". Onze tekst zegt *"break line of sight behind a pillar"*: dat is **reactief**
  advies uit een groepsgids, en solo ben je altijd het doelwit én kun je de cast niet zien
  (12.1 verbergt vijandelijke casts). **Onuitvoerbaar advies — zelfde familie als de
  Knowledge die je niet kon uitgeven.** Herschrijven, maar de tactiek is Robs beslissing,
  niet iets om te verzinnen.

📌 **Te doen:** `DELVE_TIP_RINGOFGLORY_OVERVIEW` herschrijven in 7 talen. Nu staat er "drie
varianten" met twee eindbazen; het is een gauntlet met een wisselende reeks. Het voorbehoud
"per Method and Icy Veins — not yet measured" mag eruit voor Soul Cleave en de pilaren.

## 🔴 24 aug — DE GROEPS-DISPELHELPER IS IN 12.1 NIET TE BOUWEN ZOALS GEPLAND

Rob installeerde **HexBreak 0.6.12 Beta** (dispel-interface voor 12.1 S2, GPL-3). Het
antwoord op "hoe leest hij andermans auras in 12.1" is: **hij leest ze niet.**

Hij laadt `Blizzard_AuraContainer`, maakt een `CustomAuraContainerTemplate`, bindt die aan
een tegel (`SetUnit` → `AddAuraSlot` → `SetEnabled` → `UpdateAllAuras`) en laat **de game
zelf** de dispelbare debuffs tekenen. Filter: `"HARMFUL|RAID"`, eerst gevalideerd met
`AuraUtil.IsValidFilterString`. De addon krijgt de inhoud nooit te zien.

🔴 **En daar zit de muur.** Uit zijn eigen commentaar (Core.lua:1905):

> *"12.1 applies UntrustedScriptExecution to AuraButtons. Addon-installed OnShow/OnHide
> handlers therefore cannot be used as a reliable self-alert trigger while auras are secret."*

En zijn changelog **0.6.11**: Priority Target System **compleet verwijderd** — PRIO-balk,
P1/P2/P3-nameplates, raidmarkers, HBPRIO-macro, keybinds, `Bindings.xml` eruit. In 0.6.12
nog steeds weg. Iemand heeft dit dus gebouwd en er weer uitgesloopt.

**Gevolg voor onze roadmap.** [[mh-market-position]] noemt de dispel-helper de sterkste
volgende bouwklus en [[healer-initiative]] punt 3 vraagt erom. In 12.1 kun je groeps-dispels
wél **tonen** en niet **lezen** — dus geen prioriteit, geen "deze eerst", geen alarm, en geen
uitleg. Onze hele meerwaarde is uitleggen. **Die feature is in deze vorm dood tot Blizzard
het opent.**

✅ **Wat wél overeind blijft, en al gebouwd is:** `Modules/DispelHelper.lua` doet
uitdrukkelijk alleen *jouw eigen* debuffs, met de school uit `dispelName` van de game zelf,
en meldt onleesbaar i.p.v. "niets". Dat is precies het stuk dat HexBreak niet kan en wij wel.
Geen overlap; niet nabouwen wat hij doet.

📌 **Bewaard voor als we ooit een groepsweergave willen:** het recept hierboven werkt
aantoonbaar in een draaiend addon. Het is een weergave, geen databron.

## 🔵 ROB VRAAGT — 24/25 aug (hij is twee dagen vrij)

### 1. 🔴 Tier set — de TEKST is af, de DATA is nog Season 1

✅ **De klacht hieronder is achterhaald en dat is 28 aug gecontroleerd in het bestand.**
`TIER_GUIDE_BODY` noemt Voidspire en Dreamrift niet meer; er staat *"The Season 2 raid is
The Venomous Abyss"*. Ik gaf dit die ochtend nog als openstaand door zonder te kijken —
dezelfde fout als bij HexBreak, en dit keer in ons eigen bestand.

🔴 **Wat er WEL fout is, en het is groter.** `Modules/TierSetData.lua:6-7` zegt het zelf:
*"namen + IDs uit Wowhead 12.0.7-PTR (research 16 jun)"*. Dat is **Season 1**. Dus de
setnaam per class (`TIER_SET_BY_CLASS`, 13 stuks) en alle 2/4-set-bonus-spell-IDs
(`TIER_SPEC_BONUS`, ~38 specs) zijn die van vorig seizoen, terwijl Rob sinds 18 aug in
Season 2 zit. Dát is waarom hij en Cisca er niet uitkwamen: we tonen ze de verkeerde set.

📌 **De bonus-TEKST zelf is niet fout** — die komt uit de live spell-tooltip (`TierSet.lua`
regel 7-9), dus wat je ziet als je hovert klopt altijd. Fout zijn de **setnaam** en **welke
spell** we linken.

✅ **28 aug gedaan, zonder client:** de voetnoot zei vrijblijvend *"may still be last
season's"*. Dat is te zacht nu we het weten. `TIER_FOOTER` en `INFO_DRAWER_BODY_TIER`
zeggen nu dat de setnaam en de links uit Season 1 komen en dat je je eigen uitrusting moet
geloven boven ons. enUS + nlNL bij; de vijf andere talen staan als drift in
`docs/TRANSLATION_DRIFT.md` (nu 9 keys) — die gaan naar #translations.

🔵 **Wat nog moet, en wat het nodig heeft.** De echte reparatie is de S2-setnamen en
bonus-IDs ophalen. Bron-volgorde: eerst de client (die settelt het), wago.tools/DB2 als
kandidatenlijst. ⚠️ **Niet uit Wowhead overtypen zoals in juni** — dat is precies hoe deze
tabel S1 werd en drie maanden S1 bleef zonder dat iemand het merkte.

### 🔴 CORRECTIE 28 aug — SEASON 2 HÉÉFT TIER SETS. Onze metingen klopten, onze conclusie niet.

**Ik was op weg naar "The Venomous Abyss heeft geen class tier set". Dat is fout.** Er zijn
gewoon 13 sets; ze zijn alleen **geen bossdrop**. Je krijgt **tokens** en ruilt die in bij
**Kirana**, naast de Catalyst in Silvermoon. Daarom stond er niets in de loot-tabel, en daarom
zag Rob geen set-ingang onder Ula'tek — precies wat we maten, met de verkeerde uitleg erbij.

🔴 **En de tokens zaten al in onze eigen data.** Mijn analyse filterde op items in de vijf
harnasslots; een token heeft **geen slot**, dus alle 50 slotloze items gingen de prullenbak in.
Uit Robs `tierScan`, per class:

| harnastype | tokenfamilie | classes |
|---|---|---|
| Cloth | **Venomwoven** | Mage, Priest, Warlock |
| Leather | **Venomcured** | Rogue, Monk, Druid, Demon Hunter |
| Mail | **Venomcast** | Shaman, Evoker, Hunter |
| Plate | **Venomforged** | Warrior, Paladin, Death Knight |

Vijf per familie + één omni-token, met de encounter waar ze vallen:

| encounter | token | cloth / leather / mail / plate |
|---|---|---|
| 2871 | Relic | 270918 / 270919 / 270920 / 270921 |
| 2887 | Effigy | 270914 / 270915 / 270916 / 270917 |
| 2874 | Idol | 270910 / 270911 / 270912 / 270913 |
| 2894 | Remnant | 270922 / 270923 / 270924 / 270925 |
| 2882 | Icon | 270926 / 270927 / 270928 / 270929 |
| 2895 | **Slumbering Coil Curio 270909** | alle classes |

⚠️ **2883 en 2888 geven geen token.** Alle bovenstaande item-IDs en namen komen uit **Robs
client**, niet uit een datamine.

**De 13 SETNAMEN komen wél van buiten** — wago.tools `ItemSet` 2055-2067, build 12.1.0.69497.
Dat is Blizzards eigen DB2, dus sterk, maar het is **niet de client**. Vóór ze in
`TierSetData.lua` gaan: laat de client ze bevestigen (de bonus-spell-IDs staan erbij, dus
`C_Spell.GetSpellName`/`GetSpellDescription` is één ronde).

✅ **DE MAGE-SET IS HELEMAAL BEVESTIGD, uit de client, via de Catalyst.** Rob legde een
legs-stuk in (Pyrewalker's Treads, ilvl 295) en het voorbeeld gaf **item 271563 "Primal
Leywarden's Tailored Legwraps"** met het volledige setblok erin:

- **`Primal Leywarden's Attire (1/5)`** — exact de DB2-naam van set 2060, nu uit het spel.
- **De vijf stukken:** Crest of the Primal Leywarden · Primal Leywarden's Manashapers ·
  Crown of the Primal Leywarden · Primal Leywarden's Tailored Legwraps · Primal Leywarden's
  Manaflux. ⚠️ Alleen van de Legwraps staat het slot vast (het stuk zelf is Legs); de andere
  vier niet toewijzen op naam — "Crest" en "Crown" zíjn geen bewijs van chest en head.
- **De bonusteksten van Frost Mage, woordelijk:** *(2) Set: Each stack of Freezing Shattered
  has a 4% chance to generate an Icicle. Glacial Spike damage increased by 20%.* · *(4) Set:
  Casting Glacial Spike has a chance to rapidly generate 5 Icicles over 1 sec. Shatter damage
  increased by 5%.*

📌 Ook meegekomen: **295 → 295** en +85 Haste / +104 Versatility onveranderd — tweede
bevestiging van zowel het item level als de secundaire stats.

⚠️ **Naamverwarring om te vermijden:** *Primal Leywarden's **Manaflux*** is een setstuk;
*Venomblight **Manaflux*** is de Catalyst-currency (3465). Twee verschillende dingen.

Twaalf sets te gaan. Robs Catalyst geeft ze alleen voor zíjn class, dus de rest moet via
`C_Spell` op de bonus-IDs of via de setline-toets hieronder. ⚠️ Icy Veins schrijft *"Jade
Warrior's Dominion"* waar DB2 **"Jade Warlord's Dominion"** zegt — overtypen van een gids is
precies hoe deze tabel in juni Season 1 werd.

📌 **Twee dingen uit de officiële patch notes** (news.blizzard.com, Curse of Ula'tek):
*"Class set vendor Kirana has relocated… near the Catalyst in Silvermoon… in exchange for
Slumbering Coil Curios"* en *"Class set armor now inherits the secondary and tertiary stats as
well as certain special cantrip effects."* Dat laatste bevestigt onafhankelijk wat het
Catalyst-venster zelf zei (zie `docs/TESTLIJST.md`), en het voegt **tertiair + cantrips** toe.

⚠️ **Nog niet vastgesteld:** welk token bij welk slot hoort (head/schouder/borst/handen/benen),
en wat Kirana per stuk rekent.

### ⚠️ `/mh ej save` alléén kan dit niet beantwoorden — maar `/mh tierscan` wel

Rob draaide het en herlaadde. De capture is inmiddels **wél** een loot-capture (die tak is
na 24 aug toegevoegd): `ejCapture` in zijn SavedVariables telt 12 instances en 268 items,
waarvan **The Venomous Abyss (1320) 8 bosses en 114 items**. Encounter-IDs client-bevestigd:
**2871, 2874, 2882, 2883, 2887, 2888, 2894, 2895** — dat komt overeen met
`docs/PTR_S2_ENCOUNTERS.md`.

🔴 **Maar er zit geen tier in.** De 21 harnasstukken in de vijf setslots zijn gewone
raid-armor (*Ruthless Slaughtergrips*, *Ophidian Fangmail*, *Coiled Hex Legguards*); ze
delen geen setnaam, in geen van de vier harnastypes. Class sets zitten in de Encounter
Journal achter een **apart filter** en dat stond bij deze capture niet aan. En elk
`setLine`-veld is leeg met dezelfde reden: *"cannot see one on unowned items"* — de EJ geeft
setlidmaatschap niet vrij voor spullen die je niet bezit.

**Twee routes die wél kunnen, in deze volgorde:**
1. **Het class-set-filter aanzetten in de capture** (`EJ_SetLootFilter` / de class-tab) en
   opnieuw opslaan. Dan staan de 13 sets er per class in, uit de client.
2. **Van een gedragen tier-stuk lezen.** `TierPiecesEquipped` haalt de "(n/5)"-regel al uit
   de item-tooltip; op diezelfde regel staat de setnaam. ⚠️ Werkt alleen als de speler er
   één draagt — en dat is precies wanneer de pagina het minst nodig is.

📌 **Rob heeft 28 aug het advies overgenomen dat de hardgecodeerde tabel weg moet** zodra de
client de naam kan leveren. Route 1 haalt de data uit de client maar houdt een tabel; route
2 heeft geen tabel maar ook geen antwoord voor wie nog niks draagt. Waarschijnlijk allebei:
lees het van een gedragen stuk, val terug op wat de capture opleverde. Niet bouwen terwijl
Rob niet kan testen.

⚠️ **En overweeg of dit überhaupt data moet zijn.** Een hardgecodeerde tabel die per seizoen
verrot is drie keer stil fout gegaan in deze repo. De teller leest de setnaam al uit de
item-tooltip (`TierPiecesEquipped`, "(n/5)"); als de client de naam kan geven, hoort onze
tabel te verdwijnen in plaats van jaarlijks bijgewerkt te worden.

⚠️ **Wat we NIET weten en niet mogen verzinnen:** welke Venomous Abyss-boss welk token-slot
laat vallen, en of de Catalyst-kant nog klopt (Eldara Dawnrunner, quest 'Taste True Power',
Dawnlight Manaflux, "eerste lading week 1 daarna elke 2 weken"). Die hele alinea is
ongecontroleerd sinds S1.

🔴 **GEMETEN 24 aug: `/mh ej save` LEGT GEEN LOOT VAST.** Rob heeft het gedraaid; het blok
staat op regel 31166-32110 van zijn SavedVariables en bevat instances → bosses → creatures
met display-ids, en **nul** itemIDs. De 64 `itemID`-regels in dat bestand horen bij
`tradingPostCache`, een andere sectie. `EncounterCapture.lua` roept `EJ_GetLootInfo*` nooit
aan. Deze meting kan de token-vraag dus niet beantwoorden.

**Wat er wél voor nodig is:** een loot-tak in `ns.CaptureEncounterJournal` die per boss
`EJ_GetNumLoot` + `EJ_GetLootInfoByIndex` uitleest. Kleine, afgebakende toevoeging; daarna
één `/mh ej save` + `/reload` en het antwoord staat er.

⚠️ Vier sondes op rij sliceden dit bestand verkeerd (900k-terugval, 1-regel-blok, verkeerde
sectie) omdat ik op inspringing probeerde te knippen. **Het SavedVariables-bestand heeft
GEEN inspringing.** Accolades tellen vanaf de sleutel is de enige grens die het heeft.

✅ **Bonus uit dezelfde capture — de Season 2-roster, uit de client:** Altar of Fangs (1322:
Rav'i, The Writhing Coil, Zul'jan), Den of Nalorakk (1311), Murder Row (1304), The Blinding
Vale (1309), Voidscar Arena (1313), **The Tidebound Grotto (1317)**, **The Venomous Abyss
(1320)**, plus Kings' Rest / Ruby Life Pools / Temple of Sethraliss. Dat is precies de
Spec 01-lijst die nog open stond (Altar of Fangs + Tidebound Grotto), nu met
client-bevestigde bossnamen en encounterIDs.

De Catalyst-vragen blijven een aparte bron (NPC in Silvermoon), niet uit de EJ.

## 🟢 24 aug — WAAROM VALEERA-XP PER DELVE VERSCHILT: het zijn Chunks

Rob installeerde **Delve Companion XP Tracker v0.3.0**. Dat beantwoordt de vraag waarop we
gisteren de run-schatting geschrapt hebben, en Rob had het bij het rechte eind: het hangt af
van wat je oppakt.

Valeera-XP komt uit **Companion Experience Chunks** — losse voorwerpen in de delve, in drie
zeldzaamheden. Het addon leest de rarity uit het **item-id** en niet uit het XP-bedrag,
juist omdat Delver's Journey en weekbonussen dat bedrag veranderen:

| rarity | basis | met 1,5× |
|---|---|---|
| Uncommon | 1.250 | 1.875 |
| Rare | 2.500 | 3.750 |
| Epic | 6.250 | 9.375 |

Item-ids die het gebruikt — **kandidaten, niet bewezen** (ander addon, CLAUDE.md):
groen `228071 254756 235504 232047` · blauw `228072 254757 235503 232046` ·
paars `254869 228073 232045 235502 254748 235607`

Dit verklaart alles wat we fout hadden: een niet-Bountiful delve geeft XP (er liggen chunks),
Bountiful geeft meer (meer/betere chunks), en "XP per run" bestaat niet als grootheid.

⚠️ **NIET nabouwen.** Dat addon trackt dit goed en Rob gebruikt het. Onze marktpositie is
uitléggen, niet tracken ([[mh-market-position]]). Het gat dat wél van ons is: onze popup zegt
nu "elke delve telt mee, Bountiful meer" — waar hij zou kunnen zeggen wat je moet zóeken.
Eerst de ids en bedragen in de client bevestigen; overtypen uit een ander addon is precies
de fout die 8 aug een niet-bestaand event opleverde.

**Pas daarna schrijven** — en dan in één keer goed in zeven talen, niet twee keer.
⚠️ De uitleg hoort op één plek. `Modules/TierSet.lua` heeft hem al; er komt geen tweede in
de Academy of de Codex bij. Drie keer deze week was de oorzaak van een bug "twee plekken
beantwoorden dezelfde vraag".

### 2. 🔴 "Zijn onze spec-spells nog actueel in 12.1?" — MEET DIT, raad het niet
`Modules/KeybindRoles_<Class>.lua`, 14 bestanden. **Laatst aangeraakt 4-7 aug 2026 —
vóór 12.1 live ging.** Dus de vraag is terecht.

**Maar het faalt maar op één manier, en dat bepaalt de meting.** Die data is geen spell-lijst
maar een *rol-toewijzing over spells die de client bevestigt dat je ze hebt* (zie de commits
van 4 aug: "only the ones you actually have", "Robs talenttree versloeg drie databronnen").
Gevolg:

- Een spell die 12.1 **verwijderd** heeft → verdwijnt vanzelf. Zelfherstellend, geen werk.
- Een spell die 12.1 **toegevoegd/hernoemd** heeft → staat nergens en zegt niets. **Stil gat.**

⚠️ Dus tellen hoeveel van onze spells nog bestaan bewijst niets — dat meet precies de kant
die zichzelf al repareert. Zie [[silence-is-not-absence]]: dit is dezelfde vorm als de
Valeera-fout van vanavond.

**De meting die het wél beantwoordt:** loop Robs spellbook af en rapporteer de spells die
**wij niet kennen**, per spec. Positieve controle in dezelfde run: de spells die we wél
kennen moeten er ook uit komen, anders is de sonde stuk en niet de data. Schrijf naar
`ns.db.<iets>` + `/reload`, dan lees ik het SV-bestand — geen screenshots van lange lijsten.

⚠️ Rob speelt **Prot Paladin (66)**. Eén spec meten dekt één spec; zeg dat er dan bij in
plaats van te doen alsof het over alle veertien gaat.

## ✅ AF (23-24 aug) — ~~EERST MORGEN (21 aug): wij dragen Rob op iets te doen dat niet kan~~

Gerepareerd op **twee** plekken, en de tweede pas nadat Rob hem op 23 aug opnieuw tegenkwam:
`ProfessionNextStep.lua` (21 aug, `CanSpendKnowledge`) én de adviesregel in Professions 101
(`BuildAdviceLine`, 24 aug). Die tweede was de bug: `canSpend` had één lezer, en de cursus
vroeg het nooit. De test staat nu als `ns.MH_CanSpendKnowledge` — één implementatie, en de
nodelijst eronder verdwijnt ook zolang alles op slot zit. Alles hieronder is historie.

## 🔴 ~~EERST MORGEN (21 aug)~~ — wij dragen Rob op iets te doen dat niet kan

**GEMETEN op Robs shadow priest, 20 aug laat.** Hij heeft 12 onbestede Knowledge Points op
Tailoring, en hij kan er **geen enkele** van uitgeven. Uit de tooltip van `Nimble
Needlework`, met alle vier de tabbladen op slot:

> Nimble Needlework — Specialization (Locked) — **Rank 0/30**
> On learning this specialization: Gain +5 Ingenuity when crafting Midnight bolts.
> 🔴 **Requires level 25 in Midnight Tailoring to unlock a specialization.**

Zijn Midnight Tailoring staat onder de 25. De knop onderaan zegt **"Unlock Specialization"**
en doet niets.

**En ondertussen zegt onze This Week-melding: _"Tailoring: 12 Knowledge unspent — spend
it."_** Dat is advies dat niet uitvoerbaar is, en dat is erger dan geen advies: de speler
gaat aan zichzelf twijfelen in plaats van aan ons. Zelfde familie als Engineering dat mensen
in een doodlopende weg zette en work orders die naar de verkeerde balie wezen.

Het verklaart ook een stuk van gisteravond. De aanname was dat Rob zijn punten bewust liet
liggen omdat hij op de gecorrigeerde routes wachtte. Bij Tailoring is dat niet eens de
reden — het kán niet.

### Twee plekken die het fout zeggen

| waar | wat er staat | wat waar is |
|---|---|---|
| `Modules/ProfessionNextStep.lua` (~114-124), Home | "X Knowledge unspent — spend it" | hij kan niets uitgeven tot skill 25 |
| Academy-adviesregel | "next points into Nimble Needlework" | het werkwoord op zijn scherm is **Unlock**, en de eerste stap is kiezen wélke van vier |

### ⚠️ Eerst meten, niets verzinnen

We lezen de **vergrendelde staat nu nergens uit**. `summary.tabs` geeft `active`/`max`, en
`math.max(active - 1, 0)` maakt "op slot" en "open maar onaangeraakt" allebei tot `0` — die
twee zijn met wat we lezen dus niet te onderscheiden. **Verzin hier geen API-naam.** Eerst
een probe die per tab dumpt wat er te weten valt (en of er iets is dat de skill-drempel
noemt), dan pas de reparatie.

**Doel van de reparatie:** de melding zegt *"breng je Tailoring eerst naar 25"* in plaats
van *"spend it"*, en de adviesregel gebruikt het werkwoord dat op het scherm staat.

### ✅ Wat hiermee BEVESTIGD is — niet opnieuw uitzoeken

- De keuze-momenten op **skill 25, 50, 60 en 75** staan letterlijk in de tooltip. De tekst in
  `PROFACAD_CH_TREES_BODY` klopt.
- **"On learning this specialization"** bevestigt dat het openen zelf al iets geeft — precies
  wat het hoofdstuk zegt over openen versus volmaken.
- **Rank 0/30** komt overeen met wat de addon uit de client las.

### ⏳ Nog steeds onbevestigd

De **20 punten** bij `Nimble Needlework` (advisorRoutes[197]). Die drempel is pas te zien
als de tree open is, dus niet verifieerbaar zolang de skill onder 25 staat. Blijft een hint
met "lees de tooltip" ernaast, zoals bedoeld.

---

## 🔨 BOUWPLAN 20 AUG — de zes professie-lessen in de addon (bouwkant van Spec 27)

Spec 27 (onderzoek, `06d6343`) beschrijft *wat* er moet komen. Dit is de bouwkant, en
twee metingen stellen zijn aannames bij. Beide kosten anders werk dat niet nodig is.

### 1. De lay-outbeslissing is geen keuze maar een meting — en hij is al beantwoord

Spec 27 noemt dit "de beslissing vóór alle andere": lessen van 800-1500 woorden zouden
niet passen in hoofdstukken die nu één of twee alinea's zijn, dus splitsen / scrollen /
inklappen moet gekozen worden vóór er vertaald wordt.

**Gemeten in `Modules/ProfessionAcademy.lua`:** alle hoofdstukken staan al in één
`UIPanelScrollFrameTemplate` (regel 674). Per hoofdstuk is `bodyFs` een FontString met
`SetWordWrap(true)` (regel 703) en de rijhoogte wordt in `Relayout` uit de gewrapte
tekst berekend — er is nergens een hoogtelimiet. **Lange teksten passen dus al.**

Dat maakt de vraag een andere: niet *of* het past, maar of het leest. Daarom:
- **Geen nieuwe container bouwen**, geen inklapveld, geen scroll-in-scroll.
- **Wel splitsen waar de les twee dingen doet** — les 2 is KP én specialisaties, dat zijn
  twee hoofdstukken. Splitsen op inhoud, niet op lengte.
- Dit hoeft dus niet vóór het vertalen beslist te worden, want het is per les te zien.

### 2. Vertalen blokkeert niets — het is geen onderdeel van de klus, maar een klus erna

`ns:L` valt bij een ontbrekende sleutel terug op enUS (zie CLAUDE.md → Localization). Een
les die alleen in enUS en nlNL bestaat is niet stuk; hij is Engels. Dat is precies wat
5 van de 7 packs vandaag al doen voor alles wat na 2025 is toegevoegd, tot
`Translations2026.lua` bijgewerkt wordt.

Daarmee valt "de grootste vertaalklus die dit project ooit had" van het kritieke pad af.
Bouwen en uitbrengen in enUS + nlNL; vertalen als eigen ronde daarna, fill-only.

### Volgorde

- **Ronde A** — les 3 (kwaliteit), les 4 (de zes stats), les 5 (Concentration). Drie
  nieuwe hoofdstukken, niets bestaands te herschrijven, tijdloos. Plus vindbaarheid,
  zie hieronder. Dit is één sessie en het is al een echte professions-update.
- **Ronde B** — les 1 (work orders) en les 2 (KP + specialisaties). Die *vervangen*
  bestaande hoofdstukken, dus eerst de bestaande tekst ernaast leggen en per zin
  bepalen wat fout is en wat alleen korter. Niets weggooien voor die diff er is.
- **Ronde C** — les 6 (goud). Het vergankelijke deel krijgt een eigen gedateerde
  sleutel, zodat een hermeting één string is en geen zeven talen.
- **Ronde D** — vertalingen via `Translations2026.lua`.

### Vindbaarheid hoort in ronde A, niet erna

Een zevende hoofdstuk in een tab die niemand opent lost het probleem van vandaag niet op:
Rob wist zelf niet dat de Academy er stond. Minimaal mee te leveren in ronde A:
- een regel op **This Week** zodra er onbestede Knowledge Points zijn, met een knop naar
  het hoofdstuk — de punten zijn al leesbaar, dus dit is een koppeling en geen meting;
- **elk nieuw hoofdstuk in de zoekindex.** Nieuwe inhoud wordt hier niet automatisch
  geïndexeerd; dat is dezelfde bug die mounts, raids en toolslaunch onvindbaar hield.

### Niet in dit plan

De node-adviseur (Spec 25). Eens met de onderzoekskant: eerst de lessen uitbrengen, dan
pas kijken of de vraag ernaar bestaat. Punten uitgeven doe je één keer per personage.

---

## 💡 ROB-VERZOEK 19 AUG — "dit soort info moeten wij ook gaan bieden!!!"

Aanleiding: Rob stond op het punt Azta'rec te pullen met **Valeera op Tank**. Uit
EverythingDelves' Nemesis-tab kwam dat je haar op **Healer** moet zetten, en waarom:
twee mechanieken bepalen alles — **Soul Extinction** (onderbreekbaar, dodelijk als hij
doorkomt) en **Void Toxin** (dispelbare magic debuff, tikt hard én −40% schade).

**En dáár zit ons gat, én onze voorsprong.** Hun advies is generiek: *"as DPS or tank,
set Valeera to Healer"*. Ik moest dat met de hand vertalen naar: *"jij speelt Mage, dus
je kunt Void Toxin niet zelf weghalen — dit is geen voorkeur maar noodzaak."* **Die
vertaalslag kan de addon zelf maken, want wij lezen de spec al.**

### Waarom dit past en niet gekopieerd is

De redenering is van ons, niet van hen. Wij hebben al:
- `ns.HEALER_DISPELS` / `ns.NONHEALER_DISPELS` — wat jouw spec van een vriend kan halen
- `ns.OFFENSIVE_PURGES` — apart gehouden, en dat is hier cruciaal: `MAGE = 30449`
  (Spellsteal) staat er als **offensieve** purge, dus een Mage krijgt terecht "nee" op
  "kun jij een magic debuff van jezelf halen?". Die categoriefout is op 5 aug al een
  keer gemaakt en toen opgelost — de landmijn ligt er dus niet meer.
- KeybindRoles per spec — interrupts, defensives, CC

Wat we **moeten meten** is per baas: welke mechaniek doet ertoe, en van welke soort is
hij (onderbreekbaar / magic-dispelbaar / geen van beide). Dat is precies de tabel die
niemand mag overschrijven uit andermans addon.

### De vorm

Per delve-baas een handvol regels `{ spellID, kind = "interrupt" | "dispel_magic" }`,
en dan kruist de addon dat met wat JIJ kunt:

> Soul Extinction — jij kickt dit zelf (Counterspell).
> Void Toxin — **jij kunt dit niet weghalen.** Zet Valeera op Healer.

Dus: eerst zeggen wat de speler zelf dekt, dan wat er overblijft, en daaruit volgt
de companion-stand. Nooit "zet haar op Healer" zonder de reden erbij — dat is precies
het verschil met een gids.

⚠️ **Curio-advies blijft per gevecht, niet algemeen.** `/mh curios` legt bewust niet
vast welke curio "de beste" is: dat hangt van spec én delve af en niemand heeft het
gemeten. Wat hier bijkomt is per-baas advies, met bron erbij. De **Poisons-slot** is
dit seizoen nieuw (notitie van 27 jul) en heeft nog helemaal geen advies.

**Huis:** `DelveCuriosAdvisor.lua` doet al rolgebaseerde curio-suggesties en heeft al
een popup-plek. `DelveTipsData.lua` heeft de per-delve secties, inclusief de rode
`danger`-vlag van 18 aug.

⚠️ **Venomfall Deeps heeft nog HELEMAAL GEEN coach-entry**, als enige delve. Dat is de
plek om dit als eerste te bouwen — en Rob loopt hem vandaag, dus de mechanieken komen
uit zijn eigen run in plaats van uit een gids.

## 🎯 MORGEN 19 AUG — PRIORITEIT: de EU-seizoensstart

Rob speelt **EU**; Season 2 opent daar pas bij de reset van 19 aug. Alles wat gisteravond
leeg terugkwam bewijst dus **niets** — hij waarschuwde daar zelf voor toen ik op het punt
stond het weer als bewijs te lezen. Eén run na de reset beantwoordt vier dingen tegelijk:

```
/reload      →      /mh atal      →      /reload   (dan leest de sessie ns.db.atalProbe)
```

**1. 🔴 96466 STAAT WEER OPEN — dit is de belangrijkste meting.** Op 17 aug sloot ik hem
als "fout id" met het argument: 96528 resolvet, dus "nog niet live" kan de stilte van
96466 niet verklaren. Zygor bracht 18 aug drie ids uit dezelfde Prey-keten mee en Robs
client antwoordde:

```
96004 ✓    96474 ✓    96528 ✓
96466 –    96525 –    96503 –    96532 –
```

Drie stappen antwoorden, drie niet, bínnen één keten. Daarmee valt de aanname weg waar
mijn argument op rustte (dat alle stappen van dezelfde ongereleasde keten zich hetzelfde
gedragen). **Springt na de EU-reset één van 96525/96503/96532 aan → "nog niet live" was
altijd de verklaring, en 96466 is daarmee ook beantwoord.** Blijven ze stil terwijl S2
draait → dán pas zijn het foute ids. Er hangt niets aan 96466, dus er breekt niets.

**2. Verschijnt Venomfall Deeps als POI?** `Modules/Delves.lua:89` voorspelt van niet vóór
de seizoensstart (gemeten mét positieve controle: de sweep gaf 14 aug precies twee delves
voor 2512). Verschijnt hij nu, dan levert de client **zelf het poiID en de coördinaten** —
en zijn we van het bronnenverschil af: Method zegt `2512 51.22/30.27`, Wowhead `51.2/31.0`.
Geen van beide staat in de data.

**3. De portaal-gate.** Wij hangen het Coiled Isle-portaal aan **96004** (eerste quest van
de keten), Zygors reisgraaf aan **96532** (de vijfde) — én Zygor accepteert "quest actief"
waar wij "voltooid" eisen. Rob kan de questlijn morgen pas lopen (Zygor heeft hem als
guide). **Vraag er expliciet bij of het portaal in Astalor's Sanctum werkt**; zonder dat
is de questlijst alleen een lijst. Coördinaten van beide bronnen liggen binnen een tiende
van de onze — dat is al onafhankelijke bevestiging van onze eigen getallen.

**4. Klopt onze seizoensgate?** `IsSeasonLive()` is in 2.18.0 geregionaliseerd
(`GetSecondsUntilWeeklyReset`). De EU-reset is er de eerste echte test van: S2-content moet
vóór de reset verborgen zijn en erna zichtbaar. Derde correctie op die gate — kijk of het
deze keer klopt.

**Ook morgen, tijdgebonden:** achievement **63334** (*Fabled Let Me Solo Him: Azta'rec*,
solo-kill) **vervalt bij de reset van 25 aug**. Naam en id zijn 18 aug door Robs client
bevestigd. Als de planner daar een rij voor krijgt: voeden met `GetAchievementInfo`, nooit
met een datum in de code, zodat de rij vanzelf verdwijnt.

## 📌 18 aug (avond) — na de release: vertalingen, en drie kapotte-stringbugs

Zestien commits na `v3.0.0`, alles gepusht, werkboom schoon, lint 0/0.

**Wat er gemeten is:** 189 hazard-ids allemaal benoemd door Robs client (16 nieuw uit
GTFO 6.8, inclusief 5 voor de raid die diezelfde dag openging), en de Azta'rec-introketen
bevestigd — 97321 "Slithering Spoils" en 97482 "Fangs for the Memories" komen terug met
exact de namen uit de gids. 97482 stond bij ons verkeerd als "de delve" en is stap 2.

**Nieuw gereedschap:** `/mh hazards check` legt élk id in het bestand aan de client voor,
met een positieve controle die moet slagen en een onmogelijk id dat moet falen. De 173 van
17 aug waren met een wegwerpscript gecontroleerd dat niet meer bestond.

**Lint-check [13]** bewaakt vertalingen op de drie manieren waarop ze machinaal breken. Alle
drie zijn in twee uur gevonden, en geen ervan had met taalgevoel te maken:
- esES toonde `__TKHace 0__m` — een onafgemaakte vertaalmarkering, `%d` vervangen door een
  letterlijke nul. Stond in de 3.0.0 van gisteren.
- **362×** `\n` als zichtbare tekst in deDE/esES/frFR/ptBR (dubbele backslash), vrijwel
  allemaal in de **Academy**.
- **116×** een backslash vóór elk aanhalingsteken, zelfde vier packs, zelfde feature.

⚠️ **De eerste reparatie van die 116 brak alle vier de packs** (aangenomen dat het er twee
waren; het zijn er drie). Meteen teruggedraaid. **Les: tel de bytes, lees ze niet af van een
weergave** — en elk pack, óók enUS en nlNL, heeft twee backslashes vóór een `R`, dus een
algemene "dubbele backslash opruimen"-regel sloopt juist de goede bestanden.

**Vertaald:** 49 Duitse dungeon-tips (de DPS-regels + Altar of Fangs) en de hele Duitse
Academy (DPS-spoor, 5 heal-hoofdstukken, checklist). deDE 80,2% → **83,0%**.

**De audit telt nu eerlijk:** `CHANGELOG_*` en `LANG_LABEL_*` (330 sleutels) zijn bewust
Engels en zaten in de noemer. nlNL staat op **100%** en stond dat al.

## ⚠️ OPEN, en het raakt alle vertaalwerk

**`/mh lang de` doet niets op een niet-Duitse client.** `deDE.lua` kapt bovenaan af
(`if GetLocale() ~= "deDE" then return end`) omdat de taalkeuze in SavedVariables zit en die
pas ná de locale-bestanden laadt. Gevolg: **Rob kan geen enkele vertaling zelf zien** — hij
draait een Engelse client — en het verklaart waarom die 362 kapotte regels nooit gemeld
zijn. Alleen spelers mét een Duitse client zagen ze.

Voorstel (nog niet gebouwd, ~5 bestanden + laadvolgorde): de tabel niet afkappen maar in een
functie zetten die pas draait als de voorkeur bekend is. Dan werkt de taalkiezer voor
iedereen en betaalt alleen wie erom vraagt het geheugen. Goedkope tussenstap voor een test:
die drie regels tijdelijk uitzetten, kijken, terugzetten.

**Wat níét afgedekt is en ook niet kan:** of het Duits goed *klinkt*. Daar is een
moedertaalspreker voor nodig — `#translations`, zoals Robs eigen brief al voorstelde.

**Kleiner open:** vier keer `Schlüssel` waar `Taste` hoort in de Duitse Layout/Guide-teksten
(de Academy-versie is gefixt), Robs screenshots moeten nog gecropt (`tools\Crop-Shots.bat`),
en op CurseForge moeten de **description** (bijgewerkt in de repo) en de **summary** nog met
de hand geplakt.

## 🚀 18 aug — v3.0.0 GETAGD (Season 2)

Rob: *"maak hier idd maar v 3.0 van en go"*. Zijn eigen afspraak "v3.0.0 = Season 2"
is daarmee ingelost. Vijf artefacten bij: toc, `Changelog.lua` + `CHANGELOG_300_*`,
`RELEASE_NOTES.md` (25 regels, 0 bullets), `CHANGELOG.md`, `docs/CURSEFORGE_3.0.0.md`.
`CURSEFORGE_DESCRIPTION.md` op drie plekken bijgewerkt (reisplan, Mix Master + Ring of
Glory, `/mh plan` in de commandotabel) — **Rob plakt die zelf op de CF-pagina.**

⚠️ **Twee dingen uit het kopstuk van 17 aug waren al opgelost en stonden hier ten
onrechte nog open** (dit bestand was ouder dan de commits):
- De Windcaller-coördinaten zijn **binnen** — alle drie de hubs staan in `ns.AMANI_HUBS`
  met NPC- én landingscoördinaten (`d797415`).
- De pijl **loopt het plan al**. Niet door voortgang bij te houden, maar doordat
  `BuildTravelPlan` bij elke update opnieuw draait vanaf waar je staat: na de vlucht is
  de deur dichterbij dan de Windcaller, dus `skipVia` wordt waar en die stap valt weg.

**Nog open na 3.0.0:** Rob moet nog croppen (`tools\Crop-Shots.bat`) — `/mh shots` en
de reload zijn gedaan. Negen scènes nu; `/mh keys` en `/mh plan` zijn **niet** te
fotograferen zolang ze naar de chat printen en de rig UIParent verbergt.

🔴 **De Timeworn Golem is GESLOTEN, niet vergeten.** Er kan geen live waarschuwing
komen: 12.1 geeft niets leesbaars over een vijandelijke cast (spell-id 13/13 secret,
en naam/icoon/begintijd/eindtijd óók). `BracePrompt.lua` is dezelfde dag gebouwd,
gemeten en weer verwijderd. De inhoud staat nu in de Delve Coach als rood blok.
Niet opnieuw bouwen; wél hermeten als 12.2 landt.

## 📌 18 aug — Season 2 open, 2.18.0 live, en een dag van vindbaarheid

**v2.18.0 staat op CurseForge (approved).** Daarna ~20 commits, nog niet uitgebracht.

**De rode draad van vandaag: de gaten zijn geen ontbrekende features, het zijn features
onder een naam die niemand zou raden.** Drie keer dezelfde vorm gevonden:
- **12 features waren alleen bereikbaar door te typen** — geen knop, geen Settings.
  Onder andere `/mh dispel`, `/mh healcds`, `/mh kicks`, `/mh binds`, `/mh plan`.
  Gemeten met `tools/_probe.py`; de lijst staat in de sessie. **Nog te doen: welke van
  die twaalf een echte plek in de UI krijgen** (dat is voorstel-punt 3.4, maar dan 12×).
- **Elke Coiled Isle-treasure was onzichtbaar voor de zoekfunctie** — de index las
  `node.name` en die hunts hebben bewust geen naam. Zevende plek van diezelfde fout.
  Gefixt: leest nu `ns.AchievementNodeName`, dus een Duitse speler vindt de Duitse naam.
- **De commandolijst zelf was niet vindbaar** — onderaan tabblad "Losse vensters", zonder
  "command" in de zoektrefwoorden. Gefixt.

**Nieuw vandaag:** `/mh here` (plekken opschrijven i.p.v. screenshots overtikken), de
Coiled Isle Safari + Mysterious Mix Master met de tien recepten, alle drie de Amani-hubs
gemeten, en de API-wachter draait nu lokaal en schrijft in `docs/API_WATCH.md`.

**🔴 OPEN — Timeworn Golem in The Ring of Glory.** Rob: een mob die one-shot met iets als
"Fissure Slam", niet te ontkomen, alleen te overleven met een defensive. GTFO heeft
`392013 Golem Smash` op instance 3077, **maar datzelfde id staat óók in hun DF- en
TWW-bestanden met andere NPC-namen** — het is een generieke golem-ability en misschien
niet wat Rob zag. Een agent zoekt het uit; Rob levert NPC-naam via `/mh here` en de
castbalk-naam. **Bouw niets tot het id gemeten is** — een prompt op het verkeerde id
waarschuwt voor iets anders dan wat je doodmaakt. Machinerie bestaat wel: de Action
prompt draait op `UNIT_SPELLCAST_START` (geen combat log, dus toegestaan).

## 🌅 MORGENVROEG — twee dingen, en Rob brengt data mee

**1. Vier scènes toevoegen aan `Modules/DevShots.lua`.** `/mh shots` maakt nu zeven
scènes (This Week, mounts-preview, raids, search-boss, class-coach, alts, void-rituals)
en niets van 17 aug. Nodig voor de CF-pagina: het **hazard-blok** in de Delve Coach, het
**Achievements-tabblad** met de vijf Coiled Isle-kaarten (Soft Underbelly uitgeklapt, dan
zie je de stap-knoppen), **`/mh keys`** en **`/mh plan`**. Het is een tabel met scènes —
kleine klus. Daarna: `/mh shots`, **`/reload`** (SavedVariables worden pas dan
weggeschreven, zonder reload snijdt hij verkeerd), dan `tools\Crop-Shots.bat`.

**2. De Windcaller-coördinaten die Rob meebrengt.** Wat we hebben: Amani Foothold
`2509 44.42/62.21` (taxi-node, eruit) en één Windcaller op `2509 49.99/61.93`. Wat
ontbreekt: waar **Eastern Amani Outpost** en **Northern Amani Bulwark** liggen, en waar
hun Windcallers staan. Zonder die kan `/mh plan` niet kiezen wélke interne sprong het
beste is — nu neemt hij altijd de noordelijke, omdat de Underbelly-deur noordelijk ligt.
Er zit al een halve regel in die bewijsbaar klopt: sta je dichter bij de deur dan bij de
NPC, dan slaat hij de sprong over. De omgekeerde conclusie is bewust NIET getrokken.

**Daarna:** de pijl het plan laten lópen (nu loopt hij alleen stap 1), en dan 3.0.0.

## 📌 17 aug — v2.18.0 GETAGD, seizoensgate geregionaliseerd

**v2.18.0 staat op CF en wacht op goedkeuring.** Werkboom schoon, linter 12/12.

⚠️ **Rob's afspraak over 3.0.0 staat in dit bestand (regel ~289, ~1283): "v3.0.0 =
Season 2", bij de seizoensstart.** Hij bracht dat terecht op; ik was het kwijt. Besloten:
2.18.0 vandaag (de seizoensgate moest vóór de reset live), **3.0.0 deze week** als het
seizoen echt open is — met gemeten delve-ilvls, geverifieerde raid-tips en de complete
reisplanner, in plaats van een hernummering.

**Nog te testen door Rob:** de vliegbanner ("Take X — then on to Y"), het dispel-icoon.
Allebei fixes van vandaag die niemand ooit heeft zien werken, want ze werkten nooit.

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

## ⭐ v2.16.0 GETAGD 16 aug (`v2.16.0`, packager uploadt) — en er staat al werk ná de tag

"Getting there, and knowing your keys": delve-kistenroute, tweetraps-reizen naar de
flight master, 649 flightpoints, `/mh binds`, en de Layout-kolomfix.

**Getest sinds de tag:**
- ✅ **De kistenroute schuift door** — bevestigd door **Carola** (16 aug). Rob kon het
  niet: de kist-vlaggen zijn **account-wide**, dus op zijn account staat alles voor altijd
  op gedaan. ⚠️ Een lege route bij een veteraan is de feature die wérkt, geen bug. Deze
  feature is voor wie een delve voor het eerst ziet.
- ✅ **De boss-prompt verdwijnt na 5 seconden** — Rob, 16 aug avond.
- ✅ **De pijl schakelt om bij het instappen op de taxi** — Rob, 16 aug avond.
  **Daarmee is 2.16.0 volledig getest.**

### 💡 Robs idee: één knop "breng me naar de Coiled Isle" (16 aug, avond)

⚠️ **Eerst meten, dan bouwen.** `MIDNIGHT_PORTALS` (Delves.lua:125) kent Silvermoon ↔
Harandar ↔ Voidstorm en **géén portaal naar 2512**. Dat betekent niet dat er geen is —
alleen dat wij er geen hebben. Rob checkt de portaalkamer in Silvermoon.

Bestaat het portaal, dan moet de knop dáárheen sturen: de vlucht naar Tokka's Landing
duurt 6:18 (Blizzards eigen tooltip), een portaal is direct. Bestaat het niet, dan naar
de flight master.

📌 **De machinerie ligt er al.** De tweetraps-reis doet precies "van waar dan ook naar X":
vertrekpunt zoeken, pijl naar de flight master, omschakelen bij instappen, halte oplichten
op de vliegkaart. Een knop is alleen een vaste bestemming die dat aanzet — de vraag is
wáár hij staat en waarheen hij wijst, niet of het kan.

### ✅ De vliegkaart-pin licht op — OPGELOST 16 aug (`0997123`)

**Oorzaak: de client noemt een taxi-node mét zijn zone.** Robs muis over de pin gaf
Blizzards eigen tooltip: *"Tokka's Landing, The Coiled Isle"*, terwijl onze
FLIGHT_POINTS (uit Zygor) *"Tokka's Landing"* zegt. De `==`-vergelijking miste hem —
in de markering **én** in de "staat deze halte op je kaart"-check, dus de balk klaagde
niet eens. Nu op **prefix**.

⚠️ **Twee eerdere pogingen namen een oorzaak aan en waren allebei fout** (eerst de
pin-template `FlightMap_FlightPointPinTemplate`, toen de lookup-route). Wat het oploste
was een screenshot waarop het spel het antwoord zelf toonde. `/mh flightpins` bestaat nog
als diagnose maar was uiteindelijk niet nodig.

📌 De pins komen via `FlightMapFrame.dataProviders` → de provider met `AddFlightNode` →
`slotIndexToPin`; elke pin draagt `taxiNodeData` (name, nodeID, state). Dat patroon komt
uit ZygorGuidesViewer `Libs/LibTaxi-1.0` — een API-gebruikspatroon is leesbaar en
controleerbaar, anders dan game-data uit dezelfde addon.

⚠️ De balk zegt alleen "gemarkeerd" als het markeren écht lukte. Niet terugdraaien naar
een vaste tekst.

### 📊 Onze delve-ilvl-tabel meet iets ANDERS dan die van EverythingDelves

Rob liet hun paneel zien (T1 220/233 … T8 250/259) naast onze tabel (T1 210/216 …
T8 246/259). **Geen conflict:** hun veld heet `bountifulLoot`, het onze `endChest`. Een
Bountiful delve geeft hoger ilvl dan een gewone eindkist.

⚠️ **Maar ons label "End" zegt niet wélke kist het is**, en niemand weet nog waar die
S1-getallen vandaan komen. Te meten: één gewone (niet-Bountiful) delve op een bekende
tier. Hun tabel is ook S1 ("static for S1" in hun eigen comment) en wordt dinsdag net zo
onwaar als de onze — wij zetten de onze dan op nil en printen een zin.

📌 Wat zij hebben en wij niet: een **`recGear`-kolom** (aanbevolen ilvl per tier, T1 170
→ T11 265). "Kan ik deze tier aan?" is een echte beginnersvraag. Alleen zinvol ná dinsdag,
en dan uit een gemeten bron — niet uit hun tabel overgetypt.

**Commits ná de tag — gaan mee met 2.17.0:**
- Dubbele "Eindbaas nog niet herkend" in de coach (de tiptekst houdt hem, de
  modellenstrip geeft toe — die tekst gaat mee als je de briefing deelt).
- De deel-knoppenrij liep buiten het frame. ⚠️ Niet "één knop te veel": Carola speelt
  Nederlands, waar *"Deel briefing"* bijna 3× zo breed is als *"Brief"*. De rij wrapt nu
  op breedte. Beide bugs kwamen van **één foto van Carola's monitor**.
- **`/mh curios`** — wat elke curio-keuze van je companion doet, live uit de client.

### 🎯 `/mh curios` en waarom het GEEN ranglijst is

Rob vroeg om advies bij Valeera. Bewust niet gebouwd als "kies deze":

- **`Everything Delves`** (CF, v1.25.0, 12.1) heeft `/ed curios` mét ranking — maar bij
  Rob toonde het *Porcelain Blade Tip* en *Mandate of Sacred Death*, voor alle drie de
  rollen identiek. **Dat zijn Brann-curio's uit The War Within**; Valeera's echte opties
  zijn Ouroboric Curse / Essence Trap en Dundun's Favor / Soul-Cracking Dreamcatcher /
  Venom Infusion. Hun ranking klopt hier dus niet. ⚠️ Ik had Rob eerst geadviseerd dat
  addon erbij te installeren — dat advies is ingetrokken toen zijn screenshot dit liet
  zien.
- De boost-sites (boostmatch/expcarry/koroboost) recyclen dezelfde TWW-namen onder een
  12.1-kop. Zelfde bronnenfamilie als de teruggetrokken kostenladder.
- Dus: **niets hardcoded.** Keuzeslots uit de trait-boom, effecttekst uit
  `GetSpellDescription` (al vertaald), actieve keuze uit de node. Een curio die Blizzard
  toevoegt verschijnt vanzelf. Zie `mh-market-position` in het geheugen.

⚠️ **`RequestLoadSpellData` is asynchroon** — de eerste versie printte acht keer "geen
beschrijving" omdat aanvraag en uitlezing in dezelfde frame zaten. Zelfde les als bij de
trait-sweep die ochtend; de aanroep was overgenomen, de reden niet.

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

**📌 MORGEN (17 aug), door Rob aangedragen vlak voor het slapen:**
1. **Nieuwe screenshots voor de CF-pagina** — de beschrijving is al bij (`463a6a1`).
2. **Method uitkammen**, te beginnen met
   `https://www.method.gg/guides/best-corrosive-codex-powers-in-wow-midnight`.
   ⚠️ Let op de spanning: `/mh curios` weigert bewust te rangschikken omdat wij niets
   gemeten hebben. Method rangschikt wél. Dat mag alleen mee als het als *bron met naam*
   binnenkomt ("Method zet X bovenaan"), niet als ons eigen oordeel — anders verkopen we
   andermans mening als meting. En Method's staat van dienst van vandaag: twee quest-ids
   uit één alinea, één klopte, één is nog onbeslist. Kandidaten, geen bewijs.

**✅ 96466 IS BESLIST (17 aug) — en niet door te wachten.** De server zei 16 aug "bestaat
niet" en ik noemde dat "fout id". Rob wierp terecht tegen dat een S2-quest die nog niet
geactiveerd is er precies zo uitziet. Die tegenwerping leverde de betere test op: Method's
Prey-gids noemt dezelfde vervolgquest **96528**, en die kent de client wél ("Prey: Anguish
from Beyond") terwijl 96466 stil blijft. Twee ids voor dezelfde niet-live content, één
resolvet — dus "nog niet live" verklaart niets meer. **96466 is een fout id van Method.**
Les: een lege uitkomst werd pas bewijs toen er een *rivaal* naast lag die kon slagen.

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
