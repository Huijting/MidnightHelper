"""Task 4 (classes/spells 12.1.7): live 12.1.5.70783 vs PTR 12.1.7.70892, DB2 via wago.tools (gamedata cache).
Writes t4_out.txt next to this script; prints a short summary."""
import csv, io, os, re, sys, urllib.parse
from collections import defaultdict
sys.path.insert(0, r"E:\World of Warcraft\_retail_\Interface\AddOns\MidnightHelper\tools")
import gamedata as g

LIVE = "12.1.5.70783"
PTR = "12.1.7.70892"
HERE = os.path.dirname(os.path.abspath(__file__))
OUT = os.path.join(HERE, "t4_out.txt")
if __name__ == "__main__" and len(sys.argv) >= 3:
    LIVE, PTR = sys.argv[1], sys.argv[2]
    OUT = os.path.join(HERE, "t4_out_%s_%s.txt" % (LIVE, PTR))
SELFTEST = r"E:\World of Warcraft\_retail_\Interface\AddOns\MidnightHelper\Modules\SelftestData.lua"
csv.field_size_limit(10 ** 8)


def text_of(table, build):
    url = "https://wago.tools/db2/%s/csv?%s" % (urllib.parse.quote(table), urllib.parse.urlencode({"build": build}))
    cpath = os.path.join(g.CACHE, "db2", build, "%s.enUS.csv" % table)
    data, _ = g.fetch(url, cpath, None, soft404=True)
    if data is None:
        return None
    t = data.decode("utf-8-sig", "replace")
    if t.lstrip().startswith("<"):
        try:
            os.remove(cpath)
        except OSError:
            pass
        return None
    return t


def rows(table, build, keep=None, keycol="SpellID"):
    t = text_of(table, build)
    if t is None:
        return None
    rd = csv.DictReader(io.StringIO(t))
    out = []
    for r in rd:
        if keep is None or r.get(keycol) in keep:
            out.append(r)
    return out


def ids_from_selftest():
    s = io.open(SELFTEST, encoding="utf-8").read()
    m = re.search(r'spell\s*=\s*\{\s*R\s*=\s*"([^"]*)",\s*F\s*=\s*"([^"]*)",\s*B\s*=\s*"([^"]*)"', s)
    r, f, b = m.groups()
    ids = set(x for x in (r + "," + b).split(",") if x)
    fids = set(x for x in f.split(",") if x)
    return ids, fids


lines = []


def out(s=""):
    lines.append(s)


# ---------------------------------------------------------------- small tables
SMALL = ["TraitDefinition", "TraitNodeEntry", "TraitNode", "TraitNodeXTraitNodeEntry", "TraitTreeLoadout",
         "ChrSpecialization", "ChrClasses", "TraitSubTree", "SpecializationSpells", "TraitNodeGroupXTraitNode",
         "TraitNodeGroupXTraitCond", "TraitCond", "SpecSetMember", "TraitNodeXTraitCond", "SpellCooldowns",
         "SpellCategories", "SpellCategory", "SpellPower", "SpellDuration", "SpellCastTimes", "SpellRange", "TraitTree",
         "SpellAuraOptions", "SpellClassOptions", "ChrClasses"]
D = {}
for b in (LIVE, PTR):
    D[b] = {}
    for t in SMALL:
        D[b][t] = rows(t, b)

name = {}
for b in (LIVE, PTR):
    nm = {}
    t = text_of("SpellName", b)
    for r in csv.reader(io.StringIO(t)):
        if r and r[0].isdigit():
            nm[r[0]] = r[1]
    name[b] = nm


def classes(b):
    return {r["ID"]: r["Name_lang"] for r in D[b]["ChrClasses"]}


def specs(b):
    return {r["ID"]: (r["ClassID"], r["Name_lang"]) for r in D[b]["ChrSpecialization"]}


