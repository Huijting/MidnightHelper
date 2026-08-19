#!/usr/bin/env python3
"""Replace noteEn with a STABLE noteKey in ConsumablesWowheadData.lua.

⚠️ THIS SCRIPT USED TO DERIVE THE KEYS BY SORTING THE NOTE TEXTS AND NUMBERING THEM.
That made every key a function of every other note's wording: reword one note, add one, or
drop one, and all the keys after it shift. Nothing errors — the Lua still loads, the panel
still renders — but the fifteen CONS_NOTE_* strings in Locales/ConsumablesNotes.lua, which
exist in seven languages, quietly reattach to the wrong notes. A German healer gets told to
use the tank flask, confidently, in correct German.

Found by the stale-advice audit on 19 Aug 2026, while the consumables data was overdue a
refresh — which is to say the landmine was armed and the next person to do the obvious
right thing would have stepped on it.

The mapping now lives in data/consumables_note_keys.json and is APPEND-ONLY:

  * a note already in the mapping keeps its key, whatever its neighbours do;
  * a note that is not in the mapping gets the next free number and is reported;
  * a mapped note that no longer appears in the file is reported too, because it usually
    means someone edited the text in place — which is the exact move that breaks the
    translations. Rewording a note needs a NEW key and a retired old one.

Writes atomically. Modules/ is the running game folder (the repo IS the live AddOns
directory), and a plain write truncates first and fills after; that window is what broke
Locales/enUS.lua on 22 July 2026 and rendered raw keys in a player's Great Vault popup.
"""
import io
import json
import os
import re
import sys

# Same as lint_addon.py: a Windows console defaults to cp1252 and mangles anything this
# prints that is not plain ASCII — including the warning marker that makes the "you edited
# a note in place" message stand out.
for _stream in (sys.stdout, sys.stderr):
    if hasattr(_stream, "reconfigure"):
        _stream.reconfigure(encoding="utf-8", errors="replace")

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
LUA = os.path.join(ROOT, "Modules", "ConsumablesWowheadData.lua")
MAP = os.path.join(ROOT, "data", "consumables_note_keys.json")


def load_mapping():
    with io.open(MAP, "r", encoding="utf-8") as fh:
        return json.load(fh).get("keys", {})


def next_free(mapping):
    used = set()
    for key in mapping.values():
        m = re.match(r"CONS_NOTE_(\d+)$", key)
        if m:
            used.add(int(m.group(1)))
    n = 1
    while n in used:
        n += 1
    return n


def main():
    mapping = load_mapping()
    with io.open(LUA, "r", encoding="utf-8", newline="") as fh:
        text = fh.read()

    found = sorted(set(re.findall(r'noteEn = "([^"]+)"', text)))
    if not found:
        print("No noteEn entries — already keyed, nothing to do.")
        return 0

    added = []
    for note in found:
        if note not in mapping:
            key = "CONS_NOTE_%02d" % next_free(mapping)
            mapping[note] = key
            added.append((key, note))

    missing = [n for n in mapping if n not in found]

    for note in found:
        text = text.replace('noteEn = "%s"' % note, 'noteKey = "%s"' % mapping[note])

    tmp = LUA + ".tmp"
    with io.open(tmp, "w", encoding="utf-8", newline="") as fh:
        fh.write(text)
    os.replace(tmp, LUA)

    if added:
        out = {"_comment": json.load(io.open(MAP, "r", encoding="utf-8")).get("_comment", ""),
               "keys": mapping}
        tmp = MAP + ".tmp"
        with io.open(tmp, "w", encoding="utf-8", newline="\n") as fh:
            fh.write(json.dumps(out, indent=2, ensure_ascii=False) + "\n")
        os.replace(tmp, MAP)
        print("NEW keys assigned — add these to Locales/ConsumablesNotes.lua in 7 languages:")
        for key, note in added:
            print("   %s = %s" % (key, note))

    if missing:
        print("\n⚠️  MAPPED NOTES NOT FOUND IN THE FILE (%d):" % len(missing))
        for note in missing:
            print("   %s  <- %s" % (mapping[note], note[:60]))
        print("   If you reworded one of these, give it a NEW key instead of editing the")
        print("   text in place — the old key is still referenced in seven languages.")

    print("\nKeyed %d notes (%d new)." % (len(found), len(added)))
    return 0


if __name__ == "__main__":
    sys.exit(main())
