# Dispel-helper: hercontrole 7 okt 2026

Geplande hercontrole uit `aura-facade-12-1` en `mh-market-position` ("rond 7 okt").
Alleen gelezen en gemeten, niets gebouwd, geen git.

Labels per bewering:
- **GEMETEN** = gezien in een bron met naam en datum, of in Robs eigen bestanden.
- **KANDIDAAT** = staat in een andere addon of een changelog. Een aanwijzing, geen bewijs.
- **AFGELEID** = mijn eigen redenering.

---

## Het korte antwoord

1. **Aan de API is sinds 7 sep niets veranderd dat de deur opent.** Ook niet in 12.1.5 (live op 13/14 okt).
2. **Het "stil verkeerd" van 12 en 31 aug is geen toeval. Het is zo bedoeld, en nu weten we waarom.**
   Vragen op spell-ID werkt in gevecht alleen voor buffs die Blizzard "niet geheim" heeft gemaakt.
   Al het andere geeft gewoon niets terug. Dat geldt ook voor de route naar een ánder character.
3. **Er zit een fout in onze eigen meting van 31 aug.** De "twee calls die elkaar tegenspraken" waren
   geen tegenspraak: `GetAuraDataBySpellID` bestaat niet. "absent" betekende "deze functie is er niet".
4. **PIHelper werkt omdat hij buffs volgt die Blizzard zelf vrijgaf.** Dat zegt niets over boss-debuffs.
5. **De zichtbare route bestaat wél, en MH heeft hem al**: de rode rij in `/mh partytargets` (Blizzard
   tekent, wij versieren). Daar zit één open probleem in: hij licht soms op voor iets wat jij niet kunt weghalen.
6. **Advies:** de deur voor een *lezende* dispel-helper (geluid of tekst "dispel X nu") blijft dicht.
   Twee kleine, veilige dingen zijn het meten waard. Zie het einde.

---

## 1. Wat is er veranderd sinds 7 sep?

### 1a. De officiële API-lijsten

- **GEMETEN** (Warcraft Wiki, "Patch 12.1.5/API changes", laatst bewerkt 6 okt 2026): vier PTR-builds
  na 7 sep: 69594 (3 sep), 69848 (16 sep), 69952 (22 sep), 70077 (29 sep). Nieuw bij de aura's:
  alleen `C_UnitAuras.GetAuraCasterGUID` en `C_UnitAuras.GetRefreshCarryOverDuration`, plus
  uitbreidingen aan AuraContainer/AuraButton (animaties, naam van de caster, items uitzetten).
  **Niets** over `GetUnitAuraBySpellID` of `GetPlayerAuraBySpellID`.
- **GEMETEN** (zelfde pagina, build 69848, 16 sep): Blizzard repareerde dat `includeSpellIDs` in een
  AuraContainer ook andere aura's doorliet. Ze noemen het filter expliciet "voor nooit-geheime aura's, zoals Sated".
- **GEMETEN** (zelfde pagina, build 70077, 29 sep): `AddAuraSound` speelt een geluid nu maximaal
  5 seconden af, en accepteert geen `throttleSeconds` boven de 5.
- **GEMETEN** (Wiki, "Patch 12.1.0/API changes", revisiegeschiedenis): na 5 sep alleen kleine
  bewerkingen (18, 22 en 25 sep, +71 bytes of minder). Geen nieuwe regels over aura's.
- **GEMETEN** (Wiki, zoekpoging "Patch 12.1.7/API changes"): bestaat nog niet (404).
- **GEMETEN** (Blizzard Watch, 29 sep): 12.1.5 gaat live op 13 okt (NA), dus 14 okt in Europa.

### 1b. GetUnitAuraBySpellID / GetPlayerAuraBySpellID in gevecht

- **GEMETEN** (Wiki, pagina `API:C_UnitAuras.GetUnitAuraBySpellID`, ruwe tekst gelezen 7 okt): het
  spell-ID-argument draagt de markering `RequiresNonSecretAura`. Voor `GetPlayerAuraBySpellID` staat
  hetzelfde. Ook `GetAuraDataBySpellName` heeft die markering.
