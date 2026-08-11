"""Scratch script — rewritten per task, always run as tools/_probe.py.

Right now: the four "say it on the panel too" keys, seven languages.
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
ORDER = ['MH_SAY_PRESET_LAYOUT', 'MH_SAY_ACCOUNT_LAYOUT',
         'MH_SAY_BARS_DONE', 'MH_SAY_BARS_RESTORED']

PACK = {
    'enUS': {
        'MH_SAY_PRESET_LAYOUT': 'You are on one of Blizzard\u2019s preset layouts, and a preset cannot be changed. Open Edit Mode, use the layout dropdown \u2192 New layout, and tick Character there so the bars stay on this character only.',
        'MH_SAY_ACCOUNT_LAYOUT': '%s is an account-wide layout: every character using it gets these bars. A character-specific layout keeps the change here.',
        'MH_SAY_BARS_DONE': 'Bars replaced (%d system(s) into %s). Reload now \u2014 nothing is settled until you do.',
        'MH_SAY_BARS_RESTORED': '%s is back as it was before the import. Reload now.',
    },
    'nlNL': {
        'MH_SAY_PRESET_LAYOUT': 'Je zit op een preset-layout van Blizzard, en die kun je niet wijzigen. Open Edit Mode, kies in het layout-menu \u2192 New layout, en vink daar Character aan zodat de balken alleen op dit personage staan.',
        'MH_SAY_ACCOUNT_LAYOUT': '%s is een account-brede layout: elk personage dat hem gebruikt krijgt deze balken. Een character-specifieke layout houdt de wijziging hier.',
        'MH_SAY_BARS_DONE': 'Balken vervangen (%d systeem/systemen in %s). Doe nu een reload \u2014 pas dan staat het vast.',
        'MH_SAY_BARS_RESTORED': '%s staat weer zoals voor de import. Doe nu een reload.',
    },
}
FILLS = {
    'deDE': {
        'MH_SAY_PRESET_LAYOUT': 'Du bist auf einem Vorlagen-Layout von Blizzard, und eine Vorlage l\u00e4sst sich nicht \u00e4ndern. \u00d6ffne den Bearbeitungsmodus, w\u00e4hle im Layout-Men\u00fc \u2192 Neues Layout und h\u00e4kle dort Charakter an, damit die Leisten nur auf diesem Charakter bleiben.',
        'MH_SAY_ACCOUNT_LAYOUT': '%s ist ein accountweites Layout: jeder Charakter, der es nutzt, bekommt diese Leisten. Ein charakterspezifisches Layout beh\u00e4lt die \u00c4nderung hier.',
        'MH_SAY_BARS_DONE': 'Leisten ersetzt (%d System(e) in %s). Jetzt neu laden \u2014 vorher ist nichts festgeschrieben.',
        'MH_SAY_BARS_RESTORED': '%s ist wieder wie vor dem Import. Jetzt neu laden.',
    },
    'frFR': {
        'MH_SAY_PRESET_LAYOUT': 'Tu es sur une disposition pr\u00e9d\u00e9finie de Blizzard, et une pr\u00e9d\u00e9finie ne peut pas \u00eatre modifi\u00e9e. Ouvre le mode \u00c9dition, choisis dans le menu des dispositions \u2192 Nouvelle disposition, et coche Personnage pour que les barres restent sur ce personnage uniquement.',
        'MH_SAY_ACCOUNT_LAYOUT': '%s est une disposition li\u00e9e au compte : chaque personnage qui l\u2019utilise re\u00e7oit ces barres. Une disposition propre au personnage garde le changement ici.',
        'MH_SAY_BARS_DONE': 'Barres remplac\u00e9es (%d syst\u00e8me(s) dans %s). Recharge maintenant \u2014 rien n\u2019est fix\u00e9 avant \u00e7a.',
        'MH_SAY_BARS_RESTORED': '%s est revenue \u00e0 son \u00e9tat d\u2019avant l\u2019import. Recharge maintenant.',
    },
    'esES': {
        'MH_SAY_PRESET_LAYOUT': 'Est\u00e1s en una disposici\u00f3n predefinida de Blizzard, y una predefinida no se puede cambiar. Abre el modo Edici\u00f3n, elige en el men\u00fa de disposiciones \u2192 Nueva disposici\u00f3n, y marca Personaje para que las barras se queden solo en este personaje.',
        'MH_SAY_ACCOUNT_LAYOUT': '%s es una disposici\u00f3n de toda la cuenta: cada personaje que la use recibe estas barras. Una disposici\u00f3n propia del personaje mantiene el cambio aqu\u00ed.',
        'MH_SAY_BARS_DONE': 'Barras reemplazadas (%d sistema(s) en %s). Recarga ahora \u2014 nada queda fijado hasta entonces.',
        'MH_SAY_BARS_RESTORED': '%s ha vuelto a como estaba antes de la importaci\u00f3n. Recarga ahora.',
    },
    'ptBR': {
        'MH_SAY_PRESET_LAYOUT': 'Voc\u00ea est\u00e1 num layout predefinido da Blizzard, e um predefinido n\u00e3o pode ser alterado. Abre o modo Edi\u00e7\u00e3o, escolhe no menu de layouts \u2192 Novo layout, e marca Personagem para as barras ficarem s\u00f3 neste personagem.',
        'MH_SAY_ACCOUNT_LAYOUT': '%s \u00e9 um layout de toda a conta: cada personagem que o usa recebe estas barras. Um layout do personagem mant\u00e9m a mudan\u00e7a aqui.',
        'MH_SAY_BARS_DONE': 'Barras substitu\u00eddas (%d sistema(s) em %s). Recarrega agora \u2014 nada fica definido at\u00e9 l\u00e1.',
        'MH_SAY_BARS_RESTORED': '%s voltou a como estava antes da importa\u00e7\u00e3o. Recarrega agora.',
    },
    'itIT': {
        'MH_SAY_PRESET_LAYOUT': 'Sei su un layout predefinito di Blizzard, e un predefinito non si pu\u00f2 modificare. Apri la modalit\u00e0 Modifica, scegli nel men\u00f9 dei layout \u2192 Nuovo layout, e spunta Personaggio cos\u00ec le barre restano solo su questo personaggio.',
        'MH_SAY_ACCOUNT_LAYOUT': '%s \u00e8 un layout valido per tutto l\u2019account: ogni personaggio che lo usa riceve queste barre. Un layout del personaggio tiene la modifica qui.',
        'MH_SAY_BARS_DONE': 'Barre sostituite (%d sistema/i in %s). Ricarica adesso \u2014 niente \u00e8 definitivo prima.',
        'MH_SAY_BARS_RESTORED': '%s \u00e8 tornato com\u2019era prima dell\u2019importazione. Ricarica adesso.',
    },
}

for code, keys in PACK.items():
    p = os.path.join(BASE, '%s.lua' % code)
    t = open(p, encoding='utf-8', newline='').read()
    if ORDER[0] in t:
        print('%s: stond er al in' % code)
        continue
    nl = '\r\n' if '\r\n' in t else '\n'
    m = re.compile(r'^\tSETUPNUDGE_BTN = .*$', re.M).search(t)
    if not m:
        print('%s: geen anker' % code)
        continue
    for k in ORDER:
        assert '"' not in keys[k], (code, k)
    block = nl.join('\t%s = "%s",' % (k, keys[k]) for k in ORDER)
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
    for code, keys in FILLS.items():
        for k in ORDER:
            assert '"' not in keys[k], (code, k)
        marker = 'fill("%s", {' % code
        start = t.rindex(marker)
        end = t.index('})', start)
        block = nl.join('\t%s = "%s",' % (k, keys[k]) for k in ORDER) + nl
        t = t[:end] + block + t[end:]
    io.open(p + '.tmp', 'w', encoding='utf-8', newline='').write(t)
    os.replace(p + '.tmp', p)
    print('Translations2026: 5 talen')
