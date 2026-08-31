#!/usr/bin/env python3
"""Replay the profession advisor offline, from ns.db.profIdDump.

This is what the ranks were for. Until now the DATA could be checked here and the ADVICE only
in game, so every question cost Rob a login and a screenshot. With ranks in the dump the whole
route can be walked from the file.

⚠️ It mirrors FirstUnfinishedStep's rules and is therefore a SECOND implementation -- if the Lua
changes, this drifts. It is a reading aid, not the authority; `/mh profadvice` in the client is.
Kept deliberately small for that reason.
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


def entries(b):
    out, k = [], 1
    while True:
        n = b.find("{", k)
        if n < 0:
            return out
        e = block(b, n)
        if not e:
            return out
        out.append(e)
        k = n + len(e)


sv = io.open(SV, encoding="utf-8", errors="replace").read()
dump = block(sv, sv.find('["profIdDump"]'))

client = {}
for m in re.finditer(r'\["(\d+)"\]\s*=\s*\{', dump):
    sid = int(m.group(1))
    if sid not in PROF:
        continue
    b = block(dump, m.end() - 1)
    got = {"tabs": {}, "nodes": {}}
    for which in ("tabs", "nodes"):
        mm = re.search(r'\["%s"\]\s*=\s*\{' % which, b)
        if not mm:
            continue
        for e in entries(block(b, mm.end() - 1)):
            n_ = re.search(r'\["name"\]\s*=\s*"([^"]*)"', e)
            r_ = re.search(r'\["rank"\]\s*=\s*(\d+)', e)
            x_ = re.search(r'\["max"\]\s*=\s*(\d+)', e)
            if n_:
                got[which][n_.group(1).lower()] = (
                    int(r_.group(1)) if r_ else None,
                    int(x_.group(1)) if x_ else 0)
    client[sid] = got

data = io.open(DATA, encoding="utf-8", errors="replace").read()
body = data[data.index("advisorRoutes = {"):]

for m in re.finditer(r'\n\t\t\[(\d+)\]\s*=\s*\{(.*?)\n\t\t\},', body, re.S):
    sid, steps = int(m.group(1)), m.group(2)
    if sid not in client:
        continue
    print("\n=== %s" % PROF[sid])
    advised, done = None, []
    for st in re.finditer(r'\{\s*(tree|node|anyOf|anyOfNodes)\s*=\s*(.*?)\s*[,}]', steps, re.S):
        kind, names = st.group(1), re.findall(r'"([^"]+)"', st.group(2))
        table = "nodes" if kind in ("node", "anyOfNodes") else "tabs"
        opts, satisfied = [], False
        for nm in names:
            hit = client[sid][table].get(nm.lower())
            if not hit:
                continue
            rank, mx = hit
            if rank is None:
                opts.append((nm, None, mx))
            elif mx and rank >= mx:
                satisfied = True
                done.append("%s %d/%d" % (nm, rank, mx))
            else:
                opts.append((nm, rank, mx))
        if satisfied or not opts:
            continue
        if advised is None:
            advised = ", ".join(
                "%s %s/%d" % (n, "?" if r is None else r, x) for n, r, x in opts)
    for d in done:
        print("   done: %s" % d)
    print("   NEXT: %s" % (advised or "route complete (or goal-split, see /mh profadvice)"))
