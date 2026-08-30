# Spec 31 — Bereik: waarom de community leeg blijft, en wat eraan te doen is

**Van:** ONDERZOEK-sessie, 30 aug 2026
**Voor:** BOUW-sessie (deel B) en Rob zelf (deel A en C)
**Aanleiding:** Rob: *"er is nog weinig leven in de community afdeling van MH … hoe bereiken we
meer mensen, of in ieder geval de mensen die nu al dagelijks met onze addon werken."*
**Methode:** vier parallelle onderzoeken (ecosysteem, social media, de addon zelf, vindbaarheid),
elk met dezelfde bronregels. Alle beslissende feiten hieronder zijn daarna door de hoofdsessie
zelf nagemeten; waar dat niet kon staat het erbij.

---

## 0. De uitkomst in één alinea

Het probleem is **niet** de Discord-instellingen (die zijn op 15 aug end-to-end nagelopen en
kloppen), **niet** het releasetempo (18 tags in augustus, gelijk aan de grootste concurrent) en
**niet** de kwaliteit. Het probleem zit op drie plekken tegelijk: **CurseForge kan ons niet
vinden** op de woorden waarop onze eigen doelgroep zoekt, **de addon vraagt op het verkeerde
moment het verkeerde ding**, en **we hebben nooit ergens verteld dat we bestaan.**

---

## 1. Correcties op wat we dachten te weten

| Wat wij dachten | Gemeten 30 aug 2026 |
|---|---|
| 6.849 downloads | **10.863** — dat oude getal komt uit de meting van 15 aug en is 15 dagen later ~59 % hoger |
| "Eén persoon heeft iets via GitHub gedaan" | **AndyMM22 stuurde vijf pull requests, alle vijf samengevoegd**, 7–8 aug (`gh pr list`) |
| CurseForge blokkeert ons (403) | **Niet meer.** Projectpagina en ~15 zoekopdrachten laadden schoon op 30 aug |
| Reddit is niet te bereiken | `reddit.com` blokkeert ons wél; alles ging via de spiegel `safereddit.com`. ⚠️ Die toont **korte** regelnamen, niet Reddits lange regelteksten |

---

## 2. 🔴 De hoofdvondst: CurseForge indexeert onze omschrijving niet

**Alleen de projectnaam en de samenvatting van ~200 tekens zitten in de zoekindex.** De
omschrijving van 28.382 tekens telt voor **nul** mee.

**Bewijs (nagemeten door de hoofdsessie, 30 aug).** Zoeken op `Openables` — een woord dat
letterlijk in `CURSEFORGE_DESCRIPTION.md` staat — geeft twintig resultaten, waaronder
`EnAbleQoL`, `RawMouseEnable` en `ReloadEnable`. De index matcht dus zelfs losse letterreeksen
binnen namen. **MH staat er niet bij.** Dat is beslissend: als het lichaam geïndexeerd wás,
hadden we op een exacte woordmatch bovenaan gestaan.

Twee gevolgen die er los van bewezen zijn:

**a) Er is geen stemming.** `weekly planning` → 1 resultaat, MH op #1. `weekly planner` →
5 resultaten, MH **afwezig**. Onze samenvatting staat in woordvormen die niemand intypt.

**b) 🎯 Onze eigen niche is een leeg schap, en wij staan er niet in.** Concurrentie per
zoekterm, geteld op een catalogus van 10.000+ addons:

| Wat iemand intypt | Aantal addons | MH |
|---|---|---|
| `returning player` | **1** (en die gaat over PvP) | afwezig |
| `beginner` | **4** | afwezig |
| `knowledge points` | 5 | afwezig |
| `concentration` | 12 | afwezig |
| `work orders` | 16 | afwezig |
| `weekly planner` | 5 | afwezig |
| `keybind coach` | 1 | **#1** |
| `professions` | 281 | afwezig |

