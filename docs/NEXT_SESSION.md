# Midnight Helper — waar we staan

## ▶▶ 28 nov (Bouwchat 28-11): levend blok — "Low on health?" en de wand los (`/reload`)

673892d ✅ door Rob in het spel getest op hunter en priest (screenshots, via Sparring; afgevinkt). Rob via Sparring,
letterlijk: *"en ja voor low on health"* en op de wand-regel *"ja"*. ORDER_EXTRA.heal (Priest Renew + Lesser Heal, Paladin
Holy Light, Druid Rejuvenation + Healing Touch, Shaman Healing Wave, Warlock Drain Life) uit de rij → FHOWTO_EARLY_HEAL_FMT
met de echte toetsen ("A or B", FHOWTO_EARLY_OR). ORDER_EXTRA.wand = Shoot (Priest, Mage, Warlock) → FHOWTO_EARLY_WAND_FMT,
alleen als een bloktoets nu Shoot cast (Warlock: Shoot staat niet op het blok → nooit, niet gegokt). Life Tap ("low on
mana") blijft in de rij (niet gevraagd). 3 sleutels in 7 talen. live_test: Robs priest exact zoals zijn screenshot +
regels; Warlock zonder wand-regel.
AANVULLING zelfde ronde: Rob (Troll Warlock 8, screenshot via Sparring), letterlijk: *"life tap staat ook in de volgorde,
en eigenlijk moet je die gebruiken als je low op mana bent toch? en niet in een standaard rotatie??"* → ORDER_EXTRA.situ:
Warlock Life Tap → FHOWTO_EARLY_LIFETAP_FMT; nagelopen in alle class-Simple orders: Warrior Thunder Clap ("Several
enemies?") → FHOWTO_EARLY_AOE_FMT, Shaman Earth Shock ("for when the enemy casts") → FHOWTO_EARLY_INTERRUPT_FMT. Niet
gedaan: Bloodrage/Evocation/Innervate staan in geen Simple order; Rogue Backstab ("with a dagger, behind") blijft (een
gewone stap onder voorwaarde, niet duidelijk genoeg). 3 sleutels in 7 talen. live_test: Robs warlock 8 = zijn
screenshot zonder Life Tap in de rij + de losse regel.

## ▶▶ 28 nov (Bouwchat 28-11): levend blok voor iedereen onder 10 + Auto Shot / Raptor Strike los (`/reload`)

Rob via Sparring 28-11 (screenshot hunter 6, het blok werkt — GEMETEN door Sparring), letterlijk *"Ja, dat mag."* (1)
Order now: ORDER_EXTRA (ForeverHowToPlay.lua) haalt een spell die geen echte stap is uit de rij: HUNTER auto = Auto Shot
(start vanzelf met Serpent Sting/Arcane Shot, Rob mat het) → regel FHOWTO_EARLY_AUTO_FMT met de echte toetsen; close =
Raptor Strike, melee → FHOWTO_EARLY_MELEE_FMT; MAGE close = Frost Nova → FHOWTO_EARLY_NEAR_FMT ("then step away"). Andere
classes: niets dat duidelijk past (de "Low on health?"-heals van Priest/Paladin/Druid/Shaman/Warlock zijn ook
voorwaardelijk, maar niet gevraagd → niet gedaan, gemeld). (2) Rob, letterlijk: *"Oh, ik dacht dat we inmiddels bij iedereen tot
en met 10 hadden, maar blijkbaar nog niet."* → *"ja"*: EarlyBlock toont nu bij ELK character onder max(10, startlevel
rol); "Your role … starts at level X" alleen als de rol nog niet speelbaar is, anders FHOWTO_EARLY_BASICS. 4 nieuwe
sleutels in 7 talen. Offline: live_test (9 gevallen + 720 blokken), early_test 8/8 (verwachtingen bijgewerkt).

## ▶▶ 28 nov (Bouwchat 28-11): Skill up Enchanting — skill 1-5 heeft een recept (`/reload`)

Rob via Sparring 28-11, letterlijk: *"Ik volg je advies. Dus enchanting ja."* (advies: DB2 hier als enige bron).
ForeverRecipeSourceData.lua: [7418] k K at 20, [7421] k K at 5, met commentaar "ONE source on Rob's ja" (GEMETEN
SkillLineAbility 4289/4291, SkillLine 333, AcquireMethod 1, zoals 2660 = 1631 Blacksmithing, die er al stond).
`run forever_skillroute --emit` (controles OK): alleen de ENCHANTING-regel veranderde, nu "m7421>7,m7418>22,l14293,…",
geen gaten tot 300 in onze route (de "HOLE"-regels in de uitvoer gaan over Zygors route, niet de onze).
FSROUTE_HOLE_FMT is een algemene gat-zin; geen route gebruikt hem nu nog, hij blijft als vangnet (niet fout, niet
aangepast).

## ▶▶ 28 nov (Bouwchat 28-11): toetsenplan laatste stap — Mage Frost (`/reload`)

Robs go voor de rest van het plan: *"Alleen de hunten eerst en daarna gaan we door voor de rest."* GEBOUWD: cls.dirKeys
(ForeverBlock.lua): per richting (ForeverDirection band) eigen toetsen, alleen met "Swap keys" aan; KeysFor/ClassTable
passen hem toe (cache per sleuteltabel + laag). Mage band 3 (Frost), beide tabellen: 1 = { Frostbolt, Fireball } +
swapNote (moved Fireball → 2), 2 = Fireball, Ctrl-2 = Arcane Blast (geen dubbele Fireball). ForeverDirection.lua
ns.ForeverDirectionChanged roept nu ns.ForeverBlockDirectionChanged (macro's herschrijven + melding, buiten gevecht).
How you play KeyMap leest een oude toets in een tekst nu uit de BASIStabel (cls.keys) en zoekt de spell in de huidige
12x4-toetsen (KeysFor) → Frost: "Frostbolt (2)" toont "(1)"; hunter met schakelaar uit: "Hunter's Mark (1)" toont
"(Shift-Z)" (dat randje van stap (a) is daarmee weg in 12x4). Uitlegzin bij "**2** = Frostbolt" + FBLOCK_SWAP_SW_DESC in 8
talen (de/fr/es/esMX/pt/ru door mh-writer; nl tabnaam "Zo speel je"). Offline: swap3_test 5/5 (Frost 3/4, Arcane, geen
richting, schakelaar uit, melding, LiveKeys), swap/swap2/live/lvl/stance/fix3/fable9 opnieuw goed. Toetsenplan = AF.

## ▶▶ 28 nov (Bouwchat 28-11): het "Until level X"-blok leeft mee (`/reload`)

Rob via Sparring 28-11, letterlijk: *"Is het misschien handiger dat we gewoon zeggen van hey, level 1, je kan dit drukken,
level 2, je kan dat drukken"*; op het advies om het blok levend te maken: *"Ja, dat is een goed idee van jou."*
ForeverHowToPlay.lua EarlyBlock: in plaats van de vaste secties nu Now (LiveNow: elke bloktoets die nu iets doet, via
ns.ForeverMacroBody → show-id → clientnaam; pet-commando's niet; in leesvolgorde), Order now (de spells van de class-Simple
order die in Now staan, in tekstvolgorde, met hun toets; SpellsIn = dezelfde naamregels als NotYetLine) en Next (LiveNext:
ns.ForeverTrainerCompute per volgend level, alleen NIEUWE spells (geen req = geen hogere rang), max 3, toets uit de
blokTabel). Niets leesbaar → terugval op de vaste Simple order. Ververst ook op SPELLS_CHANGED (1 s, één keer per burst).
5 sleutels FHOWTO_EARLY_NOW_FMT/ORDER/NEXT_HEAD/NEXT_FMT/NEXT_KEY_FMT in en/nl/de/fr/es/pt/ru (zelf vertaald). Offline:
live_test (hunter 6 → Next 8 Concussive Shot op Shift-Q; 8 → Now groeit, Next 10; 720 blokken zonder fout), early_test 8/8.

## ▶▶ 28 nov (Bouwchat 28-11): toetsenplan stap (b) — Mage Arcane, Rogue, Shaman Enhancement (`/reload`)

Stap (a) (hunter) ✅ door Rob in het spel getest (via Sparring: *"de Hunt gaf inderdaad groot in beeld … Na de reload komt
hij inderdaad niet terug … Ook in How to Play staat het goed."*); zijn go voor de rest: *"Alleen de hunten eerst en daarna
gaan we door voor de rest."* GEBOUWD, beide tabellen + noSwap: Mage 1 = { Arcane Blast, Fireball }, Ctrl-2 = Fireball;
Shaman 1 = { Stormstrike, Lightning Bolt }, 3 = Lightning Bolt; Rogue 1 = { Mutilate, Hemorrhage, Sinister Strike }
(stealth Garrote blijft), 3 = Sinister Strike (oud) / { Sinister Strike, Shank } (12x4). Motor (ForeverBlock.lua):
FirstFor slaat in een lijst een spell over die een andere toets leent en neemt de volgende; FallbackHeld markeert die
dan ook (2e ronde) — zo houdt Combat (geen talent) in 12x4 Shank op 3 en blijft Shift-3 leeg, zoals sinds 24 nov; met
talent 3 = Sinister Strike, Shift-3 = Shank. SwapNotice: melding zodra toets 1 iets anders kiest dan swapNote.moved (dus
Mutilate óf Hemorrhage), met de echte spellnaam. Teksten 8 talen: Levels 1-10 (zin bij 1), What comes later (talent op
1), rolteksten alleen de talentspell → (**1**) (script, overal 2 per rol: Arcane, Enhancement, Assassination,
Subtlety); de verschoven spell houdt zijn oude token (12x4 LiveKeys volgt de spell). FBLOCK_SWAP_SW_DESC noemt nu alle
vier. frFR "Courroux naturel" = Stormstrike GEMETEN (SpellName 17364 frFR). Offline: swap2_test 5/5, swap_test 5/5,
early_test 8/8, lvl_test 16/16, stance_test 5/5. VOLGENDE: Mage Frost (Frostbolt op 1; heeft de richting nodig).

## ▶▶ 28 nov (Bouwchat 28-11): toetsenplan stap (a) — Hunter's Mark op 1, Auto Shot op Shift-Z (`/reload`)

Rob via Sparring 28-11, letterlijk: *"Doe maar stap AI inderdaad voor het toetsenplan. Alleen de hunten eerst en daarna
gaan we door voor de rest."* (= stap (a), hunter). GEBOUWD: ForeverBlock_Hunter.lua beide tabellen: 1 = { Hunter's Mark,
Auto Shot } (bang alleen voor Auto Shot: def.bang mag nu een naamset zijn), Shift-Z = Auto Shot (bang); het bestaande
leen-mechanisme (FallbackHeld) houdt Auto Shot op 1 en Shift-Z leeg tot Mark bekend is. cls.noSwap = de oude indeling;
schakelaar ns.db.foreverKeySwap (Toetsen & macro's → Schakelaars FBLOCK_SWAP_SW, standaard aan; ns.SetForeverKeySwap
herschrijft de macro's). ForeverBlock.lua: SwapOn/KeysFor/ClassTable-laag; SwapNotice (def.swapNote): één
FireAccessibleAlert + chatregel per character per toets (ns.db.foreverSwapTold[GUID]), alleen met geplaatst blok, wacht in
gevecht, opnieuw bij weigering, "+ press Update once" als Shift-Z nog geen eigen macro had. ForeverHowToPlay KeyMap volgt
de schakelaar (ns.ForeverBlockKeysFor). Teksten 8 talen: Levels 1-10 (1 = Auto Shot + zin "From level 6 …"; Mark-regel
**1**), Simple order, 3 rolvolgordes (script: (**Shift-Z**)↔(**1**), overal 3/2), What comes later "- 6: …"; 5 sleutels
FBLOCK_SWAP_* in enUS/nlNL/de/fr/es/pt/ru (de/fr/es/esMX/pt/ru door mh-writer). Rob meet: Serpent Sting en Arcane Shot
starten Auto Shot, Hunter's Mark niet. Offline: swap_test 5/5, early_test 8/8, lvl_test 16/16, stance_test 5/5.
Bekend randje: gewone indeling + schakelaar UIT → How you play-tekst noemt nog Mark op 1 (tekst is vast; 12x4 klopt wel).
VOLGENDE (Robs "daarna gaan we door voor de rest"): stap (b) Mage Arcane, Rogue, Shaman; daarna Mage Frost (richting).

## ▶▶ 28 nov (Bouwchat 28-11): Fable-feitencheck sinds v5.11.0 — 6 van 9 gebouwd (`/reload`)

Robs vooraf-ja via Sparring 28-11 (zie de sectie hieronder, dezelfde zin). GEBOUWD:
(1) Munitie: ns.ForeverAmmoHave (ForeverClassVendors.lua) telt alle munitie van je soort in je tassen + ammo-slot (item
class 6, subclass 2 pijl / 3 kogel, GEMETEN DB2 Item 71139 op 7 items incl. Forever 274387/274388), plus de winkellijst;
in de Do this now-regel en de grote melding. (4) HowToPlay Warrior "Sunder Armor (every stance)" → zonder die toevoeging
(fout in 12x4), 8 talen. (5) Shaman totemregel: de toetsen tussen haakjes vet (Searing (**5**) was "(lvl 5)"), 8 talen.
(7) Prayer of Fortitude rang 1/2 = één "rank"-groep (tools/forever_classvendors.py + opnieuw --emit; alleen de 2
Priest-regels veranderden; GEMETEN SpellReagents 21562→17028, 21564→17029). (8) Rogue Q: guardFree = Death Mark (engine
ForeverBlock.lua BodyRaw); GEMETEN SpellMisc Attributes_1 0x20 op Death Mark 1316709 + 3 rangen, Sprint, Vanish, Cold
Blood; niet op Adrenaline Rush, Evasion, Blade Flurry (betekenis 0x20 AFGELEID). (9) "Concussion Blow on Shift-V (a stun)"
zonder de Berserker-toevoeging (fout in 12x4), 8 talen.
NIET GEBOUWD: (2) Cooking/First Aid Artisan: alleen GEMETEN dat de quests bestaan (Wowhead Forever 6610 Clamlette
Surprise, 6622/6624 Triage); skill 225 + level 35 alleen uit gidsen, SpellLevels heeft geen rij voor vakrangen. (3) Twijfel
(levels per vakrang, Expert/Artisan-trainers): niet hard te krijgen. (6) Enchanting 7421 Runed Copper Rod / 7418:
GEMETEN SkillLineAbility AcquireMethod 1 (zoals 2660, die bij het vak hoort), maar ze ontbreken in
ForeverRecipeSourceData.lua, en dat bestand vraagt twee bronnen per soort; DB2 is er één → niet zelf toegevoegd.
fable9_test geslaagd; lvl_test 16/16 (Shaman 27 → 26, overal gelijk).

## ▶▶ 28 nov (Bouwchat 28-11): drie fixes uit de Fable-meetronde (`/reload`)

Rob vooraf via Sparring 28-11, letterlijk: *"Je weet dat ik toch je advies volg, dus op het moment dat die binnenkomt, dan
krijg je vast je ja voor de bouwchat."* (1) Lacerate — open punt van 27 nov AF. GEMETEN door mh-research (DB2 wowf
1.60.1.71139 + Wowhead Forever): 1328617 = rang 1, talent (lvl 25, TraitDefinition 134410); 1328616 (34) Supercedes
1328617; 414647 = rankloze lvl-1 "Lacerate". ForeverTrainerData.lua: r109 req {1328617}, tal = 1328617 op de 4
Lacerate-rijen (met handcommentaar: bestand heet "GENERATED"). ForeverTrainer.lua Fits: tal telt ook als een rang met de
naam van het talent bekend is (ns.ForeverKnownSpell), zoals de req-regel al deed. (2) NotYetLine: FindWord (geen letter
ervoor/erna) + een kortere naam die alleen BINNEN een langere gevonden naam staat valt weg. 27 namen staan binnen een
andere (Heal in Lesser/Flash/Greater/Chain Heal, Wrath in Hammer of Wrath …; lijst in fix3_test-uitvoer). (3) Priest
Simple order "Shield (Z)" → volle naam in 7 talen (de had hem al), naam uit het eigen bestand. fix3_test geslaagd
(Druid geen "Heal"; Priest Power Word: Shield, geen losse Heal; Lacerate zonder talent weg, met talent op 34, rang 1 uit
het boek → rang 3 op 42 nog zichtbaar). lvl_test 16/16. NIET gebouwd (alleen info): Feral telt Bear 10 en Cat 20 in één
band (Cat's 20 nooit gebruikt); Fury 10-19 toont alleen "Levels 1-10".

## ▶▶ 28 nov (Bouwchat 28-11): Forever How you play — "(lvl N)" + hunter melee-wapen (`/reload`)

Rob via Sparring 28-11 na zijn test van "Until level 10" (*"Het ziet er goed uit"*), letterlijk *"ja"* op: (1) "(4)" →
"(lvl 4)"; (2) Raptor Strike vraagt een melee-wapen. (1) LevelMarks bij het tonen (ForeverHowToPlay.lua): getal 1-60 in
"(N)", "(N, ", "(N; " of "(N ; " wordt "(<kort> N)"; "(level 1" → "(lvl 1". In KeySection ("Simple order", "Beginner
mistakes") blijft een getal dat een bloktoets is (1-5) staan. Kort per taal: en/nl lvl, de Stufe, fr/es/esMX niv., pt
nív., ru ур. Twee toets-plekken buiten die secties nu **vet** in 8 bestanden: Paladin "first (**3**)", Rogue "Eviscerate
(**4**), … (**Shift-4**) … (**5**)". Bijvangst: Beginner mistakes krijgt nu LiveKeys in toets-modus → in 12x4 "Raptor
Strike (Shift-X)" i.p.v. "(5)". lvl_test 16/16: per class gelijk aantal levels in alle 8 talen (fr/pt hadden "(8 ;"/"(1;"
→ meegenomen). (2) GEMETEN door mh-research (DB2 71139 SpellEquippedItems, masker 173555 + tooltip "Requires Melee Weapon"):
Raptor Strike 2973, Wing Clip 2974, Mongoose Bite 1495, Counterattack 19306, Disengage 781 eisen een melee-wapen; Strider
Kick 1317257 en Deterrence niet (AFGELEID). Skinning Knife 7005 = subclass Miscellaneous → telt niet. Robs hunters (Syndicator-
save) begonnen met Worn Axe 37; één had de Skinning Knife in de hand (waarschijnlijke oorzaak, AFGELEID). Undead/Gnome kunnen
geen hunter. Tekst: Levels-regel + volgorde + nieuwe Beginner mistakes-regel, 8 talen (de/fr/es/esMX/pt/ru door mh-writer;
Skinning Knife per client GEMETEN). Niet gezegd: verkopersnamen/plekken (namen per client niet gemeten).

## ▶▶ 28 nov (Bouwchat 28-11): Midnight Codex — Venomstones met aantallen (`/reload`)

Rob via Sparring 28-11, letterlijk: *"Venomstones A"* en op de Codex: *"ja"*. GEMETEN (web-fetch, zelfde dag) in
Blizzards hotfix 24 nov, news 24307310, tabel "Content Type / Ascendant Venomstone Quantity": Mythic Raid Bosses 4,
Heroic Raid Bosses 2, Mythic Keystone +10/+14/+18 = 1/2/3, Delve Bountiful Coffers (Tier 11) 1, Nightmare Prey
Equipment Caches 1. De prijs (10 per upgrade) staat NIET in dat artikel; de kaart zei al "Ten", niet veranderd.
CODEX_VENOMSTONE_BODY + _BODY_1217 in 9 talen (Codex.lua en/nl, Translations2026 de/fr/es/pt/it, esMX.lua, ruRU.lua):
"Where they drop" is nu een lijstje met de getallen. Bountiful Coffer per client uit CLIENT_NAMES_CODEX (ItemSparse
254250). Positieve controle: nieuwe zin 18x (9 x 2). NIET aangepast: TRACKCEIL_ROUTE_VENOM(_1217) (gear-route-tip,
noemt dezelfde bronnen zonder getallen — niet fout).

## ▶▶ 28 nov (Bouwchat 28-11): Forever How you play — "Until level X" (`/reload`)

Rob via Sparring 28-11, letterlijk: *"bij how to play er eigenlijk vanuit gegaan word dat je al level 10 bent en er niet
verteld word wat je tot die tijd moet doen ... en kijken of dat bij andere classes dat ook zo is"*; op het voorstel: *"ja
voor untill level 10"*. ForeverHowToPlay.lua: EarlyBlock (ns.ForeverHowToEarlyBlock) bovenaan tab Start (overview,
kind "early") én in het oude venster (Body), alleen als UnitLevel < startlevel van je rol (richting; geen richting = laagste
van de class). Inhoud = de class-secties "Levels 1-10: your buttons" + "Simple order" (bestaande vertaalde teksten) met
één regel "Your role (X) starts at level N" (FHOWTO_EARLY_TITLE_FMT/_ROLE_FMT/_CLASS_FMT, 7 talen; itIT Engels).
Startlevel = "From level N" uit de Engelse roltekst (RoleFrom); MM en SV overschreven naar 10 (volgorde eist Hawk + pet).
Uitkomst: Hunter 10/10/10, Warrior Prot 10 · Fury 20, Paladin Prot 10, Druid Bear 10 · Cat 20, Mage Arcane 8 · Frost 4,
Priest Shadow 4, Warlock Affliction 4; de rest 1. PLAYER_LEVEL_UP → 1 s later verversen. Hunter class-"Simple order" in
8 talen: pet + Aspect of the Hawk naar "From level 10:" aan het eind. GEMETEN DB2 71139 SpellLevels: 13165 Aspect of
the Hawk 10, 883 Call Pet 10, 1978 Serpent Sting 4, 3044 Arcane Shot 6. Nagelopen, niet veranderd: de andere 8
class-volgordes noemen alleen spells; wat je nog niet hebt krijgt al de grijze "Not learned yet (level N)"-regel (19 nov).
Bijvangst GEREPAREERD: KeyMap liet pet-commandotoetsen (cmd.needs = Call Pet) meetellen → Call Pet soms op Ctrl-2 i.p.v.
Ctrl-4 (afhankelijk van pairs()). Offline: early_test 8/8 talen, 2160 combinaties; howtotabs 0 mismatch; stance_test 5/5.

## ▶▶ 28 nov (Bouwchat 28-11): Cenarion Circle-tip aangepast (`/reload`) + HealBot wacht

Rob via Sparring 28-11, letterlijk: *"HealBot nee , verwijder die maar, Cenarion ja"*.
(1) Cenarion: mh-research las Blizzards eigen tekst (forum t/2403040 + news 24315281, GEMETEN): dev note "The repeatable
'Encrypted Twilight Texts' for Cenarion Circle reputation is intentionally unavailable". FREP_HOW_CENARION herschreven in
enUS, nlNL, de/fr/es/esMX/pt/ru (itIT heeft de key niet → Engels). Itemnaam per client GEMETEN (ItemSparse 20404, Forever
1.60.1.71139): de "Verschlüsselter Text der Twilight", fr "Texte du crépuscule crypté", es "Texto crepuscular codificado",
esMX "Texto Crepuscular codificado", pt "Texto Codificado do Crepúsculo", ru "Зашифрованный Сумеречный текст" (oude packs
hadden zelfgemaakte meervouden). "level 55-60" weg (niet gemeten). Niet genoemd: kill-rep cultisten, Ve'han's Fall —
alleen Wowhead-waarden, en Wowhead geeft ook de uitgezette quest 8319 rep, dus geen bewijs. REGIE tabel 5-regel = af.
(2) HealBot (Forever): AF. Rob deed het zelf (via Sparring: *"hij is er al uit 🙂 zelf gedaan"*); GEMETEN: geen
HealBot*-map meer in `_forever_/Interface/AddOns`. Ik heb niets verwijderd.

## ▶▶ 28 nov ochtend (Bouwchat 28-11): ochtendronde + handoff gesplitst

GEMETEN: main = 71781bd na pull (6 wachter/regie-commits), schoon; laatste tag v5.11.0. gh_inbox 0 open; HandyNotes en
Zygor onveranderd; site-mail 0; BOUW_VRAAG "(geen)"; Notion-inbak 4x "Nieuw" (allemaal van 12 nov, geen addon-idee).
addon_updates: 🔔 Forever HealBot 26.11.20 → 26.11.27 (uit op 19/19 characters; geen changelog in de map).
Wachters: 0 MOET GEFIKST; content-wachter 🔴 FREP_HOW_CENARION (enUS.lua:6420) botst met Blizzards dev note van 25 nov
(niet zelf getoetst, wacht op opdracht). Handoff was 1589 regels: geknipt bij "25 nov nacht (Bouwchat 24-11) …
UITKOMST" → 24 secties (24 nov) naar het archief, archief alleen aangevuld.

## ▶▶▶ STAND 27 nov avond (Bouwchat 27-11, context vol → opvolger "Bouwchat 27-11 (2)")

AF op main t/m 1c84157, NIETS getagd (laatste release blijft v5.11.0), niets daarvan in het spel getest. Op volgorde:
a508cda Dual Spec-waarschuwing · 092b0b6 Skill up hele route 1-300 · c23b1ad tas-melding (Put it on/Swap) · 5223b21
class reagents + munitie (Find + Do this now) · 3498f79 opraak-melding 50/3 · 7abe118 één MH-venster tegelijk (B, Back/
Home) · 80eb161 Druid Swipe op 4 · 3f0dc78 Druid form guard + eigen macro's per character (gedeelde account-macro-bug) ·
a875074 Druid Ferocious Bite op C · 1c84157 vormen/standen-ronde (Warrior Sunder op 4 Defensive, Druid bear X =
Demoralizing Roar, Rogue Stealth guard, How you play split-toetsen).
Testen bij Rob: TESTLIJST, alle secties "27 nov". Toetsblok: 1x per character Undo + Place, daarna /reload.
Daarna (Bouwchat 27-11 (2)): Skill up-route eenvoudiger GEBOUWD (zie de sectie hieronder), niet in het spel gezien.
OPEN:
- Wacht op Robs test van de eenvoudige route (TESTLIJST "27 nov — Skill up: de route eenvoudiger").
- Wacht op Robs 4 testjes (TESTLIJST "vormen/standen-ronde"): Shadowmeld in beer, Moonkin+C, Shadowform+C/Fear Ward,
  Prowl bonusbar. Daarna pas: Shadowmeld-guard, Moonkin/Shadowform-heals, Fear Ward-tekst, Ravage/Prowl-stand.
- ~~Lacerate ForeverTrainerData r109 req {414647}~~ AF 28 nov (req {1328617} + tal, zie 28 nov "drie fixes").
- Opties 1 (geld) en 3 (verzamelplekken): alleen onderzocht, IDEEEN.md; wachten op Robs keuze + zijn testjes.
- Oude gedeelde account-macro's ("MH 4" e.d.) staan nog in Robs account-lijst; MH raakt ze niet meer; verwijderen pas
  als elk character opnieuw geplaatst heeft (Robs keuze).

## ▶▶ 27 nov (Bouwchat 27-11 (2)): Forever Skill up — de route eenvoudiger (`/reload`)

Rob via Sparring 27-11, letterlijk: *"Kunnen we dat eenvoudiger uitleggen?"* → op het plan: *"Ja, das klappt so."*
ForeverSkillup.lua: nieuw RouteSimple (ns.ForeverSkillRouteSimple) op dezelfde stappen als RouteText. In de route-weergave:
StatusBar "<beroep>: 62 / 300" (f.bar, streepjes 50/125/200, grijs als je erlangs bent) + f.now (GameFontHighlightLarge)
met de NU-regel: open je beroepenvenster (KnownCount 0) / trainer of boek (skill ≥ cap) / gat / leer recept (+ waar) /
je mist nog N X (+ herkomst zonder "MH:", MakeFirst, "Also missing") / maak ongeveer Nx (je hebt alles). Een stap stopt
op je cap. "What comes next": eerst de volgende rang (bij 50/125/200, of "kan nu al", of boek voor Cooking/First Aid
boven 150), anders het volgende recept. Kleuren- en rang-uitleg in gewone woorden. Lange lijst (RouteText) alleen
achter f.full "Show the whole route" (ns.db.skillupRouteList, standaard uit). Knop f.mode heet nu "Route to 300".
19 sleutels FSROUTE_* nieuw/gewijzigd in enUS, nlNL, ForeverClassQuests_de/fr/es/pt/ru (itIT Engels, zoals Skill up).
Offline: scratch simple_test (416 toestanden, 8 beroepen, %-codes per taal gelijk aan Engels) + oude route_test 56/56.
Niet in het spel gezien: balk en grote regel (plek, hoogte, skin).

## ▶▶ 27 nov (Bouwchat 27-11): Forever toetsblok — vormen/standen-ronde gebouwd (`/reload`)

Rob via Sparring 27-11, letterlijk: *"Ik volg uiteraard je advies."* (op: ja op 1, 2, 3 en Concussion Blow; de rest pas na
een test). Uit de mh-research-audit (Shadowmeld-punt door mij weerlegd: 20580 Attributes_0 169082896 heeft 0x10000 NIET).
(1) Warrior keys12 "4" = Execute (battle/berserker) + Sunder Armor (defensive); SHIFT-C leeg. (4) keys12 SHIFT-V + berserker
Concussion Blow. (2) Druid keys12 X = bear Demoralizing Roar + base Nature's Grasp (open); SHIFT-2 alleen Wild Growth.
(3) Rogue Z/SHIFT-1/Q (beide tabellen): `all` → `base` + `guard = true`; motor: def.guard krijgt de baseGuard met eigen
schakelaar ns.db.foreverStealthGuard (Keys-tab FBLOCK_SG_SW). Geen formGuard voor de rest van de rogue.
(5) How you play KeyMap/LiveKeys: een oude toets met spells op VERSCHILLENDE 12x4-toetsen (split) kiest nu per spellnaam
die direct naast de toets staat ("Naam (**X**", "Naam op X", "**X** = Naam"), clientnaam + Engels; voorheen hing het van
pairs() af. stance_test 5/5 runs (eerste versie keek te ver en faalde 5/5 — gerepareerd).
NIET gebouwd (wacht op Robs 4 testjes, TESTLIJST): Shadowmeld, Moonkin/Shadowform-heals, Fear Ward-tekst, Ravage/Prowl.

## ▶▶ 27 nov (Bouwchat 27-11): Forever Druid — Ferocious Bite als kat van Shift-4 naar C (`/reload`)

Rob via Sparring 27-11, letterlijk: *"ja ja"* (1 = "Ferocious Bite als kat van Shift-4 naar C?", 2 = "Een helper alle
classes met vormen of standen laten nalopen?"). (1) ForeverBlock_Druid.lua: keys12 C + cat Ferocious Bite, SHIFT-4 alleen
Swiftmend; gewone tabel ook (C + cat; SHIFT-4 weg — een oude "MH SHIFT-4" in die indeling blijft dus Ferocious Bite
doen tot Undo + Place). How you play Cat in en/nl/de/fr/es/esMX/pt/ru (16 regels). swipe_test uitgebreid, geslaagd.
(2) loopt: mh-research loopt alle classes met vormen/standen/stealth na; NIETS bouwen, voorstellen naar Sparring.

## ▶▶ 27 nov (Bouwchat 27-11): Forever toetsblok — Druid form guard + nooit meer gedeelde account-macro's

Rob via Sparring 27-11: *"als ik in beervorm ben, [ben ik] veel te snel geneigd om op 2 te drukken. En 2, dat is dan
Moonfire, en dan ga ik uit beervorm"* → op het plan, letterlijk: *"akkoord"*.
(1) ForeverBlock.lua BodyRaw: cls.formGuard (alleen DRUID; Rogue ongemoeid) → base krijgt ALTIJD baseGuard, ook zonder
bekende vorm-spell; pair-toetsen ook ("[nobonusbar:1/2/3,combat] Rebirth; [nobonusbar:1/2/3] Revive"). open = true
op Ctrl-1/2/3 en X (beide tabellen; R had het al); `all` (Z, Shift-E, Shift-F/5) was nooit guarded. Schakelaar
ns.db.foreverFormGuard (Keys-tab FBLOCK_FG_SW), herschrijft meteen. Uitleg + autoUnshift-tip in "Why these keys?"
(KEYGUIDE_FORMS, alleen Forever-druid). MH zet autoUnshift nooit.
(2) 🔴 BUG gedeelde account-macro's, GEMETEN in Robs macros-cache: account-lijst had 7 gedeelde "MH …" (MH 4 = mage
Fire Blast, MH CTRL-Q paladin, MH R druid); druid 18/18 eigen plekken vol; GetMacroIndexByName vindt de account-lijst
eerst → elk character herschreef dezelfde. Nu OwnMacro: eerst de eigen character-macro (in het character-bereik), anders
een account-macro "MH <toets> <laatste 3 tekens GUID>". Een kale gedeelde "MH <toets>" wordt nooit meer bewerkt (niet
verwijderd: kan op andere balken staan). Rob: per character 1x Undo + Place. RefreshExisting maakt een eigen macro
zonder bekende spell leeg ("#showtooltip") — de oude MH SHIFT-1 met Swipe — alleen als andere toetsen wel tekst hebben.
(3) Bijvangst ForeverTrainerData.lua r109: Lacerate 1328616 req {414647}; DB2 71139: 1328616 Supersedes 1328617, 414647
Supersedes 0 / AcquireMethod 3. NIET aangepast (betekenis van req alle/één niet nagegaan) — open punt.
guard_test + swipe_test geslaagd.

## ▶▶ 27 nov (Bouwchat 27-11): Forever Druid — Swipe als beer van Shift-1 naar 4 (`/reload`)

Rob via Sparring 27-11, letterlijk: *"Ja, ik gebruik 12 keer 4 en swipe mag inderdaad op 4."* (als tank Shift-1 met twee
vingers). ForeverBlock_Druid.lua: keys12 én keys `["4"].bear = "Swipe"`, SHIFT-1 alleen nog Hurricane (gewone tabel
ook, mijn keuze: dan zegt How you play één toets voor elke indeling; LiveKeys vertaalt per toets, niet per spell).
How you play bear-tekst "Swipe (**4**…)" in en + nl/de/fr/es/esMX/pt/ru (16 regels, GEMETEN 0 over met Shift-1).
Bestaande macro's: RefreshExisting bij PLAYER_ENTERING_WORLD herschrijft "MH 4" → `/reload` volstaat. swipe_test
(echte Body, beide indelingen) geslaagd.

## ▶▶ 27 nov (Bouwchat 27-11): beide games — één MH-venster tegelijk, Back en Home (keuze B, herstart)

Rob (aan Carola uitleggend, gedicteerd): *"… al die schermpjes die bouwen op en over elkaar heen … alleen maar dat
schermpje openen. En de andere schermpje afsluiten … terugknop … homeknop …"* → plan: *"klopt"*; keuze A/B, letterlijk:
*"Ik volg uiteraard jouw advies weer."* = B. Nieuw `Modules/WindowStack.lua` (beide toc's, na DialogPopup): allow-list
PAGES (pagina-vensters; helpers staan er bewust NIET in) + het hoofdvenster (Midnight MidnightHelperMainUI, Forever
MidnightHelperForeverOverview). Een pagina die opent sluit alle andere pagina's én het hoofdvenster, behalve docked
(Midnight). Back = geschiedenis (max 20), Home = ns:ShowMainUI / ToggleForeverOverview; strook met de twee knoppen
BOVEN de bovenrand van het venster (raakt titels/knoppen niet). Beveiligde frames in combat blijven open. Haak: in
ns.RegisterMidnightDialogPopup (ns.MidnightPageAttach) + sweep elke 2 s (boss window, instance map, hoofdvensters).
Schakelaar ns.db.ui.keepSeveral (Settings "Keep several windows open", `/mh windows several`); `/mh windows` = rapport.
Sleutels in Locales/SettingsPage.lua (7 blokken) + ruRU.lua. stack_test geslaagd. Niet in het spel gezien.

## ▶▶ 27 nov (Bouwchat 27-11): Forever — grote melding als munitie/reagents opraken (`/reload`)

Rob via Sparring 27-11: *"… dat je een melding krijgt als je de laatste 50 aan gaat beginnen of iets …"* → op het plan,
letterlijk: *"ja"*. ForeverClassVendors.lua CheckRunOut: munitie ≤ ammoAt (50) of een reagent voor een gekende spell ≤
reagentAt (3) → één melding via ns.FireAccessibleAlert(tekst, geluid, 6 s) (dezelfde deur + cooldown; geweigerd =
later opnieuw), chatregel met de verkoper. Pas opnieuw na eerst weer boven de grens (warned[]). In gevecht: pending →
PLAYER_REGEN_ENABLED. Instellingen ns.db.foreverRunOut {on, ammoAt, reagentAt}; `/mh vendor alert [on|off|ammo n|
reagent n]`, Quiet helpers FCVEND_ALERT_SW (los van de Do this now-schakelaar). Sleutels FCVEND_ALERT_* in 7 talen.
cvend_test met de melding geslaagd (grens, één keer, opnieuw na bijvullen, gevecht, weigering, instelbaar, schakelaar).

## ▶▶ 27 nov (Bouwchat 27-11): Forever beroepen optie 4 — class reagents + munitie GEBOUWD (herstart)

Rob via Sparring 27-11, letterlijk: *"nr 4 ja"*. `tools/forever_classvendors.py` → `Modules/ForeverClassVendorData.lua`
(beide toc's): per class de reagent per spell + level, GEMETEN in DB2 1.60.1.71139 (SpellReagents.Reagent_0,
SpellLevels.BaseLevel; 23 spells, 0 afwijkend; Rebirth/Gift of the Wild als rangen), munitie per level (ItemSparse),
220 verkopers uit Zygor NPCData (Reagents 31, Arrows 103, Bullets 86; tier uit clevel<10/25/40 = AFGELEID via
QuestieDB), namen Zygor + Wowhead-tooltip. `Modules/ForeverClassVendors.lua`: regels voor Do this now (0 = to-do, <5 =
tip, LOW 5 = eigen keuze; munitie <200 = tip, 0 = to-do; alleen boog/kruisboog/geweer), schakelaar
ns.db.foreverClassVendLine (Quiet helpers FCVEND_SW, `/mh vendor reagents on|off`), diagnose in `/mh vendor check`.
ForeverVendors.lua: Find-soorten reagent/arrows/bullets (alleen voor classes die ze gebruiken; pijlen gefilterd op tier
≥ jouw level), rogue → bestaande "thief". Categorienamen = ItemSubClass per client (GEMETEN). cvend_test geslaagd
(vond: de schakelaar kon niet uit, `and false or`). Niet gemeten: of Forever munitie verbruikt.

## ▶▶ 27 nov (Bouwchat 27-11): Forever — melding voor een bruikbare/grotere tas (`/reload`)

Rob via Sparring 27-11, letterlijk: *"ja voor de tas"* (zijn vraag: *"ik kreeg net deze tas en heb genoeg plek om hem
te gebruiken, kunnen we daar een melding van maken als zoiets in onze tas zit/komt, ook als ie groter en of beter is
dan een tas die we al hebben ?"*). ForeverBagFull.lua: ns.ForeverBagUpgrade (equip = SpareBag, nu ook zonder volle
tassen; swap = grootste losse gewone tas met bekende grootte (BAG_SLOTS) > kleinste gedragen gewone tas, bij gelijke
de leegste), ns.ForeverBagUpgradeGo (swap alleen als die tas leeg is: PickupContainerItem + PutItemInBag(oude inv),
AFGELEID = wat slepen doet, niet in het spel gezien), tooltipregel, schakelaar ns.db.foreverBagFull.bags (Quiet helpers
FBAGUP_SW, /mh bagfull bags on|off; /mh bagfull toont "bag line in Do this now: <reden>"). De regel gaat via
ForeverWear.lua (ForeverWearLines + isBag, ForeverWearLabel voor de overzichtskaart) → bovenaan Do this now, opent
vanzelf (WEAR_TODO), [Not this one] werkt. Alleen class 1/0 (geen pijlkoker/ammo/soul/beroepstas). Sleutels FBAGUP_*
in 7 talen (it Engels, zoals FBAG). Offline bag_test geslaagd (vond en repareerde: gelijke tassen → de leegste).

## ▶▶ 27 nov (Bouwchat 27-11): Forever beroepen — 4 opties uitgezocht, optie 2 (hele route 1-300) GEBOUWD (herstart)

Rob via Sparring 27-11, letterlijk: *"zoek al de 4 opties goed uit en begin met 2"* (Pathfinder Forever = ARR, alleen
idee). Alle 4 in IDEEEN.md. (2) GEBOUWD: `tools/forever_skillroute.py` → `Modules/ForeverSkillRouteData.lua` (beide
toc's, vóór ForeverSkillup.lua) + RouteText/knop in `ForeverSkillup.lua` (ns.db.skillupWhole), sleutels FSROUTE_*
(enUS, nlNL, de/fr/es/pt/ru in ForeverClassQuests_*; itIT Engels zoals de rest van Skill up).
🔑 GEMETEN: Robs Forever-SV `skillupProbe` heeft de grijs-grens van de client (C_TradeSkillUI maxTrivialLevel) en die is
gelijk aan onze DB2 (2881 40, 3816 70, 1229432 20). Zygors beroepsroutes vragen op 40+ stappen om recepten die in
Forever al grijs zijn (2665 van 65 naar 75, grijs 55) → plan "Zygor-volgorde" verlaten; onze route = DB2-kleuren +
leer-skill uit ForeverRecipeSourceData (K = vanaf 1), regel: oranje/geel vóór groen, dan trainer, dan Zygor-recepten,
dan zekerste; stap stopt op groen, bij een beter recept of op 50/125/200. Gat: alleen Enchanting 1-5. Healing potions
2330/2337/3447 hebben in Forever-DB2 GEEN SpellName/SpellReagents (gemeten). Offline: scratch route_test 56/56.
(1) geld, (3) verzamelplekken, (4) reagents/munitie: alleen onderzocht, zie IDEEEN.md. Robs eerste tests daarvoor:
(1) ziet hij Auctionators "To craft/Profit" in het beroepenvenster; (3) `/mh rares why` (GetLootSourceInfo yes/no) +
twee /run-regels (UNIT_SPELLCAST_SUCCEEDED-spell-id, LOOT_OPENED-GUID) bij één ader, één kruid, één keer vissen;
(4) `/run print(GetInventoryItemID("player",0),GetInventoryItemCount("player",0))` en bij een reagent-verkoper
`/run for i=1,GetMerchantNumItems() do print(i,GetMerchantItemID(i)) end`. De twee regels voor (3):
`/run local f=CreateFrame("Frame")f:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED","player")f:SetScript("OnEvent",function(_,_,_,_,s)print("CAST",s,C_Spell.GetSpellName(s))end)`
`/run local f=CreateFrame("Frame")f:RegisterEvent("LOOT_OPENED")f:SetScript("OnEvent",function(_,_,a,i)print("LOOT",a,i,GetLootSourceInfo(1))end)`
Niets daarvan in TESTLIJST tot Rob een optie kiest.

## ▶▶ 27 nov (Bouwchat 27-11): Forever Dual Spec-advies krijgt een balken-waarschuwing (`/reload`, NA 5.11.0)

Rob via Sparring 27-11, letterlijk: *"Ja en ja"* (op: "Dual Spec: komt er een waarschuwing bij ons advies?"). Aanleiding:
API_WATCH 27 nov, spelersmeldingen (US-forum 20 + 26 nov, EU 26 nov) dat een spec-wissel spells op de bars zet, over
eigen slots en macro's. NIET door ons gemeten, dus overal "kan". Gebouwd: (1) nieuwe sleutel FDONOW_DUALSPEC_BARS, in
ForeverDoNow.lua direct achter FDONOW_DUALSPEC geplakt (vóór de Paladin-zin); enUS, nlNL, de/fr/es/pt/ru in de
ForeverClassQuests-packs (itIT heeft geen Do this now-pack: Engels, net als FDONOW_DUALSPEC zelf). (2) Een regel "Your
bars after a switch" in de How to play-sectie "Talents: reset and Dual Spec" (ForeverHowToPlay.lua) + nl/de/fr/es/esMX/
pt/ru-packs. De drie class-regels (Paladin/Warrior/Druid) verwijzen al naar die sectie. Woorden GEMETEN in GlobalStrings
Forever 1.60.1.71139: ACTIONBARS_LABEL Aktionsleisten / Barres d’actions / Barras de acción (esES+esMX) / Barras de ação
/ Панели команд; MACROS Makros / Macros / Макросы. Niet in het spel getest (TESTLIJST 27 nov).

## ▶▶ 26 nov laat (Bouwchat 26-11): "about equal" i.p.v. "Upgrade" + de rol in de gear-zin (`/reload`, NA 5.11.0)

Rob: *"waarom vinden wij dit een upgrade en polestar juist de andere ?"* (Handstitched Leather Belt +1 Str, 31 armor vs
gedragen Aquarius Belt +2 Sta +2 Int, 40 armor). GEMETEN in ForeverQuestHint.lua `IsBetter`: hoofdstats eerst (`ds > 0`
→ beter); Stamina/armor tellen pas bij gelijke hoofdstats. Robs druid (SV foreverDirection) = richting 2 Feral → main
Agility = Strength (ForeverMainStats BY_TREE.DRUID[2]); Int telt daar niet. Een keuze per rol BESTOND al (`/mh direction`,
boom 1-3; Druid 3 = heal: Int, Spirit, healing; Bear = tweede regel in Do this now). Nieuw: `Sidegrade(row)` — winst in
hoofdstats ≤ verloren Stamina + verloren armor/10 (AFGELEID, geen meting) en geen DPS-winst → `row.side`, geen upgrade.
ForeverGearTipText geeft dan `nil` (Do this now, oppakmelding, Wear it en de quest-hint zeggen niets) en als 7e waarde een
gele tooltipregel FGEAR_SIDE_FMT (7 talen) met ALLE veranderde stats + "/mh direction". `WhoFor` zet de richting achter de
class in elke gear-zin ("Druid (Feral Combat)"). side_test 8/8.

## ▶▶ 26 nov avond (Bouwchat 26-11): RELEASE 5.11.0 — STAAT OP CURSEFORGE

Rob via Sparring, letterlijk: *"release 5.11.0 en duidelijk maken als mensen de eerste keer opstarten wat er verandert
is :)"*. Tag v5.11.0 op ce0ad85; run 45891560799 groen (Retail + Forever + GitHub-release). CF-API GEMETEN: 9833686
`MidnightHelper-v5.11.0.zip` (12.0.7-12.1.7) en 9833709 `-forever.zip` (1.60.1), beide releaseType 1, status 4. GitHub-release
met beide zips, geen prerelease. Wago: "Success!" in de log (niet apart nagemeten).
"Eerste keer opstarten": GEMETEN dat dit al werkt in BEIDE games: Changelog.lua staat in beide toc's (136 / 85), opent bij
PLAYER_ENTERING_WORLD als `lastSeenVersion` ≠ 5.11.0 (tenzij "nooit meer" = hideForever, of het keuzevenster neemt over met
een knop ernaartoe). Bovenaan het 5.11.0-blok; elke regel begint met "Both games:" of "Forever:". Niets gebouwd.
✅ De `/mh move`-test (ce0ad85: eerste keer meteen alle vakken, geen "Dock to window") is goed: Rob via Sparring, *"ik had
de extra testen op midnight al gedaan, vandaar de release"*. ✅ CURSEFORGE_DESCRIPTION.md staat op de CF-pagina: Rob via
Sparring, *"en dat staat er ook al :p"* (Robs woord; niet door ons nagemeten). Voor 26 nov staat niets meer open bij Rob.

## ▶▶ 26 nov avond (Bouwchat 26-11): Robs Midnight-check — Move eerste keer half + "Dock to window" weg (`/reload`)

Rob (Holy Paladin): inloggen en klikkaart ✅ (*"De eerste is goed"*, *"verder geen fout melding verder"*). ❌ 1: de eerste
/mh move gaf alleen de balk. GEMETEN in MoveMode.lua `Bar()`: een nieuw frame is zichtbaar; de `b:Hide()` stond NA
`SetScript("OnHide")` → OnHide → Stop() terwijl Start net active = true had gezet; Start deed daarna toch `b:Show()`. Balk
zichtbaar, Move uit, Done deed niets (Stop: niet actief). Nu: `b:Hide()` meteen na CreateFrame. move_test 22/22 (stub maakt
frames nu zichtbaar zoals de client; nieuwe check "first start: Move stays on"). ❌ 2: DialogPopup.lua kent `frame._mhNoDock`
(geen dock-knop, een opgeslagen dock wordt gewist); gezet op MidnightHelperMoveBar en de klikkaart. Lint [25] blijft blij
(beide nog via RegisterMidnightDialogPopup).

## ▶▶ 26 nov (Bouwchat 26-11): Robs characternamen uit alles wat meegaat + lint [30] (HARD)

Sparring (Rob volgt zijn advies, wil zijn gegevens niet publiek): de 5.11.0-tekst noemde een character van Rob, en
FALT_BANK_NONE_FMT (spelerstekst, 7 talen) had sinds 5.10.0 een echte naam als voorbeeld. Gerepareerd (24818da), en nu
ook 23 commentaarregels in 20 bestanden (scratch scrub_names.py; diff GEMETEN: alleen commentaar) → "Anna Example" /
"Example" / "Anna". Nieuw: lint [30] `check_private_names` leest de namen LIVE uit de WTF-mappen (één map per character:
Forever "Voor-Achter", retail per realm), dus er staat nergens een lijst met Robs namen in de repo (die gaat naar
GitHub). Zoekt in alles wat de zip meekrijgt (spiegel van de .pkgmeta-ignore) + RELEASE_NOTES, CURSEFORGE_DESCRIPTION,
docs/CURSEFORGE_*.md. Uitzonderingen: auteursnaam in de toc, gewone woorden (whatever/little/helper) en het testcharacter
dat "Midnight Helper" heet. Losse voornaam alleen in een paar (te algemeen). Controle: geplante naam wordt gevonden,
gewone zin niet. Geen WTF-map (andere pc) → SOFT "NOT CHECKED". Interne docs (TESTLIJST, NEXT_SESSION …) bewust niet.

## ▶▶ 26 nov (Bouwchat 26-11): 5.11.0 KLAARGEZET — NIET GETAGD (wacht op Robs "release 5.11.0")

Rob via Sparring: *"Zet maar vast klaar dan test ik midnight vanavond na het diner"*. Beide toc's 5.11.0; Changelog.lua +
CHANGELOG_5110_1 t/m _8 (enUS); `RELEASE_NOTES.md` = `docs/CURSEFORGE_5.11.0.md` (byte-gelijk, zonder beta-zin zoals
5.10.0); CHANGELOG.md; CURSEFORGE_DESCRIPTION.md (route/flight paths, rares/dood, gear-%, class-questkaart, Your race,
klikkaart + klik-heals) — Rob plakt die zelf op CF. SITE_SEIN: "klaargezet, nog niet getagd". Nieuwe bestanden →
"restart the game once" in de tekst. Inhoud = v5.10.0..HEAD. Tag: `git tag -a v5.11.0` + push, alleen op Robs zin.

## ▶▶ 26 nov (Bouwchat 26-11): de volledige Forever-naam ("Ima Druiddude") op de spiekbrief + Syndicator-alts (`/reload`)

Rob: *"al mijn karakters hebben de voorletters Ima … Dus dan moet hier ook wel de achternaam bij komen."* GEMETEN in zijn
Forever-SV: foreverNameProbe unitName "Ima", unitFullNameRealm "Druiddude", getUnitNameTrue "Ima Druiddude", normRealm "";
ForeverChars bewaart al "Ima Warlocky" enz.; Syndicator noemt ze "Ima Pallie" met realm "RP". KeyBlock.lua `ShownName`
(ns.KeyBlockShownName; alleen Forever: UnitName's 2e waarde + Blizzards separator) → `char=` in de code en `char` in
keyBlockCodes (de sleutel `ck` blijft). ForeverClassQuests item-tooltip: "jij" = voornaam OF volledige naam (anders telde
hij je eigen tassen als "kan mailen"), en bij een lege eigen realm geen realm-test (anders las elke alt "other realm";
AFGELEID uit de SV, niet in het spel gezien). undo_test 42/42, cq_test 36/36.

## ▶▶ 26 nov (Bouwchat 26-11): druid-klikken compleet: Rebirth, Innervate, Wild Growth (`/reload`)

Rob, op zijn geprinte blad (print werkt ✅, via Sparring): *"Zijn dit trouwens maar alle heels die je krijgt met druid?"*
GEMETEN in ForeverClickCast.lua: met "linkerklik voor targeting" (Robs stand) vielen Rebirth en Innervate weg, Wild Growth
stond er nergens in. Nu `KEEP_EXTRA.DRUID` + `WantFor` (één regel voor Rows, Missing en /mh clickheal): plain-midden = Wild
Growth, Shift+midden = Rebirth (moeilijkste misklik), Shift+rechts = Innervate (plain rechts is al het menu). Let op: in
die stand is Shift+rechts LEEG tot Innervate geleerd is (level 40), niet meer het menu (GEMETEN in click_test). Healer-stand
ongewijzigd behalve Alt+links = Wild Growth; Shift+rechts blijft daar het menu.
Levels GEMETEN in ForeverTrainerData.lua: Rebirth 20, Innervate 40, Wild Growth = talent (rank 1 408120 leert geen trainer;
nieuwe regel in Missing: eerste trainer-rang met een `req` die geen trainer leert = talent). click_test 38/38.

## ▶▶ 26 nov (Bouwchat 26-11): MH-macro's in de spiekbrief-code dragen hun spell (`/reload`)

Site-chat op Robs echte Forever-code (Ima, Druid): "maar 3 plaatsen gevuld". GEMETEN in zijn SV (keyBlockCodes, t
1795706488): 18 plekken gevuld, waarvan 15 MH-macro's als `macro||MH 1` zonder id; alleen Teleport: Moonglade, Healing
Potion en Minor Mana Potion hadden een id. De code was dus niet leeg. ⚠️ Correctie site-chat dezelfde dag: de "3
plaatsen" kwam uit hun testscript ("||" eerst ingeklapt); de site toonde "MH 1" enz. al (18/18 GEMETEN door hen). Deze
wijziging is dus een verbetering (de spell i.p.v. "MH 1", met icoon en link; live a95246ff), geen reparatie.
KeyBlock.lua: PlacePlan's macro-`want` draagt nu `show` (= ForeverBlock's spell.id); de export zet bij een MH-macro op
zijn eigen toets (naam = want.id, of nog niet geplaatst) `id` = die spell en `name` = de clientnaam; kind blijft macro.
Een eigen macro van de speler blijft zoals hij is. Contract-regel `id` bijgewerkt. undo_test 39/39.

## ▶▶ 26 nov (Bouwchat 26-11): bedanken voor een buff ná het gevecht (`/reload`)

Rob: *"Klopt het dat wanneer ik in een gevecht ben en ik krijg een buff van iemand, dat ik dan niet kan bedanken?"* — dat
was onze eigen regel (ThanksBuff.lua "Never: in combat", GEMETEN). Nu: Decide draait ook in een gevecht; een "ja" gaat in
`pending[guid]`; bij PLAYER_REGEN_ENABLED `AfterCombat`: alleen als de buff ≤ 60 s oud is, en opnieuw gecheckt op instance,
groep en de 5-minutenregel. Emote naar een unit-token als we die hebben (target/mouseover/focus/nameplate), anders de naam,
net als buiten een gevecht. Of de naam-route de speler bereikt: nog NIET gemeten (stond al open). `/mh thanks` toont
"kept from a fight" en "thanked after combat". SET_THANKS_DESC in 7 talen aangepast + check_drift --mark. thanks_test 10/10.

## ▶▶ 26 nov (Bouwchat 26-11): klik-heals in de toetsblok-spiekbrief (`/reload`; site-werk open)

Rob: *"een printout … welke healknop op welke gedeelte … die ik naast me kan leggen"*. GEMETEN: de Midnight-printout is de
toetsblok-spiekbrief (`/mh block export` → midnighthelper.com/keyblock/, A4 liggend); klikken stonden er niet in. Sparring:
één code, geen tweede. Nu: `ns.ClickCardExportRows` (ClickCard.lua, dezelfde bron als de kaart: actief DF-profiel, anders
MH's indeling; met rank via GetSpellSubtext en de nog-niet-geleerde klikken) → KeyBlock.lua `ClickExportLines` → header
`clicks=` + `K|MOUSE-…`-regels achter de toetsregels. Contract in het commentaar boven BuildKeyBlockExport en in
`docs/SITE_SEIN.md`. GEMETEN in de site-parser (keyblock/index.html:576-595, is12 :437): een K-regel wordt daar een
onschuldige "place" onder sleutel MOUSE-…; begint nooit met CTRL-, dus de 12x4-gok klopt nog. Knop "Print (website)"
(FCARD_PRINT, 7 talen) op de klikkaart + `/mh clickcard export|print`. undo_test 34/34, card_test 26/26.
OPEN: de site-chat moet de K-regels lezen en het printvak bouwen (opdracht via Sparring).

## ▶▶ 26 nov (Bouwchat 26-11): gear-% in de voet, routetijden m:ss, teleport korter, "binnen, boven" (`/reload`)

1. Rob: *"dat daar standaard altijd komt hoeveel onze gear is."* ForeverDoNow.lua `DurText` (links van `f.bags`): het meest
   versleten item via `ns.ForeverDurabilityParts` (ForeverDurability.lua, dezelfde bron als de waarschuwing), groen ≥50, geel,
   rood < limiet (25). Tooltip 3 slechtste + dichtstbijzijnde reparateur; klik = `ForeverRepairGoNearest`. Live op
   UPDATE_INVENTORY_DURABILITY en BAG_UPDATE_DELAYED. 3 keys × 7 bestanden. dur_test 10/10.
2. Routepaneel (ForeverTravel.lua): stappen en totaal in m:ss (`StepSec`/`MssText`); totaal = som van de afgeronde stappen,
   key FROUTE_ABOUT_FMT (8 talen). De oude "min 1 per stap" gaf 2+1 onder "about 2 min". Teleport: `TP_CAST` 10 s (GEMETEN
   SpellCastTimes), laadscherm 20 s AFGELEID tot MH het meet: `ns.db.foreverTpLoad {n, sec}` = cast-SUCCEEDED → eerste
   PLAYER_ENTERING_WORLD/ZONE_CHANGED_NEW_AREA, gemiddelde van de laatste 10. Was 0.5 + 1.5 = 2 min (gok).
   Vlucht Nighthaven(63)→Thunder Bluff(22): TaxiPath 316 = 78 punten (DB2 71139, GEMETEN); rechte lijn begin-eind al
   ~9300 yd, pad 16313 yd; 30 yd/s GEMETEN in Robs eigen vluchten (25>22 5461 yd = 182 s; 22>77 2599 yd = 87 s). Dus ~9:04
   klopt; Polestar's 3:04 kan niet (dat lijkt Crossroads→TB, 182 s). Rob vloog 63>22 nog niet (geen `63>22` in zijn SV).
   Robs correctie: Teleport: Moonglade was het goede advies voor Dendrite. flight_test 62/62.
3. Dendrite staat boven. ForeverClassQuests.lua `UPSTAIRS` (30 npc-id's) + `UpNote` in Where, NowParts.zone en CardData.place:
   uit Zygor Forever-tips "Upstairs inside the building/tower" / "Top of the building/tower" (alleen het feit). 37 treffers,
   6 buiten (heuvel/berg/platform) en Gakin (onduidelijk) weggelaten. Key FCQ_UPSTAIRS (7 talen, itIT valt terug). cq_test 33/33.

## ▶▶ 26 nov (Bouwchat 26-11): lijk-pijl weg zodra je leeft (`/reload`)

Rob: *"je kan vaak al wat van verderop … resurrecten. En op dat moment blijft de pijl staan tot ik eroverheen loop."*
ForeverTravel.lua: `ns.ForeverCorpseArrow` (de knop) onthoudt de route van vóór (`corpseArrow.prev`) en de kaartspeld die
MH zette; `ReleaseCorpseArrow` bovenaan `DeathUpdate` zodra UnitIsDeadOrGhost false is (PLAYER_ALIVE bij release blijft
geest → pijl blijft): alleen als ns.lastTarget nog de lijk-target is; speld alleen weg als hij nog op het lijk staat; route
van vóór terug, anders lastTarget/owner nil. `/mh ghost` regel "corpse arrow: …". `DeathPos` vooraf gedeclareerd.
flight_test 57/57.

## ▶▶ 26 nov (Bouwchat 26-11): zalf-waarschuwing bij "Curing the Sick" (`/reload`)

Rob verloor zijn Curative Animal Salve (15826) op 9/10. ForeverClassQuests.lua `SALVE` + `SalveLine`: op het kaartje de
waarschuwing (niet in gevecht; 10 doses; opgeven en opnieuw halen bij de gever = `e.from`, nu meegegeven als `s.giver`) en
"Doses left: N, still needed: M" (rood bij te weinig). Doses: `C_Item.GetItemCount(15826, false, true)` — includeUses GEMETEN
in Forevers ItemDocumentation.lua; nog nodig = numRequired − numFulfilled uit GetQuestObjectives. Item 15826 voor beide kanten
GEMETEN (Zygor H :24729, A :22489). "In gevecht telt niet" = Blizzard EU-forum 10 nov (mh-research via Sparring). 3 keys × 8
talen. cq_test 26/26.

## ▶▶ 26 nov (Bouwchat 26-11): toetsblok restore + plekken in woorden + voorvertoning vóór Undo (`/reload`)

Rob's /mh block slots: "slot 9 … now empty · undo: put back War Stomp" — GEMETEN in zijn snapshot: dat is een bar-1-dubbel
dat Place bewust optilt (Rob 5 okt: "die dubbele kopieën gelijk opruimen"); War Stomp zit ook in het blok (macro MH SHIFT-E).
KeyBlock.lua: `MayLift` nu op bestandsniveau (één regel voor undo, slots, voorvertoning, restore); `SlotLabel` = "Action
Bar N, button B (key X)" (ns.KEYBIND_BAR_COMMANDS, Blizzards HUD_EDIT_MODE_ACTION_BAR_LABEL als die er is); `ns.KeyBlockRestore`
(/mh block restore, onvermeld) vult alleen LEGE vakjes met wat de snapshot had (spell als bekend, macro op naam, item als in
tassen; niet als het naar een andere knop verschoven nog daar staat); knop "Update" roept het stil aan. `UndoPreviewLine` in de
login-mismatch-melding en de indeling-vraag. 11 keys × 8 talen. undo_test 20/20.

## ▶▶ 26 nov (Bouwchat 26-11): GoldScout MAG NIET (licentie GEMETEN) + gazelles/deer + dichtstbijzijnde spawn (`/reload`)

Rob koos GoldScout (b), maar de GoldScout Data License v1.0 (zelf gelezen, raw GitHub) verbiedt *"include the Data, or
anything derived from it, in another addon"*. Dus niet gebruikt; generator controleert nu elke npc tegen Zygor (`##id`
bij de genoemde regel) of Wowhead Forever; `docs/forever/CQ_MOBS_2026-11-26.json` herschreven zonder GoldScout (0 treffers
op "GS", origineel 59 — positieve controle). Let op: de eerste versie (5076736) had de percentages; die staan nog in git.
Nieuw: Sickly Gazelle 12296 (Zygor H :24730) en Sickly Deer 12298 (Wowhead Forever), 67 doelen. Data per gebied nu ook
`p` = spawns uitgedund (1 per 3×3 kaart-%); `NearestSpot`: op die kaart de dichtstbijzijnde spawn. Toegepast bij >1 gebied
of ≥5 spawns; `static` = het gebied, zodat het kaartje-id niet verspringt. cq_test 22/22.

## ▶▶ 26 nov (Bouwchat 26-11): oorzaak "eten/drinken weg" = NIET ZEKER; `/mh block look` om het te meten (`/reload`)

Rob, later: *"toen had ik even wel compleet afgesloten, opnieuw opgestart. En nu staan de dingen, zoals mijn mana en mijn
eten, weer terug op de plek waar ik ze eigenlijk achtergelaten had."* Dat past NIET bij de diagnose hieronder (Undo tilde ze
eraf): een vak dat met PickupAction leeg gemaakt is, bewaart de server leeg (AFGELEID, standaard WoW-gedrag) en komt na een
herstart niet terug. Dus waarschijnlijk stonden ze er nog en liet de balk ze niet zien (wat precies: NIET GEMETEN; kandidaten:
knop zonder icoon/item-cache, een verborgen of doorzichtige knop, een balk die een andere pagina toont). De fix van f7a74cc
(Undo tilt alleen MH's eigen spul) blijft goed, maar is niet bewezen als oorzaak.
Nieuw: `/mh block look` (onvermeld) — balk 1-8: per gevulde knop wat GetActionInfo zegt vs of de knop zichtbaar is, een icoon
heeft en naar dat vak wijst; problemen in chat, alles in `ns.db.keyBlockLook`. Rob doet dat als het weer gebeurt (vóór een
herstart). Ook: zalf-regel rood → oranje regel alleen de gevechtsregel (FCQ_SALVE_COMBAT), de opgeven-zin één keer.
undo_test 24/24, cq_test 28/28.

## ▶▶ 26 nov (Bouwchat 26-11): BUG eten/drinken weg na Undo van het toetsblok → fix (oorzaak later onzeker, zie boven)

Rob (Druid): spells/eten/drinken weg "op het vrije gedeelte … links naast onze alt-knoppen". GEMETEN in zijn SV: snapshot
`keyBlockSnapshots["Player-6944-02C2528B:1484"].at = 1795694474` = vandaag 13:01 (NL): het blok is vandaag opnieuw geplaatst;
een Place kan alleen na een Undo (KeyBlock.lua Place weigert met snapshot) → Undo via login-melding "Fix"
(KEYBLOCK_LAYOUT_MISMATCH), de layout-knop of /mh block undo (welke: AFGELEID, niet gelogd). Oorzaak GEMETEN in de code:
`KeyBlockUndo` deed `PickupAction(s.slot) -- lift ours off` op ELK opgenomen vakje, ongeacht wat er nu op staat → wat Rob
er later zelf op zette verdween zonder spoor. Geen macro's voor eten/drinken (macros-cache.txt GEMETEN), dus items.
Fix: Place/Update slaan per vakje `ours` op (wat MH er liet; false = leeg); Undo tilt alleen op als dat er nog staat (item:
zelfde id; spell/macro: zelfde soort, rank mag wisselen); oude snapshot zonder `ours`: nooit een item optillen. Bewaard
= in chat (KEYBLOCK_UNDO_KEPT_FMT, 8 talen) + `ns.db.keyBlockLastUndo`. Nieuw `/mh block slots` (onvermeld): per vakje
MH left · now · undo lift/KEEP. undo_test 13/13. Herstel voor Rob: zelf terugslepen (MH wist niet wat er stond).
Nog open (niet gebouwd): Place zelf tilt bij "clear" zonder vrije knop iets op en zet het bij Undo "by kind" terug — een item
dat op is (0 in tassen) komt dan niet terug.

## ▶▶ 26 nov (Bouwchat 26-11): class-questteksten rechtgezet (`/reload`); GoldScout blijft eruit (Sparring: (a))

- WL_AVELINA / WL_ISAAC: "kill Avelina/Isaac here for … Heart" (Wowhead Forever: dropped by 185333 / 185334).
- MA_SILK en MA_QUILL: "(… drop it most)" weg: AFGELEID, en bij Quill van gemengde herkomst (POLESTAR_NAKIJK M23); geen
  toegestane bron steunt het. MA_DUST: "defeat blood elves" (Zygor: "Blood Elf enemies").
- Alle talen; de rasnaam per client GEMETEN (ChrRaces 10, 71139): Blutelf / Elfe de sang / Elfo de sangre / Elfo Sangrento /
  Эльф крови (meervoud is van mij). esMX MA_SILK ook. check_drift: alleen de 2 oude drift-keys (GEARLADDER_FOOT,
  MBUFF_EUI_OVERLAP_HINT), niets nieuws.

## ▶▶ 26 nov (Bouwchat 26-11): class-quest-gebieden DATA erin (HERSTART: nieuw bestand ForeverClassQuestAreas.lua)

Alles in `docs/forever/CQ_AREAS_2026-11-26.md`. mh-research → `docs/forever/CQ_MOBS_2026-11-26.json` (87 doelen met npc's,
elk id op naam gecontroleerd in Wowhead Forever). Generator (`CQ_AREAS_generator_2026-11-26.py.txt`) neemt NU alleen
Zygor/Wowhead-bronnen: 63 doelen, 13 met meer dan één gebied. 🔴 24 doelen alleen via GoldScout (wowgoldscout.com) → wachten
op Robs keuze (via Sparring gevraagd). cq_test 18/18 met het echte bestand.

## ▶▶ 26 nov (Bouwchat 26-11): `/mh travel` zegt per stap waar de minuten vandaan komen (`/reload`)

Rob's tweede /mh travel: route + Nighthaven 63 ✅. ForeverTravelSlash: elke stap "(flight timed by you)" / "(flight:
distance / 30 yd/s)" / "(ride + wait: …)" / "(walk: estimated from your run speed)"; "total: … (the sum of the steps
above)" i.p.v. "rough: the planner's units are chosen"; Hearthstone-regel noemt alleen de echte reden (route kruist geen
water / telling onleesbaar / "you have a Hearthstone: N"). flight_test 52/52.

## ▶▶ 26 nov (Bouwchat 26-11): Earthroot-tooltip ✅ in het spel; nu ook alts van de andere factie/realm, met reden (`/reload`)

Rob: *"Ja, de tooltip werkt netjes."* + *"Joey Whatever is een alliance en die kan dus niks naar mij toesturen."* Joey
ontbrak in MH's regel omdat `ns.ForeverCQItemBody` Syndicator met sameRealm+sameFaction = true vroeg. Nu (false, false):
eerst je eigen factie/realm "(can mail it to you)", dan grijs "(Alliance: cannot mail it to you)" / "(other realm: …)", plus
"MH: by mail you can get N of the M". Factie GEMETEN in Syndicator: `API.GetCharacter("naam-realm").details.faction`
(Initialize.lua:86); realm: realmNormalized vs GetNormalizedRealmName + GetAutoCompleteRealms. "Mail kruist geen factie in
Forever" = Robs woorden/Classic-regel (AFGELEID). Midnight: deze regel bestaat daar niet (Forever-bestand). cq_test 18/18.

## ▶▶ 26 nov (Bouwchat 26-11): Earthroot-tooltip + Nighthaven per factie + class quest "meerdere gebieden" (werking, data volgt)

- Rob: *"Kunnen we daar ook een tooltip van maken, zodat ik kan zien of een van mijn andere karakters hem heeft."*
  ForeverClassQuests.lua: `TIP_ITEMS` (FCQ_OBJ_EARTHROOT = 2449 ×5; GEMETEN Wowhead Forever + DB2 Item 7/9 = herb); de stap
  draagt `item`/`need` (ook `o.items`). Kaartje: `whoHover` → `ns.ForeverCQItemTip` (SetItemByID + `ns.ForeverCQItemBody`);
  overzicht Do this now: `tipLink = "item:…"` + dezelfde body. Andere characters: Syndicator.API.GetInventoryInfoByItemID
  (staat in Rob's Forever-AddOns, GEMETEN; bags+bank+mail, jezelf niet). MH's eigen AltProfTip noemt alleen beroepen, geen
  aantallen — MH bewaart geen tassen van alts (grep, AFGELEID).
- Nighthaven: `NodeForMe` filtert nu ook op factie. GEMETEN DB2 TaxiNodes 71139: 62 Flags 1025 + MountCreatureID_1 (Alliance,
  als Auberdine), 63 Flags 1026 + MountCreatureID_0 (Horde, als Thunder Bluff). flight_test 48/48.
- Meerdere gebieden (Rob: Polestar zag meer Kodo-plekken): `NearestArea` in ForeverClassQuests.lua (reistijd, cache 20 s;
  zonder positie het grootste gebied), "N areas, this one is nearest". Data `ns.FOREVER_CQ_AREAS` komt uit een
  gegenereerd bestand (scratch `cq_areas.py`: Wowhead Forever-spawns, zone → uiMap via DB2 UiMapAssignment+UiMap Type 3,
  groepen binnen 7 kaart-%). Kodo GEMETEN: 3 gebieden (25 punten 52.4,42.9; 13 bij 54.9,13.7; 8 bij 41.9,21.7). Welke npc
  per doel: mh-research loopt. Zonder data verandert er niets. cq_test 12/12.

## ▶▶ 26 nov (Bouwchat 26-11): Robs testronde ✅ + Move-knop/Escape + castbalk-label + klikkaart 3 per rij (`/reload`)

Rob testte (via Sparring, 5 screenshots) en het werkt: /mh crests-melding in Forever, castbalken slepen, "The way there: walk
(about 3 min)", Shift-laag + Shift+scroll op de klikkaart, /mh rares test met 3D-model, tooltip/grotere letters/glansvlek op
de klikkaart. In TESTLIJST afgevinkt met zijn woorden.
Gerepareerd: MoveMode.lua — balk MidnightHelperMoveBar bovenaan met "Done" (RegisterMidnightDialogPopup → Escape verbergt
hem → OnHide stopt Move); Start/Stop roepen `ns.ForeverOverviewRefreshIfShown` (Tools-knop "Open" ↔ Blizzards `CLOSE`) en
SyncNativeSetting (vinkje Midnight). Element castbalken `labelAbove`: label op een strookje boven het vak. ClickCard.lua: Other
layers 3 × 3, 228 breed (G.miniCols/miniW/miniN). Keys MOVE_BAR_LINE/_DONE in 8 talen. move_test 19/19, card_test 22/22.
Volgende: class quest met meerdere plekken (alle spawnpunten van het doel, clusteren, dichtstbijzijnde gebied).

## ▶▶ 26 nov (Bouwchat 26-11): klikkaart na Robs TWEEDE screenshot — tooltips, grotere letters, glansvlek weg (`/reload`)

Rob: lay-out werkt (niets overlapt, GEMETEN door Sparring op de screenshot), maar *"allemaal wat wel lastiger te lezen"* en
*"Kunnen we ook de Healing Touch, de Regrowth, Rejuvenation een tooltip geven?"*. Lay-out bewust NIET omgegooid (Rob
twijfelt nog). ClickCard.lua: elk icoon (3 grote + Other layers) heeft de echte spell-tooltip (GameTooltip:SetSpellByID met
het rank-id) + MH-regel "Alt + left click on a group frame"; niet geleerd: + "Not learned yet: level 24/talent/via quest";
Target/Menu: korte uitleg. Slepen vanaf een icoon versleept de kaart. Letters: ondertitel, "Rank", layer-regel, Other
layers-namen/toetsen en voettekst van Small naar normaal; pillen, "live" en de kop Other layers naar Large. Eerste keer
open: schaal 1.25 (een Shift+scroll-maat die je al koos wint — Rob had de kleinste stand, die blijft dus tot hij scrolt).
Glansrechthoek (`shine`) weg. Keys FCARD_BTN_L/R/M, FCARD_TIP_* in enUS/nlNL/ruRU/Translations2026 (de/fr/es/pt; itIT had
ook geen andere FCARD-keys). card_test 22/22.

## ▶▶ 26 nov (Bouwchat 26-11): loot die MH ZELF leert GEBOUWD (`/reload`) + sickness-duur nagemeten

Keuze (a) van Sparring (Rob volgt zijn advies): geen Drop Tables, geen licentiewijziging. ForeverRares.lua: LOOT_OPENED →
per slot GetLootSourceInfo (GUID, aantal, …); een bron-GUID die een rare uit onze lijst is telt het item, één keer per lijk
(sessie). `ns.db.foreverRareLoot[npc] = { kills, items = { [itemID] = { n, name, icon } } }` (MidnightHelperDB = account-breed).
GetLootSourceInfo staat NIET in Forevers gegenereerde API-docs (GEMETEN: LootFrameDocumentation.lua heeft alleen
TryAutoLoot; LootFrame.lua gebruikt hem niet) → zonder: de dode rare in target/mouseover. Getoond als "Your loot (N kills):
[icoon] naam ×n" (max 3) in Find-rijen en het rare-venster; nooit een kans. `/mh rares why` → regel "loot: …".
Keys FRARE_LOOT_FMT/_ONE_FMT in enUS, nlNL, ForeverClassQuests_de/es/fr/pt/ru (zelf vertaald, niet nagekeken door een
moedertaalspreker). "Vaste items, gemeten": er zijn er nog geen gemeten → niets getoond. rare_test 38/38.
Sickness (mh-research): GEMETEN Polestars eigen meting op Robs shaman 240 s op level 14 (Polestar.lua SV r431); Polestars
"10m" = vaste terugval (Death.lua:59). DB2 71139 SpellDuration 427: 60000 + 60000/level, max 600000 (GEMETEN). Onze regel
level-10 (max 10) klopt dus op 14 (GEMETEN), 15 = 5 AFGELEID. `/mh ghost` toont nu ook GetResSicknessDuration() (de
waarde van Blizzards eigen Spirit Healer-popup). flight_test 46/46.

## ▶▶ 26 nov (Bouwchat 26-11): rare in 3D GEBOUWD (`/reload`) — rij: loot die MH zelf leert (keuze (a), Sparring)

Rob: *"Toen ging ik kijken bij ons in Find… Een animatie."* ForeverRares.lua: `SetRareModel` (PlayerModel:SetCreature(npc),
zoals de bazengids, die Rob 19 nov in Forever zag werken = GEMETEN voor bazen; voor rares waar je nooit was NIET gemeten).
Na 1,5 s GetModelFileID 0/nil → verbergen (geen zwart vak), reden in `/mh rares why` ("3D model: …"). Find: muis op de naam
van een rare-rij → `ns.ForeverRareModelHover` toont een draaiend model naast het venster (rijen dragen `npc`;
ForeverOverview.lua FindRow-hooks). Rare-venster: 380 breed, model 100 px links, tekst ernaast; laadt het niet, dan neemt
de tekst de hele breedte. rare_test 27/27.
Loot: Sparring koos (a) + "MH leert het zelf" (LOOT_OPENED, GetLootSourceInfo-GUID = rare-npc, telling per item,
account-breed, "your loot, N kills", geen kans). Geen Drop Tables, geen licentiewijziging.

## ▶▶ 26 nov (Bouwchat 26-11): BUG na-je-dood-venster kwam steeds terug → GEREPAREERD (`/reload`)

Rob (echt dood, Druid 15): venster en pijl werken, maar *"Daarna klik ik het weg, maar hij blijft nu terugkomen."*
ForeverTravel.lua: `dpDismissed` — jij sluit (X, Escape, of de pijlknop, die het venster nu zelf sluit) = weg voor de rest
van DEZE dood. MH's eigen verbergen loopt via `SelfHide` (vlag `_selfHide`; OnHide vuurt alleen bij een zichtbaar frame).
Reset alleen bij PLAYER_DEAD (nieuwe dood) of als je leeft; PLAYER_ALIVE bij release laat hem dicht. `/mh ghost test` toont
altijd; `/mh ghost` zegt "you closed the window". flight_test 45/45 (nieuw blok 14).
Sickness-duur: zie het blok hierboven (onze regel klopt op 14, GEMETEN).

## ▶▶ 26 nov (Bouwchat 26-11): "na je dood"-venster GEBOUWD (`/reload`) — rij: rare-model + loot (bron = Rob kiest)

Sparrings advies, Rob volgt het (*"weer nuttige info"*). Feiten: `docs/forever/DOOD_EN_RARELOOT_2026-11-26.md`
(mh-research): 15007 -75%, MIN_RES_SICKNESS_LEVEL 11, 25% durability (CONFIRM_XP_LOSS), C_DeathInfo.GetCorpseMapPosition +
GetDeathReleasePosition bestaan in Forever; Spirit Healer-plek niet leesbaar (release-punt = kerkhof). Clientnamen 15007 en
npc 6491 per taal GEMETEN (gamedata). ForeverTravel.lua: venster MidnightHelperForeverDeathPanel (dood: release ↔ lijk;
geest: jij ↔ lijk, live, geestsnelheid = GetUnitSpeed run), kosten per level (AFGELEID regel level-10, max 10),
"Arrow to my corpse", FDEATH_SW (aan), /mh ghost [why|test] (onvermeld). flight_test 36/36.
Loot-bron: alleen Drop Tables (CC BY-SA 4.0) is open; heeft de 3 test-rares niet → keuze voor Rob via Sparring.

## ▶▶ 26 nov (Bouwchat 26-11): klikkaart na Robs eerste screenshot GEREPAREERD (`/reload`)

Rob zag hem werken (Alt-laag, iconen, ranks); 5 punten via Sparring. ClickCard.lua: geometrie in tabel G, kaart 760 breed;
bovenste spell op -185 (vrij van de pillen), muis lager; namen links/rechts ONDER het icoon (max 210 px); kaart groeit met de
strook (Fit), voettekst max 2 regels eronder. Meer "tof": halo om de muis, gouden verlooprand, verloop op lichaam/knoppen/
wieltje (SetGradient, terugval SetGradientAlpha), glans, naad, halo achter elk icoon, lijnen 5 px + gloedlijn 13 px.
ForeverClickMissing: trainer → class quest (ForeverClassQuestList spell-id) → talent (ForeverTalentLevel was verkeerd
gebruikt: die wil een level). Gecontroleerd met een HTML-weergave op dezelfde maten (scratch clickcard_geom.png):
geen overlap. click_test 28/28, card_test 14/14.

## ▶▶ 26 nov (Bouwchat 26-11): reisplanner STAP 4 GEBOUWD (`/reload`) — rij: "na je dood", dan rare-model + loot

- ForeverTravel.lua: ritdetectie (ticker 1 s): bewegen terwijl GetUnitSpeed 0 binnen 120 yd van een boot/zeppelin-eind =
  vertrek (GetServerTime, per realm, laatste 6 in ns.db.foreverDepartures[realm][linkId..eind]); stilstand 5 s aan de
  andere kant = ritduur (foreverRideTimes). Periode = kleinste gat 1-30 min; ns.ForeverLinkCost = wachten tot het volgende
  vertrek + eigen ritduur, anders COST. /mh travel: regel "boats/zeppelins learned". AFGELEID: periode, 1,5 min
  gemiddelde wachttijd.
- Liften NIET gebouwd: DB2 TransportAnimation heeft timing maar geen plek → bewust weggelaten.
- /mh walkrec on|off|clear (onvermeld meetgereedschap): punten elke 4 yd in ns.db.foreverWalkRec[map]; routeert nog niets.
- flight_test 33/33.

## ▶▶ 26 nov (Bouwchat 26-11): klikkaart GEBOUWD (HERSTART: nieuw bestand ClickCard.lua) — daarna stap 4, dan "na je dood"

Rob: *"Het moet grafisch tof zijn"*; keuze *"Ik volg jouw advies."* (één grote laag + strook, Alt/heal-laag standaard);
*"Wordt dan het plaatje automatisch dynamisch aangepast?"* → ja.
- Modules/ClickCard.lua (beide toc's): leest LIVE het actieve DandersFrames-profiel (ClickCast:GetClassData().profiles[
  GetActiveProfileName()].bindings, velden die MH zelf schrijft; DF 6.1.0-bron), anders MH's indeling (ForeverClickRows /
  ClickLayoutRows) met regel FCARD_SOURCE_MH. Grote laag = vastgehouden modifier (MODIFIER_STATE_CHANGED) > aangeklikte
  pil > laag met de meeste spells. Muis = ellips via TempPortraitAlphaMask + CreateLine-lijntjes (ook naar het wieltje).
  Strook: andere lagen + ForeverClickMissing (grijs, "level N"/"talent"/"via quest", AFGELEID: geen trainer + geen
  talent = quest). Ticker 2 s met signatuur; schakelaars in ForeverClickCast verversen meteen. See-through 100/85/70/50,
  FCARD_FADE_SW (uit). Openen: /mh clickcard [why], Quiet helpers, Midnight PlayCardWindow (eigen pool _cardBtn).
- card_test 14/14, click_test 25/25. Niet in het spel gezien: maskers/lijnen in Forever (pcall-bewaakt).
- Wachtrij van Sparring: reisplanner stap 4, daarna "na je dood" (afstand lijk/Spirit Healer, resurrection sickness meten).

## ▶▶ 26 nov (Bouwchat 26-11): reisplanner STAP 3 GEBOUWD (`/reload`) — daarna klikkaart, dan stap 4

- ForeverTravel.lua: lopen = afstand × DETOUR 1,4 / eigen run-snelheid (GetUnitSpeed, 7-21 yd/s; AFGELEID factor) via
  WalkFactor op elke loop-kant; vluchttijd eigen meting (hooksecurefunc TakeTaxiNode → landing, ns.db.foreverFlightTimes
  "van>naar", gemiddeld) wint van yd/30. Routepaneel MidnightHelperForeverRoutePanel (zelfde Plan als de pijl, ticker 2 s,
  icoon/tekst/minuten, totaal + afstand, kruisje per doel, FROUTE_SW aan), ring + "MH: fly here" op TaxiButton<slot>
  (nooit TakeTaxiNode). /mh travel: loopsnelheid, getimede vluchten, paneelregel (fouten zichtbaar).
- FlightMapHint.lua (Midnight): GetAllTaxiNodes(GetTaxiMapID()) i.p.v. zonder uiMapID.
- flight_test 30/30. Rob koos de klikkaart (*"Ik volg jouw advies."*) → nu bouwen, live met DF-profiel (zie Sparring).

## ▶▶ 26 nov (Bouwchat 26-11): /mh clickheal — 2 fixes uit Robs screenshot; klikkaart-ontwerp wacht op Robs keuze

Rob via Sparring: Alt-klik werkt (*"alt-click heb ik al geprobeerd en dat werkt dus"*). Fixes: (1) "not learned yet"
noemde Middle Mouse = Healing Touch terwijl die op Alt+Middle stond: met "keep left-click" tellen alleen de Alt/Ctrl-vakken,
en een vak waarvan je de spell al kent is niet "not learned"; (2) "…5187eep": "|k" is een chat-escape → signatuur nu
" /keep" / " /heal". Klikkaart (*"Het moet grafisch tof zijn"*): mock `<scratchpad>/clickcard_mock.png` naar Sparring;
pas bouwen na Robs keuze. Reisplanner stap 3 staat stil tot daarna (nog niets gewijzigd).

## ▶▶ 26 nov (Bouwchat 26-11): reisplanner STAP 2 — rare-in-zicht-venster GEBOUWD (`/reload`)

- ForeverRares.lua (onderaan): NAME_PLATE_UNIT_ADDED / PLAYER_TARGET_CHANGED / UPDATE_MOUSEOVER_UNIT; telt als
  UnitClassification rare/rareelite óf npc-id (UnitGUID) in FOREVER_RARES_ALL/_WORTH, levend, aanvalbaar; 10 min per rare.
  Venster MidnightHelperForeverRareAlert (RegisterMidnightDialogPopup, verplaatsbaar, 60 s), knoppen: Target = secure
  macro /targetexact op UIParent, alleen buiten gevecht over het venster gelegd (nooit eraan geankerd), Show in Find
  (ns.ShowForeverFind("rare", "z<map>")), Waypoint. Schakelaar FRALERT_SW (aan), /mh rares [why|test|on|off].
- AFGELEID: UnitGUID/UnitName zijn voor nameplates in Forever leesbaar (anders: geen Target-knop, wel het venster).
  rare_test 15/15.

## ▶▶ 26 nov (Bouwchat 26-11): Forever-reisplanner "leren van Polestar" — STAP 1 van 4 GEBOUWD (`/reload`)

Rob via Sparring: *"Ik volg sowieso jouw advies, dus ik zeg ja, denk ik. En gaan we door tot jullie eigenlijk klaar
zijn."* Volgorde: 1 flight-point-kennis, 2 rare-venster, 3 echte seconden + stappenpaneel + vliegkaart, 4 transport/liften/
Undercity. 🔴 Licentie: Polestar GPL-3 → alleen de METHODE gelezen, geen code/tabellen/getallen overgenomen.
- ForeverTravel.lua: leren bij TAXIMAP_OPENED via GetAllTaxiNodes(GetTaxiMapID()) ÉN de slot-lijst (NumTaxiNodes/
  TaxiNodeGetType/TaxiNodeName: CURRENT/REACHABLE/UNREACHABLE = bekend; naam → node via clientnamen + Engels, per kant);
  een geziene vliegkaart = dat continent "seen", ontbrekende punten vergeten. Ook ERR_NEWTAXIPATH (UI_INFO_MESSAGE) en
  landing (PLAYER_CONTROL_GAINED na UnitOnTaxi) → master binnen 60 yd. Wereldkaartlijst alleen nog voor namen
  (GEMETEN door Rob: alles "discovered").
- Nighthaven 62 (A) / 63 (H), druid-only, altijd bekend voor druids; paden 62→27, 63→22 (DB2 315/316). x,y AFGELEID uit de
  wereldpositie via nodes 49/69; Wowhead 11798/11800 binnen 0,2 (GEMETEN). StaticGraph-cache per kant + class.
- Eén advies: de start die een plan koos blijft 10 min staan tenzij een andere ≥ 1,5 min sneller is (SWITCH; de
  Hearthstone-cooldown liet het plan heen en weer flippen). /mh travel: taxi-API-regel + "seen" per continent.
- Open voor stap 3: FlightMapHint.lua:82 (GetAllTaxiNodes zonder uiMapID).

## ▶▶ 26 nov (Bouwchat 26-11): klik-heals op DandersFrames in Forever — GEBOUWD, wacht op test (HERSTART: nieuw bestand)

Rob via Sparring: *"2 ja"* (*"Kunnen wij dat in Forever ook? En zo niet, waarom niet? En kunnen we het wel maken?"*).
- Waarom de Midnight-versie niet werkte (GEMETEN): ClickCast.lua staat niet in de Forever-toc; retail spec-id's en
  spell-id's. DandersFrames _forever_ = v6.1.0 met dezelfde import + ClickCast-functies; Core/API.lua:309-328: import mét
  profielnaam overschrijft dat profiel (geen kopieën) → automatisch bijwerken is veilig.
- Nieuw: Modules/ForeverClickCast.lua (Camelot-toc na ForeverSmartBuff). Per class (Druid/Priest/Paladin/Shaman) een
  healer-indeling met per klik een lijst Engelse namen; de eerste die het character kent wint (ns.ForeverKnownSpell =
  hoogste rank, ids uit ForeverSpellIds.lua, alle 34 namen GEMETEN aanwezig). Binding draagt de CLIENTnaam. Dubbele
  spells overgeslagen. Schakelaar FCLICK_SW (uit) + FCLICK_KEEP_SW (aan: L/R = target/menu, heals op Alt/Ctrl).
  SPELLS_CHANGED/login → stil bijwerken als de indeling veranderde (signatuur), buiten gevecht. Uit = Undo (eerste
  "vóór" bewaard). /mh clickheal [why|on|off|heal|offheal] (foreverOnly in de lijst).
- AFGELEID, niet in het spel: klik castt de hoogste rank; GetCurrentSpec geeft in Forever een index; Forever-vormnamen
  in de de/fr-teksten niet nagemeten. click_test 25/25 (nep-DF).

## ▶▶ 26 nov (Bouwchat 26-11): Midnight-commando's weg uit Forever — GEBOUWD, wacht op test (`/reload`)

Rob via Sparring: *"3 ja"* (*"heel veel commando's die we alleen maar kunnen gebruiken in de Midnight versie"*).
- CommandList.lua: MIDNIGHT_ONLY (63 woorden) zet `midnightOnly` op die rijen; ns.CommandItemShown verbergt ze in
  Forever (lijst, Forever-venster, NavSearch). ns.IsMidnightOnlyCommand + Core.lua bovenaan de slash-handler: in Forever
  zegt zo'n commando CMD_MIDNIGHT_ONLY_FMT (7 talen) i.p.v. niets.
- GEMETEN per commando (scratch cmd_games.py): elke ns-functie die de Core-tak aanroept staat alleen in bestanden die niet in
  MidnightHelper_Camelot.toc staan. Beide houden (tak raakt een Forever-bestand): o.a. enchant, board, partytargets,
  play, survey, move, block, mark, arrow, bar, fps, mbuff, cleanup. Na de hand nagelopen: skip, mouse, goto, lang, new,
  pickup, alttip, thanks (Core of Forever-bestand). Geen tweede Forever-tak voor die woorden in Core (grep).
- cmd_test 13/13: 39 rijen in Forever, 63 alleen Midnight.

## ▶▶ 26 nov (Bouwchat 26-11): 5 instellingen in Forever Quiet helpers — GEBOUWD, wacht op test (`/reload`)

Rob via Sparring: *"Even kijken. 1 ja. 2 ja. 3 ja."* (1 = deze, 2 = klik-heals Forever, 3 = Midnight-commando's verbergen).
- ForeverOverview QUIET (kopje Screen): missing buff icon, upgrade in je tas, pijlgrootte (nieuw: `cycle`-rij, klik =
  volgende maat, rechtsklik = vorige; FOV_TIP_CYCLE 7 talen), meters, minimap-icoon, quick bar + zoekwoorden.
  GEMETEN dat elk in Forever werkt: MissingBuff.lua:244 Forever-tak, PickupUpgrade.lua:129, NativeArrow.lua:984/1013,
  QuickBar.lua:357, Broker.lua:412.
- Tekstgrootte NIET toegevoegd: GEMETEN dat geen Forever-bestand ns.MHScalableFont gebruikt (grep; positieve controle 51
  retail-bestanden wel) → in Forever-vensters doet hij niets.
- Volgende: opdracht 3 (commando's), dan 2 (klik-heals).

## ▶▶ 26 nov (Bouwchat 26-11): Move secret-veilig + castbalken in Move + cast-waarschuwing vindbaar in Forever — GEBOUWD, wacht op test (`/reload`)

Rob via Sparring (Forever, BugSack MoveMode.lua:144 "attempt to compare a secret number value", el =
MidnightHelperCombatSafety): *"Ik kon dus niet die bars verplaatsen"* → *"ja doe maar, en waarom kan ik het niet zoeken ?"*.
Versie: Rob wil geen haast met 5.10.1 (*"misschien in de 5.11 versie"*); release alleen op zijn letterlijke zin.
- MoveMode.lua: `PlainAlpha` (pcall + issecretvalue) i.p.v. f:GetAlpha() vergelijken/opslaan. Vervaagd of secret →
  alpha 1 tijdens Move; terug: eigen waarde, of 0 als hij secret was (de volgende SetAlphaFromBoolean beslist). Ook
  ActionPrompt gebruikt SetAlphaFromBoolean en staat in ELEMENTS: dekt deze fix ook (GEMETEN: grep; andere GetAlpha
  in BriefNotice/MidnightToast zijn eigen fades, niet secret, AFGELEID).
- Nieuw element MidnightHelperCombatSafetyBars (MOVE_EL_SAFETY_BARS, 7 talen) met `preview` =
  ns.CombatSafetyBarsPreview (3 voorbeeldbalken, alleen als balken aan). CombatSafety.lua: de balkenstapel kreeg eigen
  OnDragStart/Stop (positie in ns.db.ui.combatSafetyBarsPos, zelfde als slepen van een balk).
- ForeverOverview.lua QUIET: kopje SET_SEC_COMBAT met de 4 SET_CS_*-schakelaars + actie SET_CS_PREVIEW
  (ns.TestCombatSafety); QUIET_WORDS zodat "cast bars" ze vindt. Teksten = die van de Midnight-instellingen (al vertaald).
- Offline: move_test 12/12 (scratch, nep-secret die bij vergelijken een fout geeft). 🔵 De lijst "andere instellingen die
  in Forever werken maar daar niet te vinden zijn" gaat naar Sparring (niet gebouwd).

## ▶▶ 26 nov (Bouwchat 26-11): flight paths in de Forever-reisplanner + "zo kom je er" op het class-questkaartje — GEBOUWD, wacht op test (`/reload`)

Rob via Sparring (Druid 14 bij de zeppelintoren, pijl 4405 m naar Turak in Thunder Bluff): *"Waarom alleen maar een pijl
die kant op en niet hoe ik kom?"* → voorstel → *"Ja, stuur maar."*. Mag mee in 5.10.1 (niet getagd).
- Meting: `docs/forever/VLUCHTEN_2026-11-26.md` (mh-research). GEMETEN: geen zeppelin Org ↔ TB (DB2, 18 nov); 65
  flight points + 286 vluchten (DB2 71139, Flags 0x1 A / 0x2 H); 30 yd/s uit 12 echte vluchten van Rob; API in Blizzards
  forever-UI-bron (GetAllTaxiNodes state 0/1 bij de flight map, GetTaxiNodesForMap met isUndiscovered). AFGELEID: zone
  x,y uit wereldpositie (64/65 binnen 0,44 kaart-% van Wowhead); Classic-regel "alleen INTO bekende punten".
- ForeverTravel.lua: FLIGHT_NODES/FLIGHT_PATHS; flight masters van je kant zijn punten in StaticGraph, vluchten worden in
  Plan toegevoegd alleen naar punten die je kent (KnownTaxi: geleerd bij elke flight map in `ns.db.foreverTaxiKnown`
  per character + de wereldkaartlijst als die zichtbaar filtert). Opeenvolgende vluchten = één stap ("fly to …").
  Tijdens een vlucht (UnitOnTaxi) geen plan. `/mh travel` noemt de bekende flight points en waar MH ze van weet.
  Hearthstone-cooldown zat er al in (WaitMin).
- `ns.ForeverWayLine` → class-questkaartje (nieuwe regel onder de plek) + chat bij Show the way. Ververst ook bij
  ZONE_CHANGED(_NEW_AREA)/TAXIMAP_CLOSED. Nieuwe sleutels FTRAVEL_WALK_FMT, FTRAVEL_FLY_FMT, FTRAVEL_FLY_IN_FMT (7 talen;
  it alleen WALK, Forever heeft geen itIT-pack).
- Andere "Show the way"-knoppen (punt 3): alle lopen via NativeArrow + ForeverTravelNeedsLink, dus de pijl vliegt nu
  overal mee: ForeverTrainer, Vendors, Weapons, Dungeons, DungeonQuests, Rares, RestXP, QuestieDB, Overview (Find,
  dungeons). Een zin "The way there" hadden al: Trainer, Weapons, Dungeons, DungeonQuests, Overview. Zonder zin (alleen
  de pijl): Vendors, Rares, RestXP, QuestieDB.
- Offline: flight_test 19/19, trainroute_test 6/6 (scratch). 🔵 Open: (a) of GetTaxiNodesForMap in Forever alleen
  ontdekte punten geeft: Robs `/mh travel` beslist; (b) Classic- of moderne regel voor vliegen dóór onbekende punten
  (testvoorstel in VLUCHTEN-verslag); (c) bijvangst retail: `Modules/FlightMapHint.lua:82` roept GetAllTaxiNodes() zonder
  uiMapID aan (verplicht volgens de docs), niet gerepareerd.

## ▶▶ 26 nov (Bouwchat 26-11): Oath of Light duurt 1 uur — tekst GEREPAREERD, gaat mee in 5.10.1 (`/reload`)

Rob via Sparring: *"Ja, ik zeg ja op 1 en 2."* Bron: content-wachter 26 nov (Forever-hotfix 25 nov "Oath of Light
duration increased to 60 minutes").
- GEMETEN: Wowhead Forever-tooltip 1328548 "Swear an Oath … for 1 hour". DB2 71139 SpellMisc DurationIndex 5 =
  SpellDuration 300000 ms: de hotfix staat niet in de DB2-bestanden (server-hotfix), dus DB2 is hier niet de bron.
- "It lasts 5 minutes" → "1 hour" in alle 8 bestanden (ForeverHowToPlay.lua:987 + 7 packs, Holy Paladin stap 1).
  Andere spelerstekst over de duur: geen (grep "Oath of Light" + de clientnamen in Modules/Locales).
  Onderzoeksnotitie `docs/forever/PALADIN_ROLES_2026-11-17.md` kreeg een ⚠️-regel. `KEYBLOCK12_PALADIN.md` noemt nog
  "5 minuten" als reden om Oath uit het 12 × 4-blok te laten: met 1 uur geldt die reden sterker, dus niet gewijzigd.
- Ook: handoff gesplitst (1754 → 909 + index; kop 21 nov avond en ouder naar het archief) en
  `event_snapshot --write` (forever 71091 → 71139, positieve controle ADDON_LOADED in alle drie).
- OpenXP (Forever, uit op alle 20 characters) 2.0.4 → 2.0.7: zijn eigen lijst in `UI/Welcome.lua` gelezen, uitleg
  naar Sparring. NIET aangezet.

## ▶▶ 26 nov (Bouwchat 25-11): trainerpijl op reistijd — GEBOUWD, wacht op test (`/reload`)

Rob via Sparring (Druid in Orgrimmar): *"… 4493 METER VERDEROP STUREN, dat moet beter kunnen haha"*.
- ForeverTrainer.lua Nearest(): eerst `ns.ForeverTravelMinutes` (nieuw, ForeverTravel.lua: plan-minuten of loopkosten) voor
  elke kandidaat op elk continent, laagste wint; rechte lijn alleen als terugval. 5e/6e return min/how; HowFar() → "N min"
  (FTRAIN_MIN_FMT, 8 talen) in venster, tooltip, cap-melding, chat; chat noemt ook de route (FWEAP_ROUTE_LABEL +
  ForeverTravelSentence). `/mh trainer check`: "chosen: … by travel time …" + "route: …" (ns.ForeverTrainerLastChoice).
  Distance(nil)-val op 3 plekken gedicht (andere continent = geen yards).
- ForeverTravel TELEPORTS moonglade: dest = Loganaar 1450 52.5,40.5 (AFGELEID landing; geleerd na de eerste cast).
- ForeverTrainerSpots: Loganaar 12042 (N), Jannos Lighthoof 8142 (H, Feralas), Golhine 9465 (A, Felwood) + FIELD-tabel 15
  veldtrainers. Bron Wowhead Forever-tooltips (GEMETEN), HandyNotes_ClassTrainers alleen vergeleken (ARR, niets
  gekopieerd); uiMaps GEMETEN. Weggelaten: Zayus 5994 ("High Priest"), Fahrad 6707 ("Grand Master Rogue").
- Orgrimmar heeft geen Druid-trainer (HandyNotes r.166-192, Sparring) → Thunder Bluff was correct, alleen ver.
- trainroute_test 6/6 (scratch). ⚠️ Plan() cachet 1 s per doel: Nearest rekent ~20 plannen bij een klik (geen OnUpdate).

## ▶▶ 26 nov (Bouwchat 25-11): Fable-controle "Your race" verwerkt — klaar voor 5.10.1 (NIET getagd)

Rob op "Fable vóór 5.10.1": *"ja"*. 13 punten van Sparring/Fable; zelf GEMETEN: Rogue-Eureka breekt Stealth niet
(Attributes_1 0x20), Skysight bewegend 14 / Read Leyline 15 (SpellInterrupts), Purification Potion level 47, Ghost Wolf en
Travel Form +40%, Cheetah +30%, Herbalism esES Botánica / esMX Herboristería. Code: Walk on Air in Druid-Shift-E (beide
indelingen), alle 5 Eureka!-id's in ForeverMacros RACIALS, 13462 in de item-preload. Tekst: 19 regels herschreven,
SKY_C_HUN nieuw, GNO_C_RAGE/_ENERGY en UND_C_PAL weg (66 FRACE-sleutels). Details: `docs/forever/RAS_FEITEN.md`.
🔵 Open: fr "Cooldown" → "recharge" pack-breed (nu alleen in het FRACE-blok). 5.10.1 = 133bfa6 + 6bc2d2d + deze commit;
tag pas op Robs letterlijke zin.

## ▶▶ 26 nov (Bouwchat 25-11): "Your race" in How you play, tab Start — GEBOUWD, wacht op test + Fable (`/reload`)

Rob via Sparring: *"… als extra info vermelden bij de klas"* → *"ja , ik zag bv ook dat deze druid ook Cultivation heeft :)"*.
Rob wil 5.10.1 = dit + 133bfa6 (Gear check), na Sparrings Fable-ronde.
- ForeverHowToPlay.lua: RACE_INFO (raceID → base-sleutels + class-regels), RaceSection(token) via UnitRace; kind "race",
  tab start, achteraan Start. Kop "**For you as a <class>:**" alleen als er class-regels zijn (Priest altijd:
  FRACE_PRI_OWN verwijst naar "Your race's own spells"). `<S:EUREKA>` → Eureka! van die class. Tokens via
  ns.ForeverWeaponAdviceTokens, toetsen via LiveKeys (Shift-E).
- GEMETEN (DB2 71091): alle spell-id's, ras-id's 95/96, Plainsrunning 2/5/60, Travel Form 5419 aura 31 +40% (783 zelf
  niets), Charged = 3 id's met andere Duitse namen → beschreven. Register `docs/forever/RAS_FEITEN.md`.
- Vertalingen 7 talen door mh-writer (zie commit); race_test (scratch) controleert elk ras × class, sleutels en tokens per pack.

## ▶▶ 26 nov (Bouwchat 25-11): Gear check enchants — Legs + live bijwerken — GEBOUWD, wacht op test (`/reload`)

Rob via Sparring (screenshot Druid, geen Legs): *"Ik mis hier volgens mij mijn [legs] … kan de [gear] check enchants ook
dynamisch updaten? Want nu moest ik hem eerst weer mijn karakter uitdoen en toen weer aandoen."*
- GEMETEN (DB2 1.60.1.71091, elke ENCHANT_ITEM-spell × SpellEquippedItems): legs 78 (armor kits, ook chest/robe/hands/
  feet; arcanums), head 52, shoulder 22, waist 3 (tinkers), wapens 76 (ook scopes). Geen enchant-spell zonder
  SpellEquippedItems.
- ForeverEnchantCheck SLOTS: + Legs (gewoon vakje, telt mee in Do this now) + Head/Shoulder/Waist/Ranged met `onlyOn`
  (alleen als er iets op zit; "no enchant" daar = ruis voor de meeste spelers — keuze bouwchat, AFGELEID). Volgorde =
  paperdoll.
- Live: UNIT_INVENTORY_CHANGED("player") + PLAYER_EQUIPMENT_CHANGED → Fill nu en 0,5 s later; in een gevecht `pending`,
  dan bij PLAYER_REGEN_ENABLED. Welk event in Forever vuurt bij een enchant op een gedragen item = AFGELEID (classic-API),
  `/mh enchant` noemt het laatste ("last live refresh: …").
- ench_test 30/30 (was 24). Mogelijk een 5.10.1 als Rob dat wil.

## ▶▶ 25 nov (Bouwchat 25-11): RELEASE 5.10.0 (Rob via Sparring: *"breng 5.10.0 maar uit 🙂 , mee eens ?"*)

✅ STAAT OP CURSEFORGE (GEMETEN, files-API): 9816083 `MidnightHelper-v5.10.0.zip` (12.0.7/12.1.0/12.1.5/12.1.7) en
9816110 `MidnightHelper-v5.10.0-forever.zip` (1.60.1), beide releaseType 1 (Release), status 4. Tag v5.10.0 = 154e195;
run 45688975346 groen; GitHub-release 2 zips + release.json. SITE_SEIN op "staat op CurseForge".

Gewone release, geen beta, beide games. Inhoud v5.9.1..55ba32a (35 commits). Beide toc's 5.10.0; Changelog.lua +
CHANGELOG_5100_1.._7 (enUS); `RELEASE_NOTES.md` = `docs/CURSEFORGE_5.10.0.md` (GEMETEN byte-gelijk, 73 regels, 4131
bytes), zonder de beta-zin (geen betas sinds 4.14.0-beta2), met "restart the game once" (nieuwe bestanden AltProfTip.lua
+ ForeverEnchantCheck.lua; nieuw in de notes, geen eerdere gewoonte gevonden). CURSEFORGE_DESCRIPTION.md: tabs, Which
weapon?, gear-regel met spell damage/enchant, Gear check enchants (Forever), andere characters in tooltips (beide) —
🔵 Rob plakt hem. SITE_SEIN: 7 regels → getagd. NIET in het spel getest: bank-vinkje gear-regel, "you can make this
yourself", spell/healing-vergelijking, Warlock-stats (offline wel).

## ▶▶ 25 nov (Bouwchat 25-11): Warlock-stats = keuze (a) — GEBOUWD, wacht op test (`/reload`)

Sparring (a): *"Voor alle drie de richtingen hetzelfde: spell damage eerst, dan Intellect en Spirit even belangrijk.
Stamina noemen we niet meer als hoofd-stat."* Rob: *"Ik volg jouw advies."* → open punt Warlock-Stamina GESLOTEN.
- ForeverMainStats WARLOCK klasse-rij + BY_TREE [1]/[2]/[3] = {INTELLECT, SPIRIT}, `equal`, lead "spell", spellW 1,
  stamTie true. Bronnen in de comment: dev notes 3 nov (demon 2 HP per Stamina, was 7,5), Life Tap 1454 schaalt met Spirit
  (DB2 + Blizzard 24 sep/7 okt), alle gidsen spell power eerst (BRON, niet door mij nagemeten).
- Tooltip-rekensom (AFGELEID uit Score()): was klasse-rij Int 1 + Stamina 0,5, Demo/Destro Int 1 + Stamina 1, Affliction
  Spi 1 + Int 1. Nu overal Int 1 + Spi 1 + spell damage ×1; Stamina telt alleen bij gelijke score. Gevolg: een
  Stamina-item zonder Int/Spi/spell damage heet niet meer "better"; een Spirit-item kan dat nu wel.
- FWADV_WLK_7 (8 talen): "Stamina … more health, but it only decides between two equal items: spell damage, Intellect and
  Spirit come first." wadv_test 107/107, gearench_test 25/25.

## ▶▶ 25 nov (Bouwchat 25-11): "How you play" in tabbladen — ✅ GETEST door Rob (5d0f24e)

✅ Rob via Sparring (Druid 12 Feral, 2 screenshots): tabs + kopjes te zien, laatste tab blijft na `/reload`, `/mh howtotabs
mine` = "DRUID: OK, role lines 72/72, total 127 lines, 0 double … nothing missing". *"Wat minder druk voor mijn gevoel."*
Niet apart genoemd: alle tabs langs, kopje klikken, Your direction/All roles, Shift+scroll, andere ingangen.
🔴 BESLIST: NIET inkorten (Rob: *"dan gaan we misschien weer heel veel informatie missen"*) — het open punt "blokken 10-13
regels" hieronder is daarmee dicht.

Rob via Sparring: *"zo'n lange lap tekst … Met tabbladen van mijn part"* → *"Ja, je mag het zo sturen."*
- ForeverHowToPlay.lua: `ns.ForeverHowToSections` geeft elk blok een `tab` (start/keys/gear/group/levels, volgorde
  `ns.FOREVER_HOWTO_TABS`) en sorteert erop. Klasse-blokken op hun ENGELSE titel (ClassTab); COMMON via COMMON_TAB.
  Rol-teksten geknipt op hun 3 vette subkopjes (RoleChunks; GEMETEN 84 = 28 rollen × 3 in alle 8 bestanden): intro +
  volgorde + fouten → Start, per 10 levels → Levels. Andere vorm = heel laten + `uncut` gemeld. Nieuwe kinds: `plan`
  (Group), `weapon` en `stats` (Weapon & stats; stats = `ns.ForeverStatLines` uit ForeverDoNow). Dir-blok → Weapon & stats.
- `ns.ShowPlayCardWindow`/`Toggle` openen nu de overzichtspagina "play" (oude losse venster = reserve zonder overzicht).
- ForeverOverview.lua FillPlayPage: links eerst de tabs (gekozen = goud + balk `row.sel`), dan 8 px lager de kopjes van
  dat tabblad (ingesprongen, klik = springen). `f.playTab` + `ns.db.foreverPlayTab` onthouden.
- `/mh howtotabs [mine]` (Core.lua) → `ns.ForeverHowToTabsReport`: per klas per tab de blokken + regels, "role lines
  X/Y" (moet gelijk), dubbele lange regels (rol-tegen-rol telt niet). Let op: weapon/stats/dir zijn van JOUW character,
  ook in de regels van andere klassen.
- tabs_test (scratch) 153/153: 9 klassen × 8 talen, rolregels vóór = na, elk blok een tab, gesorteerd.
- Open: blokken "Levels 1-10" zijn 10-13 regels (spec zei ±5): inkorten = herschrijven = vraag aan Rob. (Beslist: niet
  inkorten, zie boven.)

## ▶▶ 25 nov (Bouwchat 25-11): spell-rekensom AF met Robs 4 dumps — healing, scholen, mp5 (`/reload`)

GEMETEN door Rob (GetItemStats, 2e run; 1e run nil = item nog niet geladen): 7049 SPELL_HEALING_DONE 15 + SPELL_DAMAGE_DONE 5;
19395 SPELL_HEALING_DONE 66 + MANA_REGENERATION 9; 2231 FIRE_DAMAGE_DONE 23; 2311 SPELL_POWER 2 (type 45 op leer = echt).
Scholen-keys GEMETEN in GlobalStrings (HOLY/FIRE/NATURE/FROST/SHADOW/ARCANE/PHYSICAL_DAMAGE_DONE_SHORT).
ForeverQuestHint: SpellValue = healers SPELL + HEAL + 0,5·MP5, damage-rollen SPELL + SDMG + de scholen van de spec;
SpellUnweighable = onbekende key, een school die de spec niet cast, of een school-regel voor een healer → geen oordeel.
Explain noemt het clientwoord ("Spell Healing" / "Spell Damage"). ForeverMainStats `schools` (AFGELEID): Mage Arcane/Fire/
Frost per boom (zonder richting geen lijst = zwijgen), Warlock Shadow (+Fire Destruction), Priest Shadow+Holy / Shadow,
Elemental Nature+Fire, Balance Nature+Arcane, Paladin Holy. gearench_test 25/25. Volgende: "How you play" in tabbladen.

## ▶▶ 25 nov (Bouwchat 25-11): spell damage telt mee in de gear-vergelijking — GEBOUWD, wacht op test (`/reload`)

GEMETEN door Rob: `/dump C_Item.GetItemStats("item:9513")` (Ley Staff) = INTELLECT 1, SPELL_POWER 2, DPS 5.34, SPIRIT 1;
de kale GetItemStats is nil in Forever. GEMETEN in DB2: 9513 heeft in ItemSparse alleen Spirit/Intellect (de client maakt de
spell power: caster-wapen). Stattypes in ItemSparse: 45 spell power (1078 items, ook op leer: 2311), 41 healing, 42 spell
damage, 85/87/88… school.
- ForeverQuestHint.lua: Stats() → `out.SPELL`; andere SPELL/HEAL-keys → `out.spellUnknown` (lijst); Score telt
  `SPELL × curSpellW` (MainFor zet curSpellW uit def.spellW); IsBetter = false als een van beide items `spellUnknown` heeft
  (liever zwijgen); Explain noemt "+/-N spell damage"; `/mh questhint check` en `/mh geartip` tonen de som. Sum() geeft
  spellUnknown door.
- ForeverMainStats.lua `spellW`: 1 voor Mage/Priest/Warlock (klasse + bomen), Holy Paladin, Resto/Elemental Shaman,
  Balance/Resto Druid; 0,5 voor Paladin-klasse-rij, Ret, Prot. AFGELEID (voorzichtig).
- 🔵 Nog te meten (Rob, /dump): 7049 Truefaith Gloves (41+42), 19395 Rejuvenating Gem (41), 2231 Inferno Robe (85), 2311
  White Leather Jerkin (45 op leer). Tot dan: healing-only/school = geen oordeel.
gearench_test 20/20.

✅ 25 nov: restjes clientnaam (Sparring: valt onder "clientnaam wint altijd"). GEMETEN: frFR ItemSubClass 2.3 DisplayName
"Arme à feu" (VerboseName "Fusils") → fr WAR_8, ROG_7, HUN_1, PAL_5 "arme(s) à feu" (FDIRB_W_RANGED had het al; PLAYCARD_255
"coups de fusil" = schoten, retail, gelaten); ptBR item 2862 "Pedra de Afiar Rústica" → FPROFG_DOES_BLACKSMITHING "pedras de
afiar"; esMX ItemSubClass 2.4 "Maza" = esES → geen overlay nodig.
🔵 Gemeten voor Sparring (niets veranderd): Prot Paladin `BY_TREE.PALADIN[2]` = {Stamina} → de tooltip-rekensom weegt alleen
Stamina. `Stats()` (ForeverQuestHint.lua:182) leest alleen STAT_KEY (5 hoofdstats) + armor + DPS; "SPELL_POWER" komt in dat
bestand niet voor. Gevolg: een item met MINDER Stamina en veel spell damage krijgt geen regel (MH zegt nooit "worse", hij
zwijgt); een item met iets MEER Stamina krijgt "better", ook als wat je draagt veel spell damage heeft → mogelijk verkeerd
upgrade-advies. Dat gold vóór vandaag ook al (Intellect telde, spell damage nooit). Of GetItemStats op Forever spell power
teruggeeft: NIET gemeten.

## ▶▶ 25 nov (Bouwchat 25-11): "Which weapon?" — Fable-controle VERWERKT (alle 9), wacht op test (`/reload`)

Rob via Sparring: *"Maak ze maar een voor een compleet af daarna de controle"* — dit is die controle.
CODE (ForeverWeapons.lua): token `<GF:NAME|n|en>` (clientstring met voorbeeldgetal via gsub, dus %1$d werkt ook) en
`<W:c.s|en>` (item-subklasse); ru-override FWADV_DPS_WORD (ruRU ITEM_MOD_DAMAGE_PER_SECOND_SHORT = "к урону в секунду",
GEMETEN); Wands (5009) in "already use" voor casters; regels met `maxLvl` (First wand tot 20); titel via UnitClass (eerste
waarde) voor alle 9; items 247789/11287/263412/274947/20750/5175-5178 bij het laden opgevraagd; Druid Dire Bear (9634) vanaf
40, beer-armorregel pas vanaf 10; DirNoneText: Feral krijgt FWEAP_DIR_FORM_FMT. Comments: datums (Paladin 15 okt, Mage &
Shaman 7 okt), Shaman Dual Wield rij 2455 bestaat wel (overblijfsel), talentlevels "at the earliest".
STATS: Druid-klasse-rij {Strength, Agility} equal (was Agi 1 / Str 0,5 in de tooltip-rekensom; nu allebei 1); TANK.WARRIOR
en TANK.DRUID zonder DPS-lead (A7: tanks = Stamina eerst, overal); Paladin tank (TANK + BY_TREE[2]) = {Stamina} + `spell`
("Stamina, then spell damage"; Blizzard hotfix-thread 2403040 post 12, 17 nov) — Intellect weg, open punt "Prot Intellect"
OPGELOST, en de tooltip-rekensom voor Prot weegt nu alleen Stamina; Survival lead "survival" (ranged <30, melee ≥30).
TEKST (enUS): CAST_1/_2/_4, MAG_7 (Scroll of Imbue Lesser Flame 274947), WLK_7 (Wizard Oil 20750 als token), PAL_3/_4/_6/_7,
WAR_5, ROG_4/_5/_8, HUN_6/_8/_9, SHA_2/_8 (Totem-items 5175-5178), FWEAP_DIR_NONE/FORM_FMT, FDONOW_STAT_SPELLDMG; vertalingen
door mh-writer (zie de commit). wadv_test 104/104. Nog open voor Rob: Warlock-Stamina.

## ▶▶ 25 nov (Bouwchat 25-11): de ochtendwachters bewaken het wapenadvies (register + vaste stap)

Rob via Sparring: *"Zorg er ook voor dat in onze controlerondes elke dag gecontroleerd wordt of er wijzigingen zijn die hier
invloed op hebben."* + *"En dat bedoel ik natuurlijk bij patch notes en dat soort dingen allemaal."* (ook zijn ja voor
WATCHER_FOREVER.md).
- Nieuw: `docs/forever/WAPENADVIES_FEITEN.md` — per bewering bron, meetpunt, plek in de code (key/bestand) en status
  (GEMETEN/BRON/GIDS/🟠 BETWIST of NIET GEMETEN), per class, plus de trefwoorden.
- `docs/WATCHER_FOREVER.md` sectie "Weapon advice — every run": content- en datawachter lezen alle Blizzard-bronnen (patch
  notes, hotfixes, dev/beta notes, deep dives, blue posts/known issues); de API-wachter legt bij een nieuwe `wowf`-build de
  GEMETEN DB2-rijen naast de vorige; uitvoer = één regel `⚔️ Wapenadvies:` per treffer, niets zelf aanpassen.
- GEMETEN (get_trigger, alleen gelezen): de content- en datawachter eindigen met "read docs/WATCHER_FOREVER.md and do the
  section 'For all four' plus the section for YOUR file"; alle vier schrijven dagelijks een **Forever:**-regel (API_WATCH
  25 nov meldde build 71091). Ze lezen het bestand dus al; geen prompt-wijziging nodig. ⚠️ De nieuwe sectie heet niet "For
  all four" maar staat ernaast en noemt elke wachter bij naam — AFGELEID dat ze hem lezen (ze lezen het hele bestand); de
  eerste run (26 nov) laat het zien: zoek `⚔️ Wapenadvies:`.
- REGIE.md tabel 2 bijgewerkt.

## ▶▶ 25 nov (Bouwchat 25-11): "Which weapon?" — Warlock GEBOUWD: alle 9 classes klaar. Volgende: Fable-controle (Sparring) + wapenadvies-wacht

FWADV_WLK_5/_7 (8 talen). GEMETEN: Create Firestone 6366 (lvl 28), Create Spellstone 2362 (lvl 36), Life Tap 1454.
Stats: WARLOCK lead "spell" (basis + 3 bomen); Affliction {SPIRIT, INTELLECT} nu `equal` (guides verschillen; ook de
tooltip-rekensom). Life Tap-comment bijgewerkt. ForeverDirection WARLOCK = FDIRB_W_CASTER.
✅ GESLOTEN 25 nov (zie bovenaan): Warlock-Stamina = keuze (a), Rob: *"Ik volg jouw advies."* (was: klasse-rij {Intellect,
Stamina}, Demonology/Destruction {Intellect, Stamina} equal). wadv_test 92/92, tokcheck 68 sleutels 0 fouten.

## ▶▶ 25 nov (Bouwchat 25-11): "Which weapon?" — Priest GEBOUWD, wacht op test. Volgende: Warlock, dan de wapenadvies-wacht

FWADV_PRI_5/_7 (8 talen) + de gedeelde CAST-regels. Stats: PRIEST lead "spell" (basis + Shadow), Holy "heal",
Discipline "heal" (keuze bouwchat: de rij is al een healrol). ForeverDirection PRIEST = FDIRB_W_CASTER. wadv_test 87/87,
tokcheck 66 sleutels 0 fouten.

## ▶▶ 25 nov (Bouwchat 25-11): "Which weapon?" — Mage GEBOUWD (+ gedeelde caster-regels), wacht op test. Volgende: Priest, Warlock

Gedeeld FWADV_CAST_1..4 en _6, Mage FWADV_MAG_5/_7 (8 talen). GEMETEN (DB2 71091): Shoot 5019, Wand Specialization 6057,
Wands 5009; items Novice's Practice Wand 247789 (lvl 1), Lesser Magic Wand 11287 (lvl 5); GlobalStrings INVTYPE_HOLDABLE
"Held In Off-hand", ITEM_SPELL_TRIGGER_ONEQUIP "Equip:". De rest van de item-regel ("Increases damage and healing done by
magical spells") is in de/fr/es/pt/it/ru door mij vertaald, NIET de exacte clienttekst (AFGELEID) — Fable-ronde. Bronnen in
de code (Blizzard dev notes 24 sep/16 okt, DB2; Icy Veins Frost wijkt af en is niet gevolgd). Stats: MAGE lead "spell"
(basis + 3 bomen). ForeverDirection MAGE = FDIRB_W_CASTER (game, geen fit); FWEAP_DIR_NONE_FMT nieuwe tekst ("the weapon
kind matters little here; look at what is on it"). wadv_test 79/79, tokcheck 64 sleutels 0 fouten.

## ▶▶ 25 nov (Bouwchat 25-11): Druid "Which weapon?" — caster-staf-regel GEREPAREERD (`/reload`)

🔴 FWADV_STAFF_FMT zei "a caster staff hits about as hard in a form" — FOUT (ook in de opdracht van toen). De DB2-tabellen
ItemDamage*Caster zijn gelijk aan de gewone, maar echte caster-items (ItemSparse Flags_4 0x100) tonen ~74% DPS (staven) en
~66% (daggers): Sparring mat 120 staven + 31 daggers op Wowhead Forever (Ley Staff 5.34 vs 7.14 ilvl 10, Icicle Rod 12.5 vs
16.9, Staff of the Deeproar 33.48 vs 45.0); Blizzard hotfix 17 nov (Kaivax, thread 2403040). Nieuwe tekst in 8 talen; de
"(GEMETEN)"-comment in ForeverWeapons.lua gecorrigeerd. Les: een DB2-tabel is geen bewijs van wat het item toont.
Tooltip-check (alleen gelezen, niets veranderd): ForeverQuestHint `Stats()` leest alleen de 5 hoofdstats, armor en DPS
(GetItemStats + tooltipregels "%s Armor" / DPS) — spell damage/healing van een wapen telt NIET mee in "beter dan wat je
draagt" (AFGELEID uit de code; GetItemStats op Forever voor zo'n item niet gemeten). Tool-bug (Sparring): `run gamedata
item` laat tooltipregels weg (Whiteout Staff 19101: "+25 Intellect", "Equip: … spell damage"); de ruwe JSON heeft ze.

## ▶▶ 25 nov (Bouwchat 25-11): "Which weapon?" — Rogue GEBOUWD, wacht op test (`/reload`). Volgende: Mage, Priest, Warlock

FWADV_ROG_1..8 (8 talen), CLASS_LINES.ROGUE. GEMETEN (DB2 SpellName 71091): Backstab 53, Ambush 8676, Shank 1329283
(spelersversie; 15248/15617 zijn NPC-id's, AFGELEID), Stealth 1784, Mutilate 399956 (zelfde id als ForeverDirection),
Hemorrhage 16511, Ghostly Strike 14278, Hack and Slash 13960, Poisons 2842, Throw 2764. "Mutilate from 40" en "Shank from
24" uit het onderzoek (Beta Dev Notes 3 nov), niet uit de Talent-tabel. Stats: ROGUE lead "mhdps" ("main-hand weapon damage
per second first"), Agi/Str ongewijzigd. Bijvangst: How you play Subtlety-rol, Hemorrhage "… but with a dagger it hits
harder" in en + 8 vertaalbestanden (nl de fr es esMX pt ru; it heeft geen eigen bestand). wadv_test 72/72, tokcheck 57
sleutels 0 fouten.

## ▶▶ 25 nov (Bouwchat 25-11): "Which weapon?" — Hunter GEBOUWD, wacht op test (`/reload`). Volgende: Rogue, casters

FWADV_HUN_1..9 (8 talen), CLASS_LINES.HUNTER. GEMETEN (DB2 SpellName 71091): Auto Shot 75, Arcane Shot 3044, Aimed Shot
19434, Multi-Shot 2643, Raptor Strike 2973, Mongoose Bite 1495, Strider Kick 1317257, Careful Aim 1223984, Bows 264 /
Guns 266 / Crossbows 5011; GlobalStrings AMMOSLOT "Ammo", INVTYPE_QUIVER "Quiver", ENERGY "Energy". Bronnen van Sparring
in de code (DB2 SpellEquippedItems 262156, Beta Dev Notes 24 sep/16 okt, Wowhead tooltips, Icy Veins Survival 20 nov).
"Strider Kick from level 30" komt uit het onderzoek, niet uit de (verouderde) Talent-tabel.
Stats: HUNTER lead "rdps" ("ranged weapon damage per second first"), Agi/Spi + Careful Aim ongewijzigd; BY_TREE.HUNTER[3]
Survival = melee {AGILITY, STRENGTH} lead dps (nieuw: ook de tooltip-rekensom voor Survival). FDIRB_W_SURVIVAL nieuwe
tekst (8 talen, it valt terug op en); fit = ranged + axe/axe2/sword/sword2/polearm/staff/dagger/fist (geen maces).
FDONOW_STAT_RDPS_FMT en (voor de Rogue) FDONOW_STAT_MHDPS_FMT in 8 talen. wadv_test 64/64, tokcheck 49 sleutels 0 fouten.

## ▶▶ 25 nov (Bouwchat 25-11): "Which weapon?" — Shaman GEBOUWD, wacht op test (`/reload`). Volgende: Hunter, Rogue, casters

FWADV_SHA_1..8 (8 talen), CLASS_LINES.SHAMAN (`learn` = staff/mace2/axe2: alleen tweehanders). GEMETEN (DB2 71091):
Stormstrike 17364, Windfury Weapon 8232, Flametongue Weapon 8024, Rockbiter Weapon 8017, Frostbrand Weapon 8033, Mental
Dexterity 415140, Mail 8737, Totem 27763, Staves 227 / 2H Axes 197 / 2H Maces 199; item 263412 Totem of Charged Flames
(ItemSparse; naam via C_Item.GetItemNameByID, Engels zolang de client het item niet heeft). NIET gemeten: waar talent
16269 "Two-Handed Axes and Maces" vandaan komt → de regel zegt "rood? ga naar je class trainer en een weapon master".
Wapenbuff-levels 1/10/20/30 uit het onderzoek. Windshaper Skyborne-regel = de dynamische "already use".
Stats: standaard + Enhancement lead dps, Elemental spell, Restoration heal én Intellect boven Spirit (`equal` weg — dit
verandert ook de tooltip-rekensom voor Resto: Spirit telt nu half). ForeverDirection SHAMAN[1]/[3] = FDIRB_W_SHIELD (1H:
mace/axe/dagger/fist + shield), [2] fit + staff. wadv_test 54/54, tokcheck 40 sleutels 0 fouten.

## ▶▶ 25 nov (Bouwchat 25-11): "Which weapon?" — Paladin GEBOUWD, wacht op test (`/reload`)

FWADV_PAL_1..8 (8 talen), CLASS_LINES.PALADIN in ForeverWeapons.lua. Spell-id's GEMETEN (DB2 SpellName 71091): Seal of
Command 20375, Holy Strike 678, Seal of Righteousness 20154, Righteous Fury 25780, Seal of Fury 20163, Holy Shield 20925,
Judgement 20271, Two-Handed Weapon Specialization 20111, Libram 27762. De ras-regel van het onderzoek = de dynamische
"You can already use / still learn" (client + leraren). Stats: standaard en Retribution lead = "dpsspell" ("weapon damage
per second and spell damage first"), Holy lead = "heal". ForeverDirection GUIDE.PALADIN[1] (Holy) = FDIRB_W_ONEHAND_OFF,
fit 1H, shield.
🔵 OPEN VOOR ROB: Protection-stats staan op Stamina, dan Intellect (21 nov). Intellect als tweede is twijfelachtig (guides
verschillen: wowforeverbuilder Spell power/Int, Mobalytics ook Strength). NIET veranderd; Rob beslist.
wadv_test 42/42, tokcheck 32 sleutels 0 fouten.

## ▶▶ 25 nov (Bouwchat 25-11): "Which weapon?" — Warrior GEBOUWD (1 van 8 na de Druid), wacht op test (`/reload`)

Rob via Sparring: *"Maak ze maar een voor een compleet af daarna de controle"*; volgorde Warrior → Paladin → Shaman →
Hunter → Rogue → casters, één commit per class, Fable-controle als alle 9 klaar zijn. Tekst = Sparring's verbeterde
versie (mh-research + tweede check, 25 nov).
- Algemene motor in `ForeverWeapons.lua`: CLASS_LINES[class].lines = locale-keys met tokens die de client invult:
  `<S:id>` spellnaam, `<G:NAME|en>` Blizzard-global, `<I:id|en>` itemnaam, `<T:n>` talent-boom (ns.ForeverSpecName,
  DB2 TalentTab). Daarna "You can already use" + "Weapons you can still learn" (FWADV_LEARNANY_FMT; `learn` = alleen
  bepaalde soorten). Titel FWADV_TITLE_FMT met de client-classnaam. Druid blijft zijn eigen code.
- Warrior: FWADV_WAR_1..8 (8 talen). Spell-id's GEMETEN in DB2 SpellName 71091: Mortal Strike 12294, Overpower 7384,
  Slam 1464, Dual Wield 674, Defensive Stance 71, Shield Bash 72, Shield Block 2565, Shield Slam 23922, Revenge 6572,
  Shield 9116, Weaponmaster 12281, Two-Handed Weapon Specialization 12163; RAGE, SPELL_STAT1..5 (GlobalStrings).
- Stats: WARRIOR lead = dps; TANK.WARRIOR = Stamina, Armor, Agility (was Stamina = Strength "equal"; Icy Veins Prot 4 nov +
  wowhandbook: Agi vóór Str). Tooltip-rekensom ongewijzigd (TANK wordt alleen als tekst gebruikt).
- Scratch-controle `tokcheck.py`: elke FWADV-sleutel in 8 talen met dezelfde tokens en ** als het Engels (24 sleutels, 0
  fouten). wadv_test 30/30.

## ▶▶ 25 nov (Bouwchat 25-11): Forever "Which weapon?" voor de Druid + stats-zin — GEBOUWD, wacht op test (`/reload`)

Rob via Sparring: *"… begin maar met de Druid inderdaad"* → *"Ja"*. Feiten van Sparring (mh-research + tweede check, 25 nov;
Blizzard Forever Class Deep Dive Hunter & Druid 30 sep 2026 + DB2 1.60.1.71091), staan in de kop van het nieuwe stuk in
`ForeverWeapons.lua`. Zelf GEMETEN vandaag: SpellName 5487 Bear Form / 768 Cat Form / 9634 Dire Bear Form; GlobalStrings
STAT_ATTACK_POWER "Attack Power", ITEM_MOD_DAMAGE_PER_SECOND_SHORT "damage per second", ARMOR, STAT_DODGE.
- `ns.ForeverWeaponAdvice()` (ForeverWeapons.lua): titel + regels, alleen DRUID. <10 "from level 10 (Bear Form)", 10-19
  alleen Bear (geen Cat-tekst), 20+ Bear + Cat. Wat je al kunt (IsPlayerSpell op de wapenskill) en welke tweehanders je
  nog kunt leren bij de leraren van JOUW kant (TRAINERS-tabel) → volgt het ras vanzelf. Spelwoorden uit de client
  (spellnaam, item-subklasse, stat-globals) via %s; zinnen in 8 talen (FWADV_*).
- How you play: blok na "Level and tank" (venster Body() én overzicht-pagina ForeverHowToSections), via de locale-keys,
  NIET in de vertaalde lestabellen (die hebben vaste volgorde per taal).
- ForeverDirection GUIDE.DRUID: wapenregel per richting (FDIRB_W_DRUIDFORM / _DRUIDCAST), `game = true` → "Weapon: …" en
  bronregel FDIRB_SOURCE_GAME. GEEN `fit`: in een form telt het type niet, alleen DPS → tooltip zegt niets over "fits".
- Stats (ForeverMainStats `lead`/`armor`, ForeverDoNow StatSentence): Feral/standaard "weapon damage per second first,
  then …"; Bear-tank "… then Stamina, then Armor, then Agility"; Balance "bonus damage and healing for spells first";
  Resto "bonus healing for spells first". De tooltip-rekensom (`main`) is NIET veranderd.
- Niet gebouwd: Do this now-hint 1H→2H (niet zeker te meten). Fable-ronde vóór de volgende release.
Offline: wadv_test 20/20; locale-probe OK in 8 talen.

✅ 25 nov: Forever-post naar de andere factie kan NIET — GEMETEN door Rob (Horde → Ima Bankgirl): *"target is unfriendly
:)"* = ERR_PLAYER_WRONG_FACTION "Target is unfriendly." (GlobalStrings Forever 71091). FALT_OTHERFAC_FMT zegt nu "other
faction, can't mail" in 8 talen (was "probably not possible"); Reach()-reden en commentaar in AltProfTip.lua bijgewerkt;
splitsing ongewijzigd. altprof_test 55/55.

✅ 25 nov: recept-tooltip (95108e3) GETEST door Rob (screenshot via Sparring: "MH: your other characters with Alchemy:
Ima Warlocky (18, needs 50)"). Nog open: "knows it"/"can learn it", de gear-regel na 7734a0d/3c08cb6, bank-knop.

## ▶▶ 25 nov (Bouwchat 25-11): bank-characters uit de gear-regel — GEBOUWD, wacht op test (`/reload`)

Rob via Sparring: *"Wat betreft de bankkarakters ga ik mee met je advies. A."* (voorstel: één keer markeren, weg bij
gear, wel bij recepten/materialen). Opslag `ns.db.altBankChars[guid] = true` (NIET in het character-record: Midnight's
AltOverview.lua bouwt dat record bij elke snapshot opnieuw op, de vlag zou verdwijnen). AltProfTip: ns.IsAltBankChar /
ns.SetAltBankChar; OthersGear slaat ze over; `/mh alttip bank <naam>` (naam hoofdletterongevoelig) wisselt; `/mh alttip`
noemt "bank character, skipped for gear". Forever: knop "Bank: no/yes" (84 px, links van het kruisje) per rij in het
overzicht → Characters (ForeverOverview CharRow, via ForeverCharsViews v.bank/v.toggleBank). Het oude losse venster
(ForeverChars Row) heeft GEEN knop (iedereen landt op de overzicht-tab). Midnight: alleen het commando (keuze bouwchat).
Nieuwe sleutels (8 talen): FCHARS_BANK_OFF/ON/TIP, FALT_BANK_SET/UNSET/NONE_FMT. altprof_test 55/55; de knop zelf niet
offline getest.

## ▶▶ 25 nov (Bouwchat 25-11): enchant telt mee in "beter dan wat je draagt" + alt-regel alleen naar wie je kunt mailen — GEREPAREERD, wacht op test (`/reload`)

Robs screenshot (Druid): Nomadic Gloves 21 armor + Light Armor Kit (enchant 15) aan, grijze Worn Leather Gloves 22 armor
in de tas → "MH: +1 Armor over what you wear". GEMETEN op die screenshot: de item-armor (GetItemStats/tooltipregel) laat
de kit weg. Rob: *"Ja, op 1 en 2."*
1. `ForeverEnchantData.lua` krijgt `FOREVER_ENCH_STATS` (280 id's; 83 helemaal te wegen, 197 met een deel dat MH niet kan
   wegen = x). GEMETEN in DB2 SpellItemEnchantment: Effect 4 arg 0 = armor, Effect 5 = stat (3 agi, 4 str, 5 int, 6 spi,
   7 sta); Effect 3 = equip spell → SpellEffect aura 29 (stat; misc 3 = Int GEMETEN op 13825 "Intellect +7") of aura 22
   misc 1 (armor). Enchant 15 = Armor 8 + Stamina 1. `ForeverQuestHint.lua` Stats(): enchant (veld 2 van de link) telt
   mee; Lost()/LoseText(): " You lose the enchant on what you wear: …"; IsBetter: een verloren x-enchant = geen "beter".
   Eén functie (ns.ForeverGearTipText) voedt tooltip, oppak-melding (6e return), quest-tip, ForeverWear en ForeverBagFull:
   allemaal mee. Midnight PickupUpgrade = item level + score, andere code, niet aangeraakt. Alt-gear-regel (item level
   x → y) zegt alleen item level; enchant van het alt niet meegeteld (melding aan Sparring).
2. Geen alt-gear-regel bij grijs (quality 0); wit blijft (Robs Nomadic Gloves zijn wit, |cnIQ1 in zijn SV).
3. "(empty slot)" bij Banklady/Hunterdude/Roquedude: GEMETEN in Robs Forever-SV (met Lua geladen): gear opgeslagen,
   handen-vakje echt leeg (level 1-2). Klopt; niets veranderd.
4. Mailen (Rob: *"kan ik überhaupt wel sturen?"*). GEMETEN in de SV: één realm (CAMWOW EU4 Realm 10 RP); Alliance =
   Ima Bankgirl, Ima Tinyroque, Inchy Shootalot, Joey Whatever; zonder factie = Ima Lockie, Ima Magymage, Ima Warman; 2
   zonder realm (GUID-server 6944 beslist). AltProfTip Reach(): andere realm = weg; andere factie = apart achteraan
   "· other faction, mail probably not possible" (cross-faction mail in Forever NIET gemeten; in Classic niet mogelijk);
   factie onbekend = "(faction ?)". Recept, materiaal en gear. Midnight niet gefilterd (Warband bank, AFGELEID).
   Soulbound/BoP-check bestond al (ITEM_SOULBOUND-regel; een gedragen BoE toont "Soulbound", AFGELEID).
Nieuwe sleutels (8 talen): FGEAR_LOSE_FMT, FALT_FACQ_FMT, FALT_OTHERFAC_FMT. Offline: gearench_test 14/14,
altprof_test 48/48, ench_test 24/24. Volgende: bank-characters markeren (Rob: *"… ga ik mee met je advies. A."*).

## ▶▶ 25 nov (Bouwchat 25-11): taint van de knop Character GEREPAREERD + armor kits hebben een naam — ✅ GETEST (a178459)

✅ Rob via Sparring: *"Ja, test is goed gegaan."* + screenshot: Hands/Feet "Armor +8, Stamina +1" (groen), Back/Chest/
Wrist/Main Hand "no enchant". NIET apart gemeld: de Now-regel "Character window: C." en geen BugSack-fout meer. Nog open
(niet getest): recept- en gear-tooltip, "you can make this yourself" op de enchanter, de buff-fixes.

Robs BugSack (via Sparring): `TextStatusBar.lua:110: attempt to compare a secret number value (execution tainted by
'MidnightHelper')`, stack ShowUIPanel ← CharacterFrame.lua:25 ← pcall ← ForeverEnchantCheck.lua:376 ForeverOpenCharacter ←
ForeverDoNow.lua:343 ← ForeverOverview.lua:2278. Oorzaak (GEMETEN in de stack): ToggleCharacter vanuit onze knop opent het
paneel tainted; de PlayerFrame-balken vergelijken dan secret values. pcall helpt niet. Mijn eerdere "AFGELEID dat het mag"
(hieronder) was dus fout.
Fix: geen knop meer. `ns.ForeverOpenCharacter` weg; nieuw `ns.ForeverCharacterKeyText()` (GetBindingKey TOGGLECHARACTER0
→ GetBindingText); de Now-regel krijgt "Character window: C." (FENCH_KEY_FMT, 8 talen; FENCH_BTN/FENCH_COMBAT weg). MH
opent CharacterFrame nergens meer. SecureActionButton type=click overwogen en NIET gedaan: secure knop in de overzichtskaart,
offline niet te meten, meer risico.
Elders in MH (GEMETEN, grep): `Achievements.lua:340` ShowUIPanel(AchievementFrame) en `Delves.lua:3842`
ShowUIPanel(DelvesDashboardFrame), beide alleen Midnight, geen meldingen; niet aangeraakt. ToggleCharacter nergens meer.
"enchanted" op handen/voeten van de Druid lvl 11: GEMETEN in Robs SV: enchant 15 = spell 2831 "Armor +8, Stamina +1"
(Light Armor Kit; Druid heeft Leatherworking). `ForeverEnchantData.lua` mapt nu elke ENCHANT_ITEM-spell: 280 id's
(Enchanting eerst). Scratch `ench_test.lua` 24/24. Materiaal-tooltip GETEST door Rob (TESTLIJST/IDEEEN afgevinkt);
recept- en gear-tooltip nog open.

## ▶▶ 25 nov (Bouwchat 25-11): Forever Gear check: enchants naast het character-venster — GEBOUWD, wacht op test

Rob via Sparring, letterlijk: *"ik heb ook enchanting, maar ik zie helemaal niet of ik al iets enchant heb, ja of nee, in
mijn overzichtje."* → *"Ja, het gaat om forever. En het is goed zo met 1, 2 en 3."*
Nieuw: `Modules/ForeverEnchantData.lua` (gegenereerd) + `Modules/ForeverEnchantCheck.lua`, in beide toc's (herstart).
GEMETEN in wago DB2 Forever 1.60.1.71091: SkillLineAbility 333 = 273 spells, 180 met SpellEffect 53 (ENCHANT_ITEM);
SpellEquippedItems → vakjes nek (5, nieuw in Forever), borst/robe, voeten, pols, handen, mantel, schild, off-hand-item,
wapens (masker per subklasse; 2H apart). Geen hoofd/schouders/benen/ringen/trinkets/ranged. 147 enchant-id's →
recept-spell. Naam = het deel na de laatste " - " van de client-spellnaam (deDE "Armschiene - Große Willenskraft", GEMETEN);
een id zonder Enchanting-spell = "enchanted". Enchant = 2e veld van de itemlink.
Venster: eigen frame op UIParent (naam MidnightHelperForeverEnchantPanel, RegisterMidnightDialogPopup = Shift+scroll +
Escape), bij openen rechts naast CharacterFrame gezet via een HookScript OnShow/OnHide; raakt CharacterFrame zelf en
CharacterScape niet aan; niet bijgewerkt in een gevecht. (2) Do this now: tip "N slots … no enchant" (soort "enchant"; het
overzicht maakt de knop Character uit ACTS: ToggleCharacter("PaperDollFrame"), niet in een gevecht; of dat taint geeft is
NIET te meten offline, AFGELEID dat het mag; in de TESTLIJST gezet). (3) enchanter: bekende recepten (foreverKnownRecipes
of IsPlayerSpell) die op een leeg vakje passen. `/mh enchant` doet nu in Forever wat (was leeg: GearEnchantCheck laadt daar
niet). Schakelaar foreverEnchantCheck (aan) in de stille helpers. Teksten 8 talen. Offline: scratch `ench_test.lua` 19/19.

## ▶▶ 25 nov (Bouwchat 25-11): toetsenblok-intro klopt nu als het blok geplaatst is — GEREPAREERD, wacht op test

Robs screenshot (Midnight, 12 × 4, blok geplaatst): bovenin "This is a picture … Nothing on your bars changes until you
choose to place it.", onderin "The key block is on your bars." Rob via Sparring: *"ja dat mag de bouwchat"*.
`KeyBlock.lua` Refresh: geplaatst (GetSnap) → nieuwe tekst KEYBLOCK_INTRO_PLACED ("… This is the block as it is on your
bars now."), anders de oude KEYBLOCK_INTRO. 8 talen (de eerste zin per taal ongewijzigd overgenomen); locale-probe OK in
alle 8; check_drift alleen de 2 oude punten (GEARLADDER_FOOT, MBUFF_EUI_OVERLAP_HINT). `/reload` genoeg.

## ▶▶ 25 nov (Bouwchat 25-11): gear-tooltip "wie van je andere characters kan dit dragen" (beide games) — GEBOUWD, wacht op test

Rob plakte het advies van Sparring terug: *"Mijn advies: in beide games eerst "kan dragen + hoger item level". Forever gaat
dan ook de gear onthouden. Echte stats-vergelijking doen we later, als je het nog wilt."* — en schreef: *"Zeg je ja? JA"*.
`AltProfTip.lua` deel Gear: bij een te versturen wapen of harnas (Sendable() als bij recepten) de andere characters die
het kunnen dragen, max 3 (grootste winst eerst) + "and N more"; per character "(item level X -> Y)" als het hoger is dan
wat hij in dat vakje draagt (ring/trinket: de laagste van de twee; leeg vakje = "(empty slot)"), of "(from level N)"
(item-minlevel, Polearms 20, Forever Mail/Plate 40). Nooit "beter". Zelfde schakelaar altProfTip.
GEMETEN 25 nov in wago DB2 SkillRaceClassInfo (Forever 1.60.1.71091, Midnight 12.1.5.70961), unie van ClassMask per skill:
harnas Cloth/Leather/Mail/Plate/Shield, wapens per subklasse, Wands; Forever Mail (Hunter/Shaman) en Plate (Warrior/
Paladin) MinLevel 40; Forever-wapenmaskers = die van ForeverWeapons.lua (zelfde tabel, eerder gemeten). Midnight-bit 16384
hoort bij geen van de 13 classes (weggelaten). AFGELEID: libram/idol/totem = Paladin/Druid/Shaman (niet in die tabel).
Forever slaat nu de gear op: `ForeverChars.lua` Snap → `rec.gear[slot] = { l, i }` (slots 1-18 behalve 4/19, net als
Midnight), ook op PLAYER_EQUIPMENT_CHANGED. Midnight gebruikt `charCurrencies[guid].gear` (bestond al).
Fout gevangen in de offline test: `local _, link = a and t:GetItem()` geeft geen link (een `and` houdt één waarde) →
herschreven. Offline: scratch `altprof_test.lua` 36/36 (Forever + Midnight). NIET in het spel. Teksten 8 talen.

## ▶▶ 25 nov (Bouwchat 25-11): tooltip noemt je ANDERE characters bij recept/materiaal (beide games) — GEBOUWD, wacht op test

Rob via Sparring, letterlijk: *"Kunnen wij dat niet hier vermelden in de tooltip, zodat ik weet naar wie ik het moet gaan
sturen?"* → *"Ja, dat klopt zo. Kun je het voor beide versies maken, Forever en Midnight?"*
Nieuw `Modules/AltProfTip.lua` (beide toc's, na ReagentUse.lua: herstart nodig). GEMETEN vóór het bouwen:
- Recept-item = class 9, subclass → beroep (wago DB2 ItemSubClass ClassID=9: Forever 71091 0-9, Midnight 70961 0-11;
  0 = Book). Benodigde skill = de tooltipregel zelf via ITEM_MIN_SKILL (ook de vorm met positie %1$s, offline getest).
- Andere characters: Forever `foreverChars[guid].profs` {key, name, rank, max}; Midnight `charCurrencies[guid].profs`
  {n, r, m, s}; allebei gevuld in Robs SV (Midnight m = 100: de Midnight-skill). Bekende recepten alleen in Forever
  (`foreverKnownRecipes[guid]`, sleutels = GUID, gezien in Robs SV) + de spell die het item leert (nieuw:
  ns.ForeverRecipeTeaches in ForeverSkillup.lua). Materiaal: nieuw ns.ReagentUseKeys in ReagentUse.lua.
- Niet versturen = geen regel: tooltipregel ITEM_SOULBOUND / ITEM_BIND_ON_PICKUP, of bindType 1 (BoP) / 4 (quest).
  Account-/warbound mag (kan naar een eigen character). Midnight: alleen naam + skill, geen "can learn" (skill per
  uitbreiding; het recept kan van een andere zijn).
Schakelaar `altProfTip` (aan): Forever stille helpers, Midnight instellingen (SettingsDefs, alleen retail); `/mh alttip
on|off`, kaal = de laatste beslissing. Teksten 8 talen. Lint-vondst van de site-chat verwerkt (`x and false or nil`).
Offline: scratch `altprof_test.lua` 27/27 (Forever + Midnight: needs/can/knows, niet jezelf, soulbound/BoP/boek/niemand =
geen regel, materiaal, schakelaar, slash). NIET in het spel.
**Stap 2 (gear), alleen uitgezocht:** Forever bewaart per ander character class + level, GEEN gear (`foreverChars` heeft
geen gear-veld); "kan dragen" (class/harnastype/level) is te bepalen, "beter dan wat hij draagt" niet zonder eerst gear op
te slaan. Midnight bewaart per character class + `gear` (link + ilvl per slot, 19 records in Robs SV), maar geen spec;
"hoger item level dan wat hij draagt" kan, "beter" met stat-weights pas als we ook de spec opslaan. Rob beslist.

## ▶▶ 25 nov (Bouwchat 25-11): taunts op de muis + spiekbrief-code met de indeling — GEBOUWD; taunts ✅ GETEST

✅ Taunts: Rob via Sparring, letterlijk: *"De tangtesten is gelukt."* (class niet genoemd; de test was Druid in beervorm).
Spiekbrief-code: nog niet getest. Buff-fixes (hogere rank / groepsbuff): nog niet getest (Rob kreeg nog geen sterkere buff).

**Taunts** (Rob via Sparring: *"We hebben dingen als Taunt en Growl. Ik zou graag ook een macro van willen hebben voor een
mouse over."* → *"ja graag"*): `ForeverBlock.lua` MO_HARM + Growl, Taunt, Mocking Blow, Distracting Shot (de taunts op één
doel in de 9 blokken, GEMETEN: Druid F, Warrior F, Hunter F / 12×4 Ctrl-E). Niet: Challenging Roar/Shout (groep). Geen
Paladin- of Warlock-taunt in de blokken. Offline (scratch `taunt_mo_test.lua`): 9 classes × oud/12×4 × enUS/ruRU (ruRU-namen
uit DB2 SpellName Forever), 1128 toetsen allemaal ≤ 255 bytes, langste 195 (ruRU Paladin Shift-Z); de taunt-toetsen
krijgen `[@mouseover,harm,nodead,…]`; mouseover uit = zonder. Bijvangst (alleen gemeld): de Handy macro Growl staat alleen
bij spec 2 (Feral), omdat de Handy macros per spec een top 3 zijn (ForeverMacros.lua "DX3 #2"); lijkt bewust.
**Spiekbrief-code** (Rob via Sparring: *"ja op mijn advies bij 1 tot en met 4"*; contract met de site-chat, die akkoord
gaf): `KeyBlock.lua` BuildKeyBlockExport zet achteraan regel 2 `;layout=old|12x4;game=midnight|forever` (eerste regel blijft
"MH-KEYBLOCK 1"); SyncLayout() vóór de export. De rijen kwamen al uit de actieve indeling (GEMETEN in een echte
Forever-12×4-code in Robs SV, Druid Ima: A|Q, C|CTRL-F|KEYBLOCK_T_BANDAGE …). Uitleg in KeyBlock.lua: codes van 5.9.x
zonder `layout=` herkent de site aan A|Q/E/R/F of een CTRL-key behalve 1/2/3 (NIET aan Z X C V op A: die heeft het oude
blok ook — correctie op het voorstel van de site-chat). Site-chat bouwt het 12×4-raster + deel-link en leest beide
formaten, dus de site mag live vóór onze release. Een code mét layout= is offline niet gemaakt: komt na Robs /reload.

## ▶▶ 25 nov (Bouwchat 25-11): CURSEFORGE_DESCRIPTION.md herschreven na de Fable-review — Rob plakt hem op CF

Rob via Sparring, letterlijk: *"Ik zeg ja op jouw advies."* (1 Beta-zin weg, 2 Forever onder 6 kopjes en dubbele regels
samen, 3 ontbrekende functies invoegen zonder dat het langer wordt) en eerder *"indien nodig verbeteren"*.
Elk punt eerst zelf nagemeten in de code. Verbeterd: de "turning 3D figure" bij de trainer is weg (ForeverTrainer.lua:854-860:
het venster met model opent alleen nog met een level-argument, "none left in MH"; level-up opent de trainerpagina in het
overzicht, ForeverOverview.lua:450-452); "about 70 more" → *All commands* (Midnight: Tools, Forever: tandwiel); Beta-zin weg;
Midnight-healers: normale heals op 1-3, noodheal op C (enUS KEYGUIDE_INTRO_MN); E = interrupt "or the nearest thing";
missing-buff Midnight eigen regel zonder "now"; "New:" weg; eerste keer "Midnight Helper (MH)"; zoekkop "Midnight: …";
regel naar THIRD_PARTY.txt. Forever nu onder 6 kopjes (17 regels, was 29), plus een blok "In both games" (12 × 4,
upgrade-melding, macro's). Ingevoegd, allemaal GEMETEN in enUS/de code: Forever no-XP-waarschuwing, You just learned,
rested-XP-tip (standaard aan), worn gear + repairer (aan), MH: sell junk, tooltipregels class/quest, reputatie/valuta +
deze week, uitleg Dungeons & group, smart buff/bless (standaard UIT: "can switch on"); Midnight groepshulp, /mh map,
/mh export + /mh raidbots, account snapshot, /mh achlist, het level-90-venster, de play card-onderdelen. Waylaid Crates
en de Mage Study-tip bewust weggelaten (Robs keuze). Midnight-extra's (5 / Shift+Spatie) GEMETEN in de code: werken in
Midnight (ForeverKeyExtras.lua in de Midnight-toc, eigen Midnight-tak; Robs Midnight-SV keyExtras.on = true).
`MidnightHelper_Camelot.toc` Notes bijgewerkt (was nog de 5.0.x-lijst; zichtbaar na een herstart in de addonlijst).
📌 Voor de volgende release: RELEASE_NOTES.md regel 3 zegt "We put out betas regularly" (laatste beta 4.14.0-beta2,
29 okt). In 5.9.1 bewust niet aangepast (al uitgebracht); in de volgende notitie anders zeggen of weglaten.
✅ Daarna ook gedaan (Rob via Sparring: *"En ja op het opknappen van de 3 zinnetjes in de commandolijst."*): CMDLIST_LANG
+ "ru" (`/mh lang ru` bestaat, Locale.lua:81), CMDLIST_OVERVIEW noemt de 7 tabs met de tabnamen van elk pack (FOV_TAB_*;
esMX "Calabozos y grupo"), CMDLIST_BLOCK "opent het venster: neerzetten, nieuwe spells, terugdraaien". enUS, nlNL,
Translations2026 (de/fr/es/pt/it), ruRU.lua, ForeverClassQuests_de/fr/es/esMX/pt/ru. check_drift: CMDLIST_BLOCK +
CMDLIST_LANG gemarkeerd (7 talen); GEARLADDER_FOOT en MBUFF_EUI_OVERLAP_HINT stonden al gedrift, niet aangeraakt.
locale_probe: LANG en BLOCK in alle 8 talen OK. ⚠️ Blinde vlek van de probe: hij zet geen IS_FOREVER, dus de
ForeverClassQuests_*-packs laden niet (controle: FOV_TAB_NOW geeft hetzelfde "still English"). CMDLIST_OVERVIEW is daar
dus niet meetbaar, alleen syntax-gecontroleerd. Nog open: KEYBLOCK_STYLE_FOREVER_ONLY is verouderd (alleen een
terugval, komt nooit in beeld).

## ▶▶ 25 nov (Bouwchat 25-11): RELEASE 5.9.1 (Rob via Sparring, letterlijk: "release 5.9.1")

Geen beta. Versie 5.9.1 in beide toc's; CHANGELOG_591_1 t/m _6 (enUS) + Changelog.lua; `RELEASE_NOTES.md` byte-gelijk aan
`docs/CURSEFORGE_5.9.1.md` (cmp: gelijk); CHANGELOG.md; SITE_SEIN: de regels van 24-25 nov op "getagd" + een
release-regel. Alleen spelersdingen in de tekst. Bewust NIET in de spelerstekst: de InterruptMacros-icoonfix (Midnight
"MH+"; die fout is daar nooit gezien, alleen afgeleid), /mh disenchant en /mh buffs als diagnose.
NIET in het spel getest maar wel in de release (Sparring noemde het): de twee buff-fixes (offline 12/12 + 18/18) en het
trainervenster met toetsen + vorm.
✅ Tag v5.9.1 op f372713. Release-run 45578909374 geslaagd (Retail, Forever, verify). GEMETEN in de CF-API (25 nov
~08:55 UTC): v5.9.1 (id 9807222, 12.0.7-12.1.7) en v5.9.1-forever (id 9807230, 1.60.1), allebei Release, status 4; de
GitHub-release heeft beide zips. Wago: "Success!" in het run-log, niet apart nagemeten. SITE_SEIN op "staat op CurseForge".
🔴 Nog open voor Rob: kijken of de changelog op CurseForge netjes rendert (Files → het bestand → Changelog).
✅ `CURSEFORGE_DESCRIPTION.md` daarna bijgewerkt (Rob via Sparring: *"ja doe maar"*): Midnight 12 × 4 bij "Your keys",
Forever Layout-knop + iconen volgen de vorm, nieuwe regel "For enchanters" (tooltip, tas-icoon, Ctrl+Shift+klik), buffs
op jezelf + geen "runs out soon" onder een sterkere buff. 5.9.0-punten nagelopen: stonden er al. 🔴 Rob plakt hem op de
CF-projectpagina (de packager doet dat niet). Sparring laat daarna twee helpers beschrijving + site + screenshots nalopen.

## ▶▶ 25 nov (Bouwchat 25-11): Forever-buffs — geen "runs out soon" bij een HOGERE rank van een ander — GEREPAREERD, wacht op test

Rob (Forever Mage, screenshot "Arcane Intellect (1 min left) runs out soon"), via Sparring letterlijk: *"ik had van een
andere mage al een hogere rank gekregen die dus nog 2 minuten actief is, en dan blijft dit irritant in beeld, dat moet
natuurlijk niet"*; op het voorstel: *"ja"*. Voor 5.9.1.
Oorzaak GEMETEN in de code: `ForeverBuffs.lua` ExpiringLeft keek alleen naar de tijd, niet naar de rank. Fix: zit de
buff op je als rank hoger dan je eigen BestRank (positie in IDS[name], ranks van laag naar hoog: GEMETEN in
ForeverSpellIds.lua, bv. Mark of the Wild 6756 vóór 5234 = rankvolgorde), dan geen "runs out soon"; is hij op, dan de
gewone "ontbreekt"-melding met je eigen rank. Geldt voor alle Forever-buffs (buff en choice). `/mh buffs` zegt dan
"runs out soon, but a higher rank from someone else is on you (rank X, you know rank Y), N s left: wait until it is
gone". Offline: scratch `buff_rank_test.lua` 12/12 (hoger stil, eigen/lager/gelijk wel, lang geldig niets, op → missing,
alle ranks gekend → wel).
AFGELEID, niet gemeten in Forever: dat het spel je lagere rank weigert zolang een hogere actief is (klassieke regel).
✅ Daarna ook de covers-tak (groepsbuff van een ander), Rob via Sparring op (a): *"Ik volg uiteraard jouw advies"*. GEMETEN
in wago DB2 SpellEffect (Forever 1.60.1.71091, EffectBasePointsF): Arcane Brilliance 23028 = 31 Int = Arcane Intellect
rank 5; Prayer of Fortitude 21562/21564 = 56/70 = PW: Fortitude rank 5/6; Gift of the Wild 21849/21850 = Mark of the
Wild rank 6/7 (armor, stats, alle vijf resistances gelijk). Tabel COVER_EQUIV: is je eigen hoogste single rank zwakker
dan de groepsbuff, dan stil tot hij op is; even sterk of sterker = de knop biedt je single buff zoals eerst. Paladin
Greater Blessings: die tak bood al nooit iets (geen `buff` in de def, GEMETEN in de code). Offline 18/18 (ook: elk id
van de tabel staat in de spell-id-lijsten).

## ▶▶ 25 nov (Bouwchat 25-11): Forever — Ctrl+Shift+klik in de tas = Disenchant GEBOUWD — ✅ GETEST

✅ Rob via Sparring, letterlijk (ruw, Willow; "mates" = zijn Mage): *"de disenchanten met mijn mates. Ik kon gelukkig wat
zelf maken. Dat werkt ook. Shift-Ctrl ingedrukt houden en dan klikken naar het disenchant en dan gooit het netjes in mijn
tas. Dus daar ben ik blij mee."* Niet apart genoemd: Baganator of Blizzard-tas, gewone klik zonder Ctrl+Shift, de
schakelaar, gevecht, character zonder Enchanting.

Rob via Sparring, letterlijk: *"Kunnen wij een knop in de tooltip bouwen als we een item kunnen disenchanten? Zodat ik
niet eerst disenchant moet drukken, dan het ding wat ik wil disenchanten, maar dat we gewoon de tooltip daarvan kunnen
gebruiken."*; op het voorstel (Ctrl+Shift+klik, Blizzard-tassen + Baganator, eerst alleen Disenchant): *"Ja … En we
beginnen inderdaad met digijant eerst. En dan kunnen we prospecting en mailing later kijken."* Gezien in ForeverForge
Bags (niet geïnstalleerd, licentie onbekend): niets overgenomen.
Gebouwd in `ForeverDisenchant.lua` deel 4: één secure knop op UIParent (nooit aan een tasknop gehangen). Toont de tooltip
een "yes"-item in je eigen tassen (bag 0..NUM_BAG_SLOTS, link op die plek = tooltip-link), dan zet MH die knop buiten een
gevecht op schermpositie over het vakje (type spell, 13262, target-bag/slot), met state driver
`[combat] hide; [mod:ctrl,mod:shift] show; hide`: alleen zichtbaar zolang Ctrl én Shift ingedrukt zijn, dus een gewone klik
komt altijd bij de tas. Weg bij: muis van het vakje, tas dicht, ander item op die plek, BAG_UPDATE_DELAYED, begin gevecht.
Tooltipregel FDE_CLICK_HINT (alleen als het kan); tooltip op de knop FDE_CLICK_ARMED. Schakelaar foreverDisenchantClick
(aan; overzicht → stille helpers, en `/mh disenchant click on|off`); `/mh disenchant` print de laatste beslissing.
Teksten 7 talen (geen itIT: Forever heeft geen it-client).
GEMETEN: Baganator live-knoppen hebben GetBagID()/GetID() (ItemViewCommon/ItemButton.lua:628); de classic-variant houdt de
tas op de parent (:1286), daarom parent-ID alleen bij een knop met `.BGR`. Offline: scratch `de_click_test.lua` 36/36
(Blizzard + Baganator-knop, bank/bag -1 nee, ander item nee, combat nee, schaal ×2, tas veranderd, muis weg, schakelaar,
geen Enchanting, characterscherm-vakje nee). NIET in het spel getest.
NIET gemeten: of Blizzards Forever-tasknop GetBagID heeft (AFGELEID: het tas-icoontje van 18 nov gebruikt hetzelfde en
werkt); of Shift bij het openen van het lootvenster autoloot omdraait (Disenchant duurt even, dan heb je meestal al
losgelaten; AFGELEID); of de server bij een BoP-item een bevestiging vraagt.
Rob ook (via Sparring): **Sunder Armor = (a)**, niets doen en wachten op Blizzard (*"Wat Sunday Arbor betreft doe ik jou
volgen."*). Komt er Blizzard-nieuws (hotfix of bevestiging): melden aan Sparring. **5.9.1 wacht tot Disenchant erbij zit**
(*"we wachten nog heel eventjes met 5.9.1 totdat we deze ook erbij hebben"*); release blijft alleen op "release 5.9.1".
📌 Handoff gesplitst (1700 → 1176 regels) bij "20 nov — drie testpunten goedgekeurd".


## 📌 Ouder, maar nog niet af — staat in `docs/NEXT_SESSION_ARCHIVE.md`

De historie is afgesplitst (2 sep en 6 nov). Deze secties lezen daar nog als OPEN, dus ze
staan hier bij naam — een openstaand punt mag niet verdwijnen door oud te zijn.

⚠️ Bewust te ruim: de lijst kijkt alleen naar de kop. Is een punt af, zet een stukje van de
kop met de reden in `KNOWN_DONE` in `tools/split_handoff.py` en draai
`python "<repo>/tools/_probe.py" run split_handoff --reindex --write`. Niet met de hand
bewerken: dan loopt de lijst binnen een week uit de pas met het archief.

- ▶▶ VOLGENDE BOUWCHAT (21 nov, avond): nieuwe Forever-reeks "leren van Polestar/FlowUp" — punt 4 en 2 GEBOUWD, 1 = B, 3 rust
- ▶▶ VOLGENDE BOUWCHAT: Forever-overzicht "D" — stap 1 en 3 gebouwd; stap 2 wacht op Robs screenshots (20 nov, avond)
- ⏭️ VOLGENDE BOUWCHAT (Bouwchat 17-11 (3) draagt over; laatste commit 542715e, alles gepusht, geen release)
- ▶ OPEN OPDRACHT: `/mh selftest` + vensterlijst (opdracht 7, sparring-chat; Rob: "niks later", dus al op 11 nov)
- 🔜 OPEN na 28 okt (overdracht naar de bouwchat van 29 okt)
- 🔜 OPEN na 26 okt (overdracht naar de bouwchat van 27 okt)
- 🔜 OPEN na 23 okt (overdracht naar de bouwchat van 24 okt)
- 🌅 VOLGENDE CHAT EERST (stand eind 16 okt; bouwchat gearchiveerd door Rob)
- 🌅 16 okt — MORGEN EERST (Rob, 15 okt nacht: "onthoud dit dan kunnen we morgen verder")
- (verslag) 🔴 VOOR MORGEN — Venom Lancer Ori'kassi is geen rare maar een SCENARIO
- 🔴 9 sep — de weekly-vinkjes rusten op bewijs dat niets waard is (OPEN)
- 🆕 30 aug — waar komen onaangeleerde recepten vandaan? (OPEN)
- 🔵 OPEN 29 aug — de SMC-pin zet TWEE waypoints, plus één die niemand vroeg
- 💡 ROB-VERZOEK 19 AUG — "dit soort info moeten wij ook gaan bieden!!!"
- 🎯 MORGEN 19 AUG — PRIORITEIT: de EU-seizoensstart
- ⚠️ OPEN, en het raakt alle vertaalwerk
- 🌅 MORGENVROEG — twee dingen, en Rob brengt data mee
- 🔴 De grootste openstaande vraag (Rob, 11 aug)
- ⏳ Wacht op Rob

📌 Al het afgeronde werk staat in het archief; daar wordt niets meer aan
toegevoegd. Nieuwe regels horen bovenaan dit bestand.
