# Role Academy: feiten ronde 5 (7 okt 2026)

Uitzoekwerk voor de open punten uit `ROLE_SWITCH_REREAD4_NEWCOMER_2026-10-07.md` (T1, T4, T8, H1, B: Shield Block).
Ik heb alleen gelezen en geen addon-bestanden aangeraakt. Uit `docs/` las ik alleen REREAD4 en FACTS4. Dat mocht volgens de opdracht.

## Bronnen

- **wago.tools DB2 + GlobalStrings, build `12.1.0.69933`.** GEMETEN op 7 okt via `/api/builds`: dit is nog steeds de nieuwste `wow`-build (22 sep 2026).
- **Blizzard UI-code:** Gethe/wow-ui-source, commit `09b9db7` met de naam "12.1.0 (69933)" (22 sep 2026). Dat is dezelfde build.
- **Kandidaat, niet de client:** Icy Veins Prot Warrior rotatie (bijgewerkt 18 aug 2026), Method Prot Warrior (11 aug 2026), Icy
  Veins Holy Paladin stats (10 aug 2026), Icy Veins Mistweaver stats (3 sep 2026), warcraft.wiki.gg- en Wowhead-itempagina's
  (gelezen 7 okt), en de lokale addons Zygor (quest- en NPC-ID's) en HandyNotes_Midnight (rare-drops).

---

## 1. Waar haalt een DPS-paladin of -warrior een schild?

**Kort antwoord (AFGELEID uit de metingen hieronder):**
- **Op level 90:** ga naar het Auction House, kies **Armor → Miscellaneous → Shield** en koop een schild met Strength,
  bijvoorbeeld *Blood-Tempered Bulwark*.
- Koop er ook een **eenhandig wapen met Strength** bij. Ret en Arms dragen een tweehander, en die kan niet naast een schild.
- **Onder level 90** is er geen Midnight-schild te koop dat je al kunt dragen: alle Midnight-schilden die je kunt doorverkopen
  (BoE) vragen level 90.
- Dan is de route: zet je **Loot Specialization** op Protection (rechtsklik op je portret) en doe dungeons of de campagne.

| Bewering | Status | Bron |
|---|---|---|
| ItemSparse heeft 60 Midnight-schilden (InventoryType 14, ExpansionID 11). 46 daarvan hebben stats, 14 zijn ilvl-1-plaatsvervangers. | GEMETEN | wago ItemSparse 69933 |
| De BoE-schilden (Bonding 2) met stats: Blood-Tempered Bulwark 237920 (blauw), Thalassian Competitor's Bulwark 237912 (groen), Tarnished Dawnlit Defender 258961 (groen), Cragtender Bulwark 250446 (epic). **Alle vier: RequiredLevel 90.** | GEMETEN | ItemSparse |
| Gemaakt met Blacksmithing (CraftingData + recept in SkillLineAbility, skill 164): Blood-Tempered Bulwark (recept 1229626), Thalassian Competitor's Bulwark (1229634), Spellbreaker's Rebuke (1229665, BoP), Knight-Commander's Palisade (1230767, BoP). | GEMETEN | CraftingData, SpellName, SkillLineAbility |
| Blood-Tempered Bulwark = Midnight Blacksmithing (25), recept van de trainer. Trainer Bemarrin = NPC 241450, Silvermoon City (map 2393) 43.66,51.78. Alleen nuttig voor blacksmiths. | kandidaat | warcraft.wiki.gg; Zygor `NPCData.lua:8715` |
| Tarnished Dawnlit Defender valt als willekeurige drop van gewone vijanden op level 90 (0,2-0,4%). Voor een beginner dus alleen via het AH. | kandidaat | Wowhead |
| AH-pad: categorie Armor (`AUCTION_CATEGORY_ARMOR`) → subcategorie Generic (= "Miscellaneous") → subklasse Shield. | GEMETEN | `Blizzard_AuctionData.lua:61-99` |
| Namen per taal: zie de tabel hieronder. Of het AH "Shield" of "Shields" toont: **niet gemeten**. | GEMETEN (namen) | ItemSubClass, GlobalStrings |
| Dungeon-drops (normale versie geschaald op 80-90): Magisters' Terrace, Seranel Sunlash → Ward of the Spellbreaker 251105 · Den of Nalorakk, Sentinel of Winter → Tempest's Shelter 251150 · The Blinding Vale, Ziekket → Teldrassil's Sacrifice 251196 · Nexus-Point Xenas, Chief Corewright Kasreth → Reflux Reflector 251202. | GEMETEN | JournalEncounterItem, JournalEncounter, LFGDungeons, ContentTuning (3026/3906/4442/5143: 80-90) |
| Andere bronnen: raid The Voidspire (Imperator Averzian), raid March on Quel'Danas (Belo'ren), Season 2-dungeons The Venomous Abyss (The Lost Explorers) en The Tidebound Grotto (Nymrissa Wavecaller), Algeth'ar Academy (Crawth). | GEMETEN | idem |
| In het rechtsklikmenu van je eigen portret staat "Loot Specialization" (`SELECT_LOOT_SPECIALIZATION`). | GEMETEN | `UnitPopupMenus.lua` (SELF), `UnitPopupSharedButtonMixins.lua:1793-1819` |
| Dat je met Loot Specialization Protection een schild kunt krijgen terwijl je DPS speelt. | AFGELEID | Wowhead: *"Players can win this item when selecting: Paladin, Warrior, Shaman"* |
| Questbeloningen: Protector's Discarded Shield 248077 komt uit *[80-83] The Traitors of Tranquillien* (quest 90509, Arator, Eversong Woods 47.69,69.69). Voidformed Protector 264432 komt uit *[88-90] The Wicked End* (quest 90924, Voidstorm 47.28,49.15). | kandidaat | warcraft.wiki.gg; Zygor `ZygorLevelingCommonMID.lua:776, 11751` |
| ⚠️ QuestPackageItem heeft voor **geen enkel** van de 46 schilden een rij. Positieve controle: item 80686 werd wél gevonden. **Toch zijn het questbeloningen.** Het lege DB2-resultaat bewees dus niets. Of een Ret-paladin als beloning het schild aangeboden krijgt: **niet gemeten**. | GEMETEN (het lege resultaat) | QuestPackageItem |
| Rares: Warden of Weeds (246332, Eversong Woods 51.92,73.80) → Steelbark Bulwark 264613 · Annulus the Worldshaker (250358, Harandar 44.20,16.58) → Fungal Cap Guard 264614 · Blackcore (248823, Voidstorm 24.80,67.80) → "Repurposed Voidwalker's Chestplate" 264519. Dat laatste is ondanks de naam een schild (InventoryType 14). Alle drie hebben item level 80 en de drop is niet zeker (Wowhead: Fungal Cap Guard 35,69%). | kandidaat (drops), GEMETEN (ilvl) | HandyNotes_Midnight, Wowhead, ItemSparse |
| Een verkoper in Silvermoon die schilden verkoopt: **niet gevonden en niet te meten** (verkooplijsten staan niet in DB2). | — | — |

