# -*- coding: utf-8 -*-
"""C3: does the release text name things that exist? (plan deel 2; Rob 10 Nov 2026: "Ja, stap 2")

Checks RELEASE_NOTES.md (what CurseForge shows) and docs/SITE_SEIN.md (what the site chat copies):
  HARD  a `/mh <word>` whose first word nothing in the code routes;
  HARD  a Locales key on a SITE_SEIN "Knoplabels:" line that no Locales file defines;
  SOFT  an *italic* label in RELEASE_NOTES.md that matches no Locales text ("nakijken": italics are also emphasis).
Every italic label that DOES match is printed with the key and file it matched, every run.

🔴 WHY THE TABLE AND NOT ONLY A YES/NO — measured 10 Nov 2026 on the fault that started this check.
4.15.0 (3 Nov) wrote "*Skip* skips the rare the arrow points at." There is no Skip button on that route; skipping
is a key binding or `/mh skip` (site chat found it). But "Skip" DOES exist as Locales text: TOUR_CM_SKIP, the Skip
button of the welcome tour (Locales/StartHere.lua). A pure "does this word exist" check passes that line. It cannot
know which window a word belongs to. What it can do is say where the word comes from: "Skip -> TOUR_CM_SKIP
(StartHere.lua)" under a Coiled Isle rare section is visibly wrong to a human. So the check is exact for commands and
keys, and for prose labels it shows its evidence instead of pretending to judge it.

Usage:  run release_text_check                 -> the two real files
        run release_text_check --file <path>   -> any release text (e.g. docs/CURSEFORGE_4.15.0.md)
        run release_text_check --selftest      -> the proofs (a fake command, key and label must be caught;
                                                  the 5.1.0 /mh selftest lines must be caught as dev-only, lint [27])
"""
import glob
import io
import os
import re
import sys

ITALIC = re.compile(r'(?<![*\w])\*([^*\n]+?)\*(?![*\w])')
BOLD = re.compile(r'\*\*([^*\n]+?)\*\*')
CMD = re.compile(r'/mh\s+([a-z][a-z0-9_]*)')
KEY = re.compile(r'\b([A-Z][A-Z0-9]*_[A-Z0-9_]+)\b')
LOCALE_LINE = re.compile(r'^\s*\[?"?([A-Z][A-Z0-9_]+)"?\]?\s*=\s*"((?:[^"\\]|\\.)*)"')


def _norm(s):
    s = re.sub(r"\|c[0-9a-fA-F]{8}|\|r", "", s)
    return s.strip().lower().rstrip(":.…").strip()


# ⚠️ locale_index(root) and routed_words(root) are imported by the SITE's own check (midnighthelper-site,
# tools/check_addon_words.py, since 11 Nov 2026) on a git archive of a tag. Keep their names, arguments and return shape;
# a rename or a new signature must be announced in docs/SITE_SEIN.md in the same commit.
def locale_index(root):
    """value(normalised) -> [(key, file)], and the set of all keys."""
    by_value, keys = {}, set()
    for p in sorted(glob.glob(os.path.join(root, "Locales", "*.lua"))):
        rel = os.path.relpath(p, root).replace("\\", "/")
        with open(p, encoding="utf-8", errors="replace") as fh:
            for line in fh:
                m = LOCALE_LINE.match(line)
                if not m:
                    continue
                keys.add(m.group(1))
                v = _norm(m.group(2))
                if v:
                    lst = by_value.setdefault(v, [])
                    if (m.group(1), rel) not in lst:
                        lst.append((m.group(1), rel))
    return by_value, keys


def routed_words(root):
    """First words of /mh commands something answers to: Core.lua, every module, and the CommandList."""
    paths = [os.path.join(root, "Core.lua")]
    for d, _, fs in os.walk(os.path.join(root, "Modules")):
        paths += [os.path.join(d, f) for f in fs if f.endswith(".lua")]
    words = set()
    pats = (r'msg(?::lower\(\))?\s*==\s*"([a-z0-9_]+)', r'line\s*==\s*"([a-z0-9_]+)',
            r'cmd\s*==\s*"([a-z0-9_]+)', r':match\(\s*"\^([a-z0-9_]+)', r'cmd\s*=\s*"/mh\s+([a-z0-9_]+)')
    for p in paths:
        if not os.path.isfile(p):
            continue
        with open(p, encoding="utf-8", errors="replace") as fh:
            src = fh.read()
        for pat in pats:
            words.update(re.findall(pat, src))
    return words