def talent_map(b):
    """spellID -> list of dicts (class, specs, subtree, node, def, overrides, defname)"""
    T = D[b]
    tree_class = {}
    for r in T["TraitTreeLoadout"]:
        sp = specs(b).get(r["ChrSpecializationID"])
        if sp:
            tree_class[r["TraitTreeID"]] = sp[0]
    defs = {r["ID"]: r for r in T["TraitDefinition"]}
    entries = {r["ID"]: r for r in T["TraitNodeEntry"]}
    nodes = {r["ID"]: r for r in T["TraitNode"]}
    subtree = {r["ID"]: r["Name_lang"] for r in T["TraitSubTree"]}
    setmembers = defaultdict(set)
    for r in T["SpecSetMember"]:
        setmembers[r["SpecSet"]].add(r["ChrSpecializationID"])
    cond_specs = {}
    for r in T["TraitCond"]:
        if r["SpecSetID"] not in ("", "0"):
            cond_specs[r["ID"]] = setmembers.get(r["SpecSetID"], set())
    node_groups = defaultdict(set)
    for r in T["TraitNodeGroupXTraitNode"]:
        node_groups[r["TraitNodeID"]].add(r["TraitNodeGroupID"])
    group_specs = defaultdict(set)
    for r in T["TraitNodeGroupXTraitCond"]:
        if r["TraitCondID"] in cond_specs:
            group_specs[r["TraitNodeGroupID"]] |= cond_specs[r["TraitCondID"]]
    node_specs_direct = defaultdict(set)
    if T["TraitNodeXTraitCond"]:
        for r in T["TraitNodeXTraitCond"]:
            if r["TraitCondID"] in cond_specs:
                node_specs_direct[r["TraitNodeID"]] |= cond_specs[r["TraitCondID"]]
    spn = specs(b)
    res = defaultdict(list)
    for r in T["TraitNodeXTraitNodeEntry"]:
        node = nodes.get(r["TraitNodeID"])
        ent = entries.get(r["TraitNodeEntryID"])
        if not node or not ent:
            continue
        cls = tree_class.get(node["TraitTreeID"])
        if not cls:
            continue
        d = defs.get(ent["TraitDefinitionID"])
        if not d:
            continue
        sids = set(node_specs_direct.get(node["ID"], set()))
        for gid in node_groups.get(node["ID"], ()):
            sids |= group_specs.get(gid, set())
        specnames = sorted(spn[s][1] for s in sids if s in spn and spn[s][0] == cls)
        st = node["TraitSubTreeID"] if node["TraitSubTreeID"] not in ("", "0") else ent.get("TraitSubTreeID", "0")
        sid = d["SpellID"]
        if sid in ("", "0"):
            continue
        res[sid].append({"class": cls, "specs": specnames, "subtree": subtree.get(st, "") if st not in ("", "0") else "",
                         "node": node["ID"], "entry": ent["ID"], "def": d["ID"], "overrides": d["OverridesSpellID"],
                         "defname": d["OverrideName_lang"], "ranks": ent["MaxRanks"], "pos": (node["PosX"], node["PosY"])})
    return res


TAL = {b: talent_map(b) for b in (LIVE, PTR)}


def specspells(b):
    res = defaultdict(set)
    for r in D[b]["SpecializationSpells"]:
        res[r["SpellID"]].add(r["SpecID"])
    return res


SPS = {b: specspells(b) for b in (LIVE, PTR)}

MH, MHF = ids_from_selftest()
interest = set(MH)
for b in (LIVE, PTR):
    interest |= set(TAL[b].keys())
    interest |= set(SPS[b].keys())
    for r in D[b]["TraitDefinition"]:
        if r["OverridesSpellID"] not in ("", "0"):
            interest.add(r["OverridesSpellID"])
PLAYER_SETS = {r["SpellClassSet"]: r["Name_lang"] for r in D[LIVE]["ChrClasses"] if r["ID"] not in ("14", "15")}
CLASSSET = {}
for b in (LIVE, PTR):
    for r in D[b]["SpellClassOptions"]:
        if r["SpellClassSet"] in PLAYER_SETS:
            CLASSSET[r["SpellID"]] = PLAYER_SETS[r["SpellClassSet"]]
interest |= set(CLASSSET)

