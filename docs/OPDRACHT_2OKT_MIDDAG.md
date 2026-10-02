# Opdracht voor een verse chat — 2 okt 2026, middag

Geschreven door de lange chat van 2 okt, op Robs verzoek ("ja, zet die opdracht maar klaar"). Lees eerst
`CLAUDE.md` en de bovenste secties van `docs/NEXT_SESSION.md` (2 okt). Alle werkregels gelden (geen geketende
commando's, `probe_job.txt`, `git_stage.py` zonder argument, NEXT_SESSION in dezelfde commit, niets in de addon
zonder Robs ja).

**Waarom vandaag:** Robs weeklimiet én de Fable-pot resetten **3 okt 11:00**. Wat vandaag niet gebruikt wordt, is
weg. Stand bij het schrijven: week 63%, Fable 3%, sessie 45% (reset ±15:40).

De bestanden van de vorige chat staan in
`C:\Users\RobHu\AppData\Local\Temp\claude\E--World-of-Warcraft--retail--Interface-AddOns\bce6ed51-8e43-40f6-af21-fb6760973c6f\scratchpad\`
(hierna `OUD\`). Lezen mag; schrijf je eigen werk in je eigen scratchpad.

## A. De 7 overige M+-dungeons van Season 2 — op Fable

1. **Eerst de meting:** vraag Rob om zijn sessie-% (hij plakt het gebruiksrapport). Start dan **één** dungeon
   (Voidscar Arena, de kleinste) met `subagent_type: tips-xhigh` en `model: fable`, brief
   `OUD\dgn_xhigh\BRIEF.md`. Als die klaar is: weer het rapport. Stijgt alleen "Weekly · Fable" en niet de sessie,
   dan raakt Fable de sessie niet. Noteer het in NEXT_SESSION en in memory `effort-level-test`.
2. **Dan de andere 6 tegelijk**, zelfde opzet, één helper per dungeon:

   | dungeon | code | bazen (suffix) |
   |---|---|---|
   | Voidscar Arena | DGN_TIP_VA | TAZRAH, ATROXUS, CHARONUS |
   | Murder Row | DGN_TIP_MR | KYSTIA, ZAEN, XATHUUX, LITHIEL |
   | The Blinding Vale | DGN_TIP_BV | TRINITY, IKUZZ, RUIA, ZIEKKET |
   | Altar of Fangs | DGN_TIP_AF | RAVI, COIL, ZULJAN |
   | Kings' Rest | DGN_TIP_KR | COUNCIL, DAZAR, MCHIMBA, SERPENT |
   | Temple of Sethraliss | DGN_TIP_TS | ADDERIS, AVATAR, GALVAZZT, MEREKTHA |
   | Ruby Life Pools | DGN_TIP_RL | KOKIA, KYRAKKA, MELIDRUSSA |

3. **Den of Nalorakk is al gedaan**, twee keer: `OUD\dgn_xhigh\dn_fable.json` en `dn_opus.json`. Voeg ze samen
   (zelfde kern; neem de eigen vondsten van beide mee: ijsvloer + weg van de beren uit Fable, add-volgorde en de
   Heroic-schildvraag uit Opus; die laatste wordt een TESTLIJST-vraag).
4. **Beoordelingspagina** zoals bij de raids (`OUD\raid_xhigh\make_page.py` als voorbeeld, Artifact): oud naast
   nieuw in het Nederlands, Engels + redenen ingeklapt. **Pas na Robs ja** toepassen.
5. **Toepassen:** voorbeeld `OUD\raid_xhigh\merge_new.py` + `apply.py`. ⚠️ Dungeons staan in
   `Locales/DungeonTips.lua`, maar de fr/es/pt/it van **Altar of Fangs** staan in `Locales/Translations2026.lua`
   (15 sep, `mh_dungeon_tips_apply.py` deed beide). Vertalen met 5 helpers (`OUD\raid_xhigh\TR_BRIEF.md`), dan
   syntax, lint (baseline 0 HARD / 4 SOFT), `check_drift --mark` via `mark_drift.py`, locale_probe, TESTLIJST.

## B. De lange raidtips vóór maandagavond (Rob raidt maandag)

De 17 raid-JSON's in `OUD\raid_xhigh\<key>.json` hebben elk een lijst `steps_problems` (1-6 per baas): fouten in
`RAID_BOSS_<X>_STEPS` en de lange rolsleutels (`_TANK`/`_HEALER`/`_DPS`, níét de `_QUICK*`, die zijn al nieuw).
Voorbeelden: Midnight Falls Heroic 1 soak i.p.v. 2 (sinds 16 jun); Chimaerus Caustic Phlegm 12 vs 20 s.
- Herschrijf alleen wat aantoonbaar fout is (bron in de JSON); "onzeker" wordt een TESTLIJST-vraag, geen tekst.
- Dit is schrijfwerk, geen uitzoekwerk: de normale denkstand volstaat (geen xhigh nodig).
- Zelfde route: beoordelingspagina → Robs ja → 7 talen → controles → commit.

## C. De lijst "hele addon nalopen" (voor 3 okt)

Rob wil het hele addon nog een keer laten nalopen. Maak één lijst van alle onderdelen met feiten die verouderd of
fout kunnen zijn, in volgorde van belang voor de speler, met per onderdeel een schatting (aantal helpers, Fable of
Opus, % sessie; meetbasis: 1 raidbaas op Opus-xhigh ≈ 1,65% sessie; per dungeon op Fable ≈ 3% Fable-week).
Denk aan: delves (14), de 8 overige dungeons, Codex, gidsen, beroepencursus, 40 speelkaarten, Great Vault-advies,
achievements, Valeera, valuta/crests (20 okt crest cap!), 12.1.5-checklist. Zet hem als `docs/NALOOP_LIJST.md`
en laat Rob kiezen.

**Volgorde vandaag:** A1 (meting) → A2 en B tegelijk → C terwijl de helpers draaien.
