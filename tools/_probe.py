# -*- coding: utf-8 -*-
"""Scratch script — rewritten per task, always run as tools/_probe.py.

Right now: name the seven group dailies in the Vaults article.

Rob asked for them; the article said "a rotating set of group dailies" and
named three in passing. Nine of the ten candidate ids came back from his client
with titles matching character for character, so the seven dailies and the
weekly are now safe to write down. The tenth — the Silvermoon weekly meta —
returned nothing and is NOT in this text.

What the bullet deliberately does not claim: that the dailies rotate. One addon
implies it and Rob's snapshot is equally consistent with him simply not having
picked them up. "Take whichever your map offers today" is useful advice and
happens to be true either way; "they rotate" would be a guess dressed as a fact
on a page whose whole job is being trusted.

Bullet index 7 of twelve (three headings + nine bullets), same slot in all
seven languages.
"""
import io
import os
import sys

for _s in (sys.stdout, sys.stderr):
    try:
        _s.reconfigure(encoding="utf-8", errors="replace")
    except (AttributeError, ValueError):
        pass

P = r'E:\World of Warcraft\_retail_\Interface\AddOns\MidnightHelper\Locales\Codex.lua'
KEY = 'CODEX_ATALUTEK_BODY'
ORDER = ('enUS', 'itIT', 'nlNL', 'deDE', 'frFR', 'esES', 'ptBR')

W = '|cffffffff%s|r'
NAMES = ('Patrolling the Temple', 'Bounty of the Cursed', 'Relentless Strikes',
         'Decisive Incursions', 'From Whence it Came', 'Essence of Malice',
         "What's Out There?")


def listed(sep_and):
    """The seven titles, bolded, joined with the language's own 'and'."""
    bold = [W % n for n in NAMES]
    return ', '.join(bold[:-1]) + ' ' + sep_and + ' ' + bold[-1]


