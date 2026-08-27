# Vertaal-drift

Gegenereerd door `python tools/check_drift.py --write-report`. **Niet met de hand bijwerken.**

Drift betekent: deze taal heeft een vertaling, maar de Engelse zin waar hij uit komt is daarna veranderd. `ns:L` valt alleen terug op enUS als een key *ontbreekt* — een aanwezige vertaling blijft staan, hoe oud hij ook is. Zo blijft een gecorrigeerde bewering in vijf talen gewoon doorlopen.

Basis: **v3.5.0** — 2996 keys met een vastgelegde herkomst.

| taal | OK | drift | onvertaald | onbekend |
|---|---:|---:|---:|---:|
| deDE | 2938 | 7 | 158 | 6 |
| frFR | 2958 | 7 | 138 | 6 |
| esES | 2958 | 7 | 138 | 6 |
| ptBR | 2959 | 7 | 137 | 6 |
| itIT | 2876 | 7 | 220 | 6 |
| nlNL | 2571 | 7 | 473 | 58 |

**onbekend** = na de basistag vertaald, dus we weten niet uit welke Engelse versie. Dat is niet hetzelfde als verouderd.

De loader ziet **3447** enUS-keys; hiervan zijn er 3109 beoordeeld en 338 overgeslagen (`CHANGELOG_*`, `LANG_LABEL_*` en waarden die precies een spelbegrip zijn). ⚠️ `tools/lint_addon.py` [5] telt hetzelfde anders — die parseert de bestanden zelf en slaat niets over, dus zijn "still English" ligt hoger. Twee getallen die hetzelfde lijken te meten en niet gelijk zijn: gebruik hier het getal van de loader.

⚠️ **Niets hier automatisch vertalen.** Deze lijst gaat naar #translations op Discord; een machinevertaling in een pack is niet te onderscheiden van een gecontroleerde en blokkeert de echte.

## deDE — 7 gedrift

### `CURIO_NO_TEXT`

| | |
|---|---|
| enUS **nu** | (could not read the text for this one - hover it in game once, then run this again) |
| deDE **staat nu** | (Text nicht lesbar - fahre im Spiel einmal darüber und führe das erneut aus) |

### `DELVE_TIP_COLLEGIATE_CALAMITY_OVERVIEW`

| | |
|---|---|
| enUS **nu** | • Northwest Silvermoon / Eversong Woods (Thalassian University).\|n• Academy Under Siege -> Voidscorned Vagrant.\|n• Faculty of Fear -> Infiltrator Garand.\|n• Invasive Glow -> Hydrangea.\|n• An Elementary Antidote -> no final boss; treasure spawns instead of a kill. |
| deDE **staat nu** | • Nordwest-Silbermond / Eversong Woods (Thalassian University).\|n• Akademie unter Belagerung: Leere Portale.\|n• Fakultät der Angst: getarnte Klinge des Zwielichts.\|n• Invasives Leuchten: Lightbloom + Deweeder.\|n• An Elementary Antidote: Zutaten und Gegengift, ohne Endgegner.\|n• Vier Varianten, drei verschiedene Endgegner. |

### `DELVE_TIP_COLLEGIATE_CALAMITY_ROUTE`

| | |
|---|---|
| enUS **nu** | • Under Siege: close void portals and kill Devouring Host.\|n• Faculty of Fear: Eye of Revelation — suspicious students glow yellow through walls.\|n• Invasive Glow: Deweeder kills small Lightbloom and damages large ones.\|n• Clear Luminibulb patches on the main level.\|n• An Elementary Antidote: speak to Sir Finley Mrrgglton, gather 10 Research Tomes, then collect ingredients and cure 7 Envenomed Denizens. Ingredients are worth different amounts, so grab the big ones.\|n• Fungal Pharmacon is a weapon too: it clears the poison pools AND hits everything within 5 yards of where it lands. |
| deDE **staat nu** | • Unter Belagerung: Leerenportale schließen und Devouring Host töten.\|n• Fakultät der Angst: Auge der Offenbarung – verdächtige Schüler leuchten gelb durch Wände.\|n• Invasives Leuchten: Deweeder tötet kleine Lightbloom und beschädigt große.\|n• Löschen du Luminibulb-Patches auf der Hauptebene.\|n• An Elementary Antidote: Sprich mit Sir Finley Mrrgglton, sammle 10 Research Tomes, dann Zutaten sammeln und 7 Envenomed Denizens heilen. Zutaten zählen unterschiedlich viel, nimm also die großen.\|n• Fungal Pharmacon ist auch eine Waffe: er räumt die Poison Pools weg UND trifft alles im Umkreis von 5 Yards um den Einschlag. |

### `TIER_FOOTER`

| | |
|---|---|
| enUS **nu** | The bonus links come from a 12.0.7 datamine and may still be last season's - hover one for the live tooltip, which is always right. Where the pieces come from was read from your own client. |
| deDE **staat nu** | Die Bonus-Links stammen aus einem 12.0.7-Datamine und könnten noch von letzter Saison sein - fahre über einen für den Live-Tooltip, der stimmt immer. Woher die Teile kommen, wurde aus deinem eigenen Client gelesen. |

### `TIER_GUIDE_BODY`

