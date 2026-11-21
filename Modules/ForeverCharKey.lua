local _, ns = ...

--[[
	ForeverCharKey.lua — WoW Forever: one key per character for saved data, the player's GUID.
	Rob, 21 Nov 2026 (via sparring), verbatim: "A" — on: the player GUID as the key, through one shared function for all
	eight modules; characters with a unique first name take their old data along; every "Ima" gets a copy of the shared
	Ima data at its first login; /mh shows per module which key it used.

	Why (GEMETEN in Rob's Forever SavedVariables, written 20 Nov 22:23, after Blizzard's Forever hotfix of 20 Nov):
	GetRealmName() and GetNormalizedRealmName() return "" (foreverNameProbe.realm / normRealm), so every "Name-Realm" key
	became "Name-". And before that already, every character with the same first name on one realm shared one key: Rob has
	several "Ima" characters (Ima Pallie, Ima Lockie, …), all "Ima-CAMWOW EU4 Realm 10 RP". The player GUID is unique per
	character; ForeverChars, ForeverDirection, ForeverDoNow and ForeverLayoutCarry already use it. That it stays the same
	is AFGELEID: Blizzard's notice names only creature, vehicle, pet and game object GUIDs, and the SavedVariables written
	after the hotfix hold player GUIDs in the old form only.

	Migration, once per table and character, ONLY COPYING (the old keys stay as a safety net; remove them after 28 Nov
	2026 at the earliest): the old "Name-<realm>" entry and the post-hotfix "Name-" entry of the same first name. Two
	or more different realms for one name = ambiguous: only the "Name-" entry is used, and the log says so.
	Default merge: tables recursively, numbers the highest, anything else the newer ("Name-") value. `whole` = take the
	newer entry as one piece (a place or a gear set must never be mixed from two).
	Modules may pass copy = false (KeyBlock: its codes are rebuilt at every login from the bars; SlotOwnership: its own
	comment says guessing which character wrote a record is the very fault it fixes).
	Retail: this file does not load (Forever toc only); every caller falls back to its old key.
	/mh charkey prints per module the key, the old key and what was copied.
]]

if not ns.IS_FOREVER then
	return
end

local log = {} -- label -> { key, legacy, note }
local checked = {}

local function Secret(v)
	return issecretvalue and issecretvalue(v)
end

local function Copy(v)
	if type(v) ~= "table" then
		return v
	end
	local out = {}
	for k, x in pairs(v) do
		out[k] = Copy(x)
	end
	return out
end

local function Merge(dst, src)
	for k, v in pairs(src) do
		local d = dst[k]
		if type(v) == "table" and type(d) == "table" then
			Merge(d, v)
		elseif type(v) == "number" and type(d) == "number" then
			dst[k] = math.max(d, v)
		else
			dst[k] = Copy(v)
		end
	end
end

local function Migrate(label, t, key, name, whole)
	local tag = tostring(t) .. "|" .. key
	if checked[tag] then
		return
	end
	checked[tag] = true
	if t[key] ~= nil then
		-- 21 Nov 2026 (Rob's test via sparring: "already there" read as "nothing copied"): say WHEN it was copied.
		local m = ns.db and type(ns.db.charKeyMigrated) == "table" and ns.db.charKeyMigrated[label .. "|" .. key]
		if type(m) == "table" then
			local when = (date and m.at and m.at > 0) and date("%d %b %H:%M", m.at) or "?"
			local src = {}
			if m.from then
				src[#src + 1] = '"' .. m.from .. '"'
			end
			if m.fromNew then
				src[#src + 1] = '"' .. m.fromNew .. '"'
			end
			return ("copied earlier (%s) from %s"):format(when, table.concat(src, " + "))
		end
		return "already there (made by this character, nothing to copy)"
	end
	local prefix = name .. "-"
	local olds, newer = {}, nil
	for k in pairs(t) do
		if type(k) == "string" and k:sub(1, #prefix) == prefix then
			local realm = k:sub(#prefix + 1)
			if realm == "" then
				newer = k
			elseif not realm:find("^%d") and not realm:find("[:%-]") then
				olds[#olds + 1] = k
			end
		end
	end
	local old = olds[1]
	local note
	if #olds > 1 then
		old = nil
		note = ("%d old realms for %s: ambiguous, old data not copied"):format(#olds, name)
	end
	if not old and not newer then
		note = note or "nothing old to copy"
		return note
	end
	local result
	if whole then
		result = Copy(t[newer or old])
	else
		result = (old and type(t[old]) == "table") and Copy(t[old]) or {}
		if newer and type(t[newer]) == "table" then
			Merge(result, t[newer])
		elseif newer then
			result = Copy(t[newer])
		end
	end
	t[key] = result
	local from = {}
	if old and not (whole and newer) then
		from[#from + 1] = '"' .. old .. '"'
	end
	if newer then
		from[#from + 1] = '"' .. newer .. '"'
	end
	note = (note and (note .. "; ") or "") .. "copied from " .. table.concat(from, " + ")
	ns.db = ns.db or {}
	ns.db.charKeyMigrated = type(ns.db.charKeyMigrated) == "table" and ns.db.charKeyMigrated or {}
	ns.db.charKeyMigrated[label .. "|" .. key] = { from = old, fromNew = newer, at = time and time() or 0 }
	return note
end

--- The key for this character's entry in `tbl`. `legacy` = the module's old key (returned when no GUID can be read).
--- opts: { copy = false, whole = true }.
function ns.ForeverCharKey(label, legacy, tbl, opts)
	opts = opts or {}
	local g = UnitGUID and UnitGUID("player")
	if type(g) ~= "string" or Secret(g) or not g:find("^Player%-") then
		log[label] = { key = legacy, legacy = legacy, note = "no player GUID readable: old key used" }
		return legacy
	end
	local e = log[label] or {}
	log[label] = e
	e.key, e.legacy = g, legacy
	if opts.copy ~= false and type(tbl) == "table" then
		local name = UnitName and UnitName("player")
		if type(name) == "string" and not Secret(name) and name ~= "" then
			local ok, note = pcall(Migrate, label, tbl, g, name, opts.whole)
			if not ok then
				e.note = "error: " .. tostring(note)
			elseif note then
				e.note = note
			end
		end
	elseif opts.copy == false then
		e.note = "no copy on purpose"
	end
	return g
end

function ns.ForeverCharKeySlash()
	print("|cffffcc00Midnight Helper:|r per-character keys (Forever: your player GUID; old keys are kept):")
	local n = 0
	for label, e in pairs(log) do
		n = n + 1
		print(("   %s: key %s · old key %s · %s"):format(label, tostring(e.key), tostring(e.legacy), e.note or "already there"))
	end
	if n == 0 then
		print("   no module asked for its key yet this session.")
	end
	local m = 0
	for _ in pairs((ns.db and ns.db.charKeyMigrated) or {}) do
		m = m + 1
	end
	print(("   copies made so far (all characters): %d"):format(m))
end
