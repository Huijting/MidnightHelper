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
--- ✅ THE WHOLE AMANI WINDCALLER NETWORK, MEASURED 18 aug.
---
--- Rob walked the circuit with `/mh here`, targeting each NPC and each landing spot,
--- which is the first time this addon has had all three hubs rather than the one he
--- happened to be standing next to. Yesterday the plan always took the northern hop
--- because the Underbelly door is northern — a guess that happened to be right.
---
--- It is now arithmetic. Door at 45.19/11.15 against the three landings:
---   northern 41.25/23.45 → ~12.9      eastern 54.36/39.96 → ~30.2
---   foothold 50.03/61.93 → ~51.0
--- Northern wins by a distance no measurement error is going to close.
---
--- ⚠️ The Windcaller and its landing spot are DIFFERENT places and both are recorded.
--- You talk to the NPC; you arrive at the landing. Collapsing them into one point
--- would put the "where does this hop leave me" calculation a few units off, which is
--- exactly the size of error that picks the wrong hub for a target between two of them.
ns.AMANI_HUBS = {
	{ key = "foothold", npcX = 50.03, npcY = 61.93 },
	{ key = "eastern", npcX = 54.25, npcY = 39.41, landX = 54.36, landY = 39.96,
		optionKey = "PLAN_OPT_EASTERN_OUTPOST" },
	{ key = "northern", npcX = 41.53, npcY = 23.34, landX = 41.25, landY = 23.45,
		optionKey = "PLAN_OPT_NORTHERN_BULWARK" },
}

--- Which hub leaves you nearest `(x, y)`, and which Windcaller is nearest the player.
--- @return table|nil best, table|nil nearestNpc
local function ChooseHub(x, y, px, py)
	local best, bestD, near, nearD
	for _, hub in ipairs(ns.AMANI_HUBS) do
		if hub.landX and x then
			local d = (hub.landX - x) ^ 2 + (hub.landY - y) ^ 2
			if not bestD or d < bestD then
				best, bestD = hub, d
			end
		end
		if px then
			local d = (hub.npcX - px) ^ 2 + (hub.npcY - py) ^ 2
			if not nearD or d < nearD then
				near, nearD = hub, d
			end
		end
	end
	return best, near
end

