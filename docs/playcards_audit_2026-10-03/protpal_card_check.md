# Mist de "Zo speel je"-kaart knoppen voor Prot Paladin (66)?

Onderzoek 3 okt 2026. Strikt read-only; niets gewijzigd, geen git. `MidnightHelper/docs/` niet gelezen
(opdracht), dus de audit van 17 sep is **niet** als bron gebruikt — alles hieronder komt uit de code zelf
of uit een genoemde, gedateerde gids.

Elke bewering is gemarkeerd **GEMETEN** (zelf gelezen, met bestand:regel of URL) of **AFGELEID**.

---

## 1. Waar de kaart woont

| wat | bestand:regel | markering |
|---|---|---|
| De data-tabel per spec | `E:\World of Warcraft\_retail_\Interface\AddOns\MidnightHelper\Modules\PlayCards.lua:30-191` | GEMETEN |
| De rij voor spec 66 | `Modules\PlayCards.lua:35-38` | GEMETEN |
| De tekst (Engels) | `Locales\enUS.lua:917-925` | GEMETEN |
| Het venster + de 4 tabs | `Modules\PlayCardWindow.lua:752-776` | GEMETEN |
| Tab "Stay alive" | `Modules\SurvivalPlan.lua` + tags in `Modules\KeybindRoles_Paladin.lua` | GEMETEN |
| Tab "Dispel" | `Modules\PlayCardWindow.lua:419-602` + `Modules\HealerCooldowns.lua:273-276` | GEMETEN |
| Tab "Consumables" | `Modules\PlayCardWindow.lua:604-662` | GEMETEN |

De header van `PlayCards.lua` legt de bedoeling uit. Letterlijk, regels 12-17 (GEMETEN):

> The shape is fixed on purpose, because the whole point is that it stays short:
> IDEA / S1..S5 / AOE / MISTAKE / HERO1/2

En regel 21 (GEMETEN): *"A spell without a confirmed 12.1 id is written as plain English text instead of a
guessed id."* Dát is waarom **Hammer of Light** en **Holy Bulwark** op de kaart geen icoon en geen tooltip
hebben: het zijn bewust platte woorden, geen gegokte ID's.

---

## 2. Wat er voor spec 66 in de data staat

### 2a. De kaart zelf — tab "Your buttons"

`Modules\PlayCards.lua:35-38` (GEMETEN):

```lua
[66] = { -- Protection Paladin
    steps = 4, aoe = true, hero = 2,
    source = "Method 3 Sep · Wowhead 12 Aug · Icy Veins 21 Sep 2026",
},
```

De 9 knoppen die de kaart noemt (`Locales\enUS.lua:917-925`, GEMETEN):

| plek | knop | spell-id |
|---|---|---|
| IDEA | Shield of the Righteous | 53600 |
| S1 | Avenging Wrath · Divine Toll | 31884 · 375576 |
| S2 | Shield of the Righteous | 53600 |
| S3 | Judgment · Blessed Hammer | 20271 · 204019 |
| S4 | Avenger's Shield · Consecration | 31935 · 26573 |
| HERO1 | Hammer of Light (platte tekst) | — |
| HERO2 | Sacred Weapon · Holy Bulwark (platte tekst) | 432472 · — |

### 2b. Is de beperking bewust of toevallig?

**Bewust, maar de "4" is een losse keuze per spec.** GEMETEN:
- De vorm (idee + stappen + AoE + fout + 2 hero-regels) staat vast in de header, regel 12-17.
- Het maximum is **5 stappen**: de lus is `for i = 1, c.steps` (`PlayCards.lua:235-238`) en 15 van de 40
  specs staan op `steps = 5` (bv. Elemental 262, Fire 63, Havoc 577).
- Spec 66 staat op `steps = 4`. Er staat **geen reden** bij waarom 66 één stap minder kreeg dan die 15.
  AFGELEID: er was dus ruimte voor een 5e regel en die is niet gebruikt.

### 2c. Tab "Stay alive" voor spec 66

Afgeleid uit `survival`-tags in `Modules\KeybindRoles_Paladin.lua` (GEMETEN, regelnummers erbij):

