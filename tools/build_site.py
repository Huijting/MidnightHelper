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
<link rel="stylesheet" href="style.css">
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

<h2>Also here</h2>
<p><a href="delves.html">Every Midnight delve, and what to do in each</a> &mdash; route, trash and
boss notes for all fourteen, with the abilities linked.</p>

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

# Google Search Console verification. Rob owns the Google side; this is the one line our
# side needs. He pastes the token here, it deploys, Google reads it.
# ⚠️ Empty means no tag is emitted at all -- an empty content="" would fail verification
# while looking like it was set up, which is the worst of both.
GSC_TOKEN = "Xwv2TOPNGBTt-OPD1AEI0z3znYlSIymCaNcyC_uF8N8"
if GSC_TOKEN:
    html = html.replace("<title>", '<meta name="google-site-verification" content="%s">\n<title>'
                        % GSC_TOKEN, 1)

if not os.path.isdir(OUT_DIR):
    os.mkdir(OUT_DIR)


def write(path, text):
    io.open(path + ".tmp", "w", encoding="utf-8", newline="").write(text)
    os.replace(path + ".tmp", path)


write(OUT, html)

# One stylesheet for every page, so a second page cannot drift into looking like a different
# site. Dark mode follows the reader's own setting rather than a toggle nobody would find.
write(os.path.join(OUT_DIR, "style.css"), """\
:root{color-scheme:light dark;--fg:#1a1a1a;--bg:#fff;--dim:#5b5b5b;--rule:#e2e2e2;--accent:#7a4fbf}
@media(prefers-color-scheme:dark){:root{--fg:#e8e6e3;--bg:#17161a;--dim:#a09aa8;--rule:#2f2c35;--accent:#c0a4f0}}
*{box-sizing:border-box}
body{margin:0;padding:2rem 1.15rem 4rem;background:var(--bg);color:var(--fg);
 font:1.05rem/1.65 system-ui,-apple-system,"Segoe UI",sans-serif}
main{max-width:44rem;margin:0 auto}
h1{font-size:1.9rem;line-height:1.2;margin:0 0 .4rem}
h2{font-size:1.3rem;margin:2.6rem 0 .6rem;border-bottom:1px solid var(--rule);padding-bottom:.3rem}
h3{font-size:1rem;margin:1.4rem 0 .2rem;color:var(--dim);text-transform:uppercase;
 letter-spacing:.05em;font-size:.8rem}
p{margin:.7rem 0}
ul{margin:.4rem 0;padding-left:1.2rem}
li{margin:.35rem 0}
.lede{color:var(--dim);font-size:1.1rem;margin-bottom:1.6rem}
.back{font-size:.9rem;margin:0 0 1.4rem}
.toc{list-style:none;padding:0;margin:0 0 1rem;display:flex;flex-wrap:wrap;gap:.4rem .9rem}
.toc li{margin:0;font-size:.95rem}
table{border-collapse:collapse;width:100%;margin:1rem 0;font-size:.97rem}
th,td{text-align:left;padding:.5rem .6rem;border-bottom:1px solid var(--rule);vertical-align:top}
thead th{color:var(--dim);font-weight:600;font-size:.85rem;text-transform:uppercase;letter-spacing:.04em}
tbody th{font-weight:600;white-space:nowrap}
code{background:color-mix(in srgb,var(--fg) 8%, transparent);padding:.1em .35em;border-radius:3px;font-size:.9em}
.note{border-left:3px solid var(--accent);padding:.1rem 0 .1rem 1rem;margin:1.6rem 0;color:var(--dim)}
footer{margin-top:3rem;padding-top:1.2rem;border-top:1px solid var(--rule);color:var(--dim);font-size:.9rem}
a{color:var(--accent)}
""")

# ── The delve page ────────────────────────────────────────────────────────────────────
#
# Same rule as the page above: generated from the tips the addon ships, so the two cannot
# disagree. The delve tips are also the part a content watch checks against Blizzard's
# hotfixes every morning, which is the reason this subject is safe to publish at all.
#
# ⚠️ Three source files, because the tips grew in three places: DelveTips.lua holds eleven
# in per-language blocks, enUS.lua holds Gnarldor Isle and The Ring of Glory, and Venomfall
# Deeps has only the short CHAT form. Reading one file and reporting what is missing is
# exactly the mistake the content watch made on 1 Sep -- so this reads all of them and
# asserts on the total.

