local _, ns = ...

--[[
	ForeverKeyExtras.lua — WoW Forever, layout "12 x 4" only: two extra keys next to the block.

	Rob via Sparring 24-11, 24 Nov 2026: "En shift spatie is op zich wel een goed idee voor de mount. En de interact
	toets, nou, doe maar een voorstel." -> proposal (5 = interact, as a SECOND key) -> "Ja, ik volg advies dus A. Je
	trekt op 5 en dat punt blijft ook werken." ("trekt" = interact, dictated.)

	  5            Interact With Target (INTERACTTARGET; GEMETEN in Forever's GlobalStrings 1.60.1.71091). An extra key:
	               a key you already have for it keeps working (Rob's NUMPADDECIMAL, bindings-cache.wtf).
	               5 is free in 12 x 4 (BLOCK_12 has no 5; the old block uses it, so switching back to old removes this).
	  Shift-Space  a per-character macro "MH Mount": the fastest mount this character knows (ForeverMountData.lua,
	               from Blizzard's Mount tables), refreshed when you learn one. No mount yet: Shift-Space is left alone
	               until you have one.

	Only after a question (once, after placing the 12 x 4 block, or /mh block extras on), never silently over a key
	that does something: the question says what each key does now. Undo: /mh block extras off puts back what each key
	did. Bindings are account-wide in Forever (one bindings-cache.wtf), so the answer is account-wide too; the macro is
	per character because the mounts are. /mh block extras = what MH sees now and why (a module that is quiet needs it).
]]

if not ns.IS_FOREVER then
	return
end

local PREFIX = "|cffffcc00Midnight Helper:|r "
local KEY_INTERACT = "5"
local KEY_MOUNT = "SHIFT-SPACE"
local INTERACT = "INTERACTTARGET"
local MACRO = "MH Mount"
local MACRO_CMD = "MACRO " .. MACRO
local MACRO_ICON = "Ability_Mount_RidingHorse"

local lastWhy = "not checked yet"

local function DB()
	ns.db = ns.db or {}
	ns.db.keyExtras = ns.db.keyExtras or {}
	return ns.db.keyExtras
end

local function InFight()
	return InCombatLockdown and InCombatLockdown()
end

local function Is12()
	return ns.KeyBlockLayoutName and ns.KeyBlockLayoutName() == "12x4"
end

local function Action(key)
	if not GetBindingAction then
		return ""
	end
	local ok, a = pcall(GetBindingAction, key)
	return (ok and type(a) == "string") and a or ""
end

local function SpellName(id)
	if C_Spell and C_Spell.GetSpellName then
		local ok, n = pcall(C_Spell.GetSpellName, id)
		if ok and type(n) == "string" and n ~= "" then
			return n
		end
	end
	if GetSpellInfo then
		local ok, n = pcall(GetSpellInfo, id)
		if ok and type(n) == "string" and n ~= "" then
			return n
		end
	end
	return nil
end

local function Knows(id)
	if id == 0 then
		return true
	end
	if IsPlayerSpell then
		local ok, k = pcall(IsPlayerSpell, id)
		if ok and k then
			return true
		end
	end
	if IsSpellKnown then
		local ok, k = pcall(IsSpellKnown, id)
		if ok and k then
			return true
		end
	end
	return false
end

--- Mount spells from the mount journal, when this client has one (not measured in Forever: guarded).
local function JournalMounts()
	local out = {}
	local J = C_MountJournal
	if not (J and J.GetMountIDs and J.GetMountInfoByID) then
		return out
	end
	local ok, ids = pcall(J.GetMountIDs)
	if not (ok and type(ids) == "table") then
		return out
	end
	for _, mid in ipairs(ids) do
		local okI, _, spellID, _, _, _, _, isFavorite, _, _, hide, isCollected = pcall(J.GetMountInfoByID, mid)
		if okI and isCollected and not hide and type(spellID) == "number" then
			out[spellID] = { favorite = isFavorite and true or false }
		end
	end
	return out
end

--- The fastest mount this character knows: speed from the data (only the speeds whose needed spell you know),
--- a journal favourite first among equals, then the lowest spell id (stable). nil = no mount yet.
--- If a mount you know passes no "needs" check (the needed spell may not show as known in Forever: NOT measured), the
--- second pass ignores the needs, so a player with a mount never hears "no mount yet".
local function BestMount(ignoreNeeds)
	local data = ns.FOREVER_MOUNTS or {}
	local journal = JournalMounts()
	local best, bestScore, anyKnown
	for id, opts in pairs(data) do
		if Knows(id) or journal[id] then
			anyKnown = true
			local speed = -1
			for _, o in ipairs(opts) do
				if o[1] > speed and (ignoreNeeds or Knows(o[2])) then
					speed = o[1]
				end
			end
			if speed >= 0 then
				local score = speed * 10 + ((journal[id] and journal[id].favorite) and 1 or 0)
				if not bestScore or score > bestScore or (score == bestScore and id < best) then
					best, bestScore = id, score
				end
			end
		end
	end
	if not best and anyKnown and not ignoreNeeds then
		return BestMount(true)
	end
	return best
end

local function MacroBody(id)
	local name = SpellName(id)
	if not name then
		return nil
	end
	return "#showtooltip\n/dismount [mounted]\n/cast [nomounted] " .. name, name
end

--- Make or update this character's macro. @return mount name, or nil + why
local function EnsureMacro()
	local id = BestMount()
	if not id then
		return nil, "this character knows no mount yet"
	end
	local body, name = MacroBody(id)
	if not body then
		return nil, "mount spell " .. id .. " has no name yet (not cached)"
	end
	if not (GetMacroIndexByName and CreateMacro and EditMacro) then
		return nil, "no macro functions in this client"
	end
	local idx = GetMacroIndexByName(MACRO)
	if idx and idx > 0 then
		local _, _, oldBody = GetMacroInfo(idx)
		if oldBody ~= body then
			local ok = pcall(EditMacro, idx, MACRO, MACRO_ICON, body)
			if not ok then
				return nil, "EditMacro failed"
			end
		end
	else
		local ok, newIdx = pcall(CreateMacro, MACRO, MACRO_ICON, body, true) -- per character: the mounts are
		if not (ok and newIdx) then
			return nil, "no room for a character macro (CreateMacro failed)"
		end
	end
	DB().mountSpell = id
	return name
end

local function Save()
	if SaveBindings and GetCurrentBindingSet then
		pcall(SaveBindings, GetCurrentBindingSet())
	end
end

--- Remember what a key did before we touched it (only the first time: undo must give back the player's own).
local function Remember(key)
	local d = DB()
	d.prev = d.prev or {}
	if d.prev[key] == nil then
		d.prev[key] = Action(key)
	end
end

local function Say(key, ...)
	print(PREFIX .. ns:L(key):format(...))
end

local function InteractName()
	return _G.BINDING_NAME_INTERACTTARGET or "Interact With Target"
end

--- Bind Shift-Space to the macro when this character has a mount. Quiet = no chat line (login, new mount).
local function ApplyMount(quiet)
	local name, why = EnsureMacro()
	if not name then
		lastWhy = "Shift-Space waits: " .. why
		return false
	end
	if Action(KEY_MOUNT) ~= MACRO_CMD then
		Remember(KEY_MOUNT)
		if SetBinding then
			SetBinding(KEY_MOUNT, MACRO_CMD)
		end
		Save()
		quiet = false
	end
	lastWhy = "on: 5 = interact, Shift-Space = " .. name
	if not quiet then
		Say("KEYEXTRA_MOUNT_SET_FMT", name)
	end
	return true
end

local function Apply()
	if InFight() then
		print(PREFIX .. ns:L("KEYBLOCK_LAYOUT_COMBAT"))
		return false
	end
	if not Is12() then
		print(PREFIX .. ns:L("KEYEXTRA_NEED_12"))
		return false
	end
	local d = DB()
	d.on, d.declined = true, nil
	if Action(KEY_INTERACT) ~= INTERACT then
		Remember(KEY_INTERACT)
		if SetBinding then
			SetBinding(KEY_INTERACT, INTERACT)
		end
		Save()
	end
	if ApplyMount(true) then
		Say("KEYEXTRA_ON_FMT", InteractName())
	else
		Say("KEYEXTRA_ON_NOMOUNT_FMT", InteractName())
	end
	return true
end

--- Put back what each key did. reasonKey = the chat line to print.
local function Undo(reasonKey)
	if InFight() then
		print(PREFIX .. ns:L("KEYBLOCK_LAYOUT_COMBAT"))
		return false
	end
	local d = DB()
	local prev = d.prev or {}
	for _, pair in ipairs({ { KEY_INTERACT, INTERACT }, { KEY_MOUNT, MACRO_CMD } }) do
		local key, ours = pair[1], pair[2]
		if Action(key) == ours and SetBinding then
			local was = prev[key]
			if was and was ~= "" then
				SetBinding(key, was)
			else
				SetBinding(key)
			end
		end
	end
	Save()
	if GetMacroIndexByName and DeleteMacro then
		local idx = GetMacroIndexByName(MACRO)
		if idx and idx > 0 then
			pcall(DeleteMacro, idx)
		end
	end
	d.on, d.prev, d.mountSpell = false, nil, nil
	lastWhy = "off (" .. (reasonKey or "undo") .. ")"
	print(PREFIX .. ns:L(reasonKey or "KEYEXTRA_OFF"))
	return true
end

--- The question (once). Shown after the 12 x 4 block is placed, and at login when it is placed but never answered.
local function Ask()
	local d = DB()
	if d.on ~= nil or d.declined or not Is12() or InFight() then
		return
	end
	if not (ns.KeyBlockIsPlaced and ns.KeyBlockIsPlaced()) then
		return
	end
	local nothing = ns:L("KEYEXTRA_NOTHING")
	local function Now(key)
		local a = Action(key)
		if a == "" or a == "NONE" then
			return nothing
		end
		return _G["BINDING_NAME_" .. a] or a
	end
	local msg = ns:L("KEYEXTRA_ASK_FMT"):format(InteractName(), Now(KEY_INTERACT), Now(KEY_MOUNT))
	-- Button texts at show time, not at load: the chosen language pack (nlNL is manual) is not active yet when this
	-- file loads. Rob, 24 Nov 2026: Dutch text with English "Set them" / "No thanks" under it.
	local dlg = StaticPopupDialogs and StaticPopupDialogs["MH_KEYEXTRA_ASK"]
	if dlg then
		dlg.button1 = ns:L("KEYEXTRA_YES")
		dlg.button2 = ns:L("KEYEXTRA_NO")
	end
	if StaticPopup_Show then
		StaticPopup_Show("MH_KEYEXTRA_ASK", msg)
	end
end
ns.ForeverKeyExtrasAsk = Ask

if StaticPopupDialogs then
	StaticPopupDialogs["MH_KEYEXTRA_ASK"] = {
		text = "%s",
		button1 = ns:L("KEYEXTRA_YES"),
		button2 = ns:L("KEYEXTRA_NO"),
		OnAccept = function()
			Apply()
		end,
		OnCancel = function(_, _, reason)
			if reason == "clicked" then
				DB().declined = true
				print(PREFIX .. ns:L("KEYEXTRA_DECLINED"))
			end
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3,
	}
end

--- /mh block extras [on|off]
function ns.ForeverKeyExtrasCommand(arg)
	arg = (arg or ""):lower():gsub("%s", "")
	if arg == "on" then
		Apply()
		return
	end
	if arg == "off" then
		Undo("KEYEXTRA_OFF")
		return
	end
	if arg ~= "" then
		print(PREFIX .. ns:L("KEYEXTRA_USAGE"))
		return
	end
	local d = DB()
	local best = BestMount()
	print(PREFIX .. "extra keys (5 = interact, Shift-Space = mount):")
	print(("  answer: %s · layout: %s · block placed here: %s"):format(
		d.on == true and "on" or (d.declined and "said no" or (d.on == false and "off" or "not asked yet")),
		Is12() and "12x4" or "old", tostring(ns.KeyBlockIsPlaced and ns.KeyBlockIsPlaced() or false)))
	print(("  5 now: %s · Shift-Space now: %s"):format(Action(KEY_INTERACT) ~= "" and Action(KEY_INTERACT) or "-",
		Action(KEY_MOUNT) ~= "" and Action(KEY_MOUNT) or "-"))
	print(("  fastest mount you know: %s · mount journal in this client: %s"):format(
		best and ((SpellName(best) or "?") .. " (" .. best .. ")") or "none",
		tostring(C_MountJournal ~= nil and C_MountJournal.GetMountIDs ~= nil)))
	print("  last decision: " .. lastWhy)
	print("  " .. ns:L("KEYEXTRA_USAGE"))
end

-- After the block is placed with 12 x 4: ask (once). After an undo of the block: 5 is ours again if we are on (the
-- undo gives back the old block's binding of 5, which is the stale key Rob saw on 24 Nov).
if hooksecurefunc and ns.KeyBlockPlace then
	hooksecurefunc(ns, "KeyBlockPlace", function()
		if C_Timer and C_Timer.After then
			C_Timer.After(1, Ask)
		end
	end)
end
if hooksecurefunc and ns.KeyBlockUndo then
	hooksecurefunc(ns, "KeyBlockUndo", function()
		local d = DB()
		if d.on and Is12() and not InFight() and Action(KEY_INTERACT) ~= INTERACT and SetBinding then
			SetBinding(KEY_INTERACT, INTERACT)
			Save()
		end
	end)
end
-- Back to the old block: it uses 5 itself, so the extras go (with their undo).
if hooksecurefunc and ns.KeyBlockSetStyle then
	hooksecurefunc(ns, "KeyBlockSetStyle", function()
		if DB().on and not Is12() then
			Undo("KEYEXTRA_OFF_STYLE")
		end
	end)
end

local ev = CreateFrame("Frame")
ev:RegisterEvent("PLAYER_ENTERING_WORLD")
ev:RegisterEvent("SPELLS_CHANGED")
ev:RegisterEvent("PLAYER_REGEN_ENABLED")
local pending, loginDone = false, false
ev:SetScript("OnEvent", function(_, event)
	if InFight() then
		pending = true
		return
	end
	if event == "PLAYER_REGEN_ENABLED" and not pending then
		return
	end
	pending = false
	local d = DB()
	if d.on and Is12() then
		ApplyMount(true) -- a new mount, or this character's first login with the extras on
	elseif d.on then
		lastWhy = "on, but this layout is not 12x4"
	end
	if event == "PLAYER_ENTERING_WORLD" and not loginDone then
		loginDone = true
		if C_Timer and C_Timer.After then
			C_Timer.After(12, function()
				if not InFight() then
					Ask()
				end
			end)
		end
	end
end)
