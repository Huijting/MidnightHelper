# Keybind-maps (v6 toegepast, CONCEPT) — Rogue, Monk, Druid

> ⚠️ **Update 2026-07-02 (ná dit draft):** F2/F3/F4 zijn **heal-ankers** geworden
> (F2 = snelle combat-heal, F3 = out-of-combat-heal, F4 = recuperate/HoT — bv. Crimson Vial
> op F4). Utility-slots zijn nu F/R/T/X + overflow. F2–F4-toewijzingen herzien bij encoderen.

Standaard: `docs/KEYBIND_STANDARD_v6.md`. Kit + spell-ID's: web-research (Icy Veins/Wowhead/
Method, 12.0.5–12.0.7, juli 2026). **Dit is een CONCEPT-doc** — nog niet in-game bevestigd.

**Labels:** 🟡 = web-bron gevonden maar onbevestigd (in-game tooltip-check nodig) ·
⚠️ = ID onbekend — in-game dumpen. Er staat hier **geen enkele ✅** — niemand heeft dit nog
in-game gecheckt. Behandel elk 🟡-ID als "waarschijnlijk correct, maar niet geverifieerd."

Ankers (alle specs, verplaatsen nooit): **E**=interrupt · **Q**=movement · **Z**=kleine def ·
**C**=grote def · **V**=dispel/CC · **F1**=grote cooldown · **Shift+E**=racial · **Ctrl+F1**=trinket ·
**Alt+C**=potion (de laatste drie zijn generiek — niet per spec herhaald in de tabellen).
Overflow = zelfde toets, volgende modifier (**Shift→Ctrl→Alt**). Geen G.

**Belangrijke Midnight-context (button-bloat-reductie):** meerdere abilities uit TWW zijn
verwijderd of verplaatst (bv. Weapons of Order weg bij Brewmaster, Storm/Earth/Fire vervangen
door Zenith bij Windwalker, Symbols of Death/Flagellation weg bij Subtlety). Waar bronnen
elkaar tegenspreken over of iets nog bestaat, is dat genoteerd.

---

## 🗡️ Rogue

### Assassination

| Toets | Ability | ID | Categorie |
|------|---------|----|-----------|
| **1** | Mutilate | 1329 🟢 (addon-data: JustAC SpellArchetypes.lua — "Mutilate"; kanttekening: JustAC listet ook 5374 als Mutilate-variant) | Builder (ST, combo points) |
| **2** | Shiv | 5938 🟢 (addon-data: JustAC SpellArchetypes.lua — "Shiv") | Builder (utility-generator) |
| **3** | Garrote | 703 🟢 (addon-data: JustAC SpellArchetypes.lua — "Garrote") | Builder/DoT (opener, onderhouden) |
| **4** | Envenom | 32645 🟢 (addon-data: JustAC SpellArchetypes.lua — "Envenom") | Spender (kern-finisher) |
| **5** | Rupture | 1943 🟢 (addon-data: JustAC SpellArchetypes.lua — "Rupture") | Spender (bleed-onderhoud) |
| **Shift+1** | Fan of Knives | 51723 🟢 (addon-data: JustAC SpellArchetypes.lua — "Fan of Knives") | AoE builder |
| **Shift+5** | Crimson Tempest | 1247227 🟢 (addon-data: JustAC SpellArchetypes.lua — "Crimson Tempest") | AoE spender (verspreidt bleeds) |
| **E** | Kick | 1766 🟢 (addon-data: JustAC InterruptAbilities.lua — "Kick", kind="interrupt"; ook Interrupt_CCAndCD_Tracker) | Interrupt |
| **Q** | Sprint | 2983 🟢 (addon-data: JustAC SpellDB.lua gap-closer-lijst ROGUE_1 — "Sprint"; SpellCategories.lua) | Movement |
| **Shift+Q** | Shadowstep | 36554 🟢 (addon-data: JustAC SpellDB.lua gap-closer-lijst — "Shadowstep") | Movement (gap-closer) |
| **Z** | Crimson Vial | 185311 🟢 (addon-data: JustAC SpellDB.lua ROGUE-defensives + SpellCategories.lua — "Crimson Vial") | Kleine defensive (self-heal) |
| **Shift+Z** | Feint | 1966 🟢 (addon-data: JustAC SpellDB.lua + SpellCategories.lua — "Feint") | Defensive (AoE dmg-reductie) |
| **C** | Cloak of Shadows | 31224 🟢 (addon-data: JustAC SpellDB.lua ROGUE-defensives — "Cloak of Shadows") | Grote defensive (magic immune) |
| **Shift+C** | Evasion | 5277 🟢 (addon-data: JustAC SpellDB.lua + SpellCategories.lua — "Evasion") | Defensive (dodge) |
| **V** | Blind | 2094 🟢 (addon-data: JustAC InterruptAbilities.lua — "Blind", kind="cc") | CC (disorient) |
| **Shift+V** | Kidney Shot | 408 🟢 (addon-data: JustAC InterruptAbilities.lua — "Kidney Shot", kind="cc") | CC (finisher-stun) |
| **F1** | Deathmark | 360194 🟢 (addon-data: JustAC SpellArchetypes.lua + SpellDB.lua ROGUE_1-cooldown — "Deathmark") | Grote cooldown (2 min) |
| **Shift+F1** | Kingsbane | 385627 🟢 (addon-data: JustAC SpellArchetypes.lua + SpellDB.lua ROGUE_1 — "Kingsbane") | Cooldown (1 min) |
| **F** | Vanish | 1856 🟢 (addon-data: JustAC SpellArchetypes.lua — "Vanish") | Utility (stealth, reset) |
| **R** | Sap | 6770 🟢 (addon-data: JustAC SpellCategories.lua — "Sap") | CC (uit combat/stealth) |
| **T** | Cheap Shot | 1833 🟢 (addon-data: JustAC InterruptAbilities.lua — "Cheap Shot", kind="cc") | CC (stun vanuit stealth) |

~20 binds. Poison-toepassing (Deadly Poison 2823 🟢 [JustAC RedundancyFilter.lua/SpellDB.lua — "Deadly Poison"] / Instant Poison 315584 🟢 [JustAC RedundancyFilter.lua/SpellDB.lua — "Instant Poison"]) is een
pre-combat rechtermuisklik-toepassing, geen combat-keybind — niet in de tabel opgenomen.
Nieuwe Apex-talent Implacable (1265385 🟡; ClassCodex Rogue guide.lua gebruikt {1265385} positioneel in
de Assassination-rotatie — "unless at 80 stacks" — maar zonder naam-label, dus ID-naam-koppeling niet
addon-bevestigd) is passief, geen knop nodig.

### Outlaw

