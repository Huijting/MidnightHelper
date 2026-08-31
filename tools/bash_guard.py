#!/usr/bin/env python3
"""PreToolUse guard: refuse Bash commands that can never match a permission rule.

WHY THIS EXISTS. Rob asked five times for the chained-command habit to stop, and five
times it came back. CLAUDE.md has carried the rule since 8 August; the fix that finally
holds cannot be another paragraph asking nicely.

The measurement behind it (15 Aug, 50 sessions, 6274 Bash calls): 86% of calls were
principally unmatchable -- 4820 with `&&`, 442 with a pipe, 87 with `;`. A permission rule
matches a command STRING, so a compound line matches nothing and prompts every single time,
no matter how many rules exist. .claude/settings.local.json has ~900 dead entries proving it.

Meanwhile the allowlist already covers everything actually needed:

    git -C "<repo>" *        every git command, no prompt
    python tools/_probe.py   anything needing logic, pipes or several steps
    luac -p *  grep *  ls *  head *  tail *  wc *

So this blocks the shapes that cannot match and names the replacement. Being stopped costs
one retry; a prompt costs Rob a click and his attention, every time.

Exit 2 blocks the call and shows stderr to Claude.
"""
import json
import re
import sys

REPO = "E:/World of Warcraft/_retail_/Interface/AddOns/MidnightHelper"

# Shapes no permission rule can ever match.
PATTERNS = [
    (r"&&", "&&"),
    (r"\|\|", "||"),
    (r";", ";"),
    (r"(?<![0-9])\|(?!\|)", "a pipe"),
    (r"<<", "a heredoc"),
    (r"\bpython\s+-c\b", "python -c"),
    (r"\bpython\s+-\s*$", "python - (reads stdin and hangs)"),
]

ADVICE = """
Rewrite it as ONE command that a rule can match:

  git        ->  git -C "{repo}" <args>          (allowlisted with a wildcard)
  counting   ->  git rev-list --count <range>    (no `| wc -l` needed)
  logic,
  pipes,
  several
  steps      ->  put it in tools/_probe.py, then: python tools/_probe.py

  luac -p <file>, grep, ls, head, tail, wc are allowed bare -- just not chained.

Two separate tool calls are cheaper than one prompt.
""".format(repo=REPO)


def main() -> int:
    try:
        payload = json.load(sys.stdin)
    except Exception:
        return 0  # never block on a payload we cannot read

    tool = payload.get("tool_name")

    # 🔴 The PowerShell tool is banned outright, and this guard used to let it straight
    # through -- it checked for "Bash" and returned on anything else. MEASURED 31 Aug 2026:
    # a subagent I briefed on research, but not on our shell rules, reached for PowerShell
    # and put an allow-prompt on Rob's PHONE while he was travelling. Agents obey the SAME
    # permission rules I do; nothing here was exempting them. The hole was that no rule and
    # no guard covered this tool, so there was nothing for them to obey.
    #
    # ⚠️ A guard that only covers the tool I happen to prefer is not a guard.
    if tool == "PowerShell":
        sys.stderr.write(
            "Blocked: the PowerShell tool is not used in this project.\n\n"
            "Every PowerShell line here is a unique string, so no permission rule can ever "
            "match one and Rob gets a prompt for each -- that is how ~938 dead rules ended "
            "up in settings.local.json.\n\n"
            "  files      ->  Glob, Grep, Read   (these never prompt)\n"
            "  anything\n"
            "  scripted   ->  python \"{repo}/tools/_probe.py\" run <tool> [args]\n\n"
            "See CLAUDE.md. If you are a subagent: this applies to you too.\n".format(repo=REPO))
        return 2

    if tool != "Bash":
        return 0
    cmd = (payload.get("tool_input") or {}).get("command") or ""
    if not cmd.strip():
        return 0

    # Quoted text is data, not shell syntax: a commit message may say "A && B".
    stripped = re.sub(r'"(?:[^"\\]|\\.)*"', '""', cmd)
    stripped = re.sub(r"'(?:[^'\\]|\\.)*'", "''", stripped)

    hits = [label for pat, label in PATTERNS if re.search(pat, stripped)]
    if not hits:
        return 0

    sys.stderr.write(
        "Blocked: this command contains {} and so can never match a permission "
        "rule -- it would prompt Rob, every time.\n{}".format(
            ", ".join(dict.fromkeys(hits)), ADVICE))
    return 2


if __name__ == "__main__":
    sys.exit(main())
