# ROLE_SWITCH_FACTS8 — SURVIVAL_STEP_BIG en HEALCORE_DESC_FAST (8 okt 2026)

## Samenvatting (5 regels)

1. **SURVIVAL_STEP_BIG botst met 4 rijen:** de zin *"(an immunity is also fine when you are about to die)"* staat op dezelfde regel als de Paladin-noot *"health al laag → Lay on Hands"* (Divine Shield), en botst met de Prot-noot bij Blessing of Protection.
2. **Twee rijen kloppen niet met de hele zin:** Guardian Spirit helpt volgens de client niet tegen massive damage (één gigantische klap), en Cold Snap beschermt zelf nergens tegen (het zet alleen cooldowns terug).
3. **Voorstel 1:** schrap het stuk tussen haakjes voor iedereen. Geef verder 2 rijen een eigen tekst via een nieuw veld `survivalWhen` (1 regel code in SurvivalPlan.lua).
4. **HEALCORE_DESC_FAST klopt niet voor iedereen:** de tag mengt 4 instant spells (Holy Shock, Word of Glory, Swiftmend, Verdant Embrace) met 5 casts van 1,5 s. Living Flame (2 s) is volgens de gids en MH's eigen speelkaart géén heal-knop.
5. **Voorstel 2:** splits de tag. `instant` voor die 4, `fast` (nieuwe tekst) voor Flash of Light, Regrowth, Vivify en Flash Heal, en `filler` voor Living Flame. Optioneel: Holy Word: Serenity (2050) toevoegen bij Holy Priest.

**Bronnen en grenzen**
- **Code:** gelezen op 8 okt 2026. Regelnummers zijn GEMETEN.
- **wago.tools DB2:** build **12.1.0.69933**. Dat is de live-branch `wow`, sinds 22 sep 2026 op wago (GEMETEN op wago.tools/builds). Gelezen op 8 okt 2026.
- **Icy Veins (IV):** 12.1-pagina's, met hun eigen "Last Updated"-datum per regel.
  - ⚠️ Zes van de tien gebruikte pagina's zijn van vóór 18 aug (start van S2).
- **`docs/` niet gelezen** (opdrachtregel). FACTS3 en FACTS7 heb ik dus niet zelf gelezen. Wat ik eruit noem, komt uit de opdrachttekst.
- ⚠️ Een Grep-voorbeeld liet per ongeluk een paar regels uit `docs/` zien (mijn glob-filter werkte niet). Die regels heb ik niet gebruikt.

---

## 1. SURVIVAL_STEP_BIG

**Waar staat hij (GEMETEN)**
- **Tekst:** `enUS.lua:1581` en `nlNL.lua:1531`. De andere 5 talen staan in `Translations2026.lua:2843/2877/2911/2945/2979`, allemaal mét de zin over immuniteit.
- **Koppeling:** `SurvivalPlan.lua:122` (TAGGED_PLAN). `SurvivalPlan.lua` heeft maar 582 regels; de "~769" uit de opdracht ligt dus ergens anders.
- **Waar stap en noot aan elkaar komen:** `PlayCardWindow.lua:735-739` en `RoleAcademy.lua:769-773`. Daar komt de noot tussen haakjes achter de stap: `L(s.whenKey) .. " (" .. L(s.noteKey) .. ")"`.

### 1a. Alle rijen met `survival = "big"` (29 stuks, 13 klassen)

- **Kolom "Wat het is":** komt uit `Spell.Description_lang` (wago 69933), dus GEMETEN.
- **Kolom "Soort":** mijn indeling op basis van die tekst, dus AFGELEID.
- **Positieve controle:** de grep op `"big"` vond ook `HealerCooldowns.lua:164` en `TankToolkit.lua:108`. Het patroon werkt dus.

