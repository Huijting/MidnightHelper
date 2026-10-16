local _, ns = ...

--[[
	Midnight Helper — Travel, part 3 of 5: the planner (docs/TRAVEL_DESIGN_2026-10-16.md §2.3). Phase 2, 16 Oct 2026.

	This phase moves ONE question here: "how do I get home (to my capital, or to Silvermoon) from where I stand?".
	It was the Mount run's HomeSteps (MountRun.lua, built today step by step with Rob); the travel plan only had a
	bare "go to your capital" with no place. Both now ask Travel.WayHome, so a portal home, a mage teleport, the
	Hearthstone or a Hearthstone toy is offered the same way for a Mount run, a delve in Midnight or a Codex link
	(Rob: "hearthstone voor alle routes is goed").

	A step is { map, x, y, to, text, via, hearth, useID, isToy, mage, spellID }: no x/y means "something to cast or
	use", not a place (the Mount run shows a button for it). Fail closed everywhere: a Hearthstone only when it is in
	the bags/owned, off cooldown AND the conservative bind check says it lands where it helps; a mage spell only when
	IsPlayerSpell says the character knows it.
]]

ns.Travel = ns.Travel or {}
local T = ns.Travel

--- Mage teleports, by the uiMap they land on. Candidates, checked at run time with IsPlayerSpell, so an id that is
--- wrong is never offered (fails closed). 1259190 = Teleport: Silvermoon City (Delves.lua, Travel Assistant).
--- ✅ GEMETEN on Rob's Horde mage, 16 Oct 2026: C_Spell.GetSpellName(3567) = "Teleport: Orgrimmar", IsPlayerSpell
--- true; GetSpellName(3561) = "Teleport: Stormwind", IsPlayerSpell false (right for a Horde mage).
T.MAGE_TELEPORTS = {
	[85] = 3567, -- Teleport: Orgrimmar
	[84] = 3561, -- Teleport: Stormwind
	[2393] = 1259190, -- Teleport: Silvermoon City (Midnight)
}

local function Fac(capital)
	return capital == 85 and "H" or "A"
end

local function Name(m)
	return (T.MapName and T.MapName(m)) or "?"
end

--- The Hearthstone this character can use right now: useID, isToy, toyName — or nil.
function T.HearthChoice()
	local function Ready(itemID)
		return ns.GetItemCooldownSafe and (ns.GetItemCooldownSafe(itemID) or 0) == 0
	end
	if C_Item and C_Item.GetItemCount and (C_Item.GetItemCount(6948) or 0) > 0 and Ready(6948) then
		return 6948, false, nil
	end
	if PlayerHasToy then
		for _, id in ipairs(ns.MOUNTRUN_HEARTH_TOYS or {}) do
			local okT, has = pcall(PlayerHasToy, id)
			if okT and has and Ready(id) then
				local okN, _, name = false, nil, nil
				if C_ToyBox and C_ToyBox.GetToyInfo then
					okN, _, name = pcall(C_ToyBox.GetToyInfo, id)
				end
				return id, true, (okN and type(name) == "string" and name ~= "") and name or nil
			end
		end
	end
	return nil
end

--- A mage teleport to `goal` this character knows: spellID, name — or nil.
function T.MageTeleportTo(goal)
	local id = T.MAGE_TELEPORTS[goal]
	if not (id and IsPlayerSpell) then
		return nil
	end
	local okK, known = pcall(IsPlayerSpell, id)
	if not (okK and known) then
		return nil
	end
	local name
	if C_Spell and C_Spell.GetSpellName then
		local okN, n = pcall(C_Spell.GetSpellName, id)
		name = okN and n or nil
	end
	return id, name
end

local function HearthStep(pm, place, useID, isToy, toyName)
	local text = toyName and (ns:L("MOUNTRUN_STEP_HEARTH_TOY")):format(toyName, Name(place))
		or (ns:L("MOUNTRUN_STEP_HEARTH")):format(Name(place))
	return { map = pm, to = place, hearth = true, useID = useID, isToy = isToy, text = text }
end

local function MageStep(pm, goal, spellID, spellName)
	return { map = pm, to = goal, mage = true, spellID = spellID,
		text = (ns:L("MOUNTRUN_STEP_MAGE")):format(spellName or "?", Name(goal)) }
end

--- The portal home on map `m` to `capital`, as a step, or nil.
local function HomeRow(m, capital)
	local row = ns.MOUNTRUN_HOME and ns.MOUNTRUN_HOME[m]
	local p = row and row[Fac(capital)]
	if p then
		return { map = m, x = p[1], y = p[2], to = capital, via = row.via,
			text = (ns:L(row.room and "MOUNTRUN_STEP_ROOM" or "MOUNTRUN_STEP_PORTAL")):format(Name(capital)) }
	end
end

