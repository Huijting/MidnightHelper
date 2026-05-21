--[[
	Midnight Helper — Delve Coach boss 3D previews (PlayerModel + creature IDs).
	IDs from Wowhead nether tooltip API / Icy Veins–linked NPC pages.
]]

local _, ns = ...

---@class MHDelveBossVisual
---@field creatureId number
---@field label string

---@type table<string, MHDelveBossVisual[]>
ns.DELVE_BOSS_SHOWCASE = {
	shadow_enclave = {
		{ creatureId = 252352, label = "Lord Antenorian" },
	},
	collegiate_calamity = {
		{ creatureId = 254772, label = "Hydrangea" },
		{ creatureId = 254769, label = "Infiltrator Garand" },
		{ creatureId = 254773, label = "Voidscorned Vagrant" },
	},
	the_darkway = {
		{ creatureId = 256817, label = "Infiltrator Gulkat" },
	},
	parhelion_plaza = {
		{ creatureId = 246621, label = "Gladius Slaurna" },
	},
	atal_aman = {
		{ creatureId = 247114, label = "Spiritflayer Jin'Ma" },
	},
	twilight_crypts = {
		{ creatureId = 251032, label = "Blademaster Darza" },
	},
	gulf_of_memory = {
		{ creatureId = 246680, label = "Lumenia" },
		{ creatureId = 250939, label = "Mul'tha'ul" },
	},
	grudge_pit = {
		-- Brightthorn / Mycomight: no dedicated Wowhead NPC yet (DBM encounter files still TODO).
		-- 248320 = Unstoppable Thornmaw <Spawn of Brightthorn>; 248257 = Fungarian [PH] placeholder.
		{ creatureId = 248320, label = "Brightthorn" },
		{ creatureId = 247910, label = "Gyrospore" },
		{ creatureId = 248257, label = "Mycomight" },
	},
	sunkiller_sanctum = {
		{ creatureId = 256683, label = "Esuritus" },
	},
	shadowguard_point = {
		{ creatureId = 248676, label = "Chief-Arcanist Patram" },
	},
	torments_rise = {
		{ creatureId = 255108, label = "Nullaeus" },
	},
}

function ns:GetDelveBossShowcase(entryId)
	if not entryId then
		return nil
	end
	return ns.DELVE_BOSS_SHOWCASE[entryId]
end

function ns:GetDelveBossShowcaseIndex(entryId)
	local s = ns.db and ns.db.ui and ns.db.ui.delveCoach
	if type(s) ~= "table" then
		return 1
	end
	if type(s.bossIndex) ~= "table" then
		s.bossIndex = {}
	end
	local idx = tonumber(s.bossIndex[entryId]) or 1
	return math.max(1, idx)
end

function ns:SetDelveBossShowcaseIndex(entryId, index)
	local bosses = self:GetDelveBossShowcase(entryId)
	if not bosses or #bosses == 0 then
		return
	end
	index = math.max(1, math.min(#bosses, tonumber(index) or 1))
	local s = ns.db and ns.db.ui and ns.db.ui.delveCoach
	if type(s) == "table" then
		if type(s.bossIndex) ~= "table" then
			s.bossIndex = {}
		end
		s.bossIndex[entryId] = index
	end
end

function ns:ClearDelveBossCreatureModel(model)
	if not model then
		return
	end
	model._mhPendingCreatureId = nil
	model._mhLoadedCreatureId = nil
	if model.SetCreature then
		pcall(model.SetCreature, model, 0)
	end
	if model.ClearModel then
		pcall(model.ClearModel, model)
	end
	if model.SetAnimation then
		pcall(model.SetAnimation, model, 0, 0)
	end
	model:Hide()
end

local function FinishDelveBossCreatureModel(model, creatureId)
	if not model or model._mhPendingCreatureId ~= creatureId then
		return false
	end

	local ok = pcall(function()
		if model.SetCreatureData then
			model:SetCreatureData(creatureId)
		elseif model.SetCreature then
			model:SetCreature(creatureId)
		else
			error("no SetCreature")
		end
	end)

	if not ok or model._mhPendingCreatureId ~= creatureId then
		ns:ClearDelveBossCreatureModel(model)
		return false
	end

	model._mhLoadedCreatureId = creatureId
	model:Show()
	if model.SetPosition then
		model:SetPosition(0, 0, -0.35)
	end
	if model.SetFacing then
		model:SetFacing(0.35)
	end
	if model.SetCamDistanceScale then
		model:SetCamDistanceScale(0.82)
	end
	if model.SetAnimation then
		pcall(model.SetAnimation, model, 0, 0)
	end
	if model.SetDoBlend then
		model:SetDoBlend(true)
	end
	if model.RefreshCamera then
		pcall(model.RefreshCamera, model)
	end
	return true
end

function ns:ApplyDelveBossCreatureModel(model, creatureId)
	if not model then
		return false
	end
	creatureId = tonumber(creatureId)
	if not creatureId or creatureId <= 0 then
		self:ClearDelveBossCreatureModel(model)
		return false
	end

	if model._mhLoadedCreatureId == creatureId and model.IsShown and model:IsShown() then
		return true
	end

	self:ClearDelveBossCreatureModel(model)
	model._mhPendingCreatureId = creatureId

	if C_Timer and C_Timer.After then
		C_Timer.After(0, function()
			FinishDelveBossCreatureModel(model, creatureId)
		end)
	else
		FinishDelveBossCreatureModel(model, creatureId)
	end
	return true
end
