# Ochtendronde — wat de bouwchat doet bij "goedemorgen"

Bij een groet of de eerste boodschap van de dag, ongevraagd en in deze volgorde. Elke chat kan dit lezen, ook een chat
vanaf Robs telefoon (die ziet geen recepten op de pc). Het verhaal achter elke regel: `docs/CLAUDE_HISTORIE.md`.
Welke routines er zijn, met ID, tijd en bestand: `docs/REGIE.md`, tabel 1. Repo = `<repo>` hieronder.

## 1. Eerst ophalen, dan pas praten

1. **`git -C "<repo>" status` eerst.** Een lege pull bewijst niets: werk kan op schijf staan zonder commit.
2. **Staat een wachter-bestand gewijzigd-maar-ongecommit, met een nieuwe `- [JJJJ-MM-DD]`-regel onderaan?** Commit alléén
   dat bestand (`stage.txt` + `git_stage.py`), boodschap *"Commit the «wachter» watcher's entry of «datum», left
   uncommitted on disk"*. Pas dan pullen: met een vuile working tree weigert `pull --rebase`.
   Iets anders (een halve regel, een wijziging midden in het bestand): melden, niet committen.
3. **`git -C "<repo>" pull --rebase`.** (GEMETEN 11 nov: mét `origin main` erachter gaf git "Cannot rebase onto multiple
   branches"; zonder werkte het.)
4. **Conflict in zo'n bestand?** Houd beide regels: eerst de gepushte, dan de lokale, lege regel ertussen. Markeringen
   weg, `git_stage.py`, dan `git -C "<repo>" -c core.editor=true rebase --continue` (zonder `-c` opent een editor).
5. **Duikt er weer een wees-regel op?** Dan is er een nieuwe lokale schrijver: kijk in `C:\Users\RobHu\Claude\Scheduled\`
   en in `%APPDATA%\Claude\logs\main*.log` (Cowork-taken staan niet in `list_scheduled_tasks`).
6. **Routines opruimen of wijzigen: altijd met ID en plek**, nooit alleen de naam. Cloud-routines en oude Cowork-taken
   hebben bijna dezelfde namen; op 12 sep zijn daardoor de verkeerde verwijderd.

## 2. Lezen wat er vannacht kwam

7. **Blok 0 van `docs/REGIE.md`** eerst: het verslag van de regisseur.
8. **De vier wachter-bestanden:** `docs/API_WATCH.md`, `docs/PTR_12.1_WATCH.md`, `docs/PTR_12.0.7_DATA.md`,
   `docs/CONTENT_WATCH.md` (sinds 11 nov elk met een Forever-deel, regels in `docs/WATCHER_FOREVER.md`; dat bestand
   alleen met Robs ja wijzigen). Nieuws = `[MOET GEFIKST]`, `[RAAKT ONS]` of "nakijken".
9. **De laatste regel van `docs/NACHTCONTROLE.md`.** Staat de snapshot achter: `run event_snapshot --write`.
10. **Op maandag:** de voorstellen van de ideeënbus (onderaan `docs/IDEEEN.md`) naar Open of Nee verplaatsen; Rob beslist.
11. **Geen regel van vandaag = "heeft nog niet gedraaid"**, nooit "niets gevonden". Dat is hier al drie keer verkeerd
    om gelezen.
12. **Is het nieuwste dat een wachter zag ouder dan wat hij gisteren al noemde, dan keek hij naar een cache** (Exa geeft
    soms een week oude pagina; daarom `?nocache=JJJJMMDD` achter elke Exa-URL).
13. De wachters melden alleen en repareren nooit; elk schrijft precies één bestand.

## 3. Mensen, addons, bronnen (altijd via `probe_job.txt`, `_probe.py` zonder argumenten)

14. **`run gh_inbox`**: CurseForge-reacties en GitHub. **Een 🔴 WAITING FOR AN ANSWER meld je Rob altijd**, ook als de rest
    "niets" is. Beantwoord = Rob (twelveinchy) reageerde met *Reply* in dat draadje; een losse nieuwe reactie telt niet.
15. **`run addon_updates`**: Robs andere addons, Midnight én Forever. Jij oordeelt of iets MH raakt (taint, markers,
    secret values, TomTom, DBM, JustAC). Lezen is geen testen: zeg dat erbij. **Een 🔔 (uit op elk character, nieuwe
    versie) meld je altijd**, met wat de maker veranderde (geen changelog in de map → CurseForge). Rob wil per addon één
    zin, in het Nederlands, over wat er voor hém veranderde.
16. **`run handynotes_watch`**: wat er in HandyNotes veranderde. Leg het naast MH's eigen data (kisten, rares, schatten,
    Codex-{WAY}) en neem over wat beter is. Rob: HandyNotes is "meestal de beste bron van allemaal".
    Daarna **`run zygor_watch`** (sinds 11 nov): wat er in de Zygor-gidsen veranderde, Midnight (MID-bestanden in detail)
    en Forever (alles). Leg npc/quest/coördinaten naast MH's data (mounts, achievements, rares, Forever-trainers). Kopie
    staat in `%LOCALAPPDATA%\MidnightHelper\zygor_snapshot`. Twijfel of hij nog iets ziet: `run zygor_watch --selftest`.
17. **De site-mail:** Gmail-connector, `search_threads` met `subject:(MH feedback OR MH vragenlijst) newer_than:3d`.
    `[MH feedback]` altijd melden; `[MH vragenlijst]` bijtellen in `docs/SURVEY_RESULTS.md`. Robs eigen tests tellen niet.
    Alleen lezen: nooit antwoorden, labelen of archiveren.
18. **De vragen van de site-chat:** `C:\Users\RobHu\Downloads\midnighthelper-site\drafts\BOUW_VRAAG.md` (alleen lezen).
    Een open vraag beantwoord je in `docs/SITE_SEIN.md`. Ontbreekt het bestand of staat het achter: melden.
    (En los van de ronde: elke nieuwe functie, tag of CurseForge-upload krijgt een regel in `SITE_SEIN.md`, in dezelfde commit.)

## 4. Vertellen

19. **Vertel Rob alleen wat hém raakt**, in eenvoudig Nederlands. Meestal is dat "niets": zeg dat dan, mét wat je gelezen
    hebt, zodat stilte te onderscheiden is van niet-kijken.

Ook goed om te weten: de regisseur draait om 08:15, en Home Assistant start hem eerder zodra Rob wakker is (knop
"Regisseur nu" op dashboard MH HQ). Geeft HA een 401, dan is de sleutel fout of verlopen: Rob maakt een nieuwe op
claude.ai → Routines → MH regie → API-trigger.
