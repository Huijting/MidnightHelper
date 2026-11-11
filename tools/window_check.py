# -*- coding: utf-8 -*-
"""C5: every MH window can be resized with Shift+scroll (Rob, 7 Oct 2026: "IK WIL DAT GEWOON ALLE SCHERMEN DIT MOETEN
KUNNEN"; the list as a check: opdracht 7, Rob 11 Nov 2026 "Ja, bouw het").

A named frame on UIParent — CreateFrame("Frame"|"Button", "<Name>", UIParent …) — must be ONE of:
  1. in SCALABLE_WINDOWS (Modules/DialogPopup.lua), picked up by the 2-second sweep;
  2. passed to ns.RegisterMidnightDialogPopup(…) or ns.MakeMidnightWindowScalable(…) within LOOKAHEAD lines after it
     is created, in the same file;
  3. in EXEMPT below, with the reason (not a window, or it has its own Shift+scroll).
Anything else is HARD: a new window that cannot be resized. Fix it with way 1 or 2, or add it to EXEMPT with a reason.

What it does NOT see (said, not hidden): frames without a name, frames not parented to UIParent, frames made through a
helper function. Counted from what it reads; the blind spot is the unnamed ones.
Positive control in the same run: a made-up uncovered window must be caught, and MidnightHelperFpsPanel (way 2) must
count as covered.

Usage:  run window_check     (also part of the lint as [25])
"""
import io
import os
import re
import sys

LOOKAHEAD = 120  # ForeverTrainer registers 99 lines after CreateFrame, LabyrinthSplitsWindow 94 (measured 11 Nov)
CREATE = re.compile(r'CreateFrame\(\s*"(?:Frame|Button)"\s*,\s*"([A-Za-z_][A-Za-z0-9_]*)"\s*,\s*UIParent')
REGISTER = re.compile(r'(?:RegisterMidnightDialogPopup|MakeMidnightWindowScalable)\(')
LIST_BLOCK = re.compile(r'local SCALABLE_WINDOWS = \{(.*?)\n\}', re.S)

# name -> reason. Keep the reason honest: "own Shift+scroll" only when the file really has it.
EXEMPT = {
    # Own Shift+scroll (an OnMouseWheel + IsShiftKeyDown script in the file; measured 11 Nov 2026).
    "MidnightHelperMainUI": "main window: own Shift+scroll (UI.lua)",
    "MidnightHelperConsumableBoard": "own Shift+scroll (ConsumableReadyBoard.lua)",
    "MidnightHelperDelveCoach": "own Shift+scroll (DelveCoach.lua)",
    "MidnightHelperBossWindow": "own Shift+scroll (DungeonBossWindow.lua)",
    "MidnightHelperMissingBuff": "missing-buff icon: own Shift+scroll (MissingBuff.lua)",
    "MidnightHelperOpenables": "openables icon: own Shift+scroll (Openables.lua)",
    "MidnightHelperTreasureToast": "own Shift+scroll (Achievements.lua:585)",
    "MidnightHelperCombatSafety": "own Shift+scroll (CombatSafety.lua:240)",
    "MidnightHelperCombatSafetyBars": "own Shift+scroll (CombatSafety.lua:375)",
    "MidnightHelperPartyTargets": "own size: a resize grip (PartyTargets.lua:1146 SetResizable / StartSizing)",
    # Not a window: does not take the mouse, or is a secure/protected frame, a menu, a test pad or no frame to see.
    "MidnightHelperEventFrame": "event frame, nothing to see",
    "MidnightHelperRolesetTest": "debug probe (ApiProbe.lua), not for players",
    "MidnightHelperAlert": "alert text, does not take the mouse",
    "MidnightHelperDurabilityAlert": "alert, EnableMouse(false)",
    "MidnightHelperRitualAlert": "alert text, does not take the mouse",
    "MidnightHelperRestHint": "Forever 'Low mana: drink first' line, does not take the mouse",
    "MidnightHelperToolGuardNote": "Forever note line, does not take the mouse",
    "MidnightHelperToast": "toast; its size comes from its own scale (MidnightToast.lua:673)",
    "MidnightHelperFavPinMenu": "dropdown menu",
    "MidnightHelperDelveShareMenu": "dropdown menu",
    "MidnightHelperRaidBuffCast": "SecureActionButton: cannot be rescaled in combat, sits on the board",
    "MidnightHelperMissingBuffCast": "SecureActionButton click layer; follows the icon's scale (MissingBuff.lua SyncSecurePos)",
    "MidnightHelperMarkBar": "secure marker bar (FastMark.lua)",
    "MidnightHelperKeyBlockBar1": "secure action bar (SecureHandlerStateTemplate)",
    "MidnightHelperTourOverlay": "full-screen overlay during the guided tour",
    "MidnightHelperMouseDetect": "mouse test pad: the wheel is what it measures, so Shift+scroll cannot be used there",
    "MidnightHelperNativeArrow": "the route arrow, not a window (drag only; no size setting yet)",
}


