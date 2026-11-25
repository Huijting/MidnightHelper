# Midnight Helper — waar we staan

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
🔵 OPEN VOOR ROB: Warlock-Stamina (klasse-rij {Intellect, Stamina}, Demonology/Destruction {Intellect, Stamina} equal) NIET
veranderd. wadv_test 92/92, tokcheck 68 sleutels 0 fouten.

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

## ▶▶ 25 nov nacht (Bouwchat 24-11): Midnight 12 × 4 op Robs Prot Paladin — UITKOMST (vóór 5.9.1 nog testen)

GEMETEN in keyBlockProbe (retail-SV 25 nov 00:07, spec 66, layout 12x4, slot voor slot): ALLES staat zoals het plan, op
één toets na. 2 Avenger's Shield · 3 Blessed Hammer (vervangt Hammer of the Righteous, zelfde knop) · 4 Shield of the
Righteous · Q Sentinel (vervangt Avenging Wrath) · E Rebuke · R Divine Steed · F Hand of Reckoning · Z Ardent Defender ·
X Divine Shield · C Guardian of Ancient Kings · V Cleanse Toxins · Shift-1 Consecration · Shift-3 Blessing of Sacrifice ·
Shift-Q Divine Toll · Shift-E Arcane Torrent · Shift-R Rite of Sanctification · Shift-F Hammer of Justice · Shift-Z
Blessing of Protection · Shift-X Holy Bulwark · **Shift-C Word of Glory (85673: NIET leeg)** · Shift-V Blinding Light ·
Ctrl-1/2/3 Devotion / Crusader / Concentration Aura (dus: de aura's bestaan en zijn knoppen in Midnight, GEMETEN) ·
Ctrl-4 Intercession · Ctrl-E Blessing of Freedom · Ctrl-R Redemption · Ctrl-F combat potion (241308) · Ctrl-Z health
potion (271884). Leeg: Shift-2, Shift-4, Ctrl-Q (niets voor in het plan), Ctrl-X/Ctrl-C/Ctrl-V (geen bruikbare trinket /
geen Healthstone). Alt: Spellwarding, Recuperate, een eigen macro, Flash of Light, Lay on Hands.
De afwijking: **toets 1 = "refuse", met spell 375576 (Divine Toll), dat ook op Shift-Q staat**. In de code kan dat
alleen de Single-Button Assistant van Blizzard zijn (IsAssist, KeyBlock.lua; die meldt zich als de spell die hij
voorstelt). MH bedekt of verplaatst die bewust nooit (een addon kan hem niet terugzetten). AFGELEID, niet op Robs scherm
gezien. Dus Judgment staat niet op 1. Wat Rob doet: de Single-Button Assistant van toets 1 slepen (bv. naar een Alt-plek),
dan `/mh block` → "Update (add new spells)": Judgment komt op 1. Geen code-fout. Rob: *"het ziet er nu wel goed uit"*.
✅ 25 nov GETEST (Rob via Sparring, letterlijk): *"Sorry, ja, toets 1 was ook gelukt. Judgment zit nu op toets 1."*
Trinkets: *"ik heb geen trinkets met een use"* (3 characters) → leeg is juist. Alles gezet in Midnight: *"werkt ook keurig"*.
Idee voor later (NIET gebouwd): de vraag/Update zegt het met naam als een plek de Single-Button Assistant houdt.

## ▶▶ 25 nov nacht (Bouwchat 24-11): Midnight 12 × 4 op Robs Prot Paladin — balken ≠ plaatje (eerdere stand)

Rob: *"volgens mij zet hij ze niety in mijn keyblock , ook niet na update"*, daarna *"het gaat niet om het block dat MH
laat zien maar mijn layout in game , onder dat block, dat komt niet overeen"*. Sparring zag op een klein screenshot
(NIET betrouwbaar): Shift-C (Word of Glory) leeg, Ctrl-X/Ctrl-V leeg. Robs retail-SV is van 24 nov 17:50, dus van vóór
de test: keyBlockProbe moet na zijn /reload nog gelezen worden (live knop per slot ↔ plan).
Al gerepareerd (GEMETEN in de code): het plaatje toonde bij de trinket-plekken altijd het icoon van de trinket die je
DRAAGT (slot 13/14), maar neerzetten zet alleen een trinket met een Use:-effect (UsableTrinkets, 5 okt). Nu dezelfde
regel op het plaatje (FixedWant), met een tooltip die de gedragen trinket noemt (KEYBLOCK_TRINKET_PASSIVE_FMT, 8 talen).
Of Robs trinkets echt passief zijn is NIET gemeten (de tooltip laat het zien). Open: de vergelijking slot voor slot.
⚠️ KEYBLOCK_FIXED_HINT ("you put this one on the key yourself") is verouderd: MH zet items zelf neer. Nog aanpassen.

## ▶▶ 24 nov avond (Bouwchat 24-11): Forever — macro-icoon volgde de vorm niet — ✅ GETEST (Rob: *"forever test ook gelukt met de druid, en nu weltrusten"*)

Rob: *"o wacht, het word wel maul en die andere maar de icoontjes zijn hetzelfde als die van niet in beer vorm !!"*
GEMETEN in `_forever_/WTF/.../93/Ima-Druiddude/macros-cache.txt` (23:41): de teksten kloppen ("MH 1" = `[bonusbar:3]
Maul; [nobonusbar:1/2/3] Wrath`, "MH F" Growl, "MH CTRL-1" Bear Form), maar elke herschreven MH-macro had een vast
icoon-nummer (136006 = Wrath …), de nooit herschreven nog INV_MISC_QUESTIONMARK. Oorzaak: ForeverEnsureMacro gaf bij
EditMacro het icoon van GetMacroInfo terug, en dat is bij een vraagteken-macro het icoon dat NU getoond wordt
(AFGELEID uit dat patroon) → #showtooltip bevroor. Sinds de eerste herschrijving van een blokmacro (Druid-blok 5 nov;
AFGELEID). Fix: EditMacro altijd met het gewenste icoon (cmd.icon of het vraagteken); eenmalige reparatie per character
(`ns.db.foreverMacroIconFixed[guid]`) in RefreshExisting; zelfde patroon gerepareerd in ForeverMacros.lua (handige
macro's) en InterruptMacros.lua (Midnight "MH+"-macro's). Trainervenster: KeyFor gebruikt nu de tabel van de gekozen
indeling (was altijd het oude blok → F2 i.p.v. Shift-C bij 12 × 4) en zegt "1 (Bear Form)" bij een vorm-toets (chip in
het overzicht: alleen "1", de vorm in de tooltip); dat deel is NIET offline getest. Offline: `bear_test.lua` 11/11.
De eerdere melding "krijg ze niet op mijn keys" vervalt (Sparring: was dit). De extra SPELLS_CHANGED-herschrijving blijft
(onschadelijk, vangt een spell uit een quest).

## ▶▶ 24 nov avond (Bouwchat 24-11): Forever Druid, Bear Form geleerd, toetsen volgden niet — gerepareerd, wacht op test

Rob: *"maar ik heb net mijn beer vorm gehaald maar krijg deze spells niet op mijn keys ?"* (Forever Druid ~10, 12 × 4).
Uitgezocht in de code: (1) een NIEUWE toets (Ctrl-1 = Bear Form) krijgt zijn macro alleen via de vraag "New for your
key block" (KeyBlock.lua CheckNew op SPELLS_CHANGED → MissingRows) of Update. Op 5.9.0 crashte MissingRows op deze
Druid (fout 1527, wees-macro Shift-Z; aa781a1 staat nog niet in een release), dus daar kwam géén vraag (AFGELEID; of Rob
op 5.9.0 speelde vraagt Sparring na). (2) Bestaande "MH <toets>"-macro's (1, F …) werden alleen herschreven op
LEARNED_SPELL_IN_SKILL_LINE / inloggen / na een gevecht; of dat event vuurt voor een spell uit een QUEST is niet gemeten.
Fix: ForeverBlock.lua herschrijft ook op SPELLS_CHANGED (één keer per golf, na 1 s; begint er een gevecht, dan erna).
(3) De gereserveerde Ctrl-1 (1b8a696) houdt alleen ANDERE spells weg; Bear Form zelf krijgt Ctrl-1 als eigen toets.
Offline: scratch `bear_test.lua` 6/6 (MH 1 = "[bonusbar:3] Maul; [nobonusbar:1/2/3] Wrath", MH F = Growl/Rejuvenation).

## ▶▶ 24 nov avond (Bouwchat 24-11): 12 × 4 voor MIDNIGHT (stap A2) — AF, wacht op test

Controle: 4× mh-research (scratch `review12_g1..g4.md`) + tweede Opus (`review12_final.md`, met eigen simulatie van
KeyBlockAllocate): 76 ACCEPT + HEALER A (Rob: *"a ja"*) in `Modules/KeyBlock12Exceptions.lua`, op spell-id (+ basis-id
bij vervangende talenten: het spellbook meldt die onder het id van de spell die ze vervangen). AFGEWEZEN o.a. Steady
Shot→D en Expunge→D (op id zou dat BM's Barbed Shot / Pres' Naturalize naar D sturen) → in de rol-data opgelost.
Rol-data (ook voor het oude blok, Rob: *"a ja"*): Steady Shot specs {254,255}; Expunge {1467,1473}; Resuscitate +270;
Ancestral Spirit alle Shamans; Resurrection (Priest, 2006) en Conjure Refreshment (Mage, 190336) nieuw; The Hunt +1480;
Warrior-stances (386164/386208/386196) en Paladin-aura's (465/32223/317920) als blockForm 1/2/3 (ids GEMETEN in
SpellName; castbaar in Midnight AFGELEID — zonder spellbook-treffer worden ze nooit geplaatst). Uitlegblad Midnight:
KEYGUIDE_INTRO/BAR_A/BAR_SHIFT_MN (8 talen). Offline: `keys12_mn_test.lua` 2688 controles 0 fout, plus vaste
steekproeven (Prot Paladin 4 = SotR, Z Ardent Defender, X Divine Shield, Ctrl-R Redemption; Holy C = Lay on Hands; MW
C = Life Cocoon; Pres C = Rewind; Blood Z = AMS; Enh 4 = Lightning Bolt; Disc Ctrl-R = Resurrection; Arcane Ctrl-R =
Conjure Refreshment). Oude blok verschuift alleen door de nieuwe rol-data: 1165/71 → 1171/91 (stances/aura's houden
Ctrl-1/2/3 vrij bij Warrior/Paladin, overloop gaat dan naar D).
NIET gemeten / open (review12_final.md DATA): welk id het spellbook meldt bij een spec-vervanging (Healing Wave/8004,
Mind Flay/585 …; één spellbook-dump op een Resto Shaman of Shadow Priest beslist het); ids alleen in survivalId zijn
onzichtbaar voor de id-lookup (Holy Divine Protection 498, Blink …) → op een niet-Engelse client ongeclassificeerd;
Whirlwind Arms 1680 / Templar's Verdict 85256-ids; Eternal Flame blockAs[65]; Naturalize bindKey V; Raze / Red Moon /
Rushing Wind Kick vallen waarschijnlijk via het basis-id goed (AFGELEID).

## ▶▶ 24 nov avond (Bouwchat 24-11): 12 × 4 voor MIDNIGHT (stap A2) — tabel gebouwd (eerdere stand)

Rob via Sparring, letterlijk: *"A A A"* = 1a (rol-naar-toets-tabel uit de bestaande KeybindRoles, daarna mh-research per
spec + tweede Opus-controle, uitzonderingen per spec), 2a (Ctrl-F combat potion, Ctrl-Z health potion, Ctrl-X trinket 2,
Ctrl-C healthstone, Ctrl-V trinket 1), 3a (Blizzards willekeurige favoriete mount). Keuze 1a "alleen Forever" VERVALT.
Gebouwd (`KeyBlock.lua`): LayoutName zonder Forever-poort; BLOCK_12R (Ctrl-rij Midnight); ANCHOR12/CATEGORY12/OVERFLOW12
+ ANCHOR_ORDER12_HEAL (healers: heals vóór de defensives, C = grote heal); KeyBlockAllocate schaduwt de tabellen bij 12x4
in Midnight; `free()` eist nu dat de toets in de indeling BESTAAT (bindKey "5"/"Shift+F1" lekte anders naar een
niet-bestaande toets; oud blok GEMETEN ongewijzigd: 1165 geplaatst / 71 over, voor en na); FixedWant `combatpotion`
(ConsumablesWowhead combatPotion) en `trinket2`; geen tweede-trinket-overflow als Ctrl-X vast is; login-waarschuwing,
`/mh block style`, knop Layout en "Why these keys?" nu ook in Midnight (KEYGUIDE_BAR_CTRL_MN / _EXTRA_MN).
`ForeverKeyExtras.lua` ook in Midnight: Shift+Spatie = macro `/dismount [mounted,noflying]` + `/run if not IsMounted()
then C_MountJournal.SummonByID(0) end` (nooit afstijgen in de lucht), alleen als je een bruikbare mount hebt;
NEW_MOUNT_ADDED; eigen vraagtekst KEYEXTRA_ASK_MN_FMT. Offline: scratch `keys12_mn_test.lua` 40 specs × 2 indelingen,
2734 controles 0 fout (geen spell op een oude-alleen-toets of vaste plek, interrupt op E, healer-C = heal waar
heal_sustain bestaat); totaal 12×4 1150 geplaatst / 86 naar blok D. Dump per spec: scratch `keys12_mn_dump.txt`.
GEZIEN in de dump, voor de controle: Holy Paladin C = Blessing of Protection (zijn heals zijn main_rotation, geen
heal_sustain); Lay on Hands op Ctrl-R (heal_ooc). Open: controle per spec (mh-research + tweede Opus), uitzonderingen,
itIT-vertalingen (alle 12×4-teksten missen itIT: Forever had geen it-client), TESTLIJST/IDEEEN/SITE_SEIN.

## ▶▶ 24 nov avond (Bouwchat 24-11): buff-knop cast op jezelf (stap B) — wacht op test

Rob (Druid, Thorns): *"Elke keer als die in beeld komt, moet ik eerst mezelf aanklikken en dan pas kan ik op het knopje
drukken."* Oorzaak GEMETEN in de code: `MissingBuff.lua` ApplySecureCast zette bij een spell alleen type + spell, geen
`unit`; dan cast het spel een helpful spell op je target, en wacht op een klik als dat een vijand is. Fix: de entries
van de Forever-buffs (`ForeverBuffs.lua`: ontbrekend + "runs out soon") krijgen `self = true`, en de knop zet dan
`unit = "player"`; `unit` wordt op elk pad eerst gewist. Pet-spells (Call/Revive Pet, demonen) en het ally-macropad
blijven zoals ze waren. Midnight (retail-entries) onveranderd. Groepsbord: de eigen rij zet al `unit = row.unit`
(= player), GEMETEN in `ForeverReadyBoard.lua` (CastButton unit). Offline: scratch `selfbuff_test.lua` 9/9.

## ▶▶ 24 nov avond (Bouwchat 24-11): knop "Layout" in het toetsenblok (stap A1) — wacht op test

Rob via Sparring (letterlijk in IDEEEN). `KeyBlock.lua`: `f.styleBtn` (TOPRIGHT -150,-40, 300 px, onder New spells; de
bovenste rij zit vol, de intro maakt rechts 470 px vrij), `ns.KeyBlockCanUse12` (nu: Forever + keys12),
`ns.KeyBlockAskSwitchStyle` (StaticPopup MH_KEYBLOCK_SWITCH, teksten bij het tonen, twee teksten: geplaatst / niet
geplaatst) en `ns.KeyBlockSwitchStyle` (undo als het blok stond → KeyBlockSetStyle → Place als het stond; nooit in een
gevecht; weigert SetStyle, dan wordt er niets neergezet). Hooks van ForeverKeyExtras werken mee (Place = de extras-vraag,
naar oud = extras weg). Teksten 7 talen (KEYBLOCK_STYLE_BTN_FMT, KEYBLOCK_SWITCH_*). Offline: scratch `switch_test.lua`
16/16. Midnight: knop verborgen tot stap A2 (12 × 4 voor Midnight). Daarna B (Thorns-knop), dan A2.

📌 Na 5.9.0 (site-chat, bijvangst): nlNL noemde het venster in 4 regels "Do this now" i.p.v. de nl-titel "Doe dit nu"
(SET_FOREVER_WEAR_TITLE/_DESC, FTALENT_SW/_DESC) → nu "Doe dit nu". GEMETEN: daarna 0 keer "Do this now" in nlNL.lua.
Gaat mee in de volgende release.

## ▶▶ 24 nov avond (Bouwchat 24-11): RELEASE 5.9.0 getagd (Rob via Sparring, letterlijk: "release 5.9.0")

Geen beta. Versie 5.9.0 in beide toc's; CHANGELOG_590_1 t/m _8 (enUS) + Changelog.lua; `RELEASE_NOTES.md` byte-gelijk aan
`docs/CURSEFORGE_5.9.0.md` (5476 bytes, LF, GEMETEN met een scratch-vergelijking); CHANGELOG.md; SITE_SEIN: de regels
van 23-24 nov op "getagd" + een release-regel. Alleen Forever in de spelerstekst; de Midnight-voorbereiding op 12.1.7
werkt pas op een 12.1.7-client en staat er dus niet in (Sparring: alleen noemen als spelers er nu iets aan hebben).
✅ Tag v5.9.0 op 1bdc468. Release-run 45451928608 geslaagd (Retail, Forever, verify). GEMETEN in de CF-API (24 nov 17:53
UTC): v5.9.0 (id 9795543, 12.0.7-12.1.7) en v5.9.0-forever (id 9795583, 1.60.1), allebei Release, status 4; de
GitHub-release heeft beide zips. Wago NIET apart nagemeten (de run meldt Retail en Forever geslaagd). SITE_SEIN op
"staat op CurseForge".
✅ `CURSEFORGE_DESCRIPTION.md` bijgewerkt (Forever: 12 × 4 + Why these keys? + 5/Shift-Space, groepscheck, QuestieDB,
Do this now: upgrades, tasplekken, How you play-knop; How you play noemt je toetsen; credit-regel QuestieDB).
✅ 25 nov: Rob heeft de beschrijving op de CF-projectpagina geplakt (via Sparring, letterlijk: *"En cursewords had ik de
nieuwe beschrijving geplakt."*). ✅ 25 nov: changelog op CurseForge netjes (Rob via Sparring: *"En ook de changelog was
goed."*).

## ▶▶ 24 nov avond (Bouwchat 24-11): Lua-fout KeyBlock.lua:1527 (Druid, na harde uitval) GEREPAREERD — wacht op test

Rob, Forever Druid, bij inloggen na een onverwachte herstart (de kat zette de pc uit): `KeyBlock.lua:1527: bad argument
#1 to 'tostring' (value expected)`, via 1812 (de nieuwe-spell-vraag) → MissingRows. Oorzaak GEMETEN in de locals: slot
145 (SHIFT-Z, bar B) = ("macro", 0), en `GetActionText` gaf GEEN waarde terug (geen nil: tostring() zonder argument
gooit "value expected"). De knop wil "MH SHIFT-Z" (offline, Druid 12×4); GEMETEN: die macro staat NIET in
`_forever_/WTF/.../93/Ima-Druiddude/macros-cache.txt` (17:18) noch in `.old` (17:00), wel de andere MH-macro's (MH 1, 2, C,
F, SHIFT-E, SHIFT-X). AFGELEID: die macro werd die sessie gemaakt en ging verloren bij de uitval (macro's worden pas bij
uitloggen weggeschreven); de knop wees daarna naar niets. Fix: `pcall(GetActionText)` + alleen een echte naam telt, en
een macro-knop met id 0 zonder naam telt als LEEG, zodat de nieuwe-spell-vraag/Update de goede macro terugzet
(PlaceAction wisselt de kapotte eraf). Een macro met naam maar id 0 (bv. FishFry) blijft "bezet". GEMETEN ook: dit is
de enige plek waar GetActionText in tostring() ging (de andere 8 vergelijken of geven door). Locals ook: macro's melden
in Forever de spell-id van #showtooltip als id ("macro:5185" = Healing Touch). OVERFLOW = de lijst van het oude blok, ook
bij 12×4: sleutels die 12×4 niet heeft (F3, SHIFT-F1) worden overgeslagen (byKey nil), de rest bestaat in beide; maar
MissingRows filtert de CTRL-vormtoetsen niet zoals PlacePlan (hasForms) → kan bij een Druid zonder vorm een nieuwe
spell op Ctrl-1..3 voorstellen. → ✅ DAARNA OOK GEREPAREERD (Sparring: *"neem het mee nu, vóór de release"*):
MissingRows slaat nu dezelfde toetsen over als het neerzetten (hasForms uit res.occ, zoals de tweede trinket) én, in
Forever, elke toets die de class-tabel (ClassTable().keys, huidige indeling) voor iets bedoelt; zo blijft de toets van een
onbekende vorm leeg en niet fout. Gevolg in Forever: staat de eigen toets van een nieuwe spell vol met iets van de
speler, dan wacht de spell (geen plek) in plaats van op een andere vaste toets te landen. Offline: scratch
`orphan_test.lua` 12/12, met tegencontrole (zonder de fix landt hij op CTRL-1).

