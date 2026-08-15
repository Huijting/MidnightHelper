"""Scratch script — rewritten per task, always run as tools/_probe.py.

Right now: two bullets of CODEX_ATALUTEK_BODY in all seven languages.

1. The Altar bullet said "what its nodes hand out has not been measured". Four
   of them are now known, and they share one shape worth teaching.
2. The rares bullet said "nobody knows where they stand". That is still true and
   it is no longer a gap: they spawn after a Temple Incursion, ten-minute
   window. Knowing why there is no coordinate is the actual answer.

Per-language anchors, because each language puts its own article in front of
the English name. The Altar bullet ends at the next |n; the rares bullet is the
LAST one in the string, so it ends at the closing quote.
"""
import io
import os
import sys

for _s in (sys.stdout, sys.stderr):
    try:
        _s.reconfigure(encoding="utf-8", errors="replace")
    except (AttributeError, ValueError):
        pass

P = r'E:\World of Warcraft\_retail_\Interface\AddOns\MidnightHelper\Locales\Codex.lua'
W, R = '|cffffffff', '|r'

LANGS = ['enUS', 'itIT', 'nlNL', 'deDE', 'frFR', 'esES', 'ptBR']

ALTAR_OLD = {
    'enUS': '• %sThe Altar of Corrosion%s is the node tree' % (W, R),
    'itIT': '• %sL\'Altar of Corrosion%s è l\'albero' % (W, R),
    'nlNL': '• %sThe Altar of Corrosion%s is de boom' % (W, R),
    'deDE': '• %sDer Altar of Corrosion%s ist der Knotenbaum' % (W, R),
    'frFR': '• %sL\'Altar of Corrosion%s est l\'arbre' % (W, R),
    'esES': '• %sEl Altar of Corrosion%s es el árbol' % (W, R),
    'ptBR': '• %sO Altar of Corrosion%s é a árvore' % (W, R),
}

RARES_OLD = {
    'enUS': '• %sThree rare elites on the main map%s' % (W, R),
    'itIT': '• %sTre rari elite sulla mappa principale%s' % (W, R),
    'nlNL': '• %sDrie rare elites op de hoofdkaart%s' % (W, R),
    'deDE': '• %sDrei seltene Elite-Gegner auf der Hauptkarte%s' % (W, R),
    'frFR': '• %sTrois élites rares sur la carte principale%s' % (W, R),
    'esES': '• %sTres élites raros en el mapa principal%s' % (W, R),
    'ptBR': '• %sTrês elites raros no mapa principal%s' % (W, R),
}

