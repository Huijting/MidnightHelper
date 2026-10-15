"""Turn a WoW combat log into a per-fight list of what the enemies did -- the raw material for a boss guide
(Rob, 15 Oct 2026: "kunnen we iets bouwen waarbij we de filmpjes compleet kunnen analyseren en van daaruit een
guide maken? ... wat voor abilities zijn er, wat zou je kunnen doen").

A video shows what a fight LOOKS like; the combat log says what HAPPENED: every enemy cast with its spell id and
name, every debuff it put on a player, every hit, every interrupt and every death, to the millisecond. The game
writes it to <WoW>/_retail_/Logs/WoWCombatLog-*.txt while `/combatlog` is on. It is a file the client writes,
not something MH reads in game, so none of the combat-log taint questions apply.

GEMETEN on a 12.0.1 log (30 Mar 2026): enemy names, spell ids and spell names are plain text. The damage
AMOUNTS in that log looked wrong (a pet hitting a 10k-HP beast for 271 million), so this report counts hits
and does not print amounts.

Run through the front door (no arguments on the command line -- see CLAUDE.md):
    probe_job.txt:  run combatlog_guide                 (newest log in the Logs folder)
                    run combatlog_guide <log path>
Output: a Markdown report in %TEMP%/mh_combatlog/<log name>.md, and a short summary printed here.
"""
import csv
import glob
import os
import sys
from collections import defaultdict

LOG_DIR = r"E:\World of Warcraft\_retail_\Logs"
OUT_ROOT = os.path.join(os.environ.get("TEMP", r"C:\Temp"), "mh_combatlog")

HOSTILE = 0x40  # COMBATLOG_OBJECT_REACTION_HOSTILE
DEATH_LOOKBACK = 4  # enemy hits remembered per player, to say what killed them


def parse_time(stamp):
    # "3/30/2026 08:48:54.3832" -> seconds of the day (fights do not cross midnight often enough to matter)
    try:
        clock = stamp.split(" ")[1]
        h, m, s = clock.split(":")
        return int(h) * 3600 + int(m) * 60 + float(s)
    except (IndexError, ValueError):
        return None


def is_enemy(guid, flags):
    if not guid or not (guid.startswith("Creature-") or guid.startswith("Vehicle-")):
        return False
    try:
        return int(flags, 16) & HOSTILE != 0
    except (TypeError, ValueError):
        return False


def npc_id(guid):
    parts = guid.split("-")
    return parts[5] if len(parts) > 5 else "?"


class Segment:
    def __init__(self, title, start, encounter_id=None):
        self.title = title
        self.start = start
        self.end = start
        self.encounter_id = encounter_id
        self.result = None
        self.casts = defaultdict(lambda: {"start": [], "success": [], "school": ""})  # (npc, npcid, spellid, name)
        self.debuffs = defaultdict(lambda: {"count": 0, "players": set()})  # (npc, spellid, name)
        self.hits = defaultdict(lambda: {"count": 0, "players": set()})  # (npc, spellid, name)
        self.summons = defaultdict(int)  # (npc, spellid, name, summoned)
        self.interrupts = defaultdict(int)  # (enemy, spellid, name)
        self.deaths = []  # (t, player, [recent enemy hits])
        self.enemy_deaths = defaultdict(int)

    def empty(self):
        return not (self.casts or self.debuffs or self.hits or self.deaths)


