"""Which of Rob's installed addons changed since the last look, and what do their changelogs say?

    python tools/_probe.py run addon_updates

Part of the morning round since 22 Sep 2026. Rob: "hebben we addons die geupdate zijn ook getest?" —
followed by "ja doe maar" to checking them every morning. File dates are useless for this (the
updater rewrites every folder), so the tool compares each addon's .toc Version against what it saw
last time, stored in tools/addon_versions_seen.json (local, not in git: it describes one machine).

For every addon whose version moved it prints the top of its own changelog, so the human reading
the output can say whether anything touches Midnight Helper. It does NOT judge that itself. An addon
without a changelog file is listed as such, never silently skipped.

First run: records everything and reports only the count, so there is a baseline to compare against.
"""
import glob
import io
import json
import os
import re

HERE = os.path.dirname(os.path.abspath(__file__))
ADDONS = os.path.dirname(os.path.dirname(HERE))
STATE = os.path.join(HERE, "addon_versions_seen.json")
LOG_NAMES = ("changelog", "changes", "whatsnew")


def toc_path(d, name):
    main = os.path.join(d, name + ".toc")
    if os.path.exists(main):
        return main
    tocs = sorted(glob.glob(os.path.join(d, "*.toc")))
    return tocs[0] if tocs else None


def toc_version(path):
    try:
        for line in io.open(path, encoding="utf-8-sig", errors="replace"):
            m = re.match(r"^##\s*Version\s*:\s*(.+)$", line.strip(), re.I)
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


def main():
    seen = {}
    if os.path.exists(STATE):
        seen = json.load(io.open(STATE, encoding="utf-8"))
    first_run = not seen

    now = {}
    for name in sorted(os.listdir(ADDONS), key=str.lower):
        d = os.path.join(ADDONS, name)
        if not os.path.isdir(d) or name.startswith("Blizzard_"):
            continue
        toc = toc_path(d, name)
        if toc:
            now[name] = toc_version(toc)

    if first_run:
        print("eerste run: %d addons vastgelegd als basis; de volgende run meldt wat er verandert." % len(now))
    else:
        changed = [n for n in now if n in seen and now[n] != seen[n]]
        added = [n for n in now if n not in seen]
        removed = [n for n in seen if n not in now]
        # The DB-only halves of a suite repeat their parent's news; show the parent once.
        shown = [n for n in changed if not re.match(r"^RaiderIO_DB_|^DBM-(Party|Raids|Delves)-(?!Midnight)", n)]
        print("addons: %d · bijgewerkt: %d (waarvan %d getoond) · nieuw: %d · weg: %d"
              % (len(now), len(changed), len(shown), len(added), len(removed)))
        for n in shown:
            log, lines = changelog_top(os.path.join(ADDONS, n))
            print()
            print("== %s  %s -> %s" % (n, seen[n] or "?", now[n] or "?"))
            if log:
                for s in lines:
                    print("   " + s)
            else:
                print("   (geen changelog-bestand in de map)")
        for n in added:
            print("NIEUW: %s %s" % (n, now[n]))
        for n in removed:
            print("WEG:   %s" % n)

    tmp = STATE + ".tmp"
    json.dump(now, io.open(tmp, "w", encoding="utf-8"), indent=1, sort_keys=True)
    os.replace(tmp, STATE)


if __name__ == "__main__":
    main()
