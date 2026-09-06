local _, ns = ...

--[==[
	Midnight Helper — `/mh sniff`: welk event draagt een melding die we zien maar niet kennen?

	⚠️ Let op de `[==[`-haken: dit blok verwijst naar memory-notities in `[[naam]]`-vorm, en die
	`]]` zou een gewoon `--[[`-commentaar hier al beëindigen. Kostte één syntaxfout om te leren.

	🔴 WAAROM DIT BESTAAT — 6 sep 2026. Rob fotografeerde de spelmelding *"Additional Bountiful
	Rewards Will Manifest Upon Delve Completion"* bij zijn EERSTE Dundun van de week op een vers
	character. Als de addon die melding kan lezen, hoeft de Dundun-regel niet meer de regel op te
	dreunen ("de eerste geeft een kist, de rest een keuzescherm") maar kan hij zeggen wélk geval
	dit is. Alleen: niemand weet welk event hem draagt, en dat valt niet te bedenken.

	⚠️ EN DE VOOR DE HAND LIGGENDE OPLOSSING IS EEN VAL: match NOOIT op de Engelse tekst. Die
	banner is vertaald, dus een string-vergelijking werkt op één van de zeven clients en faalt
	stil op de rest — een bug die alleen niet-Engelse spelers ooit tegenkomen en die wij dus nooit
	te zien krijgen. Zie [[locale-packs-gated-by-client]]. Wat we zoeken is een EVENT plus een
	getal: een gossipOptionID, een toast-id, een scenario-criterium. Daarom logt dit ding de
	numerieke velden even zorgvuldig als de tekst.

	📌 GOSSIP_SHOW is hier de meest kansrijke vangst en niet de banner zelf: `C_GossipInfo.
	GetOptions()` geeft per keuze een `gossipOptionID`, en dat is een GETAL. Biedt Dundun de
	eerste keer een andere optie-id aan dan de tweede, dan hebben we een taalonafhankelijk
	onderscheid zonder ooit naar een zin te hoeven kijken.

	⚠️ Registreren gebeurt defensief. Op 8 aug 2026 wierp `LEARNED_SPELL_IN_TAB` bij het laden
	"Attempt to register unknown event" omdat de naam uit een andere addon was overgeschreven in
	plaats van aan de client gevraagd. Elke naam hieronder is dus een KANDIDAAT: hij gaat door een
	pcall en wat de client weigert wordt gemeld in plaats van stilgehouden.

	Gebruik:
	    /mh sniff        aan/uit
	    /mh sniff dump   print wat er gevangen is
	    /mh sniff clear  gooi het logboek leeg

	Het logboek staat in `ns.db.sniffLog`, zodat een `/reload` het niet wist en ik het bestand
	zelf kan lezen — zie [[savedvariables-diagnostics]].
]==]

--- Kandidaten voor "een melding die midden op het scherm verschijnt" plus de gossip eromheen.
--- Bewust breed: de hele opzet is dat wij niet weten welke het is.
local CANDIDATES = {
	-- Meldingen in beeld
	"RAID_BOSS_EMOTE", "RAID_BOSS_WHISPER",
	"CHAT_MSG_RAID_BOSS_EMOTE", "CHAT_MSG_RAID_BOSS_WHISPER",
	"CHAT_MSG_MONSTER_EMOTE", "CHAT_MSG_MONSTER_SAY", "CHAT_MSG_MONSTER_YELL",
	"UI_INFO_MESSAGE", "UI_ERROR_MESSAGE",
	"DISPLAY_EVENT_TOASTS", "SHOW_LOOT_TOAST",
	-- De delve als scenario
	"SCENARIO_UPDATE", "SCENARIO_CRITERIA_UPDATE", "SCENARIO_POI_UPDATE",
	"SCENARIO_COMPLETED", "CRITERIA_UPDATE",
	-- De kant met getallen erin
	"GOSSIP_SHOW", "GOSSIP_CLOSED",
}

