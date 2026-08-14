# Wat MH onmisbaar maakt — een voorstel

Geschreven 14 aug 2026, op Robs vraag: *"wat zouden we nog moeten doen om MH het absolute
'hier kan ik echt niet meer zonder'-effect te geven?"*

Dit is een **mening**, geen meting. Alles wat hieronder als feit staat is wél nagekeken in
de code en de docs, met bestand en regel erbij. Waar ik gok, staat dat er.

---

## De diagnose, in één alinea

MH heeft geen inhoudsprobleem. Er zitten 24 tabbladen, ~114 commando's en 127.000 regels
in, en de nooit-liegen-discipline is zichtbaar in vrijwel elke bestandskop. Het probleem
is dat **een speler niet vindt wat er al is**, en dat het addon zich niet meldt op het
moment dat het ertoe doet. Dat is niet mijn conclusie, het is die van Rob zelf, twee keer
opgeschreven met vijf weken ertussen:

> *"there is no reliable mental model for 'where does X live?' — which is why even the
> author loses the thread, let alone a new user."* — `docs/REDESIGN_5_ROOMS.md`, 23 jun

> *"de addon is zo groot geworden dat hij zijn eigen dingen niet terugvindt."*
> — `docs/NEXT_SESSION.md:304`, 11 aug

En er is één datapunt dat precies vertelt wat wél werkt. De Raid Coach stond op de Tools-
launchpad **én** in NavSearch, en niemand vond hem — inclusief Rob, die hem zelf gebouwd
had. Wat hem wél zichtbaar maakte was één regel op Home, naast de weekcontent
(`Modules/HomeDashboard.lua:520`). Dat is een bewijs tégen "nog een index" en vóór
"het addon wijst zichzelf aan op het juiste moment".

---

# Deel 0 — De vier dagen tot 18 augustus

⚠️ **Lees dit eerst en zet de rest opzij tot het af is.** Season 2 opent op 18 aug. Een
addon dat op seizoensdag zelfverzekerd verkeerde dingen toont, verliest precies het
vertrouwen waar "kan niet meer zonder" op rust. Dit zijn geen ideeën, dit zijn schulden.

Alle vier hieronder heb ik zelf in de code nagekeken.

### 0.1 🔴 `seasonStats` is al omgerold — en het is retroactief

`Modules/SeasonStats.lua:61` `RollSeasonIfNeeded` leest de **kale** M+-season-id, zonder
datumpoort:

```lua
local cur = LiveSeasonId()          -- C_MythicPlus.GetCurrentSeason()
...
if s.seasonId ~= cur then           -- archiveer en begin opnieuw
```

Dat getal ging van 17 naar 18 op **patchdag** (11/12 aug), niet op seizoensdag. Het blok
dat straks "Season 2" heet bevat dus al een kleine week Season 1-keys, -deaths en
-bosskills, en `startedAt` wijst naar patchdag. Op 18 aug gebeurt er niets meer — hij
staat al op 18. Dit overtreedt de regel die het bestand zelf op regel 29 stelt: *"a Season 1
number must never appear under a Season 2 heading."*

**Fix:** poort `RollSeasonIfNeeded` op `ns.IsSeason2Live()`, precies zoals `IsSeasonLive()`
in `SeasonTransitionData.lua:246` het al doet met `seasonStartsAt`. Zonder handmatig in
SavedVariables snijden is de vervuiling niet meer terug te draaien, dus hoe eerder hoe
minder.

### 0.2 🔴 De M+-tab toont straks de S2-dungeonpool náást de S1-affixladder

`Modules/DungeonGuide.lua:720` en `:733` renderen `MPLUS_AFFIX_LADDER` en `MPLUS_BARGAINS`
**zonder seizoenspoort**, terwijl de dungeonpool drie regels verderop wel correct omklapt.
Onder een kop die "hoe keys werken dit seizoen" belooft.

Een half-correct paneel is gevaarlijker dan een zichtbaar verouderd paneel, want het is
overtuigender. **Fix:** ofwel S2-data erbij, ofwel die twee blokken verbergen met een
eerlijke regel ("nog niet gemeten voor dit seizoen").

### 0.3 🟠 De curio-popup opent straks leeg, mét titel

`Modules/DelveCuriosAdvisor.lua:688` zet titel en afmeting zonder datacheck; de rijen
verbergen zich individueel. Zonder S2-pack krijg je een net venster met niets erin. Dit
staat al sinds 6 aug als P0 in `docs/NEXT_UPLOAD.md`.

Bijkomend: `Modules/DelveCuriosData.lua:76` valt terug op `return 1` als de API ontbreekt —
wat om de expliciete *"NO fallback to season 1"*-garantie tien regels lager heen loopt.
Laat hem `nil` teruggeven en de consumenten verbergen zich vanzelf.

