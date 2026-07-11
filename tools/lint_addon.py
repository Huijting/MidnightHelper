#!/usr/bin/env python3
"""
Midnight Helper — addon data-integrity linter (Design Spec 06).

Catches the bug classes the changelog keeps showing — missing/typo'd locale
keys, unregistered files, duplicate keys, tabs that fall out of the search
index — BEFORE they ship. It touches no game data; it only guards that what the
code *names* actually *exists* (never-lie: no silently-broken displays).

Report-first, no auto-fix. HARD checks fail the build (exit 1); SOFT checks only
inform (locale parity, since EN fallback is by design).

Pure stdlib, regex-based (like the repo's other tools — no Lua runtime).

Usage:
    python tools/lint_addon.py                 # run all checks
    python tools/lint_addon.py --parity        # also print the full parity table
    python tools/lint_addon.py --dump-keys L   # print every defined key for locale L
"""

from __future__ import annotations

import os
import re
import sys

LOCALES = ["enUS", "deDE", "frFR", "esES", "ptBR", "itIT", "nlNL"]
LOCALE_FILE_RE = re.compile(r"^(deDE|frFR|esES|ptBR|itIT|nlNL)\.lua$")

# A defined key: `KEY =` or `["KEY"] =` at (mostly) top-level of a locale table.
KEY_BARE_RE = re.compile(r'^\s*([A-Z][A-Z0-9_]+)\s*=')
KEY_BRACKET_RE = re.compile(r'^\s*\[\s*"([A-Z][A-Z0-9_]+)"\s*\]\s*=')
# Inline batch style: `deDE.KEY = "..."` possibly several per line (semicolons).
KEY_DOTTED_RE = re.compile(r'\b(?:deDE|frFR|esES|ptBR|itIT|nlNL|enUS)\.([A-Z][A-Z0-9_]+)\s*=')

# Context switches inside multi-locale files.
CTX_MERGE_RE = re.compile(r'merge\(\s*ns\._mhLocales(?:\s+and\s+ns\._mhLocales)?\.(\w+)\s*,')
CTX_FILL_RE = re.compile(r'fill\(\s*"(\w+)"\s*,')
CTX_ENUS_TABLE_RE = re.compile(r'ns\._mhLocales\.enUS\s*=\s*\{')
CTX_DOTTED_LOCAL_RE = re.compile(r'local\s+(\w+)\s*=\s*ns\._mhLocales\.(\w+)\s+or')

# References.
REF_RE = re.compile(r'(?:ns:L|[^A-Za-z0-9_]VL)\(\s*(["\'])([A-Z][A-Z0-9_]+)\1')
# Dynamic reference we cannot statically resolve, e.g. ns:L("PRE_"..x).
REF_DYNAMIC_RE = re.compile(r'(?:ns:L|[^A-Za-z0-9_]VL)\(\s*["\'][A-Z0-9_]*["\']?\s*\.\.')


def repo_root() -> str:
    return os.path.dirname(os.path.dirname(os.path.abspath(__file__)))


def read_lines(path: str) -> list[str]:
    with open(path, "r", encoding="utf-8", errors="replace") as fh:
        return fh.read().splitlines()


def locale_files(root: str) -> list[str]:
    d = os.path.join(root, "Locales")
    return [os.path.join(d, f) for f in sorted(os.listdir(d)) if f.endswith(".lua")]


