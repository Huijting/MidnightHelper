# Richtingen per class: WoW: Forever (12 nov 2026)

Onderzoek voor een ontwerp. Rob, 12 nov 2026: *"Ja, alle classes"*. Hier staat geen code in, alleen feiten.
Gemaakt door mh-research. Forever-build **1.60.1.70888** (wago `wowf`, 10 nov 2026).

**Hoe je dit leest.** Elke regel eindigt met **[GEMETEN: bron]** of **[AFGELEID]**.
- GEMETEN = ik heb het gezien in een bron met een naam en een datum (bronnenlijst onderaan).
- AFGELEID = ik heb het zelf beredeneerd uit gemeten feiten. Dat is dus geen bewijs.
- "Nodig" en de respec-prijs zijn deels serverfeiten of gidskennis. Blizzards eigen tabellen zeggen daar weinig over.

---

## 1. In één oogopslag

| class | richting (naam in de client) | in één zin |
|---|---|---|
| Warrior | Arms | Hard slaan met één groot wapen in twee handen. |
| Warrior | Fury | Snel en wild slaan met een wapen in elke hand. |
| Warrior | Protection | Met een schild de klappen opvangen, zodat de vijand jou aanvalt en niet je groep (tank). |
| Paladin | Holy | Anderen genezen met heilig licht (healer). |
| Paladin | Protection | Klappen opvangen met schild en zware wapenrusting, geholpen door heilige magie (tank). |
| Paladin | Retribution | Hard slaan met een groot wapen, met heilige magie erbovenop. |
| Hunter | Beast Mastery | Je dier doet het meeste werk, jij schiet mee. |
| Hunter | Marksmanship | Jij bent de scherpschutter: harde, precieze schoten van ver. |
| Hunter | Survival | Een mix van schieten, vallen zetten en dichtbij vechten. |
| Rogue | Assassination | Gif en twee dolken: je schade loopt gestaag door. |
| Rogue | Combat | Recht op de vijand af en snel blijven slaan met je wapens. |
| Rogue | Subtlety | Onzichtbaar besluipen en toeslaan vanuit de schaduw. |
| Priest | Discipline | Beschermen met schilden die schade opvangen, en daarnaast genezen (healer). |
| Priest | Holy | Echt genezen, met veel verschillende heal-spells (healer). |
| Priest | Shadow | Schaduwmagie die de vijand langzaam pijn doet, van een afstand. |
| Shaman | Elemental | Bliksem en vuur van een afstand. |
| Shaman | Enhancement | Van dichtbij slaan met een groot wapen, sterker gemaakt door de elementen. |
| Shaman | Restoration | Genezen met natuurmagie, geholpen door totems (healer). |
| Mage | Arcane | Pure magie die in korte tijd veel schade doet, maar veel mana kost. |
| Mage | Fire | Vuur dat vaak extra hard raakt. |
| Mage | Frost | IJs dat schade doet en vijanden vertraagt of vastzet. |
| Warlock | Affliction | Vloeken en langzame schade: de vijand smelt weg. |
| Warlock | Demonology | Je demon wordt sterker en vecht als je beste wapen mee. |
| Warlock | Destruction | Directe, harde vuur- en schaduwspells. |
| Druid | Balance | Van een afstand toveren met maan- en natuurmagie. |
| Druid | Feral Combat | Als kat schade doen, of als beer klappen opvangen (tank). |
| Druid | Restoration | Genezen, vooral met heals die een tijdje doorwerken (healer). |

- De **namen** zijn de namen uit de client. [GEMETEN: DB2 `TalentTab` 1.60.1.70888, 27 rijen, 3 per class]
- De **rol** per richting (tank, healer, schade) komt uit Warcraft Tavern en Blizzards deep dives. [GEMETEN: WT; BLZ-HD; BLZ-PW]
- De **zinnen** zelf zijn mijn eigen samenvatting voor een beginner. [AFGELEID]

---

## 2. Woordjes

- **Richting** = een **talentboom**. Elke class heeft er drie. In de bomen zet je **talentpunten**. Waar je de meeste punten zet, dat is je richting.
- **Tank** = degene die de klappen opvangt, zodat de vijand niet de rest van de groep slaat.
- **Healer** = degene die de groep geneest.
- **Schade doen** (Engels: DPS) = de vijand zo snel mogelijk doodmaken.
- **Respec** = je talentpunten terugnemen en opnieuw verdelen.
- **Dual Spec** = twee sets talenten bewaren en wisselen, zonder elke keer te betalen.
- **Pantser**: Cloth (stof, het lichtst) < Leather (leer) < Mail (maliën) < Plate (platen, het zwaarst). Zwaarder = minder schade krijgen.
- **Stats** (cijfers op je spullen):
  - **Strength** = kracht: harder slaan (voor veel classes).
  - **Agility** = behendigheid: bij Hunter en Rogue harder slaan of schieten, en vaker kritiek raken.
  - **Stamina** = meer levenspunten.
  - **Intellect** = meer mana, en spells raken vaker kritiek.
  - **Spirit** = je mana komt sneller terug.
  - **Spell Power** = je spells doen meer schade. **Healing Power** = je heals genezen meer.
  - **Hit** = je mist minder vaak. **Expertise** = de vijand ontwijkt je minder vaak.
  - **Crit** (Critical Strike) = kans op een extra harde klap of heal.
  - **Defense** en **Armor** = minder schade krijgen (vooral voor tanks).
  - **Weapon DPS** = hoeveel schade je wapen zelf doet.
- **Offhand** = iets in je tweede hand dat geen wapen is (een boek, een bol). **Wand** = toverstokje dat vanzelf schiet.

---

## 3. Wat voor ALLE classes hetzelfde is (één keer gemeten)

