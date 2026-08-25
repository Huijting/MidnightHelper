# Spec 29 — De catalyst behoudt nu je stats

**Van:** ONDERZOEK-sessie, 20 aug 2026
**Voor:** BOUW-sessie
**Raakt:** `Modules/TierSet.lua` (zegt hier nu niets over) en de Codex
**Aanleiding:** een claim uit een YouTube-gids, getoetst en **bevestigd**

---

## 1. Het feit, met twee primaire bronnen

**Blizzard, PTR Development Notes, 18 juni 2026** — letterlijk:

> *"Class set armor now inherits the secondary and tertiary stats as well as certain special
> cantrip effects of items converted with the Catalyst."*

**De client zelf**, tooltip van de currency **Venomblight Manaflux** (currency **3465**,
toegevoegd in 12.1.0 op 11 aug 2026):

> *"Charge the Catalyst with Venomblight Manaflux to imbue armor with incredible power. The
> resulting armor will inherit the secondary stats of the original equipment."*

Twee onafhankelijke bronnen, waarvan één de tekst die het spel op het scherm zet. Geen fansite
nodig.

**Sinds wanneer:** patch **12.1.0**, live 11 aug 2026. Dit is de **eerste** gedocumenteerde
wijziging in dit gedrag ooit — niet in Dragonflight, niet in TWW, niet in 12.0.

**Wat het daarvoor deed, met positief bewijs:** Methods tier-set-gids voor Season 1 (26 feb 2026)
lijst per klasse de tier-stukken met **vaste stats per slot** — élk Head-stuk Haste/Mastery,
ongeacht klasse. Tier-items hádden dus voorgeschreven secondaries, en conversie overschreef wat
er op je bronitem stond.

---

## 2. 🔴 Waarom dit meer is dan een weetje

**Het draait het advies om, in twee richtingen tegelijk.**

Vroeger was de catalyst een **gratis herroll**: welk item je erin stopte maakte niet uit, want de
uitkomst had toch vaste stats. Een stuk met waardeloze secondaries omzetten was juist slim.

Nu erft het tier-stuk je secondaries — **ook de slechte**. Een stuk met verkeerde stats is na
conversie **permanent** verkeerd. De keuze welk item je erin stopt is dus van "onbelangrijk" naar
"een van de weinige onomkeerbare keuzes in je gearing" gegaan.

Dat is precies het soort omkering waar spelers op oude gewoonte doorgaan zonder te merken dat de
regels veranderd zijn. En het is precies MH's lijn: geen tracker, maar uitleggen wat een keuze
betekent.

⚠️ **Eén nuance die de video wegliet en die wél in de tekst moet.** Blizzard schrijft *"certain
special cantrip effects"* — met een slag om de arm. Voor secondaries en tertiaries is de
formulering onvoorwaardelijk, voor speciale effecten niet. Schrijf dus niet "alle effecten gaan
mee".

---

## 3. Wat MH zou moeten zeggen

Kern, in één regel:

> **Sinds 12.1 houdt het tier-stuk de secundaire stats van het item dat je erin stopt — ook de
> slechte. Kies dus bewust wélk stuk je omzet.**

Aanvullend, als er ruimte is:
- Vroeger maakte het niet uit; dat is veranderd, en oude gewoonte kost je nu stats.
- Tertiaire stats (leech, speed, avoidance) gaan ook mee.
- Sommige speciale effecten gaan mee — bijvoorbeeld de **Venomcursed**-stukken uit The Venomous
  Abyss. Blizzard zegt "certain", dus geen belofte dat het altijd zo is.

**Waar:** het meest voor de hand liggend in `TierSet.lua`, op het moment dat MH iets over de
catalyst zegt. Een Codex-regel erbij is logisch omdat dit uitleg is, geen tracking.

---

## 4. De rest van wat er gecontroleerd is

**De naam klopte net niet.** Het is **Venomblight Manaflux** (één woord), niet "Venom Blight
Manaflux". Currency **3465**, cap 8, +1 per twee weken, plus drops uit M+, de S2-raidbosses
(Tidebound Grotto en Venomous Abyss), Bountiful Delves en Rated PvP.

**Twee achievements, beide bestaan, drempels kloppen:**

| Achievement | ID | Criteria | Beloning |
|---|---|---|---|
| Midnight Season 2: Catalyst Unbound | **62871** | class set bonuses ontgrendeld in S2 | Manaflux kan uit extra bronnen droppen |
| Midnight Season 2: Serpent Scion | **62872** | **2000+** M+ rating, **1600+** Rated PvP, óf Ula'tek op **Heroic of Mythic** | Crystallized Venomblight Manaflux (item 274707) |

📌 Twee correcties op de video: het is Heroic **of** Mythic (de video noemde alleen heroic), en
`Catalyst Unbound` hangt in de achievementtekst aan "class set bonuses" terwijl secundaire
bronnen consequent "4-piece" zeggen. Klein verschil, niet uit de officiële tekst te bewijzen —
neem de achievementtekst over, niet de gidsen.

---

## 5. ⛔ Niet encoderen

1. **"Alle speciale effecten gaan mee."** Blizzard zegt *certain*. Schrijf wat Blizzard schrijft.
2. **Dat gem sockets meegaan.** Eén bron (Method), niet in de blue post, niet in de tooltip.
3. **Wat de Venomcursed-cantrip mechanisch doet.** Niet vastgesteld.
4. **Of `Crystallized Venomblight Manaflux` één charge of drie fragmenten geeft.** Icy Veins zegt
   één; de andere bewering kwam van een verboden bron. Ga uit van één, of laat het weg.

---

## 6. De meting die de rest beslecht

Eén handeling dekt punt 1 én 2 uit §5:

> Zet een stuk met **bekende secondaries én een tertiary** (leech, speed of avoidance) door de
> catalyst in Silvermoon, en vergelijk het resultaat met het origineel. Zit er een socket op, dan
> weet je die vraag meteen ook.

Voor de cantrip is een **Venomcursed**-stuk uit The Venomous Abyss nodig.

⚠️ Dit is een **onomkeerbare** handeling op een echt item, en charges zijn gecapt op 8 met
+1 per twee weken. Doe dit dus op een stuk dat je toch wilde omzetten — niet als experiment.

---

## 7. Waarom dit hoger op de lijst hoort dan het lijkt

De claim kwam uit een YouTube-gids, en het eerste wat we deden was hem als **kandidaat**
wegschrijven in `docs/RESEARCH_S2_GEARING_VIDEO.md` in plaats van hem over te nemen. Twee uur
later staat er een blue post en een client-tooltip onder.

Dat is de goede volgorde, en hij loont hier dubbel: **de video had gelijk over het feit en
ongelijk over de details** — de naam van de currency, "any special effects" in plaats van
"certain", en heroic in plaats van heroic-of-mythic. Precies de drie dingen die zonder toets in
de addon waren beland.
