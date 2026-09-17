# Audit klasse-advies — Shaman (262/263/264) en Evoker (1467/1468/1473)

Datum 2026-09-17, patch 12.1 (Midnight S2). Alleen gelezen, niets gewijzigd.

**Label per regel:**
- **BRON** = bevestigd door een genoemde, actuele bron (12.0/12.1).
- **AFGELEID** = alleen mijn eigen redenering.

Niets hiervan is in de client gemeten.

**Gelezen code:**
- `Modules/SurvivalPlan.lua`
- `Modules/KeybindRoles_Shaman.lua`
- `Modules/KeybindRoles_Evoker.lua`
- `Modules/DpsToolkit.lua`
- `Modules/HealerCooldowns.lua`
- `Modules/RoleAcademy.lua` (de renderer)

**Hoe de schermen worden opgebouwd (gemeten in de code):**
- **Overlevingskaart.** Gebouwd uit de classifier. De stappen staan in deze volgorde (`SurvivalPlan.lua:75-84`): keepup → hurts → heal → escape → interrupt. Binnen een stap wordt gesorteerd op `priority`, daarna alfabetisch (`:351-357`). Er wordt gefilterd met `IsPlayerSpell` op de naam (`:130-199`).
- **DPS-cooldownlijst.** Gefilterd op `IsPlayerSpell`, maar **alleen voor je eigen actieve spec**. Bij een preview (bv. een Resto Shaman die de DPS-track opent) komt alles in beeld (`RoleAcademy.lua:636-639`).
- **Healer-toolkit.** Kern-heals, cooldowns en defensives worden **helemaal niet** gefilterd (`RoleAcademy.lua:468-505`).
  - Een Deva/Aug Evoker ziet daar een preview van Preservation.
  - Een Ele/Enh Shaman ziet daar een preview van Resto (`:457`).
- **`DPS_DEFENSIVES`.** Wordt sinds 5 aug niet meer getoond (`RoleAcademy.lua:667-679`). Staat wel als "verified data" klaar voor hergebruik.

**Bronnen (hieronder afgekort):**
- **IV-Ele** = https://www.icy-veins.com/wow/elemental-shaman-pve-dps-spell-summary (12.1, 10 aug 2026)
- **IV-Enh** = https://www.icy-veins.com/wow/enhancement-shaman-pve-dps-spell-summary (12.1)
- **IV-Resto** = https://www.icy-veins.com/wow/restoration-shaman-pve-healing-spell-summary (12.1)
- **IV-Dev** = https://www.icy-veins.com/wow/devastation-evoker-pve-dps-spell-summary (12.1)
- **IV-Aug** = https://www.icy-veins.com/wow/augmentation-evoker-pve-dps-spell-summary (12.1)
- **IV-Pres** = https://www.icy-veins.com/wow/preservation-evoker-pve-healing-spell-summary (12.1)
- **WH-pp-<spec>** = de Wowhead-gidsen "Starting Midnight Pre-Patch as …" (bijgewerkt 12 aug 2026):
  - https://www.wowhead.com/guide/classes/shaman/elemental/midnight-pre-patch
  - …/shaman/enhancement/midnight-pre-patch
  - …/shaman/restoration/midnight-pre-patch
  - …/evoker/devastation/midnight-pre-patch
  - …/evoker/augmentation/midnight-pre-patch
  - …/evoker/preservation/midnight-pre-patch
- **WH-Enh-rot** = https://www.wowhead.com/guide/classes/shaman/enhancement/rotation-cooldowns-pve-dps (22 aug 2026)
- **WH-Ele-rot** = https://www.wowhead.com/guide/classes/shaman/elemental/rotation-cooldowns-pve-dps (31 aug 2026)
- **Wiki-RB** = https://warcraft.wiki.gg/wiki/Renewing_Blaze (*"Patch 12.0.0: Redesigned as a passive talent"*)
- **Wiki-EC** = https://warcraft.wiki.gg/wiki/Emerald_Communion (nu een *PvP talent*)
- **Wiki-MT** = https://warcraft.wiki.gg/wiki/Mana_Tide (*"Patch 12.0.0: Removed"*; al in 11.1 in de plaats gekomen van Mana Tide Totem)
- **Wiki-DF** = https://warcraft.wiki.gg/wiki/Dream_Flight (keuzeknoop met Stasis, 2 min)
- **WH-spell** = losse Wowhead-spellpagina's (live, 12.1):
  - Earth Elemental 198103: 3 min / 30 s
  - Doom Winds 384352: 1 min
  - Stormkeeper 191634: 1 min
  - Ascendance 114050: Elemental, 3 min
  - Ascendance 114051: **Enhancement**, 3 min, geeft Windstrike + Doom Winds
  - Ascendance 114052: Restoration, 3 min
  - Astral Shift 108271: 2 min, 40%, 12 s
  - Zephyr 374227: 2 min, 20% AoE-reductie, 8 s
  - Stasis 370537: 1,5 min
  - Breath of Eons 403631: 2 min
  - Upheaval 396286: 40 s
  - Eternity Surge 359073: 30 s
  - Dragonrage 375087: 2 min
  - Healing Tide Totem 108280: 3 min