### 3a. Welke classes Forever heeft
- Forever heeft **negen** classes: Warrior, Paladin, Hunter, Rogue, Priest, Shaman, Mage, Warlock en Druid. [GEMETEN: DB2 `ChrClasses` 1.60.1.70888: precies 9 rijen, ID 1, 2, 3, 4, 5, 7, 8, 9, 11]
- Er is dus geen Death Knight, Monk, Demon Hunter of Evoker. [GEMETEN: dezelfde tabel; de ID's 6, 10, 12 en 13 ontbreken]
- Het addon gebruikt dezelfde negen. [GEMETEN: `Modules/ForeverHowToPlay.lua:36-363`; `Modules/ForeverWeapons.lua:27-28`]

### 3b. Een richting kies je met talentpunten, niet met een knop
- Forever heeft per class maar **één** "specialization", met de naam van de class zelf. Er is dus geen spec-knop zoals in retail. [GEMETEN: DB2 `ChrSpecialization` 1.60.1.70888: 9 rijen, ID 1482-1491, naam = classnaam]
- De richting zit dus helemaal in de drie talentbomen. [AFGELEID uit de twee regels hierboven]
- Het addon raadt je richting al: het telt je punten per boom. [GEMETEN: `Modules/ForeverMacros.lua:663-714`]

### 3c. Eerste talentpunt en aantal punten
- Je eerste talentpunt krijg je op **level 10**. Daarna krijg je **1 punt per level**, tot en met level 60. Dat zijn **51 punten**. [GEMETEN: DB2 `TraitCurrencySource`, currency 3820: rijen "Level 10" t/m "Level 60", elk Amount 1]
- Blizzard zegt ook: talenten openen op level 10. [GEMETEN: BLZ-HD en BLZ-PW, 30 sep 2026, beta-info]
- Alle negen class-bomen gebruiken diezelfde punten. [GEMETEN: DB2 `TraitTreeXTraitCurrency`: bomen 1082, 1089, 1091, 1100, 1111, 1112, 1114, 1116, 1117 → currency 3820]
- Een boom heeft rijen. Een nieuwe rij gaat open na **5, 10, 15, 20, 25 en 30** punten. [GEMETEN: DB2 `TraitCond`, boom 1117 (Warrior): 18 voorwaarden, 6 per boom, SpentAmountRequired 5 t/m 30]
- Dat die drempels per boom tellen (en niet over alle bomen samen) is de oude Classic-regel. [AFGELEID; Blizzard noemt het "de bekende structuur", BLZ-HD]

### 3d. Wanneer merk je het verschil?
- Level 10-19: je eerste punten geven vooral kleine bonussen. Je merkt weinig. [AFGELEID]
- Blizzard noemt vaste mijlpalen: een talent na **11, 16, 21 en 31 punten** in een boom. [GEMETEN: BLZ-HD, BLZ-PW]
- Met 1 punt per level vanaf 10 betekent dat: het 11-punts-talent op zijn vroegst op **level 20**, het 16-punts op **25**, het 21-punts op **30**, het 31-punts op **40**. [AFGELEID uit 3c]
- Vanaf **level 20** voelt een richting dus echt anders. Op **40** heb je het grote eindtalent van je boom. [AFGELEID]
- Dezelfde levels (20 / 25 / 30 / 40 "op zijn vroegst") staan al in de addon-teksten. [GEMETEN: `Modules/ForeverHowToPlay.lua:123, 187, 228, 271, 311, 354`; `Modules/ForeverMacros.lua:380-381`]

### 3e. Sneller talenten met een Legacy-perk ("Talented")
- Forever heeft een **Legacy Tree**: voordelen voor je hele account, betaald met **Legacy Points**. [GEMETEN: GlobalStrings `LEGACY_TREE_FRAME_TITLE`, `LEGACY_POINTS_CURR_MAX` in 1.60.1.70888; `LEGACY_TREE_FRAME_TITLE` staat niet in retail 12.1.5.70783 (de andere niet nagekeken)]
- Die punten verdien je met **Legacy Challenges**, bijvoorbeeld "voor het eerst level 25/45/60 met een Warrior", een beroep op 150/225/300, of dungeons. [GEMETEN: DB2 `TraitCurrencySource`, currency 4225]
- Er is een seizoensplafond voor hoeveel Legacy Points je mag uitgeven. [GEMETEN: GlobalStrings `LEGACY_POINTS_SEASONAL_CAP`]
- De perk **Talented** laat je talentpunten al vanaf **level 5** krijgen in plaats van 10. Je krijgt er niet meer van: het blijft maximaal **51**. [GEMETEN: Wowhead Forever-tooltip spell 1225474, 12 nov 2026]
- De perk heeft 5 rangen: rang 1 geeft een punt op level 9, rang 5 op level 5. [GEMETEN: DB2 `TraitCurrencySource` "Talented Rank 1 (Level 9)" t/m "Rank 5 (Level 5)"; node 110298 in boom 1188]
- Met alle 5 rangen komt alles uit 3d dus **5 levels eerder** (eindtalent op 35). [AFGELEID]
- Je kunt Talented pas weghalen als je eerst je class-talenten leeghaalt. [GEMETEN: GlobalStrings `ERR_LEGACY_WIPE_ERROR_CLASS_POINTS`]

### 3f. Opnieuw kiezen (respec): wat kost het?
- Je verandert je talenten (ook Legacy-talenten) bij je **class trainer in een hoofdstad**. [GEMETEN: BLZ-HD, BLZ-PW, 30 sep 2026]
- De client heeft aparte vragen voor "class-talenten weghalen" en "legacy-perks weghalen". [GEMETEN: GlobalStrings `CONFIRM_TALENT_WIPE` en `CONFIRM_TALENT_WIPE_5`]
- In de **beta** kostte een respec 1 silver, en Blizzard zei dat dat alleen voor de beta was. [GEMETEN, maar via anderen: Blizzards beta-notities van 24 sep en 26 okt, geciteerd door Mobalytics, PC Gamer en Icy Veins]
- Na de start (4 nov) melden spelers: **eerste respec 1 gold, tweede 5 gold**. [GEMETEN, zwak: TS 8 nov 2026, op basis van Reddit; DTG 5 nov 2026 noemt ook 1 gold, zonder bron]
- Blizzard zou tegen TechRadar gezegd hebben: de prijs stijgt snel en zakt maar **één keer per week**. [GEMETEN, zwak: alleen via TS; het TechRadar-stuk zelf heb ik niet gevonden]
- Wowhead zegt alleen dat een respec "steeds meer gold" kost. [GEMETEN: WH-DS, 11 nov 2026]
- Een plafond van 50 gold wordt genoemd, maar dat is de Classic Era-regel. Voor Forever heb ik dat niet bevestigd gezien. [AFGELEID / niet gemeten]
- **Conclusie:** de echte prijs staat in het bevestigvenster bij de trainer. Geen enkele bron hier is een Blizzard-prijstabel. [AFGELEID]

### 3g. Dual Spec
- Dual Spec komt op **level 40**. [GEMETEN: BLZ-HD, BLZ-PW, 30 sep 2026 (beta-info); WH-DS, 11 nov 2026]
- Je koopt het bij je **class trainer**, voor **50 gold**. [GEMETEN: WH-DS, Squishei, 11 nov 2026. Die schrijft het als feit, maar noemt geen Blizzard-bron]
- Over de prijs zijn de bronnen het niet eens: Icy Veins en EZG (9 nov) zeggen 50 gold, Gladiator Boost zegt 10 gold, Timesaver (8 nov) zegt "niet aangekondigd". **Blizzard heeft de prijs niet bevestigd.** [GEMETEN: zoekresultaten 12 nov 2026]
- Dat de client Dual Spec echt kent, is wel zeker. De Forever-client heeft de knopteksten "Primary", "Secondary", "Active" en **"Unlock at your class trainer"**. Retail 12.1.5 heeft die teksten niet. [GEMETEN: GlobalStrings `DUAL_SPEC_PRIMARY` 59221, `DUAL_SPEC_SECONDARY` 59222, `TALENT_SPEC_ACTIVE` 59357, `TALENT_SPEC_LOCKED` 59368 in 1.60.1.70888; positieve controle `TALENT_SPEC_PRIMARY` staat in beide builds]
- Wisselen gaat met de spells "Activate Primary Spec" en "Activate Secondary Spec". Dat duurt **5 seconden**. [GEMETEN: Wowhead Forever-tooltips 63644 en 63645, 12 nov 2026]
- Op hetzelfde level koop je ook je eerste rijdier (Apprentice Riding). Volgens Wowhead kost dat samen 150 gold. [GEMETEN: WH-DS]
- Level en prijs staan niet in de DB2-tabel `SpellLevels` (wel een positieve controle: Frostbolt 116 = level 4). [GEMETEN] Dat zijn dus serverfeiten.

### 3h. Pantser per level (geldt voor meerdere classes)
- **Plate** kunnen alleen Warrior en Paladin leren, vanaf **level 40**. [GEMETEN: DB2 `SkillRaceClassInfo` skill 293 "Plate Mail": ClassMask 3, MinLevel 40]
- **Mail**: Warrior en Paladin vanaf het begin; Hunter en Shaman vanaf **level 40**. [GEMETEN: skill 413: ClassMask 3 MinLevel 0, en ClassMask 68 MinLevel 40]
- **Leather**: iedereen behalve Priest, Mage en Warlock. **Cloth**: iedereen. [GEMETEN: skill 414 ClassMask 1103; skill 415 ClassMask 1503]
- **Schild**: alleen Warrior, Paladin en Shaman. [GEMETEN: skill 433 ClassMask 67]
- **Wand**: alleen Priest, Mage en Warlock. [GEMETEN: skill 228 ClassMask 400]
- **Polearms** (stokwapens) pas vanaf level 20. [GEMETEN: skill 229 MinLevel 20]
- Mail en Plate leer je bij de trainer. Prijzen staan in de addon-data. [GEMETEN in de What's Training?-data, niet in de client: `Modules/ForeverTrainerData.lua:293, 599, 1090, 1364`]

### 3i. Wat een stat oplevert, per class
- Strength geeft **2** aanvalskracht bij Warrior, Paladin, Shaman en Druid, en **1** bij de rest. [GEMETEN: DB2 `ChrClasses` AttackPowerPerStrength]
- Agility geeft alleen bij Hunter en Rogue aanvalskracht van dichtbij. Op afstand ook bij de Warrior. [GEMETEN: DB2 `ChrClasses` AttackPowerPerAgility en RangedAttackPowerPerAgility]
- Een Druid krijgt alleen in Cat Form aanvalskracht van Agility. [GEMETEN in client-teksten volgens `Modules/ForeverMainStats.lua:10-11`; niet opnieuw gemeten]
- Blizzards tabel geeft geen "hoofdstat" per class (PrimaryStatPriority = 0 overal). Een lijst als hieronder moet dus uit gidsen komen. [GEMETEN: `ChrClasses` en `ChrSpecialization` 1.60.1.70888]
- De stat-volgordes hieronder komen van Icy Veins (bijgewerkt 4 nov 2026). Die zijn geschreven voor **level 60**. Tijdens het levelen telt vooral de eerste stat. [GEMETEN: IV; "vooral de eerste" is AFGELEID]

---

## 4. Per class

Vaste vorm: **Richtingen** · **Nodig** · **Vanaf level** · **Wat de addon al weet** · **Bronnen**.
De wapenlijst per class komt uit Blizzards eigen tabel. [GEMETEN: DB2 `SkillRaceClassInfo`, zoals opgeslagen in `Modules/ForeverWeapons.lua:29-44`, gemeten op 1.60.1.70862; steekproef op 70888 (staf, dolk) klopt]

### Warrior
**Richtingen:** Arms · Fury · Protection [GEMETEN: DB2 `TalentTab` 161, 164, 163]

**Nodig**
| richting | wapen | gear | stats (belangrijkste eerst) |
|---|---|---|---|
| Arms | één groot wapen in twee handen | Mail, Plate vanaf 40 | Weapon DPS > Hit > Expertise > Crit > Strength |
| Fury | twee wapens, één in elke hand (Dual Wield vanaf 20) | Mail, Plate vanaf 40 | Weapon DPS > Hit > Expertise > Crit > Strength |
| Protection | eenhandig wapen + schild | Mail, Plate vanaf 40 | verdedigen: Stamina > Armor > Agility; aanvallen: Expertise > Hit |

- Mag: eenhandige en tweehandige maces, axes en swords, polearms (20), staves, daggers, fist weapons, bows, crossbows, guns, thrown. [GEMETEN: `ForeverWeapons.lua:30-43`, bit 1]
- Arms = tweehandig, Fury = twee wapens, Protection = schild. [GEMETEN: WT]
- Blizzard: een tweehandig wapen geeft extra Rage. Twee wapens maken Whirlwind dubbel (talent). Defiance en Bastion werken alleen met een schild. [GEMETEN: BLZ-PW]
- Shield Bash, Shield Block en Shield Slam werken alleen met een schild. [GEMETEN: DB2 `SpellEquippedItems` 72, 2565, 23922: armor-subclass Shield]
- Dual Wield leer je op level 20 bij de trainer. [GEMETEN: `ForeverTrainerData.lua:1326`]
- Stats: [GEMETEN: IV, 4 nov 2026]. Tijdens het levelen: Strength eerst, dan Agility. [GEMETEN: `ForeverMainStats.lua:25`]

**Vanaf level**
- Defensive Stance (de tank-houding) op 10, via een quest. [GEMETEN: `ForeverHowToPlay.lua:164, 177`]
- Spearing Strike (Arms) op 25, Sweeping Strikes op 30, Mortal Strike op 40. Death Wish (Fury) op 30, Bloodthirst op 40. Shield Slam (Protection) op 40. [GEMETEN: `ForeverMacros.lua:384-403`; levels zelf AFGELEID volgens `:380-381`]
- Berserker Stance op 30, via de quest "The Affray". [GEMETEN: `ForeverHowToPlay.lua:165`]
- Plate op 40. [GEMETEN: 3h]

**Wat de addon al weet:** speelkaart `ForeverHowToPlay.lua:157-196` (talentlevels op :187) · stats `ForeverMainStats.lua:25` · wapens `ForeverWeapons.lua:29-44` · boomnamen `ForeverMacros.lua:580-588` · macro's per boom `ForeverMacros.lua:383-403` · Dual Wield/Plate `ForeverTrainerData.lua:1326, 1364`.

**Bronnen:** DB2 `TalentTab`, `SkillRaceClassInfo`, `SpellEquippedItems` (70888) · BLZ-PW · WT · IV.

### Paladin
**Richtingen:** Holy · Protection · Retribution [GEMETEN: DB2 `TalentTab` 382, 383, 381]

**Nodig**
| richting | wapen | gear | stats (belangrijkste eerst) |
|---|---|---|---|
| Holy | eenhandig wapen + schild of offhand | Mail, Plate vanaf 40 | Healing Power > Intellect > Spirit > Mp5 > Crit |
| Protection | eenhandig wapen + schild | Mail, Plate vanaf 40 | Stamina > Defense > Spell Power > Intellect > Strength |
| Retribution | groot wapen in twee handen | Mail, Plate vanaf 40 | build 1: Weapon DPS > Hit > Expertise > Strength > Spell Power · build 2: Weapon DPS > Hit > Spell Power > Crit |

- Mag: eenhandige en tweehandige maces, axes en swords, en polearms (20). Geen staf, geen dolk. [GEMETEN: `ForeverWeapons.lua:30-36`, bit 2]
- Ook een **Libram** in het relic-vakje. [GEMETEN: DB2 `ChrClasses` ArmorTypeMask 2303 (bevat bit 128 = Libram); betekenis van de bit AFGELEID]
- Holy Shield werkt alleen met een schild. [GEMETEN: DB2 `SpellEquippedItems` 20925]
- Retribution: Icy Veins noemt twee builds en wil een tweehandig wapen, heel snel of heel traag, afhankelijk van de build. [GEMETEN: IV]
- Holy met schild of offhand: dat wapen per richting staat niet in mijn bronnen. [AFGELEID]
- Tijdens het levelen: Strength eerst. Zodra je het talent "Champion of the Light" hebt, telt Intellect zwaarder. [GEMETEN: `ForeverMainStats.lua:26-27`; Icy Veins bevestigt dat talent: 60% van je Intellect wordt Spell Power, IV]

**Vanaf level**
- Seal of Command (Retribution) op 20, Divine Favor (Holy) op 20, Holy Shock en Holy Shield op 30, Light's Vigil (Holy) op 40. [GEMETEN: `ForeverMacros.lua:239, 446-467`; levels AFGELEID]
- Plate op 40. [GEMETEN: 3h]

**Wat de addon al weet:** speelkaart `ForeverHowToPlay.lua:65-101` (Seal of Command op :73) · stats `ForeverMainStats.lua:26-27` · wapens `ForeverWeapons.lua:29-44` · boomnamen `ForeverMacros.lua:589-597` · macro's `ForeverMacros.lua:446-467` · Plate `ForeverTrainerData.lua:599`.

**Bronnen:** DB2 `TalentTab`, `SkillRaceClassInfo`, `SpellEquippedItems`, `ChrClasses` (70888) · WT · IV.

### Hunter
**Richtingen:** Beast Mastery · Marksmanship · Survival [GEMETEN: DB2 `TalentTab` 361, 363, 362]

**Nodig**
| richting | wapen | gear | stats (belangrijkste eerst) |
|---|---|---|---|
| Beast Mastery | afstandswapen (bow, gun of crossbow) | Leather, Mail vanaf 40 | Weapon Damage > Hit > Crit > Agility > Attack Power |
| Marksmanship | afstandswapen | Leather, Mail vanaf 40 | Weapon Damage > Hit > Crit > Agility > Attack Power |
| Survival | afstandswapen + een wapen voor dichtbij | Leather, Mail vanaf 40 | Weapon Damage > Hit > Crit > Agility > Attack Power |

- Mag: eenhandige en tweehandige axes en swords, polearms (20), staves, daggers, fist weapons, bows, crossbows, guns, thrown. Geen maces. [GEMETEN: `ForeverWeapons.lua:30-43`, bit 4]
- Elke Hunter schiet met een afstandswapen (Auto Shot). [GEMETEN: `ForeverHowToPlay.lua:130-133`]
- Sniper Shot (Marksmanship) werkt alleen met een bow, gun of crossbow. [GEMETEN: DB2 `SpellEquippedItems` 1310687: subclass-masker 262156]
- Survival heeft opties voor vallen en voor dichtbij vechten. [GEMETEN: BLZ-HD; WT]. Welk wapen Survival voor dichtbij wil: NIET GEMETEN.
- Je dier krijgt stats mee van jouw gear. [GEMETEN: BLZ-HD]
- Dual Wield op level 20. [GEMETEN: `ForeverTrainerData.lua:250`]
- Tijdens het levelen: Agility, dan Spirit. Met het talent "Careful Aim" telt Intellect. [GEMETEN: `ForeverMainStats.lua:28-29`]

**Vanaf level**
- Je dier krijg je op 10, via quests. [GEMETEN: `ForeverHowToPlay.lua:141`]
- Lone Wolf (Marksmanship, 11 punten) is +20% schade als je **geen** dier hebt. [GEMETEN: BLZ-HD]
- Summon Hawk (Beast Mastery) op 25, Intimidation op 30, Bestial Wrath op 40. Scatter Shot (Marksmanship) op 30, Sniper Shot op 40. Deterrence (Survival) op 20, Counterattack op 30. [GEMETEN: `ForeverMacros.lua:425-445`; levels AFGELEID]
- Mail op 40. [GEMETEN: 3h]

**Wat de addon al weet:** speelkaart `ForeverHowToPlay.lua:128-156` · stats `ForeverMainStats.lua:28-29` · wapens `ForeverWeapons.lua:29-44` · boomnamen `ForeverMacros.lua:598-606` · macro's `ForeverMacros.lua:425-445` · Mail/Dual Wield `ForeverTrainerData.lua:250, 293`.

**Bronnen:** DB2 `TalentTab`, `SkillRaceClassInfo`, `SpellEquippedItems` (70888) · BLZ-HD · WT · IV.

### Rogue
**Richtingen:** Assassination · Combat · Subtlety [GEMETEN: DB2 `TalentTab` 182, 181, 183]

**Nodig**
| richting | wapen | gear | stats (belangrijkste eerst) |
|---|---|---|---|
| Assassination | twee dolken | Leather | Expertise > Hit > Agility > Weapon Damage > Crit |
| Combat | twee eenhandige wapens | Leather | Expertise > Hit > Agility > Weapon Damage > Crit |
| Subtlety | een dolk in je hoofdhand (en een tweede wapen) | Leather | Weapon Damage > Expertise > Hit > Weapon Skill > Agility |

- Mag: eenhandige maces, axes (nieuw in Forever) en swords, daggers, fist weapons, bows, crossbows, guns, thrown. [GEMETEN: `ForeverWeapons.lua:30-43`, bit 8; WT noemt de axes ook]
- Mutilate (Assassination) werkt alleen met een dolk. [GEMETEN: DB2 `SpellEquippedItems` 399956: subclass Dagger]. Icy Veins: Assassination gebruikt altijd twee dolken. [GEMETEN: IV]
- Backstab en Ambush (veel gebruikt bij Subtlety) werken alleen met een dolk. [GEMETEN: DB2 `SpellEquippedItems` 53, 8676; ook `ForeverHowToPlay.lua:211, 233`]
- Combat: welk soort wapen het best werkt, heb ik niet gemeten. [NIET GEMETEN]
- Dual Wield op level 10. [GEMETEN: `ForeverTrainerData.lua:882`]
- Tijdens het levelen: Agility, dan Strength. [GEMETEN: `ForeverMainStats.lua:30`]

**Vanaf level**
- Poisons (gif) op 20, via een quest. [GEMETEN: `ForeverHowToPlay.lua:225, 237`]
- Riposte (Combat) en Premeditation (Subtlety) op 20. Cold Blood (Assassination) en Ghostly Strike (Subtlety) op 25. Blade Flurry (Combat) en Preparation (Subtlety) op 30. Mutilate (Assassination) en Adrenaline Rush (Combat) op 40. [GEMETEN: `ForeverMacros.lua:404-424`; levels AFGELEID]

**Wat de addon al weet:** speelkaart `ForeverHowToPlay.lua:197-239` (talenten op :228) · stats `ForeverMainStats.lua:30` · wapens `ForeverWeapons.lua:29-44` · boomnamen `ForeverMacros.lua:607-615` · macro's `ForeverMacros.lua:404-424` · Dual Wield `ForeverTrainerData.lua:882`.

**Bronnen:** DB2 `TalentTab`, `SkillRaceClassInfo`, `SpellEquippedItems` (70888) · WT · IV.

### Priest
**Richtingen:** Discipline · Holy · Shadow [GEMETEN: DB2 `TalentTab` 201, 202, 203]

**Nodig**
| richting | wapen | gear | stats (belangrijkste eerst) |
|---|---|---|---|
| Discipline | staf, of mace/dolk + offhand; plus een wand | Cloth | Healing Power > Mp5 > Spirit = Intellect > Crit |
| Holy | idem | Cloth | Healing Power > Mp5 > Spirit = Intellect > Crit |
| Shadow | idem | Cloth | Hit > Spell Power > Crit > Spell Pierce > Spirit |

- Mag: eenhandige maces, staves, daggers, en een wand. [GEMETEN: `ForeverWeapons.lua:30-43`, bit 16; wand: DB2 skill 228 ClassMask 400]
- Welk wapen per richting het best is, staat niet in mijn bronnen. Voor casters gaat het om de stats op het wapen. [AFGELEID]
- Blizzard: Holy-spells krijgen genoeg Hit uit een talent, dus healers hoeven geen Hit te zoeken. Meditation geeft veel meer mana uit Spirit. [GEMETEN: BLZ-PW]
- Tijdens het levelen: Intellect, dan Spirit. [GEMETEN: `ForeverMainStats.lua:31`]

**Vanaf level**
- Op 10 en 20 krijgt elk ras een eigen Priest-spell, via een quest. [GEMETEN: `ForeverHowToPlay.lua:244-251`]
- Mind Flay (Shadow) en Holy Nova (Holy) op 20. Penance (Discipline) en Silence (Shadow) op 30. Power Infusion en Inner Focus (Discipline), Prayer of Mending (Holy) en Shadowform (Shadow) op 40. [GEMETEN: `ForeverMacros.lua:291, 533-553`; levels AFGELEID]
- In Shadowform werken geen heals. [GEMETEN: `ForeverHowToPlay.lua:242, 273`]

**Wat de addon al weet:** speelkaart `ForeverHowToPlay.lua:240-278` (talenten op :271) · stats `ForeverMainStats.lua:31` · wapens `ForeverWeapons.lua:29-44` · boomnamen `ForeverMacros.lua:616-624` · macro's `ForeverMacros.lua:533-553`.

**Bronnen:** DB2 `TalentTab`, `SkillRaceClassInfo` (70888) · BLZ-PW · WT · IV.

### Shaman
**Richtingen:** Elemental · Enhancement · Restoration [GEMETEN: DB2 `TalentTab` 261, 263, 262]

**Nodig**
| richting | wapen | gear | stats (belangrijkste eerst) |
|---|---|---|---|
| Elemental | staf, of eenhandig wapen + schild | Leather, Mail vanaf 40 | Spell Power > Hit > Crit > Intellect > Mp5 |
| Enhancement | een traag groot wapen in twee handen | Leather, Mail vanaf 40 | Strength (zie hieronder) · Weapon DPS · Hit · Expertise |
| Restoration | eenhandig wapen + schild | Leather, Mail vanaf 40 | Healing Power > Crit > Intellect > Spirit > Mp5 |

- Mag: eenhandige en tweehandige maces en axes, staves, daggers, fist weapons. Ook een schild. Geen swords. [GEMETEN: `ForeverWeapons.lua:30-43`, bit 64; schild: DB2 skill 433]
- Ook een **Totem** in het relic-vakje. [GEMETEN: DB2 `ChrClasses` ArmorTypeMask 2671 (bevat bit 512 = Totem); betekenis AFGELEID]
- Enhancement: Icy Veins wil een traag tweehandig wapen (rond 3.3 seconden of trager). [GEMETEN: IV]
- **Enhancement-stats zijn veranderd na Icy Veins.** Icy Veins (4 nov) zet Intellect vóór Strength. Blizzard zei op 6 nov dat Strength altijd de sterkste stat is, en paste op 10 nov Mental Dexterity aan. [GEMETEN, maar tweedehands: `ForeverMainStats.lua:32-36` (gelezen via mirrors, niet in de client); Wowhead-nieuwskop "Enhancement Shaman Changes - Hotfixes for November 10" staat op wowhead.com/forever/news, 12 nov 2026]
- In de Shaman-trainerlijst staat geen Dual Wield (bij Warrior, Hunter en Rogue wel). [GEMETEN: `ForeverTrainerData.lua`, zoekopdracht "Dual Wield" raakt :250, :882, :1326, niets tussen :988 en :1154] Dus de Shaman leert Dual Wield waarschijnlijk niet bij de trainer. [AFGELEID]
- Restoration en Elemental met schild: dat staat niet in mijn bronnen. [AFGELEID]
- Warcraft Tavern zegt dat Enhancement "in nood" ook kan tanken. [GEMETEN: WT]. Blizzards classtabel geeft de Shaman maar twee rollen (RolesMask 12; Paladin en Druid 14). [GEMETEN: DB2 `ChrClasses`; wat de bits betekenen is AFGELEID]
- Tijdens het levelen: Strength, dan Intellect. [GEMETEN: `ForeverMainStats.lua:36`]

**Vanaf level**
- Totems krijg je via quests: Earth op 4, Fire op 10, Water op 20, Air op 30. [GEMETEN: `ForeverHowToPlay.lua:285`]
- Water Shield op 20. Stormstrike (Enhancement) en Mana Tide Totem op 25. Nature's Swiftness op 30. Lightning Mastery (Elemental), Rage of the Farseer (Enhancement) en Riptide (Restoration) op 40. [GEMETEN: `ForeverHowToPlay.lua:311`; `ForeverMacros.lua:468-489`; levels AFGELEID]
- ⚠️ Stormstrike staat op 25 in `ForeverHowToPlay.lua:311` en op 40 in `ForeverMacros.lua:476`. Dat spreekt elkaar tegen. [GEMETEN: beide regels; welke klopt is NIET GEMETEN]
- Mail op 40. [GEMETEN: 3h]

**Wat de addon al weet:** speelkaart `ForeverHowToPlay.lua:279-319` · stats `ForeverMainStats.lua:32-36` · wapens `ForeverWeapons.lua:29-44` · boomnamen `ForeverMacros.lua:625-633` · macro's `ForeverMacros.lua:468-489` · Mail `ForeverTrainerData.lua:1090`.

**Bronnen:** DB2 `TalentTab`, `SkillRaceClassInfo`, `ChrClasses` (70888) · WT · IV · Wowhead-nieuwsoverzicht 12 nov 2026.

### Mage
**Richtingen:** Arcane · Fire · Frost [GEMETEN: DB2 `TalentTab` 81, 41, 61]

**Nodig**
| richting | wapen | gear | stats (belangrijkste eerst) |
|---|---|---|---|
| Arcane | staf, of dolk/sword + offhand; plus een wand | Cloth | Hit = Spell Power > Crit > Intellect > Spirit > Mp5 |
| Fire | idem | Cloth | Hit = Spell Power > Crit > Intellect > Spirit > Mp5 |
| Frost | idem | Cloth | Hit = Spell Power > Crit > Intellect > Mp5 > Spirit |

- Mag: eenhandige swords, staves, daggers, en een wand. [GEMETEN: `ForeverWeapons.lua:30-43`, bit 128; wand: DB2 skill 228]
- Het wapen per richting verschilt niet in mijn bronnen. [AFGELEID]
- Icy Veins: je wand gebruiken stopt je mana-terugwinning door Spirit niet. [GEMETEN: IV]
- Tijdens het levelen: Intellect, dan Spirit. [GEMETEN: `ForeverMainStats.lua:37`]

**Vanaf level**
- Arcane Blast, Pyroblast (Fire) en Ice Lance (Frost) op 20. Arcane Wrath en Ice Block op 25. Blast Wave op 30. Arcane Power, Combustion en Ice Barrier op 40. [GEMETEN: `ForeverHowToPlay.lua:123`; `ForeverMacros.lua:490-510`; levels AFGELEID]

**Wat de addon al weet:** speelkaart `ForeverHowToPlay.lua:102-127` · stats `ForeverMainStats.lua:37` · wapens `ForeverWeapons.lua:29-44` · boomnamen `ForeverMacros.lua:634-642` · macro's `ForeverMacros.lua:490-510`.

**Bronnen:** DB2 `TalentTab`, `SkillRaceClassInfo` (70888) · WT · IV.

### Warlock
**Richtingen:** Affliction · Demonology · Destruction [GEMETEN: DB2 `TalentTab` 302, 303, 301]

**Nodig**
| richting | wapen | gear | stats (belangrijkste eerst) |
|---|---|---|---|
| Affliction | staf, of dolk/sword + offhand; plus een wand | Cloth | Hit > Spell Power > Crit > Haste > Intellect |
| Demonology | idem | Cloth | Hit > Spell Power > Crit > Haste > Intellect |
| Destruction | idem | Cloth | Hit > Spell Power > Haste > Crit > Intellect |

- Mag: eenhandige swords, staves, daggers, en een wand. [GEMETEN: `ForeverWeapons.lua:30-43`, bit 256; wand: DB2 skill 228]
- Het wapen per richting verschilt niet in mijn bronnen. [AFGELEID]
- Tijdens het levelen: Intellect, dan Stamina. [GEMETEN: `ForeverMainStats.lua:38`]

**Vanaf level**
- Je demonen krijg je via quests: Imp op 1, Voidwalker op 10, Succubus of Incubus op 20, Felhunter op 30. [GEMETEN: `ForeverHowToPlay.lua:326-327`]
- Demonic Sacrifice (Demonology) en Shadowburn (Destruction) op 20. Curse of Exhaustion (Affliction) op 25. Siphon Life (Affliction) en Bane of Havoc (Destruction) op 30. [GEMETEN: `ForeverHowToPlay.lua:354`; `ForeverMacros.lua:511-532`; levels AFGELEID]

**Wat de addon al weet:** speelkaart `ForeverHowToPlay.lua:320-362` (talenten op :354) · stats `ForeverMainStats.lua:38` · wapens `ForeverWeapons.lua:29-44` · boomnamen `ForeverMacros.lua:643-651` · macro's `ForeverMacros.lua:511-532`.

**Bronnen:** DB2 `TalentTab`, `SkillRaceClassInfo` (70888) · WT · IV.

### Druid
**Richtingen:** Balance · Feral Combat · Restoration [GEMETEN: DB2 `TalentTab` 283, 281, 282]

**Nodig**
| richting | wapen | gear | stats (belangrijkste eerst) |
|---|---|---|---|
| Balance | staf, of mace/dolk + offhand | Leather | Hit > Crit > Spell Power > Intellect |
| Feral Combat | een sterk wapen (in Forever telt de wapenschade mee) | Leather | schade: Weapon DPS > Expertise > Hit > Agility > Strength · tank: Armor > Defense > Stamina > Agility |
| Restoration | staf, of mace + offhand | Leather | Healing Power > Intellect > Spirit > Mp5 > Crit |

- Mag: eenhandige en tweehandige maces, polearms (vanaf 20, nieuw in Forever), staves, daggers, fist weapons. Geen schild. [GEMETEN: `ForeverWeapons.lua:30-43`, bit 1024; schild: DB2 skill 433 heeft de Druid niet; WT zegt ook "geen schild"]
- Ook een **Idol** in het relic-vakje. [GEMETEN: DB2 `ChrClasses` ArmorTypeMask 2343 (bevat bit 256 = Idol); betekenis AFGELEID; WT noemt ook Idols]
- Feral: Warcraft Tavern zegt dat de aanvallen meegaan met de wapenschade, en Icy Veins zet Weapon DPS bovenaan. [GEMETEN: WT; IV]. Welk wapentype dan het best is: NIET GEMETEN.
- Feral als tank: Thick Hide wordt sterker met Defense op je gear. [GEMETEN: BLZ-HD]
- Tijdens het levelen: Agility, dan Strength. [GEMETEN: `ForeverMainStats.lua:39`]

**Vanaf level**
- Bear Form op 10 (quest), Cat Form op 20 (quest). [GEMETEN: `ForeverHowToPlay.lua:51, 57`]
- Feral Charge op 20. Insect Swarm (Balance) en Swiftmend (Restoration) op 25. Nature's Swiftness (Restoration) op 30. Moonkin Form (Balance) op 40. [GEMETEN: `ForeverMacros.lua:554-576`; `ForeverHowToPlay.lua:62`; levels AFGELEID]
- ⚠️ Primal Bite (Feral) staat in de addon op 40, maar Blizzard noemt het een 16-punts-talent, dus level 25. [GEMETEN: `ForeverMacros.lua:566` tegenover BLZ-HD (beta, 30 sep)]. Welke klopt in de huidige build: NIET GEMETEN.
- Lacerate wordt op 42 een gewone spell. [GEMETEN: BLZ-HD]

**Wat de addon al weet:** speelkaart `ForeverHowToPlay.lua:37-64` · stats `ForeverMainStats.lua:39` · wapens `ForeverWeapons.lua:29-44` (polearms :36) · boomnamen `ForeverMacros.lua:652-660` · macro's `ForeverMacros.lua:554-576`.

**Bronnen:** DB2 `TalentTab`, `SkillRaceClassInfo`, `ChrClasses` (70888) · BLZ-HD · WT · IV.

---

## 5. Bronnen

- **DB2**: wago.tools, Blizzards eigen tabellen, Forever-build 1.60.1.70888 (10 nov 2026). Opgehaald op 12 nov 2026 via `tools/gamedata.py`. Tabellen: ChrClasses, ChrSpecialization, TalentTab, TraitTreeXTraitCurrency, TraitCurrencySource, TraitCond, TraitNode, TraitNodeEntry, TraitNodeXTraitNodeEntry, TraitDefinition, TraitTree, SkillRaceClassInfo, SkillLine, SpellEquippedItems, SpellLevels, SpellName, GlobalStrings. Ter vergelijking ook GlobalStrings van retail 12.1.5.70783.
- **Wowhead-tooltips**: nether.wowhead.com/forever/tooltip, spells 1225474, 63624, 63644, 63645, 465546. Opgehaald op 12 nov 2026.
- **BLZ-HD**: Blizzard, "World of Warcraft: Forever Class Deep Dives — Hunter and Druid", worldofwarcraft.blizzard.com/news/24301515, 30 sep (2026). Beta-info.
- **BLZ-PW**: Blizzard, "World of Warcraft: Forever Class Deep Dives — Priest and Warrior", worldofwarcraft.blizzard.com/news/24301514, 30 sep (2026). Beta-info.
- **WH-DS**: Wowhead, "Dual Spec Costs 50 Gold at Level 40 - Unlock Secondary Talent Tree", Squishei, 11 nov 2026, wowhead.com/forever/news/dual-spec-costs-50-gold-at-level-40-unlock-secondary-talent-tree-383835. Gelezen op 12 nov in het browservenster. Er staat geen Blizzard-bron in.
- **IV**: Icy Veins, de 27 WoW Forever-pagina's "<richting> Stat Priority" (icy-veins.com/wow-forever/…-pve-stat-priority). Allemaal "Last Updated Nov 4, 2026". Gelezen op 12 nov 2026. Geschreven voor level 60.
- **WT**: Warcraft Tavern, "Classes, Specializations, & Roles" (warcrafttavern.com/forever/guides/classes/) en de Druid-gids. Zonder datum op de pagina. Gelezen op 12 nov 2026.
- **TS**: timesaver.gg, "wow forever dual spec respec cost", 8 nov 2026. ⚠️ Deze site verkoopt gold en boosts.
- **DTG**: dtgre.com, "WoW Forever Talent Reset Costs 1 Gold?", 5 nov 2026. Noemt geen bronnen.
- **Beta-respec 1 silver**: Blizzards beta-notities van 24 sep en 26 okt 2026, zoals geciteerd door Mobalytics, PC Gamer en Icy Veins. De Blizzard-post zelf heb ik niet geopend.
- **Andere zoekresultaten over de Dual Spec-prijs** (12 nov 2026): Icy Veins en EZG (9 nov) zeggen 50 g; Gladiator Boost zegt 10 g; Kami-labs en Timesaver zeggen "niet bekend".
- **Addon-bestanden** (alleen gelezen): `Modules/ForeverHowToPlay.lua`, `ForeverWeapons.lua`, `ForeverMainStats.lua`, `ForeverMacros.lua`, `ForeverTrainer.lua`, `ForeverTrainerData.lua`.

---

## 6. NIET gemeten / kon niet meten

1. **Respec-prijs na de start.** Er is geen Blizzard-tabel. Alleen spelersmeldingen (1 g, dan 5 g) en een tweedehands Blizzard-zin ("stijgt snel, zakt één keer per week"). Plafond, stapgrootte en het weekelijkse zakken: onbekend. → Meet het in de client: het bevestigvenster bij de trainer toont de prijs.
2. **Dual Spec-prijs (50 g).** Alleen Wowhead (11 nov) en een paar gidsen. Blizzard bevestigde het niet, en andere sites zeggen 10 g of "onbekend". Het level (40) staat wel in Blizzards deep dives, maar die zijn uit de beta (30 sep).
3. **Legacy-talenten resetten:** apart of samen met de class-talenten, en wat het kost. De client heeft twee aparte vragen. Timesaver zegt dat een reset ook Legacy wist; DTG zegt dat het apart is. Niet gemeten.
4. **Hoeveel Legacy Points de perk "Talented" kost.** De tabel `TraitNodeXTraitCost` bestaat niet onder die naam op wago (HTTP 400).
5. **Of de rij-drempels (5-30 punten) per boom tellen of over alle bomen samen.** Ik heb alleen Warrior-boom 1117 bekeken. "Per boom" is de Classic-regel (AFGELEID).
6. **De drie Blizzard deep dives voor Rogue/Warlock, Mage/Shaman en Paladin** heb ik niet geopend. Die richtingen rusten op Warcraft Tavern, Icy Veins en de addon-bestanden.
7. **Het beste wapen per richting** voor: Holy/Protection Paladin (schild of offhand), Survival Hunter (melee-wapen), Combat Rogue (welk type), alle casters (staf of eenhandig + offhand), Feral Druid (welk type), Elemental/Restoration Shaman (schild). Daar staat in mijn bronnen niets over. Wat in de tabellen staat, is AFGELEID.
8. **Stats tijdens het levelen per richting.** Icy Veins schrijft voor level 60. Alleen de levelstat per class staat in `ForeverMainStats.lua` (onderzoek van 7 nov, niet opnieuw gemeten).
9. **De Enhancement-stat.** Icy Veins (4 nov) zegt Intellect vóór Strength; Blizzard (6 en 10 nov, tweedehands via `ForeverMainStats.lua:32-35`) zegt Strength. Het Blizzard-bericht zelf heb ik niet geopend.
10. **Twee tegenstrijdige levels in de addon:** Stormstrike (25 in `ForeverHowToPlay.lua:311`, 40 in `ForeverMacros.lua:476`) en Primal Bite (40 in `ForeverMacros.lua:566`, maar 16-punts = 25 volgens Blizzard in de beta). Niet in de client gecontroleerd.
11. **De talentlevels per talent** in `ForeverMacros.lua` gebruiken de regel "10 + punten". Dat eerste punt op 10 is nu GEMETEN (DB2), maar de levels zelf zijn niet in de client getest.
12. **Wat de RolesMask-bits in ChrClasses betekenen** (tank/healer/schade). Uit het patroon afgeleid, niet gemeten.
13. **docs/forever/ niet gelezen.** De opdracht noemde die map, maar de vaste regel van mh-research is dat het niets in `docs/` leest. Eerder onderzoek daar (FOREVER_<CLASS>_*.md, FOREVER_MAIN_STATS, enz.) is dus niet vergeleken met dit bestand. Dat kan mh-sweep doen.
14. **Wapentabel op build 70888.** `ForeverWeapons.lua` is gemeten op 70862. Op 70888 heb ik alleen staves en daggers nagekeken (die kloppen). Pantser, schild, wand en polearms heb ik wel volledig op 70888 gemeten.