| Toets | Ability | ID | Categorie |
|------|---------|----|-----------|
| **1** | Sinister Strike | 193315 🟢 (addon-data: JustAC SpellArchetypes.lua — "Sinister Strike") | Builder |
| **2** | Pistol Shot | 185763 🟢 (addon-data: JustAC SpellArchetypes.lua — "Pistol Shot") | Builder (Opportunity-proc) |
| **3** | Roll the Bones | 315508 🟡 (ClassCodex Rogue guide.lua gebruikt {315508} positioneel in de Outlaw-rotatie — "on cooldown if at stage 1 or less" — maar zonder naam-label; ID-naam niet addon-bevestigd) | Builder/buff (4-stage, herwerkt) |
| **4** | Between the Eyes | 315341 🟢 (addon-data: JustAC SpellArchetypes.lua — "Between the Eyes") | Spender (finisher/stun) |
| **5** | Dispatch | 2098 🟢 (addon-data: JustAC SpellArchetypes.lua — "Dispatch") | Spender/builder-hybride |
| **Shift+1** | Blade Flurry | 13877 🟡 | AoE (cleave-toggle) |
| **E** | Kick | 1766 🟢 (addon-data: JustAC InterruptAbilities.lua — "Kick") | Interrupt |
| **Q** | Grappling Hook | 195457 🟢 (addon-data: JustAC SpellDB.lua gap-closer-lijst ROGUE_2 — "Grappling Hook") | Movement (Outlaw-exclusief) |
| **Shift+Q** | Sprint | 2983 🟢 (addon-data: JustAC SpellDB.lua ROGUE_2 — "Sprint") | Movement |
| **Z** | Crimson Vial | 185311 🟢 (addon-data: JustAC SpellDB.lua + SpellCategories.lua — "Crimson Vial") | Kleine defensive |
| **Shift+Z** | Feint | 1966 🟢 (addon-data: JustAC SpellDB.lua + SpellCategories.lua — "Feint") | Defensive (AoE dmg-reductie) |
| **C** | Cloak of Shadows | 31224 🟢 (addon-data: JustAC SpellDB.lua — "Cloak of Shadows") | Grote defensive |
| **Shift+C** | Evasion | 5277 🟢 (addon-data: JustAC SpellDB.lua + SpellCategories.lua — "Evasion") | Defensive |
| **V** | Blind | 2094 🟢 (addon-data: JustAC InterruptAbilities.lua — "Blind") | CC (disorient) |
| **Shift+V** | Kidney Shot | 408 🟢 (addon-data: JustAC InterruptAbilities.lua — "Kidney Shot") | CC (finisher-stun) |
| **F1** | Adrenaline Rush | 13750 🟢 (addon-data: JustAC SpellDB.lua ROGUE_2-cooldown — "Adrenaline Rush") | Grote cooldown |
| **Shift+F1** | Killing Spree | 51690 🟢 (addon-data: JustAC SpellArchetypes.lua + SpellDB.lua ROGUE_2 — "Killing Spree") | Cooldown |
| **Ctrl+F1** | Keep It Rolling | 381989 🟡 (ClassCodex Rogue guide.lua gebruikt {381989} positioneel in de Outlaw-rotatie — "if stage 3 or higher RtB active" — maar zonder naam-label; ID-naam niet addon-bevestigd) | Cooldown (herrolt naar hoogste RtB-stage; talent) |
| **F** | Vanish | 1856 🟢 (addon-data: JustAC SpellArchetypes.lua — "Vanish") | Utility (reset Between the Eyes) |
| **R** | Sap | 6770 🟢 (addon-data: JustAC SpellCategories.lua — "Sap") | CC |
| **T** | Cheap Shot | 1833 🟢 (addon-data: JustAC InterruptAbilities.lua — "Cheap Shot") | CC (stun vanuit stealth) |

⚠️ **Preparation**: onderzoeksbron gaf ID 1277933, wat sterk afwijkt van het historisch bekende
ID 14185. Dit ID is **niet betrouwbaar** — behandel als ⚠️ (ID onbekend, in-game dumpen) tot
bevestigd. Niet in de tabel opgenomen totdat het is geverifieerd. **Addon-check (2026-07-02, herzien):**
ClassCodex's Rogue `guide.lua` gebruikt {1277933} **wél** positioneel in de Outlaw-rotatie (als een
cooldown naast {315341} Between the Eyes en {13750} Adrenaline Rush) — dus dat ID komt in een addon
voor. **Maar** guide.lua geeft géén naam-label, dus of 1277933 daadwerkelijk "Preparation" is, kan
niet uit addon-data worden bevestigd (never-lie). De andere addons (JustAC, CooldownCompanion, CDPulse,
Interrupt_CCAndCD_Tracker, BliZzi_Interrupts) hebben geen 1277933- of Preparation-vermelding. Netto:
ID 1277933 bestaat en wordt in de Outlaw-rotatie gebruikt, maar de naam "Preparation" blijft ⚠️
(onbevestigd) — in-game tooltip-check. Slice and Dice (5171 🟢 [JustAC SpellArchetypes.lua — "Slice and Dice"]) is
grotendeels vervangen door Roll the Bones-mechaniek in Midnight-guides; niet apart gebonden.

### Subtlety

