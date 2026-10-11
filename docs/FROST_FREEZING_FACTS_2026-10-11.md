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
- Frostfire: **12** (Wowhead 29 aug, Method-lijsten) tegen **10** (Method-tekst, Icy Veins AOE/FAQ). De kaart
  (`PLAYCARD_64_HERO2`) zegt 12; NIET aangepast.

## Gevolg op de kaart (11 okt)
- Nieuw: `PLAYCARD_64_TERMS` ("Goed om te weten:") onder het idee; verborgen samen met de waarom-regels.
- W3 zei "slaat al het Freezing kapot" → **fout**, nu "breekt 4 tegelijk (meer met talenten)". W2 "3", W4 "8" en "max 20".
