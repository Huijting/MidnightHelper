--[[
	Profession Guided mode data (ns.PROF_GUIDES) - inline en/nl.
	Generated from the verified PROFGUIDE_LVL_* routes + ResetRoutine TRAINER_PINS.
	Middle steps auto-complete at `gate` (skill rank); gate=nil = manual Done.
]]

local _, ns = ...

ns.PROF_GUIDE_ORDER = { 171, 164, 333, 202, 773, 755, 165, 197, 182, 186, 393 }

ns.PROF_GUIDES = {
	[171] = {
		profName = { en = "Alchemy", nl = "Alchemy" },
		trainerName = "Camberon",
		trainer = { mapID = 2393, x = 47.02, y = 51.88 },
		weeklyAtStation = true,
		middleSteps = {
			{ gate = 7, title = { en = "Your first potions (skill 1-7)", nl = "Je eerste drankjes (skill 1-7)" }, body = { en = "Craft 6x Silvermoon Health Potion. Buy the cheap reagents (Tranquility Bloom) from the Auction House, or farm them with Herbalism.", nl = "Maak 6x Silvermoon Health Potion. Koop de goedkope reagentia (Tranquility Bloom) op het veilinghuis, of farm ze met Herbalism." } },
			{ gate = 20, title = { en = "Recycle Potions (skill 7-20)", nl = "Recycle Potions (skill 7-20)" }, body = { en = "Use 'Recycle Potions' 10x on the potions you just made. Cheap, fast skill-ups.", nl = "Gebruik 'Recycle Potions' 10x op de drankjes die je net maakte. Goedkope, snelle skill-ups." } },
			{ gate = 27, title = { en = "Camberon's Cauldron (skill 20-27)", nl = "Camberon's Cauldron (skill 20-27)" }, body = { en = "At Camberon's Cauldron (next to the trainer) research Primal Philosopher's Stone and Lightfused Mana Potion, then craft each once - every first craft gives +1 Knowledge.", nl = "Bij Camberon's Cauldron (naast de trainer) onderzoek je Primal Philosopher's Stone en Lightfused Mana Potion, en maak je elk een keer - elke eerste craft geeft +1 Knowledge." } },
			{ gate = 50, title = { en = "Keep growing (skill 27-50)", nl = "Doorgroeien (skill 27-50)" }, body = { en = "Craft Entropic Extract, then more Silvermoon Health Potions until skill 50.", nl = "Maak Entropic Extract, daarna meer Silvermoon Health Potions tot skill 50." } },
			{ gate = 100, title = { en = "Push to 100 (skill 50-100)", nl = "Naar 100 (skill 50-100)" }, body = { en = "Craft Light's Potential potions, flasks (if you took the flask spec), or transmutes - whatever is cheapest on your realm.", nl = "Maak Light's Potential-drankjes, flasks (als je de flask-spec nam), of transmutes - wat het goedkoopst is op jouw realm." } },
		},
	},
	[164] = {
		profName = { en = "Blacksmithing", nl = "Blacksmithing" },
		trainerName = "Bemarrin",
		trainer = { mapID = 2393, x = 43.74, y = 51.33 },
		weeklyAtStation = true,
		middleSteps = {
			{ gate = 15, title = { en = "Smelt ingots (skill 1-15)", nl = "Smelt ingots (skill 1-15)" }, body = { en = "Smelt 25x Refulgent Copper Ingot.", nl = "Smelt 25x Refulgent Copper Ingot." } },
			{ gate = 50, title = { en = "First-craft recipes (skill 15-50)", nl = "First-craft recepten (skill 15-50)" }, body = { en = "Tick the \"First Craft Bonus\" filter and craft each trainer recipe once, up through all 28.", nl = "Vink het \"First Craft Bonus\"-filter aan en craft elk trainer-recept een keer, tot alle 28." } },
			{ gate = 70, title = { en = "Sterling Alloy (skill 50-70)", nl = "Sterling Alloy (skill 50-70)" }, body = { en = "Craft 50x Sterling Alloy.", nl = "Craft 50x Sterling Alloy." } },
			{ gate = 100, title = { en = "Push to 100 (skill 70-100)", nl = "Naar 100 (skill 70-100)" }, body = { en = "Rush with rare profession equipment via the Craftsmithing spec, or use epic equipment and crafting orders.", nl = "Rush met rare profession equipment via de Craftsmithing-spec, of gebruik epic equipment en crafting orders." } },
		},
	},
	[333] = {
		profName = { en = "Enchanting", nl = "Enchanting" },
		trainerName = "Dolothos",
		trainer = { mapID = 2393, x = 47.97, y = 53.63 },
		weeklyAtStation = false,
		middleSteps = {
			{ gate = 25, title = { en = "Rods & disenchanting (skill 1-25)", nl = "Rods & disenchanten (skill 1-25)" }, body = { en = "Craft 30x Runed Refulgent Copper Rod, then disenchant all 30 for skill.", nl = "Craft 30x Runed Refulgent Copper Rod en disenchant daarna alle 30 voor skill." } },
			{ gate = 40, title = { en = "Ring enchants (skill 25-40)", nl = "Ring-enchants (skill 25-40)" }, body = { en = "First-craft the new enchants, then craft about 13 more Enchant Ring - Nature's Wrath.", nl = "First-craft de nieuwe enchants, daarna nog zo'n 13 extra Enchant Ring - Nature's Wrath." } },
			{ gate = 52, title = { en = "Spellweaver's Wands (skill 40-52)", nl = "Spellweaver's Wands (skill 40-52)" }, body = { en = "Craft 4x Thalassian Spellweaver's Wand.", nl = "Craft 4x Thalassian Spellweaver's Wand." } },
			{ gate = 62, title = { en = "Amani Mastery rings (skill 52-62)", nl = "Amani Mastery-ringen (skill 52-62)" }, body = { en = "Craft Amani Mastery rings plus a few helm and shoulder enchants.", nl = "Craft Amani Mastery-ringen plus een paar helm- en shoulder-enchants." } },
			{ gate = 100, title = { en = "Push to 100 (skill 62-100)", nl = "Naar 100 (skill 62-100)" }, body = { en = "Craft one of every recipe you own, then whatever sells.", nl = "Craft een van elk recept dat je hebt, daarna wat verkoopt." } },
		},
	},
	[202] = {
		profName = { en = "Engineering", nl = "Engineering" },
		trainerName = "Danwe",
		trainer = { mapID = 2393, x = 43.53, y = 54.01 },
		weeklyAtStation = true,
		middleSteps = {
			{ gate = 16, title = { en = "Song Gear & Recycling (skill 1-16)", nl = "Song Gear & Recycling (skill 1-16)" }, body = { en = "Craft 8x Song Gear, then 7x Recycling.", nl = "Craft 8x Song Gear, daarna 7x Recycling." } },
			{ gate = 39, title = { en = "Evercore & sprockets (skill 16-39)", nl = "Evercore & sprockets (skill 16-39)" }, body = { en = "First-craft the Evercore items, then craft 10x Soul Sprocket and the four Cogwheels.", nl = "First-craft de Evercore-items, craft dan 10x Soul Sprocket en de vier Cogwheels." } },
			{ gate = 45, title = { en = "More Recycling (skill 39-45)", nl = "Meer Recycling (skill 39-45)" }, body = { en = "Craft 20x Recycling, then first-craft each new bonus recipe.", nl = "Craft 20x Recycling, daarna first-craft elk nieuw bonus-recept." } },
			{ gate = 80, title = { en = "Quel'dorei gear (skill 45-80)", nl = "Quel'dorei-gear (skill 45-80)" }, body = { en = "Recycle until you discover a Quel'dorei recipe, then mass-craft Quel'dorei gear like 60x Quel'dorei Guards.", nl = "Recycle tot je een Quel'dorei-recept ontdekt, dan mass-craft je Quel'dorei-gear zoals 60x Quel'dorei Guards." } },
			{ gate = 100, title = { en = "Push to 100 (skill 80-100)", nl = "Naar 100 (skill 80-100)" }, body = { en = "Craft Housing Decor, rare equipment, or epic tools and armor via crafting orders.", nl = "Craft Housing Decor, rare equipment, of epic tools en armor via crafting orders." } },
		},
	},
	[773] = {
		profName = { en = "Inscription", nl = "Inscription" },
		trainerName = "Zantasia",
		trainer = { mapID = 2393, x = 46.78, y = 51.48 },
		weeklyAtStation = true,
		middleSteps = {
			{ gate = 20, title = { en = "Milling (skill 1-20)", nl = "Millen (skill 1-20)" }, body = { en = "Use Midnight Milling on all your herbs.", nl = "Gebruik Midnight Milling op al je kruiden." } },
			{ gate = 30, title = { en = "Inks (skill 20-30)", nl = "Inkten (skill 20-30)" }, body = { en = "Craft 11x Munsell Ink, then 12x Sienna Ink, and keep them all.", nl = "Craft 11x Munsell Ink, daarna 12x Sienna Ink, en bewaar ze allemaal." } },
			{ gate = 45, title = { en = "First crafts & Treatises (skill 30-45)", nl = "First-crafts & Treatises (skill 30-45)" }, body = { en = "First-craft the batons, Soul Cipher and Missives, then craft up to 3x Thalassian Treatise on Inscription.", nl = "First-craft de batons, Soul Cipher en Missives, daarna tot 3x Thalassian Treatise on Inscription." } },
			{ gate = 100, title = { en = "Push to 100 (skill 45-100)", nl = "Naar 100 (skill 45-100)" }, body = { en = "Keep crafting Thalassian Treatise on Inscription, about 70 total.", nl = "Blijf Thalassian Treatise on Inscription craften, zo'n 70 in totaal." } },
		},
	},
	[755] = {
		profName = { en = "Jewelcrafting", nl = "Jewelcrafting" },
		trainerName = "Amin",
		trainer = { mapID = 2393, x = 47.93, y = 55.15 },
		weeklyAtStation = true,
		middleSteps = {
			{ gate = 14, title = { en = "Prospect & Lens (skill 1-14)", nl = "Prospect & Lens (skill 1-14)" }, body = { en = "Do 12x Midnight Prospecting, then craft 4x Sin'dorei Lens.", nl = "Doe 12x Midnight Prospecting, daarna craft 4x Sin'dorei Lens." } },
			{ gate = 50, title = { en = "First-craft recipes (skill 14-50)", nl = "First-craft recepten (skill 14-50)" }, body = { en = "Tick the \"First Craft Bonus\" filter and craft each trainer recipe once, learning new ones every 5 skill.", nl = "Vink het \"First Craft Bonus\"-filter aan en craft elk trainer-recept een keer; er komen elke 5 skill nieuwe bij." } },
			{ gate = 65, title = { en = "Monologuer's Chalice (skill 50-65)", nl = "Monologuer's Chalice (skill 50-65)" }, body = { en = "Craft 40x Monologuer's Chalice.", nl = "Craft 40x Monologuer's Chalice." } },
			{ gate = 100, title = { en = "Push to 100 (skill 65-100)", nl = "Naar 100 (skill 65-100)" }, body = { en = "Cut Eversong Diamonds, spam rare and epic profession equipment from Gelanthis, or fill jewelry crafting orders.", nl = "Cut Eversong Diamonds, spam rare en epic profession equipment van Gelanthis, of vul jewelry crafting orders." } },
		},
	},
	[165] = {
		profName = { en = "Leatherworking", nl = "Leatherworking" },
		trainerName = "Talmar",
		trainer = { mapID = 2393, x = 43.15, y = 55.7 },
		weeklyAtStation = true,
		middleSteps = {
			{ gate = 7, title = { en = "First bracers (skill 1-7)", nl = "Eerste bracers (skill 1-7)" }, body = { en = "First-craft Smuggler's Leather Wristbands and Scout's Scaled Bracers, then return to the trainer.", nl = "First-craft Smuggler's Leather Wristbands en Scout's Scaled Bracers en ga terug naar de trainer." } },
			{ gate = 60, title = { en = "First Craft Bonus recipes (skill 7-60)", nl = "First Craft Bonus-recepten (skill 7-60)" }, body = { en = "Tick the \"First Craft Bonus\" filter, craft each recipe once, and learn new trainer recipes every 5-10 skill.", nl = "Vink het \"First Craft Bonus\"-filter aan, craft elk recept een keer en leer elke 5-10 skill nieuwe trainer-recepten." } },
			{ gate = 91, title = { en = "Bulk craft (skill 60-91)", nl = "In bulk craften (skill 60-91)" }, body = { en = "Craft ~35x of any one of Blessed Pango Charm, Primal Spore Binding or Blood Knight's Armor Kit.", nl = "Craft ~35x van een van Blessed Pango Charm, Primal Spore Binding of Blood Knight's Armor Kit." } },
			{ gate = 100, title = { en = "Push to 100 (skill 91-100)", nl = "Naar 100 (skill 91-100)" }, body = { en = "Keep going, or switch to an epic leather or mail armor recipe via crafting orders.", nl = "Ga door, of stap over op een epic leather- of mail-armorrecept via crafting orders." } },
		},
	},
	[197] = {
		profName = { en = "Tailoring", nl = "Tailoring" },
		trainerName = "Galana",
		trainer = { mapID = 2393, x = 48.25, y = 54.15 },
		weeklyAtStation = true,
		middleSteps = {
			{ gate = 25, title = { en = "Bright Linen Bolts (skill 1-25)", nl = "Bright Linen Bolts (skill 1-25)" }, body = { en = "Craft 66x Bright Linen Bolt and keep them all - you need them for later recipes.", nl = "Craft 66x Bright Linen Bolt en bewaar ze allemaal - je hebt ze later nog nodig." } },
			{ gate = 40, title = { en = "Imbued Bright Linen Bolts (skill 25-40)", nl = "Imbued Bright Linen Bolts (skill 25-40)" }, body = { en = "Craft 14x Imbued Bright Linen Bolt.", nl = "Craft 14x Imbued Bright Linen Bolt." } },
			{ gate = 45, title = { en = "First Craft Bonus recipes (skill 40-45)", nl = "First Craft Bonus-recepten (skill 40-45)" }, body = { en = "Tick the \"First Craft Bonus\" filter and craft each remaining recipe once.", nl = "Vink het \"First Craft Bonus\"-filter aan en craft elk resterend recept een keer." } },
			{ gate = 50, title = { en = "Courtly Shoulders (skill 44-50)", nl = "Courtly Shoulders (skill 44-50)" }, body = { en = "Craft 6x Courtly Shoulders.", nl = "Craft 6x Courtly Shoulders." } },
			{ gate = 100, title = { en = "Push to 100 (skill 50-100)", nl = "Door naar 100 (skill 50-100)" }, body = { en = "Spend 5 points into Nimble Needlework and level off the daily bolt cooldown, or rush with Spellthread and Lining recipes.", nl = "Stop 5 punten in Nimble Needlework en level op de dagelijkse bolt-CD, of rush met Spellthread- en Lining-recepten." } },
		},
	},
	[182] = {
		profName = { en = "Herbalism", nl = "Herbalism" },
		trainerName = "Botanist Nathera",
		trainer = { mapID = 2393, x = 48.2, y = 51.52 },
		weeklyAtStation = false,
		middleSteps = {
			{ gate = 30, title = { en = "Pick anything (skill 1-30)", nl = "Pluk alles (skill 1-30)" }, body = { en = "Start in Eversong Woods and pick whatever herb you find - almost everything gives skill.", nl = "Begin in Eversong Woods en pluk elk kruid dat je tegenkomt - bijna alles geeft skill." } },
			{ gate = 60, title = { en = "Pick the base herbs (skill 30-60)", nl = "Pluk de basis-kruiden (skill 30-60)" }, body = { en = "Keep picking the four base herbs - Sanguithorn, Azeroot, Argentleaf and Mana Lily still give skill.", nl = "Blijf de vier basis-kruiden plukken - Sanguithorn, Azeroot, Argentleaf en Mana Lily geven nog skill." } },
			{ gate = 100, title = { en = "Hunt Lush & Infused herbs (skill 60-100)", nl = "Zoek Lush- & Infused-kruiden (skill 60-100)" }, body = { en = "Only Lush and Infused herb variants still give skill now, so just keep gathering until they appear.", nl = "Alleen Lush- en Infused-varianten geven nu nog skill, dus blijf gewoon verzamelen tot ze verschijnen." } },
		},
	},
	[186] = {
		profName = { en = "Mining", nl = "Mining" },
		trainerName = "Belil",
		trainer = { mapID = 2393, x = 42.68, y = 52.84 },
		weeklyAtStation = false,
		middleSteps = {
			{ gate = 30, title = { en = "Mine anything (skill 1-30)", nl = "Min alles (skill 1-30)" }, body = { en = "Start in Eversong Woods and mine whatever deposit you find - almost every one gives skill.", nl = "Begin in Eversong Woods en min elke deposit die je tegenkomt - bijna elke geeft skill." } },
			{ gate = 60, title = { en = "Mine rich deposits (skill 30-60)", nl = "Min rijke deposits (skill 30-60)" }, body = { en = "Base deposits go yellow now, so keep mining Rich deposits, Seams and Infused variants for skill.", nl = "Basis-deposits worden nu geel, dus blijf Rich deposits, Seams en Infused-varianten minen voor skill." } },
			{ gate = 100, title = { en = "Hunt rich & infused nodes (skill 60-100)", nl = "Zoek rijke & infused nodes (skill 60-100)" }, body = { en = "Only Rich deposits, Seams and Infused variants still give skill, so keep mining until they spawn.", nl = "Alleen Rich deposits, Seams en Infused-varianten geven nu nog skill, dus blijf minen tot ze spawnen." } },
		},
	},
	[393] = {
		profName = { en = "Skinning", nl = "Skinning" },
		trainerName = "Tyn",
		trainer = { mapID = 2393, x = 43.27, y = 55.59 },
		weeklyAtStation = false,
		middleSteps = {
			{ title = { en = "Spend points on the farming build", nl = "Zet punten in de farm-build" }, body = { en = "Skinning scales through its trees, so put your early Knowledge points into Thorough Tanning for more leather and scales.", nl = "Skinning schaalt via de trees, dus stop je vroege Knowledge-punten in Thorough Tanning voor meer leather en scales." } },
			{ title = { en = "Skin High Value Beasts", nl = "Vil High Value Beasts" }, body = { en = "Chase the beasts with a glowing skinning-knife icon on the minimap - they yield 5-10 extra hides.", nl = "Ga achter de beesten met een glimmend skinning-knife-icoon op de minimap aan - die geven 5-10 extra hides." } },
			{ title = { en = "Carry two knives", nl = "Draag twee messen" }, body = { en = "Keep a Finesse knife for more base materials and a Perception knife for an extra roll on rares.", nl = "Houd een Finesse-mes voor meer base-materialen en een Perception-mes voor een extra roll op rares." } },
		},
	},
}
