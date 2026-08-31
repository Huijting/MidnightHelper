#!/usr/bin/env python3
"""Check EVERY advisorRoutes name against the ids Rob captured from his own client.

Measurement before rewriting, which is the whole lesson of 31 Aug: this morning six route
steps were wrong about the LAYER and nobody knew until the client was asked. Eight of the
eleven professions are now captured, so the rest of that question can be answered in one run
instead of one profession at a time.

Reports per step: is it a tab, a node, or neither -- and whether the route calls it right.
"""
import io
import os
import re
import sys

try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass

SV = r"E:\World of Warcraft\_retail_\WTF\Account\JOEYWHATEVER\SavedVariables\MidnightHelper.lua"
REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
DATA = os.path.join(REPO, "Modules", "ProfessionAcademyData.lua")

PROF = {164: "Blacksmithing", 165: "Leatherworking", 171: "Alchemy", 182: "Herbalism",
        186: "Mining", 197: "Tailoring", 202: "Engineering", 333: "Enchanting",
        393: "Skinning", 755: "Jewelcrafting", 773: "Inscription"}


def block(s, at):
    start = s.find("{", at)
    depth, j, ins = 0, start, False
    while j < len(s):
        c = s[j]
        if ins:
            if c == "\\":
                j += 2
                continue
            if c == '"':
                ins = False
        elif c == '"':
            ins = True
        elif c == "{":
            depth += 1
        elif c == "}":
            depth -= 1
            if depth == 0:
                return s[start:j + 1]
        j += 1
    return ""


sv = io.open(SV, encoding="utf-8", errors="replace").read()
dump = block(sv, sv.find('["profIdDump"]'))

# skillLine -> {"tabs": {name: id}, "nodes": {name: id}}
client = {}
for m in re.finditer(r'\["(\d+)"\]\s*=\s*\{', dump):
    sid = int(m.group(1))
    if sid not in PROF:
        continue
    b = block(dump, m.end() - 1)
    out = {"tabs": {}, "nodes": {}}
    for which in ("tabs", "nodes"):
        mm = re.search(r'\["%s"\]\s*=\s*\{' % which, b)
        if not mm:
            continue
        sub = block(b, mm.end() - 1)
        for e in re.finditer(r'\{(.*?)\}', sub, re.S):
            t = e.group(1)
            i_ = re.search(r'\["id"\]\s*=\s*(\d+)', t)
            n_ = re.search(r'\["name"\]\s*=\s*"([^"]*)"', t)
            if i_ and n_:
                out[which][n_.group(1).lower()] = int(i_.group(1))
    client[sid] = out

data = io.open(DATA, encoding="utf-8", errors="replace").read()
body = data[data.index("advisorRoutes = {"):]

print("%-16s %-34s %-10s %s" % ("profession", "step", "written as", "client says"))
print("-" * 88)
bad = 0
for m in re.finditer(r'\n\t\t\[(\d+)\]\s*=\s*\{(.*?)\n\t\t\},', body, re.S):
    sid, steps = int(m.group(1)), m.group(2)
    if sid not in client:
        continue
    for st in re.finditer(r'\{\s*(tree|node|anyOf|anyOfNodes)\s*=\s*(.*?)\s*[,}]', steps, re.S):
        kind, rest = st.group(1), st.group(2)
        names = re.findall(r'"([^"]+)"', rest)
        for nm in names:
            low = nm.lower()
            is_tab = low in client[sid]["tabs"]
            is_node = low in client[sid]["nodes"]
            want = "tree" if kind in ("tree", "anyOf") else "node"
            real = "TAB" if is_tab else ("NODE" if is_node else "NEITHER")
            ok = (want == "tree" and is_tab) or (want == "node" and is_node)
            if not ok:
                bad += 1
            print("%-16s %-34s %-10s %s%s" % (
                PROF[sid], nm[:33], kind, real, "" if ok else "   <-- MISMATCH"))

# ⚠️ Counted, not hardcoded. This line said "the 8 captured professions" while the list
# above it showed 9 — a summary contradicting its own evidence, which is the exact fault
# CLAUDE.md records about the CurseForge length table.
print("\n%d mismatched step name(s) across the %d captured professions." % (bad, len(client)))
print("missing from the dump: %s" % ", ".join(PROF[s] for s in sorted(PROF) if s not in client))