--- Steps from where the player stands to `goal` (a capital, 84/85, or Silvermoon 2393). Empty when already there or
--- when nothing is known — the caller then keeps its own first step, as before.
function T.WayHome(goal)
	local pm = T.PlayerMap()
	if not pm or not goal or T.InMap(pm, goal) then
		return {}
	end

	if goal == T.HUB then
		-- To Silvermoon: a mage teleport, a Hearthstone bound there, the Midnight side zones' portals; otherwise home
		-- to the capital and its portal to Silvermoon.
		local spell, sName = T.MageTeleportTo(goal)
		if spell then
			return { MageStep(pm, goal, spell, sName) }
		end
		local useID, isToy, toyName = T.HearthChoice()
		if useID and ns.MHHearthstoneGoesTo and ns.MHHearthstoneGoesTo(Name(goal)) then
			return { HearthStep(pm, goal, useID, isToy, toyName) }
		end
		for m, list in pairs(ns.MOUNTRUN_TO_SILVERMOON or {}) do
			if T.InMap(pm, m) then
				local out = {}
				for _, f in ipairs(list) do
					out[#out + 1] = { map = f[1], x = f[2], y = f[3], to = f.to,
						text = (ns:L(f.den and "MOUNTRUN_STEP_DEN" or "MOUNTRUN_STEP_PORTAL")):format(Name(f.to)) }
				end
				return out
			end
		end
		local capital = T.MyCapital()
		local hub = ns.MOUNTRUN_HUBS and ns.MOUNTRUN_HUBS.P_SILVERMOON
		local p = hub and hub[Fac(capital)]
		if not p then
			return {}
		end
		local out = T.WayHome(capital)
		out[#out + 1] = { map = p[1], x = p[2], y = p[3], to = T.HUB,
			text = (ns:L("MOUNTRUN_STEP_PORTAL")):format(Name(T.HUB)) }
		return out
	end

	local capital = goal
	-- 1. A portal home right here: no cooldown spent.
	for m in pairs(ns.MOUNTRUN_HOME or {}) do
		if T.InMap(pm, m) and HomeRow(m, capital) then
			return { HomeRow(m, capital) }
		end
	end
	-- 2. A mage teleport home (no cooldown either).
	local spell, sName = T.MageTeleportTo(capital)
	if spell then
		return { MageStep(pm, capital, spell, sName) }
	end
	-- 3. The Hearthstone or a toy, only when it lands at the capital, or in Silvermoon with the portal room after it.
	local useID, isToy, toyName = T.HearthChoice()
	if useID and ns.MHHearthstoneGoesTo then
		if ns.MHHearthstoneGoesTo(Name(capital)) then
			return { HearthStep(pm, capital, useID, isToy, toyName) }
		end
		if ns.MHHearthstoneGoesTo(Name(T.HUB)) and HomeRow(T.HUB, capital) then
			return { HearthStep(pm, T.HUB, useID, isToy, toyName), HomeRow(T.HUB, capital) }
		end
	end
	-- 4. A Midnight side zone: to Silvermoon first, then home from there.
	local pre, from = {}, pm
	for m, list in pairs(ns.MOUNTRUN_TO_SILVERMOON or {}) do
		if T.InMap(pm, m) then
			for _, f in ipairs(list) do
				pre[#pre + 1] = { map = f[1], x = f[2], y = f[3], to = f.to,
					text = (ns:L(f.den and "MOUNTRUN_STEP_DEN" or "MOUNTRUN_STEP_PORTAL")):format(Name(f.to)) }
			end
			from = T.HUB
			break
		end
	end
	for m in pairs(ns.MOUNTRUN_HOME or {}) do
		if T.InMap(from, m) and HomeRow(m, capital) then
			pre[#pre + 1] = HomeRow(m, capital)
			return pre
		end
	end
	-- 5. Not in a hub, but on a continent that has one: fly to the nearest. Never on the capital's own continent.
	local pc = T.Continent(from)
	if pc and pc ~= T.Continent(capital) then
		local pcont, px, py
		local mx, my = T.PlayerXY(from)
		if mx then
			pcont, px, py = T.WorldXY(from, mx, my)
		end
		local best, bestD
		for m, row in pairs(ns.MOUNTRUN_HOME or {}) do
			local p = row[Fac(capital)]
			if p and T.Continent(m) == pc then
				local d = math.huge - 1
				local hcont, hx, hy = T.WorldXY(m, p[1], p[2])
				if pcont and hcont == pcont then
					d = (hx - px) ^ 2 + (hy - py) ^ 2
				end
				if not bestD or d < bestD then
					best, bestD = m, d
				end
			end
		end
		if best then
			local row = ns.MOUNTRUN_HOME[best]
			local p = row[Fac(capital)]
			pre[#pre + 1] = { map = best, x = p[1], y = p[2], to = capital, via = row.via,
				text = (ns:L("MOUNTRUN_STEP_HOME_FAR")):format(Name(best), Name(capital)) }
			return pre
		end
	end
	return {}
end