### 0.4 🟠 Drie dingen die Rob zelf al op zijn P2-lijst heeft staan

Uit `docs/NEXT_UPLOAD.md:119-141`, allemaal met "klopt vandaag, is op 18 aug fout" erbij:
de **world-boss-planner** (12.1 verving world bosses door Lairs; `Modules/WorldBoss.lua:9`
draait nog op een rotatie verankerd op 18 mrt), de **consumables-data** (stempel "Midnight
Season 1", `Modules/ConsumablesWowheadData.lua:11`), en **`VOIDCORE_SLOTS_REQUIRED = 3`**
(`Modules/VaultAdvisor.lua:1072`, alleen op de PTR gezien, nooit op live bevestigd — en hij
gaat op 18 aug een concreet "je hebt er nog N nodig" tonen).

### 0.5 Eén beslissing

`seasonStartsAt = 1787011200` is 18 aug **00:00 UTC**. De US-reset is die dinsdag ~15:00
UTC, de EU-reset woensdag ~03:00 UTC. Elke poort gaat dus tot ~28 uur te vroeg open. Het
bestand vlagt dit zelf (`SeasonTransitionData.lua:60`) en vraagt om verplaatsing naar de
reset als de content op de 18e nog dicht blijkt. Begrensd tot één dag — de oude bug was zes
— maar het is een echt raam.

---

# Deel 1 — De grote gok: het addon meldt zich op het juiste moment

Dit is wat ik zou bouwen als er maar één ding mocht.

**Het idee.** Eén klein systeem dat een set *momenten* kent — je loopt een delve binnen, je
staat bij de obelisk, je krijgt een keystone, je opent je beroepenvenster, je bent net twee
keer aan dezelfde rare doodgegaan, het is dinsdagavond en je Vault is nog leeg. Elk moment
kan door precies één bestaande feature geclaimd worden, en dat levert één kaartje op:
*"hier is het ding hiervoor"*, met een knop en een wegklik-kruisje.

**Waarom dit en niet nog een index.** De Raid Coach stond in twee indexen en werd niet
gevonden. Eén regel op Home, op het juiste moment, wel. Rob heeft dit zelf als optie 2
goedgekeurd (`docs/NEXT_SESSION.md:314`): *"De addon wijst zichzelf aan wanneer het
uitmaakt. Dit is het directe antwoord op de Carola-vraag."*

**Waarom het goedkoop is.** De machinerie staat er al: `Modules/Nudges.lua` met registratie,
wegklikbaarheid per id (`ns.db.nudgeDismissed`) en rendering op Home én Settings. Er zijn nu
vier nudges geregistreerd. Dit is registratiewerk, geen nieuwe motor.

**Wat het onmisbaar maakt.** Van 24 tabbladen en 114 commando's naar één belofte: *je hoeft
niet te weten waar iets woont, het komt naar je toe*. Dat is het verschil tussen een
naslagwerk en een compagnon.

**Waar het misgaat als je niet oppast.** Te veel kaartjes is precies de Cisca-shield-spam
in een nieuw jasje (`Modules/Auras.lua:19`). Regels die ik zou hanteren: maximaal één kaart
tegelijk, nooit tijdens gevecht, één keer weggeklikt is voorgoed weg, en een moment dat
niets te melden heeft meldt niets. En: **geen chatregel bij het inloggen** — Rob, 7 aug:
*"ik kijk zelden in de chat bij het opstarten"* (`Modules/MissingBuff.lua:389`).

**Eerste vijf momenten die ik zou registreren**, allemaal features die al bestaan en die
niemand vindt: delve binnenlopen → Delve Coach; obelisk/delve-ingang → tier-advies (zie
2.1); keystone in je tas → Keystone-paneel; beroepenvenster open → Now-doing (zie 2.3);
tweede dood aan dezelfde rare → SurvivalPlan (gebouwd omdat *"Carola keeps dying to rares…
She does not know which buttons to press"*, `Modules/SurvivalPlan.lua:6`).

---

# Deel 2 — Vijf features, op volgorde van wat ik zou doen

### 2.1 Tier-advies bij de ingang ⭐ het enige voorstel waar niets technisch op wacht

`docs/PROPOSAL_TIER_ADVISOR.md`, status "proposal, not built". Vertel de speler wélke tier
hij aankan terwijl hij bij de ingang staat te twijfelen. `C_DelvesUI.GetDelveEntranceTiers()`
wordt al aangeroepen door `TierProbe.lua`, `Knowledge.lua` én `KnowledgeRuntime.lua` — de
*lezing* bestaat, het *advies* niet.

Geblokkeerd op vijf beslissingen, niet op code: is `suggestedILvl` een poort of een
suggestie (meet het op een lage alt), equipped of overall ilvl, wat is een "comfortabele"
marge (een getal verzinnen is een gok), toast of paneel, en hoe toon je het aantal
challenges ernaast in plaats van erin.

Dit is de meest directe "wauw" in de lijst: het beantwoordt een vraag die iedereen elke keer
heeft, op de plek waar hij hem heeft.

### 2.2 Dispel-helper voorbij jezelf ⭐ de luidste klacht, en de meting staat op groen

`docs/NEXT_SESSION.md` noemt dit zelf *de sterkste volgende bouw*. `Modules/DispelHelper.lua`
bestaat, maar zijn eigen kop zegt: alleen je **eigen** debuffs; party- en raid-auras zijn
*"completely untouched"*.

De meting is er al en hij is groen: `HARMFUL|DISPELLABLE` op party-units gaf nul fouten over
zes tellingen, en hij discrimineert (party1 antwoordde 36/36 nee terwijl party3 in dezelfde
gevechten 36/36 ja gaf) — `docs/SPELLPILOT_TEARDOWN.md`. ⚠️ Gebruik hem als live ja/nee,
nooit om een frequentie te claimen: de probe vuurt op aura-activiteit, dus de steekproef is
scheef.

Waarom dit onmisbaar maakt: WeakAuras heeft hier niets voor op Midnight. Dit is de eerste
feature waarbij iemand in je groep merkt dát je MH draait.

### 2.3 Het "nu doen"-kaartje bij beroepen

`docs/PROFESSION_ACADEMY_PLAN.md` concept D, een complete bouwspec van 20 juni. Maximaal
drie concrete acties deze week bovenaan de Professions Hub. Bevestigd ongebouwd — geen
`_phNowCard`, geen `PROFNOW_*`-sleutels. Eén extra stap: `GetSpecSummary`, `GetAdviceForProf`
en `AllProfToolsEquipped` zijn `local function` in `ProfessionAcademy.lua`, dus er moeten
twee publieke wrappers voor.

### 2.4 Sessielengte als invoer — mijn eigen idee, en volgens mij de grootste

De Knowledge-runtime is af: ~3.270 regels, fixture-getest, met een inertheidscontrole die
elke wijziging bewijst dat hij niets tekent (`tools/check_knowledge_inert.lua`). Er staat
nul speler-zichtbare content achter, en **twee invoeren zijn in v1 permanent `null`**. Eén
daarvan is `available_session_minutes`, met als reden: *niet waarneembaar*.

Dat klopt — en het is ook precies het soort invoer dat je gewoon kunt **vragen**. Drie
knoppen op Home: *20 min · 45 min · een avond*. Daarmee wordt de vraag die niemand goed
beantwoordt — "ik heb een half uur, wat levert het meest op?" — ineens beantwoordbaar door
een motor die al gebouwd en getest is.

⚠️ Wel eerlijk zijn over de kosten: elk object staat nog op `status = "review"`,
`IsPlayerVisible()` weigert alles wat niet `approved` is, en **de 36 copy-keys bestaan
helemaal niet in `Locales/`**. Dit is dus geen middagje. Maar het is de enige richting in de
hele repo waar een groot, af, ongebruikt stuk techniek klaarstaat voor een vraag die geen
enkel addon goed beantwoordt.

### 2.5 Het eerste-keer-pad, één keer echt getesten

`docs/REVIEW_2026-07.md:89` noemt dit het zwaarste UX-punt in de hele review: **Carola zag
bij haar eerste login niets.** Geen welkomstregel, geen hint, alleen het minimap-icoon en
het onraadbare `/mh`. De uitstekende Start Here-tab en de tour waren daardoor onvindbaar.
En de eerlijke voetnoot bij haar geslaagde hertest (`docs/NEXT_SESSION.md:967`): *"het
first-run-pad is nog door niemand getest… ze is er allang voorbij."*

Dit is per persoon één keer meetbaar en het bepaalt of een verse CurseForge-installatie
blijft plakken. Ik zou het uitbreiden tot drie vragen bij de eerste start — rol, ervaring,
taal — en op basis daarvan de juiste vijf dingen aanzetten en het eerste moment-kaartje
tonen. Iemand die MH nog nooit gezien heeft moet dat doen, niet Rob.

---

# Deel 3 — Goedkope geloofwaardigheidsgaten

Geen van deze is "wauw". Alle vijf ondermijnen ze wél het vertrouwen waar wauw op leunt.

| | Wat | Waar |
|---|---|---|
| 3.1 | **43 hardcoded Nederlandse tooltips** in de Silvermoon-gids, getoond aan élke gebruiker in élke taal. Rob zag ze zelf op auto/Engels. Grootste onvertaalde plek die er is — en er is op 12 aug per ongeluk een 44e bijgekomen door het patroon van de buren te volgen. ⚠️ Niet in één klap doen: 43 × 7 ≈ 300 strings is exact het soort massabewerking dat op 22 juli drie locale-bestanden brak. | `UI.lua:759` |
| 3.2 | **Vijf "features" in de commandolijst zijn dev-probes**, met beschrijvingen die niet kloppen. `/mh mbuff` heet "toggle the missing buff reminder" en toggelt niets; `/mh trail` heet "plan a way to get somewhere" en is *"MEASUREMENT ONLY… not wired into the travel assistant"*; `/mh nodes`, `/mh weeklies` en `/mh folio` idem. De linter controleert alleen dát een commando ergens gerouteerd is — hij kan een feature niet van een probe onderscheiden. Dit is exact de Alt+M-fout in zijn eigen commandolijst. | `Modules/CommandList.lua` |
| 3.3 | **Hoofdstuk 9 van het beginnersboek beschrijft een verkoop-adviseur die niet bestaat**, inclusief een geciteerde string die nergens in de codebase voorkomt. Twee opties: hoofdstuk herschrijven, of de feature bouwen en het hoofdstuk wordt waar. | `docs/DOCUMENTATION_IMPACT.md:104` |
| 3.4 | **AccessibleAlerts is goed ontworpen, onvindbaar en de facto leeg** — één debuff-id (`[440313]`), en alleen bereikbaar vanuit de Dungeon Guide, niet uit Settings. De toegankelijke route bestaat, is doordacht, en is verborgen én ongevuld. | `Modules/AccessibleAlerts.lua:29` |
| 3.5 | **~55 probe-emmers in de SavedVariables van elke speler** — `atalProbe`, `auraDump`, `eventSpy`, `vignetteCapture` en vijftig andere. Iedereen draagt de meetapparatuur mee. Een schema-v2 die dev-buckets opruimt hoort sowieso bij 3.0.0, want er is nu **geen enkele** seizoensmigratie (`Core.lua:243`: één migratie, over spookvelden). | `Core.lua:241` |

---

# Deel 4 — Wat ik níét zou doen

Ter bevestiging dat ik het gelezen heb, en zodat dit niet over een half jaar terugkomt:

- **Ground Safety / "MOVE!"-flits** en **interrupt-credit** — allebei dood door meting, niet
  door moeite. De combat log weigert: vier pogingen, vier `ADDON_ACTION_FORBIDDEN`, nul
  successen. En het oude argument "DBM doet het dus het kan" is weerlegd in DBM's eigen
  broncode (`DBM-Core.lua:1680` blokkeert CLEU op Midnight+).
- **`aura.canActivePlayerDispel` als route om de dispel-tabel over te slaan** — 477 metingen,
  leesbaar precies wanneer `spellId` dat ook is. `docs/SPELLPILOT_TEARDOWN.md` zegt letterlijk:
  niet opnieuw bekijken omdat een concurrent het gebruikt.
- **Live rotatie-coach tijdens levelen** — drie brainstorms kwamen onafhankelijk op *niet
  doen*: hoog onderhoud, concurreert recht met RestedXP/Zygor, buiten MH's identiteit.
- **Simple/Full-toggle** — al uitgefaseerd, `Core.lua` nilt het veld actief weg.
- **Tier terugschrijven in de RitualLog** — het experiment faalde: de client zegt nooit welke
  tier je koos. Tier 0 betekent onbekend en moet dat blijven.
- **De 35-taks slash-dispatch-tabel herschrijven** — bewust geparkeerd als hoog risico, lage
  gebruikerswaarde. Daar ben ik het mee eens.

---

# Als ik moest kiezen

**Deze week:** 0.1 tot en met 0.4. Niets anders. Een addon dat op seizoensdag klopt, verdient
de aandacht die de rest van deze lijst nodig heeft.

**Daarna, in deze volgorde:** het moment-systeem (deel 1) met de vijf genoemde momenten →
tier-advies (2.1) als eerste echte moment → dispel voorbij jezelf (2.2) → 3.1 en 3.2 als
opruimwerk tussendoor → en dan de grote vraag of de Knowledge-runtime aangezet wordt met
sessielengte als invoer (2.4).

**En één ding dat niets kost:** laat iemand die MH nooit gezien heeft één keer installeren
terwijl je meekijkt. Dat is de enige meting in dit hele document die je niet zelf kunt doen,
en volgens de review de zwaarste die er is.
