#!/usr/bin/env python3
"""Correct the families block: the spec does not gate WHICH recipes you own.

Shipped an hour ago saying "picking a family is picking a customer: someone who wants a Haste
ring has to find a Thalassian enchanter". Rob's own spec tooltips say what the branch actually
grants -- "+5 Skill for Amani enchantments. Learn to use Finishing Reagents on Amani
enchantment recipes." Skill and Finishing Reagents. Not a recipe list.

And the recipes come from more than one place: ItemSparse has Formula items for the greater
rings (Eyes of the Eagle 256739, Nature's Fury 256752, Silvermoon's Tenacity 256760) while the
lesser ones are auto-learned while levelling -- Thalassian Haste is AcquireMethod 1. Our own
levelling route already tells a beginner to craft Nature's Wrath at skill 25-40, long before
they could have 20 points in Haranir, which is the contradiction that started this.

⚠️ The two research agents disagreed here and I shipped anyway. Agent 1 counted 22 Formula
items; agent 3 said there were none at all. One query settled it in favour of agent 1. Writing
a confident sentence on top of an unresolved disagreement is the exact fault of the day.

So the claim is narrowed to what the tooltips actually say, and what is still unknown is now
named: whether the branches gate any recipes at all was never traced.
"""
import io
import os
import re

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
LOC = os.path.join(REPO, "Locales")
NB = " "

JOBS = {
    "enUS": (
        r"So picking a family is picking a customer.*?weapon proc is Thalassian\.",
        "So the branch you take decides which family you can push to the top quality rank: it grants +5 Skill for that family and lets you use Finishing Reagents on its recipes. It is not a recipe list — the lesser enchants are learned automatically while you level, and several of the greater ones come from formulas you buy or find. And inside a family the ring stat is never the weapon stat: Mastery rings are Amani, but the Mastery weapon proc is Thalassian.",
    ),
    "nlNL": (
        r"Een familie kiezen is dus een klant kiezen.*?op wapens is Thalassian\.",
        "De tak die je neemt bepaalt dus welke familie je naar de hoogste kwaliteitsrang kunt duwen: hij geeft +5 Skill voor die familie en laat je Finishing Reagents op haar recepten gebruiken. Het is géén receptenlijst — de lagere enchants leer je vanzelf tijdens het levelen, en een deel van de hogere komt uit formules die je koopt of vindt. En binnen een familie is de ring-stat nooit de wapen-stat: Mastery-ringen zijn Amani, maar de Mastery-proc op wapens is Thalassian.",
    ),
    "deDE": (
        r"Eine Familie zu wählen heißt also.*?aber Thalassian\.",
        "Der Zweig, den du nimmst, entscheidet also, welche Familie du auf die höchste Qualitätsstufe bringen kannst: er gibt +5 Skill für diese Familie und erlaubt dir Finishing Reagents auf ihren Rezepten. Es ist keine Rezeptliste — die kleineren Verzauberungen lernst du beim Leveln von selbst, und mehrere der größeren stammen aus Formeln, die du kaufst oder findest. Und innerhalb einer Familie ist der Ring-Wert nie der Waffen-Wert: Mastery-Ringe sind Amani, der Mastery-Proc auf Waffen aber Thalassian.",
    ),
    "frFR": (
        r"Choisir une famille, c'est donc choisir une clientèle.*?proc Mastery sur arme est Thalassian\.",
        "La branche que tu prends décide donc quelle famille tu peux pousser au rang de qualité maximum" + NB + ": elle donne +5 Skill pour cette famille et te permet d'utiliser les Finishing Reagents sur ses recettes. Ce n'est pas une liste de recettes — les enchantements mineurs s'apprennent tout seuls en montant, et plusieurs des majeurs viennent de formules que tu achètes ou que tu trouves. Et dans une même famille la stat de l'anneau n'est jamais celle de l'arme" + NB + ": les anneaux Mastery sont Amani, mais le proc Mastery sur arme est Thalassian.",
    ),
    "esES": (
        r"Elegir familia es elegir cliente.*?en armas es Thalassian\.",
        "Así que la rama que tomes decide qué familia puedes llevar al rango de calidad más alto: da +5 Skill para esa familia y te deja usar Finishing Reagents en sus recetas. No es una lista de recetas: los encantamientos menores se aprenden solos mientras subes, y varios de los mayores vienen de fórmulas que compras o encuentras. Y dentro de una familia la estadística del anillo nunca es la del arma: los anillos de Mastery son Amani, pero el proc de Mastery en armas es Thalassian.",
    ),
    "ptBR": (
        r"Escolher uma família é escolher um cliente.*?em armas é Thalassian\.",
        "Então o ramo que você pega decide qual família você consegue levar ao nível de qualidade mais alto: ele dá +5 Skill para aquela família e deixa você usar Finishing Reagents nas receitas dela. Não é uma lista de receitas — os encantamentos menores você aprende sozinho enquanto sobe, e vários dos maiores vêm de fórmulas que você compra ou encontra. E dentro de uma família o atributo do anel nunca é o da arma: anéis de Mastery são Amani, mas o proc de Mastery em armas é Thalassian.",
    ),
    "itIT": (
        r"Scegliere una famiglia significa quindi scegliere un cliente.*?sulle armi è Thalassian\.",
        "Quindi il ramo che prendi decide quale famiglia puoi spingere al grado di qualità più alto: dà +5 Skill per quella famiglia e ti permette di usare i Finishing Reagents sulle sue ricette. Non è un elenco di ricette: gli enchant minori si imparano da soli mentre sali, e diversi di quelli maggiori vengono da formule che compri o trovi. E dentro una famiglia la statistica dell'anello non è mai quella dell'arma: gli anelli Mastery sono Amani, ma il proc Mastery sulle armi è Thalassian.",
    ),
}

