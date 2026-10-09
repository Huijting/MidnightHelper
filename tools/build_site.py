#!/usr/bin/env python3
"""Generate the guide pages of midnighthelper.com from the addon's own data.

    python "<repo>/tools/_probe.py" run build_site

then, in the site repo, the usual i18n round (extract -> translate the new units -> merge -> build).

🔴 GENERATED, NEVER HAND-EDITED, and that is the whole point. These pages answer the same
questions the addon answers in game, so a hand-written copy would drift from it the moment a
route or a tip changed -- and a public page that contradicts the addon is worse than no page.
On 31 Aug we found four language packs asserting things the English had stopped saying; this is
that same failure with a bigger audience.

📌 Why pages at all: MEASURED 30 Aug -- CurseForge indexes only the project name and a ~200
character summary. Our 28,000-character description counts for nothing in search. A website is
the part Google can read.

WHERE THINGS GO (moved 1 Oct 2026, Rob: "Begin maar met de pagina's naar de website verhuizen")
  - The guides now live on midnighthelper.com/guides/ (the site repo, SITE_REPO below), in the
    site's own header, footer and language picker. They used to be a separate-looking site at
    huijting.github.io/MidnightHelper, generated into this repo's site/ folder.
  - site/ now only holds small "this page moved" pages for the old addresses, so old links and
    Google's index follow us. 🔴 site/google9f04431797b34db7.html (Search Console) stays.
  - Seven languages, and the addon's text is NOT translated again: every element that carries
    addon text is written translate="no" data-addon="<LOCALE_KEY>", and i18n/addon.json holds
    what the addon itself shows in each language. The site's i18n build swaps it in. The page
    furniture (titles, headings, the Knowledge Points prose) goes through the site's normal
    translation round like every other page.

⚠️ The texts come from tools/locale_probe.lua --dump: the locale files loaded the way the client
loads them, once per language. Reading the Lua files with regexes is how this project kept
missing text that lived in a second file (see the notes below); the loader cannot miss it.
"""
import datetime
import html as htmllib
import io
import json
import os
import re
import subprocess
import sys

try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
# MH_ADDON (4 Oct 2026, asked by the site chat): read the addon from another folder, e.g. an export
# of the latest v*-tag, so the site's nightly job builds the guides from the RELEASE and not from
# this working folder. Same variable name as the site repo's build_play_pages.py uses.
ROOT = os.path.abspath(os.environ.get("MH_ADDON") or ROOT)
assert os.path.isfile(os.path.join(ROOT, "MidnightHelper.toc")), \
    "no MidnightHelper.toc in %s -- MH_ADDON must point at the addon folder" % ROOT
DATA = os.path.join(ROOT, "Modules", "ProfessionAcademyData.lua")
OLD_DIR = os.path.join(ROOT, "site")   # the old github.io site: redirect pages only

# The midnighthelper.com repo (Huijting/midnighthelper-site). Override with MH_SITE_REPO.
SITE_REPO = os.environ.get("MH_SITE_REPO") or r"C:\Users\RobHu\Downloads\midnighthelper-site"
assert os.path.isfile(os.path.join(SITE_REPO, "tools", "i18n.py")), \
    "site repo not found at %s -- set MH_SITE_REPO" % SITE_REPO
BASE = "https://midnighthelper.com"

# site language -> addon pack, and what a bare link word says in that language
LANGS = {"en": "enUS", "nl": "nlNL", "de": "deDE", "fr": "frFR", "es": "esES", "pt": "ptBR", "it": "itIT"}
WOWHEAD = {"en": "", "nl": "", "de": "de/", "fr": "fr/", "es": "es/", "pt": "pt/", "it": "it/"}
WORDS = {
    # nl: Rob wil "spell", nooit "spreuk" (9 okt 2026, via de site-chat); nlNL houdt ook "currency" Engels (CLAUDE.md)
    "en": ("spell", "item", "currency"), "nl": ("spell", "item", "currency"),
    "de": ("Zauber", "Gegenstand", "Währung"), "fr": ("sort", "objet", "monnaie"),
    "es": ("hechizo", "objeto", "moneda"), "pt": ("feitiço", "item", "moeda"),
    "it": ("incantesimo", "oggetto", "valuta"),
}

