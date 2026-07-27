# The Midnight Codex — how it actually works

Written 2026-07-27 as step 1 of the RFC-001 proof of concept: before anything
generates a Codex article, someone has to know what a valid one looks like.

Everything below was read out of the code, not remembered. Where a comment in the
repo contradicted the code, the code won and the comment was corrected.

**Scale today:** 9 categories, 39 articles, 7 language packs.

---

## The three files

| File | Holds | Owned by |
|---|---|---|
| `Modules/MidnightCodexData.lua` | the registry: ids, categories, ordering, navigation, search keywords | code |
| `Locales/Codex.lua` | every string, in 7 languages | text |
| `Modules/MidnightCodex.lua` | rendering, category buttons, the panel | code |

An article is a **row in the registry plus two locale keys**. Nothing else. There
is no per-article file and no content in the data module.

---

## An article

```lua
{
    id = "season_end",              -- permanent; NavSearch and DailyTip use it
    category = "start",             -- must match a CODEX_CATEGORIES id
    titleKey = "CODEX_SEASONEND_TITLE",
    bodyKey  = "CODEX_SEASONEND_BODY",
    sort = 7,                       -- position within its category
    searchKeys = "season end reset rollover ...",
}
```

Optional fields, all nil-safe:

| Field | Effect |
|---|---|
| `tabId` + `tabLabelKey` | adds an "Open ..." button that jumps to that tab |
| `navLabelKey` | overrides the button text when the tab name alone is unclear |
| `delvesSection` | `"vault"` / `"midnight"` — which accordion to open |
| `referenceSubTab` | `"crest"` / `"professions"` when `tabId` is `reference` |
| `currencyId` | shows the player's live balance under the title |
| `betaKey` (categories only) | hides the category unless that beta box is ticked |

`id` is already what RFC-001 calls a stable identifier. `season_end`,
`gear_tracks`, `warband_bank` — these do not change, and NavSearch indexes on them.

---

## The strings

`Locales/Codex.lua` merges **seven** packs, in this order: enUS, itIT, nlNL, deDE,
frFR, esES, ptBR. Each block is a plain `merge(ns._mhLocales.<code>, { ... })`.

⚠️ The file's own header claimed "enUS + nlNL; other packs fall back" until
2026-07-27. It had seven blocks. A generator written against that comment would
have produced two languages and silently dropped five.

**Resolution order** (`ns:L`, Locale.lua:256):

1. the active pack
2. `enUS`
3. the key itself

So a missing translation shows English. A missing **key** shows `CODEX_FOO_BODY`
on screen — which is the only truly broken outcome, and the linter's check [1]
catches it as a HARD failure.

The Codex renders through `ns:SafeL`, which is `ns:L` plus `SanitizeUIFontText`.
A generator does not need to know what that sanitiser does; it needs to know that
output is not rendered raw.

---

## Body markup

Bodies are a single string with WoW's inline markup. Counts across the file:

| Token | Meaning | Uses |
|---|---|---|
| `\|n` | line break | 821 |
| `\|cffRRGGBB` … `\|r` | colour on / off | 595 / 595 |
| `•` (U+2022) | bullet, written literally | 907 |
| `->` | arrow in navigation hints | 62 |

Two invariants a generator must hold, both mechanically checkable:

- **every `|cff` is closed by a `|r`.** They balance exactly today (595/595). An
  unclosed colour bleeds into the rest of the panel.
- **`%` must be doubled only in strings passed through `:format()`.** A body shown
  directly takes a single `%`. Getting this backwards prints `%d` at the player or
  errors at runtime.

There is no `{CURRENCY:id}` token in Codex bodies — that exists elsewhere in the
locale files. Do not invent it here.

---

## What else consumes an article

Three things, and a generator that ignores them produces an article that exists
but cannot be reached:

