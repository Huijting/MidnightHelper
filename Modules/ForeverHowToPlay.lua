local _, ns = ...

--[[
	ForeverHowToPlay.lua — "How you play" for WoW Forever.

	Rob, 6 Nov 2026: "doe b en dan a" (b = drop the dead "How you play" step from the key-block guide on Forever, a = put
	the How to play draft in the addon). The text is docs/forever/HOW_TO_PLAY_CONCEPT_2026-11-06.md (written by mh-writer,
	checked by mh-research against DB2 1.60.1.70790 and Blizzard's class deep dives), with the notes for Rob left out.
	Four classes are written (Druid, Paladin, Mage, Hunter); the other five get an honest "not written yet" line.

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
- **Ctrl-3** = Shoot: your **wand** (a small magic stick that shoots by itself). Handy when your mana is low. When you learn Frostfire Bolt, that takes Ctrl-3; put Shoot on one of your own Alt keys if you still want it.
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
