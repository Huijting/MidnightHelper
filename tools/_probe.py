"""Scratch script — rewritten per task, always run as tools/_probe.py.

Right now: the clever parse ate itself (0 of 8 while the capture exists), so do
the dumb thing instead — for each Venomous Abyss boss name, print the raw SV
lines that follow it. Eyes beat a regex that has already failed once.
"""
import io
import sys

for _s in (sys.stdout, sys.stderr):
    try:
        _s.reconfigure(encoding="utf-8", errors="replace")
    except (AttributeError, ValueError):
        pass

SV = r'E:\World of Warcraft\_retail_\WTF\Account\JOEYWHATEVER\SavedVariables\MidnightHelper.lua'

BOSSES = ["Nek'zali the Soulcoiler", "Entombed Sentinels", "The Lost Explorers",
          "Vashnik the Malignant", "Sszorak", "The Twin Fangs",
          "The Coiled Altar", "Ula'tek"]

t = io.open(SV, encoding='utf-8', errors='replace').read()
start = t.find('["ejCapture"]')
if start == -1:
    print('geen ejCapture')
    sys.exit(1)
lines = t[start:].splitlines()

for boss in BOSSES:
    needle = '"%s"' % boss.replace("'", "\\'")
    alt = '"%s"' % boss
    for i, line in enumerate(lines):
        if needle in line or alt in line:
            print('\n=== %s ===' % boss)
            for j in range(i, min(len(lines), i + 34)):
                s = lines[j].strip()
                if s:
                    print(s[:110])
                if j > i and '["index"]' in lines[j] and j > i + 3:
                    break
            break
    else:
        print('\n=== %s === NIET GEVONDEN' % boss)
