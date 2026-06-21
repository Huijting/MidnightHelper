--[[
	Midnight Helper — Midnight Codex (handbook) strings.
	enUS + nlNL; other UI packs fall back to enUS via ns:L().
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
	TAB_CODEX = "Midnight Codex",
	CODEX_PANEL_TITLE = "Midnight Codex",
	CODEX_PANEL_INTRO = "Your Midnight Season 1 handbook — what each system is, what currency does what, and where to click in this addon. Hover currency icons for Blizzard tooltips.",
	CODEX_OPEN_TAB_FMT = "Open: %s",
	CODEX_NAV_DELVES_VAULT = "Delves & Vault tab (Great Vault block)",
	CODEX_NAV_DELVES_MIDNIGHT = "Delves & Vault tab (delve list)",
	CODEX_NAV_BASICS_DAWN = "Basics tab (Dawncrests)",
	CODEX_NAV_BASICS_PROF = "Basics tab (Professions guide)",
	CODEX_BALANCE_FMT = "You have: |cffffffff%d|r",
	CODEX_BALANCE_UNKNOWN = "Balance updates when you log in on this character.",
	CODEX_SEARCH_OPENED = "Opened Midnight Codex.",
	CODEX_BETA_DISABLED = "Midnight Codex is disabled in Settings (beta tabs).",

	CODEX_CAT_START = "Start Here",
	CODEX_CAT_WEEKLY = "Weekly loop",
	CODEX_CAT_CURRENCIES = "Currencies",
	CODEX_CAT_DELVES = "Delves",
	CODEX_CAT_DUNGEONS = "Dungeons & M+",
	CODEX_CAT_RAID = "Raid & crests",
	CODEX_CAT_WORLD = "Void & Rituals",
	CODEX_CAT_PROFESSIONS = "Professions",

	CODEX_START_TITLE = "Start Here — your Midnight week",
	CODEX_START_BODY = "|cffffcc00Think in layers:|r one weekly reset, several reward tracks. You do not need every system every day — pick a goal.|n|n|cffffff781) Account & reset|r|n• Check |cffffffffHome -> This Week|r for vault ready, world boss, keys, and chores.|n• |cffffffffAccount snapshot|r shows all alts (vault, Delver's Call, profession weeklies).|n|n|cffffff782) Combat content|r|n• |cffffffffDelves|r — main gearing track (keys, tiers, Great Vault slots). Use |cffffffffDelve Coach|r for tips per delve.|n• |cffffffffMythic+|r and |cffffffffRaid|r fill other Great Vault slots (see Dungeons & Raid categories).|n|n|cffffff783) Open world (12.0.5)|r|n• |cffffffffVoid & Rituals|r tab — Field Accolades, Ritual Sites, Void Assaults (same renown track).|n• |cffffffffRares|r tab — weekly rare loot and routes.|n|n|cffffff784) Crafting|r|n• |cffffffffProfessions|r tab for KP / weekly mats; |cffffffffBasics|r for Dawncrest crests.|n|n|cffffcc00Tip:|r open the |cffffffffCurrencies|r category here when you forget what a token is for. Scroll the boss preview in Delve Coach to zoom.",

	CODEX_WEEKLY_RESET_TITLE = "Weekly reset",
	CODEX_WEEKLY_RESET_BODY = "• Most weekly progress resets on your region's maintenance day (EU Wednesday morning, US Tuesday morning).|n• Great Vault choices, world boss loot, many weekly caps, and Delver's Call deliveries reset.|n• |cffffffffHome -> This Week|r shows time until reset when the API provides it.|n• Plan alts: snapshot tab compares who still owes vault, boss, or Delver's Call.",

	CODEX_VAULT_TITLE = "Great Vault",
	CODEX_VAULT_BODY = "• Three tracks: |cffffffffWorld|r (delves + world content), |cffffffffDungeons|r (M+), |cffffffffRaid|r.|n• Fill activities during the week; after reset you pick one reward per unlocked slot at the vault NPC or via SHIFT-J.|n• |cffffffffVault Advisor|r (on Blizzard's vault UI) ranks options vs your equipped gear.|n• This addon shows all three tracks in the |cffffffffDelves & Vault|r tab — expand |cffffffffWeekly Great Vault (World)|r (not a separate tab yet).|n• Summary also on |cffffffffHome -> This Week|r and |cffffffffAccount snapshot|r.",

	CODEX_WORLDBOSS_TITLE = "World boss (Midnight S1)",
	CODEX_WORLDBOSS_BODY = "• One rotating world boss per week (Lu'ashal, Cragpine, Thorm'belan, Predaxas).|n• Warband loot: once any character kills it, alts show completed.|n• Tracked at the top of |cffffffffDelves & Vault|r with TomTom route.|n• Also linked from SMC City Guide when in Silvermoon.",
	CODEX_FOLIO_TITLE = "Omnium Folio (12.0.7)",
	CODEX_FOLIO_BODY = "• New mid-expansion power system — a minimap book of |cffffffffrunes|r you swap freely out of combat (no slot cost).|n• Power comes from the weekly |cffffffff'Seeking Knowledge'|r chain (5 weeks): The Omnium Folio, Ritualized Arcana, Leyline Assaults, Magical Primessence, Off-World Magic.|n• Each week rewards a |cffffffffMote of Omnial Inquiry|r to choose/empower a rune.|n• Finish all 5 for the meta achievement and the Sunstrider Omnium Simulacrum decor.|n• (Datamined — exact rune effects/IDs confirmed at launch.)",
	CODEX_TT_TITLE = "Turbulent Timeways (12.0.7)",
	CODEX_TT_BODY = "• Returning Timewalking event — this time a |cffffffffDragonflight|r dungeon pool: Algeth'ar Academy, Halls of Infusion, Neltharus, Ruby Life Pools, The Azure Vault, Brackenhide Hollow.|n• Weekly: run |cffffffff5 Timewalking dungeons|r for a gear cache; each run stacks |cffffffffKnowledge of Timeways|r (XP buff).|n• Earn |cffffffffMastery of Timeways|r in 4 of 6 weeks for 'Master of the Turbulent Timeways' and the |cffffffffSpawn of Vyranoth|r mount.|n• Spend Timewarped Badges at the event vendor.|n• Runs ~June 30 – Aug 11. (Datamined — confirm at launch.)",

	CODEX_DELVER_CALL_TITLE = "Delver's Call",
	CODEX_DELVER_CALL_BODY = "• Weekly delve objectives that grant a large XP burst when turned in.|n• You can |cffffffffbank|r completed calls (done objectives, not yet turned in) for a later character level.|n• |cffffffffAccount snapshot|r rolls up banked and pending calls across alts.|n• Hover the Delver's Call line in snapshot for per-character detail.",

	CODEX_ACCOUNT_TITLE = "Account snapshot",
	CODEX_ACCOUNT_BODY = "• Read-only overview of characters you've logged in on with Midnight Helper.|n• Sort/filter by vault ready, keys, Shards of Dundun cap, stale since reset, etc.|n• Use it to answer: \"Which alt still needs vault / boss / Delver's Call?\"|n• Does not replace logging onto an alt for gear or quest checks.",

	CODEX_CUR_COFFER_KEY_TITLE = "Restored Coffer Key",
	CODEX_CUR_COFFER_KEY_BODY = "• Opens Midnight delves (like previous expansion keys).|n• Earn from world content, weeklies, and vendors; no hard weekly cap on holding keys.|n• Shown on |cffffffffDelves & Vault|r with your current count.",

	CODEX_CUR_SHARDS_TITLE = "Coffer Key Shards",
	CODEX_CUR_SHARDS_BODY = "• Combine into Restored Coffer Keys (100 shards -> 1 key at the standard rate).|n• Weekly earn cap applies to shards — track \"Weekly: X / Y\" on the Delves tab.|n• Cap fills faster if you run more delves or complete shard sources.",

	CODEX_CUR_UNDERCOIN_TITLE = "Undercoin",
	CODEX_CUR_UNDERCOIN_BODY = "• Vendor currency for delve-related goods (curios, upgrades, convenience items).|n• Earn primarily from running delves and delve rewards.|n• Spend before hoarding blindly — check the delve vendor when you have a goal piece.",

	CODEX_CUR_MANA_TITLE = "Untainted Mana-Crystals",
	CODEX_CUR_MANA_BODY = "• Used for specific Midnight gear upgrades / vendor purchases (check current patch notes for exact vendors).|n• Earn from delves, world content, and weekly sources.|n• Account snapshot can show per-character totals.",

	CODEX_CUR_ACCOLADES_TITLE = "Field Accolades",
	CODEX_CUR_ACCOLADES_BODY = "• Shared currency for the |cffffffffVoid & Rituals|r systems (Ritual Sites + Void Assaults).|n• Weekly earn cap — after cap you still play for other rewards but stop gaining accolades until reset.|n• Spends on renown rewards at the Bazaar hub (Eversong / Zul'Aman).|n• Live count on |cffffffffVoid & Rituals|r tab.",

	CODEX_CUR_DAWN_TITLE = "Dawncrests (crests)",
	CODEX_CUR_DAWN_BODY = "• Raid-tier crafting currency (Great Vault raid slots, catalyst-adjacent progression).|n• Live crest counts are on |cffffffffBasics -> Dawncrests|r (not in this list).|n• Not the same as delve keys — see that guide for spend targets and weekly caps.",

	CODEX_DELVES_INTRO_TITLE = "Midnight delves — overview",
	CODEX_DELVES_INTRO_BODY = "• Solo or small-group scenarios across Eversong, Harandar, Voidstorm, etc.|n• |cffffffffTier 1–11+|r — higher tier = harder enemies and better item level in the vault.|n• Costs a |cffffffffRestored Coffer Key|r per run (see Currencies).|n• |cffffffffBountiful|r delves (rotating) give extra loot — use \"Find Nearest Bountiful Delve\" on the Delves tab.",

	CODEX_DELVE_COACH_TITLE = "Delve Coach",
	CODEX_DELVE_COACH_BODY = "• Floating tips panel: route, trash, and boss mechanics per delve.|n• Opens automatically in a delve (optional) or via |cffffffffDelve Coach (preview tips)|r / |cffffffff/mh coach|r.|n• English or Dutch text follows `/mh lang`.|n• Boss spotlight: scroll on the model to zoom (saved per boss).|n• Blue spell names link to real spell tooltips when IDs are known.",

	CODEX_DELVE_CURIOS_TITLE = "Valeera & delve curios",
	CODEX_DELVE_CURIOS_BODY = "• Curios modify your next delve run (extra loot, easier bosses, etc.).|n• Valeera offers advice at repair/gossip NPCs — popup on Delves tab when relevant.|n• Track consumables and minimap buttons via delve items popup (RAID-R Mini, Trovehunter's Bounty).",

	CODEX_TORMENTS_TITLE = "Torment's Rise (Nemesis delve)",
	CODEX_TORMENTS_BODY = "• Capstone Nemesis delve in Voidstorm — separate instance portal, not a rotating world delve.|n• Unlocks on high delve tiers with limited lives (see in-game requirements).|n• Boss Nullaeus — heavy interrupt/DPS check; see Delve Coach for mechanics.|n• Weekly bounty can pull a weakened Nullaeus into a normal delve (Beacon of Hope).",

	CODEX_DELVE_LOG_TITLE = "Delve Log",
	CODEX_DELVE_LOG_BODY = "• History of recent delve runs (tiers, times, party).|n• Useful to remember which variant you finished or which boss was up.|n• Nearest-delve routing can send you to the closest entrance from your position.",

	CODEX_MPLUS_TITLE = "Mythic+ & dungeon vault",
	CODEX_MPLUS_BODY = "• M+ dungeons fill the |cffffffffDungeons|r Great Vault row (separate from delve/world rows).|n• Higher key level = higher item level in vault slot if you time the key.|n• Vault Advisor uses M+ stat weights when you claim dungeon vault loot.|n• Midnight Helper does not replace a route addon — use MDT / notes for affix weeks.",

	CODEX_RAID_VAULT_TITLE = "Raid Great Vault",
	CODEX_RAID_VAULT_BODY = "• Raid bosses progress raid vault slots (difficulty affects item level).|n• Normal / Heroic / Mythic each contribute — check vault UI for which bosses you've killed this week.|n• Crests (Dawncrests) often gate upgrade paths on raid gear.",

	CODEX_VAULT_ADVISOR_TITLE = "Great Vault Advisor",
	CODEX_VAULT_ADVISOR_BODY = "• Side panel on Blizzard's weekly reward UI when you claim Great Vault loot (SHIFT-J) — not inside Midnight Helper tabs.|n• Ranks vault pieces vs equipped gear using guide stat priorities (and optional Pawn).|n• Toggle in minimap quick settings / Esc -> AddOns -> Midnight Helper.|n• Auto vs Raid vs M+ profile for stat weights.",

	CODEX_WORLD_HUB_TITLE = "Void & Rituals — one system",
	CODEX_WORLD_HUB_BODY = "• Midnight 12.0.5 pairs |cffffffffRitual Sites|r (Eversong) and |cffffffffVoid Assaults|r (Zul'Aman) under one currency and renown.|n• Same |cffffffffField Accolades|r and Bazaar hub — do not grind them as unrelated farms.|n• Open the combined tab for live active site, weekly caps, and TomTom buttons.",

	CODEX_RITUAL_TITLE = "Ritual Sites",
	CODEX_RITUAL_BODY = "• Weekly rotating ritual in Eversong Woods — complete stages for accolades and loot.|n• Only one site is \"active\" at a time; addon highlights which.|n• SMC City Guide pin can jump you to the Ritual tab with context.",

	CODEX_VOID_TITLE = "Void Assaults",
	CODEX_VOID_BODY = "• Zul'Aman assault waves — defend objectives, earn accolades.|n• Shares weekly cap with ritual progress on the same currency.|n• Check assault timer / active zone on Void & Rituals tab.",

	CODEX_RARES_TITLE = "Midnight rares",
	CODEX_RARES_BODY = "• Weekly rare mobs with account/character loot (check each rare's rules in-game).|n• |cffffffffRares|r tab: track kills, build nearest route, TomTom arrow stays on closest pin.|n• Live alert when a tracked rare is nearby (~500 yds) — toggle in settings.",

	CODEX_PROF_TITLE = "Professions — weekly loop",
	CODEX_PROF_BODY = "• Knowledge Points (KP), Artisan's Moxie, Unalloyed Abundance, and Shards of Dundun are separate tracks.|n• |cffffffffProfessions|r tab shows unspent KP and weekly currencies per profession.|n• Crafting orders and treasures are not fully automated here — use Basics guide for KP spending.",

	CODEX_PROF_GUIDE_TITLE = "Professions beginner guide",
	CODEX_PROF_GUIDE_BODY = "• |cffffffffBasics -> Professions|r sub-tab: step-by-step KP plan and combo suggestions.|n• Dawncrests guide covers raid crafting currency (different from delve keys).|n• Re-read after patches — currency IDs and caps can change.",
})