TIPS_FILE = os.path.join(ROOT, "Locales", "DelveTips.lua")
ENUS_FILE = os.path.join(ROOT, "Locales", "enUS.lua")
IDS_FILE = os.path.join(ROOT, "Modules", "DelveSpellIds.lua")

PART_ORDER = ["OVERVIEW", "ROUTE", "TRASH", "DANGER", "BOSS"]

# 🔴 ONE DELVE, TWO KEY PREFIXES -- found by building this page, and it is a fault in our own
# data rather than in the generator: DelveTips.lua writes DELVE_CHAT_VENOMFALL_DEEPS_* while
# enUS.lua writes DELVE_TIP_VENOMFALL_*. Without this fold the page listed the same delve
# twice, under two names. Worth repairing in the addon; folded here so the page is right
# meanwhile.
SLUG_ALIAS = {"VENOMFALL_DEEPS": "VENOMFALL"}
# Delves whose tips live outside DelveTips.lua have no DELVE_NAME_ key, so the slug would be
# shown raw ("Ringofglory"). Names as Blizzard writes them.
DISPLAY = {"VENOMFALL": "Venomfall Deeps", "GNARLDOR": "Gnarldor Isle",
           "RINGOFGLORY": "The Ring of Glory"}
PART_TITLE = {"OVERVIEW": "The short version", "ROUTE": "Route",
              "TRASH": "Trash", "DANGER": "Watch out", "BOSS": "Bosses"}

spell_ids = dict(re.findall(r'^\t([a-z0-9_]+)\s*=\s*(\d+),',
                            io.open(IDS_FILE, encoding="utf-8", errors="replace").read(), re.M))

tips_src = io.open(TIPS_FILE, encoding="utf-8", errors="replace").read()
en_start = tips_src.find("merge(ns._mhLocales and ns._mhLocales.enUS, {")
en_end = tips_src.find("\n})", en_start)
assert en_start >= 0 and en_end > en_start, "enUS block not found in DelveTips.lua"
sources = [tips_src[en_start:en_end], io.open(ENUS_FILE, encoding="utf-8", errors="replace").read()]

delves, names = {}, {}
for src in sources:
    for m in re.finditer(r'DELVE_(TIP|CHAT)_([A-Z0-9_]+?)_(%s)\s*=\s*"((?:[^"\\]|\\.)*)"'
                         % "|".join(PART_ORDER), src):
        kind, slug, part, text = m.groups()
        slug = SLUG_ALIAS.get(slug, slug)
        # TIP is the long form; never let the short CHAT line overwrite it.
        if kind == "CHAT" and delves.get(slug, {}).get(part):
            continue
        delves.setdefault(slug, {})[part] = text
    for m in re.finditer(r'DELVE_NAME_([A-Z0-9_]+)\s*=\s*"([^"]*)"', src):
        names.setdefault(m.group(1), m.group(2))

assert len(delves) >= 13, "only %d delves parsed -- refusing to publish a partial page" % len(delves)


def markup(text):
    """Addon markup -> HTML. Escape FIRST, then substitute, so our own tags survive."""
    t = esc(text)
    # A spell we have an id for becomes a real link; one we do not becomes plain words --
    # the same honest fallback the addon uses in game rather than a dead link.
    t = re.sub(r'\{SPELL:(\d+)\}',
               lambda m: '<a href="https://www.wowhead.com/spell=%s">spell</a>' % m.group(1), t)
    t = re.sub(r'\{SPELL:@([a-z0-9_]+)\}',
               lambda m: ('<a href="https://www.wowhead.com/spell=%s">%s</a>'
                          % (spell_ids[m.group(1)], m.group(1).replace("_", " ")))
               if m.group(1) in spell_ids else m.group(1).replace("_", " "), t)
    t = re.sub(r'\{ITEM:(\d+)\}',
               lambda m: '<a href="https://www.wowhead.com/item=%s">item</a>' % m.group(1), t)
    t = re.sub(r'\{CURRENCY:(\d+)\}', "currency", t)
    t = re.sub(r'\{WAY:\d+:([\d.]+):([\d.]+):([^}]+)\}',
               lambda m: "%s (%s, %s)" % (m.group(3), m.group(1), m.group(2)), t)
    t = re.sub(r'\|cff[0-9a-fA-F]{6}(.*?)\|r', r"<strong>\1</strong>", t)
    t = re.sub(r'\|cn[A-Z_]+:(.*?)\|R', r"<strong>\1</strong>", t)
    return t