# Google Search Console verification for the OLD github.io address. Kept on the redirect pages
# so the property stays verified while Google follows the move.
GSC_TOKEN = "Xwv2TOPNGBTt-OPD1AEI0z3znYlSIymCaNcyC_uF8N8"

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
     "<em>Lasting Leather</em> is a <strong>tab</strong> in Leatherworking and a "
     "<strong>node</strong> in Skinning. No guide records which is which, because that layer "
     "only exists in the game client. It is also why advice that matches on names alone "
     "quietly points at nothing."),
]


def esc(s):
    return s.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")


def write(path, text):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    io.open(path + ".tmp", "w", encoding="utf-8", newline="\n").write(text)
    os.replace(path + ".tmp", path)


# ── The addon's texts, per language, the way the client loads them ────────────────────
def load_packs():
    p = subprocess.run(["lua", "tools/locale_probe.lua", "--dump"], cwd=ROOT,
                       capture_output=True, text=True, encoding="utf-8", errors="replace")
    assert p.returncode == 0, "locale_probe.lua --dump failed:\n" + p.stderr[:800]
    assert "PROBLEM" not in p.stderr, "locale_probe reported problems:\n" + p.stderr[:800]

    def unesc(s):
        return re.sub(r"\\(\\|n|t)", lambda m: {"\\": "\\", "n": "\n", "t": "\t"}[m.group(1)], s)
    packs = {code: {} for code in LANGS.values()}
    for line in p.stdout.splitlines():
        parts = line.split("\t", 2)
        if len(parts) == 3 and parts[0] in packs:
            packs[parts[0]][parts[1]] = unesc(parts[2])
    for code, pack in packs.items():
        assert len(pack) > 3000, "only %d keys for %s -- refusing to publish" % (len(pack), code)
    return packs


PACKS = load_packs()
EN = PACKS["enUS"]

# The English fallbacks for {UI:NAME}, read from the addon so the two can never disagree.
_codex_lua = io.open(os.path.join(ROOT, "Modules", "MidnightCodex.lua"), encoding="utf-8").read()
_m_ui = re.search(r"local UI_FALLBACK = \{(.*?)\n\}", _codex_lua, re.S)
assert _m_ui, "MidnightCodex.lua lost its UI_FALLBACK table"
UI_FALLBACK = dict(re.findall(r'\t([A-Z0-9_]+) = "([^"]+)",', _m_ui.group(1)))
assert len(UI_FALLBACK) >= 10, "only %d UI_FALLBACK names parsed" % len(UI_FALLBACK)

spell_ids = dict(re.findall(r'^\t([a-z0-9_]+)\s*=\s*(\d+),',
                            io.open(os.path.join(ROOT, "Modules", "DelveSpellIds.lua"),
                                    encoding="utf-8", errors="replace").read(), re.M))


def markup(text, lang):
    """Addon markup -> HTML. Escape FIRST, then substitute, so our own tags survive."""
    spell_w, item_w, cur_w = WORDS[lang]
    wh = "https://www.wowhead.com/" + WOWHEAD[lang]
    t = esc(text)
    # A spell we have an id for becomes a real link; one we do not becomes plain words --
    # the same honest fallback the addon uses in game rather than a dead link.
    t = re.sub(r'\{SPELL:(\d+)\}', lambda m: '<a href="%sspell=%s">%s</a>' % (wh, m.group(1), spell_w), t)
    t = re.sub(r'\{SPELL:@([a-z0-9_]+)\}',
               lambda m: ('<a href="%sspell=%s">%s</a>' % (wh, spell_ids[m.group(1)], m.group(1).replace("_", " ")))
               if m.group(1) in spell_ids else m.group(1).replace("_", " "), t)
    t = re.sub(r'\{ITEM:(\d+)\}', lambda m: '<a href="%sitem=%s">%s</a>' % (wh, m.group(1), item_w), t)
    t = re.sub(r'\{CURRENCY:(\d+)\}', cur_w, t)
    # {UI:NAME}: in game the client's own button name (MidnightCodex.lua); here the English one,
    # because the site cannot know which client the reader has. Unknown name -> refuse, never print
    # a raw token on a public page.
    t = re.sub(r'\{UI:([A-Z0-9_]+)\}', lambda m: esc(UI_FALLBACK[m.group(1)]), t)
    t = re.sub(r'\{WAY:\d+:([\d.]+):([\d.]+):([^}]+)\}',
               lambda m: "%s (%s, %s)" % (m.group(3), m.group(1), m.group(2)), t)
    t = re.sub(r'\|cff[0-9a-fA-F]{6}(.*?)\|r', r"<strong>\1</strong>", t)
    t = re.sub(r'\|cn[A-Z_]+:(.*?)\|R', r"<strong>\1</strong>", t)
    return t


