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
---@field portraitZoom number|nil

---@class MHDelveBossVisual
---@field creatureId number
---@field label string
---@field cam number|nil
---@field x number|nil
---@field y number|nil
---@field z number|nil
---@field facing number|nil
---@field portraitZoom number|nil

-- SetCamDistanceScale: higher = camera further = smaller on screen (more body visible).
-- Tuned from in-game Delve Coach screenshots (May 2026).
local DEFAULT_BOSS_FRAME = {
	cam = 1.0,
	x = 0,
	y = 0,
	z = 0,
	facing = 0.32,
	portraitZoom = 0,
}

local BOSS_CAM_MIN = 0.45
local BOSS_CAM_MAX = 2.0
local BOSS_CAM_WHEEL_STEP = 0.07
local MODEL_RETRY_DELAYS = { 0, 0.12, 0.3, 0.6, 1.0, 1.8, 3.0 }

local function GetDelveCoachSettings()
	local s = ns.db and ns.db.ui and ns.db.ui.delveCoach
	return type(s) == "table" and s or nil
end

function ns:GetDelveBossCamOverride(creatureId)
	local s = GetDelveCoachSettings()
	if not s or type(s.bossCam) ~= "table" then
		return nil
	end
	creatureId = tonumber(creatureId)
	if not creatureId then
		return nil
	end
	local cam = tonumber(s.bossCam[creatureId]) or tonumber(s.bossCam[tostring(creatureId)])
	if not cam then
		return nil
	end
	return math.max(BOSS_CAM_MIN, math.min(BOSS_CAM_MAX, cam))
end

function ns:SetDelveBossCamOverride(creatureId, cam)
	local s = GetDelveCoachSettings()
	if not s then
		return
	end
	creatureId = tonumber(creatureId)
	cam = tonumber(cam)
	if not creatureId or not cam then
		return
	end
	if type(s.bossCam) ~= "table" then
		s.bossCam = {}
	end
	s.bossCam[creatureId] = math.max(BOSS_CAM_MIN, math.min(BOSS_CAM_MAX, cam))
end

--- Scroll up = zoom in (model larger); scroll down = zoom out.
function ns:AdjustDelveBossCam(model, creatureId, bossEntry, wheelDelta)
	if not model or not creatureId or not wheelDelta or wheelDelta == 0 then
		return
	end
	creatureId = tonumber(creatureId)
	if not creatureId then
		return
	end
	local frame = self:GetDelveBossFrame(creatureId, bossEntry)
	local cam = tonumber(frame.cam) or DEFAULT_BOSS_FRAME.cam
	if wheelDelta > 0 then
		cam = cam - BOSS_CAM_WHEEL_STEP
	else
		cam = cam + BOSS_CAM_WHEEL_STEP
	end
	self:SetDelveBossCamOverride(creatureId, cam)
	frame.cam = self:GetDelveBossCamOverride(creatureId) or cam
	self:ApplyDelveBossFrameSettings(model, frame)
	return frame.cam
end

