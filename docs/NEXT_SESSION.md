# Midnight Helper — waar we staan

## 🔴 DIT BESTAND BIJWERKEN HOORT BIJ DE WIJZIGING, NIET ERNA

Rob, 2 sep 2026: *"dit moet eigenlijk altijd gebeuren als er iets verandert, vind je niet?"*

Ja. En de reden dat het tóch misgaat is dat bijwerken aan het *eind* komt, als het werk al klaar
voelt — dan is het optioneel geworden. **Verandert de status van iets dat hier staat, dan gaat de
regel mee in dezelfde commit als de code.** Niet "straks even".

⚠️ Wat het kost als je het niet doet, twee keer gemeten: op 31 aug somde ik zeven beroepen op als
ongecontroleerd terwijl Rob ze diezelfde ochtend had gemeten, en op 2 sep stond `A Toxic Tour` hier
nog als open vraag terwijl hij al beantwoord was. Beide keren citeerde ik mijn eigen verouderde
aantekening als bewijs. Een aantekening is een claim mét een datum, geen meting.

## Stand 2 sep 2026 (ochtend)

**Alle vier de wachters draaien nu in de cloud** en pushen zelf, tussen 05:30 en 06:00 Robs tijd —
API, PTR/roadmap, blue post/data, content. Niets hangt meer aan Robs pc. Zie de tabel bovenaan
`CLAUDE.md`. De drie oorzaken die dat blokkeerden (repo niet als bron ingesteld, twee logboeken in
`.gitignore`, en een connector-toestemming waar een onbeheerde run op bleef wachten) staan in de
commits van die ochtend.

📌 En de regel die daaruit volgde en breder geldt dan wachters: **een onbeheerd proces mag nooit op
een goedkeuring blijven wachten.** 4 van de 10 laatste API-runs waren zo stilgevallen. Kan iets niet,
schrijf op wát niet kon en ga door — een halve meting die aankomt is meer waard dan een volledige
die nooit komt.

## ✅ 3.7.3 LIVE en approved op CurseForge — 31 aug 2026 (tag `v3.7.3` op `945e17d`)

De adviseur zweeg voor hele beroepen (12 routestappen in 5 beroepen noemden een node alsof het een
tabblad was), vier talen bleken machinaal vertaald, Valeera heet Valira in het Portugees, vijf
spell-links werkten niet, en de Vaults-keten was drie quests terwijl het er vier zijn.

✅ **Vertalen is AF**: zeven talen, nul drift, alle 43 placeholders lossen op.

### 🔴 Wat morgen als eerste telt

**Wacht op iemand anders:**

1. **`cmd:req` voor het consumables-bord** — wacht op Cisca's reload-test.
2. ✅ **Wago staat er — 2 sep.** Project aangemaakt, versie 3.7.3 handmatig geüpload (Wago's
   "Upload your Addon!" leidt naar *Create Version*, dus een zip is nodig om te beginnen), en
   `## X-Wago-ID: rNky4wKa` staat in de `.toc` onder het CurseForge-ID. `release.yml` gaf
   `WAGO_API_TOKEN` al door aan de packager, dus vanaf de volgende release gaat het vanzelf naar
   CurseForge **én** Wago. Dit was SPEC_31 B7.
   ⚠️ **Nog niet bewezen:** of de automatische upload werkt. Het GitHub-secret `WAGO_API_TOKEN`
   staat er wél in (Rob bevestigd, 2 sep), maar of de packager er daadwerkelijk mee uploadt blijkt
   pas bij de eerste release ná vandaag — kijk dan of Wago de nieuwe versie krijgt zonder handwerk.
   🔴 **DOODLOPEND SPOOR, niet opnieuw onderzoeken: Wago's downloadcijfers zitten achter Patreon.**
   Rob wilde er een teller voor in Home Assistant, naast die voor CurseForge, en heeft daarvoor een
   tweede API-token aangemaakt. Dat token is weer ingetrokken: de statistieken zijn betaald en dat
   is geen plan. Er is dus **geen** Wago-downloadteller, en de reden is een prijskaartje en geen
   ontbrekend eindpunt — zoeken naar de juiste API levert niets op.
   ✅ **Uitgezocht dezelfde ochtend, en het was geen bug maar onze eigen keuze.** `release.yml`
   zei het zelf: GitHub-releases waren bewust uit, *"one new shop at a time"*. Die reden is nu
   vervallen (CF werkt al maanden, Wago staat er), dus aangezet met `GITHUB_API_TOKEN:
   ${{ secrets.GITHUB_TOKEN }}` plus `permissions: contents: write`. **Geen nieuw secret nodig** —
   Actions levert die token zelf.
   ⚠️ Onbewezen tot de eerste release hierna: of het Release-object echt verschijnt.
   📌 Bijvangst die een schrik bespaarde: de packager-README noemt `CF_API_TOKEN` terwijl wij
   `CF_API_KEY` doorgeven. `release.sh` accepteert **allebei** (gemeten in de broncode, niet in de
   README). Onze werkende opzet was dus nooit in gevaar en moet **niet** "gerepareerd" worden.

