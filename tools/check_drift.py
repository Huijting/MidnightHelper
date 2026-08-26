# -*- coding: utf-8 -*-
"""Welke vertalingen zijn losgeraakt van de Engelse tekst waar ze uit komen?

    python tools/check_drift.py            rapport
    python tools/check_drift.py --seed     (her)schrijf tools/translation_state.json
    python tools/check_drift.py --write-report   schrijf docs/TRANSLATION_DRIFT.md

ns:L valt terug op enUS als een key ONTBREEKT, maar niet als hij AANWEZIG is. Een
Engelse zin corrigeren laat vijf packs dus stil verkeerd staan: ze antwoorden nog
steeds, alleen op de oude vraag. Dat is wat hier drift heet.

De staat is geen kennis en geen uitvoer, maar een RELATIE tussen een versie van de
Engelse tekst en een taal -- daarom staat hij in een eigen bestand en niet in de
locale-bestanden. Zie docs/POC_TRANSLATION_DRIFT.md; dit is dezelfde vorm, nu op
locale-keys in plaats van kennisobjecten.

⚠️ DIT LEEST GEEN LUA. Op 26 aug 2026 gaf een statische parser drie keer op rij een
   verkeerd antwoord (keys die een regel deelden; de merge()-blokken per taal in
   DelveTips/Codex/...; en een "bewijs" dat 1170 fills dood waren). De echte loader
   sprak hem elke keer tegen en had elke keer gelijk. Dus vragen we het de loader:
   tools/locale_probe.lua --dump laadt de bestanden zoals de client ze laadt.
"""
import hashlib
import io
import json
import os
import subprocess
import sys

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
STATE = os.path.join(REPO, "tools", "translation_state.json")
REPORT = os.path.join(REPO, "docs", "TRANSLATION_DRIFT.md")
SEED_TAG = "v3.5.0"
LANGS = ("deDE", "frFR", "esES", "ptBR", "itIT", "nlNL")

sys.stdout.reconfigure(encoding="utf-8")

# --- wat nooit vertaald wordt, en dus nooit kan driften -----------------------
# CLAUDE.md ("What never gets translated"). Een key die hier valt, hoort in elke
# taal Engels te zijn; hem als "onvertaald" melden is ruis, en ruis in een rapport
# is hoe mensen leren rapporten te negeren.
SKIP_PREFIX = (
    "CHANGELOG_",     # met opzet Engels, in alle talen
    "LANG_LABEL_",    # "Deutsch" hoort in élke taal Deutsch te zijn (endoniem)
)
# Spelbegrippen: als de HELE waarde dit is, is Engels het juiste antwoord.
GAME_TERMS = {
    "Mythic+", "PvP", "Raid", "Renown", "Delves", "Bountiful", "Tier",
    "Vault", "Keys", "Shards", "Knowledge Points", "KP", "ilvl", "Elite",
}


def excluded(key, en_value):
    if key.startswith(SKIP_PREFIX):
        return True
    if en_value.strip() in GAME_TERMS:
        return True
    return False


def h(s):
    return hashlib.sha256(s.encode("utf-8")).hexdigest()[:16]


# --- de loader vragen, niet zelf parsen ---------------------------------------
def dump(root):
    """{code: {key: value}} zoals de client het zou laden, uit die werkmap."""
    try:
        p = subprocess.run(["lua", "tools/locale_probe.lua", "--dump"],
                           cwd=root, capture_output=True, text=True,
                           encoding="utf-8", errors="replace")
    except FileNotFoundError:
        sys.exit("STOP: 'lua' staat niet in PATH. Zonder loader geen meting -- en\n"
                 "terugvallen op tellen is precies hoe de vorige audit ernaast zat.")
    if p.returncode != 0:
        sys.exit("STOP: locale_probe.lua faalde in %s\n%s" % (root, p.stderr))
    for line in (p.stderr or "").splitlines():
        print("  loader: " + line)
    out = {}
    for line in p.stdout.splitlines():
        parts = line.split("\t")
        if len(parts) != 3:
            continue
        code, key, val = parts
        val = val.replace("\\t", "\t").replace("\\n", "\n").replace("\\\\", "\\")
        out.setdefault(code, {})[key] = val
    if not out.get("enUS"):
        sys.exit("STOP: de dump bevat geen enUS -- dat is geen leeg antwoord maar een kapot meetinstrument.")
    return out


