# Wat moet er in de volgende upload — geprioriteerd

**Opgesteld 6 aug 2026.** Uitgebracht: **2.12.0**. Op `main` staan zes commits die
er nog niet in zitten (commandolijst, scroll-fix, docs).

**De klok: 12.1 gaat live op 11 aug (NA) / 12 aug (EU) — vijf dagen.** Season 2
volgt 18 aug. Dat verdeelt deze lijst: alles wat op patchdag fout kan gaan, moet
er vóór 11 aug in. De rest niet.

---

## P0 — vóór 11 augustus, anders gaat het op patchdag mis

**1. ✅ AFGEVINKT 6 aug — de dispel-helper overleeft 12.1.**
Gemeten op de PTR (Maisara Caverns, follower dungeon, Prot Paladin), 38 scans:

```
                tries  hits  misses  errors  absent
player_harmful    38     15     23       0       0
party1..4         38      0     38       0       0
target_helpful    38      0     24       0       0
```

**Nul errors, nul absent** — het filter bestaat nog en antwoordt op een
12.1-client. En het onderscheidt: 15 van de 38 keer vond het iets afneembaars op
de speler zelf. De nul bij de volgers is `noUnit=0`, dus ze waren er wel en droegen
gewoon niets afneembaars in dat halve stukje dungeon.

Restpunt, klein: `dispelFieldLog` bleef leeg, dus over de leesbaarheid van
`spellId`/`name`/`dispelName`/`canActivePlayerDispel` op 12.1 hebben we nog niets.
Voor de helper maakt dat niet uit — die vraagt het filter, niet de velden.

<details><summary>De oorspronkelijke opdracht</summary>

**1. Meet de dispel-helper op de PTR.**
`ns.AllyHasRemovableAura` leunt op `GetAuraSlots(unit, "HARMFUL|DISPELLABLE", 1)`,
en dat is **alleen op live 12.0.7 gemeten** (36 scans, party1 0 hits vs party3 36 —
het onderscheidt echt). De API-wachter citeert de 12.1-notities: *"All of the
UnitAura APIs will now either return full secrets or nil when called by addons."*
Valt het filter om, dan verschijnt het dispel-icoon nooit meer — en dat faalt
**stil**, wat de ergste vorm is: een groepslid dat een dispel nodig heeft en geen
icoon. `copy_to_ptr.bat`, één dungeon, klaar.
</details>

**2. Meet de secure klik-knoppen op de PTR.**
Klikken-om-over-te-nemen is uitgeleverd en werkt op live. 12.1 brengt nieuwe
taint-machinerie (Forbidden Aspects, Private Script Objects, `securecopy`,
`CreateSecureDelegate`). Op 3 aug kostte één taint-fout al het hele targetten
(`786cae1`). Dit is nu een aangekondigde functie, dus stukgaan is zichtbaar.

**3. Beslis wat er met `/mh kicks who` gebeurt.**
Gemeten onmogelijk: Midnight weigert combat-log-registratie aan élke addon, DBM
incluis (`DBM-Core.lua:1680`). Het commando staat er nog, staat standaard uit en
zwijgt. Keuze: weghalen, of laten staan met een eerlijke melding als iemand hem
aanzet. Nu zegt hij "AAN" en doet daarna niets — dat is de Alt+M-fout in een
andere jas.

---

## P1 — hoort in de volgende upload, geen patchdag-risico

**4. De commandolijst uitleveren** (staat op `main`, Rob test hem nu). Daarna kan
de zin die vandaag uit de CurseForge-pagina is gehaald terug: *"de volledige lijst
vind je in de addon onder Tools"*.

**5. De actie-hint aankondigen.** De interrupt-helft is nu **wél** bevestigd — Rob
zag hem oplichten in Windrunner Spire — en er staat sinds vanavond het woord
ONDERBREKEN bij. Dat is de eerste functie uit de "gebouwd maar nooit gezien"-bak
die eruit mag. De purge-helft blijft ongenoemd tot iemand hem ziet.

**6. Het dispel-icoon naast een groepslid.** Ongetest, dus nog steeds niet
aankondigen — maar zie P0-1: als de PTR-meting goed uitvalt én iemand het icoon in
een dungeon ziet, mag het mee.

---

## P2 — na 12.1, vóór of rond Season 2 (18 aug)

**7. De death recap vervangen.** Die kan sinds 12.0 geen doodsoorzaak vaststellen,
want hij vult zijn damage-ring uit dezelfde geweigerde registratie. Blizzards eigen
Death Recap werkt wél en we openen die in restricted content al. Ontwerpkeuze van
Rob: het bestaande venster laten verwijzen, of de belofte inperken.

**8. Consumables-data opnieuw genereren voor S2.** `ConsumablesWowheadMeta` staat
op *"Midnight Season 1", generatedAt 2026-07-08*. Klopt vandaag, is op 18 aug fout.

**9. Wereldbazen degraderen in de weekplanner.** De wachter meldde 5 aug: world
bosses en de one-time epic-gearquest zijn **niet** ge-updatet voor S2 en blijven
S1-gear. Vanaf 18 aug stuurt de planner mensen dus naar iets dat niet meer loont.

**10. Patchdag-metingen** (11/12 aug, in-game): `/mh crests` om te zien welke
S2-crest-id de primaire is, en de Voidcore-currency-id (3418 vs 3513 — de bronnen
spreken elkaar tegen).

✅ **De Coiled Isle-mapID is al binnen: 2512**, gemeten op de PTR op 6 aug met
`/dump WorldMapFrame:GetMapID()` terwijl de kaart openstond — dat werkt zonder dat
je in de zone hoeft te staan, en de zone gaat pas open na twee campagne-hoofdstukken.
Bewust nog **niet** in `MAP_TO_ZONE_KEY` gezet: die tabel betekent "gedekt", en we
hebben nul rares of treasures voor dat eiland. Zie `RESEARCH_12_1.md`.

---

## Bewust NIET op deze lijst

- **De upgrade-calculator** — voorstel ligt klaar (`PROPOSAL_UPGRADE_CALCULATOR.md`)
  maar hoort ná 18 aug, want de crest-kosten wisselen dan en een rekenmachine die
  ernaast zit wordt geloofd.
- **De tier-adviseur bij de obelisk** (`PROPOSAL_TIER_ADVISOR.md`) — geen deadline.
- **Fase 3 van de party-targets-makeover** (interrupt-gloed per rij) — vereist eerst
  de Fase 0-meting, en die kan pas als iemand er zin in heeft.
- **Een 2.12.1 alleen voor bovenstaande toevoegingen.** Er staat niets kapot dat
  uitgeleverd is. Een extra upload is voor reparaties, niet voor extra's.