| | |
|---|---|
| enUS **nu** | \|cffe8c36aWhat a tier set is\|r\|n• Five slots — head, shoulders, chest, hands, legs — carry a set bonus. Two pieces give you a small one, four give you the big one. The 4-set is usually worth more than a few item levels, so four is the goal.\|n• You only need 4 of the 5. Leave out the slot where your ordinary item is strongest, because that is the one you would be giving up.\|n• Wrist, belt, boots, neck, rings, cloak and weapons are never part of a set. There, just wear the best item you have.\|n\|n\|cffe8c36aWhere it comes from this season\|r\|n• The Season 2 raid is \|cffffffffThe Venomous Abyss\|r, at Raid Finder, Normal, Heroic and Mythic.\|n• Great Vault: your weekly picks can hand you a piece you never saw drop.\|n• {CATALYST}: turns armour you already own into a set piece. This is the route that does not depend on luck.\|n\|n\|cffe8c36aThe Catalyst, and what to feed it\|r\|n• Each conversion costs one \|cffffffffVenomblight Manaflux\|r, and you gain one roughly every two weeks.\|n• \|cffffd100Note:\|r Every character builds their OWN supply, up to 8. So your alts are quietly saving charges too - and a character sitting at 8 has stopped gaining, which is the one way to waste them.\|n• \|cffffd100Note:\|r The new piece keeps \|cffffffffboth the item level and the secondary stats\|r of what you put in. What goes in is what comes back, only now it counts towards the set - so feed it your BEST piece in that slot, never a spare. Saving the good one and converting a leftover just gives you a leftover with a set bonus.\|n• \|cffffd100This changed in 12.1:\|r it did not always work this way. The Catalyst used to stamp a fixed set of stats on whatever you gave it, so feeding it a badly rolled piece was actually the clever move. That habit now costs you, because a bad piece comes back bad - permanently.\|n• Leech, Speed and Avoidance come across as well, and Blizzard says certain special effects do too - certain, not all. The Catalyst screen previews the result before you confirm, so hover it and read what you are actually getting.\|n• Mythic Keystones, Venomous Abyss bosses, Bountiful Delves and rated PvP drop extra charges too - but only once your class set bonuses are running. That is the Catalyst Unbound feat, and it is a reward for getting there, not a hoop to jump through first.\|n\|n\|cffe8c36aWhich pieces to convert\|r\|n• Only slots where you are wearing something ordinary. Never spend a charge on a slot that already holds a set piece.\|n• Keep your single strongest non-set piece and skip that slot — four is enough for the big bonus.\|n• Choosing between two? Take the one whose secondary stats you want to keep, since those carry over. |
| deDE **staat nu** | \|cffe8c36aWas ein Tier-Set ist\|r\|n• Fünf Slots — Kopf, Schultern, Brust, Hände, Beine — tragen einen Set-Bonus. Zwei Teile geben den kleinen, vier den großen. Der 4er-Bonus ist meist mehr wert als ein paar Gegenstandsstufen, also sind vier das Ziel.\|n• Du brauchst nur 4 von 5. Lass den Slot aus, in dem dein normales Teil am stärksten ist — genau das würdest du hergeben.\|n• Handgelenk, Gürtel, Schuhe, Hals, Ringe, Umhang und Waffen gehören nie zu einem Set. Trag dort einfach das Beste, was du hast.\|n\|n\|cffe8c36aWoher es diese Saison kommt\|r\|n• Der Season-2-Raid ist \|cffffffffThe Venomous Abyss\|r, auf Raid Finder, Normal, Heroisch und Mythisch.\|n• Great Vault: Deine wöchentliche Auswahl kann dir ein Teil geben, das nie gedroppt ist.\|n• {CATALYST}: baut Rüstung, die du schon besitzt, in ein Set-Teil um. Das ist der Weg, der nicht von Glück abhängt.\|n\|n\|cffe8c36aDer Catalyst und was du hineingibst\|r\|n• Jede Umwandlung kostet einen \|cffffffffVenomblight Manaflux\|r, und du bekommst etwa alle zwei Wochen einen.\|n• \|cffffd100Achtung:\|r Jeder Charakter baut seinen EIGENEN Vorrat auf, bis 8. Deine Twinks sammeln also still mit - und ein Charakter bei 8 gewinnt nichts mehr dazu, und genau so verschenkt man sie.\|n• \|cffffd100Achtung:\|r Das neue Teil behält \|cffffffffsowohl die Gegenstandsstufe als auch die Sekundärwerte\|r dessen, was du hineingibst. Es kommt genau dasselbe heraus, nur zählt es jetzt für das Set - gib also dein BESTES Teil in diesem Slot hinein, nie ein Reserveteil. Das gute aufheben und einen Rest umwandeln bringt dir einen Rest mit Set-Bonus.\|n• Mythic Keystones, Venomous-Abyss-Bosse, Bountiful Delves und gewertetes PvP geben ebenfalls Ladungen - aber erst, wenn deine Klassenset-Boni laufen. Das ist das Feat Catalyst Unbound: eine Belohnung dafür, dass du dein Set hast, keine Hürde davor.\|n\|n\|cffe8c36aWelche Teile du umwandelst — und welche nicht\|r\|n• Nur Slots, in denen du etwas Normales trägst. Verschwende nie eine Ladung auf einen Slot, der schon ein Set-Teil hat.\|n• Behalte dein stärkstes Nicht-Set-Teil und lass diesen Slot aus — vier reichen für den großen Bonus.\|n• Unentschieden zwischen zweien? Nimm das, dessen Sekundärwerte du behalten willst, denn die wandern mit. |

### `VALEERA_RUN_FMT`

| | |
|---|---|
| enUS **nu** | This delve: %s picked up. %s XP so far, kills included. |
| deDE **staat nu** | Diese Tiefe: %s aufgesammelt. Bisher %s XP, Kills eingerechnet. |

### `VALEERA_RUN_NONE`

| | |
|---|---|
| enUS **nu** | This delve: nothing picked up yet. Chunks of Companion Experience, Boons and the odd rich find all feed her — and so does killing things, so nothing you do in here is wasted. |
| deDE **staat nu** | Diese Tiefe: noch nichts aufgesammelt. Chunks of Companion Experience, Boons und ab und zu ein besonders ergiebiger Fund zahlen alle ein — und Töten zählt auch, es ist hier drin also nichts umsonst. |

## frFR — 7 gedrift

### `CURIO_NO_TEXT`

| | |
|---|---|
| enUS **nu** | (could not read the text for this one - hover it in game once, then run this again) |
| frFR **staat nu** | (texte illisible - survole-le une fois en jeu, puis relance ceci) |

### `DELVE_TIP_COLLEGIATE_CALAMITY_OVERVIEW`

| | |
|---|---|
| enUS **nu** | • Northwest Silvermoon / Eversong Woods (Thalassian University).\|n• Academy Under Siege -> Voidscorned Vagrant.\|n• Faculty of Fear -> Infiltrator Garand.\|n• Invasive Glow -> Hydrangea.\|n• An Elementary Antidote -> no final boss; treasure spawns instead of a kill. |
| frFR **staat nu** | • Nord-ouest de Lune-d'Argent/Eversong Woods (Université Thalassienne).\|n• Académie assiégée : portails vides.\|n• Faculté de la Peur : Lame du Crépuscule déguisée.\|n• Lueur envahissante : Lightbloom + Désherbeur.\|n• An Elementary Antidote : ingrédients et antidote, sans boss final.\|n• Quatre variantes, trois boss finaux différents. |

### `DELVE_TIP_COLLEGIATE_CALAMITY_ROUTE`

| | |
|---|---|
| enUS **nu** | • Under Siege: close void portals and kill Devouring Host.\|n• Faculty of Fear: Eye of Revelation — suspicious students glow yellow through walls.\|n• Invasive Glow: Deweeder kills small Lightbloom and damages large ones.\|n• Clear Luminibulb patches on the main level.\|n• An Elementary Antidote: speak to Sir Finley Mrrgglton, gather 10 Research Tomes, then collect ingredients and cure 7 Envenomed Denizens. Ingredients are worth different amounts, so grab the big ones.\|n• Fungal Pharmacon is a weapon too: it clears the poison pools AND hits everything within 5 yards of where it lands. |
| frFR **staat nu** | • En état de siège : fermez les portails du Vide et tuez l'Hôte dévorant.\|n• Faculté de la peur : Œil de la révélation – les étudiants méfiants brillent en jaune à travers les murs.\|n• Lueur envahissante : Le désherbant tue les petites fleurs de lumière et endommage les grandes.\|n• Effacer les patchs Lumibulb au niveau principal.\|n• An Elementary Antidote : parlez à Sir Finley Mrrgglton, rassemblez 10 Research Tomes, puis récoltez les ingrédients et soignez 7 Envenomed Denizens. Les ingrédients ne comptent pas tous pareil, prenez les gros.\|n• Fungal Pharmacon est aussi une arme : il nettoie les poison pools ET frappe tout dans un rayon de 5 yards autour du point d'impact. |

### `TIER_FOOTER`

| | |
|---|---|
| enUS **nu** | The bonus links come from a 12.0.7 datamine and may still be last season's - hover one for the live tooltip, which is always right. Where the pieces come from was read from your own client. |
| frFR **staat nu** | Les liens de bonus viennent d'un datamining 12.0.7 et peuvent dater de la saison passée - survolez-en un pour l'infobulle en direct, qui est toujours juste. La provenance des pièces a été lue dans votre propre client. |

