"""Scratch script — rewritten per task, always run as tools/_probe.py.

Right now: dump crestProbe and crestScanProbe from the SavedVariables. The
"You cannot earn 10 Adventurer Mistcrests right now" error is a cap message, so
the quantities and caps Rob already saved should say which cap it is.
"""
import io
import sys

for _s in (sys.stdout, sys.stderr):
    try:
        _s.reconfigure(encoding="utf-8", errors="replace")
    except (AttributeError, ValueError):
        pass

SV = r'E:\World of Warcraft\_retail_\WTF\Account\JOEYWHATEVER\SavedVariables\MidnightHelper.lua'


def block(text, key, start=0):
    i = text.find('["%s"]' % key, start)
    if i == -1:
        return None
    j = text.find('{', i)
    if j == -1:
        return None
    depth, k = 0, j
    while k < len(text):
        if text[k] == '{':
            depth += 1
        elif text[k] == '}':
            depth -= 1
            if depth == 0:
                return text[j:k + 1]
        k += 1
    return None


t = io.open(SV, encoding='utf-8', errors='replace').read()

for key in ('crestProbe', 'crestScanProbe'):
    b = block(t, key)
    print('\n=========== %s ===========' % key)
    if b is None:
        print('(niet aanwezig)')
        continue
    lines = [ln.rstrip() for ln in b.splitlines()]
    print('%d regels' % len(lines))
    for ln in lines:
        print(ln)
