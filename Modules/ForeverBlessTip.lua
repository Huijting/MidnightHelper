local _, ns = ...

--[[
	ForeverBlessTip.lua — WoW Forever, paladin: which blessing for the player under your mouse (step 1 of "slimme zegen").
	Rob, 17 Nov 2026 (via Sparring 17-11): "Kan er een macro komen of bestaat er een macro ... die kan zien wat voor speler
	het is waar ik overheen [ga] en welke ik hem dan moet geven?" On the options (1 tooltip tip, 2 one smart button):
	"Allebei." This is (1); the smart button is (2), later. Plan: docs/IDEEEN.md, "slimme zegen".

	A line in the unit tooltip of a friendly PLAYER: "MH: Blessing of Might (Shift+Z)". Off by default (/mh blesstip on, or
	the setting). The table per class is a suggestion, AFGELEID (Classic knowledge; Might 19740 only gives melee attack
	power in Forever, GEMETEN by sparring in DB2 70938): melee → Might, casters → Wisdom, hybrids and hunters → Kings once
	you have it (20), else Wisdom. A blessing you do not know yet falls back to the next one you do. The player can change
	any class: /mh blesstip set <class> might|wisdom|kings.
	The key in brackets only when MH's key block macro for it exists ("MH SHIFT-Z" etc., ForeverBlock_Paladin.lua).
	NOT measured: whether TooltipDataProcessor (or OnTooltipSetUnit) fires in Forever, and whether UnitClass on a stranger
	is readable (secret values). So: every reading is guarded, /mh blesstip prints the hook, how often it fired and the
	choice + reason for your mouseover, and stores it in ns.db.foreverBlessTipProbe (silence rule, CLAUDE.md).
]]

if not ns.IS_FOREVER then
	return
end

