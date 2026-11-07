local _, ns = ...

--[[
	ForeverTrainer.lua — WoW Forever: "new at your trainer", with the key each spell lands on.

	Rob, 7 Nov 2026: "ik denk aan a en dan evt zelf de optie geven om een pijl naar de trainer maken, dan hoeven we niet
	de extra addon te installeren" → "Ja, A + pijl". This file is step A; the arrow to the trainer is step 2.
	Idea from What's Training? (docs/forever/WHATS_TRAINING_2026-11-07.md). What MH adds: the KEY. What's Training knows
	what you can learn; only MH knows where it goes on your block.

	Data: ForeverTrainerData.lua (generated from What's Training?'s MIT data, levels cross-checked with our research).
	  - At every level-up: one chat line, and the window opens by itself when there is something to learn (out of combat).
	    /mh trainer auto off stops the window opening by itself (the chat line stays) — players choose, not us.
	  - /mh trainer        opens or closes the window (with the "Take me to my trainer" button, step 2)
	  - /mh trainer go     the arrow to your nearest class trainer; /mh trainer here records one; /mh trainer forget
	  - /mh trainer check  prints what was decided and why (a module whose normal result is "nothing" needs a way to see
	                       that it decided nothing on purpose — CLAUDE.md).
	Window texts are FTRAIN_* locale keys since 7 Nov 2026 (enUS + nlNL; the other packs in the translation round). The
chat lines of /mh trainer check stay English (a diagnosis).
]]

if not ns.IS_FOREVER then
	return
end

local DATA = ns.FOREVER_TRAINER_SPELLS

local function Token()
	local _, token = UnitClass("player")
	return token
end

local function Settings()
	if not ns.db then
		return { auto = true }
	end
	ns.db.foreverTrainer = ns.db.foreverTrainer or { auto = true }
	return ns.db.foreverTrainer
end

--- Does this character have this exact spell id?
local function KnownId(id)
	for _, fn in ipairs({ IsPlayerSpell, IsSpellKnown }) do
		if fn then
			local ok, v = pcall(fn, id)
			if ok and v == true then
				return true
			end
		end
	end
	return false
end

local function SpellName(e)
	if C_Spell and C_Spell.GetSpellName then
		local ok, nm = pcall(C_Spell.GetSpellName, e.id)
		if ok and type(nm) == "string" and nm ~= "" and not (issecretvalue and issecretvalue(nm)) then
			return nm
		end
	end
	return e.n
end

local function RankText(id)
	if C_Spell and C_Spell.GetSpellSubtext then
		local ok, sub = pcall(C_Spell.GetSpellSubtext, id)
		if ok and type(sub) == "string" and sub ~= "" and not (issecretvalue and issecretvalue(sub)) then
			return sub
		end
	end
	return nil
end

local function Money(c)
	if C_CurrencyInfo and C_CurrencyInfo.GetCoinTextureString then
		local ok, s = pcall(C_CurrencyInfo.GetCoinTextureString, c)
		if ok and s then
			return s
		end
	end
	if GetCoinTextureString then
		return GetCoinTextureString(c)
	end
	return tostring(c) .. "c"
end

