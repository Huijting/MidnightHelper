# -*- coding: utf-8 -*-
"""Blizzard's own list of game events, saved once so the lint can check RegisterEvent names offline (check C1).

Plan deel 2, C1 (docs/PLAN_WERKWIJZE_2026-11-10.md; Rob 10 Nov 2026: "Ja, stap 2"). Aanleiding: on 8 Aug 2026
`LEARNED_SPELL_IN_TAB` was registered because its name appeared in other addons; 12.x threw "Attempt to register
unknown event" on the next reload.

SOURCE: github.com/Gethe/wow-ui-source, folder Interface/AddOns/Blizzard_APIDocumentationGenerated. Every
*Documentation.lua there lists its events as `LiteralName = "EVENT_NAME"`. MEASURED 10 Nov 2026: branches `live`
(12.1.5), `ptr` (12.1.7) and `forever` exist; each head commit's first line is the build ("12.1.5 (70783)").

⚠️ The list is a CANDIDATE source, not proof. Not measured: whether every event the client fires is documented there
(older events may be missing). So the lint reports a name outside the list as "nakijken", never as an error.

Usage (through the front door, CLAUDE.md):
    run event_snapshot            -> fetch and print counts, write nothing
    run event_snapshot --write    -> write tools/blizzard_events_snapshot.json
Refreshing is manual for now; later the fifth watcher's job (plan deel 3).
"""
import datetime
import io
import json
import os
import re
import sys
import urllib.request

REPO = "Gethe/wow-ui-source"
DOC_DIR = "Interface/AddOns/Blizzard_APIDocumentationGenerated"
BRANCHES = ("live", "ptr", "forever")
OUT = os.path.join(os.path.dirname(os.path.abspath(__file__)), "blizzard_events_snapshot.json")
HDR = {"User-Agent": "midnight-helper-lint", "Accept": "application/vnd.github+json"}


def get(url, raw=False):
    req = urllib.request.Request(url, headers=HDR)
    with urllib.request.urlopen(req, timeout=60) as r:
        data = r.read()
    return data.decode("utf-8", "replace") if raw else json.loads(data)


def branch_events(branch):
    head = get("https://api.github.com/repos/%s/commits/%s" % (REPO, branch))
    build = head["commit"]["message"].splitlines()[0].strip()
    files = get("https://api.github.com/repos/%s/contents/%s?ref=%s" % (REPO, DOC_DIR, head["sha"]))
    names = set()
    n_files = 0
    for f in files:
        if not f["name"].endswith(".lua"):
            continue
        n_files += 1
        src = get("https://raw.githubusercontent.com/%s/%s/%s/%s" % (REPO, head["sha"], DOC_DIR, f["name"]), raw=True)
        names.update(re.findall(r'LiteralName\s*=\s*"([A-Z0-9_]+)"', src))
    return {"build": build, "commit": head["sha"], "commit_date": head["commit"]["committer"]["date"],
            "files": n_files, "events": sorted(names)}


def main():
    sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
    write = "--write" in sys.argv[1:]
    snap = {"source": "https://github.com/%s/tree/<branch>/%s" % (REPO, DOC_DIR),
            "fetched": datetime.date.today().isoformat(), "branches": {}}
    for b in BRANCHES:
        info = branch_events(b)
        snap["branches"][b] = info
        print("%-8s %-18s %s  files %3d  events %5d" % (b, info["build"], info["commit_date"][:10],
                                                         info["files"], len(info["events"])))
    # Positive control in the same run: an event every client has must be in every list.
    for b, info in snap["branches"].items():
        if "PLAYER_LOGIN" not in info["events"] and "ADDON_LOADED" not in info["events"]:
            print("❌ %s: neither PLAYER_LOGIN nor ADDON_LOADED found — the parse is wrong, nothing written" % b)
            return 1
    print("positive control: ADDON_LOADED in", [b for b, i in snap["branches"].items() if "ADDON_LOADED" in i["events"]])
    if write:
        with open(OUT + ".tmp", "w", encoding="utf-8", newline="\n") as fh:
            json.dump(snap, fh, indent=1)
            fh.write("\n")
        os.replace(OUT + ".tmp", OUT)
        print("written:", OUT)
    else:
        print("(dry run — add --write to save)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
