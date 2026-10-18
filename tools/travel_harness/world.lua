-- Headless test world for MidnightHelper's travel code.
-- ⚠️ FIXTURE: map tree ids are the real uiMap ids MH already uses; parents, instances and world geometry are
-- invented test values (plausible, not measured). They only decide "same continent?" and rough distances.

local W = {}
_G.W = W

-- id = { name, parent, type, inst, ox, oy, w, h }   type: 2 continent, 3 zone, 4 city/sub
local M = {
	-- Kalimdor
	[12] = { "Kalimdor", 947, 2, 1, -12000, -8000, 24000, 24000 },
	[1] = { "Durotar", 12, 3, 1, 0, 0, 3000, 3000 },
	[85] = { "Orgrimmar", 1, 4, 1, 900, 300, 1200, 1000 },
	[10] = { "Northern Barrens", 12, 3, 1, -3000, 0, 3000, 3000 },
	[71] = { "Tanaris", 12, 3, 1, -1500, 9000, 3500, 3500 },
	[74] = { "Caverns of Time", 71, 4, 1, 0, 10000, 800, 800 },
	[1527] = { "Uldum", 12, 3, 1, -5000, 9500, 4000, 4000 },
	[198] = { "Mount Hyjal", 12, 3, 1, -3000, -6000, 3500, 3500 },
	-- Eastern Kingdoms
	[13] = { "Eastern Kingdoms", 947, 2, 0, -10000, -15000, 20000, 30000 },
	[37] = { "Elwynn Forest", 13, 3, 0, 0, 0, 3500, 3500 },
	[84] = { "Stormwind City", 37, 4, 0, 300, -800, 1500, 1500 },
	[17] = { "Blasted Lands", 13, 3, 0, 1000, 6000, 3000, 3000 },
	[18] = { "Tirisfal Glades", 13, 3, 0, 0, -13000, 4000, 4000 },
	[87] = { "Ironforge", 13, 4, 0, 2000, -5000, 900, 900 },
	-- Outland
	[101] = { "Outland", 946, 2, 530, -6000, -6000, 12000, 12000 },
	[108] = { "Terokkar Forest", 101, 3, 530, 0, 0, 4000, 4000 },
	[111] = { "Shattrath City", 108, 4, 530, 500, 500, 1000, 1000 },
	[100] = { "Hellfire Peninsula", 101, 3, 530, 4000, -2000, 4000, 4000 },
	[122] = { "Isle of Quel'Danas", 13, 3, 0, 4000, -16000, 1500, 1500 },
	-- Northrend
	[113] = { "Northrend", 947, 2, 571, -6000, -6000, 12000, 12000 },
	[127] = { "Crystalsong Forest", 113, 3, 571, 0, 0, 2000, 2000 },
	[125] = { "Dalaran", 127, 4, 571, 600, 600, 800, 800 },
	[118] = { "Icecrown", 113, 3, 571, -1500, -4500, 4500, 4500 },
	-- Draenor
	[572] = { "Draenor", 946, 2, 1116, -7000, -7000, 14000, 14000 },
	[588] = { "Ashran", 572, 3, 1116, 4000, -4000, 3000, 3000 },
	[624] = { "Warspear", 588, 4, 1116, 5200, -3000, 800, 800 },
	[622] = { "Stormshield", 588, 4, 1116, 4200, -3800, 800, 800 },
	[542] = { "Spires of Arak", 572, 3, 1116, -2000, 3000, 4000, 4000 },
	[534] = { "Tanaan Jungle", 572, 3, 1116, 0, -5000, 4000, 4000 },
	-- Pandaria
	[424] = { "Pandaria", 947, 2, 870, -6000, -6000, 12000, 12000 },
	[371] = { "The Jade Forest", 424, 3, 870, 2000, 0, 4000, 4000 },
	[388] = { "Townlong Steppes", 424, 3, 870, -4000, -3000, 4000, 4000 },
	[504] = { "Isle of Thunder", 424, 3, 870, -9000, -6000, 3000, 3000 }, -- (really its own instance; fixture)
	-- Broken Isles + Argus
	[619] = { "Broken Isles", 947, 2, 1220, -6000, -6000, 12000, 12000 },
	[630] = { "Azsuna", 619, 3, 1220, -3000, 1000, 4000, 4000 },
	[627] = { "Dalaran", 619, 4, 1220, 0, 0, 800, 800 },
	[905] = { "Argus", 946, 2, 1669, -3000, -3000, 6000, 6000 },
	[882] = { "Eredath", 905, 3, 1669, 0, 0, 3000, 3000 },
	[831] = { "The Vindicaar", 905, 4, 1669, 500, 500, 300, 300 },
	-- Shadowlands
	[1550] = { "The Shadowlands", 946, 2, 2222, -6000, -6000, 12000, 12000 },
	[1670] = { "Oribos", 1550, 4, 2222, 0, 0, 600, 600 },
	[1671] = { "Ring of Transference", 1670, 4, 2222, 100, 100, 400, 400 },
	-- Dragon Isles
	[1978] = { "Dragon Isles", 947, 2, 2444, -6000, -6000, 12000, 12000 },
	[2025] = { "Thaldraszus", 1978, 3, 2444, 2000, 0, 4000, 4000 },
	[2112] = { "Valdrakken", 2025, 4, 2444, 2800, 600, 900, 900 },
	-- Khaz Algar
	[2274] = { "Khaz Algar", 947, 2, 2552, -6000, -6000, 12000, 12000 },
	[2248] = { "Isle of Dorn", 2274, 3, 2552, 2000, -2000, 4000, 4000 },
	[2339] = { "Dornogal", 2248, 4, 2552, 2800, -1000, 900, 900 },
	[2214] = { "The Ringing Deeps", 2274, 3, 2552, 1000, 2500, 4000, 4000 },
	-- Midnight (Quel'Thalas)
	[2537] = { "Quel'Thalas", 947, 2, 2694, -6000, -6000, 12000, 12000 },
	[2395] = { "Eversong Woods", 2537, 3, 2694, 0, 0, 4000, 4000 },
	[2393] = { "Silvermoon City", 2395, 4, 2694, 1200, -1500, 1200, 1200 },
	[2437] = { "Zul'Aman", 2537, 3, 2694, 4000, 1000, 4000, 4000 },
	[2424] = { "Isle of Quel'Danas", 2537, 3, 2694, 0, -6000, 2000, 2000 },
	[2413] = { "Harandar", 2701, 3, 2695, 0, 0, 4000, 4000 },
	[2701] = { "Harandar (continent)", 947, 2, 2695, -6000, -6000, 12000, 12000 },
	[2405] = { "Voidstorm", 2702, 3, 2696, 0, 0, 4000, 4000 },
	[2702] = { "Voidstorm (continent)", 947, 2, 2696, -6000, -6000, 12000, 12000 },
	[2512] = { "The Coiled Isle", 2703, 3, 2697, 0, 0, 3000, 3000 },
	[2703] = { "Coiled Isle (continent)", 947, 2, 2697, -6000, -6000, 12000, 12000 },
	[2509] = { "The Vaults", 2512, 4, 2697, 500, 500, 1500, 1500 },
	[946] = { "Cosmic", nil, 0, nil },
	[947] = { "Azeroth", 946, 1, nil },
}
W.M = M

-- Player state
W.P = { map = 2393, x = 50, y = 50, faction = "Horde", bind = "Orgrimmar", spells = {}, toys = {}, hearth = 1,
	hearthCD = 0, quests = setmetatable({}, { __index = function() return true end }) }

local function world(m, x, y)
	local r = M[m]
	if not (r and r[4] and r[7]) then
		return nil
	end
	return r[4], r[5] + (x / 100) * r[7], r[6] + (y / 100) * r[8]
end
W.world = world

local Vec = {}
Vec.__index = Vec
function Vec:GetXY()
	return self.x, self.y
end
function _G.CreateVector2D(x, y)
	return setmetatable({ x = x, y = y }, Vec)
end

_G.Enum = { UIMapType = { Cosmic = 0, World = 1, Continent = 2, Zone = 3, Dungeon = 4, Micro = 5, Orphan = 6 } }
_G.C_Map = {
	GetBestMapForUnit = function()
		return W.P.map
	end,
	GetMapInfo = function(m)
		local r = M[m]
		if not r then
			return nil
		end
		return { mapID = m, name = r[1], parentMapID = r[2] or 0, mapType = r[3] }
	end,
	GetWorldPosFromMapPos = function(m, v)
		local inst, wx, wy = world(m, v.x * 100, v.y * 100)
		if not inst then
			return nil
		end
		return inst, CreateVector2D(wx, wy)
	end,
	GetPlayerMapPosition = function(m)
		local pinst, px, py = world(W.P.map, W.P.x, W.P.y)
		local r = M[m]
		if not (pinst and r and r[4] == pinst and r[7]) then
			return nil
		end
		return CreateVector2D((px - r[5]) / r[7], (py - r[6]) / r[8])
	end,
	GetMapWorldSize = function(m)
		local r = M[m]
		if r and r[7] then
			return r[7], r[8]
		end
		return 0, 0
	end,
	GetMapLinksForMap = function()
		return {}
	end,
	GetMapChildrenInfo = function()
		return {}
	end,
}
_G.UnitFactionGroup = function()
	return W.P.faction
end
_G.GetBindLocation = function()
	return W.P.bind
end
_G.IsPlayerSpell = function(id)
	return W.P.spells[id] == true
end
_G.PlayerHasToy = function(id)
	return W.P.toys[id] == true
end
_G.C_Spell = {
	GetSpellName = function(id)
		return "Spell " .. id
	end,
}
_G.C_Item = {
	GetItemCount = function(id)
		return id == 6948 and W.P.hearth or 0
	end,
	GetItemCooldown = function()
		return (W.P.hearthCD > 0) and 1000 or 0, W.P.hearthCD, 1
	end,
}
_G.C_QuestLog = {
	IsQuestFlaggedCompleted = function(q)
		return W.P.quests[q] == true
	end,
	GetTitleForQuestID = function()
		return nil
	end,
}
_G.C_ToyBox = { GetToyInfo = function(id)
	return id, "Toy " .. id
end }
_G.time = os.time
_G.date = os.date
_G.issecretvalue = function()
	return false
end
_G.GetTime = os.clock
_G.select = select
return W
