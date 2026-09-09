# Spec 35 — "Your week" toont de helft, en een paar dingen zijn geen weekly

**Van:** ONDERZOEK-sessie, 9 sep 2026
**Voor:** BOUW-sessie
**Raakt:** `Modules/ResetRoutine.lua`, `Modules/AccountWeeklyChecklist.lua`, en de data eronder
**Aanleiding:** Rob: *"er klopt onze addon weekly, voor mijn gevoel, dingen niet."* Twee
parallelle onderzoeken — één over concurrerende addons, één over de spelinhoud zelf — plus mijn
eigen metingen in onze code.

---

## 1. 🔴 De hoofdoorzaak: twee lijsten, elk de helft, en geen van beide zegt dat

GEMETEN met grep in beide bestanden.

| | **"Your week — do these in order"** (`ResetRoutine.lua`) | **Account-checklist** (`AccountWeeklyChecklist.lua`) |
|---|---|---|
| Lady Liadrin (13 quests) | ✅ | ❌ (nul treffers op `liadrin`) |
| Halduron · Aethas · Maella | ✅ | ❌ |
| Trainer-weeklies per beroep | ✅ | ❌ |
| Ritual Sites · Void Assaults | ✅ | ✅ |
| **Delver's Call** | ❌ | ✅ |
| **Mythic+ keystone** | ❌ | ✅ |
| **Catalyst-ladingen** | ❌ | ✅ |
| **Coffer shards** | ❌ | ✅ |
| **Omnium Folio** | ❌ | ✅ |

**Dit is geen datafout.** Beide lijsten zijn goed onderbouwd; ze zijn alleen elk half, en ze
overlappen nauwelijks.

🔴 **Het echte probleem zit in de titel.** *"Your week — do these in order"* leest als
**alles**. Wie dat scherm afwerkt denkt klaar te zijn en mist zijn delve-weekly en zijn
keystone. Dat is dezelfde soort belofte-die-niet-klopt waar deze addon bij spell-data streng op
is; hier glipte het weg omdat het over lay-out gaat en niet over feiten.

### De reparatie, in twee maten

1. **Klein, en vanavond te doen:** laat elk scherm zeggen wat het **niet** dekt, met een knop
   naar de ander. Dat neemt de verkeerde belofte weg zonder de architectuur aan te raken.
2. **Groot:** samenvoegen tot één lijst. Dat is wat je uiteindelijk wilt, maar de twee schermen
   hebben verschillende aannames over per-personage versus account-breed, en dat is het echte
   werk.

📌 **Begin met 1.** Als het misverstand weg is, kun je rustig meten of 2 nog nodig voelt.

---

## 2. Wat er inhoudelijk fout of ontbrekend is

Uit het onafhankelijke inhoudsonderzoek. **Alles hier komt van Wowhead-pagina's die de agent
daadwerkelijk geladen heeft**, niet uit een gids-parafrase — maar het is **niet in Robs client
gemeten**, en dat verschil is in dit project belangrijk. Behandel het als kandidaten.

### 🔴 Drie dingen die we mogelijk verkeerd voorstellen

| Bevinding | Waarom het uitmaakt |
|---|---|
| **De Catalyst is TWEEwekelijks** — `Venomblight Manaflux` (currency 3465), +1 lading per twee weken | Hij staat op onze weekly-lijst. ✅ Onze *tekst* liegt niet (*"Catalyst charges waiting"*, `enUS.lua:2292`), maar de plaatsing suggereert een ritme dat er niet is. Dit strookt met `SPEC_29`, dat zelf al "+1 per twee weken" schreef |
| **Mythic 0 is sinds 18 aug 2026 een DAGELIJKSE reset** | Als wij hem ergens als weekly tonen, is dat sinds drie weken fout |
| **De Lair-boss (Nymrissa, quest 97128) vult de RAID-rij van de vault**, niet World | Dit raakt `VaultAdvisor` rechtstreeks. En het is dezelfde quest die in ons soul-grootboek de grootste bron bleek (`RESEARCH_SOUL_LEDGER_2026-09-07.md`) |

### Wat de échte wekelijkse grens is, waar wij een quest verwachten

- **Delves zijn niet "een weekly"** — de begrenzingen zijn de **600 Coffer Key Shard-cap**,
  Gilded Stash 3×, Hidden Trove 1×, en de Journey-inlevering `A Gnawing Void of Curiosity`
  (**93784**).
- **Prey** is geen "doe een hunt" maar een **cap van 15 hunts** plus *"de eerste 2 per
  moeilijkheidsgraad"* geven een uitrustingskist — zes kisten per week.
- 🎯 **`Purging the Vaults` (95520) geeft in zijn eentje 312 Coffer Key Shards** — meer dan de
  helft van de wekelijkse cap van 600. **Dus de vólgorde van je week doet ertoe**, en dat is
  precies het soort ding dat geen enkele concurrent vertelt.

### ⏳ Nog niet live — niet inbouwen als "je bent iets vergeten"

