"""Apply the 5 Oct 2026 gap round (gaps_g1..g4.tsv from mh-research) to Modules/KeybindRoles_*.lua.

Rules (Rob: "ja doe maar"; the main session's filter):
  - only confidence == sure, priority <= 8, no 'skip', no stances, no out-of-combat niche (priority >= 9);
  - a name that already has an entry: widen its `specs`; if the entry means something else there (other
    category/role, a bindKey, cooldown_bar), add blockAs for the new specs instead of inheriting it;
  - entries with `specs = {}` (card-only) and Rob's 17 Sep single-spec choices are left alone;
  - an id already used in the same file is not reused (match by name instead);
  - a list of entries MEASURED as not castable in 12.1 is commented out, and a few `specs` are narrowed.
Writes atomically; prints every action.
"""
import io, os, re, collections

S = "C:/Users/RobHu/AppData/Local/Temp/claude/E--World-of-Warcraft--retail--Interface-AddOns/eae6b59e-18f0-4808-8205-724b4dbfdb90/scratchpad/"
R = "E:/World of Warcraft/_retail_/Interface/AddOns/MidnightHelper/Modules/"
FILE = {
    "WARRIOR": "Warrior", "PALADIN": "Paladin", "DEATHKNIGHT": "DeathKnight", "HUNTER": "Hunter",
    "ROGUE": "Rogue", "MONK": "Monk", "PRIEST": "Priest", "MAGE": "Mage", "WARLOCK": "Warlock",
    "SHAMAN": "Shaman", "EVOKER": "Evoker", "DEMONHUNTER": "DemonHunter", "DRUID": "Druid",
}
LEAVE = {  # Rob's earlier choices / decisions the agents flagged
    ("MONK", "Chi Torpedo"), ("MONK", "Transcendence: Transfer"), ("MONK", "Celestial Infusion"),
    ("HUNTER", "Primal Rage"), ("HUNTER", "Master's Call"), ("HUNTER", "Hatchet Toss"),
    ("DRUID", "Hibernate"),  # left out for Balance today: beasts/dragonkin only, takes the overflow before Dash
    # Second pass after the before/after diff (5 Oct 2026): these took the overflow places from core spells
    # (Havoc, Mana Tea, Ghost Wolf, Prowl, Dash, Evocation). Niche, or the either/or partner already has a key.
    ("SHAMAN", "Earthbind Totem"), ("SHAMAN", "Earthgrab Totem"), ("SHAMAN", "Totemic Projection"),
    ("SHAMAN", "Poison Cleansing Totem"), ("SHAMAN", "Ancestral Swiftness"), ("SHAMAN", "Greater Purge"),
    ("WARLOCK", "Curse of Exhaustion"), ("WARLOCK", "Soulburn"), ("MAGE", "Mass Polymorph"),
    ("WARRIOR", "Piercing Howl"), ("PRIEST", "Dominate Mind"),
    # Third pass: talents that REPLACE an existing button (it keeps its place) and 1-hour self-buffs.
    ("DRUID", "Frantic Frenzy"), ("DRUID", "Raze"), ("DRUID", "Red Moon"),
    ("SHAMAN", "Lightning Shield"), ("SHAMAN", "Flametongue Weapon"), ("SHAMAN", "Windfury Weapon"),
    ("SHAMAN", "Earthliving Weapon"), ("SHAMAN", "Water Shield"), ("SHAMAN", "Tidecaller's Guard"),
    ("SHAMAN", "Thunderstrike Ward"),
}
# Same pass: keep the entry, but not for these specs (off-role spells that pushed core ones off the block).
EXCLUDE_SPECS = {
    ("DRUID", "Moonfire"): [103], ("DRUID", "Typhoon"): [103], ("DRUID", "Mighty Bash"): [103, 105],
    ("DRUID", "Mass Entanglement"): [103, 104], ("DRUID", "Innervate"): [103, 104], ("DRUID", "Regrowth"): [103],
    ("DRUID", "Heart of the Wild"): [103, 105], ("DRUID", "Ironfur"): [103, 105],
    ("DRUID", "Tiger Dash"): [103, 104, 105], ("DRUID", "Symbiotic Relationship"): [103, 104, 105],
    ("DRUID", "Rip"): [105], ("DRUID", "Ferocious Bite"): [105], ("DRUID", "Rake"): [105], ("DRUID", "Shred"): [105],
    ("DRUID", "Thrash"): [105], ("DRUID", "Swipe"): [105], ("DRUID", "Frenzied Regeneration"): [105],
    ("DRUID", "Incapacitating Roar"): [105], ("DRUID", "Stampeding Roar"): [105], ("DRUID", "Starfire"): [105],
    ("SHAMAN", "Healing Stream Totem"): [262, 263], ("SHAMAN", "Earth Shield"): [262, 263],
    ("SHAMAN", "Chain Heal"): [262, 263], ("SHAMAN", "Frost Shock"): [262, 264],
    ("SHAMAN", "Spiritwalker's Grace"): [263], ("SHAMAN", "Ancestral Spirit"): [262, 263],
    ("MAGE", "Cone of Cold"): [62, 63], ("MAGE", "Ice Nova"): [62, 63],
    ("MONK", "Provoke"): [270], ("MONK", "Disable"): [270], ("MONK", "Song of Chi-Ji"): [270],
    ("MONK", "Crackling Jade Lightning"): [270], ("MONK", "Tiger's Lust"): [270], ("MONK", "Resuscitate"): [270],
}
# MEASURED not castable in 12.1 (mh-research 5 Oct 2026, wago DB2 69933 + a second source).
REMOVE = {
    "DEATHKNIGHT": ["Strangulate"], "PALADIN": ["Repentance"],
    "WARLOCK": ["Doom", "Dimensional Rift", "Call Felhunter"],
    "MAGE": ["Nether Tempest", "Living Bomb", "Cauterize"],
    "HUNTER": ["Bursting Shot", "Scatter Shot", "Stampede", "Steel Trap", "Chimaera Shot", "Wyvern Sting"],
    "DEMONHUNTER": ["Fel Eruption"],
}
NARROW = {  # (class, name) -> new specs
    ("PALADIN", "Cleanse"): [65], ("PALADIN", "Blessing of Spellwarding"): [66],
    ("HUNTER", "Kill Shot"): [254], ("SHAMAN", "Elemental Blast"): [262], ("SHAMAN", "Stormkeeper"): [262],
}
DROP_SPEC = {("DEMONHUNTER", "The Hunt"): 581, ("DEMONHUNTER", "Felblade"): 1480}

