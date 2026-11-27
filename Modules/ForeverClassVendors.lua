local _, ns = ...

--[[
	ForeverClassVendors.lua — WoW Forever: class reagents and ammunition — what you need, how many you have, and the
	nearest seller with the arrow.
	Rob, 27 Nov 2026, via Sparring 27-11, verbatim: "nr 4 ja" (idea 4 in docs/IDEEEN.md; Pathfinder Forever is All
	Rights Reserved: only the idea, own code; MMOBoom is not a source).

	Data: ForeverClassVendorData.lua (tools/forever_classvendors.py): which reagent each class spell uses and from which
	level (Blizzard DB2, GEMETEN; 0 of 23 spells off), the ammo per level (DB2), and the vendors (Zygor's lists).
	  Reagents: only for a spell you KNOW (IsPlayerSpell); for ranked spells (Rebirth, Gift of the Wild) the highest
	    rank you know decides the item. 0 in your bags = a to-do in Do this now; fewer than LOW = a tip.
	  Ammo: only with a bow or crossbow (arrows) or a gun (bullets) in your ranged slot. The best ammo for your level
	    (ItemSparse RequiredLevel). Fewer than one stack (200, ItemSparse VendorStackCount) = a tip, none = a to-do.
	    Whether Forever really uses up ammo: Zygor's own guide says so (GEMETEN in Zygor), in the game NOT measured.
	  Sellers: Find / /mh vendor reagent | arrows | bullets (a rogue's Flash Powder: /mh vendor thief, the same vendors,
	    GEMETEN by mh-research in QuestieDB: 18 of 18).
	LOW = 5 is MH's own choice (AFGELEID), not a game number.
	Switch: Quiet helpers "Class reagents and ammo in Do this now" / /mh vendor reagents on|off (default on).
	/mh vendor check prints the decision and the reason (a module that can stay quiet needs that, CLAUDE.md).
]]

if not ns.IS_FOREVER then
	return
end

local LOW = 5
local STACK = 200
local lastWhy = "not checked yet"

function ns.IsForeverClassVendLineOn()
	return not (type(ns.db) == "table" and ns.db.foreverClassVendLine == false)
end

function ns.SetForeverClassVendLine(on)
	ns.db = ns.db or {}
	if on then
		ns.db.foreverClassVendLine = nil -- on = the default
	else
		ns.db.foreverClassVendLine = false
	end
	if ns.ForeverDoNowUpdate then
		pcall(ns.ForeverDoNowUpdate)
	end
end

local function Readable(v)
	return v ~= nil and not (issecretvalue and issecretvalue(v))
end

local function Count(id)
	local f = (C_Item and C_Item.GetItemCount) or GetItemCount
	if not f then
		return 0
	end
	local ok, n = pcall(f, id)
	return (ok and Readable(n) and tonumber(n)) or 0
end

local function Knows(spell)
	if IsPlayerSpell then
		local ok, k = pcall(IsPlayerSpell, spell)
		if ok and Readable(k) and k then
			return true
		end
	end
	if IsSpellKnown then
		local ok, k = pcall(IsSpellKnown, spell)
		return ok and Readable(k) and k == true
	end
	return false
end

local function ItemName(id)
	if C_Item and C_Item.GetItemNameByID then
		local ok, n = pcall(C_Item.GetItemNameByID, id)
		if ok and type(n) == "string" and n ~= "" and Readable(n) then
			return n
		end
	end
	if C_Item and C_Item.RequestLoadItemDataByID then
		pcall(C_Item.RequestLoadItemDataByID, id)
	end
	return nil
end

local function SpellName(id)
	if C_Spell and C_Spell.GetSpellName then
		local ok, n = pcall(C_Spell.GetSpellName, id)
		if ok and type(n) == "string" and n ~= "" and Readable(n) then
			return n
		end
	end
	if GetSpellInfo then
		local ok, n = pcall(GetSpellInfo, id)
		if ok and type(n) == "string" and n ~= "" and Readable(n) then
			return n
		end
	end
	return "#" .. tostring(id)
end

--- "arrows", "bullets" or nil: what your ranged weapon shoots (slot 18; bow 2 / crossbow 18 = arrows, gun 3 = bullets).
function ns.ForeverAmmoKind()
	if not GetInventoryItemID then
		return nil
	end
	local ok, id = pcall(GetInventoryItemID, "player", 18)
	if not (ok and type(id) == "number" and Readable(id)) then
		return nil
	end
	local f = (C_Item and C_Item.GetItemInfoInstant) or GetItemInfoInstant
	if not f then
		return nil
	end
	local okI, _, _, _, _, _, class, sub = pcall(f, id)
	if not okI or class ~= 2 then
		return nil
	end
	if sub == 2 or sub == 18 then
		return "arrows"
	elseif sub == 3 then
		return "bullets"
	end
	return nil
end

--- The tier (1-4) of the best ammo your level can use, and that item.
function ns.ForeverAmmoTier(kind)
	local list = ns.FOREVER_AMMO and ns.FOREVER_AMMO[kind or ns.ForeverAmmoKind() or "arrows"] or {}
	local level = (UnitLevel and UnitLevel("player")) or 1
	local tier, item = 1, list[1] and list[1][1]
	for i, row in ipairs(list) do
		if level >= row[2] then
			tier, item = i, row[1]
		end
	end
	return tier, item
end

--- The nearest seller of a Find category ("reagent", "arrows", "bullets", "thief"): its Find row, or nil.
local function Nearest(key)
	if not ns.ForeverVendorFindRows then
		return nil
	end
	local ok, rows = pcall(ns.ForeverVendorFindRows, key)
	return ok and type(rows) == "table" and rows[1] or nil
end

local function SellerText(row)
	if not row then
		return ns:L("FCVEND_NO_SELLER")
	end
	return ns:L("FCVEND_SELLER_FMT"):format(row.name or "?", row.zone or "?",
		row.dist and (ns.ForeverTrainerDistance and ns.ForeverTrainerDistance(row.dist) or ("%d yd"):format(row.dist))
		or ns:L("FVEND_OTHER_CONT"))
end

--- The reagents your known spells need: { item, spell, have } per item (one per item, the first spell that needs it).
local function Needs()
	local _, token = UnitClass("player")
	local out, seen = {}, {}
	for _, g in ipairs((ns.FOREVER_CLASS_REAGENTS or {})[token or ""] or {}) do
		local pick
		for _, row in ipairs(g) do
			if Knows(row[1]) then
				pick = row
				if g.mode ~= "rank" then
					break
				end
			end
		end
		if pick and not seen[pick[2]] then
			seen[pick[2]] = true
			out[#out + 1] = { item = pick[2], spell = pick[1], have = Count(pick[2]) }
		end
	end
	return out, token
end

--- For Do this now: { text, key, now = true for a to-do } per line. key = the Find category of the seller.
function ns.ForeverClassVendorLines()
	if not ns.IsForeverClassVendLineOn() then
		lastWhy = "switched off (/mh vendor reagents on)"
		return {}
	end
	local out, why = {}, {}
	local needs, token = Needs()
	local key = (token == "ROGUE") and "thief" or "reagent"
	local seller
	for _, n in ipairs(needs) do
		local name = ItemName(n.item) or ("#" .. n.item)
		if n.have == 0 then
			seller = seller or Nearest(key)
			out[#out + 1] = { text = ns:L("FCVEND_NONE_FMT"):format(name, SpellName(n.spell), SellerText(seller),
				"/mh vendor " .. key), key = key, now = true }
		elseif n.have < LOW then
			seller = seller or Nearest(key)
			out[#out + 1] = { text = ns:L("FCVEND_LOW_FMT"):format(n.have, name, SellerText(seller), "/mh vendor " .. key),
				key = key }
		end
		why[#why + 1] = ("%s %d"):format(name, n.have)
	end
	local kind = ns.ForeverAmmoKind()
	if kind then
		local list = ns.FOREVER_AMMO and ns.FOREVER_AMMO[kind] or {}
		local have = 0
		for _, row in ipairs(list) do
			have = have + Count(row[1])
		end
		local _, best = ns.ForeverAmmoTier(kind)
		local name = best and (ItemName(best) or ("#" .. best)) or "?"
		if have < STACK then
			local row = Nearest(kind)
			out[#out + 1] = { text = ns:L(have == 0 and "FCVEND_AMMO_NONE_FMT" or "FCVEND_AMMO_LOW_FMT"):format(have, name,
				SellerText(row), "/mh vendor " .. kind), key = kind, now = have == 0 }
		end
		why[#why + 1] = ("%s: %d (best for your level: %s)"):format(kind, have, name)
	else
		why[#why + 1] = "no bow, crossbow or gun in your ranged slot"
	end
	lastWhy = (#needs == 0 and "no class reagent for a spell you know; " or "") .. table.concat(why, ", ")
		.. ("; %d line(s)"):format(#out)
	return out
end

function ns.ForeverClassVendorWhy()
	pcall(ns.ForeverClassVendorLines)
	return lastWhy
end

--------------------------------------------------------------------------------
-- 27 Nov 2026, the alert (Rob via Sparring 27-11: "… dat je een melding krijgt als je de laatste 50 aan gaat beginnen
-- of iets" → on the plan: "ja"): when your ammo drops to the limit (50) or a reagent for a spell you know to its limit
-- (3), ONE big message in the middle of the screen with a sound — ns.FireAccessibleAlert, the same door as every MH
-- alert (its own cooldown included; a refused alert is tried again when that cooldown is over). Not again for that
-- thing until you were above the limit once more. In a fight it waits until the fight is over. Limits adjustable and
-- the alert has its own switch (players choose): Quiet helpers "Alert when ammo or reagents run out",
-- /mh vendor alert on|off, /mh vendor alert ammo <0-1000>, /mh vendor alert reagent <0-20>.
--------------------------------------------------------------------------------
local PREFIX = "|cffffcc00Midnight Helper:|r "
local alertWhy = "not checked yet"
local warned, pending = {}, false

local function AlertSettings()
	ns.db = ns.db or {}
	local s = type(ns.db.foreverRunOut) == "table" and ns.db.foreverRunOut or {}
	ns.db.foreverRunOut = s
	if s.on == nil then s.on = true end
	if s.ammoAt == nil then s.ammoAt = 50 end
	if s.reagentAt == nil then s.reagentAt = 3 end
	return s
end

local function InFight()
	return (InCombatLockdown and InCombatLockdown()) or (UnitAffectingCombat and UnitAffectingCombat("player") == true)
end

local CheckRunOut
--- Everything at or under its limit that was not announced yet: { key, text, seller key }.
local function Due(s)
	local out = {}
	local kind = ns.ForeverAmmoKind()
	if kind then
		local have = 0
		for _, row in ipairs((ns.FOREVER_AMMO or {})[kind] or {}) do
			have = have + Count(row[1])
		end
		if have > s.ammoAt then
			warned.ammo = nil
		elseif not warned.ammo then
			out[#out + 1] = { key = "ammo", text = ns:L("FCVEND_ALERT_AMMO_FMT"):format(have), vend = kind }
		end
	end
	local needs, token = Needs()
	for _, n in ipairs(needs) do
		if n.have > s.reagentAt then
			warned[n.item] = nil
		elseif not warned[n.item] then
			out[#out + 1] = { key = n.item, text = ns:L("FCVEND_ALERT_REAGENT_FMT"):format(ItemName(n.item) or ("#" .. n.item),
				n.have), vend = (token == "ROGUE") and "thief" or "reagent" }
		end
	end
	return out
end

CheckRunOut = function()
	local s = AlertSettings()
	if not s.on then
		alertWhy = "switched off (/mh vendor alert on)"
		return
	end
	local due = Due(s)
	if #due == 0 then
		pending = false
		alertWhy = ("nothing at or under the limits (ammo %d, reagent %d)"):format(s.ammoAt, s.reagentAt)
		return
	end
	if InFight() then
		pending = true -- PLAYER_REGEN_ENABLED tries again
		alertWhy = ("%d to tell, in a fight: waits until it is over"):format(#due)
		return
	end
	local parts = {}
	for _, d in ipairs(due) do
		parts[#parts + 1] = d.text
	end
	local big = table.concat(parts, "  ·  ")
	local fired, wait = false, nil
	if ns.FireAccessibleAlert then
		fired, wait = ns.FireAccessibleAlert(big, true, 6)
	end
	if not fired then
		pending = true
		alertWhy = ("another MH alert just showed: tries again in %.0f s"):format(wait or 2)
		if C_Timer and C_Timer.After then
			C_Timer.After((wait or 2) + 0.2, function()
				pcall(CheckRunOut)
			end)
		end
		return
	end
	pending = false
	for _, d in ipairs(due) do
		warned[d.key] = true
	end
	print(PREFIX .. big .. "; " .. SellerText(Nearest(due[1].vend)) .. ". |cff888888" .. ns:L("FCVEND_ALERT_OFF_HINT") .. "|r")
	alertWhy = ("told you: %s"):format(big)
end

function ns.IsForeverRunOutAlertOn()
	return AlertSettings().on
end

function ns.SetForeverRunOutAlert(on)
	AlertSettings().on = on and true or false
	warned = {}
end

--- /mh vendor alert [on | off | ammo <n> | reagent <n>]; true = it was an alert command.
function ns.ForeverRunOutSlash(arg)
	local s = AlertSettings()
	if arg == "alert on" or arg == "alert off" then
		ns.SetForeverRunOutAlert(arg == "alert on")
		print(PREFIX .. ns:L(arg == "alert on" and "FCVEND_ALERT_ON" or "FCVEND_ALERT_OFF"))
		return true
	end
	local what, n = (arg or ""):match("^alert (%a+) (%d+)$")
	if what == "ammo" or what == "reagent" then
		n = tonumber(n)
		if what == "ammo" then
			s.ammoAt = math.max(0, math.min(1000, n))
		else
			s.reagentAt = math.max(0, math.min(20, n))
		end
		warned = {}
		print(PREFIX .. ns:L("FCVEND_ALERT_AT_FMT"):format(s.ammoAt, s.reagentAt))
		return true
	end
	if arg == "alert" then
		print(PREFIX .. ("run-out alert: %s, ammo at %d, reagent at %d (/mh vendor alert on||off, /mh vendor alert ammo <n>, /mh vendor alert reagent <n>)")
			:format(s.on and "on" or "off", s.ammoAt, s.reagentAt))
		print("  last decision: " .. alertWhy .. (pending and " (waiting)" or ""))
		return true
	end
	return false
end

function ns.ForeverRunOutWhy()
	return alertWhy
end
ns.ForeverRunOutCheck = function() -- for the offline check: the same function the events call
	return CheckRunOut()
end

local ev = CreateFrame("Frame")
for _, e in ipairs({ "BAG_UPDATE_DELAYED", "PLAYER_REGEN_ENABLED", "PLAYER_ENTERING_WORLD", "PLAYER_EQUIPMENT_CHANGED",
	"SPELLS_CHANGED" }) do
	pcall(ev.RegisterEvent, ev, e)
end
ev:SetScript("OnEvent", function(self, event)
	if event == "PLAYER_REGEN_ENABLED" and not pending then
		return
	end
	if self._busy then
		return
	end
	self._busy = true
	-- At login a few seconds later (bags and spells are read by then); otherwise half a second, to fold a burst of events.
	C_Timer.After(event == "PLAYER_ENTERING_WORLD" and 8 or 0.5, function()
		self._busy = nil
		pcall(CheckRunOut)
	end)
end)
