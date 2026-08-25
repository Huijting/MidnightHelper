# -*- coding: utf-8 -*-
"""Zet de twee LayoutGrowth-instellingen in alle zeven blokken van SettingsPage.lua.

Anker: de bestaande SET_SHARDCAP_TOGGLE_DESC-regel binnen elk taalblok. Die staat er
zeven keer, dus we voegen na élke voorkomende toe -- de talen staan in vaste volgorde
in het bestand (enUS, itIT, nlNL, deDE, frFR, esES, ptBR volgens de regelnummers).
"""
import io
import os
import re
import sys

P = (r"E:\World of Warcraft\_retail_\Interface\AddOns\MidnightHelper"
     r"\Locales\SettingsPage.lua")
sys.stdout.reconfigure(encoding="utf-8")

# Volgorde zoals de blokken in het bestand staan.
ORDER = ["enUS", "itIT", "nlNL", "deDE", "frFR", "esES", "ptBR"]

T = {
"enUS": ("Say where a new ability goes",
         "When you learn an ability, mention which key your layout has for it. One line, once. Off by default - nothing is placed or bound unless you ask.",
         "Use a popup for it",
         "Show it as a small window with a Place it button instead of only a chat line. Needs the setting above."),
"itIT": ("Dimmi dove va una nuova abilità",
         "Quando impari un'abilità, ti dice quale tasto le assegna il tuo layout. Una riga, una volta. Disattivato di default - non viene piazzato né assegnato nulla senza che tu lo chieda.",
         "Usa un popup",
         "Mostralo come una finestrella con un pulsante Place it invece della sola riga in chat. Richiede l'opzione qui sopra."),
"nlNL": ("Zeggen waar een nieuwe spell hoort",
         "Zodra je iets leert, noemen we welke toets jouw layout ervoor heeft. Eén regel, één keer. Standaard uit - er wordt niets geplaatst of gebonden tenzij je erom vraagt.",
         "Doe dat met een popup",
         "Toon het als een klein venster met een Place it-knop in plaats van alleen een chatregel. Vereist de instelling hierboven."),
"deDE": ("Sagen, wohin eine neue Fähigkeit gehört",
         "Wenn du etwas lernst, nennen wir die Taste, die dein Layout dafür vorsieht. Eine Zeile, einmal. Standardmäßig aus - es wird nichts platziert oder belegt, solange du nicht fragst.",
         "Dafür ein Popup verwenden",
         "Als kleines Fenster mit einem Place it-Knopf zeigen statt nur als Chatzeile. Benötigt die Einstellung darüber."),
"frFR": ("Dire où va une nouvelle capacité",
         "Quand vous apprenez une capacité, on indique la touche que votre disposition lui réserve. Une ligne, une fois. Désactivé par défaut - rien n'est placé ni assigné sans votre demande.",
         "Utiliser une popup",
         "L'afficher dans une petite fenêtre avec un bouton Place it plutôt qu'en simple ligne de chat. Nécessite l'option ci-dessus."),
"esES": ("Decir dónde va una habilidad nueva",
         "Cuando aprendes una habilidad, te decimos qué tecla le reserva tu distribución. Una línea, una vez. Desactivado por defecto: no se coloca ni asigna nada salvo que lo pidas.",
         "Usar una ventana emergente",
         "Mostrarlo como una ventanita con un botón Place it en vez de solo una línea de chat. Necesita la opción de arriba."),
"ptBR": ("Dizer onde vai uma habilidade nova",
         "Quando você aprende uma habilidade, dizemos qual tecla o seu layout reserva para ela. Uma linha, uma vez. Desligado por padrão - nada é colocado ou vinculado sem você pedir.",
         "Usar um popup",
         "Mostrar numa janelinha com um botão Place it em vez de só uma linha no chat. Precisa da opção acima."),
}

with io.open(P, "r", encoding="utf-8", newline="") as fh:
    txt = fh.read()

if "SET_GROWTH_TIPS_TITLE" in txt:
    print("staat er al -- niets gedaan")
    raise SystemExit(0)

pat = re.compile(r'\tSET_SHARDCAP_TOGGLE_DESC = "[^"]*",\r?\n')
hits = list(pat.finditer(txt))
print("ankers gevonden: %d (verwacht %d)" % (len(hits), len(ORDER)))
if len(hits) != len(ORDER):
    raise SystemExit("aantal klopt niet -- niets gewijzigd")

# Achterstevoren invoegen, zodat eerdere offsets geldig blijven.
for idx in range(len(hits) - 1, -1, -1):
    m = hits[idx]
    code = ORDER[idx]
    t1, d1, t2, d2 = T[code]
    nl = "\r\n" if m.group(0).endswith("\r\n") else "\n"
    ins = ('\tSET_GROWTH_TIPS_TITLE = "%s",%s'
           '\tSET_GROWTH_TIPS_DESC = "%s",%s'
           '\tSET_GROWTH_POPUP_TITLE = "%s",%s'
           '\tSET_GROWTH_POPUP_DESC = "%s",%s' % (t1, nl, d1, nl, t2, nl, d2, nl))
    txt = txt[:m.end()] + ins + txt[m.end():]
    print("  %s: toegevoegd" % code)

io.open(P + ".tmp", "w", encoding="utf-8", newline="").write(txt)
os.replace(P + ".tmp", P)
print("klaar")
