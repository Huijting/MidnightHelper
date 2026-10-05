# Vast toetsenblok — plan (4 okt 2026, Rob + Claude, brainstorm)

Robs idee (4 okt): één vast, strak blok knoppen. Elke plek heeft voor elke klasse en rol altijd dezelfde taak en
toets, zodat je spiergeheugen op elk personage werkt. Moet werken op de Blizzard-balken én op EllesmereUI.
**Nog niets gebouwd.** Dit bestand is de stand van de keuzes.

## Besloten (Rob, 4 okt)

- **3 balken = 36 plekken**, elk 3 rijen × 4 knoppen, naast elkaar. Vaste grootte; lege plekken mogen.
  (Variant C uit de proefvulling; Rob: "ik volg jouw advies".)
- **Hoofdknop op 1.**
- **Muis: MH zet er standaard NIETS op.** We gaan niet uit van een muis met extra knoppen. Robs 6 zijknoppen zijn
  van hem. Wie meer ruimte wil, zet zelf een balk bij.
- **Robs vaste toetsen** (mag later nog schuiven): T = healing potion, F4 = Recuperate, F2 = snelle heal,
  Q = een vaste taak (eerst gedacht: grote damage-cooldown; "samen bekijken").
- **MH doet allebei:** een plaatje van jouw blok + een knop "zet het voor me neer" (met proefrit en terugzetten,
  zoals `/mh apply`). Per toets snel zelf aanpassen blijft.
- **Hulpspreuken** (mount, hearthstone, buffs e.d.) horen niet in het blok; de speler zet ze zelf ergens neer.

## Het blok (eerste schets; balk 4 nog in te vullen)

| | balk A (3×4) | balk B (3×4) | balk C (3×4, extra) |
|---|---|---|---|
| rij 1 | 1 hoofdknop · 2 · 3 rotatie · 4 spender | 5 rotatie · Q vaste taak · E kick · R beweging | trinket · druid-vorm 1-3 (andere klassen: overloop) |
| rij 2 | Shift-1/2 AoE · **Shift-3 cooldown 3** · F1 cooldown 2 | F taunt/hulp · T potion · F2 snelle heal · F4 Recuperate | overloop |
| rij 3 | Z klein def · X def 2 · C groot def · **V CC/dispel** | Shift-Q/Shift-F CC/dispel · Shift-R beweging 2 · Shift-T healthstone | overloop |