def bullets(text, lang):
    out = []
    for line in markup(text, lang).replace("\n", "|n").split("|n"):
        line = line.strip()
        if line.startswith("&bull;") or line.startswith("•"):
            line = line.lstrip("•").lstrip()
        if line:
            out.append("<li>%s</li>" % line)
    return "<ul>%s</ul>" % "".join(out) if out else ""


# key -> {lang: html}; the English html goes into the page, the rest into i18n/addon.json
ADDON = {}


def addon(key, kind, tag, attrs=""):
    """An element carrying addon text: English in the page, every language in ADDON."""
    render = (lambda v, lang: esc(v)) if kind == "text" else bullets
    ADDON[key] = {lang: render(PACKS[code].get(key, EN[key]), lang) for lang, code in LANGS.items()}
    return '<%s%s translate="no" data-addon="%s">%s</%s>' % (tag, attrs, key, ADDON[key]["en"], tag)


# ── The page shell: the site's own header and footer ──────────────────────────────────
#
# Copied from a live page rather than written here, so the guides cannot drift into looking
# like a different site -- which is exactly what the github.io pages had become.
_shell_src = io.open(os.path.join(SITE_REPO, "raidbots", "index.html"), encoding="utf-8").read()
_m_head = re.search(r'(<div class="uc".*?</header>)', _shell_src, re.S)
_m_foot = re.search(r'(<footer class="sf">.*?</footer>)', _shell_src, re.S)
_m_css = re.search(r'href="(/shared\.css\?v=[^"]+)"', _shell_src)
assert _m_head and _m_foot and _m_css, "raidbots/index.html lost its header, footer or stylesheet link"
HEADER = _m_head.group(1).replace(' aria-current="page"', "")
assert '<a href="/guides/">Guides</a>' in HEADER, "the site menu has no Guides link yet"
HEADER = HEADER.replace('<a href="/guides/">Guides</a>', '<a href="/guides/" aria-current="page">Guides</a>')
HEADER = re.sub(r"<!--i18n:picker-->.*?<!--/i18n:picker-->", "<!--i18n:picker--><!--/i18n:picker-->", HEADER, flags=re.S)
FOOTER = _m_foot.group(1)
SHARED_CSS = _m_css.group(1)

GUIDE_CSS = """\
:root{color-scheme:dark}
*{box-sizing:border-box}
html,body{background:var(--night)}
body{margin:0;color:var(--ink);font-family:var(--body);font-size:16px;line-height:1.6;padding:0 16px}
a{color:var(--gold)}
a:focus-visible{outline:2px solid var(--gold);outline-offset:3px;border-radius:4px}
.wrap{max-width:720px;margin:0 auto;padding-block:28px 64px}
h1{font-family:var(--display);font-weight:400;font-size:clamp(32px,6vw,44px);line-height:1.1;margin:36px 0 8px;text-wrap:balance}
.lead{color:var(--muted);margin:0 0 22px;max-width:62ch}
.checked{color:var(--muted);font-size:14px;margin:-14px 0 22px}
.guides{list-style:none;padding:0;margin:0 0 28px;display:flex;flex-wrap:wrap;gap:8px}
.guides a,.guides span{display:inline-block;padding:4px 12px;border:1px solid var(--line);border-radius:999px;text-decoration:none;color:var(--muted);font-size:14px;font-weight:600}
.guides a:hover{color:var(--ink);border-color:var(--gold)}
.guides span{color:var(--night);background:var(--gold);border-color:var(--gold)}
.toc{columns:2 220px;column-gap:28px;padding-left:20px;margin:0 0 8px;font-size:15px}
.toc li{margin:2px 0;break-inside:avoid}
section{border-top:1px solid var(--line);margin-top:32px;padding-top:4px}
h2{font-family:var(--display);font-weight:400;font-size:26px;line-height:1.2;margin:18px 0 8px;text-wrap:balance}
h3{font-size:12.5px;letter-spacing:.08em;text-transform:uppercase;color:var(--gold);margin:20px 0 4px}
p{margin:0 0 12px;max-width:65ch}
ul{padding-left:20px;margin:0 0 8px}
li{margin:5px 0;max-width:65ch}
.tablewrap{overflow-x:auto;margin:12px 0 20px}
table{border-collapse:collapse;width:100%;font-size:15px}
th,td{text-align:left;padding:8px 10px;border-bottom:1px solid var(--line);vertical-align:top}
thead th{color:var(--muted);font-size:12px;letter-spacing:.06em;text-transform:uppercase}
tbody th{white-space:nowrap}
.note{background:var(--night-2);border:1px solid var(--line);border-radius:12px;padding:14px 18px;margin:24px 0}
.note p{margin:0}
.from{margin-top:44px;padding-top:16px;border-top:1px solid var(--line);color:var(--muted);font-size:14.5px}
.cards{list-style:none;padding:0;margin:0;display:grid;gap:12px;grid-template-columns:repeat(auto-fill,minmax(250px,1fr))}
.cards a{display:block;height:100%;background:var(--night-2);border:1px solid var(--line);border-radius:12px;padding:16px 18px;text-decoration:none;color:var(--ink)}
.cards a:hover{border-color:var(--gold)}
.cards b{display:block;font-family:var(--display);font-weight:400;font-size:21px;line-height:1.25;margin-bottom:4px}
.cards span{display:block;color:var(--muted);font-size:14.5px}
"""

