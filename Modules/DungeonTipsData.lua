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
		},
		emberdawn = {
			steps = "DGN_TIP_WS_EMBER_STEPS",
			tank = "DGN_TIP_WS_EMBER_TANK",
			healer = "DGN_TIP_WS_EMBER_HEALER",
		},
		kroluk = {
			steps = "DGN_TIP_WS_KROLUK_STEPS",
			tank = "DGN_TIP_WS_KROLUK_TANK",
			healer = "DGN_TIP_WS_KROLUK_HEALER",
		},
		restlessheart = {
			steps = "DGN_TIP_WS_HEART_STEPS",
			tank = "DGN_TIP_WS_HEART_TANK",
			healer = "DGN_TIP_WS_HEART_HEALER",
		},
	},
	maisara = {
		murojin = {
			steps = "DGN_TIP_MC_MUROJIN_STEPS",
			tank = "DGN_TIP_MC_MUROJIN_TANK",
			healer = "DGN_TIP_MC_MUROJIN_HEALER",
		},
		vordaza = {
			steps = "DGN_TIP_MC_VORDAZA_STEPS",
			tank = "DGN_TIP_MC_VORDAZA_TANK",
			healer = "DGN_TIP_MC_VORDAZA_HEALER",
		},
		raktul = {
			steps = "DGN_TIP_MC_RAKTUL_STEPS",
			tank = "DGN_TIP_MC_RAKTUL_TANK",
			healer = "DGN_TIP_MC_RAKTUL_HEALER",
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
		},
		zaen = {
			steps = "DGN_TIP_MR_ZAEN_STEPS",
			tank = "DGN_TIP_MR_ZAEN_TANK",
			healer = "DGN_TIP_MR_ZAEN_HEALER",
		},
		xathuux = {
			steps = "DGN_TIP_MR_XATHUUX_STEPS",
			tank = "DGN_TIP_MR_XATHUUX_TANK",
			healer = "DGN_TIP_MR_XATHUUX_HEALER",
		},
		lithiel = {
			steps = "DGN_TIP_MR_LITHIEL_STEPS",
			tank = "DGN_TIP_MR_LITHIEL_TANK",
			healer = "DGN_TIP_MR_LITHIEL_HEALER",
		},
	},
	nalorakk = {
		hoardmonger = {
			steps = "DGN_TIP_DN_HOARDMONGER_STEPS",
			tank = "DGN_TIP_DN_HOARDMONGER_TANK",
			healer = "DGN_TIP_DN_HOARDMONGER_HEALER",
		},
		sentinel = {
			steps = "DGN_TIP_DN_SENTINEL_STEPS",
			tank = "DGN_TIP_DN_SENTINEL_TANK",
			healer = "DGN_TIP_DN_SENTINEL_HEALER",
		},
		nalorakk = {
			steps = "DGN_TIP_DN_NALORAKK_STEPS",
			tank = "DGN_TIP_DN_NALORAKK_TANK",
			healer = "DGN_TIP_DN_NALORAKK_HEALER",
		},
	},
	blindingvale = {
		trinity = {
			steps = "DGN_TIP_BV_TRINITY_STEPS",
			tank = "DGN_TIP_BV_TRINITY_TANK",
			healer = "DGN_TIP_BV_TRINITY_HEALER",
		},
		ikuzz = {
			steps = "DGN_TIP_BV_IKUZZ_STEPS",
			tank = "DGN_TIP_BV_IKUZZ_TANK",
			healer = "DGN_TIP_BV_IKUZZ_HEALER",
		},
		ruia = {
			steps = "DGN_TIP_BV_RUIA_STEPS",
			tank = "DGN_TIP_BV_RUIA_TANK",
			healer = "DGN_TIP_BV_RUIA_HEALER",
		},
		ziekket = {
			steps = "DGN_TIP_BV_ZIEKKET_STEPS",
			tank = "DGN_TIP_BV_ZIEKKET_TANK",
			healer = "DGN_TIP_BV_ZIEKKET_HEALER",
		},
	},
	voidscar = {
		tazrah = {
			steps = "DGN_TIP_VA_TAZRAH_STEPS",
			tank = "DGN_TIP_VA_TAZRAH_TANK",
			healer = "DGN_TIP_VA_TAZRAH_HEALER",
		},
		atroxus = {
			steps = "DGN_TIP_VA_ATROXUS_STEPS",
			tank = "DGN_TIP_VA_ATROXUS_TANK",
			healer = "DGN_TIP_VA_ATROXUS_HEALER",
		},
		charonus = {
			steps = "DGN_TIP_VA_CHARONUS_STEPS",
			tank = "DGN_TIP_VA_CHARONUS_TANK",
			healer = "DGN_TIP_VA_CHARONUS_HEALER",
		},
	},
	nexuspoint = {
		kasreth = {
			steps = "DGN_TIP_NX_KASRETH_STEPS",
			tank = "DGN_TIP_NX_KASRETH_TANK",
			healer = "DGN_TIP_NX_KASRETH_HEALER",
		},
		nysarra = {
			steps = "DGN_TIP_NX_NYSARRA_STEPS",
			tank = "DGN_TIP_NX_NYSARRA_TANK",
			healer = "DGN_TIP_NX_NYSARRA_HEALER",
		},
		lothraxion = {
			steps = "DGN_TIP_NX_LOTHRAXION_STEPS",
			tank = "DGN_TIP_NX_LOTHRAXION_TANK",
			healer = "DGN_TIP_NX_LOTHRAXION_HEALER",
		},
	},
	magisters = {
		arcanotron = {
			steps = "DGN_TIP_MT_ARCANOTRON_STEPS",
			tank = "DGN_TIP_MT_ARCANOTRON_TANK",
			healer = "DGN_TIP_MT_ARCANOTRON_HEALER",
		},
		seranel = {
			steps = "DGN_TIP_MT_SERANEL_STEPS",
			tank = "DGN_TIP_MT_SERANEL_TANK",
			healer = "DGN_TIP_MT_SERANEL_HEALER",
		},
		gemellus = {
			steps = "DGN_TIP_MT_GEMELLUS_STEPS",
			tank = "DGN_TIP_MT_GEMELLUS_TANK",
			healer = "DGN_TIP_MT_GEMELLUS_HEALER",
		},
		degentrius = {
			steps = "DGN_TIP_MT_DEGENTRIUS_STEPS",
			tank = "DGN_TIP_MT_DEGENTRIUS_TANK",
			healer = "DGN_TIP_MT_DEGENTRIUS_HEALER",
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
		},
		araknath = {
			steps = "DGN_TIP_SR_ARAKNATH_STEPS",
			tank = "DGN_TIP_SR_ARAKNATH_TANK",
			healer = "DGN_TIP_SR_ARAKNATH_HEALER",
		},
		rukhran = {
			steps = "DGN_TIP_SR_RUKHRAN_STEPS",
			tank = "DGN_TIP_SR_RUKHRAN_TANK",
			healer = "DGN_TIP_SR_RUKHRAN_HEALER",
		},
		viryx = {
			steps = "DGN_TIP_SR_VIRYX_STEPS",
			tank = "DGN_TIP_SR_VIRYX_TANK",
			healer = "DGN_TIP_SR_VIRYX_HEALER",
		},
	},
	pitofsaron = {
		garfrost = {
			steps = "DGN_TIP_PS_GARFROST_STEPS",
			tank = "DGN_TIP_PS_GARFROST_TANK",
			healer = "DGN_TIP_PS_GARFROST_HEALER",
		},
		krickick = {
			steps = "DGN_TIP_PS_KRICKICK_STEPS",
			tank = "DGN_TIP_PS_KRICKICK_TANK",
			healer = "DGN_TIP_PS_KRICKICK_HEALER",
		},
		tyrannus = {
			steps = "DGN_TIP_PS_TYRANNUS_STEPS",
			tank = "DGN_TIP_PS_TYRANNUS_TANK",
			healer = "DGN_TIP_PS_TYRANNUS_HEALER",
		},
	},
	triumvirate = {
		zuraal = {
			steps = "DGN_TIP_ST_ZURAAL_STEPS",
			tank = "DGN_TIP_ST_ZURAAL_TANK",
			healer = "DGN_TIP_ST_ZURAAL_HEALER",
		},
		saprish = {
			steps = "DGN_TIP_ST_SAPRISH_STEPS",
			tank = "DGN_TIP_ST_SAPRISH_TANK",
			healer = "DGN_TIP_ST_SAPRISH_HEALER",
		},
		nezhar = {
			steps = "DGN_TIP_ST_NEZHAR_STEPS",
			tank = "DGN_TIP_ST_NEZHAR_TANK",
			healer = "DGN_TIP_ST_NEZHAR_HEALER",
		},
		lura = {
			steps = "DGN_TIP_ST_LURA_STEPS",
			tank = "DGN_TIP_ST_LURA_TANK",
			healer = "DGN_TIP_ST_LURA_HEALER",
		},
	},
	algethar = {
		vexamus = {
			steps = "DGN_TIP_AA_VEXAMUS_STEPS",
			tank = "DGN_TIP_AA_VEXAMUS_TANK",
			healer = "DGN_TIP_AA_VEXAMUS_HEALER",
		},
		ancient = {
			steps = "DGN_TIP_AA_ANCIENT_STEPS",
			tank = "DGN_TIP_AA_ANCIENT_TANK",
			healer = "DGN_TIP_AA_ANCIENT_HEALER",
		},
		crawth = {
			steps = "DGN_TIP_AA_CRAWTH_STEPS",
			tank = "DGN_TIP_AA_CRAWTH_TANK",
			healer = "DGN_TIP_AA_CRAWTH_HEALER",
		},
		doragosa = {
			steps = "DGN_TIP_AA_DORAGOSA_STEPS",
			tank = "DGN_TIP_AA_DORAGOSA_TANK",
			healer = "DGN_TIP_AA_DORAGOSA_HEALER",
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