| Toets | Ability | ID | Categorie |
|------|---------|----|-----------|
| **1** | Shadowstrike | 185438 🟢 (addon-data: JustAC SpellArchetypes.lua — "Shadowstrike"; SpellDB.lua ROGUE_3) | Builder (vanuit Stealth/Shadow Dance) |
| **2** | Backstab | 53 🟢 (addon-data: JustAC SpellArchetypes.lua — "Backstab") | Builder (buiten Shadow Dance) |
| **3** | Secret Technique | 280719 🟢 (addon-data: JustAC SpellArchetypes.lua + SpellDB.lua ROGUE_3 — "Secret Technique") | Spender/cooldown-hybride (prioriteit tijdens Shadow Dance) |
| **4** | Eviscerate | 196819 🟢 (addon-data: JustAC SpellArchetypes.lua — "Eviscerate") | Spender (kern-finisher) |
| **5** | Mark for Death | 1293340 🟡 (geen addon-data — geen enkele van de 8 addons bevat 1293340; in-game dumpen) | Utility (herplaatst Deathstalker's Mark) |
| **Shift+1** | Shuriken Storm | 197835 🟢 (addon-data: JustAC SpellArchetypes.lua — "Shuriken Storm") | AoE builder |
| **Shift+4** | Black Powder | 319175 🟢 (addon-data: JustAC SpellArchetypes.lua — "Black Powder") | AoE spender (3+ targets) |
| **E** | Kick | 1766 🟢 (addon-data: JustAC InterruptAbilities.lua — "Kick") | Interrupt |
| **Q** | Shadowstep | 36554 🟢 (addon-data: JustAC SpellDB.lua ROGUE_3 gap-closer — "Shadowstep") | Movement |
| **Shift+Q** | Sprint | 2983 🟢 (addon-data: JustAC SpellDB.lua ROGUE_3 — "Sprint") | Movement |
| **Z** | Crimson Vial | 185311 🟢 (addon-data: JustAC SpellDB.lua + SpellCategories.lua — "Crimson Vial") | Kleine defensive |
| **Shift+Z** | Feint | 1966 🟢 (addon-data: JustAC SpellDB.lua + SpellCategories.lua — "Feint") | Defensive |
| **C** | Cloak of Shadows | 31224 🟢 (addon-data: JustAC SpellDB.lua — "Cloak of Shadows") | Grote defensive |
| **Shift+C** | Evasion | 5277 🟢 (addon-data: JustAC SpellDB.lua + SpellCategories.lua — "Evasion") | Defensive |
| **V** | Blind | 2094 🟢 (addon-data: JustAC InterruptAbilities.lua — "Blind") | CC (disorient) |
| **Shift+V** | Kidney Shot | 408 🟢 (addon-data: JustAC InterruptAbilities.lua — "Kidney Shot") | CC (finisher-stun) |
| **F1** | Shadow Dance | 185313 🟡 (ClassCodex Rogue guide.lua gebruikt {185313} positioneel in de Subtlety-rotatie — "repeat for the rest of {185313}" — maar zonder naam-label; ID-naam niet addon-bevestigd) | Grote cooldown (definiërend) |
| **Shift+F1** | Shadow Blades | 121471 🟢 (addon-data: JustAC SpellDB.lua ROGUE_3-cooldown — "Shadow Blades") | Grote cooldown (90s) |
| **F** | Vanish | 1856 🟢 (addon-data: JustAC SpellArchetypes.lua — "Vanish") | Utility (stealth) |
| **R** | Sap | 6770 🟢 (addon-data: JustAC SpellCategories.lua — "Sap") | CC |
| **T** | Cheap Shot | 1833 🟢 (addon-data: JustAC InterruptAbilities.lua — "Cheap Shot") | CC (stun vanuit stealth) |

Midnight-rebalans: Symbols of Death en Flagellation zijn **verwijderd** — Shadow Dance +
Shadow Blades vormen nu het 90s-cooldownraamwerk. Coup de Grace (441423 🟡; ClassCodex Rogue guide.lua
gebruikt {441423} positioneel — "{196819} with {441423}" (Eviscerate versterkt door Coup de Grace) —
maar zonder naam-label, dus ID-naam niet addon-bevestigd) niet apart gebonden, overlapt met Eviscerate-slot.

---

## 🥋 Monk

### Brewmaster

| Toets | Ability | ID | Categorie |
|------|---------|----|-----------|
| **1** | Keg Smash | 121253 🟢 (addon-data: JustAC SpellArchetypes.lua — "Keg Smash") | Builder (AoE dmg + snare) |
| **2** | Tiger Palm | 100780 🟢 (addon-data: JustAC SpellArchetypes.lua — "Tiger Palm") | Builder/filler |
| **3** | Blackout Kick | 100784 🟢 (addon-data: JustAC SpellArchetypes.lua — "Blackout Kick") | Builder (Shuffle + Mastery-stack) |
| **4** | Purifying Brew | 119582 🟢 (addon-data: JustAC SpellDB.lua MONK_1 — "Purifying Brew") | Spender (purift Stagger) |
| **Shift+2** | Breath of Fire | 115181 🟢 (addon-data: JustAC SpellArchetypes.lua — "Breath of Fire") | AoE/DoT |
| **Shift+3** | Rushing Jade Wind | 116847 🟢 (addon-data: JustAC SpellArchetypes.lua — "Rushing Jade Wind") | AoE (talent) |
| **E** | Spear Hand Strike | 116705 🟢 (addon-data: JustAC InterruptAbilities.lua — "Spear Hand Strike", kind="interrupt") | Interrupt (talent, vrijwel altijd gepickt) |
| **Q** | Roll | 109132 🟢 (addon-data: JustAC SpellDB.lua MONK_1 gap-closer + SpellCategories.lua — "Roll") | Movement |
| **Z** | Celestial Brew | 322507 🟢 (addon-data: JustAC SpellDB.lua MONK_1 + SpellCategories.lua — "Celestial Brew") | Kleine defensive (absorb-shield) |
| **Shift+Z** | Purifying Brew (zie 4) | — | *(dubbel; Purifying Brew staat al op 4, geen aparte Shift-slot nodig)* |
| **C** | Fortifying Brew | 120954 🟢 (addon-data: JustAC `DEFENSE_TIER`/`MONK_1` en BliZzi_Interrupts bevestigen 120954 als Brewmaster-specifieke variant/aura; 115203 is de gedeelde basis-ID) | Grote defensive/major cooldown |
| **V** | Paralysis | 115078 🟢 (addon-data: JustAC InterruptAbilities.lua — "Paralysis", kind="cc") | CC (single-target incapacitate) |
| **Shift+V** | Leg Sweep | 119381 🟢 (addon-data: JustAC InterruptAbilities.lua — "Leg Sweep", kind="cc") | CC (AoE stun) |
| **F1** | Invoke Niuzao, the Black Ox | 132578 🟢 (addon-data: BliZzi_Interrupts PartyCooldowns.lua — label="Invoke Niuzao, the Black Ox", spec=MONK_BREW) | Grote cooldown |
| **F** | Provoke | 115546 🟢 (addon-data: JustAC SpellCategories.lua — "Provoke") | Utility (taunt) |

🟢 **Fortifying Brew opgehelderd via addon-data:** JustAC's `SpellCategories.lua` en
`SpellDB.lua` (DEFENSE_TIER) én ExwindCore/LibOpenRaid's Midnight-bestand geven een
spec-specifieke opsplitsing: **115203** = gedeelde basis-ID (alle Monk-specs kennen deze
spell-naam), **120954** = Brewmaster-variant/aura, **201318** = Windwalker-variant,
**243435** = **Mistweaver**-variant (niet Brewmaster, zoals het draft-vermoeden was!).
Voor Brewmaster op **C** dus 120954 (zie tabel hierboven, bijgewerkt).
**Verwijderd in Midnight (bevestigd):** Zen Meditation, Weapons of Order, Dampen Harm,
Diffuse Magic (los), Rising Sun Kick uit Brewmaster-kit. Rij C→Shift+Z is bewust leeg gelaten
(geen 2e major defensive nodig, Purifying Brew dekt de rotationele mitigatie op slot 4).

### Mistweaver

ST-heals (Renewing Mist, Soothing Mist, Enveloping Mist, Vivify) → **mouseover/Click Cast
Bindings**, niet op toetsen (§6 standaard). Onderstaande toetsen zijn offensief/utility,
identiek-in-geest aan een DPS-layout.

| Toets | Ability | ID | Categorie |
|------|---------|----|-----------|
| **1** | Tiger Palm | 100780 🟢 (addon-data: JustAC SpellArchetypes.lua — "Tiger Palm") | Damage/builder |
| **2** | Blackout Kick | 100784 🟢 (addon-data: JustAC SpellArchetypes.lua — "Blackout Kick") | Damage/filler |
| **3** | Rising Sun Kick | 107428 🟢 (addon-data: JustAC SpellArchetypes.lua — "Rising Sun Kick") | Damage |
| **4** | Sheilun's Gift | 399491 🟢 (addon-data: CooldownCompanion Helpers.lua — "Sheilun's Gift cast-count spell") | Raid-heal (talent-pad, Vivify-alternatief) |
| **Shift+1** | Thunder Focus Tea | 116680 🟢 (addon-data: JustAC SpellCategories.lua — "Thunder Focus Tea") | Cooldown/utility (versterkt volgende cast) |
| **Q** | Roll | 109132 🟢 (addon-data: JustAC SpellDB.lua + SpellCategories.lua — "Roll") | Movement |
| **Shift+Q** | Transcendence: Transfer | 119996 🟡 (geen addon-data — geen enkele van de 8 addons bevat 119996; in-game dumpen) | Movement/utility |
| **Z** | Life Cocoon | 116849 🟢 (addon-data: JustAC SpellCategories.lua — "Life Cocoon") | Kleine defensive (extern shield) |
| **C** | Revival | 115310 🟡 (geen addon-data — geen enkele van de 8 addons bevat 115310; in-game dumpen) | Grote cooldown (raid-heal AoE, talent) |
| **V** | Detox | 115450 🟢 (addon-data: JustAC SpellCategories.lua — "Detox (Monk)") | Dispel (magic; poison/disease via talent) |
| **Shift+V** | Ring of Peace | 116844 🟢 (addon-data: JustAC SpellCategories.lua — "Ring of Peace (displacement)") | CC / cast-reset-fallback |
| **F1** | Life Cocoon (zie Z) | — | *(Life Cocoon staat al op Z als kleine/externe defensive — geen dubbele slot)* |
| **F** | Paralysis | 115078 🟢 (addon-data: JustAC InterruptAbilities.lua + SpellCategories.lua — "Paralysis") | CC (niche, ook cast-reset-fallback) |

⚠️ **E (interrupt) is bewust LEEG** — bevestigd: Mistweaver heeft **geen interrupt** in
Midnight (Spear Hand Strike is expliciet verwijderd als Mistweaver-talentoptie, class-breed
designbesluit voor de meeste healers). E blijft utility tot er ooit een interrupt terugkomt
(regel uit standaard §3). Renewing Mist (115151 🟡 [draft-ID niet in addon-data]; JustAC
SpellCategories.lua bevestigt echter **119611** als "Renewing Mist" → 🟢 voor 119611, de alt-ID —
draft-ID 115151 kon niet worden bevestigd, gebruik 119611), Soothing Mist (115175 🟢 [JustAC
SpellCategories.lua — "Soothing Mist"]), Enveloping Mist (124682 🟢 [JustAC SpellCategories.lua —
"Enveloping Mist"]), Vivify (116670 🟢 [JustAC SpellCategories.lua — "Vivify"]) → Click Cast/mouseover,
niet in bovenstaande tabel. Thunder Focus Tea-cooldown is in Midnight verlaagd naar 30s (🟡).

### Windwalker

| Toets | Ability | ID | Categorie |
|------|---------|----|-----------|
| **1** | Tiger Palm | 100780 🟢 (addon-data: JustAC SpellArchetypes.lua — "Tiger Palm") | Builder |
| **2** | Rising Sun Kick | 107428 🟢 (addon-data: JustAC SpellArchetypes.lua — "Rising Sun Kick") | Builder/spender |
| **3** | Spinning Crane Kick | 101546 🟢 (addon-data: JustAC SpellArchetypes.lua — "Spinning Crane Kick") | Builder (AoE-georiënteerd, ook ST-relevant) |
| **4** | Fists of Fury | 113656 🟢 (addon-data: JustAC SpellArchetypes.lua — "Fists of Fury") | Spender/finisher (channeled) |
| **5** | Blackout Kick | 100784 🟢 (addon-data: JustAC SpellArchetypes.lua — "Blackout Kick") | Spender (vaak gratis via Combo Breaker-proc) |
| **Shift+3** | Spinning Crane Kick (AoE-nadruk, zie 3) | — | *(zelfde knop als ST — SCK is van zichzelf al AoE; geen aparte Shift-tweeling nodig)* |
| **E** | Spear Hand Strike | 116705 🟢 (addon-data: JustAC InterruptAbilities.lua — "Spear Hand Strike") | Interrupt |
| **Q** | Roll | 109132 🟢 (addon-data: JustAC SpellDB.lua MONK_3 + SpellCategories.lua — "Roll") | Movement |
| **Shift+Q** | Chi Torpedo | 115008 🟢 (addon-data: JustAC SpellDB.lua MONK_3 gap-closer — "Chi Torpedo") | Movement (talent, vervangt Roll) |
| **Z** | Touch of Karma | 122470 🟢 (addon-data: BliZzi_Interrupts PartyCooldowns.lua — label="Touch of Karma", spec=MONK_WW; JustAC SpellDB.lua MONK_3) | Kleine defensive |
| **Shift+Z** | Diffuse Magic | 122783 🟢 (addon-data: JustAC SpellCategories.lua + SpellDB.lua MONK_3 — "Diffuse Magic") | Defensive (talent) |
| **C** | Fortifying Brew | 201318 🟢 (addon-data: JustAC `MONK_3`/`DEFENSE_TIER` bevestigen 201318 als Windwalker-specifieke variant, i.p.v. de gedeelde 115203) | Grote defensive |
| **V** | Paralysis | 115078 🟢 (addon-data: JustAC InterruptAbilities.lua — "Paralysis") | CC |
| **Shift+V** | Leg Sweep | 119381 🟢 (addon-data: JustAC InterruptAbilities.lua — "Leg Sweep") | CC (AoE stun) |
| **F1** | Invoke Xuen, the White Tiger | 123904 🟢 (addon-data: JustAC SpellDB.lua MONK_3-cooldown — "Invoke Xuen, the White Tiger") | Grote cooldown (Hero Talent: Conduit of the Celestials) |
| **Ctrl+F1** | Zenith | 1249625 🟢 (addon-data: ClassCodex Monk-guide.lua gebruikt `{1249625}` letterlijk in de Windwalker-rotatietekst; CooldownCompanion heeft ook expliciete Zenith/Zenith Stomp-ondersteuning) | Grote cooldown (vervangt Storm, Earth, and Fire) |
| **F** | Flying Serpent Kick | 101545 🟢 (addon-data: JustAC `MONK_3 = {109132, 115008, 101545}` movement-lijst — Flying Serpent Kick nog actief in Midnight) | Movement/utility |

🟢 **Storm, Earth, and Fire is verwijderd in Midnight 12.0.0**, vervangen door **Zenith** —
ID **1249625** bevestigd via ClassCodex's Monk-rotatiegids (letterlijke spell-referentie in de
Windwalker-rotatietekst, meerdere keren). Zenith Stomp (1272696) is een gerelateerd
proc-mechaniek, apart bevestigd via CooldownCompanion's changelog (geen losse knop nodig).
**Invoke Xuen is verplaatst naar Hero Talent "Conduit of the Celestials"** — niet baseline
meer; Shado-Pan-spelers hebben dit niet en missen dus F1 in deze vorm (extra-check bij
in-game bevestiging welke Hero Talent gekozen wordt). 🟢 **Flying Serpent Kick (101545) bestaat
nog** — bevestigd via JustAC's movement-ability-lijst voor Windwalker, dus **niet** vervangen
door Slicing Winds (1217413, dat blijkt een apart Hero Talent-ability te zijn — beide bestaan
naast elkaar volgens ClassCodex's guide.lua, dat Slicing Winds los citeert als
Hero-Talent-pre-cast). F-slot blijft Flying Serpent Kick.

