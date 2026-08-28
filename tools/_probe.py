#!/usr/bin/env python3
"""Ask GitHub whether anyone has reacted: issues, PRs, discussions and recent comments.

Rob asked "kijk op github of er nog iemand gereageerd heeft". Everything goes through one
allowlisted command (`python tools/_probe.py`) so it costs no permission prompt.

It reports what it COULD NOT check as loudly as what it found -- an empty answer from a
tool that never ran looks exactly like "nobody reacted".
"""
import json
import os
import subprocess

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))


def run(args):
    try:
        r = subprocess.run(args, capture_output=True, text=True, encoding="utf-8",
                           errors="replace", cwd=REPO)
    except FileNotFoundError:
        return None, "command not found: " + args[0]
    if r.returncode != 0:
        return None, (r.stderr or r.stdout).strip()
    return r.stdout, None


# --- which repo are we even talking to? -----------------------------------------------
url, err = run(["git", "-C", REPO, "remote", "get-url", "origin"])
print("origin: " + (url.strip() if url else "UNKNOWN (%s)" % err))

ver, err = run(["gh", "--version"])
if not ver:
    raise SystemExit("gh CLI unavailable: %s\nNothing was checked -- do not read this as "
                     "'nobody reacted'." % err)
print("gh: " + ver.splitlines()[0])

auth, err = run(["gh", "auth", "status"])
if err:
    print("!! gh auth status failed: " + err)

FIELDS = "number,title,state,author,updatedAt,comments,url"


def show(kind, args, empty):
    out, e = run(args)
    print("\n=== %s ===" % kind)
    if e:
        print("!! could not check: " + e)
        return
    try:
        rows = json.loads(out)
    except Exception:
        print("!! unreadable answer: " + (out or "")[:400])
        return
    if not rows:
        print(empty)
        return
    for r in rows:
        who = (r.get("author") or {}).get("login", "?")
        n = r.get("comments")
        n = len(n) if isinstance(n, list) else (n or 0)
        print("#%s  %s  [%s]  by %s  updated %s  comments: %d"
              % (r.get("number"), (r.get("title") or "")[:70], r.get("state"), who,
                 (r.get("updatedAt") or "")[:10], n))
        print("    " + (r.get("url") or ""))
        for c in (r.get("comments") if isinstance(r.get("comments"), list) else [])[-3:]:
            ca = (c.get("author") or {}).get("login", "?")
            body = " ".join((c.get("body") or "").split())[:220]
            print("    - %s (%s): %s" % (ca, (c.get("createdAt") or "")[:10], body))


show("OPEN ISSUES", ["gh", "issue", "list", "--state", "open", "--limit", "30",
                     "--json", FIELDS], "geen open issues")
show("RECENT CLOSED ISSUES", ["gh", "issue", "list", "--state", "closed", "--limit", "5",
                              "--json", FIELDS], "geen gesloten issues")
show("OPEN PRs", ["gh", "pr", "list", "--state", "open", "--limit", "30",
                  "--json", FIELDS], "geen open pull requests")
show("RECENT MERGED/CLOSED PRs", ["gh", "pr", "list", "--state", "closed", "--limit", "5",
                                  "--json", FIELDS], "geen gesloten pull requests")

# Comments on the newest items, so a reply on an old thread still surfaces.
out, e = run(["gh", "api", "repos/{owner}/{repo}/issues/comments?per_page=15&sort=created&direction=desc"])
print("\n=== NIEUWSTE COMMENTS (issues + PRs door elkaar) ===")
if e:
    print("!! could not check: " + e)
else:
    try:
        for c in json.loads(out):
            who = (c.get("user") or {}).get("login", "?")
            body = " ".join((c.get("body") or "").split())[:240]
            print("%s  %s  op %s\n    %s" % ((c.get("created_at") or "")[:16], who,
                                             (c.get("issue_url") or "").rsplit("/", 1)[-1],
                                             body))
    except Exception:
        print("!! unreadable: " + (out or "")[:400])
