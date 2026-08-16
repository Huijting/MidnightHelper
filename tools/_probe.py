# -*- coding: utf-8 -*-
"""Scratch script — rewritten per task, always run as tools/_probe.py.

Right now: are Method's two portal quest ids real?

96004 "Prey: A Slithering Threat" gates the Coiled Isle portal we just added, so
a wrong id means the portal never appears for anyone. Rob is on a shaman that has
only run delves on the isle, so BOTH should read as not completed — the title is
the check, not the flag.
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
rb = block('repeatable', probe) if probe else None
if not rb:
    print('geen repeatable-blok')
    sys.exit(1)


def f(chunk, name):
    m = re.search(r'\["%s"\]\s*=\s*("(?:[^"\\]|\\.)*"|true|false|[\d.-]+)' % name, chunk)
    if not m:
        return None
    v = m.group(1)
    if v.startswith('"'):
        return v[1:-1]
    if v in ('true', 'false'):
        return v == 'true'
    return v


print('%-8s %-34s %-34s %s' % ('id', 'wat Method zei', 'wat je client zegt', 'gedaan'))
print('-' * 96)
for e in split_top(rb):
    qid = f(e, 'id')
    if qid not in ('96004', '96466'):
        continue
    label = f(e, 'guideLabel') or ''
    title = f(e, 'gameTitle')
    done = f(e, 'completed')
    asked = f(e, 'askedServer')
    print('%-8s %-34s %-34s %s%s' % (
        qid, label, title or '— NIETS —', 'ja' if done else 'nee',
        '   (server gevraagd)' if asked else ''))
    if title and label and title != label:
        print('   ⚠️ TITEL WIJKT AF van wat Method zei')
