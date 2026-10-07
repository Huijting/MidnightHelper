local _, ns = ...

--[[
	One slash command per Midnight Helper screen, for a keypad (Rob, 8 Sep 2026: "schuine streep rares en dan gaat mijn
	rares-scherm open"; built 7 Oct 2026). A keypad sends one line, so these are top-level commands, and Rob chose the
	safe form: always "/mh" + the screen ("/mhrares"), never a bare "/rares" another addon might own.

	Screens open through the same door the search bar uses (ns.ShowMainUI + ns.SelectTab, NavSearch.lua), with the same
	tab ids, so a screen that opens from the search bar opens from here. The three pop-out windows go through the /mh
	router itself, so they behave exactly like typing /mh craftshop.

	`/mh keypad` prints the list (CommandList.lua lists that one, so the set can be found).
]]

-- { command, tab id or nil, /mh sub-command or nil, label key }
local KEYPAD = {
	{ "mhhome", "home", nil, "TAB_HOME" },
	{ "mhstart", "starthere", nil, "TAB_START_HERE" },
	{ "mhcodex", "codex", nil, "TAB_CODEX" },
	{ "mhdelves", "delves", nil, "TAB_DELVES" },
	{ "mhdungeons", "dungeons", nil, "TAB_DUNGEONS" },
	{ "mhraids", "raids", nil, "TAB_RAIDS" },
	{ "mhrares", "rares", nil, "TAB_RARES" },
	{ "mhachievements", "achievements", nil, "TAB_ACHIEVEMENTS" },
	{ "mhmounts", "mounts", nil, "TAB_MOUNTS" },
	{ "mhworld", "world", nil, "TAB_WORLD" },
	{ "mhevents", "events", nil, "TAB_EVENTS" },
	{ "mhaccount", "account", nil, "TAB_ACCOUNT_SNAPSHOT" },
	{ "mhdelvelog", "delvelog", nil, "TAB_DELVE_LOG" },
	{ "mhenchants", "enchants", nil, "TAB_ENCHANTS" },
	{ "mhtier", "tier", nil, "TAB_TIER" },
	{ "mhomnium", "omnium", nil, "TAB_OMNIUM" },
	{ "mhsmc", "smcguide", nil, "TAB_SMC" },
	{ "mhcurrency", "currency", nil, "TAB_CURRENCY" },
	{ "mhguide", "guide", nil, "TAB_GUIDE" },
	{ "mhprofessions", "professions", nil, "TAB_PROFESSIONS" },
	{ "mhtools", "toolslaunch", nil, "TAB_TOOLSLAUNCH" },
	{ "mhtoolbox", "toolbox", nil, "TAB_TOOLBOX" },
	{ "mhaddons", "addons", nil, "TAB_ADDONS" },
	{ "mhsettings", "settings", nil, "TAB_SETTINGS" },
	-- Pop-out windows: the same as typing /mh <sub-command>.
	{ "mhcraftshop", nil, "craftshop", "CRAFTSHOP_TITLE" },
	{ "mhready", nil, "ready", "RAIDSHOP_TITLE" },
	{ "mhblock", nil, "block", "KEYBLOCK_TITLE" },
}

local function Open(def)
	if def[2] then
		if ns.ShowMainUI then
			ns:ShowMainUI()
		end
		if ns.SelectTab then
			ns.SelectTab(def[2])
		end
	elseif def[3] and SlashCmdList and SlashCmdList.MIDNIGHTHELPER then
		SlashCmdList.MIDNIGHTHELPER(def[3])
	end
end

for _, def in ipairs(KEYPAD) do
	local key = "MHKEYPAD_" .. def[1]:upper()
	_G["SLASH_" .. key .. "1"] = "/" .. def[1]
	SlashCmdList[key] = function()
		Open(def)
	end
end

--- `/mh keypad`: the list, so a player can find what to bind.
function ns.PrintKeypadCommands()
	local p = ("|cffffcc00%s|r"):format(ns:L("PRINT_PREFIX"))
	print(p .. " " .. ns:L("KEYPAD_HEAD"))
	local parts = {}
	for _, def in ipairs(KEYPAD) do
		parts[#parts + 1] = ("|cffffd100/%s|r %s"):format(def[1], ns:L(def[4]))
		if #parts == 4 then
			print("   " .. table.concat(parts, "  ·  "))
			parts = {}
		end
	end
	if #parts > 0 then
		print("   " .. table.concat(parts, "  ·  "))
	end
end
