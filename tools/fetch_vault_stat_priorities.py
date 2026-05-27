#!/usr/bin/env python3
"""Fetch Icy Veins stat-priority-widget order and merge into vault_stat_priorities.json."""

from __future__ import annotations

import json
import re
import time
import urllib.error
import urllib.request
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
OUT_JSON = ROOT / "data" / "vault_stat_priorities.json"
CATALOG = ROOT / "data" / "vault_stat_catalog.json"

STAT_MAP = {
    "crit": "crit",
    "critical": "crit",
    "haste": "haste",
    "mastery": "mastery",
    "vers": "vers",
    "versatility": "vers",
    "ilevel": None,
    "ilvl": None,
    "item-level": None,
}


def parse_icy_veins_widget(html: str, widget_index: int = 0) -> list[str] | None:
    """Parse Icy Veins stat-priority-widget (Item Level > secondaries). widget_index for multi-hero pages."""
    starts = [m.start() for m in re.finditer(r'<div class="stat-priority-widget">', html)]
    if not starts:
        return None
    if widget_index >= len(starts):
        widget_index = 0
    block = html[starts[widget_index] : starts[widget_index] + 8000]
    raw: list[str] = re.findall(r"stat-container\s+([\w-]+)", block)
    secondaries: list[str] = []
    for token in raw:
        key = STAT_MAP.get(token)
        if key and key not in secondaries:
            secondaries.append(key)
    if len(secondaries) < 3:
        return None
    while len(secondaries) < 4:
        for s in ("vers", "haste", "crit", "mastery"):
            if s not in secondaries:
                secondaries.append(s)
                break
    return secondaries[:4]


def parse_icy_veins_numbered_list(html: str) -> list[str] | None:
    """Fallback when the stat-priority-widget is missing (e.g. Shadow Priest)."""
    idx = html.find("Stat Priority")
    if idx < 0:
        return None
    chunk = html[idx : idx + 20000]
    name_to_stat = {
        "mastery": "mastery",
        "haste": "haste",
        "critical strike": "crit",
        "crit": "crit",
        "versatility": "vers",
    }
    secondaries: list[str] = []
    for m in re.finditer(r"<li>\s*\d+\.\s*([^<]+?)\s*</li>", chunk, re.I):
        label = re.sub(r"\s+", " ", m.group(1)).strip().lower()
        label = re.sub(r"\s*\(.*\)$", "", label).strip()
        if label in ("intellect", "agility", "strength", "item level"):
            continue
        stat = name_to_stat.get(label)
        if stat and stat not in secondaries:
            secondaries.append(stat)
        if len(secondaries) >= 4:
            break
    return secondaries if len(secondaries) >= 3 else None


def fetch_url(url: str) -> str:
    req = urllib.request.Request(url, headers={"User-Agent": "MidnightHelper/1.0 (vault stat fetch)"})
    with urllib.request.urlopen(req, timeout=45) as resp:
        return resp.read().decode("utf-8", "replace")


def wowhead_stat_url(class_slug: str, spec_slug: str, role: str) -> str:
    suffix = {"dps": "pve-dps", "healer": "pve-healing", "tank": "pve-tank"}[role]
    return f"https://www.wowhead.com/guide/classes/{class_slug}/{spec_slug}/stat-priority-{suffix}"


def build_entry(
    spec: dict,
    priority: list[str],
    priority_text: str | None = None,
    *,
    key_suffix: str = "",
    label_suffix: str = "",
) -> dict:
    key = f"{spec['class']}_{spec['specID']}{key_suffix}"
    label = (spec["label"] or key) + label_suffix
    role = spec["role"]
    pt = priority_text or _default_priority_text(spec.get("primary"), priority)
    sources = [
        {"name": "Icy Veins", "url": spec["icyVeinsUrl"]},
        {
            "name": "Wowhead",
            "url": wowhead_stat_url(spec["wowheadClass"], spec["wowheadSpec"], role),
        },
    ]
    entry: dict = {
        "key": key,
        "class": spec["class"],
        "specID": spec["specID"],
        "label": label,
        "priority": priority,
        "priorityText": pt,
        "sources": sources,
    }
    if spec.get("ties"):
        entry["ties"] = spec["ties"]
    return entry


def _default_priority_text(primary: str | None, priority: list[str]) -> str:
    names = {"mastery": "Mastery", "haste": "Haste", "crit": "Crit", "vers": "Vers"}
    sec = " > ".join(names[s] for s in priority)
    if primary:
        return f"{primary} > {sec}"
    return sec


