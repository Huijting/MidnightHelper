#!/usr/bin/env python3
"""Stop-hook wrapper around lint_addon.py.

Runs the addon linter once per turn and, when it finds HARD issues, blocks the
turn with the failing output so Claude fixes it before Rob reloads the game.

Why a Stop hook and not PostToolUse on Write|Edit:
    On 2026-07-22 a broken locale line reached Rob's running game and rendered
    the entire interface as raw keys. That edit was made by a Python heredoc
    through the Bash tool, not through Edit — so a Write|Edit matcher would have
    missed exactly the case that caused the outage. Stop fires once at the end of
    a turn regardless of HOW the files changed, which is the property we need.
    It also costs one 2.2s run per turn instead of one per edit.

Why blocking rather than a passive message:
    The repo IS the live AddOns folder, so a broken file is already in Rob's game
    the moment it is written. The only useful moment to catch it is before the
    turn ends and he reloads.

Escape hatch: if the linter is failing for a reason that cannot be fixed right
now, disable the hook from the /hooks menu rather than fighting it.
"""
import json
import os
import subprocess
import sys

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
MAX_REASON_LINES = 25


def main() -> int:
    linter = os.path.join(REPO, "tools", "lint_addon.py")
    if not os.path.isfile(linter):
        return 0  # nothing to run; never make the absence of the linter fatal

    try:
        proc = subprocess.run(
            [sys.executable, linter],
            cwd=REPO,
            capture_output=True,
            text=True,
            timeout=120,
        )
    except Exception:
        # A hook that crashes must not take the turn with it.
        return 0

    if proc.returncode == 0:
        return 0

    output = (proc.stdout or "") + (proc.stderr or "")
    lines = [ln for ln in output.splitlines() if ln.strip()]
    tail = "\n".join(lines[-MAX_REASON_LINES:])

    print(json.dumps({
        "decision": "block",
        "reason": (
            "tools/lint_addon.py reports HARD issues. The repo is the live AddOns "
            "folder, so this is already in the running game — fix it before the turn "
            "ends.\n\n" + tail
        ),
        "systemMessage": "Addon linter found hard issues — see the transcript.",
    }))
    return 0


if __name__ == "__main__":
    sys.exit(main())
