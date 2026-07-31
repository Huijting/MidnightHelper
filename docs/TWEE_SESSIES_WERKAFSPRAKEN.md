# Werkafspraken — twee sessies, één werkmap

Er werken twee Claude-sessies in `Interface/AddOns/MidnightHelper`. Dat is **één
git-checkout**, geen twee. Alles wat de een doet, ziet de ander meteen op schijf — en
de map is tegelijk Robs draaiende game.

Deze regels staan er omdat het op 31 juli 2026 vier keer bijna misging. Elke regel
noemt wat er gebeurde, want een regel zonder reden wordt de eerste die sneuvelt.

---

## 1. Wissel nooit van branch

Een `git checkout` verandert de bestanden onder de andere sessie, midden in zijn werk.

*Wat er gebeurde:* een sessie begon op `fix/crest-terminology` en committe daarna op
`main` zonder het te merken — de branch was onderweg gewisseld. De commit was inhoudelijk
goed en landde toevallig op de juiste plek. Toeval is geen werkwijze.

**Alleen Rob wisselt van branch.** Heb je een andere nodig, vraag het.

## 2. Controleer de branch vlák vóór elke commit

Niet aan het begin van je sessie — vlak voor de commit zelf.

```
git rev-parse --abbrev-ref HEAD
```

Zet de uitkomst in je bericht aan Rob. Dan ziet hij het ook als het fout gaat.

## 3. Push meteen na elke commit

Ongepushte commits stapelen op en zijn voor de andere sessie onzichtbaar; op 31 juli
stonden er vier. Direct pushen maakt je werk zichtbaar en houdt de historie recht.

**Nooit** `--force`, `reset --hard`, `rebase` of `stash` op gedeeld werk. Moet er iets
teruggedraaid worden: overleg met Rob, doe het met een nieuwe commit.

## 4. Bestandseigendom

| Eigenaar | Bestanden |
|---|---|
| **Knowledge Runtime** | `docs/RFC-002*`, `docs/knowledge_proposal_v0.4/`, `Modules/Knowledge*`, `tools/build_knowledge.py`, `tools/knowledge_*`, `.pkgmeta`, `tools/lint_addon.py` |
| **Addon-ontwikkeling** | `docs/NEXT_SESSION.md`, `docs/EVIDENCE_REGISTER.md`, overige `Modules/`, `Locales/`, `Core.lua`, `UI.lua`, `MidnightHelper.toc` |
| **Niemand** | `docs/PTR_12.1_WATCH.md`, `docs/PTR_12.0.7_DATA.md` |

De twee watcher-bestanden worden door een geplande taak geschreven. **Niet committen,
niet opschonen** — laat ze als lokale wijziging staan.

`tools/lint_addon.py` staat bij Knowledge omdat zij hem uitbreiden. De andere sessie
mag hem **draaien** maar niet wijzigen.

## 5. Fout in andermans bestand? Melden, niet repareren

*Wat er gebeurde:* de Knowledge-sessie zag dat de patchdatum verkeerd stond in
`NEXT_SESSION.md` en `EVIDENCE_REGISTER.md`. Ze hebben het **gemeld** in plaats van
gerepareerd, met bron erbij. Dat werkte precies goed en is nu de regel.

Meld: welk bestand, welke regel, wat er fout is, en de bron. De eigenaar repareert.

## 6. Kijk in `git log` vóór je aan iets nieuws begint

*Wat er gebeurde:* beide sessies begonnen aan dezelfde datumcorrectie. De tweede zag
het op tijd en stopte — maar pas nadat het werk al gedaan was.

Eén `git log --oneline -5` vooraf voorkomt dat.

## 7. Zeg wélke bestanden je gaat aanraken vóór je begint

Eén regel in je bericht aan Rob is genoeg. Overlapt het met de andere eigenaar, dan
weet je het vóór het werk in plaats van erna.

## 8. Neem elkaars bevindingen niet op gezag over

*Wat er gebeurde:* de ene sessie meldde dat de patchdatum wél officieel was. De ander
heeft het **eerst zelf nagetrokken** bij de bron voordat hij drie documenten aanpaste —
en het klopte.

Dat is geen wantrouwen maar dezelfde never-lie-regel die voor Wowhead geldt. Een
melding van de andere sessie is een aanwijzing, geen bewijs.

---

## Wat er niet verandert

Robs bestaande regels blijven onverkort gelden voor allebei: nooit gokken naar
spell-ID's, coördinaten of API-namen; `luac -p` plus `python tools/lint_addon.py` (HARD
= 0) vóór elke overdracht; en versiebumps of releases alleen als Rob "af" of "go" zegt.

En het belangrijkste blijft ongewijzigd: **de repo ís de draaiende game.** Elke
schrijfactie moet atomisch (`.tmp` + `os.replace`), want Rob kan op elk moment inloggen.
