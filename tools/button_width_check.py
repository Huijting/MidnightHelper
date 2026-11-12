"""Lint [28]: buttons whose text is probably wider than the button (SOFT).

Rob, 12 Nov 2026 (via sparring, verbatim): "Ja, bouw dat". Why: in his screenshot 21.png the "Do this now" window's
"Weapon trainers" button was a fixed 90 px wide and the text stuck out on both sides. Our offline tests could not see
that; this check reads the code and the locale packs instead of the screen.

What it does
  - Finds UIPanelButtonTemplate buttons with a FIXED width: `X:SetSize(<number>, ...)` / `X:SetWidth(<number>)` after
    `X = CreateFrame("Button", ..., "UIPanelButtonTemplate")`, and buttons made by a local helper function whose body
    does that (`local function Btn(...)` -> `f.yes = Btn(...)`).
  - Finds `X:SetText(ns:L("KEY"))` for those buttons, looks KEY up in every language pack, and estimates the text width:
    characters x 6.5 px (GameFontNormal, AFGELEID from the 21.png case) + 16 px for the button's edges.
  - Skips a button whose width is set from its own text (a `SetWidth(...GetStringWidth...)` within 40 lines after the
    SetText): it sizes itself.
It is an ESTIMATE, not a measurement: a SOFT note, never a blocker.
Proof (must be caught): a 90 px button with FWEAP_TITLE ("Weapon trainers"), the 21.png case.
Counter-proof (must pass): the same button at 180 px.
"""
import io
import os
import re
import sys

PX_PER_CHAR = 6.5
EDGE = 16
AUTO_LOOKAHEAD = 40
MIN_WIDTH = 30

CREATE = re.compile(r'^\s*(?:local\s+)?([\w.\[\]]+)\s*=\s*CreateFrame\(\s*"Button".*UIPanelButtonTemplate')
SIZE = re.compile(r'([\w.\[\]]+):SetSize\(\s*(\d+)\s*,')
WIDTH = re.compile(r'([\w.\[\]]+):SetWidth\(\s*(\d+)\s*\)')
SETTEXT = re.compile(r'([\w.\[\]]+):SetText\(\s*ns:L\(\s*"([A-Z0-9_]+)"\s*\)\s*\)')
HELPER = re.compile(r'^\s*local\s+function\s+(\w+)\s*\(')
HELPER_CALL = re.compile(r'^\s*(?:local\s+)?([\w.\[\]]+)\s*=\s*(\w+)\(')
AUTO = re.compile(r'SetWidth\(.*GetStringWidth')
ENTRY = re.compile(r'^\s*([A-Z][A-Z0-9_]+)\s*=\s*"((?:[^"\\]|\\.)*)"')
FILL = re.compile(r'fill\(\s*"(\w{4})"')
PACKS = ["enUS", "nlNL", "deDE", "frFR", "esES", "ptBR", "itIT", "ruRU"]


def module_files(root):
    out = [os.path.join(root, "Core.lua"), os.path.join(root, "UI.lua")]
    for dp, _, fs in os.walk(os.path.join(root, "Modules")):
        out += [os.path.join(dp, f) for f in fs if f.endswith(".lua")]
    return [p for p in out if os.path.isfile(p)]


def load_strings(root):
    """{lang: {key: text}} from the pack files and the fill() blocks (a later value wins, as in the game)."""
    out = {lang: {} for lang in PACKS}
    loc = os.path.join(root, "Locales")
    for lang in PACKS:
        p = os.path.join(loc, lang + ".lua")
        if os.path.isfile(p):
            with open(p, encoding="utf-8", errors="replace") as fh:
                for line in fh:
                    m = ENTRY.match(line)
                    if m:
                        out[lang][m.group(1)] = m.group(2)
    for name in ("Translations2026.lua", "TranslationsS2.lua"):
        p = os.path.join(loc, name)
        if not os.path.isfile(p):
            continue
        cur = None
        with open(p, encoding="utf-8", errors="replace") as fh:
            for line in fh:
                f = FILL.search(line)
                if f:
                    cur = f.group(1)
                m = ENTRY.match(line)
                if m and cur in out:
                    out[cur][m.group(1)] = m.group(2)
    return out


def visible_len(text):
    t = re.sub(r"\|c[0-9a-fA-F]{8}", "", text)
    t = t.replace("|r", "").replace('\\"', '"')
    t = re.sub(r"\|T.*?\|t", "XX", t)
    return len(t)


