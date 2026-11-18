# dg_check2 — onafhankelijke controle bazengids WoW Forever (18 nov 2026)

Gecontroleerd: `Modules/ForeverDungeonGuide.lua`, `Modules/ForeverDungeonGuideData.lua`, de 205 FDG_*-sleutels in
enUS, nlNL en de zes ForeverClassQuests-packs (+ esMX-overlay), en de knop in `ForeverOverview.lua`.
Repo niet aangeraakt. Niets in `docs/` gelezen.

**Telling: 9 FOUT, 11 RISICO, de rest OK.** Fix-bestanden: `dg_fix_enUS.txt` (9 regels), `dg_fix_nlNL.txt` (8),
`dg_fix_deDE.txt` (11), `dg_fix_frFR.txt` (10), `dg_fix_esES.txt` (11), `dg_fix_esMX.txt` (7, voor de overlay),
`dg_fix_ptBR.txt` (10), `dg_fix_ruRU.txt` (10). Alle 76 regels getest op het formaat `\tFDG_KEY = "...",`.
Na het plakken: `check_drift.py` zal WC_7_T als gedrift zien in de packs; de betekenis is gelijk gebleven, dus `--mark`.

## Bronnen (alle gelezen 18 nov 2026)

- **DB2** GEMETEN: wago.tools build 1.60.1.70959, `DungeonEncounter` (7 locales, elk 376 rijen; positieve controle
  2732 = Oggleflint, map 389) en `GlobalStrings` (7 locales, elk 27402 rijen). Script: `scratch dg2_verify.py`,
  `scratch dg2_loc.py`; uitvoer `dg2_verify_out.txt`, `dg2_loc_out.txt`.
- **Wowhead Forever tooltips** GEMETEN: alle 27 items en alle boss-npc's, enUS + 6 locales (ook item-tooltips per taal:
  slotwoord, Equip-regel, "Dropped by").
- **Gidsen** (via Exa): Icy Veins Forever (Neryssa; RFC/WC/SFK/Stockade/BFD/RoL/Thanes bijgewerkt 19 okt 2026,
  Deadmines/Excavation 18 okt 2026), Mobalytics (Thanes 12 nov, RFC 12 nov, WC 14 nov, DM 12 nov, RoL 13 okt 2026),
  Warcraft Tavern (Thanes, RoL; geen datum), GameSpot (RoL 3 nov, Excavation 2 nov 2026), raidforever RoL (5 okt),
  wowfdb (Thanes/RoL/Excavation; geen datum), Method (Excavation/DM/RFC; geen datum), conquestcapped (Excavation 14 okt,
  DM 24 okt), Wowhead-gidsen (RFC 26 okt, Excavation 1 okt), apocanow (Thanes 13 nov), wowforeverguides (verzamelsite).

## FOUT (moet veranderen)

1. **LORD_6_D2 "Fire pulses around him"** — Icy Veins: "an AOE effect around him that hurts melee"; Mobalytics:
   "PULSATING AOE damage around himself". Geen van beide zegt vuur (GEMETEN). "Fire" is AFGELEID. Fix in alle 8 talen:
   "Damage pulses around him and hurts melee."
2. **Zes items heten "one-hand", maar zijn Main Hand** (GEMETEN Wowhead Forever tooltip + GlobalStrings
   INVTYPE_WEAPONMAINHAND): Trogg Scepter (RFC_L1), Cursed Felblade (RFC_L3), Durgen's Crescent Axe (THANES_L3),
   Scepter of the Abandoned (LORD_L2), Debt Collector (STOCKS_L1), Hamhock's Cleaver (STOCKS_L2). Een Main Hand-wapen
   kan niet in de schildhand; "one-hand" belooft dat wel. Clientwoorden: Waffenhand / Main droite / Mano principal
   (esMX Mano derecha) / Mão principal / Правая рука. Fix in alle talen + esMX-overlay.
   (Cruel Barb en Meteor Shard zijn echt One-Hand: OK. Fang of Magmatus zegt alleen "dagger": OK.)
3. **WC_7_T bijna letterlijk Icy Veins** — IV: "If you do not need to be near his melee, stay at range"; wij: "If you
   do not have to be in melee, stay at range." Nieuwe Engelse zin, zelfde betekenis; vertalingen kunnen blijven.
4. **DM_5_T "Kill the Squallshaper with him first"** — alleen Icy Veins zegt dat. Mobalytics zegt crowd control op de
   Squallshaper; Method, conquestcapped en wow-forever.gg doden hem juist als laatste (GEMETEN). Eén bron, niet gemeld.
   Fix: "Crowd-control or kill the Squallshaper with him first" (IV + MOB samen), in alle talen.
