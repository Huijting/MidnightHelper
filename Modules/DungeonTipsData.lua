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