- **GEMETEN** (Wiki, "Secret values", laatst bewerkt 23 sep 2026): die markering betekent dat de aura
  op dat moment niet geheim mag zijn. Is hij wél geheim, dan krijg je **geen fout, maar ook geen
  antwoord**. Precies wat Rob op 12 en 31 aug zag.
- **GEMETEN** (Blizzard-bericht uit de WoW UI Discord, overgenomen in een forumdraad op 25 feb 2026):
  Blizzard maakte een lijst spells "niet geheim". Daarin staan o.a. Arcane Intellect (1459),
  Power Word: Fortitude (21562), Skyfury (462854), Battle Shout (6673), Icicles (205473), Prescience
  (410089), Beacon of Light (53563). Ze schrijven er zelf bij dat ze die later misschien weer geheim maken.
- **AFGELEID, maar het past precies:** alle buffs die MH in gevecht wél vond, staan op die lijst:
  Fortitude (28 jul, 155×), Arcane Intellect (12 aug), Skyfury (31 aug), Icicles (3 okt).
  De buffs die terugkwamen als niets, staan er níét op. Eén uitzondering die we niet kunnen
  verklaren: Flight Style: Steady (404468) wordt ook gevonden, maar staat niet op die februarilijst.
  Er bestaan dus meer vrijgegeven aura's dan deze lijst.
- **AFGELEID:** de "unit-route" naar een ander character (`GetUnitAuraBySpellID("party1", id)`) heeft
  dezelfde `RequiresNonSecretAura`. Hij vindt dus ook alleen vrijgegeven aura's. Boss-debuffs staan
  niet op zo'n lijst (die zijn geheim of zelfs privé). **Deze route kan een dispel-helper niet dragen.**
  Niet gemeten met een groep; dat lijkt me ook niet meer nodig.

### 1c. De filters DISPELLABLE, RAID_PLAYER_DISPELLABLE en IMPORTANT

- **GEMETEN** (Wiki, `API_types/AuraFilters`, ruwe tekst 7 okt):
  - `HARMFUL|RAID` = "alleen debuffs die *de speler* kan dispellen".
  - `HARMFUL|RAID_PLAYER_DISPELLABLE` = "alleen debuffs die *iemand in je groep* kan dispellen".
  - `DISPELLABLE` = "alles met een dispel-type, ongeacht of iemand het kan".
  - `IMPORTANT` is in 12.1.0 teruggekomen.
- **GEMETEN** (Wiki 12.1.0): op spell-ID filteren in een AuraContainer (`includeSpellIDs` /
  `excludeSpellIDs`) werkt alleen voor aura's die als niet-geheim gemarkeerd zijn.
- **GEMETEN** (PTR-meting van 4 sep, build 69594, in Robs XPTR-bestand): `GetAuraSlots` met
  `HARMFUL|DISPELLABLE` wordt in gevecht **geweigerd** met een Lua-fout. Een filter gebruiken om zélf
  te tellen kan dus niet. Een filter meegeven aan een AuraContainer kan wel (zie 1d).

### 1d. AuraContainer en private auras

- **GEMETEN** (Wiki 12.1.0): AuraContainers behandelen private auras nu als gewone aura's. Ze
  worden dus gewoon getoond.
- **GEMETEN** (Blizzard-blogpost uit juni, geciteerd op de wiki): de addon bepaalt hoe het eruitziet;
  het spel bepaalt wát er staat. De addon krijgt de gegevens zelf nooit te zien.
- **GEMETEN** (Wiki 12.1.5, blauwe post Linxy 3 sep): Blizzards eigen raid frames krijgen een optie
  voor "mieren" (een bewegende stippelrand) om een frame **als jij er iets af kunt dispellen**, en een
  optie om de dispel-kleurlaag te laten pulseren. De CVars heten `raidFramesDispelIndicatorAnimatedBorder`
  (nieuw in 12.1.5, build 69952) en `raidFramesDispelIndicatorOverlayAnimation` (al in 12.1.0).

### 1e. Hotfixes op live

