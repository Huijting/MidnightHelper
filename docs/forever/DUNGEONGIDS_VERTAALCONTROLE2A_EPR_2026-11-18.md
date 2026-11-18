# Vertaalcontrole bazengids stap 2a — esES, esMX, ptBR, ruRU (controleur EPR, 18 nov 2026)

Gecontroleerd: alle 349 `FDG_*`/`FDGP_*`-sleutels van GNOMER, RFK, SM, RFD, ULDA, ZF, MARA, DAL, DROWN, KROL, ALCAZ
(+ de 8 `FDGP_*`) in `Locales/ForeverClassQuests_esES.lua` (r. 762-1110), `_ptBR.lua` (r. 716-1064), `_ruRU.lua`
(r. 531-879) en de 18 overlayregels in `_esMX.lua` (r. 158-175), tegen `enUS.lua` r. 5861-6209. Repo niet aangeraakt.
Verbeterde regels: `dg2x_esES.txt` (5), `dg2x_ptBR.txt` (4). Geen `dg2x_esMX.txt` en geen `dg2x_ruRU.txt`: geen fouten.

## Telling

| taal | FOUT | RISICO | in dg2x |
|---|---|---|---|
| esES | 5 | 1 | 5 |
| esMX (overlay) | 0 | 0 | 0 |
| ptBR | 2 | 2 | 4 |
| ruRU | 0 | 1 (laag) | 0 |

## esES

- **FOUT — `FDG_ULDA_3_T`, `FDG_ZF_9_T`, `FDG_MARA_2_T`, `FDG_MARA_7_T`: "turn away" vertaald als "wegzetten".**
  Engels: "turn her/him/both away (from the group)" = de baas dráaien zodat zijn voorkant van de groep af wijst. Het pack
  zegt "aléjala del grupo", "Aparta a los dos del grupo", "apártalo del grupo", "El tanque lo aparta": *alejar/apartar*
  = verplaatsen, niet draaien (AFGELEID, taalkennis). Dezelfde Engelse opdracht staat in dit blok wél goed vertaald:
  `FDG_GNOMER_4_T` "Mantenlo de espaldas al grupo", `FDG_DROWN_2_T` "lo gira lejos del grupo" (GEMETEN, grep in het
  pack). Bij Ironaya, Razorlash, Gizlock en Ukorz/Ruuzlu gaat het juist om de voorkant (frontale slag): de betekenis
  verandert dus. Nieuw: "gírala/gíralo/Gira a los dos de espaldas al grupo", zelfde vorm als GNOMER_4_T.
  ⚠️ Buiten mijn set: stap 1 `FDG_SFK_5_T` "aparta a los murciélagos del grupo" heeft hetzelfde probleem.
- **FOUT — `FDG_DAL_6_D1`: "late durante unos segundos un daño muy fuerte sobre todos".** *Latir* is onovergankelijk;
  "late un daño" is geen correct Spaans (AFGELEID). Nieuw: "durante unos segundos inflige pulsos de daño muy fuerte a
  todos los que están a menos de 25 metros." Betekenis, 25 en "unos segundos" gelijk.
- **RISICO (laag, niet aangepast) — "a dos manos" in 15 rolregels** (`FDG_DAL_L1`, `_L2`, `FDG_GNOMER_L1`, `_L2`,
  `FDG_RFK_L1`, `_L2`, `FDG_SM_L4`, `_L5`, `_L7`, `_L11`, `FDG_DROWN_L1`, `FDG_RFD_L1`, `FDG_KROL_L3`, `FDG_ULDA_L2`,
  `FDG_ALCAZ_L3`). De client zegt "de dos manos": ItemSubClass esES Forever 1.60.1.70959 "Hachas/Mazas/Espadas de dos
  manos", INVTYPE_2HWEAPON "Dos manos" (GEMETEN). "a dos manos" is correct Spaans en stap 1 mengt beide (`FDG_DM_L2`
  "de", `FDG_BFD_L1` "a"). Alleen aanpassen als Rob één vorm wil.

## esMX (overlay)

