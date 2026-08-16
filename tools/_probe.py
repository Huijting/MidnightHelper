# -*- coding: utf-8 -*-
"""Scratch script — rewritten per task, always run as tools/_probe.py.

Right now: does RELEASE_NOTES.md sit inside the rule that keeps CurseForge's
auto-upload from mangling it? Eight clean uploads share two properties: under
~40 lines and no bullet lists. 2.8.4 was mangled at 55 lines with 6 bullets.
The rule is not a diagnosis, so measure rather than eyeball it.
"""
import io
import sys

for _s in (sys.stdout, sys.stderr):
    try:
        _s.reconfigure(encoding="utf-8", errors="replace")
    except (AttributeError, ValueError):
        pass

BASE = r'E:\World of Warcraft\_retail_\Interface\AddOns\MidnightHelper'
P = BASE + r'\RELEASE_NOTES.md'

t = io.open(P, encoding='utf-8', errors='replace', newline='').read()
lines = t.rstrip('\n').split('\n')

bullets = [n for n, l in enumerate(lines, 1)
           if l.lstrip().startswith(('- ', '* ', '+ '))]

print('RELEASE_NOTES.md')
print('  regels   : %d      (schoon geweest t/m 40)' % len(lines))
print('  tekens   : %d    (langste schone: 1937)' % len(t))
print('  bullets  : %d %s' % (len(bullets),
                              ('op regel ' + str(bullets)) if bullets else ''))
print('  begint   : %r' % lines[0][:60])

ok = len(lines) <= 40 and not bullets and lines[0].startswith('# ')
print('\n  %s' % ('✅ binnen de regel' if ok else '❌ BUITEN de regel'))

# The .toc is the version of record; everything else must agree with it.
toc = io.open(BASE + r'\MidnightHelper.toc', encoding='utf-8',
              errors='replace', newline='').read()
ver = None
for l in toc.split('\n'):
    if l.startswith('## Version:'):
        ver = l.split(':', 1)[1].strip()
        break
print('\n.toc versie : %s' % ver)
print('  in notes  : %s' % ('ja' if ver and ver in lines[0] else 'NEE'))

chg = io.open(BASE + r'\Modules\Changelog.lua', encoding='utf-8',
              errors='replace', newline='').read()
print('  in changelog-module : %s'
      % ('ja' if ver and ('version = "%s"' % ver) in chg else 'NEE'))

en = io.open(BASE + r'\Locales\enUS.lua', encoding='utf-8',
             errors='replace', newline='').read()
key = 'CHANGELOG_%s_' % (ver.replace('.', '') if ver else '')
print('  enUS-regels voor deze versie : %d' % en.count(key + ''))
