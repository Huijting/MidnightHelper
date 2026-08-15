# Corrosive Codex — wat gemeten is, en wat de spec daarom niet kan

Gemeten 15 aug 2026 op Robs live client, via `/mh atal` (currency-lijst, tas-scan,
trait-sweep over tree-id 1..1400 met node-namen). Alles hieronder komt uit zijn client,
niet uit een gids.

---

## 1. Soul is geen currency — de spec zit hier fout

| | wat het is | id | gemeten |
|---|---|---|---|
| **Corrosive Coin** | currency | **3448** | `maxQuantity = 0` (geen cap), 6387 in bezit |
| **Corrosive Soul** | **item in je tas** | **273000** | 13 in bezit, alleen gevonden door de tas-scan |

Onafhankelijk bevestigd door Plumber (`ResourceList.lua`), dat dezelfde splitsing met
dezelfde twee ids hanteert.

**Gevolg voor de spec:** §4 vraagt om "de currency-ID van Corrosive Souls" en §6 wil dat
de balans klopt met de currency-UI. Die currency bestaat niet. De balansregel, het
weektotaal en de "kan ik de volgende power betalen"-test lezen dus `C_Item.GetItemCount`,
niet `C_CurrencyInfo`. Dit is geen detail: §5 zegt zelf dat een verkeerde soul-balans
erger is dan geen soul-balans.

---

## 2. De Codex is GEEN C_Traits-boom — §8.2 is daarmee beantwoord

De sweep vond **19 trait-bomen** op dit character. Achttien daarvan gaven bijna al hun
nodes met naam terug (bv. 45/45, 47/51, 39/43), dus dit is een leesbare meting en geen
blinde vlek.

**Controles aanwezig:** Runes of Power (tree 1186, 5 nodes), Brann 11.2 (1151),
Valeera 12.0 (1168) en 12.1 (1223).

**Geen enkele boom bevat:**
- één van de twaalf power-namen uit §4 van de spec (Ula'tek's Gift, Ouroboric Cycle,
  Ophidian Maw, Viperine Grasp, Mephitic Cloud, Miasma Geyser, Insidious Venom,
  Virulent Mucus, Accursed Poison, Plague of Corrosion, Gorgoneion Gaze, Lithic Plumage)
- één van de vier discovery-nodes uit `VAULTS_DISCOVERIES.md` (Run of the Vaults,
  Broodmaster, Spectral Winds, Spiritual Protection)
- de woorden corrosi/corrode/Ula'tek/Atal in welke node dan ook

**Geen enkele boom geeft item 273000 uit.**

> ⚠️ Twee lezingen bleven open toen alleen de currency was bekeken: "de Codex is geen
> trait-boom" en "de spec-namen kloppen niet". De namen sluiten dat nu: als het een
> trait-boom wás, zouden de vier discovery-nodes uit ons eigen onderzoek erin staan,
> hoe fout de gids-namen ook zijn. Ze staan er niet.
>
> ✅ **En de tweede lezing is 15 aug definitief dood.** Blizzards eigen hotfix van
> 14 aug noemt *Gorgoneion Gaze* en *Ula'tek's Gift* bij naam (`PTR_12.1_WATCH.md`,
> 15 aug). Dat zijn dus Blizzard-namen en geen gids-parafrase — en ze staan alsnog in
> geen van de 19 bomen. De conclusie werd daarmee **sterker**, niet zwakker.

### ⚠️ Maar "geen trait-boom" was een antwoord over één route

Dat de powers echte spells zijn (Blizzard noemt ze zo in patch notes) betekent dat ze
een **spell-ID** hebben. "Niet leesbaar via `C_Traits`" heb ik één avond lang laten
staan als "niet leesbaar", en dat is een grotere claim dan de meting droeg.

`/mh atal` zoekt nu de twaalf namen op via `C_Spell.GetSpellIDForSpellIdentifier`
(**lookup-gereedschap, met een positieve controle op "Auto Attack"** — nooit shipped
logica, want naam-matching werkt alleen op een Engelse client) en kijkt per gevonden id
naar `IsPlayerSpell` en `C_UnitAuras.GetPlayerAuraBySpellID`. Die laatste is bewust de
spellID-route: index-iteratie gooit een Lua-error zodra auras secret zijn in 12.1, de
spellID-route blijft werken.

**Als een actieve power een aura op de speler is, is §3.1 alsnog te bouwen** — alleen
via een heel andere weg dan de spec beschrijft.

#### Uitkomst 15 aug, avond — de naam-route is dood, en de meting was leeg om een andere reden

`GetSpellIDForSpellIdentifier` gaf **0 van de 12** een id. En de tweede controle gaf
**false**: een spell die een Paladin niet heeft resolvet óók niet. De functie reikt dus
alleen tot je eigen spellbook, en die twaalf blanco's zijn de vorm van de API, geen
uitspraak over de powers. ⚠️ Met alleen de eerste controle ("Auto Attack") had hier
gestaan dat de powers geen spells zijn.

Daarna een aura-dump op het eiland: **4 auras, allemaal leesbaar** (Arcane Intellect,
Sandstone Drake, Sign of the Emissary, Flight Style: Steady). Geen Codex-naam. Reden
bleek uit Robs screenshot van de Codex-UI: **alle twaalf staan op slot.** Er was niets
te vinden. De methode faalde niet — er is nog niets ontgrendeld.

✅ **Wat die screenshot wél vaststelt:**
- de twaalf namen in de spec zijn **exact** wat het spel toont
- de UI-tekst: *"Unlock powerful gifts by offering Corrosive Souls. You may only use one
  gift until your offerings are sufficient. Only then are you worthy of choosing two."*
  Dat bevestigt §3.1's tweede slot, maar noemt **geen aantal van 8** — die 8 komt nog
  steeds alleen uit gidsen.