def check_text(text, name, by_value, keys, routed, site_format=False):
    hard, soft, labels = [], [], []
    for n, line in enumerate(text.splitlines(), 1):
        if site_format:
            low = line.lower()
            if low.startswith("- commando"):
                for w in CMD.findall(line):
                    if w not in routed:
                        hard.append("%s:%d  /mh %s — nothing in the code routes this command" % (name, n, w))
            elif low.startswith("- knoplabels"):
                for k in KEY.findall(line):
                    if k not in keys:
                        hard.append("%s:%d  %s — no Locales file defines this key" % (name, n, k))
            continue
        for w in CMD.findall(line):
            if w not in routed:
                hard.append("%s:%d  /mh %s — nothing in the code routes this command" % (name, n, w))
        for lab in ITALIC.findall(BOLD.sub("", line)):
            hits = by_value.get(_norm(lab))
            if hits:
                labels.append((n, lab, hits))
            else:
                soft.append("%s:%d  *%s* — matches no Locales text (nakijken: label or just emphasis?)" % (name, n, lab))
    return hard, soft, labels


def run(root, files=None):
    by_value, keys = locale_index(root)
    routed = routed_words(root)
    if files is None:
        files = [("RELEASE_NOTES.md", False), ("docs/SITE_SEIN.md", True)]
    hard, soft, labels = [], [], []
    for rel, site in files:
        p = os.path.join(root, rel)
        if not os.path.isfile(p):
            soft.append("%s — file missing, not checked" % rel)
            continue
        with open(p, encoding="utf-8", errors="replace") as fh:
            h, s, l = check_text(fh.read(), rel, by_value, keys, routed, site)
        hard += h
        soft += s
        labels += [(rel,) + x for x in l]
    # Positive control in the SAME run: a command, a key and a label that cannot exist must be caught.
    ph, ps, _ = check_text("- Commando's: /mh zzznotacommand\n- Knoplabels: ZZZ_NOT_A_KEY\n", "control",
                           by_value, keys, routed, True)
    ph2, ps2, _ = check_text("Press *Zzz not a label* or `/mh zzznotacommand`.", "control",
                             by_value, keys, routed, False)
    control_ok = len(ph) == 2 and len(ph2) == 1 and len(ps2) == 1
    info = {"routed": len(routed), "keys": len(keys), "values": len(by_value), "control_ok": control_ok}
    return hard, soft, labels, info


# ── Commands only WE use, never in player text (lint [27]) ──────────────────────────────────────────────────────────
# Rob, 11 Nov 2026, after 5.1.0 announced /mh selftest: "je hebt bij de change log ook genoemd dat we dingen kunnen
# testen die alleen wij doen, dat is niet handig, volgende keer niet doen". Rob, 12 Nov 2026 (via the sparring chat):
# "Ja, bouw dat" -> a lint error when such a command is in the release text. The build chat keeps THIS list.
# ⚠️ Off switches (`/mh pickup off`, `/mh geartip off`) and diagnostics we ask players to run (`/mh report`,
# `/mh arrow`) ARE for players: never put them here. Only probes and measurements whose output only we can read.
# Every name must be routed (first word of a /mh command); a stale name is printed as SOFT.
DEV_ONLY = (
    "selftest", "partytest",
    "auradump", "eventspy", "events", "sniff", "spellbook", "uinames", "api12", "debug",
    "dispelprobe", "kickprobe", "mapprobe",
    "tierscan", "rarescan", "questscan", "delvescan", "crestscan", "curscan", "questsnap",
    "chunklog", "hexmasks", "curiodebug", "resetdebug", "ritualspy", "profids",
    "raretest", "readytest", "shardtest",
)

# The 5.1.0 lines that started this (commit eb3e22a removed them): the proof that the check catches the real fault.
DEV_PROOF = (
    "- **`/mh selftest`:** checks that every spell, item and map number Midnight Helper uses exists in your game.\n"
    "Both games: /mh selftest checks that every spell, item and map number MH uses exists in your game.\n"
)
# The counter-proof: player commands and off switches from the same release must NOT fire.
DEV_COUNTER = "`/mh pickup off` turns it off. `/mh geartip off`. Tell us with `/mh report`. Arrows (`/mh trainer <x>`)."


def _toc_version(root):
    with open(os.path.join(root, "MidnightHelper.toc"), encoding="utf-8", errors="replace") as fh:
        m = re.search(r"^##\s*Version:\s*(\S+)", fh.read(), re.M)
    return m.group(1) if m else None