---

## Shaman — Elemental (262)

**Kaart zoals de code hem bouwt:**
1. Astral Shift — "when your health drops fast"
2. Earth Elemental — "when your health drops fast"
3. Healing Surge — "to heal yourself"
4. Wind Shear — "when it is casting something"

Er is geen keepup-stap en geen escape-stap.

| spell | id | wat de addon zegt | oordeel | wat het moet zijn | bron |
|---|---|---|---|---|---|
| Astral Shift | 108271 (naam) | hurts, prio 1; `DPS_DEFENSIVES` cd 120 | OK (BRON) | 40% voor 12 s. Grote noodknop, dus "when health drops fast" klopt. Cd 2 min (Planes Traveler −30 s). IV-Ele zegt 1,5 min, IV-Enh en WH-spell zeggen 2 min. | WH-spell, IV-Enh, IV-Ele |
| Earth Elemental | 198103 (naam) | hurts, prio 4, **alleen `specs={262}`** (`KeybindRoles_Shaman.lua:59`) | FOUT (BRON) wat betreft de spec-koppeling | Talent in de class-boom, voor alle drie de specs. In 12.x 30 s / 3 min. Is een noodtank; met Primordial Bond geeft hij +15% max HP. "Drops fast" is verdedigbaar. | IV-Ele, IV-Enh, IV-Resto, WH-spell |
| Healing Surge | 8004 (naam) | heal_quick | OK (BRON) | Baseline voor Ele. Werkt op jezelf ("do not hesitate to use it on yourself"). | IV-Ele |
| Wind Shear | 57994 (naam) | interrupt | OK (BRON) | 12 s cd, 30 m bereik | IV-Ele |
| DPS: Stormkeeper | 191634 | cd 60 | OK (BRON) | 1 min (Rolling Thunder / Herald −15 s) | WH-spell, IV-Ele |
| DPS: Ascendance | 114050 | cd 180 | OK (BRON) | 3 min, met First Ascendant 2 min. De Midnight-standaard is 2 min. | WH-spell, WH-pp-Ele |
| DPS: Fire Elemental | 198067 | cd 120 | **FOUT (BRON)** | **Verwijderd in 12.0.** Komt nu mee met Ascendance via het passieve talent Call of Fire. | WH-pp-Ele, IV-Ele |
| DPS: Storm Elemental | 192249 | cd 120 | **FOUT (BRON)** | **Verwijderd.** Nu Fury of the Storms: Stormkeeper roept hem op. | WH-pp-Ele, IV-Ele |
| DPS: Primordial Wave | 375982 | cd 30 | **FOUT (BRON)** | **Verwijderd, vervangen door Voltaic Blaze + Purging Flames.** Het commentaar "id pinned by SHAMAN_1 APL" is achterhaald. | WH-pp-Ele |
| `DPS_DEFENSIVES`: Ancestral Guidance | 108281 | cd 120 | **FOUT (BRON)** | Bestaat niet meer in 12.x. De classifier-kop (`KeybindRoles_Shaman.lua:96`) zegt dat zelf ook. Staat niet in IV-Ele of IV-Enh. Wordt nu niet getoond, maar staat gemarkeerd als "verified". | IV-Ele, IV-Enh |

**Gevolg:** op je eigen Ele-spec verbergt `IsPlayerSpell` de drie verwijderde spells waarschijnlijk (AFGELEID). In de preview die een **Resto Shaman** in de DPS-track ziet, staan ze er wél (`RoleAcademy.lua:622, 636-639`).