# ---------------------------------------------------------------- big tables, filtered
BIG = {}
for b in (LIVE, PTR):
    BIG[b] = {}
    BIG[b]["Spell"] = {r["ID"]: r for r in rows("Spell", b, interest, "ID")}
    BIG[b]["SpellMisc"] = {}
    for r in rows("SpellMisc", b, interest):
        if r["DifficultyID"] == "0":
            BIG[b]["SpellMisc"][r["SpellID"]] = r
    eff = defaultdict(dict)
    for r in rows("SpellEffect", b, interest):
        eff[r["SpellID"]][(r["DifficultyID"], r["EffectIndex"])] = r
    BIG[b]["SpellEffect"] = eff


def idx(b, table, key="SpellID", diff0=True):
    res = defaultdict(list)
    for r in D[b][table]:
        if diff0 and r.get("DifficultyID", "0") != "0":
            continue
        res[r[key]].append(r)
    return res


CD = {b: idx(b, "SpellCooldowns") for b in (LIVE, PTR)}
CAT = {b: idx(b, "SpellCategories") for b in (LIVE, PTR)}
CATDEF = {b: {r["ID"]: r for r in D[b]["SpellCategory"]} for b in (LIVE, PTR)}
POW = {b: idx(b, "SpellPower", diff0=False) for b in (LIVE, PTR)}
DUR = {b: {r["ID"]: r["Duration"] for r in D[b]["SpellDuration"]} for b in (LIVE, PTR)}
CAST = {b: {r["ID"]: r["Base"] for r in D[b]["SpellCastTimes"]} for b in (LIVE, PTR)}
RNG = {b: {r["ID"]: r["RangeMax_0"] for r in D[b]["SpellRange"]} for b in (LIVE, PTR)}

_any = next((r for b in (LIVE,) for e in BIG[b]["SpellEffect"].values() for r in e.values()), None)
EFF_FIELDS = [f for f in (_any or {}).keys() if f not in ("ID", "SpellID", "DifficultyID", "EffectIndex")]
AURA = {b: idx(b, "SpellAuraOptions") for b in (LIVE, PTR)}


def changes(sid):
    """list of change strings for one spell id, live -> ptr"""
    ch = []
    nl, np_ = name[LIVE].get(sid), name[PTR].get(sid)
    if nl is None and np_ is None:
        return ["absent in both"]
    if nl is None:
        return ["NEW on PTR"]
    if np_ is None:
        return ["REMOVED on PTR"]
    if nl != np_:
        ch.append("NAME '%s' -> '%s'" % (nl, np_))
    sl, sp = BIG[LIVE]["Spell"].get(sid, {}), BIG[PTR]["Spell"].get(sid, {})
    for f in ("Description_lang", "AuraDescription_lang", "NameSubtext_lang"):
        if (sl.get(f) or "") != (sp.get(f) or ""):
            ch.append("%s:\n        LIVE: %s\n        PTR : %s" % (f, (sl.get(f) or "").replace("\n", " | "),
                                                             (sp.get(f) or "").replace("\n", " | ")))

    def cdtuple(b):
        return sorted((r["RecoveryTime"], r["CategoryRecoveryTime"], r["StartRecoveryTime"]) for r in CD[b].get(sid, []))
    if cdtuple(LIVE) != cdtuple(PTR):
        ch.append("COOLDOWN (recovery, categoryRecovery, gcd) %s -> %s" % (cdtuple(LIVE), cdtuple(PTR)))

    def chg(b):
        res = []
        for r in CAT[b].get(sid, []):
            for k in ("ChargeCategory", "Category"):
                c = CATDEF[b].get(r[k])
                if c and (c["MaxCharges"] not in ("", "0") or c["ChargeRecoveryTime"] not in ("", "0")):
                    res.append((k, c["MaxCharges"], c["ChargeRecoveryTime"]))
            res.append(("DispelType", r["DispelType"], r["Mechanic"]))
        return sorted(res)
    if chg(LIVE) != chg(PTR):
        ch.append("CHARGES/CATEGORY %s -> %s" % (chg(LIVE), chg(PTR)))
    ml, mp = BIG[LIVE]["SpellMisc"].get(sid), BIG[PTR]["SpellMisc"].get(sid)
    if ml and mp:
        for f, tab in (("CastingTimeIndex", CAST), ("DurationIndex", DUR), ("RangeIndex", RNG)):
            a, b_ = tab[LIVE].get(ml[f], ml[f]), tab[PTR].get(mp[f], mp[f])
            if a != b_:
                ch.append("%s %s -> %s" % (f.replace("Index", ""), a, b_))
        if ml["SchoolMask"] != mp["SchoolMask"]:
            ch.append("SchoolMask %s -> %s" % (ml["SchoolMask"], mp["SchoolMask"]))

    def pw(b):
        return sorted((r["PowerType"], r["ManaCost"], r["PowerCostPct"], r["PowerCostMaxPct"]) for r in POW[b].get(sid, []))
    if pw(LIVE) != pw(PTR):
        ch.append("COST (type, cost, pct, maxpct) %s -> %s" % (pw(LIVE), pw(PTR)))

    def ao(b):
        return sorted((r["CumulativeAura"], r["ProcChance"], r["ProcCharges"], r["SpellProcsPerMinuteID"],
                       r["ProcCategoryRecovery"]) for r in AURA[b].get(sid, []))
    if ao(LIVE) != ao(PTR):
        ch.append("AURAOPTIONS (stacks, procChance, procCharges, ppmID, procICD) %s -> %s" % (ao(LIVE), ao(PTR)))
    el, ep = BIG[LIVE]["SpellEffect"].get(sid, {}), BIG[PTR]["SpellEffect"].get(sid, {})
    for k in sorted(set(el) | set(ep), key=lambda x: (int(x[0] or 0), int(x[1] or 0))):
        a, c = el.get(k), ep.get(k)
        if a is None:
            ch.append("EFFECT #%s (diff %s) ADDED: effect=%s aura=%s base=%s trigger=%s" % (
                k[1], k[0], c["Effect"], c["EffectAura"], c["EffectBasePointsF"], c["EffectTriggerSpell"]))
            continue
        if c is None:
            ch.append("EFFECT #%s (diff %s) REMOVED: effect=%s aura=%s base=%s" % (
                k[1], k[0], a["Effect"], a["EffectAura"], a["EffectBasePointsF"]))
            continue
        dd = ["%s %s->%s" % (f, a[f], c[f]) for f in EFF_FIELDS if a.get(f) != c.get(f)]
        if dd:
            ch.append("EFFECT #%s (diff %s): %s" % (k[1], k[0], "; ".join(dd)))
    return ch


