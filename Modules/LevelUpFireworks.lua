local _, ns = ...

--[[
	LevelUpFireworks.lua — a short burst of stars when you level up. Midnight and WoW Forever.

	Rob, 16 Nov 2026 (via sparring), after seeing another addon's level-up effect in Forever: "ja dat wil ik, dat
	vuurwerk, evt met geluid 🙂". Our own version: nothing taken from that addon (licence not measured).
	- Picture: Blizzard's own Interface\Cooldown\star4 (GEMETEN in Forever ManifestInterfaceData 1.60.1.70938, FileDataID
	  131010; retail has it too), coloured, three bursts, ~2.5 s. No mouse, nothing to click away, fades by itself.
	- Sound: SOUNDKIT.UI_EPICLOOT_TOAST (31578), GEMETEN in Blizzard_SharedXML/Mainline/SoundKitConstants.lua of the
	  forever branch (commit bebcb6bf); that the sound itself plays in Forever: AFGELEID. One short sound, SFX channel.
	- Players choose: two switches, fireworks and sound, both ON by default (Settings, and /mh fireworks on|off,
	  /mh fireworks sound on|off).
	- Not in a fight: then it waits for the end of the fight (up to 60 s, else it is skipped).
	- Midnight at max level: the "You are 90" popup comes 3 s after the level-up (MaxLevelWelcome.lua), so the
	  fireworks are over first.
	/mh fireworks        the switches and what happened at the last level-up (silence rule, CLAUDE.md)
	/mh fireworks test   the fireworks now, as at a level-up
]]

local STAR = "Interface\\Cooldown\\star4"
local COLORS = {
	{ 1, 0.82, 0.25 }, -- gold
	{ 0.45, 0.85, 1 }, -- light blue
	{ 1, 0.45, 0.75 }, -- pink
	{ 0.55, 1, 0.45 }, -- green
}
local STARS_PER_BURST = 12
local BURSTS = { { x = 0, y = 120, t = 0 }, { x = -180, y = 200, t = 0.45 }, { x = 170, y = 190, t = 0.9 } }

local last = "no level-up seen yet this session"

local function FireworksOn()
	return not (ns.db and ns.db.levelUpFireworks == false)
end

local function SoundOn()
	return not (ns.db and ns.db.levelUpFireworksSound == false)
end

local holder
local stars = {}

local function Holder()
	if holder then
		return holder
	end
	holder = CreateFrame("Frame", nil, UIParent)
	holder:SetAllPoints(UIParent)
	holder:SetFrameStrata("HIGH")
	holder:EnableMouse(false)
	if holder.SetMouseClickEnabled then
		holder:SetMouseClickEnabled(false)
	end
	return holder
end

--- One star: flies from the burst centre outwards, grows a little and fades.
local function Star(i)
	local s = stars[i]
	if s then
		return s
	end
	local h = Holder()
	local t = h:CreateTexture(nil, "OVERLAY")
	t:SetTexture(STAR)
	t:SetBlendMode("ADD")
	t:SetSize(28, 28)
	t:SetAlpha(0)
	local g = t:CreateAnimationGroup()
	g.move = g:CreateAnimation("Translation")
	g.move:SetDuration(1.1)
	g.move:SetSmoothing("OUT")
	g.scale = g:CreateAnimation("Scale")
	g.scale:SetDuration(1.1)
	if g.scale.SetScaleFrom then
		g.scale:SetScaleFrom(0.4, 0.4)
		g.scale:SetScaleTo(1.3, 1.3)
	else
		g.scale:SetScale(3, 3)
	end
	g.fadeIn = g:CreateAnimation("Alpha")
	g.fadeIn:SetFromAlpha(0)
	g.fadeIn:SetToAlpha(1)
	g.fadeIn:SetDuration(0.12)
	g.fadeOut = g:CreateAnimation("Alpha")
	g.fadeOut:SetFromAlpha(1)
	g.fadeOut:SetToAlpha(0)
	g.fadeOut:SetStartDelay(0.55)
	g.fadeOut:SetDuration(0.55)
	g:SetScript("OnFinished", function()
		t:SetAlpha(0)
	end)
	t.anim = g
	stars[i] = t
	return t
