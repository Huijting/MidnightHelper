# -*- coding: utf-8 -*-
"""Positieve controle op linter-check [14].

Nul treffers betekent niets als de check ook nul zou geven op een regel die WEL
fout is. Dit voert de echte regel uit op zelfgemaakte regels waarvan we het
antwoord weten -- inclusief de pijl die 62 keer vals alarm gaf.
"""
import re
import sys

sys.stdout.reconfigure(encoding="utf-8")

bad = re.compile("[←-⯿]️"
                 "|[\U0001F000-\U0001FAFF]")

CASES = [
    # (regel, moet-vlaggen, waarom)
    ('\tX = "⚠️ Every character builds their own supply.",', True,
     "de regel die vanmiddag als twee lege blokjes op Robs scherm stond"),
    ('\tX = "Stap 1 → stap 2.",', False,
     "pijl: staat al maanden in Codex en DungeonGuide en rendert prima"),
    ('\tX = "Café crème, naïve über",', False,
     "accenten moeten met rust gelaten worden"),
    ('\tX = "• bullet en em-dash — blijven",', False,
     "typografie die de hele addon gebruikt"),
    ('\tX = "\U0001f525 vuur",', True,
     "astrale emoji"),
    ('\t-- ⚠️ dit is commentaar en bereikt nooit een scherm', False,
     "commentaar is toegestaan; de check slaat die regels over"),
]

fails = 0
for line, should_flag, why in CASES:
    if line.lstrip().startswith("--"):
        flagged = False
    else:
        m = re.match(r'\s*\[?"?([A-Za-z0-9_]+)"?\]?\s*=\s*"(.*)"\s*,?\s*$', line)
        flagged = bool(m and bad.search(m.group(2)))
    ok = flagged == should_flag
    fails += 0 if ok else 1
    print("%s  vlagt=%-5s verwacht=%-5s  %s"
          % ("OK  " if ok else "FOUT", flagged, should_flag, why))

print("")
if fails:
    print("%d van de %d gevallen fout -- check [14] deugt niet." % (fails, len(CASES)))
else:
    print("Alle %d gevallen goed. De check vangt de echte fout en laat de rest staan."
          % len(CASES))
