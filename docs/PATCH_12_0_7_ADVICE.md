# Patch 12.0.7 "Revelations" — geverifieerd advies-overzicht voor MidnightHelper

Bron-input: een Gemini-samenvatting (Rob, 17 juni 2026) van een YouTube-gids. **Never-lie:**
elke claim hieronder is gekruist tegen (a) MH's eigen geverifieerde data in `docs/PTR_12.0.7_DATA.md`
(deels in-game/PTR bevestigd door Rob) en (b) actuele web-bronnen (juni 2026). Niets is overgenomen
op gezag van de video alleen.

Legenda: ✅ geverifieerd · ⚠️ bronnen spreken elkaar tegen (in-game beslissen) · ⬜ onbevestigd
(door niemand hard gemaakt) · ❌ Gemini had het mis.

---

## 0. Wat is hiervan NIEUW voor MH (build-prioriteit)

Het meeste 12.0.7-werk is al in MH gebouwd/geverifieerd: Showdowns (`Showdowns.lua`,
`ShowdownsData.lua`), Sporefall (`SporefallCoach.lua`), Ritual Sites (`RitualSites.lua`),
VoidAssaults, Rares, EventScheduler. Het **enige echt nieuwe, goed te bouwen onderdeel** uit
Gemini's tekst is de **Omnium Folio rune-tree-advisor** — MH had alleen de quest-IDs van de
weekly-keten, niet de rune-keuzes. Dat is nu volledig geverifieerd (sectie 1) en klaar om als
advies-module + Codex-artikel te bouwen.

---

## 1. Omnium Folio — rune-advies (✅ NIEUW, bouwbaar)

Borrowed power zónder gear-slot, blijft heel Midnight actief, gratis te wisselen, geen respec-kosten.
**5 rijen, 1 per wekelijkse reset; rij 1 meteen bij voltooien van de intro.** 13 runes totaal.
(ConquestCapped, met Wowhead spell-IDs; rune-namen & structuur identiek aan Gemini.)

**Unlock (✅ post-release bijgesteld, Icy Veins 16 jun + MH-note):**
- Start = **"The Magister's Call"** bij de **Field Accolade-vendors in Silvermoon City** → keten via
  **Magisters' Terrace** (+ Dawnstar Spire) → eindigt bij **Grand Magister Rommath** die je de Folio
  geeft; daarna een eigen **minimap-knop**. Eind-/week-1-quest = **"Seeking Knowledge Week 1 of 5: The
  Omnium Folio" = 96410** (Zygor-bevestigd). ✅ **Gemini had gelijk over de Silvermoon-start** (mijn
  eerdere "correctie" naar puur Rommath/Magisters' Terrace was te streng — ConquestCapped beschreef de
  eind-NPC). Beide kloppen: start in Silvermoon, eind bij Rommath.
- **Folio-unlock-storyline = "The Sunstrider Omnium"** (✅ volledige keten uit Zygor, 19 jun).
  Quest-IDs op volgorde: **96223** The Magister's Call (Silvermoon) → 96225 The Magister's
  Conundrum → 96226 Omnium Anomalies (The Lycaneum) → 96227 Lycaneum Chaos → 96228 The Shadowed
  Spire → 96229 The Void Reveals → **96230 Unravelling the Wards** → **96231 The Grand Magister's
  Key-Cipher** (Isle of Quel'Danas: Belo'vir's Arcane Vault; loot *Grand Magister's Key-Cipher*
  item 274261) → 96232 Return to the Omnium → 96233 The Omnium Reawakens → **96410** "Seeking
  Knowledge Week 1 of 5: The Omnium Folio" (Rommath overhandigt de Folio). Daarna ontgrendelen de
  weekly's **96441/96442/96443/96444** (week 2–5) de overige rijen. Folio-item-tooltip: spell
  **1302265 (CDPulse)**, iconID 1506458.

**Account-wide of per-char? — ✅ OPGELOST (Icy Veins 16 jun, post-release):**
- **Unlocks = account-breed.** Letterlijk: "Access to the Omnium Folio will be unlocked for your entire
  account once you complete the questline" + "unlocking a Mote of Omnial Inquiry on one character unlocks
  it for your entire account." → questlijn 1× doen; de wekelijkse Mote opent een rij voor het hele account.
  Matcht MH's eigen note (warband/account-breed).
