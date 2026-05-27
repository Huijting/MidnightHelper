#!/usr/bin/env python3
"""List Icy Veins stat-priority-widget counts per spec slug."""

import json
import re
import time
import urllib.request
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
CATALOG = ROOT / "data" / "vault_stat_catalog.json"

STAT_MAP = {
    "crit": "crit",
    "haste": "haste",
    "mastery": "mastery",
    "versatility": "vers",
    "ilevel": None,
}


def parse_widgets(html: str) -> list[list[str]]:
    starts = [m.start() for m in re.finditer(r'<div class="stat-priority-widget">', html)]
    out: list[list[str]] = []
    for start in starts:
        block = html[start : start + 8000]
        sec: list[str] = []
        for token in re.findall(r"stat-container\s+([\w-]+)", block):
            s = STAT_MAP.get(token)
            if s and s not in sec:
                sec.append(s)
        if len(sec) >= 3:
            while len(sec) < 4:
                for s in ("vers", "haste", "crit", "mastery"):
                    if s not in sec:
                        sec.append(s)
                        break
            out.append(sec[:4])
    return out


def main() -> None:
    catalog = json.loads(CATALOG.read_text(encoding="utf-8"))
    multi = []
    for spec in catalog["specs"]:
        slug = spec["icyVeinsUrl"].rsplit("/", 1)[-1]
        req = urllib.request.Request(
            spec["icyVeinsUrl"],
            headers={"User-Agent": "MidnightHelper/1.0"},
        )
        html = urllib.request.urlopen(req, timeout=45).read().decode("utf-8", "replace")
        widgets = parse_widgets(html)
        if len(widgets) > 1:
            multi.append(
                {
                    "key": f"{spec['class']}_{spec['specID']}",
                    "slug": slug,
                    "widgets": widgets,
                }
            )
            print(f"{spec['class']}_{spec['specID']}: {len(widgets)} widgets -> {widgets}")
        time.sleep(0.3)
    out = ROOT / "data" / "vault_multi_widget_specs.json"
    out.write_text(json.dumps(multi, indent=2) + "\n", encoding="utf-8")
    print(f"\nWrote {out} ({len(multi)} specs with multiple widgets)")


if __name__ == "__main__":
    main()
