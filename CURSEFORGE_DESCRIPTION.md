## Midnight Helper

Midnight Helper is an all-in-one utility addon for **World of Warcraft Retail** (Midnight Season 1). It brings weekly planning, Delves, Great Vault tracking, alt snapshots, in-delve coaching, and reference guides into one compact window — with full UI support in **six languages**.

### Highlights

**Delves & weekly progress**
- Delves dashboard: currencies, season progress, and bountiful tracking
- **Great Vault** helper (World / Dungeons / Raids) on the Delves tab
- Reset-day reminders and subtle highlights when a character has claimable vault rewards
- **Travel Assistant** for sensible cross-zone hops toward delve entrances (optional **TomTom** arrows, or Blizzard map waypoints when TomTom is not installed)

**In-delve tools**
- **Delve Coach** — route, trash, and boss tips for all **11 Midnight Season 1 delves**; resizable panel; boss **3D preview** with scroll-zoom; spell tooltips where IDs are known
- **Delve Party Share** — send coach tips to party, raid, or instance chat (brief, boss, sections, copy dialog); recipients do not need this addon
- **Delve consumables** — quick-use panel for **RAID-R Mini** and **Trovehunter's Bounty** when you carry them; auto-shows on delve entry; **minimap launchers** (left-click opens panel, right-click uses item) visible **only during an active delve**
- **Valeera curio advisor** — role-based curio suggestions on the Delves tab and a popup at repair / gossip NPCs

**Account & professions**
- **Account snapshot** — per-character overview (keys, shards, undercoins, item level, profession weekly currencies in tooltips)
- Sort/filter toolbar, stale-since-Wednesday badge, and compact vault status per row
- **Profession** tools and overview on the Professions tab

**Guides & reference**
- **Leveling Guides** — advisor text and gear notes per class/spec at level brackets; **In groups** tab (interrupt priority, defensives, party tips by role); **Layout** sub-tab with the ISO keyboard prototype (Midnight key highlights)
- **Role Academy** — tank and heal learning tracks with links to macros, consumables, and delves
- **Macros** — interrupt and team macro templates with class context
- **Consumables** — per-spec suggestions with Wowhead-backed data and guide search preview
- **SMC City Guide** — Silvermoon City pins with waypoint buttons; optional weekly/hub checklist (quest IDs configurable in data)
- **Addons** tab — companion helpers (e.g. Platynator integration)
- Global **search** routes keywords to the right tab (delves, consumables, academy, macros, city pins, and more)
- In-game **changelog** window

**Minimap**
- DataBroker launcher with quick access, locale switcher, and vault reminder lines

### Languages

Full UI, Delve Coach tips, leveling advisor text, consumable notes, and guide groups are available in:

| Language | Code | Auto with `/mh lang auto`? |
|----------|------|----------------------------|
| English | `en` | Yes (also EN-GB → English pack) |
| Deutsch | `de` | Yes |
| Français | `fr` | Yes |
| Español | `es` | Yes (`esMX` uses the same pack) |
| Português (BR) | `pt` | Yes |
| Nederlands | `nl` | **No** — choose manually (`/mh lang nl`) |

Other WoW client locales (e.g. Italian, Korean, Chinese) fall back to **English** until a dedicated pack is added.

### Slash commands

| Command | Action |
|---------|--------|
| `/mh` or `/midnight` | Toggle main window |
| `/mh coach` | Toggle Delve Coach |
| `/mh items` | Toggle delve consumables panel (force preview outside a delve) |
| `/mh items mark` / `mark radar` / `mark bounty` | Mark consumable as used this delve |
| `/mh items reset` | Reset consumable advice for this delve |
| `/mh lang auto` | Match WoW client language (when a pack exists) |
| `/mh lang en` · `de` · `fr` · `es` · `pt` · `nl` | Set language |
| `/mh settings` | Quick settings |
| `/mh changelog` | Changelog window |
| `/mh debug` | Debug mode |
| `/mh guide` | Layout diagnostics (maintainers) |

### Notes

- Great Vault and alt snapshot values reflect the **latest saved data per character**. Log each alt at least once after weekly reset for a complete account picture.
- Delve Coach party share only sends when you are in a real group (avoids Blizzard “not in a party” messages when solo).
- Delve consumable tracking is per delve instance; use `/mh items reset` if advice was wrong.
- Game data and recommendations may change with patches — verify quest IDs and weekly pins after major updates.

### Requirements

- WoW Retail (see addon TOC for current **interface** version)
- Optional: [TomTom](https://www.curseforge.com/wow/addons/tomtom) for enhanced map arrows

### Credits and References

- [Wowhead](https://www.wowhead.com/) for public game-reference validation and lookup support.
- [Icy Veins](https://www.icy-veins.com/wow/) for external leveling and talent reference links.
- [TomTom](https://www.curseforge.com/wow/addons/tomtom) for optional waypoint integration.

### Disclaimer

Midnight Helper is a fan-made addon and is not affiliated with, endorsed, sponsored, or specifically approved by Blizzard Entertainment, Inc.

World of Warcraft and Blizzard are trademarks or registered trademarks of Blizzard Entertainment, Inc. in the U.S. and/or other countries.

Game data and recommendations may change with patches, hotfixes, or tuning updates.