**Gemeten open op 2 sep** (met positieve controle in dezelfde run):

3. ✅ **B5 — `/mh report` GEBOUWD, 2 sep.** `Modules/SupportReport.lua`, via het bestaande
   `ns.ShowShareCopyDialog` zoals de spec voorschreef — bedrading, geen nieuw scherm. Bevat
   versie, clientbuild, taal (client én MH), klasse/spec/level, groepsgrootte en instantie, plus
   wat de speler achter het commando typt. Beide bestemmingen erin, Discord én GitHub.
   Lint: 173 gerouteerd / 65 vermeld (was 172/64), dus hij staat in de commandolijst én in
   NavSearch. ✅ **Door Rob getest en afgetekend** (`docs/TESTLIJST.md` punt 11) — hij vond binnen
   twintig minuten twee uitvoerfouten die geen controle kón zien omdat de wáárden klopten:
   `MAGE Frost` en `Eastern Kingdoms (open world)` in plaats van de zone. Beide gerepareerd.
   📌 Twee keuzes die Rob mag terugdraaien: **geen personagenaam of realm** in het rapport (het is
   bedoeld om openbaar geplakt te worden, en die twee helpen niet bij reproduceren), en het
   **rapportblok blijft Engels** terwijl de chrome eromheen in zeven talen staat — het is aan de
   maker gericht, zoals een logbestand.
4. ✅ **B10b — beroepen-scène TOEGEVOEGD, 2 sep.** `{ name = "10-professions-advice", tab =
   "profoverview" }` in `Modules/DevShots.lua`. De meting van die ochtend is precies omgedraaid:
   `prof` gaf nul treffers in dat bestand, nu vier.
   📌 **Waarom juist deze scène en niet een willekeurige elfde:** op 31 aug is over ~20 addons
   gemeten dat **geen enkele** vertelt wáár je Knowledge uitgeeft. Het enige dat deze addon doet
   en niemand anders, was dus het enige dat een bezoeker van de CF-pagina niet kon zien.
   ⚠️ `profoverview`, niet `professions` — die oude id landt op Treasures & Books, wat Rob op
   22 juli kreeg toen hij op een Knowledge-regel klikte.
   ⚠️ Deze scène hangt als enige aan het **ingelogde personage**: draai `/mh shots` op iemand met
   Midnight-beroepen en punten te besteden, anders fotografeert hij een eerlijke lege pagina.
5. **De INHOUD van de Engineering-, Jewelcrafting- en Inscription-routes.** Hun *structuur* is
   geverifieerd (0 afwijkingen over alle 11 beroepen), maar of `Recycling` het juiste eerste punt
   is, is nooit tegen gamedata gelegd. ⚠️ Dat verschil is echt en is op 31 aug één keer verward.
   Drie beslissingen liggen bij Rob: de `points`-semantiek (Recycling zegt "mik op 10" maar de stap
   voltooit pas bij 30), JC stap 1 (alle gidsen zeggen ~5, wij eisen een volle root), en of
   Inscriptions vierde boom `Darkmoon Curiosity` erbij moet.

**Niet opnieuw gemeten, overgenomen uit de meting van 31 aug:**

