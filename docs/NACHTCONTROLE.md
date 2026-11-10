# Nachtcontrole — events en spel-nummers (C1 + C2)

Logboek van de cloud-routine **"MH nachtcontrole — events en spel-id's (C1/C2)"** (sinds 10 nov 2026; plan
`docs/PLAN_WERKWIJZE_2026-11-10.md` deel 2 en 3). Elke nacht:

- **C1** `tools/event_check.py` tegen een VERSE eventlijst van Blizzard (live, PTR en Forever), opgehaald in een tijdelijk
  bestand. Is de lijst in de repo (`tools/blizzard_events_snapshot.json`) ouder, dan meldt hij dat; verversen doet de
  bouwchat met `run event_snapshot --write`.
- **C2** `tools/data_check.py --c2`: elk spell-, quest-, achievement-, item- en kaartnummer tegen de nieuwste DB2.

Hij meldt alleen, repareert nooit, en schrijft alleen in dit bestand. Alles is "nakijken", nooit "fout".
Nieuwste regel onderaan.

---

- [2026-11-10] 🌙 **Nachtcontrole** — C1: NIET GEDRAAID (0 nakijken bekend), builds live/ptr/forever onbekend, snapshot repo: niet vergeleken. C2: 0 nakijken, controle OK, blinde vlek 23.
  - C1: `tools/event_snapshot.py` faalde op https://api.github.com/repos/<REPO>/commits/<tak> met HTTP Error 403: Forbidden (zelfde 403 met curl op api.github.com/repos/Gethe/wow-ui-source/commits/live; wago.tools gaf 200). Geen verse eventlijst, dus ook event_check niet gedraaid. Een controle die niet draaide is niet schoon.
  - C2: wago-builds live 12.1.5.70783, ptr 12.1.7.70740, forever 1.60.1.70888; spell 1070/achievement 39/quest 341/item 25/map 71 ids, 0 nakijken, positieve controles OK. Blinde vlek: 23 regels met id-achtige toewijzing die geen patroon leest (niet gecontroleerd). 4 ids bewust genegeerd (DispelTest.lua 999001-999004).