cls_l, cls_p = classes(LIVE), classes(PTR)
spn_l, spn_p = specs(LIVE), specs(PTR)

out("# Task 4 DB2 diff  live %s  vs  PTR %s  (wago.tools CSV, gamedata cache)" % (LIVE, PTR))
out("control: 6603 live=%r ptr=%r ; 1 (Word of Recall?) live=%r" % (name[LIVE].get("6603"), name[PTR].get("6603"), name[LIVE].get("1")))
out("MH retail spell ids (R+B): %d ; Forever-only F: %d" % (len(MH), len(MHF)))
out("SpellName rows live=%d ptr=%d" % (len(name[LIVE]), len(name[PTR])))
out("talent spells live=%d ptr=%d ; spec spells live=%d ptr=%d" % (len(TAL[LIVE]), len(TAL[PTR]), len(SPS[LIVE]), len(SPS[PTR])))
out()

# ---------------------------------------------------------------- S1 MH ids
out("## S1  MH ids: absent / removed / renamed / changed")
mh_changed = {}
for sid in sorted(MH, key=int):
    ch = changes(sid)
    if ch:
        mh_changed[sid] = ch
absent_both = [s for s, c in mh_changed.items() if c == ["absent in both"]]
removed = [s for s, c in mh_changed.items() if c == ["REMOVED on PTR"]]
new = [s for s, c in mh_changed.items() if c == ["NEW on PTR"]]
out("absent in both builds: %s" % ", ".join(absent_both))
out("REMOVED on PTR: %s" % ", ".join("%s %s" % (s, name[LIVE].get(s)) for s in removed))
out("only on PTR: %s" % ", ".join(new))
renamed = [s for s, c in mh_changed.items() if any(x.startswith("NAME") for x in c)]
out("renamed: %s" % "; ".join("%s %s->%s" % (s, name[LIVE].get(s), name[PTR].get(s)) for s in renamed))
out()


