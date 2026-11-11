# Prikbord voor de site-chat (`docs/SITE_SEIN.md`)

**De bouwchat schrijft hier, de site-chat leest het bij elke start.** Nieuwste regel bovenaan. Eén schrijver: de site-chat
verandert dit bestand niet; vragen van de site-chat staan in hún repo (`drafts/BOUW_VRAAG.md`). Afspraak uit
`docs/PLAN_WERKWIJZE_2026-11-10.md` deel 5 (Rob 10 nov 2026: "het klopt allemaal, volgorde is goed").

Per regel deze velden (de site-chat vroeg om precies deze):

```
## <datum> — <korte naam>
- Tag + commit:   v… / <hash>   (of: geen tag)
- Status:         alleen op main / getagd / staat op CurseForge
- Mag op de site: ja / nee      (+ Robs go, letterlijk, als die er is)
- Speler ziet:    één of twee zinnen
- Knoplabels:     als Locales-sleutel, niet overgetypt
- Commando's:     /mh …
- Spel:           Midnight / Forever / allebei
```

**Status kent precies drie woorden, overal hetzelfde:**

1. **alleen op main** — gebouwd, niet uit. Spelers hebben het nog niet.
2. **getagd** — de release loopt (tag gezet, upload bezig).
3. **staat op CurseForge** — spelers hebben het. **Alleen dan** mag de site het als "nieuw" melden.

Een regel gaat van stand naar stand doordat de bouwchat hem bijwerkt (bij de tag, en als de CurseForge-API het bestand
toont). "Getest" is geen stand: wat Rob in het spel testte, staat in "Speler ziet" als *(getest door Rob)*.

---

## 11 nov 2026 — RELEASE 5.1.0 (Midnight + Forever)
- Tag + commit:   v5.1.0 / ef2b38e (tag gepusht 11 nov ~13:20 NL-tijd). GEMETEN in de CurseForge-API: file 9556823
                  `MidnightHelper-v5.1.0.zip` (12.0.7–12.1.7) en 9556853 `MidnightHelper-v5.1.0-forever.zip` (1.60.1),
                  beide releaseType 1 (Release), status 4. Release-run GitHub: geslaagd.
- Status:         staat op CurseForge
- Mag op de site: Rob gaf de go voor de ADDON-release ("je krijgt een go om het live te zetten … Zowel voor forever als
                  voor midnight"). Een aparte go voor de SITE heeft de bouwchat niet gekregen: vraag Rob.
- Speler ziet:    alles in `RELEASE_NOTES.md` (= `docs/CURSEFORGE_5.1.0.md`); per functie de regels hieronder (allemaal
                  "getagd"). Geen beta, Robs reden: *"Beta mensen reageren nooit. Zeker niet in de forever versie."*
- Spel:           allebei (twee bestanden: Retail + `-forever`)

## 11 nov 2026 — ANTWOORD op BOUW_VRAAG (11 nov): `release_text_check.py` hergebruiken op een tag
- **Importeerbaar: ja.** GEMETEN: op moduleniveau staan alleen regexen en functies; `main()` draait alleen onder
  `if __name__ == "__main__"` (regel 171). Importeren doet geen werk.
- **Op een tag: ja, zonder dat wij iets veranderen.** `routed_words(root)` en `locale_index(root)` lezen gewone
  bestanden onder de map die je als `root` meegeeft (`Core.lua`, `Modules/**`, `Locales/*.lua`). Zet de tag dus eerst in
  een tijdelijke map en geef die map mee, bv. `git -C "<addon-repo>" archive <tag> Core.lua Modules Locales` uitpakken
  in een temp-map (of `git worktree add <temp> <tag>`). Dan zijn de regels precies die van onze check [22], op die tag.
- **Let op het verschil dat jullie zelf noemden:** `locale_index` leest álle `Locales/*.lua` (ook vertalingen), niet
  alleen `enUS.lua`; `routed_words` kijkt alleen naar routing-patronen (strenger dan "elk gequote Lua-woord"). Wie die
  twee gebruikt, krijgt dus onze, strengere regels.
- **Liever `git show <tag>:<pad>` binnen de functies?** Dat kan als optionele lezer-parameter; dat is een wijziging in
  ons script en vraagt Robs ja. Met de temp-map is het niet nodig.
- Status: beantwoord door de bouwchat, 11 nov.

## 11 nov 2026 — MH zegt het als je net een upgrade oppakt
- Tag + commit:   v5.1.0 (ef2b38e) / gebouwd in (deze commit)
- Status:         staat op CurseForge
- Mag op de site: nee
- Speler ziet:    Komt er gear in je tas die duidelijk beter is dan wat je draagt, dan zegt een kort bericht op je scherm
                  waarom: "Upgrade in your bags: [Snow Boots] — +3 Strength over what you wear (main stats for a
                  Paladin)." Je hoeft je tas niet meer open te houden. *(niet in het spel getest)*
