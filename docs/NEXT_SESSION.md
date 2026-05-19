# Next session — Midnight Helper (2026-05-20)

Pick up from `main` @ `ec70932` (everything pushed).

## Test first (delve / travel)

- [ ] SMC → portal → Harandar/Voidstorm delve: TomTom arrow returns after zoning
- [ ] Enter delve (e.g. Shadowguard Point): no `ADDON_ACTION_BLOCKED` on travel popup
- [ ] Near delve / inside delve: no false Hearthstone popup
- [ ] Account snapshot: shards show `total (weekly/600)`; relog alts once for weekly data

## Release

- [ ] **CurseForge 1.2.4** zip (`tools/package.ps1`) — bundle since 1.2.3:
  - Travel Assistant delve fixes (false HS, portal arrow restore, combat-safe popup hide)
  - Account snapshot weekly shards + delete tooltip fix
- [ ] Paste changelog on CurseForge project page

## Expansion ideas (prioritize with user)

### Quick polish

- Consumables: open tab from guide search / spec preview (not only via sidebar)
- Account snapshot: sort/filter; clearer “stale since Wednesday” badge
- Delves: bountiful quick-action per row; coffer keys in snapshot

### Medium

- Great Vault: reset-day reminder (chat or minimap ping)
- Professions: mirror weekly currencies in Account snapshot
- Macros: one-click “copy team pack” or slot helper
- TomTom optional: Blizzard user waypoint fallback when TomTom missing

### Larger (later)

- Keyboard layout + macros for more classes
- SMC checklist: maintain/verify quest IDs per patch
- Alt snapshot export/import (local string, no cloud)

## Recent fixes (context)

| Commit     | Topic |
|-----------|--------|
| `ec70932` | `SafeHideTravelPopup` — no Hide() during combat lockdown |
| `0d1c7ae` | TomTom arrow after portal; strict “arrived” = distance only |
| `20f306f` | Weekly shard cap in Account snapshot |
| `5882277` | Travel Assistant + TomTom docs (EN/NL) |
| `25d06db` | Delete tooltip `SetText` alpha fix |