def player_texts(root):
    """[(name, text)] of what players read for the CURRENT version: RELEASE_NOTES.md, docs/CURSEFORGE_<ver>.md and the
    in-game CHANGELOG_<ver>_* lines in enUS.lua. Not CHANGELOG.md or the handoff: there a dev command may stand."""
    ver = _toc_version(root)
    out, missing = [], []
    for rel in ("RELEASE_NOTES.md", "docs/CURSEFORGE_%s.md" % ver):
        p = os.path.join(root, rel)
        if os.path.isfile(p):
            with open(p, encoding="utf-8", errors="replace") as fh:
                out.append((rel, fh.read()))
        else:
            missing.append(rel)
    prefix = "CHANGELOG_%s_" % (ver or "").replace(".", "")
    lines = []
    with open(os.path.join(root, "Locales", "enUS.lua"), encoding="utf-8", errors="replace") as fh:
        for line in fh:
            m = LOCALE_LINE.match(line)
            if m and m.group(1).startswith(prefix):
                lines.append("%s = %s" % (m.group(1), m.group(2)))
    out.append(("Locales/enUS.lua %s*" % prefix, "\n".join(lines)))
    return out, missing, ver, len(lines)


def dev_only_hits(text, name):
    hits = []
    for n, line in enumerate(text.splitlines(), 1):
        for w in CMD.findall(line):
            if w in DEV_ONLY:
                hits.append("%s:%d  /mh %s — a command only we use, in text players read" % (name, n, w))
    return hits


def dev_only_check(root):
    texts, missing, ver, n_changelog = player_texts(root)
    hard = []
    for name, text in texts:
        hard += dev_only_hits(text, name)
    proof = dev_only_hits(DEV_PROOF, "proof")
    counter = dev_only_hits(DEV_COUNTER, "counter")
    routed = routed_words(root)
    stale = [w for w in DEV_ONLY if w not in routed]
    info = {"version": ver, "files": [n for n, _ in texts], "missing": missing, "changelog_lines": n_changelog,
            "proof": len(proof), "counter": len(counter), "control_ok": len(proof) == 2 and not counter,
            "stale": stale}
    return hard, info


def selftest(root):
    """The proofs asked for in the assignment, printed so a human can see what the check can and cannot do."""
    ok = True
    _, dinfo = dev_only_check(root)
    print("[27] proof (the two 5.1.0 /mh selftest lines): %d of 2 caught; counter-proof (pickup off, geartip off, "
          "report, trainer): %d fired -> %s" % (dinfo["proof"], dinfo["counter"], "OK" if dinfo["control_ok"] else "FAILED"))
    ok &= dinfo["control_ok"]
    _, _, labels, info = run(root, [("docs/CURSEFORGE_4.15.0.md", False)])
    print("positive control (fake command, key, label all caught):", "OK" if info["control_ok"] else "FAILED")
    ok &= info["control_ok"]
    skip = [x for x in labels if x[2] == "Skip"]
    if skip:
        rel, n, lab, hits = skip[0]
        where = ", ".join("%s (%s)" % h for h in hits)
        print("3 Nov fault, %s:%d  *Skip* -> %s" % (rel, n, where))
        print("  -> the table shows the word belongs to the welcome tour, not the rare route: visible to a reader.")
        print("  -> NOT caught as an error: an existence check cannot know which window a word belongs to.")
        ok &= all(k.startswith("TOUR_") for k, _ in hits)
    else:
        print("3 Nov proof: *Skip* not found in docs/CURSEFORGE_4.15.0.md — the proof did not run")
        ok = False
    return ok


def main():
    sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
    root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    args = sys.argv[1:]
    if "--selftest" in args:
        return 0 if selftest(root) else 1
    files = None
    if "--file" in args:
        f = args[args.index("--file") + 1]
        files = [(f, f.replace("\\", "/").endswith("SITE_SEIN.md"))]
    hard, soft, labels, info = run(root, files)
    print("routed command words %d · Locales keys %d · positive control %s"
          % (info["routed"], info["keys"], "OK" if info["control_ok"] else "FAILED"))
    for h in hard:
        print("HARD ", h)
    for s in soft:
        print("SOFT ", s)
    for rel, n, lab, hits in labels:
        print("label %s:%d  *%s* -> %s" % (rel, n, lab, ", ".join("%s (%s)" % h for h in hits[:3])))
    return 1 if hard or not info["control_ok"] else 0


if __name__ == "__main__":
    sys.exit(main())
