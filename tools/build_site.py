#!/usr/bin/env python3
"""Generate site/index.html from the addon's own route data.

    python "<repo>/tools/_probe.py" run build_site

🔴 GENERATED, NEVER HAND-EDITED, and that is the whole point. This page answers the same
question the in-game advisor answers, so a hand-written copy would drift from it the moment a
route changed -- and a public page that contradicts the addon is worse than no page. On 31 Aug
we found four language packs asserting things the English had stopped saying; this is that same
failure with a bigger audience.

⚠️ It reads Modules/ProfessionAcademyData.lua. If that file's shape changes, this fails loudly
(assert) rather than emitting a half-empty page. Silence is the failure mode to avoid.

📌 Why a page at all: MEASURED 30 Aug -- CurseForge indexes only the project name and a ~200
character summary. Our 28,000-character description counts for nothing, so searching for a word
that appears in it finds twenty other addons and not us. A website is the part Google can read.
"""
import io
import os
import re
import sys

try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
DATA = os.path.join(ROOT, "Modules", "ProfessionAcademyData.lua")
OUT_DIR = os.path.join(ROOT, "site")
OUT = os.path.join(OUT_DIR, "index.html")

PROF = {164: "Blacksmithing", 165: "Leatherworking", 171: "Alchemy", 182: "Herbalism",
        186: "Mining", 197: "Tailoring", 202: "Engineering", 333: "Enchanting",
        393: "Skinning", 755: "Jewelcrafting", 773: "Inscription"}

# Things we MEASURED that the guides get wrong or do not record at all. Hand-written because
# they are explanations, not data -- but each one names where it was measured, so a reader can
# check us and a future session knows what to re-verify rather than assume.
FINDINGS = [
    ("Disenchanting ignores every craft stat",
     "Enchanting's disenchanting reads <em>raw Skill only</em>. Our own route used to send "
     "players to spend around fifty points elsewhere first, and those points did nothing for "
     "it. <strong>Disenchanting Delegate pays out from the very first point.</strong> "
     "If you disenchant, start there."),
    ("Recycling works from zero points",
     "Engineering's Recycling ability gives materials and skill-ups immediately. The ten points "
     "people tell you to spend buy <em>recipe discovery</em>, not the ability. Worth knowing "
     "before you conclude something is broken."),
    ("Calm Hands stops at 10, not 30",
     "Inscription's first tree caps at rank 10, where most guides print 30. Ten fills the root "
     "and unlocks all three sub-specialisations."),
    ("The same name can be two different things",
     "<code>Lasting Leather</code> is a <strong>tab</strong> in Leatherworking and a "
     "<strong>node</strong> in Skinning. No guide records which is which, because that layer "
     "only exists in the game client. It is also why advice that matches on names alone "
     "quietly points at nothing."),
]


def steps_for(body):
    out = []
    for m in re.finditer(r'\{\s*(tree|node|anyOf|anyOfNodes)\s*=\s*(.*?)\s*[,}]', body, re.S):
        names = re.findall(r'"([^"]+)"', m.group(2))
        if names:
            out.append((m.group(1), names))
    return out


def esc(s):
    return s.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")


data = io.open(DATA, encoding="utf-8", errors="replace").read()
assert "advisorRoutes = {" in data, "route table not found -- has the data file changed shape?"
body = data[data.index("advisorRoutes = {"):]

routes = []
for m in re.finditer(r'\n\t\t\[(\d+)\]\s*=\s*\{(.*?)\n\t\t\},', body, re.S):
    sid = int(m.group(1))
    if sid in PROF:
        st = steps_for(m.group(2))
        if st:
            routes.append((PROF[sid], st))
routes.sort()
assert len(routes) >= 10, "only %d routes parsed -- refusing to publish a half page" % len(routes)

rows = []
for name, st in routes:
    kind, names = st[0]
    first = " <em>or</em> ".join(esc(n) for n in names)
    what = "tree" if kind in ("tree", "anyOf") else "node"
    rows.append("<tr><th scope=\"row\">%s</th><td>%s</td><td>%s</td></tr>"
                % (esc(name), first, what))

finds = "\n".join(
    "<section><h3>%s</h3><p>%s</p></section>" % (esc(t), b) for t, b in FINDINGS)

