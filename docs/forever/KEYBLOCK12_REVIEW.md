# Tweede controle "12 x 4" (keys12) — 24 nov 2026

Door: een tweede, onafhankelijke helper (alleen lezen, niets gewijzigd).
Gelezen: alleen `Modules/` — de negen `ForeverBlock_<Class>.lua`, `ForeverBlock.lua`, `KeyBlock.lua` (regels 40-129 en
888-980), `ForeverHowToPlay.lua`, `ForeverTalentNext.lua`, `ForeverTrainerData.lua`, `ForeverSpellIds.lua`.
Niets in `docs/` gelezen. Niets in de client gemeten. Geen gamedata/probe gebruikt (mocht niet voor deze opdracht).

- **GEMETEN** = gezien in het genoemde bestand op de genoemde regel (stand 24 nov 2026).
- **AFGELEID** = mijn redenering (bv. hoe vaak iets gedrukt wordt, of talent-drempels).
- Niet opnieuw gedaan (al automatisch gemeten): toegestane toetsen, namen bestaan, geen dubbele spell, macro <= 255, niets kwijt.

## Kort

| Klasse | Oordeel |
|---|---|
| Warrior | goed |
| Rogue | goed |
| Hunter | goed |
| Mage | 1 wijziging (twee toetsen ruilen) |
| Priest | 1 wijziging (`bang` op de wand) |
| Warlock | 1 wijziging (twee toetsen ruilen) |
| Druid | goed |
| Paladin | goed, met 1 aandachtspunt (Oath of Light op de Alt-balk) |
| Shaman | goed |

Daarnaast twee punten buiten de `keys12`-tabellen die voor een nieuwe speler zwaarder wegen (onderaan): de Alt-balk kan
vol raken zodat juist de armor-buffs eraf vallen, en "How you play" noemt in 12 x 4 nog de oude toetsen.

---

## Warrior — goed

**(a) Wijzigingen:** geen.

Nagelopen:
- Elke stance-spell staat in dezelfde stance als in het oude blok (GEMETEN `ForeverBlock_Warrior.lua:28-62` tegen `:70-107`).
  Nieuw is alleen `Z berserker = Berserker Rage`; die stond in het oude blok ook alleen in Berserker Stance (Shift-V, `:62`).
- `3 = { Mortal Strike, Bloodthirst, Shield Slam }`: drie talenten van level 40 in drie bomen; twee ervan kan niemand
  hebben (twee keer ~31 punten > 51, max 51 GEMETEN `ForeverHowToPlay.lua:63`; drempel 30 AFGELEID). Mortal Strike heeft
  bovendien de talent-poort in de motor (GEMETEN `ForeverBlock.lua:189-191`).
- E = Shield Bash / Pummel, R = Charge / Intercept, Z/X/C = Shield Block, Last Stand, Shield Wall/Retaliation: juiste taak.

Niet als wijziging geteld (smaak of eerst meten):
- Battle Shout staat op Ctrl-Q, terwijl hij stap 1 is in alle drie de volgordes (GEMETEN `ForeverHowToPlay.lua:500, 522, 544`).
  Hoe lang hij duurt staat niet in `Modules/`. Duurt hij kort, dan hoort hij dichterbij (bv. ruilen met Intimidating Shout
  op Shift-F). Eerst de duur meten.
- Slam op Ctrl-4: voor Arms wordt Slam pas een gewone knop na Improved Slam (GEMETEN `ForeverTalentNext.lua:207`;
  `ForeverHowToPlay.lua:539`). Arms is niet de standaardboom (Protection, GEMETEN `ForeverTalentNext.lua:39`). Laten.

**(b) Twijfel "Berserker Rage op Z": laten.**
Z heeft de taak "klein defensief" (GEMETEN `KeyBlock.lua:76`) en is in Berserker Stance verder leeg: Shield Block werkt alleen
in Defensive Stance (GEMETEN `ForeverBlock_Warrior.lua:36` en `:81`). De state klopt (zie boven). Wat Berserker Rage in
Forever precies doet staat niet in `Modules/`; dat het een verdediging is (beschermt tegen fear) is AFGELEID uit Classic.

---

## Rogue — goed

**(a) Wijzigingen:** geen.

Nagelopen:
- Stealth-toetsen gelijk aan het oude blok: 1, 2, F, V, en Shift-F = het oude Shift-Q (Sap/Gouge) (GEMETEN
  `ForeverBlock_Rogue.lua:29-52` tegen `:66-88`). De `baseGuard [nobonusbar:1]` geldt dus op dezelfde manier.
