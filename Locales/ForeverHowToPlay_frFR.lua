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
- 16 : Forme aquatique sur R quand tu nages. 18 : Lucioles sur 5 (marche dans toutes les formes), Hibernation sur Shift-Q.
- 20 : Forme de félin (via une quête) sur Ctrl-2, avec Griffe, Déchirure et Rôder. Feu stellaire sur 3. En combat, F3 devient Renaissance.
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
- **2** = Jugement (4) : cooldown de 10 secondes. Il ne consomme pas ton sceau.
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
- 12 : Rédemption sur F3 (ramène un ami mort ; pas en combat). 14 : Bénédiction de sagesse sur Shift-V.
- 18 : Bénédiction de liberté sur R (rien ne peut te ralentir pendant un moment). 20 : Consécration sur Shift-1 (frappe plusieurs ennemis à la fois), Exorcisme sur 5, Eclair lumineux sur F2 (soin rapide), Bénédiction des rois sur Shift-X.
- 30 : Intervention divine : en combat, F3 lance celle-ci au lieu de Rédemption. 34 : Bouclier divin sur Z : 10 secondes pendant lesquelles rien ne peut te blesser, et tu peux quand même te battre (avec la moitié des dégâts).
- 42 : Epuration remplace Purification sur Shift-C. 44 : Marteau de courroux sur 4 (seulement quand l'ennemi a 20 % de vie ou moins).
- 52-60 : en groupe, les touches de bénédiction lancent la version supérieure pour tout le groupe ; en solo, elles lancent la normale.]] },
		{ "Erreurs de débutant", [[
- Appuyer sur Exorcisme (5) contre un ennemi normal. Il ne marche que sur les ennemis de type Mort-vivant et Démon. Renvoi des morts-vivants (Shift-Q, 24) ne marche que sur le type Mort-vivant.
- Appuyer sur Marteau de courroux (4) tôt dans le combat. Il ne marche que quand l'ennemi est presque mort (20 % de vie ou moins).
- Bouclier divin et Protection divine partagent un même cooldown, donc ils sont sur une seule touche (Z). Ces sorts de protection, et Bénédiction de protection, donnent **Longanimité** : pendant 1 minute, tu ne peux plus en recevoir aucun. Imposition des mains n'en donne pas.]] },
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
- **Niveau 10, quêtes du familier :** tu apprends Apprivoise une bête, Appel du familier et Ressusciter le familier. **F4** = Appel du familier (fait venir ton familier), **F3** = Ressusciter le familier (ramène un familier mort). Apprivoise une bête n'a pas de touche ; tu l'utilises hors combat.
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
Chaque race de Prêtre a deux sorts de Prêtre bien à elle : un au niveau 10 et un au niveau 20. MH les met sur **X** et **Shift-R**, donc chaque race utilise les deux mêmes touches.
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
- Soigner en Forme d'Ombre. Aucun sort de soin ne marche en Forme d'Ombre. Gardien de peur et les sorts raciaux du Nain et du Gnome (Châtiment, Éclair déconcertant) n'y marchent pas non plus. Quitte-la d'abord : appuie encore sur Ctrl-1.
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
}