def collect_locale_keys(paths: list[str]):
    """Return defined[locale] -> {key: [(relpath, lineno), ...]}."""
    root = repo_root()
    defined = {loc: {} for loc in LOCALES}

    def add(loc, key, rel, ln):
        if loc not in defined:
            return
        defined[loc].setdefault(key, []).append((rel, ln))

    for path in paths:
        base = os.path.basename(path)
        try:
            rel = os.path.relpath(path, root).replace("\\", "/")
        except ValueError:
            rel = base  # external file on another drive
        if rel.startswith(".."):
            rel = base
        lines = read_lines(path)

        file_locale = None
        m = LOCALE_FILE_RE.match(base)
        if m:
            file_locale = m.group(1)  # whole-file context: this locale's OVERRIDES
        is_enus_file = base == "enUS.lua"

        ctx = file_locale or ("enUS" if is_enus_file else None)
        for i, line in enumerate(lines, 1):
            # context switches (multi-locale files)
            cm = CTX_MERGE_RE.search(line)
            if cm:
                ctx = cm.group(1)
            cf = CTX_FILL_RE.search(line)
            if cf:
                ctx = cf.group(1)
            if CTX_ENUS_TABLE_RE.search(line):
                ctx = "enUS"
            cl = CTX_DOTTED_LOCAL_RE.search(line)
            if cl:
                ctx = cl.group(2)

            # dotted inline assignments carry their own locale
            for dm in KEY_DOTTED_RE.finditer(line):
                # locale prefix is captured group-less; re-extract prefix
                pref = re.match(r'\s*.*?\b(deDE|frFR|esES|ptBR|itIT|nlNL|enUS)\.', line)
                if pref:
                    add(pref.group(1), dm.group(1), rel, i)

            if ctx is None:
                continue
            kb = KEY_BARE_RE.match(line)
            if kb:
                add(ctx, kb.group(1), rel, i)
                continue
            kk = KEY_BRACKET_RE.match(line)
            if kk:
                add(ctx, kk.group(1), rel, i)

    return defined


def collect_references(root: str):
    """Return (static_refs: {key: [(rel,line)]}, dynamic_count, ref_files)."""
    static = {}
    dynamic = 0
    targets = []
    for name in ("UI.lua", "Core.lua"):
        p = os.path.join(root, name)
        if os.path.isfile(p):
            targets.append(p)
    moddir = os.path.join(root, "Modules")
    if os.path.isdir(moddir):
        for f in sorted(os.listdir(moddir)):
            if f.endswith(".lua"):
                targets.append(os.path.join(moddir, f))
    for p in targets:
        rel = os.path.relpath(p, root).replace("\\", "/")
        for i, line in enumerate(read_lines(p), 1):
            for m in REF_RE.finditer(line):
                # a literal followed by `..` is a dynamic key prefix, not a key
                if line[m.end():].lstrip().startswith(".."):
                    dynamic += 1
                    continue
                static.setdefault(m.group(2), []).append((rel, i))
    return static, dynamic


def parse_toc(root: str) -> set[str]:
    toc = os.path.join(root, "MidnightHelper.toc")
    files = set()
    for line in read_lines(toc):
        s = line.strip()
        if s.lower().endswith(".lua") and not s.startswith("#"):
            files.add(s.replace("\\", "/"))
    return files


def find_orphans(root: str, toc_files: set[str]) -> list[str]:
    orphans = []
    for sub in ("Modules", "Locales"):
        d = os.path.join(root, sub)
        if not os.path.isdir(d):
            continue
        for f in sorted(os.listdir(d)):
            if f.endswith(".lua"):
                rel = f"{sub}/{f}"
                if rel not in toc_files:
                    orphans.append(rel)
    return orphans


def collect_indexed_tabs(root: str) -> set[str]:
    p = os.path.join(root, "Modules", "NavSearch.lua")
    ids = set()
    if os.path.isfile(p):
        for line in read_lines(p):
            for m in re.finditer(r'\btab\(\s*"[^"]+"\s*,\s*"([^"]+)"', line):
                ids.add(m.group(1))
    return ids


def collect_selecttab_ids(root: str) -> dict:
    """Best-effort: tab ids passed to ns.SelectTab("id") across modules/UI."""
    ids = {}
    targets = [os.path.join(root, n) for n in ("UI.lua", "Core.lua")]
    moddir = os.path.join(root, "Modules")
    if os.path.isdir(moddir):
        targets += [os.path.join(moddir, f) for f in os.listdir(moddir) if f.endswith(".lua")]
    for p in targets:
        if not os.path.isfile(p):
            continue
        rel = os.path.relpath(p, root).replace("\\", "/")
        for i, line in enumerate(read_lines(p), 1):
            for m in re.finditer(r'SelectTab\(\s*"([a-z][a-z0-9_]*)"', line):
                ids.setdefault(m.group(1), (rel, i))
    return ids