- `3 = { Mutilate, Hemorrhage }`: Mutilate is level 40 (GEMETEN `ForeverHowToPlay.lua:700`), Hemorrhage level 30 (`:742`).
  Samen = minstens 31 + 21 = 52 punten (drempels 30 en 20 AFGELEID) > 51 (`:63`): nooit allebei. Krap, maar goed.
- `Q = { Adrenaline Rush, Death Mark }`: allebei level 40 in twee bomen: nooit allebei.

**(b) Twijfel "toets 3 leeg voor Combat": laten.**
Elke kandidaat voor 3 wordt ook door een andere boom gebruikt, en zou daar in een lijst achter Mutilate/Hemorrhage
verdwijnen (precies de fout die we niet willen):
- Shank: in alle drie de volgordes (GEMETEN `ForeverHowToPlay.lua:706, 718, 727, 747`).
- Cold Blood: ook in de Combat-volgorde (GEMETEN `ForeverTalentNext.lua:334`).
- Slice and Dice, Rupture: elke boom (`:707, 728, 749`).
- Riposte (Combat, level 20, `:732`) of Blade Flurry (Combat, 30, `:733`): haalbaar voor een Assassination- of
  Subtlety-mix (AFGELEID uit de drempels).
De knoppen van Combat staan al dichtbij: 1, 4, Shift-4, Shift-3, Shift-Z (Riposte), Shift-1, Q.
Bekende prijs (geen fout): toets 3 is voor élke Rogue leeg tot level 30 (AFGELEID uit `:742` en `:700`).

---

## Hunter — goed

**(a) Wijzigingen:** geen.

Nagelopen:
- `SHIFT-4 = { Sniper Shot, Bestial Wrath }`: Bestial Wrath vraagt 30 punten in Beast Mastery ervoor (GEMETEN
  `ForeverHowToPlay.lua:782`), Sniper Shot is een level-40 talent in Marksmanship (`:806`; drempel 30 AFGELEID). Samen > 51: nooit allebei.
- `SHIFT-2 = { Explosive Trap, Immolation Trap }`: bewust; vanaf 34 heeft Immolation Trap geen toets (GEMETEN `:820`),
  en alle vallen delen één cooldown van 30 s (`:193`).
- Z/X/C = Disengage, Feign Death, Deterrence; V = Freezing Trap; R = Aspect of the Cheetah: juiste taak.
- Summon Hawk op Shift-3 direct onder Arcane Shot (3): ze delen één cooldown (GEMETEN `:775, 787`). Logisch.

**(b) Twijfel "E = Scatter Shot óf Intimidation in één lijst": laten.**
Allebei zijn level-30 talenten, in twee bomen (GEMETEN `ForeverHowToPlay.lua:781` en `:805`). Allebei hebben vraagt
minstens 21 punten in Beast Mastery én 21 in Marksmanship (drempel 20 AFGELEID) = 42 <= 51: dat kán in een eigen build.
Niet in de gidsbuild: Beast Mastery 31/20/0 neemt in Marksmanship geen Scatter Shot (GEMETEN `ForeverTalentNext.lua:276-301`),
en Marksmanship-daarna-Beast-Mastery komt op 31 + 20 (`ForeverHowToPlay.lua:807`), één punt te weinig (AFGELEID).
Gevolg in die zeldzame build: Intimidation krijgt helemaal geen toets (ook niet op Alt, want hij staat in `keys12`;
GEMETEN `ForeverBlock.lua:88, 94-95`). Klein risico, en beide spells doen op E hetzelfde werk (een cast stoppen). Laten.

---

## Mage — 1 wijziging (twee toetsen ruilen)

**(a) Wijzigingen:**
- `4: van Pyroblast naar Fire Blast` — Pyroblast is een Fire-talent, op zijn vroegst level 20 (GEMETEN
  `ForeverHowToPlay.lua:165, 588`). Frost is de standaardboom van MH (GEMETEN `ForeverTalentNext.lua:39`, MAGE = 3) en de
  eerste keus van bijna elke gids (GEMETEN `ForeverHowToPlay.lua:610`; `ForeverTalentNext.lua:400`). Dus toets 4 blijft
  leeg voor Frost en Arcane, en voor élke Mage tot level 20 (AFGELEID). Fire Blast heeft iedere Mage vanaf level 6
  (GEMETEN `:153`) en hij staat in alle drie de volgordes (`:573, 592, 617`).
- `SHIFT-3: van Fire Blast naar Pyroblast` — de plek die vrijkomt; Fire heeft Pyroblast dan één modifier weg.
  Prijs: Fire drukt Pyroblast vaak (opener en Heating Up, GEMETEN `:590, 593`); Fire is niet de standaardboom.
  AFGELEID dat de winst groter is dan de prijs.
