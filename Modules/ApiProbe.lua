local _, ns = ...

--[[
	Midnight Helper — 12.1 API probe (dev tool).

	/mh roleset [save]

	Patch 12.1 introduces a Roleset system. The only thing we know about it is one
	sentence and one function name, from the Warcraft Wiki API changes (logged
	2026-07-19): frames can belong to a roleset, `C_Roleset.ApplyRolesetFilters`
	decides which rolesets are active, and "frames in an inactive roleset will never
	be shown, regardless of their shown state".

	That last clause is why this exists. Midnight Helper creates frames on UIParent in
	33 files -- the combat warnings, the toasts, the arrow, the accessibility alert.
	A system that can keep a frame hidden despite :Show() and without raising an error
	would take all of them out at once, silently.

	⚠️ THIS PROBE ASSUMES NOTHING BEYOND THAT ONE FUNCTION NAME. It does not guess at
	an API and then report whether the guess worked -- it enumerates what the client
	actually has: every field of C_Roleset, every frame method whose name mentions a
	roleset, and every matching global. A probe built on guessed names would "find
	nothing" for two different reasons and we could not tell them apart.

	It also draws one plain test frame and reports what the client says about it, so
	"does an ordinary frame still show" is answered by looking rather than assuming.
]]

local PREFIX = "|cffffcc00Midnight Helper|r"

