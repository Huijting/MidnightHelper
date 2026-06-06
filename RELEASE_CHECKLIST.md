# Release Checklist (CurseForge)

Use this before every release upload.

## Versioning

- [ ] Update version notes in `CHANGELOG.md`
- [ ] Confirm `.toc` metadata is correct:
  - [ ] `## Interface` — supports multiple comma-separated versions (e.g. `120005, 120007` for live + PTR). **At a patch release: drop the old version** (e.g. remove `120005` once 12.0.7 is live) so the addon isn't flagged compatible with a client it no longer targets
  - [ ] `## Title`
  - [ ] `## Notes`
  - [ ] `## SavedVariables`

## Functional QA

- [ ] Addon loads without Lua errors
- [ ] Main window opens via `/mh`
- [ ] Delves panel renders correctly
- [ ] Great Vault rows show expected status
- [ ] Alt snapshot updates after relog/event updates
- [ ] English locale looks correct
- [ ] Dutch locale looks correct
- [ ] Optional TomTom flow still works (if installed)

## Packaging

- [ ] Build the CurseForge zip: `powershell -ExecutionPolicy Bypass -File tools\package.ps1` → output `dist\MidnightHelper-<Version>.zip` (reads version from `.toc`; excludes `tools/`, `data/`, `docs/`, dev markdown, **`Sync-MidnightHelper.bat`**, other `*.bat` / `*.ps1` / `*.py`, etc.)
- [ ] Zip root contains exactly `MidnightHelper/`
- [ ] **No `.bat`, `.cmd`, `.ps1`, `.exe`, or `.py` in the zip** — `package.ps1` fails the build if any slip through (CF moderation rejects them)
- [ ] No temporary files included (local notes, debug dumps)
- [ ] No secrets or personal files included

## CurseForge Project Page

- [ ] Description matches current feature set
- [ ] At least 3 fresh screenshots uploaded
- [ ] Changelog pasted for this release
- [ ] Correct game version selected
- [ ] Correct release type selected (Release/Beta/Alpha)

## Post-release

- [ ] Smoke test installed zip on a clean AddOns folder
- [ ] Verify project page renders correctly
- [ ] Check first feedback/issues after publish