# ── The guides, in ONE place ──────────────────────────────────────────────────────────
#
# 🔴 This list is the section. The pill menu on every guide, the cards on /guides/ and the
# redirects from the old addresses are all derived from it, so a page cannot quietly drop out
# of the menu -- which is how Rob once lost the delve page on the old site.
GUIDES = [
    # slug, menu label, card blurb, old github.io file
    ("knowledge-points", "Knowledge Points",
     "Which profession tree to fill first, for all eleven professions.", "index.html"),
    ("delves", "Delves",
     "Route, trash and bosses for every Midnight delve.", "delves.html"),
    ("start", "New at max level",
     "What the game never sits you down and explains.", "start.html"),
    ("weekly", "Your week",
     "What resets, what is worth doing, and the Great Vault.", "weekly.html"),
    ("currencies", "Currencies",
     "Crests, coins, sparks and shards, and what each is for.", "currencies.html"),
    ("coiled-isle", "The Coiled Isle",
     "The 12.1 zone and the Vaults of Atal'Utek.", "coiled-isle.html"),
    # 2 Oct 2026. Never on github.io, so no old address to redirect (None).
    ("mythic-plus", "Mythic+",
     "Your first key: getting one, finding a group, and what happens in the run.", None),
]


# When each guide's CONTENT was last checked against the game and current guides (4 Oct 2026,
# site-chat point 4). Hand-kept on purpose: a review is something people do, and the date a file
# last changed is not the date anyone checked it. Source: docs/NALOOP_LIJST.md, "Al gedaan".
# 🔴 Every slug in GUIDES needs a date here; a new guide without one stops the build.
REVIEWED = {
    "knowledge-points": "2026-10-03",  # naloop #8, profession course + KP routes
    "delves": "2026-10-03",            # naloop #3, delves + Valeera
    "start": "2026-10-03",             # naloop #6, Codex
    "weekly": "2026-10-03",            # naloop #6 + #2 Great Vault
    "currencies": "2026-10-03",        # naloop #6 + #1 currencies & crests
    "coiled-isle": "2026-10-03",       # naloop #6
    "mythic-plus": "2026-10-03",       # naloop #6
}
assert set(REVIEWED) == {g[0] for g in GUIDES}, \
    "REVIEWED and GUIDES disagree: %s" % sorted(set(REVIEWED) ^ {g[0] for g in GUIDES})
MONTHS = ["January", "February", "March", "April", "May", "June", "July", "August", "September",
          "October", "November", "December"]


def checked_line(slug):
    y, m, d = (int(x) for x in REVIEWED[slug].split("-"))
    return '<p class="checked">Last checked: <time datetime="%s">%d %s %d</time></p>' % (
        REVIEWED[slug], d, MONTHS[m - 1], y)


def pills(current):
    items = []
    for slug, label, _b, _o in GUIDES:
        if slug == current:
            items.append('<li><span aria-current="page">%s</span></li>' % esc(label))
        else:
            items.append('<li><a href="/guides/%s/">%s</a></li>' % (slug, esc(label)))
    return '<ul class="guides" aria-label="Guides">%s</ul>' % "".join(items)


