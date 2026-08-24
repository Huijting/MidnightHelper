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

Usage: write one repo-relative path per line to
  <scratchpad>/stage.txt
then run this with no arguments. Blank lines and #-comments are ignored.
"""
import io
import os
import subprocess
import sys

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
LIST = os.path.join(
    os.environ.get("CLAUDE_SCRATCHPAD", ""), "stage.txt") if os.environ.get(
    "CLAUDE_SCRATCHPAD") else None

# Fixed fallback: the session scratchpad path is stable for this project.
if not LIST or not os.path.isfile(LIST):
    LIST = os.path.join(
        os.path.expanduser("~"), "AppData", "Local", "Temp", "claude",
        "E--World-of-Warcraft--retail--Interface-AddOns",
        "3d73686f-b8a5-478e-826d-74f066e950ea", "scratchpad", "stage.txt")

if not os.path.isfile(LIST):
    sys.exit("No stage.txt at:\n  %s\nWrite one repo-relative path per line first." % LIST)

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
