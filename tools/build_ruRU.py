#!/usr/bin/env python3
"""Generate Locales/ruRU.lua from enUS.lua (Phase B Russian shell)."""
from __future__ import annotations

import re
import time
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
EN_PATH = ROOT / "Locales" / "enUS.lua"
OUT_PATH = ROOT / "Locales" / "ruRU.lua"
PACK_CODE = "ruRU"

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
        # Google sometimes Cyrillicizes TK placeholders (__ТК0__).
        s = s.replace(f"__ТК{i}__", tok)
    return re.sub(r"__T[KК](\d+)__", lambda m: tokens[int(m.group(1))] if int(m.group(1)) < len(tokens) else m.group(0), s)


def translate_batch(texts: list[str], translator) -> list[str]:
    out: list[str] = []
    for t in texts:
        if not t.strip():
            out.append(t)
            continue
        protected, tokens = protect(t)
        try:
            ru = translator.translate(protected)
        except Exception:
            ru = protected
        out.append(restore(ru, tokens))
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
    print(f"Translating {len(keys)} keys to Russian…")

    translator = GoogleTranslator(source="en", target="ru")
    translated: dict[str, str] = {}
    batch_size = 40
    for i in range(0, len(keys), batch_size):
        batch_keys = keys[i : i + batch_size]
        batch_vals = [entries[k] for k in batch_keys]
        batch_ru = translate_batch(batch_vals, translator)
        for k, v in zip(batch_keys, batch_ru):
            translated[k] = v
        print(f"  {min(i + batch_size, len(keys))}/{len(keys)}")
        time.sleep(0.3)

    fixes = {
        "PRINT_PREFIX": "Midnight Helper:",
        "MAIN_TITLE": "Midnight Helper",
        "LOCALE_NAME_NL": "Nederlands (addon)",
        "LOCALE_AUTO_HINT": "Следует языку клиента WoW, если есть перевод; иначе английский. Nederlands всегда вручную.",
        "LANG_SLASH_HINT": "Команды: /mh lang auto  |  /mh lang en  |  /mh lang de  |  /mh lang fr  |  /mh lang es  |  /mh lang pt  |  /mh lang ru  |  /mh lang nl",
        "UNKNOWN_COMMAND": "Неизвестная команда %q. Используйте: /mh, /mh coach, /mh debug, /mh guide, /mh settings, /mh lang auto|en|de|fr|es|pt|ru|nl.",
        "LANG_ROW_RU_TOOLTIP": "Русский",
        "TAB_DELVES": "Глубины · Хранилище",
        "SEARCH_CHAT_TAB_DELVES": "Открыта вкладка: Глубины и Великое Хранилище",
        "DELVES_BTN_BOUNTIFUL": "Найти ближайшую щедрую глубину",
        "DELVES_ROW_ROUTE_BTN": "Клик по строке: маршрут к этой щедрой глубине (TomTom).",
        "DELVES_BOUNTIFUL_ROUTE": "|cffffff78Midnight Helper:|r TomTom: ближайшая щедрая глубина — %s",
        "DELVES_TITLE": "Глубины Midnight",
        "DELVES_ACC_MIDNIGHT": "Глубины Midnight",
        "DELVES_ACC_VAULT": "Великое Хранилище (мир)",
        "DELVES_JOURNEY_RANK": "Путь искателя глубин: ранг %d (%d / %d)",
        "DELVES_HINT_SHIFT_J": "|cffffff00SHIFT-J|r — Путеводитель: Великое Хранилище, |cff00ffffпуть искателя глубин|r, глубины.",
        "DELVES_BTN_COACH": "Delve Coach (советы)",
        "ALT_OVERVIEW_HINT": "Сохраняется по персонажу при входе / обновлении валют.",
        "ALT_SNAPSHOT_SORT_LEVEL": "Сорт.: уровень",
        "ALT_SNAPSHOT_SORT_NAME": "Сорт.: имя",
        "ALT_SNAPSHOT_SORT_KEYS": "Сорт.: ключи",
        "ALT_SNAPSHOT_SORT_SHARDS": "Сорт.: shards",
        "ALT_SNAPSHOT_SORT_UNDER": "Сорт.: undercoins",
        "ALT_SNAPSHOT_SORT_UPDATED": "Сорт.: обновл.",
        "ALT_SNAPSHOT_FILTER_STALE": "Нужен релог",
        "ALT_SNAPSHOT_FILTER_STALE_ON": "Нужен релог: ДА",
        "ALT_SNAPSHOT_FILTER_KEYS": "С ключами",
        "ALT_SNAPSHOT_FILTER_KEYS_ON": "С ключами: ДА",
        "ALT_VAULT_RAIDS": "Рейды",
        "ALT_VAULT_TOOLTIP_TITLE": "Великое Хранилище",
        "ALT_TOOLTIP_KEYS": "Восстановленный ключ от сундука: %d",
        "ALT_COL_KEYS_HINT": "Восстановленные ключи в сумке этого персонажа (сохранены при последнем входе).",
        "VAULT_REMINDER_TOOLTIP_TITLE": "Великое Хранилище — забрать или проверить",
        "VAULT_REMINDER_TOOLTIP_OPEN_HINT": "SHIFT-J → Путеводитель → Великое Хранилище",
        "DELVE_COACH_PICKER_TITLE": "Выбрать глубину",
        "DELVE_SHARE_BTN_BRIEF": "Краткий обзор",
        "DELVE_SHARE_COPY_CLOSE": "Закрыть",
        "LOCALE_NAME_ruRU": "Русский",
    }
    translated.update(fixes)

    lines = [
        "--[[",
        "\tMidnight Helper — Russian locale shell (Phase B).",
        "\tLoad order: after ptBR.lua, before nlNL.lua.",
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
