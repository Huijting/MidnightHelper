"""Scratch script — rewritten per task, always run as tools/_probe.py.

Right now: four new delve-coach bodies (overview + route for Gnarldor Isle and
The Ring of Glory), seven languages, inserted after DELVE_TIP_UNMEASURED.

Content sources, so the texts can be audited later:
- Chest coordinates: HandyNotes_Midnight zones/delves.lua (trusted for coords).
- Exits: HandyNotes_MapNotes RetailInsideDungeonNodesLocation.lua.
- Gnarldor quest chain: Zygor (trusted for quest chains).
- The absence of a boss: DBM stubs are empty, nothing on disk names one.

Proper nouns stay English everywhere: Sturdy Chest, Scrollmaster Ruma, the
delve names. Coordinates identical across languages.
"""
import io
import os
import sys

for _s in (sys.stdout, sys.stderr):
    try:
        _s.reconfigure(encoding="utf-8", errors="replace")
    except (AttributeError, ValueError):
        pass

BASE = r'E:\World of Warcraft\_retail_\Interface\AddOns\MidnightHelper\Locales'
W, R = '|cffffffff', '|r'

def bold(s):
    return W + s + R

K = {}

K['DELVE_TIP_GNARLDOR_OVERVIEW'] = {
    'enUS': '• New in 12.1, on the Coiled Isle — entrance at %s. Inside is its own map.|n• %s stands at the entrance with a short quest chain that sends you in.|n• %s No addon on this machine names one, so this page does not guess. Your runs are recorded now — the first one teaches the coach who lives here.' % (bold('64.3, 77.7'), bold('Scrollmaster Ruma'), bold('The boss is unmeasured.')),
    'nlNL': '• Nieuw in 12.1, op de Coiled Isle — ingang op %s. Binnen is een eigen kaart.|n• %s staat bij de ingang met een korte questketen die je naar binnen stuurt.|n• %s Geen addon op deze machine noemt er een, dus deze pagina gokt niet. Je runs worden nu gelogd — de eerste leert de coach wie hier woont.' % (bold('64.3, 77.7'), bold('Scrollmaster Ruma'), bold('De boss is ongemeten.')),
    'deDE': '• Neu in 12.1, auf der Coiled Isle — Eingang bei %s. Drinnen liegt eine eigene Karte.|n• %s steht am Eingang mit einer kurzen Questkette, die dich hineinschickt.|n• %s Kein Addon auf dieser Maschine nennt einen, also rät diese Seite nicht. Deine Runs werden jetzt aufgezeichnet — der erste bringt dem Coach bei, wer hier wohnt.' % (bold('64.3, 77.7'), bold('Scrollmaster Ruma'), bold('Der Boss ist nicht vermessen.')),
    'frFR': '• Nouveau en 12.1, sur la Coiled Isle — entrée en %s. À l’intérieur, sa propre carte.|n• %s se tient à l’entrée avec une courte chaîne de quêtes qui t’envoie dedans.|n• %s Aucun addon sur cette machine n’en nomme un, donc cette page ne devine pas. Tes runs sont enregistrés désormais — le premier apprend au coach qui vit ici.' % (bold('64.3, 77.7'), bold('Scrollmaster Ruma'), bold('Le boss n’est pas mesuré.')),
    'esES': '• Nuevo en 12.1, en la Coiled Isle — entrada en %s. Dentro tiene su propio mapa.|n• %s está en la entrada con una breve cadena de misiones que te manda dentro.|n• %s Ningún addon de esta máquina nombra uno, así que esta página no adivina. Tus runs se registran desde ahora — la primera le enseña al coach quién vive aquí.' % (bold('64.3, 77.7'), bold('Scrollmaster Ruma'), bold('El jefe no está medido.')),
    'ptBR': '• Novo na 12.1, na Coiled Isle — entrada em %s. Lá dentro tem o seu próprio mapa.|n• %s está na entrada com uma pequena cadeia de missões que te manda para dentro.|n• %s Nenhum addon nesta máquina nomeia um, por isso esta página não adivinha. As tuas runs são registadas agora — a primeira ensina ao coach quem vive aqui.' % (bold('64.3, 77.7'), bold('Scrollmaster Ruma'), bold('O chefe não está medido.')),
    'itIT': '• Nuovo nella 12.1, sulla Coiled Isle — ingresso a %s. Dentro ha una mappa propria.|n• %s sta all’ingresso con una breve catena di missioni che ti manda dentro.|n• %s Nessun addon su questa macchina ne nomina uno, quindi questa pagina non tira a indovinare. Le tue run ora vengono registrate — la prima insegna al coach chi vive qui.' % (bold('64.3, 77.7'), bold('Scrollmaster Ruma'), bold('Il boss non è misurato.')),
}

