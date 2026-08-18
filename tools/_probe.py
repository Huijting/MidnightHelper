# -*- coding: utf-8 -*-
"""Scratch script — rewritten per task, always run as tools/_probe.py.

Read the spot log. Rob marked two places while the arrow was misbehaving: in
the gate corridor (where it kept pointing back at the door he had just walked
through) and further in (where it finally pointed at the destination). The
map ids are the interesting part -- they say where the boundary actually is.
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


def f(chunk, name):
    m = re.search(r'\["%s"\]\s*=\s*("(?:[^"\\]|\\.)*"|true|false|[\d.-]+)'
                  % name, chunk)
    if not m:
        return None
    v = m.group(1)
    if v.startswith('"'):
        return v[1:-1]
    if v in ('true', 'false'):
        return v == 'true'
    return v


spots = block('spots', t)
if not spots:
    print('geen spots')
    sys.exit(0)

rows = split_top(spots)
print('%d plekken\n' % len(rows))
print('%-4s %-7s %-8s %-8s %-26s %s'
      % ('#', 'map', 'x', 'y', 'zone', 'doelwit / notitie'))
print('-' * 84)
for n, e in enumerate(rows, 1):
    label = f(e, 'target') or ''
    note = f(e, 'note')
    if note:
        label = (label + '  ' + note).strip()
    print('%-4d %-7s %-8s %-8s %-26s %s' % (
        n, f(e, 'mapID') or '?', f(e, 'x') or '?', f(e, 'y') or '?',
        (f(e, 'zone') or '?')[:26], label))
    when = f(e, 'when')
    if when:
        print('     %s' % when)