local PREFIX = "|cffffcc00Midnight Helper:|r "
-- English names (ForeverBlock's Known() takes the English name and finds the rank this client knows), and the block key.
local BLESS = {
	-- id = rank 1 (sparring, GEMETEN DB2 wowf 70938), only used to show the client's name in a chat line.
	might = { name = "Blessing of Might", key = "SHIFT-Z", label = "Shift+Z", id = 19740 },
	wisdom = { name = "Blessing of Wisdom", key = "SHIFT-V", label = "Shift+V", id = 19742 },
	kings = { name = "Blessing of Kings", key = "SHIFT-X", label = "Shift+X", id = 20217 },
}
-- First choice per class; then the fallbacks in this order. AFGELEID, Rob/players may change it.
local DEFAULT = {
	WARRIOR = "might", ROGUE = "might",
	MAGE = "wisdom", WARLOCK = "wisdom", PRIEST = "wisdom",
	HUNTER = "kings", DRUID = "kings", SHAMAN = "kings", PALADIN = "kings",
}
local FALLBACK = { kings = { "kings", "wisdom", "might" }, wisdom = { "wisdom", "kings", "might" }, might = { "might", "kings", "wisdom" } }

local state = { hook = "none", fired = 0 }

local function Enabled()
	return ns.db and ns.db.foreverBlessTip == true
end

local function IsPaladin()
	local _, token = UnitClass("player")
	return token == "PALADIN"
end

local function Clean(v)
	if v == nil or (issecretvalue and issecretvalue(v)) then
		return nil
	end
	return v
end

local function Known(name)
	return ns.ForeverKnownSpell and ns.ForeverKnownSpell(name) or nil
end

--- The blessing for a unit: kind ("might"…), spell id, label, and the reason. nil + reason when there is none.
local function Pick(unit)
	if not unit then
		return nil, "no unit"
	end
	-- 21 Nov 2026 (sparring: does UnitIsPlayer give nil/secret since the 20 Nov hotfix?): the reasons are split, so a
	-- secret or an error can be told from a plain "no" in /mh blesstip and foreverBlessTipProbe. Not measured yet.
	local okE, exists = pcall(UnitExists, unit)
	if okE and exists == false then
		return nil, "no " .. unit
	end
	local okP, isPlayer = pcall(UnitIsPlayer, unit)
	if not okP then
		return nil, "UnitIsPlayer error"
	elseif issecretvalue and issecretvalue(isPlayer) then
		return nil, "UnitIsPlayer secret"
	elseif isPlayer == nil then
		return nil, "UnitIsPlayer nil"
	elseif not isPlayer then
		return nil, "not a player"
	end
	local okA, assist = pcall(UnitCanAssist, "player", unit)
	if not okA then
		return nil, "UnitCanAssist error"
	elseif issecretvalue and issecretvalue(assist) then
		return nil, "UnitCanAssist secret"
	elseif not assist then
		return nil, "not friendly"
	end
	local okC, _, token = pcall(UnitClass, unit)
	token = okC and Clean(token) or nil
	if type(token) ~= "string" then
		return nil, "class unreadable"
	end
	local own = ns.db and ns.db.foreverBlessTable and ns.db.foreverBlessTable[token]
	local want = BLESS[own] and own or DEFAULT[token] or "kings"
	for i, kind in ipairs(FALLBACK[want]) do
		local id = Known(BLESS[kind].name)
		if id then
			local why = ("%s → %s%s%s"):format(token, want, own and " (your choice)" or "",
				i > 1 and (", not known yet, so " .. kind) or "")
			return kind, id, token, why
		end
	end
	return nil, ("%s → %s, but you know no blessing yet"):format(token, want)
end

local function KeyLabel(kind)
	local b = BLESS[kind]
	if GetMacroIndexByName then
		local ok, idx = pcall(GetMacroIndexByName, "MH " .. b.key)
		if ok and type(idx) == "number" and idx > 0 then
			return b.label
		end
	end
	return nil
end

local function SpellName(id)
	if C_Spell and C_Spell.GetSpellName then
		local ok, n = pcall(C_Spell.GetSpellName, id)
		if ok and type(n) == "string" and n ~= "" and not (issecretvalue and issecretvalue(n)) then
			return n
		end
	end
	return nil
end

local function OnUnitTooltip(tt)
	state.fired = state.fired + 1
	if not (Enabled() and IsPaladin()) or tt ~= GameTooltip then
		return
	end
	local ok, _, unit = pcall(tt.GetUnit, tt)
	unit = ok and Clean(unit) or nil
	local kind, id, token, why = Pick(unit)
	state.last = { unit = unit, pick = kind, why = token and why or id }
	if not kind then
		return
	end
	local key = KeyLabel(kind)
	local name = SpellName(id) or BLESS[kind].name
	tt:AddLine(ns:L("FBLESS_TIP_FMT"):format(name .. (key and (" (" .. key .. ")") or "")), 0.95, 0.80, 0.35)
	tt:Show()
end

local function Hook()
	if TooltipDataProcessor and TooltipDataProcessor.AddTooltipPostCall and Enum and Enum.TooltipDataType
		and Enum.TooltipDataType.Unit then
		local ok = pcall(TooltipDataProcessor.AddTooltipPostCall, Enum.TooltipDataType.Unit, OnUnitTooltip)
		if ok then
			state.hook = "TooltipDataProcessor"
			return
		end
	end
	if GameTooltip and GameTooltip.HasScript and GameTooltip:HasScript("OnTooltipSetUnit") then
		GameTooltip:HookScript("OnTooltipSetUnit", OnUnitTooltip)
		state.hook = "OnTooltipSetUnit"
	end
end

--------------------------------------------------------------------------------
-- (2) The smart blessing button (19 Nov 2026; Rob via sparring, letterlijk: "Ja, die mogen door" on step 2 of
-- "slimme zegen", plan in docs/IDEEEN.md). ONE key that blesses the friendly player under your mouse with the blessing
-- Pick() chooses (the same choice as the tooltip line, and your own table).
-- How (the plan's rules): a hidden SecureActionButton "MidnightHelperSmartBless"; a SEPARATE event frame sets its
-- attributes out of combat (since 21 Nov 2026: type macro + one /cast line for mouseover, then target, see below); in
-- combat the last choice stays (attributes cannot change then); no script on the secure button itself (lesson
-- ForeverPartyPanel.lua:12-13).
-- Clicks: up AND down since 21 Nov 2026 (see BuildSmart: a key press is a down-click). You press it through a macro
-- "MH Smart Bless" (/click MidnightHelperSmartBless), made when you switch it on, out of combat; drag it to a bar.
-- Off by default (players choose): ns.db.foreverSmartBless == true. /mh blesstip says the button's state and spell.
-- NOT measured: that /click reaches a secure button in Forever, and UPDATE_MOUSEOVER_UNIT on unit frames.
--------------------------------------------------------------------------------
-- 21 Nov 2026 (Rob via sparring: "Als ik iemand geselecteerd heb en die hard doorloopt, dat ik daarna op F5 druk" → on
-- "Eerst de muis, anders je doelwit": "Ja, doe maar."): the button is now type "macro" with one /cast line,
-- "/cast [@mouseover,help,nodead] <spell for the mouseover>; [@target,help,nodead] <spell for the target>". The game
-- picks the clause at the moment you press (secure conditions, the same [@mouseover,help,nodead] that ForeverBlock.lua
-- already uses in Forever); MH only rewrites the line out of combat, on UPDATE_MOUSEOVER_UNIT and PLAYER_TARGET_CHANGED.
-- A clause is only there when Pick() found a friendly PLAYER for it. Neither = no line: the key does nothing (no
-- self-cast; Rob asked for mouse or target, and a blessing on yourself by accident costs mana — sparring was told).
-- In combat the last line stays: the clause order still works, but the spells are those of the last choice.
-- AFGELEID from the old code why it "first did not work, later did" (Rob, 21 Nov): the spell attribute was only set on
-- UPDATE_MOUSEOVER_UNIT with a player under the mouse, so before the first hover the button had no spell at all.
local SMART_NAME, SMART_MACRO = "MidnightHelperSmartBless", "MH Smart Bless"
local smart, smartWhy, smartSpell = nil, "not built (switched off, or not a paladin)", nil
local smartLine, targetWhy = nil, "not checked yet"
local smartClicks, smartLastClick = 0, "never this session"
local mouseSpell, targetSpell -- the spell ids in the current line (nil = no clause)

local function SmartOn()
	return ns.db and ns.db.foreverSmartBless == true
end

local function BuildSmart()
	if smart or (InCombatLockdown and InCombatLockdown()) then
		return smart
	end
	smart = CreateFrame("Button", SMART_NAME, UIParent, "SecureActionButtonTemplate")
	smart:SetSize(1, 1)
	smart:SetPoint("TOPLEFT", UIParent, "TOPLEFT", -50, 50) -- off screen: only the macro clicks it
	-- 21 Nov 2026 (Rob: "Ik heb niks gedaan, maar het werkt niet", pressing F5): it listened to LeftButtonUp only, with
	-- useOnKeyDown false. A /click from a KEY comes in as a key-down when ActionButtonUseKeyDown is on, and that CVar is
	-- not in Rob's Forever Config.wtf / config-cache.wtf (GEMETEN: absent, so the client default; that the default is 1
	-- in Forever is AFGELEID from retail). So a key press never reached it, a mouse click on the macro icon did — "first
	-- not, then yes". Now both, and the template picks the one that matches the CVar (no double cast).
	smart:RegisterForClicks("AnyUp", "AnyDown")
	smart:SetAttribute("type", "macro")
	-- A click counter for /mh blesstip (a post-hook; it changes nothing about the secure click itself).
	smart:HookScript("OnClick", function(self, button, down)
		smartClicks = smartClicks + 1
		local ok, txt = pcall(self.GetAttribute, self, "macrotext")
		smartLastClick = ("%s, %s %s, line: %s"):format(date and date("%H:%M:%S") or "?", tostring(button),
			down and "down" or "up", (ok and txt) or "none")
	end)
	return smart
end

local macroBody, macroWhy = nil, "not written yet"

--- Write the line into the macro the player presses. nil line = a /run line that says why nothing happens.
local function WriteMacro(line)
	if not (GetMacroIndexByName and EditMacro) or (InCombatLockdown and InCombatLockdown()) then
		macroWhy = "cannot edit macros now (in combat or no API)"
		return
	end
	local body
	if line then
		body = "#showtooltip\n" .. line
	else
		local msg = ns:L("FBLESS_NONE"):gsub("[\"\\]", "")
		body = "#showtooltip\n/run print(\"" .. msg .. "\")"
	end
	if #body > 255 then
		macroWhy = ("line too long for a macro (%d characters)"):format(#body)
		return
	end
	if body == macroBody then
		return
	end
	local ok, idx = pcall(GetMacroIndexByName, SMART_MACRO)
	if not (ok and type(idx) == "number" and idx > 0) then
		macroWhy = "the macro \"" .. SMART_MACRO .. "\" does not exist (/mh blesstip button on makes it)"
		return
	end
	local okE, err = pcall(EditMacro, idx, SMART_MACRO, 134400, body)
	if okE then
		macroBody = body
		macroWhy = "written " .. (date and date("%H:%M:%S") or "")
	else
		macroWhy = "EditMacro error: " .. tostring(err)
	end
end

--- The /cast line for the current mouseover and target (out of combat only).
local function SmartUpdate(event)
	if not (SmartOn() and IsPaladin()) then
		smartWhy = "switched off (or not a paladin)"
		return
	end
	if InCombatLockdown and InCombatLockdown() then
		smartWhy = "in combat: the last choice stays"
		return
	end
	local b = BuildSmart()
	if not b then
		return
	end
	if smartWhy == "in combat: the last choice stays" then
		smartWhy = "updated after the fight"
	end
	-- The mouseover clause is only rewritten when the mouse is over a unit (UPDATE_MOUSEOVER_UNIT): typing in chat or
	-- leaving a player does not fire it, and the [@mouseover] condition handles "nobody under the mouse" at the press.
	local mKind, mId, _, mWhy
	if event == "UPDATE_MOUSEOVER_UNIT" or mouseSpell == nil then
		mKind, mId, _, mWhy = Pick("mouseover")
		if mKind and mId then
			mouseSpell = mId
			smartWhy = "mouseover: " .. mWhy
		elseif event == "UPDATE_MOUSEOVER_UNIT" then
			mouseSpell = nil
			smartWhy = "mouseover: " .. tostring(mId) .. " (no mouseover part)"
		end
	end
	local tKind, tId, _, tWhy = Pick("target")
	if tKind and tId then
		targetSpell = tId
		targetWhy = tWhy
	else
		targetSpell = nil
		targetWhy = tostring(tId) .. " (no target part)"
	end
	local parts = {}
	if mouseSpell then
		parts[#parts + 1] = "[@mouseover,help,nodead] " .. (SpellName(mouseSpell) or tostring(mouseSpell))
	end
	if targetSpell then
		parts[#parts + 1] = "[@target,help,nodead] " .. (SpellName(targetSpell) or tostring(targetSpell))
	end
	local line = #parts > 0 and ("/cast " .. table.concat(parts, "; ")) or nil
	if line ~= smartLine then
		b:SetAttribute("macrotext", line)
		smartLine = line
	end
	smartSpell = mouseSpell or targetSpell
	-- 21 Nov 2026 (Rob, after 5213ee8: "Nee, er gebeurt helemaal niks", while /mh blesstip showed the press reached the
	-- button as "up" with the right line, and ActionButtonUseKeyDown = 1; his Purify macro on the same kind of mouse
	-- button works): the /click → secure macro button road casts nothing in Forever (GEMETEN by Rob; WHY is not known).
	-- Sparring's proposal: MH writes the /cast line into the macro "MH Smart Bless" itself (EditMacro, out of combat,
	-- only when the line changes), so the key runs a plain macro like his Purify. The hidden button stays only for the
	-- diagnosis.
	WriteMacro(line)
end

--- Make the macro once (out of combat); true when it exists afterwards.
local function SmartMacro()
	if not (GetMacroIndexByName and CreateMacro) or (InCombatLockdown and InCombatLockdown()) then
		return false
	end
	local ok, idx = pcall(GetMacroIndexByName, SMART_MACRO)
	if ok and type(idx) == "number" and idx > 0 then
		return true
	end
	local okC = pcall(CreateMacro, SMART_MACRO, 134400, "#showtooltip\n/run print(\"MH\")", true)
	if okC then
		macroBody = nil
		WriteMacro(smartLine)
	end
	return okC
end

function ns.IsForeverSmartBlessOn()
	return SmartOn()
end

function ns.SetForeverSmartBless(on)
	ns.db = ns.db or {}
	if on then
		ns.db.foreverSmartBless = true
		BuildSmart()
		SmartUpdate()
		if SmartMacro() then
			print(PREFIX .. ns:L("FBLESS_BTN_ON_FMT"):format(SMART_MACRO))
			if ShowMacroFrame then
				pcall(ShowMacroFrame) -- to drag it onto a bar (AFGELEID that Forever has it, as ForeverMacros.lua says)
			end
		else
			print(PREFIX .. ns:L("FBLESS_BTN_NOMACRO"))
		end
	else
		ns.db.foreverSmartBless = nil
		print(PREFIX .. ns:L("FBLESS_BTN_OFF"))
	end
end

local sev = CreateFrame("Frame")
pcall(sev.RegisterEvent, sev, "UPDATE_MOUSEOVER_UNIT")
pcall(sev.RegisterEvent, sev, "PLAYER_TARGET_CHANGED")
pcall(sev.RegisterEvent, sev, "PLAYER_REGEN_ENABLED")
pcall(sev.RegisterEvent, sev, "PLAYER_ENTERING_WORLD")
sev:SetScript("OnEvent", function(_, event)
	if SmartOn() then
		SmartUpdate(event)
	end
end)

-- Hook once, at login (the tooltip exists by then); cheap when the switch is off (one counter, one return).
local ev = CreateFrame("Frame")
ev:RegisterEvent("PLAYER_LOGIN")
ev:SetScript("OnEvent", function(self)
	self:UnregisterAllEvents()
	if IsPaladin() then
		Hook()
	end
end)

--- /mh blesstip [on|off|set <class> <might|wisdom|kings>|reset]: the switch, your own table, and the diagnosis.
function ns.ForeverBlessTipSlash(arg)
	arg = (arg or ""):lower()
	ns.db = ns.db or {}
	if arg == "on" or arg == "off" then
		ns.db.foreverBlessTip = (arg == "on") or nil
		print(PREFIX .. ns:L(arg == "on" and "FBLESS_ON" or "FBLESS_OFF"))
		return
	end
	if arg == "button on" or arg == "button off" then
		ns.SetForeverSmartBless(arg == "button on")
		return
	end
	local cls, kind = arg:match("^set%s+(%a+)%s+(%a+)$")
	if cls then
		cls = cls:upper()
		if not DEFAULT[cls] or not BLESS[kind] then
			print(PREFIX .. ns:L("FBLESS_SET_USAGE"))
			return
		end
		ns.db.foreverBlessTable = ns.db.foreverBlessTable or {}
		ns.db.foreverBlessTable[cls] = kind
		-- The client's own words (a translator saw "HUNTER now gets might" in every language).
		local names = LOCALIZED_CLASS_NAMES_MALE
		print(PREFIX .. ns:L("FBLESS_SET_FMT"):format((names and names[cls]) or cls,
			SpellName(BLESS[kind].id) or BLESS[kind].name))
		return
	end
	if arg == "reset" then
		ns.db.foreverBlessTable = nil
		print(PREFIX .. ns:L("FBLESS_RESET"))
		return
	end
	-- Diagnosis: what MH reads and decides for your mouseover right now.
	local kind, id, token, why = Pick("mouseover")
	print(PREFIX .. ("blessing tip: %s, paladin %s, hook %s, fired %d time(s)"):format(Enabled() and "ON" or "off",
		tostring(IsPaladin()), state.hook, state.fired))
	print("  mouseover: " .. (kind and (("%s (%s) — %s"):format(SpellName(id) or kind, tostring(id), why)) or tostring(id)))
	-- The smart button (19 Nov 2026): on/off, built, the spell on it now, the last decision, and the macro.
	local mOk, mIdx = false, 0
	if GetMacroIndexByName then
		mOk, mIdx = pcall(GetMacroIndexByName, SMART_MACRO)
	end
	print(("  smart button: %s, built %s, last: %s; macro \"%s\" %s (/mh blesstip button on|off)"):format(
		SmartOn() and "ON" or "off", tostring(smart ~= nil), smartWhy, SMART_MACRO,
		(mOk and type(mIdx) == "number" and mIdx > 0) and "exists" or "missing"))
	-- 21 Nov 2026: the target part, and the exact line the key runs (mouse first, then target).
	local tk, tid, _, twhy = Pick("target")
	print("  target now: " .. (tk and (("%s (%s) — %s"):format(SpellName(tid) or tk, tostring(tid), twhy)) or tostring(tid)))
	print("  target on the button: " .. targetWhy)
	print("  the key runs: " .. (smartLine or "nothing (no friendly player under the mouse or as target yet)")
		.. ((InCombatLockdown and InCombatLockdown()) and "  — in combat: this stays until the fight ends" or ""))
	local kd = C_CVar and C_CVar.GetCVar and C_CVar.GetCVar("ActionButtonUseKeyDown")
	print(("  presses that reached the hidden button (old road, no longer used by the macro): %d · last: %s · ActionButtonUseKeyDown = %s"):format(smartClicks,
		smartLastClick, tostring(kd)))
	-- 21 Nov 2026: the macro itself now carries the line.
	local okB, mBody = false, nil
	if GetMacroIndexByName and GetMacroBody then
		local okI, idx = pcall(GetMacroIndexByName, SMART_MACRO)
		if okI and type(idx) == "number" and idx > 0 then
			okB, mBody = pcall(GetMacroBody, idx)
		end
	end
	print("  macro \"" .. SMART_MACRO .. "\" now: " .. ((okB and type(mBody) == "string") and mBody:gsub("\n", " | ") or "?")
		.. " · last write: " .. macroWhy)
	print("  (typing this in chat: your mouse is on the chat, so \"mouseover\" above reads nothing — that is normal)")
	local t = {}
	for c, d in pairs(DEFAULT) do
		local own = ns.db.foreverBlessTable and ns.db.foreverBlessTable[c]
		t[#t + 1] = c:sub(1, 3) .. "=" .. (own and (own .. "*") or d)
	end
	table.sort(t)
	print("  table (* = yours): " .. table.concat(t, " "))
	print("  " .. ns:L("FBLESS_HELP"))
	ns.db.foreverBlessTipProbe = {
		at = time and time() or 0, enabled = Enabled(), hook = state.hook, fired = state.fired,
		mouseover = { pick = kind, id = id, class = token, why = kind and why or id }, last = state.last,
		target = { pick = tk, id = tid, why = tk and twhy or tid }, line = smartLine, smartWhy = smartWhy,
		clicks = smartClicks, lastClick = smartLastClick, keyDownCVar = kd,
	}
	print("  saved in SavedVariables (foreverBlessTipProbe) — /reload writes it to disk.")
end