## ▶▶ 24 nov avond (Bouwchat 24-11): groepsbord — titel onder het sluitkruisje GEREPAREERD — wacht op test

Rob (nl, solo op zijn Druid): *"Het afsluitknopje loopt door de tekst heen."* Oorzaak: de breedte kwam alleen uit de
kolommen (min. 300 px), en de Forever-stijl zet een groter lettertype NA de eerste Render. Fix (`ForeverReadyBoard.lua`):
breedte ≥ titelbreedte + 54 px (gemeten met GetStringWidth); 0,25 s na het tonen nog eens meten en zo nodig opnieuw
Render (het bord hangt aan zijn midden, dus breder = alle cellen schuiven; Render zet de klikknoppen opnieuw).
Langste titel per tekens: de "Gruppencheck: Buffs und Verbrauchsgüter" (39); de meting dekt elke taal. Offline 44
controles (scratch readyboard_test.lua; de stub-HookScript verving het oude script, nu rijgt hij zoals het spel).
Punt 2/3 van Sparring vervielen (Rob zat op de Druid; *"bij die andere had ik inderdaad ook nog geen Hearthstone
geleerd"*). Regel healthstone-kolom: alleen met een Warlock in de groep (jij telt mee). GEMETEN in Syndicator-SV: de
Minor Healing Potion (118, 2 stuks) zat in de tas van een Mage, niet van de Warlocks.

## ▶▶ 24 nov avond (Bouwchat 24-11): 12 × 4 extra toetsen (5 = interact, Shift+Spatie = mount) — wacht op test

📌 Fix daarna (Rob: *"het is nederlands (dat klopt) met engelse set them en no thanks eronder"*): de knoppen van een
StaticPopup die bij het LADEN met `ns:L` gevuld worden, zijn Engels, want het gekozen pack (nlNL is handmatig) is dan nog
niet actief. GEMETEN met grep op `button1 = ns:L(` (alle vensters): de vaste vorm is "teksten bij het tonen zetten"
(FirstRun, Survey, MaxLevelWelcome, KEYBLOCK_NEW). Afwijkend waren MH_KEYEXTRA_ASK en MH_KEYBLOCK_LAYOUT_MISMATCH
(beide vandaag) → nu bij het tonen. Ook MH_FOREVER_MYLAYOUT_RELOAD (7 nov) had vaste Engelse tekst + knoppen → nieuwe key
FMYLAYOUT_RELOAD_TEXT (7 talen) + bestaande KEYBLOCK_BTN_RELOAD/KEYBLOCK_NEW_LATER. Ter info: Shift-Spatie stond bij Rob
op Toggle Score Screen; de vraag liet dat zien. Test: 28 controles (ook: knoppen volgen een taal die na het laden komt).

Rob via Sparring: *"En shift spatie is op zich wel een goed idee voor de mount. En de interact toets, nou, doe maar een
voorstel."* → voorstel → *"Ja, ik volg advies dus A. Je trekt op 5 en dat punt blijft ook werken."*
GEMETEN vooraf: `INTERACTTARGET` bestaat in Forever (GlobalStrings 1.60.1.71091; ook INTERACTMOUSEOVER); Robs
`_forever_/WTF/Account/JOEYWHATEVER/bindings-cache.wtf`: `NUMPADDECIMAL INTERACTTARGET`, `5 NONE`, `` ` TOGGLECHARACTER0``
(niet door MH gezet: 0 treffers, tegencontrole 7); Spatie/Shift+Spatie niet in het bestand = spelstandaard (niet leesbaar
uit dat bestand; de module vraagt het live met GetBindingAction).
Gebouwd: `Modules/ForeverKeyExtras.lua` (nieuw, beide toc's): één vraag (StaticPopup na het neerzetten van 12 × 4 of
bij inloggen, met wat 5 en Shift+Spatie nu doen), `/mh block extras [on|off]` + diagnose. 5 = INTERACTTARGET als extra
toets; Shift+Spatie = `MACRO MH Mount`, een macro PER CHARACTER (`/dismount [mounted]` + `/cast [nomounted] <mount>`),
alleen als het character een mount kent (anders blijft Shift+Spatie staan tot SPELLS_CHANGED er een brengt). Undo zet
per toets terug wat er stond (`ns.db.keyExtras.prev`) en wist de macro; terug naar het oude blok = automatisch undo
(hook op KeyBlockSetStyle); na een blok-undo pakt 5 interact terug (de undo gaf 5 aan de oude blokknop).
Snelste mount: `Modules/ForeverMountData.lua` (GEGENEREERD uit Mount → MountTypeXCapability → MountCapability, 140
mounts; 4 AQ-tanks eruit, alleen in AQ40): snelheid 2/1 + nodige spell (racial riding). NIET gemeten: of Forever die
racial riding als bekende spell toont → valt terug op "negeer de eis" als je wel een mount kent maar er geen door de
check komt; of C_MountJournal bestaat (bewaakt; favoriet telt mee als het er is); of een binding `MACRO <naam>` een
per-character macro vindt (AFGELEID: binding op naam). Uitlegblad: deel EXTRA (KEYGUIDE_HEAD/BAR_EXTRA). Teksten 7 talen.
Offline: 26 controles (scratch `keyextras_test.lua`). Ook afgevinkt deze ronde: Fix it now (Druid), tas-getal + kleuren,
How you play-knop; groepsbord → later testen op hoger level; Warrior toets 3 + Priest-gids geaccepteerd (niet apart getest).

## ▶▶ 24 nov avond (Bouwchat 24-11): "Do this now" — knop How you play + vrije tasplekken — ✅ GETEST (Rob: *"Ja, beide zijn helemaal goed."*)

Rob via Sparring, letterlijk: *"kunnen we hier onder ook een knop how to play toevoegen en in het rijtje van gold aan de
linkerzijde het aantal open tas plaatsen :)"*, op de samenvatting *"ja"*. Gebouwd in `ForeverDoNow.lua`: `f.btnPlay`
(tekst `FOV_TAB_PLAY`, opent `ns.ShowPlayCardWindow`) als laatste knop in de rij; `BagText` links van `f.money`, ververst
op `BAG_UPDATE_DELAYED` (zelfde event-frame als PLAYER_MONEY). Telling = `ns.ForeverFreeBagSlots` (de FreeSlots van
`ForeverWarnings.lua`, bag family 0); oranje bij ≤ max(5, `ns.ForeverBagWarnAt()`), rood bij 0; niet leesbaar = leeg.
Nieuwe key `FDONOW_BAGS_FREE_FMT` (en, nl, de, fr, es, pt, ru). Offline: telling 15 bij 4 gewone tassen + een pijlkoker.

## ▶▶ 24 nov avond (Bouwchat 24-11): How you play volgt de gekozen indeling — ✅ GETEST (Rob: *"en in how to play staat get nu goed"*)

Rob, letterlijk: *"ik zie een fout in how to play , de oude keyblock staan er nog in"* (open punt 1 van vanochtend; trainer:
*"trainer gaat goed"*). Gebouwd (`ForeverHowToPlay.lua` `LiveKeys`/`KeyMap`): bij 12 × 4 worden bij het TONEN alle
blok-toetsen in de teksten (8 talen ongewijzigd) vervangen: oude toets → zijn spells in `keys` → waar die in `keys12`
staan (terugval nu = die toets; geen plek = "blok D" in de taal van de tekst); T/Shift-T/G → Ctrl-Z/Ctrl-C/Ctrl-V.
Vormen die gelezen worden: `**K**` overal, `(K)` en `(K, …)` alleen in "Simple order" (elders is "(4)" een level),
"<op> K" met het voorzetsel per taal (een kaal cijfer alleen voor een leesteken/haakje). Oud blok = tekst onveranderd.
Venster + overzichtspagina (ForeverHowToSections). Andere schermen: GEMETEN 0 vaste blok-toetsen in de schermteksten
(tegencontrole 116 in HowToPlay). Offline: 151 controles (scratch `howto_keys_test.lua`).

## ▶▶ 24 nov avond (Bouwchat 24-11): trainerpijl naar Mirket i.p.v. Dhugru GEREPAREERD — ✅ GETEST (Rob: *"trainer gaat goed"*)

Rob (Horde Warlock, Razor Hill), letterlijk: *"Ik sta op dit moment bij mijn warlock trainer, maar hij stuurt me een heel
andere kant op."* en *"ja die naam staat er"* (Dhugru Gorelust). Oorzaak GEMETEN in zijn SV: `foreverTrainerCap[3172] =
{ cap = 6, seen = 6 }`; ook Kardris 14/14, Narm 12/12, Sian'tsu 16/16, Nartok 4/4: de trainerlijst toonde alleen spells
tot zijn eigen level, dus "hoogste level in de lijst" = zijn level, geen trainer-cap. Reparatie (`ForeverTrainer.lua`
TrainerCap): een gemeten cap telt alleen als hij lager is dan het level waarop hij gemeten is (Mai'ah 6 op 10 = echt),
en nooit lager dan de vaste cap uit ForeverTrainerSpots (Lanka 1 op 2). `/mh trainer check` noemt nu welke trainers
overgeslagen zijn, met cap en bron. Offline 10 gevallen (scratch `trainercap_test.lua`, Robs eigen SV-waarden).
Open: waarom Un'Thuwa wél 60 gaf op level 10 (de lijst toonde toen hogere spells) is niet uitgezocht; de regel is er veilig voor.

## ▶▶ 24 nov avond (Bouwchat 24-11): terugval zonder dubbele + "Later"-geheugen — wacht op test

Rob (via Sparring 24-11), letterlijk: *"Waarom krijg ik deze, terwijl die ook al op 3 gezet wordt? En als ik hem daar
weghaal, even later krijg ik weer terug dat hij weer daarheen moet. Beetje verwarrend."* Gebouwd:
- `ForeverBlock.lua` `FallbackHeld`/`FirstFor`: een spell die een toets als terugval houdt (latere naam in de lijst)
  komt niet ook op zijn eigen toets; is de eerste naam geleerd, dan schuift hij terug. Geldt alleen voor de 4 terugvallen
  (GEMETEN: Warlock 3/Shift-2, Rogue 3/Shift-3, Paladin 4/Shift-4 en V/Shift-F); het oude blok heeft er geen.
- `KeyBlock.lua`: "Later" (OnCancel) onthoudt per character elk paar toets + spell (`ns.db.keyBlockDeclined`, macro's
  met de spellnaam, zodat een nieuwe rang niet opnieuw vraagt maar een nieuwe spell wel). Update wist dat geheugen.
- Offline: 16 gevallen (scratch `fallback_test.lua`), keys12 2252, stale/login 27. NIET in het spel.

## ▶▶ 24 nov avond (Bouwchat 24-11): uitlegblad "Why these keys?" (12 × 4) GEBOUWD — ✅ GETEST (Rob: *"JA ZIET ER GOED UIT"*; Shift+scroll/dichtklikken niet genoemd, open)

Rob via Sparring 24-11, letterlijk: *"kunnen we ook een soort blad even maken, waarbij we de users uitleggen waarom we welke
knop waar gezet hebben"* + *"… Dat gewoon voor iedereen weet dat een heal altijd op die knop staat …"*; heal-keuze *"a"*
(C = grote heal of grote defensive, Shift-C = snelle heal; niets verschoven). Eerlijk bij de toetsen die per class
verschillen ("vaste hulp-plek van je class": F, Shift-3/R/Z/X, Ctrl-4/Q/E). Gemeten per toets over 9 classes:
`docs/forever/KEYBLOCK12_TAKEN.md`. Gebouwd: `ns.ShowKeyBlockWhy` (KeyBlock.lua), venster `MidnightHelperKeyBlockWhy`
(in SCALABLE_WINDOWS), knop `f.whyBtn` bovenin het toetsenblok-venster (x 475; alleen Forever + 12×4), teksten
KEYGUIDE_* (en/nl zelf, de/fr/es/pt/ru mh-writer). Layout meet de hoogtes opnieuw na de Forever-stijl. Offline: venster
bouwt en klapt. Site-pagina: later via de site-chat (SITE_SEIN).

## ▶▶ 24 nov avond (Bouwchat 24-11): één indeling voor alle Forever-characters (Rob: *"advies a"*) — wacht op test

GEMETEN: Forever-toetsen gelden voor het hele account (één `bindings-cache.wtf`; `bindingSet = 1` in Robs SV; `style` ook
account-breed in MidnightHelperDB), de balken per character. Gebouwd (KeyBlock.lua): het neerzetten bewaart
`snap.layout`; bij het inloggen (Forever, 8 s, niet in gevecht, één keer) een chatregel + StaticPopup
`MH_KEYBLOCK_LAYOUT_MISMATCH` als dit character met de andere indeling staat ("Fix it now" = undo + neerzetten;
`/mh block fix` doet hetzelfde). `/mh block style` zegt erbij dat toetsen voor alle characters gelden. `/mh block why`
noemt "placed on this character". Oude snapshots zonder `layout` = het oude blok. Paladin V = Repentance, anders Turn
Undead (24); level 8-23 heeft hij geen andere CC (Hammer of Justice staat bewust op E). Offline getest (login-check:
4 gevallen, keys12 2252), NIET in het spel. Bevestigd uit de code (AFGELEID): na `/reload` zet "Update" of de
nieuwe-spell-vraag Immolate op toets 3 (lege plek met een macro-wens). Teststappen: TESTLIJST "24 nov (avond)".

## ▶▶ 24 nov (Bouwchat 24-11): 12 × 4 GEREPAREERD na Robs Warlock-test — wacht op hertest

Rob testte 12×4 op zijn Warlock (screenshots via Sparring 24-11). Fout 1: op balk 5/6/7 stonden nog de oude toetsen
(5, T, G, F1-F4, Shift-T, Shift-F1). Oorzaak (GEMETEN in de code, AFGELEID voor Robs account): neerzetten bindt alleen
de toetsen van de gekozen indeling; oude toetsen die nog naar een blokknop wijzen (account-bindingen van een eerder
neerzetten, misschien op een ander character, dus niet in de undo van de Warlock) bleven staan, en een knop toont zijn
eerste toets. Reparatie: `StaleBlockKeys()` in KeyBlock.lua; neerzetten maakt ze los en zet ze in de snapshot (undo
zet ze terug); `/mh block why` noemt ze (ook in de SV: `dump.staleKeys`). Offline: de 9 toetsen van de screenshots
gevonden, F2→kaart blijft.
Fout 2: Summon Imp 4× → pet-commando's tonen nu hun label + icoon (`spell.label/iconTex`, ook in de tooltip); de 4e
(Alt, block D) is bewust. Klein: "Summon Demon" (vermoedelijk een flyout, AFGELEID) telt niet meer als onbekend
(flyouts overgeslagen + naam in Warlock `listed`). Vraag 3 (Immolate op Shift-2, toets 3 leeg tot Agony op level 8):
voorgelegd aan Sparring, niets veranderd. Teststappen: TESTLIJST "24 nov (later)".
- 🔧 Vervolg (Sparring: *"ja, doe jouw advies … Kijk ook of hetzelfde gat … bij andere klassen voorkomt"*): terugval op
  rotatietoetsen waar de spell pas later bij de trainer komt: Warlock 3 = Agony, anders Immolate; Rogue 3 = Mutilate/
  Hemorrhage, anders Shank (24); Paladin 4 = Hammer of Wrath (44), anders Exorcism (20). Gemeten met scratch `gap_test.lua`
  (per level 1-60, alleen trainerlevels; begin-spells en talenten tellen daar als "niet geleerd", dus een deel van de
  overige meldingen is nep). Niet aangepast: Warrior 4 (4 levels, per stance), Shaman 4 (Fire Nova vraagt een fire totem,
  pas op 20), Druid 4 (4 levels, cat), en alle vaste-taaktoetsen (E R Z X C V). Te bekijken: Paladin V leeg 8-60 terwijl
  Purify op Shift-V staat (welke CC staat op V?).
- 📏 Bindingen GEMETEN: Forever heeft één `bindings-cache.wtf` op accountniveau, geen per character (25 character-mappen,
  tegencontrole: daar staan wel macros/config). Gevolg en advies: zie bericht aan Sparring; nog niets aan veranderd.

## ▶▶ 24 nov (Bouwchat 24-11): `data/keyblock_specs.json` opnieuw gemaakt — ✅ AF (open punt NEXT_SESSION_ARCHIVE r.7171)

Sparring 24-11, letterlijk: *"Ja: run keyblock_specs, commit en push"*. Het bestand was van 6 okt; 6 specs schoven door
bewuste datawijzigingen uit oktober (GEMETEN, vergeleken met de oude versie): Holy Paladin (Avenging Crusader F1, Divine
Toll Shift-3, Holy Prism Shift-F1; Redemption en Intercession nu zonder plek door de Rites van 22 okt), Prot Paladin,
Assassination, Shadow (Halo → Halo (Shadow)), Vengeance en Devourer (The Hunt niet meer in hun lijst). De indeling zelf
(`layout`) is ongewijzigd. Gebruikt door de site-spiekbrief (branch "keyblock"); Sparring seint de site-chat.

## ▶▶ 24 nov (Bouwchat 24-11): Forever-toetsenblok "12 × 4" GEBOUWD (1a + 2b) — wacht op Robs test

Rob via Sparring 24-11, letterlijk: *"ik vind namelijk zijn uitleg goed en wil onze versie ook zo hebben van keybinds qua
knoppen"* (Bellular-video) en *"uiteraard volg ik je advies e laat een agent uitzoeken welke spells logisch zijn per class
zodat dat automatisch kan worden toegepast"*. 1a = alleen Forever, 2b = schakelaar, oud blok standaard. VERVALT: Rob keurt
niet meer elke klasse-tabel goed; het onderzoek bepaalt, Rob test.
- 🧪 `KeyBlock.lua`: BLOCK_OLD + BLOCK_12, `BLOCK` wordt in place gevuld door `SyncLayout()` (in Build, Ensure, ArmBar1);
  het plaatje vindt knoppen nu op plek (`f.slotAt`), niet op toetsnaam. `/mh block style old|12x4` (`ns.KeyBlockSetStyle`;
  weigert als het blok geplaatst is, in gevecht, of zonder keys12 voor de class). `ns.db.keyBlock.style` (account-breed).
  `/mh block why` toont "layout: …" en per toets "12x4: <reden>".
- 12×4: A = 1-4 Q E R F Z X C V, B = Shift, C = Ctrl (1-4, Q, E, R + vaste items Ctrl-F bandage, Ctrl-Z health potion,
  Ctrl-X mana potion, Ctrl-C healthstone, Ctrl-V trinket), D = Alt (= block D, Alt-G i.p.v. Alt-Z; Sparring: *"akkoord"*).
  `FixedWant`: in Forever nu de gemeten lijsten (ForeverReadyBoardData hpot/mpot/hs/bandage) — geldt ook voor T/Shift-T
  van het OUDE blok (daar vond hij in Forever niets: retail-data).
- `ForeverBlock.lua`: ClassTable geeft in 12×4 een view met `keys12`; oude spells zonder 12×4-plek gaan VOOR toBlockD naar
  block D (tweede controle: anders vallen de armor-buffs eraf op 60). `why` telt niet als spellnaam.
- 9 tabellen `keys12` (onderzoek 3× mh-research, `docs/forever/KEYBLOCK12_<CLASS>.md`; tweede controle mh-research
  `KEYBLOCK12_REVIEW.md` → 3 wijzigingen doorgevoerd: Mage 4 = Fire Blast / Shift-3 = Pyroblast, Priest wand `bang`,
  Warlock 3 = Agony / Shift-2 = Immolate). Bandage-id's: `docs/forever/BANDAGES_FOREVER_2026-11-24.md` (12 algemeen;
  16 battleground-bandages bewust NIET).
- Offline 2248 controles goed (scratch `keys12_test.lua`: toetsen, namen, dubbelen, 255 tekens, niets kwijt), NIET in het spel.
- Open: How you play noemt nog de oude toetsen (5, F2, T/Shift-T/G; review r.33/153/176/311/381). Stap 2 (Sparring
  *"akkoord"*): mount Shift+Spatie, interact-toets, sit/sheathe/character na een vraag. Geen knop in het venster (geen
  ruimte bovenin): alleen het commando. Battle Shout-duur niet gemeten; Hammer of the Righteous: bron onbekend.

## ▶▶ 24 nov (Bouwchat 24-11): Forever-groepsbord GEBOUWD (optie A) — wacht op Robs test

Rob via Sparring 24-11, letterlijk: *"Ja maak maar"* en op *"Bedoel je doe jouw advies (A)?"*: *"ja"*.
- 🧪 `Modules/ForeverReadyBoard.lua` + `ForeverReadyBoardData.lua` (NIEUW, beide toc's; alleen actief in Forever = herstart).
  Neemt in Forever de namen `ns.ShowConsumableBoard` (`/mh readyboard`, `/mh board`, NavSearch, Launchpad) en
  `ns.PrintConsumableReadyCheck` (`/mh readycheck` = diagnose → `ns.db.foreverReadyProbe`) over; Midnight-bestanden
  staan niet in de Forever-toc, dus geen botsing (GEMETEN met grep). Nieuw: `/mh readyboard auto on|off` (Core.lua).
- Eigen kolommen: elixer/flask (75), eten (Well Fed + 5 andere namen; vissen/kruiden/snelheid tellen NIET), wapen
  (`ns.ForeverTempEnchant` + `ns.FOREVER_WEAPON_ITEMS`, nieuw export in ForeverBuffs.lua), hpot, mpot (mana-classes),
  hs (alleen met Warlock). Buffs: int (alleen mana-classes), fort, motw, bless (elke blessing telt; klik = laatst
  gecaste, anders de eerste die je kent). Een kolom alleen als die class in de groep zit.
- Andermans auras: één scan per speler; te ver weg / offline / geheime id / in gevecht = vraagteken, nooit rood.
  Gaat dicht bij PLAYER_REGEN_DISABLED. Klikknoppen op UIParent, met de hand geplaatst, sluiten mee (lessen
  ConsumableReadyBoard). Eigen Shift+scroll → `tools/window_check.py` EXEMPT (reden: knoppen moeten mee).
- Id's: mh-research, `docs/forever/CONSUMABLES_FOREVER_2026-11-24.md` (wowf 71037). NIET meetbaar: Battle/Guardian-
  elixers (niet in de clientdata → één kolom), welke healthstone de server maakt, of de SoD-potions bestaan.
- Offline 43/43 (scratch `readyboard_test.lua`), NIET in het spel. Vertalingen de/fr/es/pt/ru: mh-writer (niet
  nagekeken door een moedertaalspreker). GEMETEN (SpellName wowf 71037): Well Fed 1248406 = Satt / Bien nourri / Bien
  alimentado / Bem Alimentado / Сытость; flask (17626) = Fläschchen / Flacon / Frasco / Frasco / Склянка (ru was
  "настой", gerepareerd). Uit de packs, niet gemeten: Healthstone, Warlock, potions, ready check, "Paladin-blessing". Teststappen: TESTLIJST "24 nov — FOREVER: groepsbord".
- Niet gebouwd (optie B, later): andermans tassen via addon-berichten. Divine Spirit/Shadow Protection niet op het bord.

## ▶▶ 24 nov (Bouwchat 24-11): twee wachter-fixes na de Forever-hotfix van 23 nov + handoff gesplitst

Opdracht Sparring 24-11, letterlijk: *"ga door met de kleine dingen. (1) Splits NEXT_SESSION.md eerst. (2) Fix Forever
Warrior toets 3 … (3) Zet de Priest-gids recht … GEEN tag of release."* Grondslag Rob 13 nov *"ga voortaan door"*.
- 🔧 **Warrior toets 3** (API-wachter [MOET GEFIKST] 24 nov): `ForeverBlock.lua` `TALENT_GATED` — Mortal Strike telt voor
  een toets alleen als node 105941 (tree 1117) gekocht is; onleesbaar talent = oude spellbook-antwoord. Alleen de toetsen;
  `ns.ForeverKnownSpell` (trainer, Do this now …) ongewijzigd. `/mh block why` toont de beslissing; ververst nu ook op
  TRAIT_CONFIG_UPDATED (pcall). Offline 9/9 (scratch `warrior_gate_test.lua`), NIET in het spel. Rest (AFGELEID): een al
  geplaatste "MH 3" van een Warrior met alleen Mortal Strike blijft staan (nieuwe body = niets → geen herschrijving).
- 🔧 **Priest-gids Chastise** (content-wachter 24 nov): regel "Healing in Shadowform" zonder Chastise, in 8 talen
  (`ForeverHowToPlay.lua:315` + 7 locales). Fear Ward-helft blijft (niet in de hotfix; AFGELEID dat hij klopt).
- Teststappen: TESTLIJST "24 nov — FOREVER: twee kleine fixes". Party-consumablevenster: nog NIET, sparring legt het voor.

## ▶▶ VOLGENDE BOUWCHAT (21 nov, avond): nieuwe Forever-reeks "leren van Polestar/FlowUp" — punt 4 en 2 GEBOUWD, 1 = B, 3 rust

✅ **RONDE 1 GETEST (22 nov via sparring, letterlijk: *"ronde 1 klopt"*):** herstart zonder fout, bekende recepten op één
character, Bags full (niets wat hij wil houden, grijs + Destroy), gevecht zonder "action blocked". Voorwaardelijk, dus niet
zeker: Equip, vrij talentpunt, pet. Niet los getest: per soort, bijna vol + schakelaar, grijs zonder waarde, link, Equip in
gevecht, andere characters. **OPEN: ronde 2** (ingrediënten, recept-pijl, dungeon-quests, XP per uur). Midnight-inlog: GEDAAN.
5.8.0 staat op CurseForge (22 nov). CURSEFORGE_DESCRIPTION.md geplakt door Rob (via sparring: *"aan mijn kant alles
gedaan"*); de live pagina zag niemand van ons.
💡 Midnight, LATER (Rob 22 nov: *"alle 3 maar niet voor nu, straks slapen"*): patchdag-kaartje 12.1.7, "eerste blik",
december-events in de weekplanning. Alleen in IDEEEN; niets gebouwd. PTR-map heeft MH van 16 okt: niet kopiëren zonder Robs ja.
◐ **RONDE 2, 23 nov:** dungeon-quests: Rob via sparring, letterlijk *"een test : een dungeon-quest , werkt"* (welke quest:
nog niet bekend). Recept-pijl en Copper Ore (ingrediënt) blijven open; XP per uur niet gemeld.
▶▶ **MORGEN (24 nov) EERST:** Robs wens, letterlijk via sparring: *"voor morgen, een consumable venster voor de party in forever
zoals in midnight"* + *"en de buffs natuurlijk"* (wie mist welke class-buff, wie kan hem geven; vóór het gevecht).
Rob zegt JA, nog niets gebouwd. Wat bedoeld is, wat anders is in Forever en wat bruikbaar is: IDEEEN,
"Forever: consumable-venster voor de party". Eerst een kort plan via sparring (welke consumables/buffs, alleen vóór het gevecht).
Nog open van 23 nov: layer-meting 1 + 2, de teller in het spel zien, testen van weetjes A en de QuestieDB-inleverregel.
▶ **ROBS DRIE OPDRACHTEN 23 nov** (via Sparring 23-11, letterlijk: *"Ja, 1, 2 en 3, maar juist ook 3. … We moeten ook zelf
kunnen swappen."*):
- 1 Patch 12.1.7-kaartje (Midnight): GEBOUWD in `NewChoices.lua` (kaart `patch1217`, alleen op een 12.1.7-client, één keer;
  knop naar het Timewalking-schema in de Codex; badges = valuta 1166, GEMETEN). Feitencontrole door Fable loopt; vertalingen
  daarna. Test kan pas op de PTR of op patchdag.
- 2 Weetjes A GEBOUWD (rapport `docs/forever/POLESTAR_NAKIJK_2026-11-22.md`): R12 needs 78307, wachtzinnen R11/R14, getallen
  weg R10/M21/W3, commentaar M1/S6; 7 talen. `tools/fcq_check.lua` faalde sinds 5a37dde (CreateFrame bij laden): stub
  erbij, nu 989101 gevallen, 0 fouten. Wacht op test (TESTLIJST).
- 🧪 Teller in het class-questkaartje GEBOUWD (Rob: *"… met hoeveel ik op dat moment heb?"*): `ObjProgress` → kaartje,
  Do this now, overzicht. Offline getest (4/6 → tekst; 6/6 → "lever in"). NIET in het spel gezien (Rob: quest al af,
  *"we gaan er van uit dat het werkt"*): eerstvolgende class-quest met teller.
- Layer-meting 23 nov (SV 16:37, GEMETEN): alleen een /reload + /mh layer in Durotar (2 spelers, 9 NPC's, 0 getagd); geen
  zonewissel, geen verplaatsing, geen uitnodiging (Rob: *"Nee, ik ben niet uitgenodigd of naar andere legen gegaan."*).
  Meting 1 + 2 OPEN → melding "je bent verplaatst" NIET bouwen. Login-regel ontbrak in het log (oorzaak onbekend).
- 3 Layer: Rob koos A + D (*"Ik ga uiteraard weer voor jullie advies."*). Metingen teruggebracht tot 3 (verplaatsing-signaal,
  "uitnodiging van andere layer", drukte tellen); eerst een stille meter + /mh layer, meldingen pas na meting 1.
  🧪 GEBOUWD: `Modules/ForeverLayer.lua` (nieuw, beide toc's) → `ns.db.layerProbe` (log van 40: SHARD_TRANSFER*,
  PARTY_INVITE_REQUEST 6e waarde, UnitPhaseReason per groepslid, zonewissel; geen namen) + `/mh layer [clear]` (drukte:
  speler-naamplaatjes, getagde NPC's). Offline getest. Spelers zien niets. D = nu alleen een zin; knop als Rob een
  wissel-addon installeert.
- 🔧 Folio 12.1.7 KLAARGEZET (Fable-bijvangst, onder Robs ja op "idee patch"): op een 12.1.7-client 7 quests
  (OmniumFolioData `unlockQuests1217` = 99509, 99508; GEMETEN QuestLineXQuest 6307 PTR 71087), "klaar" bij het echte aantal
  (was hard 5), tellers `_1217` "/7 steps", OMNIUM_WK_OBJ_6. 96444 heet live "Off-World Magic" en op 12.1.7 "Otherworldly
  Magic" (Wowhead live/PTR GEMETEN): alleen CODEX_FOLIO_BODY_1217 aangepast (9 regels). Runen-rijen en 99508: patchdag.
- 🔧 Patchkaartje: Fable-controle verwerkt (niets fout; 6 formuleringen eerlijker); patchdag-punten in draaiboek §4.
  Vertalingen loopt (mh-writer). Fable meldde ook: CODEX_FOLIO_BODY_1217 "Off-World Magic" vs Wowhead "Otherworldly
  Magic" (96444), en OmniumFolioData `unlockQuests` kent alleen de 5 oude quests: nog niet bekeken.
- 3 Layer swap: ONDERZOEK GEDAAN → `docs/forever/LAYER_SWAP_ONDERZOEK_2026-11-23.md`; layernummer onleesbaar (GEMETEN ook in
  Robs RFC-SV van 23 nov). Opties A-D bij sparring, advies A + D. Niets gebouwd.
✅ **WEAR B GOEDGEKEURD** (Rob via sparring, letterlijk: *"ORB is goedgekeurd. Alles doet hij wat hij moet doen."*; een
goedkeuring voor het geheel). Wat er gebouwd is (Rob via sparring, letterlijk: *"Ja, doe maar OR-B. Maar dan moet je wel opvallen dat
hij erin staat. En als er meerdere zijn in je tas, dan moet het ook blijven staan."*): `Modules/ForeverWear.lua` (nieuw
bestand = herstart). Per upgrade een groene regel met ↑ bovenaan Do this now (onder de talentregel) met klikbare [Wear it] /
[Not this one] (|H-links in de tekst, geen nieuw venster); knop "Wear it" in het overzicht. Oordeel = ns.ForeverGearTipText
(nu met 5e return: het vak). EquipItemByName(link, vak), alleen buiten gevecht; BoE-vraag van het spel blijft.
Schakelaar "Show upgrades in Do this now" (aan). `/mh wear why|reset`. Alleen Forever (daar zit het oordeel en Do this
now). Offline getest (nep-tas, 8 gevallen goed). Rob koos A (via sparring, letterlijk: *"Opvallen A."*): een upgrade
opent het venster vanzelf (`WEAR_TODO = true`), nooit in gevecht. Mijn keuze bij het kruisje: dicht blijft dicht tot er
een NIEUWE upgrade in je tas komt (`closedWear`). Vertalingen de/fr/es/pt/ru door mh-writer (niet nagekeken door een
moedertaalspreker; let op: "Mejora/Melhoria/Amélioration" staat in FBAG_NONE ook voor iets anders).
◐ **QUEST B getest 1-3** (Rob: *"1 tot en met 3 is goed."*); 4 ❌ op SM_GY (Vorrel's Revenge bleef "no place"). GEMETEN in
de QuestieDB-toc: Vorrel (3981) staat er alleen als (-1,-1) = "in een instance"; van 10 gaten zijn er 6 zo, 3 hebben een
echte plek (allemaal Alliance of level 55+). 🔧 Zo'n quest gaat nu naar "inside the dungeon" met "(QuestieDB)"
(`ns.ForeverQuestieNpcInside`): hertest ✅ (Rob: *"ennuh, een reload was genoeg, zoals zo vaak :)"*). 5 ✅ (*"Stap 5 uit
en aan, die werkte."*), 6 ✅ (*"Stap 6, gevecht gedaan en geen errors gekregen."*) → **QUEST B HELEMAAL GETEST.**
🧪 **"Of"-paren één regel GEBOUWD** (Rob: *"En glowing, ja,"*): paar = zelfde titel + gever + voorganger; GEMETEN 2 paren
(WC The Glowing Shard 3366/6981, BRD A Taste of Flame 4022/4024). Bijvangst gerepareerd: `taken` keek alleen naar de titel
en verborg zo de latere stappen van een keten met één naam (RFC Hidden Enemies, DM Defias; AFGELEID uit de code, offline
getest). Glowing GETEST ✅ (screenshot WC). Keten-fix niet te testen op Robs character (RFC 9 van 10 af).
🔧 "In Nightmares" (Rob: *"En nightmares, ja,"*): een voorganger telt als gedaan als zijn "of"-variant gedaan is
(`PrevDone`, code, niet in de gegenereerde data). Offline getest; in het spel pas te zien na The Glowing Shard. Schakelaar staat onder "On-screen buttons".
💡 Voorgesteld, wacht op ja: "The Glowing Shard" staat 2× in WC (3366 + 6981, twee echte quests; GEMETEN Wowhead
Forever) → altijd één regel tonen.
🧪 **QUEST B GEBOUWD** (Rob via sparring, letterlijk: *"Ik volg jullie advies weer. En het voelde niet
trager bij het inloggen, dus dat scheelt."* → laadtijd afgevinkt). MH's eigen data wint altijd; QuestieDB vult alleen
gaten, nooit omrekenen, pcall, niet in gevecht. (1) "Ready to turn in … (QuestieDB)" + knop Turn in in Do this now en het
overzicht (tip, opent het venster niet zelf); (2) dungeon-quests: ~40 rijen met een gever zonder plek krijgen er een
(QuestieDB); (3) LivePlace class-quests: laatste stap, nu 0 gaten (268/268 plekken hebben x,y; GEMETEN met grep).
Schakelaar "Use QuestieDB if you have it" (`mh_foreverQuestieDb`), standaard aan. `/mh questiedb why`. Vertalingen
de/fr/es/pt/ru door mh-writer (niet nagekeken door een moedertaalspreker), esMX "calabozo"; itIT geen (Forever-client
Engels). THIRD_PARTY: "Uses QuestieDB if you have it installed". Offline getest (nep-LibQuestieDB): 1 fout gevonden en
gerepareerd (schakelaar uit werkte niet: `and false or`). Teststappen: TESTLIJST 23 nov "stap B".
✅ **QUEST A GEMETEN, goed** (Rob: *"klaar"*): 0 fouten, ~1 ms per 150 vragen, 7,7 MB, 218/218 trainerplekken binnen
0,11-0,49 kaartpunt; Robs gemeten plekken 0,04 en 0,17; `here` 0,21. QuestieDB-plekken zijn al Forever: Era→Forever-
omrekening NOOIT gebruiken (maakte Stormwind 14,77). Laadtijd niet gemeten. ▶ B wacht op Robs ja via sparring.
🧪 **QUEST A: METING GEBOUWD** (Rob via Sparring 23-11, letterlijk: *"Ik volg jullie advies."* = eerst A meten,
B pas na zijn meting; is A slecht: melden, niet door naar B). `Modules/ForeverQuestieDB.lua`, `/mh questiedb [here]` →
`ns.db.questieDbProbe` (alleen tellingen, ms, KB en afstanden; geen QuestieDB-data). Offline getest met een nep-
LibQuestieDB (5 gevallen goed), NIET in het spel. Teststappen: TESTLIJST 23 nov. ⏸️ Questie-regels in ForeverClassQuests
(r.243/362/1005/1070): **LATEN tot het GPL-besluit**, niets aanraken.
🔎 **QUEST A ONDERZOCHT** (Rob via Sparring 23-11, letterlijk: *"quest a"*): QuestieDB alleen live lezen,
niets meeleveren; GPLv3 = later mogelijk, eerst toestemming mede-auteur AndyMM22 (Rob: *"gpl is niet defenitief van
tafel :)"*). Voorstel A-D in `docs/forever/QUESTIEDB_LIVE_2026-11-23.md` (advies A dan B),
wacht op Robs keuze. Gevonden: ForeverClassQuests noemt al Questie-plekken (r.243) en Questie-volgorde (r.362).
🧪 **PTR GEDAAN 23 nov** (Rob via Sparring 23-11, letterlijk: *"ja kopieer maar"*, daarna *"Alle 5 tests gaat goed. Ik heb
geen tailbound character, dus daar kan ik niet zoveel mee."*): `copy_to_ptr.bat` → `_ptr_` en `_xptr_` toc 5.8.0 (GEMETEN; was
4.7.7). `_ptr_` = 12.1.7.71087, `_xptr_` = 12.1.5.70340 (ouder dan retail 70961). Draaiboek §3 punt 1-5 ✅ ("Simple Keybinds" stond er NIET, Rob: *"nee, stond er niet simple keybinds"*;
op patchdag opnieuw kijken), punt 6
(Talebound laadt MH niet) OPEN: geen Talebound-character. Vervolg: §4 op patchdag (2 dec).

🔧 **SKILL UP-VENSTER GEREPAREERD (22 nov via sparring, letterlijk: *"venster ja"*), getest: *"Venster is goed"* (klik en scroll open):** stijl A (dicht),
"MH doesn't know which trainer/vendor yet", knop noemt het beroep. Ronde 2 uit zijn screenshots: XP-regel, Linen Cloth,
Light Leather, recepten in Skill up gezien; pijl, persoon en dungeon-quests niet. ▶ Robs *"Doe maar vensters A"*: alle 11
andere GEBOUWD (`S.SkinPanel` in ForeverStyle.lua). BagFull, Crates, Durability, HowToPlay GOEDGEKEURD (Rob 22 nov: *"Dus de
vensters zijn goed. Dat kan je goedkeuren."*; details open in TESTLIJST, prijs in Bags full: grijze regel goed, langere regel = controlepunt, niet repareren). De andere 7
(Chars, Dungeons, Macros, ProfTrainers, Trainer, Vendors, Weapons) openen niet meer: reserve achter het overzicht.
📜 **BRONNENLIJST GEBOUWD** (Rob 22 nov via sparring, letterlijk: *"Bronnenlijst, ja."*): `THIRD_PARTY.txt` (gaat mee in de zips)
+ de MIT-zin in README; LICENSE, code en data ongewijzigd. Licentie van ons werk blijft MIT. ⏸️ Alleen gemeld, wacht op Robs keuzes
via sparring: LibDBIcon (tegenstrijdig), LibDataBroker (geen licentie), plekken gelijk aan HandyNotes: Midnight (All Rights
Reserved). Niets daarvan zelf weghalen of vervangen.
🗑️ **PLATYNATOR-PAGINA WEG, vóór 5.8.0** (Rob 22 nov via sparring, letterlijk: *"En ja, platy die mag weg."*): pagina, profiel,
link, plaatjes, tool en verwijzingen; releasetekst + in-game regel 9 erbij. Details! blijft. fac9074, GETEST: *"midnight goed tekst goed"* (Rob 22 nov).

🔎 **POLESTAR-WEETJES NAGEKEKEN, niets gewijzigd** (Rob 22 nov via sparring: *"Misschien is dat wel slim, ouderwetjes
nakijken."*): 55 feiten = 36 bevestigd, 3 tegengesproken (rogue-keten 2x, Cantation), 1 betwist, 15 zonder andere bron.
`docs/forever/POLESTAR_NAKIJK_2026-11-22.md`. Repareren wacht op Robs keuze via sparring; 5.8.0 blijft zoals het staat.
Licentie: niets wijzigen tot sparring zijn keuze stuurt.

🚦 **5.8.0 STAAT OP CURSEFORGE (gewone release, 899a225).** Rob 22 nov avond via sparring, letterlijk: *"crates zwijgen en go voor 5.8.0"*.
Daarmee vervalt *"We doen nog geen release"* voor 5.8.0. Weetjes, libraries en HandyNotes gingen niet mee.
Run + CurseForge-bestanden: zie SITE_SEIN.
Fable-ronde GEDAAN: 1 echte fout gerepareerd (Scholomance 5803 = alleen Alliance, Horde = 5804; `QUEST_FIX` in de generator)
+ 4 kleine tekstverbeteringen. Waylaid Crates + mage Study-tip: Rob koos zwijgen. NIET door Fable:
vensters, spel, vertalingen, de keuze van de gidsen.
 Midnight + releasetekst GOEDGEKEURD op fac9074 (Rob: *"midnight goed tekst goed"*; ingrediënt-tooltip niet los afgevinkt).
 3 Forever-tests GEDAAN (Rob: *"de drie testjes zie screens"*): Way (alleen de chatregel gezien, aankomen open), rest off/on,
 prijs bij grijs.
▶ **NU: KAART B (Rob 22 nov via sparring, letterlijk: *"b"*):** level 1-briefjes voor alle classes/rassen + elk class-queststapje
als opvallend kaartje (ForeverCQWindow). GEBOUWD, kaartje GOEDGEKEURD op een Tauren hunter (Rob 22 nov: *"kaartje goed,
hebben we dit voor meerdere classes ?"*; andere classes, latere quests en knoppen open in TESTLIJST): 56 combinaties, 0 zonder briefje (Skyborne op level 2);
pas na de quest ervoor, tot en met level 5 (AFGELEID), nooit vóór een spell-keten. `docs/forever/CLASS_NOTES_2026-11-22.md`.
✅ **PLEKKEN B (Rob 22 nov via sparring, letterlijk: *"Plekken b"*), GEBOUWD, wacht op test:** 59 uit HandyNotes: Class Trainers
overgenomen plekken in ForeverClassQuests nu van Zygor (mediaan 0,11, grootste 1,01 kaartpunt: Beram 3032); wie die addon heeft
krijgt zijn plek live (`LivePlace`; Robs meting > gezien > /mh trainer here > HandyNotes > lijst; niets opgeslagen).
✅ **KLADJES A (Rob 22 nov via sparring, letterlijk: *"kladjes ja"*), gedaan:** die cijfers uit 11 docs en 2 commentaarregels
(71 paren, 131 vindplaatsen → 0; code-waarden en git-geschiedenis ongemoeid). Daarna nog 5 regels in 3 van die docs (HUNTER r.240,
PALADIN r.271 + 411, PRIEST r.340 + 502) → 0. ⚠️ Dat die 5 onder "kladjes ja" vallen is **uitleg van sparring, geen tweede ja van
Rob**; sparring meldde het hem en hij kan het intrekken met "die 5 laten" (dan die 5 terug zoals in 79343f6).
Buiten die 11 docs niets aanpassen. Andere HandyNotes-addons zijn niet nagelopen.

▶ **ROBS KEUZES 22 nov, rond het ontbijt (via Sparring 22-11), letterlijk:** *"overnemen, ja"* (1. Zygor kijken of
overnemen; 2. mag het vrije deel van Polestar uitgezocht worden) · *"knop weg, en polestar heeft ook iets om je volle tassen
onderweg leger te maken, check dat ook, tijd voor koffie en ontbijt dus ga door szo lang je kan en ik terug ben"* ·
*"Ik ben nog niet terug maar kan wel via telefoon reageren 😇 tas 1 2 3"*. Werklijst, in deze volgorde:
- [x] 1. Talents-knop weg, regel noemt zijn eigen toets. ◐ Ronde 1: gevecht goed; vrij punt en pet onzeker.
- [x] 2. **ZYGOR = OVERNEMEN: id's, coördinaten, volgorde. Geen teksten, notities of code.** "Zygor b" en de pauze vervallen.
      ✅ Dungeon-quests terug (wacht op test, herstart nodig; nieuw: y=100.38 bij Dark Iron Legacy = geen pijl).
      ✅ Reagentia 87 → 172 (+78 valt van monsters, +7 Skinning, 17 verkopers; één bron blijft stil). Wacht op test.
- [x] 3. Tassen, eigen code (Polestar = GPL, alleen het idee): eerst nameten of eten, drinken, munitie, class-reagentia als
      weggooien kunnen verschijnen; dan reservetas, hulp bij bijna vol, grijs zonder verkoopwaarde. (4) markeren koos hij niet.
      ✅ a GEMETEN + GEBOUWD (wacht op test): ze konden alle vier verschijnen (286 soorten eten/drinken, 14 munitie, class-
      reagentia), nu nooit meer, ook niet via de Yes van Destroy. b reservetas GEBOUWD (wacht op test, klik + gevecht).
      c (bijna vol + schakelaar) en d (grijs zonder waarde) GEBOUWD.
      ▶ Beantwoord: Rob via sparring, letterlijk *"alles advies"* = bewaren B (recepten en leerboeken erbij), GEBOUWD,
      wacht op test: ook gif, drankjes, elixers, flasks, verband, scrolls, sleutels en tassen.
- [x] 4. Recepten (gebouwd = 8): Zygor mag als bron. Craft Ladder alleen nakijken als tweede bron, geen waarden: dat is de uitleg van
      sparring (regel 7 nov), GEEN woord van Rob; hij kan het intrekken. Pijl nooit naar zomaar een trainer.
- [x] 5. Polestar UITGEZOCHT, niets overgenomen: `docs/forever/POLESTAR_DATA_2026-11-22.md`. recorded.json kan los (CC BY
      4.0); geeft 549 recepten een tweede bron. Rob koos A (*"alles advies"*): bouwen = 8 en 9.
- ▶ **Robs *"alles advies"* (22 nov via sparring, letterlijk), in deze volgorde:**
      [x] 7. Tassen bewaren B. + *"dieren ja"* (22 nov via sparring, letterlijk): de 63 leer-dingen ook, wacht op test.
      [x] 8. Recepten GEBOUWD (1102 antwoorden, 206 pijlen: 90 meer dan voorgelegd, gemeld; herstart, wacht op test).
          🔴 Bij de release: Polestar-naam in RELEASE_NOTES, CF-beschrijving en site (tekst in SITE_SEIN). Was: Classic A (553 + 116 pijlen, zonder Zygors losse receptenlijst, geen Zygor-skillgetallen,
          "Classic-data, nog niet in Forever gezien") samen met Polestar A (alleen recorded.json, trusted, tweede bron of
          controle; naam, bron, licentie, bewerking in het databestand + zichtbare plek noteren voor de release).
      [x] 9. Ingrediënten 172 → 194 (GEBOUWD, wacht op test; zelfde naamsvermelding bij de release). Was: aanvullen uit recorded.json, zelfde regels. Komt een getal anders uit dan voorgelegd: melden.
- [x] 6. "Bekende recepten" GEREPAREERD (Rob via sparring, letterlijk: *"Recepten ja"*): kopie, eigen venster vervangt,
      beroepen die hij niet heeft weg, linked overslaan, leeg wist niets. ◐ Getest op één character (lijst 40 → 25, GEMETEN); de andere nog.
      De kopie-regel van 21 nov ("A") staat nog. Geen tag of release.

📜 **Recepten met Zygor onderzocht + gebouwd (22 nov):** `docs/forever/RECEPTEN_2026-11-22.md`. Rob koos A
(*"alles advies"*): gebouwd = punt 8 hierboven, samen met Polestar A.

🐞 **"action blocked" MultiBarBottomRight:SetPointBase (sessie 335): aanleiding weggehaald; gevecht in ronde 1 zonder fout (pet onzeker).** Rob: *"knop
weg"*. `docs/forever/TALENTKNOP_TAINT_2026-11-22.md`. 🔴 MH opent het talentvenster NOOIT meer zelf. In v5.7.0 zit de knop
nog (overzicht). Dat dit de oorzaak bij Rob was blijft AFGELEID: komt de fout terug, dan verder zoeken.

🗳️ **Robs woorden 22 nov, later (via sparring, letterlijk: *"smart buff goed\nBoot Rust\nmeting gedaan"* en, bij een
screenshot van Do this now, *"kunnen we de talent point meer laten opvallen"* → *"talent b"*):**
- **Talent B GEBOUWD, regel getest:** talentregel bovenaan in goud met ster + witregel. Alleen het venster Do this now.
  De knop die erbij kwam is weg, zie bovenaan.
- **Meting:** Cooking 132 recepten, GetRecipeSourceText leeg bij alle 132, 2 runs (GEMETEN in de SV). Niet op die API
  bouwen; per recept eigen data nodig. "window closed" bij een open venster: oorzaak GEMETEN = CharacterForever toont
  een eigen receptenvenster, ProfessionsFrame komt dan nooit in beeld (zijn recipeLog). ⚠️ De regel "in het
  beroepenvenster" moet dus ook zonder dat frame werken. De meting kijkt nu naar TRADE_SKILL_SHOW/CLOSE.
- **Smart Buff goed** (mage; Priest/Druid niet getest). **Boot = laten rusten**, niet opnieuw vragen.
- **Robs antwoorden, letterlijk: *"talent goed / plek ja / Zygor b"*.** Talent B getest (niet: in gevecht).
- **d, reagentia GEBOUWD, wacht op test (herstart nodig):** `ForeverReagentSource(Data).lua`, nu 194 items, regel
  in de tooltip + Skill up (daar de pijlknop). Wat één bron heeft zwijgt.
  Nog van d: recepten. c en e: niet meer nodig, zie bovenaan.
- **Plek:** tooltip = hoofdplek + MH's Skill up-venster; Blizzards beroepenvenster alleen als extra.
- ⏹️ **(VERVALLEN, zie bovenaan: Zygor = overnemen)** **ZYGOR B (vervangt "alleen feiten" van 21 nov): niets meer overnemen uit Zygor, geen id's, plekken, volgorde of
  namen; alleen ermee nakijken.** Volgorde: b) dungeon-quests van main → d) reagentia (87, AllTheThings met MIT-tekst) +
  recepten zonder Zygor → c) ALLEEN een lijst van ouder Zygor-werk, niets wijzigen zonder apart ja → e) dungeon-quests
  herbouwen of met aantallen melden. Optie D (meelezen) niet gekozen: niet bouwen.
  Voor c: ForeverRepairData, ForeverClassQuests, en `docs/forever/DUNGEONS_2026-11-14.md` (Zygor-quest-id's, publiek).

🗳️ **Robs keuzes 22 nov (via Sparring 22-11, letterlijk: *"1 b"* en *"reparatie A, briefjes laten"*):**
- **Punt 1 = B:** onbekende recepten "Waar haal je dit" (beroepenvenster + tooltip; trainer = pijl, verkoop na onderzoek
  per recept) + reagentia in de tooltip (Trade Supplies met pijl / verzamelberoep / monsters zonder plek). Weet MH het
  niet: zwijgen. Meting `/mh skillup source` → `ns.db.recipeSourceProbe`: gedaan, uitslag hierboven.
  Reagentia hangt niet van die meting af, de licentiekeuze is gemaakt (Zygor B, hierboven): Zygors toc zegt `X-License: GPL`
  (GEMETEN 22 nov). Onderzoek + keuze: `docs/forever/REAGENTIA_2026-11-22.md`. Die keuze raakt ook de dungeon-quests
  van 21 nov: vóór de volgende release beslist hebben.
- **/mh rest-reparatie = A:** mee met de volgende gewone release (geen 5.7.1, geen go voor een release).
- **Notion-briefjes 12 nov:** blijven staan, niet opnieuw vragen. De ideeën: maandag via sparring.

⛴️ **Punt 3 boot/zeppelin ONDERZOCHT (22 nov): nu niet eerlijk te meten, niets gebouwd.**
`docs/forever/BOOT_ZEPPELIN_2026-11-22.md`. Rondetijd is af te leiden; waar het schip NU is niet (geen API gevonden).
Misschien aftellen na één waargenomen aankomst: hangt aan een meting van 12 minuten in het spel (macro in dat bestand).
✅ Rob 22 nov via sparring: *"Boot Rust"* = laten rusten. Niets bouwen, niet opnieuw vragen.

⏱️ **Punt 4 XP per uur GEBOUWD (Bouwchat 21-11 (2)), nagekeken en gerepareerd (Bouwchat 22-11, 22 nov ochtend)** — wacht
op Robs test (TESTLIJST "21 nov (nacht)"). De pc ging 21 nov 23:22 uit vóór lint en commit; 22 nov nagelopen.
- `Modules/ForeverXPRate.lua`: regel onder de XP-balk + tooltip, schakelaar FXPRATE_SW, `/mh rest xp`.
- Bij het nakijken gevonden met een offline test (nep-client; 6 van 15 gevallen faalden, nu 15 van 15 goed):
  (a) het venster werd langer dan een uur na stilstand (3 uur stil + 30 min XP gaf 2857 i.p.v. 9999 per uur),
  (b) level-up: liep UnitLevel of UnitXPMax een update achter, dan telde hij een balk te weinig of te veel,
  (c) max 0 bij inloggen telde de hele balk als winst. NIET gemeten: de echte volgorde van die waarden in Forever.
- Vertalingen GEMETEN: 9 van 9 keys laden en formatteren in de/fr/es/pt/ru. ⚠️ `locale_probe.lua` zegt "still English"
  voor deze keys: hij laadt de Forever-packs niet.

🐞 **`/mh rest off|on|test|mana|health` was kapot sinds edb0f37 (20 nov), zit in v5.7.0 (GEMETEN: tag --contains)** —
ForeverRestXP.lua definieerde `ns.ForeverRestSlash` opnieuw en laadt na ForeverWarnings.lua. Nu `ns.ForeverRestXPSlash`;
kale `/mh rest` print beide diagnoses. GEREPAREERD op main, NIET in het spel gezien; of er een release komt beslist Rob.
In de Camelot-toc is dit de enige dubbele `function ns.X` (GEMETEN 22 nov, nu 0).

☀️ **Ochtendronde 22 nov gedaan (Bouwchat 22-11).** GEMETEN: CurseForge 0 wachtend, GitHub 0 open, site-mail 0 (3 dagen),
BOUW_VRAAG 0 open, wachters 0 MOET GEFIKST, HandyNotes 173 zonder zone-wijziging, Zygor: ingangen Drowned City/Krol'dok
kloppen al in MH, dungeon-quests blijft 519. Notion-inbak: 4 regels "Nieuw" van 12 nov. SITE_SEIN 5.7.0: 14 blokken op
"ja" (staan in de releasetekst), Waylaid Crates blijft "nee". Event-snapshot ververst (live 70961 / ptr 71087 / forever
71037). Open uit de ronde:
- [ ] Verlopen tekst "Fabled, only until the week of 27 October" (site-chat 22 nov): DELVE_TIP_LABYRINTH_BOSS +
      CODEX_LABYRINTH_BODY, met alle taalpacks en esMX; dan check_drift.
- [ ] Nachtcontrole C2 blinde vlek 24 -> 290 -> 774: uitzoeken. Draaiboek 12.1.7 zegt nog "testdata" (release 1/2 dec).
- [ ] Ideeënbus: 2 voorstellen van 15 nov + wat vandaag 08:06 komt, maandag 23 nov aan Rob voorleggen.
- [ ] Commentaar ForeverCharKey.lua zegt "Forever toc only", staat in beide tocs (gedrag goed).

✂️ **24 nov GESPLITST (Bouwchat 24-11, opdracht Sparring 24-11):** 1776 → 1304 regels + index; de zeven secties van 18 nov
staan nu bovenaan `NEXT_SESSION_ARCHIVE.md`. Hun koppen lezen niet als open, dus de open stukjes staan hier (GEMETEN met grep
vóór het knippen): `/mh disenchant` (/dump voor optie B open); optie A wapens (2 bewust open: Franse duizendtal-spatie,
> 1000 DPS); bazengids 2a/2b (Robs test; bazennamen in vertaalde tips nalopen, ~25 in fr/de/es/ru; stap 3 raids = 9 dec);
Bouwchat 18-11 (zoekbalk Midnight-check open; esES SpellName 17039 "Maestro invocador" nalopen).

🗺️ **Punt 2 dungeon-quests: 22 nov VAN MAIN gehaald** (Rob 22 nov via sparring, letterlijk: *"Zygor b"*). Gebouwd 21 nov uit Zygor;
nooit uitgebracht. Weg: data, module, knop, toc-regels, FDQ_-teksten, `build_dungeon_quests`. Geschiedenis niet herschreven.
Herbouw uit andere bronnen = stap e; het venster zonder data staat in git (`c4223dc:Modules/ForeverDungeonQuests.lua`).
Nooit de data, `inside` of volgorde uit die commit terugzetten.

Bouwchat 21-11 stopt hier (context vol). Alles hieronder is gepusht t/m 738de2c; `git status` was schoon. 5.7.0 staat op
CurseForge (9734057 / 9734079) en op de site.
Rob via sparring, letterlijk: *"ik blijf bij Zygor, Polestar probeer ik later. maar kunnen wij er iets van leren /
verbeteren"* → op sparrings 5 voorstellen: *"2 en 1, doe maar, daarna 3 en 4 :)"*. ⚠️ Polestar = GPLv3: alleen het IDEE,
geen code/tekst/data. FlowUp-routes = ARR: niets overnemen. Per punt: eerst kort uitzoeken → echte keuze = opties naar
sparring; anders bouwen. Lint, 7 talen, IDEEEN (Robs zin staat er), TESTLIJST, push mag, geen tag. Meld per punt kort.
1. **(punt 2) Dungeon-quests** — per dungeon in de dungeon-gids/Dungeons-lijst "haal eerst deze quests op": quest,
   level, questgever + plek met Show the way, en of je hem al hebt/gedaan hebt. GEMETEN 21 nov: ForeverDungeons.lua en
   ForeverDungeonGuide.lua hebben GEEN dungeon-quests (grep "quest": alleen UI-texturen); ForeverDungeonGuideData.lua noemt
   quests alleen in baas-opmerkingen (`-- src:`-regels, bv. regel 960 Sergeant Bly). Dus nieuwe data: DB2 QuestV2 /
   Wowhead Forever-tooltips (`run gamedata`) / Zygor lokaal / HandyNotes; coördinatenregel uit het geheugen.
2. **(punt 1) ✅ Rob 22 nov: *"1 b"*, zie boven. "Waar haal ik dit vandaan?"** bij item/recept/mount/pet (zoekbalk + tooltip): verkoper, drop, quest, beroep,
   trainer, met Show the way. Midnight heeft het voor recepten (`CraftShoppingList.lua`, CRAFTSHOP_UNLEARNED,
   CHANGELOG_474_3) — hergebruik waar het kan. Klein beginnen (recepten + reagents + mounts?) en zeggen wat de data toelaat.
3. **(punt 3) Boot/zeppelin-wachttijd** "komt over ~N s": eerst uitzoeken of het meetbaar is (transport-objecten, vaste
   cyclustijd per route); anders eerlijk "niet te meten". ✅ ONDERZOCHT 22 nov: niet te meten zonder meting in het spel,
   zie boven.
4. **(punt 4) XP per uur + tijd tot volgend level** (overzicht, met een schakelaar): ✅ GEBOUWD, zie boven.

## ▶▶ VOLGENDE BOUWCHAT: Forever-overzicht "D" — stap 1 en 3 gebouwd; stap 2 wacht op Robs screenshots (20 nov, avond)

🛡️ **Level als X, tank als Y + respec/Dual Spec + Wolfsbane + tankstats (21 nov)** — Rob via sparring, GO letterlijk:
*"Ja, voeg dat maar toe en laat het maar uitvoeren ook. Ik vind dat wel iets belangrijks eigenlijk."* Bronnen + G/A per
regel: `docs/forever/TANK_LEVELEN_2026-11-21.md`. Gebouwd: `PLANS` in ForeverHowToPlay.lua (Paladin/Warrior/Druid, altijd
open bovenaan How you play, ook op de overzichtspagina als kind "role"); COMMON-sectie 4 "Talents: reset and Dual Spec"
(COMMON valt nu PER SECTIE terug op Engels, zodat een nieuwe sectie ook zonder vertaling verschijnt). Do this now:
`FDONOW_WOLFSBANE_FMT` (Paladin, Wolfsbane-keten niet klaar, spell 202 niet bekend; tip 18-19, to-do vanaf 20; knop =
Find op Two-Handed Swords + pijl naar de dichtste wapenmeester) en `FDONOW_DUALSPEC` (tip vanaf 40 zolang 63644 niet
bekend; knop naar de class-trainer). `/mh donow check` print 202 en 63644. Tankstats Paladin: Stamina > Intellect (was
> Strength). GEMETEN: wissel 63644/63645 = 5 s (SpellCastTimes 6). NIET gemeten: of IsPlayerSpell(63644) na het kopen
true geeft; of de druid-klassequest Growl ook geeft. Vertalingen KLAAR (mh-writer, 7 talen + esMX, niet door een
moedertaalspreker nagekeken): ForeverHowToPlay_<code> (PLANS + COMMON[4]) en ForeverClassQuests_<code> (2 FDONOW-keys).
Daarbij gerepareerd: esES Wolfsbane = "Aterralobos" (Wowhead Forever); Archibald heet in ptBR "Arquibaldo", ruRU
"Арчибальд" (in de Wolfsbane-regel; de Find-rij van de wapenmeester toont nog overal "Archibald"). ⚠️ esES SpellName
202 zegt "Mazas de dos manos" (Blizzard-fout?); de teksten gebruiken "Espadas de dos manos" (SkillLine 55, esMX).

🐞 **`/mh arrow` "Zygor geladen" in Forever (21 nov)** — bijvangst mh-research via sparring: NativeArrow.lua vroeg alleen
"ZygorGuidesViewer"; in Forever heet hij "ZygorGuidesViewerForever" (GEMETEN: de .toc in `_forever_\Interface\AddOns`).
Nu beide namen. Alleen de diagnoseregel; MH wijkt niet voor Zygor. NIET in het spel gezien.

🎯 **Volgend talentpunt: ALLE classes, per class (21 nov, bezig)** — Rob via sparring, letterlijk: *"het puntensysteem,
waar ga ik welk punt in stoppen, moet natuurlijk wel uitgebreid worden. Ik zit nu bijvoorbeeld op mijn shamaan, die is
level 11. Ik mag 2 punten indelen ... Ga ermee aan de slag"*. Fable pas aan het eind, één controleronde over alle
volgordes (Rob: *"misschien dat we die gewoon aan het einde even overheen gooien"*); eerst melden bij sparring.
- ✅ **Shaman** (tree 1082): Enhancement = Mobalytics/Tiqqle 13 nov (22 stappen, 6 van 7 gidsen Enhancement);
  Restoration = stillsixty 2 nov (18 stappen, Riptide stap 13). Ids GEMETEN (mh-research), 3 nagemeten.
  ⚠️ Stormstrike: gidsen op 25, client-SpellLevels zegt 40 (niet verlaagd, i.t.t. Mana Tide 40→1). Nu: een stap die de
  client weigert (`canPurchaseRank == false`, AFGELEID dat Forever dat veld vult) wordt overgeslagen, de volgende komt;
  `/mh talent` zegt het. NIET gemeten wat het spel doet.
- Standaardrichting zonder keuze = de levelboom uit How you play voor elke class (`DEFAULT`).
- ✅ **Warrior** (tree 1117): Protection = timesaver.gg/Maxroll 4 nov (20 stappen; meeste gidsen: Prot levelt het
  snelst, SixtySim: Arms); Arms = Mobalytics/Ahlaundoh 19 nov (24 stappen, Mortal Strike op 40).
- ✅ **Druid** (tree 1089): Feral (kat) = Mobalytics/yumytv 14 nov (21 stappen, Shifting Power op 40); Restoration =
  timesaver.gg/Maxroll 3 nov (19 stappen, Wild Growth stap 12). Geen talent vóór zijn SpellLevels (GEMETEN door
  mh-research). ⚠️ Open: wat Talented (Legacy) met SpellLevels doet (rij 7 op 35 i.p.v. 40?) — niet gemeten.
- ✅ **Hunter** (tree 1091): Beast Mastery = Mobalytics/Feor 18 nov (21 stappen, Bestial Wrath op 40). Geen tweede
  volgorde (geen duidelijk groepsadvies). ⚠️ How you play zegt "Every guide we read picks Beast Mastery": mh-research
  vindt dat te sterk (Wowhead: alle drie doen goed mee). GEREPAREERD (sparring: feitencorrectie): "Most guides pick
  Beast Mastery … Wowhead adds that all three trees work.", in het Engels + 7 talen (8/8 GEMETEN met grep, oude zin 0×).
- ✅ **Rogue** (tree 1111): Combat = Mobalytics/Djexde 12 nov (25 stappen, Adrenaline Rush op 42). Geen tweede volgorde.
- ✅ **Priest** (tree 1114): Shadow = MMOJUGG 13 nov (21 stappen, Shadowform op 42); Holy = warcraftmaps 17 nov
  (21 stappen, Prayer of Mending stap 14; 4:2 Holy boven Disc voor dungeons). ⚠️ Vampiric Embrace op 27, SpellLevels 30
  (overslaan-logica vangt het op als het spel weigert).
- ✅ **Mage** (tree 1112): Frost = GrindClassic 20 nov (24 stappen, Ice Barrier op 40). Geen tweede (geen eensgezind
  groepsadvies).
- ✅ **Warlock** (tree 1116): Affliction = Mobalytics/Crix 21 nov (20 stappen, Wrack op 40); Destruction (alleen bij die
  richting) = wofwforever 9 nov (19 stappen, Incinerate stap 13).
- ✅ **Fable-controle (21 nov, sparring: "Ja, de Fable-ronde mag nu")**: alle 15 volgordes, 314 stappen, 765 punten —
  ids, rangen, banden, volgorde t.o.v. de bronpagina (gelezen), rijgrenzen en voorgangers: allemaal OK (GEMETEN, twee
  checkers + negatieve controles). Niets aan ORDERS veranderd. Open blijft (data beslist het niet): Stormstrike
  SpellLevels 40 (onveranderd uit Classic Era; meerdere gidsen na launch: 25) en Vampiric Embrace 30 (in Forever
  verhoogd van 1; gidsen 25-27). AFGELEID: beide waarschijnlijk kiesbaar. Risico zit in de terugval: die werkt alleen als
  de client `canPurchaseRank = false` meldt. Daarom toont `/mh talent` nu per stap "can buy: …" — Robs test beslist het.

🚀 **RELEASE 5.7.0 (21 nov)** — Rob via sparring, letterlijk: *"reload gedaan, tekst staat goed, go voor 5.7.0"*. Geen
beta. Beide .toc 5.7.0, CHANGELOG_570_1-13, RELEASE_NOTES = CURSEFORGE_5.7.0 (diff leeg), CHANGELOG.md, SITE_SEIN (alle
regels sinds 5.6.0 → getagd). Waylaid Crates + mage Study-tip zitten in de zip, NIET in de tekst. Run + CF-bestanden:
zie SITE_SEIN zodra gemeten.

🐞 **Dungeons-lijst: routetekst liep onder Way/Bosses (21 nov)** — Rob, screenshot: *"Er loopt tekst door elkaar heen."*
GEMETEN in de code: `DungeonRow` route begint 70 px in (chip 2+58, gat 10) maar had breedte rowW-80 → eindigde 70 px te ver
rechts, onder de knoppenkolom (70 breed, 2 van rechts). Nu rowW-150 (vaste breedte, want de rijhoogte wordt direct na
SetText gemeten). Nagelopen, zelfde opbouw: FindRow (route onder de knop, die één rij hoog is: geen overlap), macro-rijen
(rowW-112 bij knoppen 96: vrij). NIET in het spel gezien.

✨ **Smart Buff-macro voor Mage, Priest, Druid (21 nov)** — Rob via sparring: *"Kunnen wij ook een soort mouse-over macro
maken voor de andere buffs, voor alle andere classes."* GO letterlijk: *"Ja, wou het maar."* `Modules/ForeverSmartBuff.lua`:
macro "MH Smart Buff" = `#showtooltip` + `/cast [@mouseover,help,nodead][@target,help,nodead] <clientnaam>` + een
/run-hintregel als niemand vriendelijk onder de muis/doelwit is (valt weg als de macro > 255 tekens wordt). EditMacro
buiten combat (PLAYER_ENTERING_WORLD, PLAYER_REGEN_ENABLED, SPELLS_CHANGED). Buffs GEMETEN in ns.FOREVER_SPELL_IDS:
Arcane Intellect, Power Word: Fortitude, Mark of the Wild. Warlock/Shaman (alleen water-spells), Warrior/Rogue/Hunter:
geen macro, de schakelaar zegt het. Paladin = Smart Bless. Overlap: ForeverBlock MO_HELP (mouseover-stand van het
toetsenblok) heeft deze buffs al op zijn eigen toetsen. Schakelaar FSBUFF_SW (standaard uit), `/mh smartbuff [on|off]`.
Offline test GESLAAGD. NIET gemeten: één spell na twee voorwaarden in Forever (AFGELEID, zelfde syntax).
🔧 Daarbij: Wolfsbane/Dual Spec-check gebruikt nu C_SpellBook.IsSpellKnown eerst (IsPlayerSpell is in Forever alleen
een deprecation-fallback, ForeverBlock.lua KnownId); `/mh donow check` toont alle drie.

🎯 **Volgend talentpunt in Do this now (21 nov, GEBOUWD voor Paladin)** — Rob via sparring, letterlijk: *"Ja, doe dat maar"* op
"'Do this now' zegt bij elk nieuw level welk talent je nu moet kiezen". `Modules/ForeverTalentNext.lua`: alleen bij een
vrij punt (GetTreeCurrencyInfo tree 1100, valuta 3820), richting → volgorde, eerste stap die nog niet af is
(GetNodeInfo.ranksPurchased). Schakelaar FTALENT_SW, `/mh talent`, knop opent het talentvenster (AFGELEID). Offline test
GESLAAGD (nepvolgorde + controle op de echte data). ORDERS Paladin: Ret (band 3) = guided.news 21 nov, 19 stappen tot 60;
Prot (band 2) = stillsixty.com 17 nov, 20 stappen (Shieldsworn = stap 14, op 40). Node/spell-ids GEMETEN door
mh-research in DB2 71037, 3 entries→nodes door de bouwchat nagemeten. Geen richting = Ret + zin "(You chose no
direction …)". Holy = geen volgorde → stil. Dual Spec-tip zegt bij Paladin: tweede set Protection + richting
Protection kiezen. 🔜 Andere classes: zelfde vorm, per class mh-research (nog NIET gedaan). NIET gemeten in het spel:
of GetTreeCurrencyInfo(cfg, 1100) de vrije punten geeft (anders stil; `/mh talent` zegt waarom).

