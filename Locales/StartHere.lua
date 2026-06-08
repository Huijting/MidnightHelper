--[[
	Midnight Helper — "Start Here" new-player roadmap (EN + NL).
	A guided first-week path that ties the existing systems together. Steps link
	to the relevant tab via ns.SelectTab; the weekly steps auto-tick from the same
	helpers the Home dashboard uses (never-lie: only ticked where a real signal
	exists). Line breaks |n.
]]

local _, ns = ...

local function merge(target, patch)
	if not target or not patch then
		return
	end
	for k, v in pairs(patch) do
		target[k] = v
	end
end

merge(ns._mhLocales and ns._mhLocales.enUS, {
	TAB_START_HERE = "Start Here",
	START_TITLE = "Start Here — new to Midnight",
	START_SUBTITLE = "Just hit max level and not sure what to do? This is the whole endgame, in order. Tap a step to jump straight to the tool for it; the weekly ones tick off on their own.",

	START_INTRO_HEADER = "The Midnight loop in a nutshell",
	START_INTRO_BODY = "Endgame is a weekly rhythm: lift your item level, tune your character, then each week fill your Great Vault from Delves, Ritual Sites and Void Assaults. Renown, professions and currencies layer on top once that loop feels routine.",

	START_S1_TITLE = "1. Lift your item level first",
	START_S1_BODY = "Start with the easy wins: do the Midnight campaign, grab gear from world quests and the renown milestone quests, and run regular Delves (plus Prey hunts and Heroic dungeons) to climb your item level. A few cheap crafted/AH pieces help too. Higher item level then opens the higher tiers where the real rewards are.",
	START_S1_NAV = "Open Delves",

	START_S2_TITLE = "2. Tune your character",
	START_S2_BODY = "Before harder content: pick your talents, grab the right flask, food, potion and enchants/gems for your spec, and set an interrupt + defensive macro. MH has a consumables checklist, ready-made macros (Toolbox) and rotation help (Role Academy).",
	START_S2_NAV = "Open Consumables",

	START_S3_TITLE = "3. Aim everything at the Great Vault",
	START_S3_BODY = "The Great Vault hands you one free reward each week. Its World row fills from Delves, Ritual Sites and Prey; dungeons and raid fill the other rows. Unlock as many slots as you can before reset.",
	START_S3_NAV = "Open Home",

	START_S4_TITLE = "4. Run your Delves",
	START_S4_BODY = "Delves are solo or small-group dungeons with Brann at your side — steady gear and the easiest World-row vault progress. Climb the regular tiers first; once you reach Tier 8 you can run Bountiful Delves (you need a Restored Coffer Key) for Champion gear and Hero-track vault picks. The Delve Coach gives per-delve tips you can share with your group.",
	START_S4_NAV = "Open Delves",

	START_S5_TITLE = "5. Ritual Sites & Void Assaults",
	START_S5_BODY = "Two more World-row activities, best once you're geared a bit (they give random Champion gear). Unlock Ritual Sites first via the \"Ritual Interest\" questline in Silvermoon; Void Assaults are the rotating outdoor zone event and your way in. At the Curious Obelisk you pick a tier + challenges — the Ritual Coach explains every one.",
	START_S5_NAV = "Open Void & Rituals",

	START_S6_TITLE = "6. Go deeper: renown, professions & currencies",
	START_S6_BODY = "Renown unlocks perks and cosmetics; professions make gear, consumables and gold (MH has a full beginner course); and the Bazaar vendors in Silvermoon turn your currencies into upgrades. Pick these up once the weekly loop is routine.",
	START_S6_NAV = "Open Professions 101",

	START_RESET_TITLE = "Reset day: do it all again",
	START_RESET_BODY = "Weeklies and the Great Vault reset every week — Wednesday on EU realms, Tuesday on US. Claim last week's vault first, then run the loop again. That's the whole game — welcome to Midnight!",

	START_WEEKLY_RITUAL = "Ritual Sites weekly",
	START_WEEKLY_VOID = "Void Assaults weekly",
	START_STATUS_DONE = "done this week",
	START_STATUS_TODO = "still to do this week",

	START_WEEKLY_SUMMARY_FMT = "This week: %d/%d weekly objectives done",
	START_VAULT_READY = "A Great Vault reward is waiting — claim it!",
	START_VAULT_NONE = "No vault reward waiting yet — keep filling it before reset.",
	START_DELVERCALL_FMT = "Delver's Call: %d/%d done this week",
})