---

## 🐾 Druid

Shapeshift-forms (kort, geen combat-keybind-slot toegewezen — vaak macro'd in de eerste
ability van de vorm): Moonkin Form (Balance) 🟢 **24858** (addon-data: JustAC `SpellCategories.lua`
Druid Forms-lijst bevestigt beide 24858 en 197625 als geldige Moonkin Form-ID's — 197625 is de
Balance-Affinity-variant voor andere specs, 24858 de reguliere; MissingClassBuff gebruikt ook
24858 als de check-ID voor "sta je in Moonkin Form"); Cat Form (Feral) 768 🟢 (addon-data: JustAC
SpellDB.lua Druid-Forms — "Cat Form"); Bear Form (Guardian) 5487 🟢 (addon-data: JustAC SpellDB.lua
Druid-Forms — "Bear Form"). Alleen combat-abilities krijgen hieronder een toets, zoals gevraagd.

### Balance

| Toets | Ability | ID | Categorie |
|------|---------|----|-----------|
| **1** | Wrath | 5176 🟢 (addon-data: JustAC SpellArchetypes.lua — "Wrath") | Builder (Astral Power) |
| **2** | Starfire | 194153 🟢 (addon-data: JustAC SpellArchetypes.lua — "Starfire") | Builder (Arcane, cleave 8yd) |
| **3** | Moonfire | 8921 🟢 (addon-data: JustAC SpellArchetypes.lua — "Moonfire") | Builder/DoT |
| **4** | Starsurge | 78674 🟢 (addon-data: JustAC SpellArchetypes.lua — "Starsurge") | Spender |
| **5** | Sunfire | 93402 🟢 (addon-data: JustAC SpellArchetypes.lua — "Sunfire") | Builder/DoT (AoE bij cast) |
| **Shift+4** | Starfall | 191034 🟢 (addon-data: JustAC SpellArchetypes.lua — "Starfall") | AoE spender |
| **E** | Solar Beam | 78675 🟢 (addon-data: JustAC InterruptAbilities.lua + SpellCategories.lua — "Solar Beam", kind="interrupt") | Interrupt (AoE silence) |
| **Q** | Wild Charge | 102401 🟢 (addon-data: JustAC SpellCategories.lua + SpellDB.lua — "Wild Charge") | Movement |
| **Shift+Q** | Tiger Dash | 252216 🟢 (addon-data: JustAC SpellCategories.lua — "Tiger Dash (Druid)") | Movement (talent, Cat Form) |
| **Z** | Barkskin | 22812 🟢 (addon-data: JustAC SpellCategories.lua + BliZzi_Interrupts PartyCooldowns.lua — "Barkskin") | Kleine defensive (-20% dmg, alle vormen) |
| **C** | Renewal | 108238 🟢 (addon-data: JustAC `DEFENSE_TIER` — "Renewal (Druid, 30%)" — en ExwindCore/LibOpenRaid Midnight-bestand, specs={102,103,104,105}, cd 90s) | Grote defensive (instant heal 30%) |
| **V** | Typhoon | 132469 🟢 (addon-data: JustAC SpellCategories.lua — "Typhoon (knockback+daze)") | CC (frontal knockback+daze) |
| **Shift+V** | Mighty Bash | 166972 ⚠️ (draft-ID 166972 door geen addon bevestigd; JustAC SpellCategories.lua + InterruptAbilities.lua + Interrupt_CCAndCD_Tracker hebben alle drie **5211** voor "Mighty Bash" — draft-ID vermoedelijk fout, gebruik 5211) | CC (stun) |
| **F1** | Celestial Alignment | 194223 🟢 (addon-data: BliZzi_Interrupts PartyCooldowns.lua — label="Celestial Alignment", spec=DRUID_BAL; JustAC SpellDB.lua DRUID_1. Kanttekening: BliZzi noemt alt-ID 383410) | Grote cooldown (beide Eclipses, 15s) |
| **Shift+F1** | Incarnation: Chosen of Elune | 102560 🟢 (addon-data: BliZzi_Interrupts PartyCooldowns.lua + OffensiveCDAlert.lua — "Incarnation: Chosen of Elune"; JustAC SpellDB.lua DRUID_1) | Grote cooldown (talent-alternatief; 1 van beide, niet beide tegelijk actief) |