🔎 **Zoeken springt naar de schakelaar + "for WoW Forever" (21 nov)** — Rob via sparring, letterlijk: *"Wat ik dan krijg
is het lange overzicht. Dan moet ik eerst gaan scrollen naar beneden en kijken waar staat hij ook weer. ... Dat moet
volgens mij beter kunnen."* en *"waarom staat er niet onder Forever versie ... Iets dat duidelijk maakt dat het echt voor
Forever is."* Gebouwd in `ForeverOverview.lua`: een zoektreffer op een Quiet helpers-schakelaar → `FocusQuietRow(i)`:
opent de pagina, scrollt de regel naar een derde van boven en laat hem 2 s goud oplichten (vlak + streep links,
`FlashQuietRow`). Elke rij onthoudt `_y/_h` in FillQuietPage. Extra zoekwoorden `QUIET_WORDS` (spar/ore/herb/glow/node/
mining/herbalism) voor FLS_SW, FNODE_ICON_SW, FNODE_GLOW_SW. Ondertitel `FOV_SUBTITLE` onder "MIDNIGHT HELPER" (beide
layouts, zelfde titelregel), 7 talen. Andere zoektreffers (tabs, Find, Tools) springen nog alleen naar de pagina.
NIET gemeten in het spel: of de ondertitel in de oude layout vrij van de tabs blijft (11 px tussen -37 en -50), en of het
scrollen meteen raak is (tweede poging na 0,05 s als het scrollbereik nog 0 is).

