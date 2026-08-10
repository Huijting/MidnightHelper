"""Scratch script — rewritten per task, always run as tools/_probe.py.

Right now: register LayoutWizard in the .toc and route `/mh setup`.
"""
import io, os

p = r'E:\World of Warcraft\_retail_\Interface\AddOns\MidnightHelper\MidnightHelper.toc'
t = open(p, encoding='utf-8-sig', newline='').read()
if 'LayoutWizard' not in t:
    t = t.replace('Modules\\BarPlanCard.lua',
                  'Modules\\BarPlanCard.lua\nModules\\LayoutWizard.lua')
    io.open(p + '.tmp', 'w', encoding='utf-8-sig', newline='').write(t)
    os.replace(p + '.tmp', p)
    print('toc ok')
else:
    print('toc already')

p = r'E:\World of Warcraft\_retail_\Interface\AddOns\MidnightHelper\Core.lua'
t = open(p, encoding='utf-8', newline='').read()
anchor = '\tif msg == "bars plan" then'
if 'msg == "setup"' in t:
    print('route already')
else:
    assert anchor in t
    add = ('\tif msg == "setup" then\n'
           '\t\tif ns.MH_ShowLayoutWizard then\n'
           '\t\t\tns.MH_ShowLayoutWizard()\n'
           '\t\tend\n'
           '\t\treturn\n'
           '\tend\n\n')
    t = t.replace(anchor, add + anchor, 1)
    io.open(p + '.tmp', 'w', encoding='utf-8', newline='').write(t)
    os.replace(p + '.tmp', p)
    print('route ok')