| stap | knop | id | regel |
|---|---|---|---|
| keepup | Shield of the Righteous | 53600 | :136 |
| small 1 | Divine Protection | 403876 | :70 |
| small 2 | Ardent Defender | 31850 | :151 |
| big 1 | Guardian of Ancient Kings | 86659 | :66 |
| big 2 | Sentinel | 389539 | :197 |
| big 3 | Blessing of Spellwarding | 204018 | :73 |
| big 4 | Blessing of Protection | 1022 | :71 |
| big 5 | Divine Shield | 642 | :63 |
| heal 1 | Word of Glory | 85673 | :86 |
| heal 2 | Lay on Hands | 633 | :88 |
| escape | Divine Steed | 190784 | :59 |
| interrupt | Rebuke | 96231 | :56 |

De lijst wordt gefilterd op `IsPlayerSpell`, dus wat hij niet kent, staat er niet (GEMETEN
`Modules\SurvivalPlan.lua:221-241`).

### 2d. Tab "Dispel" voor spec 66

GEMETEN `Modules\HealerCooldowns.lua:273-276`: Cleanse Toxins 213644 (poison/disease) en Cleanse 4987
(magic). GEMETEN `Modules\PlayCardWindow.lua:430-437`: in `ENEMY_DISPELS` staat **geen** PALADIN, dus het
kopje "van vijanden afhalen" zegt bij hem "geen".

### 2e. Tab "Consumables"

Items, geen spells (GEMETEN `Modules\PlayCardWindow.lua:354-362`). Buiten deze vraag.

---

## 3. De echte knoppenlijst van een Prot Paladin in 12.1

Bronnen, allemaal zelf geopend op 3 okt 2026:

| bron | datum op de pagina | markering |
|---|---|---|
| Icy Veins, Prot Pal Rotation, Cooldowns and Abilities — 12.1 | header "Aug 21, 2026"; changelog "21 Sep. 2026: Updated openers for Instruments of the Divine" en "10 Aug. 2026: Reviewed for Patch 12.1" | GEMETEN |
| Icy Veins, Prot Pal Spell List and Glossary — 12.1 | "Aug 10, 2026" | GEMETEN |
| Icy Veins, Prot Pal Spec, Builds and Talents — 12.1 | "Sep 21, 2026" | GEMETEN |
| Method, Protection Paladin — Playstyle and Rotation | "Patch: 12.1 · Last Updated: 3rd Sep, 2026" | GEMETEN |
| wow.gg Prot Pal | geen patch genoemd, "2026-08-16" | GEMETEN, maar NIET gebruikt: noemt nog **Eye of Tyr** en **Holy Armaments** |

URL's: https://www.icy-veins.com/wow/protection-paladin-pve-tank-rotation-cooldowns-abilities ·
https://www.icy-veins.com/wow/protection-paladin-pve-tank-spell-summary ·
https://www.icy-veins.com/wow/protection-paladin-pve-tank-spec-builds-talents ·
https://www.method.gg/guides/protection-paladin/playstyle-and-rotation

### 3a. Rotatie-knoppen

Icy Veins' prioriteitslijst, letterlijk uit de pagina gehaald (GEMETEN):

1. Avenging Wrath
2. Sacred Weapon if you do not have Avenging Wrath active
3. Divine Toll
4. Hammer of Light
5. Consecration if you are not standing in it
6. Avenger's Shield if Vanguard is active
7. Shield of the Righteous when you are between 3 and 5 Holy Power
8. Hammer of Wrath / Judgment
9. Blessed Hammer
10. Hammer of the Righteous
11. Avenger's Shield
12. Arcane Torrent (racial)
13. Word of Glory if you have a charge of Shining Light and are below 50% Health
14. Word of Glory if you have a charge of Shining Light
15. Consecration if everything else is on cooldown to refresh the duration

In AoE wisselen alleen 8 en 11 van plek: Avenger's Shield komt dan **direct na** Shield of the Righteous
(GEMETEN, de AoE-variant van dezelfde lijst).

Method 3 sep, Templar (GEMETEN): Hammer of Light → Shield of the Righteous → Hammer of Wrath →
Avenger's Shield → Judgment/Hammer of Wrath → Blessed Hammer → Avenger's Shield → **Word of Glory if free
to cast with Shining Light** → Blessed Hammers → Consecration.
Method, Lightsmith (GEMETEN): Consecration met 5 stacks Divine Guidance staat **bovenaan**; verder Sacred
Weapon, Holy Bulwark, Hammer of the Righteous bij Blessed Assurance.

Opener (Icy Veins, GEMETEN): *"Before the pull: Pre-place Consecration … cast Blessed Hammer … and pull the
enemy with **Hand of Reckoning**."*

### 3b. Cooldowns

