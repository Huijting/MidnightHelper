#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""gh_inbox.py -- the morning round for people writing to us: CurseForge comments first, then
GitHub (Huijting/MidnightHelper).

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

import datetime
import json
import subprocess
import sys
import urllib.request

REPO = "Huijting/MidnightHelper"

# CurseForge comments (added 1 Oct 2026). Rob: "voortaan moeten we sneller dit soort comments
# zien.... 17 dagen geleden is veel te lang" -- MrsBoojiePanda's bug report sat unseen for 17
# days, because this round only ever looked at GitHub. The project page itself answers 403 to
# scripts; this JSON endpoint (the one the page loads) answered 200 without a login, measured
# 1 Oct 2026 with curl.
CF_PROJECT_ID = 1528577
CF_COMMENTS_URL = ("https://www.curseforge.com/api/v1/mods/%d/comments?pageIndex=0&pageSize=20"
                   % CF_PROJECT_ID)
CF_OUR_NAMES = {"twelveinchy"}  # Rob's CurseForge username: his replies count as answered
CF_RECENT_DAYS = 30

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


def cf_fetch():
    """The CurseForge comment threads as parsed JSON, or None (reported) if the fetch failed."""
    req = urllib.request.Request(CF_COMMENTS_URL, headers={
        "User-Agent": "curl/8.0",
        "Accept": "application/json",
    })
    try:
        with urllib.request.urlopen(req, timeout=20) as r:
            return json.loads(r.read().decode("utf-8", "replace"))
    except Exception as e:  # network, HTTP 403, bad JSON: all mean "not checked"
        print("  !! CurseForge comments NOT checked: %s" % e)
        return None


def cf_when(ms):
    try:
        return datetime.datetime.fromtimestamp(ms / 1000.0)
    except (TypeError, ValueError):
        return None


def cf_flatten(thread, out):
    """Every comment and reply of one thread, oldest first."""
    out.append(thread)
    for r in thread.get("replies") or []:
        cf_flatten(r, out)
    return out


def cf_round():
    print("\nCURSEFORGE COMMENTS (project %d)" % CF_PROJECT_ID)
    data = cf_fetch()
    if data is None:
        return
    threads = data.get("data") or []
    total = (data.get("pagination") or {}).get("totalCount")
    if not threads:
        print("  none. (measured, not assumed; totalCount=%s)" % total)
        return
    now = datetime.datetime.now()
    waiting = 0
    for t in threads:
        msgs = sorted(cf_flatten(t, []), key=lambda m: m.get("datePosted") or 0)
        last = msgs[-1]
        last_who = ((last.get("author") or {}).get("username") or "?").lower()
        answered = last_who in CF_OUR_NAMES
        newest = cf_when(last.get("datePosted"))
        age = (now - newest).days if newest else None
        if answered and age is not None and age > CF_RECENT_DAYS:
            continue  # old and answered: not worth a line every morning
        if not answered:
            waiting += 1
        first = msgs[0]
        who = (first.get("author") or {}).get("displayName", "?")
        text = " ".join((first.get("text") or "").split())
        if len(text) > 110:
            text = text[:110] + "..."
        flag = "🔴 WAITING FOR AN ANSWER" if not answered else "answered"
        print("  %s  %-18s %s" % (newest.strftime("%Y-%m-%d") if newest else "?", who, flag))
        print("        %s" % text)
        if len(msgs) > 1:
            print("        (%d messages; last by %s)" % (len(msgs), last_who))
    print("  -- %d thread(s) waiting for an answer, %s comment thread(s) in total."
          % (waiting, total))


def main():
    cf_round()
    print("\nGitHub round -- %s" % REPO)

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
