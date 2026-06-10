# Dungeon Coach — designplan

Status: design, 10 juni 2026 (avond, na de 1.6.0-release). Doel: dungeons
toegankelijk maken voor beginners én nuttig voor ervaren spelers — eerst
Normal + Heroic, Mythic/M+ in een latere fase. Zelfde discipline als altijd:
"never lie", waypoints, 6 talen, gefaseerd, **eerst dit plan reviewen (Rob),
dan bouwen.**

## Probleem / kans

Dungeons zijn voor beginners de engste content in het spel: je speelt met
vier vreemden, niemand legt uit hoe je in de wachtrij komt, wat je rol
inhoudt, wat de etiquette is, of wat een boss gaat doen. Het spel zelf zegt
er vrijwel niets over. Ervaren spelers missen juist een snelle
per-boss-referentie + de weekly-koppeling (dungeon van de week, Spark-weekly,
vault-rij). MH heeft voor delves en rituals bewezen dat een Coach dit gat
vult — dungeons zijn de logische derde.

## Doelgroepen

- **Beginner:** wil per stap weten wat te doen — van "hoe kom ik er überhaupt
  in" tot "wat doe ik bij deze boss". Kernfeature: **Follower Dungeons**
  (solo met NPC's oefenen, geen druk) als instappad.
- **Ervaren:** wil per boss een 3-regel-spiekbrief, de weekly-status in één
  oogopslag en een share-knop voor de groep ("hebben jullie deze boss al
  gedaan? hier de tactiek — in jouw taal").

## Researchfeiten (10 jun: web + Robs lokale addons)

### Rosters

**Launch-dungeons (Normal + Follower, altijd beschikbaar):** Windrunner
Spire · Murder Row · Den of Nalorakk · Magisters' Terrace · Nexus-Point
Xenas · The Blinding Vale · Voidscar Arena · Maisara Caverns.
(Bron: DungeonHelper-instance-map; lijst in-game bevestigen.)

**Season 1 (Heroic / M0 / M+, seizoensrotatie)** — EJ journalInstanceID +
bossen (bron: BossHelper-data, kruist met Methods M+-gidslijst):

| Dungeon | EJ-ID | Bossen (encounterID) |
|---|---|---|
| Maisara Caverns | 1315 | Muro'jin & Nekraxx 2810 · Vordaza 2811 · Rak'tul, Vessel of Souls 2812 |
| Magisters' Terrace | 249 | Arcanotron Custos 2659 · Seranel Sunlash 2661 · Gemellus 2660 · Degentrius 2662 |
| Nexus-Point Xenas | 1316 | Chief Corewright Kasreth 2813 · Corewarden Nysarra 2814 · Lothraxion 2815 |
| Windrunner Spire | 1299 | Derelict Duo 2656 · Emberdawn 2655 · Commander Kroluk 2657 · The Restless Heart 2658 |
| Skyreach | 476 | Ranjit 965 · Araknath 966 · Rukhran 967 · High Sage Viryx 968 |
| Pit of Saron | 278 | Forgemaster Garfrost 608 · Krick and Ick 609 · Scourgelord Tyrannus 610 |
| Seat of the Triumvirate | 945 | Zuraal 1979 · Saprish 1980 · Viceroy Nezhar 1981 · L'ura 1982 |
| Algeth'ar Academy | 1201 | Vexamus 2509 · Overgrown Ancient 2512 · Crawth 2495 · Echo of Doragosa 2514 |

### Systeem

- **Follower Dungeons:** Normal-difficulty solo of met vrienden + NPC's;
  level 80-90; beloningen ilvl 214 (niet upgradebaar); cap ~10 starts per
  dag per account (launch-cap — actuele stand verifiëren). HET beginner-pad.
- **Normal:** alle launch-dungeons, altijd; geen lockout-zorgen voor
  beginners. **Heroic/M0/M+:** seizoensrotatie (de 8 hierboven).
- Heroic-ilvl-eis voor de queue: **te verifiëren** (gidsen noemen 'm niet
  eenduidig).
- **Bestaande weekly-koppeling in MH (1.6.0!):** Liadrins Spark-keuze bevat
  "Midnight: Dungeons" (93911, elke seasonal dungeon); **Halduron** geeft de
  rep-dungeon-van-de-week (93761 = Windrunner Spire-week; per week ander ID,
  we verzamelen ze toch al); Cracked Keystone 92600 (eens per season, M+).
  De vault-Dungeons-rij staat al in snapshot + per-slot-detail.

## Inventaris — wat MH al heeft (veel!)

- **DelveCoach-patroon** = de blauwdruk: TipsData + Locales-bodies + paneel +
  share v2 met cross-locale-ontvangst. Ritual Coach bewees dat het patroon
  herbruikbaar is.
- **Role Academy** (rol-basics per rol), **GuideAdvisor** (rotatie per spec),
  **Toolbox-macro's** (interrupt Focus/Mouseover!), **Consumables** —
  alles waar een beginner vóór z'n eerste dungeon naartoe moet; alleen nog
  aan elkaar rijgen met nav-knoppen.
- **Reset-routine + Account Weekly**: 93911/93761 al getrackt.
- **Travel assistant + TomTom-infra** voor entree-waypoints.
- **Delve Log** → zelfde patroon kan later een **Dungeon Log** worden
  (synergie met het geplande Delve & Ritual Log — zelfde detectie-laag:
  instance enter/leave + ENCOUNTER_END).
- **Codex** voor het systeem-artikel ("hoe werken dungeons/difficulties").

## Voorbeeld-addons (Robs map — inventaris 10 jun)

- **BossHelper** (MIT!): per-locale per-dungeon-bestanden, encounterID-keyed,
  per boss `short` = genummerde stappen 1-2-3 + rol-regels ("Tank. …",
  "Healer. …") + `details` + optioneel `phaseText`. Dekt exact de S1-8.
  **MIT = tekst mag hergebruikt/bewerkt met attributie** — beslispunt
  hieronder.
- **DungeonHelper** (geen licentie zichtbaar): EJ-gedreven UI (tier →
  instance → encounter), naam-keyed tactics met `overview` + `roles`-regels,
  chat-broadcast van de tactiek. Goede structuur-inspiratie (vooral het
  rol-onderscheid en de locale-onafhankelijke EJ-fallback); **geen tekst
  kopiëren**.
- **HandyNotes_MapNotes**: heeft dungeon-portaal-nodes — kandidaat-bron voor
  entree-coords (zelfde werkwijze als de ritual-obelisken: Rob checkt de
  overlay in-game).

## Datamodel (gespiegeld op DelveTips/RitualCoach)

**A. `DUNGEON_ROSTER`** (data-only module):
```
{ key = "maisara", journalInstanceID = 1315, native = true, season1 = true,
  entrance = nil, -- { mapID, x, y } pas na verificatie (never lie)
  bosses = { { id = "murojin", encounterID = 2810, nameKey = ... }, ... } }
```
EJ-API (`EJ_GetInstanceInfo`/`EJ_GetEncounterInfo`) levert runtime de
gelokaliseerde namen bij de IDs → geen naam-vertaling nodig, geen
naam-matching-fragiliteit (les uit DungeonHelpers fallback-gepuzzel).

**B. `DUNGEON_TIP_ENTRIES`** — per boss secties:
```
{ id = "murojin", encounterID = 2810, sections = {
    { type = "STEPS",  bodyKey = "DGN_TIP_MAISARA_MUROJIN_STEPS" },  -- 1-2-3, beginner-taal
    { type = "TANK",   bodyKey = ... }, { type = "HEALER", ... }, { type = "DPS", ... }, -- optioneel
    { type = "HEROIC", bodyKey = ... }, -- alleen indien heroic écht anders is
  } }
```
Locale-structuur `DGN_TIP_<DUNGEON>_<BOSS>_<SECTIE>` → share v2-ontvangst
werkt gratis. Pilot enUS+nlNL, daarna ×4 (bewezen flow).

**C. "Dungeons 101"-hoofdstukken** (Professions 101-patroon, per character
afvinkbaar, auto-detectie waar een echt signaal bestaat):

1. **Wat zijn dungeons?** — difficulties uitgelegd: Follower → Normal →
   Heroic → (Mythic/M+ later). Auto-tick: eerste dungeon-completion.
2. **Zo kom je binnen** — Group Finder (I-toets), rol aanvinken, en dé
   beginner-tip: **start een Follower Dungeon en oefen solo, zonder druk**
   (cap ~10/dag). Auto-tick: follower/normal completion.
3. **Maak je klaar** — rol kiezen (→ Role Academy), interrupt- +
   defensive-macro (→ Toolbox), flask/food/potion (→ Consumables),
   ilvl-check voor heroic. Nav-knoppen naar bestaande tabs.
4. **In de groep** — etiquette in beginner-taal: volg de tank, pull niet
   zelf, zeg "first time here" (mensen helpen graag), loot-basics, na een
   wipe: eten en terug. Handmatig vinkje.
5. **De bossen** — verwijst naar de Coach: lees vóór de run de 1-2-3-stappen
   van de bossen (of laat een groepslid ze sharen).
6. **Daarna: Heroic** — eisen, rotatie van het seizoen, verschil met normal,
   en de weekly-haakjes (Halduron + Spark).

## UI-voorstel

Eigen top-tab **"Dungeons"** in de THIS WEEK-sectie (onder Delves & Vault),
met het bewezen twee-views-patroon van Void & Rituals:

- **"Deze week"**: dungeon-van-de-week (zodra Halduron-mapping bekend),
  Spark-weekly-status (93911), Cracked Keystone-status (92600, M+-voorbereiding),
  vault-Dungeons-rij van deze char, Follower-hint voor beginners,
  entree-routeknoppen (zodra coords geverifieerd), nav naar 101/Coach.
- **"Dungeon Coach"**: rosterlijst (launch + S1-markering) → per dungeon de
  bossen met STEPS + rol-regels; **rol-filterknoppen (Tank/Healer/DPS,
  default = jouw spec-rol)**; share-knop per dungeon ("post de stappen van
  deze 3-4 bossen"). Beginner ziet stappen, ervaren speler een spiekbrief.

Tab-count gaat 12 → 13; alternatief is inbouwen onder Delves & Vault als
sub-view, maar dungeons ≠ delves en de tab verdient eigen vindbaarheid.
**Keuze aan Rob.**

## Share-infra: nu generaliseren

Met delve + ritual + dungeon zou een derde parallelle kopie ontstaan.
Voorstel: **nu de geplande generalisatie doen** (`MHShareSync`, payload
`"2|<locale>|<type>|<mode>|<entryId>"`, dispatch per type) — het
risico-argument van vóór de release is vervallen, 1.6.0 is uit. Delve- en
Ritual-share migreren mee (proto-bump; oude ontvangers zien gewoon de platte
tekst, zoals altijd). **Keuze aan Rob.**

## Content-bronnen & licentie (beslispunt)

BossHelper is MIT: de korte boss-stappen mogen hergebruikt/bewerkt worden
mét attributie (credit in TOC/description + comment in de data). Voorstel:
**eigen tekst schrijven in MH-stijl** (beginner-taal, never-lie), met
BossHelper + DungeonHelper als kruis-referentie en Wowhead/Icy Veins/Method
als bronnen — en Robs runs als verificatie. Dan is attributie netjes
("structuur geïnspireerd op, gecheckt tegen") zonder copy-paste-twijfel.

## Never-lie-signalen (wat kunnen we écht weten)

- Boss-kill in run: `ENCOUNTER_END` (encounterID matcht onze data) — basis
  voor latere Dungeon Log + "deze boss al gedaan deze run".
- Dungeon-completion: `LFG_COMPLETION_REWARD` / scenario-end — verify.
- Heroic lockout per dungeon: `GetSavedInstanceInfo` — verify of heroic
  5-mans in Midnight een lockout hebben.
- Dungeon-van-de-week: Halduron-quest-ID → dungeon-mapping (groeit per week,
  zelfde aanpak als GIVER_WEEKLIES; questnaam = dungeon-naam → evt. zelfs
  automatisch te matchen op EJ-naam — verify).
- Spec-rol voor het rol-filter: `GetSpecializationRole` — bestaat, betrouwbaar.
- Eerste-keer-detectie per dungeon: achievement/statistics-API — nice-to-have,
  verify; anders handmatig vinkje (never lie).

## Open in-game verificaties (Rob)

1. Launch-roster bevestigen: staan alle 8 in de Group Finder onder Normal +
   Follower? (En: bestaat Follower voor álle 8?)
2. Heroic-queue-ilvl-eis (Group Finder-tooltip toont 'm).
3. Follower-cap: nog steeds 10/dag?
4. Entree-coords per dungeon (HandyNotes_MapNotes-overlay checken zoals bij
   de obelisken; Magisters' Terrace = Quel'Danas — zone-toegang?).
5. Heroic lockout-gedrag (GetSavedInstanceInfo na een heroic-run dumpen).
6. Halduron-questnaam vs EJ-dungeonnaam (matcht 1-op-1? → automatische
   dungeon-van-de-week zonder hardcoded mapping).
7. EJ-IDs spot-checken: `/dump EJ_GetInstanceInfo(1315)` enz.
8. ENCOUNTER_END-payload in een follower-run (encounterID + success-flag).

## Fasering (voorstel)

1. **Data-skelet + Dungeons 101** — DUNGEON_ROSTER, 101-hoofdstukken
   (EN/NL), Codex-artikel; nav-knopjes naar Role Academy/Toolbox/Consumables.
   Geen tips-content nog. → Rob test de 101-flow op een verse alt.
2. **Dungeons-tab + Coach-UI** — twee views, rol-filter, EJ-namen runtime;
   tips tonen "coming soon" per boss tot fase 3 (eerlijk).
3. **Boss-tips Normal** — research-batch per dungeon (launch-8 eerst),
   STEPS + rol-regels EN/NL; Rob verifieert per dungeon in follower-runs
   (ideaal testpad!).
4. **Heroic-laag + weekly-koppeling** — HEROIC-secties waar relevant,
   dungeon-van-de-week, Spark/Keystone-status, entree-waypoints.
5. **Share-generalisatie** + dungeon-share-knoppen.
6. **Lokalisatie ×4** (bewezen flow van 10 juni).
7. **Later: Mythic/M+** — keystones, Font of Power, affixes, vault 1/4/8,
   M+-specifieke boss-verschillen. Eigen fase, eigen review.

## Besluiten Rob (10 juni, via vraag) ✅

1. **Eigen "Dungeons"-tab** (THIS WEEK-sectie, onder Delves & Vault).
2. **Share-infra generaliseren** (MHShareSync proto 2) in de share-fase.
3. **Content zelf schrijven**, BossHelper (MIT) + DungeonHelper + gidsen als
   kruisreferentie, attributie netjes vermelden; Rob verifieert in
   follower-runs.
4. Rol-filter default = spec-rol.
5. **Fase 1+2 samen bouwen, dan review.** → Bouw gestart 10 juni avond.

## Bronnen

- Robs lokale addons: BossHelper (MIT, S1-data), DungeonHelper (structuur),
  HandyNotes_MapNotes (entrees — te checken).
- Icy Veins Follower Dungeons-guide + Midnight dungeons-guide; Overgear
  "Midnight All Dungeons"; Method M+-gidsenlijst (jun 2026).
- MH-eigen: DelveCoach/RitualCoach-patroon, share v2, GIVER_WEEKLIES-aanpak.