def fmt_offset(seconds):
    seconds = max(0, int(round(seconds)))
    return "%d:%02d" % (seconds // 60, seconds % 60)


def describe_times(times, start):
    if not times:
        return "", ""
    first = fmt_offset(times[0] - start)
    if len(times) < 2:
        return first, ""
    gaps = [b - a for a, b in zip(times, times[1:]) if b - a > 0.5]  # same-moment multi-casts are one cast
    if not gaps:
        return first, ""
    return first, "%.0f-%.0f s" % (min(gaps), max(gaps)) if max(gaps) - min(gaps) > 2 else "~%.0f s" % (sum(gaps) / len(gaps))


def run(path):
    segments = []
    current_trash = None
    current_enc = None
    zone = "?"
    recent = defaultdict(list)  # player -> recent enemy hits
    meta = ""
    lines = 0

    def seg():
        nonlocal current_trash
        if current_enc:
            return current_enc
        if current_trash is None or current_trash.title != "Outside boss fights - " + zone:
            current_trash = Segment("Outside boss fights - " + zone, t)
            segments.append(current_trash)
        return current_trash

    with open(path, encoding="utf-8", errors="replace") as fh:
        for raw in fh:
            lines += 1
            head, sep, rest = raw.partition("  ")
            if not sep:
                continue
            t = parse_time(head)
            if t is None:
                continue
            try:
                f = next(csv.reader([rest.rstrip("\r\n")]))
            except (csv.Error, StopIteration):
                continue
            if not f:
                continue
            ev = f[0]
            if ev == "COMBAT_LOG_VERSION":
                meta = ",".join(f[1:])
                continue
            if ev == "ZONE_CHANGE" and len(f) > 2:
                zone = f[2]
                continue
            if ev == "ENCOUNTER_START" and len(f) > 2:
                current_enc = Segment(f[2], t, f[1])
                segments.append(current_enc)
                continue
            if ev == "ENCOUNTER_END" and len(f) > 5:
                if current_enc:
                    current_enc.end = t
                    current_enc.result = "kill" if f[5] == "1" else "wipe"
                current_enc = None
                continue
            if len(f) < 9:
                continue
            s = seg()
            s.end = t
            src_guid, src_name, src_flags = f[1], f[2], f[3]
            dst_guid, dst_name, dst_flags = f[5], f[6], f[7]
            enemy_src = is_enemy(src_guid, src_flags)
            player_dst = dst_guid.startswith("Player-")

            if ev == "UNIT_DIED":
                if player_dst:
                    s.deaths.append((t, dst_name, list(recent[dst_name])))
                    recent[dst_name] = []
                elif is_enemy(dst_guid, dst_flags):
                    s.enemy_deaths[dst_name] += 1
                continue
            if len(f) < 12:
                # SWING_* has no spell prefix
                if ev.startswith("SWING_DAMAGE") and enemy_src and player_dst and ev == "SWING_DAMAGE":
                    s.hits[(src_name, "0", "Melee")]["count"] += 1
                    s.hits[(src_name, "0", "Melee")]["players"].add(dst_name)
                    recent[dst_name] = (recent[dst_name] + [(src_name, "Melee")])[-DEATH_LOOKBACK:]
                continue
            spell_id, spell_name, school = f[9], f[10], f[11]

            if ev == "SPELL_INTERRUPT" and is_enemy(dst_guid, dst_flags) and len(f) > 13:
                s.interrupts[(dst_name, f[12], f[13])] += 1
                continue
            if not enemy_src:
                continue
            key = (src_name, npc_id(src_guid), spell_id, spell_name)
            if ev == "SPELL_CAST_START":
                s.casts[key]["start"].append(t)
                s.casts[key]["school"] = school
            elif ev == "SPELL_CAST_SUCCESS":
                s.casts[key]["success"].append(t)
                s.casts[key]["school"] = school
            elif ev == "SPELL_AURA_APPLIED" and player_dst and len(f) > 12 and f[12] == "DEBUFF":
                d = s.debuffs[(src_name, spell_id, spell_name)]
                d["count"] += 1
                d["players"].add(dst_name)
            elif ev in ("SPELL_DAMAGE", "SPELL_PERIODIC_DAMAGE", "RANGE_DAMAGE") and player_dst:
                h = s.hits[(src_name, spell_id, spell_name + (" (tick)" if ev == "SPELL_PERIODIC_DAMAGE" else ""))]
                h["count"] += 1
                h["players"].add(dst_name)
                recent[dst_name] = (recent[dst_name] + [(src_name, spell_name)])[-DEATH_LOOKBACK:]
            elif ev == "SPELL_SUMMON":
                s.summons[(src_name, spell_id, spell_name, dst_name)] += 1

    return meta, lines, [x for x in segments if not x.empty()]


def report(path, meta, lines, segments):
    out = []
    out.append("# Combat log: %s" % os.path.basename(path))
    out.append("")
    out.append("Log header: `%s` - %d lines read. Times are minutes:seconds from the start of the fight." % (meta, lines))
    out.append("Damage amounts are left out on purpose (see the tool's docstring). \"Players\" = how many different players it touched.")
    for s in segments:
        out.append("")
        dur = fmt_offset(s.end - s.start)
        if s.encounter_id:
            out.append("## %s (encounter %s) - %s, %s" % (s.title, s.encounter_id, dur, s.result or "no end seen"))
        else:
            out.append("## %s - %s" % (s.title, dur))
        if s.casts:
            out.append("")
            out.append("**Enemy casts** (cast bar = has a cast time, so it can be seen coming and maybe interrupted)")
            out.append("")
            out.append("| Enemy (npc id) | Spell (id) | Cast bar | Instant/finished | First | Repeats every |")
            out.append("|---|---|---|---|---|---|")
            for (npc, nid, sid, name), c in sorted(s.casts.items(), key=lambda kv: (kv[0][0], -(len(kv[1]["start"]) + len(kv[1]["success"])))):
                times = sorted(c["start"] or c["success"])
                first, every = describe_times(times, s.start)
                out.append("| %s (%s) | %s (%s) | %d | %d | %s | %s |" % (npc, nid, name, sid, len(c["start"]), len(c["success"]), first, every))
        if s.debuffs:
            out.append("")
            out.append("**Debuffs on players**")
            out.append("")
            for (npc, sid, name), d in sorted(s.debuffs.items(), key=lambda kv: -kv[1]["count"]):
                out.append("- %s (%s) from %s: %dx, %d player(s)" % (name, sid, npc, d["count"], len(d["players"])))
        if s.hits:
            out.append("")
            out.append("**What hit players**")
            out.append("")
            for (npc, sid, name), h in sorted(s.hits.items(), key=lambda kv: -kv[1]["count"]):
                out.append("- %s (%s) from %s: %d hits, %d player(s)" % (name, sid, npc, h["count"], len(h["players"])))
        if s.summons:
            out.append("")
            out.append("**Summons**")
            out.append("")
            for (npc, sid, name, what), n in s.summons.items():
                out.append("- %s casts %s (%s) -> %s, %dx" % (npc, name, sid, what, n))
        if s.interrupts:
            out.append("")
            out.append("**Interrupted** (proof the spell CAN be interrupted)")
            out.append("")
            for (enemy, sid, name), n in s.interrupts.items():
                out.append("- %s (%s) on %s: %dx" % (name, sid, enemy, n))
        if s.deaths:
            out.append("")
            out.append("**Player deaths**")
            out.append("")
            for t, who, last in s.deaths:
                tail = ", ".join("%s (%s)" % (spell, npc) for npc, spell in last) or "no enemy hit seen"
                out.append("- %s at %s - last enemy hits: %s" % (who, fmt_offset(t - s.start), tail))
        if s.enemy_deaths:
            out.append("")
            out.append("Enemies killed: " + ", ".join("%s x%d" % kv for kv in sorted(s.enemy_deaths.items(), key=lambda kv: -kv[1])))
    return "\n".join(out) + "\n"


def main(argv):
    if argv:
        path = argv[0]
    else:
        logs = sorted(glob.glob(os.path.join(LOG_DIR, "WoWCombatLog*.txt")), key=os.path.getmtime)
        if not logs:
            print("no combat log in", LOG_DIR, "- type /combatlog in game first")
            return 1
        path = logs[-1]
    if not os.path.isfile(path):
        print("not found:", path)
        return 1
    meta, lines, segments = run(path)
    os.makedirs(OUT_ROOT, exist_ok=True)
    out_path = os.path.join(OUT_ROOT, os.path.splitext(os.path.basename(path))[0] + ".md")
    text = report(path, meta, lines, segments)
    with open(out_path + ".tmp", "w", encoding="utf-8", newline="\n") as fh:
        fh.write(text)
    os.replace(out_path + ".tmp", out_path)
    print("log:", path, "(%d lines)" % lines)
    print("header:", meta)
    print("report:", out_path)
    for s in segments:
        kind = ("encounter %s, %s" % (s.encounter_id, s.result or "no end")) if s.encounter_id else "outside fights"
        print("  - %s [%s]: %d enemy spells, %d debuffs, %d player deaths" % (s.title, kind, len(s.casts), len(s.debuffs), len(s.deaths)))
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
