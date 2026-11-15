# patch_watch — meetscripts voor een nieuwe patch (live tegen PTR)

Gemaakt door de speur-agenten van 15 nov 2026 voor patch 12.1.7 (zie `docs/PATCH_12_1_7_DRAAIBOEK.md` §5), ongewijzigd
uit de scratchpad gekopieerd zodat ze niet verloren gaan. Niet opgepoetst: lees een script vóór je het draait.

- `t4_diff.py <live> <ptr>` — klassen/spells (SpellName, Spell, SpellEffect, Trait*). Draai eerst de controle
  `12.1.5.70575 12.1.5.70688` (moet de hotfix van 27 okt vinden).
- `p2_gd_diff.py`, `p2_detail.py` — speldata-tabellen (Achievement, QuestV2, CurrencyTypes, Item, Holidays, …).
- `decode_holidays.py`, `diff_holidays.py` — eventdata (Holidays) uitlezen en live/PTR vergelijken.
- `uisrc_tree_diff.py`, `apidiff.py`, `apidiff2.py` — Blizzards UI-bron / API-docs tussen twee builds.

⚠️ Ze schreven hun uitvoer naast zichzelf (de scratchpad). Draai ze via de voordeur (`scratch …` in `probe_job.txt` na
kopiëren naar je scratchpad, of maak er een `run`-tool van). Paden in de scripts kunnen nog naar de oude scratchpad wijzen.