# Item, node and choice names stay English: Blizzard owns them and the player's
# own screen will show them that way.
ALTAR_NEW = {
    'enUS': (
        '• %sThe Altar of Corrosion%s is the node tree the last quest of the chain opens. Most of it '
        'unlocks as you spend, but %sfour nodes sit behind a key you have to go and find%s — and all four '
        'work the same way: an item drops, you use it on one object somewhere in the Vaults, that gives a '
        'quest item, and Er’inye takes it from there.|n'
        '%sCorroded Key%s → the Venom-Worn Coffer → %sRun of the Vaults%s (Glideways, or Swift Steps) · '
        '%sSpirit Loupe%s → the Feather of Tok’jara at %s48.46, 25.80%s → %sSpectral Winds%s (Spirit Walk, or '
        'Spectral Shipping) · %sExcising Knife%s → the Eye of Szarith, in a venom pool in the Underbelly → '
        '%sBroodmaster%s (+100%% damage to eggs, or −75%% damage from egg bursts) · %sDispelling Charm%s → '
        'Jin’tal’s Reliquary in the Profaned Mausoleum → %sSpiritual Protection%s (ghostly allies at Curse '
        'Surges, or getting straight back up when you die outside the Vaults).|n'
        '%sShowing a key to Er’inye does not unlock anything.%s He is blind, and he tells you what he feels '
        '— that is a hint about where the thing belongs. %sWhere the keys drop is not settled|r: three '
        'careful reads of the same database gave three different answers, so we are not going to name one. '
        'Run Strikes and Incursions and they turn up.'
    ) % (W, R, W, R, W, R, W, R, W, R, W, R, W, R, W, R, W, R, W, R, W, R, W, R, W),
    'itIT': (
        '• %sL\'Altar of Corrosion%s è l\'albero di nodi che apre l\'ultima missione della catena. Gran parte '
        'si sblocca spendendo, ma %squattro nodi stanno dietro a una chiave che devi trovare%s — e tutti e '
        'quattro funzionano allo stesso modo: cade un oggetto, lo usi su un oggetto fisso da qualche parte '
        'nelle Vaults, quello dà un oggetto missione, ed Er’inye fa il resto.|n'
        '%sCorroded Key%s → il Venom-Worn Coffer → %sRun of the Vaults%s (Glideways, oppure Swift Steps) · '
        '%sSpirit Loupe%s → la Feather of Tok’jara a %s48.46, 25.80%s → %sSpectral Winds%s (Spirit Walk, '
        'oppure Spectral Shipping) · %sExcising Knife%s → l\'Eye of Szarith, in una pozza di veleno nella '
        'Underbelly → %sBroodmaster%s (+100%% danni alle uova, oppure −75%% danni dalle esplosioni) · '
        '%sDispelling Charm%s → Jin’tal’s Reliquary nel Profaned Mausoleum → %sSpiritual Protection%s '
        '(alleati spettrali ai Curse Surge, oppure rialzarti subito se muori fuori dalle Vaults).|n'
        '%sMostrare una chiave a Er’inye non sblocca nulla.%s È cieco, e ti dice cosa sente — è un indizio su '
        'dove va quell\'oggetto. %sDa dove cadano le chiavi non è stabilito|r: tre letture attente dello '
        'stesso database hanno dato tre risposte diverse, quindi non ne indichiamo una. Fai Strike e '
        'Incursion e saltano fuori.'
    ) % (W, R, W, R, W, R, W, R, W, R, W, R, W, R, W, R, W, R, W, R, W, R, W, R, W),
    'nlNL': (
        '• %sThe Altar of Corrosion%s is de boom met nodes die de laatste quest van de keten opent. Het '
        'meeste gaat vanzelf open naarmate je uitgeeft, maar %svier nodes zitten achter een sleutel die je '
        'zelf moet vinden%s — en alle vier werken ze hetzelfde: er valt een item, dat gebruik je op één '
        'object ergens in de Vaults, dat geeft een questitem, en Er’inye doet de rest.|n'
        '%sCorroded Key%s → de Venom-Worn Coffer → %sRun of the Vaults%s (Glideways, of Swift Steps) · '
        '%sSpirit Loupe%s → de Feather of Tok’jara op %s48.46, 25.80%s → %sSpectral Winds%s (Spirit Walk, of '
        'Spectral Shipping) · %sExcising Knife%s → de Eye of Szarith, in een gifpoel in de Underbelly → '
        '%sBroodmaster%s (+100%% schade op eggs, of −75%% schade van egg bursts) · %sDispelling Charm%s → '
        'Jin’tal’s Reliquary in het Profaned Mausoleum → %sSpiritual Protection%s (spookbondgenoten bij '
        'Curse Surges, of meteen weer opstaan als je buiten de Vaults doodgaat).|n'
        '%sEen sleutel aan Er’inye tonen ontgrendelt niets.%s Hij is blind, en hij vertelt je wat hij vóélt — '
        'dat is een hint over waar het ding hoort. %sWaar de sleutels vandaan komen staat niet vast|r: drie '
        'zorgvuldige lezingen van dezelfde database gaven drie verschillende antwoorden, dus we noemen er '
        'geen. Doe Strikes en Incursions, dan komen ze vanzelf.'
    ) % (W, R, W, R, W, R, W, R, W, R, W, R, W, R, W, R, W, R, W, R, W, R, W, R, W),
    'deDE': (
        '• %sDer Altar of Corrosion%s ist der Knotenbaum, den die letzte Quest der Kette öffnet. Das meiste '
        'öffnet sich beim Ausgeben, aber %svier Knoten liegen hinter einem Schlüssel, den du selbst finden '
        'musst%s — und alle vier funktionieren gleich: ein Gegenstand fällt, du benutzt ihn an einem Objekt '
        'irgendwo in den Vaults, das gibt einen Questgegenstand, und Er’inye macht den Rest.|n'
        '%sCorroded Key%s → die Venom-Worn Coffer → %sRun of the Vaults%s (Glideways, oder Swift Steps) · '
        '%sSpirit Loupe%s → die Feather of Tok’jara bei %s48.46, 25.80%s → %sSpectral Winds%s (Spirit Walk, '
        'oder Spectral Shipping) · %sExcising Knife%s → das Eye of Szarith, in einem Gifttümpel in der '
        'Underbelly → %sBroodmaster%s (+100%% Schaden an Eiern, oder −75%% Schaden durch Eierexplosionen) · '
        '%sDispelling Charm%s → Jin’tal’s Reliquary im Profaned Mausoleum → %sSpiritual Protection%s '
        '(geisterhafte Verbündete bei Curse Surges, oder sofort wieder aufstehen, wenn du außerhalb der '
        'Vaults stirbst).|n'
        '%sEinem Er’inye einen Schlüssel zu zeigen schaltet nichts frei.%s Er ist blind und sagt dir, was er '
        'fühlt — das ist ein Hinweis darauf, wohin der Gegenstand gehört. %sWoher die Schlüssel fallen, ist '
        'nicht geklärt|r: drei sorgfältige Lesungen derselben Datenbank ergaben drei verschiedene Antworten, '
        'also nennen wir keine. Mach Strikes und Incursions, dann tauchen sie auf.'
    ) % (W, R, W, R, W, R, W, R, W, R, W, R, W, R, W, R, W, R, W, R, W, R, W, R, W),
    'frFR': (
        '• %sL\'Altar of Corrosion%s est l\'arbre de nœuds qu\'ouvre la dernière quête de la chaîne. '
        'L\'essentiel s\'ouvre en dépensant, mais %squatre nœuds sont derrière une clé que tu dois aller '
        'chercher%s — et les quatre fonctionnent pareil : un objet tombe, tu l\'utilises sur un objet fixe '
        'quelque part dans les Vaults, ça donne un objet de quête, et Er’inye fait le reste.|n'
        '%sCorroded Key%s → le Venom-Worn Coffer → %sRun of the Vaults%s (Glideways, ou Swift Steps) · '
        '%sSpirit Loupe%s → la Feather of Tok’jara en %s48.46, 25.80%s → %sSpectral Winds%s (Spirit Walk, ou '
        'Spectral Shipping) · %sExcising Knife%s → l\'Eye of Szarith, dans une mare de venin de l\'Underbelly '
        '→ %sBroodmaster%s (+100%% de dégâts aux œufs, ou −75%% de dégâts des explosions d\'œufs) · '
        '%sDispelling Charm%s → Jin’tal’s Reliquary dans le Profaned Mausoleum → %sSpiritual Protection%s '
        '(alliés spectraux aux Curse Surges, ou te relever aussitôt si tu meurs hors des Vaults).|n'
        '%sMontrer une clé à Er’inye ne débloque rien.%s Il est aveugle et te dit ce qu\'il ressent — c\'est '
        'un indice sur l\'endroit où va l\'objet. %sD\'où tombent les clés n\'est pas tranché|r : trois '
        'lectures attentives de la même base ont donné trois réponses différentes, donc on n\'en désigne '
        'aucune. Fais des Strikes et des Incursions, elles finissent par tomber.'
    ) % (W, R, W, R, W, R, W, R, W, R, W, R, W, R, W, R, W, R, W, R, W, R, W, R, W),
    'esES': (
        '• %sEl Altar of Corrosion%s es el árbol de nodos que abre la última misión de la cadena. La mayoría '
        'se abre al gastar, pero %scuatro nodos están detrás de una llave que tienes que ir a buscar%s — y '
        'los cuatro funcionan igual: cae un objeto, lo usas sobre un objeto fijo en algún punto de las '
        'Vaults, eso da un objeto de misión, y Er’inye hace el resto.|n'
        '%sCorroded Key%s → el Venom-Worn Coffer → %sRun of the Vaults%s (Glideways, o Swift Steps) · '
        '%sSpirit Loupe%s → la Feather of Tok’jara en %s48.46, 25.80%s → %sSpectral Winds%s (Spirit Walk, o '
        'Spectral Shipping) · %sExcising Knife%s → el Eye of Szarith, en una charca de veneno de la '
        'Underbelly → %sBroodmaster%s (+100%% de daño a los huevos, o −75%% de daño de sus estallidos) · '
        '%sDispelling Charm%s → Jin’tal’s Reliquary en el Profaned Mausoleum → %sSpiritual Protection%s '
        '(aliados fantasmales en los Curse Surges, o levantarte al instante si mueres fuera de las Vaults).|n'
        '%sEnseñarle una llave a Er’inye no desbloquea nada.%s Es ciego y te cuenta lo que siente — eso es '
        'una pista de dónde va el objeto. %sDe dónde caen las llaves no está resuelto|r: tres lecturas '
        'cuidadosas de la misma base de datos dieron tres respuestas distintas, así que no señalamos '
        'ninguna. Haz Strikes e Incursions y acaban apareciendo.'
    ) % (W, R, W, R, W, R, W, R, W, R, W, R, W, R, W, R, W, R, W, R, W, R, W, R, W),
    'ptBR': (
        '• %sO Altar of Corrosion%s é a árvore de nós que a última missão da cadeia abre. A maior parte '
        'abre-se à medida que gastas, mas %squatro nós estão atrás de uma chave que tens de ir procurar%s — '
        'e os quatro funcionam da mesma maneira: cai um item, usa-lo num objeto fixo algures nas Vaults, '
        'isso dá um item de missão, e Er’inye trata do resto.|n'
        '%sCorroded Key%s → o Venom-Worn Coffer → %sRun of the Vaults%s (Glideways, ou Swift Steps) · '
        '%sSpirit Loupe%s → a Feather of Tok’jara em %s48.46, 25.80%s → %sSpectral Winds%s (Spirit Walk, ou '
        'Spectral Shipping) · %sExcising Knife%s → o Eye of Szarith, numa poça de veneno na Underbelly → '
        '%sBroodmaster%s (+100%% de dano aos ovos, ou −75%% de dano das explosões) · %sDispelling Charm%s → '
        'Jin’tal’s Reliquary no Profaned Mausoleum → %sSpiritual Protection%s (aliados espectrais nos Curse '
        'Surges, ou levantares-te logo se morreres fora das Vaults).|n'
        '%sMostrar uma chave a Er’inye não desbloqueia nada.%s Ele é cego e diz-te o que sente — isso é uma '
        'pista de onde o objeto pertence. %sDe onde caem as chaves não está resolvido|r: três leituras '
        'cuidadosas da mesma base de dados deram três respostas diferentes, por isso não apontamos nenhuma. '
        'Faz Strikes e Incursions e acabam por aparecer.'
    ) % (W, R, W, R, W, R, W, R, W, R, W, R, W, R, W, R, W, R, W, R, W, R, W, R, W),
}

