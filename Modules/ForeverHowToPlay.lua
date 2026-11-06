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

	English only for now: Forever is in early test and this is a draft. The keys named here are the ones the
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
- 16: Aquatic Form on R while you swim. 18: Faerie Fire on 5 (works in every form), Hibernate on Shift-Q.
- 20: Cat Form (from a quest) on Ctrl-2, with Claw, Rip and Prowl. Starfire on 3. In a fight, F3 becomes Rebirth.
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
- **2** = Judgement (4): cooldown 10 seconds. It does not use up your seal.
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
- 12: Redemption on F3 (brings a dead friend back; not in a fight). 14: Blessing of Wisdom on Shift-V.
- 18: Blessing of Freedom on R (nothing can slow you for a while). 20: Consecration on Shift-1 (hits several enemies at once), Exorcism on 5, Flash of Light on F2 (quick heal), Blessing of Kings on Shift-X.
- 30: Divine Intervention: in a fight, F3 casts this one instead of Redemption. 34: Divine Shield on Z: 10 seconds where nothing can hurt you, and you can still fight (with half damage).
- 42: Cleanse replaces Purify on Shift-C. 44: Hammer of Wrath on 4 (only when the enemy is at 20% health or less).
- 52-60: in a group, the blessing keys cast the Greater Blessing for the whole group; solo they cast the normal one.]] },
		{ "Beginner mistakes", [[
- Pressing Exorcism (5) on a normal enemy. It only works on Undead and Demons. Turn Undead (Shift-Q, 24) works on Undead only.
- Pressing Hammer of Wrath (4) early in the fight. It only works when the enemy is almost dead (20% health or less).
- Divine Shield and Divine Protection share one cooldown, so they sit on one key (Z). These protection spells, and Blessing of Protection, give **Forbearance**: for 1 minute you cannot get any of them again. Lay on Hands does not.]] },
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
- 18: Remove Lesser Curse on Shift-V. 20: Blink on R (your movement spell), Blizzard on Shift-1, Evocation on F1 (gets mana back), Mana Shield on Z, Fire Ward on F4, and the teleports (block D).
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
- **Level 10, pet quests:** you learn Tame Beast, Call Pet and Revive Pet. **F4** = Call Pet (brings your pet), **F3** = Revive Pet (brings a dead pet back). Tame Beast has no key; you use it outside a fight.
- From then on your pet has three keys: **Ctrl-1** = attack your target, **Ctrl-2** = follow you, **Ctrl-3** = stay where it is.]] },
		{ "Simple order", [[
Aspect of the Hawk on (Shift-R). Pet in first (Ctrl-1). Hunter's Mark (Shift-Z), Serpent Sting (2), Auto Shot (1), then Arcane Shot (3) when it is ready. Enemy next to you? Raptor Strike (5).]] },
		{ "What comes later", [[
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
Every Priest race has two Priest spells of its own: one at level 10 and one at level 20. MH puts them on **X** and **Shift-R**, so every race uses the same two keys.
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
- Healing in Shadowform. No healing spell works in Shadowform. Fear Ward and the Dwarf and Gnome race spells (Chastise, Confounding Flash) do not work in it either. Leave it first: press Ctrl-1 again.
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
- 16: Unending Breath on Shift-R. 18: Create Soulstone (costs a Soul Shard) and Searing Pain (block D).
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

local GOLD, HEAD = "|cffffd100", "|cffffcc66"

--- "**word**" → gold. Everything else is plain text.
local function Format(body)
	return (body:gsub("%*%*(.-)%*%*", GOLD .. "%1|r"))
end

local function ClassName(token)
	local names = LOCALIZED_CLASS_NAMES_MALE
	return (names and names[token]) or (token:sub(1, 1) .. token:sub(2):lower())
end

--- The whole text for one class, sections first, then the part every class shares.
local function TextFor(token)
	local parts = {}
	local cls = CLASSES[token]
	if cls then
		for _, sec in ipairs(cls) do
			parts[#parts + 1] = HEAD .. sec[1] .. "|r\n" .. Format(sec[2])
		end
	else
		parts[#parts + 1] = ("Not written yet for the %s. Your keys are already on the block: open it with /mh block, " ..
			"and point at a key to see its spell."):format(ClassName(token))
	end
	for _, sec in ipairs(COMMON) do
		parts[#parts + 1] = HEAD .. sec[1] .. "|r\n" .. Format(sec[2])
	end
	return table.concat(parts, "\n\n")
end
ns.ForeverHowToPlayText = TextFor

local win, shown

local function Show(token)
	shown = token
	win.title:SetText(ns:L("PLAYCARD_HEAD_FMT"):format(ClassName(token)))
	win.body:SetText(TextFor(token))
	win.child:SetHeight(win.body:GetStringHeight() + 20)
	win.scroll:SetVerticalScroll(0)
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
