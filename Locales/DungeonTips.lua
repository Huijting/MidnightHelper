--[[
	Midnight Helper — Dungeon Coach boss-step bodies (EN + NL pilot; other
	locales fall back to EN until the localization pass). Line breaks |n.

	Phase 3, batch 1: Windrunner Spire + Maisara Caverns (Normal difficulty).
	Own MH text in beginner language, cross-referenced against BossHelper
	(MIT) and DungeonHelper on Rob's machine; to be verified by Rob in
	follower runs before this ships in a release. Spell names stay in English
	(proper names policy).
]]

local _, ns = ...

local function merge(target, patch)
	if not target or not patch then
		return
	end
	for k, v in pairs(patch) do
		target[k] = v
	end
end

merge(ns._mhLocales and ns._mhLocales.enUS, {
	-- Windrunner Spire ---------------------------------------------------------
	DGN_TIP_WS_DUO_STEPS = "1. Two bosses — damage them evenly so they die around the same time.|n2. Interrupt Shadow Bolt; step out of the spew circles (don't waste floor space).|n3. Got cursed? Have it dispelled fast — or crowd-control the Dark Entity it spawns until it fades.|n4. Hooked by Heaving Yank during the shriek? Position so you get pulled THROUGH the ghost lady — that breaks her cast.",
	DGN_TIP_WS_DUO_TANK = "Tank: defensive for Bone Hack; move the bosses when the floor gets cluttered.",
	DGN_TIP_WS_DUO_HEALER = "Healer: big group damage during Debilitating Shriek; dispel Curse of Darkness quickly.",

	DGN_TIP_WS_EMBER_STEPS = "1. Fire = bad. Drop the fire puddles (Flaming Updraft) at the edges, keep the middle clean.|n2. At full energy run TO the boss for Burning Gale, then sidestep every Fire Breath.|n3. Old puddles spawn fire twisters — keep dodging.",
	DGN_TIP_WS_EMBER_TANK = "Tank: defensive for Searing Beak.",
	DGN_TIP_WS_EMBER_HEALER = "Healer: heavy group damage during Burning Gale.",

	DGN_TIP_WS_KROLUK_STEPS = "1. Brown circles = bad, step out.|n2. Stack with an ally before Intimidating Shout finishes (overlap the purple circles).|n3. Fixated or leaped at? Run it away from the group.|n4. When adds spawn (about two thirds and one third health): kill them fast — the Phantasmal Mystic first, and keep interrupting it.",
	DGN_TIP_WS_KROLUK_TANK = "Tank: defensive for Rampage; be ready to pick up the second Reckless Leap.",
	DGN_TIP_WS_KROLUK_HEALER = "Healer: group damage during Rallying Bellow.",

	DGN_TIP_WS_HEART_STEPS = "1. Squall Leap stacks ticking on you? Step on a windy arrow (Turbulent Arrow) at 2-3 stacks — it clears the DoT and jumps you over the expanding shockwave.|n2. Keep one arrow free for the big blast at full energy (Bullseye Windblast).|n3. Spread a little for Gust Shot and use the big circles to clear the electric ground.|n4. Targeted by Bolt Gale? Stand still and let the others move out; everyone else: step out of the frontal.",
	DGN_TIP_WS_HEART_TANK = "Tank: defensive for Tempest Slash; aim the knockback away from the puddles.",
	DGN_TIP_WS_HEART_HEALER = "Healer: top up players with high Squall Leap stacks first; extra healing after Gust Shot.",

	-- Maisara Caverns -----------------------------------------------------------
	DGN_TIP_MC_MUROJIN_STEPS = "1. Two bosses (hunter and bird) — kill them close together, or the survivor goes berserk.|n2. Ice traps, green circles and the frontal Barrage = bad, stay out.|n3. Targeted by Carrion Swoop (the bird dive)? Run INTO an ice trap — the freeze stops the dive. Everyone else: get away from that player.",
	DGN_TIP_MC_MUROJIN_TANK = "Tank: defensive for Flanking Spear.",
	DGN_TIP_MC_MUROJIN_HEALER = "Healer: heavy group damage from Infected Pinions.",

	DGN_TIP_MC_VORDAZA_STEPS = "1. The boss spawns phantoms that chase the tank and DPS. Pop them by overlapping them — but ONE at a time: every pop hurts the whole group.|n2. Dodge the rotating beam, the floating orbs and Soulrot.|n3. Someone wrapped in a Deathshroud? Break them out fast; interrupt Necrotic Convergence and dodge the swirls during it.",
	DGN_TIP_MC_VORDAZA_TANK = "Tank: defensive for Drain Soul.",
	DGN_TIP_MC_VORDAZA_HEALER = "Healer: every phantom pop = group damage (so stagger them); Lingering Dread stacks up.",

	DGN_TIP_MC_RAKTUL_STEPS = "1. The boss leaps at three players and leaves Soulbind Totems — spread so the totems land apart, don't get crushed, and kill the totems fast.|n2. Stay out of the Chill of Death ground.|n3. Soul phase (Soulrending Roar): you're pulled out of your body — crowd-control and interrupt the big adds while you run back to your body.|n4. Dodge the swirls from the Deathgorged Vessel.",
	DGN_TIP_MC_RAKTUL_TANK = "Tank: defensive for Spiritbreaker; place the puddles away from the group.",
	DGN_TIP_MC_RAKTUL_HEALER = "Healer: heavy group damage during Deathgorged Vessel and when totems shatter.",
})