- **GEMETEN** (Blizzard-hotfixpagina, versie "October 6, 2026", via Exa met nocache): tussen 7 sep en
  6 okt staat er **geen regel over addons of geheime waarden**. Wel kreeg een paar aura's een andere
  weergave in Blizzards eigen UI: Deathmark groot op raid frames (22 sep), Boiling Venom op Mythic een
  "Important Aura" (21 sep). Positieve controle: mijn zoekpatroon vond op dezelfde pagina wél het kopje
  "User Interface" van eind augustus.

### 1f. Wat onze eigen wachters erover schreven

- **NIET GELEZEN.** `docs/API_WATCH.md`, `docs/PTR_12.1_WATCH.md` en `docs/PTR_12.0.7_DATA.md` liggen in
  `docs/`, en mijn eigen werkregels verbieden mij daar iets te lezen (alleen dit rapport schrijven
  mocht). De bouwchat moet die drie dus zelf nalezen vanaf 2026-09-07, op `aura`, `DISPELLABLE`,
  `secret` en `C_UnitAuras`. Ik zeg dit erbij omdat weglaten zou lezen als "nagekeken en niets gevonden".

---

## 2. Een correctie op onze eigen meting van 31 aug

- **GEMETEN** (code, `Modules/Auras.lua:338-347`): de functie `Outcome` geeft `"absent"` terug als
  de functie **niet bestaat**. Krijgt hij een leeg antwoord, dan geeft hij `"nil"`.
- **GEMETEN** (Robs XPTR-bestand, `ptrProbe`, 4 sep 2026, 12.1.5 build 69594): de volledige lijst van
  `C_UnitAuras` telt 39 functies. `GetAuraDataBySpellID` zit er niet bij.
- **GEMETEN** (Wiki, 7 okt): `API:C_UnitAuras.GetAuraDataBySpellID` geeft 404. Positieve controle:
  `GetAuraDataBySpellName` en `GetUnitAuraBySpellID` bestaan wel op dezelfde wiki.