### `TIER_GUIDE_BODY`

| | |
|---|---|
| enUS **nu** | \|cffe8c36aWhat a tier set is\|r\|n• Five slots — head, shoulders, chest, hands, legs — carry a set bonus. Two pieces give you a small one, four give you the big one. The 4-set is usually worth more than a few item levels, so four is the goal.\|n• You only need 4 of the 5. Leave out the slot where your ordinary item is strongest, because that is the one you would be giving up.\|n• Wrist, belt, boots, neck, rings, cloak and weapons are never part of a set. There, just wear the best item you have.\|n\|n\|cffe8c36aWhere it comes from this season\|r\|n• The Season 2 raid is \|cffffffffThe Venomous Abyss\|r, at Raid Finder, Normal, Heroic and Mythic.\|n• Great Vault: your weekly picks can hand you a piece you never saw drop.\|n• {CATALYST}: turns armour you already own into a set piece. This is the route that does not depend on luck.\|n\|n\|cffe8c36aThe Catalyst, and what to feed it\|r\|n• Each conversion costs one \|cffffffffVenomblight Manaflux\|r, and you gain one roughly every two weeks.\|n• \|cffffd100Note:\|r Every character builds their OWN supply, up to 8. So your alts are quietly saving charges too - and a character sitting at 8 has stopped gaining, which is the one way to waste them.\|n• \|cffffd100Note:\|r The new piece keeps \|cffffffffboth the item level and the secondary stats\|r of what you put in. What goes in is what comes back, only now it counts towards the set - so feed it your BEST piece in that slot, never a spare. Saving the good one and converting a leftover just gives you a leftover with a set bonus.\|n• \|cffffd100This changed in 12.1:\|r it did not always work this way. The Catalyst used to stamp a fixed set of stats on whatever you gave it, so feeding it a badly rolled piece was actually the clever move. That habit now costs you, because a bad piece comes back bad - permanently.\|n• Leech, Speed and Avoidance come across as well, and Blizzard says certain special effects do too - certain, not all. The Catalyst screen previews the result before you confirm, so hover it and read what you are actually getting.\|n• Mythic Keystones, Venomous Abyss bosses, Bountiful Delves and rated PvP drop extra charges too - but only once your class set bonuses are running. That is the Catalyst Unbound feat, and it is a reward for getting there, not a hoop to jump through first.\|n\|n\|cffe8c36aWhich pieces to convert\|r\|n• Only slots where you are wearing something ordinary. Never spend a charge on a slot that already holds a set piece.\|n• Keep your single strongest non-set piece and skip that slot — four is enough for the big bonus.\|n• Choosing between two? Take the one whose secondary stats you want to keep, since those carry over. |
| frFR **staat nu** | \|cffe8c36aCe qu'est un set\|r\|n• Cinq emplacements — tête, épaules, torse, mains, jambes — portent un bonus de set. Deux pièces donnent le petit, quatre le grand. Le bonus 4 pièces vaut souvent plus que quelques niveaux d'objet, donc visez quatre.\|n• Il n'en faut que 4 sur 5. Laissez de côté l'emplacement où votre pièce ordinaire est la plus forte, car c'est elle que vous abandonneriez.\|n• Poignets, ceinture, bottes, cou, anneaux, cape et armes ne font jamais partie d'un set. Portez-y simplement ce que vous avez de mieux.\|n\|n\|cffe8c36aD'où cela vient cette saison\|r•\|n• Le raid de la saison 2 est \|cffffffffThe Venomous Abyss\|r, en Recherche de raid, Normal, Héroïque et Mythique.\|n• Great Vault : vos choix hebdomadaires peuvent vous donner une pièce jamais tombée.\|n• {CATALYST} : transforme une armure que vous possédez déjà en pièce de set. C'est la voie qui ne dépend pas de la chance.\|n\|n\|cffe8c36aLe Catalyst, et quoi lui donner\|r\|n• Chaque conversion coûte un \|cffffffffVenomblight Manaflux\|r, et vous en gagnez un environ toutes les deux semaines.\|n• \|cffffd100Attention :\|r Chaque personnage constitue sa PROPRE réserve, jusqu'à 8. Vos rerolls accumulent donc aussi - et un personnage à 8 ne gagne plus rien, ce qui est la seule façon d'en perdre.\|n• \|cffffd100Attention :\|r La nouvelle pièce conserve \|cffffffffà la fois le niveau d'objet et les statistiques secondaires\|r de ce que vous donnez. Ce qui entre ressort à l'identique, mais compte désormais pour le set - donnez donc votre MEILLEURE pièce sur cet emplacement, jamais une pièce de rechange. Garder la bonne et convertir un reste vous donne un reste avec un bonus de set.\|n• Les Mythic Keystones, les boss de Venomous Abyss, les Bountiful Delves et le PvP coté donnent aussi des charges - mais seulement une fois vos bonus de set actifs. C'est le haut fait Catalyst Unbound : une récompense pour y être arrivé, pas un obstacle préalable.\|n\|n\|cffe8c36aQuelles pièces convertir, et lesquelles non\|r\|n• Uniquement les emplacements où vous portez de l'ordinaire. Ne dépensez jamais une charge sur un emplacement qui a déjà une pièce de set.\|n• Gardez votre meilleure pièce hors set et sautez cet emplacement — quatre suffisent pour le grand bonus.\|n• Hésitation entre deux ? Prenez celle dont vous voulez garder les stats secondaires, car elles suivent. |

### `VALEERA_RUN_FMT`

| | |
|---|---|
| enUS **nu** | This delve: %s picked up. %s XP so far, kills included. |
| frFR **staat nu** | Ce gouffre : %s ramassé. %s XP jusqu'ici, kills compris. |

### `VALEERA_RUN_NONE`

| | |
|---|---|
| enUS **nu** | This delve: nothing picked up yet. Chunks of Companion Experience, Boons and the odd rich find all feed her — and so does killing things, so nothing you do in here is wasted. |
| frFR **staat nu** | Ce gouffre : rien de ramassé pour l'instant. Les Chunks of Companion Experience, les Boons et de temps en temps une trouvaille généreuse comptent tous — et tuer compte aussi, donc rien de ce que tu fais ici n'est perdu. |

## esES — 7 gedrift

### `CURIO_NO_TEXT`

| | |
|---|---|
| enUS **nu** | (could not read the text for this one - hover it in game once, then run this again) |
| esES **staat nu** | (no se ha podido leer el texto - pasa el ratón por encima en el juego y vuelve a ejecutarlo) |

### `DELVE_TIP_COLLEGIATE_CALAMITY_OVERVIEW`

| | |
|---|---|
| enUS **nu** | • Northwest Silvermoon / Eversong Woods (Thalassian University).\|n• Academy Under Siege -> Voidscorned Vagrant.\|n• Faculty of Fear -> Infiltrator Garand.\|n• Invasive Glow -> Hydrangea.\|n• An Elementary Antidote -> no final boss; treasure spawns instead of a kill. |
| esES **staat nu** | • Noroeste de Silvermoon / Eversong Woods (Universidad Thalassian).\|n• Academia bajo asedio: portales vacíos.\|n• Facultad del Miedo: Espada del Crepúsculo disfrazada.\|n• Resplandor invasivo: Flor de luz + Deweeder.\|n• An Elementary Antidote: ingredientes y antídoto, sin jefe final.\|n• Cuatro variantes, tres jefes finales diferentes. |