Avenging Wrath (of Sentinel) — GEMETEN beide bronnen; Method: *"Avenging Wrath (or Sentinel)"*.
Divine Toll — GEMETEN. Sacred Weapon / Holy Bulwark (Lightsmith) — GEMETEN.

### 3c. Verdediging

Ardent Defender (20% DR, 2 min), Guardian of Ancient Kings (50% DR, 3 min, **twee charges** met
Empyrean Authority), Sentinel, Divine Shield, Blessing of Protection (fysiek), Blessing of Spellwarding
(magisch). Allemaal GEMETEN op de Icy Veins-spell-list en in Methods "Cooldowns and Defensive Usage".
Actieve mitigatie: Shield of the Righteous **en** Word of Glory — GEMETEN, dat zijn letterlijk de twee
kopjes onder "Active Mitigation for Protection Paladins".

### 3d. Heal

Word of Glory (hoofdheal; gratis bij Shining Light), Lay on Hands, Flash of Light. GEMETEN.
Method: *"most of your healing will come from Word of Glory"*.

### 3e. Utility / interrupt / taunt

Rebuke (interrupt), Avenger's Shield (**interrupt/silence**, GEMETEN: *"deals Holy damage and interrupts
the target"*), Hammer of Justice (6 s stun), Blinding Light, Turn Evil, Blessing of Freedom, Blessing of
Sacrifice, Divine Steed, Cleanse Toxins, Redemption, Intercession, Hand of Reckoning (taunt, 8 s cd),
en de drie Aura's (Devotion / Concentration / Crusader). Allemaal GEMETEN op de Icy Veins-spell-list.

### 3f. Hero-talent-knoppen

- **Templar**: `Light's Guidance` geeft 12 s na Divine Toll toegang tot **Hammer of Light** (3 Holy Power).
  GEMETEN. Dus de kaart heeft dit goed.
- **Lightsmith**: **één** knop die wisselt. GEMETEN, letterlijk: *"This ability rotates Holy Bulwark and
  Sacred Weapon. You start with 2 charges, and it takes 1 minute to recharge. It will start the cycle as
  Holy Bulwark."* Method noemt diezelfde knop "Holy Armaments".
- Hero-talenten vanaf **level 71**. GEMETEN, Icy Veins talents-pagina (21 sep 2026): *"Protection Paladin
  gets to pick between the Templar and Lightsmith Hero Talents from Level 71."*

### 3g. De knoppen uit je vraag, één voor één

| knop | bestaat voor Prot in 12.1? | markering |
|---|---|---|
| **Hammer of Wrath** | **NEE, geen losse knop meer.** Letterlijk: *"Hammer of Wrath is now a passive ability. While you have Avenging Wrath active Hammer of Wrath will replace Judgment"* | GEMETEN (IV spell-list 10 aug 2026) |
| **Word of Glory** | JA, en het staat in de rotatie-prioriteit (plek 13-14) én het is de 2e actieve mitigatie | GEMETEN |
| **Eye of Tyr** | **NEE, weg.** Staat nergens op de complete 12.1-spell-list. Positieve controle in dezelfde run: "Crusader Strike" vond ik wél op diezelfde pagina, dus de zoekactie werkt | GEMETEN (afwezigheid, mét positieve controle) |
| **Consecration** als eigen knop | JA, en hoger dan de kaart doet vermoeden: "if you are not standing in it" staat op plek 5, bóven Shield of the Righteous | GEMETEN |
| **Blessing-knoppen** (Protection / Spellwarding / Freedom / Sacrifice) | JA, alle vier | GEMETEN |
| **Rebuke** | JA, de interrupt | GEMETEN |
| **Hand of Reckoning** | JA, de taunt, 8 s cd, en de pull-knop in Icy Veins' eigen opener | GEMETEN |
| **Divine Steed** | JA | GEMETEN |
| **Hammer of the Righteous** | JA, talent-alternatief voor Blessed Hammer (vervangt Crusader Strike) | GEMETEN |
| **Divine Protection** | **NEE voor Prot.** Staat niet op de 12.1-spell-list (niet bij class tree, niet bij spec tree). Zelfde positieve controle als hierboven | GEMETEN (afwezigheid, mét positieve controle) |
| **Final Stand** | Is een **talent** dat een AoE-taunt aan Divine Shield hangt, geen eigen knop | GEMETEN |

---

## 4. Naast elkaar