- **NavSearch** (`Modules/NavSearch.lua`) indexes every article automatically on
  `L(titleKey)` plus `"codex article <id> <searchKeys>"`. Without `searchKeys` an
  article is findable only by words already in its own title — which is exactly
  the words a reader who has not found it will not type.
- **DailyTip** picks one article a day from `ns.CODEX_ARTICLES`.
- **Category buttons** are built from `CODEX_CATEGORIES`, sorted by `sort`.

---

## What a generator has to emit

To add one article, a generator must produce **four** things:

1. a registry entry appended to `ns.CODEX_ARTICLES`
2. `<KEY>_TITLE` and `<KEY>_BODY` in the **enUS** block of `Locales/Codex.lua`
3. the same two keys in the six other blocks, or accept the English fallback
4. `searchKeys` on the registry entry

And then pass, unchanged, the checks this repo already runs:

```bash
luac -p Locales/Codex.lua Modules/MidnightCodexData.lua
```

```bash
python tools/lint_addon.py
```

The linter must report **0 HARD**. Its check [1] resolves every `ns:L` reference
against the enUS pack, so a registry entry pointing at a key that was never
written is caught before it reaches the game.

---

## Honest notes for the RFC-001 round trip

**The Codex is already a knowledge base**, and this is the overlap the RFC did not
account for: stable ids, categories, ordering, search keywords, seven languages,
39 articles. `GEAR-001 "I found a new helmet"` and the Codex's `gear_tracks` are
the same kind of object.

**Round-tripping is not symmetric.** A knowledge object can generate an article:
prose plus metadata is a superset of what a registry row and two locale keys need.
The reverse is lossy — an article has no `difficulty`, no `related`, no evidence
references. So the PoC should treat `/knowledge` as **upstream** and the Codex as
**one output**, not as two peers kept in sync.

**Six languages are the real cost.** Generating enUS is easy. The other six are
where the work is, and today they are hand-written prose, not translations of a
canonical source. A generator that only emits English quietly turns a
seven-language Codex into a one-language one, because English does not overwrite
an existing translation — it just never updates it. Decide this before the PoC,
not after.

**Suggested first object:** `season_end` ("When a season ends"). It is
self-contained, deliberately free of numbers and dates, already exists in all
seven languages, and has `searchKeys` — so the round trip exercises every field
that matters without touching anything patch-sensitive.

---

## The boundary, and the falsifier

Agreed with ChatGPT 2026-07-27, at the close of the RFC-001 discussion. Written
down here because it decides what a knowledge object may contain, and a decision
that lives only in a chat log is a decision that gets re-litigated.

**The split in this repo is by rate of change and by owner, not by file type.**
Prose changes often and belongs to translators, so it lives in `Locales/` — and
that is enforced, not stylistic: `tools/lint_addon.py:79` collects key definitions
from `Locales/` only, so a key defined in a module makes every reference to it a
HARD failure. Structure changes rarely and belongs to code, so it lives in the
registry, identically for all seven languages. Presentation changes independently
of both, so the renderer knows neither ids nor text.

**A knowledge object carries intent, never implementation.** `tabId = "reference"`,
`delvesSection`, `currencyId` and `sort` are facts about *this addon's user
interface*. Put them in a knowledge object and every future output inherits one
addon's topology. What belongs there is "this explains crests"; a small per-output
map then says "in MH, crest articles link to the reference tab". That map is the
only thing that changes when the tabs are reorganised.

**The falsifier for the whole model.** If a knowledge object cannot be written
without already encoding `sort = 7` and `category = "start"`, then knowledge is
not upstream of the article — it is the article in a different file format, and
the architecture has not earned its keep. That is a real possible outcome and it
costs one file to discover.

**The proof of concept is a diff, not a write.** Express `season_end` as a
knowledge object, generate what the enUS registry row and locale entries *should*
be, and compare against what is in the repo. Nothing is written, so it cannot
break the addon, and because the article already exists there is a ground truth to
be wrong against. Success is an empty diff apart from differences you can explain.
