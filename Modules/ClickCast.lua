local _, ns = ...

--[[
	"Clicks" for the healer specs (five on 24 Oct 2026, Mistweaver and Preservation the same day): which mouse button casts what on a group frame, and a button that puts that
	layout into DandersFrames as a click-cast profile (Rob, 24 Oct 2026: "Bouw het tabblad Klikken. De knop zet het
	profiel ook zelf aan via DandersFrames' interne functies. Lukt dat niet, dan toont het tabblad de uitleg voor /df.").

	🔴 Rob, 24 Oct 2026: "mensen moeten dan wel verteld worden dat dit alleen met DF werkt !!!!" The tab says so on top for
	everyone, the button's tooltip says it again, and without DandersFrames the button's place explains what to do instead.

	The layouts come from the healer click pack (AddOns/Healer-Klikpakket, healer_data.py of 21 Oct 2026): spell ids
	checked twice (guides/tooltips and wago 12.1.5.70448), four of the five profiles run in Rob's game. The same pattern
	for every healer: Shift+left = target, Shift+right = menu, Ctrl+left = dispel, Ctrl+middle = save someone else,
	Alt+right = battle res (Druid and Paladin only). No side buttons: we never assume an MMO mouse.

	Putting it in DandersFrames, measured in DandersFrames v5.5.0:
	  1. the public DandersFrames_ClickCast_Import(str, profileKey, importAll) makes the profile (Core/API.lua). It only
	     takes a "!DFC1!" string (LibSerialize + LibDeflate, both inside DandersFrames via LibStub). It never turns the
	     profile on: it calls CC:SwitchProfile, which does not exist in 5.5.0.
	  2. so MH turns it on itself through DandersFrames' own functions (global DandersFrames.ClickCast, not a public API):
	     link it to the current talent loadout (AssignProfileToLoadout, with DandersFrames' own GetCurrentSpec and
	     GetCurrentLoadoutConfigID, so it is the same key DandersFrames switches on at login), then SetActiveProfile +
	     ApplyBindings. Every call is type-checked and pcall'ed; if any is missing or fails, the tab shows the /df steps.
	  3. what was linked and active before is saved, so "Undo" puts it back.
	spellName is the CLIENT's name (C_Spell.GetSpellName): DandersFrames checks spells by name, and an English name is
	"invalid" on a German client (AFGELEID from its code, not tried on a non-English client).

	/mh klikken prints what MH sees and the last result (CLAUDE.md: something that can stay silent gets a diagnosis).
]]

local PREFIX = "!DFC1!"

-- Slot order = how the tab lists them: plain, Shift, Ctrl, Alt; left, right, middle.
local MODS = { "", "shift-", "ctrl-", "alt-" }
local BUTTONS = { "LeftButton", "RightButton", "MiddleButton" }
local SLOT_CODE = {
	[""] = { LeftButton = "L", RightButton = "R", MiddleButton = "M" },
	["shift-"] = { LeftButton = "SL", RightButton = "SR", MiddleButton = "SM" },
	["ctrl-"] = { LeftButton = "CL", RightButton = "CR", MiddleButton = "CM" },
	["alt-"] = { LeftButton = "AL", RightButton = "AR", MiddleButton = "AM" },
}

--- [specID] = { class, profile (the DandersFrames profile name), slots = { [code] = spellId } }.
--- A code without an id is free. SL/SR are the same for everyone (target / menu). The sentence per slot is the locale
--- key CLICK_<spec>_<code>.
ns.CLICKCAST_LAYOUTS = {
	[105] = { class = "DRUID", profile = "MH - Resto Druid",
		slots = { L = 774, R = 8936, M = 33763, SM = 474750, CL = 88423, CR = 18562, CM = 102342, AL = 48438, AR = 20484, AM = 29166 } },
	[65] = { class = "PALADIN", profile = "MH - Holy Paladin",
		slots = { L = 20473, R = 19750, M = 85673, SM = 53563, CL = 4987, CR = 82326, CM = 633, AL = 1044, AR = 391054, AM = 1022 } },
	[256] = { class = "PRIEST", profile = "MH - Disc Priest",
		slots = { L = 17, R = 2061, M = 47540, SM = 10060, CL = 527, CR = 200829, CM = 33206, AL = 194509, AR = 73325 } },
	[257] = { class = "PRIEST", profile = "MH - Holy Priest",
		slots = { L = 33076, R = 2061, M = 2050, SM = 10060, CL = 527, CR = 596, CM = 47788, AR = 73325 } },
	[264] = { class = "SHAMAN", profile = "MH - Resto Shaman",
		slots = { L = 61295, R = 77472, M = 974, SM = 73685, CL = 77130, CR = 1064, CM = 378081 } },
	-- Added 24 Oct 2026 (same click-pack chat; two routes: guides 12-20 Oct + wago 12.1.5.70575). Thunder Focus Tea is
	-- self-only and Dream Breath is an empower spell, so both stay on the action bar, not on a click.
	[270] = { class = "MONK", profile = "MH - Mistweaver Monk",
		slots = { L = 115151, R = 116670, M = 124682, SM = 115175, CL = 115450, CM = 116849, AL = 116841 } },
	[1468] = { class = "EVOKER", profile = "MH - Preservation Evoker",
		slots = { L = 364343, R = 366155, M = 360995, SM = 369459, CL = 360823, CR = 355913, CM = 357170 } },
}

function ns.HasClickLayout(specID)
	return specID ~= nil and ns.CLICKCAST_LAYOUTS[specID] ~= nil
end

--- The rows of a spec's layout in tab order: { code, mod, button, spellId?, action ("spell"/"target"/"menu"/nil) }.
function ns.ClickLayoutRows(specID)
	local def = specID and ns.CLICKCAST_LAYOUTS[specID]
	if not def then
		return nil
	end
	local out = {}
	for _, mod in ipairs(MODS) do
		for _, btn in ipairs(BUTTONS) do
			local code = SLOT_CODE[mod][btn]
			local action, id
			if code == "SL" then
				action = "target"
			elseif code == "SR" then
				action = "menu"
			elseif def.slots[code] then
				action, id = "spell", def.slots[code]
			end
			out[#out + 1] = { code = code, mod = mod, button = btn, spellId = id, action = action }
		end
	end
	return out
end

local function SpellName(id)
	if C_Spell and C_Spell.GetSpellName then
		local ok, name = pcall(C_Spell.GetSpellName, id)
		if ok and type(name) == "string" and name ~= "" then
			return name
		end
	end
	return nil
end

local function CC()
	local df = rawget(_G, "DandersFrames")
	local cc = type(df) == "table" and df.ClickCast
	return type(cc) == "table" and cc or nil
end

local function Libs()
	local stub = rawget(_G, "LibStub")
	if type(stub) ~= "table" then
		return nil, nil
	end
	local okS, ser = pcall(stub, "LibSerialize", true)
	local okD, def = pcall(stub, "LibDeflate", true)
	return okS and ser or nil, okD and def or nil
end

local function DFLoaded()
	if C_AddOns and C_AddOns.IsAddOnLoaded then
		local ok, loaded = pcall(C_AddOns.IsAddOnLoaded, "DandersFrames")
		if ok and loaded then
			return true
		end
	end
	return rawget(_G, "DandersFrames") ~= nil
end

local ACTIVATE_FNS = { "GetCurrentSpec", "GetCurrentLoadoutConfigID", "GetClassData", "AssignProfileToLoadout",
	"SetActiveProfile", "ApplyBindings", "GetActiveProfileName" }

--- What MH can do with DandersFrames right now.
--- @return table { loaded, api, libs, activate, missing = {names} }
function ns.ClickCastDFStatus()
	local s = { loaded = DFLoaded(), missing = {} }
	s.api = type(rawget(_G, "DandersFrames_ClickCast_Import")) == "function"
	local ser, def = Libs()
	s.libs = ser ~= nil and def ~= nil
	local cc = CC()
	s.activate = cc ~= nil
	for _, fn in ipairs(ACTIVATE_FNS) do
		if not (cc and type(cc[fn]) == "function") then
			s.activate = false
			s.missing[#s.missing + 1] = fn
		end
	end
	return s
end

local function Store()
	if not ns.db then
		return nil
	end
	ns.db.clickCast = ns.db.clickCast or {}
	return ns.db.clickCast
end

local function PlayerClass()
	local _, token = UnitClass("player")
	return token
end

--- The "!DFC1!" string for a spec, built the way DandersFrames' own export builds it (Core/API.lua).
local function BuildString(specID)
	local def = ns.CLICKCAST_LAYOUTS[specID]
	local ser, deflate = Libs()
	if not (def and ser and deflate) then
		return nil, "no LibSerialize/LibDeflate"
	end
	local bindings = {}
	for _, r in ipairs(ns.ClickLayoutRows(specID)) do
		if r.action then
			local b = {
				enabled = true, bindType = "mouse", button = r.button, modifiers = r.mod, actionType = r.action,
				targetType = "all", scope = "blizzard", combat = "always", priority = 5,
				fallback = { mouseover = false, target = false, selfCast = false },
			}
			if r.action == "spell" then
				b.spellId = r.spellId
				b.spellName = SpellName(r.spellId)
				if not b.spellName then
					return nil, "no name for spell " .. tostring(r.spellId)
				end
			end
			bindings[#bindings + 1] = b
		end
	end
	-- No sourceFlavor: DandersFrames refuses a string that names another flavor (FlavorCorrection.lua).
	local data = {
		version = 2, profileName = def.profile, class = def.class,
		profile = {
			_priorityHigherWinsV1 = true, bindings = bindings, customMacros = {}, consumables = {},
			options = { enabled = true, castOnDown = true, viewLayout = "grid", viewSort = "sectioned",
				quickBindEnabled = true, smartResurrection = "normal" },
		},
	}
	local ok, out = pcall(function()
		return PREFIX .. deflate:EncodeForPrint(deflate:CompressDeflate(ser:Serialize(data)))
	end)
	if not ok or type(out) ~= "string" then
		return nil, tostring(out)
	end
	return out, #bindings
end

--- Link the profile to the current talent loadout and turn it on. Saves what was there for Undo.
--- @return loadoutName|nil, err
local function Activate(profileName)
	local cc = CC()
	if not ns.ClickCastDFStatus().activate then
		return nil, "DandersFrames functions missing"
	end
	local ok, err = pcall(function()
		local specIndex = cc.GetCurrentSpec()
		local loadoutID = cc.GetCurrentLoadoutConfigID() or 0
		if not specIndex then
			error("no spec yet")
		end
		local classData = cc:GetClassData()
		local assigned = classData and classData.loadoutAssignments and classData.loadoutAssignments[specIndex]
		local st = Store()
		if st then
			st.undo = st.undo or {}
			local prev = st.undo[PlayerClass() or "?"]
			-- Keep the FIRST "before": pressing the button twice must not make MH's own profile the thing Undo returns to.
			if not (prev and prev.specIndex == specIndex and prev.loadoutID == loadoutID and prev.ours == profileName) then
				st.undo[PlayerClass() or "?"] = {
					specIndex = specIndex, loadoutID = loadoutID, ours = profileName,
					prevAssigned = assigned and assigned[loadoutID] or false,
					prevActive = cc:GetActiveProfileName(),
				}
			end
		end
		cc:AssignProfileToLoadout(specIndex, loadoutID, profileName)
		if not cc:SetActiveProfile(profileName) then
			error("SetActiveProfile said no")
		end
		cc:ApplyBindings()
		if type(cc.RefreshUIIfLoaded) == "function" then
			cc:RefreshUIIfLoaded()
		end
		return loadoutID
	end)
	if not ok then
		return nil, tostring(err)
	end
	local name
	if type(cc.GetLoadoutName) == "function" then
		local okN, n = pcall(cc.GetLoadoutName, cc.GetCurrentLoadoutConfigID())
		name = okN and n or nil
	end
	return name or "?"
end

--- The button: make the profile, then try to turn it on. Never in combat, never for another spec or class.
--- Result in ns.db.clickCast.last = { spec, state = "on"/"made"/"fail", profile, loadout?, err? }.
function ns.ClickCastImport(specID)
	local def = ns.CLICKCAST_LAYOUTS[specID]
	local st = Store()
	local function Done(r)
		r.spec = specID
		r.when = time and time() or nil
		if st then
			st.last = r
		end
		return r
	end
	if not def then
		return Done({ state = "fail", err = "no layout" })
	end
	if InCombatLockdown and InCombatLockdown() then
		return Done({ state = "fail", err = "in combat" })
	end
	if def.class ~= PlayerClass() then
		return Done({ state = "fail", err = "other class" })
	end
	local s = ns.ClickCastDFStatus()
	if not (s.loaded and s.api) then
		return Done({ state = "fail", err = "DandersFrames import function missing" })
	end
	local str, n = BuildString(specID)
	if not str then
		return Done({ state = "fail", err = n })
	end
	local ok, res, name = pcall(rawget(_G, "DandersFrames_ClickCast_Import"), str, def.profile, true)
	if not ok then
		return Done({ state = "fail", err = tostring(res) })
	end
	if not res then
		return Done({ state = "fail", err = tostring(name) })
	end
	local loadout, err = Activate(name or def.profile)
	if loadout then
		return Done({ state = "on", profile = name or def.profile, loadout = loadout, count = n })
	end
	return Done({ state = "made", profile = name or def.profile, err = err, count = n })
end

--- Undo: the loadout link and the active profile as they were before MH's button. MH's profile itself stays in
--- DandersFrames (deleting a player's profile is not ours to do).
function ns.ClickCastUndo()
	local st = Store()
	local u = st and st.undo and st.undo[PlayerClass() or "?"]
	local cc = CC()
	if not (u and cc and ns.ClickCastDFStatus().activate) or (InCombatLockdown and InCombatLockdown()) then
		return false
	end
	local ok = pcall(function()
		cc:AssignProfileToLoadout(u.specIndex, u.loadoutID, u.prevAssigned or nil)
		local back = u.prevAssigned or u.prevActive
		if back and back ~= u.ours then
			cc:SetActiveProfile(back)
		end
		cc:ApplyBindings()
		if type(cc.RefreshUIIfLoaded) == "function" then
			cc:RefreshUIIfLoaded()
		end
	end)
	if ok then
		st.undo[PlayerClass() or "?"] = nil
		if st.last then
			st.last = { spec = st.last.spec, state = "undone", profile = u.prevAssigned or u.prevActive }
		end
	end
	return ok
end

--- Is there something to undo for this class?
function ns.ClickCastCanUndo()
	local st = ns.db and ns.db.clickCast
	return st and st.undo and st.undo[PlayerClass() or "?"] ~= nil or false
end

--------------------------------------------------------------------------------
-- /mh klikken blizz — a PROBE, nothing for players (Rob, 24 Oct 2026: "zet een veilige proef klaar die meet of MH
-- Blizzards eigen klik-indeling mag zetten. Nog niets bouwen voor spelers.").
-- Blizzard's own Click Casting has C_ClickBindings.SetProfileByInfo(infoVec), flagged HasRestrictions in
-- ClickBindingsDocumentation.lua (wow-ui-source live, read 24 Oct 2026). Whether an addon may call it is not in the doc.
-- The probe reads the current profile and writes THE SAME profile back, so nothing changes either way, then:
--   - pcall's error, if any;
--   - ADDON_ACTION_BLOCKED / ADDON_ACTION_FORBIDDEN naming us, caught for 2 seconds after the call;
--   - the profile read back and compared field by field with the one before.
-- Result in chat and in ns.db.clickBlizzProbe (SavedVariables). Never in combat.
--------------------------------------------------------------------------------

local probeWatch -- { events = {} } while a probe is listening
local probeFrame

local function ProfileText(info)
	if type(info) ~= "table" then
		return "nil"
	end
	local rows = {}
	for _, b in ipairs(info) do
		local keys = {}
		for k in pairs(b) do
			keys[#keys + 1] = k
		end
		table.sort(keys)
		local parts = {}
		for _, k in ipairs(keys) do
			parts[#parts + 1] = k .. "=" .. tostring(b[k])
		end
		rows[#rows + 1] = table.concat(parts, ",")
	end
	table.sort(rows)
	return table.concat(rows, " | ")
end

function ns.ClickBlizzProbe()
	local say = function(s)
		print("|cff66ccff[MH klikken blizz]|r " .. s)
	end
	local out = { when = time and time() or nil }
	if ns.db then
		ns.db.clickBlizzProbe = out
	end
	if InCombatLockdown and InCombatLockdown() then
		out.verdict = "not run: in combat"
		say("niet in een gevecht; probeer het straks.")
		return
	end
	local api = C_ClickBindings
	if not (api and type(api.GetProfileInfo) == "function" and type(api.SetProfileByInfo) == "function") then
		out.verdict = "no C_ClickBindings.GetProfileInfo/SetProfileByInfo"
		say("de Blizzard-functies bestaan niet in deze client.")
		return
	end
	local okGet, before = pcall(api.GetProfileInfo)
	if not okGet or type(before) ~= "table" then
		out.verdict = "GetProfileInfo failed: " .. tostring(before)
		say("lezen mislukte: " .. tostring(before))
		return
	end
	out.count = #before
	out.before = ProfileText(before)
	say(("je Blizzard-klikindeling heeft %d regels. Ik schrijf precies dezelfde terug..."):format(#before))

	if not probeFrame then
		probeFrame = CreateFrame("Frame")
		probeFrame:RegisterEvent("ADDON_ACTION_BLOCKED")
		probeFrame:RegisterEvent("ADDON_ACTION_FORBIDDEN")
		probeFrame:SetScript("OnEvent", function(_, event, addon, fn)
			if probeWatch then
				probeWatch.events[#probeWatch.events + 1] = event .. " " .. tostring(addon) .. " " .. tostring(fn)
			end
		end)
	end
	probeWatch = { events = {} }
	local okSet, err = pcall(api.SetProfileByInfo, before)
	out.pcallOk = okSet
	out.pcallErr = not okSet and tostring(err) or nil

	C_Timer.After(2, function()
		local events = probeWatch and probeWatch.events or {}
		probeWatch = nil
		local okBack, after = pcall(api.GetProfileInfo)
		out.after = okBack and ProfileText(after) or ("read failed: " .. tostring(after))
		out.same = okBack and out.after == out.before or false
		out.events = events
		local ours = false
		for _, e in ipairs(events) do
			if e:find("MidnightHelper", 1, true) then
				ours = true
			end
		end
		if okSet and not ours then
			out.verdict = "ALLOWED"
		else
			out.verdict = "BLOCKED"
		end
		say("pcall: " .. (okSet and "|cff33ff66geen fout|r" or ("|cffff5555fout:|r " .. tostring(err))))
		say("geblokkeerd-meldingen: " .. (#events > 0 and table.concat(events, "; ") or "geen"))
		say("indeling daarna gelijk aan ervoor: " .. (out.same and "|cff33ff66ja|r" or "|cffff5555nee|r"))
		say("uitkomst: " .. (out.verdict == "ALLOWED" and "|cff33ff66MAG|r - MH kan Blizzards klik-indeling zetten (buiten gevecht)"
			or "|cffff5555MAG NIET|r - Blizzard blokkeert het voor addons"))
	end)
end

--- /mh klikken: what MH sees, and the last result. Read-only.
function ns.PrintClickCastStatus()
	local s = ns.ClickCastDFStatus()
	local function yn(b)
		return b and "|cff33ff66ja|r" or "|cffff5555nee|r"
	end
	print("|cff66ccff[MH klikken]|r DandersFrames geladen: " .. yn(s.loaded)
		.. " · importfunctie: " .. yn(s.api) .. " · LibSerialize+LibDeflate: " .. yn(s.libs)
		.. " · zelf aanzetten: " .. yn(s.activate))
	if #s.missing > 0 then
		print("   ontbreekt in DandersFrames.ClickCast: " .. table.concat(s.missing, ", "))
	end
	local cc = CC()
	if cc and type(cc.GetActiveProfileName) == "function" then
		local ok, name = pcall(cc.GetActiveProfileName, cc)
		print("   actief DF-profiel: " .. tostring(ok and name or "?"))
	end
	local spec = ns.GetSpecialization and ns.GetSpecialization()
	local specID = spec and ns.GetSpecializationInfo and ns.GetSpecializationInfo(spec)
	print("   jouw spec " .. tostring(specID) .. ": " .. (ns.HasClickLayout(specID) and "heeft een klik-indeling" or "geen klik-indeling"))
	if ns.HasClickLayout(specID) then
		local str, n = BuildString(specID)
		print("   proefstring: " .. (str and (#str .. " tekens, " .. tostring(n) .. " klikken") or ("mislukt: " .. tostring(n))))
	end
	local st = ns.db and ns.db.clickCast
	local last = st and st.last
	if last then
		print(("   laatste keer: spec %s, %s, profiel %s%s%s"):format(tostring(last.spec), tostring(last.state),
			tostring(last.profile), last.loadout and (", indeling " .. tostring(last.loadout)) or "",
			last.err and (", reden: " .. tostring(last.err)) or ""))
	else
		print("   laatste keer: nog nooit op de knop gedrukt")
	end
	print("   ongedaan maken mogelijk: " .. yn(ns.ClickCastCanUndo()))
end