Geen fouten. Alle 18 overlayregels kloppen met de esMX-client (GEMETEN, zie namen hieronder): Tomo de Dalaran, Tomo
oscuro, Maestra Destructora Emi Plomocorto, mano derecha (3×), Ofrendas eternas, Elemental primitivo, Medallón de
Gni'kiv (2×), Geólogos de Forjatiniebla, Vara divinomática, abalorio (2×), mano izquierda, Capellanes de Alcaz.
Volledigheid (AFGELEID uit de metingen): geen andere esES-regel in deze set bevat een woord dat esMX anders zegt; alle
andere gemeten namen (Mastic, Cuerolanza de Rajacieno, Practicante Escarlata, Fantasma de maná, Bastión/Ciudadela
Violeta, Sala de Máquinas, Molino Ámbar, Castillo de Colmillo Oscuro, Tierras del Interior, Cascadas del Canto de la
Tierra, Celebras el Redimido, Cavindra, Modera, alle bazennamen in de teksten) zijn in esMX gelijk aan esES.
Mijn esES-verbeteringen raken geen overlayregel; esMX erft ze.
- Geen fout, wel goed om te weten: `FDG_ZF_6_D1` zegt "Sandfury Executioner" en `FDG_ZF_8_D1` alleen "Weegli": Wowhead
  esMX geeft voor 7274 en 7607 een placeholder ("[Sandfury Executioner]", "[Weegli Blastfuse]", GEMETEN). Volgens de
  regel (niet te meten → Engels) in orde.

## ptBR

- **FOUT — `FDG_RFK_1_D2` "outros javalianos" en `FDG_RFD_2_D1` "ídolo javaliano".** Quilboar heet in ptBR
  *javatusco*: npc 2952 "Javatusco Costagulha", 3111 "Javatusco Crinavalha", quest 3525 "Escolte Belnistrasz até o
  ídolo dos javatuscos" (Wowhead Forever tooltip ptBR, 18 nov 2026, GEMETEN). Het pack zelf zegt het ook:
  `FCQ_OBJ_SH_FIRETAR_H` "javatuscos Crinavalha". "javaliano" komt verder nergens voor. Nieuw: "outros javatuscos",
  "no ídolo dos javatuscos".
- **RISICO — `FDG_ZF_2_T` "mantenha o curador à distância".** Enige "curador" in het pack; "curandeiro" staat er 35×
  (GEMETEN, grep). Client-rolnaam is "Cura" (GlobalStrings HEALER ptBR, GEMETEN), dus geen van beide is het clientwoord;
  wel inconsistent. Nieuw: "curandeiro".
- **RISICO (stijl) — `FDG_GNOMER_1_D1` "fale com Estalomestre Emi Paviocurto".** Lidwoord ontbreekt; de andere regels
  zeggen "fale com a Arquimaga Modera", "fale com o prisioneiro" (GEMETEN). Nieuw: "fale com a Estalomestre …"
  (naam GEMETEN: npc 7998 ptBR "Estalomestre Emi Paviocurto").
- Gecontroleerd, géén fout: `FDG_MARA_L1` "+12 de Resistência a Natureza" zonder crase. De itemtooltip 17744 ptBR zegt
  zelf "+12 de resistência a Natureza" (GEMETEN); GlobalStrings RESISTANCE3_NAME zegt "à Natureza". Beide verdedigbaar.

## ruRU

Geen fouten. Alle gemeten namen kloppen, ook de naamvallen (со Взрывником Ими Фитилюшкой, Чавккера, Белнистразом,
Селебрасом Искупленным, к Песне Земли, у Аметистовой крепости, Тенегорнскими геологами).
- RISICO (laag, niet aangepast) — `FDG_DAL_6_T` "Сначала убейте фолианты": de Angry Tomes zijn wezens; levende
  monsters krijgen in het Russisch meestal de bezielde accusatief ("фолиантов", zoals "скелетов" in `FDG_DAL_1_T`).
  AFGELEID; grammaticaal niet fout.
- Info, geen fout: Celebras heet als baas "Келебрас" (DungeonEncounter 425 ruRU) maar als npc/item "Селебрас"
  (npc 13716 "Селебрас Искупленный", item 17191 "Скипетр Селебраса"); `FDG_MARA_4_D3` en `_T` volgen elk hun bron
  (GEMETEN). Blizzard is zelf inconsistent.

## Wat ik gemeten heb (alle `run gamedata …`, 18 nov 2026)

