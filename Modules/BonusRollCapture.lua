local _, ns = ...

--[[
	Midnight Helper — bonus-roll recorder (`/mh bonusroll`, dev tool, opt-in).

	Rob finished a delve on live 12.0.7 on 6 Aug and got a popup with a die he could
	click for a bonus roll. He had never seen it before, and neither had this addon:
	the only bonus roll we know about is the Season 2 "Nebulous Voidcore", which is a
	BUTTON IN THE GREAT VAULT and is gated out on live. A popup with a die is not that.

	So either there is a live mechanic we say nothing about, or the Season 2 one looks
	different from what `VaultAdvisor` assumes — and that file already flags its
	three-slot threshold as the one part never confirmed on a live realm. Both readings
	matter, and neither is worth guessing at.

	WHAT IT RECORDS. `BonusRollFrame` is a real Blizzard frame (EllesmereUIQoL lists it
	among the movable windows), so this watches for it becoming visible and writes down
	whatever the client put on it. It does NOT assume field names: it walks the frame's
	own keys and keeps the scalars, so whatever Blizzard actually stores there lands in
	the file whether or not anyone has documented it. Every visible FontString is read
	too, because the words on the popup say what it is for.

	WHY A TICKER AND NOT A HOOK. Hooking Show on a Blizzard frame that sits next to
	loot is asking for taint near something protected. A one-second poll costs nothing,
	cannot taint anything, and a popup you are meant to click stays up far longer.

	⚠️ 12.x SECRETS. A value on that frame may be secret, and a secret string passes
	type() — the trap that broke QuestDiff the same evening. Everything is filtered
	through issecretvalue before it is stored or formatted.
]]

local CAP = 40

local function Store()
	if not ns.db then
		return nil
	end
	if type(ns.db.bonusRollLog) ~= "table" then
		ns.db.bonusRollLog = {}
	end
	return ns.db.bonusRollLog
end

local function Secret(v)
	return issecretvalue and issecretvalue(v) or false
end

--- Keep a value only when it is a readable scalar.
local function Scalar(v)
	if v == nil or Secret(v) then
		return nil
	end
	local t = type(v)
	if t == "number" or t == "boolean" then
		return v
	end
	if t == "string" then
		return v
	end
	return nil
end

--- Every readable scalar the frame carries, by its own key names.
---
--- Field names are not assumed anywhere here. Whatever Blizzard stores — a currency
--- id, a spell id, a cost, a flag — comes out under the name they gave it.
local function FrameFields(frame)
	local out = {}
	local ok = pcall(function()
		for k, v in pairs(frame) do
			if type(k) == "string" then
				local s = Scalar(v)
				if s ~= nil then
					out[k] = s
				end
			end
		end
	end)
	if not ok then
		out._walkFailed = true
	end
	return out
end