end

local function Burst(b, colour, firstIndex)
	for k = 1, STARS_PER_BURST do
		local t = Star(firstIndex + k)
		local angle = (k / STARS_PER_BURST) * 2 * math.pi + (math.random() * 0.3)
		local dist = 90 + math.random() * 50
		t:ClearAllPoints()
		t:SetPoint("CENTER", Holder(), "CENTER", b.x, b.y)
		t:SetVertexColor(colour[1], colour[2], colour[3])
		t.anim.move:SetOffset(math.cos(angle) * dist, math.sin(angle) * dist)
		t.anim:Stop()
		t:SetAlpha(1)
		t.anim:Play()
	end
end

local function Play(withSound)
	Holder():Show()
	for i, b in ipairs(BURSTS) do
		local colour = COLORS[((i - 1) % #COLORS) + 1]
		local first = (i - 1) * STARS_PER_BURST
		if C_Timer and C_Timer.After and b.t > 0 then
			C_Timer.After(b.t, function()
				Burst(b, colour, first)
			end)
		else
			Burst(b, colour, first)
		end
	end
	if withSound and PlaySound and SOUNDKIT and SOUNDKIT.UI_EPICLOOT_TOAST then
		pcall(PlaySound, SOUNDKIT.UI_EPICLOOT_TOAST, "SFX")
	end
end

local waitingSince
local ev = CreateFrame("Frame")
ev:RegisterEvent("PLAYER_LEVEL_UP")
ev:SetScript("OnEvent", function(self, event, newLevel)
	if event == "PLAYER_REGEN_ENABLED" then
		self:UnregisterEvent("PLAYER_REGEN_ENABLED")
		if waitingSince and GetTime and GetTime() - waitingSince <= 60 then
			last = last .. "; shown after the fight"
			Play(SoundOn())
		elseif waitingSince then
			last = last .. "; fight lasted over 60 s, skipped"
		end
		waitingSince = nil
		return
	end
	if not FireworksOn() then
		last = ("level %s: fireworks are off"):format(tostring(newLevel))
		return
	end
	if InCombatLockdown and InCombatLockdown() then
		last = ("level %s: in a fight, waiting for its end"):format(tostring(newLevel))
		waitingSince = GetTime and GetTime() or 0
		self:RegisterEvent("PLAYER_REGEN_ENABLED")
		return
	end
	last = ("level %s: shown%s"):format(tostring(newLevel), SoundOn() and " with sound" or " without sound")
	Play(SoundOn())
end)

--- Settings (SettingsDefs.lua) and /mh fireworks.
function ns.IsLevelUpFireworksOn()
	return FireworksOn()
end
function ns.SetLevelUpFireworks(on)
	if ns.db then
		ns.db.levelUpFireworks = on and true or false
	end
end
function ns.IsLevelUpFireworksSoundOn()
	return SoundOn()
end
function ns.SetLevelUpFireworksSound(on)
	if ns.db then
		ns.db.levelUpFireworksSound = on and true or false
	end
end

function ns.HandleFireworksCommand(arg)
	arg = (arg or ""):lower()
	local P = "|cffffcc00Midnight Helper:|r "
	if arg == "test" then
		Play(SoundOn())
		print(P .. "fireworks test" .. (SoundOn() and " (with sound)" or " (sound off)"))
		return
	elseif arg == "on" or arg == "off" then
		ns.SetLevelUpFireworks(arg == "on")
	elseif arg == "sound on" or arg == "sound off" then
		ns.SetLevelUpFireworksSound(arg == "sound on")
	end
	print(P .. ("level-up fireworks: %s, sound: %s (sound kit %s). Last level-up: %s. /mh fireworks test = see it."):format(
		FireworksOn() and "on" or "off", SoundOn() and "on" or "off",
		tostring(SOUNDKIT and SOUNDKIT.UI_EPICLOOT_TOAST or "missing on this client"), last))
end
