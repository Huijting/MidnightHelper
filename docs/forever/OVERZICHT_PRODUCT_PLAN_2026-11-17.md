# Plan — het overzicht wordt hét Midnight Helper voor Forever, 17 nov 2026

Rob (via Sparring 17-11), letterlijk: *"hoe gaan we de rest van onze Midnight helpen, in ieder geval voor Forever al,
hierin verwerken?"* en *"Je moet gewoon één mooi product maken. En als je over twijfelt wat dat is, zoek het allemaal
goed uit."* Op het voorstel hieronder en "zal ik de bouwchat met stap 1-3 laten beginnen? De rest volgt in dezelfde
volgorde": *"ja doe maar"*.

Dit is de uitwerking van stap 5 in `HUISSTIJL_PLAN_2026-11-17.md` ("elke tab in deze stijl"). Eén look: A (B is op
Robs woord vervallen).

## Inventaris (mh-research Opus, 17 nov, alleen gelezen; GEMETEN in code tenzij anders)
- ~15 losse Forever-vensters. `/mh`, Alt+M (Bindings.xml), minimap-links (Broker.lua:17/407), compartiment, snelbalk-MH
  (QuickBar.lua:213) openen allemaal het OUDE hoofdvenster (Core.lua:4402). `/mh overview` stond bewust niet in de
  commandolijst.
- Minimap-middenklik roept de consumable-borden aan, die niet in de Forever-toc staan (doet niets, tooltip belooft het
  wel — AFGELEID).
- "Now" in het overzicht gebruikt eigen NowItems, niet ForeverDoNow `Collect()` → mist oude rangen, wapens, buffs,
  gereedschap, spells-zonder-balk, stat-tips, volgend talent.
- Tabs: 104 px, stap 108, vanaf 40 px rechts, venster 920 → 7 tabs passen niet naast titel + dock (AFGELEID).

## Indeling: 7 tabs + tandwiel
1. **Now** — de volledige "Do this now"-lijst uit ÉÉN functie (kaart en mini-venster zeggen hetzelfde), een actieknop
   per regel, Komt eraan, Pad, kaartje "Deze week" + geld; kaarten klikbaar naar detailpagina's Trainer, Camping, (Legacy).
2. **Je class** — How you play + Class quests (schakelaar bovenaan).
3. **Vinden** — class trainer, beroepstrainers, wapenmeesters, gereedschap/General Goods: vervangt 4 vensters
   (ForeverProfTrainers, ForeverVendors, ForeverWeapons, trainer-zoeker); dichtstbijzijnde eerst, Show the way + reisstap.
4. **Beroepen** — jouw beroepen + skill, beroepskaart (ForeverProfGuide), gereedschap, uitleg tooltipregels
   Used for/ToolGuard met schakelaars.
5. **Dungeons & groep** — ForeverDungeons met Route, raid-locks, groepspaneel aan/uit, markeerbalk.
6. **Toetsen & macros** — toetsenhub-deuren, ForeverMacros-rijen met Maak, schakelaars (mouseover, oude-rang-rand,
   layout meenemen); het toetsenblok blijft een eigen venster.
7. **Karakters** — ForeverChars, Legacy (verhuist hierheen), volledige "Deze week".
- **Tandwiel**: instellingen in dezelfde stijl per tab + pagina "Wat MH stil voor je doet" (alle tooltips/meldingen/
  knoppen bij Blizzard-vensters met één zin + schakelaar) + link naar het Blizzard-paneel.
- Wat op het moment zelf moet (tooltips, Train all, oude-rang-knop, questbeloning, buff-icoon, waarschuwingen, pijl,
  groepspaneel) blijft waar het is.

## Bouwvolgorde
1. (klein) **Voordeur**: in Forever openen `/mh`, Alt+M, minimap-links, compartiment en snelbalk-MH het overzicht;
   `/mh overview` in de commandolijst; minimap-middenklik + tooltip Forever-proof; tabs op een eigen rij onder de titel.
2. (middel) **Eén Now-lijst**: het overzicht leest dezelfde lijst als ForeverDoNow (`Collect`), met actieknoppen;
   "Deze week" + geld; het mini-venster krijgt "Open overzicht" en blijft optioneel (auto/altijd/uit).
3. (middel) **Trainer-detailpagina** (toets per spell, kosten, Go); een level-up opent die pagina (bestaande schakelaar
   blijft).
4. Vinden (groot). 5. Toetsen & macros. 6. Beroepen. 7. Dungeons & groep. 8. Karakters (+ Legacy). 9. Tandwiel +
   "Wat MH voor je doet". 10. Opruimen oude Forever-takken (HomeDashboard/RoomLauncher/ToolsLaunchpad) — ALLEEN na
   Robs test.
- Deze opdracht = 1-3; daarna 4-9 in dezelfde volgorde; 10 pas na Robs test.

## Regels
- Oude open-functies en slash-commando's blijven werken en openen de juiste tab/pagina (geen commando breekt).
- Alles in 8 talen; testregels in TESTLIJST; lint 0 HARD; geen /reload-gevaarlijke halve staat pushen.
- Na elke stap één regel naar de sparring-chat.
- Midnight (retail): pas na Forever, als proef één scherm.
