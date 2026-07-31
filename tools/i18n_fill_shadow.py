#!/usr/bin/env python3
"""Which fill() translations can never apply, because the pack already copied enUS?

deDE.lua and its siblings build their pack by walking ns._mhLocales.enUS and
copying every key, using OVERRIDES where they have one and the ENGLISH string
where they do not. That happens at .toc line 28. Translations2026.lua and
TranslationsS2.lua run at lines 45-46 with a fill() that only writes when
t[k] == nil -- and after the copy, nothing is nil.

So a fill can only land for a key that did NOT yet exist in enUS when the pack was
built, i.e. one added by a later Locales/ file (Codex, DelveTips, SettingsPage...).
Any fill for a key living in the main enUS.lua is a no-op: the German player sees
English, and every count we take from source says otherwise.

Usage: python tools/i18n_fill_shadow.py
"""

import io
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
LOCALES = ROOT / "Locales"
TOC = ROOT / "MidnightHelper.toc"

KEY_RE = re.compile(r'^[ \t]*(?:([A-Z][A-Z0-9_]+)|\["([A-Z][A-Z0-9_]+)"\])\s*=')
FILL_RE = re.compile(r'fill\(\s*"(\w+)"')
# The packs that build themselves by copying enUS.
COPY_RE = re.compile(r"ns\._mhLocales\.enUS")


def toc_order():
    order = []
    for line in TOC.read_text(encoding="utf-8", errors="replace").splitlines():
        line = line.strip()
        if line.lower().startswith("locales\\") and line.lower().endswith(".lua"):
            order.append(line.split("\\")[-1])
    return order


def keys_in(path):
    out = []
    for line in path.read_text(encoding="utf-8", errors="replace").splitlines():
        m = KEY_RE.match(line)
        if m:
            out.append(m.group(1) or m.group(2))
    return out


def main():
    order = toc_order()
    copy_packs = []
    for name in order:
        p = LOCALES / name
        if p.exists() and COPY_RE.search(p.read_text(encoding="utf-8", errors="replace")):
            if name not in ("enUS.lua", "Locale.lua") and not name.startswith("Translations"):
                copy_packs.append(name)

    print("packs that copy enUS at build time: %s" % ", ".join(copy_packs))
    if not copy_packs:
        return

    # enUS keys that exist BEFORE the first copying pack loads -- those are the ones
    # the copy captures, and therefore the ones a later fill can never set.
    first_copy = min(order.index(n) for n in copy_packs)
    shadowed_keys = set()
    for name in order[:first_copy]:
        p = LOCALES / name
        if p.exists():
            shadowed_keys.update(keys_in(p))
    print("enUS keys already present when the first pack copies: %d\n" % len(shadowed_keys))

    for fname in ("Translations2026.lua", "TranslationsS2.lua"):
        p = LOCALES / fname
        if not p.exists():
            continue
        current = None
        dead, live = {}, {}
        for line in p.read_text(encoding="utf-8", errors="replace").splitlines():
            m = FILL_RE.search(line)
            if m:
                current = m.group(1)
                continue
            k = KEY_RE.match(line)
            if k and current:
                key = k.group(1) or k.group(2)
                bucket = dead if key in shadowed_keys else live
                bucket.setdefault(current, []).append(key)
        print("%s" % fname)
        for code in sorted(set(list(dead) + list(live))):
            d, l = len(dead.get(code, [])), len(live.get(code, []))
            print("   %-6s applies %4d   NEVER APPLIES %4d" % (code, l, d))
        sample = sorted({k for v in dead.values() for k in v})[:8]
        if sample:
            print("   examples that never apply: %s" % ", ".join(sample))
        print()


if __name__ == "__main__":
    main()