📌 Die laatste twee rijen samen zijn het hele verhaal: waar het woord in onze **samenvatting**
staat, staan we eerste. Waar het alleen in de omschrijving staat, bestaan we niet.

---

## 3. DEEL A — wat Rob zelf kan doen, zonder code en zonder de bouw-chat

### A1. 🔴 De CurseForge-samenvatting herschrijven — een kwartier, en het belangrijkste van alles

**Nu (live):**
> *All-in-one WoW addon for Midnight Season 2: weekly planning, Delves & Great Vault, the Coiled
> Isle, route guidance and a class keybind coach. Seven languages, no dependencies, always free.*

Begint met het meest generieke woord dat er is, en bevat geen van de woorden waarop onze
doelgroep zoekt.

**Voorstel (~243 tekens):**
> **Explains WoW in plain language for the beginner and the returning player: a professions
> course (Knowledge Points, Concentration, work orders), Great Vault advice, Delves coaching, a
> weekly planner and a class keybind coach. Seven languages, free.**

**Kortere terugval (~148 tekens)** — de zoekkaart kapt rond 138 tekens af, dus voorin laden:
> **Explains WoW in plain language for the beginner and returning player: professions, Knowledge
> Points, Great Vault, Delves, weekly planner, keybind coach.**

⚠️ **Elke bewering hierin is na te trekken tot een module die we echt hebben** (cursus =
`ProfessionAcademy*.lua`, 14 hoofdstukken; Knowledge Points = `Knowledge*.lua`; vault =
`VaultAdvisor.lua`; keybind coach = `KeyboardLayoutPrototype.lua`). Er wordt niets overdreven.

**Bewust weggelaten:** "All-in-one" (generiek), "Midnight Season 2" (veroudert, en kost de
tekens die `knowledge points` nodig heeft — de spelversie-tags zeggen dit al), "Coiled Isle"
(echt verlies, bewust geruild tegen professions).

### A2. De vrije categorie invullen — twee minuten
CurseForge staat hoofd + 4 toe; MH gebruikt hoofd + 3 (`Miscellaneous`, `Map & Minimap`,
`Professions`, `Class`). **Voeg `Quests & Leveling` toe.**
📌 Overweging voor later: `Miscellaneous` als *hoofd*categorie is het schap voor "geen idee".

### A3. De GitHub-repo, vijf minuten
Gemeten via `gh repo view`, 30 aug:
- Omschrijving staat op `Project form Inchy & Gemma & Cursor` — met een typefout, en het zegt
  een vreemde niet wat de addon doet.
- **Geen topics.** GitHub's zoekfunctie draait daarop; vergelijkbare addons gebruiken
  `warcraft-addon` / `wow-addon` / `world-of-warcraft`.
- Geen homepage-URL (zet de CurseForge-pagina erin).
- 0 sterren, 0 issues ooit, Discussions uit.

### A4. De zes bijschriften bij de schermafbeeldingen — twintig minuten
Zes van de tien heten letterlijk `05-class-coach.png`. Dat is de laag die overslaande lezers
wél lezen. En: **er is geen enkele schermafbeelding van de professies-cursus**, ons sterkste
punt. `/mh course` openen en er één maken.
📌 `docs/SCREENSHOTS_WANTED.md` is verouderd — er staan er al tien online.

### A5. Twee dingen van vijf minuten die het natrekken waard zijn
- **Het CurseForge-vertaalsysteem.** Volgens hun eigen documentatie (22 jan 2024) bestaat er
  een gratis crowdsourced vertaalmodule met "open" modus, en WeakAuras gebruikt hem in
  productie. Maar `Modules/TranslateNudge.lua` noteert *"deprecated / absent from the new
  authors console — verified 2026-07-13"*. **Rob's eigen waarneming wint** — maar als het er
  tóch is, hoeft een vertaler geen GitHub en geen Lua meer te kennen, en dat is de goedkoopste
  ingang die bestaat.
