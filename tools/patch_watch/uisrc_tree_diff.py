"""Which FrameXML files differ between Gethe/wow-ui-source live and ptr, and how? Read-only research (15 Nov 2026).

Two GitHub tree calls (recursive), compare blob SHAs per path. Writes:
  uisrc_tree_list.txt  - every changed/new/gone path under Interface/ (APIDocumentationGenerated left out)
  uisrc_tree_diff.txt  - unified diffs for the paths that match FOCUS, plus a grep of HITS over every
                         changed .lua/.xml file (ptr version)
Downloads text only, never executes it.
"""
import difflib
import io
import json
import os
import re
import sys
import urllib.request

try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass

HERE = os.path.dirname(os.path.abspath(__file__))
UA = {"User-Agent": "wow-ui-research-script"}
REPO = "Gethe/wow-ui-source"
FOCUS = re.compile(r"(Blizzard_Settings|KeyBind|Keybind|QuickKeybind|Blizzard_EditMode|Blizzard_ActionBar|"
                   r"StaticPopup|Blizzard_NamePlates|Blizzard_UnitFrame|Blizzard_GameRules|"
                   r"Blizzard_FrameXMLBase|Blizzard_SharedXMLBase|Blizzard_LossOfControl|ActionButton|"
                   r"Bindings|SecureTemplates|SecureHandlers)", re.I)
HITS = re.compile(r"simpleKeybind|SimpleKeybind|AllowSimpleKeybindOption|IsAccountKeyBindingsEnabled|"
                  r"ContentSetAccountKeyBindings|GetGameType|wowhack|WoWHack", re.I)


def get(url):
    req = urllib.request.Request(url, headers=UA)
    with urllib.request.urlopen(req, timeout=120) as r:
        return r.read().decode("utf-8", "replace")


def tree(ref):
    j = json.loads(get("https://api.github.com/repos/%s/git/trees/%s?recursive=1" % (REPO, ref)))
    out = {}
    for e in j.get("tree", []):
        if e.get("type") == "blob":
            out[e["path"]] = e["sha"]
    return out, j.get("truncated")


def raw(ref, path):
    return get("https://raw.githubusercontent.com/%s/%s/%s" % (REPO, ref, path))


a, ta = tree("live")
b, tb = tree("ptr")
names = sorted(set(a) | set(b))
changed = [n for n in names if a.get(n) != b.get(n) and n.startswith("Interface/")
           and "Blizzard_APIDocumentationGenerated" not in n]
lst = []
for n in changed:
    tag = "NEW " if n not in a else ("GONE" if n not in b else "CHG ")
    lst.append("%s %s" % (tag, n))
head = "live files %d (truncated=%s), ptr files %d (truncated=%s), changed under Interface/: %d" % (
    len(a), ta, len(b), tb, len(changed))
io.open(os.path.join(HERE, "uisrc_tree_list.txt"), "w", encoding="utf-8", newline="\n").write(
    head + "\n" + "\n".join(lst) + "\n")
print(head)

out = []
hitlines = []
for n in changed:
    if not (n.endswith(".lua") or n.endswith(".xml") or n.endswith(".toc")):
        continue
    new = raw("ptr", n) if n in b else ""
    for i, line in enumerate(new.splitlines()):
        if HITS.search(line):
            hitlines.append("%s:%d: %s" % (n, i + 1, line.strip()[:220]))
    if not FOCUS.search(n):
        continue
    old = raw("live", n) if n in a else ""
    d = list(difflib.unified_diff(old.splitlines(), new.splitlines(), "live/" + n, "ptr/" + n, n=2, lineterm=""))
    out.append("=" * 100)
    out.append("%s  (%d diff lines)" % (n, len(d)))
    out.extend(d[:1500])
    if len(d) > 1500:
        out.append("... %d more lines cut" % (len(d) - 1500))

io.open(os.path.join(HERE, "uisrc_tree_diff.txt"), "w", encoding="utf-8", newline="\n").write(
    "HITS (%d)\n" % len(hitlines) + "\n".join(hitlines) + "\n\nDIFFS\n" + "\n".join(out) + "\n")
print("hits %d, focus diffs written; see uisrc_tree_list.txt and uisrc_tree_diff.txt" % len(hitlines))
