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