def estimate(text):
    return visible_len(text) * PX_PER_CHAR + EDGE


def scan_source(src, rel):
    """[(var, width, key, line)] for buttons with a fixed width and a locale text, auto-sizing ones left out."""
    lines = src.splitlines()
    helpers = {}  # helper function name -> fixed width of the button it builds
    cur_fn, cur_has_btn = None, False
    for line in lines:
        h = HELPER.match(line)
        if h:
            cur_fn, cur_has_btn = h.group(1), False
        if cur_fn and "UIPanelButtonTemplate" in line:
            cur_has_btn = True
        if cur_fn and cur_has_btn:
            for rx in (SIZE, WIDTH):
                m = rx.search(line)
                if m and cur_fn not in helpers:
                    helpers[cur_fn] = int(m.group(2))
    width = {}  # var -> last fixed width seen (by line order)
    buttons = set()  # vars that hold a UIPanelButtonTemplate button (font strings and frames are not checked)
    found = []
    for n, line in enumerate(lines, 1):
        if line.lstrip().startswith("--"):
            continue
        c = CREATE.match(line)
        if c:
            width.pop(c.group(1), None)
            buttons.add(c.group(1))
        hc = HELPER_CALL.match(line)
        if hc and hc.group(2) in helpers:
            width[hc.group(1)] = helpers[hc.group(2)]
            buttons.add(hc.group(1))
        for rx in (SIZE, WIDTH):
            for m in rx.finditer(line):
                width[m.group(1)] = int(m.group(2))
        for m in SETTEXT.finditer(line):
            var, key = m.group(1), m.group(2)
            # A width under MIN_WIDTH is a placeholder (the button is stretched by two anchors later): not fixed.
            if var not in buttons or var not in width or width[var] < MIN_WIDTH:
                continue
            after = "\n".join(lines[n:n + AUTO_LOOKAHEAD])
            if AUTO.search(after):
                continue
            found.append((var, width[var], key, n, rel))
    return found


def judge(found, strings):
    """[(overflow_px, rel, line, var, width, key, lang, text)] for every button that probably overflows."""
    bad = []
    for var, w, key, n, rel in found:
        worst = None
        for lang in PACKS:
            text = strings.get(lang, {}).get(key)
            if not text:
                continue
            over = estimate(text) - w
            if over > 0 and (worst is None or over > worst[0]):
                worst = (over, lang, text)
        if worst:
            bad.append((worst[0], rel, n, var, w, key, worst[1], worst[2]))
    bad.sort(key=lambda b: -b[0])
    return bad


def run(root, top=8):
    strings = load_strings(root)
    found = []
    for p in module_files(root):
        rel = os.path.relpath(p, root).replace("\\", "/")
        with open(p, encoding="utf-8", errors="replace") as fh:
            found += scan_source(fh.read(), rel)
    bad = judge(found, strings)
    # Proof: the 21.png case must be caught; counter-proof: the same button at 180 px must pass.
    proof_src = ('local b = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")\n'
                 'b:SetSize(90, 20)\nb:SetText(ns:L("FWEAP_TITLE"))\n')
    counter_src = proof_src.replace("90, 20", "180, 20")
    proof = len(judge(scan_source(proof_src, "proof"), strings)) == 1
    counter = len(judge(scan_source(counter_src, "counter"), strings)) == 0
    control_ok = proof and counter and bool(strings["enUS"].get("FWEAP_TITLE"))
    lines = ["%d fixed-width buttons with a locale text checked; %d probably too narrow in at least one language"
             % (len(found), len(bad))]
    for over, rel, n, var, w, key, lang, text in bad[:top]:
        lines.append('SOFT  %s:%d  %s (%d px) %s %s ~%d px too wide: "%s"'
                     % (rel, n, var, w, key, lang, round(over), text))
    if len(bad) > top:
        lines.append("... and %d more (python tools/button_width_check.py lists all)" % (len(bad) - top))
    return lines, len(bad), control_ok, (proof, counter)


def main():
    sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
    root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    lines, n, ok, pc = run(root, top=10 ** 6)
    for line in lines:
        print(line)
    print("proof (21.png case caught): %s · counter-proof (180 px passes): %s" % pc)
    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main())
