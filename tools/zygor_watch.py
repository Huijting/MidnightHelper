"""What changed in the Zygor guides since the last look? Part of the morning round (step e, Rob 11 Nov 2026).

    probe_job.txt:  run zygor_watch            -> both games
                    run zygor_watch --selftest -> proves it sees a change (a fake edit on a copy), then cleans up

Why: Zygor is a trusted local source for quest chains, ids and coordinates (memory: zygor-guide-data-source), and on
10 Nov it quietly updated Midnight mounts and achievements. addon_updates only says THAT the version moved; this says
WHAT moved. Same shape as tools/handynotes_watch.py.

Watches:  Midnight  _retail_/Interface/AddOns/ZygorGuidesViewer/Guides-Retail/**.lua      (~717 files)
          Forever   _forever_/Interface/AddOns/ZygorGuidesViewerForever/Guides-Forever/**.lua (~104 files)
Detail (changed lines with the npc / quest / coordinates pulled out) only for the files that matter to MH:
  Midnight = file names containing "MID" (the Midnight expansion); Forever = every file (it is all Classic).
Other files: one line with +/- counts. A new or removed file is always named.

The copy from the last run is kept GZIPPED outside the repo and outside the WoW folder, in
%LOCALAPPDATA%\\MidnightHelper\\zygor_snapshot (not git: it describes one machine; not the WoW folder: Battle.net's
permission check trips over extra files there, the 25 Oct lesson). First run = baseline only.
It does NOT judge: the reader compares with MH's own data (rares, treasures, mounts, achievements, Forever trainers).
"""
import difflib
import glob
import gzip
import io
import os
import re
import shutil
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
# tools -> MidnightHelper -> AddOns -> Interface -> _retail_ -> World of Warcraft
WOW = os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(HERE)))))
GAMES = {
    "midnight": (os.path.join(WOW, "_retail_", "Interface", "AddOns", "ZygorGuidesViewer"), "Guides-Retail",
                 "ZygorGuidesViewer.toc", lambda rel: "MID" in os.path.basename(rel)),
    "forever": (os.path.join(WOW, "_forever_", "Interface", "AddOns", "ZygorGuidesViewerForever"), "Guides-Forever",
                "ZygorGuidesViewerForever.toc", lambda rel: True),
}
SNAP_ROOT = os.path.join(os.environ.get("LOCALAPPDATA") or os.path.expanduser("~"), "MidnightHelper", "zygor_snapshot")
MAX_LINES = 30  # per file
NPC = re.compile(r"##(\d{2,7})")
QUEST = re.compile(r"\|q\s+(\d{2,7})")
GOTO = re.compile(r"\|?goto\s+([^|]*?)\s+(\d{1,2}\.\d{1,2}),\s*(\d{1,2}\.\d{1,2})")
ACH = re.compile(r"achieve\s+(\d{3,6})", re.I)


def version(base, tocname):
    try:
        for line in io.open(os.path.join(base, tocname), encoding="utf-8-sig", errors="replace"):
            m = re.match(r"^##\s*Version\s*:\s*(.+)$", line.strip(), re.I)
            if m:
                return m.group(1).strip()
    except OSError:
        pass
    return "?"


def describe(line):
    bits = ["npc " + v for v in NPC.findall(line)] + ["quest " + v for v in QUEST.findall(line)]
    bits += ["ach " + v for v in ACH.findall(line)]
    bits += ["%s %s,%s" % g for g in GOTO.findall(line)]
    s = line.strip()
    if len(s) > 140:
        s = s[:137] + "..."
    return s + (("   [" + ", ".join(bits) + "]") if bits else "")


def guide_files(base, sub):
    root = os.path.join(base, sub)
    return {os.path.relpath(p, root).replace("\\", "/"): p
            for p in glob.glob(os.path.join(root, "**", "*.lua"), recursive=True)}


def read_text(path):
    with io.open(path, encoding="utf-8", errors="replace") as fh:
        return fh.read()


def snap_path(game, rel):
    return os.path.join(SNAP_ROOT, game, rel.replace("/", os.sep) + ".gz")


def read_snap(game, rel):
    with gzip.open(snap_path(game, rel), "rt", encoding="utf-8", errors="replace") as fh:
        return fh.read()


def write_snap(game, rel, text):
    p = snap_path(game, rel)
    os.makedirs(os.path.dirname(p), exist_ok=True)
    with gzip.open(p + ".tmp", "wt", encoding="utf-8") as fh:
        fh.write(text)
    os.replace(p + ".tmp", p)


def snap_names(game):
    root = os.path.join(SNAP_ROOT, game)
    out = set()
    for p in glob.glob(os.path.join(root, "**", "*.lua.gz"), recursive=True):
        out.add(os.path.relpath(p, root).replace("\\", "/")[:-3])
    return out


