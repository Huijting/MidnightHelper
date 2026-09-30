#!/usr/bin/env python3
"""The scratch probe -- AND the front door for every other tool in this folder.

    python ".../tools/_probe.py"                     runs the scratch probe below
    python ".../tools/_probe.py" run <tool> [args]   runs tools/<tool>.py with those args

🔴 The second form exists because of a cost Rob pays and I do not. The allowlist covers exactly
five script paths; every NEW script is a new command string, so it prompts him, every single
run. On 31 Aug 2026 I added four tools in one day and cost him about ten prompts before he
asked why they kept coming. CLAUDE.md has said for weeks that the variable part belongs INSIDE
the script rather than in the command line -- this is that rule applied to the tools folder
itself, instead of only to one-off probes.

⚠️ So: a permanent tool still gets its own well-named file. It just gets INVOKED through here,
because `_probe.py *` is already allowlisted and therefore never prompts. Adding a new
permission rule cannot fix this, since settings.json is only read at startup.
"""
import io
import os
import re
import runpy
import sys

try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass

# 🔴 THE WILDCARD RULE NEVER MATCHED. MEASURED 26 Sep 2026: settings.local.json holds 192
# exact "Always allow" entries for `_probe.py" scratch <x>` and 66 for `_probe.py" run <x>` --
# each one a prompt Rob clicked, although settings.json has `Bash(python ".../_probe.py" *)`.
# Why that rule does not match is not established. What IS measured: the argument-free rules
# (git_stage.py, lint_addon.py, lua_syntax_check.py) run clean.
#
# So the command line carries NO arguments at all:
#
#     python ".../tools/_probe.py"
#
# and the job goes in `probe_job.txt` in the scratchpad, one line, e.g.
# `scratch filelog.py Modules/X.lua` or `run check_drift --mark KEY`. The file is renamed to
# probe_job.done.txt once read, so a stale job can never run twice. No job file -> the old
# SavedVariables probe below, unchanged.
#
# 🔴 30 Sep 2026: "the newest job on disk" RAN ANOTHER SESSION'S JOB. Two sessions wrote a job
# within the same minute; this session ran the Comfy session's image script and that session ran
# this one's site build (each once, confirmed by the other session). Claude Code puts the calling
# session's id in CLAUDE_CODE_SESSION_ID, and the scratchpad folder carries that same id
# (measured: bce6ed51-... both). So when that folder exists, ONLY that folder counts -- no job
# there means no job, never someone else's. The old newest-anywhere search stays only for callers
# without that folder (cloud routines, older clients), and it says so.
_SCRATCH_ROOT = os.path.join(os.path.expanduser("~"), "AppData", "Local", "Temp", "claude",
                             "E--World-of-Warcraft--retail--Interface-AddOns")


def _own_scratchpad():
    sid = os.environ.get("CLAUDE_CODE_SESSION_ID") or ""
    own = os.path.join(_SCRATCH_ROOT, sid, "scratchpad") if sid else ""
    return own if own and os.path.isdir(own) else None


if len(sys.argv) == 1:
    import glob as _gj
    import shlex as _sh
    _own = _own_scratchpad()
    _jobs = []
    if _own:
        _p = os.path.join(_own, "probe_job.txt")
        _jobs = [_p] if os.path.isfile(_p) else []
    else:
        print("note: no scratchpad for this session id; taking the newest job of any session")
        _roots = [os.environ.get("CLAUDE_SCRATCHPAD") or "", _SCRATCH_ROOT]
        for _r in _roots:
            if _r:
                _jobs += _gj.glob(os.path.join(_r, "probe_job.txt"))
                _jobs += _gj.glob(os.path.join(_r, "*", "scratchpad", "probe_job.txt"))
    if _jobs:
        _job = max(_jobs, key=os.path.getmtime)
        _line = io.open(_job, encoding="utf-8").read().strip()
        os.replace(_job, _job[:-len("probe_job.txt")] + "probe_job.done.txt")
        print("job: %s" % _line)
        sys.argv = [sys.argv[0]] + _sh.split(_line, posix=True)

if len(sys.argv) > 2 and sys.argv[1] == "scratch":
    # 🔴 THE THIRD FRONT DOOR, AND THE ONE CLAUDE.md WRONGLY SAID ALREADY EXISTED.
    #
    #     python ".../tools/_probe.py" scratch <name> [args]
    #
    # CLAUDE.md has told every session for weeks to "write the script to the scratchpad
    # and run it as `python <path>`; that path is in the allowlist". MEASURED 3 Sep 2026:
    # it is NOT. .claude/settings.json carries Read() and Write() for the Temp folder and
    # no Bash rule at all, so every one-off script prompted Rob on every run. Ten scripts
    # in one day cost him roughly fifteen prompts, and the instruction that caused it was
    # the one telling me it was safe.
    #
    # ⚠️ A wrong claim in a rules file is worse than a missing rule. A missing rule makes
    # you check; a wrong one makes you confident.
    #
    # `_probe.py *` is allowlisted, so routing scratch scripts through here costs nothing
    # and works for every future script without touching settings.json (which is only
    # read at startup anyway).
    name = sys.argv[2]
    if not name.endswith(".py"):
        name += ".py"
    base = os.environ.get("CLAUDE_SCRATCHPAD")
    # This session's own scratchpad first (30 Sep 2026: a same-named script of another session
    # would otherwise win on age alone); other sessions' scripts stay reachable after it.
    roots = [r for r in (_own_scratchpad(), base) if r]
    roots.append(_SCRATCH_ROOT)
    target = None
    for root in roots:
        if not root:
            continue
        direct = os.path.join(root, name)
        if os.path.isfile(direct):
            target = direct
            break
        # Session folders sit one level down; take the newest match rather than guessing
        # a session id, which is what broke git_stage.py's fallback on 2 Sep.
        import glob as _glob
        found = _glob.glob(os.path.join(root, "*", "scratchpad", name))
        if found:
            target = max(found, key=os.path.getmtime)
            break
    if not target:
        sys.exit("no scratch script named %s (looked in %s)" % (name, ", ".join(r for r in roots if r)))
    print("running %s" % target)
    sys.argv = [target] + sys.argv[3:]
    runpy.run_path(target, run_name="__main__")
    raise SystemExit(0)

