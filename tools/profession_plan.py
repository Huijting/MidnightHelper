#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Beroepenoverzicht + plan, printbaar.

    python tools/profession_plan.py

Schrijft PROFESSIONS_PLAN.html naast dit script. Openen, Ctrl+P.

⚠️ De TABEL komt uit ns.db.charCurrencies (SavedVariables), dus die veroudert
zodra Rob iets wijzigt en opnieuw inlogt. Elke rij draagt daarom zijn eigen
leeftijd; een vel dat stilletjes oud is, is erger dan geen vel. Zelfde regel als
tools/keybind_mine.py, en om dezelfde reden.

⚠️ Het ADVIES is geschreven, niet berekend. Welke twee beroepen je verplaatst
hangt af van klassen die de addon niet opslaat en van wat Rob zelf wil. De code
rekent alleen uit wat dubbel is en wat ontbreekt — de conclusie staat als tekst
onderaan, zodat niemand hem voor een meting aanziet.
"""
import datetime
import io
import os
import re
import sys

for _s in (sys.stdout, sys.stderr):
    try:
        _s.reconfigure(encoding="utf-8", errors="replace")
    except (AttributeError, ValueError):
        pass

SV = (r"E:\World of Warcraft\_retail_\WTF\Account\JOEYWHATEVER"
      r"\SavedVariables\MidnightHelper.lua")
OUT = os.path.join(os.path.dirname(os.path.abspath(__file__)),
                   "PROFESSIONS_PLAN.html")

CRAFT = ["Alchemy", "Blacksmithing", "Enchanting", "Engineering",
         "Inscription", "Jewelcrafting", "Leatherworking", "Tailoring"]
GATHER = ["Herbalism", "Mining", "Skinning"]

# De addon bewaart geen klasse per alt. Deze staan hier omdat Rob ze zelf heeft
# bevestigd (25 aug 2026) of omdat ze gemeten zijn via /mh binds. Niets geraden:
# een naam die er niet in staat, blijft leeg op het vel.
KLASSE = {
    "Theexodus": "Paladin (Protection) &mdash; main",  # Rob, 25 aug
    "Purlymixanox": "Druid (Guardian)",   # /mh binds, 25 aug
    "Redisch": "Hunter (Beast Mastery)",  # /mh binds, 25 aug
    "Umbrion": "Priest (Shadow)",         # Rob, 25 aug
    "Earthshammy": "Shaman",              # Rob, 25 aug
    "Iceicebaby": "Mage",                 # savedvars: Iceicebaby-Lightbringer, MAGE
}


def read_chars():
    with io.open(SV, "r", encoding="utf-8", errors="replace") as fh:
        lines = fh.read().split("\n")
    start = next(i for i, l in enumerate(lines) if '["charCurrencies"]' in l)
    depth, end = 0, start
    for i in range(start, len(lines)):
        depth += lines[i].count("{") - lines[i].count("}")
        if depth == 0 and i > start:
            end = i
            break
    out, cur, d = [], None, 0
    for line in lines[start + 1:end]:
        if d == 0 and re.match(r'^\["[^"]+"\] = \{', line):
            cur = {}
            out.append(cur)
            d = 1
            continue
        if cur is None:
            continue
        d += line.count("{") - line.count("}")
        m = re.match(r'^\["([A-Za-z]+)"\] = (.*),$', line.strip())
        if m:
            v = m.group(2).strip()
            if v.startswith('"'):
                v = v[1:-1]
            cur.setdefault(m.group(1), v)
        if d <= 0:
            cur, d = None, 0
    return out


now = datetime.datetime.now()
rows = []
for c in read_chars():
    if not c.get("name"):
        continue
    age = None
    for k in ("at", "ts"):
        v = c.get(k, "")
        if v.isdigit() and int(v) > 1000000000:
            age = (now - datetime.datetime.fromtimestamp(int(v))).days
            break
    lvl = int(c["level"]) if c.get("level", "").isdigit() else None
    profs = c.get("professionsFull") or c.get("professions") or ""
    rows.append({"name": c["name"], "realm": c.get("realm", ""), "level": lvl,
                 "age": age, "profs": [p.strip() for p in profs.split("\u00b7") if p.strip()]})

rows.sort(key=lambda r: (-(r["level"] or 0), r["name"]))
maxrows = [r for r in rows if r["level"] == 90]


def holders(p):
    return [r["name"] for r in maxrows if p in r["profs"]]


def esc(s):
    return (s.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;"))


H = ['<!doctype html><html lang="nl"><head><meta charset="utf-8">',
     '<title>Beroepen &mdash; plan</title>', '''<style>
:root{--ink:#1b1b1f;--muted:#6b6b76;--rule:#d8d8de;--dup:#8a6d1f;--dupbg:#fdf6e3;
      --gap:#8f2f2f;--gapbg:#fbeceb;--ok:#2f6b3f}
*{box-sizing:border-box}
body{margin:0;padding:28px 32px;font:14px/1.5 "Segoe UI",system-ui,sans-serif;color:var(--ink)}
h1{margin:0 0 2px;font-size:22px;letter-spacing:.2px}
.sub{color:var(--muted);font-size:12px;margin-bottom:18px}
section{break-inside:avoid;page-break-inside:avoid;margin:0 0 18px}
h2{font-size:12px;text-transform:uppercase;letter-spacing:.9px;color:var(--muted);
   margin:0 0 6px;padding-bottom:3px;border-bottom:1px solid var(--rule)}
table{width:100%;border-collapse:collapse;font-size:13px}
th{text-align:left;font-size:11px;text-transform:uppercase;letter-spacing:.6px;
   color:var(--muted);font-weight:600;padding:0 8px 4px 0}
td{padding:4px 8px 4px 0;vertical-align:baseline;border-top:1px solid var(--rule)}
td.n{font-weight:600;white-space:nowrap}
td.c{color:var(--muted);white-space:nowrap}
td.a{color:var(--muted);font-size:11px;white-space:nowrap;text-align:right}
tr.dup td{background:var(--dupbg)}
tr.gap td{background:var(--gapbg)}
.tag{font-size:11px;font-weight:600;padding:1px 6px;border-radius:9px;white-space:nowrap}
.t-dup{background:var(--dupbg);color:var(--dup)}
.t-gap{background:var(--gapbg);color:var(--gap)}
.t-ok{color:var(--ok)}
.plan li{margin-bottom:5px}
.note{margin-top:8px;font-size:11px;color:var(--muted);border-top:1px solid var(--rule);
      padding-top:8px}
@media print{body{padding:0}a{color:inherit;text-decoration:none}}
</style></head><body>''']

H.append('<h1>Beroepen &mdash; wat je hebt en wat ik aanraad</h1>')
H.append('<div class="sub">%d characters gelezen uit de client &middot; %d op level 90 '
         '&middot; opgesteld %s</div>'
         % (len(rows), len(maxrows), now.strftime("%d-%m-%Y %H:%M")))

# --- 1. de max-level characters -------------------------------------------
H.append('<section><h2>Level 90 &mdash; hier telt het</h2><table>')
H.append('<tr><th>Character</th><th>Klasse</th><th>Beroepen</th><th></th><th>Gelezen</th></tr>')
# ⚠️ Het label zegt wat het PLAN met deze character doet, niet of zijn beroepen
# ergens anders ook voorkomen. Eerst stond hier "alles dubbel" zodra elk beroep bij
# meer dan één character stond, en dat markeerde ook Iceicebaby — terwijl zij juist
# degene is die Tailoring en Enchanting houdt. Waar, en toch het verkeerde signaal:
# na het plan is zij de enige die ze heeft. Een vel dat de verkeerde character
# aanwijst is erger dan een vel zonder labels.
CHANGE = {"Umbrion", "Redisch"}
for r in maxrows:
    dupes = [p for p in r["profs"] if p in CRAFT + GATHER and len(holders(p)) > 1]
    if r["name"] in CHANGE:
        cls, tag = "dup", '<span class="tag t-dup">wijzigen</span>'
    elif dupes:
        cls, tag = "", ('<span class="tag t-ok">blijft &mdash; wordt straks '
                        'de enige met %s</span>' % ", ".join(dupes))
    else:
        cls, tag = "", '<span class="tag t-ok">blijft</span>'
    age = ("%d d" % r["age"]) if r["age"] is not None else "?"
    H.append('<tr class="%s"><td class="n">%s</td><td class="c">%s</td><td>%s</td>'
             '<td>%s</td><td class="a">%s</td></tr>'
             % (cls, esc(r["name"]), esc(KLASSE.get(r["name"], "")),
                esc(" &middot; ".join(r["profs"])).replace("&amp;middot;", "&middot;"),
                tag, age))
H.append('</table></section>')

# --- 2. dekking per beroep ------------------------------------------------
for group, title in ((CRAFT, "Crafting"), (GATHER, "Verzamelen")):
    H.append('<section><h2>%s &mdash; dekking op 90</h2><table>' % title)
    for p in group:
        who = holders(p)
        low = [("%s (%s)" % (r["name"], r["level"] or "?")) for r in rows
               if p in r["profs"] and r["level"] != 90]
        if not who:
            cls, tag = "gap", '<span class="tag t-gap">ontbreekt</span>'
            where = ("alleen op " + ", ".join(low)) if low else "op geen enkele character"
        elif len(who) > 1:
            cls, tag = "dup", '<span class="tag t-dup">%d&times;</span>' % len(who)
            where = ", ".join(who)
        else:
            cls, tag = "", '<span class="tag t-ok">goed</span>'
            where = who[0]
        H.append('<tr class="%s"><td class="n">%s</td><td>%s</td><td>%s</td></tr>'
                 % (cls, p, tag, esc(where)))
    H.append('</table></section>')

# --- 3. het plan ----------------------------------------------------------
H.append('''<section><h2>Het plan</h2>
<p style="margin:0 0 8px">Zes characters &times; 2 slots = <b>12 plekken</b> voor
<b>11 beroepen</b>. Alles kan dus, met &eacute;&eacute;n plek over &mdash; nu staan er vier dubbel.</p>
<ul class="plan">
<li><b>Umbrion</b> (Shadow Priest) &rarr; Inscription + Jewelcrafting.
    Zijn Tailoring en Enchanting heeft Iceicebaby al allebei.</li>
<li><b>Redisch</b> (Hunter) &rarr; Engineering + vrije keuze.
    Zijn Blacksmithing heeft Theexodus, zijn Enchanting Iceicebaby.</li>
<li>Earthshammy, Purlymixanox, Theexodus en Iceicebaby blijven zoals ze zijn.</li>
</ul>
<p style="margin:8px 0 0">Dat Blacksmithing bij <b>Theexodus</b> blijft en niet bij Redisch,
is geen muntje opgooien: Theexodus is je Prot Paladin en draagt plate, en dat is precies
wat Blacksmithing maakt. Hetzelfde geldt voor Purlymixanox (Druid, leather) met
Leatherworking en Iceicebaby (Mage, cloth) met Tailoring. Elk pantsertype zit
&eacute;&eacute;n keer op de character die het zelf draagt.</p></section>''')

# --- 4. de kosten, in Blizzards eigen woorden -----------------------------
H.append('''<section><h2>Wat het kost &mdash; Blizzards eigen tekst</h2>
<p style="margin:0 0 6px"><b>Een beroep laten vallen:</b> &bdquo;<i>Do you want to unlearn %s
and lose all associated recipes? Your specialization knowledge will remain should you choose
to return to this profession.</i>&ldquo;</p>
<ul class="plan">
<li><b>Je Knowledge Points blijven staan.</b> Kom je ooit terug, dan staat alles er nog.
    Het is dus omkeerbaar.</li>
<li><b>Je recepten raak je kwijt</b> &mdash; maar bij Umbrion en Redisch heeft een
    ander character ze allemaal al, dus als speler verlies je niets.</li>
<li><b>De echte prijs:</b> Inscription, Jewelcrafting en Engineering beginnen op
    <b>nul kennis</b>. Die twee starten daar een seizoen achter.</li>
</ul>
<p style="margin:8px 0 0"><b>De reset binnen een beroep dat je h&oacute;udt</b> is iets anders:
&bdquo;<i>&hellip;re-allocate your knowledge as you see fit. <b>This can only be done ONCE.</b></i>&ldquo;
E&eacute;n kans per beroep &mdash; verbrand hem niet per ongeluk.</p></section>''')

H.append('<div class="note">Beroepen en leeftijden komen uit de client via Midnight Helper; '
         'het advies is geschreven, niet berekend. Rijen ouder dan een paar dagen kunnen '
         'achterlopen &mdash; log in op die character en het vel klopt weer. '
         'Bron van de citaten: Blizzards GlobalStrings, build 12.1 '
         '(UNLEARN_SKILL en PROFESSION_RESPEC_CONFIRMATION).</div>')
H.append('</body></html>')

io.open(OUT + ".tmp", "w", encoding="utf-8", newline="").write("\n".join(H))
os.replace(OUT + ".tmp", OUT)
print("geschreven: %s" % OUT)
print("%d characters, %d op 90" % (len(rows), len(maxrows)))
gaps = [p for p in CRAFT + GATHER if not holders(p)]
dups = [p for p in CRAFT + GATHER if len(holders(p)) > 1]
print("ontbreekt op 90: %s" % (", ".join(gaps) or "niets"))
print("dubbel op 90   : %s" % (", ".join(dups) or "niets"))
