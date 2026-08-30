#!/usr/bin/env python3
"""Finish the Enchanting correction: the BODY still recommends the reverse order.

This afternoon I replaced the Shatter Essence sentence in PROFACAD_CH_ENCHANTING_ADVANCED and
stopped there. The static audit then showed the BODY of the same chapter still opens with
"Starter build (community consensus): Spellbound Shatterer first ... Disenchanting Delegate is
a strong third" -- the exact order the advisor route contradicts, still on screen, in seven
languages. Half a correction is worse than none: the two paragraphs now disagreed with each
other as well as with the route.

"Community consensus" was also simply untrue. Icy Veins (11 Aug, the only guide updated for
Season 2) and Method both start at Disenchanting Delegate; Wowhead says the order does not
matter; only games.gg says Shatterer first, and that page is derivative of Wowhead's.

Matched by regex between two distinctive markers rather than on the whole sentence, because
the French line carries no-break spaces before its colons. Tree names stay English -- that is
what THIS string already does in every pack, even though the ADVANCED string next to it
translates them.
"""
import io
import os
import re

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
LOC = os.path.join(REPO, "Locales")

JOBS = {
    "deDE": (
        r"Startbuild \(Community-Konsens\).*?Material-Selbstversorgung\.",
        "Startbuild: zuerst Disenchanting Delegate — der Baum, von dem der Rest des Berufs lebt, und der Start, den die beiden am besten gepflegten Guides empfehlen. Dann Elevating Equipment — Wurzel bis ~30, danach den Weapon/Chest/Ring-Zweig einer Familie: Skill entscheidet, welche Qualitätsstufe du erreichst, und eine Top-Verzauberung, die du nicht herstellen kannst, verkaufst du auch nicht. Spellbound Shatterer zuletzt — seine Werte senken, was ein Craft kostet, und das zahlt sich erst aus, wenn du die gute Version überhaupt machen kannst.",
    ),
    "frFR": (
        r"Build de départ \(consensus communautaire\).*?en matériaux\.",
        "Build de départ : Disenchanting Delegate d'abord — c'est l'arbre qui alimente tout le reste du métier, et c'est là que commencent les deux guides les mieux tenus à jour. Puis Elevating Equipment — racine jusqu'à ~30, puis la branche Weapon/Chest/Ring d'une famille : le Skill décide du rang de qualité que tu peux atteindre, et un enchantement de rang max que tu ne sais pas fabriquer ne se vend pas. Spellbound Shatterer en dernier — ses stats réduisent le coût d'un craft, ce qui ne rapporte qu'une fois que tu peux faire la bonne version.",
    ),
    "esES": (
        r"Build inicial \(consenso de la comunidad\).*?de materiales\.",
        "Build inicial: primero Disenchanting Delegate — es el árbol que alimenta al resto de la profesión, y es donde empiezan las dos guías mejor mantenidas. Luego Elevating Equipment — raíz hasta ~30 y después la rama Weapon/Chest/Ring de una familia: el Skill decide qué rango de calidad alcanzas, y un encantamiento de rango máximo que no sabes hacer no se vende. Spellbound Shatterer al final — sus estadísticas bajan lo que cuesta una fabricación, y eso solo compensa cuando ya puedes hacer la versión buena.",
    ),
    "ptBR": (
        r"Build inicial \(consenso da comunidade\).*?de materiais\.",
        "Build inicial: Disenchanting Delegate primeiro — é a árvore que alimenta o resto da profissão, e é onde os dois guias mais bem mantidos começam. Depois Elevating Equipment — raiz até ~30, então o ramo Weapon/Chest/Ring de uma família: o Skill decide que nível de qualidade você alcança, e um encantamento de nível máximo que você não consegue fazer não vende. Spellbound Shatterer por último — os atributos dele reduzem o custo de uma fabricação, e isso só compensa quando você já consegue fazer a versão boa.",
    ),
    "itIT": (
        r"Build iniziale \(consenso della community\).*?di materiali\.",
        "Build iniziale: prima Disenchanting Delegate — è l'albero che alimenta il resto della professione, ed è da lì che partono le due guide tenute meglio. Poi Elevating Equipment — root a ~30, poi il ramo Weapon/Chest/Ring di una famiglia: lo Skill decide che grado di qualità raggiungi, e un enchant di grado massimo che non riesci a fare non lo vendi. Spellbound Shatterer per ultimo — le sue stat abbassano quanto costa un craft, e questo rende solo quando riesci già a fare la versione buona.",
    ),
    "enUS": (
        r"Starter build \(community consensus\).*?self-sufficiency\.",
        "Starter build: Disenchanting Delegate first — it feeds the rest of the profession, and it is where both of the best-maintained guides start. Then Elevating Equipment — root to ~30, then one family's Weapon/Chest/Ring branch: Skill decides what quality rank you can reach, and a top-rank enchant you cannot make is one you cannot sell. Spellbound Shatterer last — its stats lower what a craft costs, which only pays once you can make the good version at all.",
    ),
    "nlNL": (
        r"Startbuild \(community-consensus\).*?materiaal-zelfvoorziening\.",
        "Startbuild: eerst Disenchanting Delegate — dat is de boom waar de rest van het beroep op draait, en het is waar de twee best onderhouden guides allebei beginnen. Dan Elevating Equipment — root tot ~30, daarna de Weapon/Chest/Ring-tak van één familie: Skill bepaalt welke kwaliteitsrang je haalt, en een top-enchant die je niet kúnt maken verkoop je ook niet. Spellbound Shatterer als laatste — zijn stats verlagen wat een craft kost, en dat betaalt zich pas als je de goede versie überhaupt kunt maken.",
    ),
}

TARGETS = {"enUS": "enUS.lua", "nlNL": "nlNL.lua", "deDE": "deDE.lua",
           "frFR": "frFR.lua", "esES": "esES.lua", "ptBR": "ptBR.lua", "itIT": "itIT.lua"}

for code, (pat, new) in JOBS.items():
    path = os.path.join(LOC, TARGETS[code])
    text = io.open(path, encoding="utf-8", newline="").read()
    hits = re.findall(pat, text)
    if len(hits) != 1:
        print("%s  %d matches -- skipped" % (code, len(hits)))
        continue
    text = re.sub(pat, lambda _: new, text, count=1)
    with io.open(path + ".tmp", "w", encoding="utf-8", newline="") as fh:
        fh.write(text)
    os.replace(path + ".tmp", path)
    print("%s  replaced (%d -> %d chars)" % (code, len(hits[0]), len(new)))