--- Per-creature camera tweaks.
local CREATURE_FRAMES = {
	[246621] = { cam = 1.05 },
	[246680] = { cam = 0.86 }, -- Lumenia: too small
	[247114] = { cam = 1.38, z = -0.04 }, -- Jin'Ma: torso close-up
	[247910] = { cam = 1.22, z = -0.10, y = -0.03 }, -- Gyrospore: dark, cap clipped
	[248257] = { cam = 1.18, z = -0.08 }, -- Mycomight
	[248320] = { cam = 1.28, z = -0.10 }, -- Brightthorn: head fills frame
	[250939] = { cam = 1.42, z = -0.08 }, -- Mul'tha'ul: shoulders only
	[251032] = { cam = 0.86, z = -0.02 }, -- Darza: too small / dark
	[252352] = { cam = 1.05 },
	[254772] = { cam = 1.15, z = -0.06, y = -0.02 }, -- Hydrangea
	[254769] = { cam = 1.32 }, -- Garand: torso close-up
	[254773] = { cam = 1.08 }, -- Voidscorned Vagrant
	[255108] = { cam = 0.98 },
	[256683] = { cam = 0.96 },
	[256817] = { cam = 1.35 }, -- Gulkat: torso close-up
	[248676] = { cam = 0.88 }, -- Patram: too small
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
			if k == "cam" or k == "x" or k == "y" or k == "z" or k == "facing" or k == "portraitZoom" then
				frame[k] = v
			end
		end
	end
	local userCam = self:GetDelveBossCamOverride(creatureId)
	if userCam then
		frame.cam = userCam
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

local function CancelBossModelRetries(model)
	if not model then
		return
	end
	model._mhRetryGeneration = (model._mhRetryGeneration or 0) + 1
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
	if model._mhLoadingFs and model._mhLoadingFs.Hide then
		model._mhLoadingFs:Hide()
	end
	ns:ApplyDelveBossFrameSettings(model, frame)

	local function refit()
		if not model or model._mhLoadedCreatureId ~= creatureId then
			return
		end
		local fresh = ns:GetDelveBossFrame(creatureId, model._mhBossEntry)
		ns:ApplyDelveBossFrameSettings(model, fresh)
	end
	if C_Timer and C_Timer.After then
		C_Timer.After(0.05, refit)
		C_Timer.After(0.12, refit)
		C_Timer.After(0.25, refit)
		C_Timer.After(0.45, refit)
	end
	return true
end

local function ScheduleBossModelRetries(model, creatureId, bossEntry)
	if not model or not creatureId or not C_Timer or not C_Timer.After then
		return
	end
	local frame = ns:GetDelveBossFrame(creatureId, bossEntry)
	CancelBossModelRetries(model)
	local generation = model._mhRetryGeneration or 0
	for _, delay in ipairs(MODEL_RETRY_DELAYS) do
		C_Timer.After(delay, function()
			if not model or model._mhRetryGeneration ~= generation then
				return
			end
			if model._mhLoadedCreatureId == creatureId then
				return
			end
			if model._mhPendingCreatureId ~= creatureId then
				model._mhPendingCreatureId = creatureId
			end
			FinishDelveBossCreatureModel(model, creatureId, frame)
		end)
	end
end

function ns:ClearDelveBossCreatureModel(model)
	if not model then
		return
	end
	CancelBossModelRetries(model)
	model._mhPendingCreatureId = nil
	model._mhLoadedCreatureId = nil
	if model.ClearModel then
		pcall(model.ClearModel, model)
	end
	if model.SetCamDistanceScale then
		pcall(model.SetCamDistanceScale, model, 1)
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
	local z = tonumber(frame.z) or 0
	local facing = tonumber(frame.facing) or 0.32
	local cam = tonumber(frame.cam) or DEFAULT_BOSS_FRAME.cam
	local portraitZoom = tonumber(frame.portraitZoom)
	if portraitZoom == nil then
		portraitZoom = DEFAULT_BOSS_FRAME.portraitZoom or 0
	end

	if model.SetPosition then
		model:SetPosition(x, y, z)
	end
	if model.SetFacing then
		model:SetFacing(facing)
	end
	if model.SetAnimation then
		pcall(model.SetAnimation, model, 0, 0)
	end
	if model.SetDoBlend then
		model:SetDoBlend(true)
	end
	if model.SetPortraitZoom then
		pcall(model.SetPortraitZoom, model, portraitZoom)
	end
	if model.SetCamDistanceScale then
		model:SetCamDistanceScale(cam)
	end
	if model.RefreshCamera then
		pcall(model.RefreshCamera, model)
	end
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
	model._mhBossEntry = bossEntry

	if model._mhLoadedCreatureId == creatureId and model.IsShown and model:IsShown() then
		self:ApplyDelveBossFrameSettings(model, frame)
		return true
	end

	CancelBossModelRetries(model)
	self:ClearDelveBossCreatureModel(model)
	model._mhPendingCreatureId = creatureId

	if FinishDelveBossCreatureModel(model, creatureId, frame) then
		return true
	end
	ScheduleBossModelRetries(model, creatureId, bossEntry)
	return true
end
