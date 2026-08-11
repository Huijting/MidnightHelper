"""Scratch script — rewritten per task, always run as tools/_probe.py.

Right now: three keys for the setup nudge, seven languages.
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
ORDER = ['SETUPNUDGE_TITLE', 'SETUPNUDGE_BODY', 'SETUPNUDGE_BTN']

PACK = {
    'enUS': {
        'SETUPNUDGE_TITLE': 'Let Midnight Helper set up your bars?',
        'SETUPNUDGE_BODY': 'Your spells can be placed for you and your keys bound to them, per specialisation. It shows you what would change before anything moves, and everything can be undone.|n|nAlready happy with your bars? Dismiss this and it will not come back.',
        'SETUPNUDGE_BTN': 'Show me',
    },
    'nlNL': {
        'SETUPNUDGE_TITLE': 'Zal Midnight Helper je balken inrichten?',
        'SETUPNUDGE_BODY': 'Je spells kunnen voor je neergezet worden en je toetsen eraan gebonden, per specialisatie. Je ziet eerst wat er zou veranderen, en alles is terug te draaien.|n|nTevreden met je balken zoals ze zijn? Klik dit weg en het komt niet terug.',
        'SETUPNUDGE_BTN': 'Laat maar zien',
    },
}
FILLS = {
    'deDE': {
        'SETUPNUDGE_TITLE': 'Soll Midnight Helper deine Leisten einrichten?',
        'SETUPNUDGE_BODY': 'Deine Zauber k\u00f6nnen f\u00fcr dich abgelegt und deine Tasten darauf belegt werden, pro Spezialisierung. Du siehst vorher, was sich \u00e4ndern w\u00fcrde, und alles ist r\u00fcckg\u00e4ngig zu machen.|n|nZufrieden mit deinen Leisten? Weglegen, dann kommt es nicht wieder.',
        'SETUPNUDGE_BTN': 'Zeig es mir',
    },
    'frFR': {
        'SETUPNUDGE_TITLE': 'Laisser Midnight Helper configurer vos barres ?',
        'SETUPNUDGE_BODY': 'Vos sorts peuvent \u00eatre plac\u00e9s pour vous et vos touches attribu\u00e9es, par sp\u00e9cialisation. Vous voyez ce qui changerait avant que quoi que ce soit ne bouge, et tout est annulable.|n|nD\u00e9j\u00e0 satisfait de vos barres ? \u00c9cartez ceci et il ne reviendra pas.',
        'SETUPNUDGE_BTN': 'Montrez-moi',
    },
    'esES': {
        'SETUPNUDGE_TITLE': '\u00bfDejas que Midnight Helper configure tus barras?',
        'SETUPNUDGE_BODY': 'Tus hechizos pueden colocarse por ti y tus teclas asignarse a ellos, por especializaci\u00f3n. Ves qu\u00e9 cambiar\u00eda antes de que nada se mueva, y todo se puede deshacer.|n|n\u00bfContento con tus barras? Desc\u00e1rtalo y no volver\u00e1.',
        'SETUPNUDGE_BTN': 'Mu\u00e9stramelo',
    },
    'ptBR': {
        'SETUPNUDGE_TITLE': 'Deixar o Midnight Helper montar suas barras?',
        'SETUPNUDGE_BODY': 'Suas magias podem ser colocadas para voc\u00ea e suas teclas definidas, por especializa\u00e7\u00e3o. Voc\u00ea v\u00ea o que mudaria antes de qualquer coisa se mexer, e tudo pode ser desfeito.|n|nJ\u00e1 satisfeito com suas barras? Dispense isto e n\u00e3o volta.',
        'SETUPNUDGE_BTN': 'Me mostra',
    },
    'itIT': {
        'SETUPNUDGE_TITLE': 'Vuoi che Midnight Helper sistemi le tue barre?',
        'SETUPNUDGE_BODY': 'Le tue magie possono essere posizionate per te e i tasti assegnati, per specializzazione. Vedi cosa cambierebbe prima che si muova qualcosa, e tutto \u00e8 annullabile.|n|nGi\u00e0 contento delle tue barre? Scarta questo e non torner\u00e0.',
        'SETUPNUDGE_BTN': 'Fammi vedere',
    },
}

for code, keys in PACK.items():
    p = os.path.join(BASE, '%s.lua' % code)
    t = open(p, encoding='utf-8', newline='').read()
    if 'SETUPNUDGE_TITLE' in t:
        print('%s: stond er al in' % code)
        continue
    nl = '\r\n' if '\r\n' in t else '\n'
    m = re.compile(r'^\tQUICKBAR_DELVE_UNKNOWN = .*$', re.M).search(t)
    if not m:
        print('%s: geen anker' % code)
        continue
    for k in ORDER:
        assert '"' not in keys[k], k
    block = nl.join('\t%s = "%s",' % (k, keys[k]) for k in ORDER)
    t = t[:m.end()] + nl + block + t[m.end():]
    io.open(p + '.tmp', 'w', encoding='utf-8', newline='').write(t)
    os.replace(p + '.tmp', p)
    print('%s: ok' % code)

p = os.path.join(BASE, 'Translations2026.lua')
t = open(p, encoding='utf-8', newline='').read()
if 'SETUPNUDGE_TITLE' in t:
    print('Translations2026: stond er al in')
else:
    nl = '\r\n' if '\r\n' in t else '\n'
    for code, keys in FILLS.items():
        for k in ORDER:
            assert '"' not in keys[k], k
        marker = 'fill("%s", {' % code
        start = t.rindex(marker)
        end = t.index('})', start)
        block = nl.join('\t%s = "%s",' % (k, keys[k]) for k in ORDER) + nl
        t = t[:end] + block + t[end:]
    io.open(p + '.tmp', 'w', encoding='utf-8', newline='').write(t)
    os.replace(p + '.tmp', p)
    print('Translations2026: 5 talen')