FROM_NOTE = ('<div class="from"><p>Generated from the data inside <strong>Midnight Helper</strong>, '
             'a free World of Warcraft addon. In game the same text sits one click away, in your own '
             'language. <a href="https://www.curseforge.com/wow/addons/midnight-helper">Get it on '
             'CurseForge</a>.</p><p>Some of this is measured in game and some comes from other '
             'guides; where we are unsure, the text says so. Something wrong? '
             '<a href="/feedback/">Tell us</a>.</p></div>')


def page(path, title, desc, body):
    return """<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
<title>%s · Midnight Helper</title>
<meta name="description" content="%s">
<link rel="canonical" href="%s%s">
<!-- Shared link previews, the same set as the site's own pages (feedback/index.html explains why
     there is no og:title/og:description: the translated <title> and description are used). -->
<meta property="og:type" content="website">
<meta property="og:site_name" content="Midnight Helper">
<meta property="og:url" content="%s%s">
<meta property="og:image" content="https://midnighthelper.com/og-image.png">
<meta property="og:image:width" content="1200">
<meta property="og:image:height" content="630">
<meta name="twitter:card" content="summary_large_image">
<!--i18n:alternates--><!--/i18n:alternates-->
<link rel="icon" href="/favicon.svg" type="image/svg+xml">
<link rel="stylesheet" href="/fonts/fonts.css">
<link rel="stylesheet" href="%s">
<!-- GENERATED by MidnightHelper/tools/build_site.py from the addon's data. Do not edit by hand. -->
<style>
%s</style>
</head>
<body>

%s

<div class="wrap">
  <main>
%s
  </main>
</div>

%s

<script src="/lang.js" defer></script>
</body>
</html>
""" % (esc(title), htmllib.escape(desc, quote=True), BASE, path, BASE, path, SHARED_CSS, GUIDE_CSS,
       HEADER, body, FOOTER)


def write_page(slug, title, desc, body):
    path = "/guides/%s/" % slug if slug else "/guides/"
    if slug:
        # Right under the lead paragraph: the first </p> on every guide page closes the lead.
        assert '<p class="lead">' in body, "guide %s has no lead paragraph for the date" % slug
        body = body.replace("</p>", "</p>\n    " + checked_line(slug), 1)
    out = os.path.join(SITE_REPO, "guides", slug, "index.html") if slug else \
        os.path.join(SITE_REPO, "guides", "index.html")
    write(out, page(path, title, desc, body))


# ── Knowledge Points ──────────────────────────────────────────────────────────────────
def steps_for(body):
    out = []
    for m in re.finditer(r'\{\s*(tree|node|anyOf|anyOfNodes)\s*=\s*(.*?)\s*[,}]', body, re.S):
        names = re.findall(r'"([^"]+)"', m.group(2))
        if names:
            out.append((m.group(1), names))
    return out


data = io.open(DATA, encoding="utf-8", errors="replace").read()
assert "advisorRoutes = {" in data, "route table not found -- has the data file changed shape?"
route_src = data[data.index("advisorRoutes = {"):]
routes = []
for m in re.finditer(r'\n\t\t\[(\d+)\]\s*=\s*\{(.*?)\n\t\t\},', route_src, re.S):
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
    # Profession, tree and node names are the English client's: there is no Dutch client, and
    # these names come from the game's own data, not from a translation of ours.
    first = " / ".join(esc(n) for n in names)
    what = "tree" if kind in ("tree", "anyOf") else "node"
    rows.append('<tr><th scope="row" translate="no">%s</th><td translate="no">%s</td><td>%s</td></tr>'
                % (esc(name), first, what))

kp_body = """    <h1>Where do your Knowledge Points go?</h1>
    <p class="lead">Profession specializations in World of Warcraft: Midnight, for all eleven professions, and what nobody can tell you from outside the game.</p>
    %s
    <p>Knowledge Points are scarce and the reset is once only, so the order you spend them in matters more than most guides admit. Below is the tree each profession is worth filling <strong>first</strong>.</p>
    <h2>The first step, per profession</h2>
    <div class="tablewrap"><table>
      <thead><tr><th scope="col">Profession</th><th scope="col">Fill this first</th><th scope="col">It is a</th></tr></thead>
      <tbody>%s</tbody>
    </table></div>
    <p>Names are shown as the English game client writes them.</p>
    <div class="note"><p><strong>How this was checked.</strong> Every step above was verified against a real game client rather than copied between guides: four characters, one profession window at a time, reading the identifiers the game itself reports. On the first pass twelve steps across five professions turned out to name the wrong kind of thing.</p></div>
    <h2>Four things worth knowing before you spend</h2>
    %s
    <h2>What we do not know</h2>
    <p>The <em>structure</em> above is measured for all eleven professions. The <em>content</em>, whether a given tree is the best first pick rather than merely a legal one, is verified for the professions we play, and open for Engineering, Jewelcrafting and Inscription. Where guides disagree with each other, we would rather say so than pick a winner and sound certain.</p>
    %s""" % (pills("knowledge-points"), "".join(rows),
             "".join("<h3>%s</h3><p>%s</p>" % (esc(t), b) for t, b in FINDINGS), FROM_NOTE)