merge(ns._mhLocales and ns._mhLocales.itIT, {
	TAB_CODEX = "Midnight Codex",
	CODEX_PANEL_TITLE = "Midnight Codex",
	CODEX_PANEL_INTRO = "Il tuo manuale per la Midnight Season 1 — cos'è ogni sistema, a cosa serve ogni currency e dove cliccare in questo addon. Passa il cursore sulle icone delle currency per i tooltip di Blizzard.",
	CODEX_OPEN_TAB_FMT = "Apri: %s",
	CODEX_NAV_DELVES_VAULT = "Scheda Delves & Vault (blocco Great Vault)",
	CODEX_NAV_DELVES_MIDNIGHT = "Scheda Delves & Vault (elenco delve)",
	CODEX_NAV_BASICS_DAWN = "Scheda Basics (Dawncrests)",
	CODEX_NAV_BASICS_PROF = "Scheda Basics (guida Professions)",
	CODEX_BALANCE_FMT = "Hai: |cffffffff%d|r",
	CODEX_BALANCE_UNKNOWN = "Il saldo si aggiorna quando accedi con questo personaggio.",
	CODEX_SEARCH_OPENED = "Midnight Codex aperto.",
	CODEX_BETA_DISABLED = "Midnight Codex è disattivato nelle Impostazioni (schede beta).",

	CODEX_CAT_START = "Inizia qui",
	CODEX_CAT_WEEKLY = "Ciclo settimanale",
	CODEX_CAT_CURRENCIES = "Currencies",
	CODEX_CAT_DELVES = "Delves",
	CODEX_CAT_DUNGEONS = "Dungeons & M+",
	CODEX_CAT_RAID = "Raid & crests",
	CODEX_CAT_WORLD = "Void & Rituals",
	CODEX_CAT_PROFESSIONS = "Professions",

	CODEX_START_TITLE = "Inizia qui — la tua settimana Midnight",
	CODEX_START_BODY = "|cffffcc00Ragiona a livelli:|r un weekly reset, diverse tracce di ricompensa. Non ti serve ogni sistema ogni giorno — scegli un obiettivo.|n|n|cffffff781) Account & reset|r|n• Controlla |cffffffffHome -> This Week|r per vault pronta, world boss, key e faccende.|n• |cffffffffAccount snapshot|r mostra tutti gli alt (vault, Delver's Call, weekly delle profession).|n|n|cffffff782) Contenuti di combattimento|r|n• |cffffffffDelves|r — traccia principale di gearing (key, tier, slot della Great Vault). Usa |cffffffffDelve Coach|r per i consigli su ogni delve.|n• |cffffffffMythic+|r e |cffffffffRaid|r riempiono gli altri slot della Great Vault (vedi le categorie Dungeons & Raid).|n|n|cffffff783) Mondo aperto (12.0.5)|r|n• Scheda |cffffffffVoid & Rituals|r — Field Accolades, Ritual Sites, Void Assaults (stessa traccia di renown).|n• Scheda |cffffffffRares|r — loot rare settimanale e percorsi.|n|n|cffffff784) Crafting|r|n• Scheda |cffffffffProfessions|r per KP / mat settimanali; |cffffffffBasics|r per i crest Dawncrest.|n|n|cffffcc00Consiglio:|r apri qui la categoria |cffffffffCurrencies|r quando non ricordi a cosa serve un token. Scorri l'anteprima del boss in Delve Coach per zoomare.",

	CODEX_WEEKLY_RESET_TITLE = "Weekly reset",
	CODEX_WEEKLY_RESET_BODY = "• La maggior parte dei progressi settimanali si resetta nel giorno di manutenzione della tua regione (EU mercoledì mattina, US martedì mattina).|n• Si resettano le scelte della Great Vault, il loot del world boss, molti cap settimanali e le consegne della Delver's Call.|n• |cffffffffHome -> This Week|r mostra il tempo al reset quando l'API lo fornisce.|n• Pianifica gli alt: la scheda snapshot confronta chi deve ancora vault, boss o Delver's Call.",

	CODEX_VAULT_TITLE = "Great Vault",
	CODEX_VAULT_BODY = "• Tre tracce: |cffffffffWorld|r (delve + contenuti del mondo), |cffffffffDungeons|r (M+), |cffffffffRaid|r.|n• Riempi le attività durante la settimana; dopo il reset scegli una ricompensa per ogni slot sbloccato dall'NPC della vault o con SHIFT-J.|n• |cffffffffVault Advisor|r (sull'UI vault di Blizzard) classifica le opzioni rispetto al tuo equip.|n• Questo addon mostra tutte e tre le tracce nella scheda |cffffffffDelves & Vault|r — espandi |cffffffffWeekly Great Vault (World)|r (non è ancora una scheda separata).|n• Riepilogo anche in |cffffffffHome -> This Week|r e |cffffffffAccount snapshot|r.",

	CODEX_WORLDBOSS_TITLE = "World boss (Midnight S1)",
	CODEX_WORLDBOSS_BODY = "• Un world boss a rotazione per settimana (Lu'ashal, Cragpine, Thorm'belan, Predaxas).|n• Loot Warband: una volta che un personaggio lo uccide, gli alt risultano completati.|n• Tracciato in cima a |cffffffffDelves & Vault|r con percorso TomTom.|n• Collegato anche dalla SMC City Guide quando sei a Silvermoon.",
	CODEX_FOLIO_TITLE = "Omnium Folio (12.0.7)",
	CODEX_FOLIO_BODY = "• Nuovo sistema di potere di metà espansione — un libro sulla minimappa di |cffffffffrune|r che scambi liberamente fuori dal combattimento (nessun costo di slot).|n• Il potere arriva dalla catena settimanale |cffffffff'Seeking Knowledge'|r (5 settimane): The Omnium Folio, Ritualized Arcana, Leyline Assaults, Magical Primessence, Off-World Magic.|n• Ogni settimana ricompensa un |cffffffffMote of Omnial Inquiry|r per scegliere/potenziare una runa.|n• Completa tutte e 5 per il meta achievement e l'arredo Sunstrider Omnium Simulacrum.|n• (Da datamining — effetti/ID esatti delle rune confermati al lancio.)",
	CODEX_TT_TITLE = "Turbulent Timeways (12.0.7)",
	CODEX_TT_BODY = "• Evento Timewalking di ritorno — questa volta un pool di dungeon |cffffffffDragonflight|r: Algeth'ar Academy, Halls of Infusion, Neltharus, Ruby Life Pools, The Azure Vault, Brackenhide Hollow.|n• Settimanale: completa |cffffffff5 dungeon Timewalking|r per un cache di gear; ogni run accumula |cffffffffKnowledge of Timeways|r (buff XP).|n• Ottieni |cffffffffMastery of Timeways|r in 4 settimane su 6 per 'Master of the Turbulent Timeways' e la cavalcatura |cffffffffSpawn of Vyranoth|r.|n• Spendi i Timewarped Badges dal venditore dell'evento.|n• Attivo dal ~30 giugno all'11 ago. (Da datamining — confermare al lancio.)",

	CODEX_DELVER_CALL_TITLE = "Delver's Call",
	CODEX_DELVER_CALL_BODY = "• Obiettivi settimanali delle delve che concedono un grosso burst di XP alla consegna.|n• Puoi |cffffffffmettere in banca|r le call completate (obiettivi fatti, non ancora consegnati) per un livello successivo del personaggio.|n• |cffffffffAccount snapshot|r riepiloga le call in banca e in sospeso tra gli alt.|n• Passa il cursore sulla riga Delver's Call nello snapshot per il dettaglio per personaggio.",

	CODEX_ACCOUNT_TITLE = "Account snapshot",
	CODEX_ACCOUNT_BODY = "• Panoramica in sola lettura dei personaggi con cui hai effettuato l'accesso usando Midnight Helper.|n• Ordina/filtra per vault pronta, key, cap di Shards of Dundun, inattivi dal reset, ecc.|n• Usalo per rispondere: \"Quale alt deve ancora vault / boss / Delver's Call?\"|n• Non sostituisce l'accesso a un alt per controllare gear o quest.",

	CODEX_CUR_COFFER_KEY_TITLE = "Restored Coffer Key",
	CODEX_CUR_COFFER_KEY_BODY = "• Apre le delve Midnight (come le key delle espansioni precedenti).|n• Si ottiene da contenuti del mondo, weekly e venditori; nessun cap settimanale rigido sul numero di key che puoi tenere.|n• Mostrata in |cffffffffDelves & Vault|r con il tuo conteggio attuale.",

	CODEX_CUR_SHARDS_TITLE = "Coffer Key Shards",
	CODEX_CUR_SHARDS_BODY = "• Si combinano in Restored Coffer Keys (100 shard -> 1 key al tasso standard).|n• C'è un cap settimanale di guadagno sugli shard — controlla \"Weekly: X / Y\" nella scheda Delves.|n• Il cap si riempie più in fretta se fai più delve o completi le fonti di shard.",

	CODEX_CUR_UNDERCOIN_TITLE = "Undercoin",
	CODEX_CUR_UNDERCOIN_BODY = "• Currency da venditore per beni legati alle delve (curio, upgrade, oggetti di comodità).|n• Si ottiene principalmente facendo delve e dalle ricompense delle delve.|n• Spendili prima di accumularli alla cieca — controlla il venditore delle delve quando hai un pezzo obiettivo.",

	CODEX_CUR_MANA_TITLE = "Untainted Mana-Crystals",
	CODEX_CUR_MANA_BODY = "• Usati per specifici upgrade di gear Midnight / acquisti da venditore (controlla le patch notes attuali per i venditori esatti).|n• Si ottengono da delve, contenuti del mondo e fonti settimanali.|n• Account snapshot può mostrare i totali per personaggio.",

	CODEX_CUR_ACCOLADES_TITLE = "Field Accolades",
	CODEX_CUR_ACCOLADES_BODY = "• Currency condivisa per i sistemi |cffffffffVoid & Rituals|r (Ritual Sites + Void Assaults).|n• C'è un cap settimanale di guadagno — dopo il cap continui a giocare per altre ricompense ma smetti di guadagnare accolades fino al reset.|n• Si spendono per le ricompense di renown all'hub Bazaar (Eversong / Zul'Aman).|n• Conteggio in tempo reale nella scheda |cffffffffVoid & Rituals|r.",

	CODEX_CUR_DAWN_TITLE = "Dawncrests (crests)",
	CODEX_CUR_DAWN_BODY = "• Currency di crafting di raid-tier (slot raid della Great Vault, progressione affine al catalyst).|n• I conteggi dei crest in tempo reale sono in |cffffffffBasics -> Dawncrests|r (non in questo elenco).|n• Non sono come le key delle delve — vedi quella guida per gli obiettivi di spesa e i cap settimanali.",

	CODEX_DELVES_INTRO_TITLE = "Midnight delves — panoramica",
	CODEX_DELVES_INTRO_BODY = "• Scenari in solitaria o in piccolo gruppo tra Eversong, Harandar, Voidstorm, ecc.|n• |cffffffffTier 1–11+|r — tier più alto = nemici più difficili e item level migliore nella vault.|n• Costa una |cffffffffRestored Coffer Key|r a run (vedi Currencies).|n• Le delve |cffffffffBountiful|r (a rotazione) danno loot extra — usa \"Find Nearest Bountiful Delve\" nella scheda Delves.",

	CODEX_DELVE_COACH_TITLE = "Delve Coach",
	CODEX_DELVE_COACH_BODY = "• Pannello di consigli fluttuante: percorso, trash e meccaniche dei boss per ogni delve.|n• Si apre automaticamente in una delve (opzionale) o tramite |cffffffffDelve Coach (preview tips)|r / |cffffffff/mh coach|r.|n• Il testo in inglese o olandese segue `/mh lang`.|n• Spotlight sul boss: scorri sul modello per zoomare (salvato per ogni boss).|n• I nomi delle spell in blu rimandano ai tooltip reali delle spell quando gli ID sono noti.",

	CODEX_DELVE_CURIOS_TITLE = "Valeera & delve curios",
	CODEX_DELVE_CURIOS_BODY = "• I curio modificano la tua prossima run di delve (loot extra, boss più facili, ecc.).|n• Valeera offre consigli presso gli NPC di riparazione/gossip — popup nella scheda Delves quando pertinente.|n• Traccia consumabili e pulsanti della minimappa tramite il popup degli oggetti delve (RAID-R Mini, Trovehunter's Bounty).",

	CODEX_TORMENTS_TITLE = "Torment's Rise (Nemesis delve)",
	CODEX_TORMENTS_BODY = "• Delve Nemesis capostipite in Voidstorm — portale per un'istanza separata, non una delve del mondo a rotazione.|n• Si sblocca ai tier alti delle delve con vite limitate (vedi i requisiti in-game).|n• Boss Nullaeus — pesante check di interrupt/DPS; vedi Delve Coach per le meccaniche.|n• La bounty settimanale può attirare un Nullaeus indebolito in una delve normale (Beacon of Hope).",

	CODEX_DELVE_LOG_TITLE = "Delve Log",
	CODEX_DELVE_LOG_BODY = "• Cronologia delle run di delve recenti (tier, tempi, gruppo).|n• Utile per ricordare quale variante hai finito o quale boss era attivo.|n• Il routing verso la delve più vicina può mandarti all'ingresso più vicino alla tua posizione.",

	CODEX_MPLUS_TITLE = "Mythic+ & vault dei dungeon",
	CODEX_MPLUS_BODY = "• I dungeon M+ riempiono la riga |cffffffffDungeons|r della Great Vault (separata dalle righe delve/world).|n• Key di livello più alto = item level più alto nello slot vault se completi la key nei tempi.|n• Vault Advisor usa i pesi delle stat M+ quando reclami il loot vault dei dungeon.|n• Midnight Helper non sostituisce un addon di route — usa MDT / note per le settimane degli affix.",

	CODEX_RAID_VAULT_TITLE = "Raid Great Vault",
	CODEX_RAID_VAULT_BODY = "• I boss di raid fanno progredire gli slot raid della vault (la difficoltà influisce sull'item level).|n• Normal / Heroic / Mythic contribuiscono ciascuno — controlla l'UI della vault per vedere quali boss hai ucciso questa settimana.|n• I crest (Dawncrests) spesso limitano i percorsi di upgrade del gear di raid.",

	CODEX_VAULT_ADVISOR_TITLE = "Great Vault Advisor",
	CODEX_VAULT_ADVISOR_BODY = "• Pannello laterale sull'UI delle ricompense settimanali di Blizzard quando reclami il loot della Great Vault (SHIFT-J) — non dentro le schede di Midnight Helper.|n• Classifica i pezzi della vault rispetto al gear equipaggiato usando le priorità di stat della guida (e Pawn opzionale).|n• Attiva/disattiva nelle impostazioni rapide della minimappa / Esc -> AddOns -> Midnight Helper.|n• Profilo Auto vs Raid vs M+ per i pesi delle stat.",

	CODEX_WORLD_HUB_TITLE = "Void & Rituals — un unico sistema",
	CODEX_WORLD_HUB_BODY = "• Midnight 12.0.5 abbina |cffffffffRitual Sites|r (Eversong) e |cffffffffVoid Assaults|r (Zul'Aman) sotto un'unica currency e renown.|n• Stesse |cffffffffField Accolades|r e hub Bazaar — non farmarli come attività scollegate.|n• Apri la scheda combinata per il sito attivo, i cap settimanali e i pulsanti TomTom in tempo reale.",

	CODEX_RITUAL_TITLE = "Ritual Sites",
	CODEX_RITUAL_BODY = "• Rituale settimanale a rotazione in Eversong Woods — completa le fasi per accolades e loot.|n• Solo un sito è \"attivo\" alla volta; l'addon evidenzia quale.|n• Il pin della SMC City Guide può portarti alla scheda Ritual con il contesto.",

	CODEX_VOID_TITLE = "Void Assaults",
	CODEX_VOID_BODY = "• Ondate di assalto a Zul'Aman — difendi gli obiettivi, guadagna accolades.|n• Condivide il cap settimanale con il progresso dei ritual sulla stessa currency.|n• Controlla il timer dell'assalto / la zona attiva nella scheda Void & Rituals.",

	CODEX_RARES_TITLE = "Midnight rares",
	CODEX_RARES_BODY = "• Mob rari settimanali con loot per account/personaggio (controlla in-game le regole di ogni rare).|n• Scheda |cffffffffRares|r: traccia le uccisioni, crea il percorso più vicino, la freccia TomTom resta sul pin più vicino.|n• Avviso in tempo reale quando un rare tracciato è vicino (~500 yd) — attiva/disattiva nelle impostazioni.",

	CODEX_PROF_TITLE = "Professions — ciclo settimanale",
	CODEX_PROF_BODY = "• Knowledge Points (KP), Artisan's Moxie, Unalloyed Abundance e Shards of Dundun sono tracce separate.|n• La scheda |cffffffffProfessions|r mostra i KP non spesi e le currency settimanali per profession.|n• Gli ordini di crafting e i tesori non sono completamente automatizzati qui — usa la guida Basics per spendere i KP.",

	CODEX_PROF_GUIDE_TITLE = "Professions beginner guide",
	CODEX_PROF_GUIDE_BODY = "• Sotto-scheda |cffffffffBasics -> Professions|r: piano KP passo passo e suggerimenti di combo.|n• La guida Dawncrests copre la currency di crafting di raid (diversa dalle key delle delve).|n• Rileggi dopo le patch — gli ID delle currency e i cap possono cambiare.",
})

