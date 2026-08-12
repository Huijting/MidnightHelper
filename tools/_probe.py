"""Scratch script — rewritten per task, always run as tools/_probe.py.

Right now: the nine 2.14.0 changelog lines into enUS (English only, by design).
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

P = r'E:\World of Warcraft\_retail_\Interface\AddOns\MidnightHelper\Locales\enUS.lua'

LINES = [
    ("CHANGELOG_2140_1",
     "New: /mh setup. Laying out your bars was a set of commands you had to run from "
     "memory, in the right order, on the right character - and getting that wrong cost "
     "one of us eight keybinds. It is a panel now. It says who you are and whether your "
     "keys are account-wide or this character's own BEFORE offering anything that "
     "changes them, and nothing destructive happens on a single click."),
    ("CHANGELOG_2140_2",
     "New: the addon offers, once. Open Midnight Helper on a character whose bars have "
     "never been set up and a card asks whether it should do it for you. There was no "
     "way to discover /mh setup existed - a changelog is read by nobody and the store "
     "page is read once, before installing. Dismiss it and it stays dismissed."),
    ("CHANGELOG_2140_3",
     "New: our bar layout as something you can apply, not a picture to copy by hand. It "
     "changes action bars 1-8 and nothing else, so your minimap, unit frames and macro "
     "bars stay put, and a button next to it puts your old layout back. It refuses "
     "politely if another addon is already arranging those bars."),
    ("CHANGELOG_2140_4",
     "New: thumb-button keys onto action bar 8. If your mouse sends 6 7 8 9 0 - instead "
     "of mouse buttons, one press puts them on bar 8 and leaves every key you already "
     "bound exactly where your hands expect it. A layout change is a habit change, so it "
     "shows you the plan first and moves nothing until you press again."),
    ("CHANGELOG_2140_5",
     "New: a small quick bar, off by default: /mh bar. Midnight Helper, reload, the "
     "setup panel, and leaving a group - including leaving a delve, which needed its own "
     "call because solo in a delve there is no party to leave."),
    ("CHANGELOG_2140_6",
     "New: your healing potion and healthstone as keybinds instead of action bar slots. "
     "Bind them in Blizzard's own keybinding screen under Midnight Helper. Nothing is "
     "bound by default."),
    ("CHANGELOG_2140_7",
     "New: /mh fps reads out the graphics settings that cost the most frames and changes "
     "none of them. It tells an untouched default apart from a deliberate choice, "
     "because the two look identical and only one is worth mentioning. Also new: a "
     "Details! damage meter page, which copies a profile for you to paste - it never "
     "imports anything on its own."),
    ("CHANGELOG_2140_8",
     "Ready for patch 12.1. The world boss scan used a function 12.1 removed and failed "
     "silently, falling back to a stale answer. In combat, 12.1 hides some of your own "
     "buffs and reports them as simply not there - measured, three of five - so the "
     "addon now answers “cannot tell” instead of “you do not have it”. And the Season "
     "2 gate opened on patch day because it keyed off a number that changes with the "
     "patch rather than the season."),
    ("CHANGELOG_2140_9",
     "Fixed: the search box did not index the Addons pages at all, so searching for the "
     "tools they cover found nothing. Commands are searchable by what they do rather "
     "than what they are called. Shift+scroll now resizes every dialog, not just one. "
     "And the About window credited the wrong people."),
]

t = open(P, encoding='utf-8', newline='').read()
if LINES[0][0] in t:
    print('stond er al in')
    raise SystemExit(0)

nl = '\r\n' if '\r\n' in t else '\n'
m = re.compile(r'^\tCHANGELOG_2130_1 = ', re.M).search(t)
if not m:
    print('geen anker')
    raise SystemExit(1)

for key, text in LINES:
    assert '"' not in text, key

block = nl.join('\t%s = "%s",' % (k, v) for k, v in LINES) + nl
t = t[:m.start()] + block + t[m.start():]
io.open(P + '.tmp', 'w', encoding='utf-8', newline='').write(t)
os.replace(P + '.tmp', P)
print('%d regels toegevoegd' % len(LINES))