### `DELVE_TIP_COLLEGIATE_CALAMITY_ROUTE`

| | |
|---|---|
| enUS **nu** | • Under Siege: close void portals and kill Devouring Host.\|n• Faculty of Fear: Eye of Revelation — suspicious students glow yellow through walls.\|n• Invasive Glow: Deweeder kills small Lightbloom and damages large ones.\|n• Clear Luminibulb patches on the main level.\|n• An Elementary Antidote: speak to Sir Finley Mrrgglton, gather 10 Research Tomes, then collect ingredients and cure 7 Envenomed Denizens. Ingredients are worth different amounts, so grab the big ones.\|n• Fungal Pharmacon is a weapon too: it clears the poison pools AND hits everything within 5 yards of where it lands. |
| esES **staat nu** | • Bajo asedio: cierra los portales del vacío y mata a la Hueste devoradora.\|n• Facultad del Miedo: Ojo de la Revelación: los estudiantes sospechosos brillan de color amarillo a través de las paredes.\|n• Resplandor invasivo: Deweeder mata a los pequeños Lightbloom y daña a los grandes.\|n• Borrar parches Luminibulb en el nivel principal.\|n• An Elementary Antidote: habla con Sir Finley Mrrgglton, reúne 10 Research Tomes, luego recoge ingredientes y cura a 7 Envenomed Denizens. Los ingredientes no valen lo mismo, así que coge los grandes.\|n• Fungal Pharmacon también es un arma: limpia las poison pools Y golpea todo en 5 yardas alrededor del impacto. |

### `TIER_FOOTER`

| | |
|---|---|
| enUS **nu** | The bonus links come from a 12.0.7 datamine and may still be last season's - hover one for the live tooltip, which is always right. Where the pieces come from was read from your own client. |
| esES **staat nu** | Los enlaces de bonus vienen de un datamining 12.0.7 y pueden ser de la temporada pasada - pasa el ratón por uno para ver el tooltip en vivo, que siempre acierta. De dónde salen las piezas se ha leído de tu propio cliente. |

### `TIER_GUIDE_BODY`

| | |
|---|---|
| enUS **nu** | \|cffe8c36aWhat a tier set is\|r\|n• Five slots — head, shoulders, chest, hands, legs — carry a set bonus. Two pieces give you a small one, four give you the big one. The 4-set is usually worth more than a few item levels, so four is the goal.\|n• You only need 4 of the 5. Leave out the slot where your ordinary item is strongest, because that is the one you would be giving up.\|n• Wrist, belt, boots, neck, rings, cloak and weapons are never part of a set. There, just wear the best item you have.\|n\|n\|cffe8c36aWhere it comes from this season\|r\|n• The Season 2 raid is \|cffffffffThe Venomous Abyss\|r, at Raid Finder, Normal, Heroic and Mythic.\|n• Great Vault: your weekly picks can hand you a piece you never saw drop.\|n• {CATALYST}: turns armour you already own into a set piece. This is the route that does not depend on luck.\|n\|n\|cffe8c36aThe Catalyst, and what to feed it\|r\|n• Each conversion costs one \|cffffffffVenomblight Manaflux\|r, and you gain one roughly every two weeks.\|n• \|cffffd100Note:\|r Every character builds their OWN supply, up to 8. So your alts are quietly saving charges too - and a character sitting at 8 has stopped gaining, which is the one way to waste them.\|n• \|cffffd100Note:\|r The new piece keeps \|cffffffffboth the item level and the secondary stats\|r of what you put in. What goes in is what comes back, only now it counts towards the set - so feed it your BEST piece in that slot, never a spare. Saving the good one and converting a leftover just gives you a leftover with a set bonus.\|n• \|cffffd100This changed in 12.1:\|r it did not always work this way. The Catalyst used to stamp a fixed set of stats on whatever you gave it, so feeding it a badly rolled piece was actually the clever move. That habit now costs you, because a bad piece comes back bad - permanently.\|n• Leech, Speed and Avoidance come across as well, and Blizzard says certain special effects do too - certain, not all. The Catalyst screen previews the result before you confirm, so hover it and read what you are actually getting.\|n• Mythic Keystones, Venomous Abyss bosses, Bountiful Delves and rated PvP drop extra charges too - but only once your class set bonuses are running. That is the Catalyst Unbound feat, and it is a reward for getting there, not a hoop to jump through first.\|n\|n\|cffe8c36aWhich pieces to convert\|r\|n• Only slots where you are wearing something ordinary. Never spend a charge on a slot that already holds a set piece.\|n• Keep your single strongest non-set piece and skip that slot — four is enough for the big bonus.\|n• Choosing between two? Take the one whose secondary stats you want to keep, since those carry over. |
| esES **staat nu** | \|cffe8c36aQué es un conjunto\|r\|n• Cinco ranuras — cabeza, hombros, pecho, manos, piernas — llevan un bonus de conjunto. Dos piezas dan el pequeño, cuatro el grande. El bonus de 4 suele valer más que unos cuantos niveles de objeto, así que el objetivo es cuatro.\|n• Solo necesitas 4 de 5. Deja fuera la ranura donde tu pieza normal sea más fuerte, porque es la que estarías entregando.\|n• Muñecas, cinturón, botas, cuello, anillos, capa y armas nunca forman parte de un conjunto. Ahí lleva simplemente lo mejor que tengas.\|n\|n\|cffe8c36aDe dónde sale esta temporada\|r\|n• La raid de la temporada 2 es \|cffffffffThe Venomous Abyss\|r, en Buscador de bandas, Normal, Heroico y Mítico.\|n• Great Vault: tus elecciones semanales pueden darte una pieza que nunca viste caer.\|n• {CATALYST}: convierte una armadura que ya tienes en una pieza de conjunto. Esta es la vía que no depende de la suerte.\|n\|n\|cffe8c36aEl Catalyst y qué meterle\|r\|n• Cada conversión cuesta un \|cffffffffVenomblight Manaflux\|r, y consigues uno cada dos semanas aproximadamente.\|n• \|cffffd100Atención:\|r Cada personaje acumula su PROPIA reserva, hasta 8. Tus alts también van guardando - y un personaje que está en 8 ha dejado de ganar, que es la única forma de desperdiciarlas.\|n• \|cffffd100Atención:\|r La pieza nueva conserva \|cfffffffftanto el nivel de objeto como las estadísticas secundarias\|r de lo que metes. Sale exactamente lo mismo, solo que ahora cuenta para el conjunto - así que mete tu MEJOR pieza de esa ranura, nunca una de repuesto. Guardar la buena y convertir una sobra te da una sobra con bonus de conjunto.\|n• Mythic Keystones, jefes de Venomous Abyss, Bountiful Delves y PvP con clasificación también dan cargas - pero solo cuando tus bonus de conjunto estén activos. Esa es la proeza Catalyst Unbound: una recompensa por haber llegado, no un requisito previo.\|n\|n\|cffe8c36aCuáles convertir y cuáles no\|r\|n• Solo ranuras donde lleves algo normal. Nunca gastes una carga en una ranura que ya tiene pieza de conjunto.\|n• Quédate con tu mejor pieza que no sea del conjunto y salta esa ranura — cuatro bastan para el bonus grande.\|n• ¿Dudas entre dos? Coge la que tenga las secundarias que quieres conservar, porque esas se mantienen. |

