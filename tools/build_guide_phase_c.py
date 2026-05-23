#!/usr/bin/env python3
"""Generate Locales/GuideAdvisor.lua — Phase C advisor + per-spec gear merges."""
from __future__ import annotations

import re
import time
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
EN_PATH = ROOT / "Locales" / "enUS.lua"
OUT_PATH = ROOT / "Locales" / "GuideAdvisor.lua"

GEAR_CLASS_RE = re.compile(
    r"^GUIDE_GEAR_(MAGE|DK|DH|PRIEST|PALADIN|ROGUE|SHAMAN|WARRIOR|MONK|HUNTER|DRUID|WARLOCK|EVOKER)_"
)
ADVISOR_RE = re.compile(r"^GUIDE_ADVISOR_")

TOKEN_RE = re.compile(
    r"(\|c[0-9a-fA-F]{8}[^|]*\|r|"
    r"\|n|"
    r"%[sdq.]+|"
    r"\{SPELL:[^}]+\}|"
    r"\{[^}]+\})"
)

LOCALES = [
    ("deDE", "de"),
    ("frFR", "fr"),
    ("esES", "es"),
]


def parse_enus_keys(path: Path) -> list[tuple[str, str]]:
    text = path.read_text(encoding="utf-8")
    out: list[tuple[str, str]] = []
    for m in re.finditer(r"^\t([A-Z][A-Z0-9_]+) = (.+)$", text, re.M):
        key = m.group(1)
        if not (ADVISOR_RE.match(key) or GEAR_CLASS_RE.match(key)):
            continue
        rest = m.group(2).strip()
        if rest.startswith('"'):
            val_m = re.match(r'^"(.*)"[,]?\s*$', rest, re.S)
            if val_m:
                out.append((key, val_m.group(1).replace("\\n", "\n")))
    return out


def protect(s: str) -> tuple[str, list[str]]:
    tokens: list[str] = []

    def repl(m: re.Match[str]) -> str:
        tokens.append(m.group(0))
        return f"__TK{len(tokens) - 1}__"

    return TOKEN_RE.sub(repl, s), tokens


def restore(s: str, tokens: list[str]) -> str:
    for i, tok in enumerate(tokens):
        s = s.replace(f"__TK{i}__", tok)
    return s


def lua_escape(s: str) -> str:
    return s.replace("\\", "\\\\").replace('"', '\\"').replace("\n", "\\n")


def translate_pairs(
    pairs: list[tuple[str, str]], target: str, label: str
) -> list[tuple[str, str]]:
    from deep_translator import GoogleTranslator

    tr = GoogleTranslator(source="en", target=target)
    out: list[tuple[str, str]] = []
    batch = 25
    for i in range(0, len(pairs), batch):
        chunk = pairs[i : i + batch]
        protected_vals = []
        token_lists = []
        for _, v in chunk:
            p, tok = protect(v)
            protected_vals.append(p)
            token_lists.append(tok)
        try:
            translated = tr.translate_batch(protected_vals)
        except Exception:
            translated = protected_vals
        for (key, _), tr_text, tokens in zip(chunk, translated, token_lists):
            out.append((key, restore(tr_text or "", tokens)))
        print(f"  {label} {min(i + batch, len(pairs))}/{len(pairs)}")
        time.sleep(0.25)
    return out


def block(locale: str, pairs: list[tuple[str, str]]) -> str:
    lines = [f"merge(ns._mhLocales.{locale}, {{"]
    for k, v in pairs:
        lines.append(f'\t["{k}"] = "{lua_escape(v)}",')
    lines.append("})")
    return "\n".join(lines)


def main() -> None:
    pairs = parse_enus_keys(EN_PATH)
    print(f"Phase C: {len(pairs)} keys from enUS")

    parts = [
        "--[[",
        "\tMidnight Helper — Leveling advisor + per-spec gear (Phase C).",
        "\tMerged into deDE, frFR, esES at load. nlNL is complete in nlNL.lua.",
        "]]",
        "",
        "local _, ns = ...",
        "",
        "ns._mhLocales = ns._mhLocales or {}",
        "",
        "local function merge(into, keys)",
        '\tif type(into) ~= "table" or type(keys) ~= "table" then',
        "\t\treturn",
        "\tend",
        "\tfor k, v in pairs(keys) do",
        "\t\tinto[k] = v",
        "\tend",
        "end",
        "",
    ]

    for code, target in LOCALES:
        print(f"Translating {code}…")
        translated = translate_pairs(pairs, target, code)
        tbl_lines = [f"local {code}_PHASE_C = {{"]
        for k, v in translated:
            tbl_lines.append(f'\t["{k}"] = "{lua_escape(v)}",')
        tbl_lines.append("}")
        parts.append("\n".join(tbl_lines))
        parts.append(f"\nmerge(ns._mhLocales.{code}, {code}_PHASE_C)\n")

    OUT_PATH.write_text("\n".join(parts) + "\n", encoding="utf-8")
    print(f"Wrote {OUT_PATH}")


if __name__ == "__main__":
    main()
