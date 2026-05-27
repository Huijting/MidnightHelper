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
- **Data pipeline**: `data/vault_stat_catalog.json` → `tools/fetch_vault_stat_priorities.py` → `tools/generate_vault_stat_weights.py` → `Modules/VaultAdvisorData.lua`

### 🔜 Volgende verbeteringen (na backup commit)

1. **Pawn-integratie** — optioneel Pawn-scale scores i.p.v. guide-weights als Pawn geladen is
2. **Instellingen** — popup aan/uit in Broker (code had `popup`, UI-checkbox ontbrak)
3. **Hero classes** — meer specs met hero-specifieke stat widgets (Arms Colossus/Slayer, etc.)
4. **Raid vs M+ profielen** — vooral healers (Icy Veins raid ≠ M+ waar van toepassing)

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