def module_files(root):
    out = [os.path.join(root, "Core.lua"), os.path.join(root, "UI.lua")]
    for dp, _, fs in os.walk(os.path.join(root, "Modules")):
        out += [os.path.join(dp, f) for f in fs if f.endswith(".lua")]
    return [p for p in out if os.path.isfile(p)]


def scalable_list(root):
    with open(os.path.join(root, "Modules", "DialogPopup.lua"), encoding="utf-8", errors="replace") as fh:
        m = LIST_BLOCK.search(fh.read())
    return set(re.findall(r'"([A-Za-z_][A-Za-z0-9_]*)"', m.group(1))) if m else set()


def windows_in(src, rel):
    """[(name, rel, line, registered_nearby)] for one file's text."""
    lines = src.splitlines()
    out = []
    for n, line in enumerate(lines, 1):
        if line.lstrip().startswith("--"):
            continue
        for m in CREATE.finditer(line):
            near = "\n".join(lines[n - 1:n - 1 + LOOKAHEAD])
            out.append((m.group(1), rel, n, bool(REGISTER.search(near))))
    return out


def classify(wins, listed):
    bad, covered, exempt = [], [], []
    for name, rel, n, reg in wins:
        if name in listed or reg:
            covered.append(name)
        elif name in EXEMPT:
            exempt.append(name)
        else:
            bad.append((name, rel, n))
    return bad, covered, exempt


def run(root):
    listed = scalable_list(root)
    wins = []
    quoted = set()  # every "Name" string in the code: a frame named through a variable still counts as existing
    for p in module_files(root):
        rel = os.path.relpath(p, root).replace("\\", "/")
        with open(p, encoding="utf-8", errors="replace") as fh:
            src = fh.read()
        wins += windows_in(src, rel)
        if not rel.endswith("DialogPopup.lua"):
            quoted |= set(re.findall(r'"([A-Za-z_][A-Za-z0-9_]*)"', src))
    bad, covered, exempt = classify(wins, listed)
    names = {w[0] for w in wins} | quoted
    stale = sorted(n for n in listed if n not in names)
    stale_exempt = sorted(n for n in EXEMPT if n not in names)
    # Positive control: an uncovered made-up window is caught; FpsPanel (registered right after creation) is covered.
    fake = windows_in('local f = CreateFrame("Frame", "MidnightHelperZzzFake", UIParent)\n', "control")
    fb, _, _ = classify(fake, listed)
    fps = [w for w in wins if w[0] == "MidnightHelperFpsPanel"]
    control_ok = len(fb) == 1 and bool(fps) and (fps[0][3] or fps[0][0] in listed)
    lines = ["%d named frames on UIParent: %d resizable, %d exempt with a reason, %d HARD" % (
        len(wins), len(covered), len(exempt), len(bad))]
    for name, rel, n in bad:
        lines.append("HARD  %s  %s:%d — cannot be resized: add it to SCALABLE_WINDOWS, register it, or exempt it"
                     % (name, rel, n))
    for n in stale:
        lines.append("SOFT  %s is in SCALABLE_WINDOWS but no file creates it (renamed or gone?)" % n)
    for n in stale_exempt:
        lines.append("SOFT  %s is in EXEMPT (tools/window_check.py) but no file creates it" % n)
    return lines, len(bad), len(stale) + len(stale_exempt), control_ok


def main():
    sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
    root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    lines, hard, soft, ok = run(root)
    for line in lines:
        print(line)
    print("positive control:", "OK" if ok else "FAILED")
    return 1 if hard or not ok else 0


if __name__ == "__main__":
    sys.exit(main())