🟢 **Renewal = 108238** bevestigd via addon-data (JustAC DEFENSE_TIER + ExwindCore Midnight-
bestand). **Let op nuance:** JustAC's `SpellDB.lua` (regel 643, `DRUID_3` fallback-lijst) heeft
een expliciete comment "Renewal removed in 12.0" voor **Guardian**, terwijl ExwindCore's
Midnight-bestand het juist listet voor alle 4 Druid-specs (102/103/104/105). Voor **Balance**
(deze tabel) is 108238 dus zeer waarschijnlijk correct; in-game bevestigen blijft aan te raden
gezien de tegenstrijdigheid tussen bronnen over Guardian-beschikbaarheid. Eclipse-mechaniek zelf
is passief (geen knop). Displacer Beast bestaat niet meer sinds patch 8.0.1 — niet opgenomen.

### Feral

| Toets | Ability | ID | Categorie |
|------|---------|----|-----------|
| **1** | Shred | 5221 🟢 (addon-data: JustAC SpellArchetypes.lua — "Shred") | Builder (Cat Form) |
| **2** | Rake | 1822 🟢 (addon-data: JustAC SpellArchetypes.lua — "Rake") | Builder/DoT |
| **3** | Thrash | 77758 🟢 (addon-data: JustAC SpellArchetypes.lua — "Thrash") | Builder/DoT (AoE-georiënteerd) |
| **4** | Rip | 1079 🟢 (addon-data: JustAC SpellArchetypes.lua — "Rip") | Spender/finisher (bleed) |
| **5** | Ferocious Bite | 22568 🟢 (addon-data: JustAC SpellArchetypes.lua — "Ferocious Bite") | Spender/finisher (physical) |
| **Shift+3** | Thrash (AoE-nadruk, zie 3) | — | *(Thrash is van zichzelf al AoE-DoT — geen aparte Shift-tweeling)* |
| **E** | Skull Bash | 106839 🟢 (addon-data: JustAC InterruptAbilities.lua — "Skull Bash", kind="interrupt"; ook Interrupt_CCAndCD_Tracker) | Interrupt (charge + interrupt) |
| **Q** | Wild Charge | 102401 🟢 (addon-data: JustAC SpellCategories.lua + SpellDB.lua DRUID_2 — "Wild Charge") | Movement |
| **Shift+Q** | Stampeding Roar | 106898 🟡 (geen addon-data — geen enkele van de 8 addons bevat 106898; in-game dumpen) | Movement/raid-utility (+speed) |
| **Z** | Barkskin | 22812 🟢 (addon-data: JustAC SpellCategories.lua + BliZzi_Interrupts — "Barkskin") | Kleine defensive |
| **C** | Survival Instincts | 61336 🟢 (addon-data: JustAC SpellCategories.lua — "Survival Instincts") | Grote defensive (-50% dmg, 6s) |
| **V** | Maim | 22570 🟢 (addon-data: JustAC SpellArchetypes.lua — "Maim") | CC (Cat Form stun, schaalt met CP) |
| **F1** | Berserk | 106951 🟢 (addon-data: BliZzi_Interrupts labelt dit expliciet "Berserk (Feral)"; ExwindCore/LibOpenRaid Midnight-bestand specs={103,104}=Feral+Guardian; JustAC `DRUID_2 = {106951, 102543}`. **Draft-ID 343223 wordt door geen enkele addon bevestigd — waarschijnlijk fout.**) | Grote cooldown (baseline) |
| **Shift+F1** | Incarnation: Avatar of Ashamane | 102543 🟢 (addon-data: BliZzi_Interrupts PartyCooldowns.lua + OffensiveCDAlert.lua — "Incarnation: Avatar of Ashamane", spec=DRUID_FERAL; JustAC SpellDB.lua DRUID_2) | Grote cooldown (talent-alternatief voor Berserk) |
| **F** | Rebirth | 20484 🟢 (addon-data: JustAC SpellCategories.lua — "Rebirth (Druid)") | Utility (battle-res, class-gedeeld) |

