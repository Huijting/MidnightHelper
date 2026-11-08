"""Which of Rob's installed addons changed since the last look, and what do their changelogs say?

    python tools/_probe.py run addon_updates

Part of the morning round since 22 Sep 2026. Rob: "hebben we addons die geupdate zijn ook getest?" —
followed by "ja doe maar" to checking them every morning. File dates are useless for this (the
updater rewrites every folder), so the tool compares each addon's .toc Version against what it saw
last time, stored in tools/addon_versions_seen*.json (local, not in git: it describes one machine).

Since 8 Nov 2026 (Rob: "meldingen wat er geupdate is in midnight en 4ever ... sinds ik het op automatisch updaten
heb gezet heb ik geen idee wat er verandert is" → "Ja, bouw maar"):
  - it looks at BOTH games: Midnight (_retail_) and WoW Forever (_forever_), each with its own seen-file;
  - a WATCH LIST: addons Rob switched off on every character (read from WTF/.../AddOns.txt). When one of those gets
    a new version it is printed first, with a bell, because that is the moment to try it again (his example:
    CharacterScape in Forever, switched off because it kept throwing errors).

For every addon whose version moved it prints the top of its own changelog, so the human reading
the output can say whether anything touches Midnight Helper. It does NOT judge that itself. An addon
without a changelog file is listed as such, never silently skipped.

First run of a game: records everything and reports only the count, so there is a baseline to compare against.
"""
import glob
import io
import json
import os
import re

HERE = os.path.dirname(os.path.abspath(__file__))
ADDONS = os.path.dirname(os.path.dirname(HERE))  # _retail_/Interface/AddOns
WOW = os.path.dirname(os.path.dirname(os.path.dirname(ADDONS)))  # E:/World of Warcraft
GAMES = [
    # (label, AddOns folder, seen-file); the Midnight file keeps its old name so its baseline carries on.
    ("Midnight", ADDONS, os.path.join(HERE, "addon_versions_seen.json")),
    ("Forever", os.path.join(WOW, "_forever_", "Interface", "AddOns"), os.path.join(HERE, "addon_versions_seen_forever.json")),
]
LOG_NAMES = ("changelog", "changes", "whatsnew")


def toc_path(d, name):
    main = os.path.join(d, name + ".toc")
    if os.path.exists(main):
        return main
    tocs = sorted(glob.glob(os.path.join(d, "*.toc")))
    return tocs[0] if tocs else None


def toc_field(path, field):
    try:
        for line in io.open(path, encoding="utf-8-sig", errors="replace"):
            m = re.match(r"^##\s*" + re.escape(field) + r"\s*:\s*(.+)$", line.strip(), re.I)
            if m:
                return m.group(1).strip()
    except OSError:
        pass
    return ""


def changelog_top(d, limit=7):
    for p in sorted(glob.glob(os.path.join(d, "*"))):
        base, ext = os.path.splitext(os.path.basename(p))
        if os.path.isfile(p) and base.lower().replace("_", "") in LOG_NAMES and ext.lower() in (".md", ".txt", ""):
            out = []
            for line in io.open(p, encoding="utf-8-sig", errors="replace"):
                s = line.strip()
                if not s or s.startswith("[Full Changelog]") or s.lower().startswith("# "):
                    continue
                if out and re.match(r"^(##\s*)?\[?v?\d", s):
                    break  # next version heading
                out.append(s[:160])
                if len(out) >= limit:
                    break
            return os.path.basename(p), out
    return None, []


def switched_off(addons_dir):
    """name -> (off, total): on how many characters the addon is disabled, out of how many that list it."""
    game_root = os.path.dirname(os.path.dirname(addons_dir))
    counts = {}
    for p in glob.glob(os.path.join(game_root, "WTF", "Account", "*", "*", "*", "AddOns.txt")):
        try:
            for line in io.open(p, encoding="utf-8-sig", errors="replace"):
                m = re.match(r"^(.+?):\s*(enabled|disabled)\s*$", line.strip(), re.I)
                if m:
                    off, total = counts.get(m.group(1), (0, 0))
                    counts[m.group(1)] = (off + (m.group(2).lower() == "disabled"), total + 1)
        except OSError:
            pass
    return counts


