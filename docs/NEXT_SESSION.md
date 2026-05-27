# Next session — Midnight Helper

**Laatste update:** 2026-05-27  
**CurseForge:** **niet pushen** tot CF gate in `I18N_ROADMAP.md` volledig ✅

---

## CF-talen (6) — status

| Taal | B | C | Volgende |
|------|---|---|----------|
| enUS / nlNL | ✅ | ✅ | polish NL |
| deDE / frFR / esES | ✅ | ✅ | polish + in-game |
| ptBR | ✅ | ✅ | polish + in-game ptBR |

**Geen ruRU** — bewust buiten scope; Russische WoW-clients vallen terug op `enUS` via `/mh lang auto`.

---

## Vault Advisor + Reminder — status (2026-05-27)

### ✅ Af (fase 1, in-game getest)

- **Vault Advisor** (`Modules/VaultAdvisor.lua`): `C_WeeklyRewards`, ranking vs **equipped**, ilvl dominant, tier-waarschuwing, unique, token-footnote, Delves-tab host
- **Guide-stats alle 39 specs** (Icy Veins widget, patch 12.0.5) + Wowhead-links in metadata
- **Shaman hero overrides**: Totemic / Stormbringer / Farseer (Enhancement + Elemental)
- **Vault Reminder**: chat, minimap, pulse, login-popup + TomTom waypoint (Silvermoon vault)
- **Blizzard vault banner** — advies op `WeeklyRewardsFrame` (echte claim-UI), ook als MH dicht is; instelbaar aan/uit
- **Data pipeline**: `data/vault_stat_catalog.json` → `tools/fetch_vault_stat_priorities.py` → `tools/generate_vault_stat_weights.py` → `Modules/VaultAdvisorData.lua`

### ✅ Fase 2 (2026-05-27)

- **Pawn** — scores via `PawnGetItemData` + actieve scale (instelbaar)
- **Instellingen** — popup, Pawn, M+ profiel in Broker quick settings
- **Hero trees** — labels voor alle SubTreeIDs; fetch voor o.a. Blood DK, Enhancement
- **Raid vs M+** — `_MPLUS` keys voor healers; auto bij dungeon-vault of instelling

### 🔜 Later

- Meer hero-spec entries waar Icy Veins geen aparte widget heeft (Arms Colossus/Slayer — zelfde priority op IV)

### ✅ Extra (2026-05-27)

- **Zijpaneel toggle** in quick settings (`showBlizzardPanel`)
- **Vault Advisor alleen zijpaneel** — Delves-tab ranking verwijderd
- **Hero stat-gewichten** — 18 extra hero entries (70 totaal) via Icy Veins multi-widget specs
- **i18n Vault Advisor** — de/fr/es/pt + EN/NL

### Test Vault Advisor

```text
/reload
```

Delves-tab → **Weekly Great Vault** → open echte claim-UI bij vault in wereld (niet alleen SHIFT-J overzicht). Check: guide-regel, ranking, `+N ilvl vs equipped`, tier-note.

### Data verversen na patch

```bash
python tools/fetch_vault_stat_priorities.py
python tools/generate_vault_stat_weights.py
```

---

## Overig backlog

1. **Professions-gids** fase 1+2 in game testen (EN/NL)
2. About/changelog CF-tekst → upload pas na gate ✅

**In-game talen (6 packs):** getest en goed bevonden ✅

---

## Test i18n

```text
/reload
/mh lang de
/mh lang fr
/mh lang es
/mh lang pt
```

Per taal: tab Delves, Leveling Guide (Advisor + Gear), Gids (Dawncrest), Delve Coach share-knoppen.