- **de aura-read op `"player"` werkt gewoon in 12.1** — geen secret values, geen
  Lua-error. Relevant voor `MissingBuff`.

**Volgende meting:** zodra Rob één power ontgrendelt, opnieuw `/mh atal` op het eiland.
Verschijnt hij dan als aura, dan is §3.1 te bouwen; verschijnt hij niet, dan is die
route definitief dood.

---

## 5. Gemeten uit de Codex-tooltip (Rob, 15 aug, in een delve)

### Ula'tek's Gift — de eerste power met een gemeten prijs én gemeten tekst

> **Kosten:** *"Offer 8 Corrosive Souls to unlock."*

> **Effect (letterlijk uit het spel):** *"Your harmful spells and abilities have a chance
> to afflict your target with 5 stacks of Ula'Tek's Gift, dealing Nature damage per
> application every 5 sec for 1 min. While you are Poisoned, apply 5 additional stacks.
> Upon applying 20 stacks to a target, the Gift Corrodes, dealing the remainder of its
> damage immediately before removing itself."*

⚠️ **Eén van de twaalf is geen bewijs voor alle twaalf.** De spec zegt "8 souls, volgens
huidige bronnen uniform voor alle 12" — dat eerste getal is nu gemeten, dat woord
*uniform* niet. Twee punten maken nog geen lijn (zie de teruggetrokken kostenladder in
`VAULTS_DISCOVERIES.md`). De spec zegt zelf dat de kosten **per power** in data moeten;
dat blijft dus staan, met elf lege velden.

⚠️ **De gids-parafrase klopte net niet, en miste een hele mechaniek.**

| | |
|---|---|
| spec §4 | "Stapelende Nature-DoT op targets; stacks **verdubbelen** terwijl je zelf Poisoned bent" |
| het spel | basis **5** stacks, Poisoned geeft **+5** — hier toevallig een verdubbeling |
| spec §4 | *(niets)* |
| het spel | **bij 20 stacks "Corrodes" de Gift**: de resterende schade valt direct en de debuff verdwijnt |

"Verdubbelen" is een regel, "+5" is een getal. Ze zijn hier toevallig gelijk, en bij een
andere basis niet meer. En de 20-stack-ontlading — de reden waarom je überhaupt stacks
wilt opbouwen — staat nergens in de spec. Dit is precies waarom §4 zegt: haal de teksten
uit het spel, niet uit de gids.

✅ **En het bevestigt dat de powers spell-achtig zijn**: ze hebben een echte tooltip met
stacks, duur en periodieke schade. Dat maakt de aura-route voor §3.1 aannemelijker, niet
minder — zodra er één ontgrendeld is, is het te meten.

**Gevolg:** §3.1 (actieve powers, tweede slot bij 8) en §3.3 (X/12 unlocks) zijn **niet
te bouwen** zoals de spec ze beschrijft. Er is geen leesbare unlock-status.

### De enige onopgeloste boom

**Tree 1191** — 22 nodes, maar slechts **2** met een leesbare naam: *Volatility
Overflowing* (spell 1307833) en *Venomous Hunt* (1307823, ranks 1). Currency-type 3,
`spent = 2`. De spell-ids liggen in de 12.1-band. Twintig van de tweeëntwintig nodes
geven niets terug.

Dit is **niet** de Codex — die twee namen staan niet in de twaalf, en de Codex heeft er
twaalf. Maar het is wel het enige dat we niet kunnen benoemen, en het is 12.1-content.
Nog uit te zoeken; niet gebruiken tot het een naam heeft.

---

## 3. Wat WEL te bouwen is

Een v1 van de module is haalbaar, maar het is de **checklist-helft**, niet de
power-helft:

- **Soul-saldo** — `C_Item.GetItemCount(273000)`. Klopt per definitie met je tas.
- **Coin-saldo** — currency 3448, geen cap.
- **De weeklies en dailies** — alle tien quest-ids zijn 15 aug tegen de client
  geverifieerd (zie `Locales/Codex.lua` en de `REPEATABLE`-tabel in `AtalUtekProbe.lua`).
  Wat de spec §3.2 wil weten (staat hij nog open?) is `IsQuestFlaggedCompleted`.

**Nog NIET te bouwen zonder meting:** de kolom "opbrengst in souls" uit §3.2 (2/2/1/6).
Die getallen komen uit gidsen. De juiste manier is Robs `GetItemCount(273000)` vóór en ná
één weekly loggen; tot dat gebeurd is toont de checklist wél de bron en géén getal.

---

## 4. Bijvangst: de Valeera-boom is gevonden

Tree **1223 = "12.1 Valeera Sanguinar"** (48 nodes), tree **1168 = "12.0"** (50 nodes).
De client noemt ze zelf zo.

Dit bevestigt op **live** wat op 27 jul op de PTR gemeten was, en waar Wowhead het fout
had:

| curio | spell-id | status |
|---|---|---|
| Soulthirst Venom | **1250826** | ✓ komt overeen, en Rob heeft er ranks 1 op |
| Poison of the Forgotten Master | **1249934** | ✓ komt overeen |
| Bloodcrypt Toxin | **1251120** | ✓ komt overeen |

En belangrijker: `ranksPurchased` is leesbaar. In de 12.1-boom staan er drie op 1
(Soulthirst Venom, Soul-Cracking Dreamcatcher, Ouroboric Curse). **Welke curio's Rob
gekozen heeft is dus wél uit te lezen** — precies wat de Codex-module níet kan.
