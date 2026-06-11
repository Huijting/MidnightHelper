# CurseForge release 1.7.0 — copy/paste

**Upload:** `dist/MidnightHelper-1.7.0.zip` (build with `tools\package.ps1`).
**Description:** projectpagina-tekst hoeft niet volledig vervangen; voeg het
Dungeons-blok toe (zie onderaan) of vervang opnieuw met
`docs/CURSEFORGE_DESCRIPTION.md` + dat blok. Screenshot-suggestie: Dungeon
Coach opengeklapt (1 dungeon), de live chat-stappen bij een pull, en de
nieuwe rare-toast met 3D-model.

---

## Short summary (one line)

The Dungeon update: a complete Dungeon Coach for all 12 dungeons (43 bosses) with live boss steps in your chat at every pull, a beginners' course from first queue to Heroic in 6 languages — plus a smarter rare alert with the rare's own 3D model.

---

## Changelog — paste below (since 1.6.0)

### 1.7.0 — 2026-06-11

#### New — the Dungeons tab

- **This week:** your Spark weekly, Halduron's dungeon of the week, the Cracked Keystone and your Great Vault Dungeons row — tracked live in one place.
- **Dungeons 101:** a six-chapter beginners' course that takes you from "what is a dungeon?" to your first Heroic, with per-character progress ticks. Fully localized in 6 languages.
- **Dungeon Coach:** short, practical boss steps for **all 12 dungeons — 43 bosses** (what to dodge, what to kick, what your role does), in plain language. Every boss ability is a **clickable spell link** — hover it for the real tooltip, and spell names automatically show in your client's language. Click a dungeon open, hit the route button and TomTom guides you to the entrance — including the old-world portals for the Season 1 legacy dungeons.
- **Live coach:** the moment you pull a boss, its steps appear in your own chat (once per boss per session — wipes don't spam; `/mh livetips` toggles). Type **`/mh bossshare`** to share the last boss's steps with your group.
- Honest footnotes: the boss steps are currently in **English and Dutch** (the other languages fall back to English — full localization follows); group sharing is plain text in your language for now. The steps are written against DBM encounter data and Wowhead spell tooltips; in-game verification is ongoing. Spot something off? Tell us — never-lie is the house rule.

#### New — alerts

- **Rare alert, supercharged:** the popup now shows the actual **3D model** of the rare (double size), you can **drag it** wherever you want (position remembered for all popups), and it knows when you're already flying to your routed rare — "you're nearly there!" instead of a pointless waypoint offer. New option: only alert during an active rare hunt. Treasure/event false positives are gone.
- **Weekly shard cap:** one clear popup with its own sound the moment a character hits 600/600 Coffer Shards — stop farming, go do something fun.

#### Improved

- **"After the reset" routine** understands low-level characters: quest givers show "available from level 90" instead of sending you to an empty NPC, Halduron's leveling weekly is tracked, and profession weeklies respect your actual skill level.
- **Ritual Sites intro hint is step-aware:** it shows exactly which of the five intro steps is next for this character (robust against Blizzard's out-of-order quest flags).
- **Delves:** Start Here and the weekly hints now mention the Tier 3 cap below level 90.

#### Fixes

- Corrected the Overload gathering mechanic in the Professions 101 texts.
- Corrected dangerous Vordaza advice (kill the phantoms — don't touch them).
- The shard-cap "once per week" marker is only consumed when you actually saw the popup.
- An arrow glyph in Dungeons 101 chapter 3 no longer renders as a box.

#### Heads-up

- 12.0.7 lands June 16 — Midnight Helper's Showdowns support activates automatically on 12.0.7 clients. A content update with Val/Naigtal data follows shortly after release.

---

## Projectpagina — Dungeons-blok (toevoegen aan de feature-lijst)

**🗡 Dungeon Coach — from first queue to Heroic**
A complete dungeon companion: weekly dungeon goals tracked live, a six-chapter beginners' course (Dungeons 101), and short boss steps for all 12 dungeons that appear right in your chat when you pull — shareable with your group via `/mh bossshare`. Route buttons take you to every entrance, legacy portals included.