| Klasse | Spell (id) | Wie ziet hem | Wat het is (DB2) | Soort | Noot op de rij |
|---|---|---|---|---|---|
| DK | Vampiric Blood (55233) | Blood | +max health, +healing ontvangen | verlager | — |
| DK | Icebound Fortitude (48792) | alle | DR + immuun voor stuns | verlager | — |
| DH | Metamorphosis (187827) | Vengeance | +health (heelt), +armor | verlager | — |
| Druid | Survival Instincts (61336) | Feral, Guardian | DR | verlager | — |
| Druid | Heart of the Wild (1261867) | Balance, Feral, Resto | in Bear Form: +max health | verlager | BEAR |
| Druid | Bear Form (5487, `{[spec]=big}`) | Balance, Feral, Resto | +armor, +stamina | verlager | BEAR_FORM |
| Evoker | Obsidian Scales (363916) | alle | DR | verlager | — |
| Evoker | Deep Breath (357210, `{[1467]=big}`) | alleen Devastation, met Stretch Time 410352 | tijdens het vliegen komt een deel van de schade later binnen | uitsteller | STRETCH_TIME |
| Hunter | Aspect of the Turtle (186265) | alle | "all spells and attacks miss" + DR, je kunt niet aanvallen | (bijna-)immuniteit | — |
| Mage | Ice Block (45438) | alle | immuun voor alle aanvallen en schade, 10 s. Daarna Hypothermia 30 s | **immuniteit**. Met het talent Ice Cold (414658) toont de rij Ice Cold, en dat is **alleen DR** | — |
| Mage | Cold Snap (235219) | Frost | "Resets the cooldown of" Ice Barrier, Frost Nova, (Cone of Cold), Ice Cold en Ice Block | **reset, geen bescherming** | — |
| Monk | Life Cocoon (116849) | Mistweaver | absorb-schild | absorb | SELF_CAST |
| Monk | Fortifying Brew (115203 → 120954) | alle | +health, DR (met 388917) | verlager | — |
| Paladin | Guardian of Ancient Kings (86659) | Prot | DR | verlager | — |
| Paladin | Blessing of Spellwarding (204018) | Prot | immuun voor magie. **Geeft Forbearance**. Deelt de cooldown met BoP | immuniteit (magie) | MAGIC |
| Paladin | Blessing of Protection (1022) | Holy, Prot, Ret | immuun voor fysieke schade. **Geeft Forbearance** | immuniteit (fysiek) | 65/70 PHYSICAL, 66 PHYSICAL_TANK |
| Paladin | Divine Shield (642) | Holy, Prot, Ret | immuun voor alle schade, 8 s. **Geeft Forbearance** (30 s). Met Final Stand (204077): taunt | **immuniteit** | 65/70 FORBEARANCE, 66 FORBEARANCE_TANK |
| Priest | Pain Suppression (33206) | Disc | DR (extern) | verlager | SELF_CAST |
| Priest | Guardian Spirit (47788) | Holy | +healing ontvangen. Ga je dood, dan zet hij je terug op een deel van je health. **"Cannot save the target from massive damage."** | **cheat-death** | SELF_CAST |
| Priest | Dispersion (47585) | Shadow | DR + heal. Je kunt niet aanvallen of casten | verlager | — |
| Rogue | Evasion (5277) | alle | +dodge | verlager (fysiek) | PHYSICAL |
| Rogue | Cloak of Shadows (31224) | alle | "a moment of magic immunity" | immuniteit (magie) | MAGIC |
| Shaman | Astral Shift (108271) | alle | DR | verlager | — |
| Shaman | Earth Elemental (198103) | Ele, Enh, Resto | pet die vijanden taunt. Met Primordial Bond (1279819): +max health, geen taunt | pet / verlager | — |
| Warlock | Unending Resolve (104773) | alle | DR + immuun voor interrupt | verlager | — |
| Warrior | Die by the Sword (118038) | Arms | +parry, DR | verlager | — |
| Warrior | Enraged Regeneration (184364) | Fury | DR + heal | verlager | STUNNED |
| Warrior | Shield Wall (871) | Prot | DR | verlager | — |
| Warrior | Rallying Cry (97462) | alle | groep: +max health | verlager (groep) | GROUP |

- **Hypothermia** (41425, DB2): *"cannot Ice Block or Ice Cold again"*, duur 30 s (DurationIndex 9). GEMETEN.
- **Forbearance** (25771, DB2): *"Cannot be affected by Divine Shield, Hand of Protection, or Lay on Hands"*, 30 s. Lay on Hands (633) geeft hem ook. GEMETEN.

### 1b. Botsingen

