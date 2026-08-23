# -*- coding: utf-8 -*-
"""Test the bash guard: does it block what it should and pass what it should?"""
import json
import subprocess
import sys

import os

# ⚠️ Absolute. A missing script also exits 2, which is the guard's own "blocked" code —
# so a wrong path reads as "everything is blocked" and the test lies in the safe-looking
# direction. Same class as the earlier probe that reported keys as translated.
GUARD = ["python", os.path.join(os.path.dirname(os.path.abspath(__file__)), "bash_guard.py")]

CASES = [
    # (command, should_be_blocked)
    ('cd "E:/x" && git log --oneline v3.4.0..main | wc -l', True),
    ('git log --oneline | wc -l', True),
    ('ls; echo hi', True),
    ('python -c "print(1)"', True),
    ('cat <<EOF', True),
    ('git -C "E:/World of Warcraft/_retail_/Interface/AddOns/MidnightHelper" status --short', False),
    ('python tools/lint_addon.py', False),
    ('luac -p Locales/enUS.lua', False),
    ('git commit -F msg.txt', False),
    # Quoted shell characters are data, not syntax.
    ('git -C "E:/repo" commit -m "fixed A && B"', False),
]

fails = 0
for cmd, expect_block in CASES:
    payload = json.dumps({"tool_name": "Bash", "tool_input": {"command": cmd}})
    p = subprocess.run(GUARD, input=payload, capture_output=True, text=True)
    blocked = (p.returncode == 2)
    ok = (blocked == expect_block)
    if not ok:
        fails += 1
    print("{}  blocked={:<5} want={:<5}  {}".format(
        "ok " if ok else "FAIL", str(blocked), str(expect_block), cmd[:58]))

print("\nfailures:", fails)
sys.exit(1 if fails else 0)