HTML = """<!doctype html>
<html lang="en">
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>Where do your Knowledge Points go? WoW Midnight professions</title>
<meta name="description" content="Which profession specialization tree to fill first in World of\
 Warcraft Midnight, for all eleven professions -- checked against a live game client, with what\
 we could not verify said out loud.">
<link rel="canonical" href="https://huijting.github.io/MidnightHelper/">
<style>
:root{color-scheme:light dark;--fg:#1a1a1a;--bg:#fff;--dim:#5b5b5b;--rule:#e2e2e2;--accent:#7a4fbf}
@media(prefers-color-scheme:dark){:root{--fg:#e8e6e3;--bg:#17161a;--dim:#a09aa8;--rule:#2f2c35;--accent:#c0a4f0}}
*{box-sizing:border-box}
body{margin:0;padding:2rem 1.15rem 4rem;background:var(--bg);color:var(--fg);
 font:1.05rem/1.65 system-ui,-apple-system,"Segoe UI",sans-serif}
main{max-width:44rem;margin:0 auto}
h1{font-size:1.9rem;line-height:1.2;margin:0 0 .4rem}
h2{font-size:1.3rem;margin:2.6rem 0 .6rem;border-bottom:1px solid var(--rule);padding-bottom:.3rem}
h3{font-size:1.05rem;margin:1.6rem 0 .2rem}
p{margin:.7rem 0}
.lede{color:var(--dim);font-size:1.1rem;margin-bottom:1.6rem}
table{border-collapse:collapse;width:100%;margin:1rem 0;font-size:.97rem}
th,td{text-align:left;padding:.5rem .6rem;border-bottom:1px solid var(--rule);vertical-align:top}
thead th{color:var(--dim);font-weight:600;font-size:.85rem;text-transform:uppercase;letter-spacing:.04em}
tbody th{font-weight:600;white-space:nowrap}
code{background:color-mix(in srgb,var(--fg) 8%, transparent);padding:.1em .35em;border-radius:3px;font-size:.9em}
.note{border-left:3px solid var(--accent);padding:.1rem 0 .1rem 1rem;margin:1.6rem 0;color:var(--dim)}
footer{margin-top:3rem;padding-top:1.2rem;border-top:1px solid var(--rule);color:var(--dim);font-size:.9rem}
a{color:var(--accent)}
</style>
<main>
<h1>Where do your Knowledge Points go?</h1>
<p class="lede">Profession specializations in World of Warcraft: Midnight, for all eleven
professions &mdash; and what nobody can tell you from outside the game.</p>

<p>Knowledge Points are scarce and the reset is once only, so the order you spend them in
matters more than most guides admit. Below is the tree each profession is worth filling
<strong>first</strong>.</p>

<h2>The first step, per profession</h2>
<table>
<thead><tr><th scope="col">Profession</th><th scope="col">Fill this first</th><th scope="col">It is a</th></tr></thead>
<tbody>
__ROWS__
</tbody>
</table>

<div class="note"><p><strong>How this was checked.</strong> Every step above was verified against
a real game client rather than copied between guides: four characters, one profession window at
a time, reading the identifiers the game itself reports. On the first pass twelve steps across
five professions turned out to name the wrong kind of thing.</p></div>

<h2>Four things worth knowing before you spend</h2>
__FINDS__

<h2>What we do not know</h2>
<p>The <em>structure</em> above is measured for all eleven professions. The <em>content</em>
&mdash; whether a given tree is the best first pick rather than merely a legal one &mdash; is
verified for the professions we play, and open for Engineering, Jewelcrafting and Inscription.
Where guides disagree with each other, we would rather say so than pick a winner and sound
certain.</p>

<footer>
<p>This page is generated from the data inside <strong>Midnight Helper</strong>, a free World of
Warcraft addon that explains <em>why</em> rather than only <em>what</em> &mdash; weekly planning,
Great Vault advice, Delve coaching, a beginner professions course and a class keybind coach, in
seven languages.</p>
<p><a href="https://www.curseforge.com/wow/addons/midnight-helper">Get it on CurseForge</a>
&middot; <a href="https://github.com/Huijting/MidnightHelper">Source on GitHub</a></p>
<p>Written and maintained by one person. If something here is wrong, saying so is genuinely
welcome.</p>
</footer>
</main>
</html>
"""

html = HTML.replace("__ROWS__", "\n".join(rows)).replace("__FINDS__", finds)
if not os.path.isdir(OUT_DIR):
    os.mkdir(OUT_DIR)
io.open(OUT + ".tmp", "w", encoding="utf-8", newline="").write(html)
os.replace(OUT + ".tmp", OUT)
print("wrote %s -- %d professions, %d findings, %d bytes"
      % (os.path.relpath(OUT, ROOT), len(routes), len(FINDINGS), len(html)))
