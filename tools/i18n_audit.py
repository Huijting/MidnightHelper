#!/usr/bin/env python3
"""
i18n_audit.py — Midnight Helper locale completeness audit.

Run LOCALLY (e.g. via Cursor), NOT through the Cowork sandbox mount — the mount
truncates large files and lies about what's present (it caused false "missing"
reports during the 2.0 prep). Locally the reads are reliable.

What it does
------------
- Scans every Locales/*.lua (except Locale.lua, the resolver).
- Collects the set of keys defined for each language pack, whether they live in
  a main file (`ns._mhLocales.enUS = { ... }`) or a topical merge block
  (`merge(ns._mhLocales and ns._mhLocales.deDE, { ... })`). This matters because
  most de/fr/es/pt content lives in the topical merges (GuideAdvisor, GuideTips,
  DelveTips, ...), not the small shell file.
- Compares each target pack against enUS and reports the keys that are MISSING
  (these fall back to English at runtime).
- Groups the missing keys by prefix so the output is digestible, and writes a
  full report next to this script.

Intentionally-English content
-----------------------------
Per docs/I18N_ROADMAP.md some things stay English in every pack and must NOT be
flagged as work:
  - In-STRING terms (Keys, Shards, Undercoin, ilvl, TomTom, most item names) —
    these live inside translated values, not as separate keys, so they never
    show up here anyway.
  - Whole key groups we deliberately leave on enUS fallback can be listed in
    IGNORE_PREFIXES below so they drop out of the "to translate" list.
Blizzard terms (Delve -> Tiefe/Gouffre/Profundidad, Great Vault -> Große
Schatzkammer/Grande chambre forte/Gran Bóveda/Grande Câmara) are translated, but
always in the official client form — see the term tables in the roadmap.

Usage
-----
    python tools/i18n_audit.py
    python tools/i18n_audit.py --lang deDE        # detail for one pack
    python tools/i18n_audit.py --report out.txt   # custom report path
"""

import argparse
import pathlib
import re
import sys

# Packs that ship in the .toc. koKR/zh*/ruRU have no pack -> nothing to audit.
KNOWN_LANGS = ["enUS", "nlNL", "deDE", "frFR", "esES", "ptBR", "itIT"]
# enUS is the source of truth; everything else is a translation target.
TARGETS = ["nlNL", "deDE", "frFR", "esES", "ptBR", "itIT"]

# Key prefixes (first underscore segment, or longer) that are deliberately left
# on enUS fallback in every pack. Add here when we consciously decide a group
# stays English; keep it small and documented. Empty by default.
IGNORE_PREFIXES = (
    "CHANGELOG",      # older changelog entries stay English (per the addon itself)
    "OMNIUM_RUNE",    # rune item names
    "WB_BOSS",        # world boss names
    "WB_ZONE",        # zone names (WB_ZONE_FMT is translated; the names stay English)
    "OMNIUM_MODE",    # Mythic+ / PvP / Raid game terms
    "PROFGUIDE_SUB",  # Dawncrests / Professions labels
    "TAB_OMNIUM",     # "Omnium Folio" proper name
)

