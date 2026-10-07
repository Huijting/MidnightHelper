# Role Academy — feiten ronde 4 (7 okt 2026)

Onderzoek voor de Role Academy (tank/heal leren voor DPS'ers), punten 1-9 uit de opdracht.
Alleen lezen; geen addon-bestanden aangeraakt.

## Bronnen en builds

- **Live build = `12.1.0.69933`** (GEMETEN 7 okt via `wago.tools/api/builds`: product `wow`, aangemaakt 22 sep 2026).
  ⚠️ `12.1.5.70077` (de standaard op wago-pagina's) is **`wowxptr` = PTR**, niet live. Alle DB2-metingen hieronder
  zijn gedaan met `&build=12.1.0.69933`.
- **wago DB2** (SpellName, Spell, SpellMisc, SpellCastTimes, TraitDefinition, TraitNodeEntry, SkillLineAbility,
  SpecializationSpells, JournalEncounterSection, GlobalStrings) via het browservenster, build 12.1.0.69933.
- **Blizzard UI-code** (Gethe/wow-ui-source, branch `live`, commit "12.1.0 (69933)" van 22 sep 2026) = dezelfde build.
  Dit is de code die de knoppen en de chat aanstuurt.
- **Gidsen (kandidaat, niet de client):** Icy Veins 12.1 (Prot Pal bijgewerkt 21 aug 2026, changelog 21 sep; Prot War
  18 aug; Guardian/Blood/Brewmaster/Vengeance/Resto Druid 10 aug), Method 12.1 (Prot Pal 3 sep 2026, Vengeance
  27 aug 2026).
- ⚠️ Ik heb `docs/ROLE_SWITCH_REREAD3_…` en `ROLE_SWITCH_FACTS*` **niet gelezen** (mijn agentregel verbiedt lezen
  onder `docs/`). Overlap met eerdere rondes is dus mogelijk.

---

## 1. AoE-knoppen per tankspec

Kolom "DB2" = GEMETEN in build 69933 (naam in SpellName + talent in TraitDefinition of klasse-skill in
SkillLineAbility of spec-spell in SpecializationSpells). Kolom "raakt" = GEMETEN uit de spelltekst (Spell.Description).
Welke knoppen "de eerste van een pull" zijn = GEMETEN in de genoemde gids (dus gidsadvies, geen clientfeit).

| Spec | Knop | ID | DB2 | Raakt (spelltekst) | KeybindRoles |
|---|---|---|---|---|---|
| Prot Paladin 66 | Consecration | 26573 | skill 800 | grondvlak, iedereen die erin komt | `_Paladin.lua:152` id 26573 ✓ |
| | Avenger's Shield | 31935 | trait 107476 | doel + springt naar extra vijanden | `:133` id 31935 ✓ |
| | Blessed Hammer | 204019 | trait 107435 (vervangt Crusader Strike 35395) | spiraal, raakt vijanden rondom | `:135` id 204019 ✓ |
| | Hammer of the Righteous | **53595** | trait 107436 (vervangt 35395) | 1 doel; golf naar anderen **alleen in Consecration** | `:134` id **88263** ⚠️ |
| Prot Warrior 73 | Thunder Clap | 6343 | trait 117210 e.a. | alle vijanden binnen bereik | `_Warrior.lua:109` id 6343 ✓ |
| | Revenge | 6572 | trait 117157 (vervangt Slam 1464) | alle vijanden vóór je | `:130` id 6572 ✓ |
| | Shockwave (stun) | 46968 | trait 117247 | — | `:151` id 46968 ✓ |
| Guardian 104 | Thrash | 77758 | skill 798 | alle vijanden dichtbij + bloeding | `_Druid.lua:194` **geen `id`**, alleen survivalId 77758 ⚠️ |
| | Swipe | 213764 (beer: 213771) | trait 108306 | alle vijanden dichtbij | `:195` id 213764 ✓ |
| | Moonfire | 8921 | skill 798 | 1 doel (2e doel met talent) | `:126` id 8921 ✓ |
| Blood 250 | Death and Decay | 43265 | skill 796 | grondvlak | `_DeathKnight.lua:91` id 43265 ✓ (Shift+2) |
| | Blood Boil | 50842 | trait 101307 | alle vijanden binnen bereik + Blood Plague | `:90` id 50842 ✓ (Shift+1) |
| | (Heart Strike) | 206930 | trait 101306 (vervangt 316239) | doel + 1 extra (meer in DnD) | `:86` id 206930 ✓ |
| Brewmaster 268 | Keg Smash | 121253 | trait 106453 | doel + alle vijanden rondom | `_Monk.lua:98` **geen `id`**, alleen survivalId 121253 ⚠️ |
| | Breath of Fire | 115181 | trait 106466 | kegel vóór je | `:102` id 115181 ✓ (Shift+2) |
| | Spinning Crane Kick | **322729** (BrM) | SpecializationSpells 268: 322729 vervangt 101546 | alle vijanden binnen bereik | `:121` id 101546, bindKey Shift+2 |
| Vengeance 581 | Immolation Aura | 258920 | skill 1848 | vijanden rondom je | `_DemonHunter.lua:96` id 258920 ✓ |
| | Sigil of Flame | 204596 | trait 117859 + skill 1848 | iedereen in het sigil | `:121` id 204596 ✓ |
| | Spirit Bomb | 247454 | trait 117912 | vijanden dichtbij | `:125` id 247454 ✓ (Shift+4) |

**Advies "eerste knoppen van een pull" (GEMETEN in gids, datum erbij):**
- **Prot Paladin:** Consecration vooraf neerleggen, Blessed Hammer, dan Avenger's Shield (Icy Veins 12.1, 21 aug/21 sep;
  Method 3 sep: Consecration + Blessed Hammers vóór de pull, daarna Avenger's Shield). Divine Toll 375576
  (`:125`) gooit Avenger's Shield op meerdere doelen — wel een cooldown.
- **Prot Warrior:** Thunder Clap is de AoE-knop; Icy Veins (18 aug) zegt in dungeons bij nieuwe vijanden Thunder Clap
  (of anders Revenge) vóór Shield Slam te drukken om ze op te pakken.
- **Guardian:** Thrash op cooldown is regel 1 van AoE, Swipe/Moonfire als vulling (Icy Veins 10 aug).
- **Blood:** Death and Decay vooraf neerleggen, Blood Boil in de opener (Icy Veins 10 aug).
- **Brewmaster:** opener met Breath of Fire, Rushing Jade Wind (116847, `:103`), Keg Smash (Icy Veins 10 aug).
- **Vengeance:** Immolation Aura vooraf, Sigil of Flame vooraf neerleggen, Spirit Bomb als AoE-besteder (Method 27 aug).

**Beginnersselectie (AFGELEID uit bovenstaande):** Pal: Consecration · Avenger's Shield · Blessed Hammer. War: Thunder
Clap · Revenge. Guardian: Thrash · Swipe. Blood: Death and Decay · Blood Boil. Brew: Keg Smash · Breath of Fire.
Veng: Immolation Aura · Sigil of Flame · Spirit Bomb.

⚠️ Bijvangst KeybindRoles (AFGELEID, niet in-game getest):
- `_Paladin.lua:134` Hammer of the Righteous gebruikt **88263**. In build 69933 heeft 88263 geen talent of skill-rij; de
  spelltekst van 53595 noemt 88263 als de "golf"-component. De knop zelf is **53595**. Matchen op ID mist dus; de
  naam-fallback redt het alleen op een Engelse client.
- `_Druid.lua:194` (Thrash) en `_Monk.lua:98` (Keg Smash) hebben **geen `id`**, alleen `survivalId` → naam-only matching.
- `_Monk.lua:121` Spinning Crane Kick: Brewmaster krijgt 322729 (vervangt 101546). Of het spellboek 101546 of 322729
  meldt is niet gemeten. Ook: zowel Breath of Fire (`:102`) als Spinning Crane Kick (`:121`) vragen `bindKey = "Shift+2"`
  voor 268 — of de `blockAs` van SCK die bindKey opheft is niet nagekeken.

---

## 2. Blessing of Protection / Divine Shield op jezelf als tank

- **Tooltip (GEMETEN, Spell.Description, 69933):** BoP 1022 = immuun voor Physical schade en schadelijke effecten,
  Forbearance. Divine Shield 642 = immuun voor alle schade, schadelijke effecten, knockbacks. **Geen van beide tooltips
  zegt iets over aggro/threat**, en de spell-effecten bevatten geen threat-aura (GEMETEN: alleen immuniteit, dummy,
  schadereductie, snelheid).
- **Final Stand 204077 (GEMETEN, trait 107478 bestaat in 69933):** "During Divine Shield, all targets within 15 yds are
  taunted." De Divine Shield-tooltip toont met dat talent "Taunts all targets within 15 yd."
- **Aggro (GEMETEN in gidsen, na 18 aug):**
  - Method Prot Pal 12.1 (3 sep 2026): BoP én Divine Shield op jezelf laten je **aggro verliezen**; tegen één vijand
    los je dat op met Hand of Reckoning (62124), tegen meer met het talent Final Stand. Blessing of Spellwarding
    (204018) heeft dat aggro-nadeel volgens Method **niet**.
  - Icy Veins Prot Pal 12.1 (21 aug 2026): onder een immuniteit word je door vijanden genegeerd tot het effect voorbij
    is; Hand of Reckoning werkt ook tijdens een immuniteit.
- **Conclusie voor de les (AFGELEID):** "BoP/Divine Shield op jezelf = de vijanden lopen weg naar je groep, tenzij je
  Final Stand hebt of meteen taunt." Wat de client precies doet staat niet in DB2; het is engine-gedrag dat alleen de
  gidsen beschrijven.

---

## 3. Group Finder: rol kiezen, samen queuen, uitnodigen

**Rol kiezen vóór Find Group — GEMETEN (UI-code `LFDFrame.xml` / `LFDFrame.lua`, live 69933):**
- De Dungeon Finder heeft drie rolknoppen (rollen `TANK`, `HEALER`, `DAMAGER`). Elk is een **icoon met een vinkje**
  (`CheckButton`). Er staat **geen tekstlabel** bij (de template heeft geen `text=`). Bij muis-erop toont de tooltip
  `ROLE_DESCRIPTION_<rol>`.
- **Geen rol aangevinkt → knop uit.** `LFDQueueCheckRoleSelectionValid` geeft `false` als geen van de drie is aangevinkt.
  De knop wordt dan uitgeschakeld met tooltip `INSTANCE_ROLE_WARNING_TITLE`.
- **De knoptekst wisselt:** alleen = `FIND_A_GROUP`. In een groep met meer dan 1 lid = `JOIN_AS_PARTY`. In de wachtrij =
  `LEAVE_QUEUE`.
- **Samen queuen: ja.** In een groep maar niet de leider → knop uit, tooltip `ERR_NOT_LEADER`. De leider drukt op de knop;
  de anderen krijgen een popup (`LFDRoleCheckPopup`) met `CONFIRM_YOUR_ROLE` en de knoppen `ACCEPT`/`DECLINE`.
- Het tabblad heet `LOOKING_FOR_DUNGEON_PVEFRAME`, het venster/de microknop `DUNGEONS_BUTTON`.

**Uitnodigen — GEMETEN (UI-code `UnitPopupSharedMenus.lua` + `UnitPopupSharedButtonMixins.lua`):**
- Rechtsklik-menu's `PLAYER` (portret/doelframe van een speler) en `FRIEND` (naam in chat) bevatten het blok
  Invite / Suggest Invite / Request to Join. De Invite-knop toont `PARTY_INVITE`. De andere twee tonen
  `SUGGEST_INVITE` / `REQUEST_INVITE`. Welke van de drie verschijnt hangt af van wie in een groep zit (AFGELEID; de
  voorwaarden heb ik niet gelezen).
- Slash: `SLASH_INVITE1-4`, zie tabel. `/inv` en `/invite` werken in alle zes talen.

**GlobalStrings (GEMETEN, wago GlobalStrings, build 12.1.0.69933):**

| Tag | enUS | deDE | frFR | esES | ptBR | itIT |
|---|---|---|---|---|---|---|
| FIND_A_GROUP | Find Group | Gruppe finden | Trouver un groupe | Buscar grupo | Encontrar grupo | Trova gruppo |
| JOIN_AS_PARTY | Join as Party | Beitritt als Gruppe | Rejoindre en groupe | Unirse como grupo | Em grupo | Entra (gruppo) |
| LEAVE_QUEUE | Leave Queue | Abbrechen | Quitter la file | Abandonar cola | Sair da fila | Abbandona coda |
| TANK | Tank | Tank | Tank | Tanque | Tanque | Difensore |
| HEALER | Healer | Heilung | Soigneur | Sanador | Cura | Guaritore |
| DAMAGER | Damage | Schaden | Dégâts | Daño | Dano | Assaltatore |
| DUNGEONS_BUTTON | Group Finder | Dungeonbrowser | Recherche de groupe | Buscador de grupos | Localizador de Grupos | Ricerca gruppi |
| LOOKING_FOR_DUNGEON_PVEFRAME | Dungeon Finder | Dungeon-(regel)browser | Donjons | Buscador de mazmorras | Loc. de Masmorras | Ricerca delle spedizioni |
| CONFIRM_YOUR_ROLE | Confirm your role: | Rolle bestätigen: | Confirmez votre rôle : | Confirma tu función: | Confirme sua função: | Conferma il tuo ruolo: |
| ACCEPT | Accept | Annehmen | Accepter | Aceptar | Aceitar | Accetta |
| ERR_NOT_LEADER | You are not the party leader. | Ihr seid nicht der Gruppenanführer. | Vous n'êtes pas le chef du groupe. | No eres el líder del grupo. | Você não é líder do grupo. | Non sei il capogruppo. |
| INSTANCE_ROLE_WARNING_TITLE | Role unavailable for some dungeons. | Rolle für manche Dungeons nicht verfügbar. | Rôle non disponible dans certains donjons. | Función no disponible en algunas mazmorras. | Função indisponível para algumas masmorras. | Ruolo non disponibile per alcune istanze. |
| PARTY_INVITE | Invite | Einladen | Inviter | Invitar | Convidar | Invita |
| SUGGEST_INVITE | Suggest Invite | Gruppeneinladung vorschlagen | Suggérer une invitation | Sugerir invitación | Sugerir convite | Suggerisci invito |
| REQUEST_INVITE | Request to Join Group | Gruppeneinladung anfragen | Demander à rejoindre le groupe | Solicitar unirse a grupo | Pedir para entrar no grupo | Richiedi di unirti a un gruppo |
| SLASH_INVITE1/2 | /inv, /invite | /einl, /einladen | /inv, /inviter | /inv, /invitar | /con, /convidar | /inv, /invita |
| SLASH_INVITE3/4 | /inv, /invite | idem | idem | idem | idem | idem |
| ROLE_POLL | Role Check | Rollenabfrage | Vérification des rôles | Eligiendo función | Função OK? | Controllo del ruolo |

(ROLE_POLL bestaat; wáár hij op het scherm staat heb ik niet nagekeken. ROLE_DESCRIPTION_TANK/HEALER/DAMAGER bestaan
ook in alle zes talen: enUS "Indicates that you are willing to …".)

---

## 4. Klopt de hoofdstat op mijn gear?

- **Specialisatie-tab — GEMETEN (`Blizzard_ClassSpecializationsFrame.lua`, live 69933):** onder elke spec staat
  `SPEC_FRAME_PRIMARY_STAT` = "Primary Stat: %s" met Strength/Agility/Intellect. Talen: de "Primärwert: %s",
  fr "Stat. principale : %s", es "Estadística principal: %s", pt "Atributos Primários: %s", it "Attributo primario: %s".
  Statnamen: Strength/Stärke/Force/Fuerza/Força/Forza · Agility/Beweglichkeit/Agilité/Agilidad/Agilidade/Agilità ·
  Intellect/Intelligenz/Intelligence/Intelecto/Intelecto/Intelletto.
- **Karakterscherm — GEMETEN (`PaperDollFrame.lua`):** de stat-lijst toont alleen de hoofdstat van je huidige spec.
  `PaperDollFrame_UpdateStats` verbergt de andere twee.
- **Itemtooltip — inactieve hoofdstat grijs: AFGELEID voor 12.1, GEMETEN alleen in oudere bronnen.** Blizzards
  WoD-patchnotes (via Wowhead, 28 aug 2014) zeggen dat stats die je spec niet gebruikt grijs worden in plaats van groen,
  en niet meetellen op je karakterscherm. Blizzard-forum 2019-2021 en warcraft.wiki.gg (Attributes) zeggen hetzelfde.
  Geen bron na 18 aug 2026 gevonden. De tooltip wordt door de client gebouwd (niet in de UI-code), dus niet te meten
  zonder het spel.
  ⚠️ Kanttekening (WoWInterface, 7.3-tijdperk): grijze stats zouden op **gedragen** soulbound items niet getoond worden.
  Niet nagekeken in 12.1.
- **Voorstel:** laat Rob één tooltip bekijken (plaat/leer item in de tas).

---

## 5. Fysiek vs magisch zien als beginner

- **Dungeon Journal — GEMETEN (JournalEncounterSection, 69933):** de rol-overzichten ("Tanks", "Healers", "Damage Dealers")
  van Midnight-bazen noemen het schadetype. Voorbeelden:
  - Lothraxion (Nexus-Point Xenas): Searing Rend doet zware **Physical** schade.
  - Zul'jan (Altar of Fangs): Chop Down zware **Physical** schade.
  - The Writhing Coil (Altar of Fangs): Tail Scythe zware **Physical** schade.
  - The Lost Explorers (The Venomous Abyss): Shredding Shards doet hoge **magic** schade.
  
  Over alle uitbreidingen: 705 secties met "Physical damage", 484 "Shadow damage", 506 "Fire damage", 461 "Nature damage".
  "magic damage" komt maar 18 keer voor. Meestal staat er dus een **schoolnaam**: alles wat niet Physical is, is magisch
  (AFGELEID).
- **Bazen-tijdlijn (Encounter Timeline) — GEMETEN in 2 bestanden:** de iconensets zijn TankAlert, HealerAlert,
  DamageAlert, Deadly, Dispel, Enrage, plus severity. In `EncounterTimelineConstants.lua` en
  `EncounterTimelineTimerEvent.lua` staat **niets** over schadeschool. De andere ~20 bestanden heb ik niet gelezen.
- **Advies (AFGELEID):** wel noemen, maar alleen via de Dungeon Journal: open de baas, tab Overview, dan het kopje Tanks.
  Staat er "Physical", dan helpen armor, Shield Block en BoP. Een schoolnaam (Fire, Shadow, …) betekent magie. Niet
  beloven dat de tijdlijn het toont.

---

## 6. Instant heals per healerspec

Cast time = GEMETEN (SpellMisc.CastingTimeIndex → SpellCastTimes.Base, 69933; index 1 = 0 ms).
"Channel" = GEMETEN (SpellMisc Attributes_1 kanaalbit). Welke spec de spreuk heeft = AFGELEID (bekende specspreuk;
alleen waar genoemd GEMETEN via SpecializationSpells).

| Spec | Instant (0 ms) | Met cast time | Channel/empower |
|---|---|---|---|
| Holy Priest | Renew 139, Prayer of Mending 33076 (*vervangt PW:Shield 17 voor 257*, GEMETEN), Holy Word: Serenity 2050, Holy Word: Sanctify 34861, Guardian Spirit 47788, Circle of Healing 204883¹ | Flash Heal 2061 1,5 s · Prayer of Healing 596 2,5 s · Heal 2060 2,5 s¹ | Divine Hymn 64843 |
| Disc Priest | Power Word: Shield 17, Pain Suppression 33206, Plea 200829 (SpecializationSpells 256) | Flash Heal 2061 1,5 s · Power Word: Radiance 194509 2,0 s | Penance 47540 (SpecSpells 256) |
| Resto Druid | Rejuvenation 774, Lifebloom 33763, Swiftmend 18562, Efflorescence 145205, Cenarion Ward 102351, Ironbark 102342 | Regrowth 8936 1,5 s · Wild Growth 48438 1,5 s | Tranquility 740 |
| Resto Shaman | Riptide 61295, Unleash Life 73685, Earth Shield 974, Healing Stream Totem 5394¹ | Healing Wave 77472 2,0 s (*vervangt Healing Surge 8004 voor 264*, GEMETEN) · Chain Heal 1064 2,0 s · Healing Rain 73920 2,0 s | — |
| Mistweaver | Renewing Mist 115151 (SpecSpells 270), Life Cocoon 116849 | Vivify 116670 1,5 s · Enveloping Mist 124682 2,0 s · Sheilun's Gift 399491 2,0 s | Soothing Mist 115175 |
| Holy Paladin | Holy Shock 20473, Word of Glory 85673, Light of Dawn 85222, Eternal Flame 156322, Lay on Hands 633 | Flash of Light 19750 1,5 s · Holy Light 82326 2,0 s (SpecSpells 65) | — |
| Preservation | Verdant Embrace 360995, Echo 364343, Reversion 366155, Emerald Blossom 355913 | Living Flame 361469 2,0 s · Temporal Anomaly 373861 1,5 s | Dream Breath 355936, Spiritbloom 367226 (empower) |

¹ Bestaat in SpellName, maar ik vond geen talent-, skill- of specrij (de zoektocht op korte ID's is onbetrouwbaar). Of
het in 12.1 in de kit zit is **niet bevestigd**. Niet als voorbeeld gebruiken.

- **Tooltiptekst:** `SPELL_CAST_TIME_INSTANT` en `SPELL_CAST_TIME_INSTANT_NO_MANA` bestaan allebei (GEMETEN). Welke de
  client gebruikt is niet te meten (de tooltip wordt C-zijdig gebouwd). enUS/fr/es/pt/it zijn voor beide gelijk.
  **deDE verschilt:** "Spontan" vs "Sofort". Kanalen: `SPELL_CAST_CHANNELED`. Cast time: `SPELL_CAST_TIME_SEC` =
  "%.2g sec cast".

  | Tag | enUS | deDE | frFR | esES | ptBR | itIT |
  |---|---|---|---|---|---|---|
  | SPELL_CAST_TIME_INSTANT | Instant | Spontan | Instantané | Instantáneo | Instantâneo | Istantaneo |
  | SPELL_CAST_TIME_INSTANT_NO_MANA | Instant | Sofort | Instantané | Instantáneo | Instantâneo | Istantaneo |
  | SPELL_CAST_CHANNELED | Channeled | Kanalisiert | Canalisé | Canalizado | Canalizado | Canalizzato |
  | SPELL_CAST_TIME_SEC | %.2g sec cast | Wirken in %.2g Sek. | %.2g s d'incantation | %.2g s para lanzar | Lançamento de %.2g s | %.2g s di lancio |

- ⚠️ **Basiswaarden.** Talenten en procs maken casts instant (Icy Veins: Nature's Swiftness → Regrowth; Tree of Life →
  Regrowth). De tooltip toont dan iets anders dan deze tabel.

---

## 7. Resto Druid: "grote heal"?

- **Regrowth 8936** = de directe heal met cast time: 1,5 s (GEMETEN), klassespreuk (skill 798).
- Icy Veins Resto 12.1 (10 aug) beschrijft Regrowth als directe heal met een kleine HoT. Hun advies: bij scherpe schade
  Regrowth casten (eventueel met Nature's Swiftness) en herhalen tot het doel veilig is. Ze noemen het seizoen "enorm
  Regrowth-gericht".
- **Nourish 50464 is GEEN knop in 12.1 — GEMETEN:** TraitDefinition 108099 → TraitNodeEntry 103094 is aan **geen enkele
  TraitNode** gekoppeld. Positieve controle in dezelfde run: Lifebloom (108105) en Wild Growth (108288) hangen wél aan
  nodes in boom 793. Icy Veins noemt Nourish alleen als spreuk die de Grove Guardians-treants zelf casten.
- **Antwoord (AFGELEID):** "Regrowth" is het juiste antwoord, niet "geen". Beter is "directe heal" dan "grote heal":
  Regrowth is de enige directe cast-heal, maar geen trage, zware heal zoals Holy Light.

---

## 8. Chat: Enter, Say, groepschat

**GEMETEN (`ChatFrameEditBox.lua`, `ChatTypeInfoConstants.lua`, live 69933):**
- Het chatvak start met `SetChatType("SAY")` en `SetStickyType("SAY")`. Enter opent dus standaard **Say**.
- SAY, PARTY, RAID, GUILD, WHISPER en INSTANCE_CHAT zijn **sticky**. Na één bericht in Party opent Enter de volgende keer
  weer Party.
- Ben je niet (meer) in een eigen groep, dan zet `ResetChatType` PARTY terug naar SAY.
- **/p in een Dungeon Finder-groep:** zonder eigen groep, maar wel in een instance-groep, maakt `UpdateHeader` van PARTY
  automatisch **INSTANCE_CHAT**. Solo gequeued werkt `/p` dus gewoon; de kop toont dan "Instance:".
- ⚠️ **Met een vriend gequeued** ben je wél in een eigen groep. Dan blijft PARTY gewoon PARTY: `/p` gaat
  (AFGELEID) alleen naar je vriend. `/i` bereikt de hele dungeongroep. Voor de les: **in een Group Finder-dungeon
  altijd `/i`**.

| Tag | enUS | deDE | frFR | esES | ptBR | itIT |
|---|---|---|---|---|---|---|
| CHAT_SAY_SEND (kop) | Say: | Sagen: | Dire : | Decir: | Diz: | Dici: |
| CHAT_PARTY_SEND | Party: | Gruppe: | Groupe : | Grupo: | Grupo: | Gruppo: |
| CHAT_INSTANCE_CHAT_SEND | Instance: | Instanz: | Instance : | Estancia: | Instância: | Istanza: |
| SLASH_PARTY1-4 | /p /party /p /party | /p /Gruppe /p /party | /gr /groupe /p /party | /gp /grupo /p /party | /p /grupo /p /party | /gr /gruppo /p /party |
| SLASH_INSTANCE_CHAT1-4 | /i /i /instance /instance | /i /i /instanz /instance | /i /i /instance /instance | /est /i /estancia /instance | /i /i /instância /instance | /i /i /instance /istanza |
| SLASH_SAY1-4 | /s /say /s /say | /s /say /s /sprechen | /s /say /d /dire | /d /say /s /decir | /s /dizer /s /say | /pa /say /s /parla |

`/p`, `/i` en `/s` (via de nummers 3/2/3) werken dus in alle zes talen.

---

## 9. Shield of the Righteous: "bijna altijd aan houden"?

- **Ja, dat is het juiste beginnersadvies (GEMETEN in twee gidsen na 18 aug):**
  - Icy Veins Prot Pal 12.1 (21 aug): SotR kost 3 Holy Power, geeft een korte armor-buff (4,5 s volgens de gids) en zit
    buiten de GCD. Streef ernaar hem in gevechten bijna altijd actief te hebben. Word of Glory alleen gebruiken als hij
    gratis is (Shining Light).
  - Method Prot Pal 12.1 (3 sep): met SotR en de juiste rotatie hou je de mitigatie op bijna 100% uptime. Holy Power gaat
    vrijwel helemaal naar SotR.
- **DB2 (GEMETEN):** SotR 53600 (skill 800) slaat vijanden vóór je en verhoogt je Armor voor de duur van buff 132403.
- ⚠️ **Eén interne tegenspraak bij Icy Veins (GEMETEN):** de prioriteitslijst zegt SotR bij 3-5 Holy Power. De tekst
  eronder raadt af om hem op precies 3 Holy Power te drukken. Voor beginners: "hou hem bijna altijd aan, en zit niet
  op 5 Holy Power" — dat staat in beide gidsen.

---

## Wat NIET gemeten is

- In-game tooltips (grijze stat, de "Instant"-regel, de rechtsklik-Invite in de praktijk). Alleen UI-code, DB2 en gidsen.
- De precieze voorwaarden waaronder Invite, Suggest Invite of Request to Join verschijnt.
- Of `/p` met een vriend in de groep echt alleen de vriend bereikt (afgeleid uit de code).
- Welke van de twee "Instant"-strings de Duitse client toont.
