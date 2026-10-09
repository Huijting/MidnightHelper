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

--- Swaps: a busy spell on a harder key, and a quiet one (a third or less) on an easier key.
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

local function PrintReport()
	local p = Prefix()
	local bucket, spec = Bucket(false)
	if not ns.IsKeyPressesEnabled() then
		print(("%s %s"):format(p, ns:L("PRESSES_IS_OFF")))
	end
	if not bucket or not next(bucket.spells) then
		print(("%s %s"):format(p, ns:L("PRESSES_NONE")))
		return
	end
	local specName
	if spec and GetSpecializationInfoByID then
		local ok, _, n = pcall(GetSpecializationInfoByID, spec)
		specName = ok and type(n) == "string" and n or nil
	end
	specName = specName or tostring(spec)
	print(("%s " .. ns:L("PRESSES_HEAD")):format(p, specName or "?", bucket.fights or 0))
	local rows, shown = Rows(bucket), 0
	for _, r in ipairs(rows) do
		if shown >= MAX_ROWS then
			break
		end
		if r.kind == "key" then
			shown = shown + 1
			print(("   %d. %s  %dx  [%s] %s"):format(shown, SpellName(r.id), r.n, r.short, Label(r.score)))
		elseif r.kind == "nokey" then
			shown = shown + 1
			print(("   %d. %s  %dx  |cff9d9d9d%s|r"):format(shown, SpellName(r.id), r.n, ns:L("PRESSES_NOKEY")))
		end
	end
	local swaps = Swaps(rows)
	if #swaps == 0 then
		print(("%s %s"):format(p, ns:L("PRESSES_NOSWAP")))
	else
		for _, s in ipairs(swaps) do
			print(("%s " .. ns:L("PRESSES_SWAP")):format(p,
				SpellName(s.busy.id), s.busy.n, s.busy.short, SpellName(s.quiet.id), s.quiet.n, s.quiet.short))
		end
		print(("   |cff9d9d9d%s|r"):format(ns:L("PRESSES_FEW")))
	end
	print(("   |cff9d9d9d%s|r"):format(ns:L("PRESSES_RULE")))
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
	else
		PrintReport()
	end
end

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_REGEN_DISABLED")
f:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "player")
f:SetScript("OnEvent", function(_, event, _, _, spellID)
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
