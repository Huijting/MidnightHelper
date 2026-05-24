#!/usr/bin/env python3
"""Polish player-facing formality and Blizzard terms in locale Lua files."""
from __future__ import annotations

import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

# Order matters: longer / more specific phrases first.
DE_REPLACEMENTS = [
    ("TAB_DELVES = \"Delves & Vault\"", "TAB_DELVES = \"Tiefen & Schatzkammer\""),
    (
        "SEARCH_CHAT_TAB_DELVES = \"Geöffneter Tab: Delves & Vault\"",
        "SEARCH_CHAT_TAB_DELVES = \"Tab geöffnet: Tiefen & Schatzkammer\"",
    ),
    ("Tauchtipps", "Tiefentipps"),
    ("Tauchtip", "Tiefentipp"),
    ("Tauchtipp", "Tiefentipp"),
    ("Tauchtipzeilen", "Tiefentipp-Zeilen"),
    ("Delve-Tipps", "Tiefentipps"),
    ("Delve Coach", "Tiefen-Coach"),
    ("Delve Party Share", "Tiefen-Gruppenteilen"),
    ("Midnight Delves", "Midnight-Tiefen"),
    ("Delves-Kommandozentrale", "Tiefen-Kommandozentrale"),
    ("Delver's Journey", "Reise des Tiefenforschers"),
    ("Delvers Reise", "Reise des Tiefenforschers"),
    ("Öffnen Sie", "Öffne"),
    ("Verwenden Sie", "Nutze"),
    ("Wählen Sie", "Wähle"),
    ("Klicken Sie", "Klicke"),
    ("Drücken Sie", "Drücke"),
    ("Sagen Sie", "Sag"),
    ("Probieren Sie", "Probiere"),
    ("Geben Sie", "Gib"),
    ("Warten Sie", "Warte"),
    ("Schließen Sie", "Schließe"),
    ("Ziehen Sie", "Ziehe"),
    ("Scrollen Sie", "Scrolle"),
    ("Bewegen Sie", "Bewege"),
    ("Melden Sie", "Logge"),
    ("Entfernen Sie", "Entferne"),
    ("Setzen Sie", "Setze"),
    ("Optimieren Sie", "Stelle ein"),
    ("Stellen Sie sich", "Stell dich"),
    ("Erweitern Sie", "Erweitere"),
    ("Sehen Sie sich", "Sieh dir"),
    ("Versenden Sie", "Sende"),
    ("Treten Sie", "Tritt"),
    ("Aktivieren Sie", "Aktiviere"),
    ("Installieren Sie", "Installiere"),
    ("Protokollieren Sie", "Logge"),
    ("Suchen Sie", "Suche"),
    ("Vergessen Sie", "Vergiss"),
    ("Halten Sie", "Halte"),
    ("Beginnen Sie", "Beginne"),
    ("Lassen Sie", "Lass"),
    ("Verwenden Sie", "Nutze"),
    ("Benutzen Sie", "Benutze"),
    ("Fügen Sie", "Füge"),
    ("Behalten Sie", "Behalte"),
    ("Priorisieren Sie", "Priorisiere"),
    ("klicken Sie", "klicke"),
    ("versuchen Sie", "versuche"),
    ("warten Sie", "warte"),
    ("Ihre Aufgabe", "Deine Aufgabe"),
    ("Ihre ", "Deine "),
    ("Ihr ", "Dein "),
    ("Ihnen ", "dir "),
    (" Sie ", " du "),
    (" sie ", " du "),
]

FR_REPLACEMENTS = [
    ("Delve Coach", "Coach des gouffres"),
    ("Delve Party Share", "Partage de conseils en groupe"),
    ("Ouvrez ", "Ouvre "),
    ("Utilisez ", "Utilise "),
    ("Cliquez ", "Clique "),
    ("Copiez ", "Copie "),
    ("Choisissez ", "Choisis "),
    ("Appuyez ", "Appuie "),
    ("Faites glisser", "Fais glisser"),
    ("Faites défiler", "Fais défiler"),
    ("Attendez ", "Attends "),
    ("Essayez ", "Essaie "),
    ("Rejoignez ", "Rejoins "),
    ("Signalez ", "Signale "),
    ("Supprimez ", "Supprime "),
    ("Connectez-vous", "Connecte-toi"),
    ("connectez-vous", "connecte-toi"),
    ("Cachez-vous", "Cache"),
    ("N'oubliez pas", "N'oublie pas"),
    ("ne le gardez pas", "ne le garde pas"),
    ("vous êtes", "tu es"),
    ("vous avez", "tu as"),
    ("vous pouvez", "tu peux"),
    ("vous aide", "t'aide"),
    ("vous donne", "te donne"),
    ("vous emmène", "t'emmène"),
    ("vous souhaitez", "tu souhaites"),
    ("vos ", "tes "),
    ("votre ", "ton "),
    ("Votre ", "Ton "),
    (" vous ", " tu "),
    (" Vous ", " Tu "),
]