Forever = build 1.60.1.70959; WHT = Wowhead Forever tooltip-JSON.
- **npc's (WHT, enUS + esES/esMX/ptBR/ruRU):** 7998 Emi Shortfuse, 6215 Chomper, 4438 Razorfen Spearhide, 6575 Scarlet
  Trainee, 8516 Belnistrasz, 7274 Sandfury Executioner, 13716 Celebras the Redeemed, 13697 Cavindra, 269127 (Image of)
  Archmage Modera, 255262 Alcaz Chaplain, 255707 Zarla Ober, 7607 Weegli Blastfuse, 270910 Brinescale Priestess,
  269475 Mana Phantom, 263899 Undying Offering, 7797 Ruuzlu, 7030 Shadowforge Geologist, 6906-6908 Baelog/Eric/Olaf,
  7604 Bly (ruRU), 2952/3111 quilboar (ptBR). Id's gevonden in Zygor Forever / ForeverDungeonJournal (kandidaten) en
  per id in WHT enUS bevestigd. Alle teksten kloppen, behalve "javaliano" (ptBR).
- **Placeholders (dus Engels laten = goed):** Brinescale Priestess (alle 4 talen), Zarla Ober (alle 4), Alcaz Chaplain
  (alleen esES; esMX/ptBR/ruRU hebben een echte naam en die staat erin), Sandfury Executioner en Weegli (alleen esMX).
- **Items (DB2 ItemSparse Forever, 4 talen):** 275989 Tome of Dalaran, 276561 Black Tome, 6893 Workshop Key, 7146 The
  Scarlet Key, 7740, 7741, 7733, 9240, 8548, 17702, 17703, 17191. Alles klopt (esES "Escrito de Dalaran" / "Tomo
  negro" is echt de esES-clientnaam; esMX "Tomo de Dalaran" / "Tomo oscuro").
- **Bazen (DB2 DungeonEncounter Forever, 4 talen):** 2768, 2772, 450, 446, 2781, 549, 553, 425, 3475, 3476, 3511, 594,
  598, 599, 600: alle bazennamen in de teksten kloppen. De overige uit het `names`-veld (WHT/DB2 van de makers).
- **Plekken:** AreaTable Forever 233 Ambermill, 209 Shadowfang Keep, 47 Hinterlands, 721/1176/1337/2100 (ruRU): kloppen.
  Hall of Gears en Violet Hold/Citadel staan NIET in Forever-DB2 (0 rijen; positieve controle "Gnomeregan" en
  "Dalaran" gaven wel rijen); gemeten in retail 12.1.5.70961 (UiMapGroupMember 516, AreaTable 4567/4619): kloppen.
  Dat de Forever-client dezelfde namen toont is AFGELEID.
- **Earth Song Falls:** itemtooltip 17191 ruRU "к Песне Земли", esMX "Cascadas del Canto de la Tierra" (GEMETEN).
- **Vleugelnamen SM** (Graveyard/Library/Armory/Cathedral): geen clientnaam te vinden (LFGDungeons Forever, Classic Era
  1.15.9.70576 en retail: alleen "Scarlet Monastery"/"Scarlet Halls"; AreaTable Forever: geen subzones onder 796) →
  gewone vertaling is goed.
- **Slot/stat (GlobalStrings Forever):** Main Hand esES "Mano principal", esMX "Mano derecha", ptBR "Mão principal",
  ruRU "Правая рука"; Off Hand/Held In Off-hand, trinket, parry, defense, attack power, crit: alles klopt met de
  teksten. Main Hand ≠ One-Hand overal goed (SM_L12, KROL_L1, ULDA_L1).
- **Niet te meten:** Angry Tome (geen id gevonden), Glowing Pearl (geen rij in GameObjects Forever; positieve controle
  ontbrak: ook "Pearl" gaf 0 van 1526 rijen, dus deze tabel is te dun om iets te bewijzen). Beide staan Engels = goed.

## Ook nagelopen, geen bevinding

Getallen (25 yards, alle +stats, 1%, 5 sec) in alle drie de talen gelijk aan het Engels; volgorde/wie-doet-wat
(Eric→Olaf→Baelog, Chomper eerst, Ruuzlu eerst, Nekrum eerst, Questioner als laatste, tank/healer/ranged/melee),
"optional"/"rare" overal aanwezig. Aanspreekvorm: esES tú, ptBR você, ruRU вы, overal consequent. Geen recht `"` in
de tekst (grep met positieve controle op FRANK_WIN_SUB). Geen markup in deze sleutels.
