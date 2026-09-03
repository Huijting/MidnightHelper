#!/usr/bin/env python3
"""Stage files listed in a text file, so the COMMAND never varies.

WHY. CLAUDE.md's rule for permission prompts is "the variable part belongs inside the
script, so the command line never changes". We applied that to every probe and every
linter and never to `git add` -- where the argument list is different literally every
time. On 24 aug Rob got a prompt for a `git -C "<repo>" add <11 files>` even though the
allowlist carries `git -C "<repo>" *` and nothing denies it; the file was verified valid,
48 rules, no deny/ask, and the rule matches that string by prefix. The cause is still
unknown, and rather than guess a fourth theory, this removes the variability itself.

⚠️ It deliberately does NOT stage everything. Two Claude sessions share this working tree
(docs/COORDINATION.md rule 3): `git add -A` and `git add -u` would sweep up the other
session's half-finished work. Naming files stays mandatory -- they just move from the
command line into stage.txt.

Usage: write one repo-relative path per line to <scratchpad>/stage.txt, then run
  python tools/git_stage.py          -- NO ARGUMENTS, EVER. See resolve_list().
Blank lines and #-comments are ignored.

🔴 THE FALLBACK USED TO BE A HARDCODED SESSION UUID, AND ON 2 SEP 2026 IT STAGED THE WRONG
FILES. The comment called that path "stable for this project"; it is per SESSION, and that
session had ended. A newer session wrote its stage.txt, passed the path on the command line
-- which this script ignored -- and the script silently staged a list from a dead session
instead. It did not fail. It reported success, printed the stale list, and the only reason
it was caught is that the printed names were visibly wrong.

📌 Which is the same shape as the poison bug it was committing: a hardcoded snapshot of
something that moves, with nothing re-checking it. Resolution order below is explicit
argument, then environment, then newest on disk -- and it says which one it used.
"""
import io
import glob
import os
import subprocess
import sys

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

SCRATCH_ROOT = os.path.join(
    os.path.expanduser("~"), "AppData", "Local", "Temp", "claude",
    "E--World-of-Warcraft--retail--Interface-AddOns")


def resolve_list():
    """Return (path, how) for the stage.txt to use.

    🔴 THE COMMAND-LINE ARGUMENT IS GONE AGAIN, AND THAT IS THE WHOLE POINT OF THIS FILE.
    On the morning of 3 Sep the hardcoded-session-id fallback was replaced by "pass the
    path as argv[1]" -- which reads like an improvement and destroyed the one property
    this tool exists for. The allowlist carries `Bash(python ".../git_stage.py")` with NO
    trailing wildcard, so the moment an argument is added the command stops matching and
    Rob is prompted on every single stage. He was, about ten times that day, and it was
    the second thing on his list when he asked why the prompts were back.

    ⚠️ So: never accept a path here. The newest stage.txt on disk is found instead, which
    handles the multi-session case the hardcoded id got wrong without changing the
    command string. If argv carries something anyway, say so loudly rather than using it.
    """
    if len(sys.argv) > 1:
        print("⚠️  ignoring the argument %r: this tool must stay argument-free or the\n"
              "    allowlist stops matching and every run prompts. Using the newest\n"
              "    stage.txt on disk instead." % sys.argv[1])
    env = os.environ.get("CLAUDE_SCRATCHPAD")
    if env:
        p = os.path.join(env, "stage.txt")
        if os.path.isfile(p):
            return p, "CLAUDE_SCRATCHPAD"
    found = glob.glob(os.path.join(SCRATCH_ROOT, "*", "scratchpad", "stage.txt"))
    if found:
        newest = max(found, key=os.path.getmtime)
        return newest, "newest of %d on disk" % len(found)
    return None, "nothing found"


LIST, HOW = resolve_list()

if not LIST or not os.path.isfile(LIST):
    sys.exit("No stage.txt (%s):\n  %s\nWrite one repo-relative path per line first."
             % (HOW, LIST))

print("reading stage.txt (%s):\n   %s\n" % (HOW, LIST))

paths = []
for line in io.open(LIST, encoding="utf-8"):
    line = line.strip()
    if line and not line.startswith("#"):
        paths.append(line)

if not paths:
    sys.exit("stage.txt is empty -- nothing to stage. Refusing to guess.")

missing = [p for p in paths if not os.path.exists(os.path.join(REPO, p))]
if missing:
    # A typo'd path makes `git add` fail the whole call; catching it here says which one.
    sys.exit("These do not exist in the repo:\n  " + "\n  ".join(missing))

print("staging %d file(s):" % len(paths))
for p in paths:
    print("   " + p)

r = subprocess.run(["git", "-C", REPO, "add"] + paths,
                   capture_output=True, text=True, encoding="utf-8", errors="replace")
if r.stdout.strip():
    print(r.stdout.rstrip())
if r.returncode != 0:
    print(r.stderr.rstrip())
    sys.exit(r.returncode)

# Positive control: say what git now has staged, so "it ran" and "it worked" are not the
# same claim. An empty diff here means nothing was actually staged.
s = subprocess.run(["git", "-C", REPO, "diff", "--cached", "--name-only"],
                   capture_output=True, text=True, encoding="utf-8", errors="replace")
staged = [l for l in s.stdout.splitlines() if l.strip()]
print("\nnow staged: %d" % len(staged))
for l in staged:
    print("   " + l)
