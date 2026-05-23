#!/usr/bin/env python3
"""Generate Locales/ptBR.lua from enUS.lua (Phase B Brazilian Portuguese shell)."""
from __future__ import annotations

import re
import time
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
EN_PATH = ROOT / "Locales" / "enUS.lua"
OUT_PATH = ROOT / "Locales" / "ptBR.lua"
PACK_CODE = "ptBR"

CLASS_GEAR = re.compile(
    r"^GUIDE_GEAR_(MAGE|DK|DH|PRIEST|PALADIN|ROGUE|SHAMAN|WARRIOR|MONK|HUNTER|DRUID|WARLOCK|EVOKER)_"
)

TOKEN_RE = re.compile(
    r"(\|c[0-9a-fA-F]{8}|"
    r"\|r|"
    r"\|n|"
    r"%[sdq.]+|"
    r"\{SPELL:[^}]+\}|"
    r"\{[^}]+\})"
)


def should_include(key: str) -> bool:
    if key.startswith("GUIDE_ADVISOR_"):
        return False
    if CLASS_GEAR.match(key):
        return False
    return True


def parse_enus(path: Path) -> dict[str, str]:
    text = path.read_text(encoding="utf-8")
    entries: dict[str, str] = {}
    key_re = re.compile(r"^\t([A-Z][A-Z0-9_]+) = (.+)$", re.M)
    for m in key_re.finditer(text):
        key = m.group(1)
        rest = m.group(2).strip()
        if rest.startswith('"'):
            val_m = re.match(r'^"(.*)"[,]?\s*$', rest, re.S)
            if val_m:
                entries[key] = val_m.group(1)
            continue
        start = m.end()
        chunk = text[start:]
        lines = []
        for line in chunk.splitlines():
            if line.strip() == "}," or (
                re.match(r"^\t[A-Z][A-Z0-9_]+ = ", line) and lines
            ):
                break
            lines.append(line)
        body = "\n".join(lines)
        parts = re.findall(r'"([^"]*)"', body)
        joined = "".join(parts)
        if joined:
            entries[key] = joined
    return entries


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


def translate_batch(texts: list[str], translator) -> list[str]:
    out: list[str] = []
    for t in texts:
        if not t.strip():
            out.append(t)
            continue
        protected, tokens = protect(t)
        try:
            pt = translator.translate(protected)
        except Exception:
            pt = protected
        out.append(restore(pt, tokens))
        time.sleep(0.05)
    return out


def lua_escape(s: str) -> str:
    return s.replace("\\", "\\\\").replace('"', '\\"')


def lua_string(s: str) -> str:
    if "\n" in s:
        parts = s.split("\n")
        lines = ['\t"' + lua_escape(parts[0]) + '"']
        for p in parts[1:]:
            lines.append('\t\t.. "' + lua_escape(p) + '"')
        return "\n".join(lines)
    return '"' + lua_escape(s) + '"'


