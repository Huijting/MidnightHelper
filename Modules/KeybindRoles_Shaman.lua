local addonName, ns = ...
ns.KeybindRoleClassifier = ns.KeybindRoleClassifier or {}

--[[
	Naam->rol-classifier voor SHAMAN (WoW Midnight, v6-keybind-standaard).
	VERVANGT de oude incomplete Shaman-draft: dekt elke relevante ACTIVE spell per spec.

	Never-lie. Rollen zijn HIERUIT afgeleid:
	  - Modules/KeybindingData.lua -> ele_shaman (262) + enh_shaman (263): in-game bevestigd
	    (Rob, 2026-07-02). LEIDEND: toets/rol voor 262/263 volgt exact die spellByUiKey-blokken.
	  - JustAC/Data/InterruptAbilities.lua (Wind Shear/Capacitor Totem), SpellCategories.lua
	    (Astral Shift/Hex/Purge/Cleanse Spirit/Healing Surge/Bloodlust/Heroism/Thunderstorm),
	    SpellArchetypes.lua (builders/spenders), DefensiveEngine.lua, GapCloserEngine.lua
	    (Spirit Walk/Gust of Wind/Ghost Wolf/Spiritwalker's Grace).
	  - docs/KEYBIND_MAP_DRAFT_hunter_paladin_shaman.md (Restoration 264 - healer, draft-toetsen).

	Gekeyd op de exacte spell-NAAM; de addon matcht dit tegen de live spellbook.
	specs={<id>} = spec-specifiek; geen specs = class-baseline (alle 3 specs).
	specID's: Elemental 262, Enhancement 263, Restoration 264.

	BELANGRIJK (never-lie, Ele-scope): de in-game bevestigde Elemental-kit (KeybindingData) heeft
	GEEN Earth Shock / Flame Shock / Fire Elemental / Hex / Frost Shock / Tremor Totem /
	Spirit Walk / Lightning Lasso. Die worden daarom NIET aan spec 262 gekoppeld (dat waren
	draft-aannames in de oude versie). Ele-movement = Gust of Wind (Q); Ele-CD = Stormkeeper (F1)
	+ Ascendance (Alt+F1); Ele-spenders = Elemental Blast (ST) + Earthquake (AoE).

	Niet opgenomen: Recuperate (globaal F4), heal_sustain/F4, racial, trinket, potion, passieven
	(Tempest 454009 = passieve Lightning Bolt-proc, geen eigen knop).
]]

ns.KeybindRoleClassifier.SHAMAN = {
	-- ============================================================
	-- Gedeelde class-baseline (alle 3 specs; 1 entry per naam)
	-- ============================================================
	["Wind Shear"] = { role = "interrupt", priority = 1 }, -- E (interrupt; JustAC InterruptAbilities/SpellCategories 57994)
	["Ghost Wolf"] = { role = "utility_primary", priority = 2 }, -- Shift+Q (travel; 2645)
	["Astral Shift"] = { role = "defensive_3", priority = 1 }, -- C (grote def, 40% DR; JustAC DefensiveEngine 108271)
	["Hex"] = { category = "dispel_cc", priority = 1 }, -- V (CC; JustAC SpellCategories 51514) -- alleen Enh bindt Hex live; baseline utility
	["Purge"] = { category = "dispel_cc", priority = 1 }, -- Ele V / Enh Shift+V (enemy dispel; JustAC SpellCategories 370)
	["Capacitor Totem"] = { category = "dispel_cc", priority = 2, alsoStop = "stun" }, -- T (AoE stun; JustAC InterruptAbilities [192058] cc mech=12) → Spec 08 alsoStop
	["Healing Surge"] = { role = "heal_quick", priority = 1 }, -- F2 (snelle combat self-heal-anker; JustAC SpellCategories 8004)
	["Bloodlust"] = { category = "cooldown", priority = 4 }, -- Shift+F2 (raid-haste, Horde; JustAC SpellCategories 2825)
	["Heroism"] = { category = "cooldown", priority = 4 }, -- Shift+F2 (raid-haste, Alliance; JustAC SpellCategories 32182)
	["Gust of Wind"] = { role = "utility_primary", priority = 1 }, -- Ele Q (movement; JustAC GapCloserEngine 192063)
	["Nature's Swiftness"] = { category = "utility", priority = 5 }, -- Ele Shift+R (instant next cast; 378081)

	-- ============================================================
	-- Elemental (262) -- KeybindingData live-bevestigd (leidend)
	-- ============================================================
	["Lava Burst"] = { category = "main_rotation", priority = 1, specs = { 262 } }, -- Ele 1 (kern-nuke, Lava Surge; 51505)
	["Voltaic Blaze"] = { category = "main_rotation", priority = 2, specs = { 262, 263 } }, -- Ele 2 + Enh 3 (instant filler, past FS toe; 470057)
	["Lightning Bolt"] = { category = "main_rotation", priority = 3, specs = { 262, 263 } }, -- Ele 3; Enh 4 (Maelstrom-builder; 188196)
	["Elemental Blast"] = { category = "spender", priority = 1, specs = { 262, 263 } }, -- Ele 4; Enh 5 (ST-spender; 117014)
	["Chain Lightning"] = { category = "main_rotation", priority = 6, bindKey = "Shift+1", specs = { 262, 263 } }, -- Ele Shift+1; Enh Shift+4 (AoE builder; 188443)
	["Earthquake"] = { category = "spender", priority = 7, bindKey = "Shift+4", specs = { 262 } }, -- Ele Shift+4 (AoE-spender; live 462620)
	["Spiritwalker's Grace"] = { role = "utility_secondary", priority = 1, specs = { 262, 264 } }, -- Ele+Resto F (cast-while-moving; JustAC GapCloserEngine 79206)
	["Skyfury"] = { category = "utility", priority = 2, specs = { 262 } }, -- Ele R (raid-buff, pre-combat; 462854)
	["Thunderstorm"] = { category = "utility", priority = 4, specs = { 262 } }, -- Ele X (AoE knockback + slow; JustAC SpellCategories 51490)
	["Earth Elemental"] = { category = "defensive", priority = 4, specs = { 262 } }, -- Ele Shift+C (extra def/pet; JustAC DefensiveEngine 198103)
	["Cleanse Spirit"] = { category = "dispel_cc", priority = 3, specs = { 262 } }, -- Ele Shift+V (friendly dispel; JustAC SpellCategories 51886)
	["Stormkeeper"] = { role = "cooldown_bar", priority = 1, specs = { 262, 263 } }, -- Ele F1 (burst-CD, live); Enh R (191634 Ele / 205495 Enh talent)

	-- ============================================================
	-- Enhancement (263) -- KeybindingData live-bevestigd (leidend)
	-- ============================================================
	["Stormstrike"] = { category = "main_rotation", priority = 1, specs = { 263 } }, -- Enh 1 (17364; Windstrike via Ascendance-macro)
	["Lava Lash"] = { category = "main_rotation", priority = 2, specs = { 263 } }, -- Enh 2 (Hot Hand; JustAC SpellArchetypes 60103)
	["Crash Lightning"] = { category = "main_rotation", priority = 6, bindKey = "Shift+1", specs = { 263 } }, -- Enh Shift+1 (AoE; JustAC SpellArchetypes 187874)
	["Sundering"] = { category = "main_rotation", priority = 6, bindKey = "Shift+2", specs = { 263 } }, -- Enh Shift+2 (AoE frontal; 197214)
	["Frost Shock"] = { role = "utility_secondary", priority = 1, specs = { 263 } }, -- Enh F (ranged slow; 196840)
	["Tremor Totem"] = { category = "utility", priority = 4 }, -- baseline alle specs (fear/charm break; 8143) — Ele/Resto binden 'm net zo goed
	["Wind Rush Totem"] = { category = "utility", priority = 3, specs = { 263 } }, -- Enh Shift+T (movement-speed utility; JustAC 192077)
	["Spirit Walk"] = { role = "utility_primary", priority = 1, specs = { 263 } }, -- Enh Q (snare-break movement; JustAC GapCloserEngine 58875)
	["Feral Spirit"] = { role = "cooldown_bar", priority = 1, specs = { 263 } }, -- Enh F1 (wolves, grote CD; 51533)
	["Doom Winds"] = { category = "cooldown", priority = 3, specs = { 263 } }, -- Enh Shift+F1 (burst; 384352)
	["Primordial Wave"] = { category = "cooldown", priority = 4, specs = { 263 } }, -- Enh Shift+R (burst-CD: damage + Flame Shock spread, buft next LB/HW; 375982)

	-- ============================================================
	-- Gedeeld Enh + Ele: grootste extra CD
	-- ============================================================
	["Ascendance"] = { category = "cooldown", priority = 3, specs = { 262, 263, 264 } }, -- Enh/Ele Alt+F1 (burst-CD 114050); Resto (heal-CD: injured allies binnen 20yd instant geheald; 114049)

	-- ============================================================
	-- Restoration (264) -- healer (v6 6-splitsing; Midnight 12.0.7 bevestigd via Method-gids).
	-- ST-heals + ST-HoTs (Riptide/Healing Wave/Healing Surge/Unleash Life) -> role="click_cast"
	--   (mouseover/click-cast, GEEN eigen toets).
	-- Raid/AoE/smart-heals op toets: Chain Heal/Healing Rain/Downpour/Surging Totem/Healing Stream Totem.
	-- Heal-COOLDOWNS: Healing Tide Totem (cooldown_bar), Spirit Link Totem, Ascendance (Resto).
	-- Never-lie: Wellspring / Cloudburst Totem / Ancestral Guidance zijn in Midnight VERWIJDERD -> niet opgenomen.
	-- ============================================================
	-- ST-heals + ST-HoTs -> click_cast (mouseover/click-cast; GEEN toets). v6 6.
	["Riptide"] = { role = "click_cast", priority = 1, specs = { 264 } }, -- Resto ST-HoT (instant HoT; mouseover/click-cast; 61295)
	["Healing Wave"] = { role = "click_cast", priority = 1, specs = { 264 } }, -- Resto ST-heal (mana-efficiente filler; mouseover/click-cast; 77472)
	-- Healing Surge NIET dubbel opgenomen: de class-baseline heal_quick (F2, alle specs, persoonlijke noodheal) hierboven blijft leidend; 1 key kan niet splitsen. (never-lie / geen dubbele key die de baseline zou overschrijven)
	["Unleash Life"] = { role = "click_cast", priority = 1, specs = { 264 } }, -- Resto ST-heal-buff (buft next cast op doel; mouseover/click-cast; 73685)
	-- Raid/AoE/smart-heals -> toets.
	["Chain Heal"] = { category = "raid_heal", priority = 2, specs = { 264 } }, -- Resto (smart multi-target heal, toets; 1064)
	["Healing Rain"] = { category = "raid_heal", priority = 2, specs = { 264 } }, -- Resto (ground-AoE heal, toets; JustAC SpellCategories 73920)
	["Downpour"] = { category = "raid_heal", priority = 3, specs = { 264 } }, -- Resto (AoE-burst-heal, toets; 462486)
	["Surging Totem"] = { category = "raid_heal", priority = 4, specs = { 264 } }, -- Resto (heal/damage-totem, on cooldown, toets; 444995)
	["Purify Spirit"] = { category = "dispel_cc", priority = 1, specs = { 264 } }, -- Resto V (curse/magic dispel; JustAC DefensiveEngine 77130)
	["Healing Tide Totem"] = { role = "cooldown_bar", priority = 1, specs = { 264 } }, -- Resto F1 (raid-heal-burst; JustAC DefensiveEngine 108280)
	["Spirit Link Totem"] = { category = "cooldown", priority = 2, specs = { 264 } }, -- Resto R (HP-verdeling raid-CD; JustAC DefensiveEngine 98008)
	["Healing Stream Totem"] = { role = "utility_secondary", priority = 1, specs = { 264 } }, -- Resto F (passieve group-heal; JustAC SpellCategories 5394)
	["Ancestral Spirit"] = { category = "utility", priority = 3, specs = { 264 } }, -- Resto T (out-of-combat rez; JustAC SpellCategories 2008)
}
