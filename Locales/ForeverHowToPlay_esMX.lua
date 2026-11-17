local _, ns = ...
-- Mexican Spanish "How you play" for WoW Forever (translated 7 Nov 2026 from Modules/ForeverHowToPlay.lua by mh-writer;
-- game names measured in docs/forever/CLIENT_NAMES_FOREVER_2026-11-07.md, esMX column). Same text as
-- ForeverHowToPlay_esES.lua with the esMX client names swapped in. ForeverHowToPlay.lua picks this table on esMX.
if not ns.IS_FOREVER then
	return
end
if GetLocale() ~= "esMX" then
	return
end
ns.FOREVER_HOWTOPLAY_L = ns.FOREVER_HOWTOPLAY_L or {}
ns.FOREVER_HOWTOPLAY_L.esMX = {
	COMMON = {
		{ "Antes de empezar", [[
- Las teclas dan por hecho que el bloque de teclas de MH está colocado: /mh block, y luego los pasos 1 y 2.
- **Rangos de hechizo.** La mayoría de los hechizos tienen rangos: Rango 1, Rango 2, etc. Un rango más alto es el mismo hechizo, solo que más fuerte. Compras los rangos nuevos a tu instructor de clase a medida que subes de nivel. No tienes que cambiar nada: las teclas de MH lanzan un hechizo por su nombre, y el juego usa el rango más alto que conoces.
- **Una tecla que todavía no tiene nada** conserva su sitio. Se llena cuando aprendes el hechizo. Si un hechizo nuevo no aparece, abre el bloque de teclas (/mh block) y pulsa **Actualizar (hechizos nuevos)**.
- **Los hechizos de talento** también tienen tecla. Si nunca eliges ese talento, la tecla se queda vacía. No pasa nada.
- **Maná** es la barra azul debajo de tu salud. La mayoría de los hechizos cuestan maná. Cuando se vacía, no puedes lanzar hechizos.
- **Reutilización** = la espera antes de poder pulsar un hechizo otra vez.
- Teclas fijas, iguales para todas las clases: **T** = poción, **Shift-T** = piedra de salud, **G** = abalorio.]] },
	},
	DRUID = {
		{ "Qué hace", [[
El Druida puede cambiar de forma. Como lanzador normal lanza hechizos y cura. Más adelante puede convertirse en oso o en felino, para luchar cuerpo a cuerpo. El oso puede provocar (Bramido), así que es la forma para tanquear.
Una **forma** es una de esas figuras. En una forma, muchas de tus teclas hacen otra cosa. Las teclas de MH cambian solas: la misma tecla es un hechizo como lanzador y otro hechizo como oso.]] },
		{ "Niveles 1-10: tus botones", [[
- **1** = Cólera (nivel 1): tu hechizo de ataque principal.
- **2** = Fuego lunar (4): daño, y luego más daño durante unos segundos.
- **C** = Toque de sanación (1): tu gran cura.
- **F4** = Rejuvenecimiento (4): una cura que te cura poco a poco.
- **Shift-X** = Marca de lo Salvaje (1): un buff. Un **buff** es un efecto bueno sobre ti o sobre un amigo. Póntelo antes de un combate.
- **Shift-Z** = Espinas (6): otro buff.
- **V** = Raíces enredadoras (8): deja a un enemigo quieto en su sitio.
- **X** = Trabazón con la Naturaleza (10).
- **Shift-E** = el hechizo de tu raza (Fusión de las Sombras para un Elfo de la noche, Pisotón de guerra para un Tauren).
- **Nivel 10, Forma de oso** (de una misión): **Ctrl-1** te convierte en oso. Como oso: **1** = Magullar, **F** = Bramido, **Shift-2** = Rugido desmoralizador.]] },
		{ "Orden sencillo (lanzador)", [[
Primero Fuego lunar (2), luego Cólera (1) hasta que el enemigo muera. ¿Poca salud? Rejuvenecimiento (F4) o Toque de sanación (C).]] },
		{ "Lo que llega después", [[
- 12: Recrecimiento en F2 (cura rápida). Revivir en F3: trae de vuelta a un amigo muerto, solo fuera de combate.
- 16: Forma acuática (de una misión) en R mientras nadas. 18: Fuego feérico en 5 (funciona en casi todas las formas, pero no en Forma de viaje ni en Forma acuática), Hibernar en Shift-Q.
- 20: Forma felina (de una misión) en Ctrl-2, con Zarpa, Triturar, Destripar y Acechar. Carga feral en E (un talento, como pronto en el nivel 20). Fuego estelar en 3. En combate, F3 pasa a ser Renacer.
- 30: Forma de viaje en R (para desplazarte), Tranquilidad en Q. 40: Forma de oso temible (sustituye a Forma de oso en Ctrl-1), Estimular en F1.
- 44: Piel de corteza en Z, en todas las formas.]] },
		{ "Errores de principiante", [[
- Pulsar una cura mientras estás en una forma. Tus curas solo funcionan en tu forma normal, no en Forma de oso, Forma felina, Forma acuática ni Forma de viaje. Sal primero de la forma: pulsa otra vez la misma tecla de forma (Ctrl-1 para el oso, Ctrl-2 para el felino).
- En Forma de lechúcico lunar (un talento, como pronto en el nivel 40) tus hechizos de ataque funcionan, pero tus curas no.
- Lo que sí funciona en una forma: pociones, Piel de corteza, Trabazón con la Naturaleza, Fuego feérico y el hechizo de tu raza.]] },
	},
	PALADIN = {
		{ "Qué hace", [[
El Paladín es un luchador sagrado. Golpea cuerpo a cuerpo, se cura a sí mismo y a otros, y protege a sus amigos. No tiene formas ni actitudes, así que cada tecla hace siempre lo mismo.
Un **sello** es un poder sagrado que te pones a ti mismo. Dura 30 segundos, y solo puedes tener uno a la vez. Un **aura** es un poder que activas y dejas activo; ayuda a todo tu grupo. Una **bendición** es un buff que te pones a ti o a un amigo; dura 60 minutos. Un **buff** es un efecto bueno.]] },
		{ "Sellos y auras", [[
- **Sello de Rectitud** (1): cada golpe hace daño sagrado extra. Un arma lenta hace más por golpe.
- **Sello del cruzado** (6, en su propia tecla Alt): golpeas más rápido, pero cada golpe hace menos.
- **Sello de furia** (10): el sello para tanquear. Con un escudo, cada golpe también te da un pequeño escudo.
- **Sello de orden** (talento, como pronto en el nivel 20): a veces los golpes hacen un gran golpe sagrado extra. En cuanto lo tienes, la tecla 3 lanza este en lugar de Sello de rectitud.
- **Sello de Justicia** (22), **Sello de Luz** (30), **Sello de sabiduría** (38), todos en sus propias teclas Alt: a veces los golpes aturden, te curan o te dan maná.
- **Aura de devoción** (1): más armadura para tu grupo. **Aura de reprensión** (16): daño sagrado a todo lo que golpea a tu grupo. **Aura de concentración** (22): a los lanzadores de tu grupo se les interrumpe menos cuando reciben golpes.]] },
		{ "Niveles 1-10: tus botones", [[
- **3** = Sello de Rectitud (nivel 1): tu sello.
- **C** = Luz Sagrada (1): tu gran cura. Los Paladines No-muertos la consiguen con la misión de nivel 2 "Redescubrimiento de la Luz".
- **Ctrl-1** = Aura de devoción (1, del instructor): actívala y déjala activa.
- **2** = Sentencia (4): reutilización de 10 segundos. No gasta tu sello. Solo funciona si tienes un sello puesto: ponte primero tu sello (3).
- **Shift-Z** = Bendición de poderío (4): póntela a ti mismo.
- **1** = Golpe Sagrado (6): tu golpe principal, cuerpo a cuerpo.
- **Z** = Protección divina (6): durante 6 segundos nada puede hacerte daño, pero tú tampoco puedes atacar. Reutilización de 5 minutos.
- **E** = Martillo de Justicia (8): aturde al enemigo. Un **aturdimiento** significa que el enemigo no puede moverse ni lanzar hechizos durante unos segundos. El Paladín no tiene una interrupción de verdad, así que esta es tu tecla de "para ese hechizo".
- **Shift-C** = Purificar (8): quita un efecto malo a un amigo.
- **Q** = Imposición de manos (10): tu botón de emergencia. Cura a un amigo (o a ti) hasta la salud completa, pero gasta todo el maná que te queda. Reutilización de 20 minutos.
- **Shift-F** = Bendición de protección (10): salva a un amigo que está en apuros.
- **F** = Sello de furia (10): un sello para tanquear. Su Sentencia provoca. **Provocar** = hacer que el enemigo te ataque a ti.]] },
		{ "Orden sencillo", [[
Sello (3) antes del combate. Luego Golpe Sagrado (1) y Sentencia (2) cada vez que estén listos. Vuelve a ponerte el sello cuando se acabe (dura 30 segundos). ¿Poca salud? Luz Sagrada (C).]] },
		{ "Lo que llega después", [[
- 12: Redención (de una misión) en F3 (trae de vuelta a un amigo muerto; no en combate). 14: Bendición de sabiduría en Shift-V.
- 18: Bendición de libertad en R (nada puede ralentizarte durante un rato). 20: Consagración en Shift-1 (golpea a varios enemigos a la vez), Exorcismo en 5, Destello de Luz en F2 (cura rápida), Bendición de reyes en Shift-X.
- 30: Intervención divina: en combate, F3 lanza este en lugar de Redención. Cuidado: mueres tú; el amigo que eliges queda a salvo de todos los ataques durante un rato. 34: Escudo divino en Z: 10 segundos en los que nada puede hacerte daño, y aun así puedes luchar (con la mitad de daño).
- 42: Limpiar sustituye a Purificar en Shift-C. 44: Martillo de cólera en 4 (solo cuando el enemigo tiene un 20% de salud o menos).
- 52-60: en un grupo, las teclas de bendición lanzan la bendición superior para todo el grupo (por ejemplo Bendición de poderío superior); si juegas solo, lanzan la normal.]] },
		{ "Errores de principiante", [[
- Pulsar Exorcismo (5) contra un enemigo normal. Solo funciona contra No-muertos y Demonios. Ahuyentar no-muertos (Shift-Q, 24) solo funciona contra No-muertos.
- Pulsar Martillo de cólera (4) al principio del combate. Solo funciona cuando el enemigo está casi muerto (un 20% de salud o menos).
- Escudo divino y Protección divina comparten una reutilización, así que están en una sola tecla (Z). Estos hechizos de protección, Bendición de protección y Baluarte del templario dan **Abstinencia**: durante 1 minuto no puedes recibir ninguno de ellos otra vez. Imposición de manos no.]] },
	},
	MAGE = {
		{ "Qué hace", [[
El Mago se queda atrás y lanza magia de fuego, de escarcha y arcana. Mantiene a los enemigos lejos con hechizos que los dejan quietos o los ralentizan. El Mago no tiene formas ni actitudes, así que cada tecla hace siempre lo mismo.]] },
		{ "Niveles 1-10: tus botones", [[
- **1** = Bola de Fuego (nivel 1): tu hechizo de ataque principal.
- **Shift-Z** = Armadura de Escarcha (1): un buff sobre ti mismo. Póntelo antes de un combate. Solo puedes llevar una armadura.
- **Shift-X** = Intelecto Arcano (1): un buff para ti o para un amigo.
- **Ctrl-3** = Disparar: tu **varita** (un pequeño palo mágico que dispara solo), en cuanto tengas una. Útil cuando te queda poco maná. Cuando aprendes Descarga de Pirofrío, esa ocupa Ctrl-3; pon Disparar en una de tus propias teclas Alt si todavía la quieres.
- **2** = Descarga de Escarcha (4): daño de escarcha.
- **5** = Explosión de Fuego (6): golpe de fuego instantáneo. **Instantáneo** = sin tiempo de lanzamiento. Reutilización de 8 segundos.
- **3** = Misiles Arcanos (8): daño arcano.
- **Shift-Q** = Polimorfia (8): saca del combate a un enemigo durante un rato. Ese tipo de hechizo se llama **CC** (control de masas).
- **V** = Nova de Escarcha (10): congela a todos los enemigos a menos de 10 metros a tu alrededor, hasta 8 segundos. El daño puede romperlo. Reutilización de 25 segundos.
- Crear agua (4) y Crear comida (6) no están en el bloque. Van en tus propias teclas Alt (bloque D).]] },
		{ "Orden sencillo", [[
Descarga de Escarcha (2) o Bola de Fuego (1) mientras el enemigo se acerca. Explosión de Fuego (5) cuando esté lista. ¿El enemigo está cerca de ti? Nova de Escarcha (V), apártate y sigue lanzando.]] },
		{ "Lo que llega después", [[
- 12: Caída lenta en Shift-R. 14: Deflagración Arcana en Shift-2 (golpea a varios enemigos). 16: Fogonazo en Shift-4.
- 18: Eliminar maldición inferior en Shift-V. 20: Traslación en R (tu hechizo de movimiento), Ventisca en Shift-1, Evocación en F1 (recupera maná), Escudo de maná en Z, Resguardo contra el Fuego en F4. También los teletransportes (y más tarde los portales): hechizos de viaje, no están en el bloque. Ponlos en tu propia barra, o úsalos desde tu libro de hechizos (Hechizos).
- 22: Agostar en Ctrl-1, Resguardo contra la Escarcha en F2. 24: Contrahechizo en E: tu **interrupción** (detiene el hechizo de un enemigo).
- 26: Cono de frío en Shift-F. 30: Armadura de hielo: a partir de entonces Shift-Z lanza esta en lugar de Armadura de Escarcha (también te protege contra la escarcha).
- Talentos a partir del nivel 20: Piroexplosión en 4, Lanza de hielo en F, Explosión Arcana en Ctrl-2, Bloque de hielo en C (como pronto en el 25).]] },
		{ "Errores de principiante", [[
- Esperar los dos resguardos a la vez. Resguardo contra el Fuego (F4) y Resguardo contra la Escarcha (F2) comparten una reutilización de 30 segundos, así que solo uno a la vez.
- Llevar Armadura de mago y Armadura de hielo juntas. Solo puedes llevar una armadura a la vez. Armadura de mago (34) está en el bloque D.]] },
	},
	HUNTER = {
		{ "Qué hace", [[
El Cazador dispara desde lejos con un arma a distancia, y desde el nivel 10 tiene una **mascota**: un animal que domesticas y que lucha a tu lado. De cerca tiene unos pocos golpes cuerpo a cuerpo.
**Disparo automático** = tu arma sigue disparando sola hasta que paras. **Cuerpo a cuerpo** = luchar de cerca. El Cazador no tiene formas ni actitudes, así que cada tecla hace siempre lo mismo.]] },
		{ "Niveles 1-10: tus botones", [[
- **1** = Disparo automático (nivel 1): empieza a disparar. La tecla de MH está hecha para que una segunda pulsación no lo detenga.
- **5** = Golpe de raptor (1): tu golpe cuando el enemigo está a tu lado.
- **2** = Picadura de serpiente (4): daño durante unos segundos.
- Aspecto del mono (4) va en tus propias teclas Alt (bloque D). Un **aspecto** es un buff sobre ti mismo, parecido a una actitud. Solo puedes tener un aspecto a la vez.
- **3** = Disparo Arcano (6): disparo instantáneo. Reutilización de 6 segundos.
- **Shift-Z** = Marca del cazador (6): pónsela al enemigo una vez.
- **Shift-Q** = Disparo de conmoción (8): ralentiza al enemigo.
- **Shift-R** = Aspecto del halcón (10): tu aspecto principal.
- **Nivel 10, misiones de mascota:** aprendes Domesticar bestia, Llamar a mascota y Retirar mascota; la misión siguiente da Revivir mascota y Alimentar mascota. **F4** = Llamar a mascota (trae a tu mascota), **F3** = Revivir mascota (trae de vuelta a una mascota muerta). Domesticar bestia no tiene tecla; la usas fuera de combate.
- A partir de entonces tu mascota tiene tres teclas: **Ctrl-1** = atacar a tu objetivo, **Ctrl-2** = seguirte, **Ctrl-3** = quedarse donde está.]] },
		{ "Orden sencillo", [[
Activa Aspecto del halcón (Shift-R). Primero entra la mascota (Ctrl-1). Marca del cazador (Shift-Z), Picadura de serpiente (2), Disparo automático (1), y luego Disparo Arcano (3) cuando esté listo. ¿El enemigo está a tu lado? Golpe de raptor (5).]] },
		{ "Lo que llega después", [[
- 10: Alimentar mascota y Retirar mascota no están en el bloque (los usas fuera de combate); ponlos en tu propia barra. Lo mismo con Asustar bestia (14).
- 12: Disparo de distracción en F (hace que el enemigo te ataque), Aliviar mascota en F2 (cura a tu mascota), Cortar alas en Shift-F.
- 16: Trampa de inmolación en Shift-2, Mordedura de mangosta en Shift-C (solo después de esquivar). 18: Multidisparo en Shift-1.
- 20: Disparo de puntería en 4 (tu gran disparo), Aspecto del guepardo en R (corres rápido), Separación en Z, Trampa congelante en V.
- 26: Fuego rápido en Q. 30: Fingir muerte en X, Aspecto de la bestia (bloque D). 34: Trampa explosiva pasa a ocupar Shift-2.
- Las cuatro trampas comparten una reutilización de 30 segundos.]] },
		{ "Errores de principiante", [[
- Disparar a un enemigo que está justo a tu lado. Tu arma de fuego o tu arco no funciona a menos de 8 metros (la "zona muerta"): usa Golpe de raptor (5), o da un paso atrás.
- Esperar que una tecla dispare de lejos y golpee de cerca. Una macro no puede ver la distancia, así que el cuerpo a cuerpo tiene sus propias teclas (5, Shift-F, Shift-C).
- Pulsar Aliviar mascota (F2) para curarte a ti. Solo cura a tu mascota. El Cazador no tiene cura propia.]] },
	},
	WARRIOR = {
		{ "Qué hace", [[
El Guerrero lucha cuerpo a cuerpo con un arma. Tiene tres actitudes, y desde el nivel 10 puede tanquear. No se cura a sí mismo, salvo con Ataque de la victoria (nivel 20).
El Guerrero tiene **Ira** en lugar de maná. Ganas Ira cuando golpeas y cuando te golpean. Fuera de combate, tu Ira baja poco a poco hasta 0.]] },
		{ "Actitudes", [[
Una **actitud** es una forma de luchar que activas con una tecla. Siempre estás en una actitud. Algunos hechizos solo funcionan en una o dos actitudes. Las teclas de MH cambian solas: en otra actitud, la misma tecla lanza otro hechizo. Si una tecla no tiene nada para tu actitud, no hace nada (sin error).
- **Actitud de batalla** (1): tu actitud para luchar normalmente.
- **Actitud defensiva** (10, de una misión): la actitud para tanquear. Solo aquí tienes Provocar.
- **Actitud rabiosa** (30, de la misión "La Reyerta"). Aquí E pasa a ser Zurrar y R pasa a ser Interceptar.
- **Maestría táctica** (14, pasiva, no haces nada): conservas hasta 10 de Ira al cambiar de actitud.
- Ninguna tecla cambia tu actitud por sí sola. Tú eliges la actitud; las teclas la siguen.]] },
		{ "Niveles 1-10: tus botones", [[
- **1** = Golpe heroico (nivel 1): tu golpe principal, en todas las actitudes.
- **Ctrl-1** = Actitud de batalla (1): actívala y déjala activa.
- **Shift-X** = Grito de batalla (1): un buff. Un **buff** es un efecto bueno sobre ti o sobre un amigo. Póntelo antes de un combate.
- **R** = Cargar (4): corres hacia un enemigo para empezar un combate. Solo funciona en Actitud de batalla, y no cuando ya estás luchando.
- **Shift-Z** = Desgarrar (4): un **sangrado**: daño durante unos segundos. Actitud de batalla y Actitud defensiva.
- **Shift-1** = Atronar (6): golpea a varios enemigos a la vez. Actitud de batalla y Actitud defensiva. Reutilización de 6 segundos.
- **V** = Seccionar (8): ralentiza mucho al enemigo durante 15 segundos. Actitud de batalla y Actitud rabiosa.
- **F1** = Ira sangrienta (10): te da Ira enseguida y un poco más durante unos segundos. Cuesta un poco de salud. Reutilización de 1 minuto.
- **Nivel 10, Actitud defensiva** (de una misión): **Ctrl-2** la activa. La misma misión da **5** = Hender armadura (todas las actitudes) y, en Actitud defensiva, **F** = Provocar. **Provocar** = hacer que el enemigo te ataque a ti. Reutilización de 8 segundos.
- Disparar arco, Disparar arma de fuego, Disparar ballesta y Lanzar van en tus propias teclas Alt (bloque D). Recibes el que va con tu arma a distancia. Úsalo para hacer **pull**: golpear a un enemigo desde lejos, para que venga hacia ti.]] },
		{ "Orden sencillo", [[
Activa Actitud de batalla (Ctrl-1), Grito de batalla (Shift-X). Entra con Cargar (R). Desgarrar (Shift-Z), y luego Golpe heroico (1) una y otra vez. ¿Varios enemigos? Atronar (Shift-1).]] },
		{ "Lo que llega después", [[
- 12: Abrumar en 2 (Actitud de batalla; después de que el enemigo esquive), Azote de escudo en E: tu **interrupción** (detiene el hechizo de un enemigo).
- 14: Revancha en 2 (Actitud defensiva), Grito desmoralizador en Shift-2. 16: Falsa arremetida en F (Actitud de batalla), Bloqueo con escudo en Z (Actitud defensiva). 18: Desarmar en V (Actitud defensiva).
- 20: Rajar en Shift-4, Embate en Shift-C, Ataque de la victoria en F2 (solo en los 20 segundos después de matar a un enemigo que da PE; te cura un poco; reutilización de 30 segundos), Represalias en C (Actitud de batalla). 22: Grito intimidador en Shift-Q. 24: Ejecutar en 4 (Actitud de batalla y Actitud rabiosa; solo cuando el enemigo tiene un 20% de salud o menos).
- 26: Grito desafiante en Shift-F. 28: Muro de escudo en C (Actitud defensiva).
- 30: Actitud rabiosa en Ctrl-3. En ella: Interceptar en R, Ira rabiosa en Shift-V. 36: Torbellino en 2 (rabiosa). 38: Zurrar en E (rabiosa). 50: Temeridad en Q (rabiosa).
- Talentos: Última carga en X y Aullido perforador en Shift-R (una ralentización en área), como pronto en el 20. Golpe de lanza en F3 (Actitud de batalla) y Golpes temerarios en Shift-F1, 25. Golpes de barrido en Q (Actitud de batalla), Deseo de muerte en Shift-3, Arremetida de conmoción en Shift-V (un aturdimiento; en Actitud rabiosa esta tecla es Ira rabiosa), 30. Golpe mortal, Sed de sangre o Embate con escudo en 3, 40.]] },
		{ "Errores de principiante", [[
- Pulsar una tecla en la actitud equivocada. Provocar solo funciona en Actitud defensiva, Abrumar solo en Actitud de batalla. En la actitud equivocada la tecla no hace nada. Mira primero tu actitud.
- Cargar en Actitud defensiva. Allí solo funciona con el talento **Vanguardia**. Sin él, recibes un error en rojo.
- Cargar en combate. Cargar solo empieza un combate; cuando ya estás luchando, no funciona.
- Atronar (Shift-1) no funciona en Actitud rabiosa.
- Azote de escudo, Bloqueo con escudo y Embate con escudo sin escudo. Los tres necesitan un escudo en la mano izquierda.
- Esperar que Embate sea rápido. En Forever tiene 1,5 segundos de lanzamiento y 15 segundos de reutilización.
- Represalias y Muro de escudo están los dos en C, cada uno con su propia reutilización de 15 minutos. Guárdalos para los apuros de verdad.]] },
	},
	ROGUE = {
		{ "Qué hace", [[
El Pícaro lucha cuerpo a cuerpo con golpes rápidos. Puede acercarse a los enemigos sin que lo vean, y tiene muchas formas de detener a un enemigo un momento.
El Pícaro tiene **Energía** en lugar de maná. La Energía se rellena sola, y rápido: una barra vacía vuelve a estar llena en unos 10 segundos.]] },
		{ "Sigilo y remates", [[
**Sigilo** (nivel 1, Shift-R) hace que sea difícil verte. Te mueves a la mitad de velocidad. Algunos ataques solo funcionan desde Sigilo: son tus **aperturas**, el primer golpe de un combate. En Sigilo, las teclas de MH cambian solas:
- **1** pasa a ser Garrote (14), **2** pasa a ser Emboscada (18), **V** pasa a ser Golpe bajo (26), **Shift-Q** pasa a ser Porrazo (10), **F** pasa a ser Robar (4).
- Antes de conocer el hechizo Sigilo, la tecla simplemente mantiene su hechizo normal.
Golpes como Golpe siniestro te dan **puntos de combo** (hasta 5). Un **remate** es un golpe que gasta todos tus puntos de combo: Eviscerar (4), Hacer picadillo (Shift-4) y Ruptura (5). Más puntos lo hacen más fuerte.]] },
		{ "Niveles 1-10: tus botones", [[
- **1** = Golpe siniestro (nivel 1): tu golpe principal.
- **4** = Eviscerar (1): tu remate principal.
- **Shift-R** = Sigilo (1): avanzar a escondidas. Púlsalo otra vez para salir de Sigilo. Después de salir de Sigilo, no puedes volver a entrar durante 10 segundos.
- **Shift-2** = Lanzar (1): un lanzamiento a distancia. Necesitas un arma arrojadiza (como cuchillos arrojadizos) en tu ranura de arma a distancia. Con un arma de fuego, un arco o una ballesta equipados, la tecla dispara con eso.
- **2** = Puñalada (4): un golpe fuerte. Necesitas una daga, y tienes que estar detrás del enemigo.
- **F** = Robar (4): solo en Sigilo. Le roba al enemigo.
- **Shift-Q** = Gubia (6): detiene a un enemigo un momento. Cualquier daño lo rompe. Ese tipo de hechizo se llama **CC** (control de masas).
- **Z** = Evasión (8): esquivas muchos más ataques durante 15 segundos. Reutilización de 5 minutos.
- **Shift-4** = Hacer picadillo (10): tu segundo remate.
- **R** = Sprint (10): corres rápido.
- **Shift-Q** = Porrazo (10): solo en Sigilo. Saca a un enemigo humanoide del combate durante un rato, antes de que empiece el combate. No funciona contra bestias ni contra enemigos que ya están luchando. El daño lo rompe. Porrazo no rompe tu Sigilo.
- **F4** = la cura con el tiempo de tu raza, si tiene una: Canibalismo (No-muerto; solo cerca de un cadáver Humanoide o No-muerto), Regeneración rápida (Trol; se detiene cuando te mueves, actúas o recibes daño), Leer línea ley (Cielonato de la Suma Orden).
- **Shift-E** = el hechizo de tu raza (por ejemplo Fusión de las Sombras para un Elfo de la noche, Furia sangrienta para un Orco).]] },
		{ "Orden sencillo", [[
Sigilo (Shift-R) y acércate al enemigo. Golpe siniestro (1) unas cuantas veces, y luego Eviscerar (4). Con una daga y detrás del enemigo: Puñalada (2). A partir del nivel 10: mantén activo Hacer picadillo (Shift-4).]] },
		{ "Lo que llega después", [[
- 12: Patada en E: tu **interrupción** (detiene el hechizo de un enemigo). 14: Exponer armadura en Shift-Z, Garrote en 1 en Sigilo.
- 16: Amago en F (fuera de Sigilo). Baja tu **amenaza**: las ganas que tiene el enemigo de atacarte. Forzar cerradura (bloque D).
- 18: Emboscada en 2 en Sigilo (daga, desde detrás). 20: Ruptura en 5. Venenos (de una misión; mira más abajo).
- 22: Distraer en Shift-F, Esfumarse en X (tu huida; cada uso gasta una Pólvora cegadora, un objeto de tus bolsas). 24: Punzar en Shift-3 (un golpe con tu arma de la mano izquierda, así que necesitas un arma en cada mano; reutilización de 10 segundos; te devuelve 15 de Energía).
- 26: Golpe bajo en V en Sigilo: un **aturdimiento** (el enemigo no puede moverse ni actuar durante unos segundos). 30: Golpe en los riñones en V fuera de Sigilo. Desactivar trampa (bloque D). 34: Ceguera en Shift-V (gasta unas Partículas cegadoras).
- Talentos: Contestación en Shift-F1 y Premeditación en Shift-C, como pronto en el 20. Sangre fría en F1 y Golpe fantasmal en Shift-X, 25. Aluvión de acero en Shift-1 (golpea a más enemigos), Preparación en F3 (reinicia la reutilización de tus otros hechizos de Pícaro, como Evasión, Sprint y Esfumarse), Hemorragia en 3, 30. Mutilar en 3, Subidón de adrenalina o Marca mortal en Q, 40.]] },
		{ "Errores de principiante", [[
- Pulsar una apertura fuera de Sigilo. Garrote, Emboscada, Golpe bajo, Porrazo y Robar necesitan Sigilo. Fuera de Sigilo, la misma tecla lanza su hechizo normal.
- Pulsar Sigilo otra vez sin querer. Eso termina el Sigilo, y no puedes volver a entrar durante 10 segundos.
- Elfo de la noche: Fusión de las Sombras es el hechizo de tu raza, no el Sigilo de tu clase. Para tus aperturas, usa Sigilo (Shift-R).
- Puñalada y Emboscada de frente, o sin daga. Las dos necesitan una daga, y tienes que estar detrás del enemigo.
- Golpear a un enemigo que sacaste del combate con Gubia o Porrazo. Cualquier daño lo despierta.
- Porrazo contra una bestia o contra un enemigo que ya está luchando. Porrazo solo funciona contra humanoides, antes del combate.
- Esfumarse o Ceguera sin polvo en tus bolsas. Esfumarse necesita una Pólvora cegadora, Ceguera necesita unas Partículas cegadoras.
- Buscar los venenos en el bloque. Los **Venenos** son objetos que fabricas (aprendes Venenos con una misión hacia el nivel 20). Los pones en tu arma. Arrástralos tú mismo a tus propias teclas Alt (bloque D).
- Golpe fantasmal (talento): después de él, tu siguiente Emboscada o Garrote funciona sin Sigilo, si lo usas en 7 segundos. Las teclas de MH no pueden ver eso, así que fuera de Sigilo las teclas 1 y 2 siguen lanzando Golpe siniestro y Puñalada.]] },
	},
	PRIEST = {
		{ "Qué hace", [[
El Sacerdote cura, y golpea desde lejos con magia sagrada y de sombras. Protege a sus amigos con un escudo. Más adelante puede elegir **Forma de las Sombras** (un talento, como pronto en el nivel 40): más daño de sombras, pero nada de curación.
El Sacerdote no tiene actitudes. Forma de las Sombras no cambia las teclas: cada tecla hace siempre lo mismo.]] },
		{ "Los hechizos propios de tu raza", [[
Cada raza de Sacerdote tiene dos hechizos de Sacerdote propios: uno en el nivel 10 y otro en el nivel 20. Los dos los consigues con una misión, no con el instructor. MH los pone en **X** y **Shift-R**, así que todas las razas usan las mismas dos teclas.
- Enano: Rezo desesperado (10, X; reutilización de 10 minutos), Castigar (20, Shift-R).
- Humano: Gracia divina (10, Shift-R; una cura instantánea sobre un amigo con menos de la mitad de salud, no sobre ti; reutilización de 10 minutos), Rebote (20, X).
- Elfo de la noche: Fragmentos estelares (10, Shift-R; reutilización de 30 segundos), Gracia de Elune (20, X).
- No-muerto: Toque de debilidad (10, X), Sacrificio oscuro (20, Shift-R; cambias tu propia salud por maná).
- Trol: Maleficio de debilidad (10, Shift-R), Guardia de las Sombras (20, X).
- Gnomo: Destello desconcertante (10, Shift-R), Plan de contingencia (20, X; una protección sobre un amigo que lo cura y lo escuda cuando su salud baja mucho).]] },
		{ "Niveles 1-10: tus botones", [[
- **1** = Punición (nivel 1): tu hechizo de ataque principal.
- **C** = Sanación inferior (1): tu cura principal. Más tarde Sanar (16) y Sanación superior (40) ocupan esta tecla.
- **5** = Disparar (1): tu **varita** (un pequeño palo mágico que dispara solo). Necesitas una varita en las manos.
- **Shift-X** = Palabra de poder: entereza (1): un buff. Un **buff** es un efecto bueno sobre ti o sobre un amigo. Póntelo antes de un combate.
- **2** = Palabra de las Sombras: dolor (4): daño de sombras.
- **Z** = Palabra de poder: escudo (6): un escudo sobre ti o sobre un amigo. Reutilización de 4 segundos, pero la misma persona solo puede recibir un escudo nuevo después de 15 segundos.
- **F** = Desvanecerse (8): los enemigos tienen menos ganas de atacarte durante un rato. Reutilización de 30 segundos.
- **F4** = Renovar (8): una cura que cura poco a poco.
- **3** = Explosión mental (10): daño de sombras. Reutilización de 8 segundos.
- **F3** = Resurrección (10): trae de vuelta a un amigo muerto. Solo fuera de combate.
- El hechizo de tu raza de nivel 10 está en **X** o en **Shift-R** (mira la lista de arriba).
- **Shift-E** = la habilidad de tu raza (por ejemplo Forma de piedra para un Enano, Fusión de las Sombras para un Elfo de la noche).]] },
		{ "Orden sencillo", [[
Escudo (Z) sobre ti. Palabra de las Sombras: dolor (2), Explosión mental (3), y luego Punición (1). ¿Poco maná? Usa tu varita (5). ¿Poca salud? Renovar (F4) o Sanación inferior (C).]] },
		{ "Lo que llega después", [[
- 12: Fuego interno en Shift-Z. 14: Curar enfermedad en Shift-C, Alarido psíquico en V (unos cuantos enemigos a tu alrededor huyen con miedo hasta 8 segundos; el daño puede terminarlo; reutilización de 30 segundos).
- 18: Disipar magia en Shift-V. 20: Sanación relámpago en F2 (cura rápida), Fuego Sagrado en 4, Encadenar no-muerto en Shift-Q, Peste devoradora en Shift-3, el hechizo de tu raza de nivel 20, Resguardo de miedo (bloque D).
- 30: Rezo de sanación en Shift-2 (cura a tu grupo), Control mental en Shift-F. 32: Palabra de las Sombras: muerte en Shift-4, Suprimir enfermedad pasa a ocupar Shift-C. 34: Levitar en R (gasta una Pluma ligera). 48: Rezo de entereza pasa a ocupar Shift-X (gasta una Vela Sagrada).
- Talentos: Tortura mental (ocupa la tecla 1), Nova Sagrada en Shift-1 y Enfoque interno en F1, como pronto en el 20. Abrazo vampírico en Ctrl-3, 25. Penitencia en Shift-F1 y Silencio en E (tu **interrupción**: detiene el hechizo de un enemigo), 30. Infusión de poder en Q, Forma de las Sombras en Ctrl-1, Rezo de alivio en Ctrl-2, 40.]] },
		{ "Errores de principiante", [[
- Curar en Forma de las Sombras. Ningún hechizo de curación funciona en Forma de las Sombras. Resguardo de miedo y el hechizo de raza del Enano (Castigar) tampoco funcionan en ella. Sal primero: pulsa otra vez Ctrl-1.
- Echar de menos Punición después de elegir Tortura mental. En cuanto conoces Tortura mental, la tecla 1 lanza Tortura mental, no Punición.
- Pulsar Disparar (5) sin varita. Primero compra o encuentra una.
- Buscar una interrupción en E al principio. El Sacerdote solo consigue una con el talento Silencio (como pronto en el 30).
- Encadenar no-muerto (Shift-Q) contra un enemigo normal. Solo funciona contra enemigos No-muertos.]] },
	},
	SHAMAN = {
		{ "Qué hace", [[
El Chamán lanza rayos y fuego, cura y coloca tótems. Puede luchar desde lejos o cuerpo a cuerpo con un arma. En Forever, los Enanos (Alianza) también pueden ser Chamán.
El Chamán no tiene actitudes. **Lobo fantasmal** (nivel 20, en R) es una forma para correr, pero no cambia tus teclas.]] },
		{ "Tótems y buffs de arma", [[
Un **tótem** es un pequeño objeto que colocas en el suelo. Te ayuda a ti o a tu grupo, o hace daño a los enemigos, mientras está en pie. Los tótems pertenecen a cuatro elementos: Tierra, Fuego, Agua y Aire. Puedes tener un tótem de cada elemento a la vez. Uno nuevo sustituye al anterior.
- Cada elemento tiene un objeto Tótem que consigues con una misión de clase: Tótem de tierra (nivel 4, o 3 para los cielonatos), Tótem de fuego (10), Tótem de agua (20), Tótem de aire (30). Necesitas ese objeto en tus bolsas para todos los tótems de ese elemento.
- Antes del nivel 20, cada uno de tus tótems tiene su propia tecla: Tótem Piel de piedra (Z), Tótem Nexo Terrestre (V), Tótem Garra de piedra (F), Tótem Fuerza de la tierra (Shift-X), Tótem abrasador (5), Tótem de tremor (Shift-F).
- A partir del nivel 20 el juego te da una **barra de tótems**. En ella eliges un tótem por elemento. Luego una sola tecla los coloca todos: **Ctrl-1** = Llamada de los elementos (20), **Ctrl-2** = Llamada de los ancestros (30), **Ctrl-3** = Llamada de los espíritus (40). Cada una coloca hasta 4 tótems de su propia página de la barra de tótems. Tiene 3 segundos de lanzamiento y cuesta el maná de todos los tótems que coloca.
- **Shift-R** = Llamado totémico (22): mueve tus tótems hasta ti. Regreso totémico (20, bloque D) los recoge y te devuelve una cuarta parte de su maná.
Un **buff de arma** pone poder en tu arma durante 60 minutos. Tienes uno a la vez. Arma Muerdepiedras (1), Arma Lengua de Fuego (10), Arma Estigma de Escarcha (20) y Arma Viento Furioso (30) van en tus propias teclas Alt (bloque D). Elige el que va con tu forma de jugar.]] },
		{ "Niveles 1-10: tus botones", [[
- **1** = Descarga de relámpagos (nivel 1): tu hechizo de ataque principal.
- **C** = Ola de sanación (1): tu gran cura.
- Arma Muerdepiedras (1) va en el bloque D (mira arriba).
- **E** = Choque de tierra (4): tu **interrupción** (detiene el hechizo de un enemigo), y daño.
- **Z** = Tótem Piel de piedra (4, de una misión): recibes menos daño de los golpes cuerpo a cuerpo. **Cuerpo a cuerpo** = luchar de cerca.
- **V** = Tótem Nexo Terrestre (6): ralentiza a los enemigos que están cerca. Reutilización de 15 segundos.
- **F** = Tótem Garra de piedra (8): hace que los enemigos de alrededor ataquen al tótem. Reutilización de 30 segundos.
- **Shift-Z** = Escudo de relámpagos (8): un escudo sobre ti mismo. Solo un escudo a la vez.
- **2** = Choque de llamas (10): daño de fuego, y luego más daño durante unos segundos.
- **5** = Tótem abrasador (10, de una misión): tu tótem de daño.
- **Shift-X** = Tótem Fuerza de la tierra (10): un tótem que da un buff a tu grupo. Un **buff** es un efecto bueno.
- Arma Lengua de Fuego (10) va en el bloque D.
- **Shift-E** = el hechizo de tu raza (por ejemplo Pisotón de guerra para un Tauren, Forma de piedra para un Enano).]] },
		{ "Orden sencillo", [[
Buff de arma puesto (bloque D), Escudo de relámpagos puesto (Shift-Z). Tótem abrasador (5) al suelo. Choque de llamas (2), y luego Descarga de relámpagos (1). Guarda Choque de tierra (E) para cuando el enemigo lance un hechizo. ¿Poca salud? Ola de sanación (C).]] },
		{ "Lo que llega después", [[
- 12: Nova de Fuego en Shift-4, Purgar en Shift-Q (quita magia a un enemigo), Espíritu ancestral en F3 (trae de vuelta a un amigo muerto). 16: Curar envenenamiento en Shift-C. 18: Tótem de tremor en Shift-F (quita miedo, encantamiento y sueño a tu grupo).
- 20: Lobo fantasmal en R (3 segundos de lanzamiento, solo al aire libre), Choque de Escarcha en 4 (ralentiza), Ola de sanación inferior en F2 (cura rápida), Tótem Corriente de sanación en F4 (de una misión; cura a tu grupo poco a poco; necesita el Tótem de agua), Llamada de los elementos en Ctrl-1.
- 22: Curar enfermedad en Shift-V, Llamado totémico en Shift-R. 30: Tótem derribador en X (atrapa un hechizo dañino dirigido a ti o a un miembro del grupo cercano; no los hechizos de área; necesita el Tótem de aire de la misión de nivel 30), Llamada de los ancestros en Ctrl-2. 32: Cadena de relámpagos en Shift-1 (golpea a varios enemigos).
- 40: Sanación en cadena en Shift-2 (cura a varios amigos), Llamada de los espíritus en Ctrl-3.
- Talentos: Escudo de agua (ocupa Shift-Z), como pronto en el 20. Golpe de tormenta en 3 y Tótem Marea de maná en F1, 25. Presteza de la Naturaleza en Shift-3, 30. Mareas Vivas en Shift-F1, y Maestría en relámpagos o Ira del clarividente en Q, 40.]] },
		{ "Errores de principiante", [[
- Usar un choque justo antes de necesitar interrumpir. Choque de tierra (E), Choque de llamas (2) y Choque de Escarcha (4) comparten una reutilización de 6 segundos. Después de Choque de llamas, no hay interrupción durante hasta 6 segundos.
- Pulsar Nova de Fuego (Shift-4) sin un tótem de Fuego colocado. Necesita uno de tus tótems de Fuego (como Tótem abrasador o Tótem de Magma). Golpea a los enemigos que están cerca de ese tótem, no a los que están cerca de ti.
- Colocar un tótem sin su objeto Tótem. Cada elemento necesita su propio objeto Tótem en tus bolsas, de una misión de clase.
- Lanzar hechizos en Lobo fantasmal. Tus hechizos no están hechos para el lobo. Sal primero de Lobo fantasmal, y luego lanza.
- Olvidar el buff de arma. Dura 60 minutos y no está en el bloque: está en tus propias teclas Alt (bloque D).
- Esperar dos escudos. En cuanto tienes Escudo de agua, Shift-Z lanza ese, no Escudo de relámpagos.]] },
	},
	WARLOCK = {
		{ "Qué hace", [[
El Brujo se queda atrás y lanza magia de sombras y de fuego. Gran parte de su daño llega despacio: hechizos que dañan al enemigo con el tiempo, y maldiciones. Casi siempre lleva un demonio con él.
Un **DoT** (daño con el tiempo) es un hechizo que daña al enemigo poco a poco durante un rato. Una **maldición** o un **terror** es un efecto malo que pones sobre un enemigo. Una maldición y un terror pueden estar sobre el mismo enemigo. El Brujo no tiene formas ni actitudes, así que cada tecla hace siempre lo mismo.]] },
		{ "Tu demonio", [[
Tu **mascota** es un demonio que invocas. Lucha a tu lado. Aprendes los demonios con misiones de clase.
- **Invocar diablillo** (1): de tu primera misión de clase en tu zona de inicio. El nombre depende de tu raza: Humano "El libro robado", Gnomo "Novato", Orco y Trol "Familiares viles", No-muerto "Descubrir el misterio". El Diablillo no cuesta Fragmento de alma.
- **Invocar abisario** (10, misión). **Invocar súcubo** o **Invocar íncubo** (20, misión). **Invocar manáfago** (30, misión). Cada uno de estos cuesta 1 **Fragmento de alma** (mira Drenar alma más abajo).
- **Inferno** (50) está en **F3**. Cada lanzamiento necesita una Piedra infernal. Reutilización de 1 hora.
- Las invocaciones no están en el bloque. Van en tus propias teclas Alt (bloque D).
- Desde tu primer demonio, tu mascota tiene tres teclas: **Ctrl-1** = atacar a tu objetivo, **Ctrl-2** = seguirte, **Ctrl-3** = quedarse donde está.
- El Abisario puede provocar (Tormento). El Manáfago puede detener el hechizo de un enemigo (Bloqueo de hechizo, desde el 36). Estos son hechizos propios de tu demonio, en la Barra de mascota de Blizzard.]] },
		{ "Niveles 1-10: tus botones", [[
- **1** = Descarga de las Sombras (nivel 1): tu hechizo de ataque principal.
- **3** = Inmolar (1): daño de fuego, y luego más daño con el tiempo.
- **Shift-Z** = Piel de demonio (1): un buff sobre ti mismo (más armadura). Un **buff** es un efecto bueno. Desde el 20, Armadura demoníaca ocupa esta tecla.
- **2** = Corrupción (4): un DoT.
- **Shift-V** = Maldición de debilidad (4): tu maldición. Desde el 20, Maldición de los Elementos ocupa esta tecla.
- **F** = Transfusión de vida (6): convierte parte de tu salud en maná.
- **5** = Terror de agonía (8): tu terror, un DoT.
- **V** = Miedo (8): tu tecla de **CC**. CC (control de masas) = un hechizo que saca a un enemigo del combate durante un rato.
- **4** = Drenar alma (10): úsalo para rematar a un enemigo que da PE, y consigues un **Fragmento de alma**. Un Fragmento de alma es un pequeño objeto en tus bolsas. Necesitas uno para invocar a la mayoría de los demonios (todos menos el Diablillo) y para hacer una Piedra de salud o una Piedra de alma. Los enemigos grises (demasiado fáciles) no dan fragmento.
- Crear piedra de salud (10, cuesta un Fragmento de alma; algunos rangos se llaman Crear piedra de salud (inferior), Crear piedra de salud (superior) o Crear piedra de salud (sublime)) va en el bloque D. Tu piedra de salud estará entonces en **Shift-T**, como para todas las clases.
- **Shift-E** = el hechizo de tu raza (por ejemplo Furia sangrienta para un Orco, Voluntad de los Renegados para un No-muerto).]] },
		{ "Orden sencillo", [[
Saca al demonio (bloque D; todos menos el Diablillo necesitan un Fragmento de alma), y luego mándalo al ataque (Ctrl-1). Corrupción (2), Terror de agonía (5), Inmolar (3), y luego Descarga de las Sombras (1). ¿Poco maná? Transfusión de vida (F). ¿Poca salud? Drenar vida (C, desde el 14).]] },
		{ "Lo que llega después", [[
- 12: Cauce de salud en F2 (cura a tu demonio). 14: Drenar vida en C (tu propia gran cura).
- 16: Aliento inagotable en Shift-R. 18: Dolor abrasador (bloque D), y Crear piedra de alma (cuesta un Fragmento de alma; no está en el bloque, ponlo tú mismo en tu propia barra).
- Maldición de las lenguas y Ritual de invocación (traer a un miembro del grupo hasta ti) se usan poco: tampoco están en el bloque. Ponlos en tu propia barra si los quieres.
- 20: Lluvia de Fuego en Shift-1 (golpea a varios enemigos), Armadura demoníaca en Shift-Z, Maldición de los Elementos en Shift-V.
- 28: Desterrar en Shift-Q. 30: Llamas infernales en Shift-2. 32: Resguardo contra las Sombras en Z (absorbe daño de sombras; reutilización de 30 segundos).
- 40: Aullido de terror en Shift-F (da miedo a varios enemigos). 42: Espiral de la muerte en X (un horror, como el miedo, y una cura; reutilización de 2 minutos).
- 48: Fuego de alma en Q (tu golpe más grande; cuesta un Fragmento de alma; 6 segundos de lanzamiento; reutilización de 1 minuto). 50: Inferno en F3. 60: Terror de fatalidad en F1.
- Talentos: Quemadura de las Sombras en Shift-4 (cuesta un Fragmento de alma), Amplificar maldición en Shift-3, Sacrificio demoníaco en Shift-C, como pronto en el 20. Maldición de agotamiento en R (ralentiza al enemigo, para que puedas mantenerte lejos de él), Dominación vil en Shift-F1 (invoca un demonio rápido), 25. Succionar vida en F4 (un DoT que te cura), Enlace de alma en Shift-X, 30. Conflagrar (25), Terror de caos (30), Arruinar (40) e Incinerar (40), todos como pronto, van en el bloque D.]] },
		{ "Errores de principiante", [[
- Invocar un demonio sin Fragmento de alma. Todos los demonios menos el Diablillo cuestan uno. Usa Drenar alma (4) para rematar a enemigos que dan PE.
- Buscar una interrupción en E. El Brujo no tiene ninguna propia, así que E se queda vacía. Solo el Manáfago tiene una.
- Pulsar Cauce de salud (F2) para curarte a ti. Cura a tu demonio. Tu propia cura es Drenar vida (C).
- Desterrar (Shift-Q) contra un enemigo normal. Solo funciona contra demonios y elementales.
- Terror de fatalidad (F1) contra un jugador. No se puede lanzar sobre jugadores.
- Echar de menos tu varita. Disparar no está en el bloque. Arrástralo tú mismo desde tu libro de hechizos (Hechizos) a tu propia barra.]] },
	},
	-- Por rol (16 Nov 2026, mh-writer): the esES text with the esMX client names (SpellName esMX, wowf 1.60.1.70938;
	-- tree names ForeverMacros.lua SPEC_NAMES). Same band, same order as ROLES in Modules/ForeverHowToPlay.lua.
	ROLES = {
		DRUID = {
			{ band = 2, title = "Oso: tanque", body = [[
Desde el nivel 10 (Forma de oso, de una misión). El **tanque** es al que golpean los enemigos, para que el resto del grupo esté a salvo. Para subir de nivel, las guías dicen que el felino es más cómodo; el oso es útil del 10 al 20, y para tanquear en calabozos. El oso usa **Ira**: la consigues cuando golpeas y cuando te golpean.
**Orden sencillo:**
1. Haz **pull** con Fuego feérico (**5**, desde el 18) o Carga feral (**E**, desde el 20). **Pull** = golpear a un enemigo desde lejos, para que venga hacia ti.
2. Rugido desmoralizador (**Shift-2**) una vez.
3. Mordedura primigenia (**3**, desde el 40) cada vez que esté lista.
4. Lacerar (**2**, desde el 25) hasta que tenga 5 acumulaciones.
5. Ira de sobra: Magullar (**1**) contra un enemigo, Flagelo (**Shift-1**, desde el 16) contra dos o más.
6. Bramido (**F**) cuando un enemigo golpea a otra persona.
**Cada 10 niveles:**
- 10: Forma de oso (**Ctrl-1**), Magullar (**1**), Bramido (**F**), Rugido desmoralizador (**Shift-2**). Luego Enfurecer (**Q**) en el 12, Azote (**V**) en el 14, Flagelo (**Shift-1**) en el 16, Fuego feérico (**5**) en el 18.
- 20: Carga feral (**E**, un talento): cargas contra el enemigo y no puede moverse ni lanzar hechizos durante 4 segundos. Reutilización de 15 segundos. Los niveles de talento de aquí son los más tempranos; una ventaja puede adelantarlos hasta 5 niveles.
- 30: Líder de la manada (un talento). Antes: Lacerar (**2**, un talento) en el 25, Rugido desafiante (**Shift-F**) en el 28.
- 40: Forma de oso temible sustituye a Forma de oso en **Ctrl-1**. Mordedura primigenia (**3**, un talento). Antes: Regeneración frenética (**X**) en el 36: convierte la Ira en salud.
- 50: rangos más fuertes de Mordedura primigenia, Lacerar y Magullar. Piel de corteza (**Z**) en el 44.
- 60: otra vez rangos más fuertes; nada nuevo para este rol.
**Errores de principiante:**
- Carga feral cuando el enemigo está a menos de 8 metros. Ahí no funciona.
- Enfurecer (**Q**) mientras recibes golpes fuertes. Te da Ira, pero tienes un 27% menos de armadura.]] },
			{ band = 2, title = "Felino: daño cuerpo a cuerpo", body = [[
Desde el nivel 20 (Forma felina, de una misión; Acechar viene con ella). Para subir de nivel es la primera opción de las guías: dicen que es la más rápida y la más cómoda. El felino usa **Energía**, que se rellena sola. Tus golpes te dan **puntos de combo** (hasta 5); un **remate** los gasta todos.
**Orden sencillo:**
1. Acechar (**Shift-R**), y luego abre con Triturar (**3**) por la espalda. **Acechar** = moverte a escondidas, para que el enemigo no te vea.
2. Fuego feérico (**5**) contra enemigos duros.
3. Arañazo (**2**, desde el 24), pero no cuando el enemigo está casi muerto.
4. Zarpa (**1**) para puntos de combo; Triturar (**3**) cuando estás detrás del enemigo.
5. Con 4-5 puntos de combo: Destripar (**4**) si el enemigo va a vivir mucho; si no, Mordedura feroz (**Shift-4**, desde el 24).
6. Poder cambiante (**Q**, desde el 40) cuando tu Energía está por debajo de 50.
**Cada 10 niveles:**
- 10: nada nuevo para este rol (el felino llega en el 20).
- 20: Forma felina (**Ctrl-2**), Zarpa (**1**), Triturar (**3**, por la espalda), Destripar (**4**), Acechar (**Shift-R**). Carga feral (**E**, un talento): como felino saltas detrás del enemigo. Augurio de claridad es pasivo: no tiene tecla.
- 30: Líder de la manada (un talento). Antes: Arañazo (**2**) y Mordedura feroz (**Shift-4**) en el 24, Carrerilla (**R**) en el 26, Agazapar (**F**) en el 28.
- 40: Poder cambiante (**Q**, un talento): 40 de Energía a cambio de maná, reutilización de 8 segundos, solo como felino. Antes: Devastar (bloque D) en el 32, Abalanzarse (**V**, desde Acechar, un aturdimiento) en el 36. Los niveles de talento de aquí son los más tempranos; una ventaja puede adelantarlos hasta 5 niveles.
- 50: rangos más fuertes de Mordedura feroz, Destripar y Triturar; nada nuevo para este rol.
- 60: otra vez rangos más fuertes; nada nuevo para este rol.
**Errores de principiante:**
- Triturar de frente. Solo funciona por la espalda; de frente, usa Zarpa.
- Poder cambiante demasiado a menudo. Luego no te queda maná para curarte.]] },
			{ band = 1, title = "Equilibrio: daño a distancia", body = [[
Desde el nivel 1: Cólera la tienes desde el principio, Fuego lunar llega en el 4. Forma de lechúcico lunar es un talento, como pronto en el 40. Las guías dicen que subir de nivel como Equilibrio funciona, pero es más lento que el felino. Algunas guías toman Forma de lechúcico lunar más tarde (Zygor en el 53): el 40 no es una regla.
**Orden sencillo:**
1. Fuego estelar (**3**, desde el 20) para abrir contra un enemigo.
2. Fuego lunar (**2**).
3. Enjambre de insectos (**4**, desde el 25).
4. Cólera (**1**) como relleno. Con Eclipse (desde el 30): Cólera acumula cargas, y luego Fuego estelar (**3**).
5. Huracán (**Shift-1**, desde el 40) contra grupos.
¿Poco maná? Sigue con Cólera: es barata.
**Cada 10 niveles:**
- 10: Cólera (**1**), Fuego lunar (**2**), Espinas (**Shift-Z**), Raíces enredadoras (**V**), Trabazón con la Naturaleza (**X**).
- 20: Fuego estelar (**3**). Augurio de claridad es pasivo: no tiene tecla.
- 30: Eclipse (un talento): Cólera hace más rápidos tus 2 siguientes Fuego estelar. Antes: Enjambre de insectos (**4**, un talento) en el 25. Los niveles de talento de aquí son los más tempranos; una ventaja puede adelantarlos hasta 5 niveles.
- 40: Forma de lechúcico lunar (**Ctrl-3**, un talento): cuesta maná, da a tu grupo +3% de crítico (**crítico** = un golpe de suerte, más fuerte), pero en ella no hay curas. Huracán (**Shift-1**), Estimular (**F1**).
- 50: rangos más fuertes de Huracán y Fuego estelar. Piel de corteza (**Z**) en el 44.
- 60: otra vez rangos más fuertes; nada nuevo para este rol.
**Errores de principiante:**
- Curar en Forma de lechúcico lunar. No se puede, y volver a la forma cuesta maná.
- Buscar una tecla para Augurio de claridad. Es pasivo: funciona solo.]] },
			{ band = 3, title = "Restauración: sanador", body = [[
Desde el nivel 1: Toque de sanación lo tienes desde el principio. Las guías no aconsejan curar para subir de nivel en solitario (los enemigos mueren despacio): sube de nivel con Cólera y Fuego lunar, y cura en calabozos. Un **HoT** es una cura que cura poco a poco.
**Orden sencillo (en grupo):**
1. Rejuvenecimiento (**F4**) en el tanque.
2. Recrecimiento (**F2**) en alguien con poca salud.
3. Alivio presto (**Shift-F1**, desde el 25): solo en alguien que tiene tu Rejuvenecimiento o tu Recrecimiento.
4. Crecimiento salvaje (**Shift-2**, desde el 40) cuando varias personas reciben daño.
5. Toque de sanación (**C**) contra mucho daño. Emergencia: Presteza de la Naturaleza (**Shift-3**, desde el 30), y luego Toque de sanación.
6. Estimular (**F1**, desde el 40) cuando te queda poco maná.
**Cada 10 niveles:**
- 10: Toque de sanación (**C**), Rejuvenecimiento (**F4**). Luego Recrecimiento (**F2**) y Revivir (**F3**, fuera de combate) en el 12, Curar envenenamiento (**Shift-C**) en el 14.
- 20: Renacer (**F3**, en combate). Luego Eliminar maldición (**Shift-V**) en el 24, Suprimir veneno (**Shift-C**) en el 26.
- 30: Presteza de la Naturaleza (**Shift-3**, un talento), Tranquilidad (**Q**). Antes: Alivio presto (**Shift-F1**, un talento) en el 25. Los niveles de talento de aquí son los más tempranos; una ventaja puede adelantarlos hasta 5 niveles.
- 40: Crecimiento salvaje (**Shift-2**, un talento), Estimular (**F1**).
- 50: Don de lo Salvaje (**Shift-X**), un Crecimiento salvaje más fuerte.
- 60: otra vez rangos más fuertes; nada nuevo para este rol.
**Errores de principiante:**
- Curar en una forma. Las curas solo funcionan en tu forma normal.
- Lanzar un HoT a alguien que todavía lo tiene. El nuevo sustituye al viejo.]] },
		},
		-- Warrior .. Paladin: 17 Nov 2026, mh-writer, from the English ROLES; names from SpellName esMX (wowf 1.60.1.70938).
		WARRIOR = {
			{ band = 3, title = "Protección: tanque", body = [[
Desde el nivel 10 (Actitud defensiva, de una misión; la misma misión da Provocar y Hender armadura). El **tanque** es al que golpean los enemigos, para que el resto del grupo esté a salvo. Llevas un arma de una mano y un escudo. **Amenaza** = las ganas que tiene un enemigo de atacarte; como tanque la necesitas sobre cada enemigo. Las guías no se ponen de acuerdo sobre qué árbol sube de nivel más rápido en solitario: algunas dicen que Protección es el más rápido, otras dicen que es más lento en solitario. Arranca hacia el nivel 16, cuando tienes Bloqueo con escudo junto a Revancha.
**Orden sencillo:**
1. Actitud defensiva (**Ctrl-2**), Grito de batalla (**Shift-X**). Ira sangrienta (**F1**) para tener Ira al empezar.
2. Haz **pull**. **Pull** = golpear a un enemigo desde lejos, para que venga hacia ti. Cargar (**R**) solo funciona en Actitud de batalla (**Ctrl-1**); vuelve a Actitud defensiva (**Ctrl-2**) después. Con Vanguardia (desde el 25) Cargar también funciona en Actitud defensiva. O haz pull con tu arma a distancia (bloque D).
3. Varios enemigos: Grito desmoralizador (**Shift-2**, desde el 14) una vez, Atronar (**Shift-1**) cada vez que esté listo.
4. Bloqueo con escudo (**Z**, desde el 16), y Revancha (**2**, desde el 14) en cuanto se ilumine.
5. Embate con escudo (**3**, desde el 40) cada vez que esté listo.
6. Hender armadura (**5**) sobre tu objetivo principal; hasta 5 acumulaciones sobre un jefe.
7. Provocar (**F**) cuando un enemigo ataca a otra persona.
8. Ira de sobra: Golpe heroico (**1**) contra un enemigo, Rajar (**Shift-4**, desde el 20) contra dos o más.
**Cada 10 niveles:**
- 10: Actitud defensiva (**Ctrl-2**), Provocar (**F**), Hender armadura (**5**), Ira sangrienta (**F1**). Luego Azote de escudo (**E**) en el 12, Revancha (**2**) y Grito desmoralizador (**Shift-2**) en el 14, Bloqueo con escudo (**Z**) en el 16, Desarmar (**V**) en el 18.
- 20: Última carga (**X**, un talento): un 30% más de salud máxima durante 20 segundos. Ataque de la victoria (**F2**), Rajar (**Shift-4**). Luego Grito intimidador (**Shift-Q**) en el 22, Vanguardia (un talento, pasivo) en el 25, Grito desafiante (**Shift-F**) en el 26, Muro de escudo (**C**) en el 28. Los niveles de talento de aquí son los más tempranos; una ventaja puede adelantarlos hasta 5 niveles.
- 30: Arremetida de conmoción (**Shift-V**, un talento): un aturdimiento de 5 segundos. Actitud rabiosa (**Ctrl-3**, de una misión). Luego Bastión (un talento, pasivo) en el 35.
- 40: Embate con escudo (**3**, un talento). Malla de placas en el instructor: puedes llevar placas.
- 50: nada nuevo para este rol. Rangos más fuertes de Embate con escudo, Revancha, Hender armadura y Atronar.
- 60: otra vez rangos más fuertes; nada nuevo para este rol.
**Errores de principiante:**
- Pensar que Atronar golpea a todo el grupo de enemigos. Golpea a 4 enemigos; un quinto puede correr hacia el sanador.
- Dejar enemigos detrás de ti. Por la espalda no puedes bloquear, esquivar ni parar, y Revancha no se ilumina.
- Provocar contra un enemigo que ya te ataca. Entonces no hace nada.]] },
			{ band = 1, title = "Armas: daño con un arma grande", body = [[
Desde el nivel 1. Llevas un arma grande de dos manos y casi siempre estás en Actitud de batalla. Los grandes pasos son Golpes de barrido en el 30 y Golpe mortal en el 40. Un arma nueva es tu mayor mejora. No tienes cura propia, salvo Ataque de la victoria (desde el 20), así que la comida y las vendas siguen siendo útiles. Las guías no se ponen de acuerdo sobre qué árbol sube de nivel más rápido; los tres funcionan.
**Orden sencillo:**
1. Actitud de batalla (**Ctrl-1**), Grito de batalla (**Shift-X**).
2. Cargar (**R**) para empezar.
3. Desgarrar (**Shift-Z**), si el enemigo va a vivir un rato.
4. Abrumar (**2**, desde el 12) en cuanto se ilumine.
5. Golpe mortal (**3**, desde el 40) cada vez que esté listo; guarda 30 de Ira para él.
6. Ataque de la victoria (**F2**, desde el 20) después de matar, cuando te falta salud.
7. Dos enemigos: Golpes de barrido (**Q**, desde el 30), y luego Rajar (**Shift-4**, desde el 20). Antes del 30: Atronar (**Shift-1**).
8. Ira de sobra: Golpe heroico (**1**).
**Cada 10 niveles:**
- 10: Golpe heroico (**1**), Cargar (**R**), Desgarrar (**Shift-Z**), Atronar (**Shift-1**), Seccionar (**V**), Grito de batalla (**Shift-X**), Ira sangrienta (**F1**). Luego Abrumar (**2**) en el 12, Grito desmoralizador (**Shift-2**) en el 14.
- 20: Ataque de la victoria (**F2**), Rajar (**Shift-4**), Embate (**Shift-C**), Represalias (**C**). Luego Ejecutar (**4**) en el 24, Golpe de lanza (**F3**, un talento) en el 25: un golpe extra fuerte contra Gigantes y Dragonantes. Los niveles de talento de aquí son los más tempranos; una ventaja puede adelantarlos hasta 5 niveles.
- 30: Golpes de barrido (**Q**, un talento, solo en Actitud de batalla): tus 5 golpes siguientes también golpean a un enemigo junto a tu objetivo. Actitud rabiosa (**Ctrl-3**, de una misión) con Interceptar (**R**) e Ira rabiosa (**Shift-V**). Luego Embate mejorado (un talento, pasivo) en el 35, Torbellino (**2** en Actitud rabiosa) en el 36, Zurrar (**E** en Actitud rabiosa) en el 38.
- 40: Golpe mortal (**3**, un talento): el enemigo recibe un 50% menos de curación durante 10 segundos. Malla de placas en el instructor.
- 50: Temeridad (**Q** en Actitud rabiosa). Rangos más fuertes de Golpe mortal.
- 60: otra vez rangos más fuertes; nada nuevo para este rol.
**Errores de principiante:**
- Pulsar Golpe heroico (**1**) todo el tiempo. Ese golpe no da Ira, así que no te queda nada para Golpe mortal ni Abrumar.
- Embate (**Shift-C**) antes del talento Embate mejorado: 1,5 segundos de lanzamiento que retrasan tu golpe normal. La mayoría de las guías no lo usan hasta entonces.
- Buscar una interrupción en **E** con un arma de dos manos. Azote de escudo necesita un escudo; tu interrupción es Zurrar (38, Actitud rabiosa).]] },
			{ band = 2, title = "Furia: daño con dos armas", body = [[
Un arma en cada mano, desde el nivel 20 (Doble empuñadura en el instructor). Hasta entonces, usa tu mejor arma (una de dos manos está bien) y juega como Armas. Furia se vuelve fuerte de verdad con Torbellino (36) y Sed de sangre (40). Necesitas dos armas buenas. Torbellino, Zurrar, Interceptar e Ira rabiosa solo funcionan en Actitud rabiosa, así que cambias de actitud a menudo.
**Orden sencillo (desde el 36; antes, juega como Armas):**
1. Grito de batalla (**Shift-X**). Ira sangrienta (**F1**) para tener Ira.
2. Cargar (**R**) en Actitud de batalla (**Ctrl-1**).
3. Deseo de muerte (**Shift-3**, desde el 30) contra un enemigo fuerte.
4. Actitud rabiosa (**Ctrl-3**): Torbellino (**2**, desde el 36) cada vez que esté listo.
5. Sed de sangre (**3**, desde el 40) cada vez que esté lista. Las guías no coinciden en cuál de estos dos va primero.
6. Ataque de la victoria (**F2**) después de matar, cuando te falta salud.
7. Ira de sobra: Golpe heroico (**1**); contra dos enemigos, Rajar (**Shift-4**).
8. Poca Ira: Golpes temerarios (**Shift-F1**, desde el 25; cuesta salud).
**Cada 10 niveles:**
- 10: nada nuevo para este rol: juegas como Armas, con un arma.
- 20: Doble empuñadura en el instructor: ahora puedes llevar un arma en la otra mano. Aullido perforador (**Shift-R**, un talento): ralentiza a todos los enemigos cerca de ti. Ataque de la victoria (**F2**), Rajar (**Shift-4**). Luego Ejecutar (**4**) en el 24, Golpes temerarios (**Shift-F1**, un talento) en el 25. Los niveles de talento de aquí son los más tempranos; una ventaja puede adelantarlos hasta 5 niveles.
- 30: Deseo de muerte (**Shift-3**, un talento). Actitud rabiosa (**Ctrl-3**, de una misión) con Interceptar (**R**) e Ira rabiosa (**Shift-V**). Luego Torbellino (**2** en Actitud rabiosa) en el 36, Zurrar (**E** en Actitud rabiosa) en el 38.
- 40: Sed de sangre (**3**, un talento; necesitas Deseo de muerte antes). No cura; te hace correr más rápido. Malla de placas en el instructor.
- 50: Temeridad (**Q** en Actitud rabiosa). Rangos más fuertes de Sed de sangre.
- 60: otra vez rangos más fuertes; nada nuevo para este rol.
**Errores de principiante:**
- Jugar Furia con un arma buena y una segunda mala.
- Buscar Torbellino (**2**) en Actitud de batalla. Solo funciona en Actitud rabiosa, y allí Desgarrar y Atronar no funcionan.
- Deseo de muerte (**Shift-3**) en un combate que podrías perder. Durante 30 segundos también recibes un 5% más de daño.]] },
		},
		MAGE = {
			{ band = 1, title = "Arcano: daño a distancia", body = [[
Desde el nivel 8 (Misiles Arcanos). Explosión Arcana es un talento, como pronto en el 20; hasta entonces juegas como cualquier mago, con Descarga de Escarcha, Bola de Fuego y Misiles Arcanos. Las guías no coinciden: algunas dicen que Arcano es fuerte para subir de nivel, la mayoría aconseja Escarcha y dice que Arcano gasta mucho maná. Su árbol no tiene ralentizaciones, así que es el más débil para mantener lejos a los enemigos. Un **canalizado** es un hechizo que dura mientras estás quieto; moverte lo detiene. Misiles Arcanos es uno.
**Orden sencillo:**
1. Abre con Descarga de Escarcha (**2**): así el enemigo llega despacio.
2. Explosión Arcana (**Ctrl-2**, desde el 20): una o dos, contra un jefe hasta cuatro. Cada una hace que la siguiente cueste más maná.
3. ¿Se ilumina Tromba de misiles (desde el 15)? Misiles Arcanos (**3**) enseguida: gratis y el doble de rápido.
4. Cólera arcana (**Shift-F1**, desde el 25) cada vez que esté lista.
5. ¿El enemigo está cerca de ti? Nova de Escarcha (**V**), apártate.
6. Casi muerto: tu varita (**Ctrl-3**, hasta el 40) o Explosión de Fuego (**5**).
7. Enemigo duro o jefe: Presencia mental (**Shift-3**, desde el 30), y luego Cólera arcana para un gran golpe instantáneo. Desde el 40 también Poder Arcano (**Q**).
Varios enemigos: Nova de Escarcha (**V**), y luego Deflagración Arcana (**Shift-2**, desde el 14). ¿Poco maná? Evocación (**F1**, desde el 20).
**Cada 10 niveles:**
- 10: Nova de Escarcha (**V**). Primer talento: Canalización mejorada (Misiles Arcanos ya no se corta cuando recibes golpes). Luego Deflagración Arcana (**Shift-2**) en el 14, Tromba de misiles (un talento, pasivo) en el 15. Los niveles de talento de aquí son los más tempranos; una ventaja puede adelantarlos hasta 5 niveles.
- 20: Explosión Arcana (**Ctrl-2**, un talento). Traslación (**R**), Evocación (**F1**), Escudo de maná (**Z**). Luego Contrahechizo (**E**) en el 24, Cólera arcana (**Shift-F1**, un talento; necesitas Explosión Arcana antes) en el 25.
- 30: Presencia mental (**Shift-3**, un talento): tu siguiente hechizo con menos de 10 segundos de lanzamiento es instantáneo. Armadura de hielo (**Shift-Z**). Luego Armadura de mago (bloque D) en el 34.
- 40: Poder Arcano (**Q**, un talento; necesitas Presencia mental antes): durante 15 segundos tus hechizos hacen un 30% más de daño, pero cuestan un 30% más de maná. Descarga de Pirofrío ocupa **Ctrl-3**: pon tu varita (Disparar) en tu propia tecla Alt.
- 50: rangos más fuertes de Explosión Arcana, Cólera arcana y Misiles Arcanos; nada nuevo para este rol.
- 60: otra vez rangos más fuertes; nada nuevo para este rol.
**Errores de principiante:**
- Pulsar Explosión Arcana una y otra vez. Cada una hace que la siguiente cueste un 100% más de maná; te quedas sin maná rápido.
- Moverte durante Misiles Arcanos. Es un canalizado: moverte lo detiene.
- Poder Arcano contra un enemigo normal. También hace que tus hechizos cuesten más, y tiene una reutilización de 3 minutos.]] },
			{ band = 2, title = "Fuego: daño a distancia", body = [[
Desde el nivel 1 (Bola de Fuego). Piroexplosión es un talento, como pronto en el 20. El juego de verdad de Fuego empieza con Calentamiento (como pronto en el 25); antes, Piroexplosión solo sirve para abrir. Las guías dicen que Fuego hace el mayor daño contra un enemigo, y sube de nivel rápido, pero con más riesgo que Escarcha: no tiene congelaciones propias. Un **crítico** es un golpe de suerte, más fuerte.
**Orden sencillo:**
1. Abre desde lejos con Piroexplosión (**4**, desde el 20). Antes: Bola de Fuego (**1**).
2. Bola de Fuego (**1**) como tu hechizo normal.
3. Explosión de Fuego (**5**) cada vez que esté lista. Desde el 25 cada Explosión de Fuego da una acumulación de Calentamiento.
4. ¿Dos o tres acumulaciones de Calentamiento (desde el 25)? Piroexplosión (**4**).
5. Enemigo cerca: Agostar (**Ctrl-1**, desde el 22) en lugar de Bola de Fuego, o Nova de Escarcha (**V**) y apártate. Desde el 30, Ola explosiva (**F3**) después.
6. Casi muerto: tu varita (**Ctrl-3**, hasta el 40) o Explosión de Fuego.
7. Élite o jefe, desde el 40: Combustión (**Q**).
Varios enemigos: Nova de Escarcha (**V**), Fogonazo (**Shift-4**, desde el 16), Ola explosiva (**F3**, desde el 30).
**Cada 10 niveles:**
- 10: Nova de Escarcha (**V**). Primer talento: Acelerante (Bola de Fuego se lanza más rápido). Luego Ignición e Impacto (talentos) en el 15, Fogonazo (**Shift-4**) en el 16. Los niveles de talento de aquí son los más tempranos; una ventaja puede adelantarlos hasta 5 niveles.
- 20: Piroexplosión (**4**, un talento): 6 segundos de lanzamiento, así que solo para abrir. Traslación (**R**), Evocación (**F1**), Resguardo contra el Fuego (**F4**), Escudo de maná (**Z**). Luego Agostar (**Ctrl-1**) en el 22, Contrahechizo (**E**) en el 24, Calentamiento (un talento, pasivo; necesitas Piroexplosión antes) en el 25: un crítico con Bola de Fuego, Descarga de Pirofrío, Explosión de Fuego o Agostar hace tu siguiente Piroexplosión un 25% más rápida, hasta 3 acumulaciones.
- 30: Ola explosiva (**F3**, un talento): instantánea, a tu alrededor; los enemigos van un 50% más lentos durante 6 segundos. Masa crítica (un talento). Armadura de hielo (**Shift-Z**). Luego Poder de Fuego (un talento) en el 35.
- 40: Combustión (**Q**, un talento; necesitas Masa crítica antes). Descarga de Pirofrío ocupa **Ctrl-3**: pon tu varita (Disparar) en tu propia tecla Alt.
- 50: rangos más fuertes de Bola de Fuego, Piroexplosión, Ola explosiva y Descarga de Pirofrío; nada nuevo para este rol.
- 60: otra vez rangos más fuertes; nada nuevo para este rol.
**Errores de principiante:**
- Lanzar Piroexplosión cuando el enemigo ya está encima de ti. 6 segundos de lanzamiento es demasiado lento entonces.
- Pensar que tres acumulaciones de Calentamiento hacen Piroexplosión instantánea. Sigue teniendo 1,5 segundos de lanzamiento: quédate quieto.
- Buscar un Bloque de hielo. Fuego no tiene. Tu salida: Nova de Escarcha (**V**), Traslación (**R**), Ola explosiva (**F3**).]] },
			{ band = 3, title = "Escarcha: daño a distancia", body = [[
Desde el nivel 4 (Descarga de Escarcha); Nova de Escarcha llega en el 10. Lanza de hielo es un talento, como pronto en el 20. Para subir de nivel es la primera opción de la mayoría de las guías: dicen que es la más segura. Arranca de verdad hacia el 30. **Congelado** = el enemigo está congelado en su sitio y no puede moverse.
**Orden sencillo:**
1. Descarga de Escarcha (**2**) desde tan lejos como puedas. Cada golpe ralentiza al enemigo.
2. ¿Enemigo Congelado (por Nova de Escarcha, o por el talento Congelamiento)? Lanza de hielo (**F**, desde el 20).
3. ¿El enemigo está cerca? Nova de Escarcha (**V**), apártate, Descarga de Escarcha, y luego Lanza de hielo.
4. ¿Se ilumina Dedos de Escarcha (desde el 30)? Lanza de hielo.
5. Lanza de hielo no está lista y el enemigo está cerca: Cono de frío (**Shift-F**, desde el 26).
6. Casi muerto: tu varita (**Ctrl-3**, hasta el 40) o Explosión de Fuego (**5**).
Varios enemigos (desde el 20): Nova de Escarcha (**V**), apártate, Ventisca (**Shift-1**), y luego Cono de frío (**Shift-F**). En apuros: Bloque de hielo (**C**, desde el 25), Traslación (**R**).
**Cada 10 niveles:**
- 10: Nova de Escarcha (**V**). Primer talento: Descarga de Escarcha mejorada (un lanzamiento más corto). Luego Congelamiento (un talento) en el 15: tus ralentizaciones pueden congelar al enemigo durante 5 segundos. Los niveles de talento de aquí son los más tempranos; una ventaja puede adelantarlos hasta 5 niveles.
- 20: Lanza de hielo (**F**, un talento): un 300% más de daño contra un enemigo Congelado. Ventisca (**Shift-1**), Traslación (**R**), Evocación (**F1**), Escudo de maná (**Z**). Luego Resguardo contra la Escarcha (**F2**) en el 22, Contrahechizo (**E**) en el 24, Bloque de hielo (**C**, un talento) en el 25, Cono de frío (**Shift-F**) en el 26.
- 30: Mordedura de frío (**Shift-C**, un talento): reinicia la reutilización de tus otros hechizos de Escarcha; su propia reutilización es de 10 minutos. Dedos de Escarcha (un talento; necesitas Lanza de hielo antes): tus 2 hechizos siguientes actúan como si el enemigo estuviera Congelado. Armadura de hielo (**Shift-Z**). Luego Escalofrío invernal (un talento) en el 35.
- 40: Barrera de hielo (**X**, un talento; necesitas Mordedura de frío antes): un escudo que absorbe daño. Descarga de Pirofrío ocupa **Ctrl-3**: pon tu varita (Disparar) en tu propia tecla Alt.
- 50: rangos más fuertes de Descarga de Escarcha, Cono de frío, Armadura de hielo, Barrera de hielo y Ventisca; nada nuevo para este rol.
- 60: otra vez rangos más fuertes; nada nuevo para este rol.
**Errores de principiante:**
- Lanza de hielo contra un enemigo que no está Congelado. Entonces es un golpe pequeño.
- Pulsar Explosión de Fuego justo antes de congelar. Explosión de Fuego y Lanza de hielo comparten una reutilización de 8 segundos.
- Gastar Mordedura de frío para nada. Tiene una reutilización de 10 minutos: guárdala para cuando las cosas salgan mal.]] },
		},
		PRIEST = {
			{ band = 1, title = "Disciplina: sanador", body = [[
Desde el nivel 1: Sanación inferior la tienes desde el principio. Sus hechizos propios llegan más tarde: Amparo de alma en el 25 y Penitencia en el 30, los dos como pronto. En un grupo es el más fuerte curando a una persona: el tanque. Subir de nivel en solitario funciona con Punición, Fuego Sagrado y tu varita, más tarde Penitencia; las guías no coinciden en si es más rápido que Sombra. **Alma debilitada**: después de un Palabra de poder: escudo, la misma persona no puede recibir un escudo nuevo durante 15 segundos.
**Orden sencillo (en grupo):**
1. Palabra de poder: escudo (**Z**) en el tanque, justo antes del pull. **Pull** = el primer golpe que empieza un combate.
2. Renovar (**F4**) en el tanque.
3. Penitencia (**Shift-F1**, desde el 30) en quien esté herido, cada vez que esté lista.
4. Tu gran cura (**C**) contra el daño normal.
5. Sanación relámpago (**F2**, desde el 20) cuando C es demasiado lenta.
6. Más gente herida: Rezo de sanación (**Shift-2**, desde el 30).
7. Enfoque interno (**F1**, desde el 20) antes de una cura cara. Infusión de poder (**Q**, desde el 40) en ti o en un lanzador.
En solitario: Escudo (**Z**), Fuego Sagrado (**4**, desde el 20), Punición (**1**), Explosión mental (**3**), Palabra de las Sombras: dolor (**2**), Penitencia si no la necesitas para curar, y luego tu varita (**5**).
**Cada 10 niveles:**
- 10: Sanación inferior (**C**), Palabra de poder: escudo (**Z**), Renovar (**F4**), Resurrección (**F3**, solo fuera de combate), Punición (**1**). Luego Fuego interno (**Shift-Z**) en el 12, Curar enfermedad (**Shift-C**) en el 14, Sanar (**C**) en el 16, Disipar magia (**Shift-V**) en el 18.
- 20: Sanación relámpago (**F2**), Fuego Sagrado (**4**), Resguardo de miedo (bloque D). Enfoque interno (**F1**, un talento): tu siguiente hechizo no cuesta maná y es crítico más a menudo; reutilización de 3 minutos. Luego Amparo de alma (un talento, pasivo) en el 25: Escudo no tiene reutilización y cuesta menos. Los niveles de talento de aquí son los más tempranos; una ventaja puede adelantarlos hasta 5 niveles.
- 30: Penitencia (**Shift-F1**, un talento): cura a un amigo o daña a un enemigo; reutilización de 12 segundos. Rezo de sanación (**Shift-2**), Espíritu divino (bloque D). Luego Suprimir enfermedad (**Shift-C**) en el 32, Égida divina (un talento, pasivo) en el 35.
- 40: Infusión de poder (**Q**, un talento; necesitas Penitencia antes): un 20% más de daño y curación con hechizos; reutilización de 3 minutos. Sanación superior ocupa **C**.
- 50: rangos más fuertes de Penitencia, Rezo de sanación, Sanación relámpago y Renovar. Rezo de entereza (**Shift-X**) en el 48.
- 60: otra vez rangos más fuertes; nada nuevo para este rol.
**Errores de principiante:**
- Escudar al mismo jugador dos veces seguidas. Alma debilitada lo impide. Es por jugador: otra persona puede recibir un escudo enseguida.
- Penitencia contra un enemigo para curar a tu grupo. Cura o daña, no las dos cosas.
- Rezo de sanación en el jugador equivocado. Cura al grupo del jugador que eliges.]] },
			{ band = 2, title = "Sagrado: sanador", body = [[
Desde el nivel 1: Sanación inferior la tienes desde el principio. Sagrado es el sanador de grupo. En solitario sube de nivel despacio: las guías aconsejan hacer misiones con Punición y tu varita, y curar en calabozos. Sus hechizos propios llegan tarde: Nova Sagrada en el 20 y Rezo de alivio en el 40, los dos como pronto.
**Orden sencillo (en grupo):**
1. Renovar (**F4**) en el tanque cuando empieza el pull. **Pull** = el primer golpe que empieza un combate.
2. Rezo de alivio (**Ctrl-2**, desde el 40) en el tanque antes del pull, y otra vez cada vez que esté listo.
3. Tu gran cura (**C**) contra el daño normal.
4. Sanación relámpago (**F2**, desde el 20) cuando C llegaría demasiado tarde.
5. Todo el grupo herido: Rezo de sanación (**Shift-2**, desde el 30). Nova Sagrada (**Shift-1**, desde el 20) solo cuando todos están justo a tu lado; cuesta mucho maná.
6. Palabra de poder: escudo (**Z**) para ganar tiempo.
7. Un enemigo te ataca: Desvanecerse (**F**).
**Cada 10 niveles:**
- 10: Sanación inferior (**C**), Palabra de poder: escudo (**Z**), Renovar (**F4**), Resurrección (**F3**, solo fuera de combate). Luego Fuego interno (**Shift-Z**) en el 12, Curar enfermedad (**Shift-C**) en el 14, Sanar (**C**) en el 16, Disipar magia (**Shift-V**) en el 18.
- 20: Nova Sagrada (**Shift-1**, un talento): instantánea; daña a los enemigos a tu alrededor y cura a tu grupo, sin amenaza. Sanación relámpago (**F2**), Fuego Sagrado (**4**), Resguardo de miedo (bloque D). Luego Vinculación sagrada (un talento, pasivo) en el 25: Sanación relámpago sobre otra persona te cura a ti la mitad. Los niveles de talento de aquí son los más tempranos; una ventaja puede adelantarlos hasta 5 niveles.
- 30: Rezo de sanación (**Shift-2**), Espíritu divino (bloque D). Espíritu redentor (un talento, pasivo). Luego Suprimir enfermedad (**Shift-C**) en el 32, Sanación espiritual (un talento, pasivo) en el 35.
- 40: Rezo de alivio (**Ctrl-2**, un talento; necesitas Espíritu redentor antes): cura en cuanto el objetivo recibe daño, y luego salta a otro miembro del grupo, hasta 5 veces; reutilización de 10 segundos. Sanación superior ocupa **C**.
- 50: rangos más fuertes de Rezo de alivio, Nova Sagrada, Rezo de sanación y Renovar. Rezo de entereza (**Shift-X**) en el 48.
- 60: otra vez rangos más fuertes; nada nuevo para este rol.
**Errores de principiante:**
- Rezo de sanación en el jugador equivocado. Cura al grupo del jugador que eliges, no al tuyo.
- Sanación relámpago para todo. Es rápida pero cara; guárdala para emergencias.
- Nova Sagrada en un grupo que está lejos. Solo funciona justo a tu alrededor, y cuesta mucho.]] },
			{ band = 3, title = "Sombra: daño a distancia", body = [[
Desde el nivel 4 (Palabra de las Sombras: dolor); Explosión mental llega en el 10. Tortura mental es un talento, como pronto en el 20; Forma de las Sombras en el 40. La mayoría de las guías sube de nivel como Sombra; algunas juegan Disciplina hasta el 40. Al principio, tu varita hace gran parte del trabajo. Sombra no tiene ningún hechizo que golpee a muchos enemigos a la vez. Un **DoT** es daño en pequeñas partes durante unos segundos. Un **canalizado** es un hechizo que dura mientras estás quieto.
**Orden sencillo:**
1. Palabra de poder: escudo (**Z**) sobre ti, si el enemigo va a llegar hasta ti.
2. Explosión mental (**3**) desde lejos, para empezar.
3. Palabra de las Sombras: dolor (**2**).
4. Peste devoradora (**Shift-3**, desde el 20) contra un enemigo que va a vivir un rato.
5. Tortura mental (**1**, desde el 20), y déjala llegar hasta el final. Antes: Punición (**1**).
6. Remata con tu varita (**5**).
¿Poco maná? Sáltate Peste devoradora y Tortura mental, y usa tu varita antes. Desde el 32: Palabra de las Sombras: muerte (**Shift-4**) solo cuando vaya a matar al enemigo. Desde el 40: activa Forma de las Sombras (**Ctrl-1**) antes del primer pull, y déjala activa.
**Cada 10 niveles:**
- 10: Explosión mental (**3**), reutilización de 8 segundos. Ya tienes Punición (**1**), Palabra de las Sombras: dolor (**2**), Palabra de poder: escudo (**Z**), Desvanecerse (**F**) y tu varita (**5**). Luego Fuego interno (**Shift-Z**) en el 12, Alarido psíquico (**V**) en el 14.
- 20: Tortura mental (un talento): ocupa la tecla **1** en lugar de Punición. Peste devoradora (**Shift-3**): un DoT que también te cura; reutilización de 24 segundos. Luego Abrazo vampírico (**Ctrl-3**, un talento) en el 25 o el 30: tu grupo se cura un 20% de tu daño de Sombras. Los niveles de talento de aquí son los más tempranos; una ventaja puede adelantarlos hasta 5 niveles.
- 30: Silencio (**E**, un talento): tu **interrupción** (detiene el hechizo de un enemigo); reutilización de 45 segundos. Control mental (**Shift-F**). Luego Palabra de las Sombras: muerte (**Shift-4**) en el 32, Levitar (**R**) en el 34.
- 40: Forma de las Sombras (**Ctrl-1**, un talento; necesitas Abrazo vampírico antes): un 10% más de daño de Sombras, los hechizos de Sombras cuestan la mitad, recibes un 15% menos de daño físico, pero no hay hechizos de curación. Antes: Oscuridad (un talento, pasivo) en el 35.
- 50: rangos más fuertes de Tortura mental, Explosión mental, Palabra de las Sombras: dolor, Peste devoradora y Palabra de las Sombras: muerte. Rezo de entereza (**Shift-X**) en el 48.
- 60: rangos más fuertes de Tortura mental y Peste devoradora; nada nuevo para este rol.
**Errores de principiante:**
- Palabra de las Sombras: muerte contra un enemigo con mucha salud. Si no muere, pierdes un 30% de tu propia salud.
- Parar Tortura mental antes de tiempo. Con el talento Tortura mental mejorada, el último golpe de daño es el más fuerte.
- Abrir con Explosión mental en un grupo. Causa mucha amenaza (las ganas que tiene un enemigo de atacarte): deja que el tanque vaya primero. Si un enemigo te ataca: Desvanecerse (**F**).]] },
		},
		ROGUE = {
			{ band = 1, title = "Asesinato: dagas y veneno", body = [[
Desde el nivel 1 (Golpe siniestro y Eviscerar). Luchas cuerpo a cuerpo, con dagas y veneno. Usas **Energía**, que se rellena sola. Tus golpes dan **puntos de combo** (hasta 5) sobre el enemigo que golpeas; un **remate** los gasta todos. Mutilar es un talento, como pronto en el 40, y necesita una daga en cada mano. Hasta entonces juegas con Puñalada o Golpe siniestro. Las guías no dicen que este sea el comienzo más fácil: el gran paso solo llega con Mutilar.
**Orden sencillo:**
1. Desde el 20: veneno en las dos armas (objetos, en el bloque D).
2. Espera a tener la Energía llena. Desde el 18 (Presto) tu primer ataque cuesta entonces 10 de Energía menos.
3. Sigilo (**Shift-R**), ponte detrás del enemigo. **Sigilo** = avanzar a escondidas, para que el enemigo no te vea. Abre con Emboscada (**2**, desde el 18, daga en tu mano principal) o Garrote (**1**, desde el 14). Enemigo fuerte, desde el 26: Golpe bajo (**V**), un aturdimiento de 4 segundos.
4. Puntos de combo: Puñalada (**2**) cuando estás detrás del enemigo; si no, Golpe siniestro (**1**). Desde el 40: Mutilar (**3**), 2 puntos cada vez.
5. Punzar (**Shift-3**, desde el 24) cada vez que esté listo. Con Veneno (desde el 30) cada Punzar hace tu veneno más fuerte durante 6 segundos.
6. Remate: Hacer picadillo (**Shift-4**) en un combate largo; si no, Eviscerar (**4**) con 5 puntos. Ruptura (**5**, desde el 20) contra un enemigo que va a vivir mucho (un élite, un jefe).
7. Sangre fría (**F1**, desde el 25) justo antes de un Eviscerar con 5 puntos.
**Cada 10 niveles:**
- 10: ya tienes Golpe siniestro (**1**), Eviscerar (**4**), Puñalada (**2**), Sigilo (**Shift-R**), Gubia (**Shift-Q**) y Evasión (**Z**). Nuevo en el 10: Hacer picadillo (**Shift-4**), Sprint (**R**), Porrazo (**Shift-Q** en Sigilo), y un arma en cada mano (Doble empuñadura). Luego Patada (**E**) en el 12, Garrote (**1** en Sigilo) y Exponer armadura (**Shift-Z**) en el 14, Amago (**F**) en el 16, Emboscada (**2** en Sigilo) y Presto (pasivo) en el 18.
- 20: Ruptura (**5**). Venenos, de una misión. Luego Esfumarse (**X**) en el 22, Punzar (**Shift-3**) en el 24, Sangre fría (**F1**, un talento) en el 25: tu siguiente Golpe siniestro, Puñalada, Emboscada, Eviscerar o Mutilar es crítico seguro (**crítico** = un golpe de suerte, más fuerte); reutilización de 3 minutos. Golpe bajo (**V** en Sigilo) en el 26. Los niveles de talento de aquí son los más tempranos; una ventaja puede adelantarlos hasta 5 niveles.
- 30: Veneno (un talento, pasivo: sin tecla): cada Punzar da a tu veneno un 30% más de daño y un 20% más de probabilidad de aplicarse, durante 6 segundos. Golpe en los riñones (**V**). Luego Ceguera (**Shift-V**) en el 34, Sellar destino (un talento, pasivo) en el 35: un crítico con un ataque que da puntos de combo te da un punto extra.
- 40: Mutilar (**3**, un talento; necesitas Veneno antes): 60 de Energía, golpea con las dos dagas, 2 puntos de combo, un 20% más de daño contra un enemigo envenenado. Luego Hacer picadillo rango 2 en el 42, Punzar rango 2 en el 44.
- 50: Mutilar rango 2 y Golpe en los riñones rango 2; nada nuevo para este rol.
- 60: Mutilar rango 3 y rangos más fuertes; nada nuevo para este rol.
**Errores de principiante:**
- Mutilar sin dagas. Necesita una daga en cada mano: consigue tu segunda daga antes del nivel 40.
- Olvidar Punzar. Veneno solo funciona a través de Punzar.
- Cambiar a otro enemigo con puntos de combo sobre el anterior. Los puntos no vienen contigo.]] },
			{ band = 2, title = "Combate: daño constante con cualquier arma", body = [[
Desde el nivel 1 (Golpe siniestro y Eviscerar). No necesitas estar detrás del enemigo: tu golpe principal es Golpe siniestro. Funciona con cualquier arma de una mano: espada, hacha, maza, arma de puño o daga. Varias guías dicen que Combate es el árbol más fácil para subir de nivel en solitario. Aconsejan un arma lenta en tu mano principal y una rápida en la otra mano. Usas **Energía**, que se rellena sola; tus golpes dan **puntos de combo**, y un **remate** los gasta. Aluvión de acero (como pronto en el 30) es lo único que tiene un Pícaro contra dos enemigos a la vez.
**Orden sencillo:**
1. Espera a tener la Energía llena (Presto, desde el 18).
2. Abre desde Sigilo (**Shift-R**) con Garrote (**1**, desde el 14), o desde el 26 con Golpe bajo (**V**). Acercarte y atacar sin más también está bien.
3. Golpe siniestro (**1**) para puntos de combo.
4. Contestación (**Shift-F1**, desde el 20) en cuanto se ilumine: pasa después de que paras un ataque.
5. Punzar (**Shift-3**, desde el 24) cuando esté listo.
6. Remate: Hacer picadillo (**Shift-4**) en un combate largo; si no, Eviscerar (**4**) con 5 puntos. Las guías no coinciden en lo pronto que hay que mantener activo Hacer picadillo.
7. Dos enemigos: Aluvión de acero (**Shift-1**, desde el 30). Desde el 40, junto con Subidón de adrenalina (**Q**), para un combate duro. ¿Vas perdiendo? Evasión (**Z**).
**Cada 10 niveles:**
- 10: ya tienes Golpe siniestro (**1**), Eviscerar (**4**), Sigilo (**Shift-R**), Gubia (**Shift-Q**) y Evasión (**Z**). Nuevo en el 10: Hacer picadillo (**Shift-4**), Sprint (**R**), Porrazo (**Shift-Q** en Sigilo), y un arma en cada mano. Luego Patada (**E**) en el 12, Garrote (**1** en Sigilo) y Exponer armadura (**Shift-Z**) en el 14, Amago (**F**) en el 16, Presto (pasivo) en el 18.
- 20: Contestación (**Shift-F1**, un talento; necesitas Desvío antes): solo funciona justo después de que paras un ataque. 10 de Energía, y el enemigo queda desarmado durante 6 segundos. Ruptura (**5**), y Venenos de una misión. Luego Esfumarse (**X**) en el 22, Punzar (**Shift-3**) en el 24, Ejecución impecable (un talento, pasivo) en el 25: Eviscerar cuesta 15 de Energía menos. Golpe bajo (**V** en Sigilo) en el 26. Los niveles de talento de aquí son los más tempranos; una ventaja puede adelantarlos hasta 5 niveles.
- 30: Aluvión de acero (**Shift-1**, un talento): durante 15 segundos atacas un 20% más rápido, y cada golpe también golpea a un segundo enemigo cercano; reutilización de 2 minutos. Cortar y rebanar (un talento, pasivo): una mejora que depende de tu arma. Golpe en los riñones (**V**). Luego Ceguera (**Shift-V**) en el 34, Destello de acero (un talento, pasivo) en el 35: Punzar da hasta 15 de Energía extra y está listo hasta 2 segundos antes.
- 40: Subidón de adrenalina (**Q**, un talento; necesitas Aluvión de acero antes): durante 15 segundos tu Energía se rellena el doble de rápido; reutilización de 5 minutos. Luego Hacer picadillo rango 2 en el 42 (un 30% más rápido en lugar de un 20%), Punzar rango 2 en el 44 (25 de Energía de vuelta en lugar de 15).
- 50: Golpe en los riñones rango 2 y rangos más fuertes; nada nuevo para este rol.
- 60: rangos más fuertes; nada nuevo para este rol.
**Errores de principiante:**
- Aluvión de acero junto a un enemigo que sacaste del combate con Porrazo, Gubia o Ceguera. Los golpes extra lo despiertan.
- Pulsar Contestación cuando no has parado nada. Solo funciona justo después de parar.
- Puñalada o Emboscada con una espada, un hacha o una maza. Las dos necesitan una daga en tu mano principal.]] },
			{ band = 3, title = "Sutileza: golpea desde Sigilo", body = [[
Desde el nivel 1 (Golpe siniestro y Sigilo). Este árbol lucha desde Sigilo: un primer golpe fuerte, y muchos puntos de combo antes de que el combate empiece de verdad. **Sigilo** = avanzar a escondidas, para que el enemigo no te vea. Las guías dicen que subir de nivel en solitario va más lento que con Combate. Hemorragia es un talento, como pronto en el 30: barato, de frente, con cualquier arma. Marca mortal es un talento, como pronto en el 40. Emboscada y Puñalada necesitan una daga en tu mano principal; Hemorragia y Golpe fantasmal no.
**Orden sencillo:**
1. Sigilo (**Shift-R**). ¿Un segundo Humanoide cerca? Porrazo (**Shift-Q**). Porrazo no rompe el Sigilo.
2. Premeditación (**Shift-C**, desde el 20): 2 puntos de combo sobre el enemigo. Luego tu primer golpe.
3. Primer golpe por la espalda: Emboscada (**2**, desde el 18, daga en tu mano principal). Enemigo fuerte, desde el 26: Golpe bajo (**V**), un aturdimiento de 4 segundos. Las guías no coinciden en la mejor apertura.
4. Golpe fantasmal (**Shift-X**, desde el 25) y Punzar (**Shift-3**, desde el 24) cada vez que estén listos.
5. Puntos de combo: desde el 30, Hemorragia (**3**). Antes: Puñalada (**2**) cuando estás detrás del enemigo; si no, Golpe siniestro (**1**).
6. Remate: Eviscerar (**4**) cuando el enemigo está casi muerto; Ruptura (**5**) contra un enemigo que va a vivir mucho; Hacer picadillo (**Shift-4**) en un combate largo.
7. Desde el 40: Marca mortal (**Q**) contra el enemigo más fuerte, mejor mientras Ruptura o Garrote están activos.
8. Emergencia: Esfumarse (**X**). Preparación (**F3**, desde el 30) deja listos otra vez Esfumarse, Evasión y Sprint enseguida.
**Cada 10 niveles:**
- 10: ya tienes Golpe siniestro (**1**), Eviscerar (**4**), Puñalada (**2**), Sigilo (**Shift-R**), Gubia (**Shift-Q**) y Evasión (**Z**). Nuevo en el 10: Porrazo (**Shift-Q** en Sigilo), Hacer picadillo (**Shift-4**), Sprint (**R**), y un arma en cada mano. Luego Patada (**E**) en el 12, Garrote (**1** en Sigilo) en el 14, Amago (**F**) en el 16, Emboscada (**2** en Sigilo) y Presto (pasivo) en el 18.
- 20: Premeditación (**Shift-C**, un talento): 2 puntos de combo sobre tu objetivo; úsalos en 20 segundos, o se pierden; reutilización de 2 minutos. Ruptura (**5**), y Venenos de una misión. Luego Esfumarse (**X**) en el 22, Punzar (**Shift-3**) en el 24, Golpe fantasmal (**Shift-X**, un talento) en el 25: 40 de Energía, 1 punto de combo, un 15% más de esquiva durante 7 segundos; reutilización de 20 segundos. Golpe bajo (**V** en Sigilo) en el 26. Los niveles de talento de aquí son los más tempranos; una ventaja puede adelantarlos hasta 5 niveles.
- 30: Hemorragia (**3**, un talento; necesitas Espadas dentadas antes): 35 de Energía, 1 punto de combo, funciona de frente; durante 15 segundos tu Ruptura y tu Garrote hacen un 15% más de daño a ese enemigo. Preparación (**F3**, un talento): deja lista enseguida la reutilización de tus otros hechizos de Pícaro; su propia reutilización es de 10 minutos. Consigues uno de estos dos en el 30, el otro en el 31. Golpe en los riñones (**V**). Luego Ceguera (**Shift-V**) en el 34, Cuchillo de bota (un talento, pasivo) en el 35: Punzar puede dar 2 puntos de combo.
- 40: Marca mortal (**Q**, un talento; necesitas Preparación antes): un remate, 25 de Energía, reutilización de 10 segundos. Durante 6 segundos guarda parte de tu daño (más por punto de combo), y luego lo inflige de una vez, hasta un límite. El daño de Ruptura y de Garrote cuenta doble. Luego Hacer picadillo rango 2 y Esfumarse rango 2 en el 42, Punzar rango 2 en el 44, Marca mortal rango 2 en el 48.
- 50: Golpe en los riñones rango 2, Marca mortal rango 3 en el 56; nada nuevo para este rol.
- 60: Marca mortal rango 4 y rangos más fuertes; nada nuevo para este rol.
**Errores de principiante:**
- Emboscada o Puñalada sin una daga en tu mano principal, o de frente.
- Usar Premeditación y luego esperar. Los 2 puntos se pierden después de 20 segundos, y la reutilización es de 2 minutos.
- Marca mortal sin puntos de combo. Es un remate.]] },
		},
		HUNTER = {
			{ band = 1, title = "Bestias: daño con tu mascota", body = [[
Desde el nivel 10 (tu mascota, de las misiones de clase). Tu mascota hace la mayor parte del trabajo: mantiene ocupado al enemigo mientras tú disparas desde lejos. Todas las guías que leímos eligen Bestias para subir de nivel: dicen que es el más fácil y el más rápido. Nuevo en Forever: Invocar halcón (un talento, como pronto en el 25) manda pájaros extra a tu objetivo. Punto débil: los grupos de enemigos. Tu mascota solo puede retener a uno.
**Orden sencillo:**
Antes de empezar: activa Aspecto del halcón (**Shift-R**). El talento Aspectos mortales solo funciona entonces.
1. Marca del cazador (**Shift-Z**).
2. Mascota al ataque (**Ctrl-1**), y espera hasta que tenga al enemigo.
3. Picadura de serpiente (**2**).
4. Invocar halcón (**Shift-F1**, desde el 25): mantén 2 halcones todo el tiempo.
5. Disparo de puntería (**4**, desde el 20) mientras estás quieto. Dos o más enemigos: Multidisparo (**Shift-1**) en su lugar. Comparten una reutilización.
6. Disparo automático (**1**) sigue disparando. Disparo Arcano (**3**): antes del 25, úsalo sin más. Desde el 25, solo cuando ya tienes 2 halcones: comparte reutilización con Invocar halcón.
7. Mascota casi muerta: Aliviar mascota (**F2**). Enemigo encima de ti: Intimidación (**Shift-3**, desde el 30) o Separación (**Z**, desde el 20). Separación no es un salto: hace que el enemigo tenga menos ganas de atacarte, de cerca, y detiene tu ataque automático. Apuros de verdad: Fingir muerte (**X**, desde el 30).
8. Enemigo duro: Cólera de las bestias (**F1**, desde el 40) junto con Fuego rápido (**Q**, desde el 26).
**Cada 10 niveles:**
- 10: tu mascota, de las misiones de clase. Aspecto del halcón (**Shift-R**). Primeros talentos: Aspectos mortales, Entrenamiento de robustez. Los niveles de talento de aquí son los más tempranos; una ventaja puede adelantarlos hasta 5 niveles. Luego Aliviar mascota (**F2**) en el 12, Multidisparo (**Shift-1**) en el 18.
- 20: Disparo de puntería (**4**, del instructor), Aspecto del guepardo (**R**), Separación (**Z**), Trampa congelante (**V**). Talentos: Presteza bestial (tu mascota corre un 30% más rápido; la necesitas para Intimidación), Furia desatada, Encontrar camino.
- 30: Intimidación (**Shift-3**, un talento): tu mascota aturde al enemigo durante 3 segundos con su siguiente golpe; reutilización de 1 minuto. Fingir muerte (**X**). Antes: Invocar halcón (**Shift-F1**, un talento) en el 25: un halcón se queda 18 segundos, como máximo 2 a la vez. Fuego rápido (**Q**) en el 26.
- 40: Cólera de las bestias (**F1**, un talento; los 30 puntos anteriores tienen que estar en Bestias): tu mascota hace un 50% más de daño durante 18 segundos; reutilización de 2 minutos. Salva (bloque D). Antes: Trampa explosiva ocupa **Shift-2** en el 34, Frenesí (un talento, pasivo) en el 35.
- 50: rangos más fuertes de Invocar halcón, Disparo de puntería y Aliviar mascota; nada nuevo para este rol. Después del 40, las guías ponen tus puntos en Puntería.
- 60: otra vez rangos más fuertes; nada nuevo para este rol.
**Errores de principiante:**
- Disparar antes de que tu mascota tenga al enemigo. Entonces el enemigo viene hacia ti.
- Ver Invocar halcón y Disparo Arcano como dos botones separados. Comparten una reutilización: primero los halcones.
- Luchar en Aspecto del guepardo o en Aspecto del mono. Aspectos mortales solo funciona con Aspecto del halcón activo.]] },
			{ band = 2, title = "Puntería: daño a distancia", body = [[
Desde el nivel 1 (Disparo automático). Tus propios disparos hacen el trabajo, desde lejos. Disparo de puntería llega en el 20, del instructor: no es un talento. Disparo de francotirador es un talento, como pronto en el 40: 4 segundos de lanzamiento, y llega hasta 45 metros. Las guías dicen que subir de nivel funciona, pero más lento que con Bestias: tu mascota retiene peor al enemigo, porque tú haces más daño. En grupos es fuerte: Aura de disparo certero ayuda a todo tu grupo o tu banda. Lobo solitario (un talento, como pronto en el 20) da un 20% más de daño mientras no tienes mascota; para subir de nivel, las guías se quedan con la mascota.
**Orden sencillo:**
Antes de empezar: activa Aspecto del halcón (**Shift-R**) y Aura de disparo certero (**Shift-X**, desde el 25).
1. Marca del cazador (**Shift-Z**). Con mascota: mascota al ataque (**Ctrl-1**).
2. Enemigo todavía lejos: Disparo de francotirador (**Shift-4**, desde el 40) para abrir.
3. Picadura de serpiente (**2**). Algunas guías se la saltan en combates cortos.
4. Disparo de puntería (**4**, desde el 20) cada vez que esté listo. Quédate quieto.
5. Disparo Arcano (**3**) entre medias, si tu maná lo permite.
6. Disparo automático (**1**) sigue disparando.
7. Un grupo de enemigos: Multidisparo (**Shift-1**) en lugar de Disparo de puntería. Un grupo grande: Salva (bloque D, desde el 40).
8. Enemigo encima de ti: Disparo de dispersión (**E**, desde el 30), y luego apártate. Disparo de conmoción (**Shift-Q**) lo ralentiza.
9. Enemigo duro: Fuego rápido (**Q**, desde el 26) al principio.
**Cada 10 niveles:**
- 10: tu mascota, de las misiones de clase. Aspecto del halcón (**Shift-R**). Primeros talentos: Ataques letales, Ojo de halcón, Disparo de conmoción mejorado; desde el 15: Afinar la puntería, Eficacia, Picaduras mejoradas. Los niveles de talento de aquí son los más tempranos; una ventaja puede adelantarlos hasta 5 niveles. Luego Multidisparo (**Shift-1**) en el 18.
- 20: Disparo de puntería (**4**), del instructor: 2 segundos de lanzamiento, reutilización de 6 segundos, compartida con Multidisparo. Talentos: Matanza rápida, Disparo arcano mejorado, Lobo solitario. Aspecto del guepardo (**R**), Separación (**Z**), Trampa congelante (**V**).
- 30: Disparo de dispersión (**E**, un talento): el enemigo queda desorientado durante 4 segundos, y cualquier daño lo rompe; reutilización de 30 segundos. Fingir muerte (**X**). Antes: Aura de disparo certero (**Shift-X**, un talento) en el 25: más Poder de ataque a distancia para tu grupo, durante 30 minutos. Fuego rápido (**Q**) en el 26.
- 40: Disparo de francotirador (**Shift-4**, un talento; necesitas Aura de disparo certero antes): reutilización de 15 segundos, y tus 3 disparos siguientes llegan 10 metros más lejos. Salva (bloque D). Antes: Aura de disparo certero rango 2 en el instructor en el 32, Especialización en armas a distancia (un talento, pasivo) en el 35.
- 50: rangos más fuertes: Disparo de puntería en el 44 y el 52, Disparo de francotirador en el 48, Aura de disparo certero y Salva en el 50. Después del 40, las guías ponen tus puntos en Bestias.
- 60: otra vez rangos más fuertes; nada nuevo para este rol.
**Errores de principiante:**
- Moverte durante Disparo de puntería o Disparo de francotirador. Tienen 2 y 4 segundos de lanzamiento.
- Multidisparo contra un solo enemigo. Entonces tampoco tienes Disparo de puntería durante 6 segundos.
- Disparo de francotirador cuando el enemigo ya está encima de ti. Tiene 4 segundos de lanzamiento, y no funciona a menos de 8 metros.]] },
			{ band = 3, title = "Supervivencia: daño cuerpo a cuerpo, con trampas", body = [[
Desde el nivel 1 (Golpe de raptor), pero el juego de verdad de Supervivencia empieza hacia el 30. En Forever este es el Cazador cuerpo a cuerpo: Golpe de raptor, Mordedura de mangosta, Contraataque y Patada de zancudo, más trampas. Conservas tu mascota y tu arma a distancia: abre desde lejos, y luego acércate. Las guías dicen que es el más lento de los tres para subir de nivel; hasta el 30, más o menos, juegas como cualquier Cazador (mascota al ataque, disparar). Cuesta mucho maná, y un gran golpe tuyo puede quitarle el enemigo a tu mascota. Las guías no se ponen de acuerdo sobre cuál es la mejor arma cuerpo a cuerpo.
**Orden sencillo:**
Antes de empezar: Aspecto del halcón (**Shift-R**) mientras disparas. Desde el 30, Aspecto de la bestia para luchar de cerca; no tiene tecla fija, así que ponlo en tu propia barra.
1. Marca del cazador (**Shift-Z**). Sin la Marca, Exponer presa no funciona.
2. Mascota al ataque (**Ctrl-1**).
3. Picadura de serpiente (**2**), y luego Disparo Arcano (**3**) mientras el enemigo se acerca, o mientras caminas hacia él.
4. Una trampa a tus pies: Trampa de inmolación (**Shift-2**, desde el 16). Desde el 34 esa tecla es Trampa explosiva, y Trampa de inmolación no tiene tecla: ponla en tu propia barra si la quieres.
5. De cerca: Mordedura de mangosta (**Shift-C**, desde el 16) en cuanto se ilumine. Golpe de raptor (**5**) cada vez que esté listo. Patada de zancudo (desde el 30) cada vez que esté lista; ponla en tu propia barra. Las guías no coinciden: algunas se apartan para disparar después de Patada de zancudo, otras se quedan cerca.
6. Contraataque (**Shift-V**) justo después de parar un ataque.
7. El enemigo huye, o quieres distancia otra vez: Cortar alas (**Shift-F**).
8. En apuros: Disuasión (**C**, desde el 20), Fingir muerte (**X**, desde el 30).
**Cada 10 niveles:**
- 10: tu mascota, de las misiones de clase. Golpe de raptor (**5**) lo tienes desde el nivel 1. Primeros talentos: Rastreo mejorado, Desvío; desde el 15: Golpes salvajes, Superviviente, Atrapar, Cortar alas mejorado. Los niveles de talento de aquí son los más tempranos; una ventaja puede adelantarlos hasta 5 niveles. Luego Cortar alas (**Shift-F**) en el 12, Mordedura de mangosta (**Shift-C**) y Trampa de inmolación (**Shift-2**) en el 16.
- 20: Disuasión (**C**, un talento): un 25% más de esquiva y de parada durante 10 segundos; reutilización de 5 minutos. Trampa congelante (**V**), Disparo de puntería (**4**), Doble empuñadura (pasiva, del instructor). Separación (**Z**): no es un salto; baja tu **amenaza** (las ganas que tiene un enemigo de atacarte) de cerca, y detiene tu ataque automático. Talentos: Pies de plomo, Trampas inteligentes.
- 30: Patada de zancudo (un talento; sin tecla fija, ponla en tu propia barra): 100% del daño del arma, y luego corres un 30% más rápido durante 3 segundos; reutilización de 8 segundos. Aspecto de la bestia (del instructor; ponlo en tu propia barra): más Poder de ataque. Fingir muerte (**X**). Antes: Contraataque (**Shift-V**, un talento), desde el 25 o el 30 (las fuentes no coinciden): se activa después de que paras, y retiene al enemigo en su sitio durante 5 segundos. Filo de depredador (un talento, pasivo) desde el 25. También en esta fila: Exponer presa, Inventiva, Disciplina de superviviente.
- 40: Golpes cortantes (un talento, pasivo; necesitas Exponer presa antes): Mordedura de mangosta también hace sangrar al enemigo. Antes: Trampa explosiva ocupa **Shift-2** en el 34, Reflejos de relámpago (un talento, pasivo) en el 35.
- 50: rangos más fuertes: Contraataque en el 42 y el 54, Mordedura de mangosta en el 44, Trampa explosiva en el 44 y el 54, Golpe de raptor en el 48, Aspecto de la bestia en el 50. Las guías no coinciden en dónde van tus puntos después del 40.
- 60: otra vez rangos más fuertes; nada nuevo para este rol.
**Errores de principiante:**
- Entrar corriendo directamente. Abre desde lejos (Marca, mascota, Picadura, un disparo), y luego acércate.
- Pulsar Mordedura de mangosta o Contraataque cuando no se iluminan. Mordedura de mangosta solo funciona después de esquivar (o mediante Exponer presa), Contraataque solo después de parar.
- Quedarte en Aspecto del halcón de cerca después del nivel 30. El halcón solo ayuda a tus disparos; Aspecto de la bestia da Poder de ataque.]] },
		},
		SHAMAN = {
			{ band = 1, title = "Elemental: daño a distancia", body = [[
Desde el nivel 1: Descarga de relámpagos la tienes desde el principio. Rayos y fuego desde lejos. Choque de llamas llega en el 10, Cadena de relámpagos en el 32. Maestría en relámpagos es un talento, como pronto en el 40. Las guías suben de nivel como Mejora: Elemental funciona, pero gasta muchísimo maná, tienes que estar quieto para lanzar, y muchos enemigos a la vez son difíciles.
**Orden sencillo:**
Antes de empezar: activa Escudo de relámpagos (**Shift-Z**, desde el 8). Tótem abrasador (**5**, desde el 10) al suelo antes del pull.
1. Abre desde lejos con Descarga de relámpagos (**1**).
2. Choque de llamas (**2**, desde el 10) contra un enemigo que va a vivir mucho.
3. Descarga de relámpagos (**1**) como relleno.
4. Tres o más enemigos: Nova de Fuego (**Shift-4**, desde el 12) y Cadena de relámpagos (**Shift-1**, desde el 32) cuando estén listas.
5. Maestría en relámpagos (**Q**, desde el 40) contra un élite o un grupo grande.
6. Guarda Choque de tierra (**E**) para cuando el enemigo lance un hechizo: interrumpe el lanzamiento.
Poca salud: Ola de sanación (**C**). Enemigo demasiado cerca: Tótem Nexo Terrestre (**V**) o Choque de Escarcha (**4**, desde el 20).
**Cada 10 niveles:**
- 10: Descarga de relámpagos (**1**), Choque de tierra (**E**, desde el 4), Escudo de relámpagos (**Shift-Z**, desde el 8). Choque de llamas (**2**), Tótem abrasador (**5**, de una misión). Primeros talentos: Convección, Conmoción (pasivo). Los niveles de talento de aquí son los más tempranos; una ventaja puede adelantarlos hasta 5 niveles. Luego Nova de Fuego (**Shift-4**) y Purgar (**Shift-Q**) en el 12, Tótem de tremor (**Shift-F**) en el 18.
- 20: Choque de Escarcha (**4**), Lobo fantasmal (**R**), Llamada de los elementos (**Ctrl-1**). Enfoque elemental (un talento, pasivo). Luego Llamado totémico (**Shift-R**) en el 22. Vinculado a la tierra (un talento) en el 25: Tótem Nexo Terrestre (**V**) retiene a los enemigos en su sitio durante 5 segundos, solo en el momento en que lo colocas. Tótem de Magma (bloque D) en el 26.
- 30: Llamada del trueno (un talento, pasivo). Tótem derribador (**X**), Llamada de los ancestros (**Ctrl-2**), Reencarnación (pasiva). Sobrecarga eléctrica (un talento, pasivo). Luego Cadena de relámpagos (**Shift-1**) en el 32, Furia elemental (un talento, pasivo) en el 35.
- 40: Maestría en relámpagos (**Q**, un talento): durante 15 segundos Descarga de relámpagos se lanza 0,5 segundos más rápido y Cadena de relámpagos no tiene reutilización; reutilización de 3 minutos. Llamada de los espíritus (**Ctrl-3**), Sanación en cadena (**Shift-2**). Armadura de malla (Malla) en el instructor.
- 50: rangos más fuertes de Descarga de relámpagos, Cadena de relámpagos, Choque de tierra, Choque de llamas, Nova de Fuego y Tótem abrasador; nada nuevo para este rol.
- 60: otra vez rangos más fuertes; nada nuevo para este rol.
**Errores de principiante:**
- Choque de tierra para hacer daño en un grupo. Causa mucha **amenaza** (las ganas que tiene un enemigo de atacarte). Y comparte su reutilización con Choque de llamas: después ya no tienes interrupción.
- Cadena de relámpagos contra un solo enemigo. Cuesta mucho maná y tiene una reutilización de 6 segundos.
- Rematar a cada enemigo con un hechizo. El maná es tu límite: golpea con tu arma a un enemigo que está casi muerto.]] },
			{ band = 2, title = "Mejora: daño cuerpo a cuerpo", body = [[
Desde el nivel 1: golpeas con tu arma, con Arma Muerdepiedras puesta. Las guías suben de nivel como Mejora: dicen que es la opción cómoda. Usa un arma lenta de dos manos. Golpe de tormenta es un talento, como pronto en el 25; Arma Viento Furioso llega en el 30, del instructor. El maná es tu límite: cuando se acaba, deja de lanzar hechizos y sigue golpeando. El consejo de una guía para el buff de arma: Arma Muerdepiedras sola, Arma Lengua de Fuego en un grupo, Arma Viento Furioso desde el 30. En un grupo pequeño, Mejora puede tanquear un rato con Arma Muerdepiedras (Parar da entonces más amenaza), pero no hay provocación ni reutilización defensiva.
**Orden sencillo:**
Antes de empezar: buff de arma puesto (bloque D), Escudo de relámpagos (**Shift-Z**), Tótem abrasador (**5**) o tus tótems al suelo.
1. Haz pull con Descarga de relámpagos (**1**). **Pull** = golpear a un enemigo desde lejos, para que venga hacia ti.
2. Golpe de tormenta (**3**, desde el 25) cada vez que esté listo.
3. Descarga de relámpagos (**1**) con 5 acumulaciones de Arma vorágine (desde el 35): entonces es instantánea y gratis.
4. Choque de tierra (**E**). En un grupo, alterna con Choque de llamas (**2**).
5. Nova de Fuego (**Shift-4**, desde el 12) cuando hay un tótem de Fuego colocado y te sobra maná; sobre todo contra más enemigos.
6. Ira del clarividente (**Q**, desde el 40) contra un élite o un pull grande.
7. Si no, sigue golpeando.
Después del combate: Ola de sanación (**C**). Emergencia durante un combate: Ola de sanación inferior (**F2**, desde el 20).
**Cada 10 niveles:**
- 10: Arma Muerdepiedras (bloque D), Descarga de relámpagos (**1**), Choque de tierra (**E**, desde el 4), Escudo de relámpagos (**Shift-Z**, desde el 8). Choque de llamas (**2**), Tótem abrasador (**5**), Tótem Fuerza de la tierra (**Shift-X**), Arma Lengua de Fuego (bloque D). Primeros talentos: Golpes atronadores y otros (pasivos); Maña mental (pasivo) desde el 15. Los niveles de talento de aquí son los más tempranos; una ventaja puede adelantarlos hasta 5 niveles. Luego Nova de Fuego (**Shift-4**) en el 12.
- 20: Lobo fantasmal (**R**), Choque de Escarcha (**4**), Ola de sanación inferior (**F2**), Llamada de los elementos (**Ctrl-1**). Enfoque chamanístico (un talento, pasivo): los choques y Escudo de relámpagos cuestan un 45% menos de maná. Luego Golpe de tormenta (**3**, un talento) en el 25. Aluvión (un talento, pasivo) desde el 25. Lobo fantasmal mejorado (un talento) desde el 25: Lobo fantasmal es más rápido (instantáneo con los dos puntos) y también funciona en interiores; las guías lo toman en niveles muy distintos. Tótem de Magma (bloque D) en el 26.
- 30: Arma Viento Furioso (bloque D). Golpe de tormenta mejorado y Parar (talentos). Tótem derribador (**X**), Llamada de los ancestros (**Ctrl-2**). Luego Tótem Viento Furioso en el 32 (sin tecla: usa la barra de tótems), Cadena de relámpagos (**Shift-1**) en el 32, Arma vorágine (un talento, pasivo) en el 35.
- 40: Ira del clarividente (**Q**, un talento): golpeas un 30% más rápido durante 25 segundos; solo golpea tu arma, no tus hechizos. Reutilización de 3 minutos. No todas las guías lo toman en el 40: algunas van primero a Restauración por el maná. Llamada de los espíritus (**Ctrl-3**), armadura de malla, un Arma Viento Furioso más fuerte. Luego Tótem Gracia del aire en el 42 (sin tecla: usa la barra de tótems).
- 50: rangos más fuertes de Arma Viento Furioso, Arma Muerdepiedras, Choque de tierra, Descarga de relámpagos y Tótem Fuerza de la tierra; nada nuevo para este rol.
- 60: otra vez rangos más fuertes; nada nuevo para este rol.
**Errores de principiante:**
- Descarga de relámpagos con menos de 5 acumulaciones de Arma vorágine. Reinicia tu temporizador de golpe. Y Arma vorágine solo ayuda a Descarga de relámpagos: no a las curas, no a Cadena de relámpagos.
- Arma Muerdepiedras en un grupo mientras tú haces el daño, cuando ya tienes Parar. Con Muerdepiedras haces un 30% más de amenaza, sin ella un 30% menos. Usa Lengua de Fuego o Viento Furioso.
- Buscar una provocación. El Chamán no tiene ninguna. Tótem Garra de piedra (**F**) hace que los enemigos ataquen al tótem, no a ti.]] },
			{ band = 3, title = "Restauración: sanador", body = [[
Desde el nivel 1: Ola de sanación la tienes desde el principio, y es tu cura principal mientras subes de nivel. Las guías no aconsejan subir de nivel en solitario como Restauración (los enemigos mueren despacio), pero es buena en grupo. Entre calabozos haces misiones con Descarga de relámpagos y Choque de llamas. Mareas Vivas es un talento, como pronto en el 40. Un Chamán puede quitar Veneno y Enfermedad, pero ni maldiciones ni magia.
**Orden sencillo (en grupo):**
Antes de empezar: Escudo de agua (**Shift-Z**, desde el 20). Tótems al suelo: Llamada de los elementos (**Ctrl-1**, desde el 20) o Tótem Corriente de sanación (**F4**, desde el 20).
1. Mareas Vivas (**Shift-F1**, desde el 40) en el tanque o en quien reciba daño.
2. Sanación en cadena (**Shift-2**, desde el 40) en ese mismo objetivo cuando hay más gente herida.
3. Ola de sanación (**C**) para una persona o para el tanque.
4. Ola de sanación inferior (**F2**, desde el 20) cuando tiene que ser rápido.
5. Emergencia: Presteza de la Naturaleza (**Shift-3**, desde el 30), y luego Ola de sanación (**C**).
6. Tótem Marea de maná (**F1**, desde el 25) cuando se te acaba el maná.
7. Nadie herido: Descarga de relámpagos (**1**).
**Cada 10 niveles:**
- 10: Ola de sanación (**C**). Primeros talentos: Ola de sanación mejorada (una Ola de sanación más rápida), Enfoque de las mareas (pasivo). Los niveles de talento de aquí son los más tempranos; una ventaja puede adelantarlos hasta 5 niveles. Luego Espíritu ancestral (**F3**, fuera de combate) en el 12, Curar envenenamiento (**Shift-C**) en el 16, Tótem de tremor (**Shift-F**) en el 18.
- 20: Ola de sanación inferior (**F2**), Tótem Corriente de sanación (**F4**, de una misión), Llamada de los elementos (**Ctrl-1**), Lobo fantasmal (**R**). Escudo de agua (**Shift-Z**, un talento): 3 orbes de agua; cuando te golpean o uno de tus hechizos es crítico, recuperas un 2% de tu maná por orbe. Dura 10 minutos. Desde entonces Shift-Z lanza Escudo de agua, no Escudo de relámpagos. Luego Curar enfermedad (**Shift-V**) en el 22. Tótem Marea de maná (**F1**, un talento) en el 25: devuelve maná a tu grupo; reutilización de 5 minutos. Tótem Fuente de maná en el 26 (sin tecla: usa la barra de tótems).
- 30: Presteza de la Naturaleza (**Shift-3**, un talento): tu siguiente hechizo de Naturaleza con menos de 10 segundos de lanzamiento es instantáneo; reutilización de 3 minutos. Camino de sanación (un talento, pasivo). Tótem derribador (**X**), Llamada de los ancestros (**Ctrl-2**), Reencarnación (pasiva). Luego Purificación (un talento, pasivo) en el 35, un Tótem Marea de maná más fuerte en el 38.
- 40: Sanación en cadena (**Shift-2**). Mareas Vivas (**Shift-F1**, un talento; necesitas Camino de sanación antes): una cura durante 15 segundos, no una cura instantánea, y una Sanación en cadena que lances directamente sobre ese objetivo cura un 25% más; reutilización de 12 segundos. Llamada de los espíritus (**Ctrl-3**), armadura de malla.
- 50: rangos más fuertes de Mareas Vivas, Sanación en cadena, Ola de sanación, Ola de sanación inferior, Tótem Marea de maná y Tótem Corriente de sanación; nada nuevo para este rol.
- 60: otra vez rangos más fuertes; nada nuevo para este rol.
**Errores de principiante:**
- Sanación en cadena sobre alguien que no es tu objetivo de Mareas Vivas. El extra solo cuenta cuando la lanzas directamente sobre ese objetivo.
- Pulsar solo Presteza de la Naturaleza. No cura nada por sí sola: hace instantáneo tu siguiente hechizo de Naturaleza. Pulsa Ola de sanación justo después.
- Intentar quitar una maldición. Un Chamán no puede; solo Veneno (**Shift-C**) y Enfermedad (**Shift-V**).]] },
		},
		WARLOCK = {
			{ band = 1, title = "Aflicción: daño con el tiempo", body = [[
Desde el nivel 4 (Corrupción) y el 8 (Terror de agonía). Pones DoTs sobre el enemigo y dejas que tu demonio lo retenga. La mayoría de las guías suben de nivel como Aflicción. Succionar vida es un talento, como pronto en el 30. Arruinar es un talento, como pronto en el 40: mientras lo canalizas, tus Succionar vida, Corrupción y Terror de agonía sobre ese enemigo hacen daño un 100% más rápido. Arruinar no te cura.
**Orden sencillo:**
1. Manda a tu demonio al ataque (**Ctrl-1**).
2. Terror de agonía (**5**) para hacer pull. Su daño empieza bajo, así que tu demonio se queda con el enemigo.
3. Corrupción (**2**). Con Corrupción mejorada 5/5 es instantánea (como pronto en el 14).
4. Succionar vida (**F4**, desde el 30), solo contra un enemigo que va a vivir mucho.
5. Inmolar (**3**) solo contra un enemigo duro.
6. Enemigo duro: añade tu maldición (**Shift-V**). Las guías no coinciden en lo pronto.
7. Relleno: hasta el nivel 30, más o menos, tu varita (Disparar; no está en el bloque, ponla en tu propia barra), y luego Drenar vida (**C**). Las guías no coinciden del todo en cuándo cambiar.
8. ¿Se ilumina Trance de las Sombras (Ocaso, desde el 25)? Descarga de las Sombras (**1**): entonces es instantánea.
9. Desde el 40: Arruinar (bloque D) en lugar de Drenar vida cuando tu salud está bien. Pon primero tus DoTs.
10. ¿Más salud que maná? Transfusión de vida (**F**).
11. ¿Necesitas un Fragmento de alma? Remata al enemigo con Drenar alma (**4**).
Dos enemigos: DoTs sobre el primero, Miedo (**V**) sobre él, y luego lucha contra el segundo. El daño puede romper Miedo, y las guías no coinciden en poner DoTs antes de Miedo.
**Cada 10 niveles:**
- 10: Drenar alma (**4**), Crear piedra de salud (bloque D), el Abisario (misión). Ya tienes Descarga de las Sombras (**1**), Inmolar (**3**), Corrupción (**2**, 4), Maldición de debilidad (**Shift-V**, 4), Transfusión de vida (**F**, 6), Terror de agonía (**5**, 8) y Miedo (**V**, 8). Primer talento: Corrupción mejorada o Supresión (las guías no coinciden). Los niveles de talento de aquí son los más tempranos; una ventaja puede adelantarlos hasta 5 niveles. Luego Cauce de salud (**F2**) en el 12; Drenar vida (**C**) y Corrupción rango 2 (15 segundos) en el 14; Drenajes mejorados y Cosecha de almas (talentos, pasivos) desde el 15; Dolor abrasador (bloque D) y Crear piedra de alma en el 18.
- 20: Amplificar maldición (**Shift-3**, un talento): tu siguiente Maldición de debilidad o Terror de agonía es un 50% más fuerte; reutilización de 3 minutos. Maldición de los Elementos (**Shift-V**), Armadura demoníaca (**Shift-Z**), Lluvia de Fuego (**Shift-1**), el Súcubo o el Íncubo (misión). Luego Corrupción rango 3 (18 segundos) y Drenar maná en el 24. Maldición de agotamiento (**R**, un talento; necesitas Amplificar maldición antes) en el 25: el enemigo va un 30% más lento durante 12 segundos. Ocaso (un talento, pasivo) en el 25: una pequeña probabilidad de que tu siguiente Descarga de las Sombras sea instantánea. Desterrar (**Shift-Q**) en el 28.
- 30: Succionar vida (**F4**, un talento): pasa salud del enemigo a ti, durante 30 segundos. Succión de alma (un talento, pasivo): Drenar vida, Drenar alma y Arruinar hacen más por cada Corrupción, Succionar vida y Terror de agonía tuyos sobre el enemigo. Drenar vida rango 3, Llamas infernales (**Shift-2**), el Manáfago (misión). Luego Resguardo contra las Sombras (**Z**) en el 32, Maestría de las Sombras (un talento, pasivo) en el 35, Succionar vida rango 2 y Drenar vida rango 4 en el 38.
- 40: Arruinar (bloque D, un talento; necesitas Succionar vida antes): un canalizado de 6 segundos que hace daño cada segundo y hace que tus DoTs sobre ese enemigo hagan daño un 100% más rápido. Aullido de terror (**Shift-F**), el Corcel vil (misión). Luego Espiral de la muerte (**X**) en el 42, Fuego de alma (**Q**) y Succionar vida rango 3 en el 48.
- 50: Inferno (**F3**). Maldición de los Elementos rango 4. Por lo demás, rangos más fuertes.
- 60: Terror de fatalidad (**F1**): un gran golpe después de 60 segundos; no sobre jugadores. Por lo demás, rangos más fuertes.
**Errores de principiante:**
- Volver a poner Terror de agonía demasiado pronto. Sus golpes más fuertes llegan al final.
- Usar Arruinar cuando necesitas salud. Arruinar no cura; Drenar vida sí.
- Maldición de temeridad sobre el enemigo al que quieres dar Miedo. Ese enemigo ignora el Miedo.]] },
			{ band = 2, title = "Demonología: daño con tu demonio", body = [[
Desde el nivel 1 (el Diablillo), de verdad desde el 10 (el Abisario). Tu demonio hace gran parte del trabajo, y los talentos lo hacen más fuerte. Las guías no coinciden en cuándo entrar en este árbol: algunas entran desde el 10, otras suben primero como Aflicción y cambian hacia el 26 o el 27. Sacrificio demoníaco (como pronto en el 20) solo vale la pena con Pacto demoníaco (como pronto en el 40). Antes, cualquier demonio que invocas quita el buff.
**Orden sencillo:**
1. Manda a tu demonio al ataque (**Ctrl-1**), y deja que golpee primero.
2. Desde el 30: activa Enlace de alma (**Shift-X**), y otra vez después de cada invocación.
3. Desde el 25 (Marca demoníaca): Dolor abrasador (bloque D) sobre el enemigo de tu demonio. Otra vez cuando la marca desaparece (10 segundos). Antes de Marca demoníaca: nada de Dolor abrasador.
4. Terror de agonía (**5**) y Corrupción (**2**) sobre enemigos que viven lo suficiente. Aquí Corrupción tiene 2 segundos de lanzamiento.
5. Relleno: tu varita (no está en el bloque, ponla en tu propia barra) o Descarga de las Sombras (**1**). Drenar vida (**C**) cuando necesitas salud.
6. Demonio casi muerto: Cauce de salud (**F2**). Cuesta tu propia salud.
7. Transfusión de vida (**F**). Con Energías demoníacas tu demonio también recibe maná.
8. Desde el 40 (Pacto demoníaco): Sacrificio demoníaco (**Shift-C**) sobre un demonio, y luego invoca a otro distinto (bloque D). El buff dura 2 horas. Las guías no coinciden en qué demonio sacrificar.
9. Desde el 48, con Exterminación: ¿enemigo por debajo del 35% de salud? Descarga de las Sombras o Dolor abrasador, y luego Fuego de alma (**Q**): más rápido, y sin Fragmento de alma.
**Cada 10 niveles:**
- 10: el Abisario (misión; cuesta 1 Fragmento de alma). Su Tormento da **amenaza** (las ganas que tiene un enemigo de atacarlo). Drenar alma (**4**) para conseguir fragmentos. Primeros talentos: Poder profano, Abrazo demoníaco, Diablillo mejorado, Cauce de salud mejorado (pasivos). Los niveles de talento de aquí son los más tempranos; una ventaja puede adelantarlos hasta 5 niveles. Luego Cauce de salud (**F2**) en el 12; Energías demoníacas, Vitalidad vil y Abisario mejorado (talentos, pasivos) desde el 15; Sacrificio (Abisario) en el 16; Consumir Sombras (Abisario) y Dolor abrasador (bloque D) en el 18.
- 20: Sacrificio demoníaco (**Shift-C**, un talento): sacrificas a tu demonio a cambio de un buff de 2 horas. Diablillo: un 15% más de daño de Sombras. Súcubo o Íncubo: un 15% más de daño de Fuego. Abisario: recuperas maná. Manáfago: recuperas salud. Maestro invocador (un talento, pasivo): las invocaciones son más rápidas y más baratas. El Súcubo o el Íncubo (misión). Armadura demoníaca (**Shift-Z**). Luego Sufrimiento (Abisario) en el 24. Dominación vil (**Shift-F1**, un talento; necesitas Maestro invocador antes) en el 25: tu siguiente invocación es 5,5 segundos más rápida y un 50% más barata. Marca demoníaca y Exterminación (talentos, pasivos) desde el 25.
- 30: Enlace de alma (**Shift-X**, un talento; necesitas Sacrificio demoníaco antes): el 30% del daño que recibes va a tu demonio, y los dos hacen un 3% más de daño. Dura mientras tu demonio esté ahí. El Manáfago (misión; Bloqueo de hechizo en el 36). Conocimiento demoníaco (un talento, pasivo). Luego Maestro demonólogo (un talento, pasivo) desde el 35.
- 40: Pacto demoníaco (un talento, pasivo; necesitas Enlace de alma antes): el buff de Sacrificio demoníaco se queda cuando invocas a otro demonio distinto. Solo ahora vale la pena Sacrificio demoníaco. Aullido de terror (**Shift-F**), el Corcel vil (misión). Luego Espiral de la muerte (**X**) en el 42, Fuego de alma (**Q**) en el 48.
- 50: Inferno (**F3**): un infernal; 1 Piedra infernal cada vez; reutilización de 1 hora. Por lo demás, rangos más fuertes.
- 60: Terror de fatalidad (**F1**). Por lo demás, rangos más fuertes.
**Errores de principiante:**
- Dolor abrasador antes de tener Marca demoníaca. Causa mucha amenaza y le quita el enemigo a tu demonio.
- Sacrificio demoníaco antes de Pacto demoníaco (40). Tu demonio desaparece, e invocar cualquier demonio quita el buff.
- Después de Pacto demoníaco, invocar el mismo demonio que sacrificaste. Entonces el buff desaparece.]] },
			{ band = 3, title = "Destrucción: daño con grandes golpes", body = [[
Desde el nivel 1 (Descarga de las Sombras e Inmolar). Grandes golpes de fuego y de sombras, y es el que más maná gasta. Algunas guías desaconsejan subir de nivel con él (mucho maná, poco para recuperarlo); otras dicen que se puede jugar, y una dice que es fuerte en calabozos. Conflagrar es un talento, como pronto en el 25; Incinerar es un talento, como pronto en el 40. El punto de cambio es Sombras y llamas 5/5 (como pronto en el 39): desde entonces Conflagrar ya no se come tu Inmolar, y Quemadura de las Sombras siempre te devuelve su Fragmento de alma.
**Orden sencillo:**
1. Manda a tu demonio al ataque (**Ctrl-1**).
2. Inmolar (**3**). Una guía abre con Descarga de las Sombras desde lejos, con Inmolar justo después.
3. Enemigo duro: Terror de agonía (**5**) y tu maldición (**Shift-V**).
4. Desde el 25: Conflagrar (bloque D). Antes de Sombras y llamas 5/5 se come tu Inmolar: úsalo al final de Inmolar, o como último golpe. Después: cada vez que esté listo.
5. Relleno: Descarga de las Sombras (**1**). Desde el 40, Incinerar (bloque D), con Inmolar sobre el enemigo.
6. Desde el 20: Quemadura de las Sombras (**Shift-4**) como último golpe. Así recuperas el Fragmento de alma.
7. Transfusión de vida (**F**) entre combates. Poco maná: tu varita (no está en el bloque, ponla en tu propia barra).
8. Más enemigos: desde el 30, Terror de caos (bloque D) sobre un enemigo duro, y luego ataca al resto. Lluvia de Fuego (**Shift-1**). Llamas infernales (**Shift-2**, desde el 30) solo con salud suficiente.
**Cada 10 niveles:**
- 10: Descarga de las Sombras (**1**) e Inmolar (**3**; rango 2 en el 10). Primer talento: Aterrar (lanzamientos más rápidos) o Descarga de las sombras mejorada. Los niveles de talento de aquí son los más tempranos; una ventaja puede adelantarlos hasta 5 niveles. Luego Descarga de las Sombras rango 3 en el 12 (2,8 segundos de lanzamiento); Secuelas y Cataclismo (talentos, pasivos) desde el 15; Dolor abrasador (bloque D) en el 18.
- 20: Quemadura de las Sombras (**Shift-4**, un talento): un golpe de Sombras instantáneo; cuesta 1 Fragmento de alma; reutilización de 15 segundos. Si el enemigo (uno que da PE) muere en 8 segundos, recuperas un fragmento. Ruina (un talento, pasivo): tus críticos de Destrucción golpean más fuerte. Lluvia de Fuego (**Shift-1**). Descarga de las Sombras rango 4 (3 segundos de lanzamiento). Luego Quemadura de las Sombras rango 2 en el 24. Conflagrar (bloque D, un talento) en el 25: un golpe de Fuego instantáneo contra un enemigo con tu Inmolar; ese Inmolar desaparece entonces; reutilización de 10 segundos. Llamas agonizantes e Intensidad (talentos, pasivos) desde el 25.
- 30: Terror de caos (bloque D, un talento): 5 minutos sobre un enemigo; el 15% de todo tu daño contra otros enemigos también golpea a este. Solo un enemigo a la vez. Fuego y azufre (necesitas Conflagrar antes) y Piroestruendo (necesitas Intensidad antes), talentos, pasivos. Llamas infernales (**Shift-2**). Luego Conflagrar rango 2 y Quemadura de las Sombras rango 3 en el 32; Sombras y llamas (un talento, pasivo) desde el 35, 5/5 como pronto en el 39.
- 40: Incinerar (bloque D, un talento; necesitas Terror de caos antes): 2,5 segundos de lanzamiento, un 25% más de daño cuando el enemigo tiene tu Inmolar. Conflagrar rango 3, Quemadura de las Sombras rango 4. Luego Fuego de alma (**Q**) en el 48.
- 50: Incinerar rango 2. Inferno (**F3**).
- 60: Incinerar rango 3, Conflagrar rango 6. Terror de fatalidad (**F1**).
**Errores de principiante:**
- Conflagrar justo después de Inmolar. Se come tu Inmolar (hasta Sombras y llamas 5/5).
- Quemadura de las Sombras sin Fragmento de alma, o contra un enemigo que va a vivir mucho. El fragmento solo vuelve si el enemigo muere en 8 segundos.
- Terror de caos y Terror de agonía sobre el mismo enemigo. Solo cabe un terror sobre él.]] },
		},
		PALADIN = {
			{ band = 1, title = "Sagrado: sanador", body = [[
Desde el nivel 1: Luz Sagrada la tienes desde el principio. Un **sanador** mantiene vivo al grupo. Las guías dicen que Sagrado es el árbol más lento para subir de nivel en solitario: sube de nivel como Reprensión y cura en calabozos, o juega Sagrado con un amigo. Los botones propios del árbol llegan en el 20 (Favor divino), el 25 (Juramento de Luz), el 30 (Choque Sagrado) y el 40 (Vigilia de la Luz).
**Orden sencillo (en grupo):**
Antes del pull: Bendición de sabiduría (**Shift-V**, desde el 14) sobre ti, Bendición de reyes (**Shift-X**, desde el 20) sobre los demás. Aura: Aura de devoción (**Ctrl-1**), o Aura de concentración (**Ctrl-3**, desde el 22) cuando los lanzadores reciben muchos golpes.
1. Juramento de Luz (**Shift-R**, desde el 25) en el tanque. Dura 5 minutos, y solo un jugador puede tenerlo.
2. Destello de Luz (**F2**, desde el 20) es tu cura normal. Antes del 20: Luz Sagrada (**C**).
3. Luz Sagrada (**C**) contra un golpe grande. Desde el 25 (Infusión de Luz) se lanza más rápido justo después de un crítico de Choque Sagrado o de Destello de Luz. **Crítico** = un golpe o una cura de suerte, más fuerte.
4. Choque Sagrado (**F4**, desde el 30) cuando no hay tiempo para lanzar, o mientras te mueves.
5. Todo el grupo herido, desde el 40: Vigilia de la Luz (**Shift-F1**) sobre un jugador, y luego Choque Sagrado (**F4**) sobre ese mismo jugador.
6. Favor divino (**Shift-3**, desde el 20) antes de una cura que tiene que ser grande.
7. Un efecto malo sobre un amigo: Purificar, más tarde Limpiar (**Shift-C**).
8. Emergencia: Imposición de manos (**Q**). Gasta todo el maná que te queda.
Nada que curar: tu sello (**3**), Sentencia (**2**) y Golpe Sagrado (**1**) de cerca. En solitario: juega como un Paladín de Reprensión; desde el 30, Choque Sagrado (**F4**) contra el enemigo es tu único botón de daño fuerte.
**Cada 10 niveles:**
- 10: ya tienes Luz Sagrada (**C**), Aura de devoción (**Ctrl-1**), Bendición de poderío (**Shift-Z**), Protección divina (**Z**), Martillo de Justicia (**E**) y Purificar (**Shift-C**). Nuevo en el 10: Imposición de manos (**Q**), Bendición de protección (**Shift-F**). Primer talento: Enfoque espiritual (pasivo). Los niveles de talento de aquí son los más tempranos; una ventaja puede adelantarlos hasta 5 niveles. Luego Redención (**F3**, de una misión) en el 12, Bendición de sabiduría (**Shift-V**) en el 14, Reverencia y Luz sanadora (talentos, pasivos) desde el 15, Bendición de libertad (**R**) en el 18.
- 20: Destello de Luz (**F2**), Bendición de reyes (**Shift-X**). Favor divino (**Shift-3**, un talento): tu siguiente Destello de Luz, Luz Sagrada o Choque Sagrado es crítico seguro; reutilización de 2 minutos. Iluminación (un talento, pasivo; necesitas Reverencia antes). Luego Aura de concentración (**Ctrl-3**) en el 22. Juramento de Luz (**Shift-R**, un talento) e Infusión de Luz (un talento, pasivo) en el 25.
- 30: Choque Sagrado (**F4**, un talento): instantáneo, daño a un enemigo o una cura a un amigo; reutilización de 10 segundos. Intervención divina (**F3** en combate: mueres tú). Sello de Luz (bloque D). Luego Escudo divino (**Z**) en el 34, Poder sagrado (un talento, pasivo) en el 35, Sello de sabiduría (bloque D) en el 38.
- 40: Vigilia de la Luz (**Shift-F1**, un talento; necesitas Choque Sagrado antes): sobre un amigo durante 30 segundos; tu siguiente Choque Sagrado sobre ese amigo no tiene reutilización y también cura a su grupo. Choque Sagrado rango 2. Malla de placas: puedes llevar placas. Luego Limpiar (**Shift-C**) en el 42, Bendición de sacrificio (bloque D) en el 46, Choque Sagrado rango 3 en el 48.
- 50: Vigilia de la Luz rango 2, Imposición de manos rango 3. Luego Bendición de poderío superior en el 52 y Bendición de sabiduría superior en el 54, Choque Sagrado rango 4 en el 56.
- 60: Bendición de reyes superior, Vigilia de la Luz rango 3; nada nuevo para este rol.
**Errores de principiante:**
- Luz Sagrada para cada golpe pequeño. Destello de Luz (**F2**, desde el 20) es la cura normal barata.
- Vigilia de la Luz sobre un jugador y Choque Sagrado sobre otro. La cura de grupo solo viene de Choque Sagrado sobre el MISMO jugador.
- Pulsar F3 en combate sin querer. Entonces lanza Intervención divina, y mueres tú. Fuera de combate, F3 es Redención.]] },
			{ band = 2, title = "Protección: tanque", body = [[
Desde el nivel 10 (Furia recta y Sello de furia en el instructor). El **tanque** es al que golpean los enemigos, para que el resto del grupo esté a salvo. **Amenaza** = las ganas que tiene un enemigo de atacarte. Llevas un arma de una mano y un escudo. Las guías no se ponen de acuerdo sobre lo bien que sube de nivel Protección en solitario. Los botones del árbol: Baluarte del templario en el 20, Sentencia veloz en el 25, Escudo Sagrado en el 30.
**Orden sencillo:**
1. Antes del pull: activa Furia recta (sin tecla fija: está en el bloque D, o ponla en tu propia barra; dura 30 minutos). Sello de furia (**F**), una bendición, un aura. Las guías no se ponen de acuerdo sobre el aura: Aura de devoción (**Ctrl-1**) o Aura de reprensión (**Ctrl-2**).
2. Desde el 30: Escudo Sagrado (**Shift-4**) justo antes de que los enemigos lleguen hasta ti. Púlsalo otra vez cada vez que esté listo.
3. Sentencia (**2**) sobre el primer enemigo. Con Sello de furia puesto, Sentencia es tu provocación (3 segundos). **Provocar** = hacer que el enemigo te ataque a ti.
4. Dos o más enemigos, desde el 20: Consagración (**Shift-1**) debajo de ellos. Solo los 4 primeros reciben el daño extra.
5. Golpe Sagrado (**1**) cada vez que esté listo.
6. Un enemigo corre hacia otra persona: Sentencia (**2**). ¿No está lista? Desde el 25: Sentencia veloz (**F1**), una segunda Sentencia con su propia reutilización de 1 minuto.
7. Un enemigo lanza un hechizo: Martillo de Justicia (**E**). El Paladín no tiene interrupción.
8. Exorcismo (**5**, desde el 20) contra No-muertos y Demonios. Martillo de cólera (**4**, desde el 44).
9. Viene mucho daño, desde el 20: Baluarte del templario (**X**). Último recurso: Imposición de manos (**Q**).
Poco maná: deja primero Consagración. Desde el 40 (Escudo juramentado): primero Escudo Sagrado, luego Golpe Sagrado. Si no eres el tanque (en solitario, o tanquea otro): usa tu sello en **3**, no Sello de furia.
**Cada 10 niveles:**
- 10: Furia recta (bloque D) y Sello de furia (**F**). Ya tienes Sentencia (**2**), Golpe Sagrado (**1**), Martillo de Justicia (**E**), Aura de devoción (**Ctrl-1**) y Protección divina (**Z**). También nuevo: Imposición de manos (**Q**), Bendición de protección (**Shift-F**). Primer talento: Baluarte (pasivo). Los niveles de talento de aquí son los más tempranos; una ventaja puede adelantarlos hasta 5 niveles. Luego Precisión, Favor del Guardián o Deber sagrado (talentos, pasivos) desde el 15, Aura de reprensión (**Ctrl-2**) en el 16.
- 20: Baluarte del templario (**X**, un talento): un escudo que absorbe daño igual a tu salud máxima, durante 8 segundos; reutilización de 5 minutos. Consagración (**Shift-1**), Bendición de reyes (**Shift-X**), Exorcismo (**5**). Especialización en escudos (un talento, pasivo; necesitas Baluarte antes). Luego Sentencia veloz (**F1**, un talento; necesitas Baluarte del templario antes) y Furia recta mejorada (un talento, pasivo) en el 25.
- 30: Escudo Sagrado (**Shift-4**, un talento; necesitas un escudo): un 30% más de probabilidad de bloquear durante 10 segundos, 4 cargas; reutilización de 10 segundos. Expiación (un talento, pasivo). Luego Escudo divino (**Z**) en el 34, Credo de hierro (un talento, pasivo) en el 35.
- 40: Escudo juramentado (un talento, pasivo; necesitas Escudo Sagrado antes): Golpe Sagrado cada 6 segundos, y funciona con Escudo Sagrado. Malla de placas: puedes llevar placas. Escudo Sagrado rango 2. Luego Martillo de cólera (**4**) en el 44, Bendición de sacrificio (bloque D) en el 46.
- 50: Escudo Sagrado rango 3, Cólera Sagrada (bloque D); rangos más fuertes de Sello de furia y Consagración.
- 60: Escudo Sagrado rango 4 y rangos más fuertes; nada nuevo para este rol.
**Errores de principiante:**
- Olvidar Furia recta. Sin ella haces mucha menos amenaza. Compruébala antes de cada pull; dura 30 minutos.
- Sello de furia puesto cuando no eres el tanque. Entonces cada Sentencia provoca.
- Sin escudo. Escudo Sagrado no funciona sin uno, y Sello de furia no da absorción.]] },
			{ band = 3, title = "Reprensión: daño cuerpo a cuerpo", body = [[
Desde el nivel 1 (Sello de rectitud); Sentencia llega en el 4, Golpe Sagrado en el 6. Las guías dicen que Reprensión es el árbol más rápido para subir de nivel en solitario, con un arma lenta de dos manos. La misión de clase del 20 te da una. Los botones del árbol: Sello de orden en el 20, Arrepentimiento en el 30.
**Orden sencillo:**
1. Antes del combate: Bendición de poderío (**Shift-Z**) hasta el 20, luego Bendición de reyes (**Shift-X**).
2. Aura: Aura de devoción (**Ctrl-1**); Aura de reprensión (**Ctrl-2**, desde el 16) contra varios enemigos.
3. Sello puesto (**3**): Sello de rectitud, hasta que conozcas Sello de orden (desde el 20). Entonces la tecla 3 lanza Sello de orden.
4. Sentencia (**2**) cada vez que esté lista. No gasta el sello.
5. Golpe Sagrado (**1**) cada vez que esté listo.
6. No-muerto o Demonio, desde el 20: Exorcismo (**5**).
7. Dos o más enemigos, desde el 20: Consagración (**Shift-1**). No contra un solo enemigo: cuesta demasiado maná.
8. Desde el 44: Martillo de cólera (**4**) cuando el enemigo tiene un 20% de salud o menos.
9. Enemigo fuerte: Martillo de Justicia (**E**), y luego Sentencia (**2**). Con Sello de orden, Sentencia hace el doble de daño contra un enemigo aturdido.
10. Un segundo Humanoide, desde el 30: Arrepentimiento (**V**), y no lo golpees.
11. Vuelve a ponerte el sello cuando se acabe (30 segundos). Poca salud: Luz Sagrada (**C**) entre combates.
**Cada 10 niveles:**
- 10: ya tienes Sello de rectitud (**3**), Sentencia (**2**), Golpe Sagrado (**1**), Bendición de poderío (**Shift-Z**) y Martillo de Justicia (**E**). Nuevo en el 10: Imposición de manos (**Q**). Primer talento: Oración (la mayoría de las guías) o Desvío (una guía), los dos pasivos. Los niveles de talento de aquí son los más tempranos; una ventaja puede adelantarlos hasta 5 niveles. Luego Sentencia mejorada, Convicción o Sentencia santificada (talentos, pasivos) desde el 15, Aura de reprensión (**Ctrl-2**) en el 16.
- 20: Sello de orden (**3**, un talento): a veces tus golpes hacen un golpe Sagrado extra. Desde entonces la tecla 3 lo lanza en lugar de Sello de rectitud. Consagración (**Shift-1**), Exorcismo (**5**), Bendición de reyes (**Shift-X**), Destello de Luz (**F2**). Búsqueda de justicia (un talento, pasivo: te mueves un 15% más rápido con 2/2). La misión de clase para un arma de dos manos. Luego Árbitro sagrado y Especialización en armas de dos manos (talentos, pasivos) en el 25.
- 30: Arrepentimiento (**V**, un talento): saca del combate a un Humanoide hasta 6 segundos; cualquier daño lo despierta; reutilización de 1 minuto. Venganza (un talento, pasivo; necesitas Sello de orden antes): después de un crítico haces más daño durante 30 segundos; se acumula 5 veces. Sello de orden rango 2. Luego Escudo divino (**Z**) en el 34, Campeón de la Luz (un talento, pasivo) en el 35.
- 40: Furia desatada (un talento, pasivo; necesitas Arrepentimiento antes): tus golpes guardan copias de tu sello, y un golpe con un sello distinto las usa. Malla de placas: puedes llevar placas. La misión del caballo de guerra. Luego Martillo de cólera (**4**) en el 44.
- 50: Sello de orden rango 4, Cólera Sagrada (bloque D), Martillo de cólera rango 2 en el 52; nada nuevo para este rol.
- 60: Sello de orden rango 5 y rangos más fuertes; la misión del destrero (Alianza); nada nuevo para este rol.
**Errores de principiante:**
- Volver a ponerte el sello después de cada Sentencia. Sentencia no lo gasta; un sello dura 30 segundos.
- Sello de orden con un arma rápida. Quiere un arma lenta de dos manos.
- Consagración contra un solo enemigo. Cuesta demasiado maná para eso.]] },
		},
	},
}
