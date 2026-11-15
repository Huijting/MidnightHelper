"""What changed in the API docs on the 12.1.7 PTR SINCE build 70424 (16 Oct research)?

Read-only research helper (15 Nov 2026). Finds the commit for build 70424 on each repo's ptr branch,
then diffs that tree against the ptr head (70892). Text only, nothing is executed.
Writes apidiff2_out.txt next to this script and prints a summary.
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
OUT = os.path.join(HERE, "apidiff2_out.txt")
UA = {"User-Agent": "wow-api-diff-research"}


def get(url):
    req = urllib.request.Request(url, headers=UA)
    with urllib.request.urlopen(req, timeout=90) as r:
        return r.read().decode("utf-8", "replace")


def find_commit(repo, branch, needle):
    j = json.loads(get("https://api.github.com/repos/%s/commits?sha=%s&per_page=60" % (repo, branch)))
    seen = []
    for c in j:
        msg = c["commit"]["message"].splitlines()[0]
        seen.append("%s %s %s" % (c["sha"][:10], c["commit"]["committer"]["date"], msg))
        if needle in msg:
            return c["sha"], seen
    return None, seen


def listing(repo, path, ref):
    url = "https://api.github.com/repos/%s/contents/%s?ref=%s" % (repo, path, ref)
    out = {}
    for e in json.loads(get(url)):
        if e.get("type") == "file":
            out[e["name"]] = (e["sha"], e.get("size", 0))
    return out


def raw(repo, ref, path):
    return get("https://raw.githubusercontent.com/%s/%s/%s" % (repo, ref, path))


JOBS = [
    ("Gethe/wow-ui-source", "Interface/AddOns/Blizzard_APIDocumentationGenerated", 3),
    ("Ketho/BlizzardInterfaceResources", "Resources", 0),
]
SKIP = {"AtlasInfo.lua", "FrameXML.lua", "Templates.lua", "Mixins.lua", "Frames.lua"}

lines = []
summary = []
for repo, path, ctx in JOBS:
    base, seen = find_commit(repo, "ptr", "70424")
    summary.append("%s ptr history (newest first):" % repo)
    summary.extend("   " + s for s in seen[:12])
    if not base:
        summary.append("  no commit with 70424 in the last 60 -- skipped")
        continue
    summary.append("  base = %s (70424), head = ptr" % base[:10])
    a = listing(repo, path, base)
    b = listing(repo, path, "ptr")
    names = sorted(set(a) | set(b))
    changed = [n for n in names if a.get(n, (None,))[0] != b.get(n, (None,))[0]]
    summary.append("  %s: %d files at 70424, %d now, %d differ" % (path, len(a), len(b), len(changed)))
    for n in changed:
        if n in SKIP:
            summary.append("  SKIP %s" % n)
            continue
        old = raw(repo, base, path + "/" + n).splitlines() if n in a else []
        new = raw(repo, "ptr", path + "/" + n).splitlines() if n in b else []
        d = list(difflib.unified_diff(old, new, "70424/" + n, "70892/" + n, n=ctx, lineterm=""))
        plus = sum(1 for x in d if x.startswith("+") and not x.startswith("+++"))
        minus = sum(1 for x in d if x.startswith("-") and not x.startswith("---"))
        tag = "NEW" if n not in a else ("GONE" if n not in b else "CHG")
        summary.append("    %s %-58s +%d -%d" % (tag, n, plus, minus))
        lines.append("=" * 100)
        lines.append("%s  %s/%s  (+%d -%d)" % (repo, path, n, plus, minus))
        lines.extend(d[:3000])

io.open(OUT + ".tmp", "w", encoding="utf-8", newline="\n").write("\n".join(summary) + "\n\n" + "\n".join(lines) + "\n")
os.replace(OUT + ".tmp", OUT)
print("\n".join(summary))
print("\nfull diff: %s (%d lines)" % (OUT, len(lines)))
