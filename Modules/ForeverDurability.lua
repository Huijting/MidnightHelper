local _, ns = ...

--[[
	ForeverDurability.lua — WoW Forever: your gear is worn, with the way to the nearest vendor who repairs.
	Rob, 20 Nov 2026 (via sparring), verbatim: "ja doe maar" on "wil je die waarschuwing ook in Forever? Bijvoorbeeld: zijn
	je spullen onder de 25%, dan zegt MH het en toont hij de knop 'Repair & sell' erbij."

	Midnight has DurabilityWarn.lua (retail toc only, GEMETEN); its triggers are retail moments (a ready check, walking into
	a dungeon). Here: when your most worn item drops under the limit (25%), once, a small window in the middle of the
	screen says so — the same words as Midnight (DURABILITY_WARN_FMT, already in 7 languages) — names the worst item and
	the nearest vendor who repairs (ForeverVendors.lua ns.ForeverRepairNearest), with a button that sets the arrow. A chat
	line keeps a record. Not again until the item was repaired above the limit. In combat it waits for the fight to end.
	Switch in Quiet helpers (FDUR_SW), on by default.
	/mh durability prints what MH sees and why it did or did not warn; /mh durability test shows the window now (the same
	door as the real trigger). The retail module, which owns those commands in Midnight, does not load in Forever.
]]

if not ns.IS_FOREVER then
	return
end

local PREFIX = "|cffffcc00Midnight Helper:|r "
local DEFAULT_AT = 25
local SLOTS = { 1, 2, 3, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18 }
local last = "nothing checked yet"
local armed = true -- false after a warning, until the worst item is back above the limit

local function Settings()
	ns.db = ns.db or {}
	ns.db.foreverDurability = type(ns.db.foreverDurability) == "table" and ns.db.foreverDurability or {}
	local s = ns.db.foreverDurability
	if s.on == nil then
		s.on = true
	end
	s.at = tonumber(s.at) or DEFAULT_AT
	return s
end

function ns.IsForeverDurabilityOn()
	return Settings().on ~= false
end

function ns.SetForeverDurability(on)
	Settings().on = on and true or false
end

local function Secret(v)
	return issecretvalue and issecretvalue(v)
end

--- The most worn equipped item: percent, slot.
local function Lowest()
	if not GetInventoryItemDurability then
		return nil
	end
	local low, slot
	for _, s in ipairs(SLOTS) do
		local ok, c, m = pcall(GetInventoryItemDurability, s)
		if ok and c and m and not Secret(c) and not Secret(m) and m > 0 then
			local pct = c / m * 100
			if not low or pct < low then
				low, slot = pct, s
			end
		end
	end
	return low, slot
end

local function SlotLink(slot)
	if slot and GetInventoryItemLink then
		local ok, link = pcall(GetInventoryItemLink, "player", slot)
		if ok and type(link) == "string" then
			return link
		end
	end
	return nil
end

local win
local function Build()
	if win then
		return win
	end
	local f = CreateFrame("Frame", "MidnightHelperForeverDurability", UIParent, "BackdropTemplate")
	f:SetSize(460, 150)
	f:SetPoint("CENTER", 0, 180)
	f:SetFrameStrata("DIALOG")
	f:SetBackdrop({
		bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
		edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Border",
		tile = true, tileSize = 32, edgeSize = 32,
		insets = { left = 11, right = 12, top = 12, bottom = 11 },
	})
	f:SetBackdropColor(0.08, 0.03, 0.03, 0.97)
	f:EnableMouse(true)
	f:SetMovable(true)
	f:RegisterForDrag("LeftButton")
	f:SetScript("OnDragStart", f.StartMoving)
	f:SetScript("OnDragStop", f.StopMovingOrSizing)
	local close = CreateFrame("Button", nil, f, "UIPanelCloseButton")
	close:SetPoint("TOPRIGHT", -6, -6)
	f.big = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	f.big:SetPoint("TOPLEFT", 22, -20)
	f.big:SetPoint("RIGHT", f, "RIGHT", -36, 0)
	f.big:SetJustifyH("LEFT")
	f.big:SetTextColor(1, 0.3, 0.2)
	f.item = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	f.item:SetPoint("TOPLEFT", f.big, "BOTTOMLEFT", 0, -8)
	f.item:SetPoint("RIGHT", f, "RIGHT", -22, 0)
	f.item:SetJustifyH("LEFT")
	f.where = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	f.where:SetPoint("TOPLEFT", f.item, "BOTTOMLEFT", 0, -8)
	f.where:SetPoint("RIGHT", f, "RIGHT", -22, 0)
	f.where:SetJustifyH("LEFT")
	f.btn = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
	f.btn:SetSize(170, 24)
	f.btn:SetPoint("BOTTOMLEFT", 22, 18)
	f.btn:SetText(ns:L("FCITY_CAT_REPAIR"))
	f.btn:SetScript("OnClick", function()
		if ns.ForeverRepairGoNearest then
			ns.ForeverRepairGoNearest()
		end
	end)
	if ns.RegisterMidnightDialogPopup then
		ns.RegisterMidnightDialogPopup(f)
	else
		tinsert(UISpecialFrames, f:GetName())
	end
	f:Hide()
	win = f
	return f
