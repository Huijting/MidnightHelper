<!-- Paste-ready Markdown copy of the v2.7.0 CurseForge notes. The packager uploads
     RELEASE_NOTES.html (HTML) verbatim; this file is the fallback if the CF page needs
     fixing by hand. Keep in sync with RELEASE_NOTES.html and CHANGELOG.md. -->

## Everyday decisions, made easier

Two questions you ask constantly — **"is this an upgrade?"** and **"how did that run go?"** — now have an answer right where you need it. Plus a calm on-ramp to the next season, and a route arrow that finally guides *every* route.

### 🗡️ Loot upgrade tips

Hover any piece of gear and Midnight Helper tells you, at a glance, whether it is an **Upgrade**, **Sidegrade** or **Lower** for your spec — with the exact item-level change.

- Uses the **same stat weights** as the Great Vault advisor — no second guesswork.
- Only clear-cut cases are called Upgrade or Lower; a higher-ilvl-but-worse-stats piece is honestly a *Sidegrade*.
- Upgrades also get a small **green arrow** right on the bag item.
- Toggle with `/mh loot`.

### 📊 Post-run scorecard

Finish a Midnight **delve or ritual** and you get one friendly line: your time — with a nudge when you beat your own average or set a record — and your deaths.

Toggle with `/mh scorecard`, or add `/mh scorecard detail` for the exact numbers.

### 🌙 A calm on-ramp to the next season

- A **Season transition** checklist on *This Week*: what to wrap up now, and — once the patch is live — how to get ready for the next season. It reads the game itself, so it only appears when it is genuinely relevant, and never shows a made-up "done". `/mh season`.
- New in the **Codex**: a reassuring "what a new season means" explainer, and a Season 2 glossary — crest, upgrade track, tier set, Catalyst, Bountiful, Nemesis, Lair, and the start-of-season rescale.

### 🧭 A route arrow for every route

Midnight Helper's own on-screen arrow now guides you to **delves, world bosses, the Trading Post, Silvermoon City** and more — not just rares and treasures — even without TomTom installed, and it releases once you arrive.

- It is **brighter with a dark outline**, so it stands out on any background.
- *Find nearest bountiful delve* now really picks the **closest** one.

---

## Fixed

- An error could pop up repeatedly inside **delves, dungeons and Mythic+** (the game hides some aura details in that content, which one of our on-screen alerts tripped over). Midnight Helper handles it quietly again.

## Under the hood

- **Lighter at login** — only your active language pack is built now, instead of all seven, so Midnight Helper uses less memory when you log in.
