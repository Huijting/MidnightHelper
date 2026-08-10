"""Scratch script — rewritten per task, always run as tools/_probe.py.

Right now: check that every command I actually ran is covered by a rule in the
PROJECT settings file, using the same prefix matching the permission system uses.
"""
import json

P = r'E:\World of Warcraft\_retail_\Interface\AddOns\.claude\settings.json'
allow = json.load(open(P, encoding='utf-8'))['permissions']['allow']

MH = 'E:/World of Warcraft/_retail_/Interface/AddOns/MidnightHelper'
SCRATCH = ('C:/Users/RobHu/AppData/Local/Temp/claude/'
           'E--World-of-Warcraft--retail--Interface-AddOns/'
           '3d73686f-b8a5-478e-826d-74f066e950ea/scratchpad')

commands = [
    'python "%s/tools/lua_syntax_check.py"' % MH,
    'python "%s/tools/lint_addon.py"' % MH,
    'python "%s/tools/_probe.py"' % MH,
    'git -C "%s" add -u' % MH,
    'git -C "%s" add tools/_probe.py' % MH,
    'git -C "%s" commit -q -F "%s/msg.txt"' % (MH, SCRATCH),
    'git -C "%s" push -q origin main' % MH,
    'git -C "%s" rev-parse --short HEAD' % MH,
    'python "%s/tools/lint_addon.py" 2>&1 | tail -3' % MH,   # pipe: can never match
]


def covered(cmd):
    for rule in allow:
        if not rule.startswith('Bash(') or not rule.endswith(')'):
            continue
        body = rule[5:-1]
        if body.endswith(' *'):
            if cmd.startswith(body[:-1]):
                return rule
        elif cmd == body:
            return rule
    return None


for c in commands:
    r = covered(c)
    mark = 'OK       ' if r else 'PROMPT   '
    print(mark + c[:96])
    if r:
        print('           via  ' + r[:92])