- `why`-teksten mee: 4 "instant fire hit, 8 s cooldown, shared with Ice Lance (F)" (`:153, 628`);
  Shift-3 "Fire: opener and Heating Up spender".

Afgewezen alternatief: `F = { Ice Lance, Fire Blast }` (ze delen één cooldown, GEMETEN `:628`). Dat is een lijst met twee
spells die een Frost Mage allebei heeft, en Frost gebruikt Fire Blast nog als afmaker (`:617`).

Bekende prijs, laten: Arcane Blast (Ctrl-2) en Arcane Wrath (Ctrl-4) zijn de Arcane-rotatie op de Ctrl-balk
(GEMETEN `:569, 571`). Weinig gidsen raden Arcane aan (`:566`), en elke andere plek vraagt een lijst met spells die je
allebei kunt hebben. Laten.

**(b) Twijfels:** geen genoemd.

---

## Priest — 1 wijziging

**(a) Wijzigingen:**
- `4: Shoot zonder bang → Shoot met bang = true` (zoals de Mage op CTRL-3) — de wand is de kern van het levelen
  (GEMETEN `ForeverHowToPlay.lua:676, 683`). De motor zet met `bang` een "!" voor de naam, zodat een tweede druk de wand
  niet stopt (GEMETEN `ForeverBlock.lua:398-405`). De Mage doet dat voor dezelfde wand al (GEMETEN `ForeverBlock_Mage.lua:31-33`
  en `:105`); de Priest niet (`ForeverBlock_Priest.lua:67`; het oude blok op 5 ook niet, `:27`). Een beginner die 4
  twee keer drukt, zet nu zijn wand uit. AFGELEID dat een gewone `/cast Shoot` de wand uitzet (Classic-gedrag; in Forever
  niet gemeten, net zo onzeker als bij Mage en Hunter).

**(b) Twijfel "Flash Heal op Shift-C, niet zonder modifier": laten.**
C blijft de heal die je het vaakst drukt: Discipline "Flash Heal when C is too slow" (GEMETEN `ForeverHowToPlay.lua:639`),
Holy "when C would come too late" (`:660`) en "Flash Heal for everything ... keep it for emergencies" (`:673`).
Shift-C zit direct bij C, en het is dezelfde plek als de snelle heal van de andere drie healers (GEMETEN Paladin
`ForeverBlock_Paladin.lua:87`, Druid `ForeverBlock_Druid.lua:92`, Shaman `ForeverBlock_Shaman.lua:89`): regel 3.

---

## Warlock — 1 wijziging (twee toetsen ruilen)

**(a) Wijzigingen:**
- `3: van Immolate naar Bane of Agony` en
- `SHIFT-2: van Bane of Agony naar Immolate` — Affliction is de standaardboom van MH (GEMETEN `ForeverTalentNext.lua:39`,
  WARLOCK = 1) en van de meeste gidsen (`ForeverHowToPlay.lua:910`; `ForeverTalentNext.lua:432`). Daar is Bane of Agony
  stap 2 van elk gevecht ("to pull", GEMETEN `:913`) en Immolate "only on a tough enemy" (`:916`). Demonology gebruikt
  Agony en Corruption, geen Immolate (`:941`). Alleen Destruction opent met Immolate (`:962`) en zet Agony alleen op een
  taaie vijand (`:963`). Hoe vaak = AFGELEID uit die volgordes.
  Bijkomend: kolom 3 wordt bane (3) boven curse (Shift-3); één bane en één curse passen op dezelfde vijand (GEMETEN `:365`).
  Prijs: level 1-7 is toets 3 leeg (Agony komt op 8, `:381`) terwijl Immolate (level 1, `:376`) op Shift-2 staat; Destruction
  speelt Immolate van de Shift-balk. `why`-teksten mee.

**(b) Twijfel "E leeg": laten.**
De Warlock heeft geen eigen interrupt (GEMETEN `ForeverHowToPlay.lua:399`); Spell Lock is een spell van de Felhunter, op
Blizzards pet-balk (`:373`). Een `cmd` met `/cast Spell Lock` is gewone macrotekst (GEMETEN `ForeverBlock.lua:390-397`):
de motor vertaalt die naam niet naar de taal van de client, dus op deDE/frFR/... werkt hij niet (zie `:120-125`).
Of `/cast` in Forever een pet-spell bereikt, is niet gemeten. Een lege E is eerlijk, en "How you play" zegt het al (`:399`).