merge(ns._mhLocales and ns._mhLocales.nlNL, {
	TAB_START_HERE = "Start Here",
	START_TITLE = "Start Here — nieuw in Midnight",
	START_SUBTITLE = "Net max level en geen idee wat je moet doen? Dit is de hele endgame, op volgorde. Klik een stap om direct naar de juiste tool te springen; de wekelijkse stappen vinken zichzelf af.",

	START_INTRO_HEADER = "De Midnight-loop in het kort",
	START_INTRO_BODY = "Endgame is een wekelijks ritme: verhoog je item level, stel je character af, en vul daarna elke week je Great Vault met Delves, Ritual Sites en Void Assaults. Renown, professies en currencies komen erbovenop zodra die loop routine wordt.",

	START_S1_TITLE = "1. Verhoog eerst je item level",
	START_S1_BODY = "Begin met de makkelijke winst: doe de Midnight-campaign, pak gear uit world quests en de renown-milestone-quests, en draai gewone Delves (plus Prey-hunts en Heroic dungeons) om je item level te klimmen. Een paar goedkope crafted/AH-stukken helpen ook. Een hoger item level opent dan de hogere tiers waar de echte beloningen zitten.",
	START_S1_NAV = "Open Delves",

	START_S2_TITLE = "2. Stel je character af",
	START_S2_BODY = "Vóór zwaardere content: kies je talents, pak de juiste flask, food, potion en enchants/gems voor je spec, en zet een interrupt- + defensive-macro. MH heeft een consumables-checklist, kant-en-klare macro's (Toolbox) en rotatie-hulp (Role Academy).",
	START_S2_NAV = "Open Consumables",

	START_S3_TITLE = "3. Richt alles op de Great Vault",
	START_S3_BODY = "De Great Vault geeft je elke week één gratis beloning. De World-rij vult met Delves, Ritual Sites en Prey; dungeons en raid vullen de andere rijen. Ontgrendel zoveel mogelijk slots vóór de reset.",
	START_S3_NAV = "Open Home",

	START_S4_TITLE = "4. Doe je Delves",
	START_S4_BODY = "Delves zijn solo- of kleine-groep-dungeons met Brann aan je zij — stabiele gear en de makkelijkste World-rij-vaultvoortgang. Klim eerst de gewone tiers; vanaf Tier 8 kun je Bountiful Delves doen (je hebt een Restored Coffer Key nodig) voor Champion-gear en Hero-track vault-picks. De Delve Coach geeft tips per delve die je kunt delen.",
	START_S4_NAV = "Open Delves",

	START_S5_TITLE = "5. Ritual Sites & Void Assaults",
	START_S5_BODY = "Nog twee World-rij-activiteiten, het best zodra je wat gear hebt (ze geven random Champion-gear). Ontgrendel Ritual Sites eerst via de \"Ritual Interest\"-questlijn in Silvermoon; Void Assaults zijn het roterende outdoor-zone-event en je toegang ertoe. Bij de Curious Obelisk kies je een tier + challenges — de Ritual Coach legt elke challenge uit.",
	START_S5_NAV = "Open Void & Rituals",

	START_S6_TITLE = "6. Ga dieper: renown, professies & currencies",
	START_S6_BODY = "Renown ontgrendelt perks en cosmetics; professies maken gear, consumables en goud (MH heeft een volledige beginnerscursus); en de Bazaar-vendors in Silvermoon zetten je currencies om in upgrades. Pak deze op zodra de weekly loop routine is.",
	START_S6_NAV = "Open Professions 101",

	START_RESET_TITLE = "Reset-dag: alles opnieuw",
	START_RESET_BODY = "Weeklies en de Great Vault resetten elke week — woensdag op EU-realms, dinsdag op US. Claim eerst de vault van vorige week, draai dan de loop opnieuw. Dat is het hele spel — welkom in Midnight!",

	START_WEEKLY_RITUAL = "Ritual Sites weekly",
	START_WEEKLY_VOID = "Void Assaults weekly",
	START_STATUS_DONE = "deze week gedaan",
	START_STATUS_TODO = "nog te doen deze week",

	START_WEEKLY_SUMMARY_FMT = "Deze week: %d/%d wekelijkse doelen gedaan",
	START_VAULT_READY = "Er wacht een Great Vault-beloning — claim 'm!",
	START_VAULT_NONE = "Nog geen vault-beloning klaar — blijf 'm vullen vóór de reset.",
	START_DELVERCALL_FMT = "Delver's Call: %d/%d gedaan deze week",
})