✅ **Charkey GESLAAGD op twee Ima's (Rob in het spel, 21 nov)** — Ima 2 = Player-6944-0120ED18 (Ima 1 = …0118CB4F), eigen
kopieën, "copies so far 9". Joey en KeyBlock nog niet getest.

⛏️ **Gloed alleen bij wat je kunt verzamelen (21 nov)** — Rob (Paladin, Mining + Blacksmithing, geen Herbalism), letterlijk:
*"eigenlijk zouden we die dingen alleen maar moeten kunnen zien op het moment dat we het ook echt hebben."* GEMETEN in zijn
screenshot: rode ster bij geen Herbalism (optie C werkte). Nu: geen beroep → HideGlow, `/mh sparkle` "skipped: no
Herbalism/Mining"; beroep maar skill te laag → rood blijft (Rob bevestigde, letterlijk: *"Van heb je beroep wel mijn skill
te laag, dan blijft hij rood. En zo hoort het ook."*).
FNODE_GLOW_SW_DESC 7 talen + esMX. ⚠️ Het game-icoon (schakelaar A, CVar SoftTargetIconGameObject) is één aan/uit voor
ALLE objecten; per soort beperken kan met die CVar niet (AFGELEID uit de CVar-lijst; geen per-type CVar gezien in de
meting van 20 nov). 🔧 Even (0c6aea4) liet B het icoon op 0 als A uit stond. Rob MAT het dezelfde dag in het spel
(Paladin, Mining, ertsader, 2 screenshots): A uit + B aan = GEEN game-icoon én GEEN MH-ster; A aan + B aan = beide.
GEMETEN dus: de gloed heeft SoftTargetIconGameObject nodig. Teruggedraaid: B zet het icoon weer zelf aan, uitleg weer
"so the icon comes along" (7 talen + esMX). Een CVar die alleen het icoon verbergt: niet gevonden. Kandidaat (AFGELEID, uit
MFNameplates SoftIcon.lua, geen bewijs): `SoftTargetNameplateSize` = grootte van het soft-target-icoon; 0 zou het icoon
kunnen verbergen, maar misschien ook het naamplaatje waar de gloed op zit. Alleen bouwen na een meting door Rob. Offline
GEMETEN (nodeswitch_test.lua). Overzicht D afgevinkt (Rob: *"dat zag er goed uit"*).