merge(ns._mhLocales and ns._mhLocales.nlNL, {
	-- Windrunner Spire ----------------------------------------------------------
	DGN_TIP_WS_DUO_STEPS = "1. Twee bosses — beschadig ze gelijkmatig zodat ze ongeveer tegelijk doodgaan.|n2. Interrupt Shadow Bolt; stap uit de spuugcirkels (verspil geen vloerruimte).|n3. Vervloekt? Laat 'm snel dispellen — of CC de Dark Entity die eruit spawnt tot 'ie verdwijnt.|n4. Gegrepen door Heaving Yank tijdens de schreeuw? Ga zo staan dat je DWARS DOOR de spookdame getrokken wordt — dat breekt haar cast.",
	DGN_TIP_WS_DUO_TANK = "Tank: defensive voor Bone Hack; verplaats de bosses als de vloer te vol raakt.",
	DGN_TIP_WS_DUO_HEALER = "Healer: veel groepsschade tijdens Debilitating Shriek; dispel Curse of Darkness snel.",

	DGN_TIP_WS_EMBER_STEPS = "1. Vuur = slecht. Leg de vuurplassen (Flaming Updraft) aan de randen, houd het midden schoon.|n2. Op volle energie: ren NAAR de boss voor Burning Gale en stap daarna elke Fire Breath opzij.|n3. Oude plassen spawnen vuurhozen — blijf ontwijken.",
	DGN_TIP_WS_EMBER_TANK = "Tank: defensive voor Searing Beak.",
	DGN_TIP_WS_EMBER_HEALER = "Healer: zware groepsschade tijdens Burning Gale.",

	DGN_TIP_WS_KROLUK_STEPS = "1. Bruine cirkels = slecht, stap eruit.|n2. Ga bij een maatje staan vóór Intimidating Shout afloopt (overlap de paarse cirkels).|n3. Gefixeerd of doelwit van de sprong? Ren 'm wég van de groep.|n4. Spawnen er adds (rond tweederde en eenderde health): maak ze snel dood — de Phantasmal Mystic eerst, en blijf 'm interrupten.",
	DGN_TIP_WS_KROLUK_TANK = "Tank: defensive voor Rampage; sta klaar om de tweede Reckless Leap op te vangen.",
	DGN_TIP_WS_KROLUK_HEALER = "Healer: groepsschade tijdens Rallying Bellow.",

	DGN_TIP_WS_HEART_STEPS = "1. Tikken de Squall Leap-stacks op je? Stap op een windpijl (Turbulent Arrow) bij 2-3 stacks — die haalt de DoT weg én springt je over de uitdijende schokgolf.|n2. Houd één pijl over voor de grote knal op volle energie (Bullseye Windblast).|n3. Spreid licht voor Gust Shot en gebruik de grote cirkels om de elektrische vloer schoon te vegen.|n4. Doelwit van Bolt Gale? Blijf stilstaan en laat de rest wegstappen; iedereen anders: uit de frontal.",
	DGN_TIP_WS_HEART_TANK = "Tank: defensive voor Tempest Slash; richt de knockback wég van de plassen.",
	DGN_TIP_WS_HEART_HEALER = "Healer: spelers met hoge Squall Leap-stacks eerst bijhealen; extra healing na Gust Shot.",

	-- Maisara Caverns -------------------------------------------------------------
	DGN_TIP_MC_MUROJIN_STEPS = "1. Twee bosses (jager en vogel) — maak ze dicht bij elkaar dood, anders gaat de overlever berserk.|n2. IJsvallen, groene cirkels en de frontale Barrage = slecht, blijf eruit.|n3. Doelwit van Carrion Swoop (de duikvlucht)? Ren een ijsval IN — de freeze stopt de duik. De rest: weg bij die speler.",
	DGN_TIP_MC_MUROJIN_TANK = "Tank: defensive voor Flanking Spear.",
	DGN_TIP_MC_MUROJIN_HEALER = "Healer: zware groepsschade van Infected Pinions.",

	DGN_TIP_MC_VORDAZA_STEPS = "1. De boss spawnt fantomen die de tank en DPS achtervolgen. Pop ze door ertegenaan te lopen — maar ÉÉN tegelijk: elke pop doet de hele groep pijn.|n2. Ontwijk de draaiende straal, de zwevende orbs en Soulrot.|n3. Zit iemand in een Deathshroud? Sla 'm er snel uit; interrupt Necrotic Convergence en ontwijk de swirls ondertussen.",
	DGN_TIP_MC_VORDAZA_TANK = "Tank: defensive voor Drain Soul.",
	DGN_TIP_MC_VORDAZA_HEALER = "Healer: elke fantoom-pop = groepsschade (dus spreid ze); Lingering Dread stapelt op.",

	DGN_TIP_MC_RAKTUL_STEPS = "1. De boss springt naar drie spelers en laat Soulbind Totems achter — spreid zodat de totems uit elkaar landen, word niet geplet, en maak de totems snel dood.|n2. Blijf uit de Chill of Death-vloer.|n3. Zielfase (Soulrending Roar): je wordt uit je lichaam getrokken — CC en kick de grote adds terwijl je terugrent naar je lichaam.|n4. Ontwijk de swirls van het Deathgorged Vessel.",
	DGN_TIP_MC_RAKTUL_TANK = "Tank: defensive voor Spiritbreaker; leg de plassen wég van de groep.",
	DGN_TIP_MC_RAKTUL_HEALER = "Healer: zware groepsschade tijdens Deathgorged Vessel en wanneer totems breken.",
})
