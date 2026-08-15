# -*- coding: utf-8 -*-
"""Scratch script — rewritten per task, always run as tools/_probe.py.

Right now: the soul ledger's first real test.

The Codex UI shows 3 souls; the probe measured 13 this afternoon. If ten were
spent, the ledger built a few hours ago should have written that down — and if
it did not, the ledger is broken and better to know now than after a week.
"""
import io
import re
import sys
import datetime

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


def split_top(blob):
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


lb = block('soulLedger', t)
if lb is None:
    print('geen soulLedger in de SavedVariables.')
    print('Het grootboek heeft dus nog nooit een verandering gezien.')
    sys.exit(0)

rows = split_top(lb)
print('grootboek: %d regel(s)' % len(rows))
print()
if not rows:
    print('LEEG. Er is sinds vanmiddag geen verandering in item 273000 gezien.')
    print('Als het aantal wel veranderd IS, luistert de watcher naar het')
    print('verkeerde event of leest hij het verkeerde item.')
    sys.exit(0)

print('%-19s %6s %6s %7s  %s' % ('wanneer', 'van', 'naar', 'delta', 'laatste quest (sec geleden)'))
print('-' * 88)
for r in rows:
    def g(k):
        m = re.search(r'\["%s"\]\s*=\s*(-?\d+)' % k, r)
        return int(m.group(1)) if m else None
    qt = re.search(r'\["questTitle"\]\s*=\s*"((?:[^"\\]|\\.)*)"', r)
    at, fr, to, dl = g('at'), g('from'), g('to'), g('delta')
    secs, q = g('secondsSinceQuest'), g('quest')
    when = datetime.datetime.fromtimestamp(at).strftime('%Y-%m-%d %H:%M:%S') if at else '?'
    ctx = ''
    if q:
        ctx = '%s (%s)  %ss' % (qt.group(1) if qt else '?', q,
                                secs if secs is not None else '?')
    print('%-19s %6s %6s %+7d  %s' % (when, fr, to, dl or 0, ctx))
