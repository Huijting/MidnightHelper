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

### ⚠️ Chapter 9 describes an addon feature that does not exist

- **Summary:** "Hoofdstuk 9", page 5, states that Midnight Helper never issues an
  automatic sell instruction for six categories of item, and quotes what the addon
  supposedly says: *"Bewaar voorlopig — controle nodig."*
- **What the addon actually does:** **nothing of the sort.** Midnight Helper has no sell
  advisor, no junk list and no vendor recommendation of any kind. The quoted string
  appears nowhere in the codebase, in any language. The closest real feature is
  `Modules/BagUpgrade.lua`, which puts a small green arrow on bag items that are a clear
  upgrade — and it deliberately says nothing about anything else, including selling.
- **Evidence:** IN_GAME_VERIFIED / code-verified, 2026-07-27 (grep across all modules and
  locale files).
- **Book chapters affected:** 9. Possibly others that describe addon behaviour.
- **Confidence:** certain. This is a claim about our own code.
- **Action required:** rewrite page 5. The *advice* is good and worth keeping — read the
  binding before you sell — but it must not be presented as something the addon does or
  says. Either drop the addon framing, or we build the feature and then the chapter
  becomes true. Rob's call; it is not currently on any roadmap.

### Chapter 10 lists an "Explorer" gear track that Midnight does not appear to have

- **Summary:** chapter 10 is titled "van Explorer tot Myth" and lists six tracks:
  Explorer, Adventurer, Veteran, Champion, Hero, Myth.
- **What we measured:** five tiers — Adventurer, Veteran, Champion, Hero, Myth. Explorer
  appears zero times in `docs/CREST_SOURCES_MEASURED.md` (read from `C_CurrencyInfo`,
  2026-07-22) and zero times in the Dawncrest code. Rob's own upgrade panel shows those
  same five. A second, independent source describes Season 2 as having five tracks.
- **Evidence:** IN_GAME_VERIFIED for the five; the sixth is COMMUNITY_REPORTED at best.
  Note the honest limit: we measured **crest tiers**, and a track without its own crest
  would not show up that way. So this is strong evidence, not proof.
- **Source of the error, probably:** the chapter cites the same *Embers of Neltharion*
  article as chapter 7. Explorer was a track in that era.
- **Action required:** verify at the upgrade NPC, then drop Explorer if confirmed. The
  chapter title changes with it.

### Chapter 10 generalises "6/6" to every track

- **Summary:** the chapter says appearances change when an item is fully upgraded to 6/6.
- **What we measured** (2026-07-17, at Cuzoth's upgrade window): Hero reads `3/6` and
  Champion reads `4/6`, so /6 is right **for those two**. Adventurer, Veteran and Myth
  rank counts have never been seen. The War Within used 8 for lower tracks, so the
  generalisation is not safe.
- **Confidence:** medium. The claim may well be right; it is simply not verified.
- **Action required:** either soften to the two tracks we have seen, or verify the rest.

### Chapter 13: the delve count conflict can now be resolved

- **Summary:** the chapter deliberately refuses to state a delve count, because Blizzard's
  announcement says ten new Delves plus one seasonal Nemesis Delve while beta material
  says eleven. It treats these as conflicting and points at the interface. That was the
  right call at the time.
- **What we measured:** `C_AreaPoiInfo.GetDelvesForMap` across all Midnight zones returns
  **ten** unique delves (`docs/PTR_DELVE_SCAN.md`, 2026-07-27). Nullaeus sits in a
  separate lair, not in that list.
- **So the two sources agree:** 10 regular + 1 nemesis = 11 total. Neither was wrong.
- **Confidence:** high, with the standing caveat that the API returns what is on offer.
- **Action required:** optional. The chapter is safe as written; it could now say ten
  regular delves plus a seasonal Nemesis Delve, and cite the interface for the list.

### Pattern, not incidents: three chapters cite Dragonflight-era sources

- **Summary:** chapters 3, 7 and 10 all source their upgrade and gear explanations from
  2023 Dragonflight material — *Embers of Neltharion Upgrade System Overview*,
  *Developer Insights: New Upgrade System in Embers of Neltharion*, *Dragonflight
  Preview: An Eye on Professions*, *Rev up Your Adventures with Turbo Boost*.
- **Why it matters:** the upgrade system is the part that has changed most since. It is
  almost certainly where the Explorer track in chapter 10 comes from.
- **Action required:** treat this as one editorial pass rather than three fixes. Anything
  about tracks, ranks, crests or upgrade currency that traces back to those articles
  needs re-checking against the current game or against our measured files.

### Verified TRUE: chapter 8's claim about the addon

- Chapter 8 states that Midnight Helper shows the source and patch version when it makes
  a specific recommendation. **It does.** `VAULT_ADVISOR_SOURCE_FMT` renders
  "Guide stats (%s, patch %s)". No change needed — recorded so this is not re-checked.

### Verified TRUE: chapter 14's boss count

- "Three raid zones with nine bosses in Season 1" matches the addon's own roster exactly:
  The Dreamrift 1, The Voidspire 6, March on Quel'Danas 2. IN_GAME_VERIFIED via DBM
  cross-check. No change needed.

### Checked and clear

- **Chapter 13's Valeera guidance** matches the addon exactly: it declines to fix a talent
  route without current patch verification, which is the same reason the addon shows the
  poisons without recommending one. No change needed.
- **Chapter 7** does not claim gear is reset at a season change.
- **Chapters 2, 4, 5, 11 and 12** were read and no factual problem was found. Chapter 5's
  armour split across all thirteen classes is correct; chapter 4's sixteen-slot list is
  correct and says openly what it leaves out.
- **Chapter 6, page 4** contains a softer version of the chapter 9 problem — "daarom wordt
  een onbekende trinket niet automatisch verkocht" implies addon behaviour that does not
  exist. Lower priority than chapter 9, same fix.

### Review scope

All fourteen chapters plus the Boekmaster were read on 2026-07-27 against the addon's code
and measured data. Two claims about the addon were checked: one true (chapter 8), one
false (chapter 9). Chapters not re-read since then may have changed.

- The earlier warning in the 2.11.0 section predicted the book might say gear is reset or
  scaled down when a season ends. Chapter 7 does **not** say this. Recorded so nobody
  goes looking for a problem that is not there. Other chapters not yet reviewed.
