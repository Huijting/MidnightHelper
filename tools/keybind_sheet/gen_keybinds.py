#!/usr/bin/env python3
"""Generate per-spec keybind data from MidnightHelper's KeybindRoles_*.lua by a
faithful port of ns.Keybind_AllocateSpells (KeybindSchema.lua v6). Emits keybinds.json."""
import re, json, os, glob

ADDON = r"E:\World of Warcraft\_retail_\Interface\AddOns\MidnightHelper\Modules"

# ---- v6 schema tables (ported verbatim from KeybindSchema.lua) ----
MOD_DISPLAY = {"shift": "Shift", "ctrl": "Ctrl", "alt": "Alt"}
# Alt was dropped from the scheme on 6 Aug 2026; this file kept handing it out for
# another day, so the sheet showed keys the addon never binds. Mirror the Lua.
MOD_FILL = ["shift", "ctrl"]
# Thumb buttons, tried after the Shift layer (KeybindSchema.lua, trySlots). EMPTY by
# default, mirroring the Lua since 7 Aug 2026: we do not assume a player has any. The
# old default of two put 52 bindings across the specs on buttons nobody confirmed, and
# a key you cannot press is worse than an ability we admit did not fit. Set it to
# ["BUTTON4", ...] to model a player who has told us.
MOUSE_SLOTS = []
EXCLUDED = {"G"}
BASE_FILL = ["1","2","3","4","5","Q","F","R","X","Z","C","V","F1"]
ROLES = {
    "interrupt":"E","main_rotation_1":"1","main_rotation_2":"2","main_rotation_3":"3",
    "spender":"4","utility_primary":"Q","utility_secondary":"F","defensive_1":"Z",
    "defensive_2":"X","defensive_3":"C","defensive_4":"V","mobility":"R",
    "cooldown_bar":"F1","heal_quick":"F2","heal_ooc":"F3","heal_sustain":"F4",
}
# human role label per role/category, for the display
ROLE_LABEL = {
    "interrupt":"Interrupt","utility_primary":"Movement","utility_secondary":"Utility",
    "mobility":"Mobility","defensive_1":"Defensive","defensive_2":"Defensive",
    "defensive_3":"Defensive (major)","defensive_4":"Dispel / CC","cooldown_bar":"Big cooldown",
    "heal_quick":"Self-heal","heal_ooc":"Heal (out of combat)","heal_sustain":"Sustain / HoT",
}
CAT_LABEL = {
    "main_rotation":"Rotation","spender":"Spender","raid_heal":"Raid heal","taunt":"Taunt",
    "utility":"Utility","interrupt":"Interrupt","defensive":"Defensive","dispel_cc":"Dispel / CC",
    "cooldown":"Cooldown","selfheal":"Self-heal","pet_care":"Pet","blessings":"Blessing",
    "racial":"Racial",
}
CATEGORIES = {
    "main_rotation":["1","2","3","4","5"],"spender":["4","5"],"raid_heal":["1","2","3","4","5"],
    "taunt":["F"],"utility":["F","R","X"],"interrupt":["E"],"defensive":["Z","C","X","V"],
    "dispel_cc":["V","X","C"],"cooldown":["F1","F3","F2"],"selfheal":["F2","F3","F4"],"pet_care":["R","F1"],
    "blessings":["R","F1"],"racial":["E"],
}
PREF_BASE_OK = {"E","F1","F2","F3","F4","T"} | set(BASE_FILL)  # T: consumable anchor, wishes only
# Bare base keys no spell may take. Mirrors ns.Keybind_ReservedBaseKeys: empty by default,
# {"1"} when the player turns on /mh sba (Blizzard's Assisted Combat button). Only the bare
# key -- Shift+1 stays available, it is a different press.
RESERVED_BASE = set()
# A role resolves to one key, so a reserved key would strand it; send it to its category.
ROLE_FALLBACK_CATEGORY = {"main_rotation_1":"main_rotation","main_rotation_2":"main_rotation",
                          "main_rotation_3":"main_rotation","spender":"spender"}

def normalize_base(k):
    k = (k or "").strip()
    m = re.match(r'^[fF](\d+)$', k)
    if m: return "F"+m.group(1)
    if len(k) == 1: return k.upper()
    return k

def parse_bindkey(bk):
    raw = (bk or "").strip()
    m = re.match(r'^([A-Za-z]+)[\+\-](.+)$', raw)
    if m and m.group(1).lower() in MOD_DISPLAY:
        return m.group(1).lower(), normalize_base(m.group(2))
    return None, normalize_base(raw)

def make_bindkey(mod, base):
    base = normalize_base(base)
    if not base: return None
    if not mod: return base
    if mod not in MOD_DISPLAY: return base
    return MOD_DISPLAY[mod]+"+"+base