### `VALEERA_RUN_FMT`

| | |
|---|---|
| enUS **nu** | This delve: %s picked up. %s XP so far, kills included. |
| esES **staat nu** | Este delve: %s recogido. %s XP hasta ahora, con las muertes incluidas. |

### `VALEERA_RUN_NONE`

| | |
|---|---|
| enUS **nu** | This delve: nothing picked up yet. Chunks of Companion Experience, Boons and the odd rich find all feed her — and so does killing things, so nothing you do in here is wasted. |
| esES **staat nu** | Este delve: aún no has recogido nada. Los Chunks of Companion Experience, los Boons y de vez en cuando un hallazgo generoso suman todos — y matar también suma, así que nada de lo que hagas aquí se pierde. |

## ptBR — 7 gedrift

### `CURIO_NO_TEXT`

| | |
|---|---|
| enUS **nu** | (could not read the text for this one - hover it in game once, then run this again) |
| ptBR **staat nu** | (não foi possível ler o texto - passe o mouse por cima no jogo e execute novamente) |

### `DELVE_TIP_COLLEGIATE_CALAMITY_OVERVIEW`

| | |
|---|---|
| enUS **nu** | • Northwest Silvermoon / Eversong Woods (Thalassian University).\|n• Academy Under Siege -> Voidscorned Vagrant.\|n• Faculty of Fear -> Infiltrator Garand.\|n• Invasive Glow -> Hydrangea.\|n• An Elementary Antidote -> no final boss; treasure spawns instead of a kill. |
| ptBR **staat nu** | • Noroeste Silvermoon / Eversong Woods (Universidade Thalassian).\|n• Academia sob cerco: portais vazios.\|n• Faculdade do Medo: Lâmina do Crepúsculo disfarçada.\|n• Brilho Invasivo: Lightbloom + Deweeder.\|n• An Elementary Antidote: ingredientes e antídoto, sem chefe final.\|n• Quatro variantes, três chefes finais diferentes. |

### `DELVE_TIP_COLLEGIATE_CALAMITY_ROUTE`

| | |
|---|---|
| enUS **nu** | • Under Siege: close void portals and kill Devouring Host.\|n• Faculty of Fear: Eye of Revelation — suspicious students glow yellow through walls.\|n• Invasive Glow: Deweeder kills small Lightbloom and damages large ones.\|n• Clear Luminibulb patches on the main level.\|n• An Elementary Antidote: speak to Sir Finley Mrrgglton, gather 10 Research Tomes, then collect ingredients and cure 7 Envenomed Denizens. Ingredients are worth different amounts, so grab the big ones.\|n• Fungal Pharmacon is a weapon too: it clears the poison pools AND hits everything within 5 yards of where it lands. |
| ptBR **staat nu** | • Under Siege: feche portais vazios e mate Devouring Host.\|n• Faculdade do Medo: Olho da Revelação — estudantes suspeitos brilham em amarelo através das paredes.\|n• Brilho Invasivo: Deweeder mata Lightbloom pequeno e danifica os grandes.\|n• Patches claros do Luminibulb no nível principal.\|n• An Elementary Antidote: fale com Sir Finley Mrrgglton, reúna 10 Research Tomes, depois colete ingredientes e cure 7 Envenomed Denizens. Os ingredientes não valem o mesmo, então pegue os grandes.\|n• Fungal Pharmacon também é uma arma: limpa as poison pools E atinge tudo num raio de 5 jardas do impacto. |

### `TIER_FOOTER`

| | |
|---|---|
| enUS **nu** | The bonus links come from a 12.0.7 datamine and may still be last season's - hover one for the live tooltip, which is always right. Where the pieces come from was read from your own client. |
| ptBR **staat nu** | Os links de bônus vêm de um datamining 12.0.7 e podem ser da temporada passada - passe o mouse em um para ver a tooltip ao vivo, que está sempre certa. De onde vêm as peças foi lido do seu próprio cliente. |

### `TIER_GUIDE_BODY`

| | |
|---|---|
| enUS **nu** | \|cffe8c36aWhat a tier set is\|r\|n• Five slots — head, shoulders, chest, hands, legs — carry a set bonus. Two pieces give you a small one, four give you the big one. The 4-set is usually worth more than a few item levels, so four is the goal.\|n• You only need 4 of the 5. Leave out the slot where your ordinary item is strongest, because that is the one you would be giving up.\|n• Wrist, belt, boots, neck, rings, cloak and weapons are never part of a set. There, just wear the best item you have.\|n\|n\|cffe8c36aWhere it comes from this season\|r\|n• The Season 2 raid is \|cffffffffThe Venomous Abyss\|r, at Raid Finder, Normal, Heroic and Mythic.\|n• Great Vault: your weekly picks can hand you a piece you never saw drop.\|n• {CATALYST}: turns armour you already own into a set piece. This is the route that does not depend on luck.\|n\|n\|cffe8c36aThe Catalyst, and what to feed it\|r\|n• Each conversion costs one \|cffffffffVenomblight Manaflux\|r, and you gain one roughly every two weeks.\|n• \|cffffd100Note:\|r Every character builds their OWN supply, up to 8. So your alts are quietly saving charges too - and a character sitting at 8 has stopped gaining, which is the one way to waste them.\|n• \|cffffd100Note:\|r The new piece keeps \|cffffffffboth the item level and the secondary stats\|r of what you put in. What goes in is what comes back, only now it counts towards the set - so feed it your BEST piece in that slot, never a spare. Saving the good one and converting a leftover just gives you a leftover with a set bonus.\|n• \|cffffd100This changed in 12.1:\|r it did not always work this way. The Catalyst used to stamp a fixed set of stats on whatever you gave it, so feeding it a badly rolled piece was actually the clever move. That habit now costs you, because a bad piece comes back bad - permanently.\|n• Leech, Speed and Avoidance come across as well, and Blizzard says certain special effects do too - certain, not all. The Catalyst screen previews the result before you confirm, so hover it and read what you are actually getting.\|n• Mythic Keystones, Venomous Abyss bosses, Bountiful Delves and rated PvP drop extra charges too - but only once your class set bonuses are running. That is the Catalyst Unbound feat, and it is a reward for getting there, not a hoop to jump through first.\|n\|n\|cffe8c36aWhich pieces to convert\|r\|n• Only slots where you are wearing something ordinary. Never spend a charge on a slot that already holds a set piece.\|n• Keep your single strongest non-set piece and skip that slot — four is enough for the big bonus.\|n• Choosing between two? Take the one whose secondary stats you want to keep, since those carry over. |
| ptBR **staat nu** | \|cffe8c36aO que é um conjunto\|r\|n• Cinco espaços — cabeça, ombros, peito, mãos, pernas — carregam um bônus de conjunto. Duas peças dão o pequeno, quatro dão o grande. O bônus de 4 costuma valer mais que alguns níveis de item, então quatro é o objetivo.\|n• Você só precisa de 4 dos 5. Deixe de fora o espaço onde sua peça comum é mais forte, porque é ela que você estaria abrindo mão.\|n• Pulsos, cinto, botas, pescoço, anéis, capa e armas nunca fazem parte de um conjunto. Ali é só usar o melhor que tiver.\|n\|n\|cffe8c36aDe onde vem nesta temporada\|r\|n• A raide da temporada 2 é \|cffffffffThe Venomous Abyss\|r, em Buscador de Raide, Normal, Heroico e Mítico.\|n• Great Vault: suas escolhas semanais podem te dar uma peça que nunca caiu.\|n• {CATALYST}: transforma uma armadura que você já tem em peça de conjunto. Este é o caminho que não depende de sorte.\|n\|n\|cffe8c36aO Catalyst e o que colocar nele\|r\|n• Cada conversão custa um \|cffffffffVenomblight Manaflux\|r, e você ganha um a cada duas semanas mais ou menos.\|n• \|cffffd100Atenção:\|r Cada personagem acumula a PRÓPRIA reserva, até 8. Seus alts também vão guardando - e um personagem parado em 8 não ganha mais nada, que é o único jeito de desperdiçar.\|n• \|cffffd100Atenção:\|r A peça nova mantém \|cffffffffo nível de item E os atributos secundários\|r do que você coloca. Sai exatamente o mesmo, só que agora conta para o conjunto - então coloque a sua MELHOR peça daquele espaço, nunca uma reserva. Guardar a boa e converter uma sobra te dá uma sobra com bônus de conjunto.\|n• Mythic Keystones, chefes da Venomous Abyss, Bountiful Delves e PvP ranqueado também dão cargas - mas só depois que seus bônus de conjunto estiverem ativos. Esse é o feito Catalyst Unbound: uma recompensa por ter chegado lá, não um obstáculo antes.\|n\|n\|cffe8c36aQuais converter e quais não\|r\|n• Só espaços onde você usa algo comum. Nunca gaste uma carga num espaço que já tem peça de conjunto.\|n• Guarde sua melhor peça fora do conjunto e pule esse espaço — quatro bastam para o bônus grande.\|n• Na dúvida entre duas? Pegue a que tem os secundários que você quer manter, porque eles vão junto. |

