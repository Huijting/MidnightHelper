local _, ns = ...

--[[
	ForeverClickCast.lua — WoW Forever: heals on a mouse click on your DandersFrames group frames.

	Rob, 26 Nov 2026 (Tauren Druid, level ~14, off-healing): "in de midnight versie kunnen wij de heals op onze
	dandenframes zetten. Kunnen wij dat in Forever ook? En zo niet, waarom niet? En kunnen we het wel maken?" → via
	Sparring "2 ja".

	Why the Midnight one (ClickCast.lua) does not work here, measured 26 Nov 2026: ClickCast.lua is not in
	MidnightHelper_Camelot.toc; its layouts are keyed by retail spec ids (105, 65 …) and retail spell ids (33763, 474750 …)
	that do not exist in Forever; Forever has one spec per class (DB2 wowf 71139).
	What does work: DandersFrames in _forever_ is the same v6.1.0 as retail (Sparring's mh-research, byte-compared), with
	DandersFrames_ClickCast_Import and the DandersFrames.ClickCast functions MH uses in Midnight. Read in its source here:
	Core/API.lua:309-328 — an import with a profile name OVERWRITES that profile (no "Name 2" copies), so refreshing after
	you learn a spell is safe. FlavorCorrection refuses a string that names another flavor: MH writes none.

	So this module builds the profile here, BY NAME: every slot is a short list of English spell names, the first one this
	character knows wins (ns.ForeverKnownSpell, ForeverBlock.lua: highest known rank; ids from ForeverSpellIds.lua), and
	the binding carries the CLIENT's name (DandersFrames checks spells by name). A click casts the spell by name, which in
	this client is its highest rank (AFGELEID, not tried in the game).
	It is a switch the player turns on (off by default; Rob: players choose). While on, it follows you: a new spell
	(SPELLS_CHANGED) refreshes the profile, out of combat only. Off = Undo: the loadout link and the active profile go
	back to what they were; MH's profile stays in DandersFrames (deleting a player's profile is not ours to do).
	Second switch "keep left-click for targeting" (on by default): plain left and right click stay target / menu, the heals
	go on Ctrl and Alt. Off: the healer layout with heals on the plain clicks too. A Druid in Cat or Bear Form off-healing
	does not want a plain click to pull him out of form.
	/mh clickheal [why|on|off|heal|offheal] prints what MH decided and why (CLAUDE.md: a module that can stay silent).
]]

if not ns.IS_FOREVER then
	return
end

local PREFIX = "|cffffcc00Midnight Helper:|r "
local DF_PREFIX = "!DFC1!"

-- Slot code = modifier + button: L/R/M plain, S = Shift, C = Ctrl, A = Alt.
local SLOT = {
	L = { "", "LeftButton" }, R = { "", "RightButton" }, M = { "", "MiddleButton" },
	SL = { "shift-", "LeftButton" }, SR = { "shift-", "RightButton" }, SM = { "shift-", "MiddleButton" },
	CL = { "ctrl-", "LeftButton" }, CR = { "ctrl-", "RightButton" }, CM = { "ctrl-", "MiddleButton" },
	AL = { "alt-", "LeftButton" }, AR = { "alt-", "RightButton" }, AM = { "alt-", "MiddleButton" },
}
local ORDER = { "L", "R", "M", "SL", "SR", "SM", "CL", "CR", "CM", "AL", "AR", "AM" }

