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
- 16: Wassergestalt auf R, während du schwimmst. 18: Feenfeuer auf 5 (wirkt in jeder Gestalt), Winterschlaf auf Shift-Q.
- 20: Katzengestalt (aus einer Quest) auf Ctrl-2, mit Klaue, Zerfetzen und Schleichen. Sternenfeuer auf 3. Im Kampf wird F3 zu Wiedergeburt.
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
- 12: Erlösung auf F3 (holt einen toten Freund zurück; nicht im Kampf). 14: Segen der Weisheit auf Shift-V.
- 18: Segen der Freiheit auf R (eine Weile kann dich nichts verlangsamen). 20: Weihe auf Shift-1 (trifft mehrere Gegner auf einmal), Exorzismus auf 5, Lichtblitz auf F2 (schnelle Heilung), Segen der Könige auf Shift-X.
- 30: Göttliches Eingreifen: Im Kampf wirkt F3 dieses statt Erlösung. 34: Gottesschild auf Z: 10 Sekunden, in denen dir nichts schaden kann, und du kannst trotzdem kämpfen (mit halbem Schaden).
- 42: Reinigung des Glaubens ersetzt Läutern auf Shift-C. 44: Hammer des Zorns auf 4 (nur wenn der Gegner 20 % Gesundheit oder weniger hat).
- 52-60: In einer Gruppe wirken die Segen-Tasten den Großen Segen für die ganze Gruppe; allein wirken sie den normalen.]] },
		{ "Anfängerfehler", [[
- Exorzismus (5) auf einen normalen Gegner drücken. Er wirkt nur auf Untote und Dämonen. Untote vertreiben (Shift-Q, 24) wirkt nur auf Untote.
- Hammer des Zorns (4) früh im Kampf drücken. Er wirkt nur, wenn der Gegner fast tot ist (20 % Gesundheit oder weniger).
- Gottesschild und Göttlicher Schutz teilen sich eine Abklingzeit, deshalb liegen sie auf einer Taste (Z). Diese Schutzzauber und Segen des Schutzes geben dir **Vorahnung**: 1 Minute lang kannst du keinen davon wieder bekommen. Handauflegung nicht.]] },
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
- **Stufe 10, Begleiter-Quests:** Du lernst Wildtier zähmen, Tier rufen und Tier wiederbeleben. **F4** = Tier rufen (holt deinen Begleiter), **F3** = Tier wiederbeleben (holt einen toten Begleiter zurück). Wildtier zähmen hat keine Taste; du nutzt es außerhalb eines Kampfes.
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
Jedes Priester-Volk hat zwei eigene Priesterzauber: einen auf Stufe 10 und einen auf Stufe 20. MH legt sie auf **X** und **Shift-R**, so nutzt jedes Volk dieselben zwei Tasten.
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
- In Schattengestalt heilen. Kein Heilzauber wirkt in Schattengestalt. Furchtzauberschutz und die Volkszauber von Zwerg und Gnom (Züchtigung, Verwirrender Lichtblitz) wirken darin auch nicht. Verlass sie zuerst: Drück Ctrl-1 noch einmal.
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
}
