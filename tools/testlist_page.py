"""Build the phone tick-off page from docs/TESTLIJST.md.

    python tools/_probe.py run testlist_page

Reads every checkbox that is still open, flattens its markdown, and pastes the lot into
`tools/testlist_page_template.html` (which carries the whole page: style, logic, the `db`
calls). The result is `tools/testlist_page_build.html`, which is what gets published as an
Artifact for Rob's phone.

Why a tool and not a scratch script: the page is rebuilt every time the test list grows, and
a scratch script would have to be rewritten from memory each time -- including the item ids,
which must stay stable or Rob's ticks come loose. The id is a hash of section + text, so an
edit somewhere else in the file never moves another item's tick.

Rob, 16 Sep 2026: "maak een afvinklijst ala een onderweg pagina zoals we eerder deden met de
openstaande punten die we moesten bevestigen".
"""
import hashlib
import io
import json
import os
import re

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
SRC = os.path.join(ROOT, "docs", "TESTLIJST.md")
TEMPLATE = os.path.join(HERE, "testlist_page_template.html")
OUT = os.path.join(HERE, "testlist_page_build.html")

BOX = re.compile(r"^(\s*)-\s\[( |x|X)\]\s?(.*)$")
CONT = re.compile(r"^(\s+)(?!-\s\[)(\S.*)$")


def flatten(text):
    """Markdown down to the words. Links keep their words, not their target."""
    text = re.sub(r"\[([^\]]+)\]\([^)]+\)", r"\1", text)
    text = re.sub(r"`([^`]+)`", r"\1", text)
    text = re.sub(r"\*\*([^*]+)\*\*", r"\1", text)
    text = re.sub(r"\*([^*]+)\*", r"\1", text)
    text = re.sub(r"~~([^~]+)~~", r"\1", text)
    return re.sub(r"\s+", " ", text).strip()


def read_open_items():
    sections, cur, item = [], None, None

    with io.open(SRC, "r", encoding="utf-8") as fh:
        lines = fh.read().split("\n")

    for lineno, raw in enumerate(lines):
        line = raw.rstrip()
        if line.startswith("## "):
            if item is not None:
                _store(cur, item)
                item = None
            cur = {"title": flatten(line[3:]), "items": []}
            sections.append(cur)
            continue
        if cur is None:
            continue
        m = BOX.match(line)
        if m:
            if item is not None:
                _store(cur, item)
                item = None
            if m.group(2) == " ":
                item = {"indent": len(m.group(1)) // 2, "parts": [m.group(3)], "line": lineno}
            continue
        if item is not None:
            c = CONT.match(line)
            if c:
                item["parts"].append(c.group(2))
            else:
                _store(cur, item)
                item = None
    if item is not None:
        _store(cur, item)

    out = []
    for s in sections:
        if s["items"]:
            s["is40"] = "4.0.0" in s["title"]
            out.append(s)

    # "Nieuwste" = the two most recent dates that appear in a section title. Computed here
    # instead of hardcoded in the page, which named "14/15/16 sep" and would have gone stale.
    # Two, not three: with three the filter still showed 49 items, which is the "too many" Rob
    # was complaining about in the first place.
    months = {m: n for n, m in enumerate(
        ["jan", "feb", "mrt", "apr", "mei", "jun", "jul", "aug", "sep", "okt", "nov", "dec"], 1)}
    date_re = re.compile(r"\b(\d{1,2})\s+(jan|feb|mrt|apr|mei|jun|jul|aug|sep|okt|nov|dec)\b")
    for s in out:
        m = date_re.search(s["title"])
        s["_date"] = (months[m.group(2)], int(m.group(1))) if m else (0, 0)
    recent = sorted({s["_date"] for s in out if s["_date"] != (0, 0)}, reverse=True)[:2]
    for s in out:
        s["isNew"] = s.pop("_date") in recent
    return out


def _store(section, item):
    text = flatten(" ".join(item["parts"]))
    if not text:
        return
    key = (section["title"] + "|" + text).encode("utf-8")
    section["items"].append({
        "id": hashlib.sha1(key).hexdigest()[:10],
        "text": text,
        "indent": item["indent"],
        "line": item["line"],
    })


def apply_ticks(ids_file, stamp):
    """Tick off, in TESTLIJST.md itself, every item whose id is in `ids_file` (one per line).

    The phone page only REMEMBERS a tick; the list stays as long as the markdown says `- [ ]`.
    Rob, 16 Sep 2026: "vinkjes nog niet gedaan, zijn er wel heel veel" -- so what he confirmed
    has to leave the list for real, or the page never gets shorter. Only boxes marked OK are
    passed in here; a "niet goed" stays open, with its note, for us to fix.
    """
    wanted = set()
    for line in io.open(ids_file, "r", encoding="utf-8"):
        line = line.strip()
        if line and not line.startswith("#"):
            wanted.add(line)
    lines = io.open(SRC, "r", encoding="utf-8").read().split("\n")
    done = []
    for s in read_open_items():
        for i in s["items"]:
            if i["id"] in wanted:
                row = lines[i["line"]]
                new = row.replace("- [ ]", "- [x] ✅ (%s)" % stamp, 1)
                if new != row:
                    lines[i["line"]] = new
                    done.append(i["id"])
    text = "\n".join(lines)
    io.open(SRC + ".tmp", "w", encoding="utf-8", newline="").write(text)
    os.replace(SRC + ".tmp", SRC)
    missing = sorted(wanted - set(done))
    print("afgevinkt in TESTLIJST.md: %d van %d" % (len(done), len(wanted)))
    if missing:
        print("niet (meer) open of onbekend: %s" % ", ".join(missing))


def main():
    sections = read_open_items()
    total = sum(len(s["items"]) for s in sections)

    html = io.open(TEMPLATE, "r", encoding="utf-8").read()
    if "__DATA__" not in html:
        raise SystemExit("no __DATA__ placeholder in " + TEMPLATE)
    blob = json.dumps({"sections": sections}, ensure_ascii=False).replace("</", "<\\/")
    html = html.replace("__DATA__", blob)

    io.open(OUT + ".tmp", "w", encoding="utf-8", newline="").write(html)
    os.replace(OUT + ".tmp", OUT)

    print("secties: %d   open punten: %d" % (len(sections), total))
    for s in sections[:8]:
        print("  %3d  %s%s" % (len(s["items"]), "[4.0] " if s["is40"] else "", s["title"][:70]))
    print("geschreven: %s (%d KB)" % (OUT, len(html.encode("utf-8")) // 1024))
    print("publiceren: Artifact-tool, capabilities {db:{}} -- de bestaande pagina bijwerken met haar URL.")


if __name__ == "__main__":
    import sys
    # python tools/_probe.py run testlist_page apply <ids-file> "<stamp>"   -> tick them off, then rebuild
    if len(sys.argv) >= 3 and sys.argv[1] == "apply":
        apply_ticks(sys.argv[2], sys.argv[3] if len(sys.argv) > 3 else "telefoon")
    main()