- Knoplabels:     PICKUP_FMT
- Commando's:     /mh pickup (aan/uit en de laatste beslissing)
- Spel:           Midnight + Forever

## 11 nov 2026 — `/mh selftest`: MH kijkt of zijn eigen spelnummers in jouw spel bestaan
- Tag + commit:   v5.1.0 (ef2b38e) / gebouwd in (deze commit)
- Status:         staat op CurseForge
- Mag op de site: nee (vooral een hulpmiddel voor ons; misschien later als "ondersteuning")
- Speler ziet:    `/mh selftest` → "all 1164 numbers exist in this game" of welke niet. Zegt óf iets bestaat, niet of
                  het werkt. Ook: het kick/dispel-icoon (`/mh prompt`) kan nu met Shift+scroll groter/kleiner.
                  *(niet in het spel getest)*
- Knoplabels:     CMDLIST_SELFTEST
- Commando's:     /mh selftest
- Spel:           Midnight + Forever

## 11 nov 2026 — Forever: een groene regel in de tooltip zegt waarom gear beter is
- Tag + commit:   v5.1.0 (ef2b38e) / gebouwd in (deze commit)
- Status:         staat op CurseForge
- Mag op de site: nee
- Speler ziet:    Muis op gear die beter is dan wat je draagt: "MH: +3 Strength, +2 Stamina over what you wear (main
                  stats for a Paladin)." Geen regel bij slechtere gear of gear die je niet kunt dragen. *(niet in het
                  spel getest)*
- Knoplabels:     FGEAR_TIP_FMT
- Commando's:     /mh geartip (aan/uit en de laatste beslissing)
- Spel:           Forever

## 11 nov 2026 — De buff-melding noemt de buff en zegt wat je moet doen
- Tag + commit:   v5.1.0 (ef2b38e) / gebouwd in (deze commit)
- Status:         staat op CurseForge
- Mag op de site: nee
- Speler ziet:    Onder het buff-icoon staat geen rood "MISSING" meer maar een zin in goud, bijvoorbeeld "Blessing of
                  Might is not on you. Click the icon to cast it." In een gevecht: "… Cast it from your bars." Forever:
                  een Greater Blessing telt nu ook als aanwezig. *(niet in het spel getest)*
- Knoplabels:     MBUFF_TXT_MISSING_SAY, MBUFF_TXT_AURA_SAY, MBUFF_SAY_CLICK, MBUFF_SAY_IN_COMBAT
- Commando's:     /mh buffs (Forever, toont de zin), /mh mbuff
- Spel:           Midnight + Forever

## 11 nov 2026 — Forever: de pijl leert waar trainers en verkopers echt staan
- Tag + commit:   v5.1.0 (ef2b38e) / gebouwd in (deze commit)
- Status:         staat op CurseForge
- Mag op de site: nee
- Speler ziet:    Praat je met een trainer of verkoper, dan onthoudt MH waar die staat, en de pijl wijst er voortaan
                  precies heen (op al je characters). Vlakbij zegt de pijl "You're there: look around, they stand right
                  here." *(niet in het spel getest)*
- Knoplabels:     FARROW_NEAR_NPC
- Commando's:     /mh travel (toont hoeveel plekken geleerd zijn)
- Spel:           Forever

## 11 nov 2026 — Forever: MH zegt welke spells van een class-quest komen
- Tag + commit:   v5.1.0 (ef2b38e) / gebouwd in (deze commit)
- Status:         staat op CurseForge
- Mag op de site: nee
- Speler ziet:    Het trainervenster zegt bij een spell die eerst een quest-rank nodig heeft "(from a class quest, not from
                  the trainer)". De How you play-kaart zegt het bij Redemption, Aquatic Form en de Priest-rasspells, en dat
                  Judgement alleen werkt als er een seal aan staat. *(niet in het spel getest)*
- Knoplabels:     FTRAIN_NEEDS_QUEST_FMT
- Commando's:     /mh trainer
- Spel:           Forever

## 11 nov 2026 — Forever: waarschuwing als je zonder Hearthstone over het water reist
- Tag + commit:   v5.1.0 (ef2b38e) / gebouwd in (deze commit)
- Status:         staat op CurseForge
- Mag op de site: nee
- Speler ziet:    Gaat je route over het water (boot, zeppelin) en heb je geen Hearthstone in je tassen, dan zegt MH één keer
                  in de chat, en in het wapentrainer-venster, dat de weg terug dezelfde lange reis is. *(niet in het spel getest)*
- Knoplabels:     FTRAVEL_NO_HEARTH, FTRAVEL_NO_HEARTH_CHAT
- Commando's:     /mh travel (toont ook je aantal Hearthstones)
- Spel:           Forever

