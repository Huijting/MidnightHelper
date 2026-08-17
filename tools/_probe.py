# -*- coding: utf-8 -*-
"""Scratch script — rewritten per task, always run as tools/_probe.py.

Right now: release check for 2.18.0. Does RELEASE_NOTES.md sit inside the rule
that keeps CurseForge's auto-upload from mangling it (nine clean uploads: under
~40 lines, no bullet lists), and does every artefact agree on the version?
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
print('  kop     : %r' % lines[0][:64])
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
print('  .toc                 : %s' % ver)
print('  in de release notes  : %s' % ('ja' if ver and ver in lines[0] else 'NEE'))
print('  changelog-module     : %s'
      % ('ja' if ver and ('version = "%s"' % ver) in chg else 'NEE'))
print('  enUS-regels          : %d' % en.count(key))
print('  regels in de module  : %d' % chg.count('"%s' % key))

arch = BASE + r'\docs\CURSEFORGE_%s.md' % (ver.replace('.', '') if ver else '')
print('  docs-archief         : %s'
      % ('bestaat' if os.path.exists(arch) else 'ONTBREEKT'))
if os.path.exists(arch):
    a = io.open(arch, encoding='utf-8', errors='replace', newline='').read()
    print('  identiek aan notes   : %s' % ('ja' if a == t else 'NEE'))

full = io.open(BASE + r'\CHANGELOG.md', encoding='utf-8',
               errors='replace', newline='').read()
print('  CHANGELOG.md         : %s'
      % ('ja' if ver and ('## %s' % ver) in full else 'NEE'))
