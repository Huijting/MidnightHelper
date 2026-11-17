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
- **2** = Judgement (4): cooldown 10 seconds. It does not use up your seal. It only works while a seal is on: put your seal on first (3). Without one the game says "You can't do that yet".
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
- **1** = Fireball (level 1): your main attack spell.
- **Shift-Z** = Frost Armor (1): a buff on yourself. Put it on before a fight. You can only have one armor on.
- **Shift-X** = Arcane Intellect (1): a buff for you or a friend.
- **Ctrl-3** = Shoot: your **wand** (a small magic stick that shoots by itself), once you have one. Handy when your mana is low. When you learn Frostfire Bolt, that takes Ctrl-3; put Shoot on one of your own Alt keys if you still want it.
- **2** = Frostbolt (4): frost damage.
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
- Talents from level 20: Pyroblast on 4, Ice Lance on F, Arcane Blast on Ctrl-2, Ice Block on C (25 at the earliest).]] },
		{ "Beginner mistakes", [[
- Expecting both wards at once. Fire Ward (F4) and Frost Ward (F2) share one 30-second cooldown, so only one at a time.
- Wearing Mage Armor and Ice Armor together. Only one armor can be on at a time. Mage Armor (34) is on block D.]] },
	},
	HUNTER = {
		{ "What it does", [[
The Hunter shoots from a distance with a ranged weapon, and from level 10 has a **pet**: an animal you tame that fights next to you. Up close it has a few melee hits.
**Auto Shot** = your weapon keeps shooting by itself until you stop. **Melee** = fighting up close. The Hunter has no shapes and no stances, so every key always does the same thing.]] },
		{ "Levels 1-10: your buttons", [[
- **1** = Auto Shot (level 1): starts shooting. MH's key is made so a second press does not stop it.
- **5** = Raptor Strike (1): your hit when the enemy is next to you.
- **2** = Serpent Sting (4): damage over a few seconds.
- Aspect of the Monkey (4) goes on your own Alt keys (block D). An **aspect** is a stance-like buff on yourself. Only one aspect can be on at a time.
- **3** = Arcane Shot (6): instant shot. Cooldown 6 seconds.
- **Shift-Z** = Hunter's Mark (6): put it on the enemy once.
- **Shift-Q** = Concussive Shot (8): slows the enemy.
- **Shift-R** = Aspect of the Hawk (10): your main aspect.
- **Level 10, pet quests:** you learn Tame Beast, Call Pet and Dismiss Pet; the quest after them (Training the Beast) gives Revive Pet and Feed Pet. **F4** = Call Pet (brings your pet), **F3** = Revive Pet (brings a dead pet back). Tame Beast has no key; you use it outside a fight.
- From then on your pet has three keys: **Ctrl-1** = attack your target, **Ctrl-2** = follow you, **Ctrl-3** = stay where it is.]] },
		{ "Simple order", [[
Aspect of the Hawk on (Shift-R). Pet in first (Ctrl-1). Hunter's Mark (Shift-Z), Serpent Sting (2), Auto Shot (1), then Arcane Shot (3) when it is ready. Enemy next to you? Raptor Strike (5).]] },
		{ "What comes later", [[
- 10: Feed Pet and Dismiss Pet are not on the block (you use them outside a fight); put them on your own bar. The same for Scare Beast (14).
- 12: Distracting Shot on F (makes the enemy attack you), Mend Pet on F2 (heals your pet), Wing Clip on Shift-F.
- 16: Immolation Trap on Shift-2, Mongoose Bite on Shift-C (only after you dodge). 18: Multi-Shot on Shift-1.
- 20: Aimed Shot on 4 (your big shot), Aspect of the Cheetah on R (run fast), Disengage on Z, Freezing Trap on V.
- 26: Rapid Fire on Q. 30: Feign Death on X, Aspect of the Beast (block D). 34: Explosive Trap takes over Shift-2.
- All four traps share one 30-second cooldown.]] },
		{ "Beginner mistakes", [[
- Shooting at an enemy right next to you. Your gun or bow does not work within 8 yards (the "dead zone"): use Raptor Strike (5), or step back.
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
- **Level 10, Defensive Stance** (from a quest): **Ctrl-2** turns it on. The same quest gives **5** = Sunder Armor (every stance) and, in Defensive Stance, **F** = Taunt. **Taunt** = make the enemy attack you. Cooldown 8 seconds.
- Shoot Bow, Shoot Gun, Shoot Crossbow and Throw go on your own Alt keys (block D). You get the one that fits your ranged weapon. Use it to **pull**: hit one enemy from far away, so it comes to you.]] },
		{ "Simple order", [[
Battle Stance on (Ctrl-1), Battle Shout (Shift-X). Charge (R) in. Rend (Shift-Z), then Heroic Strike (1) again and again. Several enemies? Thunder Clap (Shift-1).]] },
		{ "What comes later", [[
- 12: Overpower on 2 (Battle Stance; after the enemy dodges), Shield Bash on E: your **interrupt** (it stops an enemy's spell).
- 14: Revenge on 2 (Defensive Stance), Demoralizing Shout on Shift-2. 16: Mocking Blow on F (Battle Stance), Shield Block on Z (Defensive Stance). 18: Disarm on V (Defensive Stance).
- 20: Cleave on Shift-4, Slam on Shift-C, Victory Rush on F2 (only in the 20 seconds after you kill an enemy that gives XP; it heals you a bit; cooldown 30 seconds), Retaliation on C (Battle Stance). 22: Intimidating Shout on Shift-Q. 24: Execute on 4 (Battle and Berserker Stance; only when the enemy is at 20% health or less).
- 26: Challenging Shout on Shift-F. 28: Shield Wall on C (Defensive Stance).
- 30: Berserker Stance on Ctrl-3. In it: Intercept on R, Berserker Rage on Shift-V. 36: Whirlwind on 2 (Berserker). 38: Pummel on E (Berserker). 50: Recklessness on Q (Berserker).
- Talents: Last Stand on X and Piercing Howl on Shift-R (an area slow), 20 at the earliest. Spearing Strike on F3 (Battle Stance) and Reckless Swings on Shift-F1, 25. Sweeping Strikes on Q (Battle Stance), Death Wish on Shift-3, Concussion Blow on Shift-V (a stun; in Berserker Stance this key is Berserker Rage instead), 30. Mortal Strike, Bloodthirst or Shield Slam on 3, 40.]] },
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
Hits like Sinister Strike give you **combo points** (up to 5). A **finisher** is a hit that uses all your combo points: Eviscerate (4), Slice and Dice (Shift-4) and Rupture (5). More points make it stronger.]] },
		{ "Levels 1-10: your buttons", [[
- **1** = Sinister Strike (level 1): your main hit.
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
- Talents: Riposte on Shift-F1 and Premeditation on Shift-C, 20 at the earliest. Cold Blood on F1 and Ghostly Strike on Shift-X, 25. Blade Flurry on Shift-1 (hits more enemies), Preparation on F3 (resets the cooldown of your other Rogue spells, like Evasion, Sprint and Vanish), Hemorrhage on 3, 30. Mutilate on 3, Adrenaline Rush or Death Mark on Q, 40.]] },
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
Shield (Z) on yourself. Shadow Word: Pain (2), Mind Blast (3), then Smite (1). Low on mana? Use your wand (5). Low on health? Renew (F4) or Lesser Heal (C).]] },
		{ "What comes later", [[
- 12: Inner Fire on Shift-Z. 14: Cure Disease on Shift-C, Psychic Scream on V (a few enemies around you run away in fear for up to 8 seconds; damage can end it; cooldown 30 seconds).
- 18: Dispel Magic on Shift-V. 20: Flash Heal on F2 (quick heal), Holy Fire on 4, Shackle Undead on Shift-Q, Devouring Plague on Shift-3, your race spell of level 20, Fear Ward (block D).
- 30: Prayer of Healing on Shift-2 (heals your group), Mind Control on Shift-F. 32: Shadow Word: Death on Shift-4, Abolish Disease takes over Shift-C. 34: Levitate on R (costs a Light Feather). 48: Prayer of Fortitude takes over Shift-X (costs a Holy Candle).
- Talents: Mind Flay (takes over key 1), Holy Nova on Shift-1 and Inner Focus on F1, 20 at the earliest. Vampiric Embrace on Ctrl-3, 25. Penance on Shift-F1 and Silence on E (your **interrupt**: it stops an enemy's spell), 30. Power Infusion on Q, Shadowform on Ctrl-1, Prayer of Mending on Ctrl-2, 40.]] },
		{ "Beginner mistakes", [[
- Healing in Shadowform. No healing spell works in Shadowform. Fear Ward and the Dwarf race spell (Chastise) do not work in it either. Leave it first: press Ctrl-1 again.
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
- Before level 20, your totems each have their own key: Stoneskin (Z), Earthbind (V), Stoneclaw (F), Strength of Earth (Shift-X), Searing (5), Tremor (Shift-F).
- From level 20 the game gives you a **totem bar**. On it you pick one totem per element. Then one key places them all: **Ctrl-1** = Call of the Elements (20), **Ctrl-2** = Call of the Ancestors (30), **Ctrl-3** = Call of the Spirits (40). Each one places up to 4 totems from its own page of the totem bar. It has a 3-second cast and costs the mana of all the totems it places.
- **Shift-R** = Totemic Call (22): moves your totems to you. Totemic Recall (20, block D) takes them back and gives you a quarter of their mana back.
A **weapon buff** puts power on your weapon for 60 minutes. You have one at a time. Rockbiter (1), Flametongue (10), Frostbrand (20) and Windfury (30) go on your own Alt keys (block D). Pick the one that fits how you play.]] },
		{ "Levels 1-10: your buttons", [[
- **1** = Lightning Bolt (level 1): your main attack spell.
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
- Talents: Water Shield (takes over Shift-Z), 20 at the earliest. Stormstrike on 3 and Mana Tide Totem on F1, 25. Nature's Swiftness on Shift-3, 30. Riptide on Shift-F1, and Lightning Mastery or Rage of the Farseer on Q, 40.]] },
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
5. Rage left over: Maul (**1**) on one enemy, Swipe (**Shift-1**, from 16) on two or more.
6. Growl (**F**) when an enemy hits someone else.
**Per 10 levels:**
- 10: Bear Form (**Ctrl-1**), Maul (**1**), Growl (**F**), Demoralizing Roar (**Shift-2**). Then Enrage (**Q**) at 12, Bash (**V**) at 14, Swipe (**Shift-1**) at 16, Faerie Fire (**5**) at 18.
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
5. At 4-5 combo points: Rip (**4**) if the enemy will live long, otherwise Ferocious Bite (**Shift-4**, from 24).
6. Shifting Power (**Q**, from 40) when your Energy is under 50.
**Per 10 levels:**
- 10: nothing new for this role (the cat comes at 20).
- 20: Cat Form (**Ctrl-2**), Claw (**1**), Shred (**3**, from behind), Rip (**4**), Prowl (**Shift-R**). Feral Charge (**E**, a talent): as a cat you leap behind the enemy. Omen of Clarity is passive: no key.
- 30: Leader of the Pack (a talent). Before that: Rake (**2**) and Ferocious Bite (**Shift-4**) at 24, Dash (**R**) at 26, Cower (**F**) at 28.
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
2. Arcane Blast (**Ctrl-2**, from 20): one or two, on a boss up to four. Each one makes the next cost more mana.
3. Missile Barrage (from 15) lights up? Arcane Missiles (**3**) right away: free and twice as fast.
4. Arcane Wrath (**Shift-F1**, from 25) whenever it is ready.
5. Enemy close to you? Frost Nova (**V**), step away.
6. Almost dead: your wand (**Ctrl-3**, until 40) or Fire Blast (**5**).
7. Tough enemy or boss: Presence of Mind (**Shift-3**, from 30), then Arcane Wrath for a big instant hit. From 40 also Arcane Power (**Q**).
Several enemies: Frost Nova (**V**), then Arcane Explosion (**Shift-2**, from 14). Low on mana? Evocation (**F1**, from 20).
**Per 10 levels:**
- 10: Frost Nova (**V**). First talent: Improved Channeling (Arcane Missiles is no longer cut short when you are hit). Then Arcane Explosion (**Shift-2**) at 14, Missile Barrage (a talent, passive) at 15. Talent levels here are the earliest; a perk can bring them up to 5 levels sooner.
- 20: Arcane Blast (**Ctrl-2**, a talent). Blink (**R**), Evocation (**F1**), Mana Shield (**Z**). Then Counterspell (**E**) at 24, Arcane Wrath (**Shift-F1**, a talent; you need Arcane Blast first) at 25.
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
4. Combo points: Backstab (**2**) when you stand behind the enemy, otherwise Sinister Strike (**1**). From 40: Mutilate (**3**), 2 points each time.
5. Shank (**Shift-3**, from 24) whenever it is ready. With Venom (from 30) each Shank makes your poison stronger for 6 seconds.
6. Finisher: Slice and Dice (**Shift-4**) in a long fight; otherwise Eviscerate (**4**) at 5 points. Rupture (**5**, from 20) on an enemy that will live long (an elite, a boss).
7. Cold Blood (**F1**, from 25) just before an Eviscerate with 5 points.
**Per 10 levels:**
- 10: you already have Sinister Strike (**1**), Eviscerate (**4**), Backstab (**2**), Stealth (**Shift-R**), Gouge (**Shift-Q**) and Evasion (**Z**). New at 10: Slice and Dice (**Shift-4**), Sprint (**R**), Sap (**Shift-Q** in Stealth), and a weapon in each hand (Dual Wield). Then Kick (**E**) at 12, Garrote (**1** in Stealth) and Expose Armor (**Shift-Z**) at 14, Feint (**F**) at 16, Ambush (**2** in Stealth) and Poised (passive) at 18.
- 20: Rupture (**5**). Poisons, from a quest. Then Vanish (**X**) at 22, Shank (**Shift-3**) at 24, Cold Blood (**F1**, a talent) at 25: your next Sinister Strike, Backstab, Ambush, Eviscerate or Mutilate is sure to crit (**crit** = a lucky, stronger hit); cooldown 3 minutes. Cheap Shot (**V** in Stealth) at 26. Talent levels here are the earliest; a perk can bring them up to 5 levels sooner.
- 30: Venom (a talent, passive: no key): each Shank gives your poison 30% more damage and 20% more chance to land, for 6 seconds. Kidney Shot (**V**). Then Blind (**Shift-V**) at 34, Seal Fate (a talent, passive) at 35: a crit with an attack that gives combo points gives you an extra point.
- 40: Mutilate (**3**, a talent; you need Venom first): 60 Energy, hits with both daggers, 2 combo points, 20% more damage on a poisoned enemy. Then Slice and Dice rank 2 at 42, Shank rank 2 at 44.
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
From level 1 (Sinister Strike and Stealth). This tree fights from Stealth: a strong first hit, and many combo points before the fight really starts. **Stealth** = sneak, so the enemy does not see you. The guides say levelling alone goes slower than with Combat. Hemorrhage is a talent, 30 at the earliest: cheap, from the front, with any weapon. Death Mark is a talent, 40 at the earliest. Ambush and Backstab need a dagger in your main hand; Hemorrhage and Ghostly Strike do not.
**Simple order:**
1. Stealth (**Shift-R**). A second Humanoid nearby? Sap (**Shift-Q**). Sap does not break Stealth.
2. Premeditation (**Shift-C**, from 20): 2 combo points on the enemy. Then your first hit.
3. First hit from behind: Ambush (**2**, from 18, dagger in your main hand). Strong enemy, from 26: Cheap Shot (**V**), a 4-second stun. The guides differ on the best opener.
4. Ghostly Strike (**Shift-X**, from 25) and Shank (**Shift-3**, from 24) whenever they are ready.
5. Combo points: from 30 Hemorrhage (**3**). Before that: Backstab (**2**) when you stand behind the enemy, otherwise Sinister Strike (**1**).
6. Finisher: Eviscerate (**4**) when the enemy is almost dead; Rupture (**5**) on an enemy that will live long; Slice and Dice (**Shift-4**) in a long fight.
7. From 40: Death Mark (**Q**) on the strongest enemy, best while Rupture or Garrote is running.
8. Emergency: Vanish (**X**). Preparation (**F3**, from 30) makes Vanish, Evasion and Sprint ready again right away.
**Per 10 levels:**
- 10: you already have Sinister Strike (**1**), Eviscerate (**4**), Backstab (**2**), Stealth (**Shift-R**), Gouge (**Shift-Q**) and Evasion (**Z**). New at 10: Sap (**Shift-Q** in Stealth), Slice and Dice (**Shift-4**), Sprint (**R**), and a weapon in each hand. Then Kick (**E**) at 12, Garrote (**1** in Stealth) at 14, Feint (**F**) at 16, Ambush (**2** in Stealth) and Poised (passive) at 18.
- 20: Premeditation (**Shift-C**, a talent): 2 combo points on your target; use them within 20 seconds, or they are gone; cooldown 2 minutes. Rupture (**5**), and Poisons from a quest. Then Vanish (**X**) at 22, Shank (**Shift-3**) at 24, Ghostly Strike (**Shift-X**, a talent) at 25: 40 Energy, 1 combo point, 15% more dodge for 7 seconds; cooldown 20 seconds. Cheap Shot (**V** in Stealth) at 26. Talent levels here are the earliest; a perk can bring them up to 5 levels sooner.
- 30: Hemorrhage (**3**, a talent; you need Serrated Blades first): 35 Energy, 1 combo point, works from the front; for 15 seconds your Rupture and Garrote do 15% more damage to that enemy. Preparation (**F3**, a talent): makes the cooldown of your other Rogue spells ready right away; its own cooldown is 10 minutes. You get one of these two at 30, the other at 31. Kidney Shot (**V**). Then Blind (**Shift-V**) at 34, Boot Knife (a talent, passive) at 35: Shank can give 2 combo points.
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
From level 10 (your pet, from the class quests). Your pet does most of the work: it keeps the enemy busy while you shoot from a distance. Every guide we read picks Beast Mastery for levelling: they call it the easiest and the fastest. New in Forever: Summon Hawk (a talent, 25 at the earliest) sends extra birds at your target. Weak spot: groups of enemies. Your pet can hold only one.
**Simple order:**
Before you start: Aspect of the Hawk on (**Shift-R**). The Deadly Aspects talent only works then.
1. Hunter's Mark (**Shift-Z**).
2. Pet in (**Ctrl-1**), and wait until it has the enemy.
3. Serpent Sting (**2**).
4. Summon Hawk (**Shift-F1**, from 25): keep 2 hawks up all the time.
5. Aimed Shot (**4**, from 20) while you stand still. Two or more enemies: Multi-Shot (**Shift-1**) instead. They share one cooldown.
6. Auto Shot (**1**) keeps going. Arcane Shot (**3**): before 25, just use it. From 25 only when you already have 2 hawks: it shares a cooldown with Summon Hawk.
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
1. Hunter's Mark (**Shift-Z**). With a pet: pet in (**Ctrl-1**).
2. Enemy still far away: Sniper Shot (**Shift-4**, from 40) to open.
3. Serpent Sting (**2**). Some guides skip it in short fights.
4. Aimed Shot (**4**, from 20) every time it is ready. Stand still.
5. Arcane Shot (**3**) in between, if your mana allows it.
6. Auto Shot (**1**) keeps going.
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
1. Hunter's Mark (**Shift-Z**). Without the Mark, Expose Prey does not work.
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
2. Stormstrike (**3**, from 25) whenever it is ready.
3. Lightning Bolt (**1**) at 5 stacks of Maelstrom Weapon (from 35): then it is instant and free.
4. Earth Shock (**E**). In a group, take turns with Flame Shock (**2**).
5. Fire Nova (**Shift-4**, from 12) when a Fire totem is down and you have mana to spare; mostly against more enemies.
6. Rage of the Farseer (**Q**, from 40) for an elite or a big pull.
7. Otherwise just keep hitting.
After the fight: Healing Wave (**C**). Emergency during a fight: Lesser Healing Wave (**F2**, from 20).
**Per 10 levels:**
- 10: Rockbiter Weapon (block D), Lightning Bolt (**1**), Earth Shock (**E**, from 4), Lightning Shield (**Shift-Z**, from 8). Flame Shock (**2**), Searing Totem (**5**), Strength of Earth Totem (**Shift-X**), Flametongue Weapon (block D). First talents: Thundering Strikes and others (passive); Mental Dexterity (passive) from 15. Talent levels here are the earliest; a perk can bring them up to 5 levels sooner. Then Fire Nova (**Shift-4**) at 12.
- 20: Ghost Wolf (**R**), Frost Shock (**4**), Lesser Healing Wave (**F2**), Call of the Elements (**Ctrl-1**). Shamanistic Focus (a talent, passive): Shocks and Lightning Shield cost 45% less mana. Then Stormstrike (**3**, a talent) at 25. Flurry (a talent, passive) from 25. Improved Ghost Wolf (a talent) from 25: Ghost Wolf is faster (instant with both points) and works indoors too; the guides take it at very different levels. Magma Totem (block D) at 26.
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
}
ns.FOREVER_HOWTOPLAY_ROLES = ROLES -- the offline check reads it

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

--- The whole text for one class, sections first, then the part every class shares.
local function TextFor(token)
	local parts = {}
	local tr = Translated()
	local cls = (tr and tr[token]) or CLASSES[token]
	if cls then
		for _, sec in ipairs(cls) do
			parts[#parts + 1] = HEAD .. sec[1] .. "|r\n" .. Format(sec[2])
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
	for _, sec in ipairs((tr and tr.COMMON) or COMMON) do
		parts[#parts + 1] = HEAD .. sec[1] .. "|r\n" .. Format(sec[2])
	end
	return table.concat(parts, "\n\n")
end
ns.ForeverHowToPlayText = TextFor

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
		parts[#parts + 1] = HEAD .. r.title .. "|r\n" .. Format(r.body)
	end
	if #others > 0 then
		if showAllRoles then
			for _, r in ipairs(others) do
				parts[#parts + 1] = HEAD .. r.title .. "|r\n" .. Format(r.body)
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
	if win and win.roles then
		win.roles:SetShown(folded)
		local hasDir = ns.GetForeverDirection and ns.GetForeverDirection()
		win.roles:SetText(ns:L(not showAllRoles and "FHOWTO_ROLES_SHOW" or (hasDir and "FHOWTO_ROLES_HIDE" or "FHOWTO_ROLES_FOLD")))
	end
	return (block and (block .. "\n\n") or "") .. (roles and (roles .. "\n\n") or "") .. (cq and (cq .. "\n\n") or "")
		.. TextFor(token)
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
	f:Hide()
	win = f
	return f
end

--- Open on this character's class. (Retail passes a spec id; Forever has none, so it is ignored.)
function ns.ShowPlayCardWindow()
	local f = Build()
	local _, token = UnitClass("player")
	Show(token or shown or "WARRIOR")
	f:Show()
end

function ns.TogglePlayCardWindow()
	if win and win:IsShown() then
		win:Hide()
	else
		ns.ShowPlayCardWindow()
	end
end
