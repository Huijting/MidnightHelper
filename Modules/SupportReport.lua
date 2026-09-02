--[[
	/mh report — a ready-made report to paste, for a player who saw something wrong.

	WHY THIS EXISTS (Spec 31 B5)
	Zero GitHub issues in four months. That was never a sign that nothing was wrong; on
	2 Sep 2026 Rob spotted a stale world-boss article on our own public site within an hour
	of it going up, and the only reason it got fixed is that he happens to be the maintainer.
	A player who notices the same thing has nowhere obvious to put it.

	⚠️ THIS ADDON'S WORST FAULT IS BEING OUT OF DATE, NOT CRASHING. Nothing on screen looks
	broken when a tip quietly describes last season. So the wording deliberately says that
	"it told me something wrong" counts -- the same line the GitHub bug template opens with.

	NO NEW WINDOW. ns.ShowShareCopyDialog (Modules/DelvePartyShare.lua:431) is already
	shared, scrollable, multiline, Esc-closable and self-selecting, and four modules use it.

	📌 THE REPORT BODY IS ENGLISH ON PURPOSE, while everything around it is translated.
	It is addressed to the maintainer, not to the player: a Spanish report whose labels are
	Spanish is harder for the one person who reads it, and would add seven languages of
	upkeep to a technical block. The dialog title and the chat line DO speak the player's
	language, so nobody has to guess what the block is for. Same split as a log file.

	🔴 WHAT IS DELIBERATELY NOT IN IT: character name and realm. They identify the player,
	they are not needed to reproduce anything, and this text is meant to be pasted somewhere
	public. Class, spec, group size and instance are enough to place a report.
]]

local addonName, ns = ...

--- 12.x can hand back secret values for things read out of the world, and comparing or
--- concatenating one throws. Core.lua:2306 is the precedent; anything below that comes from
--- the world goes through here first.
local function Safe(v)
	if issecretvalue and issecretvalue(v) then
		return nil
	end
	return v
end

local function AddonVersion()
	if C_AddOns and C_AddOns.GetAddOnMetadata then
		return C_AddOns.GetAddOnMetadata(addonName, "Version") or "?"
	elseif GetAddOnMetadata then
		return GetAddOnMetadata(addonName, "Version") or "?"
	end
	return "?"
end

local function ClientLine()
	if not GetBuildInfo then
		return "client unknown"
	end
	local version, build = GetBuildInfo()
	return ("client %s (%s)"):format(tostring(version or "?"), tostring(build or "?"))
end

local function LocaleLine()
	local client = (GetLocale and GetLocale()) or "?"
	local mh = "?"
	if ns.GetEffectiveLocaleCode then
		local ok, code = pcall(ns.GetEffectiveLocaleCode, ns)
		if ok and code then
			mh = code
		end
	end
	-- Worth stating both: a player on a German client reading English text is a locale
	-- question, not a bug, and this line settles it before anyone investigates.
	return ("locale %s client / %s in MH"):format(client, mh)
end

local function CharacterLine()
	local _, class = UnitClass("player")
	local spec = "?"
	if GetSpecialization then
		local idx = GetSpecialization()
		if idx and GetSpecializationInfo then
			local _, name = GetSpecializationInfo(idx)
			spec = Safe(name) or "?"
		end
	end
	local level = UnitLevel and UnitLevel("player") or 0
	return ("%s %s, level %s"):format(tostring(class or "?"), tostring(spec), tostring(level))
end

local function GroupLine()
	local n = (GetNumGroupMembers and GetNumGroupMembers()) or 0
	if n <= 1 then
		return "solo"
	end
	return ((IsInRaid and IsInRaid()) and "raid of %d" or "party of %d"):format(n)
end

local function PlaceLine()
	if not GetInstanceInfo then
		return "somewhere"
	end
	local ok, name, instanceType, _, difficultyName = pcall(GetInstanceInfo)
	if not ok then
		return "somewhere"
	end
	name = Safe(name)
	instanceType = Safe(instanceType)
	difficultyName = Safe(difficultyName)
	if not name or name == "" then
		return "somewhere"
	end
	if instanceType == "none" then
		return tostring(name) .. " (open world)"
	end
	if difficultyName and difficultyName ~= "" then
		return ("%s (%s, %s)"):format(tostring(name), tostring(instanceType), tostring(difficultyName))
	end
	return ("%s (%s)"):format(tostring(name), tostring(instanceType))
end

--- Build the pasteable block. `what` is whatever the player typed after /mh report.
function ns.BuildSupportReport(what)
	what = (what or ""):gsub("^%s+", ""):gsub("%s+$", "")
	if what == "" then
		what = "(describe what you saw here -- including \"it told me something wrong\")"
	end

	local lines = {
		"Midnight Helper report",
		("%s . %s"):format(AddonVersion(), ClientLine()),
		LocaleLine(),
		("%s . %s . %s"):format(CharacterLine(), GroupLine(), PlaceLine()),
		"",
		"What I saw:",
		what,
		"",
		-- Both destinations, so the player uses whichever is already open rather than
		-- being sent somewhere. Spec 31 B5.
		"Send to: https://discord.gg/kBHaHcsASQ",
		"     or: https://github.com/Huijting/MidnightHelper/issues",
	}
	return table.concat(lines, "\n")
end

function ns.ShowSupportReport(what)
	if not ns.ShowShareCopyDialog then
		print("|cffffcc00Midnight Helper:|r " .. ns:L("REPORT_NO_DIALOG"))
		return
	end
	ns.ShowShareCopyDialog({
		id = "mh_support_report",
		titleKey = "REPORT_TITLE",
		text = ns.BuildSupportReport(what),
	})
	print("|cffffcc00Midnight Helper:|r " .. ns:L("REPORT_CHAT_HINT"))
end