### `VALEERA_RUN_FMT`

| | |
|---|---|
| enUS **nu** | This delve: %s picked up. %s XP so far, kills included. |
| ptBR **staat nu** | Este delve: %s recolhido. %s XP até agora, mortes incluídas. |

### `VALEERA_RUN_NONE`

| | |
|---|---|
| enUS **nu** | This delve: nothing picked up yet. Chunks of Companion Experience, Boons and the odd rich find all feed her — and so does killing things, so nothing you do in here is wasted. |
| ptBR **staat nu** | Este delve: ainda não recolheste nada. Os Chunks of Companion Experience, os Boons e de vez em quando um achado generoso contam todos — e matar também conta, por isso nada do que fazes aqui é desperdiçado. |

## itIT — 7 gedrift

### `CURIO_NO_TEXT`

| | |
|---|---|
| enUS **nu** | (could not read the text for this one - hover it in game once, then run this again) |
| itIT **staat nu** | (testo non leggibile - passaci sopra una volta nel gioco e rilancia questo) |

### `DELVE_TIP_COLLEGIATE_CALAMITY_OVERVIEW`

| | |
|---|---|
| enUS **nu** | • Northwest Silvermoon / Eversong Woods (Thalassian University).\|n• Academy Under Siege -> Voidscorned Vagrant.\|n• Faculty of Fear -> Infiltrator Garand.\|n• Invasive Glow -> Hydrangea.\|n• An Elementary Antidote -> no final boss; treasure spawns instead of a kill. |
| itIT **staat nu** | • Silvermoon / Eversong Woods nord-ovest (Thalassian University).\|n• Academy Under Siege -> Voidscorned Vagrant.\|n• Faculty of Fear -> Infiltrator Garand.\|n• Invasive Glow -> Hydrangea.\|n• An Elementary Antidote -> nessun boss finale; compaiono tesori invece di un'uccisione. |

### `DELVE_TIP_COLLEGIATE_CALAMITY_ROUTE`

| | |
|---|---|
| enUS **nu** | • Under Siege: close void portals and kill Devouring Host.\|n• Faculty of Fear: Eye of Revelation — suspicious students glow yellow through walls.\|n• Invasive Glow: Deweeder kills small Lightbloom and damages large ones.\|n• Clear Luminibulb patches on the main level.\|n• An Elementary Antidote: speak to Sir Finley Mrrgglton, gather 10 Research Tomes, then collect ingredients and cure 7 Envenomed Denizens. Ingredients are worth different amounts, so grab the big ones.\|n• Fungal Pharmacon is a weapon too: it clears the poison pools AND hits everything within 5 yards of where it lands. |
| itIT **staat nu** | • Under Siege: chiudi i void portal e uccidi i Devouring Host.\|n• Faculty of Fear: Eye of Revelation — gli studenti sospetti brillano di giallo attraverso i muri.\|n• Invasive Glow: il Deweeder uccide i piccoli Lightbloom e danneggia quelli grandi.\|n• Elimina le zone di Luminibulb sul livello principale.\|n• An Elementary Antidote: parla con Sir Finley Mrrgglton, raccogli 10 Research Tomes, poi raccogli gli ingredienti e cura 7 Envenomed Denizens. Gli ingredienti valgono cifre diverse, quindi prendi quelli grandi.\|n• Fungal Pharmacon è anche un'arma: ripulisce le poison pool E colpisce tutto entro 5 yard dal punto d'impatto. |

### `TIER_FOOTER`

| | |
|---|---|
| enUS **nu** | The bonus links come from a 12.0.7 datamine and may still be last season's - hover one for the live tooltip, which is always right. Where the pieces come from was read from your own client. |
| itIT **staat nu** | I link dei bonus vengono da un datamining 12.0.7 e potrebbero essere ancora della scorsa stagione - passaci sopra per il tooltip live, che è sempre giusto. Da dove arrivano i pezzi è stato letto dal tuo client. |

### `TIER_GUIDE_BODY`

