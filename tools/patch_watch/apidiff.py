"""Diff Blizzard's API documentation + Ketho's resource lists between the live and ptr branches.

Read-only research helper (15 Nov 2026). Downloads text from GitHub, never executes it.
Writes the full diff to apidiff_out.txt next to this script and prints a summary.
"""
import difflib
import io
import json
import os
import sys
import urllib.request

try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass

HERE = os.path.dirname(os.path.abspath(__file__))
OUT = os.path.join(HERE, "apidiff_out.txt")
UA = {"User-Agent": "wow-api-diff-research"}


def get(url):
    req = urllib.request.Request(url, headers=UA)
    with urllib.request.urlopen(req, timeout=90) as r:
        return r.read().decode("utf-8", "replace")


def listing(repo, path, ref):
    url = "https://api.github.com/repos/%s/contents/%s?ref=%s" % (repo, path, ref)
    out = {}
    for e in json.loads(get(url)):
        if e.get("type") == "file":
            out[e["name"]] = (e["sha"], e.get("size", 0))
    return out


def head(repo, ref):
    j = json.loads(get("https://api.github.com/repos/%s/commits/%s" % (repo, ref)))
    return "%s  %s  %s" % (ref, j["commit"]["committer"]["date"], j["commit"]["message"].splitlines()[0])


def raw(repo, ref, path):
    return get("https://raw.githubusercontent.com/%s/%s/%s" % (repo, ref, path))


JOBS = [
    ("Gethe/wow-ui-source", "Interface/AddOns/Blizzard_APIDocumentationGenerated", 3),
    ("Ketho/BlizzardInterfaceResources", "Resources", 0),
]

lines = []
summary = []
for repo, path, ctx in JOBS:
    for ref in ("live", "ptr"):
        try:
            summary.append("%s %s" % (repo, head(repo, ref)))
        except Exception as ex:
            summary.append("%s %s: head failed %s" % (repo, ref, ex))
    a = listing(repo, path, "live")
    b = listing(repo, path, "ptr")
    names = sorted(set(a) | set(b))
    changed = [n for n in names if a.get(n, (None,))[0] != b.get(n, (None,))[0]]
    summary.append("%s/%s: %d files live, %d ptr, %d differ" % (repo, path, len(a), len(b), len(changed)))
    for n in changed:
        size = max(a.get(n, (0, 0))[1], b.get(n, (0, 0))[1])
        if size > 4000000:
            summary.append("  SKIP (size %d) %s" % (size, n))
            continue
        old = raw(repo, "live", path + "/" + n).splitlines() if n in a else []
        new = raw(repo, "ptr", path + "/" + n).splitlines() if n in b else []
        d = list(difflib.unified_diff(old, new, "live/" + n, "ptr/" + n, n=ctx, lineterm=""))
        plus = sum(1 for x in d if x.startswith("+") and not x.startswith("+++"))
        minus = sum(1 for x in d if x.startswith("-") and not x.startswith("---"))
        tag = "NEW" if n not in a else ("GONE" if n not in b else "CHG")
        summary.append("  %s %-60s +%d -%d" % (tag, n, plus, minus))
        lines.append("=" * 100)
        lines.append("%s  %s/%s  (+%d -%d)" % (repo, path, n, plus, minus))
        if len(d) > 4000:
            lines.extend(d[:4000])
            lines.append("... (%d more diff lines cut)" % (len(d) - 4000))
        else:
            lines.extend(d)

io.open(OUT + ".tmp", "w", encoding="utf-8", newline="\n").write("\n".join(summary) + "\n\n" + "\n".join(lines) + "\n")
os.replace(OUT + ".tmp", OUT)
print("\n".join(summary))
print("\nfull diff: %s (%d lines)" % (OUT, len(lines)))