| # | Rij | Botsing | Status |
|---|---|---|---|
| 1 | Divine Shield (65/66/70) | De stap zegt *"an immunity is also fine when you are about to die"*. Direct daarachter zegt de noot (`enUS:1681/1682`): *"About to die? Careful: is your health already low, press Lay on Hands instead."* Dat staat op één regel. | GEMETEN (beide teksten en de koppeling) |
| 2 | Blessing of Protection (Prot, 66) | De stap nodigt uit tot BoP op jezelf als je bijna dood bent. De noot `SURVIVAL_NOTE_PHYSICAL_TANK` (`enUS:1584`) zegt: *"On yourself: only against one boss … Never with a pack"*. ⚠️ De opdracht noemt *"als tank alleen in nood"*, maar die tekst bestaat niet meer: `nlNL:1533` is nu de lange versie. | GEMETEN |
| 3 | BoP (Holy/Ret) en Spellwarding (Prot) | Allebei een immuniteit die Forbearance geeft (DB2). Ze blokkeren dus Lay on Hands, en daarmee geldt hetzelfde conflict als bij #1. Hun noten (`PHYSICAL`, `MAGIC`) noemen Forbearance niet. De Divine Shield-noot doet dat wel (*"nor does Blessing of Protection"*). | AFGELEID |
| 4 | Guardian Spirit (Holy Priest) | De stap zegt *"just before the hardest hit you see coming"*. Maar DB2 zegt *"Cannot save the target from massive damage"*, en MH's eigen `GROUP_NOTE_GUARDIAN_SPIRIT` (`enUS:1646`) zegt *"(not against one giant hit)"*. | Teksten GEMETEN; de botsing AFGELEID |
| 5 | Cold Snap (Frost) | De stap zegt "druk hem net vóór de klap". Cold Snap doet zelf niets tegen een klap (DB2: alleen een reset). Ice Block kan ook pas weer 30 s na de vorige (Hypothermia). | AFGELEID uit DB2-tekst |
| 6 | Hele addon | `HEALTOOLKIT_DEF_DESC` (`enUS:4087`) en `TANKKIT_CDDESC_IMMUNITY` (`enUS:4132`) zeggen: immuniteit = *"just before a hit you will not survive"*. Alleen SURVIVAL_STEP_BIG zegt nog "ook als je bijna dood bent". | GEMETEN |
| 7 | Earth Elemental (Shaman) | Zonder Primordial Bond is het een taunt-pet. Die vangt "de hardste klap" alleen op als de vijand hem aanvalt. Niet in een gids nagekeken. | AFGELEID, lage prio |
| 8 | `KeybindRoles_DeathKnight.lua:41` | Het commentaar zegt dat Lichborne als laatste onder "big" staat. De entry op r.74 is sinds 3 okt `survival = "small"`. Alleen commentaar, geen schermfout. | GEMETEN |
| 9 | `SURVIVAL_NOTE_CHEAT_DEATH` | Staat in 7 packs (`enUS:1696`), maar geen enkele entry gebruikt hem. Positieve controle: dezelfde grep vond `SURVIVAL_NOTE_LAST_RESORT` in `KeybindRoles_Paladin.lua:93`. De tekst *"saves you from one killing blow"* botst ook met de "massive damage"-uitzondering. Niet zo aanzetten. | GEMETEN |

**Gaat er iets verloren als de zin over immuniteit verdwijnt?**
- **IV Easy Modes (10 aug 2026):** BM noemt Turtle *"your immunity"*, Outlaw noemt Cloak *"your immunity"*. Frost noemt Ice Block *"a full immunity … except very special attacks that pierce immunities"*.
- **"Ook als je bijna dood bent":** dat zegt geen van die pagina's in wat ik las. Voor Hunter, Mage en Rogue is dat advies dus AFGELEID en niet uit een bron.
- **Conclusie:** schrappen kost geen bewezen advies.

### 1c. Voorstel

