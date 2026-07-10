local _, ns = ...

--[[
	Midnight Helper — first-run onboarding (review F4.1).

	Bij de ALLEREERSTE login (per SavedVariables) ziet een nieuwe speler nu iets:
	een chatregel + een kleine popup die de interactieve rondleiding aanbiedt. Daarna
	nooit meer (vlag `ns.db.firstRunSeen`). Rob's keuze: niet-intrusief — géén venster
	dat ongevraagd openspringt, wél goed vindbaar.

	Standalone module: leest/schrijft `ns.db.firstRunSeen` rechtstreeks (nil = nog nooit
	gezien), dus GEEN wijziging aan Core.lua's DEFAULT_DB nodig.

	Test: `/mhfirstrun` reset de sessie-guard en toont de popup + chathint opnieuw.
]]

local POPUP_KEY = "MIDNIGHTHELPER_FIRSTRUN"
local shownThisSession = false

local function ShowFirstRun()
	if shownThisSession then
		return
	end
	shownThisSession = true
	if ns.db then
		ns.db.firstRunSeen = true -- markeer zodra we tonen; nooit twee keer
	end

	-- Chathint (blijft staan ook als de popup wordt weggeklikt).
	if ns.PrintChat then
		ns:PrintChat(ns:L("FIRSTRUN_CHAT"))
	elseif DEFAULT_CHAT_FRAME and DEFAULT_CHAT_FRAME.AddMessage then
		DEFAULT_CHAT_FRAME:AddMessage(ns:L("FIRSTRUN_CHAT"))
	end

	-- Kleine popup met de rondleiding-knop. StaticPopup regelt ESC/positie zelf.
	if type(StaticPopupDialogs) ~= "table" or not StaticPopup_Show then
		return
	end
	StaticPopupDialogs[POPUP_KEY] = StaticPopupDialogs[POPUP_KEY] or {}
	local d = StaticPopupDialogs[POPUP_KEY]
	-- Teksten elke keer verversen zodat ze de huidige taal volgen.
	d.text = ns:L("FIRSTRUN_POPUP_TEXT")
	d.button1 = ns:L("FIRSTRUN_SHOW_ME")
	d.button2 = ns:L("FIRSTRUN_LATER")
	-- Land on the Start Here roadmap, not on a tour of the window's furniture: a
	-- newcomer's first click should answer "what do I do?", not "where are the
	-- buttons?". The window tour is still one click away inside Start Here.
	d.OnAccept = function()
		if ns.ShowMainUI then
			ns:ShowMainUI()
		end
		if ns.SelectTab then
			ns.SelectTab("starthere")
		end
	end
	d.timeout = 0
	d.whileDead = true
	d.hideOnEscape = true
	d.showAlert = false
	d.preferredIndex = 3 -- Blizzard-aanbeveling tegen taint
	StaticPopup_Show(POPUP_KEY)
end

ns.ShowFirstRunExperience = ShowFirstRun

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", function()
	-- ns.db wordt door Core op ADDON_LOADED gezet; dat gaat vooraf aan PLAYER_LOGIN.
	if type(ns.db) ~= "table" then
		return
	end
	if ns.db.firstRunSeen then
		return
	end
	-- Even laten bezinken na het inlog-/laadscherm.
	if C_Timer and C_Timer.After then
		C_Timer.After(4, ShowFirstRun)
	else
		ShowFirstRun()
	end
end)

-- Test/preview: forceer de first-run-ervaring opnieuw (reset de sessie-guard).
SLASH_MHFIRSTRUN1 = "/mhfirstrun"
SlashCmdList["MHFIRSTRUN"] = function()
	shownThisSession = false
	ShowFirstRun()
end