**Stats op schilden: let op.** In ItemSparse heeft de eerste stat van alle 46 schilden code 4 (Strength).
Wowhead en warcraft.wiki.gg tonen op dezelfde schilden **Strength én Intellect** (Blood-Tempered Bulwark: +27 Strength,
+84 Intellect). De Intellect komt dus ergens anders vandaan dan ItemSparse. Schrijf daarom **niet** "een schild heeft
alleen Strength".
Positieve controle op de statcodes, GEMETEN op 20 Midnight-rijen (18 borststukken, 2 bogen): plate = 74 (Strength of
Intellect, 7 van 7), cloth = 5, leather/mail = 73, boog = 3.

| Tag / veld | enUS | deDE | frFR | esES | ptBR | itIT |
|---|---|---|---|---|---|---|
| AUCTION_CATEGORY_ARMOR | Armor | Rüstung | Armure | Armadura | Armadura | Armature |
| ItemSubClass 4/0 | Miscellaneous | Verschiedenes | Divers | Miscelánea | Diversos | Varie |
| ItemSubClass 4/6 (kort / lang) | Shield / Shields | Schild / Schilde | Bouclier / Boucliers | Escudo / Escudos | Escudo / Escudos | Scudo / Scudi |
| SELECT_LOOT_SPECIALIZATION | Loot Specialization | Beutespezialisierung | Spécialisation du butin | Especialización de botín | Especialização de saque | Specializzazione per il bottino |

---

## 2. Zie je op een tooltip of de hoofdstat bij je spec hoort?