🟢 **Skull Bash = 106839** bevestigd als interrupt via JustAC's `InterruptAbilities.lua`
(kind="interrupt", pri=1, samen met Solar Beam als CC-vangnet) — mag van 🟡 naar 🟢. Wees nog
steeds alert op de historische ID's in oudere patches (Classic 410176, Cata Classic 80965),
maar voor Midnight/12.0.x is 106839 nu addon-bevestigd. Savage Roar bestaat niet meer sinds
Dragonflight — niet opgenomen. **Berserk-ID gecorrigeerd:** was 343223 in het oorspronkelijke
draft (web-bron), addon-data wijst overtuigend naar **106951** (zie tabel).

### Guardian

| Toets | Ability | ID | Categorie |
|------|---------|----|-----------|
| **1** | Mangle | 33917 🟢 (addon-data: JustAC SpellArchetypes.lua — "Mangle") | Builder (primaire Rage-generator) |
| **2** | Thrash | 77758 🟢 (addon-data: JustAC SpellArchetypes.lua — "Thrash"; zelfde basisspell als Feral) | Builder/AoE (bleed, Rage-generatie) |
| **3** | Moonfire | 8921 🟢 (addon-data: JustAC SpellArchetypes.lua — "Moonfire") | Builder/filler (indien getalenteerd voor Guardian) |
| **4** | Ironfur | 192081 🟢 (addon-data: JustAC SpellCategories.lua + SpellDB.lua DRUID_3 — "Ironfur") | Spender (mitigation, stackable) |
| **5** | Frenzied Regeneration | 22842 🟢 (addon-data: JustAC SpellCategories.lua + SpellDB.lua DRUID_3 — "Frenzied Regeneration") | Spender (self-heal) |
| **E** | Skull Bash | 106839 🟢 (addon-data: JustAC `InterruptAbilities.lua`, kind="interrupt") | Interrupt |
| **Q** | Wild Charge | 102401 🟢 (addon-data: JustAC SpellCategories.lua + SpellDB.lua DRUID_3 — "Wild Charge") | Movement |
| **Shift+Q** | Stampeding Roar | 106898 🟡 (geen addon-data — geen enkele van de 8 addons bevat 106898; in-game dumpen) | Movement/raid-utility |
| **Z** | Barkskin | 22812 🟢 (addon-data: JustAC SpellCategories.lua + BliZzi_Interrupts — "Barkskin") | Kleine defensive |
| **C** | Survival Instincts | 61336 🟢 (addon-data: JustAC SpellCategories.lua — "Survival Instincts") | Grote defensive |
| **V** | Mighty Bash | 166972 ⚠️ (draft-ID 166972 door geen addon bevestigd; JustAC SpellCategories.lua + InterruptAbilities.lua + Interrupt_CCAndCD_Tracker hebben alle drie **5211** voor "Mighty Bash" — draft-ID vermoedelijk fout, gebruik 5211) | CC (stun) |
| **Shift+V** | Incapacitating Roar | 99 🟢 (addon-data: JustAC `InterruptAbilities.lua` kind="cc" mech=14 pbaoe radius=10; ExwindCore Midnight-bestand specs={102,103,104,105} cd 30s) | CC (AoE disorient) |
| **F1** | Incarnation: Guardian of Ursoc | 102558 🟢 (addon-data: BliZzi_Interrupts PartyCooldowns.lua — label="Incarnation: Guardian of Ursoc", spec=DRUID_GUARDIAN; JustAC SpellDB.lua DRUID_3) | Grote cooldown |
| **Shift+F1** | Berserk: Ravage | 343240 ⚠️ (geen enkele addon bevestigt dit ID — zie kanttekening onder; overweeg of dit talent-label uberhaupt correct is) | Grote cooldown (Druid of the Claw hero-tree, talent-alternatief) |
| **F** | Growl | 6795 🟢 (addon-data: JustAC SpellCategories.lua — "Growl (Druid)") | Utility (taunt) |
| **R** | Rebirth | 20484 🟢 (addon-data: JustAC SpellCategories.lua — "Rebirth (Druid)") | Utility (battle-res, class-gedeeld) |