- **De volgende CurseForge Addon Trials.** De ronde van 2026 leverde de winnaars 3 Wowhead- en
  2 Icy-Veins-artikelen op. MH viel af op de aanmaakdatum-grens. Alleen in de gaten houden.

---

## 4. DEEL B — voor de BOUW-sessie

### B1. 🔴 Eerst een never-lie-correctie, vóór alle nieuwe vragen
`TRANSLATE_HELP_DISCORD` (`Locales/enUS.lua:262`, vertaald in
`Locales/Translations2026.lua:2513-2537`) stuurt vertalers naar een vastgeprikte lijst in
`#translations`. In `CLAUDE.md` staat sinds 30 aug Robs eigen uitspraak: *"er is nog helemaal
niemand op Discord"*, en die route is dood verklaard. **De addon doet die belofte nu nog in zes
talen.** Of de lijst is echt en actueel, of de regel gaat eruit.

De eerlijke vraag is bovendien smaller en beter: *"Klopt deze zin niet in jouw taal? Stuur die
ene regel."* De GitHub-route in dezelfde functie (`Modules/TranslateNudge.lua:53`) is wél nog
goed.

### B2. Twee tabelregels die een echt defect repareren
`/mh discord` en `/mh translate` zijn wél gerouteerd (`Core.lua:1430-1438`) maar staan **niet**
in `ns.MH_COMMANDS` (`Modules/CommandList.lua:43-160`). Gevolgen:
- de "Alle commando's"-pagina noemt precies de twee commando's die over de community gaan niet;
- **NavSearch bouwt zijn index uitsluitend uit die tabel** (`Modules/NavSearch.lua:486-502`),
  dus `discord = "community help support invite chat server"` (`:478`) en `translate` (`:455`)
  zijn **dode code**. Typ "community" of "discord" in onze eigen zoekbalk en je vindt niets.

⚠️ `tools/lint_addon.py` controle [10] eist dat elk vermeld commando gerouteerd is — beide zijn
dat, dus dit komt schoon door de linter.
📌 Dezelfde ingreep herleeft nog een handvol dode trefwoorden (`pawn`, `wishlist`, `death`,
`pullsummary`, `consready`, en `groupbuffs` staat gesleuteld terwijl het commando `/mh gbuffs`
heet). Apart tickettje waard.

### B3. De Discord-nudge een echte `when` geven
Nu: `when = function() return true end` (`Modules/DiscordNudge.lua:161`) — de kaart staat er
vanaf de allereerste login, onder de onboarding-kaart (`Modules/HomeDashboard.lua:277-305`).
**We vragen een gunst voordat de addon er één heeft gedaan.**

Kandidaat-signalen die al bestaan en O(1) zijn:
- `ns.db.milestones` niet leeg (`Modules/Milestones.lua:32-38`) — MH heeft iets gevierd;
- `ns.MH_ManagedSlotCount() > 0` (`Modules/SetupNudge.lua:53`) — MH heeft hun bars gelegd;
- `db.changelog.lastSeenVersion` aanwezig én ongelijk aan de installatieversie — ze zijn door
  minstens één update heen, dus geen toerist.

⚠️ Het moet een signaal zijn dat **waar** is, geen leeftijdsheuristiek. `SetupNudge.lua:31-47`
is het waarschuwende voorbeeld in eigen huis: gebonden toetsen tellen mat "Blizzard levert
standaardwaarden", niet "deze speler heeft iets ingesteld".
⚠️ `NudgeActive` draait bij **elke** Home-render (`Modules/Nudges.lua:45-51`) — een tabelsleutel
lezen mag, iets doorlopen niet.