- **Niet te meten in de UI-code. GEMETEN dat het daar níét staat:**
  - `TooltipDataRules.lua` (69933) geeft stats geen eigen kleur. De kleur komt kant-en-klaar van de client
    (`lineData.leftColor`).
  - `Enum.TooltipDataLineType` heeft geen regeltype voor stats. Er is wel `DisabledLine = 42`, maar of de client dat
    gebruikt voor een inactieve stat, is niet te zien.
- **GlobalStrings (GEMETEN):**
  - `ITEM_MOD_STRENGTH` = "%c%s Strength", `ITEM_MOD_INTELLECT` = "%c%s Intellect", `ITEM_MOD_AGILITY` = "%c%s Agility".
    Er zit geen kleur in.
  - Ook deze bestaan: `ITEM_MOD_STRENGTH_OR_INTELLECT_SHORT` = "Strength or Intellect", `…AGILITY_OR_INTELLECT_SHORT`,
    `…AGILITY_OR_STRENGTH_SHORT`, `…AGILITY_OR_STRENGTH_OR_INTELLECT_SHORT`.
  - Er is **geen** string voor "deze stat telt niet". Positieve controle: de zoekopdracht vond andere teksten wel, zoals
    "Inactive" 24 keer en "specialization does not" 1 keer.
- **Grijs = telt niet:** alleen oude bronnen (de WoD-patchnotes uit FACTS4, Blizzard-forum 2019/2020, MMO-Champion).
  **Na 18 aug 2026 vond ik geen bron.** Status: AFGELEID. Laat Rob één tooltip bekijken (plate-item of schild in de tas).
- **Wel gemeten, en dit helpt de les:**
  - Midnight-plate heeft statcode 74 (Strength of Intellect). Plate past dus altijd bij een paladin of warrior.
  - Ringen hebben geen hoofdstat: op pagina 1 had 25 van de 25 Midnight-ringen statveld -1.
  - De controle "klopt de stat?" is dus vooral nodig bij wapen, schild/off-hand en trinkets. Dat is AFGELEID.
  - Voor de Ret/Holy-wissel: zie punt 5.

---

## 3. Lay on Hands vlak na Divine Shield

**Antwoord: op jezelf werkt het niet.** Lay on Hands op iemand anders werkt wel, zolang die geen Forbearance heeft.

| Spreuk | Tekst in 12.1 (Spell.Description) | Controle (SpellAuraRestrictions) |
|---|---|---|
| Lay on Hands 633 | *"Cannot be used on a target with Forbearance. Causes Forbearance for 30 sec."* | ExcludeTargetAuraSpell 61988 |
| Divine Shield 642 | *"Cannot be used if you have Forbearance. Causes Forbearance."* | ExcludeCasterAuraSpell 61988 |
| Blessing of Protection 1022 | net als Lay on Hands | ExcludeTargetAuraSpell 61988 |
| Blessing of Spellwarding 204018 | net als Lay on Hands | ExcludeTargetAuraSpell 61988 |

- **Forbearance 25771 duurt 30 s.** GEMETEN: SpellMisc DurationIndex 9 → SpellDuration 30000 ms.
  - De debufftekst: *"Cannot be affected by Divine Shield, Blessing of Protection, or Lay on Hands"*.
  - Met het talent Light's Revocation valt "Divine Shield" uit die tekst.
- **De controle loopt via 61988, niet via 25771.** GEMETEN:
  - 25771 staat in geen enkele kolom van SpellAuraRestrictions. Positieve controle: 61988 gaf 7 + 6 rijen.
  - 61988 heeft geen SpellName-rij.
  - Dat het een verborgen markering is die samen met Forbearance wordt gezet: AFGELEID.
- **Talenten (GEMETEN, Paladin-boom 790 = SkillLine 800 "Paladin"):**
  - **Light's Revocation** 146956 (node 81608): *"Divine Shield may now be cast while Forbearance is active."*
    Alleen Divine Shield gaat dus door Forbearance heen, Lay on Hands niet.
  - **Holy Reprieve** 469445 (node 103860): Forbearance duurt 10 s korter (effectwaarde -10000 ms).
  - Geen enkel talent laat Lay on Hands door Forbearance heen. GEMETEN: de 18 spelteksten met "Forbearance" zeggen dat
    nergens. Absolute Aegis 469447 heeft dezelfde Divine Shield-tekst, maar geen TraitDefinition.