merge(ns._mhLocales and ns._mhLocales.nlNL, {
	TAB_CODEX = "Midnight Codex",
	CODEX_PANEL_TITLE = "Midnight Codex",
	CODEX_PANEL_INTRO = "Jouw Midnight Season 1-handboek — wat elk systeem is, welke currency waarvoor dient, en waar je in deze addon moet klikken. Hover currency-iconen voor Blizzard-tooltips.",
	CODEX_OPEN_TAB_FMT = "Open: %s",
	CODEX_NAV_DELVES_VAULT = "Tab Delves & Vault (Great Vault-blok)",
	CODEX_NAV_DELVES_MIDNIGHT = "Tab Delves & Vault (delve-lijst)",
	CODEX_NAV_BASICS_DAWN = "Tab Basics (Dawncrests)",
	CODEX_NAV_BASICS_PROF = "Tab Basics (Professions-gids)",
	CODEX_BALANCE_FMT = "Je hebt: |cffffffff%d|r",
	CODEX_BALANCE_UNKNOWN = "Saldo werkt bij na inloggen op dit personage.",
	CODEX_SEARCH_OPENED = "Midnight Codex geopend.",
	CODEX_BETA_DISABLED = "Midnight Codex staat uit in Instellingen (beta-tabs).",

	CODEX_CAT_START = "Start Here",
	CODEX_CAT_WEEKLY = "Weeklijkse loop",
	CODEX_CAT_CURRENCIES = "Currencies",
	CODEX_CAT_DELVES = "Delves",
	CODEX_CAT_DUNGEONS = "Dungeons & M+",
	CODEX_CAT_RAID = "Raid & crests",
	CODEX_CAT_WORLD = "Void & Rituals",
	CODEX_CAT_PROFESSIONS = "Professions",

	CODEX_START_TITLE = "Start Here — jouw Midnight-week",
	CODEX_START_BODY = "|cffffcc00Denk in lagen:|r één weekly reset, meerdere beloningslijnen. Je hoeft niet alles elke dag te doen — kies een doel.|n|n|cffffff781) Account & reset|r|n• Check |cffffffffHome -> This Week|r voor vault, world boss, keys en weektaken.|n• |cffffffffAccount snapshot|r toont al je alts (vault, Delver's Call, profession-weeklies).|n|n|cffffff782) Combat content|r|n• |cffffffffDelves|r — hoofdgear-track (keys, tiers, Great Vault-slots). Gebruik |cffffffffDelve Coach|r voor tips per delve.|n• |cffffffffMythic+|r en |cffffffffRaid|r vullen andere vault-slots (zie categorieën Dungeons & Raid).|n|n|cffffff783) Open wereld (12.0.5)|r|n• Tab |cffffffffVoid & Rituals|r — Field Accolades, Ritual Sites, Void Assaults (zelfde renown).|n• Tab |cffffffffRares|r — weekly rare loot en routes.|n|n|cffffff784) Crafting|r|n• Tab |cffffffffProfessions|r voor KP / weekly mats; |cffffffffBasics|r voor Dawncrest-crests.|n|n|cffffcc00Tip:|r open de categorie |cffffffffCurrencies|r als je een token bent vergeten. Scroll op het baas-beeld in Delve Coach om te zoomen.",

	CODEX_WEEKLY_RESET_TITLE = "Weekly reset",
	CODEX_WEEKLY_RESET_BODY = "• Het meeste weekly progress reset op onderhoudsdag (EU woensdag ochtend, US dinsdag ochtend).|n• Great Vault, world boss, veel weekly caps en Delver's Call resetten.|n• |cffffffffHome -> This Week|r toont tijd tot reset als de API dat geeft.|n• Plan alts: snapshot-tab vergelijkt wie nog vault, boss of Delver's Call schuldig is.",

	CODEX_VAULT_TITLE = "Great Vault",
	CODEX_VAULT_BODY = "• Drie sporen: |cffffffffWorld|r (delves + world), |cffffffffDungeons|r (M+), |cffffffffRaid|r.|n• Vul activiteiten in de week; na reset kies je één beloning per slot bij de vault-NPC of SHIFT-J.|n• |cffffffffVault Advisor|r (op Blizzard vault-UI) rangschikt opties vs je gear.|n• De addon toont alle drie sporen op tab |cffffffffDelves & Vault|r — klapt |cffffffffWeekly Great Vault (World)|r open (nog geen aparte tab).|n• Samenvatting ook op |cffffffffHome -> This Week|r en |cffffffffAccount snapshot|r.",

	CODEX_WORLDBOSS_TITLE = "World boss (Midnight S1)",
	CODEX_WORLDBOSS_BODY = "• Eén roterende world boss per week (Lu'ashal, Cragpine, Thorm'belan, Predaxas).|n• Warband-loot: killt één char, alts tonen klaar.|n• Bovenaan |cffffffffDelves & Vault|r met TomTom-route.|n• Ook via SMC City Guide in Silvermoon.",
	CODEX_FOLIO_TITLE = "Omnium Folio (12.0.7)",
	CODEX_FOLIO_BODY = "• Nieuw power-systeem — een minimap-boek met |cffffffffrunen|r die je vrij wisselt buiten combat (geen slot nodig).|n• Power komt uit de wekelijkse |cffffffff'Seeking Knowledge'|r-keten (5 weken): The Omnium Folio, Ritualized Arcana, Leyline Assaults, Magical Primessence, Off-World Magic.|n• Elke week levert een |cffffffffMote of Omnial Inquiry|r om een rune te kiezen/versterken.|n• Alle 5 af = meta-achievement + de Sunstrider Omnium Simulacrum-decor.|n• (Gedataminet — exacte rune-effecten/IDs bij launch bevestigen.)",
	CODEX_TT_TITLE = "Turbulent Timeways (12.0.7)",
	CODEX_TT_BODY = "• Terugkerend Timewalking-event — nu een |cffffffffDragonflight|r-dungeonpool: Algeth'ar Academy, Halls of Infusion, Neltharus, Ruby Life Pools, The Azure Vault, Brackenhide Hollow.|n• Weekly: doe |cffffffff5 Timewalking-dungeons|r voor een gear-kist; elke run stapelt |cffffffffKnowledge of Timeways|r (XP-buff).|n• Verdien |cffffffffMastery of Timeways|r in 4 van 6 weken voor 'Master of the Turbulent Timeways' + het |cffffffffSpawn of Vyranoth|r-mount.|n• Geef Timewarped Badges uit bij de event-vendor.|n• Loopt ~30 juni – 11 aug. (Gedataminet — bij launch bevestigen.)",

	CODEX_DELVER_CALL_TITLE = "Delver's Call",
	CODEX_DELVER_CALL_BODY = "• Weekly delve-doelen met grote XP-beloning bij inleveren.|n• Je kunt calls |cffffffffbanken|r (klaar maar nog niet ingeleverd) voor een later level.|n• |cffffffffAccount snapshot|r telt banked/pending over alts.|n• Hover Delver's Call in snapshot voor detail per char.",

	CODEX_ACCOUNT_TITLE = "Account snapshot",
	CODEX_ACCOUNT_BODY = "• Overzicht van chars waar je op hebt ingelogd met Midnight Helper.|n• Sorteer/filter op vault ready, keys, Dundun-cap, stale sinds reset.|n• Beantwoordt: \"Welke alt moet nog vault / boss / Delver's Call?\"|n• Vervangt niet inloggen voor gear of quest-checks.",

	CODEX_CUR_COFFER_KEY_TITLE = "Restored Coffer Key",
	CODEX_CUR_COFFER_KEY_BODY = "• Opent Midnight-delves (zoals vorige expansion keys).|n• Verdien via world, weeklies en vendors; geen harde cap op voorraad.|n• Zichtbaar op |cffffffffDelves & Vault|r.",

	CODEX_CUR_SHARDS_TITLE = "Coffer Key Shards",
	CODEX_CUR_SHARDS_BODY = "• Combineer tot Restored Coffer Keys (100 shards -> 1 key).|n• Weekly earn cap op shards — \"Weekly: X / Y\" op Delves-tab.|n• Meer delves = sneller cap vullen.",

	CODEX_CUR_UNDERCOIN_TITLE = "Undercoin",
	CODEX_CUR_UNDERCOIN_BODY = "• Vendor-currency voor delve-spullen (curios, upgrades).|n• Vooral uit delves.|n• Check delve-vendor met een concreet upgrade-doel.",

	CODEX_CUR_MANA_TITLE = "Untainted Mana-Crystals",
	CODEX_CUR_MANA_BODY = "• Voor specifieke Midnight-upgrades / vendors (zie patch notes).|n• Uit delves, world en weeklies.|n• Snapshot kan totals per char tonen.",

	CODEX_CUR_ACCOLADES_TITLE = "Field Accolades",
	CODEX_CUR_ACCOLADES_BODY = "• Gedeelde currency voor |cffffffffVoid & Rituals|r (Ritual Sites + Void Assaults).|n• Weekly cap — daarna nog spelen, geen accolades tot reset.|n• Uitgeven aan renown in Bazaar-hub.|n• Live count op tab Void & Rituals.",

	CODEX_CUR_DAWN_TITLE = "Dawncrests (crests)",
	CODEX_CUR_DAWN_BODY = "• Raid-tier crafting currency.|n• Live crest-saldi staan op |cffffffffBasics -> Dawncrests|r (niet in deze lijst).|n• Niet hetzelfde als delve keys — zie die gids voor uitgaven en weekly caps.",

	CODEX_DELVES_INTRO_TITLE = "Midnight delves — overzicht",
	CODEX_DELVES_INTRO_BODY = "• Solo of kleine groep in Eversong, Harandar, Voidstorm, …|n• |cffffffffTier 1–11+|r — hogere tier = moeilijker en betere ilvl in vault.|n• Kost |cffffffffRestored Coffer Key|r per run.|n• |cffffffffBountiful|r delves geven extra loot — knop op Delves-tab.",

	CODEX_DELVE_COACH_TITLE = "Delve Coach",
	CODEX_DELVE_COACH_BODY = "• Zwevend tip-venster: route, trash en boss per delve.|n• Auto in delve of via preview-knop / |cffffffff/mh coach|r.|n• NL/EN via `/mh lang`.|n• Baas-beeld: scroll = zoom (opgeslagen per baas).|n• Blauwe spells = echte tooltips waar IDs bekend zijn.",

	CODEX_DELVE_CURIOS_TITLE = "Valeera & delve curios",
	CODEX_DELVE_CURIOS_BODY = "• Curios passen je volgende delve aan.|n• Valeera adviseert bij repair/gossip — popup op Delves-tab.|n• Delve items popup voor RAID-R Mini, Trovehunter's Bounty.",

	CODEX_TORMENTS_TITLE = "Torment's Rise (Nemesis delve)",
	CODEX_TORMENTS_BODY = "• Capstone Nemesis-delve in Voidstorm — eigen portal.|n• Hoge tiers + limited lives (zie game).|n• Baas Nullaeus — zware interrupt/DPS-check; zie Delve Coach.|n• Weekly bounty kan verzwakte Nullaeus in normale delve trekken.",

	CODEX_DELVE_LOG_TITLE = "Delve Log",
	CODEX_DELVE_LOG_BODY = "• Geschiedenis van recente runs.|n• Onthoud variant/baas.|n• Nearest-delve routing naar dichtstbijzijnde ingang.",

	CODEX_MPLUS_TITLE = "Mythic+ & dungeon vault",
	CODEX_MPLUS_BODY = "• M+ vult |cffffffffDungeons|r vault-rij.|n• Hogere key = hogere ilvl bij timed key.|n• Vault Advisor gebruikt M+-stat weights bij dungeon-loot.|n• Geen route-addon — gebruik MDT voor affix-weken.",

	CODEX_RAID_VAULT_TITLE = "Raid Great Vault",
	CODEX_RAID_VAULT_BODY = "• Raid-bazen vullen raid vault-slots (moeilijkheid = ilvl).|n• Normal/Heroic/Mythic tellen mee.|n• Dawncrests gaten vaak upgrades op raid-gear.",

	CODEX_VAULT_ADVISOR_TITLE = "Great Vault Advisor",
	CODEX_VAULT_ADVISOR_BODY = "• Zijpaneel op Blizzard weekly reward UI bij Great Vault claimen (SHIFT-J) — niet in een Midnight Helper-tab.|n• Rangschikt vs equipped gear (optioneel Pawn).|n• Toggle in minimap settings / Esc -> AddOns.|n• Auto / Raid / M+ profiel.",

	CODEX_WORLD_HUB_TITLE = "Void & Rituals — één systeem",
	CODEX_WORLD_HUB_BODY = "• 12.0.5 koppelt Ritual Sites (Eversong) en Void Assaults (Zul'Aman).|n• Zelfde |cffffffffField Accolades|r en Bazaar-hub.|n• Gecombineerde tab voor actieve site, caps en TomTom.",

	CODEX_RITUAL_TITLE = "Ritual Sites",
	CODEX_RITUAL_BODY = "• Weekly ritual in Eversong — accolades en loot.|n• Eén site tegelijk actief; addon markeert welke.|n• SMC-pin opent Ritual-tab.",

	CODEX_VOID_TITLE = "Void Assaults",
	CODEX_VOID_BODY = "• Zul'Aman assault-golven — accolades.|n• Deelt weekly cap met rituals.|n• Timer/actieve zone op Void & Rituals-tab.",

	CODEX_RARES_TITLE = "Midnight rares",
	CODEX_RARES_BODY = "• Weekly rares met account/char loot.|n• Tab Rares: kills, route, TomTom op dichtstbijzijnde.|n• Alert bij rare in de buurt (~500 yd) — toggle in settings.",

	CODEX_PROF_TITLE = "Professions — weekly loop",
	CODEX_PROF_BODY = "• KP, Artisan's Moxie, Unalloyed Abundance en Dundun-shards zijn apart.|n• Tab Professions toont unspent KP en weeklies.|n• Orders/treasures: zie Basics voor KP-plan.",

	CODEX_PROF_GUIDE_TITLE = "Professions beginner guide",
	CODEX_PROF_GUIDE_BODY = "• |cffffffffBasics -> Professions|r: KP-plan en combos.|n• Dawncrests = raid crafting currency.|n• Herlees na patches — caps/IDs kunnen wijzigen.",
})