def where(sid, b):
    res = []
    for t in TAL[b].get(sid, []):
        res.append("talent %s%s%s node %s" % (cls_l.get(t["class"], t["class"]),
                                              (" [" + "/".join(t["specs"]) + "]") if t["specs"] else "",
                                              (" {hero " + t["subtree"] + "}") if t["subtree"] else "", t["node"]))
    for s in sorted(SPS[b].get(sid, set())):
        sp = spn_l.get(s) or spn_p.get(s)
        if sp:
            res.append("specspell %s %s" % (cls_l.get(sp[0], sp[0]), sp[1]))
    return res


out("## S2  MH ids with any change (details)")
for sid in sorted(mh_changed, key=int):
    ch = mh_changed[sid]
    if ch in (["absent in both"], ["NEW on PTR"]):
        continue
    wl, wp = where(sid, LIVE), where(sid, PTR)
    out("- %s %s   live:%s   ptr:%s" % (sid, name[LIVE].get(sid) or name[PTR].get(sid), "; ".join(wl) or "-", "; ".join(wp) or "-"))
    for c in ch:
        out("    " + c)
out()

out("## S2b MH ids whose TALENT status changed (in a tree live but not ptr, or v.v.)")
for sid in sorted(MH, key=int):
    a, c = bool(TAL[LIVE].get(sid)), bool(TAL[PTR].get(sid))
    wl, wp = where(sid, LIVE), where(sid, PTR)
    if a != c or sorted(wl) != sorted(wp):
        out("- %s %s  live:%s  ptr:%s" % (sid, name[LIVE].get(sid) or name[PTR].get(sid), "; ".join(wl) or "-", "; ".join(wp) or "-"))
out()

# ---------------------------------------------------------------- S3 talent trees per class
out("## S3  talent tree diff per class (by spell id in class trees)")
allcls = sorted(set(cls_l) | set(cls_p), key=int)
for c in allcls:
    lset = {s for s, ts in TAL[LIVE].items() if any(t["class"] == c for t in ts)}
    pset = {s for s, ts in TAL[PTR].items() if any(t["class"] == c for t in ts)}
    if not lset and not pset:
        continue
    added, gone, both = sorted(pset - lset, key=int), sorted(lset - pset, key=int), sorted(lset & pset, key=int)
    changed = []
    for s in both:
        ch = changes(s)
        tl = sorted((t["node"], t["ranks"], tuple(t["specs"]), t["subtree"]) for t in TAL[LIVE][s] if t["class"] == c)
        tp = sorted((t["node"], t["ranks"], tuple(t["specs"]), t["subtree"]) for t in TAL[PTR][s] if t["class"] == c)
        if ch == ["absent in both"]:
            ch = []
        if tl != tp:
            ch = ch + ["TREE PLACE %s -> %s" % (tl, tp)]
        if ch:
            changed.append((s, ch))
    out("### %s %s  talents live=%d ptr=%d  added=%d removed=%d changed=%d" % (
        c, cls_l.get(c) or cls_p.get(c), len(lset), len(pset), len(added), len(gone), len(changed)))
    for s in added:
        t = [x for x in TAL[PTR][s] if x["class"] == c][0]
        out("  + %s %s %s%s  (ptr new spell: %s)%s" % (s, name[PTR].get(s), "[" + "/".join(t["specs"]) + "]" if t["specs"] else "[class]",
                                                    " {hero " + t["subtree"] + "}" if t["subtree"] else "",
                                                    "yes" if s not in name[LIVE] else "no",
                                                    "  MH!" if s in MH else ""))
        sp = BIG[PTR]["Spell"].get(s, {})
        out("      " + (sp.get("Description_lang") or "").replace("\n", " | ")[:400])
    for s in gone:
        t = [x for x in TAL[LIVE][s] if x["class"] == c][0]
        out("  - %s %s %s%s  (spell still exists on ptr: %s)%s" % (s, name[LIVE].get(s), "[" + "/".join(t["specs"]) + "]" if t["specs"] else "[class]",
                                                             " {hero " + t["subtree"] + "}" if t["subtree"] else "",
                                                             "yes" if s in name[PTR] else "NO",
                                                             "  MH!" if s in MH else ""))
    for s, ch in changed:
        t = [x for x in TAL[PTR][s] if x["class"] == c][0]
        out("  ~ %s %s %s%s%s" % (s, name[PTR].get(s), "[" + "/".join(t["specs"]) + "]" if t["specs"] else "[class]",
                                 " {hero " + t["subtree"] + "}" if t["subtree"] else "", "  MH!" if s in MH else ""))
        for x in ch:
            out("      " + x[:700])