**Ontbreekt:**
- **Escape-stap is leeg.** Gust of Wind (sprong, 20 s), Spirit Walk (60% snelheid en snare weg, 1 min) en Ghost Wolf staan als `utility_primary` (`:36, :44, :80`), en de kaart kijkt alleen naar `role="mobility"`.
  - Thunderstorm (Ele baseline) duwt vijanden weg en werkt ook als je gestund bent.
  - BRON: IV-Ele.
- **Healing Stream Totem** is een class-talent voor alle specs en een kleine heal die je vaak kunt drukken. De classifier geeft hem alleen aan Resto (`:111`). BRON: IV-Ele (class tree), IV-Enh.
- **Spiritwalker's Grace / Nature's Swiftness** voor beweging. WH-Ele-rot noemt ze bij elke priority. Dit is geen overleving; alleen ter info.
- **Stone Bulwark Totem staat terecht NIET** in de lijst: hij is verwijderd (WH-pp-Ele). Nature's Guardian is passief (40% heal onder 35%). Dat is het vermelden waard als uitleg, niet als knop.

## Shaman — Enhancement (263)

**Kaart:**
1. Astral Shift — "when your health drops fast"
2. Healing Surge — "to heal yourself"
3. Wind Shear — "when it is casting something"

Earth Elemental ontbreekt door de fout met `specs={262}`.