- **Gevolg voor de MH-tekst (AFGELEID):**
  - `GROUP_NOTE_LOH` noemt alleen Blessing of Protection.
  - Juist is: *"werkt niet als diegene Forbearance heeft: na Divine Shield, Blessing of Protection of Spellwarding (30 s)"*.
  - Op *Blijf leven*: wie Divine Shield drukt, kan daarna 30 s zichzelf geen Lay on Hands geven.

---

## 4. Group Finder als je niet de leider bent

**GEMETEN in de UI-code 69933:**
- **Wat je ziet als de leider in de wachtrij zet:**
  - Het venster `LFDRoleCheckPopup` gaat open (`LFDFrame.lua:53-59`).
  - Bovenaan staat `CONFIRM_YOUR_ROLE`, daaronder `QUEUED_FOR` met de naam van de dungeon.
  - Je ziet **drie rol-icoontjes met elk een vinkje** (Tank/Healer/Damage) en de knoppen **Accept** en **Decline**.
- **Accept** blijft grijs tot je minstens één rol aanvinkt (`:927-938`, tooltip `INSTANCE_ROLE_WARNING_TITLE`).
  Bij Accept slaat het spel je rollen op (`SetLFGRoles`) en bevestigt het (`:887-903`).
- **Al ingevuld:** de vinkjes komen uit `GetLFGRoles()`, dus uit wat je het laatst in de Dungeon Finder aanvinkte
  (`LFGFrame.lua:476-477, 484-489`).
- **Vooraf instellen kan:**
  - Ook als niet-leider vink je zelf in Group Finder → Dungeon Finder het Tank-icoontje aan.
  - `LFG_UpdateRolesChangeable` zet de rolknoppen alleen uit tijdens wachtrij, rolecheck of voorstel, niet voor
    niet-leiders (`LFGFrame.lua:500-509`). Alleen het Leader-vinkje zit vast als je geen leider bent (`:458-463`).
  - Klikken slaat de keuze meteen op: `LFDFrameRoleCheckButton_OnClick` → `LFDQueueFrame_SetRoles` → `SetLFGRoles`
    (`LFDFrame.lua:135-151`).
- **Rechtsklik op je portret → "Set Role" bestaat**, met daaronder Tank / Healer / Damage / No Role
  (`UnitPopupMenus.lua:23`, `UnitPopupSharedButtonMixins.lua:3448-3571`).
  - Je ziet hem alleen in een groep, buiten een scenario, zonder LFG-beperking (dus meestal niet ín een Group
    Finder-groep), en op jezelf of als je leider/assistent bent.
  - Hij zet je **groepsrol** (`UnitSetRoleEnum`): het icoontje op de groepsframes.
  - **Hij vult de Dungeon Finder-rolvraag niet in.** Die leest `GetLFGRoles` (AFGELEID uit de code: dit zijn twee aparte
    instellingen).
  - Voor de les: kies je rol in de Dungeon Finder of in de popup, niet via "Set Role".
- **Niet verwarren:** als de leider een Role Check doet (`ROLE_POLL_BEGIN`), komt er een ander venster,
  `SELECT_YOUR_ROLE` + Accept (`RolePoll.xml`, `RolePoll.lua`). Dat zet de groepsrol, niet de wachtrij.

| Tag | enUS | deDE | frFR | esES | ptBR | itIT |
|---|---|---|---|---|---|---|
| CONFIRM_YOUR_ROLE | Confirm your role: | Rolle bestätigen: | Confirmez votre rôle : | Confirma tu función: | Confirme sua função: | Conferma il tuo ruolo: |
| QUEUED_FOR | Queued for %s | In Warteschlange für '%s' | En file d'attente pour %s | En cola para %s | Na fila para %s | In coda per %s |
| ACCEPT | Accept | Annehmen | Accepter | Aceptar | Aceitar | Accetta |
| DECLINE | Decline | Ablehnen | Refuser | Rechazar | Rejeitar | Declina |
| SET_ROLE | Set Role | Rolle wählen | Définir le rôle | Establecer función | Definir função | Imposta ruolo |
| NO_ROLE | No Role | Keine Rolle | Aucun rôle | Sin función | Sem função | Nessun ruolo |
| SELECT_YOUR_ROLE | Select Your Role | Wählt Eure Rolle | Choisissez votre rôle | Elige tu función | Selecione sua função | Scegli il tuo ruolo: |
| ROLE_POLL | Role Check | Rollenabfrage | Vérification des rôles | Eligiendo función | Função OK? | Controllo del ruolo |
| LFG_ROLE_CHECK_ROLE_CHOSEN (chat) | %s has chosen: %s | %s hat gewählt: %s | %s a choisi : %s | %s ha elegido: %s | %s escolheu: %s | %s ha scelto: %s |

