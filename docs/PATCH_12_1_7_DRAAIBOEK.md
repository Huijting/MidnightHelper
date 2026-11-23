# Draaiboek patch 12.1.7 "Echoes of the Worldcore"

Rob, 15 nov 2026 (bouwchat): *"Als op 2 dec de patch komt moetwn we wel van te voren weten wat er komt en wat we moeten
checken en evt testen"* → *"Klopt en stuur een aantal speur agenten het net op om alle info over de patch vast op te
speuren"*.

Bronnen (15 nov, PTR 12.1.7.70892 tegen live 12.1.5.70783), elk met GEMETEN/AFGELEID per bewering:
`docs/PATCH_12_1_7_PTR_2026-11-15.md` (eerste onderzoek) en `docs/patch_12_1_7/` 1_blizzard, 2_gamedata, 3_api,
4_classes, 5_community. Dit draaiboek vat ze samen; de details en URL's staan daar.

---

## 1. Wat er komt (kort)

- **Datum:** Blizzard noemde er geen. De testdata zetten Turbulent Timeways op **di 1 dec (VS) / wo 2 dec 05:00 (EU)**,
  en Blizzard zegt dat Timeways begint bij de patch. Dus waarschijnlijk 1/2 dec (AFGELEID).
- **Geen Season 3.** Mythic+, dungeons, raid, delves, crests en Great Vault blijven Season 2 (GEMETEN: 0 rijen anders in
  de M+- en dungeon-tabellen). Season 3 komt kort na 12.2.
- **Geen enkele klassen-spell verandert** (GEMETEN, alle spell-tabellen). Alle 1053 spell-id's van MH bestaan nog.
- **Turbulent Timeways VI**, 8 weken (tot ~27 jan): BfA, Shadowlands, Dragonflight, Classic, TBC, Wrath, Cata, MoP (één
  per week, GEMETEN in de testdata). Mount-prestatie 64207 vraagt **4 weken**.