| | |
|---|---|
| enUS **nu** | \|cffe8c36aWhat a tier set is\|r\|n• Five slots — head, shoulders, chest, hands, legs — carry a set bonus. Two pieces give you a small one, four give you the big one. The 4-set is usually worth more than a few item levels, so four is the goal.\|n• You only need 4 of the 5. Leave out the slot where your ordinary item is strongest, because that is the one you would be giving up.\|n• Wrist, belt, boots, neck, rings, cloak and weapons are never part of a set. There, just wear the best item you have.\|n\|n\|cffe8c36aWhere it comes from this season\|r\|n• The Season 2 raid is \|cffffffffThe Venomous Abyss\|r, at Raid Finder, Normal, Heroic and Mythic.\|n• Great Vault: your weekly picks can hand you a piece you never saw drop.\|n• {CATALYST}: turns armour you already own into a set piece. This is the route that does not depend on luck.\|n\|n\|cffe8c36aThe Catalyst, and what to feed it\|r\|n• Each conversion costs one \|cffffffffVenomblight Manaflux\|r, and you gain one roughly every two weeks.\|n• \|cffffd100Note:\|r Every character builds their OWN supply, up to 8. So your alts are quietly saving charges too - and a character sitting at 8 has stopped gaining, which is the one way to waste them.\|n• \|cffffd100Note:\|r The new piece keeps \|cffffffffboth the item level and the secondary stats\|r of what you put in. What goes in is what comes back, only now it counts towards the set - so feed it your BEST piece in that slot, never a spare. Saving the good one and converting a leftover just gives you a leftover with a set bonus.\|n• \|cffffd100This changed in 12.1:\|r it did not always work this way. The Catalyst used to stamp a fixed set of stats on whatever you gave it, so feeding it a badly rolled piece was actually the clever move. That habit now costs you, because a bad piece comes back bad - permanently.\|n• Leech, Speed and Avoidance come across as well, and Blizzard says certain special effects do too - certain, not all. The Catalyst screen previews the result before you confirm, so hover it and read what you are actually getting.\|n• Mythic Keystones, Venomous Abyss bosses, Bountiful Delves and rated PvP drop extra charges too - but only once your class set bonuses are running. That is the Catalyst Unbound feat, and it is a reward for getting there, not a hoop to jump through first.\|n\|n\|cffe8c36aWhich pieces to convert\|r\|n• Only slots where you are wearing something ordinary. Never spend a charge on a slot that already holds a set piece.\|n• Keep your single strongest non-set piece and skip that slot — four is enough for the big bonus.\|n• Choosing between two? Take the one whose secondary stats you want to keep, since those carry over. |
| itIT **staat nu** | \|cffe8c36aCos'è un tier set\|r\|n• Cinque slot — testa, spalle, petto, mani, gambe — portano un bonus set. Due pezzi danno quello piccolo, quattro quello grande. Il bonus da 4 vale di solito più di qualche livello oggetto, quindi l'obiettivo è quattro.\|n• Te ne servono solo 4 su 5. Lascia fuori lo slot dove il tuo pezzo normale è più forte, perché è quello a cui rinunceresti.\|n• Polsi, cintura, stivali, collo, anelli, mantello e armi non fanno mai parte di un set. Lì metti semplicemente il meglio che hai.\|n\|n\|cffe8c36aDa dove arriva questa stagione\|r\|n• Il raid della Stagione 2 è \|cffffffffThe Venomous Abyss\|r, in Raid Finder, Normale, Eroico e Mitico.\|n• Great Vault: le tue scelte settimanali possono darti un pezzo che non hai mai visto cadere.\|n• {CATALYST}: trasforma un'armatura che possiedi già in un pezzo del set. È la via che non dipende dalla fortuna.\|n\|n\|cffe8c36aIl Catalyst e cosa dargli\|r\|n• Ogni conversione costa un \|cffffffffVenomblight Manaflux\|r, e ne ottieni uno circa ogni due settimane.\|n• \|cffffd100Attenzione:\|r Ogni personaggio accumula la SUA riserva, fino a 8. Anche i tuoi alt stanno mettendo da parte - e un personaggio fermo a 8 non guadagna più nulla, che è l'unico modo per sprecarle.\|n• \|cffffd100Attenzione:\|r Il pezzo nuovo mantiene \|cffffffffsia il livello oggetto sia le statistiche secondarie\|r di quello che ci metti. Esce esattamente lo stesso, solo che ora conta per il set - quindi mettici il tuo pezzo MIGLIORE per quello slot, mai un ricambio. Tenere quello buono e convertire un avanzo ti dà un avanzo con un bonus set.\|n• Mythic Keystone, boss della Venomous Abyss, Bountiful Delve e PvP classificato danno anche cariche - ma solo quando i bonus del set sono attivi. È l'impresa Catalyst Unbound: una ricompensa per esserci arrivato, non un ostacolo prima.\|n\|n\|cffe8c36aQuali convertire e quali no\|r\|n• Solo slot dove indossi qualcosa di normale. Non sprecare mai una carica su uno slot che ha già un pezzo del set.\|n• Tieni il tuo pezzo non-set più forte e salta quello slot — quattro bastano per il bonus grande.\|n• Indeciso tra due? Prendi quello di cui vuoi tenere le secondarie, perché quelle passano. |

### `VALEERA_RUN_FMT`

| | |
|---|---|
| enUS **nu** | This delve: %s picked up. %s XP so far, kills included. |
| itIT **staat nu** | Questa delve: %s raccolti. %s XP finora, uccisioni comprese. |

### `VALEERA_RUN_NONE`

| | |
|---|---|
| enUS **nu** | This delve: nothing picked up yet. Chunks of Companion Experience, Boons and the odd rich find all feed her — and so does killing things, so nothing you do in here is wasted. |
| itIT **staat nu** | Questa delve: ancora niente raccolto. Chunks of Companion Experience, Boon e ogni tanto un ritrovamento generoso contribuiscono tutti — e anche uccidere conta, quindi niente di quel che fai qui è sprecato. |

## nlNL — 7 gedrift

### `CURIO_NO_TEXT`

| | |
|---|---|
| enUS **nu** | (could not read the text for this one - hover it in game once, then run this again) |
| nlNL **staat nu** | (tekst niet kunnen lezen - ga er in het spel een keer overheen en draai dit opnieuw) |

### `DELVE_TIP_COLLEGIATE_CALAMITY_OVERVIEW`

| | |
|---|---|
| enUS **nu** | • Northwest Silvermoon / Eversong Woods (Thalassian University).\|n• Academy Under Siege -> Voidscorned Vagrant.\|n• Faculty of Fear -> Infiltrator Garand.\|n• Invasive Glow -> Hydrangea.\|n• An Elementary Antidote -> no final boss; treasure spawns instead of a kill. |
| nlNL **staat nu** | • Noordwest Silvermoon / Eversong Woods (Thalassian University).\|n• Academy Under Siege -> Voidscorned Vagrant.\|n• Faculty of Fear -> Infiltrator Garand.\|n• Invasive Glow -> Hydrangea.\|n• An Elementary Antidote -> geen eindbaas; er komen treasures in plaats van een kill. |

### `DELVE_TIP_COLLEGIATE_CALAMITY_ROUTE`

| | |
|---|---|
| enUS **nu** | • Under Siege: close void portals and kill Devouring Host.\|n• Faculty of Fear: Eye of Revelation — suspicious students glow yellow through walls.\|n• Invasive Glow: Deweeder kills small Lightbloom and damages large ones.\|n• Clear Luminibulb patches on the main level.\|n• An Elementary Antidote: speak to Sir Finley Mrrgglton, gather 10 Research Tomes, then collect ingredients and cure 7 Envenomed Denizens. Ingredients are worth different amounts, so grab the big ones.\|n• Fungal Pharmacon is a weapon too: it clears the poison pools AND hits everything within 5 yards of where it lands. |
| nlNL **staat nu** | • Under Siege: sluit void-portals en kill Devouring Host.\|n• Faculty of Fear: Eye of Revelation — verdachte studenten gloeien geel door muren.\|n• Invasive Glow: Deweeder voor kleine Lightbloom, schade aan grote.\|n• Verwijder Luminibulb-patches op het hoofdniveau.\|n• An Elementary Antidote: praat met Sir Finley Mrrgglton, verzamel 10 Research Tomes, daarna ingrediënten en genees 7 Envenomed Denizens. Ingrediënten tellen verschillend zwaar, dus pak de grote.\|n• Fungal Pharmacon is ook een wapen: hij ruimt de poison pools op én raakt alles binnen 5 yards van waar hij landt. |