# A locale entry can be written two ways, both at one indent level:
#   bare:     \tKEY = "..."
#   bracket:  \t["KEY"] = "..."   (used by the generated Phase C / group tables)
# Sub-keys of nested table VALUES are indented deeper / lowercase and skipped.
KEY_RE = re.compile(r'^\t+(?:([A-Z][A-Z0-9_]+)|\["([A-Z][A-Z0-9_]+)"\])\s*=')
# Inline block openers that directly carry the pack code:
#   ns._mhLocales.deDE = {                            (main file)
#   merge(ns._mhLocales and ns._mhLocales.deDE, {     (inline merge block)
NS_ASSIGN_RE = re.compile(r"ns\._mhLocales\.(\w+)\s*=\s*\{")
MERGE_INLINE_RE = re.compile(r"merge\(\s*ns\._mhLocales(?:\s+and\s+ns\._mhLocales)?\.(\w+)\s*,\s*\{")
# Translations2026.lua fill-only blocks:  fill("deDE", { ... })
FILL_INLINE_RE = re.compile(r'fill\(\s*"(\w+)"\s*,\s*\{')
# Named local table opener: `local SHARED_DE = {` / `local deDE_PHASE_C = {`.
LOCAL_OPEN_RE = re.compile(r"^\s*local\s+(\w+)\s*=\s*\{")
# Authoritative table->pack mapping from explicit merge calls of a NAMED table:
#   merge(ns._mhLocales.deDE or {}, SHARED_DE)  ->  SHARED_DE belongs to deDE
# (the `[^,]*` tolerates the `or {}` guard between target and table arg.)
MERGE_NAMED_RE = re.compile(r"merge\(\s*ns\._mhLocales\.(\w+)[^,]*,\s*([A-Za-z_]\w*)\s*\)")
# Direct per-key assignment: ns._mhLocales.deDE.KEY = / ns._mhLocales.deDE["KEY"] =
DIRECT_RE = re.compile(r'ns\._mhLocales\.(\w+)(?:\.([A-Z][A-Z0-9_]+)|\["([A-Z][A-Z0-9_]+)"\])\s*=')


def _value(line):
    """Raw enUS value text after the first '=', minus the trailing comma."""
    v = line.split("=", 1)[1].strip()
    return v[:-1].rstrip() if v.endswith(",") else v


def parse_file(path, keys, en_values=None):
    """Attribute every locale key to its pack, across all known block styles.

    Two passes so naming conventions don't matter: pass 1 reads the explicit
    `merge(ns._mhLocales.<pack>, <TABLE>)` calls to learn which named local
    table feeds which pack (covers SHARED_DE, GROUP_PT, deDE_PHASE_C, ...);
    pass 2 attributes keys to the current block's pack. Brace depth is NOT
    tracked, so `{`/`}` inside string values (e.g. {SPELL:123}) is harmless.

    When en_values is given, the English source text of each enUS key is also
    captured (for the translation worksheet).
    """
    lines = path.read_text(encoding="utf-8", errors="replace").splitlines()
    # Main pack files are named by their code (deDE.lua, frFR.lua, ...). Their
    # keys live in a `local OVERRIDES = { ... }` table assigned to the pack via
    # a loop (no merge() call), so default this file's language to the filename.
    file_lang = path.stem if path.stem in keys else None

    table_lang = {}
    for line in lines:
        m = MERGE_NAMED_RE.search(line)
        if m and m.group(1) in keys:
            table_lang[m.group(2)] = m.group(1)

    current = file_lang
    for line in lines:
        dm = DIRECT_RE.search(line)
        if dm and dm.group(1) in keys:
            k = dm.group(2) or dm.group(3)
            keys[dm.group(1)].add(k)
            if dm.group(1) == "enUS" and en_values is not None:
                en_values.setdefault(k, _value(line))
            continue
        if "{" in line:
            m = NS_ASSIGN_RE.search(line) or MERGE_INLINE_RE.search(line) or FILL_INLINE_RE.search(line)
            if m and m.group(1) in keys:
                current = m.group(1)
                continue
            lm = LOCAL_OPEN_RE.match(line)
            if lm:
                # mapped named table -> its pack; otherwise fall back to the
                # file's own language (OVERRIDES in deDE.lua), else None.
                current = table_lang.get(lm.group(1), file_lang)
                continue
        if current:
            km = KEY_RE.match(line)
            if km:
                k = km.group(1) or km.group(2)
                keys[current].add(k)
                if current == "enUS" and en_values is not None:
                    en_values.setdefault(k, _value(line))


def ignored(key):
    return any(key == p or key.startswith(p + "_") for p in IGNORE_PREFIXES)