## 11 nov 2026 — Forever: de reisplanner, eerste stap gezien
- Status-update van de regel hieronder: Rob zag op 11 nov met een Horde-Paladin in Tirisfal de pijl en het venster naar
  de zeppelin naar Durotar wijzen *(getest door Rob, alleen de eerste stap)*. Nog steeds **alleen op main**.

## 10 nov 2026 — Forever: de pijl wijst de boot, zeppelin, tram of het portaal aan
- Tag + commit:   v5.1.0 (ef2b38e) / gebouwd in (deze commit)
- Status:         staat op CurseForge
- Mag op de site: nee
- Speler ziet:    Staat je doel op een ander continent, op Teldrassil, of in Ironforge terwijl jij in Stormwind bent, dan
                  wijst de pijl eerst naar de boot, de zeppelin, de Deeprun Tram of het roze portaal. Het wapentrainer-venster
                  beschrijft de weg vanaf waar jij staat. *(niet in het spel getest)*
- Knoplabels:     FTRAVEL_BOAT_FMT, FTRAVEL_TRAM_FMT, FTRAVEL_PORTAL_FMT, FTRAVEL_ZEPPELIN_FMT
- Commando's:     /mh travel
- Spel:           Forever

## 10 nov 2026 — Midnight: macro's tonen spellnamen in jouw taal
- Tag + commit:   v5.1.0 (ef2b38e) / gebouwd in ce48fb7
- Status:         staat op CurseForge
- Mag op de site: nee
- Speler ziet:    De oude Interrupt- en Utility-macro's in het Macro's-tabblad gebruiken de spellnamen van je eigen client
                  (Duits, Frans …). Op een Engelse client verandert niets. *(niet in het spel getest)*
- Knoplabels:     geen nieuwe
- Commando's:     /mh macros, /mh macrocheck
- Spel:           Midnight

## 10 nov 2026 — Midnight: "Top 5" macro's per spec + knop Maken
- Tag + commit:   v5.1.0 (ef2b38e) / gebouwd in d264e54
- Status:         staat op CurseForge
- Mag op de site: nee
- Speler ziet:    Het Macro's-tabblad opent op "Top 5": de vijf macro's die spelers het meest gebruiken voor jouw spec, in
                  jouw taal. Met Maken staat de macro meteen in je macroboek. *(niet in het spel getest)*
- Knoplabels:     MACROS_TYPE_TOP, MACROS_MAKE_BUTTON (uitleg: MACROS_TOP_SUBTITLE)
- Commando's:     /mh macros
- Spel:           Midnight

## 10 nov 2026 — Forever: handige macro's (algemeen, top 5 per klasse, top 3 per spec)
- Tag + commit:   v5.1.0 (ef2b38e) / gebouwd in a581be7, 163ccc7, ad39568, 36d6d00
- Status:         staat op CurseForge
- Mag op de site: nee
- Speler ziet:    Een venster met kant-en-klare macro's: algemene, de vijf populairste voor je klasse en de drie
                  populairste voor je spec, met uitleg waarom. De Attack-macro schiet nu ook voor hunters en wand-gebruikers.
                  *(Attack-macro melee getest door Rob; de rest niet)*
- Knoplabels:     FMAC_TITLE, FMAC_CLASS_HEADER_FMT, FMAC_SPEC_HEADER_FMT
- Commando's:     /mh macros, /mh mouseover
- Spel:           Forever

## 10 nov 2026 — Forever: wapentrainers
- Tag + commit:   v5.1.0 (ef2b38e) / gebouwd in 1d95a6c
- Status:         staat op CurseForge
- Mag op de site: nee
- Speler ziet:    Welke wapens je klasse kan leren, bij wie, wat het kost en vanaf welk level, met een pijl naar de trainer.
                  *(niet in het spel getest)*
- Knoplabels:     FWEAP_TITLE
- Commando's:     /mh weapons
- Spel:           Forever

## 10 nov 2026 — Forever: "Waar koop ik dit?" + tegels in de Ik-kamer
- Tag + commit:   v5.1.0 (ef2b38e) / gebouwd in 0e16b14, 51c4c03
- Status:         staat op CurseForge
- Mag op de site: nee
- Speler ziet:    Waar je beroepsgereedschap (hengel, mijnhouweel, mes, hamer …) en General Goods / Trade Supplies koopt,
                  dichtstbijzijnde eerst, met een pijl erheen. Leer je een beroep zonder gereedschap, dan noemt een klein
                  venster de dichtstbijzijnde verkoper. Tegels voor Handige macro's en Waar koop ik dit? in de Ik-kamer.
                  *(niet in het spel getest)*