--- The words on the popup, which say what it is for better than any id.
---
--- ⚠️ CHILDREN TOO. The first version read only `GetRegions()` on the frame itself and
--- came back with nothing at all, while Rob's screenshot plainly showed "Bonus Loot",
--- "Cost: 1" and a currency count. Blizzard nests those in child frames, so a flat read
--- of the top level sees an empty popup. One level of children is enough here and keeps
--- it cheap.
local function FrameTexts(frame)
	local out = {}
	local function harvest(f)
		if not (f and f.GetRegions) then
			return
		end
		for _, region in ipairs({ f:GetRegions() }) do
			if region and region.GetText then
				local okT, txt = pcall(region.GetText, region)
				if okT and type(txt) == "string" and txt ~= "" and not Secret(txt) then
					out[#out + 1] = txt
				end
			end
		end
	end
	local ok = pcall(function()
		harvest(frame)
		if frame.GetChildren then
			for _, child in ipairs({ frame:GetChildren() }) do
				harvest(child)
			end
		end
	end)
	if not ok then
		out[#out + 1] = "(regions unreadable)"
	end
	return out
end

--- Which currency does it cost, and how much of it does the player have?
---
--- The frame reported a spellID and a countdown but no currency at all, while the popup
--- on screen showed "Cost: 1" beside an icon and "23" below it. `C_CurrencyInfo` is
--- where that lives; without it we would be recording that a bonus roll exists and not
--- what it is paid with, which is the part that decides whether this is the Season 2
--- mechanic we already model or something else entirely.
local function CurrencyGuesses(frame)
	local out = {}
	local ok = pcall(function()
		for k, v in pairs(frame) do
			if type(k) == "string" and k:lower():find("currency") and type(v) == "number" then
				local row = { field = k, id = v }
				if C_CurrencyInfo and C_CurrencyInfo.GetCurrencyInfo then
					local okC, info = pcall(C_CurrencyInfo.GetCurrencyInfo, v)
					if okC and type(info) == "table" then
						row.name = info.name
						row.quantity = info.quantity
					end
				end
				out[#out + 1] = row
			end
		end
	end)
	if not ok then
		out[#out + 1] = { field = "(walk failed)" }
	end
	return out
end

local wasShown = false

local function Capture()
	local frame = _G and _G.BonusRollFrame
	if not frame or not frame.IsShown then
		return
	end
	local okShown, shown = pcall(frame.IsShown, frame)
	if not okShown then
		return
	end
	if not shown then
		wasShown = false
		return
	end
	if wasShown then
		return -- already recorded this appearance
	end
	wasShown = true

	local store = Store()
	if not store or #store >= CAP then
		return
	end

	local mapID
	if C_Map and C_Map.GetBestMapForUnit then
		local okM, m = pcall(C_Map.GetBestMapForUnit, "player")
		mapID = okM and m or nil
	end
	local instName, instType, instDiff
	if GetInstanceInfo then
		local okI, n, ty, diff = pcall(GetInstanceInfo)
		if okI then
			instName, instType, instDiff = n, ty, diff
		end
	end

	store[#store + 1] = {
		fields = FrameFields(frame),
		texts = FrameTexts(frame),
		currency = CurrencyGuesses(frame),
		mapID = mapID,
		instanceName = Scalar(instName),
		instanceType = Scalar(instType),
		difficultyID = Scalar(instDiff),
	}

	local p = ("|cffffcc00%s|r"):format((ns.L and ns:L("PRINT_PREFIX")) or "Midnight Helper:")
	print(("%s bonus roll recorded (#%d). |cffffffff/reload|r when you are done."):format(p, #store))
end

local ticker
local function SetRunning(on)
	if on and not ticker and C_Timer and C_Timer.NewTicker then
		ticker = C_Timer.NewTicker(1, function()
			pcall(Capture)
		end)
	elseif not on and ticker then
		ticker:Cancel()
		ticker = nil
	end
end

--- `/mh bonusroll` — toggle. `/mh bonusroll clear` — throw the list away.
function ns.HandleBonusRollCapture(arg)
	local p = ("|cffffcc00%s|r"):format((ns.L and ns:L("PRINT_PREFIX")) or "Midnight Helper:")
	ns.db = ns.db or {}

	if arg == "clear" then
		ns.db.bonusRollLog = {}
		print(("%s bonus roll capture cleared."):format(p))
		return
	end

	ns.db.bonusRollCaptureOn = not ns.db.bonusRollCaptureOn
	SetRunning(ns.db.bonusRollCaptureOn)
	if ns.db.bonusRollCaptureOn then
		pcall(Capture) -- in case it is on screen right now
		print(("%s bonus roll capture ON — it records the popup the moment it appears."):format(p))
		print("   |cff9d9d9dDo a delve, take the roll, then |cffffffff/reload|r.|r")
	else
		print(("%s bonus roll capture OFF — %d recorded."):format(p, #(Store() or {})))
	end
end

-- Survives a reload, like the other recorders, so a run can span a loading screen.
local ev = CreateFrame("Frame")
ev:RegisterEvent("PLAYER_ENTERING_WORLD")
ev:SetScript("OnEvent", function()
	if ns.db and ns.db.bonusRollCaptureOn then
		SetRunning(true)
	end
end)
