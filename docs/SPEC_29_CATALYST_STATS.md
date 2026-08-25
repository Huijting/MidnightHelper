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

## 6. Wat de client-data zegt — en waarom die het niet beslecht

Een tweede onderzoek ging rechtstreeks naar de DB2-tabellen. Uitkomst, en het is genuanceerder
dan §1 alleen:

**a) De catalyst-UI zwijgt volledig over stats.** Alle `GlobalStrings` rond de catalyst zijn nog
de Shadowlands-9.2-teksten (`SL_SET_CONVERSION_*`, `GENERIC_ITEM_CONVERSION_SLOT_TOOLTIP`). De
diff 12.0.7.68974 → 12.1.0.69465 telt 606 nieuwe tags, en **nul** daarvan raakt de catalyst.

⚠️ Dat is een **gemeten** stilte, geen gereedschapsfout: dezelfde run ving wél echte
12.1-wijzigingen op (`WEEKLY_REWARDS_COMPLETE_WORLD` ging van "Ritual Sites (Tier 5, 6, 7, 12,
or 13…)" naar "Ritual Sites (Tier 1-6)").

**b) De uitvoer-items hebben een VAST secundair paar in hun template.** Voor Robs Prot Paladin,
set *Consecrated Flame* (conversie 13, build 12.1.0.69382): `Bulwark of the Consecrated Flame`
(**271468**) staat op **Mastery + Haste**, `Warhelm` (271465) op Crit + Mastery, enzovoort. De
12.0-sets zijn identiek opgebouwd.

**c) Aan de conversietabellen is niets van betekenis veranderd.** `ItemConversionEntry` heeft
117 rijen voor zowel 12.0 als 12.1 (13 klassen × 9 items) — **geen slot-uitbreiding**. Enige
structuurwijziging: een nieuwe, onleesbare `Flags`-kolom die 12.1 níét van 12.0 onderscheidt.

### Waarom dit §1 niet tegenspreekt

**Tertiairen, sockets en ilvl staan sowieso nooit in het item-template** — die worden bij creatie
via bonus-ID's op het item geplakt. En een bonus-ID van **type 2** kan de template-secondaries
overschrijven; dat mechanisme bestaat al jaren. De conversielogica zit dus **server-side en is in
DB2 principieel onzichtbaar**.

➡️ De blue post en de currency-tooltip blijven het bewijs. De template-stats zijn een
**vertrekpunt**, geen eindstand.

---

## 7. 🔴 De meting — en die is GRATIS, in tegenstelling tot wat ik eerder schreef

**Correctie op een eerdere versie van deze spec**, die zei dat je een charge moest opofferen. Dat
hoeft niet: **de Catalyst-UI toont een preview vóórdat je bevestigt.**

1. Zoek een **borststuk** dat **niet** Mastery + Haste heeft — bijvoorbeeld Crit + Versatility.
   Noteer de secondaries, plus een eventueel tertiair (Leech/Speed/Avoidance) en socket.
2. Leg het in het Catalyst-slot in Silvermoon. **Niet bevestigen.**
3. Hover de preview. Die hoort `Bulwark of the Consecrated Flame` (271468) te zijn.

| Preview toont | Conclusie |
|---|---|
| **Mastery + Haste** | stats zijn voorgeschreven — de gids heeft ongelijk |
| **Crit + Versatility** (jouw invoer) | stats worden overgenomen — §1 bevestigd in de praktijk |

⚠️ **Let apart op het tertiair en de socket.** Die konden in Dragonflight en TWW al meekomen, dus
*"mijn Leech bleef staan"* is **geen** bewijs dat de secondaries meekomen. Dat is precies het
soort halve conclusie waar deze hele dag over ging.

Wil je het achteraf hard vastleggen: vergelijk de bonus-ID-lijsten van in- en uitvoer via
`C_Container.GetContainerItemLink(bag, slot)`. Komt de lijst van het invoeritem grotendeels
terug, dan is dát het mechanisme.

Voor de cantrip is nog steeds een **Venomcursed**-stuk uit The Venomous Abyss nodig.

---

## 7. Waarom dit hoger op de lijst hoort dan het lijkt

De claim kwam uit een YouTube-gids, en het eerste wat we deden was hem als **kandidaat**
wegschrijven in `docs/RESEARCH_S2_GEARING_VIDEO.md` in plaats van hem over te nemen. Twee uur
later staat er een blue post en een client-tooltip onder.

Dat is de goede volgorde, en hij loont hier dubbel: **de video had gelijk over het feit en
ongelijk over de details** — de naam van de currency, "any special effects" in plaats van
"certain", en heroic in plaats van heroic-of-mythic. Precies de drie dingen die zonder toets in
de addon waren beland.