def main() -> int:
    if not CATALOG.is_file():
        print(f"Missing catalog: {CATALOG}", file=__import__("sys").stderr)
        return 1

    catalog = json.loads(CATALOG.read_text(encoding="utf-8"))
    patch = catalog.get("patch") or "12.0.5"
    specs = catalog["specs"]
    hero_entries: list[dict] = list(catalog.get("heroEntries") or [])
    hero_keys_seen = {e["key"] for e in hero_entries}
    existing = {}
    if OUT_JSON.is_file():
        old = json.loads(OUT_JSON.read_text(encoding="utf-8"))
        for e in old.get("entries") or []:
            if "_HERO_" not in e.get("key", ""):
                existing[e["key"]] = e

    entries: list[dict] = []
    failed: list[str] = []

    for spec in specs:
        key = f"{spec['class']}_{spec['specID']}"
        url = spec["icyVeinsUrl"]
        try:
            html = fetch_url(url)
            widget_index = int(spec.get("icyVeinsWidgetIndex") or 0)
            priority = parse_icy_veins_widget(html, widget_index)
            if not priority:
                priority = parse_icy_veins_numbered_list(html)
            if not priority:
                raise ValueError("no stat-priority-widget")
            pt = spec.get("priorityText")
            if not pt:
                names = {"mastery": "Mastery", "haste": "Haste", "crit": "Crit", "vers": "Vers"}
                sec = " > ".join(names[s] for s in priority)
                primary = spec.get("primary")
                pt = f"{primary} > {sec}" if primary else sec
            entry = build_entry(spec, priority, pt)
            if spec.get("ties"):
                entry["ties"] = spec["ties"]
            if spec.get("priorityText"):
                entry["priorityText"] = spec["priorityText"]
            entries.append(entry)
            print(f"OK  {key}: {' > '.join(priority)}")

            for ht in spec.get("heroTalents") or []:
                hero_id = ht["heroID"]
                hkey = f"{spec['class']}_{spec['specID']}_HERO_{hero_id}"
                if hkey in hero_keys_seen:
                    continue
                hp = parse_icy_veins_widget(html, int(ht.get("widgetIndex") or 0))
                if not hp:
                    continue
                hlabel = ht.get("label") or f"Hero {hero_id}"
                he = build_entry(
                    spec,
                    hp,
                    spec.get("priorityText"),
                    key_suffix=f"_HERO_{hero_id}",
                    label_suffix=f" ({hlabel})",
                )
                he["heroID"] = hero_id
                if ht.get("ties"):
                    he["ties"] = ht["ties"]
                hero_entries.append(he)
                hero_keys_seen.add(hkey)
                print(f"  HERO {hkey}: {' > '.join(hp)}")

            mplus = (spec.get("profiles") or {}).get("mplus")
            if mplus:
                mp_key = f"{key}_MPLUS"
                if mp_key not in {e["key"] for e in entries}:
                    mp_priority = mplus.get("priority")
                    if mp_priority is None and mplus.get("widgetIndex") is not None:
                        mp_priority = parse_icy_veins_widget(html, int(mplus["widgetIndex"]))
                    if mp_priority:
                        mp_entry = build_entry(
                            spec,
                            mp_priority,
                            mplus.get("priorityText"),
                            key_suffix="_MPLUS",
                            label_suffix=" (M+)",
                        )
                        if mplus.get("ties"):
                            mp_entry["ties"] = mplus["ties"]
                        if mplus.get("priorityText"):
                            mp_entry["priorityText"] = mplus["priorityText"]
                        entries.append(mp_entry)
                        print(f"  MPLUS {mp_key}: {' > '.join(mp_priority)}")
        except (urllib.error.URLError, ValueError, TimeoutError) as exc:
            if spec.get("fallbackPriority"):
                entry = build_entry(spec, spec["fallbackPriority"], spec.get("priorityText"))
                if spec.get("ties"):
                    entry["ties"] = spec["ties"]
                if spec.get("priorityText"):
                    entry["priorityText"] = spec["priorityText"]
                entries.append(entry)
                print(f"FALL {key}: {' > '.join(spec['fallbackPriority'])} ({exc})")
            elif key in existing:
                entries.append(existing[key])
                print(f"KEEP {key} (fetch failed: {exc})")
            else:
                failed.append(key)
                print(f"FAIL {key}: {exc}")
        time.sleep(0.35)

    entries.extend(hero_entries)
    entries.sort(key=lambda e: (e["class"], e["specID"], e.get("heroID") or 0, e["key"]))

    out = {
        "patch": patch,
        "note": "Secondary stat order from Icy Veins stat-priority-widget (Midnight). "
        "Regenerate: python tools/fetch_vault_stat_priorities.py && python tools/generate_vault_stat_weights.py",
        "entries": entries,
    }
    OUT_JSON.write_text(json.dumps(out, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    print(f"\nWrote {len(entries)} entries to {OUT_JSON}")
    if failed:
        print("Failed specs:", ", ".join(failed))
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
