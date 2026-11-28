local _, ns = ...

--[[
	ForeverHowToPlay.lua — "How you play" for WoW Forever.

	Rob, 6 Nov 2026: "doe b en dan a" (b = drop the dead "How you play" step from the key-block guide on Forever, a = put
	the How to play draft in the addon). The text is docs/forever/HOW_TO_PLAY_CONCEPT_2026-11-06.md (written by mh-writer,
	checked by mh-research against DB2 1.60.1.70790 and Blizzard's class deep dives), with the notes for Rob left out.
	All nine classes are written. Druid, Paladin, Mage and Hunter came first; Warrior, Rogue, Priest, Shaman and Warlock
	followed the same night (Rob: "Ja, schrijf ze"), written by mh-writer from docs/forever/FOREVER_<CLASS>_2026-11-06.md
	and the key tables, then fact-checked by mh-research (DB2 1.60.1.70790, Blizzard's deep dives). A class without a
	text (none today) gets an honest "not written yet" line. The window shows only this character's class.

	English here; other languages in Locales/ForeverHowToPlay_<code>.lua (7 Nov 2026). The keys named here are the ones the
	ForeverBlock_<Class>.lua tables use on 6 Nov 2026 — change a table, change its line here too.

	It takes the retail names ns.ShowPlayCardWindow / ns.TogglePlayCardWindow, because PlayCardWindow.lua is not loaded on
	Forever: the key block's step 4 and /mh play then open this window.
]]

if not ns.IS_FOREVER then
	return
end

local COMMON = {
	{ "Before you start", [[
- The keys assume MH's key block is placed: /mh block, then steps 1 and 2.
- **Spell ranks.** Most spells come in ranks: Rank 1, Rank 2, and so on. A higher rank is the same spell, only stronger. You buy new ranks from your class trainer as you level up. You do not need to swap anything: MH's keys cast a spell by its name, and the game uses the highest rank you know.
- **A key with nothing on it yet** keeps its place. It fills up when you learn the spell. If a new spell does not show up, open the key block (/mh block) and press **Update (add new spells)**.
- **Talent spells** get a key too. If you never pick that talent, the key stays empty. That is fine.
- **Mana** is the blue bar under your health. Most spells cost mana. When it is empty, you cannot cast.
- **Cooldown** = the wait before you can press a spell again.
- Fixed keys, the same for every class: **T** = potion, **Shift-T** = healthstone, **G** = trinket.]] },
	{ "Camping", [[
- **Camping** is not a profession. Every profession can make one **camp feature**. Cooking makes the fire.
- **Start** with the quest **The Great Outdoors**, in every starting zone.
- **1. The fire.** With Cooking, make a **Basic Campfire Kit**: 1 Simple Wood, with **Flint and Tinder** as a tool (you keep it). Use the kit outdoors, not in combat. The fire has room for 3 features (Journeyman Campfire 5, Expert Campfire 10). Cooldown: 5 minutes.
- **2. A feature.** Make it with your profession. You need skill 20 to place it. Place it near the fire. The item is used up.
- **3. Sit down** near the fire. You get **Welcoming Campfire** for 60 seconds. You may craft, but do not walk. Then you get **Camp Benefits** for 1 hour, with one line per feature.
- **Rules:** all features share a cooldown of 1 hour. Each kind of feature only once per camp.
- **Clashes:** you cannot have a camp buff and the class buff named below at the same time. Most camp buffs grow with your level.
- Skinning: **Camp Chair** = critical strike chance. Clashes with Moonkin Aura.
- Blacksmithing: **Sharpening Wheel** = Strength. Clashes with Strength of Earth Totem.
- Herbalism: **Incense Candle** = Intellect. Clashes with Arcane Intellect.
- Alchemy: **Mana Well** = mana every 5 seconds. Clashes with Blessing of Wisdom.
- Mining: **Lodestone** = melee attack power. Clashes with Blessing of Might.
- Fishing: **Fish Bowl** = all stats. Clashes with Blessing of Kings.
- First Aid: **First Aid Kit** = Stamina. Clashes with Power Word: Fortitude.
- Tailoring: **Faction Banner** = Spirit, for your own faction only. Clashes with Divine Spirit.
- Enchanting: **Enchanted Lute** = armor, all stats and resistances. Clashes with Mark of the Wild.
- Leatherworking: **Camp Tent** = rest 30 seconds near it for extra rested XP, once per hour.
- Engineering: **Reagent Bot** = no buff, it sells reagents.
- **/mh camp** shows what MH can read of your camp buffs.]] },
	{ "Legacy Points", [[
- **Legacy Points** are earned by your whole account: 65 challenges, 1 point each. Each character spends its own points, up to 16 for now.
- **How you earn them:** a class reaching 25, 45 and 60 for the first time. Alchemy, Blacksmithing, Enchanting, Engineering, Leatherworking and Tailoring at 150, 225 and 300. A few more for PvP, dungeons, raids and exploring.
- Gathering professions, Cooking, First Aid and Fishing give no points.
- The window opens with your first point. For most players that is at level 25.
- **Spending:** press the **Legacy** button in the menu bar. There are three trees: **Professions**, **Adventure** and **Resourcefulness**. Each rank costs 1 point.
- **Column 2** opens after 5 points in that tree, **column 3** after 10.
- **Undo:** at your class trainer, all perks at once. The trainer shows the price. Do you have Talented? Then unlearn your class talents first.
- **Rewards** at 15, 25, 40 and 55 earned points (earned, not spent). Pick them up from **Innkeeper Wiley** in Ratchet.
- **Example, leveling:** **Well Rested** (rested XP builds up faster), then **Talented** (needs Well Rested): talent points up to 5 levels earlier, never more than 51 in total.
- **Example, professions:** **Working Overtime** (more skill-ups) and **Bountiful Harvest** (Scarce materials more often from Mining, Herbalism and Skinning).
- **Dedicated Study** is a button, not a passive perk: a 25-second cast, then 23 hours wait. It raises your lowest tradeskill by 1.
- **/mh legacy** shows how many points MH can read.]] },
	-- 21 Nov 2026 (Rob: "welke talentpunten ... ook bij andere"; GO "Ja, voeg dat maar toe"). Blizzard: Dual Spec at 40 and
	-- "the price climbs quickly and only decreases once per week". GEMETEN DB2 1.60.1.71037: spells 63624/63644/63645,
	-- GlobalStrings TALENT_SPEC_SECONDARY "Secondary Talents", switch cast 5 s (SpellMisc → SpellCastTimes 6 = 5000 ms).
	-- Players: 50 gold (Wowhead news 11 Nov), respec 1, 5, 10 gold (timesaver.gg 16 Nov, realmfirst.net 17 Nov).
	-- 27 Nov 2026 (Rob via Sparring 27-11: "Ja en ja"): the bars line. PLAYER REPORTS only (forums 20 + 26 Nov, US and
	-- EU; docs/API_WATCH.md 27 Nov), not measured by us, hence "can". Same warning in Do this now (FDONOW_DUALSPEC_BARS).
	{ "Talents: reset and Dual Spec", [[
- **Reset your talents** at your class trainer: talk to them and pick the talent option. Then spend your points again. Players say it costs 1 gold the first time, then 5, then 10, and more after that. Blizzard says the price climbs quickly and goes down once a week.
- **Dual Spec:** from level 40 your class trainer sells a second set of talents. In the game it is called **Secondary Talents**. Players say it costs 50 gold; Blizzard gave no price.
- **Switching** between your two sets takes 5 seconds and does not work in a fight.
- **Your bars after a switch:** players report that switching can change your action bars: the game can put spells on them, over your own buttons and macros. MH has not seen this in the game itself. Check your bars after your first switch.
- **Why:** level with one set and tank or heal with the other. A Paladin levels as Retribution and tanks as Protection, a Druid levels as a cat and heals as Restoration.]] },
}

local CLASSES = {
	DRUID = {
		{ "What it does", [[
The Druid can change shape. As a normal caster it throws spells and heals. Later it can turn into a bear or a cat, to fight up close. The bear has a taunt (Growl), so it is the shape for tanking.
A **form** is one of those shapes. In a form, many of your keys do something else. MH's keys switch by themselves: the same key is one spell as a caster and another spell as a bear.]] },
		{ "Levels 1-10: your buttons", [[
- **1** = Wrath (level 1): your main attack spell.
- **2** = Moonfire (4): damage, then more damage over a few seconds.
- **C** = Healing Touch (1): your big heal.
- **F4** = Rejuvenation (4): a heal that heals you a little at a time.
- **Shift-X** = Mark of the Wild (1): a buff. A **buff** is a good effect on you or a friend. Put it on before a fight.
- **Shift-Z** = Thorns (6): another buff.
- **V** = Entangling Roots (8): holds an enemy in place.
- **X** = Nature's Grasp (10).
- **Shift-E** = your race spell (Shadowmeld for a Night Elf, War Stomp for a Tauren).
- **Level 10, Bear Form** (from a quest): **Ctrl-1** turns you into a bear. As a bear: **1** = Maul, **F** = Growl, **Shift-2** = Demoralizing Roar.]] },
		{ "Simple order (caster)", [[
Moonfire (2) first, then Wrath (1) until the enemy is dead. Low on health? Rejuvenation (F4) or Healing Touch (C).]] },
		{ "What comes later", [[
- 12: Regrowth on F2 (quick heal). Revive on F3: brings a dead friend back, outside a fight only.
- 16: Aquatic Form (from a quest) on R while you swim. 18: Faerie Fire on 5 (works in most forms, but not in Travel or Aquatic Form), Hibernate on Shift-Q.
- 20: Cat Form (from a quest) on Ctrl-2, with Claw, Shred, Rip and Prowl. Feral Charge on E (a talent, 20 at the earliest). Starfire on 3. In a fight, F3 becomes Rebirth.
- 30: Travel Form on R (for moving around), Tranquility on Q. 40: Dire Bear Form (replaces Bear Form on Ctrl-1), Innervate on F1.
- 44: Barkskin on Z, in every form.]] },
		{ "Beginner mistakes", [[
- Pressing a heal while you are in a form. Your heals only work in your normal shape, not in Bear, Cat, Aquatic or Travel Form. Leave the form first: press the same form key again (Ctrl-1 for the bear, Ctrl-2 for the cat).
- In Moonkin Form (a talent, level 40 at the earliest) your attack spells work, but your heals do not.
- What does work in a form: potions, Barkskin, Nature's Grasp, Faerie Fire and your race spell.]] },
	},
	PALADIN = {
		{ "What it does", [[
The Paladin is a holy fighter. It hits up close, heals itself and others, and protects friends. It has no shapes and no stances, so every key always does the same thing.
A **seal** is a holy power you put on yourself. It lasts 30 seconds, and you can have only one at a time. An **aura** is a power you switch on and leave on; it helps your whole group. A **blessing** is a buff you put on yourself or a friend; it lasts 60 minutes. A **buff** is a good effect.]] },
		{ "Seals and auras", [[
- **Seal of Righteousness** (1): every hit does extra holy damage. A slow weapon does more per hit.
- **Seal of the Crusader** (6, own Alt key): you swing faster, but each hit does less.
- **Seal of Fury** (10): the tank seal. With a shield, every hit also gives you a small shield.
- **Seal of Command** (talent, level 20 at the earliest): hits sometimes do a big extra holy hit. Once you have it, key 3 casts this one instead of Seal of Righteousness.
- **Seal of Justice** (22), **Seal of Light** (30), **Seal of Wisdom** (38), all on your own Alt keys: hits sometimes stun, heal you, or give you mana.
- **Devotion Aura** (1): more armor for your group. **Retribution Aura** (16): holy damage to anything that hits your group. **Concentration Aura** (22): casters in your group get interrupted less when they are hit.]] },
		{ "Levels 1-10: your buttons", [[
- **3** = Seal of Righteousness (level 1): your seal.
- **C** = Holy Light (1): your big heal. Undead Paladins get it from the level-2 quest "Rediscovering the Light".
- **Ctrl-1** = Devotion Aura (1, from the trainer): turn it on and leave it on.
- **2** = Judgement (4): cooldown 10 seconds. It does not use up your seal. It only works while a seal is on: put your seal on first (**3**). Without one the game says "You can't do that yet".
- **Shift-Z** = Blessing of Might (4): put it on yourself.
- **1** = Holy Strike (6): your main hit, up close.
- **Z** = Divine Protection (6): for 6 seconds nothing can hurt you, but you cannot attack either. Cooldown 5 minutes.
- **E** = Hammer of Justice (8): stuns the enemy. A **stun** means the enemy cannot move or cast for a few seconds. The Paladin has no real interrupt, so this is your "stop that spell" key.
- **Shift-C** = Purify (8): removes a bad effect from a friend.
- **Q** = Lay on Hands (10): your emergency button. It heals a friend (or you) to full health, but uses up all the mana you have left. Cooldown 20 minutes.
- **Shift-F** = Blessing of Protection (10): saves a friend who is in trouble.
- **F** = Seal of Fury (10): a seal for tanking. Its Judgement taunts. **Taunt** = make the enemy attack you.]] },
		{ "Simple order", [[
Seal (3) before the fight. Then Holy Strike (1) and Judgement (2) whenever they are ready. Put the seal back on when it runs out (it lasts 30 seconds). Low on health? Holy Light (C).]] },
		{ "What comes later", [[
- 12: Redemption (from a quest) on F3 (brings a dead friend back; not in a fight). 14: Blessing of Wisdom on Shift-V.
- 18: Blessing of Freedom on R (nothing can slow you for a while). 20: Consecration on Shift-1 (hits several enemies at once), Exorcism on 5, Flash of Light on F2 (quick heal), Blessing of Kings on Shift-X.
- 30: Divine Intervention: in a fight, F3 casts this one instead of Redemption. Careful: you die yourself; the friend you pick is safe from all attacks for a short time. 34: Divine Shield on Z: 10 seconds where nothing can hurt you, and you can still fight (with half damage).
- 42: Cleanse replaces Purify on Shift-C. 44: Hammer of Wrath on 4 (only when the enemy is at 20% health or less).
- 52-60: in a group, the blessing keys cast the Greater Blessing for the whole group; solo they cast the normal one.]] },
		{ "Beginner mistakes", [[
- Pressing Exorcism (5) on a normal enemy. It only works on Undead and Demons. Turn Undead (Shift-Q, 24) works on Undead only.
- Pressing Hammer of Wrath (4) early in the fight. It only works when the enemy is almost dead (20% health or less).
- Divine Shield and Divine Protection share one cooldown, so they sit on one key (Z). These protection spells, Blessing of Protection and Templar's Bulwark give **Forbearance**: for 1 minute you cannot get any of them again. Lay on Hands does not.]] },
	},
	MAGE = {
		{ "What it does", [[
The Mage stands back and casts fire, frost and arcane magic. It keeps enemies away with spells that hold them in place or slow them. The Mage has no shapes and no stances, so every key always does the same thing.]] },
		{ "Levels 1-10: your buttons", [[
- **1** = Fireball (level 1): your main attack spell. With the Arcane Blast talent (20 at the earliest), Arcane Blast takes key 1 and Fireball moves to Ctrl-2.
- **Shift-Z** = Frost Armor (1): a buff on yourself. Put it on before a fight. You can only have one armor on.
- **Shift-X** = Arcane Intellect (1): a buff for you or a friend.
- **Ctrl-3** = Shoot: your **wand** (a small magic stick that shoots by itself), once you have one. Handy when your mana is low. When you learn Frostfire Bolt, that takes Ctrl-3; put Shoot on one of your own Alt keys if you still want it.
- **2** = Frostbolt (4): frost damage. With the direction Frost (the direction button at the top of How you play), Frostbolt takes key 1 from level 4, and Fireball moves to 2.
- **5** = Fire Blast (6): instant fire hit. **Instant** = no cast time. Cooldown 8 seconds.
- **3** = Arcane Missiles (8): arcane damage.
- **Shift-Q** = Polymorph (8): takes one enemy out of the fight for a while. That kind of spell is called **CC** (crowd control).
- **V** = Frost Nova (10): freezes every enemy within 10 yards around you, for up to 8 seconds. Damage can break it. Cooldown 25 seconds.
- Conjure Water (4) and Conjure Food (6) are not on the block. They go on your own Alt keys (block D).]] },
		{ "Simple order", [[
Frostbolt (2) or Fireball (1) as the enemy comes in. Fire Blast (5) when it is ready. Enemy close to you? Frost Nova (V), step away, keep casting.]] },
		{ "What comes later", [[
- 12: Slow Fall on Shift-R. 14: Arcane Explosion on Shift-2 (hits several enemies). 16: Flamestrike on Shift-4.
- 18: Remove Lesser Curse on Shift-V. 20: Blink on R (your movement spell), Blizzard on Shift-1, Evocation on F1 (gets mana back), Mana Shield on Z, Fire Ward on F4. Also the teleports (and later portals): travel spells, not on the block. Put them on your own bar, or use them from your spellbook.
- 22: Scorch on Ctrl-1, Frost Ward on F2. 24: Counterspell on E: your **interrupt** (it stops an enemy's spell).
- 26: Cone of Cold on Shift-F. 30: Ice Armor: Shift-Z casts it from then on instead of Frost Armor (it also protects you against frost).
- Talents from level 20: Pyroblast on 4, Ice Lance on F, Arcane Blast on 1 (Fireball then moves to Ctrl-2), Ice Block on C (25 at the earliest).]] },
		{ "Beginner mistakes", [[
- Expecting both wards at once. Fire Ward (F4) and Frost Ward (F2) share one 30-second cooldown, so only one at a time.
- Wearing Mage Armor and Ice Armor together. Only one armor can be on at a time. Mage Armor (34) is on block D.]] },
	},
	HUNTER = {
		{ "What it does", [[
The Hunter shoots from a distance with a ranged weapon, and from level 10 has a **pet**: an animal you tame that fights next to you. Up close it has a few melee hits.
**Auto Shot** = your weapon keeps shooting by itself until you stop. **Melee** = fighting up close. The Hunter has no shapes and no stances, so every key always does the same thing.]] },
		{ "Levels 1-10: your buttons", [[
- **1** = Auto Shot (level 1): starts shooting. MH's key is made so a second press does not stop it. From level 6 Hunter's Mark takes key 1, and Auto Shot moves to Shift-Z. Serpent Sting and Arcane Shot start Auto Shot by themselves.
- **5** = Raptor Strike (1): your hit when the enemy is next to you. It needs a **melee weapon** (a weapon for up close) in your main hand: the axe or dagger you start with counts, a Skinning Knife does not.
- **2** = Serpent Sting (4): damage over a few seconds.
- Aspect of the Monkey (4) goes on your own Alt keys (block D). An **aspect** is a stance-like buff on yourself. Only one aspect can be on at a time.
- **3** = Arcane Shot (6): instant shot. Cooldown 6 seconds.
- **1** = Hunter's Mark (6): put it on the enemy once, as the first press of a fight. From then on it is on key 1 (see Auto Shot above).
- **Shift-Q** = Concussive Shot (8): slows the enemy.
- **Shift-R** = Aspect of the Hawk (10): your main aspect.
- **Level 10, pet quests:** you learn Tame Beast, Call Pet and Dismiss Pet; the quest after them (Training the Beast) gives Revive Pet and Feed Pet. **F4** = Call Pet (brings your pet), **F3** = Revive Pet (brings a dead pet back). Tame Beast has no key; you use it outside a fight.
- From then on your pet has three keys: **Ctrl-1** = attack your target, **Ctrl-2** = follow you, **Ctrl-3** = stay where it is.]] },
		{ "Simple order", [[
Hunter's Mark (1), Serpent Sting (2), then Arcane Shot (3) when it is ready. Serpent Sting and Arcane Shot start Auto Shot by themselves; if it stopped, Auto Shot (Shift-Z). Before level 6 you have no Hunter's Mark yet, and key 1 is Auto Shot. Enemy next to you? Raptor Strike (5), with a melee weapon in your hand. From level 10: Aspect of the Hawk on (Shift-R) first, and send your pet in (Ctrl-1) before you shoot.]] },
		{ "What comes later", [[
- 6: Hunter's Mark takes key 1, and Auto Shot moves to Shift-Z. MH tells you once when it happens.
- 10: Feed Pet and Dismiss Pet are not on the block (you use them outside a fight); put them on your own bar. The same for Scare Beast (14).
- 12: Distracting Shot on F (makes the enemy attack you), Mend Pet on F2 (heals your pet), Wing Clip on Shift-F.
- 16: Immolation Trap on Shift-2, Mongoose Bite on Shift-C (only after you dodge). 18: Multi-Shot on Shift-1.
- 20: Aimed Shot on 4 (your big shot), Aspect of the Cheetah on R (run fast), Disengage on Z, Freezing Trap on V.
- 26: Rapid Fire on Q. 30: Feign Death on X, Aspect of the Beast (block D). 34: Explosive Trap takes over Shift-2.
- All four traps share one 30-second cooldown.]] },
		{ "Beginner mistakes", [[
- Shooting at an enemy right next to you. Your gun or bow does not work within 8 yards (the "dead zone"): use Raptor Strike (5), or step back.
- Raptor Strike, Wing Clip, Mongoose Bite, Counterattack and Disengage with no melee weapon in your main hand. Then the spell's tooltip says in red that it needs one, and the key does nothing. The axe or dagger you start with counts; a Skinning Knife or a fishing pole does not. Lost yours? A weaponsmith sells a cheap one.
- Expecting one key to shoot far away and hit up close. A macro cannot see distance, so melee has its own keys (5, Shift-F, Shift-C).
- Pressing Mend Pet (F2) to heal yourself. It heals your pet only. The Hunter has no self heal.]] },
	},
	WARRIOR = {
		{ "What it does", [[
The Warrior fights up close with a weapon. It has three stances, and from level 10 it can tank. It does not heal itself, except with Victory Rush (level 20).
The Warrior has **Rage** instead of mana. You get Rage when you hit and when you are hit. Outside a fight, your Rage slowly runs down to 0.]] },
		{ "Stances", [[
A **stance** is a way of fighting that you switch on with a key. You are always in one stance. Some spells only work in one or two stances. MH's keys switch by themselves: in another stance, the same key casts another spell. If a key has nothing for your stance, it does nothing (no error).
- **Battle Stance** (1): your stance for normal fighting.
- **Defensive Stance** (10, from a quest): the stance for tanking. Only here you have Taunt.
- **Berserker Stance** (30, from the quest "The Affray"). Here E becomes Pummel and R becomes Intercept.
- **Tactical Mastery** (14, passive, you do nothing): you keep up to 10 Rage when you change stance.
- No key changes your stance by itself. You pick the stance; the keys follow.]] },
		{ "Levels 1-10: your buttons", [[
- **1** = Heroic Strike (level 1): your main hit, in every stance.
- **Ctrl-1** = Battle Stance (1): turn it on and leave it on.
- **Shift-X** = Battle Shout (1): a buff. A **buff** is a good effect on you or a friend. Put it on before a fight.
- **R** = Charge (4): run to an enemy to start a fight. It works in Battle Stance only, and not once you are already fighting.
- **Shift-Z** = Rend (4): a **bleed**: damage over a few seconds. Battle and Defensive Stance.
- **Shift-1** = Thunder Clap (6): hits several enemies at once. Battle and Defensive Stance. Cooldown 6 seconds.
- **V** = Hamstring (8): slows the enemy a lot for 15 seconds. Battle and Berserker Stance.
- **F1** = Bloodrage (10): gives you Rage right away and a bit more over a few seconds. It costs a little health. Cooldown 1 minute.
- **Level 10, Defensive Stance** (from a quest): **Ctrl-2** turns it on. The same quest gives **5** = Sunder Armor and, in Defensive Stance, **F** = Taunt. **Taunt** = make the enemy attack you. Cooldown 8 seconds.
- Shoot Bow, Shoot Gun, Shoot Crossbow and Throw go on your own Alt keys (block D). You get the one that fits your ranged weapon. Use it to **pull**: hit one enemy from far away, so it comes to you.]] },
		{ "Simple order", [[
Battle Stance on (Ctrl-1), Battle Shout (Shift-X). Charge (R) in. Rend (Shift-Z), then Heroic Strike (1) again and again. Several enemies? Thunder Clap (Shift-1).]] },
		{ "What comes later", [[
- 12: Overpower on 2 (Battle Stance; after the enemy dodges), Shield Bash on E: your **interrupt** (it stops an enemy's spell).
- 14: Revenge on 2 (Defensive Stance), Demoralizing Shout on Shift-2. 16: Mocking Blow on F (Battle Stance), Shield Block on Z (Defensive Stance). 18: Disarm on V (Defensive Stance).
- 20: Cleave on Shift-4, Slam on Shift-C, Victory Rush on F2 (only in the 20 seconds after you kill an enemy that gives XP; it heals you a bit; cooldown 30 seconds), Retaliation on C (Battle Stance). 22: Intimidating Shout on Shift-Q. 24: Execute on 4 (Battle and Berserker Stance; only when the enemy is at 20% health or less).
- 26: Challenging Shout on Shift-F. 28: Shield Wall on C (Defensive Stance).
- 30: Berserker Stance on Ctrl-3. In it: Intercept on R, Berserker Rage on Shift-V. 36: Whirlwind on 2 (Berserker). 38: Pummel on E (Berserker). 50: Recklessness on Q (Berserker).
- Talents: Last Stand on X and Piercing Howl on Shift-R (an area slow), 20 at the earliest. Spearing Strike on F3 (Battle Stance) and Reckless Swings on Shift-F1, 25. Sweeping Strikes on Q (Battle Stance), Death Wish on Shift-3, Concussion Blow on Shift-V (a stun), 30. Mortal Strike, Bloodthirst or Shield Slam on 3, 40.]] },
		{ "Beginner mistakes", [[
- Pressing a key in the wrong stance. Taunt only works in Defensive Stance, Overpower only in Battle Stance. In the wrong stance the key does nothing. Look at your stance first.
- Charge in Defensive Stance. It only works there with the **Vanguard** talent. Without it, you get a red error.
- Charge in a fight. Charge only starts a fight; once you are fighting, it does not work.
- Thunder Clap (Shift-1) does not work in Berserker Stance.
- Shield Bash, Shield Block and Shield Slam without a shield. All three need a shield in your off hand.
- Expecting Slam to be quick. In Forever it has a 1.5-second cast and a 15-second cooldown.
- Retaliation and Shield Wall are both on C, each with its own 15-minute cooldown. Keep them for real trouble.]] },
	},
	ROGUE = {
		{ "What it does", [[
The Rogue fights up close with fast hits. It can sneak up on enemies unseen, and it has many ways to stop an enemy for a moment.
The Rogue has **Energy** instead of mana. Energy fills up by itself, fast: an empty bar is full again in about 10 seconds.]] },
		{ "Stealth and finishers", [[
**Stealth** (level 1, Shift-R) makes you hard to see. You move at half speed. Some attacks only work from Stealth: they are your **openers**, the first hit of a fight. In Stealth, MH's keys switch by themselves:
- **1** becomes Garrote (14), **2** becomes Ambush (18), **V** becomes Cheap Shot (26), **Shift-Q** becomes Sap (10), **F** becomes Pick Pocket (4).
- Before you know the Stealth spell, the key just keeps its normal spell.
Hits like Sinister Strike give you **combo points** (up to 5). A **finisher** is a hit that uses all your combo points: Eviscerate (**4**), Slice and Dice (**Shift-4**) and Rupture (**5**). More points make it stronger.]] },
		{ "Levels 1-10: your buttons", [[
- **1** = Sinister Strike (level 1): your main hit. With Hemorrhage (Subtlety, 30 at the earliest) or Mutilate (Assassination, 40 at the earliest), both talents, that one takes key 1 and Sinister Strike moves to 3.
- **4** = Eviscerate (1): your main finisher.
- **Shift-R** = Stealth (1): sneak. Press it again to leave Stealth. After you leave Stealth, you cannot go back in for 10 seconds.
- **Shift-2** = Throw (1): a ranged throw. You need a throwing weapon (like throwing knives) in your ranged slot. With a gun, bow or crossbow equipped, the key shoots that instead.
- **2** = Backstab (4): a strong hit. You need a dagger, and you must stand behind the enemy.
- **F** = Pick Pocket (4): in Stealth only. It steals from the enemy.
- **Shift-Q** = Gouge (6): stops one enemy for a moment. Any damage breaks it. That kind of spell is called **CC** (crowd control).
- **Z** = Evasion (8): you dodge many more attacks for 15 seconds. Cooldown 5 minutes.
- **Shift-4** = Slice and Dice (10): your second finisher.
- **R** = Sprint (10): run fast.
- **Shift-Q** = Sap (10): in Stealth only. Takes one humanoid enemy out for a while, before the fight starts. It does not work on beasts or on enemies already fighting. Damage breaks it. Sap does not break your Stealth.
- **F4** = your race's heal over time, if it has one: Cannibalize (Undead; only near a Humanoid or Undead corpse), Rapid Regeneration (Troll; stops when you move, act or take damage), Read Leyline (High Order Skyborne).
- **Shift-E** = your race spell (for example Shadowmeld for a Night Elf, Blood Fury for an Orc).]] },
		{ "Simple order", [[
Stealth (Shift-R) and walk up to the enemy. Sinister Strike (1) a few times, then Eviscerate (4). With a dagger and behind the enemy: Backstab (2). From level 10: keep Slice and Dice (Shift-4) up.]] },
		{ "What comes later", [[
- 12: Kick on E: your **interrupt** (it stops an enemy's spell). 14: Expose Armor on Shift-Z, Garrote on 1 in Stealth.
- 16: Feint on F (outside Stealth). It lowers your **threat**: how much the enemy wants to attack you. Pick Lock (block D).
- 18: Ambush on 2 in Stealth (dagger, from behind). 20: Rupture on 5. Poisons (from a quest; see below).
- 22: Distract on Shift-F, Vanish on X (your escape; each use costs a Flash Powder, an item in your bags). 24: Shank on Shift-3 (a hit with your off-hand weapon, so you need a weapon in each hand; cooldown 10 seconds; gives 15 Energy back).
- 26: Cheap Shot on V in Stealth: a **stun** (the enemy cannot move or act for a few seconds). 30: Kidney Shot on V outside Stealth. Disarm Trap (block D). 34: Blind on Shift-V (costs a Blinding Powder).
- Talents: Riposte on Shift-F1 and Premeditation on Shift-C, 20 at the earliest. Cold Blood on F1 and Ghostly Strike on Shift-X, 25. Blade Flurry on Shift-1 (hits more enemies), Preparation on F3 (resets the cooldown of your other Rogue spells, like Evasion, Sprint and Vanish), Hemorrhage on 1, 30. Mutilate on 1, Adrenaline Rush or Death Mark on Q, 40. With Hemorrhage or Mutilate on 1, Sinister Strike moves to 3.]] },
		{ "Beginner mistakes", [[
- Pressing an opener outside Stealth. Garrote, Ambush, Cheap Shot, Sap and Pick Pocket need Stealth. Outside Stealth, the same key casts its normal spell.
- Pressing Stealth again by accident. That ends Stealth, and you cannot go back in for 10 seconds.
- Night Elf: Shadowmeld is your race spell, not your class Stealth. For your openers, use Stealth (Shift-R).
- Backstab and Ambush from the front, or without a dagger. Both need a dagger, and you must stand behind the enemy.
- Hitting an enemy you took out with Gouge or Sap. Any damage wakes it up.
- Sap on a beast or on an enemy that is already fighting. Sap only works on humanoids, before the fight.
- Vanish or Blind with no powder in your bags. Vanish needs a Flash Powder, Blind needs a Blinding Powder.
- Looking for poisons on the block. **Poisons** are items you make (you learn Poisons from a quest at about level 20). You put them on your weapon. Drag them to your own Alt keys (block D) yourself.
- Ghostly Strike (talent): after it, your next Ambush or Garrote works without Stealth, if you use it within 7 seconds. MH's keys cannot see that, so outside Stealth keys 1 and 2 still cast Sinister Strike and Backstab.]] },
	},
	PRIEST = {
		{ "What it does", [[
The Priest heals, and hits with holy and shadow magic from a distance. It protects friends with a shield. Later it can choose **Shadowform** (a talent, level 40 at the earliest): more shadow damage, but no healing.
The Priest has no stances. Shadowform does not change the keys: every key always does the same thing.]] },
		{ "Your race's own spells", [[
Every Priest race has two Priest spells of its own: one at level 10 and one at level 20. You get both from a quest, not from the trainer. MH puts them on **X** and **Shift-R**, so every race uses the same two keys.
- Dwarf: Desperate Prayer (10, X; cooldown 10 minutes), Chastise (20, Shift-R).
- Human: Divine Grace (10, Shift-R; an instant heal on a friend below half health, not on you; cooldown 10 minutes), Feedback (20, X).
- Night Elf: Starshards (10, Shift-R; cooldown 30 seconds), Elune's Grace (20, X).
- Undead: Touch of Weakness (10, X), Dark Sacrifice (20, Shift-R; trade your own health for mana).
- Troll: Hex of Weakness (10, Shift-R), Shadowguard (20, X).
- Gnome: Confounding Flash (10, Shift-R), Contingency Plan (20, X; a ward on a friend that heals and shields them when their health drops low).]] },
		{ "Levels 1-10: your buttons", [[
- **1** = Smite (level 1): your main attack spell.
- **C** = Lesser Heal (1): your main heal. Later Heal (16) and Greater Heal (40) take over this key.
- **5** = Shoot (1): your **wand** (a small magic stick that shoots by itself). You need a wand in your hands.
- **Shift-X** = Power Word: Fortitude (1): a buff. A **buff** is a good effect on you or a friend. Put it on before a fight.
- **2** = Shadow Word: Pain (4): shadow damage.
- **Z** = Power Word: Shield (6): a shield on you or a friend. Cooldown 4 seconds, but the same person can only get a new shield after 15 seconds.
- **F** = Fade (8): enemies want to attack you less for a while. Cooldown 30 seconds.
- **F4** = Renew (8): a heal that heals a little at a time.
- **3** = Mind Blast (10): shadow damage. Cooldown 8 seconds.
- **F3** = Resurrection (10): brings a dead friend back. Outside a fight only.
- Your race spell of level 10 is on **X** or **Shift-R** (see the list above).
- **Shift-E** = your race skill (for example Stoneform for a Dwarf, Shadowmeld for a Night Elf).]] },
		{ "Simple order", [[
Power Word: Shield (Z) on yourself. Shadow Word: Pain (2), Mind Blast (3), then Smite (1). Low on mana? Use your wand (5). Low on health? Renew (F4) or Lesser Heal (C).]] },
		{ "What comes later", [[
- 12: Inner Fire on Shift-Z. 14: Cure Disease on Shift-C, Psychic Scream on V (a few enemies around you run away in fear for up to 8 seconds; damage can end it; cooldown 30 seconds).
- 18: Dispel Magic on Shift-V. 20: Flash Heal on F2 (quick heal), Holy Fire on 4, Shackle Undead on Shift-Q, Devouring Plague on Shift-3, your race spell of level 20, Fear Ward (block D).
- 30: Prayer of Healing on Shift-2 (heals your group), Mind Control on Shift-F. 32: Shadow Word: Death on Shift-4, Abolish Disease takes over Shift-C. 34: Levitate on R (costs a Light Feather). 48: Prayer of Fortitude takes over Shift-X (costs a Holy Candle).
- Talents: Mind Flay (takes over key 1), Holy Nova on Shift-1 and Inner Focus on F1, 20 at the earliest. Vampiric Embrace on Ctrl-3, 25. Penance on Shift-F1 and Silence on E (your **interrupt**: it stops an enemy's spell), 30. Power Infusion on Q, Shadowform on Ctrl-1, Prayer of Mending on Ctrl-2, 40.]] },
		{ "Beginner mistakes", [[
- Healing in Shadowform. No healing spell works in Shadowform. Fear Ward does not work in it either. Leave it first: press Ctrl-1 again.
- Missing Smite after you take Mind Flay. Once you know Mind Flay, key 1 casts Mind Flay, not Smite.
- Pressing Shoot (5) without a wand. Buy or find one first.
- Looking for an interrupt on E early. The Priest only gets one from the Silence talent (30 at the earliest).
- Shackle Undead (Shift-Q) on a normal enemy. It only works on Undead enemies.]] },
	},
	SHAMAN = {
		{ "What it does", [[
The Shaman casts lightning and fire, heals, and places totems. It can fight from a distance or up close with a weapon. Dwarves (Alliance) can be a Shaman too in Forever.
The Shaman has no stances. **Ghost Wolf** (level 20, on R) is a form for running, but it does not change your keys.]] },
		{ "Totems and weapon buffs", [[
A **totem** is a small object you place on the ground. It helps you or your group, or hurts enemies, while it stands. Totems belong to four elements: Earth, Fire, Water and Air. You can have one totem of each element at a time. A new one replaces the old one.
- Each element has a Totem item that you get from a class quest: Earth (level 4, or 3 for the Skyborne), Fire (10), Water (20), Air (30). You need that item in your bags for all totems of that element.
- Before level 20, your totems each have their own key: Stoneskin (**Z**), Earthbind (**V**), Stoneclaw (**F**), Strength of Earth (**Shift-X**), Searing (**5**), Tremor (**Shift-F**).
- From level 20 the game gives you a **totem bar**. On it you pick one totem per element. Then one key places them all: **Ctrl-1** = Call of the Elements (20), **Ctrl-2** = Call of the Ancestors (30), **Ctrl-3** = Call of the Spirits (40). Each one places up to 4 totems from its own page of the totem bar. It has a 3-second cast and costs the mana of all the totems it places.
- **Shift-R** = Totemic Call (22): moves your totems to you. Totemic Recall (20, block D) takes them back and gives you a quarter of their mana back.
A **weapon buff** puts power on your weapon for 60 minutes. You have one at a time. Rockbiter (1), Flametongue (10), Frostbrand (20) and Windfury (30) go on your own Alt keys (block D). Pick the one that fits how you play.]] },
		{ "Levels 1-10: your buttons", [[
- **1** = Lightning Bolt (level 1): your main attack spell. With the Stormstrike talent (25 at the earliest), Stormstrike takes key 1 and Lightning Bolt moves to 3.
- **C** = Healing Wave (1): your big heal.
- Rockbiter Weapon (1) goes on block D (see above).
- **E** = Earth Shock (4): your **interrupt** (it stops an enemy's spell), and damage.
- **Z** = Stoneskin Totem (4, from a quest): you take less damage from melee hits. **Melee** = fighting up close.
- **V** = Earthbind Totem (6): slows enemies near it. Cooldown 15 seconds.
- **F** = Stoneclaw Totem (8): makes enemies around it attack the totem. Cooldown 30 seconds.
- **Shift-Z** = Lightning Shield (8): a shield on yourself. Only one shield at a time.
- **2** = Flame Shock (10): fire damage, then more damage over a few seconds.
- **5** = Searing Totem (10, from a quest): your damage totem.
- **Shift-X** = Strength of Earth Totem (10): a totem that buffs your group. A **buff** is a good effect.
- Flametongue Weapon (10) goes on block D.
- **Shift-E** = your race spell (for example War Stomp for a Tauren, Stoneform for a Dwarf).]] },
		{ "Simple order", [[
Weapon buff on (block D), Lightning Shield on (Shift-Z). Searing Totem (5) down. Flame Shock (2), then Lightning Bolt (1). Keep Earth Shock (E) for when the enemy casts a spell. Low on health? Healing Wave (C).]] },
		{ "What comes later", [[
- 12: Fire Nova on Shift-4, Purge on Shift-Q (removes magic from an enemy), Ancestral Spirit on F3 (brings a dead friend back). 16: Cure Poison on Shift-C. 18: Tremor Totem on Shift-F (removes fear, charm and sleep from your group).
- 20: Ghost Wolf on R (3-second cast, outdoors only), Frost Shock on 4 (slows), Lesser Healing Wave on F2 (quick heal), Healing Stream Totem on F4 (from a quest; heals your group a little at a time; needs the Water Totem), Call of the Elements on Ctrl-1.
- 22: Cure Disease on Shift-V, Totemic Call on Shift-R. 30: Grounding Totem on X (catches one harmful spell aimed at you or a group member nearby; not area spells; needs the Air Totem from the level 30 quest), Call of the Ancestors on Ctrl-2. 32: Chain Lightning on Shift-1 (hits several enemies).
- 40: Chain Heal on Shift-2 (heals several friends), Call of the Spirits on Ctrl-3.
- Talents: Water Shield (takes over Shift-Z), 20 at the earliest. Stormstrike on 1 (Lightning Bolt then moves to 3) and Mana Tide Totem on F1, 25. Nature's Swiftness on Shift-3, 30. Riptide on Shift-F1, and Lightning Mastery or Rage of the Farseer on Q, 40.]] },
		{ "Beginner mistakes", [[
- Using a shock right before you need to interrupt. Earth Shock (E), Flame Shock (2) and Frost Shock (4) share one 6-second cooldown. After Flame Shock, there is no interrupt for up to 6 seconds.
- Pressing Fire Nova (Shift-4) with no Fire totem down. It needs one of your Fire totems (like Searing or Magma). It hits the enemies near that totem, not the ones near you.
- Placing a totem without its Totem item. Each element needs its own Totem item in your bags, from a class quest.
- Casting in Ghost Wolf. Your spells are not made for the wolf. Leave Ghost Wolf first, then cast.
- Forgetting the weapon buff. It lasts 60 minutes and it is not on the block: it is on your own Alt keys (block D).
- Expecting two shields. Once you have Water Shield, Shift-Z casts that one, not Lightning Shield.]] },
	},
	WARLOCK = {
		{ "What it does", [[
The Warlock stands back and casts shadow and fire magic. Much of its damage comes slowly: spells that hurt the enemy over time, and curses. It almost always has a demon with it.
A **DoT** (damage over time) is a spell that hurts the enemy a little at a time for a while. A **curse** or **bane** is a bad effect you put on an enemy. One curse and one bane can be on the same enemy. The Warlock has no shapes and no stances, so every key always does the same thing.]] },
		{ "Your demon", [[
Your **pet** is a demon you call up. It fights next to you. You learn the demons from class quests.
- **Summon Imp** (1): from your first class quest in your starting area. The name depends on your race: Human "The Stolen Tome", Gnome "Beginnings", Orc and Troll "Vile Familiars", Undead "Piercing the Veil". The Imp costs no Soul Shard.
- **Summon Voidwalker** (10, quest). **Summon Succubus** or **Summon Incubus** (20, quest). **Summon Felhunter** (30, quest). Each of these costs 1 **Soul Shard** (see Drain Soul below).
- **Inferno** (50) is on **F3**. Each cast needs an Infernal Stone. Cooldown 1 hour.
- The summons are not on the block. They go on your own Alt keys (block D).
- From your first demon, your pet has three keys: **Ctrl-1** = attack your target, **Ctrl-2** = follow you, **Ctrl-3** = stay where it is.
- The Voidwalker can taunt (Torment). The Felhunter can stop an enemy's spell (Spell Lock, from 36). These are your demon's own spells, on Blizzard's pet bar.]] },
		{ "Levels 1-10: your buttons", [[
- **1** = Shadow Bolt (level 1): your main attack spell.
- **3** = Immolate (1): fire damage, then more damage over time.
- **Shift-Z** = Demon Skin (1): a buff on yourself (more armor). A **buff** is a good effect. From 20, Demon Armor takes over this key.
- **2** = Corruption (4): a DoT.
- **Shift-V** = Curse of Weakness (4): your curse. From 20, Curse of the Elements takes over this key.
- **F** = Life Tap (6): turns some of your health into mana.
- **5** = Bane of Agony (8): your bane, a DoT.
- **V** = Fear (8): your **CC** key. CC (crowd control) = a spell that takes an enemy out of the fight for a while.
- **4** = Drain Soul (10): use it to finish off an enemy that gives XP, and you get a **Soul Shard**. A Soul Shard is a small item in your bags. You need one to summon most demons (all but the Imp) and to make a Healthstone or Soulstone. Grey (too easy) enemies give no shard.
- Create Healthstone (10, costs a Soul Shard) goes on block D. Your healthstone is then on **Shift-T**, as for every class.
- **Shift-E** = your race spell (for example Blood Fury for an Orc, Will of the Forsaken for an Undead).]] },
		{ "Simple order", [[
Demon out (block D; all but the Imp need a Soul Shard), then send it in (Ctrl-1). Corruption (2), Bane of Agony (5), Immolate (3), then Shadow Bolt (1). Low on mana? Life Tap (F). Low on health? Drain Life (C, from 14).]] },
		{ "What comes later", [[
- 12: Health Funnel on F2 (heals your demon). 14: Drain Life on C (your own big heal).
- 16: Unending Breath on Shift-R. 18: Searing Pain (block D), and Create Soulstone (costs a Soul Shard; not on the block, put it on your own bar yourself).
- Curse of Tongues and Ritual of Summoning (bring a group member to you) are rarely used: they are not on the block either. Put them on your own bar if you want them.
- 20: Rain of Fire on Shift-1 (hits several enemies), Demon Armor on Shift-Z, Curse of the Elements on Shift-V.
- 28: Banish on Shift-Q. 30: Hellfire on Shift-2. 32: Shadow Ward on Z (soaks up shadow damage; cooldown 30 seconds).
- 40: Howl of Terror on Shift-F (fears several enemies). 42: Death Coil on X (a horror, like fear, and a heal; cooldown 2 minutes).
- 48: Soul Fire on Q (your biggest hit; costs a Soul Shard; 6-second cast; cooldown 1 minute). 50: Inferno on F3. 60: Bane of Doom on F1.
- Talents: Shadowburn on Shift-4 (costs a Soul Shard), Amplify Curse on Shift-3, Demonic Sacrifice on Shift-C, 20 at the earliest. Curse of Exhaustion on R (slows the enemy, so you can stay away from it), Fel Domination on Shift-F1 (summon a demon fast), 25. Siphon Life on F4 (a DoT that heals you), Soul Link on Shift-X, 30. Conflagrate (25), Bane of Havoc (30), Wrack (40) and Incinerate (40), all at the earliest, go on block D.]] },
		{ "Beginner mistakes", [[
- Summoning a demon with no Soul Shard. All demons but the Imp cost one. Use Drain Soul (4) to finish off enemies that give XP.
- Looking for an interrupt on E. The Warlock has none of its own, so E stays empty. Only the Felhunter has one.
- Pressing Health Funnel (F2) to heal yourself. It heals your demon. Your own heal is Drain Life (C).
- Banish (Shift-Q) on a normal enemy. It only works on demons and elementals.
- Bane of Doom (F1) on a player. It cannot be cast on players.
- Missing your wand. Shoot is not on the block. Drag it from your spellbook to your own bar yourself.]] },
	},
}
ns.FOREVER_HOWTOPLAY = CLASSES -- the offline check reads it

--[[
	Per role (16 Nov 2026, Rob via Sparring 16-11, letterlijk "ja" op: per rol een eenvoudige volgorde en per 10 levels wat
	er verandert; de rol van de speler bovenaan, de rest inklapbaar). One entry per role: band = the talent tree that
	leads to it (ForeverDirection band 1-3; Feral = both bear and cat), title, body (same "**gold**" markup as above).
	Your direction's role(s) show in full; the others fold behind the "Other roles" button. No direction = all folded.
	Translations: ns.FOREVER_HOWTOPLAY_L[code].ROLES[class], same shape (a missing class falls back to English).
]]
local ROLES = {
	-- Druid: written 16 Nov 2026 by mh-writer from docs/forever/DRUID_ROLES_2026-11-16.md (DB2 1.60.1.70938 + guides).
	DRUID = {
		{ band = 2, title = "Bear: tank", body = [[
From level 10 (Bear Form, from a quest). A **tank** is the one the enemies hit, so the rest of the group stays safe. For levelling the guides call the cat smoother; the bear is handy from 10 to 20, and for tanking in dungeons. The bear uses **Rage**: you get it when you hit and when you are hit.
**Simple order:**
1. Pull with Faerie Fire (**5**, from 18) or Feral Charge (**E**, from 20). **Pull** = hit one enemy from a distance so it comes to you.
2. Demoralizing Roar (**Shift-2**) once.
3. Primal Bite (**3**, from 40) whenever it is ready.
4. Lacerate (**2**, from 25) until it has 5 stacks.
5. Rage left over: Maul (**1**) on one enemy, Swipe (**4**, from 16) on two or more.
6. Growl (**F**) when an enemy hits someone else.
**Per 10 levels:**
- 10: Bear Form (**Ctrl-1**), Maul (**1**), Growl (**F**), Demoralizing Roar (**Shift-2**). Then Enrage (**Q**) at 12, Bash (**V**) at 14, Swipe (**4**) at 16, Faerie Fire (**5**) at 18.
- 20: Feral Charge (**E**, a talent): you charge the enemy, it cannot move and cannot cast for 4 seconds. Cooldown 15 seconds. Talent levels here are the earliest; a perk can bring them up to 5 levels sooner.
- 30: Leader of the Pack (a talent). Before that: Lacerate (**2**, a talent) at 25, Challenging Roar (**Shift-F**) at 28.
- 40: Dire Bear Form replaces Bear Form on **Ctrl-1**. Primal Bite (**3**, a talent). Before that: Frenzied Regeneration (**X**) at 36: turns Rage into health.
- 50: stronger ranks of Primal Bite, Lacerate and Maul. Barkskin (**Z**) at 44.
- 60: stronger ranks again; nothing new for this role.
**Beginner mistakes:**
- Feral Charge when the enemy is closer than 8 yards. It does not work there.
- Enrage (**Q**) while you take heavy hits. It gives Rage, but you get 27% less armor.]] },
		{ band = 2, title = "Cat: damage up close", body = [[
From level 20 (Cat Form, from a quest; Prowl comes with it). For levelling it is the guides' first choice: they call it the fastest and the smoothest. The cat uses **Energy**, which fills up by itself. Your hits give **combo points** (up to 5); a **finisher** spends them all.
**Simple order:**
1. Prowl (**Shift-R**), then open with Shred (**3**) from behind. **Prowl** = sneak, so the enemy does not see you.
2. Faerie Fire (**5**) on tough enemies.
3. Rake (**2**, from 24), but not when the enemy is almost dead.
4. Claw (**1**) for combo points; Shred (**3**) when you stand behind the enemy.
5. At 4-5 combo points: Rip (**4**) if the enemy will live long, otherwise Ferocious Bite (**C**, from 24).
6. Shifting Power (**Q**, from 40) when your Energy is under 50.
**Per 10 levels:**
- 10: nothing new for this role (the cat comes at 20).
- 20: Cat Form (**Ctrl-2**), Claw (**1**), Shred (**3**, from behind), Rip (**4**), Prowl (**Shift-R**). Feral Charge (**E**, a talent): as a cat you leap behind the enemy. Omen of Clarity is passive: no key.
- 30: Leader of the Pack (a talent). Before that: Rake (**2**) and Ferocious Bite (**C**) at 24, Dash (**R**) at 26, Cower (**F**) at 28.
- 40: Shifting Power (**Q**, a talent): 40 Energy for mana, cooldown 8 seconds, cat only. Before that: Ravage (block D) at 32, Pounce (**V**, from Prowl, a stun) at 36. Talent levels here are the earliest; a perk can bring them up to 5 levels sooner.
- 50: stronger ranks of Ferocious Bite, Rip and Shred; nothing new for this role.
- 60: stronger ranks again; nothing new for this role.
**Beginner mistakes:**
- Shred from the front. It only works from behind; from the front, use Claw.
- Shifting Power too often. Then you have no mana left to heal yourself.]] },
		{ band = 1, title = "Balance: damage from a distance", body = [[
From level 1: Wrath is there from the start, Moonfire comes at 4. Moonkin Form is a talent, 40 at the earliest. The guides say levelling as Balance works, but it is slower than the cat. Some guides take Moonkin Form later (Zygor at 53): 40 is not a rule.
**Simple order:**
1. Starfire (**3**, from 20) as the opener on one enemy.
2. Moonfire (**2**).
3. Insect Swarm (**4**, from 25).
4. Wrath (**1**) as your filler. With Eclipse (from 30): Wrath builds charges, then Starfire (**3**).
5. Hurricane (**Shift-1**, from 40) on groups.
Low on mana? Keep using Wrath: it is cheap.
**Per 10 levels:**
- 10: Wrath (**1**), Moonfire (**2**), Thorns (**Shift-Z**), Entangling Roots (**V**), Nature's Grasp (**X**).
- 20: Starfire (**3**). Omen of Clarity is passive: no key.
- 30: Eclipse (a talent): Wrath makes your next 2 Starfires faster. Before that: Insect Swarm (**4**, a talent) at 25. Talent levels here are the earliest; a perk can bring them up to 5 levels sooner.
- 40: Moonkin Form (**Ctrl-3**, a talent): costs mana, gives your group +3% crit (**crit** = a lucky, stronger hit), but no heals in it. Hurricane (**Shift-1**), Innervate (**F1**).
- 50: stronger ranks of Hurricane and Starfire. Barkskin (**Z**) at 44.
- 60: stronger ranks again; nothing new for this role.
**Beginner mistakes:**
- Healing in Moonkin Form. It cannot be done, and going back into the form costs mana.
- Looking for an Omen of Clarity key. It is passive: it works by itself.]] },
		{ band = 3, title = "Restoration: healer", body = [[
From level 1: Healing Touch is there from the start. The guides do not advise healing for solo levelling (enemies die slowly): level with Wrath and Moonfire, and heal in dungeons. A **HoT** is a heal that heals a little at a time.
**Simple order (in a group):**
1. Rejuvenation (**F4**) on the tank.
2. Regrowth (**F2**) on someone who is low.
3. Swiftmend (**Shift-F1**, from 25): only on someone who has your Rejuvenation or Regrowth.
4. Wild Growth (**Shift-2**, from 40) when more people take damage.
5. Healing Touch (**C**) for big damage. Emergency: Nature's Swiftness (**Shift-3**, from 30), then Healing Touch.
6. Innervate (**F1**, from 40) when your mana is low.
**Per 10 levels:**
- 10: Healing Touch (**C**), Rejuvenation (**F4**). Then Regrowth (**F2**) and Revive (**F3**, outside a fight) at 12, Cure Poison (**Shift-C**) at 14.
- 20: Rebirth (**F3**, in a fight). Then Remove Curse (**Shift-V**) at 24, Abolish Poison (**Shift-C**) at 26.
- 30: Nature's Swiftness (**Shift-3**, a talent), Tranquility (**Q**). Before that: Swiftmend (**Shift-F1**, a talent) at 25. Talent levels here are the earliest; a perk can bring them up to 5 levels sooner.
- 40: Wild Growth (**Shift-2**, a talent), Innervate (**F1**).
- 50: Gift of the Wild (**Shift-X**), a stronger Wild Growth.
- 60: stronger ranks again; nothing new for this role.
**Beginner mistakes:**
- Healing in a form. Heals only work in your normal shape.
- Casting a HoT on someone who still has it. The new one replaces the old one.]] },
	},
	-- Warrior, Mage, Priest: written 17 Nov 2026 by mh-writer from docs/forever/<CLASS>_ROLES_2026-11-17.md (DB2 1.60.1.70938 + guides).
	WARRIOR = {
		{ band = 3, title = "Protection: tank", body = [[
From level 10 (Defensive Stance, from a quest; the same quest gives Taunt and Sunder Armor). A **tank** is the one the enemies hit, so the rest of the group stays safe. You carry a one-handed weapon and a shield. **Threat** = how much an enemy wants to attack you; as a tank you need it on every enemy. The guides disagree on which tree levels fastest alone: some call Protection the fastest, others say it is slower alone. It gets going around level 16, once you have Shield Block next to Revenge.
**Simple order:**
1. Defensive Stance (**Ctrl-2**), Battle Shout (**Shift-X**). Bloodrage (**F1**) for Rage to start with.
2. Pull. **Pull** = hit one enemy from a distance so it comes to you. Charge (**R**) only works in Battle Stance (**Ctrl-1**); go back to Defensive Stance (**Ctrl-2**) after it. With Vanguard (from 25) Charge works in Defensive Stance too. Or pull with your ranged weapon (block D).
3. Several enemies: Demoralizing Shout (**Shift-2**, from 14) once, Thunder Clap (**Shift-1**) whenever it is ready.
4. Shield Block (**Z**, from 16), and Revenge (**2**, from 14) as soon as it lights up.
5. Shield Slam (**3**, from 40) whenever it is ready.
6. Sunder Armor (**5**) on your main target; up to 5 stacks on a boss.
7. Taunt (**F**) when an enemy attacks someone else.
8. Rage left over: Heroic Strike (**1**) on one enemy, Cleave (**Shift-4**, from 20) on two or more.
**Per 10 levels:**
- 10: Defensive Stance (**Ctrl-2**), Taunt (**F**), Sunder Armor (**5**), Bloodrage (**F1**). Then Shield Bash (**E**) at 12, Revenge (**2**) and Demoralizing Shout (**Shift-2**) at 14, Shield Block (**Z**) at 16, Disarm (**V**) at 18.
- 20: Last Stand (**X**, a talent): 30% more max health for 20 seconds. Victory Rush (**F2**), Cleave (**Shift-4**). Then Intimidating Shout (**Shift-Q**) at 22, Vanguard (a talent, passive) at 25, Challenging Shout (**Shift-F**) at 26, Shield Wall (**C**) at 28. Talent levels here are the earliest; a perk can bring them up to 5 levels sooner.
- 30: Concussion Blow (**Shift-V**, a talent): a 5-second stun. Berserker Stance (**Ctrl-3**, from a quest). Then Bastion (a talent, passive) at 35.
- 40: Shield Slam (**3**, a talent). Plate Mail at the trainer: you can wear plate.
- 50: nothing new for this role. Stronger ranks of Shield Slam, Revenge, Sunder Armor and Thunder Clap.
- 60: stronger ranks again; nothing new for this role.
**Beginner mistakes:**
- Thinking Thunder Clap hits the whole pack. It hits 4 enemies; a fifth can run to the healer.
- Leaving enemies behind you. From behind you cannot block, dodge or parry, and Revenge does not light up.
- Taunt on an enemy that already attacks you. It does nothing then.]] },
		{ band = 1, title = "Arms: damage with one big weapon", body = [[
From level 1. You carry one big two-handed weapon and almost always stand in Battle Stance. The big steps are Sweeping Strikes at 30 and Mortal Strike at 40. A new weapon is your biggest gain. You have no heal of your own except Victory Rush (from 20), so food and bandages stay handy. The guides disagree on which tree levels fastest; all three work.
**Simple order:**
1. Battle Stance (**Ctrl-1**), Battle Shout (**Shift-X**).
2. Charge (**R**) to start.
3. Rend (**Shift-Z**), if the enemy will live a while.
4. Overpower (**2**, from 12) as soon as it lights up.
5. Mortal Strike (**3**, from 40) whenever it is ready; keep 30 Rage for it.
6. Victory Rush (**F2**, from 20) after a kill, when you miss health.
7. Two enemies: Sweeping Strikes (**Q**, from 30), then Cleave (**Shift-4**, from 20). Before 30: Thunder Clap (**Shift-1**).
8. Rage left over: Heroic Strike (**1**).
**Per 10 levels:**
- 10: Heroic Strike (**1**), Charge (**R**), Rend (**Shift-Z**), Thunder Clap (**Shift-1**), Hamstring (**V**), Battle Shout (**Shift-X**), Bloodrage (**F1**). Then Overpower (**2**) at 12, Demoralizing Shout (**Shift-2**) at 14.
- 20: Victory Rush (**F2**), Cleave (**Shift-4**), Slam (**Shift-C**), Retaliation (**C**). Then Execute (**4**) at 24, Spearing Strike (**F3**, a talent) at 25: an extra hard hit on Giants and Dragonkin. Talent levels here are the earliest; a perk can bring them up to 5 levels sooner.
- 30: Sweeping Strikes (**Q**, a talent, Battle Stance only): your next 5 hits also hit an enemy next to your target. Berserker Stance (**Ctrl-3**, from a quest) with Intercept (**R**) and Berserker Rage (**Shift-V**). Then Improved Slam (a talent, passive) at 35, Whirlwind (**2** in Berserker Stance) at 36, Pummel (**E** in Berserker Stance) at 38.
- 40: Mortal Strike (**3**, a talent): the enemy gets 50% less healing for 10 seconds. Plate Mail at the trainer.
- 50: Recklessness (**Q** in Berserker Stance). Stronger ranks of Mortal Strike.
- 60: stronger ranks again; nothing new for this role.
**Beginner mistakes:**
- Pressing Heroic Strike (**1**) all the time. That swing gives no Rage, so nothing is left for Mortal Strike or Overpower.
- Slam (**Shift-C**) before the Improved Slam talent: a 1.5-second cast that delays your normal swing. Most guides skip it until then.
- Looking for an interrupt on **E** with a two-handed weapon. Shield Bash needs a shield; your interrupt is Pummel (38, Berserker Stance).]] },
		{ band = 2, title = "Fury: damage with two weapons", body = [[
A weapon in each hand, from level 20 (Dual Wield at the trainer). Until then, use your best weapon (a two-handed one is fine) and play as Arms. Fury gets really strong with Whirlwind (36) and Bloodthirst (40). You need two good weapons. Whirlwind, Pummel, Intercept and Berserker Rage only work in Berserker Stance, so you change stance often.
**Simple order (from 36; before that, play as Arms):**
1. Battle Shout (**Shift-X**). Bloodrage (**F1**) for Rage.
2. Charge (**R**) in Battle Stance (**Ctrl-1**).
3. Death Wish (**Shift-3**, from 30) on a strong enemy.
4. Berserker Stance (**Ctrl-3**): Whirlwind (**2**, from 36) whenever it is ready.
5. Bloodthirst (**3**, from 40) whenever it is ready. The guides differ on which of these two comes first.
6. Victory Rush (**F2**) after a kill, when you miss health.
7. Rage left over: Heroic Strike (**1**); on two enemies Cleave (**Shift-4**).
8. Low on Rage: Reckless Swings (**Shift-F1**, from 25; it costs health).
**Per 10 levels:**
- 10: nothing new for this role: you play as Arms, with one weapon.
- 20: Dual Wield at the trainer: now a weapon can go in your other hand. Piercing Howl (**Shift-R**, a talent): slows all enemies near you. Victory Rush (**F2**), Cleave (**Shift-4**). Then Execute (**4**) at 24, Reckless Swings (**Shift-F1**, a talent) at 25. Talent levels here are the earliest; a perk can bring them up to 5 levels sooner.
- 30: Death Wish (**Shift-3**, a talent). Berserker Stance (**Ctrl-3**, from a quest) with Intercept (**R**) and Berserker Rage (**Shift-V**). Then Whirlwind (**2** in Berserker Stance) at 36, Pummel (**E** in Berserker Stance) at 38.
- 40: Bloodthirst (**3**, a talent; you need Death Wish first). It does not heal; it makes you run faster. Plate Mail at the trainer.
- 50: Recklessness (**Q** in Berserker Stance). Stronger ranks of Bloodthirst.
- 60: stronger ranks again; nothing new for this role.
**Beginner mistakes:**
- Playing Fury with one good weapon and a bad second one.
- Looking for Whirlwind (**2**) in Battle Stance. It only works in Berserker Stance, and there Rend and Thunder Clap do not work.
- Death Wish (**Shift-3**) in a fight you might lose. For 30 seconds you also take 5% more damage.]] },
	},
	MAGE = {
		{ band = 1, title = "Arcane: damage from a distance", body = [[
From level 8 (Arcane Missiles). Arcane Blast is a talent, 20 at the earliest; until then you play like any mage, with Frostbolt, Fireball and Arcane Missiles. The guides differ: some call Arcane strong for levelling, most advise Frost and call Arcane hungry for mana. Its tree has no slows, so it is the weakest at keeping enemies away. A **channel** is a spell that runs while you stand still; moving stops it. Arcane Missiles is one.
**Simple order:**
1. Open with Frostbolt (**2**): the enemy then comes slowly.
2. Arcane Blast (**1**, from 20): one or two, on a boss up to four. Each one makes the next cost more mana.
3. Missile Barrage (from 15) lights up? Arcane Missiles (**3**) right away: free and twice as fast.
4. Arcane Wrath (**Shift-F1**, from 25) whenever it is ready.
5. Enemy close to you? Frost Nova (**V**), step away.
6. Almost dead: your wand (**Ctrl-3**, until 40) or Fire Blast (**5**).
7. Tough enemy or boss: Presence of Mind (**Shift-3**, from 30), then Arcane Wrath for a big instant hit. From 40 also Arcane Power (**Q**).
Several enemies: Frost Nova (**V**), then Arcane Explosion (**Shift-2**, from 14). Low on mana? Evocation (**F1**, from 20).
**Per 10 levels:**
- 10: Frost Nova (**V**). First talent: Improved Channeling (Arcane Missiles is no longer cut short when you are hit). Then Arcane Explosion (**Shift-2**) at 14, Missile Barrage (a talent, passive) at 15. Talent levels here are the earliest; a perk can bring them up to 5 levels sooner.
- 20: Arcane Blast (**1**, a talent). Blink (**R**), Evocation (**F1**), Mana Shield (**Z**). Then Counterspell (**E**) at 24, Arcane Wrath (**Shift-F1**, a talent; you need Arcane Blast first) at 25.
- 30: Presence of Mind (**Shift-3**, a talent): your next spell with a cast under 10 seconds is instant. Ice Armor (**Shift-Z**). Then Mage Armor (block D) at 34.
- 40: Arcane Power (**Q**, a talent; you need Presence of Mind first): for 15 seconds your spells do 30% more damage, but cost 30% more mana. Frostfire Bolt takes **Ctrl-3**: put your wand (Shoot) on your own Alt key.
- 50: stronger ranks of Arcane Blast, Arcane Wrath and Arcane Missiles; nothing new for this role.
- 60: stronger ranks again; nothing new for this role.
**Beginner mistakes:**
- Pressing Arcane Blast again and again. Each one makes the next cost 100% more mana; you run dry fast.
- Moving during Arcane Missiles. It is a channel: moving stops it.
- Arcane Power on a normal enemy. It also makes your spells cost more, and it has a 3-minute cooldown.]] },
		{ band = 2, title = "Fire: damage from a distance", body = [[
From level 1 (Fireball). Pyroblast is a talent, 20 at the earliest. The real Fire play starts with Heating Up (25 at the earliest); before that, Pyroblast is only an opener. The guides say Fire does the most damage on one enemy, and levels fast but with more risk than Frost: it has no freezes of its own. A **crit** is a lucky, stronger hit.
**Simple order:**
1. Open from far away with Pyroblast (**4**, from 20). Before that: Fireball (**1**).
2. Fireball (**1**) as your normal spell.
3. Fire Blast (**5**) whenever it is ready. From 25 each Fire Blast gives a Heating Up stack.
4. Two or three Heating Up stacks (from 25)? Pyroblast (**4**).
5. Enemy close: Scorch (**Ctrl-1**, from 22) instead of Fireball, or Frost Nova (**V**) and step away. From 30, Blast Wave (**F3**) after it.
6. Almost dead: your wand (**Ctrl-3**, until 40) or Fire Blast.
7. Elite or boss, from 40: Combustion (**Q**).
Several enemies: Frost Nova (**V**), Flamestrike (**Shift-4**, from 16), Blast Wave (**F3**, from 30).
**Per 10 levels:**
- 10: Frost Nova (**V**). First talent: Accelerant (Fireball casts faster). Then Ignite and Impact (talents) at 15, Flamestrike (**Shift-4**) at 16. Talent levels here are the earliest; a perk can bring them up to 5 levels sooner.
- 20: Pyroblast (**4**, a talent): a 6-second cast, so only as an opener. Blink (**R**), Evocation (**F1**), Fire Ward (**F4**), Mana Shield (**Z**). Then Scorch (**Ctrl-1**) at 22, Counterspell (**E**) at 24, Heating Up (a talent, passive; you need Pyroblast first) at 25: a crit with Fireball, Frostfire Bolt, Fire Blast or Scorch makes your next Pyroblast 25% faster, up to 3 stacks.
- 30: Blast Wave (**F3**, a talent): instant, around you; enemies are 50% slower for 6 seconds. Critical Mass (a talent). Ice Armor (**Shift-Z**). Then Fire Power (a talent) at 35.
- 40: Combustion (**Q**, a talent; you need Critical Mass first). Frostfire Bolt takes **Ctrl-3**: put your wand (Shoot) on your own Alt key.
- 50: stronger ranks of Fireball, Pyroblast, Blast Wave and Frostfire Bolt; nothing new for this role.
- 60: stronger ranks again; nothing new for this role.
**Beginner mistakes:**
- Casting Pyroblast when the enemy is already at you. A 6-second cast is too slow then.
- Thinking three Heating Up stacks make Pyroblast instant. It is still a 1.5-second cast: stand still.
- Looking for an Ice Block. Fire has none. Your way out: Frost Nova (**V**), Blink (**R**), Blast Wave (**F3**).]] },
		{ band = 3, title = "Frost: damage from a distance", body = [[
From level 4 (Frostbolt); Frost Nova comes at 10. Ice Lance is a talent, 20 at the earliest. For levelling it is the first choice of most guides: they call it the safest. It really gets going around 30. **Frozen** = the enemy is frozen in place and cannot move.
**Simple order:**
1. Frostbolt (**2**) from as far away as you can. Every hit slows the enemy.
2. Enemy Frozen (by Frost Nova, or by the Frostbite talent)? Ice Lance (**F**, from 20).
3. Enemy close? Frost Nova (**V**), step away, Frostbolt, then Ice Lance.
4. Fingers of Frost lights up (from 30)? Ice Lance.
5. Ice Lance not ready and the enemy is close: Cone of Cold (**Shift-F**, from 26).
6. Almost dead: your wand (**Ctrl-3**, until 40) or Fire Blast (**5**).
Several enemies (from 20): Frost Nova (**V**), step away, Blizzard (**Shift-1**), then Cone of Cold (**Shift-F**). In trouble: Ice Block (**C**, from 25), Blink (**R**).
**Per 10 levels:**
- 10: Frost Nova (**V**). First talent: Improved Frostbolt (a shorter cast). Then Frostbite (a talent) at 15: your slows can freeze the enemy for 5 seconds. Talent levels here are the earliest; a perk can bring them up to 5 levels sooner.
- 20: Ice Lance (**F**, a talent): 300% more damage on a Frozen enemy. Blizzard (**Shift-1**), Blink (**R**), Evocation (**F1**), Mana Shield (**Z**). Then Frost Ward (**F2**) at 22, Counterspell (**E**) at 24, Ice Block (**C**, a talent) at 25, Cone of Cold (**Shift-F**) at 26.
- 30: Cold Snap (**Shift-C**, a talent): resets the cooldown of your other Frost spells; its own cooldown is 10 minutes. Fingers of Frost (a talent; you need Ice Lance first): your next 2 spells act as if the enemy is Frozen. Ice Armor (**Shift-Z**). Then Winter's Chill (a talent) at 35.
- 40: Ice Barrier (**X**, a talent; you need Cold Snap first): a shield that soaks up damage. Frostfire Bolt takes **Ctrl-3**: put your wand (Shoot) on your own Alt key.
- 50: stronger ranks of Frostbolt, Cone of Cold, Ice Armor, Ice Barrier and Blizzard; nothing new for this role.
- 60: stronger ranks again; nothing new for this role.
**Beginner mistakes:**
- Ice Lance on an enemy that is not Frozen. Then it is a small hit.
- Pressing Fire Blast just before a freeze. Fire Blast and Ice Lance share one 8-second cooldown.
- Using Cold Snap for nothing. It has a 10-minute cooldown: keep it for when things go wrong.]] },
	},
	PRIEST = {
		{ band = 1, title = "Discipline: healer", body = [[
From level 1: Lesser Heal is there from the start. Its own spells come later: Soul Warding at 25 and Penance at 30, both at the earliest. In a group it is strongest at healing one person, the tank. Levelling alone works with Smite, Holy Fire and your wand, later Penance; the guides disagree on whether it is faster than Shadow. **Weakened Soul**: after a Power Word: Shield, the same person cannot get a new shield for 15 seconds.
**Simple order (in a group):**
1. Power Word: Shield (**Z**) on the tank, just before the pull. **Pull** = the first hit that starts a fight.
2. Renew (**F4**) on the tank.
3. Penance (**Shift-F1**, from 30) on whoever is hurt, every time it is ready.
4. Your big heal (**C**) for normal damage.
5. Flash Heal (**F2**, from 20) when C is too slow.
6. More people hurt: Prayer of Healing (**Shift-2**, from 30).
7. Inner Focus (**F1**, from 20) before an expensive heal. Power Infusion (**Q**, from 40) on yourself or a caster.
Alone: Shield (**Z**), Holy Fire (**4**, from 20), Smite (**1**), Mind Blast (**3**), Shadow Word: Pain (**2**), Penance if you do not need it to heal, then your wand (**5**).
**Per 10 levels:**
- 10: Lesser Heal (**C**), Power Word: Shield (**Z**), Renew (**F4**), Resurrection (**F3**, outside a fight only), Smite (**1**). Then Inner Fire (**Shift-Z**) at 12, Cure Disease (**Shift-C**) at 14, Heal (**C**) at 16, Dispel Magic (**Shift-V**) at 18.
- 20: Flash Heal (**F2**), Holy Fire (**4**), Fear Ward (block D). Inner Focus (**F1**, a talent): your next spell costs no mana and crits more often; cooldown 3 minutes. Then Soul Warding (a talent, passive) at 25: Shield has no cooldown and costs less. Talent levels here are the earliest; a perk can bring them up to 5 levels sooner.
- 30: Penance (**Shift-F1**, a talent): heals a friend or hurts an enemy; cooldown 12 seconds. Prayer of Healing (**Shift-2**), Divine Spirit (block D). Then Abolish Disease (**Shift-C**) at 32, Divine Aegis (a talent, passive) at 35.
- 40: Power Infusion (**Q**, a talent; you need Penance first): 20% more spell damage and healing; cooldown 3 minutes. Greater Heal takes over **C**.
- 50: stronger ranks of Penance, Prayer of Healing, Flash Heal and Renew. Prayer of Fortitude (**Shift-X**) at 48.
- 60: stronger ranks again; nothing new for this role.
**Beginner mistakes:**
- Shielding the same player twice in a row. Weakened Soul stops it. It is per player: someone else can get a shield right away.
- Penance on an enemy to heal your group. It heals or hurts, not both.
- Prayer of Healing on the wrong player. It heals the group of the player you pick.]] },
		{ band = 2, title = "Holy: healer", body = [[
From level 1: Lesser Heal is there from the start. Holy is the group healer. Alone it levels slowly: the guides advise questing with Smite and your wand, and healing in dungeons. Its own spells come late: Holy Nova at 20 and Prayer of Mending at 40, both at the earliest.
**Simple order (in a group):**
1. Renew (**F4**) on the tank as the pull starts. **Pull** = the first hit that starts a fight.
2. Prayer of Mending (**Ctrl-2**, from 40) on the tank before the pull, and again every time it is ready.
3. Your big heal (**C**) for normal damage.
4. Flash Heal (**F2**, from 20) when C would come too late.
5. Whole group hurt: Prayer of Healing (**Shift-2**, from 30). Holy Nova (**Shift-1**, from 20) only when everyone stands right next to you; it costs a lot of mana.
6. Power Word: Shield (**Z**) to win time.
7. An enemy attacks you: Fade (**F**).
**Per 10 levels:**
- 10: Lesser Heal (**C**), Power Word: Shield (**Z**), Renew (**F4**), Resurrection (**F3**, outside a fight only). Then Inner Fire (**Shift-Z**) at 12, Cure Disease (**Shift-C**) at 14, Heal (**C**) at 16, Dispel Magic (**Shift-V**) at 18.
- 20: Holy Nova (**Shift-1**, a talent): instant; hurts enemies around you and heals your group, without threat. Flash Heal (**F2**), Holy Fire (**4**), Fear Ward (block D). Then Holy Binding (a talent, passive) at 25: Flash Heal on someone else heals you for half. Talent levels here are the earliest; a perk can bring them up to 5 levels sooner.
- 30: Prayer of Healing (**Shift-2**), Divine Spirit (block D). Spirit of Redemption (a talent, passive). Then Abolish Disease (**Shift-C**) at 32, Spiritual Healing (a talent, passive) at 35.
- 40: Prayer of Mending (**Ctrl-2**, a talent; you need Spirit of Redemption first): it heals as soon as the target takes damage, then jumps to another group member, up to 5 times; cooldown 10 seconds. Greater Heal takes over **C**.
- 50: stronger ranks of Prayer of Mending, Holy Nova, Prayer of Healing and Renew. Prayer of Fortitude (**Shift-X**) at 48.
- 60: stronger ranks again; nothing new for this role.
**Beginner mistakes:**
- Prayer of Healing on the wrong player. It heals the group of the player you pick, not your own.
- Flash Heal for everything. It is fast but expensive; keep it for emergencies.
- Holy Nova on a group that stands far away. It only works right around you, and it costs a lot.]] },
		{ band = 3, title = "Shadow: damage from a distance", body = [[
From level 4 (Shadow Word: Pain); Mind Blast comes at 10. Mind Flay is a talent, 20 at the earliest; Shadowform at 40. Most guides level as Shadow; some play Discipline until 40. Early on, your wand does much of the work. Shadow has no spell that hits many enemies at once. A **DoT** is damage in small bits over a few seconds. A **channel** is a spell that runs while you stand still.
**Simple order:**
1. Power Word: Shield (**Z**) on yourself, if the enemy will reach you.
2. Mind Blast (**3**) from far away, to start.
3. Shadow Word: Pain (**2**).
4. Devouring Plague (**Shift-3**, from 20) on an enemy that will live a while.
5. Mind Flay (**1**, from 20), and let it run to the end. Before that: Smite (**1**).
6. Finish with your wand (**5**).
Low on mana? Skip Devouring Plague and Mind Flay, and use your wand sooner. From 32: Shadow Word: Death (**Shift-4**) only when it will kill the enemy. From 40: Shadowform (**Ctrl-1**) on before the first pull, and leave it on.
**Per 10 levels:**
- 10: Mind Blast (**3**), cooldown 8 seconds. You already have Smite (**1**), Shadow Word: Pain (**2**), Power Word: Shield (**Z**), Fade (**F**) and your wand (**5**). Then Inner Fire (**Shift-Z**) at 12, Psychic Scream (**V**) at 14.
- 20: Mind Flay (a talent): takes over key **1** from Smite. Devouring Plague (**Shift-3**): a DoT that also heals you; cooldown 24 seconds. Then Vampiric Embrace (**Ctrl-3**, a talent) at 25 or 30: your group is healed for 20% of your Shadow damage. Talent levels here are the earliest; a perk can bring them up to 5 levels sooner.
- 30: Silence (**E**, a talent): your **interrupt** (it stops an enemy's spell); cooldown 45 seconds. Mind Control (**Shift-F**). Then Shadow Word: Death (**Shift-4**) at 32, Levitate (**R**) at 34.
- 40: Shadowform (**Ctrl-1**, a talent; you need Vampiric Embrace first): 10% more Shadow damage, Shadow spells cost half, 15% less physical damage taken, but no healing spells. Before that: Darkness (a talent, passive) at 35.
- 50: stronger ranks of Mind Flay, Mind Blast, Shadow Word: Pain, Devouring Plague and Shadow Word: Death. Prayer of Fortitude (**Shift-X**) at 48.
- 60: stronger ranks of Mind Flay and Devouring Plague; nothing new for this role.
**Beginner mistakes:**
- Shadow Word: Death on an enemy with lots of health. If it does not die, you lose 30% of your own health.
- Stopping Mind Flay early. With the Improved Mind Flay talent the last tick is the strongest.
- Opening with Mind Blast in a group. It causes a lot of threat (how much an enemy wants to attack you): let the tank go first. If an enemy attacks you: Fade (**F**).]] },
	},
	-- Rogue: written 17 Nov 2026 by mh-writer from docs/forever/ROGUE_ROLES_2026-11-17.md (DB2 1.60.1.70938 + guides).
	ROGUE = {
		{ band = 1, title = "Assassination: daggers and poison", body = [[
From level 1 (Sinister Strike and Eviscerate). You fight up close, with daggers and poison. You use **Energy**, which fills up by itself. Your hits give **combo points** (up to 5) on the enemy you hit; a **finisher** spends them all. Mutilate is a talent, 40 at the earliest, and needs a dagger in each hand. Until then you play with Backstab or Sinister Strike. The guides do not call this the easiest start: the big step only comes with Mutilate.
**Simple order:**
1. From 20: poison on both weapons (items, on block D).
2. Wait for full Energy. From 18 (Poised) your first attack then costs 10 Energy less.
3. Stealth (**Shift-R**), walk behind the enemy. **Stealth** = sneak, so the enemy does not see you. Open with Ambush (**2**, from 18, dagger in your main hand) or Garrote (**1**, from 14). Strong enemy, from 26: Cheap Shot (**V**), a 4-second stun.
4. Combo points: Backstab (**2**) when you stand behind the enemy, otherwise Sinister Strike (**1**). From 40: Mutilate (**1**), 2 points each time.
5. Shank (**Shift-3**, from 24) whenever it is ready. With Venom (from 30) each Shank makes your poison stronger for 6 seconds.
6. Finisher: Slice and Dice (**Shift-4**) in a long fight; otherwise Eviscerate (**4**) at 5 points. Rupture (**5**, from 20) on an enemy that will live long (an elite, a boss).
7. Cold Blood (**F1**, from 25) just before an Eviscerate with 5 points.
**Per 10 levels:**
- 10: you already have Sinister Strike (**1**), Eviscerate (**4**), Backstab (**2**), Stealth (**Shift-R**), Gouge (**Shift-Q**) and Evasion (**Z**). New at 10: Slice and Dice (**Shift-4**), Sprint (**R**), Sap (**Shift-Q** in Stealth), and a weapon in each hand (Dual Wield). Then Kick (**E**) at 12, Garrote (**1** in Stealth) and Expose Armor (**Shift-Z**) at 14, Feint (**F**) at 16, Ambush (**2** in Stealth) and Poised (passive) at 18.
- 20: Rupture (**5**). Poisons, from a quest. Then Vanish (**X**) at 22, Shank (**Shift-3**) at 24, Cold Blood (**F1**, a talent) at 25: your next Sinister Strike, Backstab, Ambush, Eviscerate or Mutilate is sure to crit (**crit** = a lucky, stronger hit); cooldown 3 minutes. Cheap Shot (**V** in Stealth) at 26. Talent levels here are the earliest; a perk can bring them up to 5 levels sooner.
- 30: Venom (a talent, passive: no key): each Shank gives your poison 30% more damage and 20% more chance to land, for 6 seconds. Kidney Shot (**V**). Then Blind (**Shift-V**) at 34, Seal Fate (a talent, passive) at 35: a crit with an attack that gives combo points gives you an extra point.
- 40: Mutilate (**1**, a talent; you need Venom first): 60 Energy, hits with both daggers, 2 combo points, 20% more damage on a poisoned enemy. Then Slice and Dice rank 2 at 42, Shank rank 2 at 44.
- 50: Mutilate rank 2 and Kidney Shot rank 2; nothing new for this role.
- 60: Mutilate rank 3 and stronger ranks; nothing new for this role.
**Beginner mistakes:**
- Mutilate without daggers. It needs a dagger in each hand: get your second dagger before level 40.
- Forgetting Shank. Venom only works through Shank.
- Switching to another enemy with combo points on the old one. The points do not come along.]] },
		{ band = 2, title = "Combat: steady damage with any weapon", body = [[
From level 1 (Sinister Strike and Eviscerate). You do not need to stand behind the enemy: your main hit is Sinister Strike. It works with any one-handed weapon: a sword, axe, mace, fist weapon or dagger. Several guides call Combat the easiest tree to level alone. They advise a slow weapon in your main hand and a fast one in your other hand. You use **Energy**, which fills up by itself; your hits give **combo points**, and a **finisher** spends them. Blade Flurry (30 at the earliest) is the only thing a Rogue has against two enemies at once.
**Simple order:**
1. Wait for full Energy (Poised, from 18).
2. Open from Stealth (**Shift-R**) with Garrote (**1**, from 14), or from 26 with Cheap Shot (**V**). Just walking up and attacking is fine too.
3. Sinister Strike (**1**) for combo points.
4. Riposte (**Shift-F1**, from 20) as soon as it lights up: that happens after you parry an attack.
5. Shank (**Shift-3**, from 24) when it is ready.
6. Finisher: Slice and Dice (**Shift-4**) in a long fight; otherwise Eviscerate (**4**) at 5 points. The guides differ on how early to keep Slice and Dice up.
7. Two enemies: Blade Flurry (**Shift-1**, from 30). From 40 together with Adrenaline Rush (**Q**) for a hard fight. Losing? Evasion (**Z**).
**Per 10 levels:**
- 10: you already have Sinister Strike (**1**), Eviscerate (**4**), Stealth (**Shift-R**), Gouge (**Shift-Q**) and Evasion (**Z**). New at 10: Slice and Dice (**Shift-4**), Sprint (**R**), Sap (**Shift-Q** in Stealth), and a weapon in each hand. Then Kick (**E**) at 12, Garrote (**1** in Stealth) and Expose Armor (**Shift-Z**) at 14, Feint (**F**) at 16, Poised (passive) at 18.
- 20: Riposte (**Shift-F1**, a talent; you need Deflection first): only works right after you parry an attack. 10 Energy, and the enemy is disarmed for 6 seconds. Rupture (**5**), and Poisons from a quest. Then Vanish (**X**) at 22, Shank (**Shift-3**) at 24, Flawless Execution (a talent, passive) at 25: Eviscerate costs 15 Energy less. Cheap Shot (**V** in Stealth) at 26. Talent levels here are the earliest; a perk can bring them up to 5 levels sooner.
- 30: Blade Flurry (**Shift-1**, a talent): for 15 seconds you attack 20% faster, and each hit also hits a second enemy nearby; cooldown 2 minutes. Hack and Slash (a talent, passive): a bonus that depends on your weapon. Kidney Shot (**V**). Then Blind (**Shift-V**) at 34, Flash of Steel (a talent, passive) at 35: Shank gives up to 15 Energy extra and is ready up to 2 seconds sooner.
- 40: Adrenaline Rush (**Q**, a talent; you need Blade Flurry first): for 15 seconds your Energy fills twice as fast; cooldown 5 minutes. Then Slice and Dice rank 2 at 42 (30% faster instead of 20%), Shank rank 2 at 44 (25 Energy back instead of 15).
- 50: Kidney Shot rank 2 and stronger ranks; nothing new for this role.
- 60: stronger ranks; nothing new for this role.
**Beginner mistakes:**
- Blade Flurry next to an enemy you took out with Sap, Gouge or Blind. The extra hits wake it up.
- Pressing Riposte when nothing was parried. It only works right after a parry.
- Backstab or Ambush with a sword, axe or mace. Both need a dagger in your main hand.]] },
		{ band = 3, title = "Subtlety: strike from Stealth", body = [[
From level 1 (Sinister Strike and Stealth). This tree fights from Stealth: a strong first hit, and many combo points before the fight really starts. **Stealth** = sneak, so the enemy does not see you. The guides say levelling alone goes slower than with Combat. Hemorrhage is a talent, 30 at the earliest: cheap, from the front, with any weapon, but with a dagger it hits harder. Death Mark is a talent, 40 at the earliest. Ambush and Backstab need a dagger in your main hand; Hemorrhage and Ghostly Strike do not.
**Simple order:**
1. Stealth (**Shift-R**). A second Humanoid nearby? Sap (**Shift-Q**). Sap does not break Stealth.
2. Premeditation (**Shift-C**, from 20): 2 combo points on the enemy. Then your first hit.
3. First hit from behind: Ambush (**2**, from 18, dagger in your main hand). Strong enemy, from 26: Cheap Shot (**V**), a 4-second stun. The guides differ on the best opener.
4. Ghostly Strike (**Shift-X**, from 25) and Shank (**Shift-3**, from 24) whenever they are ready.
5. Combo points: from 30 Hemorrhage (**1**). Before that: Backstab (**2**) when you stand behind the enemy, otherwise Sinister Strike (**1**).
6. Finisher: Eviscerate (**4**) when the enemy is almost dead; Rupture (**5**) on an enemy that will live long; Slice and Dice (**Shift-4**) in a long fight.
7. From 40: Death Mark (**Q**) on the strongest enemy, best while Rupture or Garrote is running.
8. Emergency: Vanish (**X**). Preparation (**F3**, from 30) makes Vanish, Evasion and Sprint ready again right away.
**Per 10 levels:**
- 10: you already have Sinister Strike (**1**), Eviscerate (**4**), Backstab (**2**), Stealth (**Shift-R**), Gouge (**Shift-Q**) and Evasion (**Z**). New at 10: Sap (**Shift-Q** in Stealth), Slice and Dice (**Shift-4**), Sprint (**R**), and a weapon in each hand. Then Kick (**E**) at 12, Garrote (**1** in Stealth) at 14, Feint (**F**) at 16, Ambush (**2** in Stealth) and Poised (passive) at 18.
- 20: Premeditation (**Shift-C**, a talent): 2 combo points on your target; use them within 20 seconds, or they are gone; cooldown 2 minutes. Rupture (**5**), and Poisons from a quest. Then Vanish (**X**) at 22, Shank (**Shift-3**) at 24, Ghostly Strike (**Shift-X**, a talent) at 25: 40 Energy, 1 combo point, 15% more dodge for 7 seconds; cooldown 20 seconds. Cheap Shot (**V** in Stealth) at 26. Talent levels here are the earliest; a perk can bring them up to 5 levels sooner.
- 30: Hemorrhage (**1**, a talent; you need Serrated Blades first): 35 Energy, 1 combo point, works from the front; for 15 seconds your Rupture and Garrote do 15% more damage to that enemy. Preparation (**F3**, a talent): makes the cooldown of your other Rogue spells ready right away; its own cooldown is 10 minutes. You get one of these two at 30, the other at 31. Kidney Shot (**V**). Then Blind (**Shift-V**) at 34, Boot Knife (a talent, passive) at 35: Shank can give 2 combo points.
- 40: Death Mark (**Q**, a talent; you need Preparation first): a finisher, 25 Energy, cooldown 10 seconds. For 6 seconds it saves part of your damage (more per combo point), then deals it in one go, up to a limit. Rupture and Garrote damage counts double. Then Slice and Dice rank 2 and Vanish rank 2 at 42, Shank rank 2 at 44, Death Mark rank 2 at 48.
- 50: Kidney Shot rank 2, Death Mark rank 3 at 56; nothing new for this role.
- 60: Death Mark rank 4 and stronger ranks; nothing new for this role.
**Beginner mistakes:**
- Ambush or Backstab without a dagger in your main hand, or from the front.
- Using Premeditation and then waiting. The 2 points are gone after 20 seconds, and the cooldown is 2 minutes.
- Death Mark without combo points. It is a finisher.]] },
	},
	-- Hunter: written 17 Nov 2026 by mh-writer from docs/forever/HUNTER_ROLES_2026-11-17.md (DB2 1.60.1.70938 + guides).
	HUNTER = {
		{ band = 1, title = "Beast Mastery: damage with your pet", body = [[
From level 10 (your pet, from the class quests). Your pet does most of the work: it keeps the enemy busy while you shoot from a distance. Most guides pick Beast Mastery for levelling: they call it the easiest and the fastest. Wowhead adds that all three trees work. New in Forever: Summon Hawk (a talent, 25 at the earliest) sends extra birds at your target. Weak spot: groups of enemies. Your pet can hold only one.
**Simple order:**
Before you start: Aspect of the Hawk on (**Shift-R**). The Deadly Aspects talent only works then.
1. Hunter's Mark (**1**).
2. Pet in (**Ctrl-1**), and wait until it has the enemy.
3. Serpent Sting (**2**).
4. Summon Hawk (**Shift-F1**, from 25): keep 2 hawks up all the time.
5. Aimed Shot (**4**, from 20) while you stand still. Two or more enemies: Multi-Shot (**Shift-1**) instead. They share one cooldown.
6. Auto Shot (**Shift-Z**) keeps going. Arcane Shot (**3**): before 25, just use it. From 25 only when you already have 2 hawks: it shares a cooldown with Summon Hawk.
7. Pet almost dead: Mend Pet (**F2**). Enemy on you: Intimidation (**Shift-3**, from 30) or Disengage (**Z**, from 20). Disengage is no jump: it makes the enemy want you less, up close, and stops your auto-attack. Real trouble: Feign Death (**X**, from 30).
8. Tough enemy: Bestial Wrath (**F1**, from 40) together with Rapid Fire (**Q**, from 26).
**Per 10 levels:**
- 10: your pet, from the class quests. Aspect of the Hawk (**Shift-R**). First talents: Deadly Aspects, Endurance Training. Talent levels here are the earliest; a perk can bring them up to 5 levels sooner. Then Mend Pet (**F2**) at 12, Multi-Shot (**Shift-1**) at 18.
- 20: Aimed Shot (**4**, from the trainer), Aspect of the Cheetah (**R**), Disengage (**Z**), Freezing Trap (**V**). Talents: Bestial Swiftness (your pet runs 30% faster; you need it for Intimidation), Unleashed Fury, Pathfinding.
- 30: Intimidation (**Shift-3**, a talent): your pet stuns the enemy for 3 seconds with its next hit; cooldown 1 minute. Feign Death (**X**). Before that: Summon Hawk (**Shift-F1**, a talent) at 25: a hawk stays 18 seconds, at most 2 at a time. Rapid Fire (**Q**) at 26.
- 40: Bestial Wrath (**F1**, a talent; all 30 points before it must be in Beast Mastery): your pet does 50% more damage for 18 seconds; cooldown 2 minutes. Volley (block D). Before that: Explosive Trap takes **Shift-2** at 34, Frenzy (a talent, passive) at 35.
- 50: stronger ranks of Summon Hawk, Aimed Shot and Mend Pet; nothing new for this role. After 40 the guides put your points in Marksmanship.
- 60: stronger ranks again; nothing new for this role.
**Beginner mistakes:**
- Shooting before your pet has the enemy. Then the enemy comes to you.
- Seeing Summon Hawk and Arcane Shot as two separate buttons. They share one cooldown: hawks first.
- Fighting in Aspect of the Cheetah or the Monkey. Deadly Aspects only works with the Hawk on.]] },
		{ band = 2, title = "Marksmanship: damage from a distance", body = [[
From level 1 (Auto Shot). Your own shots do the work, from far away. Aimed Shot comes at 20 from the trainer: it is not a talent. Sniper Shot is a talent, 40 at the earliest: a 4-second cast that reaches up to 45 yards. The guides say levelling works, but slower than Beast Mastery: your pet holds the enemy less well, because you do more damage. In groups it is strong: Trueshot Aura helps your whole party or raid. Lone Wolf (a talent, 20 at the earliest) gives 20% more damage while you have no pet; for levelling, the guides keep the pet.
**Simple order:**
Before you start: Aspect of the Hawk (**Shift-R**) and Trueshot Aura (**Shift-X**, from 25) on.
1. Hunter's Mark (**1**). With a pet: pet in (**Ctrl-1**).
2. Enemy still far away: Sniper Shot (**Shift-4**, from 40) to open.
3. Serpent Sting (**2**). Some guides skip it in short fights.
4. Aimed Shot (**4**, from 20) every time it is ready. Stand still.
5. Arcane Shot (**3**) in between, if your mana allows it.
6. Auto Shot (**Shift-Z**) keeps going.
7. A group of enemies: Multi-Shot (**Shift-1**) instead of Aimed Shot. A big group: Volley (block D, from 40).
8. Enemy at you: Scatter Shot (**E**, from 30), then step away. Concussive Shot (**Shift-Q**) slows it.
9. Tough enemy: Rapid Fire (**Q**, from 26) at the start.
**Per 10 levels:**
- 10: your pet, from the class quests. Aspect of the Hawk (**Shift-R**). First talents: Lethal Attacks, Hawk Eye, Improved Concussive Shot; from 15: Careful Aim, Efficiency, Improved Stings. Talent levels here are the earliest; a perk can bring them up to 5 levels sooner. Then Multi-Shot (**Shift-1**) at 18.
- 20: Aimed Shot (**4**), from the trainer: a 2-second cast, cooldown 6 seconds, shared with Multi-Shot. Talents: Rapid Killing, Improved Arcane Shot, Lone Wolf. Aspect of the Cheetah (**R**), Disengage (**Z**), Freezing Trap (**V**).
- 30: Scatter Shot (**E**, a talent): the enemy is confused for 4 seconds, and any damage breaks it; cooldown 30 seconds. Feign Death (**X**). Before that: Trueshot Aura (**Shift-X**, a talent) at 25: more Ranged Attack Power for your party, for 30 minutes. Rapid Fire (**Q**) at 26.
- 40: Sniper Shot (**Shift-4**, a talent; you need Trueshot Aura first): cooldown 15 seconds, and your next 3 shots reach 10 yards further. Volley (block D). Before that: Trueshot Aura rank 2 at the trainer at 32, Ranged Weapon Specialization (a talent, passive) at 35.
- 50: stronger ranks: Aimed Shot at 44 and 52, Sniper Shot at 48, Trueshot Aura and Volley at 50. After 40 the guides put your points in Beast Mastery.
- 60: stronger ranks again; nothing new for this role.
**Beginner mistakes:**
- Moving during Aimed Shot or Sniper Shot. They have a cast of 2 and 4 seconds.
- Multi-Shot on one enemy. Then Aimed Shot is gone for 6 seconds too.
- Sniper Shot when the enemy is already at you. It is a 4-second cast, and it does not work within 8 yards.]] },
		{ band = 3, title = "Survival: damage up close, with traps", body = [[
From level 1 (Raptor Strike), but the real Survival play starts around 30. In Forever this is the melee Hunter: Raptor Strike, Mongoose Bite, Counterattack and Strider Kick, plus traps. You keep your pet and your ranged weapon: open from a distance, then step in. The guides call it the slowest of the three to level; until about 30 you play like any Hunter (pet in, shoot). It costs a lot of mana, and a big hit from you can pull the enemy off your pet. The guides disagree on which melee weapon is best.
**Simple order:**
Before you start: Aspect of the Hawk (**Shift-R**) while you shoot. From 30, Aspect of the Beast for fighting up close; it has no fixed key, so put it on your own bar.
1. Hunter's Mark (**1**). Without the Mark, Expose Prey does not work.
2. Pet in (**Ctrl-1**).
3. Serpent Sting (**2**), then Arcane Shot (**3**) while the enemy comes, or while you walk to it.
4. A trap at your feet: Immolation Trap (**Shift-2**, from 16). From 34 that key is Explosive Trap, and Immolation Trap has no key: put it on your own bar if you want it.
5. Up close: Mongoose Bite (**Shift-C**, from 16) as soon as it lights up. Raptor Strike (**5**) every time it is ready. Strider Kick (from 30) every time it is ready; put it on your own bar. The guides differ: some step back to shoot after Strider Kick, others stay close.
6. Counterattack (**Shift-V**) right after a parry.
7. The enemy runs, or you want distance again: Wing Clip (**Shift-F**).
8. In trouble: Deterrence (**C**, from 20), Feign Death (**X**, from 30).
**Per 10 levels:**
- 10: your pet, from the class quests. Raptor Strike (**5**) you have from level 1. First talents: Improved Tracking, Deflection; from 15: Savage Strikes, Survivalist, Entrapment, Improved Wing Clip. Talent levels here are the earliest; a perk can bring them up to 5 levels sooner. Then Wing Clip (**Shift-F**) at 12, Mongoose Bite (**Shift-C**) and Immolation Trap (**Shift-2**) at 16.
- 20: Deterrence (**C**, a talent): 25% more dodge and parry for 10 seconds; cooldown 5 minutes. Freezing Trap (**V**), Aimed Shot (**4**), Dual Wield (passive, trainer). Disengage (**Z**): no jump; it lowers your **threat** (how much an enemy wants to attack you) up close, and stops your auto-attack. Talents: Surefooted, Clever Traps.
- 30: Strider Kick (a talent; no fixed key, put it on your own bar): 100% weapon damage, then you run 30% faster for 3 seconds; cooldown 8 seconds. Aspect of the Beast (trainer; put it on your own bar): more Melee Attack Power. Feign Death (**X**). Before that: Counterattack (**Shift-V**, a talent), from 25 or 30 (the sources differ): it becomes active after you parry, and holds the enemy in place for 5 seconds. Predator's Edge (a talent, passive) from 25. Also in this row: Expose Prey, Resourcefulness, Survivalist's Discipline.
- 40: Lacerating Strikes (a talent, passive; you need Expose Prey first): Mongoose Bite also makes the enemy bleed. Before that: Explosive Trap takes **Shift-2** at 34, Lightning Reflexes (a talent, passive) at 35.
- 50: stronger ranks: Counterattack at 42 and 54, Mongoose Bite at 44, Explosive Trap at 44 and 54, Raptor Strike at 48, Aspect of the Beast at 50. The guides disagree on where your points go after 40.
- 60: stronger ranks again; nothing new for this role.
**Beginner mistakes:**
- Running straight in. Open from a distance (Mark, pet, Sting, a shot), then step in.
- Pressing Mongoose Bite or Counterattack when they do not light up. Mongoose Bite only works after a dodge (or through Expose Prey), Counterattack only after a parry.
- Staying in Aspect of the Hawk up close after level 30. The Hawk only helps your shots; the Beast gives Melee Attack Power.]] },
	},
	-- Shaman: written 17 Nov 2026 by mh-writer from docs/forever/SHAMAN_ROLES_2026-11-17.md (DB2 1.60.1.70938 + guides).
	SHAMAN = {
		{ band = 1, title = "Elemental: damage from a distance", body = [[
From level 1: Lightning Bolt is there from the start. Lightning and fire from a distance. Flame Shock comes at 10, Chain Lightning at 32. Lightning Mastery is a talent, 40 at the earliest. The guides level as Enhancement: Elemental works, but its mana costs are very high, you have to stand still to cast, and many enemies at once are hard.
**Simple order:**
Before you start: Lightning Shield (**Shift-Z**, from 8) on. Searing Totem (**5**, from 10) down before the pull.
1. Open from a distance with Lightning Bolt (**1**).
2. Flame Shock (**2**, from 10) on an enemy that will live long.
3. Lightning Bolt (**1**) as your filler.
4. Three or more enemies: Fire Nova (**Shift-4**, from 12) and Chain Lightning (**Shift-1**, from 32) when they are ready.
5. Lightning Mastery (**Q**, from 40) for an elite or a big group.
6. Keep Earth Shock (**E**) for when the enemy casts: it interrupts the cast.
Low on health: Healing Wave (**C**). Enemy too close: Earthbind Totem (**V**) or Frost Shock (**4**, from 20).
**Per 10 levels:**
- 10: Lightning Bolt (**1**), Earth Shock (**E**, from 4), Lightning Shield (**Shift-Z**, from 8). Flame Shock (**2**), Searing Totem (**5**, from a quest). First talents: Convection, Concussion (passive). Talent levels here are the earliest; a perk can bring them up to 5 levels sooner. Then Fire Nova (**Shift-4**) and Purge (**Shift-Q**) at 12, Tremor Totem (**Shift-F**) at 18.
- 20: Frost Shock (**4**), Ghost Wolf (**R**), Call of the Elements (**Ctrl-1**). Elemental Focus (a talent, passive). Then Totemic Call (**Shift-R**) at 22. Earthbound (a talent) at 25: Earthbind Totem (**V**) holds enemies in place for 5 seconds, only at the moment you put it down. Magma Totem (block D) at 26.
- 30: Call of Thunder (a talent, passive). Grounding Totem (**X**), Call of the Ancestors (**Ctrl-2**), Reincarnation (passive). Lightning Overload (a talent, passive). Then Chain Lightning (**Shift-1**) at 32, Elemental Fury (a talent, passive) at 35.
- 40: Lightning Mastery (**Q**, a talent): for 15 seconds Lightning Bolt casts 0.5 seconds faster and Chain Lightning has no cooldown; cooldown 3 minutes. Call of the Spirits (**Ctrl-3**), Chain Heal (**Shift-2**). Mail armor at the trainer.
- 50: stronger ranks of Lightning Bolt, Chain Lightning, Earth Shock, Flame Shock, Fire Nova and Searing Totem; nothing new for this role.
- 60: stronger ranks again; nothing new for this role.
**Beginner mistakes:**
- Earth Shock for damage in a group. It causes a lot of **threat** (how much an enemy wants to attack you). And it shares its cooldown with Flame Shock: after that you have no interrupt.
- Chain Lightning on one enemy. It costs a lot of mana and has a 6-second cooldown.
- Finishing every enemy with a spell. Mana is your limit: hit an enemy that is almost dead with your weapon.]] },
		{ band = 2, title = "Enhancement: damage up close", body = [[
From level 1: you hit with your weapon, with Rockbiter Weapon on it. The guides level as Enhancement: they call it the comfortable choice. Use a slow two-handed weapon. Stormstrike is a talent, 25 at the earliest; Windfury Weapon comes at 30 from the trainer. Mana is your limit: when it runs low, stop casting and keep hitting. One guide's advice for the weapon buff: Rockbiter Weapon alone, Flametongue Weapon in a group, Windfury Weapon from 30. In a small group Enhancement can tank for a while with Rockbiter Weapon (Spirit Weapons then gives more threat), but there is no taunt and no defensive cooldown.
**Simple order:**
Before you start: weapon buff on (block D), Lightning Shield (**Shift-Z**), Searing Totem (**5**) or your totems down.
1. Pull with Lightning Bolt (**1**). **Pull** = hit one enemy from a distance so it comes to you.
2. Stormstrike (**1**, from 25) whenever it is ready.
3. Lightning Bolt (**1**) at 5 stacks of Maelstrom Weapon (from 35): then it is instant and free.
4. Earth Shock (**E**). In a group, take turns with Flame Shock (**2**).
5. Fire Nova (**Shift-4**, from 12) when a Fire totem is down and you have mana to spare; mostly against more enemies.
6. Rage of the Farseer (**Q**, from 40) for an elite or a big pull.
7. Otherwise just keep hitting.
After the fight: Healing Wave (**C**). Emergency during a fight: Lesser Healing Wave (**F2**, from 20).
**Per 10 levels:**
- 10: Rockbiter Weapon (block D), Lightning Bolt (**1**), Earth Shock (**E**, from 4), Lightning Shield (**Shift-Z**, from 8). Flame Shock (**2**), Searing Totem (**5**), Strength of Earth Totem (**Shift-X**), Flametongue Weapon (block D). First talents: Thundering Strikes and others (passive); Mental Dexterity (passive) from 15. Talent levels here are the earliest; a perk can bring them up to 5 levels sooner. Then Fire Nova (**Shift-4**) at 12.
- 20: Ghost Wolf (**R**), Frost Shock (**4**), Lesser Healing Wave (**F2**), Call of the Elements (**Ctrl-1**). Shamanistic Focus (a talent, passive): Shocks and Lightning Shield cost 45% less mana. Then Stormstrike (**1**, a talent) at 25. Flurry (a talent, passive) from 25. Improved Ghost Wolf (a talent) from 25: Ghost Wolf is faster (instant with both points) and works indoors too; the guides take it at very different levels. Magma Totem (block D) at 26.
- 30: Windfury Weapon (block D). Improved Stormstrike and Spirit Weapons (talents). Grounding Totem (**X**), Call of the Ancestors (**Ctrl-2**). Then Windfury Totem at 32 (no key: use the totem bar), Chain Lightning (**Shift-1**) at 32, Maelstrom Weapon (a talent, passive) at 35.
- 40: Rage of the Farseer (**Q**, a talent): you hit 30% faster for 25 seconds; only your weapon hits, not your spells. Cooldown 3 minutes. Not every guide takes it at 40: some first go into Restoration for mana. Call of the Spirits (**Ctrl-3**), mail armor, a stronger Windfury Weapon. Then Grace of Air Totem at 42 (no key: use the totem bar).
- 50: stronger ranks of Windfury Weapon, Rockbiter Weapon, Earth Shock, Lightning Bolt and Strength of Earth Totem; nothing new for this role.
- 60: stronger ranks again; nothing new for this role.
**Beginner mistakes:**
- Lightning Bolt with fewer than 5 stacks of Maelstrom Weapon. It resets your swing timer. And Maelstrom Weapon only helps Lightning Bolt: not heals, not Chain Lightning.
- Rockbiter Weapon in a group while you deal the damage, once you have Spirit Weapons. With Rockbiter you make 30% more threat, without it 30% less. Use Flametongue or Windfury.
- Looking for a taunt. The Shaman has none. Stoneclaw Totem (**F**) makes enemies attack the totem, not you.]] },
		{ band = 3, title = "Restoration: healer", body = [[
From level 1: Healing Wave is there from the start, and it is your main heal while levelling. The guides do not advise levelling alone as Restoration (enemies die slowly), but it is good in a group. Between dungeons you quest with Lightning Bolt and Flame Shock. Riptide is a talent, 40 at the earliest. A Shaman can remove Poison and Disease, but no curses and no magic.
**Simple order (in a group):**
Before you start: Water Shield (**Shift-Z**, from 20). Totems down: Call of the Elements (**Ctrl-1**, from 20) or Healing Stream Totem (**F4**, from 20).
1. Riptide (**Shift-F1**, from 40) on the tank or on whoever takes damage.
2. Chain Heal (**Shift-2**, from 40) on that same target when more people are hurt.
3. Healing Wave (**C**) for one person or the tank.
4. Lesser Healing Wave (**F2**, from 20) when it has to be fast.
5. Emergency: Nature's Swiftness (**Shift-3**, from 30), then Healing Wave (**C**).
6. Mana Tide Totem (**F1**, from 25) when your mana runs out.
7. Nobody hurt: Lightning Bolt (**1**).
**Per 10 levels:**
- 10: Healing Wave (**C**). First talents: Improved Healing Wave (a faster Healing Wave), Tidal Focus (passive). Talent levels here are the earliest; a perk can bring them up to 5 levels sooner. Then Ancestral Spirit (**F3**, outside a fight) at 12, Cure Poison (**Shift-C**) at 16, Tremor Totem (**Shift-F**) at 18.
- 20: Lesser Healing Wave (**F2**), Healing Stream Totem (**F4**, from a quest), Call of the Elements (**Ctrl-1**), Ghost Wolf (**R**). Water Shield (**Shift-Z**, a talent): 3 water globes; when you are hit or one of your spells crits, you get 2% of your mana back per globe. It lasts 10 minutes. From then on Shift-Z casts Water Shield, not Lightning Shield. Then Cure Disease (**Shift-V**) at 22. Mana Tide Totem (**F1**, a talent) at 25: gives your group mana back; cooldown 5 minutes. Mana Spring Totem at 26 (no key: use the totem bar).
- 30: Nature's Swiftness (**Shift-3**, a talent): your next Nature spell with a cast under 10 seconds is instant; cooldown 3 minutes. Healing Way (a talent, passive). Grounding Totem (**X**), Call of the Ancestors (**Ctrl-2**), Reincarnation (passive). Then Purification (a talent, passive) at 35, a stronger Mana Tide Totem at 38.
- 40: Chain Heal (**Shift-2**). Riptide (**Shift-F1**, a talent; you need Healing Way first): a heal over 15 seconds, not an instant heal, and a Chain Heal you cast directly on that target heals 25% more; cooldown 12 seconds. Call of the Spirits (**Ctrl-3**), mail armor.
- 50: stronger ranks of Riptide, Chain Heal, Healing Wave, Lesser Healing Wave, Mana Tide Totem and Healing Stream Totem; nothing new for this role.
- 60: stronger ranks again; nothing new for this role.
**Beginner mistakes:**
- Chain Heal on someone other than your Riptide target. The bonus only counts when you cast it directly on that target.
- Pressing only Nature's Swiftness. It heals nothing by itself: it makes your next Nature spell instant. Press Healing Wave right after.
- Trying to remove a curse. A Shaman cannot; only Poison (**Shift-C**) and Disease (**Shift-V**).]] },
	},
	-- Warlock: written 17 Nov 2026 by mh-writer from docs/forever/WARLOCK_ROLES_2026-11-17.md (DB2 1.60.1.70938 + guides).
	WARLOCK = {
		{ band = 1, title = "Affliction: damage over time", body = [[
From level 4 (Corruption) and 8 (Bane of Agony). You put DoTs on the enemy and let your demon hold it. Most guides level as Affliction. Siphon Life is a talent, 30 at the earliest. Wrack is a talent, 40 at the earliest: while you channel it, your Siphon Life, Corruption and Bane of Agony on that enemy tick 100% faster. Wrack does not heal you.
**Simple order:**
1. Send your demon in (**Ctrl-1**).
2. Bane of Agony (**5**) to pull. Its damage starts low, so your demon gets the enemy.
3. Corruption (**2**). With Improved Corruption 5/5 it is instant (14 at the earliest).
4. Siphon Life (**F4**, from 30), only on an enemy that will live long.
5. Immolate (**3**) only on a tough enemy.
6. Tough enemy: add your curse (**Shift-V**). The guides differ on how early.
7. Filler: until about level 30 your wand (Shoot; not on the block, put it on your own bar), then Drain Life (**C**). The guides differ a little on when to switch.
8. Shadow Trance lights up (Nightfall, from 25)? Shadow Bolt (**1**): it is instant then.
9. From 40: Wrack (block D) instead of Drain Life when your health is fine. Put your DoTs on first.
10. More health than mana? Life Tap (**F**).
11. Need a Soul Shard? Finish the enemy with Drain Soul (**4**).
Two enemies: DoTs on the first, Fear (**V**) on it, then fight the second. Damage can break Fear, and the guides differ on DoTs before Fear.
**Per 10 levels:**
- 10: Drain Soul (**4**), Create Healthstone (block D), the Voidwalker (quest). You already have Shadow Bolt (**1**), Immolate (**3**), Corruption (**2**, 4), Curse of Weakness (**Shift-V**, 4), Life Tap (**F**, 6), Bane of Agony (**5**, 8) and Fear (**V**, 8). First talent: Improved Corruption or Suppression (the guides differ). Talent levels here are the earliest; a perk can bring them up to 5 levels sooner. Then Health Funnel (**F2**) at 12; Drain Life (**C**) and Corruption rank 2 (15 seconds) at 14; Improved Drains and Soul Harvest (talents, passive) from 15; Searing Pain (block D) and Create Soulstone at 18.
- 20: Amplify Curse (**Shift-3**, a talent): your next Curse of Weakness or Bane of Agony is 50% stronger; cooldown 3 minutes. Curse of the Elements (**Shift-V**), Demon Armor (**Shift-Z**), Rain of Fire (**Shift-1**), the Succubus or Incubus (quest). Then Corruption rank 3 (18 seconds) and Drain Mana at 24. Curse of Exhaustion (**R**, a talent; you need Amplify Curse first) at 25: the enemy is 30% slower for 12 seconds. Nightfall (a talent, passive) at 25: a small chance that your next Shadow Bolt is instant. Banish (**Shift-Q**) at 28.
- 30: Siphon Life (**F4**, a talent): moves health from the enemy to you, for 30 seconds. Soul Siphon (a talent, passive): Drain Life, Drain Soul and Wrack do more for each of your Corruption, Siphon Life and Bane of Agony on the enemy. Drain Life rank 3, Hellfire (**Shift-2**), the Felhunter (quest). Then Shadow Ward (**Z**) at 32, Shadow Mastery (a talent, passive) at 35, Siphon Life rank 2 and Drain Life rank 4 at 38.
- 40: Wrack (block D, a talent; you need Siphon Life first): a 6-second channel that does damage every second and makes your DoTs on that enemy tick 100% faster. Howl of Terror (**Shift-F**), the Felsteed (quest). Then Death Coil (**X**) at 42, Soul Fire (**Q**) and Siphon Life rank 3 at 48.
- 50: Inferno (**F3**). Curse of the Elements rank 4. Otherwise stronger ranks.
- 60: Bane of Doom (**F1**): a big hit after 60 seconds; not on players. Otherwise stronger ranks.
**Beginner mistakes:**
- Putting Bane of Agony back on too early. Its strongest ticks come at the end.
- Using Wrack when you need health. Wrack does not heal; Drain Life does.
- Curse of Recklessness on the enemy you want to Fear. That enemy ignores Fear.]] },
		{ band = 2, title = "Demonology: damage with your demon", body = [[
From level 1 (the Imp), really from 10 (the Voidwalker). Your demon does much of the work, and the talents make it stronger. The guides differ on when to go into this tree: some go in from 10, others level as Affliction first and switch around 26 or 27. Demonic Sacrifice (20 at the earliest) only pays off with Demonic Pact (40 at the earliest). Before that, any demon you summon removes the buff.
**Simple order:**
1. Send your demon in (**Ctrl-1**), and let it hit first.
2. From 30: Soul Link (**Shift-X**) on, and again after every summon.
3. From 25 (Demonic Brand): Searing Pain (block D) on your demon's enemy. Again when the brand is gone (10 seconds). Before Demonic Brand: no Searing Pain.
4. Bane of Agony (**5**) and Corruption (**2**) on enemies that live long enough. Corruption has a 2-second cast here.
5. Filler: your wand (not on the block, put it on your own bar) or Shadow Bolt (**1**). Drain Life (**C**) when you need health.
6. Demon almost dead: Health Funnel (**F2**). It costs your own health.
7. Life Tap (**F**). With Demonic Energies your demon gets mana too.
8. From 40 (Demonic Pact): Demonic Sacrifice (**Shift-C**) on one demon, then summon a different one (block D). The buff lasts 2 hours. The guides differ on which demon to sacrifice.
9. From 48, with Decimation: enemy under 35% health? Shadow Bolt or Searing Pain, then Soul Fire (**Q**): faster, and no Soul Shard.
**Per 10 levels:**
- 10: the Voidwalker (quest; costs 1 Soul Shard). Its Torment gives **threat** (how much an enemy wants to attack it). Drain Soul (**4**) for shards. First talents: Unholy Power, Demonic Embrace, Improved Imp, Improved Health Funnel (passive). Talent levels here are the earliest; a perk can bring them up to 5 levels sooner. Then Health Funnel (**F2**) at 12; Demonic Energies, Fel Vitality and Improved Voidwalker (talents, passive) from 15; Sacrifice (Voidwalker) at 16; Consume Shadows (Voidwalker) and Searing Pain (block D) at 18.
- 20: Demonic Sacrifice (**Shift-C**, a talent): you sacrifice your demon for a buff of 2 hours. Imp: 15% more Shadow damage. Succubus or Incubus: 15% more Fire damage. Voidwalker: mana back. Felhunter: health back. Master Summoner (a talent, passive): summons are faster and cheaper. The Succubus or Incubus (quest). Demon Armor (**Shift-Z**). Then Suffering (Voidwalker) at 24. Fel Domination (**Shift-F1**, a talent; you need Master Summoner first) at 25: your next summon is 5.5 seconds faster and 50% cheaper. Demonic Brand and Decimation (talents, passive) from 25.
- 30: Soul Link (**Shift-X**, a talent; you need Demonic Sacrifice first): 30% of the damage on you goes to your demon, and you both do 3% more damage. It lasts as long as your demon is there. The Felhunter (quest; Spell Lock at 36). Demonic Knowledge (a talent, passive). Then Master Demonologist (a talent, passive) from 35.
- 40: Demonic Pact (a talent, passive; you need Soul Link first): the Demonic Sacrifice buff stays when you summon a different demon. Only now does Demonic Sacrifice pay off. Howl of Terror (**Shift-F**), the Felsteed (quest). Then Death Coil (**X**) at 42, Soul Fire (**Q**) at 48.
- 50: Inferno (**F3**): an Infernal; 1 Infernal Stone each time; cooldown 1 hour. Otherwise stronger ranks.
- 60: Bane of Doom (**F1**). Otherwise stronger ranks.
**Beginner mistakes:**
- Searing Pain before you have Demonic Brand. It causes a lot of threat and pulls the enemy off your demon.
- Demonic Sacrifice before Demonic Pact (40). Your demon is gone, and summoning any demon removes the buff.
- After Demonic Pact, summoning the same demon you sacrificed. Then the buff is gone.]] },
		{ band = 3, title = "Destruction: damage with big hits", body = [[
From level 1 (Shadow Bolt and Immolate). Big fire and shadow hits, and it costs the most mana. Some guides advise against levelling with it (a lot of mana, little to get it back); others call it playable, and one calls it strong in dungeons. Conflagrate is a talent, 25 at the earliest; Incinerate is a talent, 40 at the earliest. The turning point is Shadow and Flame 5/5 (39 at the earliest): from then on Conflagrate no longer eats your Immolate, and Shadowburn always gives its Soul Shard back.
**Simple order:**
1. Send your demon in (**Ctrl-1**).
2. Immolate (**3**). One guide opens with Shadow Bolt from far away, with Immolate right after.
3. Tough enemy: Bane of Agony (**5**) and your curse (**Shift-V**).
4. From 25: Conflagrate (block D). Before Shadow and Flame 5/5 it eats your Immolate: use it at the end of Immolate, or as the last hit. After that: every time it is ready.
5. Filler: Shadow Bolt (**1**). From 40 Incinerate (block D), with Immolate on the enemy.
6. From 20: Shadowburn (**Shift-4**) as the last hit. Then you get the Soul Shard back.
7. Life Tap (**F**) between fights. Low on mana: your wand (not on the block, put it on your own bar).
8. More enemies: from 30 Bane of Havoc (block D) on one tough enemy, then attack the rest. Rain of Fire (**Shift-1**). Hellfire (**Shift-2**, from 30) only with enough health.
**Per 10 levels:**
- 10: Shadow Bolt (**1**) and Immolate (**3**; rank 2 at 10). First talent: Bane (faster casts) or Improved Shadow Bolt. Talent levels here are the earliest; a perk can bring them up to 5 levels sooner. Then Shadow Bolt rank 3 at 12 (2.8-second cast); Aftermath and Cataclysm (talents, passive) from 15; Searing Pain (block D) at 18.
- 20: Shadowburn (**Shift-4**, a talent): an instant Shadow hit; costs 1 Soul Shard; cooldown 15 seconds. If the enemy (one that gives XP) dies within 8 seconds, you get a shard back. Ruin (a talent, passive): your Destruction crits hit harder. Rain of Fire (**Shift-1**). Shadow Bolt rank 4 (3-second cast). Then Shadowburn rank 2 at 24. Conflagrate (block D, a talent) at 25: an instant Fire hit on an enemy with your Immolate; that Immolate is then gone; cooldown 10 seconds. Agonizing Flames and Intensity (talents, passive) from 25.
- 30: Bane of Havoc (block D, a talent): 5 minutes on one enemy; 15% of all your damage on other enemies also hits this one. Only one enemy at a time. Fire and Brimstone (you need Conflagrate first) and Pyroclasm (you need Intensity first), talents, passive. Hellfire (**Shift-2**). Then Conflagrate rank 2 and Shadowburn rank 3 at 32; Shadow and Flame (a talent, passive) from 35, 5/5 at 39 at the earliest.
- 40: Incinerate (block D, a talent; you need Bane of Havoc first): a 2.5-second cast, 25% more damage when the enemy has your Immolate. Conflagrate rank 3, Shadowburn rank 4. Then Soul Fire (**Q**) at 48.
- 50: Incinerate rank 2. Inferno (**F3**).
- 60: Incinerate rank 3, Conflagrate rank 6. Bane of Doom (**F1**).
**Beginner mistakes:**
- Conflagrate right after Immolate. It eats your Immolate (until Shadow and Flame 5/5).
- Shadowburn with no Soul Shard, or on an enemy that will live long. The shard only comes back if the enemy dies within 8 seconds.
- Bane of Havoc and Bane of Agony on the same enemy. Only one bane fits on it.]] },
	},
	-- Paladin: written 17 Nov 2026 by mh-writer from docs/forever/PALADIN_ROLES_2026-11-17.md (DB2 1.60.1.70938 + guides).
	PALADIN = {
		{ band = 1, title = "Holy: healer", body = [[
From level 1: Holy Light is there from the start. A **healer** keeps the group alive. The guides call Holy the slowest tree to level alone: level as Retribution and heal in dungeons, or play Holy with a friend. The tree's own buttons come at 20 (Divine Favor), 25 (Oath of Light), 30 (Holy Shock) and 40 (Light's Vigil).
**Simple order (in a group):**
Before the pull: Blessing of Wisdom (**Shift-V**, from 14) on yourself, Blessing of Kings (**Shift-X**, from 20) on the others. Aura: Devotion Aura (**Ctrl-1**), or Concentration Aura (**Ctrl-3**, from 22) when casters get hit a lot.
1. Oath of Light (**Shift-R**, from 25) on the tank. It lasts 1 hour, and only one player can have it.
2. Flash of Light (**F2**, from 20) is your normal heal. Before 20: Holy Light (**C**).
3. Holy Light (**C**) for a big hit. From 25 (Infusion of Light) it casts faster right after a crit of Holy Shock or Flash of Light. **Crit** = a lucky, stronger hit or heal.
4. Holy Shock (**F4**, from 30) when there is no time to cast, or while you move.
5. The whole party hurt, from 40: Light's Vigil (**Shift-F1**) on one player, then Holy Shock (**F4**) on that same player.
6. Divine Favor (**Shift-3**, from 20) before a heal that must be big.
7. A bad effect on a friend: Purify, later Cleanse (**Shift-C**).
8. Emergency: Lay on Hands (**Q**). It uses up all the mana you have left.
Nothing to heal: your seal (**3**), Judgement (**2**) and Holy Strike (**1**) up close. Alone: play like a Retribution Paladin; from 30 Holy Shock (**F4**) on the enemy is your one strong damage button.
**Per 10 levels:**
- 10: you already have Holy Light (**C**), Devotion Aura (**Ctrl-1**), Blessing of Might (**Shift-Z**), Divine Protection (**Z**), Hammer of Justice (**E**) and Purify (**Shift-C**). New at 10: Lay on Hands (**Q**), Blessing of Protection (**Shift-F**). First talent: Spiritual Focus (passive). Talent levels here are the earliest; a perk can bring them up to 5 levels sooner. Then Redemption (**F3**, from a quest) at 12, Blessing of Wisdom (**Shift-V**) at 14, Reverence and Healing Light (talents, passive) from 15, Blessing of Freedom (**R**) at 18.
- 20: Flash of Light (**F2**), Blessing of Kings (**Shift-X**). Divine Favor (**Shift-3**, a talent): your next Flash of Light, Holy Light or Holy Shock is a sure crit; cooldown 2 minutes. Illumination (a talent, passive; you need Reverence first). Then Concentration Aura (**Ctrl-3**) at 22. Oath of Light (**Shift-R**, a talent) and Infusion of Light (a talent, passive) at 25.
- 30: Holy Shock (**F4**, a talent): instant, damage on an enemy or a heal on a friend; cooldown 10 seconds. Divine Intervention (**F3** in a fight: you die yourself). Seal of Light (block D). Then Divine Shield (**Z**) at 34, Holy Power (a talent, passive) at 35, Seal of Wisdom (block D) at 38.
- 40: Light's Vigil (**Shift-F1**, a talent; you need Holy Shock first): on a friend for 30 seconds; your next Holy Shock on that friend has no cooldown and heals their party too. Holy Shock rank 2. Plate Mail: you can wear plate. Then Cleanse (**Shift-C**) at 42, Blessing of Sacrifice (block D) at 46, Holy Shock rank 3 at 48.
- 50: Light's Vigil rank 2, Lay on Hands rank 3. Then Greater Blessing of Might at 52 and of Wisdom at 54, Holy Shock rank 4 at 56.
- 60: Greater Blessing of Kings, Light's Vigil rank 3; nothing new for this role.
**Beginner mistakes:**
- Holy Light for every small hit. Flash of Light (**F2**, from 20) is the cheap normal heal.
- Light's Vigil on one player and Holy Shock on another. The party heal only comes from Holy Shock on the SAME player.
- Pressing F3 in a fight by accident. Then it casts Divine Intervention, and you die yourself. Outside a fight F3 is Redemption.]] },
		{ band = 2, title = "Protection: tank", body = [[
From level 10 (Righteous Fury and Seal of Fury at the trainer). A **tank** is the one the enemies hit, so the rest of the group stays safe. **Threat** = how much an enemy wants to attack you. You carry a one-handed weapon and a shield. The guides disagree on how well Protection levels alone. The tree's buttons: Templar's Bulwark at 20, Swift Judgement at 25, Holy Shield at 30.
**Simple order:**
1. Before the pull: Righteous Fury on (no fixed key: it is on block D, or put it on your own bar; it lasts 30 minutes). Seal of Fury (**F**), a blessing, an aura. The guides disagree on the aura: Devotion Aura (**Ctrl-1**) or Retribution Aura (**Ctrl-2**).
2. From 30: Holy Shield (**Shift-4**) just before the enemies reach you. Press it again every time it is ready.
3. Judgement (**2**) on the first enemy. With Seal of Fury on, Judgement is your taunt (3 seconds). **Taunt** = make the enemy attack you.
4. Two or more enemies, from 20: Consecration (**Shift-1**) under them. Only the first 4 take the extra damage.
5. Holy Strike (**1**) every time it is ready.
6. An enemy runs to someone else: Judgement (**2**). Not ready? From 25: Swift Judgement (**F1**), a second Judgement with its own 1-minute cooldown.
7. An enemy casts a spell: Hammer of Justice (**E**). The Paladin has no interrupt.
8. Exorcism (**5**, from 20) on Undead and Demons. Hammer of Wrath (**4**, from 44).
9. Big damage coming, from 20: Templar's Bulwark (**X**). Last resort: Lay on Hands (**Q**).
Low on mana: drop Consecration first. From 40 (Shieldsworn): Holy Shield first, then Holy Strike. Not the tank (alone, or someone else tanks): use your seal on **3**, not Seal of Fury.
**Per 10 levels:**
- 10: Righteous Fury (block D) and Seal of Fury (**F**). You already have Judgement (**2**), Holy Strike (**1**), Hammer of Justice (**E**), Devotion Aura (**Ctrl-1**) and Divine Protection (**Z**). Also new: Lay on Hands (**Q**), Blessing of Protection (**Shift-F**). First talent: Redoubt (passive). Talent levels here are the earliest; a perk can bring them up to 5 levels sooner. Then Precision, Guardian's Favor or Sacred Duty (talents, passive) from 15, Retribution Aura (**Ctrl-2**) at 16.
- 20: Templar's Bulwark (**X**, a talent): a shield that soaks up damage equal to your max health, for 8 seconds; cooldown 5 minutes. Consecration (**Shift-1**), Blessing of Kings (**Shift-X**), Exorcism (**5**). Shield Specialization (a talent, passive; you need Redoubt first). Then Swift Judgement (**F1**, a talent; you need Templar's Bulwark first) and Improved Righteous Fury (a talent, passive) at 25.
- 30: Holy Shield (**Shift-4**, a talent; you need a shield): 30% more block chance for 10 seconds, 4 charges; cooldown 10 seconds. Reckoning (a talent, passive). Then Divine Shield (**Z**) at 34, Iron Creed (a talent, passive) at 35.
- 40: Shieldsworn (a talent, passive; you need Holy Shield first): Holy Strike every 6 seconds, and it works with Holy Shield. Plate Mail: you can wear plate. Holy Shield rank 2. Then Hammer of Wrath (**4**) at 44, Blessing of Sacrifice (block D) at 46.
- 50: Holy Shield rank 3, Holy Wrath (block D); stronger ranks of Seal of Fury and Consecration.
- 60: Holy Shield rank 4 and stronger ranks; nothing new for this role.
**Beginner mistakes:**
- Forgetting Righteous Fury. Without it you make far less threat. Check it before every pull; it lasts 30 minutes.
- Seal of Fury on when you are not the tank. Every Judgement then taunts.
- No shield. Holy Shield does not work without one, and Seal of Fury gives no absorb.]] },
		{ band = 3, title = "Retribution: damage up close", body = [[
From level 1 (Seal of Righteousness); Judgement comes at 4, Holy Strike at 6. The guides call Retribution the fastest tree to level alone, with one slow two-handed weapon. The class quest at 20 gives you one. The tree's buttons: Seal of Command at 20, Repentance at 30.
**Simple order:**
1. Before the fight: Blessing of Might (**Shift-Z**) until 20, then Blessing of Kings (**Shift-X**).
2. Aura: Devotion Aura (**Ctrl-1**); Retribution Aura (**Ctrl-2**, from 16) against several enemies.
3. Seal on (**3**): Seal of Righteousness, until you know Seal of Command (from 20). Then key 3 casts Seal of Command.
4. Judgement (**2**) every time it is ready. It does not use up the seal.
5. Holy Strike (**1**) every time it is ready.
6. Undead or Demon, from 20: Exorcism (**5**).
7. Two or more enemies, from 20: Consecration (**Shift-1**). Not on one enemy: it costs too much mana.
8. From 44: Hammer of Wrath (**4**) when the enemy is at 20% health or less.
9. Strong enemy: Hammer of Justice (**E**), then Judgement (**2**). With Seal of Command, Judgement does double damage on a stunned enemy.
10. A second Humanoid, from 30: Repentance (**V**), and do not hit it.
11. Put the seal back on when it runs out (30 seconds). Low on health: Holy Light (**C**) between fights.
**Per 10 levels:**
- 10: you already have Seal of Righteousness (**3**), Judgement (**2**), Holy Strike (**1**), Blessing of Might (**Shift-Z**) and Hammer of Justice (**E**). New at 10: Lay on Hands (**Q**). First talent: Benediction (most guides) or Deflection (one guide), both passive. Talent levels here are the earliest; a perk can bring them up to 5 levels sooner. Then Improved Judgement, Conviction or Sanctified Judgement (talents, passive) from 15, Retribution Aura (**Ctrl-2**) at 16.
- 20: Seal of Command (**3**, a talent): your hits sometimes do an extra Holy hit. From then on key 3 casts it instead of Seal of Righteousness. Consecration (**Shift-1**), Exorcism (**5**), Blessing of Kings (**Shift-X**), Flash of Light (**F2**). Pursuit of Justice (a talent, passive: you move 15% faster at 2/2). The class quest for a two-handed weapon. Then Sacred Arbiter and Two-Handed Weapon Specialization (talents, passive) at 25.
- 30: Repentance (**V**, a talent): takes one Humanoid out for up to 6 seconds; any damage wakes it; cooldown 1 minute. Vengeance (a talent, passive; you need Seal of Command first): after a crit you do more damage for 30 seconds; it stacks 5 times. Seal of Command rank 2. Then Divine Shield (**Z**) at 34, Champion of the Light (a talent, passive) at 35.
- 40: Unsealed Wrath (a talent, passive; you need Repentance first): your hits store copies of your seal, and a hit with a different seal uses them. Plate Mail: you can wear plate. The Warhorse quest. Then Hammer of Wrath (**4**) at 44.
- 50: Seal of Command rank 4, Holy Wrath (block D), Hammer of Wrath rank 2 at 52; nothing new for this role.
- 60: Seal of Command rank 5 and stronger ranks; the Charger quest (Alliance); nothing new for this role.
**Beginner mistakes:**
- Putting the seal on again after every Judgement. Judgement does not use it up; a seal lasts 30 seconds.
- Seal of Command with a fast weapon. It wants a slow two-handed weapon.
- Consecration on one enemy. It costs too much mana for that.]] },
	},
}
ns.FOREVER_HOWTOPLAY_ROLES = ROLES -- the offline check reads it

--[[
	21 Nov 2026 — "Level as X, tank as Y" (Rob via sparring: "Ik ben nu een paladin aan het levelen ... als tank ... Heb ik
	een two-handed sword nodig? ... een one-handed en een shield? ... welke talentpunten ... ook bij andere ... zoals een
	druid"; GO: "Ja, voeg dat maar toe en laat het maar uitvoeren ook. Ik vind dat wel iets belangrijks eigenlijk.").
	Only for the three classes that can tank (ChrClasses.RolesMask, GEMETEN 16 Nov). Always shown in full, whatever the
	direction: it is the answer to "which one do I level with". Levels of spells and talents = the role texts above
	(GEMETEN in DB2 when those were written); which dungeon at which level and "the guides say" = AFGELEID (guides).
	Translations: ns.FOREVER_HOWTOPLAY_L[code].PLANS[class] = { title, body }; missing = English.
]]
local PLANS = {
	PALADIN = { title = "Level as Retribution, tank as Protection", body = [[
- **Levelling:** the guides call Retribution the fastest way to level alone: one slow **two-handed weapon** and Seal of Righteousness, later Seal of Command (20, a talent). Spend your talent points in Retribution.
- **Tanking a dungeon** works from your first one, without a respec: Ragefire Chasm for the Horde (from level 13), the Hall of Thanes for the Alliance (about 13): Righteous Fury and Seal of Fury both come at 10. Keep a **one-handed weapon and a shield in your bags**. Before the dungeon: swap to them, put Righteous Fury on (block D) and Seal of Fury (**F**). After it: back to the two-hander, and Righteous Fury off (right-click it at the top right). With Righteous Fury on you pull the enemies away from your group.
- **When it gets easy:** at 30 with Holy Shield (a Protection talent), and properly at 40 with Shieldsworn. If you want to do that, you need Protection talents: **Dual Spec** (from 40) gives you a second set, so you can level as Retribution and tank as Protection. See "Talents: reset and Dual Spec" below.
- **Stats for tanking:** Stamina first. The guides do not agree on what comes next: wowforeverbuilder says Defense, Stamina, spell power, Intellect (no Strength), another guide puts spell power and Intellect above Strength. Spell power makes Consecration and Holy Shield hold enemies better.
- **Two-handed sword from Wolfsbane** (the Undead class quest at 20): learn Two-Handed Swords first, from Archibald in Undercity. MH tells you in Do this now.]] },
	WARRIOR = { title = "Level and tank as a Warrior", body = [[
- **Levelling:** the guides disagree. Most say Protection levels fastest: a two-handed weapon until Revenge at 14, then a **one-handed weapon and a shield**. One guide finds Protection slower alone. Arms or Fury work too; then keep a one-handed weapon and a shield in your bags for tanking.
- **Tanking a dungeon** works from your first one: Ragefire Chasm (Horde) from level 13, the Hall of Thanes (Alliance) from about 13, the Deadmines from 16, Wailing Caverns from 17. The class quest at 10 gives you Defensive Stance, Taunt and Sunder Armor. In Forever, Defensive Stance makes a lot more threat than in the old game, so enemies stay on you.
- **When it gets easy:** at 14-16 with Revenge and Shield Block, and properly at 40 with Shield Slam (a talent) and Plate Mail.
- **Talents:** with Protection talents you level and tank with one set. Did you level as Arms or Fury? Then **Dual Spec** (from 40) gives you a second set for tanking. See "Talents: reset and Dual Spec" below.
- **Stats for tanking:** Stamina first. The guides disagree on the rest: one puts Defense last, another wants Defense up to 440 early. For threat: hit and expertise.]] },
	DRUID = { title = "Level and tank as a Druid", body = [[
- **Levelling:** the guides pick Feral: the bear from level 10, the cat from 20. Feral talents work for both, so you level as a cat and tank as a bear with the same talents. You need no shield and no second weapon.
- **Your weapon counts in a form.** Blizzard: in Bear and Cat Form your normal hits do the damage of the weapon you hold. So keep the best two-handed staff or mace, also for tanking.
- **Tanking a dungeon** works from your first one: Ragefire Chasm for the Horde (from level 13), the Hall of Thanes for the Alliance (about 13). Bear Form comes from the class quest at 10, with Growl and Maul (one guide says only Maul: check your spells). In Forever, Bear Form makes a lot more threat than in the old game.
- **When it gets easy:** Swipe at 16 (more enemies at once), Lacerate at 25 (a talent), and properly at 40 with Dire Bear Form and Primal Bite (a talent).
- **Healing in a group?** That needs Restoration talents and Intellect gear: **Dual Spec** (from 40) gives you a second set. See "Talents: reset and Dual Spec" below.
- **Stats for tanking:** the guides disagree. For surviving: armor, then Defense up to 440, then Stamina, then Agility. For threat: weapon damage, then Agility, then Strength. Another guide says weapon damage, Strength, Agility while you level.]] },
}
ns.FOREVER_HOWTOPLAY_PLANS = PLANS -- the offline check reads it

local GOLD, HEAD = "|cffffd100", "|cffffcc66"
local GREY_NOTE = "|cffb0b0b0"

--- "**word**" → gold. Everything else is plain text.
local function Format(body)
	return (body:gsub("%*%*(.-)%*%*", GOLD .. "%1|r"))
end

local function ClassName(token)
	local names = LOCALIZED_CLASS_NAMES_MALE
	return (names and names[token]) or (token:sub(1, 1) .. token:sub(2):lower())
end

--- 7 Nov 2026 (Rob: "Alles in 5.0.0"): the translations live in Locales/ForeverHowToPlay_<code>.lua, one file per
--- language, each `ns.FOREVER_HOWTOPLAY_L[code] = { COMMON = {...}, DRUID = {...}, ... }` in the SAME shape as the
--- English tables here (same sections, same order). A class or COMMON missing in a language falls back to English.
local function Translated()
	local all = ns.FOREVER_HOWTOPLAY_L
	local code = ns.GetEffectiveLocaleCode and ns:GetEffectiveLocaleCode()
	if not (all and code) then
		return nil
	end
	-- The esMX client reads the esES pack (Locale.lua maps esMX → esES), but a few Forever names differ there (the Rogue's
	-- powders swap, CLIENT_NAMES_FOREVER section 5): an esMX table, when there is one, wins on that client.
	if code == "esES" and GetLocale and GetLocale() == "esMX" and all.esMX then
		return all.esMX
	end
	return all[code]
end

--------------------------------------------------------------------------------
-- 24 Nov 2026 (Rob, Warlock with 12 x 4: "ik zie een fout in how to play , de oude keyblock staan er nog in"). The texts
-- (8 languages) were written for the old block: "Bane of Agony (**5**)", "Health Funnel (**F2**)". With 12 x 4 chosen,
-- every key named in them is now translated when the text is shown, from the SAME class tables the block uses (old
-- keys -> the spells on it -> where those spells are in keys12), so the two can never drift apart again. A spell with no
-- 12 x 4 key reads "block D". Which forms are read (GEMETEN in the 8 files: keys are written the same in every language,
-- "Shift-"/"Ctrl-", never translated):
--   **K** (bold, everywhere) · (K) in the "Simple order" sections (plain parentheses; elsewhere "(4)" is a LEVEL) ·
--   "<on> K" in the class sections, with the word for "on" of that language ("Regrowth on F2").
-- With the old block the text is left exactly as it is.
--------------------------------------------------------------------------------
local OLD_FIXED = { T = "CTRL-Z", ["SHIFT-T"] = "CTRL-C", G = "CTRL-V" }
local PREP = { enUS = "on", enGB = "on", nlNL = "op", deDE = "auf", frFR = "sur", esES = "en", esMX = "en",
	ptBR = "no", ruRU = "на" }
local BLOCKD = { enUS = "block D", enGB = "block D", nlNL = "blok D", deDE = "Block D", frFR = "bloc D", esES = "bloque D",
	esMX = "bloque D", ptBR = "bloco D", ruRU = "блок D" } -- the words the texts themselves use (GEMETEN, 50-57 times each)

--- "Shift-2" -> "SHIFT-2", "F2" -> "F2", "5" -> "5"; nil when it is no key of the old block.
local function KeyCode(tok)
	local m, k = tok:match("^(%a+)%-(%w+)$")
	if m then
		m = m:upper()
		if m == "SHIFT" or m == "CTRL" or m == "ALT" then
			return m .. "-" .. k:upper()
		end
		return nil
	end
	if tok:match("^[1-5]$") or tok:match("^F[1-4]$") or tok:match("^[QERFTGZXCV]$") then
		return tok
	end
	return nil
end

--- "SHIFT-2" -> "Shift-2" (the way the texts write it).
local function KeyText(code)
	local m, k = code:match("^(%u+)%-(.+)$")
	if m then
		return m:sub(1, 1) .. m:sub(2):lower() .. "-" .. k
	end
	return code
end

--- Old key -> 12 x 4 key for this class ("D" = block D), built from the class tables; cached per class.
local keyMapCache = {}
local function KeyMap(token)
	local cls = ns.FOREVER_BLOCK_CLASSES and ns.FOREVER_BLOCK_CLASSES[token]
	if not (cls and cls.keys and cls.keys12 and ns.ForeverBlockKeyNames) then
		return nil
	end
	local held = ns.ForeverBlockFallbackHeld and ns.ForeverBlockFallbackHeld() or {}
	-- 28 Nov 2026: the TEXTS are written with the keys of the class table itself (cls.keys: the swapped layout, no
	-- direction), so an old key in a text is read from that; where the spell is NOW comes from the 12 x 4 keys as the
	-- "Swap keys" switch and the direction have them (ForeverBlock.lua KeysFor). So "Frostbolt (2)" reads "(1)" for a
	-- Frost mage, and "Hunter's Mark (1)" reads "(Shift-Z)" with the switch off.
	local KF = ns.ForeverBlockKeysFor
	local keysOld, keys12 = cls.keys, KF and KF(cls, true) or cls.keys12
	cls = setmetatable({ keys = keysOld, keys12 = keys12 }, { __index = cls })
	local primary, any = {}, {}
	for k12, def in pairs(cls.keys12) do
		-- 28 Nov 2026 (offline check of "Until level X"): a command key (the pet's Attack/Follow/Stay) names its `needs`
		-- spell (Call Pet), so pairs() could put "Call Pet" on Ctrl-2 instead of Ctrl-4 — different per run. A command
		-- key holds no spell of its own: it never decides where a spell is.
		for i, n in ipairs(def.cmd and {} or (ns.ForeverBlockKeyNames({ [k12] = def }))) do
			any[n] = any[n] or k12
			local v = def.all or def.base
			local isFallback = type(v) == "table" and v[1] ~= n and (function()
				for j = 2, #v do
					if v[j] == n then
						return true
					end
				end
				return false
			end)()
			if not isFallback then
				primary[n] = primary[n] or k12
			end
		end
	end
	local map, split = {}, {}
	for kOld, def in pairs(cls.keys) do
		-- 27 Nov 2026 (bug found by the form audit): an old key whose spells sit on DIFFERENT 12x4 keys (Druid old X =
		-- Frenzied Regeneration + Nature's Grasp → C and X) had one map entry, picked from the first name pairs() gave —
		-- not a fixed order — so one of the two texts named the wrong key. split[kOld] = { [english] = 12x4 key } lets
		-- LiveKeys pick by the spell name written next to the key in the text.
		if not def.cmd then
			local per, n, first = {}, 0, nil
			for _, en in ipairs((ns.ForeverBlockKeyNames({ [kOld] = def }))) do
				local k12 = held[en] or primary[en] or any[en]
				if k12 then
					per[en] = k12
					if first and first ~= k12 then
						n = n + 1
					end
					first = first or k12
				end
			end
			if n > 0 then
				split[kOld] = per
			end
		end
		if def.cmd then
			for k12, d12 in pairs(cls.keys12) do
				if d12.cmd and d12.cmd.text == def.cmd.text then
					map[kOld] = k12
				end
			end
		else
			local names = ns.ForeverBlockKeyNames({ [kOld] = def })
			local first = names[1]
			if first then
				-- Right now on a fallback key (Immolate on the Warlock's 3 until Agony)? Then that key.
				map[kOld] = held[first] or primary[first] or any[first] or "D"
			end
		end
	end
	for k, v in pairs(OLD_FIXED) do
		map[k] = map[k] or v
	end
	return map, split
end
ns.ForeverHowToKeyMap = KeyMap -- the offline check calls it

--- The client's own name of a spell from its English table name (the texts are written with the client's names).
local function ClientName(en)
	for _, id in ipairs((ns.FOREVER_SPELL_IDS and ns.FOREVER_SPELL_IDS[en]) or {}) do
		local n
		if C_Spell and C_Spell.GetSpellName then
			local ok, v = pcall(C_Spell.GetSpellName, id)
			n = ok and v or nil
		end
		if not n and GetSpellInfo then
			local ok, v = pcall(GetSpellInfo, id)
			n = ok and v or nil
		end
		if type(n) == "string" and n ~= "" and not (issecretvalue and issecretvalue(n)) then
			return n
		end
	end
	return en
end

--- The text with its block keys in the layout this character uses. Unchanged with the old block.
local function LiveKeys(token, text, simpleOrder)
	if type(text) ~= "string" or not (ns.KeyBlockLayoutName and ns.KeyBlockLayoutName() == "12x4") then
		return text
	end
	local map, split = KeyMap(token)
	if not map then
		return text
	end
	local loc = (ns.GetEffectiveLocaleCode and ns:GetEffectiveLocaleCode()) or "enUS"
	-- pos/stop = where the token stands in `src`, so a split key can read the spell name written next to it
	-- ("Frenzied Regeneration (**X**" or "**X** = Frenzied Regeneration").
	local src
	local function new(tok, pos, stop)
		local code = KeyCode(tok)
		local to = code and map[code]
		local per = code and split and split[code]
		if per and src and pos then
			local before = src:sub(math.max(1, pos - 60), pos - 1)
			local after = src:sub(stop or pos, (stop or pos) + 60)
			-- Only a name RIGHT next to the key counts: "Name (**X**" / "Name on X" before it, or "**X** = Name" after it.
			-- A name that merely appears further on ("... (**X**) and Nature's Grasp") must not decide (offline check,
			-- 5 of 5 runs). Before-matches win over after-matches. The client's name first, the English one as fallback.
			local eq = after:match("^%s*=%s*(.*)$")
			local found
			for pass = 1, 2 do
				for en, k12 in pairs(per) do
					for _, n in ipairs({ ClientName(en), en }) do
						local hit
						if pass == 1 then
							hit = before:sub(-(#n + 2)) == n .. " (" or before:sub(-(#n + 1)) == n .. " "
						else
							hit = eq ~= nil and eq:sub(1, #n) == n
						end
						if hit then
							found = k12
							break
						end
					end
					if found then
						break
					end
				end
				if found then
					break
				end
			end
			to = found or to
		end
		if not to then
			return nil
		end
		return to == "D" and (BLOCKD[loc] or BLOCKD.enUS) or KeyText(to)
	end
	src = text
	text = src:gsub("()%*%*([^*\n]+)%*%*()", function(pos, inner, stop)
		local n = new(inner, pos, stop)
		return n and ("**" .. n .. "**") or nil
	end)
	if simpleOrder then
		src = text
		text = src:gsub("()%(([^()\n]+)%)()", function(pos, inner, stop)
			local n = new(inner, pos, stop)
			return n and ("(" .. n .. ")") or nil
		end)
		-- "(C, from 14)": a key first, then more words.
		text = text:gsub("%(([%w%-]+)(, [^()\n]*)%)", function(tok, rest)
			local n = new(tok)
			return n and ("(" .. n .. rest .. ")") or nil
		end)
	end
	local prep = PREP[loc] or PREP.enUS
	src = text
	text = src:gsub("()(%f[%w%z\128-\255]" .. prep .. " )([%w%-]+)()", function(pos, p, tok, after)
		-- A bare digit only when a mark, a bracket or the end follows ("on 5 (works", "on 5."), never "en 5 segundos".
		if tok:match("^%d$") then
			local nxt = src:sub(after, after + 1)
			if not (nxt == "" or nxt:match("^[%.,;:%)\n]") or nxt:match("^ %(")) then
				return nil
			end
		end
		local n = new(tok, pos, after)
		return n and (p .. n) or nil
	end)
	return text
end
ns.ForeverHowToLiveKeys = LiveKeys -- the offline check calls it

--------------------------------------------------------------------------------
-- 28 Nov 2026 (Rob via Sparring 28-11, after testing "Until level 10": "er staat alleen bij de eerste keer level 1
-- tussen haakjes. En daarna niet meer ... tussen haakjes 1, wat is dat dan?"; "lvl" in front, Rob: "ja"). A level in
-- brackets is shown as "(lvl 4)", the first "(level 1)" too. Done when the text is shown, so the 8 language files keep
-- their words. Which brackets hold a LEVEL: any number 1-60 in "(N)" or "(N, ...)", EXCEPT in the sections where plain
-- brackets hold KEYS ("Simple order" and "Beginner mistakes", see LiveKeys): there a number that is a block key (1-5)
-- stays as it is. The two places outside those sections that had a key in plain brackets (Paladin "first (3)", Rogue
-- "Eviscerate (4) ... Rupture (5)") are written as **bold** keys since this day, in every language.
-- The short word per language (the texts' own long word in front of the first level, GEMETEN in the 8 files):
--------------------------------------------------------------------------------
local LVL_SHORT = { enUS = "lvl", enGB = "lvl", nlNL = "lvl", deDE = "Stufe", frFR = "niv.", esES = "niv.", esMX = "niv.",
	ptBR = "nív.", ruRU = "ур." }
local LVL_LONG = { enUS = "level", enGB = "level", nlNL = "level", deDE = "Stufe", frFR = "niveau", esES = "nivel",
	esMX = "nivel", ptBR = "nível", ruRU = "уровень" }

local function LevelMarks(text, keysInParens)
	if type(text) ~= "string" then
		return text
	end
	local loc = (ns.GetEffectiveLocaleCode and ns:GetEffectiveLocaleCode()) or "enUS"
	local short, long = LVL_SHORT[loc] or LVL_SHORT.enUS, LVL_LONG[loc] or LVL_LONG.enUS
	if long ~= short then
		text = text:gsub("%(" .. long .. " (%d)", function(d)
			return "(" .. short .. " " .. d
		end)
	end
	local function mark(n, tail)
		local v = tonumber(n)
		if not v or v < 1 or v > 60 or (keysInParens and KeyCode(n)) then
			return nil
		end
		return "(" .. short .. " " .. n .. tail
	end
	text = text:gsub("%((%d+)(%))", mark)
	-- "(10, from a quest)", and "(8 ; à partir du Rang 2 …)" / "(1; a partir do Grau 2 …)" in fr and pt
	text = text:gsub("%((%d+)(%s?[,;] )", mark)
	return text
end
ns.ForeverHowToLevelMarks = LevelMarks -- the offline check calls it

--- Sections whose plain brackets hold keys, by ENGLISH title.
local function KeySection(enTitle)
	return type(enTitle) == "string" and (enTitle:find("^Simple order") ~= nil or enTitle == "Beginner mistakes")
end

--------------------------------------------------------------------------------
-- 19 Nov 2026 (Rob's screenshot, mage level 9: "Enemy close to you? Frost Nova (V)" — "dat krijg ik pas als ik level 54
-- ben", via sparring). GEMETEN that day: Frost Nova rank 1 = level 10 (Forever DB2 SpellLevels 122 BaseLevel 10, and
-- MH's trainer data ForeverTrainerData.lua; rank 4 is level 54 — AFGELEID that the other addon showed the top rank).
-- The "Simple order" texts are fixed sentences and named spells you may not have yet. Now, for EVERY class (the role
-- texts already say "from N" themselves, see RoleBody):
-- the spells the English text names (matched against ns.FOREVER_SPELL_IDS) that this character does not know yet get
-- one grey line under the section, "Not learned yet: Frost Nova (level 10)", with the client's own spell name and the
-- first level from the trainer data. The translated texts keep the same sections in the same order, so the English
-- text of the same index is read.
--------------------------------------------------------------------------------
local function KnownAny(list)
	for _, id in ipairs(list or {}) do
		if IsPlayerSpell and select(2, pcall(IsPlayerSpell, id)) == true then
			return true
		end
		if IsSpellKnown and select(2, pcall(IsSpellKnown, id)) == true then
			return true
		end
	end
	return false
end

local function FirstLevel(token, name)
	local best
	for _, e in ipairs((ns.FOREVER_TRAINER_SPELLS or {})[token] or {}) do
		if e.n == name and (not best or e.l < best) then
			best = e.l
		end
	end
	return best
end

local notYetCache = {} -- englishText -> sorted list of names in it (the scan is the same every time)

--- 28 Nov 2026 (Fable check via Sparring 28-11): where `name` stands in `text` as a whole name, or nil. A plain find
--- let "Heal" (a Priest spell) match inside "Healing Touch" and "Lesser Heal", so a Druid could read "Not learned yet:
--- Heal". Now a letter right before or after does not count.
local function FindWord(text, name, init)
	local from = init or 1
	while true do
		local s, e = text:find(name, from, true)
		if not s then
			return nil
		end
		local before, after = text:sub(s - 1, s - 1), text:sub(e + 1, e + 1)
		if not before:find("%a") and not after:find("%a") then
			return s
		end
		from = s + 1
	end
end
ns.ForeverHowToFindWord = FindWord -- the offline check calls it

--- The grey "not learned yet" line for an English text, or nil when you know every spell it names.
local function NotYetLine(token, english)
	if type(english) ~= "string" or not ns.FOREVER_SPELL_IDS then
		return nil
	end
	local names = notYetCache[english]
	if not names then
		-- Every whole-name place of every name; then a shorter name that only stands INSIDE a longer one found here
		-- ("Heal" in "Lesser Heal", "Shield" in "Power Word: Shield") is dropped.
		local spots = {} -- { name, s, e }
		for name in pairs(ns.FOREVER_SPELL_IDS) do
			if #name >= 4 then
				local from = 1
				while true do
					local s = FindWord(english, name, from)
					if not s then
						break
					end
					spots[#spots + 1] = { name, s, s + #name - 1 }
					from = s + #name
				end
			end
		end
		local first = {}
		for _, a in ipairs(spots) do
			local inside = false
			for _, b in ipairs(spots) do
				if #b[1] > #a[1] and b[2] <= a[2] and b[3] >= a[3] then
					inside = true
					break
				end
			end
			if not inside and (not first[a[1]] or a[2] < first[a[1]]) then
				first[a[1]] = a[2]
			end
		end
		names = {}
		for name in pairs(first) do
			names[#names + 1] = name
		end
		-- The order they appear in the sentence.
		table.sort(names, function(a, b)
			return first[a] < first[b]
		end)
		notYetCache[english] = names
	end
	local out = {}
	for _, name in ipairs(names) do
		local list = ns.FOREVER_SPELL_IDS[name]
		if not KnownAny(list) then
			local shown = (C_Spell and C_Spell.GetSpellName and list[1] and C_Spell.GetSpellName(list[1])) or name
			local lv = FirstLevel(token, name)
			out[#out + 1] = lv and ns:L("FHOWTO_NOTYET_LV_FMT"):format(shown, lv) or shown
		end
	end
	if #out == 0 then
		return nil
	end
	return GREY_NOTE .. ns:L("FHOWTO_NOTYET_FMT"):format(table.concat(out, ", ")) .. "|r"
end

--- The English "Simple order" text of a class section, or nil for any other section.
local function OrderPart(title, body)
	if type(title) == "string" and title:find("^Simple order") then
		return body
	end
	return nil
end

--- A role body. The role texts already say "(from 18)" after every spell that comes later (written so on 16 Nov), so
--- they get no extra "not learned yet" line: it would only say the same twice. Kept as one place to change that.
local function RoleBody(token, list, r)
	return r.body
end

--- The whole text for one class, sections first, then the part every class shares.
local function TextFor(token)
	local parts = {}
	local tr = Translated()
	local cls = (tr and tr[token]) or CLASSES[token]
	if cls then
		for i, sec in ipairs(cls) do
			local en = CLASSES[token] and CLASSES[token][i]
			local note = en and NotYetLine(token, OrderPart(en[1], en[2]))
			local keys = en and KeySection(en[1])
			parts[#parts + 1] = HEAD .. sec[1] .. "|r\n" .. Format(LevelMarks(LiveKeys(token, sec[2], keys), keys))
				.. (note and ("\n" .. note) or "")
		end
		-- 17 Nov 2026 (Rob via Sparring 17-11: the Talented gap is a bug): the talent levels in the texts count the first
		-- point at 10. The Legacy perk Talented gives points up to 5 levels sooner; one line says so, with your rank if MH
		-- can read it (ns.ForeverTalentedRank, ForeverMacros.lua; AFGELEID until measured in the client).
		local r = ns.ForeverTalentedRank and ns.ForeverTalentedRank()
		parts[#parts + 1] = GREY_NOTE .. (type(r) == "number" and ns:L("FHOWTO_TALENTED_RANK_FMT"):format(r)
			or ns:L("FHOWTO_TALENTED_NOTE")) .. "|r"
	else
		parts[#parts + 1] = ns:L("FHOWTO_NOT_WRITTEN_FMT"):format(ClassName(token))
	end
	-- Per section, English when a language does not have it yet (21 Nov 2026: "Talents: reset and Dual Spec" is new).
	for i, en in ipairs(COMMON) do
		local sec = (tr and tr.COMMON and tr.COMMON[i]) or en
		parts[#parts + 1] = HEAD .. sec[1] .. "|r\n" .. Format(LiveKeys(token, sec[2]))
	end
	return table.concat(parts, "\n\n")
end
ns.ForeverHowToPlayText = TextFor

--- 25 Nov 2026: "Which weapon?" title + raw body, or nil (only the Druid so far; ns.ForeverWeaponAdvice).
local function WeaponAdvice()
	if not ns.ForeverWeaponAdvice then
		return nil
	end
	local ok, t, b = pcall(ns.ForeverWeaponAdvice)
	if ok and t then
		return t, b
	end
	return nil
end

--- 21 Nov 2026: the "level as X, tank as Y" block for this class in this client's language, or nil (classes that cannot
--- tank). Returns title, body (raw).
local function PlanFor(token)
	local tr = Translated()
	local p = (tr and tr.PLANS and tr.PLANS[token]) or PLANS[token]
	if not p then
		return nil
	end
	return p.title, p.body
end

--- 17 Nov 2026 (overview pages Camping and Legacy, ForeverOverview.lua): one shared section in this client's language,
--- by its English title ("Camping", "Legacy Points"). Returns title, body (raw: **bold** marks, "- " lines) or nil.
--- The translated COMMON tables have the same sections in the same order, so the index of the English title is used.
function ns.ForeverHowToCommon(englishTitle)
	local idx
	for i, sec in ipairs(COMMON) do
		if sec[1] == englishTitle then
			idx = i
		end
	end
	if not idx then
		return nil
	end
	local tr = Translated()
	local sec = (tr and tr.COMMON and tr.COMMON[idx]) or COMMON[idx]
	return sec[1], sec[2]
end

local win, shown
local showAllRoles = false

--- The role blocks for this class: yours in full, the rest folded (titles only) unless "Other roles" is open.
--- Returns the text (or nil when the class has no roles written) and whether there is anything folded.
local function RolesText(token)
	local tr = Translated()
	local list = (tr and tr.ROLES and tr.ROLES[token]) or ROLES[token]
	if not list or #list == 0 then
		return nil, false
	end
	local band = ns.GetForeverDirection and ns.GetForeverDirection()
	local mine, others = {}, {}
	for _, r in ipairs(list) do
		if band and r.band == band then
			mine[#mine + 1] = r
		else
			others[#others + 1] = r
		end
	end
	local parts = {}
	for _, r in ipairs(mine) do
		parts[#parts + 1] = HEAD .. r.title .. "|r\n" .. Format(LevelMarks(LiveKeys(token, RoleBody(token, list, r))))
	end
	if #others > 0 then
		if showAllRoles then
			for _, r in ipairs(others) do
				parts[#parts + 1] = HEAD .. r.title .. "|r\n" .. Format(LevelMarks(LiveKeys(token, RoleBody(token, list, r))))
			end
		else
			local names = {}
			for _, r in ipairs(others) do
				names[#names + 1] = r.title
			end
			parts[#parts + 1] = HEAD .. ns:L(#mine > 0 and "FHOWTO_ROLES_OTHER" or "FHOWTO_ROLES_ALL") .. "|r\n"
				.. ns:L("FHOWTO_ROLES_FOLDED_FMT"):format(table.concat(names, ", "))
		end
	end
	return table.concat(parts, "\n\n"), #others > 0
end

--- 17 Nov 2026 (the overview's How you play page, ForeverOverview.lua): the same content as this window, as separate
--- sections so the page can show headings and a table of contents. Class quests, Camping and Legacy Points are left
--- out: they have their own tabs there. Bodies are raw (**bold**, "- " lines, colour codes from the direction block).
--[[
	25 Nov 2026 — tabs (Rob via Sparring 25-11: "zo'n lange lap tekst. Kunnen we dat venster niet beter indelen? Met
	tabbladen van mijn part"; GO "Ja, je mag het zo sturen"). Start = your direction's role (intro, simple order,
	mistakes) and the class basics; Your keys; Weapon & stats; Group (tank plan, Dual Spec); Levels. The text itself is
	not changed, only divided. Class sections go by their ENGLISH title (the translations keep the same order).
]]
local TAB_INDEX = { start = 1, keys = 2, gear = 3, group = 4, levels = 5 }
local COMMON_TAB = { ["Before you start"] = "keys", ["Talents: reset and Dual Spec"] = "group" }

local function ClassTab(en)
	if type(en) ~= "string" then
		return "keys"
	end
	if en == "What it does" or en == "Beginner mistakes" or en:find("^Simple order") then
		return "start"
	end
	if en == "What comes later" then
		return "levels"
	end
	return "keys" -- "Levels 1-10: your buttons" and the class's own (Stances, Seals and auras, Your demon ...)
end

--- A role body cut at its bold sub-head lines ("**Simple order:**" ...): 1 = intro, 2 = order, 3 = per 10 levels,
--- 4 = mistakes. Every role in every language has those three (GEMETEN 25 Nov: 84 = 28 roles x 3 in each file).
local function RoleChunks(body)
	local chunks, cur = {}, {}
	for line in ((body or "") .. "\n"):gmatch("([^\n]*)\n") do
		if line:find("^%*%*[^*]+%*%*%s*$") and #cur > 0 then
			chunks[#chunks + 1] = table.concat(cur, "\n")
			cur = {}
		end
		cur[#cur + 1] = line
	end
	if #cur > 0 then
		chunks[#chunks + 1] = table.concat(cur, "\n")
	end
	return chunks
end

--[[
	26 Nov 2026 — "Your race: <race>" in the Start tab (Rob via Sparring: "misschien is dat een goed idee om dat uit te
	leggen. Niet alleen bij de Druid natuurlijk, maar bij alle Taurens … ook andere specs … als extra info vermelden bij
	de klas"; on the proposal: "ja , ik zag bv ook dat deze druid ook Cultivation heeft :)"). Only your own race, and under
	it only the lines for your own class. Facts: mh-research + an independent second check (Sparring, 25 Nov; DB2
	1.60.1.71091/71139, Wowhead Forever tooltips, Kaivax dev notes 2360696 24 Sep - 2 Nov, hotfix thread 2403040 to 23
	Nov); register: docs/forever/RAS_FEITEN.md. Every spell id GEMETEN in DB2 SpellName 71091 (26 Nov), race ids in
	ChrRaces (95 High Order Skyborne = Alliance, 96 Windshaper Skyborne = Horde). Spell names through <S:id> tokens, so
	every client says its own name. <S:EUREKA> = the Gnome's Eureka! of this class (a different id per class).
	"Charged" (Windshaper) has three ids with different German names (Geladen / Aufgeladen), so its line describes it
	instead of naming it.
]]
local RACE_INFO = {
	[1] = { base = { "FRACE_HUM_1", "FRACE_HUM_2", "FRACE_HUM_3", "FRACE_HUM_4" }, cls = {
		{ "FRACE_HUM_C_STUN", WARRIOR = true, ROGUE = true, HUNTER = true, PALADIN = true },
		{ "FRACE_HUM_C_SPIRIT", PRIEST = true, MAGE = true, WARLOCK = true, PALADIN = true },
		{ "FRACE_HUM_C_PERC", ROGUE = true, HUNTER = true } } },
	[3] = { base = { "FRACE_DWA_1", "FRACE_DWA_2", "FRACE_DWA_3", "FRACE_DWA_4" }, cls = {
		{ "FRACE_DWA_C_TANK", WARRIOR = true, PALADIN = true },
		{ "FRACE_DWA_C_ROG", ROGUE = true },
		{ "FRACE_DWA_C_HUN", HUNTER = true } } },
	[4] = { base = { "FRACE_NE_1", "FRACE_NE_2", "FRACE_NE_3", "FRACE_NE_4" }, cls = {
		{ "FRACE_NE_C_MELD", HUNTER = true, PRIEST = true },
		{ "FRACE_NE_C_ROG", ROGUE = true },
		{ "FRACE_NE_C_DRU", DRUID = true },
		{ "FRACE_NE_C_DRU2", DRUID = true } } },
	[7] = { base = { "FRACE_GNO_1", "FRACE_GNO_2", "FRACE_GNO_3", "FRACE_GNO_4" }, cls = {
		{ "FRACE_GNO_C_ROG", ROGUE = true },
		{ "FRACE_GNO_C_PRI", PRIEST = true },
		{ "FRACE_GNO_C_WLK", WARLOCK = true } } },
	[2] = { base = { "FRACE_ORC_1", "FRACE_ORC_2", "FRACE_ORC_3" }, cls = {
		{ "FRACE_ORC_C_CMD_HUN", HUNTER = true },
		{ "FRACE_ORC_C_CMD_WLK", WARLOCK = true },
		{ "FRACE_ORC_C_CURSE", WARRIOR = true, ROGUE = true, HUNTER = true, SHAMAN = true, WARLOCK = true } } },
	[5] = { base = { "FRACE_UND_1", "FRACE_UND_2", "FRACE_UND_3", "FRACE_UND_4", "FRACE_UND_5" }, cls = {
		{ "FRACE_UND_C_CAST", PRIEST = true, MAGE = true, WARLOCK = true } } },
	[6] = { base = { "FRACE_TAU_1", "FRACE_TAU_2", "FRACE_TAU_3", "FRACE_TAU_4" }, cls = {
		{ "FRACE_TAU_C_DRU", DRUID = true },
		{ "FRACE_TAU_C_HUN", HUNTER = true },
		{ "FRACE_TAU_C_SHA", SHAMAN = true } } },
	[8] = { base = { "FRACE_TRO_1", "FRACE_TRO_2", "FRACE_TRO_3", "FRACE_TRO_4", "FRACE_TRO_5" }, cls = {
		{ "FRACE_TRO_C_HUN", HUNTER = true } } },
	[95] = { base = { "FRACE_SKY_1", "FRACE_SKY_2", "FRACE_SKY_3", "FRACE_SKY_HO" } },
	[96] = { base = { "FRACE_SKY_1", "FRACE_SKY_2", "FRACE_SKY_3", "FRACE_SKY_WS" }, cls = {
		{ "FRACE_SKY_C_SHA", SHAMAN = true },
		{ "FRACE_SKY_C_DRU", DRUID = true },
		{ "FRACE_SKY_C_HUN", HUNTER = true } } },
}
-- 26 Nov 2026, Fable check (Sparring, DB2 71139 + Wowhead + dev notes; bouwchat measured what it could, RAS_FEITEN.md):
-- Rogue Eureka! 1259812 keeps Stealth (Attributes_1 0x20, like Vanish/Sprint) -> "Not in Stealth" gone; Skysight can be
-- cast while moving (SpellInterrupts 14), Read Leyline not (15); Purification Potion needs level 47; Ghost Wolf and
-- Travel Form +40%, Cheetah +30% (SpellEffect aura 31); Gnome Rage/Energy lines merged into GNO_3; Undead Paladin line out.
ns.FOREVER_RACE_INFO = RACE_INFO -- the offline check reads it
local EUREKA = { WARRIOR = 1259813, ROGUE = 1259812, MAGE = 1259817, WARLOCK = 1259821, PRIEST = 1259823 }

--- The "Your race" block for this character's race and the class `token`: title, raw body; or nil (race not written).
local function RaceSection(token)
	if not UnitRace then
		return nil
	end
	local ok, name, _, rid = pcall(UnitRace, "player")
	local r = ok and RACE_INFO[rid]
	if not r then
		return nil
	end
	local lines = { ns:L("FRACE_INTRO") }
	for _, k in ipairs(r.base) do
		lines[#lines + 1] = "- " .. ns:L(k)
	end
	local mine = {}
	for _, c in ipairs(r.cls or {}) do
		if c[token] then
			mine[#mine + 1] = "- " .. ns:L(c[1])
		end
	end
	if token == "PRIEST" then
		mine[#mine + 1] = "- " .. ns:L("FRACE_PRI_OWN")
	end
	if #mine > 0 then
		lines[#lines + 1] = "**" .. ns:L("FRACE_FORCLASS_FMT"):format(ClassName(token)) .. "**"
		for _, l in ipairs(mine) do
			lines[#lines + 1] = l
		end
	end
	local body = table.concat(lines, "\n"):gsub("<S:EUREKA>", "<S:" .. (EUREKA[token] or EUREKA.WARRIOR) .. ">")
	if ns.ForeverWeaponAdviceTokens then
		body = ns.ForeverWeaponAdviceTokens(body)
	end
	return ns:L("FRACE_TITLE_FMT"):format(name or "?"), LiveKeys(token, body)
end

--[[
	28 Nov 2026 — "Until level X" (Rob via Sparring 28-11, with his Hunter: "bij how to play er eigenlijk vanuit gegaan
	word dat je al level 10 bent en er niet verteld word wat je tot die tijd moet doen ... en kijken of dat bij andere
	classes dat ook zo is"; on the proposal: "ja voor untill level 10"). Below the level your role starts at, the top of
	Start shows the class's own "Levels 1-10: your buttons" and "Simple order" (texts written for level 1 on), with one
	line saying when your role starts. It goes away by itself at that level. The start level is the role's own "From
	level N" in its English text. Marksmanship and Survival say "From level 1", but their order needs Aspect of the Hawk
	and the pet (both level 10), so they count as 10. No direction chosen: the lowest start level of the class's roles
	(so a Warrior or a Druid without a direction gets no block: Arms and Balance start at 1).
]]
local ROLE_FROM_OVERRIDE = { HUNTER = { [2] = 10, [3] = 10 } }

-- 28 Nov 2026: spells of a class's Simple order that are no step of the row in the living block (English names).
-- auto = starts by itself when you press one of `by` (Hunter: GEMETEN by Rob in the game, 28 Nov); close = only for an
-- enemy up close, melee = needs a melee weapon (Hunter: DB2 71139 SpellEquippedItems, see the 28 Nov melee check).
-- heal = the "Low on health?" spells of that class's Simple order (28 Nov, Rob: "en ja voor low on health").
local ORDER_EXTRA = {
	HUNTER = { auto = "Auto Shot", by = { "Serpent Sting", "Arcane Shot" }, close = "Raptor Strike", melee = true },
	MAGE = { close = "Frost Nova", wand = "Shoot" },
	PRIEST = { heal = { "Renew", "Lesser Heal" }, wand = "Shoot" },
	PALADIN = { heal = { "Holy Light" } },
	DRUID = { heal = { "Rejuvenation", "Healing Touch" } },
	SHAMAN = { heal = { "Healing Wave" } },
	-- The Warlock's Shoot is not on the block (its own Beginner mistakes say so), so its wand line never shows: no guess.
	WARLOCK = { heal = { "Drain Life" }, wand = "Shoot" },
}

--- The spell names (English, as in ns.FOREVER_SPELL_IDS) an English text names, in the order it names them (the same
--- whole-name rules as the grey "Not learned yet" line).
local function SpellsIn(token, english)
	if type(english) ~= "string" then
		return {}
	end
	if not notYetCache[english] then
		NotYetLine(token, english)
	end
	return notYetCache[english] or {}
end

local ID2EN
local function EnglishOf(id)
	if not ID2EN then
		ID2EN = {}
		for en, ids in pairs(ns.FOREVER_SPELL_IDS or {}) do
			for _, i in ipairs(ids) do
				ID2EN[i] = ID2EN[i] or en
			end
		end
	end
	return ID2EN[id]
end

--- The block keys in the order a player reads them: no modifier, Shift, Ctrl, Alt; then 1-0, Q E R F T G Z X C V, F1-F4.
local KEY_ORDER = {}
for i, k in ipairs({ "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "Q", "E", "R", "F", "T", "G", "Z", "X", "C", "V",
	"F1", "F2", "F3", "F4" }) do
	KEY_ORDER[k] = i
end
local MOD_ORDER = { [""] = 0, SHIFT = 1, CTRL = 2, ALT = 3 }
local function KeySortValue(code)
	local m, k = code:match("^(%u+)%-(.+)$")
	if not m then
		m, k = "", code
	end
	return (MOD_ORDER[m] or 4) * 100 + (KEY_ORDER[k] or 99)
end

--- What MH's key block does right now for this character: { list = { { code, label, name, en } ... } in key order,
--- byEn = { [english] = entry } }, or nil when the block has no table for this class.
local function LiveNow(token)
	local cls = ns.ForeverBlockClassTable and select(2, pcall(ns.ForeverBlockClassTable))
	if type(cls) ~= "table" or not cls.keys or not ns.ForeverMacroBody then
		return nil
	end
	local out = { list = {}, byEn = {} }
	for code, def in pairs(cls.keys) do
		if not def.cmd then -- the pet's Attack/Follow/Stay keys are commands, not spells
			local ok, body, _, show = pcall(ns.ForeverMacroBody, code)
			if ok and body and show then
				local en = EnglishOf(show)
				local name = (C_Spell and C_Spell.GetSpellName and C_Spell.GetSpellName(show)) or en
				if name then
					local e = { code = code, label = KeyText(code), name = name, en = en }
					out.list[#out.list + 1] = e
					if en and not out.byEn[en] then
						out.byEn[en] = e
					end
				end
			end
		end
	end
	table.sort(out.list, function(a, b)
		return KeySortValue(a.code) < KeySortValue(b.code)
	end)
	return out
end

--- "Next: at level X you get <spell> (key Y)." — the next NEW trainer spells (no higher ranks of a spell you have),
--- from the trainer data and its own rules (race, faction, talent: ns.ForeverTrainerCompute). nil when none is known.
local function LiveNext(token, lvl, now)
	if not ns.ForeverTrainerCompute then
		return nil
	end
	local cls = ns.ForeverBlockClassTable and select(2, pcall(ns.ForeverBlockClassTable))
	local keyOf = {}
	if type(cls) == "table" and cls.keys and ns.ForeverBlockKeyNames then
		for code, def in pairs(cls.keys) do
			if not def.cmd then
				for i, n in ipairs((ns.ForeverBlockKeyNames({ [code] = def }))) do
					-- the first name of a key's list is its real place; a fallback place only when nothing better
					if not keyOf[n] or (i == 1 and not keyOf[n].first) then
						keyOf[n] = { code = code, first = i == 1 }
					end
				end
			end
		end
	end
	local at = lvl
	for _ = 1, 6 do
		local ok, out = pcall(ns.ForeverTrainerCompute, at)
		if not ok or type(out) ~= "table" or not out.nextLevel then
			return nil
		end
		local items = {}
		for _, e in ipairs(out.next or {}) do
			local newSpell = not (e.req and #e.req > 0) and not KnownAny({ e.id })
				and not (now and now.byEn[e.n])
			if newSpell and #items < 3 then
				local name = (C_Spell and C_Spell.GetSpellName and C_Spell.GetSpellName(e.id)) or e.n
				local k = keyOf[e.n]
				items[#items + 1] = k and ns:L("FHOWTO_EARLY_NEXT_KEY_FMT"):format(name, KeyText(k.code)) or name
			end
		end
		if #items > 0 then
			return "**" .. ns:L("FHOWTO_EARLY_NEXT_HEAD") .. "** "
				.. ns:L("FHOWTO_EARLY_NEXT_FMT"):format(out.nextLevel, table.concat(items, ", "))
		end
		at = out.nextLevel
	end
	return nil
end

local function RoleFrom(token, i)
	local o = ROLE_FROM_OVERRIDE[token]
	if o and o[i] then
		return o[i]
	end
	local en = ROLES[token] and ROLES[token][i]
	return (en and tonumber((en.body or ""):match("[Ff]rom level (%d+)"))) or 1
end
ns.ForeverHowToRoleFrom = RoleFrom -- the offline check reads it

--- Title and raw body of the "Until level X" block, or nil (at or above the start level, or nothing to show).
local function EarlyBlock(token)
	local lvl = UnitLevel and UnitLevel("player")
	if type(lvl) ~= "number" or lvl < 1 then
		return nil
	end
	local tr = Translated()
	local list = (tr and tr.ROLES and tr.ROLES[token]) or ROLES[token]
	local cls, en = (tr and tr[token]) or CLASSES[token], CLASSES[token]
	if not (list and #list > 0 and cls and en) then
		return nil
	end
	local band = ns.GetForeverDirection and ns.GetForeverDirection()
	local from, name
	for i, r in ipairs(list) do
		if not band or r.band == band then
			local f = RoleFrom(token, i)
			if not from or f < from then
				from, name = f, r.title
			end
		end
	end
	-- 28 Nov 2026 (Rob's Undead Priest, Holy, level 6, via Sparring 28-11: "Oh, ik dacht dat we inmiddels bij iedereen tot
	-- en met 10 hadden, maar blijkbaar nog niet." → "ja"): EVERY character under 10 gets the block, every class and
	-- direction, also without one; a role that starts later than 10 (Cat 20, Fury 20) keeps it until that level. The
	-- "your role starts at level X" line only where that is true (the role is not playable yet).
	from = from or 1
	local untilLv = math.max(from, 10)
	if lvl >= untilLv then
		return nil
	end
	local parts = {}
	if from > lvl then
		parts[1] = band and name and ns:L("FHOWTO_EARLY_ROLE_FMT"):format(name, from)
			or ns:L("FHOWTO_EARLY_CLASS_FMT"):format(from)
	else
		parts[1] = ns:L("FHOWTO_EARLY_BASICS")
	end
	-- 28 Nov 2026, the LIVING block (Rob via Sparring 28-11: "level 1, je kan dit drukken, level 2, je kan dat drukken";
	-- on the advice to make it live instead of a list per level: "Ja, dat is een goed idee van jou."). Three parts, all
	-- read from what this character has right now, so it grows with every level and never shows empty lines:
	--   Now (level N): the keys of MH's block that do something now, with the spell they cast (the block's own macro body).
	--   Order now: the spells of the class's Simple order that you already know, in that order, each with its key.
	--   Next: the next NEW trainer spell (not a higher rank), with the key the block puts it on.
	local now = LiveNow(token)
	if now and #now.list > 0 then
		local items = {}
		for _, k in ipairs(now.list) do
			items[#items + 1] = "**" .. k.label .. "** = " .. k.name
		end
		parts[#parts + 1] = "**" .. ns:L("FHOWTO_EARLY_NOW_FMT"):format(lvl) .. "** " .. table.concat(items, " · ")
		-- 28 Nov 2026 (Rob's screenshot of the block, via Sparring 28-11; "Ja, dat mag."): a spell that is no real STEP
		-- leaves the row and gets its own short line: Auto Shot (Serpent Sting and Arcane Shot start it, Rob measured)
		-- and the up-close emergency (Raptor Strike, with a melee weapon; the Mage's Frost Nova).
		local extra = ORDER_EXTRA[token] or {}
		local skip = {}
		if extra.auto then
			skip[extra.auto] = true
		end
		if extra.close then
			skip[extra.close] = true
		end
		for _, h in ipairs(extra.heal or {}) do
			skip[h] = true
		end
		if extra.wand then
			skip[extra.wand] = true
		end
		local seq = {}
		for _, sec in ipairs(en) do
			if OrderPart(sec[1], sec[2]) then
				for _, enName in ipairs(SpellsIn(token, sec[2])) do
					local k = now.byEn[enName]
					if k and not skip[enName] then
						seq[#seq + 1] = k.name .. " (**" .. k.label .. "**)"
					end
				end
			end
		end
		if #seq > 0 then
			parts[#parts + 1] = "**" .. ns:L("FHOWTO_EARLY_ORDER") .. "** " .. table.concat(seq, " → ")
		end
		local auto = extra.auto and now.byEn[extra.auto]
		if auto then
			local by = {}
			for _, s in ipairs(extra.by or {}) do
				local k = now.byEn[s]
				if k then
					by[#by + 1] = "**" .. k.label .. "**"
				end
			end
			if #by > 0 then
				parts[#parts + 1] = ns:L("FHOWTO_EARLY_AUTO_FMT"):format(auto.name, table.concat(by, ", "),
					"**" .. auto.label .. "**")
			end
		end
		local close = extra.close and now.byEn[extra.close]
		if close then
			parts[#parts + 1] = ns:L(extra.melee and "FHOWTO_EARLY_MELEE_FMT" or "FHOWTO_EARLY_NEAR_FMT")
				:format(close.name, "**" .. close.label .. "**")
		end
		local heals = {}
		for _, h in ipairs(extra.heal or {}) do
			local k = now.byEn[h]
			if k then
				heals[#heals + 1] = k.name .. " (**" .. k.label .. "**)"
			end
		end
		if #heals > 0 then
			parts[#parts + 1] = ns:L("FHOWTO_EARLY_HEAL_FMT"):format(table.concat(heals, ns:L("FHOWTO_EARLY_OR")))
		end
		-- 28 Nov 2026 (Rob: "ja"): the wand, only when a key of the block casts Shoot right now.
		local wand = extra.wand and now.byEn[extra.wand]
		if wand then
			parts[#parts + 1] = ns:L("FHOWTO_EARLY_WAND_FMT"):format(wand.name, "**" .. wand.label .. "**")
		end
		local nxt = LiveNext(token, lvl, now)
		if nxt then
			parts[#parts + 1] = nxt
		end
	else
		-- Nothing readable yet (a login moment, or no block table): the class's own Simple order, as before.
		for i, sec in ipairs(cls) do
			if en[i] and OrderPart(en[i][1], en[i][2]) then
				parts[#parts + 1] = "**" .. sec[1] .. "**\n" .. LevelMarks(LiveKeys(token, sec[2], true), true)
			end
		end
	end
	return ns:L("FHOWTO_EARLY_TITLE_FMT"):format(untilLv), table.concat(parts, "\n")
end
ns.ForeverHowToEarlyBlock = EarlyBlock -- the offline check calls it

--- 25 Nov 2026: every section also has `tab` (see FOREVER_HOWTO_TABS below). Role texts come in two parts: "start"
--- (intro, simple order, beginner mistakes) and "levels" (per 10 levels), cut at their bold sub-heads.
--- @return list of { title, body, kind = "dir"|"role"|"folded"|"class"|"note"|"common"|"stats", tab }, hasFolded, hasMine
function ns.ForeverHowToSections(token, allRoles)
	local out = {}
	local block = ns.ForeverDirectionBlock and ns.ForeverDirectionBlock()
	if block then
		local first, rest = block:match("^([^\n]*)\n?(.*)$")
		out[#out + 1] = { title = (first:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")), body = rest, kind = "dir", tab = "gear" }
	end
	-- 25 Nov 2026: "Which weapon?" (ForeverWeapons.lua), in every language through the locale keys.
	local wt, wb = WeaponAdvice()
	if wt then
		out[#out + 1] = { title = wt, body = wb, kind = "weapon", tab = "gear" }
	end
	-- 25 Nov 2026 (tabs): which stats count, the same sentences as "Do this now" (ForeverDoNow.lua).
	if ns.ForeverStatLines then
		local ok, lines = pcall(ns.ForeverStatLines)
		if ok and type(lines) == "table" and #lines > 0 then
			out[#out + 1] = { title = ns:L("FHOWTO_STATS_HEAD"), body = "- " .. table.concat(lines, "\n- "), kind = "stats",
				tab = "gear" }
		end
	end
	local planTitle, planBody = PlanFor(token)
	if planTitle then
		out[#out + 1] = { title = planTitle, body = LevelMarks(LiveKeys(token, planBody)), kind = "plan", tab = "group" }
	end
	-- 28 Nov 2026: "Until level X", first in Start, only below your role's start level.
	local okE, et, eb = pcall(EarlyBlock, token)
	if okE and et then
		out[#out + 1] = { title = et, body = eb, kind = "early", tab = "start" }
	end
	local function AddRole(r, list)
		local chunks = RoleChunks(RoleBody(token, list, r))
		if #chunks == 4 then
			out[#out + 1] = { title = r.title, body = LevelMarks(LiveKeys(token, chunks[1] .. "\n" .. chunks[2] .. "\n" .. chunks[4])),
				kind = "role", tab = "start" }
			out[#out + 1] = { title = r.title, body = LevelMarks(LiveKeys(token, chunks[3])), kind = "role", tab = "levels" }
		else -- not the usual three sub-heads: keep it whole (/mh howtotabs reports it)
			out[#out + 1] = { title = r.title, body = LevelMarks(LiveKeys(token, RoleBody(token, list, r))), kind = "role", tab = "start",
				uncut = #chunks }
		end
	end
	local tr = Translated()
	local list = (tr and tr.ROLES and tr.ROLES[token]) or ROLES[token] or {}
	local band = ns.GetForeverDirection and ns.GetForeverDirection()
	local mine, others = {}, {}
	for _, r in ipairs(list) do
		if band and r.band == band then
			mine[#mine + 1] = r
		else
			others[#others + 1] = r
		end
	end
	for _, r in ipairs(mine) do
		AddRole(r, list)
	end
	if #others > 0 then
		if allRoles then
			for _, r in ipairs(others) do
				AddRole(r, list)
			end
		else
			local names = {}
			for _, r in ipairs(others) do
				names[#names + 1] = r.title
			end
			out[#out + 1] = { title = ns:L(#mine > 0 and "FHOWTO_ROLES_OTHER" or "FHOWTO_ROLES_ALL"),
				body = ns:L("FHOWTO_ROLES_FOLDED_FMT"):format(table.concat(names, ", ")), kind = "folded", tab = "start" }
		end
	end
	local cls = (tr and tr[token]) or CLASSES[token]
	if cls then
		for i, sec in ipairs(cls) do
			local en = CLASSES[token] and CLASSES[token][i]
			local note = en and NotYetLine(token, OrderPart(en[1], en[2]))
			local keys = en and KeySection(en[1])
			out[#out + 1] = { title = sec[1], body = LevelMarks(LiveKeys(token, sec[2], keys), keys) .. (note and ("\n" .. note) or ""),
				kind = "class", tab = ClassTab(en and en[1]) }
		end
		local r = ns.ForeverTalentedRank and ns.ForeverTalentedRank()
		out[#out + 1] = { body = type(r) == "number" and ns:L("FHOWTO_TALENTED_RANK_FMT"):format(r)
			or ns:L("FHOWTO_TALENTED_NOTE"), kind = "note", tab = "levels" }
	else
		out[#out + 1] = { title = ClassName(token), body = ns:L("FHOWTO_NOT_WRITTEN_FMT"):format(ClassName(token)), kind = "class",
			tab = "start" }
	end
	-- 26 Nov 2026: your race, at the end of Start (after the class basics).
	local okR, rt, rb = pcall(RaceSection, token)
	if okR and rt then
		out[#out + 1] = { title = rt, body = rb, kind = "race", tab = "start" }
	end
	for i, enSec in ipairs(COMMON) do
		local sec = (tr and tr.COMMON and tr.COMMON[i]) or enSec
		local en = enSec[1]
		if en ~= "Camping" and en ~= "Legacy Points" then
			out[#out + 1] = { title = sec[1], body = LiveKeys(token, sec[2]), kind = "common", tab = COMMON_TAB[en] or "keys" }
		end
	end
	-- Fixed order inside every tab: the order of HOWTO_ORDER, then the order above (stable).
	for i, s in ipairs(out) do
		s.n = i
	end
	table.sort(out, function(a, b)
		local ta, tb = TAB_INDEX[a.tab] or 9, TAB_INDEX[b.tab] or 9
		if ta ~= tb then
			return ta < tb
		end
		return a.n < b.n
	end)
	return out, #others > 0, #mine > 0
end

--- 25 Nov 2026: the tabs of the How you play page, in order, with their label keys.
ns.FOREVER_HOWTO_TABS = {
	{ id = "start", key = "FHOWTO_TAB_START" },
	{ id = "keys", key = "FHOWTO_TAB_KEYS" },
	{ id = "gear", key = "FHOWTO_TAB_GEAR" },
	{ id = "group", key = "FHOWTO_TAB_GROUP" },
	{ id = "levels", key = "FHOWTO_TAB_LEVELS" },
}

--- Non-empty lines of a text, colour codes and **marks** left out (for the /mh howtotabs count).
local function Lines(text)
	local n = 0
	for line in ((text or "") .. "\n"):gmatch("([^\n]*)\n") do
		if line:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", ""):find("%S") then
			n = n + 1
		end
	end
	return n
end

--- /mh howtotabs [all]: for every class (or only yours), which block lands in which tab, and the line count of the
--- old text (all sections whole) against the tabs. Nothing may go missing: "before" must equal "after".
function ns.ForeverHowToTabsReport(onlyMine)
	local _, mine = UnitClass("player")
	local tokens = onlyMine and { mine } or { "WARRIOR", "PALADIN", "HUNTER", "ROGUE", "PRIEST", "SHAMAN", "MAGE", "WARLOCK", "DRUID" }
	local out, bad = {}, 0
	for _, token in ipairs(tokens) do
		local secs = ns.ForeverHowToSections(token, true)
		-- Before: the same content uncut (every role body whole, as the page showed it until today).
		local before = 0
		local tr = Translated()
		local list = (tr and tr.ROLES and tr.ROLES[token]) or ROLES[token] or {}
		for _, r in ipairs(list) do
			before = before + Lines(r.body)
		end
		local after, roleLines, perTab, uncut = 0, 0, {}, 0
		local seen, dupes = {}, {}
		for _, s in ipairs(secs) do
			local n = Lines(s.body)
			after = after + n
			if s.kind == "role" then
				roleLines = roleLines + n
			end
			-- The same long line in two blocks = a double (reported, not removed: the text is not ours to cut here).
			for line in ((s.body or "") .. "\n"):gmatch("([^\n]*)\n") do
				local key = line:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", ""):gsub("^%s*%-?%s*", "")
				if #key >= 30 then
					-- two different roles may share a line ("60: stronger ranks again"): you only see your own. The
					-- "Until level X" block repeats two class sections on purpose (28 Nov 2026), so it does not count.
					if seen[key] and seen[key] ~= s and not (seen[key].kind == "role" and s.kind == "role")
						and s.kind ~= "early" and seen[key].kind ~= "early" then
						dupes[#dupes + 1] = key:sub(1, 50)
					end
					seen[key] = seen[key] or s
				end
			end
			if s.uncut then
				uncut = uncut + 1
			end
			local t = perTab[s.tab] or {}
			t[#t + 1] = (s.title or "(note)") .. " " .. n
			perTab[s.tab] = t
		end
		local ok = roleLines == before and uncut == 0
		if not ok then
			bad = bad + 1
		end
		out[#out + 1] = ("%s: %s, role lines %d/%d, total %d lines, %d double%s"):format(token, ok and "OK" or "MISMATCH",
			roleLines, before, after, #dupes, uncut > 0 and (", " .. uncut .. " role(s) not cut") or "")
		for _, d in ipairs(dupes) do
			out[#out + 1] = "  double: " .. d
		end
		for _, tab in ipairs(ns.FOREVER_HOWTO_TABS) do
			if perTab[tab.id] then
				out[#out + 1] = "  " .. ns:L(tab.key) .. ": " .. table.concat(perTab[tab.id], " · ")
			end
		end
	end
	return out, bad
end
ns.ForeverClassName = ClassName

local function RefreshDirection()
	if not (win and win.dir) then
		return
	end
	local band, name = nil, nil
	if ns.GetForeverDirection then
		band, name = ns.GetForeverDirection()
	end
	win.dir:SetText(band and ns:L("FDIR_HOWTO_BTN_FMT"):format(name) or ns:L("FDIR_HOWTO_BTN_NONE"))
	win.dir:SetShown(ns.ShowForeverDirection ~= nil)
end

--- The class text, with the block for your chosen direction on top (12 Nov 2026, ForeverDirection.lua; Rob via sparring:
--- "1 en 2"). No direction chosen = no block, the window as before.
local function Body(token)
	local block = ns.ForeverDirectionBlock and ns.ForeverDirectionBlock()
	-- 16 Nov 2026: your class quests and where you stand in each (ForeverClassQuests.lua), under the direction block.
	local cq
	if ns.ForeverClassQuestOverview then
		local ok, text = pcall(ns.ForeverClassQuestOverview)
		if ok and text then
			cq = HEAD .. ns:L("FCQ_HOWTO_HEAD") .. "|r\n" .. Format(text)
		end
	end
	local roles, folded = RolesText(token)
	-- 28 Nov 2026: "Until level X" above the roles, only below your role's start level (EarlyBlock).
	local okE, et, eb = pcall(EarlyBlock, token)
	if okE and et then
		roles = HEAD .. et .. "|r\n" .. Format(eb) .. (roles and ("\n\n" .. roles) or "")
	end
	if win and win.roles then
		win.roles:SetShown(folded)
		local hasDir = ns.GetForeverDirection and ns.GetForeverDirection()
		win.roles:SetText(ns:L(not showAllRoles and "FHOWTO_ROLES_SHOW" or (hasDir and "FHOWTO_ROLES_HIDE" or "FHOWTO_ROLES_FOLD")))
	end
	local planTitle, planBody = PlanFor(token)
	local plan = planTitle and (HEAD .. planTitle .. "|r\n" .. Format(LevelMarks(LiveKeys(token, planBody)))) or nil
	local wt, wb = WeaponAdvice()
	if wt then
		plan = (plan and (plan .. "\n\n") or "") .. HEAD .. wt .. "|r\n" .. Format(wb)
	end
	return (block and (block .. "\n\n") or "") .. (plan and (plan .. "\n\n") or "") .. (roles and (roles .. "\n\n") or "")
		.. (cq and (cq .. "\n\n") or "") .. TextFor(token)
end

local function Show(token)
	shown = token
	RefreshDirection()
	win.title:SetText(ns:L("PLAYCARD_HEAD_FMT"):format(ClassName(token)))
	win.body:SetText(Body(token))
	win.child:SetHeight(win.body:GetStringHeight() + 20)
	win.scroll:SetVerticalScroll(0)
end

--- After a new direction: the button and, when the window is open, the block.
ns.ForeverHowToPlayRefreshDirection = function()
	RefreshDirection()
	if ns.ForeverOverviewRefresh then
		ns.ForeverOverviewRefresh()
	end
	if win and win:IsShown() and shown then
		win.body:SetText(Body(shown))
		win.child:SetHeight(win.body:GetStringHeight() + 20)
	end
end

local function Build()
	if win then
		return win
	end
	local f = CreateFrame("Frame", "MidnightHelperForeverHowToPlay", UIParent, "BackdropTemplate")
	f:SetSize(620, 560)
	f:SetPoint("CENTER")
	f:SetFrameStrata("DIALOG")
	f:SetBackdrop({
		bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
		edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Border",
		tile = true, tileSize = 32, edgeSize = 32,
		insets = { left = 11, right = 12, top = 12, bottom = 11 },
	})
	f:SetBackdropColor(0.05, 0.05, 0.08, 0.97)
	f:EnableMouse(true)
	f:RegisterForDrag("LeftButton")
	f:SetScript("OnDragStart", f.StartMoving)
	f:SetScript("OnDragStop", f.StopMovingOrSizing)

	f.title = f:CreateFontString(nil, "OVERLAY", "GameFontNormalHuge")
	f.title:SetPoint("TOPLEFT", 22, -18)

	local close = CreateFrame("Button", nil, f, "UIPanelCloseButton")
	close:SetPoint("TOPRIGHT", -6, -6)

	-- 12 Nov 2026: your chosen direction (ForeverDirection.lua), and the way back to the question.
	local dir = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
	dir:SetSize(200, 22)
	dir:SetPoint("TOPRIGHT", -36, -18)
	dir:SetScript("OnClick", function()
		if ns.ShowForeverDirection then
			ns.ShowForeverDirection()
		end
	end)
	f.dir = dir

	-- 16 Nov 2026: unfold / fold the roles that are not your direction's (shown only when there are any).
	local roles = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
	roles:SetSize(110, 22)
	roles:SetPoint("RIGHT", dir, "LEFT", -6, 0)
	roles:SetScript("OnClick", function()
		showAllRoles = not showAllRoles
		if shown then
			f.body:SetText(Body(shown))
			f.child:SetHeight(f.body:GetStringHeight() + 20)
		end
	end)
	roles:Hide()
	f.roles = roles

	-- Only this character's class (Rob, 6 Nov 2026: "ik wil ze per character zien, dus alleen voor de geldige class").
	-- The first version had a button per written class; they are gone.

	local scroll = CreateFrame("ScrollFrame", nil, f, "UIPanelScrollFrameTemplate")
	scroll:SetPoint("TOPLEFT", 22, -54)
	scroll:SetPoint("BOTTOMRIGHT", -38, 20)
	local child = CreateFrame("Frame", nil, scroll)
	child:SetSize(550, 10)
	scroll:SetScrollChild(child)
	local body = child:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	body:SetPoint("TOPLEFT", 4, -4)
	body:SetWidth(540)
	body:SetJustifyH("LEFT")
	body:SetSpacing(3)
	f.scroll, f.child, f.body = scroll, child, body

	if ns.RegisterMidnightDialogPopup then
		ns.RegisterMidnightDialogPopup(f)
	else
		tinsert(UISpecialFrames, f:GetName())
	end
	if ns.ForeverStyle and ns.ForeverStyle.SkinPanel then -- style A, opaque (Rob, 22 Nov 2026: "Doe maar vensters A")
		ns.ForeverStyle.SkinPanel(f, function()
			f.child:SetHeight(f.body:GetStringHeight() + 20)
		end)
	end
	f:Hide()
	win = f
	return f
end

--- Open on this character's class. (Retail passes a spec id; Forever has none, so it is ignored.)
--- 25 Nov 2026 (tabs): every way in (key block step 4, /mh play, the dashboards) opens the overview's How you play page,
--- which has the tabs; this old one-page window stays only as the fallback when the overview is not there.
function ns.ShowPlayCardWindow()
	if ns.ShowForeverOverviewPage then
		ns.ShowForeverOverviewPage("play")
		return
	end
	local f = Build()
	local _, token = UnitClass("player")
	Show(token or shown or "WARRIOR")
	f:Show()
end

function ns.TogglePlayCardWindow()
	if ns.ShowForeverOverviewPage then
		ns.ShowForeverOverviewPage("play", true)
		return
	end
	if win and win:IsShown() then
		win:Hide()
	else
		ns.ShowPlayCardWindow()
	end
end

-- 28 Nov 2026: the "Until level X" block goes away by itself at that level, also while the page is open. One second
-- later, because UnitLevel can still give the old level inside PLAYER_LEVEL_UP.
-- Since the living block (28 Nov) also on SPELLS_CHANGED: a new spell shows up in "Now" at once. It comes in bursts,
-- so one refresh a second after the first one.
local lvlEv = CreateFrame("Frame")
pcall(lvlEv.RegisterEvent, lvlEv, "PLAYER_LEVEL_UP")
pcall(lvlEv.RegisterEvent, lvlEv, "SPELLS_CHANGED")
local lvlQueued = false
lvlEv:SetScript("OnEvent", function()
	if lvlQueued then
		return
	end
	lvlQueued = true
	C_Timer.After(1, function()
		lvlQueued = false
		if ns.ForeverHowToPlayRefreshDirection then
			pcall(ns.ForeverHowToPlayRefreshDirection)
		end
	end)
end)
