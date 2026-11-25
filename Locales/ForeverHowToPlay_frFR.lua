local _, ns = ...
-- French "How you play" for WoW Forever (translated 7 Nov 2026 from Modules/ForeverHowToPlay.lua by mh-writer;
-- game names measured in docs/forever/CLIENT_NAMES_FOREVER_2026-11-07.md). Same sections, same order.
-- Not reviewed by a native speaker.
if not ns.IS_FOREVER then
	return
end
if GetLocale() ~= "frFR" then
	return
end
ns.FOREVER_HOWTOPLAY_L = ns.FOREVER_HOWTOPLAY_L or {}
ns.FOREVER_HOWTOPLAY_L.frFR = {
	COMMON = {
		{ "Avant de commencer", [[
- Les touches supposent que le bloc de touches de MH est en place : /mh block, puis les étapes 1 et 2.
- **Rangs des sorts.** La plupart des sorts existent en plusieurs rangs : Rang 1, Rang 2, et ainsi de suite. Un rang plus élevé, c'est le même sort, juste plus fort. Tu achètes les nouveaux rangs chez ton maître de classe quand tu montes de niveau. Tu n'as rien à échanger : les touches de MH lancent un sort par son nom, et le jeu prend le rang le plus élevé que tu connais.
- **Une touche encore vide** garde sa place. Elle se remplit quand tu apprends le sort. Si un nouveau sort n'apparaît pas, ouvre le bloc de touches (/mh block) et appuie sur **Mettre à jour (nouveaux sorts)**.
- **Les sorts de talent** ont aussi une touche. Si tu ne prends jamais ce talent, la touche reste vide. C'est normal.
- **Mana** : c'est la barre bleue sous ta vie. La plupart des sorts coûtent du mana. Quand elle est vide, tu ne peux plus lancer de sorts.
- **Cooldown** = le temps d'attente avant de pouvoir relancer un sort.
- Touches fixes, les mêmes pour chaque classe : **T** = potion, **Shift-T** = Pierre de soins, **G** = bijou.]] },
		-- not measured: The Great Outdoors (no QuestV2.frFR in the gamedata cache)
		{ "Camping", [[
- Le **camping** n'est pas un métier. Chaque métier peut fabriquer un **élément de camp**. La Cuisine fabrique le feu.
- **Commence** par la quête **The Great Outdoors**, dans chaque zone de départ.
- **1. Le feu.** Avec la Cuisine, fabrique un **Kit de feu de camp basique** : 1 Bois simple, avec **Silex et amadou** comme outil (tu le gardes). Utilise le kit en extérieur, pas en combat. Le feu a de la place pour 3 éléments (Feu de camp de compagnon 5, Feu de camp de spécialiste 10). Cooldown : 5 minutes.
- **2. Un élément.** Fabrique-le avec ton métier. Il te faut la compétence 20 pour le poser. Pose-le près du feu. L'objet est consommé.
- **3. Assieds-toi** près du feu. Tu reçois **Feu de camp accueillant** pendant 60 secondes. Tu peux fabriquer, mais ne marche pas. Ensuite, tu reçois **Avantages du camp** pendant 1 heure, avec une ligne par élément.
- **Règles :** tous les éléments partagent un cooldown de 1 heure. Chaque sorte d'élément une seule fois par camp.
- **Conflits :** tu ne peux pas avoir un buff de camp et le buff de classe indiqué ci-dessous en même temps. La plupart des buffs de camp augmentent avec ton niveau.
- Dépeçage : **Chaise du camp** = chances de coup critique. Conflit avec Aura de sélénien.
- Forge : **Meule à aiguiser** = Force. Conflit avec Totem de Force de la Terre.
- Herboristerie : **Bougie d’encens** = Intelligence. Conflit avec Intelligence des arcanes.
- Alchimie : **Puits de mana** = du mana toutes les 5 secondes. Conflit avec Bénédiction de sagesse.
- Minage : **Magnétite** = puissance d'attaque en mêlée. Conflit avec Bénédiction de puissance.
- Pêche : **Bocal à poisson** = toutes les caractéristiques. Conflit avec Bénédiction des rois.
- Premiers soins : **Trousse de premiers soins** = Endurance. Conflit avec Mot de pouvoir : Robustesse.
- Couture : **Bannière de faction** = Esprit, seulement pour ta propre faction. Conflit avec Esprit divin.
- Enchantement : **Luth enchanté** = armure, toutes les caractéristiques et résistances. Conflit avec Marque du fauve.
- Travail du cuir : **Tente du camp** = repose-toi 30 secondes près d'elle pour plus d'XP de repos, une fois par heure.
- Ingénierie : **Robot vendeur de composants** = pas de buff, il vend des composants.
- **/mh camp** montre ce que MH peut lire de tes buffs de camp.]] },
		-- not measured: Innkeeper Wiley (NPC 6791 not in Creature.frFR of the gamedata cache)
		-- not measured: Scarce (material quality word, no frFR source found)
		{ "Points d’héritage", [[
- Les **Points d’héritage** se gagnent pour tout ton compte : 65 défis, 1 point chacun. Chaque personnage dépense ses propres points, jusqu'à 16 pour l'instant.
- **Comment les gagner :** une classe qui atteint 25, 45 et 60 pour la première fois. Alchimie, Forge, Enchantement, Ingénierie, Travail du cuir et Couture à 150, 225 et 300. Quelques-uns de plus pour le JcJ, les donjons, les raids et l'exploration.
- Les métiers de récolte, la Cuisine, les Premiers soins et la Pêche ne donnent aucun point.
- La fenêtre s'ouvre avec ton premier point. Pour la plupart des joueurs, c'est au niveau 25.
- **Dépenser :** appuie sur le bouton **Héritage** dans la barre de menu. Il y a trois arbres : **Métiers**, **Aventure** et **Ingéniosité**. Chaque rang coûte 1 point.
- La **colonne 2** s'ouvre après 5 points dans cet arbre, la **colonne 3** après 10.
- **Annuler :** chez ton maître de classe, tous les avantages d'un coup. Le maître affiche le prix. Tu as Talent ? Alors désapprends d'abord tes talents de classe.
- **Récompenses** à 15, 25, 40 et 55 points gagnés (gagnés, pas dépensés). Va les chercher auprès d'**Innkeeper Wiley** à Cabestan.
- **Exemple, monter de niveau :** **Bien reposé** (l'XP de repos s'accumule plus vite), puis **Talent** (demande Bien reposé) : des points de talent jusqu'à 5 niveaux plus tôt, jamais plus de 51 au total.
- **Exemple, métiers :** **Heures supplémentaires** (plus de points de compétence gagnés) et **Récolte généreuse** (des matériaux Scarce plus souvent avec le Minage, l'Herboristerie et le Dépeçage).
- **Étude assidue** est un bouton, pas un avantage passif : 25 secondes d'incantation, puis 23 heures d'attente. Elle augmente de 1 ton métier le plus bas.
- **/mh legacy** montre combien de points MH peut lire.]] },
		-- 21 Nov 2026: new 4th section (mh-writer). Measured DB2 frFR 1.60.1.71037: TALENT_SPEC_SECONDARY "Talents secondaires",
		-- spell 63624 "Apprendre une seconde spécialisation des talents" (no separate "Dual Spec" word in the client).
		{ "Talents : réinitialiser et seconde spécialisation", [[
- **Réinitialise tes talents** chez ton maître de classe : parle-lui et choisis l'option des talents. Ensuite, redépense tes points. Les joueurs disent que ça coûte 1 pièce d'or la première fois, puis 5, puis 10, et plus ensuite. Blizzard dit que le prix monte vite et baisse une fois par semaine.
- **Seconde spécialisation des talents :** dès le niveau 40, ton maître de classe vend un deuxième jeu de talents. Dans le jeu, ça s'appelle **Talents secondaires**. Les joueurs disent que ça coûte 50 pièces d'or ; Blizzard n'a pas donné de prix.
- **Passer** d'un jeu à l'autre prend 5 secondes et ne marche pas en combat.
- **Pourquoi :** tu montes de niveau avec un jeu, et tu tankes ou tu soignes avec l'autre. Un Paladin monte en Vindicte et tanke en Protection, un Druide monte en félin et soigne en Restauration.]] },
	},
	-- 21 Nov 2026: "Level as X, tank as Y" (mh-writer, from ForeverHowToPlay.lua PLANS). Names measured DB2 frFR
	-- 1.60.1.71037 (SpellName, TalentTab, Map, GlobalStrings); Aconit and Archibald from Wowhead Forever frFR.
	PLANS = {
		PALADIN = { title = "Monter en Vindicte, tanker en Protection", body = [[
- **Monter de niveau :** les guides disent que Vindicte est le moyen le plus rapide de monter seul : une **arme à deux mains** lente et Sceau de piété, plus tard Sceau d'autorité (20, un talent). Dépense tes points de talent en Vindicte.
- **Tanker un donjon** marche dès ton premier, sans changer de talents : Gouffre de Ragefeu pour la Horde (dès le niveau 13), la salle des Thanes pour l'Alliance (vers 13). Fureur vertueuse et Sceau de fureur arrivent tous les deux au 10. Garde une **arme à une main et un bouclier dans tes sacs**. Avant le donjon : équipe-les, active Fureur vertueuse (bloc D) et Sceau de fureur (**F**). Après : reprends l'arme à deux mains, et coupe Fureur vertueuse (clic droit dessus, en haut à droite). Avec Fureur vertueuse active, tu éloignes les ennemis de ton groupe.
- **Quand ça devient facile :** au 30 avec Bouclier sacré (un talent Protection), et vraiment au 40 avec Serment du bouclier. Pour ça, il te faut des talents Protection : la **seconde spécialisation des talents** (dès 40) te donne un deuxième jeu, pour monter en Vindicte et tanker en Protection. Voir « Talents : réinitialiser et seconde spécialisation » plus bas.
- **Caractéristiques pour tanker :** d'abord Endurance. Les guides ne sont pas d'accord sur la suite : wowforeverbuilder dit Défense, Endurance, Puissance des sorts, Intelligence (pas de Force), un autre guide met Puissance des sorts et Intelligence au-dessus de Force. Avec la Puissance des sorts, Consécration et Bouclier sacré retiennent mieux les ennemis.
- **Épée à deux mains d'Aconit** (la quête de classe Mort-vivant du 20) : apprends d'abord Epées à deux mains, auprès d'Archibald à Fossoyeuse. MH te le dit dans Fais ça maintenant.]] },
		WARRIOR = { title = "Monter de niveau et tanker en Guerrier", body = [[
- **Monter de niveau :** les guides ne sont pas d'accord. La plupart disent que Protection monte le plus vite : une arme à deux mains jusqu'à Vengeance au 14, puis une **arme à une main et un bouclier**. Un guide trouve Protection plus lente en solo. Armes ou Fureur marchent aussi ; garde alors une arme à une main et un bouclier dans tes sacs pour tanker.
- **Tanker un donjon** marche dès ton premier : Gouffre de Ragefeu (Horde) dès le niveau 13, la salle des Thanes (Alliance) vers 13, les Mortemines dès 16, les Cavernes des Lamentations dès 17. La quête de classe du 10 te donne Posture défensive, Provocation et Fracasser armure. Dans Forever, Posture défensive crée beaucoup plus de menace que dans l'ancien jeu, donc les ennemis restent sur toi.
- **Quand ça devient facile :** au 14-16 avec Vengeance et Maîtrise du blocage, et vraiment au 40 avec Heurt de bouclier (un talent) et Armure en plaques.
- **Talents :** avec des talents Protection, tu montes et tu tankes avec un seul jeu. Tu as monté en Armes ou en Fureur ? Alors la **seconde spécialisation des talents** (dès 40) te donne un deuxième jeu pour tanker. Voir « Talents : réinitialiser et seconde spécialisation » plus bas.
- **Caractéristiques pour tanker :** d'abord Endurance. Les guides ne sont pas d'accord sur le reste : l'un met Défense en dernier, un autre veut Défense à 440 tôt. Pour la menace : Toucher et Expertise.]] },
		DRUID = { title = "Monter de niveau et tanker en Druide", body = [[
- **Monter de niveau :** les guides choisissent Combat farouche : l'ours dès le niveau 10, le félin dès 20. Les talents Combat farouche servent aux deux, donc tu montes en félin et tu tankes en ours avec les mêmes talents. Il ne te faut ni bouclier ni deuxième arme.
- **Ton arme compte en forme.** Blizzard : en Forme d’ours et en Forme de félin, tes coups normaux font les dégâts de l'arme que tu tiens. Garde donc le meilleur bâton ou la meilleure masse à deux mains, aussi pour tanker.
- **Tanker un donjon** marche dès ton premier : Gouffre de Ragefeu pour la Horde (dès le niveau 13), la salle des Thanes pour l'Alliance (vers 13). Forme d’ours vient de la quête de classe du 10, avec Grondement et Mutiler (un guide dit seulement Mutiler : vérifie tes sorts). Dans Forever, Forme d’ours crée beaucoup plus de menace que dans l'ancien jeu.
- **Quand ça devient facile :** Balayage au 16 (plus d'ennemis à la fois), Lacérer au 25 (un talent), et vraiment au 40 avec Forme d’ours redoutable et Morsure primordiale (un talent).
- **Soigner en groupe ?** Il te faut des talents Restauration et de l'équipement avec de l'Intelligence : la **seconde spécialisation des talents** (dès 40) te donne un deuxième jeu. Voir « Talents : réinitialiser et seconde spécialisation » plus bas.
- **Caractéristiques pour tanker :** les guides ne sont pas d'accord. Pour survivre : Armure, puis Défense jusqu'à 440, puis Endurance, puis Agilité. Pour la menace : dégâts de l'arme, puis Agilité, puis Force. Un autre guide dit dégâts de l'arme, Force, Agilité pendant que tu montes.]] },
	},
	DRUID = {
		{ "Ce qu'il fait", [[
Le Druide peut changer de forme. Sous sa forme normale, il lance des sorts et soigne. Plus tard, il peut se transformer en ours ou en félin, pour se battre au corps à corps. L'ours a une provocation (Grondement) : c'est donc la forme pour tanker.
Une **forme** est l'une de ces apparences. Dans une forme, beaucoup de tes touches font autre chose. Les touches de MH changent toutes seules : la même touche est un sort sous ta forme normale et un autre sort en ours.]] },
		{ "Niveaux 1-10 : tes boutons", [[
- **1** = Colère (niveau 1) : ton principal sort d'attaque.
- **2** = Eclat lunaire (4) : des dégâts, puis encore des dégâts pendant quelques secondes.
- **C** = Toucher guérisseur (1) : ton gros soin.
- **F4** = Récupération (4) : un soin qui te soigne petit à petit.
- **Shift-X** = Marque du fauve (1) : un buff. Un **buff** est un effet positif sur toi ou sur un ami. Mets-le avant un combat.
- **Shift-Z** = Epines (6) : un autre buff.
- **V** = Sarments (8) : immobilise un ennemi sur place.
- **X** = Emprise de la nature (10).
- **Shift-E** = ton sort racial (Camouflage dans l'ombre pour un Elfe de la nuit, Choc martial pour un Tauren).
- **Niveau 10, Forme d’ours** (via une quête) : **Ctrl-1** te transforme en ours. En ours : **1** = Mutiler, **F** = Grondement, **Shift-2** = Rugissement démoralisant.]] },
		{ "Ordre simple (forme normale)", [[
D'abord Eclat lunaire (2), puis Colère (1) jusqu'à ce que l'ennemi soit mort. Peu de vie ? Récupération (F4) ou Toucher guérisseur (C).]] },
		{ "Ce qui vient plus tard", [[
- 12 : Rétablissement sur F2 (soin rapide). Ressusciter sur F3 : ramène un ami mort, seulement hors combat.
- 16 : Forme aquatique (via une quête) sur R quand tu nages. 18 : Lucioles sur 5 (marche dans la plupart des formes, mais pas en Forme de voyage ni en Forme aquatique), Hibernation sur Shift-Q.
- 20 : Forme de félin (via une quête) sur Ctrl-2, avec Griffe, Lambeau, Déchirure et Rôder. Charge farouche sur E (un talent, au plus tôt au niveau 20). Feu stellaire sur 3. En combat, F3 devient Renaissance.
- 30 : Forme de voyage sur R (pour te déplacer), Tranquillité sur Q. 40 : Forme d’ours redoutable (remplace Forme d’ours sur Ctrl-1), Innervation sur F1.
- 44 : Ecorce sur Z, dans toutes les formes.]] },
		{ "Erreurs de débutant", [[
- Appuyer sur un soin alors que tu es dans une forme. Tes soins ne marchent que sous ta forme normale, pas en Forme d’ours, Forme de félin, Forme aquatique ou Forme de voyage. Quitte d'abord la forme : appuie encore une fois sur la même touche de forme (Ctrl-1 pour l'ours, Ctrl-2 pour le félin).
- En Forme de sélénien (un talent, au plus tôt au niveau 40), tes sorts d'attaque marchent, mais pas tes soins.
- Ce qui marche dans une forme : les potions, Ecorce, Emprise de la nature, Lucioles et ton sort racial.]] },
	},
	PALADIN = {
		{ "Ce qu'il fait", [[
Le Paladin est un combattant sacré. Il frappe au corps à corps, se soigne lui-même et soigne les autres, et protège ses amis. Il n'a ni formes ni postures, donc chaque touche fait toujours la même chose.
Un **sceau** est un pouvoir sacré que tu poses sur toi. Il dure 30 secondes, et tu ne peux en avoir qu'un à la fois. Une **aura** est un pouvoir que tu actives et que tu laisses actif ; elle aide tout ton groupe. Une **bénédiction** est un buff que tu poses sur toi ou sur un ami ; elle dure 60 minutes. Un **buff** est un effet positif.]] },
		{ "Sceaux et auras", [[
- **Sceau de piété** (1) : chaque coup inflige des dégâts sacrés en plus. Une arme lente en inflige plus par coup.
- **Sceau du Croisé** (6, sur ta propre touche Alt) : tu frappes plus vite, mais chaque coup fait moins de dégâts.
- **Sceau de fureur** (10) : le sceau du tank. Avec un bouclier, chaque coup te donne aussi un petit bouclier.
- **Sceau d'autorité** (talent, au plus tôt au niveau 20) : tes coups font parfois un gros coup sacré en plus. Dès que tu l'as, la touche 3 lance celui-ci au lieu de Sceau de piété.
- **Sceau de justice** (22), **Sceau de lumière** (30), **Sceau de sagesse** (38), tous sur tes propres touches Alt : tes coups peuvent parfois étourdir, te soigner ou te rendre du mana.
- **Aura de dévotion** (1) : plus d'armure pour ton groupe. **Aura de vindicte** (16) : des dégâts sacrés à tout ce qui frappe ton groupe. **Aura de concentration** (22) : les lanceurs de sorts de ton groupe sont moins souvent interrompus quand ils sont frappés.]] },
		{ "Niveaux 1-10 : tes boutons", [[
- **3** = Sceau de piété (niveau 1) : ton sceau.
- **C** = Lumière sacrée (1) : ton gros soin. Les Paladins Mort-vivant l'obtiennent avec la quête de niveau 2 « Redécouverte de la Lumière ».
- **Ctrl-1** = Aura de dévotion (1, chez le maître de classe) : active-la et laisse-la active.
- **2** = Jugement (4) : cooldown de 10 secondes. Il ne consomme pas ton sceau. Il ne marche que si un sceau est actif : mets d'abord ton sceau (3).
- **Shift-Z** = Bénédiction de puissance (4) : mets-la sur toi.
- **1** = Frappe sacrée (6) : ton coup principal, au corps à corps.
- **Z** = Protection divine (6) : pendant 6 secondes, rien ne peut te blesser, mais tu ne peux pas attaquer non plus. Cooldown de 5 minutes.
- **E** = Marteau de la justice (8) : étourdit l'ennemi. Un **étourdissement** veut dire que l'ennemi ne peut ni bouger ni lancer de sort pendant quelques secondes. Le Paladin n'a pas de vraie interruption, donc c'est ta touche « arrête ce sort ».
- **Shift-C** = Purification (8) : retire un effet négatif d'un ami.
- **Q** = Imposition des mains (10) : ton bouton d'urgence. Il rend toute sa vie à un ami (ou à toi), mais consomme tout le mana qu'il te reste. Cooldown de 20 minutes.
- **Shift-F** = Bénédiction de protection (10) : sauve un ami en difficulté.
- **F** = Sceau de fureur (10) : un sceau pour tanker. Son Jugement provoque. **Provocation** = forcer l'ennemi à t'attaquer.]] },
		{ "Ordre simple", [[
Sceau (3) avant le combat. Ensuite Frappe sacrée (1) et Jugement (2) dès qu'ils sont prêts. Remets le sceau quand il s'arrête (il dure 30 secondes). Peu de vie ? Lumière sacrée (C).]] },
		{ "Ce qui vient plus tard", [[
- 12 : Rédemption (via une quête) sur F3 (ramène un ami mort ; pas en combat). 14 : Bénédiction de sagesse sur Shift-V.
- 18 : Bénédiction de liberté sur R (rien ne peut te ralentir pendant un moment). 20 : Consécration sur Shift-1 (frappe plusieurs ennemis à la fois), Exorcisme sur 5, Eclair lumineux sur F2 (soin rapide), Bénédiction des rois sur Shift-X.
- 30 : Intervention divine : en combat, F3 lance celle-ci au lieu de Rédemption. Attention : tu meurs toi-même ; l'ami que tu choisis est à l'abri de toutes les attaques pendant un court moment. 34 : Bouclier divin sur Z : 10 secondes pendant lesquelles rien ne peut te blesser, et tu peux quand même te battre (avec la moitié des dégâts).
- 42 : Epuration remplace Purification sur Shift-C. 44 : Marteau de courroux sur 4 (seulement quand l'ennemi a 20 % de vie ou moins).
- 52-60 : en groupe, les touches de bénédiction lancent la version supérieure pour tout le groupe ; en solo, elles lancent la normale.]] },
		{ "Erreurs de débutant", [[
- Appuyer sur Exorcisme (5) contre un ennemi normal. Il ne marche que sur les ennemis de type Mort-vivant et Démon. Renvoi des morts-vivants (Shift-Q, 24) ne marche que sur le type Mort-vivant.
- Appuyer sur Marteau de courroux (4) tôt dans le combat. Il ne marche que quand l'ennemi est presque mort (20 % de vie ou moins).
- Bouclier divin et Protection divine partagent un même cooldown, donc ils sont sur une seule touche (Z). Ces sorts de protection, Bénédiction de protection et Rempart de templier donnent **Longanimité** : pendant 1 minute, tu ne peux plus en recevoir aucun. Imposition des mains n'en donne pas.]] },
	},
	MAGE = {
		{ "Ce qu'il fait", [[
Le Mage reste à distance et lance de la magie de feu, de givre et des arcanes. Il tient les ennemis à l'écart avec des sorts qui les immobilisent ou les ralentissent. Le Mage n'a ni formes ni postures, donc chaque touche fait toujours la même chose.]] },
		{ "Niveaux 1-10 : tes boutons", [[
- **1** = Boule de feu (niveau 1) : ton principal sort d'attaque.
- **Shift-Z** = Armure de givre (1) : un buff sur toi. Mets-le avant un combat. Tu ne peux avoir qu'une seule armure à la fois.
- **Shift-X** = Intelligence des arcanes (1) : un buff pour toi ou pour un ami.
- **Ctrl-3** = Tir : ta **baguette** (un petit bâton magique qui tire tout seul), dès que tu en as une. Pratique quand ton mana est bas. Quand tu apprends Éclair de givrefeu, il prend Ctrl-3 ; mets Tir sur une de tes propres touches Alt si tu le veux encore.
- **2** = Eclair de givre (4) : des dégâts de givre.
- **5** = Trait de feu (6) : un coup de feu instantané. **Instantané** = pas de temps d'incantation. Cooldown de 8 secondes.
- **3** = Projectiles des arcanes (8) : des dégâts des arcanes.
- **Shift-Q** = Métamorphose (8) : met un ennemi hors du combat pendant un moment. Ce genre de sort s'appelle du **CC** (contrôle de foule).
- **V** = Nova de givre (10) : gèle chaque ennemi à 10 mètres autour de toi, jusqu'à 8 secondes. Les dégâts peuvent la briser. Cooldown de 25 secondes.
- Invocation d'eau (4) et Invocation de nourriture (6) ne sont pas sur le bloc. Elles vont sur tes propres touches Alt (bloc D).]] },
		{ "Ordre simple", [[
Eclair de givre (2) ou Boule de feu (1) pendant que l'ennemi approche. Trait de feu (5) quand il est prêt. L'ennemi est près de toi ? Nova de givre (V), recule, et continue à lancer tes sorts.]] },
		{ "Ce qui vient plus tard", [[
- 12 : Chute lente sur Shift-R. 14 : Explosion des arcanes sur Shift-2 (frappe plusieurs ennemis). 16 : Choc de flammes sur Shift-4.
- 18 : Délivrance de la malédiction mineure sur Shift-V. 20 : Transfert sur R (ton sort de déplacement), Blizzard sur Shift-1, Evocation sur F1 (te rend du mana), Bouclier de mana sur Z, Gardien de feu sur F4. Aussi les téléportations (et plus tard les portails) : des sorts de voyage, pas sur le bloc. Mets-les sur ta propre barre, ou lance-les depuis ton Grimoire.
- 22 : Brûlure sur Ctrl-1, Gardien de givre sur F2. 24 : Contresort sur E : ton **interruption** (elle arrête le sort d'un ennemi).
- 26 : Cône de froid sur Shift-F. 30 : Armure de glace : à partir de là, Shift-Z lance celle-ci au lieu d'Armure de givre (elle te protège aussi contre le givre).
- Talents à partir du niveau 20 : Explosion pyrotechnique sur 4, Javelot de glace sur F, Déflagration des arcanes sur Ctrl-2, Bloc de glace sur C (au plus tôt au niveau 25).]] },
		{ "Erreurs de débutant", [[
- Attendre les deux gardiens en même temps. Gardien de feu (F4) et Gardien de givre (F2) partagent un même cooldown de 30 secondes, donc un seul à la fois.
- Porter Armure du mage et Armure de glace ensemble. Une seule armure peut être active à la fois. Armure du mage (34) est sur le bloc D.]] },
	},
	HUNTER = {
		{ "Ce qu'il fait", [[
Le Chasseur tire de loin avec une arme à distance et, à partir du niveau 10, il a un **familier** : un animal que tu apprivoises et qui se bat à côté de toi. Au corps à corps, il a quelques coups.
**Tir automatique** = ton arme continue de tirer toute seule jusqu'à ce que tu arrêtes. **Corps à corps** = se battre de près. Le Chasseur n'a ni formes ni postures, donc chaque touche fait toujours la même chose.]] },
		{ "Niveaux 1-10 : tes boutons", [[
- **1** = Tir automatique (niveau 1) : commence à tirer. La touche de MH est faite pour qu'un second appui ne l'arrête pas.
- **5** = Attaque du raptor (1) : ton coup quand l'ennemi est juste à côté de toi.
- **2** = Morsure de serpent (4) : des dégâts pendant quelques secondes.
- Aspect du singe (4) va sur tes propres touches Alt (bloc D). Un **aspect** est un buff sur toi, un peu comme une posture. Un seul aspect peut être actif à la fois.
- **3** = Tir des arcanes (6) : un tir instantané. Cooldown de 6 secondes.
- **Shift-Z** = Marque du chasseur (6) : pose-la une fois sur l'ennemi.
- **Shift-Q** = Trait de choc (8) : ralentit l'ennemi.
- **Shift-R** = Aspect du faucon (10) : ton aspect principal.
- **Niveau 10, quêtes du familier :** tu apprends Apprivoise une bête, Appel du familier et Renvoyer le familier ; la quête suivante donne Ressusciter le familier et Nourrir le familier. **F4** = Appel du familier (fait venir ton familier), **F3** = Ressusciter le familier (ramène un familier mort). Apprivoise une bête n'a pas de touche ; tu l'utilises hors combat.
- Ensuite, ton familier a trois touches : **Ctrl-1** = attaquer ta cible, **Ctrl-2** = te suivre, **Ctrl-3** = rester où il est.]] },
		{ "Ordre simple", [[
Aspect du faucon actif (Shift-R). Le familier d'abord (Ctrl-1). Marque du chasseur (Shift-Z), Morsure de serpent (2), Tir automatique (1), puis Tir des arcanes (3) quand il est prêt. L'ennemi est à côté de toi ? Attaque du raptor (5).]] },
		{ "Ce qui vient plus tard", [[
- 10 : Nourrir le familier et Renvoyer le familier ne sont pas sur le bloc (tu les utilises hors combat) ; mets-les sur ta propre barre. Pareil pour Effrayer une bête (14).
- 12 : Trait provocateur sur F (pousse l'ennemi à t'attaquer), Guérison du familier sur F2 (soigne ton familier), Coupure d'ailes sur Shift-F.
- 16 : Piège d'Immolation sur Shift-2, Morsure de la mangouste sur Shift-C (seulement après une esquive de ta part). 18 : Flèches multiples sur Shift-1.
- 20 : Visée sur 4 (ton gros tir), Aspect du guépard sur R (pour courir vite), Désengagement sur Z, Piège givrant sur V.
- 26 : Tir rapide sur Q. 30 : Feindre la mort sur X, Aspect de la bête (bloc D). 34 : Piège explosif prend Shift-2.
- Les quatre pièges partagent un même cooldown de 30 secondes.]] },
		{ "Erreurs de débutant", [[
- Tirer sur un ennemi juste à côté de toi. Ton arme à feu ou ton arc ne marche pas à moins de 8 mètres (la « zone morte ») : utilise Attaque du raptor (5), ou recule.
- Croire qu'une seule touche peut tirer de loin et frapper de près. Une macro ne peut pas voir la distance, donc le corps à corps a ses propres touches (5, Shift-F, Shift-C).
- Appuyer sur Guérison du familier (F2) pour te soigner. Elle ne soigne que ton familier. Le Chasseur n'a pas de soin pour lui-même.]] },
	},
	WARRIOR = {
		{ "Ce qu'il fait", [[
Le Guerrier se bat au corps à corps avec une arme. Il a trois postures et, à partir du niveau 10, il peut tanker. Il ne se soigne pas lui-même, sauf avec Ivresse de la victoire (niveau 20).
Le Guerrier a de la **Rage** au lieu du mana. Tu gagnes de la Rage quand tu frappes et quand tu es frappé. Hors combat, ta Rage redescend lentement à 0.]] },
		{ "Postures", [[
Une **posture** est une façon de se battre que tu actives avec une touche. Tu es toujours dans une posture. Certains sorts ne marchent que dans une ou deux postures. Les touches de MH changent toutes seules : dans une autre posture, la même touche lance un autre sort. Si une touche n'a rien pour ta posture, elle ne fait rien (pas d'erreur).
- **Posture de combat** (1) : ta posture pour le combat normal.
- **Posture défensive** (10, via une quête) : la posture pour tanker. C'est seulement ici que tu as Provocation.
- **Posture berserker** (30, via la quête « La Dispute »). Ici, E devient Volée de coups et R devient Interception.
- **Maîtrise tactique** (14, passif, tu n'as rien à faire) : tu gardes jusqu'à 10 de Rage quand tu changes de posture.
- Aucune touche ne change ta posture toute seule. Tu choisis la posture ; les touches suivent.]] },
		{ "Niveaux 1-10 : tes boutons", [[
- **1** = Frappe héroïque (niveau 1) : ton coup principal, dans toutes les postures.
- **Ctrl-1** = Posture de combat (1) : active-la et laisse-la active.
- **Shift-X** = Cri de guerre (1) : un buff. Un **buff** est un effet positif sur toi ou sur un ami. Mets-le avant un combat.
- **R** = Charge (4) : cours vers un ennemi pour commencer un combat. Ne marche qu'en Posture de combat, et plus du tout une fois que tu es déjà en combat.
- **Shift-Z** = Pourfendre (4) : un **saignement** : des dégâts pendant quelques secondes. Posture de combat et Posture défensive.
- **Shift-1** = Coup de tonnerre (6) : frappe plusieurs ennemis à la fois. Posture de combat et Posture défensive. Cooldown de 6 secondes.
- **V** = Brise-genou (8) : ralentit beaucoup l'ennemi pendant 15 secondes. Posture de combat et Posture berserker.
- **F1** = Rage sanguinaire (10) : te donne de la Rage tout de suite, et encore un peu pendant quelques secondes. Elle coûte un peu de vie. Cooldown de 1 minute.
- **Niveau 10, Posture défensive** (via une quête) : **Ctrl-2** l'active. La même quête donne **5** = Fracasser armure (toutes les postures) et, en Posture défensive, **F** = Provocation. **Provocation** = forcer l'ennemi à t'attaquer. Cooldown de 8 secondes.
- Tir à l'arc, Tir avec une arme à feu, Tir à l’arbalète et Lancer vont sur tes propres touches Alt (bloc D). Tu reçois celui qui va avec ton arme à distance. Sers-t'en pour **attirer** : frappe un ennemi de loin, pour qu'il vienne vers toi.]] },
		{ "Ordre simple", [[
Posture de combat active (Ctrl-1), Cri de guerre (Shift-X). Charge (R) pour entrer. Pourfendre (Shift-Z), puis Frappe héroïque (1) encore et encore. Plusieurs ennemis ? Coup de tonnerre (Shift-1).]] },
		{ "Ce qui vient plus tard", [[
- 12 : Fulgurance sur 2 (Posture de combat ; après une esquive de l'ennemi), Coup de bouclier sur E : ton **interruption** (elle arrête le sort d'un ennemi).
- 14 : Vengeance sur 2 (Posture défensive), Cri démoralisant sur Shift-2. 16 : Coup railleur sur F (Posture de combat), Maîtrise du blocage sur Z (Posture défensive). 18 : Désarmement sur V (Posture défensive).
- 20 : Enchaînement sur Shift-4, Heurtoir sur Shift-C, Ivresse de la victoire sur F2 (seulement dans les 20 secondes après avoir tué un ennemi qui rapporte des PX ; elle te soigne un peu ; cooldown de 30 secondes), Représailles sur C (Posture de combat). 22 : Cri d’intimidation sur Shift-Q. 24 : Exécution sur 4 (Posture de combat et Posture berserker ; seulement quand l'ennemi a 20 % de vie ou moins).
- 26 : Cri de défi sur Shift-F. 28 : Mur protecteur sur C (Posture défensive).
- 30 : Posture berserker sur Ctrl-3. Dans cette posture : Interception sur R, Rage berserker sur Shift-V. 36 : Tourbillon sur 2 (berserker). 38 : Volée de coups sur E (berserker). 50 : Témérité sur Q (berserker).
- Talents : Dernier rempart sur X et Hurlement perçant sur Shift-R (un ralentissement de zone), au plus tôt au niveau 20. Frappe transperçante sur F3 (Posture de combat) et Frappes téméraires sur Shift-F1, 25. Attaques circulaires sur Q (Posture de combat), Souhait mortel sur Shift-3, Bourrasque sur Shift-V (un étourdissement ; en Posture berserker, cette touche est Rage berserker à la place), 30. Frappe mortelle, Sanguinaire ou Heurt de bouclier sur 3, 40.]] },
		{ "Erreurs de débutant", [[
- Appuyer sur une touche dans la mauvaise posture. Provocation ne marche qu'en Posture défensive, Fulgurance qu'en Posture de combat. Dans la mauvaise posture, la touche ne fait rien. Regarde d'abord ta posture.
- Charge en Posture défensive. Elle n'y marche qu'avec le talent **Avant-garde**. Sans lui, tu as une erreur rouge.
- Charge en combat. Charge sert seulement à commencer un combat ; une fois que tu te bats, elle ne marche pas.
- Coup de tonnerre (Shift-1) ne marche pas en Posture berserker.
- Coup de bouclier, Maîtrise du blocage et Heurt de bouclier sans bouclier. Les trois ont besoin d'un bouclier dans ta main gauche.
- Croire que Heurtoir est rapide. Dans Forever, il a 1,5 seconde d'incantation et un cooldown de 15 secondes.
- Représailles et Mur protecteur sont tous les deux sur C, chacun avec son propre cooldown de 15 minutes. Garde-les pour les vrais problèmes.]] },
	},
	ROGUE = {
		{ "Ce qu'il fait", [[
Le Voleur se bat au corps à corps avec des coups rapides. Il peut s'approcher des ennemis sans être vu, et il a beaucoup de moyens d'arrêter un ennemi pendant un moment.
Le Voleur a de l'**Énergie** au lieu du mana. L'Énergie se remplit toute seule, et vite : une barre vide est de nouveau pleine en 10 secondes environ.]] },
		{ "Camouflage et coups de grâce", [[
**Camouflage** (niveau 1, Shift-R) te rend difficile à voir. Tu avances à mi-vitesse. Certaines attaques ne marchent que depuis le Camouflage : ce sont tes **ouvertures**, le premier coup d'un combat. En Camouflage, les touches de MH changent toutes seules :
- **1** devient Garrot (14), **2** devient Embuscade (18), **V** devient Coup bas (26), **Shift-Q** devient Assommer (10), **F** devient Vol à la tire (4).
- Tant que tu ne connais pas le sort Camouflage, la touche garde simplement son sort normal.
Des coups comme Attaque pernicieuse te donnent des **points de combo** (jusqu'à 5). Un **coup de grâce** est un coup qui utilise tous tes points de combo : Eviscération (4), Débiter (Shift-4) et Rupture (5). Plus tu as de points, plus il est fort.]] },
		{ "Niveaux 1-10 : tes boutons", [[
- **1** = Attaque pernicieuse (niveau 1) : ton coup principal.
- **4** = Eviscération (1) : ton coup de grâce principal.
- **Shift-R** = Camouflage (1) : avance sans être vu. Appuie encore une fois pour sortir du Camouflage. Après être sorti du Camouflage, tu ne peux pas y retourner pendant 10 secondes.
- **Shift-2** = Lancer (1) : un lancer à distance. Il te faut une arme de jet (comme des couteaux de lancer) dans ton emplacement à distance. Avec une arme à feu, un arc ou une arbalète équipé, la touche tire avec celle-ci à la place.
- **2** = Attaque sournoise (4) : un coup puissant. Il te faut une dague, et tu dois être derrière l'ennemi.
- **F** = Vol à la tire (4) : seulement en Camouflage. Vole quelque chose à l'ennemi.
- **Shift-Q** = Suriner (6) : arrête un ennemi pendant un moment. Le moindre dégât le libère. Ce genre de sort s'appelle du **CC** (contrôle de foule).
- **Z** = Evasion (8) : tu esquives beaucoup plus d'attaques pendant 15 secondes. Cooldown de 5 minutes.
- **Shift-4** = Débiter (10) : ton deuxième coup de grâce.
- **R** = Sprint (10) : cours vite.
- **Shift-Q** = Assommer (10) : seulement en Camouflage. Met un ennemi de type Humanoïde hors jeu pendant un moment, avant que le combat commence. Ne marche pas sur les ennemis de type Bête ni sur les ennemis déjà en combat. Les dégâts le libèrent. Assommer ne brise pas ton Camouflage.
- **F4** = le soin sur la durée de ta race, si elle en a un : Cannibalisme (Mort-vivant ; seulement près d'un cadavre Humanoïde ou Mort-vivant), Régénération rapide (Troll ; s'arrête quand tu bouges, agis ou prends des dégâts), Lecture des lignes telluriques (Éolide de l’Ordre suprême).
- **Shift-E** = ton sort racial (par exemple Camouflage dans l'ombre pour un Elfe de la nuit, Fureur sanguinaire pour un Orc).]] },
		{ "Ordre simple", [[
Camouflage (Shift-R) et approche-toi de l'ennemi. Attaque pernicieuse (1) quelques fois, puis Eviscération (4). Avec une dague et derrière l'ennemi : Attaque sournoise (2). À partir du niveau 10 : garde Débiter (Shift-4) actif.]] },
		{ "Ce qui vient plus tard", [[
- 12 : Coup de pied sur E : ton **interruption** (elle arrête le sort d'un ennemi). 14 : Exposer l'armure sur Shift-Z, Garrot sur 1 en Camouflage.
- 16 : Feinte sur F (hors Camouflage). Elle baisse ta **menace** : à quel point l'ennemi veut t'attaquer. Crochetage (bloc D).
- 18 : Embuscade sur 2 en Camouflage (dague, par derrière). 20 : Rupture sur 5. Poisons (via une quête ; voir plus bas).
- 22 : Distraction sur Shift-F, Disparition sur X (ta fuite ; chaque utilisation coûte une Poudre éclipsante, un objet dans tes sacs). 24 : Surin sur Shift-3 (un coup avec ton arme de main gauche, donc il te faut une arme dans chaque main ; cooldown de 10 secondes ; te rend 15 d'Énergie).
- 26 : Coup bas sur V en Camouflage : un **étourdissement** (l'ennemi ne peut ni bouger ni agir pendant quelques secondes). 30 : Aiguillon perfide sur V hors Camouflage. Désarmement de piège (bloc D). 34 : Cécité sur Shift-V (coûte une Poudre aveuglante).
- Talents : Riposte sur Shift-F1 et Préméditation sur Shift-C, au plus tôt au niveau 20. Sang froid sur F1 et Frappe fantomatique sur Shift-X, 25. Déluge de lames sur Shift-1 (frappe plus d'ennemis), Préparation sur F3 (remet à zéro le cooldown de tes autres sorts de Voleur, comme Evasion, Sprint et Disparition), Hémorragie sur 3, 30. Estropier sur 3, Poussée d'adrénaline ou Marque de mort sur Q, 40.]] },
		{ "Erreurs de débutant", [[
- Appuyer sur une ouverture hors Camouflage. Garrot, Embuscade, Coup bas, Assommer et Vol à la tire ont besoin du Camouflage. Hors Camouflage, la même touche lance son sort normal.
- Appuyer encore sur Camouflage par accident. Ça met fin au Camouflage, et tu ne peux pas y retourner pendant 10 secondes.
- Elfe de la nuit : Camouflage dans l'ombre est ton sort racial, pas le Camouflage de ta classe. Pour tes ouvertures, utilise Camouflage (Shift-R).
- Attaque sournoise et Embuscade de face, ou sans dague. Les deux ont besoin d'une dague, et tu dois être derrière l'ennemi.
- Frapper un ennemi que tu as mis hors jeu avec Suriner ou Assommer. Le moindre dégât le réveille.
- Assommer sur un ennemi de type Bête ou sur un ennemi déjà en combat. Assommer ne marche que sur le type Humanoïde, avant le combat.
- Disparition ou Cécité sans poudre dans tes sacs. Disparition a besoin d'une Poudre éclipsante, Cécité d'une Poudre aveuglante.
- Chercher les poisons sur le bloc. Les **Poisons** sont des objets que tu fabriques (tu apprends Poisons via une quête vers le niveau 20). Tu les mets sur ton arme. Fais-les glisser toi-même sur tes propres touches Alt (bloc D).
- Frappe fantomatique (talent) : après elle, ta prochaine Embuscade ou ton prochain Garrot marche sans Camouflage, si tu l'utilises dans les 7 secondes. Les touches de MH ne peuvent pas le voir, donc hors Camouflage les touches 1 et 2 lancent toujours Attaque pernicieuse et Attaque sournoise.]] },
	},
	PRIEST = {
		{ "Ce qu'il fait", [[
Le Prêtre soigne, et frappe de loin avec de la magie sacrée et de la magie de l'ombre. Il protège ses amis avec un bouclier. Plus tard, il peut choisir **Forme d'Ombre** (un talent, au plus tôt au niveau 40) : plus de dégâts d'ombre, mais aucun soin.
Le Prêtre n'a pas de postures. Forme d'Ombre ne change pas les touches : chaque touche fait toujours la même chose.]] },
		{ "Les sorts propres à ta race", [[
Chaque race de Prêtre a deux sorts de Prêtre bien à elle : un au niveau 10 et un au niveau 20. Tu obtiens les deux via une quête, pas chez le maître de classe. MH les met sur **X** et **Shift-R**, donc chaque race utilise les deux mêmes touches.
- Nain : Prière du désespoir (10, X ; cooldown de 10 minutes), Châtiment (20, Shift-R).
- Humain : Grâce divine (10, Shift-R ; un soin instantané sur un ami à moins de la moitié de sa vie, pas sur toi ; cooldown de 10 minutes), Réaction (20, X).
- Elfe de la nuit : Eclats stellaires (10, Shift-R ; cooldown de 30 secondes), Grâce d'Elune (20, X).
- Mort-vivant : Toucher de faiblesse (10, X), Sombre sacrifice (20, Shift-R ; échange ta propre vie contre du mana).
- Troll : Maléfice de faiblesse (10, Shift-R), Garde de l'ombre (20, X).
- Gnome : Éclair déconcertant (10, Shift-R), Plan d’urgence (20, X ; une protection sur un ami qui le soigne et lui donne un bouclier quand sa vie tombe bas).]] },
		{ "Niveaux 1-10 : tes boutons", [[
- **1** = Châtiment (niveau 1) : ton principal sort d'attaque.
- **C** = Soins inférieurs (1) : ton soin principal. Plus tard, Soins (16) et Soins supérieurs (40) prennent cette touche.
- **5** = Tir (1) : ta **baguette** (un petit bâton magique qui tire tout seul). Il te faut une baguette en main.
- **Shift-X** = Mot de pouvoir : Robustesse (1) : un buff. Un **buff** est un effet positif sur toi ou sur un ami. Mets-le avant un combat.
- **2** = Mot de l'ombre : Douleur (4) : des dégâts d'ombre.
- **Z** = Mot de pouvoir : Bouclier (6) : un bouclier sur toi ou sur un ami. Cooldown de 4 secondes, mais la même personne ne peut recevoir un nouveau bouclier qu'après 15 secondes.
- **F** = Oubli (8) : les ennemis ont moins envie de t'attaquer pendant un moment. Cooldown de 30 secondes.
- **F4** = Rénovation (8) : un soin qui soigne petit à petit.
- **3** = Attaque mentale (10) : des dégâts d'ombre. Cooldown de 8 secondes.
- **F3** = Résurrection (10) : ramène un ami mort. Seulement hors combat.
- Ton sort racial de niveau 10 est sur **X** ou **Shift-R** (voir la liste plus haut).
- **Shift-E** = ta compétence raciale (par exemple Forme de pierre pour un Nain, Camouflage dans l'ombre pour un Elfe de la nuit).]] },
		{ "Ordre simple", [[
Bouclier (Z) sur toi. Mot de l'ombre : Douleur (2), Attaque mentale (3), puis Châtiment (1). Peu de mana ? Utilise ta baguette (5). Peu de vie ? Rénovation (F4) ou Soins inférieurs (C).]] },
		{ "Ce qui vient plus tard", [[
- 12 : Feu intérieur sur Shift-Z. 14 : Guérison des maladies sur Shift-C, Cri psychique sur V (quelques ennemis autour de toi s'enfuient de peur, jusqu'à 8 secondes ; les dégâts peuvent y mettre fin ; cooldown de 30 secondes).
- 18 : Dissipation de la magie sur Shift-V. 20 : Soins rapides sur F2 (soin rapide), Flammes sacrées sur 4, Entraves des morts-vivants sur Shift-Q, Peste dévorante sur Shift-3, ton sort racial de niveau 20, Gardien de peur (bloc D).
- 30 : Prière de soins sur Shift-2 (soigne ton groupe), Contrôle mental sur Shift-F. 32 : Mot de l’ombre : Mort sur Shift-4, Abolir maladie prend Shift-C. 34 : Lévitation sur R (coûte une Plume légère). 48 : Prière de robustesse prend Shift-X (coûte une Bougie sanctifiée).
- Talents : Fouet mental (prend la touche 1), Nova sacrée sur Shift-1 et Focalisation améliorée sur F1, au plus tôt au niveau 20. Etreinte vampirique sur Ctrl-3, 25. Pénitence sur Shift-F1 et Silence sur E (ton **interruption** : elle arrête le sort d'un ennemi), 30. Infusion de puissance sur Q, Forme d'Ombre sur Ctrl-1, Prière de guérison sur Ctrl-2, 40.]] },
		{ "Erreurs de débutant", [[
- Soigner en Forme d'Ombre. Aucun sort de soin ne marche en Forme d'Ombre. Gardien de peur n'y marche pas non plus. Quitte-la d'abord : appuie encore sur Ctrl-1.
- Ne plus trouver Châtiment après avoir pris Fouet mental. Dès que tu connais Fouet mental, la touche 1 lance Fouet mental, pas Châtiment.
- Appuyer sur Tir (5) sans baguette. Achètes-en une ou trouves-en une d'abord.
- Chercher une interruption sur E au début. Le Prêtre n'en a une qu'avec le talent Silence (au plus tôt au niveau 30).
- Entraves des morts-vivants (Shift-Q) sur un ennemi normal. Ne marche que sur les ennemis de type Mort-vivant.]] },
	},
	SHAMAN = {
		{ "Ce qu'il fait", [[
Le Chaman lance la foudre et le feu, soigne et pose des totems. Il peut se battre de loin, ou au corps à corps avec une arme. Dans Forever, les Nains (Alliance) peuvent aussi être Chaman.
Le Chaman n'a pas de postures. **Loup fantôme** (niveau 20, sur R) est une forme pour courir, mais elle ne change pas tes touches.]] },
		{ "Totems et buffs d'arme", [[
Un **totem** est un petit objet que tu poses au sol. Tant qu'il reste debout, il t'aide, toi ou ton groupe, ou il blesse les ennemis. Les totems appartiennent à quatre éléments : Terre, Feu, Eau et Air. Tu peux avoir un totem de chaque élément à la fois. Un nouveau remplace l'ancien.
- Chaque élément a un objet totem que tu reçois avec une quête de classe : Totem de terre (niveau 4, ou 3 pour un éolide), Totem de feu (10), Totem d'eau (20), Totem d'air (30). Il te faut cet objet dans tes sacs pour tous les totems de cet élément.
- Avant le niveau 20, tes totems ont chacun leur propre touche : Totem de Peau de pierre (Z), Totem de lien terrestre (V), Totem de Griffes de pierre (F), Totem de Force de la Terre (Shift-X), Totem incendiaire (5), Totem de Séisme (Shift-F).
- À partir du niveau 20, le jeu te donne une **Barre de totems**. Dessus, tu choisis un totem par élément. Ensuite, une seule touche les pose tous : **Ctrl-1** = Appel des éléments (20), **Ctrl-2** = Appel des ancêtres (30), **Ctrl-3** = Appel des esprits (40). Chacun pose jusqu'à 4 totems depuis sa propre page de la Barre de totems. Il a 3 secondes d'incantation et coûte le mana de tous les totems qu'il pose.
- **Shift-R** = Appel totémique (22) : déplace tes totems jusqu'à toi. Rappel totémique (20, bloc D) les reprend et te rend un quart de leur mana.
Un **buff d'arme** donne de la puissance à ton arme pendant 60 minutes. Tu en as un à la fois. Arme Croque-roc (1), Arme Langue de feu (10), Arme de givre (20) et Arme Furie-des-vents (30) vont sur tes propres touches Alt (bloc D). Choisis celui qui va avec ta façon de jouer.]] },
		{ "Niveaux 1-10 : tes boutons", [[
- **1** = Eclair (niveau 1) : ton principal sort d'attaque.
- **C** = Vague de soins (1) : ton gros soin.
- Arme Croque-roc (1) va sur le bloc D (voir plus haut).
- **E** = Horion de terre (4) : ton **interruption** (elle arrête le sort d'un ennemi), et des dégâts.
- **Z** = Totem de Peau de pierre (4, via une quête) : tu subis moins de dégâts des coups au corps à corps. **Corps à corps** = se battre de près.
- **V** = Totem de lien terrestre (6) : ralentit les ennemis près de lui. Cooldown de 15 secondes.
- **F** = Totem de Griffes de pierre (8) : force les ennemis autour de lui à attaquer le totem. Cooldown de 30 secondes.
- **Shift-Z** = Bouclier de foudre (8) : un bouclier sur toi. Un seul bouclier à la fois.
- **2** = Horion de flammes (10) : des dégâts de feu, puis encore des dégâts pendant quelques secondes.
- **5** = Totem incendiaire (10, via une quête) : ton totem de dégâts.
- **Shift-X** = Totem de Force de la Terre (10) : un totem qui donne un buff à ton groupe. Un **buff** est un effet positif.
- Arme Langue de feu (10) va sur le bloc D.
- **Shift-E** = ton sort racial (par exemple Choc martial pour un Tauren, Forme de pierre pour un Nain).]] },
		{ "Ordre simple", [[
Buff d'arme actif (bloc D), Bouclier de foudre actif (Shift-Z). Pose le Totem incendiaire (5). Horion de flammes (2), puis Eclair (1). Garde Horion de terre (E) pour le moment où l'ennemi lance un sort. Peu de vie ? Vague de soins (C).]] },
		{ "Ce qui vient plus tard", [[
- 12 : Nova de feu sur Shift-4, Expiation sur Shift-Q (retire la magie d'un ennemi), Esprit ancestral sur F3 (ramène un ami mort). 16 : Guérison du poison sur Shift-C. 18 : Totem de Séisme sur Shift-F (retire la peur, le charme et le sommeil de ton groupe).
- 20 : Loup fantôme sur R (3 secondes d'incantation, seulement en extérieur), Horion de givre sur 4 (ralentit), Vague de soins inférieurs sur F2 (soin rapide), Totem guérisseur sur F4 (via une quête ; soigne ton groupe petit à petit ; demande le Totem d'eau), Appel des éléments sur Ctrl-1.
- 22 : Guérison des maladies sur Shift-V, Appel totémique sur Shift-R. 30 : Totem de Glèbe sur X (attrape un sort nuisible visé sur toi ou sur un membre du groupe proche ; pas les sorts de zone ; demande le Totem d'air de la quête de niveau 30), Appel des ancêtres sur Ctrl-2. 32 : Chaîne d'éclairs sur Shift-1 (frappe plusieurs ennemis).
- 40 : Salve de guérison sur Shift-2 (soigne plusieurs amis), Appel des esprits sur Ctrl-3.
- Talents : Bouclier d’eau (prend Shift-Z), au plus tôt au niveau 20. Courroux naturel sur 3 et Totem de Vague de mana sur F1 (à partir du Rang 4 : Totem de vague de mana), 25. Rapidité de la nature sur Shift-3, 30. Remous sur Shift-F1, et Maîtrise de la foudre ou Rage long-voyante sur Q, 40.]] },
		{ "Erreurs de débutant", [[
- Utiliser un horion juste avant de devoir interrompre. Horion de terre (E), Horion de flammes (2) et Horion de givre (4) partagent un même cooldown de 6 secondes. Après Horion de flammes, tu n'as plus d'interruption pendant 6 secondes au plus.
- Appuyer sur Nova de feu (Shift-4) sans totem de Feu posé. Elle a besoin d'un de tes totems de Feu (comme Totem incendiaire ou Totem de Magma). Elle frappe les ennemis près de ce totem, pas ceux près de toi.
- Poser un totem sans son objet totem. Chaque élément a besoin de son propre objet totem dans tes sacs, reçu avec une quête de classe.
- Lancer des sorts en Loup fantôme. Tes sorts ne sont pas faits pour le loup. Quitte d'abord Loup fantôme, puis lance tes sorts.
- Oublier le buff d'arme. Il dure 60 minutes et il n'est pas sur le bloc : il est sur tes propres touches Alt (bloc D).
- Attendre deux boucliers. Dès que tu as Bouclier d’eau, Shift-Z lance celui-ci, pas Bouclier de foudre.]] },
	},
	WARLOCK = {
		{ "Ce qu'il fait", [[
Le Démoniste reste à distance et lance de la magie de l'ombre et de feu. Une grande partie de ses dégâts arrive lentement : des sorts qui blessent l'ennemi sur la durée, et des malédictions. Il a presque toujours un démon avec lui.
Un **DoT** (dégâts sur la durée) est un sort qui blesse l'ennemi petit à petit pendant un moment. Une **malédiction** ou une **plaie** est un effet négatif que tu poses sur un ennemi. Une malédiction et une plaie peuvent être sur le même ennemi. Le Démoniste n'a ni formes ni postures, donc chaque touche fait toujours la même chose.]] },
		{ "Ton démon", [[
Ton **familier** est un démon que tu invoques. Il se bat à côté de toi. Tu apprends les démons avec des quêtes de classe.
- **Invocation d'un diablotin** (1) : via ta première quête de classe dans ta zone de départ. Le nom dépend de ta race : Humain « Le Tome dérobé », Gnome « Les débuts », Orc et Troll « Les vils quasits », Mort-vivant « Lever le voile ». Le Diablotin ne coûte pas de Fragment d'âme.
- **Invocation d'un marcheur du Vide** (10, quête). **Invocation d'une succube** ou **Invocation d’incube** (20, quête). **Invocation d'un chasseur corrompu** (30, quête). Chacun coûte 1 **Fragment d'âme** (voir Siphon d'âme plus bas).
- **Inferno** (50) est sur **F3**. Chaque lancement demande une Pierre infernale. Cooldown de 1 heure.
- Les invocations ne sont pas sur le bloc. Elles vont sur tes propres touches Alt (bloc D).
- Dès ton premier démon, ton familier a trois touches : **Ctrl-1** = attaquer ta cible, **Ctrl-2** = te suivre, **Ctrl-3** = rester où il est.
- Le Marcheur du Vide peut provoquer (Tourment). Le Chasseur corrompu peut arrêter le sort d'un ennemi (Verrou magique, à partir du niveau 36). Ce sont les sorts propres à ton démon, sur la Barre du familier de Blizzard.]] },
		{ "Niveaux 1-10 : tes boutons", [[
- **1** = Trait de l'ombre (niveau 1) : ton principal sort d'attaque.
- **3** = Immolation (1) : des dégâts de feu, puis encore des dégâts sur la durée.
- **Shift-Z** = Peau de démon (1) : un buff sur toi (plus d'armure). Un **buff** est un effet positif. À partir du niveau 20, Armure démoniaque prend cette touche.
- **2** = Corruption (4) : un DoT.
- **Shift-V** = Malédiction de faiblesse (4) : ta malédiction. À partir du niveau 20, Malédiction des éléments prend cette touche.
- **F** = Connexion (6) : transforme une partie de ta vie en mana.
- **5** = Plaie d'agonie (8 ; à partir du Rang 2 : Plaie d’agonie) : ta plaie, un DoT.
- **V** = Peur (8) : ta touche de **CC**. CC (contrôle de foule) = un sort qui met un ennemi hors du combat pendant un moment.
- **4** = Siphon d'âme (10) : utilise-le pour achever un ennemi qui rapporte des PX, et tu reçois un **Fragment d'âme**. Un Fragment d'âme est un petit objet dans tes sacs. Il t'en faut un pour invoquer la plupart des démons (tous sauf le Diablotin) et pour créer une Pierre de soins ou une Pierre d'âme. Les ennemis gris (trop faciles) ne donnent pas de fragment.
- Création de Pierre de soins (10, coûte un Fragment d'âme) va sur le bloc D. Ta Pierre de soins est ensuite sur **Shift-T**, comme pour chaque classe.
- **Shift-E** = ton sort racial (par exemple Fureur sanguinaire pour un Orc, Volonté des Réprouvés pour un Mort-vivant).]] },
		{ "Ordre simple", [[
Sors ton démon (bloc D ; tous sauf le Diablotin demandent un Fragment d'âme), puis envoie-le (Ctrl-1). Corruption (2), Plaie d'agonie (5), Immolation (3), puis Trait de l'ombre (1). Peu de mana ? Connexion (F). Peu de vie ? Drain de vie (C, à partir du niveau 14).]] },
		{ "Ce qui vient plus tard", [[
- 12 : Captation de vie sur F2 (soigne ton démon). 14 : Drain de vie sur C (ton propre gros soin).
- 16 : Respiration interminable sur Shift-R. 18 : Douleur brûlante (bloc D), et Création de pierre d'âme (au Rang 3 seulement : Création de Pierre d'âme ; coûte un Fragment d'âme ; pas sur le bloc, mets-la toi-même sur ta propre barre).
- Malédiction des langages et Rituel d'invocation (fait venir un membre du groupe jusqu'à toi) servent rarement : ils ne sont pas sur le bloc non plus. Mets-les sur ta propre barre si tu les veux.
- 20 : Pluie de feu sur Shift-1 (frappe plusieurs ennemis), Armure démoniaque sur Shift-Z, Malédiction des éléments sur Shift-V.
- 28 : Bannir sur Shift-Q. 30 : Flammes infernales sur Shift-2. 32 : Gardien de l'ombre sur Z (absorbe des dégâts d'ombre ; cooldown de 30 secondes).
- 40 : Hurlement de terreur sur Shift-F (fait fuir de peur plusieurs ennemis). 42 : Voile mortel sur X (une horreur, comme la peur, et un soin ; cooldown de 2 minutes).
- 48 : Feu de l'âme sur Q (ton plus gros coup ; coûte un Fragment d'âme ; 6 secondes d'incantation ; cooldown de 1 minute). 50 : Inferno sur F3. 60 : Plaie funeste sur F1.
- Talents : Brûlure de l'ombre sur Shift-4 (coûte un Fragment d'âme), Malédiction amplifiée sur Shift-3, Sacrifice démoniaque sur Shift-C, au plus tôt au niveau 20. Malédiction de fatigue sur R (ralentit l'ennemi, pour que tu puisses rester loin de lui), Domination corrompue sur Shift-F1 (invoque un démon vite), 25. Siphon de vie sur F4 (un DoT qui te soigne), Lien spirituel sur Shift-X, 30. Conflagration (25), Plaie de tumulte (30), Calvaire (40) et Incinérer (40), tous au plus tôt, vont sur le bloc D.]] },
		{ "Erreurs de débutant", [[
- Invoquer un démon sans Fragment d'âme. Tous les démons sauf le Diablotin en coûtent un. Utilise Siphon d'âme (4) pour achever les ennemis qui rapportent des PX.
- Chercher une interruption sur E. Le Démoniste n'en a pas à lui, donc E reste vide. Seul le Chasseur corrompu en a une.
- Appuyer sur Captation de vie (F2) pour te soigner. Elle soigne ton démon. Ton propre soin, c'est Drain de vie (C).
- Bannir (Shift-Q) sur un ennemi normal. Ne marche que sur les ennemis de type Démon et Elémentaire.
- Plaie funeste (F1) sur un joueur. Elle ne peut pas être lancée sur des joueurs.
- Ne plus trouver ta baguette. Tir n'est pas sur le bloc. Fais-le glisser toi-même de ton Grimoire vers ta propre barre.]] },
	},
	-- Par rôle (16 Nov 2026, mh-writer), same shape as ROLES in Modules/ForeverHowToPlay.lua: same band, same order.
	-- Spell names: SpellName frFR, wowf 1.60.1.70938. Tree names: ForeverMacros.lua SPEC_NAMES.
	ROLES = {
		DRUID = {
			{ band = 2, title = "Ours : tank", body = [[
Dès le niveau 10 (Forme d’ours, via une quête). Le **tank**, c'est celui que les ennemis frappent, pour que le reste du groupe reste à l'abri. Pour monter de niveau, les guides trouvent le félin plus agréable ; l'ours est pratique de 10 à 20, et pour tanker en donjon. L'ours utilise la **Rage** : tu en gagnes quand tu frappes et quand on te frappe.
**Ordre simple :**
1. Attire avec Lucioles (**5**, dès 18) ou Charge farouche (**E**, dès 20). **Attirer** = frapper un ennemi de loin, pour qu'il vienne vers toi.
2. Rugissement démoralisant (**Shift-2**) une fois.
3. Morsure primordiale (**3**, dès 40) dès qu'elle est prête.
4. Lacérer (**2**, dès 25) jusqu'à 5 cumuls.
5. Rage en trop : Mutiler (**1**) sur un ennemi, Balayage (**Shift-1**, dès 16) sur deux ennemis ou plus.
6. Grondement (**F**) quand un ennemi frappe quelqu'un d'autre.
**Tous les 10 niveaux :**
- 10 : Forme d’ours (**Ctrl-1**), Mutiler (**1**), Grondement (**F**), Rugissement démoralisant (**Shift-2**). Puis Enrager (**Q**) au niveau 12, Sonner (**V**) au 14, Balayage (**Shift-1**) au 16, Lucioles (**5**) au 18.
- 20 : Charge farouche (**E**, un talent) : tu charges l'ennemi, il ne peut ni bouger ni lancer de sort pendant 4 secondes. Cooldown 15 secondes. Les niveaux de talent indiqués ici sont les plus tôt possibles ; un avantage peut les avancer jusqu'à 5 niveaux.
- 30 : Chef de la meute (un talent). Avant ça : Lacérer (**2**, un talent) au 25, Rugissement provocateur (**Shift-F**) au 28.
- 40 : Forme d’ours redoutable remplace Forme d’ours sur **Ctrl-1**. Morsure primordiale (**3**, un talent). Avant ça : Régénération frénétique (**X**) au 36 : transforme la Rage en vie.
- 50 : rangs plus forts de Morsure primordiale, Lacérer et Mutiler. Ecorce (**Z**) au 44.
- 60 : encore des rangs plus forts ; rien de nouveau pour ce rôle.
**Erreurs de débutant :**
- Charge farouche quand l'ennemi est à moins de 8 mètres. Elle ne marche pas à cette distance.
- Enrager (**Q**) pendant que tu prends de gros coups. Ça donne de la Rage, mais tu as 27 % d'armure en moins.]] },
			{ band = 2, title = "Félin : dégâts au corps à corps", body = [[
Dès le niveau 20 (Forme de félin, via une quête ; Rôder vient avec). Pour monter de niveau, c'est le premier choix des guides : ils le disent le plus rapide et le plus agréable. Le félin utilise l'**Énergie**, qui se remplit toute seule. Tes coups te donnent des **points de combo** (jusqu'à 5) ; un **coup de grâce** les utilise tous.
**Ordre simple :**
1. Rôder (**Shift-R**), puis ouvre avec Lambeau (**3**) par derrière. **Rôder** = avancer en douce, pour que l'ennemi ne te voie pas.
2. Lucioles (**5**) sur les ennemis coriaces.
3. Griffure (**2**, dès 24), mais pas quand l'ennemi est presque mort.
4. Griffe (**1**) pour les points de combo ; Lambeau (**3**) quand tu es derrière l'ennemi.
5. À 4-5 points de combo : Déchirure (**4**) si l'ennemi va vivre longtemps, sinon Morsure féroce (**Shift-4**, dès 24).
6. Puissance fluctuante (**Q**, dès 40) quand ton Énergie est sous 50.
**Tous les 10 niveaux :**
- 10 : rien de nouveau pour ce rôle (le félin arrive au 20).
- 20 : Forme de félin (**Ctrl-2**), Griffe (**1**), Lambeau (**3**, par derrière), Déchirure (**4**), Rôder (**Shift-R**). Charge farouche (**E**, un talent) : en félin, tu bondis derrière l'ennemi. Augure de clarté est passif : pas de touche.
- 30 : Chef de la meute (un talent). Avant ça : Griffure (**2**) et Morsure féroce (**Shift-4**) au 24, Célérité (**R**) au 26, Dérobade (**F**) au 28.
- 40 : Puissance fluctuante (**Q**, un talent) : 40 Énergie contre du mana, cooldown 8 secondes, en félin seulement. Avant ça : Ravage (bloc D) au 32, Traquenard (**V**, depuis Rôder, un étourdissement) au 36. Les niveaux de talent indiqués ici sont les plus tôt possibles ; un avantage peut les avancer jusqu'à 5 niveaux.
- 50 : rangs plus forts de Morsure féroce, Déchirure et Lambeau ; rien de nouveau pour ce rôle.
- 60 : encore des rangs plus forts ; rien de nouveau pour ce rôle.
**Erreurs de débutant :**
- Lambeau de face. Il ne marche que par derrière ; de face, utilise Griffe.
- Puissance fluctuante trop souvent. Ensuite tu n'as plus de mana pour te soigner.]] },
			{ band = 1, title = "Equilibre : dégâts à distance", body = [[
Dès le niveau 1 : Colère est là dès le début, Eclat lunaire arrive au niveau 4. Forme de sélénien est un talent, au plus tôt au niveau 40. Les guides disent que monter de niveau en Equilibre marche, mais plus lentement qu'en félin. Certains guides prennent Forme de sélénien plus tard (Zygor au 53) : 40 n'est pas une règle.
**Ordre simple :**
1. Feu stellaire (**3**, dès 20) pour ouvrir sur un ennemi.
2. Eclat lunaire (**2**).
3. Essaim d'insectes (**4**, dès 25).
4. Colère (**1**) pour remplir. Avec Éclipse (dès 30) : Colère accumule des charges, puis Feu stellaire (**3**).
5. Ouragan (**Shift-1**, dès 40) sur les groupes.
Peu de mana ? Continue avec Colère : ce sort coûte peu.
**Tous les 10 niveaux :**
- 10 : Colère (**1**), Eclat lunaire (**2**), Epines (**Shift-Z**), Sarments (**V**), Emprise de la nature (**X**).
- 20 : Feu stellaire (**3**). Augure de clarté est passif : pas de touche.
- 30 : Éclipse (un talent) : Colère rend tes 2 prochains sorts Feu stellaire plus rapides. Avant ça : Essaim d'insectes (**4**, un talent) au 25. Les niveaux de talent indiqués ici sont les plus tôt possibles ; un avantage peut les avancer jusqu'à 5 niveaux.
- 40 : Forme de sélénien (**Ctrl-3**, un talent) : coûte du mana, donne +3 % de critique à ton groupe (**critique** = un coup chanceux, plus fort), mais pas de soins dans cette forme. Ouragan (**Shift-1**), Innervation (**F1**).
- 50 : rangs plus forts d'Ouragan et de Feu stellaire. Ecorce (**Z**) au 44.
- 60 : encore des rangs plus forts ; rien de nouveau pour ce rôle.
**Erreurs de débutant :**
- Soigner en Forme de sélénien. C'est impossible, et reprendre la forme coûte du mana.
- Chercher une touche pour Augure de clarté. Il est passif : il marche tout seul.]] },
			{ band = 3, title = "Restauration : soigneur", body = [[
Dès le niveau 1 : Toucher guérisseur est là dès le début. Les guides déconseillent de soigner pour monter de niveau en solo (les ennemis meurent lentement) : monte de niveau avec Colère et Eclat lunaire, et soigne en donjon. Un **HoT** est un soin qui soigne petit à petit.
**Ordre simple (en groupe) :**
1. Récupération (**F4**) sur le tank.
2. Rétablissement (**F2**) sur quelqu'un qui a peu de vie.
3. Prompte guérison (**Shift-F1**, dès 25) : seulement sur quelqu'un qui a ta Récupération ou ton Rétablissement.
4. Croissance sauvage (**Shift-2**, dès 40) quand plusieurs personnes prennent des dégâts.
5. Toucher guérisseur (**C**) pour les gros dégâts. Urgence : Rapidité de la nature (**Shift-3**, dès 30), puis Toucher guérisseur.
6. Innervation (**F1**, dès 40) quand ton mana est bas.
**Tous les 10 niveaux :**
- 10 : Toucher guérisseur (**C**), Récupération (**F4**). Puis Rétablissement (**F2**) et Ressusciter (**F3**, hors combat) au 12, Guérison du poison (**Shift-C**) au 14.
- 20 : Renaissance (**F3**, en combat). Puis Délivrance de la malédiction (**Shift-V**) au 24, Abolir le poison (**Shift-C**) au 26.
- 30 : Rapidité de la nature (**Shift-3**, un talent), Tranquillité (**Q**). Avant ça : Prompte guérison (**Shift-F1**, un talent) au 25. Les niveaux de talent indiqués ici sont les plus tôt possibles ; un avantage peut les avancer jusqu'à 5 niveaux.
- 40 : Croissance sauvage (**Shift-2**, un talent), Innervation (**F1**).
- 50 : Don du fauve (**Shift-X**), une Croissance sauvage plus forte.
- 60 : encore des rangs plus forts ; rien de nouveau pour ce rôle.
**Erreurs de débutant :**
- Soigner dans une forme. Les soins ne marchent que sous ta forme normale.
- Lancer un HoT sur quelqu'un qui l'a encore. Le nouveau remplace l'ancien.]] },
		},
		-- Warrior ... Paladin: translated 17 Nov 2026 by mh-writer. Spell names: SpellName frFR, wowf 1.60.1.70938.
		WARRIOR = {
			{ band = 3, title = "Protection : tank", body = [[
Dès le niveau 10 (Posture défensive, via une quête ; la même quête donne Provocation et Fracasser armure). Le **tank**, c'est celui que les ennemis frappent, pour que le reste du groupe reste à l'abri. Tu portes une arme à une main et un bouclier. **Menace** = à quel point un ennemi veut t'attaquer ; comme tank, il t'en faut sur chaque ennemi. Les guides ne sont pas d'accord sur l'arbre le plus rapide pour monter de niveau seul : certains disent Protection, d'autres disent qu'elle est plus lente seul. Elle démarre vraiment vers le niveau 16, quand tu as Maîtrise du blocage en plus de Vengeance.
**Ordre simple :**
1. Posture défensive (**Ctrl-2**), Cri de guerre (**Shift-X**). Rage sanguinaire (**F1**) pour avoir de la Rage au départ.
2. Attire. **Attirer** = frapper un ennemi de loin, pour qu'il vienne vers toi. Charge (**R**) ne marche qu'en Posture de combat (**Ctrl-1**) ; reviens ensuite en Posture défensive (**Ctrl-2**). Avec Avant-garde (dès 25), Charge marche aussi en Posture défensive. Ou attire avec ton arme à distance (bloc D).
3. Plusieurs ennemis : Cri démoralisant (**Shift-2**, dès 14) une fois, Coup de tonnerre (**Shift-1**) dès qu'il est prêt.
4. Maîtrise du blocage (**Z**, dès 16), et Vengeance (**2**, dès 14) dès qu'elle s'illumine.
5. Heurt de bouclier (**3**, dès 40) dès qu'il est prêt.
6. Fracasser armure (**5**) sur ta cible principale ; jusqu'à 5 cumuls sur un boss.
7. Provocation (**F**) quand un ennemi attaque quelqu'un d'autre.
8. Rage en trop : Frappe héroïque (**1**) sur un ennemi, Enchaînement (**Shift-4**, dès 20) sur deux ennemis ou plus.
**Tous les 10 niveaux :**
- 10 : Posture défensive (**Ctrl-2**), Provocation (**F**), Fracasser armure (**5**), Rage sanguinaire (**F1**). Puis Coup de bouclier (**E**) au 12, Vengeance (**2**) et Cri démoralisant (**Shift-2**) au 14, Maîtrise du blocage (**Z**) au 16, Désarmement (**V**) au 18.
- 20 : Dernier rempart (**X**, un talent) : 30 % de vie maximum en plus pendant 20 secondes. Ivresse de la victoire (**F2**), Enchaînement (**Shift-4**). Puis Cri d’intimidation (**Shift-Q**) au 22, Avant-garde (un talent, passif) au 25, Cri de défi (**Shift-F**) au 26, Mur protecteur (**C**) au 28. Les niveaux de talent indiqués ici sont les plus tôt possibles ; un avantage peut les avancer jusqu'à 5 niveaux.
- 30 : Bourrasque (**Shift-V**, un talent) : un étourdissement de 5 secondes. Posture berserker (**Ctrl-3**, via une quête). Puis Bastion (un talent, passif) au 35.
- 40 : Heurt de bouclier (**3**, un talent). Armure en plaques chez le maître de classe : tu peux porter des plaques.
- 50 : rien de nouveau pour ce rôle. Rangs plus forts de Heurt de bouclier, Vengeance, Fracasser armure et Coup de tonnerre.
- 60 : encore des rangs plus forts ; rien de nouveau pour ce rôle.
**Erreurs de débutant :**
- Croire que Coup de tonnerre frappe tout le groupe d'ennemis. Il frappe 4 ennemis ; un cinquième peut courir vers le soigneur.
- Laisser des ennemis derrière toi. Par derrière, tu ne peux ni bloquer, ni esquiver, ni parer, et Vengeance ne s'illumine pas.
- Provocation sur un ennemi qui t'attaque déjà. Elle ne fait rien alors.]] },
			{ band = 1, title = "Armes : dégâts avec une grande arme", body = [[
Dès le niveau 1. Tu portes une grande arme à deux mains et tu es presque toujours en Posture de combat. Les grandes étapes sont Attaques circulaires au 30 et Frappe mortelle au 40. Une nouvelle arme est ton plus gros gain. Tu n'as pas de soin à toi, sauf Ivresse de la victoire (dès 20), donc garde de la nourriture et des bandages sous la main. Les guides ne sont pas d'accord sur l'arbre le plus rapide pour monter de niveau ; les trois marchent.
**Ordre simple :**
1. Posture de combat (**Ctrl-1**), Cri de guerre (**Shift-X**).
2. Charge (**R**) pour commencer.
3. Pourfendre (**Shift-Z**), si l'ennemi va vivre un moment.
4. Fulgurance (**2**, dès 12) dès qu'elle s'illumine.
5. Frappe mortelle (**3**, dès 40) dès qu'elle est prête ; garde 30 de Rage pour elle.
6. Ivresse de la victoire (**F2**, dès 20) après avoir tué un ennemi, quand il te manque de la vie.
7. Deux ennemis : Attaques circulaires (**Q**, dès 30), puis Enchaînement (**Shift-4**, dès 20). Avant 30 : Coup de tonnerre (**Shift-1**).
8. Rage en trop : Frappe héroïque (**1**).
**Tous les 10 niveaux :**
- 10 : Frappe héroïque (**1**), Charge (**R**), Pourfendre (**Shift-Z**), Coup de tonnerre (**Shift-1**), Brise-genou (**V**), Cri de guerre (**Shift-X**), Rage sanguinaire (**F1**). Puis Fulgurance (**2**) au 12, Cri démoralisant (**Shift-2**) au 14.
- 20 : Ivresse de la victoire (**F2**), Enchaînement (**Shift-4**), Heurtoir (**Shift-C**), Représailles (**C**). Puis Exécution (**4**) au 24, Frappe transperçante (**F3**, un talent) au 25 : un coup plus fort en plus sur les Géants et les Draconiens. Les niveaux de talent indiqués ici sont les plus tôt possibles ; un avantage peut les avancer jusqu'à 5 niveaux.
- 30 : Attaques circulaires (**Q**, un talent, en Posture de combat seulement) : tes 5 prochains coups frappent aussi un ennemi à côté de ta cible. Posture berserker (**Ctrl-3**, via une quête) avec Interception (**R**) et Rage berserker (**Shift-V**). Puis Heurtoir amélioré (un talent, passif) au 35, Tourbillon (**2** en Posture berserker) au 36, Volée de coups (**E** en Posture berserker) au 38.
- 40 : Frappe mortelle (**3**, un talent) : l'ennemi reçoit 50 % de soins en moins pendant 10 secondes. Armure en plaques chez le maître de classe.
- 50 : Témérité (**Q** en Posture berserker). Rangs plus forts de Frappe mortelle.
- 60 : encore des rangs plus forts ; rien de nouveau pour ce rôle.
**Erreurs de débutant :**
- Appuyer tout le temps sur Frappe héroïque (**1**). Ce coup ne donne pas de Rage, donc il n'en reste plus pour Frappe mortelle ou Fulgurance.
- Heurtoir (**Shift-C**) avant le talent Heurtoir amélioré : 1,5 seconde d'incantation, qui retarde ton coup normal. La plupart des guides ne l'utilisent pas avant ça.
- Chercher une interruption sur **E** avec une arme à deux mains. Coup de bouclier a besoin d'un bouclier ; ton interruption, c'est Volée de coups (38, Posture berserker).]] },
			{ band = 2, title = "Fureur : dégâts avec deux armes", body = [[
Une arme dans chaque main, dès le niveau 20 (Ambidextrie chez le maître de classe). Jusque-là, utilise ta meilleure arme (une arme à deux mains, c'est bien) et joue comme Armes. Fureur devient vraiment forte avec Tourbillon (36) et Sanguinaire (40). Il te faut deux bonnes armes. Tourbillon, Volée de coups, Interception et Rage berserker ne marchent qu'en Posture berserker, donc tu changes souvent de posture.
**Ordre simple (dès 36 ; avant, joue comme Armes) :**
1. Cri de guerre (**Shift-X**). Rage sanguinaire (**F1**) pour la Rage.
2. Charge (**R**) en Posture de combat (**Ctrl-1**).
3. Souhait mortel (**Shift-3**, dès 30) sur un ennemi fort.
4. Posture berserker (**Ctrl-3**) : Tourbillon (**2**, dès 36) dès qu'il est prêt.
5. Sanguinaire (**3**, dès 40) dès qu'elle est prête. Les guides ne sont pas d'accord sur lequel des deux passe en premier.
6. Ivresse de la victoire (**F2**) après avoir tué un ennemi, quand il te manque de la vie.
7. Rage en trop : Frappe héroïque (**1**) ; sur deux ennemis, Enchaînement (**Shift-4**).
8. Peu de Rage : Frappes téméraires (**Shift-F1**, dès 25 ; ça coûte de la vie).
**Tous les 10 niveaux :**
- 10 : rien de nouveau pour ce rôle : tu joues comme Armes, avec une seule arme.
- 20 : Ambidextrie chez le maître de classe : maintenant, une arme peut aller dans ton autre main. Hurlement perçant (**Shift-R**, un talent) : ralentit tous les ennemis près de toi. Ivresse de la victoire (**F2**), Enchaînement (**Shift-4**). Puis Exécution (**4**) au 24, Frappes téméraires (**Shift-F1**, un talent) au 25. Les niveaux de talent indiqués ici sont les plus tôt possibles ; un avantage peut les avancer jusqu'à 5 niveaux.
- 30 : Souhait mortel (**Shift-3**, un talent). Posture berserker (**Ctrl-3**, via une quête) avec Interception (**R**) et Rage berserker (**Shift-V**). Puis Tourbillon (**2** en Posture berserker) au 36, Volée de coups (**E** en Posture berserker) au 38.
- 40 : Sanguinaire (**3**, un talent ; il te faut d'abord Souhait mortel). Elle ne soigne pas ; elle te fait courir plus vite. Armure en plaques chez le maître de classe.
- 50 : Témérité (**Q** en Posture berserker). Rangs plus forts de Sanguinaire.
- 60 : encore des rangs plus forts ; rien de nouveau pour ce rôle.
**Erreurs de débutant :**
- Jouer Fureur avec une bonne arme et une mauvaise deuxième.
- Chercher Tourbillon (**2**) en Posture de combat. Il ne marche qu'en Posture berserker, et là, Pourfendre et Coup de tonnerre ne marchent pas.
- Souhait mortel (**Shift-3**) dans un combat que tu pourrais perdre. Pendant 30 secondes, tu subis aussi 5 % de dégâts en plus.]] },
		},
		MAGE = {
			{ band = 1, title = "Arcanes : dégâts à distance", body = [[
Dès le niveau 8 (Projectiles des arcanes). Déflagration des arcanes est un talent, au plus tôt au niveau 20 ; jusque-là, tu joues comme n'importe quel mage, avec Eclair de givre, Boule de feu et Projectiles des arcanes. Les guides ne sont pas d'accord : certains disent qu'Arcanes est fort pour monter de niveau, la plupart conseillent Givre et disent qu'Arcanes demande beaucoup de mana. Son arbre n'a pas de ralentissements, donc c'est le plus faible pour tenir les ennemis à l'écart. Un **sort canalisé** est un sort qui continue tant que tu restes immobile ; bouger l'arrête. Projectiles des arcanes en est un.
**Ordre simple :**
1. Ouvre avec Eclair de givre (**2**) : l'ennemi arrive alors lentement.
2. Déflagration des arcanes (**Ctrl-2**, dès 20) : une ou deux, sur un boss jusqu'à quatre. Chacune fait coûter plus de mana à la suivante.
3. Barrage de projectiles (dès 15) s'illumine ? Projectiles des arcanes (**3**) tout de suite : gratuit et deux fois plus rapide.
4. Colère des arcanes (**Shift-F1**, dès 25) dès qu'elle est prête.
5. L'ennemi est près de toi ? Nova de givre (**V**), recule.
6. Presque mort : ta baguette (**Ctrl-3**, jusqu'au 40) ou Trait de feu (**5**).
7. Ennemi coriace ou boss : Présence spirituelle (**Shift-3**, dès 30), puis Colère des arcanes pour un gros coup instantané. Dès 40, aussi Pouvoir des arcanes (**Q**).
Plusieurs ennemis : Nova de givre (**V**), puis Explosion des arcanes (**Shift-2**, dès 14). Peu de mana ? Evocation (**F1**, dès 20).
**Tous les 10 niveaux :**
- 10 : Nova de givre (**V**). Premier talent : Canalisation améliorée (Projectiles des arcanes n'est plus interrompu quand tu es frappé). Puis Explosion des arcanes (**Shift-2**) au 14, Barrage de projectiles (un talent, passif) au 15. Les niveaux de talent indiqués ici sont les plus tôt possibles ; un avantage peut les avancer jusqu'à 5 niveaux.
- 20 : Déflagration des arcanes (**Ctrl-2**, un talent). Transfert (**R**), Evocation (**F1**), Bouclier de mana (**Z**). Puis Contresort (**E**) au 24, Colère des arcanes (**Shift-F1**, un talent ; il te faut d'abord Déflagration des arcanes) au 25.
- 30 : Présence spirituelle (**Shift-3**, un talent) : ton prochain sort avec moins de 10 secondes d'incantation est instantané. Armure de glace (**Shift-Z**). Puis Armure du mage (bloc D) au 34.
- 40 : Pouvoir des arcanes (**Q**, un talent ; il te faut d'abord Présence spirituelle) : pendant 15 secondes, tes sorts font 30 % de dégâts en plus, mais coûtent 30 % de mana en plus. Éclair de givrefeu prend **Ctrl-3** : mets ta baguette (Tir) sur une de tes propres touches Alt.
- 50 : rangs plus forts de Déflagration des arcanes, Colère des arcanes et Projectiles des arcanes ; rien de nouveau pour ce rôle.
- 60 : encore des rangs plus forts ; rien de nouveau pour ce rôle.
**Erreurs de débutant :**
- Appuyer sur Déflagration des arcanes encore et encore. Chacune fait coûter 100 % de mana en plus à la suivante ; tu es vite à sec.
- Bouger pendant Projectiles des arcanes. C'est un sort canalisé : bouger l'arrête.
- Pouvoir des arcanes sur un ennemi normal. Il fait aussi coûter plus cher tes sorts, et il a un cooldown de 3 minutes.]] },
			{ band = 2, title = "Feu : dégâts à distance", body = [[
Dès le niveau 1 (Boule de feu). Explosion pyrotechnique est un talent, au plus tôt au niveau 20. Le vrai jeu Feu commence avec Réchauffement (au plus tôt au niveau 25) ; avant ça, Explosion pyrotechnique sert seulement à ouvrir. Les guides disent que Feu fait le plus de dégâts sur un ennemi, et monte vite de niveau, mais avec plus de risque que Givre : il n'a pas de gel à lui. Un **critique** est un coup chanceux, plus fort.
**Ordre simple :**
1. Ouvre de loin avec Explosion pyrotechnique (**4**, dès 20). Avant ça : Boule de feu (**1**).
2. Boule de feu (**1**) comme sort normal.
3. Trait de feu (**5**) dès qu'il est prêt. Dès 25, chaque Trait de feu donne un cumul de Réchauffement.
4. Deux ou trois cumuls de Réchauffement (dès 25) ? Explosion pyrotechnique (**4**).
5. Ennemi proche : Brûlure (**Ctrl-1**, dès 22) au lieu de Boule de feu, ou Nova de givre (**V**) et recule. Dès 30, Vague explosive (**F3**) après.
6. Presque mort : ta baguette (**Ctrl-3**, jusqu'au 40) ou Trait de feu.
7. Elite ou boss, dès 40 : Combustion (**Q**).
Plusieurs ennemis : Nova de givre (**V**), Choc de flammes (**Shift-4**, dès 16), Vague explosive (**F3**, dès 30).
**Tous les 10 niveaux :**
- 10 : Nova de givre (**V**). Premier talent : Empressement (Boule de feu s'incante plus vite). Puis Enflammer et Impact (des talents) au 15, Choc de flammes (**Shift-4**) au 16. Les niveaux de talent indiqués ici sont les plus tôt possibles ; un avantage peut les avancer jusqu'à 5 niveaux.
- 20 : Explosion pyrotechnique (**4**, un talent) : 6 secondes d'incantation, donc seulement pour ouvrir. Transfert (**R**), Evocation (**F1**), Gardien de feu (**F4**), Bouclier de mana (**Z**). Puis Brûlure (**Ctrl-1**) au 22, Contresort (**E**) au 24, Réchauffement (un talent, passif ; il te faut d'abord Explosion pyrotechnique) au 25 : un critique avec Boule de feu, Éclair de givrefeu, Trait de feu ou Brûlure rend ta prochaine Explosion pyrotechnique 25 % plus rapide, jusqu'à 3 cumuls.
- 30 : Vague explosive (**F3**, un talent) : instantanée, autour de toi ; les ennemis sont 50 % plus lents pendant 6 secondes. Masse critique (un talent). Armure de glace (**Shift-Z**). Puis Puissance du feu (un talent) au 35.
- 40 : Combustion (**Q**, un talent ; il te faut d'abord Masse critique). Éclair de givrefeu prend **Ctrl-3** : mets ta baguette (Tir) sur une de tes propres touches Alt.
- 50 : rangs plus forts de Boule de feu, Explosion pyrotechnique, Vague explosive et Éclair de givrefeu ; rien de nouveau pour ce rôle.
- 60 : encore des rangs plus forts ; rien de nouveau pour ce rôle.
**Erreurs de débutant :**
- Lancer Explosion pyrotechnique quand l'ennemi est déjà sur toi. 6 secondes d'incantation, c'est trop lent alors.
- Croire que trois cumuls de Réchauffement rendent Explosion pyrotechnique instantanée. Elle a encore 1,5 seconde d'incantation : reste immobile.
- Chercher un Bloc de glace. Feu n'en a pas. Ta sortie : Nova de givre (**V**), Transfert (**R**), Vague explosive (**F3**).]] },
			{ band = 3, title = "Givre : dégâts à distance", body = [[
Dès le niveau 4 (Eclair de givre) ; Nova de givre arrive au 10. Javelot de glace est un talent, au plus tôt au niveau 20. Pour monter de niveau, c'est le premier choix de la plupart des guides : ils le disent le plus sûr. Il démarre vraiment vers le 30. **Gelé** = l'ennemi est gelé sur place et ne peut pas bouger.
**Ordre simple :**
1. Eclair de givre (**2**) d'aussi loin que possible. Chaque coup ralentit l'ennemi.
2. Ennemi Gelé (par Nova de givre, ou par le talent Morsure de givre) ? Javelot de glace (**F**, dès 20).
3. Ennemi proche ? Nova de givre (**V**), recule, Eclair de givre, puis Javelot de glace.
4. Doigts de givre s'illumine (dès 30) ? Javelot de glace.
5. Javelot de glace pas prêt et l'ennemi est proche : Cône de froid (**Shift-F**, dès 26).
6. Presque mort : ta baguette (**Ctrl-3**, jusqu'au 40) ou Trait de feu (**5**).
Plusieurs ennemis (dès 20) : Nova de givre (**V**), recule, Blizzard (**Shift-1**), puis Cône de froid (**Shift-F**). En difficulté : Bloc de glace (**C**, dès 25), Transfert (**R**).
**Tous les 10 niveaux :**
- 10 : Nova de givre (**V**). Premier talent : Eclair de givre amélioré (une incantation plus courte). Puis Morsure de givre (un talent) au 15 : tes ralentissements peuvent geler l'ennemi pendant 5 secondes. Les niveaux de talent indiqués ici sont les plus tôt possibles ; un avantage peut les avancer jusqu'à 5 niveaux.
- 20 : Javelot de glace (**F**, un talent) : 300 % de dégâts en plus sur un ennemi Gelé. Blizzard (**Shift-1**), Transfert (**R**), Evocation (**F1**), Bouclier de mana (**Z**). Puis Gardien de givre (**F2**) au 22, Contresort (**E**) au 24, Bloc de glace (**C**, un talent) au 25, Cône de froid (**Shift-F**) au 26.
- 30 : Morsure du froid (**Shift-C**, un talent) : remet à zéro le cooldown de tes autres sorts de Givre ; son propre cooldown est de 10 minutes. Doigts de givre (un talent ; il te faut d'abord Javelot de glace) : tes 2 prochains sorts agissent comme si l'ennemi était Gelé. Armure de glace (**Shift-Z**). Puis Froid hivernal (un talent) au 35.
- 40 : Barrière de glace (**X**, un talent ; il te faut d'abord Morsure du froid) : un bouclier qui absorbe des dégâts. Éclair de givrefeu prend **Ctrl-3** : mets ta baguette (Tir) sur une de tes propres touches Alt.
- 50 : rangs plus forts d'Eclair de givre, Cône de froid, Armure de glace, Barrière de glace et Blizzard ; rien de nouveau pour ce rôle.
- 60 : encore des rangs plus forts ; rien de nouveau pour ce rôle.
**Erreurs de débutant :**
- Javelot de glace sur un ennemi qui n'est pas Gelé. C'est alors un petit coup.
- Appuyer sur Trait de feu juste avant un gel. Trait de feu et Javelot de glace partagent un même cooldown de 8 secondes.
- Utiliser Morsure du froid pour rien. Il a un cooldown de 10 minutes : garde-le pour quand ça tourne mal.]] },
		},
		PRIEST = {
			{ band = 1, title = "Discipline : soigneur", body = [[
Dès le niveau 1 : Soins inférieurs est là dès le début. Ses propres sorts arrivent plus tard : Protection de l’âme au 25 et Pénitence au 30, les deux au plus tôt. En groupe, elle est la plus forte pour soigner une seule personne, le tank. Monter de niveau seul marche avec Châtiment, Flammes sacrées et ta baguette, plus tard Pénitence ; les guides ne sont pas d'accord pour dire si c'est plus rapide qu'Ombre. **Ame affaiblie** : après un Mot de pouvoir : Bouclier, la même personne ne peut pas recevoir de nouveau bouclier pendant 15 secondes.
**Ordre simple (en groupe) :**
1. Mot de pouvoir : Bouclier (**Z**) sur le tank, juste avant d'attirer. **Attirer** = le premier coup qui commence un combat.
2. Rénovation (**F4**) sur le tank.
3. Pénitence (**Shift-F1**, dès 30) sur celui qui est blessé, chaque fois qu'elle est prête.
4. Ton gros soin (**C**) pour les dégâts normaux.
5. Soins rapides (**F2**, dès 20) quand C est trop lent.
6. Plus de gens blessés : Prière de soins (**Shift-2**, dès 30).
7. Focalisation améliorée (**F1**, dès 20) avant un soin cher. Infusion de puissance (**Q**, dès 40) sur toi ou sur un lanceur de sorts.
Seul : Bouclier (**Z**), Flammes sacrées (**4**, dès 20), Châtiment (**1**), Attaque mentale (**3**), Mot de l'ombre : Douleur (**2**), Pénitence si tu n'en as pas besoin pour soigner, puis ta baguette (**5**).
**Tous les 10 niveaux :**
- 10 : Soins inférieurs (**C**), Mot de pouvoir : Bouclier (**Z**), Rénovation (**F4**), Résurrection (**F3**, seulement hors combat), Châtiment (**1**). Puis Feu intérieur (**Shift-Z**) au 12, Guérison des maladies (**Shift-C**) au 14, Soins (**C**) au 16, Dissipation de la magie (**Shift-V**) au 18.
- 20 : Soins rapides (**F2**), Flammes sacrées (**4**), Gardien de peur (bloc D). Focalisation améliorée (**F1**, un talent) : ton prochain sort ne coûte pas de mana et fait plus souvent un critique ; cooldown 3 minutes. Puis Protection de l’âme (un talent, passif) au 25 : Bouclier n'a plus de cooldown et coûte moins. Les niveaux de talent indiqués ici sont les plus tôt possibles ; un avantage peut les avancer jusqu'à 5 niveaux.
- 30 : Pénitence (**Shift-F1**, un talent) : soigne un ami ou blesse un ennemi ; cooldown 12 secondes. Prière de soins (**Shift-2**), Esprit divin (bloc D). Puis Abolir maladie (**Shift-C**) au 32, Égide divine (un talent, passif) au 35.
- 40 : Infusion de puissance (**Q**, un talent ; il te faut d'abord Pénitence) : 20 % de dégâts et de soins des sorts en plus ; cooldown 3 minutes. Soins supérieurs prend la touche **C**.
- 50 : rangs plus forts de Pénitence, Prière de soins, Soins rapides et Rénovation. Prière de robustesse (**Shift-X**) au 48.
- 60 : encore des rangs plus forts ; rien de nouveau pour ce rôle.
**Erreurs de débutant :**
- Mettre un bouclier deux fois de suite sur le même joueur. Ame affaiblie l'empêche. C'est par joueur : quelqu'un d'autre peut recevoir un bouclier tout de suite.
- Pénitence sur un ennemi pour soigner ton groupe. Elle soigne ou elle blesse, pas les deux.
- Prière de soins sur le mauvais joueur. Elle soigne le groupe du joueur que tu choisis.]] },
			{ band = 2, title = "Sacré : soigneur", body = [[
Dès le niveau 1 : Soins inférieurs est là dès le début. Sacré est le soigneur de groupe. Seul, il monte lentement de niveau : les guides conseillent de faire tes quêtes avec Châtiment et ta baguette, et de soigner en donjon. Ses propres sorts arrivent tard : Nova sacrée au 20 et Prière de guérison au 40, les deux au plus tôt.
**Ordre simple (en groupe) :**
1. Rénovation (**F4**) sur le tank au moment où il attire. **Attirer** = le premier coup qui commence un combat.
2. Prière de guérison (**Ctrl-2**, dès 40) sur le tank avant d'attirer, et de nouveau chaque fois qu'elle est prête.
3. Ton gros soin (**C**) pour les dégâts normaux.
4. Soins rapides (**F2**, dès 20) quand C arriverait trop tard.
5. Tout le groupe blessé : Prière de soins (**Shift-2**, dès 30). Nova sacrée (**Shift-1**, dès 20) seulement quand tout le monde est juste à côté de toi ; elle coûte beaucoup de mana.
6. Mot de pouvoir : Bouclier (**Z**) pour gagner du temps.
7. Un ennemi t'attaque : Oubli (**F**).
**Tous les 10 niveaux :**
- 10 : Soins inférieurs (**C**), Mot de pouvoir : Bouclier (**Z**), Rénovation (**F4**), Résurrection (**F3**, seulement hors combat). Puis Feu intérieur (**Shift-Z**) au 12, Guérison des maladies (**Shift-C**) au 14, Soins (**C**) au 16, Dissipation de la magie (**Shift-V**) au 18.
- 20 : Nova sacrée (**Shift-1**, un talent) : instantanée ; blesse les ennemis autour de toi et soigne ton groupe, sans menace. Soins rapides (**F2**), Flammes sacrées (**4**), Gardien de peur (bloc D). Puis Lien sacré (un talent, passif) au 25 : Soins rapides sur quelqu'un d'autre te soigne de la moitié. Les niveaux de talent indiqués ici sont les plus tôt possibles ; un avantage peut les avancer jusqu'à 5 niveaux.
- 30 : Prière de soins (**Shift-2**), Esprit divin (bloc D). Esprit de rédemption (un talent, passif). Puis Abolir maladie (**Shift-C**) au 32, Soins spirituels (un talent, passif) au 35.
- 40 : Prière de guérison (**Ctrl-2**, un talent ; il te faut d'abord Esprit de rédemption) : elle soigne dès que la cible prend des dégâts, puis saute vers un autre membre du groupe, jusqu'à 5 fois ; cooldown 10 secondes. Soins supérieurs prend la touche **C**.
- 50 : rangs plus forts de Prière de guérison, Nova sacrée, Prière de soins et Rénovation. Prière de robustesse (**Shift-X**) au 48.
- 60 : encore des rangs plus forts ; rien de nouveau pour ce rôle.
**Erreurs de débutant :**
- Prière de soins sur le mauvais joueur. Elle soigne le groupe du joueur que tu choisis, pas le tien.
- Soins rapides pour tout. C'est rapide mais cher ; garde-le pour les urgences.
- Nova sacrée sur un groupe qui est loin. Elle ne marche que juste autour de toi, et elle coûte cher.]] },
			{ band = 3, title = "Ombre : dégâts à distance", body = [[
Dès le niveau 4 (Mot de l'ombre : Douleur) ; Attaque mentale arrive au 10. Fouet mental est un talent, au plus tôt au niveau 20 ; Forme d'Ombre au 40. La plupart des guides montent de niveau en Ombre ; certains jouent Discipline jusqu'au 40. Au début, ta baguette fait une grande partie du travail. Ombre n'a pas de sort qui frappe beaucoup d'ennemis à la fois. Un **DoT**, ce sont des dégâts en petits morceaux pendant quelques secondes. Un **sort canalisé** est un sort qui continue tant que tu restes immobile.
**Ordre simple :**
1. Mot de pouvoir : Bouclier (**Z**) sur toi, si l'ennemi va t'atteindre.
2. Attaque mentale (**3**) de loin, pour commencer.
3. Mot de l'ombre : Douleur (**2**).
4. Peste dévorante (**Shift-3**, dès 20) sur un ennemi qui va vivre un moment.
5. Fouet mental (**1**, dès 20), et laisse-le aller jusqu'au bout. Avant ça : Châtiment (**1**).
6. Achève avec ta baguette (**5**).
Peu de mana ? Saute Peste dévorante et Fouet mental, et utilise ta baguette plus tôt. Dès 32 : Mot de l’ombre : Mort (**Shift-4**) seulement quand il va tuer l'ennemi. Dès 40 : Forme d'Ombre (**Ctrl-1**) active avant d'attirer le premier ennemi, et laisse-la active.
**Tous les 10 niveaux :**
- 10 : Attaque mentale (**3**), cooldown 8 secondes. Tu as déjà Châtiment (**1**), Mot de l'ombre : Douleur (**2**), Mot de pouvoir : Bouclier (**Z**), Oubli (**F**) et ta baguette (**5**). Puis Feu intérieur (**Shift-Z**) au 12, Cri psychique (**V**) au 14.
- 20 : Fouet mental (un talent) : prend la touche **1** à la place de Châtiment. Peste dévorante (**Shift-3**) : un DoT qui te soigne aussi ; cooldown 24 secondes. Puis Etreinte vampirique (**Ctrl-3**, un talent) au 25 ou au 30 : ton groupe est soigné de 20 % de tes dégâts d'ombre. Les niveaux de talent indiqués ici sont les plus tôt possibles ; un avantage peut les avancer jusqu'à 5 niveaux.
- 30 : Silence (**E**, un talent) : ton **interruption** (elle arrête le sort d'un ennemi) ; cooldown 45 secondes. Contrôle mental (**Shift-F**). Puis Mot de l’ombre : Mort (**Shift-4**) au 32, Lévitation (**R**) au 34.
- 40 : Forme d'Ombre (**Ctrl-1**, un talent ; il te faut d'abord Etreinte vampirique) : 10 % de dégâts d'ombre en plus, tes sorts d'ombre coûtent moitié moins, tu subis 15 % de dégâts physiques en moins, mais aucun sort de soin. Avant ça : Ténèbres (un talent, passif) au 35.
- 50 : rangs plus forts de Fouet mental, Attaque mentale, Mot de l'ombre : Douleur, Peste dévorante et Mot de l’ombre : Mort. Prière de robustesse (**Shift-X**) au 48.
- 60 : rangs plus forts de Fouet mental et Peste dévorante ; rien de nouveau pour ce rôle.
**Erreurs de débutant :**
- Mot de l’ombre : Mort sur un ennemi qui a beaucoup de vie. S'il ne meurt pas, tu perds 30 % de ta propre vie.
- Arrêter Fouet mental trop tôt. Avec le talent Fouet mental amélioré, le dernier tic est le plus fort.
- Ouvrir avec Attaque mentale en groupe. Ça crée beaucoup de menace (à quel point un ennemi veut t'attaquer) : laisse le tank commencer. Si un ennemi t'attaque : Oubli (**F**).]] },
		},
		ROGUE = {
			{ band = 1, title = "Assassinat : dagues et poison", body = [[
Dès le niveau 1 (Attaque pernicieuse et Eviscération). Tu te bats au corps à corps, avec des dagues et du poison. Tu utilises l'**Énergie**, qui se remplit toute seule. Tes coups donnent des **points de combo** (jusqu'à 5) sur l'ennemi que tu frappes ; un **coup de grâce** les utilise tous. Estropier est un talent, au plus tôt au niveau 40, et demande une dague dans chaque main. Jusque-là, tu joues avec Attaque sournoise ou Attaque pernicieuse. Les guides ne disent pas que c'est le départ le plus facile : la grande étape n'arrive qu'avec Estropier.
**Ordre simple :**
1. Dès 20 : du poison sur tes deux armes (des objets, sur le bloc D).
2. Attends d'avoir toute ton Énergie. Dès 18 (En garde), ta première attaque coûte alors 10 Énergie de moins.
3. Camouflage (**Shift-R**), passe derrière l'ennemi. **Camouflage** = avancer en douce, pour que l'ennemi ne te voie pas. Ouvre avec Embuscade (**2**, dès 18, une dague en main droite) ou Garrot (**1**, dès 14). Ennemi fort, dès 26 : Coup bas (**V**), un étourdissement de 4 secondes.
4. Points de combo : Attaque sournoise (**2**) quand tu es derrière l'ennemi, sinon Attaque pernicieuse (**1**). Dès 40 : Estropier (**3**), 2 points à chaque fois.
5. Surin (**Shift-3**, dès 24) dès qu'il est prêt. Avec Toxine (dès 30), chaque Surin rend ton poison plus fort pendant 6 secondes.
6. Coup de grâce : Débiter (**Shift-4**) dans un long combat ; sinon Eviscération (**4**) à 5 points. Rupture (**5**, dès 20) sur un ennemi qui va vivre longtemps (un élite, un boss).
7. Sang froid (**F1**, dès 25) juste avant une Eviscération à 5 points.
**Tous les 10 niveaux :**
- 10 : tu as déjà Attaque pernicieuse (**1**), Eviscération (**4**), Attaque sournoise (**2**), Camouflage (**Shift-R**), Suriner (**Shift-Q**) et Evasion (**Z**). Nouveau au 10 : Débiter (**Shift-4**), Sprint (**R**), Assommer (**Shift-Q** en Camouflage), et une arme dans chaque main (Ambidextrie). Puis Coup de pied (**E**) au 12, Garrot (**1** en Camouflage) et Exposer l'armure (**Shift-Z**) au 14, Feinte (**F**) au 16, Embuscade (**2** en Camouflage) et En garde (passif) au 18.
- 20 : Rupture (**5**). Poisons, via une quête. Puis Disparition (**X**) au 22, Surin (**Shift-3**) au 24, Sang froid (**F1**, un talent) au 25 : ta prochaine Attaque pernicieuse, Attaque sournoise, Embuscade, Eviscération ou Estropier fait à coup sûr un critique (**critique** = un coup chanceux, plus fort) ; cooldown 3 minutes. Coup bas (**V** en Camouflage) au 26. Les niveaux de talent indiqués ici sont les plus tôt possibles ; un avantage peut les avancer jusqu'à 5 niveaux.
- 30 : Toxine (un talent, passif : pas de touche) : chaque Surin donne à ton poison 30 % de dégâts en plus et 20 % de chances en plus de toucher, pendant 6 secondes. Aiguillon perfide (**V**). Puis Cécité (**Shift-V**) au 34, Scelle le destin (un talent, passif) au 35 : un critique avec une attaque qui donne des points de combo te donne un point en plus.
- 40 : Estropier (**3**, un talent ; il te faut d'abord Toxine) : 60 Énergie, frappe avec les deux dagues, 2 points de combo, 20 % de dégâts en plus sur un ennemi empoisonné. Puis Débiter Rang 2 au 42, Surin Rang 2 au 44.
- 50 : Estropier Rang 2 et Aiguillon perfide Rang 2 ; rien de nouveau pour ce rôle.
- 60 : Estropier Rang 3 et des rangs plus forts ; rien de nouveau pour ce rôle.
**Erreurs de débutant :**
- Estropier sans dagues. Il demande une dague dans chaque main : trouve ta deuxième dague avant le niveau 40.
- Oublier Surin. Toxine ne marche que par Surin.
- Changer d'ennemi alors que l'ancien a des points de combo. Les points ne suivent pas.]] },
			{ band = 2, title = "Combat : des dégâts réguliers avec n'importe quelle arme", body = [[
Dès le niveau 1 (Attaque pernicieuse et Eviscération). Tu n'as pas besoin d'être derrière l'ennemi : ton coup principal est Attaque pernicieuse. Elle marche avec n'importe quelle arme à une main : une épée, une hache, une masse, une arme de pugilat ou une dague. Plusieurs guides disent que Combat est l'arbre le plus facile pour monter de niveau seul. Ils conseillent une arme lente en main droite et une arme rapide dans ton autre main. Tu utilises l'**Énergie**, qui se remplit toute seule ; tes coups donnent des **points de combo**, et un **coup de grâce** les utilise. Déluge de lames (au plus tôt au niveau 30) est la seule chose qu'un Voleur a contre deux ennemis à la fois.
**Ordre simple :**
1. Attends d'avoir toute ton Énergie (En garde, dès 18).
2. Ouvre depuis le Camouflage (**Shift-R**) avec Garrot (**1**, dès 14), ou dès 26 avec Coup bas (**V**). Marcher vers l'ennemi et attaquer, c'est bien aussi.
3. Attaque pernicieuse (**1**) pour les points de combo.
4. Riposte (**Shift-F1**, dès 20) dès qu'elle s'illumine : ça arrive après que tu as paré une attaque.
5. Surin (**Shift-3**, dès 24) quand il est prêt.
6. Coup de grâce : Débiter (**Shift-4**) dans un long combat ; sinon Eviscération (**4**) à 5 points. Les guides ne sont pas d'accord sur le moment où garder Débiter actif.
7. Deux ennemis : Déluge de lames (**Shift-1**, dès 30). Dès 40, avec Poussée d'adrénaline (**Q**) pour un combat difficile. Tu perds ? Evasion (**Z**).
**Tous les 10 niveaux :**
- 10 : tu as déjà Attaque pernicieuse (**1**), Eviscération (**4**), Camouflage (**Shift-R**), Suriner (**Shift-Q**) et Evasion (**Z**). Nouveau au 10 : Débiter (**Shift-4**), Sprint (**R**), Assommer (**Shift-Q** en Camouflage), et une arme dans chaque main. Puis Coup de pied (**E**) au 12, Garrot (**1** en Camouflage) et Exposer l'armure (**Shift-Z**) au 14, Feinte (**F**) au 16, En garde (passif) au 18.
- 20 : Riposte (**Shift-F1**, un talent ; il te faut d'abord Déviation) : ne marche que juste après que tu as paré une attaque. 10 Énergie, et l'ennemi est désarmé pendant 6 secondes. Rupture (**5**), et Poisons via une quête. Puis Disparition (**X**) au 22, Surin (**Shift-3**) au 24, Exécution parfaite (un talent, passif) au 25 : Eviscération coûte 15 Énergie de moins. Coup bas (**V** en Camouflage) au 26. Les niveaux de talent indiqués ici sont les plus tôt possibles ; un avantage peut les avancer jusqu'à 5 niveaux.
- 30 : Déluge de lames (**Shift-1**, un talent) : pendant 15 secondes, tu attaques 20 % plus vite, et chaque coup frappe aussi un deuxième ennemi proche ; cooldown 2 minutes. Taillader et trancher (un talent, passif) : un bonus qui dépend de ton arme. Aiguillon perfide (**V**). Puis Cécité (**Shift-V**) au 34, L’éclat de l’acier (un talent, passif) au 35 : Surin donne jusqu'à 15 Énergie en plus et est prêt jusqu'à 2 secondes plus tôt.
- 40 : Poussée d'adrénaline (**Q**, un talent ; il te faut d'abord Déluge de lames) : pendant 15 secondes, ton Énergie se remplit deux fois plus vite ; cooldown 5 minutes. Puis Débiter Rang 2 au 42 (30 % plus vite au lieu de 20 %), Surin Rang 2 au 44 (25 Énergie rendue au lieu de 15).
- 50 : Aiguillon perfide Rang 2 et des rangs plus forts ; rien de nouveau pour ce rôle.
- 60 : des rangs plus forts ; rien de nouveau pour ce rôle.
**Erreurs de débutant :**
- Déluge de lames à côté d'un ennemi que tu as mis hors jeu avec Assommer, Suriner ou Cécité. Les coups en plus le réveillent.
- Appuyer sur Riposte alors que rien n'a été paré. Elle ne marche que juste après une parade.
- Attaque sournoise ou Embuscade avec une épée, une hache ou une masse. Les deux ont besoin d'une dague en main droite.]] },
			{ band = 3, title = "Finesse : frapper depuis le Camouflage", body = [[
Dès le niveau 1 (Attaque pernicieuse et Camouflage). Cet arbre se bat depuis le Camouflage : un premier coup fort, et beaucoup de points de combo avant que le combat commence vraiment. **Camouflage** = avancer en douce, pour que l'ennemi ne te voie pas. Les guides disent que monter de niveau seul est plus lent qu'avec Combat. Hémorragie est un talent, au plus tôt au niveau 30 : pas cher, de face, avec n'importe quelle arme, mais avec une dague elle frappe plus fort.Marque de mort est un talent, au plus tôt au niveau 40. Embuscade et Attaque sournoise ont besoin d'une dague en main droite ; Hémorragie et Frappe fantomatique, non.
**Ordre simple :**
1. Camouflage (**Shift-R**). Un deuxième Humanoïde à côté ? Assommer (**Shift-Q**). Assommer ne brise pas le Camouflage.
2. Préméditation (**Shift-C**, dès 20) : 2 points de combo sur l'ennemi. Puis ton premier coup.
3. Premier coup par derrière : Embuscade (**2**, dès 18, une dague en main droite). Ennemi fort, dès 26 : Coup bas (**V**), un étourdissement de 4 secondes. Les guides ne sont pas d'accord sur la meilleure ouverture.
4. Frappe fantomatique (**Shift-X**, dès 25) et Surin (**Shift-3**, dès 24) dès qu'ils sont prêts.
5. Points de combo : dès 30, Hémorragie (**3**). Avant ça : Attaque sournoise (**2**) quand tu es derrière l'ennemi, sinon Attaque pernicieuse (**1**).
6. Coup de grâce : Eviscération (**4**) quand l'ennemi est presque mort ; Rupture (**5**) sur un ennemi qui va vivre longtemps ; Débiter (**Shift-4**) dans un long combat.
7. Dès 40 : Marque de mort (**Q**) sur l'ennemi le plus fort, de préférence pendant que Rupture ou Garrot agit.
8. Urgence : Disparition (**X**). Préparation (**F3**, dès 30) rend Disparition, Evasion et Sprint de nouveau prêts tout de suite.
**Tous les 10 niveaux :**
- 10 : tu as déjà Attaque pernicieuse (**1**), Eviscération (**4**), Attaque sournoise (**2**), Camouflage (**Shift-R**), Suriner (**Shift-Q**) et Evasion (**Z**). Nouveau au 10 : Assommer (**Shift-Q** en Camouflage), Débiter (**Shift-4**), Sprint (**R**), et une arme dans chaque main. Puis Coup de pied (**E**) au 12, Garrot (**1** en Camouflage) au 14, Feinte (**F**) au 16, Embuscade (**2** en Camouflage) et En garde (passif) au 18.
- 20 : Préméditation (**Shift-C**, un talent) : 2 points de combo sur ta cible ; utilise-les dans les 20 secondes, sinon ils disparaissent ; cooldown 2 minutes. Rupture (**5**), et Poisons via une quête. Puis Disparition (**X**) au 22, Surin (**Shift-3**) au 24, Frappe fantomatique (**Shift-X**, un talent) au 25 : 40 Énergie, 1 point de combo, 15 % d'esquive en plus pendant 7 secondes ; cooldown 20 secondes. Coup bas (**V** en Camouflage) au 26. Les niveaux de talent indiqués ici sont les plus tôt possibles ; un avantage peut les avancer jusqu'à 5 niveaux.
- 30 : Hémorragie (**3**, un talent ; il te faut d'abord Lames dentelées) : 35 Énergie, 1 point de combo, marche de face ; pendant 15 secondes, ta Rupture et ton Garrot font 15 % de dégâts en plus à cet ennemi. Préparation (**F3**, un talent) : rend tes autres sorts de Voleur prêts tout de suite ; son propre cooldown est de 10 minutes. Tu reçois l'un des deux au 30, l'autre au 31. Aiguillon perfide (**V**). Puis Cécité (**Shift-V**) au 34, Couteau de jet (un talent, passif) au 35 : Surin peut donner 2 points de combo.
- 40 : Marque de mort (**Q**, un talent ; il te faut d'abord Préparation) : un coup de grâce, 25 Énergie, cooldown 10 secondes. Pendant 6 secondes, elle garde une partie de tes dégâts (plus par point de combo), puis les inflige d'un coup, jusqu'à une limite. Les dégâts de Rupture et de Garrot comptent double. Puis Débiter Rang 2 et Disparition Rang 2 au 42, Surin Rang 2 au 44, Marque de mort Rang 2 au 48.
- 50 : Aiguillon perfide Rang 2, Marque de mort Rang 3 au 56 ; rien de nouveau pour ce rôle.
- 60 : Marque de mort Rang 4 et des rangs plus forts ; rien de nouveau pour ce rôle.
**Erreurs de débutant :**
- Embuscade ou Attaque sournoise sans dague en main droite, ou de face.
- Utiliser Préméditation, puis attendre. Les 2 points disparaissent après 20 secondes, et le cooldown est de 2 minutes.
- Marque de mort sans points de combo. C'est un coup de grâce.]] },
		},
		HUNTER = {
			{ band = 1, title = "Maîtrise des bêtes : dégâts avec ton familier", body = [[
Dès le niveau 10 (ton familier, via les quêtes de classe). Ton familier fait la plus grande partie du travail : il occupe l'ennemi pendant que tu tires de loin. La plupart des guides choisissent Maîtrise des bêtes pour monter de niveau : ils la disent la plus facile et la plus rapide. Wowhead ajoute que les trois arbres fonctionnent. Nouveau dans Forever : Invocation de faucon (un talent, au plus tôt au niveau 25) envoie des oiseaux en plus sur ta cible. Point faible : les groupes d'ennemis. Ton familier ne peut en tenir qu'un.
**Ordre simple :**
Avant de commencer : Aspect du faucon actif (**Shift-R**). Le talent Aspects mortels ne marche qu'avec lui.
1. Marque du chasseur (**Shift-Z**).
2. Le familier d'abord (**Ctrl-1**), et attends qu'il ait l'ennemi.
3. Morsure de serpent (**2**).
4. Invocation de faucon (**Shift-F1**, dès 25) : garde 2 faucons tout le temps.
5. Visée (**4**, dès 20) pendant que tu restes immobile. Deux ennemis ou plus : Flèches multiples (**Shift-1**) à la place. Elles partagent un même cooldown.
6. Tir automatique (**1**) continue. Tir des arcanes (**3**) : avant 25, utilise-le simplement. Dès 25, seulement quand tu as déjà 2 faucons : il partage un cooldown avec Invocation de faucon.
7. Familier presque mort : Guérison du familier (**F2**). Ennemi sur toi : Intimidation (**Shift-3**, dès 30) ou Désengagement (**Z**, dès 20). Désengagement n'est pas un saut : de près, l'ennemi a moins envie de t'attaquer, et ton attaque automatique s'arrête. Vrai problème : Feindre la mort (**X**, dès 30).
8. Ennemi coriace : Courroux bestial (**F1**, dès 40) avec Tir rapide (**Q**, dès 26).
**Tous les 10 niveaux :**
- 10 : ton familier, via les quêtes de classe. Aspect du faucon (**Shift-R**). Premiers talents : Aspects mortels, Entraînement à l'Endurance. Les niveaux de talent indiqués ici sont les plus tôt possibles ; un avantage peut les avancer jusqu'à 5 niveaux. Puis Guérison du familier (**F2**) au 12, Flèches multiples (**Shift-1**) au 18.
- 20 : Visée (**4**, chez le maître de classe), Aspect du guépard (**R**), Désengagement (**Z**), Piège givrant (**V**). Talents : Rapidité bestiale (ton familier court 30 % plus vite ; il te la faut pour Intimidation), Fureur libérée, Science des chemins.
- 30 : Intimidation (**Shift-3**, un talent) : ton familier étourdit l'ennemi pendant 3 secondes avec son prochain coup ; cooldown 1 minute. Feindre la mort (**X**). Avant ça : Invocation de faucon (**Shift-F1**, un talent) au 25 : un faucon reste 18 secondes, 2 au plus à la fois. Tir rapide (**Q**) au 26.
- 40 : Courroux bestial (**F1**, un talent ; les 30 points d'avant doivent tous être en Maîtrise des bêtes) : ton familier fait 50 % de dégâts en plus pendant 18 secondes ; cooldown 2 minutes. Salve (bloc D). Avant ça : Piège explosif prend **Shift-2** au 34, Frénésie (un talent, passif) au 35.
- 50 : rangs plus forts d'Invocation de faucon, Visée et Guérison du familier ; rien de nouveau pour ce rôle. Après 40, les guides mettent tes points en Précision.
- 60 : encore des rangs plus forts ; rien de nouveau pour ce rôle.
**Erreurs de débutant :**
- Tirer avant que ton familier ait l'ennemi. L'ennemi vient alors vers toi.
- Voir Invocation de faucon et Tir des arcanes comme deux boutons séparés. Ils partagent un même cooldown : les faucons d'abord.
- Te battre en Aspect du guépard ou du singe. Aspects mortels ne marche qu'avec le Faucon actif.]] },
			{ band = 2, title = "Précision : dégâts à distance", body = [[
Dès le niveau 1 (Tir automatique). Tes propres tirs font le travail, de loin. Visée arrive au 20 chez le maître de classe : ce n'est pas un talent. Tir de précision est un talent, au plus tôt au niveau 40 : 4 secondes d'incantation, et une portée jusqu'à 45 mètres. Les guides disent que monter de niveau marche, mais plus lentement qu'en Maîtrise des bêtes : ton familier tient moins bien l'ennemi, parce que tu fais plus de dégâts. En groupe, c'est fort : Aura de précision aide tout ton groupe ou ton raid. Loup solitaire (un talent, au plus tôt au niveau 20) donne 20 % de dégâts en plus quand tu n'as pas de familier ; pour monter de niveau, les guides gardent le familier.
**Ordre simple :**
Avant de commencer : Aspect du faucon (**Shift-R**) et Aura de précision (**Shift-X**, dès 25) actifs.
1. Marque du chasseur (**Shift-Z**). Avec un familier : le familier d'abord (**Ctrl-1**).
2. Ennemi encore loin : Tir de précision (**Shift-4**, dès 40) pour ouvrir.
3. Morsure de serpent (**2**). Certains guides la sautent dans les combats courts.
4. Visée (**4**, dès 20) chaque fois qu'elle est prête. Reste immobile.
5. Tir des arcanes (**3**) entre les deux, si ton mana le permet.
6. Tir automatique (**1**) continue.
7. Un groupe d'ennemis : Flèches multiples (**Shift-1**) au lieu de Visée. Un grand groupe : Salve (bloc D, dès 40).
8. Ennemi sur toi : Flèche de dispersion (**E**, dès 30), puis recule. Trait de choc (**Shift-Q**) le ralentit.
9. Ennemi coriace : Tir rapide (**Q**, dès 26) au début.
**Tous les 10 niveaux :**
- 10 : ton familier, via les quêtes de classe. Aspect du faucon (**Shift-R**). Premiers talents : Attaques mortelles, Oeil de faucon, Trait de choc amélioré ; dès 15 : Visée minutieuse, Efficacité, Morsures et piqûres améliorées. Les niveaux de talent indiqués ici sont les plus tôt possibles ; un avantage peut les avancer jusqu'à 5 niveaux. Puis Flèches multiples (**Shift-1**) au 18.
- 20 : Visée (**4**), chez le maître de classe : 2 secondes d'incantation, cooldown 6 secondes, partagé avec Flèches multiples. Talents : Tueur rapide, Tir des arcanes amélioré, Loup solitaire. Aspect du guépard (**R**), Désengagement (**Z**), Piège givrant (**V**).
- 30 : Flèche de dispersion (**E**, un talent) : l'ennemi est désorienté pendant 4 secondes, et le moindre dégât le libère ; cooldown 30 secondes. Feindre la mort (**X**). Avant ça : Aura de précision (**Shift-X**, un talent) au 25 : plus de Puissance d'attaque à distance pour ton groupe, pendant 30 minutes. Tir rapide (**Q**) au 26.
- 40 : Tir de précision (**Shift-4**, un talent ; il te faut d'abord Aura de précision) : cooldown 15 secondes, et tes 3 prochains tirs portent 10 mètres plus loin. Salve (bloc D). Avant ça : Aura de précision Rang 2 chez le maître de classe au 32, Spécialisation Armes à distance (un talent, passif) au 35.
- 50 : rangs plus forts : Visée au 44 et au 52, Tir de précision au 48, Aura de précision et Salve au 50. Après 40, les guides mettent tes points en Maîtrise des bêtes.
- 60 : encore des rangs plus forts ; rien de nouveau pour ce rôle.
**Erreurs de débutant :**
- Bouger pendant Visée ou Tir de précision. Ils ont 2 et 4 secondes d'incantation.
- Flèches multiples sur un seul ennemi. Visée est alors bloquée elle aussi pendant 6 secondes.
- Tir de précision quand l'ennemi est déjà sur toi. C'est 4 secondes d'incantation, et ça ne marche pas à moins de 8 mètres.]] },
			{ band = 3, title = "Survie : dégâts au corps à corps, avec des pièges", body = [[
Dès le niveau 1 (Attaque du raptor), mais le vrai jeu Survie commence vers le 30. Dans Forever, c'est le Chasseur de corps à corps : Attaque du raptor, Morsure de la mangouste, Contre-attaque et Coup de trotteur, plus les pièges. Tu gardes ton familier et ton arme à distance : ouvre de loin, puis approche. Les guides la disent la plus lente des trois pour monter de niveau ; jusque vers le 30, tu joues comme n'importe quel Chasseur (le familier d'abord, puis tirer). Elle coûte beaucoup de mana, et un gros coup de ta part peut prendre l'ennemi à ton familier. Les guides ne sont pas d'accord sur la meilleure arme de corps à corps.
**Ordre simple :**
Avant de commencer : Aspect du faucon (**Shift-R**) pendant que tu tires. Dès 30, Aspect de la bête pour te battre de près ; il n'a pas de touche fixe, donc mets-le sur ta propre barre.
1. Marque du chasseur (**Shift-Z**). Sans la Marque, Exposition de proie ne marche pas.
2. Le familier d'abord (**Ctrl-1**).
3. Morsure de serpent (**2**), puis Tir des arcanes (**3**) pendant que l'ennemi arrive, ou pendant que tu marches vers lui.
4. Un piège à tes pieds : Piège d'Immolation (**Shift-2**, dès 16). Dès 34, cette touche est Piège explosif, et Piège d'Immolation n'a pas de touche : mets-le sur ta propre barre si tu le veux.
5. De près : Morsure de la mangouste (**Shift-C**, dès 16) dès qu'elle s'illumine. Attaque du raptor (**5**) chaque fois qu'elle est prête. Coup de trotteur (dès 30) chaque fois qu'il est prêt ; mets-le sur ta propre barre. Les guides ne sont pas d'accord : certains reculent pour tirer après Coup de trotteur, d'autres restent près.
6. Contre-attaque (**Shift-V**) juste après une parade.
7. L'ennemi s'enfuit, ou tu veux reprendre de la distance : Coupure d'ailes (**Shift-F**).
8. En difficulté : Dissuasion (**C**, dès 20), Feindre la mort (**X**, dès 30).
**Tous les 10 niveaux :**
- 10 : ton familier, via les quêtes de classe. Attaque du raptor (**5**), tu l'as dès le niveau 1. Premiers talents : Pistage amélioré, Déviation ; dès 15 : Frappes sauvages, Survivant, Piège, Coupure d'ailes améliorée. Les niveaux de talent indiqués ici sont les plus tôt possibles ; un avantage peut les avancer jusqu'à 5 niveaux. Puis Coupure d'ailes (**Shift-F**) au 12, Morsure de la mangouste (**Shift-C**) et Piège d'Immolation (**Shift-2**) au 16.
- 20 : Dissuasion (**C**, un talent) : 25 % d'esquive et de parade en plus pendant 10 secondes ; cooldown 5 minutes. Piège givrant (**V**), Visée (**4**), Ambidextrie (passif, chez le maître de classe). Désengagement (**Z**) : pas un saut ; de près, il baisse ta **menace** (à quel point un ennemi veut t'attaquer), et ton attaque automatique s'arrête. Talents : Pied sûr, Pièges astucieux.
- 30 : Coup de trotteur (un talent ; pas de touche fixe, mets-le sur ta propre barre) : 100 % des dégâts de l'arme, puis tu cours 30 % plus vite pendant 3 secondes ; cooldown 8 secondes. Aspect de la bête (chez le maître de classe ; mets-le sur ta propre barre) : plus de Puissance d’attaque. Feindre la mort (**X**). Avant ça : Contre-attaque (**Shift-V**, un talent), dès 25 ou 30 (les sources ne sont pas d'accord) : elle devient active après une parade, et immobilise l'ennemi pendant 5 secondes. Tranchant de prédateur (un talent, passif) dès 25. Aussi dans cette rangée : Exposition de proie, Ingéniosité, Discipline de survivaliste.
- 40 : Frappes lacérantes (un talent, passif ; il te faut d'abord Exposition de proie) : Morsure de la mangouste fait aussi saigner l'ennemi. Avant ça : Piège explosif prend **Shift-2** au 34, Réflexes éclairs (un talent, passif) au 35.
- 50 : rangs plus forts : Contre-attaque au 42 et au 54, Morsure de la mangouste au 44, Piège explosif au 44 et au 54, Attaque du raptor au 48, Aspect de la bête au 50. Les guides ne sont pas d'accord sur où mettre tes points après 40.
- 60 : encore des rangs plus forts ; rien de nouveau pour ce rôle.
**Erreurs de débutant :**
- Foncer droit sur l'ennemi. Ouvre de loin (Marque, familier, Morsure de serpent, un tir), puis approche.
- Appuyer sur Morsure de la mangouste ou Contre-attaque quand elles ne s'illuminent pas. Morsure de la mangouste ne marche qu'après une esquive (ou grâce à Exposition de proie), Contre-attaque seulement après une parade.
- Rester en Aspect du faucon de près après le niveau 30. Le Faucon n'aide que tes tirs ; la Bête donne de la Puissance d’attaque.]] },
		},
		SHAMAN = {
			{ band = 1, title = "Elémentaire : dégâts à distance", body = [[
Dès le niveau 1 : Eclair est là dès le début. La foudre et le feu, à distance. Horion de flammes arrive au 10, Chaîne d'éclairs au 32. Maîtrise de la foudre est un talent, au plus tôt au niveau 40. Les guides montent de niveau en Amélioration : Elémentaire marche, mais ses coûts en mana sont très élevés, tu dois rester immobile pour lancer tes sorts, et beaucoup d'ennemis à la fois, c'est difficile.
**Ordre simple :**
Avant de commencer : Bouclier de foudre (**Shift-Z**, dès 8) actif. Totem incendiaire (**5**, dès 10) posé avant d'attirer.
1. Ouvre de loin avec Eclair (**1**).
2. Horion de flammes (**2**, dès 10) sur un ennemi qui va vivre longtemps.
3. Eclair (**1**) pour remplir.
4. Trois ennemis ou plus : Nova de feu (**Shift-4**, dès 12) et Chaîne d'éclairs (**Shift-1**, dès 32) quand elles sont prêtes.
5. Maîtrise de la foudre (**Q**, dès 40) pour un élite ou un grand groupe.
6. Garde Horion de terre (**E**) pour le moment où l'ennemi lance un sort : il interrompt le sort.
Peu de vie : Vague de soins (**C**). Ennemi trop près : Totem de lien terrestre (**V**) ou Horion de givre (**4**, dès 20).
**Tous les 10 niveaux :**
- 10 : Eclair (**1**), Horion de terre (**E**, dès 4), Bouclier de foudre (**Shift-Z**, dès 8). Horion de flammes (**2**), Totem incendiaire (**5**, via une quête). Premiers talents : Convection, Commotion (passif). Les niveaux de talent indiqués ici sont les plus tôt possibles ; un avantage peut les avancer jusqu'à 5 niveaux. Puis Nova de feu (**Shift-4**) et Expiation (**Shift-Q**) au 12, Totem de Séisme (**Shift-F**) au 18.
- 20 : Horion de givre (**4**), Loup fantôme (**R**), Appel des éléments (**Ctrl-1**). Focalisation élémentaire (un talent, passif). Puis Appel totémique (**Shift-R**) au 22. Lien terrestre (un talent) au 25 : Totem de lien terrestre (**V**) immobilise les ennemis pendant 5 secondes, seulement au moment où tu le poses. Totem de Magma (bloc D) au 26.
- 30 : Appel de la foudre (un talent, passif). Totem de Glèbe (**X**), Appel des ancêtres (**Ctrl-2**), Réincarnation (passif). Surcharge de foudre (un talent, passif). Puis Chaîne d'éclairs (**Shift-1**) au 32, Fureur élémentaire (un talent, passif) au 35.
- 40 : Maîtrise de la foudre (**Q**, un talent) : pendant 15 secondes, Eclair s'incante 0,5 seconde plus vite et Chaîne d'éclairs n'a pas de cooldown ; cooldown 3 minutes. Appel des esprits (**Ctrl-3**), Salve de guérison (**Shift-2**). Mailles chez le maître de classe.
- 50 : rangs plus forts d'Eclair, Chaîne d'éclairs, Horion de terre, Horion de flammes, Nova de feu et Totem incendiaire ; rien de nouveau pour ce rôle.
- 60 : encore des rangs plus forts ; rien de nouveau pour ce rôle.
**Erreurs de débutant :**
- Horion de terre pour faire des dégâts en groupe. Il crée beaucoup de **menace** (à quel point un ennemi veut t'attaquer). Et il partage son cooldown avec Horion de flammes : après ça, tu n'as plus d'interruption.
- Chaîne d'éclairs sur un seul ennemi. Elle coûte beaucoup de mana et a un cooldown de 6 secondes.
- Achever chaque ennemi avec un sort. Le mana est ta limite : frappe avec ton arme un ennemi presque mort.]] },
			{ band = 2, title = "Amélioration : dégâts au corps à corps", body = [[
Dès le niveau 1 : tu frappes avec ton arme, avec Arme Croque-roc dessus. Les guides montent de niveau en Amélioration : ils disent que c'est le choix confortable. Prends une arme lente à deux mains. Courroux naturel est un talent, au plus tôt au niveau 25 ; Arme Furie-des-vents arrive au 30 chez le maître de classe. Le mana est ta limite : quand il baisse, arrête de lancer des sorts et continue à frapper. Le conseil d'un guide pour le buff d'arme : Arme Croque-roc seule, Arme Langue de feu en groupe, Arme Furie-des-vents dès 30. En petit groupe, Amélioration peut tanker un moment avec Arme Croque-roc (Armes spirituelles donne alors plus de menace), mais il n'y a ni provocation ni cooldown défensif.
**Ordre simple :**
Avant de commencer : buff d'arme actif (bloc D), Bouclier de foudre (**Shift-Z**), Totem incendiaire (**5**) ou tes totems posés.
1. Attire avec Eclair (**1**). **Attirer** = frapper un ennemi de loin, pour qu'il vienne vers toi.
2. Courroux naturel (**3**, dès 25) dès qu'il est prêt.
3. Eclair (**1**) à 5 cumuls d'Arme du Maelström (dès 35) : il est alors instantané et gratuit.
4. Horion de terre (**E**). En groupe, alterne avec Horion de flammes (**2**).
5. Nova de feu (**Shift-4**, dès 12) quand un totem de Feu est posé et que tu as du mana en trop ; surtout contre plus d'ennemis.
6. Rage long-voyante (**Q**, dès 40) pour un élite ou un gros groupe attiré.
7. Sinon, continue simplement à frapper.
Après le combat : Vague de soins (**C**). Urgence pendant un combat : Vague de soins inférieurs (**F2**, dès 20).
**Tous les 10 niveaux :**
- 10 : Arme Croque-roc (bloc D), Eclair (**1**), Horion de terre (**E**, dès 4), Bouclier de foudre (**Shift-Z**, dès 8). Horion de flammes (**2**), Totem incendiaire (**5**), Totem de Force de la Terre (**Shift-X**), Arme Langue de feu (bloc D). Premiers talents : Frappe foudroyante et d'autres (passifs) ; Dextérité mentale (passif) dès 15. Les niveaux de talent indiqués ici sont les plus tôt possibles ; un avantage peut les avancer jusqu'à 5 niveaux. Puis Nova de feu (**Shift-4**) au 12.
- 20 : Loup fantôme (**R**), Horion de givre (**4**), Vague de soins inférieurs (**F2**), Appel des éléments (**Ctrl-1**). Focalisation chamanique (un talent, passif) : les horions et Bouclier de foudre coûtent 45 % de mana en moins. Puis Courroux naturel (**3**, un talent) au 25. Rafale (un talent, passif) dès 25. Loup fantôme amélioré (un talent) dès 25 : Loup fantôme est plus rapide (instantané avec les deux points) et marche aussi à l'intérieur ; les guides le prennent à des niveaux très différents. Totem de Magma (bloc D) au 26.
- 30 : Arme Furie-des-vents (bloc D). Frappe-tempête amélioré et Armes spirituelles (des talents). Totem de Glèbe (**X**), Appel des ancêtres (**Ctrl-2**). Puis Totem Furie-des-vents au 32 (pas de touche : utilise la Barre de totems), Chaîne d'éclairs (**Shift-1**) au 32, Arme du Maelström (un talent, passif) au 35.
- 40 : Rage long-voyante (**Q**, un talent) : tu frappes 30 % plus vite pendant 25 secondes ; seulement les coups de ton arme, pas tes sorts. Cooldown 3 minutes. Tous les guides ne la prennent pas au 40 : certains vont d'abord en Restauration pour le mana. Appel des esprits (**Ctrl-3**), les Mailles, une Arme Furie-des-vents plus forte. Puis Totem de Grâce aérienne au 42 (pas de touche : utilise la Barre de totems).
- 50 : rangs plus forts d'Arme Furie-des-vents, Arme Croque-roc, Horion de terre, Eclair et Totem de Force de la Terre ; rien de nouveau pour ce rôle.
- 60 : encore des rangs plus forts ; rien de nouveau pour ce rôle.
**Erreurs de débutant :**
- Eclair avec moins de 5 cumuls d'Arme du Maelström. Il remet ton temps d'attaque à zéro. Et Arme du Maelström n'aide qu'Eclair : pas les soins, pas Chaîne d'éclairs.
- Arme Croque-roc en groupe quand c'est toi qui fais les dégâts, une fois que tu as Armes spirituelles. Avec Croque-roc, tu crées 30 % de menace en plus, sans elle 30 % en moins. Utilise Langue de feu ou Furie-des-vents.
- Chercher une provocation. Le Chaman n'en a pas. Totem de Griffes de pierre (**F**) force les ennemis à attaquer le totem, pas toi.]] },
			{ band = 3, title = "Restauration : soigneur", body = [[
Dès le niveau 1 : Vague de soins est là dès le début, et c'est ton soin principal pour monter de niveau. Les guides déconseillent de monter de niveau seul en Restauration (les ennemis meurent lentement), mais elle est bonne en groupe. Entre les donjons, tu fais tes quêtes avec Eclair et Horion de flammes. Remous est un talent, au plus tôt au niveau 40. Un Chaman peut retirer le Poison et la Maladie, mais pas les malédictions ni la magie.
**Ordre simple (en groupe) :**
Avant de commencer : Bouclier d’eau (**Shift-Z**, dès 20). Totems posés : Appel des éléments (**Ctrl-1**, dès 20) ou Totem guérisseur (**F4**, dès 20).
1. Remous (**Shift-F1**, dès 40) sur le tank ou sur celui qui prend des dégâts.
2. Salve de guérison (**Shift-2**, dès 40) sur cette même cible quand plus de gens sont blessés.
3. Vague de soins (**C**) pour une personne ou pour le tank.
4. Vague de soins inférieurs (**F2**, dès 20) quand ça doit aller vite.
5. Urgence : Rapidité de la nature (**Shift-3**, dès 30), puis Vague de soins (**C**).
6. Totem de Vague de mana (**F1**, dès 25) quand ton mana s'épuise.
7. Personne n'est blessé : Eclair (**1**).
**Tous les 10 niveaux :**
- 10 : Vague de soins (**C**). Premiers talents : Vague de soins améliorée (une Vague de soins plus rapide), Focalisation des flots (passif). Les niveaux de talent indiqués ici sont les plus tôt possibles ; un avantage peut les avancer jusqu'à 5 niveaux. Puis Esprit ancestral (**F3**, hors combat) au 12, Guérison du poison (**Shift-C**) au 16, Totem de Séisme (**Shift-F**) au 18.
- 20 : Vague de soins inférieurs (**F2**), Totem guérisseur (**F4**, via une quête), Appel des éléments (**Ctrl-1**), Loup fantôme (**R**). Bouclier d’eau (**Shift-Z**, un talent) : 3 globes d'eau ; quand tu es frappé ou qu'un de tes sorts fait un critique, tu récupères 2 % de ton mana par globe. Il dure 10 minutes. À partir de là, Shift-Z lance Bouclier d’eau, pas Bouclier de foudre. Puis Guérison des maladies (**Shift-V**) au 22. Totem de Vague de mana (**F1**, un talent) au 25 : rend du mana à ton groupe ; cooldown 5 minutes. Totem Fontaine de mana au 26 (pas de touche : utilise la Barre de totems).
- 30 : Rapidité de la nature (**Shift-3**, un talent) : ton prochain sort de Nature avec moins de 10 secondes d'incantation est instantané ; cooldown 3 minutes. Flots de soins (un talent, passif). Totem de Glèbe (**X**), Appel des ancêtres (**Ctrl-2**), Réincarnation (passif). Puis Purification (un talent, passif) au 35, un Totem de Vague de mana plus fort au 38.
- 40 : Salve de guérison (**Shift-2**). Remous (**Shift-F1**, un talent ; il te faut d'abord Flots de soins) : un soin sur 15 secondes, pas un soin instantané, et une Salve de guérison que tu lances directement sur cette cible soigne 25 % de plus ; cooldown 12 secondes. Appel des esprits (**Ctrl-3**), les Mailles.
- 50 : rangs plus forts de Remous, Salve de guérison, Vague de soins, Vague de soins inférieurs, Totem de Vague de mana et Totem guérisseur ; rien de nouveau pour ce rôle.
- 60 : encore des rangs plus forts ; rien de nouveau pour ce rôle.
**Erreurs de débutant :**
- Salve de guérison sur quelqu'un d'autre que ta cible de Remous. Le bonus ne compte que quand tu la lances directement sur cette cible.
- Appuyer seulement sur Rapidité de la nature. Elle ne soigne rien toute seule : elle rend ton prochain sort de Nature instantané. Appuie sur Vague de soins juste après.
- Essayer de retirer une malédiction. Un Chaman ne peut pas ; seulement le Poison (**Shift-C**) et la Maladie (**Shift-V**).]] },
		},
		WARLOCK = {
			{ band = 1, title = "Affliction : dégâts sur la durée", body = [[
Dès le niveau 4 (Corruption) et 8 (Plaie d'agonie). Tu poses des DoT sur l'ennemi et tu laisses ton démon le tenir. La plupart des guides montent de niveau en Affliction. Siphon de vie est un talent, au plus tôt au niveau 30. Calvaire est un talent, au plus tôt au niveau 40 : pendant que tu le canalises, ton Siphon de vie, ta Corruption et ta Plaie d'agonie sur cet ennemi font leurs dégâts 100 % plus vite. Calvaire ne te soigne pas.
**Ordre simple :**
1. Envoie ton démon (**Ctrl-1**).
2. Plaie d'agonie (**5**) pour attirer. Ses dégâts commencent bas, donc ton démon prend l'ennemi.
3. Corruption (**2**). Avec Corruption améliorée 5/5, elle est instantanée (au plus tôt au 14).
4. Siphon de vie (**F4**, dès 30), seulement sur un ennemi qui va vivre longtemps.
5. Immolation (**3**) seulement sur un ennemi coriace.
6. Ennemi coriace : ajoute ta malédiction (**Shift-V**). Les guides ne sont pas d'accord sur le moment.
7. Pour remplir : jusque vers le niveau 30, ta baguette (Tir ; pas sur le bloc, mets-le sur ta propre barre), puis Drain de vie (**C**). Les guides ne sont pas tout à fait d'accord sur le moment de changer.
8. Transe de l'ombre s'illumine (Crépuscule, dès 25) ? Trait de l'ombre (**1**) : il est alors instantané.
9. Dès 40 : Calvaire (bloc D) au lieu de Drain de vie quand ta vie va bien. Pose d'abord tes DoT.
10. Plus de vie que de mana ? Connexion (**F**).
11. Besoin d'un Fragment d'âme ? Achève l'ennemi avec Siphon d'âme (**4**).
Deux ennemis : des DoT sur le premier, Peur (**V**) sur lui, puis bats-toi contre le second. Les dégâts peuvent briser la Peur, et les guides ne sont pas d'accord sur les DoT avant la Peur.
**Tous les 10 niveaux :**
- 10 : Siphon d'âme (**4**), Création de Pierre de soins (bloc D), le Marcheur du Vide (quête). Tu as déjà Trait de l'ombre (**1**), Immolation (**3**), Corruption (**2**, 4), Malédiction de faiblesse (**Shift-V**, 4), Connexion (**F**, 6), Plaie d'agonie (**5**, 8) et Peur (**V**, 8). Premier talent : Corruption améliorée ou Suppression (les guides ne sont pas d'accord). Les niveaux de talent indiqués ici sont les plus tôt possibles ; un avantage peut les avancer jusqu'à 5 niveaux. Puis Captation de vie (**F2**) au 12 ; Drain de vie (**C**) et Corruption Rang 2 (15 secondes) au 14 ; Drains améliorés et Récolte d’âmes (des talents, passifs) dès 15 ; Douleur brûlante (bloc D) et Création de pierre d'âme au 18.
- 20 : Malédiction amplifiée (**Shift-3**, un talent) : ta prochaine Malédiction de faiblesse ou Plaie d'agonie est 50 % plus forte ; cooldown 3 minutes. Malédiction des éléments (**Shift-V**), Armure démoniaque (**Shift-Z**), Pluie de feu (**Shift-1**), la Succube ou l'Incube (quête). Puis Corruption Rang 3 (18 secondes) et Drain de mana au 24. Malédiction de fatigue (**R**, un talent ; il te faut d'abord Malédiction amplifiée) au 25 : l'ennemi est 30 % plus lent pendant 12 secondes. Crépuscule (un talent, passif) au 25 : une petite chance que ton prochain Trait de l'ombre soit instantané. Bannir (**Shift-Q**) au 28.
- 30 : Siphon de vie (**F4**, un talent) : prend de la vie à l'ennemi et te la donne, pendant 30 secondes. Siphon d’âme (un talent, passif) : Drain de vie, Siphon d'âme et Calvaire font plus pour chacun de tes Corruption, Siphon de vie et Plaie d'agonie sur l'ennemi. Drain de vie Rang 3, Flammes infernales (**Shift-2**), le Chasseur corrompu (quête). Puis Gardien de l'ombre (**Z**) au 32, Maîtrise de l'ombre (un talent, passif) au 35, Siphon de vie Rang 2 et Drain de vie Rang 4 au 38.
- 40 : Calvaire (bloc D, un talent ; il te faut d'abord Siphon de vie) : un sort canalisé de 6 secondes qui fait des dégâts chaque seconde et fait agir tes DoT sur cet ennemi 100 % plus vite. Hurlement de terreur (**Shift-F**), le Palefroi corrompu (quête). Puis Voile mortel (**X**) au 42, Feu de l'âme (**Q**) et Siphon de vie Rang 3 au 48.
- 50 : Inferno (**F3**). Malédiction des éléments Rang 4. Sinon, des rangs plus forts.
- 60 : Plaie funeste (**F1**) : un gros coup après 60 secondes ; pas sur les joueurs. Sinon, des rangs plus forts.
**Erreurs de débutant :**
- Remettre Plaie d'agonie trop tôt. Ses tics les plus forts arrivent à la fin.
- Utiliser Calvaire quand tu as besoin de vie. Calvaire ne soigne pas ; Drain de vie, oui.
- Malédiction de témérité sur l'ennemi que tu veux apeurer avec Peur. Cet ennemi ignore la Peur.]] },
			{ band = 2, title = "Démonologie : dégâts avec ton démon", body = [[
Dès le niveau 1 (le Diablotin), vraiment dès 10 (le Marcheur du Vide). Ton démon fait une grande partie du travail, et les talents le rendent plus fort. Les guides ne sont pas d'accord sur le moment d'aller dans cet arbre : certains y vont dès 10, d'autres montent d'abord en Affliction et changent vers 26 ou 27. Sacrifice démoniaque (au plus tôt au 20) ne vaut le coup qu'avec Pacte démoniaque (au plus tôt au 40). Avant ça, chaque démon que tu invoques retire le buff.
**Ordre simple :**
1. Envoie ton démon (**Ctrl-1**), et laisse-le frapper en premier.
2. Dès 30 : Lien spirituel (**Shift-X**) actif, et de nouveau après chaque invocation.
3. Dès 25 (Marque démoniaque) : Douleur brûlante (bloc D) sur l'ennemi de ton démon. De nouveau quand la marque est partie (10 secondes). Avant Marque démoniaque : pas de Douleur brûlante.
4. Plaie d'agonie (**5**) et Corruption (**2**) sur les ennemis qui vivent assez longtemps. Corruption a ici 2 secondes d'incantation.
5. Pour remplir : ta baguette (pas sur le bloc, mets-la sur ta propre barre) ou Trait de l'ombre (**1**). Drain de vie (**C**) quand tu as besoin de vie.
6. Démon presque mort : Captation de vie (**F2**). Elle coûte ta propre vie.
7. Connexion (**F**). Avec Énergie démoniaque, ton démon reçoit aussi du mana.
8. Dès 40 (Pacte démoniaque) : Sacrifice démoniaque (**Shift-C**) sur un démon, puis invoque un autre démon (bloc D). Le buff dure 2 heures. Les guides ne sont pas d'accord sur le démon à sacrifier.
9. Dès 48, avec Décimation : ennemi sous 35 % de vie ? Trait de l'ombre ou Douleur brûlante, puis Feu de l'âme (**Q**) : plus rapide, et sans Fragment d'âme.
**Tous les 10 niveaux :**
- 10 : le Marcheur du Vide (quête ; coûte 1 Fragment d'âme). Son Tourment donne de la **menace** (à quel point un ennemi veut l'attaquer). Siphon d'âme (**4**) pour les fragments. Premiers talents : Puissance impie, Baiser démoniaque, Diablotin amélioré, Captation de vie améliorée (passifs). Les niveaux de talent indiqués ici sont les plus tôt possibles ; un avantage peut les avancer jusqu'à 5 niveaux. Puis Captation de vie (**F2**) au 12 ; Énergie démoniaque, Vitalité gangrenée et Marcheur du Vide amélioré (des talents, passifs) dès 15 ; Sacrifice (Marcheur du Vide) au 16 ; Consumer les ombres (Marcheur du Vide) et Douleur brûlante (bloc D) au 18.
- 20 : Sacrifice démoniaque (**Shift-C**, un talent) : tu sacrifies ton démon pour un buff de 2 heures. Diablotin : 15 % de dégâts d'ombre en plus. Succube ou Incube : 15 % de dégâts de feu en plus. Marcheur du Vide : du mana rendu. Chasseur corrompu : de la vie rendue. Maître invocateur (un talent, passif) : les invocations sont plus rapides et moins chères. La Succube ou l'Incube (quête). Armure démoniaque (**Shift-Z**). Puis Souffrance (Marcheur du Vide) au 24. Domination corrompue (**Shift-F1**, un talent ; il te faut d'abord Maître invocateur) au 25 : ta prochaine invocation est 5,5 secondes plus rapide et 50 % moins chère. Marque démoniaque et Décimation (des talents, passifs) dès 25.
- 30 : Lien spirituel (**Shift-X**, un talent ; il te faut d'abord Sacrifice démoniaque) : 30 % des dégâts que tu prends vont à ton démon, et vous faites tous les deux 3 % de dégâts en plus. Il dure tant que ton démon est là. Le Chasseur corrompu (quête ; Verrou magique au 36). Connaissance démoniaque (un talent, passif). Puis Maître démonologue (un talent, passif) dès 35.
- 40 : Pacte démoniaque (un talent, passif ; il te faut d'abord Lien spirituel) : le buff de Sacrifice démoniaque reste quand tu invoques un autre démon. C'est seulement maintenant que Sacrifice démoniaque vaut le coup. Hurlement de terreur (**Shift-F**), le Palefroi corrompu (quête). Puis Voile mortel (**X**) au 42, Feu de l'âme (**Q**) au 48.
- 50 : Inferno (**F3**) : un infernal ; 1 Pierre infernale à chaque fois ; cooldown 1 heure. Sinon, des rangs plus forts.
- 60 : Plaie funeste (**F1**). Sinon, des rangs plus forts.
**Erreurs de débutant :**
- Douleur brûlante avant d'avoir Marque démoniaque. Elle crée beaucoup de menace et prend l'ennemi à ton démon.
- Sacrifice démoniaque avant Pacte démoniaque (40). Ton démon est parti, et invoquer n'importe quel démon retire le buff.
- Après Pacte démoniaque, invoquer le même démon que celui que tu as sacrifié. Le buff est alors parti.]] },
			{ band = 3, title = "Destruction : dégâts avec de gros coups", body = [[
Dès le niveau 1 (Trait de l'ombre et Immolation). De gros coups de feu et d'ombre, et c'est ce qui coûte le plus de mana. Certains guides déconseillent de monter de niveau avec (beaucoup de mana, peu de moyens d'en récupérer) ; d'autres le disent jouable, et un guide le dit fort en donjon. Conflagration est un talent, au plus tôt au niveau 25 ; Incinérer est un talent, au plus tôt au niveau 40. Le tournant, c'est Ombre et flammes 5/5 (au plus tôt au 39) : à partir de là, Conflagration ne consomme plus ton Immolation, et Brûlure de l'ombre te rend toujours son Fragment d'âme.
**Ordre simple :**
1. Envoie ton démon (**Ctrl-1**).
2. Immolation (**3**). Un guide ouvre avec Trait de l'ombre de loin, avec Immolation juste après.
3. Ennemi coriace : Plaie d'agonie (**5**) et ta malédiction (**Shift-V**).
4. Dès 25 : Conflagration (bloc D). Avant Ombre et flammes 5/5, elle consomme ton Immolation : utilise-la à la fin d'Immolation, ou comme dernier coup. Après : chaque fois qu'elle est prête.
5. Pour remplir : Trait de l'ombre (**1**). Dès 40, Incinérer (bloc D), avec Immolation sur l'ennemi.
6. Dès 20 : Brûlure de l'ombre (**Shift-4**) comme dernier coup. Tu récupères alors le Fragment d'âme.
7. Connexion (**F**) entre les combats. Peu de mana : ta baguette (pas sur le bloc, mets-la sur ta propre barre).
8. Plus d'ennemis : dès 30, Plaie de tumulte (bloc D) sur un ennemi coriace, puis attaque les autres. Pluie de feu (**Shift-1**). Flammes infernales (**Shift-2**, dès 30) seulement avec assez de vie.
**Tous les 10 niveaux :**
- 10 : Trait de l'ombre (**1**) et Immolation (**3** ; Rang 2 au 10). Premier talent : Fléau (des incantations plus rapides) ou Trait de l'ombre amélioré. Les niveaux de talent indiqués ici sont les plus tôt possibles ; un avantage peut les avancer jusqu'à 5 niveaux. Puis Trait de l'ombre Rang 3 au 12 (2,8 secondes d'incantation) ; Conséquences et Cataclysme (des talents, passifs) dès 15 ; Douleur brûlante (bloc D) au 18.
- 20 : Brûlure de l'ombre (**Shift-4**, un talent) : un coup d'ombre instantané ; coûte 1 Fragment d'âme ; cooldown 15 secondes. Si l'ennemi (un qui rapporte des PX) meurt dans les 8 secondes, tu récupères un fragment. Ruine (un talent, passif) : tes critiques de Destruction frappent plus fort. Pluie de feu (**Shift-1**). Trait de l'ombre Rang 4 (3 secondes d'incantation). Puis Brûlure de l'ombre Rang 2 au 24. Conflagration (bloc D, un talent) au 25 : un coup de feu instantané sur un ennemi qui a ton Immolation ; cette Immolation disparaît alors ; cooldown 10 secondes. Flammes déchirantes et Intensité (des talents, passifs) dès 25.
- 30 : Plaie de tumulte (bloc D, un talent) : 5 minutes sur un ennemi ; 15 % de tous tes dégâts sur les autres ennemis frappent aussi celui-ci. Un seul ennemi à la fois. Feu et soufre (il te faut d'abord Conflagration) et Pyroclasme (il te faut d'abord Intensité), des talents, passifs. Flammes infernales (**Shift-2**). Puis Conflagration Rang 2 et Brûlure de l'ombre Rang 3 au 32 ; Ombre et flammes (un talent, passif) dès 35, 5/5 au plus tôt au 39.
- 40 : Incinérer (bloc D, un talent ; il te faut d'abord Plaie de tumulte) : 2,5 secondes d'incantation, 25 % de dégâts en plus quand l'ennemi a ton Immolation. Conflagration Rang 3, Brûlure de l'ombre Rang 4. Puis Feu de l'âme (**Q**) au 48.
- 50 : Incinérer Rang 2. Inferno (**F3**).
- 60 : Incinérer Rang 3, Conflagration Rang 6. Plaie funeste (**F1**).
**Erreurs de débutant :**
- Conflagration juste après Immolation. Elle consomme ton Immolation (jusqu'à Ombre et flammes 5/5).
- Brûlure de l'ombre sans Fragment d'âme, ou sur un ennemi qui va vivre longtemps. Le fragment ne revient que si l'ennemi meurt dans les 8 secondes.
- Plaie de tumulte et Plaie d'agonie sur le même ennemi. Une seule plaie tient sur lui.]] },
		},
		PALADIN = {
			{ band = 1, title = "Sacré : soigneur", body = [[
Dès le niveau 1 : Lumière sacrée est là dès le début. Un **soigneur** garde le groupe en vie. Les guides disent que Sacré est l'arbre le plus lent pour monter de niveau seul : monte de niveau en Vindicte et soigne en donjon, ou joue Sacré avec un ami. Les boutons propres à l'arbre arrivent au 20 (Faveur divine), au 25 (Serment de lumière), au 30 (Horion sacré) et au 40 (Vigile de Lumière).
**Ordre simple (en groupe) :**
Avant d'attirer : Bénédiction de sagesse (**Shift-V**, dès 14) sur toi, Bénédiction des rois (**Shift-X**, dès 20) sur les autres. Aura : Aura de dévotion (**Ctrl-1**), ou Aura de concentration (**Ctrl-3**, dès 22) quand les lanceurs de sorts sont souvent frappés.
1. Serment de lumière (**Shift-R**, dès 25) sur le tank. Il dure 5 minutes, et un seul joueur peut l'avoir.
2. Eclair lumineux (**F2**, dès 20) est ton soin normal. Avant 20 : Lumière sacrée (**C**).
3. Lumière sacrée (**C**) pour un gros coup. Dès 25 (Imprégnation de lumière), elle s'incante plus vite juste après un critique d'Horion sacré ou d'Eclair lumineux. **Critique** = un coup ou un soin chanceux, plus fort.
4. Horion sacré (**F4**, dès 30) quand il n'y a pas le temps d'incanter, ou pendant que tu bouges.
5. Tout le groupe blessé, dès 40 : Vigile de Lumière (**Shift-F1**) sur un joueur, puis Horion sacré (**F4**) sur ce même joueur.
6. Faveur divine (**Shift-3**, dès 20) avant un soin qui doit être gros.
7. Un effet négatif sur un ami : Purification, plus tard Epuration (**Shift-C**).
8. Urgence : Imposition des mains (**Q**). Elle consomme tout le mana qu'il te reste.
Rien à soigner : ton sceau (**3**), Jugement (**2**) et Frappe sacrée (**1**) au corps à corps. Seul : joue comme un Paladin Vindicte ; dès 30, Horion sacré (**F4**) sur l'ennemi est ton seul bouton de dégâts fort.
**Tous les 10 niveaux :**
- 10 : tu as déjà Lumière sacrée (**C**), Aura de dévotion (**Ctrl-1**), Bénédiction de puissance (**Shift-Z**), Protection divine (**Z**), Marteau de la justice (**E**) et Purification (**Shift-C**). Nouveau au 10 : Imposition des mains (**Q**), Bénédiction de protection (**Shift-F**). Premier talent : Focalisation spirituelle (passif). Les niveaux de talent indiqués ici sont les plus tôt possibles ; un avantage peut les avancer jusqu'à 5 niveaux. Puis Rédemption (**F3**, via une quête) au 12, Bénédiction de sagesse (**Shift-V**) au 14, Révérence et Lumière guérisseuse (des talents, passifs) dès 15, Bénédiction de liberté (**R**) au 18.
- 20 : Eclair lumineux (**F2**), Bénédiction des rois (**Shift-X**). Faveur divine (**Shift-3**, un talent) : ton prochain Eclair lumineux, Lumière sacrée ou Horion sacré fait à coup sûr un critique ; cooldown 2 minutes. Illumination (un talent, passif ; il te faut d'abord Révérence). Puis Aura de concentration (**Ctrl-3**) au 22. Serment de lumière (**Shift-R**, un talent) et Imprégnation de lumière (un talent, passif) au 25.
- 30 : Horion sacré (**F4**, un talent) : instantané, des dégâts sur un ennemi ou un soin sur un ami ; cooldown 10 secondes. Intervention divine (**F3** en combat : tu meurs toi-même). Sceau de lumière (bloc D). Puis Bouclier divin (**Z**) au 34, Puissance sacrée (un talent, passif) au 35, Sceau de sagesse (bloc D) au 38.
- 40 : Vigile de Lumière (**Shift-F1**, un talent ; il te faut d'abord Horion sacré) : sur un ami pendant 30 secondes ; ton prochain Horion sacré sur cet ami n'a pas de cooldown et soigne aussi son groupe. Horion sacré Rang 2. Armure en plaques : tu peux porter des plaques. Puis Epuration (**Shift-C**) au 42, Bénédiction de sacrifice (bloc D) au 46, Horion sacré Rang 3 au 48.
- 50 : Vigile de Lumière Rang 2, Imposition des mains Rang 3. Puis Bénédiction de puissance supérieure au 52 et Bénédiction de sagesse supérieure au 54, Horion sacré Rang 4 au 56.
- 60 : Bénédiction des rois supérieure, Vigile de Lumière Rang 3 ; rien de nouveau pour ce rôle.
**Erreurs de débutant :**
- Lumière sacrée pour chaque petit coup. Eclair lumineux (**F2**, dès 20) est le soin normal, pas cher.
- Vigile de Lumière sur un joueur et Horion sacré sur un autre. Le soin de groupe ne vient que d'Horion sacré sur le MÊME joueur.
- Appuyer sur F3 en combat par erreur. Elle lance alors Intervention divine, et tu meurs toi-même. Hors combat, F3 est Rédemption.]] },
			{ band = 2, title = "Protection : tank", body = [[
Dès le niveau 10 (Fureur vertueuse et Sceau de fureur chez le maître de classe). Le **tank**, c'est celui que les ennemis frappent, pour que le reste du groupe reste à l'abri. **Menace** = à quel point un ennemi veut t'attaquer. Tu portes une arme à une main et un bouclier. Les guides ne sont pas d'accord sur le fait que Protection monte bien de niveau seul. Les boutons de l'arbre : Rempart de templier au 20, Jugement rapide au 25, Bouclier sacré au 30.
**Ordre simple :**
1. Avant d'attirer : Fureur vertueuse active (pas de touche fixe : elle est sur le bloc D, ou mets-la sur ta propre barre ; elle dure 30 minutes). Sceau de fureur (**F**), une bénédiction, une aura. Les guides ne sont pas d'accord sur l'aura : Aura de dévotion (**Ctrl-1**) ou Aura de vindicte (**Ctrl-2**).
2. Dès 30 : Bouclier sacré (**Shift-4**) juste avant que les ennemis t'atteignent. Appuie de nouveau dessus chaque fois qu'il est prêt.
3. Jugement (**2**) sur le premier ennemi. Avec Sceau de fureur actif, Jugement est ta provocation (3 secondes). **Provocation** = forcer l'ennemi à t'attaquer.
4. Deux ennemis ou plus, dès 20 : Consécration (**Shift-1**) sous eux. Seuls les 4 premiers prennent les dégâts en plus.
5. Frappe sacrée (**1**) chaque fois qu'elle est prête.
6. Un ennemi court vers quelqu'un d'autre : Jugement (**2**). Pas prêt ? Dès 25 : Jugement rapide (**F1**), un deuxième Jugement avec son propre cooldown de 1 minute.
7. Un ennemi lance un sort : Marteau de la justice (**E**). Le Paladin n'a pas d'interruption.
8. Exorcisme (**5**, dès 20) sur les Morts-vivants et les Démons. Marteau de courroux (**4**, dès 44).
9. De gros dégâts arrivent, dès 20 : Rempart de templier (**X**). Dernier recours : Imposition des mains (**Q**).
Peu de mana : arrête d'abord Consécration. Dès 40 (Serment du bouclier) : Bouclier sacré d'abord, puis Frappe sacrée. Tu n'es pas le tank (seul, ou quelqu'un d'autre tanke) : utilise ton sceau sur **3**, pas Sceau de fureur.
**Tous les 10 niveaux :**
- 10 : Fureur vertueuse (bloc D) et Sceau de fureur (**F**). Tu as déjà Jugement (**2**), Frappe sacrée (**1**), Marteau de la justice (**E**), Aura de dévotion (**Ctrl-1**) et Protection divine (**Z**). Aussi nouveau : Imposition des mains (**Q**), Bénédiction de protection (**Shift-F**). Premier talent : Redoute (passif). Les niveaux de talent indiqués ici sont les plus tôt possibles ; un avantage peut les avancer jusqu'à 5 niveaux. Puis Précision, Faveur du Gardien ou Devoir sacré (des talents, passifs) dès 15, Aura de vindicte (**Ctrl-2**) au 16.
- 20 : Rempart de templier (**X**, un talent) : un bouclier qui absorbe autant de dégâts que ta vie maximum, pendant 8 secondes ; cooldown 5 minutes. Consécration (**Shift-1**), Bénédiction des rois (**Shift-X**), Exorcisme (**5**). Spécialisation Bouclier (un talent, passif ; il te faut d'abord Redoute). Puis Jugement rapide (**F1**, un talent ; il te faut d'abord Rempart de templier) et Fureur vertueuse améliorée (un talent, passif) au 25.
- 30 : Bouclier sacré (**Shift-4**, un talent ; il te faut un bouclier) : 30 % de chances de bloquer en plus pendant 10 secondes, 4 charges ; cooldown 10 secondes. Rétribution (un talent, passif). Puis Bouclier divin (**Z**) au 34, Credo de fer (un talent, passif) au 35.
- 40 : Serment du bouclier (un talent, passif ; il te faut d'abord Bouclier sacré) : Frappe sacrée toutes les 6 secondes, et elle marche avec Bouclier sacré. Armure en plaques : tu peux porter des plaques. Bouclier sacré Rang 2. Puis Marteau de courroux (**4**) au 44, Bénédiction de sacrifice (bloc D) au 46.
- 50 : Bouclier sacré Rang 3, Colère divine (bloc D) ; rangs plus forts de Sceau de fureur et de Consécration.
- 60 : Bouclier sacré Rang 4 et des rangs plus forts ; rien de nouveau pour ce rôle.
**Erreurs de débutant :**
- Oublier Fureur vertueuse. Sans elle, tu crées beaucoup moins de menace. Vérifie-la chaque fois avant d'attirer ; elle dure 30 minutes.
- Sceau de fureur actif quand tu n'es pas le tank. Chaque Jugement provoque alors.
- Pas de bouclier. Bouclier sacré ne marche pas sans bouclier, et Sceau de fureur ne donne pas d'absorption.]] },
			{ band = 3, title = "Vindicte : dégâts au corps à corps", body = [[
Dès le niveau 1 (Sceau de piété) ; Jugement arrive au 4, Frappe sacrée au 6. Les guides disent que Vindicte est l'arbre le plus rapide pour monter de niveau seul, avec une arme lente à deux mains. La quête de classe du niveau 20 t'en donne une. Les boutons de l'arbre : Sceau d'autorité au 20, Repentir au 30.
**Ordre simple :**
1. Avant le combat : Bénédiction de puissance (**Shift-Z**) jusqu'au 20, puis Bénédiction des rois (**Shift-X**).
2. Aura : Aura de dévotion (**Ctrl-1**) ; Aura de vindicte (**Ctrl-2**, dès 16) contre plusieurs ennemis.
3. Sceau actif (**3**) : Sceau de piété, jusqu'à ce que tu connaisses Sceau d'autorité (dès 20). Ensuite, la touche 3 lance Sceau d'autorité.
4. Jugement (**2**) chaque fois qu'il est prêt. Il ne consomme pas le sceau.
5. Frappe sacrée (**1**) chaque fois qu'elle est prête.
6. Mort-vivant ou Démon, dès 20 : Exorcisme (**5**).
7. Deux ennemis ou plus, dès 20 : Consécration (**Shift-1**). Pas sur un seul ennemi : elle coûte trop de mana.
8. Dès 44 : Marteau de courroux (**4**) quand l'ennemi a 20 % de vie ou moins.
9. Ennemi fort : Marteau de la justice (**E**), puis Jugement (**2**). Avec Sceau d'autorité, Jugement fait le double de dégâts sur un ennemi étourdi.
10. Un deuxième Humanoïde, dès 30 : Repentir (**V**), et ne le frappe pas.
11. Remets le sceau quand il s'arrête (30 secondes). Peu de vie : Lumière sacrée (**C**) entre les combats.
**Tous les 10 niveaux :**
- 10 : tu as déjà Sceau de piété (**3**), Jugement (**2**), Frappe sacrée (**1**), Bénédiction de puissance (**Shift-Z**) et Marteau de la justice (**E**). Nouveau au 10 : Imposition des mains (**Q**). Premier talent : Bénédiction (la plupart des guides) ou Déviation (un guide), les deux passifs. Les niveaux de talent indiqués ici sont les plus tôt possibles ; un avantage peut les avancer jusqu'à 5 niveaux. Puis Jugement amélioré, Conviction ou Jugement sanctifié (des talents, passifs) dès 15, Aura de vindicte (**Ctrl-2**) au 16.
- 20 : Sceau d'autorité (**3**, un talent) : tes coups font parfois un coup sacré en plus. À partir de là, la touche 3 lance celui-ci au lieu de Sceau de piété. Consécration (**Shift-1**), Exorcisme (**5**), Bénédiction des rois (**Shift-X**), Eclair lumineux (**F2**). Poursuite de la justice (un talent, passif : tu te déplaces 15 % plus vite à 2/2). La quête de classe pour une arme à deux mains. Puis Sentence sacrée et Spécialisation Arme 2M (des talents, passifs) au 25.
- 30 : Repentir (**V**, un talent) : met un Humanoïde hors jeu jusqu'à 6 secondes ; le moindre dégât le réveille ; cooldown 1 minute. Vengeance (un talent, passif ; il te faut d'abord Sceau d'autorité) : après un critique, tu fais plus de dégâts pendant 30 secondes ; ça se cumule 5 fois. Sceau d'autorité Rang 2. Puis Bouclier divin (**Z**) au 34, Champion de la lumière (un talent, passif) au 35.
- 40 : Courroux descellé (un talent, passif ; il te faut d'abord Repentir) : tes coups gardent des copies de ton sceau, et un coup avec un autre sceau les utilise. Armure en plaques : tu peux porter des plaques. La quête du cheval de guerre. Puis Marteau de courroux (**4**) au 44.
- 50 : Sceau d'autorité Rang 4, Colère divine (bloc D), Marteau de courroux Rang 2 au 52 ; rien de nouveau pour ce rôle.
- 60 : Sceau d'autorité Rang 5 et des rangs plus forts ; la quête du destrier (Alliance) ; rien de nouveau pour ce rôle.
**Erreurs de débutant :**
- Remettre le sceau après chaque Jugement. Jugement ne le consomme pas ; un sceau dure 30 secondes.
- Sceau d'autorité avec une arme rapide. Il veut une arme lente à deux mains.
- Consécration sur un seul ennemi. Elle coûte trop de mana pour ça.]] },
		},
	},
}
