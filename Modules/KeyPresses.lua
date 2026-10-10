--[[
	Key presses: which spells you press most, and whether they sit on easy keys.

	Rob, 9 Oct 2026, after dropping the Single-Button Assistant for Blizzard's highlight: "ik ga van 1
	naar Ctrl 5, naar Shift 2 ... bijna geen logische volgorde. Is dat te checken en te corrigeren?"
	Blizzard's highlight says WHAT to press next, never WHERE it should live; bars fill in the order
	spells were learned. This is Spec 07 phase 2 (memory spec-07-08-keybinds): count your own casts,
	put the count next to the key the spell really sits on (ns.LiveKeyForSpell), and say which swaps
	would put the busy spells on the easy keys. Rob chose "count + report + suggestion"; moving the
	buttons stays his (one or two at a time: a layout change is a habit change).

	OPT-IN, OFF BY DEFAULT (players choose): `/mh presses on`, or the switch under Combat.
	Counts the player's OWN casts in combat only (UNIT_SPELLCAST_SUCCEEDED for "player", the same
	event TankPullSummary and InterruptScore already count). A secret spell id is skipped, never
	guessed. Stored account-wide per character and spec in ns.db.keyPresses.

	⚠️ THE KEY IS WHERE THE SPELL SITS, NOT WHICH KEY WAS PRESSED. The game does not tell us the key.
	A spell on two buttons shows the one LiveKeys picks; a click shows up as that key too.

	⚠️ "EASY" IS A RULE OF THUMB ABOUT KEYS, NOT YOUR HANDS (never assume hardware). Unmodified
	1-5 / Q E R F and mouse buttons count as easy; Shift adds a little, Ctrl or Alt more. Keys on bar 8
	count as thumb keys ONLY when the player used the thumb-pad button (ns.db.padKeyHome has entries),
	because only then do we know they are a thumb pad. The report prints this rule, so a hint never
	reads as a verdict.

	`/mh presses why` prints every counted spell with its id, key, score and why it was left out.
]]

local _, ns = ...

local MIN_COUNT = 5 -- below this a spell is noise in the suggestions
local MAX_ROWS = 8
local MAX_SWAPS = 3

local EASY_BASE = { ["1"] = 0, ["2"] = 0, ["3"] = 0, ["4"] = 0, ["5"] = 0, Q = 0, E = 0, R = 0, F = 0,
	BUTTON3 = 0, BUTTON4 = 0, BUTTON5 = 0 }
local MID_BASE = { ["6"] = 1, T = 1, G = 1, Z = 1, X = 1, C = 1, V = 1, ["`"] = 1 }

local function Prefix()
	return ("|cffffcc00%s|r"):format(ns:L("PRINT_PREFIX"))
end

local function Store()
	ns.db = ns.db or {}
	ns.db.keyPresses = ns.db.keyPresses or { on = false, chars = {} }
	ns.db.keyPresses.chars = ns.db.keyPresses.chars or {}
	return ns.db.keyPresses
end

function ns.IsKeyPressesEnabled()
	return ns.db and ns.db.keyPresses and ns.db.keyPresses.on == true or false
end

function ns.SetKeyPressesEnabled(v)
	Store().on = v and true or false
end

local function CharKey()
	local name = UnitName and UnitName("player")
	local realm = GetRealmName and GetRealmName()
	if not name or (issecretvalue and issecretvalue(name)) then
		return nil
	end
	return name .. "-" .. (realm or "?")
end

local function SpecID()
	if ns.GetSpecialization and ns.GetSpecializationInfo then
		local idx = ns.GetSpecialization()
		return idx and ns.GetSpecializationInfo(idx) or nil
	end
	return nil
end

--- The table for this character + spec; created on demand.
local function Bucket(create)
	local ck, spec = CharKey(), SpecID()
	if not (ck and spec) then
		return nil, spec
	end
	local chars = Store().chars
	if not chars[ck] then
		if not create then
			return nil, spec
		end
		chars[ck] = {}
	end
	local b = chars[ck][spec]
	if not b and create then
		b = { fights = 0, spells = {} }
		chars[ck][spec] = b
	end
	return b, spec
end

--- Thumb pad known? Only when the player used the bar-8 pad button (BarEightKeys).
local function ThumbPadKnown()
	return ns.db and type(ns.db.padKeyHome) == "table" and next(ns.db.padKeyHome) ~= nil
end

