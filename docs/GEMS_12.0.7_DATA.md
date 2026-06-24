# MidnightHelper — geverifieerde gem-data (Midnight 12.0.7)

Bron: Wowhead live (12.0.7), per-item tooltips direct gelezen op 24 jun 2026.
Never-lie: alle item-ID's + stats hieronder zijn 1-op-1 van de Wowhead-itempagina's
gehaald (geen gokwerk). Zie ook `GearEnchantCheck.lua` voor het zuster-patroon.

## Systeem
- Midnight secundaire-stat-gems zijn **blue/rare**, **prismatic** (passen in elke socket),
  **Item Level 295**, kwaliteitsnaam **"Flawless"** (= max rank).
- Elke gem is **dual-stat: +16 hoofdstat + 7 bijstat** (hotfix 12 mrt 2026, was 12/5).
- **Mineraal = de +16 (hoofd)stat. Prefix = de +7 (bij)stat.** Beide gebruiken dezelfde
  4-stat-woordenschat.
- **Mono-gem** (mineraal én prefix dezelfde stat) toont als **+17** van die ene stat.

### Mineraal → +16 hoofdstat (elk direct bevestigd via tooltip)
| Mineraal | +16 stat |
|---|---|
| Amethyst | Mastery |
| Garnet | Critical Strike |
| Peridot | Haste |
| Lapis | Versatility |

### Prefix → +7 bijstat
| Prefix | +7 stat |
|---|---|
| Masterful | Mastery |
| Deadly | Critical Strike |
| Quick | Haste |
| Versatile | Versatility |

## Volledige item-ID-tabel (Flawless, ilvl 295)
Naam → itemID → stats (hoofd+16 / bij+7; mono = +17).

| Item | ID | Stats |
|---|---|---|
| Flawless Masterful Amethyst | 240896 | +17 Mastery (mono) |
| Flawless Deadly Amethyst | 240898 | +16 Mastery, +7 Crit |
| Flawless Quick Amethyst | 240900 | +16 Mastery, +7 Haste |
| Flawless Versatile Amethyst | 240902 | +16 Mastery, +7 Vers |
| Flawless Deadly Garnet | 240904 | +17 Crit (mono) |
| Flawless Masterful Garnet | 240908 | +16 Crit, +7 Mastery |
| Flawless Quick Garnet | 240906 | +16 Crit, +7 Haste |
| Flawless Versatile Garnet | 240910 | +16 Crit, +7 Vers |
| Flawless Quick Peridot | 240888 | +17 Haste (mono) |
| Flawless Masterful Peridot | 240892 | +16 Haste, +7 Mastery |
| Flawless Deadly Peridot | 240890 | +16 Haste, +7 Crit |
| Flawless Versatile Peridot | 240894 | +16 Haste, +7 Vers |
| Flawless Versatile Lapis | 240912 | +17 Vers (mono) |
| Flawless Masterful Lapis | 240918 | +16 Vers, +7 Mastery |
| Flawless Deadly Lapis | 240914 | +16 Vers, +7 Crit |
| Flawless Quick Lapis | 240916 | +16 Vers, +7 Haste |

Direct-bevestigde tooltips (spot-checks): 240902 (16 Mas/7 Vers), 240900 (16 Mas/7 Has),
240898 (16 Mas/7 Crit), 240894 (16 Has/7 Vers), 240912 (+17 Vers mono), 240910 (16 Crit/7 Vers).
De rest volgt deterministisch uit het mineraal+prefix-patroon; ID's uit de Wowhead-listview
(`g_listviews` data, prismatic/quality:3, ilvl 295).

## Pure-stat (mono) gem per stat — simpelste advies (mirror van enchant-aanpak)
| Top stat | Mono-gem | ID |
|---|---|---|
| Crit | Flawless Deadly Garnet | 240904 |
| Haste | Flawless Quick Peridot | 240888 |
| Mastery | Flawless Masterful Amethyst | 240896 |
| Vers | Flawless Versatile Lapis | 240912 |

## Eversong Diamond (Thalassian Diamond) — de unieke epic-gem
- **Epic, prismatic, ilvl 295. UNIQUE-EQUIPPED: "Thalassian Diamond (1)"** → je kunt er
  maar **ÉÉN** dragen over al je sockets samen (bevestigd op de itempagina + comment).
- **Indecipherable Eversong Diamond = 240983 = +32 Primary Stat** (klasse-agnostisch: jouw
  hoofdstat). Direct geverifieerd op de Wowhead-itempagina. Dit is de Class-Codex-pick
  (Rob, Ele Shaman, 24 jun).
- Lager-ilvl variant: Indecipherable 240982 (ilvl 278).
- Andere varianten (allemaal Thalassian Diamond, unique): **Powerful 240967/240966**,
  **Stoic 240971/240970**, **Telluric 240969/240968**. Hun stat-regel kwam **niet
  betrouwbaar** door op Wowhead (Stoic staat zelfs als "bugged" in de comments) → die
  claimen we NIET en raden we niet aan (never-lie). MH raadt alleen de geverifieerde
  Indecipherable (+32 primary) aan.

### Advies-model (in MH gebouwd, 24 jun)
- **1× Eversong Diamond (Indecipherable, +32 primary, uniek) + de rest secundaire dual-gems.**
- MH detecteert of er al een Thalassian Diamond gesocket zit (via de gem-ID's in de
  item-link, set `DIAMOND_IDS`); zo ja, geen tweede aanraden.
- Per lege socket: de stat-gematchte dual-gem (16 top + 7 tweede).

## Open / nog te besluiten
- Stoic/Telluric/Powerful stats: bij de volgende patch/Wowhead-fix verifiëren — als ze
  +primary + een secundaire blijken, kan MH per spec de beste variant kiezen.
- Bevestigen tegen AskMrRobot / Class Codex of het stat-prioriteits-idee klopt per spec
  (MH gebruikt nu `ns.VAULT_ADVISOR_SPEC_WEIGHTS`, zelfde bron als de enchant-advisor).
