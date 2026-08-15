# -*- coding: utf-8 -*-
"""Scratch script — rewritten per task, always run as tools/_probe.py.

Right now: which trait tree spends item 273000?

A traitCurrencyID points at either a real currency or an item. The tree whose
currency resolves to item 273000 (Corrosive Soul) is the Corrosive Codex. The
config name, where the client supplies one, settles it without inference.
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
tb = block('traits', probe) if probe else None
if not tb:
    print('geen traits-blok')
    sys.exit(1)

print('%-7s %-6s %-28s %s' % ('tree', 'nodes', 'configName', 'currency -> waar wijst hij heen'))
print('-' * 100)
hit = []
for r in split_top(tb):
    tid = re.search(r'\["treeID"\]\s*=\s*(\d+)', r)
    nds = re.search(r'\["nodes"\]\s*=\s*(\d+)', r)
    nm = re.search(r'\["configName"\]\s*=\s*"([^"]*)"', r)
    cb = block('currencies', r)
    bits = []
    for c in (split_top(cb) if cb else []):
        def g(k):
            m = re.search(r'\["%s"\]\s*=\s*(-?\d+)' % k, c)
            return m.group(1) if m else '?'
        bits.append('tc=%s type=%s ->%s q=%s spent=%s'
                    % (g('traitCurrencyID'), g('currencyType'),
                       g('currencyTypesID'), g('quantity'), g('spent')))
        if g('currencyTypesID') == '273000':
            hit.append((tid.group(1) if tid else '?', nm.group(1) if nm else ''))
    print('%-7s %-6s %-28s %s' % (
        tid.group(1) if tid else '?', nds.group(1) if nds else '?',
        (nm.group(1) if nm else '')[:28], ' | '.join(bits) or '-'))

print()
if hit:
    for tid, nm in hit:
        print('>>> tree %s geeft ITEM 273000 (Corrosive Soul) uit  %s' % (tid, nm))
else:
    print('Geen enkele boom geeft item 273000 uit.')
    print('Als de controles er staan, is de Corrosive Codex GEEN C_Traits-boom.')
