# -*- coding: utf-8 -*-
"""Scratch script — rewritten per task, always run as tools/_probe.py.

Right now: make the Vaults articles readable instead of merely correct.

Rob, looking at the finished page: "het is nog steeds een grote brei aan tekst
... kijk er zelf als een nitwit naar." He is right on both counts.

Two changes, and the second matters more than the first:

1. A blank line between bullets. Ten bullets flush against each other read as
   one block; the eye has nowhere to rest and nothing signals where one idea
   ends. His own suggestion, and it costs nothing.

2. Reorder. "How do I actually find a Temple Strike?" — the most practical
   question on the page — sat LAST, after three paragraphs about currencies.
   It went there because appending was easy, not because a reader would look
   there. It now follows the activity loop, which is the question that
   provokes it. Definitions move to the back where reference material belongs.

Applied to all three Vaults articles; the density is the same problem in each.
"""
import io
import os
import sys

for _s in (sys.stdout, sys.stderr):
    try:
        _s.reconfigure(encoding="utf-8", errors="replace")
    except (AttributeError, ValueError):
        pass

P = r'E:\World of Warcraft\_retail_\Interface\AddOns\MidnightHelper\Locales\Codex.lua'
KEYS = ('CODEX_ATALUTEK_BODY', 'CODEX_ATALUTEK_DISC_BODY', 'CODEX_ATALUTEK_DEAD_BODY')

t = io.open(P, encoding='utf-8', newline='').read()
if '|n|n•' in t:
    print('witregels staan er al')
    sys.exit(0)

eol = '\r\n' if '\r\n' in t else '\n'
lines = t.split(eol)
out = []
counts = {k: 0 for k in KEYS}

for line in lines:
    stripped = line.lstrip()
    key = None
    for k in KEYS:
        if stripped.startswith(k + ' = "'):
            key = k
            break
    if not key:
        out.append(line)
        continue

    indent = line[:len(line) - len(line.lstrip())]
    body = stripped[len(key) + 4:]
    assert body.endswith('",'), key
    body = body[:-2]

    # Split into bullets. The first chunk already starts with "• ".
    parts = body.split('|n•')
    bullets = [parts[0]] + ['•' + p for p in parts[1:]]

    if key == 'CODEX_ATALUTEK_BODY':
        # Move the last bullet (the Temple Strike how-to) to just after the
        # activity loop. The loop is bullet index 2 (0-based), so the practical
        # follow-up belongs at 3 — the question a reader asks next.
        assert len(bullets) >= 5, key
        strike = bullets.pop()
        bullets.insert(3, strike)

    body = '|n|n'.join(bullets)
    counts[key] += 1
    out.append('%s%s = "%s",' % (indent, key, body))

for k, n in counts.items():
    print('%-30s %d van 7' % (k, n))
if any(n != 7 for n in counts.values()):
    print('NIETS geschreven — alles of niets')
    sys.exit(1)

io.open(P + '.tmp', 'w', encoding='utf-8', newline='').write(eol.join(out))
os.replace(P + '.tmp', P)
print('geschreven')