def main() -> int:
    root = repo_root()
    args = sys.argv[1:]
    lf = locale_files(root)
    defined = collect_locale_keys(lf)
    static_refs, dynamic = collect_references(root)
    toc_files = parse_toc(root)
    orphans = find_orphans(root, toc_files)

    if "--dump-keys" in args:
        loc = args[args.index("--dump-keys") + 1]
        for k in sorted(defined.get(loc, {})):
            print(k)
        return 0

    hard = 0
    soft = 0
    print("=" * 70)
    print("Midnight Helper — addon lint")
    print("=" * 70)

    # 1. Missing locale keys (HARD)
    enus = set(defined["enUS"])
    missing = sorted(k for k in static_refs if k not in enus)
    print(f"\n[1] Missing enUS keys (referenced by ns:L/VL but undefined): {len(missing)}")
    for k in missing[:60]:
        rel, ln = static_refs[k][0]
        print(f"    HARD  {k}   first ref {rel}:{ln}")
    if len(missing) > 60:
        print(f"    ... and {len(missing) - 60} more")
    hard += len(missing)
    print(f"    (statically checked {len(static_refs)} distinct keys; "
          f"{dynamic} dynamic refs skipped — blind spot, not checked)")

    # 2. Unregistered files (HARD)
    print(f"\n[2] Files not registered in .toc: {len(orphans)}")
    for o in orphans:
        print(f"    HARD  {o}")
    hard += len(orphans)

    # 3. Duplicate keys within a locale (HARD)
    dup_total = 0
    print("\n[3] Duplicate keys within a locale (last-wins silent override):")
    for loc in LOCALES:
        dups = {k: v for k, v in defined[loc].items() if len(v) > 1}
        if dups:
            dup_total += len(dups)
            print(f"    {loc}: {len(dups)} duplicated")
            for k, locs in list(sorted(dups.items()))[:12]:
                where = "  ".join(f"{r}:{n}" for r, n in locs)
                print(f"      HARD  {k}   {where}")
    if dup_total == 0:
        print("    none")
    hard += dup_total

    # 4. Search-index coverage (SOFT for now — best-effort)
    indexed = collect_indexed_tabs(root)
    seltabs = collect_selecttab_ids(root)
    not_indexed = sorted(t for t in seltabs if t not in indexed)
    print(f"\n[4] Tabs used via SelectTab but missing from NavSearch index: "
          f"{len(not_indexed)}  (SOFT/best-effort)")
    for t in not_indexed:
        rel, ln = seltabs[t]
        print(f"    warn  {t}   e.g. {rel}:{ln}")
    print(f"    (indexed tabs: {len(indexed)}; SelectTab ids seen: {len(seltabs)})")
    soft += len(not_indexed)

    # 5. Locale parity (SOFT — EN fallback is by design)
    print("\n[5] Locale parity (enUS keys without a native translation):")
    print(f"    enUS defines {len(enus)} keys")
    for loc in LOCALES:
        if loc == "enUS":
            continue
        gap = enus - set(defined[loc])
        pct = 100 * (len(enus) - len(gap)) / max(1, len(enus))
        print(f"    {loc}: {len(defined[loc]):5d} translated · "
              f"{len(gap):5d} still English · {pct:5.1f}% covered")
        soft += 0  # informational only
    if "--parity" in args:
        for loc in LOCALES:
            if loc == "enUS":
                continue
            gap = sorted(enus - set(defined[loc]))
            print(f"\n    --- {loc} missing {len(gap)} ---")
            for k in gap:
                print(f"      {k}")

    print("\n" + "=" * 70)
    print(f"HARD issues: {hard}   SOFT notes: {soft}")
    print("=" * 70)
    return 1 if hard else 0


if __name__ == "__main__":
    sys.exit(main())
