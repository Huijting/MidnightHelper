#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Turn Rob's OWN bindings into a page he can print.

Run `/mh binds` in game, then `/reload`, then:

    python tools/keybind_mine.py

Writes MY_KEYBINDS.html next to this script. Open it and press Ctrl+P.

⚠️ WHY A BROWSER. WoW cannot print, and no addon can make it — that is the
platform, not a gap in the addon. So the game reads the bindings and something
that can lay out a page renders them. This reads ns.db.keybindExport, which
`/mh binds` writes as STRUCTURE; parsing the addon's own display text instead
would mean writing a parser for our own prose and breaking on the first label
with two spaces in it.

⚠️ It reads the SavedVariables file, so it shows what was true at the last
/reload. If the sheet looks stale, that is because it is: run /mh binds and
reload again. Said out loud on the page itself for the same reason.
"""
import io
import os
import re
import sys
import datetime

for _s in (sys.stdout, sys.stderr):
    try:
        _s.reconfigure(encoding="utf-8", errors="replace")
    except (AttributeError, ValueError):
        pass

SV = (r'E:\World of Warcraft\_retail_\WTF\Account\JOEYWHATEVER'
      r'\SavedVariables\MidnightHelper.lua')
OUT = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'MY_KEYBINDS.html')

# Blizzard's binding command names mean nothing to a player reading a printout.
BAR_NAMES = {
    'ACTION': 'Main bar',
    'MULTIACTIONBAR1': 'Bottom left bar',
    'MULTIACTIONBAR2': 'Bottom right bar',
    'MULTIACTIONBAR3': 'Right bar',
    'MULTIACTIONBAR4': 'Right bar 2',
    'MULTIACTIONBAR5': 'Bar 6',
    'MULTIACTIONBAR6': 'Bar 7',
    'MULTIACTIONBAR7': 'Bar 8 (mouse buttons)',
}


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


def field(chunk, name):
    m = re.search(r'\["%s"\]\s*=\s*("(?:[^"\\]|\\.)*"|true|false|[\d.-]+)' % name, chunk)
    if not m:
        return None
    v = m.group(1)
    if v.startswith('"'):
        return v[1:-1].replace('\\"', '"').replace('\\\\', '\\')
    if v in ('true', 'false'):
        return v == 'true'
    return v


try:
    t = io.open(SV, encoding='utf-8', errors='replace').read()
except OSError as e:
    print('kan de SavedVariables niet lezen: %s' % e)
    sys.exit(1)

exp = block('keybindExport', t)
if not exp:
    print('geen keybindExport in de SavedVariables.')
    print('Draai eerst /mh binds in het spel en daarna /reload.')
    sys.exit(1)

player = field(exp, 'player') or '?'
klass = field(exp, 'class') or ''
spec = field(exp, 'spec') or ''
at = field(exp, 'at')
dupes = field(exp, 'duplicates') or 0

bars_blob = block('bars', exp)
bars = []
for b in split_top(bars_blob or '{}'):
    name = field(b, 'name') or '?'
    rows_blob = block('rows', b)
    rows = []
    for r in split_top(rows_blob or '{}'):
        rows.append({
            'keys': field(r, 'keys') or '',
            'label': field(r, 'label') or '',
            'dup': field(r, 'duplicate') is True,
        })
    if rows:
        bars.append((BAR_NAMES.get(name, name), rows))

when = '?'
try:
    when = datetime.datetime.fromtimestamp(int(at)).strftime('%d-%m-%Y %H:%M')
except (TypeError, ValueError):
    pass

H = []
H.append('<!doctype html><html lang="nl"><head><meta charset="utf-8">')
H.append('<title>%s — keybinds</title>' % player)
H.append('''<style>
:root{--ink:#1b1b1f;--muted:#6b6b76;--rule:#d8d8de;--dup:#8a6d1f;--dupbg:#fdf6e3}
*{box-sizing:border-box}
body{margin:0;padding:28px 32px;font:14px/1.5 "Segoe UI",system-ui,sans-serif;color:var(--ink)}
h1{margin:0 0 2px;font-size:22px;letter-spacing:.2px}
.sub{color:var(--muted);font-size:12px;margin-bottom:18px}
/* Columns, because this is meant to fit on paper rather than scroll. */
.grid{column-count:2;column-gap:28px}
@media print{body{padding:0}.grid{column-count:2}}
section{break-inside:avoid;page-break-inside:avoid;margin:0 0 16px}
h2{font-size:12px;text-transform:uppercase;letter-spacing:.9px;color:var(--muted);
   margin:0 0 6px;padding-bottom:3px;border-bottom:1px solid var(--rule)}
table{width:100%;border-collapse:collapse}
td{padding:3px 0;vertical-align:baseline}
/* A key is the thing you are memorising, so it gets the weight and a fixed column. */
td.k{width:104px;font-family:"Cascadia Mono",Consolas,monospace;font-weight:600;
     white-space:nowrap}
tr.dup td{background:var(--dupbg)}
tr.dup td.n::after{content:" \\2194";color:var(--dup)}
.note{margin-top:6px;font-size:11px;color:var(--muted);border-top:1px solid var(--rule);
      padding-top:8px}
</style></head><body>''')
H.append('<h1>%s</h1>' % player)
H.append('<div class="sub">%s %s &middot; gelezen uit de client op %s</div>'
         % (spec, klass, when))
H.append('<div class="grid">')
for title, rows in bars:
    H.append('<section><h2>%s</h2><table>' % title)
    for r in rows:
        cls = ' class="dup"' if r['dup'] else ''
        H.append('<tr%s><td class="k">%s</td><td class="n">%s</td></tr>'
                 % (cls, r['keys'], r['label']))
    H.append('</table></section>')
H.append('</div>')
if dupes:
    H.append('<div class="note">\u2194 %s toetsen doen iets dat een andere toets ook '
             'doet. Vaak bewust — dezelfde spell bereikbaar op een laptop \u00e9n op '
             'een MMO-muis.</div>' % dupes)
H.append('<div class="note">Momentopname van %s. Verander je iets in het spel, draai '
         'dan opnieuw <code>/mh binds</code> + <code>/reload</code> en genereer dit '
         'blad opnieuw — anders leer je iets dat niet meer klopt.</div>' % when)
H.append('</body></html>')

io.open(OUT + '.tmp', 'w', encoding='utf-8').write('\n'.join(H))
os.replace(OUT + '.tmp', OUT)
print('geschreven: %s' % OUT)
print('%d balken, %d toetsen, %s dubbel' %
      (len(bars), sum(len(r) for _, r in bars), dupes))
print('Open het bestand en druk Ctrl+P.')
