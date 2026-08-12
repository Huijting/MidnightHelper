"""Scratch script — rewritten per task, always run as tools/_probe.py.

Right now: rewrite CODEX_PROFRESET_BODY in seven languages to say what
"associated recipes" actually means. Rob reset Enchanting on 12 Aug expecting
to lose everything; his Knowledge came back at 1000/1000 and his recipe list
was untouched. That is the fear the article exists to remove, and it did not
address it.
"""
import io
import os
import re
import sys

for _s in (sys.stdout, sys.stderr):
    try:
        _s.reconfigure(encoding="utf-8", errors="replace")
    except (AttributeError, ValueError):
        pass

P = r'E:\World of Warcraft\_retail_\Interface\AddOns\MidnightHelper\Locales\Codex.lua'
B = 'CODEX_PROFRESET_BODY'
W, R, N = '|cffffffff', '|r', '|n'

BODY = {}

BODY['enUS'] = (
    '\u2022 Patch 12.1 lets you undo your Midnight specialization choices \u2014 once per profession.' + N
    + '\u2022 ' + W + 'Who:' + R + ' Theremis, in Silvermoon\u2019s Bazaar beside the crafting orders. He offers one line per profession, so you can reset Blacksmithing and leave Enchanting exactly as it is.' + N
    + '\u2022 ' + W + 'What comes back:' + R + ' every Knowledge Point you spent in that profession\u2019s Midnight trees, yours to re-allocate as you see fit.' + N
    + '\u2022 ' + W + 'What it costs:' + R + ' the game\u2019s warning reads \u201cYou will lose all associated recipes\u201d.' + N
    + '\u2022 ' + W + 'Associated, not all.' + R + ' What goes is what those specialization choices unlocked. Recipes you learned from a trainer, a drop or a quest sit outside the trees and stay. Seen on a reset Enchanting: the recipe list was untouched and the spent Knowledge was back on the counter.' + N
    + '\u2022 ' + W + 'It is once.' + R + ' The confirmation says ONCE in capitals, and that is per profession \u2014 there is no second attempt if the new path disappoints you.' + N
    + '\u2022 So decide where the points are going ' + W + 'before' + R + ' you confirm. The Professions page names the tree to fill and the exact node to spend on.' + N
    + '\u2022 Does re-spending exactly as before return the recipes it took? The game never says so. Plan as though it will not.'
)
BODY['nlNL'] = (
    '\u2022 Patch 12.1 laat je je Midnight-specialisatiekeuzes terugdraaien \u2014 \u00e9\u00e9n keer per beroep.' + N
    + '\u2022 ' + W + 'Bij wie:' + R + ' Theremis, in de Bazaar van Silvermoon naast de crafting orders. Hij biedt per beroep een aparte regel, dus je kunt Blacksmithing resetten en Enchanting precies laten zoals hij is.' + N
    + '\u2022 ' + W + 'Wat je terugkrijgt:' + R + ' elk Knowledge Point dat je in de Midnight-bomen van dat beroep hebt uitgegeven, vrij om opnieuw te verdelen.' + N
    + '\u2022 ' + W + 'Wat het kost:' + R + ' de waarschuwing van het spel luidt \u201cYou will lose all associated recipes\u201d.' + N
    + '\u2022 ' + W + 'Bijbehorende, niet alle.' + R + ' Weg is wat die specialisatiekeuzes hadden ontgrendeld. Recepten van een trainer, een drop of een quest staan buiten de bomen en blijven gewoon staan. Gezien bij een gereset Enchanting: de receptenlijst was onaangeroerd en de uitgegeven Knowledge stond weer op de teller.' + N
    + '\u2022 ' + W + 'Het is \u00e9\u00e9n keer.' + R + ' De bevestiging zegt ONCE in hoofdletters, en dat is per beroep \u2014 er is geen tweede poging als het nieuwe pad tegenvalt.' + N
    + '\u2022 Bepaal dus ' + W + 'vooraf' + R + ' waar de punten heen gaan. De Professions-pagina noemt de boom die je moet vullen en precies welke node.' + N
    + '\u2022 Komen de recepten die hij afnam terug als je identiek herbesteedt? Het spel zegt dat nergens. Reken erop van niet.'
)
BODY['deDE'] = (
    '\u2022 Patch 12.1 l\u00e4sst dich deine Midnight-Spezialisierungen zur\u00fccksetzen \u2014 einmal pro Beruf.' + N
    + '\u2022 ' + W + 'Bei wem:' + R + ' Theremis, im Basar von Silbermond neben den Handwerksauftr\u00e4gen. Er bietet pro Beruf eine eigene Zeile, du kannst also Schmiedekunst zur\u00fccksetzen und Verzauberkunst unangetastet lassen.' + N
    + '\u2022 ' + W + 'Was du zur\u00fcckbekommst:' + R + ' jeden Wissenspunkt, den du in den Midnight-B\u00e4umen dieses Berufs ausgegeben hast, frei neu verteilbar.' + N
    + '\u2022 ' + W + 'Was es kostet:' + R + ' die Warnung des Spiels lautet \u201eYou will lose all associated recipes\u201c.' + N
    + '\u2022 ' + W + 'Zugeh\u00f6rige, nicht alle.' + R + ' Weg ist, was diese Spezialisierungen freigeschaltet hatten. Rezepte von einem Lehrer, aus Beute oder aus einer Quest liegen au\u00dferhalb der B\u00e4ume und bleiben. Bei einer zur\u00fcckgesetzten Verzauberkunst beobachtet: die Rezeptliste war unber\u00fchrt und das ausgegebene Wissen stand wieder auf dem Z\u00e4hler.' + N
    + '\u2022 ' + W + 'Es ist einmalig.' + R + ' Die Best\u00e4tigung sagt ONCE in Gro\u00dfbuchstaben, und zwar pro Beruf \u2014 einen zweiten Versuch gibt es nicht, wenn der neue Weg entt\u00e4uscht.' + N
    + '\u2022 Entscheide also ' + W + 'vorher' + R + ', wohin die Punkte gehen. Die Berufe-Seite nennt den zu f\u00fcllenden Baum und den genauen Knoten.' + N
    + '\u2022 Kommen die genommenen Rezepte zur\u00fcck, wenn du identisch neu verteilst? Das Spiel sagt es nirgends. Plane so, als w\u00fcrden sie es nicht.'
)
BODY['frFR'] = (
    '\u2022 Le patch 12.1 permet d\u2019annuler tes choix de sp\u00e9cialisation Midnight \u2014 une fois par m\u00e9tier.' + N
    + '\u2022 ' + W + 'Chez qui :' + R + ' Theremis, au Bazar de Lune-d\u2019argent, \u00e0 c\u00f4t\u00e9 des commandes d\u2019artisanat. Il propose une ligne par m\u00e9tier : tu peux r\u00e9initialiser le Forgeage et laisser l\u2019Enchantement intact.' + N
    + '\u2022 ' + W + 'Ce que tu r\u00e9cup\u00e8res :' + R + ' chaque point de Connaissance d\u00e9pens\u00e9 dans les arbres Midnight de ce m\u00e9tier, libre de le replacer.' + N
    + '\u2022 ' + W + 'Ce que \u00e7a co\u00fbte :' + R + ' l\u2019avertissement du jeu dit \u00ab You will lose all associated recipes \u00bb.' + N
    + '\u2022 ' + W + 'Associ\u00e9es, pas toutes.' + R + ' Ce qui part, c\u2019est ce que ces sp\u00e9cialisations avaient d\u00e9bloqu\u00e9. Les recettes apprises d\u2019un ma\u00eetre, d\u2019un butin ou d\u2019une qu\u00eate sont hors des arbres et restent. Observ\u00e9 sur un Enchantement r\u00e9initialis\u00e9 : la liste de recettes \u00e9tait intacte et la Connaissance d\u00e9pens\u00e9e \u00e9tait revenue au compteur.' + N
    + '\u2022 ' + W + 'C\u2019est une seule fois.' + R + ' La confirmation \u00e9crit ONCE en majuscules, et c\u2019est par m\u00e9tier \u2014 pas de deuxi\u00e8me essai si la nouvelle voie te d\u00e9\u00e7oit.' + N
    + '\u2022 D\u00e9cide donc ' + W + 'avant' + R + ' de confirmer. La page M\u00e9tiers indique l\u2019arbre \u00e0 remplir et le n\u0153ud exact.' + N
    + '\u2022 Les recettes reprises reviennent-elles si tu red\u00e9penses \u00e0 l\u2019identique ? Le jeu ne le dit nulle part. Pr\u00e9vois que non.'
)
BODY['esES'] = (
    '\u2022 El parche 12.1 permite deshacer tus elecciones de especializaci\u00f3n Midnight \u2014 una vez por profesi\u00f3n.' + N
    + '\u2022 ' + W + 'Con qui\u00e9n:' + R + ' Theremis, en el Bazar de Ciudad Lunargenta junto a los encargos de artesan\u00eda. Ofrece una l\u00ednea por profesi\u00f3n, as\u00ed que puedes reiniciar Herrer\u00eda y dejar Encantamiento intacto.' + N
    + '\u2022 ' + W + 'Qu\u00e9 recuperas:' + R + ' cada punto de Conocimiento gastado en los \u00e1rboles Midnight de esa profesi\u00f3n, libre para repartir de nuevo.' + N
    + '\u2022 ' + W + 'Qu\u00e9 cuesta:' + R + ' el aviso del juego dice \u201cYou will lose all associated recipes\u201d.' + N
    + '\u2022 ' + W + 'Asociadas, no todas.' + R + ' Lo que se pierde es lo que esas especializaciones hab\u00edan desbloqueado. Las recetas de un maestro, de un bot\u00edn o de una misi\u00f3n est\u00e1n fuera de los \u00e1rboles y se quedan. Visto en un Encantamiento reiniciado: la lista de recetas estaba intacta y el Conocimiento gastado hab\u00eda vuelto al contador.' + N
    + '\u2022 ' + W + 'Es una sola vez.' + R + ' La confirmaci\u00f3n escribe ONCE en may\u00fasculas, y es por profesi\u00f3n \u2014 no hay segundo intento si el nuevo camino decepciona.' + N
    + '\u2022 Decide ' + W + 'antes' + R + ' de confirmar. La p\u00e1gina de Profesiones nombra el \u00e1rbol a llenar y el nodo exacto.' + N
    + '\u2022 \u00bfVuelven las recetas retiradas si repartes igual que antes? El juego no lo dice en ninguna parte. Cuenta con que no.'
)
BODY['ptBR'] = (
    '\u2022 O patch 12.1 permite desfazer as tuas escolhas de especializa\u00e7\u00e3o Midnight \u2014 uma vez por profiss\u00e3o.' + N
    + '\u2022 ' + W + 'Com quem:' + R + ' Theremis, no Bazar de Luaprata junto \u00e0s encomendas de profiss\u00e3o. Oferece uma linha por profiss\u00e3o, por isso podes reiniciar Ferraria e deixar Encantamento intacto.' + N
    + '\u2022 ' + W + 'O que recuperas:' + R + ' cada ponto de Conhecimento gasto nas \u00e1rvores Midnight dessa profiss\u00e3o, livre para redistribuir.' + N
    + '\u2022 ' + W + 'O que custa:' + R + ' o aviso do jogo diz \u201cYou will lose all associated recipes\u201d.' + N
    + '\u2022 ' + W + 'Associadas, n\u00e3o todas.' + R + ' O que se perde \u00e9 o que essas especializa\u00e7\u00f5es tinham desbloqueado. As receitas de um treinador, de um despojo ou de uma miss\u00e3o est\u00e3o fora das \u00e1rvores e ficam. Visto num Encantamento reiniciado: a lista de receitas estava intacta e o Conhecimento gasto tinha voltado ao contador.' + N
    + '\u2022 ' + W + '\u00c9 uma s\u00f3 vez.' + R + ' A confirma\u00e7\u00e3o escreve ONCE em mai\u00fasculas, e \u00e9 por profiss\u00e3o \u2014 n\u00e3o h\u00e1 segunda tentativa se o novo caminho desiludir.' + N
    + '\u2022 Decide ' + W + 'antes' + R + ' de confirmar. A p\u00e1gina de Profiss\u00f5es indica a \u00e1rvore a preencher e o n\u00f3 exato.' + N
    + '\u2022 As receitas retiradas voltam se redistribu\u00edres igual? O jogo nunca o diz. Conta que n\u00e3o.'
)
BODY['itIT'] = (
    '\u2022 La patch 12.1 permette di annullare le scelte di specializzazione Midnight \u2014 una volta per professione.' + N
    + '\u2022 ' + W + 'Da chi:' + R + ' Theremis, nel Bazaar di Lunargenta accanto agli ordini di artigianato. Offre una riga per professione, quindi puoi azzerare Forgiatura e lasciare Incantamento intatto.' + N
    + '\u2022 ' + W + 'Cosa recuperi:' + R + ' ogni punto Conoscenza speso negli alberi Midnight di quella professione, libero di essere ridistribuito.' + N
    + '\u2022 ' + W + 'Quanto costa:' + R + ' l\u2019avviso del gioco dice \u201cYou will lose all associated recipes\u201d.' + N
    + '\u2022 ' + W + 'Associate, non tutte.' + R + ' Sparisce ci\u00f2 che quelle specializzazioni avevano sbloccato. Le ricette imparate da un maestro, da un bottino o da una missione stanno fuori dagli alberi e restano. Osservato su un Incantamento azzerato: la lista delle ricette era intatta e la Conoscenza spesa era tornata sul contatore.' + N
    + '\u2022 ' + W + '\u00c8 una volta sola.' + R + ' La conferma scrive ONCE in maiuscolo, e vale per professione \u2014 nessun secondo tentativo se la nuova strada delude.' + N
    + '\u2022 Decidi ' + W + 'prima' + R + ' di confermare. La pagina Professioni indica l\u2019albero da riempire e il nodo esatto.' + N
    + '\u2022 Le ricette tolte tornano se ridistribuisci in modo identico? Il gioco non lo dice mai. Conta che non sia cos\u00ec.'
)

for code, text in BODY.items():
    assert '"' not in text, (code, text[:60])

t = open(P, encoding='utf-8', newline='').read()
changed, missed = 0, []
for code, text in BODY.items():
    marker = 'ns._mhLocales.%s, {' % code
    start = t.find(marker)
    if start == -1:
        missed.append(code)
        continue
    pat = re.compile(r'^\t%s = "(?:[^"\\]|\\.)*",' % B, re.M)
    m = pat.search(t, start)
    if not m:
        missed.append(code)
        continue
    t = t[:m.start()] + '\t%s = "%s",' % (B, text) + t[m.end():]
    changed += 1

if missed:
    print('NIET aangepast: ' + ', '.join(missed))
print('%d talen herschreven' % changed)
if changed:
    io.open(P + '.tmp', 'w', encoding='utf-8', newline='').write(t)
    os.replace(P + '.tmp', P)