**Orin Straylights wekelijkse bonusroll en de Ascendant Venomstones bestaan nog niet.** Orin
start ~8 weken na `Prismatic Potential` (97978), dus rond half oktober. Een checklist die er nu
naar vraagt, vraagt naar iets wat niet bestaat.

---

## 3. ⚠️ De Halduron-blokvondst — interessant, en NIET blind overnemen

`ResetRoutine.lua:134` verzamelt de dungeon-of-the-week **één per week**, handmatig:
`{ 93761, 93164, 95468 }`, met een commentaar dat zegt "add each week's confirmed ID here".

Het onderzoek vond een **blok van acht** dungeonquests: **93751–93758**, waarvan er per week één
actief is. Als dat klopt, hoeven we niet acht weken te verzamelen.

🔴 **Maar er is een discrepantie die eerst opgelost moet worden.** Ik heb `93751` opgehaald: die
heet **"Windrunner Spire"**. Bij ons staat **93761** als *"Windrunner Spire"*, en dat ID heeft
**Rob op 10 jun in zijn eigen client bevestigd** via `/mh questscan`.

Twee ID's, één naam. Mogelijke verklaringen: het zijn varianten (level-90 versus levelend, of per
factie), of één van beide is een verschrijving.

⛔ **Vervang 93761 NIET door 93751.** Een eigen meting slaat een Wowhead-ID — dat is precies de
les van [[valeera-s2-poisons]], waar drie Wowhead-ID's fout bleken.

**De juiste volgorde:** `/mh questscan` op de acht ID's uit het blok en kijken welke de client
een titel geeft. Dán weet je of het blok echt is en of onze twee erin passen of ernaast staan.

---

## 4. ⛔ Niet bouwen

1. **Curse Surge is geen weekly.** Een toegewijde tracker toont een cyclus van **45 minuten**.
   Een wekelijks vinkje ervoor zou gewoon fout zijn. (`AtalUtekProbe.lua:750` zegt zelf al
   "we track none of them" — laat dat zo.)
2. **Feestdag-weeklies, eigen taken, verhaalhoofdstukken, content uit oude uitbreidingen.** Elke
   concurrent heeft ze; het is ruis en het maakt de lijst onleesbaar.
3. **Geen vinkje voor Orin Straylight** tot hij bestaat (§2).

---

## 5. Wat we NIET weten

- **PvP is het zwakste stuk.** Er is geen bereikbaar Midnight-S2-PvP-overzicht gevonden. Twee
  wekelijkse PvP-quests gevonden (`Preparing for Battle` 89354, `Against Overwhelming Odds`
  93581/93582/93641/93642), maar de conquest-cap en eventuele BG/arena-weeklies zijn
  **onbevestigd**. Niets inbouwen op deze basis.
- **Raid-lockout ontbreekt volledig.** `GetSavedInstanceInfo` komt **0×** voor in de hele addon.
  Voor een raider is dit de luidste afwezigheid — en tegelijk de duurste bouw.
- **Onze Ritual Sites-data is 12.0.7-materiaal** en citeert Season 1-crests en -ilvls. Voor S2
  onbevestigd. Sluit aan op de twee velden die sinds 19 aug bewust leeg staan
  (`VOID_INFO_VAULT`, `RITUAL_INFO_VAULT`).
- **De `Midnight: X` Journeys-metas lijken seizoensbreed, niet wekelijks** — en hier spreken
  Wowhead en warcraft.wiki elkaar tegen. Niet opgelost, bewust niet gekozen.

⚠️ **Eén methodologische waarschuwing die de agent zelf meegaf:** Wowheads weekly-filter is
**niet uitputtend** — quest `93784` zegt op zijn eigen pagina "Type: Weekly" maar ontbreekt in de
gefilterde lijst. **Afwezigheid uit die lijst bewijst dus niets.** Zie
[[silence-is-not-absence]].

---

## 6. 🎯 Waar dit strategisch heen wijst

De checklist-nis is dubbel bezet (Routine 2,8M, Larias 1,1M). **MH wint daar niet met vinkjes.**

Maar alle concurrenten beantwoorden dezelfde vraag: *"heb je het gedaan?"* — en persen Liadrins
twaalf-plus quests samen tot één regel "rotating weekly meta quest". **Niemand beantwoordt
"wélke van de vier moet je kiezen, en in welke volgorde."**

Dat is een vraag die een vinkje structureel niet kán beantwoorden, en het is waar deze addon voor
gebouwd is. §2 levert er meteen de munitie voor: **doe `Purging the Vaults` vroeg, want hij is in
z'n eentje meer dan de helft van je shard-cap.**

---

## 7. Klaar als

- Geen van beide schermen belooft nog "je hele week" terwijl het de helft toont.
- De catalyst staat niet meer op een plek die een wekelijks ritme suggereert.
- Als Mythic 0 ergens als weekly staat: weg.
- De Halduron-blokvraag is **gemeten**, niet overgenomen — met de uitkomst opgeschreven, ook als
  die is "onze twee ID's staan los van het blok".
- Wat we niet weten (§5) staat nergens ingevuld met een gok.