### B4. Eén regel in de voet van het changelog-venster
`ns:ShowChangelogWindow` opent vanzelf bij elke versiewissel (`Modules/Changelog.lua:845-865`).
**Dat is de grootste volledig ongebruikte plek in de addon**: iedereen die update ziet hem, de
gebruiker denkt op dat moment aan de addon en zijn maker, en de twee bestaande vinkjes
(`CHANGELOG_CB_VERSION` / `CHANGELOG_CB_NEVER`) zijn al een permanente uitschakelaar.

Bewoording volgens het model van B6, niet "join onze Discord". Bijvoorbeeld: *"Iets in deze
lijst fout, of ontbreekt er iets voor jouw klasse? Eén persoon schrijft dit; zeg het."*

### B5. `/mh report` — een kant-en-klaar rapport om te plakken
**De widget bestaat al.** `ns.ShowShareCopyDialog` (`Modules/DelvePartyShare.lua:431-571`) is
gedeeld, schaalbaar, scrollend, **meerregelig**, sluit op Esc, selecteert zichzelf, en wordt al
door vier modules gebruikt (`CurioExplain.lua:220`, `KeybindExport.lua:274`,
`StatCoach.lua:417`, `WorldContent.lua:592`).

⚠️ De Discord-kaart gebruikt hem **niet** — die heeft een eigen privaat boxje van 390×32
(`Modules/DiscordNudge.lua:97-98`) dat fysiek geen rapport kan bevatten. Zijn eigen kop zegt al
*"worth folding into one helper if a fourth shows up"*. Er is een vierde. Er zijn er vier.

Inhoud: addonversie (patroon: `Modules/SettingsPage.lua:298-302`), clientbuild (patroon:
`Modules/Retrospective.lua:143`), `GetLocale()` + effectieve MH-locale, klasse/spec/groepsgrootte/
instantie, plus de vrije tekst die de gebruiker meetypte. **Beide bestemmingen erin** — Discord
én de GitHub-repo — dan kiest de gebruiker wat hij toch al open heeft.

⚠️ **`issecretvalue`-guard is verplicht** op alles wat uit de wereld komt; `Core.lua:2306-2319`
is het precedent in eigen huis. En geen persoonsgegevens die de gebruiker niet zelf op zijn
scherm ziet staan.

### B6. Vragen hangen aan de plekken waar we toegeven dat we iets niet weten
**Dit is het sterkste moment dat bestaat**: de speler staat vóór iets waarvan MH zegt dat
niemand het gemeten heeft. Hij heeft de informatie die wij missen, nú, in handen.

Het model staat er al één keer in, en het werkt — `Locales/RitualTips.lua:117`:
> *"If you fight it, tell us what it did on Discord and it goes in"*

Het noemt het ontbrekende feit, zegt dat het erin gaat, en zegt níét "de community". De doelen:

| String | Plek |
|---|---|
| `DELVE_TIP_UNMEASURED` | `Locales/enUS.lua:1434` |
| `DELVE_REWARDS_UNMEASURED` | `Locales/enUS.lua:1437`, getoond in `Modules/Delves.lua:1964` |
| `MPLUS_AFFIX_UNMEASURED` | `Modules/DungeonGuide.lua:745-746` |
| `DELVE_CHEST_LEARNED` | `Locales/enUS.lua:537` |
| `HAZARD_SOURCE_NOTE` | `Locales/enUS.lua:1651` |

⚠️ **Dit is het voorstel dat het snelst een zeurpiet wordt.** De vraagzin hoort alleen op
inhoudsteksten die iemand bewust léést (delve-tip-pagina, bossstappen), nooit op een tooltip die
de muis volgt, en nooit met een knop die terugkomt. Waar het een tooltip is
(`Modules/Delves.lua:1964`) noemt de tekst `/mh report` — daarom moet B5 eerst.