- **Events in december** (testdata): Delves Bonus Event wo 16 dec, Midnight Dungeon Event wo 23 dec, Winter Veil vanaf
  15 dec. (Pilgrim's Bounty en het jubileum lopen al.)
- **Aqir Invasions verdwijnen.** Beloningen blijven, zonder reputatie-eis maar duurder (mount 2.500 → 3.500 Marl; dat
  getal is tweedehands).
- **Talebound** (aparte spelsoort, eigen personages): geeft Season 2-dingen voor je gewone characters via de Traveling
  Raven in Silvermoon: Venomstone Caches, Nebulous Voidcaches, Mistcrest-zakjes, gear-kisten.
- **Nieuwe campagne** "The Coreway Advance" (14 quests), **4 Lorewalking-verhalen** (tijdens Lorewalking kun je geen
  andere quests doen), **Omnium Folio 7 stappen** (2 nieuwe runen).
- **Spawn of Vyranoth-mount** te koop: 5000 Timewarped Badges bij elke Timewalking-verkoper (GEMETEN in de testdata).
- **Techniek:** Edit Mode krijgt nieuwe onderdelen (systeem 26 = de griffioenen, Loss of Control wordt 28) en een derde
  standaardindeling "Gamepad"; een optie "Simple Keybinds" (zet Ctrl+1 enz. uit) die waarschijnlijk alleen in Talebound
  aan kan; een paar balk-wijzigingen. Andere addon-makers moesten bijna niets aanpassen.

## 2. Wat MH moet doen

### 2a. Al klaar (gaat vanzelf aan op 12.1.7)
- ✅ Edit Mode-back-ups onthouden hun spelversie en weigeren terugzetten op een andere versie (8948997).
- ✅ Aqir-artikel in de Codex verdwijnt vanzelf (8948997).
- ✅ Timeways-tekst zegt 4 weken, in 9 talen (feabb43). Het Timeways-artikel en de mount staan al klaar achter 12.1.7.
- ✅ MH laadt niet in Talebound (`AllowLoadGameType: standard`, AFGELEID).

### 2b-stand (15 nov avond; Rob: *"Ja, je mag de klaarzetpunten mee beginnen en wij gaan dat zeker benoemen als
midnight helper zijnde"* = Talebound als bron noemen)
- ✅ 1 toetsenblok-"terug" zoekt de oude indeling nu OP NAAM (`EditModeBackup.lua` BackToPreset); niet gevonden = niets
  doen, MH valt terug op de opgeslagen kopie van je eigen indeling.
- ✅ 2 Timeways-weekschema in CODEX_TT6_BODY (9 talen; "Classic" per taal zoals de client het noemt).
- ✅ 3 Vyranoth, ✅ 6 Talebound als bron (Venomstone/Voidcache), ✅ 4 (alleen de TEKST: 7 stappen, 2 runen) — als
  `<KEY>_1217`: `Locales/Locale.lua` ns:L kiest die op interface ≥ 120107 (GEMETEN met de packs geladen als 12.1.5 en
  12.1.7, en/de/esMX/fr). Namen GEMETEN in PTR-DB2; Engels gebleven (niet te meten): Memories and Tales, Traveling Raven,
  Veldharin, frFR Venomstone Cache/Nebulous Voidcache.
- ✅ 10 Lorewalking-zin stond er al (artikel verborgen tot 12.1.7).
- ⏳ Patchdag: 4-data (Folio-rijen 6/7: welke rij, welke volgorde, één stap via Talebound → MH kan niet meer gewoon tellen),
  5 campagne (startplek/volgorde onbekend, geen Zygor-gids), 7 Aqir-prijs, 8 Talebound-prestatielijst, 9 december-events.
- ✅ Lint [18] telt een `<KEY>_1217` als gebruikt als `<KEY>` in de code staat (16 nov; GEMETEN: 1440 → 1436
  "ongebruikt", de 4 `_1217`-keys weg, 0 HARD).

### 2b. Vóór 2 dec klaarzetten (zelfde truc: pas zichtbaar op een 12.1.7-client)
| # | Wat | Waar in MH | Zeker? |
|---|---|---|---|
| 1 | 🔴 Toetsenblok "terug naar je oude indeling" bewaart een vast indelingnummer. Met de nieuwe "Gamepad"-indeling kan dat na de patch een andere indeling kiezen. Repareren: op naam bewaren of eerst controleren. | `EditModeBackup.lua:947` en `:1022` | GEMETEN in de code; dat het misgaat is AFGELEID |
| 2 | Timeways-artikel: de dungeon-volgorde per week erin | `CODEX_TT6_BODY` (9 talen) | volgorde GEMETEN in de testdata |
| 3 | Vyranoth-mount: "te koop voor 5000 Timewarped Badges" i.p.v. "nog niet bevestigd" | `MOUNTPROG_VYRANOTH_HOWTO` | GEMETEN in de testdata |
| 4 | Omnium Folio: 7 stappen, de 2 nieuwe runen en quests | `OmniumFolioData.lua`, `CODEX_FOLIO_BODY` | GEMETEN; volgorde van stap 6/7 NIET zeker |
| 5 | Campagne "The Coreway Advance" (QuestLine 6210) | `CampaignLeadIn.lua` | GEMETEN |
| 6 | Talebound als bron van Venomstone, Voidcache, Mistcrests (keuze voor Rob: noemen of niet) | `TRACKCEIL_ROUTE_VENOM`, Codex | GEMETEN (bron: datamining) |
| 7 | Aqir-mount: nieuwe prijs, geen reputatie-eis | `MountProgress.lua` aqir, `MOUNTPROG_AQIRSWARMER_HOWTO` | prijs tweedehands → op patchdag nameten |
| 8 | Prestatielijst: Talebound-categorieën | `MidnightAchList.lua` GROUPS | GEMETEN |
| 9 | Weekplanning: Delves Bonus Event (16 dec) en Midnight Dungeon Event (23 dec) | weekplanning/events | GEMETEN in de testdata |
| 10 | Lorewalking-zin "geen andere quests tijdens het verhaal" | `CODEX_LOREWALK_BODY` | GEMETEN (Blizzard) |

### 2c. Pas op patchdag (kan niet eerder)
- Releasenotes van Blizzard lezen (of er toch klassen-wijzigingen zijn) en de meting herhalen.
- Aqir-mountprijs nameten in het spel.
- TOC-nummers controleren (`/dump select(4, GetBuildInfo())` → 120107; staat al in de toc).

## 3. Wat Rob vóór 2 dec op de testserver (PTR) kan testen

Optioneel; elk punt kost een paar minuten. Character kopiëren naar de PTR geeft een bekende Lua-fout van Blizzard (niet
van MH).
✅ **Getest 23 nov op `_ptr_` = 12.1.7.71087, MH 5.8.0** (via Sparring 23-11, Rob letterlijk: *"Alle 5 tests gaat
goed. Ik heb geen tailbound character, dus daar kan ik niet zoveel mee."*). `_xptr_` = 12.1.5.70340 (ouder dan retail),
niet gebruikt.
- [x] MH laadt zonder rode fout (BugSack aan).
- [x] Toetsenblok neerzetten en weer weghalen ("Your key block" → terug): komt je oude indeling terug? (punt 2b-1)
- [x] `/mh apply` → dry run → go → undo → relog: staan je toetsen weer zoals eerst? (Blizzard ontkoppelt toetsen nu
      anders, AFGELEID risico laag-midden.)
- [x] Options → Keybindings: staat er "Simple Keybinds"? Zo ja: zet hem NIET aan en meld het. (Gemeld als "goed";
      of de optie er stond, zei Rob niet.)
- [x] Liggen de balken van het toetsenblok nog op hun plek (Blizzard herschreef de onderste balken)?
- [ ] Een Talebound-personage: typ `/mh` → MH hoort daar NIET te laden. **Open: niet getest, Rob heeft geen
      Talebound-character** (23 nov).

## 4. Patchdag-afvinklijst (wo 2 dec, voor Rob)

- [ ] Inloggen, `/reload`: geen rode fout van MH.
- [ ] Codex: Aqir-artikel is weg; Timeways-artikel is er (met 4 weken en de dungeons).
- [ ] Mounts-pagina: Markeet of the Infinite (Timeways) en Spawn of Vyranoth kloppen.
- [ ] Oude Edit Mode-back-up terugzetten: oranje regel "made on another game version", er verandert niets.
- [ ] Toetsenblok: neerzetten en terug werkt op de nieuwe versie.
- [ ] Omnium Folio: 7 rijen?
- [ ] Weekplanning noemt Timeways.

## 5. Elke week opnieuw meten tot 2 dec

Blizzard kan nog veranderen (datum, dungeons, klassen). De scripts staan sinds 15 nov in `tools/patch_watch/` (zie de
README daar):
- klassen/spells: `t4_diff.py <live> <ptr>` (controle eerst: `12.1.5.70575 12.1.5.70688`);
- speldata: `p2_gd_diff.py`; events: `decode_holidays.py`, `diff_holidays.py`; API: `uisrc_tree_diff.py`.
Voorstel: elke woensdag (Midnight-dag) één ronde. Eerste: wo 18 nov.
