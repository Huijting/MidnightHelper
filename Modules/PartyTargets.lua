local _, ns = ...

--[[
	Midnight Helper — party targets panel (`/mh partytargets`).

	Four lines: each party member and what they are on. Nothing else, and that is
	not modesty — it is the ceiling.

	WHAT 12.x ALLOWS, measured 31 jul (docs/RESEARCH_12_1.md). An enemy target's
	name comes back SECRET through every route: UnitName, UnitFullName, GetUnitName,
	even UnitGUID. UnitIsUnit returns a secret BOOLEAN, so we cannot ask "is this the
	same thing I am on" either. But a secret may be handed to a display widget and
	rendered — proven not by probing but by Rob watching Danders Frames with
	SimplePartyTargets print the very names this addon measures as secret.

	So this panel SHOWS names it cannot READ. There is no sorting by target, no
	"three of four are on yours", no highlighting the row that matches you. Every one
	of those needs to look at the value, and looking is what is refused. If a future
	idea here needs to inspect a name, it cannot be built — that is the design, not
	an omission.

	WHY IT EXISTS AT ALL when SimplePartyTargets does this. That addon anchors to
	Blizzard's compact party frames, and EllesmereUI does not skin those — it
	unregisters, hides and reparents them, with a hooksecurefunc that puts them back
	if anything moves them. So it has nothing to attach to and never draws. This
	panel anchors to nobody, which also means it survives Rob changing UI suite.

	SAFETY RULE FOR THIS FILE. Never let an expression ask what a value is. `x = ok
	and v or nil` throws on a secret boolean because and/or evaluate truthiness, and
	that crashed the probe on 31 jul. Everything goes through Ask() and Secret().
]]

-- Wider than it first was: "Daggerspine Myrmidon" is an ordinary trash mob and it
-- did not fit. Since the text cannot be measured — it is a secret — the only lever
-- is giving it room.
-- Widened from 260 on 2 Aug: with the role icon in front of it, an 84px name
-- column cut "Captain Garrick" down to "Captain Gar...". Both columns gain here
-- rather than one being robbed for the other — the target column was made
-- deliberately roomy in July after "Daggerspine Myrmidon" ran past the edge, and
-- narrowing it again to pay for the names would walk straight back into that.
local PANEL_W, ROW_H, PAD = 320, 22, 8
local MAX_ROWS = 4
local ROLE_W = 14
local MEMBER_W = 112

-- Height of the title bar. Rows start below it, so every row offset carries it and
-- the panel's height adds it once.
local HEAD_H = 18

-- House style, from ns.UI_COLORS (UI.lua:175). Read defensively: this module loads
-- before UI.lua in the .toc, so the table may not exist yet at file scope.
local function HeaderRGB()
	local c = ns.UI_COLORS and ns.UI_COLORS.header
	if type(c) == "table" and c[1] then
		return c[1], c[2], c[3]
	end
	return 0.91, 0.76, 0.42
end

--- Where a row's top edge sits inside the panel.
local function RowTop(i)
	return -PAD - HEAD_H - (i - 1) * ROW_H
end

--- Vertical nudge to centre a ROLE_W icon in a taller row.
local function IconInset()
	return math.floor((ROW_H - ROLE_W) / 2)
end

local panel, rows
local clicks = {}   -- left half: the group member
local tclicks = {}  -- right half: whatever that member is looking at
local glows = {}    -- per row: Blizzard's aura container, drawing "you can remove this"

--- 🔴 WE NEVER READ THE AURA. BLIZZARD DECIDES; WE ONLY DECORATE.
---
--- The obvious build — scan an ally's debuffs, compare against what this spec can
--- remove, colour the row — cannot work on 12.1. Another unit's aura data is secret in
--- combat inside an instance, which is exactly when it matters. Our own API watch wrote
--- that off on 24 aug as "you can show group dispels but not read them".
---
--- HexBreak 0.6.12 does it anyway, and their comment says how (Core.lua:1842): they
--- never read the payload either. They ask Blizzard for an aura container filtered to
--- HARMFUL|RAID — the game's own idea of "dispellable by me" — and hang static artwork
--- on the slot. Blizzard shows the slot or does not; the red wash comes with it. The
--- addon never learns what the aura is, and does not need to.
---
--- ⚠️ STATIC ARTWORK ONLY, NO SCRIPTS. 12.1 puts UntrustedScriptExecution on
--- AuraButtons, so an OnShow handler here is not a reliable trigger. That rules out a
--- sound, a count, a priority, or any Lua reacting to it. Textures parented to the slot
--- are shown and hidden by the engine along with it, and that is the whole mechanism.
---
--- ⚠️ AND IT MUST NOT EAT CLICKS. The row underneath is a secure button; a container
--- swallowing the mouse would break the dispel it is advertising.
local DISPEL_FILTER = "HARMFUL|RAID"
local glowUnavailable  -- a reason string, so a silent nothing is never the answer

--- Which of our row containers a slot belongs to.
---
--- 🔴 THE SLOT IS ICON-SIZED, THE ROW IS NOT. The first build painted the wash with
--- `wash:SetAllPoints()`, which fills the AuraButton — a small square — and then drew a
--- 2px edge around that. Rob's screenshot from Maisara Caverns, 26 aug: HexBreak filled
--- Shuja Grimaxe's whole tile red and wrote DISPEL on it; ours showed a thin red line and
--- he could not tell who needed him. The glow was working perfectly and saying nothing.
--- So the artwork anchors to the ROW and only its PARENT stays the slot — the engine
--- shows and hides children with the parent, which is the whole mechanism we rely on.
local glowLookup = setmetatable({}, { __mode = "k" })
local paintLog = {}

local function OwningRow(slot)
	local f = slot
	for _ = 1, 6 do
		f = f and f.GetParent and f:GetParent()
		if not f then
			return nil
		end
		if glowLookup[f] then
			return f
		end
	end
	return nil
end