write_page("knowledge-points", "Where do your Knowledge Points go?",
           "Which profession specialization tree to fill first in World of Warcraft Midnight, for all "
           "eleven professions, checked against a live game client.", kp_body)

# ── Delves ────────────────────────────────────────────────────────────────────────────
#
# Same rule as above: generated from the tips the addon ships. They are also the part the
# content watch checks against Blizzard's hotfixes every morning, which is the reason this
# subject is safe to publish at all.
#
# ⚠️ The tips grew in three places (DelveTips.lua per language, enUS.lua for Gnarldor Isle and
# The Ring of Glory, and only the short CHAT form for Venomfall Deeps). The loader sees all of
# them; the assert on the total stays, because a page that looks finished while a delve is
# missing is the failure mode this project keeps paying for.
PART_ORDER = ["OVERVIEW", "ROUTE", "TRASH", "DANGER", "BOSS"]
PART_TITLE = {"OVERVIEW": "The short version", "ROUTE": "Route",
              "TRASH": "Trash", "DANGER": "Watch out", "BOSS": "Bosses"}
# 🔴 ONE DELVE, TWO KEY PREFIXES: DELVE_CHAT_VENOMFALL_DEEPS_* and DELVE_TIP_VENOMFALL_*.
SLUG_ALIAS = {"VENOMFALL_DEEPS": "VENOMFALL"}
# Delves whose tips live outside DelveTips.lua have no DELVE_NAME_ key. Names as Blizzard writes them.
DISPLAY = {"VENOMFALL": "Venomfall Deeps", "GNARLDOR": "Gnarldor Isle", "RINGOFGLORY": "The Ring of Glory"}

delves = {}
part_re = re.compile(r'^DELVE_(TIP|CHAT)_([A-Z0-9_]+?)_(%s)$' % "|".join(PART_ORDER))
for key in sorted(EN):
    m = part_re.match(key)
    if not m:
        continue
    kind, slug, part = m.groups()
    slug = SLUG_ALIAS.get(slug, slug)
    # TIP is the long form; never let the short CHAT line take its place.
    have = delves.setdefault(slug, {}).get(part)
    if have and kind == "CHAT":
        continue
    delves[slug][part] = key
assert len(delves) >= 13, "only %d delves parsed -- refusing to publish a partial page" % len(delves)


def delve_name_key(slug):
    k = "DELVE_NAME_" + slug
    return k if k in EN else None


def pretty(slug):
    k = delve_name_key(slug)
    return DISPLAY.get(slug) or (EN[k] if k else slug.replace("_", " ").title())


secs, toc = [], []
for slug in sorted(delves, key=pretty):
    anchor = slug.lower().replace("_", "-")
    nk = delve_name_key(slug)
    if nk and slug not in DISPLAY:
        h2 = addon(nk, "text", "h2")
        toc.append('<li><a href="#%s">%s</a></li>' % (anchor, addon(nk, "text", "span")))
    else:
        h2 = '<h2 translate="no">%s</h2>' % esc(pretty(slug))
        toc.append('<li><a href="#%s" translate="no">%s</a></li>' % (anchor, esc(pretty(slug))))
    parts = "".join("<h3>%s</h3>%s" % (PART_TITLE[p], addon(delves[slug][p], "list", "div"))
                    for p in PART_ORDER if delves[slug].get(p))
    secs.append('<section id="%s">%s%s</section>' % (anchor, h2, parts))

delve_body = """    <h1>Every Midnight delve, and what to do in each</h1>
    <p class="lead">%d delves, with the route, the trash and the bosses: the same notes the addon shows you in game.</p>
    %s
    <ol class="toc">%s</ol>
    %s
    %s""" % (len(delves), pills("delves"), "".join(toc), "".join(secs), FROM_NOTE)
