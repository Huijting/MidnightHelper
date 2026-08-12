"""Scratch script — rewritten per task, always run as tools/_probe.py.

Right now: the seven Silvermoon category headings. Same shape as the pins —
`title` becomes `titleKey`, resolved through the locale.
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

# literal in UI.lua -> locale key
CATS = [
    ('Essential Services', 'SMC_CAT_ESSENTIAL'),
    ('Gear & Currency Vendors', 'SMC_CAT_VENDORS'),
    ('Travel', 'SMC_CAT_TRAVEL'),
    ('Quest Hubs', 'SMC_CAT_QUEST_HUBS'),
    ('Horde District (Horde only)', 'SMC_CAT_HORDE'),
    ('Professions', 'SMC_CAT_PROFESSIONS'),
    ('Gathering', 'SMC_CAT_GATHERING'),
]
ORDER = [k for _, k in CATS]

EN = {
    'SMC_CAT_ESSENTIAL': 'Essential Services',
    'SMC_CAT_VENDORS': 'Gear & Currency Vendors',
    'SMC_CAT_TRAVEL': 'Travel',
    'SMC_CAT_QUEST_HUBS': 'Quest Hubs',
    'SMC_CAT_HORDE': 'Horde District (Horde only)',
    'SMC_CAT_PROFESSIONS': 'Professions',
    'SMC_CAT_GATHERING': 'Gathering',
}
NL = {
    'SMC_CAT_ESSENTIAL': 'Basisvoorzieningen',
    'SMC_CAT_VENDORS': 'Gear- en currency-vendors',
    'SMC_CAT_TRAVEL': 'Reizen',
    'SMC_CAT_QUEST_HUBS': 'Questhubs',
    'SMC_CAT_HORDE': 'Horde-wijk (alleen Horde)',
    'SMC_CAT_PROFESSIONS': 'Beroepen',
    'SMC_CAT_GATHERING': 'Verzamelberoepen',
}
DE = {
    'SMC_CAT_ESSENTIAL': 'Wichtige Dienste',
    'SMC_CAT_VENDORS': 'Ausr\u00fcstungs- und W\u00e4hrungsh\u00e4ndler',
    'SMC_CAT_TRAVEL': 'Reisen',
    'SMC_CAT_QUEST_HUBS': 'Quest-Knotenpunkte',
    'SMC_CAT_HORDE': 'Horde-Viertel (nur Horde)',
    'SMC_CAT_PROFESSIONS': 'Berufe',
    'SMC_CAT_GATHERING': 'Sammelberufe',
}
FR = {
    'SMC_CAT_ESSENTIAL': 'Services essentiels',
    'SMC_CAT_VENDORS': '\u00c9quipement et marchands de monnaie',
    'SMC_CAT_TRAVEL': 'Voyage',
    'SMC_CAT_QUEST_HUBS': 'Centres de qu\u00eates',
    'SMC_CAT_HORDE': 'Quartier de la Horde (Horde uniquement)',
    'SMC_CAT_PROFESSIONS': 'M\u00e9tiers',
    'SMC_CAT_GATHERING': 'M\u00e9tiers de r\u00e9colte',
}
ES = {
    'SMC_CAT_ESSENTIAL': 'Servicios esenciales',
    'SMC_CAT_VENDORS': 'Equipo y vendedores de monedas',
    'SMC_CAT_TRAVEL': 'Viajes',
    'SMC_CAT_QUEST_HUBS': 'Centros de misiones',
    'SMC_CAT_HORDE': 'Distrito de la Horda (solo Horda)',
    'SMC_CAT_PROFESSIONS': 'Profesiones',
    'SMC_CAT_GATHERING': 'Profesiones de recolecci\u00f3n',
}
PT = {
    'SMC_CAT_ESSENTIAL': 'Servi\u00e7os essenciais',
    'SMC_CAT_VENDORS': 'Equipamento e vendedores de moedas',
    'SMC_CAT_TRAVEL': 'Viagens',
    'SMC_CAT_QUEST_HUBS': 'Centros de miss\u00f5es',
    'SMC_CAT_HORDE': 'Distrito da Horda (s\u00f3 Horda)',
    'SMC_CAT_PROFESSIONS': 'Profiss\u00f5es',
    'SMC_CAT_GATHERING': 'Profiss\u00f5es de recolha',
}
IT = {
    'SMC_CAT_ESSENTIAL': 'Servizi essenziali',
    'SMC_CAT_VENDORS': 'Equipaggiamento e mercanti di valute',
    'SMC_CAT_TRAVEL': 'Viaggi',
    'SMC_CAT_QUEST_HUBS': 'Centri missioni',
    'SMC_CAT_HORDE': 'Distretto dell\u2019Orda (solo Orda)',
    'SMC_CAT_PROFESSIONS': 'Professioni',
    'SMC_CAT_GATHERING': 'Professioni di raccolta',
}

PACK = {'enUS': EN, 'nlNL': NL}
FILLS = {'deDE': DE, 'frFR': FR, 'esES': ES, 'ptBR': PT, 'itIT': IT}

for table in list(PACK.values()) + list(FILLS.values()):
    for k, text in table.items():
        assert '"' not in text, (k, text)

for code, table in PACK.items():
    p = os.path.join(BASE, '%s.lua' % code)
    t = open(p, encoding='utf-8', newline='').read()
    if ORDER[0] in t:
        print('%s: stond er al in' % code)
        continue
    nl = '\r\n' if '\r\n' in t else '\n'
    m = re.compile(r'^\tSMC_PIN_WORLD_BOSS_WEEK = .*$', re.M).search(t)
    if not m:
        print('%s: geen anker' % code)
        continue
    block = nl.join('\t%s = "%s",' % (k, table[k]) for k in ORDER)
    t = t[:m.end()] + nl + block + t[m.end():]
    io.open(p + '.tmp', 'w', encoding='utf-8', newline='').write(t)
    os.replace(p + '.tmp', p)
    print('%s: ok' % code)

p = os.path.join(BASE, 'Translations2026.lua')
t = open(p, encoding='utf-8', newline='').read()
if ORDER[0] in t:
    print('Translations2026: stond er al in')
else:
    nl = '\r\n' if '\r\n' in t else '\n'
    for code, table in FILLS.items():
        marker = 'fill("%s", {' % code
        start = t.rindex(marker)
        end = t.index('})', start)
        block = nl.join('\t%s = "%s",' % (k, table[k]) for k in ORDER) + nl
        t = t[:end] + block + t[end:]
    io.open(p + '.tmp', 'w', encoding='utf-8', newline='').write(t)
    os.replace(p + '.tmp', p)
    print('Translations2026: 5 talen')

# UI.lua: title -> titleKey. CRLF, so never anchor a pattern on a bare \n.
t = open(UI, encoding='utf-8', newline='').read()
changed, missed = 0, []
for literal, key in CATS:
    # No `$`: these lines end in CRLF, so `$` sits after the \r and never matches.
    pat = re.compile(r'^\t\ttitle = "%s",' % re.escape(literal), re.M)
    new, n = pat.subn('\t\ttitleKey = "%s",' % key, t)
    if n == 1:
        t, changed = new, changed + 1
    else:
        missed.append('%s (%d)' % (literal, n))
if missed:
    print('UI.lua NIET aangepast: ' + ', '.join(missed))
print('UI.lua: %d kopjes op titleKey' % changed)
if changed:
    io.open(UI + '.tmp', 'w', encoding='utf-8', newline='').write(t)
    os.replace(UI + '.tmp', UI)