| knop | kaart | Stay alive | Dispel | elders in MH | nergens in MH |
|---|---|---|---|---|---|
| Shield of the Righteous | ✅ | ✅ | | `TankToolkit.lua:74` | |
| Avenging Wrath | ✅ | | | `KeybindRoles_Paladin.lua:193` | |
| Divine Toll | ✅ | | | :113 | |
| Judgment | ✅ | | | :120 | |
| Blessed Hammer | ✅ | | | :123 | |
| Avenger's Shield | ✅ | | | :121 (`alsoStop="silence"`) | |
| Consecration | ✅ | | | :137 | |
| Sacred Weapon 432472 | ✅ | | | **nergens in de keybind-data** | |
| Hammer of Light | ✅ (platte tekst) | | | nergens | |
| Holy Bulwark | ✅ (platte tekst) | | | :172 | |
| Ardent Defender | | ✅ | | `TankToolkit.lua:102` | |
| Guardian of Ancient Kings | | ✅ | | `TankToolkit.lua:103` | |
| Sentinel | | ✅ | | `TankToolkit.lua:104` | |
| Divine Shield | | ✅ | | `TankToolkit.lua:106` | |
| Blessing of Protection | | ✅ | | :71 | |
| Blessing of Spellwarding | | ✅ | | `TankToolkit.lua:105` | |
| Word of Glory | ❌ | ✅ (alleen als heal) | | :86 | |
| Lay on Hands | | ✅ | | :88 | |
| Divine Steed | | ✅ | | :59 | |
| Rebuke | | ✅ | | :56 | |
| Cleanse Toxins / Cleanse | | | ✅ | `HealerCooldowns.lua:274-275` | |
| **Hand of Reckoning** | ❌ | ❌ | ❌ | alleen `:150` (keybind-data) | **ja, op alle 4 de tabs** |
| Hammer of Justice | ❌ | ❌ | ❌ | :78 (dispel_cc) | **ja, op alle 4 de tabs** |
| Hammer of the Righteous | ❌ | ❌ | ❌ | :122 | **ja, op alle 4 de tabs** |
| Blinding Light / Turn Evil / Freedom / Sacrifice | ❌ | ❌ | ❌ | :79-82 | **ja, op alle 4 de tabs** |
| Flash of Light | ❌ | ❌ | ❌ | alleen als Holy-click-cast (:103, `specs={65}`) | **ja, voor spec 66** |
| Devotion / Concentration / Crusader Aura | ❌ | ❌ | ❌ | alleen "heb je een aura op" (`MissingBuff.lua:357`, id 465) | **ja, als knop/keuze** |
| Redemption / Intercession | ❌ | ❌ | ❌ | :91-92 | **ja, op alle 4 de tabs** |

Alles in deze tabel is GEMETEN (gelezen in die bestanden, op die regels).

---

## 5. Oordeel

**De kaart is niet fout. Hij is bewust kort, en wat hij zegt klopt.** GEMETEN: alle 9 knoppen op de kaart
staan in de 12.1-prioriteitslijst van Icy Veins (21 sep) én Method (3 sep). De AoE-regel klopt zelfs
precies: in de AoE-lijst schuift Avenger's Shield naar direct ná Shield of the Righteous. De kaart noemt
géén enkele spell die in 12.1 niet meer bestaat of anders heet.

Maar Robs gevoel klopt óók. Er zijn drie echte gaten, van hard naar zacht:

### 🔴 1. Hand of Reckoning staat op geen enkele tab
Dit is de knop die een Prot Paladin **elke pull** indrukt. GEMETEN, Icy Veins' eigen opener: *"pull the
enemy with Hand of Reckoning"*. En GEMETEN bij Method: hij is verplicht naast Divine Shield en Blessing of
Protection, want die twee laten je aggro vallen. Hij zit in MH **alleen** als keybind-regel
(`KeybindRoles_Paladin.lua:150`, categorie `taunt`). De Role Academy heeft er één afvinkregel over,
`ACADEMY_PREF_TANK_TAUNT` = *"I know my taunt key (dummy test once)"* (`Locales\enUS.lua:1808`), maar die
noemt de spell niet en toont geen icoon. Zeg dit hard: dit is de knop die mist.
**Level/talent:** baseline, geen talent. In MH's eigen data op **level 9** (`KeybindingData.lua:354`).
Rob heeft hem dus zeker.

