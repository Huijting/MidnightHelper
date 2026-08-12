"""Scratch script — rewritten per task, always run as tools/_probe.py.

Right now: the last SMC pin with a literal description. It was already English,
so nobody saw the wrong language — but a literal string cannot be translated at
all, which is the same bug wearing a friendlier face.
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
UI = r'E:\World of Warcraft\_retail_\Interface\AddOns\MidnightHelper\UI.lua'
K = 'SMC_PIN_WORLD_BOSS_WEEK'

PACK = {
    'enUS': 'Opens Delves & Vault and routes to this week\u2019s world boss.',
    'nlNL': 'Opent Delves & Vault en zet de route naar de world boss van deze week.',
}
FILLS = {
    'deDE': '\u00d6ffnet Delves & Vault und legt die Route zum Weltboss dieser Woche.',
    'frFR': 'Ouvre Delves & Vault et trace l\u2019itin\u00e9raire vers le boss de monde de la semaine.',
    'esES': 'Abre Delves & Vault y traza la ruta hacia el jefe de mundo de esta semana.',
    'ptBR': 'Abre Delves & Vault e tra\u00e7a a rota at\u00e9 ao chefe de mundo desta semana.',
    'itIT': 'Apre Delves & Vault e traccia il percorso verso il boss mondiale di questa settimana.',
}

for text in list(PACK.values()) + list(FILLS.values()):
    assert '"' not in text, text[:40]

for code, text in PACK.items():
    p = os.path.join(BASE, '%s.lua' % code)
    t = open(p, encoding='utf-8', newline='').read()
    if K in t:
        print('%s: stond er al in' % code)
        continue
    nl = '\r\n' if '\r\n' in t else '\n'
    m = re.compile(r'^\tSMC_PIN_FISHING = .*$', re.M).search(t)
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

t = open(UI, encoding='utf-8', newline='').read()
pat = re.compile(r'^\t\t\t\tdescription = "(?:[^"\\]|\\.)*",\n', re.M)
new, n = pat.subn('\t\t\t\tdescKey = "%s",\n' % K, t)
print('UI.lua: %d vervangen' % n)
if n == 1:
    io.open(UI + '.tmp', 'w', encoding='utf-8', newline='').write(new)
    os.replace(UI + '.tmp', UI)
