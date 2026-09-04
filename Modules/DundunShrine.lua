local _, ns = ...

--[[
	Midnight Helper — Dundun, the Shrine of Abundance.

	One sentence nobody else gives the player: this delve is Bountiful, so Dundun is
	hiding in it, and taking his offer can cost a SECOND Restored Coffer Key.

	🔴 WHAT DUNDUN IS, AND WHAT WE GOT WRONG FIRST (3-4 Sep 2026). Rob met him in The Gulf
	of Memory and the entrance screen said "Dundun will hide within this Delve." The
	handoff then recorded him as a delve MODIFIER, which is wrong: the wiki's
	`Category:Delve affixes` lists seventeen and he is not among them. He is an NPC
	(wiki NPC id 266751) disguised as a prop -- a fake tree -- and he appears in
	**Bountiful** delves of any tier once the player has reached Delver's Journey rank 3.

	That correction is what makes this small. We do not need to read delve affixes at all
	(we never could): Bountiful already comes from the client, the Journey rank already
	has a reader, and Restored Coffer Keys are already counted.

	⚠️ WHAT IS STILL UNSETTLED, and why the wording below is careful. Sources disagree on
	what the FIRST find of a week gives. Rob measured a second Bountiful Coffer that
	needed a second key (his own tooltip read `Restored Coffer Key 2 / 1`), and
	masterofwarcraft.net says the same; the Warcraft Wiki instead describes an "Abundantly
	Bountiful Heavy Trunk" with a choice of Undercoin / Voidlight Marl / Valeera XP /
	housing decor. Whether the axis is "first ever" or "first this week" is not
	established. So we say the extra chest CAN cost a second key -- never that it will.

	⚠️ And rank 3 itself is from those same web sources, not measured in the client. If
	the rank cannot be read we still speak, but say the condition out loud instead of
	pretending we checked it.

	📌 `/mh dundun` prints the whole decision including why it stayed quiet, because
	staying quiet is the normal outcome here (most delves are not Bountiful) and correct
	silence must be distinguishable from broken.
]]

local PREFIX = "|cffffcc00Midnight Helper|r"

--- The rank at which Dundun starts appearing. Web-sourced ("Rank 3: Treasure Hunter"),
--- NOT measured in the client -- see the header.
local DUNDUN_MIN_JOURNEY_RANK = 3
local CURRENCY_COFFER_KEY = 3028

--- @return number|nil quantity, nil when the currency cannot be read
local function CofferKeyCount()
	if not (C_CurrencyInfo and C_CurrencyInfo.GetCurrencyInfo) then
		return nil
	end
	local ok, info = pcall(C_CurrencyInfo.GetCurrencyInfo, CURRENCY_COFFER_KEY)
	if not ok or type(info) ~= "table" then
		return nil
	end
	local q = info.quantity
	if q == nil or (issecretvalue and issecretvalue(q)) then
		return nil
	end
	return tonumber(q)
end

--- Name of the delve the player is standing in, as far as the addon can tell.
--- @return string|nil
local function ActiveDelveName()
	local entry
	if ns.GetActiveDelveTipEntryForPlayer then
		local ok, e = pcall(ns.GetActiveDelveTipEntryForPlayer, ns)
		if ok then
			entry = e
		end
	end
	if type(entry) == "table" then
		return entry.name or entry.title
	end
	return nil
end

