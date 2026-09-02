#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""gh_inbox.py -- the morning GitHub round for Huijting/MidnightHelper.

WHY THIS EXISTS
    Rob, 30 aug 2026: "zodat we niet weer na 17 dagen erachter komen dat iemand ons wilde
    helpen." AndyMM22's five pull requests sat open from 7 August and were first read on
    25 August. No watcher covers this -- they all look at Blizzard, not at people trying to
    help us -- and GitHub sends no notification anyone here reads.

WHY IT IS ONE SCRIPT AND NOT A HANDFUL OF gh CALLS
    Loose `gh ...` invocations match no permission rule, so each one costs Rob a prompt.
    tools/_probe.py is on the allowlist, so the front door is:

        python "<repo>/tools/_probe.py" run gh_inbox

    Anything variable belongs inside this file, never on the command line.

READ THE SILENCE OUT LOUD
    An empty inbox is a result and must be printed as one. Saying nothing about nothing is
    exactly how those 17 days happened.
"""

import json
import subprocess
import sys

REPO = "Huijting/MidnightHelper"

# How far back a closed item is still worth showing. Open items are always shown, however old.
RECENT_COMMENTS = 15


def gh(args):
    """Run one gh call and return parsed JSON, or None if gh itself failed.

    A failure here is reported rather than swallowed: "gh is not logged in" and "nobody has
    written to us" must never look the same on screen.
    """
    try:
        out = subprocess.run(
            ["gh"] + args,
            capture_output=True,
            text=True,
            encoding="utf-8",
            errors="replace",
        )
    except FileNotFoundError:
        print("  !! gh is not installed or not on PATH -- inbox NOT checked")
        return None
    if out.returncode != 0:
        err = (out.stderr or "").strip().splitlines()
        print("  !! gh failed (exit %d) -- inbox NOT checked" % out.returncode)
        for line in err[:4]:
            print("     %s" % line)
        return None
    try:
        return json.loads(out.stdout or "[]")
    except ValueError:
        print("  !! gh returned something that is not JSON -- inbox NOT checked")
        return None


def show_items(kind, items, empty="none open"):
    if items is None:
        return
    if not items:
        print("  %s. (measured, not assumed)" % empty)
        return
    for it in items:
        who = (it.get("author") or {}).get("login", "?")
        print(
            "  #%-4s %-18s %s"
            % (it.get("number"), who, (it.get("title") or "").strip())
        )
        print("        opened %s  updated %s" % (it.get("createdAt", "?")[:10],
                                                 it.get("updatedAt", "?")[:10]))
        if kind == "pr" and it.get("isDraft"):
            print("        (draft)")


def main():
    print("GitHub round -- %s" % REPO)

    print("\nOPEN ISSUES")
    show_items(
        "issue",
        gh(["issue", "list", "--repo", REPO, "--state", "open", "--limit", "30",
            "--json", "number,title,author,createdAt,updatedAt"]),
    )

    print("\nOPEN PULL REQUESTS")
    show_items(
        "pr",
        gh(["pr", "list", "--repo", REPO, "--state", "open", "--limit", "30",
            "--json", "number,title,author,createdAt,updatedAt,isDraft"]),
    )

    # Comments are where a conversation continues after the issue itself stops being "new",
    # so a round that only lists open items still misses people.
    print("\nNEWEST COMMENTS (issues + PRs, most recent first)")
    comments = gh([
        "api",
        "repos/%s/issues/comments?sort=created&direction=desc&per_page=%d"
        % (REPO, RECENT_COMMENTS),
    ])
    if comments is not None:
        if not comments:
            print("  none ever. (measured, not assumed)")
        for c in comments:
            who = (c.get("user") or {}).get("login", "?")
            body = " ".join((c.get("body") or "").split())
            if len(body) > 100:
                body = body[:100] + "..."
            # issue_url ends in /issues/<n> for both issues and PRs
            num = (c.get("issue_url") or "").rsplit("/", 1)[-1]
            print("  %s  #%-4s %-18s %s" % (c.get("created_at", "?")[:10], num, who, body))

    # ⚠️ `gh issue list` does NOT include pull requests, so an empty closed-issue list says
    # nothing about merged PRs -- #1/#2/#4/#5 are PRs and will never appear here.
    print("\nRecently closed ISSUES (last 10 -- pull requests are not included here)")
    show_items(
        "issue",
        gh(["issue", "list", "--repo", REPO, "--state", "closed", "--limit", "10",
            "--json", "number,title,author,createdAt,updatedAt"]),
        empty="no closed issues",
    )

    print("\nRecently closed PULL REQUESTS (last 10)")
    show_items(
        "pr",
        gh(["pr", "list", "--repo", REPO, "--state", "closed", "--limit", "10",
            "--json", "number,title,author,createdAt,updatedAt,isDraft"]),
        empty="no closed pull requests",
    )
    return 0


if __name__ == "__main__":
    sys.exit(main())
