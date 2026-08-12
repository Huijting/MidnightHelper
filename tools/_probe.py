"""Scratch script — rewritten per task, always run as tools/_probe.py.

Right now: is Rob's 12.1 Hunter export the same string as the 12.0.7 one?
Compared byte for byte, because "looks the same" is not a comparison.
"""
import re
import sys

for _s in (sys.stdout, sys.stderr):
    try:
        _s.reconfigure(encoding="utf-8", errors="replace")
    except (AttributeError, ValueError):
        pass

NEW = ("2 8 0 0 0 8 6 MultiBarBottomRight -4.0 0.0 -1 ##$$%)&''%)$+$,# 0 1 0 8 6 "
       "MultiBar5 -4.0 0.0 -1 ##$$%,&''%(#,# 0 2 0 4 4 UIParent 149.1 -560.0 -1 "
       "##$$%*&''%(#,# 0 3 0 8 2 MultiBarBottomLeft 0.0 4.0 -1 ##$$%+&''%(#,# 0 4 0 8 2 "
       "MultiBar5 0.0 4.0 -1 ##$$%)&''%(#,# 0 5 0 8 2 MultiBarBottomRight 0.0 4.0 -1 "
       "##$$%)&''%(#,# 0 6 0 7 7 UIParent -614.9 2.0 -1 ##$$%/&''%(#,# 0 7 0 4 4 "
       "UIParent 400.0 -520.0 -1 ##$&%/&''%(#,#")

SRC = r'E:\World of Warcraft\_retail_\Interface\AddOns\MidnightHelper\Modules\BarPreset.lua'
t = open(SRC, encoding='utf-8', errors='replace').read()

m = re.search(r'local PRESET_1207\s*=\s*(.*?)\n\n', t, re.S)
if not m:
    print('kon PRESET_1207 niet vinden')
    raise SystemExit(1)

old = ''.join(re.findall(r'"((?:[^"\\]|\\.)*)"', m.group(1)))

print('oud (12.0.7) : %d tekens' % len(old))
print('nieuw (12.1) : %d tekens' % len(NEW))
print('identiek     : %s' % (old == NEW))
if old != NEW:
    for i, (a, b) in enumerate(zip(old, NEW)):
        if a != b:
            print('eerste verschil op %d: oud %r vs nieuw %r' % (i, a, b))
            print('  oud   ...%s...' % old[max(0, i - 30):i + 30])
            print('  nieuw ...%s...' % NEW[max(0, i - 30):i + 30])
            break
    else:
        print('gelijk tot %d; lengtes verschillen' % min(len(old), len(NEW)))
