--[[
	Midnight Helper — Delve Coach boss 3D previews (PlayerModel + creature IDs).
	IDs from Wowhead nether tooltip API / Icy Veins–linked NPC pages.
]]

local _, ns = ...

---@class MHDelveBossFrame
---@field cam number|nil
---@field x number|nil
---@field y number|nil
---@field z number|nil
---@field facing number|nil

---@class MHDelveBossVisual
---@field creatureId number
---@field label string
---@field cam number|nil
---@field x number|nil
---@field y number|nil
---@field z number|nil
---@field facing number|nil

local DEFAULT_BOSS_FRAME = {
	cam = 0.58,
	x = 0,
	y = 0,
	z = -0.22,
	facing = 0.32,
}

--- Per-creature camera tweaks (large mushrooms, hydras, faceless ones need zoom-out).
local CREATURE_FRAMES = {
	[246621] = { cam = 0.48, z = -0.38 },
	[246680] = { cam = 0.50, z = -0.35 },
	[247114] = { cam = 0.52, z = -0.30 },
	[247910] = { cam = 0.36, z = -0.62, y = -0.05 },
	[248257] = { cam = 0.34, z = -0.58, y = -0.08 },
	[248320] = { cam = 0.36, z = -0.60, y = -0.05 },
	[250939] = { cam = 0.38, z = -0.55 },
	[251032] = { cam = 0.54, z = -0.28 },
	[252352] = { cam = 0.56, z = -0.26 },
	[254772] = { cam = 0.38, z = -0.58 },
	[254769] = { cam = 0.56, z = -0.26 },
	[254773] = { cam = 0.54, z = -0.28 },
	[255108] = { cam = 0.42, z = -0.48 },
	[256683] = { cam = 0.46, z = -0.40 },
	[256817] = { cam = 0.56, z = -0.26 },
	[248676] = { cam = 0.55, z = -0.28 },
}

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

function ns:GetDelveBossFrame(creatureId, bossEntry)
	local frame = {}
	for k, v in pairs(DEFAULT_BOSS_FRAME) do
		frame[k] = v
	end
	local byCreature = creatureId and CREATURE_FRAMES[creatureId]
	if byCreature then
		for k, v in pairs(byCreature) do
			frame[k] = v
		end
	end
	if bossEntry then
		for k, v in pairs(bossEntry) do
			if k == "cam" or k == "x" or k == "y" or k == "z" or k == "facing" then
				frame[k] = v
			end
		end
	end
	return frame
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

function ns:ApplyDelveBossFrameSettings(model, frame)
	if not model or not frame then
		return
	end
	local x = tonumber(frame.x) or 0
	local y = tonumber(frame.y) or 0
	local z = tonumber(frame.z) or -0.22
	local facing = tonumber(frame.facing) or 0.32
	local cam = tonumber(frame.cam) or DEFAULT_BOSS_FRAME.cam

	if model.SetPosition then
		model:SetPosition(x, y, z)
	end
	if model.SetFacing then
		model:SetFacing(facing)
	end
	if model.SetCamDistanceScale then
		model:SetCamDistanceScale(cam)
	end
	if model.SetPortraitZoom then
		pcall(model.SetPortraitZoom, model, 0)
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
end

local function FinishDelveBossCreatureModel(model, creatureId, frame)
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
	ns:ApplyDelveBossFrameSettings(model, frame)

	local function refit()
		if model._mhLoadedCreatureId ~= creatureId then
			return
		end
		ns:ApplyDelveBossFrameSettings(model, frame)
	end
	if C_Timer and C_Timer.After then
		C_Timer.After(0.05, refit)
		C_Timer.After(0.15, refit)
	end
	return true
end

function ns:ApplyDelveBossCreatureModel(model, creatureId, bossEntry)
	if not model then
		return false
	end
	creatureId = tonumber(creatureId)
	if not creatureId or creatureId <= 0 then
		self:ClearDelveBossCreatureModel(model)
		return false
	end

	local frame = self:GetDelveBossFrame(creatureId, bossEntry)

	if model._mhLoadedCreatureId == creatureId and model.IsShown and model:IsShown() then
		self:ApplyDelveBossFrameSettings(model, frame)
		return true
	end

	self:ClearDelveBossCreatureModel(model)
	model._mhPendingCreatureId = creatureId

	if C_Timer and C_Timer.After then
		C_Timer.After(0, function()
			FinishDelveBossCreatureModel(model, creatureId, frame)
		end)
	else
		FinishDelveBossCreatureModel(model, creatureId, frame)
	end
	return true
end