### B7. Publiceren naar meer dan alleen CurseForge
`.github/workflows/release.yml` zet nu alleen `CF_API_KEY`. **Dezelfde `BigWigsMods/packager@v2`
die we al draaien publiceert in één run ook naar Wago, WoWInterface en GitHub Releases** — drie
`env:`-regels, één `.toc`-regel (`X-Wago-ID`) en één secret. WowUp (19 aug 2026) en instawow
(22 aug 2026) zijn beide aantoonbaar actief en lezen Wago.
📌 Eerlijke verwachting: enkele procenten, geen doorbraak. Maar het is eenmalig werk dat daarna
vanzelf blijft draaien.
⚠️ WoWInterface was op geen enkele URL bereikbaar (403) — levend of dood is **onbekend**.

### B8. Twee ontbrekende GitHub-bestanden
- `.github/ISSUE_TEMPLATE/bug_report.yml` — we hebben alléén `translation.yml`, dus wie een fout
  wil melden krijgt een leeg tekstvak. **Nul issues in vier maanden past daar precies bij.**
- `.github/ISSUE_TEMPLATE/config.yml` — vijf regels die de Discord-link op de "nieuw issue"-
  keuzepagina zetten. WeakAuras doet dit zo.

📌 En: **onze vertaal-issue-vorm is beter dan die van WeakAuras, BigWigs, Plater of Krowi.** Dat
vakje is afgevinkt; Weblate/Crowdin erbij halen loont niet bij een Lua-tabelformaat.

### B9. Bouwvolgorde
1. **B1** (never-lie-correctie) — mag niet naast nieuwe vragen blijven staan.
2. **B2** (twee tabelregels, repareert een defect en herleeft de zoekbalk).
3. **B3** (echte `when`).
4. **B4** (changelog-voetregel).
   → *stap 1 t/m 4 zijn samen één avond en raken vier bestanden.*
5. **B5** (`/mh report`).
6. **B6** (vragen op de ongemeten plekken; heeft B5 nodig).
7. **B7** / **B8** (buiten de addon, kan parallel).

---

## 5. DEEL C — waar we vertellen dat we bestaan

⛔ **Twee regels die boven alles gaan.** r/wow en r/wowaddons toetsen dit nu allebei expliciet:
1. **Rob schrijft de post zelf.** r/wow: *"The posts themselves must not be written by AI."*
   r/wowaddons' hoogst gestemde eis, die de mod heeft toegezegd te handhaven: auteurs *"need to
   be required to write their own posts"*, en *"the emoji-ridden list of features needs to go."*
   🎯 **Robs onvolmaakte Engels is hier een pluspunt, geen probleem — het bewijst dat een mens
   het schreef.** Een assistent mag de spelling nakijken; hij mag het niet schrijven.
2. **Vermeld het AI-gebruik, en beantwoord de differentiatievraag.** r/wow's AutoMod vraagt er
   letterlijk om. Goed nieuws: MH heeft een sterk antwoord — het legt uit in plaats van te
   tellen, en het is volledig vertaald in zeven talen.

### C1. r/wowaddons — de enige plek waar de regels "aangemoedigd" zeggen
24,9k leden, allemaal daar om addons te vinden. Zijbalk: *"Self promotion of mods is allowed and
encouraged."* Mod-bericht van ~4 aug 2026: *"AI is explicitly allowed."* Typische release-post
scoort 0–45; de goede halen 300–700.

Vorm die daar aantoonbaar werkt (afgekeken van de posts met 708, 445, 367, 302 en 243 stemmen):
open met het **probleem**, niet met de addon. Vier gewone opsommingstekens. Een eerlijke regel
over wat nog rammelt. Een korte alinea over hoe AI wél en niet gebruikt wordt. **Eindig met een
vraag** — *"helpt dat uitleggen echt, of wil je gewoon de checklist?"* Link als laatste. En
blijf daarna een dag in de reacties; dát is wat deze posts laat werken.

### C2. r/wownoob — 🎯 schrijf de uitleg, niet de advertentie
224,5k leden, en het is **exact** onze doelgroep. Regel 2 verbiedt "personal links or
advertisements" — dus post de kennis **zonder link**.

