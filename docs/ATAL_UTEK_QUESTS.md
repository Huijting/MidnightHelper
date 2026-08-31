# Vaults of Atal'Utek — wat er aan quests is (31 aug 2026)

Twee onafhankelijke sweeps: Zygors lokale gidsbestanden (op naam) en Blizzards DB2 via
wago.tools (op **map-ID 2509**). De tweede vangt precies wat de eerste mist.

⚠️ **DIT IS EEN ONDERGRENS, GEEN VOLLEDIGE LIJST.** De DB2-sweep gaat over `QuestPOIBlob` en
vindt dus alleen quests **met een kaartmarkering op 2509**. Eén gemiste is al bevestigd: **98232
"Midnight: Vaults of Atal'Utek"**, de zone-meta, bestaat en kwam niet boven. Mijn Zygor-pass was
nóg smaller: alleen titels met de zonenaam erin.

📌 **Positieve controles die de agent draaide** — zonder deze zou "geen resultaat" niets
betekenen: `QuestPOIBlob` op 2509 gaf 124 rijen / 28 quests, dezelfde query op de ouderkaart 2512
gaf 554 / 87. En een filter dat leeg terugkwam is getest met een string die wél moest matchen.

---

## 🔴 Wat dit ons vertelt over MH, in volgorde van belang

### 1. De zone is zwaarder gepoort dan wij ergens zeggen

**Level 90** (gemeten op zeven quests), én de campagne moet doorlopen zijn: 98388 staat in
questline 6232 direct ná **93420 "Lor'themar's Judgement"**, en in diezelfde keten zitten de
**Altar of Fangs**-dungeon (93417) en de **Venomous Abyss**-raid (93418) als harde stappen.

⚠️ Ik beschreef deze zone dezelfde dag aan een beginner zonder één van die eisen te noemen. Een
route-knop naar een deur die niet opengaat is erger dan geen knop.

### 2. Onze introketen mist een quest

Wij shippen drie; het zijn er **vier**. `QuestLineXQuest` (questline 6232, gemeten):

| # | id | quest |
|---|---|---|
| 4 | 98388 | Into the Vaults of Atal'Utek |
| 5 | 97640 | Vaults of Atal'Utek: One Coin Too Many |
| 6 | **98515** | **Vaults of Atal'Utek: A Toxic Tour** ← ontbreekt bij ons |
| 7 | 98428 | Vaults of Atal'Utek: The Altar of Corrosion |

🔴 **En de bronnen spreken elkaar tegen over wát 98515 is.** Zygor zet hem in
`ZygorDailiesCommonMID.lua` (dus: dagelijks), de questline-data zet hem als eenmalige
verhaalstap. Beide zijn echte waarnemingen. **Niet opgelost — de client beslist.** Zijn doelen
(Temple Patrol, Temple Strike, Temple Incursion, een Ancient Foe) zijn wél herhaalbare
activiteiten, wat allebei de lezingen verklaarbaar maakt.

📌 Er bestaan **twee overlappende questlines** voor hetzelfde gebied: 6352 met drie quests, 6232
met alle acht. Daarom zegt Wowhead "1st of 3".

### 3. "Niemand heeft gemeten wat de keten oplevert" kan weg

`CampaignLeadIn.lua` draagt die notitie. Gemeten (wiki-infoboxen, spells bevestigd op Wowhead):
**41.100 XP, 103g 48s, 1000 Corrosive Coins**, plus twee ontgrendelingen — de zone zelf
(spell 1310359) en het **Altar of Corrosion** (spell 1310218), waar je Spirit Corrosion aan
traits uitgeeft.

⚠️ **Eén beloningslijst is WEGGEGOOID, niet gebruikt.** Een extractie gaf voor 98515 een setje
items en currencies terug dat **identiek** was aan dat van een niet-verwante quest — dus een
gedeelde zone-zijbalk die meegeschraapt werd, geen beloningsvak. De agent zag het zelf. Dit is
precies de fout die zelfverzonnen loot voor een speler zou zetten.

### 4. Een plaatsnaam die wij verzonnen (GEREPAREERD)

Wij schreven **Vault of Restless Brothers** in zeven talen. Het questdoel van 95954 zegt
**Vault of Restless Bones** — gemeten uit de live clientstring. Onze bron was gidsproza.

---

## De lijst

### Campagne, vóór de Vaults (op kaart 2512)
93417 Altar of Fangs · 93419 Nature of Her Wounds · 93418 The Venomous Abyss ·
93420 Lor'themar's Judgement

### De Med'jai-zijketen — questline 6227 "The Honored Med'jai"
95521 The Med'jai Medallion (start met een **gedropt voorwerp**, INFERRED) · 95522 Guardians of
Death, Guardians in Stone · 95523 Worthy of the Past · 95524 The Unremembered · 95954 An Ancient
Foe · 95525 A Worthy Vigil

### Losse / herhaalbaar
95520 Purging the Vaults (**wekelijks — gemeten**, de enige met die vlag) · 96305 The Innocent
Essence · 98419 Shoulder to Shoulder · 98420 What's Out There? · 96113 Venom Fishing: Maximum
Potency · en vijf namen die **elk onder twee quest-ids** staan: Ancestral Gems (96267/96349),
Cursed Existence (96271/96361), A Balance Paid in Blood (96273/96354), Wading In (96275/96360),
Dark Charms (96276/96352).

⚠️ De dubbele ids zijn **gemeten**; wáárom ze dubbel zijn niet. Ga er niet van uit dat één van
elk paar dood is.

⚠️ **Van geen enkele quest in deze laatste groep is bekend wie hem geeft of wat hem opstart.**
NOT FOUND, geen enkele bron.

---

## Nog open
- Is 98515 verhaal of dagelijks? Alleen in het spel te zien.
- De gevers van de losse quests.
- Waarom vijf namen twee ids hebben.
- Bestaan er quests in de zone zónder kaart-POI, buiten 98232?
