"""Scratch script — rewritten per task, always run as tools/_probe.py.

Right now: DAWNCREST_ROW_CAP_FMT in seven languages — "held of cap", for a
currency with a total cap and no weekly reset.
"""
import io
import os
import re
import sys

for _s in (sys.stdout, sys.stderr):
    try:
        _s.reconfigure(encoding="utf-8", errors="replace")
    except (AttributeError, ValueError):
        pass

BASE = r'E:\World of Warcraft\_retail_\Interface\AddOns\MidnightHelper\Locales'
K = 'DAWNCREST_ROW_CAP_FMT'

PACK = {
    'enUS': '%d  (of %d, the cap)',
    'nlNL': '%d  (van %d, het maximum)',
}
FILLS = {
    'deDE': '%d  (von %d, dem Maximum)',
    'frFR': '%d  (sur %d, le plafond)',
    'esES': '%d  (de %d, el m\u00e1ximo)',
    'ptBR': '%d  (de %d, o m\u00e1ximo)',
    'itIT': '%d  (su %d, il massimo)',
}

for text in list(PACK.values()) + list(FILLS.values()):
    assert '"' not in text, text

for code, text in PACK.items():
    p = os.path.join(BASE, '%s.lua' % code)
    t = open(p, encoding='utf-8', newline='').read()
    if K in t:
        print('%s: stond er al in' % code)
        continue
    nl = '\r\n' if '\r\n' in t else '\n'
    m = re.compile(r'^\tDAWNCREST_ROW_FMT = .*', re.M).search(t)
    if not m:
        print('%s: geen anker' % code)
        continue
    t = t[:m.end()] + nl + '\t%s = "%s",' % (K, text) + t[m.end():]
    io.open(p + '.tmp', 'w', encoding='utf-8', newline='').write(t)
    os.replace(p + '.tmp', p)
    print('%s: ok' % code)

p = os.path.join(BASE, 'Translations2026.lua')
t = open(p, encoding='utf-8', newline='').read()
if K in t:
    print('Translations2026: stond er al in')
else:
    nl = '\r\n' if '\r\n' in t else '\n'
    for code, text in FILLS.items():
        marker = 'fill("%s", {' % code
        start = t.rindex(marker)
        end = t.index('})', start)
        t = t[:end] + '\t%s = "%s",%s' % (K, text, nl) + t[end:]
    io.open(p + '.tmp', 'w', encoding='utf-8', newline='').write(t)
    os.replace(p + '.tmp', p)
    print('Translations2026: 5 talen')