local LINKS = {
	--- Method, 10 aug: one entrance to the Underbelly, and they place it "close to the
	--- Northern Amani Bulwark flight point". Unverified, but the coordinate agrees with
	--- itself: 11.15 is the far north of the map.
	---
	--- ⚠️ `via` is the fix for an ordering mistake Rob caught immediately. The first
	--- version emitted the Windcaller as a loose extra step AFTER the door, tagged
	--- "optional, saves a walk" — so a plan read "go to the far north of the map" and
	--- then, too late, "by the way, there is a man who flies you there".
	---
	--- Standing beside that NPC, Rob said what the plan should obviously be: use the
	--- inner hop to reach the northern part, then the door. He is right, and the
	--- reason the code got it wrong is that a gossip hop was bolted on rather than
	--- attached to the thing it serves. Now it belongs to the door.
	{
		kind = "walk",
		fromMap = 2509,
		toMap = 2613,
		x = 45.19,
		y = 11.15,
		labelKey = "ACH_STEP_UNDERBELLY_WAY_IN",
		source = "method-10aug",
		via = {
			--- ✅ MEASURED from Rob's screenshot, 17 aug: the Windcaller stands at
			--- 49.99/61.93 and its gossip offers the Eastern Amani Outpost and the
			--- Northern Amani Bulwark. The northern one is named here because the door
			--- above is northern — not because we know where either lands, which we do
			--- not. If a plan ever needs the eastern hop, that is a new measurement.
			kind = "gossip",
			mapID = 2509,
			x = 49.99,
			y = 61.93,
			npc = "Amani Windcaller",
			optionKey = "PLAN_OPT_NORTHERN_BULWARK",
			note = "PLAN_NOTE_WINDCALLER",
			source = "rob-screenshot-17aug",
		},
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
		--- 🔴 A PORTAL YOU CANNOT WALK TO IS NOT A STEP. Rob, 3 Sep 2026, standing IN
		--- Harandar and routing to the Twilight Crypts, was told to "head for Portal to
		--- Harandar first" -- a portal that is physically in Silvermoon.
		---
		--- 📌 The bug was one missing condition. This loop asked only "does this portal go
		--- where I want?" (`p.toID == outermost`) and took the first hit. It never asked
		--- "and is it where I am?". `MIDNIGHT_PORTALS` is ordered by nothing in particular,
		--- so the first row leading to Harandar happens to be the Silvermoon-side one, and
		--- that is verbatim what he was sent to.
		---
		--- ⚠️ Strict on purpose: `p.mapID == here` only. A portal on some third map is not a
		--- step, it is a step that needs its own plan first, and this planner does not build
		--- those -- so offering it states a route we cannot justify. The file already argues
		--- this a few lines down: "Silence beats a guessed hop." Falling through to the
		--- flight fallback, or to nothing, is the honest outcome.
		--- 📌 `MIDNIGHT_PORTALS` carries duplicate rows for the combined canvas 2576 beside
		--- the 2393/2413 ones, so an exact match still lands whichever map id the client
		--- reports. Where a row is missing for one of the pair we now say nothing instead of
		--- naming the wrong side, which is the safe direction to fail in.
		--- 🔴 THE NEAREST MATCH, NOT THE FIRST — 4 Sep 2026.
		---
		--- The 3 Sep fix added `p.mapID == here`, which stopped MH naming a portal on
		--- another map. It did not stop it naming the WRONG ONE on this map: `break` on the
		--- first hit, and the comment above already says the table "is ordered by nothing in
		--- particular". `/mh portals` on Rob's character lists six rows called "Portal to
		--- Silvermoon" and five called "Portal to Harandar"; on canvas 2576 several share a
		--- mapID, so several match and the first won.
		---
		--- What he saw: standing beside a portal, told "Use: Portal to Silvermoon (882yd)"
		--- with the arrow pointing at one a kilometre away. The right portal was under his
		--- feet and the plan named a different one with the same name.
		---
		--- ⚠️ Compared in MAP coordinates, not yards. Every candidate is on `here` by the
		--- condition above, so map units order them correctly, and squared distance avoids a
		--- square root we have no use for. Yards would need a world-position call per
		--- candidate that can fail, to sort a list we can already sort.
		--- 📌 With no player position we keep the old behaviour — first match — because a
		--- portal on the right map is still a better answer than none.
		if ns.MIDNIGHT_PORTALS and ns.MHPortalUsable then
			local pxp, pyp
			if C_Map and C_Map.GetPlayerMapPosition then
				local okPos, pos = pcall(C_Map.GetPlayerMapPosition, here, "player")
				if okPos and pos then
					local okXY, mx, my = pcall(pos.GetXY, pos)
					if okXY and mx then
						pxp, pyp = mx, my
					end
				end
			end
			local best, bestDist
			for _, p in ipairs(ns.MIDNIGHT_PORTALS) do
				if p.toID == outermost and p.mapID == here and ns.MHPortalUsable(p) then
					local d
					if pxp and p.x and p.y then
						-- Portal coords are 0-100, the player position 0-1.
						local dx = (p.x / 100) - pxp
						local dy = (p.y / 100) - pyp
						d = dx * dx + dy * dy
					end
					if not best then
						best, bestDist = p, d
					elseif d and (not bestDist or d < bestDist) then
						best, bestDist = p, d
					end
				end
			end
			if best then
				steps[#steps + 1] = {
					kind = "portal",
					mapID = best.mapID,
					x = best.x,
					y = best.y,
					label = best.name,
					source = "MIDNIGHT_PORTALS",
				}
			end
		end
		-- Failing a portal, the flight network is the honest fallback, and it can
		-- only speak about places it has. Silence beats a guessed hop.
		--- ⚠️ PASS THE COORDINATES. `GetNearestFlightPoint` only lives up to its name when
		--- it gets a position: without one it returns "the first stop this faction may
		--- use", which is list order, not distance (FlightPointsData.lua:1041).
		---
		--- Rob saw both answers stacked in one screen on 19 aug — chat said "Nearest flight
		--- point there: Silverglade Refuge", the arrow said "head for Fairbreeze Village",
		--- for the same delve in the same breath. Same function, two precisions: the chat
		--- had passed the target's position and this call had not.
		---
		--- Only when the outermost container IS the target's own map do the target's
		--- coordinates describe a point on it; one map further out they would be numbers
		--- from the wrong space, and a confidently wrong stop is worse than an arbitrary
		--- one. So the guess stays where it cannot be improved.
		if #steps == 0 and ns.GetNearestFlightPoint then
			local fx, fy
			if outermost == targetMap then
				fx, fy = x, y
			end
			local ok, fp = pcall(ns.GetNearestFlightPoint, outermost, fx, fy)
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
				-- The hop that gets you to the door goes BEFORE the door. Rob, standing
				-- next to the Windcaller and reading a plan that told him to walk north
				-- first: "volgens mij moet het plan zo zijn dat ik de interne
				-- mogelijkheid gebruik om naar het noordelijke gedeelte te vliegen."
				--- ⚠️ SKIP THE HOP WHEN IT WOULD SEND YOU BACKWARDS. Rob: "of als je
				--- dichterbij de ingang bent gelijk de pijl naar de ingang?"
				---
				--- We cannot answer the fuller question — which of the three inner hops
				--- is best — because we do not have the coordinates of the two landing
				--- points, only of the NPC. So the plan deliberately answers the half
				--- that IS provable: if the player is already nearer the door than the
				--- Windcaller, flying cannot help, because reaching the NPC alone means
				--- walking away from where they are going.
				---
				--- The other direction is NOT assumed. Being nearer the NPC does not
				--- prove the hop is worth it — that depends on where it lands, which is
				--- unmeasured — so the hop is still offered there rather than dropped.
				--- ⚠️ NOW COMPUTED, NOT ASSUMED. Yesterday this always offered the
				--- northern hop because the door is northern; with all three hubs
				--- measured it picks the one that lands nearest the door, and the one
				--- whose Windcaller is nearest the player to talk to.
				---
				--- Three reasons to say nothing, all of them real:
				---   * already at the hub that serves this door — flying is a no-op;
				---   * nearer the door than the NPC — the hop sends you backwards;
				---   * the chosen hub has no landing recorded (Foothold is where the
				---     Windcallers send you FROM, not to), so there is nothing to say.
				local skipVia, hub, viaNpc = false, nil, nil
				if link.via and here == link.fromMap and C_Map
					and C_Map.GetPlayerMapPosition then
					local okP, pos = pcall(C_Map.GetPlayerMapPosition, link.fromMap, "player")
					if okP and pos and pos.GetXY then
						local okXY, a, b = pcall(pos.GetXY, pos)
						if okXY and a then
							local px, py = a * 100, b * 100
							local best, near = ChooseHub(link.x, link.y, px, py)
							hub = best
							if not best then
								skipVia = true
							elseif near and best.key == near.key then
								-- Standing at the hub that already serves this door.
								skipVia = true
							else
								local toDoor = (link.x - px) ^ 2 + (link.y - py) ^ 2
								local npcX = (near and near.npcX) or link.via.x
								local npcY = (near and near.npcY) or link.via.y
								local toNpc = (npcX - px) ^ 2 + (npcY - py) ^ 2
								skipVia = toDoor < toNpc
								--- ⚠️ DO NOT WRITE INTO `link.via`. This used to set
								--- `link.via.x, link.via.y = near.npcX, near.npcY`,
								--- which edits the module-level LINKS table — so the
								--- first plan ever built stamped whichever Windcaller
								--- that player happened to be near into the data
								--- permanently, and every later plan on every character
								--- inherited it.
								---
								--- Rob standing at the EASTERN Windcaller is what sent
								--- me back to look. The chosen NPC is a property of this
								--- one plan, so it lives in a local and the table stays
								--- the constant it was written to be.
								if not skipVia and near then
									viaNpc = near
								end
							end
						end
					end
				end
				if link.via and not skipVia then
					steps[#steps + 1] = {
						kind = link.via.kind,
						mapID = link.via.mapID,
						-- The Windcaller nearest the player when one was chosen, the
						-- data's own otherwise. Never written back into the table.
						x = (viaNpc and viaNpc.npcX) or link.via.x,
						y = (viaNpc and viaNpc.npcY) or link.via.y,
						label = link.via.npc,
						detail = (hub and hub.optionKey) or link.via.optionKey,
						note = link.via.note,
						source = link.via.source,
					}
				end
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

	--- ⚠️ REMOVED: a loose pass that appended every gossip hop at the end of the plan.
	--- That is what produced "walk to the far north" followed by "(optional, saves a
	--- walk) talk to the man who flies you there". A hop belongs to the door it serves
	--- and is emitted with it, above — a step that is only useful before another step
	--- cannot be listed after it and still be advice.

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
		-- `optional` is no longer set by anything: the one step that used it was the
		-- gossip hop, and calling a step optional while listing it after the step it
		-- replaces was the whole mistake. Kept as a renderer capability, unused.
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