---

## Druid — goed

**(a) Wijzigingen:** geen.

Nagelopen (de nieuwe vorm-combinaties):
- F (Growl / Cower / Rejuvenation), C (Frenzied Regeneration als beer / Healing Touch), Shift-4 (Ferocious Bite / Swiftmend),
  Shift-Q (Challenging Roar / poison), Shift-R (Prowl / Soothe Animal): elke basis-spell is een caster-spell en krijgt
  `[nobonusbar:1/2/3]`, omdat er een vorm-spell op dezelfde toets staat (GEMETEN `ForeverBlock.lua:428-441`,
  `ForeverBlock_Druid.lua:26-30`). Klopt.
- X = Nature's Grasp zonder vorm-spell, dus zonder guard: werkt nu ook als beer en kat. "How you play" zegt dat dat mag
  (GEMETEN `ForeverHowToPlay.lua:105`). Verbetering.
- Moonkin bladert de balk niet om (GEMETEN `ForeverBlock_Druid.lua:10-12`), dus F en C proberen in Moonkin een heal die daar
  niet werkt (`ForeverHowToPlay.lua:104`). Dat deden de oude C en F4 ook: niet nieuw.
- Tekst om na te kijken (niet in `Modules/` te controleren): `why` van Shift-4 "Swiftmend eats your HoT" en van X "roots
  what hits you". `:480` zegt alleen "only on someone who has your Rejuvenation or Regrowth". AFGELEID uit Classic.

**(b) Twijfel "E leeg als caster (Regrowth op E?)": laten.**
E heeft de taak interrupt (GEMETEN `KeyBlock.lua:74`). Een caster-Druid heeft er geen; Feral Charge werkt alleen als beer
en kat (GEMETEN `ForeverHowToPlay.lua:429`). Met Regrowth op E start iemand die als caster een cast wil stoppen een heal
van 2 seconden. Regrowth staat al op Shift-C, net als de snelle heal van de andere healers, en de caster heeft nu
Rejuvenation op F (zonder modifier).

---

## Paladin — goed (1 aandachtspunt)

**(a) Wijzigingen in keys12:** geen voor de twijfel. **Aandachtspunt (Alt-balk):**
Oath of Light (Holy-talent 25, stap 1 van de Holy-volgorde, GEMETEN `ForeverHowToPlay.lua:987`; oud Shift-R,
`ForeverBlock_Paladin.lua:37`) en Hammer of the Righteous (oud Shift-2, `:29`) hebben geen plek in `keys12` en gaan naar Alt.
De Alt-balk was in het oude blok op 60 al vol ("13 for 12", GEMETEN `ForeverBlock_Paladin.lua:7-8`; de trainer geeft er
tot 60 tien, `ForeverTrainerData.lua:527-667`). De restjes komen achteraan (GEMETEN `ForeverBlock.lua:89-99`) en de
plaatsing stopt bij de 12e plek (GEMETEN `KeyBlock.lua:966-969`). Dus bij een Holy Paladin op 60 is Oath of Light de
eerste die "no free place left on D" krijgt (telling AFGELEID). Oplossing: zie "Alt-balk" onderaan.
Open vraag: waar komt Hammer of the Righteous in Forever vandaan? Hij staat niet in `ForeverTrainerData` of
`ForeverTalentNext`, alleen in `ForeverSpellIds.lua:221` (id 407632). Onbekend.

**(b) Twijfel "C = Holy Light en Divine Shield op Z (of andersom)": laten zoals het is.**
- Divine Shield en Divine Protection delen één cooldown en staan in één lijst op Z (GEMETEN `ForeverHowToPlay.lua:142`;
  `ForeverBlock_Paladin.lua:73`): de noodknop staat zonder modifier (regel 2).
- C is bij alle vier de healers de hoofd-heal, met de snelle heal op Shift-C (regel 3). Holy Light is tot level 20 de enige
  heal (GEMETEN `:120`; Flash of Light komt op 20, `:135`), dus C moet hem hebben.
- Volgens het label hoort de grootste verdediging op C (Z = klein, C = groot; GEMETEN `KeyBlock.lua:76-77`), maar
  "andersom" zet de heal op Z en breekt het healer-patroon. Laten.
- Wel weten: voor een Holy Paladin is Flash of Light de gewone heal (GEMETEN `:988, 1004`), en die zit op Shift-C. Een lijst
  `{ Flash of Light, Holy Light }` op C zou Holy Light afpakken van Retribution, die hem tussen gevechten gebruikt (`:1044`). Laten.

---

## Shaman — goed

