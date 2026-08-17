# -*- coding: utf-8 -*-
"""Scratch script — rewritten per task, always run as tools/_probe.py.

Right now: the 2.18.0 release check, re-run after the notes gained two
sections. Under ~40 lines and no bullet lists is what ten clean CurseForge
uploads have in common, and a release is the wrong place to find the edge.
"""
import io
import os
import sys

for _s in (sys.stdout, sys.stderr):
    try:
        _s.reconfigure(encoding="utf-8", errors="replace")
    except (AttributeError, ValueError):
        pass

BASE = r'E:\World of Warcraft\_retail_\Interface\AddOns\MidnightHelper'

t = io.open(BASE + r'\RELEASE_NOTES.md', encoding='utf-8',
            errors='replace', newline='').read()
lines = t.rstrip('\n').split('\n')
bullets = [n for n, l in enumerate(lines, 1)
           if l.lstrip().startswith(('- ', '* ', '+ '))]

print('RELEASE_NOTES.md')
print('  regels  : %d      (schoon geweest t/m 40)' % len(lines))
print('  tekens  : %d    (langste schone: 1937)' % len(t))
print('  bullets : %d' % len(bullets))
ok = len(lines) <= 40 and not bullets and lines[0].startswith('# ')
print('  %s' % ('✅ binnen de regel' if ok else '❌ BUITEN de regel'))

toc = io.open(BASE + r'\MidnightHelper.toc', encoding='utf-8',
              errors='replace', newline='').read()
ver = None
for l in toc.split('\n'):
    if l.startswith('## Version:'):
        ver = l.split(':', 1)[1].strip()
        break

chg = io.open(BASE + r'\Modules\Changelog.lua', encoding='utf-8',
              errors='replace', newline='').read()
en = io.open(BASE + r'\Locales\enUS.lua', encoding='utf-8',
             errors='replace', newline='').read()
key = 'CHANGELOG_%s_' % (ver.replace('.', '') if ver else '')

print('\nversie-samenhang')
print('  .toc                : %s' % ver)
print('  in de notes         : %s' % ('ja' if ver and ver in lines[0] else 'NEE'))
print('  changelog-module    : %s'
      % ('ja' if ver and ('version = "%s"' % ver) in chg else 'NEE'))
print('  enUS-regels         : %d' % en.count(key))

arch = BASE + r'\docs\CURSEFORGE_%s.md' % (ver.replace('.', '') if ver else '')
if os.path.exists(arch):
    a = io.open(arch, encoding='utf-8', errors='replace', newline='').read()
    print('  docs-archief gelijk : %s' % ('ja' if a == t else 'NEE'))
else:
    print('  docs-archief        : ONTBREEKT')

full = io.open(BASE + r'\CHANGELOG.md', encoding='utf-8',
               errors='replace', newline='').read()
print('  CHANGELOG.md        : %s'
      % ('ja' if ver and ('## %s' % ver) in full else 'NEE'))