rows = []
for g in ("gaps_g1.tsv", "gaps_g2.tsv", "gaps_g3.tsv", "gaps_g4.tsv"):
    lines = io.open(S + g, encoding="utf-8").read().splitlines()
    head = [h.strip() for h in lines[0].split("\t")]
    for l in lines[1:]:
        if l.strip():
            rows.append(dict(zip(head, [c.strip() for c in l.split("\t")])))

import subprocess
REPO = "E:/World of Warcraft/_retail_/Interface/AddOns/MidnightHelper"
texts = {}
for cls, f in FILE.items():
    # Start from the committed version (a first run on 5 Oct left duplicates in the CRLF files).
    t = subprocess.run(["git", "-C", REPO, "show", "HEAD:Modules/KeybindRoles_%s.lua" % f],
                       capture_output=True).stdout.decode("utf-8")
    texts[cls] = t

# New entries are collected first, so a name that comes as two rows (Frostfire Bolt, Ice Nova) becomes ONE
# entry: specs joined, and a second row with another meaning becomes blockAs for its specs.
pending = collections.OrderedDict()

log = collections.defaultdict(list)


def entry_re(name):
    # Greedy body up to the LAST "}," before an optional comment, so nested tables (survivalId = {...})
    # stay inside the body and nothing is inserted into them.
    # CRLF files: the \r stays outside the match (lookahead), so it is never lost or doubled.
    return re.compile(r'^([ \t]*\["' + re.escape(name) + r'"\][ \t]*=[ \t]*\{)(.*)(\}[ \t]*,[ \t]*(?:--[^\r\n]*)?)(?=\r?$)', re.M)