GN_COORDS = '%s · %s · %s' % (bold('60.44, 68.12'), bold('52.41, 40.84'), bold('28.67, 41.69'))
K['DELVE_TIP_GNARLDOR_ROUTE'] = {
    'enUS': '• Three %s count toward the delve’s discovery achievement. On the delve’s own map: %s.|n• You arrive at about 77, 46 and the exit portal is right there — sweep the chests and you end where you started.' % (bold('Sturdy Chests'), GN_COORDS),
    'nlNL': '• Drie %s tellen voor het discovery-achievement van de delve. Op de binnenkaart: %s.|n• Je komt binnen rond 77, 46 en de uitgang staat daar ook — loop de kisten langs en je eindigt waar je begon.' % (bold('Sturdy Chests'), GN_COORDS),
    'deDE': '• Drei %s zählen für den Entdeckungs-Erfolg des Delves. Auf der eigenen Karte: %s.|n• Du kommst bei etwa 77, 46 an, und das Ausgangsportal steht genau dort — lauf die Truhen ab und du endest, wo du angefangen hast.' % (bold('Sturdy Chests'), GN_COORDS),
    'frFR': '• Trois %s comptent pour le haut fait de découverte du delve. Sur sa propre carte : %s.|n• Tu arrives vers 77, 46 et le portail de sortie est juste là — fais le tour des coffres et tu finis où tu as commencé.' % (bold('Sturdy Chests'), GN_COORDS),
    'esES': '• Tres %s cuentan para el logro de descubrimiento del delve. En su propio mapa: %s.|n• Llegas hacia 77, 46 y el portal de salida está justo ahí — recorre los cofres y acabas donde empezaste.' % (bold('Sturdy Chests'), GN_COORDS),
    'ptBR': '• Três %s contam para a proeza de descoberta do delve. No seu próprio mapa: %s.|n• Chegas por volta de 77, 46 e o portal de saída está mesmo aí — percorre as arcas e acabas onde começaste.' % (bold('Sturdy Chests'), GN_COORDS),
    'itIT': '• Tre %s contano per l’impresa di scoperta del delve. Sulla sua mappa: %s.|n• Arrivi verso 77, 46 e il portale d’uscita è proprio lì — fai il giro dei forzieri e finisci dove hai iniziato.' % (bold('Sturdy Chests'), GN_COORDS),
}

K['DELVE_TIP_RINGOFGLORY_OVERVIEW'] = {
    'enUS': '• New in 12.1, on the Coiled Isle — entrance at %s. The game lays its inside out like a dungeon map rather than a cave.|n• %s No addon on this machine names one, so this page does not guess. Your runs are recorded now — the first one fills this in.' % (bold('71.1, 56.4'), bold('Who you fight is unmeasured.')),
    'nlNL': '• Nieuw in 12.1, op de Coiled Isle — ingang op %s. Het spel zet de binnenkant op als een dungeonkaart, niet als een grot.|n• %s Geen addon op deze machine noemt er een, dus deze pagina gokt niet. Je runs worden nu gelogd — de eerste vult dit in.' % (bold('71.1, 56.4'), bold('Tegen wie je vecht is ongemeten.')),
    'deDE': '• Neu in 12.1, auf der Coiled Isle — Eingang bei %s. Das Spiel legt das Innere als Dungeonkarte an, nicht als Höhle.|n• %s Kein Addon auf dieser Maschine nennt einen, also rät diese Seite nicht. Deine Runs werden jetzt aufgezeichnet — der erste füllt das hier.' % (bold('71.1, 56.4'), bold('Gegen wen du kämpfst, ist nicht vermessen.')),
    'frFR': '• Nouveau en 12.1, sur la Coiled Isle — entrée en %s. Le jeu présente l’intérieur comme une carte de donjon, pas comme une grotte.|n• %s Aucun addon sur cette machine n’en nomme un, donc cette page ne devine pas. Tes runs sont enregistrés désormais — le premier remplira ceci.' % (bold('71.1, 56.4'), bold('Contre qui tu te bats n’est pas mesuré.')),
    'esES': '• Nuevo en 12.1, en la Coiled Isle — entrada en %s. El juego presenta el interior como un mapa de mazmorra, no como una cueva.|n• %s Ningún addon de esta máquina nombra uno, así que esta página no adivina. Tus runs se registran desde ahora — la primera rellenará esto.' % (bold('71.1, 56.4'), bold('Contra quién luchas no está medido.')),
    'ptBR': '• Novo na 12.1, na Coiled Isle — entrada em %s. O jogo apresenta o interior como um mapa de masmorra, não como uma gruta.|n• %s Nenhum addon nesta máquina nomeia um, por isso esta página não adivinha. As tuas runs são registadas agora — a primeira preencherá isto.' % (bold('71.1, 56.4'), bold('Contra quem lutas não está medido.')),
    'itIT': '• Nuovo nella 12.1, sulla Coiled Isle — ingresso a %s. Il gioco imposta l’interno come una mappa da dungeon, non come una grotta.|n• %s Nessun addon su questa macchina ne nomina uno, quindi questa pagina non tira a indovinare. Le tue run ora vengono registrate — la prima riempirà questa parte.' % (bold('71.1, 56.4'), bold('Contro chi combatti non è misurato.')),
}

