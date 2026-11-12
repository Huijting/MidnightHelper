local _, ns = ...
-- Dutch "How you play" for WoW Forever (translated 7 Nov 2026 from Modules/ForeverHowToPlay.lua). Same sections, same order.
-- No client gate (the Dutch pack is manual-only and always loads), but only on Forever (Core.lua sets IS_FOREVER first).
if not ns.IS_FOREVER then
	return
end
ns.FOREVER_HOWTOPLAY_L =ns.FOREVER_HOWTOPLAY_L or {}
ns.FOREVER_HOWTOPLAY_L.nlNL = {
	COMMON = {
		{ "Voor je begint", [[
- De toetsen gaan ervan uit dat MH's toetsenblok staat: /mh block, dan stap 1 en 2.
- **Spell ranks.** De meeste spells hebben ranks: Rank 1, Rank 2, enzovoort. Een hogere rank is dezelfde spell, alleen sterker. Nieuwe ranks koop je bij je class trainer als je levelt. Je hoeft niets te wisselen: MH's toetsen casten een spell op naam, en het spel neemt de hoogste rank die je kent.
- **Een toets waar nog niets op staat** houdt zijn plek. Hij vult zich als je de spell leert. Komt een nieuwe spell niet tevoorschijn? Open dan het toetsenblok (/mh block) en druk op **Bijwerken (nieuwe spells erbij)**.
- **Talent-spells** krijgen ook een toets. Kies je dat talent nooit, dan blijft de toets leeg. Dat is prima.
- **Mana** is de blauwe balk onder je health. De meeste spells kosten mana. Is hij leeg, dan kun je niet casten.
- **Cooldown** = de wachttijd voor je een spell weer kunt indrukken.
- Vaste toetsen, voor elke class hetzelfde: **T** = potion, **Shift-T** = healthstone, **G** = trinket.]] },
	},
	DRUID = {
		{ "Wat hij doet", [[
De Druid kan van vorm veranderen. Als gewone caster gooit hij spells en healt hij. Later kan hij een beer of een kat worden, om van dichtbij te vechten. De beer heeft een taunt (Growl), dus dat is de vorm om te tanken.
Een **form** is zo'n vorm. In een form doen veel van je toetsen iets anders. MH's toetsen wisselen vanzelf: dezelfde toets is als caster de ene spell en als beer een andere.]] },
		{ "Level 1-10: je knoppen", [[
- **1** = Wrath (level 1): je belangrijkste aanvalsspell.
- **2** = Moonfire (4): schade, en daarna nog meer schade over een paar seconden.
- **C** = Healing Touch (1): je grote heal.
- **F4** = Rejuvenation (4): een heal die je beetje bij beetje healt.
- **Shift-X** = Mark of the Wild (1): een buff. Een **buff** is een goed effect op jou of een vriend. Zet hem op voor een gevecht.
- **Shift-Z** = Thorns (6): nog een buff.
- **V** = Entangling Roots (8): houdt een vijand op zijn plek.
- **X** = Nature's Grasp (10).
- **Shift-E** = je race-spell (Shadowmeld voor een Night Elf, War Stomp voor een Tauren).
- **Level 10, Bear Form** (uit een quest): **Ctrl-1** maakt je een beer. Als beer: **1** = Maul, **F** = Growl, **Shift-2** = Demoralizing Roar.]] },
		{ "Simpele volgorde (caster)", [[
Eerst Moonfire (2), dan Wrath (1) tot de vijand dood is. Weinig health? Rejuvenation (F4) of Healing Touch (C).]] },
		{ "Wat er later komt", [[
- 12: Regrowth op F2 (snelle heal). Revive op F3: brengt een dode vriend terug, alleen buiten een gevecht.
- 16: Aquatic Form (uit een quest) op R als je zwemt. 18: Faerie Fire op 5 (werkt in elke form), Hibernate op Shift-Q.
- 20: Cat Form (uit een quest) op Ctrl-2, met Claw, Rip en Prowl. Starfire op 3. In een gevecht wordt F3 Rebirth.
- 30: Travel Form op R (om je te verplaatsen), Tranquility op Q. 40: Dire Bear Form (vervangt Bear Form op Ctrl-1), Innervate op F1.
- 44: Barkskin op Z, in elke form.]] },
		{ "Beginnersfouten", [[
- Een heal indrukken terwijl je in een form zit. Je heals werken alleen in je gewone vorm, niet in Bear, Cat, Aquatic of Travel Form. Ga eerst uit de form: druk dezelfde form-toets nog eens in (Ctrl-1 voor de beer, Ctrl-2 voor de kat).
- In Moonkin Form (een talent, op z'n vroegst level 40) werken je aanvalsspells wel, maar je heals niet.
- Wat wél werkt in een form: potions, Barkskin, Nature's Grasp, Faerie Fire en je race-spell.]] },
	},
	PALADIN = {
		{ "Wat hij doet", [[
De Paladin is een heilige vechter. Hij slaat van dichtbij, healt zichzelf en anderen, en beschermt vrienden. Hij heeft geen vormen en geen stances, dus elke toets doet altijd hetzelfde.
Een **seal** is een heilige kracht die je op jezelf zet. Hij duurt 30 seconden, en je kunt er maar één tegelijk hebben. Een **aura** is een kracht die je aanzet en aan laat staan; hij helpt je hele groep. Een **blessing** is een buff die je op jezelf of een vriend zet; hij duurt 60 minuten. Een **buff** is een goed effect.]] },
		{ "Seals en aura's", [[
- **Seal of Righteousness** (1): elke klap doet extra holy-schade. Een traag wapen doet meer per klap.
- **Seal of the Crusader** (6, eigen Alt-toets): je slaat sneller, maar elke klap doet minder.
- **Seal of Fury** (10): de tank-seal. Met een schild geeft elke klap je ook een klein schild.
- **Seal of Command** (talent, op z'n vroegst level 20): klappen doen soms een grote extra holy-klap. Heb je hem, dan cast toets 3 deze in plaats van Seal of Righteousness.
- **Seal of Justice** (22), **Seal of Light** (30), **Seal of Wisdom** (38), allemaal op je eigen Alt-toetsen: klappen geven soms een stun, healen je, of geven je mana.
- **Devotion Aura** (1): meer armor voor je groep. **Retribution Aura** (16): holy-schade op alles wat je groep slaat. **Concentration Aura** (22): casters in je groep worden minder vaak onderbroken als ze geraakt worden.]] },
		{ "Level 1-10: je knoppen", [[
- **3** = Seal of Righteousness (level 1): je seal.
- **C** = Holy Light (1): je grote heal. Undead Paladins krijgen hem uit de quest van level 2, "Rediscovering the Light".
- **Ctrl-1** = Devotion Aura (1, van de trainer): zet hem aan en laat hem aan.
- **2** = Judgement (4): cooldown 10 seconden. Hij gebruikt je seal niet op. Hij werkt alleen als er een seal aan staat: zet eerst je seal aan (3). Zonder seal zegt het spel "You can't do that yet".
- **Shift-Z** = Blessing of Might (4): zet hem op jezelf.
- **1** = Holy Strike (6): je belangrijkste klap, van dichtbij.
- **Z** = Divine Protection (6): 6 seconden lang kan niets je pijn doen, maar jij kunt ook niet aanvallen. Cooldown 5 minuten.
- **E** = Hammer of Justice (8): geeft de vijand een stun. Een **stun** betekent dat de vijand een paar seconden niet kan bewegen of casten. De Paladin heeft geen echte interrupt, dus dit is je "stop die spell"-toets.
- **Shift-C** = Purify (8): haalt een slecht effect weg bij een vriend.
- **Q** = Lay on Hands (10): je noodknop. Hij healt een vriend (of jou) helemaal vol, maar gebruikt alle mana op die je nog hebt. Cooldown 20 minuten.
- **Shift-F** = Blessing of Protection (10): redt een vriend die in de problemen zit.
- **F** = Seal of Fury (10): een seal om te tanken. Zijn Judgement is een taunt. **Taunt** = de vijand jou laten aanvallen.]] },
		{ "Simpele volgorde", [[
Seal (3) voor het gevecht. Dan Holy Strike (1) en Judgement (2) zodra ze klaar zijn. Zet de seal opnieuw op als hij afloopt (hij duurt 30 seconden). Weinig health? Holy Light (C).]] },
		{ "Wat er later komt", [[
- 12: Redemption (uit een quest) op F3 (brengt een dode vriend terug; niet in een gevecht). 14: Blessing of Wisdom op Shift-V.
- 18: Blessing of Freedom op R (een tijdje kan niets je vertragen). 20: Consecration op Shift-1 (raakt meerdere vijanden tegelijk), Exorcism op 5, Flash of Light op F2 (snelle heal), Blessing of Kings op Shift-X.
- 30: Divine Intervention: in een gevecht cast F3 deze in plaats van Redemption. 34: Divine Shield op Z: 10 seconden waarin niets je pijn kan doen, en je kunt nog steeds vechten (met de helft van je schade).
- 42: Cleanse vervangt Purify op Shift-C. 44: Hammer of Wrath op 4 (alleen als de vijand op 20% health of minder staat).
- 52-60: in een groep casten de blessing-toetsen de Greater Blessing voor de hele groep; alleen casten ze de gewone.]] },
		{ "Beginnersfouten", [[
- Exorcism (5) indrukken op een gewone vijand. Hij werkt alleen op Undead en Demons. Turn Undead (Shift-Q, 24) werkt alleen op Undead.
- Hammer of Wrath (4) vroeg in het gevecht indrukken. Hij werkt alleen als de vijand bijna dood is (20% health of minder).
- Divine Shield en Divine Protection delen één cooldown, dus ze staan op één toets (Z). Deze beschermspells, en Blessing of Protection, geven **Forbearance**: 1 minuut lang kun je er geen van allen opnieuw krijgen. Lay on Hands niet.]] },
	},
	MAGE = {
		{ "Wat hij doet", [[
De Mage staat achteraan en cast fire-, frost- en arcane-magie. Hij houdt vijanden op afstand met spells die ze op hun plek houden of vertragen. De Mage heeft geen vormen en geen stances, dus elke toets doet altijd hetzelfde.]] },
		{ "Level 1-10: je knoppen", [[
- **1** = Fireball (level 1): je belangrijkste aanvalsspell.
- **Shift-Z** = Frost Armor (1): een buff op jezelf. Zet hem op voor een gevecht. Je kunt maar één armor tegelijk ophebben.
- **Shift-X** = Arcane Intellect (1): een buff voor jou of een vriend.
- **Ctrl-3** = Shoot: je **wand** (een klein toverstokje dat vanzelf schiet), zodra je er een hebt. Handig als je mana laag is. Leer je Frostfire Bolt, dan neemt die Ctrl-3; zet Shoot op een van je eigen Alt-toetsen als je hem nog wilt.
- **2** = Frostbolt (4): frost-schade.
- **5** = Fire Blast (6): instant fire-klap. **Instant** = geen cast-tijd. Cooldown 8 seconden.
- **3** = Arcane Missiles (8): arcane-schade.
- **Shift-Q** = Polymorph (8): haalt één vijand een tijdje uit het gevecht. Zo'n spell heet **CC** (crowd control).
- **V** = Frost Nova (10): bevriest elke vijand binnen 10 yards om je heen, tot 8 seconden lang. Schade kan het breken. Cooldown 25 seconden.
- Conjure Water (4) en Conjure Food (6) staan niet op het blok. Ze komen op je eigen Alt-toetsen (blok D).]] },
		{ "Simpele volgorde", [[
Frostbolt (2) of Fireball (1) terwijl de vijand aankomt. Fire Blast (5) als hij klaar is. Vijand dicht bij je? Frost Nova (V), stap weg, en cast verder.]] },
		{ "Wat er later komt", [[
- 12: Slow Fall op Shift-R. 14: Arcane Explosion op Shift-2 (raakt meerdere vijanden). 16: Flamestrike op Shift-4.
- 18: Remove Lesser Curse op Shift-V. 20: Blink op R (je bewegingsspell), Blizzard op Shift-1, Evocation op F1 (geeft mana terug), Mana Shield op Z, Fire Ward op F4. Ook de teleports (en later portals): reisspells, niet op het blok. Zet ze op je eigen balk, of gebruik ze uit je spellbook.
- 22: Scorch op Ctrl-1, Frost Ward op F2. 24: Counterspell op E: je **interrupt** (hij stopt de spell van een vijand).
- 26: Cone of Cold op Shift-F. 30: Ice Armor: Shift-Z cast vanaf dan deze in plaats van Frost Armor (hij beschermt je ook tegen frost).
- Talents vanaf level 20: Pyroblast op 4, Ice Lance op F, Arcane Blast op Ctrl-2, Ice Block op C (op z'n vroegst 25).]] },
		{ "Beginnersfouten", [[
- Beide wards tegelijk verwachten. Fire Ward (F4) en Frost Ward (F2) delen één cooldown van 30 seconden, dus maar één tegelijk.
- Mage Armor en Ice Armor samen dragen. Je kunt maar één armor tegelijk ophebben. Mage Armor (34) staat op blok D.]] },
	},
	HUNTER = {
		{ "Wat hij doet", [[
De Hunter schiet van een afstand met een ranged wapen, en heeft vanaf level 10 een **pet**: een dier dat je temt en dat naast je vecht. Van dichtbij heeft hij een paar melee-klappen.
**Auto Shot** = je wapen blijft vanzelf schieten tot je stopt. **Melee** = van dichtbij vechten. De Hunter heeft geen vormen en geen stances, dus elke toets doet altijd hetzelfde.]] },
		{ "Level 1-10: je knoppen", [[
- **1** = Auto Shot (level 1): begint te schieten. MH's toets is zo gemaakt dat een tweede druk hem niet stopt.
- **5** = Raptor Strike (1): je klap als de vijand naast je staat.
- **2** = Serpent Sting (4): schade over een paar seconden.
- Aspect of the Monkey (4) komt op je eigen Alt-toetsen (blok D). Een **aspect** is een buff op jezelf die werkt als een stance. Je kunt maar één aspect tegelijk ophebben.
- **3** = Arcane Shot (6): instant schot. Cooldown 6 seconden.
- **Shift-Z** = Hunter's Mark (6): zet hem één keer op de vijand.
- **Shift-Q** = Concussive Shot (8): vertraagt de vijand.
- **Shift-R** = Aspect of the Hawk (10): je belangrijkste aspect.
- **Level 10, pet-quests:** je leert Tame Beast, Call Pet en Revive Pet. **F4** = Call Pet (haalt je pet), **F3** = Revive Pet (brengt een dode pet terug). Tame Beast heeft geen toets; die gebruik je buiten een gevecht.
- Vanaf dan heeft je pet drie toetsen: **Ctrl-1** = val je target aan, **Ctrl-2** = volg mij, **Ctrl-3** = blijf waar je bent.]] },
		{ "Simpele volgorde", [[
Aspect of the Hawk aan (Shift-R). Pet er eerst op (Ctrl-1). Hunter's Mark (Shift-Z), Serpent Sting (2), Auto Shot (1), dan Arcane Shot (3) als hij klaar is. Vijand naast je? Raptor Strike (5).]] },
		{ "Wat er later komt", [[
- 10: Feed Pet en Dismiss Pet staan niet op het blok (je gebruikt ze buiten een gevecht); zet ze op je eigen balk. Hetzelfde voor Scare Beast (14).
- 12: Distracting Shot op F (laat de vijand jou aanvallen), Mend Pet op F2 (healt je pet), Wing Clip op Shift-F.
- 16: Immolation Trap op Shift-2, Mongoose Bite op Shift-C (alleen nadat jij een dodge doet). 18: Multi-Shot op Shift-1.
- 20: Aimed Shot op 4 (je grote schot), Aspect of the Cheetah op R (snel rennen), Disengage op Z, Freezing Trap op V.
- 26: Rapid Fire op Q. 30: Feign Death op X, Aspect of the Beast (blok D). 34: Explosive Trap neemt Shift-2 over.
- Alle vier de traps delen één cooldown van 30 seconden.]] },
		{ "Beginnersfouten", [[
- Schieten op een vijand die vlak naast je staat. Je geweer of boog werkt niet binnen 8 yards (de "dead zone"): gebruik Raptor Strike (5), of stap achteruit.
- Verwachten dat één toets ver weg schiet en van dichtbij slaat. Een macro kan geen afstand zien, dus melee heeft eigen toetsen (5, Shift-F, Shift-C).
- Mend Pet (F2) indrukken om jezelf te healen. Hij healt alleen je pet. De Hunter heeft geen self-heal.]] },
	},
	WARRIOR = {
		{ "Wat hij doet", [[
De Warrior vecht van dichtbij met een wapen. Hij heeft drie stances, en vanaf level 10 kan hij tanken. Hij healt zichzelf niet, behalve met Victory Rush (level 20).
De Warrior heeft **Rage** in plaats van mana. Je krijgt Rage als je slaat en als je geslagen wordt. Buiten een gevecht loopt je Rage langzaam terug naar 0.]] },
		{ "Stances", [[
Een **stance** is een manier van vechten die je met een toets aanzet. Je staat altijd in één stance. Sommige spells werken alleen in één of twee stances. MH's toetsen wisselen vanzelf: in een andere stance cast dezelfde toets een andere spell. Heeft een toets niets voor je stance, dan doet hij niets (geen foutmelding).
- **Battle Stance** (1): je stance om gewoon te vechten.
- **Defensive Stance** (10, uit een quest): de stance om te tanken. Alleen hier heb je Taunt.
- **Berserker Stance** (30, uit de quest "The Affray"). Hier wordt E Pummel en R Intercept.
- **Tactical Mastery** (14, passief, je doet niets): je houdt tot 10 Rage als je van stance wisselt.
- Geen enkele toets wisselt vanzelf van stance. Jij kiest de stance; de toetsen volgen.]] },
		{ "Level 1-10: je knoppen", [[
- **1** = Heroic Strike (level 1): je belangrijkste klap, in elke stance.
- **Ctrl-1** = Battle Stance (1): zet hem aan en laat hem aan.
- **Shift-X** = Battle Shout (1): een buff. Een **buff** is een goed effect op jou of een vriend. Zet hem op voor een gevecht.
- **R** = Charge (4): ren naar een vijand om een gevecht te beginnen. Werkt alleen in Battle Stance, en niet als je al vecht.
- **Shift-Z** = Rend (4): een **bleed**: schade over een paar seconden. Battle en Defensive Stance.
- **Shift-1** = Thunder Clap (6): raakt meerdere vijanden tegelijk. Battle en Defensive Stance. Cooldown 6 seconden.
- **V** = Hamstring (8): vertraagt de vijand flink, 15 seconden lang. Battle en Berserker Stance.
- **F1** = Bloodrage (10): geeft je meteen Rage en nog wat meer over een paar seconden. Het kost een beetje health. Cooldown 1 minuut.
- **Level 10, Defensive Stance** (uit een quest): **Ctrl-2** zet hem aan. Dezelfde quest geeft **5** = Sunder Armor (elke stance) en, in Defensive Stance, **F** = Taunt. **Taunt** = de vijand jou laten aanvallen. Cooldown 8 seconden.
- Shoot Bow, Shoot Gun, Shoot Crossbow en Throw komen op je eigen Alt-toetsen (blok D). Je krijgt degene die bij je ranged wapen past. Gebruik hem om te **pullen**: raak één vijand van ver weg, zodat hij naar jou toe komt.]] },
		{ "Simpele volgorde", [[
Battle Stance aan (Ctrl-1), Battle Shout (Shift-X). Charge (R) erin. Rend (Shift-Z), dan steeds weer Heroic Strike (1). Meerdere vijanden? Thunder Clap (Shift-1).]] },
		{ "Wat er later komt", [[
- 12: Overpower op 2 (Battle Stance; nadat de vijand een dodge doet), Shield Bash op E: je **interrupt** (hij stopt de spell van een vijand).
- 14: Revenge op 2 (Defensive Stance), Demoralizing Shout op Shift-2. 16: Mocking Blow op F (Battle Stance), Shield Block op Z (Defensive Stance). 18: Disarm op V (Defensive Stance).
- 20: Cleave op Shift-4, Slam op Shift-C, Victory Rush op F2 (alleen in de 20 seconden nadat je een vijand doodt die XP geeft; hij healt je een beetje; cooldown 30 seconden), Retaliation op C (Battle Stance). 22: Intimidating Shout op Shift-Q. 24: Execute op 4 (Battle en Berserker Stance; alleen als de vijand op 20% health of minder staat).
- 26: Challenging Shout op Shift-F. 28: Shield Wall op C (Defensive Stance).
- 30: Berserker Stance op Ctrl-3. Daarin: Intercept op R, Berserker Rage op Shift-V. 36: Whirlwind op 2 (Berserker). 38: Pummel op E (Berserker). 50: Recklessness op Q (Berserker).
- Talents: Last Stand op X en Piercing Howl op Shift-R (vertraagt alles om je heen), op z'n vroegst 20. Spearing Strike op F3 (Battle Stance) en Reckless Swings op Shift-F1, 25. Sweeping Strikes op Q (Battle Stance), Death Wish op Shift-3, Concussion Blow op Shift-V (een stun; in Berserker Stance is deze toets in plaats daarvan Berserker Rage), 30. Mortal Strike, Bloodthirst of Shield Slam op 3, 40.]] },
		{ "Beginnersfouten", [[
- Een toets indrukken in de verkeerde stance. Taunt werkt alleen in Defensive Stance, Overpower alleen in Battle Stance. In de verkeerde stance doet de toets niets. Kijk eerst naar je stance.
- Charge in Defensive Stance. Daar werkt hij alleen met het talent **Vanguard**. Zonder dat krijg je een rode foutmelding.
- Charge in een gevecht. Charge begint alleen een gevecht; als je al vecht, werkt hij niet.
- Thunder Clap (Shift-1) werkt niet in Berserker Stance.
- Shield Bash, Shield Block en Shield Slam zonder schild. Alle drie hebben een schild in je off hand nodig.
- Verwachten dat Slam snel is. In Forever heeft hij een cast van 1,5 seconde en een cooldown van 15 seconden.
- Retaliation en Shield Wall staan allebei op C, elk met een eigen cooldown van 15 minuten. Bewaar ze voor echte problemen.]] },
	},
	ROGUE = {
		{ "Wat hij doet", [[
De Rogue vecht van dichtbij met snelle klappen. Hij kan ongezien naar vijanden toe sluipen, en hij heeft veel manieren om een vijand even stil te zetten.
De Rogue heeft **Energy** in plaats van mana. Energy vult zich vanzelf, en snel: een lege balk is in ongeveer 10 seconden weer vol.]] },
		{ "Stealth en finishers", [[
**Stealth** (level 1, Shift-R) maakt je moeilijk te zien. Je loopt op halve snelheid. Sommige aanvallen werken alleen vanuit Stealth: dat zijn je **openers**, de eerste klap van een gevecht. In Stealth wisselen MH's toetsen vanzelf:
- **1** wordt Garrote (14), **2** wordt Ambush (18), **V** wordt Cheap Shot (26), **Shift-Q** wordt Sap (10), **F** wordt Pick Pocket (4).
- Ken je de spell Stealth nog niet, dan houdt de toets gewoon zijn normale spell.
Klappen zoals Sinister Strike geven je **combo points** (tot 5). Een **finisher** is een klap die al je combo points gebruikt: Eviscerate (4), Slice and Dice (Shift-4) en Rupture (5). Meer points maken hem sterker.]] },
		{ "Level 1-10: je knoppen", [[
- **1** = Sinister Strike (level 1): je belangrijkste klap.
- **4** = Eviscerate (1): je belangrijkste finisher.
- **Shift-R** = Stealth (1): sluipen. Druk nog eens om uit Stealth te gaan. Daarna kun je 10 seconden lang niet terug in Stealth.
- **Shift-2** = Throw (1): een worp van een afstand. Je hebt een werpwapen (zoals werpmessen) in je ranged-slot nodig. Draag je een geweer, boog of kruisboog, dan schiet de toets daarmee.
- **2** = Backstab (4): een sterke klap. Je hebt een dagger nodig, en je moet achter de vijand staan.
- **F** = Pick Pocket (4): alleen in Stealth. Hij steelt iets van de vijand.
- **Shift-Q** = Gouge (6): zet één vijand even stil. Elke schade breekt het. Zo'n spell heet **CC** (crowd control).
- **Z** = Evasion (8): 15 seconden lang ontwijk je veel meer aanvallen. Cooldown 5 minuten.
- **Shift-4** = Slice and Dice (10): je tweede finisher.
- **R** = Sprint (10): snel rennen.
- **Shift-Q** = Sap (10): alleen in Stealth. Haalt één humanoid vijand een tijdje uit het gevecht, voordat het gevecht begint. Werkt niet op beasts of op vijanden die al vechten. Schade breekt het. Sap breekt je Stealth niet.
- **F4** = de heal over tijd van je race, als die er een heeft: Cannibalize (Undead; alleen bij een lijk van een Humanoid of Undead), Rapid Regeneration (Troll; stopt als je beweegt, iets doet of schade krijgt), Read Leyline (High Order Skyborne).
- **Shift-E** = je race-spell (bijvoorbeeld Shadowmeld voor een Night Elf, Blood Fury voor een Orc).]] },
		{ "Simpele volgorde", [[
Stealth (Shift-R) en loop naar de vijand. Een paar keer Sinister Strike (1), dan Eviscerate (4). Met een dagger en achter de vijand: Backstab (2). Vanaf level 10: houd Slice and Dice (Shift-4) aan.]] },
		{ "Wat er later komt", [[
- 12: Kick op E: je **interrupt** (hij stopt de spell van een vijand). 14: Expose Armor op Shift-Z, Garrote op 1 in Stealth.
- 16: Feint op F (buiten Stealth). Hij verlaagt je **threat**: hoe graag de vijand jou wil aanvallen. Pick Lock (blok D).
- 18: Ambush op 2 in Stealth (dagger, van achteren). 20: Rupture op 5. Poisons (uit een quest; zie hieronder).
- 22: Distract op Shift-F, Vanish op X (je ontsnapping; elke keer kost het een Flash Powder, een item in je tassen). 24: Shank op Shift-3 (een klap met je off-hand wapen, dus je hebt in elke hand een wapen nodig; cooldown 10 seconden; geeft 15 Energy terug).
- 26: Cheap Shot op V in Stealth: een **stun** (de vijand kan een paar seconden niet bewegen of iets doen). 30: Kidney Shot op V buiten Stealth. Disarm Trap (blok D). 34: Blind op Shift-V (kost een Blinding Powder).
- Talents: Riposte op Shift-F1 en Premeditation op Shift-C, op z'n vroegst 20. Cold Blood op F1 en Ghostly Strike op Shift-X, 25. Blade Flurry op Shift-1 (raakt meer vijanden), Preparation op F3 (zet de cooldown van je andere Rogue-spells terug, zoals Evasion, Sprint en Vanish), Hemorrhage op 3, 30. Mutilate op 3, Adrenaline Rush of Death Mark op Q, 40.]] },
		{ "Beginnersfouten", [[
- Een opener indrukken buiten Stealth. Garrote, Ambush, Cheap Shot, Sap en Pick Pocket hebben Stealth nodig. Buiten Stealth cast dezelfde toets zijn normale spell.
- Per ongeluk nog eens op Stealth drukken. Dan stopt Stealth, en kun je 10 seconden lang niet terug.
- Night Elf: Shadowmeld is je race-spell, niet de Stealth van je class. Gebruik voor je openers Stealth (Shift-R).
- Backstab en Ambush van voren, of zonder dagger. Allebei hebben een dagger nodig, en je moet achter de vijand staan.
- Een vijand slaan die je met Gouge of Sap hebt stilgezet. Elke schade maakt hem wakker.
- Sap op een beast of op een vijand die al vecht. Sap werkt alleen op humanoids, voor het gevecht.
- Vanish of Blind zonder powder in je tassen. Vanish heeft een Flash Powder nodig, Blind een Blinding Powder.
- Poisons zoeken op het blok. **Poisons** zijn items die je maakt (je leert Poisons uit een quest rond level 20). Je zet ze op je wapen. Sleep ze zelf naar je eigen Alt-toetsen (blok D).
- Ghostly Strike (talent): daarna werkt je volgende Ambush of Garrote zonder Stealth, als je hem binnen 7 seconden gebruikt. MH's toetsen kunnen dat niet zien, dus buiten Stealth casten toets 1 en 2 nog steeds Sinister Strike en Backstab.]] },
	},
	PRIEST = {
		{ "Wat hij doet", [[
De Priest healt, en slaat van een afstand met holy- en shadow-magie. Hij beschermt vrienden met een schild. Later kan hij kiezen voor **Shadowform** (een talent, op z'n vroegst level 40): meer shadow-schade, maar geen heals.
De Priest heeft geen stances. Shadowform verandert de toetsen niet: elke toets doet altijd hetzelfde.]] },
		{ "De eigen spells van je race", [[
Elke Priest-race heeft twee eigen Priest-spells: één op level 10 en één op level 20. Allebei krijg je uit een quest, niet bij de trainer. MH zet ze op **X** en **Shift-R**, dus elke race gebruikt dezelfde twee toetsen.
- Dwarf: Desperate Prayer (10, X; cooldown 10 minuten), Chastise (20, Shift-R).
- Human: Divine Grace (10, Shift-R; een instant heal op een vriend onder de helft van zijn health, niet op jezelf; cooldown 10 minuten), Feedback (20, X).
- Night Elf: Starshards (10, Shift-R; cooldown 30 seconden), Elune's Grace (20, X).
- Undead: Touch of Weakness (10, X), Dark Sacrifice (20, Shift-R; ruil je eigen health voor mana).
- Troll: Hex of Weakness (10, Shift-R), Shadowguard (20, X).
- Gnome: Confounding Flash (10, Shift-R), Contingency Plan (20, X; een ward op een vriend die hem healt en een schild geeft als zijn health laag wordt).]] },
		{ "Level 1-10: je knoppen", [[
- **1** = Smite (level 1): je belangrijkste aanvalsspell.
- **C** = Lesser Heal (1): je belangrijkste heal. Later nemen Heal (16) en Greater Heal (40) deze toets over.
- **5** = Shoot (1): je **wand** (een klein toverstokje dat vanzelf schiet). Je moet een wand in je handen hebben.
- **Shift-X** = Power Word: Fortitude (1): een buff. Een **buff** is een goed effect op jou of een vriend. Zet hem op voor een gevecht.
- **2** = Shadow Word: Pain (4): shadow-schade.
- **Z** = Power Word: Shield (6): een schild op jou of een vriend. Cooldown 4 seconden, maar dezelfde persoon kan pas na 15 seconden een nieuw schild krijgen.
- **F** = Fade (8): vijanden willen jou een tijdje minder graag aanvallen. Cooldown 30 seconden.
- **F4** = Renew (8): een heal die beetje bij beetje healt.
- **3** = Mind Blast (10): shadow-schade. Cooldown 8 seconden.
- **F3** = Resurrection (10): brengt een dode vriend terug. Alleen buiten een gevecht.
- Je race-spell van level 10 staat op **X** of **Shift-R** (zie de lijst hierboven).
- **Shift-E** = je race-skill (bijvoorbeeld Stoneform voor een Dwarf, Shadowmeld voor een Night Elf).]] },
		{ "Simpele volgorde", [[
Schild (Z) op jezelf. Shadow Word: Pain (2), Mind Blast (3), dan Smite (1). Weinig mana? Gebruik je wand (5). Weinig health? Renew (F4) of Lesser Heal (C).]] },
		{ "Wat er later komt", [[
- 12: Inner Fire op Shift-Z. 14: Cure Disease op Shift-C, Psychic Scream op V (een paar vijanden om je heen rennen tot 8 seconden lang angstig weg; schade kan het stoppen; cooldown 30 seconden).
- 18: Dispel Magic op Shift-V. 20: Flash Heal op F2 (snelle heal), Holy Fire op 4, Shackle Undead op Shift-Q, Devouring Plague op Shift-3, je race-spell van level 20, Fear Ward (blok D).
- 30: Prayer of Healing op Shift-2 (healt je groep), Mind Control op Shift-F. 32: Shadow Word: Death op Shift-4, Abolish Disease neemt Shift-C over. 34: Levitate op R (kost een Light Feather). 48: Prayer of Fortitude neemt Shift-X over (kost een Holy Candle).
- Talents: Mind Flay (neemt toets 1 over), Holy Nova op Shift-1 en Inner Focus op F1, op z'n vroegst 20. Vampiric Embrace op Ctrl-3, 25. Penance op Shift-F1 en Silence op E (je **interrupt**: hij stopt de spell van een vijand), 30. Power Infusion op Q, Shadowform op Ctrl-1, Prayer of Mending op Ctrl-2, 40.]] },
		{ "Beginnersfouten", [[
- Healen in Shadowform. Geen enkele heal-spell werkt in Shadowform. Fear Ward en de race-spell van de Dwarf (Chastise) werken er ook niet in. Ga er eerst uit: druk nog eens op Ctrl-1.
- Smite missen nadat je Mind Flay kiest. Zodra je Mind Flay kent, cast toets 1 Mind Flay, niet Smite.
- Shoot (5) indrukken zonder wand. Koop of vind er eerst een.
- Vroeg een interrupt zoeken op E. De Priest krijgt er pas een via het talent Silence (op z'n vroegst 30).
- Shackle Undead (Shift-Q) op een gewone vijand. Hij werkt alleen op Undead vijanden.]] },
	},
	SHAMAN = {
		{ "Wat hij doet", [[
De Shaman cast bliksem en vuur, healt, en zet totems neer. Hij kan van een afstand vechten of van dichtbij met een wapen. In Forever kunnen Dwarves (Alliance) ook Shaman zijn.
De Shaman heeft geen stances. **Ghost Wolf** (level 20, op R) is een form om te rennen, maar hij verandert je toetsen niet.]] },
		{ "Totems en weapon buffs", [[
Een **totem** is een klein voorwerp dat je op de grond zet. Zolang hij staat, helpt hij jou of je groep, of doet hij vijanden pijn. Totems horen bij vier elementen: Earth, Fire, Water en Air. Je kunt één totem van elk element tegelijk hebben. Een nieuwe vervangt de oude.
- Elk element heeft een Totem-item dat je uit een class-quest krijgt: Earth (level 4, of 3 voor de Skyborne), Fire (10), Water (20), Air (30). Je hebt dat item in je tassen nodig voor alle totems van dat element.
- Voor level 20 heeft elke totem een eigen toets: Stoneskin (Z), Earthbind (V), Stoneclaw (F), Strength of Earth (Shift-X), Searing (5), Tremor (Shift-F).
- Vanaf level 20 geeft het spel je een **totem bar**. Daarop kies je één totem per element. Dan zet één toets ze allemaal neer: **Ctrl-1** = Call of the Elements (20), **Ctrl-2** = Call of the Ancestors (30), **Ctrl-3** = Call of the Spirits (40). Elk zet tot 4 totems neer van zijn eigen pagina van de totem bar. Hij heeft een cast van 3 seconden en kost de mana van alle totems die hij neerzet.
- **Shift-R** = Totemic Call (22): verplaatst je totems naar jou. Totemic Recall (20, blok D) haalt ze terug en geeft je een kwart van hun mana terug.
Een **weapon buff** zet 60 minuten lang kracht op je wapen. Je hebt er één tegelijk. Rockbiter (1), Flametongue (10), Frostbrand (20) en Windfury (30) komen op je eigen Alt-toetsen (blok D). Kies degene die past bij hoe je speelt.]] },
		{ "Level 1-10: je knoppen", [[
- **1** = Lightning Bolt (level 1): je belangrijkste aanvalsspell.
- **C** = Healing Wave (1): je grote heal.
- Rockbiter Weapon (1) komt op blok D (zie hierboven).
- **E** = Earth Shock (4): je **interrupt** (hij stopt de spell van een vijand), en schade.
- **Z** = Stoneskin Totem (4, uit een quest): je krijgt minder schade van melee-klappen. **Melee** = van dichtbij vechten.
- **V** = Earthbind Totem (6): vertraagt vijanden in de buurt. Cooldown 15 seconden.
- **F** = Stoneclaw Totem (8): laat vijanden eromheen de totem aanvallen. Cooldown 30 seconden.
- **Shift-Z** = Lightning Shield (8): een schild op jezelf. Maar één schild tegelijk.
- **2** = Flame Shock (10): fire-schade, en daarna nog meer schade over een paar seconden.
- **5** = Searing Totem (10, uit een quest): je schade-totem.
- **Shift-X** = Strength of Earth Totem (10): een totem die je groep een buff geeft. Een **buff** is een goed effect.
- Flametongue Weapon (10) komt op blok D.
- **Shift-E** = je race-spell (bijvoorbeeld War Stomp voor een Tauren, Stoneform voor een Dwarf).]] },
		{ "Simpele volgorde", [[
Weapon buff aan (blok D), Lightning Shield aan (Shift-Z). Searing Totem (5) neerzetten. Flame Shock (2), dan Lightning Bolt (1). Bewaar Earth Shock (E) voor als de vijand een spell cast. Weinig health? Healing Wave (C).]] },
		{ "Wat er later komt", [[
- 12: Fire Nova op Shift-4, Purge op Shift-Q (haalt magie van een vijand af), Ancestral Spirit op F3 (brengt een dode vriend terug). 16: Cure Poison op Shift-C. 18: Tremor Totem op Shift-F (haalt fear, charm en sleep weg bij je groep).
- 20: Ghost Wolf op R (cast van 3 seconden, alleen in de open lucht), Frost Shock op 4 (vertraagt), Lesser Healing Wave op F2 (snelle heal), Healing Stream Totem op F4 (uit een quest; healt je groep beetje bij beetje; heeft de Water Totem nodig), Call of the Elements op Ctrl-1.
- 22: Cure Disease op Shift-V, Totemic Call op Shift-R. 30: Grounding Totem op X (vangt één schadelijke spell op die op jou of een groepslid in de buurt gericht is; geen spells op een gebied; heeft de Air Totem uit de quest van level 30 nodig), Call of the Ancestors op Ctrl-2. 32: Chain Lightning op Shift-1 (raakt meerdere vijanden).
- 40: Chain Heal op Shift-2 (healt meerdere vrienden), Call of the Spirits op Ctrl-3.
- Talents: Water Shield (neemt Shift-Z over), op z'n vroegst 20. Stormstrike op 3 en Mana Tide Totem op F1, 25. Nature's Swiftness op Shift-3, 30. Riptide op Shift-F1, en Lightning Mastery of Rage of the Farseer op Q, 40.]] },
		{ "Beginnersfouten", [[
- Een shock gebruiken vlak voordat je moet interrupten. Earth Shock (E), Flame Shock (2) en Frost Shock (4) delen één cooldown van 6 seconden. Na Flame Shock heb je tot 6 seconden lang geen interrupt.
- Fire Nova (Shift-4) indrukken zonder Fire-totem op de grond. Hij heeft een van je Fire-totems nodig (zoals Searing of Magma). Hij raakt de vijanden bij die totem, niet die bij jou.
- Een totem neerzetten zonder zijn Totem-item. Elk element heeft een eigen Totem-item in je tassen nodig, uit een class-quest.
- Casten in Ghost Wolf. Je spells zijn niet voor de wolf gemaakt. Ga eerst uit Ghost Wolf, cast dan.
- De weapon buff vergeten. Hij duurt 60 minuten en staat niet op het blok: hij staat op je eigen Alt-toetsen (blok D).
- Twee schilden verwachten. Zodra je Water Shield hebt, cast Shift-Z die, niet Lightning Shield.]] },
	},
	WARLOCK = {
		{ "Wat hij doet", [[
De Warlock staat achteraan en cast shadow- en fire-magie. Veel van zijn schade komt langzaam: spells die de vijand over tijd pijn doen, en curses. Hij heeft bijna altijd een demon bij zich.
Een **DoT** (damage over time) is een spell die de vijand een tijdje beetje bij beetje pijn doet. Een **curse** of **bane** is een slecht effect dat je op een vijand zet. Eén curse en één bane kunnen op dezelfde vijand staan. De Warlock heeft geen vormen en geen stances, dus elke toets doet altijd hetzelfde.]] },
		{ "Je demon", [[
Je **pet** is een demon die je oproept. Hij vecht naast je. De demonen leer je uit class-quests.
- **Summon Imp** (1): uit je eerste class-quest in je startgebied. De naam hangt af van je race: Human "The Stolen Tome", Gnome "Beginnings", Orc en Troll "Vile Familiars", Undead "Piercing the Veil". De Imp kost geen Soul Shard.
- **Summon Voidwalker** (10, quest). **Summon Succubus** of **Summon Incubus** (20, quest). **Summon Felhunter** (30, quest). Elk hiervan kost 1 **Soul Shard** (zie Drain Soul hieronder).
- **Inferno** (50) staat op **F3**. Elke cast heeft een Infernal Stone nodig. Cooldown 1 uur.
- De summons staan niet op het blok. Ze komen op je eigen Alt-toetsen (blok D).
- Vanaf je eerste demon heeft je pet drie toetsen: **Ctrl-1** = val je target aan, **Ctrl-2** = volg mij, **Ctrl-3** = blijf waar je bent.
- De Voidwalker kan taunten (Torment). De Felhunter kan de spell van een vijand stoppen (Spell Lock, vanaf 36). Dat zijn de eigen spells van je demon, op Blizzards pet bar.]] },
		{ "Level 1-10: je knoppen", [[
- **1** = Shadow Bolt (level 1): je belangrijkste aanvalsspell.
- **3** = Immolate (1): fire-schade, en daarna nog meer schade over tijd.
- **Shift-Z** = Demon Skin (1): een buff op jezelf (meer armor). Een **buff** is een goed effect. Vanaf 20 neemt Demon Armor deze toets over.
- **2** = Corruption (4): een DoT.
- **Shift-V** = Curse of Weakness (4): je curse. Vanaf 20 neemt Curse of the Elements deze toets over.
- **F** = Life Tap (6): maakt een deel van je health tot mana.
- **5** = Bane of Agony (8): je bane, een DoT.
- **V** = Fear (8): je **CC**-toets. CC (crowd control) = een spell die een vijand een tijdje uit het gevecht haalt.
- **4** = Drain Soul (10): gebruik hem om een vijand die XP geeft af te maken, en je krijgt een **Soul Shard**. Een Soul Shard is een klein item in je tassen. Je hebt er een nodig om de meeste demonen op te roepen (alle behalve de Imp) en om een Healthstone of Soulstone te maken. Grijze (te makkelijke) vijanden geven geen shard.
- Create Healthstone (10, kost een Soul Shard) komt op blok D. Je healthstone staat dan op **Shift-T**, net als bij elke class.
- **Shift-E** = je race-spell (bijvoorbeeld Blood Fury voor een Orc, Will of the Forsaken voor een Undead).]] },
		{ "Simpele volgorde", [[
Demon erbij (blok D; alle behalve de Imp hebben een Soul Shard nodig), stuur hem dan op de vijand af (Ctrl-1). Corruption (2), Bane of Agony (5), Immolate (3), dan Shadow Bolt (1). Weinig mana? Life Tap (F). Weinig health? Drain Life (C, vanaf 14).]] },
		{ "Wat er later komt", [[
- 12: Health Funnel op F2 (healt je demon). 14: Drain Life op C (je eigen grote heal).
- 16: Unending Breath op Shift-R. 18: Searing Pain (blok D), en Create Soulstone (kost een Soul Shard; niet op het blok, zet hem zelf op je eigen balk).
- Curse of Tongues en Ritual of Summoning (haal een groepslid naar je toe) gebruik je zelden: die staan ook niet op het blok. Zet ze op je eigen balk als je ze wilt.
- 20: Rain of Fire op Shift-1 (raakt meerdere vijanden), Demon Armor op Shift-Z, Curse of the Elements op Shift-V.
- 28: Banish op Shift-Q. 30: Hellfire op Shift-2. 32: Shadow Ward op Z (vangt shadow-schade op; cooldown 30 seconden).
- 40: Howl of Terror op Shift-F (geeft meerdere vijanden fear). 42: Death Coil op X (een horror, zoals fear, en een heal; cooldown 2 minuten).
- 48: Soul Fire op Q (je grootste klap; kost een Soul Shard; cast van 6 seconden; cooldown 1 minuut). 50: Inferno op F3. 60: Bane of Doom op F1.
- Talents: Shadowburn op Shift-4 (kost een Soul Shard), Amplify Curse op Shift-3, Demonic Sacrifice op Shift-C, op z'n vroegst 20. Curse of Exhaustion op R (vertraagt de vijand, zodat je bij hem weg kunt blijven), Fel Domination op Shift-F1 (roep snel een demon op), 25. Siphon Life op F4 (een DoT die jou healt), Soul Link op Shift-X, 30. Conflagrate (25), Bane of Havoc (30), Wrack (40) en Incinerate (40), allemaal op z'n vroegst, komen op blok D.]] },
		{ "Beginnersfouten", [[
- Een demon oproepen zonder Soul Shard. Alle demonen behalve de Imp kosten er een. Gebruik Drain Soul (4) om vijanden die XP geven af te maken.
- Een interrupt zoeken op E. De Warlock heeft er zelf geen, dus E blijft leeg. Alleen de Felhunter heeft er een.
- Health Funnel (F2) indrukken om jezelf te healen. Hij healt je demon. Je eigen heal is Drain Life (C).
- Banish (Shift-Q) op een gewone vijand. Hij werkt alleen op demons en elementals.
- Bane of Doom (F1) op een speler. Hij kan niet op spelers gecast worden.
- Je wand missen. Shoot staat niet op het blok. Sleep hem zelf uit je spellbook naar je eigen balk.]] },
	},
}