def slotlist_for(sp):
    if sp.get("role") == "interrupt": return CATEGORIES["interrupt"]
    role = sp.get("role")
    if role and role in ROLES:
        if ROLES[role] in RESERVED_BASE:
            fb = ROLE_FALLBACK_CATEGORY.get(role)
            return CATEGORIES[fb] if fb else BASE_FILL
        return [ROLES[role]]
    cat = sp.get("category")
    if cat: return CATEGORIES.get(cat)  # None if unknown -> base fallback
    return BASE_FILL

def try_slots(slots, sp, occupied, out):
    if not slots: return False
    for mod in [None] + MOD_FILL:
        for s in slots:
            base = normalize_base(s)
            if base and base not in EXCLUDED and not (base in RESERVED_BASE and not mod):
                bk = make_bindkey(mod, base) if mod else base
                if bk and bk not in occupied:
                    occupied.add(bk); out[bk] = sp; return True
        # After Shift, before Ctrl: a free thumb button beats a second modifier.
        if mod == "shift":
            for bk in MOUSE_SLOTS:
                if bk not in occupied:
                    occupied.add(bk); out[bk] = sp; return True
    return False

def try_preferred(sp, occupied, out):
    if not sp.get("bindKey"): return False
    mod, base = parse_bindkey(sp["bindKey"])
    if not base or base in EXCLUDED or base not in PREF_BASE_OK: return False
    if base in RESERVED_BASE and not mod: return False  # a reserved bare key beats a wish
    bk = make_bindkey(mod, base)
    if bk and bk not in occupied:
        occupied.add(bk); out[bk] = sp; return True
    return False

def allocate(spells):
    """Two passes, wishes first inside each — see KeybindSchema.lua's `pass()`.

    Role anchors resolve to exactly one key and so have nowhere else to go; categories
    have a list. Serving the one with no alternative first is the only order that cannot
    strand anybody. Within a pass, a spell that named a key (`bindKey`) is served before
    ordinary overflow, or overflow sits on a key that was spoken for.

    There is NO global fallback: a spell that does not fit its own slots and their
    modifier layers gets no key and is returned as unplaced. Falling back on the whole
    base list put crowd control on builder keys, which is the complaint that started
    the rework.
    """
    out, occupied, unplaced = {}, set(), []

    def sortkey(s):
        return (s.get("priority", 0) or 0, 0 if s.get("role") == "interrupt" else 1, s.get("id", 0) or 0)

    def place(sp):
        if try_preferred(sp, occupied, out):
            return
        if not try_slots(slotlist_for(sp), sp, occupied, out):
            unplaced.append(sp)

    ordered = sorted(spells, key=sortkey)
    handled = set()
    for wants_role in (True, False):
        for wishes_first in (True, False):
            for i, sp in enumerate(ordered):
                if i in handled:
                    continue
                if (sp.get("role") is not None) != wants_role:
                    continue
                if (sp.get("bindKey") is not None) != wishes_first:
                    continue
                handled.add(i)
                place(sp)
    return out, unplaced

# ---- parse KeybindRoles_*.lua ----
def parse_file(path):
    entries = []
    for line in open(path, encoding="utf-8", errors="replace"):
        m = re.search(r'\["([^"]+)"\]\s*=\s*\{', line)
        if not m: continue
        name = m.group(1)
        def gs(pat):
            mm = re.search(pat, line); return mm.group(1) if mm else None
        specs = None
        sm = re.search(r'specs\s*=\s*\{([^}]*)\}', line)
        if sm:
            specs = [int(x) for x in re.findall(r'\d+', sm.group(1))]
        e = {
            "name": name,
            "id": int(gs(r'\bid\s*=\s*(\d+)')) if gs(r'\bid\s*=\s*(\d+)') else None,
            "role": gs(r'\brole\s*=\s*"([^"]+)"'),
            "category": gs(r'\bcategory\s*=\s*"([^"]+)"'),
            "priority": int(gs(r'\bpriority\s*=\s*(\d+)')) if gs(r'\bpriority\s*=\s*(\d+)') else 0,
            "bindKey": gs(r'\bbindKey\s*=\s*"([^"]+)"'),
            "specs": specs,
        }
        if e["role"] or e["category"]:
            entries.append(e)
    return entries

CLASS_ENTRIES = {}
for path in glob.glob(os.path.join(ADDON, "KeybindRoles_*.lua")):
    fn = os.path.basename(path)
    if "HunterPaladinShaman" in fn:  # legacy draft; superseded by per-class files
        continue
    if "Racials" in fn:
        # Racials register globally and depend on the player's RACE, not their spec.
        # A per-spec sheet cannot say which one you have, so it says none.
        continue
    token = fn.replace("KeybindRoles_", "").replace(".lua", "").upper()
    CLASS_ENTRIES[token] = parse_file(path)

# global (KeybindAutoMap.lua): Recuperate = F4 sustain, applies to everyone in Midnight
GLOBAL = [{"name":"Recuperate","id":1231411,"role":"heal_sustain","category":None,"priority":1,"bindKey":None,"specs":None}]