def where_to_read(d, name):
    toc = toc_path(d, name)
    cf = toc_field(toc, "X-Curse-Project-ID") if toc else ""
    web = toc_field(toc, "X-Website") if toc else ""
    if cf:
        return "CurseForge project %s" % cf
    if web:
        return web
    return "zijn CurseForge-pagina (geen project-ID in de .toc)"


def print_block(d, name, old, new, extra=""):
    log, lines = changelog_top(os.path.join(d, name))
    print("== %s  %s -> %s%s" % (name, old or "?", new or "?", extra))
    if log:
        for s in lines:
            print("   " + s)
    else:
        print("   (geen changelog-bestand in de map; lees %s)" % where_to_read(d, name))


def run_game(label, addons_dir, state):
    print("######## %s  (%s)" % (label, addons_dir))
    if not os.path.isdir(addons_dir):
        print("   map bestaat niet: overgeslagen.")
        return
    seen = {}
    if os.path.exists(state):
        seen = json.load(io.open(state, encoding="utf-8"))
    first_run = not seen

    now = {}
    for name in sorted(os.listdir(addons_dir), key=str.lower):
        d = os.path.join(addons_dir, name)
        if not os.path.isdir(d) or name.startswith("Blizzard_"):
            continue
        toc = toc_path(d, name)
        if toc:
            now[name] = toc_field(toc, "Version")

    off = switched_off(addons_dir)
    # Watch list: off on EVERY character that lists it (one char with it off is a per-character choice, not "kapot").
    # RaiderIO's other-region databases are off on purpose and update daily: a bell every morning would be noise.
    watch = sorted(n for n in now if n in off and off[n][0] > 0 and off[n][0] == off[n][1]
                   and not n.startswith("RaiderIO_DB_"))

    if first_run:
        print("eerste run: %d addons vastgelegd als basis; de volgende run meldt wat er verandert." % len(now))
    else:
        changed = [n for n in now if n in seen and now[n] != seen[n]]
        added = [n for n in now if n not in seen]
        removed = [n for n in seen if n not in now]

        # Bell first: a switched-off addon got a new version.
        rang = [n for n in changed if n in watch]
        for n in rang:
            print()
            print("🔔 UITGEZET, EN NU BIJGEWERKT (misschien gerepareerd?) — uit bij %d van %d characters" % off[n])
            print_block(addons_dir, n, seen[n], now[n])

        # The DB-only halves of a suite repeat their parent's news; show the parent once.
        shown = [n for n in changed if n not in rang
                 and not re.match(r"^RaiderIO_DB_|^DBM-(Party|Raids|Delves)-(?!Midnight)", n)]
        # A suite's modules share its prefix and version (EllesmereUIBags next to EllesmereUI, 23 Sep:
        # 21 blocks saying "no changelog"). Fold a module into its parent when both moved together.
        folded = {}
        for n in list(shown):
            parent = next((p for p in shown if p != n and n.startswith(p) and now[p] == now[n]), None)
            if parent:
                shown.remove(n)
                folded[parent] = folded.get(parent, 0) + 1
        print("addons: %d · bijgewerkt: %d (waarvan %d getoond) · nieuw: %d · weg: %d"
              % (len(now), len(changed), len(shown) + len(rang), len(added), len(removed)))
        for n in shown:
            print()
            extra = ("  (+%d modules, same version)" % folded[n]) if n in folded else ""
            print_block(addons_dir, n, seen[n], now[n], extra)
        for n in added:
            print("NIEUW: %s %s" % (n, now[n]))
        for n in removed:
            print("WEG:   %s" % n)

    # Always say what is on the watch list, so "no bell" reads as "looked, nothing new" and not as "never looked".
    print()
    if watch:
        print("wachtlijst (uit op elk character): " + ", ".join("%s %s" % (n, now[n] or "?") for n in watch))
    else:
        print("wachtlijst (uit op elk character): leeg (%d AddOns.txt-regels gelezen)" % sum(t for _, t in off.values()))

    tmp = state + ".tmp"
    json.dump(now, io.open(tmp, "w", encoding="utf-8"), indent=1, sort_keys=True)
    os.replace(tmp, state)


def main():
    for i, (label, d, state) in enumerate(GAMES):
        if i:
            print()
        run_game(label, d, state)


if __name__ == "__main__":
    main()
