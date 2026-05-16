# Release Checklist (CurseForge)

Use this before every release upload.

## Versioning

- [ ] Update version notes in `CHANGELOG.md`
- [ ] Confirm `.toc` metadata is correct:
  - [ ] `## Interface`
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

- [ ] Build the CurseForge zip: `powershell -ExecutionPolicy Bypass -File tools\package.ps1` → output `dist\MidnightHelper-<Version>.zip` (reads version from `.toc`; excludes `tools/`, `data/`, `docs/`, dev markdown, etc.)
- [ ] Zip root contains exactly `MidnightHelper/`
- [ ] No temporary files included (`.ps1`, local notes, debug dumps)
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