def baseline(tag):
    """De locale-wereld zoals hij op <tag> was, uitgepakt naar de scratchpad."""
    dest = os.path.join(REPO, "tools", ".baseline-" + tag)
    files = ["MidnightHelper.toc"]
    ls = subprocess.run(["git", "-C", REPO, "ls-tree", "--name-only",
                         tag + ":Locales"], capture_output=True, text=True)
    if ls.returncode != 0:
        sys.exit("STOP: tag %s bestaat niet in deze repo." % tag)
    files += ["Locales/" + f for f in ls.stdout.split() if f.endswith(".lua")]
    for rel in files:
        blob = subprocess.run(["git", "-C", REPO, "show", tag + ":" + rel],
                              capture_output=True)
        if blob.returncode != 0:
            continue
        p = os.path.join(dest, rel.replace("/", os.sep))
        os.makedirs(os.path.dirname(p), exist_ok=True)
        with io.open(p + ".tmp", "wb") as fh:
            fh.write(blob.stdout)
        os.replace(p + ".tmp", p)
    # De loader komt uit de HUIDIGE boom, niet uit de tag: op v3.5.0 bestond
    # --dump nog niet. We meten oude locale-bestanden met het nieuwe instrument.
    os.makedirs(os.path.join(dest, "tools"), exist_ok=True)
    with io.open(os.path.join(REPO, "tools", "locale_probe.lua"),
                 encoding="utf-8") as fh:
        probe = fh.read()
    with io.open(os.path.join(dest, "tools", "locale_probe.lua"), "w",
                 encoding="utf-8", newline="\n") as fh:
        fh.write(probe)
    return dump(dest)


# --- oordelen ------------------------------------------------------------------
def classify(now, state):
    """(code, key) -> status, met de Engelse tekst erbij."""
    en = now["enUS"]
    rows = {c: [] for c in LANGS}
    for key in sorted(en):
        env = en[key]
        if excluded(key, env):
            continue
        cur = h(env)
        for code in LANGS:
            val = now.get(code, {}).get(key)
            if val is None or val == env:
                rows[code].append(("ONVERTAALD", key, env, None))
                continue
            base = state.get("keys", {}).get(key, {}).get(code)
            if base is None:
                rows[code].append(("ONBEKEND", key, env, val))
            elif base == cur:
                rows[code].append(("OK", key, env, val))
            else:
                rows[code].append(("DRIFT", key, env, val))
    return rows


def seed(now, base):
    """Een taal krijgt alleen een basis als hij op de tag ECHT vertaald was.

    Zomaar elke key stempelen zou aannemen dat alles op v3.5.0 klopte. Een key
    zonder regel meldt ONBEKEND, en dat is eerlijk -- het is niet hetzelfde als
    verouderd.
    """
    ben = base["enUS"]
    keys = {}
    for key, env in ben.items():
        if excluded(key, env):
            continue
        for code in LANGS:
            val = base.get(code, {}).get(key)
            if val is not None and val != env:
                keys.setdefault(key, {})[code] = h(env)
    return {"seed_tag": SEED_TAG,
            "note": "hash = sha256[:16] van de ENGELSE waarde op het moment dat "
                    "deze taal hem vertaalde. Alleen door tools/check_drift.py te "
                    "schrijven, nooit met de hand.",
            "keys": keys}


def counts(rows):
    per = {}
    for code in LANGS:
        c = {"OK": 0, "DRIFT": 0, "ONVERTAALD": 0, "ONBEKEND": 0}
        for st, _k, _e, _v in rows[code]:
            c[st] += 1
        per[code] = c
    return per


def render_console(rows, state, en_total=None, scored=None):
    out = []
    if en_total is not None:
        out.append("enUS volgens de loader: %d keys, waarvan %d beoordeeld "
                   "(%d overgeslagen: CHANGELOG_*, LANG_LABEL_*, spelbegrippen)"
                   % (en_total, scored, en_total - scored))
    out += ["Basis: %s (%d keys met een vastgelegde herkomst)"
            % (state.get("seed_tag", "?"), len(state.get("keys", {}))), "",
           "%-6s %8s %8s %11s %9s" % ("taal", "OK", "DRIFT", "ONVERTAALD", "ONBEKEND")]
    per = counts(rows)
    for code in LANGS:
        c = per[code]
        out.append("%-6s %8d %8d %11d %9d"
                   % (code, c["OK"], c["DRIFT"], c["ONVERTAALD"], c["ONBEKEND"]))
    drift = sorted({r[1] for code in LANGS for r in rows[code] if r[0] == "DRIFT"})
    out.append("")
    out.append("gedrifte keys (%d): %s" % (len(drift), ", ".join(drift)))
    return "\n".join(out)