- **AFGELEID:** de regel in `Auras.lua:133-143` ("de twee calls spraken elkaar tegen, dus
  GetAuraDataBySpellID geeft een zeker fout antwoord") klopt niet. Die functie bestaat niet; daarom
  stond er bij alle acht "absent". Het eerste blok in `Aura.GetPlayerAura` (r. 87-95) is dus dode code.
- **AFGELEID:** de conclusie blijft wél staan. `GetPlayerAuraBySpellID` gaf 7 van de 8 keer niets
  terug. Alleen het "bewijs" voor de tegenspraak valt weg. Het echte bewijs is nu de documentatie (1b).
- 📌 Ook in de geheugenbestanden `aura-facade-12-1` en `mh-market-position` staat die tegenspraak.
  Die moeten mee worden aangepast. Dat is werk voor de bouwchat; ik heb niets veranderd.

---

## 3. PIHelper

- **GEMETEN** (CurseForge-API, via Exa met `nocache=20261007`):
  - Laatste versie **1.7.0**, geüpload **7 sep 2026**. Daarna niets meer.
  - 7 bestanden, van 1.1.1 (29 aug) tot 1.7.0 (7 sep). Alleen gemarkeerd voor 12.1.0.
  - **15.279 downloads** (de bestanden samen: 15.263). Op 7 sep waren dat er ~1,9K.
  - Licentie: **All Rights Reserved**. Auteur: squided. Project-ID 1669833.
- **GEMETEN** (beschrijving): een helper voor Priests (Power Infusion). Hij volgt een lijst buff-ID's
  op DPS-spelers en laat hun raid frame oplichten zolang die buff aanstaat. Werkt met Blizzard-frames,
  ElvUI, Grid2, DandersFrames, EllesmereUI, Cell, VuhDo e.a. De auteur zegt zelf: een cooldown zonder
  zichtbare buff kan hij niet zien, want addons zien in gevecht de casts van anderen niet.
- **GEMETEN** (changelogs): 1.5.0 Mich's Raid Frames, 1.6.0 Cell, 1.7.0 fluister-optie alleen in raid.
  Geen enkele regel over aura-toegang.
- **GEMETEN** (reacties, 20 van 23 gelezen):
  - 3 okt: "doet wat het belooft", werkt met EllesmereUI.
  - 22 sep: "werkt perfect", vraagt hetzelfde voor Prescience.
  - 9 sep: "werkt in raid, maar lijkt in M+ niet te helpen" (met DandersFrames).
  - 20 sep: met AtrocityUI vindt hij geen frames.
- **AFGELEID:** PIHelper bewijst niet dat de unit-route voor dispels werkt. Hij volgt *spelersbuffs*,
  en die kan Blizzard vrijgeven. Prescience staat zelfs op de februarilijst. Boss-debuffs zijn een
  andere soort aura. De M+-melding past bij het beeld dat M+ strenger is.
- Geen code gelezen of overgenomen.

---

## 4. Andere addons die dispels markeren (allemaal KANDIDAAT)

- **DandersFrames v5.3.3** (lokaal geïnstalleerd, bestand van 16 sep). In zijn changelog voor 5.0.0:
  alle aura-rijen lopen nu via de nieuwe beschermde aura-motor van het spel. De dispel-overlay draait op
  die motor en **toont boss-debuffs (private auras) vanzelf**. Debuffs verbergen kan alleen voor
  niet-geheime debuffs; encounter-debuffs blijven altijd staan. Spell-ID-filters werken alleen op
  units die je kunt helpen.
- **Grid2 4.0.12** (WowAce, 15 aug 2026): draait op aura containers, met een rand in de dispel-kleur.
  4.0.33-beta (24 sep): randen gerepareerd voor 12.1.5. Nieuwste: 4.1.4-beta (5 okt), niets over dispels.
  Eerder (Grid2 3.3.24, 12.0.5) liet de auteur weten: Grid2 kan alleen Blizzards eigen dispel-overlay
  tonen; private auras zijn een gesloten doos.
- **HexBreak 0.6.23 Beta** (lokaal geïnstalleerd). Zijn changelog noemt de motor: `HARMFUL|RAID` +
  AuraContainer + veilige klik-knoppen. Plus een "native" geluid als jij zelf iets dispelbaars krijgt.
  Van HexBreak 0.6.12 heeft MH de rode rij afgekeken (staat in `PartyTargets.lua:115`).
- **DBM** (lokaal): registreert geluiden per spell-ID via `C_UnitAuras.AddAuraSound`, met
  `unitToken = "player"` (`DBM-Core/modules/objects/BossMod.lua:1496-1513`).
- **ElvUI**: hun wiki raadt filterstrings aan, zoals `HARMFUL|RAID_PLAYER_DISPELLABLE`. Datum onbekend.
- **EllesmereUI** (Boostmatch, 13 aug): bij debuffs op je eigen groep kun je niet filteren op spell-ID.
- **Cell**: op GitHub is de nieuwste release r279-beta van 9 aug; daar zie ik geen 12.1-versie.
  Kan een cache zijn, of hij wordt elders bijgewerkt. Onzeker.
- **AFGELEID, het patroon:** wie in 12.1 dispels laat zien, laat **Blizzard** het tekenen
  (AuraContainer of Blizzards eigen overlay). Niemand leest de debuff zelf uit. Voor geluid gebruikt
  men `AddAuraSound` op een bekende spell-ID, en voor zover ik zag alleen voor jezelf.

---

## 5. Wat MH zelf al heeft

### 5a. De code

- **GEMETEN** `Modules/DispelHelper.lua`: het alarm voor jezelf ("je hebt iets wat je zelf kunt
  weghalen") leest je eigen debuffs. `ns.AllyHasRemovableAura` (r. 371) vraagt `GetAuraSlots` en wordt
  in gevecht geweigerd (4 sep). `PrintDispelProbeSelf` (r. 553) vraagt op spell-ID.
- **GEMETEN** `Modules/DispelCapture.lua`: verzamelt echte dispelbare debuffs (met school en baas) en
  houdt drie logs bij. **Geen van die logs bewaart een datum.** Er wordt nergens een `at` weggeschreven.
- **GEMETEN** `Modules/Auras.lua`: `/mh dispelprobe` en `/mh dispelprobe watch` **sommen op**. In
  gevecht worden ze dus geweigerd. Ze beantwoorden de vraag van vandaag niet.
- **GEMETEN** `/mh dispeltest [decide|show|combat]` (`DispelTest.lua`) en `/mh dispellog [clear]`
  bestaan.
- **GEMETEN en belangrijk: `Modules/PartyTargets.lua` heeft al een werkende AuraContainer-route.**
  `/mh partytargets` toont een paneel. Per rij zit er een Blizzard-container op met filter
  `HARMFUL|RAID` (r. 128). Komt er iets op wat jij kunt dispellen, dan tekent het spel de rij rood met
  "DISPEL", en met rechts-klik dispel je. MH leest de debuff nooit. Diagnose: `/mh glow` en
  `/mh glow test`. Volgens de commentaren in de code zag Rob het op 26 aug werken in Maisara Caverns
  (toen nog als dunne lijn). Ik noem dat een aantekening in code, geen meting die ik heb nagekeken.

### 5b. Robs SavedVariables (stand van het bestand: 6 okt 2026, 21:48)

Bestand: `WTF/Account/JOEYWHATEVER/SavedVariables/MidnightHelper.lua`.

- **`dispelFieldLog`** (GEMETEN, **geen datum**, opgeteld sinds de laatste `clear`):
  - je eigen debuffs opsommen **in gevecht**: 170.324 keer **geweigerd**, 0 keer gelukt;
  - buiten gevecht: 44.582 keer gelukt;
  - buiten gevecht zijn spellId, naam, dispelName én `canActivePlayerDispel` leesbaar.
- **`dispelLookupLog`** (GEMETEN, **geen datum**, opgeteld):
  - in gevecht 44.839 keer gevraagd naar 89 spell-ID's. **Nooit meer dan 1 treffer per keer.** Die ene
    is Flight Style: Steady (404468), 44.805 keer gevonden.
  - Gemist, bij elke ronde: o.a. Devotion Aura (465), Flask of the Magisters (1235108), Warband Mentored
    Leveling (430191), Fortitude of the Bear (388035). Geen van die vier staat op Blizzards lijst.
  - buiten gevecht: in de laatste ronde 10 van 10 gevonden (22.311 rondes).
  - De teller in gevecht is **gelijk** aan die in de `.bak` van 21:40. In de laatste sessie (21:40-21:48)
    is dus niet gevochten. Wanneer de laatste meting in gevecht was, staat nergens.
  - ⚠️ AFGELEID: de lijst `dispelRecentIds` zit vol (30 ID's, van meerdere characters, inclusief
    mounts). Een "miss" op een mount is dus geen bewijs. De sterke cijfers zijn "max 1 treffer" en
    Devotion Aura.
- **`dispelFilterProbes`**: alle tellers zitten op het plafond van 200. Oude data (vermoedelijk 3 aug,
  12.0.7). Zegt niets over 12.1.
- **`dispelSelfLog`** (GEMETEN, **mét datum**, 27-30 sep). Na elk gevecht kijkt MH welke van jouw
  eigen debuffs het rij-filter `HARMFUL|RAID` raakt. 7 regels; **4 daarvan zijn Magic, terwijl jouw spec
  geen Magic kan weghalen** (`youCan = false`):
  - Corrosive Breath, 29 sep;
  - Soul Torment, 2× op 30 sep, in Windrunner Spire;
  - Chilled, 30 sep;
  - Weight of Greed, 30 sep.
  De andere 3 (Venom Bite, Festering Gash) kon je wel weghalen. **Dus licht de rode rij soms op voor
  iets wat jij niet kunt weghalen.** Dat past bij Robs melding van 27 sep. Waaróm de wiki het anders
  beschrijft, weet ik niet (AFGELEID: open vraag).
- **`rezLustLog`** (GEMETEN, **mét datum**): `GetPlayerAuraBySpellID` vond Sated (57724) in gevecht
  14.336 keer, van 30 sep 20:17 tot 6 okt 21:23 (live, interface 120100). Sated is een nooit-geheime
  aura. Dit bevestigt het beeld: vrijgegeven aura's antwoorden in gevecht, en dat gaat betrouwbaar.
- **XPTR-bestand** (12.1.5, bestand van 3 okt 11:06): in gevecht 80 rondes, max 3 treffers. Gevonden:
  Arcane Intellect (66×), Flight Style (80×), Icicles (29×). Niet gevonden: o.a. Sign of the
  Dragonflights. AFGELEID: dit komt uit de sessie van 3 okt rond 11:00, want daar zat 81 seconden
  gevecht tussen en de teller staat op 80 rondes. **Ook op 12.1.5 antwoorden alleen vrijgegeven aura's.**
- **`dispelAlert.enabled = true`** (GEMETEN): Robs zelf-alarm staat aan, maar in gevecht wordt het
  opsommen altijd geweigerd (zie `dispelFieldLog`). AFGELEID: in gevecht zegt het dus nooit iets.
- **`partyTargets = true`** (GEMETEN): Rob gebruikt het paneel met de rode rij.

---

## 6. Conclusie in gewone taal

### Blijft de deur dicht?

**Ja, voor een dispel-helper die zélf leest** ("er zit Magic op Cisca, dispel nu", met geluid of tekst).
- GEMETEN: opsommen wordt geweigerd (170.324×).
- GEMETEN in de docs: op spell-ID vragen geeft voor geheime aura's niets terug, en dat is zo bedoeld.
- AFGELEID: boss-debuffs zijn geheim of privé. Dat is ook zo voor een ander character.
- AFGELEID: 12.1.5 verandert hier niets aan.

### Is er een nieuwe route die het meten waard is?

**Ja, twee kleine. Geen van beide leest iets; Blizzard doet het werk.**

**Meting A: klopt de rode rij? (het commando bestaat al, kost niets)**
- Wat: Rob (of Cisca) zet `/mh partytargets` aan en doet een dungeon in een groep. Komt er een
  dispelbare **boss**-debuff (private aura) op een groepslid, vergelijk dan op hetzelfde moment de
  MH-rij met Blizzards eigen raid frame. Maak een screenshot.
- Waarom: AuraContainers tonen private auras volgens de wiki gewoon (GEMETEN, docs). Of óns paneel
  dat in gevecht ook echt doet op een groepslid, is niet vastgelegd. Loggen kan niet, want MH mag niet
  zien of de rij aan staat. Dit is dus een meting met de ogen.
- Commando's: `/mh partytargets`, daarna `/mh glow` als het niet oplicht.

**Meting B: welk filter betekent echt "jij kunt het weghalen"? (moet gebouwd worden)**
- Wat: na elk gevecht vergelijkt MH al je eigen debuffs met `HARMFUL|RAID` (`AfterCombatDispelCheck`,
  `PartyTargets.lua:1972`). Breid dat uit naar drie filters naast elkaar: `HARMFUL|RAID`,
  `HARMFUL|RAID_PLAYER_DISPELLABLE` en `HARMFUL|DISPELLABLE`. Schrijf per debuff op: dispel-type en of
  jouw spec het kan. Wegschrijven naar `ns.db.dispelSelfLog`, mét datum (dat gebeurt al).
- Waarom: 4 van de 7 regels van 27-30 sep zijn een vals alarm (GEMETEN). Zonder deze meting weten we
  niet of een ander filter beter is.
- Kan alleen of met de groep, buiten gevecht. Je eigen debuffs zijn dan leesbaar (GEMETEN).
- ⚠️ AFGELEID: in een M+-key zijn aura's de hele run geheim, ook tussen de pulls. Daar werkt het niet.

**Optioneel, meting C: geluid via Blizzard, alleen voor jezelf (moet gebouwd worden)**
- `C_UnitAuras.AddAuraSound` neemt een unit en een spell-ID. Blizzard speelt het geluid af; de addon
  leest niets (GEMETEN, wiki). DBM doet dit al voor `"player"` (KANDIDAAT).
- MH heeft al ~59 echte dispelbare debuffs met school vastgelegd (`dispelCapture`). Daarmee kun je
  "iets wat jij kunt weghalen staat op jou" laten **piepen**, ook in gevecht.
- Te meten: speelt hij af voor een bekende, niet-private debuff op `player` in gevecht? En werkt
  `"party1"` ook? (Onbekend. Iedereen die ik zag gebruikt alleen `"player"`.)
- Grenzen: alleen spell-ID's die we kennen; per keer maximaal 5 seconden geluid vanaf 12.1.5 (GEMETEN).

**Niet meten (AFGELEID):** de unit-route `GetUnitAuraBySpellID` naar Cisca. Volgens de docs vindt die
alleen vrijgegeven aura's, en daar zitten geen boss-debuffs bij. Een groepsavond kost veel en levert
hooguit "nee" op.

### De veilige, kleinere variant

**Uitleggen + Blizzards eigen knoppen. Dat past bij waar MH sterk in is.**
- Vanaf 14 okt heeft Blizzards raid frame een stippelrand om een speler waar jij iets af kunt dispellen,
  plus een pulserende kleurlaag (GEMETEN, PTR-notities).
- MH kan uitleggen waar die opties staan. Eventueel geeft MH een schakelaar die de twee CVars zet,
  en de speler kiest zelf. ⚠️ Na 14 okt eerst in de client nagaan of de CVars echt zo heten en werken.
- **Alleen buiten gevecht** is als dispel-helper bijna waardeloos: dispels doen ertoe ín het gevecht
  (AFGELEID).

### Opruimen (AFGELEID, aan de bouwchat)

- `DispelCapture.ProbeKnownIDs` vraagt in gevecht nog elke seconde naar 89 ID's (44.839 rondes). Zijn
  vraag is beantwoord. Overweeg hem uit te zetten.
- `Auras.lua:133-143` en de eerste tak van `GetPlayerAura` (r. 87-95) gaan over een functie die niet
  bestaat (zie §2).
- Geheugen `aura-facade-12-1` en `mh-market-position`: pas de tegenspraak-zin aan en verwijs naar de
  Blizzard-lijst als verklaring.

---

## 7. Wat ik níét kon meten

- De drie wachterbestanden in `docs/` (zie 1f). Niet gelezen.
- Of de rode rij in gevecht op een groepslid een private boss-debuff toont. Dat kan alleen Rob zien.
- Wanneer de laatste gevechtsmeting in `dispelLookupLog`/`dispelFieldLog` was. Die logs hebben geen datum.
- Of de Exa-kopieën vers waren. Aanwijzingen dat ze vers zijn: de hotfixpagina heet "October 6", de
  Grid2-releases lopen tot 5 okt, en de laatste PIHelper-reactie is van 3 okt. Bij Cell (nieuwste 9 aug)
  twijfel ik.
- Reddit en Discord heb ik niet gelezen.
- Van PIHelper heb ik alleen de beschrijving, changelogs en reacties gelezen, geen code.

---

## Bronnen (gelezen op 7 okt 2026)

- Warcraft Wiki: `Patch_12.1.5/API_changes` (ruwe tekst + geschiedenis, laatst bewerkt 6 okt),
  `Patch_12.1.0/API_changes`, `API:C_UnitAuras.GetUnitAuraBySpellID`,
  `API:C_UnitAuras.GetPlayerAuraBySpellID`, `API:C_UnitAuras.GetAuraDataBySpellName`,
  `API_types/AuraFilters`, `API:AuraContainer_AddAuraGroup`, `API:C_UnitAuras.AddAuraSound`,
  `Secret_values` (bewerkt 23 sep).
- Blizzard-hotfixes, artikel 24296142 (versie 6 okt), via Exa.
- Blizzard Watch, "patch 12.1.5 will release on October 13" (29 sep).
- Forumdraad us.forums.blizzard.com/…/2258098 (25 feb 2026), met de lijst van niet-geheime spells.
- CurseForge-API: mod 1669833 (bestanden, changelogs, reacties) + projectpagina, via Exa `nocache=20261007`.
- WowAce Grid2 4.0.12; GitHub michaelnpsp/Grid2 releases; GitHub enderneko/Cell releases.
- Lokaal: `DandersFrames_Options/Changelog.lua` (v5.3.3), `HexBreak/CHANGELOG.txt` (0.6.23),
  `DBM-Core/modules/objects/BossMod.lua`.
- Robs bestanden: live SV (6 okt 21:48) + `.bak` (21:40); `_xptr_` SV (3 okt 11:06).