def group_of(key):
    """Coarse grouping for the report: first two underscore segments."""
    parts = key.split("_")
    if len(parts) >= 2:
        return parts[0] + "_" + parts[1]
    return parts[0]


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--lang", help="show detailed missing keys for one pack")
    ap.add_argument("--report", default=None, help="report file path")
    args = ap.parse_args()

    root = pathlib.Path(__file__).resolve().parents[1]
    locdir = root / "Locales"
    if not locdir.is_dir():
        sys.exit(f"Locales/ not found under {root}")

    keys = {l: set() for l in KNOWN_LANGS}
    en_values = {}
    files = sorted(p for p in locdir.glob("*.lua") if p.name != "Locale.lua")
    for p in files:
        parse_file(p, keys, en_values)

    en = keys["enUS"]
    report_path = pathlib.Path(args.report) if args.report else root / "tools" / "i18n_missing_report.txt"

    lines = []
    lines.append("Midnight Helper — i18n audit")
    lines.append(f"scanned {len(files)} locale files; enUS reference keys: {len(en)}")
    lines.append("")
    lines.append(f"{'pack':6} {'have':>6} {'missing':>8}  coverage")
    for l in TARGETS:
        miss = {k for k in (en - keys[l]) if not ignored(k)}
        cov = 100.0 * (len(en) - len(miss)) / max(1, len(en))
        lines.append(f"{l:6} {len(keys[l]):>6} {len(miss):>8}  {cov:5.1f}%")
    lines.append("")

    for l in TARGETS:
        miss = sorted(k for k in (en - keys[l]) if not ignored(k))
        lines.append("=" * 60)
        lines.append(f"{l}: {len(miss)} keys missing (English fallback)")
        if not miss:
            lines.append("  (complete)")
            continue
        groups = {}
        for k in miss:
            groups.setdefault(group_of(k), []).append(k)
        lines.append("  by group:")
        for g, ks in sorted(groups.items(), key=lambda kv: (-len(kv[1]), kv[0])):
            lines.append(f"    {g:28} {len(ks):>4}")
        lines.append("  all missing keys:")
        for k in miss:
            lines.append(f"      {k}")

    text = "\n".join(lines) + "\n"
    report_path.write_text(text, encoding="utf-8")

    # Translation worksheets: each missing key WITH its English source text,
    # grouped by area, ready to translate. de/fr/es/pt share one worksheet
    # (their missing sets are the same new-feature keys); itIT gets its own.
    def write_worksheet(path, missing):
        out = [f"# {len(missing)} keys to translate — KEY <TAB> English source", ""]
        groups = {}
        for k in missing:
            groups.setdefault(group_of(k), []).append(k)
        for g, ks in sorted(groups.items(), key=lambda kv: (-len(kv[1]), kv[0])):
            out.append(f"## {g}  ({len(ks)})")
            for k in sorted(ks):
                out.append(f"{k}\t{en_values.get(k, '?')}")
            out.append("")
        pathlib.Path(path).write_text("\n".join(out) + "\n", encoding="utf-8")

    group4 = set()
    for l in ("deDE", "frFR", "esES", "ptBR"):
        group4 |= (en - keys[l])
    group4 = {k for k in group4 if not ignored(k)}
    ws4 = root / "tools" / "i18n_worksheet_defrespt.txt"
    wsit = root / "tools" / "i18n_worksheet_itIT.txt"
    write_worksheet(ws4, group4)
    write_worksheet(wsit, {k for k in (en - keys["itIT"]) if not ignored(k)})

    # Console summary (and per-lang detail if requested)
    print("\n".join(lines[: 4 + len(TARGETS) + 1]))
    print(f"\nfull report written to: {report_path}")
    print(f"de/fr/es/pt worksheet:  {ws4}  ({len(group4)} keys)")
    print(f"itIT worksheet:         {wsit}")
    if args.lang:
        miss = sorted(k for k in (en - keys.get(args.lang, set())) if not ignored(k))
        print(f"\n{args.lang}: {len(miss)} missing")
        for k in miss:
            print("  ", k)


if __name__ == "__main__":
    main()