- **Rune-keuze = per personage** (elke char kiest z'n eigen build) — dáár sloeg de "per-character" van
  ConquestCapped (pre-release) op.
- → **AccountWeeklyChecklist: de Folio-weekly is een account-regel** (1× per account), niet per char.
  De "x/5 rijen"-teller in de tab werkt account-breed (warband-quest-flags). De tab-tekst is hierop
  bijgewerkt (intro + voet).
- ⬜ Gemini's "catch-up: gemiste weken inhalen" blijft onbevestigd (geen bron post-release) → niet
  als feit adviseren.

**De 5-rij rune-tree (spell-IDs voor tooltip-links via {SPELL:id}):**

Rij 1 — Core Rune (keuze 2):
- Rune of Void-Touched Orbs — spell **1279596** — orbs (max 5/10s); aanval = Cosmic damage, heal =
  redirect naar ally. *Veiligste pick voor bijna alle specs/healers.*
- Rune of Unleashed Fire — spell **1279599** — vuurpilaren (damage of ally-heal); vereist uptime.

Rij 2 — Defensief (keuze 3):
- Rune of Self-Mending — spell **1279603** — passieve heal onder 75% HP. *Default world/solo.*
- Rune of Void-Tainted Shell — spell **1279604** — absorb tegen hits >10% max HP; 50% bloedt terug
  over 10s; 30s CD. *BiS Raid/M+ (countert one-shots).*
- Rune of Lynxlike Reflexes — spell **1279605** — movement speed na hit; 30s CD. *Niche/PvP.*

Rij 3 — geen keuze, iedereen:
- Rune of Lingering — spell **1287555** — voegt 8s DoT/HoT toe na elke Core-proc (~verdubbelt
  throughput bij goede uptime).

Rij 4 — Stat (keuze 4; elke Core-proc stackt rating):
- Critical Power **1279609** · Burning Haste **1287774** · Masterful Cunning **1287771** ·
  the Versatile Warrior **1279613**. *Volg spec-prio; Versatility = veiligste catch-all.*

Rij 5 — Capstone (keuze 3):
- Rune of Overload — spell **1279614** — verdubbelt Core-effect. *Veiligste/algemeen beste.*
- Rune of Residual Energy — spell **1279615** — verdubbelt Lingering. *DoT-specs / lange ST.*
- Rune of Echoes — spell **1279616** — herhaalt 50% na 10s. *Hoogste plafond, vereist ~90% uptime.*

**Aanbevolen builds (ConquestCapped) — bruikbaar als MH-advieslogica per content-type:**
- M+: Orbs → Shell → Lingering → spec-stat → Overload
- Raid ST: Orbs → Shell → Lingering → spec-stat → Echoes
- Raid DoT-build: Orbs → Shell → Lingering → spec-stat → Residual Energy
- PvP: Orbs → Lynxlike → Lingering → Versatility → Overload
- Outdoor/casual: Orbs → Self-Mending → Lingering → Versatility → Overload

**MH-bouwidee:** `OmniumFolioCoach`-module of Codex-artikel: toon de 5 rijen, markeer de aanbevolen
pick per gekozen content-type (M+/Raid/PvP/World), met {SPELL:id}-hovertips. Detecteer voortgang via
de weekly-keten-IDs die MH al heeft (96410, 96441, 96442, 96443, 96444). Geen rune-keuze hardcoden
als "BiS" zonder caveat (specs verschillen) — adviseer met de veiligste default + uitleg.

---

## 2. Showdown-zones Val & Naigtal (grotendeels al in MH ✅)

- ❌ Gemini "Rift Blade Meia in Silvermoon start de questlijn" → het is **Riftblade Maella**, en de
  echte intro is bij **Voidstorm / Screaming Ridge (2405, 51.42/71.30)**, NIET Silvermoon. De
  gelijknamige SMC-NPC is de housing/Decor-Duels-NPC (Rob, PTR 16 jun). MH heeft `introNpc` al juist.
- ✅ Wekelijkse rotatie (1 zone tegelijk): bevestigd (Blizzard-blog). ⚠️ één gids zei "every few
  days" → MH heeft dit als open punt; rotatie-cadans in-game herbevestigen.
- ✅ Normal→Heroic-flow klopt: `hasWorldTier=true`, geen unlock-vereiste, keuze bij het portaal.
  Heroic = Hero-track gear + meer Field Accolades. (MH heeft de zones, uiMapIDs 2599/2600, weeklies
  96713/96717, rares-rosters al.)
- **Advies-logica voor MH (Gemini's farm-route, redelijk maar deels efficiency-mening):** intro op
  Normal → bij world-boss-quest de zone verlaten → Heroic kiezen → terug via Silvermoon-portaal
  (2393, 47.93/48.09). Dit is een *strategie-tip*, geen harde mechanic → als Codex/advies tonen,
  niet als verplichte stap.

---

## 3. Valuta & beloningen

- ✅ **Field Accolade** = bestaande currency **3405** (ook item-vorm 271787). Hoofdvaluta van de patch;
  Hero/Warbound-Champion gear bij Silvermoon-vendors. MH trackt currencies al.
- ❌/⚠️ **Voidlight Marl is GEEN nieuwe valuta** — het is de bestaande Midnight-renown-munt
  (currency **3316**, warband-transferable; MH trackt 'm al). De 12.0.7-vendors prijzen er alleen óók
  in. (Gemini noemde Marl niet, maar let hierop bij eventuele "nieuwe currency"-claims.)
- ✅ **"Void Cores"-weekly bij de Ritual Sites — IN-GAME BEVESTIGD (Rob, 17 jun):** questlijn
  **"Ritual Site Studies: Week 1 of 3"**, gegeven door **Lady Darkglen** bij de Ritual Sites.
  Doel wk1: **disrupt 2× Tier 6 Ritual Sites terwijl de "Reinforcements"-challenge actief is**.
  Beloning aan het eind van de keten: **Nebulous Voidcore** (bonus-roll-item) + **Voidlight Marl ×300**
  + ~68g 32s. → Gemini had hier dus gelijk; eerder als ⬜ gemarkeerd, nu bevestigd. (Nebulous Voidcore
  is dus uit meerdere bronnen te halen: Sporefall-intro 96746 én deze 3-weken-Ritual-keten.)
  **Quest-ID: "Ritual Site Studies: Week 1 of 3" = 96728** ✅ (Rob 17 jun); gerelateerd
  "Midnight: Ritual Sites" = 95843. Wk2/wk3-IDs volgen bij de resets.

---

## 4. Tier 6 Ritual Sites (grotendeels al in MH ✅)

- ✅ **6 challenges tegelijk** vereist; aanbevolen ~ilvl 270 (MH/Wowhead).
- ✅ Beloning **5 Myth Dawncrests** per T6-run (MH; Gemini zei "Myth Crests" — generiek correct).
  Plus Hero Dawncrests, Field Accolades, Voidlight Marl, Coffer Key Shards. Vault: World-rij ilvl 269.
- ⬜ Gemini's "upgrade Spark-crafted gear eenvoudig naar ilvl 285" = specifiek getal, **niet
  geverifieerd** in MH-data → niet als feit tonen.
- MH-impact (al genoteerd): RitualCoach T6-regel, Codex-tip "Myth Dawncrests soloable via T6".

---

## 5. Sporefall-raid (al in MH als `SporefallCoach` ✅)

- ❌ Gemini "boss Rott Meer", "quest bij Sporamir" → de boss heet **Rotmire** (npc **254176**); de
  intro/bonus-roll-quest is **"Sporefall: Rotmire" = quest 96746**. "Rott Meer"/"Sporamir" zijn
  verhaspelingen — niet overnemen.
- ✅ 1-boss-raid in **Harandar** (zone 16279), LFR/N/H/Mythic dag 1, **Mythic = flex 15-25** (uniek).
- ✅ Mythic-loot **ilvl 298** ("Sporefused"-tag, geen upgrade-track).
- ⬜ Gemini "een bonus-roll op Rotmire kost 2 bonus-rolls i.p.v. 1; addon moet ≥2 checken" — **niet
  in MH-data en niet geverifieerd.** Interessante waarschuwing als 'tie waar is, maar **eerst in-game
  bevestigen** voordat MH zo'n check inbouwt. (MH-mechaniek nu: bonus via Nebulous Voidcore uit 96746.)
- ⬜ Telt een Rotmire-kill mee in de Great Vault Raid-rij? Nog niet bevestigd (MH open punt).

---

## 6. Kalender-gating (voor event-/advies-timing)

- ✅ **Patch live: 16 juni 2026** (US) / 17 juni (EU).
- ✅ **Turbulent Timeways V: 30 juni → 11 augustus 2026** (2 weken na de patch). Debuut van
  **Dragonflight Timewalking**; mount **Spawn of Vyranoth** (MH: item 258884, ach 61463) via 5 weken
  de "Mastery of the Timeways"-buff onderhouden. Gemini's 30-juni-datum = bevestigd.
  - Advies-logica (Gemini, redelijk): alt-leveling uitstellen tot 30 juni voor de 30% XP-buff.
  - ⬜ De exacte DF-Timewalking-dungeonlijst (Algeth'ar Academy, Halls of Infusion, Neltharus, Ruby
    Life Pools, Azure Vaults, Brackenhide Hollow) is de bekende DF-TW-pool, maar niet 1-op-1
    geverifieerd voor deze iteratie → als "verwachte pool" tonen, licht gemarkeerd.
- ⬜ **Story-chapters 7 juli bij NPC "Orwena"** — **niet bevestigd** door de gecheckte bronnen.
  Niet als datum/locatie hardcoden tot bevestigd.

---

## 7. Samenvatting van Gemini-fouten (om niet over te nemen)

| Gemini-claim | Status | Correct / MH-data |
|---|---|---|
| Omnium Folio rune-tree (alle runes) | ✅ klopt | spell-IDs in sectie 1 |
| Unlock-start bij de Field Accolade-vendors in Silvermoon | ✅ klopt | start "The Magister's Call" in SMC → via Magisters' Terrace → eind bij Rommath (Icy Veins 16 jun) |
| Folio account-wide (unlocks/Motes) | ✅ klopt | account-breed bevestigd (Icy Veins); rune-keuze is per char |
| Folio catch-up (weken inhalen) | ⬜ | onbevestigd post-release — niet als feit |
| "Rift Blade Meia" in Silvermoon start Showdown | ❌ | Riftblade Maella; intro = Voidstorm/Screaming Ridge |
| Raid-boss "Rott Meer", NPC "Sporamir" | ❌ | Rotmire (254176), quest "Sporefall: Rotmire" 96746 |
| Rotmire-bonusroll kost 2 rolls | ⬜ | niet geverifieerd — in-game checken |
| "Void Cores" weekly bij Ritual Sites voor T6 | ✅ klopt | "Ritual Site Studies" (Lady Darkglen), 2× T6 met Reinforcements → Nebulous Voidcore + 300 Marl (in-game 17 jun) |
| T6 upgrade Spark-gear naar 285 | ⬜ | niet geverifieerd (MH: 5 Myth Dawncrests, vault 269) |
| Turbulent Timeways 30 juni | ✅ | bevestigd (t/m 11 aug) |
| Story-chapters 7 juli bij "Orwena" | ⬜ | niet bevestigd |

---

## Bronnen
- ConquestCapped — Omnium Folio Guide: https://conquestcapped.com/guides/wow/omnium-folio/
- ConquestCapped — 12.0.7 Patch Overview: https://conquestcapped.com/guides/wow/wow-patch-12-0-7-overview/
- WoWVendor — Turbulent Timeways guide: https://wowvendor.com/media/wow/turbulent-timeways-event-guide/
- Icy Veins — Midnight 12.0.7 guide: https://www.icy-veins.com/wow/midnight-1207-guide
- Method — Turbulent Timeways leveling: https://www.method.gg/guides/how-to-level-quickly-during-turbulent-timeways-wow-midnight-season-1
- MH intern (deels in-game/PTR bevestigd): `docs/PTR_12.0.7_DATA.md`