-- The healer layout per class: [slot] = English names, first known wins. Names = keys of ns.FOREVER_SPELL_IDS
-- (measured on the Forever DB2). The same pattern as Midnight's click pack: plain = heals, Ctrl+left = dispel, Alt+right
-- = res. Shift+left / Shift+right are always target / menu.
local HEAL = {
	DRUID = { L = { "Rejuvenation" }, R = { "Regrowth", "Healing Touch" }, M = { "Healing Touch" },
		CL = { "Abolish Poison", "Cure Poison" }, CR = { "Remove Curse" }, CM = { "Swiftmend" },
		AR = { "Rebirth" }, AM = { "Innervate" } },
	PRIEST = { L = { "Renew" }, R = { "Flash Heal", "Lesser Heal" }, M = { "Greater Heal", "Heal", "Lesser Heal" },
		CL = { "Dispel Magic" }, CR = { "Abolish Disease", "Cure Disease" }, CM = { "Power Word: Shield" },
		AR = { "Resurrection" }, AM = { "Power Infusion" } },
	PALADIN = { L = { "Flash of Light", "Holy Light" }, R = { "Holy Light" }, M = { "Holy Shock" },
		CL = { "Cleanse", "Purify" }, CR = { "Lay on Hands" }, CM = { "Blessing of Protection" },
		AL = { "Blessing of Freedom" }, AR = { "Redemption" }, AM = { "Oath of Light" } },
	SHAMAN = { L = { "Lesser Healing Wave", "Healing Wave" }, R = { "Healing Wave" }, M = { "Chain Heal" },
		CL = { "Cure Poison" }, CR = { "Cure Disease" }, AR = { "Ancestral Spirit" } },
}
-- Keep left-click for targeting: plain left/right = target/menu, heals move to Alt (and the res drops off: Alt+right is
-- the second heal now). [new slot] = slot of the healer layout.
local OFFHEAL_FROM = { AL = "L", AR = "R", AM = "M", CL = "CL", CR = "CR", CM = "CM" }

local why = "not looked yet" -- for /mh clickheal

local function Class()
	local _, token = UnitClass("player")
	return token
end

local function Store()
	if type(ns.db) ~= "table" then
		return nil
	end
	ns.db.foreverClick = ns.db.foreverClick or {}
	local st = ns.db.foreverClick
	st.on = st.on or {}
	st.keepLeft = st.keepLeft or {}
	st.sig = st.sig or {}
	st.undo = st.undo or {}
	return st
end

local function CharKey(tbl)
	local n, r = UnitName and UnitName("player"), GetRealmName and GetRealmName()
	local legacy = tostring(n) .. "-" .. tostring(r)
	return ns.ForeverCharKey and ns.ForeverCharKey("click heals", legacy, tbl, { whole = true }) or legacy
end

function ns.IsForeverClickOn()
	local st = Store()
	return st ~= nil and st.on[CharKey(st.on)] == true
end

function ns.IsForeverClickKeepLeft()
	local st = Store()
	return not (st and st.keepLeft[CharKey(st.keepLeft)] == false)
end

function ns.ForeverClickHasLayout()
	return HEAL[Class() or ""] ~= nil
end

local function ClientName(id)
	if C_Spell and C_Spell.GetSpellName then
		local ok, nm = pcall(C_Spell.GetSpellName, id)
		if ok and type(nm) == "string" and nm ~= "" and not (issecretvalue and issecretvalue(nm)) then
			return nm
		end
	end
	return nil
end

