# Forever: level als X, tank als Y + respec/Dual Spec — onderzoek 21 nov 2026

Rob (21 nov, via sparring): *"Ik ben nu een paladin aan het levelen ... als tank ... De ene zegt, joh, als retributie ...
Heb ik een two-handed sword nodig? ... een one-handed en een shield? ... welke talentpunten ... ook bij andere ... zoals een
druid"*. GO, letterlijk: *"Ja, voeg dat maar toe en laat het maar uitvoeren ook. Ik vind dat wel iets belangrijks eigenlijk."*

G = GEMETEN, A = AFGELEID. DB2 = wago.tools wowf 1.60.1.71037.

## Gemeten in deze bouwchat
- G: Dual Spec-wissel 63644/63645: SpellMisc CastingTimeIndex 6 → SpellCastTimes 6 = 5000 ms (controle: Defensive Stance
  71 → index 1 = 0 ms). 63624 "Learn a Second Talent Specialization" → index 190 = 100 ms.
- G: wowforeverbuilder.com/classes/paladin/protection/ (talent-snapshot 3 nov, client 1.60.1.70753): "Defense to 440,
  Stamina, Spell power, Intellect, Block value, Armor"; geen Strength; "Spell power raises Consecration and Holy Shield
  threat; it is a tank stat for you". Icy Veins en Mobalytics: 403 voor onze fetch, niet gelezen.

## Uit het mh-research-rapport (bouwchat 21-11)
- G (DB2 SpellLevels): Warrior Defensive Stance 71/Taunt 355/Sunder 7386 (10), Shield Bash 72 (12), Revenge 6572 en Demo
  Shout 1160 (14), Shield Block 2565 (16), Shield Wall 871 (28), Shield Slam 23922 (40, talent). Druid Bear Form 5487,
  Growl 6795, Demo Roar 99, Maul 6807 (10), Enrage 5229 (12), Cat Form 768 (20), Frenzied Regen 22842 (36), Dire Bear 9634 (40).
- G (DB2 ContentTuning MinLevel): Ragefire Chasm 13, Deadmines 16, Wailing Caverns 17. Dat dit de instapgrens is = A.
- A: Hall of Thanes (nieuw, Alliance) 13-18, Ruins of Lordaeron (nieuw, Horde) 15-20 (wowfdb.com).
- G: Defensive Stance 7376 +80% threat (classic +30%); Bear Form 21178 +115% (classic +30%); Blizzard 3 nov idem.
  CONFLICT: Defiance 12792 in DB2 +15%, Blizzard 3 nov 7/13/20%.
- A: Warrior levelen als Prot (Icy Veins 16 nov, Zygor suggested); wowfdb: Prot trager alleen. Druid Feral (Zygor,
  Mobalytics 20 nov). Blizzard 30 sep: in Bear/Cat Form = DPS van je wapen.
- A, tankstats: Warrior Icy Veins (4 nov) overleven Sta > Armor > Agi > Avoidance > Defense; Wowhead (3 nov) Sta > Exp >
  Hit > Defense 440 > … > Str. Druid Icy Veins (4 nov) Armor > Defense 440 > Sta > Agi; threat Weapon DPS > Exp > Hit >
  Agi > Str; Mobalytics leveling Weapon DPS > Str > Agi.
- Dual Spec: G spells 63624/63644/63645 + GlobalStrings TALENT_SPEC_SECONDARY "Secondary Talents"; geen SpellLevels-rij.
  Blizzard: level 40; respec "climbs quickly and only decreases once per week" (TechRadar 10 okt). Spelers: 50 goud
  (Wowhead news 11 nov), respec 1/5/10 goud (timesaver.gg 16 nov, realmfirst.net 17 nov).

## Paladin (uit sparrings mh-research-rapport, 21 nov)
- Level Ret met tweehander; eenhander + schild in de tas; tanken vanaf ~13 met Righteous Fury + Seal of Fury (beide 10,
  G in de rolteksten); prettig vanaf 30 (Holy Shield), echt vanaf 40 (Shieldsworn). Wolfsbane item 267369 = tweehandig zwaard.
- Mobalytics Prot (8 nov, via sparring): vanaf 20 Spell Power, Stamina, Intellect, Strength.

## Besluit tankstats Paladin
Was Stamina > Strength (16 nov, rij zonder gids). Nu Stamina > Intellect: twee van de drie bronnen zetten Spell power /
Intellect boven Strength, één noemt Strength niet. MH kent geen Spell Power/Defense in de stat-tabel.