out()

# ---------------------------------------------------------------- S4 spec spells
out("## S4  SpecializationSpells diff (baseline spec spells)")
for s in sorted(set(SPS[LIVE]) | set(SPS[PTR]), key=int):
    a, c = SPS[LIVE].get(s, set()), SPS[PTR].get(s, set())
    if a != c:
        out("  %s %s live specs %s -> ptr specs %s%s" % (s, name[PTR].get(s) or name[LIVE].get(s),
                                                        sorted(spn_l.get(x, ("?", x))[1] for x in a),
                                                        sorted(spn_p.get(x, ("?", x))[1] for x in c), "  MH!" if s in MH else ""))
    elif a:
        ch = changes(s)
        if ch == ["absent in both"]:
            ch = []
        if ch and not TAL[PTR].get(s):
            out("  ~ %s %s (%s)%s" % (s, name[PTR].get(s), sorted(spn_p.get(x, ("?", x))[1] for x in c), "  MH!" if s in MH else ""))
            for x in ch:
                out("      " + x[:700])
out()

# ---------------------------------------------------------------- S5 new specs / subtrees
out("## S5  ChrSpecialization / TraitSubTree / TraitTree rows only on PTR")
for r in D[PTR]["ChrSpecialization"]:
    if r["ID"] not in spn_l:
        out("  spec %s class %s %s : %s" % (r["ID"], r["ClassID"], r["Name_lang"], r["Description_lang"][:200]))
lst = {r["ID"] for r in D[LIVE]["TraitSubTree"]}
for r in D[PTR]["TraitSubTree"]:
    if r["ID"] not in lst:
        out("  subtree %s tree %s %s : %s" % (r["ID"], r["TraitTreeID"], r["Name_lang"], r["Description_lang"][:200]))
ltt = {r["ID"] for r in D[LIVE]["TraitTree"]}
for r in D[PTR]["TraitTree"]:
    if r["ID"] not in ltt:
        out("  tree %s system %s title %r" % (r["ID"], r["TraitSystemID"], r["TitleText_lang"]))
ltl = {(r["TraitTreeID"], r["ChrSpecializationID"]) for r in D[LIVE]["TraitTreeLoadout"]}
for r in D[PTR]["TraitTreeLoadout"]:
    if (r["TraitTreeID"], r["ChrSpecializationID"]) not in ltl:
        out("  loadout tree %s spec %s" % (r["TraitTreeID"], r["ChrSpecializationID"]))

out()
out("## S6  every spell with a player class set (SpellClassOptions), not already listed as talent/spec spell, with a change")
s6 = defaultdict(list)
for s in sorted(CLASSSET, key=int):
    if TAL[LIVE].get(s) or TAL[PTR].get(s) or SPS[LIVE].get(s) or SPS[PTR].get(s):
        continue
    ch = changes(s)
    if ch and ch != ["absent in both"]:
        s6[CLASSSET[s]].append((s, ch))
for c in sorted(s6):
    out("### %s: %d" % (c, len(s6[c])))
    for s, ch in s6[c]:
        out("  ~ %s %s%s" % (s, name[PTR].get(s) or name[LIVE].get(s), "  MH!" if s in MH else ""))
        for x in ch:
            out("      " + x[:500])
out("S6 total: %d" % sum(len(v) for v in s6.values()))

io.open(OUT + ".tmp", "w", encoding="utf-8", newline="\n").write("\n".join(lines) + "\n")
os.replace(OUT + ".tmp", OUT)
print("\n".join(lines[:12]))
print("... %d lines written to %s" % (len(lines), OUT))
print("MH ids changed (any): %d ; removed %d ; renamed %d" % (len(mh_changed) - len(absent_both) - len(new), len(removed), len(renamed)))