def table_span(t, cls):
    m = re.search(r"^ns\.KeybindRoleClassifier\.%s = \{\s*$" % cls, t, re.M)
    end = re.search(r"^\}\s*$", t[m.end():], re.M)
    return m.end(), m.end() + end.start()


def parse_specs(body):
    m = re.search(r"specs\s*=\s*\{([^}]*)\}", body)
    if not m:
        return None, None
    return [int(x) for x in re.findall(r"\d+", m.group(1))], m


def kv(sug):
    k, v = sug.split("=", 1)
    return k.strip(), v.strip()


skipped = []
new_lines = collections.defaultdict(list)
for r in rows:
    cls = r.get("class", "").upper()
    name = r.get("name", "")
    if cls not in FILE:
        skipped.append((cls, name, "unknown class"))
        continue
    pr = re.match(r"^\d+", r.get("priority", "") or "")
    sug = r.get("suggest", "")
    why = None
    if r.get("confidence") != "sure":
        why = "unsure"
    elif "skip" in sug.lower() or "=" not in sug:
        why = "skip"
    elif not pr or int(pr.group()) > 8:
        why = "low priority / out of combat"
    elif "stance bar" in r.get("note", "").lower():
        why = "stance"
    elif (cls, name) in LEAVE:
        why = "left for Rob"
    if why:
        skipped.append((cls, name, why))
        continue
    prio = int(pr.group())
    specs = [int(x) for x in re.findall(r"\d+", r.get("specs", ""))]
    specs = [s for s in specs if s not in EXCLUDE_SPECS.get((cls, name), [])]
    if not specs:
        skipped.append((cls, name, "all specs excluded (second pass)"))
        continue
    key, val = kv(sug)
    t = texts[cls]
    a, b = table_span(t, cls)
    m = entry_re(name).search(t, a, b)
    if m:
        body = m.group(2)
        cur, sm = parse_specs(body)
        if cur is None:
            skipped.append((cls, name, "entry applies to all specs already"))
            continue
        if cur == []:
            skipped.append((cls, name, "card-only entry (specs = {})"))
            continue
        add = [s for s in specs if s not in cur]
        if not add:
            skipped.append((cls, name, "specs already there"))
            continue
        newbody = body[:sm.start()] + "specs = { " + ", ".join(str(s) for s in cur + add) + " }" + body[sm.end():]
        same = re.search(r'\b%s\s*=\s*"%s"' % (key, re.escape(val)), body) is not None
        special = re.search(r"bindKey|cooldown_bar|blockQ", body) is not None
        if (not same or special):
            if "blockAs" in body:
                skipped.append((cls, name, "needs blockAs but entry has one: by hand"))
                continue
            ba = ", ".join('[%d] = { %s = "%s", priority = %d }' % (s, key, val, prio) for s in add)
            newbody = newbody.rstrip() + ", blockAs = { " + ba + " } "
        line = m.group(1) + newbody + m.group(3)
        t = t[:m.start()] + line + t[m.end():]
        texts[cls] = t
        log[cls].append("extend %s -> +%s%s" % (name, add, " (blockAs)" if (not same or special) else ""))
    else:
        k = (cls, name)
        if k in pending:
            p = pending[k]
            add = [s for s in specs if s not in p["specs"]]
            p["specs"] += add
            if (key, val, prio) != (p["key"], p["val"], p["prio"]):
                for s in add:
                    p["blockAs"][s] = (key, val, prio)
            log[cls].append("new %s: + %s" % (name, add))
            continue
        idv = re.match(r"^\d+", r.get("id", "") or "")
        idtxt = ""
        if idv and not re.search(r"\bid\s*=\s*%s\b" % idv.group(), t):
            idtxt = "id = %s, " % idv.group()
        note = (r.get("note", "") or "").replace("\n", " ")[:90]
        pending[k] = {"id": idtxt, "key": key, "val": val, "prio": prio, "specs": list(specs), "blockAs": {},
                      "note": note}
        log[cls].append("new %s %s" % (name, specs))