local MAX_ROWS = 400
--- Zichzelf uitzetten. Een snuffelaar die blijft draaien vult SavedVariables met een avond
--- delve-gepraat en niemand merkt het, want hij is per definitie stil als er niets gebeurt.
local AUTO_OFF_SECONDS = 30 * 60

local frame
local refused = {}
local expiry = 0

local function Prefix()
	return ("|cffffcc00%s|r"):format((ns.L and ns:L("PRINT_PREFIX")) or "Midnight Helper:")
end

--- Eén waarde leesbaar maken zonder erover te struikelen. 12.x kan velden als secret
--- teruggeven; `issecretvalue` aanraken mag, gebruiken niet.
local function Safe(v)
	if v == nil then
		return nil
	end
	if issecretvalue and issecretvalue(v) then
		return "<secret>"
	end
	local t = type(v)
	if t == "string" then
		if #v > 160 then
			return v:sub(1, 160) .. "…"
		end
		return v
	end
	if t == "number" or t == "boolean" then
		return tostring(v)
	end
	return "<" .. t .. ">"
end

--- GOSSIP_SHOW draagt zijn nuttige inhoud niet in de argumenten maar in een API-aanroep.
--- De optie-ID's zijn het punt: getallen overleven een vertaling, zinnen niet.
local function GossipDetail()
	if not C_GossipInfo or not C_GossipInfo.GetOptions then
		return nil
	end
	local ok, opts = pcall(C_GossipInfo.GetOptions)
	if not ok or type(opts) ~= "table" then
		return nil
	end
	local out = {}
	for i = 1, #opts do
		local o = opts[i]
		out[#out + 1] = {
			id = Safe(o and o.gossipOptionID),
			name = Safe(o and o.name),
			icon = Safe(o and o.icon),
		}
	end
	return out
end

