"""Scratch script — rewritten per task, always run as `python tools/_probe.py`.

One fixed path so a single exact permission rule covers it forever.
Right now: route the two new /mh editmode subcommands in Core.lua.
"""
import io, os

p = r'E:\World of Warcraft\_retail_\Interface\AddOns\MidnightHelper\Core.lua'
t = open(p, encoding='utf-8', newline='').read()

anchor = '\tif msg == "editmode export" then'
addition = '''\tif msg == "editmode restore" then
\t\tif ns.MH_EditModeRestore then
\t\t\tns.MH_EditModeRestore()
\t\tend
\t\treturn
\tend

\tdo
\t\tlocal barsArg = msg:match("^editmode%\x73+bars%\x73+(.+)$")
\t\tif barsArg then
\t\t\tif ns.MH_EditModeApplyBars then
\t\t\t\tns.MH_EditModeApplyBars(barsArg)
\t\t\tend
\t\t\treturn
\t\tend
\tend

'''

if 'editmode restore' in t:
    print('already routed')
else:
    assert anchor in t, 'anchor not found'
    t = t.replace(anchor, addition + anchor, 1)
    io.open(p + '.tmp', 'w', encoding='utf-8', newline='').write(t)
    os.replace(p + '.tmp', p)
    print('routed: editmode restore + editmode bars <string>')