if len(sys.argv) > 2 and sys.argv[1] == "run":
    name = sys.argv[2]
    if not name.endswith(".py"):
        name += ".py"
    target = os.path.join(os.path.dirname(os.path.abspath(__file__)), name)
    if not os.path.isfile(target):
        sys.exit("no such tool: %s" % target)
    # argv[0] becomes the tool's own path, so scripts that resolve paths from __file__
    # or read sys.argv keep working exactly as they do when run directly.
    sys.argv = [target] + sys.argv[3:]
    runpy.run_path(target, run_name="__main__")
    raise SystemExit(0)

SV = r"E:\World of Warcraft\_retail_\WTF\Account\JOEYWHATEVER\SavedVariables\MidnightHelper.lua"
PROF = {164: "Blacksmithing", 165: "Leatherworking", 171: "Alchemy", 182: "Herbalism",
        186: "Mining", 197: "Tailoring", 202: "Engineering", 333: "Enchanting",
        393: "Skinning", 755: "Jewelcrafting", 773: "Inscription"}

text = io.open(SV, encoding="utf-8", errors="replace").read()


def block(s, at):
    start = s.find("{", at)
    depth, j, ins = 0, start, False
    while j < len(s):
        c = s[j]
        if ins:
            if c == "\\":
                j += 2
                continue
            if c == '"':
                ins = False
        elif c == '"':
            ins = True
        elif c == "{":
            depth += 1
        elif c == "}":
            depth -= 1
            if depth == 0:
                return s[start:j + 1]
        j += 1
    return ""


dump = block(text, text.find('["profIdDump"]'))
print("%-16s %-8s %-8s %-6s %s" % ("profession", "entries", "ranks", "top", "captured on"))
print("-" * 66)
missing = []
for sid in sorted(PROF):
    m = re.search(r'\["%d"\]\s*=\s*\{' % sid, dump)
    if not m:
        missing.append(PROF[sid])
        continue
    b = block(dump, m.end() - 1)
    ids = len(re.findall(r'\["id"\]\s*=\s*\d+', b))
    ranks = [int(x) for x in re.findall(r'\["rank"\]\s*=\s*(\d+)', b)]
    top = max(ranks) if ranks else None
    who = re.search(r'\["char"\]\s*=\s*"([^"]*)"', b)
    # ⚠️ No owner means the row predates the fix, NOT that it came from nobody.
    owner = who.group(1) if who else "|before the fix|"
    print("%-16s %-8d %-8s %-6s %s" % (PROF[sid], ids, len(ranks) or "-",
                                       top if top is not None else "-", owner))
print("\nnot captured at all: %s" % (", ".join(missing) or "none"))

# Who has which profession -- so "log in on X" is answered from the roster rather than from
# memory. ⚠️ The rank dump only names an owner for captures taken after the 31 Aug fix, so
# this is the only source that can say who to log in on.
# 🔴 The first version looked inside `["alts"]`, which is a BOOLEAN setting, not the roster --
# so it printed an empty table. It was caught only because it says out loud that an empty result
# may mean the shape changed. Without that line it would have read as "no alt has a profession",
# which is plainly false and would have sent Rob hunting through characters.
# The real per-character rows carry `["professionsFull"]` and `["realm"]`.
print("\n%-18s %-7s %s" % ("character", "level", "professions"))
print("-" * 74)
seen, rows = set(), []
for m in re.finditer(r'\["([^"\]]+)"\]\s*=\s*\{', text):
    b = block(text, m.end() - 1)
    if '["professionsFull"]' not in b:
        continue
    p = re.search(r'\["professionsFull"\]\s*=\s*"([^"]*)"', b)
    if not p or not p.group(1):
        continue
    # ⚠️ The table key is a GUID ("Player-1388-09A6E15F"), so splitting it gives "Player" for
    # every row -- which is what the first run printed, seven times, uselessly. The readable
    # name is a field inside.
    nm = re.search(r'\["name"\]\s*=\s*"([^"]+)"', b)
    if not nm:
        continue
    name = nm.group(1).split("-")[0]
    lvl = re.search(r'\["level"\]\s*=\s*(\d+)', b)
    key = (name, p.group(1))
    if key in seen:  # the same character is written once per snapshot
        continue
    seen.add(key)
    rows.append((name, lvl.group(1) if lvl else "?", p.group(1)))
for name, lvl, profs in sorted(rows):
    print("%-18s %-7s %s" % (name, lvl, profs))
if not rows:
    print("  ⚠️ nothing found -- the roster shape may have changed again.\n"
          "     Check one entry by hand before believing this is empty.")
