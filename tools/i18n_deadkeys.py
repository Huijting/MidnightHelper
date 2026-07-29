#!/usr/bin/env python3
"""Find (and optionally remove) locale keys no code refers to any more.

Context: the per-class levelling guide was removed in 88907a2 but its ~1290 enUS
strings were left behind, and they still ship in enUS.lua, itIT.lua and nlNL.lua
in every download. The translation work package surfaced them; this removes them.

Liveness test is the same conservative one as tools/i18n_workpackage.py: a key is
LIVE unless no prefix of it, down to two segments, appears in the addon's Lua
outside Locales/. Prefixes because many keys are assembled at runtime.

Deletion is deliberately timid. Only a line that is a COMPLETE single-line entry
at one tab of indentation is removed:

    \\tKEY = "...",

Anything else -- a key inside a nested table, a value spanning lines, a bracket
form -- is reported and left alone. A locale file that will not compile afterwards
is far worse than a few strings we failed to tidy up.

Usage:
    python tools/i18n_deadkeys.py            # report only
    python tools/i18n_deadkeys.py --apply    # rewrite the locale files
"""

import io
import os
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
LOCALES = ROOT / "Locales"
EN = LOCALES / "enUS.lua"

# One tab, a SHOUTY key, an equals. The single tab is what keeps nested sub-keys
# (which sit deeper) out of the deletion set.
TOP_KEY_RE = re.compile(r'^\t([A-Z][A-Z0-9_]+)\s*=')
# A complete entry on one line: ends with a comma, and quotes balance out.
COMPLETE_RE = re.compile(r'^\t[A-Z][A-Z0-9_]+\s*=\s*.*,\s*$')


# Never delete these, however dead they look to a grep of our own Lua.
#
# BINDING_HEADER_* / BINDING_NAME_* are read by WoW itself, from globals, to label
# the Keybindings panel -- no addon code calls them, so the liveness test cannot
# see them. They are in fact unwired right now (Bindings.xml declares
# MIDNIGHTHELPER_TOGGLEMAIN, while the locale carries BINDING_NAME_TOGGLEMAIN, so
# the globals are never set and the panel shows raw names). That is a small bug
# with the fix already written; deleting the strings would throw away the fix.
KEEP_PREFIXES = ("BINDING_HEADER", "BINDING_NAME")


def code_text():
    parts = []
    for path in ROOT.rglob("*.lua"):
        if LOCALES in path.parents or path.parent.name == "tools":
            continue
        try:
            parts.append(path.read_text(encoding="utf-8", errors="replace"))
        except OSError:
            pass
    return "\n".join(parts)


def prefixes(key):
    parts = key.split("_")
    out = [key]
    for n in range(len(parts) - 1, 1, -1):
        out.append("_".join(parts[:n]) + "_")
    return out


def group_of(key):
    parts = key.split("_")
    return "_".join(parts[:2]) if len(parts) > 2 else key


def main():
    apply = "--apply" in sys.argv
    code = code_text()
    cache = {}

    def is_live(key):
        for p in prefixes(key):
            if p not in cache:
                cache[p] = p in code
            if cache[p]:
                return True
        return False

    en_keys = []
    for line in EN.read_text(encoding="utf-8", errors="replace").splitlines():
        m = TOP_KEY_RE.match(line)
        if m:
            en_keys.append(m.group(1))
    en_keys = sorted(set(en_keys))

    dead = sorted(
        k for k in en_keys
        if not is_live(k) and not k.startswith(KEEP_PREFIXES)
    )
    groups = {}
    for k in dead:
        groups.setdefault(group_of(k), []).append(k)

    print("enUS top-level keys: %d" % len(en_keys))
    print("dead (no code reference): %d in %d groups\n" % (len(dead), len(groups)))
    for g in sorted(groups, key=lambda g: (-len(groups[g]), g)):
        n = len(groups[g])
        sample = groups[g][0]
        print("  %-26s %5d   e.g. %s" % (g, n, sample))

    if not apply:
        print("\n(report only -- rerun with --apply to remove them)")
        return

    deadset = set(dead)
    total_removed, skipped = 0, []
    for path in sorted(LOCALES.glob("*.lua")):
        if path.name == "Locale.lua":
            continue
        text = path.read_text(encoding="utf-8", errors="replace")
        lines = text.split("\n")
        out, removed = [], 0
        for line in lines:
            m = TOP_KEY_RE.match(line)
            if m and m.group(1) in deadset:
                if COMPLETE_RE.match(line) and line.count('"') % 2 == 0:
                    removed += 1
                    continue
                skipped.append((path.name, m.group(1)))
            out.append(line)
        if removed:
            new = "\n".join(out)
            io.open(str(path) + ".tmp", "w", encoding="utf-8", newline="").write(new)
            os.replace(str(path) + ".tmp", str(path))
            total_removed += removed
            print("  %-24s -%d lines" % (path.name, removed))

    print("\nremoved %d lines" % total_removed)
    if skipped:
        print("LEFT ALONE (not a simple one-line entry) -- check by hand:")
        for fname, key in skipped[:40]:
            print("  %s  %s" % (fname, key))
        if len(skipped) > 40:
            print("  ... and %d more" % (len(skipped) - 40))


if __name__ == "__main__":
    main()