def main() -> None:
    from deep_translator import GoogleTranslator

    entries = parse_enus(EN_PATH)
    keys = [k for k in entries if should_include(k)]
    print(f"Translating {len(keys)} keys to Brazilian Portuguese…")

    translator = GoogleTranslator(source="en", target="pt")
    translated: dict[str, str] = {}
    batch_size = 40
    for i in range(0, len(keys), batch_size):
        batch_keys = keys[i : i + batch_size]
        batch_vals = [entries[k] for k in batch_keys]
        batch_pt = translate_batch(batch_vals, translator)
        for k, v in zip(batch_keys, batch_pt):
            translated[k] = v
        print(f"  {min(i + batch_size, len(keys))}/{len(keys)}")
        time.sleep(0.3)

    fixes = {
        "PRINT_PREFIX": "Midnight Helper:",
        "MAIN_TITLE": "Midnight Helper",
        "LOCALE_NAME_NL": "Nederlands (addon)",
        "LOCALE_AUTO_HINT": "Segue o idioma do cliente WoW se houver tradução; senão, inglês. Nederlands sempre manual.",
        "LANG_SLASH_HINT": "Use: /mh lang auto  |  /mh lang en  |  /mh lang de  |  /mh lang fr  |  /mh lang es  |  /mh lang pt  |  /mh lang nl",
        "UNKNOWN_COMMAND": "Comando desconhecido %q. Use: /mh, /mh coach, /mh debug, /mh guide, /mh settings, /mh lang auto|en|de|fr|es|pt|nl.",
        "LANG_ROW_PT_TOOLTIP": "Português (BR)",
        "TAB_DELVES": "Profundidades & Câmara",
        "SEARCH_CHAT_TAB_DELVES": "Aba aberta: Profundidades e Grande Câmara",
        "DELVES_BTN_BOUNTIFUL": "Encontrar a profundidade opulenta mais próxima",
        "DELVES_ROW_ROUTE_BTN": "Clique na linha: rota para essa profundidade opulenta (TomTom).",
        "DELVES_BOUNTIFUL_ROUTE": "|cffffff78Midnight Helper:|r TomTom: profundidade opulenta mais próxima — %s",
        "DELVES_TITLE": "Profundidades Midnight",
        "DELVES_ACC_MIDNIGHT": "Profundidades Midnight",
        "DELVES_ACC_VAULT": "Grande Câmara (mundo)",
        "DELVES_JOURNEY_RANK": "Jornada das profundidades: ranque %d (%d / %d)",
        "DELVES_HINT_SHIFT_J": "Pressione |cffffff00SHIFT-J|r — Guia de aventura (Grande Câmara, |cff00ffffJornada das profundidades|r, Profundidades, Presa).",
        "ALT_OVERVIEW_HINT": "Salvo por personagem ao entrar / atualizar moedas.",
        "ALT_SNAPSHOT_SORT_LEVEL": "Ordem: nível",
        "ALT_SNAPSHOT_SORT_NAME": "Ordem: pers.",
        "ALT_SNAPSHOT_SORT_KEYS": "Ordem: chaves",
        "ALT_SNAPSHOT_SORT_SHARDS": "Ordem: shards",
        "ALT_SNAPSHOT_SORT_UNDER": "Ordem: undercoins",
        "ALT_SNAPSHOT_SORT_UPDATED": "Ordem: atual.",
        "ALT_SNAPSHOT_FILTER_STALE": "Relog necessário",
        "ALT_SNAPSHOT_FILTER_STALE_ON": "Relog necessário: SIM",
        "ALT_SNAPSHOT_FILTER_KEYS": "Com chaves",
        "ALT_SNAPSHOT_FILTER_KEYS_ON": "Com chaves: SIM",
        "ALT_VAULT_RAIDS": "Raides",
        "ALT_VAULT_TOOLTIP_TITLE": "Grande Câmara",
        "ALT_TOOLTIP_KEYS": "Chave de cofre restaurada: %d",
        "ALT_COL_KEYS_HINT": "Chaves de cofre restauradas na bolsa deste personagem (salvas no último login).",
        "VAULT_REMINDER_TOOLTIP_TITLE": "Grande Câmara — resgatar ou verificar",
        "VAULT_REMINDER_TOOLTIP_OPEN_HINT": "SHIFT-J → Guia de aventura → Grande Câmara",
        "DELVE_COACH_PICKER_TITLE": "Escolher profundidade",
        "DELVE_SHARE_BTN_BRIEF": "Compartilhar resumo",
        "DELVE_SHARE_COPY_CLOSE": "Fechar",
        "LOCALE_NAME_ptBR": "Português",
    }
    translated.update(fixes)

    lines = [
        "--[[",
        "\tMidnight Helper — Brazilian Portuguese locale shell (Phase B).",
        "\tLoad order: after esES.lua, before nlNL.lua.",
        "",
        "\tNon-advisor keys inherit from enUS where not overridden.",
        "\tGUIDE_ADVISOR_* and per-spec GUIDE_GEAR_*: GuideAdvisor.lua (Phase C).",
        "\tDelve tip bodies: DelveTips.lua (merged at load).",
        "]]",
        "",
        "local _, ns = ...",
        "",
        "ns._mhLocales = ns._mhLocales or {}",
        "",
        "local OVERRIDES = {",
    ]
    for k in keys:
        v = translated[k]
        if "\n" in v:
            lines.append(f"\t{k} =")
            lines.append(lua_string(v) + ",")
        else:
            lines.append(f"\t{k} = {lua_string(v)},")
    lines += [
        "}",
        "",
        "local function shouldCopyFromEnUS(key)",
        '\tif type(key) ~= "string" then',
        "\t\treturn false",
        "\tend",
        '\tif key:match("^GUIDE_ADVISOR_") then',
        "\t\treturn false",
        "\tend",
        '\tif key:match("^GUIDE_GEAR_(MAGE|DK|DH|PRIEST|PALADIN|ROGUE|SHAMAN|WARRIOR|MONK|HUNTER|DRUID|WARLOCK|EVOKER)_") then',
        "\t\treturn false",
        "\tend",
        "\treturn true",
        "end",
        "",
        "local pack = {}",
        "local en = ns._mhLocales.enUS",
        'if type(en) == "table" then',
        "\tfor key, value in pairs(en) do",
        "\t\tif shouldCopyFromEnUS(key) and type(value) == \"string\" then",
        "\t\t\tpack[key] = OVERRIDES[key] or value",
        "\t\tend",
        "\tend",
        "end",
        "for key, value in pairs(OVERRIDES) do",
        "\tpack[key] = value",
        "end",
        "",
        f"ns._mhLocales.{PACK_CODE} = pack",
        "",
    ]
    OUT_PATH.write_text("\n".join(lines) + "\n", encoding="utf-8")
    print(f"Wrote {OUT_PATH} ({len(translated)} overrides)")


if __name__ == "__main__":
    main()