local function PaintDispelSlot(slot)
	if slot.SetMouseClickEnabled then
		pcall(slot.SetMouseClickEnabled, slot, false)
	end
	if slot.SetMouseMotionEnabled then
		pcall(slot.SetMouseMotionEnabled, slot, false)
	end

	local row = OwningRow(slot)

	-- What the artwork was actually given to work with. Rob's second screenshot showed a
	-- red line above each row with DISPEL hanging outside the panel, which means one of
	-- these numbers is not what this code assumes. Printing them beats another guess.
	paintLog[#paintLog + 1] = {
		row = row and true or false,
		sw = slot.GetWidth and slot:GetWidth() or -1,
		sh = slot.GetHeight and slot:GetHeight() or -1,
		rw = row and row.GetWidth and row:GetWidth() or -1,
		rh = row and row.GetHeight and row:GetHeight() or -1,
		depth = (function()
			local f, n = slot, 0
			while f and n < 8 do
				if glowLookup[f] then return n end
				f = f.GetParent and f:GetParent()
				n = n + 1
			end
			return -1
		end)(),
	}

	-- 🔴 FILL THE PARENT, THEN RISE ABOVE THE PANEL. Both lines are HexBreak's
	-- (Core.lua:1856-1859), and the second is the one we never had.
	--
	-- `SetAllPoints()` with NO argument anchors to the parent — here the row container.
	-- Our first build had exactly this and I deleted it on 26 aug, reading it as a frame
	-- anchored to itself. It was correct.
	--
	-- The real fault was the missing frame level. Without it the slot draws BEHIND the
	-- panel's own row artwork, so all that ever showed was the 2px the old edge texture
	-- stuck out past it. Three screenshots of "a thin red line" were never a broken glow:
	-- they were the glow, underneath. I changed the artwork three times to fix a stacking
	-- order — while a working implementation sat installed and readable, which is what Rob
	-- asked about before any of it.
	pcall(function()
		slot:SetAllPoints()
		slot:SetFrameLevel(math.max(slot:GetFrameLevel(), panel:GetFrameLevel() + 8))
	end)

	local wash = slot:CreateTexture(nil, "OVERLAY", nil, 1)
	wash:SetAllPoints()
	wash:SetColorTexture(0.62, 0.010, 0.006, 0.55)

	-- A bright rim, because a wash alone reads as "this row is selected" rather than
	-- "act on this row". Four thin textures, not a border texture, so nothing scales oddly
	-- when Rob drags the panel wider.
	for _, side in ipairs({ "TOP", "BOTTOM", "LEFT", "RIGHT" }) do
		local bar = slot:CreateTexture(nil, "OVERLAY", nil, 2)
		bar:SetColorTexture(1, 0.12, 0.025, 1)
		if side == "TOP" or side == "BOTTOM" then
			bar:SetHeight(2)
			bar:SetPoint(side .. "LEFT", slot, side .. "LEFT", 0, 0)
			bar:SetPoint(side .. "RIGHT", slot, side .. "RIGHT", 0, 0)
		else
			bar:SetWidth(2)
			bar:SetPoint("TOP" .. side, slot, "TOP" .. side, 0, 0)
			bar:SetPoint("BOTTOM" .. side, slot, "BOTTOM" .. side, 0, 0)
		end
	end

	-- HexBreak writes the word on the tile and that is why Rob could read theirs at a
	-- glance. Static artwork, so it is allowed here; a FontString is not a script.
	local tag = slot:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	tag:SetPoint("RIGHT", slot, "RIGHT", -6, 0)
	tag:SetText((ns.L and ns:L("PARTY_DISPEL_TAG")) or "DISPEL")
	tag:SetTextColor(1, 0.92, 0.55)
end

--- One container per row. Created once, then rebound as the roster moves.
function EnsureDispelGlow(i)
	if glows[i] or glowUnavailable or not panel then
		return
	end
	if not (C_AddOns and C_AddOns.LoadAddOn) then
		glowUnavailable = "C_AddOns.LoadAddOn missing"
		return
	end
	pcall(C_AddOns.LoadAddOn, "Blizzard_AuraContainer")
	-- Validate the filter rather than assume it: a wrong string would give a container
	-- that quietly never fires, which looks exactly like "nothing to dispel".
	if not (AuraUtil and AuraUtil.IsValidFilterString) then
		glowUnavailable = "AuraUtil.IsValidFilterString missing"
		return
	end
	local okF, valid = pcall(AuraUtil.IsValidFilterString, DISPEL_FILTER)
	if not okF or valid ~= true then
		glowUnavailable = "filter rejected: " .. DISPEL_FILTER
		return
	end
	local okC, c = pcall(CreateFrame, "AuraContainer", nil, panel, "CustomAuraContainerTemplate")
	if not okC or not c then
		glowUnavailable = "CustomAuraContainerTemplate: " .. tostring(c)
		return
	end
	-- ⚠️ REGISTER BEFORE AddAuraSlot. `initializeFrame` can fire during that call, and a
	-- slot that initialises before its row is known falls back to painting itself — which
	-- is exactly the thin-line bug this replaced.
	glowLookup[c] = true

	-- ⚠️ NOT disabling the mouse on the container itself. I added that on 26 aug on a
	-- hunch about the dead clicks, and it went in together with a slot resize — so when
	-- every click died, two changes shared the blame and neither was proven. HexBreak
	-- does not touch the container's mouse, and a plain Frame does not take one. Matching
	-- their build exactly leaves one difference to test instead of three.
	pcall(c.SetPoint, c, "TOPLEFT", panel, "TOPLEFT", PAD - 2, RowTop(i))
	pcall(c.SetPoint, c, "TOPRIGHT", panel, "TOPRIGHT", -PAD + 2, RowTop(i))
	pcall(c.SetHeight, c, ROW_H)
	if not (c.SetUnit and c.AddAuraSlot and c.SetEnabled) then
		glowUnavailable = "AuraContainer is missing SetUnit/AddAuraSlot/SetEnabled"
		return
	end
	-- ⚠️ ORDER IS LOAD-BEARING, and it is HexBreak's, tested on live 12.1:
	-- SetUnit -> AddAuraSlot -> Show -> SetEnabled -> UpdateAllAuras.
	pcall(c.SetUnit, c, "none")
	local okS = pcall(c.AddAuraSlot, c, "mhPartyDispel", DISPEL_FILTER, {
		initializeFrame = PaintDispelSlot,
	})
	if not okS then
		glowUnavailable = "AddAuraSlot failed"
		return
	end
	glows[i] = c
end

