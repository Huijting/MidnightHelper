# Frost Mage — wat is Freezing? (11 okt 2026)

Aanleiding: Rob testte de waarom-regels + quiz en vroeg *"wat is freezing eigenlijk?!"*. De kaart gebruikte het woord
overal en legde het nergens uit. Twee mh-research-agenten, los van elkaar: (A) gidsen + Wowhead-tooltips,
(B) Blizzards DB2 op wago.tools, builds **12.1.0.69933** (live) en **12.1.5.70077** (PTR). Ze zijn het eens.

## GEMETEN (beide agenten, DB2 + tooltip)
- Debuff **1221389 "Freezing"** op de vijand: max **20** stapels, **15 s**. Aura-tekst: "Frozen by … Can be Shattered by
  Ice Lance for bonus damage."
- Regels in passief **1246769 "Shatter"**: Frostbolt en Flurry leggen Freezing; Ice Lance "consum[es] 4 stacks" en doet
  schade per stapel (schadespell 1246949).
- Stapels: Frostbolt / Frostfire Bolt **1** · Flurry **1 per missile = 3** · Ray of Frost **8** (4 s / 0,5 s ticks) ·
  Glacial Spike **3** (+2 Glacial Chill; met Glacial Shatter breekt hij er 5 i.p.v. leggen) · Cone of Frost 3 op max 5
  vijanden · Frostbite +1 bij crit.
- **Ice Lance breekt er 4**, niet allemaal. Heart of Ice +1, Polished Focus +1 (Spellslinger), Thermal Void +4 na
  Brain Freeze. Comet Storm: elke komeet breekt 1.
- **Fingers of Frost:** volgende Ice Lance doet schade als 4 stapels en verbruikt er geen. Max 2 charges.
- Frozen Orb en Blizzard: hun tekst zegt niets over Freezing (bewijst niet dat ze het nooit doen).
- **12.1.5 verandert Freezing niet** (DB2 gelijk in beide builds; EU-draad 627464 alleen bugfixes).

## Gidsadvies, geen spelregel
- Spellslinger: Ice Lance vanaf **6** stapels — alle drie de gidsen eens (AFGELEID: 4 + Heart of Ice + Polished Focus).
- Frostfire: **12**, bij één vijand én AOE — BESLIST 11 okt (Rob vroeg het; 2 agenten eens). GEMETEN in
  SimulationCraft `midnight` (`ActionPriorityLists/default/mage_frost.simc`): `ice_lance,if=debuff.freezing.stack>=12`,
  sinds commit 3380f60 (11 aug 2026, "Frost 12.1 APL"), daarvoor `>=10` in `ff_st` én `ff_aoe` (12.0.7). Ongewijzigd
  t/m HEAD af05b9e (10 okt); 12.1.5-commits raken de APL niet. Wowhead 29 aug en beide Method-lijsten: 12.
  De "10" in Icy Veins (AOE-lijst, FAQ) en Method's speelstijltekst = restant van 12.0.7 (AFGELEID uit datums + diff).
  De kaart (`PLAYCARD_64_HERO2`) zegt al 12: niets aangepast.
- Ook uit de APL (niet op de kaart): Frostfire houdt één Fingers of Frost vast tenzij Thermal Void actief is; bij 2
  charges altijd Ice Lance. Spellslinger geeft elke Fingers of Frost meteen uit.

## Gevolg op de kaart (11 okt)
- Nieuw: `PLAYCARD_64_TERMS` ("Goed om te weten:") onder het idee; verborgen samen met de waarom-regels.
- W3 zei "slaat al het Freezing kapot" → **fout**, nu "breekt 4 tegelijk (meer met talenten)". W2 "3", W4 "8" en "max 20".
