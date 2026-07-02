# Next session — Midnight Helper

## ⏭️ MORGEN / VOLGENDE SESSIE — direct oppakken (sessie 4 → 5)
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

---

**Laatste update:** 2026-07-02 (sessie 4 — auto-map, spell-strook Fase 1, heal-ankers)
**Live op CF:** **2.2.0** (standalone route-pijl + reset-route + clear + self-healing giver-learn).
**In de repo bovenop 2.2.0 (nog NIET gereleased → wordt 2.3.0):** leveling-tab vervangen + keybind v6 + Frost-layout.
**Vorige live versies:** 2.1.1, 2.1.0

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