Toetsen van balk C: nog niet gekozen. **Voorstel 4 okt middag** (plaatje: https://claude.ai/artifact/TPZsR3V5EWmKuqA4LFq78U):
rij 1 `G` trinket · `Ctrl-1/2/3` druid-vormen (anders rotatie-overloop); rij 2 `F3` cooldown 4 · `Shift-E` racial ·
`Shift-4` AoE-spender · `Shift-F1` cooldown 2-tweede; rij 3 `Shift-Z/X/C/V` tweede van dezelfde soort.
GEMETEN: `Shift+4` vragen 22 `bindKey`s nu al, `Shift+F1`/`Shift+C`/`Shift+V` elk 2 (Warrior, DH); `F3` en `Shift-E`
gebruikt het toetsschema al (`KeybindSchema.lua:134`, `:189-195`). ⚠️ Botsing: druid-vormen staan nu op `Shift+T/R/X`
(`KeybindRoles_Druid.lua:246-248`); ⇧T en ⇧R zijn in balk B bezet → vormen naar Ctrl-1-3. Alternatieven op de pagina:
losse letters (G B H N F5 6 7) of een hele Ctrl-laag. ✅ **BESLOTEN 4 okt** (Rob: "Wat betreft blok C ga ik helemaal
op jouw expertise af") → optie 1, het voorstel hierboven.

## Wat de metingen zeggen (GEMETEN, proefvulling uit MH's KeybindRoles-data, 4 okt)

Scratchpad van sessie fcdcd4fe: `keyblock\research.md` (onderzoek), `sim.md`/`sim.json` (met muis), `sim2.md`/`sim2.json`
(zonder muis). Overzichtspagina (met muis, eerste run): https://claude.ai/artifact/YUyNo74kU8Q6GAXexv4mr6

- Alleen 24 plekken: voor **0 van 40** specs genoeg.
- 3 balken met V = CC/dispel en Shift-3 = cooldown 3: alles behalve utility past bij **39 van 40** (40 zonder de
  bekende keuzeknoop-dubbels). Prot Paladin mist alleen Intercession. ±20 utility-spells over alle specs plaats je zelf.
- Gemiddeld 27,4 spells per spec in de data, hoogstens 36 (Marksmanship Hunter).
- Beperkingen: talentkeuzes tellen dubbel (data, geen spellbook); racials niet meegeteld.

## Techniek (GEMETEN in de code, niet in het spel getest)

- EllesmereUI balk 1-8 = dezelfde Blizzard-slots en binding-commando's. `PlaceAction` + `SetBinding` van MH komen dus
  ook op EllesmereUI aan. Max 12 knoppen per balk, rijen vrij.
- Blok op balk 2-8 (balk 1 pagineert bij vormen/stealth). Niet EUI-balk 9/10 (botst met page 2 en Moonkin).
- `/mh apply` zet al spells én toetsen (balk 1-6, undo). Maar de taak zit nu in de **toets**, niet in de **plek**:
  de indeling moet opnieuw. De checks "balk staat uit/te kort" kijken naar Blizzard-knoppen die EUI verbergt.
- Balken op 3 rijen zetten (mh-research 4 okt, `keyblock\rows.md`):
  - **Blizzard: MH kan het zelf.** Edit Mode kent rijen 1-4 en iconen 6-12, dus 3 rijen × 12 iconen = 4 per rij
    (GEMETEN in Blizzards 12.1-code). Schrijven via `C_EditMode.SaveLayouts`: niet protected, wel niet in combat,
    niet op een preset-layout, en daarna `/reload`. MH heeft hier al `EditModeBackup.lua` voor (import met backup +
    `/mh editmode restore`).
  - **EllesmereUI: de speler doet het zelf**, met uitleg: `/eab` → balk → Icons 12, Rows 3 → "Apply to all Bars",
    plaatsen met `/unlock`. EUI heeft geen API; MH schrijft niet in EUI's gegevens (hun code verandert nu snel).
  - ⚠️ **Mogelijk probleem in de bestaande import (AFGELEID, niet getest):** EUI, OakUI en LibEditModeOverride zetten
    Blizzards preset-layouts vooraan in de lijst voordat ze `SaveLayouts` aanroepen; MH's import/restore doet dat niet
    (`EditModeBackup.lua:493`, `:552`). Eerst één keer in het spel testen, vóór we hierop bouwen.

## Besloten 4 okt middag (Rob, via telefoon: "Je mag gaan bouwen")

- **Q = de grote cooldown** ("zoiets als Ascendance voor een Shaman", per klasse een andere). Data-veld `blockQ` op de
  KeybindRoles-entry (`true` of `{ [specID] = true }`); zonder tag valt Q op de eerste `cooldown_bar`. Lijst per spec:
  mh-research `2138325d…\scratchpad\bigcd.json`.
- **Balknummers: ik koos 5, 6, 7** (A, B, C). Balk 1 wisselt met vormen/stealth, 2-4 houden de meeste spelers hun eigen
  spells, 8 = Robs muistoetsen. Instelbaar via `ns.db.keyBlock.bars` (nog geen knop).
- Edit Mode-proef: vanavond (TESTLIJST "4 okt middag").

## Gebouwd 4 okt middag: het plaatje (stap 1)

`Modules/KeyBlock.lua`, `/mh block` (venster) en `/mh block why` (chat + `ns.db.keyBlockProbe`). Leest de spreuklijst
uit `ns.MH_AutoMapBuild` (8e/9e return: `spells`, `specID`, vóór toewijzing) en verdeelt die met de regels van
sim2-variant C + balk C. Druid-vormen via `blockForm = 1/2/3` (Bear/Cat/Moonkin, KeybindRoles_Druid). **Zet niets
neer.** GEMETEN buiten het spel (scratch `kb_test.lua`, echte data, 40 specs): bij 32 past alles; de 25 die niet passen
zijn vooral utility (Mark of the Wild, Revive, Prowl, Flare, Misdirection; Prot Warrior 3, MM/SV Hunter 4-5, Guardian 5).
⚠️ Bekend: overloop vult óók plekken met een eigen taak (Shift-E racial, Shift-4) als die op dit personage leeg zijn.

## Stap 2a gebouwd 5 okt (Rob: "A1 B1 C1") — NIET in het spel getest

A1 overloop blijft vrije plekken van balk C vullen; B1 balk 5/6/7 mag overschreven worden met proefrit + undo; C1 MH zet
trinket (slot 13), healing potion (eerste uit de consumables-data in je tas) en Healthstone (5512, als in tas) erop.
`ns.KeyBlockPreview/Place/Undo` in KeyBlock.lua, knoppen in het venster + `/mh block place|go|undo`. Regels van
ApplyLayout overgenomen: alleen spell/item overschrijven (macro/flyout/mount = "left alone"), elke plaatsing teruggelezen,
snapshot per slot en per toets in `ns.db.keyBlockSnapshot`, één keer neerzetten tot undo. Toetsen zonder iets eronder
worden NIET gekoppeld (Shift 2 houdt zijn oude functie). Waarschuwt als balk 5/6/7 verborgen is.

## Stap 2b (volgende): balken zelf neerzetten via Edit Mode

3 rijen × 4 per balk, A-B-C naast elkaar; pet bar, stance bar, possess/extra action button/zone ability een vaste
plek eromheen (Rob 5 okt: "ook de game extra balken in ogenschouw nemen"). Eerst een plaatje voor Rob. Edit Mode-proef
(export → import → reload) is 5 okt geslaagd. ⚠️ Pet bar heeft standaard Ctrl 1-10; het blok neemt Ctrl 1-3 over.

## Open

1. ✅ Toetsen van balk C (4 okt, optie 1). 2. ✅ Taak van Q (grote cooldown; data volgt). 3. ✅ uitgezocht (zie Techniek): Blizzard zelf, EllesmereUI uitleg.
   Wel eerst de import-test. 4. Welke balken (nummers) standaard.
5. Bouwvolgorde: eerst het plaatje, dan "zet neer".