6. 🔴 **B6 — HERMETEN 2 sep, en écht nog open.** Het "vertel het ons"-model bestaat exact één keer:
   `RITUAL_BOSS_MINDBREAKER_STEPS` (*"If you fight it, tell us what it did on Discord and it goes
   in"*). Dat was tegelijk de positieve controle — mijn zoekvorm vindt een vraag waar er één is.
   De vijf plekken waar de addon toegeeft iets níét te weten dragen er géén: `DELVE_TIP_UNMEASURED`
   (enUS:1456), `DELVE_REWARDS_UNMEASURED` (enUS:1459), `MPLUS_AFFIX_UNMEASURED`
   (`Locales/MythicPlus.lua:32`), `DELVE_CHEST_LEARNED` (enUS:547), `HAZARD_SOURCE_NOTE`
   (enUS:1674).
   ✅ **De blokkade is weg:** de spec zei *"waar het een tooltip is noemt de tekst `/mh report` —
   daarom moet B5 eerst"*, en B5 bestaat sinds 2 sep.
   ⚠️ De spec waarschuwt dat dit het voorstel is dat het snelst een zeurpiet wordt: alleen op
   teksten die iemand bewust léést, nooit op een tooltip die de muis volgt, nooit met een knop die
   terugkomt.
6b. ✅ **B10 — CF-bovenkant HERSCHREVEN, 2 sep.** GEMETEN vóór en na: *"Just hit 90…"* stond op
   regel 9 en staat nu op 3; **Professions 101 stond op regel 117 en staat nu op 15**.
   🔴 En de meting legde bloot dat ik het die ochtend zélf erger had gemaakt: mijn site-blokcitaat
   werd het derde bovenaan en duwde de pitch nog twee regels omlaag — precies het probleem dat de
   spec beschrijft. De links staan er nog, nu ná "Start with these three".
   📌 Het eenmansproject-briefje is samengevoegd met de Discord-regel en naar de voet van het
   eerste scherm verhuisd: eerlijkheid die vertrouwen *sluit* hoort niet vóór de pitch te staan.
   ⏳ Rob moet de omschrijving hiervoor opnieuw plakken (tweede keer op 2 sep).

**Nieuw, 2 sep — en dit is nu het dringendst:**

0. ✅ **World boss — GEMETEN EN OPGELOST, 2 sep.** Rob zag het S1-world-boss-artikel binnen een
   uur na publicatie op de site staan als actueel advies, draaide `/mh worldboss` op live, en dat
   besliste alles in één keer: **Lu'ashal `taskActive = true`, 9904 min resterend**, de andere
   drie idle. De vier bosses roteren gewoon door in Season 2.
   🔴 **"12.1 verving world bosses door Lairs" was FOUT** — dezelfde probe geeft `hasLairs = true`
   én actieve world bosses: Lairs bestaan ernáást. Die claim kwam van Icy Veins en een techsite en
   was op weg naar onze publieke site. Twee secundaire bronnen die elkaar bevestigen zijn geen
   meting.
   Gedaan: de S2-poort is uit `Modules/WorldBoss.lua` gehaald, het artikel staat weer op de site,
   en `SKIP_ARTICLES` in `tools/build_site.py` is weer leeg — het mechanisme blijft.
   🔴 **Correctie op mezelf, dezelfde ochtend.** Hier stond eerst dat die poort "twee weken lang
   een boss verzweeg die er gewoon stond". Rob weerlegde dat vanuit het spel binnen een kwartier:
   Lu'ashal stond er **vóór** de reload al. `GetActiveWorldBoss` probeert eerst de client-scan, dan
   de cache, en pas dán deze functie — de poort zat alleen op die laatste. De echte kosten zijn
   dus smaller: in een week waarin de client niet antwoordt bleef het paneel leeg in plaats van de
   boss te noemen. Nog steeds terecht weggehaald, maar niet wat ik beweerde.
   ⏳ **Rob moet nog bevestigen** dat de boss in-game terug is: `docs/TESTLIJST.md` punt 10.
   📌 Blijvende les die groter is dan dit item: **de sitegenerator kopieert teksten, maar niet de
   voorwaarden waaronder de addon ze toont.** Die poort stond in Lua, de generator leest data.
   Alles wat de addon afhankelijk maakt van seizoen, patch of speler-toestand publiceert de site
   onvoorwaardelijk tenzij iemand het opmerkt. Staat als regel boven `SKIP_ARTICLES`.

**Nieuw, 2 sep (middag) — Valeera-advies bestond al, maar was onvindbaar:**

8. ✅ **`/mh poisons` is nu vermeld.** Rob vroeg onderweg of er ergens Valeera-advies over poisons
   en curios te vinden was. Gemeten: `PrintDelvePoisons` bestaat al (`DelveCuriosAdvisor.lua:1401`,
   een nette spelerprint met de omschrijvingen van de client en een markering op wat ze aan heeft)
   maar stond in `MH_UNLISTED_ON_PURPOSE`. 🔴 De rechtvaardiging daar was circulair: de comment
   noemde `poisons` een alias van `/mh poison` — en `poison` stond zelf óók in die lijst, dus er
   was geen primaire naam. Nu vermeld, met `poison` als echte alias.
9. ✅ **`/mh curio` opent eindelijk de adviseur.** De commandolijst beloofde twee dingen
   (`CMDLIST_CURIOS` = uitlegger, `CMDLIST_CURIO` = adviseur) terwijl `Core.lua` beide naar de
   uitlegger stuurde; het adviseur-blok was dode code. ⏳ Robs keuze open: enkelvoud/meervoud is
   een slechte scheidslijn — samensmelten tot één commando is eerlijker maar groter.
   Zie `docs/TESTLIJST.md` punt 12.
10. 🔴 **Twee blinde vlekken in de linter, gevonden door één toeval.** De pariteitscontrole zag
    `fill("deDE", { KEY = "..." })` op één regel niet: het contextpatroon zette de taal en
    `KEY_BARE_RE` is verankerd met `^`, dus de sleutel achter de accolade werd nooit gelezen.
    GEMETEN door alleen de opmaak te veranderen: zes vertalingen per taal doken op (deDE 3102 →
    3108). ⚠️ **Dezelfde fout zat in `collect_locale_values`, en dáár is hij gevaarlijk:** die
    voedt [13] markup en [15] must-stay-English, dus een eenregelige fill met een kapotte
    `|cff…|r` gaf een **vals sein-veilig**. Beide gerepareerd; [13]/[15] blijven 0, nu voor het
    eerst gemeten in plaats van ongezien.

## 🐍 Valeera-curio's Season 2 — onderzoek 2 sep, nog niet gebouwd

Rob vroeg onderweg om "zo'n adviesscherm zoals we in seizoen 1 hadden". **Dat scherm bestaat nog**
(`Modules/DelveCuriosAdvisor.lua`: paneel op de Delves-tab én popup bij de reparateur, per rol,
combat + utility, met aparte Nemesis-set). 🔴 **Alleen: `ns.DELVE_CURIOS_BY_SEASON` heeft een `[1]`
en geen `[2]`.** Sinds 18 aug heeft het niets te zeggen.

### De zes S2-curio's — LIJST DRIEDUBBEL BEVESTIGD

| Combat | Utility |
|---|---|
| Corrosive Bilespear | Soul-Cracking Dreamcatcher |
| Essence Trap | Dundun's Favor |
| Ouroboric Curse | Venom Infusion |

Bronnen van drie verschillende soorten, onafhankelijk: warcraft.wiki.gg (scheidt S1 en S2
expliciet), een datamining-blog van juni (PTR, geeft bewust géén advies), en de boost-sites.
✅ **Twee ervan staan in Blizzards eigen hotfixnotities** — Corrosive Bilespear (17 aug,
proc-fix) en Dundun's Favor (18 aug, lootbug). Beide staan al in `docs/PTR_12.1_WATCH.md`; de
17-aug-regel schreef er zelfs bij "raakt onze Codex-tekst niet maar wel het advies", en daar is
toen niets mee gedaan omdat er geen S2-tabel was om bij te werken.

📌 Positieve controle: de wiki zet onze drie S1-items (Porcelain Blade Tip = combat, Mandate of
Sacred Death + Overflowing Voidspire = utility) in precies de bakjes waar ons databestand ze heeft.

### De AANBEVELING — veel dunner dan de lijst

Iedereen zegt hetzelfde: **Corrosive Bilespear + Soul-Cracking Dreamcatcher voor alle drie de
rollen**, alleen de poison verschilt (Bloodcrypt voor tank/heal, Forgotten Master voor dps).

🔴 **Maar er is voor S2 GEEN eerstelijnsbron.** Wowhead schreef wél een "Best Valeera Curio
Loadout" voor Season 1 — waarschijnlijk waar onze S1-data vandaan komt — en **niets voor Season 2**.
Icy Veins evenmin. Alles komt van boost-/carry-sites die elkaar aantoonbaar overschrijven.
⚠️ Dat het advies voor alle drie de rollen identiek is, is verdacht simpel: dat kan betekenen dat
die twee domineren, of dat iedereen één build heeft gekopieerd. Niet vast te stellen.

### De concurrentie doet dit al — en zegt er niets bij

| addon | downloads | bijgewerkt | noemt zijn bron? |
|---|---:|---|---|
| Delve Companion | 516.500 | — | n.v.t. (geen advies) |
| **DelveGuide** | 151.154 | 29 aug | 🔴 nee |
| **Everything Delves** | 25.881 | 1 sep | 🔴 nee |

Everything Delves noemt letterlijk "Corrosive Bilespear for Combat and Soul-Cracking Dreamcatcher
for Utility, across all three companion roles" — een vierde stem, en een addon in plaats van een
verkooppagina, wat de consensus echter maakt.
⚠️ DelveGuide claimt "spec-by-spec curio recommendations for every class and specialization". Er
bestaat geen gepubliceerde S2-bron die zo fijnmazig gaat, en de addon noemt er geen. Niet te
controleren zonder hun data te lezen — dus **niet beweren dat het verzonnen is**, wel vaststellen
dat niemand het kán onderbouwen.

📌 **Dus: een kale "dit is de beste"-tabel maakt ons de vijfde stem die één build napraat.** Wat
niemand doet is zeggen wáár het vandaan komt en hoe zeker het is. Dat is precies deze addons
eigen stelregel, naar buiten gekeerd — en het is de enige hoek hier die van ons is.

### Wat nog moet gebeuren

1. ⏳ **Item-ID's meten, niet overschrijven.** Eén is hard: **Corrosive Bilespear = 249223** (wiki
   + WoWDB, twee bronnen). De rest niet. Rob opent Valeera's paneel in het spel → `/mh valeera
   save` → `/reload`, dan staan ze in `ns.db.companionProbe` en zijn ze GEMETEN uit zijn client.
   ⚠️ De probe stopt als dat venster dicht is — daarom die eerste stap.
2. **Robs keuze:** vullen met de consensus **mét herkomstregel**, of niets tonen tot er een betere
   bron is. Nu toont het scherm niets, en dat is de slechtste van de drie.

**Nieuw, 2 sep:**

7. **Delve-trinkets droppen minder sinds de hotfix van 1 sep.** Onze tips claimen geen droprate,
   dus er wordt niets onwaar — maar de PTR-wachter stelt voor het in het "wat farm ik hier"-advies
   te noemen. Robs keuze.
11. ✅ **Crest-rangen es/pt/it — GEMETEN EN GESLOTEN, 2 sep. Uitkomst: afblijven.** Alle drie de
    clients vertalen de rang wél, dus onze packs hebben het goed. Uit Wowheads gelokaliseerde
    currency-pagina's: esES *"Blasón del alba de héroe"*, ptBR *"Brasão Auroral do Herói"*, itIT
    *"Emblema dell'Alba del Campione"* (currency 3343). Spiegelbeeld van nlNL, precies zoals de
    comment in `KeepEnglish.lua` al voorspelde voor echte clienttalen.
    📌 `itIT.lua` zegt `"Champion"` en dat lijkt een besluit maar is er geen: de packs kopiëren
    het Engels voor elke sleutel zonder eigen vertaling, en de fill vervangt die kopie door
    `"Campione"` juist omdát hij gelijk is aan enUS. Deterministisch nagelopen in `fill()`.
    🔴 De vraag stond stil sinds 28 aug omdat het bestand hem naar **#translations** stuurde — een
    kanaal dat op 30 aug is opgeheven. Hij lag dus nergens. En hij had daar nooit hoeven liggen:
    Blizzards eigen data beantwoordde hem in twintig minuten. **Een vraag die bij de verkeerde
    eigenaar geparkeerd staat, blijft staan.**

### ✅ Robs drie beroepsbeslissingen — genomen én verwerkt op 2 sep

12. ✅ **`points`-semantiek → de VOORWAARDE wint.** 🔴 Bij het uitvoeren bleek Robs "30" een
    symptoom en niet de regel: `ProfessionAcademy.lua:204` vinkt een stap af bij
    `t.active >= t.max` — **tak vól**, met `max` uit de client. Er bestaat geen drempel van 30;
    30 is Recycling's maximum. `points` wordt alleen getóónd en stuurt niets.
    Dus niet een ander getal ingevuld, maar de voorwaarde uitgesproken:
    `PROFACAD_ADVISE_NEXT_POINTS_FMT` zegt nu *"about %d gets it working; this step only ticks off
    once the branch is full"*, in zeven talen, drift gemarkeerd.
    📌 Zo blijft Zygors feit (10 punten = recepten ontdekken) staan zonder te liegen over wanneer
    de stap afvinkt.
13. ✅ **Jewelcrafting stap 1 → `points = 5`**, zoals de gidsen zeggen.
14. ✅ **Inscription → `Darkmoon Curiosity`** toegevoegd als vierde boom, achteraan.
    ⚠️ Achteraan is voorzichtigheid, geen onderzoek: de volgorde van de eerste drie is gemeten,
    waar de vierde thuishoort niet. Wie dat uitzoekt mag hem verplaatsen.
    ✅ Naam geverifieerd met `_probe.py run audit_routes_vs_client` tegen Robs eigen capture:
    client zegt TAB, wij schrijven `tree`, **0 afwijkingen over alle 11 beroepen**. Een verkeerde
    naam was stil overgeslagen — de fout die op 31 aug twaalf stappen onzichtbaar maakte.

✅ **AF op 2 sep — `A Toxic Tour` (98515) is verhaal, geen daily.** Gemeten in Zygor 9.6: zijn eigen
dailies-gids noemt acht daily-ID's en 98515 zit er niet bij. De Codex zei nog "een keten van drie
quests" terwijl `CampaignLeadIn.lua` er al vier had; in zeven talen rechtgezet.

✅ **AF op 2 sep — B3 en B4.** Beide gemeten aanwezig: de milestone-poort in `DiscordNudge.lua:178`
en `CHANGELOG_ASK` in vier bestanden. Dit lijstje noemde ze nog als open — precies de fout die de
sectie bovenaan dit bestand beschrijft.

### 📌 Twee dingen die vandaag als werkwijze zijn vastgelegd

- **Niets aannemen, altijd meten** — óók voor "is dit al af?". Rob vroeg het twee keer en had
  twee keer gelijk. Een doc citeren is geen controle; een lege grep bewijst niets zonder
  positieve controle. Zie de nieuwe sectie in `CLAUDE.md`.
- **Nieuw gereedschap via de voordeur**: `python "<repo>/tools/_probe.py" run <tool> [args]`.
  Elk nieuw scriptpad kost Rob anders een prompt bij élke run.


## 📌 Ouder, maar nog niet af — staat in `docs/NEXT_SESSION_ARCHIVE.md`

De historie is op 2 sep afgesplitst. Deze secties lezen daar nog als OPEN, dus ze staan
hier bij naam — een openstaand punt mag niet verdwijnen door oud te zijn.

✅ **Alle negentien kandidaten zijn diezelfde middag één voor één nagelopen** (Rob: *"waarom niet
nu nalopen, ik ben toch onderweg"*), en elf bleken af. Het oordeel staat per stuk mét reden in
`KNOWN_DONE` in `tools/split_handoff.py`, zodat het na te lezen is in plaats van te geloven.
Onder de opgeloste: de dispel-aankondiging (staat in `docs/CURSEFORGE_3.7.0.md`), `fill()` die
eigennamen terugdraaide (nu `Locales/KeepEnglish.lua` + lintcheck [15]), de Season 1-tiersettabel
(op 29 aug verwijderd, leest nu de tooltip van je gedragen stuk) en de gehardcodeerde S1-ilvl's in
de delve-tooltip (weg uit `Modules/Delves.lua`).
⚠️ Eén blijft er staan die ik **niet** heb kunnen verifiëren: *MORGEN 19 AUG* (quest 96466).
Onverifieerd is niet hetzelfde als open, maar ook niet hetzelfde als af.
📌 Herclassificeren gaat met `python "<repo>/tools/_probe.py" run split_handoff --reindex --write`.

- 🆕 30 aug — waar komen onaangeleerde recepten vandaan? (OPEN)
- 🔵 OPEN 29 aug — de SMC-pin zet TWEE waypoints, plus één die niemand vroeg
- 💡 ROB-VERZOEK 19 AUG — "dit soort info moeten wij ook gaan bieden!!!"
- 🎯 MORGEN 19 AUG — PRIORITEIT: de EU-seizoensstart
- ⚠️ OPEN, en het raakt alle vertaalwerk
- 🌅 MORGENVROEG — twee dingen, en Rob brengt data mee
- 🔴 De grootste openstaande vraag (Rob, 11 aug)
- ⏳ Wacht op Rob

📌 Al het afgeronde werk staat in het archief; daar wordt niets meer aan
toegevoegd. Nieuwe regels horen bovenaan dit bestand.
