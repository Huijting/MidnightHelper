# Het soul-grootboek uitgelezen — de tweede helft van de Codex-vraag

**Van:** ONDERZOEK-sessie, 7 sep 2026
**Sluit aan op:** `docs/CORROSIVE_CODEX_MEASURED.md`, dat op 15 aug schreef: *"daar loopt nu een
soul-grootboek voor … **Kijk daar als eerste — na een week spelen staan de echte getallen
erin.**"* Dat is nooit gebeurd. Dit is die uitlezing.

**Bron:** `ns.db.soulLedger` uit `WTF/Account/JOEYWHATEVER/SavedVariables/MidnightHelper.lua`,
28 regels, 15 aug – 7 sep 2026. Alles hieronder komt uit Robs client.

---

## 1. Wat het grootboek zegt

| Bron (quest in de buurt) | souls | keren | seconden na inleveren |
|---|---|---|---|
| 🔴 **Lair: Nymrissa Wavecaller** (97128) | **18** | **6** | 8 · 14 · 21 · 23 · 25 · 40 |
| Special Assignment: Demand and Supply (96492) | 3 | 1 | 19 |
| Containment Zone (92146) | 2 | 1 | **2216** |
| Purging the Vaults (95520) | 2 | 1 | 3 |
| Temple Patrol: Slay Children of Ula'tek (95598) | 1 | 1 | 312 |

**Nymrissa is de dominante bron**, en als enige met genoeg herhalingen om iets te betekenen:
zes keer, elke keer **precies +3**, en zes keer binnen 40 seconden na de turn-in. Dat is een
patroon, geen samenloop.

### ⚠️ Wat deze tabel NIET zegt

1. **Het grootboek meet nabijheid, geen oorzaak** — zo is het ook gebouwd. Containment Zone
   staat op **2216 seconden** (37 minuten); die regel is waardeloos als attributie en hoort niet
   als bron geteld te worden.
2. **Ongeveer de helft van de opbrengst heeft géén quest in de buurt.** Elf regels met een
   positieve delta staan zonder titel. Dat is vermoedelijk kist-, rare- en wereldloot, maar het
   grootboek kan het niet uit elkaar houden en ik dus ook niet.
3. **Eén regel is onverklaard:** 21 aug, `delta = -2` toegeschreven aan *Delver's Call: The
   Darkway* (406 s). Een verlies bij een turn-in slaat nergens op; waarschijnlijk een
   tasbeweging die de filter niet ving.

📌 **Filterdetail voor wie dit reproduceert:** vier regels op 15 aug zijn `-3` gevolgd door `+3`
binnen één seconde. Dat zijn tasverplaatsingen, geen inkomsten. Zonder die filter komt
"Special Assignment" op 6 uit in plaats van 3.

---

## 2. ✅ De prijs is nu twee keer bevestigd

Twee regels met **exact `-8`**: 19 aug 14:01 en 6 sep 09:45. Dat bevestigt in de praktijk wat op
15 aug uit twaalf tooltips kwam — **8 souls per gift, 12 gifts, 96 totaal.**

**Rob heeft dus twee powers ontgrendeld.** Saldo bij de laatste schrijfactie: **5**, op
7 sep 13:42.

⚠️ **Wélke twee is onbekend en niet uit te lezen** — de Codex is geen `C_Traits`-boom
(19 bomen gesweept, `CORROSIVE_CODEX_MEASURED.md` §2). Rob kijkt het na.

---

## 3. Wat dit voor de addon betekent

**De vraag "hoe lang doe ik over de hele Codex" is nu voor het eerst te beantwoorden**, en het
antwoord is eerlijk te geven omdat beide helften er liggen:

- **prijs:** 96 souls (gemeten, twee keer bevestigd)
- **opbrengst:** in 23 dagen kwam Rob aan **twee** powers, oftewel ruwweg 16 souls in drie weken
  aan aantoonbaar toegeschreven inkomsten, plus een vergelijkbare hoeveelheid ongeattribueerd

⚠️ **Reken dat niet door naar "X weken voor alles".** Eén speler, één ledger, drie weken, en de
helft van de inkomsten zonder bron. Wat je wél kunt zeggen: **Nymrissa is de betrouwbaarste
bron en geeft +3**, en de rest is los zand tot er meer data is.

🔴 **Het bruikbaarste dat MH hiermee kan doen is niet een schatting maar een aanwijzing:**
*"Lair: Nymrissa Wavecaller geeft 3 Corrosive Souls"* — dat is één zin, hij is gemeten, en hij
staat nergens anders. Precies de vorm van uitleg waar deze addon voor bestaat.

---

## 4. Aanbeveling

1. **Laat het grootboek doorlopen.** Het kost niets en het wordt elke week beter.
2. **Zet de Nymrissa-regel in de Codex-tekst** zodra iemand hem in de content wil hebben — met
   het getal, want dat is wat niemand anders heeft.
3. **Vul de ongeattribueerde helft niet in met een gok.** Als het de moeite waard is, is de
   volgende stap dat het grootboek de *zone en de gebeurtenis* meeschrijft in plaats van alleen
   de laatste quest. Dat is een kleine wijziging en het maakt de tweede helft leesbaar.
