--[[
	/mh whatis [seconds] -- which addon drew the thing under the mouse?

	Rob, 27 sep 2026: floating icons with a timer and a stack count appear on his Prot Paladin
	only. /fstack listed nothing but nameless frames, Edit Mode cannot move them, and they do
	not follow an enemy. A frame's name is optional; its artwork is not. Most addons ship their
	own border, font or badge, and the file path of that artwork names the addon's folder.

	So this walks every visible frame under the cursor (IsMouseOver works whether or not the
	frame takes the mouse, which /fstack's focus list does not) and prints each texture and
	font path, marking the ones that live under Interface\AddOns\. `/mh whatis 5` waits five
	seconds first, so there is time to put the mouse on an icon that only shows in combat.

	Reads only. Also saved to ns.db.whatis for the SavedVariables file.
]]

local _, ns = ...

local function Prefix()
	return ("|cffffcc00%s|r"):format(ns:L("PRINT_PREFIX"))
end

local function PathOf(region)
	if region.GetTextureFilePath then
		local ok, p = pcall(region.GetTextureFilePath, region)
		if ok and type(p) == "string" and p ~= "" then
			return p
		end
	end
	if region.GetTexture then
		local ok, p = pcall(region.GetTexture, region)
		if ok and p ~= nil and not (issecretvalue and issecretvalue(p)) then
			return tostring(p)
		end
	end
	return nil
end

local function AddonOf(path)
	if type(path) ~= "string" then
		return nil
	end
	return path:match("[Aa][Dd][Dd][Oo][Nn][Ss][\\/]([^\\/]+)")
end

local function Scan()
	local hits, owners = {}, {}
	local f = EnumerateFrames and EnumerateFrames()
	local guard = 0
	-- One frame's look, all of it in a pcall: a forbidden or odd frame costs a skip, never an error.
	local function Look(f)
		local okV, vis = pcall(f.IsVisible, f)
		local okM, over = false, false
		if okV and vis == true then
			okM, over = pcall(f.IsMouseOver, f)
		end
		if okM and over == true then
			local okN, name = pcall(f.GetDebugName, f)
			local entry = { name = okN and name or "?", paths = {} }
			local okR, regions = pcall(function()
				return { f:GetRegions() }
			end)
			for _, r in ipairs(okR and regions or {}) do
				local okT, kind = pcall(r.GetObjectType, r)
				if okT and kind == "Texture" then
					local p = PathOf(r)
					if p then
						entry.paths[#entry.paths + 1] = p
					end
				elseif okT and kind == "FontString" then
					local okF, font = pcall(r.GetFont, r)
					if okF and type(font) == "string" then
						entry.paths[#entry.paths + 1] = "font " .. font
					end
				end
			end
			for _, p in ipairs(entry.paths) do
				local a = AddonOf(p)
				if a then
					owners[a] = (owners[a] or 0) + 1
				end
			end
			if #entry.paths > 0 then
				hits[#hits + 1] = entry
			end
		end
	end
	while f and guard < 200000 do
		guard = guard + 1
		pcall(Look, f)
		f = EnumerateFrames(f)
	end
	return hits, owners
end

local function Report()
	local hits, owners = Scan()
	print(("%s whatis: %d frame(s) with artwork under the mouse"):format(Prefix(), #hits))
	local names = {}
	for a, n in pairs(owners) do
		names[#names + 1] = ("%s (%d)"):format(a, n)
	end
	table.sort(names)
	print("   |cff8cd98caddon folders in that artwork:|r " .. (#names > 0 and table.concat(names, ", ") or "none -- only game files"))
	for i, h in ipairs(hits) do
		if i > 12 then
			print(("   ... and %d more (all in the SavedVariables file)"):format(#hits - 12))
			break
		end
		print("   " .. tostring(h.name):sub(1, 70))
		for j, p in ipairs(h.paths) do
			if j > 4 then
				break
			end
			local mark = AddonOf(p) and "|cff8cd98c" or "|cff9d9d9d"
			print(("      %s%s|r"):format(mark, p:sub(1, 90)))
		end
	end
	if ns.db then
		ns.db.whatis = { at = date and date("%Y-%m-%d %H:%M:%S") or "?", hits = hits, owners = owners }
	end
end

function ns.WhatIsCommand(arg)
	local delay = tonumber(arg)
	if delay and delay > 0 and C_Timer and C_Timer.After then
		delay = math.min(delay, 30)
		print(("%s whatis: put the mouse on the thing -- looking in %d seconds."):format(Prefix(), delay))
		C_Timer.After(delay, Report)
		return
	end
	Report()
end
