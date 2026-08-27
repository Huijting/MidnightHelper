# -*- coding: utf-8 -*-
"""Waar vergelijken wij een waarde die SECRET kan zijn?

CastBreaker 2.1.0 gaf Rob op 27 aug 145 fouten van deze vorm:

    attempt to compare local 'matches' (a secret boolean value, ...)
    ok, matches = pcall(UnitIsUnit, ...)   -- pcall slaagt
    if matches then                        -- en HIER gooit hij

Dezelfde fout maakte ik die ochtend in /mh glow met IsMouseEnabled. De pcall vangt
niets: het aanroepen mág, het VERGELIJKEN niet. CLAUDE.md schrijft daarom een
issecretvalue()-guard voor.

Dit zoekt Unit*-aanroepen die rechtstreeks in een voorwaarde staan. Het is een grove
zeef: onze eigen helpers (Ask, ReadsTrue, Secret) doen het goed en worden hier ook
opgesomd, zodat zichtbaar is wat afgedekt is en wat niet.
"""
import io
import os
import re
import sys

ROOT = r"E:\World of Warcraft\_retail_\Interface\AddOns\MidnightHelper"
sys.stdout.reconfigure(encoding="utf-8")

SKIP = (os.sep + "tools" + os.sep, os.sep + "docs" + os.sep, os.sep + ".git" + os.sep,
        os.sep + "Libs" + os.sep, os.sep + ".baseline")

# Unit-functies waarvan 12.1 een secret kan teruggeven.
RISKY = ("UnitIsUnit", "UnitExists", "UnitGroupRolesAssigned", "UnitClass", "UnitName",
         "UnitIsDead", "UnitIsDeadOrGhost", "UnitIsPlayer", "UnitAffectingCombat",
         "UnitIsFriend", "UnitIsEnemy", "UnitCanAttack", "UnitInRange", "UnitIsConnected")

# Direct in een voorwaarde: `if UnitX(...)`, `and UnitX(...)`, `not UnitX(...)`, `== `
COND = re.compile(r"\b(?:if|elseif|while|and|or|not)\s+\(?\s*(" + "|".join(RISKY) + r")\s*\(")

# Onze eigen guards. Een bestand dat deze gebruikt heeft er over nagedacht.
GUARD = re.compile(r"issecretvalue|\bAsk\(|\bReadsTrue\(|\bSecret\(")

rows = []
for base, _dirs, files in os.walk(ROOT):
    if any(s in base + os.sep for s in SKIP):
        continue
    for fn in sorted(files):
        if not fn.endswith(".lua"):
            continue
        p = os.path.join(base, fn)
        with io.open(p, "r", encoding="utf-8", errors="replace") as fh:
            lines = fh.readlines()
        txt = "".join(lines)
        hits = []
        for i, line in enumerate(lines, 1):
            s = line.strip()
            if s.startswith("--"):
                continue
            m = COND.search(line)
            if m:
                hits.append((i, m.group(1), s[:96]))
        if hits:
            rows.append({
                "file": os.path.relpath(p, ROOT).replace("\\", "/"),
                "hits": hits,
                "guarded": bool(GUARD.search(txt)),
            })

total = sum(len(r["hits"]) for r in rows)
print("Unit*-aanroepen die rechtstreeks in een voorwaarde staan: %d, in %d bestanden\n"
      % (total, len(rows)))

unguarded = [r for r in rows if not r["guarded"]]
print("=== bestanden ZONDER enige guard (%d) ===" % len(unguarded))
for r in unguarded:
    print("\n  %s  (%d)" % (r["file"], len(r["hits"])))
    for ln, fnname, src in r["hits"][:6]:
        print("     %5d  %-24s %s" % (ln, fnname, src))

print("\n=== bestanden die WEL guards gebruiken (%d) ==="
      % (len(rows) - len(unguarded)))
for r in rows:
    if r["guarded"]:
        print("  %-46s %d treffer(s)" % (r["file"], len(r["hits"])))

print("\n⚠️ Een treffer is GEEN fout. UnitExists geeft in de praktijk zelden een secret,")
print("   en een bestand met guards heeft er meestal over nagedacht. Dit wijst aan waar")
print("   je moet KIJKEN, niet wat er stuk is.")