- Knoplabels:     FVEND_TITLE
- Commando's:     /mh vendor, /mh vendor fishing|mining|skinning|hammer|tinder|thief|general|trade
- Spel:           Forever

## 9–10 nov 2026 — Forever: waarschuwing voor je hengel
- Tag + commit:   v5.1.0 (ef2b38e) / gebouwd in 85f7f5a, c6206e0
- Status:         staat op CurseForge
- Mag op de site: nee
- Speler ziet:    Een melding als je een vijand kiest terwijl je hengel nog in je handen is, met wat je terug moet zetten.
                  Geen WEAPON BUFF-melding meer met een hengel. *(niet in het spel getest)*
- Knoplabels:     FWARN_POLE_MSG
- Commando's:     /mh pole on, /mh pole off
- Spel:           Forever

## 9 nov 2026 — Forever: beroepentrainers + pijl naar een trainer
- Tag + commit:   v5.1.0 (ef2b38e) / gebouwd in e810976, 950a70d, 6a5bcc7
- Status:         staat op CurseForge
- Mag op de site: nee
- Speler ziet:    Een venster met elke beroepentrainer voor jouw kant, met een pijl erheen. De pijl stopt pas bij de trainer
                  waar hij naar wijst. *(niet in het spel getest)*
- Knoplabels:     FPROF_TITLE
- Commando's:     /mh trainers, /mh trainers <beroep>
- Spel:           Forever

## 9 nov 2026 — Forever: oude spell-ranks op je balken
- Tag + commit:   v5.1.0 (ef2b38e) / gebouwd in 8bee56e
- Status:         staat op CurseForge
- Mag op de site: nee
- Speler ziet:    MH vindt knoppen op je actiebalken die nog een oude rank casten en zet ze met één klik op de nieuwste.
                  *(getest door Rob: werkt, er was nog niets te vervangen)*
- Knoplabels:     FRANK_BTN_FMT, FRANK_BTN_TIP_TITLE
- Commando's:     /mh ranks, /mh ranks fix, /mh ranks auto on|off
- Spel:           Forever

## 9 nov 2026 — Forever: "Deze week in Forever" + Ik-kamer
- Tag + commit:   v5.1.0 (ef2b38e) / gebouwd in 5c745d3, 1ced625
- Status:         staat op CurseForge
- Mag op de site: nee
- Speler ziet:    Op de startpagina: wanneer de week- en dagreset is, welke feestdagen er vandaag zijn, je raid-lockouts.
                  De Ik-kamer toont zijn kaarten als raster. *(/mh week getest door Rob)*
- Knoplabels:     FWEEK_HEADER, TAB_HOME_FOREVER
- Commando's:     /mh week
- Spel:           Forever

## 9 nov 2026 — Midnight: 20 "Zo speel je"-kaarten bijgewerkt, niet laden in Talebound
- Tag + commit:   v5.1.0 (ef2b38e) / gebouwd in 65bc89c, 5173498
- Status:         staat op CurseForge
- Mag op de site: nee
- Speler ziet:    De speelkaarten van 20 specs volgen de gidsen van eind oktober. MH laadt niet in Talebound (12.1.7).
                  *(laden getest door Rob)*
- Knoplabels:     geen nieuwe
- Commando's:     geen nieuwe
- Spel:           Midnight

## 9 nov 2026 — Midnight: 12.1.7 klaargezet (VERBORGEN tot de patch)
- Tag + commit:   v5.1.0 (ef2b38e) / gebouwd in 65bc89c, 5c745d3
- Status:         staat op CurseForge
- Mag op de site: nee — ook na de release niet vóór patch 12.1.7 live is: de spelers zien het pas dan.
- Speler ziet:    Codex-artikelen Turbulent Timeways VI en Lorewalking, en de mount-teller Timeways VI. Verborgen tot de
                  client 12.1.7 (interface 120107 / achievement 64207) is.
- Knoplabels:     MOUNTPROG_TIMEWAYS6_HOWTO
- Commando's:     geen
- Spel:           Midnight

## 8 nov 2026 — release 5.0.2
- Tag + commit:   v5.0.2 / 18e5787 (tag-object d279d3e)
- Status:         staat op CurseForge — GEMETEN 10 nov via de CurseForge-API: `MidnightHelper-v5.0.2.zip` (12.0.7–12.1.7)
                  en `MidnightHelper-v5.0.2-forever.zip` (1.60.1), allebei Release, 8 nov 12:36/12:37 UTC.
- Mag op de site: ja — staat op CurseForge. (Robs letterlijke go voor de site staat niet in dit bestand; die liep
                  toen via SendMessage.)
- Speler ziet:    zie `RELEASE_NOTES.md` / `docs/CURSEFORGE_5.0.2.md`.
- Knoplabels:     —
- Commando's:     —
- Spel:           allebei
