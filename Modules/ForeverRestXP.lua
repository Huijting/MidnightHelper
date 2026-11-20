local _, ns = ...

--[[
	ForeverRestXP.lua — WoW Forever: log out where rested XP builds fastest, and get shown the way there.
	Rob, 20 Nov 2026 (via sparring): "Laten we doorgaan met REST XP, shortest path." Idea: docs/IDEEEN.md "Rest XP".
	Idea seen in Fennick Rest (PolyForm licence, not open source) and RestedAlts (MIT): NO code taken, only the idea.

	Facts (two independent mh-research runs, 20 Nov 2026; sources in docs/NEXT_SESSION.md):
	  - Rest areas are inns and capital cities. Blizzard's own text says so (GlobalStrings NEWBIE_TOOLTIP_XPBAR, Forever
	    1.60.1.70959: "logging out at an inn or city"). AreaTable Flags_0 0x20 sits on the six capitals (GEMETEN, DB2);
	    inns are server-side area triggers, NOT in client data. So the truth is the client's IsResting(), not a list.
	  - In a rest area you log out at once; outside it a 20 s timer runs (two guides; GEMETEN only there). That timer is
	    PLAYER_CAMPING — so PLAYER_CAMPING means "logging out outside a rest area", the moment for this tip.
	  - Outside a rest area rested XP builds more slowly (guides say a quarter; not in Blizzard data) -> texts say "more slowly".
	  - Events PLAYER_CAMPING, PLAYER_UPDATE_RESTING, UPDATE_EXHAUSTION, LOGOUT_CANCEL exist in Forever (snapshot, GEMETEN);
	    IsResting/GetXPExhaustion/GetRestState are called by Blizzard's Forever UI (GEMETEN), working here: AFGELEID.

	Where to go: the inns MH knows (ForeverCitySpots via ns.ForeverVendorFindRows("inn"); since 20 Nov 2026 the village inns too) plus every place
	where IsResting() said yes for one of your characters (ns.db.foreverRestSpots, one per map + subzone) — so village
	inns are learned by being there once. Friendly side only.
	Seen without a command: (1) a small window when you start logging out outside a rest area (switch FREST_SW, on by
	default), (2) a line in the XP tooltip of the overview. /mh rest [go] prints every decision and the reason.
]]

if not ns.IS_FOREVER then
	return
end

local PREFIX = "|cffffcc00Midnight Helper:|r "
local HEARTHSTONE = 6948 -- Forever DB2 ItemSparse (GEMETEN, ForeverTravel.lua)
local state = { last = "nothing yet", shown = 0, learned = 0 }

function ns.IsForeverRestTipOn()
	return not (type(ns.db) == "table" and ns.db.foreverRestTip == false)
end

function ns.SetForeverRestTip(on)
	if type(ns.db) ~= "table" then
		return
	end
	-- plain branches (lint [29])
	if on then
		ns.db.foreverRestTip = nil
	else
		ns.db.foreverRestTip = false
	end
end

local function Resting()
	if not IsResting then
		return nil
	end
	local ok, v = pcall(IsResting)
	if ok then
		return v and true or false
	end
	return nil
end

local function AtMax()
	if IsPlayerAtEffectiveMaxLevel then
		local ok, v = pcall(IsPlayerAtEffectiveMaxLevel)
		if ok and v then
			return true
		end
	end
	local max = GetMaxPlayerLevel and GetMaxPlayerLevel()
	return max and UnitLevel and UnitLevel("player") >= max or false
end

local function Side()
	local f = UnitFactionGroup and UnitFactionGroup("player")
	return (f == "Alliance" and "A") or (f == "Horde" and "H") or nil
end

local function World(map, x, y)
	if not (C_Map and C_Map.GetWorldPosFromMapPos and CreateVector2D) then
		return nil
	end
	local ok, cont, pos = pcall(C_Map.GetWorldPosFromMapPos, map, CreateVector2D(x / 100, y / 100))
	if not ok or not cont or not pos then
		return nil
	end
	local okXY, wx, wy = pcall(pos.GetXY, pos)
	if not okXY or not wx then
		return nil
	end
	return cont, wx, wy