end

--- The window and the chat line. Same door for the real trigger and /mh durability test.
local function Warn(low, slot)
	local f = Build()
	local big = ns:L("DURABILITY_WARN_FMT"):format(math.floor(low + 0.5))
	f.big:SetText(big)
	local link = SlotLink(slot)
	f.item:SetText(link and ns:L("DURABILITY_WORST_FMT"):format(link) or "")
	local near
	if ns.ForeverRepairNearest then
		local ok, r = pcall(ns.ForeverRepairNearest)
		near = ok and r or nil
	end
	if near then
		local dist = near.dist and ((ns.ForeverTrainerDistance and ns.ForeverTrainerDistance(math.floor(near.dist + 0.5)))
			or ("%d yd"):format(math.floor(near.dist + 0.5))) or ""
		f.where:SetText(ns:L("FBAG_REPAIR_NEAR_FMT"):format(tostring(near.name), tostring(near.zone), dist))
		f.btn:Enable()
	else
		f.where:SetText(ns:L("FCITY_REPAIR_NONE"))
		f.btn:Disable()
	end
	f:Show()
	if PlaySound and SOUNDKIT and SOUNDKIT.RAID_WARNING then
		pcall(PlaySound, SOUNDKIT.RAID_WARNING, "Master")
	end
	print(PREFIX .. big .. (link and (" " .. ns:L("DURABILITY_WORST_FMT"):format(link)) or ""))
end

local pendingCombat = false
local function Check(event)
	local s = Settings()
	local low, slot = Lowest()
	if not low then
		last = event .. ": no durability could be read"
		return
	end
	if low >= s.at then
		armed = true
		last = ("%s: lowest %.0f%%, limit %d%%: fine"):format(event, low, s.at)
		return
	end
	if not s.on then
		last = ("%s: lowest %.0f%% under %d%%, but switched off (Quiet helpers)"):format(event, low, s.at)
		return
	end
	if not armed then
		last = ("%s: lowest %.0f%%, already warned; again after a repair"):format(event, low)
		return
	end
	if InCombatLockdown and InCombatLockdown() then
		pendingCombat = true
		last = ("%s: lowest %.0f%%, in combat: waits for the fight to end"):format(event, low)
		return
	end
	armed = false
	pendingCombat = false
	Warn(low, slot)
	last = ("%s: lowest %.0f%% under %d%%: warned"):format(event, low, s.at)
end

local ev = CreateFrame("Frame")
ev:RegisterEvent("UPDATE_INVENTORY_DURABILITY")
ev:RegisterEvent("PLAYER_ENTERING_WORLD")
ev:RegisterEvent("PLAYER_REGEN_ENABLED")
ev:SetScript("OnEvent", function(_, event)
	if event == "PLAYER_REGEN_ENABLED" and not pendingCombat then
		return
	end
	if event == "PLAYER_ENTERING_WORLD" then
		C_Timer.After(3, function()
			pcall(Check, "login / loading screen")
		end)
		return
	end
	pcall(Check, event == "PLAYER_REGEN_ENABLED" and "after the fight" or "durability changed")
end)

--- /mh durability [test] — in Forever this module answers (DurabilityWarn.lua is Midnight only).
function ns.DurabilityCommand(arg)
	local s = Settings()
	if arg == "test" then
		local low, slot = Lowest()
		if not low then
			print(PREFIX .. "durability test: no durability could be read (no gear with durability equipped?)")
			return
		end
		Warn(low, slot)
		return
	end
	local low, slot = Lowest()
	print(PREFIX .. ("durability (Forever): warning %s, limit %d%%. Last: %s"):format(s.on and "on" or "off", s.at, last))
	if low then
		print(("   most worn now: %.0f%% %s · %s"):format(low, SlotLink(slot) or "", armed and "will warn under the limit"
			or "already warned, again after a repair"))
	end
	print("   /mh durability test shows the window now, with the nearest vendor who repairs.")
end
