"""Scratch script — rewritten per task, always run as tools/_probe.py.

Right now: reshape DAWNCREST_ROW_CAP_FMT (it gains Blizzard's label and the
earned/max pair) and add DAWNCREST_SEASON_MAX as the fallback wording.
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

# %1 held · %2 Blizzard's label · %3 earned this season · %4 the cap
CAP = {
    'enUS': '%d  (%s %d / %d)',
    'nlNL': '%d  (%s %d / %d)',
    'deDE': '%d  (%s %d / %d)',
    'frFR': '%d  (%s %d / %d)',
    'esES': '%d  (%s %d / %d)',
    'ptBR': '%d  (%s %d / %d)',
    'itIT': '%d  (%s %d / %d)',
}
# Only used when Blizzard's global is missing.
SEASON = {
    'enUS': 'season max',
    'nlNL': 'seizoensmax',
    'deDE': 'Saisonmax',
    'frFR': 'max saison',
    'esES': 'm\u00e1x. temporada',
    'ptBR': 'm\u00e1x. da temporada',
    'itIT': 'max stagione',
}

for d in (CAP, SEASON):
    for code, text in d.items():
        assert '"' not in text, (code, text)

PACK = ('enUS', 'nlNL')
changed = 0

for code in PACK:
    p = os.path.join(BASE, '%s.lua' % code)
    t = open(p, encoding='utf-8', newline='').read()
    nl = '\r\n' if '\r\n' in t else '\n'
    pat = re.compile(r'^\tDAWNCREST_ROW_CAP_FMT = "(?:[^"\\]|\\.)*",', re.M)
    if not pat.search(t):
        print('%s: geen CAP-regel' % code)
        continue
    t = pat.sub('\tDAWNCREST_ROW_CAP_FMT = "%s",' % CAP[code], t, count=1)
    if 'DAWNCREST_SEASON_MAX' not in t:
        m = re.compile(r'^\tDAWNCREST_ROW_CAP_FMT = .*', re.M).search(t)
        t = t[:m.end()] + nl + '\tDAWNCREST_SEASON_MAX = "%s",' % SEASON[code] + t[m.end():]
    io.open(p + '.tmp', 'w', encoding='utf-8', newline='').write(t)
    os.replace(p + '.tmp', p)
    changed += 1
    print('%s: ok' % code)

p = os.path.join(BASE, 'Translations2026.lua')
t = open(p, encoding='utf-8', newline='').read()
nl = '\r\n' if '\r\n' in t else '\n'
for code in ('deDE', 'frFR', 'esES', 'ptBR', 'itIT'):
    marker = 'fill("%s", {' % code
    start = t.rindex(marker)
    end = t.index('})', start)
    seg = t[start:end]
    seg = re.sub(r'\tDAWNCREST_ROW_CAP_FMT = "(?:[^"\\]|\\.)*",',
                 '\tDAWNCREST_ROW_CAP_FMT = "%s",' % CAP[code], seg, count=1)
    if 'DAWNCREST_SEASON_MAX' not in seg:
        seg = seg + '\tDAWNCREST_SEASON_MAX = "%s",%s' % (SEASON[code], nl)
    t = t[:start] + seg + t[end:]
io.open(p + '.tmp', 'w', encoding='utf-8', newline='').write(t)
os.replace(p + '.tmp', p)
print('Translations2026: 5 talen')