# Second edit: name the new gap in the "what we do not know" paragraph.
TAIL = {
    "enUS": ("Check your own auction house before you commit 20 points.",
             "Check your own auction house before you commit 20 points. We also have not established whether the branches gate any recipes at all, or only the Skill and the Finishing Reagents."),
    "nlNL": ("Kijk zelf even op je auction house voor je 20 punten vastlegt.",
             "Kijk zelf even op je auction house voor je 20 punten vastlegt. We hebben ook niet vastgesteld óf de takken überhaupt recepten afschermen, of alleen de Skill en de Finishing Reagents."),
    "deDE": ("Sieh selbst im Auktionshaus nach, bevor du 20 Punkte festlegst.",
             "Sieh selbst im Auktionshaus nach, bevor du 20 Punkte festlegst. Wir haben außerdem nicht festgestellt, ob die Zweige überhaupt Rezepte sperren oder nur Skill und Finishing Reagents."),
    "frFR": ("Va voir ton hôtel des ventes avant d'engager 20 points.",
             "Va voir ton hôtel des ventes avant d'engager 20 points. Nous n'avons pas non plus établi si les branches verrouillent la moindre recette, ou seulement le Skill et les Finishing Reagents."),
    "esES": ("Mira tu propia casa de subastas antes de comprometer 20 puntos.",
             "Mira tu propia casa de subastas antes de comprometer 20 puntos. Tampoco hemos establecido si las ramas bloquean alguna receta, o solo el Skill y los Finishing Reagents."),
    "ptBR": ("Veja a sua própria casa de leilões antes de comprometer 20 pontos.",
             "Veja a sua própria casa de leilões antes de comprometer 20 pontos. Também não estabelecemos se os ramos bloqueiam alguma receita, ou apenas o Skill e os Finishing Reagents."),
    "itIT": ("Controlla la tua casa d'aste prima di impegnare 20 punti.",
             "Controlla la tua casa d'aste prima di impegnare 20 punti. Non abbiamo nemmeno stabilito se i rami blocchino qualche ricetta, o solo lo Skill e i Finishing Reagents."),
}

TARGETS = {"enUS": "enUS.lua", "nlNL": "nlNL.lua"}
for c in ("deDE", "frFR", "esES", "ptBR", "itIT"):
    TARGETS[c] = "Translations2026.lua"

for code in JOBS:
    path = os.path.join(LOC, TARGETS[code])
    text = io.open(path, encoding="utf-8", newline="").read()
    before = text

    pat, new = JOBS[code]
    hits = re.findall(pat, text)
    if len(hits) == 1:
        text = re.sub(pat, lambda _: new, text, count=1)
    else:
        print("%s  sentence: %d matches -- skipped" % (code, len(hits)))

    old_t, new_t = TAIL[code]
    if text.count(old_t) == 1:
        text = text.replace(old_t, new_t)
    else:
        print("%s  tail: %d matches -- skipped" % (code, text.count(old_t)))

    if text != before:
        with io.open(path + ".tmp", "w", encoding="utf-8", newline="") as fh:
            fh.write(text)
        os.replace(path + ".tmp", path)
        print("%s  written" % code)