write_page("delves", "Every Midnight delve, and what to do in each",
           "Route, trash and boss notes for every World of Warcraft Midnight delve, per delve, with "
           "what is confirmed and what is not.", delve_body)

# ── The Codex pages ───────────────────────────────────────────────────────────────────
#
# The addon's Codex is ~44 short articles written for a player who just hit max level and
# checked against the client. One page per category.
#
# ⚠️ "delves" and "professions" are deliberately skipped -- they would compete with the two
# pages above and say it worse. Categories are opted IN.
#
# 🔴 THE GENERATOR COPIES THE TEXT BUT NOT THE CONDITIONS IT IS SHOWN UNDER. Found within an
# hour of the first publication, by Rob: the Season 1 world boss article went up as current
# advice while the addon (then) refused to show it. An article is only safe to publish if the
# addon would show it unconditionally; park anything gated on season, patch or player state in
# SKIP_ARTICLES until someone measures it. (Empty since 2 Sep: that article turned out true.)
SKIP_ARTICLES = {
    # (3 Oct 2026: CODEX_MPLUS_TITLE released again — the Vault review corrected "if you time the
    # key" to "any finished key counts" for Season 2.)
}

# When each patch's interface number goes live, by EU date (the later region, so no article shows early anywhere).
# A minInterface not listed here is held back until someone adds its date. The site chat's build_tips.py uses the
# same date for the daily tip.
PATCH_LIVE = {
    120105: datetime.date(2026, 10, 14),  # 12.1.5: 13 Oct US, 14 Oct EU
}


def interface_live(iface):
    day = PATCH_LIVE.get(iface)
    return day is not None and datetime.date.today() >= day


codex_src = io.open(os.path.join(ROOT, "Modules", "MidnightCodexData.lua"), encoding="utf-8",
                    errors="replace").read()
entries, skipped, held = [], [], []
for chunk in codex_src.split("\n\t{"):
    cat = re.search(r'category\s*=\s*"(\w+)"', chunk)
    tk = re.search(r'titleKey\s*=\s*"([A-Z0-9_]+)"', chunk)
    bk = re.search(r'bodyKey\s*=\s*"([A-Z0-9_]+)"', chunk)
    if not (cat and tk and bk):
        continue
    sort = re.search(r'sort\s*=\s*(\d+)', chunk)
    mi = re.search(r'minInterface\s*=\s*(\d+)', chunk)
    if mi and not interface_live(int(mi.group(1))):
        # The addon hides this article until the client is that build (MidnightCodexData.lua, filter at the
        # bottom). Site chat, 9 Oct 2026: the 4.7.5 nightly put "Keystone Myth is back (12.1.5)" on
        # /guides/mythic-plus/ five days before the patch. Same gate here, by date.
        held.append((cat.group(1), "%s (minInterface %s)" % (tk.group(1), mi.group(1))))
        continue
    entries.append((cat.group(1), int(sort.group(1)) if sort else 999, tk.group(1), bk.group(1)))
assert len(entries) >= 35, "only %d codex entries parsed -- refusing to publish" % len(entries)

CODEX_PAGES = [
    ("start", "start", "New to max level in WoW Midnight? Start here",
     "The things the game never sits you down and explains: what to do first, what the numbers on "
     "your gear mean, and which of the many blinking things actually matter."),
    ("weekly", "weekly", "Your week in Midnight: the Great Vault and the rest",
     "What resets, what is worth doing before it does, and how the Great Vault decides what it "
     "offers you."),
    ("currencies", "currencies", "Midnight currencies and crests, explained",
     "Crests, coins, sparks and shards: what each one is for, where it comes from, and which ones "
     "you are allowed to stop worrying about."),
    ("coiled-isle", "coiledisle", "The Coiled Isle and the Vaults of Atal'Utek",
     "A 12.1 zone with its own map, its own currency and very little explanation. What is in "
     "there, and where."),
    ("mythic-plus", "dungeons", "Mythic+ in Midnight, from your very first key",
     "How to get a keystone, how to sign up for a group or start your own, and what the timer, "
     "deaths and the weekly rules mean for a beginner."),
]

