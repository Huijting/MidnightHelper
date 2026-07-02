# Midnight Helper — Keybind Standard v6 (universele role→key)

**Doel:** één consistente toetsindeling die **elke class/spec** volgt, zodat een ability van
dezelfde *soort* altijd op dezelfde fysieke toets zit (muscle memory verplaatst tussen
alts/specs). Bouwt voort op schema v5, web-geverifieerd tegen best-practice (bronnen onder).
Dit is de **authoring-gids** voor het invullen van `Modules/KeybindingData.lua` en het
tekenen van de "layout"-subtab.

> **Never-lie:** spell-*ID's* per spec worden bij het invullen web-opgezocht **en door Rob/
> Cisca in-game bevestigd**. Deze standaard gaat over de *toetsen en categorieën*, niet over
> verzonnen ID's.

---

## 1. Beslissingen (t.o.v. v5)

| # | v5 | **v6 (dit doc)** | Waarom |
|---|-----|------------------|--------|
| Overflow-volgorde | Alt → Shift → Ctrl | **Shift → Ctrl → Alt** | Shift is de beste 1e modifier (duim); **Alt = WoW self-cast** → conflictrisico, dus laatst/spaarzaam. |
| Movement | "utility op Q" | **Q = movement** | Movement is reflex → verdient een green-zone-toets. |
| AoE | los toegewezen | **AoE = Shift-tweeling** van de ST-knop (1→Shift+1) | ST/AoE-toggle overal identiek. |
| Interrupt | E (anker) | **E (anker)** — behouden | Bereikbaar, zelfde vinger elke spec. |
| G | niet gebruiken | **niet gebruiken** — behouden | Te grote reach. |
| Heals (upd. 2026-07-02) | F2–F4 = utility-overflow | **F2=combat-heal, F3=OOC-heal, F4=recuperate/HoT** | Zelfde heal-reflex op elke alt (Rob). |
| Utility-volgorde (upd. 2026-07-02) | F R T X | **F R X T** | X ligt bij het Z/C/V-cluster (vinger krullen); T is een stretch rechtsboven → X eerst (Rob). |

---

## 2. Bereikbaarheid (research)

- **Green (makkelijk, geen hand van WASD):** `1 2 3`, `Q E R F`, `muis4/muis5`, en `Shift+`die.
  → rotatie-kern, interrupt, primaire defensive, movement.
- **Yellow (lichte reach):** `4 5`, `T G* C V X Z`, `Tab`. → AoE, secundaire defensives, utility.
  (*G blijft ongebruikt per teamregel.*)
- **Vermijden voor combat:** `6 7 8 9 0 - =` en diepe combo's (bv. Ctrl+7). Alleen voor
  out-of-combat (mount/prof/consumable die je vooraf cast).
- **Muis:** duimknoppen (4/5) = trinket + movement/blink. **Mouseover-macro's** voor
  interrupt/dispel/off-heal. **Healers:** single-target heals via **native Click Cast
  Bindings** (Midnight heeft dit ingebouwd) / mouseover — zodat 1/2/4/E identiek blijven aan DPS.
- Richtlijn: ~**18–25 combat-binds** per spec is genoeg; Midnight verlaagt bewust het aantal
  knoppen, dus provisie niet te veel modifier-lagen.

---

## 3. Ankers (verplaatsen NOOIT — over alle specs gelijk)

| Toets | Rol |
|------|-----|
| **E** | Interrupt (kick). Geen interrupt? → E blijft utility tot er een komt. |
| **Q** | Movement (dash/blink/roll/leap). |
| **Z** | Kleine/rotationele defensive. |
| **C** | Grote/panic defensive. |
| **V** | Dispel / CC. |
| **F1** | Grote offensieve/heal-cooldown (burst). |
| **F2** | Snelle self-heal **ín combat** (voor specs die er een hebben — bv. Healing Surge, Exhilaration). |
| **F3** | Heal/regen **out-of-combat**. |
| **F4** | "Recuperate"-achtig: doorlopende self-heal / HoT (bv. Crimson Vial). |
| **Shift+E** | Racial. |
| **Ctrl+F1** | Trinket (of macro op een cooldown). |
| **Alt+C** | Combat-potion. |

Ankers zijn "panic-pressable" zonder na te denken — daarom staan defensives/interrupt op
losse toetsen, nooit weggestopt achter een modifier.

## 4. Categorie → slots (de rest, met overflow)

Volgorde van vullen per categorie; loopt een groep vol → **zelfde toets + volgende modifier
(Shift → Ctrl → Alt)**.

| Categorie | Basis-slots (in volgorde) |
|-----------|---------------------------|
| Builder (ST-rotatie) | `1`, `2`, `3` |
| Spender | `4`, `5` |
| AoE | **Shift-tweeling** van de bijbehorende ST-knop (builder 1 → `Shift+1`, spender 4 → `Shift+4`) |
| Utility | `F`, `R`, `X`, `T` (X vóór T — makkelijker reach vanaf WASD; upd. 2026-07-02. F2–F4 = heal-ankers, zie §3) |
| Major cooldown (extra naast F1) | `Shift+F1`, `Ctrl+F1`… |
| Defensive (extra naast Z/C) | `Shift+Z`, `Shift+C`… |

