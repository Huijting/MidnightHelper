# Kandidaten uit een Valeera-DPS-video

**Van:** ONDERZOEK-sessie, 9 sep 2026
**Bron:** transcript van een YouTube-gids over Valeera's schade in delves, aangeleverd door Rob.

⚠️ **KANDIDATEN, geen bewijs.** Eén spreker, geen bronvermelding, en hij zegt zelf meermaals
*"I'm not sure"*, *"this may just be random variation"* en *"there may be something going on
behind the scenes"*. Zelfde behandeling als `RESEARCH_S2_GEARING_VIDEO.md`: niets hiervan gaat
de addon in zonder toets.

---

## 1. ✅ Wat het bevestigt — en Rob draait het al

GEMETEN 2 sep uit Robs eigen Valeera-venster (`DelveCuriosData.lua:236-241`):

| Slot | Robs keuze | Video raadt aan |
|---|---|---|
| Combat Role | **Tank** | Tank |
| Poisons | **Bursting Toad Toxin** (110784) | Bursting Toad Toxin |
| Combat Curio | **Corrosive Bilespear** (110786) | "Corrosive Biosphere" |
| Utility Curio | **Soul-Cracking Dreamcatcher** (110785) | Soul-Cracking Dreamcatcher |

**Vier van vier.** Dat is geruststellend en verder geen nieuws.

📌 **Naamcontrole:** de video zegt *"biosphere"* / *"Bio Spear"*. Het heet **Bilespear** — onze
naam komt uit Robs eigen venster. Een spraak-transcript is geen naamsbron.

---

## 2. 🎯 De sterkste kandidaat: de stapelende schadebuff van healen

> *"when Valyra is a tank and you're playing a healer and you keep healing her, you get a
> stacking damage buff on her that can go up to 12 times … at 12 stacks is 80% damage increase"*

**MH zegt hier niets over.** Gegrepd op `12 stacks` en `80%`: geen treffer in `enUS.lua`.

Waarom dit de beste kandidaat van de hele video is:
- Het is een **mechaniek**, geen meting. Mechanieken zijn te verifiëren; DPS-getallen niet.
- Het is **actiegericht**: "blijf haar healen" is iets wat je doet.
- Het verklaart iets wat je merkt maar niet begrijpt — precies MH's lijn.

⚠️ **Te toetsen:** de buff moet een naam en een spell-ID hebben. Als hij op Valeera zit en niet
op de speler, is `ns.Aura` op haar unit de route (zie [[aura-facade-12-1]] — gericht vragen mag,
opsommen niet). Vraag Rob om de tooltip als hij een healer speelt.

---

## 3. De rest, op afnemende bruikbaarheid

### a) Resto Shaman + Skyfury zou Valeera enorm versterken
De video's hoofdclaim. **Niet encoderen.** Redenen:
- De spreker noemt het de hele video **"windfury"** en corrigeert pas op 15:12 naar **Skyfury** —
  hij was tot dan toe de naam van zijn eigen kernbewering kwijt.
- Zijn verklaring is openlijk speculatief: *"maybe it's like giving her damage increases from the
  masteries from other roles or something"*.
- Het getal (600k) komt van één DPS-meter, één speler, één context.

📌 MH kent Skyfury al (`MissingBuffData.lua`, `KeybindRoles_Shaman.lua`) maar nergens in verband
met Valeera. Als iemand dit ooit wil toetsen: de dubbelslag-component van Skyfury op haar
auto-attacks is meetbaar; de "mastery doet iets onzichtbaars"-theorie niet.

### b) Rolkoppeling — wat kies JIJ voor haar
> healer → Valeera als tank · tank → Valeera als DPS · DPS → Valeera als tank (tenzij
> ondergeared, want ze houdt aggro van je af)

Redelijk en intern consistent. MH heeft rol-afhankelijk **curio**-advies maar geen advies over
**haar rol tegenover de jouwe**. Dat is een echt gat en het is goedkoop te vullen — maar het is
gids-advies, dus met bronvermelding en zonder stelligheid.

### c) "8 van de 12 powers ontgrendelt het tweede slot"
🎯 **Dit corroboreert iets dat wij als onzeker hadden gemarkeerd.**
`CORROSIVE_CODEX_MEASURED.md` schreef: de UI-tekst noemt *"geen aantal van 8 — die 8 komt nog
steeds alleen uit gidsen"*.

Dit is een **tweede gids**, geen meting. De status blijft dus "twee gidsen zeggen 8, het spel
zegt het niet". ⚠️ Robs eigen grootboek staat op **2 van de 12**, dus dit is voorlopig niet door
hem te meten.

### d) De drie 12.1-poisons komen uit een quest bij de Delver's-plek
> *"there is a quest at the Delver's area to talk to Valyria … that will give you the three new
> poisons of 12.1"*

Sluit aan op [[valeera-s2-poisons]], dat de drie poison-ID's al gemeten heeft (Soulthirst
1250826 / Forgotten Master 1249934 / Bloodcrypt 1251120 — Wowhead had ze fout). **Wat we niet
hebben is de quest die ze geeft.** Eén quest-ID zou de keten compleet maken. Te vinden met
`/mh questscan` bij de Delver's-plek.

### e) Corrosive-powers ranglijst
Ophidian Maw ("Aidian Maw" in het transcript) als hoogste schade, Ula'tek's Gift tegen taaie
doelen, Insidious Venom als onderschat.

⛔ **Niet encoderen.** Onze eigen `SPEC_29`/Codex-lijn is dat we powers niet rangschikken, en
deze video verandert daar niets aan — het is één speler zonder methode. Wat wél klopt en al bij
ons staat: Ula'tek's Gift ontlaadt bij 20 stacks (`CORROSIVE_CODEX_MEASURED.md` §5, uit de
tooltip zelf).

---

## 4. ⛔ Niet encoderen, samengevat

1. **Alle DPS-getallen.** 600k, 581k, 500k gemiddeld, "700.000 damage proc" — één speler, één
   context, geen methode.
2. **De curio- en power-ranglijsten.** MH rangschikt bewust niet
   (`DelveCuriosAdvisor.lua:929`), en één video is geen reden om die positie op te geven.
3. **"De DPS-meter meet Ula'tek's Gift verkeerd."** De spreker zegt er zelf bij dat hij het niet
   zeker weet. Een meetfout beweren zonder meting is precies verkeerd om.
4. **De Skyfury-theorie** (§3a).

---

## 5. Aanbeveling

**Eén ding is het natrekken waard: de stapelende heal-buff (§2).** Dat is een mechaniek die de
speler kan gebruiken, die MH niet uitlegt, en die te verifiëren is met een tooltip.

De rest is achtergrond. De video bevestigt vooral dat Robs huidige opstelling goed is, en dat is
op zichzelf een nuttige uitkomst — maar geen wijziging.

📌 **En de goede volgorde is opnieuw bevestigd.** Bij de vorige video (`RESEARCH_S2_GEARING_VIDEO`)
bleek de spreker gelijk te hebben over het feit en ongelijk over drie details. Hier is het
patroon hetzelfde: de curio-keuzes kloppen, de namen niet en de getallen zijn oncontroleerbaar.