def bullets(text):
    out = []
    for line in markup(text).split("|n"):
        line = line.strip()
        if line.startswith("&bull;") or line.startswith("•"):
            line = line.lstrip("•").lstrip()
        if line:
            out.append("<li>%s</li>" % line)
    return "<ul>%s</ul>" % "".join(out) if out else ""


def pretty(slug):
    return DISPLAY.get(slug) or names.get(slug) or slug.replace("_", " ").title()


secs, toc = [], []
for slug in sorted(delves, key=pretty):
    parts = delves[slug]
    body = "".join("<h3>%s</h3>%s" % (PART_TITLE[p], bullets(parts[p]))
                   for p in PART_ORDER if parts.get(p))
    anchor = slug.lower().replace("_", "-")
    toc.append('<li><a href="#%s">%s</a></li>' % (anchor, esc(pretty(slug))))
    secs.append('<section id="%s"><h2>%s</h2>%s</section>' % (anchor, esc(pretty(slug)), body))

DELVE_HTML = """<!doctype html>
<html lang="en">
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>Every Midnight delve, and what to do in each</title>
<meta name="description" content="Route, trash and boss notes for every World of Warcraft\
 Midnight delve -- the short version, per delve, with what is confirmed and what is not.">
<link rel="canonical" href="https://huijting.github.io/MidnightHelper/delves.html">
<link rel="stylesheet" href="style.css">
<main>
<p class="back"><a href="./">&larr; Midnight Helper</a></p>
<h1>Every Midnight delve, and what to do in each</h1>
<p class="lede">__COUNT__ delves, with the route, the trash and the bosses &mdash; the same notes
the addon shows you in game, in seven languages.</p>
<nav aria-label="Delves"><ul class="toc">__TOC__</ul></nav>
__SECS__
<footer>
<p>These notes come from <strong>Midnight Helper</strong>, a free World of Warcraft addon that
explains <em>why</em> rather than only <em>what</em>. In game they appear for the delve you are
actually standing in, in your own language.</p>
<p><a href="https://www.curseforge.com/wow/addons/midnight-helper">Get it on CurseForge</a>
&middot; <a href="https://github.com/Huijting/MidnightHelper">Source on GitHub</a></p>
<p>Some of this is measured in game and some comes from other guides; where we are unsure, the
text says so rather than sounding certain. If something here is wrong, saying so is genuinely
welcome.</p>
</footer>
</main>
</html>
"""

write(os.path.join(OUT_DIR, "delves.html"),
      DELVE_HTML.replace("__TOC__", "".join(toc)).replace("__SECS__", "".join(secs))
      .replace("__COUNT__", str(len(delves))))

# A sitemap is close to pointless for one page and is exactly what Search Console asks for
# the moment there are several -- so it is generated from the same list the pages are, and
# cannot fall behind them.
PAGES = [("", "weekly"), ("delves.html", "weekly")]  # (path under the root, change frequency)
today = __import__("datetime").date.today().isoformat()
sitemap = ['<?xml version="1.0" encoding="UTF-8"?>',
           '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">']
for path, freq in PAGES:
    sitemap.append("  <url><loc>https://huijting.github.io/MidnightHelper/%s</loc>"
                   "<lastmod>%s</lastmod><changefreq>%s</changefreq></url>" % (path, today, freq))
sitemap.append("</urlset>")
write(os.path.join(OUT_DIR, "sitemap.xml"), "\n".join(sitemap) + "\n")

write(os.path.join(OUT_DIR, "robots.txt"),
      "User-agent: *\nAllow: /\nSitemap: https://huijting.github.io/MidnightHelper/sitemap.xml\n")

print("wrote %s -- %d professions, %d findings, %d bytes"
      % (os.path.relpath(OUT, ROOT), len(routes), len(FINDINGS), len(html)))
print("wrote site/sitemap.xml (%d page(s)) and site/robots.txt" % len(PAGES))
print("google-site-verification: %s"
      % ("set" if GSC_TOKEN else "NOT set -- paste the token into GSC_TOKEN in this file"))
