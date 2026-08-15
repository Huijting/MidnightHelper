# -*- coding: utf-8 -*-
"""Scratch script — rewritten per task, always run as tools/_probe.py.

Right now: the two controls, then the twelve powers.

The second control is the one that decides. "A spell Rob does not have" must
resolve, or twelve blank ids say nothing about the powers and everything about
the API.
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


def flag(name):
    m = re.search(r'\["%s"\]\s*=\s*(true|false)' % name, probe)
    return m.group(1) if m else None


own, foreign = flag('powerControlOwn'), flag('powerControlForeign')
if own is None and foreign is None:
    print('De nieuwe controlevelden staan er niet — dit is nog de oude run.')
    sys.exit(1)

print('CONTROLE  spell die Rob HEEFT      : %s' % own)
print('CONTROLE  spell die Rob NIET heeft : %s' % foreign)
print()

pb = block('powers', probe)
print('%-24s %-10s %-8s %s' % ('power', 'spellID', 'known', 'aura nu'))
print('-' * 62)
found = 0
for r in split_top(pb or '{}'):
    nm = re.search(r'\["name"\]\s*=\s*"((?:[^"\\]|\\.)*)"', r)
    sid = re.search(r'\["spellID"\]\s*=\s*(\d+)', r)
    kn = re.search(r'\["known"\]\s*=\s*(true|false)', r)
    au = re.search(r'\["hasAura"\]\s*=\s*(true|false)', r)
    if sid:
        found += 1
    print('%-24s %-10s %-8s %s' % (
        (nm.group(1) if nm else '?'), sid.group(1) if sid else '—',
        kn.group(1) if kn else '-', au.group(1) if au else '-'))

print()
print('%d van de 12 namen leverden een spell-id op.' % found)
print()
if foreign == 'true' and found == 0:
    print('CONCLUSIE: de lookup reikt voorbij Robs eigen spellbook, en de twaalf')
    print('namen leveren niets op. Onder DEZE namen zijn het geen spells.')
elif foreign == 'false':
    print('CONCLUSIE: geen. De lookup vindt alleen spells die Rob zelf heeft,')
    print('dus twaalf lege regels zijn de vorm van de API, geen meting.')
elif found:
    print('CONCLUSIE: er zijn ids. Die gaan naar een datafile; de namen niet.')
