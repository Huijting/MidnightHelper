"""tools/fcq_check.py — offline check of Modules/ForeverClassQuests.lua (17 Nov 2026, Bouwchat 17-11).

Runs tools/fcq_check.lua with the Lua interpreter: every class x race x faction, levels 1-60, every quest state.
Then checks that every FCQ_* key the module names (and every key the walk used) exists in enUS.lua and nlNL.lua.
Proves the code runs and the texts exist; NOT that quest ids, places or names are right (only the game does).
Use: `run fcq_check` via tools/_probe.py (job in probe_job.txt).
"""
import os
import re
import subprocess
import sys

TOOLS = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.dirname(TOOLS)
LUA = r"C:\Users\RobHu\AppData\Local\Programs\Lua\bin\lua.exe"
MODULE = os.path.join(REPO, "Modules", "ForeverClassQuests.lua")


def has_key(text, key):
    return re.search(r"^\s*" + re.escape(key) + r"\s*=", text, re.M) is not None


def main():
    res = subprocess.run([LUA, os.path.join(TOOLS, "fcq_check.lua"), MODULE],
                         capture_output=True, text=True, encoding="utf-8", errors="replace")
    used = []
    for line in res.stdout.splitlines():
        if line.startswith("KEY:"):
            used.append(line[4:])
        else:
            print(line)
    if res.stderr.strip():
        print("STDERR:", res.stderr.strip())
    bad = res.returncode != 0 or "ERROR " in res.stdout

    mod = open(MODULE, encoding="utf-8").read()
    written = set(re.findall(r'"(FCQ_[A-Z0-9_]+)"', mod))
    keys = sorted(written | set(used))
    for loc in ("enUS", "nlNL"):
        text = open(os.path.join(REPO, "Locales", loc + ".lua"), encoding="utf-8").read()
        missing = [k for k in keys if not has_key(text, k)]
        print(f"{loc}: {len(keys)} FCQ keys (named in the module or used by the walk), missing {len(missing)}: {missing}")
        bad = bad or bool(missing)
    # Positive control: a key that certainly exists must be found by the same test.
    en = open(os.path.join(REPO, "Locales", "enUS.lua"), encoding="utf-8").read()
    print("control FCQ_LINE_FMT found:", has_key(en, "FCQ_LINE_FMT"))
    print("RESULT:", "FAIL" if bad else "OK")
    return 1 if bad else 0


if __name__ == "__main__":
    sys.exit(main())