> **Anker-pass eerst:** wijs eerst alle ankers toe (§3), dán de categorie-slots, dán overflow.
> Zo krijgen twee mensen die dezelfde spec invullen **exact dezelfde** binds (deterministisch).

---

## 5. Invul-algoritme (mechanisch, per spec)

Input per spec: een lijst spells, elk met `{ id, category, priority }` (priority = hoe vaak/
belangrijk; lager = eerder een betere toets). Dan:

1. **Anker-pass:** interrupt→E, movement→Q, minor-def→Z, major-def→C, dispel/CC→V,
   grootste CD→F1, combat-heal→F2, OOC-heal→F3, recuperate/HoT→F4, racial→Shift+E,
   trinket→Ctrl+F1, potion→Alt+C.
2. **Categorie-pass:** vul builders/spenders/utility op hun basis-slots (§4) op priority-volgorde.
3. **AoE-pass:** elke AoE-ability = Shift-tweeling van z'n ST-tegenhanger.
4. **Overflow:** groep vol → zelfde fysieke toets, volgende modifier (Shift→Ctrl→Alt).
5. **Rest (out-of-combat):** professions/mount/consumables → 6-0 of far keys (buiten green/yellow).

Deterministisch: geen keuze per spec → consistent + reproduceerbaar. Encodeer als één globale
template + per-spec spell-lijst; de allocator (`ns.Keybind_AllocateSpells`, schema-code) doet de rest.

---

## 6. Healer-overlay

- **Offensieve/utility-toetsen identiek aan DPS** (1/2/4, E, Q, Z, C, F1…): zo blijft je
  "damage/interrupt/defensive"-reflex gelijk of je nu heelt of dps't.
- **Single-target heals** → **niet** op de rotatie-toetsen, maar op **Click Cast Bindings /
  mouseover** over de raidframes (Midnight-native; geen extern addon nodig).
- Raid/AoE-heals + heal-cooldowns → F1-cluster + Shift-laag, net als DPS-cooldowns.

---

## 7. Uitgewerkte voorbeelden (illustratief; ID's bij invullen bevestigen)

**Melee-builder/spender (bv. Ret-achtig):** builder→1/2/3, spender→4, AoE→Shift+1/Shift+4,
interrupt→E, movement→Q (of muis), minor-def→Z, major-def→C, bubble/immunity→Shift+C,
burst→F1, racial→Shift+E, trinket→Ctrl+F1.

**Caster (bv. Fire-achtig):** builder→1/2, spender→3, AoE→Shift+1.., interrupt→E,
blink→Q, barrier→Z, major-def→C, block/immunity→Shift+C, combust→F1, movement-utility→F/R.

**Healer (bv. Resto-achtig):** ST-heals→Click-Cast/mouseover; raid-heal→1/2; damage→3/4;
interrupt→E; movement→Q; personal-def→Z; major-def→C; dispel→V; heal-CD→F1/Shift+F1.

---

## 8. Implementatie-aanpak (voorstel)

1. Dit doc = de standaard. (nu)
2. Code: schema-regels naar v6 (overflow Shift→Ctrl→Alt, Q=movement-anker, AoE-tweeling,
   anker-pass) in `Modules/KeybindSchema.lua`; Hunter/Paladin-data hertoetsen aan v6.
3. **Incrementeel per class vullen** (spell-lijst met category+priority), **jouw + Cisca's
   classes eerst**, elk web-opgezocht + door jullie in-game bevestigd (never-lie).
4. De "layout"-subtab tekent de ingevulde spec automatisch (highlight de gebruikte toetsen).

---

## Bronnen (research)
- Skill-Capped — WoW PvP Keybindings Guide, Midnight S1: https://www.skill-capped.com/wowarticles/general/keybindings-guide/
- Icy Veins — Keybind Tips (modifiers, muis, defensives): https://www.icy-veins.com/forums/topic/498-keybind-tips/
- Icy Veins — mouseover-macro's: https://www.icy-veins.com/forums/topic/4546-basic-mouseover-macro-guide-with-modifiers/
- Turtle Beach (Blizzard dev blog) — Midnight vermindert button-bloat (40 specs): https://www.turtlebeach.com/blog/world-of-warcraft-midnight-aiming-to-reduce-button-bloat-for-all-40-specs
- Blizzard forums — native Click Cast Bindings / addon-disruptie in Midnight: https://us.forums.blizzard.com/en/wow/t/healing-vuhdo-midnight/2235209
- MMO-Champion — Alt self-cast conflict: https://www.mmo-champion.com/threads/2549650
- Wow-Pro — Skumball's Keybinding Guide (green/yellow reach): https://www.wow-pro.com/skumballs-keybinding-guide/
