# Midnight Helper — 5-Room Redesign Blueprint

Status: proposal / build spec. Goal version target: phased, starting 1.9.0.
Owner: Inchy & Gemma. Last updated: 2026-06-23.

---

## 1. Why we're doing this

Midnight Helper grew into a rich, accurate companion — but the navigation didn't grow with it. Today it has, by actual count:

- **19 top-level tabs** across 4 sidebar sections
- **13 sub-tabs** (Toolbox, Guide, Codex categories, Professions Hub)
- **14+ separate floating windows** reachable only via slash commands
- **~50 distinct UI surfaces** in total
- Significant **duplication**: Great Vault status appears in 3 places; delve/dungeon/world/professions info exists in *both* a top-level tab *and* a Codex category.

The root cause is not "too many features." It's that three fundamentally different *kinds* of content are mixed into one flat list of tabs, so there is no reliable mental model for "where does X live?" — which is why even the author loses the thread, let alone a new user.

## 2. The model — 3 buckets → 4 rooms + search

Split everything by **what the player is trying to do**:

| Bucket | Question it answers | Room |
|--------|---------------------|------|
| Live status (changes weekly) | "What do I do this week / how are my alts?" | **Me** (This week / My characters) |
| Knowledge (static, you read it) | "How does X work?" | **Codex** |
| Situational helpers (you summon them) | "Open the thing for this fight." | **Tools** |
| Preferences | "Configure the addon." | **Settings** |

> Decision (2026-06-23, Inchy): the "live status" bucket is **one room, `Me`**, with an internal split between *This week* and *My characters* — not two separate rooms. Net result is **4 rooms**.

Plus three cross-cutting elements present on every screen:

- **Global search bar** (top, always visible) — type a word, jump straight to any screen, article, tool or setting. This is the single biggest fix for "I don't know where to look."
- **Pinned favourites row** — a thin strip under search where the player pins their most-used 3–5 targets (e.g. Great Vault, Delve Coach, Work Orders). One-click access to personal top picks.
- **Simple / Full toggle** — Simple shows the rooms and the essentials; Full unlocks every advanced panel. (Inspired by Leatrix Plus's opt-in philosophy and RaiderIO's sane defaults.)

Rail style decision: **icons + labels** (not icon-only), for clarity — especially for beginners.

## 3. The four rooms

1. **Me** — the default landing room, split into two views:
   - *This week* — your week at a glance: Vault, weekly chores (Ritual / Void / Showdown), World Boss, rares up, events, Omnium progress, reset routine, and the new-player "Start here" checklist at the top.
   - *My characters* — everything about you and your alts: alt overview snapshot, Delver's Call, vault per char, shard cap, SMC, enchants, tier set, Omnium Folio, currency caps.
2. **Codex** — one searchable knowledge library. All guides live here, nowhere else: delves, dungeons, world bosses, professions (101 + leveling routes + Work Orders + treasures/books), SMC farming, Academy lessons, beginner guide, keybind/layout reference.
3. **Tools** — a launchpad for the live helpers, so they stop hiding behind slash commands: Delve Coach, Consumable board, Dungeon Boss window, Curios advisor, Macros, Rare scanner, Model preview. Each row shows what it does + its slash command.
4. **Settings** — preferences, language, the new **independent text-size slider**, Simple/Full default, Addons panel, About & changelog.

## 4. Surface-by-surface mapping (current → new home)

| Current surface | New home |
|---|---|
| Start Here | **Me › This week** (onboarding checklist at top) |
| Home (dashboard) | **Me › This week** |
| Rares (tab) | **Me › This week** (rares up) + scanner under **Tools** |
| World (tab) | **Me › This week** (weekly status) + strats under **Codex › World** |
| Events (tab) | **Me › This week** (event calendar) |
| Account (alt overview) | **Me › My characters** |
| Delve Log | **Me › My characters** |
| Enchants | **Me › My characters** |
| Tier | **Me › My characters** |
| Omnium | **Me › My characters** |
| Currency | **Me › My characters** (live caps) + **Codex › Currencies** (spend guide) |
| Codex (tab) | **Codex** (becomes the whole room) |
| Delves (tab) | live status → **Me**; boss strats/guides → **Codex › Delves** |
| Dungeons (tab) | guides → **Codex › Dungeons**; live tips → **Tools** (Boss window) |
| Guide › Leveling | **Codex › Getting started** |
| Guide › Layout (keybinds) | **Codex › Reference** |
| SMC Guide | **Codex › SMC farming** |
| Toolbox › Consumables | board → **Tools**; "what to use" → **Codex** |
| Toolbox › Macros | **Tools** |
| Toolbox › Academy | **Codex › Academy** |
| Toolbox › Professions Hub › Overview | live KP → **Me › My characters** (or Now) |
| Toolbox › Professions Hub › Treasures + Course | **Codex › Professions** |
| Addons | **Settings** |
| Settings | **Settings** |
| All 14 floating windows | listed + launchable from **Tools**; auto-triggers unchanged |
| Changelog window | **Settings › About** (+ still auto-shows on update) |

Net result: **19 tabs → 4 rooms**, and every guide has exactly one home.

## 5. Global search (the front door)

- Build a flat search index of every navigable target: room, sub-section, Codex article, tool, and slash command — keyed on **localized** labels + keywords (so "work orders", "werkorders", "flask", "vault" all resolve).
- Selecting a result calls the existing `SelectTab()` routing (we already have alias routing for legacy names), so search reuses navigation we already have.
- Show breadcrumbs on every screen (e.g. `Codex › Delves › <boss>`) so depth never disorients.

## 6. Text size independent of window scale

On a 5120×1440 ultrawide you scale the *window* down to fit, which currently shrinks the *text* too. Fix: a `Content text size` multiplier in Settings applied to body/guide fonts, decoupled from window/UIParent scale. Small, high-value, and shippable early.

## 7. Build order — non-breaking, reversible phases

Each phase is independently shippable and can be reverted on its own. Old tab names stay aliased throughout, so nobody's muscle memory breaks mid-migration.

- **Phase 1 — Quick wins (pure additions).** Global search bar + content text-size slider. No existing screen changes; immediate relief. → ship as a point release.
- **Phase 2 — The 4-room rail.** Introduce `Me` / `Codex` / `Tools` / `Settings` as the new top-level rail (icons + labels), with the `Me` room split into *This week* / *My characters*; map every current tab underneath its room; keep all old tab IDs aliased. Add the pinned favourites row here too.
- **Phase 3 — Codex consolidation.** Merge the duplicate delve/dungeon/world/professions content into the single Codex library; add breadcrumbs; retire the redundant top-level guide tabs.
- **Phase 4 — Tools launchpad.** One discoverable panel for the 14 helpers; slash commands remain but are no longer the only way in.
- **Phase 5 — Polish.** Simple/Full default for new installs, onboarding inside Now, copy pass across all 7 languages, About reflects the new structure.

## 8. Testing & risk

- The big locale files load unconditionally, so a syntax slip breaks the whole addon → **in-game `/reload` is the definitive test after every phase** (the sandbox can't fully parse them).
- Alias routing preserves existing entry points, so each phase is additive before anything is removed.
- Keep CHANGELOG + the in-game changelog updated per phase, per the usual release rule.

## 9. Decisions (resolved 2026-06-23, Inchy)

- **Rail style:** icons **+** labels — clearer, especially for beginners. ✅
- **Me room:** `Now` and `Characters` merge into **one `Me` room** with a *This week* / *My characters* split. 4 rooms total. ✅
- **Favourites:** yes — a thin pinned-favourites row under the search bar for the player's top 3–5 targets. ✅
