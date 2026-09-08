# Spec 34 — "the only profession with that" is niet te bewijzen

**Van:** ONDERZOEK-sessie, 8 sep 2026
**Voor:** BOUW-sessie
**Raakt:** `Locales/enUS.lua:1007` (`PROFACAD_CH_INSCRIPTION_BODY`) + de zes vertalingen
**Aanleiding:** Rob nam Inscription op zijn nieuwe level-80 en vroeg wat hij eraan heeft. Bij het
natrekken van ons eigen hoofdstuk bleef één bewering staan die ik niet rond kreeg.

---

## 1. De regel

`Locales/enUS.lua:1007`:

> *"Unique perk: maxing the central Calm Hands node unlocks the weekly Thalassian Treatise —
> **+2 KP every week, the only profession with that.**"*

Twee beweringen in één zin. **De eerste klopt. De tweede kan ik niet staven.**

---

## 2. ✅ Wat WEL bevestigd is — door drie onafhankelijke bronnen

| Bron | Zegt |
|---|---|
| [wow-professions](https://www.wow-professions.com/midnight/inscription-specialization-guide-and-builds) | Calm Hands leert het Treatise-recept en *"adds a bonus Knowledge Point from your weekly Treatise"*; de root maxt op **10 punten** |
| Method (via zoekresultaat, 8 sep) | elk beroep krijgt 1 KP uit zijn wekelijkse Treatise; Inscription's Calm Hands maakt er **2** van |
| `docs/SPEC_28_ROUTE_CORRECTIONS.md` §`[773]` | GEMETEN: *"`Calm Hands` heeft max-rank 10, niet 30 zoals de gidsen schrijven … op 10 geeft je Treatise een extra kennispunt per week"* |

📌 De schijnbare spanning tussen "**+2** KP" (onze tekst) en "**een extra** kennispunt" (Spec 28)
is er geen: de Treatise geeft normaal 1, met Calm Hands op 10 wordt dat 2. Beide zeggen hetzelfde.

**De kern van het hoofdstuk is dus juist**, en het is een sterk argument om Calm Hands eerst te
nemen. Daar hoeft niets aan.

---

## 3. 🔴 Wat NIET bevestigd is

**Dat Inscription hierin uniek is.** Geen van de geraadpleegde bronnen zegt dat, en één zegt
expliciet niets over exclusiviteit. Een zoekresultaat noemt het *"a special bonus for
Inscription"* — suggestief, maar dat is een samenvattende formulering en geen bronuitspraak.

⚠️ **Een exclusiviteitsclaim is de duurste soort bewering die er is**: hij vereist dat je alle
tien de andere spec-bomen hebt nagelopen en er niets gelijkwaardigs in hebt gevonden. Dat is
niemand van ons ooit gaan doen — de zin komt uit een gids-parafrase. Zie
[[never-assume-always-factcheck]].

📌 **En deze zin staat in zeven talen uitgeleverd** (`deDE`, `enUS`, `esES`, `frFR`, `itIT`,
`nlNL`, `ptBR`). Elke gebruiker leest hem.

---

## 4. De reparatie

**Vervang de exclusiviteitsclaim door het feit dat hem draagt.** Voorstel voor de enUS-regel:

> *"Unique perk: maxing the central Calm Hands node unlocks the weekly Thalassian Treatise —
> **your Treatise then gives 2 Knowledge instead of the usual 1.**"*

Waarom dit beter is dan schrappen: het zegt **exact dezelfde nuttige zaak** — dat dit een reden
is om Calm Hands eerst te nemen — maar het is volledig te staven. De speler verliest niets; wij
verliezen alleen een bewering die we niet konden waarmaken.

⛔ **Niet "one of the few professions" schrijven.** Dat is dezelfde onbewezen claim in een jasje
dat alleen maar vager is.

**Als iemand de exclusiviteit alsnog hard wil maken:** dat is een sweep over de eerste spec-node
van alle elf beroepen op zoek naar een Treatise-bonus. Dat is een eigen onderzoek, en de winst is
één bijvoeglijk naamwoord. **Ik raad het af.**

---

## 5. Meenemen in dezelfde wijziging

1. **Zeven talen.** Na de enUS-correctie: `python tools/check_drift.py` — de zes packs blijven
   anders de oude bewering doen (`ns:L` valt alleen terug bij een *ontbrekende* key, niet bij een
   verouderde). Zie [[translation-drift-provenance-not-content]].
2. **De route is al goed.** `advisorRoutes[773]` staat inmiddels op
   `Calm Hands (10) → Blueprints → Perfected Products → Darkmoon Curiosity`, conform Spec 28.
   Niets te doen.
3. **`PROFGUIDE_LVL_INSCRIPTION` (`enUS.lua:2585`) is nagelopen en klopt** — twee externe bronnen
   beschrijven dezelfde route (rush naar 25, Calm Hands voor het Treatise-recept, first-craft
   bonussen tot 50, daarna Treatises tot 100). Ook de tip *"gebruik de Treatise niet tot je je
   spec hebt gekozen"* is correct. **Niets aan veranderen.**

---

## 6. Klaar als

- De zin bevat geen exclusiviteitsclaim meer, en zegt nog steeds waaróm Calm Hands eerst komt.
- `check_drift.py` is schoon: alle zeven talen zeggen hetzelfde.
- De commit legt vast **waarom** de claim eruit ging, zodat niemand hem later "herstelt" op gezag
  van een gids die hem ook maar overschreef.
