# -*- coding: utf-8 -*-
"""Turn Zygor's taxi graph into a connectivity table, so we stop proposing flights that do not exist.

Rob, 3 Sep 2026, standing in Harandar and routed to Zul'Aman: "Fly from The Den to Torntusk
Overlook." That flight cannot be taken. MEASURED in LibTaxi's own graph: Harandar's taxi
network is a closed five-node star (Har'alnor / Har'athir / Har'kuai / Har'mara around The
Den) with ZERO outbound edges, while Torntusk Overlook hangs off the Eastern Kingdoms
network. Our own FlightPointsData is 155 flat per-map lists with no edges at all, so it
cannot represent "these two are unconnected" and any consumer pairing "nearest point here"
with "nearest point there" keeps producing impossible instructions. No row correction fixes
that; the shape of the data is the defect.

WHAT THIS EMITS: `Modules/FlightNetworkData.lua`, a name -> component id map.
📌 COMPONENTS, NOT ZYGOR'S ROOT KEYS. `data.flightcost` is keyed by a root (13 = Eastern
Kingdoms, 2413 = Harandar, ...), and it would be tempting to treat "same root" as "connected".
That is an assumption: nothing stops a root holding two disconnected clusters. So the graph is
walked globally and real connected components are computed. Same component means a path
provably exists; different components means it provably does not. No guessing either way.

⚠️ ONLY NAMES WE ACTUALLY SHIP are emitted. Zygor's graph is thousands of nodes; ours is 649
points. Emitting the rest would be dead weight in every player's memory.

🔴 DUPLICATE NAMES ARE DROPPED, NOT RESOLVED. Our FLIGHT_POINTS has no node ids, so a name is
all we can join on. If one name sits in two different components the answer is genuinely
ambiguous, and the consumer must get "unknown" rather than a coin flip -- unknown makes the
caller stay quiet, a coin flip makes it lie half the time.
"""
import io
import os
import re
import sys
from collections import defaultdict

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
ADDONS = os.path.dirname(ROOT)
ZYGOR = os.path.join(ADDONS, "ZygorGuidesViewer", "Libs-Retail", "LibTaxi-1.0", "data.lua")
OURS = os.path.join(ROOT, "Modules", "FlightPointsData.lua")
OUT = os.path.join(ROOT, "Modules", "FlightNetworkData.lua")

NODE_RE = re.compile(r"nodeID\s*=\s*(\d+)\s*,\s*\n\s*name\s*=\s*\"([^\"]+)\"")
NEIGH_RE = re.compile(r"\[(\d+)\]\s*=\s*[\d.]+")
OUR_NAME_RE = re.compile(r'^\s*\{\s*"([^"]+)"\s*,\s*[\d.]+\s*,\s*[\d.]+\s*,\s*"[ABH]"\s*\}')


def parse_zygor():
    """nodeID -> name, and nodeID -> set(neighbour nodeIDs)."""
    if not os.path.exists(ZYGOR):
        sys.exit("LibTaxi data not found: %s" % ZYGOR)
    text = io.open(ZYGOR, encoding="utf-8", errors="replace").read()
    start = text.find("data.flightcost")
    if start < 0:
        sys.exit("no data.flightcost in LibTaxi — the format changed; stopping rather than "
                 "emitting an empty network that would silence every flight hint.")
    body = text[start:]

    names, adj = {}, defaultdict(set)
    # Each node block runs from its own "nodeID =" to the next one.
    marks = [m.start() for m in re.finditer(r"nodeID\s*=\s*\d+", body)] + [len(body)]
    for i in range(len(marks) - 1):
        chunk = body[marks[i]:marks[i + 1]]
        nm = NODE_RE.search(chunk)
        if not nm:
            continue
        nid, name = int(nm.group(1)), nm.group(2)
        names[nid] = name
        npos = chunk.find("neighbors")
        if npos >= 0:
            for m in NEIGH_RE.finditer(chunk[npos:]):
                other = int(m.group(1))
                adj[nid].add(other)
                adj[other].add(nid)   # undirected: a taxi edge is usable both ways
    return names, adj


def components(names, adj):
    """nodeID -> component id, via breadth-first walk over the whole graph."""
    comp, cid = {}, 0
    for nid in sorted(names):
        if nid in comp:
            continue
        cid += 1
        stack = [nid]
        comp[nid] = cid
        while stack:
            cur = stack.pop()
            for nb in adj.get(cur, ()):
                if nb not in comp:
                    comp[nb] = cid
                    stack.append(nb)
    return comp, cid


def our_names():
    text = io.open(OURS, encoding="utf-8", errors="replace").read()
    out = []
    for line in text.split("\n"):
        m = OUR_NAME_RE.match(line)
        if m:
            out.append(m.group(1))
    return out


