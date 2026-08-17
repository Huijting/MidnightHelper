local _, ns = ...

--[[
	Midnight Helper — the whole way there, not the first step of it.

	Rob, 17 aug, after an afternoon of arrows that each answered one hop:

	  "Een pijl naar de nearest FP of ingang van de vault en dan daarbinnen een pijl
	   naar de underbelly of naar een van de 3 interne flight points daar die me dan
	   naar het dichtstbijzijnde fp laat vliegen in de vault om in de underbelly te
	   komen."

	Everything before this answered exactly one leg — walk to a flight master, board,
	and the arrow jumps to the destination — which is why a target two hops away came
	out as a static label saying "other continent".

	⚠️ THIS DELIBERATELY DOES NOT TOUCH THE ARROW. Three separate faults today came
	from changing routing in one place and forgetting another, and the arrow's leg
	state machine is the most tangled part of it. So this computes the plan and shows
	it; the arrow keeps doing what it already does well, which is the first step.
	Wiring the arrow to walk the plan is the next job, on a day with more than an hour
	in it.

	⚠️ AND THE VAULTS' INNER HOPS ARE NOT FLIGHT POINTS. Rob's screenshot settled that:
	the Amani Windcaller is a GOSSIP npc offering "Fly me to the Eastern Amani Outpost"
	and "Fly me to the Northern Amani Bulwark". There is no taxi node to route to, so a
	step here can be "walk to this NPC and pick this line" — which is a kind of step the
	old one-leg code had no way to express at all.
]]

--- Hand-built links that the flight network does not model. Each one says what the
--- player has to DO, because "go to 49.99/61.93" is not an instruction if the thing
--- waiting there is a conversation.
---
--- Sources are named per entry. Nothing here is inferred from another entry.
local LINKS = {
	--- ✅ MEASURED from Rob's screenshot, 17 aug: the Windcaller stands at 49.99/61.93
	--- in the Vaults, and its gossip offers exactly these two destinations.
	{
		kind = "gossip",
		fromMap = 2509,
		x = 49.99,
		y = 61.93,
		npc = "Amani Windcaller",
		optionKey = "PLAN_OPT_NORTHERN_BULWARK",
		reaches = { 2509 },
		note = "PLAN_NOTE_WINDCALLER",
		source = "rob-screenshot-17aug",
	},
	--- Method, 10 aug: one entrance, near the Northern Amani Bulwark. Unverified.
	{
		kind = "walk",
		fromMap = 2509,
		toMap = 2613,
		x = 45.19,
		y = 11.15,
		labelKey = "ACH_STEP_UNDERBELLY_WAY_IN",
		source = "method-10aug",
	},
}

--- Which map is "inside" which, so a plan can tell that the Underbelly is reached
--- through the Vaults rather than flown to. Only the 12.1 chain — this is not an
--- attempt at a world model.
local INSIDE = {
	[2613] = 2509, -- the Underbelly sits inside the Vaults
	[2509] = 2512, -- the Vaults sit on the Coiled Isle
}

local function PlayerMap()
	if C_Map and C_Map.GetBestMapForUnit then
		local ok, m = pcall(C_Map.GetBestMapForUnit, "player")
		if ok then
			return m
		end
	end
	return nil
end