codex_counts = []
for slug, cat, title, lede in CODEX_PAGES:
    rows_c = sorted((e for e in entries if e[0] == cat), key=lambda e: e[1])
    assert rows_c, "no codex entries for category %r" % cat
    csecs, ctoc = [], []
    for _cat, _sort, tkey, bkey in rows_c:
        if tkey in SKIP_ARTICLES:
            held.append((cat, tkey))
            continue
        if not EN.get(tkey) or not EN.get(bkey):
            # Name the gap instead of skipping it quietly: the page would look complete while an
            # article vanished.
            skipped.append((cat, tkey if not EN.get(tkey) else bkey))
            continue
        anchor = tkey.lower().replace("codex_", "").replace("_title", "").replace("_", "-")
        ctoc.append('<li><a href="#%s">%s</a></li>' % (anchor, addon(tkey, "text", "span")))
        csecs.append('<section id="%s">%s%s</section>'
                     % (anchor, addon(tkey, "text", "h2"), addon(bkey, "list", "div")))
    assert csecs, "category %r produced no sections" % cat
    body = """    <h1>%s</h1>
    <p class="lead">%s</p>
    %s
    <ol class="toc">%s</ol>
    %s
    %s""" % (esc(title), esc(lede), pills(slug), "".join(ctoc), "".join(csecs), FROM_NOTE)
    write_page(slug, title, lede, body)
    codex_counts.append((slug, len(csecs)))

# ── /guides/ itself ───────────────────────────────────────────────────────────────────
cards = "".join('<li><a href="/guides/%s/"><b>%s</b><span>%s</span></a></li>' % (s, esc(l), esc(b))
                for s, l, b, _o in GUIDES)
index_body = """    <h1>Guides</h1>
    <p class="lead">Short, plain answers to the questions World of Warcraft: Midnight does not answer for you. Every page is made from the text inside the Midnight Helper addon, so the site and the game always say the same thing.</p>
    <ul class="cards">%s</ul>
    %s""" % (cards, FROM_NOTE)
write_page("", "Guides", "Plain-language guides to World of Warcraft Midnight: Knowledge Points, "
           "delves, your week, currencies and more, from the Midnight Helper addon.", index_body)

# ── The addon's own translations, for the site's i18n build ───────────────────────────
addon_json = {lang: {k: v[lang] for k, v in sorted(ADDON.items())} for lang in LANGS if lang != "en"}
write(os.path.join(SITE_REPO, "i18n", "addon.json"),
      json.dumps(addon_json, ensure_ascii=False, indent=1, sort_keys=True) + "\n")

# ── The old addresses: "this page moved" ──────────────────────────────────────────────
#
# GitHub Pages cannot send a real redirect, so each old page becomes a tiny page that points
# search engines at the new address (canonical) and sends people there at once (refresh).
# 🔴 site/google9f04431797b34db7.html is not written here and must never be removed: it keeps
# the old address verified in Search Console while Google follows the move.
for slug, _l, _b, old in GUIDES:
    if not old:
        continue
    new = "%s/guides/%s/" % (BASE, slug)
    write(os.path.join(OLD_DIR, old), """<!doctype html>
<html lang="en">
<meta charset="utf-8">
<meta name="google-site-verification" content="%s">
<title>This page moved to midnighthelper.com</title>
<link rel="canonical" href="%s">
<meta http-equiv="refresh" content="0; url=%s">
<p>This page moved to <a href="%s">%s</a>.</p>
</html>
""" % (GSC_TOKEN, new, new, new, new))

print("wrote %s/guides/ -- %d pages" % (SITE_REPO, len(GUIDES) + 1))
print("  knowledge-points: %d professions, %d findings" % (len(routes), len(FINDINGS)))
print("  delves: %d delves" % len(delves))
for slug, n in codex_counts:
    print("  %-16s %d codex article(s)" % (slug, n))
for cat, key in skipped:
    print("  !! SKIPPED in %-12s no enUS text for %s" % (cat, key))
for cat, key in held:
    print("  .. HELD BACK in %-9s %s (SKIP_ARTICLES or patch not live yet)" % (cat, key))
print("wrote i18n/addon.json -- %d addon texts x %d languages" % (len(ADDON), len(addon_json)))
untranslated = {lang: sum(1 for k in ADDON if PACKS[LANGS[lang]].get(k) == EN.get(k)) for lang in addon_json}
print("  still English in the addon itself (shown as English, like in game): %s" % untranslated)
print("wrote %d 'moved' pages in site/ (old github.io addresses)" % sum(1 for g in GUIDES if g[3]))