**A — tekst voor iedereen (lost #1, #2, #3 en #6 op):** het stuk tussen haakjes eruit.

| | Nu | Voorstel |
|---|---|---|
| EN | a big one: press it just before the hardest hit you see coming (an immunity is also fine when you are about to die) | **a big one: press it just before the hardest hit you see coming** |
| NL | een grote: druk hem net vóór de hardste klap die je ziet aankomen (een immuniteit mag ook als je bijna dood bent) | **een grote: druk hem net vóór de hardste klap die je ziet aankomen** |

- Dit klopt voor alle verlagers, absorbs en immuniteiten in de tabel (AFGELEID).
- Het zegt hetzelfde als HEALTOOLKIT_DEF_DESC en TANKKIT_CDDESC_IMMUNITY.
- Bear Form heeft geen cooldown. "Net vóór de klap" klopt daar nog steeds.
- Daarna: `check_drift`, en de 5 andere talen herschrijven via mh-writer.

**B — kleine code-oplossing voor de 2 rijen die één zin niet dekt (#4, #5).**
- Nieuw optioneel veld `survivalWhen` op een entry.
- In `SurvivalPlan.lua:458` wordt `whenKey = step.key` dan:
  ```lua
  whenKey = item.entry.survivalWhen or step.key,
  ```
- De rij blijft in de "big"-groep, op dezelfde volgorde. Alleen de tekst eronder wordt een andere.

| Rij | Data | EN | NL |
|---|---|---|---|
| Guardian Spirit (`KeybindRoles_Priest.lua:135`) | `survivalWhen = "SURVIVAL_WHEN_CHEAT_DEATH"` (noot SELF_CAST blijft) | when your health keeps dropping: if you would die, it saves you once. It does not lower damage and does not help against one giant hit | als je health blijft zakken: ga je dood, dan redt hij je één keer. Hij verlaagt de schade niet en helpt niet tegen één gigantische klap |
| Cold Snap (`KeybindRoles_Mage.lua:201`) | `survivalWhen = "SURVIVAL_WHEN_RESET"` | after your big one (Ice Block or Ice Cold): it makes it ready again. You can use it again 30 sec after the last one | na je grote (Ice Block of Ice Cold): hij maakt die weer klaar. Je kunt hem weer gebruiken 30 sec na de vorige |

- **Bronnen per regel:**
  - Guardian Spirit: DB2 47788 (*"If the target would die … Cannot save the target from massive damage"*). IV Holy Priest (25 aug 2026) noemt GS de knop om iemand *"in danger of death"* te redden.
  - Cold Snap: DB2 235219 (reset) en 41425 (Hypothermia, 30 s).
- **Zonder code kan het ook:**
  - Cold Snap van de kaart halen (`survival`-tag weg).
  - Guardian Spirit naar stap `heal` zetten. Dat leest minder goed: GS heelt niet direct.

**C — los te kiezen (AFGELEID, Rob kiest):**
- **BoP Holy/Ret en Spellwarding:** de noot Forbearance laten noemen, net als de tank-versie.
  - Er moeten nieuwe sleutels komen, want `SURVIVAL_NOTE_PHYSICAL` deelt de Rogue (Evasion) en `SURVIVAL_NOTE_MAGIC` delen de Rogue (Cloak) en de DK (Anti-Magic Shell).
  - EN: *"only against physical damage. Gives Forbearance: no Divine Shield or Lay on Hands on yourself for 30 sec"*
  - NL: *"alleen tegen fysieke schade. Geeft Forbearance: 30 s geen Divine Shield of Lay on Hands op jezelf"*
  - Voor Spellwarding hetzelfde, met "magic" / "magie".
- **Earth Elemental:** eerst een gids nakijken. Daarna eventueel `survivalRequires = 1279819`: dan staat hij alleen op de kaart met Primordial Bond.
- **DK-commentaar r.41:** bijwerken naar "small".

---

## 2. HEALCORE_DESC_FAST

**Waar staat hij (GEMETEN)**
- **Tekst:** `enUS.lua:4168` en `nlNL.lua:3666`. In de andere talen staat hij in `Translations2026.lua:6104/6512/6923/7341/7766`.
- **Tags:** `HealerCooldowns.lua:78-86` (TAG_DESC) en `159-209` (rijen).
- **Op het scherm:** `RoleAcademy.lua:584-590` maakt per rij `[Fast] <spell> — <desc>`, in de volgorde van de tabel.

### 2a. Per spell

- **Cast-tijd:** `SpellMisc.CastingTimeIndex` → `SpellCastTimes.Base` (wago 69933). Dit is de basiswaarde, vóór haste en talenten. GEMETEN.
- **Cooldown:** `SpellCategory.ChargeRecoveryTime`. GEMETEN, maar ook dit is de basis.
- **Gids-citaten:** komen van IV, met de datum van de pagina.

| Spec | Spell (id) | Cast 12.1 | CD / kosten | Reactieknop volgens de gids? (bron) | Nieuwe tag |
|---|---|---|---|---|---|
| Holy Pal | Holy Shock (20473) | **instant** | 6 s | ja, en de hoofdknop. *"Use Holy Shock as your primary healing spell"* (IV Easy Mode, 10 aug) | `instant` |
| Holy Pal | Flash of Light (19750) | **1,5 s** | geen | **nee, de opvuller.** *"Cast Flash of Light when you do not have 3 Holy Power and cannot Holy Shock"* (IV Easy, 10 aug). Met Infusion of Light: instant en sterker (IV rotatie, 10 aug) | `fast` |
| Holy Pal | Word of Glory (85673) | **instant** | 3 Holy Power (SpellPower type 9) | ja. *"simply cast the ability on any player in danger"* (IV rotatie, 10 aug, bij WoG/Eternal Flame) | `instant` |
| Resto Druid | Regrowth (8936) | **1,5 s** (Tree of Life: instant, DB2) | geen | ja. *"If the damage is sharp and instant, then Regrowth the target"* (IV rotatie, 10 aug) | `fast` |
| Resto Druid | Swiftmend (18562) | **instant** | 15 s | gebruik op cooldown. *"Cast Swiftmend on cooldown and follow it with Rejuvenation … or Regrowth if they are struggling"* (IV, 10 aug) | `instant` |
| Pres Evoker | Living Flame (361469) | **2,0 s** | geen | **nee.** *"cast Living Flame on enemies to generate Essence Bursts"*. IV noemt hem ook *"quite weak"* (IV rotatie, 13 aug). MH's eigen `PLAYCARD_1468_EASY/MISTAKE` (`enUS:1543/1550`): niet mee healen | `filler` |
| Pres Evoker | Verdant Embrace (360995) | **instant** | 24 s | ja. *"use Verdant Embrace for quick burst and single-target healing"* (IV, 13 aug). MH `PLAYCARD_1468_S5` zegt hetzelfde | `instant` |
| MW | Vivify (116670) | **1,5 s** | geen | ja. *"Vivify if someone is about to die"* (IV rotatie, 12 aug). Tijdens Soothing Mist: instant (IV) | `fast` |
| Disc | Flash Heal (2061) | **1,5 s** | geen | deels. Vooral voor de ramp/Atonement. Bij zware schade op één persoon noemt de gids Shadow Mend (IV, 17 aug). MH `PLAYCARD_256_S4`: *"Shadow Mend … or Flash Heal if you did not pick it"* | `fast` |
| Holy Priest | Flash Heal (2061) | **1,5 s** | geen | pas de tweede keus. *"Flash Heal in an emergency on an ally near death"*, maar als fout geldt: *"casting Flash Heal instead of Holy Word: Serenity"* (IV rotatie, 25 aug) | `fast` |

- **FACTS7** (niet zelf gelezen, volgens de opdracht): Flash of Light 1,5 s, laagste prio. Mijn meting klopt daarmee: 1,5 s volgens DB2, en IV noemt hem de opvuller.
- **Ontbreekt (AFGELEID):** Holy Word: Serenity (2050).
  - Instant, 60 s (DB2). Elke Flash Heal maakt de cooldown korter (DB2-tekst).
  - IV (25 aug) en MH's eigen `PLAYCARD_257_EASY/S2` noemen hem de eerste knop als iemand laag staat.
  - Hij staat niet in `HEALER_CORE_HEALS[257]`.
- **Al in MH:** `ACADEMY_HEAL_TRIAGE_BODY` (`enUS:2261`) maakt het onderscheid al: *"an instant one … or your fast heal"*. Splitsen laat de toolkit dus zeggen wat de Academy al zegt (GEMETEN).

### 2b. Voorstel: de tag splitsen (één zin kan dit niet dekken)

**Waarom niet één zin?** Eén zin voor alle 9 is ofwel onwaar voor Living Flame, ofwel zo vaag dat hij niets meer uitlegt. Instant (vier) en 1,5 s cast (vijf) vragen echt om ander gedrag: wel of niet stilstaan, en wat je eerst drukt.

**Code** (`HealerCooldowns.lua`):
- `TAG`, `TAG_DESC` en `TAG_COLOR` krijgen `instant` en `filler`.
- **instant:** 20473, 85673, 18562, 360995.
- **filler:** 361469.
- **fast blijft:** 19750, 8936, 116670, 2061 (twee keer).
- Optioneel: `{ id = 2050, tag = "instant" }` vóór Flash Heal in `[257]`.
- Optioneel: in `[65]` Word of Glory direct onder Holy Shock zetten. De volgorde in de tabel is de volgorde op het scherm.

**Teksten**

| Sleutel | EN | NL |
|---|---|---|
| `HEALCORE_TAG_INSTANT` (nieuw) | Instant | Instant |
| `HEALCORE_DESC_INSTANT` (nieuw) | Instant heal on one person: it lands right away. Someone drops fast? This one first. Use it often. | Instant heal op één persoon: hij landt meteen. Zakt iemand snel? Eerst deze. Gebruik hem vaak. |
| `HEALCORE_DESC_FAST` (nieuwe tekst) | Short cast on one person (1.5 sec): stand still while you cast. Someone still dropping and no instant heal ready? This one. | Korte cast op één persoon (1,5 sec): blijf stilstaan tijdens het casten. Zakt iemand nog en is er geen instant heal klaar? Dan deze. |
| `HEALCORE_TAG_FILLER` (nieuw) | Filler | Opvuller |
| `HEALCORE_DESC_FILLER` (nieuw) | Mostly for the enemy: cast it when nobody needs healing. As a heal it is weak. | Vooral voor de vijand: cast hem als niemand healing nodig heeft. Als heal is hij zwak. |

- **Het woord "Instant":** dat is het woord dat de client zelf in tooltips gebruikt (GlobalStrings `SPELL_CAST_TIME_INSTANT`, wago 69933, GEMETEN).
  - Per taal: deDE *Spontan*, frFR *Instantané*, esES *Instantáneo*, ptBR *Instantâneo*, itIT *Istantaneo*. Vertalers moeten dat woord gebruiken.
  - NL houdt "Instant", want er is geen Nederlandse client.
- **Optioneel:** `HEALCORE_TAG_FAST` hernoemen naar "Short cast" / "Korte cast". Een beginner leest "Fast" nu snel als "instant" (AFGELEID).
- **Bewust weggelaten:** "kost veel mana" bij Living Flame. De speelkaart zegt het, maar ik heb het niet kunnen meten. DB2 `SpellPower` geeft voor 361469 meerdere rijen, en het is niet duidelijk welke voor Preservation geldt.
- **Alternatief voor `filler`:** Living Flame uit `[1468]` halen. Nadeel: de beginner ziet de knop dan wel op zijn balk, maar zonder uitleg.

**Na de wijziging:** `check_drift` draaien. De 5 talen van `HEALCORE_DESC_FAST` (`Translations2026.lua`) en de 5 talen van `SURVIVAL_STEP_BIG` zeggen anders nog de oude tekst.

---

## Bronnen (allemaal gelezen op 8 okt 2026)

- **wago.tools DB2, build 12.1.0.69933 (branch `wow`):**
  - tabellen `Spell`, `SpellName`, `SpellMisc`, `SpellCastTimes`, `SpellDuration`, `SpellCategory`, `SpellPower`, `GlobalStrings`
  - adres: `https://wago.tools/db2/<Tabel>?build=12.1.0.69933&filter[<kolom>]=exact:<id>`
- **Icy Veins, met "Last Updated":**
  - Holy Paladin: rotatie en Easy Mode, 10 aug 2026
  - Resto Druid: rotatie, 10 aug
  - Preservation: rotatie, 13 aug
  - Mistweaver: rotatie, 12 aug
  - Discipline: rotatie, 17 aug
  - Holy Priest: rotatie, 25 aug
  - Easy Modes van BM Hunter, Frost Mage en Outlaw: 10 aug
  - Easy Mode van Ret Paladin: 25 aug
- **Method Holy Paladin "Midnight 12.1"** (via Exa, geen datum zichtbaar): Flash of Light alleen met Infusion of Light hoog in de lijst. Gebruikt als steun, niet als enige bron.
- **MH-code:** zie de bestand:regel-verwijzingen hierboven.
