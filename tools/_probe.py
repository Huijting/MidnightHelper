"""Scratch script — rewritten per task, always run as tools/_probe.py.

Right now: route /mh editmode import in Core.lua.
"""
import io, os

p = r'E:\World of Warcraft\_retail_\Interface\AddOns\MidnightHelper\Core.lua'
t = open(p, encoding='utf-8', newline='').read()

anchor = '\tif msg == "editmode restore" then'
addition = '''\tif msg == "editmode import" then
\t\tif ns.MH_EditModeShowImport then
\t\t\tns.MH_EditModeShowImport()
\t\tend
\t\treturn
\tend

'''

if 'editmode import' in t:
    print('already routed')
else:
    assert anchor in t, 'anchor not found'
    t = t.replace(anchor, addition + anchor, 1)
    io.open(p + '.tmp', 'w', encoding='utf-8', newline='').write(t)
    os.replace(p + '.tmp', p)
    print('routed: editmode import')