# specID -> (classToken, Class, Spec, role)
SPECS = {
    250:("DEATHKNIGHT","Death Knight","Blood","tank"),251:("DEATHKNIGHT","Death Knight","Frost","dps"),252:("DEATHKNIGHT","Death Knight","Unholy","dps"),
    577:("DEMONHUNTER","Demon Hunter","Havoc","dps"),581:("DEMONHUNTER","Demon Hunter","Vengeance","tank"),
    102:("DRUID","Druid","Balance","dps"),103:("DRUID","Druid","Feral","dps"),104:("DRUID","Druid","Guardian","tank"),105:("DRUID","Druid","Restoration","heal"),
    1467:("EVOKER","Evoker","Devastation","dps"),1468:("EVOKER","Evoker","Preservation","heal"),1473:("EVOKER","Evoker","Augmentation","dps"),
    253:("HUNTER","Hunter","Beast Mastery","dps"),254:("HUNTER","Hunter","Marksmanship","dps"),255:("HUNTER","Hunter","Survival","dps"),
    62:("MAGE","Mage","Arcane","dps"),63:("MAGE","Mage","Fire","dps"),64:("MAGE","Mage","Frost","dps"),
    268:("MONK","Monk","Brewmaster","tank"),269:("MONK","Monk","Windwalker","dps"),270:("MONK","Monk","Mistweaver","heal"),
    65:("PALADIN","Paladin","Holy","heal"),66:("PALADIN","Paladin","Protection","tank"),70:("PALADIN","Paladin","Retribution","dps"),
    256:("PRIEST","Priest","Discipline","heal"),257:("PRIEST","Priest","Holy","heal"),258:("PRIEST","Priest","Shadow","dps"),
    259:("ROGUE","Rogue","Assassination","dps"),260:("ROGUE","Rogue","Outlaw","dps"),261:("ROGUE","Rogue","Subtlety","dps"),
    262:("SHAMAN","Shaman","Elemental","dps"),263:("SHAMAN","Shaman","Enhancement","dps"),264:("SHAMAN","Shaman","Restoration","heal"),
    265:("WARLOCK","Warlock","Affliction","dps"),266:("WARLOCK","Warlock","Demonology","dps"),267:("WARLOCK","Warlock","Destruction","dps"),
    71:("WARRIOR","Warrior","Arms","dps"),72:("WARRIOR","Warrior","Fury","dps"),73:("WARRIOR","Warrior","Protection","tank"),
}

def label_for(sp):
    if sp.get("role") and sp["role"] in ROLE_LABEL: return ROLE_LABEL[sp["role"]]
    if sp.get("category") and sp["category"] in CAT_LABEL: return CAT_LABEL[sp["category"]]
    return ""

out_specs = []
for sid,(token,cls,spec,role) in sorted(SPECS.items(), key=lambda kv:(kv[1][1],kv[1][2])):
    ents = CLASS_ENTRIES.get(token, []) + GLOBAL
    picked, clickcast = [], []
    for e in ents:
        if e["specs"] is not None and sid not in e["specs"]:
            continue
        if e["role"] == "click_cast" or e["category"] == "click_cast":
            clickcast.append(e["name"]); continue
        picked.append(e)
    alloc, unplaced = allocate(picked)
    # Keep on the KEYBOARD only abilities that land on their own role/category key;
    # true overflow (a spec has more CC/dispels than the V slot holds, so the extra
    # steals a free rotation key) goes to a "situational" list instead. Cleaner sheet,
    # matches the v6 intent (V = your main dispel/CC; the rest you bind where you like).
    def home_bases(sp):
        if sp.get("role") == "interrupt": return {"E"}
        r = sp.get("role")
        if r and r in ROLES: return {ROLES[r]}
        c = sp.get("category")
        if c and c in CATEGORIES: return set(CATEGORIES[c])
        return None  # no expectation -> wherever it landed is fine
    keys, situational = {}, []
    for bk, sp in alloc.items():
        base = bk.split("+")[-1]
        hb = home_bases(sp)
        entry = {"name": sp["name"], "label": label_for(sp)}
        if hb is None or base in hb:
            keys[bk] = entry
        else:
            situational.append({"key": bk, "name": sp["name"], "label": label_for(sp)})
    situational.sort(key=lambda x: x["name"])
    out_specs.append({"id": sid, "class": cls, "classToken": token, "spec": spec, "role": role,
                      "keys": keys, "situational": situational, "clickcast": sorted(set(clickcast)),
                      "unplaced": sorted(sp["name"] for sp in unplaced)})

data = {"specs": out_specs}
outpath = os.path.join(os.path.dirname(os.path.abspath(__file__)), "keybinds.json")
json.dump(data, open(outpath,"w",encoding="utf-8"), ensure_ascii=False, indent=1)
print(f"wrote {outpath} — {len(out_specs)} specs")
# quick verify: Prot Paladin (66)
prot = next(s for s in out_specs if s["id"]==66)
print("Prot Paladin anchors:", {k: prot["keys"][k]["name"] for k in ("E","Q","Z","C","F1") if k in prot["keys"]})
print("Prot Paladin all keys:", {k: prot["keys"][k]["name"] for k in sorted(prot["keys"])})
