# -*- coding: utf-8 -*-
"""Scratch script — rewritten per task, always run as tools/_probe.py.

Read the newest spot marks. Rob stood on the Timeworn Golem in The Ring of
Glory; the interesting part is the mapID, because GTFO's 3077 is an
instanceID and we have never had this delve's uiMapID.
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
rows = split_top(spots) if spots else []
print('%d plekken — de laatste vier:\n' % len(rows))
print('%-4s %-7s %-8s %-8s %-22s %s'
      % ('#', 'map', 'x', 'y', 'zone', 'doelwit / notitie'))
print('-' * 78)
for n, e in enumerate(rows, 1):
    if n <= len(rows) - 4:
        continue
    label = f(e, 'target') or '(geen naam — secret)'
    note = f(e, 'note')
    if note:
        label = (label + '  ' + note).strip()
    print('%-4d %-7s %-8s %-8s %-22s %s' % (
        n, f(e, 'mapID') or '?', f(e, 'x') or '?', f(e, 'y') or '?',
        (f(e, 'zone') or '?')[:22], label))

# What do we already record for this delve, and under which id?
print('\n' + '=' * 62)
print('Wat wij van The Ring of Glory hebben')
print('=' * 62)
hz = io.open(r'E:\World of Warcraft\_retail_\Interface\AddOns'
             r'\MidnightHelper\Modules\HazardData.lua',
             encoding='utf-8', errors='replace').read()
print('HazardData kent instance 3077 : %s'
      % ('ja' if '[3077]' in hz else 'NEE'))
print('en 388310 (Fissuring Slam)     : %s'
      % ('ja' if '388310' in hz else 'NEE'))

zones = block('hazardZones', t)
if zones:
    for m in re.finditer(r'\[(\d+)\]\s*=\s*"((?:[^"\\]|\\.)*)"', zones):
        print('geleerd: instance %-8s %s' % (m.group(1), m.group(2)))