--- The chain of maps from `target` outward, nearest container first.
local function ContainerChain(mapID)
	local out, seen = {}, {}
	local m = mapID
	while INSIDE[m] and not seen[m] do
		seen[m] = true
		m = INSIDE[m]
		out[#out + 1] = m
	end
	return out
end

--- An ordered list of steps to reach (mapID, x, y) from where the player stands.
---
--- Each step: { kind, mapID, x, y, label, detail, source }. `kind` is one of
--- "portal", "fly", "gossip", "walk", "arrive". Every step that has a place carries a
--- real coordinate, so the caller can make each one clickable; a step without one is
--- an instruction, never a guess.
---
--- @return table|nil steps, string|nil why
function ns.BuildTravelPlan(targetMap, x, y, targetName)
	targetMap = tonumber(targetMap)
	if not targetMap then
		return nil, "PLAN_NO_TARGET"
	end
	local here = PlayerMap()
	if not here then
		return nil, "PLAN_NO_POSITION"
	end

	local steps = {}
	local chain = ContainerChain(targetMap)

	-- Is the player already inside the chain? If so we only need the tail of it.
	local startAt = nil
	if here == targetMap then
		startAt = 0
	else
		for i, m in ipairs(chain) do
			if m == here then
				startAt = i
				break
			end
		end
	end

	--- Not in the chain at all: the first job is reaching the outermost container.
	--- The portal table already knows the way in, and already refuses to name a
	--- portal this character has not unlocked — reused rather than re-derived.
	if not startAt then
		local outermost = chain[#chain] or targetMap
		-- ns.MHPortalUsable, not a name I expected it to have: checked rather than
		-- assumed, because a wrong function name here would silently drop every
		-- portal from every plan and look like "there is no portal".
		if ns.MIDNIGHT_PORTALS and ns.MHPortalUsable then
			for _, p in ipairs(ns.MIDNIGHT_PORTALS) do
				if p.toID == outermost and ns.MHPortalUsable(p) then
					steps[#steps + 1] = {
						kind = "portal",
						mapID = p.mapID,
						x = p.x,
						y = p.y,
						label = p.name,
						source = "MIDNIGHT_PORTALS",
					}
					break
				end
			end
		end
		-- Failing a portal, the flight network is the honest fallback, and it can
		-- only speak about places it has. Silence beats a guessed hop.
		if #steps == 0 and ns.GetNearestFlightPoint then
			local ok, fp = pcall(ns.GetNearestFlightPoint, outermost)
			if ok and type(fp) == "string" and fp:find("%w") then
				steps[#steps + 1] = {
					kind = "fly",
					label = fp,
					detail = "PLAN_DETAIL_FLY_TO",
					source = "FLIGHT_POINTS",
				}
			end
		end
		startAt = #chain
	end

	-- Walk inward: for each container we are not yet in, add the way in.
	for i = startAt, 1, -1 do
		local intoMap = (i == 1) and targetMap or chain[i - 1]
		local added = false
		for _, link in ipairs(LINKS) do
			if link.kind == "walk" and link.fromMap == chain[i] and link.toMap == intoMap then
				steps[#steps + 1] = {
					kind = "walk",
					mapID = link.fromMap,
					x = link.x,
					y = link.y,
					label = link.labelKey,
					localized = true,
					source = link.source,
				}
				added = true
			end
		end

		--- ⚠️ THE GAP ROB FOUND BY ASKING WHERE TO STAND. LINKS has the Underbelly
		--- door and nothing for the Coiled Isle → Vaults step, so a plan started
		--- outside the Vaults silently skipped the one door the player is actually
		--- looking for.
		---
		--- Not fixed by typing a coordinate. The client knows its own doors:
		--- C_Map.GetMapLinksForMap was already measured on 14 aug and reported THREE
		--- ways from the isle into the Vaults, where every guide describes one. A
		--- single hardcoded door would be correct and possibly the one across the
		--- island, so we ask, and pick the nearest to where the player stands.
		if not added then
			local best, bx, by
			if C_Map and C_Map.GetMapLinksForMap then
				local ok, links = pcall(C_Map.GetMapLinksForMap, chain[i])
				if ok and type(links) == "table" then
					local px, py
					if here == chain[i] and C_Map.GetPlayerMapPosition then
						local okP, pos = pcall(C_Map.GetPlayerMapPosition, chain[i], "player")
						if okP and pos and pos.GetXY then
							local okXY, a, b = pcall(pos.GetXY, pos)
							if okXY and a then
								px, py = a * 100, b * 100
							end
						end
					end
					for _, link in ipairs(links) do
						if link.linkedUiMapID == intoMap and link.position then
							local okXY, a, b = pcall(link.position.GetXY, link.position)
							if okXY and a then
								local lx, ly = a * 100, b * 100
								if not best then
									best, bx, by = link, lx, ly
								elseif px then
									local d1 = (lx - px) ^ 2 + (ly - py) ^ 2
									local d2 = (bx - px) ^ 2 + (by - py) ^ 2
									if d1 < d2 then
										best, bx, by = link, lx, ly
									end
								end
							end
						end
					end
				end
			end
			if best then
				steps[#steps + 1] = {
					kind = "walk",
					mapID = chain[i],
					x = tonumber(("%.2f"):format(bx)),
					y = tonumber(("%.2f"):format(by)),
					label = "PLAN_STEP_DOOR",
					localized = true,
					source = "C_Map.GetMapLinksForMap",
				}
			end
			-- No link and no hardcoded door: say nothing. A plan with a hole in it is
			-- honest; a plan with an invented door is what today kept producing.
		end
	end

	--- A gossip hop inside the container we are heading through. Offered rather than
	--- required: it shortens the walk, and saying so is more useful than pretending
	--- there is only one way.
	for _, link in ipairs(LINKS) do
		if link.kind == "gossip" then
			local relevant = false
			for _, m in ipairs(chain) do
				if m == link.fromMap then
					relevant = true
				end
			end
			if relevant or here == link.fromMap then
				steps[#steps + 1] = {
					kind = "gossip",
					mapID = link.fromMap,
					x = link.x,
					y = link.y,
					label = link.npc,
					detail = link.optionKey,
					note = link.note,
					optional = true,
					source = link.source,
				}
			end
		end
	end

	steps[#steps + 1] = {
		kind = "arrive",
		mapID = targetMap,
		x = tonumber(x),
		y = tonumber(y),
		label = targetName,
	}

	if #steps <= 1 then
		return nil, "PLAN_ALREADY_THERE"
	end
	return steps
end

local function L(key)
	return (ns.L and ns:L(key)) or key
end

--- Print a plan with every place clickable. Chat rather than a frame, for now: a
--- numbered list that survives being read twice is worth more today than a panel
--- that has to be designed.
function ns.PrintTravelPlan(targetMap, x, y, targetName)
	local steps, why = ns.BuildTravelPlan(targetMap, x, y, targetName)
	if not steps then
		print(("|cffffcc00%s|r %s"):format(L("PRINT_PREFIX"), L(why or "PLAN_NO_TARGET")))
		return
	end
	print(("|cffffcc00%s|r %s"):format(L("PRINT_PREFIX"),
		(L("PLAN_HEADER")):format(targetName or "?")))
	local n = 0
	for _, s in ipairs(steps) do
		n = n + 1
		local label = s.localized and L(s.label) or (s.label or "?")
		local where = ""
		if s.mapID and s.x and s.y and ns.GetWayLinkMarkup then
			where = "  " .. ns:GetWayLinkMarkup(s.mapID, s.x, s.y, label)
			label = ""
		end
		local extra = ""
		if s.detail then
			extra = " |cff8a8f98" .. L(s.detail) .. "|r"
		end
		if s.optional then
			extra = extra .. " |cff8a8f98(" .. L("PLAN_OPTIONAL") .. ")|r"
		end
		print(("   %d. %s%s%s%s"):format(n, L("PLAN_KIND_" .. s.kind:upper()),
			label ~= "" and (" " .. label) or "", where, extra))
		if s.note then
			print("      |cff8a8f98" .. L(s.note) .. "|r")
		end
	end
end
