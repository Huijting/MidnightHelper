# -*- coding: utf-8 -*-
"""Scratch script — rewritten per task, always run as tools/_probe.py.

Right now: did the flight-map learner record anything, and specifically
anything on map 2509 (Vaults of Atal'Utek)?

Rob's screenshot shows the Amani Windcaller is a GOSSIP npc, not a taxi map,
so the expectation is that 2509 holds only Mal'Tiki's real flight master (if
he opened that map at all) and nothing for the two internal hops. An empty
result here is informative rather than a failure -- but only if some OTHER
zone recorded something, which is the control.
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


seen = block('taxiSeen', t)
if not seen:
    print('geen taxiSeen in de SavedVariables.')
    print('⚠️ Dat betekent dat er GEEN enkele vliegkaart is uitgelezen — dus dit')
    print('   zegt niets over de Vaults in het bijzonder. Er is geen controle,')
    print('   dus de meting is onbeslist, niet negatief.')
    sys.exit(0)

# [mapID] = { ["Name"] = { ... }, ... }
zones = re.findall(r'\[(\d+)\]\s*=\s*\{', seen)
print('vliegkaarten waarvan iets is opgeschreven: %s' % (', '.join(zones) or 'geen'))
print()

for m in re.finditer(r'\["([^"\\]+)"\]\s*=\s*\{([^{}]*)\}', seen):
    name, body = m.group(1), m.group(2)

    def f(k):
        mm = re.search(r'\["%s"\]\s*=\s*("(?:[^"\\]|\\.)*"|[\d.-]+|true|false)' % k, body)
        if not mm:
            return None
        v = mm.group(1)
        return v[1:-1] if v.startswith('"') else v

    print('  %-32s x=%-8s y=%-8s node=%-6s via=%s' % (
        name, f('x') or '—', f('y') or '—', f('nodeID') or '—', f('via') or '—'))

print()
if '2509' in zones:
    print('✅ map 2509 (Vaults) is uitgelezen.')
else:
    print('⚠️ map 2509 (Vaults) staat er NIET bij.')
    print('   Klopt met de screenshot: de Amani Windcaller is een gossip-NPC,')
    print('   geen vliegkaart, dus er valt daar niets van pins te lezen.')