⚠️ **CORRECTIE Guardian-Berserk-ID (addon-data 2026-07-02):** het oorspronkelijke draft-vermoeden
dat Guardian **dezelfde** Berserk-ID 106951 als Feral deelt, is door addon-data **weerlegd**.
BliZzi_Interrupts `PartyCooldowns.lua` heeft twee **aparte** entries: `spellId = 106951, label =
"Berserk (Feral)", spec = DRUID_FERAL` én `spellId = 50334, label = "Berserk (Guardian)", spec =
DRUID_GUARDIAN`. JustAC `SpellDB.lua` bevestigt dit: `DRUID_2 = {106951, 102543}` (Feral) vs
`DRUID_3 = {50334, 102558}` (Guardian). BliZzi_Interrupts `OffensiveCDAlert.lua` listet `[50334] =
"Berserk", class = "DRUID"`. **Guardian baseline-Berserk = 50334 🟢 (NIET 106951)** — dit is een
apart Guardian-only ID, geen gedeelde class-tree-spell. **Let op:** deze Guardian-tabel gebruikt F1
voor "Incarnation: Guardian of Ursoc" (102558) als hoofdcooldown i.p.v. baseline Berserk — controleer
in-game of Berserk (50334) als los overflow-slot nodig is naast Incarnation. Berserk: Ravage (343240)
kon door geen enkele doorzochte addon bevestigd worden — blijft ⚠️.
**Gedeeld met Feral (bevestigd via bronnen):** Skull Bash (interrupt), Wild Charge, Stampeding
Roar, Barkskin, Mighty Bash, Rebirth — Feral en Guardian draaien beide op de
Cat Form/Bear Form-conventie en delen deze class-tree-toetsen; alleen de vorm-specifieke
builders/spenders (Shred/Rake/Rip/Ferocious Bite vs. Mangle/Ironfur/Frenzied Regeneration)
verschillen. Via het "Fluid Form"-talent kunnen beide specs ook elkaars vorm-abilities
gebruiken, maar dat is een talent-keuze, geen baseline-keybind-verschil.

### Restoration

ST-heals (Regrowth, Rejuvenation, Lifebloom) → **mouseover/Click Cast Bindings**, niet op
toetsen (§6 standaard).

| Toets | Ability | ID | Categorie |
|------|---------|----|-----------|
| **1** | Wrath | 5176 🟢 (addon-data: JustAC SpellArchetypes.lua — "Wrath") | Damage (filler) |
| **2** | Moonfire | 8921 🟢 (addon-data: JustAC SpellArchetypes.lua — "Moonfire") | Damage/DoT |
| **3** | Sunfire | 93402 🟢 (addon-data: JustAC SpellArchetypes.lua — "Sunfire") | Damage/DoT (AoE) |
| **4** | Swiftmend | 18562 🟢 (addon-data: JustAC SpellCategories.lua — "Swiftmend") | Spender/instant heal (consumeert HoT) |
| **5** | Wild Growth | 48438 🟢 (addon-data: JustAC SpellCategories.lua — "Wild Growth") | Raid-heal (tot 5-6 doelen) |
| **Shift+5** | Wild Growth (AoE, zie 5) | — | *(Wild Growth is al AoE — geen aparte Shift-tweeling nodig)* |
| **Q** | Wild Charge | 102401 🟢 (addon-data: JustAC SpellCategories.lua — "Wild Charge") | Movement |
| **Z** | Ironbark | 102342 🟢 (addon-data: JustAC SpellCategories.lua — "Ironbark") | Kleine defensive (extern, -20% dmg) |
| **C** | Tranquility | 740 🟢 (addon-data: JustAC SpellCategories.lua — "Tranquility") | Grote cooldown (raid-heal AoE, channeled) |
| **V** | Nature's Cure | 88423 🟢 (addon-data: JustAC SpellCategories.lua — "Nature's Cure (Druid)") | Dispel |
| **Shift+V** | Mass Entanglement | 102359 🟢 (addon-data: JustAC SpellArchetypes.lua — "Mass Entanglement") | CC (root) |
| **F1** | Flourish | 184879 🟡 (geen addon-data — geen enkele van de 8 addons bevat 184879; in-game dumpen) | Grote cooldown (verlengt HoTs +10s) |
| **F** | Typhoon | 132469 🟢 (addon-data: JustAC SpellCategories.lua — "Typhoon (knockback+daze)") | CC (frontal knockback+daze) |

⚠️ **E (interrupt) is bewust LEEG** — Restoration Druid heeft **geen baseline interrupt**;
Skull Bash is enkel bereikbaar via een **optionele class-talent-keuze** (gedeeld met
Feral/Guardian), niet standaard voor Resto. Als Rob/Cisca deze talent-node kiezen: Skull Bash
106839 🟢 (addon-bevestigd interrupt-ID, zie Feral/Guardian) op E. 🟢 **Innervate = 29166**
decisief bevestigd via addon-data: ExwindCore/LibOpenRaid Midnight-bestand (specs={102,105}=
Balance+Restoration, cd 180s, dur 12s), JustAC `SpellCategories.lua`, en drie onafhankelijke
macro/tracking-addons (OPie, EllesmereUI, ZugZug) gebruiken allemaal 29166. Het alternatieve
173565 komt in **geen enkele** doorzochte addon voor. **Toegewezen aan R** (extra utility-slot,
zoals het draft voorstelde). Regrowth (8936 🟢 [JustAC SpellCategories.lua — "Regrowth"; ook
SpellDB.lua DRUID_2]), Rejuvenation (774 🟢 [JustAC SpellCategories.lua — "Rejuvenation"]),
Lifebloom (33763 🟢 [JustAC SpellCategories.lua — "Lifebloom"]) →
Click Cast/mouseover, niet in bovenstaande tabel.

---

## Samenvatting open punten (⚠️ / extra-check, never-lie)

- **Rogue – Outlaw:** Preparation-ID (1277933) — ClassCodex guide.lua gebruikt dit ID **wél**
  positioneel in de Outlaw-rotatie, maar zonder naam-label; naam "Preparation" blijft dus ⚠️
  (onbevestigd), in-game tooltip-check.
- **Rogue – Subtlety:** Mark for Death (1293340) → géén addon-data (🟡, in-game dumpen).
- **Rogue – Outlaw:** Blade Flurry (13877) → géén addon-data (🟡, in-game dumpen).
- **Rogue – 🟡-restanten zonder naam-label:** Roll the Bones (315508), Keep It Rolling (381989),
  Shadow Dance (185313), Coup de Grace (441423), Implacable (1265385) — komen alleen positioneel
  (zonder naam-label) in ClassCodex guide.lua voor, ID-naam-koppeling dus niet addon-bevestigd.
- **Monk – Brewmaster:** Fortifying Brew (115203 basis / 120954 BM-aura) al 🟢 (bevestigd door
  BliZzi cast=115203 → aura=120954).
- **Monk – Mistweaver:** Transcendence: Transfer (119996) en Revival (115310) → géén addon-data
  (🟡, in-game dumpen). Renewing Mist: draft-ID 115151 niet bevestigd; JustAC heeft 119611 →
  gebruik **119611** voor Renewing Mist.
