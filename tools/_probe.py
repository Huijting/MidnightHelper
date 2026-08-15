# -*- coding: utf-8 -*-
"""Scratch script — rewritten per task, always run as tools/_probe.py.

Right now: what does Rob's client already say about Coin vs Soul?

The Corrosive Codex spec asks for "the currency ID of Corrosive Souls" and a
balance read from the currency UI. The Codex article we shipped today says the
opposite on the game's own authority: Coin is the currency, Soul is an item.
Before building anything on either claim, read what /mh atal already harvested
— currencies and bag items both — instead of running a new probe for an answer
that may be sitting in the file.
"""
import io
import re
import sys

for _s in (sys.stdout, sys.stderr):
    try:
        _s.reconfigure(encoding="utf-8", errors="replace")
    except (AttributeError, ValueError):
        pass

P = (r'E:\World of Warcraft\_retail_\WTF\Account\JOEYWHATEVER'
     r'\SavedVariables\MidnightHelper.lua')

t = io.open(P, encoding='utf-8', errors='replace', newline='').read()


def block(key, src):
    i = src.find('["%s"]' % key)
    if i < 0:
        return None
    s = src.index('{', i)
    d, j = 0, s
    while j < len(src):
        if src[j] == '{':
            d += 1
        elif src[j] == '}':
            d -= 1
            if d == 0:
                break
        j += 1
    return src[s:j + 1]


def entries(blob):
    out, d, buf = [], 0, ''
    for ch in blob[1:-1]:
        if ch == '{':
            d += 1
        if d > 0:
            buf += ch
        if ch == '}':
            d -= 1
            if d == 0:
                out.append(buf)
                buf = ''
    return out


def f(chunk, name):
    m = re.search(r'\["%s"\]\s*=\s*("(?:[^"\\]|\\.)*"|true|false|[\d.-]+)' % name, chunk)
    if not m:
        return None
    v = m.group(1)
    if v.startswith('"'):
        return v[1:-1]
    if v in ('true', 'false'):
        return v == 'true'
    return v


probe = block('atalProbe', t)
if not probe:
    print('geen atalProbe in de SavedVariables')
    sys.exit(1)

for name in ('currencies', 'items'):
    b = block(name, probe)
    print('=' * 72)
    print(name.upper())
    print('=' * 72)
    if not b:
        print('  (niet aanwezig)')
        print()
        continue
    rows = entries(b)
    if not rows:
        print('  (leeg — dat is een meting, geen ontbrekende data)')
    for e in rows:
        bits = []
        for k in ('id', 'name', 'quantity', 'count', 'maxQuantity',
                  'totalEarned', 'link', 'where', 'source'):
            v = f(e, k)
            if v is not None:
                bits.append('%s=%s' % (k, v))
        print('  ' + '  '.join(bits))
    print()