📚 **Study: waar de bibliotheek is GEBOUWD (21 nov)** — Rob: *"Ja, graag"*. mh-research (GEMETEN): Study 1302508 vraagt spell
focus 2309 "Library" (geen gebied, geen factie), 1 Light Feather 17056, 1 uur (SpellCooldowns 3600000). De focus-objecten staan
op de server, niet in DB2. Plekken met spelersmeldingen: Stormwind Mage Tower bij Garion Wendell 211033 (1453 48.9,86.5) en
Undercity Magic Quarter bij Owen Thadd 211022 (1458 73.6,33.0); spawns Wowhead Forever, namen per taal GEMETEN (pt Adélio
Tadeu, ru …). Weggelaten (één bron): Royal Library, Dalaran. Light Feather: GEEN verkoper gevonden (2 gidsen; Wowhead
"Sold by" niet leesbaar) → tekst "drops from birds and harpies". Gebouwd: ForeverProfGuide `FOREVER_LIBRARY_SPOTS`,
`ForeverStudyLibraryLine/FeatherLine`, Comprehension-kaartje +2 regels, Study-spelltooltip (TooltipDataProcessor Spell),
Find-categorie `library` (alleen mages; FindCats filtert op `mage`), Do this now-tip "Study is ready …" als Study gekend is
en geen cooldown heeft. Spellnaam per taal GEMETEN (SpellName DB2: de Studieren, fr Étudier, es/esMX Estudiar, pt Estudar, it
Study, ru Изучение; controle Fireball 133). NIET in het spel gezien; of Study echt werkt bij die bibliothecaris = Robs test.
✅ Ook vandaag: Renown-regel door Rob goedgekeurd (*"Zo is het goed."*); niet-vrijgespeelde tracks nu uit de tooltip.