5. **Drie bazen zonder `names`** → op een de/fr/es/pt/ru-client Engels. Data-correctie (Wowhead Forever npc-tooltip per
   locale, GEMETEN; geen DB2-encounter voor deze drie):
   - regel 182 Deviate Faerie Dragon (5912): `names = { deDE = "Deviatfeendrache", frFR = "Dragon féérique déviant",
     esES = "Dragón férico descarriado", esMX = "Dragón feérico descarriado", ptBR = "Dragoleta Anormal",
     ruRU = "Загадочный волшебный дракон" },`
   - regel 301 Deathsworn Captain (3872): `names = { deDE = "Todeshöriger Captain", frFR = "Capitaine Ligemort",
     esES = "Capitán Juramorte", esMX = "Capitán Juramorte", ptBR = "Capitão Devoto da Morte",
     ruRU = "Капитан служителей Смерти" },`
   - regel 345 Bruegal Ironknuckle (1720): `names = { deDE = "Bruegal Eisenfaust", frFR = "Bruegal Ironknuckle",
     esES = "Bruegal Nudoferro", esMX = "Bruegal Nudoferro", ptBR = "Bruegal Ferroque",
     ruRU = "Бругал Железный Кулак" },`
   Let op (AFGELEID): voor klassieke npc's kan Wowhead nog Classic-namen hebben (zie RISICO 2). Beter dan Engels.
6. **The Baron, regel 96: esMX ontbreekt** → esMX-client toont "The Baron". Wowhead esMX (GEMETEN): "El barón".
   Toevoegen `esMX = "El barón"`. (Regel 57 Magmatus mist esMX ook; terugval "Magmatus" = Wowhead esMX, dus geen zichtbaar
   verschil. Voor de volledigheid `esMX = "Magmatus"` toevoegen.)
7. **SFK_L3 (trinket)**: deDE "Schmuckstück" ≠ client "Schmuck"; esES "abalorio" is het esMX-woord, esES-client zegt
   "Alhaja" (GEMETEN GlobalStrings INVTYPE_TRINKET + item 273643-tooltip per taal). Fix deDE + esES; esMX-overlay krijgt
   "abalorio".
8. **WC_8_D1 en WC_8_T: de naam "Disciple of Naralex" is weggevallen** in de/fr/es/pt/ru ("den NPC", "le PNJ",
   "al PNJ", "o NPC", "союзного персонажа"). Dan weet de speler niet wie hij moet begeleiden. Clientnamen (Wowhead npc
   3678, GEMETEN): Jünger von Naralex / Disciple de Naralex / Discípulo de Naralex (esMX gelijk) / Discípulo de Naralex /
   Послушник Наралекса. Fix in 5 talen (nlNL heeft de Engelse naam al: OK).
9. **Code, `ForeverDungeonGuide.lua` regel 109**: wie Sneed's Shredder (642, `extraNpc`) target, krijgt de gids wel op
   Deadmines (regel 288 kijkt naar extraNpc), maar Sneed wordt niet groen gemarkeerd (regel 109 kijkt alleen naar
   `b.npc`). Fix: `local here = targetNpc and (targetNpc == b.npc or targetNpc == b.extraNpc)`.

## RISICO (beslissen of later meten)

1. **Plunder (regel 63): andere naam dan wat de target frame waarschijnlijk toont.** DB2-encounter 3494 (GEMETEN):
   deDE Plünderung, frFR Pillage, esES Saqueo, ptBR Butim. Wowhead-npc 261311 én de "Dropped by"-regel van
   Golemguard Chest per taal (GEMETEN): deDE Schleppweg, frFR Pilleur, esES Pillaje, ptBR Pilhar (esMX Saqueador en
   ruRU Крад zijn gelijk). Bij Magmatus en The Baron koos de data juist de npc-naam boven DB2; hier niet. Consistent
   zou zijn: `deDE = "Schleppweg", frFR = "Pilleur", esES = "Pillaje", ptBR = "Pilhar"` + een MEASURE-notitie. Wat de
   client echt toont is niet gemeten (Rob speelt enUS).
2. **Klassieke bazen: DB2 en Wowhead verschillen per taal** (GEMETEN), bv. deDE Kapitän Grünhaut/"Captain Greenskin",
   Handlanger Pein/"Mr. Smite", Krümel/"Cookie", Rotkralle/"Rethilgore", Baron Silberlein/"Baron Silverlaine",
   Kommandant Grüntal/"Kommandant Springvale", Kam Tiefenzorn/"Kam Deepfury", Alter Serra'kis/"Old Serra'kis";
   frFR M. Châtiment/"M. Smite", Rethiltripe, Printeval, Furie-du-fond; esES Verdetez/"Verdepel", Don Mamporro/"Sr.
   Golpin", Cocinitas/"El Chef", "Odo el Cegato", "Dextren Tutor"; ruRU Леди/"Повелительница Анакондра", Вечноживущий/
   "Бессмертный", Сильверлейн/"Сребролен", Спрингвейл/"Ручьедол". Data volgt DB2 (de regel zegt: Blizzard-data). AFGELEID:
   Wowhead Forever heeft hier waarschijnlijk de oude Classic-namen. Alleen een niet-Engelse client kan het beslissen.
3. **FDG_ONE_SOURCE staat onder de tip, voor de hele baas**, terwijl vaak maar één regel één bron heeft (bv. Verdan: alleen
   "Hits the tank very hard"). Leest als "deze tip komt uit één gids". Voorstel: "(one line here comes from one guide only)".
