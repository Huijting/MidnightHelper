local _, ns = ...

--[[
	Midnight Helper — 12.1.5 PTR probe (dev tool).

	/mh ptr

	Four probes already exist and this one deliberately does not repeat them:
	`/mh api12` (secret-safe helpers), `/mh auras` + `/mh aurainst` (the aura route),
	`/mh auradump` (the player's own auras), `/mh roleset`. This one covers what 12.1.5
	adds on top, plus the two walls we were told to re-measure "at 12.2" and can now
	re-measure eighteen days early because the PTR client exists.

	🔴 EVERY MEASUREMENT CARRIES ITS OWN CLIENT. Learned the hard way on 4 Sep 2026:
	two `/dump` results arrived and neither of us could say which client had produced
	them, because there are two PTR installs on this machine at two different patches
	(_ptr_ = 12.1.0.69587, _xptr_ = 12.1.5.69594). An unattributed measurement is not a
	measurement. `out.client` is written first, from the client itself, and every read
	of this data should quote it.

	⚠️ "COULD NOT MEASURE" IS NOT "ABSENT". The cast probe needs a target that is
	actually casting; with no target it says so instead of reporting an empty result
	that reads like a finding. Same trap as the silence-is-not-absence rule, and this
	file is where it would be easiest to fall into.

	(And no wiki-style double brackets in this comment: they close the block comment
	early. That cost one failed syntax check writing this very file.)

	Nothing here is called with real data beyond existence, type and secrecy.
]]

local PREFIX = "|cffffcc00Midnight Helper|r"

--- Values the client may hand back as secrets. Checked BEFORE tostring(), because
--- stringifying a secret is exactly the thing 12.x does not want us doing.
--- @param v any
--- @return string
local function Describe(v)
	local isSecret = _G.issecretvalue
	if isSecret then
		local ok, secret = pcall(isSecret, v)
		if ok and secret then
			return "SECRET"
		end
	end
	local t = type(v)
	if t == "nil" then
		return "nil"
	elseif t == "number" or t == "boolean" then
		return t .. " " .. tostring(v)
	elseif t == "string" then
		if #v > 60 then
			return "string(" .. #v .. ") " .. v:sub(1, 60) .. "..."
		end
		return "string " .. v
	end
	return t
end

--- Capture a call's results WITH their count. `#{...}` is wrong here: a return list
--- ending in nil (which is most of `UnitCastingInfo` when nothing is being cast) loses
--- its length, and the probe would then report fewer slots than the signature has.
--- @return number, table
local function PackResults(...)
	return select("#", ...), { ... }
end

--- Call `fn` and describe every return slot positionally, without assuming how many
--- there are. The count matters: a signature that grows or shrinks between patches is
--- itself the finding, and a fixed list of names would hide it.
--- @return table
local function CallAndDescribe(fn, ...)
	local n, packed = PackResults(pcall(fn, ...))
	if not packed[1] then
		return { status = "errored", err = tostring(packed[2]) }
	end
	local slots = {}
	for i = 2, n do
		slots[#slots + 1] = ("[%d] %s"):format(i - 1, Describe(packed[i]))
	end
	return { status = "ok", count = n - 1, slots = slots }
end

--- @return table
local function ProbeClient()
	local version, build, date, tocversion = GetBuildInfo()
	return {
		version = tostring(version),
		build = tostring(build),
		buildDate = tostring(date),
		interface = tonumber(tocversion) or tocversion,
		mhVersion = tostring(C_AddOns and C_AddOns.GetAddOnMetadata
			and C_AddOns.GetAddOnMetadata("MidnightHelper", "Version") or "?"),
		realm = tostring(GetRealmName and GetRealmName() or "?"),
		measuredAt = (_G.date and _G.date("%Y-%m-%d %H:%M:%S")) or "?",
	}
end

--- The fifteen FrameXML globals 12.1.5 moves to native code. Blizzard's own blue post
--- says "aliases for the existing names have been retained to prevent addon breakage",
--- but the wiki's consolidated table lists `StringContains` as removed WITHOUT a
--- matching addition — a contradiction inside one source. MH uses none of them (0 hits,
--- measured 4 Sep), so this settles a fact rather than guarding our code.
local MOVED_GLOBALS = {
	"Clamp", "CountTable", "GetKeysArray", "GetValuesArray", "Lerp",
	"RoundToSignificantDigits", "Round", "Saturate", "Sign", "StringContains",
	"TableIsEmpty", "tContains", "tDeleteItem", "tIndexOf", "tUnorderedRemove",
}

--- The ten Blizzard_Deprecated* addons 12.1.5 removes. The one that mattered to us was
--- ItemSocketInfo, because `SocketInventoryItem` is a bare global we call in
--- GearEnchantCheck and it is guarded in a way that would fail SILENTLY — a button that
--- does nothing rather than an error. ✅ Measured present on 12.1.5.69594 on 4 Sep; kept
--- so the answer can be re-checked cheaply after every PTR build.
local DEPRECATED_ADDONS = {
	"Blizzard_DeprecatedCurrencyScript", "Blizzard_DeprecatedGlue",
	"Blizzard_DeprecatedItemScript", "Blizzard_DeprecatedItemSocketInfo",
	"Blizzard_DeprecatedLFG", "Blizzard_DeprecatedPetInfo",
	"Blizzard_DeprecatedPvpScript", "Blizzard_DeprecatedSoundScript",
	"Blizzard_DeprecatedTradeInfo", "Blizzard_DeprecatedWorldElapsedTimerTypes",
	-- Not on the removal list, but we fall back to the old global SendChatMessage
	-- through it (Comms.lua:72-75), so its absence would be worth knowing about.
	"Blizzard_DeprecatedChatInfo",
}

--- Namespaces and helpers 12.1.5 adds. None are in use; this records what became
--- available, so a future feature is chosen from what exists rather than from a guess.
local ADDED_GLOBALS = {
	"C_Weather", "C_Intl", "CreateFrameWithOptions", "TimedSignalMap",
	"GetScriptBucketThrottleLimits", "C_TableUtil",
	-- Not additions: the two names on the line where Zygor 9.6 dies on 12.1.5
	-- (PetBattle.lua:27). I claimed that morning that `UIModeUtil.IsModeActive` had been
	-- removed; the first run measured it present, so that claim was wrong and something
	-- else on that line is nil. Listed here so the next run answers it instead of me
	-- guessing twice. It is not our bug either way -- MH uses neither name.
	"IsFrameLockActive", "ToggleCollectionsJournal",
	-- Our own fallback path, worth one line while we are here.
	"SocketInventoryItem", "SendChatMessage",
}

--- 🔴 THE BREAK THAT ACTUALLY HAPPENED TODAY, and the reason this list is here rather
--- than in a note. Zygor 9.6 threw "attempt to call a nil value" on 12.1.5 at
--- PetBattle.lua:27, which reads `UIModeUtil and UIModeUtil.IsModeActive("PetBattle")`
--- — it checks that the TABLE exists but not the FUNCTION inside it. So the table
--- survives and a member of it did not. MH uses neither name (0 hits, positive control
--- in the same run), but "which members does it still have" is the shape of question
--- this probe should answer for any table, and this is a live example of why.
local WATCH_TABLES = { "UIModeUtil", "C_UnitAuras", "PixelUtil" }

--- @return table
local function ProbeGlobals()
	local out = { moved = {}, added = {}, addons = {}, tables = {} }

	for _, name in ipairs(MOVED_GLOBALS) do
		out.moved[name] = (_G[name] == nil) and "absent" or type(_G[name])
	end
	-- The blue post says the new home is `string.contains`.
	out.moved["string.contains"] = (string.contains == nil) and "absent" or type(string.contains)

	for _, name in ipairs(ADDED_GLOBALS) do
		out.added[name] = (_G[name] == nil) and "absent" or type(_G[name])
	end

	for _, name in ipairs(DEPRECATED_ADDONS) do
		local info = "unknown"
		if C_AddOns and C_AddOns.GetAddOnInfo then
			local ok, _, title = pcall(C_AddOns.GetAddOnInfo, name)
			if not ok then
				info = "query errored"
			elseif title == nil then
				info = "not installed"
			else
				info = "installed"
			end
		end
		out.addons[name] = info
	end

	-- Enumerate rather than ask for names we invented. A table that exists but has lost
	-- a member is the failure mode Zygor hit; only a listing shows that.
	for _, name in ipairs(WATCH_TABLES) do
		local t = _G[name]
		if type(t) ~= "table" then
			out.tables[name] = { status = (t == nil) and "absent" or type(t) }
		else
			local members = {}
			local ok = pcall(function()
				for k, v in pairs(t) do
					members[#members + 1] = tostring(k) .. " (" .. type(v) .. ")"
				end
			end)
			table.sort(members)
			out.tables[name] = {
				status = ok and "table" or "table (could not iterate)",
				count = #members,
				members = members,
			}
		end
	end

	return out
end

--- ⚠️ RE-MEASURING THE CAST WALL. Measured 18 Aug 2026 on live 12.1: for an enemy cast,
--- the spell id, npc id, icon and both timestamps all came back secret, leaving only
--- castBarID (slot 10) readable — which proves THAT something is being cast and nothing
--- more. The note said "build nothing on this, re-measure at 12.2". 12.1.5 changes how
--- castbar IDs work (they are now unique per unit token, and the token's CASE matters),
--- so it is worth asking again eighteen days early.
---
--- Needs a target that is genuinely casting. With no such target this reports why it
--- could not measure, never an empty result that would read like "nothing is secret".
--- @return table
local function ProbeCastWall()
	local out = {}
	for _, unit in ipairs({ "target", "focus", "player" }) do
		local entry = { unit = unit }
		if not UnitExists(unit) then
			entry.status = "could not measure: no " .. unit
		else
			entry.name = UnitName and Describe(UnitName(unit)) or "?"
			for _, call in ipairs({ "UnitCastingInfo", "UnitChannelInfo" }) do
				if type(_G[call]) ~= "function" then
					entry[call] = { status = "no such function" }
				else
					local res = CallAndDescribe(_G[call], unit)
					-- A unit that is not casting returns all-nil; that is not a
					-- measurement of secrecy, so say so.
					if res.status == "ok" then
						local anyValue = false
						for _, s in ipairs(res.slots) do
							if not s:find("] nil", 1, true) then
								anyValue = true
								break
							end
						end
						if not anyValue then
							res.status = "could not measure: not casting right now"
						end
					end
					entry[call] = res
				end
			end
		end
		out[#out + 1] = entry
	end
	return out
end

--- 12.1.5 adds `C_UnitAuras.GetAuraCasterGUID`. Since 12.1 another unit's auras are a
--- secret vector, so the question is not whether the new call exists (it does — measured
--- on 12.1.5.69594) but whether we can reach an aura instance id to hand it, and whether
--- what comes back is readable. Both halves are reported separately: a readable caster
--- behind an unreachable id would still be useless to us.
---
--- 🔴 THE UNIT THAT MATTERS IS NOT `target`. Measured 4 Sep: the first run answered
--- fully for "player" and "could not measure" for everything else, which is a true
--- result and a useless one — the player's own auras were never secret, so it tells us
--- nothing we did not know on 18 Aug. A dispel helper reads a PARTY MEMBER's debuffs,
--- so `party1`-`party4` are the real question and `target` is only a convenient stand-in.
--- @return table
local function ProbeAuraCaster()
	local out = { calls = {}, units = {} }
	for _, fn in ipairs({ "GetAuraCasterGUID", "GetUnitAuraInstanceIDs", "GetUnitAuras",
		"GetAuraDataByAuraInstanceID", "GetAuraDataByIndex", "GetAuraDispelTypeColor",
		"GetUnitAuraBySpellID", "AuraIsPrivate", "DoesAuraHaveExpirationTime",
		"IsAuraFilteredOutByInstanceID", "AuraIsBigDefensive", "GetAuraSlots",
		"GetDebuffDataByIndex" }) do
		out.calls[fn] = (C_UnitAuras and C_UnitAuras[fn] == nil) and "absent"
			or (C_UnitAuras and type(C_UnitAuras[fn]) or "no C_UnitAuras")
	end

	if not C_UnitAuras then
		return out
	end

	--- ⚠️ `pet` and `targettarget` are here because of what the 09:51 run produced: a
	--- targeted Silvermoon Resident answered `table` with ZERO entries for both filters.
	--- That is not a measurement of secrecy — an empty list may well be an ordinary table
	--- on any unit, with the secret only appearing once there is something in it. We need
	--- a unit that genuinely CARRIES an aura, and a pet usually does.
	for _, unit in ipairs({ "player", "target", "targettarget", "pet",
		"party1", "party2", "focus" }) do
		local entry = { unit = unit }
		if not UnitExists(unit) then
			entry.status = "could not measure: no " .. unit
		else
			entry.isPlayer = UnitIsUnit and UnitIsUnit(unit, "player") or false
			-- HARMFUL is the filter a dispel helper actually needs; HELPFUL is kept
			-- alongside it because a difference between the two would itself be the
			-- finding (12.1 could restrict one and not the other).
			for _, filter in ipairs({ "HELPFUL", "HARMFUL" }) do
				local f = {}
				-- Route 1: the per-instance vector.
				if type(C_UnitAuras.GetUnitAuraInstanceIDs) == "function" then
					local ok, ids = pcall(C_UnitAuras.GetUnitAuraInstanceIDs, unit, filter)
					if not ok then
						f.instanceIDs = "errored: " .. tostring(ids)
					else
						f.instanceIDs = Describe(ids)
						if type(ids) == "table" then
							f.instanceCount = #ids
							local first = ids[1]
							if first ~= nil then
								f.firstID = Describe(first)
								if type(C_UnitAuras.GetAuraCasterGUID) == "function" then
									f.casterFromID =
										CallAndDescribe(C_UnitAuras.GetAuraCasterGUID, unit, first)
								end
								if type(C_UnitAuras.GetAuraDataByAuraInstanceID) == "function" then
									local okD, data = pcall(
										C_UnitAuras.GetAuraDataByAuraInstanceID, unit, first)
									f.dataByID = okD and Describe(data) or "errored"
									-- The fields a dispel helper needs to read by name.
									if okD and type(data) == "table" then
										local fields = {}
										for _, k in ipairs({ "spellId", "name", "dispelName",
											"icon", "isHarmful", "sourceUnit", "applications",
											"expirationTime", "isBossAura" }) do
											fields[k] = Describe(data[k])
										end
										f.dataFields = fields
									end
								end
							else
								f.note = "no auras of this kind on this unit right now"
							end
						end
					end
				end
				-- Route 2: the older index route, for comparison.
				if type(C_UnitAuras.GetAuraDataByIndex) == "function" then
					f.byIndex1 = CallAndDescribe(C_UnitAuras.GetAuraDataByIndex, unit, 1, filter)
				end
				entry[filter] = f
			end
			-- Blizzard's own dispel opinion, if it will answer about this unit.
			if type(C_UnitAuras.GetAuraDispelTypeColor) == "function" then
				entry.dispelTypeColor = CallAndDescribe(C_UnitAuras.GetAuraDispelTypeColor, unit, 1)
			end

			--- 🔴 THE CALL OUR SHIPPED DISPEL HELPER ACTUALLY USES, and the reason this
			--- block exists. Measured 10:12 on 12.1.5: once auras go secret, every read
			--- route above stops returning a secret and instead throws
			---   "Auras cannot be accessed when secret while tainted by 'MidnightHelper'"
			--- on player, target AND targettarget alike. `ns.AllyHasRemovableAura`
			--- (DispelHelper.lua:379) does not read aura DATA — it asks GetAuraSlots
			--- whether a HARMFUL|DISPELLABLE slot exists and looks only at whether a slot
			--- came back. If that survives the secret state, the dispel helper works
			--- exactly where it is needed and the whole data wall is beside the point.
			--- If it throws too, the feature is blocked and we should stop planning
			--- around it. Nothing else in this file answers that question.
			if type(C_UnitAuras.GetAuraSlots) == "function" then
				entry.slots = {
					harmfulDispellable =
						CallAndDescribe(C_UnitAuras.GetAuraSlots, unit, "HARMFUL|DISPELLABLE", 1),
					harmfulPlain =
						CallAndDescribe(C_UnitAuras.GetAuraSlots, unit, "HARMFUL", 1),
					helpfulDispellable =
						CallAndDescribe(C_UnitAuras.GetAuraSlots, unit, "HELPFUL|DISPELLABLE", 1),
				}
			end
			-- Same question for the two "does this exist" calls that take a spell id
			-- rather than handing back a data table.
			if type(C_UnitAuras.GetPlayerAuraBySpellID) == "function" and unit == "player" then
				-- 1459 = Arcane Intellect, present on this character in earlier runs.
				entry.bySpellID = CallAndDescribe(C_UnitAuras.GetPlayerAuraBySpellID, 1459)
			end
		end
		out.units[#out.units + 1] = entry
	end
	return out
end

--- 12.1.5 changes CustomAuraContainer: `AddDispelTypeTexture` and `AddPandemicRegion` no
--- longer return an index, and the matching Remove* calls now take a region reference.
--- MH creates exactly one container (PartyTargets.lua:326) and uses none of those four,
--- but "does our container still construct at all" is worth one line.
--- @return table
local function ProbeAuraContainer()
	local out = {}
	local ok, frame = pcall(CreateFrame, "AuraContainer", nil, UIParent, "CustomAuraContainerTemplate")
	if not ok or not frame then
		out.status = "could not create"
		out.err = tostring(frame)
		return out
	end
	out.status = "created"
	local methods = {}
	for _, m in ipairs({ "SetUnit", "AddAuraSlot", "SetEnabled", "UpdateAllAuras",
		"AddDispelTypeTexture", "AddPandemicRegion", "RemoveDispelTypeTexture",
		"RemovePandemicRegion", "SetCasterName", "SetAuraGroupEnabled",
		"SetAuraSlotEnabled", "SetItemEnchantmentEnabled", "SetEditModePreviewEnabled" }) do
		methods[m] = (frame[m] == nil) and "absent" or type(frame[m])
	end
	out.methods = methods
	pcall(frame.Hide, frame)
	return out
end

--------------------------------------------------------------------------------
-- /mh ptr watch — catch the secret state instead of timing it by hand
--------------------------------------------------------------------------------
--
-- 🔴 WHY THIS EXISTS. Six runs on 4 Sep produced exactly one sighting of the state we
-- care about: at 10:12, mid-fight with Dame Bloodshed, every aura read stopped returning
-- data and started THROWING
--     "Auras cannot be accessed when secret while tainted by 'MidnightHelper'"
-- The other five runs were all in the ordinary state, where the same code reads
-- everything plainly. The state is real, rare and short, and asking a human to press a
-- macro during the two seconds it lasts -- while being killed -- is not a measurement
-- method. So the addon watches for it.
--
-- The question it must answer is narrow: when the data routes refuse, does
-- `GetAuraSlots(unit, "HARMFUL|DISPELLABLE", 1)` refuse TOO? That call is what our
-- shipped dispel helper uses (DispelHelper.lua:379) and it asks whether a slot exists
-- rather than reading the aura. If it survives, the dispel helper works exactly where it
-- is needed. Both calls are made in the SAME tick, because a difference between them
-- measured seconds apart would prove nothing.

local watchTicker, watchTicks, watchDeadline, watchCastFrame
local caughtAura, caughtEnemyCast

--- ⚠️ THE CAST WALL IS NOT A POLLING PROBLEM, and treating it as one is why seven runs
--- never measured it. A cast lasts one to three seconds; sweeping once a second misses
--- roughly half of them, and sweeping for longer does not fix that — it just misses more
--- casts more times. `UNIT_SPELLCAST_START` fires exactly when there is something to
--- read, so the event is the measurement point and polling is not.
---
--- Both an ENEMY cast and one of our OWN are kept. The player's own cast is the positive
--- control: if the enemy's returns nothing but secrets, our own proves in the same run
--- that the reading method works, rather than leaving "all secret" and "probe broken"
--- indistinguishable — which is the mistake this repo keeps a rule about.
local function CaptureCast(unit, kind)
	local rec = {
		unit = unit,
		kind = kind,
		at = (_G.date and _G.date("%H:%M:%S")) or "?",
		inCombat = InCombatLockdown and InCombatLockdown() or false,
	}
	local okName, name = pcall(UnitName, unit)
	rec.name = okName and Describe(name) or "?"
	rec.isPlayer = UnitIsUnit and UnitIsUnit(unit, "player") or false
	for _, call in ipairs({ "UnitCastingInfo", "UnitChannelInfo" }) do
		if type(_G[call]) == "function" then
			rec[call] = CallAndDescribe(_G[call], unit)
		end
	end
	return rec
end

--- One call, described by outcome rather than by value. Returns true when the client
--- refused because of the secret/taint rule specifically -- not for any other error,
--- which would make an unrelated bug look like the finding.
--- @return boolean refused
local function Try(into, label, fn, ...)
	if type(fn) ~= "function" then
		into[label] = "no such function"
		return false
	end
	local ok, err = pcall(fn, ...)
	if ok then
		into[label] = "ok"
		return false
	end
	local s = tostring(err)
	into[label] = "REFUSED: " .. s
	local low = s:lower()
	return (low:find("secret", 1, true) or low:find("taint", 1, true)) and true or false
end

--- @return table sweep, boolean sawRefusal
local function SweepOnce()
	local sweep = { units = {} }
	local sawRefusal = false
	if not C_UnitAuras then
		return sweep, false
	end
	for _, unit in ipairs({ "player", "target", "targettarget" }) do
		if UnitExists(unit) then
			local u = { unit = unit }
			local r1 = Try(u, "instanceIDs", C_UnitAuras.GetUnitAuraInstanceIDs, unit, "HARMFUL")
			local r2 = Try(u, "byIndex", C_UnitAuras.GetAuraDataByIndex, unit, 1, "HARMFUL")
			-- The two that matter for the dispel helper, in the same tick as the above.
			local r3 = Try(u, "slotsDispellable", C_UnitAuras.GetAuraSlots,
				unit, "HARMFUL|DISPELLABLE", 1)
			local r4 = Try(u, "slotsPlain", C_UnitAuras.GetAuraSlots, unit, "HARMFUL", 1)
			local r5 = Try(u, "bySpellID", C_UnitAuras.GetUnitAuraBySpellID, unit, 118)
			u.refused = (r1 or r2 or r3 or r4 or r5) and true or false
			sweep.units[#sweep.units + 1] = u
			sawRefusal = sawRefusal or u.refused
		end
	end
	sweep.inCombat = InCombatLockdown and InCombatLockdown() or false
	sweep.isDead = UnitIsDeadOrGhost and UnitIsDeadOrGhost("player") or false
	sweep.targetName = UnitExists("target") and UnitName("target") or nil
	sweep.at = (_G.date and _G.date("%H:%M:%S")) or "?"
	return sweep, sawRefusal
end

local function StopWatch(reason)
	if watchTicker then
		pcall(watchTicker.Cancel, watchTicker)
		watchTicker = nil
	end
	if watchCastFrame then
		pcall(watchCastFrame.UnregisterAllEvents, watchCastFrame)
		pcall(watchCastFrame.SetScript, watchCastFrame, "OnEvent", nil)
	end
	print(("%s PTR watch stopped after %d sweeps — %s"):format(
		PREFIX, watchTicks or 0, reason))
	print(("  aura refusal: %s · enemy cast: %s"):format(
		caughtAura and "|cff44ff44caught|r" or "|cffff8844not seen|r",
		caughtEnemyCast and "|cff44ff44caught|r" or "|cffff8844not seen|r"))
end

--- Stop only once BOTH questions are answered. Stopping at the first catch is what the
--- single-goal version did, and with two goals that would throw away the second.
local function MaybeFinish()
	if caughtAura and caughtEnemyCast then
		StopWatch("both questions answered — |cff44ff44/reload now|r")
		return true
	end
	return false
end

--- `/mh ptr watch` — sweep every second until the secret state appears, then keep it.
function ns.MH_PtrWatch(action)
	if action == "stop" then
		if not watchTicker then
			print(PREFIX .. " PTR watch was not running.")
			return
		end
		StopWatch("stopped by hand")
		return
	end

	if watchTicker then
		print(PREFIX .. " PTR watch is already running. `/mh ptr watch stop` to end it.")
		return
	end

	ns.db = ns.db or {}
	watchTicks = 0
	caughtAura, caughtEnemyCast = false, false
	watchDeadline = GetTime() + 300
	ns.db.ptrProbeCast = { seen = 0 }
	print(PREFIX .. " PTR watch armed for 5 minutes: aura refusal (swept every second)"
		.. " and the cast wall (on the cast event itself). Go fight something.")

	-- The cast half. Event-driven on purpose — see CaptureCast above.
	watchCastFrame = watchCastFrame or CreateFrame("Frame")
	watchCastFrame:UnregisterAllEvents()
	watchCastFrame:RegisterEvent("UNIT_SPELLCAST_START")
	watchCastFrame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START")
	watchCastFrame:SetScript("OnEvent", function(_, event, unit)
		if type(unit) ~= "string" then
			return
		end
		local store = ns.db.ptrProbeCast
		store.seen = (store.seen or 0) + 1
		local okRec, rec = pcall(CaptureCast, unit,
			event == "UNIT_SPELLCAST_CHANNEL_START" and "channel" or "cast")
		if not okRec then
			store.error = tostring(rec)
			return
		end
		if rec.isPlayer then
			-- Positive control: keep the first one only, it never changes.
			if not store.self then
				store.self = rec
			end
			return
		end
		if not store.enemy then
			store.enemy = rec
			caughtEnemyCast = true
			print(("%s cast wall CAUGHT on %s (%s)."):format(PREFIX, unit, rec.kind))
			if PlaySound and SOUNDKIT and SOUNDKIT.RAID_WARNING then
				pcall(PlaySound, SOUNDKIT.RAID_WARNING)
			end
			MaybeFinish()
		end
	end)

	watchTicker = C_Timer.NewTicker(1, function()
		watchTicks = watchTicks + 1
		local okSweep, sweep, sawRefusal = pcall(SweepOnce)
		if not okSweep then
			StopWatch("the sweep itself errored: " .. tostring(sweep))
			return
		end
		if sawRefusal and not caughtAura then
			sweep.sweepNumber = watchTicks
			ns.db.ptrProbeSecret = sweep
			-- Take the full picture too, in the same state, while it lasts.
			if ns.MH_PtrProbe then
				pcall(ns.MH_PtrProbe)
			end
			if PlaySound and SOUNDKIT and SOUNDKIT.RAID_WARNING then
				pcall(PlaySound, SOUNDKIT.RAID_WARNING)
			end
			caughtAura = true
			print(PREFIX .. " aura refusal CAUGHT and saved.")
			if MaybeFinish() then
				return
			end
		end
		if GetTime() > watchDeadline then
			-- 🔴 Record what was NOT seen just as explicitly as what was. A missing key
			-- reads as "we never looked"; this says "we looked and it did not happen",
			-- which is a different claim and the only honest one.
			if not caughtAura then
				ns.db.ptrProbeSecret = {
					status = "never seen",
					sweeps = watchTicks,
					note = "5 minutes of sweeps, the aura refusal never appeared. Not"
						.. " proof it cannot happen -- proof it did not happen here.",
				}
			end
			local store = ns.db.ptrProbeCast
			if store and not store.enemy then
				store.status = "no enemy cast seen"
				store.note = ("5 minutes on UNIT_SPELLCAST_START; %d cast events arrived"
					.. " in total, none from a unit other than the player. Nothing was"
					.. " casting at us -- not a measurement of secrecy."):format(
					store.seen or 0)
			end
			StopWatch("time is up")
		end
	end)
end

--- `/mh ptr` — everything 12.1.5 changed that the other four probes do not cover.
--- Full result lands in `ns.db.ptrProbe`; chat gets a summary only, because the point of
--- writing to SavedVariables is that nobody has to retype a screenshot.
function ns.MH_PtrProbe()
	ns.db = ns.db or {}
	local out = {}
	out.client = ProbeClient()
	out.globals = ProbeGlobals()
	out.castWall = ProbeCastWall()
	out.auraCaster = ProbeAuraCaster()
	out.auraContainer = ProbeAuraContainer()
	ns.db.ptrProbe = out

	local c = out.client
	print(("%s PTR probe — client %s build %s (interface %s), MH %s"):format(
		PREFIX, c.version, c.build, tostring(c.interface), c.mhVersion))

	local missing = {}
	for name, kind in pairs(out.globals.moved) do
		if kind == "absent" then
			missing[#missing + 1] = name
		end
	end
	table.sort(missing)
	if #missing > 0 then
		print(("  moved globals now ABSENT (%d): %s"):format(#missing, table.concat(missing, ", ")))
	else
		print("  moved globals: all 15 still present (aliases kept).")
	end

	local goneAddons = {}
	for name, state in pairs(out.globals.addons) do
		if state == "not installed" then
			goneAddons[#goneAddons + 1] = name:gsub("^Blizzard_Deprecated", "")
		end
	end
	table.sort(goneAddons)
	print(("  Blizzard_Deprecated* gone: %s"):format(
		#goneAddons > 0 and table.concat(goneAddons, ", ") or "none"))
	print(("  SocketInventoryItem: %s"):format(
		_G.SocketInventoryItem == nil and "|cffff4444ABSENT|r" or "present"))

	local castNote = "no casting unit — re-run with a caster targeted"
	for _, e in ipairs(out.castWall) do
		local ci = e.UnitCastingInfo
		if ci and ci.status == "ok" then
			castNote = ("%s: %d return slots, see ns.db.ptrProbe"):format(e.unit, ci.count or 0)
			break
		end
	end
	print("  cast wall: " .. castNote)
	print(("  aura container: %s. Full detail: %s, then I read the file."):format(
		out.auraContainer.status, "/reload"))
end