--- @return number score  0 = easiest; the label comes from Label()
local function Reach(rawKey, cmd)
	if not rawKey then
		return 99
	end
	local mods, base = 0, rawKey
	while true do
		local m, rest = base:match("^(%u+)%-(.+)$")
		if not m or not (m == "SHIFT" or m == "CTRL" or m == "ALT" or m == "META") then
			break
		end
		mods = mods + (m == "SHIFT" and 1 or 3)
		base = rest
	end
	local b
	if EASY_BASE[base] then
		b = 0
	elseif ThumbPadKnown() and cmd and cmd:match("^MULTIACTIONBAR7BUTTON") then
		b = 0
	elseif MID_BASE[base] then
		b = 1
	else
		b = 2
	end
	return b + mods
end

local function Label(score)
	if score <= 0 then
		return "|cff40c040" .. ns:L("PRESSES_EASY") .. "|r"
	elseif score <= 2 then
		return "|cffffd100" .. ns:L("PRESSES_MID") .. "|r"
	end
	return "|cffff6040" .. ns:L("PRESSES_HARD") .. "|r"
end

local function SpellName(id)
	if C_Spell and C_Spell.GetSpellName then
		local ok, n = pcall(C_Spell.GetSpellName, id)
		if ok and type(n) == "string" and not (issecretvalue and issecretvalue(n)) then
			return n
		end
	end
	return tostring(id)
end

-- Auto-attacks fire UNIT_SPELLCAST_SUCCEEDED on every swing or shot, and nobody presses them. Rob, 9 Oct 2026, on a
-- Beast Mastery Hunter: "1. Auto Shot 16x not on a key" topped the list. 75 = Auto Shot, 6603 = Auto Attack (the
-- melee swing); `/mh presses why` prints the id, so a third one shows up there.
local AUTO_ATTACK = { [75] = true, [6603] = true }

--- Spells worth a row: on a bound button, or an active spell the player knows (clicked / unbound).
--- Passives, auto-attacks and triggered effects also fire the cast event; those are left out, with the reason.
local function Classify(id)
	if AUTO_ATTACK[id] then
		return "auto"
	end
	local short, hit = nil, nil
	if ns.LiveKeyForSpell then
		short, hit = ns.LiveKeyForSpell(id)
	end
	if short and hit then
		return "key", short, hit
	end
	if C_Spell and C_Spell.IsSpellPassive then
		local ok, passive = pcall(C_Spell.IsSpellPassive, id)
		if ok and passive == true then
			return "passive"
		end
	end
	if IsPlayerSpell then
		local ok, known = pcall(IsPlayerSpell, id)
		if ok and known then
			return "nokey"
		end
	end
	return "other"
end

--- Rows sorted by count, each { id, n, kind, short, hit, score }.
local function Rows(bucket)
	if ns.LiveKeysInvalidate then
		ns.LiveKeysInvalidate()
	end
	local rows = {}
	for id, n in pairs(bucket.spells) do
		local kind, short, hit = Classify(id)
		rows[#rows + 1] = { id = id, n = n, kind = kind, short = short, hit = hit,
			score = hit and Reach(hit.key, hit.cmd) or 99 }
	end
	table.sort(rows, function(a, b)
		if a.n ~= b.n then
			return a.n > b.n
		end
		return a.id < b.id
	end)
	return rows
end

-- Spells that must stay on an easy key however rarely they are pressed. Rob, 10 Oct 2026, on his Shadow Priest:
-- "Tip: swap Mind Flay (8x, on s-1) with Silence (2x, on E)" - "niet handig om een interrupt te switchen". A kick
-- or a defensive is pressed seldom and then at once. Taken from MH's own keybind roles (ns.KeybindRoleClassifier,
-- by spell id, so it works in every client language): role "interrupt", and every spell with a Stay alive line.
local keepEasy, keepEasyClass

local function Base(id)
	if FindBaseSpellByID then
		local ok, b = pcall(FindBaseSpellByID, id)
		if ok and b then
			return b
		end
	end
	return id
end

local function KeepEasy(id)
	local token = UnitClass and select(2, UnitClass("player"))
	if token ~= keepEasyClass then
		keepEasyClass, keepEasy = token, {}
		for _, e in pairs((ns.KeybindRoleClassifier or {})[token] or {}) do
			if type(e) == "table" and e.id and (e.role == "interrupt" or e.survival) then
				keepEasy[e.id] = true
			end
		end
	end
	return keepEasy[id] or keepEasy[Base(id)] or false
end

