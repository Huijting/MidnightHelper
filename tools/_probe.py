# -*- coding: utf-8 -*-
"""Genereert de story-varianttabel + de enUS-teksten uit de DB2-CSV.

Waarom gegenereerd en niet getypt: 46 namen en 46 omschrijvingen overtypen is
46 kansen op een stille fout, en een verkeerde variantnaam betekent dat de tip
nooit verschijnt zonder dat iemand doorheeft waarom.

Meegenomen: alleen de 12 roterende delves plus de twee nemesis-delves die Robs
eigen tabel al kent. Groepen die niet aantoonbaar Midnight-delves zijn (Tazavesh,
de zones Val en Naigtal, en twee losse ritual-achtige regels) blijven eruit.
"""
import csv
import io
import os
import re
import sys

CSV = (r"C:\Users\RobHu\AppData\Local\Temp\claude"
       r"\E--World-of-Warcraft--retail--Interface-AddOns"
       r"\3d73686f-b8a5-478e-826d-74f066e950ea\scratchpad\gossip.csv")
ROOT = r"E:\World of Warcraft\_retail_\Interface\AddOns\MidnightHelper"

sys.stdout.reconfigure(encoding="utf-8")

# GossipXUIDisplayInfoID -> onze delve-sleutel.
# 11 hiervan zijn vastgesteld door Robs eigen metingen op 25 aug 2026; 71 volgt uit
# de inhoud (de drie varianten die wij al kenden staan erin); 81 en 90 uit de namen
# Nullaeus en Azta'rec, die al in onze eigen tabellen staan.
GROUPS = {
    71: "collegiate_calamity",
    72: "parhelion_plaza",
    73: "shadowguard_point",
    74: "grudge_pit",
    76: "atal_aman",
    77: "twilight_crypts",
    78: "shadow_enclave",
    79: "sunkiller_sanctum",
    80: "gulf_of_memory",
    83: "the_darkway",
    88: "gnarldor_isle",
    89: "ring_of_glory",
    81: "torments_rise",
    90: "venomfall_deeps",
}

# Blizzard liet een leeg sjabloon in de tabel staan (groep 88 en 89). Zonder deze
# filter zou een speler "Story vandaag: Name" te zien krijgen.
JUNK = {"name", "description"}

# Namen die de world-map-tooltip gebruikt en die NIET in de gossip-tabel staan.
# GEMETEN in Robs client op 25 aug 2026: de tooltip zei "An Elementary Antidote"
# waar DB2 "Academic Antitoxin" zegt -- dezelfde variant, twee UI-oppervlakken.
# DelveGuide, dat het ook live uit de client haalt, zegt eveneens Antidote.
# Zonder deze regel matcht de tip precies op de variant die dit hele onderzoek
# begon. Staat hier in de generator zodat hij een ververs overleeft.
ALIASES = {
    "an elementary antidote": "Academic Antitoxin",
}


def slug(name):
    s = re.sub(r"[^A-Za-z0-9]+", "_", name).strip("_").upper()
    return "DELVE_STORY_" + s


def lua(s):
    return s.replace("\\", "\\\\").replace('"', '\\"')


rows = []
with io.open(CSV, "r", encoding="utf-8", newline="") as fh:
    for row in csv.DictReader(fh):
        gid = int(row["GossipXUIDisplayInfoID"])
        if gid not in GROUPS:
            continue
        m = re.match(r"\|cnWHITE_FONT_COLOR:(.*?)\|r\|n(.*)$",
                     row["Field_11_0_0_54935_000_lang"], re.S)
        if not m:
            continue
        name, desc = m.group(1).strip(), m.group(2).strip()
        if name.lower() in JUNK:
            continue
        rows.append((GROUPS[gid], name, " ".join(desc.split())))

# Ontdubbelen op naam. Crocolisk Reintroduction staat bij vier delves met exact
# dezelfde tekst, dus een platte naam->tekst tabel is hier juist het goede model.
seen, uniq = {}, []
for dkey, name, desc in rows:
    key = name.lower()
    if key in seen:
        if seen[key][1] != desc:
            raise SystemExit("CONFLICT: %r heeft twee omschrijvingen" % name)
        seen[key][2].add(dkey)
        continue
    entry = [name, desc, {dkey}]
    seen[key] = entry
    uniq.append(entry)

