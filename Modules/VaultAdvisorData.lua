--[[
	Midnight Helper — Great Vault Advisor stat weights.
	AUTO-GENERATED from data/vault_stat_priorities.json (patch 12.0.5).
	Edit the JSON and run: python tools/generate_vault_stat_weights.py
	Primary stat / item level handled in VaultAdvisor.lua.
]]

local _, ns = ...

--- Relative weights for secondary stats (from guide priority order, not SimC/Pawn).
ns.VAULT_ADVISOR_SPEC_WEIGHTS = {
	--- Blood Death Knight: Strength > Crit > Vers > Mastery > Haste
	--- Icy Veins: https://www.icy-veins.com/wow/blood-death-knight-pve-tank-stat-priority
	--- Wowhead: https://www.wowhead.com/guide/classes/death-knight/blood/stat-priority-pve-tank
	["DEATHKNIGHT_250"] = {
		mastery = 0.84,
		haste = 0.55,
		crit = 1.00,
		vers = 0.92,
	},
	--- Blood Death Knight (San'layn): Strength > Crit > Vers > Mastery > Haste
	--- Icy Veins: https://www.icy-veins.com/wow/blood-death-knight-pve-tank-stat-priority
	--- Wowhead: https://www.wowhead.com/guide/classes/death-knight/blood/stat-priority-pve-tank
	["DEATHKNIGHT_250_HERO_31"] = {
		mastery = 0.84,
		haste = 0.55,
		crit = 1.00,
		vers = 0.92,
	},
	--- Blood Death Knight (Deathbringer): Strength > Haste > Crit > Vers > Mastery
	--- Icy Veins: https://www.icy-veins.com/wow/blood-death-knight-pve-tank-stat-priority
	--- Wowhead: https://www.wowhead.com/guide/classes/death-knight/blood/stat-priority-pve-tank
	["DEATHKNIGHT_250_HERO_33"] = {
		mastery = 0.55,
		haste = 1.00,
		crit = 0.92,
		vers = 0.84,
	},
	--- Frost Death Knight: Strength > Mastery > Crit > Haste > Vers
	--- Icy Veins: https://www.icy-veins.com/wow/frost-death-knight-pve-dps-stat-priority
	--- Wowhead: https://www.wowhead.com/guide/classes/death-knight/frost/stat-priority-pve-dps
	["DEATHKNIGHT_251"] = {
		mastery = 1.00,
		haste = 0.84,
		crit = 0.92,
		vers = 0.55,
	},
	--- Unholy Death Knight: Strength > Mastery > Crit > Haste > Vers
	--- Icy Veins: https://www.icy-veins.com/wow/unholy-death-knight-pve-dps-stat-priority
	--- Wowhead: https://www.wowhead.com/guide/classes/death-knight/unholy/stat-priority-pve-dps
	["DEATHKNIGHT_252"] = {
		mastery = 1.00,
		haste = 0.84,
		crit = 0.92,
		vers = 0.55,
	},
	--- Havoc Demon Hunter: Agility > Crit > Mastery > Haste > Vers
	--- Icy Veins: https://www.icy-veins.com/wow/havoc-demon-hunter-pve-dps-stat-priority
	--- Wowhead: https://www.wowhead.com/guide/classes/demon-hunter/havoc/stat-priority-pve-dps
	["DEMONHUNTER_577"] = {
		mastery = 0.92,
		haste = 0.84,
		crit = 1.00,
		vers = 0.55,
	},
	--- Vengeance Demon Hunter: Agility > Haste > Vers > Crit > Mastery
	--- Icy Veins: https://www.icy-veins.com/wow/vengeance-demon-hunter-pve-tank-stat-priority
	--- Wowhead: https://www.wowhead.com/guide/classes/demon-hunter/vengeance/stat-priority-pve-tank
	["DEMONHUNTER_581"] = {
		mastery = 0.55,
		haste = 1.00,
		crit = 0.84,
		vers = 0.92,
	},
	--- Balance Druid: Intellect > Haste > Crit > Mastery > Vers
	--- Icy Veins: https://www.icy-veins.com/wow/balance-druid-pve-dps-stat-priority
	--- Wowhead: https://www.wowhead.com/guide/classes/druid/balance/stat-priority-pve-dps
	["DRUID_102"] = {
		mastery = 0.84,
		haste = 1.00,
		crit = 0.92,
		vers = 0.55,
	},
	--- Feral Druid: Agility > Mastery > Haste > Crit > Vers
	--- Icy Veins: https://www.icy-veins.com/wow/feral-druid-pve-dps-stat-priority
	--- Wowhead: https://www.wowhead.com/guide/classes/druid/feral/stat-priority-pve-dps
	["DRUID_103"] = {
		mastery = 1.00,
		haste = 0.92,
		crit = 0.84,
		vers = 0.55,
	},
	--- Feral Druid (Druid of the Claw): Agility > Mastery > Haste > Crit > Vers
	--- Icy Veins: https://www.icy-veins.com/wow/feral-druid-pve-dps-stat-priority
	--- Wowhead: https://www.wowhead.com/guide/classes/druid/feral/stat-priority-pve-dps
	["DRUID_103_HERO_21"] = {
		mastery = 1.00,
		haste = 0.92,
		crit = 0.84,
		vers = 0.55,
	},
	--- Feral Druid (Wildstalker): Agility > Mastery > Haste > Crit > Vers
	--- Icy Veins: https://www.icy-veins.com/wow/feral-druid-pve-dps-stat-priority
	--- Wowhead: https://www.wowhead.com/guide/classes/druid/feral/stat-priority-pve-dps
	["DRUID_103_HERO_22"] = {
		mastery = 1.00,
		haste = 0.92,
		crit = 0.84,
		vers = 0.55,
	},
	--- Guardian Druid: Agility > Haste > Vers > Mastery > Crit
	--- Icy Veins: https://www.icy-veins.com/wow/guardian-druid-pve-tank-stat-priority
	--- Wowhead: https://www.wowhead.com/guide/classes/druid/guardian/stat-priority-pve-tank
	["DRUID_104"] = {
		mastery = 0.84,
		haste = 1.00,
		crit = 0.55,
		vers = 0.92,
	},
	--- Guardian Druid (Druid of the Claw): Agility > Haste > Vers > Mastery > Crit
	--- Icy Veins: https://www.icy-veins.com/wow/guardian-druid-pve-tank-stat-priority
	--- Wowhead: https://www.wowhead.com/guide/classes/druid/guardian/stat-priority-pve-tank
	["DRUID_104_HERO_21"] = {
		mastery = 0.84,
		haste = 1.00,
		crit = 0.55,
		vers = 0.92,
	},
	--- Guardian Druid (Keeper of the Grove): Agility > Haste > Vers > Crit > Mastery
	--- Icy Veins: https://www.icy-veins.com/wow/guardian-druid-pve-tank-stat-priority
	--- Wowhead: https://www.wowhead.com/guide/classes/druid/guardian/stat-priority-pve-tank
	["DRUID_104_HERO_23"] = {
		mastery = 0.55,
		haste = 1.00,
		crit = 0.84,
		vers = 0.92,
	},
	--- Restoration Druid: Intellect > Haste > Mastery > Vers > Crit
	--- Icy Veins: https://www.icy-veins.com/wow/restoration-druid-pve-healing-stat-priority
	--- Wowhead: https://www.wowhead.com/guide/classes/druid/restoration/stat-priority-pve-healing
	["DRUID_105"] = {
		mastery = 0.92,
		haste = 1.00,
		crit = 0.55,
		vers = 0.84,
	},
	--- Restoration Druid (M+): Intellect > Haste > Vers > Crit > Mastery (M+)
	--- Icy Veins: https://www.icy-veins.com/wow/restoration-druid-pve-healing-stat-priority
	--- Wowhead: https://www.wowhead.com/guide/classes/druid/restoration/stat-priority-pve-healing
	["DRUID_105_MPLUS"] = {
		mastery = 0.55,
		haste = 1.00,
		crit = 0.84,
		vers = 0.92,
	},
	--- Restoration Druid (Keeper of the Grove): Intellect > Haste > Mastery > Vers > Crit
	--- Icy Veins: https://www.icy-veins.com/wow/restoration-druid-pve-healing-stat-priority
	--- Wowhead: https://www.wowhead.com/guide/classes/druid/restoration/stat-priority-pve-healing
	["DRUID_105_HERO_23"] = {
		mastery = 0.92,
		haste = 1.00,
		crit = 0.55,
		vers = 0.84,
	},
	--- Restoration Druid (Elune's Chosen): Intellect > Mastery > Haste > Vers > Crit
	--- Icy Veins: https://www.icy-veins.com/wow/restoration-druid-pve-healing-stat-priority
	--- Wowhead: https://www.wowhead.com/guide/classes/druid/restoration/stat-priority-pve-healing
	["DRUID_105_HERO_24"] = {
		mastery = 1.00,
		haste = 0.92,
		crit = 0.55,
		vers = 0.84,
	},
	--- Devastation Evoker: Intellect > Haste > Crit > Mastery > Vers
	--- Icy Veins: https://www.icy-veins.com/wow/devastation-evoker-pve-dps-stat-priority
	--- Wowhead: https://www.wowhead.com/guide/classes/evoker/devastation/stat-priority-pve-dps
	["EVOKER_1467"] = {
		mastery = 0.84,
		haste = 1.00,
		crit = 0.92,
		vers = 0.55,
	},
	--- Preservation Evoker: Intellect > Mastery > Crit > Haste > Vers
	--- Icy Veins: https://www.icy-veins.com/wow/preservation-evoker-pve-healing-stat-priority
	--- Wowhead: https://www.wowhead.com/guide/classes/evoker/preservation/stat-priority-pve-healing
	["EVOKER_1468"] = {
		mastery = 1.00,
		haste = 0.84,
		crit = 0.92,
		vers = 0.55,
	},
	--- Preservation Evoker (M+): Intellect > Haste > Crit > Mastery > Vers (M+)
	--- Icy Veins: https://www.icy-veins.com/wow/preservation-evoker-pve-healing-stat-priority
	--- Wowhead: https://www.wowhead.com/guide/classes/evoker/preservation/stat-priority-pve-healing
	["EVOKER_1468_MPLUS"] = {
		mastery = 0.84,
		haste = 1.00,
		crit = 0.92,
		vers = 0.55,
	},
	--- Augmentation Evoker: Intellect > Crit > Haste > Mastery > Vers
	--- Icy Veins: https://www.icy-veins.com/wow/augmentation-evoker-pve-dps-stat-priority
	--- Wowhead: https://www.wowhead.com/guide/classes/evoker/augmentation/stat-priority-pve-dps
	["EVOKER_1473"] = {
		mastery = 0.84,
		haste = 0.92,
		crit = 1.00,
		vers = 0.55,
	},
	--- Beast Mastery Hunter: Agility > Mastery > Crit > Haste > Vers
	--- Icy Veins: https://www.icy-veins.com/wow/beast-mastery-hunter-pve-dps-stat-priority
	--- Wowhead: https://www.wowhead.com/guide/classes/hunter/beast-mastery/stat-priority-pve-dps
	["HUNTER_253"] = {
		mastery = 1.00,
		haste = 0.84,
		crit = 0.92,
		vers = 0.55,
	},
	--- Marksmanship Hunter: Agility > Crit > Mastery > Vers > Haste
	--- Icy Veins: https://www.icy-veins.com/wow/marksmanship-hunter-pve-dps-stat-priority
	--- Wowhead: https://www.wowhead.com/guide/classes/hunter/marksmanship/stat-priority-pve-dps
	["HUNTER_254"] = {
		mastery = 0.92,
		haste = 0.55,
		crit = 1.00,
		vers = 0.84,
	},
	--- Survival Hunter: Agility > Mastery > Crit > Haste > Vers
	--- Icy Veins: https://www.icy-veins.com/wow/survival-hunter-pve-dps-stat-priority
	--- Wowhead: https://www.wowhead.com/guide/classes/hunter/survival/stat-priority-pve-dps
	["HUNTER_255"] = {
		mastery = 1.00,
		haste = 0.84,
		crit = 0.92,
		vers = 0.55,
	},
	--- Arcane Mage: Intellect > Mastery > Vers > Crit > Haste
	--- Icy Veins: https://www.icy-veins.com/wow/arcane-mage-pve-dps-stat-priority
	--- Wowhead: https://www.wowhead.com/guide/classes/mage/arcane/stat-priority-pve-dps
	["MAGE_62"] = {
		mastery = 1.00,
		haste = 0.55,
		crit = 0.84,
		vers = 0.92,
	},
	--- Fire Mage: Intellect > Haste > Mastery > Vers > Crit
	--- Icy Veins: https://www.icy-veins.com/wow/fire-mage-pve-dps-stat-priority
	--- Wowhead: https://www.wowhead.com/guide/classes/mage/fire/stat-priority-pve-dps
	["MAGE_63"] = {
		mastery = 0.92,
		haste = 1.00,
		crit = 0.55,
		vers = 0.84,
	},
	--- Frost Mage: Intellect > Mastery = Crit > Haste > Vers
	--- Icy Veins: https://www.icy-veins.com/wow/frost-mage-pve-dps-stat-priority
	--- Wowhead: https://www.wowhead.com/guide/classes/mage/frost/stat-priority-pve-dps
	["MAGE_64"] = {
		mastery = 1.00,
		haste = 0.84,
		crit = 1.00,
		vers = 0.55,
	},
	--- Brewmaster Monk: Agility > Crit > Vers > Mastery > Haste
	--- Icy Veins: https://www.icy-veins.com/wow/brewmaster-monk-pve-tank-stat-priority
	--- Wowhead: https://www.wowhead.com/guide/classes/monk/brewmaster/stat-priority-pve-tank
	["MONK_268"] = {
		mastery = 0.84,
		haste = 0.55,
		crit = 1.00,
		vers = 0.92,
	},
	--- Brewmaster Monk (Shado-Pan): Agility > Crit > Vers > Mastery > Haste
	--- Icy Veins: https://www.icy-veins.com/wow/brewmaster-monk-pve-tank-stat-priority
	--- Wowhead: https://www.wowhead.com/guide/classes/monk/brewmaster/stat-priority-pve-tank
	["MONK_268_HERO_65"] = {
		mastery = 0.84,
		haste = 0.55,
		crit = 1.00,
		vers = 0.92,
	},
	--- Brewmaster Monk (Master of Harmony): Agility > Crit > Mastery > Vers > Haste
	--- Icy Veins: https://www.icy-veins.com/wow/brewmaster-monk-pve-tank-stat-priority
	--- Wowhead: https://www.wowhead.com/guide/classes/monk/brewmaster/stat-priority-pve-tank
	["MONK_268_HERO_66"] = {
		mastery = 0.92,
		haste = 0.55,
		crit = 1.00,
		vers = 0.84,
	},
	--- Windwalker Monk: Agility > Haste > Crit > Mastery > Vers
	--- Icy Veins: https://www.icy-veins.com/wow/windwalker-monk-pve-dps-stat-priority
	--- Wowhead: https://www.wowhead.com/guide/classes/monk/windwalker/stat-priority-pve-dps
	["MONK_269"] = {
		mastery = 0.84,
		haste = 1.00,
		crit = 0.92,
		vers = 0.55,
	},
	--- Mistweaver Monk: Intellect > Haste > Crit > Vers > Mastery
	--- Icy Veins: https://www.icy-veins.com/wow/mistweaver-monk-pve-healing-stat-priority
	--- Wowhead: https://www.wowhead.com/guide/classes/monk/mistweaver/stat-priority-pve-healing
	["MONK_270"] = {
		mastery = 0.55,
		haste = 1.00,
		crit = 0.92,
		vers = 0.84,
	},
	--- Mistweaver Monk (M+): Intellect > Haste > Crit > Vers > Mastery (M+)
	--- Icy Veins: https://www.icy-veins.com/wow/mistweaver-monk-pve-healing-stat-priority
	--- Wowhead: https://www.wowhead.com/guide/classes/monk/mistweaver/stat-priority-pve-healing
	["MONK_270_MPLUS"] = {
		mastery = 0.55,
		haste = 1.00,
		crit = 0.92,
		vers = 0.84,
	},
	--- Mistweaver Monk (Conduit of the Celestials): Intellect > Haste > Crit > Vers > Mastery
	--- Icy Veins: https://www.icy-veins.com/wow/mistweaver-monk-pve-healing-stat-priority
	--- Wowhead: https://www.wowhead.com/guide/classes/monk/mistweaver/stat-priority-pve-healing
	["MONK_270_HERO_64"] = {
		mastery = 0.55,
		haste = 1.00,
		crit = 0.92,
		vers = 0.84,
	},
	--- Mistweaver Monk (Master of Harmony): Intellect > Haste > Crit > Vers > Mastery
	--- Icy Veins: https://www.icy-veins.com/wow/mistweaver-monk-pve-healing-stat-priority
	--- Wowhead: https://www.wowhead.com/guide/classes/monk/mistweaver/stat-priority-pve-healing
	["MONK_270_HERO_66"] = {
		mastery = 0.55,
		haste = 1.00,
		crit = 0.92,
		vers = 0.84,
	},
	--- Holy Paladin: Intellect > Mastery > Haste > Crit > Vers
	--- Icy Veins: https://www.icy-veins.com/wow/holy-paladin-pve-healing-stat-priority
	--- Wowhead: https://www.wowhead.com/guide/classes/paladin/holy/stat-priority-pve-healing
	["PALADIN_65"] = {
		mastery = 1.00,
		haste = 0.92,
		crit = 0.84,
		vers = 0.55,
	},
	--- Holy Paladin (M+): Intellect > Mastery > Crit > Haste > Vers (M+)
	--- Icy Veins: https://www.icy-veins.com/wow/holy-paladin-pve-healing-stat-priority
	--- Wowhead: https://www.wowhead.com/guide/classes/paladin/holy/stat-priority-pve-healing
	["PALADIN_65_MPLUS"] = {
		mastery = 1.00,
		haste = 0.92,
		crit = 0.84,
		vers = 0.55,
	},
	--- Holy Paladin (Lightsmith): Intellect > Mastery > Crit > Haste > Vers
	--- Icy Veins: https://www.icy-veins.com/wow/holy-paladin-pve-healing-stat-priority
	--- Wowhead: https://www.wowhead.com/guide/classes/paladin/holy/stat-priority-pve-healing
	["PALADIN_65_HERO_49"] = {
		mastery = 1.00,
		haste = 0.84,
		crit = 0.92,
		vers = 0.55,
	},
	--- Holy Paladin (Herald of the Sun): Intellect > Mastery > Haste > Crit > Vers
	--- Icy Veins: https://www.icy-veins.com/wow/holy-paladin-pve-healing-stat-priority
	--- Wowhead: https://www.wowhead.com/guide/classes/paladin/holy/stat-priority-pve-healing
	["PALADIN_65_HERO_50"] = {
		mastery = 1.00,
		haste = 0.92,
		crit = 0.84,
		vers = 0.55,
	},
	--- Protection Paladin: Strength > Haste > Vers > Mastery > Crit
	--- Icy Veins: https://www.icy-veins.com/wow/protection-paladin-pve-tank-stat-priority
	--- Wowhead: https://www.wowhead.com/guide/classes/paladin/protection/stat-priority-pve-tank
	["PALADIN_66"] = {
		mastery = 0.84,
		haste = 1.00,
		crit = 0.55,
		vers = 0.92,
	},
	--- Protection Paladin (Templar): Strength > Haste > Vers > Mastery > Crit
	--- Icy Veins: https://www.icy-veins.com/wow/protection-paladin-pve-tank-stat-priority
	--- Wowhead: https://www.wowhead.com/guide/classes/paladin/protection/stat-priority-pve-tank
	["PALADIN_66_HERO_48"] = {
		mastery = 0.84,
		haste = 1.00,
		crit = 0.55,
		vers = 0.92,
	},
	--- Protection Paladin (Lightsmith): Strength > Haste > Crit > Vers > Mastery
	--- Icy Veins: https://www.icy-veins.com/wow/protection-paladin-pve-tank-stat-priority
	--- Wowhead: https://www.wowhead.com/guide/classes/paladin/protection/stat-priority-pve-tank
	["PALADIN_66_HERO_49"] = {
		mastery = 0.55,
		haste = 1.00,
		crit = 0.92,
		vers = 0.84,
	},
	--- Retribution Paladin: Strength > Mastery > Crit > Haste > Vers
	--- Icy Veins: https://www.icy-veins.com/wow/retribution-paladin-pve-dps-stat-priority
	--- Wowhead: https://www.wowhead.com/guide/classes/paladin/retribution/stat-priority-pve-dps
	["PALADIN_70"] = {
		mastery = 1.00,
		haste = 0.84,
		crit = 0.92,
		vers = 0.55,
	},
	--- Discipline Priest: Intellect > Haste > Crit > Mastery > Vers
	--- Icy Veins: https://www.icy-veins.com/wow/discipline-priest-pve-healing-stat-priority
	--- Wowhead: https://www.wowhead.com/guide/classes/priest/discipline/stat-priority-pve-healing
	["PRIEST_256"] = {
		mastery = 0.84,
		haste = 1.00,
		crit = 0.92,
		vers = 0.55,
	},
	--- Discipline Priest (M+): Intellect > Haste > Crit > Mastery > Vers (M+)
	--- Icy Veins: https://www.icy-veins.com/wow/discipline-priest-pve-healing-stat-priority
	--- Wowhead: https://www.wowhead.com/guide/classes/priest/discipline/stat-priority-pve-healing
	["PRIEST_256_MPLUS"] = {
		mastery = 0.84,
		haste = 1.00,
		crit = 0.92,
		vers = 0.55,
	},
	--- Discipline Priest (Archon): Intellect > Haste > Crit > Mastery > Vers
	--- Icy Veins: https://www.icy-veins.com/wow/discipline-priest-pve-healing-stat-priority
	--- Wowhead: https://www.wowhead.com/guide/classes/priest/discipline/stat-priority-pve-healing
	["PRIEST_256_HERO_19"] = {
		mastery = 0.84,
		haste = 1.00,
		crit = 0.92,
		vers = 0.55,
	},
	--- Discipline Priest (Oracle): Intellect > Haste > Crit > Mastery > Vers
	--- Icy Veins: https://www.icy-veins.com/wow/discipline-priest-pve-healing-stat-priority
	--- Wowhead: https://www.wowhead.com/guide/classes/priest/discipline/stat-priority-pve-healing
	["PRIEST_256_HERO_20"] = {
		mastery = 0.84,
		haste = 1.00,
		crit = 0.92,
		vers = 0.55,
	},
	--- Holy Priest: Intellect > Crit > Vers > Mastery > Haste
	--- Icy Veins: https://www.icy-veins.com/wow/holy-priest-pve-healing-stat-priority
	--- Wowhead: https://www.wowhead.com/guide/classes/priest/holy/stat-priority-pve-healing
	["PRIEST_257"] = {
		mastery = 0.84,
		haste = 0.55,
		crit = 1.00,
		vers = 0.92,
	},
	--- Holy Priest (M+): Intellect > Crit > Vers > Haste > Mastery (M+)
	--- Icy Veins: https://www.icy-veins.com/wow/holy-priest-pve-healing-stat-priority
	--- Wowhead: https://www.wowhead.com/guide/classes/priest/holy/stat-priority-pve-healing
	["PRIEST_257_MPLUS"] = {
		mastery = 0.55,
		haste = 0.84,
		crit = 1.00,
		vers = 0.92,
	},
	--- Holy Priest (Archon): Intellect > Crit > Vers > Mastery > Haste
	--- Icy Veins: https://www.icy-veins.com/wow/holy-priest-pve-healing-stat-priority
	--- Wowhead: https://www.wowhead.com/guide/classes/priest/holy/stat-priority-pve-healing
	["PRIEST_257_HERO_19"] = {
		mastery = 0.84,
		haste = 0.55,
		crit = 1.00,
		vers = 0.92,
	},
	--- Holy Priest (Oracle): Intellect > Crit > Vers > Haste > Mastery
	--- Icy Veins: https://www.icy-veins.com/wow/holy-priest-pve-healing-stat-priority
	--- Wowhead: https://www.wowhead.com/guide/classes/priest/holy/stat-priority-pve-healing
	["PRIEST_257_HERO_20"] = {
		mastery = 0.55,
		haste = 0.84,
		crit = 1.00,
		vers = 0.92,
	},
	--- Shadow Priest: Intellect > Haste > Mastery > Crit > Vers
	--- Icy Veins: https://www.icy-veins.com/wow/shadow-priest-pve-dps-stat-priority
	--- Wowhead: https://www.wowhead.com/guide/classes/priest/shadow/stat-priority-pve-dps
	["PRIEST_258"] = {
		mastery = 0.92,
		haste = 1.00,
		crit = 0.84,
		vers = 0.55,
	},
	--- Assassination Rogue: Agility > Crit > Haste > Mastery > Vers
	--- Icy Veins: https://www.icy-veins.com/wow/assassination-rogue-pve-dps-stat-priority
	--- Wowhead: https://www.wowhead.com/guide/classes/rogue/assassination/stat-priority-pve-dps
	["ROGUE_259"] = {
		mastery = 0.84,
		haste = 0.92,
		crit = 1.00,
		vers = 0.55,
	},
	--- Outlaw Rogue: Agility > Crit > Haste > Vers > Mastery
	--- Icy Veins: https://www.icy-veins.com/wow/outlaw-rogue-pve-dps-stat-priority
	--- Wowhead: https://www.wowhead.com/guide/classes/rogue/outlaw/stat-priority-pve-dps
	["ROGUE_260"] = {
		mastery = 0.55,
		haste = 0.92,
		crit = 1.00,
		vers = 0.84,
	},
	--- Subtlety Rogue: Agility > Haste > Mastery > Crit > Vers
	--- Icy Veins: https://www.icy-veins.com/wow/subtlety-rogue-pve-dps-stat-priority
	--- Wowhead: https://www.wowhead.com/guide/classes/rogue/subtlety/stat-priority-pve-dps
	["ROGUE_261"] = {
		mastery = 0.92,
		haste = 1.00,
		crit = 0.84,
		vers = 0.55,
	},
	--- Elemental Shaman: Intellect > Mastery > Haste = Crit > Vers
	--- Icy Veins: https://www.icy-veins.com/wow/elemental-shaman-pve-dps-stat-priority
	--- Wowhead: https://www.wowhead.com/guide/classes/shaman/elemental/stat-priority-pve-dps
	["SHAMAN_262"] = {
		mastery = 1.00,
		haste = 0.92,
		crit = 0.92,
		vers = 0.55,
	},
	--- Elemental Shaman (Stormbringer): Intellect > Mastery > Haste = Crit > Vers
	--- Icy Veins: https://www.icy-veins.com/wow/elemental-shaman-pve-dps-stat-priority
	--- Wowhead: https://www.wowhead.com/guide/classes/shaman/elemental/stat-priority-pve-dps
	["SHAMAN_262_HERO_55"] = {
		mastery = 1.00,
		haste = 0.92,
		crit = 0.92,
		vers = 0.55,
	},
	--- Elemental Shaman (Farseer): Intellect > Mastery > Haste = Crit > Vers
	--- Icy Veins: https://www.icy-veins.com/wow/elemental-shaman-pve-dps-stat-priority
	--- Wowhead: https://www.wowhead.com/guide/classes/shaman/elemental/stat-priority-pve-dps
	["SHAMAN_262_HERO_56"] = {
		mastery = 1.00,
		haste = 0.92,
		crit = 0.92,
		vers = 0.55,
	},
	--- Enhancement Shaman: Agility > Mastery > Haste > Crit > Vers
	--- Icy Veins: https://www.icy-veins.com/wow/enhancement-shaman-pve-dps-stat-priority
	--- Wowhead: https://www.wowhead.com/guide/classes/shaman/enhancement/stat-priority-pve-dps
	["SHAMAN_263"] = {
		mastery = 1.00,
		haste = 0.92,
		crit = 0.84,
		vers = 0.55,
	},
	--- Enhancement Shaman (Totemic): Agility > Mastery > Haste > Crit > Vers
	--- Icy Veins: https://www.icy-veins.com/wow/enhancement-shaman-pve-dps-stat-priority
	--- Wowhead: https://www.wowhead.com/guide/classes/shaman/enhancement/stat-priority-pve-dps
	["SHAMAN_263_HERO_54"] = {
		mastery = 1.00,
		haste = 0.92,
		crit = 0.84,
		vers = 0.55,
	},
	--- Enhancement Shaman (Stormbringer): Agility > Mastery > Haste > Crit > Vers
	--- Icy Veins: https://www.icy-veins.com/wow/enhancement-shaman-pve-dps-stat-priority
	--- Wowhead: https://www.wowhead.com/guide/classes/shaman/enhancement/stat-priority-pve-dps
	["SHAMAN_263_HERO_55"] = {
		mastery = 0.92,
		haste = 1.00,
		crit = 0.84,
		vers = 0.55,
	},
	--- Restoration Shaman: Intellect > Crit > Vers = Mastery > Haste
	--- Icy Veins: https://www.icy-veins.com/wow/restoration-shaman-pve-healing-stat-priority
	--- Wowhead: https://www.wowhead.com/guide/classes/shaman/restoration/stat-priority-pve-healing
	["SHAMAN_264"] = {
		mastery = 0.92,
		haste = 0.55,
		crit = 1.00,
		vers = 0.92,
	},
	--- Restoration Shaman (M+): Intellect > Crit = Vers = Haste > Mastery (M+)
	--- Icy Veins: https://www.icy-veins.com/wow/restoration-shaman-pve-healing-stat-priority
	--- Wowhead: https://www.wowhead.com/guide/classes/shaman/restoration/stat-priority-pve-healing
	["SHAMAN_264_MPLUS"] = {
		mastery = 0.55,
		haste = 1.00,
		crit = 1.00,
		vers = 1.00,
	},
	--- Affliction Warlock: Intellect > Haste > Crit > Mastery > Vers
	--- Icy Veins: https://www.icy-veins.com/wow/affliction-warlock-pve-dps-stat-priority
	--- Wowhead: https://www.wowhead.com/guide/classes/warlock/affliction/stat-priority-pve-dps
	["WARLOCK_265"] = {
		mastery = 0.84,
		haste = 1.00,
		crit = 0.92,
		vers = 0.55,
	},
	--- Demonology Warlock: Intellect > Crit > Haste > Mastery > Vers
	--- Icy Veins: https://www.icy-veins.com/wow/demonology-warlock-pve-dps-stat-priority
	--- Wowhead: https://www.wowhead.com/guide/classes/warlock/demonology/stat-priority-pve-dps
	["WARLOCK_266"] = {
		mastery = 0.84,
		haste = 0.92,
		crit = 1.00,
		vers = 0.55,
	},
	--- Destruction Warlock: Intellect > Crit > Haste > Mastery > Vers
	--- Icy Veins: https://www.icy-veins.com/wow/destruction-warlock-pve-dps-stat-priority
	--- Wowhead: https://www.wowhead.com/guide/classes/warlock/destruction/stat-priority-pve-dps
	["WARLOCK_267"] = {
		mastery = 0.84,
		haste = 0.92,
		crit = 1.00,
		vers = 0.55,
	},
	--- Arms Warrior: Strength > Crit > Haste > Mastery > Vers
	--- Icy Veins: https://www.icy-veins.com/wow/arms-warrior-pve-dps-stat-priority
	--- Wowhead: https://www.wowhead.com/guide/classes/warrior/arms/stat-priority-pve-dps
	["WARRIOR_71"] = {
		mastery = 0.84,
		haste = 0.92,
		crit = 1.00,
		vers = 0.55,
	},
	--- Fury Warrior: Strength > Mastery > Haste > Vers > Crit
	--- Icy Veins: https://www.icy-veins.com/wow/fury-warrior-pve-dps-stat-priority
	--- Wowhead: https://www.wowhead.com/guide/classes/warrior/fury/stat-priority-pve-dps
	["WARRIOR_72"] = {
		mastery = 1.00,
		haste = 0.92,
		crit = 0.55,
		vers = 0.84,
	},
	--- Protection Warrior: Strength > Haste > Vers > Crit > Mastery
	--- Icy Veins: https://www.icy-veins.com/wow/protection-warrior-pve-tank-stat-priority
	--- Wowhead: https://www.wowhead.com/guide/classes/warrior/protection/stat-priority-pve-tank
	["WARRIOR_73"] = {
		mastery = 0.55,
		haste = 1.00,
		crit = 0.84,
		vers = 0.92,
	},
}

--- Guide text and sources per weight key (shown in vault advisor UI).
ns.VAULT_ADVISOR_SPEC_META = {
	["DEATHKNIGHT_250"] = {
		priorityText = "Strength > Crit > Vers > Mastery > Haste",
		sources = "Icy Veins, Wowhead",
		patch = "12.0.5",
	},
	["DEATHKNIGHT_250_HERO_31"] = {
		priorityText = "Strength > Crit > Vers > Mastery > Haste",
		sources = "Icy Veins, Wowhead",
		patch = "12.0.5",
	},
	["DEATHKNIGHT_250_HERO_33"] = {
		priorityText = "Strength > Haste > Crit > Vers > Mastery",
		sources = "Icy Veins, Wowhead",
		patch = "12.0.5",
	},
	["DEATHKNIGHT_251"] = {
		priorityText = "Strength > Mastery > Crit > Haste > Vers",
		sources = "Icy Veins, Wowhead",
		patch = "12.0.5",
	},
	["DEATHKNIGHT_252"] = {
		priorityText = "Strength > Mastery > Crit > Haste > Vers",
		sources = "Icy Veins, Wowhead",
		patch = "12.0.5",
	},
	["DEMONHUNTER_577"] = {
		priorityText = "Agility > Crit > Mastery > Haste > Vers",
		sources = "Icy Veins, Wowhead",
		patch = "12.0.5",
	},
	["DEMONHUNTER_581"] = {
		priorityText = "Agility > Haste > Vers > Crit > Mastery",
		sources = "Icy Veins, Wowhead",
		patch = "12.0.5",
	},
	["DRUID_102"] = {
		priorityText = "Intellect > Haste > Crit > Mastery > Vers",
		sources = "Icy Veins, Wowhead",
		patch = "12.0.5",
	},
	["DRUID_103"] = {
		priorityText = "Agility > Mastery > Haste > Crit > Vers",
		sources = "Icy Veins, Wowhead",
		patch = "12.0.5",
	},
	["DRUID_103_HERO_21"] = {
		priorityText = "Agility > Mastery > Haste > Crit > Vers",
		sources = "Icy Veins, Wowhead",
		patch = "12.0.5",
	},
	["DRUID_103_HERO_22"] = {
		priorityText = "Agility > Mastery > Haste > Crit > Vers",
		sources = "Icy Veins, Wowhead",
		patch = "12.0.5",
	},
	["DRUID_104"] = {
		priorityText = "Agility > Haste > Vers > Mastery > Crit",
		sources = "Icy Veins, Wowhead",
		patch = "12.0.5",
	},
	["DRUID_104_HERO_21"] = {
		priorityText = "Agility > Haste > Vers > Mastery > Crit",
		sources = "Icy Veins, Wowhead",
		patch = "12.0.5",
	},
	["DRUID_104_HERO_23"] = {
		priorityText = "Agility > Haste > Vers > Crit > Mastery",
		sources = "Icy Veins, Wowhead",
		patch = "12.0.5",
	},
	["DRUID_105"] = {
		priorityText = "Intellect > Haste > Mastery > Vers > Crit",
		sources = "Icy Veins, Wowhead",
		patch = "12.0.5",
	},
	["DRUID_105_MPLUS"] = {
		priorityText = "Intellect > Haste > Vers > Crit > Mastery (M+)",
		sources = "Icy Veins, Wowhead",
		patch = "12.0.5",
	},
	["DRUID_105_HERO_23"] = {
		priorityText = "Intellect > Haste > Mastery > Vers > Crit",
		sources = "Icy Veins, Wowhead",
		patch = "12.0.5",
	},
	["DRUID_105_HERO_24"] = {
		priorityText = "Intellect > Mastery > Haste > Vers > Crit",
		sources = "Icy Veins, Wowhead",
		patch = "12.0.5",
	},
	["EVOKER_1467"] = {
		priorityText = "Intellect > Haste > Crit > Mastery > Vers",
		sources = "Icy Veins, Wowhead",
		patch = "12.0.5",
	},
	["EVOKER_1468"] = {
		priorityText = "Intellect > Mastery > Crit > Haste > Vers",
		sources = "Icy Veins, Wowhead",
		patch = "12.0.5",
	},
	["EVOKER_1468_MPLUS"] = {
		priorityText = "Intellect > Haste > Crit > Mastery > Vers (M+)",
		sources = "Icy Veins, Wowhead",
		patch = "12.0.5",
	},
	["EVOKER_1473"] = {
		priorityText = "Intellect > Crit > Haste > Mastery > Vers",
		sources = "Icy Veins, Wowhead",
		patch = "12.0.5",
	},
	["HUNTER_253"] = {
		priorityText = "Agility > Mastery > Crit > Haste > Vers",
		sources = "Icy Veins, Wowhead",
		patch = "12.0.5",
	},
	["HUNTER_254"] = {
		priorityText = "Agility > Crit > Mastery > Vers > Haste",
		sources = "Icy Veins, Wowhead",
		patch = "12.0.5",
	},
	["HUNTER_255"] = {
		priorityText = "Agility > Mastery > Crit > Haste > Vers",
		sources = "Icy Veins, Wowhead",
		patch = "12.0.5",
	},
	["MAGE_62"] = {
		priorityText = "Intellect > Mastery > Vers > Crit > Haste",
		sources = "Icy Veins, Wowhead",
		patch = "12.0.5",
	},
	["MAGE_63"] = {
		priorityText = "Intellect > Haste > Mastery > Vers > Crit",
		sources = "Icy Veins, Wowhead",
		patch = "12.0.5",
	},
	["MAGE_64"] = {
		priorityText = "Intellect > Mastery = Crit > Haste > Vers",
		sources = "Icy Veins, Wowhead",
		patch = "12.0.5",
	},
	["MONK_268"] = {
		priorityText = "Agility > Crit > Vers > Mastery > Haste",
		sources = "Icy Veins, Wowhead",
		patch = "12.0.5",
	},
	["MONK_268_HERO_65"] = {
		priorityText = "Agility > Crit > Vers > Mastery > Haste",
		sources = "Icy Veins, Wowhead",
		patch = "12.0.5",
	},
	["MONK_268_HERO_66"] = {
		priorityText = "Agility > Crit > Mastery > Vers > Haste",
		sources = "Icy Veins, Wowhead",
		patch = "12.0.5",
	},
	["MONK_269"] = {
		priorityText = "Agility > Haste > Crit > Mastery > Vers",
		sources = "Icy Veins, Wowhead",
		patch = "12.0.5",
	},
	["MONK_270"] = {
		priorityText = "Intellect > Haste > Crit > Vers > Mastery",
		sources = "Icy Veins, Wowhead",
		patch = "12.0.5",
	},
	["MONK_270_MPLUS"] = {
		priorityText = "Intellect > Haste > Crit > Vers > Mastery (M+)",
		sources = "Icy Veins, Wowhead",
		patch = "12.0.5",
	},
	["MONK_270_HERO_64"] = {
		priorityText = "Intellect > Haste > Crit > Vers > Mastery",
		sources = "Icy Veins, Wowhead",
		patch = "12.0.5",
	},
	["MONK_270_HERO_66"] = {
		priorityText = "Intellect > Haste > Crit > Vers > Mastery",
		sources = "Icy Veins, Wowhead",
		patch = "12.0.5",
	},
	["PALADIN_65"] = {
		priorityText = "Intellect > Mastery > Haste > Crit > Vers",
		sources = "Icy Veins, Wowhead",
		patch = "12.0.5",
	},
	["PALADIN_65_MPLUS"] = {
		priorityText = "Intellect > Mastery > Crit > Haste > Vers (M+)",
		sources = "Icy Veins, Wowhead",
		patch = "12.0.5",
	},
	["PALADIN_65_HERO_49"] = {
		priorityText = "Intellect > Mastery > Crit > Haste > Vers",
		sources = "Icy Veins, Wowhead",
		patch = "12.0.5",
	},
	["PALADIN_65_HERO_50"] = {
		priorityText = "Intellect > Mastery > Haste > Crit > Vers",
		sources = "Icy Veins, Wowhead",
		patch = "12.0.5",
	},
	["PALADIN_66"] = {
		priorityText = "Strength > Haste > Vers > Mastery > Crit",
		sources = "Icy Veins, Wowhead",
		patch = "12.0.5",
	},
	["PALADIN_66_HERO_48"] = {
		priorityText = "Strength > Haste > Vers > Mastery > Crit",
		sources = "Icy Veins, Wowhead",
		patch = "12.0.5",
	},
	["PALADIN_66_HERO_49"] = {
		priorityText = "Strength > Haste > Crit > Vers > Mastery",
		sources = "Icy Veins, Wowhead",
		patch = "12.0.5",
	},
	["PALADIN_70"] = {
		priorityText = "Strength > Mastery > Crit > Haste > Vers",
		sources = "Icy Veins, Wowhead",
		patch = "12.0.5",
	},
	["PRIEST_256"] = {
		priorityText = "Intellect > Haste > Crit > Mastery > Vers",
		sources = "Icy Veins, Wowhead",
		patch = "12.0.5",
	},
	["PRIEST_256_MPLUS"] = {
		priorityText = "Intellect > Haste > Crit > Mastery > Vers (M+)",
		sources = "Icy Veins, Wowhead",
		patch = "12.0.5",
	},
	["PRIEST_256_HERO_19"] = {
		priorityText = "Intellect > Haste > Crit > Mastery > Vers",
		sources = "Icy Veins, Wowhead",
		patch = "12.0.5",
	},
	["PRIEST_256_HERO_20"] = {
		priorityText = "Intellect > Haste > Crit > Mastery > Vers",
		sources = "Icy Veins, Wowhead",
		patch = "12.0.5",
	},
	["PRIEST_257"] = {
		priorityText = "Intellect > Crit > Vers > Mastery > Haste",
		sources = "Icy Veins, Wowhead",
		patch = "12.0.5",
	},
	["PRIEST_257_MPLUS"] = {
		priorityText = "Intellect > Crit > Vers > Haste > Mastery (M+)",
		sources = "Icy Veins, Wowhead",
		patch = "12.0.5",
	},
	["PRIEST_257_HERO_19"] = {
		priorityText = "Intellect > Crit > Vers > Mastery > Haste",
		sources = "Icy Veins, Wowhead",
		patch = "12.0.5",
	},
	["PRIEST_257_HERO_20"] = {
		priorityText = "Intellect > Crit > Vers > Haste > Mastery",
		sources = "Icy Veins, Wowhead",
		patch = "12.0.5",
	},
	["PRIEST_258"] = {
		priorityText = "Intellect > Haste > Mastery > Crit > Vers",
		sources = "Icy Veins, Wowhead",
		patch = "12.0.5",
	},
	["ROGUE_259"] = {
		priorityText = "Agility > Crit > Haste > Mastery > Vers",
		sources = "Icy Veins, Wowhead",
		patch = "12.0.5",
	},
	["ROGUE_260"] = {
		priorityText = "Agility > Crit > Haste > Vers > Mastery",
		sources = "Icy Veins, Wowhead",
		patch = "12.0.5",
	},
	["ROGUE_261"] = {
		priorityText = "Agility > Haste > Mastery > Crit > Vers",
		sources = "Icy Veins, Wowhead",
		patch = "12.0.5",
	},
	["SHAMAN_262"] = {
		priorityText = "Intellect > Mastery > Haste = Crit > Vers",
		sources = "Icy Veins, Wowhead",
		patch = "12.0.5",
	},
	["SHAMAN_262_HERO_55"] = {
		priorityText = "Intellect > Mastery > Haste = Crit > Vers",
		sources = "Icy Veins, Wowhead",
		patch = "12.0.5",
	},
	["SHAMAN_262_HERO_56"] = {
		priorityText = "Intellect > Mastery > Haste = Crit > Vers",
		sources = "Icy Veins, Wowhead",
		patch = "12.0.5",
	},
	["SHAMAN_263"] = {
		priorityText = "Agility > Mastery > Haste > Crit > Vers",
		sources = "Icy Veins, Wowhead",
		patch = "12.0.5",
	},
	["SHAMAN_263_HERO_54"] = {
		priorityText = "Agility > Mastery > Haste > Crit > Vers",
		sources = "Icy Veins, Wowhead",
		patch = "12.0.5",
	},
	["SHAMAN_263_HERO_55"] = {
		priorityText = "Agility > Mastery > Haste > Crit > Vers",
		sources = "Icy Veins, Wowhead",
		patch = "12.0.5",
	},
	["SHAMAN_264"] = {
		priorityText = "Intellect > Crit > Vers = Mastery > Haste",
		sources = "Icy Veins, Wowhead",
		patch = "12.0.5",
	},
	["SHAMAN_264_MPLUS"] = {
		priorityText = "Intellect > Crit = Vers = Haste > Mastery (M+)",
		sources = "Icy Veins, Wowhead",
		patch = "12.0.5",
	},
	["WARLOCK_265"] = {
		priorityText = "Intellect > Haste > Crit > Mastery > Vers",
		sources = "Icy Veins, Wowhead",
		patch = "12.0.5",
	},
	["WARLOCK_266"] = {
		priorityText = "Intellect > Crit > Haste > Mastery > Vers",
		sources = "Icy Veins, Wowhead",
		patch = "12.0.5",
	},
	["WARLOCK_267"] = {
		priorityText = "Intellect > Crit > Haste > Mastery > Vers",
		sources = "Icy Veins, Wowhead",
		patch = "12.0.5",
	},
	["WARRIOR_71"] = {
		priorityText = "Strength > Crit > Haste > Mastery > Vers",
		sources = "Icy Veins, Wowhead",
		patch = "12.0.5",
	},
	["WARRIOR_72"] = {
		priorityText = "Strength > Mastery > Haste > Vers > Crit",
		sources = "Icy Veins, Wowhead",
		patch = "12.0.5",
	},
	["WARRIOR_73"] = {
		priorityText = "Strength > Haste > Vers > Crit > Mastery",
		sources = "Icy Veins, Wowhead",
		patch = "12.0.5",
	},
}

--- Hero talent SubTreeID labels (C_ClassTalents.GetActiveHeroTalentSpec).
ns.VAULT_ADVISOR_HERO_NAMES = {
	[18] = "Voidweaver",
	[19] = "Archon",
	[20] = "Oracle",
	[21] = "Druid of the Claw",
	[22] = "Wildstalker",
	[23] = "Keeper of the Grove",
	[24] = "Elune's Chosen",
	[31] = "San'layn",
	[32] = "Rider of the Apocalypse",
	[33] = "Deathbringer",
	[34] = "Fel-Scarred",
	[35] = "Aldrachi Reaver",
	[36] = "Scalecommander",
	[37] = "Flameshaper",
	[38] = "Chronowarden",
	[39] = "Sunfury",
	[40] = "Spellslinger",
	[41] = "Frostfire",
	[42] = "Sentinel",
	[43] = "Pack Leader",
	[44] = "Dark Ranger",
	[48] = "Templar",
	[49] = "Lightsmith",
	[50] = "Herald of the Sun",
	[51] = "Trickster",
	[52] = "Fatebound",
	[53] = "Deathstalker",
	[54] = "Totemic",
	[55] = "Stormbringer",
	[56] = "Farseer",
	[57] = "Soul Harvester",
	[58] = "Hellcaller",
	[59] = "Diabolist",
	[60] = "Slayer",
	[61] = "Mountain Thane",
	[62] = "Colossus",
	[64] = "Conduit of the Celestials",
	[65] = "Shado-Pan",
	[66] = "Master of Harmony",
	[124] = "Annihilator",
}


--- ilvl is weighted heavily because guides treat item level as primary for upgrades.
ns.VAULT_ADVISOR_ILVL_WEIGHT = 8

--- Activity types from Enum.WeeklyRewardChestThresholdType (C_WeeklyRewards.GetActivities).
ns.VAULT_ADVISOR_ACTIVITY_TYPES = {
	[1] = "dungeon",
	[2] = "pvp",
	[3] = "raid",
	[4] = "also",
	[5] = "concession",
	[6] = "world",
}
