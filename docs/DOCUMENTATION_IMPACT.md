# Documentation impact

An outgoing feed for the beginner book, Notion and player-facing writing. Only changes
that alter what a player should **understand** — not refactors, file moves or formatting.

Newest at the top. Move a section under a version heading once it ships.

---

## 2.11.0 — released 2026-07-27

### The season checklist names things that actually expire

- **Summary:** the addon now tells a player which rewards stop being obtainable when a
  season ends, and ticks them off from their own client: the Delver's Journey, the five
  "of the Dawn" achievements, three Nullaeus nemesis achievements and the Prey capstone
  that grants the Preyseeker title.
- **Addon files:** `Modules/SeasonTransitionData.lua`, `Modules/SeasonTransition.lua`
- **Evidence:** IN_GAME_VERIFIED — every achievement id read from the live client, with
  criteria and reward text checked for 61798 and 62351. See `docs/EVIDENCE_REGISTER.md`.
- **Book chapters affected:** anything about seasons ending, or about what is worth
  finishing before a flip.
- **Notion pages affected:** Season 1 / Season 2 transition pages.
- **Confidence:** high for the achievements. The reward **items** (263413, 263222) are
  COMMUNITY_REPORTED and are shown nowhere in the addon — do not print them as fact.
- **Action required:** none for the addon. The book may want the same list.

### Terminology: the nemesis is spelled **Nullaeus**

- **Summary:** the announcement spelled it both "Nulleaus" and "Nullaeus". The client
  settles it: achievement 61798's description reads "Defeat Nullaeus in his lair".
- **Evidence:** IN_GAME_VERIFIED, 2026-07-27.
- **Action required:** correct any other spelling in the book, Notion and Discord.

### New explanation: what a season rollover actually does

- **Summary:** a Codex article under Start Here on gear, currencies and progress tracks
  at a season change. Two claims it deliberately does **not** make: that unclaimed track
  rewards are lost (they return at a vendor without the rank requirement, at a higher
  price), and any hard rule about crest conversion.
- **Addon files:** `Locales/Codex.lua`, `Modules/MidnightCodexData.lua`
- **Evidence:** ADDON_RESEARCH. Season 2 item levels increase rather than decrease
  (+46 over Season 1, COMMUNITY_REPORTED); a stat squish is an expansion pre-patch event,
  not a season event.
- **Book chapters affected:** this is close to book material — worth aligning wording.
- **Confidence:** medium-high. The article states mechanics with **no numbers at all**,
  on purpose, so it survives future season flips.
- **Action required:** if the book says gear is "reset" or "scaled down" at a season
  change, correct it. It is not.

### Behaviour change: the 3D boss model is off by default

- **Summary:** the large boss model beside the boss window no longer shows unless the
  player turns it on. Anyone who had explicitly enabled it keeps it.
- **Addon files:** `Modules/DungeonBossWindow.lua`
- **Book/Notion:** any screenshot showing the boss window with a model is now atypical.
- **Action required:** re-shoot screenshots if the book uses them.

### Valeera's poisons are shown but not recommended

- **Summary:** the delve companion advisor now lists Valeera's three poisons with each
  one's description read live from the game, and marks which is slotted. It gives **no**
  recommendation.
- **Addon files:** `Modules/DelveCuriosData.lua`, `Modules/DelveCuriosAdvisor.lua`
- **Evidence:** spell ids PTR_PROVISIONAL (measured on build 120100). The effects are
  UNKNOWN to us — the descriptions we had were tied to spell ids the client does not have.
- **Confidence:** ids high, effects none.
- **Action required:** the book must not advise a poison yet either.

### Evidence-status change: three published datasets overturned

- **Summary:** three things taken from published sources were disproven by measuring
  against the client — Valeera's poison spell ids (all three wrong), the Venomous Abyss
  boss order (DBM numbering, not fight order), and three of four Season 1 achievement
  names that turned out to be real but hidden.
- **Confidence:** the corrections are IN_GAME_VERIFIED or PTR_PROVISIONAL measurements.
- **Action required:** if the book or Notion carries any of those values, replace them
  from `docs/EVIDENCE_REGISTER.md`.

---

## Unreleased

### Book chapter 7 cites a Dragonflight-era source for the upgrade system

- **Summary:** "Hoofdstuk 7 – Item level" (Notion) sources its upgrade explanation from
  Blizzard's *Embers of Neltharion Upgrade System Overview*. That is patch 10.1, 2023 —
  three expansions back. The chapter's own content is sound and the "meestal" rule is
  good; it is the **source** that is stale for tracks, crests and ranks.
- **Better sources we already hold:** `docs/CREST_SOURCES_MEASURED.md` (per-tier crest
  sources and item level ranges, read from `C_CurrencyInfo`, 2026-07-22,
  IN_GAME_VERIFIED) and the gear-track measurements from 2026-07-17 taken at Cuzoth's
  upgrade window (rank counters read as `Hero 3/6` and `Champion 4/6`; cost is crests
  plus a little gold; the track name is followed by its ilvl range, so the track is the
  ceiling).
- **Evidence:** IN_GAME_VERIFIED for the replacements.
- **Book chapters affected:** 7, and anything else citing the same article.
- **Confidence:** high that the citation is outdated; the chapter text itself was not
  found to state anything false.
- **Action required:** swap the citation, and check whether any rank or track numbers
  elsewhere in the book came from that article. Those are season-specific — the addon
  deliberately states the mechanic with no numbers so it cannot rot at a season flip.

### Checked and clear: chapter 7 does not claim gear is reset at a season change

- The earlier warning in the 2.11.0 section predicted the book might say gear is reset or
  scaled down when a season ends. Chapter 7 does **not** say this. Recorded so nobody
  goes looking for a problem that is not there. Other chapters not yet reviewed.
