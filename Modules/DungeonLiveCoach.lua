--[[
	Dungeon Live Coach (Rob, 11 jun): bij ENCOUNTER_START de boss-stappen van
	de Coach in je eigen chat printen (zoals de delve-chat-tips), plus
	"/mh bossshare" om de stappen van de laatst aangevallen boss als platte
	tekst naar instance/party-chat te sturen. Volledige gelokaliseerde
	share-sync (ontvanger ziet eigen taal) volgt in fase 5 via MHShareSync.

	ENCOUNTER_START levert dungeonEncounterIDs; de tabel hieronder komt uit
	DBM-Party-Midnight/-WoD/-WotLK/-Legion/-Dragonflight (SetEncounterID per
	boss-mod, gelezen 11 jun 2026). Eén melding per boss per sessie (wipes
	spammen niet; /mh bossshare werkt altijd).
]]

local _, ns = ...

-- [dungeonEncounterID] = { dungeonKey, bossKey } (keys: DungeonRosterData)
local ENCOUNTERS = {
	-- Windrunner Spire
	[3056] = { "windrunnerspire", "emberdawn" },
	[3057] = { "windrunnerspire", "derelictduo" },
	[3058] = { "windrunnerspire", "kroluk" },
	[3059] = { "windrunnerspire", "restlessheart" },
	-- Maisara Caverns
	[3212] = { "maisara", "murojin" },
	[3213] = { "maisara", "vordaza" },
	[3214] = { "maisara", "raktul" },
	-- Murder Row
	[3101] = { "murderrow", "kystia" },
	[3102] = { "murderrow", "zaen" },
	[3103] = { "murderrow", "xathuux" },
	[3105] = { "murderrow", "lithiel" },
	-- Den of Nalorakk
	[3207] = { "nalorakk", "hoardmonger" },
	[3208] = { "nalorakk", "sentinel" },
	[3209] = { "nalorakk", "nalorakk" },
	-- The Blinding Vale
	[3199] = { "blindingvale", "trinity" },
	[3200] = { "blindingvale", "ikuzz" },
	[3201] = { "blindingvale", "ruia" },
	[3202] = { "blindingvale", "ziekket" },
	-- Voidscar Arena
	[3285] = { "voidscar", "tazrah" },
	[3286] = { "voidscar", "atroxus" },
	[3287] = { "voidscar", "charonus" },
	-- Nexus-Point Xenas
	[3328] = { "nexuspoint", "kasreth" },
	[3332] = { "nexuspoint", "nysarra" },
	[3333] = { "nexuspoint", "lothraxion" },
	-- Magisters' Terrace
	[3071] = { "magisters", "arcanotron" },
	[3072] = { "magisters", "seranel" },
	[3073] = { "magisters", "gemellus" },
	[3074] = { "magisters", "degentrius" },
	-- Skyreach
	[1698] = { "skyreach", "ranjit" },
	[1699] = { "skyreach", "araknath" },
	[1700] = { "skyreach", "rukhran" },
	[1701] = { "skyreach", "viryx" },
	-- Pit of Saron
	[1999] = { "pitofsaron", "garfrost" },
	[2001] = { "pitofsaron", "krickick" },
	[2000] = { "pitofsaron", "tyrannus" },
	-- Seat of the Triumvirate
	[2065] = { "triumvirate", "zuraal" },
	[2066] = { "triumvirate", "saprish" },
	[2067] = { "triumvirate", "nezhar" },
	[2068] = { "triumvirate", "lura" },
	-- Algeth'ar Academy
	[2562] = { "algethar", "vexamus" },
	[2563] = { "algethar", "ancient" },
	[2564] = { "algethar", "crawth" },
	[2565] = { "algethar", "doragosa" },
}

local shownThisSession = {} -- encounterID -> true
local lastEngaged = nil -- { dungeonKey, bossKey }

local function LiveTipsEnabled()
	local uiDb = ns.db and ns.db.ui
	if type(uiDb) ~= "table" then
		return true
	end
	return uiDb.dungeonLiveTips ~= false -- default aan
end

function ns.ToggleDungeonLiveTips()
	local uiDb = ns.db and ns.db.ui
	if type(uiDb) ~= "table" then
		return
	end
	uiDb.dungeonLiveTips = not LiveTipsEnabled()
	print("|cffffcc00MH:|r " .. ns:L(LiveTipsEnabled() and "DGN_LIVE_TOGGLE_ON" or "DGN_LIVE_TOGGLE_OFF"))
