"""Scratch script — rewritten per task, always run as tools/_probe.py.

Right now: DELVE_TIP_UNMEASURED, next to OPEN_TIP_CAPPED, all seven packs.

One string for the two 12.1 delves that now appear in the coach with nothing in
them. It has to say why it is empty without sounding broken -- the delve is real,
the tips are not written, and nobody has walked it yet.
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

NEW = {
    'enUS': 'New in patch 12.1, on the Coiled Isle. Midnight Helper found this delve on your own client, but nobody has walked it yet — so there is no route, no trash list and no boss plan here rather than a borrowed one. It fills in once it has been run.',
    'nlNL': 'Nieuw in patch 12.1, op de Coiled Isle. Midnight Helper vond deze delve op je eigen client, maar niemand heeft hem gelopen — dus hier staat geen route, geen trash-lijst en geen bossplan, in plaats van een geleende. Hij vult zich zodra hij gedaan is.',
    'deDE': 'Neu in Patch 12.1, auf der Coiled Isle. Midnight Helper hat diesen Delve auf deinem eigenen Client gefunden, aber noch niemand ist ihn gelaufen — deshalb steht hier keine Route, keine Trash-Liste und kein Bossplan statt eines geliehenen. Er füllt sich, sobald er gelaufen wurde.',
    'frFR': 'Nouveau dans le patch 12.1, sur la Coiled Isle. Midnight Helper a trouvé ce delve sur ton propre client, mais personne ne l’a encore parcouru — donc pas de route, pas de liste de trash et pas de plan de boss ici, plutôt qu’un emprunté. Ça se remplira une fois fait.',
    'esES': 'Nuevo en el parche 12.1, en la Coiled Isle. Midnight Helper encontró este delve en tu propio cliente, pero nadie lo ha recorrido todavía — así que aquí no hay ruta, ni lista de trash, ni plan de jefe, en vez de uno prestado. Se rellenará cuando se haya hecho.',
    'ptBR': 'Novo no patch 12.1, na Coiled Isle. O Midnight Helper encontrou este delve no teu próprio cliente, mas ainda ninguém o percorreu — por isso aqui não há rota, nem lista de trash, nem plano de boss, em vez de um emprestado. Preenche-se assim que for feito.',
    'itIT': 'Nuovo nella patch 12.1, sulla Coiled Isle. Midnight Helper ha trovato questo delve sul tuo client, ma nessuno lo ha ancora percorso — quindi qui non c’è una rotta, né una lista di trash, né un piano per il boss, invece di uno preso in prestito. Si riempirà una volta fatto.',
}

for text in NEW.values():
    assert '"' not in text, text[:50]

TARGETS = [
    (os.path.join(BASE, 'enUS.lua'), ['enUS']),
    (os.path.join(BASE, 'nlNL.lua'), ['nlNL']),
    (os.path.join(BASE, 'Translations2026.lua'), ['deDE', 'frFR', 'esES', 'ptBR', 'itIT']),
]

for path, codes in TARGETS:
    name = os.path.basename(path)
    t = io.open(path, encoding='utf-8', newline='').read()
    if 'DELVE_TIP_UNMEASURED' in t:
        print('%s: staat er al' % name)
        continue
    eol = '\r\n' if '\r\n' in t else '\n'
    out, added = [], 0
    for line in t.split(eol):
        out.append(line)
        if 'OPEN_TIP_CAPPED' in line and added < len(codes):
            indent = line[:len(line) - len(line.lstrip())]
            out.append('%sDELVE_TIP_UNMEASURED = "%s",' % (indent, NEW[codes[added]]))
            added += 1
    if added != len(codes):
        print('%s: %d van %d — NIETS geschreven' % (name, added, len(codes)))
        sys.exit(1)
    io.open(path + '.tmp', 'w', encoding='utf-8', newline='').write(eol.join(out))
    os.replace(path + '.tmp', path)
    print('%s: %d toegevoegd' % (name, added))
