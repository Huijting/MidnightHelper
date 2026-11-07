local _, ns = ...
-- Spanish "How you play" for WoW Forever (translated 7 Nov 2026 from Modules/ForeverHowToPlay.lua by mh-writer;
-- game names measured in docs/forever/CLIENT_NAMES_FOREVER_2026-11-07.md). Same sections, same order.
-- esES names. On an esMX client Locales/ForeverHowToPlay_esMX.lua wins (the names differ there).
if not ns.IS_FOREVER then
	return
end
local loc = GetLocale()
if loc ~= "esES" and loc ~= "esMX" then
	return
end
ns.FOREVER_HOWTOPLAY_L = ns.FOREVER_HOWTOPLAY_L or {}
ns.FOREVER_HOWTOPLAY_L.esES = {
	COMMON = {
		{ "Antes de empezar", [[
- Las teclas dan por hecho que el bloque de teclas de MH está colocado: /mh block, y luego los pasos 1 y 2.
- **Rangos de hechizo.** La mayoría de los hechizos tienen rangos: Rango 1, Rango 2, etc. Un rango más alto es el mismo hechizo, solo que más fuerte. Compras los rangos nuevos a tu instructor de clase a medida que subes de nivel. No tienes que cambiar nada: las teclas de MH lanzan un hechizo por su nombre, y el juego usa el rango más alto que conoces.
- **Una tecla que todavía no tiene nada** conserva su sitio. Se llena cuando aprendes el hechizo. Si un hechizo nuevo no aparece, abre el bloque de teclas (/mh block) y pulsa **Actualizar (hechizos nuevos)**.
- **Los hechizos de talento** también tienen tecla. Si nunca eliges ese talento, la tecla se queda vacía. No pasa nada.
- **Maná** es la barra azul debajo de tu salud. La mayoría de los hechizos cuestan maná. Cuando se vacía, no puedes lanzar hechizos.
- **Reutilización** = la espera antes de poder pulsar un hechizo otra vez.
- Teclas fijas, iguales para todas las clases: **T** = poción, **Shift-T** = piedra de salud, **G** = alhaja.]] },
	},
	DRUID = {
		{ "Qué hace", [[
El Druida puede cambiar de forma. Como lanzador normal lanza hechizos y cura. Más adelante puede convertirse en oso o en felino, para luchar cuerpo a cuerpo. El oso puede provocar (Bramido), así que es la forma para tanquear.
Una **forma** es una de esas figuras. En una forma, muchas de tus teclas hacen otra cosa. Las teclas de MH cambian solas: la misma tecla es un hechizo como lanzador y otro hechizo como oso.]] },
		{ "Niveles 1-10: tus botones", [[
- **1** = Cólera (nivel 1): tu hechizo de ataque principal.
- **2** = Fuegolunar (4): daño, y luego más daño durante unos segundos.
- **C** = Toque curativo (1): tu gran cura.
- **F4** = Rejuvenecimiento (4): una cura que te cura poco a poco.
- **Shift-X** = Marca de lo salvaje (1): un buff. Un **buff** es un efecto bueno sobre ti o sobre un amigo. Póntelo antes de un combate.
- **Shift-Z** = Espinas (6): otro buff.
- **V** = Enredaderas (8): deja a un enemigo quieto en su sitio.
- **X** = Gracia de la naturaleza (10).
- **Shift-E** = el hechizo de tu raza (Fusión de las Sombras para un Elfo de la noche, Pisotón de guerra para un Tauren).
- **Nivel 10, Forma de oso** (de una misión): **Ctrl-1** te convierte en oso. Como oso: **1** = Machaque, **F** = Bramido, **Shift-2** = Clamor desmoralizador.]] },
		{ "Orden sencillo (lanzador)", [[
Primero Fuegolunar (2), luego Cólera (1) hasta que el enemigo muera. ¿Poca salud? Rejuvenecimiento (F4) o Toque curativo (C).]] },
		{ "Lo que llega después", [[
- 12: Recrecimiento en F2 (cura rápida). Revivir en F3: trae de vuelta a un amigo muerto, solo fuera de combate.
- 16: Forma acuática en R mientras nadas. 18: Fuego feérico en 5 (funciona en todas las formas), Hibernar en Shift-Q.
- 20: Forma felina (de una misión) en Ctrl-2, con Zarpa, Destripar y Acechar. Fuego estelar en 3. En combate, F3 pasa a ser Renacer.
- 30: Forma de viaje en R (para desplazarte), Tranquilidad en Q. 40: Forma de oso nefasto (sustituye a Forma de oso en Ctrl-1), Enervar en F1.
- 44: Pielcorteza en Z, en todas las formas.]] },
		{ "Errores de principiante", [[
- Pulsar una cura mientras estás en una forma. Tus curas solo funcionan en tu forma normal, no en Forma de oso, Forma felina, Forma acuática ni Forma de viaje. Sal primero de la forma: pulsa otra vez la misma tecla de forma (Ctrl-1 para el oso, Ctrl-2 para el felino).
- En Forma de lechúcico lunar (un talento, como pronto en el nivel 40) tus hechizos de ataque funcionan, pero tus curas no.
- Lo que sí funciona en una forma: pociones, Pielcorteza, Gracia de la naturaleza, Fuego feérico y el hechizo de tu raza.]] },
	},
	PALADIN = {
		{ "Qué hace", [[
El Paladín es un luchador sagrado. Golpea cuerpo a cuerpo, se cura a sí mismo y a otros, y protege a sus amigos. No tiene formas ni actitudes, así que cada tecla hace siempre lo mismo.
Un **sello** es un poder sagrado que te pones a ti mismo. Dura 30 segundos, y solo puedes tener uno a la vez. Un **aura** es un poder que activas y dejas activo; ayuda a todo tu grupo. Una **bendición** es un buff que te pones a ti o a un amigo; dura 60 minutos. Un **buff** es un efecto bueno.]] },
		{ "Sellos y auras", [[
- **Sello de rectitud** (1): cada golpe hace daño sagrado extra. Un arma lenta hace más por golpe.
- **Sello del Cruzado** (6, en su propia tecla Alt): golpeas más rápido, pero cada golpe hace menos.
- **Sello de furia** (10): el sello para tanquear. Con un escudo, cada golpe también te da un pequeño escudo.
- **Sello de orden** (talento, como pronto en el nivel 20): a veces los golpes hacen un gran golpe sagrado extra. En cuanto lo tienes, la tecla 3 lanza este en lugar de Sello de rectitud.
- **Sello de justicia** (22), **Sello de luz** (30), **Sello de sabiduría** (38), todos en sus propias teclas Alt: a veces los golpes aturden, te curan o te dan maná.
- **Aura de devoción** (1): más armadura para tu grupo. **Aura de castigo** (16): daño sagrado a todo lo que golpea a tu grupo. **Aura de concentración** (22): a los lanzadores de tu grupo se les interrumpe menos cuando reciben golpes.]] },
		{ "Niveles 1-10: tus botones", [[
- **3** = Sello de rectitud (nivel 1): tu sello.
- **C** = Luz Sagrada (1): tu gran cura. Los Paladines No-muertos la consiguen con la misión de nivel 2 "Redescubriendo la Luz".
- **Ctrl-1** = Aura de devoción (1, del instructor): actívala y déjala activa.
- **2** = Sentencia (4): reutilización de 10 segundos. No gasta tu sello.
- **Shift-Z** = Bendición del poderío (4): póntela a ti mismo.
- **1** = Golpe Sagrado (6): tu golpe principal, cuerpo a cuerpo.
- **Z** = Protección divina (6): durante 6 segundos nada puede hacerte daño, pero tú tampoco puedes atacar. Reutilización de 5 minutos.
- **E** = Martillo de justicia (8): aturde al enemigo. Un **aturdimiento** significa que el enemigo no puede moverse ni lanzar hechizos durante unos segundos. El Paladín no tiene una interrupción de verdad, así que esta es tu tecla de "para ese hechizo".
- **Shift-C** = Purificar (8): quita un efecto malo a un amigo.
- **Q** = Imposición de manos (10): tu botón de emergencia. Cura a un amigo (o a ti) hasta la salud completa, pero gasta todo el maná que te queda. Reutilización de 20 minutos.
- **Shift-F** = Bendición de Protección (10): salva a un amigo que está en apuros.
- **F** = Sello de furia (10): un sello para tanquear. Su Sentencia provoca. **Provocar** = hacer que el enemigo te ataque a ti.]] },
		{ "Orden sencillo", [[
Sello (3) antes del combate. Luego Golpe Sagrado (1) y Sentencia (2) cada vez que estén listos. Vuelve a ponerte el sello cuando se acabe (dura 30 segundos). ¿Poca salud? Luz Sagrada (C).]] },
		{ "Lo que llega después", [[
- 12: Redención en F3 (trae de vuelta a un amigo muerto; no en combate). 14: Bendición de Sabiduría en Shift-V.
- 18: Bendición de Libertad en R (nada puede ralentizarte durante un rato). 20: Consagración en Shift-1 (golpea a varios enemigos a la vez), Exorcismo en 5, Destello de Luz en F2 (cura rápida), Bendición de los Reyes en Shift-X.
- 30: Intervención divina: en combate, F3 lanza este en lugar de Redención. 34: Escudo divino en Z: 10 segundos en los que nada puede hacerte daño, y aun así puedes luchar (con la mitad de daño).
- 42: Purgación sustituye a Purificar en Shift-C. 44: Martillo de cólera en 4 (solo cuando el enemigo tiene un 20% de salud o menos).
- 52-60: en un grupo, las teclas de bendición lanzan la Bendición superior para todo el grupo (por ejemplo Bendición superior de poderío); si juegas solo, lanzan la normal.]] },
		{ "Errores de principiante", [[
- Pulsar Exorcismo (5) contra un enemigo normal. Solo funciona contra No-muertos y Demonios. Ahuyentar a no-muerto (Shift-Q, 24) solo funciona contra No-muertos.
- Pulsar Martillo de cólera (4) al principio del combate. Solo funciona cuando el enemigo está casi muerto (un 20% de salud o menos).
- Escudo divino y Protección divina comparten una reutilización, así que están en una sola tecla (Z). Estos hechizos de protección, y Bendición de Protección, dan **Paciencia**: durante 1 minuto no puedes recibir ninguno de ellos otra vez. Imposición de manos no.]] },
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
- Conjurar agua (4) y Conjurar comida (6) no están en el bloque. Van en tus propias teclas Alt (bloque D).]] },
		{ "Orden sencillo", [[
Descarga de Escarcha (2) o Bola de Fuego (1) mientras el enemigo se acerca. Explosión de Fuego (5) cuando esté lista. ¿El enemigo está cerca de ti? Nova de Escarcha (V), apártate y sigue lanzando.]] },
		{ "Lo que llega después", [[
- 12: Caída lenta en Shift-R. 14: Deflagración Arcana en Shift-2 (golpea a varios enemigos). 16: Fogonazo en Shift-4.
- 18: Deshacer maldición inferior en Shift-V. 20: Traslación en R (tu hechizo de movimiento), Ventisca en Shift-1, Evocación en F1 (recupera maná), Escudo de maná en Z, Custodia de Fuego en F4. También los teletransportes (y más tarde los portales): hechizos de viaje, no están en el bloque. Ponlos en tu propia barra, o úsalos desde tu libro de hechizos (Hechizos).
- 22: Chamuscar en Ctrl-1, Custodia de Escarcha en F2. 24: Contrahechizo en E: tu **interrupción** (detiene el hechizo de un enemigo).
- 26: Cono de frío en Shift-F. 30: Armadura de hielo: a partir de entonces Shift-Z lanza esta en lugar de Armadura de Escarcha (también te protege contra la escarcha).
- Talentos a partir del nivel 20: Piroexplosión en 4, Lanza de hielo en F, Explosión Arcana en Ctrl-2, Bloqueo de hielo en C (como pronto en el 25).]] },
		{ "Errores de principiante", [[
- Esperar las dos custodias a la vez. Custodia de Fuego (F4) y Custodia de Escarcha (F2) comparten una reutilización de 30 segundos, así que solo una a la vez.
- Llevar Armadura de mago y Armadura de hielo juntas. Solo puedes llevar una armadura a la vez. Armadura de mago (34) está en el bloque D.]] },
	},
	HUNTER = {
		{ "Qué hace", [[
El Cazador dispara desde lejos con un arma a distancia, y desde el nivel 10 tiene una **mascota**: un animal que domesticas y que lucha a tu lado. De cerca tiene unos pocos golpes cuerpo a cuerpo.
**Tiro automático** = tu arma sigue disparando sola hasta que paras. **Cuerpo a cuerpo** = luchar de cerca. El Cazador no tiene formas ni actitudes, así que cada tecla hace siempre lo mismo.]] },
		{ "Niveles 1-10: tus botones", [[
- **1** = Tiro automático (nivel 1): empieza a disparar. La tecla de MH está hecha para que una segunda pulsación no lo detenga.
- **5** = Golpe de raptor (1): tu golpe cuando el enemigo está a tu lado.
- **2** = Aguijón de serpiente (4): daño durante unos segundos.
- Aspecto del mono (4) va en tus propias teclas Alt (bloque D). Un **aspecto** es un buff sobre ti mismo, parecido a una actitud. Solo puedes tener un aspecto a la vez.
- **3** = Tiro Arcano (6): disparo instantáneo. Reutilización de 6 segundos.
- **Shift-Z** = Marca del cazador (6): pónsela al enemigo una vez.
- **Shift-Q** = Disparo de concusión (8): ralentiza al enemigo.
- **Shift-R** = Aspecto del halcón (10): tu aspecto principal.
- **Nivel 10, misiones de mascota:** aprendes Domesticar bestia, Llamar a mascota y Revivir mascota. **F4** = Llamar a mascota (trae a tu mascota), **F3** = Revivir mascota (trae de vuelta a una mascota muerta). Domesticar bestia no tiene tecla; la usas fuera de combate.
- A partir de entonces tu mascota tiene tres teclas: **Ctrl-1** = atacar a tu objetivo, **Ctrl-2** = seguirte, **Ctrl-3** = quedarse donde está.]] },
		{ "Orden sencillo", [[
Activa Aspecto del halcón (Shift-R). Primero entra la mascota (Ctrl-1). Marca del cazador (Shift-Z), Aguijón de serpiente (2), Tiro automático (1), y luego Tiro Arcano (3) cuando esté listo. ¿El enemigo está a tu lado? Golpe de raptor (5).]] },
		{ "Lo que llega después", [[
- 10: Alimentar mascota y Retirar mascota no están en el bloque (los usas fuera de combate); ponlos en tu propia barra. Lo mismo con Bestia temible (14).
- 12: Disparo de distracción en F (hace que el enemigo te ataque), Sanar mascota en F2 (cura a tu mascota), Cortar alas en Shift-F.
- 16: Trampa de inmolación en Shift-2, Mordedura de mangosta en Shift-C (solo después de esquivar). 18: Multidisparo en Shift-1.
- 20: Tiro de puntería en 4 (tu gran disparo), Aspecto del guepardo en R (corres rápido), Separación en Z, Trampa congelante en V.
- 26: Fuego rápido en Q. 30: Fingir muerte en X, Aspecto de la bestia (bloque D). 34: Trampa explosiva pasa a ocupar Shift-2.
- Las cuatro trampas comparten una reutilización de 30 segundos.]] },
		{ "Errores de principiante", [[
- Disparar a un enemigo que está justo a tu lado. Tu arma de fuego o tu arco no funciona a menos de 8 metros (la "zona muerta"): usa Golpe de raptor (5), o da un paso atrás.
- Esperar que una tecla dispare de lejos y golpee de cerca. Una macro no puede ver la distancia, así que el cuerpo a cuerpo tiene sus propias teclas (5, Shift-F, Shift-C).
- Pulsar Sanar mascota (F2) para curarte a ti. Solo cura a tu mascota. El Cazador no tiene cura propia.]] },
	},
	WARRIOR = {
		{ "Qué hace", [[
El Guerrero lucha cuerpo a cuerpo con un arma. Tiene tres actitudes, y desde el nivel 10 puede tanquear. No se cura a sí mismo, salvo con Ataque de la victoria (nivel 20).
El Guerrero tiene **Ira** en lugar de maná. Ganas Ira cuando golpeas y cuando te golpean. Fuera de combate, tu Ira baja poco a poco hasta 0.]] },
		{ "Actitudes", [[
Una **actitud** es una forma de luchar que activas con una tecla. Siempre estás en una actitud. Algunos hechizos solo funcionan en una o dos actitudes. Las teclas de MH cambian solas: en otra actitud, la misma tecla lanza otro hechizo. Si una tecla no tiene nada para tu actitud, no hace nada (sin error).
- **Actitud de batalla** (1): tu actitud para luchar normalmente.
- **Actitud defensiva** (10, de una misión): la actitud para tanquear. Solo aquí tienes Irritar.
- **Actitud rabiosa** (30, de la misión "La Reyerta"). Aquí E pasa a ser Zurrar y R pasa a ser Interceptar.
- **Maestría táctica** (14, pasiva, no haces nada): conservas hasta 10 de Ira al cambiar de actitud.
- Ninguna tecla cambia tu actitud por sí sola. Tú eliges la actitud; las teclas la siguen.]] },
		{ "Niveles 1-10: tus botones", [[
- **1** = Golpe heroico (nivel 1): tu golpe principal, en todas las actitudes.
- **Ctrl-1** = Actitud de batalla (1): actívala y déjala activa.
- **Shift-X** = Grito de guerra (1): un buff. Un **buff** es un efecto bueno sobre ti o sobre un amigo. Póntelo antes de un combate.
- **R** = Embestir (4): corres hacia un enemigo para empezar un combate. Solo funciona en Actitud de batalla, y no cuando ya estás luchando.
- **Shift-Z** = Desgarrar (4): un **sangrado**: daño durante unos segundos. Actitud de batalla y Actitud defensiva.
- **Shift-1** = Trueno (6): golpea a varios enemigos a la vez. Actitud de batalla y Actitud defensiva. Reutilización de 6 segundos.
- **V** = Seccionar (8): ralentiza mucho al enemigo durante 15 segundos. Actitud de batalla y Actitud rabiosa.
- **F1** = Sanguinario (10): te da Ira enseguida y un poco más durante unos segundos. Cuesta un poco de salud. Reutilización de 1 minuto.
- **Nivel 10, Actitud defensiva** (de una misión): **Ctrl-2** la activa. La misma misión da **5** = Hender armadura (todas las actitudes) y, en Actitud defensiva, **F** = Irritar. **Provocar** = hacer que el enemigo te ataque a ti. Reutilización de 8 segundos.
- Disparar arco, Disparar arma de fuego, Disparar ballesta y Lanzar van en tus propias teclas Alt (bloque D). Recibes el que va con tu arma a distancia. Úsalo para hacer **pull**: golpear a un enemigo desde lejos, para que venga hacia ti.]] },
		{ "Orden sencillo", [[
Activa Actitud de batalla (Ctrl-1), Grito de guerra (Shift-X). Entra con Embestir (R). Desgarrar (Shift-Z), y luego Golpe heroico (1) una y otra vez. ¿Varios enemigos? Trueno (Shift-1).]] },
		{ "Lo que llega después", [[
- 12: Abrumar en 2 (Actitud de batalla; después de que el enemigo esquive), Azote de escudo en E: tu **interrupción** (detiene el hechizo de un enemigo).
- 14: Revancha en 2 (Actitud defensiva), Grito desmoralizador en Shift-2. 16: Falsa arremetida en F (Actitud de batalla), Bloquear con escudo en Z (Actitud defensiva). 18: Desactivar en V (Actitud defensiva).
- 20: Mellar en Shift-4, Embate en Shift-C, Ataque de la victoria en F2 (solo en los 20 segundos después de matar a un enemigo que da PE; te cura un poco; reutilización de 30 segundos), Represalias en C (Actitud de batalla). 22: Grito intimidador en Shift-Q. 24: Ejecutar en 4 (Actitud de batalla y Actitud rabiosa; solo cuando el enemigo tiene un 20% de salud o menos).
- 26: Grito desafiante en Shift-F. 28: Muro de escudo en C (Actitud defensiva).
- 30: Actitud rabiosa en Ctrl-3. En ella: Interceptar en R, Ira rabiosa en Shift-V. 36: Huracán en 2 (rabiosa). 38: Zurrar en E (rabiosa). 50: Temeridad en Q (rabiosa).
- Talentos: Última posición en X y Aullido penetrante en Shift-R (una ralentización en área), como pronto en el 20. Lanzazo en F3 (Actitud de batalla) y Golpes temerarios en Shift-F1, 25. Golpes de barrido en Q (Actitud de batalla), Deseo de la Muerte en Shift-3, Golpe de concusión en Shift-V (un aturdimiento; en Actitud rabiosa esta tecla es Ira rabiosa), 30. Golpe mortal, Sed de sangre o Embate con escudo en 3, 40.]] },
		{ "Errores de principiante", [[
- Pulsar una tecla en la actitud equivocada. Irritar solo funciona en Actitud defensiva, Abrumar solo en Actitud de batalla. En la actitud equivocada la tecla no hace nada. Mira primero tu actitud.
- Embestir en Actitud defensiva. Allí solo funciona con el talento **Vanguardia**. Sin él, recibes un error en rojo.
- Embestir en combate. Embestir solo empieza un combate; cuando ya estás luchando, no funciona.
- Trueno (Shift-1) no funciona en Actitud rabiosa.
- Azote de escudo, Bloquear con escudo y Embate con escudo sin escudo. Los tres necesitan un escudo en la mano izquierda.
- Esperar que Embate sea rápido. En Forever tiene 1,5 segundos de lanzamiento y 15 segundos de reutilización.
- Represalias y Muro de escudo están los dos en C, cada uno con su propia reutilización de 15 minutos. Guárdalos para los apuros de verdad.]] },
	},
	ROGUE = {
		{ "Qué hace", [[
El Pícaro lucha cuerpo a cuerpo con golpes rápidos. Puede acercarse a los enemigos sin que lo vean, y tiene muchas formas de detener a un enemigo un momento.
El Pícaro tiene **Energía** en lugar de maná. La Energía se rellena sola, y rápido: una barra vacía vuelve a estar llena en unos 10 segundos.]] },
		{ "Sigilo y remates", [[
**Sigilo** (nivel 1, Shift-R) hace que sea difícil verte. Te mueves a la mitad de velocidad. Algunos ataques solo funcionan desde Sigilo: son tus **aperturas**, el primer golpe de un combate. En Sigilo, las teclas de MH cambian solas:
- **1** pasa a ser Garrote (14), **2** pasa a ser Emboscada (18), **V** pasa a ser Golpe bajo (26), **Shift-Q** pasa a ser Zapar (10), **F** pasa a ser Robar (4).
- Antes de conocer el hechizo Sigilo, la tecla simplemente mantiene su hechizo normal.
Golpes como Golpe siniestro te dan **puntos de combo** (hasta 5). Un **remate** es un golpe que gasta todos tus puntos de combo: Eviscerar (4), Hacer picadillo (Shift-4) y Ruptura (5). Más puntos lo hacen más fuerte.]] },
		{ "Niveles 1-10: tus botones", [[
- **1** = Golpe siniestro (nivel 1): tu golpe principal.
- **4** = Eviscerar (1): tu remate principal.
- **Shift-R** = Sigilo (1): avanzar a escondidas. Púlsalo otra vez para salir de Sigilo. Después de salir de Sigilo, no puedes volver a entrar durante 10 segundos.
- **Shift-2** = Lanzar (1): un lanzamiento a distancia. Necesitas un arma arrojadiza (como cuchillos arrojadizos) en tu ranura de arma a distancia. Con un arma de fuego, un arco o una ballesta equipados, la tecla dispara con eso.
- **2** = Puñalada (4): un golpe fuerte. Necesitas una daga, y tienes que estar detrás del enemigo.
- **F** = Robar (4): solo en Sigilo. Le roba al enemigo.
- **Shift-Q** = Incapacitación (6): detiene a un enemigo un momento. Cualquier daño lo rompe. Ese tipo de hechizo se llama **CC** (control de masas).
- **Z** = Evasión (8): esquivas muchos más ataques durante 15 segundos. Reutilización de 5 minutos.
- **Shift-4** = Hacer picadillo (10): tu segundo remate.
- **R** = Correr (10): corres rápido.
- **Shift-Q** = Zapar (10): solo en Sigilo. Saca a un enemigo humanoide del combate durante un rato, antes de que empiece el combate. No funciona contra bestias ni contra enemigos que ya están luchando. El daño lo rompe. Zapar no rompe tu Sigilo.
- **F4** = la cura con el tiempo de tu raza, si tiene una: Canibalizar (No-muerto; solo cerca de un cadáver Humanoide o No-muerto), Regeneración rápida (Trol; se detiene cuando te mueves, actúas o recibes daño), Leer línea Ley (Cielonato de la Orden Eminente).
- **Shift-E** = el hechizo de tu raza (por ejemplo Fusión de las Sombras para un Elfo de la noche, Furia sangrienta para un Orco).]] },
		{ "Orden sencillo", [[
Sigilo (Shift-R) y acércate al enemigo. Golpe siniestro (1) unas cuantas veces, y luego Eviscerar (4). Con una daga y detrás del enemigo: Puñalada (2). A partir del nivel 10: mantén activo Hacer picadillo (Shift-4).]] },
		{ "Lo que llega después", [[
- 12: Patada en E: tu **interrupción** (detiene el hechizo de un enemigo). 14: Exponer armadura en Shift-Z, Garrote en 1 en Sigilo.
- 16: Amago en F (fuera de Sigilo). Baja tu **amenaza**: las ganas que tiene el enemigo de atacarte. Ganzúa (bloque D).
- 18: Emboscada en 2 en Sigilo (daga, desde detrás). 20: Ruptura en 5. Venenos (de una misión; mira más abajo).
- 22: Distraer en Shift-F, Esfumar en X (tu huida; cada uso gasta unas Partículas cegadoras, un objeto de tus bolsas). 24: Apuñalar en Shift-3 (un golpe con tu arma de la mano izquierda, así que necesitas un arma en cada mano; reutilización de 10 segundos; te devuelve 15 de Energía).
- 26: Golpe bajo en V en Sigilo: un **aturdimiento** (el enemigo no puede moverse ni actuar durante unos segundos). 30: Golpe a los riñones en V fuera de Sigilo. Desactivar trampa (bloque D). 34: Ceguera en Shift-V (gasta un Polvo cegador).
- Talentos: Estocada en Shift-F1 y Premeditación en Shift-C, como pronto en el 20. Sangre fría en F1 y Golpe fantasmal en Shift-X, 25. Ráfaga con espada en Shift-1 (golpea a más enemigos), Preparación en F3 (reinicia la reutilización de tus otros hechizos de Pícaro, como Evasión, Correr y Esfumar), Hemorragia en 3, 30. Mutilar en 3, Subidón de adrenalina o Marca de muerte (a partir del Rango 2: Marca de la muerte) en Q, 40.]] },
		{ "Errores de principiante", [[
- Pulsar una apertura fuera de Sigilo. Garrote, Emboscada, Golpe bajo, Zapar y Robar necesitan Sigilo. Fuera de Sigilo, la misma tecla lanza su hechizo normal.
- Pulsar Sigilo otra vez sin querer. Eso termina el Sigilo, y no puedes volver a entrar durante 10 segundos.
- Elfo de la noche: Fusión de las Sombras es el hechizo de tu raza, no el Sigilo de tu clase. Para tus aperturas, usa Sigilo (Shift-R).
- Puñalada y Emboscada de frente, o sin daga. Las dos necesitan una daga, y tienes que estar detrás del enemigo.
- Golpear a un enemigo que sacaste del combate con Incapacitación o Zapar. Cualquier daño lo despierta.
- Zapar contra una bestia o contra un enemigo que ya está luchando. Zapar solo funciona contra humanoides, antes del combate.
- Esfumar o Ceguera sin polvo en tus bolsas. Esfumar necesita unas Partículas cegadoras, Ceguera necesita un Polvo cegador.
- Buscar los venenos en el bloque. Los **Venenos** son objetos que fabricas (aprendes Venenos con una misión hacia el nivel 20). Los pones en tu arma. Arrástralos tú mismo a tus propias teclas Alt (bloque D).
- Golpe fantasmal (talento): después de él, tu siguiente Emboscada o Garrote funciona sin Sigilo, si lo usas en 7 segundos. Las teclas de MH no pueden ver eso, así que fuera de Sigilo las teclas 1 y 2 siguen lanzando Golpe siniestro y Puñalada.]] },
	},
	PRIEST = {
		{ "Qué hace", [[
El Sacerdote cura, y golpea desde lejos con magia sagrada y de sombras. Protege a sus amigos con un escudo. Más adelante puede elegir **Forma de las Sombras** (un talento, como pronto en el nivel 40): más daño de sombras, pero nada de curación.
El Sacerdote no tiene actitudes. Forma de las Sombras no cambia las teclas: cada tecla hace siempre lo mismo.]] },
		{ "Los hechizos propios de tu raza", [[
Cada raza de Sacerdote tiene dos hechizos de Sacerdote propios: uno en el nivel 10 y otro en el nivel 20. MH los pone en **X** y **Shift-R**, así que todas las razas usan las mismas dos teclas.
- Enano: Rezo desesperado (10, X; reutilización de 10 minutos), Castigar (20, Shift-R).
- Humano: Gracia divina (10, Shift-R; una cura instantánea sobre un amigo con menos de la mitad de salud, no sobre ti; reutilización de 10 minutos), Rebote (20, X).
- Elfo de la noche: Fragmentos estelares (10, Shift-R; reutilización de 30 segundos), Gracia de Elune (20, X).
- No-muerto: Toque de debilidad (10, X), Sacrificio oscuro (20, Shift-R; cambias tu propia salud por maná).
- Trol: Maleficio de debilidad (10, Shift-R), Guardia de las Sombras (20, X).
- Gnomo: Destello desconcertante (10, Shift-R), Plan de contingencia (20, X; una protección sobre un amigo que lo cura y lo escuda cuando su salud baja mucho).]] },
		{ "Niveles 1-10: tus botones", [[
- **1** = Acometida (nivel 1): tu hechizo de ataque principal.
- **C** = Curación inferior (1): tu cura principal. Más tarde Curar (16) y Curación superior (40) ocupan esta tecla.
- **5** = Disparar (1): tu **varita** (un pequeño palo mágico que dispara solo). Necesitas una varita en las manos.
- **Shift-X** = Palabra de poder: entereza (1): un buff. Un **buff** es un efecto bueno sobre ti o sobre un amigo. Póntelo antes de un combate.
- **2** = Palabra de las Sombras: Dolor (4): daño de sombras.
- **Z** = Palabra de poder: escudo (6): un escudo sobre ti o sobre un amigo. Reutilización de 4 segundos, pero la misma persona solo puede recibir un escudo nuevo después de 15 segundos.
- **F** = Desvanecer (8): los enemigos tienen menos ganas de atacarte durante un rato. Reutilización de 30 segundos.
- **F4** = Renovar (8): una cura que cura poco a poco.
- **3** = Explosión mental (10): daño de sombras. Reutilización de 8 segundos.
- **F3** = Resurrección (10): trae de vuelta a un amigo muerto. Solo fuera de combate.
- El hechizo de tu raza de nivel 10 está en **X** o en **Shift-R** (mira la lista de arriba).
- **Shift-E** = la habilidad de tu raza (por ejemplo Petraforma para un Enano, Fusión de las Sombras para un Elfo de la noche).]] },
		{ "Orden sencillo", [[
Escudo (Z) sobre ti. Palabra de las Sombras: Dolor (2), Explosión mental (3), y luego Acometida (1). ¿Poco maná? Usa tu varita (5). ¿Poca salud? Renovar (F4) o Curación inferior (C).]] },
		{ "Lo que llega después", [[
- 12: Fuego interno en Shift-Z. 14: Curar enfermedad en Shift-C, Alarido psíquico en V (unos cuantos enemigos a tu alrededor huyen con miedo hasta 8 segundos; el daño puede terminarlo; reutilización de 30 segundos).
- 18: Disipar magia en Shift-V. 20: Destello curativo en F2 (cura rápida), Fuego Sagrado en 4, Encadenar no-muerto en Shift-Q, Peste devoradora en Shift-3, el hechizo de tu raza de nivel 20, Custodia de miedo (bloque D).
- 30: Rezo de curación en Shift-2 (cura a tu grupo), Control mental en Shift-F. 32: Palabra de las Sombras: muerte en Shift-4, Suprimir enfermedad pasa a ocupar Shift-C. 34: Levitar en R (gasta una Pluma ligera). 48: Rezo de entereza pasa a ocupar Shift-X (gasta una Vela sagrada).
- Talentos: Despelleje mental (ocupa la tecla 1), Nova Sagrada en Shift-1 y Enfoque interno en F1, como pronto en el 20. Unirse a vampírica en Ctrl-3, 25. Penitencia en Shift-F1 y Silencio en E (tu **interrupción**: detiene el hechizo de un enemigo), 30. Infusión de poder en Q, Forma de las Sombras en Ctrl-1, Rezo de alivio en Ctrl-2, 40.]] },
		{ "Errores de principiante", [[
- Curar en Forma de las Sombras. Ningún hechizo de curación funciona en Forma de las Sombras. Custodia de miedo y los hechizos de raza del Enano y del Gnomo (Castigar, Destello desconcertante) tampoco funcionan en ella. Sal primero: pulsa otra vez Ctrl-1.
- Echar de menos Acometida después de elegir Despelleje mental. En cuanto conoces Despelleje mental, la tecla 1 lanza Despelleje mental, no Acometida.
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
- Cada elemento tiene un objeto Tótem que consigues con una misión de clase: Tótem de tierra (nivel 4, o 3 para los cielonatos), Tótem de Fuego (10), Tótem de agua (20), Tótem de aire (30). Necesitas ese objeto en tus bolsas para todos los tótems de ese elemento.
- Antes del nivel 20, cada uno de tus tótems tiene su propia tecla: Tótem piel de piedra (Z), Tótem Nexo Terrestre (V), Tótem Garra de piedra (F), Tótem Fuerza de la tierra (Shift-X), Tótem abrasador (5), Tótem de tremor (Shift-F).
- A partir del nivel 20 el juego te da una **barra de tótems**. En ella eliges un tótem por elemento. Luego una sola tecla los coloca todos: **Ctrl-1** = Llamada de los elementos (20), **Ctrl-2** = Llamada de los ancestros (30), **Ctrl-3** = Llamada de los espíritus (40). Cada una coloca hasta 4 tótems de su propia página de la barra de tótems. Tiene 3 segundos de lanzamiento y cuesta el maná de todos los tótems que coloca.
- **Shift-R** = Llamada totémica (22): mueve tus tótems hasta ti. Regreso totémico (20, bloque D) los recoge y te devuelve una cuarta parte de su maná.
Un **buff de arma** pone poder en tu arma durante 60 minutos. Tienes uno a la vez. Arma comerrocas (1), Arma lengua de Fuego (10), Arma Estigma de Escarcha (20) y Arma tótem Viento Furioso (30) van en tus propias teclas Alt (bloque D). Elige el que va con tu forma de jugar.]] },
		{ "Niveles 1-10: tus botones", [[
- **1** = Descarga de relámpagos (nivel 1): tu hechizo de ataque principal.
- **C** = Onda de curación (1): tu gran cura.
- Arma comerrocas (1) va en el bloque D (mira arriba).
- **E** = Choque de tierra (4): tu **interrupción** (detiene el hechizo de un enemigo), y daño.
- **Z** = Tótem piel de piedra (4, de una misión): recibes menos daño de los golpes cuerpo a cuerpo. **Cuerpo a cuerpo** = luchar de cerca.
- **V** = Tótem Nexo Terrestre (6): ralentiza a los enemigos que están cerca. Reutilización de 15 segundos.
- **F** = Tótem Garra de piedra (8): hace que los enemigos de alrededor ataquen al tótem. Reutilización de 30 segundos.
- **Shift-Z** = Escudo de relámpagos (8): un escudo sobre ti mismo. Solo un escudo a la vez.
- **2** = Choque de llamas (10): daño de fuego, y luego más daño durante unos segundos.
- **5** = Tótem abrasador (10, de una misión): tu tótem de daño.
- **Shift-X** = Tótem Fuerza de la tierra (10): un tótem que da un buff a tu grupo. Un **buff** es un efecto bueno.
- Arma lengua de Fuego (10) va en el bloque D.
- **Shift-E** = el hechizo de tu raza (por ejemplo Pisotón de guerra para un Tauren, Petraforma para un Enano).]] },
		{ "Orden sencillo", [[
Buff de arma puesto (bloque D), Escudo de relámpagos puesto (Shift-Z). Tótem abrasador (5) al suelo. Choque de llamas (2), y luego Descarga de relámpagos (1). Guarda Choque de tierra (E) para cuando el enemigo lance un hechizo. ¿Poca salud? Onda de curación (C).]] },
		{ "Lo que llega después", [[
- 12: Nova de Fuego en Shift-4, Purgar en Shift-Q (quita magia a un enemigo), Espíritu ancestral en F3 (trae de vuelta a un amigo muerto). 16: Curar veneno en Shift-C. 18: Tótem de tremor en Shift-F (quita miedo, encantamiento y sueño a tu grupo).
- 20: Lobo fantasmal en R (3 segundos de lanzamiento, solo al aire libre), Choque de Escarcha en 4 (ralentiza), Onda inferior de curación en F2 (cura rápida), Tótem Corriente de sanación en F4 (de una misión; cura a tu grupo poco a poco; necesita el Tótem de agua; en el Rango 3, nivel 40, se llama Tótem de corriente curativa), Llamada de los elementos en Ctrl-1.
- 22: Curar enfermedad en Shift-V, Llamada totémica en Shift-R. 30: Tótem derribador en X (atrapa un hechizo dañino dirigido a ti o a un miembro del grupo cercano; no los hechizos de área; necesita el Tótem de aire de la misión de nivel 30), Llamada de los ancestros en Ctrl-2. 32: Cadena de relámpagos en Shift-1 (golpea a varios enemigos).
- 40: Curación en cadena en Shift-2 (cura a varios amigos), Llamada de los espíritus en Ctrl-3.
- Talentos: Escudo de agua (ocupa Shift-Z), como pronto en el 20. Golpe de tormenta en 3 y Tótem de marea de maná en F1 (a partir del nivel 58: Tótem Marea de maná), 25. Rapidez de la Naturaleza en Shift-3, 30. Mareas vivas en Shift-F1, y Maestría de Relámpago o Ira del clarividente en Q, 40.]] },
		{ "Errores de principiante", [[
- Usar un choque justo antes de necesitar interrumpir. Choque de tierra (E), Choque de llamas (2) y Choque de Escarcha (4) comparten una reutilización de 6 segundos. Después de Choque de llamas, no hay interrupción durante hasta 6 segundos.
- Pulsar Nova de Fuego (Shift-4) sin un tótem de Fuego colocado. Necesita uno de tus tótems de Fuego (como Tótem abrasador o Tótem de magma). Golpea a los enemigos que están cerca de ese tótem, no a los que están cerca de ti.
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
- **Invocar a diablillo** (1): de tu primera misión de clase en tu zona de inicio. El nombre depende de tu raza: Humano "El libro robado", Gnomo "Novato", Orco y Trol "Familiares viles", No-muerto "Descubrir el misterio". El Diablillo no cuesta Fragmento de alma.
- **Invocar a abisario** (10, misión). **Invocar a súcubo** o **Invocar íncubo** (20, misión). **Invocar a manáfago** (30, misión). Cada uno de estos cuesta 1 **Fragmento de alma** (mira Drenar alma más abajo).
- **Inferno** (50) está en **F3**. Cada lanzamiento necesita una Piedra infernal. Reutilización de 1 hora.
- Las invocaciones no están en el bloque. Van en tus propias teclas Alt (bloque D).
- Desde tu primer demonio, tu mascota tiene tres teclas: **Ctrl-1** = atacar a tu objetivo, **Ctrl-2** = seguirte, **Ctrl-3** = quedarse donde está.
- El Abisario puede provocar (Tormento). El Manáfago puede detener el hechizo de un enemigo (Bloqueo de hechizo, desde el 36). Estos son hechizos propios de tu demonio, en la Barra de mascotas de Blizzard.]] },
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
- Crear piedra de salud (10, cuesta un Fragmento de alma) va en el bloque D. Tu piedra de salud estará entonces en **Shift-T**, como para todas las clases.
- **Shift-E** = el hechizo de tu raza (por ejemplo Furia sangrienta para un Orco, Voluntad de los Renegados para un No-muerto).]] },
		{ "Orden sencillo", [[
Saca al demonio (bloque D; todos menos el Diablillo necesitan un Fragmento de alma), y luego mándalo al ataque (Ctrl-1). Corrupción (2), Terror de agonía (5), Inmolar (3), y luego Descarga de las Sombras (1). ¿Poco maná? Transfusión de vida (F). ¿Poca salud? Drenar vida (C, desde el 14).]] },
		{ "Lo que llega después", [[
- 12: Cauce de salud en F2 (cura a tu demonio). 14: Drenar vida en C (tu propia gran cura).
- 16: Fuerza inmortal en Shift-R. 18: Dolor abrasador (bloque D), y Crear piedra de alma (cuesta un Fragmento de alma; no está en el bloque, ponlo tú mismo en tu propia barra).
- Maldición de la lengua y Ritual de invocación (traer a un miembro del grupo hasta ti) se usan poco: tampoco están en el bloque. Ponlos en tu propia barra si los quieres.
- 20: Lluvia de Fuego en Shift-1 (golpea a varios enemigos), Armadura demoníaca en Shift-Z, Maldición de los Elementos en Shift-V.
- 28: Desterrar en Shift-Q. 30: Piroinferno en Shift-2. 32: Custodia de las Sombras en Z (absorbe daño de sombras; reutilización de 30 segundos).
- 40: Aullido de terror en Shift-F (da miedo a varios enemigos). 42: Espiral mortal en X (un horror, como el miedo, y una cura; reutilización de 2 minutos).
- 48: Fuego de alma en Q (tu golpe más grande; cuesta un Fragmento de alma; 6 segundos de lanzamiento; reutilización de 1 minuto). 50: Inferno en F3. 60: Terror de fatalidad en F1.
- Talentos: Quemadura de las Sombras en Shift-4 (cuesta un Fragmento de alma), Amplificar maldición en Shift-3, Sacrificio demoníaco en Shift-C, como pronto en el 20. Maldición de agotamiento en R (ralentiza al enemigo, para que puedas mantenerte lejos de él), Dominio de lo maldito en Shift-F1 (invoca un demonio rápido), 25. Succionar vida en F4 (un DoT que te cura), Vínculo de alma en Shift-X, 30. Conflagrar (25), Terror de caos (30), Arruinar (40) e Incinerar (40), todos como pronto, van en el bloque D.]] },
		{ "Errores de principiante", [[
- Invocar un demonio sin Fragmento de alma. Todos los demonios menos el Diablillo cuestan uno. Usa Drenar alma (4) para rematar a enemigos que dan PE.
- Buscar una interrupción en E. El Brujo no tiene ninguna propia, así que E se queda vacía. Solo el Manáfago tiene una.
- Pulsar Cauce de salud (F2) para curarte a ti. Cura a tu demonio. Tu propia cura es Drenar vida (C).
- Desterrar (Shift-Q) contra un enemigo normal. Solo funciona contra demonios y elementales.
- Terror de fatalidad (F1) contra un jugador. No se puede lanzar sobre jugadores.
- Echar de menos tu varita. Disparar no está en el bloque. Arrástralo tú mismo desde tu libro de hechizos (Hechizos) a tu propia barra.]] },
	},
}
