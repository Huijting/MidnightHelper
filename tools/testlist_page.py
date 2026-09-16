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

    for raw in lines:
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
                item = {"indent": len(m.group(1)) // 2, "parts": [m.group(3)]}
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
    })


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
    main()