--- Everything the client exposes under a name mentioning "roleset".
--- @return table findings
local function CollectRolesetApi()
	local out = {
		namespaceExists = false,
		namespaceFields = {},
		frameMethods = {},
		globals = {},
	}

	if type(C_Roleset) == "table" then
		out.namespaceExists = true
		local ok = pcall(function()
			for k, v in pairs(C_Roleset) do
				out.namespaceFields[#out.namespaceFields + 1] = {
					name = tostring(k),
					kind = type(v),
				}
			end
		end)
		if not ok then
			out.namespaceFields[#out.namespaceFields + 1] = { name = "(could not iterate)", kind = "?" }
		end
		table.sort(out.namespaceFields, function(a, b) return a.name < b.name end)
	end

	-- Frame methods. A frame's methods live on its metatable's __index, which is the
	-- shared widget table -- so this lists what EVERY frame can do, not just ours.
	local probeFrame = CreateFrame("Frame")
	local mt = getmetatable(probeFrame)
	local widget = mt and mt.__index
	if type(widget) == "table" then
		for k, v in pairs(widget) do
			local name = tostring(k)
			if name:lower():find("roleset", 1, true) then
				out.frameMethods[#out.frameMethods + 1] = { name = name, kind = type(v) }
			end
		end
		table.sort(out.frameMethods, function(a, b) return a.name < b.name end)
	else
		out.frameMethods[#out.frameMethods + 1] = { name = "(widget table unreadable)", kind = "?" }
	end

	-- Anything else in the global namespace. Cheap enough, and it catches a helper
	-- that lives outside C_Roleset entirely.
	for k, v in pairs(_G) do
		if type(k) == "string" and k:lower():find("roleset", 1, true) and k ~= "C_Roleset" then
			out.globals[#out.globals + 1] = { name = k, kind = type(v) }
		end
	end
	table.sort(out.globals, function(a, b) return a.name < b.name end)

	return out
end

--- Draw one ordinary frame and report what the client says about it.
--- Answers "can a plain frame still be shown" by doing it, not by reasoning.
--- @return table state
local function TestPlainFrame()
	local f = ns._mhRolesetTestFrame
	if not f then
		f = CreateFrame("Frame", "MidnightHelperRolesetTest", UIParent)
		f:SetSize(160, 40)
		f:SetPoint("CENTER", UIParent, "CENTER", 0, 220)
		f:SetFrameStrata("HIGH")
		local tex = f:CreateTexture(nil, "BACKGROUND")
		tex:SetAllPoints(f)
		tex:SetColorTexture(0.9, 0.2, 0.2, 0.85)
		local fs = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
		fs:SetPoint("CENTER")
		fs:SetText("MH roleset test")
		ns._mhRolesetTestFrame = f
	end
	f:Show()

	local state = {
		created = true,
		isShown = f:IsShown() and true or false,
		isVisible = f:IsVisible() and true or false,
		isProtected = false,
		effectiveAlpha = nil,
	}
	local okP, prot = pcall(f.IsProtected, f)
	state.isProtected = (okP and prot) and true or false
	local okA, a = pcall(f.GetEffectiveAlpha, f)
	if okA then
		state.effectiveAlpha = a
	end
	-- If the frame carries a roleset, ask it -- but only through a method the client
	-- actually has. Never call a name we invented.
	local mt = getmetatable(f)
	local widget = mt and mt.__index
	if type(widget) == "table" then
		for k in pairs(widget) do
			local name = tostring(k)
			if name:lower():find("roleset", 1, true) and name:sub(1, 3) == "Get" then
				local okR, r = pcall(f[k], f)
				-- Round one printed a table ADDRESS, which says nothing. Unpack it.
				state.rolesetCall = ("%s() -> %s"):format(name, okR and ns._mhDescribe(r) or "error")
				break
			end
		end
	end
	return state
end

--- Render a value readably. A table's address is not evidence; its contents are.
function ns._mhDescribe(v)
	if type(v) ~= "table" then
		return tostring(v)
	end
	local parts = {}
	for i, item in ipairs(v) do
		parts[#parts + 1] = tostring(item)
		if i >= 20 then
			parts[#parts + 1] = "..."
			break
		end
	end
	if #parts == 0 then
		-- Distinguish "empty list" from "map with keys" -- they mean different things.
		for k, item in pairs(v) do
			parts[#parts + 1] = ("%s=%s"):format(tostring(k), tostring(item))
			if #parts >= 20 then
				break
			end
		end
	end
	return ("{%s}"):format(table.concat(parts, ", "))
end

-- MH frames that are actually drawn on screen. If a roleset ever filters one of
-- these, the player loses a helper silently -- so these are the ones to watch.
local WATCHED_FRAMES = {
	"MidnightHelperCombatSafety",
	"MidnightHelperCombatSafetyBars",
	"MidnightHelperAlert",
	"MidnightHelperToast",
	"MidnightHelperBossWindow",
	"MH_TravelPopup",
	"MidnightHelperConsumableBoard",
}

--- What the client says about rolesets right now, and about our own frames.
local function CollectLiveState()
	local out = { active = {}, frames = {} }
	if type(C_Roleset) == "table" then
		for _, fn in ipairs({ "GetActiveAllowedRolesets", "GetActiveBlockedRolesets" }) do
			if type(C_Roleset[fn]) == "function" then
				local ok, res = pcall(C_Roleset[fn])
				out.active[#out.active + 1] = {
					name = fn,
					value = ok and ns._mhDescribe(res) or "error",
				}
			end
		end
	end

	for _, name in ipairs(WATCHED_FRAMES) do
		local f = _G[name]
		local row = { name = name, exists = f ~= nil }
		if f then
			-- ⚠️ NOT `okS and (s and true or false) or nil`. That is the classic Lua
			-- trap: the moment `s` is false the whole expression falls through to nil,
			-- so "hidden" and "unreadable" render identically. The first run reported
			-- shown=nil for three frames that were simply not shown (2026-07-27).
			local okS, s = pcall(f.IsShown, f)
			if okS then
				row.isShown = s and true or false
			end
			if type(f.IsRolesetFiltered) == "function" then
				local okF, filtered = pcall(f.IsRolesetFiltered, f)
				row.filtered = okF and tostring(filtered) or "error"
			end
			if type(f.GetRolesetNames) == "function" then
				local okN, names = pcall(f.GetRolesetNames, f)
				row.rolesets = okN and ns._mhDescribe(names) or "error"
			end
		end
		out.frames[#out.frames + 1] = row
	end
	return out
end

local function Gather()
	local api = CollectRolesetApi()
	api.frame = TestPlainFrame()
	api.live = CollectLiveState()
	api.build = select(4, GetBuildInfo())
	api.captured = (time and time()) or 0
	return api
end

--- /mh roleset — print what the client has.
function ns.PrintRolesetProbe()
	local d = Gather()
	print(("%s Roleset probe (interface %s)"):format(PREFIX, tostring(d.build)))

	print(("   C_Roleset exists   = %s"):format(tostring(d.namespaceExists)))
	if d.namespaceExists then
		if #d.namespaceFields == 0 then
			print("     (namespace is empty)")
		end
		for _, f in ipairs(d.namespaceFields) do
			print(("     C_Roleset.%-34s %s"):format(f.name, f.kind))
		end
	end

	print(("   frame methods      = %d"):format(#d.frameMethods))
	for _, f in ipairs(d.frameMethods) do
		print(("     Frame:%-38s %s"):format(f.name, f.kind))
	end

	print(("   other globals      = %d"):format(#d.globals))
	for _, g in ipairs(d.globals) do
		print(("     %-44s %s"):format(g.name, g.kind))
	end

	local fr = d.frame
	print("   plain test frame drawn at the top of your screen:")
	print(("     IsShown=%s  IsVisible=%s  protected=%s  effectiveAlpha=%s"):format(
		tostring(fr.isShown), tostring(fr.isVisible), tostring(fr.isProtected),
		tostring(fr.effectiveAlpha)))
	if fr.rolesetCall then
		print("     " .. fr.rolesetCall)
	end
	print("   |cffffff78Do you SEE a red box near the top of the screen?|r That is the answer")
	print("   that matters: IsVisible can be true while a roleset still hides it.")

	local live = d.live or {}
	print("   active rolesets right now:")
	for _, a in ipairs(live.active or {}) do
		print(("     %-28s %s"):format(a.name, a.value))
	end
	print("   Midnight Helper's own on-screen frames:")
	for _, r in ipairs(live.frames or {}) do
		if not r.exists then
			print(("     %-34s not created yet"):format(r.name))
		else
			print(("     %-34s shown=%-5s filtered=%-6s rolesets=%s"):format(
				r.name, tostring(r.isShown), tostring(r.filtered), tostring(r.rolesets)))
		end
	end
end

--- /mh roleset save — same, into SavedVariables (then /reload).
function ns.SaveRolesetProbe()
	ns.db = ns.db or {}
	ns.db.rolesetProbe = Gather()
	local d = ns.db.rolesetProbe
	print(("%s captured: C_Roleset=%s, %d namespace fields, %d frame methods, %d globals."):format(
		PREFIX, tostring(d.namespaceExists), #d.namespaceFields, #d.frameMethods, #d.globals))
	print("   |cffffff78Now type /reload|r -- SavedVariables only reach disk on reload or logout.")
end

--- /mh roleset hide — take the test frame away again.
function ns.HideRolesetTestFrame()
	if ns._mhRolesetTestFrame then
		ns._mhRolesetTestFrame:Hide()
		print(PREFIX .. " test frame hidden.")
	end
end
