#!/usr/bin/env python3
"""What did the death recap record about the difficulty that refused it?

Retrospective.lua writes ns.db.cleuBlockedDiff when a CLEU registration is refused, and
ns.db.cleuAllowed when one succeeds. Both together answer the question the chat line did not:
which difficulty IDs are allowed, and which one Timewalking actually is on Rob's client.

⚠️ SavedVariables are flushed on logout/reload, so an entry missing here may mean "not written
yet" rather than "never happened". Say which, do not fold it into the answer.
"""
import io
import os
import re

SV = os.path.join("E:\\", "World of Warcraft", "_retail_", "WTF", "Account",
                  "JOEYWHATEVER", "SavedVariables", "MidnightHelper.lua")
text = io.open(SV, encoding="utf-8", errors="replace").read()
print("file mtime is what matters for freshness; size %.1f MB\n" % (len(text) / 1048576.0))


def block(name):
    m = re.search(r'\["%s"\]\s*=\s*\{' % re.escape(name), text)
    if not m:
        return None
    i = m.end() - 1
    depth = 0
    for j in range(i, len(text)):
        if text[j] == "{":
            depth += 1
        elif text[j] == "}":
            depth -= 1
            if depth == 0:
                return text[i:j + 1]
    return None


for key in ("cleuBlockedDiff", "cleuAllowed"):
    b = block(key)
    print("=" * 66)
    if b is None:
        # A scalar rather than a table is also possible.
        m = re.search(r'\["%s"\]\s*=\s*([^,\n]+)' % key, text)
        if m:
            print("%s = %s  (scalar, not a table)" % (key, m.group(1).strip()))
        else:
            print("%s: NOT PRESENT. Either it never fired, or the client has not written "
                  "SavedVariables since it did." % key)
        continue
    print("%s: %d chars" % (key, len(b)))
    print(" ".join(b.split())[:2000])
