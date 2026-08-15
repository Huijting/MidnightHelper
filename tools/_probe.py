# -*- coding: utf-8 -*-
"""Scratch script — rewritten per task, always run as tools/_probe.py.

Right now: did the twelve Corrosive Codex power names resolve to spell ids?

Control first. "Auto Attack" must have resolved, or twelve empty answers say
nothing about the powers and everything about the lookup.
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


probe = block('atalProbe', t)
if not probe:
    print('geen atalProbe')
    sys.exit(1)

ctrl = re.search(r'\["powerControl"\]\s*=\s*(true|false)', probe)
print('CONTROLE "Auto Attack" resolved: %s'
      % (ctrl.group(1) if ctrl else 'niet opgeslagen'))
if ctrl and ctrl.group(1) == 'false':
    print('De lookup werkt niet. Alles hieronder zegt niets over de powers.')
print()

pb = block('powers', probe)
if not pb:
    print('geen powers-blok — draaide de oude probe nog?')
    sys.exit(1)

print('%-24s %-10s %-8s %s' % ('power', 'spellID', 'known', 'aura nu'))
print('-' * 62)
found = 0
for r in split_top(pb):
    nm = re.search(r'\["name"\]\s*=\s*"((?:[^"\\]|\\.)*)"', r)
    sid = re.search(r'\["spellID"\]\s*=\s*(\d+)', r)
    kn = re.search(r'\["known"\]\s*=\s*(true|false)', r)
    au = re.search(r'\["hasAura"\]\s*=\s*(true|false)', r)
    if sid:
        found += 1
    print('%-24s %-10s %-8s %s' % (
        (nm.group(1) if nm else '?'),
        sid.group(1) if sid else '—',
        kn.group(1) if kn else '-',
        au.group(1) if au else '-'))

print()
print('%d van de 12 namen leverden een spell-id op.' % found)
