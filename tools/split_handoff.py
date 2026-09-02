#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""split_handoff.py -- move the history out of docs/NEXT_SESSION.md, keep the live part.

WHY
    The handoff had grown to ~4400 lines. Only the top ~226 are live; the rest is a diary
    going back to July. That matters because this is the file a session reads to learn the
    status -- and the longer it gets, the likelier it is that something two thousand lines
    down gets quoted as current. That has already happened twice (31 aug: seven professions
    reported unchecked that Rob had measured that morning; 2 sep: A Toxic Tour still listed
    as an open question after it was answered).

🔴 THIS IS NOT A DELETION, AND THE DANGER IS NOT LOSING TEXT -- IT IS BURYING AN OPEN ITEM.
    Below the cut there are sections still marked OPEN, MORGEN BOUWEN, ROB VRAAGT and
    "Wacht op Rob". A split by date alone would file those away as history. So every section
    is classified, and the ones that still read as open are listed BY NAME in the live file
    with a pointer into the archive. Nothing disappears; the open ones stay visible.

USAGE
    python "<repo>/tools/_probe.py" run split_handoff          # dry run, prints the plan
    python "<repo>/tools/_probe.py" run split_handoff --write  # actually split
"""

import io
import os
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
LIVE = os.path.join(ROOT, "docs", "NEXT_SESSION.md")
ARCHIVE = os.path.join(ROOT, "docs", "NEXT_SESSION_ARCHIVE.md")

# The first history heading. Everything from here down moves.
CUT_HEADING = "## ✅ 31 aug — GEMETEN: geen enkele addon adviseert"

# A heading that opens with one of these is finished, whatever else it says.
RESOLVED_PREFIX = ("✅", "❌", "~~")
# Otherwise these mark something still wanting attention.
OPEN_WORDS = ("OPEN", "MORGEN", "VOLGENDE", "Wacht", "MOET", "ROB VRAAGT", "VRAAGT",
              "NIET GEREPAREERD", "niet gerepareerd", "ONGEVERIFIEERD", "BOUWPLAN",
              "VERZOEK", "grootste openstaande")


# 🔴 Overruled by hand, because the heading lies about these. Each one is a section whose
# title still says OPEN or MORGEN while the work is demonstrably finished -- and shipping
# them in the "still open" list would make that list noise, which is how a real open item
# gets ignored. Fragment matched against the heading.
KNOWN_DONE = {
    # Translating is finished: seven languages, zero drift, all placeholders resolved.
    "de Duitse en Franse delve-tips zijn machinaal vertaald",
    # The right-click dispel was fixed on 28 aug -- it had to cast by NAME.
    "ROB-GOEDGEKEURD, VOLGENDE BOUWKLUS: dispel/purge",
    # A "tomorrow" note from 5 July, and the section below it is struck through.
    "MORGEN — HIER VERDER (Rob ging slapen",
}


def classify(heading):
    """Open or resolved? The heading is the only evidence used, on purpose -- a rule you
    can check by eye beats one that reads paragraphs and is wrong in ways nobody spots.

    ⚠️ Deliberately OVER-inclusive on the open side. A stale entry in the index costs a
    reader ten seconds; a real open item filed away as history costs whatever it was for.
    The KNOWN_DONE set above is the hand-correction where the heading is simply wrong.
    """
    body = heading[3:].strip()
    for frag in KNOWN_DONE:
        if frag in body:
            return "resolved"
    # A struck-through heading is finished wherever the ~~ sits, not only at the front.
    if "~~" in body:
        return "resolved"
    for p in RESOLVED_PREFIX:
        if body.startswith(p):
            return "resolved"
    for w in OPEN_WORDS:
        if w in body:
            return "open"
    return "resolved"


def main():
    write = "--write" in sys.argv

    raw = io.open(LIVE, "r", encoding="utf-8", newline="").read()
    lines = raw.splitlines(True)  # keep the line endings exactly as they are

    cut = None
    for i, line in enumerate(lines):
        if line.startswith(CUT_HEADING):
            cut = i
            break
    if cut is None:
        sys.exit("cut heading not found -- has the file changed shape?\n  %s" % CUT_HEADING)

    head, tail = lines[:cut], lines[cut:]

    # 🔴 The positive control. A split that loses a line must fail loudly, not quietly.
    assert len(head) + len(tail) == len(lines), "line count does not add up"

    sections = []
    for i, line in enumerate(tail):
        if line.startswith("## "):
            sections.append((i, line.rstrip("\r\n"), classify(line)))

    still_open = [(n, h) for _, h, k in sections for n, h in [(0, h)] if k == "open"]

    print("live now : %d lines" % len(lines))
    print("keeping  : %d lines (through the current open list)" % len(head))
    print("archiving: %d lines, %d sections" % (len(tail), len(sections)))
    print("  of which still reading as OPEN: %d" % len(still_open))
    for _, h in still_open:
        print("   OPEN  %s" % h[3:].strip()[:96])
    if not write:
        print("\n(dry run -- pass --write to actually split)")
        return 0

    io.open(ARCHIVE + ".tmp", "w", encoding="utf-8", newline="").write(
        "# NEXT_SESSION archive\n\n"
        "History split out of `docs/NEXT_SESSION.md` on 2 Sep 2026, when it had grown to "
        "%d lines and only the top %d were live.\n\n"
        "⚠️ Nothing was deleted. Sections here that still read as open are listed by "
        "name at the bottom of the live file, so an open item cannot be lost by being old.\n\n"
        "---\n\n" % (len(lines), len(head))
        + "".join(tail)
    )
    os.replace(ARCHIVE + ".tmp", ARCHIVE)

    index = ["\n\n## \U0001f4cc Ouder, maar nog niet af — staat in `docs/NEXT_SESSION_ARCHIVE.md`\n",
             "\n",
             "De historie is op 2 sep afgesplitst. Deze secties lazen daar nog als OPEN, dus ze staan\n",
             "hier bij naam — een openstaand punt mag niet verdwijnen door oud te zijn.\n",
             "\n"]
    for _, h in still_open:
        index.append("- %s\n" % h[3:].strip())
    index.append("\n\U0001f4cc Al het afgeronde werk staat in het archief; daar wordt niets meer aan\n")
    index.append("toegevoegd. Nieuwe regels horen bovenaan dit bestand.\n")

    io.open(LIVE + ".tmp", "w", encoding="utf-8", newline="").write(
        "".join(head) + "".join(index)
    )
    os.replace(LIVE + ".tmp", LIVE)

    print("\nwrote docs/NEXT_SESSION.md      (%d lines + index)" % len(head))
    print("wrote docs/NEXT_SESSION_ARCHIVE.md (%d lines)" % len(tail))
    return 0


if __name__ == "__main__":
    sys.exit(main())