def main():
    if len(sys.argv) > 1:
        sys.exit("build_flight_network takes no arguments (got %s)."
                 % " ".join(sys.argv[1:]))

    names, adj = parse_zygor()
    # 🔴 POSITIVE CONTROL. Measured by hand on 3 Sep: Har'alnor (3195) neighbours The Den
    # (3193) and nothing else, and Torntusk Overlook is 3126. If the parser cannot see that,
    # every "no path" answer below is a lie about a graph that does say something.
    if names.get(3195) != "Har'alnor" or 3193 not in adj.get(3195, ()):
        sys.exit("POSITIVE CONTROL FAILED: node 3195 should be Har'alnor with a neighbour "
                 "3193 (The Den); got %r / %r. Parser broken, nothing written."
                 % (names.get(3195), sorted(adj.get(3195, ()))))
    if names.get(3126) != "Torntusk Overlook":
        sys.exit("POSITIVE CONTROL FAILED: node 3126 should be Torntusk Overlook, got %r."
                 % names.get(3126))
    print("parsed %d taxi nodes, %d with edges" % (len(names), len(adj)))
    print("positive control ok: 3195 Har'alnor -> {3193 The Den}, 3126 Torntusk Overlook")

    comp, ncomp = components(names, adj)
    print("connected components: %d" % ncomp)

    # 🔴 THE CONTROL THAT MATTERS: the two points from the bug report must land in DIFFERENT
    # components. If they ever share one, this table would bless the very instruction it was
    # built to stop, and silently.
    if comp[3195] == comp[3126]:
        sys.exit("CONTROL FAILED: Har'alnor and Torntusk Overlook came out in the same "
                 "component (%d). That contradicts the measurement this file exists for; "
                 "nothing written." % comp[3195])
    print("control ok: Har'alnor comp %d != Torntusk Overlook comp %d"
          % (comp[3195], comp[3126]))

    # name -> set of components (a name can repeat across the world)
    by_name = defaultdict(set)
    for nid, name in names.items():
        by_name[name].add(comp[nid])

    ours = our_names()
    if not ours:
        sys.exit("read no names out of FlightPointsData — pattern broken, nothing written.")
    known, ambiguous, missing = {}, [], []
    for name in ours:
        cs = by_name.get(name)
        if not cs:
            missing.append(name)
        elif len(cs) > 1:
            ambiguous.append(name)
        else:
            known[name] = next(iter(cs))

    print("our flight points: %d — %d resolved, %d ambiguous, %d unknown to Zygor"
          % (len(ours), len(known), len(ambiguous), len(missing)))
    if ambiguous:
        print("  ambiguous (dropped on purpose, caller gets 'unknown'):")
        for n in sorted(ambiguous)[:12]:
            print("    %s -> components %s" % (n, sorted(by_name[n])))

    lines = [
        "-- AUTO-GENERATED by tools/build_flight_network.py — do not edit by hand.",
        "--",
        "-- Which flight points can actually reach each other. Generated from",
        "-- ZygorGuidesViewer/Libs-Retail/LibTaxi-1.0/data.lua by walking its taxi graph and",
        "-- numbering the CONNECTED COMPONENTS: two names with the same number have a path",
        "-- between them, two with different numbers provably do not.",
        "--",
        "-- 🔴 WHY THIS EXISTS. Rob, 3 Sep 2026, in Harandar: \"Fly from The Den to Torntusk",
        "-- Overlook.\" Harandar's taxi network is a closed five-node star with no outbound",
        "-- edge; Torntusk Overlook is on the Eastern Kingdoms network. FlightPointsData holds",
        "-- no edges at all, so it could not know, and any \"nearest here + nearest there\"",
        "-- pairing kept producing flights nobody can take.",
        "--",
        "-- ⚠️ A name that is ABSENT here means unknown, not unconnected. Callers must treat",
        "-- nil as \"say nothing\", never as \"no path\" — Zygor's graph does not cover every",
        "-- point we ship, and silence is the honest answer for a point neither source knows.",
        "local _, ns = ...",
        "",
        "ns.FLIGHT_NETWORK = {",
    ]
    for name in sorted(known):
        lines.append("\t[%s] = %d," % (_lua_str(name), known[name]))
    lines.append("}")
    lines.append("")
    lines.append(_HELPER)

    io.open(OUT + ".tmp", "w", encoding="utf-8", newline="\n").write("\n".join(lines) + "\n")
    os.replace(OUT + ".tmp", OUT)
    print("wrote %s (%d names)" % (OUT, len(known)))


def _lua_str(s):
    return '"%s"' % s.replace("\\", "\\\\").replace('"', '\\"')


_HELPER = '''--- Can you fly from `fromName` to `toName`?
--- @return boolean|nil  true = a path exists, false = provably none, nil = we do not know
function ns.FlightPathExists(fromName, toName)
\tif type(fromName) ~= "string" or type(toName) ~= "string" then
\t\treturn nil
\tend
\tlocal a, b = ns.FLIGHT_NETWORK[fromName], ns.FLIGHT_NETWORK[toName]
\tif not a or not b then
\t\treturn nil -- one of them is outside Zygor's graph: unknown, not unconnected
\tend
\treturn a == b
end'''


if __name__ == "__main__":
    main()