RARES_NEW = {
    'enUS': (
        '• %sThree rare elites on the main map%s — Congealed Malice, Khu\'tulak and Susarikk — make up a '
        'third, %sOppose the Foes%s. %sThey have no fixed spot, and that is the answer rather than a gap%s: '
        'one of the three wakes up the moment a %sTemple Incursion%s is completed, and you have about ten '
        'minutes to kill it. So you do not go hunting for them — you finish Incursions, and one comes to you.'
    ) % (W, R, W, R, W, R, W, R),
    'itIT': (
        '• %sTre rari elite sulla mappa principale%s — Congealed Malice, Khu\'tulak e Susarikk — formano un '
        'terzo: %sOppose the Foes%s. %sNon hanno un punto fisso, e questa è la risposta, non una lacuna%s: '
        'uno dei tre si sveglia nel momento in cui viene completata una %sTemple Incursion%s, e hai circa '
        'dieci minuti per ucciderlo. Quindi non si vanno a cercare — si finiscono le Incursion, e uno arriva.'
    ) % (W, R, W, R, W, R, W, R),
    'nlNL': (
        '• %sDrie rare elites op de hoofdkaart%s — Congealed Malice, Khu\'tulak en Susarikk — vormen een '
        'derde: %sOppose the Foes%s. %sZe hebben geen vaste plek, en dat ís het antwoord, geen gat in onze '
        'kennis%s: één van de drie wordt wakker op het moment dat er een %sTemple Incursion%s wordt '
        'afgerond, en je hebt ongeveer tien minuten om hem te doden. Je gaat dus niet op ze jagen — je maakt '
        'Incursions af, en dan komt er één naar jou toe.'
    ) % (W, R, W, R, W, R, W, R),
    'deDE': (
        '• %sDrei seltene Elite-Gegner auf der Hauptkarte%s — Congealed Malice, Khu\'tulak und Susarikk — '
        'bilden einen dritten: %sOppose the Foes%s. %sSie haben keinen festen Ort, und das ist die Antwort, '
        'keine Lücke%s: einer der drei erwacht in dem Moment, in dem eine %sTemple Incursion%s abgeschlossen '
        'wird, und du hast etwa zehn Minuten. Du jagst sie also nicht — du beendest Incursions, und einer kommt.'
    ) % (W, R, W, R, W, R, W, R),
    'frFR': (
        '• %sTrois élites rares sur la carte principale%s — Congealed Malice, Khu\'tulak et Susarikk — '
        'forment un troisième : %sOppose the Foes%s. %sIls n\'ont pas de position fixe, et c\'est la réponse, '
        'pas un manque%s : l\'un des trois se réveille dès qu\'une %sTemple Incursion%s est terminée, et tu '
        'as environ dix minutes. On ne part donc pas les chasser — on finit des Incursions, et l\'un d\'eux vient.'
    ) % (W, R, W, R, W, R, W, R),
    'esES': (
        '• %sTres élites raros en el mapa principal%s — Congealed Malice, Khu\'tulak y Susarikk — forman un '
        'tercero: %sOppose the Foes%s. %sNo tienen un sitio fijo, y esa es la respuesta, no un hueco%s: uno '
        'de los tres despierta en cuanto se completa una %sTemple Incursion%s, y tienes unos diez minutos. '
        'Así que no sales a cazarlos — terminas Incursions, y uno viene a ti.'
    ) % (W, R, W, R, W, R, W, R),
    'ptBR': (
        '• %sTrês elites raros no mapa principal%s — Congealed Malice, Khu\'tulak e Susarikk — formam uma '
        'terceira: %sOppose the Foes%s. %sNão têm um sítio fixo, e essa é a resposta, não uma falha%s: um dos '
        'três acorda no momento em que uma %sTemple Incursion%s é concluída, e tens cerca de dez minutos. '
        'Por isso não sais à caça deles — acabas Incursions, e um aparece.'
    ) % (W, R, W, R, W, R, W, R),
}

