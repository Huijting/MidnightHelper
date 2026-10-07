# Feiten 7: Holy Paladin, welke heal op één persoon (7 okt 2026)

Vraag: herlezing 6, punt N10/N11 (kaart 65 en toolkit vertellen twee verhalen over Flash of Light en Holy Light).
Alleen gelezen, niets aan de addon veranderd.

**Bronnen**
- wago.tools DB2, build **12.1.0.69933** (live, aangemaakt 22 sep 2026): tabellen SpellName, Spell, SpellMisc,
  SpellCastTimes, SpellPower, SpellEffect, SpellClassOptions, SpecializationSpells, SpellActivationOverlay.
- Wowhead rotatiegids Holy Paladin (HolyClarius), **bijgewerkt 20 sep 2026**.
- Method rotatiegids (Joki), **bijgewerkt 27 aug 2026**.
- Icy Veins rotatiegids (Mytholxgy), **bijgewerkt 10 aug 2026**, één dag vóór 12.1 live. Zelfde lijn als de andere twee.
- Blizzard EU-forum, draadje "Infusion of Light & Divine Purpose - Spells Don't Glow On My Action Bar", **22 mrt 2026** (12.0).

## 1. Holy Light en Flash of Light

| | Flash of Light (19750) | Holy Light (82326) |
|---|---|---|
| Cast-tijd | **1,5 s** (GEMETEN, CastTimes 16) | **2,0 s** (GEMETEN, CastTimes 5; Wowhead zegt ook "2 sec cast") |
| Mana voor Holy | **0,6 % base mana** (GEMETEN, SpellPower-rij voor de Holy-aura 137029) | **7 % base mana** (GEMETEN, ook Wowhead) |
| Tooltip | *"Quickly heal a friendly target"* | *"A powerful but expensive spell"* (GEMETEN, Spell-tekst) |
| Holy Power | +1 via Tower of Radiance (231642, alleen Holy) | +1, zelfde talent (GEMETEN) |
| Van wie | alle paladins | alleen Holy (SpecializationSpells spec 65, GEMETEN) |

- Grootte (AFGELEID uit DB2): Holy Light heelt per cast ongeveer **7 keer** zoveel als Flash of Light
  (coëfficiënt 32,5 tegen 3,156; de Holy-aura geeft Flash of Light +50 %). Hij kost ongeveer 12 keer zoveel mana.
  Talenten en gear veranderen dit. Niet in het spel gemeten.
- Hoe spelers ze gebruiken (KANDIDAAT, drie gidsen zeggen hetzelfde):
  - **Flash of Light zonder proc** is de vuller: *"wanneer niets anders klaar is"* (Icy Veins, Wowhead zet hem onderaan).
  - **Flash of Light mét Infusion of Light** is een van de sterkste knoppen. Eerst opmaken, pas dan weer Holy Shock (Wowhead).
  - **Holy Light** is de grote, dure heal: *"als er veel healing nodig is en je mana het toelaat"* (Icy Veins, Wowhead).
    Method: alleen als je echt moet healen en geen Holy Power en geen Infusion hebt.
  - Tier-set Seizoen 2, 4 delen (1296657, GEMETEN): Holy Light geeft **altijd** Infusion of Light, maar kost **+50 %** mana.
    Judgment geeft 20 % kans. (Eén gids, expcarry, zegt 60 %: dat klopt niet met DB2.)
    Wowhead: met 4 delen is Holy Light je reserveknop als je niets meer klaar hebt maar wel veel moet healen.
- Hand of Divinity (1242008, GEMETEN): na Avenging Wrath is je volgende Holy Light direct en goedkoper.

## 2. Wat licht er op: Infusion of Light

- Talent **53576**, buff **54149** (GEMETEN, beide heten "Infusion of Light", talent zit in TraitDefinition 107555).
- Trigger: **Holy Shock**, basiskans **10 %** (GEMETEN, effectwaarde 10; Icy Veins zegt ook 10 %).
- Wat de buff doet (GEMETEN, buff-tekst en effecten):
  - **Flash of Light**: direct (cast-tijd -100 %) en **+200 %** healing (basiswaarde; tier 2 delen: nog +100 %).
  - **Judgment**: sterkere Greater Judgment en +1 Holy Power.
  - **Niet** Holy Light: de buff raakt alleen het klasse-masker van Flash of Light (GEMETEN, masker 1073741824
    = Flash of Light, Holy Light heeft een ander masker).
  - "Goedkoper" staat er **niet** in de tooltip. Er zit een los effect van -30 in de buff dat nergens in de tekst staat;
    wat het doet is niet vastgesteld.
