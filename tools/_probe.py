# -*- coding: utf-8 -*-
"""Scratch script — rewritten per task, always run as tools/_probe.py.

Right now, two reads from one /mh atal run:

  1. The quest ids added from Method today. The one that matters is 96528
     against 96466: both are the same unreleased Season 2 follow-up, so if one
     resolves and the other does not, "not live yet" stops being an
     explanation and 96466 is simply a wrong id.

  2. ns.db.hazardZones — Rob says he was standing in a delve, so the instance
     may have named itself. 3079 is the one worth having.
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


WANT = {
    '96004': 'known-good control (resolved 16 aug)',
    '96466': 'Method portal guide',
    '96528': 'Method Prey guide — the rival id',
    '97661': 'discovery: Protection of the Med\'jai',
    '97662': 'discovery: Winds of Tok\'jara',
    '97668': 'discovery: Watchful Gaze of Szarith',
    '97669': 'discovery: Luck of the Bound Spirit',
    '98388': 'Certain Doom / Into the Vaults (name disputed)',
    '97616': 'Corrosive Gifts: Corrosive Power',
    '97482': 'Azta\'rec nemesis delve',
    '96995': 'Turn Back the Surge',
    '96110': 'Captain Tokka',
}

probe = block('atalProbe', t)
rb = block('repeatable', probe) if probe else None
if not rb:
    print('geen repeatable-blok — is /mh atal gelopen vóór de reload?')
else:
    print('%-8s %-34s %-38s %s' % ('id', 'wat de client zegt', 'waarvoor', 'gevraagd'))
    print('-' * 100)
    seen = set()
    for e in split_top(rb):
        qid = f(e, 'id')
        if qid not in WANT:
            continue
        seen.add(qid)
        title = f(e, 'gameTitle')
        asked = f(e, 'askedServer')
        print('%-8s %-34s %-38s %s' % (
            qid, title or '— NIETS —', WANT[qid], 'ja' if asked else '-'))
    missing = [q for q in WANT if q not in seen]
    if missing:
        print('\nniet in de dump: %s' % ', '.join(sorted(missing)))

    print('\n' + '=' * 70)
    print('DE BESLISSENDE VERGELIJKING')
    print('=' * 70)
    got = {}
    for e in split_top(rb):
        qid = f(e, 'id')
        if qid in ('96004', '96466', '96528'):
            got[qid] = f(e, 'gameTitle')
    print('96004 (bestond al)      : %s' % (got.get('96004') or '— NIETS —'))
    print('96466 (Method portal)   : %s' % (got.get('96466') or '— NIETS —'))
    print('96528 (Method Prey)     : %s' % (got.get('96528') or '— NIETS —'))
    if got.get('96528') and not got.get('96466'):
        print('\n  → 96528 bestaat WEL en 96466 NIET, terwijl beide dezelfde')
        print('    nog-niet-live vervolgquest zouden zijn. "Komt pas na de reset"')
        print('    verklaart dat niet meer: 96466 is dan gewoon een fout id.')
    elif not got.get('96528') and not got.get('96466'):
        print('\n  → allebei stil. Dat kan nog steeds "nog niet live" zijn;')
        print('    deze meting beslist niets. Opnieuw na de reset.')
    elif got.get('96466'):
        print('\n  → 96466 bestaat wél. Mijn conclusie van 16 aug was fout.')

print('\n' + '=' * 70)
print('INSTANCES DIE ZICHZELF HEBBEN GENOEMD')
print('=' * 70)
hz = block('hazardZones', t)
if not hz:
    print('nog geen hazardZones — dan heeft de client nog niets geleerd.')
else:
    for m in re.finditer(r'\[(\d+)\]\s*=\s*"((?:[^"\\]|\\.)*)"', hz):
        note = ''
        if m.group(1) == '3079':
            note = '   <<< de onbekende'
        print('   %-8s %s%s' % (m.group(1), m.group(2), note))
