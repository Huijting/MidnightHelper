#!/usr/bin/env python3
"""Generate Modules/VaultAdvisorData.lua from data/vault_stat_priorities.json.

Guide stat order (Icy Veins / Wowhead / Method) is stored in JSON; this script
turns that order into relative secondary weights for the in-game vault advisor.
"""

from __future__ import annotations

import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
HERO_JSON = ROOT / "data" / "vault_hero_subtrees.json"
STAT_NAMES = ("mastery", "haste", "crit", "vers")
TIER_WEIGHTS = (1.0, 0.92, 0.84, 0.55)


def priority_to_weights(priority: list[str], ties: list[list[str]] | None = None) -> dict[str, float]:
    ties = ties or []
    rank: dict[str, int] = {}
    for i, stat in enumerate(priority):
        if stat not in STAT_NAMES:
            raise ValueError(f"Unknown stat {stat!r} in {priority}")
        rank[stat] = i

    for group in ties:
        best = min(rank[s] for s in group)
        for s in group:
            rank[s] = best

    weights = {s: 0.0 for s in STAT_NAMES}
    for stat, r in rank.items():
        weights[stat] = TIER_WEIGHTS[min(r, len(TIER_WEIGHTS) - 1)]
    return weights


def lua_escape(s: str) -> str:
    return s.replace("\\", "\\\\").replace('"', '\\"')


def emit_weights_table(weights: dict[str, float], indent: str) -> list[str]:
    lines = [f"{indent}{{"]
    for stat in STAT_NAMES:
        lines.append(f"{indent}\t{stat} = {weights[stat]:.2f},")
    lines.append(f"{indent}}},")
    return lines


def main() -> int:
    src = Path(sys.argv[1]) if len(sys.argv) > 1 else ROOT / "data" / "vault_stat_priorities.json"
    out = ROOT / "Modules" / "VaultAdvisorData.lua"
    if not src.is_file():
        print(f"Missing: {src}", file=sys.stderr)
        return 1

    data = json.loads(src.read_text(encoding="utf-8"))
    patch = data.get("patch") or "?"
    entries = data.get("entries") or []

    lines: list[str] = [
        "--[[",
        "\tMidnight Helper — Great Vault Advisor stat weights.",
        f"\tAUTO-GENERATED from {src.relative_to(ROOT).as_posix()} (patch {patch}).",
        "\tEdit the JSON and run: python tools/generate_vault_stat_weights.py",
        "\tPrimary stat / item level handled in VaultAdvisor.lua.",
        "]]",
        "",
        "local _, ns = ...",
        "",
        "--- Relative weights for secondary stats (from guide priority order, not SimC/Pawn).",
        "ns.VAULT_ADVISOR_SPEC_WEIGHTS = {",
    ]

    meta_lines = [
        "",
        "--- Guide text and sources per weight key (shown in vault advisor UI).",
        "ns.VAULT_ADVISOR_SPEC_META = {",
    ]

    for entry in entries:
        key = entry["key"]
        priority = entry["priority"]
        ties = entry.get("ties")
        weights = priority_to_weights(priority, ties)
        label = entry.get("label") or key
        priority_text = entry.get("priorityText") or " > ".join(priority)
        sources = entry.get("sources") or []
        source_names = ", ".join(s["name"] for s in sources if s.get("name"))

        lines.append(f'\t--- {label}: {priority_text}')
        for src_item in sources:
            url = src_item.get("url")
            name = src_item.get("name")
            if url and name:
                lines.append(f"\t--- {name}: {url}")
        lines.append(f'\t["{key}"] = {{')
        for stat in STAT_NAMES:
            lines.append(f"\t\t{stat} = {weights[stat]:.2f},")
        lines.append("\t},")

        meta_lines.append(f'\t["{key}"] = {{')
        meta_lines.append(f'\t\tpriorityText = "{lua_escape(priority_text)}",')
        meta_lines.append(f'\t\tsources = "{lua_escape(source_names)}",')
        meta_lines.append(f'\t\tpatch = "{lua_escape(str(patch))}",')
        meta_lines.append("\t},")

    lines.append("}")
    meta_lines.append("}")
    lines.extend(meta_lines)

    if HERO_JSON.is_file():
        heroes = json.loads(HERO_JSON.read_text(encoding="utf-8")).get("heroes") or {}
        lines.extend(
            [
                "",
                "--- Hero talent SubTreeID labels (C_ClassTalents.GetActiveHeroTalentSpec).",
                "ns.VAULT_ADVISOR_HERO_NAMES = {",
            ]
        )
        for hid in sorted(heroes, key=lambda x: int(x)):
            name = lua_escape(str(heroes[hid]))
            lines.append(f"\t[{hid}] = \"{name}\",")
        lines.append("}")
        lines.append("")
    lines.extend(
        [
            "",
            "--- ilvl is weighted heavily because guides treat item level as primary for upgrades.",
            # The patch as one constant, so the Pawn export can stamp it into the scale
            # NAME. That string leaves the addon and never comes back — it sits in Pawn
            # ranking someone's gear for months with nothing to say which patch it was
            # written for. Generated rather than hand-written so it cannot drift from the
            # data it describes.
            f'ns.VAULT_ADVISOR_PATCH = "{patch}"',
            "ns.VAULT_ADVISOR_ILVL_WEIGHT = 8",
            "",
            "--- Activity types from Enum.WeeklyRewardChestThresholdType (C_WeeklyRewards.GetActivities).",
            "ns.VAULT_ADVISOR_ACTIVITY_TYPES = {",
            "\t[1] = \"dungeon\",",
            "\t[2] = \"pvp\",",
            "\t[3] = \"raid\",",
            "\t[4] = \"also\",",
            "\t[5] = \"concession\",",
            "\t[6] = \"world\",",
            "}",
            "",
        ]
    )

    # ⚠️ ATOMIC, AND THIS ONE IS NOT OPTIONAL. `out` is Modules/VaultAdvisorData.lua, which
    # lives in the running game folder — the repo IS the live AddOns directory. A plain
    # write_text truncates first and writes after, so a player logging in during that
    # window loads a Lua file that stops mid-table. That is not hypothetical: it happened
    # to Locales/enUS.lua on 22 July 2026 and rendered raw keys in Rob's Great Vault popup.
    # Rename is atomic, so the game sees the old file or the new one and never a half.
    tmp = out.with_suffix(out.suffix + ".tmp")
    tmp.write_text("\n".join(lines), encoding="utf-8", newline="\n")
    tmp.replace(out)
    print(f"Wrote {out} ({len(entries)} spec entries, patch {patch})")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