### `TIER_FOOTER`

| | |
|---|---|
| enUS **nu** | The bonus links come from a 12.0.7 datamine and may still be last season's - hover one for the live tooltip, which is always right. Where the pieces come from was read from your own client. |
| nlNL **staat nu** | De bonus-links komen uit een 12.0.7-datamine en kunnen nog van vorig seizoen zijn - hover er een voor de live tooltip, die klopt altijd. Waar de stukken vandaan komen is uit je eigen client gelezen. |

### `TIER_GUIDE_BODY`

| | |
|---|---|
| enUS **nu** | \|cffe8c36aWhat a tier set is\|r\|n• Five slots — head, shoulders, chest, hands, legs — carry a set bonus. Two pieces give you a small one, four give you the big one. The 4-set is usually worth more than a few item levels, so four is the goal.\|n• You only need 4 of the 5. Leave out the slot where your ordinary item is strongest, because that is the one you would be giving up.\|n• Wrist, belt, boots, neck, rings, cloak and weapons are never part of a set. There, just wear the best item you have.\|n\|n\|cffe8c36aWhere it comes from this season\|r\|n• The Season 2 raid is \|cffffffffThe Venomous Abyss\|r, at Raid Finder, Normal, Heroic and Mythic.\|n• Great Vault: your weekly picks can hand you a piece you never saw drop.\|n• {CATALYST}: turns armour you already own into a set piece. This is the route that does not depend on luck.\|n\|n\|cffe8c36aThe Catalyst, and what to feed it\|r\|n• Each conversion costs one \|cffffffffVenomblight Manaflux\|r, and you gain one roughly every two weeks.\|n• \|cffffd100Note:\|r Every character builds their OWN supply, up to 8. So your alts are quietly saving charges too - and a character sitting at 8 has stopped gaining, which is the one way to waste them.\|n• \|cffffd100Note:\|r The new piece keeps \|cffffffffboth the item level and the secondary stats\|r of what you put in. What goes in is what comes back, only now it counts towards the set - so feed it your BEST piece in that slot, never a spare. Saving the good one and converting a leftover just gives you a leftover with a set bonus.\|n• \|cffffd100This changed in 12.1:\|r it did not always work this way. The Catalyst used to stamp a fixed set of stats on whatever you gave it, so feeding it a badly rolled piece was actually the clever move. That habit now costs you, because a bad piece comes back bad - permanently.\|n• Leech, Speed and Avoidance come across as well, and Blizzard says certain special effects do too - certain, not all. The Catalyst screen previews the result before you confirm, so hover it and read what you are actually getting.\|n• Mythic Keystones, Venomous Abyss bosses, Bountiful Delves and rated PvP drop extra charges too - but only once your class set bonuses are running. That is the Catalyst Unbound feat, and it is a reward for getting there, not a hoop to jump through first.\|n\|n\|cffe8c36aWhich pieces to convert\|r\|n• Only slots where you are wearing something ordinary. Never spend a charge on a slot that already holds a set piece.\|n• Keep your single strongest non-set piece and skip that slot — four is enough for the big bonus.\|n• Choosing between two? Take the one whose secondary stats you want to keep, since those carry over. |
| nlNL **staat nu** | \|cffe8c36aWat een tier set is\|r\|n• Vijf slots — hoofd, schouders, borst, handen, benen — dragen een set-bonus. Bij twee stuks krijg je een kleine, bij vier de grote. Die 4-set is meestal meer waard dan een paar item levels, dus vier is het doel.\|n• Je hebt er maar 4 van de 5 nodig. Sla het slot over waar je gewone stuk het sterkst is, want dat is wat je zou inleveren.\|n• Pols, riem, schoenen, ketting, ringen, cloak en wapens horen nooit bij een set. Draag daar gewoon het beste dat je hebt.\|n\|n\|cffe8c36aWaar het vandaan komt dit seizoen\|r\|n• De Season 2-raid is \|cffffffffThe Venomous Abyss\|r, op Raid Finder, Normal, Heroic en Mythic.\|n• Great Vault: je wekelijkse keuzes kunnen je een stuk geven dat je nooit hebt zien droppen.\|n• {CATALYST}: bouwt uitrusting die je al hebt om tot een setstuk. Dit is de route die niet van geluk afhangt.\|n\|n\|cffe8c36aDe Catalyst, en wat je erin stopt\|r\|n• Elke omzetting kost één \|cffffffffVenomblight Manaflux\|r, en je krijgt er ongeveer één per twee weken.\|n• \|cffffd100Let op:\|r Elk personage bouwt zijn EIGEN voorraad op, tot 8. Je alts sparen dus stilletjes mee - en een character dat op 8 staat wint niets meer, en dat is de enige manier om ze te verspillen.\|n• \|cffffd100Let op:\|r Het nieuwe stuk behoudt \|cffffffffzowel het item level als de secondary stats\|r van wat je erin stopt. Er komt precies hetzelfde uit, alleen telt het nu mee voor de set - stop er dus je BESTE stuk in dat slot in, nooit een reserve. Het goede bewaren en een restje omzetten levert je een restje met een setbonus op.\|n• \|cffffd100Dit is veranderd in 12.1:\|r vroeger ging het anders. De Catalyst zette een vaste set stats op wat je er ook in stopte, dus een slecht gerold stuk omzetten was juist slim. Die gewoonte kost je nu stats, want een slecht stuk komt slecht terug - en definitief.\|n• Leech, Speed en Avoidance gaan ook mee, en Blizzard zegt dat bepaalde speciale effecten dat ook doen - bepaalde, niet alle. Het Catalyst-scherm laat een voorbeeld zien vóór je bevestigt, dus ga er met je muis overheen en lees wat je echt krijgt.\|n• Mythic Keystones, Venomous Abyss-bosses, Bountiful Delves en rated PvP geven ook extra charges - maar pas zodra je set-bonussen draaien. Dat is de Catalyst Unbound-feat: een beloning voor het bereiken van je set, geen hoepel vooraf.\|n\|n\|cffe8c36aWelke stukken je wel en niet omzet\|r\|n• Alleen slots waar je iets gewoons draagt. Verspil nooit een charge op een slot waar al een setstuk zit.\|n• Hou je één sterkste niet-set-stuk en sla dat slot over — vier is genoeg voor de grote bonus.\|n• Twijfel je tussen twee? Neem die waarvan je de secondary stats wilt houden, want die gaan mee. |

### `VALEERA_RUN_FMT`

| | |
|---|---|
| enUS **nu** | This delve: %s picked up. %s XP so far, kills included. |
| nlNL **staat nu** | Deze delve: %s opgepakt. %s XP tot nu toe, kills meegerekend. |

### `VALEERA_RUN_NONE`

| | |
|---|---|
| enUS **nu** | This delve: nothing picked up yet. Chunks of Companion Experience, Boons and the odd rich find all feed her — and so does killing things, so nothing you do in here is wasted. |
| nlNL **staat nu** | Deze delve: nog niets opgepakt. Chunks of Companion Experience, Boons én af en toe een rijke vondst tellen allemaal mee — en doden telt óók, dus niets van wat je hier doet is voor niets. |

