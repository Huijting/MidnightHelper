--[[
	Dungeon Coach — per-boss tips (phase 3, batch 1: Windrunner Spire +
	Maisara Caverns). Bodies live in Locales/DungeonTips.lua (EN+NL pilot).

	Content policy (Robs besluit, DUNGEON_COACH_PLAN.md): own MH text in
	beginner language, written against two cross-references on Rob's machine —
	BossHelper (MIT) and DungeonHelper — and verified by Rob in follower runs.
	Normal-difficulty focus; HEROIC sections come in phase 4 where relevant.

	Structure per boss: steps (numbered, what actually matters), optional
	tank/healer/dps role lines. Keys follow DGN_TIP_<DUNGEON>_<BOSS>_<SECTION>
	so the future share sync can rebuild them per locale.
]]

local _, ns = ...

ns.DUNGEON_TIPS = {
	windrunnerspire = {
		derelictduo = {
			steps = "DGN_TIP_WS_DUO_STEPS",
			tank = "DGN_TIP_WS_DUO_TANK",
			healer = "DGN_TIP_WS_DUO_HEALER",
			dps = "DGN_TIP_WS_DUO_DPS",
		},
		emberdawn = {
			steps = "DGN_TIP_WS_EMBER_STEPS",
			tank = "DGN_TIP_WS_EMBER_TANK",
			healer = "DGN_TIP_WS_EMBER_HEALER",
			dps = "DGN_TIP_WS_EMBER_DPS",
		},
		kroluk = {
			steps = "DGN_TIP_WS_KROLUK_STEPS",
			tank = "DGN_TIP_WS_KROLUK_TANK",
			healer = "DGN_TIP_WS_KROLUK_HEALER",
			dps = "DGN_TIP_WS_KROLUK_DPS",
		},
		restlessheart = {
			steps = "DGN_TIP_WS_HEART_STEPS",
			tank = "DGN_TIP_WS_HEART_TANK",
			healer = "DGN_TIP_WS_HEART_HEALER",
			dps = "DGN_TIP_WS_HEART_DPS",
		},
	},
	maisara = {
		murojin = {
			steps = "DGN_TIP_MC_MUROJIN_STEPS",
			tank = "DGN_TIP_MC_MUROJIN_TANK",
			healer = "DGN_TIP_MC_MUROJIN_HEALER",
			dps = "DGN_TIP_MC_MUROJIN_DPS",
		},
		vordaza = {
			steps = "DGN_TIP_MC_VORDAZA_STEPS",
			tank = "DGN_TIP_MC_VORDAZA_TANK",
			healer = "DGN_TIP_MC_VORDAZA_HEALER",
			dps = "DGN_TIP_MC_VORDAZA_DPS",
		},
		raktul = {
			steps = "DGN_TIP_MC_RAKTUL_STEPS",
			tank = "DGN_TIP_MC_RAKTUL_TANK",
			healer = "DGN_TIP_MC_RAKTUL_HEALER",
			dps = "DGN_TIP_MC_RAKTUL_DPS",
		},
	},
	-- Batch 2 (11 jun): bron = DBM-Party-Midnight (spell-IDs/voice-cues) +
	-- Wowhead-spelltooltips; eigen MH-tekst. Nog niet in-game gedraaid —
	-- zelfde verificatiestatus als batch 1 vóór Robs follower-runs.
	murderrow = {
		kystia = {
			steps = "DGN_TIP_MR_KYSTIA_STEPS",
			tank = "DGN_TIP_MR_KYSTIA_TANK",
			healer = "DGN_TIP_MR_KYSTIA_HEALER",
			dps = "DGN_TIP_MR_KYSTIA_DPS",
		},
		zaen = {
			steps = "DGN_TIP_MR_ZAEN_STEPS",
			tank = "DGN_TIP_MR_ZAEN_TANK",
			healer = "DGN_TIP_MR_ZAEN_HEALER",
			dps = "DGN_TIP_MR_ZAEN_DPS",
		},
		xathuux = {
			steps = "DGN_TIP_MR_XATHUUX_STEPS",
			tank = "DGN_TIP_MR_XATHUUX_TANK",
			healer = "DGN_TIP_MR_XATHUUX_HEALER",
			dps = "DGN_TIP_MR_XATHUUX_DPS",
		},
		lithiel = {
			steps = "DGN_TIP_MR_LITHIEL_STEPS",
			tank = "DGN_TIP_MR_LITHIEL_TANK",
			healer = "DGN_TIP_MR_LITHIEL_HEALER",
			dps = "DGN_TIP_MR_LITHIEL_DPS",
		},
	},
	nalorakk = {
		hoardmonger = {
			steps = "DGN_TIP_DN_HOARDMONGER_STEPS",
			tank = "DGN_TIP_DN_HOARDMONGER_TANK",
			healer = "DGN_TIP_DN_HOARDMONGER_HEALER",
			dps = "DGN_TIP_DN_HOARDMONGER_DPS",
		},
		sentinel = {
			steps = "DGN_TIP_DN_SENTINEL_STEPS",
			tank = "DGN_TIP_DN_SENTINEL_TANK",
			healer = "DGN_TIP_DN_SENTINEL_HEALER",
			dps = "DGN_TIP_DN_SENTINEL_DPS",
		},
		nalorakk = {
			steps = "DGN_TIP_DN_NALORAKK_STEPS",
			tank = "DGN_TIP_DN_NALORAKK_TANK",
			healer = "DGN_TIP_DN_NALORAKK_HEALER",
			dps = "DGN_TIP_DN_NALORAKK_DPS",
		},
	},
	blindingvale = {
		trinity = {
			steps = "DGN_TIP_BV_TRINITY_STEPS",
			tank = "DGN_TIP_BV_TRINITY_TANK",
			healer = "DGN_TIP_BV_TRINITY_HEALER",
			dps = "DGN_TIP_BV_TRINITY_DPS",
		},
		ikuzz = {
			steps = "DGN_TIP_BV_IKUZZ_STEPS",
			tank = "DGN_TIP_BV_IKUZZ_TANK",
			healer = "DGN_TIP_BV_IKUZZ_HEALER",
			dps = "DGN_TIP_BV_IKUZZ_DPS",
		},
		ruia = {
			steps = "DGN_TIP_BV_RUIA_STEPS",
			tank = "DGN_TIP_BV_RUIA_TANK",
			healer = "DGN_TIP_BV_RUIA_HEALER",
			dps = "DGN_TIP_BV_RUIA_DPS",
		},
		ziekket = {
			steps = "DGN_TIP_BV_ZIEKKET_STEPS",
			tank = "DGN_TIP_BV_ZIEKKET_TANK",
			healer = "DGN_TIP_BV_ZIEKKET_HEALER",
			dps = "DGN_TIP_BV_ZIEKKET_DPS",
		},
	},
	voidscar = {
		tazrah = {
			steps = "DGN_TIP_VA_TAZRAH_STEPS",
			tank = "DGN_TIP_VA_TAZRAH_TANK",
			healer = "DGN_TIP_VA_TAZRAH_HEALER",
			dps = "DGN_TIP_VA_TAZRAH_DPS",
		},
		atroxus = {
			steps = "DGN_TIP_VA_ATROXUS_STEPS",
			tank = "DGN_TIP_VA_ATROXUS_TANK",
			healer = "DGN_TIP_VA_ATROXUS_HEALER",
			dps = "DGN_TIP_VA_ATROXUS_DPS",
		},
		charonus = {
			steps = "DGN_TIP_VA_CHARONUS_STEPS",
			tank = "DGN_TIP_VA_CHARONUS_TANK",
			healer = "DGN_TIP_VA_CHARONUS_HEALER",
			dps = "DGN_TIP_VA_CHARONUS_DPS",
		},
	},
	nexuspoint = {
		kasreth = {
			steps = "DGN_TIP_NX_KASRETH_STEPS",
			tank = "DGN_TIP_NX_KASRETH_TANK",
			healer = "DGN_TIP_NX_KASRETH_HEALER",
			dps = "DGN_TIP_NX_KASRETH_DPS",
		},
		nysarra = {
			steps = "DGN_TIP_NX_NYSARRA_STEPS",
			tank = "DGN_TIP_NX_NYSARRA_TANK",
			healer = "DGN_TIP_NX_NYSARRA_HEALER",
			dps = "DGN_TIP_NX_NYSARRA_DPS",
		},
		lothraxion = {
			steps = "DGN_TIP_NX_LOTHRAXION_STEPS",
			tank = "DGN_TIP_NX_LOTHRAXION_TANK",
			healer = "DGN_TIP_NX_LOTHRAXION_HEALER",
			dps = "DGN_TIP_NX_LOTHRAXION_DPS",
		},
	},
	magisters = {
		arcanotron = {
			steps = "DGN_TIP_MT_ARCANOTRON_STEPS",
			tank = "DGN_TIP_MT_ARCANOTRON_TANK",
			healer = "DGN_TIP_MT_ARCANOTRON_HEALER",
			dps = "DGN_TIP_MT_ARCANOTRON_DPS",
		},
		seranel = {
			steps = "DGN_TIP_MT_SERANEL_STEPS",
			tank = "DGN_TIP_MT_SERANEL_TANK",
			healer = "DGN_TIP_MT_SERANEL_HEALER",
			dps = "DGN_TIP_MT_SERANEL_DPS",
		},
		gemellus = {
			steps = "DGN_TIP_MT_GEMELLUS_STEPS",
			tank = "DGN_TIP_MT_GEMELLUS_TANK",
			healer = "DGN_TIP_MT_GEMELLUS_HEALER",
			dps = "DGN_TIP_MT_GEMELLUS_DPS",
		},
		degentrius = {
			steps = "DGN_TIP_MT_DEGENTRIUS_STEPS",
			tank = "DGN_TIP_MT_DEGENTRIUS_TANK",
			healer = "DGN_TIP_MT_DEGENTRIUS_HEALER",
			dps = "DGN_TIP_MT_DEGENTRIUS_DPS",
		},
	},
	-- Batch 3 (11 jun): de 4 legacy-S1-dungeons. Bron: DBM-Party-WoD/WotLK/
	-- Legion/Dragonflight — bewust de IsPostMidnight-tak (Midnight-revamp-
	-- spells, 12xxxxx-IDs) + Wowhead-tooltips. Zelfde verificatiestatus.
	skyreach = {
		ranjit = {
			steps = "DGN_TIP_SR_RANJIT_STEPS",
			tank = "DGN_TIP_SR_RANJIT_TANK",
			healer = "DGN_TIP_SR_RANJIT_HEALER",
			dps = "DGN_TIP_SR_RANJIT_DPS",
		},
		araknath = {
			steps = "DGN_TIP_SR_ARAKNATH_STEPS",
			tank = "DGN_TIP_SR_ARAKNATH_TANK",
			healer = "DGN_TIP_SR_ARAKNATH_HEALER",
			dps = "DGN_TIP_SR_ARAKNATH_DPS",
		},
		rukhran = {
			steps = "DGN_TIP_SR_RUKHRAN_STEPS",
			tank = "DGN_TIP_SR_RUKHRAN_TANK",
			healer = "DGN_TIP_SR_RUKHRAN_HEALER",
			dps = "DGN_TIP_SR_RUKHRAN_DPS",
		},
		viryx = {
			steps = "DGN_TIP_SR_VIRYX_STEPS",
			tank = "DGN_TIP_SR_VIRYX_TANK",
			healer = "DGN_TIP_SR_VIRYX_HEALER",
			dps = "DGN_TIP_SR_VIRYX_DPS",
		},
	},
	pitofsaron = {
		garfrost = {
			steps = "DGN_TIP_PS_GARFROST_STEPS",
			tank = "DGN_TIP_PS_GARFROST_TANK",
			healer = "DGN_TIP_PS_GARFROST_HEALER",
			dps = "DGN_TIP_PS_GARFROST_DPS",
		},
		krickick = {
			steps = "DGN_TIP_PS_KRICKICK_STEPS",
			tank = "DGN_TIP_PS_KRICKICK_TANK",
			healer = "DGN_TIP_PS_KRICKICK_HEALER",
			dps = "DGN_TIP_PS_KRICKICK_DPS",
		},
		tyrannus = {
			steps = "DGN_TIP_PS_TYRANNUS_STEPS",
			tank = "DGN_TIP_PS_TYRANNUS_TANK",
			healer = "DGN_TIP_PS_TYRANNUS_HEALER",
			dps = "DGN_TIP_PS_TYRANNUS_DPS",
		},
	},
	triumvirate = {
		zuraal = {
			steps = "DGN_TIP_ST_ZURAAL_STEPS",
			tank = "DGN_TIP_ST_ZURAAL_TANK",
			healer = "DGN_TIP_ST_ZURAAL_HEALER",
			dps = "DGN_TIP_ST_ZURAAL_DPS",
		},
		saprish = {
			steps = "DGN_TIP_ST_SAPRISH_STEPS",
			tank = "DGN_TIP_ST_SAPRISH_TANK",
			healer = "DGN_TIP_ST_SAPRISH_HEALER",
			dps = "DGN_TIP_ST_SAPRISH_DPS",
		},
		nezhar = {
			steps = "DGN_TIP_ST_NEZHAR_STEPS",
			tank = "DGN_TIP_ST_NEZHAR_TANK",
			healer = "DGN_TIP_ST_NEZHAR_HEALER",
			dps = "DGN_TIP_ST_NEZHAR_DPS",
		},
		lura = {
			steps = "DGN_TIP_ST_LURA_STEPS",
			tank = "DGN_TIP_ST_LURA_TANK",
			healer = "DGN_TIP_ST_LURA_HEALER",
			dps = "DGN_TIP_ST_LURA_DPS",
		},
	},
	algethar = {
		vexamus = {
			steps = "DGN_TIP_AA_VEXAMUS_STEPS",
			tank = "DGN_TIP_AA_VEXAMUS_TANK",
			healer = "DGN_TIP_AA_VEXAMUS_HEALER",
			dps = "DGN_TIP_AA_VEXAMUS_DPS",
		},
		ancient = {
			steps = "DGN_TIP_AA_ANCIENT_STEPS",
			tank = "DGN_TIP_AA_ANCIENT_TANK",
			healer = "DGN_TIP_AA_ANCIENT_HEALER",
			dps = "DGN_TIP_AA_ANCIENT_DPS",
		},
		crawth = {
			steps = "DGN_TIP_AA_CRAWTH_STEPS",
			tank = "DGN_TIP_AA_CRAWTH_TANK",
			healer = "DGN_TIP_AA_CRAWTH_HEALER",
			dps = "DGN_TIP_AA_CRAWTH_DPS",
		},
		doragosa = {
			steps = "DGN_TIP_AA_DORAGOSA_STEPS",
			tank = "DGN_TIP_AA_DORAGOSA_TANK",
			healer = "DGN_TIP_AA_DORAGOSA_HEALER",
			dps = "DGN_TIP_AA_DORAGOSA_DPS",
		},
	},
}

function ns.GetDungeonBossTips(dungeonKey, bossKey)
	local d = ns.DUNGEON_TIPS and ns.DUNGEON_TIPS[dungeonKey]
	return d and d[bossKey] or nil
end

-- true when at least one boss of this dungeon has tips (Coach uses this to
-- show/hide the per-dungeon "steps coming" note honestly).
function ns.DungeonHasTips(dungeonKey)
	local d = ns.DUNGEON_TIPS and ns.DUNGEON_TIPS[dungeonKey]
	if type(d) ~= "table" then
		return false
	end
	for _ in pairs(d) do
		return true
	end
	return false
end