Wat die sub aantoonbaar wil:

| stemmen | reacties | titel |
|---|---|---|
| **236** | 41 | *"Wowhead guides kinda assume you already know a lot. Looking for other options."* |
| 258 | 103 | een door een gebruiker geschreven uitleg over BIS — vijf maanden later nog op de voorpagina |
| **114** | **112** | *"Am I missing something or do delves really have diminishing returns after 8?"* |
| 98 | 87 | *"I don't understand Delves, but would sure like to"* |

Die eerste regel is ons productidee, geschreven door een vreemde, 236 keer omhoog gestemd.

**En die 114-stemmen-vraag is er één die Rob al gemeten heeft** — T8 t/m T11 geven identieke
loot, alleen T6 en T11 zijn echte drempels, Bountiful is de enige bron van Journey- en
Valeera-XP. Niemand heeft hem behoorlijk beantwoord. Zie `memory/delve-tiers-12-1.md`.

**Geen link, geen naam van de addon, geen ondertekening.** Vraagt iemand ernaar, dan antwoordt
hij dat in een reactie.
📌 Flair: gewoon `Retail`. De `Advice/Guide`-flair bestaat maar is in een jaar één keer gebruikt.

⚠️ **Dit werk telt dubbel** — de uitleg staat al in de addon, in zeven talen. Eén hoofdstuk
omzetten naar een Reddit-post is een uur, geen project. Eerlijke inschatting: één post per
maand, en beloof niet meer.

### C3. Tweede ronde, als C1 en C2 bevallen
- **r/WowUI** (98,9k) — de grootste opbrengst (toppers 351–2.200 stemmen), maar die sub stemt
  met zijn ogen: één leesbare schermafbeelding is de toegangsprijs, en een titel zonder
  `[AddOn]`-tag wordt automatisch verwijderd.
- **r/wow** (3,2m) — herschreef ~12 aug 2026 zijn regels mét een `Addon/App/Website`-flair
  precies voor makers, en staat **AI-vertaling voor niet-moedertaalsprekers uitdrukkelijk toe,
  mits vermeld**. Beide vermeende zwaktes van Rob zijn nu benoemde uitzonderingen. ⚠️ Maar de
  mediane addon-post daar scoort **0** — één poging per week, geen verwachtingen.
- **De Franse en Duitse Blizzard-forums** (`Interface personnalisée`) hebben een levend
  2026-patroon van auteurs die `[Addon] …` posten, meest recent 29 aug 2026. Klein, permanent,
  en vriendelijk.

---

## 6. ⛔ Wat we NIET doen

| Niet doen | Waarom |
|---|---|
| **De omschrijving langer maken om trefwoorden toe te voegen** | Wordt niet geïndexeerd (§2). Pure kostenpost. |
| **Het project hernoemen om trefwoorden in de titel te proppen** | Zou wérken (naammatches domineren), maar verbrandt de merknaam en CurseForge modereert erop. |
| **Een GIF of video maken** | Onze kracht is tekst die iets uitlegt. Een lus van drie seconden brengt dat slechter over dan een stilstaand beeld. De enige goede GIF-kandidaat (de routepijl) toont juist onze minst onderscheidende functie. |
| **Nóg een nudge toevoegen** | De trechter is op 15 aug end-to-end nagelopen. Het probleem is plaatsing en de vorm van de vraag, niet het aantal. |
| **Discord Server Discovery najagen** | 1.000 leden vereist, en onder 200 leden worden er niet eens statistieken berekend. Rekenkundig buiten bereik. Afschrijven. |
| **Een donatieknop in de addon** | Blizzards addon-beleid, punt 5, letterlijk: *"Add-ons may not include requests for donations."* Op de CurseForge-pagina mag het wél. |
| **r/CompetitiveWoW** | Regel: *"NO AI. It is not welcome here."* Advertenties verboden, UI-zaken worden doorverwezen. |
| **Niet-Engelse subreddits** | Gemeten: r/WoWFrance 6,7k en vrijwel stil, r/wowbrasil 604, r/wowlatam 118, r/wowesp verbannen, een Duitse bestaat niet. |
| **Bluesky, TikTok, r/woweconomy, r/Warcraft** | Verkeerd publiek of te weinig opbrengst voor de tijd. |
| **De WoWInterface-forums** | Dood sinds 13 feb 2026. |
| **Icy Veins een gids aanbieden** | Die nemen personeel aan, geen inzendingen. |
| **Onze eigen Discord promoten als hoofdvraag** | 2 klikken is geen Discord-probleem. De Discord ís de verkeerde vraag. |

