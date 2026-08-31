#!/usr/bin/env python3
"""Write a translation work file: the English source beside the current deDE/frFR value.

The agents translate FROM THE ENGLISH. The existing text is included only so they can see
what went wrong and avoid inheriting it -- patching the German would carry its errors
forward, which is how "Unterbrechen du" survived this long.
"""
import io
import os
import re
import sys

try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
PATH = os.path.join(REPO, "Locales", "DelveTips.lua")
OUT = os.path.join(os.environ.get("TEMP", REPO), "mh_delvetips_source.md")

CODES = ("enUS", "deDE", "frFR", "esES", "ptBR", "itIT", "nlNL")
BLOCK = re.compile(r'(?:fill|merge)\s*\([^)]*?(?:"|_mhLocales\.)(' + "|".join(CODES) + r')\b')
KEYLINE = re.compile(r'^[ \t]*(?:\["([A-Z0-9_]+)"\]|([A-Z0-9_]+))[ \t]*=[ \t]*"(.*)",?[ \t]*$')

vals = {c: {} for c in CODES}
order = []
current = None
for line in io.open(PATH, encoding="utf-8", errors="replace").read().splitlines():
    m = BLOCK.search(line)
    if m:
        current = m.group(1)
    if current is None:
        continue
    k = KEYLINE.match(line)
    if k:
        key = k.group(1) or k.group(2)
        vals[current][key] = k.group(3)
        if current == "enUS":
            order.append(key)

with io.open(OUT, "w", encoding="utf-8", newline="\n") as fh:
    fh.write("# DelveTips source — English, with the current German and French beside it\n\n")
    fh.write("%d keys. Translate FROM THE ENGLISH.\n\n" % len(order))
    for key in order:
        fh.write("## `%s`\n\n" % key)
        fh.write("**EN**\n```\n%s\n```\n\n" % vals["enUS"].get(key, "(missing)"))
        fh.write("**current deDE**\n```\n%s\n```\n\n" % vals["deDE"].get(key, "(missing)"))
        fh.write("**current frFR**\n```\n%s\n```\n\n" % vals["frFR"].get(key, "(missing)"))

print("written:", OUT)
print("keys: %s" % ", ".join("%s=%d" % (c, len(vals[c])) for c in CODES))
