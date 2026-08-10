"""Scratch script — rewritten per task, always run as tools/_probe.py.

Right now: register BarPlanCard in the .toc and route `/mh bars plan`.
"""
import io, os

# --- .toc ---------------------------------------------------------------
p = r'E:\World of Warcraft\_retail_\Interface\AddOns\MidnightHelper\MidnightHelper.toc'
t = open(p, encoding='utf-8-sig', newline='').read()
if 'BarPlanCard' not in t:
    t = t.replace('Modules\\LayoutGrowth.lua',
                  'Modules\\LayoutGrowth.lua\nModules\\BarPlanCard.lua')
    io.open(p + '.tmp', 'w', encoding='utf-8-sig', newline='').write(t)
    os.replace(p + '.tmp', p)
    print('toc ok')
else:
    print('toc already')

# --- routing ------------------------------------------------------------
p = r'E:\World of Warcraft\_retail_\Interface\AddOns\MidnightHelper\Core.lua'
t = open(p, encoding='utf-8', newline='').read()
anchor = '\tif msg == "bars" then'
if 'bars plan' in t:
    print('route already')
elif anchor in t:
    add = ('\tif msg == "bars plan" then\n'
           '\t\tif ns.MH_ShowBarPlan then\n'
           '\t\t\tns.MH_ShowBarPlan()\n'
           '\t\tend\n'
           '\t\treturn\n'
           '\tend\n\n')
    t = t.replace(anchor, add + anchor, 1)
    io.open(p + '.tmp', 'w', encoding='utf-8', newline='').write(t)
    os.replace(p + '.tmp', p)
    print('route ok')
else:
    # find how /mh bars is routed so the new one sits beside it
    import re
    for m in re.finditer(r'.*bars.*', t):
        print('KANDIDAAT:', m.group(0).strip()[:100])