--- Why is there no red wash? Answer it out loud instead of leaving a blank screen.
---
--- ⚠️ "No glow" has four causes that look identical: the container never built, the
--- filter was rejected, this character has no dispel, or there is genuinely nothing to
--- remove. Only the last is good news, and without this they are indistinguishable —
--- the exact trap that cost most of this afternoon.
function ns.PrintPartyDispelGlowStatus()
	local prefix = ("|cffffcc00%s|r"):format((ns.L and ns:L("PRINT_PREFIX")) or "MH")
	print(prefix .. " party dispel glow:")
	if glowUnavailable then
		print("   |cffff5555not available:|r " .. tostring(glowUnavailable))
	else
		local n = 0
		for i = 1, MAX_ROWS do
			if glows[i] then
				n = n + 1
			end
		end
		-- ⚠️ `|` is an escape character in WoW's text, so printing the filter raw ate it:
		-- Rob's first run read "filter=HARMFULAID". The filter was fine -- it had been
		-- validated and four containers were built on it -- but the line reporting it
		-- was wrong, in a diagnostic whose entire job is to not mislead. Doubling the
		-- pipe prints one.
		print(("   containers built: %d of %d   filter=%s")
			:format(n, MAX_ROWS, (DISPEL_FILTER:gsub("|", "||"))))
		if n == 0 then
			print("   |cff8a8f98None yet -- they are built with the panel, so open it in a group first.|r")
		end
	end
	local icon, id = nil, nil
	if ns.GetPlayerDispelIcon then
		icon, id = ns.GetPlayerDispelIcon()
	end
	if id then
		print(("   your dispel: spell %d  (right-click the left half of a row)"):format(id))
	else
		print("   |cff8a8f98This character has no dispel, so no row will ever glow.|r")
	end
	local pid
	if ns.GetPlayerPurgeIcon then
		local _, v = ns.GetPlayerPurgeIcon()
		pid = v
	end
	print(pid and ("   your purge : spell %d  (right-click the right half)"):format(pid)
		or "   |cff8a8f98This character has no purge.|r")

	-- ⚠️ WHAT THE SPELL LOOKUP FOUND IS NOT WHAT THE BUTTON CARRIES. The lines above read
	-- GetPlayerDispelIcon again, live; the button was armed by ApplyDispelAttributes,
	-- which refuses to run in combat. Those two can disagree -- and if they do, that is
	-- precisely why a right-click does nothing while this diagnostic looks healthy.
	local armed, blank = 0, 0
	for i = 1, MAX_ROWS do
		local b = clicks[i]
		if b then
			if b:GetAttribute("spell2") then armed = armed + 1 else blank = blank + 1 end
		end
	end
	print(("   rows armed to dispel: %d   without a spell: %d%s")
		:format(armed, blank,
			(InCombatLockdown and InCombatLockdown()) and "   |cffff5555(in combat — arming is blocked)|r" or ""))
	if armed == 0 and id then
		print("   |cffff5555Your spec HAS a dispel but no row carries it.|r "
			.. "Leave combat and reopen the panel.")
	end

	-- Does anything above the row still take the mouse? If a right-click does nothing
	-- while the rows are armed, this is where it is going.
	for i = 1, MAX_ROWS do
		local c = glows[i]
		if c and c.IsMouseEnabled then
			local ok, on = pcall(c.IsMouseEnabled, c)
			-- ⚠️ `on` IS A SECRET BOOLEAN in 12.1 once our own execution is tainted, and
			-- testing it directly throws. Rob, 26 aug: this diagnostic — whose entire job
			-- is to explain a failure — became the failure. CLAUDE.md has said "guard with
			-- issecretvalue() before comparing" since 12.0; I wrote the check without one.
			if ok and not (issecretvalue and issecretvalue(on)) and on == true then
				print(("   |cffff5555row %d: the glow container still takes the mouse|r"):format(i))
			end
		end
	end

	-- Geometry, because the artwork landed in the wrong place twice and both times the
	-- explanation was an assumed size.
	if #paintLog == 0 then
		print("   |cff8a8f98No slot has been painted yet — nothing dispellable has appeared.|r")
	else
		for n, p in ipairs(paintLog) do
			print(("   paint %d: row found=%s (depth %d)  slot %.0fx%.0f  row %.0fx%.0f")
				:format(n, tostring(p.row), p.depth, p.sw, p.sh, p.rw, p.rh))
			if n >= 4 then
				print(("   ... and %d more"):format(#paintLog - n))
				break
			end
		end
	end
end

--- Point a row's container at a unit, or park it.
---
--- ⚠️ NEVER SetEnabled(false) TO REBIND. On 12.1 that clears the container's own
--- AuraButtons, taking our artwork with it (HexBreak Core.lua:2093). SetUnit on a
--- configured container is legal; Show and SetEnabled(true) then re-arm it.
local function BindDispelGlow(i, unit)
	local c = glows[i]
	if not c then
		return
	end
	pcall(c.SetUnit, c, unit or "none")
	pcall(c.SetShown, c, unit ~= nil)
	if unit then
		pcall(c.SetEnabled, c, true)
		if c.UpdateAllAuras then
			pcall(c.UpdateAllAuras, c)
		end
	end
end

--- Put this spec's dispel on the member half and its purge on the target half.
---
--- ⚠️ OUT OF COMBAT ONLY. Secure attributes cannot be changed in a fight, so the
--- assignment happens when the buttons are built and again on every spec or talent
--- change; DispelHelper already fires on both.
---
--- ⚠️ And a spec with no dispel gets `type2 = nil`, not a button that swallows the
--- click and does nothing. A warrior right-clicking should get their own UI's
--- behaviour back, not our silence.
---
--- Casting by spell ID, never by name: a renamed pet or spell hands back a name that
--- cannot be cast (MissingBuff.lua:700 paid for that one).
function ApplyDispelAttributes()
	if InCombatLockdown and InCombatLockdown() then
		return
	end
	-- ⚠️ Two lines, not `f and f()`: that guard returns a single value, so the second
	-- return would always be nil. Exactly the bug lint check [12] exists for, and the
	-- one that kept GetPlayerDispelIcon returning nil for months (DispelHelper.lua:501).
	local dispelSpell
	if ns.GetPlayerDispelIcon then
		local _, id = ns.GetPlayerDispelIcon()
		dispelSpell = id
	end
	local purgeSpell
	if ns.GetPlayerPurgeIcon then
		local _, id = ns.GetPlayerPurgeIcon()
		purgeSpell = id
	end
	for i = 1, MAX_ROWS do
		local b = clicks[i]
		if b then
			b:SetAttribute("*type2", dispelSpell and "spell" or nil)
			b:SetAttribute("spell2", dispelSpell or nil)
		end
		local t = tclicks[i]
		if t then
			t:SetAttribute("*type2", purgeSpell and "spell" or nil)
			t:SetAttribute("spell2", purgeSpell or nil)
		end
	end
end
-- Forward-declared: the panel's own drag handler is written before this exists,
-- and dragging the panel has to drag the buttons with it.
local PositionClicks

local function Secret(v)
	return issecretvalue and v ~= nil and issecretvalue(v) == true
end

--- Call an API and hand back what it returned, without testing the value.
local function Ask(fn, ...)
	if type(fn) ~= "function" then
		return nil
	end
	local ok, v = pcall(fn, ...)
	if ok then
		return v
	end
	return nil
end

--- true only when the value is readable AND true. A secret answers "unknown", which
--- here has to mean "do not claim it" — the same three-state rule the aura facade
--- uses, for the same reason.
local function ReadsTrue(v)
	if v == nil or Secret(v) then
		return false
	end
	return v == true
end

local function L(key, fallback)
	local s = ns.L and ns:L(key)
	if not s or s == key then
		return fallback
	end
	return s
end

local function SavePos()
	if not panel then
		return
	end
	local p, _, rp, x, y = panel:GetPoint()
	if ns.db and ns.db.ui then
		ns.db.ui.partyTargetsPos = { p, rp, x, y }
	end
end

local function EnsurePanel()
	if panel then
		return panel
	end
	panel = CreateFrame("Frame", "MidnightHelperPartyTargets", UIParent, "BackdropTemplate")
	-- Remembered width (Rob can drag the right edge); height still follows the
	-- number of members, so only the width is ever restored.
	local savedW = ns.db and ns.db.ui and tonumber(ns.db.ui.partyTargetsWidth)
	if savedW and savedW >= 240 then
		PANEL_W = savedW
	end
	panel:SetSize(PANEL_W, PAD * 2 + HEAD_H + ROW_H * MAX_ROWS)
	panel:SetFrameStrata("MEDIUM")
	panel:SetClampedToScreen(true)
	panel:SetMovable(true)
	panel:EnableMouse(true)
	panel:RegisterForDrag("LeftButton")
	panel:SetScript("OnDragStart", function(self)
		self:StartMoving()
	end)
	panel:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
		SavePos()
		if PositionClicks then
			PositionClicks()
		end
	end)

	local pos = ns.db and ns.db.ui and ns.db.ui.partyTargetsPos
	if type(pos) == "table" and pos[1] then
		panel:SetPoint(pos[1], UIParent, pos[2] or pos[1], pos[3] or 0, pos[4] or 0)
	else
		panel:SetPoint("CENTER", UIParent, "CENTER", -320, 60)
	end

	-- House style. This panel was built in a hurry and kept a warm brown of its own
	-- (0.06, 0.05, 0.04) with a hard gold border, which sat next to every other MH
	-- window looking like a different addon.
	if panel.SetBackdrop then
		panel:SetBackdrop({
			bgFile = "Interface\\Buttons\\WHITE8X8",
			edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
			edgeSize = 14,
			insets = { left = 4, right = 4, top = 4, bottom = 4 },
		})
		panel:SetBackdropColor(0.05, 0.05, 0.09, 0.95)
		panel:SetBackdropBorderColor(HeaderRGB())
	end

	-- Title. Also the honest drag handle: the click buttons cover the rows, so
	-- without this the only bare panel left to grab was a 14px strip.
	panel.title = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	if ns.MHScalableFont then
		panel.title:SetFontObject(ns.MHScalableFont("GameFontNormal"))
	end
	panel.title:SetPoint("TOPLEFT", panel, "TOPLEFT", PAD, -PAD + 2)
	panel.title:SetTextColor(HeaderRGB())
	panel.title:SetText(L("PARTYTARGETS_TITLE", "Party targets"))

	-- Width grip, bottom right. WIDTH ONLY — the height follows the number of party
	-- members and is rewritten on every refresh, so letting it be dragged would look
	-- like the panel fighting you.
	--
	-- Not secure and parented to the panel, so it may carry scripts freely; the
	-- click buttons that must stay script-free live on UIParent.
	panel:SetResizable(true)
	if panel.SetResizeBounds then
		panel:SetResizeBounds(240, 1, 900, 4000)
	end
	local grip = CreateFrame("Frame", nil, panel)
	grip:SetSize(14, 14)
	grip:SetPoint("BOTTOMRIGHT", panel, "BOTTOMRIGHT", -2, 2)
	grip:EnableMouse(true)
	grip:RegisterForDrag("LeftButton")
	local gripTex = grip:CreateTexture(nil, "OVERLAY")
	gripTex:SetAllPoints(grip)
	gripTex:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
	gripTex:SetVertexColor(HeaderRGB())
	gripTex:SetAlpha(0.6)
	grip:SetScript("OnDragStart", function()
		panel:StartSizing("BOTTOMRIGHT")
	end)
	grip:SetScript("OnDragStop", function()
		panel:StopMovingOrSizing()
		PANEL_W = math.max(240, math.floor(panel:GetWidth() + 0.5))
		if ns.db and ns.db.ui then
			ns.db.ui.partyTargetsWidth = PANEL_W
		end
		-- Height back under our control immediately, and the secure buttons back
		-- under the rows. PositionClicks already refuses in combat, which is the
		-- same deal dragging has.
		if ns.RefreshPartyTargets then
			ns.RefreshPartyTargets()
		end
		if PositionClicks then
			PositionClicks()
		end
	end)

	rows = {}
	for i = 1, MAX_ROWS do
		local row = {}
		-- A red wash over this row when the game says there is something here you can
		-- remove. Built after the row's artwork so it draws on top of the stripe.
		EnsureDispelGlow(i)

		-- Faint stripe on every second row. The hover highlight tells you which row
		-- you are ON; this tells you where one row ends and the next begins, which
		-- is the half of "stop counting rows" that works before you touch the mouse.
		if i % 2 == 0 then
			row.stripe = panel:CreateTexture(nil, "BACKGROUND")
			row.stripe:SetColorTexture(1, 1, 1, 0.04)
			row.stripe:SetPoint("TOPLEFT", panel, "TOPLEFT", PAD - 2, RowTop(i))
			row.stripe:SetPoint("TOPRIGHT", panel, "TOPRIGHT", -PAD + 2, RowTop(i))
			row.stripe:SetHeight(ROW_H)
		end

		-- Role marker. Rob asked for it while levelling in Timewalking dungeons,
		-- where the group changes every few minutes and "who is the tank" is the
		-- thing you want at a glance.
		--
		-- Two renderings, because only one of them is verified. The atlases
		-- `roleicon-tiny-tank/healer/dps` appear in four addons installed here, so
		-- they exist -- but SetAtlas is asked under pcall and a plain coloured
		-- letter takes over if it ever fails. No texcoords are invented: guessing
		-- numbers into UI-LFG-ICON-ROLES would show the wrong corner of a texture
		-- and look deliberate.
		row.role = panel:CreateTexture(nil, "OVERLAY")
		row.role:SetSize(ROLE_W, ROLE_W)
		row.role:SetPoint("TOPLEFT", panel, "TOPLEFT", PAD, RowTop(i) - IconInset())
		row.roleLetter = panel:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
		if ns.MHScalableFont then
			row.roleLetter:SetFontObject(ns.MHScalableFont("GameFontNormalSmall"))
		end
		row.roleLetter:SetPoint("CENTER", row.role, "CENTER", 0, 0)
		row.roleLetter:Hide()

		-- Dispel indicator: this ally is carrying something removable.
		--
		-- On the LEFT, next to their name, because it is about them. The raid
		-- marker on the right is about their target; keeping the two sides
		-- meaning different things is what stops the row becoming a row of icons.
		--
		-- The icon is the player's OWN dispel spell, so it answers "what do I
		-- press" in the same glance, and it is absent entirely for a character
		-- with no dispel.
		row.dispel = panel:CreateTexture(nil, "OVERLAY")
		row.dispel:SetSize(ROLE_W, ROLE_W)
		row.dispel:SetPoint("TOPLEFT", panel, "TOPLEFT", PAD + ROLE_W + 3, RowTop(i) - IconInset())
		row.dispel:Hide()

		row.member = panel:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
		if ns.MHScalableFont then
			row.member:SetFontObject(ns.MHScalableFont("GameFontNormalSmall"))
		end
		row.member:SetPoint("TOPLEFT", panel, "TOPLEFT", PAD + (ROLE_W + 3) * 2, RowTop(i) - 3)
		row.member:SetWidth(MEMBER_W)
		row.member:SetJustifyH("LEFT")
		row.member:SetTextColor(1, 0.82, 0.2)

		row.target = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
		if ns.MHScalableFont then
			row.target:SetFontObject(ns.MHScalableFont("GameFontHighlightSmall"))
		end
		-- Raid marker on the member's target.
		--
		-- The index is SECRET for a hostile unit — measured 2 Aug, on our own
		-- target as much as on theirs — so it can never be read, compared or
		-- branched on. It can be handed straight to Blizzard's own drawing helper,
		-- which resolves it internally, exactly as the enemy name is handed to
		-- SetText without being looked at.
		--
		-- Not invented: SimplePartyTargets (installed here) ships this route, and
		-- its own comment says the helper "can handle secrets internally"
		-- (SimplePartyTargets.lua:3861-3875). The base texture is set once here;
		-- SetRaidTargetIconTexture only moves the coordinates within it.
		-- At the END of the row, not in front of the name (Rob, 3 Aug).
		--
		-- "After the name" is done as "at the right edge" on purpose. Following the
		-- text itself would mean measuring the string to know where it ends, and the
		-- string is an enemy name — a secret we are allowed to draw and not to
		-- inspect. The right edge needs no measuring and reads the same.
		row.marker = panel:CreateTexture(nil, "OVERLAY")
		row.marker:SetSize(ROLE_W, ROLE_W)
		row.marker:SetTexture("Interface\\TargetingFrame\\UI-RaidTargetingIcons")
		row.marker:SetPoint("TOPRIGHT", panel, "TOPRIGHT", -PAD, RowTop(i) - IconInset())
		row.marker:Hide()

		row.target:SetPoint("TOPLEFT", row.member, "TOPRIGHT", 6, 0)
		-- Stop short of the marker column so a long name never runs under the icon.
		row.target:SetPoint("RIGHT", panel, "RIGHT", -PAD - ROLE_W - 4, 0)
		row.target:SetJustifyH("LEFT")
		-- One line per member, always. "Daggerspine Myrmidon" wrapped onto a second
		-- line and spilled past the panel, because the rows are a fixed height (Rob,
		-- 31 jul). Growing the row instead would make the panel jump about as targets
		-- change mid-fight, which is worse in a thing you glance at.
		--
		-- It clips rather than truncating with an ellipsis, and that is on purpose:
		-- adding "..." means measuring the string, and the string is a secret we are
		-- not allowed to look at.
		row.target:SetWordWrap(false)
		if row.target.SetMaxLines then
			row.target:SetMaxLines(1)
		end
		row.member:SetWordWrap(false)
		if row.member.SetMaxLines then
			row.member:SetMaxLines(1)
		end
		rows[i] = row
	end
	panel:Hide()
	return panel
end

local ROLE_ATLAS = {
	TANK = "roleicon-tiny-tank",
	HEALER = "roleicon-tiny-healer",
	DAMAGER = "roleicon-tiny-dps",
}
local ROLE_LETTER = {
	TANK = { "T", 0.42, 0.62, 1.00 },
	HEALER = { "H", 0.40, 0.95, 0.45 },
	DAMAGER = { "D", 1.00, 0.50, 0.40 },
}

--- Draw a role, preferring the atlas and falling back to a letter.
---
--- SetAtlas can succeed on a name that does not exist and leave the texture blank,
--- so the result is checked rather than trusted — the same guard `Modules/Delves.lua`
--- already uses for its bountiful icon.
local function SetRole(row, role)
	local atlas = ROLE_ATLAS[role]
	local ok = false
	if atlas and row.role.SetAtlas then
		ok = select(1, pcall(row.role.SetAtlas, row.role, atlas))
		if ok then
			local tid = row.role.GetTexture and row.role:GetTexture()
			ok = tid ~= nil and tid ~= 0 and tid ~= ""
		end
	end
	if ok then
		row.role:Show()
		row.roleLetter:Hide()
		return
	end
	row.role:Hide()
	local letter = ROLE_LETTER[role]
	if letter then
		row.roleLetter:SetText(letter[1])
		row.roleLetter:SetTextColor(letter[2], letter[3], letter[4])
		row.roleLetter:Show()
	else
		row.roleLetter:Hide()
	end
end

--- Which party unit each display row shows: tank first, then healer, then damage.
---
--- Rob asked for the tank on top (3 Aug). The catch is that the click buttons are
--- bound to a unit by attribute, and changing an attribute is refused in combat —
--- so a row that re-sorts mid-fight would keep showing one person while clicking
--- through to another. Silently targeting the wrong mob is far worse than an
--- unsorted list.
---
--- Hence: the order is only ever recomputed OUT of combat, so what a row shows and
--- what it clicks always change together. Roles and group composition do not shift
--- mid-pull anyway; if they somehow do, the panel keeps the order it entered
--- combat with, which is at least honest.
local ROLE_RANK = { TANK = 1, HEALER = 2, DAMAGER = 3 }
local rowOrder = { 1, 2, 3, 4 }

local function RecomputeOrder()
	if InCombatLockdown and InCombatLockdown() then
		return false
	end
	local list = {}
	for i = 1, MAX_ROWS do
		local unit = "party" .. i
		local rank = 4
		if ReadsTrue(Ask(UnitExists, unit)) then
			local role = Ask(UnitGroupRolesAssigned, unit)
			rank = ROLE_RANK[role] or 3
		else
			rank = 9 -- absent members sink to the bottom
		end
		list[#list + 1] = { index = i, rank = rank }
	end
	-- Stable within a rank: party order breaks ties, so three damage dealers keep
	-- the same row from pull to pull instead of shuffling.
	table.sort(list, function(a, b)
		if a.rank ~= b.rank then
			return a.rank < b.rank
		end
		return a.index < b.index
	end)

	local changed = false
	for i = 1, MAX_ROWS do
		if rowOrder[i] ~= list[i].index then
			changed = true
		end
		rowOrder[i] = list[i].index
	end
	return changed
end

--- Draw the raid marker on a unit's target, without ever reading it.
---
--- `idx == nil` is safe on a secret: the probe compared secret values to nil
--- across four units without erroring on 2 Aug. Anything more — a range check, a
--- table lookup, arithmetic — is not, and none is done here.
---
--- Failure hides the icon rather than falling back to hand-written texcoords.
--- Those need the index as a plain number, which is exactly what we do not have,
--- and a fallback that can only run when the value is readable would be dead code
--- dressed up as robustness.
local function SetMarker(row, tUnit)
	local idx = Ask(GetRaidTargetIndex, tUnit)
	if idx == nil or type(SetRaidTargetIconTexture) ~= "function" then
		row.marker:Hide()
		return
	end
	if select(1, pcall(SetRaidTargetIconTexture, row.marker, idx)) then
		row.marker:Show()
	else
		row.marker:Hide()
	end
end

--- Move the click buttons over the rows. Out of combat only.
---
--- They are parented to UIParent rather than to the panel, and never anchored to
--- it, because a frame that parents or is anchored-to by a secure button becomes
--- protected itself. Keeping the panel unprotected is what lets it still be
--- dragged and hidden mid-fight — which matters to Rob, who asked for this while
--- running Timewalking dungeons where combat barely stops.
---
--- The cost of that choice is here: absolute placement has to be recomputed, and
--- in combat it cannot be. So a drag during a fight leaves the buttons behind
--- until PLAYER_REGEN_ENABLED catches up.
function PositionClicks()
	if not panel or (InCombatLockdown and InCombatLockdown()) then
		return
	end
	local left, top = panel:GetLeft(), panel:GetTop()
	if not (left and top) then
		return
	end
	-- Start after the role icon: that column stays bare panel, and it is the only
	-- thing left to grab once the buttons cover the rest of every row.
	local inset = PAD + ROLE_W + 4
	local w = math.max(1, panel:GetWidth() - inset - PAD)
	--- Split at a FIXED fraction, not at where the name happens to end.
	---
	--- The two halves are drawn by text: the member's name, then their target beside
	--- it. Following that boundary would move the click split every time somebody
	--- targeted something with a longer name -- and secure buttons cannot be
	--- repositioned in combat, so it would drift out of step exactly when it matters.
	--- A fixed 45% is predictable, which is what your hand needs.
	local wLeft = math.max(1, math.floor(w * 0.45))
	local wRight = math.max(1, w - wLeft)
	for i = 1, MAX_ROWS do
		local b = clicks[i]
		if b then
			b:ClearAllPoints()
			b:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", left + inset, top + RowTop(i))
			b:SetSize(wLeft, ROW_H)
		end
		local t = tclicks[i]
		if t then
			t:ClearAllPoints()
			t:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", left + inset + wLeft, top + RowTop(i))
			t:SetSize(wRight, ROW_H)
		end
	end
end

--- One secure button per row, permanently bound to that row's unit.
---
--- Each row carries both bindings at once — left the member, right their target —
--- rather than one attribute that gets rewritten as the situation changes. That is
--- the whole trick: SimplePartyTargets reassigns its attribute as slots move and
--- therefore guards it with InCombatLockdown (`SimplePartyTargets.lua:3503`), which
--- means a click can go stale mid-fight. Two fixed bindings cannot.
---
--- ⚠️ The rows DO re-sort by role, and both attributes are rewritten together there
--- (see the RecomputeOrder block). This comment used to claim `unit` "is set once and
--- never changes", which was already untrue when it was written and would have sent
--- the next reader looking for a guarantee that does not exist.
---
--- Drag is forwarded to the panel so the rows stay draggable even though the
--- buttons now cover them. Clicking still works: a button registered for both
--- fires the click only when no drag happened, exactly like Blizzard's own.
--- One secure button, bound to one unit, carrying both mouse buttons.
--- Called twice per row: once for the member, once for whatever they are looking at.
local function MakeClickButton(name, unitToken)
	do
		do
			local b = CreateFrame("Button", name, UIParent,
				"SecureActionButtonTemplate")
			b:SetFrameStrata("DIALOG")
			b:RegisterForClicks("AnyUp", "AnyDown")
			--- LEFT targets the GROUP MEMBER, RIGHT targets what they are looking at.
			---
			--- Rob asked for member-clicking on 24 aug ("ik kan hun zelf niet aanklikken")
			--- and the first build put it on right-click, to avoid moving a click people
			--- already had in their fingers. He tried it in a delve within the hour:
			--- "rechts klik is inderdaad raar, dus die moet andersom".
			---
			--- He is right for a better reason than habit. Everywhere else in this game,
			--- left-clicking a unit frame selects that unit — so a row showing a person
			--- that does NOT select them on left-click is fighting the platform, and no
			--- amount of internal logic about "the panel's purpose" wins that argument.
			---
			--- ⚠️ `unit2` and not a second button: SecureActionButton resolves the unit per
			--- mouse button, falling back to `unit` when the numbered one is absent. So one
			--- button carries both bindings and neither needs a script — which is the rule
			--- this file paid for once already (see the note below about TargetUnit()).
			--- ⚠️ SPLIT INTO TWO BUTTONS, 25 AUG 2026 — ROB'S OBSERVATION, NOT MINE.
			---
			--- The row is already drawn in two halves: their name on the left, what they
			--- are looking at on the right. One button covered both, so left and right
			--- mouse had to share the work and the right button was spent on targeting.
			---
			--- His point: "als ik links hem met de linker muis knop aantik dan selecteer
			--- ik hem, zo ook met zijn target. Dan hebben we toch de rechter knop over
			--- voor de dispels?" Correct, and it costs nothing — both left-clicks keep
			--- exactly what they did, and the right button comes free on both halves.
			---
			--- So `unit2` is gone. Each button now owns ONE unit and both mouse buttons:
			---   left half  -> unit = partyN         left: target   right: dispel HIM
			---   right half -> unit = partyN target  left: target   right: purge IT
			---
			--- The spells are filled in by ApplyDispelAttributes, out of combat only,
			--- from whatever this spec actually has. A spec with no dispel gets no
			--- right-click rather than a button that does nothing.
			b:SetAttribute("*type1", "target")
			b:SetAttribute("unit", unitToken)
			-- NO SCRIPTS ON THIS BUTTON. Not OnDragStart, not OnClick, nothing.
			--
			-- The first two builds hung drag handlers here so the rows would stay
			-- draggable, and Rob got:
			--   ADDON_ACTION_FORBIDDEN — MidnightHelper tried to call TargetUnit()
			-- Our own code running in a secure button's context taints it, and a
			-- tainted button may no longer perform a protected action. The drag
			-- convenience destroyed the targeting it was wrapped around.
			--
			-- Dragging goes back to the panel, which is not secure and may carry
			-- whatever scripts it likes. The buttons leave the role-icon column
			-- uncovered so there is always a strip of panel left to grab.
			-- A default size, because SetSize only happens in PositionClicks and that
			-- refuses to run in combat. A button created mid-fight would otherwise
			-- sit at zero by zero: shown, bound correctly, and impossible to hit.
			b:SetSize(PANEL_W - PAD * 2 - ROLE_W - 4, ROW_H)

			-- Hover highlight, so you can see which row you are about to click
			-- instead of counting down from the top (Rob, 3 Aug).
			--
			-- A TEXTURE, not an OnEnter script. Scripts on a secure button taint it,
			-- and that is what broke targeting yesterday; the engine draws a
			-- highlight texture on hover with no Lua of ours running at all.
			local hl = b:CreateTexture(nil, "HIGHLIGHT")
			hl:SetAllPoints(b)
			hl:SetColorTexture(1, 0.82, 0.2, 0.18)
			b:SetHighlightTexture(hl)
			b:Hide()
			return b
		end
	end
end

--- Two buttons per row: the member on the left half, their target on the right.
local function EnsureClickButtons()
	for i = 1, MAX_ROWS do
		if not clicks[i] then
			clicks[i] = MakeClickButton("MidnightHelperPartyTargetClick" .. i, "party" .. i)
		end
		if not tclicks[i] then
			tclicks[i] = MakeClickButton("MidnightHelperPartyTargetTClick" .. i,
				"party" .. i .. "target")
		end
	end
	ApplyDispelAttributes()
end

--- 🔴 NOT IN A RAID. Rob, in LFR of The Venomous Abyss, 25 aug 2026: "de party target
--- frame hoort hier niet."
---
--- Nothing was broken -- and that is the point. `party1` through `party4` still resolve
--- inside a raid, where they mean your own subgroup, so the panel quietly turned into
--- "four of the twenty-four people here" and kept working. A panel called Party targets,
--- built to let you see and click what a five-man group is fighting, is answering a
--- question nobody asked in a raid, while sitting on screen next to real raid frames.
---
--- Silently repurposing itself is worse than failing: there is nothing to notice.
local function InRaidGroup()
	if not IsInRaid then
		return false
	end
	local ok, v = pcall(IsInRaid)
	return ok and v == true
end

local function Refresh()
	if InRaidGroup() then
		if panel then
			panel:Hide()
		end
		-- Same reason as below: the click buttons live on UIParent and a hidden panel
		-- does not take them with it, so an invisible catcher would stay behind.
		if not (InCombatLockdown and InCombatLockdown()) then
			for i = 1, MAX_ROWS do
				if clicks[i] then
					clicks[i]:Hide()
				end
				if tclicks[i] then
					tclicks[i]:Hide()
				end
			end
		end
		return
	end
	if not (ns.db and ns.db.partyTargets) then
		if panel then
			panel:Hide()
		end
		-- The buttons live on UIParent, so hiding the panel does not take them
		-- with it. Left behind they would be an invisible click-catcher over the
		-- middle of the screen.
		if not (InCombatLockdown and InCombatLockdown()) then
			for i = 1, MAX_ROWS do
				if clicks[i] then
					clicks[i]:Hide()
				end
				if tclicks[i] then
					tclicks[i]:Hide()
				end
			end
		end
		return
	end
	EnsurePanel()
	EnsureClickButtons()

	-- Re-sort and re-bind together, out of combat only (see RecomputeOrder).
	if RecomputeOrder() and not (InCombatLockdown and InCombatLockdown()) then
		for i = 1, MAX_ROWS do
			-- Both halves move together. Rebinding only one would leave the other
			-- pointing at whoever used to be on this row -- a stale click that looks
			-- like it worked, which is the failure this file exists to avoid. That was
			-- true when they were two attributes on one button and it is just as true
			-- now that they are two buttons.
			if clicks[i] then
				clicks[i]:SetAttribute("unit", "party" .. rowOrder[i])
			end
			if tclicks[i] then
				tclicks[i]:SetAttribute("unit", "party" .. rowOrder[i] .. "target")
			end
		end
	end

	local shown = 0
	local visible = {}
	for i = 1, MAX_ROWS do
		local unit = "party" .. rowOrder[i]
		local row = rows[i]
		if ReadsTrue(Ask(UnitExists, unit)) then
			shown = shown + 1
			visible[i] = true
			-- UnitGroupRolesAssigned reads for a party member — they are friendly,
			-- and only a hostile target is secret. Ask() guards it anyway; an
			-- unreadable role simply draws nothing rather than guessing "DAMAGER".
			SetRole(row, Ask(UnitGroupRolesAssigned, unit))

			-- Only for a character that owns a dispel, and only on a definite yes.
			-- AllyHasRemovableAura returns nil when it could not read, and nil is
			-- not false: an unreadable answer must not draw "nothing to do here".
			local dispelIcon = ns.GetPlayerDispelIcon and ns.GetPlayerDispelIcon()
			if dispelIcon and ns.AllyHasRemovableAura and ns.AllyHasRemovableAura(unit) == true then
				row.dispel:SetTexture(dispelIcon)
				row.dispel:Show()
			else
				row.dispel:Hide()
			end
			-- The red wash, bound to this row's current occupant. Only for a character
			-- that HAS a dispel: the container would otherwise light up rows for
			-- somebody who can do nothing about them.
			BindDispelGlow(i, dispelIcon and unit or nil)
			-- A party member's own name reads normally; only their enemy target is
			-- protected. Both are passed straight to SetText regardless — the widget
			-- accepts a secret, we simply never look at one.
			-- Class colour on the MEMBER only. A party member is friendly, so their
			-- class reads — it is only a hostile identity that is secret. Still asked
			-- through Ask()/Secret(), and an unreadable class falls back to house gold
			-- rather than to a guess.
			--
			-- row.target stays uncoloured on purpose: that name is a secret we draw
			-- and may not classify. Colouring it would mean asking what it is.
			local classToken = Ask(function()
				return select(2, UnitClass(unit))
			end)
			local col = (not Secret(classToken)) and classToken
				and RAID_CLASS_COLORS and RAID_CLASS_COLORS[classToken] or nil
			if col then
				row.member:SetTextColor(col.r, col.g, col.b)
			else
				row.member:SetTextColor(HeaderRGB())
			end
			row.member:SetText(Ask(UnitName, unit))
			local tUnit = unit .. "target"
			if ReadsTrue(Ask(UnitExists, tUnit)) then
				-- UnitExists is the gate BECAUSE it reads where the name does not.
				-- Branching on the name itself would mean inspecting a secret.
				row.target:SetText(Ask(UnitName, tUnit))
				SetMarker(row, tUnit)
			else
				row.target:SetText(L("PARTYTARGETS_NONE", "|cff9d9d9d— no target —|r"))
				row.marker:Hide()
			end
			row.member:Show()
			row.target:Show()
			if row.stripe then
				row.stripe:Show()
			end
		else
			row.member:Hide()
			row.target:Hide()
			row.role:Hide()
			row.roleLetter:Hide()
			row.marker:Hide()
			row.dispel:Hide()
			-- Park the container too: same reason as the stripe below. An unbound
			-- aura container left on a shrunken panel would keep watching whoever
			-- used to sit here.
			BindDispelGlow(i, nil)
			-- The panel shrinks to fit the rows it uses, and a texture is not
			-- clipped by its parent: a stripe left showing would hang below the
			-- border as a floating grey bar.
			if row.stripe then
				row.stripe:Hide()
			end
		end
	end

	-- Showing or hiding a secure button is blocked in combat. Party size does not
	-- change mid-fight in practice, so deferring to PLAYER_REGEN_ENABLED loses
	-- nothing — and attempting it anyway would throw an action-blocked error at
	-- the worst moment.
	if not (InCombatLockdown and InCombatLockdown()) then
		for i = 1, MAX_ROWS do
			local on = visible[i] and shown > 0 or false
			if clicks[i] then
				clicks[i]:SetShown(on)
			end
			if tclicks[i] then
				tclicks[i]:SetShown(on)
			end
		end
	end

	if shown == 0 then
		panel:Hide()
		return
	end
	panel:SetHeight(PAD * 2 + HEAD_H + ROW_H * shown)
	panel:Show()
	PositionClicks()
end

--- Refresh is cheap but UNIT_TARGET fires a lot in combat, so coalesce into the
--- next frame rather than redrawing per event.
local pending = false
local function ScheduleRefresh()
	if pending or not (C_Timer and C_Timer.After) then
		return
	end
	pending = true
	C_Timer.After(0.1, function()
		pending = false
		pcall(Refresh)
	end)
end

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("GROUP_ROSTER_UPDATE")
-- Roles change without a roster change: someone re-queues as tank, or the group
-- finder assigns them on entering a dungeon.
f:RegisterEvent("PLAYER_ROLES_ASSIGNED")
-- Leaving combat is when the secure buttons can finally be shown and repositioned.
f:RegisterEvent("PLAYER_REGEN_ENABLED")
--- The right-click spells belong to a SPEC, and a spec is not a fixed thing. Both of
--- these change which dispel and purge this character has, and neither one moves a
--- unit, so without them the buttons would keep casting the previous build's spell.
--- DispelHelper watches the same pair for the same reason -- every one of these
--- spells is a talent, so a loadout swap changes them without the spec ever changing.
f:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
f:RegisterEvent("TRAIT_CONFIG_UPDATED")
-- Placing a skull on the mob everyone is already fighting changes no target, so
-- UNIT_TARGET stays silent and the icon would only appear on the next swap.
f:RegisterEvent("RAID_TARGET_UPDATE")
f:RegisterUnitEvent("UNIT_TARGET", "party1", "party2")
f:SetScript("OnEvent", ScheduleRefresh)
-- UNIT_TARGET only takes two units per registration, so party3/4 need their own.
local f2 = CreateFrame("Frame")
f2:RegisterUnitEvent("UNIT_TARGET", "party3", "party4")
f2:SetScript("OnEvent", ScheduleRefresh)

-- A debuff landing on an ally changes nobody's target, so without these the dispel
-- indicator would only appear the next time someone switched targets — which in a
-- fight is exactly when it is already too late to matter.
--
-- UNIT_AURA is noisy, and that is what the 0.1s coalescing above is for: the
-- refresh already runs at most ten times a second however many events arrive.
local f3 = CreateFrame("Frame")
f3:RegisterUnitEvent("UNIT_AURA", "party1", "party2")
f3:SetScript("OnEvent", ScheduleRefresh)
local f4 = CreateFrame("Frame")
f4:RegisterUnitEvent("UNIT_AURA", "party3", "party4")
f4:SetScript("OnEvent", ScheduleRefresh)

--- Read/write pair for the settings panel. A slash command alone is not a feature
--- anyone finds: MH's own July review called that out as its heaviest UX fault, and
--- shipping this behind `/mh partytargets` only would have repeated it.
function ns.IsPartyTargetsEnabled()
	return (ns.db and ns.db.partyTargets) and true or false
end

function ns.SetPartyTargetsEnabled(v)
	ns.db = ns.db or {}
	ns.db.partyTargets = v and true or false
	Refresh()
end

--- `/mh partytargets` — toggle. Off by default: MH does not put frames on someone's
--- screen uninvited.
function ns.TogglePartyTargets()
	ns.db = ns.db or {}
	ns.db.partyTargets = not ns.db.partyTargets
	local p = ("|cffffcc00%s|r"):format((ns.L and ns:L("PRINT_PREFIX")) or "Midnight Helper:")
	if ns.db.partyTargets then
		print(("%s %s"):format(p, L("PARTYTARGETS_ON",
			"Party targets ON — drag the panel where you want it. Shows in a party only.")))
	else
		print(("%s %s"):format(p, L("PARTYTARGETS_OFF", "Party targets OFF.")))
	end
	Refresh()
end

ns.RefreshPartyTargets = Refresh