--- Everything the advice rests on, gathered once so the chat line and the diagnostic
--- cannot drift apart. Every field is three-state: a value, or nil for "could not read".
--- @return table
function ns.GetDundunStatus()
	local s = {}

	s.delveName = ActiveDelveName()
	s.inDelve = (ns.IsDelveInstanceInProgress and ns:IsDelveInstanceInProgress()) or nil

	-- Bountiful. ⚠️ This reads the map POI, and inside the delve that POI may be gone --
	-- measured behaviour unknown, which is exactly why nil is kept distinct from false.
	if ns.IsDelveBountiful and s.delveName then
		local ok, b = pcall(ns.IsDelveBountiful, s.delveName, nil)
		if ok then
			s.bountiful = b and true or false
		end
	end

	-- Delver's Journey rank. nil means unreadable, never rank 0 -- GetDelverJourneyStatus
	-- is already written that way, so do not undo it here.
	if ns.GetDelverJourneyStatus then
		local ok, j = pcall(ns.GetDelverJourneyStatus)
		if ok and type(j) == "table" then
			s.rank = tonumber(j.rank)
		end
	end
	if s.rank ~= nil then
		s.rankOk = s.rank >= DUNDUN_MIN_JOURNEY_RANK
	end

	s.keys = CofferKeyCount()

	-- The verdict, with the reason attached. A caller must never re-derive this.
	if s.bountiful == nil then
		s.verdict, s.reason = "quiet", "could not read whether this delve is Bountiful"
	elseif s.bountiful == false then
		s.verdict, s.reason = "quiet", "this delve is not Bountiful, so Dundun is not in it"
	elseif s.rankOk == false then
		s.verdict, s.reason = "quiet", ("Delver's Journey rank %d is below %d, so Dundun"
			.. " does not appear yet"):format(s.rank, DUNDUN_MIN_JOURNEY_RANK)
	elseif s.rank == nil then
		s.verdict, s.reason = "speak-with-caveat", "Bountiful, but the Journey rank could"
			.. " not be read -- name the rank condition instead of assuming it"
	else
		s.verdict, s.reason = "speak", "Bountiful and rank is high enough"
	end

	return s
end

--- The chat line. This is an EVENT the player can miss (you just walked into a delve),
--- which is the case chat is right for -- as opposed to "why did nothing happen when I
--- pressed this", which belongs where the button is. See CLAUDE.md.
function ns.AnnounceDundunIfRelevant()
	local s = ns.GetDundunStatus()
	if s.verdict ~= "speak" and s.verdict ~= "speak-with-caveat" then
		ns._mhLastDundun = s
		return false
	end

	print(PREFIX .. " " .. ns:L("DUNDUN_CHAT_HEADER"))
	print("  " .. ns:L("DUNDUN_CHAT_WHAT"))
	if s.verdict == "speak-with-caveat" then
		print("  " .. ns:L("DUNDUN_CHAT_RANK_UNKNOWN"):format(DUNDUN_MIN_JOURNEY_RANK))
	end

	-- The key line, and the only number here that is Rob's own measurement.
	if s.keys == nil then
		print("  " .. ns:L("DUNDUN_CHAT_COST_UNKNOWN"))
	elseif s.keys >= 2 then
		print("  " .. ns:L("DUNDUN_CHAT_COST_FMT"):format(s.keys))
	else
		print("  |cffff8844" .. ns:L("DUNDUN_CHAT_COST_SHORT_FMT"):format(s.keys) .. "|r")
	end

	print("  " .. ns:L("DUNDUN_CHAT_MACRO"))
	ns._mhLastDundun = s
	return true
end

--- `/mh dundun` — the whole decision, including why it said nothing.
function ns.PrintDundunStatus()
	local s = ns.GetDundunStatus()
	local function Show(v)
		if v == nil then
			return "|cffff8844could not read|r"
		end
		return tostring(v)
	end
	print(PREFIX .. " Dundun (Shrine of Abundance)")
	print("  in a delve      : " .. Show(s.inDelve))
	print("  delve name      : " .. Show(s.delveName))
	print("  Bountiful       : " .. Show(s.bountiful))
	print(("  Journey rank    : %s (need %d)"):format(Show(s.rank), DUNDUN_MIN_JOURNEY_RANK))
	print("  Restored Coffer Keys: " .. Show(s.keys))
	print(("  verdict         : |cff88ccff%s|r — %s"):format(
		tostring(s.verdict), tostring(s.reason)))
	print("  What he is: an NPC disguised as a prop (a fake tree), not a delve affix.")
	print("  Unsettled: whether the first find gives a second Coffer or a choice trunk.")
end