4. **EXCAV_4_D2 "stomps to slow everyone"**: het vertragen is Thunderclap, de stomp (War Stomp) verdooft (GEMETEN
   wowfdb/Method/captain-carry). Zelfde stijl als WC_4_D2 ("Stomps" voor Thunderclap). Klein; voorstel "slows everyone
   near it".
5. **Weggevallen helpernamen in vertalingen** (betekenis blijft door de context): THANES_2_D1/T Dark Iron Summoner →
   "Beschwörer/invocateur/…"; DM_1_T Defias Watchmen → "Wachen"; DM_2_D1 Shredder → "Maschine"; DM_5_T Squallshaper →
   "Zauberwirker"; DM_6_T/DM_8_* Blackguards → "Defias/бандиты"; WC_9_T Druids of the Fang → "Druiden"; DM_3_D2 ruRU zonder
   "Defias". Gemeten clientnamen liggen klaar in `dg2_loc_out.txt` (Wachmann der Defias, Lump der Defias, Wellenformer der
   Defias, enz.) als je ze wilt gebruiken.
6. **Alleen hoofdletters**: esES schrijft Agilidad/Fuerza/Intelecto/Espíritu/Aguante (client: kleine letter; dat zijn de
   esMX-vormen); ptBR "Poder Mágico" (client "Poder mágico"). Zelfde woord, niet gecorrigeerd.
7. **Oude kopregel**: `ForeverDungeonGuide.lua` regel 15 zegt "the nine new Forever dungeons are not in it"; de data heeft
   er drie (3065, 2999, 2998).
8. **Highland Horror npc 260808**: Wowhead zet hem in zone 11 (Wetlands) met level 28, de andere Excavation-bazen in
   16732. Targeten buiten de dungeon opent de gids op Excavation. Onschuldig.
9. **LORD_4_T** lijkt op wowforeverguides ("The waves leave little time to drink"); korte gewone zin, laten staan.
10. **Lange dungeonnamen** in knoppen van 170 px (de/fr) kunnen afgekapt worden. Niet gemeten.
11. **Niet zelf nagelezen** (ik vertrouw hier de bronnen in het src-commentaar): SFK_5_D2 (Odo sterker), SFK_8_D3
    (worgen-vloek), SFK_3_T (hybrids), BFD_4_D1 (plekken), Baron Aquanis (alle drie de regels), LORD_7 (MM-bron).

## OK (gemeten)

- **Nieuwe dungeons, alle 47 tekstregels (14 + 21 + 12) en hun 9 items nagelezen.** Hall of Thanes 4/4 bazen (IV + MOB + WT + wowfdb + apocanow):
  alles klopt; THANES_3_D2 "charge" staat in MOB + wowfdb (IV/WH noemen alleen knockback), dus 2 bronnen: OK.
  Ruins of Lordaeron 7/7 (IV + MOB + GameSpot + raidforever + wowfdb): alles klopt behalve LORD_6_D2 (FOUT 1).
  Excavation Site 4/4 (IV + GameSpot + Method + wowfdb + conquestcapped): klopt. EXCAV_1_T "out of melee range" = IV;
  andere gidsen zeggen 10 meter (Dust Storm), geen fout.
- **Klassieke dungeons**: RFC 4/4, WC 9/9, DM 8/8, SFK 9/9, Stockade 6/6, BFD 7/8 tegen Icy Veins nagelezen, plus MOB voor
  RFC, WC en DM. Alleen WC_7_T en DM_5_T fout (zie boven).
- **Items: 27/27** — id, naam, "Dropped by <die baas>" en stats kloppen (Wowhead Forever tooltip). Rollen passen bij de
  stats, op de zes slot-woorden na (FOUT 2).
- **Namen: 55 bazen met encounter** tegen DB2 in 7 locales: alles gelijk, behalve de drie bekende (Magmatus/Infurnus,
  The Baron/The Butcher, Gelihast/Geilhast; bewust, staat in het commentaar).
- **Vertalingen**: alle 205 sleutels in elke taal aanwezig, geen dubbele, %s klopt. Aanspreekvorm klopt (du, tu, tú,
  você, вы). Gemeten clientwoorden kloppen: Zaubermacht / puissance des sorts / poder con hechizos / Poder Mágico / к силе
  заклинаний; Schildhand / main gauche / mano izquierda (de esES-tooltip van dit item zegt zelf "Sostener con la mano
  izquierda") / mão secundária / левая рука; Bijou / Berloque / Аксессуар. "Heilung/soins/sanación/cura/исцеление" en
  deDE "+Trefferchance" staan zo in de item-tooltips van die client (GEMETEN), dus OK.
- **Code**: elke tekst via `ns:L`, alle 205 gebruikte sleutels bestaan; item nog niet geladen → "#id" + verzoek, en
  GET_ITEM_INFO_RECEIVED vult opnieuw; target via UnitGUID met `issecretvalue`-check; knop alleen bij een dungeon met
  data (`ForeverDungeonHasGuide(d.instance)`, instance-id); Escape via UISpecialFrames en Shift+scroll via
  `RegisterMidnightDialogPopup` (frame heeft een naam); `/mh bosses` en `/mh bosses check` bestaan (Core.lua 2717).