RG_COORDS = '%s · %s · %s' % (bold('44.16, 22.60'), bold('25.19, 73.74'), bold('48.56, 94.84'))
K['DELVE_TIP_RINGOFGLORY_ROUTE'] = {
    'enUS': '• Three %s count toward the delve’s discovery achievement. On the delve’s own map: %s.|n• The exit portal is at %s.' % (bold('Sturdy Chests'), RG_COORDS, bold('80.10, 53.69')),
    'nlNL': '• Drie %s tellen voor het discovery-achievement van de delve. Op de binnenkaart: %s.|n• De uitgang staat op %s.' % (bold('Sturdy Chests'), RG_COORDS, bold('80.10, 53.69')),
    'deDE': '• Drei %s zählen für den Entdeckungs-Erfolg des Delves. Auf der eigenen Karte: %s.|n• Das Ausgangsportal steht bei %s.' % (bold('Sturdy Chests'), RG_COORDS, bold('80.10, 53.69')),
    'frFR': '• Trois %s comptent pour le haut fait de découverte du delve. Sur sa propre carte : %s.|n• Le portail de sortie est en %s.' % (bold('Sturdy Chests'), RG_COORDS, bold('80.10, 53.69')),
    'esES': '• Tres %s cuentan para el logro de descubrimiento del delve. En su propio mapa: %s.|n• El portal de salida está en %s.' % (bold('Sturdy Chests'), RG_COORDS, bold('80.10, 53.69')),
    'ptBR': '• Três %s contam para a proeza de descoberta do delve. No seu próprio mapa: %s.|n• O portal de saída está em %s.' % (bold('Sturdy Chests'), RG_COORDS, bold('80.10, 53.69')),
    'itIT': '• Tre %s contano per l’impresa di scoperta del delve. Sulla sua mappa: %s.|n• Il portale d’uscita è a %s.' % (bold('Sturdy Chests'), RG_COORDS, bold('80.10, 53.69')),
}

for key, table in K.items():
    for code, text in table.items():
        assert '"' not in text, (key, code, text[:50])

TARGETS = [
    (os.path.join(BASE, 'enUS.lua'), ['enUS']),
    (os.path.join(BASE, 'nlNL.lua'), ['nlNL']),
    (os.path.join(BASE, 'Translations2026.lua'), ['deDE', 'frFR', 'esES', 'ptBR', 'itIT']),
]

ORDER = ['DELVE_TIP_GNARLDOR_OVERVIEW', 'DELVE_TIP_GNARLDOR_ROUTE',
         'DELVE_TIP_RINGOFGLORY_OVERVIEW', 'DELVE_TIP_RINGOFGLORY_ROUTE']

for path, codes in TARGETS:
    name = os.path.basename(path)
    t = io.open(path, encoding='utf-8', newline='').read()
    if 'DELVE_TIP_GNARLDOR_OVERVIEW' in t:
        print('%s: staat er al' % name)
        continue
    eol = '\r\n' if '\r\n' in t else '\n'
    out, added = [], 0
    # Anchor on DELVE_TIP_UNMEASURED, added earlier today: one per pack, in file
    # order de/fr/es/pt/it inside the fill-file.
    for line in t.split(eol):
        out.append(line)
        if 'DELVE_TIP_UNMEASURED' in line and added < len(codes):
            indent = line[:len(line) - len(line.lstrip())]
            code = codes[added]
            for key in ORDER:
                out.append('%s%s = "%s",' % (indent, key, K[key][code]))
            added += 1
    if added != len(codes):
        print('%s: %d van %d ankers — NIETS geschreven' % (name, added, len(codes)))
        sys.exit(1)
    io.open(path + '.tmp', 'w', encoding='utf-8', newline='').write(eol.join(out))
    os.replace(path + '.tmp', path)
    print('%s: %d talen x 4 keys' % (name, added))
