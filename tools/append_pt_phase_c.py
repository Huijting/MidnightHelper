#!/usr/bin/env python3
"""Append ptBR Phase C block to Locales/GuideAdvisor.lua (without regenerating DE/FR/ES)."""
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


def main() -> None:
    from deep_translator import GoogleTranslator

    text = OUT_PATH.read_text(encoding="utf-8")
    if "ptBR_PHASE_C" in text or "merge(ns._mhLocales.ptBR" in text:
        print("ptBR Phase C already in GuideAdvisor.lua")
        return

    pairs = parse_enus_keys(EN_PATH)
    print(f"Translating {len(pairs)} keys to ptBR…")
    tr = GoogleTranslator(source="en", target="pt")
    lines = ["", "local ptBR_PHASE_C = {"]
    batch = 25
    for i in range(0, len(pairs), batch):
        chunk = pairs[i : i + batch]
        protected = []
        token_lists = []
        for _, v in chunk:
            p, tok = protect(v)
            protected.append(p)
            token_lists.append(tok)
        try:
            translated = tr.translate_batch(protected)
        except Exception:
            translated = []
            for p in protected:
                try:
                    translated.append(tr.translate(p))
                except Exception:
                    translated.append(p)
                time.sleep(0.08)
        for (key, _), pt, tokens in zip(chunk, translated, token_lists):
            lines.append(f'\t["{key}"] = "{lua_escape(restore(pt or "", tokens))}",')
        print(f"  ptBR {min(i + batch, len(pairs))}/{len(pairs)}")
        time.sleep(0.25)
    lines.append("}")
    lines.append("")
    lines.append("merge(ns._mhLocales.ptBR, ptBR_PHASE_C)")
    lines.append("")

    header = text.replace(
        "Merged into deDE, frFR, esES at load.",
        "Merged into deDE, frFR, esES, ptBR at load.",
    )
    OUT_PATH.write_text(header.rstrip() + "\n".join(lines) + "\n", encoding="utf-8")
    print(f"Appended ptBR to {OUT_PATH}")


if __name__ == "__main__":
    main()
