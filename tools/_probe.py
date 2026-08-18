# -*- coding: utf-8 -*-
"""Scratch script — rewritten per task, always run as tools/_probe.py.

Two reads from one reload: the criteria of the two achievements HandyNotes
added overnight (Coiled Isle Safari 62492, Mysterious Mixing 63432), and the
spot log Rob walked for the Amani Windcallers.
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


def block(key, src, bracket=False):
    needle = ('[%s]' % key) if bracket else ('["%s"]' % key)
    i = src.find(needle)
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


dump = block('achDump', t)
for aid in ('62492', '63432'):
    print('=' * 74)
    ach = block(aid, dump, bracket=True) if dump else None
    if not ach:
        print('%s — NIET in de dump' % aid)
        continue
    print('%s  %s' % (aid, f(ach, 'name') or '?'))
    print('=' * 74)
    crit = block('criteria', ach)
    if not crit:
        print('  geen criteria')
        continue
    rows = split_top(crit)
    print('  %d criteria' % len(rows))
    print('  %-4s %-38s %-10s %-8s %s'
          % ('#', 'naam', 'criteriaID', 'assetID', 'gedaan'))
    print('  ' + '-' * 70)
    for e in rows:
        print('  %-4s %-38s %-10s %-8s %s' % (
            f(e, 'index') or '?',
            (f(e, 'name') or '?')[:38],
            f(e, 'criteriaID') or '— GEEN —',
            f(e, 'assetID') or '-',
            'ja' if f(e, 'completed') else 'nee'))

print('\n' + '=' * 74)
print('SPOT LOG — /mh here')
print('=' * 74)
spots = block('spots', t)
if not spots:
    print('geen spots — is /mh here gelopen vóór de reload?')
else:
    rows = split_top(spots)
    print('%d plek%s' % (len(rows), 'ken' if len(rows) != 1 else ''))
    print('%-4s %-7s %-8s %-8s %-26s %s'
          % ('#', 'map', 'x', 'y', 'zone', 'doelwit / notitie'))
    print('-' * 74)
    for n, e in enumerate(rows, 1):
        label = f(e, 'target') or ''
        note = f(e, 'note')
        if note:
            label = (label + '  ' + note).strip()
        print('%-4d %-7s %-8s %-8s %-26s %s' % (
            n, f(e, 'mapID') or '?', f(e, 'x') or '?', f(e, 'y') or '?',
            (f(e, 'zone') or '?')[:26], label))