Tank/Healer/Damage (`TANK`, `HEALER`, `DAMAGER`) staan al in FACTS4 §3.

---

## 5. Heal-gear: hoofdstat per healerspec

- **"Primary Stat" op het spec-tabblad:** zie FACTS4 §4. De UI-code is ongewijzigd: `C_SpecializationInfo.GetSpecializationInfo`
  → `SPEC_FRAME_PRIMARY_STAT`, `Blizzard_ClassSpecializationsFrame.lua:333-349`.
- **DB2 ChrSpecialization.PrimaryStatPriority (GEMETEN):**
  - Holy Priest, Discipline, Resto Druid, Resto Shaman, Mistweaver en Preservation = **0**. Dat is dezelfde waarde als
    Mage, Warlock, Shadow, Elemental, Balance en Devastation.
  - Holy Paladin = **1**.
  - Strength-specs (Prot/Ret, alle Warriors, DK) = 5. Agility-specs = 2 of 3.
  - Dat 0 en 1 "Intellect" betekenen: AFGELEID.
- **Gidsen (kandidaat):** Icy Veins Mistweaver 12.1 (3 sep 2026) zegt *"Intellect is your primary stat"*. Icy Veins Holy
  Paladin 12.1 (10 aug 2026) spreekt over Intellect.
  → **Intellect voor alle 7 healerspecs:** AFGELEID, met de gidsen erbij.
- **Heeft een paladin nieuwe spullen nodig voor Holy? (H1)**
  - Midnight-plate heeft statcode 74 (Strength of Intellect). GEMETEN op 7 van 7 plate-borststukken.
  - Dezelfde plate geeft dus Intellect in Holy. AFGELEID.
  - Ringen hebben geen hoofdstat. GEMETEN.
  - Wat wél moet wisselen: het **wapen**, want een Ret-tweehander met Strength geeft geen Intellect. Ook een off-hand of
    schild met Intellect, en trinkets. AFGELEID.
  - Kortom: geen hele nieuwe set, wel een Intellect-wapen.

---

## 6. Warrior Shield Block (2565): "bijna altijd aan houden"?

- **DB2 (GEMETEN):**
  - Kost 30 Rage (SpellPower 300, PowerType 1) en zit niet op de global cooldown (StartRecoveryTime 0).
  - Het buff 132404 duurt 6 s (DurationIndex 32 = 6000 ms).
  - Basiscategorie 1385: 1 lading, 16 s oplaadtijd.
  - Tekst: *"blocking all melee attacks against you for 6 sec"* + extra Shield Slam-schade.
  - Icy Veins noemt **2 ladingen**. Dat komt vermoedelijk van een Prot-passive; **niet gemeten**.
- **Gidsen (kandidaat):**
  - **Icy Veins Prot War 12.1** (bijgewerkt 18 aug 2026) noemt hem je belangrijkste active mitigation: *"keeping Shield
    Block up as much as possible"* zolang je tankt. De FAQ voegt toe: het telt als vijanden je echt met melee slaan
    (*effective uptime*), niet als hij maar aan staat.
  - **Method Prot War 12.1** (11 aug 2026, dus vóór Season 2): *"Keep Shield Block up while you are actively tanking"*.
    Laat je Rage niet leeglopen. In de rotatie: Shield Block als hij niet actief is of als je ladingen vol dreigen te raken.
- **Oordeel (AFGELEID):** "Houd Shield Block aan zolang vijanden je slaan" is goed beginnersadvies. Het past bij de
  Shield of the Righteous-zin uit FACTS4 §9.
  - Twee kanttekeningen: hij blokt alleen melee (en sommige baas-aanvallen).
  - Zonder Rage kun je hem niet drukken.

---

## Wat NIET gemeten is

- In-game tooltips: of een inactieve stat grijs is, of de rolvraag er zo uitziet, en welke AH-subcategorienaam je ziet.
- Of een Ret-paladin bij *The Traitors of Tranquillien* het schild als beloning krijgt.
- Waar de Intellect op schilden en off-hands in de data zit (niet in ItemSparse).
- Of er een verkoper is die schilden verkoopt.