---

## 7. Meten — eerlijk over wat niet kan

| Instrument | Beantwoordt | Blijft onbekend |
|---|---|---|
| **CurseForge auteursdashboard** (gratis, unieke downloads per dag) | Of de nieuwe samenvatting werkt — **dit is een echt toetsbaar experiment**, 14 dagen ervoor tegen 14 dagen erna | ⚠️ Alleen geldig als er die dag géén release uitgaat, anders meet je de release |
| **Discord-invite-teller** | Hoeveel mensen de trechter kopiëren→alt-tab→plakken afmaken | Niets over wie de kaart zag of wegklikte |
| **Extra invite-codes per plek** (uitdrukkelijk toegestaan, `DiscordNudge.lua:20-21`) | Welke plek omzet | ⚠️ **Bij 2 aanmeldingen per maand staan die tellers maanden op 0 en 1.** Opzetten ja; beslissingen erop baseren nee |
| **GitHub Insights** | Bezoekers en verwijzende sites, 14 dagen | Kan een bezoek vanuit de addon niet onderscheiden van één vanaf CurseForge |
| **Tellen in SavedVariables** | — | ⛔ **Dat is geen meting.** Niemand stuurt zijn bestand op. De enige in-addon-getallen die Rob ooit bereiken zijn die van hemzelf en van Cisca |

⚠️ **En er bestaat geen gedocumenteerd geval van een addon waarvan de downloads aantoonbaar
stegen na een Reddit-post of een artikel.** Niemand — wij ook niet — mag hier een
omzettingspercentage noemen.

---

## 8. De maat, eerlijk

De twee addons in precies onze niche zitten op 2,7 miljoen en 1.019.940 downloads. Het verschil
is niet de kwaliteit en niet het tempo — wij brachten in augustus 18 tags uit, de grootste
concurrent ongeveer 20. **Het verschil is dat beide auteurs al een Twitch- of YouTube-publiek
hadden voordat ze begonnen, en één leent een al beroemde spreadsheet-merknaam.** MH is koud
gestart. Niets wat gratis is dicht een gat van honderd keer.

Wat wél kan: van *onvindbaar* naar *vindbaar* op vijf gemeten zoektermen, en van *een kamer
zonder deurbel* naar *een concrete vraag op het juiste moment*.

---

## 9. Wat niet geverifieerd kon worden

1. **WoWInterface** — 403 op elke URL. Levend of dood: onbekend.
2. **Wago's voorwaarden en downloadaantallen** — de site verslaat de fetcher.
3. **Reddits lange regelteksten** — alleen korte regelnamen via de spiegel. r/wownoob's regel 2
   is dus op de korte naam gelezen.
4. **De zelfpromotieregels van de grote WoW-Discords** — die staan achter een lidmaatschap.
5. **Of het CurseForge-vertaalsysteem nog bestaat** — hun documentatie en onze eigen meting van
   13 juli spreken elkaar tegen. Zie A5.
6. **Waar de Discord-trechter lekt** — "bijna niemand klikt" en "velen klikken, weinigen plakken"
   zijn verschillende problemen met verschillende oplossingen, en niets in de addon kan ze uit
   elkaar houden.