end

-- Roster-objecten opzoeken voor naam-resolutie (EJ-naam waar beschikbaar).
local function FindRosterBoss(dungeonKey, bossKey)
	for _, d in ipairs(ns.GetDungeonRoster and ns.GetDungeonRoster() or {}) do
		if d.key == dungeonKey then
			for i, b in ipairs(d.bosses or {}) do
				if b.key == bossKey then
					return d, b, i
				end
			end
		end
	end
	return nil
end

local function BossDisplayName(dungeonKey, bossKey)
	local d, b, i = FindRosterBoss(dungeonKey, bossKey)
	if d and b and ns.GetDungeonBossName then
		return ns.GetDungeonBossName(b, d, i)
	end
	return bossKey
end

local function StripMarkup(s)
	s = tostring(s or "")
	s = s:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")
	return s
end

-- {SPELL:id} → kale spelnaam (voor party-chat: geen markup versturen).
local function ExpandPlain(s)
	return (tostring(s or ""):gsub("{SPELL:(%d+)}", function(id)
		local name
		if C_Spell and C_Spell.GetSpellName then
			name = C_Spell.GetSpellName(tonumber(id))
		end
		return name and name ~= "" and name or ("spell " .. id)
	end))
end

-- Eén locale-string → lijst regels (|n-gescheiden), gesanitized.
-- rich=true: {SPELL:id} wordt een klikbare link (werkt in chatframes);
-- rich=false: kale spelnaam (voor SendChatMessage).
local function KeyToLines(key, rich)
	if not key then
		return {}
	end
	local s = ns:L(key)
	if rich and ns.ExpandDelveTipMarkup then
		s = ns:ExpandDelveTipMarkup(s)
	else
		s = ExpandPlain(s)
		if ns.SanitizeUIFontText then
			s = ns.SanitizeUIFontText(s)
		end
	end
	s = tostring(s or ""):gsub("|n", "\n")
	local out = {}
	for line in s:gmatch("[^\n]+") do
		out[#out + 1] = line
	end
	return out
end

local function PrintTipsLocal(dungeonKey, bossKey)
	local tips = ns.GetDungeonBossTips and ns.GetDungeonBossTips(dungeonKey, bossKey)
	if not tips then
		return false
	end
	local name = BossDisplayName(dungeonKey, bossKey)
	print("|cffffd100" .. ns:L("DGN_LIVE_HEADER_FMT"):format(name) .. "|r")
	for _, line in ipairs(KeyToLines(tips.steps, true)) do
		print("|cffe8e8e8" .. line .. "|r")
	end
	for _, line in ipairs(KeyToLines(tips.tank, true)) do
		print("|cffaecbfa" .. line .. "|r")
	end
	for _, line in ipairs(KeyToLines(tips.healer, true)) do
		print("|cffa9e8b8" .. line .. "|r")
	end
	print("|cff8a8f98" .. ns:L("DGN_LIVE_SHARE_HINT") .. "|r")
	return true
end

-- Ook aanroepbaar vanuit het boss-venster (Chat-knop, 12 jun). NB: ná de
-- local-definitie geplaatst — ervóór zou de upvalue nil zijn.
function ns.PrintDungeonBossTips(dungeonKey, bossKey)
	return PrintTipsLocal(dungeonKey, bossKey)
end

-- Platte tekst in stukken ≤240 tekens (SendChatMessage-limiet ~255),
-- gebroken op woordgrenzen.
local function ChunkLine(line, out)
	line = StripMarkup(line)
	while #line > 240 do
		local cut = 240
		for i = 240, 180, -1 do
			if line:sub(i, i) == " " then
				cut = i
				break
			end
		end
		out[#out + 1] = line:sub(1, cut - 1)
		line = line:sub(cut + 1)
	end
	if line ~= "" then
		out[#out + 1] = line
	end
end

-- In combat is addon-chat (SendChatMessage én C_ChatInfo-variant) door
-- Blizzard geblokkeerd (Midnight; live geverifieerd: Robs /run buiten
-- combat kwam aan, /mh bossshare vlak na de kill werd geblokkeerd — net als
-- DungeonHelpers auto-share). Daarom: in combat de share in de wachtrij,
-- automatisch versturen bij PLAYER_REGEN_ENABLED (ideaal voor wipes).
local pendingShare = nil

-- Optionele args (boss-venster deelt de gétoonde boss); zonder args geldt
-- de laatst gepullde boss.
function ns.ShareDungeonBossTips(dungeonKey, bossKey)
	local target
	if dungeonKey and bossKey then
		target = { dungeonKey = dungeonKey, bossKey = bossKey }
	else
		target = lastEngaged
	end
	if not target then
		print("|cffffcc00MH:|r " .. ns:L("DGN_SHARE_NONE"))
		return
	end
	local tips = ns.GetDungeonBossTips
		and ns.GetDungeonBossTips(target.dungeonKey, target.bossKey)
	if not tips then
		print("|cffffcc00MH:|r " .. ns:L("DGN_SHARE_NONE"))
		return
	end
	if InCombatLockdown and InCombatLockdown() then
		pendingShare = { dungeonKey = target.dungeonKey, bossKey = target.bossKey }
		print("|cffffcc00MH:|r " .. ns:L("DGN_SHARE_QUEUED"))
		return
	end
	lastEngaged = target -- de share-body hieronder leest lastEngaged
	local channel
	if IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
		channel = "INSTANCE_CHAT"
	elseif IsInGroup() then
		channel = "PARTY"
	end
	local name = BossDisplayName(lastEngaged.dungeonKey, lastEngaged.bossKey)
	local msgs = {}
	ChunkLine("MH " .. StripMarkup(ns:L("DGN_LIVE_HEADER_FMT"):format(name)), msgs)
	for _, key in ipairs({ tips.steps, tips.tank, tips.healer, tips.dps }) do
		for _, line in ipairs(KeyToLines(key)) do
			ChunkLine(line, msgs)
		end
	end
	if not channel then
		-- Geen groep: lokaal tonen, dan weet je wat er verstuurd zou worden.
		for _, m in ipairs(msgs) do
			print(m)
		end
		return
	end
	for _, m in ipairs(msgs) do
		-- C_ChatInfo.SendChatMessage — de oude global loopt op 12.x via een
		-- deprecated-shim die ADDON_ACTION_BLOCKED gooit (Rob, 11 jun);
		-- zelfde patroon als DelvePartyShare/RitualShare.
		if C_ChatInfo and C_ChatInfo.SendChatMessage then
			pcall(C_ChatInfo.SendChatMessage, m, channel)
		else
			pcall(SendChatMessage, m, channel)
		end
	end
	print("|cffffcc00MH:|r " .. ns:L("DGN_SHARE_SENT_FMT"):format(name))
end

local ev = CreateFrame("Frame")
ev:RegisterEvent("ENCOUNTER_START")
ev:RegisterEvent("ENCOUNTER_END")
ev:RegisterEvent("PLAYER_REGEN_ENABLED")
ev:SetScript("OnEvent", function(_, event, encounterID, _, _, _, success)
	if event == "PLAYER_REGEN_ENABLED" then
		if pendingShare then
			lastEngaged = pendingShare
			pendingShare = nil
			ns.ShareDungeonBossTips()
		end
		return
	end
	if event == "ENCOUNTER_END" then
		-- Boss dood → boss-venster bladert vast naar de volgende.
		if tonumber(success) == 1 then
			local hit = ENCOUNTERS[tonumber(encounterID) or 0]
			if hit and ns.BossWindowOnEncounterEnd then
				pcall(ns.BossWindowOnEncounterEnd, hit[1], hit[2])
			end
		end
		return
	end
	local hit = ENCOUNTERS[tonumber(encounterID) or 0]
	if not hit then
		return
	end
	lastEngaged = { dungeonKey = hit[1], bossKey = hit[2] }
	-- Zwevend boss-venster: auto-open + meebladeren (los van de chat-tips).
	if ns.BossWindowOnEncounter then
		pcall(ns.BossWindowOnEncounter, hit[1], hit[2])
	end
	if not LiveTipsEnabled() then
		return
	end
	if shownThisSession[encounterID] then
		return
	end
	if PrintTipsLocal(hit[1], hit[2]) then
		shownThisSession[encounterID] = true
	end
end)
