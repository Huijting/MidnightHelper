#!/usr/bin/env python3
"""Validate a language expert's KEY/TEXT file against enUS, then patch the locale block.

Usage:  python tools/apply_agent_translation.py <lang> <keytext-file> [--write]

Without --write it only reports. Nothing is patched unless every check passes, because the
whole reason translators hand back KEY/TEXT instead of Lua is so that something reads the text
BEFORE it becomes code. Last round both of them emitted `-&gt;` for `->`; a translator writing
Lua directly would have shipped it.

⚠️ The checks below compare against the enUS line, not against a notion of good Spanish. That
is deliberate -- markup is the part a language expert cannot verify and a script can, and the
part where a mistake is invisible in review and fatal in game. Meaning stays the expert's job.
"""
import io
import os
import re
import sys

try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
LUA = os.path.join(ROOT, "Locales", "DelveTips.lua")
# Escapes an agent emits when it thinks in HTML. `-&gt;` shipped once; these are the family.
HTML = re.compile(r"&(?:gt|lt|amp|quot|apos|#\d+);")
SPELL = re.compile(r"\{SPELL:@[a-z0-9_]+\}")
FMT = re.compile(r"%[sd%]")


def blockbody(text, code):
    """Return (start, end) of a merge block's body, or None."""
    head = "merge(ns._mhLocales and ns._mhLocales.%s, {" % code
    i = text.find(head)
    if i < 0:
        return None
    j = text.find("\n})", i)
    return (i + len(head), j) if j > i else None


def parse_lua(body):
    """enUS writes bare keys, the appended packs write ["KEY"] -- accept both."""
    out = {}
    for m in re.finditer(r'^\t(?:\["([A-Z0-9_]+)"\]|([A-Z0-9_]+))\s*=\s*"((?:[^"\\]|\\.)*)"',
                         body, re.M):
        out[m.group(1) or m.group(2)] = m.group(3)
    return out


def parse_keytext(path):
    out, key = {}, None
    for raw in io.open(path, encoding="utf-8", errors="replace").read().splitlines():
        if raw.startswith("KEY:"):
            key = raw[4:].strip()
        elif raw.startswith("TEXT:") and key:
            out[key] = raw[5:].strip()
            key = None
        elif raw.startswith("NOTES:"):
            break
    return out


def main():
    if len(sys.argv) < 3:
        sys.exit(__doc__)
    code, src = sys.argv[1], sys.argv[2]
    write = "--write" in sys.argv

    text = io.open(LUA, encoding="utf-8", errors="replace").read()
    en_span = blockbody(text, "enUS")
    tgt_span = blockbody(text, code)
    if not en_span:
        sys.exit("no enUS block found -- has the file format changed?")
    if not tgt_span:
        sys.exit("no %s block found; this script patches an existing block, "
                 "it does not create one" % code)

    en = parse_lua(text[en_span[0]:en_span[1]])
    old = parse_lua(text[tgt_span[0]:tgt_span[1]])
    new = parse_keytext(src)
    print("enUS %d keys · %s block %d keys · file %d keys\n" % (len(en), code, len(old), len(new)))

    bad, warn = [], []
    for k, v in sorted(new.items()):
        e = en.get(k)
        if e is None:
            bad.append((k, "not an enUS key -- invented or misspelled"))
            continue
        if '"' in v:
            bad.append((k, 'contains a double quote, which cannot go in a Lua string'))
        m = HTML.search(v)
        if m:
            bad.append((k, "HTML escape %s -- write the character itself" % m.group(0)))
        if sorted(SPELL.findall(v)) != sorted(SPELL.findall(e)):
            bad.append((k, "spell placeholders differ from enUS:\n        en  %s\n        %s  %s"
                        % (sorted(SPELL.findall(e)), code, sorted(SPELL.findall(v)))))
        if sorted(FMT.findall(v)) != sorted(FMT.findall(e)):
            bad.append((k, "format specifiers differ: en %s vs %s"
                        % (FMT.findall(e), FMT.findall(v))))
        if v.count("|c") != v.count("|r"):
            bad.append((k, "unbalanced colour codes (%d |c, %d |r)" % (v.count("|c"), v.count("|r"))))
        # ⚠️ A warning, not an error: a language can legitimately need one more or one fewer
        # line than English. A difference bigger than one is almost always a dropped bullet.
        d = v.count("|n") - e.count("|n")
        if abs(d) > 1:
            warn.append((k, "%+d line breaks vs enUS (%d vs %d)" % (d, v.count("|n"), e.count("|n"))))
        elif d:
            warn.append((k, "%+d line break" % d))

    missing = sorted(set(old) - set(new))
    extra = sorted(set(new) - set(en))
    for k in missing:
        warn.append((k, "in the %s block but not in the file -- will keep its old text" % code))

    for k, why in bad:
        print("  🔴 %-42s %s" % (k, why))
    for k, why in warn:
        print("  ⚠️  %-42s %s" % (k, why))
    print("\n%d blocking, %d to look at, %d unknown keys" % (len(bad), len(warn), len(extra)))

    if bad:
        sys.exit("\nNOT patching. Fix the blocking problems first.")
    if not write:
        print("\nChecks pass. Re-run with --write to patch %s." % os.path.basename(LUA))
        return

    merged = dict(old)
    merged.update(new)
    body = "\n" + "\n".join('\t["%s"] = "%s",' % (k, merged[k]) for k in sorted(merged))
    out = text[:tgt_span[0]] + body + text[tgt_span[1]:]
    io.open(LUA + ".tmp", "w", encoding="utf-8", newline="").write(out)
    os.replace(LUA + ".tmp", LUA)
    print("\npatched %s: %d keys (%d changed)"
          % (code, len(merged), sum(1 for k in new if old.get(k) != new[k])))


main()