🏅 **O14 Renown-regel GEREPAREERD (21 nov)** — GEMETEN in Robs Midnight-SV (`renownProbe`, 13:58): GetMajorFactionIDs() zonder
argument = 30 facties van alle uitbreidingen; met LE_EXPANSION_LEVEL_CURRENT (11 = LE_EXPANSION_MIDNIGHT) precies 11:
2696,2699,2704,2710,2742,2764,2772,2792,2796,2808,2836. Na /reload alle velden echt (Amani/Singularity/Hara'ti/Silvermoon 20 max,
Labyrinth 9 max, Preyhunter's Journey 1, Prey 5, Zul'jarra 15 …; 2742 "Delves: Season 1" isUnlocked false). Eerste keer = data
nog niet geladen (AFGELEID uit eerste screenshot vs. meting). Rob: *"Ik vind het geen gezicht."* Nu: alleen de huidige
uitbreiding, dubbele naam eruit, één regel "N of M at max · lowest: X n — point here for all", tooltip gesorteerd (niet-max met
voortgang, dan max, dan locked, dan onleesbaar). Alles "locked" en niets leesbaar = "the game is still loading this" (niet
"not unlocked"); MAJOR_FACTION_RENOWN_LEVEL_CHANGED / MAJOR_FACTION_UNLOCKED / UPDATE_FACTION / PLAYER_ENTERING_WORLD tekenen
de regel 2 s later opnieuw als hij zichtbaar is. 3 nieuwe teksten, 7 talen. NIET in het spel gezien.

🐞 **Tas vol: "Repair & sell"-regel liep door rij 3 GEREPAREERD (21 nov)** — Robs screenshot (Undercity). Oorzaak GEMETEN in de
code: `repInfo` had als tweede anker `LEFT` van het venster = verticaal midden (y −180, rij 3). Nu `LEFT` aan `BOTTOMLEFT` +51
(hoogte van de knop). Hoogte nagerekend (AFGELEID): rijen tot −198, loot + knop tot ~−266, Repair −298..−320, past in 360. ⚠️ Lint [25]: de
registratie (RegisterMidnightDialogPopup) staat nu precies 120 regels na CreateFrame (window_check LOOKAHEAD = 120); één
regel meer in Build() = HARD. Volgende keer: registratie hoger zetten.
Ook GEMETEN goed door Rob vandaag: Comprehend-melding weg, Tas vol Destroy, Midnight login/reload. Renown O14 ❌ → meting
`/mh renown` (renownProbe, ruwe velden per factie + uitbreiding) staat klaar, wacht op Rob.

🐞 **Ranks: "Comprehend Scroll Rank 1; you know Rank 5" GEREPAREERD (21 nov)** — Rob (Troll Frost Mage lvl 10): *"Ik klik hem
aan … Maar hij blijft wel staan. Hoort dat zo?"* GEMETEN (Forever DB2 Spell.NameSubtext_lang): de 5 Comprehend Scroll-ids zijn
geen rangen (1296017 "Comprehension", instant; 4 andere zonder ondertitel, 5 s cast). Zelfde check: 19 van 279 spells met
meerdere ids hebben ids die geen "Rank N" zijn (Polymorph Turtle/Pig, Swipe Cat, talent-kopieën van Execute/Flash of Light/
Holy Light, Cure Poison, Tame Beast …), 52 ids in totaal. `tools/forever_rank_filter.py` → `Modules/ForeverRanksData.lua`
(`ns.FOREVER_NOT_A_RANK`, controle 133 blijft / 1310030 eruit); ForeverRanks.lua Info() telt alleen echte rangen (spell met
< 2 rangen valt weg). ForeverSpellIds zelf ongewijzigd (KeyBlock gebruikt hem om de castbare rang te vinden). Do this now
ververst al bij ACTIONBAR_SLOT_CHANGED (GEMETEN in de code); de melding bleef staan omdat de "nieuwe rang" geen rang was
(AFGELEID: de game laat op de knop de basis-spell zien). NIET in het spel gezien.