NEW = {
    'enUS': (
        u'\u2022 ' + (W % u'The repeatables \u2014 one weekly and seven group dailies.')
        + u' ' + (W % u'Purging the Vaults') + u' from ' + (W % u'Warleader Abdumati')
        + u' at the entrance is the weekly worth not missing. The seven dailies are '
        + listed('and')
        + u' \u2014 take whichever your map offers today. Every one of them asks for the'
        u' activities above, so they tick themselves off while you play, and a group'
        u' daily just means the people already standing next to you, not a premade.'
    ),
    'itIT': (
        u'\u2022 ' + (W % u'Le missioni ripetibili \u2014 una settimanale e sette giornaliere di gruppo.')
        + u' ' + (W % u'Purging the Vaults') + u' da ' + (W % u'Warleader Abdumati')
        + u" all'ingresso \u00e8 la settimanale da non saltare. Le sette giornaliere sono "
        + listed('e')
        + u' \u2014 prendi quelle che la mappa ti offre oggi. Tutte chiedono esattamente le'
        u' attivit\u00e0 qui sopra, quindi si spuntano da sole mentre giochi, e una'
        u' giornaliera di gruppo vuol dire semplicemente le persone che ti stanno gi\u00e0'
        u' accanto, non un premade.'
    ),
    'nlNL': (
        u'\u2022 ' + (W % u'De herhaalbare quests \u2014 \u00e9\u00e9n weekly en zeven group dailies.')
        + u' ' + (W % u'Purging the Vaults') + u' bij ' + (W % u'Warleader Abdumati')
        + u' bij de ingang is de weekly die je niet wilt missen. De zeven dailies zijn '
        + listed('en')
        + u' \u2014 pak wat je kaart je vandaag aanbiedt. Ze vragen allemaal om precies de'
        u' activiteiten hierboven, dus ze vinken zichzelf af terwijl je speelt, en een'
        u' group daily betekent gewoon de mensen die al naast je staan, geen premade.'
    ),
    'deDE': (
        u'\u2022 ' + (W % u'Die wiederholbaren Quests \u2014 eine Weekly und sieben Gruppen-Dailies.')
        + u' ' + (W % u'Purging the Vaults') + u' bei ' + (W % u'Warleader Abdumati')
        + u' am Eingang ist die Weekly, die du nicht auslassen willst. Die sieben Dailies sind '
        + listed('und')
        + u' \u2014 nimm, was deine Karte dir heute anbietet. Alle verlangen genau die'
        u' Aktivit\u00e4ten von oben, sie haken sich also von selbst ab, w\u00e4hrend du'
        u' spielst, und eine Gruppen-Daily meint einfach die Leute, die ohnehin neben dir'
        u' stehen, keine Premade.'
    ),
    'frFR': (
        u'\u2022 ' + (W % u'Les qu\u00eates r\u00e9p\u00e9tables \u2014 une hebdomadaire et sept quotidiennes de groupe.')
        + u' ' + (W % u'Purging the Vaults') + u' chez ' + (W % u'Warleader Abdumati')
        + u" \u00e0 l'entr\u00e9e est l'hebdomadaire \u00e0 ne pas manquer. Les sept"
        u' quotidiennes sont ' + listed('et')
        + u" \u2014 prends celles que ta carte propose aujourd'hui. Toutes demandent"
        u' exactement les activit\u00e9s ci-dessus, elles se cochent donc toutes seules'
        u' pendant que tu joues, et une quotidienne de groupe veut simplement dire les gens'
        u' d\u00e9j\u00e0 \u00e0 c\u00f4t\u00e9 de toi, pas un groupe mont\u00e9.'
    ),
    'esES': (
        u'\u2022 ' + (W % u'Las misiones repetibles \u2014 una semanal y siete diarias de grupo.')
        + u' ' + (W % u'Purging the Vaults') + u' con ' + (W % u'Warleader Abdumati')
        + u' en la entrada es la semanal que no conviene saltarse. Las siete diarias son '
        + listed('y')
        + u' \u2014 coge las que te ofrezca el mapa hoy. Todas piden exactamente las'
        u' actividades de arriba, as\u00ed que se completan solas mientras juegas, y una'
        u' diaria de grupo solo significa la gente que ya est\u00e1 a tu lado, no un grupo'
        u' montado.'
    ),
    'ptBR': (
        u'\u2022 ' + (W % u'As miss\u00f5es repet\u00edveis \u2014 uma semanal e sete di\u00e1rias de grupo.')
        + u' ' + (W % u'Purging the Vaults') + u' com o ' + (W % u'Warleader Abdumati')
        + u' \u00e0 entrada \u00e9 a semanal que n\u00e3o vale a pena perder. As sete'
        u' di\u00e1rias s\u00e3o ' + listed('e')
        + u' \u2014 pegue as que o mapa oferecer hoje. Todas pedem exatamente as atividades'
        u' acima, ent\u00e3o elas se completam sozinhas enquanto voc\u00ea joga, e uma'
        u' di\u00e1ria de grupo significa apenas as pessoas que j\u00e1 est\u00e3o ao seu'
        u' lado, n\u00e3o um grupo montado.'
    ),
}

t = io.open(P, encoding='utf-8', newline='').read()
if 'Bounty of the Cursed' in t:
    print('de zeven staan er al')
    sys.exit(0)

eol = '\r\n' if '\r\n' in t else '\n'
out, seen = [], 0

for line in t.split(eol):
    stripped = line.lstrip()
    if not stripped.startswith(KEY + ' = "'):
        out.append(line)
        continue

    lang = ORDER[seen]
    seen += 1
    indent = line[:len(line) - len(line.lstrip())]
    body = stripped[len(KEY) + 4:]
    assert body.endswith('",'), lang
    parts = body[:-2].split('|n|n')
    if len(parts) != 12:
        print('%s heeft %d blokken, verwacht 12 — niets geschreven'
              % (lang, len(parts)))
        sys.exit(1)
    if 'Purging the Vaults' not in parts[7]:
        print('%s: blok 7 is niet de weekly — niets geschreven' % lang)
        sys.exit(1)

    parts[7] = NEW[lang]
    out.append('%s%s = "%s",' % (indent, KEY, '|n|n'.join(parts)))
    print('%-6s vervangen (%d tekens)' % (lang, len(NEW[lang])))

if seen != 7:
    print('%d van 7 — niets geschreven' % seen)
    sys.exit(1)

io.open(P + '.tmp', 'w', encoding='utf-8', newline='').write(eol.join(out))
os.replace(P + '.tmp', P)
print('geschreven')
