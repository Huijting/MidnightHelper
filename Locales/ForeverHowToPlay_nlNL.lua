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
		{ "Kamperen", [[
- **Kamperen** is geen beroep. Elk beroep kan één **kampobject** maken. Cooking maakt het vuur.
- **Begin** met de quest **The Great Outdoors**, in elke startzone.
- **1. Het vuur.** Maak met Cooking een **Basic Campfire Kit**: 1 Simple Wood, met **Flint and Tinder** als gereedschap (dat houd je). Gebruik de kit buiten, niet in combat. Het vuur heeft plek voor 3 objecten (Journeyman Campfire 5, Expert Campfire 10). Cooldown: 5 minuten.
- **2. Een object.** Maak het met je beroep. Je hebt skill 20 nodig om het neer te zetten. Zet het bij het vuur. Het item gaat op.
- **3. Ga zitten** bij het vuur. Je krijgt **Welcoming Campfire** voor 60 seconden. Craften mag, lopen niet. Daarna krijg je **Camp Benefits** voor 1 uur, met één regel per object.
- **Regels:** alle objecten delen een cooldown van 1 uur. Elk soort object maar één keer per kamp.
- **Botsen:** een kampbuff en de class-buff hieronder kun je niet tegelijk hebben. De meeste kampbuffs groeien mee met je level.
- Skinning: **Camp Chair** = kans op een critical strike. Botst met Moonkin Aura.
- Blacksmithing: **Sharpening Wheel** = Strength. Botst met Strength of Earth Totem.
- Herbalism: **Incense Candle** = Intellect. Botst met Arcane Intellect.
- Alchemy: **Mana Well** = mana elke 5 seconden. Botst met Blessing of Wisdom.
- Mining: **Lodestone** = melee attack power. Botst met Blessing of Might.
- Fishing: **Fish Bowl** = alle stats. Botst met Blessing of Kings.
- First Aid: **First Aid Kit** = Stamina. Botst met Power Word: Fortitude.
- Tailoring: **Faction Banner** = Spirit, alleen voor je eigen factie. Botst met Divine Spirit.
- Enchanting: **Enchanted Lute** = armor, alle stats en resistances. Botst met Mark of the Wild.
- Leatherworking: **Camp Tent** = rust er 30 seconden bij voor extra rested XP, één keer per uur.
- Engineering: **Reagent Bot** = geen buff, hij verkoopt reagents.
- **/mh camp** laat zien wat MH van je kampbuffs kan lezen.]] },
		{ "Legacy Points", [[
- **Legacy Points** verdien je met je hele account: 65 challenges, 1 punt per stuk. Elk character geeft zijn eigen punten uit, voorlopig tot 16.
- **Zo krijg je ze:** een class die voor het eerst 25, 45 en 60 wordt. Alchemy, Blacksmithing, Enchanting, Engineering, Leatherworking en Tailoring op 150, 225 en 300. Nog een paar voor PvP, dungeons, raids en verkennen.
- Verzamelberoepen, Cooking, First Aid en Fishing geven geen punten.
- Het venster gaat open bij je eerste punt. Voor de meeste spelers is dat op level 25.
- **Uitgeven:** druk op de knop **Legacy** in de menubalk. Er zijn drie bomen: **Professions**, **Adventure** en **Resourcefulness**. Elke rang kost 1 punt.
- **Kolom 2** gaat open na 5 punten in die boom, **kolom 3** na 10.
- **Terugdraaien:** bij je class trainer, alle perks tegelijk. De trainer laat de prijs zien. Heb je Talented? Draai dan eerst je class-talenten terug.
- **Beloningen** bij 15, 25, 40 en 55 verdiende punten (verdiend, niet uitgegeven). Haal ze op bij **Innkeeper Wiley** in Ratchet.
- **Voorbeeld, levelen:** **Well Rested** (rested XP bouwt sneller op), daarna **Talented** (vraagt Well Rested): talentpunten tot 5 levels eerder, nooit meer dan 51 in totaal.
- **Voorbeeld, beroepen:** **Working Overtime** (vaker een skill-up) en **Bountiful Harvest** (vaker Scarce materials uit Mining, Herbalism en Skinning).
- **Dedicated Study** is een knop, geen passieve perk: 25 seconden casten, daarna 23 uur wachten. Hij verhoogt je laagste beroep met 1.
- **/mh legacy** laat zien hoeveel punten MH kan lezen.]] },
		-- 21 Nov 2026: new 4th section (mh-writer, from ForeverHowToPlay.lua). nlNL keeps the English game names.
		{ "Talenten: resetten en Dual Spec", [[
- **Je talenten resetten** doe je bij je class-trainer: praat met hem en kies de talent-optie. Daarna verdeel je je punten opnieuw. Spelers zeggen dat het de eerste keer 1 goud kost, dan 5, dan 10, en daarna meer. Blizzard zegt dat de prijs snel stijgt en één keer per week omlaag gaat.
- **Dual Spec:** vanaf level 40 verkoopt je class-trainer een tweede set talenten. In het spel heet dat **Secondary Talents**. Spelers zeggen dat het 50 goud kost; Blizzard noemde geen prijs.
- **Wisselen** tussen je twee sets duurt 5 seconden en werkt niet in een gevecht.
- **Je balken na een wissel:** spelers melden dat wisselen je action bars kan veranderen: het spel kan er spells op zetten, over je eigen knoppen en macro's heen. MH heeft dit zelf niet in het spel gezien. Kijk je balken na na je eerste wissel.
- **Waarom:** level met de ene set en tank of heal met de andere. Een Paladin levelt als Retribution en tankt als Protection, een Druid levelt als kat en healt als Restoration.]] },
	},
	-- 21 Nov 2026: "Level as X, tank as Y" (mh-writer, from ForeverHowToPlay.lua PLANS).
	PLANS = {
		PALADIN = { title = "Level als Retribution, tank als Protection", body = [[
- **Levelen:** de gidsen noemen Retribution de snelste manier om alleen te levelen: één traag **tweehandig wapen** en Seal of Righteousness, later Seal of Command (20, een talent). Zet je talentpunten in Retribution.
- **Een dungeon tanken** gaat vanaf je eerste, zonder respec: Ragefire Chasm voor de Horde (vanaf level 13), de Hall of Thanes voor de Alliance (rond 13). Righteous Fury en Seal of Fury komen allebei op 10. Houd een **eenhandig wapen en een schild in je tassen**. Vóór de dungeon: wissel naar die twee, zet Righteous Fury aan (blok D) en Seal of Fury (**F**). Erna: terug naar het tweehandige wapen, en Righteous Fury uit (rechtsklik erop, rechtsboven in beeld). Met Righteous Fury aan trek je de vijanden weg van je groep.
- **Wanneer het makkelijk wordt:** op 30 met Holy Shield (een Protection-talent), en echt op 40 met Shieldsworn. Wil je dat, dan heb je Protection-talenten nodig: **Dual Spec** (vanaf 40) geeft je een tweede set, zodat je als Retribution levelt en als Protection tankt. Zie "Talenten: resetten en Dual Spec" hieronder.
- **Stats om te tanken:** eerst Stamina. De gidsen zijn het oneens over wat daarna komt: wowforeverbuilder zegt Defense, Stamina, spell power, Intellect (geen Strength), een andere gids zet spell power en Intellect boven Strength. Met spell power houden Consecration en Holy Shield vijanden beter vast.
- **Tweehandig zwaard uit Wolfsbane** (de Undead class-quest op 20): leer eerst Two-Handed Swords, bij Archibald in Undercity. MH zegt het je in Doe dit nu.]] },
		WARRIOR = { title = "Levelen en tanken als Warrior", body = [[
- **Levelen:** de gidsen zijn het oneens. De meeste zeggen dat Protection het snelst levelt: een tweehandig wapen tot Revenge op 14, daarna een **eenhandig wapen en een schild**. Eén gids vindt Protection alleen trager. Arms of Fury werkt ook; houd dan een eenhandig wapen en een schild in je tassen om te tanken.
- **Een dungeon tanken** gaat vanaf je eerste: Ragefire Chasm (Horde) vanaf level 13, de Hall of Thanes (Alliance) vanaf ongeveer 13, de Deadmines vanaf 16, Wailing Caverns vanaf 17. De class-quest op 10 geeft je Defensive Stance, Taunt en Sunder Armor. In Forever maakt Defensive Stance veel meer threat dan in het oude spel, dus vijanden blijven bij jou.
- **Wanneer het makkelijk wordt:** op 14-16 met Revenge en Shield Block, en echt op 40 met Shield Slam (een talent) en Plate Mail.
- **Talenten:** met Protection-talenten level en tank je met één set. Levelde je als Arms of Fury? Dan geeft **Dual Spec** (vanaf 40) je een tweede set om te tanken. Zie "Talenten: resetten en Dual Spec" hieronder.
- **Stats om te tanken:** eerst Stamina. Over de rest zijn de gidsen het oneens: de ene zet Defense als laatste, een andere wil Defense vroeg tot 440. Voor threat: hit en expertise.]] },
		DRUID = { title = "Levelen en tanken als Druid", body = [[
- **Levelen:** de gidsen kiezen Feral: de beer vanaf level 10, de kat vanaf 20. Feral-talenten werken voor allebei, dus je levelt als kat en tankt als beer met dezelfde talenten. Je hebt geen schild en geen tweede wapen nodig.
- **Je wapen telt in een form.** Blizzard: in Bear Form en Cat Form doen je gewone klappen de schade van het wapen dat je vasthoudt. Houd dus de beste tweehandige staf of mace, ook om te tanken.
- **Een dungeon tanken** gaat vanaf je eerste: Ragefire Chasm voor de Horde (vanaf level 13), de Hall of Thanes voor de Alliance (rond 13). Bear Form komt uit de class-quest op 10, met Growl en Maul (één gids zegt alleen Maul: kijk je spells na). In Forever maakt Bear Form veel meer threat dan in het oude spel.
- **Wanneer het makkelijk wordt:** Swipe op 16 (meer vijanden tegelijk), Lacerate op 25 (een talent), en echt op 40 met Dire Bear Form en Primal Bite (een talent).
- **Healen in een groep?** Daarvoor heb je Restoration-talenten en Intellect-gear nodig: **Dual Spec** (vanaf 40) geeft je een tweede set. Zie "Talenten: resetten en Dual Spec" hieronder.
- **Stats om te tanken:** de gidsen zijn het oneens. Om te overleven: armor, dan Defense tot 440, dan Stamina, dan Agility. Voor threat: wapenschade, dan Agility, dan Strength. Een andere gids zegt wapenschade, Strength, Agility terwijl je levelt.]] },
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
- 16: Aquatic Form (uit een quest) op R als je zwemt. 18: Faerie Fire op 5 (werkt in de meeste forms, maar niet in Travel of Aquatic Form), Hibernate op Shift-Q.
- 20: Cat Form (uit een quest) op Ctrl-2, met Claw, Shred, Rip en Prowl. Feral Charge op E (een talent, op z'n vroegst 20). Starfire op 3. In een gevecht wordt F3 Rebirth.
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
- 30: Divine Intervention: in een gevecht cast F3 deze in plaats van Redemption. Let op: je gaat zelf dood; de vriend die je kiest kan even door niets geraakt worden. 34: Divine Shield op Z: 10 seconden waarin niets je pijn kan doen, en je kunt nog steeds vechten (met de helft van je schade).
- 42: Cleanse vervangt Purify op Shift-C. 44: Hammer of Wrath op 4 (alleen als de vijand op 20% health of minder staat).
- 52-60: in een groep casten de blessing-toetsen de Greater Blessing voor de hele groep; alleen casten ze de gewone.]] },
		{ "Beginnersfouten", [[
- Exorcism (5) indrukken op een gewone vijand. Hij werkt alleen op Undead en Demons. Turn Undead (Shift-Q, 24) werkt alleen op Undead.
- Hammer of Wrath (4) vroeg in het gevecht indrukken. Hij werkt alleen als de vijand bijna dood is (20% health of minder).
- Divine Shield en Divine Protection delen één cooldown, dus ze staan op één toets (Z). Deze beschermspells, Blessing of Protection en Templar's Bulwark geven **Forbearance**: 1 minuut lang kun je er geen van allen opnieuw krijgen. Lay on Hands niet.]] },
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
- **Level 10, pet-quests:** je leert Tame Beast, Call Pet en Dismiss Pet; de quest daarna (Training the Beast) geeft Revive Pet en Feed Pet. **F4** = Call Pet (haalt je pet), **F3** = Revive Pet (brengt een dode pet terug). Tame Beast heeft geen toets; die gebruik je buiten een gevecht.
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
- Healen in Shadowform. Geen enkele heal-spell werkt in Shadowform. Fear Ward werkt er ook niet in. Ga er eerst uit: druk nog eens op Ctrl-1.
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
	-- Per rol (16 nov 2026), zelfde vorm als ROLES in Modules/ForeverHowToPlay.lua: zelfde band, zelfde volgorde.
	ROLES = {
		DRUID = {
			{ band = 2, title = "Beer: tank", body = [[
Vanaf level 10 (Bear Form, uit een quest). Een **tank** is degene die de vijanden slaan, zodat de rest van de groep veilig blijft. Om te levelen noemen de gidsen de kat soepeler; de beer is handig van 10 tot 20, en om te tanken in dungeons. De beer gebruikt **Rage**: die krijg je als je slaat en als je geslagen wordt.
**Simpele volgorde:**
1. Pull met Faerie Fire (**5**, vanaf 18) of Feral Charge (**E**, vanaf 20). **Pullen** = één vijand van een afstand raken, zodat hij naar jou toe komt.
2. Demoralizing Roar (**Shift-2**) één keer.
3. Primal Bite (**3**, vanaf 40) steeds als hij klaar is.
4. Lacerate (**2**, vanaf 25) tot hij 5 stacks heeft.
5. Rage over: Maul (**1**) op één vijand, Swipe (**Shift-1**, vanaf 16) op twee of meer.
6. Growl (**F**) als een vijand iemand anders slaat.
**Per 10 levels:**
- 10: Bear Form (**Ctrl-1**), Maul (**1**), Growl (**F**), Demoralizing Roar (**Shift-2**). Daarna Enrage (**Q**) op 12, Bash (**V**) op 14, Swipe (**Shift-1**) op 16, Faerie Fire (**5**) op 18.
- 20: Feral Charge (**E**, een talent): je stormt op de vijand af, hij kan 4 seconden niet bewegen en niet casten. Cooldown 15 seconden. Talent-levels hier zijn op z'n vroegst; een perk kan ze tot 5 levels eerder maken.
- 30: Leader of the Pack (een talent). Daarvoor: Lacerate (**2**, een talent) op 25, Challenging Roar (**Shift-F**) op 28.
- 40: Dire Bear Form vervangt Bear Form op **Ctrl-1**. Primal Bite (**3**, een talent). Daarvoor: Frenzied Regeneration (**X**) op 36: maakt van Rage health.
- 50: sterkere ranks van Primal Bite, Lacerate en Maul. Barkskin (**Z**) op 44.
- 60: weer sterkere ranks; niets nieuws voor deze rol.
**Beginnersfouten:**
- Feral Charge als de vijand dichterbij is dan 8 yards. Daar werkt hij niet.
- Enrage (**Q**) terwijl je harde klappen krijgt. Hij geeft Rage, maar je krijgt 27% minder armor.]] },
			{ band = 2, title = "Kat: schade van dichtbij", body = [[
Vanaf level 20 (Cat Form, uit een quest; Prowl krijg je erbij). Om te levelen is dit de eerste keus van de gidsen: ze noemen hem de snelste en de soepelste. De kat gebruikt **Energy**, die vanzelf vol loopt. Je klappen geven **combo points** (tot 5); een **finisher** gebruikt ze allemaal.
**Simpele volgorde:**
1. Prowl (**Shift-R**), open dan met Shred (**3**) van achteren. **Prowl** = sluipen, zodat de vijand je niet ziet.
2. Faerie Fire (**5**) op taaie vijanden.
3. Rake (**2**, vanaf 24), maar niet als de vijand bijna dood is.
4. Claw (**1**) voor combo points; Shred (**3**) als je achter de vijand staat.
5. Bij 4-5 combo points: Rip (**4**) als de vijand nog lang leeft, anders Ferocious Bite (**Shift-4**, vanaf 24).
6. Shifting Power (**Q**, vanaf 40) als je Energy onder de 50 is.
**Per 10 levels:**
- 10: niets nieuws voor deze rol (de kat komt op 20).
- 20: Cat Form (**Ctrl-2**), Claw (**1**), Shred (**3**, van achteren), Rip (**4**), Prowl (**Shift-R**). Feral Charge (**E**, een talent): als kat spring je achter de vijand. Omen of Clarity is passief: geen toets.
- 30: Leader of the Pack (een talent). Daarvoor: Rake (**2**) en Ferocious Bite (**Shift-4**) op 24, Dash (**R**) op 26, Cower (**F**) op 28.
- 40: Shifting Power (**Q**, een talent): 40 Energy voor mana, cooldown 8 seconden, alleen als kat. Daarvoor: Ravage (blok D) op 32, Pounce (**V**, vanuit Prowl, een stun) op 36. Talent-levels hier zijn op z'n vroegst; een perk kan ze tot 5 levels eerder maken.
- 50: sterkere ranks van Ferocious Bite, Rip en Shred; niets nieuws voor deze rol.
- 60: weer sterkere ranks; niets nieuws voor deze rol.
**Beginnersfouten:**
- Shred van voren. Hij werkt alleen van achteren; van voren gebruik je Claw.
- Te vaak Shifting Power. Dan heb je geen mana meer om jezelf te healen.]] },
			{ band = 1, title = "Balance: schade van een afstand", body = [[
Vanaf level 1: Wrath heb je vanaf het begin, Moonfire komt op 4. Moonkin Form is een talent, op z'n vroegst 40. De gidsen zeggen dat levelen als Balance werkt, maar trager is dan de kat. Sommige gidsen nemen Moonkin Form later (Zygor op 53): 40 is geen regel.
**Simpele volgorde:**
1. Starfire (**3**, vanaf 20) als opener op één vijand.
2. Moonfire (**2**).
3. Insect Swarm (**4**, vanaf 25).
4. Wrath (**1**) als opvuller. Met Eclipse (vanaf 30): Wrath bouwt ladingen op, dan Starfire (**3**).
5. Hurricane (**Shift-1**, vanaf 40) op groepen.
Weinig mana? Blijf Wrath gebruiken: die is goedkoop.
**Per 10 levels:**
- 10: Wrath (**1**), Moonfire (**2**), Thorns (**Shift-Z**), Entangling Roots (**V**), Nature's Grasp (**X**).
- 20: Starfire (**3**). Omen of Clarity is passief: geen toets.
- 30: Eclipse (een talent): Wrath maakt je volgende 2 Starfires sneller. Daarvoor: Insect Swarm (**4**, een talent) op 25. Talent-levels hier zijn op z'n vroegst; een perk kan ze tot 5 levels eerder maken.
- 40: Moonkin Form (**Ctrl-3**, een talent): kost mana, geeft je groep +3% crit (**crit** = een sterkere geluksklap), maar geen heals erin. Hurricane (**Shift-1**), Innervate (**F1**).
- 50: sterkere ranks van Hurricane en Starfire. Barkskin (**Z**) op 44.
- 60: weer sterkere ranks; niets nieuws voor deze rol.
**Beginnersfouten:**
- Healen in Moonkin Form. Dat kan niet, en weer terug de form in gaan kost mana.
- Een toets voor Omen of Clarity zoeken. Hij is passief: hij werkt vanzelf.]] },
			{ band = 3, title = "Restoration: healer", body = [[
Vanaf level 1: Healing Touch heb je vanaf het begin. De gidsen raden healen niet aan om alleen te levelen (vijanden gaan langzaam dood): level met Wrath en Moonfire, en heal in dungeons. Een **HoT** is een heal die beetje bij beetje healt.
**Simpele volgorde (in een groep):**
1. Rejuvenation (**F4**) op de tank.
2. Regrowth (**F2**) op iemand die laag staat.
3. Swiftmend (**Shift-F1**, vanaf 25): alleen op iemand die jouw Rejuvenation of Regrowth heeft.
4. Wild Growth (**Shift-2**, vanaf 40) als meer mensen schade krijgen.
5. Healing Touch (**C**) bij grote schade. Nood: Nature's Swiftness (**Shift-3**, vanaf 30), dan Healing Touch.
6. Innervate (**F1**, vanaf 40) als je mana laag is.
**Per 10 levels:**
- 10: Healing Touch (**C**), Rejuvenation (**F4**). Daarna Regrowth (**F2**) en Revive (**F3**, buiten een gevecht) op 12, Cure Poison (**Shift-C**) op 14.
- 20: Rebirth (**F3**, in een gevecht). Daarna Remove Curse (**Shift-V**) op 24, Abolish Poison (**Shift-C**) op 26.
- 30: Nature's Swiftness (**Shift-3**, een talent), Tranquility (**Q**). Daarvoor: Swiftmend (**Shift-F1**, een talent) op 25. Talent-levels hier zijn op z'n vroegst; een perk kan ze tot 5 levels eerder maken.
- 40: Wild Growth (**Shift-2**, een talent), Innervate (**F1**).
- 50: Gift of the Wild (**Shift-X**), een sterkere Wild Growth.
- 60: weer sterkere ranks; niets nieuws voor deze rol.
**Beginnersfouten:**
- Healen in een form. Heals werken alleen in je gewone vorm.
- Een HoT casten op iemand die hem nog heeft. De nieuwe vervangt de oude.]] },
		},
		-- Warrior, Mage, Priest (17 nov 2026), zelfde band en volgorde als in Modules/ForeverHowToPlay.lua.
		WARRIOR = {
			{ band = 3, title = "Protection: tank", body = [[
Vanaf level 10 (Defensive Stance, uit een quest; dezelfde quest geeft Taunt en Sunder Armor). Een **tank** is degene die de vijanden slaan, zodat de rest van de groep veilig blijft. Je draagt een eenhandig wapen en een schild. **Threat** = hoe graag een vijand jou wil aanvallen; als tank heb je die op elke vijand nodig. De gidsen zijn het oneens over welke boom alleen het snelst levelt: sommige noemen Protection de snelste, andere zeggen dat hij alleen trager is. Hij komt op gang rond level 16, als je Shield Block naast Revenge hebt.
**Simpele volgorde:**
1. Defensive Stance (**Ctrl-2**), Battle Shout (**Shift-X**). Bloodrage (**F1**) voor Rage om mee te beginnen.
2. Pull. **Pullen** = één vijand van een afstand raken, zodat hij naar jou toe komt. Charge (**R**) werkt alleen in Battle Stance (**Ctrl-1**); ga daarna terug naar Defensive Stance (**Ctrl-2**). Met Vanguard (vanaf 25) werkt Charge ook in Defensive Stance. Of pull met je ranged wapen (blok D).
3. Meerdere vijanden: Demoralizing Shout (**Shift-2**, vanaf 14) één keer, Thunder Clap (**Shift-1**) steeds als hij klaar is.
4. Shield Block (**Z**, vanaf 16), en Revenge (**2**, vanaf 14) zodra hij oplicht.
5. Shield Slam (**3**, vanaf 40) steeds als hij klaar is.
6. Sunder Armor (**5**) op je hoofddoel; tot 5 stacks op een baas.
7. Taunt (**F**) als een vijand iemand anders aanvalt.
8. Rage over: Heroic Strike (**1**) op één vijand, Cleave (**Shift-4**, vanaf 20) op twee of meer.
**Per 10 levels:**
- 10: Defensive Stance (**Ctrl-2**), Taunt (**F**), Sunder Armor (**5**), Bloodrage (**F1**). Daarna Shield Bash (**E**) op 12, Revenge (**2**) en Demoralizing Shout (**Shift-2**) op 14, Shield Block (**Z**) op 16, Disarm (**V**) op 18.
- 20: Last Stand (**X**, een talent): 30% meer max health, 20 seconden lang. Victory Rush (**F2**), Cleave (**Shift-4**). Daarna Intimidating Shout (**Shift-Q**) op 22, Vanguard (een talent, passief) op 25, Challenging Shout (**Shift-F**) op 26, Shield Wall (**C**) op 28. Talent-levels hier zijn op z'n vroegst; een perk kan ze tot 5 levels eerder maken.
- 30: Concussion Blow (**Shift-V**, een talent): een stun van 5 seconden. Berserker Stance (**Ctrl-3**, uit een quest). Daarna Bastion (een talent, passief) op 35.
- 40: Shield Slam (**3**, een talent). Plate Mail bij de trainer: je kunt plate dragen.
- 50: niets nieuws voor deze rol. Sterkere ranks van Shield Slam, Revenge, Sunder Armor en Thunder Clap.
- 60: weer sterkere ranks; niets nieuws voor deze rol.
**Beginnersfouten:**
- Denken dat Thunder Clap de hele groep vijanden raakt. Hij raakt er 4; een vijfde kan naar de healer lopen.
- Vijanden achter je laten staan. Van achteren kun je niet blocken, dodgen of parryen, en Revenge licht dan niet op.
- Taunt op een vijand die jou al aanvalt. Dan doet hij niets.]] },
			{ band = 1, title = "Arms: schade met één groot wapen", body = [[
Vanaf level 1. Je draagt één groot tweehandig wapen en staat bijna altijd in Battle Stance. De grote stappen zijn Sweeping Strikes op 30 en Mortal Strike op 40. Een nieuw wapen is je grootste winst. Je hebt geen eigen heal behalve Victory Rush (vanaf 20), dus eten en verband blijven handig. De gidsen zijn het oneens over welke boom het snelst levelt; alle drie werken.
**Simpele volgorde:**
1. Battle Stance (**Ctrl-1**), Battle Shout (**Shift-X**).
2. Charge (**R**) om te beginnen.
3. Rend (**Shift-Z**), als de vijand nog even leeft.
4. Overpower (**2**, vanaf 12) zodra hij oplicht.
5. Mortal Strike (**3**, vanaf 40) steeds als hij klaar is; houd er 30 Rage voor over.
6. Victory Rush (**F2**, vanaf 20) na een kill, als je health mist.
7. Twee vijanden: Sweeping Strikes (**Q**, vanaf 30), dan Cleave (**Shift-4**, vanaf 20). Vóór 30: Thunder Clap (**Shift-1**).
8. Rage over: Heroic Strike (**1**).
**Per 10 levels:**
- 10: Heroic Strike (**1**), Charge (**R**), Rend (**Shift-Z**), Thunder Clap (**Shift-1**), Hamstring (**V**), Battle Shout (**Shift-X**), Bloodrage (**F1**). Daarna Overpower (**2**) op 12, Demoralizing Shout (**Shift-2**) op 14.
- 20: Victory Rush (**F2**), Cleave (**Shift-4**), Slam (**Shift-C**), Retaliation (**C**). Daarna Execute (**4**) op 24, Spearing Strike (**F3**, een talent) op 25: een extra harde klap op Giants en Dragonkin. Talent-levels hier zijn op z'n vroegst; een perk kan ze tot 5 levels eerder maken.
- 30: Sweeping Strikes (**Q**, een talent, alleen Battle Stance): je volgende 5 klappen raken ook een vijand naast je doel. Berserker Stance (**Ctrl-3**, uit een quest) met Intercept (**R**) en Berserker Rage (**Shift-V**). Daarna Improved Slam (een talent, passief) op 35, Whirlwind (**2** in Berserker Stance) op 36, Pummel (**E** in Berserker Stance) op 38.
- 40: Mortal Strike (**3**, een talent): de vijand krijgt 10 seconden lang 50% minder healing. Plate Mail bij de trainer.
- 50: Recklessness (**Q** in Berserker Stance). Sterkere ranks van Mortal Strike.
- 60: weer sterkere ranks; niets nieuws voor deze rol.
**Beginnersfouten:**
- Steeds Heroic Strike (**1**) indrukken. Die klap geeft geen Rage, dus er blijft niets over voor Mortal Strike of Overpower.
- Slam (**Shift-C**) vóór het talent Improved Slam: een cast van 1,5 seconde die je gewone klap vertraagt. De meeste gidsen slaan hem tot dan over.
- Een interrupt zoeken op **E** met een tweehandig wapen. Shield Bash heeft een schild nodig; jouw interrupt is Pummel (38, Berserker Stance).]] },
			{ band = 2, title = "Fury: schade met twee wapens", body = [[
Een wapen in elke hand, vanaf level 20 (Dual Wield bij de trainer). Tot dan gebruik je je beste wapen (een tweehandig wapen is prima) en speel je als Arms. Fury wordt pas echt sterk met Whirlwind (36) en Bloodthirst (40). Je hebt twee goede wapens nodig. Whirlwind, Pummel, Intercept en Berserker Rage werken alleen in Berserker Stance, dus je wisselt vaak van stance.
**Simpele volgorde (vanaf 36; daarvoor speel je als Arms):**
1. Battle Shout (**Shift-X**). Bloodrage (**F1**) voor Rage.
2. Charge (**R**) in Battle Stance (**Ctrl-1**).
3. Death Wish (**Shift-3**, vanaf 30) op een sterke vijand.
4. Berserker Stance (**Ctrl-3**): Whirlwind (**2**, vanaf 36) steeds als hij klaar is.
5. Bloodthirst (**3**, vanaf 40) steeds als hij klaar is. De gidsen verschillen over welke van deze twee eerst komt.
6. Victory Rush (**F2**) na een kill, als je health mist.
7. Rage over: Heroic Strike (**1**); op twee vijanden Cleave (**Shift-4**).
8. Weinig Rage: Reckless Swings (**Shift-F1**, vanaf 25; kost health).
**Per 10 levels:**
- 10: niets nieuws voor deze rol: je speelt als Arms, met één wapen.
- 20: Dual Wield bij de trainer: nu kan er een wapen in je andere hand. Piercing Howl (**Shift-R**, een talent): vertraagt alle vijanden bij je. Victory Rush (**F2**), Cleave (**Shift-4**). Daarna Execute (**4**) op 24, Reckless Swings (**Shift-F1**, een talent) op 25. Talent-levels hier zijn op z'n vroegst; een perk kan ze tot 5 levels eerder maken.
- 30: Death Wish (**Shift-3**, een talent). Berserker Stance (**Ctrl-3**, uit een quest) met Intercept (**R**) en Berserker Rage (**Shift-V**). Daarna Whirlwind (**2** in Berserker Stance) op 36, Pummel (**E** in Berserker Stance) op 38.
- 40: Bloodthirst (**3**, een talent; je hebt eerst Death Wish nodig). Hij healt niet; je loopt er sneller door. Plate Mail bij de trainer.
- 50: Recklessness (**Q** in Berserker Stance). Sterkere ranks van Bloodthirst.
- 60: weer sterkere ranks; niets nieuws voor deze rol.
**Beginnersfouten:**
- Fury spelen met één goed wapen en een slecht tweede.
- Whirlwind (**2**) zoeken in Battle Stance. Hij werkt alleen in Berserker Stance, en daar werken Rend en Thunder Clap niet.
- Death Wish (**Shift-3**) in een gevecht dat je misschien verliest. Je krijgt 30 seconden lang ook 5% meer schade.]] },
		},
		MAGE = {
			{ band = 1, title = "Arcane: schade van een afstand", body = [[
Vanaf level 8 (Arcane Missiles). Arcane Blast is een talent, op z'n vroegst 20; tot dan speel je zoals elke mage, met Frostbolt, Fireball en Arcane Missiles. De gidsen verschillen: sommige noemen Arcane sterk om te levelen, de meeste raden Frost aan en noemen Arcane hongerig naar mana. De boom heeft geen vertragingen, dus Arcane houdt vijanden het slechtst op afstand. Een **channel** is een spell die loopt zolang je stilstaat; bewegen stopt hem. Arcane Missiles is er een.
**Simpele volgorde:**
1. Open met Frostbolt (**2**): de vijand komt dan langzaam.
2. Arcane Blast (**Ctrl-2**, vanaf 20): één of twee, op een baas tot vier. Elke Arcane Blast maakt de volgende duurder in mana.
3. Licht Missile Barrage op (vanaf 15)? Meteen Arcane Missiles (**3**): gratis en twee keer zo snel.
4. Arcane Wrath (**Shift-F1**, vanaf 25) steeds als hij klaar is.
5. Vijand dicht bij je? Frost Nova (**V**), stap weg.
6. Bijna dood: je wand (**Ctrl-3**, tot 40) of Fire Blast (**5**).
7. Taaie vijand of baas: Presence of Mind (**Shift-3**, vanaf 30), dan Arcane Wrath voor een grote instant klap. Vanaf 40 ook Arcane Power (**Q**).
Meerdere vijanden: Frost Nova (**V**), dan Arcane Explosion (**Shift-2**, vanaf 14). Weinig mana? Evocation (**F1**, vanaf 20).
**Per 10 levels:**
- 10: Frost Nova (**V**). Eerste talent: Improved Channeling (Arcane Missiles wordt niet meer korter als je geraakt wordt). Daarna Arcane Explosion (**Shift-2**) op 14, Missile Barrage (een talent, passief) op 15. Talent-levels hier zijn op z'n vroegst; een perk kan ze tot 5 levels eerder maken.
- 20: Arcane Blast (**Ctrl-2**, een talent). Blink (**R**), Evocation (**F1**), Mana Shield (**Z**). Daarna Counterspell (**E**) op 24, Arcane Wrath (**Shift-F1**, een talent; je hebt eerst Arcane Blast nodig) op 25.
- 30: Presence of Mind (**Shift-3**, een talent): je volgende spell met een cast korter dan 10 seconden is instant. Ice Armor (**Shift-Z**). Daarna Mage Armor (blok D) op 34.
- 40: Arcane Power (**Q**, een talent; je hebt eerst Presence of Mind nodig): 15 seconden lang doen je spells 30% meer schade, maar kosten ze 30% meer mana. Frostfire Bolt neemt **Ctrl-3**: zet je wand (Shoot) op je eigen Alt-toets.
- 50: sterkere ranks van Arcane Blast, Arcane Wrath en Arcane Missiles; niets nieuws voor deze rol.
- 60: weer sterkere ranks; niets nieuws voor deze rol.
**Beginnersfouten:**
- Steeds weer Arcane Blast indrukken. Elke Arcane Blast maakt de volgende 100% duurder; je mana is zo op.
- Lopen tijdens Arcane Missiles. Het is een channel: bewegen stopt hem.
- Arcane Power op een gewone vijand. Hij maakt je spells ook duurder, en hij heeft 3 minuten cooldown.]] },
			{ band = 2, title = "Fire: schade van een afstand", body = [[
Vanaf level 1 (Fireball). Pyroblast is een talent, op z'n vroegst 20. Het echte Fire-spel begint met Heating Up (op z'n vroegst 25); daarvoor is Pyroblast alleen een opener. De gidsen zeggen dat Fire de meeste schade doet op één vijand, en snel levelt maar met meer risico dan Frost: hij heeft geen eigen bevriezingen. **Crit** = een sterkere geluksklap.
**Simpele volgorde:**
1. Open van ver met Pyroblast (**4**, vanaf 20). Daarvoor: Fireball (**1**).
2. Fireball (**1**) als je gewone spell.
3. Fire Blast (**5**) steeds als hij klaar is. Vanaf 25 geeft elke Fire Blast een Heating Up-stack.
4. Twee of drie Heating Up-stacks (vanaf 25)? Pyroblast (**4**).
5. Vijand dichtbij: Scorch (**Ctrl-1**, vanaf 22) in plaats van Fireball, of Frost Nova (**V**) en stap weg. Vanaf 30 daarna Blast Wave (**F3**).
6. Bijna dood: je wand (**Ctrl-3**, tot 40) of Fire Blast.
7. Elite of baas, vanaf 40: Combustion (**Q**).
Meerdere vijanden: Frost Nova (**V**), Flamestrike (**Shift-4**, vanaf 16), Blast Wave (**F3**, vanaf 30).
**Per 10 levels:**
- 10: Frost Nova (**V**). Eerste talent: Accelerant (Fireball cast sneller). Daarna Ignite en Impact (talents) op 15, Flamestrike (**Shift-4**) op 16. Talent-levels hier zijn op z'n vroegst; een perk kan ze tot 5 levels eerder maken.
- 20: Pyroblast (**4**, een talent): een cast van 6 seconden, dus alleen als opener. Blink (**R**), Evocation (**F1**), Fire Ward (**F4**), Mana Shield (**Z**). Daarna Scorch (**Ctrl-1**) op 22, Counterspell (**E**) op 24, Heating Up (een talent, passief; je hebt eerst Pyroblast nodig) op 25: een crit met Fireball, Frostfire Bolt, Fire Blast of Scorch maakt je volgende Pyroblast 25% sneller, tot 3 stacks.
- 30: Blast Wave (**F3**, een talent): instant, om je heen; vijanden lopen 6 seconden lang 50% trager. Critical Mass (een talent). Ice Armor (**Shift-Z**). Daarna Fire Power (een talent) op 35.
- 40: Combustion (**Q**, een talent; je hebt eerst Critical Mass nodig). Frostfire Bolt neemt **Ctrl-3**: zet je wand (Shoot) op je eigen Alt-toets.
- 50: sterkere ranks van Fireball, Pyroblast, Blast Wave en Frostfire Bolt; niets nieuws voor deze rol.
- 60: weer sterkere ranks; niets nieuws voor deze rol.
**Beginnersfouten:**
- Pyroblast casten als de vijand al bij je is. Een cast van 6 seconden is dan te traag.
- Denken dat drie Heating Up-stacks Pyroblast instant maken. Het blijft een cast van 1,5 seconde: blijf stilstaan.
- Een Ice Block zoeken. Fire heeft er geen. Je uitweg: Frost Nova (**V**), Blink (**R**), Blast Wave (**F3**).]] },
			{ band = 3, title = "Frost: schade van een afstand", body = [[
Vanaf level 4 (Frostbolt); Frost Nova komt op 10. Ice Lance is een talent, op z'n vroegst 20. Om te levelen is dit de eerste keus van de meeste gidsen: ze noemen hem de veiligste. Hij komt echt op gang rond 30. **Frozen** = de vijand is op zijn plek bevroren en kan niet lopen.
**Simpele volgorde:**
1. Frostbolt (**2**) van zo ver mogelijk. Elke treffer vertraagt de vijand.
2. Vijand Frozen (door Frost Nova, of door het talent Frostbite)? Ice Lance (**F**, vanaf 20).
3. Vijand dichtbij? Frost Nova (**V**), stap weg, Frostbolt, dan Ice Lance.
4. Licht Fingers of Frost op (vanaf 30)? Ice Lance.
5. Ice Lance niet klaar en de vijand is dichtbij: Cone of Cold (**Shift-F**, vanaf 26).
6. Bijna dood: je wand (**Ctrl-3**, tot 40) of Fire Blast (**5**).
Meerdere vijanden (vanaf 20): Frost Nova (**V**), stap weg, Blizzard (**Shift-1**), dan Cone of Cold (**Shift-F**). In nood: Ice Block (**C**, vanaf 25), Blink (**R**).
**Per 10 levels:**
- 10: Frost Nova (**V**). Eerste talent: Improved Frostbolt (een kortere cast). Daarna Frostbite (een talent) op 15: je vertragingen kunnen de vijand 5 seconden bevriezen. Talent-levels hier zijn op z'n vroegst; een perk kan ze tot 5 levels eerder maken.
- 20: Ice Lance (**F**, een talent): 300% meer schade op een Frozen vijand. Blizzard (**Shift-1**), Blink (**R**), Evocation (**F1**), Mana Shield (**Z**). Daarna Frost Ward (**F2**) op 22, Counterspell (**E**) op 24, Ice Block (**C**, een talent) op 25, Cone of Cold (**Shift-F**) op 26.
- 30: Cold Snap (**Shift-C**, een talent): zet de cooldown van je andere Frost-spells op nul; zijn eigen cooldown is 10 minuten. Fingers of Frost (een talent; je hebt eerst Ice Lance nodig): je volgende 2 spells doen alsof de vijand Frozen is. Ice Armor (**Shift-Z**). Daarna Winter's Chill (een talent) op 35.
- 40: Ice Barrier (**X**, een talent; je hebt eerst Cold Snap nodig): een schild dat schade opvangt. Frostfire Bolt neemt **Ctrl-3**: zet je wand (Shoot) op je eigen Alt-toets.
- 50: sterkere ranks van Frostbolt, Cone of Cold, Ice Armor, Ice Barrier en Blizzard; niets nieuws voor deze rol.
- 60: weer sterkere ranks; niets nieuws voor deze rol.
**Beginnersfouten:**
- Ice Lance op een vijand die niet Frozen is. Dan is het een kleine klap.
- Fire Blast indrukken vlak voor een bevriezing. Fire Blast en Ice Lance delen één cooldown van 8 seconden.
- Cold Snap voor niets gebruiken. Hij heeft 10 minuten cooldown: bewaar hem voor als het misgaat.]] },
		},
		PRIEST = {
			{ band = 1, title = "Discipline: healer", body = [[
Vanaf level 1: Lesser Heal heb je vanaf het begin. De eigen spells komen later: Soul Warding op 25 en Penance op 30, allebei op z'n vroegst. In een groep is hij het sterkst in het healen van één persoon, de tank. Alleen levelen kan met Smite, Holy Fire en je wand, later Penance; de gidsen zijn het oneens of dat sneller is dan Shadow. **Weakened Soul**: na een Power Word: Shield kan dezelfde persoon 15 seconden lang geen nieuw schild krijgen.
**Simpele volgorde (in een groep):**
1. Power Word: Shield (**Z**) op de tank, vlak voor de pull. **Pull** = de eerste klap die een gevecht begint.
2. Renew (**F4**) op de tank.
3. Penance (**Shift-F1**, vanaf 30) op wie gewond is, steeds als hij klaar is.
4. Je grote heal (**C**) bij gewone schade.
5. Flash Heal (**F2**, vanaf 20) als C te langzaam is.
6. Meer mensen gewond: Prayer of Healing (**Shift-2**, vanaf 30).
7. Inner Focus (**F1**, vanaf 20) vóór een dure heal. Power Infusion (**Q**, vanaf 40) op jezelf of een caster.
Alleen: Shield (**Z**), Holy Fire (**4**, vanaf 20), Smite (**1**), Mind Blast (**3**), Shadow Word: Pain (**2**), Penance als je hem niet nodig hebt om te healen, dan je wand (**5**).
**Per 10 levels:**
- 10: Lesser Heal (**C**), Power Word: Shield (**Z**), Renew (**F4**), Resurrection (**F3**, alleen buiten een gevecht), Smite (**1**). Daarna Inner Fire (**Shift-Z**) op 12, Cure Disease (**Shift-C**) op 14, Heal (**C**) op 16, Dispel Magic (**Shift-V**) op 18.
- 20: Flash Heal (**F2**), Holy Fire (**4**), Fear Ward (blok D). Inner Focus (**F1**, een talent): je volgende spell kost geen mana en crit vaker; cooldown 3 minuten. Daarna Soul Warding (een talent, passief) op 25: Shield heeft geen cooldown en is goedkoper. Talent-levels hier zijn op z'n vroegst; een perk kan ze tot 5 levels eerder maken.
- 30: Penance (**Shift-F1**, een talent): healt een vriend of doet schade op een vijand; cooldown 12 seconden. Prayer of Healing (**Shift-2**), Divine Spirit (blok D). Daarna Abolish Disease (**Shift-C**) op 32, Divine Aegis (een talent, passief) op 35.
- 40: Power Infusion (**Q**, een talent; je hebt eerst Penance nodig): 20% meer spell-schade en healing; cooldown 3 minuten. Greater Heal neemt **C** over.
- 50: sterkere ranks van Penance, Prayer of Healing, Flash Heal en Renew. Prayer of Fortitude (**Shift-X**) op 48.
- 60: weer sterkere ranks; niets nieuws voor deze rol.
**Beginnersfouten:**
- Dezelfde speler twee keer achter elkaar een schild geven. Weakened Soul houdt dat tegen. Het geldt per speler: een ander kan meteen een schild krijgen.
- Penance op een vijand om je groep te healen. Hij healt óf doet schade, niet allebei.
- Prayer of Healing op de verkeerde speler. Hij healt de groep van de speler die je kiest.]] },
			{ band = 2, title = "Holy: healer", body = [[
Vanaf level 1: Lesser Heal heb je vanaf het begin. Holy is de groeps-healer. Alleen levelt hij traag: de gidsen raden aan te questen met Smite en je wand, en te healen in dungeons. De eigen spells komen laat: Holy Nova op 20 en Prayer of Mending op 40, allebei op z'n vroegst.
**Simpele volgorde (in een groep):**
1. Renew (**F4**) op de tank als de pull begint. **Pull** = de eerste klap die een gevecht begint.
2. Prayer of Mending (**Ctrl-2**, vanaf 40) op de tank vóór de pull, en opnieuw steeds als hij klaar is.
3. Je grote heal (**C**) bij gewone schade.
4. Flash Heal (**F2**, vanaf 20) als C te laat zou komen.
5. Hele groep gewond: Prayer of Healing (**Shift-2**, vanaf 30). Holy Nova (**Shift-1**, vanaf 20) alleen als iedereen vlak bij je staat; hij kost veel mana.
6. Power Word: Shield (**Z**) om tijd te winnen.
7. Valt een vijand jou aan: Fade (**F**).
**Per 10 levels:**
- 10: Lesser Heal (**C**), Power Word: Shield (**Z**), Renew (**F4**), Resurrection (**F3**, alleen buiten een gevecht). Daarna Inner Fire (**Shift-Z**) op 12, Cure Disease (**Shift-C**) op 14, Heal (**C**) op 16, Dispel Magic (**Shift-V**) op 18.
- 20: Holy Nova (**Shift-1**, een talent): instant; doet schade op vijanden om je heen en healt je groep, zonder threat. Flash Heal (**F2**), Holy Fire (**4**), Fear Ward (blok D). Daarna Holy Binding (een talent, passief) op 25: Flash Heal op een ander healt jou voor de helft. Talent-levels hier zijn op z'n vroegst; een perk kan ze tot 5 levels eerder maken.
- 30: Prayer of Healing (**Shift-2**), Divine Spirit (blok D). Spirit of Redemption (een talent, passief). Daarna Abolish Disease (**Shift-C**) op 32, Spiritual Healing (een talent, passief) op 35.
- 40: Prayer of Mending (**Ctrl-2**, een talent; je hebt eerst Spirit of Redemption nodig): healt zodra het doel schade krijgt, en springt dan naar een ander groepslid, tot 5 keer; cooldown 10 seconden. Greater Heal neemt **C** over.
- 50: sterkere ranks van Prayer of Mending, Holy Nova, Prayer of Healing en Renew. Prayer of Fortitude (**Shift-X**) op 48.
- 60: weer sterkere ranks; niets nieuws voor deze rol.
**Beginnersfouten:**
- Prayer of Healing op de verkeerde speler. Hij healt de groep van de speler die je kiest, niet je eigen groep.
- Flash Heal voor alles gebruiken. Hij is snel maar duur; bewaar hem voor nood.
- Holy Nova op een groep die ver weg staat. Hij werkt alleen vlak om je heen, en hij is duur.]] },
			{ band = 3, title = "Shadow: schade van een afstand", body = [[
Vanaf level 4 (Shadow Word: Pain); Mind Blast komt op 10. Mind Flay is een talent, op z'n vroegst 20; Shadowform op 40. De meeste gidsen levelen als Shadow; sommige spelen Discipline tot 40. In het begin doet je wand veel van het werk. Shadow heeft geen spell die veel vijanden tegelijk raakt. Een **DoT** is schade in kleine stukjes over een paar seconden. Een **channel** is een spell die loopt zolang je stilstaat.
**Simpele volgorde:**
1. Power Word: Shield (**Z**) op jezelf, als de vijand bij je gaat komen.
2. Mind Blast (**3**) van ver, om te beginnen.
3. Shadow Word: Pain (**2**).
4. Devouring Plague (**Shift-3**, vanaf 20) op een vijand die nog even leeft.
5. Mind Flay (**1**, vanaf 20), en laat hem helemaal uitlopen. Daarvoor: Smite (**1**).
6. Maak af met je wand (**5**).
Weinig mana? Sla Devouring Plague en Mind Flay over, en gebruik eerder je wand. Vanaf 32: Shadow Word: Death (**Shift-4**) alleen als de vijand er dood van gaat. Vanaf 40: Shadowform (**Ctrl-1**) aan vóór de eerste pull, en laat hem aan.
**Per 10 levels:**
- 10: Mind Blast (**3**), cooldown 8 seconden. Je hebt al Smite (**1**), Shadow Word: Pain (**2**), Power Word: Shield (**Z**), Fade (**F**) en je wand (**5**). Daarna Inner Fire (**Shift-Z**) op 12, Psychic Scream (**V**) op 14.
- 20: Mind Flay (een talent): neemt toets **1** over van Smite. Devouring Plague (**Shift-3**): een DoT die jou ook healt; cooldown 24 seconden. Daarna Vampiric Embrace (**Ctrl-3**, een talent) op 25 of 30: je groep wordt geheald voor 20% van je Shadow-schade. Talent-levels hier zijn op z'n vroegst; een perk kan ze tot 5 levels eerder maken.
- 30: Silence (**E**, een talent): je **interrupt** (hij stopt de spell van een vijand); cooldown 45 seconden. Mind Control (**Shift-F**). Daarna Shadow Word: Death (**Shift-4**) op 32, Levitate (**R**) op 34.
- 40: Shadowform (**Ctrl-1**, een talent; je hebt eerst Vampiric Embrace nodig): 10% meer Shadow-schade, Shadow-spells half zo duur, 15% minder fysieke schade, maar geen heal-spells. Daarvoor: Darkness (een talent, passief) op 35.
- 50: sterkere ranks van Mind Flay, Mind Blast, Shadow Word: Pain, Devouring Plague en Shadow Word: Death. Prayer of Fortitude (**Shift-X**) op 48.
- 60: sterkere ranks van Mind Flay en Devouring Plague; niets nieuws voor deze rol.
**Beginnersfouten:**
- Shadow Word: Death op een vijand met veel health. Gaat hij niet dood, dan verlies je 30% van je eigen health.
- Mind Flay te vroeg afbreken. Met het talent Improved Mind Flay is de laatste tik de sterkste.
- In een groep openen met Mind Blast. Hij geeft veel threat (hoe graag een vijand jou wil aanvallen): laat de tank eerst gaan. Valt een vijand jou aan: Fade (**F**).]] },
		},
		-- Rogue (17 nov 2026), zelfde band en volgorde als in Modules/ForeverHowToPlay.lua.
		ROGUE = {
			{ band = 1, title = "Assassination: dolken en gif", body = [[
Vanaf level 1 (Sinister Strike en Eviscerate). Je vecht van dichtbij, met dolken en gif. Je gebruikt **Energy**, die vanzelf vol loopt. Je klappen geven **combo points** (tot 5) op de vijand die je raakt; een **finisher** gebruikt ze allemaal. Mutilate is een talent, op z'n vroegst 40, en heeft een dolk in elke hand nodig. Tot dan speel je met Backstab of Sinister Strike. De gidsen noemen dit niet de makkelijkste start: de grote stap komt pas met Mutilate.
**Simpele volgorde:**
1. Vanaf 20: gif op beide wapens (items, op blok D).
2. Wacht op volle Energy. Vanaf 18 (Poised) kost je eerste aanval dan 10 Energy minder.
3. Stealth (**Shift-R**), loop achter de vijand. **Stealth** = sluipen, zodat de vijand je niet ziet. Open met Ambush (**2**, vanaf 18, dolk in je hoofdhand) of Garrote (**1**, vanaf 14). Sterke vijand, vanaf 26: Cheap Shot (**V**), een stun van 4 seconden.
4. Combo points: Backstab (**2**) als je achter de vijand staat, anders Sinister Strike (**1**). Vanaf 40: Mutilate (**3**), 2 punten per keer.
5. Shank (**Shift-3**, vanaf 24) steeds als hij klaar is. Met Venom (vanaf 30) maakt elke Shank je gif 6 seconden lang sterker.
6. Finisher: Slice and Dice (**Shift-4**) in een lang gevecht; anders Eviscerate (**4**) bij 5 punten. Rupture (**5**, vanaf 20) op een vijand die lang leeft (een elite, een baas).
7. Cold Blood (**F1**, vanaf 25) vlak voor een Eviscerate met 5 punten.
**Per 10 levels:**
- 10: je hebt al Sinister Strike (**1**), Eviscerate (**4**), Backstab (**2**), Stealth (**Shift-R**), Gouge (**Shift-Q**) en Evasion (**Z**). Nieuw op 10: Slice and Dice (**Shift-4**), Sprint (**R**), Sap (**Shift-Q** in Stealth), en een wapen in elke hand (Dual Wield). Daarna Kick (**E**) op 12, Garrote (**1** in Stealth) en Expose Armor (**Shift-Z**) op 14, Feint (**F**) op 16, Ambush (**2** in Stealth) en Poised (passief) op 18.
- 20: Rupture (**5**). Poisons, uit een quest. Daarna Vanish (**X**) op 22, Shank (**Shift-3**) op 24, Cold Blood (**F1**, een talent) op 25: je volgende Sinister Strike, Backstab, Ambush, Eviscerate of Mutilate is zeker een crit (**crit** = een sterkere geluksklap); cooldown 3 minuten. Cheap Shot (**V** in Stealth) op 26. Talent-levels hier zijn op z'n vroegst; een perk kan ze tot 5 levels eerder maken.
- 30: Venom (een talent, passief: geen toets): elke Shank geeft je gif 6 seconden lang 30% meer schade en 20% meer kans om aan te slaan. Kidney Shot (**V**). Daarna Blind (**Shift-V**) op 34, Seal Fate (een talent, passief) op 35: een crit met een aanval die combo points geeft, geeft je een extra punt.
- 40: Mutilate (**3**, een talent; je hebt eerst Venom nodig): 60 Energy, slaat met beide dolken, 2 combo points, 20% meer schade op een vergiftigde vijand. Daarna Slice and Dice rank 2 op 42, Shank rank 2 op 44.
- 50: Mutilate rank 2 en Kidney Shot rank 2; niets nieuws voor deze rol.
- 60: Mutilate rank 3 en sterkere ranks; niets nieuws voor deze rol.
**Beginnersfouten:**
- Mutilate zonder dolken. Hij heeft een dolk in elke hand nodig: haal je tweede dolk vóór level 40.
- Shank vergeten. Venom werkt alleen via Shank.
- Naar een andere vijand gaan met combo points op de oude. De punten gaan niet mee.]] },
			{ band = 2, title = "Combat: vaste schade met elk wapen", body = [[
Vanaf level 1 (Sinister Strike en Eviscerate). Je hoeft niet achter de vijand te staan: je hoofdklap is Sinister Strike. Hij werkt met elk eenhandig wapen: een zwaard, bijl, knots, vuistwapen of dolk. Een aantal gidsen noemt Combat de makkelijkste boom om alleen mee te levelen. Ze raden een langzaam wapen in je hoofdhand aan en een snel wapen in je andere hand. Je gebruikt **Energy**, die vanzelf vol loopt; je klappen geven **combo points**, en een **finisher** gebruikt ze. Blade Flurry (op z'n vroegst 30) is het enige wat een Rogue heeft tegen twee vijanden tegelijk.
**Simpele volgorde:**
1. Wacht op volle Energy (Poised, vanaf 18).
2. Open uit Stealth (**Shift-R**) met Garrote (**1**, vanaf 14), of vanaf 26 met Cheap Shot (**V**). Gewoon naar de vijand lopen en aanvallen mag ook.
3. Sinister Strike (**1**) voor combo points.
4. Riposte (**Shift-F1**, vanaf 20) zodra hij oplicht: dat gebeurt nadat je een aanval pareert.
5. Shank (**Shift-3**, vanaf 24) als hij klaar is.
6. Finisher: Slice and Dice (**Shift-4**) in een lang gevecht; anders Eviscerate (**4**) bij 5 punten. De gidsen verschillen over hoe vroeg je Slice and Dice aan houdt.
7. Twee vijanden: Blade Flurry (**Shift-1**, vanaf 30). Vanaf 40 samen met Adrenaline Rush (**Q**) voor een zwaar gevecht. Verlies je? Evasion (**Z**).
**Per 10 levels:**
- 10: je hebt al Sinister Strike (**1**), Eviscerate (**4**), Stealth (**Shift-R**), Gouge (**Shift-Q**) en Evasion (**Z**). Nieuw op 10: Slice and Dice (**Shift-4**), Sprint (**R**), Sap (**Shift-Q** in Stealth), en een wapen in elke hand. Daarna Kick (**E**) op 12, Garrote (**1** in Stealth) en Expose Armor (**Shift-Z**) op 14, Feint (**F**) op 16, Poised (passief) op 18.
- 20: Riposte (**Shift-F1**, een talent; je hebt eerst Deflection nodig): werkt alleen vlak nadat je een aanval pareert. 10 Energy, en de vijand is 6 seconden ontwapend. Rupture (**5**), en Poisons uit een quest. Daarna Vanish (**X**) op 22, Shank (**Shift-3**) op 24, Flawless Execution (een talent, passief) op 25: Eviscerate kost 15 Energy minder. Cheap Shot (**V** in Stealth) op 26. Talent-levels hier zijn op z'n vroegst; een perk kan ze tot 5 levels eerder maken.
- 30: Blade Flurry (**Shift-1**, een talent): 15 seconden lang sla je 20% sneller, en elke klap raakt ook een tweede vijand vlakbij; cooldown 2 minuten. Hack and Slash (een talent, passief): een bonus die van je wapen afhangt. Kidney Shot (**V**). Daarna Blind (**Shift-V**) op 34, Flash of Steel (een talent, passief) op 35: Shank geeft tot 15 Energy extra en is tot 2 seconden eerder klaar.
- 40: Adrenaline Rush (**Q**, een talent; je hebt eerst Blade Flurry nodig): 15 seconden lang loopt je Energy twee keer zo snel vol; cooldown 5 minuten. Daarna Slice and Dice rank 2 op 42 (30% sneller in plaats van 20%), Shank rank 2 op 44 (25 Energy terug in plaats van 15).
- 50: Kidney Shot rank 2 en sterkere ranks; niets nieuws voor deze rol.
- 60: sterkere ranks; niets nieuws voor deze rol.
**Beginnersfouten:**
- Blade Flurry naast een vijand die je met Sap, Gouge of Blind hebt uitgeschakeld. De extra klappen maken hem wakker.
- Riposte indrukken als er niets gepareerd is. Hij werkt alleen vlak na een parry.
- Backstab of Ambush met een zwaard, bijl of knots. Allebei hebben ze een dolk in je hoofdhand nodig.]] },
			{ band = 3, title = "Subtlety: toeslaan uit Stealth", body = [[
Vanaf level 1 (Sinister Strike en Stealth). Deze boom vecht vanuit Stealth: een sterke eerste klap, en veel combo points nog vóór het gevecht echt begint. **Stealth** = sluipen, zodat de vijand je niet ziet. De gidsen zeggen dat alleen levelen trager gaat dan met Combat. Hemorrhage is een talent, op z'n vroegst 30: goedkoop, van voren, met elk wapen, maar met een dolk slaat hij harder. Death Mark is een talent, op z'n vroegst 40. Ambush en Backstab hebben een dolk in je hoofdhand nodig; Hemorrhage en Ghostly Strike niet.
**Simpele volgorde:**
1. Stealth (**Shift-R**). Staat er een tweede Humanoid bij? Sap (**Shift-Q**). Sap breekt Stealth niet.
2. Premeditation (**Shift-C**, vanaf 20): 2 combo points op de vijand. Daarna je eerste klap.
3. Eerste klap van achteren: Ambush (**2**, vanaf 18, dolk in je hoofdhand). Sterke vijand, vanaf 26: Cheap Shot (**V**), een stun van 4 seconden. De gidsen verschillen over de beste opener.
4. Ghostly Strike (**Shift-X**, vanaf 25) en Shank (**Shift-3**, vanaf 24) steeds als ze klaar zijn.
5. Combo points: vanaf 30 Hemorrhage (**3**). Daarvoor: Backstab (**2**) als je achter de vijand staat, anders Sinister Strike (**1**).
6. Finisher: Eviscerate (**4**) als de vijand bijna dood is; Rupture (**5**) op een vijand die lang leeft; Slice and Dice (**Shift-4**) in een lang gevecht.
7. Vanaf 40: Death Mark (**Q**) op de sterkste vijand, het liefst terwijl Rupture of Garrote loopt.
8. Nood: Vanish (**X**). Preparation (**F3**, vanaf 30) maakt Vanish, Evasion en Sprint meteen weer klaar.
**Per 10 levels:**
- 10: je hebt al Sinister Strike (**1**), Eviscerate (**4**), Backstab (**2**), Stealth (**Shift-R**), Gouge (**Shift-Q**) en Evasion (**Z**). Nieuw op 10: Sap (**Shift-Q** in Stealth), Slice and Dice (**Shift-4**), Sprint (**R**), en een wapen in elke hand. Daarna Kick (**E**) op 12, Garrote (**1** in Stealth) op 14, Feint (**F**) op 16, Ambush (**2** in Stealth) en Poised (passief) op 18.
- 20: Premeditation (**Shift-C**, een talent): 2 combo points op je doel; gebruik ze binnen 20 seconden, anders zijn ze weg; cooldown 2 minuten. Rupture (**5**), en Poisons uit een quest. Daarna Vanish (**X**) op 22, Shank (**Shift-3**) op 24, Ghostly Strike (**Shift-X**, een talent) op 25: 40 Energy, 1 combo point, 7 seconden lang 15% meer dodge; cooldown 20 seconden. Cheap Shot (**V** in Stealth) op 26. Talent-levels hier zijn op z'n vroegst; een perk kan ze tot 5 levels eerder maken.
- 30: Hemorrhage (**3**, een talent; je hebt eerst Serrated Blades nodig): 35 Energy, 1 combo point, werkt van voren; 15 seconden lang doen je Rupture en Garrote 15% meer schade op die vijand. Preparation (**F3**, een talent): zet de cooldown van je andere Rogue-spells meteen op nul; zijn eigen cooldown is 10 minuten. Eén van deze twee krijg je op 30, de andere op 31. Kidney Shot (**V**). Daarna Blind (**Shift-V**) op 34, Boot Knife (een talent, passief) op 35: Shank kan 2 combo points geven.
- 40: Death Mark (**Q**, een talent; je hebt eerst Preparation nodig): een finisher, 25 Energy, cooldown 10 seconden. Hij bewaart 6 seconden lang een deel van je schade (meer per combo point) en deelt die daarna in één keer uit, tot een maximum. Schade van Rupture en Garrote telt dubbel. Daarna Slice and Dice rank 2 en Vanish rank 2 op 42, Shank rank 2 op 44, Death Mark rank 2 op 48.
- 50: Kidney Shot rank 2, Death Mark rank 3 op 56; niets nieuws voor deze rol.
- 60: Death Mark rank 4 en sterkere ranks; niets nieuws voor deze rol.
**Beginnersfouten:**
- Ambush of Backstab zonder dolk in je hoofdhand, of van voren.
- Premeditation gebruiken en dan wachten. De 2 punten zijn na 20 seconden weg, en de cooldown is 2 minuten.
- Death Mark zonder combo points. Het is een finisher.]] },
		},
		-- Hunter (17 nov 2026), zelfde band en volgorde als in Modules/ForeverHowToPlay.lua.
		HUNTER = {
			{ band = 1, title = "Beast Mastery: schade met je pet", body = [[
Vanaf level 10 (je pet, uit de class-quests). Je pet doet het meeste werk: hij houdt de vijand bezig terwijl jij van een afstand schiet. De meeste gidsen kiezen Beast Mastery om te levelen: ze noemen hem de makkelijkste en de snelste. Wowhead zegt erbij dat alle drie de bomen werken. Nieuw in Forever: Summon Hawk (een talent, op z'n vroegst 25) stuurt extra vogels op je doel. Zwak punt: groepen vijanden. Je pet kan er maar één vasthouden.
**Simpele volgorde:**
Vooraf: Aspect of the Hawk aan (**Shift-R**). Het talent Deadly Aspects werkt alleen dan.
1. Hunter's Mark (**Shift-Z**).
2. Pet erop (**Ctrl-1**), en wacht tot hij de vijand heeft.
3. Serpent Sting (**2**).
4. Summon Hawk (**Shift-F1**, vanaf 25): zorg dat er steeds 2 hawks zijn.
5. Aimed Shot (**4**, vanaf 20) als je stilstaat. Twee of meer vijanden: Multi-Shot (**Shift-1**) in plaats daarvan. Ze delen één cooldown.
6. Auto Shot (**1**) loopt door. Arcane Shot (**3**): vóór 25 gewoon gebruiken. Vanaf 25 alleen als je al 2 hawks hebt: hij deelt een cooldown met Summon Hawk.
7. Pet bijna dood: Mend Pet (**F2**). Vijand op jou: Intimidation (**Shift-3**, vanaf 30) of Disengage (**Z**, vanaf 20). Disengage is geen sprong: de vijand wil jou dan minder aanvallen, van dichtbij, en je auto-attack stopt. Echt mis: Feign Death (**X**, vanaf 30).
8. Zware vijand: Bestial Wrath (**F1**, vanaf 40) samen met Rapid Fire (**Q**, vanaf 26).
**Per 10 levels:**
- 10: je pet, uit de class-quests. Aspect of the Hawk (**Shift-R**). Eerste talenten: Deadly Aspects, Endurance Training. Talent-levels hier zijn op z'n vroegst; een perk kan ze tot 5 levels eerder maken. Daarna Mend Pet (**F2**) op 12, Multi-Shot (**Shift-1**) op 18.
- 20: Aimed Shot (**4**, van de trainer), Aspect of the Cheetah (**R**), Disengage (**Z**), Freezing Trap (**V**). Talenten: Bestial Swiftness (je pet loopt 30% sneller; je hebt hem nodig voor Intimidation), Unleashed Fury, Pathfinding.
- 30: Intimidation (**Shift-3**, een talent): je pet stunt de vijand 3 seconden bij zijn volgende klap; cooldown 1 minuut. Feign Death (**X**). Daarvoor: Summon Hawk (**Shift-F1**, een talent) op 25: een hawk blijft 18 seconden, hoogstens 2 tegelijk. Rapid Fire (**Q**) op 26.
- 40: Bestial Wrath (**F1**, een talent; alle 30 punten ervoor moeten in Beast Mastery zitten): je pet doet 18 seconden lang 50% meer schade; cooldown 2 minuten. Volley (blok D). Daarvoor: Explosive Trap neemt **Shift-2** over op 34, Frenzy (een talent, passief) op 35.
- 50: sterkere ranks van Summon Hawk, Aimed Shot en Mend Pet; niets nieuws voor deze rol. Na 40 zetten de gidsen je punten in Marksmanship.
- 60: weer sterkere ranks; niets nieuws voor deze rol.
**Beginnersfouten:**
- Schieten voordat je pet de vijand heeft. Dan komt de vijand naar jou.
- Summon Hawk en Arcane Shot als twee losse knoppen zien. Ze delen één cooldown: hawks eerst.
- Vechten in Aspect of the Cheetah of de Monkey. Deadly Aspects werkt alleen met de Hawk aan.]] },
			{ band = 2, title = "Marksmanship: schade van een afstand", body = [[
Vanaf level 1 (Auto Shot). Je eigen schoten doen het werk, van ver. Aimed Shot komt op 20 van de trainer: het is geen talent. Sniper Shot is een talent, op z'n vroegst 40: een cast van 4 seconden die tot 45 yards reikt. De gidsen zeggen dat levelen kan, maar trager dan met Beast Mastery: je pet houdt de vijand minder goed vast, omdat jij meer schade doet. In groepen is hij sterk: Trueshot Aura helpt je hele party of raid. Lone Wolf (een talent, op z'n vroegst 20) geeft 20% meer schade zolang je geen pet hebt; om te levelen houden de gidsen de pet.
**Simpele volgorde:**
Vooraf: Aspect of the Hawk (**Shift-R**) en Trueshot Aura (**Shift-X**, vanaf 25) aan.
1. Hunter's Mark (**Shift-Z**). Met een pet: pet erop (**Ctrl-1**).
2. Vijand nog ver weg: Sniper Shot (**Shift-4**, vanaf 40) om te openen.
3. Serpent Sting (**2**). Sommige gidsen slaan hem over in korte gevechten.
4. Aimed Shot (**4**, vanaf 20) steeds als hij klaar is. Sta stil.
5. Arcane Shot (**3**) tussendoor, als je mana het toelaat.
6. Auto Shot (**1**) loopt door.
7. Een groep vijanden: Multi-Shot (**Shift-1**) in plaats van Aimed Shot. Een grote groep: Volley (blok D, vanaf 40).
8. Vijand bij jou: Scatter Shot (**E**, vanaf 30), stap dan weg. Concussive Shot (**Shift-Q**) maakt hem trager.
9. Zware vijand: Rapid Fire (**Q**, vanaf 26) aan het begin.
**Per 10 levels:**
- 10: je pet, uit de class-quests. Aspect of the Hawk (**Shift-R**). Eerste talenten: Lethal Attacks, Hawk Eye, Improved Concussive Shot; vanaf 15: Careful Aim, Efficiency, Improved Stings. Talent-levels hier zijn op z'n vroegst; een perk kan ze tot 5 levels eerder maken. Daarna Multi-Shot (**Shift-1**) op 18.
- 20: Aimed Shot (**4**), van de trainer: een cast van 2 seconden, cooldown 6 seconden, gedeeld met Multi-Shot. Talenten: Rapid Killing, Improved Arcane Shot, Lone Wolf. Aspect of the Cheetah (**R**), Disengage (**Z**), Freezing Trap (**V**).
- 30: Scatter Shot (**E**, een talent): de vijand is 4 seconden in de war, en elke schade breekt dat; cooldown 30 seconden. Feign Death (**X**). Daarvoor: Trueshot Aura (**Shift-X**, een talent) op 25: meer Ranged Attack Power voor je party, 30 minuten lang. Rapid Fire (**Q**) op 26.
- 40: Sniper Shot (**Shift-4**, een talent; je hebt eerst Trueshot Aura nodig): cooldown 15 seconden, en je volgende 3 schoten reiken 10 yards verder. Volley (blok D). Daarvoor: Trueshot Aura rank 2 bij de trainer op 32, Ranged Weapon Specialization (een talent, passief) op 35.
- 50: sterkere ranks: Aimed Shot op 44 en 52, Sniper Shot op 48, Trueshot Aura en Volley op 50. Na 40 zetten de gidsen je punten in Beast Mastery.
- 60: weer sterkere ranks; niets nieuws voor deze rol.
**Beginnersfouten:**
- Lopen tijdens Aimed Shot of Sniper Shot. Ze hebben een cast van 2 en 4 seconden.
- Multi-Shot op één vijand. Dan is Aimed Shot ook 6 seconden weg.
- Sniper Shot als de vijand al bij je staat. Het is een cast van 4 seconden, en hij werkt niet binnen 8 yards.]] },
			{ band = 3, title = "Survival: schade van dichtbij, met traps", body = [[
Vanaf level 1 (Raptor Strike), maar het echte Survival-spel begint rond 30. In Forever is dit de melee-Hunter: Raptor Strike, Mongoose Bite, Counterattack en Strider Kick, plus traps. Je houdt je pet en je schietwapen: open van een afstand, stap dan in. De gidsen noemen hem de traagste van de drie om te levelen; tot ongeveer 30 speel je als elke andere Hunter (pet erop, schieten). Hij kost veel mana, en een grote klap van jou kan de vijand van je pet af trekken. De gidsen zijn het oneens over welk melee-wapen het best is.
**Simpele volgorde:**
Vooraf: Aspect of the Hawk (**Shift-R**) zolang je schiet. Vanaf 30 Aspect of the Beast om van dichtbij te vechten; hij heeft geen vaste toets, dus zet hem op je eigen balk.
1. Hunter's Mark (**Shift-Z**). Zonder de Mark werkt Expose Prey niet.
2. Pet erop (**Ctrl-1**).
3. Serpent Sting (**2**), dan Arcane Shot (**3**) terwijl de vijand komt, of terwijl jij erheen loopt.
4. Een trap bij je voeten: Immolation Trap (**Shift-2**, vanaf 16). Vanaf 34 is die toets Explosive Trap, en heeft Immolation Trap geen toets: zet hem op je eigen balk als je hem wilt.
5. Dichtbij: Mongoose Bite (**Shift-C**, vanaf 16) zodra hij oplicht. Raptor Strike (**5**) steeds als hij klaar is. Strider Kick (vanaf 30) steeds als hij klaar is; zet hem op je eigen balk. De gidsen verschillen: sommige stappen na Strider Kick terug om te schieten, andere blijven dichtbij.
6. Counterattack (**Shift-V**) direct na een parry.
7. De vijand rent weg, of jij wilt weer afstand: Wing Clip (**Shift-F**).
8. In nood: Deterrence (**C**, vanaf 20), Feign Death (**X**, vanaf 30).
**Per 10 levels:**
- 10: je pet, uit de class-quests. Raptor Strike (**5**) heb je vanaf level 1. Eerste talenten: Improved Tracking, Deflection; vanaf 15: Savage Strikes, Survivalist, Entrapment, Improved Wing Clip. Talent-levels hier zijn op z'n vroegst; een perk kan ze tot 5 levels eerder maken. Daarna Wing Clip (**Shift-F**) op 12, Mongoose Bite (**Shift-C**) en Immolation Trap (**Shift-2**) op 16.
- 20: Deterrence (**C**, een talent): 10 seconden lang 25% meer dodge en parry; cooldown 5 minuten. Freezing Trap (**V**), Aimed Shot (**4**), Dual Wield (passief, trainer). Disengage (**Z**): geen sprong; hij verlaagt je **threat** (hoe graag een vijand jou wil aanvallen) van dichtbij, en stopt je auto-attack. Talenten: Surefooted, Clever Traps.
- 30: Strider Kick (een talent; geen vaste toets, zet hem op je eigen balk): 100% wapenschade, daarna loop je 3 seconden lang 30% sneller; cooldown 8 seconden. Aspect of the Beast (trainer; zet hem op je eigen balk): meer Melee Attack Power. Feign Death (**X**). Daarvoor: Counterattack (**Shift-V**, een talent), vanaf 25 of 30 (de bronnen verschillen): hij wordt actief nadat je pareert, en zet de vijand 5 seconden vast. Predator's Edge (een talent, passief) vanaf 25. Ook in deze rij: Expose Prey, Resourcefulness, Survivalist's Discipline.
- 40: Lacerating Strikes (een talent, passief; je hebt eerst Expose Prey nodig): Mongoose Bite laat de vijand ook bloeden. Daarvoor: Explosive Trap neemt **Shift-2** over op 34, Lightning Reflexes (een talent, passief) op 35.
- 50: sterkere ranks: Counterattack op 42 en 54, Mongoose Bite op 44, Explosive Trap op 44 en 54, Raptor Strike op 48, Aspect of the Beast op 50. De gidsen zijn het oneens over waar je punten na 40 heen gaan.
- 60: weer sterkere ranks; niets nieuws voor deze rol.
**Beginnersfouten:**
- Meteen naar binnen rennen. Open van een afstand (Mark, pet, Sting, een schot), stap dan in.
- Mongoose Bite of Counterattack indrukken als ze niet oplichten. Mongoose Bite werkt alleen na een dodge (of via Expose Prey), Counterattack alleen na een parry.
- Na level 30 dichtbij in Aspect of the Hawk blijven. De Hawk helpt alleen je schoten; de Beast geeft Melee Attack Power.]] },
		},
		-- Shaman (17 nov 2026), zelfde band en volgorde als in Modules/ForeverHowToPlay.lua.
		SHAMAN = {
			{ band = 1, title = "Elemental: schade van een afstand", body = [[
Vanaf level 1: Lightning Bolt heb je vanaf het begin. Bliksem en vuur van een afstand. Flame Shock komt op 10, Chain Lightning op 32. Lightning Mastery is een talent, op z'n vroegst 40. De gidsen levelen als Enhancement: Elemental kan, maar kost heel veel mana, je moet stilstaan om te casten, en veel vijanden tegelijk is lastig.
**Simpele volgorde:**
Vooraf: Lightning Shield (**Shift-Z**, vanaf 8) aan. Searing Totem (**5**, vanaf 10) neerzetten vóór de pull.
1. Open van een afstand met Lightning Bolt (**1**).
2. Flame Shock (**2**, vanaf 10) op een vijand die lang leeft.
3. Lightning Bolt (**1**) als opvuller.
4. Drie of meer vijanden: Fire Nova (**Shift-4**, vanaf 12) en Chain Lightning (**Shift-1**, vanaf 32) als ze klaar zijn.
5. Lightning Mastery (**Q**, vanaf 40) voor een elite of een grote groep.
6. Bewaar Earth Shock (**E**) voor als de vijand cast: hij onderbreekt de cast.
Weinig health: Healing Wave (**C**). Vijand te dichtbij: Earthbind Totem (**V**) of Frost Shock (**4**, vanaf 20).
**Per 10 levels:**
- 10: Lightning Bolt (**1**), Earth Shock (**E**, vanaf 4), Lightning Shield (**Shift-Z**, vanaf 8). Flame Shock (**2**), Searing Totem (**5**, uit een quest). Eerste talenten: Convection, Concussion (passief). Talent-levels hier zijn op z'n vroegst; een perk kan ze tot 5 levels eerder maken. Daarna Fire Nova (**Shift-4**) en Purge (**Shift-Q**) op 12, Tremor Totem (**Shift-F**) op 18.
- 20: Frost Shock (**4**), Ghost Wolf (**R**), Call of the Elements (**Ctrl-1**). Elemental Focus (een talent, passief). Daarna Totemic Call (**Shift-R**) op 22. Earthbound (een talent) op 25: Earthbind Totem (**V**) zet vijanden 5 seconden vast, alleen op het moment dat je hem neerzet. Magma Totem (blok D) op 26.
- 30: Call of Thunder (een talent, passief). Grounding Totem (**X**), Call of the Ancestors (**Ctrl-2**), Reincarnation (passief). Lightning Overload (een talent, passief). Daarna Chain Lightning (**Shift-1**) op 32, Elemental Fury (een talent, passief) op 35.
- 40: Lightning Mastery (**Q**, een talent): 15 seconden lang cast Lightning Bolt 0,5 seconde sneller en heeft Chain Lightning geen cooldown; cooldown 3 minuten. Call of the Spirits (**Ctrl-3**), Chain Heal (**Shift-2**). Mail-armor bij de trainer.
- 50: sterkere ranks van Lightning Bolt, Chain Lightning, Earth Shock, Flame Shock, Fire Nova en Searing Totem; niets nieuws voor deze rol.
- 60: weer sterkere ranks; niets nieuws voor deze rol.
**Beginnersfouten:**
- Earth Shock voor schade in een groep. Hij maakt veel **threat** (hoe graag een vijand jou wil aanvallen). En hij deelt zijn cooldown met Flame Shock: daarna heb je geen interrupt.
- Chain Lightning op één vijand. Hij kost veel mana en heeft een cooldown van 6 seconden.
- Elke vijand met een spell afmaken. Mana is je grens: sla een vijand die bijna dood is met je wapen.]] },
			{ band = 2, title = "Enhancement: schade van dichtbij", body = [[
Vanaf level 1: je slaat met je wapen, met Rockbiter Weapon erop. De gidsen levelen als Enhancement: ze noemen het de comfortabele keus. Gebruik een langzaam tweehandig wapen. Stormstrike is een talent, op z'n vroegst 25; Windfury Weapon komt op 30 van de trainer. Mana is je grens: raakt het op, stop dan met casten en blijf slaan. Advies van één gids voor de weapon buff: Rockbiter Weapon als je alleen speelt, Flametongue Weapon in een groep, Windfury Weapon vanaf 30. In een kleine groep kan Enhancement even tanken met Rockbiter Weapon (Spirit Weapons geeft dan meer threat), maar er is geen taunt en geen verdedigings-cooldown.
**Simpele volgorde:**
Vooraf: weapon buff aan (blok D), Lightning Shield (**Shift-Z**), Searing Totem (**5**) of je totems neer.
1. Pull met Lightning Bolt (**1**). **Pullen** = één vijand van een afstand raken, zodat hij naar jou toe komt.
2. Stormstrike (**3**, vanaf 25) steeds als hij klaar is.
3. Lightning Bolt (**1**) bij 5 stacks Maelstrom Weapon (vanaf 35): dan is hij direct en gratis.
4. Earth Shock (**E**). In een groep afwisselen met Flame Shock (**2**).
5. Fire Nova (**Shift-4**, vanaf 12) als er een Fire-totem staat en je mana over hebt; vooral bij meer vijanden.
6. Rage of the Farseer (**Q**, vanaf 40) voor een elite of een grote pull.
7. Verder gewoon blijven slaan.
Na het gevecht: Healing Wave (**C**). In nood tijdens het gevecht: Lesser Healing Wave (**F2**, vanaf 20).
**Per 10 levels:**
- 10: Rockbiter Weapon (blok D), Lightning Bolt (**1**), Earth Shock (**E**, vanaf 4), Lightning Shield (**Shift-Z**, vanaf 8). Flame Shock (**2**), Searing Totem (**5**), Strength of Earth Totem (**Shift-X**), Flametongue Weapon (blok D). Eerste talenten: Thundering Strikes en andere (passief); Mental Dexterity (passief) vanaf 15. Talent-levels hier zijn op z'n vroegst; een perk kan ze tot 5 levels eerder maken. Daarna Fire Nova (**Shift-4**) op 12.
- 20: Ghost Wolf (**R**), Frost Shock (**4**), Lesser Healing Wave (**F2**), Call of the Elements (**Ctrl-1**). Shamanistic Focus (een talent, passief): Shocks en Lightning Shield kosten 45% minder mana. Daarna Stormstrike (**3**, een talent) op 25. Flurry (een talent, passief) vanaf 25. Improved Ghost Wolf (een talent) vanaf 25: Ghost Wolf gaat sneller (direct met beide punten) en werkt ook binnen; de gidsen nemen hem op heel verschillende levels. Magma Totem (blok D) op 26.
- 30: Windfury Weapon (blok D). Improved Stormstrike en Spirit Weapons (talenten). Grounding Totem (**X**), Call of the Ancestors (**Ctrl-2**). Daarna Windfury Totem op 32 (geen toets: gebruik de totem-balk), Chain Lightning (**Shift-1**) op 32, Maelstrom Weapon (een talent, passief) op 35.
- 40: Rage of the Farseer (**Q**, een talent): je slaat 25 seconden lang 30% sneller; alleen je wapenklappen, niet je spells. Cooldown 3 minuten. Niet elke gids neemt hem op 40: sommige gaan eerst in Restoration voor mana. Call of the Spirits (**Ctrl-3**), mail-armor, een sterkere Windfury Weapon. Daarna Grace of Air Totem op 42 (geen toets: gebruik de totem-balk).
- 50: sterkere ranks van Windfury Weapon, Rockbiter Weapon, Earth Shock, Lightning Bolt en Strength of Earth Totem; niets nieuws voor deze rol.
- 60: weer sterkere ranks; niets nieuws voor deze rol.
**Beginnersfouten:**
- Lightning Bolt met minder dan 5 stacks Maelstrom Weapon. Dat zet je swing timer terug. En Maelstrom Weapon helpt alleen Lightning Bolt: geen heals, geen Chain Lightning.
- Rockbiter Weapon in een groep terwijl jij de schade doet, als je Spirit Weapons hebt. Met Rockbiter maak je 30% meer threat, zonder 30% minder. Gebruik Flametongue of Windfury.
- Een taunt zoeken. De Shaman heeft er geen. Stoneclaw Totem (**F**) laat vijanden de totem aanvallen, niet jou.]] },
			{ band = 3, title = "Restoration: healer", body = [[
Vanaf level 1: Healing Wave heb je vanaf het begin, en het is je hoofd-heal tijdens het levelen. De gidsen raden niet aan om alleen als Restoration te levelen (vijanden gaan langzaam dood), maar in een groep is hij goed. Tussen dungeons door quest je met Lightning Bolt en Flame Shock. Riptide is een talent, op z'n vroegst 40. Een Shaman kan Poison en Disease weghalen, maar geen curses en geen magie.
**Simpele volgorde (in een groep):**
Vooraf: Water Shield (**Shift-Z**, vanaf 20). Totems neer: Call of the Elements (**Ctrl-1**, vanaf 20) of Healing Stream Totem (**F4**, vanaf 20).
1. Riptide (**Shift-F1**, vanaf 40) op de tank of op wie schade krijgt.
2. Chain Heal (**Shift-2**, vanaf 40) op datzelfde doel als meer mensen gewond zijn.
3. Healing Wave (**C**) voor één persoon of de tank.
4. Lesser Healing Wave (**F2**, vanaf 20) als het snel moet.
5. Nood: Nature's Swiftness (**Shift-3**, vanaf 30), dan Healing Wave (**C**).
6. Mana Tide Totem (**F1**, vanaf 25) als je mana opraakt.
7. Niemand gewond: Lightning Bolt (**1**).
**Per 10 levels:**
- 10: Healing Wave (**C**). Eerste talenten: Improved Healing Wave (een snellere Healing Wave), Tidal Focus (passief). Talent-levels hier zijn op z'n vroegst; een perk kan ze tot 5 levels eerder maken. Daarna Ancestral Spirit (**F3**, buiten een gevecht) op 12, Cure Poison (**Shift-C**) op 16, Tremor Totem (**Shift-F**) op 18.
- 20: Lesser Healing Wave (**F2**), Healing Stream Totem (**F4**, uit een quest), Call of the Elements (**Ctrl-1**), Ghost Wolf (**R**). Water Shield (**Shift-Z**, een talent): 3 waterbollen; word je geraakt of crit een spell van jou, dan krijg je 2% van je mana terug per bol. Hij duurt 10 minuten. Vanaf dan cast Shift-Z Water Shield, niet meer Lightning Shield. Daarna Cure Disease (**Shift-V**) op 22. Mana Tide Totem (**F1**, een talent) op 25: geeft je groep mana terug; cooldown 5 minuten. Mana Spring Totem op 26 (geen toets: gebruik de totem-balk).
- 30: Nature's Swiftness (**Shift-3**, een talent): je volgende Nature-spell met een cast korter dan 10 seconden is direct; cooldown 3 minuten. Healing Way (een talent, passief). Grounding Totem (**X**), Call of the Ancestors (**Ctrl-2**), Reincarnation (passief). Daarna Purification (een talent, passief) op 35, een sterkere Mana Tide Totem op 38.
- 40: Chain Heal (**Shift-2**). Riptide (**Shift-F1**, een talent; je hebt eerst Healing Way nodig): een heal over 15 seconden, geen directe heal, en een Chain Heal die je direct op dat doel cast, healt 25% meer; cooldown 12 seconden. Call of the Spirits (**Ctrl-3**), mail-armor.
- 50: sterkere ranks van Riptide, Chain Heal, Healing Wave, Lesser Healing Wave, Mana Tide Totem en Healing Stream Totem; niets nieuws voor deze rol.
- 60: weer sterkere ranks; niets nieuws voor deze rol.
**Beginnersfouten:**
- Chain Heal op iemand anders dan je Riptide-doel. De bonus telt alleen als je hem direct op dat doel cast.
- Alleen Nature's Swiftness indrukken. Hij healt zelf niets: hij maakt je volgende Nature-spell direct. Druk daarna Healing Wave.
- Een curse willen weghalen. Dat kan een Shaman niet; alleen Poison (**Shift-C**) en Disease (**Shift-V**).]] },
		},
		-- Warlock (17 nov 2026), zelfde band en volgorde als in Modules/ForeverHowToPlay.lua.
		WARLOCK = {
			{ band = 1, title = "Affliction: schade over tijd", body = [[
Vanaf level 4 (Corruption) en 8 (Bane of Agony). Je zet DoTs op de vijand en laat je demon hem vasthouden. De meeste gidsen levelen als Affliction. Siphon Life is een talent, op z'n vroegst 30. Wrack is een talent, op z'n vroegst 40: zolang je hem kanaliseert, tikken je Siphon Life, Corruption en Bane of Agony op die vijand 100% sneller. Wrack heelt je niet.
**Simpele volgorde:**
1. Stuur je demon erop af (**Ctrl-1**).
2. Bane of Agony (**5**) om te pullen. De schade begint laag, dus je demon pakt de vijand.
3. Corruption (**2**). Met Improved Corruption 5/5 is hij direct (op z'n vroegst 14).
4. Siphon Life (**F4**, vanaf 30), alleen op een vijand die lang leeft.
5. Immolate (**3**) alleen op een taaie vijand.
6. Taaie vijand: je curse erbij (**Shift-V**). De gidsen verschillen over hoe vroeg.
7. Opvuller: tot ongeveer level 30 je wand (Shoot; niet op het blok, zet hem op je eigen balk), daarna Drain Life (**C**). De gidsen verschillen een beetje over wanneer je wisselt.
8. Licht Shadow Trance op (Nightfall, vanaf 25)? Shadow Bolt (**1**): die is dan direct.
9. Vanaf 40: Wrack (blok D) in plaats van Drain Life als je health goed is. Zet eerst je DoTs erop.
10. Meer health dan mana? Life Tap (**F**).
11. Soul Shard nodig? Maak de vijand af met Drain Soul (**4**).
Twee vijanden: DoTs op de eerste, Fear (**V**) erop, vecht dan met de tweede. Schade kan Fear breken, en de gidsen verschillen over eerst DoTs of eerst Fear.
**Per 10 levels:**
- 10: Drain Soul (**4**), Create Healthstone (blok D), de Voidwalker (quest). Je had al Shadow Bolt (**1**), Immolate (**3**), Corruption (**2**, 4), Curse of Weakness (**Shift-V**, 4), Life Tap (**F**, 6), Bane of Agony (**5**, 8) en Fear (**V**, 8). Eerste talent: Improved Corruption of Suppression (de gidsen verschillen). Talent-levels hier zijn op z'n vroegst; een perk kan ze tot 5 levels eerder maken. Daarna Health Funnel (**F2**) op 12; Drain Life (**C**) en Corruption rank 2 (15 seconden) op 14; Improved Drains en Soul Harvest (talenten, passief) vanaf 15; Searing Pain (blok D) en Create Soulstone op 18.
- 20: Amplify Curse (**Shift-3**, een talent): je volgende Curse of Weakness of Bane of Agony is 50% sterker; cooldown 3 minuten. Curse of the Elements (**Shift-V**), Demon Armor (**Shift-Z**), Rain of Fire (**Shift-1**), de Succubus of Incubus (quest). Daarna Corruption rank 3 (18 seconden) en Drain Mana op 24. Curse of Exhaustion (**R**, een talent; je hebt eerst Amplify Curse nodig) op 25: de vijand is 12 seconden lang 30% trager. Nightfall (een talent, passief) op 25: een kleine kans dat je volgende Shadow Bolt direct is. Banish (**Shift-Q**) op 28.
- 30: Siphon Life (**F4**, een talent): haalt 30 seconden lang health van de vijand naar jou. Soul Siphon (een talent, passief): Drain Life, Drain Soul en Wrack doen meer voor elke Corruption, Siphon Life en Bane of Agony van jou op de vijand. Drain Life rank 3, Hellfire (**Shift-2**), de Felhunter (quest). Daarna Shadow Ward (**Z**) op 32, Shadow Mastery (een talent, passief) op 35, Siphon Life rank 2 en Drain Life rank 4 op 38.
- 40: Wrack (blok D, een talent; je hebt eerst Siphon Life nodig): een kanaal van 6 seconden dat elke seconde schade doet en je DoTs op die vijand 100% sneller laat tikken. Howl of Terror (**Shift-F**), de Felsteed (quest). Daarna Death Coil (**X**) op 42, Soul Fire (**Q**) en Siphon Life rank 3 op 48.
- 50: Inferno (**F3**). Curse of the Elements rank 4. Verder sterkere ranks.
- 60: Bane of Doom (**F1**): een grote klap na 60 seconden; niet op spelers. Verder sterkere ranks.
**Beginnersfouten:**
- Bane of Agony te vroeg opnieuw zetten. De sterkste tikken komen aan het eind.
- Wrack gebruiken als je health nodig hebt. Wrack heelt niet; Drain Life wel.
- Curse of Recklessness op de vijand die je wilt Fearen. Die vijand negeert Fear.]] },
			{ band = 2, title = "Demonology: schade met je demon", body = [[
Vanaf level 1 (de Imp), echt vanaf 10 (de Voidwalker). Je demon doet veel van het werk, en de talenten maken hem sterker. De gidsen verschillen over wanneer je deze boom ingaat: sommige vanaf 10, andere levelen eerst als Affliction en wisselen rond 26 of 27. Demonic Sacrifice (op z'n vroegst 20) loont pas met Demonic Pact (op z'n vroegst 40). Daarvoor haalt elke demon die je oproept de buff weg.
**Simpele volgorde:**
1. Stuur je demon erop af (**Ctrl-1**), en laat hem eerst raken.
2. Vanaf 30: Soul Link (**Shift-X**) aan, en opnieuw na elke oproep.
3. Vanaf 25 (Demonic Brand): Searing Pain (blok D) op de vijand van je demon. Opnieuw als het merk weg is (10 seconden). Vóór Demonic Brand: geen Searing Pain.
4. Bane of Agony (**5**) en Corruption (**2**) op vijanden die lang genoeg leven. Corruption heeft hier een cast van 2 seconden.
5. Opvuller: je wand (niet op het blok, zet hem op je eigen balk) of Shadow Bolt (**1**). Drain Life (**C**) als je health nodig hebt.
6. Demon bijna dood: Health Funnel (**F2**). Het kost je eigen health.
7. Life Tap (**F**). Met Demonic Energies krijgt je demon ook mana.
8. Vanaf 40 (Demonic Pact): Demonic Sacrifice (**Shift-C**) op de ene demon, roep daarna een andere op (blok D). De buff duurt 2 uur. De gidsen verschillen over welke demon je offert.
9. Vanaf 48, met Decimation: vijand onder 35% health? Shadow Bolt of Searing Pain, dan Soul Fire (**Q**): sneller, en zonder Soul Shard.
**Per 10 levels:**
- 10: de Voidwalker (quest; kost 1 Soul Shard). Zijn Torment geeft **threat** (hoe graag een vijand hem wil aanvallen). Drain Soul (**4**) voor shards. Eerste talenten: Unholy Power, Demonic Embrace, Improved Imp, Improved Health Funnel (passief). Talent-levels hier zijn op z'n vroegst; een perk kan ze tot 5 levels eerder maken. Daarna Health Funnel (**F2**) op 12; Demonic Energies, Fel Vitality en Improved Voidwalker (talenten, passief) vanaf 15; Sacrifice (Voidwalker) op 16; Consume Shadows (Voidwalker) en Searing Pain (blok D) op 18.
- 20: Demonic Sacrifice (**Shift-C**, een talent): je offert je demon voor een buff van 2 uur. Imp: 15% meer Shadow-schade. Succubus of Incubus: 15% meer Fire-schade. Voidwalker: mana terug. Felhunter: health terug. Master Summoner (een talent, passief): oproepen gaat sneller en goedkoper. De Succubus of Incubus (quest). Demon Armor (**Shift-Z**). Daarna Suffering (Voidwalker) op 24. Fel Domination (**Shift-F1**, een talent; je hebt eerst Master Summoner nodig) op 25: je volgende oproep is 5,5 seconden sneller en 50% goedkoper. Demonic Brand en Decimation (talenten, passief) vanaf 25.
- 30: Soul Link (**Shift-X**, een talent; je hebt eerst Demonic Sacrifice nodig): 30% van de schade op jou gaat naar je demon, en jullie doen allebei 3% meer schade. Hij blijft zolang je demon er is. De Felhunter (quest; Spell Lock op 36). Demonic Knowledge (een talent, passief). Daarna Master Demonologist (een talent, passief) vanaf 35.
- 40: Demonic Pact (een talent, passief; je hebt eerst Soul Link nodig): de buff van Demonic Sacrifice blijft als je een andere demon oproept. Pas nu loont Demonic Sacrifice. Howl of Terror (**Shift-F**), de Felsteed (quest). Daarna Death Coil (**X**) op 42, Soul Fire (**Q**) op 48.
- 50: Inferno (**F3**): een Infernal; elke keer 1 Infernal Stone; cooldown 1 uur. Verder sterkere ranks.
- 60: Bane of Doom (**F1**). Verder sterkere ranks.
**Beginnersfouten:**
- Searing Pain vóór je Demonic Brand hebt. Hij maakt veel threat en trekt de vijand van je demon af.
- Demonic Sacrifice vóór Demonic Pact (40). Je demon is weg, en elke demon die je oproept haalt de buff weg.
- Na Demonic Pact dezelfde demon oproepen die je offerde. Dan is de buff weg.]] },
			{ band = 3, title = "Destruction: schade met grote klappen", body = [[
Vanaf level 1 (Shadow Bolt en Immolate). Grote vuur- en shadow-klappen, en hij kost de meeste mana. Sommige gidsen raden hem af om mee te levelen (veel mana, weinig om het terug te krijgen); andere noemen hem speelbaar, en één noemt hem sterk in dungeons. Conflagrate is een talent, op z'n vroegst 25; Incinerate is een talent, op z'n vroegst 40. Het omslagpunt is Shadow and Flame 5/5 (op z'n vroegst 39): vanaf dan eet Conflagrate je Immolate niet meer op, en geeft Shadowburn zijn Soul Shard altijd terug.
**Simpele volgorde:**
1. Stuur je demon erop af (**Ctrl-1**).
2. Immolate (**3**). Eén gids opent met Shadow Bolt van ver, met Immolate er direct achteraan.
3. Taaie vijand: Bane of Agony (**5**) en je curse (**Shift-V**).
4. Vanaf 25: Conflagrate (blok D). Vóór Shadow and Flame 5/5 eet hij je Immolate op: gebruik hem aan het eind van Immolate, of als laatste klap. Daarna: steeds als hij klaar is.
5. Opvuller: Shadow Bolt (**1**). Vanaf 40 Incinerate (blok D), met Immolate op de vijand.
6. Vanaf 20: Shadowburn (**Shift-4**) als laatste klap. Dan krijg je de Soul Shard terug.
7. Life Tap (**F**) tussen gevechten. Weinig mana: je wand (niet op het blok, zet hem op je eigen balk).
8. Meer vijanden: vanaf 30 Bane of Havoc (blok D) op één taaie vijand, val dan de rest aan. Rain of Fire (**Shift-1**). Hellfire (**Shift-2**, vanaf 30) alleen met genoeg health.
**Per 10 levels:**
- 10: Shadow Bolt (**1**) en Immolate (**3**; rank 2 op 10). Eerste talent: Bane (snellere casts) of Improved Shadow Bolt. Talent-levels hier zijn op z'n vroegst; een perk kan ze tot 5 levels eerder maken. Daarna Shadow Bolt rank 3 op 12 (cast van 2,8 seconden); Aftermath en Cataclysm (talenten, passief) vanaf 15; Searing Pain (blok D) op 18.
- 20: Shadowburn (**Shift-4**, een talent): een directe Shadow-klap; kost 1 Soul Shard; cooldown 15 seconden. Gaat de vijand (een die XP geeft) binnen 8 seconden dood, dan krijg je een shard terug. Ruin (een talent, passief): je Destruction-crits slaan harder. Rain of Fire (**Shift-1**). Shadow Bolt rank 4 (cast van 3 seconden). Daarna Shadowburn rank 2 op 24. Conflagrate (blok D, een talent) op 25: een directe Fire-klap op een vijand met jouw Immolate; die Immolate is dan weg; cooldown 10 seconden. Agonizing Flames en Intensity (talenten, passief) vanaf 25.
- 30: Bane of Havoc (blok D, een talent): 5 minuten op één vijand; 15% van al je schade op andere vijanden komt ook op deze. Maar één vijand tegelijk. Fire and Brimstone (je hebt eerst Conflagrate nodig) en Pyroclasm (je hebt eerst Intensity nodig), talenten, passief. Hellfire (**Shift-2**). Daarna Conflagrate rank 2 en Shadowburn rank 3 op 32; Shadow and Flame (een talent, passief) vanaf 35, 5/5 op z'n vroegst op 39.
- 40: Incinerate (blok D, een talent; je hebt eerst Bane of Havoc nodig): een cast van 2,5 seconden, 25% meer schade als de vijand jouw Immolate heeft. Conflagrate rank 3, Shadowburn rank 4. Daarna Soul Fire (**Q**) op 48.
- 50: Incinerate rank 2. Inferno (**F3**).
- 60: Incinerate rank 3, Conflagrate rank 6. Bane of Doom (**F1**).
**Beginnersfouten:**
- Conflagrate direct na Immolate. Hij eet je Immolate op (tot Shadow and Flame 5/5).
- Shadowburn zonder Soul Shard, of op een vijand die nog lang leeft. De shard komt alleen terug als de vijand binnen 8 seconden doodgaat.
- Bane of Havoc en Bane of Agony op dezelfde vijand. Er past maar één bane op.]] },
		},
		-- Paladin (17 nov 2026), zelfde band en volgorde als in Modules/ForeverHowToPlay.lua.
		PALADIN = {
			{ band = 1, title = "Holy: healer", body = [[
Vanaf level 1: Holy Light heb je vanaf het begin. Een **healer** houdt de groep in leven. De gidsen noemen Holy de traagste boom om alleen te levelen: level als Retribution en heal in dungeons, of speel Holy samen met een vriend. De eigen knoppen van de boom komen op 20 (Divine Favor), 25 (Oath of Light), 30 (Holy Shock) en 40 (Light's Vigil).
**Simpele volgorde (in een groep):**
Vóór de pull: Blessing of Wisdom (**Shift-V**, vanaf 14) op jezelf, Blessing of Kings (**Shift-X**, vanaf 20) op de anderen. Aura: Devotion Aura (**Ctrl-1**), of Concentration Aura (**Ctrl-3**, vanaf 22) als casters veel geraakt worden.
1. Oath of Light (**Shift-R**, vanaf 25) op de tank. Hij duurt 1 uur, en maar één speler kan hem hebben.
2. Flash of Light (**F2**, vanaf 20) is je gewone heal. Vóór 20: Holy Light (**C**).
3. Holy Light (**C**) voor een grote klap. Vanaf 25 (Infusion of Light) cast hij sneller vlak na een crit van Holy Shock of Flash of Light. **Crit** = een sterkere geluksklap of geluksheal.
4. Holy Shock (**F4**, vanaf 30) als er geen tijd is om te casten, of terwijl je loopt.
5. De hele groep gewond, vanaf 40: Light's Vigil (**Shift-F1**) op één speler, dan Holy Shock (**F4**) op diezelfde speler.
6. Divine Favor (**Shift-3**, vanaf 20) vóór een heal die groot moet zijn.
7. Een slecht effect op een vriend: Purify, later Cleanse (**Shift-C**).
8. Nood: Lay on Hands (**Q**). Hij gebruikt alle mana op die je nog hebt.
Niets te healen: je seal (**3**), Judgement (**2**) en Holy Strike (**1**) van dichtbij. Alleen: speel zoals een Retribution Paladin; vanaf 30 is Holy Shock (**F4**) op de vijand je ene sterke schadeknop.
**Per 10 levels:**
- 10: je had al Holy Light (**C**), Devotion Aura (**Ctrl-1**), Blessing of Might (**Shift-Z**), Divine Protection (**Z**), Hammer of Justice (**E**) en Purify (**Shift-C**). Nieuw op 10: Lay on Hands (**Q**), Blessing of Protection (**Shift-F**). Eerste talent: Spiritual Focus (passief). Talent-levels hier zijn op z'n vroegst; een perk kan ze tot 5 levels eerder maken. Daarna Redemption (**F3**, uit een quest) op 12, Blessing of Wisdom (**Shift-V**) op 14, Reverence en Healing Light (talenten, passief) vanaf 15, Blessing of Freedom (**R**) op 18.
- 20: Flash of Light (**F2**), Blessing of Kings (**Shift-X**). Divine Favor (**Shift-3**, een talent): je volgende Flash of Light, Holy Light of Holy Shock is zeker een crit; cooldown 2 minuten. Illumination (een talent, passief; je hebt eerst Reverence nodig). Daarna Concentration Aura (**Ctrl-3**) op 22. Oath of Light (**Shift-R**, een talent) en Infusion of Light (een talent, passief) op 25.
- 30: Holy Shock (**F4**, een talent): direct, schade op een vijand of een heal op een vriend; cooldown 10 seconden. Divine Intervention (**F3** in een gevecht: je gaat zelf dood). Seal of Light (blok D). Daarna Divine Shield (**Z**) op 34, Holy Power (een talent, passief) op 35, Seal of Wisdom (blok D) op 38.
- 40: Light's Vigil (**Shift-F1**, een talent; je hebt eerst Holy Shock nodig): 30 seconden op een vriend; je volgende Holy Shock op die vriend heeft geen cooldown en healt ook zijn groep. Holy Shock rank 2. Plate Mail: je kunt plate dragen. Daarna Cleanse (**Shift-C**) op 42, Blessing of Sacrifice (blok D) op 46, Holy Shock rank 3 op 48.
- 50: Light's Vigil rank 2, Lay on Hands rank 3. Daarna Greater Blessing of Might op 52 en Greater Blessing of Wisdom op 54, Holy Shock rank 4 op 56.
- 60: Greater Blessing of Kings, Light's Vigil rank 3; niets nieuws voor deze rol.
**Beginnersfouten:**
- Holy Light voor elke kleine klap. Flash of Light (**F2**, vanaf 20) is de goedkope gewone heal.
- Light's Vigil op de ene speler en Holy Shock op een andere. De groepsheal komt alleen van Holy Shock op DEZELFDE speler.
- Per ongeluk F3 indrukken in een gevecht. Dan cast hij Divine Intervention, en ga je zelf dood. Buiten een gevecht is F3 Redemption.]] },
			{ band = 2, title = "Protection: tank", body = [[
Vanaf level 10 (Righteous Fury en Seal of Fury bij de trainer). Een **tank** is degene die de vijanden slaan, zodat de rest van de groep veilig blijft. **Threat** = hoe graag een vijand jou wil aanvallen. Je draagt een eenhandig wapen en een schild. De gidsen zijn het oneens over hoe goed Protection alleen levelt. De knoppen van de boom: Templar's Bulwark op 20, Swift Judgement op 25, Holy Shield op 30.
**Simpele volgorde:**
1. Vóór de pull: Righteous Fury aan (geen vaste toets: hij staat in blok D, of zet hem op je eigen balk; hij duurt 30 minuten). Seal of Fury (**F**), een blessing, een aura. De gidsen zijn het oneens over de aura: Devotion Aura (**Ctrl-1**) of Retribution Aura (**Ctrl-2**).
2. Vanaf 30: Holy Shield (**Shift-4**) vlak voordat de vijanden bij je zijn. Druk hem opnieuw steeds als hij klaar is.
3. Judgement (**2**) op de eerste vijand. Met Seal of Fury aan is Judgement je taunt (3 seconden). **Taunt** = de vijand jou laten aanvallen.
4. Twee of meer vijanden, vanaf 20: Consecration (**Shift-1**) onder ze. Alleen de eerste 4 krijgen de extra schade.
5. Holy Strike (**1**) steeds als hij klaar is.
6. Een vijand loopt naar iemand anders: Judgement (**2**). Niet klaar? Vanaf 25: Swift Judgement (**F1**), een tweede Judgement met een eigen cooldown van 1 minuut.
7. Een vijand cast een spell: Hammer of Justice (**E**). De Paladin heeft geen interrupt.
8. Exorcism (**5**, vanaf 20) op Undead en Demons. Hammer of Wrath (**4**, vanaf 44).
9. Er komt veel schade aan, vanaf 20: Templar's Bulwark (**X**). Laatste redmiddel: Lay on Hands (**Q**).
Weinig mana: laat eerst Consecration weg. Vanaf 40 (Shieldsworn): eerst Holy Shield, dan Holy Strike. Ben je niet de tank (alleen, of iemand anders tankt): gebruik je seal op **3**, niet Seal of Fury.
**Per 10 levels:**
- 10: Righteous Fury (blok D) en Seal of Fury (**F**). Je had al Judgement (**2**), Holy Strike (**1**), Hammer of Justice (**E**), Devotion Aura (**Ctrl-1**) en Divine Protection (**Z**). Ook nieuw: Lay on Hands (**Q**), Blessing of Protection (**Shift-F**). Eerste talent: Redoubt (passief). Talent-levels hier zijn op z'n vroegst; een perk kan ze tot 5 levels eerder maken. Daarna Precision, Guardian's Favor of Sacred Duty (talenten, passief) vanaf 15, Retribution Aura (**Ctrl-2**) op 16.
- 20: Templar's Bulwark (**X**, een talent): een schild dat 8 seconden lang schade opvangt, zoveel als je max health; cooldown 5 minuten. Consecration (**Shift-1**), Blessing of Kings (**Shift-X**), Exorcism (**5**). Shield Specialization (een talent, passief; je hebt eerst Redoubt nodig). Daarna Swift Judgement (**F1**, een talent; je hebt eerst Templar's Bulwark nodig) en Improved Righteous Fury (een talent, passief) op 25.
- 30: Holy Shield (**Shift-4**, een talent; je hebt een schild nodig): 10 seconden lang 30% meer kans om te blocken, 4 ladingen; cooldown 10 seconden. Reckoning (een talent, passief). Daarna Divine Shield (**Z**) op 34, Iron Creed (een talent, passief) op 35.
- 40: Shieldsworn (een talent, passief; je hebt eerst Holy Shield nodig): Holy Strike elke 6 seconden, en hij werkt samen met Holy Shield. Plate Mail: je kunt plate dragen. Holy Shield rank 2. Daarna Hammer of Wrath (**4**) op 44, Blessing of Sacrifice (blok D) op 46.
- 50: Holy Shield rank 3, Holy Wrath (blok D); sterkere ranks van Seal of Fury en Consecration.
- 60: Holy Shield rank 4 en sterkere ranks; niets nieuws voor deze rol.
**Beginnersfouten:**
- Righteous Fury vergeten. Zonder maak je veel minder threat. Kijk het na vóór elke pull; hij duurt 30 minuten.
- Seal of Fury aan terwijl jij niet de tank bent. Elke Judgement is dan een taunt.
- Geen schild. Holy Shield werkt niet zonder, en Seal of Fury geeft dan geen absorb.]] },
			{ band = 3, title = "Retribution: schade van dichtbij", body = [[
Vanaf level 1 (Seal of Righteousness); Judgement komt op 4, Holy Strike op 6. De gidsen noemen Retribution de snelste boom om alleen te levelen, met één traag tweehandig wapen. De class-quest op 20 geeft je er een. De knoppen van de boom: Seal of Command op 20, Repentance op 30.
**Simpele volgorde:**
1. Vóór het gevecht: Blessing of Might (**Shift-Z**) tot 20, daarna Blessing of Kings (**Shift-X**).
2. Aura: Devotion Aura (**Ctrl-1**); Retribution Aura (**Ctrl-2**, vanaf 16) tegen meerdere vijanden.
3. Seal aan (**3**): Seal of Righteousness, tot je Seal of Command kent (vanaf 20). Dan cast toets 3 Seal of Command.
4. Judgement (**2**) steeds als hij klaar is. Hij gebruikt de seal niet op.
5. Holy Strike (**1**) steeds als hij klaar is.
6. Undead of Demon, vanaf 20: Exorcism (**5**).
7. Twee of meer vijanden, vanaf 20: Consecration (**Shift-1**). Niet op één vijand: hij kost te veel mana.
8. Vanaf 44: Hammer of Wrath (**4**) als de vijand op 20% health of minder staat.
9. Sterke vijand: Hammer of Justice (**E**), dan Judgement (**2**). Met Seal of Command doet Judgement dubbele schade op een vijand met een stun.
10. Een tweede Humanoid, vanaf 30: Repentance (**V**), en sla hem niet.
11. Zet de seal opnieuw op als hij afloopt (30 seconden). Weinig health: Holy Light (**C**) tussen gevechten.
**Per 10 levels:**
- 10: je had al Seal of Righteousness (**3**), Judgement (**2**), Holy Strike (**1**), Blessing of Might (**Shift-Z**) en Hammer of Justice (**E**). Nieuw op 10: Lay on Hands (**Q**). Eerste talent: Benediction (de meeste gidsen) of Deflection (één gids), allebei passief. Talent-levels hier zijn op z'n vroegst; een perk kan ze tot 5 levels eerder maken. Daarna Improved Judgement, Conviction of Sanctified Judgement (talenten, passief) vanaf 15, Retribution Aura (**Ctrl-2**) op 16.
- 20: Seal of Command (**3**, een talent): je klappen doen soms een extra Holy-klap. Vanaf dan cast toets 3 deze in plaats van Seal of Righteousness. Consecration (**Shift-1**), Exorcism (**5**), Blessing of Kings (**Shift-X**), Flash of Light (**F2**). Pursuit of Justice (een talent, passief: je loopt 15% sneller bij 2/2). De class-quest voor een tweehandig wapen. Daarna Sacred Arbiter en Two-Handed Weapon Specialization (talenten, passief) op 25.
- 30: Repentance (**V**, een talent): haalt één Humanoid tot 6 seconden uit het gevecht; elke schade maakt hem wakker; cooldown 1 minuut. Vengeance (een talent, passief; je hebt eerst Seal of Command nodig): na een crit doe je 30 seconden lang meer schade; stapelt tot 5 keer. Seal of Command rank 2. Daarna Divine Shield (**Z**) op 34, Champion of the Light (een talent, passief) op 35.
- 40: Unsealed Wrath (een talent, passief; je hebt eerst Repentance nodig): je klappen bewaren kopieën van je seal, en een klap met een andere seal gebruikt ze. Plate Mail: je kunt plate dragen. De Warhorse-quest. Daarna Hammer of Wrath (**4**) op 44.
- 50: Seal of Command rank 4, Holy Wrath (blok D), Hammer of Wrath rank 2 op 52; niets nieuws voor deze rol.
- 60: Seal of Command rank 5 en sterkere ranks; de Charger-quest (Alliance); niets nieuws voor deze rol.
**Beginnersfouten:**
- Na elke Judgement de seal opnieuw opzetten. Judgement gebruikt hem niet op; een seal duurt 30 seconden.
- Seal of Command met een snel wapen. Hij wil een traag tweehandig wapen.
- Consecration op één vijand. Daarvoor kost hij te veel mana.]] },
		},
	},
}