**(a) Wijzigingen:** geen.

Nagelopen:
- `Q = { Lightning Mastery, Rage of the Farseer }`: allebei level 40 in twee bomen: nooit allebei.
- `SHIFT-Z = { Water Shield, Lightning Shield }`: maar één shield tegelijk (GEMETEN `ForeverHowToPlay.lua:340, 360`). Bewust.
- Healing Stream Totem gaat naar Alt; vanaf 20 zet de totembalk hem neer (GEMETEN `:329, 887`). Goed.
- E = Earth Shock, R = Ghost Wolf, Z/X = Stoneskin/Grounding, V = Earthbind, Shift-V = Frost Shock (vertraagt): juiste taak.

**(b) Twijfel "dispels op de Ctrl-balk": laten.**
Een Shaman haalt alleen poison en disease weg (GEMETEN `ForeverHowToPlay.lua:885, 905`), en de Restoration-volgorde heeft er
geen stap voor (`:888-894`). Ctrl-E = disease is dezelfde toets als bij de Priest (GEMETEN `ForeverBlock_Priest.lua:96`) en
de tweede dispel van de Druid (`ForeverBlock_Druid.lua:98`): consequent. De Shift-plekken houden wat vaker gaat: Chain Heal,
Lesser Healing Wave, Riptide, Nature's Swiftness, Mana Tide Totem.

---

## Buiten keys12, wel echte foutkansen

### 1. Alt-balk loopt vol, en dan vallen juist de armor-buffs eraf (motor, AFGELEID op 60)
- De motor maakt van elke naam in een oude lijst een eigen Alt-kandidaat (GEMETEN `ForeverBlock.lua:45-56` en `:94-99`).
  Zo krijgen Ice Armor én Frost Armor, Arcane Intellect én Arcane Brilliance (Mage), Demon Armor én Demon Skin (Warlock),
  Power Word: Fortitude én Prayer of Fortitude (Priest) elk een eigen Alt-plek, waar het oude blok er één toets voor had.
- Die restjes komen ná `toBlockD` (GEMETEN `ForeverBlock.lua:89-99`); de Alt-plaatsing stopt bij plek 12
  (GEMETEN `KeyBlock.lua:959-969`), en eigen knoppen van de speler op Alt tellen ook mee (`KeyBlock.lua:888-891`).
- Telling op level 60, één racial (AFGELEID uit `ForeverTrainerData.lua` en de talentvolgordes):
  - Mage: ~10 oude Alt-spells (trainer `:347-505`; ook de opmerking "about 10 remain", `ForeverBlock_Mage.lua:58-59`)
    + Arcane Intellect, Ice Armor, Frost Armor = 13, met Arcane Brilliance 14. Bij 14 krijgen Ice Armor en Frost Armor geen plek.
  - Warlock Destruction: Conflagrate, Incinerate, Bane of Havoc, 4 summons, Create Healthstone, Searing Pain, Curse of
    Recklessness, racial = 11 (trainer `:1163-1291`) + Unending Breath, Demon Armor, Demon Skin = 14. Demon Armor en Demon Skin vallen eraf.
  - Holy Paladin: zie Paladin hierboven (Oath of Light).
- Advies voor de makers: (a) neem uit een oude lijst alleen de naam die het karakter het eerst kent (zoals `First()`,
  `ForeverBlock.lua:288-305`); (b) zet de restjes vóór `toBlockD`: ze stonden op het hoofdblok, `toBlockD` was al "eigen balk".
  Op 60 te zien met `/mh block` + `ns.db.keyBlockLeftoverProbe` (GEMETEN `KeyBlock.lua:895-898`). Niet in het spel gemeten.

### 2. "How you play" noemt in 12 x 4 de oude toetsen
`ForeverHowToPlay.lua` kent 12 x 4 niet: geen `12x4` of `keys12` in dat bestand (GEMETEN met Grep; dezelfde zoekactie vond
ze wel in `ForeverBlock*.lua`, dus het patroon werkt). Het bestand zegt zelf "change a table, change its line here too"
(`:14-15`). Voorbeelden die in 12 x 4 niet kloppen: vaste toetsen "T / Shift-T / G" (`:33`) tegen Ctrl-Z / Ctrl-C / Ctrl-V
(`KeyBlock.lua:91-95`); "5 = Fire Blast" (`:153`), "5 = Raptor Strike" (`:176`), "5 = Bane of Agony" (`:381`) terwijl
12 x 4 geen 5 heeft; "Flash Heal on F2" (`:311`). Voor iemand die de klasse nooit speelde is dit het eerste dat misgaat.
