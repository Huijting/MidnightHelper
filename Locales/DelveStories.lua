--[[
	Omschrijvingen bij de story-varianten. GEGENEREERD -- zie DelveStoryData.lua.

	De enUS-teksten zijn Blizzards eigen woorden uit de DB2-tabel, letterlijk
	overgenomen. Ze staan hier omdat een addon DB2 niet kan lezen; de client
	toont ze alleen in het gossip-venster van de delve zelf.
]]

local _, ns = ...

local function merge(target, patch)
	if type(target) ~= "table" then
		return
	end
	for k, v in pairs(patch) do
		if target[k] == nil then
			target[k] = v
		end
	end
end

merge(ns._mhLocales and ns._mhLocales.enUS, {
	DELVE_STORY_ACADEMIC_ANTITOXIN = "Gather antidote and save the envenomed denizens!",
	DELVE_STORY_ACADEMY_UNDER_SIEGE = "End the Void invasion before it spreads beyond the campus!",
	DELVE_STORY_ADOPT_A_THON = "Adorable baby animals need wrangling and competitors need mangling in the cutest display of organized murder you've ever seen.",
	DELVE_STORY_ALNMOTH_MUNCHIES = "Feed fresh Lightbloom Overgrowth to hungry Alnmoths to combat their unchecked growth.",
	DELVE_STORY_ARENA_CHAMPION = "Fight your way through several rounds to challenge the reigning champion.",
	DELVE_STORY_BASILISK_BLITZ = "Destroy supercharged serpentine monstrosities before they escape.",
	DELVE_STORY_BOMBING_RUN = "Destroy Devouring Host staging grounds in the Void from within using powerful arcane explosives.",
	DELVE_STORY_CAPTURED_WILDLIFE = "Turn Voidstorm wildlife against the Shadowguard to disrupt their operations.",
	DELVE_STORY_CAUSTIC_CRUSH = "Slime Shamen of Ula'tek are summoning slimes and crashing down waves of poison. Stop them!",
	DELVE_STORY_CORE_OF_THE_PROBLEM = "Gather the Energized Cores necessary to break the Domanaar's control of the Sanctum.",
	DELVE_STORY_CROCOLISK_REINTRODUCTION = "Release Undermine sewer crocolisks into their natural habitat to help protect the species.",
	DELVE_STORY_DASTARDLY_ROTSTALK = "Antagonize fans and fighters while disguised as your villainous alter ego.",
	DELVE_STORY_DESCENT_OF_THE_HARANIR = "Retrace the Haranir's journey as they followed Azeroth's song to Harandar.",
	DELVE_STORY_DOMINATION_AND_DESPAIR = "Nullaeus waits within for those brave or foolish enough to challenge his dominance.",
	DELVE_STORY_EGGSPLOSIVE_GROWTH = "Children of Ula'tek have breached the Arcway and begun nesting within its tunnels. Destroy their eggs before they hatch into a new wave of monsters!",
	DELVE_STORY_FACULTY_OF_FEAR = "Unmask the false professors and end the Twilight's Blade's influence over the student body.",
	DELVE_STORY_FOCUSERS_UNDER_PRESSURE = "The Twilight's Blade have infiltrated the tunnels under Suramar and are disrupting the ley lines within.",
	DELVE_STORY_FUNGAL_PHARMACON = "Purge the Children of Ula'tek from their burrows and purify their poison.",
	DELVE_STORY_GAME_DAY = "Headball, the most popular, and explosively violent, sport to ever grace the arena is in full swing!",
	DELVE_STORY_HOLDING_THE_LINE = "Help restore the Sunwell's defenses in the face of a renewed Void assault.",
	DELVE_STORY_INFILTRATE_AND_AMELIORATE = "Sagotage a plan to summon Ula'tek herself.",
	DELVE_STORY_INVASIVE_GLOW = "Cut down the Lightbloom overgrowth before it overruns the campus!",
	DELVE_STORY_LEYLINE_TECHNICIAN = "Untangle the invisible flows of arcane power that course beneath Suramar.",
	DELVE_STORY_LIGHTBLOOM_INVASION = "Help the fungarians fend off a lightbloom attack.",
	DELVE_STORY_LOOSED_LOA = "Free a rampaging Loa from the shackles of the Vilebranch trolls.",
	DELVE_STORY_MARCH_OF_THE_ARCANE_BRIGADE = "Deploy Sentinels against the Void Pylons of the Devouring Host.",
	DELVE_STORY_MINCHI_S_OSSEOUS_ADVENTURE = "Piles of gnawed bones might put most people off, but for Minchi and his hat, they're a learning opportunity that can't be missed!",
	DELVE_STORY_MIRROR_SHINE = "Gabby Flashwiks has a plan to banish the shadows infesting the area with reflected sunlight.",
	DELVE_STORY_NOT_WHAT_I_EXPECTED = "Resolve the chaos caused by Deremius Duskwalk's Lightbloom experiments.",
	DELVE_STORY_OGRE_POWERED = "The Twilight's Blade have unleashed a power they could not control, leaving arcane energies to run amok through the tunnels underneath Suramar.",
	DELVE_STORY_OLDS_AND_ENDS = "Gnarldin raiders have captured many of the tortollan elders who were too slow to escape. Help rescue them and recover whatever goods have survived the gnarldins' tender care.",
	DELVE_STORY_OPEN_NIGHT = "Face off against wannabes and champions alike in search of glory in the arena.",
	DELVE_STORY_PARTY_CRASHER = "Stop the Twilight's Blade from making contact with the Void.",
	DELVE_STORY_RESULTS_CALAMITOUS = "Disrupt the Shadowguard's volatile Void experiments.",
	DELVE_STORY_RITUAL_INTERRUPTED = "Disrupt the Vilebranch trolls' sacrificial ritual and save the Spiritclaw cubs.",
	DELVE_STORY_SHADOWY_SUPPLIES = "\"Liberate\" the supplies the Twilight's Blade have gathered before they can rearm and recover their strength.",
	DELVE_STORY_SPEAKING_THEIR_LANGUAGE = "Help the tortollans send a message even the gnarldin will understand.",
	DELVE_STORY_SPORASAUR_SPECIAL = "Massive Sporasaurs are spreading explosive Lightbloom spores throughout the Gulf and need to be stopped.",
	DELVE_STORY_STOLEN_MANA = "The Shadowguard siphon mana from friend and foe alike to power their machinery.",
	DELVE_STORY_TELEPORTER_TANTRUMS = "Experimental teleporters are being used to enhance Darkfuse operations in the area.",
	DELVE_STORY_THE_GRAVITATIONAL_EFFECT = "Use the gravitational pull of the micro singularities to gain the advantage over the Domanaar.",
	DELVE_STORY_TOADLY_UNBECOMING = "Defeat the Vilebranch and break the hex imprisoning the Amani trolls in frog form.",
	DELVE_STORY_TOTEM_ANNIHILATION = "Destroy the cursed totems being used by the Vilebranch to imprison Akil'zon at her shrine.",
	DELVE_STORY_TRAITOR_S_DUE = "Disrupt the Twilight's Blade's shadowy rituals and bring Antenorian to justice.",
	DELVE_STORY_TRAPPED = "Rescue the forgotten hostages inside the crypts.",
	DELVE_STORY_VENOM_S_HEART = "A powerful Venom Priest, Azta'rec floods the archipelago with poison from within his lair.",
	DELVE_STORY_VENOMOUS_VAPORS = "Clear Toxic Clouds from Atal'Aman.",
	DELVE_STORY_WHY_D_IT_HAVE_TO_BE_SNAKES = "Help Harrison Jones find lost relics in these snake-infested crypts.",
})