### 🟠 2. Word of Glory ontbreekt op de rotatie-tab
GEMETEN: Word of Glory staat twee keer in Icy Veins' prioriteitslijst (plek 13 en 14), is bij Icy Veins
één van de **twee** kopjes onder "Active Mitigation", en Method schrijft *"most of your healing will come
from Word of Glory"*. Op de kaart staat hij nergens; op "Stay alive" staat hij als heal-stap 1. Daardoor
leert de kaart hem niet dat de knop **gratis** is bij Shining Light — en dat is precies de reden om hem in
de rotatie te drukken in plaats van alleen als noodknop.
**Level/talent:** de knop is baseline, level 9 in MH's data (`KeybindingData.lua:362`). De gratis casts
komen van **Shining Light**, een spec-tree-talent (GEMETEN op de IV-spell-list). Dus: knop ja,
gratis-effect talent-afhankelijk.

### 🟡 3. Kleinere dingen die de kaart niet zegt
- **Hammer of the Righteous** wordt niet genoemd; de kaart noemt alleen Blessed Hammer. Het zijn
  alternatieven. GEMETEN. **Talent-afhankelijk.**
- **Avenger's Shield interrupt/silence**. De kaart zegt alleen "gooi hem als hij klaar staat". MH weet het
  wel (`alsoStop = "silence"`, :121). GEMETEN. **Baseline spec-knop.**
- **Consecration vóór de pull neerzetten**, en in de Lightsmith-lijst staat Consecration bóvenaan.
  De kaart zet hem onderaan stap 4. GEMETEN. **Baseline, level 6** (`KeybindingData.lua:353`).
- **Sentinel als vervanger van Avenging Wrath** staat niet op de kaart (wel op Stay alive). GEMETEN.
  **Talent.**
- **Hammer of Justice** (6 s stun) staat op geen enkele tab. GEMETEN. **Baseline, level 6.**
- De **Lightsmith-regel suggereert twee knoppen**. GEMETEN: het is één knop met 2 charges die om en om
  Holy Bulwark en Sacred Weapon geeft. Niet onwaar, wel misleidend. **Hero-talent, vanaf level 71.**

### Wat NIET mist, al lijkt het zo
**Hammer of Wrath.** GEMETEN: in 12.1 is hij passief en vervangt hij Judgment zolang Avenging Wrath loopt.
De kaart noemt Judgment — dat is dus de juiste knop, en de kaart is hier beter dan hij lijkt.

---

## 6. Robs level

Ik kan Robs level niet meten vanuit de code. AFGELEID uit zijn melding van 17 sep over zijn Ret: nog geen
90. Daarom per ontbrekende knop hierboven gezegd of hij level- of talent-afhankelijk is. Samengevat:
**Hand of Reckoning, Word of Glory, Hammer of Justice en Consecration heeft hij zeker** (baseline, level
6-9 volgens MH's eigen `KeybindingData.lua`). **Hammer of the Righteous, Shining Light en Sentinel zijn
talenten.** **Templar en Lightsmith beginnen op level 71** (GEMETEN, Icy Veins talents-pagina 21 sep 2026),
en vullen zich daarna één punt per level — dus onder 90 zijn die twee bullets maar deels waar voor hem.

Het venster vangt dat al deels op: onder max level komt er een blauwe regel "written for level 90" en
wordt wat hij nog niet kent grijs, maar **alleen op zijn eigen actieve spec** (GEMETEN
`Modules\PlayCardWindow.lua:290-300`).

---

## 7. Losse data-vondsten (niet de kaart, wel voor de bouwchat)

Alle vier GEMETEN:

1. **Sacred Weapon 432472 staat niet in `KeybindRoles_Paladin.lua`.** De kaart noemt hem
   (`Locales\enUS.lua:925`), maar de keybind-toewijzer kent hem niet, dus hij krijgt nooit een toets
   toegewezen. Holy Bulwark 432459 staat er wél (:172).
2. **`["Hammer of Wrath"] = { id = 24275, category = "spender", … specs = { 66, 70 } }`
   (`KeybindRoles_Paladin.lua:138`) is verouderd voor spec 66.** In 12.1 is hij passief voor Prot.
3. **`["Divine Protection"]` (:70) komt op Robs Stay-alive-tab als "small 1" terecht, maar Prot heeft die
   spell niet in 12.1.** Het `IsPlayerSpell`-filter zou hem moeten tegenhouden; AFGELEID dat Rob hem
   daarom niet ziet, maar de tag is er onnodig.
4. **`Modules\KeybindingData.lua` heeft geen `paladin_protection`-layout** — alleen `paladin_early` en
   `paladin_retribution` (:337, :365, en `specOrder` :418-423). De toetsenbord-referentie dekt Robs eigen
   spec dus niet.
