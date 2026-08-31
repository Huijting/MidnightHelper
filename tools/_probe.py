#!/usr/bin/env python3
"""Why did `## Interface:` on line 1 escape both grep and my regex?

Suspect a UTF-8 BOM: the line would then start with \\ufeff rather than '#'. The addon
demonstrably loads, so this is about my tooling being blind, not about a broken toc -- but a
scanner that silently misses line 1 of every toc is worth knowing about.
"""
import io
import os

ADDONS = r"E:\World of Warcraft\_retail_\Interface\AddOns"

def first_bytes(p, n=8):
    with io.open(p, "rb") as fh:
        return fh.read(n)

mine = os.path.join(ADDONS, "MidnightHelper", "MidnightHelper.toc")
b = first_bytes(mine)
print("MidnightHelper.toc first bytes: %s" % " ".join("%02X" % x for x in b))
print("BOM present: %s" % (b[:3] == b"\xef\xbb\xbf"))

# How common is it across the other addons' tocs?
withbom, without = [], []
for name in sorted(os.listdir(ADDONS)):
    d = os.path.join(ADDONS, name)
    if not os.path.isdir(d):
        continue
    p = os.path.join(d, name + ".toc")
    if not os.path.exists(p):
        continue
    try:
        (withbom if first_bytes(p)[:3] == b"\xef\xbb\xbf" else without).append(name)
    except OSError:
        pass
print("\ntocs with a BOM: %d   without: %d" % (len(withbom), len(without)))
if withbom:
    print("with: %s" % ", ".join(withbom[:12]) + (" ..." if len(withbom) > 12 else ""))