🚦 **Afspraak 21 nov: Rob is ziek en test weinig. Bouwen mag gewoon op zijn vragen** (Rob, letterlijk via sparring: *"Nou,
bouwen mogen we natuurlijk altijd wel doen."* — dat vervangt een eerdere "bouwstop" van de sparring).
Minimale test vóór 5.7.0 staat bovenaan TESTLIJST (4 punten). Release-concept bijgewerkt met zeppelin-platforms en Skill
up-tooltips/make-first (CHANGELOG_570_10). Release/tag blijft Robs letterlijke go.

🧭 **Zuid/noord (21 nov, later)** — GEMETEN door Rob: hij nam het ZUIDELIJKE platform van de Orgrimmar-toren en kwam in Tirisfal
aan. MASTERS H1a dir SOUTH, H2a dir NORTH (de andere van twee; de kaart klopt: Frezza y 13,5 > Snurk 12,8) →
FTRAVEL_PLATFORM_SOUTH/NORTH_FMT "(the south platform, with Frezza)", 7 talen. Andere torens: geen richting (niet gemeten).
Skill up: Rob zag kleur + "make first" (afgevinkt); "needs …" nu op een eigen, ingesprongen regel (FSKILL_MAKE_NEEDS_FMT).

🛩️ **Zeppelin-platform ondubbelzinnig GEBOUWD (21 nov)** — Rob bij de toren buiten Orgrimmar: *"Maar er zijn er twee hier. Hoe
weet ik nu precies welke ik moet hebben? Kunnen we het nauwkeuriger maken?"* ForeverTravel.lua `MASTERS` (Wowhead Forever
NPC-tooltips, GEMETEN; HandyNotes en Zygor hebben ze niet, grep met controle): H1a Frezza 9564 (50.8,13.5 → Tirisfal), H2a
Snurk Bucksquick 12136 (50.6,12.8 → STV), H1b Zapetta 9566 (Tirisfal 60.8,58.8 → Orgrimmar), X1b Hin Denburg 3150 (61.8,59.0
→ Grom'gol), H2b Nez'raz 3149 (STV 31.4,29.8 → Orgrimmar), X1a Squibby Overspeck 12137 (31.5,29.4 → Undercity); elk staat naast
de DB2-stop van zijn eigen lijn. Namen per client GEMETEN (es Esnur Ciervoveloz / Petardo Porsiacaso, esMX Snurk Oroveloz, pt
Odete Cobrafrete / Squibby Talotado, ru …). Routestap: punt = de meester, zin + FTRAVEL_PLATFORM_FMT "(the platform with X)"
(7 talen); Find → Travel idem, pijl stopt op 8 yd. "You are at": straal per stop = de helft van de afstand tot de
dichtstbijzijnde andere stop op die kaart, max 2 (was overal 2): Orgrimmar 0,36, Grom'gol 0,21, Auberdine 1,49, Menethil 2
(offline GEMETEN, travel_test.lua). Boten (Auberdine 3 steigers, Menethil 2) hebben geen meester: geen naam, wel de kleinere
straal. Routeplanner zelf NIET offline getest (alleen de straal en Find); NIET in het spel gezien.

🔗 **Tooltips in Skill up + "maak eerst" GEBOUWD (21 nov)** — Rob: *"Wat ik wel mis zie, zijn onze tooltips die we overal zouden
inbouwen."* en op "maak eerst 9 Bolt of Linen Cloth (18 Linen Cloth nodig)": *"Ja, doe dat ook maar"*. Gedeelde helpers in
ForeverItemTips.lua: `ns.ForeverItemLinkText(id)` (echte item-link, kwaliteitskleur), `ns.ForeverSpellLinkText`,
`ns.ForeverHookLinks(frame)` (hover = spel-tooltip, shift-klik = chat). Skill up: recepten = link van het gemaakte item (anders
de spell), ingrediënten = item-links, "enough" groen erachter; tekst niet meer in een ScrollFrame (links werken daar niet,
PlayCardWindow-notitie, NIET hermeten) maar in een clip-frame met muiswiel-scroll, Shift+wiel = schalen. `MakeFirst`: tekort +
recept van HETZELFDE beroep dat je KENT (Knows) → "make N X first (needs …, you have …)", 1 niveau diep, aantal = ceil(tekort /
opbrengst). Offline GEMETEN (skillup_test.lua: Bolt of Linen Cloth 9 → 18 Linen Cloth, onbekend recept / ander beroep = niets;
vond een echte fout: Parse() ontbrak). Ook links/hover in: duurzaamheid-venster, krat-venster, Tas vol loot-regel (rijen hadden
al een tooltip). NIET gedaan: Repair-NPC's en "Deliver crates" — NPC-namen hebben geen spel-link/tooltip. NIET in het spel gezien.

✅ **Smart Bless WERKT (Rob in het spel, 21 nov, na 71521af)** — *"Ja, hij kreeg werkelijk wat ik gaf. Zowel iemand die niet
getarget was, als iemand die wel getarget was."* + *"Oh, dat is dynamisch. Dat is tof zeg."* Macrovenster: "#showtooltip /
/cast [@mouseover,help,nodead] Blessing of Wisdom" (62/255). Afgevinkt; open: chatregel zonder doelwit, `/mh blesstip`-regel.
Release-concept 5.7.0 bijgewerkt (RELEASE_NOTES = CURSEFORGE_5.7.0, CHANGELOG_570_8 + Changelog.lua). Daarna (sparring: charkey
en optie C zijn door Rob gezien) ook erin: erts/kruiden in de Loot Sparkles-regel (zonder "rood": niet getest) en een
bugfix-regel "every character keeps its own settings" (CHANGELOG_570_9). ⚠️ Waylaid Crates staat er NIET in (pas na Robs
test) maar zit bij een tag wél in de zip (alles op main gaat mee). Release blijft Robs go.

📋 **Testlijst in het spel: eerste echte ronde (21 nov)** — Rob gebruikte `/mhtest` in Forever (*"het fancy dat werkt"*), 3× Goed
+ 1 opmerking ("dit is een test"), Reload. `run testlist_ingame read` (proefrun) las ze GEMETEN. Met de hand weggeschreven
(de tool kan geen punt overslaan): optie C groen + `/mh sparkle` last node. NIET weggeschreven: "slimme zegen ook op je
doelwit" — Goed aangeklikt, maar Smart Bless werkte aantoonbaar niet (sparring vraagt Rob; waarschijnlijk misklik). De
testopmerking is weggelaten. Bij de volgende `read --write` komt dat Goed-vinkje opnieuw voorbij: dan eerst Robs antwoord.

🐞 **Smart Bless reparatie 2: MH schrijft de macro zelf (21 nov)** — GEMETEN door Rob na 5213ee8: "presses that reached the
button: 1 · last: 13:05:37, LeftButton up, line: /cast [@mouseover,help,nodead] Blessing of Wisdom; [@target,help,nodead]
Blessing of Wisdom · ActionButtonUseKeyDown = 1" en *"Nee, er gebeurt helemaal niks … Purify kwam wel aan met mijn
muisknop"*, geen foutmelding. Dus: klik bereikt de verborgen knop, regel klopt, maar de route /click → secure macro-knop
cast niets in Forever (WAAROM is NIET gemeten; AFGELEID mogelijk: /click kwam als "up" terwijl de knop met de CVar op 1 op
"down" handelt). Op voorstel van de sparring: `WriteMacro()` zet de regel met EditMacro (buiten combat, alleen bij een
andere regel) als body van "MH Smart Bless": `#showtooltip` + de /cast-regel; geen speler = `/run print("<FBLESS_NONE>")`
(7 talen). Rob drukt nu een gewone macro, zoals zijn Purify. In combat blijft de laatste tekst. `/mh blesstip` toont de
macro-body en "last write". De verborgen knop blijft alleen voor de diagnose. Offline GEMETEN (bless_test.lua, 22 controles).
NIET in het spel gezien.

🐞 **Smart Bless werkte niet met F5 GEREPAREERD (21 nov)** — Rob: *"Ik heb niks gedaan, maar het werkt niet."* De knop
luisterde alleen naar LeftButtonUp (useOnKeyDown false, overgenomen van de Disenchant-knop, die met de muis geklikt wordt).
Een `/click` vanaf een TOETS komt binnen als key-down als ActionButtonUseKeyDown aan staat; die CVar staat niet in Robs
Forever Config.wtf/config-cache.wtf (GEMETEN: afwezig = standaard; standaard 1 in Forever = AFGELEID van retail). Dus een
toets bereikte de knop nooit, een muisklik op het macro-icoon wel → "eerst niet, toen wel" (AFGELEID). Nu
RegisterForClicks("AnyUp","AnyDown") zonder useOnKeyDown-pin (zoals ForeverPartyPanel). Klikteller (HookScript OnClick):
`/mh blesstip` toont "presses that reached the button: N · last: tijd, knop down/up, line: … · ActionButtonUseKeyDown = …".
Offline GEMETEN (bless_test.lua, 16 controles). NIET in het spel gezien.

🔴 **Erts/kruiden optie C GEBOUWD (21 nov)** — GEMETEN door Rob (2 screenshots): ver = grijze ster + grijs bloem-icoon,
dichtbij = groene ster + gekleurd icoon; de grijze kleur kwam dus van afstand. Rob: *"c dus haha"* op "MH kijkt ook naar je
eigen skill … alleen als je het echt niet kunt … wordt hij rood". `tools/forever_nodes.py` → `Modules/ForeverNodeSkillData.lua`
(beide toc's): 74 nodes (41 kruid, 33 erts) met vereiste skill uit Wowhead Forever object-tooltips ("Requires Herbalism
(N)"), GEMETEN; controle 1618 Peacebloom = 1, 1620 Mageroyal = 50. DB2 GameObjects heeft ze niet (GEMETEN). Object-id =
GUID-veld 6 (los patroon). Kleur: cursor "Unable" + geen beroep, of skill < nodig → ROOD; "Unable" maar je kunt het →
normale kleur ("too far away … you can"); onbekende node → beroep geleerd = normale kleur. `/mh sparkle`: "last node: <naam>
(object id), kind, colour, reason, cursor". Uitleg FNODE_GLOW_SW_DESC in 7 talen; beroepsnamen per client GEMETEN (SkillLine
DB2: de Kräuterkunde/Bergbau, fr Herboristerie/Minage, es Botánica/Minería, esMX Herboristería (eigen regel in
Locales/esMX.lua), pt Herborismo/Mineração, it Herbalism/Mining, ru Травничество/Горное дело). Offline GEMETEN
(nodeswitch_test.lua: ver+kan → goud, Tin 65 met Mining 5 → rood, geen Mining → rood, onbekend → goud, dichterbij zonder event).
NIET in het spel gezien.

⛏️ **Witte ster GEREPAREERD (21 nov, later)** — Rob: *"Deze IMA heeft wel herbalism."* Oorzaak (GEMETEN in de code,
AFGELEID dat het Robs geval is): de kleur werd alleen gekozen bij PLAYER_SOFT_INTERACT_CHANGED / NAME_PLATE_UNIT_ADDED, dus
op het moment dat de plant tot 15 m ver werd opgepikt. Daar zegt de cursor "Unable" (te ver; GEMETEN op erts 20 nov) →
grijs, en dat bleef zo terwijl je dichterbij liep. Nu kijkt de gloed 5× per seconde opnieuw zolang hij zichtbaar is
(OnUpdate op het eigen, niet-secure gloed-frame). `/mh sparkle` heeft "last node: <naam>, kind …, colour …, reason …, cursor
…" (reden: "game says Unable: too far away, or skill too low (yours x/y)" / "you have no Herbalism" / "you can pick it")
en schrijft `MidnightHelperDB.foreverNodeLast`. Offline GEMETEN (nodeswitch_test.lua + nieuwe stap: grijs → dichterbij zonder
event → goud). NIET in het spel gezien.

⛏️ **Erts/kruiden-gloed: Rob zag een WITTE ster op Peacebloom (21 nov)** — werkt (bloem-icoon + MH-ster); Lueur is weg
(sparring GEMETEN: map bestaat niet meer). Code (GEMETEN): kleur komt alléén uit de cursor-naam van de game: "unable" erin
→ grijs (0.6, met ADD-blend AFGELEID wit-ogend), anders herb → groen, mine → goud. Of die ster grijs of groen was en waarom,
is NIET gemeten. `/mh sparkle` toont nu ook "colour: …", de cursor-naam van de game, en je Herbalism/Mining (rang of "not
learned"). Volgende stap: Rob staat bij een kruid en typt `/mh sparkle`. Voorstel aan sparring: "kan niet" rood maken i.p.v.
grijs (grijs leest als wit).

✨ **Slimme zegen ook op je doelwit GEBOUWD (21 nov)** — Rob via sparring: *"Als ik iemand geselecteerd heb en die hard
doorloopt, dat ik daarna op F5 druk"* → op "Eerst de muis, anders je doelwit": *"Ja, doe maar."* `ForeverBlessTip.lua`: de
knop is nu type macro met één regel `/cast [@mouseover,help,nodead] <zegen>; [@target,help,nodead] <zegen>` (de game kiest
bij het indrukken; MH schrijft de regel buiten combat bij UPDATE_MOUSEOVER_UNIT en PLAYER_TARGET_CHANGED; deel alleen als
Pick() een vriendelijke SPELER vond). Geen van beide = geen regel, de toets doet niets (keuze: GEEN zelf-cast, niet
gevraagd; gemeld aan sparring). Spellnaam uit de client (C_Spell.GetSpellName), /cast zonder rang = hoogste (AFGELEID, net
als ForeverBlock). `/mh blesstip` toont nu "target now", "target on the button" en "the key runs: …"; probe slaat target +
regel op. Pick splitst nu de reden: "no mouseover" / "UnitIsPlayer secret|nil|error" / "not a player" (zelfde voor
UnitCanAssist) — Robs probe van vandaag zei alleen "not a player (or unreadable)", dus of UnitIsPlayer na de hotfix secret
is, is NIET gemeten; de volgende `/mh blesstip` meet het. AFGELEID uit de oude code waarom het "eerst niet, later wel"
werkte: de spell werd pas gezet bij de eerste muis-over op een speler. Typ je `/mh blesstip` in chat, dan staat je muis op
de chat → "mouseover" leest niets; dat zegt de diagnose nu ook. Uitleg FBLESS_BTN_SW_DESC in 7 talen bijgewerkt. Offline
GEMETEN (bless_test.lua, 12 controles). NIET in het spel gezien.

🔑 **Charkey: eerste test van Rob (21 nov, middag)** — Ima 1 `/mh charkey`: poleGear/toolTip/ranks.top "already there",
"copies made so far: 4". GEMETEN in de Forever-SV: `charKeyMigrated` heeft 4 kopieën voor Player-6944-0118CB4F (pole,
ranks.top, toolTip: uit "Ima-CAMWOW EU4 Realm 10 RP" + "Ima-"; recepten: uit "Ima-"), en `foreverToolTipSeen[GUID]` =
dezelfde 4 vakken als de oude sleutel. Dus wél gekopieerd, bij een eerdere login/reload; "already there" was verwarrend →
zegt nu "copied earlier (datum) from …" of "already there (made by this character…)". Ranks-stap kon niet (dat character
heeft geen spells met meerdere ranks, AFGELEID) — niet nodig, de SV-vergelijking bewijst de kopie.

🔑 **API-wachter #2: één sleutel per character in Forever GEBOUWD (21 nov)** — Rob via sparring, letterlijk: *"A"* (speler-GUID
via één gedeelde functie; unieke voornamen nemen oude data mee; elke Ima krijgt een kopie; /mh toont per module de
sleutel). GEMETEN in Robs Forever-SV (20 nov 22:23, na de hotfix): `realm = ""`, `normRealm = ""`, `UnitFullName` 2e waarde
= achternaam ("Pallie"); oude sleutels "Naam-CAMWOW EU4 Realm 10 RP" (één realm), en al vóór de hotfix deelden álle "Ima"'s
één sleutel. Nieuw `Modules/ForeverCharKey.lua` (beide toc's, stopt buiten Forever): `ns.ForeverCharKey(label, legacy, tbl,
opts)` → UnitGUID("player"); kopieert eenmalig per tabel+character "Naam-<realm>" + "Naam-" (tabellen recursief, getallen
max, anders de nieuwe; `whole` = de nieuwe in één stuk; twee realms voor één naam = oude niet, log zegt het). Oude sleutels
blijven staan (vangnet; 🗓️ op z'n vroegst na 28 nov opruimen). Omgezet: ForeverSkillup (foreverKnownRecipes), ForeverRanks
(top + except), ForeverVendors (foreverToolTipSeen), ForeverWarnings (foreverPoleGear, whole), ForeverTravel (bind, whole),
KeyPresses (chars). ⚠️ Afwijking van het plan, met reden: KeyBlock (keyBlockCodes) en SlotOwnership (managedSlotsByChar)
krijgen de nieuwe sleutel maar GEEN kopie — KeyBlock bouwt zijn codes bij elke login opnieuw uit je balken (een oude
Ima-code beschrijft de balken van een andere Ima), en SlotOwnership zegt in zijn eigen commentaar dat een record bij het
verkeerde character de fout zelf is. Retail ongewijzigd (functie bestaat daar niet → oude sleutel). `/mh charkey` toont per
module sleutel, oude sleutel en wat er gekopieerd is; `MidnightHelperDB.charKeyMigrated` houdt de kopieën bij. Offline
GEMETEN (charkey_test.lua, 17 controles: kopie, diep, oud blijft, max-merge, whole, al aanwezig, dubbelzinnig, geen kopie,
tweede Ima eigen kopie, Joey eigen data, "Imani" niet als "Ima", geen GUID). AFGELEID: speler-GUID blijft gelijk. NIET in
het spel gezien. Correctie: "achternaam pas vanaf level 10" was een web-API-spelerspost (API_WATCH ~9920), NIET gemeten —
daar nu rechtgezet (Rob: je kiest voor- en achternaam bij het maken).

🔧 **API-wachter [MOET GEFIKST] #1 GEREPAREERD (21 nov)** — sparring: bugfix, geen keuze nodig. `ForeverVendors.lua` (het
leren van reparateurs bij MERCHANT_SHOW) gebruikte als enige plek nog `^Creature%-%d+%-%d+%-%d+%-%d+%-(%d+)`; sinds de
Forever-hotfix van 20 nov zijn veld 3-4 geobfusceerd. Nu velden 2-5 los (`[^%-]+`, zoals regel ~1170 en 5 andere
bestanden). GEMETEN: grep over alle .lua op het strikte patroon = 1 treffer (deze), losse variant = 6 treffers in 5
bestanden (controle). Offline GEMETEN (guid_test.lua): oud formaat, letters in veld 3/5, nullen, Player-GUID → juiste npc
of nil. Mislukt het toch, dan zegt `/mh vendor check` nu "learning: … did not give an npc id" (zweeg eerst). #2 (lege
realm) = onderzoek naar de sparring, Rob kiest.

📦 **Waylaid Crates GEBOUWD (21 nov, Forever, optie Middel)** — Rob via sparring: *"Waylaid crates zijn het ... wat zijn
dat? En ik denk dat wij er ook iets mee moeten."* → *"Ja doe maar"*. `tools/forever_crates.py` → `Modules/ForeverCratesData.lua`
(GEMETEN, DB2 wowf 1.60.1.71037 ItemSparse + Item, en de Wowhead Forever-tooltips van elke krat): 30 getypeerde kratten
(248682–248699 ruw q1, 248702–248713 gemaakt q2), elk met hun bundels als {aantal, item-id} (namen → id via ItemSparse,
bij dubbele naam de trade good; 1 geval: Dark Iron Ore 11099), 15 verzegelde (248765–248779, q1/q2/q3). Positieve controle:
248682 = 10 Earthroot (2449). Inleveren (Wowhead Forever NPC-tooltips, GEMETEN): Marcy Baker 256390 Redridge 1433 9.6,71 /
Dokimi 256386 Barrens 1413 50,29.2; HandyNotes en Zygor hebben ze NIET (grep, Zygor-controle 214101 vond wel). Namen per
taal GEMETEN (fr Marcy Fournier, pt Márcia Barreto, ru Марси Бейкер/Докими; ondertitel per taal). `Modules/ForeverCrates.lua`
(beide toc's): tooltip (bundels + GetItemCount met bank, vinkje/kruisje; groen = gemaakt "double Favor"; lege krat:
"right-click to read the label" + level 20/35; verzegeld/label: bij wie, zone, afstand, "Find -> Deliver crates";
eerste-label-tip zolang quest 98247/98248 niet gedaan), venster bij aankomst van een verzegelde krat/label in je tas
(BAG_UPDATE_DELAYED, eerste meting = basis; in combat wachten), Find-categorie `crates` in ForeverVendors (In town) met
Favor (3402, via ns.ForeverCurrencyViews) + rang (2586/2587, via ns.ForeverRepViews) bovenaan. Schakelaar `FCRATE_SW`
(standaard aan), `/mh crates [test|on|off]` schrijft de tooltipregels van elke krat in je tas naar
`MidnightHelperDB.crateProbe` (om de vul-voortgang te meten). 7 talen + esMX (Cajón arrebatado / Etiqueta de envío, GEMETEN).
AFGELEID/niet door MH gemeten: "groen = dubbel Favor" en "eerste label = 50 Favor + 2000 rep + XP" (uit het mh-research-
rapport van de sparring, Wowhead + conquestcapped); of GetItemCount(id, true) in Forever de bank meetelt. Offline GEMETEN
(crates_test.lua, 24 controles: tooltips, schakelaar, venster, combat, knop, Find-regel, probe, frFR-naam). NIET in het spel
gezien. ForeverLevelingGuide (krat-module, ARR) niet gebruikt.

🚢 **Pijl-zin bij een zeppelin/boot/tram GEREPAREERD (20 nov, laat)** — Rob: *"je loopt niet door de Zeppelin heen. Je
neemt de Zeppelin."* (Carola, class-training-route). Enige bron (GEMETEN, grep op "other side"/"go through"/"andere kant"
in de locales): `ARROW_AT_STEP` in NativeArrow (je staat óp een reisstap). Nu `ns.ArrowAtStepText(step, name)`: Forever-
stappen dragen `linkKind` (boat/zeppelin/tram/sky/loop → ARROW_AT_RIDE "wait here and get on…"; portal → ARROW_AT_STEP
zoals vroeger). Midnight-zoekstappen (source `MOUNTRUN_HUBS.<key>`) hebben al een hele zin als label ("Take the zeppelin
to X.") → ARROW_AT_RIDE_SENTENCE (zeppelin/tram) of ARROW_AT_SENTENCE (portaal, boot = kapitein aanspreken, deur). Dat
repareert meteen "You are at Take the portal to X. — go through" (AFGELEID uit de code; niet in het spel gezien). 7 talen.

⛏️ **Erts en kruiden: twee schakelaars GEBOUWD (20 nov, laat)** — Rob na zijn meting: *"reload gedaan, en ik wil beide met
idd de schakelaars"*. Uitslag (GEMETEN, Forever-SV `nodeProbe`, "Ima", Lueur uit, 22:07): vóór geen softinteract; na de
waarden "Copper Vein", UnitIsGameObject true, nameplate ja (getoond, niet forbidden), cursor "Cursor Crosshair_Mine_64"
(in bereik) / "Cursor Crosshair_UnableMine_64" (buiten bereik); UnitExists("softinteract") = FALSE. Terugzetten exact
(1/0/10/0/1/1). SoftTargetInteract en -Range zijn "secure" (GetCVarInfo). Console: 1879 commando's, o.a.
SoftTargetNameplateInteract "Always show nameplates for soft interact target". Rob zag een houweel boven de ader, en een
gele gloed links (onbekend wat; AFGELEID misschien de loot-glinstering: outlineModeShowLootEffectWhenDisabled stond op 1).
Gebouwd in `ForeverLootSparkle.lua`: `FNODE_ICON_SW` (A: NODE_SET aan) en `FNODE_GLOW_SW` (B: star4-gloed, ADD, op de
nameplate van softinteract, offset −40 = AFGELEID; goud erts, groen kruid ("herb" in de cursornaam = AFGELEID), grijs bij
"Unable"). B heeft dezelfde CVars nodig, dus het icoon komt mee. Beide standaard UIT, nooit in combat, eerst alle oude
waarden lezen, terugzetten als beide uit staan; CVAR_UPDATE en laadscherm zetten ze 1 s later opnieuw. Lueur geladen →
MH doet niets (FNODE_LUEUR). `/mh sparkle` toont alles; `/mh sparkle icon|glow on|off`. 7 talen. Offline GEMETEN
(nodeswitch_test.lua: aan/uit, grijs, kruid, verbergen, preset, geen lus op "15.000000", uitzetten in combat → na combat
terug, Lueur). NIET in het spel gezien.

⛏️ **Kruiden en erts laten glinsteren: MEETFASE (20 nov)** — Rob: *"ja graag"* op "eerst uitzoeken, dan meet jij, dan
bouwen". Onderzoek (mh-research, GEMETEN in de Forever-UI-bron): GEEN glinster-CVar voor nodes. Node-addons (Lueur: idee,
MIT volgens zijn CF-pagina, geen code genomen) zetten soft-targeting aan (SoftTargetInteract 3, Arc 2, Range 15,
IconGameObject 1, NameplateInteract 1) en hangen zelf een gloed aan de nameplate van "softinteract"; één node tegelijk,
~15 m. Robs cvp2/cvp3 waren Lueurs waarden (GEMETEN: gelijk aan Lueur's gate; echte waarden in LueurDB.savedCVars).
Lueur staat aan op 5 karakters (AddOns.txt), uit op o.a. Midnight-Helper en Ima-Pallie. Meting gebouwd in
`ForeverLootSparkle.lua`: `/mh sparkle nodes` → CVar-info (19 namen), ConsoleGetAllCommands-treffers, softinteract
vóór/na (naam, GUID, gameobject, plate, cursor-icoon), wijzigingen 30 s lang, dan exact terugzetten (ook bij reload/logout/
laadscherm) → `MidnightHelperDB.nodeProbe`. Weigert als Lueur geladen is (`force` om toch). Offline GEMETEN
(nodeprobe_test.lua): zetten, terugzetten, vangnet, weigering. NIET in het spel gezien. VOLGENDE: Robs uitslag lezen → stap A
(alleen CVars, icoon van de game) of stap B (MH tekent een gloed op die nameplate). Bijvangst: Loot Sparkles bewaarde
OutlineEngineMode "0" terwijl cvp1 "2" mat (AFGELEID: graphicsOutlineMode trok hem mee) → nu eerst álle oude waarden
lezen, dan zetten. Robs huidige `lootSparkle.saved` heeft nog de 0 (bij uitzetten: rand terug via graphicsOutlineMode 2).

🛡️ **Duurzaamheidswaarschuwing in Forever GEBOUWD (20 nov)** — Rob: *"ja doe maar"* op "zijn je spullen onder de 25%, dan
zegt MH het en toont hij de knop 'Repair & sell' erbij". `Modules/ForeverDurability.lua` (beide toc's, stopt buiten
Forever): UPDATE_INVENTORY_DURABILITY + na laadscherm (3 s) → laagste item < 25% → venster
`MidnightHelperForeverDurability` (RegisterMidnightDialogPopup) met DURABILITY_WARN_FMT + DURABILITY_WORST_FMT (bestaande
vertalingen, 7 talen) + "Repair & sell: naam, zone, afstand" + knop (ns.ForeverRepairGoNearest) + chatregel + raid-warning-
geluid. Eén keer per daling (`armed`), opnieuw na reparatie boven de grens; in combat wacht hij op PLAYER_REGEN_ENABLED.
Schakelaar `FDUR_SW` (Quiet helpers), standaard AAN (advies: hij komt zelden). `/mh durability [test]` in Forever = deze
module (ns.DurabilityCommand; DurabilityWarn.lua laadt alleen in Midnight). Drempel `ns.db.foreverDurability.at` (25).
✅ Rob zag het venster (screenshot via sparring, na /reload): "Your gear is at 98%…", "Lowest: [Copper Shortsword].",
"Repair & sell: Nadia Vernon, Silverpine Forest, 634 meters" + knop. Rob: *"kan de tekst ed gecentreerd worden ?"* →
tekst en knop nu gecentreerd. 98% boven de 25%: in de code GEMETEN dat alleen `/mh durability test` het venster boven de
grens toont (Check stopt bij `low >= at`; niets anders roept Warn aan). Rob bevestigde: *"ik had het getikt"*. Daarom
zegt de test nu "(test)" achter de zin en schrijft hij geen chatregel.

🔧 **Repair & sell GEBOUWD (20 nov, Forever)** — Rob: *"Hebben we al iets in onze helper staan waarbij ik aan kan klikken
om zo snel mogelijk naar iemand of iets te gaan waarbij ik mijn spullen kan repareren en zeker verkopen?"* → *"ja doe
maar"*. Data: `tools/forever_repair.py` → `Modules/ForeverRepairData.lua` (beide toc's): Zygor Forever NPCData ["Repair"]
(waarde) + per NPC de Wowhead Forever-tooltip (naam, ondertitel, spawns): 359 rijen, 358 binnen 1,0 van Wowhead (GEMETEN);
1 verschil = Craftsman Wilhelm EPL (Wowhead heeft daar alleen Classic-frame-punten). Redridge-rijen x −5,15 (oude frame),
alleen NPC-id < 200000 (Forever-eigen NPC's staan al goed, GEMETEN op 256730). Alterac Valley (1459) weggelaten.
ForeverVendors: categorie `repair` (In town + Which city?), `RepairSpots()` = data − `db.foreverNotRepair` + `db.foreverRepairSeen`
(geleerd bij MERCHANT_SHOW via CanMerchantRepair + UnitGUID("npc"); clientnaam + plek), `ns.ForeverRepairNearest/GoNearest`,
`/mh vendor check` telt repair. Tas vol-venster: regel "Repair & sell: naam, zone, afstand" + knop. Ondertitel alleen op een
Engelse client (zoals de winkels); namen Engels tot MH de NPC zag (dan de clientnaam). Offline GEMETEN (repair_test.lua):
Goldshire → Andrew Krighton / Corina Steele, leren werkt. Geen Forever-duurzaamheidswaarschuwing in MH (DurabilityWarn.lua
alleen in de Midnight-toc, GEMETEN) → daar dus geen knop; voorstel aan de sparring. NIET in het spel gezien.

🗑️ **Tas vol STAP 2 GEBOUWD (20 nov)** — Rob via sparring: *"Nu geeft het me 3 opties die ik eruit kan gooien, maar toch
wil ik graag die knop erbij per stuk. Dat we dat kunnen destroyen."* Zijn `/mh bagfull test` (Forever, niet bij een
verkoper, GEMETEN): vanuit een klik Delete/Use niet geblokkeerd; vanuit een timer UseContainerItem ADDON_ACTION_BLOCKED;
Sell All Junk enabled = false. Dus alles ALLEEN vanuit een klik. Gebouwd in ForeverBagFull.lua:
Destroy per regel → StaticPopup "MH_BAGFULL_DESTROY" (Ja = klik) → `DoDestroy`: zelfde itemID op die plek, geen tool, geen
quality ≥ 3, ClearCursor + PickupContainerItem + check GetCursorInfo + DeleteCursorItem; ligt het nog op de cursor →
ClearCursor + "not allowed". "Pick up the loot"-knop (LootSlot, eigen klik; in dezelfde klik kan niet, de server moet het
vak eerst vrijgeven, AFGELEID). "MH: sell junk (N)" onder het MerchantFrame: alleen grijs uit dezelfde lijst, max 12 per
klik (BUYBACK_ITEMS_PER_PAGE 12). ADDON_ACTION_BLOCKED/FORBIDDEN binnen 2 s na onze klik → melden; verkopen daarna nooit
meer (`ns.db.foreverBagFull.sellBlocked`). Test zonder timer-fase (geen rode fout meer), noteert "bij een verkoper".
`StaticPopupDialogs` alleen een eigen sleutel (nooit de global zelf toewijzen). FBAG_HINT + release-tekst/CHANGELOG_570_5
bijgewerkt (MH gooit niet meer "niets" weg, wel alleen op je klik). Offline GEMETEN (bagfull_test2.lua): vernietigt het
juiste item, weigert bij ander item en bij de hengel, verkoopt alleen grijs. NIET in het spel gezien; of vernietigen met
een ECHT item mag, weet alleen Robs test.

🐞 **Tas vol: Fishing Pole in de lijst GEREPAREERD (20 nov)** — Rob testte zelf (screenshot): *"Hij wil mijn fishing pole
weggooien. Maar mijn fishing pole die wil ik niet weggooien, want die heb ik nodig om te vissen."* Oorzaak (GEMETEN in de
code): ForeverToolGuard's TOOLS heeft geen hengels, dus de hengel viel door naar "gear". Nu `IsTool` in ForeverBagFull:
ToolGuard-lijst + elke hengel op soort (wapen-subklasse Fishing Pole, `Enum.ItemWeaponSubclass.Fishingpole`, terugval 20,
AFGELEID dat Forever die enum heeft) + hengel-id's uit ForeverVendors (6256 6365 6366 6367 12225 19022 19970) + itemklasse 19.
Ongeacht of je het beroep hebt. Offline GEMETEN: Fishing Pole (id) en een onbekende hengel (soort) eruit, gewoon zwaard
blijft. Verder werkte Robs test: venster + loot-vergelijking (Tough Jerky 1c, Slimy Bone 13c, Cracked Bill 28c).

📋 **De testlijst in het spel GEBOUWD (20 nov, alleen voor Rob)** — Rob via sparring: *"Kunnen wij niet een soort
zijstapje maken in onze add-on die alleen voor mij is? …"* (zin in IDEEEN). Aparte addon `MidnightHelper_Testlist`
(bron `tools/testlist_addon/MidnightHelper_Testlist/`: 2 toc's zoals MH, `Testlist.lua`; `.pkgmeta` negeert tools/ →
nooit in de zip, GEMETEN). `run testlist_ingame` = Data.lua uit TESTLIJST.md (parser + id's van testlist_page.py, nu
ook `cmds` uit `/backticks`, emoji eruit) + kopie naar `_retail_\Interface\AddOns\` én `_forever_\Interface\AddOns\`
(GEMETEN geïnstalleerd, 705 punten). In het spel `/mhtest`: secties links (Nieuwste/Alles), kaartjes rechts met Goed/
Fout/Overslaan, opmerking, commando-knop → chatregel, Reload-knop, Shift+wiel schaal. Opslag `MHTestlistDB.results[id]`
= {s, n, t, sec, text}. Terug: `run testlist_ingame read` (proefrun) / `read --write`: leest beide WTF-mappen
(`*\WTF\Account\*\SavedVariables\MidnightHelper_Testlist.lua`), nieuwste per id; Goed → `[x] ✅ (Rob in het spel, datum)`,
Fout → blijft open + `❌ … : opmerking`, opmerking → `📝`. Offline GEMETEN: luac OK (4 bestanden), venster/klikken/
opmerking/commando met stubs, teruglezen op een nep-SV in de kladmap (Robs WTF niet aangeraakt). NIET in het spel gezien.
Na elke wijziging aan TESTLIJST.md: `run testlist_ingame` opnieuw (en /reload). Data.lua staat alleen in de installaties.

📝 **Release-tekst 5.7.0 GESCHREVEN, NIET uitgebracht (20 nov)** — Rob via sparring: *"Ja dat mag erna"*. Voorgesteld
nummer 5.7.0 (nieuwe functies). `RELEASE_NOTES.md` = `docs/CURSEFORGE_5.7.0.md` (identiek), `CHANGELOG_570_1..7` (enUS) +
entry in `Changelog.lua`. GEEN .toc-bump (nog 5.6.0), geen tag, geen package. Het changelog-venster springt alleen open
als de .toc-versie verandert (GEMETEN, `ShowChangelogWindow`), dus Rob ziet nu niets. Inhoud sinds v5.6.0: Forever nieuw
overzicht, Which city? + alle herbergen, Hearthstone/teleports in de route, Skill up, Tas vol, Rested XP, Loot Sparkles,
geen Dock to window; beide spellen ThanksBuff (door Rob getest); Midnight Renown-regel. Alles behalve ThanksBuff is
NIET door Rob getest → schrappen als zijn test faalt. Bij Robs go: .toc's naar 5.7.0, dan pas tag.

🏅 **O14 Renown in het alt-overzicht GEBOUWD (20 nov, Midnight)** — Rob via sparring: *"1"* (één regel "Renown (hele
account)" bovenaan). `AltOverview.lua`: `RenownSummary()` uit `C_MajorFactions.GetMajorFactionIDs()` + `GetMajorFactionData`
(+ HasMaximumRenown), namen van de client; regel `ui.renown` tussen titel en hint, tooltip (`ui.renownHit`) met elke factie
en de reden als hij ontbreekt ("not unlocked yet" / "the game gave no data"). Woord "Renown" = client-global
LANDING_PAGE_RENOWN_LABEL; GEMETEN per taal (GlobalStrings 12.1.5.70961): de Ruhm, fr Renom, es Renombre, esMX
Reconocimiento (wissel in esMX.lua), pt Renome, it Fama, ru Известность. Geen kolom per character (renown = account-breed,
bit 4 GEMETEN 19 nov voor 2590/2600/2710; voor de rest AFGELEID). Welke facties GetMajorFactionIDs zonder argument geeft
(alleen deze uitbreiding, ook Journeys?) is NIET gemeten → Robs screenshot. NIET in het spel gezien.

🎒 **Tas vol, MIDDEL stap 1 GEBOUWD (20 nov)** — Rob: *"Beide ja"* (Middel in twee stappen). `Modules/ForeverBagFull.lua`
(beide toc's, stopt buiten Forever; WoW herstarten). Trigger: UI_ERROR_MESSAGE met ERR_INV_FULL (wat Blizzards LootFrame
gebruikt, GEMETEN in de Forever-UI-bron), max 1×/20 s. Venster `MidnightHelperForeverBagFull` (RegisterMidnightDialogPopup):
3 goedkoopste (verkoopprijs × stapel, normale tassen) + waarom (grijs / gear niet beter / goedkoopst) + loot-vergelijking
als het lootvenster open is. Nooit: questitems (GetContainerItemQuestInfo), gereedschap (nieuw `ns.ForeverIsTool` in
ToolGuard), ingrediënt voor je beroep (ReagentUseText groen), upgrade (ForeverGearTipText), quality ≥ 3, geen waarde.
MH doet NIETS met items. `/mh bagfull [show|test|on|off]`; `test` roept DeleteCursorItem (lege cursor) en
UseContainerItem (leeg vak) aan vanuit een klik en een timer en vangt ADDON_ACTION_BLOCKED/FORBIDDEN → beslist stap 2.
Offline getest (scratch bagfull_test.lua): selectie en uitsluitingen kloppen. NIET in het spel gezien. Kwaliteitsnamen
nagezet naar de client (GEMETEN Forever GlobalStrings ITEM_QUALITY0/3_DESC): de Schlecht/Rar, fr Mauvais/Rare, es
Pobre/Raro, pt Inferior/Raro, ru Низкое/Редкое; en/nl Poor/Rare. Stap 2 (Destroy-knop + loot,
"Sell MH junk") pas na Robs test.

⏹️ **TESTLIJST opgeruimd (20 nov)** — Rob: *"Beide ja"* (oude punten naar archief "vervallen, niet getest"). Script
(scratch testlist_split.py, per `## `-kop, eerste datum in de kop): 316 secties met kopdatum vóór 10 nov → bovenaan
`TESTLIJST_ARCHIEF.md` onder "Derde verhuizing", open punten als `[vervallen, niet getest]`. GEMETEN: vóór 1765 open /
599 [x]; na 697 open / 140 [x] in TESTLIJST, 1068 vervallen in het archief. Blijven staan: "9 nov — Deze week in
Forever" en de kop zonder datum (19 nov). De telefoonpagina (testlist_page) is NIET opnieuw gebouwd.

🔨 **Skill up voor beroepen (idee 6, MIDDEL) GEBOUWD (20 nov, Bouwchat 20-11 (2))** — Rob via sparring: *"Ja, begin
daar dan mee. Het geld kunnen we inderdaad later bekijken."* Nieuw: `tools/forever_skillup.py` → `Modules/
ForeverSkillupData.lua` (2119 recepten, 1605 receptitems, 120 KB; controles 2660 = Blacksmithing 15/55 Rough Stone en
item 2881 → 2667 OK, GEMETEN DB2 1.60.1.70959) en `Modules/ForeverSkillup.lua` (in beide toc's, zoals ForeverReagentData; buiten Forever stoppen ze meteen. De 120 KB
wordt in Midnight wel ingelezen (Lua compileert het hele bestand), net als ForeverReagentData. → WoW herstarten).
Geel/grijs GEMETEN; groen = midden en kans (grijs−skill)/(grijs−geel) AFGELEID, overal "estimate". Bekende recepten:
uit het beroepsvenster (C_TradeSkillUI of oude GetTradeSkillInfo, wat Forever heeft is NIET gemeten) per character in
`ns.db.foreverKnownRecipes` + IsPlayerSpell. Volgende stap = zekerste bekende recept, max 10 punten per stap
(`STEP_MAX`), aantal = som 1/kans. Tooltip: product/receptitem (grenzen + jouw kleur, of "ken je nog niet") en
ingrediënt (beste recept nu). Venster `MidnightHelperForeverSkillup` (RegisterMidnightDialogPopup), `/mh skillup
[probe|on|off]`, knop op Overzicht → Professions + blauwe regel bovenaan de kaart. Offline getest (scratch
skillup_test.lua, stubs): stap/lijst/tooltips kloppen. NIET in het spel gezien. **Eerst Robs `/mh skillup probe`**:
geeft de client zelf de receptkleur, dan kan MH die tonen i.p.v. uitrekenen. Teksten 7 talen (de/fr/es/pt/ru zelf
vertaald, niet nagekeken). GROOT (geld, Auctionator, route tot 300) = later (IDEEEN).
✏️ **Vertaalfixes Skill up (zelfde dag)** — nagekeken door een mh-research-helper van de sparring (Forever GlobalStrings
1.60.1.70959). ptBR: "habilidade" → "perícia" (client SKILL = Perícia, zelf nagemeten) in FSKILL_* + 4 oudere
beroeps-regels (FOV_TIP_CARD_FIND, FOV_TIP_TAB_PROFS, FOV_TIP_CARD_PROFS, FOV_PROF_SKILL_UNKNOWN), "profissão de
criação", "dicas de tela". frFR "ne donne plus", "infobulles", %d%%. ruRU «namen», "с %d до %d", TIP_YOU/REAGENT
herschreven. deDE "Handwerksberuf", "das Fenster für %s", kleuren met hoofdletter. es/nl kleine stijlpunten.

🛏️ **Alle herbergen in de data (20 nov, Bouwchat 20-11 (2))** — Rob via sparring: *"Zoek online uit waar dan overal
herbergen zijn, onder andere ook voor Richard."* (= Ratchet). `ForeverCitySpots.lua`: 40 nieuwe `kind = "inn"`-regels
(nu 52 herbergiers, 51 plaatsen; Dalaran heeft er 2. ⚠️ Er stonden er 12, niet 14 zoals hieronder staat: GEMETEN met
grep op `kind = "inn"`). Bron per regel: Zygor Forever `LibRover-1.0/data_inns.lua`
(waarde) + Wowhead Forever npc-tooltip (naam, "Innkeeper", spawns), allebei GEMETEN 20 nov, alle binnen 0,4 (Aerie
Peak 0,35). HandyNotes_WoWForever heeft GEEN herbergen (0 treffers, positieve controle 417 andere NPC-regels).
Zygor-fout: Hammerfall had npcid 7731 → 9501 Innkeeper Adegwa (Wowhead bevestigt). Nieuwe velden `area` (AreaTable,
GEMETEN DB2 1.60.1.70959) en `town` (Engelse terugval); UiMap-ID's GEMETEN (Riverglades 2548). Rog'Mar: geen
AreaTable-rij onder die naam → Engelse naam. Minst zeker: Rog'Mar 58,45 en Powderfuse Port 78,8,54 (Zygor: "GET MORE
ACCURATE COORDS LATER", Wowhead dezelfde ronde waarden). Code: `ForeverFindCities` één regel per plaats (sleutel
"a<area>" of map), naam uit area; `ForeverCityServiceRows` kiest per soort de plek het dichtst bij DEZE herberg, straal
700 yd hoofdstad / 300 yd dorp (AFGELEID); `ForeverTravel` BindDest vindt de herberg nu ook op dorpsnaam
(Hearthstone-route naar een dorp). `FCITY_SUB_INN` in 7 talen: "in steden en dorpen". NIET in het spel gezien.
**Ronde 2 (zelfde dag, na mh-research):** +5 herbergiers die Zygor's data_inns mist (Sebelia/Summit of Eternity,
Caitir Flinthew en Ortak Lomgok in West-Hyjal, Adarien in Shen'dralas, Berdun Cliffbrew/Talrendis Point), elk zelf
nagemeten in de Wowhead Forever-tooltip → nu 57 herbergiers. 2 coördinaten GEREPAREERD: Zygor + Wowhead staan in
Redridge en Eastern Plaguelands in het oude Classic-kaartformaat (GEMETEN via onze flight-master-regels met DB2-
wereldcoördinaten): Brianna/Lakeshire 27,0 → 21,8 (Wowhead heeft ook die Forever-spawn), Jessica Chambers/Light's Hope
81,6,58,1 → 71,8,48,5 (omgerekend, = wowfdb). Mulgore (Kauth) klopt WEL (vendors 9 nov). Andere zones: flight masters
binnen 0,4 → zelfde formaat. NIET opgenomen: Markus Hearthfire (New Avalon) — of je daar kunt binden is onbekend.
Sleutel zonder area = "n<npc>" (West-Hyjal en Shen'dralas tonen de zonenaam).

🏙️ **Stap 3 GEBOUWD (Bouwchat 20-11 (2))** — Find kreeg "What am I looking for? | Which city?" + zoekveld. NIET in het spel
gezien; TESTLIJST "Find, stap 3".
- `ForeverVendors.lua`: `ns.ForeverFindCities()` = elke plaats met een herberg in ForeverCitySpots aan jouw kant (één
  per map; hoofdsteden eerst, dan andere plaatsen op afstand), `ns.ForeverCityServiceRows(map)` = per soort (inn, bank,
  auction, mail, flight) de dichtstbijzijnde binnen `CITY_RADIUS` = 700 yd van de herberg (AFGELEID getal) + elke
  transportstop + je class trainer (`ForeverProfTrainerList(nil)`), `ns.ForeverCityGo(map)` = pijl naar de herberg.
  Stadsnaam: hoofdsteden = `C_Map.GetMapInfo`; andere plaatsen = `C_Map.GetAreaInfo(area)` met area-ID's GEMETEN in
  Forever-DB2 AreaTable 1.60.1.70959 (Booty Bay 35, Dalaran 279, Gadgetzan 976, Everlook 2255, Valanaar 16638), Engels
  als terugval. Of `C_Map.GetAreaInfo` in Forever bestaat: NIET gemeten (pcall + terugval). Hearthstone-label =
  `GetBindLocation() == stadsnaam` (AFGELEID dat die gelijk zijn) met de itemnaam 6948 uit de client.
- `ForeverOverview.lua`: knoppen `cat.modeWhat`/`cat.modeCity` + zoekveld `cat.search` in `BuildFindPage` (lijst begint
  nu op 86 i.p.v. 34); `FillCityPage`; keuze in `ns.db.foreverFindMode` ("city"/nil) en `ns.db.foreverFindCity` (map);
  `ShowForeverFind(kind)` zet terug naar "what". Zoekveld filtert in beide standen (naam bevat tekst).
- Teksten `FOV_FIND_MODE_*`, `FOV_FIND_CITY_*`, `FOV_FIND_SEARCH`: enUS, nlNL, de/fr/es/pt/ru (ForeverClassQuests_*).
- ✅ Ratchet zit er nu in (zie "Alle herbergen" hierboven). Werkt ook in de oude lay-out (schakelaar).

**Robs woorden (via sparring, 20 nov):** idee: *"…ik wil naar Ogrimai. Als ik hoorde ben uiteraard. Terwijl ik helemaal
op het andere werelddeel zit."* · Find: *"Want het is nu één lange lijst geworden, wat niet echt meer overzichtelijk
wordt."* · na opties A/B/C de vierde: CharacterScape (*"Well, character forever"*) · keuze: *"Ik ga toch voor d"* ·
*"Vooral de eerste paar die we nu standaard hebben, vind ik super gaaf. Dat moet ik zeker houden."* · op het plan
met schakelaar: *"Ja"*.
**Wat D is:** het HELE Forever-overzicht in CharacterScape-stijl (alleen het idee; CharacterScape = map
`_forever_\Interface\AddOns\CharacterForever`, v0.16.25, Amir Ahmadi, GEMETEN geen licentie → geen code). Tabbladen als
hoge knoppen RECHTS, paginanaam gecentreerd bovenaan, portret links blijft, inhoud van Now/Class ongewijzigd.
Midnight NIET aanraken. Schetsen: `C:\Users\RobHu\AppData\Local\Temp\claude\find_mockups\` (A/B/C/D, D_now, D_class,
D_find; Rob zag D_* in zijn Drive). Lay-out: geen Fable.
**Maten (GEMETEN in code):** oud 920×520, inhoud 700. Nieuw 1100×600 (niet CharacterScape's 1040: dan zou het
middenstuk smaller worden), `RIGHT_PAD` 188, inhoud 708, tab 160×40 stap 46, subtab 142×26 stap 30 ingesprongen 18.
**Plan (4 stappen, commit + push per stap, lint als laatste, TESTLIJST/NEXT_SESSION/SITE_SEIN mee):**
1. ✅ GEBOUWD 0ff9d9d — venster + tabkolom + subtabs + gear-groep onderaan + paginanaam + schaal-past-bij-openen +
   schakelaar. NIET in het spel gezien; Rob test thuis (TESTLIJST "nieuw overzicht, stap 1").
2. Pagina's nalopen op afgekapte tekst / overlap (12 pagina's; de 7 met een oude subrij kregen 30 px). PAS met Robs
   screenshots van stap 1.
3. ✅ GEBOUWD (zie hierboven). Was: Find "What am I looking for? | Which city?" (zie D_find.png / C.png): links eigen hoofdsteden +
   neutrale steden (Booty Bay, Gadgetzan, Everlook, Valanaar, Dalaran alleen A; Ratchet ontbreekt in onze data →
   eerst meten), doel = de herberg uit `ForeverCitySpots` (14 herbergen, GEMETEN), rechts de diensten van die stad
   (filter `ns.FOREVER_CITY_SPOTS` op map: inn/bank/auction/mail/flight + transport + je class-trainer), knop
   "Route to X" + routezin (`ns.ForeverTravelSentence`, kent nu Hearthstone/teleports + "(about N min)"), plus een
   zoekveld. MH onthoudt de laatst gekozen knop (geen schakelaar nodig). Find-code: `ForeverOverview.lua`
   `FindCatalog`/`FillFindPage`/`FindPlaces`, data via `ns.ForeverVendorFindRows`.
4. Afwerken: TESTLIJST, SITE_SEIN, en ~1 week na Robs ja het oude pad weghalen.
**Schakelaar:** `FOV_LAYOUT_SW` in Quiet helpers, db `ns.db.foreverOldLayout` (nil = nieuw, standaard), werkt na
/reload (`ns.IsForeverNewLayout`, `ns.SetForeverNewLayout`). Code: `NEW_LAYOUT`/`RIGHT_PAD`/`VTAB_*` bovenaan
`ForeverOverview.lua`, `RelayoutTabs` vóór `ns.ForeverOverviewFill`.
**Risico's om na te lopen:** Shift+scroll-schaal (DialogPopup AttachScaling vs. onze OnShow-verlaging: volgorde niet
gemeten), opgeslagen positie, kleine schermen (UI-hoogte 768), Characters met 4 subtabs (~442 px in ~490), knoppen
elders die `ns.ShowForeverFind` e.d. aanroepen.


## 📌 Ouder, maar nog niet af — staat in `docs/NEXT_SESSION_ARCHIVE.md`

De historie is afgesplitst (2 sep en 6 nov). Deze secties lezen daar nog als OPEN, dus ze
staan hier bij naam — een openstaand punt mag niet verdwijnen door oud te zijn.

⚠️ Bewust te ruim: de lijst kijkt alleen naar de kop. Is een punt af, zet een stukje van de
kop met de reden in `KNOWN_DONE` in `tools/split_handoff.py` en draai
`python "<repo>/tools/_probe.py" run split_handoff --reindex --write`. Niet met de hand
bewerken: dan loopt de lijst binnen een week uit de pas met het archief.

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