for table in (ALTAR_NEW, RARES_NEW):
    for code, text in table.items():
        assert '"' not in text, (code, text[:60])

t = io.open(P, encoding='utf-8', newline='').read()
changed = 0
problems = []

for code in LANGS:
    # --- Altar bullet: runs to the next |n ---
    start = t.find(ALTAR_OLD[code])
    if start == -1:
        problems.append('%s: altar-anker niet gevonden' % code)
        continue
    end = t.find('|n', start + len(ALTAR_OLD[code]))
    if end == -1:
        problems.append('%s: altar-einde niet gevonden' % code)
        continue
    t = t[:start] + ALTAR_NEW[code] + t[end:]

    # --- Rares bullet: LAST in the string, so it runs to the closing quote ---
    rstart = t.find(RARES_OLD[code])
    if rstart == -1:
        problems.append('%s: rares-anker niet gevonden' % code)
        continue
    rend = t.find('",', rstart)
    if rend == -1:
        problems.append('%s: rares-einde niet gevonden' % code)
        continue
    t = t[:rstart] + RARES_NEW[code] + t[rend:]

    changed += 1
    print('%s: ok' % code)

for p in problems:
    print(p)
print('%d van %d' % (changed, len(LANGS)))

if changed == len(LANGS) and not problems:
    io.open(P + '.tmp', 'w', encoding='utf-8', newline='').write(t)
    os.replace(P + '.tmp', P)
    print('geschreven')
else:
    print('NIETS geschreven — alles of niets')