local function Record(event, ...)
	ns.db = ns.db or {}
	ns.db.sniffLog = ns.db.sniffLog or {}
	local log = ns.db.sniffLog

	local row = { ev = event, t = date("%H:%M:%S"), args = {} }
	for i = 1, select("#", ...) do
		row.args[i] = Safe((select(i, ...)))
	end
	if event == "GOSSIP_SHOW" then
		row.gossip = GossipDetail()
	end

	log[#log + 1] = row
	-- Vooraan afkappen, niet achteraan: het interessante is altijd wat er NET gebeurde.
	while #log > MAX_ROWS do
		table.remove(log, 1)
	end

	local bits = {}
	for i = 1, #row.args do
		bits[#bits + 1] = tostring(row.args[i])
	end
	print(("  |cff8a8f98%s|r |cff40c040%s|r %s"):format(
		row.t, event, table.concat(bits, " | ")))
	if row.gossip then
		for i = 1, #row.gossip do
			local g = row.gossip[i]
			print(("     |cffffd100gossipOptionID %s|r  %s"):format(
				tostring(g.id), tostring(g.name)))
		end
	end
end

local function StopSniffing(quiet)
	if frame then
		pcall(frame.UnregisterAllEvents, frame)
		frame:SetScript("OnUpdate", nil)
	end
	if ns.db then
		ns.db.sniffOn = false
	end
	expiry = 0
	if not quiet then
		print(Prefix() .. " sniffer uit. |cffffd100/mh sniff dump|r toont wat er gevangen is.")
	end
end

local function StartSniffing()
	ns.db = ns.db or {}
	frame = frame or CreateFrame("Frame")
	wipe(refused)

	local taken = 0
	for i = 1, #CANDIDATES do
		local name = CANDIDATES[i]
		local ok = pcall(frame.RegisterEvent, frame, name)
		if ok then
			taken = taken + 1
		else
			refused[#refused + 1] = name
		end
	end

	frame:SetScript("OnEvent", function(_, event, ...)
		Record(event, ...)
	end)

	expiry = GetTime() + AUTO_OFF_SECONDS
	frame:SetScript("OnUpdate", function()
		if expiry > 0 and GetTime() > expiry then
			StopSniffing(true)
			print(Prefix() .. " sniffer is na 30 minuten vanzelf gestopt.")
		end
	end)

	ns.db.sniffOn = true
	print(("%s sniffer AAN — %d van %d events geregistreerd, stopt vanzelf na 30 min."):format(
		Prefix(), taken, #CANDIDATES))
	if #refused > 0 then
		print("  |cffff5555Deze kent deze client niet:|r " .. table.concat(refused, ", "))
		print("  |cff8a8f98Dat is zelf een meting — het waren kandidaten, geen feiten.|r")
	end
	print("  |cff8a8f98Doe nu de Bountiful delve en spreek Dundun aan. Let op de|r")
	print("  |cff8a8f98gossipOptionID-regels: een GETAL overleeft een vertaling, een zin niet.|r")
end

function ns.MH_SniffToggle()
	ns.db = ns.db or {}
	if ns.db.sniffOn then
		StopSniffing()
	else
		StartSniffing()
	end
end

function ns.MH_SniffDump()
	local log = (ns.db and ns.db.sniffLog) or {}
	if #log == 0 then
		print(Prefix() .. " sniffer-logboek is leeg.")
		print("  |cff8a8f98Leeg betekent hier NIET 'geen event' — het kan ook betekenen dat|r")
		print("  |cff8a8f98de sniffer uit stond of dat geen van de kandidaten de juiste was.|r")
		return
	end
	print(("%s sniffer-logboek — %d regels:"):format(Prefix(), #log))
	local seen = {}
	for i = 1, #log do
		local row = log[i]
		seen[row.ev] = (seen[row.ev] or 0) + 1
		local bits = {}
		for j = 1, #(row.args or {}) do
			bits[#bits + 1] = tostring(row.args[j])
		end
		print(("  |cff8a8f98%s|r |cff40c040%s|r %s"):format(
			row.t or "?", row.ev, table.concat(bits, " | ")))
		for j = 1, #(row.gossip or {}) do
			local g = row.gossip[j]
			print(("     |cffffd100gossipOptionID %s|r  %s"):format(
				tostring(g.id), tostring(g.name)))
		end
	end
	local kinds = {}
	for ev, n in pairs(seen) do
		kinds[#kinds + 1] = ("%s ×%d"):format(ev, n)
	end
	table.sort(kinds)
	print("  |cffffd100" .. table.concat(kinds, " · ") .. "|r")
end

function ns.MH_SniffClear()
	if ns.db then
		ns.db.sniffLog = {}
	end
	print(Prefix() .. " sniffer-logboek leeggemaakt.")
end

--- 🔴 EEN RELOAD ZETTE HEM STIL UIT, EN DE SCHAKELAAR LOOG DAAROVER.
---
--- `sniffOn` staat in SavedVariables en overleeft een `/reload`; de event-registratie doet dat
--- niet. Zonder dit blok was de toestand na een reload dus "vlag aan, luistert niets" — en de
--- volgende `/mh sniff` had die vlag gezien en netjes "sniffer uit" geprint terwijl hij al uit
--- stond. Twee keer aanzetten en nul regels vangen, zonder één foutmelding.
---
--- Gevonden doordat Rob middenin een delve vroeg of hij mocht reloaden (6 sep 2026). Hij had de
--- sniffer nog niet aangezet, dus het heeft hem niets gekost — deze keer.
---
--- 📌 Dus: hervat wat de speler heeft aangezet, en zeg het hardop. Precies de regel uit
--- CLAUDE.md over dingen die stil kunnen zwijgen — alleen dan toegepast op een schakelaar in
--- plaats van op een advies.
local loader = CreateFrame("Frame")
loader:RegisterEvent("PLAYER_LOGIN")
loader:SetScript("OnEvent", function(self)
	self:UnregisterAllEvents()
	if ns.db and ns.db.sniffOn then
		ns.db.sniffOn = false -- StartSniffing zet hem weer aan; anders telt hij als "al aan"
		StartSniffing()
		print("  |cff8a8f98(hervat na de reload — hij stond aan toen je herlaadde)|r")
	end
end)
