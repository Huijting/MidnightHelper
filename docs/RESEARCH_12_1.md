# Patch 12.1 research — curated summary

> This file is a curated summary. The automatically generated PTR watch files and
> measured research documents are the underlying source material.

**Sources, in order of authority:**

| File | What it is | Maintained by |
|---|---|---|
| `docs/PTR_S2_ENCOUNTERS.md` | Season 2 dungeon/raid/lair ids, read from the Encounter Journal | measured, 2026-07-27 |
| `docs/PTR_DELVE_SCAN.md` | Delves the client offers, with poi ids and coordinates | measured, 2026-07-27 |
| `docs/PTR_VALEERA_TREE.md` | Valeera's full companion trait tree | measured, 2026-07-27 |
| `docs/CREST_SOURCES_MEASURED.md` | Crest sources and ilvl ranges per tier | measured, 2026-07-22 |
| `docs/PTR_12.1_WATCH.md` | Daily 12.1 news scan | written automatically |
| `docs/PTR_12.0.7_DATA.md` | Daily live-patch data scan | written automatically |

Do not copy datasets in here. Update this file only when a **conclusion**, a
**confidence level**, a **conflict** or an **implementation decision** changes.

Per-value evidence status lives in `docs/EVIDENCE_REGISTER.md`.

---

## Officially confirmed

Nothing about dates. **Blizzard has announced no release date for patch 12.1 or for
Season 2.** Blizzard has announced that Season 1 ends "soon", without a date.

## Live verified (12.0.7)

The Season 1 achievements that expire are all real and all readable: 61797, 61798,
61799 and 62351, plus 61808 which nobody announced. All are hidden Feats of Strength —
invisible to a walk of the achievement categories, findable only by sweeping ids. The
nemesis is spelled **Nullaeus**, per the client's own text.

The weekly crest cap that several guides describe **does not exist**; every tier reports
a maximum of 0.

## PTR / provisional (build 120100, release candidate 68914)

Season 2's eight dungeons, its raid and the Tidebound Grotto lair are measured and
implemented, all season-gated. Three counts cross-check against the patch notes, which
is the main reason to trust the rest.

Valeera gains a Poisons choice node. The three spell ids are measured; **what they do is
not known to us**, because the effect descriptions in circulation were attached to ids
the client does not have.

~~Auras have not gone secret on the release candidate.~~ **RETRACTED 2026-07-28.**
`ShouldAurasBeSecret` did read false in the open world and inside a delve, but both
readings were taken standing still, OUT OF COMBAT -- and that is the one state where
the answer is always false. JustAC 4.55.0 models the flag as flipping at combat
edges, and falls back to `IS_MIDNIGHT_OR_LATER and InCombatLockdown()` when the API
is missing, i.e. secret IN combat, validated in-game on 12.0.7 per its own comment.
Moved to Unresolved below.

The one real 12.1 bug in the addon — combat warnings erroring during delve fights — is
fixed and confirmed silent across multiple fights.

## Datamined only

Three new delves (The Ring of Glory, Gnarldor Isle, Venomfall Deeps) and a new nemesis
(Azta'rec). None appeared in a scan of what the client currently offers, which is
expected: Season 2 opens after the patch, so a pre-season scan cannot see them either
way. Re-scan once the season is live before concluding anything.

Season 2 item levels are reported as +46 over Season 1. Used only to answer a question;
implemented nowhere.

## Unresolved

**Roleset — measured 2026-07-27, and it is not a blocker.** The system is already live on
build 120100. Every frame belongs to a roleset named `roleless` by default, and every
frame carries `IsRolesetFiltered()`, so this is checkable rather than a matter of hope.
Right now `GetActiveAllowedRolesets()` and `GetActiveBlockedRolesets()` both return empty
lists and nothing of ours is filtered.

The residual risk is one specific shape: an **active allowlist that does not include
`roleless`**. That is what "frames in an inactive roleset will never be shown" would mean
in practice, and it would take out every default frame at once -- ours and most other
addons'. Unknown: which content activates a list, and which roleset names exist. Both are
measurable with `/mh roleset` inside whatever content does it.

**Auras in combat.** The 27 July measurement was taken out of combat and therefore
says nothing about the state that matters. If auras are secret during a fight, three
things are affected and none of them have been checked: MissingBuff reading party
auras, the new dispel alert reading your own debuffs mid-fight, and CombatSafety.
`/mh auras` now prints the combat state so a reading can no longer be filed without
its condition.

**Party and raid auras.** Separately from the above, only the player's own auras have
been read at all. `/mh dispelprobe` exists for the ally side and has not been run.

**Dates.** The community projects 11/12 August for the patch and 18 August for Season 2,
derived from the release-candidate build. These are projections. They must not appear as
confirmed in the addon, the release notes, the CurseForge page, Notion, the book or
Discord.

## Conflicts retained

The Season 1 ending announcement named four rewards. Three of those names could not be
found in the client at first, which looked like the announcement being wrong. It was not:
the achievements exist as hidden Feats of Strength. **Both observations are kept** — the
names were right, and a category walk cannot see them.

Wowhead's Valeera poison spell ids and the client's disagree completely. Implementation
follows the client. The published effect descriptions are treated as unproven rather than
discarded, since only the ids were shown to be wrong.