end

local function Here()
	local map = C_Map and C_Map.GetBestMapForUnit and C_Map.GetBestMapForUnit("player")
	if not map or not C_Map.GetPlayerMapPosition then
		return nil
	end
	local ok, pos = pcall(C_Map.GetPlayerMapPosition, map, "player")
	if not ok or not pos then
		return nil
	end
	local okXY, x, y = pcall(pos.GetXY, pos)
	if not okXY or not x then
		return nil
	end
	return map, x * 100, y * 100
end

local function ZoneName(map)
	local info = C_Map and C_Map.GetMapInfo and C_Map.GetMapInfo(map)
	return info and info.name or ("map " .. tostring(map))
end

local function Distance(yards)
	if ns.ForeverTrainerDistance then
		return ns.ForeverTrainerDistance(yards)
	end
	return ("%d yd"):format(math.floor(yards + 0.5))
end

--- Remember where the client said "resting" (one spot per map + subzone, friendly side).
local function Learn()
	if Resting() ~= true or type(ns.db) ~= "table" then
		return
	end
	local map, x, y = Here()
	if not map then
		return
	end
	local sub = (GetSubZoneText and GetSubZoneText()) or ""
	if sub == "" then
		sub = (GetZoneText and GetZoneText()) or ZoneName(map)
	end
	ns.db.foreverRestSpots = ns.db.foreverRestSpots or {}
	local key = map .. ":" .. sub
	if not ns.db.foreverRestSpots[key] then
		ns.db.foreverRestSpots[key] = { map = map, x = x, y = y, name = sub, side = Side() }
		state.learned = state.learned + 1
	end
end

