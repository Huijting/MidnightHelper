# Spec 16 — CurseForge localization bridge (ready-to-wire)

Status: **DORMANT / prepped.** The runtime robustness fix is already committed (see
below). The shim files + CI Action below are NOT wired yet — they go live only after
Rob enables CF localization, so nothing here risks the release build until then.

Recommended scope (from the spec): CF localization for the **new languages only**
(koKR / zhCN / zhTW / ruRU). The existing six packs (de/fr/es/pt/it/nl) stay in code,
untouched. Never run `handle_missing: DeletePhrase`.

---

## Already done (committed, safe, no-op until shims exist)

Empty pack = no pack, in two places, so a CF shim that has no community translations yet
does NOT auto-select or suppress the "help translate" nudge:
- `Locales/Locale.lua` → `HasLocalePack()` requires `next(pack) ~= nil`.
- `Modules/TranslateNudge.lua` → `shouldNudge()` treats an empty pack as absent.

Both are no-ops today (no empty packs exist); they make the lifecycle correct once shims land.

---

## Rob's part (do FIRST — the code below depends on it)

1. CurseForge → project → **Settings → General → Localization** → enable (free).
2. **Import** the enUS keys as phrases: format `["KEY"] = "English text"`, and put the
   English text in **Context** too — critical so translators keep `%s` placeholders and
   `{SPELL:}`/`|c…|r` tokens intact.
3. Choose **open** or **moderated** submissions.
4. Grab the project's **Localization page URL** (for the nudge, step below).
5. **Never** enable `DeletePhrase` / `handle_missing: DeletePhrase` until CF holds the full,
   correct keyset — it would throw phrases away.

Tell me when this is done and I wire everything below.

---

## Half B — the pull shims (one per new language)

Drop these into `Locales/` and register them in `MidnightHelper.toc` (Locales section,
after the existing packs). Each is ~6 lines; the packager replaces the `@localization@`
line with `L["KEY"] = "translation"` at build time, and the shim writes those into
`ns._mhLocales.<loc>`. `handle-unlocalized="comment"` omits untranslated keys → enUS
fallback keeps working.

**`Locales/_cf_koKR.lua`**
```lua
local _, ns = ...
ns._mhLocales = ns._mhLocales or {}
ns._mhLocales.koKR = ns._mhLocales.koKR or {}
local L = setmetatable({}, { __newindex = function(_, k, v)
	if v and v ~= true then ns._mhLocales.koKR[k] = v end
end })
--@localization(locale="koKR", format="lua_additive_table", handle-unlocalized="comment")@
```

**`Locales/_cf_zhCN.lua`** — identical, replace every `koKR` with `zhCN`.
**`Locales/_cf_zhTW.lua`** — identical, replace every `koKR` with `zhTW`.
**`Locales/_cf_ruRU.lua`** — identical, replace every `koKR` with `ruRU`.

`.toc` lines to add (Locales section):
```
Locales\_cf_koKR.lua
Locales\_cf_zhCN.lua
Locales\_cf_zhTW.lua
Locales\_cf_ruRU.lua
```

> NOTE: these files carry a live `@localization@` keyword, so they must NOT be committed
> until CF localization is enabled — the packager would try to resolve it on the next
> release build. That's why they live here as text for now, not as real `Locales/*.lua`.

---

## Half A — push keys to CF (optional automation)

Manual (fastest to start): the CF Localization **Import** in Rob's step 2 above.

Automated (later): a GitHub Action that scans `ns:L("KEY")` and syncs keys to CF.
**VERIFY the action name / version / input names against its current README before
committing — do not trust this verbatim** (never-lie: I have not confirmed the exact
`p3lim/curseforge-localizations` input schema for this syntax).
```yaml
# .github/workflows/cf-localization.yml   (verify inputs before use)
name: Sync localization keys to CurseForge
on:
  workflow_dispatch:        # manual trigger only, so it never runs before CF is ready
jobs:
  sync:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: p3lim/curseforge-localizations@v2
        with:
          pattern: 'ns:L\(["'"'"']([A-Z0-9_]+)["'"'"']\)'   # matches ns:L("KEY")
          handle_missing: DoNothing                          # NEVER DeletePhrase
          exclude: |
            Libs/*
        env:
          CF_API_KEY: ${{ secrets.CF_API_KEY }}
```

---

## The nudge URL

`Modules/TranslateNudge.lua` → `CF_LOCALIZATION_URL` is currently an assumption
(`https://www.curseforge.com/wow/addons/midnight-helper/localization`). Replace it with
the real Localization page URL from Rob's step 4 once known.

---

## Wire-up checklist (when Rob confirms CF localization is ON)

1. Create the four `Locales/_cf_<loc>.lua` shims from the templates above.
2. Register them in `MidnightHelper.toc` (Locales section).
3. Set the real `CF_LOCALIZATION_URL` in `TranslateNudge.lua`.
4. (Optional) add the CI Action after verifying its input schema.
5. `python tools/lint_addon.py` (HARD 0) + luac each new file.
6. Commit + push. First packaged release after this pulls in whatever the community has
   translated so far; untranslated keys fall back to enUS.