--- Swaps: a busy spell on a harder key, and a quiet one (a third or less) on an easier key. The quiet one is never
--- an interrupt or a defensive (KeepEasy).
local function Swaps(rows)
	local out, used = {}, {}
	for _, busy in ipairs(rows) do
		if #out >= MAX_SWAPS then
			break
		end
		if busy.kind == "key" and busy.n >= MIN_COUNT and busy.score > 0 and not used[busy] then
			local best
			for _, quiet in ipairs(rows) do
				if quiet ~= busy and quiet.kind == "key" and not used[quiet] and quiet.score < busy.score
					and not KeepEasy(quiet.id)
					and quiet.n * 3 <= busy.n and (not best or quiet.score < best.score) then
					best = quiet
				end
			end
			if best then
				used[busy], used[best] = true, true
				out[#out + 1] = { busy = busy, quiet = best }
			end
		end
	end
	return out
end

--------------------------------------------------------------------------------
-- The report window. Rob, 9 Oct 2026, after testing on a Hunter: "de presses ding moet ook in een venster komen
-- want in een chat is het onoverzichtelijk". Same rows, same rules as the chat report it replaces; `/mh presses why`
-- stays in chat (it is a diagnosis, not a report). Drag, Shift+scroll, dock and Escape come from
-- RegisterMidnightDialogPopup. Refreshes itself after each fight while it is open.
--------------------------------------------------------------------------------

local WIN_W, ROW_H, PAD = 470, 22, 16
local win

local function SpecName(spec)
	if spec and GetSpecializationInfoByID then
		local ok, _, n = pcall(GetSpecializationInfoByID, spec)
		if ok and type(n) == "string" then
			return n
		end
	end
	return tostring(spec or "?")
end

local function SpellIcon(id)
	if C_Spell and C_Spell.GetSpellTexture then
		local ok, tex = pcall(C_Spell.GetSpellTexture, id)
		if ok and tex and not (issecretvalue and issecretvalue(tex)) then
			return tex
		end
	end
	return 134400
end

local function Text(parent, template, justify)
	local fs = parent:CreateFontString(nil, "OVERLAY", template)
	if ns.MHScalableFont then
		fs:SetFontObject(ns.MHScalableFont(template))
	end
	fs:SetJustifyH(justify or "LEFT")
	fs:SetWordWrap(true)
	return fs
end

local function Row(i)
	win.rows = win.rows or {}
	local r = win.rows[i]
	if r then
		return r
	end
	r = CreateFrame("Frame", nil, win)
	r:SetSize(WIN_W - 2 * PAD, ROW_H)
	r.icon = r:CreateTexture(nil, "ARTWORK")
	r.icon:SetSize(18, 18)
	r.icon:SetPoint("LEFT", 0, 0)
	r.name = Text(r, "GameFontHighlight")
	r.name:SetPoint("LEFT", r.icon, "RIGHT", 6, 0)
	r.name:SetWidth(200)
	r.name:SetWordWrap(false)
	r.count = Text(r, "GameFontHighlight", "RIGHT")
	r.count:SetPoint("LEFT", r, "LEFT", 228, 0)
	r.count:SetWidth(44)
	r.key = Text(r, "GameFontNormal")
	r.key:SetPoint("LEFT", r, "LEFT", 284, 0)
	r.key:SetWidth(70)
	r.key:SetWordWrap(false)
	r.reach = Text(r, "GameFontHighlight")
	r.reach:SetPoint("LEFT", r, "LEFT", 360, 0)
	r.reach:SetWidth(WIN_W - 2 * PAD - 360)
	r.reach:SetWordWrap(false)
	win.rows[i] = r
	return r
end

--- Button text that may be longer in German or French ("Effacer la spécialisation"): the button grows with it.
local function SetButtonText(btn, text)
	btn:SetText(text)
	local fs = btn:GetFontString()
	btn:SetWidth(math.max(150, (fs and fs:GetStringWidth() or 120) + 24))
end

local function Refresh()
	if not win then
		return
	end
	local on = ns.IsKeyPressesEnabled()
	SetButtonText(win.toggle, ns:L(on and "PRESSES_BTN_OFF" or "PRESSES_BTN_ON"))
	for _, r in ipairs(win.rows or {}) do
		r:Hide()
	end
	local y = -44
	local bucket, spec = Bucket(false)
	win.title:SetText(ns:L("PRESSES_WIN_TITLE"))
	win.head:ClearAllPoints()
	win.tips:ClearAllPoints()
	win.rule:ClearAllPoints()

	local lines = {}
	if not on then
		lines[#lines + 1] = "|cffff9900" .. ns:L("PRESSES_IS_OFF") .. "|r"
	end
	-- Nothing to clear when nothing was counted.
	win.reset:SetShown(bucket and next(bucket.spells) and true or false)
	if not bucket or not next(bucket.spells) then
		-- Rob, 10 Oct 2026, empty window on his Warlock: the button said "Turn counting off" while the text said
		-- "turn it on with /mh presses on". With counting on, say that the list fills itself.
		lines[#lines + 1] = ns:L(on and "PRESSES_NONE_ON" or "PRESSES_NONE")
		win.head:SetText(table.concat(lines, "\n"))
		win.head:SetPoint("TOPLEFT", win, "TOPLEFT", PAD, y)
		y = y - win.head:GetStringHeight() - 10
		win.tips:SetText("")
		win.rule:SetText("")
		win:SetHeight(-y + 50)
		return
	end
	lines[#lines + 1] = ns:L("PRESSES_HEAD"):format(SpecName(spec), bucket.fights or 0)
	win.head:SetText(table.concat(lines, "\n"))
	win.head:SetPoint("TOPLEFT", win, "TOPLEFT", PAD, y)
	y = y - win.head:GetStringHeight() - 8

	local rows, shown = Rows(bucket), 0
	for _, r in ipairs(rows) do
		if shown >= MAX_ROWS then
			break
		end
		if r.kind == "key" or r.kind == "nokey" then
			shown = shown + 1
			local row = Row(shown)
			row:ClearAllPoints()
			row:SetPoint("TOPLEFT", win, "TOPLEFT", PAD, y)
			row.icon:SetTexture(SpellIcon(r.id))
			row.name:SetText(SpellName(r.id))
			row.count:SetText(r.n .. "x")
			if r.kind == "key" then
				row.key:SetText("[" .. r.short .. "]")
				row.reach:SetText(Label(r.score))
			else
				row.key:SetText("|cff9d9d9d-|r")
				row.reach:SetText("|cff9d9d9d" .. ns:L("PRESSES_NOKEY") .. "|r")
			end
			row:Show()
			y = y - ROW_H
		end
	end

	local swaps, tips = Swaps(rows), {}
	if #swaps == 0 then
		tips[#tips + 1] = "|cff40c040" .. ns:L("PRESSES_NOSWAP") .. "|r"
	else
		for _, s in ipairs(swaps) do
			tips[#tips + 1] = ns:L("PRESSES_SWAP"):format(SpellName(s.busy.id), s.busy.n, s.busy.short,
				SpellName(s.quiet.id), s.quiet.n, s.quiet.short)
		end
		tips[#tips + 1] = "|cff9d9d9d" .. ns:L("PRESSES_FEW") .. "|r"
	end
	win.tips:SetText(table.concat(tips, "\n"))
	win.tips:SetPoint("TOPLEFT", win, "TOPLEFT", PAD, y - 10)
	y = y - 10 - win.tips:GetStringHeight()
	win.rule:SetText(ns:L("PRESSES_RULE"))
	win.rule:SetPoint("TOPLEFT", win, "TOPLEFT", PAD, y - 10)
	y = y - 10 - win.rule:GetStringHeight()
	win:SetHeight(-y + 50)
end

local function Build()
	if win then
		return win
	end
	local f = CreateFrame("Frame", "MidnightHelperKeyPressesWindow", UIParent, "BackdropTemplate")
	f:SetSize(WIN_W, 300)
	f:SetPoint("CENTER")
	f:SetFrameStrata("DIALOG")
	f:EnableMouse(true)
	f:SetMovable(true)
	f:RegisterForDrag("LeftButton")
	f:SetScript("OnDragStart", f.StartMoving)
	f:SetScript("OnDragStop", f.StopMovingOrSizing)
	f:Hide()
	if ns.ApplyMidnightDialogBackdrop then
		ns.ApplyMidnightDialogBackdrop(f)
	end
	if ns.RegisterMidnightDialogPopup then
		ns.RegisterMidnightDialogPopup(f)
	end
	win = f

	f.title = Text(f, "GameFontNormalLarge")
	f.title:SetPoint("TOPLEFT", PAD, -14)
	f.head = Text(f, "GameFontNormal")
	f.head:SetWidth(WIN_W - 2 * PAD)
	f.tips = Text(f, "GameFontHighlight")
	f.tips:SetWidth(WIN_W - 2 * PAD)
	f.rule = Text(f, "GameFontDisableSmall")
	f.rule:SetWidth(WIN_W - 2 * PAD)

	f.toggle = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
	f.toggle:SetSize(150, 22)
	f.toggle:SetPoint("BOTTOMLEFT", PAD, 14)
	f.toggle:SetScript("OnClick", function()
		ns.SetKeyPressesEnabled(not ns.IsKeyPressesEnabled())
		print(("%s %s"):format(Prefix(), ns:L(ns.IsKeyPressesEnabled() and "PRESSES_ON" or "PRESSES_OFF")))
		Refresh()
	end)

	-- Clearing loses the counts, so it takes a second click within a few seconds.
	f.reset = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
	f.reset:SetSize(150, 22)
	f.reset:SetPoint("BOTTOMRIGHT", -PAD, 14)
	SetButtonText(f.reset, ns:L("PRESSES_BTN_RESET"))
	f.reset:SetScript("OnClick", function(self)
		if not self.armed then
			self.armed = true
			SetButtonText(self, ns:L("PRESSES_BTN_RESET_SURE"))
			C_Timer.After(4, function()
				self.armed = false
				SetButtonText(self, ns:L("PRESSES_BTN_RESET"))
			end)
			return
		end
		self.armed = false
		SetButtonText(self, ns:L("PRESSES_BTN_RESET"))
		ns.KeyPressesCommand("reset")
	end)

	if ns.AttachMidnightDialogCloseButton then
		ns.AttachMidnightDialogCloseButton(f, function()
			f:Hide()
		end)
	end
	f:SetScript("OnShow", Refresh)
	return f
end

local function ShowWindow()
	Build():Show()
	Refresh()
end

--- `/mh presses why`: every counted spell, its id, key, score, and why it is or is not a row.
local function PrintWhy()
	local p = Prefix()
	local bucket, spec = Bucket(false)
	print(("%s presses: counting %s, char %s, spec %s, thumb pad known: %s"):format(p,
		ns.IsKeyPressesEnabled() and "ON" or "off", tostring(CharKey()), tostring(spec), tostring(ThumbPadKnown())))
	if not bucket then
		print("   no bucket for this character + spec yet")
		return
	end
	print(("   fights: %d"):format(bucket.fights or 0))
	for _, r in ipairs(Rows(bucket)) do
		print(("   %-24s id %-7d %4dx  %-7s %s%s"):format(SpellName(r.id), r.id, r.n, r.kind,
			r.hit and (r.hit.key .. " (" .. r.hit.cmd .. ")") or "-", r.hit and ("  score " .. r.score) or ""))
	end
end

--- `/mh presses [on|off|reset|why]`
function ns.KeyPressesCommand(arg)
	local p = Prefix()
	if arg == "on" or arg == "off" then
		ns.SetKeyPressesEnabled(arg == "on")
		print(("%s %s"):format(p, ns:L(arg == "on" and "PRESSES_ON" or "PRESSES_OFF")))
	elseif arg == "reset" then
		local ck, spec = CharKey(), SpecID()
		local chars = Store().chars
		if ck and spec and chars[ck] then
			chars[ck][spec] = nil
		end
		print(("%s %s"):format(p, ns:L("PRESSES_RESET")))
	elseif arg == "why" then
		PrintWhy()
		return
	else
		ShowWindow()
		return
	end
	if win and win:IsShown() then
		Refresh()
	end
end

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_REGEN_DISABLED")
f:RegisterEvent("PLAYER_REGEN_ENABLED")
f:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "player")
f:SetScript("OnEvent", function(_, event, _, _, spellID)
	if event == "PLAYER_REGEN_ENABLED" then
		-- A fight just ended: an open window shows the new counts.
		if win and win:IsShown() then
			Refresh()
		end
		return
	end
	if not ns.IsKeyPressesEnabled() then
		return
	end
	if event == "PLAYER_REGEN_DISABLED" then
		local b = Bucket(true)
		if b then
			b.fights = (b.fights or 0) + 1
		end
		return
	end
	-- args: unit, castGUID, spellID. RegisterUnitEvent already filters to the player.
	if not spellID or (issecretvalue and issecretvalue(spellID)) or type(spellID) ~= "number" then
		return
	end
	if not (InCombatLockdown and InCombatLockdown()) then
		return
	end
	local b = Bucket(true)
	if b then
		b.spells[spellID] = (b.spells[spellID] or 0) + 1
	end
end)
