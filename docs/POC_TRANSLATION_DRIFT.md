# Translation drift on SEASON-001

Second read-only proof of concept, 2026-07-27. **Nothing was written into the
addon.** Scope: one knowledge object, six translated locales, no change to the
other 38 articles.

---

## The model, reviewed

Transitional option B is the right shape and I would not change it. enUS canonical
and generated, six translations hand-maintained, the generator forbidden from
touching them, drift tracked rather than assumed away.

One thing to sharpen. Drift state is neither knowledge nor output — it is a
*relation* between a version of the knowledge and a locale. Keeping it outside the
Knowledge Object is right, and the reason is stronger than tidiness: if it lived in
the object, recording a finished translation would mean editing the canonical
source. Translators would be writing into the thing they translate *from*. That
inverts the ownership the whole architecture exists to establish.

---

## The smallest implementation

Two files, about eighty lines, no addon change.

**`translation_state.json`** — one entry, keyed by knowledge id:

```json
{
  "SEASON-001": {
    "canonical_hash": "3c7d5fecacd570a9",
    "locales": { "itIT": "3c7d5fec...", "nlNL": "3c7d5fec...", ... }
  }
}
```

A locale is current when its recorded hash equals the current canonical hash.

**`check_drift.py`** — recomputes and compares.

Two decisions inside it that matter more than the code:

**The hash covers canonical content, not rendered output.** Title plus points, in
order. Nothing about placement or markup. If the bullet character or the highlight
colour ever changes, enUS output changes but no translation becomes stale, because
the *meaning* did not move. Hashing the rendered string would have marked six
languages stale for a cosmetic change.

**enUS is not tracked.** It is generated, so it cannot drift — it is rewritten. The
first run listed it anyway and duly reported enUS as stale against itself, which is
nonsense, and nonsense in a report is how people learn to ignore reports.

## Proof that it detects drift

A checker that has never seen a positive proves nothing. So:

```
baseline                       all six current
change one canonical sentence  "Pick one lane." -> "Pick one lane and finish it."
re-run                         all six STALE, each showing the hash it came from
revert                         all six current again
```

The mutation was reverted; `SEASON-001.md` is unchanged.

## Scaling cost, stated plainly

`translation_state.json` needs one entry per knowledge object, and each entry needs
six recorded hashes. For 39 articles that is 39 entries — but only ever written by
the tool, never by hand, and only when a translation is finished. Nothing needs
back-filling: an object with no entry reports `UNKNOWN`, which is honest and is not
the same as stale.

---

## What a stale localised article should do

The question was (a) show the old translation with an internal warning, (b) fall
back to current enUS, or (c) something else.

**My recommendation is (a) as the default, with a deliberate escape hatch — and no
warning shown to the player.**

### Why not (b)

Falling back to English looks like the safe choice and I do not think it is. It
treats English as neutral ground. For this project it is not: the beginner guide
exists *because* people want Dutch. Carola is the reason the nlNL pack is
hand-maintained at all.

Dropping six languages to English the moment a comma moves in the canonical text
punishes exactly the readers the translation was written for, and it punishes them
for something that is usually harmless. "Accurate but unreadable" is a different
failure, not a lesser one.

### Why (a), and where its limit is

A hash tells you *that* the canonical content changed. It cannot tell you
*whether it matters*. Most changes are clarifications: the season_end article
gained its stat-squish sentence today because Rob challenged a claim, and the Dutch
text without that sentence is not wrong, only less complete.

But some changes are corrections. If enUS ever changes from "gear is reset" to
"gear is not reset", the untouched Dutch is now actively false, and showing it is
precisely the thing the Never Lie Policy forbids.

So the default is to keep the translation, and the exception must be declarable:

```yaml
# in the knowledge object, on the change that warrants it
invalidates_translations: true   # this correction makes older translations WRONG,
                                 # not merely older
```

When set, those locales fall back to enUS until re-translated. Rare, deliberate,
and it is the author who knows which kind of change they just made — no heuristic
can.

This is the same species as `deliberately_not_claimed`: a field that exists to
record a judgement the format cannot infer.

### Why no player-facing warning

A banner reading "this text may be out of date" on text that is almost always fine
teaches people to ignore banners, and it makes the addon look unreliable for a
maintenance detail they cannot act on. Staleness is a maintainer's problem.

Surface it where a maintainer looks: the drift report, and later a CI warning.
ChatGPT's instinct to warn rather than block is right — addon work stays the
priority, and a red build over a pending translation would invert that.

### Honest about what this is

This is a judgement between two harms, not a derivation. The trade is: (a) risks
showing an outdated-but-true sentence, (b) guarantees showing an accurate sentence
in a language the reader may struggle with. I weight (a) higher because the
failure it risks is rare and recoverable, and because the audience for a
translated beginner guide is the audience least served by English.

If a substantive correction ever ships and the flag is forgotten, that judgement
will have cost something real. Worth revisiting the first time it happens.