print("unieke varianten: %d   (uit %d rijen)" % (len(uniq), len(rows)))
shared = [e for e in uniq if len(e[2]) > 1]
for e in shared:
    print("  gedeeld over %d delves: %s" % (len(e[2]), e[0]))

hdr = ("--[[\n"
       "\tStory-varianten per delve -- namen en omschrijvingen.\n\n"
       "\tGEGENEREERD uit Blizzards eigen DB2-tabel GossipUIDisplayInfoCondition\n"
       "\t(wago.tools, build 12.1.0), niet met de hand overgetypt. Bijwerken door\n"
       "\ttools/_probe.py opnieuw te draaien tegen een verse CSV.\n\n"
       "\tDe DETECTIE staat hier bewust NIET in. Welke variant vandaag draait vraagt\n"
       "\tde addon aan de client (zie DelveBossShowcase); dit bestand levert alleen de\n"
       "\ttekst erbij. Die scheiding is de les van 25 aug 2026: onze handgeschreven\n"
       "\tlijst kende 3 van de 12 varianten die de client die dag aanbood.\n\n"
       "\tLET OP -- twee dingen die in de ruwe tabel zitten en hier bewust niet:\n"
       "\t  * groep 88 en 89 bevatten een leeg sjabloon met de naam \"Name\". Zonder\n"
       "\t    filter zou een speler \"Story vandaag: Name\" te zien krijgen.\n"
       "\t  * Crocolisk Reintroduction staat bij VIER delves met identieke tekst. Het\n"
       "\t    is dus geen delve-eigen variant; de platte naam->tekst tabel hieronder\n"
       "\t    dekt dat vanzelf.\n"
       "]]\n\n"
       "local _, ns = ...\n\n"
       "--- Kleine letters, want de client levert de naam in wisselend hoofdlettergebruik.\n"
       "ns.DELVE_STORY_TIP = {\n")

lines = [hdr]
for name, desc, dkeys in sorted(uniq, key=lambda e: e[0].lower()):
    where = ", ".join(sorted(dkeys))
    lines.append('\t["%s"] = "%s", -- %s\n' % (lua(name.lower()), slug(name), where))

byname = {e[0].lower(): e[0] for e in uniq}
if ALIASES:
    lines.append("\n\t-- Namen die de map-tooltip gebruikt en de gossip-tabel niet.\n")
    for alias, target in sorted(ALIASES.items()):
        if target.lower() not in byname:
            raise SystemExit("ALIAS wijst naar onbekende variant: %r" % target)
        lines.append('\t["%s"] = "%s", -- = %s\n' % (lua(alias), slug(target), target))
lines.append("}\n")

p = os.path.join(ROOT, "Modules", "DelveStoryData.lua")
io.open(p + ".tmp", "w", encoding="utf-8", newline="").write("".join(lines))
os.replace(p + ".tmp", p)
print("geschreven: Modules/DelveStoryData.lua")

loc = ["--[[\n"
       "\tOmschrijvingen bij de story-varianten. GEGENEREERD -- zie DelveStoryData.lua.\n\n"
       "\tDe enUS-teksten zijn Blizzards eigen woorden uit de DB2-tabel, letterlijk\n"
       "\tovergenomen. Ze staan hier omdat een addon DB2 niet kan lezen; de client\n"
       "\ttoont ze alleen in het gossip-venster van de delve zelf.\n"
       "]]\n\n"
       "local _, ns = ...\n\n"
       "local function merge(target, patch)\n"
       "\tif type(target) ~= \"table\" then\n"
       "\t\treturn\n"
       "\tend\n"
       "\tfor k, v in pairs(patch) do\n"
       "\t\tif target[k] == nil then\n"
       "\t\t\ttarget[k] = v\n"
       "\t\tend\n"
       "\tend\n"
       "end\n\n"
       "merge(ns._mhLocales and ns._mhLocales.enUS, {\n"]
for name, desc, _ in sorted(uniq, key=lambda e: e[0].lower()):
    loc.append('\t%s = "%s",\n' % (slug(name), lua(desc)))
loc.append("})\n")

p2 = os.path.join(ROOT, "Locales", "DelveStories.lua")
io.open(p2 + ".tmp", "w", encoding="utf-8", newline="").write("".join(loc))
os.replace(p2 + ".tmp", p2)
print("geschreven: Locales/DelveStories.lua  (%d enUS-teksten)" % len(uniq))
