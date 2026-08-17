# -*- coding: utf-8 -*-
"""Scratch script — rewritten per task, always run as tools/_probe.py.

Right now: read back the second /mh mech run — 103 ids over 17 instances, and
the client's own name for each instance (3079, 2963, 2858 and 1592 are ones
this addon has never heard of).
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


probe = block('mechProbe', t)
if not probe:
    print('geen mechProbe — is /mh mech gelopen vóór de reload?')
    sys.exit(1)

print('gemeten om : %s' % (f(probe, 'askedAt') or '?'))
print('genoemd    : %s van %s   (%s vóór de serveraanvraag)'
      % (f(probe, 'named'), f(probe, 'total'), f(probe, 'namedFirstPass')))

ctrl = block('controls', probe)
imp = f(ctrl, 'impossibleName') if ctrl else None
print('controles  : onmogelijk id %s · eigen DBM-ids %s/%s'
      % ('LEEG ✅' if not imp else ('"%s" ❌ DODE RUN' % imp),
         f(ctrl, 'knownHits') if ctrl else '?',
         f(ctrl, 'knownTotal') if ctrl else '?'))

zones = block('zones', probe)
if not zones:
    sys.exit(1)

print('\n' + '=' * 74)
print('%-9s %-30s %-6s %s' % ('instance', 'naam volgens de client', 'via', 'genoemd'))
print('=' * 74)
blocks = split_top(zones)
for z in blocks:
    sp = block('spells', z)
    rows = split_top(sp) if sp else []
    named = sum(1 for e in rows if f(e, 'name'))
    print('%-9s %-30s %-6s %d/%d' % (
        f(z, 'instance') or '(geen)',
        f(z, 'zone') or '— client zegt niets —',
        f(z, 'zoneVia') or '—', named, len(rows)))

print('\n' + '=' * 74)
print('DE MECHANICS')
print('=' * 74)
for z in blocks:
    sp = block('spells', z)
    rows = split_top(sp) if sp else []
    print('\n%s — %s' % (f(z, 'instance') or '(geen instance)',
                        f(z, 'zone') or '— client zegt niets —'))
    for e in rows:
        nm = f(e, 'name')
        print('   %-10s %s' % (f(e, 'id'), nm if nm else '— niets —'))
