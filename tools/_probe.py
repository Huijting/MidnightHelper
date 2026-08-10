"""Scratch script — rewritten per task, always run as tools/_probe.py.

Right now: move PresetCount above its first caller in EditModeBackup.lua.
"""
import io, os, re

p = r'E:\World of Warcraft\_retail_\Interface\AddOns\MidnightHelper\Modules\EditModeBackup.lua'
t = open(p, encoding='utf-8', newline='').read()

start = t.index('local function PresetCount()')
end = t.index('\nend\n', start) + len('\nend\n')
block = t[start:end]

# lift it out
t = t[:start] + t[end:]

# and put it back just above the first function that needs it
anchor = "--- `/mh editmode export` — the bars, and only the bars."
assert anchor in t
t = t.replace(anchor, block + '\n' + anchor, 1)

io.open(p + '.tmp', 'w', encoding='utf-8', newline='').write(t)
os.replace(p + '.tmp', p)
print('PresetCount verplaatst naar boven zijn eerste aanroeper')
