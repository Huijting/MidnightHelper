# -*- coding: utf-8 -*-
"""Scratch script — rewritten per task, always run as tools/_probe.py.

Right now: read ns.db.achDump for 62601 (Soft Underbelly) and 63601 (Oppose
the Foes). The criteria IDs are the whole point; the names are the check that
the right achievement was read.
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
if not dump:
    print('geen achDump — is /mh ach id gelopen vóór de reload?')
    sys.exit(1)

for aid in ('62601', '63601'):
    ach = block(aid, dump, bracket=True)
    print('=' * 66)
    if not ach:
        print('%s — NIET in de dump' % aid)
        continue
    print('%s  %s' % (aid, f(ach, 'name') or '?'))
    print('=' * 66)
    crit = block('criteria', ach)
    if not crit:
        print('  geen criteria-blok')
        continue
    print('  %-4s %-34s %-10s %-8s %s'
          % ('#', 'naam', 'criteriaID', 'assetID', 'gedaan'))
    print('  ' + '-' * 62)
    for e in split_top(crit):
        print('  %-4s %-34s %-10s %-8s %s' % (
            f(e, 'index') or '?',
            f(e, 'name') or '?',
            f(e, 'criteriaID') or '— GEEN —',
            f(e, 'assetID') or '-',
            'ja' if f(e, 'completed') else 'nee'))

print('\n' + '=' * 66)
print('Ter vergelijking: een hunt die we al shippen, zelfde vorm')
print('=' * 66)
for aid in ('63359',):
    ach = block(aid, dump, bracket=True)
    if not ach:
        print('%s staat niet in de dump — niet erg, alleen geen controle.' % aid)
        continue
    crit = block('criteria', ach)
    rows = split_top(crit) if crit else []
    print('%s %s — %d criteria, eerste id %s'
          % (aid, f(ach, 'name') or '?', len(rows),
             f(rows[0], 'criteriaID') if rows else '?'))