--- Where a spell goes on the key block: "Q", "block D", or nil (not on the block).
local function KeyFor(token, name)
	local cls = ns.FOREVER_BLOCK_CLASSES and ns.FOREVER_BLOCK_CLASSES[token]
	if not cls then
		return nil
	end
	local function has(v)
		if type(v) == "string" then
			return v == name
		elseif type(v) == "table" then
			for _, n in ipairs(v) do
				if n == name then
					return true
				end
			end
		end
		return false
	end
	local label = ns.KeyBlockKeyLabel or function(k) return k end
	for key, def in pairs(cls.keys or {}) do
		for field, v in pairs(def) do
			if field == "pair" then
				if has(v.first) or has(v.second) then
					return label(key)
				end
			elseif field ~= "cmd" and field ~= "open" and field ~= "bang" and has(v) then
				return label(key)
			end
		end
	end
	if has(cls.toBlockD) then
		return ns:L("FTRAIN_BLOCK_D") -- the pack's own word, as in KEYBLOCK_UNPLACED_FMT ("bloc D", "Block D" …)
	end
	if has(cls.listed) then
		return false -- left off the block ON PURPOSE (the class table's `listed`), not forgotten
	end
	return nil
end

--- Everything the window and the check need, for this character at this level.
local function Compute(level)
	local token = Token()
	local list = DATA and token and DATA[token]
	local out = { token = token, level = level, now = {}, needs = {}, next = {}, nextLevel = nil, known = 0, other = 0,
		total = 0, data = list and #list or 0 }
	if not list then
		return out
	end
	local faction = UnitFactionGroup and UnitFactionGroup("player")
	local _, _, raceID = UnitRace("player")
	local levelOf = {}
	for _, e in ipairs(list) do
		levelOf[e.id] = e.l
	end
	-- Highest rank this character has under each name: a lower rank counts as known once a higher one is (Forever
	-- replaces some ranks in the spellbook; What's Training keeps "overriddenGroups" for the same reason).
	local bestByName = {}
	local function Known(e)
		if KnownId(e.id) then
			return true
		end
		if bestByName[e.n] == nil then
			local id = ns.ForeverKnownSpell and ns.ForeverKnownSpell(e.n)
			bestByName[e.n] = id or false
		end
		local best = bestByName[e.n]
		return best and levelOf[best] and levelOf[best] >= e.l or false
	end
	local function Fits(e)
		if e.fac and e.fac ~= faction then
			return false
		end
		if e.race and e.race ~= raceID then
			return false
		end
		if e.races then
			local ok = false
			for _, r in ipairs(e.races) do
				if r == raceID then
					ok = true
				end
			end
			if not ok then
				return false
			end
		end
		if e.tal and not KnownId(e.tal) then
			return false -- a talent spell: only for whoever took the talent
		end
		return true
	end
	local avail = {}
	for _, e in ipairs(list) do
		if not Fits(e) then
			out.other = out.other + 1
		elseif Known(e) then
			out.known = out.known + 1
		elseif e.l <= level then
			local missing
			for _, r in ipairs(e.req or {}) do
				-- The previous rank counts when any rank of that name is known: Forever swaps some out of the spellbook
				-- (Seal of Righteousness 20154 -> 21084 with Judgement; What's Training's "overriddenGroups").
				local byName = false
				if not KnownId(r) and not avail[r] and C_Spell and C_Spell.GetSpellName and ns.ForeverKnownSpell then
					local okN, rn = pcall(C_Spell.GetSpellName, r)
					byName = okN and type(rn) == "string" and ns.ForeverKnownSpell(rn) and true or false
				end
				if not KnownId(r) and not avail[r] and not byName then
					missing = r
				end
			end
			if missing then
				local nm
				if C_Spell and C_Spell.GetSpellName then
					local ok, n = pcall(C_Spell.GetSpellName, missing)
					nm = ok and n or nil
				end
				out.needs[#out.needs + 1] = { e = e, first = nm or ("spell " .. missing) }
			else
				avail[e.id] = true
				out.now[#out.now + 1] = e
				out.total = out.total + e.c
			end
		elseif not out.nextLevel or e.l == out.nextLevel then
			out.nextLevel = e.l
			out.next[#out.next + 1] = e
		end
	end
	return out
end
ns.ForeverTrainerCompute = Compute -- the offline check calls it

local function Line(token, e)
	local name = SpellName(e)
	local rank = RankText(e.id)
	local key = KeyFor(token, e.n)
	local passive = false
	if not key and C_Spell and C_Spell.IsSpellPassive then
		local okP, p = pcall(C_Spell.IsSpellPassive, e.id)
		passive = okP and p == true
	end
	-- Rob, 7 Nov 2026 ("Ja, pas aan"): Track Beasts said "put it on your own bar" although the Hunter table leaves all
	-- tracking off the block on purpose. `false` from KeyFor = on purpose; nil = really not in our list.
	local where = key and ("|cffffd100" .. key .. "|r")
		or passive and ("|cff9d9d9d" .. ns:L("FTRAIN_PASSIVE") .. "|r")
		or key == false and ("|cff9d9d9d" .. ns:L("FTRAIN_ON_PURPOSE") .. "|r")
		or ("|cff9d9d9d" .. ns:L("FTRAIN_OWN_BAR") .. "|r")
	return ("- %s%s  %s  ->  %s"):format(name, rank and (" |cff9d9d9d(" .. rank .. ")|r") or "", Money(e.c), where)
end

--- The window's lines, plus `ids[i]` = the spell id of line i (for its tooltip) or nil.
local function Text(r)
	local p, ids = {}, {}
	local HEAD = "|cffffcc66"
	-- Rob, 7 Nov 2026: "dat we ook kunnen zien hoeveel geld we hebben … nu moet ik ook eerst op B drukken". Your money
	-- on top; red with what is missing when it is not enough for everything you can learn now.
	local have = GetMoney and GetMoney()
	if have then
		local short = #r.now > 0 and have < r.total
		p[#p + 1] = HEAD .. ns:L("FTRAIN_MONEY") .. "|r  " .. Money(have) ..
			(short and ("  |cffff5555" .. ns:L("FTRAIN_SHORT_FMT"):format(Money(r.total - have)) .. "|r") or "")
		p[#p + 1] = ""
	end
	if #r.now > 0 then
		p[#p + 1] = HEAD .. ns:L("FTRAIN_NOW_FMT"):format(#r.now) .. "|r  " .. Money(r.total)
		for _, e in ipairs(r.now) do
			p[#p + 1] = Line(r.token, e)
			ids[#p] = e.id
		end
		p[#p + 1] = "|cff9d9d9d" .. ns:L("FTRAIN_KEY_HINT") .. "|r"
	else
		p[#p + 1] = HEAD .. ns:L("FTRAIN_NOTHING") .. "|r"
	end
	if #r.needs > 0 then
		p[#p + 1] = ""
		p[#p + 1] = HEAD .. ns:L("FTRAIN_NEEDS_HEAD") .. "|r"
		for _, n in ipairs(r.needs) do
			p[#p + 1] = ns:L("FTRAIN_NEEDS_FMT"):format(SpellName(n.e), n.first)
			ids[#p] = n.e.id
		end
	end
	if r.nextLevel then
		p[#p + 1] = ""
		p[#p + 1] = HEAD .. ns:L("FTRAIN_NEXT_FMT"):format(r.nextLevel) .. "|r"
		for _, e in ipairs(r.next) do
			p[#p + 1] = Line(r.token, e)
			ids[#p] = e.id
		end
	end
	p[#p + 1] = ""
	p[#p + 1] = "|cff9d9d9d" .. ns:L("FTRAIN_FOOTER") .. "|r"
	return table.concat(p, "\n"), p, ids
end

ns.ForeverTrainerText = function(level) -- the offline check prints it
	return (Text(Compute(level)))
end

local win

local function Build()
	if win then
		return win
	end
	local f = CreateFrame("Frame", "MidnightHelperForeverTrainer", UIParent, "BackdropTemplate")
	f:SetSize(560, 460)
	f:SetPoint("CENTER", 0, 60)
	f:SetFrameStrata("DIALOG")
	f:SetBackdrop({
		bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
		edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Border",
		tile = true, tileSize = 32, edgeSize = 32,
		insets = { left = 11, right = 12, top = 12, bottom = 11 },
	})
	f:SetBackdropColor(0.05, 0.05, 0.08, 0.97)
	f:EnableMouse(true)
	f:SetMovable(true)
	f:RegisterForDrag("LeftButton")
	f:SetScript("OnDragStart", f.StartMoving)
	f:SetScript("OnDragStop", f.StopMovingOrSizing)
	f.title = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	f.title:SetPoint("TOPLEFT", 22, -18)
	local close = CreateFrame("Button", nil, f, "UIPanelCloseButton")
	close:SetPoint("TOPRIGHT", -6, -6)
	-- The arrow button sits in the same window as the list (CLAUDE.md: the explanation in the same room as the button).
	local go = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
	go:SetSize(210, 24)
	go:SetPoint("BOTTOMLEFT", 20, 16)
	go:SetText(ns:L("HOME_FOREVER_BTN_GO"))
	go:SetScript("OnClick", function()
		if ns.ForeverTrainerGo then
			ns.ForeverTrainerGo()
		end
	end)
	f.go = go
	f.goHint = f:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
	f.goHint:SetPoint("LEFT", go, "RIGHT", 8, 0)
	f.goHint:SetPoint("RIGHT", f, "RIGHT", -20, 0)
	f.goHint:SetJustifyH("LEFT")
	local scroll = CreateFrame("ScrollFrame", nil, f, "UIPanelScrollFrameTemplate")
	scroll:SetPoint("TOPLEFT", 22, -48)
	scroll:SetPoint("BOTTOMRIGHT", -38, 48)
	local child = CreateFrame("Frame", nil, scroll)
	child:SetSize(490, 10)
	scroll:SetScrollChild(child)
	-- One font string per line, so a spell line can carry its own hover area (Rob, 7 Nov 2026: "ik wil tooltips bij
	-- de spells"). Not |Hspell links in one text: links fail inside a ScrollFrame (PlayCardWindow.lua's note).
	f.rows, f.hot = {}, {}
	f.scroll, f.child = scroll, child
	if ns.RegisterMidnightDialogPopup then
		ns.RegisterMidnightDialogPopup(f)
	else
		tinsert(UISpecialFrames, f:GetName())
	end
	f:Hide()
	win = f
	return f
end

local function Fill(level)
	local f = Build()
	local r = Compute(level or UnitLevel("player"))
	f.title:SetText(ns:L("FTRAIN_TITLE_FMT"):format(r.level))
	f.go:SetText(ns:L("HOME_FOREVER_BTN_GO")) -- the language can change while the window exists
	local _, lines, ids = Text(r)
	local y = -4
	for i, s in ipairs(lines) do
		local fs = f.rows[i]
		if not fs then
			fs = f.child:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
			fs:SetWidth(480)
			fs:SetJustifyH("LEFT")
			f.rows[i] = fs
		end
		fs:ClearAllPoints()
		fs:SetPoint("TOPLEFT", f.child, "TOPLEFT", 4, y)
		fs:SetText(s ~= "" and s or " ")
		fs:Show()
		local h = s ~= "" and fs:GetStringHeight() or 6
		local hot = f.hot[i]
		if ids[i] then
			if not hot then
				hot = CreateFrame("Button", nil, f.child)
				hot:SetScript("OnEnter", function(self)
					if not GameTooltip then
						return
					end
					GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
					local ok = pcall(GameTooltip.SetSpellByID, GameTooltip, self.spellId)
					if ok then
						GameTooltip:Show()
					else
						GameTooltip:Hide()
					end
				end)
				hot:SetScript("OnLeave", function()
					if GameTooltip then
						GameTooltip:Hide()
					end
				end)
				f.hot[i] = hot
			end
			hot.spellId = ids[i]
			hot:ClearAllPoints()
			hot:SetPoint("TOPLEFT", fs, "TOPLEFT")
			hot:SetSize(math.min(480, math.max(20, fs:GetStringWidth())), math.max(10, h))
			hot:Show()
		elseif hot then
			hot:Hide()
		end
		y = y - h - 3
	end
	for i = #lines + 1, #f.rows do
		f.rows[i]:Hide()
		if f.hot[i] then
			f.hot[i]:Hide()
		end
	end
	f.child:SetHeight(-y + 16)
	f.scroll:SetVerticalScroll(0)
	f.goHint:SetText(ns.ForeverTrainerNearestText and ns.ForeverTrainerNearestText() or "")
	return f, r
end

function ns.ShowForeverTrainer(level)
	local f = Fill(level)
	f:Show()
	-- The money line follows your purse while the window is open (buy at the trainer, loot, sell).
	if not f.moneyWatch then
		f.moneyWatch = true
		f:RegisterEvent("PLAYER_MONEY")
		f:SetScript("OnEvent", function(self)
			if self:IsShown() then
				Fill(self.level)
			end
		end)
	end
	f.level = level
	-- Rank texts load on demand; fill once more when the client has them (AFGELEID: the first call can miss some).
	if C_Timer and C_Timer.After then
		C_Timer.After(0.5, function()
			if f:IsShown() then
				Fill(level)
			end
		end)
	end
end

local PREFIX = "|cffffcc00Midnight Helper:|r "

--------------------------------------------------------------------------------
-- Step 2: the arrow to your class trainer (Rob, 7 Nov 2026: "alle drie, en eigenlijk vind ik dat we gewoon die van
-- handy notes moeten kunnen gebruiken !!"). Three sources, nearest wins:
--   1. places YOU recorded with /mh trainer here (MidnightHelperDB, per class, every character of that class);
--   2. HandyNotes: Class Trainers, when it is installed: read from that addon WHILE YOU PLAY. Its data is All Rights
--      Reserved, so MH never copies it into its own files; it only asks the addon the player already has.
--   3. ns.FOREVER_TRAINER_SPOTS (ForeverTrainerSpots.lua: 218 class trainers, our own list from Wowhead's Forever NPC
--      pages, checked against Zygor; works for everyone, also without HandyNotes).
--------------------------------------------------------------------------------

local function PlayerSide()
	local f = UnitFactionGroup and UnitFactionGroup("player")
	return (f == "Alliance" and "A") or (f == "Horde" and "H") or nil
end

--- map + x/y (0-100) → continent id and world x/y, or nil.
local function World(map, x, y)
	if not (C_Map and C_Map.GetWorldPosFromMapPos and CreateVector2D) then
		return nil
	end
	local ok, cont, pos = pcall(C_Map.GetWorldPosFromMapPos, map, CreateVector2D(x / 100, y / 100))
	if not ok or not cont or not pos then
		return nil
	end
	local okXY, wx, wy = pcall(pos.GetXY, pos)
	if not okXY or not wx or (issecretvalue and (issecretvalue(wx) or issecretvalue(wy) or issecretvalue(cont))) then
		return nil
	end
	return cont, wx, wy
end

--- Where the player stands: map, x, y (0-100), or nil.
local function PlayerPlace()
	local map = C_Map and C_Map.GetBestMapForUnit and C_Map.GetBestMapForUnit("player")
	if not map or not C_Map.GetPlayerMapPosition then
		return nil
	end
	local ok, pos = pcall(C_Map.GetPlayerMapPosition, map, "player")
	if not ok or not pos then
		return nil
	end
	local okXY, x, y = pcall(pos.GetXY, pos)
	if not okXY or not x or (issecretvalue and (issecretvalue(x) or issecretvalue(y))) then
		return nil
	end
	return map, x * 100, y * 100
end

local function Spots()
	local db = ns.db
	if not db then
		return {}
	end
	db.foreverTrainerSpots = db.foreverTrainerSpots or {}
	return db.foreverTrainerSpots
end

--- The HandyNotes: Class Trainers addon object, or nil. Its points table is
--- points[uiMapID][XXXXYYYY] = { npc, class, side = "A"/"H"/"N", name, kind, title } (read from its Data.lua header).
local function HandyNotesTrainers()
	local AceAddon = LibStub and LibStub("AceAddon-3.0", true)
	local addon = AceAddon and AceAddon:GetAddon("HandyNotes_ClassTrainers", true)
	if type(addon) == "table" and type(addon.points) == "table" then
		return addon
	end
	return nil
end

--- Every known class-trainer place for this character: { map, x, y, name, src }.
local function Candidates(token)
	local out, side = {}, PlayerSide()
	for _, s in ipairs(Spots()[token] or {}) do
		out[#out + 1] = { map = s.map, x = s.x, y = s.y, name = s.name, src = "yours" }
	end
	local hn = HandyNotesTrainers()
	if hn then
		for map, nodes in pairs(hn.points) do
			if type(nodes) == "table" then
				for coord, node in pairs(nodes) do
					if type(node) == "table" and node.class == token and not node.kind and type(coord) == "number"
						and (node.side == "N" or node.side == side) then
						out[#out + 1] = { map = map, x = math.floor(coord / 10000) / 100, y = (coord % 10000) / 100,
							name = node.name, src = "HandyNotes" }
					end
				end
			end
		end
	end
	for _, s in ipairs((ns.FOREVER_TRAINER_SPOTS or {})[token] or {}) do
		if not s.side or s.side == "N" or s.side == side then
			out[#out + 1] = { map = s.map, x = s.x, y = s.y, name = s.name, src = "MH list" }
		end
	end
	return out
end
ns.ForeverTrainerCandidates = Candidates -- the offline check calls it

--- The nearest trainer on the player's continent: the candidate, its distance (yards), and how many were looked at.
local function Nearest(token)
	local all = Candidates(token)
	local map, px, py = PlayerPlace()
	local cont, wx, wy
	if map then
		cont, wx, wy = World(map, px, py)
	end
	if not cont then
		return nil, nil, #all, "your position cannot be read here"
	end
	local best, bestD
	for _, c in ipairs(all) do
		local cc, cx, cy = World(c.map, c.x, c.y)
		if cc == cont then
			local d = math.sqrt((cx - wx) ^ 2 + (cy - wy) ^ 2)
			if not bestD or d < bestD then
				best, bestD = c, d
			end
		end
	end
	if not best then
		return nil, nil, #all, (#all == 0) and "no trainer places known yet" or "none on this continent"
	end
	return best, math.floor(bestD + 0.5), #all -- whole yards: %d needs an integer
end

--- "141 yards" or "129 meters", the same unit as the route arrow (setting "Show route distance in meters";
--- Rob, 7 Nov 2026: "wil je hem op meters zetten trouwens").
local function Distance(yards)
	if ns.GetNativeArrowMeters and ns.GetNativeArrowMeters() then
		return ns:L("FTRAIN_METERS_FMT"):format(math.floor(yards * 0.9144 + 0.5))
	end
	return ns:L("FTRAIN_YARDS_FMT"):format(yards)
end

-- The source names as the player reads them ("HandyNotes" is an addon's name and stays).
local SRC_KEY = { yours = "FTRAIN_SRC_YOURS", ["MH list"] = "FTRAIN_SRC_MH" }
local WHY_KEY = {
	["your position cannot be read here"] = "FTRAIN_WHY_POS",
	["no trainer places known yet"] = "FTRAIN_WHY_NONE",
	["none on this continent"] = "FTRAIN_WHY_CONT",
}

--- One line under the window's button: where it would take you, or what is missing.
function ns.ForeverTrainerNearestText()
	local best, dist, _, why = Nearest(Token())
	if best then
		local src = SRC_KEY[best.src] and ns:L(SRC_KEY[best.src]) or best.src
		return ns:L("FTRAIN_NEAREST_FMT"):format(best.name or ns:L("FTRAIN_YOUR_TRAINER"), Distance(dist), src)
	end
	return ns:L("FTRAIN_WHY_FMT"):format(WHY_KEY[why] and ns:L(WHY_KEY[why]) or why)
end

function ns.ForeverTrainerGo()
	local token = Token()
	local best, dist, n, why = Nearest(token)
	if not best then
		print(PREFIX .. "trainer arrow: " .. why .. ". Stand next to your trainer and type /mh trainer here " ..
			"(or install HandyNotes: Class Trainers).")
		return false
	end
	if not (ns.SetBlizzardUserWaypoint and ns.SetBlizzardUserWaypoint(best.map, best.x, best.y)) then
		print(PREFIX .. "trainer arrow: the game does not allow a waypoint on that map.")
		return false
	end
	local label = (best.name or "Class trainer") .. " (trainer)"
	ns.lastTarget = { mapID = best.map, x = best.x, y = best.y, name = label, via = "/mh trainer go" }
	ns._mhRouteOwner = "waypoint"
	print(PREFIX .. ("arrow set to %s, about %s (%s, %d places known)."):format(label, Distance(dist), best.src, n))
	return true
end

--- /mh trainer here: remember where this class's trainer stands (your target, or just this spot).
local function RecordHere()
	local token = Token()
	local map, x, y = PlayerPlace()
	if not (map and token) then
		print(PREFIX .. "trainer here: your position cannot be read here.")
		return
	end
	local name = UnitExists and UnitExists("target") and UnitName("target") or nil
	local npc
	local guid = name and UnitGUID and UnitGUID("target")
	if type(guid) == "string" and not (issecretvalue and issecretvalue(guid)) then
		npc = tonumber(guid:match("^Creature%-%d+%-%d+%-%d+%-%d+%-(%d+)"))
	end
	local list = Spots()
	list[token] = list[token] or {}
	table.insert(list[token], { map = map, x = math.floor(x * 100 + 0.5) / 100, y = math.floor(y * 100 + 0.5) / 100,
		name = name, npc = npc, at = time and time() or nil })
	print(PREFIX .. ("trainer here: saved %s at %.2f, %.2f on map %d for every %s. /mh trainer forget removes the last one.")
		:format(name or "this spot", x, y, map, token:lower()))
end

local function ForgetLast()
	local token = Token()
	local list = Spots()[token]
	if list and #list > 0 then
		local s = table.remove(list)
		print(PREFIX .. ("trainer: forgot %s (%.2f, %.2f)."):format(s.name or "that spot", s.x, s.y))
	else
		print(PREFIX .. "trainer: you have not saved a trainer place for this class.")
	end
end

local function Check()
	local level = UnitLevel("player")
	local r = Compute(level)
	print(PREFIX .. ("trainer check: class %s, level %d, data rows %d"):format(tostring(r.token), level, r.data))
	print(("  known %d, learn now %d (%s), needs something first %d, next level %s (%d), other race/faction/talent %d")
		:format(r.known, #r.now, Money(r.total), #r.needs, tostring(r.nextLevel), #r.next, r.other))
	print(("  opens by itself at level-up: %s (/mh trainer auto on|off)"):format(Settings().auto and "yes" or "no"))
	if r.data == 0 then
		print("  no trainer data for this class: the window stays empty on purpose")
	end
	local yours, hn, list = 0, 0, 0
	for _, c in ipairs(Candidates(r.token)) do
		if c.src == "yours" then
			yours = yours + 1
		elseif c.src == "HandyNotes" then
			hn = hn + 1
		else
			list = list + 1
		end
	end
	print(("  trainer places: yours %d, HandyNotes %s, MH list %d"):format(yours,
		HandyNotesTrainers() and tostring(hn) or "not installed", list))
	local best, dist, _, why = Nearest(r.token)
	print("  nearest: " .. (best and ("%s, %s (%s)"):format(best.name or "?", Distance(dist), best.src) or why))
end

function ns.ForeverTrainerSlash(arg)
	arg = (arg or ""):lower()
	if arg == "check" then
		Check()
	elseif arg == "go" then
		ns.ForeverTrainerGo()
	elseif arg == "here" then
		RecordHere()
	elseif arg == "forget" then
		ForgetLast()
	elseif arg == "auto off" or arg == "auto on" then
		Settings().auto = (arg == "auto on")
		print(PREFIX .. "the trainer window " .. (Settings().auto and "opens by itself at level-up again." or
			"no longer opens by itself. The chat line stays; /mh trainer opens it."))
	elseif win and win:IsShown() then
		win:Hide()
	else
		ns.ShowForeverTrainer()
	end
end

-- Level-up: wait a moment (the new level settles), never pop up in combat.
local pendingLevel
local function OnLevel(level)
	if InCombatLockdown and InCombatLockdown() then
		pendingLevel = level -- fought straight after the ding: PLAYER_REGEN_ENABLED tries again
		return
	end
	local r = Compute(level)
	-- Rob, 7 Nov 2026 ("Ja, alleen nieuw"): the window opens by itself only when THIS level brings
	-- something new. Spells left over from an earlier level (not trained yet) get a chat line, not the window again.
	local new = 0
	for _, e in ipairs(r.now) do
		if e.l == level then
			new = new + 1
		end
	end
	if new > 0 then
		print(PREFIX .. ("level %d: %d new at your trainer, %d to learn in all (%s). /mh trainer shows them with their keys.")
			:format(level, new, #r.now, Money(r.total)))
		if Settings().auto then
			ns.ShowForeverTrainer(level)
		end
	elseif #r.now > 0 then
		print(PREFIX .. ("level %d: nothing new, still %d to learn at your trainer (%s). /mh trainer shows them.")
			:format(level, #r.now, Money(r.total)))
	elseif r.nextLevel then
		print(PREFIX .. ("level %d: nothing new at your trainer. Next: level %d (%d)."):format(level, r.nextLevel, #r.next))
	end
end

ns.ForeverTrainerOnLevel = OnLevel -- the offline check calls it

local ev = CreateFrame("Frame")
ev:RegisterEvent("PLAYER_LEVEL_UP")
ev:RegisterEvent("PLAYER_REGEN_ENABLED")
ev:SetScript("OnEvent", function(_, event, level)
	if event == "PLAYER_LEVEL_UP" then
		pendingLevel = tonumber(level) or UnitLevel("player")
		if InCombatLockdown and InCombatLockdown() then
			return
		end
	elseif not pendingLevel then
		return
	end
	local lv = pendingLevel
	pendingLevel = nil
	if C_Timer and C_Timer.After then
		C_Timer.After(2, function()
			OnLevel(lv)
		end)
	else
		OnLevel(lv)
	end
end)