- **Hoe zie je hem?** DB2 heeft voor 54149 een schermgloed (SpellActivationOverlay, ScreenLocation 3), maar het
  knop-masker is **0** (GEMETEN). Positieve controle: Hot Streak (48108) en Blade of Wrath (281178) hebben wél een
  knop-masker, en die knoppen lichten op. Het forum (22 mrt 2026) klaagt precies hierover: Flash of Light en Judgment
  lichten **niet** op op de balk. Conclusie (AFGELEID, sterk): je ziet een plaatje op je scherm bij je personage,
  niet een oplichtende knop. Niet in het spel gezien: Rob kan het testen (Holy Shock tot de proc, kijk naar de knop).

## 3. Eén beginnersregel voor heals op één persoon (KANDIDAAT-tekst, Rob kiest)

1. Iemand geraakt: **Holy Shock**. Direct (GEMETEN), geeft Holy Power, soms Infusion of Light.
2. Infusion of Light (gloed op je scherm): **Flash of Light** op wie geraakt is. Dan direct en veel sterker.
   Eerst opmaken, dan pas weer Holy Shock.
3. 3 Holy Power of meer: **Word of Glory / Eternal Flame** op wie het laagst staat. Op 5: meteen. Ook direct (GEMETEN).
4. Niets klaar en iemand zakt nog: **Flash of Light** (1,5 s, goedkoop).
   **Holy Light** (2 s, duur, heel groot) alleen als iemand veel mist en je mana genoeg is.

## Wat MH nu zegt

| Plek | Zegt | Klopt? |
|---|---|---|
| `nlNL.lua:1200` `PLAYCARD_65_S2` (enUS:1250) | *"Zodra Flash of Light oplicht op je balk ... Dan is hij direct en heel sterk. Daarna Holy Shock"* | "Direct en heel sterk" **klopt** (GEMETEN). "Daarna Holy Shock" **klopt** (Wowhead). **"Oplicht op je balk" klopt waarschijnlijk niet**: de knop licht niet op, er komt een plaatje op je scherm (zie punt 2, AFGELEID). |
| `nlNL.lua:1198` `PLAYCARD_65_EASY` (enUS:1248) | Holy Shock, dan Holy Power naar Word of Glory/Eternal Flame, dan Judgment/Shield of the Righteous | Klopt. Mist stap 4: wat doe je als niets klaar is en iemand zakt. Flash of Light en Holy Light staan er niet in. |
| `HealerCooldowns.lua:162` Holy Shock `fast` | via `HEALCORE_DESC_FAST` | Klopt: direct (GEMETEN). |
| `HealerCooldowns.lua:163` Flash of Light `fast` + `nlNL.lua:3666` `HEALCORE_DESC_FAST` (enUS:4162) | *"Snelle heal op één persoon — je reactieknop als iemands health snel zakt."* | **Half.** Zonder proc 1,5 s cast en volgens de gidsen de laagste heal-prioriteit. Je echte reactieknoppen zijn Holy Shock en Word of Glory (beide direct). Met proc klopt het wel. ⚠️ Deze tekst is gedeeld door alle specs met tag `fast`, dus wie hem verandert, verandert hem ook bij andere healers. |
| `HealerCooldowns.lua:164` Holy Light `big` + `nlNL.lua:3667` `HEALCORE_DESC_BIG` (enUS:4163) | *"Grotere, tragere heal — heelt veel, maar kost tijd om te casten. Of hij zuinig is, verschilt per spec."* | **Klopt.** Voor Holy is het antwoord op "zuinig?": nee, duur (7 %, tooltip "expensive"; met tier 4 delen nog duurder). Ook een gedeelde tekst. |
| `HealerCooldowns.lua:165` Word of Glory `fast` | via `HEALCORE_DESC_FAST` | Klopt: direct (GEMETEN). |
| `KeybindRoles_Paladin.lua:115-116` (code-commentaar) | Flash of Light *"instant bij Infusion of Light"*, Holy Light *"grote (dure) ST-filler-heal"* | Klopt. |

Positieve controle van het zoeken: `{SPELL:19750}` vond `PLAYCARD_65_S2` in `nlNL.lua`; dezelfde zoekvorm gaf 0 treffers
voor `{SPELL:82326}`, `{SPELL:54149}` en "Infusion of Light". MH noemt Holy Light en Infusion of Light dus nergens
in een spelerstekst in `nlNL.lua`. Holy Light staat alleen in de toolkitlijst (`HealerCooldowns.lua:164`).

## Niet gemeten
- Of de Flash of Light-knop in het spel tóch oplicht (DB2 en het forum zeggen nee; Rob kan het zien).
- Echte heal-getallen en mana met Robs gear en talenten.
- Wat het effect van -30 in de Infusion-buff doet.