def flat(s):
    return s.replace("\n", " ").strip()


def render_report(rows, state, en_total, scored):
    per = counts(rows)
    o = []
    o.append("# Vertaal-drift")
    o.append("")
    o.append("Gegenereerd door `python tools/check_drift.py --write-report`. "
             "**Niet met de hand bijwerken.**")
    o.append("")
    o.append("Drift betekent: deze taal heeft een vertaling, maar de Engelse zin "
             "waar hij uit komt is daarna veranderd. `ns:L` valt alleen terug op "
             "enUS als een key *ontbreekt* — een aanwezige vertaling blijft staan, "
             "hoe oud hij ook is. Zo blijft een gecorrigeerde bewering in vijf "
             "talen gewoon doorlopen.")
    o.append("")
    o.append("Basis: **%s** — %d keys met een vastgelegde herkomst."
             % (state.get("seed_tag", "?"), len(state.get("keys", {}))))
    o.append("")
    o.append("| taal | OK | drift | onvertaald | onbekend |")
    o.append("|---|---:|---:|---:|---:|")
    for code in LANGS:
        c = per[code]
        o.append("| %s | %d | %d | %d | %d |"
                 % (code, c["OK"], c["DRIFT"], c["ONVERTAALD"], c["ONBEKEND"]))
    o.append("")
    o.append("**onbekend** = na de basistag vertaald, dus we weten niet uit welke "
             "Engelse versie. Dat is niet hetzelfde als verouderd.")
    o.append("")
    o.append("De loader ziet **%d** enUS-keys; hiervan zijn er %d beoordeeld en %d "
             "overgeslagen (`CHANGELOG_*`, `LANG_LABEL_*` en waarden die precies een "
             "spelbegrip zijn). ⚠️ `tools/lint_addon.py` [5] telt hetzelfde anders — "
             "die parseert de bestanden zelf en slaat niets over, dus zijn "
             "\"still English\" ligt hoger. Twee getallen die hetzelfde lijken te "
             "meten en niet gelijk zijn: gebruik hier het getal van de loader."
             % (en_total, scored, en_total - scored))
    o.append("")
    o.append("⚠️ **Niets hier automatisch vertalen.** Deze lijst gaat naar "
             "#translations op Discord; een machinevertaling in een pack is niet "
             "te onderscheiden van een gecontroleerde en blokkeert de echte.")
    o.append("")
    for code in LANGS:
        drift = [r for r in rows[code] if r[0] == "DRIFT"]
        if not drift:
            continue
        o.append("## %s — %d gedrift" % (code, len(drift)))
        o.append("")
        for _st, key, env, val in drift:
            o.append("### `%s`" % key)
            o.append("")
            o.append("| | |")
            o.append("|---|---|")
            o.append("| enUS **nu** | %s |" % flat(env).replace("|", "\\|"))
            o.append("| %s **staat nu** | %s |" % (code, flat(val or "").replace("|", "\\|")))
            o.append("")
    return "\n".join(o) + "\n"


def main():
    args = sys.argv[1:]
    now = dump(REPO)
    if "--seed" in args:
        st = seed(now, baseline(SEED_TAG))
        with io.open(STATE + ".tmp", "w", encoding="utf-8", newline="\n") as fh:
            json.dump(st, fh, ensure_ascii=False, indent=1, sort_keys=True)
        os.replace(STATE + ".tmp", STATE)
        print("geschreven: %s (%d keys)" % (STATE, len(st["keys"])))
        return
    if not os.path.exists(STATE):
        sys.exit("STOP: %s bestaat niet. Draai eerst: python tools/check_drift.py --seed"
                 % STATE)
    with io.open(STATE, encoding="utf-8") as fh:
        state = json.load(fh)
    rows = classify(now, state)
    en_total = len(now["enUS"])
    scored = len(rows[LANGS[0]])
    print(render_console(rows, state, en_total, scored))
    if "--write-report" in args:
        with io.open(REPORT + ".tmp", "w", encoding="utf-8", newline="\n") as fh:
            fh.write(render_report(rows, state, en_total, scored))
        os.replace(REPORT + ".tmp", REPORT)
        # De brief vraagt expliciet om UTF-8 te controleren NA het schrijven.
        with io.open(REPORT, encoding="utf-8") as fh:
            fh.read()
        print("\ngeschreven: %s (UTF-8 teruggelezen, ok)" % REPORT)


main()
