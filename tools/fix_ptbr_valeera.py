#!/usr/bin/env python3
"""SUPERSEDED. Use tools/rename_in_locale.py.

This did one rename in one language: Valeera -> Valira in ptBR, on 31 Aug 2026. It was
generalised the same day, when Rob asked to settle the other four languages, and the answer
turned out to be that **deDE, frFR, esES and itIT all keep Valeera** -- measured in DB2
`Creature` @ 12.1.0.69497, where the Valeera filter returns the same 14 rows in every one of
them. ptBR is the only locale that differs.

🔴 Kept as a stop rather than deleted, because a script whose NAME says "fix valeera" invites a
future session to run it and assume the ptBR answer generalises. It does not. One language
localising a name says nothing about another.

    python "<repo>/tools/_probe.py" run rename_in_locale --lang <code> --from X --to Y [--write]
"""
import sys

print(__doc__)
sys.exit("refusing to run: use rename_in_locale.py with the language you actually measured")
