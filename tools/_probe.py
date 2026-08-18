"""Scratch probe -- fixed path so the allowlist keeps matching (see CLAUDE.md).

Today: the .toc was edited in six places by hand. Assert what the brief asked for
and what an editor can silently break: the UTF-8 BOM, the accented characters in
five languages, and the French space before its colon.
"""

import io

TOC = r"E:\World of Warcraft\_retail_\Interface\AddOns\MidnightHelper\MidnightHelper.toc"

raw = io.open(TOC, "rb").read()

print("=" * 70)
print("MidnightHelper.toc")
print("=" * 70)

bom = raw[:3] == b"\xef\xbb\xbf"
print("UTF-8 BOM present            : %s" % ("YES" if bom else "NO -- BROKEN"))

try:
    text = raw.decode("utf-8-sig")
    print("decodes as UTF-8             : YES")
except UnicodeDecodeError as e:
    print("decodes as UTF-8             : NO -- %s" % e)
    raise SystemExit(1)

# Accents that must have survived, one per language that has any.
CHECKS = [
    ("deDE", "f\u00fcr Midnight"),          # fur -> for
    ("deDE", "Routenf\u00fchrung"),
    ("frFR", "Midnight : planning"),         # the space before the colon
    ("frFR", "d'itin\u00e9raire"),
    ("esES", "planificaci\u00f3n"),
    ("esES", "gu\u00eda de rutas"),
    ("ptBR", "planejamento semanal"),
    ("itIT", "pianificazione settimanale"),
]
print()
for lang, needle in CHECKS:
    print("%-6s %-30s %s" % (lang, needle, "ok" if needle in text else "MISSING"))

print()
left = text.count("12.0.7")
print("occurrences of '12.0.7' left : %d" % left)
print("Interface line               : %s" % text.splitlines()[0])
