#!/usr/bin/env python3
"""
Download English spell names from Wowhead for every spell ID used in GuideData tips.

Writes tools/guide_spell_names.json as {"12345": "Spell Name", ...}.

Usage:
  python tools/fetch_guide_spell_names.py           # fetch missing only (merge)
  python tools/fetch_guide_spell_names.py --refresh # refetch all IDs used in tips
"""
from __future__ import annotations

import argparse
import json
import pathlib
import re
import shutil
import subprocess
import time
import urllib.error
import urllib.request

ROOT = pathlib.Path(__file__).resolve().parents[1]
OUT = ROOT / "tools" / "guide_spell_names.json"
GUIDE_DATA = ROOT / "Addons" / "GuideData.lua"

ROW_RE = re.compile(
    r'\{\s*spell\s*=\s*(\d+)\s*,\s*textKey\s*=\s*"(GUIDE_TIP_\d+)"\s*\}'
)
TITLE_RE = re.compile(r"<title>([^<]+)</title>", re.I)


def tip_spell_ids() -> list[int]:
    text = GUIDE_DATA.read_text(encoding="utf-8")
    return sorted({int(a) for a, _ in ROW_RE.findall(text)})


def _curl_get(url: str) -> str:
    curl = shutil.which("curl.exe") or shutil.which("curl")
    if not curl:
        raise RuntimeError("curl not found on PATH")
    proc = subprocess.run(
        [
            curl,
            "-sL",
            "--compressed",
            "-A",
            "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 "
            "(KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36",
            url,
        ],
        capture_output=True,
        text=True,
        timeout=35,
    )
    html = proc.stdout or ""
    if proc.returncode != 0 or not html.strip():
        raise RuntimeError(f"curl failed ({proc.returncode}) for {url}")
    return html


def fetch_name(spell_id: int) -> str | None:
    # NOTE: Wowhead often returns HTTP 403 to Python's urllib TLS fingerprint on Windows.
    # curl.exe generally works and matches what browsers send closely enough.
    urls = (
        f"https://ptr.wowhead.com/spell={spell_id}",
        f"https://www.wowhead.com/spell={spell_id}",
    )
    curl = shutil.which("curl.exe") or shutil.which("curl")
    html = ""
    last_err: Exception | None = None
    if curl:
        for url in urls:
            try:
                html = _curl_get(url)
                break
            except RuntimeError as e:
                last_err = e
                continue
        if not html:
            raise RuntimeError(str(last_err or "no html"))
    else:
        req = urllib.request.Request(
            urls[0],
            headers={
                "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 "
                "(KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36",
                "Accept": "text/html,application/xhtml+xml",
                "Accept-Language": "en-US,en;q=0.9",
            },
        )
        try:
            with urllib.request.urlopen(req, timeout=25) as resp:
                html = resp.read().decode("utf-8", "replace")
        except urllib.error.HTTPError as e:
            if e.code == 404:
                return None
            raise
    m = TITLE_RE.search(html)
    if not m:
        return None
    title = m.group(1).strip()
    # "Lightning Bolt - Spell - World of Warcraft" / "... PTR"
    if " - Spell - " in title:
        return title.split(" - Spell - ", 1)[0].strip()
    tl = title.lower()
    if tl.startswith("wowhead"):
        return None
    if "could not be satisfied" in tl or tl.startswith("error"):
        return None
    return title


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--refresh", action="store_true", help="Refetch every ID (slow)")
    ap.add_argument(
        "--sleep",
        type=float,
        default=0.35,
        help="Delay between requests (Wowhead may 403 if too fast)",
    )
    args = ap.parse_args()

    ids = tip_spell_ids()
    data: dict[str, str] = {}
    if OUT.is_file():
        data = json.loads(OUT.read_text(encoding="utf-8"))

    def needs_fetch(key: str) -> bool:
        v = data.get(key)
        if v is None or v == "":
            return True
        vl = v.lower()
        # CDN failures sometimes embed these phrases in <title>. Avoid matching substrings like "terror".
        bad = (
            "could not be satisfied",
            "access denied",
            "403 forbidden",
            "error: the request could not be satisfied",
            "403 error",
        )
        return any(b in vl for b in bad)

    todo = ids if args.refresh else [i for i in ids if needs_fetch(str(i))]

    print(f"spell IDs in tips: {len(ids)}")
    print(f"to fetch: {len(todo)}")

    def persist() -> None:
        OUT.write_text(json.dumps(data, indent=2, sort_keys=True), encoding="utf-8")

    for i, sid in enumerate(todo):
        key = str(sid)
        print(f"[{i + 1}/{len(todo)}] {sid} ...", flush=True)
        attempts = 0
        while True:
            try:
                name = fetch_name(sid)
                break
            except (urllib.error.HTTPError, RuntimeError, subprocess.TimeoutExpired) as e:
                code = getattr(e, "code", None)
                if code in (403, 429, 503) and attempts < 6:
                    attempts += 1
                    wait = min(120.0, 10.0 * attempts)
                    print(f"  fetch error ({e}); sleeping {wait:.0f}s (retry {attempts}/6)", flush=True)
                    time.sleep(wait)
                    continue
                if attempts < 6 and isinstance(e, RuntimeError):
                    attempts += 1
                    wait = min(120.0, 10.0 * attempts)
                    print(f"  {e}; sleeping {wait:.0f}s (retry {attempts}/6)", flush=True)
                    time.sleep(wait)
                    continue
                raise
        data[key] = name or ""
        persist()
        time.sleep(max(0.0, args.sleep))

    empty = sum(1 for k in ids if not data.get(str(k)))
    print(f"wrote {OUT} ({len(data)} entries, {empty} empty among tip IDs)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