for (cls, name), p in pending.items():
    ba = ""
    if p["blockAs"]:
        ba = ", blockAs = { " + ", ".join('[%d] = { %s = "%s", priority = %d }' % (s, a, b, c)
                                          for s, (a, b, c) in p["blockAs"].items()) + " }"
    new_lines[cls].append('    ["%s"] = { %s%s = "%s", priority = %d, specs = { %s }%s }, -- gap round 5 Oct 2026 (mh-research, wago 69933): %s'
                          % (name, p["id"], p["key"], p["val"], p["prio"], ", ".join(str(s) for s in p["specs"]), ba, p["note"]))

for cls in FILE:
    t = texts[cls]
    for name in REMOVE.get(cls, []):
        a, b = table_span(t, cls)
        m = entry_re(name).search(t, a, b)
        if m:
            t = t[:m.start()] + "    -- REMOVED 5 Oct 2026 (gap round, mh-research: not castable in 12.1): " + m.group(0).strip() + t[m.end():]
            log[cls].append("removed " + name)
        else:
            log[cls].append("REMOVE NOT FOUND " + name)
    for (c, name), sp in NARROW.items():
        if c != cls:
            continue
        a, b = table_span(t, cls)
        m = entry_re(name).search(t, a, b)
        if not m:
            log[cls].append("NARROW NOT FOUND " + name)
            continue
        body = m.group(2)
        cur, sm = parse_specs(body)
        spec_txt = "specs = { " + ", ".join(str(s) for s in sp) + " }"
        body = (body[:sm.start()] + spec_txt + body[sm.end():]) if sm else (body.rstrip() + ", " + spec_txt + " ")
        t = t[:m.start()] + m.group(1) + body + m.group(3) + t[m.end():]
        log[cls].append("narrow %s -> %s" % (name, sp))
    for (c, name), drop in DROP_SPEC.items():
        if c != cls:
            continue
        a, b = table_span(t, cls)
        m = entry_re(name).search(t, a, b)
        if not m:
            log[cls].append("DROP NOT FOUND " + name)
            continue
        body = m.group(2)
        cur, sm = parse_specs(body)
        if cur and drop in cur:
            cur = [s for s in cur if s != drop]
            body = body[:sm.start()] + "specs = { " + ", ".join(str(s) for s in cur) + " }" + body[sm.end():]
            t = t[:m.start()] + m.group(1) + body + m.group(3) + t[m.end():]
            log[cls].append("drop %d from %s" % (drop, name))
    if new_lines[cls]:
        a, b = table_span(t, cls)
        nl = "\r\n" if "\r\n" in t else "\n"
        block = nl + "    -- Gap round 5 Oct 2026 (Rob: \"ja doe maar\"): castable 12.1 spells that had no entry." + nl + nl.join(new_lines[cls]) + nl
        t = t[:b] + block + t[b:]
    texts[cls] = t
    p = R + "KeybindRoles_%s.lua" % FILE[cls]
    io.open(p + ".tmp", "w", encoding="utf-8", newline="").write(t)
    os.replace(p + ".tmp", p)

for cls in FILE:
    for l in log[cls]:
        print(cls, l)
print("--- skipped ---")
for s in skipped:
    print(" ", s[0], "|", s[1], "|", s[2])
print("rows", len(rows), "skipped", len(skipped))
