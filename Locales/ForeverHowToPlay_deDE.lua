local _, ns = ...
-- German "How you play" for WoW Forever (translated 7 Nov 2026 from Modules/ForeverHowToPlay.lua by mh-writer;
-- game names measured in docs/forever/CLIENT_NAMES_FOREVER_2026-11-07.md). Same sections, same order.
if not ns.IS_FOREVER then
	return
end
if GetLocale() ~= "deDE" then
	return
end
ns.FOREVER_HOWTOPLAY_L = ns.FOREVER_HOWTOPLAY_L or {}
ns.FOREVER_HOWTOPLAY_L.deDE = {
	COMMON = {
		{ "Bevor du anfängst", [[
- Die Tasten gehen davon aus, dass MHs Tastenblock platziert ist: /mh block, dann Schritt 1 und 2.
- **Zauberränge.** Die meisten Zauber gibt es in Rängen: Rang 1, Rang 2 und so weiter. Ein höherer Rang ist derselbe Zauber, nur stärker. Neue Ränge kaufst du bei deinem Klassenlehrer, wenn du aufsteigst. Du musst nichts austauschen: MHs Tasten wirken einen Zauber über seinen Namen, und das Spiel nimmt den höchsten Rang, den du kennst.
- **Eine Taste, auf der noch nichts liegt,** behält ihren Platz. Sie füllt sich, sobald du den Zauber lernst. Erscheint ein neuer Zauber nicht? Öffne den Tastenblock (/mh block) und drück **Aktualisieren (neue Zauber)**.
- **Talentzauber** bekommen auch eine Taste. Wählst du das Talent nie, bleibt die Taste leer. Das ist in Ordnung.
- **Mana** ist der blaue Balken unter deiner Gesundheit. Die meisten Zauber kosten Mana. Ist er leer, kannst du nicht zaubern.
- **Abklingzeit** = die Wartezeit, bevor du einen Zauber wieder drücken kannst.
- Feste Tasten, für jede Klasse gleich: **T** = Trank, **Shift-T** = Gesundheitsstein, **G** = Schmuck.]] },
		-- not measured: The Great Outdoors
		{ "Lager aufschlagen", [[
- **Lager aufschlagen** ist kein Beruf. Jeder Beruf kann ein **Lagerelement** herstellen. Kochkunst stellt das Feuer her.
- **Los geht's** mit der Quest **The Great Outdoors**, in jedem Startgebiet.
- **1. Das Feuer.** Stell mit Kochkunst ein **Einfaches Lagerfeuerset** her: 1 Einfaches Holz, mit **Feuerstein und Zunder** als Werkzeug (das behältst du). Benutze das Set im Freien, nicht im Kampf. Das Feuer hat Platz für 3 Elemente (Lagerfeuer des Gesellen 5, Expertenlagerfeuer 10). Abklingzeit: 5 Minuten.
- **2. Ein Element.** Stell es mit deinem Beruf her. Du brauchst Fertigkeit 20, um es aufzustellen. Stell es in der Nähe des Feuers auf. Der Gegenstand wird verbraucht.
- **3. Setz dich** in die Nähe des Feuers. Du bekommst **Einladendes Lagerfeuer** für 60 Sekunden. Du darfst herstellen, aber nicht laufen. Danach bekommst du **Lagervorteile** für 1 Stunde, mit einer Zeile pro Element.
- **Regeln:** Alle Elemente teilen sich eine Abklingzeit von 1 Stunde. Jede Art von Element nur einmal pro Lager.
- **Konflikte:** Du kannst einen Lager-Buff und den unten genannten Klassen-Buff nicht gleichzeitig haben. Die meisten Lager-Buffs wachsen mit deiner Stufe.
- Kürschnerei: **Lagerstuhl** = kritische Trefferchance. Verträgt sich nicht mit Aura des Moonkin.
- Schmiedekunst: **Schleifstein** = Stärke. Verträgt sich nicht mit Totem der Erdstärke.
- Kräuterkunde: **Räucherkerze** = Intelligenz. Verträgt sich nicht mit Arkane Intelligenz.
- Alchimie: **Manabrunnen** = Mana alle 5 Sekunden. Verträgt sich nicht mit Segen der Weisheit.
- Bergbau: **Leitstein** = Nahkampfangriffskraft. Verträgt sich nicht mit Segen der Macht.
- Angeln: **Fischglas** = alle Werte. Verträgt sich nicht mit Segen der Könige.
- Erste Hilfe: **Verbandtasche** = Ausdauer. Verträgt sich nicht mit Machtwort: Seelenstärke.
- Schneiderei: **Fraktionsbanner** = Willenskraft, nur für deine eigene Fraktion. Verträgt sich nicht mit Göttlicher Willen.
- Verzauberkunst: **Verzauberte Laute** = Rüstung, alle Werte und Widerstände. Verträgt sich nicht mit Mal der Wildnis.
- Lederverarbeitung: **Lagerzelt** = ruh dich 30 Sekunden in seiner Nähe aus, für zusätzlichen Ruhebonus, einmal pro Stunde.
- Ingenieurskunst: **Materialbot** = kein Buff, er verkauft Reagenzien.
- **/mh camp** zeigt, was MH von deinen Lager-Buffs lesen kann.]] },
		-- not measured: Innkeeper Wiley, Scarce
		{ "Vermächtnispunkte", [[
- **Vermächtnispunkte** verdient dein ganzer Account: 65 Herausforderungen, je 1 Punkt. Jeder Charakter gibt seine eigenen Punkte aus, vorerst bis zu 16.
- **So verdienst du sie:** Eine Klasse erreicht zum ersten Mal Stufe 25, 45 und 60. Alchimie, Schmiedekunst, Verzauberkunst, Ingenieurskunst, Lederverarbeitung und Schneiderei bei 150, 225 und 300. Ein paar weitere für PvP, Dungeons, Schlachtzüge und Erkunden.
- Sammelberufe, Kochkunst, Erste Hilfe und Angeln geben keine Punkte.
- Das Fenster öffnet sich mit deinem ersten Punkt. Für die meisten Spieler ist das auf Stufe 25.
- **Ausgeben:** Drück den Knopf **Klassisch** in der Menüleiste. Es gibt drei Bäume: **Berufe**, **Abenteuer** und **Einfallsreichtum**. Jeder Rang kostet 1 Punkt.
- **Spalte 2** öffnet sich nach 5 Punkten in diesem Baum, **Spalte 3** nach 10.
- **Rückgängig:** bei deinem Klassenlehrer, alle Perks auf einmal. Der Lehrer zeigt den Preis. Hast du Talentiert? Dann verlerne zuerst deine Klassentalente.
- **Belohnungen** bei 15, 25, 40 und 55 verdienten Punkten (verdient, nicht ausgegeben). Hol sie bei **Innkeeper Wiley** in Ratchet ab.
- **Beispiel, Leveln:** **Gut ausgeruht** (Ruhebonus baut sich schneller auf), dann **Talentiert** (braucht Gut ausgeruht): Talentpunkte bis zu 5 Stufen früher, nie mehr als 51 insgesamt.
- **Beispiel, Berufe:** **Überstunden machen** (mehr Fertigkeitsaufstiege) und **Reiche Ernte** (Scarce-Materialien öfter aus Bergbau, Kräuterkunde und Kürschnerei).
- **Engagiertes Studium** ist ein Knopf, kein passiver Perk: 25 Sekunden Zauberzeit, dann 23 Stunden warten. Es erhöht deinen niedrigsten Beruf um 1.
- **/mh legacy** zeigt, wie viele Punkte MH lesen kann.]] },
		-- 21 Nov 2026: new 4th section (mh-writer). Measured DB2 deDE 1.60.1.71037: TALENT_SPEC_SECONDARY "Sekundäre Talente",
		-- spell 63624 "Zweite Talentspezialisierung erlernen" (no separate "Dual Spec" word in the client), TalentTab.
		-- TalentTab 282 reads "Wiederherst" (cut short in DB2); the full word Wiederherstellung is used, as elsewhere in this file.
		{ "Talente: zurücksetzen und zweite Spezialisierung", [[
- **Talente zurücksetzen** geht bei deinem Klassenlehrer: Sprich ihn an und wähl die Talent-Option. Dann verteilst du deine Punkte neu. Spieler sagen, es kostet beim ersten Mal 1 Gold, dann 5, dann 10 und danach mehr. Blizzard sagt, der Preis steigt schnell und sinkt einmal pro Woche.
- **Zweite Talentspezialisierung:** Ab Stufe 40 verkauft dein Klassenlehrer einen zweiten Satz Talente. Im Spiel heißt er **Sekundäre Talente**. Spieler sagen, sie kostet 50 Gold; Blizzard hat keinen Preis genannt.
- **Wechseln** zwischen deinen zwei Sätzen dauert 5 Sekunden und geht nicht im Kampf.
- **Deine Leisten nach einem Wechsel:** Spieler berichten, dass ein Wechsel deine Aktionsleisten verändern kann: Das Spiel kann Zauber darauflegen, über deine eigenen Knöpfe und Makros. MH hat das selbst nicht im Spiel gesehen. Prüf deine Aktionsleisten nach dem ersten Wechsel.
- **Wozu:** Mit einem Satz levelst du, mit dem anderen tankst oder heilst du. Ein Paladin levelt als Vergeltung und tankt als Schutz, ein Druide levelt als Katze und heilt als Wiederherstellung.]] },
	},
	-- 21 Nov 2026: "Level as X, tank as Y" (mh-writer, from ForeverHowToPlay.lua PLANS). Names measured DB2 deDE
	-- 1.60.1.71037 (SpellName, TalentTab, Map, GlobalStrings); Wolfsbann and Archibald from Wowhead Forever deDE.
	PLANS = {
		PALADIN = { title = "Als Vergeltung leveln, als Schutz tanken", body = [[
- **Leveln:** Die Guides nennen Vergeltung den schnellsten Weg, allein zu leveln: eine langsame **Zweihandwaffe** und Siegel der Rechtschaffenheit, später Siegel des Befehls (20, ein Talent). Gib deine Talentpunkte in Vergeltung aus.
- **Einen Dungeon tanken** geht ab deinem ersten, ohne die Talente neu zu verteilen: Ragefireabgrund für die Horde (ab Stufe 13), die Halle der Thanen für die Allianz (etwa 13). Zorn der Gerechtigkeit und Siegel des Furors kommen beide mit 10. Behalte eine **Einhandwaffe und einen Schild in deinen Taschen**. Vor dem Dungeon: Wechsle zu ihnen, schalte Zorn der Gerechtigkeit an (Block D) und leg Siegel des Furors an (**F**). Danach: zurück zur Zweihandwaffe, und Zorn der Gerechtigkeit aus (Rechtsklick darauf, oben rechts). Mit Zorn der Gerechtigkeit ziehst du die Gegner von deiner Gruppe weg.
- **Wann es leicht wird:** mit 30 durch Heiliger Schild (ein Schutz-Talent), und richtig mit 40 durch Schildgeschworen. Willst du das, brauchst du Schutz-Talente: Die **Zweite Talentspezialisierung** (ab 40) gibt dir einen zweiten Satz, so levelst du als Vergeltung und tankst als Schutz. Siehe „Talente: zurücksetzen und zweite Spezialisierung“ unten.
- **Werte zum Tanken:** zuerst Ausdauer. Die Guides sind sich uneinig, was danach kommt: wowforeverbuilder sagt Verteidigung, Ausdauer, Zaubermacht, Intelligenz (keine Stärke), ein anderer Guide stellt Zaubermacht und Intelligenz über Stärke. Mit Zaubermacht halten Weihe und Heiliger Schild die Gegner besser.
- **Zweihandschwert aus Wolfsbann** (die Klassenquest der Untoten mit 20): Lern zuerst Zweihandschwerter, bei Archibald in Undercity. MH sagt es dir in Mach das jetzt.]] },
		WARRIOR = { title = "Als Krieger leveln und tanken", body = [[
- **Leveln:** Die Guides sind sich uneinig. Die meisten sagen, Schutz levelt am schnellsten: eine Zweihandwaffe bis Rache mit 14, dann eine **Einhandwaffe und einen Schild**. Ein Guide findet Schutz allein langsamer. Waffen oder Furor gehen auch; dann behalte eine Einhandwaffe und einen Schild zum Tanken in deinen Taschen.
- **Einen Dungeon tanken** geht ab deinem ersten: Ragefireabgrund (Horde) ab Stufe 13, die Halle der Thanen (Allianz) ab etwa 13, die Todesminen ab 16, die Höhlen des Wehklagens ab 17. Die Klassenquest mit 10 gibt dir Verteidigungshaltung, Spott und Rüstung zerreißen. In Forever macht Verteidigungshaltung viel mehr Bedrohung als im alten Spiel, also bleiben die Gegner bei dir.
- **Wann es leicht wird:** mit 14-16 durch Rache und Schildblock, und richtig mit 40 durch Schildschlag (ein Talent) und Plattenpanzer.
- **Talente:** Mit Schutz-Talenten levelst und tankst du mit einem Satz. Hast du als Waffen oder Furor gelevelt? Dann gibt dir die **Zweite Talentspezialisierung** (ab 40) einen zweiten Satz zum Tanken. Siehe „Talente: zurücksetzen und zweite Spezialisierung“ unten.
- **Werte zum Tanken:** zuerst Ausdauer. Beim Rest sind sich die Guides uneinig: Einer stellt Verteidigung ans Ende, ein anderer will Verteidigung früh auf 440. Für Bedrohung: Trefferwert und Waffenkunde.]] },
		DRUID = { title = "Als Druide leveln und tanken", body = [[
- **Leveln:** Die Guides nehmen Wilder Kampf: den Bären ab Stufe 10, die Katze ab 20. Talente in Wilder Kampf wirken für beide, also levelst du als Katze und tankst als Bär mit denselben Talenten. Du brauchst keinen Schild und keine zweite Waffe.
- **Deine Waffe zählt in einer Gestalt.** Blizzard: In Bärengestalt und Katzengestalt machen deine normalen Treffer den Schaden der Waffe, die du hältst. Behalte also den besten zweihändigen Stab oder Streitkolben, auch zum Tanken.
- **Einen Dungeon tanken** geht ab deinem ersten: Ragefireabgrund für die Horde (ab Stufe 13), die Halle der Thanen für die Allianz (etwa 13). Bärengestalt kommt aus der Klassenquest mit 10, mit Knurren und Zermalmen (ein Guide sagt nur Zermalmen: Prüf deine Zauber). In Forever macht Bärengestalt viel mehr Bedrohung als im alten Spiel.
- **Wann es leicht wird:** Prankenhieb mit 16 (mehr Gegner auf einmal), Aufschlitzen mit 25 (ein Talent), und richtig mit 40 durch Terrorbärengestalt und Urtümlicher Biss (ein Talent).
- **Heilen in einer Gruppe?** Dafür brauchst du Wiederherstellungs-Talente und Ausrüstung mit Intelligenz: Die **Zweite Talentspezialisierung** (ab 40) gibt dir einen zweiten Satz. Siehe „Talente: zurücksetzen und zweite Spezialisierung“ unten.
- **Werte zum Tanken:** Die Guides sind sich uneinig. Zum Überleben: Rüstung, dann Verteidigung bis 440, dann Ausdauer, dann Beweglichkeit. Für Bedrohung: Waffenschaden, dann Beweglichkeit, dann Stärke. Ein anderer Guide sagt beim Leveln: Waffenschaden, Stärke, Beweglichkeit.]] },
	},
	DRUID = {
		{ "Was er kann", [[
Der Druide kann seine Gestalt wechseln. Als normaler Zauberwirker wirft er Zauber und heilt. Später kann er sich in einen Bären oder eine Katze verwandeln, um im Nahkampf zu kämpfen. Der Bär hat einen Spott (Knurren), also ist er die Gestalt zum Tanken.
Eine **Gestalt** ist eine dieser Formen. In einer Gestalt machen viele deiner Tasten etwas anderes. MHs Tasten wechseln von selbst: Dieselbe Taste ist als Zauberwirker ein Zauber und als Bär ein anderer.]] },
		{ "Stufe 1-10: deine Tasten", [[
- **1** = Zorn (Stufe 1): dein wichtigster Angriffszauber.
- **2** = Mondfeuer (4): Schaden, dann noch mehr Schaden über ein paar Sekunden.
- **C** = Heilende Berührung (1): deine große Heilung.
- **F4** = Verjüngung (4): eine Heilung, die dich nach und nach heilt.
- **Shift-X** = Mal der Wildnis (1): ein Buff. Ein **Buff** ist ein guter Effekt auf dir oder einem Freund. Leg ihn vor einem Kampf an.
- **Shift-Z** = Dornen (6): noch ein Buff.
- **V** = Wucherwurzeln (8): hält einen Gegner an seinem Platz fest.
- **X** = Griff der Natur (10).
- **Shift-E** = der Zauber deines Volkes (Nachtelf: Schattenmimik, Tauren: Kriegsdonner).
- **Stufe 10, Bärengestalt** (aus einer Quest): **Ctrl-1** verwandelt dich in einen Bären. Als Bär: **1** = Zermalmen, **F** = Knurren, **Shift-2** = Demoralisierendes Gebrüll.]] },
		{ "Einfache Reihenfolge (Zauberwirker)", [[
Mondfeuer (2) zuerst, dann Zorn (1), bis der Gegner tot ist. Wenig Gesundheit? Verjüngung (F4) oder Heilende Berührung (C).]] },
		{ "Was später kommt", [[
- 12: Nachwachsen auf F2 (schnelle Heilung). Wiederbelebung (ab Rang 2: Wiederbeleben) auf F3: holt einen toten Freund zurück, nur außerhalb eines Kampfes.
- 16: Wassergestalt (aus einer Quest) auf R, während du schwimmst. 18: Feenfeuer auf 5 (wirkt in den meisten Gestalten, aber nicht in Reisegestalt oder Wassergestalt), Winterschlaf auf Shift-Q.
- 20: Katzengestalt (aus einer Quest) auf Ctrl-2, mit Klaue, Schreddern, Zerfetzen und Schleichen. Wilde Attacke auf E (ein Talent, frühestens 20). Sternenfeuer auf 3. Im Kampf wird F3 zu Wiedergeburt.
- 30: Reisegestalt auf R (zum Reisen), Gelassenheit auf Q. 40: Terrorbärengestalt (ersetzt Bärengestalt auf Ctrl-1), Anregen auf F1.
- 44: Baumrinde auf Z, in jeder Gestalt.]] },
		{ "Anfängerfehler", [[
- Eine Heilung drücken, während du in einer Gestalt bist. Deine Heilungen wirken nur in deiner normalen Gestalt, nicht in Bärengestalt, Katzengestalt, Wassergestalt oder Reisegestalt. Verlass zuerst die Gestalt: Drück dieselbe Gestalt-Taste noch einmal (Ctrl-1 für den Bären, Ctrl-2 für die Katze).
- In Moonkingestalt (ein Talent, frühestens Stufe 40) wirken deine Angriffszauber, deine Heilungen aber nicht.
- Was in einer Gestalt funktioniert: Tränke, Baumrinde, Griff der Natur, Feenfeuer und der Zauber deines Volkes.]] },
	},
	PALADIN = {
		{ "Was er kann", [[
Der Paladin ist ein heiliger Kämpfer. Er schlägt im Nahkampf zu, heilt sich und andere und beschützt Freunde. Er hat keine Gestalten und keine Haltungen, also macht jede Taste immer dasselbe.
Ein **Siegel** ist eine heilige Kraft, die du auf dich legst. Es hält 30 Sekunden, und du kannst nur eins gleichzeitig haben. Eine **Aura** ist eine Kraft, die du einschaltest und anlässt; sie hilft deiner ganzen Gruppe. Ein **Segen** ist ein Buff, den du auf dich oder einen Freund legst; er hält 60 Minuten. Ein **Buff** ist ein guter Effekt.]] },
		{ "Siegel und Auren", [[
- **Siegel der Rechtschaffenheit** (1): Jeder Treffer macht zusätzlichen Heiligschaden. Eine langsame Waffe macht mehr pro Treffer.
- **Siegel des Kreuzfahrers** (6, eigene Alt-Taste): Du schlägst schneller zu, aber jeder Treffer macht weniger.
- **Siegel des Furors** (10): das Tank-Siegel. Mit einem Schild gibt dir jeder Treffer auch einen kleinen Schutzschild.
- **Siegel des Befehls** (Talent, frühestens Stufe 20): Treffer machen manchmal einen großen zusätzlichen Heiligtreffer. Sobald du es hast, wirkt Taste 3 dieses Siegel statt Siegel der Rechtschaffenheit.
- **Siegel der Gerechtigkeit** (22), **Siegel des Lichts** (30), **Siegel der Weisheit** (38), alle auf deinen eigenen Alt-Tasten: Treffer betäuben manchmal, heilen dich oder geben dir Mana.
- **Aura der Hingabe** (1): mehr Rüstung für deine Gruppe. **Aura der Vergeltung** (16): Heiligschaden an alles, was deine Gruppe trifft. **Aura der Konzentration** (22): Zauberwirker in deiner Gruppe werden seltener unterbrochen, wenn sie getroffen werden.]] },
		{ "Stufe 1-10: deine Tasten", [[
- **3** = Siegel der Rechtschaffenheit (Stufe 1): dein Siegel.
- **C** = Heiliges Licht (1): deine große Heilung. Untote Paladine bekommen es aus der Quest „Das Licht wiederentdecken“ auf Stufe 2.
- **Ctrl-1** = Aura der Hingabe (1, vom Lehrer): einschalten und anlassen.
- **2** = Richturteil (4): Abklingzeit 10 Sekunden. Es verbraucht dein Siegel nicht. Es wirkt nur, solange ein Siegel aktiv ist: leg zuerst dein Siegel an (3).
- **Shift-Z** = Segen der Macht (4): Leg ihn auf dich selbst.
- **1** = Heiliger Stoß (6): dein wichtigster Treffer im Nahkampf.
- **Z** = Göttlicher Schutz (6): 6 Sekunden lang kann dir nichts schaden, aber du kannst auch nicht angreifen. Abklingzeit 5 Minuten.
- **E** = Hammer der Gerechtigkeit (8): betäubt den Gegner. Eine **Betäubung** heißt: Der Gegner kann sich ein paar Sekunden lang nicht bewegen und nicht zaubern. Der Paladin hat keine echte Unterbrechung, also ist das deine „Stopp diesen Zauber“-Taste.
- **Shift-C** = Läutern (8): entfernt einen schlechten Effekt von einem Freund.
- **Q** = Handauflegung (10): dein Notfallknopf. Es heilt einen Freund (oder dich) auf volle Gesundheit, verbraucht aber dein ganzes restliches Mana. Abklingzeit 20 Minuten.
- **Shift-F** = Segen des Schutzes (10): rettet einen Freund, der in Not ist.
- **F** = Siegel des Furors (10): ein Siegel zum Tanken. Sein Richturteil wirkt als Spott. **Spott** = den Gegner dazu bringen, dich anzugreifen.]] },
		{ "Einfache Reihenfolge", [[
Siegel (3) vor dem Kampf. Dann Heiliger Stoß (1) und Richturteil (2), sobald sie bereit sind. Leg das Siegel neu an, wenn es ausläuft (es hält 30 Sekunden). Wenig Gesundheit? Heiliges Licht (C).]] },
		{ "Was später kommt", [[
- 12: Erlösung (aus einer Quest) auf F3 (holt einen toten Freund zurück; nicht im Kampf). 14: Segen der Weisheit auf Shift-V.
- 18: Segen der Freiheit auf R (eine Weile kann dich nichts verlangsamen). 20: Weihe auf Shift-1 (trifft mehrere Gegner auf einmal), Exorzismus auf 5, Lichtblitz auf F2 (schnelle Heilung), Segen der Könige auf Shift-X.
- 30: Göttliches Eingreifen: Im Kampf wirkt F3 dieses statt Erlösung. Achtung: Du stirbst dabei selbst; der Freund, den du wählst, ist kurz vor allen Angriffen sicher. 34: Gottesschild auf Z: 10 Sekunden, in denen dir nichts schaden kann, und du kannst trotzdem kämpfen (mit halbem Schaden).
- 42: Reinigung des Glaubens ersetzt Läutern auf Shift-C. 44: Hammer des Zorns auf 4 (nur wenn der Gegner 20 % Gesundheit oder weniger hat).
- 52-60: In einer Gruppe wirken die Segen-Tasten den Großen Segen für die ganze Gruppe; allein wirken sie den normalen.]] },
		{ "Anfängerfehler", [[
- Exorzismus (5) auf einen normalen Gegner drücken. Er wirkt nur auf Untote und Dämonen. Untote vertreiben (Shift-Q, 24) wirkt nur auf Untote.
- Hammer des Zorns (4) früh im Kampf drücken. Er wirkt nur, wenn der Gegner fast tot ist (20 % Gesundheit oder weniger).
- Gottesschild und Göttlicher Schutz teilen sich eine Abklingzeit, deshalb liegen sie auf einer Taste (Z). Diese Schutzzauber, Segen des Schutzes und Bollwerk des Templers geben dir **Vorahnung**: 1 Minute lang kannst du keinen davon wieder bekommen. Handauflegung nicht.]] },
	},
	MAGE = {
		{ "Was er kann", [[
Der Magier steht hinten und wirkt Feuer-, Frost- und Arkanmagie. Er hält Gegner auf Abstand, mit Zaubern, die sie festhalten oder verlangsamen. Der Magier hat keine Gestalten und keine Haltungen, also macht jede Taste immer dasselbe.]] },
		{ "Stufe 1-10: deine Tasten", [[
- **1** = Feuerball (Stufe 1): dein wichtigster Angriffszauber.
- **Shift-Z** = Frostrüstung (1): ein Buff auf dir selbst. Leg ihn vor einem Kampf an. Du kannst nur eine Rüstung gleichzeitig aktiv haben.
- **Shift-X** = Arkane Intelligenz (1): ein Buff für dich oder einen Freund.
- **Ctrl-3** = Schießen: dein **Zauberstab** (ein kleiner magischer Stab, der von selbst schießt), sobald du einen hast. Praktisch, wenn dein Mana knapp ist. Wenn du Frostfeuerblitz lernst, nimmt er Ctrl-3; leg Schießen auf eine deiner eigenen Alt-Tasten, wenn du es noch willst.
- **2** = Frostblitz (4): Frostschaden.
- **5** = Feuerschlag (6): spontaner Feuertreffer. **Spontan** = keine Zauberzeit. Abklingzeit 8 Sekunden.
- **3** = Arkane Geschosse (8): Arkanschaden.
- **Shift-Q** = Verwandlung (8): nimmt einen Gegner eine Weile aus dem Kampf. So ein Zauber heißt **CC** (Crowd Control).
- **V** = Frostnova (10): friert jeden Gegner im Umkreis von 10 Metern um dich ein, bis zu 8 Sekunden lang. Schaden kann es brechen. Abklingzeit 25 Sekunden.
- Wasser herbeizaubern (4) und Essen herbeizaubern (6) liegen nicht auf dem Block. Sie kommen auf deine eigenen Alt-Tasten (Block D).]] },
		{ "Einfache Reihenfolge", [[
Frostblitz (2) oder Feuerball (1), während der Gegner herankommt. Feuerschlag (5), wenn er bereit ist. Gegner nah bei dir? Frostnova (V), geh ein Stück weg, zaubere weiter.]] },
		{ "Was später kommt", [[
- 12: Langsamer Fall auf Shift-R. 14: Arkane Explosion auf Shift-2 (trifft mehrere Gegner). 16: Flammenstoß auf Shift-4.
- 18: Geringen Fluch aufheben auf Shift-V. 20: Blinzeln auf R (dein Bewegungszauber), Blizzard auf Shift-1, Hervorrufung auf F1 (holt Mana zurück), Manaschild auf Z, Feuerzauberschutz auf F4. Außerdem die Teleports (und später Portale): Reisezauber, nicht auf dem Block. Leg sie auf deine eigene Leiste oder nutz sie aus deinem Zauberbuch.
- 22: Versengen auf Ctrl-1, Frostzauberschutz auf F2. 24: Gegenzauber auf E: deine **Unterbrechung** (sie stoppt den Zauber eines Gegners).
- 26: Kältekegel auf Shift-F. 30: Eisrüstung: Shift-Z wirkt ab dann diese statt Frostrüstung (sie schützt dich auch gegen Frost).
- Talente ab Stufe 20: Pyroschlag auf 4, Eislanze auf F, Arkanschlag auf Ctrl-2, Eisblock auf C (frühestens 25).]] },
		{ "Anfängerfehler", [[
- Beide Zauberschutze gleichzeitig erwarten. Feuerzauberschutz (F4) und Frostzauberschutz (F2) teilen sich eine Abklingzeit von 30 Sekunden, also nur einer auf einmal.
- Magische Rüstung und Eisrüstung zusammen tragen. Nur eine Rüstung kann gleichzeitig aktiv sein. Magische Rüstung (34) liegt auf Block D.]] },
	},
	HUNTER = {
		{ "Was er kann", [[
Der Jäger schießt aus der Ferne mit einer Fernkampfwaffe und hat ab Stufe 10 einen **Begleiter**: ein Tier, das du zähmst und das neben dir kämpft. Aus der Nähe hat er ein paar Nahkampftreffer.
**Automatischer Schuss** = deine Waffe schießt von selbst weiter, bis du aufhörst. **Nahkampf** = Kämpfen aus der Nähe. Der Jäger hat keine Gestalten und keine Haltungen, also macht jede Taste immer dasselbe.]] },
		{ "Stufe 1-10: deine Tasten", [[
- **1** = Automatischer Schuss (Stufe 1): fängt an zu schießen. MHs Taste ist so gebaut, dass ein zweiter Druck ihn nicht stoppt.
- **5** = Raptorstoß (1): dein Treffer, wenn der Gegner direkt neben dir steht.
- **2** = Schlangenbiss (4): Schaden über ein paar Sekunden.
- Aspekt des Affen (4) kommt auf deine eigenen Alt-Tasten (Block D). Ein **Aspekt** ist ein haltungsähnlicher Buff auf dir selbst. Nur ein Aspekt kann gleichzeitig aktiv sein.
- **3** = Arkaner Schuss (6): spontaner Schuss. Abklingzeit 6 Sekunden.
- **Shift-Z** = Mal des Jägers (6): Leg es einmal auf den Gegner.
- **Shift-Q** = Erschütternder Schuss (8): verlangsamt den Gegner.
- **Shift-R** = Aspekt des Falken (10): dein Hauptaspekt.
- **Stufe 10, Begleiter-Quests:** Du lernst Wildtier zähmen, Tier rufen und Tier freigeben; die Quest danach gibt Tier wiederbeleben und Tier füttern. **F4** = Tier rufen (holt deinen Begleiter), **F3** = Tier wiederbeleben (holt einen toten Begleiter zurück). Wildtier zähmen hat keine Taste; du nutzt es außerhalb eines Kampfes.
- Ab dann hat dein Begleiter drei Tasten: **Ctrl-1** = dein Ziel angreifen, **Ctrl-2** = dir folgen, **Ctrl-3** = bleiben, wo er ist.]] },
		{ "Einfache Reihenfolge", [[
Aspekt des Falken an (Shift-R). Begleiter zuerst hinein (Ctrl-1). Mal des Jägers (Shift-Z), Schlangenbiss (2), Automatischer Schuss (1), dann Arkaner Schuss (3), wenn er bereit ist. Gegner direkt neben dir? Raptorstoß (5).]] },
		{ "Was später kommt", [[
- 10: Tier füttern und Tier freigeben liegen nicht auf dem Block (du nutzt sie außerhalb eines Kampfes); leg sie auf deine eigene Leiste. Dasselbe gilt für Wildtier ängstigen (14).
- 12: Ablenkender Schuss auf F (der Gegner greift dich an), Tier heilen auf F2 (heilt deinen Begleiter), Zurechtstutzen auf Shift-F.
- 16: Feuerbrandfalle auf Shift-2, Mungobiss auf Shift-C (nur nachdem du ausgewichen bist). 18: Mehrfachschuss auf Shift-1.
- 20: Gezielter Schuss auf 4 (dein großer Schuss), Aspekt des Geparden auf R (schnell laufen), Rückzug auf Z, Eiskältefalle auf V.
- 26: Schnellfeuer auf Q. 30: Totstellen auf X, Aspekt des Wildtiers (Block D). 34: Sprengfalle übernimmt Shift-2.
- Alle vier Fallen teilen sich eine Abklingzeit von 30 Sekunden.]] },
		{ "Anfängerfehler", [[
- Auf einen Gegner direkt neben dir schießen. Deine Schusswaffe oder dein Bogen funktioniert innerhalb von 8 Metern nicht (die „tote Zone“): Nutz Raptorstoß (5) oder geh einen Schritt zurück.
- Erwarten, dass eine Taste weit schießt und nah zuschlägt. Ein Makro kann keine Entfernung sehen, deshalb hat der Nahkampf eigene Tasten (5, Shift-F, Shift-C).
- Tier heilen (F2) drücken, um dich selbst zu heilen. Es heilt nur deinen Begleiter. Der Jäger hat keine Selbstheilung.]] },
	},
	WARRIOR = {
		{ "Was er kann", [[
Der Krieger kämpft im Nahkampf mit einer Waffe. Er hat drei Haltungen, und ab Stufe 10 kann er tanken. Er heilt sich nicht selbst, außer mit Siegesrausch (Stufe 20).
Der Krieger hat **Wut** statt Mana. Du bekommst Wut, wenn du triffst und wenn du getroffen wirst. Außerhalb eines Kampfes sinkt deine Wut langsam auf 0.]] },
		{ "Haltungen", [[
Eine **Haltung** ist eine Kampfweise, die du mit einer Taste einschaltest. Du bist immer in einer Haltung. Manche Zauber wirken nur in einer oder zwei Haltungen. MHs Tasten wechseln von selbst: In einer anderen Haltung wirkt dieselbe Taste einen anderen Zauber. Hat eine Taste nichts für deine Haltung, macht sie nichts (keine Fehlermeldung).
- **Kampfhaltung** (1): deine Haltung für den normalen Kampf.
- **Verteidigungshaltung** (10, aus einer Quest): die Haltung zum Tanken. Nur hier hast du Spott.
- **Berserkerhaltung** (30, aus der Quest „Der Ringkampf“). Hier wird E zu Zuschlagen und R zu Abfangen.
- **Taktiker** (14, passiv, du tust nichts): Du behältst bis zu 10 Wut, wenn du die Haltung wechselst.
- Keine Taste wechselt deine Haltung von selbst. Du wählst die Haltung; die Tasten folgen.]] },
		{ "Stufe 1-10: deine Tasten", [[
- **1** = Heldenhafter Stoß (Stufe 1): dein wichtigster Treffer, in jeder Haltung.
- **Ctrl-1** = Kampfhaltung (1): einschalten und anlassen.
- **Shift-X** = Schlachtruf (1): ein Buff. Ein **Buff** ist ein guter Effekt auf dir oder einem Freund. Leg ihn vor einem Kampf an.
- **R** = Sturmangriff (4): Lauf zu einem Gegner, um einen Kampf zu beginnen. Er wirkt nur in Kampfhaltung, und nicht mehr, wenn du schon kämpfst.
- **Shift-Z** = Verwunden (4): ein **Blutungseffekt**: Schaden über ein paar Sekunden. Kampfhaltung und Verteidigungshaltung.
- **Shift-1** = Donnerknall (6): trifft mehrere Gegner auf einmal. Kampfhaltung und Verteidigungshaltung. Abklingzeit 6 Sekunden.
- **V** = Kniesehne (8): verlangsamt den Gegner 15 Sekunden lang stark. Kampfhaltung und Berserkerhaltung.
- **F1** = Blutrausch (10): gibt dir sofort Wut und über ein paar Sekunden noch etwas mehr. Es kostet ein wenig Gesundheit. Abklingzeit 1 Minute.
- **Stufe 10, Verteidigungshaltung** (aus einer Quest): **Ctrl-2** schaltet sie ein. Dieselbe Quest gibt dir **5** = Rüstung zerreißen (jede Haltung) und, in Verteidigungshaltung, **F** = Spott. **Spott** = den Gegner dazu bringen, dich anzugreifen. Abklingzeit 8 Sekunden.
- Bogenschuss, Schusswaffe abfeuern, Armbrust abschießen und Werfen kommen auf deine eigenen Alt-Tasten (Block D). Du bekommst den, der zu deiner Fernkampfwaffe passt. Nutz ihn zum **Pullen**: einen Gegner aus der Ferne treffen, damit er zu dir kommt.]] },
		{ "Einfache Reihenfolge", [[
Kampfhaltung an (Ctrl-1), Schlachtruf (Shift-X). Mit Sturmangriff (R) hinein. Verwunden (Shift-Z), dann immer wieder Heldenhafter Stoß (1). Mehrere Gegner? Donnerknall (Shift-1).]] },
		{ "Was später kommt", [[
- 12: Überwältigen auf 2 (Kampfhaltung; nachdem der Gegner ausgewichen ist), Schildhieb auf E: deine **Unterbrechung** (sie stoppt den Zauber eines Gegners).
- 14: Rache auf 2 (Verteidigungshaltung), Demoralisierender Ruf (ab Rang 2: Demoralisierungsruf) auf Shift-2. 16: Spöttischer Schlag auf F (Kampfhaltung), Schildblock auf Z (Verteidigungshaltung). 18: Entwaffnen auf V (Verteidigungshaltung).
- 20: Spalten auf Shift-4, Zerschmettern auf Shift-C, Siegesrausch auf F2 (nur in den 20 Sekunden, nachdem du einen Gegner getötet hast, der EP gibt; er heilt dich ein wenig; Abklingzeit 30 Sekunden), Gegenschlag auf C (Kampfhaltung). 22: Drohruf auf Shift-Q. 24: Hinrichten auf 4 (Kampfhaltung und Berserkerhaltung; nur wenn der Gegner 20 % Gesundheit oder weniger hat).
- 26: Herausforderungsruf auf Shift-F. 28: Schildwall auf C (Verteidigungshaltung).
- 30: Berserkerhaltung auf Ctrl-3. Darin: Abfangen auf R, Berserkerwut auf Shift-V. 36: Wirbelwind auf 2 (Berserkerhaltung). 38: Zuschlagen auf E (Berserkerhaltung). 50: Tollkühnheit auf Q (Berserkerhaltung).
- Talente: Letztes Gefecht auf X und Durchdringendes Heulen auf Shift-R (eine Verlangsamung im Umkreis), frühestens 20. Aufspießender Stoß auf F3 (Kampfhaltung) und Tollkühne Schwünge auf Shift-F1, 25. Weitreichende Stöße auf Q (Kampfhaltung), Todeswunsch auf Shift-3, Erschütternder Schlag auf Shift-V (eine Betäubung; in Berserkerhaltung ist diese Taste stattdessen Berserkerwut), 30. Tödlicher Stoß, Blutdurst oder Schildschlag auf 3, 40.]] },
		{ "Anfängerfehler", [[
- Eine Taste in der falschen Haltung drücken. Spott wirkt nur in Verteidigungshaltung, Überwältigen nur in Kampfhaltung. In der falschen Haltung macht die Taste nichts. Schau zuerst auf deine Haltung.
- Sturmangriff in Verteidigungshaltung. Dort wirkt er nur mit dem Talent **Frontkämpfer**. Ohne es bekommst du eine rote Fehlermeldung.
- Sturmangriff im Kampf. Sturmangriff beginnt nur einen Kampf; sobald du kämpfst, funktioniert er nicht.
- Donnerknall (Shift-1) funktioniert nicht in Berserkerhaltung.
- Schildhieb, Schildblock und Schildschlag ohne Schild. Alle drei brauchen einen Schild in der Nebenhand.
- Erwarten, dass Zerschmettern schnell ist. In Forever hat es 1,5 Sekunden Zauberzeit und 15 Sekunden Abklingzeit.
- Gegenschlag und Schildwall liegen beide auf C, jeder mit seiner eigenen Abklingzeit von 15 Minuten. Heb sie dir für echte Not auf.]] },
	},
	ROGUE = {
		{ "Was er kann", [[
Der Schurke kämpft im Nahkampf mit schnellen Treffern. Er kann sich ungesehen an Gegner heranschleichen, und er hat viele Wege, einen Gegner kurz aufzuhalten.
Der Schurke hat **Energie** statt Mana. Energie füllt sich von selbst, und zwar schnell: Ein leerer Balken ist in etwa 10 Sekunden wieder voll.]] },
		{ "Verstohlenheit und Finisher", [[
**Verstohlenheit** (Stufe 1, Shift-R) macht dich schwer zu sehen. Du bewegst dich mit halber Geschwindigkeit. Manche Angriffe wirken nur aus der Verstohlenheit: Das sind deine **Eröffner**, der erste Treffer eines Kampfes. In Verstohlenheit wechseln MHs Tasten von selbst:
- **1** wird zu Erdrosseln (14), **2** wird zu Hinterhalt (18), **V** wird zu Fieser Trick (26), **Shift-Q** wird zu Kopfnuss (10), **F** wird zu Taschendiebstahl (4).
- Bevor du den Zauber Verstohlenheit kennst, behält die Taste einfach ihren normalen Zauber.
Treffer wie Finsterer Stoß geben dir **Combopunkte** (bis zu 5). Ein **Finisher** ist ein Treffer, der alle deine Combopunkte verbraucht: Ausweiden (4), Zerhäckseln (Shift-4) und Blutung (5). Mehr Punkte machen ihn stärker.]] },
		{ "Stufe 1-10: deine Tasten", [[
- **1** = Finsterer Stoß (Stufe 1): dein wichtigster Treffer.
- **4** = Ausweiden (1): dein wichtigster Finisher.
- **Shift-R** = Verstohlenheit (1): schleichen. Drück es noch einmal, um die Verstohlenheit zu verlassen. Danach kannst du 10 Sekunden lang nicht wieder hinein.
- **Shift-2** = Werfen (1): ein Wurf auf Entfernung. Du brauchst eine Wurfwaffe (zum Beispiel Wurfmesser) in deinem Fernkampfplatz. Hast du eine Schusswaffe, einen Bogen oder eine Armbrust angelegt, schießt die Taste stattdessen damit.
- **2** = Meucheln (4): ein starker Treffer. Du brauchst einen Dolch, und du musst hinter dem Gegner stehen.
- **F** = Taschendiebstahl (4): nur in Verstohlenheit. Es bestiehlt den Gegner.
- **Shift-Q** = Solarplexus (6): hält einen Gegner kurz auf. Jeder Schaden bricht es. So ein Zauber heißt **CC** (Crowd Control).
- **Z** = Entrinnen (8): Du weichst 15 Sekunden lang viel mehr Angriffen aus. Abklingzeit 5 Minuten.
- **Shift-4** = Zerhäckseln (10): dein zweiter Finisher.
- **R** = Sprinten (10): schnell laufen.
- **Shift-Q** = Kopfnuss (10): nur in Verstohlenheit. Nimmt einen Gegner vom Typ Humanoid eine Weile aus dem Spiel, bevor der Kampf beginnt. Es wirkt nicht auf Wildtiere und nicht auf Gegner, die schon kämpfen. Schaden bricht es. Kopfnuss bricht deine Verstohlenheit nicht.
- **F4** = die Heilung über Zeit deines Volkes, falls es eine hat: Kannibalismus (Untoter; nur in der Nähe einer Leiche vom Typ Humanoid oder Untoter), Rasche Regeneration (Troll; endet, wenn du dich bewegst, etwas tust oder Schaden nimmst), Leylinie lesen (Himmelsgeborener des Hohen Ordens).
- **Shift-E** = der Zauber deines Volkes (zum Beispiel Nachtelf: Schattenmimik, Orc: Kochendes Blut).]] },
		{ "Einfache Reihenfolge", [[
Verstohlenheit (Shift-R) und geh zum Gegner. Ein paar Mal Finsterer Stoß (1), dann Ausweiden (4). Mit Dolch und hinter dem Gegner: Meucheln (2). Ab Stufe 10: Halt Zerhäckseln (Shift-4) aufrecht.]] },
		{ "Was später kommt", [[
- 12: Tritt auf E: deine **Unterbrechung** (sie stoppt den Zauber eines Gegners). 14: Rüstung schwächen auf Shift-Z, Erdrosseln auf 1 in Verstohlenheit.
- 16: Finte auf F (außerhalb der Verstohlenheit). Sie senkt deine **Bedrohung**: wie sehr der Gegner dich angreifen will. Schloss knacken (Block D).
- 18: Hinterhalt auf 2 in Verstohlenheit (Dolch, von hinten). 20: Blutung auf 5. Gifte (aus einer Quest; siehe unten).
- 22: Ablenken auf Shift-F, Verschwinden auf X (deine Flucht; jede Nutzung kostet ein Blitzstrahlpulver, einen Gegenstand in deinen Taschen). 24: Scharfe Klinge auf Shift-3 (ein Treffer mit deiner Nebenhandwaffe, also brauchst du in jeder Hand eine Waffe; Abklingzeit 10 Sekunden; gibt 15 Energie zurück).
- 26: Fieser Trick auf V in Verstohlenheit: eine **Betäubung** (der Gegner kann sich ein paar Sekunden lang nicht bewegen und nichts tun). 30: Nierenhieb auf V außerhalb der Verstohlenheit. Falle entschärfen (Block D). 34: Blenden auf Shift-V (kostet ein Blendungspulver).
- Talente: Riposte auf Shift-F1 und Konzentration auf Shift-C, frühestens 20. Kaltblütigkeit auf F1 und Geisterhafter Stoß auf Shift-X, 25. Klingenwirbel auf Shift-1 (trifft mehr Gegner), Vorbereitung auf F3 (setzt die Abklingzeit deiner anderen Schurkenzauber zurück, wie Entrinnen, Sprinten und Verschwinden), Blutsturz auf 3, 30. Verstümmeln auf 3, Adrenalinrausch oder Todesmal auf Q, 40.]] },
		{ "Anfängerfehler", [[
- Einen Eröffner außerhalb der Verstohlenheit drücken. Erdrosseln, Hinterhalt, Fieser Trick, Kopfnuss und Taschendiebstahl brauchen Verstohlenheit. Außerhalb der Verstohlenheit wirkt dieselbe Taste ihren normalen Zauber.
- Verstohlenheit aus Versehen noch einmal drücken. Das beendet die Verstohlenheit, und du kannst 10 Sekunden lang nicht wieder hinein.
- Nachtelf: Schattenmimik ist der Zauber deines Volkes, nicht die Verstohlenheit deiner Klasse. Für deine Eröffner nutz Verstohlenheit (Shift-R).
- Meucheln und Hinterhalt von vorn oder ohne Dolch. Beide brauchen einen Dolch, und du musst hinter dem Gegner stehen.
- Einen Gegner treffen, den du mit Solarplexus oder Kopfnuss ausgeschaltet hast. Jeder Schaden weckt ihn auf.
- Kopfnuss auf ein Wildtier oder auf einen Gegner, der schon kämpft. Kopfnuss wirkt nur auf Gegner vom Typ Humanoid, vor dem Kampf.
- Verschwinden oder Blenden ohne Pulver in den Taschen. Verschwinden braucht ein Blitzstrahlpulver, Blenden ein Blendungspulver.
- Gifte auf dem Block suchen. **Gifte** sind Gegenstände, die du herstellst (du lernst Gifte aus einer Quest auf etwa Stufe 20). Du legst sie auf deine Waffe. Zieh sie selbst auf deine eigenen Alt-Tasten (Block D).
- Geisterhafter Stoß (Talent): Danach wirkt dein nächster Hinterhalt oder dein nächstes Erdrosseln ohne Verstohlenheit, wenn du es innerhalb von 7 Sekunden nutzt. MHs Tasten können das nicht sehen, also wirken die Tasten 1 und 2 außerhalb der Verstohlenheit trotzdem Finsterer Stoß und Meucheln.]] },
	},
	PRIEST = {
		{ "Was er kann", [[
Der Priester heilt und trifft aus der Ferne mit Heilig- und Schattenmagie. Er schützt Freunde mit einem Schild. Später kann er **Schattengestalt** wählen (ein Talent, frühestens Stufe 40): mehr Schattenschaden, aber keine Heilung.
Der Priester hat keine Haltungen. Schattengestalt ändert die Tasten nicht: Jede Taste macht immer dasselbe.]] },
		{ "Die eigenen Zauber deines Volkes", [[
Jedes Priester-Volk hat zwei eigene Priesterzauber: einen auf Stufe 10 und einen auf Stufe 20. Beide bekommst du aus einer Quest, nicht vom Lehrer. MH legt sie auf **X** und **Shift-R**, so nutzt jedes Volk dieselben zwei Tasten.
- Zwerg: Verzweifeltes Gebet (10, X; Abklingzeit 10 Minuten), Züchtigung (20, Shift-R).
- Mensch: Göttliche Anmut (10, Shift-R; eine spontane Heilung auf einen Freund unter halber Gesundheit, nicht auf dich; Abklingzeit 10 Minuten), Rückkopplung (20, X).
- Nachtelf: Sternensplitter (10, Shift-R; Abklingzeit 30 Sekunden), Elunes Anmut (20, X).
- Untoter: Berührung der Schwäche (10, X), Dunkles Opfer (20, Shift-R; tausch deine eigene Gesundheit gegen Mana).
- Troll: Verhexung der Schwäche (10, Shift-R), Schattenschild (20, X).
- Gnom: Verwirrender Lichtblitz (10, Shift-R), Notfallplan (20, X; ein Schutz auf einem Freund, der ihn heilt und abschirmt, wenn seine Gesundheit tief fällt).]] },
		{ "Stufe 1-10: deine Tasten", [[
- **1** = Heilige Pein (Stufe 1; ab Rang 2: Göttliche Pein): dein wichtigster Angriffszauber.
- **C** = Geringes Heilen (1): deine wichtigste Heilung. Später übernehmen Heilen (16) und Große Heilung (40) diese Taste.
- **5** = Schießen (1): dein **Zauberstab** (ein kleiner magischer Stab, der von selbst schießt). Du brauchst einen Zauberstab in den Händen.
- **Shift-X** = Machtwort: Seelenstärke (1): ein Buff. Ein **Buff** ist ein guter Effekt auf dir oder einem Freund. Leg ihn vor einem Kampf an.
- **2** = Schattenwort: Schmerz (4): Schattenschaden.
- **Z** = Machtwort: Schild (6): ein Schild auf dir oder einem Freund. Abklingzeit 4 Sekunden, aber dieselbe Person kann erst nach 15 Sekunden einen neuen Schild bekommen.
- **F** = Verblassen (8): Gegner wollen dich eine Weile weniger angreifen. Abklingzeit 30 Sekunden.
- **F4** = Erneuerung (8): eine Heilung, die nach und nach heilt.
- **3** = Gedankenschlag (10): Schattenschaden. Abklingzeit 8 Sekunden.
- **F3** = Auferstehung (10): holt einen toten Freund zurück. Nur außerhalb eines Kampfes.
- Der Zauber deines Volkes von Stufe 10 liegt auf **X** oder **Shift-R** (siehe die Liste oben).
- **Shift-E** = die Fähigkeit deines Volkes (zum Beispiel Zwerg: Steingestalt, Nachtelf: Schattenmimik).]] },
		{ "Einfache Reihenfolge", [[
Machtwort: Schild (Z) auf dich. Schattenwort: Schmerz (2), Gedankenschlag (3), dann Göttliche Pein (1). Wenig Mana? Nutz deinen Zauberstab (5). Wenig Gesundheit? Erneuerung (F4) oder Geringes Heilen (C).]] },
		{ "Was später kommt", [[
- 12: Inneres Feuer auf Shift-Z. 14: Krankheit heilen auf Shift-C, Psychischer Schrei auf V (ein paar Gegner um dich herum laufen bis zu 8 Sekunden lang vor Angst weg; Schaden kann es beenden; Abklingzeit 30 Sekunden).
- 18: Magiebannung auf Shift-V. 20: Blitzheilung auf F2 (schnelle Heilung), Heiliges Feuer auf 4, Untote fesseln auf Shift-Q, Verschlingende Seuche auf Shift-3, der Zauber deines Volkes von Stufe 20, Furchtzauberschutz (Block D).
- 30: Gebet der Heilung auf Shift-2 (heilt deine Gruppe), Gedankenkontrolle auf Shift-F. 32: Schattenwort: Tod auf Shift-4, Krankheit aufheben übernimmt Shift-C. 34: Levitieren auf R (kostet eine Leichte Feder). 48: Gebet der Seelenstärke übernimmt Shift-X (kostet eine Heilige Kerze).
- Talente: Gedankenschinden (übernimmt Taste 1), Heilige Nova auf Shift-1 und Innerer Fokus auf F1, frühestens 20. Vampirumarmung auf Ctrl-3, 25. Sühne auf Shift-F1 und Stille auf E (deine **Unterbrechung**: sie stoppt den Zauber eines Gegners), 30. Seele der Macht auf Q, Schattengestalt auf Ctrl-1, Gebet der Besserung auf Ctrl-2, 40.]] },
		{ "Anfängerfehler", [[
- In Schattengestalt heilen. Kein Heilzauber wirkt in Schattengestalt. Furchtzauberschutz wirkt darin auch nicht. Verlass sie zuerst: Drück Ctrl-1 noch einmal.
- Göttliche Pein vermissen, nachdem du Gedankenschinden genommen hast. Sobald du Gedankenschinden kennst, wirkt Taste 1 Gedankenschinden, nicht Göttliche Pein.
- Schießen (5) ohne Zauberstab drücken. Kauf oder finde zuerst einen.
- Früh eine Unterbrechung auf E suchen. Der Priester bekommt erst eine mit dem Talent Stille (frühestens 30).
- Untote fesseln (Shift-Q) auf einen normalen Gegner. Es wirkt nur auf untote Gegner.]] },
	},
	SHAMAN = {
		{ "Was er kann", [[
Der Schamane wirkt Blitz und Feuer, heilt und stellt Totems auf. Er kann aus der Ferne oder im Nahkampf mit einer Waffe kämpfen. Zwerge (Allianz) können in Forever auch Schamane sein.
Der Schamane hat keine Haltungen. **Geisterwolf** (Stufe 20, auf R) ist eine Gestalt zum Laufen, aber sie ändert deine Tasten nicht.]] },
		{ "Totems und Waffen-Buffs", [[
Ein **Totem** ist ein kleiner Gegenstand, den du auf den Boden stellst. Solange es steht, hilft es dir oder deiner Gruppe oder schadet Gegnern. Totems gehören zu vier Elementen: Erde, Feuer, Wasser und Luft. Du kannst von jedem Element ein Totem gleichzeitig haben. Ein neues ersetzt das alte.
- Jedes Element hat einen Totem-Gegenstand, den du aus einer Klassenquest bekommst: Erdtotem (Stufe 4, oder 3 für die Himmelsgeborenen), Feuertotem (10), Wassertotem (20), Lufttotem (30). Du brauchst diesen Gegenstand in deinen Taschen für alle Totems dieses Elements.
- Vor Stufe 20 hat jedes Totem seine eigene Taste: Totem der Steinhaut (Z), Totem der Erdbindung (V), Totem der Steinklaue (F), Totem der Erdstärke (Shift-X), Totem der Verbrennung (5), Totem des Erdstoßes (Shift-F).
- Ab Stufe 20 gibt dir das Spiel eine **Totemleiste**. Darauf wählst du ein Totem pro Element. Dann stellt eine Taste sie alle auf: **Ctrl-1** = Ruf der Elemente (20), **Ctrl-2** = Ruf der Urahnen (30), **Ctrl-3** = Ruf der Geister (40). Jeder stellt bis zu 4 Totems von seiner eigenen Seite der Totemleiste auf. Er hat 3 Sekunden Zauberzeit und kostet das Mana aller Totems, die er aufstellt.
- **Shift-R** = Totemischer Ruf (22): bewegt deine Totems zu dir. Totemischer Rückruf (20, Block D) nimmt sie zurück und gibt dir ein Viertel ihres Manas zurück.
Ein **Waffen-Buff** legt 60 Minuten lang Kraft auf deine Waffe. Du hast einen gleichzeitig. Waffe des Felsbeißers (1), Waffe der Flammenzunge (10), Waffe des Frostbrands (20) und Waffe des Windzorns (30) kommen auf deine eigenen Alt-Tasten (Block D). Wähl den, der zu deiner Spielweise passt.]] },
		{ "Stufe 1-10: deine Tasten", [[
- **1** = Blitzschlag (Stufe 1): dein wichtigster Angriffszauber.
- **C** = Welle der Heilung (1): deine große Heilung.
- Waffe des Felsbeißers (1) kommt auf Block D (siehe oben).
- **E** = Erdschock (4): deine **Unterbrechung** (sie stoppt den Zauber eines Gegners), und Schaden.
- **Z** = Totem der Steinhaut (4, aus einer Quest): Du nimmst weniger Schaden von Nahkampftreffern. **Nahkampf** = Kämpfen aus der Nähe.
- **V** = Totem der Erdbindung (6): verlangsamt Gegner in seiner Nähe. Abklingzeit 15 Sekunden.
- **F** = Totem der Steinklaue (8): bringt Gegner um es herum dazu, das Totem anzugreifen. Abklingzeit 30 Sekunden.
- **Shift-Z** = Blitzschlagschild (8): ein Schild auf dir selbst. Nur ein Schild gleichzeitig.
- **2** = Flammenschock (10): Feuerschaden, dann noch mehr Schaden über ein paar Sekunden.
- **5** = Totem der Verbrennung (10, aus einer Quest): dein Schadenstotem.
- **Shift-X** = Totem der Erdstärke (10): ein Totem, das deiner Gruppe einen Buff gibt. Ein **Buff** ist ein guter Effekt.
- Waffe der Flammenzunge (10) kommt auf Block D.
- **Shift-E** = der Zauber deines Volkes (zum Beispiel Tauren: Kriegsdonner, Zwerg: Steingestalt).]] },
		{ "Einfache Reihenfolge", [[
Waffen-Buff an (Block D), Blitzschlagschild an (Shift-Z). Totem der Verbrennung (5) aufstellen. Flammenschock (2), dann Blitzschlag (1). Heb dir Erdschock (E) auf, bis der Gegner einen Zauber wirkt. Wenig Gesundheit? Welle der Heilung (C).]] },
		{ "Was später kommt", [[
- 12: Feuernova auf Shift-4, Reinigen auf Shift-Q (entfernt Magie von einem Gegner), Geist der Ahnen auf F3 (holt einen toten Freund zurück). 16: Vergiftung heilen auf Shift-C. 18: Totem des Erdstoßes auf Shift-F (entfernt Furcht, Bezauberung und Schlaf von deiner Gruppe).
- 20: Geisterwolf auf R (3 Sekunden Zauberzeit, nur im Freien), Frostschock auf 4 (verlangsamt), Geringe Welle der Heilung auf F2 (schnelle Heilung), Totem des heilenden Flusses auf F4 (aus einer Quest; heilt deine Gruppe nach und nach; braucht das Wassertotem), Ruf der Elemente auf Ctrl-1.
- 22: Krankheit heilen auf Shift-V, Totemischer Ruf auf Shift-R. 30: Totem der Erdung auf X (fängt einen schädlichen Zauber ab, der auf dich oder ein Gruppenmitglied in der Nähe zielt; keine Flächenzauber; braucht das Lufttotem aus der Quest auf Stufe 30), Ruf der Urahnen auf Ctrl-2. 32: Kettenblitzschlag auf Shift-1 (trifft mehrere Gegner).
- 40: Kettenheilung auf Shift-2 (heilt mehrere Freunde), Ruf der Geister auf Ctrl-3.
- Talente: Wasserschild (übernimmt Shift-Z), frühestens 20. Sturmschlag auf 3 und Totem der Manaflut auf F1, 25. Schnelligkeit der Natur auf Shift-3, 30. Springflut auf Shift-F1, und Blitzbeherrschung oder Zorn des Scharfsehers auf Q, 40.]] },
		{ "Anfängerfehler", [[
- Einen Schock nutzen, kurz bevor du unterbrechen musst. Erdschock (E), Flammenschock (2) und Frostschock (4) teilen sich eine Abklingzeit von 6 Sekunden. Nach Flammenschock hast du bis zu 6 Sekunden lang keine Unterbrechung.
- Feuernova (Shift-4) drücken, ohne dass ein Feuer-Totem steht. Es braucht eins deiner Feuer-Totems (wie Totem der Verbrennung oder Totem der glühenden Magma). Es trifft die Gegner nahe diesem Totem, nicht die nahe bei dir.
- Ein Totem ohne seinen Totem-Gegenstand aufstellen. Jedes Element braucht seinen eigenen Totem-Gegenstand in deinen Taschen, aus einer Klassenquest.
- In Geisterwolf zaubern. Deine Zauber sind nicht für den Wolf gemacht. Verlass zuerst Geisterwolf, dann zaubere.
- Den Waffen-Buff vergessen. Er hält 60 Minuten und liegt nicht auf dem Block: Er liegt auf deinen eigenen Alt-Tasten (Block D).
- Zwei Schilde erwarten. Sobald du Wasserschild hast, wirkt Shift-Z diesen, nicht Blitzschlagschild.]] },
	},
	WARLOCK = {
		{ "Was er kann", [[
Der Hexenmeister steht hinten und wirkt Schatten- und Feuermagie. Viel von seinem Schaden kommt langsam: Zauber, die den Gegner über Zeit verletzen, und Flüche. Er hat fast immer einen Dämon dabei.
Ein **DoT** (Schaden über Zeit) ist ein Zauber, der den Gegner eine Weile lang nach und nach verletzt. Ein **Fluch** oder **Omen** ist ein schlechter Effekt, den du auf einen Gegner legst. Ein Fluch und ein Omen können auf demselben Gegner liegen. Der Hexenmeister hat keine Gestalten und keine Haltungen, also macht jede Taste immer dasselbe.]] },
		{ "Dein Dämon", [[
Dein **Begleiter** ist ein Dämon, den du herbeirufst. Er kämpft neben dir. Die Dämonen lernst du aus Klassenquests.
- **Wichtel beschwören** (1): aus deiner ersten Klassenquest in deinem Startgebiet. Der Name hängt von deinem Volk ab: Mensch „Der gestohlene Foliant“, Gnom „Anfänge“, Orc und Troll „Üble Familiare“, Untoter „Der zerrissene Schleier“. Der Wichtel kostet keinen Seelensplitter.
- **Leerwandler beschwören** (10, Quest). **Sukkubus beschwören** oder **Inkubus beschwören** (20, Quest). **Teufelsjäger beschwören** (30, Quest). Jeder davon kostet 1 **Seelensplitter** (siehe Seelendieb unten).
- **Inferno** (50) liegt auf **F3**. Jeder Zauber braucht einen Höllenstein. Abklingzeit 1 Stunde.
- Die Beschwörungen liegen nicht auf dem Block. Sie kommen auf deine eigenen Alt-Tasten (Block D).
- Ab deinem ersten Dämon hat dein Begleiter drei Tasten: **Ctrl-1** = dein Ziel angreifen, **Ctrl-2** = dir folgen, **Ctrl-3** = bleiben, wo er ist.
- Der Leerwandler kann spotten (Qual). Der Teufelsjäger kann den Zauber eines Gegners stoppen (Zaubersperre, ab 36). Das sind die eigenen Zauber deines Dämons, auf Blizzards Haustierbalken.]] },
		{ "Stufe 1-10: deine Tasten", [[
- **1** = Schattenblitz (Stufe 1): dein wichtigster Angriffszauber.
- **3** = Feuerbrand (1): Feuerschaden, dann noch mehr Schaden über Zeit.
- **Shift-Z** = Dämonenhaut (1): ein Buff auf dir selbst (mehr Rüstung). Ein **Buff** ist ein guter Effekt. Ab 20 übernimmt Dämonenrüstung diese Taste.
- **2** = Verderbnis (4): ein DoT.
- **Shift-V** = Fluch der Schwäche (4): dein Fluch. Ab 20 übernimmt Fluch der Elemente diese Taste.
- **F** = Aderlass (6): macht einen Teil deiner Gesundheit zu Mana.
- **5** = Omen der Pein (8): dein Omen, ein DoT.
- **V** = Furcht (8): deine **CC**-Taste. CC (Crowd Control) = ein Zauber, der einen Gegner eine Weile aus dem Kampf nimmt.
- **4** = Seelendieb (10): Nutz es, um einen Gegner zu erledigen, der EP gibt, dann bekommst du einen **Seelensplitter**. Ein Seelensplitter ist ein kleiner Gegenstand in deinen Taschen. Du brauchst einen, um die meisten Dämonen (alle außer dem Wichtel) zu beschwören und um einen Gesundheitsstein oder Seelenstein herzustellen. Graue (zu leichte) Gegner geben keinen Splitter.
- Gesundheitsstein herstellen (10, kostet einen Seelensplitter) kommt auf Block D. Dein Gesundheitsstein liegt dann auf **Shift-T**, wie bei jeder Klasse.
- **Shift-E** = der Zauber deines Volkes (zum Beispiel Orc: Kochendes Blut, Untoter: Wille der Verlassenen).]] },
		{ "Einfache Reihenfolge", [[
Dämon heraus (Block D; alle außer dem Wichtel brauchen einen Seelensplitter), dann schick ihn hinein (Ctrl-1). Verderbnis (2), Omen der Pein (5), Feuerbrand (3), dann Schattenblitz (1). Wenig Mana? Aderlass (F). Wenig Gesundheit? Blutsauger (C, ab 14).]] },
		{ "Was später kommt", [[
- 12: Lebenslinie auf F2 (heilt deinen Dämon). 14: Blutsauger auf C (deine eigene große Heilung).
- 16: Unendlicher Atem auf Shift-R. 18: Sengender Schmerz (Block D) und Seelenstein herstellen (kostet einen Seelensplitter; nicht auf dem Block, leg es selbst auf deine eigene Leiste).
- Fluch der Sprachen und Ritual der Beschwörung (holt ein Gruppenmitglied zu dir) werden selten genutzt: Sie liegen auch nicht auf dem Block. Leg sie auf deine eigene Leiste, wenn du sie willst.
- 20: Feuerregen auf Shift-1 (trifft mehrere Gegner), Dämonenrüstung auf Shift-Z, Fluch der Elemente auf Shift-V.
- 28: Verbannen auf Shift-Q. 30: Höllenfeuer auf Shift-2. 32: Schattenzauberschutz auf Z (saugt Schattenschaden auf; Abklingzeit 30 Sekunden).
- 40: Schreckensgeheul auf Shift-F (versetzt mehrere Gegner in Furcht). 42: Todesmantel auf X (ein Entsetzen, wie Furcht, und eine Heilung; Abklingzeit 2 Minuten).
- 48: Seelenfeuer auf Q (dein größter Treffer; kostet einen Seelensplitter; 6 Sekunden Zauberzeit; Abklingzeit 1 Minute). 50: Inferno auf F3. 60: Omen der Verdammnis auf F1.
- Talente: Schattenbrand auf Shift-4 (kostet einen Seelensplitter), Fluch verstärken auf Shift-3, Dämonische Opferung auf Shift-C, frühestens 20. Fluch der Erschöpfung auf R (verlangsamt den Gegner, damit du von ihm wegbleiben kannst), Teufelsbeherrschung auf Shift-F1 (schnell einen Dämon beschwören), 25. Lebensentzug auf F4 (ein DoT, der dich heilt), Seelenverbindung auf Shift-X, 30. Feuersbrunst (25), Omen der Verwüstung (30), Zermürben (40) und Verbrennen (40), jeweils frühestens, kommen auf Block D.]] },
		{ "Anfängerfehler", [[
- Einen Dämon ohne Seelensplitter beschwören. Alle Dämonen außer dem Wichtel kosten einen. Nutz Seelendieb (4), um Gegner zu erledigen, die EP geben.
- Eine Unterbrechung auf E suchen. Der Hexenmeister hat keine eigene, also bleibt E leer. Nur der Teufelsjäger hat eine.
- Lebenslinie (F2) drücken, um dich selbst zu heilen. Sie heilt deinen Dämon. Deine eigene Heilung ist Blutsauger (C).
- Verbannen (Shift-Q) auf einen normalen Gegner. Es wirkt nur auf Dämonen und Elementare.
- Omen der Verdammnis (F1) auf einen Spieler. Es kann nicht auf Spieler gewirkt werden.
- Deinen Zauberstab vermissen. Schießen liegt nicht auf dem Block. Zieh es selbst aus deinem Zauberbuch auf deine eigene Leiste.]] },
	},
	-- Pro Rolle (16 Nov 2026, mh-writer), same shape as ROLES in Modules/ForeverHowToPlay.lua: same band, same order.
	-- Spell names: SpellName deDE, wowf 1.60.1.70938. Tree names: ForeverMacros.lua SPEC_NAMES.
	ROLES = {
		DRUID = {
			{ band = 2, title = "Bär: Tank", body = [[
Ab Stufe 10 (Bärengestalt, aus einer Quest). Ein **Tank** ist der, den die Gegner schlagen, damit der Rest der Gruppe sicher bleibt. Zum Leveln nennen die Guides die Katze angenehmer; der Bär ist praktisch von 10 bis 20 und zum Tanken in Dungeons. Der Bär nutzt **Wut**: Du bekommst sie, wenn du triffst und wenn du getroffen wirst.
**Einfache Reihenfolge:**
1. Pullen mit Feenfeuer (**5**, ab 18) oder Wilde Attacke (**E**, ab 20). **Pullen** = einen Gegner aus der Ferne treffen, damit er zu dir kommt.
2. Demoralisierendes Gebrüll (**Shift-2**) einmal.
3. Urtümlicher Biss (**3**, ab 40), sobald er bereit ist.
4. Aufschlitzen (**2**, ab 25), bis es 5-mal gestapelt ist.
5. Wut übrig: Zermalmen (**1**) auf einen Gegner, Prankenhieb (**Shift-1**, ab 16) auf zwei oder mehr.
6. Knurren (**F**), wenn ein Gegner jemand anderen schlägt.
**Alle 10 Stufen:**
- 10: Bärengestalt (**Ctrl-1**), Zermalmen (**1**), Knurren (**F**), Demoralisierendes Gebrüll (**Shift-2**). Danach Wutanfall (**Q**) mit 12, Hieb (**V**) mit 14, Prankenhieb (**Shift-1**) mit 16, Feenfeuer (**5**) mit 18.
- 20: Wilde Attacke (**E**, ein Talent): Du stürmst auf den Gegner zu, er kann sich 4 Sekunden nicht bewegen und nicht zaubern. Abklingzeit 15 Sekunden. Die Talentstufen hier sind die frühesten; ein Perk kann sie bis zu 5 Stufen früher bringen.
- 30: Rudelführer (ein Talent). Davor: Aufschlitzen (**2**, ein Talent) mit 25, Herausforderndes Gebrüll (**Shift-F**) mit 28.
- 40: Terrorbärengestalt ersetzt Bärengestalt auf **Ctrl-1**. Urtümlicher Biss (**3**, ein Talent). Davor: Rasende Regeneration (**X**) mit 36: macht aus Wut Gesundheit.
- 50: stärkere Ränge von Urtümlicher Biss, Aufschlitzen und Zermalmen. Baumrinde (**Z**) mit 44.
- 60: wieder stärkere Ränge; nichts Neues für diese Rolle.
**Anfängerfehler:**
- Wilde Attacke, wenn der Gegner näher als 8 Meter ist. Dort wirkt sie nicht.
- Wutanfall (**Q**), während du harte Treffer bekommst. Er gibt Wut, aber du hast 27% weniger Rüstung.]] },
			{ band = 2, title = "Katze: Schaden aus der Nähe", body = [[
Ab Stufe 20 (Katzengestalt, aus einer Quest; Schleichen bekommst du dazu). Zum Leveln ist sie die erste Wahl der Guides: Sie nennen sie die schnellste und die angenehmste. Die Katze nutzt **Energie**, die sich von selbst füllt. Deine Treffer geben **Combopunkte** (bis zu 5); ein **Finisher** verbraucht sie alle.
**Einfache Reihenfolge:**
1. Schleichen (**Shift-R**), dann von hinten mit Schreddern (**3**) eröffnen. **Schleichen** = sich anschleichen, damit der Gegner dich nicht sieht.
2. Feenfeuer (**5**) auf zähe Gegner.
3. Krallenhieb (**2**, ab 24), aber nicht, wenn der Gegner fast tot ist.
4. Klaue (**1**) für Combopunkte; Schreddern (**3**), wenn du hinter dem Gegner stehst.
5. Bei 4-5 Combopunkten: Zerfetzen (**4**), wenn der Gegner noch lange lebt, sonst Wilder Biss (**Shift-4**, ab 24).
6. Machtverschiebung (**Q**, ab 40), wenn deine Energie unter 50 ist.
**Alle 10 Stufen:**
- 10: nichts Neues für diese Rolle (die Katze kommt mit 20).
- 20: Katzengestalt (**Ctrl-2**), Klaue (**1**), Schreddern (**3**, von hinten), Zerfetzen (**4**), Schleichen (**Shift-R**). Wilde Attacke (**E**, ein Talent): Als Katze springst du hinter den Gegner. Omen der Klarsicht ist passiv: keine Taste.
- 30: Rudelführer (ein Talent). Davor: Krallenhieb (**2**) und Wilder Biss (**Shift-4**) mit 24, Spurt (**R**) mit 26, Ducken (**F**) mit 28.
- 40: Machtverschiebung (**Q**, ein Talent): 40 Energie für Mana, Abklingzeit 8 Sekunden, nur als Katze. Davor: Verheeren (Block D) mit 32, Anspringen (**V**, aus Schleichen, eine Betäubung) mit 36. Die Talentstufen hier sind die frühesten; ein Perk kann sie bis zu 5 Stufen früher bringen.
- 50: stärkere Ränge von Wilder Biss, Zerfetzen und Schreddern; nichts Neues für diese Rolle.
- 60: wieder stärkere Ränge; nichts Neues für diese Rolle.
**Anfängerfehler:**
- Schreddern von vorn. Es wirkt nur von hinten; von vorn nimmst du Klaue.
- Zu oft Machtverschiebung. Dann hast du kein Mana mehr, um dich selbst zu heilen.]] },
			{ band = 1, title = "Gleichgewicht: Schaden aus der Ferne", body = [[
Ab Stufe 1: Zorn hast du von Anfang an, Mondfeuer kommt mit 4. Moonkingestalt ist ein Talent, frühestens 40. Die Guides sagen, Leveln als Gleichgewicht klappt, ist aber langsamer als die Katze. Manche Guides nehmen Moonkingestalt später (Zygor mit 53): 40 ist keine Regel.
**Einfache Reihenfolge:**
1. Sternenfeuer (**3**, ab 20) als Eröffner auf einen Gegner.
2. Mondfeuer (**2**).
3. Insektenschwarm (**4**, ab 25).
4. Zorn (**1**) als Füller. Mit Finsternis (ab 30): Zorn baut Ladungen auf, dann Sternenfeuer (**3**).
5. Hurrikan (**Shift-1**, ab 40) auf Gruppen.
Wenig Mana? Bleib bei Zorn: Er ist billig.
**Alle 10 Stufen:**
- 10: Zorn (**1**), Mondfeuer (**2**), Dornen (**Shift-Z**), Wucherwurzeln (**V**), Griff der Natur (**X**).
- 20: Sternenfeuer (**3**). Omen der Klarsicht ist passiv: keine Taste.
- 30: Finsternis (ein Talent): Zorn macht deine nächsten 2 Sternenfeuer schneller. Davor: Insektenschwarm (**4**, ein Talent) mit 25. Die Talentstufen hier sind die frühesten; ein Perk kann sie bis zu 5 Stufen früher bringen.
- 40: Moonkingestalt (**Ctrl-3**, ein Talent): kostet Mana, gibt deiner Gruppe +3% kritische Trefferchance (**kritischer Treffer** = ein glücklicher, stärkerer Treffer), aber darin keine Heilungen. Hurrikan (**Shift-1**), Anregen (**F1**).
- 50: stärkere Ränge von Hurrikan und Sternenfeuer. Baumrinde (**Z**) mit 44.
- 60: wieder stärkere Ränge; nichts Neues für diese Rolle.
**Anfängerfehler:**
- Heilen in Moonkingestalt. Das geht nicht, und wieder in die Gestalt zu gehen kostet Mana.
- Eine Taste für Omen der Klarsicht suchen. Es ist passiv: Es wirkt von selbst.]] },
			{ band = 3, title = "Wiederherstellung: Heiler", body = [[
Ab Stufe 1: Heilende Berührung hast du von Anfang an. Die Guides raten vom Heilen beim Leveln allein ab (Gegner sterben langsam): Level mit Zorn und Mondfeuer und heile in Dungeons. Ein **HoT** ist eine Heilung, die nach und nach heilt.
**Einfache Reihenfolge (in einer Gruppe):**
1. Verjüngung (**F4**) auf den Tank.
2. Nachwachsen (**F2**) auf jemanden mit wenig Gesundheit.
3. Rasche Heilung (**Shift-F1**, ab 25): nur auf jemanden, der deine Verjüngung oder dein Nachwachsen hat.
4. Wildwuchs (**Shift-2**, ab 40), wenn mehrere Leute Schaden nehmen.
5. Heilende Berührung (**C**) bei großem Schaden. Notfall: Schnelligkeit der Natur (**Shift-3**, ab 30), dann Heilende Berührung.
6. Anregen (**F1**, ab 40), wenn dein Mana knapp ist.
**Alle 10 Stufen:**
- 10: Heilende Berührung (**C**), Verjüngung (**F4**). Danach Nachwachsen (**F2**) und Wiederbelebung (**F3**, außerhalb eines Kampfes) mit 12, Vergiftung heilen (**Shift-C**) mit 14.
- 20: Wiedergeburt (**F3**, im Kampf). Danach Fluch aufheben (**Shift-V**) mit 24, Vergiftung aufheben (**Shift-C**) mit 26.
- 30: Schnelligkeit der Natur (**Shift-3**, ein Talent), Gelassenheit (**Q**). Davor: Rasche Heilung (**Shift-F1**, ein Talent) mit 25. Die Talentstufen hier sind die frühesten; ein Perk kann sie bis zu 5 Stufen früher bringen.
- 40: Wildwuchs (**Shift-2**, ein Talent), Anregen (**F1**).
- 50: Gabe der Wildnis (**Shift-X**), ein stärkerer Wildwuchs.
- 60: wieder stärkere Ränge; nichts Neues für diese Rolle.
**Anfängerfehler:**
- Heilen in einer Gestalt. Heilungen wirken nur in deiner normalen Gestalt.
- Einen HoT auf jemanden wirken, der ihn noch hat. Der neue ersetzt den alten.]] },
		},
		-- Warrior, Mage, Priest, Rogue, Hunter, Shaman, Warlock, Paladin: translated 17 Nov 2026 by mh-writer from ROLES in
		-- Modules/ForeverHowToPlay.lua. Spell names: SpellName deDE, wowf 1.60.1.70938; stat words: GlobalStrings deDE.
		WARRIOR = {
			{ band = 3, title = "Schutz: Tank", body = [[
Ab Stufe 10 (Verteidigungshaltung, aus einer Quest; dieselbe Quest gibt Spott und Rüstung zerreißen). Ein **Tank** ist der, den die Gegner schlagen, damit der Rest der Gruppe sicher bleibt. Du trägst eine Einhandwaffe und einen Schild. **Bedrohung** = wie sehr ein Gegner dich angreifen will; als Tank brauchst du sie auf jedem Gegner. Die Guides sind sich nicht einig, welcher Baum allein am schnellsten levelt: Manche nennen Schutz den schnellsten, andere sagen, er ist allein langsamer. Er kommt um Stufe 16 in Fahrt, sobald du Schildblock neben Rache hast.
**Einfache Reihenfolge:**
1. Verteidigungshaltung (**Ctrl-2**), Schlachtruf (**Shift-X**). Blutrausch (**F1**) für Wut zum Start.
2. Pullen. **Pullen** = einen Gegner aus der Ferne treffen, damit er zu dir kommt. Sturmangriff (**R**) wirkt nur in Kampfhaltung (**Ctrl-1**); geh danach zurück in Verteidigungshaltung (**Ctrl-2**). Mit Frontkämpfer (ab 25) wirkt Sturmangriff auch in Verteidigungshaltung. Oder pulle mit deiner Fernkampfwaffe (Block D).
3. Mehrere Gegner: Demoralisierender Ruf (**Shift-2**, ab 14) einmal, Donnerknall (**Shift-1**), sobald er bereit ist.
4. Schildblock (**Z**, ab 16), und Rache (**2**, ab 14), sobald sie aufleuchtet.
5. Schildschlag (**3**, ab 40), sobald er bereit ist.
6. Rüstung zerreißen (**5**) auf dein Hauptziel; bis zu 5 Stapel auf einem Boss.
7. Spott (**F**), wenn ein Gegner jemand anderen angreift.
8. Wut übrig: Heldenhafter Stoß (**1**) auf einen Gegner, Spalten (**Shift-4**, ab 20) auf zwei oder mehr.
**Alle 10 Stufen:**
- 10: Verteidigungshaltung (**Ctrl-2**), Spott (**F**), Rüstung zerreißen (**5**), Blutrausch (**F1**). Danach Schildhieb (**E**) mit 12, Rache (**2**) und Demoralisierender Ruf (**Shift-2**) mit 14, Schildblock (**Z**) mit 16, Entwaffnen (**V**) mit 18.
- 20: Letztes Gefecht (**X**, ein Talent): 20 Sekunden lang 30% mehr maximale Gesundheit. Siegesrausch (**F2**), Spalten (**Shift-4**). Danach Drohruf (**Shift-Q**) mit 22, Frontkämpfer (ein Talent, passiv) mit 25, Herausforderungsruf (**Shift-F**) mit 26, Schildwall (**C**) mit 28. Die Talentstufen hier sind die frühesten; ein Perk kann sie bis zu 5 Stufen früher bringen.
- 30: Erschütternder Schlag (**Shift-V**, ein Talent): eine Betäubung von 5 Sekunden. Berserkerhaltung (**Ctrl-3**, aus einer Quest). Danach Bastion (ein Talent, passiv) mit 35.
- 40: Schildschlag (**3**, ein Talent). Plattenpanzer beim Lehrer: Du kannst Platte tragen.
- 50: nichts Neues für diese Rolle. Stärkere Ränge von Schildschlag, Rache, Rüstung zerreißen und Donnerknall.
- 60: wieder stärkere Ränge; nichts Neues für diese Rolle.
**Anfängerfehler:**
- Glauben, dass Donnerknall die ganze Gegnergruppe trifft. Er trifft 4 Gegner; ein fünfter kann zum Heiler laufen.
- Gegner hinter dir lassen. Von hinten kannst du nicht blocken, ausweichen oder parieren, und Rache leuchtet nicht auf.
- Spott auf einen Gegner, der dich schon angreift. Dann macht er nichts.]] },
			{ band = 1, title = "Waffen: Schaden mit einer großen Waffe", body = [[
Ab Stufe 1. Du trägst eine große Zweihandwaffe und stehst fast immer in Kampfhaltung. Die großen Schritte sind Weitreichende Stöße mit 30 und Tödlicher Stoß mit 40. Eine neue Waffe ist dein größter Gewinn. Du hast keine eigene Heilung außer Siegesrausch (ab 20), also halt Essen und Verbände bereit. Die Guides sind sich nicht einig, welcher Baum am schnellsten levelt; alle drei funktionieren.
**Einfache Reihenfolge:**
1. Kampfhaltung (**Ctrl-1**), Schlachtruf (**Shift-X**).
2. Sturmangriff (**R**) zum Start.
3. Verwunden (**Shift-Z**), wenn der Gegner eine Weile lebt.
4. Überwältigen (**2**, ab 12), sobald es aufleuchtet.
5. Tödlicher Stoß (**3**, ab 40), sobald er bereit ist; heb 30 Wut dafür auf.
6. Siegesrausch (**F2**, ab 20), nachdem du einen Gegner getötet hast, wenn dir Gesundheit fehlt.
7. Zwei Gegner: Weitreichende Stöße (**Q**, ab 30), dann Spalten (**Shift-4**, ab 20). Vor 30: Donnerknall (**Shift-1**).
8. Wut übrig: Heldenhafter Stoß (**1**).
**Alle 10 Stufen:**
- 10: Heldenhafter Stoß (**1**), Sturmangriff (**R**), Verwunden (**Shift-Z**), Donnerknall (**Shift-1**), Kniesehne (**V**), Schlachtruf (**Shift-X**), Blutrausch (**F1**). Danach Überwältigen (**2**) mit 12, Demoralisierender Ruf (**Shift-2**) mit 14.
- 20: Siegesrausch (**F2**), Spalten (**Shift-4**), Zerschmettern (**Shift-C**), Gegenschlag (**C**). Danach Hinrichten (**4**) mit 24, Aufspießender Stoß (**F3**, ein Talent) mit 25: ein besonders harter Treffer gegen Riesen und Drachkin. Die Talentstufen hier sind die frühesten; ein Perk kann sie bis zu 5 Stufen früher bringen.
- 30: Weitreichende Stöße (**Q**, ein Talent, nur Kampfhaltung): Deine nächsten 5 Treffer treffen auch einen Gegner neben deinem Ziel. Berserkerhaltung (**Ctrl-3**, aus einer Quest) mit Abfangen (**R**) und Berserkerwut (**Shift-V**). Danach Verbessertes Zerschmettern (ein Talent, passiv) mit 35, Wirbelwind (**2** in Berserkerhaltung) mit 36, Zuschlagen (**E** in Berserkerhaltung) mit 38.
- 40: Tödlicher Stoß (**3**, ein Talent): Der Gegner bekommt 10 Sekunden lang 50% weniger Heilung. Plattenpanzer beim Lehrer.
- 50: Tollkühnheit (**Q** in Berserkerhaltung). Stärkere Ränge von Tödlicher Stoß.
- 60: wieder stärkere Ränge; nichts Neues für diese Rolle.
**Anfängerfehler:**
- Die ganze Zeit Heldenhafter Stoß (**1**) drücken. Dieser Schlag gibt keine Wut, also bleibt nichts für Tödlicher Stoß oder Überwältigen übrig.
- Zerschmettern (**Shift-C**) vor dem Talent Verbessertes Zerschmettern: 1,5 Sekunden Zauberzeit, die deinen normalen Schlag verzögert. Die meisten Guides lassen es bis dahin weg.
- Mit einer Zweihandwaffe eine Unterbrechung auf **E** suchen. Schildhieb braucht einen Schild; deine Unterbrechung ist Zuschlagen (38, Berserkerhaltung).]] },
			{ band = 2, title = "Furor: Schaden mit zwei Waffen", body = [[
Eine Waffe in jeder Hand, ab Stufe 20 (Beidhändigkeit beim Lehrer). Bis dahin nimm deine beste Waffe (eine Zweihandwaffe ist in Ordnung) und spiel wie Waffen. Furor wird richtig stark mit Wirbelwind (36) und Blutdurst (40). Du brauchst zwei gute Waffen. Wirbelwind, Zuschlagen, Abfangen und Berserkerwut wirken nur in Berserkerhaltung, also wechselst du oft die Haltung.
**Einfache Reihenfolge (ab 36; davor spiel wie Waffen):**
1. Schlachtruf (**Shift-X**). Blutrausch (**F1**) für Wut.
2. Sturmangriff (**R**) in Kampfhaltung (**Ctrl-1**).
3. Todeswunsch (**Shift-3**, ab 30) auf einen starken Gegner.
4. Berserkerhaltung (**Ctrl-3**): Wirbelwind (**2**, ab 36), sobald er bereit ist.
5. Blutdurst (**3**, ab 40), sobald er bereit ist. Die Guides sind sich uneinig, welcher der beiden zuerst kommt.
6. Siegesrausch (**F2**), nachdem du einen Gegner getötet hast, wenn dir Gesundheit fehlt.
7. Wut übrig: Heldenhafter Stoß (**1**); auf zwei Gegner Spalten (**Shift-4**).
8. Wenig Wut: Tollkühne Schwünge (**Shift-F1**, ab 25; kostet Gesundheit).
**Alle 10 Stufen:**
- 10: nichts Neues für diese Rolle: Du spielst wie Waffen, mit einer Waffe.
- 20: Beidhändigkeit beim Lehrer: Jetzt kann eine Waffe in deine andere Hand. Durchdringendes Heulen (**Shift-R**, ein Talent): verlangsamt alle Gegner in deiner Nähe. Siegesrausch (**F2**), Spalten (**Shift-4**). Danach Hinrichten (**4**) mit 24, Tollkühne Schwünge (**Shift-F1**, ein Talent) mit 25. Die Talentstufen hier sind die frühesten; ein Perk kann sie bis zu 5 Stufen früher bringen.
- 30: Todeswunsch (**Shift-3**, ein Talent). Berserkerhaltung (**Ctrl-3**, aus einer Quest) mit Abfangen (**R**) und Berserkerwut (**Shift-V**). Danach Wirbelwind (**2** in Berserkerhaltung) mit 36, Zuschlagen (**E** in Berserkerhaltung) mit 38.
- 40: Blutdurst (**3**, ein Talent; du brauchst zuerst Todeswunsch). Er heilt nicht; er lässt dich schneller laufen. Plattenpanzer beim Lehrer.
- 50: Tollkühnheit (**Q** in Berserkerhaltung). Stärkere Ränge von Blutdurst.
- 60: wieder stärkere Ränge; nichts Neues für diese Rolle.
**Anfängerfehler:**
- Furor mit einer guten und einer schlechten zweiten Waffe spielen.
- Wirbelwind (**2**) in Kampfhaltung suchen. Er wirkt nur in Berserkerhaltung, und dort wirken Verwunden und Donnerknall nicht.
- Todeswunsch (**Shift-3**) in einem Kampf, den du verlieren könntest. 30 Sekunden lang nimmst du auch 5% mehr Schaden.]] },
		},
		MAGE = {
			{ band = 1, title = "Arkan: Schaden aus der Ferne", body = [[
Ab Stufe 8 (Arkane Geschosse). Arkanschlag ist ein Talent, frühestens 20; bis dahin spielst du wie jeder Magier, mit Frostblitz, Feuerball und Arkane Geschosse. Die Guides sind sich uneinig: Manche nennen Arkan stark zum Leveln, die meisten raten zu Frost und nennen Arkan hungrig nach Mana. Sein Baum hat keine Verlangsamungen, also hält er Gegner am schlechtesten auf Abstand. Ein **kanalisierter Zauber** ist ein Zauber, der läuft, während du stillstehst; Bewegen stoppt ihn. Arkane Geschosse ist einer.
**Einfache Reihenfolge:**
1. Eröffne mit Frostblitz (**2**): Der Gegner kommt dann langsam.
2. Arkanschlag (**Ctrl-2**, ab 20): einer oder zwei, auf einem Boss bis zu vier. Jeder macht den nächsten teurer an Mana.
3. Geschosssalve (ab 15) leuchtet auf? Sofort Arkane Geschosse (**3**): kostenlos und doppelt so schnell.
4. Arkaner Zorn (**Shift-F1**, ab 25), sobald er bereit ist.
5. Gegner nah bei dir? Frostnova (**V**), geh ein Stück weg.
6. Fast tot: dein Zauberstab (**Ctrl-3**, bis 40) oder Feuerschlag (**5**).
7. Zäher Gegner oder Boss: Geistesgegenwart (**Shift-3**, ab 30), dann Arkaner Zorn für einen großen spontanen Treffer. Ab 40 auch Arkane Macht (**Q**).
Mehrere Gegner: Frostnova (**V**), dann Arkane Explosion (**Shift-2**, ab 14). Wenig Mana? Hervorrufung (**F1**, ab 20).
**Alle 10 Stufen:**
- 10: Frostnova (**V**). Erstes Talent: Verbesserte Kanalisierung (Arkane Geschosse wird nicht mehr verkürzt, wenn du getroffen wirst). Danach Arkane Explosion (**Shift-2**) mit 14, Geschosssalve (ein Talent, passiv) mit 15. Die Talentstufen hier sind die frühesten; ein Perk kann sie bis zu 5 Stufen früher bringen.
- 20: Arkanschlag (**Ctrl-2**, ein Talent). Blinzeln (**R**), Hervorrufung (**F1**), Manaschild (**Z**). Danach Gegenzauber (**E**) mit 24, Arkaner Zorn (**Shift-F1**, ein Talent; du brauchst zuerst Arkanschlag) mit 25.
- 30: Geistesgegenwart (**Shift-3**, ein Talent): Dein nächster Zauber mit einer Zauberzeit unter 10 Sekunden ist spontan. Eisrüstung (**Shift-Z**). Danach Magische Rüstung (Block D) mit 34.
- 40: Arkane Macht (**Q**, ein Talent; du brauchst zuerst Geistesgegenwart): 15 Sekunden lang machen deine Zauber 30% mehr Schaden, kosten aber 30% mehr Mana. Frostfeuerblitz nimmt **Ctrl-3**: Leg deinen Zauberstab (Schießen) auf deine eigene Alt-Taste.
- 50: stärkere Ränge von Arkanschlag, Arkaner Zorn und Arkane Geschosse; nichts Neues für diese Rolle.
- 60: wieder stärkere Ränge; nichts Neues für diese Rolle.
**Anfängerfehler:**
- Arkanschlag immer wieder drücken. Jeder macht den nächsten 100% teurer an Mana; du bist schnell leer.
- Bewegen während Arkane Geschosse. Es ist ein kanalisierter Zauber: Bewegen stoppt ihn.
- Arkane Macht auf einen normalen Gegner. Sie macht deine Zauber auch teurer, und sie hat 3 Minuten Abklingzeit.]] },
			{ band = 2, title = "Feuer: Schaden aus der Ferne", body = [[
Ab Stufe 1 (Feuerball). Pyroschlag ist ein Talent, frühestens 20. Das echte Feuer-Spiel beginnt mit Aufwärmen (frühestens 25); davor ist Pyroschlag nur ein Eröffner. Die Guides sagen, Feuer macht den meisten Schaden auf einen Gegner und levelt schnell, aber mit mehr Risiko als Frost: Es hat kein eigenes Einfrieren. Ein **kritischer Treffer** ist ein glücklicher, stärkerer Treffer.
**Einfache Reihenfolge:**
1. Eröffne aus der Ferne mit Pyroschlag (**4**, ab 20). Davor: Feuerball (**1**).
2. Feuerball (**1**) als dein normaler Zauber.
3. Feuerschlag (**5**), sobald er bereit ist. Ab 25 gibt jeder Feuerschlag einen Stapel Aufwärmen.
4. Zwei oder drei Stapel Aufwärmen (ab 25)? Pyroschlag (**4**).
5. Gegner nah: Versengen (**Ctrl-1**, ab 22) statt Feuerball, oder Frostnova (**V**) und geh ein Stück weg. Ab 30 danach Druckwelle (**F3**).
6. Fast tot: dein Zauberstab (**Ctrl-3**, bis 40) oder Feuerschlag.
7. Elitegegner oder Boss, ab 40: Verbrennung (**Q**).
Mehrere Gegner: Frostnova (**V**), Flammenstoß (**Shift-4**, ab 16), Druckwelle (**F3**, ab 30).
**Alle 10 Stufen:**
- 10: Frostnova (**V**). Erstes Talent: Beschleuniger (Feuerball wird schneller gewirkt). Danach Entzünden und Einschlag (Talente) mit 15, Flammenstoß (**Shift-4**) mit 16. Die Talentstufen hier sind die frühesten; ein Perk kann sie bis zu 5 Stufen früher bringen.
- 20: Pyroschlag (**4**, ein Talent): 6 Sekunden Zauberzeit, also nur als Eröffner. Blinzeln (**R**), Hervorrufung (**F1**), Feuerzauberschutz (**F4**), Manaschild (**Z**). Danach Versengen (**Ctrl-1**) mit 22, Gegenzauber (**E**) mit 24, Aufwärmen (ein Talent, passiv; du brauchst zuerst Pyroschlag) mit 25: Ein kritischer Treffer mit Feuerball, Frostfeuerblitz, Feuerschlag oder Versengen macht deinen nächsten Pyroschlag 25% schneller, bis zu 3 Stapel.
- 30: Druckwelle (**F3**, ein Talent): spontan, um dich herum; Gegner sind 6 Sekunden lang 50% langsamer. Kritische Masse (ein Talent). Eisrüstung (**Shift-Z**). Danach Feuermacht (ein Talent) mit 35.
- 40: Verbrennung (**Q**, ein Talent; du brauchst zuerst Kritische Masse). Frostfeuerblitz nimmt **Ctrl-3**: Leg deinen Zauberstab (Schießen) auf deine eigene Alt-Taste.
- 50: stärkere Ränge von Feuerball, Pyroschlag, Druckwelle und Frostfeuerblitz; nichts Neues für diese Rolle.
- 60: wieder stärkere Ränge; nichts Neues für diese Rolle.
**Anfängerfehler:**
- Pyroschlag wirken, wenn der Gegner schon bei dir ist. 6 Sekunden Zauberzeit sind dann zu langsam.
- Glauben, dass drei Stapel Aufwärmen Pyroschlag spontan machen. Er hat immer noch 1,5 Sekunden Zauberzeit: Bleib stehen.
- Einen Eisblock suchen. Feuer hat keinen. Dein Ausweg: Frostnova (**V**), Blinzeln (**R**), Druckwelle (**F3**).]] },
			{ band = 3, title = "Frost: Schaden aus der Ferne", body = [[
Ab Stufe 4 (Frostblitz); Frostnova kommt mit 10. Eislanze ist ein Talent, frühestens 20. Zum Leveln ist Frost die erste Wahl der meisten Guides: Sie nennen ihn den sichersten. Richtig in Fahrt kommt er um 30. **Eingefroren** = der Gegner ist an seinem Platz festgefroren und kann sich nicht bewegen.
**Einfache Reihenfolge:**
1. Frostblitz (**2**) aus so großer Entfernung wie möglich. Jeder Treffer verlangsamt den Gegner.
2. Gegner eingefroren (durch Frostnova oder durch das Talent Erfrierung)? Eislanze (**F**, ab 20).
3. Gegner nah? Frostnova (**V**), geh ein Stück weg, Frostblitz, dann Eislanze.
4. Eisige Finger leuchtet auf (ab 30)? Eislanze.
5. Eislanze nicht bereit und der Gegner ist nah: Kältekegel (**Shift-F**, ab 26).
6. Fast tot: dein Zauberstab (**Ctrl-3**, bis 40) oder Feuerschlag (**5**).
Mehrere Gegner (ab 20): Frostnova (**V**), geh ein Stück weg, Blizzard (**Shift-1**), dann Kältekegel (**Shift-F**). In Not: Eisblock (**C**, ab 25), Blinzeln (**R**).
**Alle 10 Stufen:**
- 10: Frostnova (**V**). Erstes Talent: Verbesserter Frostblitz (eine kürzere Zauberzeit). Danach Erfrierung (ein Talent) mit 15: Deine Verlangsamungen können den Gegner 5 Sekunden lang einfrieren. Die Talentstufen hier sind die frühesten; ein Perk kann sie bis zu 5 Stufen früher bringen.
- 20: Eislanze (**F**, ein Talent): 300% mehr Schaden auf einen eingefrorenen Gegner. Blizzard (**Shift-1**), Blinzeln (**R**), Hervorrufung (**F1**), Manaschild (**Z**). Danach Frostzauberschutz (**F2**) mit 22, Gegenzauber (**E**) mit 24, Eisblock (**C**, ein Talent) mit 25, Kältekegel (**Shift-F**) mit 26.
- 30: Kälteeinbruch (**Shift-C**, ein Talent): setzt die Abklingzeit deiner anderen Frostzauber zurück; seine eigene Abklingzeit ist 10 Minuten. Eisige Finger (ein Talent; du brauchst zuerst Eislanze): Deine nächsten 2 Zauber wirken, als wäre der Gegner eingefroren. Eisrüstung (**Shift-Z**). Danach Winterkälte (ein Talent) mit 35.
- 40: Eisbarriere (**X**, ein Talent; du brauchst zuerst Kälteeinbruch): ein Schild, der Schaden aufsaugt. Frostfeuerblitz nimmt **Ctrl-3**: Leg deinen Zauberstab (Schießen) auf deine eigene Alt-Taste.
- 50: stärkere Ränge von Frostblitz, Kältekegel, Eisrüstung, Eisbarriere und Blizzard; nichts Neues für diese Rolle.
- 60: wieder stärkere Ränge; nichts Neues für diese Rolle.
**Anfängerfehler:**
- Eislanze auf einen Gegner, der nicht eingefroren ist. Dann ist sie ein kleiner Treffer.
- Feuerschlag kurz vor einem Einfrieren drücken. Feuerschlag und Eislanze teilen sich eine Abklingzeit von 8 Sekunden.
- Kälteeinbruch für nichts nutzen. Er hat 10 Minuten Abklingzeit: Heb ihn auf, wenn etwas schiefgeht.]] },
		},
		PRIEST = {
			{ band = 1, title = "Disziplin: Heiler", body = [[
Ab Stufe 1: Geringes Heilen hast du von Anfang an. Die eigenen Zauber des Baums kommen später: Seelenwehr mit 25 und Sühne mit 30, beide frühestens. In einer Gruppe ist er am stärksten darin, eine Person zu heilen, den Tank. Allein leveln klappt mit Göttliche Pein, Heiliges Feuer und deinem Zauberstab, später Sühne; die Guides sind sich uneinig, ob das schneller ist als Schatten. **Geschwächte Seele**: Nach einem Machtwort: Schild kann dieselbe Person 15 Sekunden lang keinen neuen Schild bekommen.
**Einfache Reihenfolge (in einer Gruppe):**
1. Machtwort: Schild (**Z**) auf den Tank, kurz vor dem Pull. **Pull** = der erste Treffer, der einen Kampf beginnt.
2. Erneuerung (**F4**) auf den Tank.
3. Sühne (**Shift-F1**, ab 30) auf den, der verletzt ist, jedes Mal, wenn sie bereit ist.
4. Deine große Heilung (**C**) für normalen Schaden.
5. Blitzheilung (**F2**, ab 20), wenn C zu langsam ist.
6. Mehr Leute verletzt: Gebet der Heilung (**Shift-2**, ab 30).
7. Innerer Fokus (**F1**, ab 20) vor einer teuren Heilung. Seele der Macht (**Q**, ab 40) auf dich oder einen Zauberwirker.
Allein: Schild (**Z**), Heiliges Feuer (**4**, ab 20), Göttliche Pein (**1**), Gedankenschlag (**3**), Schattenwort: Schmerz (**2**), Sühne, wenn du sie nicht zum Heilen brauchst, dann dein Zauberstab (**5**).
**Alle 10 Stufen:**
- 10: Geringes Heilen (**C**), Machtwort: Schild (**Z**), Erneuerung (**F4**), Auferstehung (**F3**, nur außerhalb eines Kampfes), Göttliche Pein (**1**). Danach Inneres Feuer (**Shift-Z**) mit 12, Krankheit heilen (**Shift-C**) mit 14, Heilen (**C**) mit 16, Magiebannung (**Shift-V**) mit 18.
- 20: Blitzheilung (**F2**), Heiliges Feuer (**4**), Furchtzauberschutz (Block D). Innerer Fokus (**F1**, ein Talent): Dein nächster Zauber kostet kein Mana und trifft öfter kritisch; Abklingzeit 3 Minuten. Danach Seelenwehr (ein Talent, passiv) mit 25: Schild hat keine Abklingzeit und kostet weniger. Die Talentstufen hier sind die frühesten; ein Perk kann sie bis zu 5 Stufen früher bringen.
- 30: Sühne (**Shift-F1**, ein Talent): heilt einen Freund oder verletzt einen Gegner; Abklingzeit 12 Sekunden. Gebet der Heilung (**Shift-2**), Göttlicher Willen (Block D). Danach Krankheit aufheben (**Shift-C**) mit 32, Göttliche Aegis (ein Talent, passiv) mit 35.
- 40: Seele der Macht (**Q**, ein Talent; du brauchst zuerst Sühne): 20% mehr Zauberschaden und Heilung; Abklingzeit 3 Minuten. Große Heilung übernimmt **C**.
- 50: stärkere Ränge von Sühne, Gebet der Heilung, Blitzheilung und Erneuerung. Gebet der Seelenstärke (**Shift-X**) mit 48.
- 60: wieder stärkere Ränge; nichts Neues für diese Rolle.
**Anfängerfehler:**
- Denselben Spieler zweimal hintereinander abschirmen. Geschwächte Seele verhindert es. Es gilt pro Spieler: Jemand anderes kann sofort einen Schild bekommen.
- Sühne auf einen Gegner, um deine Gruppe zu heilen. Sie heilt oder verletzt, nicht beides.
- Gebet der Heilung auf den falschen Spieler. Es heilt die Gruppe des Spielers, den du wählst.]] },
			{ band = 2, title = "Heilig: Heiler", body = [[
Ab Stufe 1: Geringes Heilen hast du von Anfang an. Heilig ist der Gruppenheiler. Allein levelt er langsam: Die Guides raten, mit Göttliche Pein und deinem Zauberstab zu questen und in Dungeons zu heilen. Die eigenen Zauber des Baums kommen spät: Heilige Nova mit 20 und Gebet der Besserung mit 40, beide frühestens.
**Einfache Reihenfolge (in einer Gruppe):**
1. Erneuerung (**F4**) auf den Tank, wenn der Pull beginnt. **Pull** = der erste Treffer, der einen Kampf beginnt.
2. Gebet der Besserung (**Ctrl-2**, ab 40) auf den Tank vor dem Pull, und wieder jedes Mal, wenn es bereit ist.
3. Deine große Heilung (**C**) für normalen Schaden.
4. Blitzheilung (**F2**, ab 20), wenn C zu spät käme.
5. Ganze Gruppe verletzt: Gebet der Heilung (**Shift-2**, ab 30). Heilige Nova (**Shift-1**, ab 20) nur, wenn alle direkt neben dir stehen; sie kostet viel Mana.
6. Machtwort: Schild (**Z**), um Zeit zu gewinnen.
7. Ein Gegner greift dich an: Verblassen (**F**).
**Alle 10 Stufen:**
- 10: Geringes Heilen (**C**), Machtwort: Schild (**Z**), Erneuerung (**F4**), Auferstehung (**F3**, nur außerhalb eines Kampfes). Danach Inneres Feuer (**Shift-Z**) mit 12, Krankheit heilen (**Shift-C**) mit 14, Heilen (**C**) mit 16, Magiebannung (**Shift-V**) mit 18.
- 20: Heilige Nova (**Shift-1**, ein Talent): spontan; verletzt Gegner um dich herum und heilt deine Gruppe, ohne Bedrohung. Blitzheilung (**F2**), Heiliges Feuer (**4**), Furchtzauberschutz (Block D). Danach Heilige Bindung (ein Talent, passiv) mit 25: Blitzheilung auf jemand anderen heilt dich um die Hälfte. Die Talentstufen hier sind die frühesten; ein Perk kann sie bis zu 5 Stufen früher bringen.
- 30: Gebet der Heilung (**Shift-2**), Göttlicher Willen (Block D). Geist der Erlösung (ein Talent, passiv). Danach Krankheit aufheben (**Shift-C**) mit 32, Spirituelle Heilung (ein Talent, passiv) mit 35.
- 40: Gebet der Besserung (**Ctrl-2**, ein Talent; du brauchst zuerst Geist der Erlösung): Es heilt, sobald das Ziel Schaden nimmt, dann springt es zu einem anderen Gruppenmitglied, bis zu 5-mal; Abklingzeit 10 Sekunden. Große Heilung übernimmt **C**.
- 50: stärkere Ränge von Gebet der Besserung, Heilige Nova, Gebet der Heilung und Erneuerung. Gebet der Seelenstärke (**Shift-X**) mit 48.
- 60: wieder stärkere Ränge; nichts Neues für diese Rolle.
**Anfängerfehler:**
- Gebet der Heilung auf den falschen Spieler. Es heilt die Gruppe des Spielers, den du wählst, nicht deine eigene.
- Blitzheilung für alles. Sie ist schnell, aber teuer; heb sie für Notfälle auf.
- Heilige Nova auf eine Gruppe, die weit weg steht. Sie wirkt nur direkt um dich herum, und sie kostet viel.]] },
			{ band = 3, title = "Schatten: Schaden aus der Ferne", body = [[
Ab Stufe 4 (Schattenwort: Schmerz); Gedankenschlag kommt mit 10. Gedankenschinden ist ein Talent, frühestens 20; Schattengestalt mit 40. Die meisten Guides leveln als Schatten; manche spielen Disziplin bis 40. Am Anfang macht dein Zauberstab viel von der Arbeit. Schatten hat keinen Zauber, der viele Gegner auf einmal trifft. Ein **DoT** ist Schaden in kleinen Stücken über ein paar Sekunden. Ein **kanalisierter Zauber** ist ein Zauber, der läuft, während du stillstehst.
**Einfache Reihenfolge:**
1. Machtwort: Schild (**Z**) auf dich, wenn der Gegner dich erreichen wird.
2. Gedankenschlag (**3**) aus der Ferne, zum Start.
3. Schattenwort: Schmerz (**2**).
4. Verschlingende Seuche (**Shift-3**, ab 20) auf einen Gegner, der eine Weile lebt.
5. Gedankenschinden (**1**, ab 20), und lass es bis zum Ende laufen. Davor: Göttliche Pein (**1**).
6. Erledige den Gegner mit deinem Zauberstab (**5**).
Wenig Mana? Lass Verschlingende Seuche und Gedankenschinden weg und nimm früher deinen Zauberstab. Ab 32: Schattenwort: Tod (**Shift-4**) nur, wenn es den Gegner tötet. Ab 40: Schattengestalt (**Ctrl-1**) vor dem ersten Pull an, und lass sie an.
**Alle 10 Stufen:**
- 10: Gedankenschlag (**3**), Abklingzeit 8 Sekunden. Du hast schon Göttliche Pein (**1**), Schattenwort: Schmerz (**2**), Machtwort: Schild (**Z**), Verblassen (**F**) und deinen Zauberstab (**5**). Danach Inneres Feuer (**Shift-Z**) mit 12, Psychischer Schrei (**V**) mit 14.
- 20: Gedankenschinden (ein Talent): übernimmt Taste **1** von Göttliche Pein. Verschlingende Seuche (**Shift-3**): ein DoT, der dich auch heilt; Abklingzeit 24 Sekunden. Danach Vampirumarmung (**Ctrl-3**, ein Talent) mit 25 oder 30: Deine Gruppe wird um 20% deines Schattenschadens geheilt. Die Talentstufen hier sind die frühesten; ein Perk kann sie bis zu 5 Stufen früher bringen.
- 30: Stille (**E**, ein Talent): deine **Unterbrechung** (sie stoppt den Zauber eines Gegners); Abklingzeit 45 Sekunden. Gedankenkontrolle (**Shift-F**). Danach Schattenwort: Tod (**Shift-4**) mit 32, Levitieren (**R**) mit 34.
- 40: Schattengestalt (**Ctrl-1**, ein Talent; du brauchst zuerst Vampirumarmung): 10% mehr Schattenschaden, Schattenzauber kosten die Hälfte, du nimmst 15% weniger körperlichen Schaden, aber keine Heilzauber. Davor: Dunkelheit (ein Talent, passiv) mit 35.
- 50: stärkere Ränge von Gedankenschinden, Gedankenschlag, Schattenwort: Schmerz, Verschlingende Seuche und Schattenwort: Tod. Gebet der Seelenstärke (**Shift-X**) mit 48.
- 60: stärkere Ränge von Gedankenschinden und Verschlingende Seuche; nichts Neues für diese Rolle.
**Anfängerfehler:**
- Schattenwort: Tod auf einen Gegner mit viel Gesundheit. Stirbt er nicht, verlierst du 30% deiner eigenen Gesundheit.
- Gedankenschinden zu früh abbrechen. Mit dem Talent Verbessertes Gedankenschinden ist der letzte Tick der stärkste.
- In einer Gruppe mit Gedankenschlag eröffnen. Er macht viel Bedrohung (wie sehr ein Gegner dich angreifen will): Lass den Tank zuerst gehen. Greift dich ein Gegner an: Verblassen (**F**).]] },
		},
		ROGUE = {
			{ band = 1, title = "Meucheln: Dolche und Gift", body = [[
Ab Stufe 1 (Finsterer Stoß und Ausweiden). Du kämpfst aus der Nähe, mit Dolchen und Gift. Du nutzt **Energie**, die sich von selbst füllt. Deine Treffer geben **Combopunkte** (bis zu 5) auf dem Gegner, den du triffst; ein **Finisher** verbraucht sie alle. Verstümmeln ist ein Talent, frühestens 40, und braucht einen Dolch in jeder Hand. Bis dahin spielst du mit Meucheln oder Finsterer Stoß. Die Guides nennen das nicht den leichtesten Start: Der große Schritt kommt erst mit Verstümmeln.
**Einfache Reihenfolge:**
1. Ab 20: Gift auf beide Waffen (Gegenstände, auf Block D).
2. Warte auf volle Energie. Ab 18 (Bereitschaft) kostet dein erster Angriff dann 10 Energie weniger.
3. Verstohlenheit (**Shift-R**), geh hinter den Gegner. **Verstohlenheit** = schleichen, damit der Gegner dich nicht sieht. Eröffne mit Hinterhalt (**2**, ab 18, Dolch in deiner Haupthand) oder Erdrosseln (**1**, ab 14). Starker Gegner, ab 26: Fieser Trick (**V**), eine Betäubung von 4 Sekunden.
4. Combopunkte: Meucheln (**2**), wenn du hinter dem Gegner stehst, sonst Finsterer Stoß (**1**). Ab 40: Verstümmeln (**3**), jedes Mal 2 Punkte.
5. Scharfe Klinge (**Shift-3**, ab 24), sobald sie bereit ist. Mit Toxin (ab 30) macht jede Scharfe Klinge dein Gift 6 Sekunden lang stärker.
6. Finisher: Zerhäckseln (**Shift-4**) in einem langen Kampf; sonst Ausweiden (**4**) bei 5 Punkten. Blutung (**5**, ab 20) auf einen Gegner, der lange lebt (ein Elitegegner, ein Boss).
7. Kaltblütigkeit (**F1**, ab 25) kurz vor einem Ausweiden mit 5 Punkten.
**Alle 10 Stufen:**
- 10: Du hast schon Finsterer Stoß (**1**), Ausweiden (**4**), Meucheln (**2**), Verstohlenheit (**Shift-R**), Solarplexus (**Shift-Q**) und Entrinnen (**Z**). Neu mit 10: Zerhäckseln (**Shift-4**), Sprinten (**R**), Kopfnuss (**Shift-Q** in Verstohlenheit) und eine Waffe in jeder Hand (Beidhändigkeit). Danach Tritt (**E**) mit 12, Erdrosseln (**1** in Verstohlenheit) und Rüstung schwächen (**Shift-Z**) mit 14, Finte (**F**) mit 16, Hinterhalt (**2** in Verstohlenheit) und Bereitschaft (passiv) mit 18.
- 20: Blutung (**5**). Gifte, aus einer Quest. Danach Verschwinden (**X**) mit 22, Scharfe Klinge (**Shift-3**) mit 24, Kaltblütigkeit (**F1**, ein Talent) mit 25: Dein nächster Finsterer Stoß, Meucheln, Hinterhalt, Ausweiden oder Verstümmeln trifft sicher kritisch (**kritischer Treffer** = ein glücklicher, stärkerer Treffer); Abklingzeit 3 Minuten. Fieser Trick (**V** in Verstohlenheit) mit 26. Die Talentstufen hier sind die frühesten; ein Perk kann sie bis zu 5 Stufen früher bringen.
- 30: Toxin (ein Talent, passiv: keine Taste): Jede Scharfe Klinge gibt deinem Gift 6 Sekunden lang 30% mehr Schaden und 20% mehr Chance zu wirken. Nierenhieb (**V**). Danach Blenden (**Shift-V**) mit 34, Schicksal besiegeln (ein Talent, passiv) mit 35: Ein kritischer Treffer mit einem Angriff, der Combopunkte gibt, gibt dir einen Extrapunkt.
- 40: Verstümmeln (**3**, ein Talent; du brauchst zuerst Toxin): 60 Energie, trifft mit beiden Dolchen, 2 Combopunkte, 20% mehr Schaden auf einen vergifteten Gegner. Danach Zerhäckseln Rang 2 mit 42, Scharfe Klinge Rang 2 mit 44.
- 50: Verstümmeln Rang 2 und Nierenhieb Rang 2; nichts Neues für diese Rolle.
- 60: Verstümmeln Rang 3 und stärkere Ränge; nichts Neues für diese Rolle.
**Anfängerfehler:**
- Verstümmeln ohne Dolche. Es braucht einen Dolch in jeder Hand: Besorg dir deinen zweiten Dolch vor Stufe 40.
- Scharfe Klinge vergessen. Toxin wirkt nur über Scharfe Klinge.
- Mit Combopunkten auf dem alten Gegner zu einem anderen Gegner wechseln. Die Punkte kommen nicht mit.]] },
			{ band = 2, title = "Kampf: gleichmäßiger Schaden mit jeder Waffe", body = [[
Ab Stufe 1 (Finsterer Stoß und Ausweiden). Du musst nicht hinter dem Gegner stehen: Dein wichtigster Treffer ist Finsterer Stoß. Er funktioniert mit jeder Einhandwaffe: Schwert, Axt, Streitkolben, Faustwaffe oder Dolch. Mehrere Guides nennen Kampf den leichtesten Baum, um allein zu leveln. Sie raten zu einer langsamen Waffe in deiner Haupthand und einer schnellen in deiner Nebenhand. Du nutzt **Energie**, die sich von selbst füllt; deine Treffer geben **Combopunkte**, und ein **Finisher** verbraucht sie. Klingenwirbel (frühestens 30) ist das Einzige, was ein Schurke gegen zwei Gegner auf einmal hat.
**Einfache Reihenfolge:**
1. Warte auf volle Energie (Bereitschaft, ab 18).
2. Eröffne aus der Verstohlenheit (**Shift-R**) mit Erdrosseln (**1**, ab 14), oder ab 26 mit Fieser Trick (**V**). Einfach hingehen und angreifen ist auch in Ordnung.
3. Finsterer Stoß (**1**) für Combopunkte.
4. Riposte (**Shift-F1**, ab 20), sobald sie aufleuchtet: Das passiert, nachdem du einen Angriff parierst.
5. Scharfe Klinge (**Shift-3**, ab 24), wenn sie bereit ist.
6. Finisher: Zerhäckseln (**Shift-4**) in einem langen Kampf; sonst Ausweiden (**4**) bei 5 Punkten. Die Guides sind sich uneinig, wie früh du Zerhäckseln aufrechthalten sollst.
7. Zwei Gegner: Klingenwirbel (**Shift-1**, ab 30). Ab 40 zusammen mit Adrenalinrausch (**Q**) für einen harten Kampf. Du verlierst? Entrinnen (**Z**).
**Alle 10 Stufen:**
- 10: Du hast schon Finsterer Stoß (**1**), Ausweiden (**4**), Verstohlenheit (**Shift-R**), Solarplexus (**Shift-Q**) und Entrinnen (**Z**). Neu mit 10: Zerhäckseln (**Shift-4**), Sprinten (**R**), Kopfnuss (**Shift-Q** in Verstohlenheit) und eine Waffe in jeder Hand. Danach Tritt (**E**) mit 12, Erdrosseln (**1** in Verstohlenheit) und Rüstung schwächen (**Shift-Z**) mit 14, Finte (**F**) mit 16, Bereitschaft (passiv) mit 18.
- 20: Riposte (**Shift-F1**, ein Talent; du brauchst zuerst Abwehr): wirkt nur direkt, nachdem du einen Angriff parierst. 10 Energie, und der Gegner ist 6 Sekunden lang entwaffnet. Blutung (**5**) und Gifte aus einer Quest. Danach Verschwinden (**X**) mit 22, Scharfe Klinge (**Shift-3**) mit 24, Perfekte Ausführung (ein Talent, passiv) mit 25: Ausweiden kostet 15 Energie weniger. Fieser Trick (**V** in Verstohlenheit) mit 26. Die Talentstufen hier sind die frühesten; ein Perk kann sie bis zu 5 Stufen früher bringen.
- 30: Klingenwirbel (**Shift-1**, ein Talent): 15 Sekunden lang greifst du 20% schneller an, und jeder Treffer trifft auch einen zweiten Gegner in der Nähe; Abklingzeit 2 Minuten. Niedermetzeln (ein Talent, passiv): ein Bonus, der von deiner Waffe abhängt. Nierenhieb (**V**). Danach Blenden (**Shift-V**) mit 34, Blitzender Stahl (ein Talent, passiv) mit 35: Scharfe Klinge gibt bis zu 15 Energie extra und ist bis zu 2 Sekunden früher bereit.
- 40: Adrenalinrausch (**Q**, ein Talent; du brauchst zuerst Klingenwirbel): 15 Sekunden lang füllt sich deine Energie doppelt so schnell; Abklingzeit 5 Minuten. Danach Zerhäckseln Rang 2 mit 42 (30% schneller statt 20%), Scharfe Klinge Rang 2 mit 44 (25 Energie zurück statt 15).
- 50: Nierenhieb Rang 2 und stärkere Ränge; nichts Neues für diese Rolle.
- 60: stärkere Ränge; nichts Neues für diese Rolle.
**Anfängerfehler:**
- Klingenwirbel neben einem Gegner, den du mit Kopfnuss, Solarplexus oder Blenden ausgeschaltet hast. Die Extratreffer wecken ihn auf.
- Riposte drücken, wenn nichts pariert wurde. Sie wirkt nur direkt nach einer Parade.
- Meucheln oder Hinterhalt mit Schwert, Axt oder Streitkolben. Beide brauchen einen Dolch in deiner Haupthand.]] },
			{ band = 3, title = "Täuschung: aus der Verstohlenheit zuschlagen", body = [[
Ab Stufe 1 (Finsterer Stoß und Verstohlenheit). Dieser Baum kämpft aus der Verstohlenheit: ein starker erster Treffer und viele Combopunkte, bevor der Kampf richtig beginnt. **Verstohlenheit** = schleichen, damit der Gegner dich nicht sieht. Die Guides sagen, allein leveln geht langsamer als mit Kampf. Blutsturz ist ein Talent, frühestens 30: billig, von vorn, mit jeder Waffe, aber mit einem Dolch trifft er härter.Todesmal ist ein Talent, frühestens 40. Hinterhalt und Meucheln brauchen einen Dolch in deiner Haupthand; Blutsturz und Geisterhafter Stoß nicht.
**Einfache Reihenfolge:**
1. Verstohlenheit (**Shift-R**). Ein zweiter Humanoid in der Nähe? Kopfnuss (**Shift-Q**). Kopfnuss bricht die Verstohlenheit nicht.
2. Konzentration (**Shift-C**, ab 20): 2 Combopunkte auf dem Gegner. Dann dein erster Treffer.
3. Erster Treffer von hinten: Hinterhalt (**2**, ab 18, Dolch in deiner Haupthand). Starker Gegner, ab 26: Fieser Trick (**V**), eine Betäubung von 4 Sekunden. Die Guides sind sich uneinig über den besten Eröffner.
4. Geisterhafter Stoß (**Shift-X**, ab 25) und Scharfe Klinge (**Shift-3**, ab 24), sobald sie bereit sind.
5. Combopunkte: ab 30 Blutsturz (**3**). Davor: Meucheln (**2**), wenn du hinter dem Gegner stehst, sonst Finsterer Stoß (**1**).
6. Finisher: Ausweiden (**4**), wenn der Gegner fast tot ist; Blutung (**5**) auf einen Gegner, der lange lebt; Zerhäckseln (**Shift-4**) in einem langen Kampf.
7. Ab 40: Todesmal (**Q**) auf den stärksten Gegner, am besten, während Blutung oder Erdrosseln läuft.
8. Notfall: Verschwinden (**X**). Vorbereitung (**F3**, ab 30) macht Verschwinden, Entrinnen und Sprinten sofort wieder bereit.
**Alle 10 Stufen:**
- 10: Du hast schon Finsterer Stoß (**1**), Ausweiden (**4**), Meucheln (**2**), Verstohlenheit (**Shift-R**), Solarplexus (**Shift-Q**) und Entrinnen (**Z**). Neu mit 10: Kopfnuss (**Shift-Q** in Verstohlenheit), Zerhäckseln (**Shift-4**), Sprinten (**R**) und eine Waffe in jeder Hand. Danach Tritt (**E**) mit 12, Erdrosseln (**1** in Verstohlenheit) mit 14, Finte (**F**) mit 16, Hinterhalt (**2** in Verstohlenheit) und Bereitschaft (passiv) mit 18.
- 20: Konzentration (**Shift-C**, ein Talent): 2 Combopunkte auf deinem Ziel; nutz sie innerhalb von 20 Sekunden, sonst sind sie weg; Abklingzeit 2 Minuten. Blutung (**5**) und Gifte aus einer Quest. Danach Verschwinden (**X**) mit 22, Scharfe Klinge (**Shift-3**) mit 24, Geisterhafter Stoß (**Shift-X**, ein Talent) mit 25: 40 Energie, 1 Combopunkt, 7 Sekunden lang 15% mehr Ausweichen; Abklingzeit 20 Sekunden. Fieser Trick (**V** in Verstohlenheit) mit 26. Die Talentstufen hier sind die frühesten; ein Perk kann sie bis zu 5 Stufen früher bringen.
- 30: Blutsturz (**3**, ein Talent; du brauchst zuerst Gezahnte Klingen): 35 Energie, 1 Combopunkt, wirkt von vorn; 15 Sekunden lang machen deine Blutung und dein Erdrosseln an diesem Gegner 15% mehr Schaden. Vorbereitung (**F3**, ein Talent): macht die Abklingzeit deiner anderen Schurkenzauber sofort bereit; ihre eigene Abklingzeit ist 10 Minuten. Eins davon bekommst du mit 30, das andere mit 31. Nierenhieb (**V**). Danach Blenden (**Shift-V**) mit 34, Stiefelmesser (ein Talent, passiv) mit 35: Scharfe Klinge kann 2 Combopunkte geben.
- 40: Todesmal (**Q**, ein Talent; du brauchst zuerst Vorbereitung): ein Finisher, 25 Energie, Abklingzeit 10 Sekunden. 6 Sekunden lang speichert es einen Teil deines Schadens (mehr pro Combopunkt) und teilt ihn dann auf einmal aus, bis zu einer Grenze. Schaden von Blutung und Erdrosseln zählt doppelt. Danach Zerhäckseln Rang 2 und Verschwinden Rang 2 mit 42, Scharfe Klinge Rang 2 mit 44, Todesmal Rang 2 mit 48.
- 50: Nierenhieb Rang 2, Todesmal Rang 3 mit 56; nichts Neues für diese Rolle.
- 60: Todesmal Rang 4 und stärkere Ränge; nichts Neues für diese Rolle.
**Anfängerfehler:**
- Hinterhalt oder Meucheln ohne Dolch in deiner Haupthand, oder von vorn.
- Konzentration nutzen und dann warten. Die 2 Punkte sind nach 20 Sekunden weg, und die Abklingzeit ist 2 Minuten.
- Todesmal ohne Combopunkte. Es ist ein Finisher.]] },
		},
		HUNTER = {
			{ band = 1, title = "Tierherrschaft: Schaden mit deinem Begleiter", body = [[
Ab Stufe 10 (dein Begleiter, aus den Klassenquests). Dein Begleiter macht die meiste Arbeit: Er beschäftigt den Gegner, während du aus der Ferne schießt. Die meisten Guides nehmen Tierherrschaft zum Leveln: Sie nennen sie die leichteste und die schnellste. Wowhead fügt hinzu, dass alle drei Bäume funktionieren. Neu in Forever: Falke beschwören (ein Talent, frühestens 25) schickt zusätzliche Vögel auf dein Ziel. Schwachpunkt: Gruppen von Gegnern. Dein Begleiter kann nur einen halten.
**Einfache Reihenfolge:**
Bevor du anfängst: Aspekt des Falken an (**Shift-R**). Das Talent Tödliche Aspekte wirkt nur dann.
1. Mal des Jägers (**Shift-Z**).
2. Begleiter hinein (**Ctrl-1**), und warte, bis er den Gegner hat.
3. Schlangenbiss (**2**).
4. Falke beschwören (**Shift-F1**, ab 25): Halt die ganze Zeit 2 Falken aufrecht.
5. Gezielter Schuss (**4**, ab 20), während du stillstehst. Zwei oder mehr Gegner: stattdessen Mehrfachschuss (**Shift-1**). Sie teilen sich eine Abklingzeit.
6. Automatischer Schuss (**1**) läuft weiter. Arkaner Schuss (**3**): vor 25 einfach nutzen. Ab 25 nur, wenn du schon 2 Falken hast: Er teilt sich eine Abklingzeit mit Falke beschwören.
7. Begleiter fast tot: Tier heilen (**F2**). Gegner bei dir: Einschüchterung (**Shift-3**, ab 30) oder Rückzug (**Z**, ab 20). Rückzug ist kein Sprung: Er sorgt dafür, dass der Gegner dich aus der Nähe weniger angreifen will, und stoppt deinen automatischen Angriff. Echte Not: Totstellen (**X**, ab 30).
8. Zäher Gegner: Zorn des Wildtiers (**F1**, ab 40) zusammen mit Schnellfeuer (**Q**, ab 26).
**Alle 10 Stufen:**
- 10: dein Begleiter, aus den Klassenquests. Aspekt des Falken (**Shift-R**). Erste Talente: Tödliche Aspekte, Belastbarkeit-Ausbildung. Die Talentstufen hier sind die frühesten; ein Perk kann sie bis zu 5 Stufen früher bringen. Danach Tier heilen (**F2**) mit 12, Mehrfachschuss (**Shift-1**) mit 18.
- 20: Gezielter Schuss (**4**, vom Lehrer), Aspekt des Geparden (**R**), Rückzug (**Z**), Eiskältefalle (**V**). Talente: Erhöhte Tiergeschwindigkeit (dein Begleiter läuft 30% schneller; du brauchst es für Einschüchterung), Entfesselter Zorn, Orientierung.
- 30: Einschüchterung (**Shift-3**, ein Talent): Dein Begleiter betäubt den Gegner mit seinem nächsten Treffer 3 Sekunden lang; Abklingzeit 1 Minute. Totstellen (**X**). Davor: Falke beschwören (**Shift-F1**, ein Talent) mit 25: Ein Falke bleibt 18 Sekunden, höchstens 2 gleichzeitig. Schnellfeuer (**Q**) mit 26.
- 40: Zorn des Wildtiers (**F1**, ein Talent; alle 30 Punkte davor müssen in Tierherrschaft sein): Dein Begleiter macht 18 Sekunden lang 50% mehr Schaden; Abklingzeit 2 Minuten. Salve (Block D). Davor: Sprengfalle übernimmt **Shift-2** mit 34, Raserei (ein Talent, passiv) mit 35.
- 50: stärkere Ränge von Falke beschwören, Gezielter Schuss und Tier heilen; nichts Neues für diese Rolle. Nach 40 stecken die Guides deine Punkte in Treffsicherheit.
- 60: wieder stärkere Ränge; nichts Neues für diese Rolle.
**Anfängerfehler:**
- Schießen, bevor dein Begleiter den Gegner hat. Dann kommt der Gegner zu dir.
- Falke beschwören und Arkaner Schuss als zwei getrennte Tasten sehen. Sie teilen sich eine Abklingzeit: Falken zuerst.
- Kämpfen in Aspekt des Geparden oder Aspekt des Affen. Tödliche Aspekte wirkt nur mit dem Falken.]] },
			{ band = 2, title = "Treffsicherheit: Schaden aus der Ferne", body = [[
Ab Stufe 1 (Automatischer Schuss). Deine eigenen Schüsse machen die Arbeit, aus großer Entfernung. Gezielter Schuss kommt mit 20 vom Lehrer: Er ist kein Talent. Heckenschützenschuss ist ein Talent, frühestens 40: 4 Sekunden Zauberzeit und bis zu 45 Meter Reichweite. Die Guides sagen, Leveln klappt, aber langsamer als Tierherrschaft: Dein Begleiter hält den Gegner schlechter, weil du mehr Schaden machst. In Gruppen ist es stark: Aura des Volltreffers hilft deiner ganzen Gruppe oder deinem Schlachtzug. Einsamer Wolf (ein Talent, frühestens 20) gibt 20% mehr Schaden, solange du keinen Begleiter hast; zum Leveln behalten die Guides den Begleiter.
**Einfache Reihenfolge:**
Bevor du anfängst: Aspekt des Falken (**Shift-R**) und Aura des Volltreffers (**Shift-X**, ab 25) an.
1. Mal des Jägers (**Shift-Z**). Mit Begleiter: Begleiter hinein (**Ctrl-1**).
2. Gegner noch weit weg: Heckenschützenschuss (**Shift-4**, ab 40) zum Eröffnen.
3. Schlangenbiss (**2**). Manche Guides lassen ihn in kurzen Kämpfen weg.
4. Gezielter Schuss (**4**, ab 20) jedes Mal, wenn er bereit ist. Bleib stehen.
5. Arkaner Schuss (**3**) dazwischen, wenn dein Mana es erlaubt.
6. Automatischer Schuss (**1**) läuft weiter.
7. Eine Gruppe von Gegnern: Mehrfachschuss (**Shift-1**) statt Gezielter Schuss. Eine große Gruppe: Salve (Block D, ab 40).
8. Gegner bei dir: Streuschuss (**E**, ab 30), dann geh ein Stück weg. Erschütternder Schuss (**Shift-Q**) verlangsamt ihn.
9. Zäher Gegner: Schnellfeuer (**Q**, ab 26) am Anfang.
**Alle 10 Stufen:**
- 10: dein Begleiter, aus den Klassenquests. Aspekt des Falken (**Shift-R**). Erste Talente: Tödliche Angriffe, Falkenauge, Verbesserter erschütternder Schuss; ab 15: Sorgfältiges Zielen, Effizienz, Verbesserte Stiche und Bisse. Die Talentstufen hier sind die frühesten; ein Perk kann sie bis zu 5 Stufen früher bringen. Danach Mehrfachschuss (**Shift-1**) mit 18.
- 20: Gezielter Schuss (**4**), vom Lehrer: 2 Sekunden Zauberzeit, Abklingzeit 6 Sekunden, geteilt mit Mehrfachschuss. Talente: Schneller Tod, Verbesserter arkaner Schuss, Einsamer Wolf. Aspekt des Geparden (**R**), Rückzug (**Z**), Eiskältefalle (**V**).
- 30: Streuschuss (**E**, ein Talent): Der Gegner ist 4 Sekunden lang verwirrt, und jeder Schaden bricht es; Abklingzeit 30 Sekunden. Totstellen (**X**). Davor: Aura des Volltreffers (**Shift-X**, ein Talent) mit 25: mehr Distanzangriffskraft für deine Gruppe, 30 Minuten lang. Schnellfeuer (**Q**) mit 26.
- 40: Heckenschützenschuss (**Shift-4**, ein Talent; du brauchst zuerst Aura des Volltreffers): Abklingzeit 15 Sekunden, und deine nächsten 3 Schüsse reichen 10 Meter weiter. Salve (Block D). Davor: Aura des Volltreffers Rang 2 beim Lehrer mit 32, Distanzwaffen-Spezialisierung (ein Talent, passiv) mit 35.
- 50: stärkere Ränge: Gezielter Schuss mit 44 und 52, Heckenschützenschuss mit 48, Aura des Volltreffers und Salve mit 50. Nach 40 stecken die Guides deine Punkte in Tierherrschaft.
- 60: wieder stärkere Ränge; nichts Neues für diese Rolle.
**Anfängerfehler:**
- Bewegen während Gezielter Schuss oder Heckenschützenschuss. Sie haben 2 und 4 Sekunden Zauberzeit.
- Mehrfachschuss auf einen Gegner. Dann ist auch Gezielter Schuss 6 Sekunden lang weg.
- Heckenschützenschuss, wenn der Gegner schon bei dir ist. Er hat 4 Sekunden Zauberzeit und wirkt nicht innerhalb von 8 Metern.]] },
			{ band = 3, title = "Überleben: Schaden aus der Nähe, mit Fallen", body = [[
Ab Stufe 1 (Raptorstoß), aber das echte Überleben-Spiel beginnt um 30. In Forever ist das der Nahkampf-Jäger: Raptorstoß, Mungobiss, Gegenangriff und Streichertritt, dazu Fallen. Du behältst deinen Begleiter und deine Fernkampfwaffe: Eröffne aus der Ferne, dann geh nah heran. Die Guides nennen es den langsamsten der drei Bäume zum Leveln; bis etwa 30 spielst du wie jeder Jäger (Begleiter hinein, schießen). Es kostet viel Mana, und ein großer Treffer von dir kann den Gegner von deinem Begleiter wegziehen. Die Guides sind sich uneinig, welche Nahkampfwaffe am besten ist.
**Einfache Reihenfolge:**
Bevor du anfängst: Aspekt des Falken (**Shift-R**), während du schießt. Ab 30 Aspekt des Wildtiers für den Kampf aus der Nähe; er hat keine feste Taste, also leg ihn auf deine eigene Leiste.
1. Mal des Jägers (**Shift-Z**). Ohne das Mal wirkt Beute aufspüren nicht.
2. Begleiter hinein (**Ctrl-1**).
3. Schlangenbiss (**2**), dann Arkaner Schuss (**3**), während der Gegner kommt oder während du zu ihm gehst.
4. Eine Falle zu deinen Füßen: Feuerbrandfalle (**Shift-2**, ab 16). Ab 34 ist diese Taste Sprengfalle, und Feuerbrandfalle hat keine Taste: Leg sie auf deine eigene Leiste, wenn du sie willst.
5. Aus der Nähe: Mungobiss (**Shift-C**, ab 16), sobald er aufleuchtet. Raptorstoß (**5**) jedes Mal, wenn er bereit ist. Streichertritt (ab 30) jedes Mal, wenn er bereit ist; leg ihn auf deine eigene Leiste. Die Guides sind sich uneinig: Manche gehen nach Streichertritt zurück, um zu schießen, andere bleiben nah.
6. Gegenangriff (**Shift-V**) direkt nach einer Parade.
7. Der Gegner läuft weg, oder du willst wieder Abstand: Zurechtstutzen (**Shift-F**).
8. In Not: Abschreckung (**C**, ab 20), Totstellen (**X**, ab 30).
**Alle 10 Stufen:**
- 10: dein Begleiter, aus den Klassenquests. Raptorstoß (**5**) hast du ab Stufe 1. Erste Talente: Verbessertes Fährtenlesen, Abwehr; ab 15: Wilde Schläge, Überlebenskünstler, Einfangen, Verbessertes Zurechtstutzen. Die Talentstufen hier sind die frühesten; ein Perk kann sie bis zu 5 Stufen früher bringen. Danach Zurechtstutzen (**Shift-F**) mit 12, Mungobiss (**Shift-C**) und Feuerbrandfalle (**Shift-2**) mit 16.
- 20: Abschreckung (**C**, ein Talent): 10 Sekunden lang 25% mehr Ausweichen und Parieren; Abklingzeit 5 Minuten. Eiskältefalle (**V**), Gezielter Schuss (**4**), Beidhändigkeit (passiv, Lehrer). Rückzug (**Z**): kein Sprung; er senkt deine **Bedrohung** (wie sehr ein Gegner dich angreifen will) aus der Nähe und stoppt deinen automatischen Angriff. Talente: Sicherer Stand, Falleneffizienz.
- 30: Streichertritt (ein Talent; keine feste Taste, leg ihn auf deine eigene Leiste): 100% Waffenschaden, dann läufst du 3 Sekunden lang 30% schneller; Abklingzeit 8 Sekunden. Aspekt des Wildtiers (Lehrer; leg ihn auf deine eigene Leiste): mehr Nahkampfangriffskraft. Totstellen (**X**). Davor: Gegenangriff (**Shift-V**, ein Talent), ab 25 oder 30 (die Quellen sind sich uneinig): Er wird aktiv, nachdem du parierst, und hält den Gegner 5 Sekunden lang an seinem Platz fest. Vorteil des Raubtiers (ein Talent, passiv) ab 25. Auch in dieser Reihe: Beute aufspüren, Einfallsreichtum, Disziplin des Überlebenskünstlers.
- 40: Aufschlitzende Schläge (ein Talent, passiv; du brauchst zuerst Beute aufspüren): Mungobiss lässt den Gegner auch bluten. Davor: Sprengfalle übernimmt **Shift-2** mit 34, Blitzartige Reflexe (ein Talent, passiv) mit 35.
- 50: stärkere Ränge: Gegenangriff mit 42 und 54, Mungobiss mit 44, Sprengfalle mit 44 und 54, Raptorstoß mit 48, Aspekt des Wildtiers mit 50. Die Guides sind sich uneinig, wohin deine Punkte nach 40 gehen.
- 60: wieder stärkere Ränge; nichts Neues für diese Rolle.
**Anfängerfehler:**
- Direkt hineinrennen. Eröffne aus der Ferne (Mal, Begleiter, Schlangenbiss, ein Schuss), dann geh nah heran.
- Mungobiss oder Gegenangriff drücken, wenn sie nicht aufleuchten. Mungobiss wirkt nur nach einem Ausweichen (oder durch Beute aufspüren), Gegenangriff nur nach einer Parade.
- Nach Stufe 30 aus der Nähe in Aspekt des Falken bleiben. Der Falke hilft nur deinen Schüssen; das Wildtier gibt Nahkampfangriffskraft.]] },
		},
		SHAMAN = {
			{ band = 1, title = "Elementar: Schaden aus der Ferne", body = [[
Ab Stufe 1: Blitzschlag hast du von Anfang an. Blitz und Feuer aus der Ferne. Flammenschock kommt mit 10, Kettenblitzschlag mit 32. Blitzbeherrschung ist ein Talent, frühestens 40. Die Guides leveln als Verstärkung: Elementar klappt, aber seine Manakosten sind sehr hoch, du musst zum Zaubern stillstehen, und viele Gegner auf einmal sind schwer.
**Einfache Reihenfolge:**
Bevor du anfängst: Blitzschlagschild (**Shift-Z**, ab 8) an. Totem der Verbrennung (**5**, ab 10) vor dem Pull aufstellen.
1. Eröffne aus der Ferne mit Blitzschlag (**1**).
2. Flammenschock (**2**, ab 10) auf einen Gegner, der lange lebt.
3. Blitzschlag (**1**) als Füller.
4. Drei oder mehr Gegner: Feuernova (**Shift-4**, ab 12) und Kettenblitzschlag (**Shift-1**, ab 32), wenn sie bereit sind.
5. Blitzbeherrschung (**Q**, ab 40) für einen Elitegegner oder eine große Gruppe.
6. Heb dir Erdschock (**E**) auf, bis der Gegner zaubert: Er unterbricht den Zauber.
Wenig Gesundheit: Welle der Heilung (**C**). Gegner zu nah: Totem der Erdbindung (**V**) oder Frostschock (**4**, ab 20).
**Alle 10 Stufen:**
- 10: Blitzschlag (**1**), Erdschock (**E**, ab 4), Blitzschlagschild (**Shift-Z**, ab 8). Flammenschock (**2**), Totem der Verbrennung (**5**, aus einer Quest). Erste Talente: Konvektion, Erschütterung (passiv). Die Talentstufen hier sind die frühesten; ein Perk kann sie bis zu 5 Stufen früher bringen. Danach Feuernova (**Shift-4**) und Reinigen (**Shift-Q**) mit 12, Totem des Erdstoßes (**Shift-F**) mit 18.
- 20: Frostschock (**4**), Geisterwolf (**R**), Ruf der Elemente (**Ctrl-1**). Elementarfokus (ein Talent, passiv). Danach Totemischer Ruf (**Shift-R**) mit 22. Erdgebunden (ein Talent) mit 25: Totem der Erdbindung (**V**) hält Gegner 5 Sekunden lang an ihrem Platz fest, nur in dem Moment, in dem du es aufstellst. Totem der glühenden Magma (Block D) mit 26.
- 30: Ruf des Donners (ein Talent, passiv). Totem der Erdung (**X**), Ruf der Urahnen (**Ctrl-2**), Reinkarnation (passiv). Blitzschlag-Überladung (ein Talent, passiv). Danach Kettenblitzschlag (**Shift-1**) mit 32, Elementarfuror (ein Talent, passiv) mit 35.
- 40: Blitzbeherrschung (**Q**, ein Talent): 15 Sekunden lang wird Blitzschlag 0,5 Sekunden schneller gewirkt, und Kettenblitzschlag hat keine Abklingzeit; Abklingzeit 3 Minuten. Ruf der Geister (**Ctrl-3**), Kettenheilung (**Shift-2**). Panzer beim Lehrer.
- 50: stärkere Ränge von Blitzschlag, Kettenblitzschlag, Erdschock, Flammenschock, Feuernova und Totem der Verbrennung; nichts Neues für diese Rolle.
- 60: wieder stärkere Ränge; nichts Neues für diese Rolle.
**Anfängerfehler:**
- Erdschock für Schaden in einer Gruppe. Er macht viel **Bedrohung** (wie sehr ein Gegner dich angreifen will). Und er teilt seine Abklingzeit mit Flammenschock: Danach hast du keine Unterbrechung.
- Kettenblitzschlag auf einen Gegner. Er kostet viel Mana und hat 6 Sekunden Abklingzeit.
- Jeden Gegner mit einem Zauber erledigen. Mana ist deine Grenze: Schlag einen Gegner, der fast tot ist, mit deiner Waffe.]] },
			{ band = 2, title = "Verstärkung: Schaden aus der Nähe", body = [[
Ab Stufe 1: Du schlägst mit deiner Waffe zu, mit Waffe des Felsbeißers darauf. Die Guides leveln als Verstärkung: Sie nennen es die bequeme Wahl. Nimm eine langsame Zweihandwaffe. Sturmschlag ist ein Talent, frühestens 25; Waffe des Windzorns kommt mit 30 vom Lehrer. Mana ist deine Grenze: Wenn es knapp wird, hör auf zu zaubern und schlag weiter zu. Der Rat eines Guides für den Waffen-Buff: Waffe des Felsbeißers allein, Waffe der Flammenzunge in einer Gruppe, Waffe des Windzorns ab 30. In einer kleinen Gruppe kann Verstärkung mit Waffe des Felsbeißers eine Weile tanken (Waffen der Geister gibt dann mehr Bedrohung), aber es gibt keinen Spott und keine Verteidigungs-Abklingzeit.
**Einfache Reihenfolge:**
Bevor du anfängst: Waffen-Buff an (Block D), Blitzschlagschild (**Shift-Z**), Totem der Verbrennung (**5**) oder deine Totems aufstellen.
1. Pullen mit Blitzschlag (**1**). **Pullen** = einen Gegner aus der Ferne treffen, damit er zu dir kommt.
2. Sturmschlag (**3**, ab 25), sobald er bereit ist.
3. Blitzschlag (**1**) bei 5 Stapeln Waffe des Mahlstroms (ab 35): Dann ist er spontan und kostenlos.
4. Erdschock (**E**). In einer Gruppe abwechselnd mit Flammenschock (**2**).
5. Feuernova (**Shift-4**, ab 12), wenn ein Feuer-Totem steht und du Mana übrig hast; vor allem gegen mehr Gegner.
6. Zorn des Scharfsehers (**Q**, ab 40) für einen Elitegegner oder einen großen Pull.
7. Sonst einfach weiter zuschlagen.
Nach dem Kampf: Welle der Heilung (**C**). Notfall im Kampf: Geringe Welle der Heilung (**F2**, ab 20).
**Alle 10 Stufen:**
- 10: Waffe des Felsbeißers (Block D), Blitzschlag (**1**), Erdschock (**E**, ab 4), Blitzschlagschild (**Shift-Z**, ab 8). Flammenschock (**2**), Totem der Verbrennung (**5**), Totem der Erdstärke (**Shift-X**), Waffe der Flammenzunge (Block D). Erste Talente: Donnernde Stöße und andere (passiv); Geistige Gewandtheit (passiv) ab 15. Die Talentstufen hier sind die frühesten; ein Perk kann sie bis zu 5 Stufen früher bringen. Danach Feuernova (**Shift-4**) mit 12.
- 20: Geisterwolf (**R**), Frostschock (**4**), Geringe Welle der Heilung (**F2**), Ruf der Elemente (**Ctrl-1**). Schamanistischer Fokus (ein Talent, passiv): Schocks und Blitzschlagschild kosten 45% weniger Mana. Danach Sturmschlag (**3**, ein Talent) mit 25. Schlaghagel (ein Talent, passiv) ab 25. Verbesserter Geisterwolf (ein Talent) ab 25: Geisterwolf ist schneller (spontan mit beiden Punkten) und wirkt auch drinnen; die Guides nehmen ihn auf sehr unterschiedlichen Stufen. Totem der glühenden Magma (Block D) mit 26.
- 30: Waffe des Windzorns (Block D). Verbesserter Sturmschlag und Waffen der Geister (Talente). Totem der Erdung (**X**), Ruf der Urahnen (**Ctrl-2**). Danach Totem des Windzorns mit 32 (keine Taste: nutz die Totemleiste), Kettenblitzschlag (**Shift-1**) mit 32, Waffe des Mahlstroms (ein Talent, passiv) mit 35.
- 40: Zorn des Scharfsehers (**Q**, ein Talent): Du schlägst 25 Sekunden lang 30% schneller zu; nur deine Waffentreffer, nicht deine Zauber. Abklingzeit 3 Minuten. Nicht jeder Guide nimmt ihn mit 40: Manche gehen zuerst in Wiederherstellung, für Mana. Ruf der Geister (**Ctrl-3**), Panzer, eine stärkere Waffe des Windzorns. Danach Totem der luftgleichen Anmut mit 42 (keine Taste: nutz die Totemleiste).
- 50: stärkere Ränge von Waffe des Windzorns, Waffe des Felsbeißers, Erdschock, Blitzschlag und Totem der Erdstärke; nichts Neues für diese Rolle.
- 60: wieder stärkere Ränge; nichts Neues für diese Rolle.
**Anfängerfehler:**
- Blitzschlag mit weniger als 5 Stapeln Waffe des Mahlstroms. Er setzt deinen Schlagtimer zurück. Und Waffe des Mahlstroms hilft nur Blitzschlag: nicht Heilungen, nicht Kettenblitzschlag.
- Waffe des Felsbeißers in einer Gruppe, während du den Schaden machst, sobald du Waffen der Geister hast. Mit Felsbeißer machst du 30% mehr Bedrohung, ohne ihn 30% weniger. Nimm Flammenzunge oder Windzorn.
- Einen Spott suchen. Der Schamane hat keinen. Totem der Steinklaue (**F**) bringt Gegner dazu, das Totem anzugreifen, nicht dich.]] },
			{ band = 3, title = "Wiederherstellung: Heiler", body = [[
Ab Stufe 1: Welle der Heilung hast du von Anfang an, und sie ist deine wichtigste Heilung beim Leveln. Die Guides raten davon ab, allein als Wiederherstellung zu leveln (Gegner sterben langsam), aber in einer Gruppe ist es gut. Zwischen Dungeons questest du mit Blitzschlag und Flammenschock. Springflut ist ein Talent, frühestens 40. Ein Schamane kann Gift und Krankheit entfernen, aber keine Flüche und keine Magie.
**Einfache Reihenfolge (in einer Gruppe):**
Bevor du anfängst: Wasserschild (**Shift-Z**, ab 20). Totems aufstellen: Ruf der Elemente (**Ctrl-1**, ab 20) oder Totem des heilenden Flusses (**F4**, ab 20).
1. Springflut (**Shift-F1**, ab 40) auf den Tank oder auf den, der Schaden nimmt.
2. Kettenheilung (**Shift-2**, ab 40) auf dasselbe Ziel, wenn mehr Leute verletzt sind.
3. Welle der Heilung (**C**) für eine Person oder den Tank.
4. Geringe Welle der Heilung (**F2**, ab 20), wenn es schnell gehen muss.
5. Notfall: Schnelligkeit der Natur (**Shift-3**, ab 30), dann Welle der Heilung (**C**).
6. Totem der Manaflut (**F1**, ab 25), wenn dein Mana ausgeht.
7. Niemand verletzt: Blitzschlag (**1**).
**Alle 10 Stufen:**
- 10: Welle der Heilung (**C**). Erste Talente: Verbesserte Welle der Heilung (eine schnellere Welle der Heilung), Gezeitenfokus (passiv). Die Talentstufen hier sind die frühesten; ein Perk kann sie bis zu 5 Stufen früher bringen. Danach Geist der Ahnen (**F3**, außerhalb eines Kampfes) mit 12, Vergiftung heilen (**Shift-C**) mit 16, Totem des Erdstoßes (**Shift-F**) mit 18.
- 20: Geringe Welle der Heilung (**F2**), Totem des heilenden Flusses (**F4**, aus einer Quest), Ruf der Elemente (**Ctrl-1**), Geisterwolf (**R**). Wasserschild (**Shift-Z**, ein Talent): 3 Wasserkugeln; wenn du getroffen wirst oder einer deiner Zauber kritisch trifft, bekommst du pro Kugel 2% deines Manas zurück. Er hält 10 Minuten. Ab dann wirkt Shift-Z Wasserschild, nicht Blitzschlagschild. Danach Krankheit heilen (**Shift-V**) mit 22. Totem der Manaflut (**F1**, ein Talent) mit 25: gibt deiner Gruppe Mana zurück; Abklingzeit 5 Minuten. Totem der Manaquelle mit 26 (keine Taste: nutz die Totemleiste).
- 30: Schnelligkeit der Natur (**Shift-3**, ein Talent): Dein nächster Naturzauber mit einer Zauberzeit unter 10 Sekunden ist spontan; Abklingzeit 3 Minuten. Pfad der Heilung (ein Talent, passiv). Totem der Erdung (**X**), Ruf der Urahnen (**Ctrl-2**), Reinkarnation (passiv). Danach Läuterung (ein Talent, passiv) mit 35, ein stärkeres Totem der Manaflut mit 38.
- 40: Kettenheilung (**Shift-2**). Springflut (**Shift-F1**, ein Talent; du brauchst zuerst Pfad der Heilung): eine Heilung über 15 Sekunden, keine sofortige Heilung, und eine Kettenheilung, die du direkt auf dieses Ziel wirkst, heilt 25% mehr; Abklingzeit 12 Sekunden. Ruf der Geister (**Ctrl-3**), Panzer.
- 50: stärkere Ränge von Springflut, Kettenheilung, Welle der Heilung, Geringe Welle der Heilung, Totem der Manaflut und Totem des heilenden Flusses; nichts Neues für diese Rolle.
- 60: wieder stärkere Ränge; nichts Neues für diese Rolle.
**Anfängerfehler:**
- Kettenheilung auf jemand anderen als dein Springflut-Ziel. Der Bonus zählt nur, wenn du sie direkt auf dieses Ziel wirkst.
- Nur Schnelligkeit der Natur drücken. Sie heilt selbst nichts: Sie macht deinen nächsten Naturzauber spontan. Drück direkt danach Welle der Heilung.
- Versuchen, einen Fluch zu entfernen. Ein Schamane kann das nicht; nur Gift (**Shift-C**) und Krankheit (**Shift-V**).]] },
		},
		WARLOCK = {
			{ band = 1, title = "Gebrechen: Schaden über Zeit", body = [[
Ab Stufe 4 (Verderbnis) und 8 (Omen der Pein). Du legst DoTs auf den Gegner und lässt deinen Dämon ihn halten. Die meisten Guides leveln als Gebrechen. Lebensentzug ist ein Talent, frühestens 30. Zermürben ist ein Talent, frühestens 40: Während du es kanalisierst, ticken dein Lebensentzug, deine Verderbnis und dein Omen der Pein auf diesem Gegner 100% schneller. Zermürben heilt dich nicht.
**Einfache Reihenfolge:**
1. Schick deinen Dämon hinein (**Ctrl-1**).
2. Omen der Pein (**5**) zum Pullen. Sein Schaden beginnt niedrig, also bekommt dein Dämon den Gegner.
3. Verderbnis (**2**). Mit Verbesserte Verderbnis 5/5 ist sie spontan (frühestens 14).
4. Lebensentzug (**F4**, ab 30), nur auf einen Gegner, der lange lebt.
5. Feuerbrand (**3**) nur auf einen zähen Gegner.
6. Zäher Gegner: Leg deinen Fluch dazu (**Shift-V**). Die Guides sind sich uneinig, wie früh.
7. Füller: bis etwa Stufe 30 dein Zauberstab (Schießen; nicht auf dem Block, leg es auf deine eigene Leiste), dann Blutsauger (**C**). Die Guides sind sich etwas uneinig, wann du wechselst.
8. Schattentrance leuchtet auf (Einbruch der Nacht, ab 25)? Schattenblitz (**1**): Er ist dann spontan.
9. Ab 40: Zermürben (Block D) statt Blutsauger, wenn deine Gesundheit in Ordnung ist. Leg zuerst deine DoTs an.
10. Mehr Gesundheit als Mana? Aderlass (**F**).
11. Brauchst du einen Seelensplitter? Erledige den Gegner mit Seelendieb (**4**).
Zwei Gegner: DoTs auf den ersten, Furcht (**V**) auf ihn, dann bekämpf den zweiten. Schaden kann Furcht brechen, und die Guides sind sich uneinig über DoTs vor Furcht.
**Alle 10 Stufen:**
- 10: Seelendieb (**4**), Gesundheitsstein herstellen (Block D), der Leerwandler (Quest). Du hast schon Schattenblitz (**1**), Feuerbrand (**3**), Verderbnis (**2**, 4), Fluch der Schwäche (**Shift-V**, 4), Aderlass (**F**, 6), Omen der Pein (**5**, 8) und Furcht (**V**, 8). Erstes Talent: Verbesserte Verderbnis oder Unterdrückung (die Guides sind sich uneinig). Die Talentstufen hier sind die frühesten; ein Perk kann sie bis zu 5 Stufen früher bringen. Danach Lebenslinie (**F2**) mit 12; Blutsauger (**C**) und Verderbnis Rang 2 (15 Sekunden) mit 14; Verbessertes Entziehen und Seelenernte (Talente, passiv) ab 15; Sengender Schmerz (Block D) und Seelenstein herstellen mit 18.
- 20: Fluch verstärken (**Shift-3**, ein Talent): Dein nächster Fluch der Schwäche oder dein nächstes Omen der Pein ist 50% stärker; Abklingzeit 3 Minuten. Fluch der Elemente (**Shift-V**), Dämonenrüstung (**Shift-Z**), Feuerregen (**Shift-1**), der Sukkubus oder Inkubus (Quest). Danach Verderbnis Rang 3 (18 Sekunden) und Mana entziehen mit 24. Fluch der Erschöpfung (**R**, ein Talent; du brauchst zuerst Fluch verstärken) mit 25: Der Gegner ist 12 Sekunden lang 30% langsamer. Einbruch der Nacht (ein Talent, passiv) mit 25: eine kleine Chance, dass dein nächster Schattenblitz spontan ist. Verbannen (**Shift-Q**) mit 28.
- 30: Lebensentzug (**F4**, ein Talent): überträgt 30 Sekunden lang Gesundheit vom Gegner auf dich. Seelenentzug (ein Talent, passiv): Blutsauger, Seelendieb und Zermürben machen mehr für jeden deiner Effekte Verderbnis, Lebensentzug und Omen der Pein auf dem Gegner. Blutsauger Rang 3, Höllenfeuer (**Shift-2**), der Teufelsjäger (Quest). Danach Schattenzauberschutz (**Z**) mit 32, Schattenbeherrschung (ein Talent, passiv) mit 35, Lebensentzug Rang 2 und Blutsauger Rang 4 mit 38.
- 40: Zermürben (Block D, ein Talent; du brauchst zuerst Lebensentzug): ein kanalisierter Zauber von 6 Sekunden, der jede Sekunde Schaden macht und deine DoTs auf diesem Gegner 100% schneller ticken lässt. Schreckensgeheul (**Shift-F**), das Teufelsross (Quest). Danach Todesmantel (**X**) mit 42, Seelenfeuer (**Q**) und Lebensentzug Rang 3 mit 48.
- 50: Inferno (**F3**). Fluch der Elemente Rang 4. Sonst stärkere Ränge.
- 60: Omen der Verdammnis (**F1**): ein großer Treffer nach 60 Sekunden; nicht auf Spieler. Sonst stärkere Ränge.
**Anfängerfehler:**
- Omen der Pein zu früh neu anlegen. Seine stärksten Ticks kommen am Ende.
- Zermürben nutzen, wenn du Gesundheit brauchst. Zermürben heilt nicht; Blutsauger schon.
- Fluch der Tollkühnheit auf den Gegner, den du in Furcht versetzen willst. Dieser Gegner ignoriert Furcht.]] },
			{ band = 2, title = "Dämonologie: Schaden mit deinem Dämon", body = [[
Ab Stufe 1 (der Wichtel), richtig ab 10 (der Leerwandler). Dein Dämon macht viel von der Arbeit, und die Talente machen ihn stärker. Die Guides sind sich uneinig, wann du in diesen Baum gehst: Manche gehen ab 10 hinein, andere leveln zuerst als Gebrechen und wechseln um 26 oder 27. Dämonische Opferung (frühestens 20) lohnt sich erst mit Dämonischer Pakt (frühestens 40). Davor entfernt jeder Dämon, den du beschwörst, den Buff.
**Einfache Reihenfolge:**
1. Schick deinen Dämon hinein (**Ctrl-1**) und lass ihn zuerst zuschlagen.
2. Ab 30: Seelenverbindung (**Shift-X**) an, und wieder nach jeder Beschwörung.
3. Ab 25 (Dämonisches Brandmal): Sengender Schmerz (Block D) auf den Gegner deines Dämons. Wieder, wenn das Brandmal weg ist (10 Sekunden). Vor Dämonisches Brandmal: kein Sengender Schmerz.
4. Omen der Pein (**5**) und Verderbnis (**2**) auf Gegner, die lange genug leben. Verderbnis hat hier 2 Sekunden Zauberzeit.
5. Füller: dein Zauberstab (nicht auf dem Block, leg ihn auf deine eigene Leiste) oder Schattenblitz (**1**). Blutsauger (**C**), wenn du Gesundheit brauchst.
6. Dämon fast tot: Lebenslinie (**F2**). Sie kostet deine eigene Gesundheit.
7. Aderlass (**F**). Mit Dämonische Energien bekommt auch dein Dämon Mana.
8. Ab 40 (Dämonischer Pakt): Dämonische Opferung (**Shift-C**) auf einen Dämon, dann beschwör einen anderen (Block D). Der Buff hält 2 Stunden. Die Guides sind sich uneinig, welchen Dämon du opferst.
9. Ab 48, mit Dezimierung: Gegner unter 35% Gesundheit? Schattenblitz oder Sengender Schmerz, dann Seelenfeuer (**Q**): schneller und ohne Seelensplitter.
**Alle 10 Stufen:**
- 10: der Leerwandler (Quest; kostet 1 Seelensplitter). Seine Qual gibt **Bedrohung** (wie sehr ein Gegner ihn angreifen will). Seelendieb (**4**) für Splitter. Erste Talente: Unheilige Macht, Dämonische Umarmung, Verbesserter Wichtel, Verbesserte Lebenslinie (passiv). Die Talentstufen hier sind die frühesten; ein Perk kann sie bis zu 5 Stufen früher bringen. Danach Lebenslinie (**F2**) mit 12; Dämonische Energien, Teuflische Vitalität und Verbesserter Leerwandler (Talente, passiv) ab 15; Opferung (Leerwandler) mit 16; Schatten verzehren (Leerwandler) und Sengender Schmerz (Block D) mit 18.
- 20: Dämonische Opferung (**Shift-C**, ein Talent): Du opferst deinen Dämon für einen Buff von 2 Stunden. Wichtel: 15% mehr Schattenschaden. Sukkubus oder Inkubus: 15% mehr Feuerschaden. Leerwandler: Mana zurück. Teufelsjäger: Gesundheit zurück. Meister der Beschwörung (ein Talent, passiv): Beschwörungen sind schneller und billiger. Der Sukkubus oder Inkubus (Quest). Dämonenrüstung (**Shift-Z**). Danach Leiden (Leerwandler) mit 24. Teufelsbeherrschung (**Shift-F1**, ein Talent; du brauchst zuerst Meister der Beschwörung) mit 25: Deine nächste Beschwörung ist 5,5 Sekunden schneller und 50% billiger. Dämonisches Brandmal und Dezimierung (Talente, passiv) ab 25.
- 30: Seelenverbindung (**Shift-X**, ein Talent; du brauchst zuerst Dämonische Opferung): 30% des Schadens auf dich geht auf deinen Dämon, und ihr beide macht 3% mehr Schaden. Sie hält, solange dein Dämon da ist. Der Teufelsjäger (Quest; Zaubersperre mit 36). Dämonisches Wissen (ein Talent, passiv). Danach Meister der Dämonologie (ein Talent, passiv) ab 35.
- 40: Dämonischer Pakt (ein Talent, passiv; du brauchst zuerst Seelenverbindung): Der Buff von Dämonische Opferung bleibt, wenn du einen anderen Dämon beschwörst. Erst jetzt lohnt sich Dämonische Opferung. Schreckensgeheul (**Shift-F**), das Teufelsross (Quest). Danach Todesmantel (**X**) mit 42, Seelenfeuer (**Q**) mit 48.
- 50: Inferno (**F3**): eine Höllenbestie; jedes Mal 1 Höllenstein; Abklingzeit 1 Stunde. Sonst stärkere Ränge.
- 60: Omen der Verdammnis (**F1**). Sonst stärkere Ränge.
**Anfängerfehler:**
- Sengender Schmerz, bevor du Dämonisches Brandmal hast. Er macht viel Bedrohung und zieht den Gegner von deinem Dämon weg.
- Dämonische Opferung vor Dämonischer Pakt (40). Dein Dämon ist weg, und jeder Dämon, den du beschwörst, entfernt den Buff.
- Nach Dämonischer Pakt denselben Dämon beschwören, den du geopfert hast. Dann ist der Buff weg.]] },
			{ band = 3, title = "Zerstörung: Schaden mit großen Treffern", body = [[
Ab Stufe 1 (Schattenblitz und Feuerbrand). Große Feuer- und Schattentreffer, und es kostet am meisten Mana. Manche Guides raten davon ab, damit zu leveln (viel Mana, wenig Wege, es zurückzubekommen); andere nennen es spielbar, und einer nennt es stark in Dungeons. Feuersbrunst ist ein Talent, frühestens 25; Verbrennen ist ein Talent, frühestens 40. Der Wendepunkt ist Schatten und Flamme 5/5 (frühestens 39): Ab dann frisst Feuersbrunst deinen Feuerbrand nicht mehr, und Schattenbrand gibt seinen Seelensplitter immer zurück.
**Einfache Reihenfolge:**
1. Schick deinen Dämon hinein (**Ctrl-1**).
2. Feuerbrand (**3**). Ein Guide eröffnet mit Schattenblitz aus der Ferne, mit Feuerbrand direkt danach.
3. Zäher Gegner: Omen der Pein (**5**) und dein Fluch (**Shift-V**).
4. Ab 25: Feuersbrunst (Block D). Vor Schatten und Flamme 5/5 frisst sie deinen Feuerbrand: Nutz sie am Ende von Feuerbrand oder als letzten Treffer. Danach: jedes Mal, wenn sie bereit ist.
5. Füller: Schattenblitz (**1**). Ab 40 Verbrennen (Block D), mit Feuerbrand auf dem Gegner.
6. Ab 20: Schattenbrand (**Shift-4**) als letzter Treffer. Dann bekommst du den Seelensplitter zurück.
7. Aderlass (**F**) zwischen Kämpfen. Wenig Mana: dein Zauberstab (nicht auf dem Block, leg ihn auf deine eigene Leiste).
8. Mehr Gegner: ab 30 Omen der Verwüstung (Block D) auf einen zähen Gegner, dann greif den Rest an. Feuerregen (**Shift-1**). Höllenfeuer (**Shift-2**, ab 30) nur mit genug Gesundheit.
**Alle 10 Stufen:**
- 10: Schattenblitz (**1**) und Feuerbrand (**3**; Rang 2 mit 10). Erstes Talent: Dunkle Macht (schnellere Zauber) oder Verbesserter Schattenblitz. Die Talentstufen hier sind die frühesten; ein Perk kann sie bis zu 5 Stufen früher bringen. Danach Schattenblitz Rang 3 mit 12 (2,8 Sekunden Zauberzeit); Nachwirkung und Katastrophe (Talente, passiv) ab 15; Sengender Schmerz (Block D) mit 18.
- 20: Schattenbrand (**Shift-4**, ein Talent): ein spontaner Schattentreffer; kostet 1 Seelensplitter; Abklingzeit 15 Sekunden. Stirbt der Gegner (einer, der EP gibt) innerhalb von 8 Sekunden, bekommst du einen Splitter zurück. Verderben (ein Talent, passiv): Deine kritischen Zerstörungstreffer treffen härter. Feuerregen (**Shift-1**). Schattenblitz Rang 4 (3 Sekunden Zauberzeit). Danach Schattenbrand Rang 2 mit 24. Feuersbrunst (Block D, ein Talent) mit 25: ein spontaner Feuertreffer auf einen Gegner mit deinem Feuerbrand; dieser Feuerbrand ist dann weg; Abklingzeit 10 Sekunden. Peinigende Flammen und Intensität (Talente, passiv) ab 25.
- 30: Omen der Verwüstung (Block D, ein Talent): 5 Minuten auf einem Gegner; 15% deines ganzen Schadens auf andere Gegner trifft auch diesen. Nur ein Gegner gleichzeitig. Feuer und Schwefel (du brauchst zuerst Feuersbrunst) und Feuerschwall (du brauchst zuerst Intensität), Talente, passiv. Höllenfeuer (**Shift-2**). Danach Feuersbrunst Rang 2 und Schattenbrand Rang 3 mit 32; Schatten und Flamme (ein Talent, passiv) ab 35, 5/5 frühestens mit 39.
- 40: Verbrennen (Block D, ein Talent; du brauchst zuerst Omen der Verwüstung): 2,5 Sekunden Zauberzeit, 25% mehr Schaden, wenn der Gegner deinen Feuerbrand hat. Feuersbrunst Rang 3, Schattenbrand Rang 4. Danach Seelenfeuer (**Q**) mit 48.
- 50: Verbrennen Rang 2. Inferno (**F3**).
- 60: Verbrennen Rang 3, Feuersbrunst Rang 6. Omen der Verdammnis (**F1**).
**Anfängerfehler:**
- Feuersbrunst direkt nach Feuerbrand. Sie frisst deinen Feuerbrand (bis Schatten und Flamme 5/5).
- Schattenbrand ohne Seelensplitter, oder auf einen Gegner, der lange lebt. Der Splitter kommt nur zurück, wenn der Gegner innerhalb von 8 Sekunden stirbt.
- Omen der Verwüstung und Omen der Pein auf demselben Gegner. Nur ein Omen passt darauf.]] },
			-- derived, not measured as a standalone name: Höllenbestie (from SpellName 437833 "Höllenbestie beschwören"),
			-- Teufelsross (from 5784 "Teufelsross beschwören").
		},
		PALADIN = {
			{ band = 1, title = "Heilig: Heiler", body = [[
Ab Stufe 1: Heiliges Licht hast du von Anfang an. Ein **Heiler** hält die Gruppe am Leben. Die Guides nennen Heilig den langsamsten Baum, um allein zu leveln: Level als Vergeltung und heile in Dungeons, oder spiel Heilig mit einem Freund. Die eigenen Tasten des Baums kommen mit 20 (Göttliche Gunst), 25 (Eid des Lichts), 30 (Heiliger Schock) und 40 (Lichtwacht).
**Einfache Reihenfolge (in einer Gruppe):**
Vor dem Pull: Segen der Weisheit (**Shift-V**, ab 14) auf dich, Segen der Könige (**Shift-X**, ab 20) auf die anderen. Aura: Aura der Hingabe (**Ctrl-1**), oder Aura der Konzentration (**Ctrl-3**, ab 22), wenn Zauberwirker oft getroffen werden.
1. Eid des Lichts (**Shift-R**, ab 25) auf den Tank. Er hält 1 Stunde, und nur ein Spieler kann ihn haben.
2. Lichtblitz (**F2**, ab 20) ist deine normale Heilung. Vor 20: Heiliges Licht (**C**).
3. Heiliges Licht (**C**) für einen großen Treffer. Ab 25 (Lichtinfusion) wird es schneller gewirkt, direkt nach einem kritischen Treffer von Heiliger Schock oder Lichtblitz. **Kritischer Treffer** = ein glücklicher, stärkerer Treffer oder eine stärkere Heilung.
4. Heiliger Schock (**F4**, ab 30), wenn keine Zeit zum Zaubern ist, oder während du dich bewegst.
5. Die ganze Gruppe verletzt, ab 40: Lichtwacht (**Shift-F1**) auf einen Spieler, dann Heiliger Schock (**F4**) auf denselben Spieler.
6. Göttliche Gunst (**Shift-3**, ab 20) vor einer Heilung, die groß sein muss.
7. Ein schlechter Effekt auf einem Freund: Läutern, später Reinigung des Glaubens (**Shift-C**).
8. Notfall: Handauflegung (**Q**). Sie verbraucht dein ganzes restliches Mana.
Nichts zu heilen: dein Siegel (**3**), Richturteil (**2**) und Heiliger Stoß (**1**) aus der Nähe. Allein: Spiel wie ein Vergeltungspaladin; ab 30 ist Heiliger Schock (**F4**) auf den Gegner deine eine starke Schadenstaste.
**Alle 10 Stufen:**
- 10: Du hast schon Heiliges Licht (**C**), Aura der Hingabe (**Ctrl-1**), Segen der Macht (**Shift-Z**), Göttlicher Schutz (**Z**), Hammer der Gerechtigkeit (**E**) und Läutern (**Shift-C**). Neu mit 10: Handauflegung (**Q**), Segen des Schutzes (**Shift-F**). Erstes Talent: Spiritueller Fokus (passiv). Die Talentstufen hier sind die frühesten; ein Perk kann sie bis zu 5 Stufen früher bringen. Danach Erlösung (**F3**, aus einer Quest) mit 12, Segen der Weisheit (**Shift-V**) mit 14, Andacht und Heilendes Licht (Talente, passiv) ab 15, Segen der Freiheit (**R**) mit 18.
- 20: Lichtblitz (**F2**), Segen der Könige (**Shift-X**). Göttliche Gunst (**Shift-3**, ein Talent): Dein nächster Lichtblitz, dein nächstes Heiliges Licht oder dein nächster Heiliger Schock ist sicher kritisch; Abklingzeit 2 Minuten. Illumination (ein Talent, passiv; du brauchst zuerst Andacht). Danach Aura der Konzentration (**Ctrl-3**) mit 22. Eid des Lichts (**Shift-R**, ein Talent) und Lichtinfusion (ein Talent, passiv) mit 25.
- 30: Heiliger Schock (**F4**, ein Talent): spontan, Schaden an einem Gegner oder eine Heilung auf einen Freund; Abklingzeit 10 Sekunden. Göttliches Eingreifen (**F3** im Kampf: Du stirbst dabei selbst). Siegel des Lichts (Block D). Danach Gottesschild (**Z**) mit 34, Heilige Kraft (ein Talent, passiv) mit 35, Siegel der Weisheit (Block D) mit 38.
- 40: Lichtwacht (**Shift-F1**, ein Talent; du brauchst zuerst Heiliger Schock): 30 Sekunden auf einem Freund; dein nächster Heiliger Schock auf diesen Freund hat keine Abklingzeit und heilt auch seine Gruppe. Heiliger Schock Rang 2. Plattenpanzer: Du kannst Platte tragen. Danach Reinigung des Glaubens (**Shift-C**) mit 42, Segen der Opferung (Block D) mit 46, Heiliger Schock Rang 3 mit 48.
- 50: Lichtwacht Rang 2, Handauflegung Rang 3. Danach Großer Segen der Macht mit 52 und Großer Segen der Weisheit mit 54, Heiliger Schock Rang 4 mit 56.
- 60: Großer Segen der Könige, Lichtwacht Rang 3; nichts Neues für diese Rolle.
**Anfängerfehler:**
- Heiliges Licht für jeden kleinen Treffer. Lichtblitz (**F2**, ab 20) ist die billige normale Heilung.
- Lichtwacht auf einen Spieler und Heiliger Schock auf einen anderen. Die Gruppenheilung kommt nur von Heiliger Schock auf DENSELBEN Spieler.
- Im Kampf aus Versehen F3 drücken. Dann wirkt es Göttliches Eingreifen, und du stirbst selbst. Außerhalb eines Kampfes ist F3 Erlösung.]] },
			{ band = 2, title = "Schutz: Tank", body = [[
Ab Stufe 10 (Zorn der Gerechtigkeit und Siegel des Furors beim Lehrer). Ein **Tank** ist der, den die Gegner schlagen, damit der Rest der Gruppe sicher bleibt. **Bedrohung** = wie sehr ein Gegner dich angreifen will. Du trägst eine Einhandwaffe und einen Schild. Die Guides sind sich uneinig, wie gut Schutz allein levelt. Die Tasten des Baums: Bollwerk des Templers mit 20, Schnelles Richturteil mit 25, Heiliger Schild mit 30.
**Einfache Reihenfolge:**
1. Vor dem Pull: Zorn der Gerechtigkeit an (keine feste Taste: Er liegt auf Block D, oder leg ihn auf deine eigene Leiste; er hält 30 Minuten). Siegel des Furors (**F**), ein Segen, eine Aura. Die Guides sind sich uneinig über die Aura: Aura der Hingabe (**Ctrl-1**) oder Aura der Vergeltung (**Ctrl-2**).
2. Ab 30: Heiliger Schild (**Shift-4**), kurz bevor die Gegner dich erreichen. Drück ihn wieder jedes Mal, wenn er bereit ist.
3. Richturteil (**2**) auf den ersten Gegner. Mit Siegel des Furors ist Richturteil dein Spott (3 Sekunden). **Spott** = den Gegner dazu bringen, dich anzugreifen.
4. Zwei oder mehr Gegner, ab 20: Weihe (**Shift-1**) unter ihnen. Nur die ersten 4 nehmen den zusätzlichen Schaden.
5. Heiliger Stoß (**1**) jedes Mal, wenn er bereit ist.
6. Ein Gegner läuft zu jemand anderem: Richturteil (**2**). Nicht bereit? Ab 25: Schnelles Richturteil (**F1**), ein zweites Richturteil mit seiner eigenen Abklingzeit von 1 Minute.
7. Ein Gegner wirkt einen Zauber: Hammer der Gerechtigkeit (**E**). Der Paladin hat keine Unterbrechung.
8. Exorzismus (**5**, ab 20) auf Untote und Dämonen. Hammer des Zorns (**4**, ab 44).
9. Großer Schaden kommt, ab 20: Bollwerk des Templers (**X**). Letzter Ausweg: Handauflegung (**Q**).
Wenig Mana: Lass zuerst Weihe weg. Ab 40 (Schildgeschworen): zuerst Heiliger Schild, dann Heiliger Stoß. Nicht der Tank (allein, oder jemand anderes tankt): Nutz dein Siegel auf **3**, nicht Siegel des Furors.
**Alle 10 Stufen:**
- 10: Zorn der Gerechtigkeit (Block D) und Siegel des Furors (**F**). Du hast schon Richturteil (**2**), Heiliger Stoß (**1**), Hammer der Gerechtigkeit (**E**), Aura der Hingabe (**Ctrl-1**) und Göttlicher Schutz (**Z**). Auch neu: Handauflegung (**Q**), Segen des Schutzes (**Shift-F**). Erstes Talent: Verschanzen (passiv). Die Talentstufen hier sind die frühesten; ein Perk kann sie bis zu 5 Stufen früher bringen. Danach Präzision, Gunst des Hüters oder Heilige Pflicht (Talente, passiv) ab 15, Aura der Vergeltung (**Ctrl-2**) mit 16.
- 20: Bollwerk des Templers (**X**, ein Talent): ein Schild, der 8 Sekunden lang Schaden in Höhe deiner maximalen Gesundheit aufsaugt; Abklingzeit 5 Minuten. Weihe (**Shift-1**), Segen der Könige (**Shift-X**), Exorzismus (**5**). Schild-Spezialisierung (ein Talent, passiv; du brauchst zuerst Verschanzen). Danach Schnelles Richturteil (**F1**, ein Talent; du brauchst zuerst Bollwerk des Templers) und Verbesserter Zorn der Gerechtigkeit (ein Talent, passiv) mit 25.
- 30: Heiliger Schild (**Shift-4**, ein Talent; du brauchst einen Schild): 10 Sekunden lang 30% mehr Blockchance, 4 Aufladungen; Abklingzeit 10 Sekunden. Abrechnung (ein Talent, passiv). Danach Gottesschild (**Z**) mit 34, Eiserner Glaube (ein Talent, passiv) mit 35.
- 40: Schildgeschworen (ein Talent, passiv; du brauchst zuerst Heiliger Schild): Heiliger Stoß alle 6 Sekunden, und er wirkt mit Heiliger Schild. Plattenpanzer: Du kannst Platte tragen. Heiliger Schild Rang 2. Danach Hammer des Zorns (**4**) mit 44, Segen der Opferung (Block D) mit 46.
- 50: Heiliger Schild Rang 3, Heiliger Zorn (Block D); stärkere Ränge von Siegel des Furors und Weihe.
- 60: Heiliger Schild Rang 4 und stärkere Ränge; nichts Neues für diese Rolle.
**Anfängerfehler:**
- Zorn der Gerechtigkeit vergessen. Ohne ihn machst du viel weniger Bedrohung. Prüf ihn vor jedem Pull; er hält 30 Minuten.
- Siegel des Furors an, wenn du nicht der Tank bist. Jedes Richturteil spottet dann.
- Kein Schild. Heiliger Schild wirkt ohne einen nicht, und Siegel des Furors gibt keinen Schutzschild.]] },
			{ band = 3, title = "Vergeltung: Schaden aus der Nähe", body = [[
Ab Stufe 1 (Siegel der Rechtschaffenheit); Richturteil kommt mit 4, Heiliger Stoß mit 6. Die Guides nennen Vergeltung den schnellsten Baum, um allein zu leveln, mit einer langsamen Zweihandwaffe. Die Klassenquest mit 20 gibt dir eine. Die Tasten des Baums: Siegel des Befehls mit 20, Buße mit 30.
**Einfache Reihenfolge:**
1. Vor dem Kampf: Segen der Macht (**Shift-Z**) bis 20, dann Segen der Könige (**Shift-X**).
2. Aura: Aura der Hingabe (**Ctrl-1**); Aura der Vergeltung (**Ctrl-2**, ab 16) gegen mehrere Gegner.
3. Siegel an (**3**): Siegel der Rechtschaffenheit, bis du Siegel des Befehls kennst (ab 20). Dann wirkt Taste 3 Siegel des Befehls.
4. Richturteil (**2**) jedes Mal, wenn es bereit ist. Es verbraucht das Siegel nicht.
5. Heiliger Stoß (**1**) jedes Mal, wenn er bereit ist.
6. Untoter oder Dämon, ab 20: Exorzismus (**5**).
7. Zwei oder mehr Gegner, ab 20: Weihe (**Shift-1**). Nicht auf einen Gegner: Sie kostet zu viel Mana.
8. Ab 44: Hammer des Zorns (**4**), wenn der Gegner 20% Gesundheit oder weniger hat.
9. Starker Gegner: Hammer der Gerechtigkeit (**E**), dann Richturteil (**2**). Mit Siegel des Befehls macht Richturteil doppelten Schaden an einem betäubten Gegner.
10. Ein zweiter Humanoid, ab 30: Buße (**V**), und schlag ihn nicht.
11. Leg das Siegel neu an, wenn es ausläuft (30 Sekunden). Wenig Gesundheit: Heiliges Licht (**C**) zwischen Kämpfen.
**Alle 10 Stufen:**
- 10: Du hast schon Siegel der Rechtschaffenheit (**3**), Richturteil (**2**), Heiliger Stoß (**1**), Segen der Macht (**Shift-Z**) und Hammer der Gerechtigkeit (**E**). Neu mit 10: Handauflegung (**Q**). Erstes Talent: Segnung (die meisten Guides) oder Abwehr (ein Guide), beide passiv. Die Talentstufen hier sind die frühesten; ein Perk kann sie bis zu 5 Stufen früher bringen. Danach Verbessertes Richturteil, Überzeugung oder Gesegnetes Richturteil (Talente, passiv) ab 15, Aura der Vergeltung (**Ctrl-2**) mit 16.
- 20: Siegel des Befehls (**3**, ein Talent): Deine Treffer machen manchmal einen zusätzlichen Heiligtreffer. Ab dann wirkt Taste 3 es statt Siegel der Rechtschaffenheit. Weihe (**Shift-1**), Exorzismus (**5**), Segen der Könige (**Shift-X**), Lichtblitz (**F2**). Streben nach Gerechtigkeit (ein Talent, passiv: Du bewegst dich bei 2/2 15% schneller). Die Klassenquest für eine Zweihandwaffe. Danach Heiliger Richter und Zweihandwaffen-Spezialisierung (Talente, passiv) mit 25.
- 30: Buße (**V**, ein Talent): nimmt einen Humanoiden bis zu 6 Sekunden lang aus dem Kampf; jeder Schaden weckt ihn; Abklingzeit 1 Minute. Rache (ein Talent, passiv; du brauchst zuerst Siegel des Befehls): Nach einem kritischen Treffer machst du 30 Sekunden lang mehr Schaden; es stapelt sich 5-mal. Siegel des Befehls Rang 2. Danach Gottesschild (**Z**) mit 34, Champion des Lichts (ein Talent, passiv) mit 35.
- 40: Entfesselter Zorn (ein Talent, passiv; du brauchst zuerst Buße): Deine Treffer speichern Kopien deines Siegels, und ein Treffer mit einem anderen Siegel verbraucht sie. Plattenpanzer: Du kannst Platte tragen. Die Quest für das Schlachtross. Danach Hammer des Zorns (**4**) mit 44.
- 50: Siegel des Befehls Rang 4, Heiliger Zorn (Block D), Hammer des Zorns Rang 2 mit 52; nichts Neues für diese Rolle.
- 60: Siegel des Befehls Rang 5 und stärkere Ränge; die Quest für das Streitross (Allianz); nichts Neues für diese Rolle.
**Anfängerfehler:**
- Das Siegel nach jedem Richturteil neu anlegen. Richturteil verbraucht es nicht; ein Siegel hält 30 Sekunden.
- Siegel des Befehls mit einer schnellen Waffe. Es will eine langsame Zweihandwaffe.
- Weihe auf einen Gegner. Dafür kostet sie zu viel Mana.]] },
			-- derived, not measured as a standalone name: Schlachtross (from SpellName 13819 "Schlachtross beschwören"),
			-- Streitross (from 23214 "Streitross beschwören").
		},
	},
}