--- The rows for this character now: { code, mod, button, action, spellId?, spellName?, english? }, plus a signature.
local function Rows()
	local heal = HEAL[Class() or ""]
	if not heal then
		return nil, "no heals for your class"
	end
	local keepLeft = ns.IsForeverClickKeepLeft()
	local want = {} -- slot -> list of names
	if keepLeft then
		for to, from in pairs(OFFHEAL_FROM) do
			want[to] = heal[from]
		end
	else
		for k, v in pairs(heal) do
			want[k] = v
		end
	end
	local rows, used, sig = {}, {}, {}
	for _, code in ipairs(ORDER) do
		local mod, button = SLOT[code][1], SLOT[code][2]
		local action
		if (keepLeft and code == "L") or code == "SL" then
			action = "target"
		elseif (keepLeft and code == "R") or code == "SR" then
			action = "menu"
		end
		if action then
			rows[#rows + 1] = { code = code, mod = mod, button = button, action = action }
		elseif want[code] then
			for _, english in ipairs(want[code]) do
				local id = ns.ForeverKnownSpell and ns.ForeverKnownSpell(english)
				if id and not used[english] then
					local name = ClientName(id)
					if name then
						used[english] = true
						rows[#rows + 1] = { code = code, mod = mod, button = button, action = "spell", spellId = id,
							spellName = name, english = english }
						sig[#sig + 1] = code .. "=" .. tostring(id)
						break
					end
				end
			end
		end
	end
	return rows, table.concat(sig, ",") .. (keepLeft and "|keep" or "|heal")
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

local NEED = { "GetCurrentSpec", "GetCurrentLoadoutConfigID", "GetClassData", "AssignProfileToLoadout",
	"SetActiveProfile", "ApplyBindings", "GetActiveProfileName" }

--- What MH can use of DandersFrames: ok, and what is missing.
local function DFStatus()
	local missing = {}
	if type(rawget(_G, "DandersFrames_ClickCast_Import")) ~= "function" then
		missing[#missing + 1] = "DandersFrames_ClickCast_Import"
	end
	local ser, def = Libs()
	if not (ser and def) then
		missing[#missing + 1] = "LibSerialize/LibDeflate"
	end
	local cc = CC()
	for _, fn in ipairs(NEED) do
		if not (cc and type(cc[fn]) == "function") then
			missing[#missing + 1] = "ClickCast." .. fn
		end
	end
	return #missing == 0, missing
end

local function ProfileName()
	local cls = Class() or "?"
	return "MH - Forever " .. cls:sub(1, 1) .. cls:sub(2):lower()
end

--- The "!DFC1!" string, built the way DandersFrames' own export builds it (as ClickCast.lua does for Midnight).
local function BuildString(rows)
	local ser, deflate = Libs()
	if not (ser and deflate) then
		return nil, "no LibSerialize/LibDeflate"
	end
	local bindings = {}
	for _, r in ipairs(rows) do
		local b = {
			enabled = true, bindType = "mouse", button = r.button, modifiers = r.mod, actionType = r.action,
			targetType = "all", scope = "blizzard", combat = "always", priority = 5,
			fallback = { mouseover = false, target = false, selfCast = false },
		}
		if r.action == "spell" then
			b.spellId, b.spellName = r.spellId, r.spellName
		end
		bindings[#bindings + 1] = b
	end
	local data = {
		version = 2, profileName = ProfileName(), class = Class(),
		profile = {
			_priorityHigherWinsV1 = true, bindings = bindings, customMacros = {}, consumables = {},
			options = { enabled = true, castOnDown = true, viewLayout = "grid", viewSort = "sectioned",
				quickBindEnabled = true, smartResurrection = "normal" },
		},
	}
	local ok, out = pcall(function()
		return DF_PREFIX .. deflate:EncodeForPrint(deflate:CompressDeflate(ser:Serialize(data)))
	end)
	if not ok or type(out) ~= "string" then
		return nil, tostring(out)
	end
	return out
end

--- Link MH's profile to the current spec/loadout and switch it on; the first "before" is kept for Undo.
local function Activate(st, name)
	local cc = CC()
	local ok, err = pcall(function()
		local specIndex = cc.GetCurrentSpec()
		local loadoutID = cc.GetCurrentLoadoutConfigID() or 0
		if not specIndex then
			error("no spec index from the client")
		end
		local classData = cc:GetClassData()
		local assigned = classData and classData.loadoutAssignments and classData.loadoutAssignments[specIndex]
		local cls = Class() or "?"
		local prev = st.undo[cls]
		if not (prev and prev.specIndex == specIndex and prev.loadoutID == loadoutID) then
			st.undo[cls] = { specIndex = specIndex, loadoutID = loadoutID,
				prevAssigned = assigned and assigned[loadoutID] or false, prevActive = cc:GetActiveProfileName() }
		end
		cc:AssignProfileToLoadout(specIndex, loadoutID, name)
		if not cc:SetActiveProfile(name) then
			error("SetActiveProfile said no")
		end
		cc:ApplyBindings()
		if type(cc.RefreshUIIfLoaded) == "function" then
			cc:RefreshUIIfLoaded()
		end
	end)
	return ok, ok and nil or tostring(err)
end

local function Undo(st)
	local u = st and st.undo[Class() or "?"]
	local cc = CC()
	if not (u and cc) then
		return false, "nothing to undo"
	end
	local ok, err = pcall(function()
		cc:AssignProfileToLoadout(u.specIndex, u.loadoutID, u.prevAssigned or nil)
		local back = u.prevAssigned or u.prevActive
		if back and back ~= ProfileName() then
			cc:SetActiveProfile(back)
		end
		cc:ApplyBindings()
		if type(cc.RefreshUIIfLoaded) == "function" then
			cc:RefreshUIIfLoaded()
		end
	end)
	if ok then
		st.undo[Class() or "?"] = nil
	end
	return ok, ok and nil or tostring(err)
end

local pending = false

--- Build and apply the profile now (out of combat). quiet = no chat when nothing changed (the automatic refresh).
local function Apply(quiet)
	local st = Store()
	if not st then
		why = "saved data not ready"
		return false
	end
	if InCombatLockdown and InCombatLockdown() then
		pending = true
		why = "in combat: waiting until it ends"
		return false
	end
	pending = false
	local okDF, missing = DFStatus()
	if not okDF then
		why = "DandersFrames missing or changed: " .. table.concat(missing, ", ")
		if not quiet then
			print(PREFIX .. ns:L("FCLICK_NODF"))
		end
		return false
	end
	local rows, sig = Rows()
	if not rows then
		why = sig
		if not quiet then
			print(PREFIX .. ns:L("FCLICK_NOCLASS"))
		end
		return false
	end
	local key = CharKey(st.sig)
	if quiet and st.sig[key] == sig then
		why = "on, nothing changed since the last time (" .. sig .. ")"
		return true
	end
	local str, err = BuildString(rows)
	if not str then
		why = "could not build the profile: " .. tostring(err)
		return false
	end
	local ok, res, msg = pcall(rawget(_G, "DandersFrames_ClickCast_Import"), str, ProfileName(), true)
	if not (ok and res) then
		why = "DandersFrames import said no: " .. tostring(ok and msg or res)
		if not quiet then
			print(PREFIX .. ns:L("FCLICK_FAIL"))
		end
		return false
	end
	local okA, errA = Activate(st, ProfileName())
	st.sig[key] = sig
	local n = 0
	for _, r in ipairs(rows) do
		if r.action == "spell" then
			n = n + 1
		end
	end
	if okA then
		why = ("on: profile %s, %d spells (%s)"):format(ProfileName(), n, sig)
		print(PREFIX .. ns:L("FCLICK_DONE_FMT"):format(n))
	else
		why = ("profile %s made, but not switched on: %s"):format(ProfileName(), tostring(errA))
		print(PREFIX .. ns:L("FCLICK_MADE_FMT"):format(ProfileName()))
	end
	return okA
end

function ns.SetForeverClick(on)
	local st = Store()
	if not st then
		return
	end
	local key = CharKey(st.on)
	if on and not ns.ForeverClickHasLayout() then
		why = "no heals for your class"
		print(PREFIX .. ns:L("FCLICK_NOCLASS"))
		return
	end
	if on then
		st.on[key] = true
		st.sig[CharKey(st.sig)] = nil -- apply now, even if nothing changed
		Apply(false)
	else
		st.on[key] = nil
		st.sig[CharKey(st.sig)] = nil
		if InCombatLockdown and InCombatLockdown() then
			print(PREFIX .. ns:L("FCLICK_COMBAT"))
			return
		end
		local ok = Undo(st)
		why = ok and "off: put back what DandersFrames had before" or "off (there was nothing to put back)"
		if ok then
			print(PREFIX .. ns:L("FCLICK_UNDONE"))
		end
	end
end

function ns.SetForeverClickKeepLeft(on)
	local st = Store()
	if not st then
		return
	end
	-- plain branches, not `and false or` (lint [29]): nil = the default (keep left-click), false = healer layout
	if on then
		st.keepLeft[CharKey(st.keepLeft)] = nil
	else
		st.keepLeft[CharKey(st.keepLeft)] = false
	end
	if ns.IsForeverClickOn() then
		st.sig[CharKey(st.sig)] = nil
		Apply(false)
	end
end

local function SlotText(code)
	local mod, button = SLOT[code][1], SLOT[code][2]
	local m = (mod == "shift-" and (SHIFT_KEY_TEXT or "Shift")) or (mod == "ctrl-" and (CTRL_KEY_TEXT or "Ctrl"))
		or (mod == "alt-" and (ALT_KEY_TEXT or "Alt")) or nil
	local b = (button == "LeftButton" and (KEY_BUTTON1 or "Left")) or (button == "RightButton" and (KEY_BUTTON2 or "Right"))
		or (KEY_BUTTON3 or "Middle")
	return m and (m .. "+" .. b) or b
end

--- /mh clickheal [why|on|off|heal|offheal]
function ns.ForeverClickSlash(arg)
	arg = (arg or ""):lower()
	if arg == "on" then
		ns.SetForeverClick(true)
		return
	elseif arg == "off" then
		ns.SetForeverClick(false)
		return
	elseif arg == "heal" then
		ns.SetForeverClickKeepLeft(false)
		return
	elseif arg == "offheal" then
		ns.SetForeverClickKeepLeft(true)
		return
	end
	local okDF, missing = DFStatus()
	print(PREFIX .. ("click heals: %s, left-click kept for targeting: %s, class %s, layout %s"):format(
		ns.IsForeverClickOn() and "on" or "off", ns.IsForeverClickKeepLeft() and "yes" or "no", tostring(Class()),
		ns.ForeverClickHasLayout() and "yes" or "no (only Druid, Priest, Paladin, Shaman)"))
	print("  DandersFrames: " .. (okDF and "everything MH needs is there" or ("missing " .. table.concat(missing, ", "))))
	print("  last decision: " .. why)
	local rows, sig = Rows()
	if not rows then
		print("  layout: " .. tostring(sig))
		return
	end
	for _, r in ipairs(rows) do
		local what = (r.action == "spell" and ("%s (%s, id %d)"):format(r.spellName, r.english, r.spellId)) or r.action
		print(("  %s: %s"):format(SlotText(r.code), what))
	end
	-- Slots with names this character does not know yet (so "why is Ctrl+right empty" has an answer).
	local heal = HEAL[Class() or ""] or {}
	local free = {}
	for _, code in ipairs(ORDER) do
		local filled = false
		for _, r in ipairs(rows) do
			if r.code == code then
				filled = true
			end
		end
		local src = ns.IsForeverClickKeepLeft() and OFFHEAL_FROM[code] or code
		if not filled and heal[src] then
			free[#free + 1] = SlotText(code) .. " = " .. table.concat(heal[src], " / ")
		end
	end
	if #free > 0 then
		print("  not learned yet: " .. table.concat(free, "; "))
	end
	print("  signature: " .. tostring(sig))
end

-- While on: follow new spells and ranks, out of combat. Login: once, quietly (nothing changes if nothing changed).
do
	local ev = CreateFrame("Frame")
	local soon = false
	local function Later()
		if soon then
			return
		end
		soon = true
		C_Timer.After(2, function()
			soon = false
			if ns.IsForeverClickOn() then
				Apply(true)
			end
		end)
	end
	for _, e in ipairs({ "PLAYER_ENTERING_WORLD", "SPELLS_CHANGED", "PLAYER_REGEN_ENABLED" }) do
		pcall(ev.RegisterEvent, ev, e)
	end
	ev:SetScript("OnEvent", function(_, event)
		if event == "PLAYER_REGEN_ENABLED" and not pending then
			return
		end
		Later()
	end)
end