| spell | id | wat de addon zegt | oordeel | wat het moet zijn | bron |
|---|---|---|---|---|---|
| Astral Shift | 108271 | hurts, prio 1; cd 120 | OK (BRON) | 2 min, 40%, 12 s | IV-Enh, WH-spell |
| Healing Surge | 8004 | heal_quick | OK (BRON) | Baseline. Met 5+ Maelstrom Weapon is hij instant. Die tip ontbreekt. | IV-Enh |
| Wind Shear | 57994 | interrupt | OK (BRON) | 12 s | IV-Enh |
| DPS: Feral Spirit | 51533 | cd 90 (en classifier `cooldown_bar`, `:81`) | **FOUT (BRON)** | **In 12.1 passief.** Sundering en Doom Winds roepen elk een wolf op. Er is geen knop meer. De oude Wowhead-spellpagina toont nog een actieve versie van 1,5 min, maar IV-Enh (12.1) en WH-Enh-rot noemen geen knop. | IV-Enh, WH-Enh-rot |
| DPS: Ascendance | **114050** | cd 180 | **FOUT (BRON) — verkeerde ID** | 114050 is de **Elemental**-versie. Enhancement is **114051**: die maakt van Stormstrike Windstrike en start Doom Winds. Het commentaar in `DpsToolkit.lua:48-50` ("genuinely SHARED") klopt niet. Gevolg (AFGELEID): `IsPlayerSpell(114050)` geeft op Enh waarschijnlijk `false`, dus de grootste cooldown van Stormbringer verdwijnt uit de eigen lijst. Cd 3 min (Thorim's Invocation −1 min). | WH-spell 114050/114051, IV-Enh |
| DPS: Doom Winds | 384352 | cd 60 | OK (BRON) | 1 min. Let op: keuzeknoop met Ascendance ("Replaces Doom Winds"). | WH-spell, IV-Enh |
| DPS: Sundering | 197214 | cd 30 | OK (BRON) | 30 s | IV-Enh |
| classifier: Primordial Wave | 375982 | `category="cooldown"` (`:83`) | FOUT (BRON), niet zichtbaar op de kaart | Staat niet meer in de Enh-kit van 12.1 | IV-Enh, WH-Enh-rot |
| `DPS_DEFENSIVES`: Ancestral Guidance | 108281 | cd 120 | FOUT (BRON), wordt niet getoond | Verwijderd | IV-Enh |

**Ontbreekt:**
- **Earth Elemental** (zie Ele), dus ook op de Enh-kaart.
  - WH-pp-Enh zegt dat de duur en de cooldown zijn verkort en dat de schadereductie van Primordial Bond weg is. Bij de cooldown spreken de bronnen elkaar tegen: IV-Enh zegt 5 min, WH-spell zegt 3 min (TWIJFEL).
  - Stone Bulwark Totem is verwijderd, en Enh "is noticeably more fragile" (WH-pp-Enh).
- **Escape:** Spirit Walk / Gust of Wind / Ghost Wolf staan niet op de kaart. BRON: IV-Enh.
- **Damage-cooldowns:**
  - **Surging Totem** (Totemic, 1 min burst) ontbreekt. BRON: IV-Enh, WH-pp-Enh, WH-Enh-rot.
  - **Primordial Storm** is een vervolg op Sundering, geen eigen cooldown.
- **Healing Stream Totem** (class tree) als self-heal. BRON: IV-Enh.

## Shaman — Restoration (264)

**Kaart:**
1. Astral Shift — "when your health drops fast"
2. Wind Shear — "when it is casting something"

Healing Surge valt waarschijnlijk weg omdat hij voor Resto niet meer bestaat (AFGELEID uit de filter). Daardoor heeft de **kaart geen enkele self-heal**.

| spell | id | wat de addon zegt | oordeel | wat het moet zijn | bron |
|---|---|---|---|---|---|
| Astral Shift | 108271 | hurts; `HEALER_DEFENSIVES` cd 120 | OK (BRON) | Class-talent | IV-Resto |
| Healing Surge | 8004 | classifier heal_quick (baseline, alle specs, `:41`); `HEALER_CORE_HEALS[264]` "fast" (`HealerCooldowns.lua:206`) | **FOUT (BRON)** | **"Healing Surge has been removed" voor Resto.** De healer-toolkit filtert niet en toont hem dus als kern-heal. Voor Resto hoort hier Healing Wave of Riptide. | WH-pp-Resto, IV-Resto (baseline noemt alleen Healing Wave) |
| Wind Shear | 57994 | interrupt | OK (BRON) | Class-talent; "the only healer interrupt". Een forumpost meldt een langere cd voor Resto (TWIJFEL, niet in een gids bevestigd). | WH-pp-Resto, IV-Resto, https://us.forums.blizzard.com/en/wow/t/preservation-wheres-my-interrupt/2244325 |
| HealCD: Healing Tide Totem | 108280 | cd 180, raid | OK (BRON) | 3 min. **Keuzeknoop met Ascendance.** | WH-spell, WH-pp-Resto |
| HealCD: Spirit Link Totem | 98008 | cd 180, mitig | OK (AFGELEID voor de cd; de spell zelf is BRON) | Bestaat in 12.1 (Spouting Spirits). Cd niet los nagemeten. | IV-Resto |
| HealCD: Ascendance (Resto) | 114052 | cd 180 | OK (BRON), met kanttekening | 3 min, keuzeknoop met HTT. De lijst toont beide ongefilterd. Het classifier-commentaar noemt nog "114049" (`KeybindRoles_Shaman.lua:88`). | WH-spell, WH-pp-Resto |
| HealCD: Mana Tide Totem | 16191 | cd 180, mana | **FOUT (BRON)** | Mana Tide Totem werd in 11.1 vervangen door Mana Tide, en **Mana Tide is in 12.0 verwijderd**. De lijst toont hem ongefilterd. | Wiki-MT, https://overgear.com/guides/wow/midnight-shaman-guide/ |
| Core: Riptide 61295, Healing Wave 77472, Chain Heal 1064, Healing Rain 73920 | — | — | OK (BRON) | Bestaan in 12.1 | IV-Resto |

**Ontbreekt:**
- **Self-heal op de kaart.** Riptide en Healing Wave staan als `click_cast` en tellen daarom niet mee. Healing Stream Totem is `utility_secondary`. De Resto-kaart zegt dus niets over jezelf heal­en. AFGELEID uit de code.
- **Earth Elemental.** IV-Resto noemt hem een "decent extra defensive cooldown". BRON.
- **Escape** (Spirit Walk / Gust of Wind / Ghost Wolf). BRON: IV-Resto.
- **Verwijderd, dus terecht niet opgenomen:** Earthen Wall Totem, Ancestral Protection Totem, Cloudburst, Wellspring. BRON: WH-pp-Resto en realmgg (https://realmgg.com/restoration-shaman-changes-midnight-world-of-warcraft/).
- **Healing Stream Totem** is dé centrale heal-knop in Midnight (WH-pp-Resto). Hij staat niet in `HEALER_CORE_HEALS[264]`.

---

## Evoker — Devastation (1467)

**Kaart:**
1. **Obsidian Scales — "keep this up, put it on BEFORE you pull"**
2. Zephyr — "when your health drops fast"
3. **Living Flame** — "to heal yourself" (prio 1; alfabetisch vóór Verdant Embrace)
4. Verdant Embrace — "to heal yourself"
5. **Renewing Blaze** — "to heal yourself" (als de client de passieve spell als bekend meldt)
6. Quell — "when it is casting something"

Er is geen escape-stap.

| spell | id | wat de addon zegt | oordeel | wat het moet zijn | bron |
|---|---|---|---|---|---|
| Obsidian Scales | 363916 (naam) | **defensive_1 → "keep this up, put it on BEFORE you pull"** | **FOUT (BRON)** | Een cooldown van 30% voor 12 s, cd 1,5 min (2 charges met Obsidian Bulwark). Je houdt hem niet "op". Hij hoort bij "when your health drops fast". Het is ook de hoofd-defensive van de Evoker ("one of the few defensive abilities"). Zelfde fout als Divine Shield. | IV-Dev, IV-Aug, WH-spell |
| Zephyr | 374227 (naam) | defensive_3 → "drops fast", prio 1 | TWIJFEL (BRON) | Werkt op jou + 4 bondgenoten, **alleen tegen AoE-schade** (−20%, 8 s), en geeft 30% snelheid. Cd 2 min. Tegen een enkele grote klap helpt hij niet. De tekst hoort te zeggen: "before a big AoE / group damage hit". | IV-Dev, WH-spell |
| Verdant Embrace | 360995 (naam) | heal_quick | OK (BRON) | Sterkste losse heal, "castable on yourself". Op een bondgenoot vlieg je naar die bondgenoot toe (waarschuwing ontbreekt). | IV-Dev |
| Living Flame | 361469 (naam) | heal_ooc, prio 1 | TWIJFEL (AFGELEID) | Kan op een vriendelijk doel healen, dus ook op jezelf (IV-Dev). Maar het is een cast met cast-tijd, en door prio 1 plus de alfabetische volgorde komt hij **vóór** de instant Verdant Embrace. Voor een beginner is de volgorde omgekeerd. | IV-Dev |
| Renewing Blaze | 374348 (naam) | heal_ooc, prio 2 (`KeybindRoles_Evoker.lua:72`); `DPS_DEFENSIVES[1467]` (`DpsToolkit.lua:78`) | **FOUT (BRON)** | **Sinds 12.0 een passief talent.** Obsidian Scales healt nu de schade terug die hij heeft tegengehouden. Het is geen knop meer en zeker geen "heal yourself". | Wiki-RB, WH-pp-Dev, WH-pp-Pres |
| Quell | 351338 (naam) | interrupt | OK (BRON) | Class-talent voor Dev/Aug. Cd 20 s (40 s zonder Imposing Presence). | IV-Dev |
| DPS: Dragonrage | 375087 | cd 120 | OK (BRON) | 2 min, 18 s | WH-spell, IV-Dev |
| DPS: Fire Breath | 357208 | cd 30 | TWIJFEL | Empower. Wowhead meldt voor één hero-pad 2 charges. De cd is niet door een 12.1-bron bevestigd. | WH-pp-Dev |
| DPS: Eternity Surge | 359073 | cd 30 | OK (BRON) | 30 s (Event Horizon −3 s) | WH-spell, IV-Dev |
| DPS: Deep Breath | 357210 | cd 120 | TWIJFEL (AFGELEID) | 2 min basis volgt uit "Onyx Legacy reduces by 1 minute" (IV-Dev). Strafing Run geeft een tweede cast. | IV-Dev, WH-pp-Dev |
| classifier: Firestorm | — | main_rotation (`:89`) | FOUT (BRON), niet zichtbaar op de kaart | In 12.0 **passief** geworden (Feed the Flames / Pyre) | WH-pp-Dev |
| classifier: Deep Breath | — | utility_primary | TWIJFEL (AFGELEID) | Is ook een ontsnapping: vliegen, en met Recall weer terug. Staat niet op de kaart. | IV-Dev |

**Ontbreekt:**
- **Escape: Hover.** Het is de beweeg-knop van de Evoker en kan sinds 12.0 zelfs tijdens een cast. Staat als `utility_primary` (`:56`) en valt daardoor buiten de kaart. BRON: IV-Dev, WH-pp-Dev.
- **Emerald Blossom als self-heal.** Baseline; met Panacea healt hij jou direct. BRON: IV-Dev.
- **Damage-cooldown: Tip the Scales** (instant empower op max rank). Staat alleen in de classifier. BRON: IV-Dev. Engulf (Flameshaper) is een hero-knop. BRON: IV-Dev.

## Evoker — Preservation (1468)

**Kaart:**
1. **Obsidian Scales — "keep this up …"** (FOUT, zie Dev)
2. Zephyr — "drops fast"
3. Living Flame — "heal yourself"
4. Verdant Embrace — "heal yourself"
5. Renewing Blaze (FOUT, passief)

Quell valt weg omdat hij niet bekend is (AFGELEID). Er is dus geen interrupt-regel en geen uitleg waarom.

| spell | id | wat de addon zegt | oordeel | wat het moet zijn | bron |
|---|---|---|---|---|---|
| Obsidian Scales | 363916 | keepup; `HEALER_DEFENSIVES` cd 90 | keepup FOUT (BRON); cd OK (BRON) | Zie Dev | IV-Pres |
| Renewing Blaze | 374348 | heal_ooc; `HEALER_DEFENSIVES[1468]` (`HealerCooldowns.lua:229`), wordt ongefilterd getoond | **FOUT (BRON)** | Samengevoegd met Obsidian Scales, passief | WH-pp-Pres, Wiki-RB |
| Quell | 351338 | interrupt, baseline alle specs (`KeybindRoles_Evoker.lua:54`) | **FOUT (BRON)** voor Pres | **"Removed Abilities: … Quell (our interrupt)".** Pres heeft in 12.x geen interrupt. De kaart zwijgt erover, terwijl juist dat een beginner verteld moet worden. | WH-pp-Pres, forum-link hierboven |
| HealCD: Rewind | 363534 | cd 240 | TWIJFEL | Bestaat nog (IV-Pres). 4 min komt alleen uit een zwakke bron (accountshark). Niet bevestigd. | IV-Pres |
| HealCD: Dream Flight | 359816 | cd 120 | OK (BRON) | 2 min; **keuzeknoop met Stasis**. Beide staan ongefilterd in de lijst. | Wiki-DF |
| HealCD: Emerald Communion | 370960 | cd 180, "flow" | **FOUT (BRON)** | **Verwijderd in 12.0**, nu alleen nog een PvP-talent | WH-pp-Pres, Wiki-EC |
| HealCD: Stasis | 370537 | cd 90 | OK (BRON) | 1,5 min (start pas als de aura weg is) | WH-spell, IV-Pres |
| HealCD: Time Dilation | 357170 | cd 60, ext | OK voor de functie (BRON); cd TWIJFEL | Een external op een bondgenoot (IV-Pres: "Casting this on a target…"). De cd is niet bevestigd. | IV-Pres |
| Core: Spiritbloom | 367226 | "big" (`HealerCooldowns.lua:177`) | **FOUT (BRON)** | **Verwijderd in 12.0** | WH-pp-Pres, IV-Pres (staat er niet in) |
| Core: Living Flame 361469, Reversion 366155, Verdant Embrace 360995, Emerald Blossom 355913 | — | — | OK (BRON) | — | IV-Pres |
| classifier: Spiritbloom / Emerald Communion | — | click_cast / cooldown (`:105, :116`) | FOUT (BRON) | Verwijderd | WH-pp-Pres |

**Ontbreekt:**
- **Core-heals:**
  - **Dream Breath** is in Midnight "the mandatory anchor". Hij staat alleen als `raid_heal` in de classifier en niet in `HEALER_CORE_HEALS`. BRON: IV-Pres; boostmatch (https://boostmatch.gg/blog/wow/articles/wow-midnight-preservation-evoker-guide), zwakkere bron.
  - **Echo** en **Temporal Anomaly** ontbreken ook. BRON: IV-Pres.
- **Escape:** Hover (en Rescue, dat een bondgenoot of jezelf verplaatst). BRON: IV-Pres ("Mobility Abilities").
- **Interrupt-tekst:** "Preservation heeft geen interrupt meer". BRON: WH-pp-Pres.

## Evoker — Augmentation (1473)

**Kaart:**
1. **Obsidian Scales — "keep this up …"** (FOUT)
2. Zephyr en **Defy Fate** — "drops fast" (beide prio 1, alfabetisch **Defy Fate eerst**)
3. Living Flame / Verdant Embrace / Renewing Blaze — "heal yourself"
4. Quell

Er is geen escape-stap.

| spell | id | wat de addon zegt | oordeel | wat het moet zijn | bron |
|---|---|---|---|---|---|
| Obsidian Scales | 363916 | keepup; `DPS_DEFENSIVES` cd 90 | keepup FOUT (BRON); cd OK | Baseline voor Aug | IV-Aug, Wiki (https://warcraft.wiki.gg/wiki/Obsidian_Scales) |
| Defy Fate | geen id | **defensive_4 → "when your health drops fast", staat bovenaan de stap** (`KeybindRoles_Evoker.lua:135`) | **FOUT (BRON)** | Een **passief cheat-death**-effect: "save you from fatal damage". Je kunt hem niet drukken. Als de client hem als bekend meldt (AFGELEID), staat er een knop op de kaart die niet bestaat, en nog wel als eerste. | IV-Aug, https://warcraft.wiki.gg/wiki/Defy_Fate |
| Zephyr | 374227 | hurts; `DPS_DEFENSIVES` cd 120 | TWIJFEL (BRON) | Zie Dev: alleen tegen AoE | IV-Aug, WH-spell |
| Renewing Blaze | 374348 | heal_ooc | **FOUT (BRON)** | Passief op Obsidian Scales. IV-Aug zegt het letterlijk: "causes Obsidian Scales to heal you". | IV-Aug, Wiki-RB |
| Verdant Embrace / Living Flame | — | heal | OK / TWIJFEL | Zie Dev | IV-Aug |
| Quell | 351338 | interrupt | OK (BRON) | Class-talent | IV-Aug |
| DPS: Breath of Eons | 403631 | cd 120, als "burst" | TWIJFEL (BRON) | 2 min klopt, maar het is **geen persoonlijke burst**. Hij "stores damage dealt by allies" en is een groepsversterker. De uitleg moet zeggen: "leg hem gelijk met de cooldowns van je groep". | IV-Aug, WH-pp-Aug, WH-spell |
| DPS: Ebon Might | 395152 | cd 30, als "burst" | **FOUT (BRON), wat betreft de uitleg** | Het is de **kern-buff voor je bondgenoten**, die je op cooldown houdt ("our main buffing spell", 30 s). Het is geen eigen schade-cooldown. Een beginner moet horen: "altijd aan houden, hij versterkt je team". | WH-pp-Aug, IV-Aug |
| DPS: Upheaval | 396286 | cd 40 | OK (BRON) | 40 s, empower | WH-spell, IV-Aug |
| classifier: Deep Breath (baseline) | — | utility_primary | TWIJFEL (BRON) | Voor Aug **vervangen** door Breath of Eons | IV-Aug |
| classifier: Blistering Scales / Time Skip | — | utility | OK (BRON) | Ally-buff (tank) en cooldown-reset. Time Skip kan vervangen zijn door Interwoven Threads (passief). | IV-Aug |

**Ontbreekt:**
- **Escape:** Hover (Chronowarden: Warp, met Temporality −20% schade). BRON: IV-Aug.
- **Self-heal:** Emerald Blossom, dat met Nourishing Sands extra 20% max HP healt. BRON: IV-Aug.
- **Damage-cooldowns:**
  - **Tip the Scales** (en Chronoboon). BRON: IV-Aug.
  - **Fire Breath** (empower, verlengt Ebon Might). BRON: IV-Aug.
  - **Time Skip.** BRON: IV-Aug.
- **Utility:** Prescience en Blistering Scales zijn ally-only. Ze staan terecht niet op de kaart. Ze horen in een support-uitleg, niet in "damage".

---

## Structurele oorzaken (file:line)

1. **`defensive_1` betekent "kleine defensive" voor de toetsenindeling, maar de kaart leest het als "altijd aan".**
   - Code: `SurvivalPlan.lua:76` plus locale `SURVIVAL_STEP_KEEPUP` (`Locales/enUS.lua:810`).
   - Mage (Ice Barrier) is het enige voorbeeld waarvoor dit klopt.
   - Evoker Obsidian Scales (`KeybindRoles_Evoker.lua:59`) krijgt zo dezelfde fout als Paladin Divine Shield.
   - Nodig: een expliciet `survival="hurts"`-veld, of een aparte `maintained`-vlag.
2. **Passieve talenten staan in de classifier als drukbare rollen.**
   - Defy Fate (`KeybindRoles_Evoker.lua:135`) en Renewing Blaze (`:72`).
   - `LiveName` (`SurvivalPlan.lua:165-180`) kijkt alleen of je de spell *kent*, niet of hij *passief* is.
   - Een check met `C_Spell.IsSpellPassive` (of iets vergelijkbaars) ontbreekt. **Nog te meten** welke API in 12.1 bestaat.
3. **De escape-stap leest alleen `role="mobility"`** (`SurvivalPlan.lua:81`), en Shaman en Evoker gebruiken die rol nergens.
   - Hover, Gust of Wind, Spirit Walk en Ghost Wolf staan op `utility_primary` (`KeybindRoles_Evoker.lua:56-57`, `KeybindRoles_Shaman.lua:36, 44, 80`) zonder `survival="escape"`.
   - Gevolg: beide klassen krijgen nooit een escape-regel.
4. **Rol-koppelingen aan specs zijn uit oude drafts overgenomen.**
   - Earth Elemental heeft `specs={262}` (`KeybindRoles_Shaman.lua:59`), met als reden "Ele Shift+C". Een toetskeuze bepaalt zo of een spell op de overlevingskaart staat.
   - Healing Surge staat als baseline voor alle specs (`:41`), terwijl Resto hem in 12.0 kwijt is.
5. **Verwijderde spells staan nog in de ID-lijsten, en die worden in preview of bij healers niet gefilterd.**
   - Lijsten:
     - `DpsToolkit.lua:51` (Fire/Storm Elemental, Primordial Wave)
     - `:52` (Feral Spirit)
     - `:92-93` (Ancestral Guidance)
     - `:78` (Renewing Blaze)
     - `HealerCooldowns.lua:115` (Emerald Communion)
     - `:148` (Mana Tide Totem)
     - `:177` (Spiritbloom)
     - `:206` (Healing Surge Resto)
     - `:229` (Renewing Blaze)
   - Filters:
     - `RoleAcademy.lua:468-505` heeft **geen** `IsPlayerSpell`-filter voor de healer-toolkit.
     - `:636-639` filtert DPS alleen voor de eigen actieve spec, dus de preview toont alles.
   - De commentaren "IDs verified in JustAC" en "never-lie" dateren van vóór de 12.0-prune. De bron (andere addons) is verouderd, precies zoals `CLAUDE.md` waarschuwt.
6. **Een gedeelde ID wordt aangenomen waar er per spec een eigen ID is.**
   - Enh Ascendance staat als 114050 (`DpsToolkit.lua:48-52`) maar is 114051.
   - Met de `IsPlayerSpell`-filter valt hij dan waarschijnlijk stil weg (AFGELEID).
   - **In de client te meten:** `IsPlayerSpell(114050)` en `IsPlayerSpell(114051)` op een Enh Shaman met Ascendance.
7. **Keuzeknopen worden allebei getoond.**
   - Dream Flight en Stasis (`HealerCooldowns.lua:114-116`); HTT en Ascendance (`:145, :147`).
   - Zonder filter ziet de speler een cooldown die hij niet heeft.
8. **De sortering binnen een stap is prioriteit, daarna alfabetisch** (`SurvivalPlan.lua:351-357`). Gelijke prioriteiten zetten de volgorde dus willekeurig:
   - Living Flame (cast) komt vóór Verdant Embrace (instant).
   - Defy Fate komt vóór Zephyr.
   - `priority` is bedoeld voor de toetsenindeling, niet voor "klein eerst, groot laatst".
9. **"Damage cooldown" is één label voor alles** (`RoleAcademy.lua:661`, `DPSKIT_TAG_BURST`).
   - Augmentation-support (Ebon Might, Breath of Eons) krijgt zo dezelfde uitleg als een persoonlijke burst.
   - Een `kind`-veld zoals `HealerCooldowns` al heeft (`ext`/`raid`) ontbreekt in `DPS_COOLDOWNS`.

**In de client te meten (nog open):**
- Welke van deze spells `IsPlayerSpell` bij naam als true meldt: Renewing Blaze, Defy Fate, Feral Spirit, Quell op Pres, Healing Surge op Resto.
- Welke Ascendance-ID Enh bezit.
- Of `C_Spell.IsSpellPassive` in 12.1 bestaat.