ES_REPLACEMENTS = [
    ("Delve Coach", "Entrenador de profundidades"),
    ("Delve Party Share", "Compartir consejos en grupo"),
    ("Delve Coach:", "Entrenador de profundidades:"),
    ("autocar Delve", "entrenador de profundidades"),
    ("Entrenador Delve", "Entrenador de profundidades"),
    ("profundización", "profundidad"),
    ("profundizaciones", "profundidades"),
    ("Delves,", "Profundidades,"),
    ("Delves ", "Profundidades "),
    ("Delves.", "Profundidades."),
    ("Delves\\", "Profundidades\\"),
]

PT_REPLACEMENTS = [
    ("Delve Coach", "Treinador de profundidades"),
    ("Delve Party Share", "Compartilhar dicas em grupo"),
    ("Delves,", "Profundidades,"),
]

RU_REPLACEMENTS = [
    ("Delve Coach", "Тренер глубин"),
    ("Delve Party Share", "Обмен советами в группе"),
]


# Fixes bad merges when "Sie" appeared inside longer words/phrases.
DE_FIXUPS = [
    ("Nehmen du ", "Nimm "),
    ("Aktualisieren du ", "Aktualisiere "),
    ("wissen Sie,", "lerne,"),
    ("wissen Sie ", "lerne "),
    ("vermeiden Sie,", "vermeide,"),
    ("vermeiden Sie ", "vermeide "),
    ("beobachten Sie,", "beobachte,"),
    ("beobachten Sie ", "beobachte "),
    ("lernen Sie,", "lerne,"),
    ("lernen Sie ", "lerne "),
    ("Versuchen Sie,", "Versuche,"),
    ("Versuchen Sie ", "Versuche "),
    ("Retten Sie,", "Rette,"),
    ("Sie können ", "Du kannst "),
    ("Sie sollten ", "Du solltest "),
    ("als Sie", "als du"),
    ("Ihrer ", "deiner "),
    ("Qualität Ihrer ", "Qualität deiner "),
    ("Dauer Ihrer ", "Dauer deiner "),
    ("möchten", "möchtest"),
    ("Dein ", "dein "),
    ("Deine ", "deine "),
]


def apply_replacements(text: str, pairs: list[tuple[str, str]]) -> str:
    for old, new in pairs:
        text = text.replace(old, new)
    return text


def polish_file(path: Path, pairs: list[tuple[str, str]]) -> int:
    before = path.read_text(encoding="utf-8")
    after = apply_replacements(before, pairs)
    if pairs == DE_REPLACEMENTS:
        after = apply_replacements(after, DE_FIXUPS)
    # de: fix accidental double-du
    after = re.sub(r"\bdu kannst du\b", "du kannst", after)
    after = re.sub(r"\bdu du\b", "du", after)
    if after != before:
        path.write_text(after, encoding="utf-8")
        return 1
    return 0


def main() -> int:
    targets = {
        "de": (
            DE_REPLACEMENTS,
            [
                ROOT / "Locales" / "deDE.lua",
                ROOT / "Locales" / "GuideTips.lua",
                ROOT / "Locales" / "DelveTips.lua",
                ROOT / "Locales" / "GuideAdvisor.lua",
            ],
        ),
        "fr": (
            FR_REPLACEMENTS,
            [
                ROOT / "Locales" / "frFR.lua",
                ROOT / "Locales" / "GuideAdvisor.lua",
                ROOT / "Locales" / "GuideTips.lua",
                ROOT / "Locales" / "DelveTips.lua",
            ],
        ),
        "es": (
            ES_REPLACEMENTS,
            [ROOT / "Locales" / "esES.lua", ROOT / "Locales" / "DelveTips.lua", ROOT / "Locales" / "GuideTips.lua"],
        ),
        "pt": (
            PT_REPLACEMENTS,
            [ROOT / "Locales" / "ptBR.lua", ROOT / "Locales" / "GuideAdvisor.lua", ROOT / "Locales" / "GuideTips.lua"],
        ),
    }
    langs = sys.argv[1:] if len(sys.argv) > 1 else list(targets.keys())
    changed = 0
    for lang in langs:
        if lang not in targets:
            print("Unknown lang:", lang, file=sys.stderr)
            continue
        pairs, files = targets[lang]
        for path in files:
            if not path.exists():
                print("skip (missing):", path)
                continue
            if polish_file(path, pairs):
                print("polished:", path.relative_to(ROOT))
                changed += 1
            else:
                print("unchanged:", path.relative_to(ROOT))
    return 0 if changed >= 0 else 1


if __name__ == "__main__":
    raise SystemExit(main())