def watch(game, base, sub, tocname, detail, snap_game=None):
    """Print what changed for one game; returns the number of changed files. snap_game: where the copy lives."""
    snap_game = snap_game or game
    if not os.path.isdir(os.path.join(base, sub)):
        print("%s: Zygor not installed at %s — not checked" % (game, base))
        return 0
    ver = version(base, tocname)
    files = guide_files(base, sub)
    old = snap_names(snap_game)
    vfile = os.path.join(SNAP_ROOT, snap_game, "VERSION.txt")
    if not old:
        for rel, p in files.items():
            write_snap(snap_game, rel, read_text(p))
        os.makedirs(os.path.dirname(vfile), exist_ok=True)
        io.open(vfile, "w", encoding="utf-8").write(ver)
        print("%s: Zygor %s, baseline recorded (%d guide files). Next run shows what changed." % (game, ver, len(files)))
        return 0
    old_ver = io.open(vfile, encoding="utf-8").read().strip() if os.path.exists(vfile) else "?"
    print("%s: Zygor last seen %s, now %s (%d guide files)" % (game, old_ver, ver, len(files)))
    changed, quiet = 0, []
    for rel in sorted(files):
        text = read_text(files[rel])
        if rel not in old:
            changed += 1
            print("\n  == %s: NEW guide file (%d lines)" % (rel, text.count("\n") + 1))
            write_snap(snap_game, rel, text)
            continue
        before = read_snap(snap_game, rel)
        if before == text:
            continue
        changed += 1
        diff = [l for l in difflib.unified_diff(before.splitlines(), text.splitlines(), lineterm="", n=0)
                if l[:1] in "+-" and l[:3] not in ("+++", "---")]
        adds = sum(1 for l in diff if l.startswith("+"))
        if detail(rel):
            print("\n  == %s: +%d / -%d lines" % (rel, adds, len(diff) - adds))
            for l in diff[:MAX_LINES]:
                print("    " + l[0] + " " + describe(l[1:]))
            if len(diff) > MAX_LINES:
                print("    ... %d more" % (len(diff) - MAX_LINES))
        else:
            quiet.append("%s (+%d/-%d)" % (rel, adds, len(diff) - adds))
        # Move the copy forward per file only after printing it.
        write_snap(snap_game, rel, text)
    for rel in sorted(old - set(files)):
        changed += 1
        print("\n  == %s: guide file REMOVED" % rel)
        os.remove(snap_path(snap_game, rel))
    if quiet:
        print("\n  other expansions, counts only (%d files): %s" % (len(quiet), "; ".join(quiet[:15])
                                                                  + (" …" if len(quiet) > 15 else "")))
    if not changed:
        print("  no guide file changed.")
    io.open(vfile, "w", encoding="utf-8").write(ver)
    return changed


def selftest():
    """Positive control: copy the Forever guides to a temp folder, baseline it, edit one line, run again: the edit
    must show up with its npc id, and a file with no edit must not. Cleans up after itself."""
    base, sub, tocname, _ = GAMES["forever"]
    src = os.path.join(base, sub)
    if not os.path.isdir(src):
        print("selftest: Forever Zygor not installed — cannot prove anything")
        return 1
    tmp = os.path.join(SNAP_ROOT, "_selftest_src")
    shutil.rmtree(tmp, ignore_errors=True)
    shutil.rmtree(os.path.join(SNAP_ROOT, "_selftest"), ignore_errors=True)
    shutil.copytree(src, os.path.join(tmp, sub))
    shutil.copy2(os.path.join(base, tocname), os.path.join(tmp, tocname))
    buf = io.StringIO()
    real = sys.stdout
    try:
        sys.stdout = buf
        watch("selftest", tmp, sub, tocname, lambda rel: True, snap_game="_selftest")
        target = sorted(guide_files(tmp, sub).items())[0][1]
        with io.open(target, "a", encoding="utf-8") as fh:
            fh.write("\ntalk Zzz Fake Npc##9999999\n")
        watch("selftest", tmp, sub, tocname, lambda rel: True, snap_game="_selftest")
    finally:
        sys.stdout = real
        shutil.rmtree(tmp, ignore_errors=True)
        shutil.rmtree(os.path.join(SNAP_ROOT, "_selftest"), ignore_errors=True)
    out = buf.getvalue()
    ok = "npc 9999999" in out and out.count("lines\n") + out.count("lines\r\n") == 1
    print(out.strip().splitlines()[-1] if out.strip() else "(no output)")
    print("selftest: the fake edit was %s, and exactly one file was reported: %s" % (
        "seen" if "npc 9999999" in out else "NOT seen", "OK" if ok else "FAILED"))
    return 0 if ok else 1


def main():
    sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
    if "--selftest" in sys.argv:
        return selftest()
    for game, (base, sub, tocname, detail) in GAMES.items():
        watch(game, base, sub, tocname, detail)
        print()
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