- **Druid – Balance & Guardian:** **Mighty Bash draft-ID 166972 is vermoedelijk FOUT** — 3 addons
  (JustAC SpellCategories + InterruptAbilities, Interrupt_CCAndCD_Tracker) hebben **5211** voor
  "Mighty Bash". ⚠️, gebruik 5211.
- **Druid – Guardian:** **Baseline-Berserk = 50334 🟢 (NIET 106951)** — BliZzi + JustAC geven een
  apart Guardian-only Berserk-ID (50334), los van Feral's 106951; oude draft-aanname weerlegd.
  Berserk: Ravage (343240) → géén addon-data, blijft ⚠️.
- **Druid – Feral:** Stampeding Roar (106898) → géén addon-data (🟡). Skull Bash 106839 nu 🟢
  (InterruptAbilities + Interrupt_CCAndCD_Tracker).
- **Druid – Restoration:** Innervate-ID tegenstrijdig (29166 🟢 addon-bevestigd vs 173565 nergens);
  Flourish (184879) → géén addon-data (🟡, in-game dumpen).

**Geen enkel ID in dit document is ✅.** Alles moet nog in-game gedumpt/bevestigd worden door
Rob/Cisca voordat het naar `Modules/KeybindingData.lua` gaat (never-lie, zie standaard §0/inleiding).

---

## Bronnen (research, juli 2026)

- Wowhead rotation guides: [Assassination](https://www.wowhead.com/guide/classes/rogue/assassination/rotation-cooldowns-pve-dps) · [Outlaw](https://www.wowhead.com/guide/classes/rogue/outlaw/rotation-cooldowns-pve-dps) · [Subtlety](https://www.wowhead.com/guide/classes/rogue/subtlety/rotation-cooldowns-pve-dps)
- Icy Veins (12.0.7): [Assassination](https://www.icy-veins.com/wow/assassination-rogue-pve-dps-rotation-cooldowns-abilities) · [Outlaw](https://www.icy-veins.com/wow/outlaw-rogue-pve-dps-rotation-cooldowns-abilities) · [Subtlety](https://www.icy-veins.com/wow/subtlety-rogue-pve-dps-rotation-cooldowns-abilities)
- Method.gg: [Outlaw](https://www.method.gg/guides/outlaw-rogue/playstyle-and-rotation) · [Subtlety](https://www.method.gg/guides/subtlety-rogue/playstyle-and-rotation)
- Blizzard: [Developer Insight — Combat for Everyone in Midnight](https://news.blizzard.com/en-us/article/24235745/developer-insight-combat-for-everyone-in-midnight) · [Midnight goes live](https://news.blizzard.com/en-us/article/24243639/world-of-warcraft-midnight-goes-live-march-2)
- Wowhead Monk-guides: [Brewmaster](https://www.wowhead.com/guide/classes/monk/brewmaster/abilities-talents-pve-tank) · [Mistweaver](https://www.wowhead.com/guide/classes/monk/mistweaver/talent-builds-pve-healer) · [Windwalker](https://www.wowhead.com/guide/classes/monk/windwalker/abilities-talents-pve-dps) · [Apex Talents overzicht](https://www.wowhead.com/guide/midnight/apex-talents-overview)
- Wowhead nieuws: [Stagger control / fewer cooldowns first impression](https://www.wowhead.com/news/stagger-control-without-addons-and-fewer-cooldowns-first-impression-of-midnight-378902) · [Windwalker pruning first impression](https://www.wowhead.com/news/pruning-of-excess-or-excess-of-pruning-first-impression-of-midnight-windwalker-378964) · [Phase Four alpha dev notes](https://www.wowhead.com/news/phase-four-midnight-alpha-development-notes-voidstorm-tier-and-more-378986)
- Icy Veins Monk: [Brewmaster](https://www.icy-veins.com/wow/brewmaster-monk-midnight-guide) · [Mistweaver](https://www.icy-veins.com/wow/mistweaver-monk-pve-healing-spec-builds-talents) · [Windwalker](https://www.icy-veins.com/wow/windwalker-monk-pve-dps-spec-builds-talents)
- Method.gg Monk: [Mistweaver](https://www.method.gg/guides/mistweaver-monk) · [Windwalker](https://www.method.gg/guides/windwalker-monk) · [Brewmaster](https://www.method.gg/guides/brewmaster-monk)
- Blizzard forums: [No more healer interrupts](https://us.forums.blizzard.com/en/wow/t/no-more-healer-interrupts-thank-god/2189080) · [SEF gone, replaced by Weapons of Order (naam-verwarring, zie Zenith)](https://us.forums.blizzard.com/en/wow/t/sef-gone-replaced-by-weapons-of-order/2176006)
- Icy Veins Druid: [Balance spec](https://www.icy-veins.com/wow/balance-druid-pve-dps-spec-builds-talents) · [Balance glossary](https://www.icy-veins.com/wow/balance-druid-pve-dps-spell-summary) · [Feral spec](https://www.icy-veins.com/wow/feral-druid-pve-dps-spec-builds-talents) · [Feral glossary](https://www.icy-veins.com/wow/feral-druid-pve-dps-spell-summary) · [Guardian guide](https://www.icy-veins.com/wow/guardian-druid-pve-tank-guide) · [Guardian glossary](https://www.icy-veins.com/wow/guardian-druid-pve-tank-spell-summary) · [Restoration spec](https://www.icy-veins.com/wow/restoration-druid-pve-healing-spec-builds-talents) · [Restoration glossary](https://www.icy-veins.com/wow/restoration-druid-pve-healing-spell-summary)
- Wowhead Balance rotation: [Balance](https://www.wowhead.com/guide/classes/druid/balance/rotation-cooldowns-pve-dps)
- Wowhead spell-database (individuele lookups, zie ID's per tabel hierboven) — o.a. [Skull Bash](https://www.wowhead.com/spell=106839/skull-bash), [Sunfire](https://www.wowhead.com/spell=93402/sunfire)
- Boostmatch: [Midnight 12.0.5 Class Balance Guide](https://boostmatch.gg/blog/wow/articles/wow-midnight-12-0-5-class-balance-guide)
- Wowhead nieuws: [Midnight 12.0.5 PTR Class And Spell Tuning Changes](https://www.wowhead.com/news/midnight-patch-12-0-5-ptr-class-and-spell-tuning-changes-380765)

## Volgende stap

In-game dumpen/tooltip-check van alle 🟡- en vooral ⚠️-ID's door Rob/Cisca (never-lie, zie
standaard). Daarna pas encoderen in `Modules/KeybindingData.lua` — dat datamodel is nu
Hunter/Paladin/Mage/Shaman-specifiek; check of het generiek genoeg is voor 10 extra specs of
dat een kleine generalisatie nodig is (zelfde open vraag als bij het Mage/Shaman-doc).