--- Every place to rest MH knows, nearest first: { name, zone, dist, go } (dist nil = other continent / unknown).
local function Places()
	local out = {}
	if ns.ForeverVendorFindRows then
		local ok, rows = pcall(ns.ForeverVendorFindRows, "inn")
		if ok and type(rows) == "table" then
			for _, r in ipairs(rows) do
				out[#out + 1] = { name = r.name, zone = r.zone, dist = r.dist, go = r.go, from = "inn list" }
			end
		end
	end
	local side = Side()
	local hm, hx, hy = Here()
	local hc, wx, wy
	if hm then
		hc, wx, wy = World(hm, hx, hy)
	end
	for _, s in pairs((type(ns.db) == "table" and ns.db.foreverRestSpots) or {}) do
		if not s.side or s.side == side then
			local sc, sx, sy = World(s.map, s.x, s.y)
			local dist
			if hc and sc and hc == sc then
				dist = math.sqrt((sx - wx) ^ 2 + (sy - wy) ^ 2)
			end
			local spot = s
			out[#out + 1] = { name = s.name, zone = ZoneName(s.map), dist = dist, from = "rested here before",
				go = function()
					if not (ns.SetBlizzardUserWaypoint and ns.SetBlizzardUserWaypoint(spot.map, spot.x, spot.y)) then
						return false
					end
					ns.lastTarget = { mapID = spot.map, x = spot.x, y = spot.y, name = spot.name, via = "/mh rest",
						arriveYards = 15 }
					ns._mhRouteOwner = "waypoint"
					return true
				end }
		end
	end
	table.sort(out, function(a, b)
		if a.dist and b.dist then
			return a.dist < b.dist
		end
		if a.dist or b.dist then
			return a.dist ~= nil
		end
		return (a.name or "") < (b.name or "")
	end)
	return out
end

local function HearthReady()
	local countFn = (C_Item and C_Item.GetItemCount) or GetItemCount
	local okN, n = pcall(countFn or function() return nil end, HEARTHSTONE)
	if not okN or not tonumber(n) or tonumber(n) < 1 then
		return false, "no Hearthstone in your bags"
	end
	local cdFn = (C_Container and C_Container.GetItemCooldown) or (C_Item and C_Item.GetItemCooldown) or GetItemCooldown
	if not cdFn then
		return nil, "cannot read the cooldown"
	end
	local ok, start, dur = pcall(cdFn, HEARTHSTONE)
	if not ok then
		return nil, "cannot read the cooldown"
	end
	start, dur = tonumber(start) or 0, tonumber(dur) or 0
	if start > 0 and dur > 2 then
		local left = start + dur - GetTime()
		if left > 0 then
			return false, ("on cooldown, %d min left"):format(math.ceil(left / 60))
		end
	end
	return true, "ready"
end

local function Bind()
	if not GetBindLocation then
		return nil
	end
	local ok, b = pcall(GetBindLocation)
	if ok and type(b) == "string" and b ~= "" then
		return b
	end
	return nil
end

--- The window (only when logging out outside a rest area).
local win
local function Build()
	if win then
		return win
	end
	local f = CreateFrame("Frame", "MidnightHelperForeverRestWindow", UIParent, "BackdropTemplate")
	f:SetSize(360, 140)
	f:SetFrameStrata("DIALOG")
	f:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8X8", edgeFile = "Interface\\Buttons\\WHITE8X8", edgeSize = 1 })
	f:SetPoint("TOP", UIParent, "TOP", 0, -160)
	f:EnableMouse(true)
	f:SetMovable(true)
	f:RegisterForDrag("LeftButton")
	f:SetScript("OnDragStart", f.StartMoving)
	f:SetScript("OnDragStop", f.StopMovingOrSizing)
	f.title = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	f.title:SetPoint("TOPLEFT", 12, -10)
	f.title:SetPoint("RIGHT", f, "RIGHT", -32, 0)
	f.title:SetJustifyH("LEFT")
	local close = CreateFrame("Button", nil, f, "UIPanelCloseButton")
	close:SetPoint("TOPRIGHT", 2, 2)
	close:SetScale(0.8)
	f.body = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	f.body:SetPoint("TOPLEFT", f.title, "BOTTOMLEFT", 0, -8)
	f.body:SetWidth(336)
	f.body:SetJustifyH("LEFT")
	f.body:SetJustifyV("TOP")
	if f.body.SetSpacing then
		f.body:SetSpacing(3)
	end
	f.go = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
	f.go:SetSize(130, 22)
	f.go:SetPoint("BOTTOMRIGHT", -10, 8)
	f.go:SetText(ns:L("FCQ_BTN"))
	f.go:SetScript("OnClick", function()
		ns.ForeverRestGo()
	end)
	function f:Fit()
		self:SetHeight(10 + (self.title:GetStringHeight() or 14) + 8 + (self.body:GetStringHeight() or 15) + 12 + 22 + 8)
	end
	if ns.ForeverStyle and ns.ForeverStyle.SkinOnShow then
		ns.ForeverStyle.SkinOnShow(f)
	end
	if ns.RegisterMidnightDialogPopup then
		ns.RegisterMidnightDialogPopup(f) -- Shift+scroll, Escape
	end
	f:Hide()
	win = f
	return f
end

--- The sentences, shared by the window and /mh rest.
local function Lines()
	local lines = { ns:L("FREST_NOT_RESTING") }
	local ready = HearthReady()
	local bind = Bind()
	if ready == true and bind then
		-- The item's name as THIS client shows it (game-name rule, CLAUDE.md); English only while the item is uncached.
		local getName = (C_Item and C_Item.GetItemNameByID) or GetItemInfo
		local okN, hsName = pcall(getName or function() return nil end, HEARTHSTONE)
		hsName = (okN and type(hsName) == "string" and hsName ~= "") and hsName or "Hearthstone"
		lines[#lines + 1] = ns:L("FREST_HEARTH_FMT"):format(hsName, bind)
	end
	local p = Places()[1]
	if p then
		lines[#lines + 1] = ns:L("FREST_NEAREST_FMT"):format(p.name or "?", p.zone or "?",
			p.dist and Distance(p.dist) or ns:L("FVEND_OTHER_CONT"))
	else
		lines[#lines + 1] = ns:L("FREST_NONE")
	end
	return lines, p
end

local function ShowTip()
	if not ns.IsForeverRestTipOn() then
		state.last = "logout outside a rest area: switched off (Quiet helpers)"
		return
	end
	if AtMax() then
		state.last = "logout outside a rest area: max level, no XP to rest for"
		return
	end
	if Resting() == true then
		state.last = "logout timer, but the client says you are resting: nothing to say"
		return
	end
	local f = Build()
	local lines, p = Lines()
	f.title:SetText(ns:L("FREST_WIN_TITLE"))
	f.body:SetText(table.concat(lines, "\n"))
	f.go:SetShown(p ~= nil)
	f:Fit()
	f:Show()
	state.shown = state.shown + 1
	state.last = "logout outside a rest area: window shown" .. (p and (", nearest " .. tostring(p.name)) or ", no place known")
end

function ns.ForeverRestGo()
	local p = Places()[1]
	if not p then
		print(PREFIX .. ns:L("FREST_NONE"))
		return false
	end
	local ok = p.go and p.go()
	if ok then
		print(PREFIX .. ns:L("FREST_ARROW_FMT"):format(p.name or "?", p.zone or "?"))
	end
	return ok
end

--- One line for the XP tooltip of the overview (nil at max level).
function ns.ForeverRestTipLine()
	if AtMax() then
		return nil
	end
	local r = Resting()
	if r == true then
		return ns:L("FREST_TIP_RESTING")
	elseif r == false then
		local p = Places()[1]
		return ns:L("FREST_TIP_NOT_FMT"):format(p and p.name or "?")
	end
	return nil
end

local ev = CreateFrame("Frame")
for _, e in ipairs({ "PLAYER_CAMPING", "LOGOUT_CANCEL", "PLAYER_UPDATE_RESTING", "PLAYER_ENTERING_WORLD" }) do
	pcall(ev.RegisterEvent, ev, e)
end
ev:SetScript("OnEvent", function(_, event)
	if event == "PLAYER_CAMPING" then
		ShowTip()
	elseif event == "LOGOUT_CANCEL" then
		if win and win:IsShown() then
			win:Hide()
		end
	else
		Learn()
		if Resting() == true and win and win:IsShown() then
			win:Hide()
		end
	end
end)

--- /mh rest [go]
function ns.ForeverRestSlash(arg)
	arg = (arg or ""):lower()
	if arg == "go" then
		ns.ForeverRestGo()
		return
	end
	local r = Resting()
	local xp = GetXPExhaustion and GetXPExhaustion() or nil
	local max = UnitXPMax and UnitXPMax("player") or 0
	local okS, sid, sname = pcall(GetRestState or function() return nil end)
	local ready, why = HearthReady()
	print(PREFIX .. ("rested XP tip: %s (Quiet helpers). Resting now (IsResting): %s. Max level: %s."):format(
		ns.IsForeverRestTipOn() and "on" or "off", r == nil and "UNREADABLE" or tostring(r), tostring(AtMax())))
	print(("  rested XP: %s%s; rest state: %s"):format(tostring(xp or 0),
		(xp and max > 0) and (" (" .. math.floor(xp / max * 100 + 0.5) .. "% of this level)") or "",
		okS and (tostring(sid) .. " " .. tostring(sname)) or "unreadable"))
	print(("  Hearthstone: %s (%s); bound to: %s"):format(tostring(ready), tostring(why), tostring(Bind() or "?")))
	local list = Places()
	local spots = 0
	for _ in pairs((type(ns.db) == "table" and ns.db.foreverRestSpots) or {}) do
		spots = spots + 1
	end
	print(("  places known: %d (of which learned by resting there: %d, new this session: %d)"):format(#list, spots,
		state.learned))
	for i = 1, math.min(3, #list) do
		local p = list[i]
		print(("    %d. %s, %s, %s (%s)"):format(i, tostring(p.name), tostring(p.zone),
			p.dist and Distance(p.dist) or "other continent", p.from))
	end
	print(("  windows shown: %d; last decision: %s. /mh rest go = arrow to the nearest."):format(state.shown, state.last))
end
