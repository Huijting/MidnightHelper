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
		-- not measured: The Great Outdoors
		{ "Acampar", [[
- **Acampar** no es una profesión. Cada profesión puede fabricar un **objeto de campamento**. Cocina fabrica la hoguera.
- **Empieza** con la misión **The Great Outdoors**, en cada zona de inicio.
- **1. La hoguera.** Con Cocina, fabrica un **Equipo de hoguera básica**: 1 Madera simple, con **Sílex y Yesca** como herramienta (te lo quedas). Usa el equipo al aire libre, no en combate. La hoguera tiene sitio para 3 objetos (Hoguera de oficial 5, Hoguera de experto 10). Reutilización: 5 minutos.
- **2. Un objeto.** Fabrícalo con tu profesión. Necesitas habilidad 20 para colocarlo. Colócalo cerca de la hoguera. El objeto se gasta.
- **3. Siéntate** cerca de la hoguera. Recibes **Hoguera agradable** durante 60 segundos. Puedes fabricar, pero no camines. Después recibes **Beneficios de campamento** durante 1 hora, con una línea por objeto.
- **Reglas:** todos los objetos comparten una reutilización de 1 hora. Cada tipo de objeto solo una vez por campamento.
- **Choques:** no puedes tener a la vez un buff de campamento y el buff de clase que se nombra abajo. La mayoría de los buffs de campamento crecen con tu nivel.
- Desuello: **Silla de campamento** = probabilidad de golpe crítico. Choca con Aura de lechúcico lunar.
- Herrería: **Rueda de afilar** = Fuerza. Choca con Tótem Fuerza de la tierra.
- Herboristería: **Vela de incienso** = Intelecto. Choca con Intelecto Arcano.
- Alquimia: **Pozo de maná** = maná cada 5 segundos. Choca con Bendición de Sabiduría.
- Minería: **Magnetita** = poder de ataque cuerpo a cuerpo. Choca con Bendición del poderío.
- Pesca: **Cuenco con pescado** = todas las estadísticas. Choca con Bendición de los Reyes.
- Primeros auxilios: **Equipo de primeros auxilios** = Aguante. Choca con Palabra de poder: entereza.
- Sastrería: **Estandarte de facción** = Espíritu, solo para tu propia facción. Choca con Espíritu divino.
- Encantamiento: **Laúd encantado** = armadura, todas las estadísticas y resistencias. Choca con Marca de lo salvaje.
- Peletería: **Tienda de campamento** = descansa 30 segundos cerca de ella para tener más experiencia de descanso, una vez por hora.
- Ingeniería: **Robot de componentes** = ningún buff, vende componentes.
- **/mh camp** muestra lo que MH puede leer de tus buffs de campamento.]] },
		-- not measured: Innkeeper Wiley; Scarce (materials)
		{ "Puntos de legado", [[
- Los **Puntos de legado** los gana toda tu cuenta: 65 desafíos, 1 punto cada uno. Cada personaje gasta sus propios puntos, hasta 16 por ahora.
- **Cómo los ganas:** una clase que llega a 25, 45 y 60 por primera vez. Alquimia, Herrería, Encantamiento, Ingeniería, Peletería y Sastrería a 150, 225 y 300. Unos cuantos más por JcJ, mazmorras, bandas y exploración.
- Las profesiones de recolección, Cocina, Primeros auxilios y Pesca no dan puntos.
- La ventana se abre con tu primer punto. Para la mayoría de los jugadores eso es en el nivel 25.
- **Gastar:** pulsa el botón **Banda antigua** en la barra de menú. Hay tres árboles: **Profesiones**, **Aventura** e **Ingenio**. Cada rango cuesta 1 punto.
- La **columna 2** se abre tras 5 puntos en ese árbol, la **columna 3** tras 10.
- **Deshacer:** con tu instructor de clase, todas las ventajas a la vez. El instructor muestra el precio. ¿Tienes Talentoso? Entonces desaprende primero tus talentos de clase.
- **Recompensas** a los 15, 25, 40 y 55 puntos ganados (ganados, no gastados). Recógelas de **Innkeeper Wiley** en Trinquete.
- **Ejemplo, subir de nivel:** **Bien descansado** (la experiencia de descanso se acumula más rápido), luego **Talentoso** (necesita Bien descansado): puntos de talento hasta 5 niveles antes, nunca más de 51 en total.
- **Ejemplo, profesiones:** **Horas extra** (más subidas de habilidad) y **Cosecha generosa** (materiales Scarce más a menudo de Minería, Herboristería y Desuello).
- **Estudio dedicado** es un botón, no una ventaja pasiva: 25 segundos de lanzamiento, luego 23 horas de espera. Sube en 1 tu habilidad de profesión más baja.
- **/mh legacy** muestra cuántos puntos puede leer MH.]] },
		-- 21 Nov 2026: new 4th section (mh-writer). Measured DB2 esES 1.60.1.71037: TALENT_SPEC_SECONDARY "Talentos secundarios",
		-- spell 63624 "Aprender una segunda especialización de talento" (no separate "Dual Spec" word in the client).
		{ "Talentos: reiniciar y segunda especialización", [[
- **Reinicia tus talentos** con tu instructor de clase: habla con él y elige la opción de talentos. Luego gasta tus puntos otra vez. Los jugadores dicen que cuesta 1 de oro la primera vez, luego 5, luego 10, y más después. Blizzard dice que el precio sube rápido y baja una vez por semana.
- **Segunda especialización de talento:** desde el nivel 40, tu instructor de clase vende un segundo juego de talentos. En el juego se llama **Talentos secundarios**. Los jugadores dicen que cuesta 50 de oro; Blizzard no dio precio.
- **Cambiar** entre tus dos juegos tarda 5 segundos y no funciona en combate.
- **Tus barras tras un cambio:** los jugadores dicen que cambiar puede modificar tus barras de acción: el juego puede poner hechizos en ellas, encima de tus propios botones y macros. MH no lo ha visto en el juego. Revisa tus barras de acción después del primer cambio.
- **Para qué:** sube de nivel con un juego y tanquea o cura con el otro. Un Paladín sube de nivel como Reprensión y tanquea como Protección, un Druida sube de nivel como felino y cura como Recuperación.]] },
	},
	-- 21 Nov 2026: "Level as X, tank as Y" (mh-writer, from ForeverHowToPlay.lua PLANS). Names measured DB2 esES
	-- 1.60.1.71037 (SpellName, TalentTab, Map, GlobalStrings); Aterralobos (item 267369) and Archibald from Wowhead Forever esES.
	-- Two-Handed Swords: SpellName 202 esES reads "Mazas de dos manos" (looks like a Blizzard data slip); SkillLine 55 esES
	-- "Espadas de dos manos" is used here.
	PLANS = {
		PALADIN = { title = "Sube de nivel como Reprensión, tanquea como Protección", body = [[
- **Subir de nivel:** las guías dicen que Reprensión es la forma más rápida de subir de nivel en solitario: un **arma de dos manos** lenta y Sello de rectitud, más tarde Sello de orden (20, un talento). Gasta tus puntos de talento en Reprensión.
- **Tanquear una mazmorra** funciona desde la primera, sin cambiar de talentos: Sima Ígnea para la Horda (desde el nivel 13), el Salón de los Feudales para la Alianza (hacia el 13). Furia justa y Sello de furia llegan los dos en el 10. Lleva un **arma de una mano y un escudo en tus bolsas**. Antes de la mazmorra: equípatelos, activa Furia justa (bloque D) y Sello de furia (**F**). Después: vuelve al arma de dos manos y quita Furia justa (clic derecho sobre ella, arriba a la derecha). Con Furia justa activa, apartas a los enemigos de tu grupo.
- **Cuándo se vuelve fácil:** en el 30 con Escudo Sagrado (un talento de Protección), y de verdad en el 40 con Juramento de escudo. Para eso necesitas talentos de Protección: la **segunda especialización de talento** (desde el 40) te da un segundo juego, así subes de nivel como Reprensión y tanqueas como Protección. Mira "Talentos: reiniciar y segunda especialización" más abajo.
- **Estadísticas para tanquear:** primero Aguante. Las guías no se ponen de acuerdo en lo que sigue: wowforeverbuilder dice Defensa, Aguante, poder con hechizos, Inteligencia (nada de Fuerza), otra guía pone poder con hechizos e Inteligencia por encima de Fuerza. Con poder con hechizos, Consagración y Escudo Sagrado retienen mejor a los enemigos.
- **Espada de dos manos de Aterralobos** (la misión de clase de los No-muertos del 20): aprende primero Espadas de dos manos, con Archibald en Entrañas. MH te lo dice en Haz esto ahora.]] },
		WARRIOR = { title = "Sube de nivel y tanquea como Guerrero", body = [[
- **Subir de nivel:** las guías no se ponen de acuerdo. La mayoría dice que Protección sube de nivel más rápido: un arma de dos manos hasta Revancha en el 14, luego un **arma de una mano y un escudo**. Una guía ve Protección más lenta en solitario. Armas o Furia también funcionan; entonces lleva un arma de una mano y un escudo en tus bolsas para tanquear.
- **Tanquear una mazmorra** funciona desde la primera: Sima Ígnea (Horda) desde el nivel 13, el Salón de los Feudales (Alianza) desde el 13 más o menos, Minas de la Muerte desde el 16, Cuevas de los Lamentos desde el 17. La misión de clase del 10 te da Actitud defensiva, Irritar y Hender armadura. En Forever, Actitud defensiva genera mucha más amenaza que en el juego antiguo, así que los enemigos se quedan contigo.
- **Cuándo se vuelve fácil:** en el 14-16 con Revancha y Bloquear con escudo, y de verdad en el 40 con Embate con escudo (un talento) y Peto de malla.
- **Talentos:** con talentos de Protección subes de nivel y tanqueas con un solo juego. ¿Subiste de nivel como Armas o Furia? Entonces la **segunda especialización de talento** (desde el 40) te da un segundo juego para tanquear. Mira "Talentos: reiniciar y segunda especialización" más abajo.
- **Estadísticas para tanquear:** primero Aguante. En el resto las guías no se ponen de acuerdo: una pone Defensa al final, otra quiere Defensa hasta 440 pronto. Para la amenaza: Golpe y Pericia.]] },
		DRUID = { title = "Sube de nivel y tanquea como Druida", body = [[
- **Subir de nivel:** las guías eligen Combate feral: el oso desde el nivel 10, el felino desde el 20. Los talentos de Combate feral sirven para los dos, así que subes de nivel como felino y tanqueas como oso con los mismos talentos. No necesitas escudo ni una segunda arma.
- **Tu arma cuenta en una forma.** Blizzard: en Forma de oso y Forma felina, tus golpes normales hacen el daño del arma que llevas. Así que quédate con el mejor bastón o maza de dos manos, también para tanquear.
- **Tanquear una mazmorra** funciona desde la primera: Sima Ígnea para la Horda (desde el nivel 13), el Salón de los Feudales para la Alianza (hacia el 13). Forma de oso llega con la misión de clase del 10, con Bramido y Machaque (una guía dice que solo Machaque: revisa tus hechizos). En Forever, Forma de oso genera mucha más amenaza que en el juego antiguo.
- **Cuándo se vuelve fácil:** Flagelo en el 16 (más enemigos a la vez), Lacerar en el 25 (un talento), y de verdad en el 40 con Forma de oso nefasto y Mordisco primigenio (un talento).
- **¿Curar en grupo?** Para eso necesitas talentos de Recuperación y equipo con Inteligencia: la **segunda especialización de talento** (desde el 40) te da un segundo juego. Mira "Talentos: reiniciar y segunda especialización" más abajo.
- **Estadísticas para tanquear:** las guías no se ponen de acuerdo. Para sobrevivir: Armadura, luego Defensa hasta 440, luego Aguante, luego Agilidad. Para la amenaza: daño del arma, luego Agilidad, luego Fuerza. Otra guía dice daño del arma, Fuerza, Agilidad mientras subes de nivel.]] },
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
- 16: Forma acuática (de una misión) en R mientras nadas. 18: Fuego feérico en 5 (funciona en casi todas las formas, pero no en Forma de viaje ni en Forma acuática), Hibernar en Shift-Q.
- 20: Forma felina (de una misión) en Ctrl-2, con Zarpa, Triturar, Destripar y Acechar. Carga feral en E (un talento, como pronto en el nivel 20). Fuego estelar en 3. En combate, F3 pasa a ser Renacer.
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
- **2** = Sentencia (4): reutilización de 10 segundos. No gasta tu sello. Solo funciona si tienes un sello puesto: ponte primero tu sello (3).
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
- 12: Redención (de una misión) en F3 (trae de vuelta a un amigo muerto; no en combate). 14: Bendición de Sabiduría en Shift-V.
- 18: Bendición de Libertad en R (nada puede ralentizarte durante un rato). 20: Consagración en Shift-1 (golpea a varios enemigos a la vez), Exorcismo en 5, Destello de Luz en F2 (cura rápida), Bendición de los Reyes en Shift-X.
- 30: Intervención divina: en combate, F3 lanza este en lugar de Redención. Cuidado: mueres tú; el amigo que eliges queda a salvo de todos los ataques durante un rato. 34: Escudo divino en Z: 10 segundos en los que nada puede hacerte daño, y aun así puedes luchar (con la mitad de daño).
- 42: Purgación sustituye a Purificar en Shift-C. 44: Martillo de cólera en 4 (solo cuando el enemigo tiene un 20% de salud o menos).
- 52-60: en un grupo, las teclas de bendición lanzan la Bendición superior para todo el grupo (por ejemplo Bendición superior de poderío); si juegas solo, lanzan la normal.]] },
		{ "Errores de principiante", [[
- Pulsar Exorcismo (5) contra un enemigo normal. Solo funciona contra No-muertos y Demonios. Ahuyentar a no-muerto (Shift-Q, 24) solo funciona contra No-muertos.
- Pulsar Martillo de cólera (4) al principio del combate. Solo funciona cuando el enemigo está casi muerto (un 20% de salud o menos).
- Escudo divino y Protección divina comparten una reutilización, así que están en una sola tecla (Z). Estos hechizos de protección, Bendición de Protección y Baluarte de templario dan **Paciencia**: durante 1 minuto no puedes recibir ninguno de ellos otra vez. Imposición de manos no.]] },
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
- **Nivel 10, misiones de mascota:** aprendes Domesticar bestia, Llamar a mascota y Retirar mascota; la misión siguiente da Revivir mascota y Alimentar mascota. **F4** = Llamar a mascota (trae a tu mascota), **F3** = Revivir mascota (trae de vuelta a una mascota muerta). Domesticar bestia no tiene tecla; la usas fuera de combate.
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
Cada raza de Sacerdote tiene dos hechizos de Sacerdote propios: uno en el nivel 10 y otro en el nivel 20. Los dos los consigues con una misión, no con el instructor. MH los pone en **X** y **Shift-R**, así que todas las razas usan las mismas dos teclas.
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
- Curar en Forma de las Sombras. Ningún hechizo de curación funciona en Forma de las Sombras. Custodia de miedo tampoco funciona en ella. Sal primero: pulsa otra vez Ctrl-1.
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
	-- Por rol (16 Nov 2026, mh-writer), same shape as ROLES in Modules/ForeverHowToPlay.lua: same band, same order.
	-- Spell names: SpellName esES, wowf 1.60.1.70938. Tree names: ForeverMacros.lua SPEC_NAMES. esMX: own copy.
	ROLES = {
		DRUID = {
			{ band = 2, title = "Oso: tanque", body = [[
Desde el nivel 10 (Forma de oso, de una misión). El **tanque** es al que golpean los enemigos, para que el resto del grupo esté a salvo. Para subir de nivel, las guías dicen que el felino es más cómodo; el oso es útil del 10 al 20, y para tanquear en mazmorras. El oso usa **Ira**: la consigues cuando golpeas y cuando te golpean.
**Orden sencillo:**
1. Haz **pull** con Fuego feérico (**5**, desde el 18) o Carga feral (**E**, desde el 20). **Pull** = golpear a un enemigo desde lejos, para que venga hacia ti.
2. Clamor desmoralizador (**Shift-2**) una vez.
3. Mordisco primigenio (**3**, desde el 40) cada vez que esté listo.
4. Lacerar (**2**, desde el 25) hasta que tenga 5 acumulaciones.
5. Ira de sobra: Machaque (**1**) contra un enemigo, Flagelo (**4**, desde el 16) contra dos o más.
6. Bramido (**F**) cuando un enemigo golpea a otra persona.
**Cada 10 niveles:**
- 10: Forma de oso (**Ctrl-1**), Machaque (**1**), Bramido (**F**), Clamor desmoralizador (**Shift-2**). Luego Enfurecer (**Q**) en el 12, Azote (**V**) en el 14, Flagelo (**4**) en el 16, Fuego feérico (**5**) en el 18.
- 20: Carga feral (**E**, un talento): cargas contra el enemigo y no puede moverse ni lanzar hechizos durante 4 segundos. Reutilización de 15 segundos. Los niveles de talento de aquí son los más tempranos; una ventaja puede adelantarlos hasta 5 niveles.
- 30: Líder de la manada (un talento). Antes: Lacerar (**2**, un talento) en el 25, Clamor desafiante (**Shift-F**) en el 28.
- 40: Forma de oso nefasto sustituye a Forma de oso en **Ctrl-1**. Mordisco primigenio (**3**, un talento). Antes: Regeneración frenética (**X**) en el 36: convierte la Ira en salud.
- 50: rangos más fuertes de Mordisco primigenio, Lacerar y Machaque. Pielcorteza (**Z**) en el 44.
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
5. Con 4-5 puntos de combo: Destripar (**4**) si el enemigo va a vivir mucho; si no, Mordedura feroz (**C**, desde el 24).
6. Poder cambiante (**Q**, desde el 40) cuando tu Energía está por debajo de 50.
**Cada 10 niveles:**
- 10: nada nuevo para este rol (el felino llega en el 20).
- 20: Forma felina (**Ctrl-2**), Zarpa (**1**), Triturar (**3**, por la espalda), Destripar (**4**), Acechar (**Shift-R**). Carga feral (**E**, un talento): como felino saltas detrás del enemigo. Augurio de claridad es pasivo: no tiene tecla.
- 30: Líder de la manada (un talento). Antes: Arañazo (**2**) y Mordedura feroz (**C**) en el 24, Diligencia (**R**) en el 26, Pavor (**F**) en el 28.
- 40: Poder cambiante (**Q**, un talento): 40 de Energía a cambio de maná, reutilización de 8 segundos, solo como felino. Antes: Devastar (bloque D) en el 32, Lanzarse (**V**, desde Acechar, un aturdimiento) en el 36. Los niveles de talento de aquí son los más tempranos; una ventaja puede adelantarlos hasta 5 niveles.
- 50: rangos más fuertes de Mordedura feroz, Destripar y Triturar; nada nuevo para este rol.
- 60: otra vez rangos más fuertes; nada nuevo para este rol.
**Errores de principiante:**
- Triturar de frente. Solo funciona por la espalda; de frente, usa Zarpa.
- Poder cambiante demasiado a menudo. Luego no te queda maná para curarte.]] },
			{ band = 1, title = "Equilibrio: daño a distancia", body = [[
Desde el nivel 1: Cólera la tienes desde el principio, Fuegolunar llega en el 4. Forma de lechúcico lunar es un talento, como pronto en el 40. Las guías dicen que subir de nivel como Equilibrio funciona, pero es más lento que el felino. Algunas guías toman Forma de lechúcico lunar más tarde (Zygor en el 53): el 40 no es una regla.
**Orden sencillo:**
1. Fuego estelar (**3**, desde el 20) para abrir contra un enemigo.
2. Fuegolunar (**2**).
3. Enjambre de insectos (**4**, desde el 25).
4. Cólera (**1**) como relleno. Con Eclipse (desde el 30): Cólera acumula cargas, y luego Fuego estelar (**3**).
5. Huracán (**Shift-1**, desde el 40) contra grupos.
¿Poco maná? Sigue con Cólera: es barata.
**Cada 10 niveles:**
- 10: Cólera (**1**), Fuegolunar (**2**), Espinas (**Shift-Z**), Enredaderas (**V**), Gracia de la naturaleza (**X**).
- 20: Fuego estelar (**3**). Augurio de claridad es pasivo: no tiene tecla.
- 30: Eclipse (un talento): Cólera hace más rápidos tus 2 siguientes Fuego estelar. Antes: Enjambre de insectos (**4**, un talento) en el 25. Los niveles de talento de aquí son los más tempranos; una ventaja puede adelantarlos hasta 5 niveles.
- 40: Forma de lechúcico lunar (**Ctrl-3**, un talento): cuesta maná, da a tu grupo +3% de crítico (**crítico** = un golpe de suerte, más fuerte), pero en ella no hay curas. Huracán (**Shift-1**), Enervar (**F1**).
- 50: rangos más fuertes de Huracán y Fuego estelar. Pielcorteza (**Z**) en el 44.
- 60: otra vez rangos más fuertes; nada nuevo para este rol.
**Errores de principiante:**
- Curar en Forma de lechúcico lunar. No se puede, y volver a la forma cuesta maná.
- Buscar una tecla para Augurio de claridad. Es pasivo: funciona solo.]] },
			{ band = 3, title = "Recuperación: sanador", body = [[
Desde el nivel 1: Toque curativo lo tienes desde el principio. Las guías no aconsejan curar para subir de nivel en solitario (los enemigos mueren despacio): sube de nivel con Cólera y Fuegolunar, y cura en mazmorras. Un **HoT** es una cura que cura poco a poco.
**Orden sencillo (en grupo):**
1. Rejuvenecimiento (**F4**) en el tanque.
2. Recrecimiento (**F2**) en alguien con poca salud.
3. Arreglo rápido (**Shift-F1**, desde el 25): solo en alguien que tiene tu Rejuvenecimiento o tu Recrecimiento.
4. Crecimiento salvaje (**Shift-2**, desde el 40) cuando varias personas reciben daño.
5. Toque curativo (**C**) contra mucho daño. Emergencia: Rapidez de la Naturaleza (**Shift-3**, desde el 30), y luego Toque curativo.
6. Enervar (**F1**, desde el 40) cuando te queda poco maná.
**Cada 10 niveles:**
- 10: Toque curativo (**C**), Rejuvenecimiento (**F4**). Luego Recrecimiento (**F2**) y Revivir (**F3**, fuera de combate) en el 12, Curar veneno (**Shift-C**) en el 14.
- 20: Renacer (**F3**, en combate). Luego Deshacer maldición (**Shift-V**) en el 24, Suprimir veneno (**Shift-C**) en el 26.
- 30: Rapidez de la Naturaleza (**Shift-3**, un talento), Tranquilidad (**Q**). Antes: Arreglo rápido (**Shift-F1**, un talento) en el 25. Los niveles de talento de aquí son los más tempranos; una ventaja puede adelantarlos hasta 5 niveles.
- 40: Crecimiento salvaje (**Shift-2**, un talento), Enervar (**F1**).
- 50: Regalo de lo salvaje (**Shift-X**), un Crecimiento salvaje más fuerte.
- 60: otra vez rangos más fuertes; nada nuevo para este rol.
**Errores de principiante:**
- Curar en una forma. Las curas solo funcionan en tu forma normal.
- Lanzar un HoT a alguien que todavía lo tiene. El nuevo sustituye al viejo.]] },
		},
		-- Warrior to Paladin: 17 Nov 2026, mh-writer, from Modules/ForeverHowToPlay.lua ROLES. Spell names: SpellName esES 1.60.1.70938.
		WARRIOR = {
			{ band = 3, title = "Protección: tanque", body = [[
Desde el nivel 10 (Actitud defensiva, de una misión; la misma misión da Irritar y Hender armadura). El **tanque** es al que golpean los enemigos, para que el resto del grupo esté a salvo. Llevas un arma de una mano y un escudo. **Amenaza** = las ganas que tiene un enemigo de atacarte; como tanque la necesitas en cada enemigo. Las guías no se ponen de acuerdo sobre qué árbol sube de nivel más rápido en solitario: algunas dicen que Protección es el más rápido, otras dicen que en solitario es más lento. Empieza a funcionar hacia el nivel 16, cuando tienes Bloquear con escudo junto a Revancha.
**Orden sencillo:**
1. Actitud defensiva (**Ctrl-2**), Grito de guerra (**Shift-X**). Sanguinario (**F1**) para tener Ira al empezar.
2. Haz **pull**. **Pull** = golpear a un enemigo desde lejos, para que venga hacia ti. Embestir (**R**) solo funciona en Actitud de batalla (**Ctrl-1**); después vuelve a Actitud defensiva (**Ctrl-2**). Con Vanguardia (desde el 25) Embestir también funciona en Actitud defensiva. O haz pull con tu arma a distancia (bloque D).
3. Varios enemigos: Grito desmoralizador (**Shift-2**, desde el 14) una vez, Trueno (**Shift-1**) cada vez que esté listo.
4. Bloquear con escudo (**Z**, desde el 16), y Revancha (**2**, desde el 14) en cuanto se ilumine.
5. Embate con escudo (**3**, desde el 40) cada vez que esté listo.
6. Hender armadura (**5**) en tu objetivo principal; hasta 5 acumulaciones en un jefe.
7. Irritar (**F**) cuando un enemigo ataca a otra persona.
8. Ira de sobra: Golpe heroico (**1**) contra un enemigo, Mellar (**Shift-4**, desde el 20) contra dos o más.
**Cada 10 niveles:**
- 10: Actitud defensiva (**Ctrl-2**), Irritar (**F**), Hender armadura (**5**), Sanguinario (**F1**). Luego Azote de escudo (**E**) en el 12, Revancha (**2**) y Grito desmoralizador (**Shift-2**) en el 14, Bloquear con escudo (**Z**) en el 16, Desactivar (**V**) en el 18.
- 20: Última posición (**X**, un talento): un 30% más de salud máxima durante 20 segundos. Ataque de la victoria (**F2**), Mellar (**Shift-4**). Luego Grito intimidador (**Shift-Q**) en el 22, Vanguardia (un talento, pasivo) en el 25, Grito desafiante (**Shift-F**) en el 26, Muro de escudo (**C**) en el 28. Los niveles de talento de aquí son los más tempranos; una ventaja puede adelantarlos hasta 5 niveles.
- 30: Golpe de concusión (**Shift-V**, un talento): un aturdimiento de 5 segundos. Actitud rabiosa (**Ctrl-3**, de una misión). Luego Bastión (un talento, pasivo) en el 35.
- 40: Embate con escudo (**3**, un talento). Peto de malla en el instructor: puedes llevar armadura de placas.
- 50: nada nuevo para este rol. Rangos más fuertes de Embate con escudo, Revancha, Hender armadura y Trueno.
- 60: otra vez rangos más fuertes; nada nuevo para este rol.
**Errores de principiante:**
- Pensar que Trueno golpea a todo el grupo de enemigos. Golpea a 4 enemigos; un quinto puede correr hacia el sanador.
- Dejar enemigos a tu espalda. Por detrás no puedes bloquear, esquivar ni parar, y Revancha no se ilumina.
- Irritar contra un enemigo que ya te ataca. Entonces no hace nada.]] },
			{ band = 1, title = "Armas: daño con una gran arma", body = [[
Desde el nivel 1. Llevas una gran arma de dos manos y casi siempre estás en Actitud de batalla. Los grandes pasos son Golpes de barrido en el 30 y Golpe mortal en el 40. Un arma nueva es tu mayor mejora. No tienes cura propia, salvo Ataque de la victoria (desde el 20), así que ten a mano comida y vendas. Las guías no se ponen de acuerdo sobre qué árbol sube de nivel más rápido; los tres funcionan.
**Orden sencillo:**
1. Actitud de batalla (**Ctrl-1**), Grito de guerra (**Shift-X**).
2. Embestir (**R**) para empezar.
3. Desgarrar (**Shift-Z**), si el enemigo va a vivir un rato.
4. Abrumar (**2**, desde el 12) en cuanto se ilumine.
5. Golpe mortal (**3**, desde el 40) cada vez que esté listo; guarda 30 de Ira para él.
6. Ataque de la victoria (**F2**, desde el 20) después de matar a un enemigo, cuando te falta salud.
7. Dos enemigos: Golpes de barrido (**Q**, desde el 30), y luego Mellar (**Shift-4**, desde el 20). Antes del 30: Trueno (**Shift-1**).
8. Ira de sobra: Golpe heroico (**1**).
**Cada 10 niveles:**
- 10: Golpe heroico (**1**), Embestir (**R**), Desgarrar (**Shift-Z**), Trueno (**Shift-1**), Seccionar (**V**), Grito de guerra (**Shift-X**), Sanguinario (**F1**). Luego Abrumar (**2**) en el 12, Grito desmoralizador (**Shift-2**) en el 14.
- 20: Ataque de la victoria (**F2**), Mellar (**Shift-4**), Embate (**Shift-C**), Represalias (**C**). Luego Ejecutar (**4**) en el 24, Lanzazo (**F3**, un talento) en el 25: un golpe fuerte extra contra Giants y Dragonkin. Los niveles de talento de aquí son los más tempranos; una ventaja puede adelantarlos hasta 5 niveles.
- 30: Golpes de barrido (**Q**, un talento, solo en Actitud de batalla): tus 5 siguientes golpes también golpean a un enemigo junto a tu objetivo. Actitud rabiosa (**Ctrl-3**, de una misión) con Interceptar (**R**) e Ira rabiosa (**Shift-V**). Luego Embate mejorado (un talento, pasivo) en el 35, Huracán (**2** en Actitud rabiosa) en el 36, Zurrar (**E** en Actitud rabiosa) en el 38.
- 40: Golpe mortal (**3**, un talento): el enemigo recibe un 50% menos de curación durante 10 segundos. Peto de malla en el instructor.
- 50: Temeridad (**Q** en Actitud rabiosa). Rangos más fuertes de Golpe mortal.
- 60: otra vez rangos más fuertes; nada nuevo para este rol.
**Errores de principiante:**
- Pulsar Golpe heroico (**1**) todo el rato. Ese golpe no da Ira, así que no te queda nada para Golpe mortal ni para Abrumar.
- Embate (**Shift-C**) antes del talento Embate mejorado: 1,5 segundos de lanzamiento que retrasan tu golpe normal. La mayoría de las guías no lo usan hasta entonces.
- Buscar una interrupción en **E** con un arma de dos manos. Azote de escudo necesita un escudo; tu interrupción es Zurrar (38, Actitud rabiosa).]] },
			{ band = 2, title = "Furia: daño con dos armas", body = [[
Un arma en cada mano, desde el nivel 20 (Doble empuñadura en el instructor). Hasta entonces, usa tu mejor arma (una de dos manos está bien) y juega como Armas. Furia se vuelve fuerte de verdad con Huracán (36) y Sed de sangre (40). Necesitas dos armas buenas. Huracán, Zurrar, Interceptar e Ira rabiosa solo funcionan en Actitud rabiosa, así que cambias de actitud a menudo.
**Orden sencillo (desde el 36; antes, juega como Armas):**
1. Grito de guerra (**Shift-X**). Sanguinario (**F1**) para tener Ira.
2. Embestir (**R**) en Actitud de batalla (**Ctrl-1**).
3. Deseo de la Muerte (**Shift-3**, desde el 30) contra un enemigo fuerte.
4. Actitud rabiosa (**Ctrl-3**): Huracán (**2**, desde el 36) cada vez que esté listo.
5. Sed de sangre (**3**, desde el 40) cada vez que esté lista. Las guías no coinciden en cuál de estos dos va primero.
6. Ataque de la victoria (**F2**) después de matar a un enemigo, cuando te falta salud.
7. Ira de sobra: Golpe heroico (**1**); contra dos enemigos, Mellar (**Shift-4**).
8. Poca Ira: Golpes temerarios (**Shift-F1**, desde el 25; cuesta salud).
**Cada 10 niveles:**
- 10: nada nuevo para este rol: juegas como Armas, con un arma.
- 20: Doble empuñadura en el instructor: ahora puedes llevar un arma en la otra mano. Aullido penetrante (**Shift-R**, un talento): ralentiza a todos los enemigos cerca de ti. Ataque de la victoria (**F2**), Mellar (**Shift-4**). Luego Ejecutar (**4**) en el 24, Golpes temerarios (**Shift-F1**, un talento) en el 25. Los niveles de talento de aquí son los más tempranos; una ventaja puede adelantarlos hasta 5 niveles.
- 30: Deseo de la Muerte (**Shift-3**, un talento). Actitud rabiosa (**Ctrl-3**, de una misión) con Interceptar (**R**) e Ira rabiosa (**Shift-V**). Luego Huracán (**2** en Actitud rabiosa) en el 36, Zurrar (**E** en Actitud rabiosa) en el 38.
- 40: Sed de sangre (**3**, un talento; antes necesitas Deseo de la Muerte). No cura; te hace correr más rápido. Peto de malla en el instructor.
- 50: Temeridad (**Q** en Actitud rabiosa). Rangos más fuertes de Sed de sangre.
- 60: otra vez rangos más fuertes; nada nuevo para este rol.
**Errores de principiante:**
- Jugar como Furia con un arma buena y una segunda mala.
- Buscar Huracán (**2**) en Actitud de batalla. Solo funciona en Actitud rabiosa, y allí Desgarrar y Trueno no funcionan.
- Deseo de la Muerte (**Shift-3**) en un combate que podrías perder. Durante 30 segundos también recibes un 5% más de daño.]] },
			-- not measured: Giants, Dragonkin (creature types, kept English)
		},
		MAGE = {
			{ band = 1, title = "Arcano: daño a distancia", body = [[
Desde el nivel 8 (Misiles Arcanos). Explosión Arcana es un talento, como pronto en el 20; hasta entonces juegas como cualquier mago, con Descarga de Escarcha, Bola de Fuego y Misiles Arcanos. Las guías no coinciden: algunas dicen que Arcano es fuerte para subir de nivel, la mayoría aconseja Escarcha y dice que Arcano gasta mucho maná. Su árbol no tiene ralentizaciones, así que es el más débil para mantener lejos a los enemigos. Una **canalización** es un hechizo que dura mientras estás quieto; si te mueves, se detiene. Misiles Arcanos es una.
**Orden sencillo:**
1. Abre con Descarga de Escarcha (**2**): así el enemigo llega despacio.
2. Explosión Arcana (**Ctrl-2**, desde el 20): una o dos, contra un jefe hasta cuatro. Cada una hace que la siguiente cueste más maná.
3. ¿Se ilumina Tromba de misiles (desde el 15)? Misiles Arcanos (**3**) enseguida: gratis y el doble de rápido.
4. Cólera Arcana (**Shift-F1**, desde el 25) cada vez que esté lista.
5. ¿El enemigo está cerca de ti? Nova de Escarcha (**V**), apártate.
6. Casi muerto: tu varita (**Ctrl-3**, hasta el 40) o Explosión de Fuego (**5**).
7. Enemigo duro o jefe: Presencia mental (**Shift-3**, desde el 30), y luego Cólera Arcana para un gran golpe instantáneo. Desde el 40 también Poder Arcano (**Q**).
Varios enemigos: Nova de Escarcha (**V**), y luego Deflagración Arcana (**Shift-2**, desde el 14). ¿Poco maná? Evocación (**F1**, desde el 20).
**Cada 10 niveles:**
- 10: Nova de Escarcha (**V**). Primer talento: Canalización mejorada (Misiles Arcanos ya no se corta cuando te golpean). Luego Deflagración Arcana (**Shift-2**) en el 14, Tromba de misiles (un talento, pasivo) en el 15. Los niveles de talento de aquí son los más tempranos; una ventaja puede adelantarlos hasta 5 niveles.
- 20: Explosión Arcana (**Ctrl-2**, un talento). Traslación (**R**), Evocación (**F1**), Escudo de maná (**Z**). Luego Contrahechizo (**E**) en el 24, Cólera Arcana (**Shift-F1**, un talento; antes necesitas Explosión Arcana) en el 25.
- 30: Presencia mental (**Shift-3**, un talento): tu siguiente hechizo con menos de 10 segundos de lanzamiento es instantáneo. Armadura de hielo (**Shift-Z**). Luego Armadura de mago (bloque D) en el 34.
- 40: Poder Arcano (**Q**, un talento; antes necesitas Presencia mental): durante 15 segundos tus hechizos hacen un 30% más de daño, pero cuestan un 30% más de maná. Descarga de Pirofrío ocupa **Ctrl-3**: pon tu varita (Disparar) en una de tus propias teclas Alt.
- 50: rangos más fuertes de Explosión Arcana, Cólera Arcana y Misiles Arcanos; nada nuevo para este rol.
- 60: otra vez rangos más fuertes; nada nuevo para este rol.
**Errores de principiante:**
- Pulsar Explosión Arcana una y otra vez. Cada una hace que la siguiente cueste un 100% más de maná; te quedas sin maná muy rápido.
- Moverte durante Misiles Arcanos. Es una canalización: si te mueves, se detiene.
- Poder Arcano contra un enemigo normal. También hace que tus hechizos cuesten más, y tiene una reutilización de 3 minutos.]] },
			{ band = 2, title = "Fuego: daño a distancia", body = [[
Desde el nivel 1 (Bola de Fuego). Piroexplosión es un talento, como pronto en el 20. El juego de Fuego de verdad empieza con Calentamiento (como pronto en el 25); antes, Piroexplosión solo sirve para abrir. Las guías dicen que Fuego hace más daño contra un solo enemigo, y que sube de nivel rápido pero con más riesgo que Escarcha: no tiene congelaciones propias. Un **crítico** es un golpe de suerte, más fuerte.
**Orden sencillo:**
1. Abre desde lejos con Piroexplosión (**4**, desde el 20). Antes: Bola de Fuego (**1**).
2. Bola de Fuego (**1**) como tu hechizo normal.
3. Explosión de Fuego (**5**) cada vez que esté lista. Desde el 25, cada Explosión de Fuego te da una acumulación de Calentamiento.
4. ¿Dos o tres acumulaciones de Calentamiento (desde el 25)? Piroexplosión (**4**).
5. Enemigo cerca: Chamuscar (**Ctrl-1**, desde el 22) en lugar de Bola de Fuego, o Nova de Escarcha (**V**) y apártate. Desde el 30, Ola explosiva (**F3**) después.
6. Casi muerto: tu varita (**Ctrl-3**, hasta el 40) o Explosión de Fuego.
7. Élite o jefe, desde el 40: Combustión (**Q**).
Varios enemigos: Nova de Escarcha (**V**), Fogonazo (**Shift-4**, desde el 16), Ola explosiva (**F3**, desde el 30).
**Cada 10 niveles:**
- 10: Nova de Escarcha (**V**). Primer talento: Acelerante (Bola de Fuego se lanza más rápido). Luego Ignición e Impacto (talentos) en el 15, Fogonazo (**Shift-4**) en el 16. Los niveles de talento de aquí son los más tempranos; una ventaja puede adelantarlos hasta 5 niveles.
- 20: Piroexplosión (**4**, un talento): 6 segundos de lanzamiento, así que solo para abrir. Traslación (**R**), Evocación (**F1**), Custodia de Fuego (**F4**), Escudo de maná (**Z**). Luego Chamuscar (**Ctrl-1**) en el 22, Contrahechizo (**E**) en el 24, Calentamiento (un talento, pasivo; antes necesitas Piroexplosión) en el 25: un crítico con Bola de Fuego, Descarga de Pirofrío, Explosión de Fuego o Chamuscar hace tu siguiente Piroexplosión un 25% más rápida, hasta 3 acumulaciones.
- 30: Ola explosiva (**F3**, un talento): instantánea, a tu alrededor; los enemigos van un 50% más lentos durante 6 segundos. Masa crítica (un talento). Armadura de hielo (**Shift-Z**). Luego Poder de Fuego (un talento) en el 35.
- 40: Combustión (**Q**, un talento; antes necesitas Masa crítica). Descarga de Pirofrío ocupa **Ctrl-3**: pon tu varita (Disparar) en una de tus propias teclas Alt.
- 50: rangos más fuertes de Bola de Fuego, Piroexplosión, Ola explosiva y Descarga de Pirofrío; nada nuevo para este rol.
- 60: otra vez rangos más fuertes; nada nuevo para este rol.
**Errores de principiante:**
- Lanzar Piroexplosión cuando el enemigo ya está encima de ti. 6 segundos de lanzamiento es demasiado lento entonces.
- Pensar que tres acumulaciones de Calentamiento hacen instantánea Piroexplosión. Sigue teniendo 1,5 segundos de lanzamiento: quédate quieto.
- Buscar un Bloqueo de hielo. Fuego no tiene. Tu salida: Nova de Escarcha (**V**), Traslación (**R**), Ola explosiva (**F3**).]] },
			{ band = 3, title = "Escarcha: daño a distancia", body = [[
Desde el nivel 4 (Descarga de Escarcha); Nova de Escarcha llega en el 10. Lanza de hielo es un talento, como pronto en el 20. Para subir de nivel es la primera opción de la mayoría de las guías: dicen que es la más segura. Empieza a funcionar de verdad hacia el 30. **Congelado** = el enemigo está congelado en su sitio y no puede moverse.
**Orden sencillo:**
1. Descarga de Escarcha (**2**) desde lo más lejos que puedas. Cada golpe ralentiza al enemigo.
2. ¿El enemigo está Congelado (por Nova de Escarcha, o por el talento Mordiescarcha)? Lanza de hielo (**F**, desde el 20).
3. ¿El enemigo está cerca? Nova de Escarcha (**V**), apártate, Descarga de Escarcha, y luego Lanza de hielo.
4. ¿Se ilumina Dedos de Escarcha (desde el 30)? Lanza de hielo.
5. Lanza de hielo no está lista y el enemigo está cerca: Cono de frío (**Shift-F**, desde el 26).
6. Casi muerto: tu varita (**Ctrl-3**, hasta el 40) o Explosión de Fuego (**5**).
Varios enemigos (desde el 20): Nova de Escarcha (**V**), apártate, Ventisca (**Shift-1**), y luego Cono de frío (**Shift-F**). En apuros: Bloqueo de hielo (**C**, desde el 25), Traslación (**R**).
**Cada 10 niveles:**
- 10: Nova de Escarcha (**V**). Primer talento: Descarga de Escarcha mejorada (menos tiempo de lanzamiento). Luego Mordiescarcha (un talento) en el 15: tus ralentizaciones pueden congelar al enemigo durante 5 segundos. Los niveles de talento de aquí son los más tempranos; una ventaja puede adelantarlos hasta 5 niveles.
- 20: Lanza de hielo (**F**, un talento): un 300% más de daño contra un enemigo Congelado. Ventisca (**Shift-1**), Traslación (**R**), Evocación (**F1**), Escudo de maná (**Z**). Luego Custodia de Escarcha (**F2**) en el 22, Contrahechizo (**E**) en el 24, Bloqueo de hielo (**C**, un talento) en el 25, Cono de frío (**Shift-F**) en el 26.
- 30: Mordedura helada (**Shift-C**, un talento): reinicia la reutilización de tus otros hechizos de Escarcha; su propia reutilización es de 10 minutos. Dedos de Escarcha (un talento; antes necesitas Lanza de hielo): tus 2 siguientes hechizos actúan como si el enemigo estuviera Congelado. Armadura de hielo (**Shift-Z**). Luego Escalofrío del invierno (un talento) en el 35.
- 40: Barrera de hielo (**X**, un talento; antes necesitas Mordedura helada): un escudo que absorbe daño. Descarga de Pirofrío ocupa **Ctrl-3**: pon tu varita (Disparar) en una de tus propias teclas Alt.
- 50: rangos más fuertes de Descarga de Escarcha, Cono de frío, Armadura de hielo, Barrera de hielo y Ventisca; nada nuevo para este rol.
- 60: otra vez rangos más fuertes; nada nuevo para este rol.
**Errores de principiante:**
- Lanza de hielo contra un enemigo que no está Congelado. Entonces es un golpe pequeño.
- Pulsar Explosión de Fuego justo antes de congelar. Explosión de Fuego y Lanza de hielo comparten una reutilización de 8 segundos.
- Usar Mordedura helada para nada. Tiene una reutilización de 10 minutos: guárdala para cuando las cosas salen mal.]] },
		},
		PRIEST = {
			{ band = 1, title = "Disciplina: sanador", body = [[
Desde el nivel 1: Curación inferior la tienes desde el principio. Sus propios hechizos llegan más tarde: Amparo de alma en el 25 y Penitencia en el 30, los dos como pronto. En grupo es el más fuerte curando a una sola persona, el tanque. Subir de nivel en solitario funciona con Acometida, Fuego Sagrado y tu varita, más tarde Penitencia; las guías no coinciden en si es más rápido que Sombra. **Alma debilitada**: después de un Palabra de poder: escudo, la misma persona no puede recibir un escudo nuevo durante 15 segundos.
**Orden sencillo (en grupo):**
1. Palabra de poder: escudo (**Z**) en el tanque, justo antes del pull. **Pull** = el primer golpe que empieza un combate.
2. Renovar (**F4**) en el tanque.
3. Penitencia (**Shift-F1**, desde el 30) en quien esté herido, cada vez que esté lista.
4. Tu gran cura (**C**) para el daño normal.
5. Destello curativo (**F2**, desde el 20) cuando C es demasiado lenta.
6. Más gente herida: Rezo de curación (**Shift-2**, desde el 30).
7. Enfoque interno (**F1**, desde el 20) antes de una cura cara. Infusión de poder (**Q**, desde el 40) sobre ti o sobre un lanzador.
En solitario: Escudo (**Z**), Fuego Sagrado (**4**, desde el 20), Acometida (**1**), Explosión mental (**3**), Palabra de las Sombras: Dolor (**2**), Penitencia si no la necesitas para curar, y luego tu varita (**5**).
**Cada 10 niveles:**
- 10: Curación inferior (**C**), Palabra de poder: escudo (**Z**), Renovar (**F4**), Resurrección (**F3**, solo fuera de combate), Acometida (**1**). Luego Fuego interno (**Shift-Z**) en el 12, Curar enfermedad (**Shift-C**) en el 14, Curar (**C**) en el 16, Disipar magia (**Shift-V**) en el 18.
- 20: Destello curativo (**F2**), Fuego Sagrado (**4**), Custodia de miedo (bloque D). Enfoque interno (**F1**, un talento): tu siguiente hechizo no cuesta maná y es crítico más a menudo; reutilización de 3 minutos. Luego Amparo de alma (un talento, pasivo) en el 25: Escudo no tiene reutilización y cuesta menos. Los niveles de talento de aquí son los más tempranos; una ventaja puede adelantarlos hasta 5 niveles.
- 30: Penitencia (**Shift-F1**, un talento): cura a un amigo o daña a un enemigo; reutilización de 12 segundos. Rezo de curación (**Shift-2**), Espíritu divino (bloque D). Luego Suprimir enfermedad (**Shift-C**) en el 32, Égida divina (un talento, pasivo) en el 35.
- 40: Infusión de poder (**Q**, un talento; antes necesitas Penitencia): un 20% más de daño y curación con hechizos; reutilización de 3 minutos. Curación superior ocupa **C**.
- 50: rangos más fuertes de Penitencia, Rezo de curación, Destello curativo y Renovar. Rezo de entereza (**Shift-X**) en el 48.
- 60: otra vez rangos más fuertes; nada nuevo para este rol.
**Errores de principiante:**
- Poner un escudo al mismo jugador dos veces seguidas. Alma debilitada lo impide. Es por jugador: otra persona puede recibir un escudo enseguida.
- Penitencia contra un enemigo para curar a tu grupo. Cura o daña, no las dos cosas.
- Rezo de curación en el jugador equivocado. Cura al grupo del jugador que eliges.]] },
			{ band = 2, title = "Sagrado: sanador", body = [[
Desde el nivel 1: Curación inferior la tienes desde el principio. Sagrado es el sanador de grupo. En solitario sube de nivel despacio: las guías aconsejan hacer misiones con Acometida y tu varita, y curar en mazmorras. Sus propios hechizos llegan tarde: Nova Sagrada en el 20 y Rezo de alivio en el 40, los dos como pronto.
**Orden sencillo (en grupo):**
1. Renovar (**F4**) en el tanque cuando empieza el pull. **Pull** = el primer golpe que empieza un combate.
2. Rezo de alivio (**Ctrl-2**, desde el 40) en el tanque antes del pull, y otra vez cada vez que esté listo.
3. Tu gran cura (**C**) para el daño normal.
4. Destello curativo (**F2**, desde el 20) cuando C llegaría demasiado tarde.
5. Todo el grupo herido: Rezo de curación (**Shift-2**, desde el 30). Nova Sagrada (**Shift-1**, desde el 20) solo cuando todos están justo a tu lado; cuesta mucho maná.
6. Palabra de poder: escudo (**Z**) para ganar tiempo.
7. Un enemigo te ataca: Desvanecer (**F**).
**Cada 10 niveles:**
- 10: Curación inferior (**C**), Palabra de poder: escudo (**Z**), Renovar (**F4**), Resurrección (**F3**, solo fuera de combate). Luego Fuego interno (**Shift-Z**) en el 12, Curar enfermedad (**Shift-C**) en el 14, Curar (**C**) en el 16, Disipar magia (**Shift-V**) en el 18.
- 20: Nova Sagrada (**Shift-1**, un talento): instantánea; daña a los enemigos a tu alrededor y cura a tu grupo, sin amenaza. Destello curativo (**F2**), Fuego Sagrado (**4**), Custodia de miedo (bloque D). Luego Vinculación sagrada (un talento, pasivo) en el 25: Destello curativo sobre otra persona te cura a ti la mitad. Los niveles de talento de aquí son los más tempranos; una ventaja puede adelantarlos hasta 5 niveles.
- 30: Rezo de curación (**Shift-2**), Espíritu divino (bloque D). Espíritu de redencción (un talento, pasivo). Luego Suprimir enfermedad (**Shift-C**) en el 32, Curación espiritual (un talento, pasivo) en el 35.
- 40: Rezo de alivio (**Ctrl-2**, un talento; antes necesitas Espíritu de redencción): cura en cuanto el objetivo recibe daño, y luego salta a otro miembro del grupo, hasta 5 veces; reutilización de 10 segundos. Curación superior ocupa **C**.
- 50: rangos más fuertes de Rezo de alivio, Nova Sagrada, Rezo de curación y Renovar. Rezo de entereza (**Shift-X**) en el 48.
- 60: otra vez rangos más fuertes; nada nuevo para este rol.
**Errores de principiante:**
- Rezo de curación en el jugador equivocado. Cura al grupo del jugador que eliges, no al tuyo.
- Destello curativo para todo. Es rápido pero caro; guárdalo para emergencias.
- Nova Sagrada contra un grupo que está lejos. Solo funciona justo a tu alrededor, y cuesta mucho.]] },
			{ band = 3, title = "Sombra: daño a distancia", body = [[
Desde el nivel 4 (Palabra de las Sombras: Dolor); Explosión mental llega en el 10. Despelleje mental es un talento, como pronto en el 20; Forma de las Sombras, en el 40. La mayoría de las guías suben de nivel como Sombra; algunas juegan Disciplina hasta el 40. Al principio, tu varita hace gran parte del trabajo. Sombra no tiene ningún hechizo que golpee a muchos enemigos a la vez. Un **DoT** es daño en trocitos durante unos segundos. Una **canalización** es un hechizo que dura mientras estás quieto.
**Orden sencillo:**
1. Palabra de poder: escudo (**Z**) sobre ti, si el enemigo va a llegar hasta ti.
2. Explosión mental (**3**) desde lejos, para empezar.
3. Palabra de las Sombras: Dolor (**2**).
4. Peste devoradora (**Shift-3**, desde el 20) contra un enemigo que va a vivir un rato.
5. Despelleje mental (**1**, desde el 20), y déjalo llegar hasta el final. Antes: Acometida (**1**).
6. Remata con tu varita (**5**).
¿Poco maná? Sáltate Peste devoradora y Despelleje mental, y usa antes tu varita. Desde el 32: Palabra de las Sombras: muerte (**Shift-4**) solo cuando va a matar al enemigo. Desde el 40: activa Forma de las Sombras (**Ctrl-1**) antes del primer pull, y déjala activa.
**Cada 10 niveles:**
- 10: Explosión mental (**3**), reutilización de 8 segundos. Ya tienes Acometida (**1**), Palabra de las Sombras: Dolor (**2**), Palabra de poder: escudo (**Z**), Desvanecer (**F**) y tu varita (**5**). Luego Fuego interno (**Shift-Z**) en el 12, Alarido psíquico (**V**) en el 14.
- 20: Despelleje mental (un talento): ocupa la tecla **1** en lugar de Acometida. Peste devoradora (**Shift-3**): un DoT que también te cura; reutilización de 24 segundos. Luego Unirse a vampírica (**Ctrl-3**, un talento) en el 25 o el 30: tu grupo se cura un 20% de tu daño de sombras. Los niveles de talento de aquí son los más tempranos; una ventaja puede adelantarlos hasta 5 niveles.
- 30: Silencio (**E**, un talento): tu **interrupción** (detiene el hechizo de un enemigo); reutilización de 45 segundos. Control mental (**Shift-F**). Luego Palabra de las Sombras: muerte (**Shift-4**) en el 32, Levitar (**R**) en el 34.
- 40: Forma de las Sombras (**Ctrl-1**, un talento; antes necesitas Unirse a vampírica): un 10% más de daño de sombras, los hechizos de sombras cuestan la mitad, recibes un 15% menos de daño físico, pero no tienes hechizos de curación. Antes: Oscuridad (un talento, pasivo) en el 35.
- 50: rangos más fuertes de Despelleje mental, Explosión mental, Palabra de las Sombras: Dolor, Peste devoradora y Palabra de las Sombras: muerte. Rezo de entereza (**Shift-X**) en el 48.
- 60: rangos más fuertes de Despelleje mental y Peste devoradora; nada nuevo para este rol.
**Errores de principiante:**
- Palabra de las Sombras: muerte contra un enemigo con mucha salud. Si no muere, pierdes un 30% de tu propia salud.
- Parar Despelleje mental antes de tiempo. Con el talento Tortura mental mejorada, el último tic es el más fuerte.
- Abrir con Explosión mental en grupo. Causa mucha amenaza (las ganas que tiene un enemigo de atacarte): deja que el tanque vaya primero. Si un enemigo te ataca: Desvanecer (**F**).]] },
		},
		ROGUE = {
			{ band = 1, title = "Asesinato: dagas y veneno", body = [[
Desde el nivel 1 (Golpe siniestro y Eviscerar). Luchas cuerpo a cuerpo, con dagas y veneno. Usas **Energía**, que se rellena sola. Tus golpes dan **puntos de combo** (hasta 5) en el enemigo al que golpeas; un **remate** los gasta todos. Mutilar es un talento, como pronto en el 40, y necesita una daga en cada mano. Hasta entonces juegas con Puñalada o Golpe siniestro. Las guías no dicen que este sea el comienzo más fácil: el gran paso solo llega con Mutilar.
**Orden sencillo:**
1. Desde el 20: veneno en las dos armas (objetos, en el bloque D).
2. Espera a tener la Energía llena. Desde el 18 (Disposición) tu primer ataque cuesta entonces 10 de Energía menos.
3. Sigilo (**Shift-R**), ponte detrás del enemigo. **Sigilo** = avanzar a escondidas, para que el enemigo no te vea. Abre con Emboscada (**2**, desde el 18, daga en tu mano principal) o Garrote (**1**, desde el 14). Enemigo fuerte, desde el 26: Golpe bajo (**V**), un aturdimiento de 4 segundos.
4. Puntos de combo: Puñalada (**2**) cuando estás detrás del enemigo; si no, Golpe siniestro (**1**). Desde el 40: Mutilar (**3**), 2 puntos cada vez.
5. Apuñalar (**Shift-3**, desde el 24) cada vez que esté listo. Con Veneno (desde el 30), cada Apuñalar hace tu veneno más fuerte durante 6 segundos.
6. Remate: Hacer picadillo (**Shift-4**) en un combate largo; si no, Eviscerar (**4**) con 5 puntos. Ruptura (**5**, desde el 20) contra un enemigo que va a vivir mucho (un élite, un jefe).
7. Sangre fría (**F1**, desde el 25) justo antes de un Eviscerar con 5 puntos.
**Cada 10 niveles:**
- 10: ya tienes Golpe siniestro (**1**), Eviscerar (**4**), Puñalada (**2**), Sigilo (**Shift-R**), Incapacitación (**Shift-Q**) y Evasión (**Z**). Nuevo en el 10: Hacer picadillo (**Shift-4**), Correr (**R**), Zapar (**Shift-Q** en Sigilo), y un arma en cada mano (Doble empuñadura). Luego Patada (**E**) en el 12, Garrote (**1** en Sigilo) y Exponer armadura (**Shift-Z**) en el 14, Amago (**F**) en el 16, Emboscada (**2** en Sigilo) y Disposición (pasivo) en el 18.
- 20: Ruptura (**5**). Venenos, de una misión. Luego Esfumar (**X**) en el 22, Apuñalar (**Shift-3**) en el 24, Sangre fría (**F1**, un talento) en el 25: tu siguiente Golpe siniestro, Puñalada, Emboscada, Eviscerar o Mutilar es crítico seguro (**crítico** = un golpe de suerte, más fuerte); reutilización de 3 minutos. Golpe bajo (**V** en Sigilo) en el 26. Los niveles de talento de aquí son los más tempranos; una ventaja puede adelantarlos hasta 5 niveles.
- 30: Veneno (un talento, pasivo: sin tecla): cada Apuñalar da a tu veneno un 30% más de daño y un 20% más de probabilidad de acertar, durante 6 segundos. Golpe a los riñones (**V**). Luego Ceguera (**Shift-V**) en el 34, Sello del destino (un talento, pasivo) en el 35: un crítico con un ataque que da puntos de combo te da un punto extra.
- 40: Mutilar (**3**, un talento; antes necesitas Veneno): 60 de Energía, golpea con las dos dagas, 2 puntos de combo, un 20% más de daño contra un enemigo envenenado. Luego Hacer picadillo rango 2 en el 42, Apuñalar rango 2 en el 44.
- 50: Mutilar rango 2 y Golpe a los riñones rango 2; nada nuevo para este rol.
- 60: Mutilar rango 3 y rangos más fuertes; nada nuevo para este rol.
**Errores de principiante:**
- Mutilar sin dagas. Necesita una daga en cada mano: consigue tu segunda daga antes del nivel 40.
- Olvidar Apuñalar. Veneno solo funciona a través de Apuñalar.
- Cambiar a otro enemigo con puntos de combo en el anterior. Los puntos no vienen contigo.]] },
			{ band = 2, title = "Combate: daño constante con cualquier arma", body = [[
Desde el nivel 1 (Golpe siniestro y Eviscerar). No tienes que estar detrás del enemigo: tu golpe principal es Golpe siniestro. Funciona con cualquier arma de una mano: una espada, un hacha, una maza, un arma de puño o una daga. Varias guías dicen que Combate es el árbol más fácil para subir de nivel en solitario. Aconsejan un arma lenta en tu mano principal y una rápida en la otra mano. Usas **Energía**, que se rellena sola; tus golpes dan **puntos de combo**, y un **remate** los gasta. Ráfaga con espada (como pronto en el 30) es lo único que tiene un Pícaro contra dos enemigos a la vez.
**Orden sencillo:**
1. Espera a tener la Energía llena (Disposición, desde el 18).
2. Abre desde Sigilo (**Shift-R**) con Garrote (**1**, desde el 14), o desde el 26 con Golpe bajo (**V**). También está bien acercarte y atacar sin más.
3. Golpe siniestro (**1**) para puntos de combo.
4. Estocada (**Shift-F1**, desde el 20) en cuanto se ilumine: eso pasa después de que pares un ataque.
5. Apuñalar (**Shift-3**, desde el 24) cuando esté listo.
6. Remate: Hacer picadillo (**Shift-4**) en un combate largo; si no, Eviscerar (**4**) con 5 puntos. Las guías no coinciden en lo pronto que hay que mantener activo Hacer picadillo.
7. Dos enemigos: Ráfaga con espada (**Shift-1**, desde el 30). Desde el 40, junto con Subidón de adrenalina (**Q**) para un combate duro. ¿Vas perdiendo? Evasión (**Z**).
**Cada 10 niveles:**
- 10: ya tienes Golpe siniestro (**1**), Eviscerar (**4**), Sigilo (**Shift-R**), Incapacitación (**Shift-Q**) y Evasión (**Z**). Nuevo en el 10: Hacer picadillo (**Shift-4**), Correr (**R**), Zapar (**Shift-Q** en Sigilo), y un arma en cada mano. Luego Patada (**E**) en el 12, Garrote (**1** en Sigilo) y Exponer armadura (**Shift-Z**) en el 14, Amago (**F**) en el 16, Disposición (pasivo) en el 18.
- 20: Estocada (**Shift-F1**, un talento; antes necesitas Desvío): solo funciona justo después de parar un ataque. 10 de Energía, y el enemigo queda desarmado durante 6 segundos. Ruptura (**5**), y Venenos de una misión. Luego Esfumar (**X**) en el 22, Apuñalar (**Shift-3**) en el 24, Ejecución impecable (un talento, pasivo) en el 25: Eviscerar cuesta 15 de Energía menos. Golpe bajo (**V** en Sigilo) en el 26. Los niveles de talento de aquí son los más tempranos; una ventaja puede adelantarlos hasta 5 niveles.
- 30: Ráfaga con espada (**Shift-1**, un talento): durante 15 segundos atacas un 20% más rápido, y cada golpe también golpea a un segundo enemigo cercano; reutilización de 2 minutos. Cortar y rebanar (un talento, pasivo): una bonificación que depende de tu arma. Golpe a los riñones (**V**). Luego Ceguera (**Shift-V**) en el 34, Destello de acero (un talento, pasivo) en el 35: Apuñalar da hasta 15 de Energía extra y está listo hasta 2 segundos antes.
- 40: Subidón de adrenalina (**Q**, un talento; antes necesitas Ráfaga con espada): durante 15 segundos tu Energía se rellena el doble de rápido; reutilización de 5 minutos. Luego Hacer picadillo rango 2 en el 42 (un 30% más rápido en lugar de un 20%), Apuñalar rango 2 en el 44 (te devuelve 25 de Energía en lugar de 15).
- 50: Golpe a los riñones rango 2 y rangos más fuertes; nada nuevo para este rol.
- 60: rangos más fuertes; nada nuevo para este rol.
**Errores de principiante:**
- Ráfaga con espada junto a un enemigo que sacaste del combate con Zapar, Incapacitación o Ceguera. Los golpes extra lo despiertan.
- Pulsar Estocada cuando no has parado nada. Solo funciona justo después de parar.
- Puñalada o Emboscada con una espada, un hacha o una maza. Las dos necesitan una daga en tu mano principal.]] },
			{ band = 3, title = "Sutileza: golpear desde Sigilo", body = [[
Desde el nivel 1 (Golpe siniestro y Sigilo). Este árbol lucha desde Sigilo: un primer golpe fuerte, y muchos puntos de combo antes de que el combate empiece de verdad. **Sigilo** = avanzar a escondidas, para que el enemigo no te vea. Las guías dicen que subir de nivel en solitario va más lento que con Combate. Hemorragia es un talento, como pronto en el 30: barato, de frente, con cualquier arma, pero con una daga pega más fuerte.Marca de muerte es un talento, como pronto en el 40. Emboscada y Puñalada necesitan una daga en tu mano principal; Hemorragia y Golpe fantasmal no.
**Orden sencillo:**
1. Sigilo (**Shift-R**). ¿Otro humanoide cerca? Zapar (**Shift-Q**). Zapar no rompe el Sigilo.
2. Premeditación (**Shift-C**, desde el 20): 2 puntos de combo en el enemigo. Luego tu primer golpe.
3. Primer golpe por la espalda: Emboscada (**2**, desde el 18, daga en tu mano principal). Enemigo fuerte, desde el 26: Golpe bajo (**V**), un aturdimiento de 4 segundos. Las guías no coinciden en la mejor apertura.
4. Golpe fantasmal (**Shift-X**, desde el 25) y Apuñalar (**Shift-3**, desde el 24) cada vez que estén listos.
5. Puntos de combo: desde el 30, Hemorragia (**3**). Antes: Puñalada (**2**) cuando estás detrás del enemigo; si no, Golpe siniestro (**1**).
6. Remate: Eviscerar (**4**) cuando el enemigo está casi muerto; Ruptura (**5**) contra un enemigo que va a vivir mucho; Hacer picadillo (**Shift-4**) en un combate largo.
7. Desde el 40: Marca de muerte (**Q**) en el enemigo más fuerte, mejor mientras Ruptura o Garrote están activos.
8. Emergencia: Esfumar (**X**). Preparación (**F3**, desde el 30) deja Esfumar, Evasión y Correr listos otra vez enseguida.
**Cada 10 niveles:**
- 10: ya tienes Golpe siniestro (**1**), Eviscerar (**4**), Puñalada (**2**), Sigilo (**Shift-R**), Incapacitación (**Shift-Q**) y Evasión (**Z**). Nuevo en el 10: Zapar (**Shift-Q** en Sigilo), Hacer picadillo (**Shift-4**), Correr (**R**), y un arma en cada mano. Luego Patada (**E**) en el 12, Garrote (**1** en Sigilo) en el 14, Amago (**F**) en el 16, Emboscada (**2** en Sigilo) y Disposición (pasivo) en el 18.
- 20: Premeditación (**Shift-C**, un talento): 2 puntos de combo en tu objetivo; úsalos en 20 segundos, o se pierden; reutilización de 2 minutos. Ruptura (**5**), y Venenos de una misión. Luego Esfumar (**X**) en el 22, Apuñalar (**Shift-3**) en el 24, Golpe fantasmal (**Shift-X**, un talento) en el 25: 40 de Energía, 1 punto de combo, un 15% más de esquivar durante 7 segundos; reutilización de 20 segundos. Golpe bajo (**V** en Sigilo) en el 26. Los niveles de talento de aquí son los más tempranos; una ventaja puede adelantarlos hasta 5 niveles.
- 30: Hemorragia (**3**, un talento; antes necesitas Espadas dentadas): 35 de Energía, 1 punto de combo, funciona de frente; durante 15 segundos tu Ruptura y tu Garrote hacen un 15% más de daño a ese enemigo. Preparación (**F3**, un talento): deja lista enseguida la reutilización de tus otros hechizos de Pícaro; su propia reutilización es de 10 minutos. Consigues uno de estos dos en el 30, el otro en el 31. Golpe a los riñones (**V**). Luego Ceguera (**Shift-V**) en el 34, Cuchillo de bota (un talento, pasivo) en el 35: Apuñalar puede dar 2 puntos de combo.
- 40: Marca de muerte (**Q**, un talento; antes necesitas Preparación): un remate, 25 de Energía, reutilización de 10 segundos. Durante 6 segundos guarda parte de tu daño (más por cada punto de combo), y luego lo hace de una vez, hasta un límite. El daño de Ruptura y de Garrote cuenta el doble. Luego Hacer picadillo rango 2 y Esfumar rango 2 en el 42, Apuñalar rango 2 en el 44, Marca de muerte rango 2 en el 48.
- 50: Golpe a los riñones rango 2, Marca de muerte rango 3 en el 56; nada nuevo para este rol.
- 60: Marca de muerte rango 4 y rangos más fuertes; nada nuevo para este rol.
**Errores de principiante:**
- Emboscada o Puñalada sin daga en tu mano principal, o de frente.
- Usar Premeditación y luego esperar. Los 2 puntos se pierden después de 20 segundos, y la reutilización es de 2 minutos.
- Marca de muerte sin puntos de combo. Es un remate.]] },
		},
		HUNTER = {
			{ band = 1, title = "Dominio de bestias: daño con tu mascota", body = [[
Desde el nivel 10 (tu mascota, de las misiones de clase). Tu mascota hace la mayor parte del trabajo: mantiene ocupado al enemigo mientras tú disparas desde lejos. La mayoría de las guías eligen Dominio de bestias para subir de nivel: dicen que es el más fácil y el más rápido. Wowhead añade que los tres árboles funcionan. Nuevo en Forever: Invocar halcón (un talento, como pronto en el 25) manda pájaros extra contra tu objetivo. Punto débil: grupos de enemigos. Tu mascota solo puede retener a uno.
**Orden sencillo:**
Antes de empezar: activa Aspecto del halcón (**Shift-R**). El talento Aspectos letales solo funciona entonces.
1. Marca del cazador (**Shift-Z**).
2. Primero entra la mascota (**Ctrl-1**); espera a que tenga al enemigo.
3. Aguijón de serpiente (**2**).
4. Invocar halcón (**Shift-F1**, desde el 25): mantén 2 halcones todo el rato.
5. Tiro de puntería (**4**, desde el 20) mientras estás quieto. Dos o más enemigos: Multidisparo (**Shift-1**) en su lugar. Comparten una reutilización.
6. Tiro automático (**1**) sigue disparando. Tiro Arcano (**3**): antes del 25, úsalo sin más. Desde el 25, solo cuando ya tienes 2 halcones: comparte una reutilización con Invocar halcón.
7. Mascota casi muerta: Sanar mascota (**F2**). Enemigo encima de ti: Intimidación (**Shift-3**, desde el 30) o Separación (**Z**, desde el 20). Separación no es un salto: hace que el enemigo tenga menos ganas de atacarte, de cerca, y detiene tu ataque automático. Apuro de verdad: Fingir muerte (**X**, desde el 30).
8. Enemigo duro: Ira de bestias (**F1**, desde el 40) junto con Fuego rápido (**Q**, desde el 26).
**Cada 10 niveles:**
- 10: tu mascota, de las misiones de clase. Aspecto del halcón (**Shift-R**). Primeros talentos: Aspectos letales, Entrenamiento en aguante. Los niveles de talento de aquí son los más tempranos; una ventaja puede adelantarlos hasta 5 niveles. Luego Sanar mascota (**F2**) en el 12, Multidisparo (**Shift-1**) en el 18.
- 20: Tiro de puntería (**4**, del instructor), Aspecto del guepardo (**R**), Separación (**Z**), Trampa congelante (**V**). Talentos: Rapidez de bestias (tu mascota corre un 30% más rápido; la necesitas para Intimidación), Furia desatada, Encontrar camino.
- 30: Intimidación (**Shift-3**, un talento): tu mascota aturde al enemigo durante 3 segundos con su siguiente golpe; reutilización de 1 minuto. Fingir muerte (**X**). Antes: Invocar halcón (**Shift-F1**, un talento) en el 25: un halcón se queda 18 segundos, como mucho 2 a la vez. Fuego rápido (**Q**) en el 26.
- 40: Ira de bestias (**F1**, un talento; los 30 puntos anteriores tienen que estar en Dominio de bestias): tu mascota hace un 50% más de daño durante 18 segundos; reutilización de 2 minutos. Lluvia (bloque D). Antes: Trampa explosiva ocupa **Shift-2** en el 34, Frenesí (un talento, pasivo) en el 35.
- 50: rangos más fuertes de Invocar halcón, Tiro de puntería y Sanar mascota; nada nuevo para este rol. Después del 40 las guías ponen tus puntos en Puntería.
- 60: otra vez rangos más fuertes; nada nuevo para este rol.
**Errores de principiante:**
- Disparar antes de que tu mascota tenga al enemigo. Entonces el enemigo viene hacia ti.
- Ver Invocar halcón y Tiro Arcano como dos botones separados. Comparten una reutilización: primero los halcones.
- Luchar con Aspecto del guepardo o Aspecto del mono. Aspectos letales solo funciona con el Halcón activo.]] },
			{ band = 2, title = "Puntería: daño a distancia", body = [[
Desde el nivel 1 (Tiro automático). Tus propios disparos hacen el trabajo, desde lejos. Tiro de puntería llega en el 20 del instructor: no es un talento. Disparo de francotirador es un talento, como pronto en el 40: 4 segundos de lanzamiento, con un alcance de hasta 45 metros. Las guías dicen que subir de nivel funciona, pero más lento que con Dominio de bestias: tu mascota retiene peor al enemigo, porque tú haces más daño. En grupo es fuerte: Aura de disparo certero ayuda a todo tu grupo o banda. Lobo solitario (un talento, como pronto en el 20) da un 20% más de daño mientras no tienes mascota; para subir de nivel, las guías se quedan con la mascota.
**Orden sencillo:**
Antes de empezar: activa Aspecto del halcón (**Shift-R**) y Aura de disparo certero (**Shift-X**, desde el 25).
1. Marca del cazador (**Shift-Z**). Con mascota: entra la mascota (**Ctrl-1**).
2. El enemigo sigue lejos: Disparo de francotirador (**Shift-4**, desde el 40) para abrir.
3. Aguijón de serpiente (**2**). Algunas guías se lo saltan en combates cortos.
4. Tiro de puntería (**4**, desde el 20) cada vez que esté listo. Quédate quieto.
5. Tiro Arcano (**3**) entre medias, si tu maná lo permite.
6. Tiro automático (**1**) sigue disparando.
7. Un grupo de enemigos: Multidisparo (**Shift-1**) en lugar de Tiro de puntería. Un grupo grande: Lluvia (bloque D, desde el 40).
8. Enemigo encima de ti: Disparo disperso (**E**, desde el 30), y luego apártate. Disparo de concusión (**Shift-Q**) lo ralentiza.
9. Enemigo duro: Fuego rápido (**Q**, desde el 26) al principio.
**Cada 10 niveles:**
- 10: tu mascota, de las misiones de clase. Aspecto del halcón (**Shift-R**). Primeros talentos: Ataques letales, Ojo de águila, Disparo de concusión mejorado; desde el 15: Afinar la puntería, Eficacia, Picaduras mejoradas. Los niveles de talento de aquí son los más tempranos; una ventaja puede adelantarlos hasta 5 niveles. Luego Multidisparo (**Shift-1**) en el 18.
- 20: Tiro de puntería (**4**), del instructor: 2 segundos de lanzamiento, reutilización de 6 segundos, compartida con Multidisparo. Talentos: Matanza rápida, Disparo Arcano mejorado, Lobo solitario. Aspecto del guepardo (**R**), Separación (**Z**), Trampa congelante (**V**).
- 30: Disparo disperso (**E**, un talento): el enemigo queda desorientado durante 4 segundos, y cualquier daño lo rompe; reutilización de 30 segundos. Fingir muerte (**X**). Antes: Aura de disparo certero (**Shift-X**, un talento) en el 25: más Poder de ataque a distancia para tu grupo, durante 30 minutos. Fuego rápido (**Q**) en el 26.
- 40: Disparo de francotirador (**Shift-4**, un talento; antes necesitas Aura de disparo certero): reutilización de 15 segundos, y tus 3 siguientes disparos llegan 10 metros más lejos. Lluvia (bloque D). Antes: Aura de disparo certero rango 2 en el instructor en el 32, Especialización en armas a distancia (un talento, pasivo) en el 35.
- 50: rangos más fuertes: Tiro de puntería en el 44 y el 52, Disparo de francotirador en el 48, Aura de disparo certero y Lluvia en el 50. Después del 40 las guías ponen tus puntos en Dominio de bestias.
- 60: otra vez rangos más fuertes; nada nuevo para este rol.
**Errores de principiante:**
- Moverte durante Tiro de puntería o Disparo de francotirador. Tienen 2 y 4 segundos de lanzamiento.
- Multidisparo contra un solo enemigo. Entonces Tiro de puntería tampoco está durante 6 segundos.
- Disparo de francotirador cuando el enemigo ya está encima de ti. Tiene 4 segundos de lanzamiento, y no funciona a menos de 8 metros.]] },
			{ band = 3, title = "Supervivencia: daño cuerpo a cuerpo, con trampas", body = [[
Desde el nivel 1 (Golpe de raptor), pero el juego de Supervivencia de verdad empieza hacia el 30. En Forever este es el Cazador cuerpo a cuerpo: Golpe de raptor, Mordedura de mangosta, Contraataque y Patada de zancudo, más trampas. Conservas tu mascota y tu arma a distancia: abre desde lejos, y luego acércate. Las guías dicen que es el más lento de los tres para subir de nivel; hasta más o menos el 30 juegas como cualquier Cazador (entra la mascota, dispara). Cuesta mucho maná, y un gran golpe tuyo puede quitarle el enemigo a tu mascota. Las guías no se ponen de acuerdo sobre qué arma cuerpo a cuerpo es la mejor.
**Orden sencillo:**
Antes de empezar: Aspecto del halcón (**Shift-R**) mientras disparas. Desde el 30, Aspecto de la bestia para luchar de cerca; no tiene tecla fija, así que ponlo en tu propia barra.
1. Marca del cazador (**Shift-Z**). Sin la Marca, Exponer presa no funciona.
2. Entra la mascota (**Ctrl-1**).
3. Aguijón de serpiente (**2**), y luego Tiro Arcano (**3**) mientras el enemigo viene, o mientras tú vas hacia él.
4. Una trampa a tus pies: Trampa de inmolación (**Shift-2**, desde el 16). Desde el 34 esa tecla es Trampa explosiva, y Trampa de inmolación no tiene tecla: ponla en tu propia barra si la quieres.
5. De cerca: Mordedura de mangosta (**Shift-C**, desde el 16) en cuanto se ilumine. Golpe de raptor (**5**) cada vez que esté listo. Patada de zancudo (desde el 30) cada vez que esté lista; ponla en tu propia barra. Las guías no coinciden: algunas se apartan para disparar después de Patada de zancudo, otras se quedan cerca.
6. Contraataque (**Shift-V**) justo después de parar un ataque.
7. El enemigo huye, o quieres distancia otra vez: Cortar alas (**Shift-F**).
8. En apuros: Disuasión (**C**, desde el 20), Fingir muerte (**X**, desde el 30).
**Cada 10 niveles:**
- 10: tu mascota, de las misiones de clase. Golpe de raptor (**5**) lo tienes desde el nivel 1. Primeros talentos: Rastreo mejorado, Desvío; desde el 15: Golpes salvajes, Sobrevividor, Atrapamiento, Cortar alas mejorado. Los niveles de talento de aquí son los más tempranos; una ventaja puede adelantarlos hasta 5 niveles. Luego Cortar alas (**Shift-F**) en el 12, Mordedura de mangosta (**Shift-C**) y Trampa de inmolación (**Shift-2**) en el 16.
- 20: Disuasión (**C**, un talento): un 25% más de esquivar y parar durante 10 segundos; reutilización de 5 minutos. Trampa congelante (**V**), Tiro de puntería (**4**), Doble empuñadura (pasivo, instructor). Separación (**Z**): no es un salto; baja tu **amenaza** (las ganas que tiene un enemigo de atacarte) de cerca, y detiene tu ataque automático. Talentos: Pies de plomo, Trampas inteligentes.
- 30: Patada de zancudo (un talento; sin tecla fija, ponla en tu propia barra): un 100% del daño del arma, y luego corres un 30% más rápido durante 3 segundos; reutilización de 8 segundos. Aspecto de la bestia (instructor; ponlo en tu propia barra): más Poder de ataque cuerpo a cuerpo. Fingir muerte (**X**). Antes: Contraataque (**Shift-V**, un talento), desde el 25 o el 30 (las fuentes no coinciden): se activa después de que paras un ataque, y deja al enemigo quieto en su sitio durante 5 segundos. Filo de depredador (un talento, pasivo) desde el 25. También en esta fila: Exponer presa, Ingenio, Disciplina de superviviente.
- 40: Golpes lacerantes (un talento, pasivo; antes necesitas Exponer presa): Mordedura de mangosta también hace sangrar al enemigo. Antes: Trampa explosiva ocupa **Shift-2** en el 34, Reflejos de relámpago (un talento, pasivo) en el 35.
- 50: rangos más fuertes: Contraataque en el 42 y el 54, Mordedura de mangosta en el 44, Trampa explosiva en el 44 y el 54, Golpe de raptor en el 48, Aspecto de la bestia en el 50. Las guías no se ponen de acuerdo sobre dónde van tus puntos después del 40.
- 60: otra vez rangos más fuertes; nada nuevo para este rol.
**Errores de principiante:**
- Entrar corriendo directamente. Abre desde lejos (Marca, mascota, Aguijón, un disparo), y luego acércate.
- Pulsar Mordedura de mangosta o Contraataque cuando no se iluminan. Mordedura de mangosta solo funciona después de esquivar (o mediante Exponer presa); Contraataque, solo después de parar.
- Quedarte en Aspecto del halcón de cerca después del nivel 30. El Halcón solo ayuda a tus disparos; la Bestia da Poder de ataque cuerpo a cuerpo.]] },
		},
		SHAMAN = {
			{ band = 1, title = "Elemental: daño a distancia", body = [[
Desde el nivel 1: Descarga de relámpagos la tienes desde el principio. Rayos y fuego desde lejos. Choque de llamas llega en el 10, Cadena de relámpagos en el 32. Maestría de Relámpago es un talento, como pronto en el 40. Las guías suben de nivel como Mejora: Elemental funciona, pero su coste de maná es muy alto, tienes que estar quieto para lanzar, y muchos enemigos a la vez son difíciles.
**Orden sencillo:**
Antes de empezar: activa Escudo de relámpagos (**Shift-Z**, desde el 8). Tótem abrasador (**5**, desde el 10) al suelo antes del pull.
1. Abre desde lejos con Descarga de relámpagos (**1**).
2. Choque de llamas (**2**, desde el 10) contra un enemigo que va a vivir mucho.
3. Descarga de relámpagos (**1**) como relleno.
4. Tres o más enemigos: Nova de Fuego (**Shift-4**, desde el 12) y Cadena de relámpagos (**Shift-1**, desde el 32) cuando estén listas.
5. Maestría de Relámpago (**Q**, desde el 40) contra un élite o un grupo grande.
6. Guarda Choque de tierra (**E**) para cuando el enemigo lance un hechizo: interrumpe el lanzamiento.
Poca salud: Onda de curación (**C**). Enemigo demasiado cerca: Tótem Nexo Terrestre (**V**) o Choque de Escarcha (**4**, desde el 20).
**Cada 10 niveles:**
- 10: Descarga de relámpagos (**1**), Choque de tierra (**E**, desde el 4), Escudo de relámpagos (**Shift-Z**, desde el 8). Choque de llamas (**2**), Tótem abrasador (**5**, de una misión). Primeros talentos: Convección, Concusión (pasivos). Los niveles de talento de aquí son los más tempranos; una ventaja puede adelantarlos hasta 5 niveles. Luego Nova de Fuego (**Shift-4**) y Purgar (**Shift-Q**) en el 12, Tótem de tremor (**Shift-F**) en el 18.
- 20: Choque de Escarcha (**4**), Lobo fantasmal (**R**), Llamada de los elementos (**Ctrl-1**). Enfoque elemental (un talento, pasivo). Luego Llamada totémica (**Shift-R**) en el 22. Vinculado a la tierra (un talento) en el 25: Tótem Nexo Terrestre (**V**) deja a los enemigos quietos en su sitio durante 5 segundos, solo en el momento en que lo colocas. Tótem de magma (bloque D) en el 26.
- 30: Llamada del trueno (un talento, pasivo). Tótem derribador (**X**), Llamada de los ancestros (**Ctrl-2**), Reencarnación (pasivo). Sobrecarga de relámpagos (un talento, pasivo). Luego Cadena de relámpagos (**Shift-1**) en el 32, Furia elemental (un talento, pasivo) en el 35.
- 40: Maestría de Relámpago (**Q**, un talento): durante 15 segundos Descarga de relámpagos se lanza 0,5 segundos más rápido y Cadena de relámpagos no tiene reutilización; reutilización de 3 minutos. Llamada de los espíritus (**Ctrl-3**), Curación en cadena (**Shift-2**). Armadura de mallas en el instructor.
- 50: rangos más fuertes de Descarga de relámpagos, Cadena de relámpagos, Choque de tierra, Choque de llamas, Nova de Fuego y Tótem abrasador; nada nuevo para este rol.
- 60: otra vez rangos más fuertes; nada nuevo para este rol.
**Errores de principiante:**
- Choque de tierra para hacer daño en grupo. Causa mucha **amenaza** (las ganas que tiene un enemigo de atacarte). Y comparte su reutilización con Choque de llamas: después no tienes interrupción.
- Cadena de relámpagos contra un solo enemigo. Cuesta mucho maná y tiene una reutilización de 6 segundos.
- Rematar a cada enemigo con un hechizo. El maná es tu límite: golpea con tu arma a un enemigo que está casi muerto.]] },
			{ band = 2, title = "Mejora: daño cuerpo a cuerpo", body = [[
Desde el nivel 1: golpeas con tu arma, con Arma comerrocas puesta. Las guías suben de nivel como Mejora: dicen que es la opción cómoda. Usa un arma lenta de dos manos. Golpe de tormenta es un talento, como pronto en el 25; Arma tótem Viento Furioso llega en el 30, del instructor. El maná es tu límite: cuando se acaba, deja de lanzar hechizos y sigue golpeando. El consejo de una guía para el buff de arma: Arma comerrocas en solitario, Arma lengua de Fuego en grupo, Arma tótem Viento Furioso desde el 30. En un grupo pequeño, Mejora puede tanquear un rato con Arma comerrocas (Armas de espíritu da entonces más amenaza), pero no hay provocación ni hechizo defensivo con reutilización.
**Orden sencillo:**
Antes de empezar: buff de arma puesto (bloque D), Escudo de relámpagos (**Shift-Z**), Tótem abrasador (**5**) o tus tótems al suelo.
1. Haz pull con Descarga de relámpagos (**1**). **Pull** = golpear a un enemigo desde lejos, para que venga hacia ti.
2. Golpe de tormenta (**3**, desde el 25) cada vez que esté listo.
3. Descarga de relámpagos (**1**) con 5 acumulaciones de Arma vorágine (desde el 35): entonces es instantánea y gratis.
4. Choque de tierra (**E**). En grupo, alterna con Choque de llamas (**2**).
5. Nova de Fuego (**Shift-4**, desde el 12) cuando tienes un tótem de Fuego colocado y maná de sobra; sobre todo contra más enemigos.
6. Ira del clarividente (**Q**, desde el 40) contra un élite o un pull grande.
7. Si no, sigue golpeando.
Después del combate: Onda de curación (**C**). Emergencia durante un combate: Onda inferior de curación (**F2**, desde el 20).
**Cada 10 niveles:**
- 10: Arma comerrocas (bloque D), Descarga de relámpagos (**1**), Choque de tierra (**E**, desde el 4), Escudo de relámpagos (**Shift-Z**, desde el 8). Choque de llamas (**2**), Tótem abrasador (**5**), Tótem Fuerza de la tierra (**Shift-X**), Arma lengua de Fuego (bloque D). Primeros talentos: Golpes de trueno y otros (pasivos); Maña mental (pasivo) desde el 15. Los niveles de talento de aquí son los más tempranos; una ventaja puede adelantarlos hasta 5 niveles. Luego Nova de Fuego (**Shift-4**) en el 12.
- 20: Lobo fantasmal (**R**), Choque de Escarcha (**4**), Onda inferior de curación (**F2**), Llamada de los elementos (**Ctrl-1**). Enfoque chamanístico (un talento, pasivo): los choques y Escudo de relámpagos cuestan un 45% menos de maná. Luego Golpe de tormenta (**3**, un talento) en el 25. Aluvión (un talento, pasivo) desde el 25. Lobo fantasmal mejorado (un talento) desde el 25: Lobo fantasmal es más rápido (instantáneo con los dos puntos) y también funciona en interiores; las guías lo eligen en niveles muy distintos. Tótem de magma (bloque D) en el 26.
- 30: Arma tótem Viento Furioso (bloque D). Golpe de tormenta mejorado y Armas de espíritu (talentos). Tótem derribador (**X**), Llamada de los ancestros (**Ctrl-2**). Luego Tótem Viento Furioso en el 32 (sin tecla: usa la barra de tótems), Cadena de relámpagos (**Shift-1**) en el 32, Arma vorágine (un talento, pasivo) en el 35.
- 40: Ira del clarividente (**Q**, un talento): golpeas un 30% más rápido durante 25 segundos; solo los golpes de tu arma, no tus hechizos. Reutilización de 3 minutos. No todas las guías lo eligen en el 40: algunas van primero a Recuperación por el maná. Llamada de los espíritus (**Ctrl-3**), armadura de mallas, un Arma tótem Viento Furioso más fuerte. Luego Tótem gracia del aire en el 42 (sin tecla: usa la barra de tótems).
- 50: rangos más fuertes de Arma tótem Viento Furioso, Arma comerrocas, Choque de tierra, Descarga de relámpagos y Tótem Fuerza de la tierra; nada nuevo para este rol.
- 60: otra vez rangos más fuertes; nada nuevo para este rol.
**Errores de principiante:**
- Descarga de relámpagos con menos de 5 acumulaciones de Arma vorágine. Reinicia el temporizador de tu golpe. Y Arma vorágine solo ayuda a Descarga de relámpagos: no a las curas, no a Cadena de relámpagos.
- Arma comerrocas en grupo mientras tú haces el daño, cuando ya tienes Armas de espíritu. Con Arma comerrocas generas un 30% más de amenaza; sin ella, un 30% menos. Usa Arma lengua de Fuego o Arma tótem Viento Furioso.
- Buscar una provocación. El Chamán no tiene. Tótem Garra de piedra (**F**) hace que los enemigos ataquen al tótem, no a ti.]] },
			{ band = 3, title = "Recuperación: sanador", body = [[
Desde el nivel 1: Onda de curación la tienes desde el principio, y es tu cura principal mientras subes de nivel. Las guías no aconsejan subir de nivel en solitario como Recuperación (los enemigos mueren despacio), pero es bueno en grupo. Entre mazmorras haces misiones con Descarga de relámpagos y Choque de llamas. Mareas vivas es un talento, como pronto en el 40. Un Chamán puede quitar Veneno y Enfermedad, pero no maldiciones ni magia.
**Orden sencillo (en grupo):**
Antes de empezar: Escudo de agua (**Shift-Z**, desde el 20). Tótems al suelo: Llamada de los elementos (**Ctrl-1**, desde el 20) o Tótem Corriente de sanación (**F4**, desde el 20).
1. Mareas vivas (**Shift-F1**, desde el 40) en el tanque o en quien reciba daño.
2. Curación en cadena (**Shift-2**, desde el 40) en ese mismo objetivo cuando hay más gente herida.
3. Onda de curación (**C**) para una persona o para el tanque.
4. Onda inferior de curación (**F2**, desde el 20) cuando tiene que ser rápido.
5. Emergencia: Rapidez de la Naturaleza (**Shift-3**, desde el 30), y luego Onda de curación (**C**).
6. Tótem de marea de maná (**F1**, desde el 25) cuando se te acaba el maná.
7. Nadie herido: Descarga de relámpagos (**1**).
**Cada 10 niveles:**
- 10: Onda de curación (**C**). Primeros talentos: Onda de curación mejorada (una Onda de curación más rápida), Enfoque de las mareas (pasivo). Los niveles de talento de aquí son los más tempranos; una ventaja puede adelantarlos hasta 5 niveles. Luego Espíritu ancestral (**F3**, fuera de combate) en el 12, Curar veneno (**Shift-C**) en el 16, Tótem de tremor (**Shift-F**) en el 18.
- 20: Onda inferior de curación (**F2**), Tótem Corriente de sanación (**F4**, de una misión), Llamada de los elementos (**Ctrl-1**), Lobo fantasmal (**R**). Escudo de agua (**Shift-Z**, un talento): 3 esferas de agua; cuando te golpean o uno de tus hechizos es crítico, recuperas un 2% de tu maná por esfera. Dura 10 minutos. A partir de entonces Shift-Z lanza Escudo de agua, no Escudo de relámpagos. Luego Curar enfermedad (**Shift-V**) en el 22. Tótem de marea de maná (**F1**, un talento) en el 25: devuelve maná a tu grupo; reutilización de 5 minutos. Tótem Fuente de maná en el 26 (sin tecla: usa la barra de tótems).
- 30: Rapidez de la Naturaleza (**Shift-3**, un talento): tu siguiente hechizo de Naturaleza con menos de 10 segundos de lanzamiento es instantáneo; reutilización de 3 minutos. Forma curativa (un talento, pasivo). Tótem derribador (**X**), Llamada de los ancestros (**Ctrl-2**), Reencarnación (pasivo). Luego Purificación (un talento, pasivo) en el 35, un Tótem de marea de maná más fuerte en el 38.
- 40: Curación en cadena (**Shift-2**). Mareas vivas (**Shift-F1**, un talento; antes necesitas Forma curativa): una cura durante 15 segundos, no una cura instantánea, y una Curación en cadena que lanzas directamente sobre ese objetivo cura un 25% más; reutilización de 12 segundos. Llamada de los espíritus (**Ctrl-3**), armadura de mallas.
- 50: rangos más fuertes de Mareas vivas, Curación en cadena, Onda de curación, Onda inferior de curación, Tótem de marea de maná y Tótem Corriente de sanación; nada nuevo para este rol.
- 60: otra vez rangos más fuertes; nada nuevo para este rol.
**Errores de principiante:**
- Curación en cadena sobre alguien que no es tu objetivo de Mareas vivas. La ventaja solo cuenta cuando la lanzas directamente sobre ese objetivo.
- Pulsar solo Rapidez de la Naturaleza. No cura nada por sí sola: hace instantáneo tu siguiente hechizo de Naturaleza. Pulsa Onda de curación justo después.
- Intentar quitar una maldición. Un Chamán no puede; solo Veneno (**Shift-C**) y Enfermedad (**Shift-V**).]] },
		},
		WARLOCK = {
			{ band = 1, title = "Aflicción: daño con el tiempo", body = [[
Desde el nivel 4 (Corrupción) y el 8 (Terror de agonía). Pones DoTs sobre el enemigo y dejas que tu demonio lo retenga. La mayoría de las guías suben de nivel como Aflicción. Succionar vida es un talento, como pronto en el 30. Arruinar es un talento, como pronto en el 40: mientras lo canalizas, tu Succionar vida, tu Corrupción y tu Terror de agonía en ese enemigo hacen sus tics un 100% más rápido. Arruinar no te cura.
**Orden sencillo:**
1. Manda a tu demonio al ataque (**Ctrl-1**).
2. Terror de agonía (**5**) para hacer pull. Su daño empieza bajo, así que tu demonio se queda con el enemigo.
3. Corrupción (**2**). Con Corrupción mejorado 5/5 es instantánea (como pronto en el 14).
4. Succionar vida (**F4**, desde el 30), solo contra un enemigo que va a vivir mucho.
5. Inmolar (**3**) solo contra un enemigo duro.
6. Enemigo duro: añade tu maldición (**Shift-V**). Las guías no coinciden en lo pronto.
7. Relleno: hasta más o menos el nivel 30, tu varita (Disparar; no está en el bloque, ponla en tu propia barra), y luego Drenar vida (**C**). Las guías no coinciden del todo en cuándo cambiar.
8. ¿Se ilumina Trance de las Sombras (Ocaso, desde el 25)? Descarga de las Sombras (**1**): entonces es instantánea.
9. Desde el 40: Arruinar (bloque D) en lugar de Drenar vida cuando tu salud está bien. Pon antes tus DoTs.
10. ¿Más salud que maná? Transfusión de vida (**F**).
11. ¿Necesitas un Fragmento de alma? Remata al enemigo con Drenar alma (**4**).
Dos enemigos: DoTs en el primero, Miedo (**V**) sobre él, y luego lucha contra el segundo. El daño puede romper el Miedo, y las guías no coinciden en poner DoTs antes del Miedo.
**Cada 10 niveles:**
- 10: Drenar alma (**4**), Crear piedra de salud (bloque D), el Abisario (misión). Ya tienes Descarga de las Sombras (**1**), Inmolar (**3**), Corrupción (**2**, 4), Maldición de debilidad (**Shift-V**, 4), Transfusión de vida (**F**, 6), Terror de agonía (**5**, 8) y Miedo (**V**, 8). Primer talento: Corrupción mejorado o Supresión (las guías no coinciden). Los niveles de talento de aquí son los más tempranos; una ventaja puede adelantarlos hasta 5 niveles. Luego Cauce de salud (**F2**) en el 12; Drenar vida (**C**) y Corrupción rango 2 (15 segundos) en el 14; Drenajes mejorados y Cosecha de almas (talentos, pasivos) desde el 15; Dolor abrasador (bloque D) y Crear piedra de alma en el 18.
- 20: Amplificar maldición (**Shift-3**, un talento): tu siguiente Maldición de debilidad o Terror de agonía es un 50% más fuerte; reutilización de 3 minutos. Maldición de los Elementos (**Shift-V**), Armadura demoníaca (**Shift-Z**), Lluvia de Fuego (**Shift-1**), el Súcubo o el Íncubo (misión). Luego Corrupción rango 3 (18 segundos) y Drenar maná en el 24. Maldición de agotamiento (**R**, un talento; antes necesitas Amplificar maldición) en el 25: el enemigo va un 30% más lento durante 12 segundos. Ocaso (un talento, pasivo) en el 25: una pequeña probabilidad de que tu siguiente Descarga de las Sombras sea instantánea. Desterrar (**Shift-Q**) en el 28.
- 30: Succionar vida (**F4**, un talento): pasa salud del enemigo a ti, durante 30 segundos. Sifón de alma (un talento, pasivo): Drenar vida, Drenar alma y Arruinar hacen más por cada Corrupción, Succionar vida y Terror de agonía tuyo sobre el enemigo. Drenar vida rango 3, Piroinferno (**Shift-2**), el Manáfago (misión). Luego Custodia de las Sombras (**Z**) en el 32, Maestría de las Sombras (un talento, pasivo) en el 35, Succionar vida rango 2 y Drenar vida rango 4 en el 38.
- 40: Arruinar (bloque D, un talento; antes necesitas Succionar vida): una canalización de 6 segundos que hace daño cada segundo y hace que tus DoTs en ese enemigo hagan sus tics un 100% más rápido. Aullido de terror (**Shift-F**), el Corcel nefasto (misión). Luego Espiral mortal (**X**) en el 42, Fuego de alma (**Q**) y Succionar vida rango 3 en el 48.
- 50: Inferno (**F3**). Maldición de los Elementos rango 4. Por lo demás, rangos más fuertes.
- 60: Terror de fatalidad (**F1**): un gran golpe después de 60 segundos; no sobre jugadores. Por lo demás, rangos más fuertes.
**Errores de principiante:**
- Volver a poner Terror de agonía demasiado pronto. Sus tics más fuertes llegan al final.
- Usar Arruinar cuando necesitas salud. Arruinar no cura; Drenar vida sí.
- Maldición de Temeridad sobre el enemigo al que quieres dar Miedo. Ese enemigo ignora el Miedo.]] },
			{ band = 2, title = "Demonología: daño con tu demonio", body = [[
Desde el nivel 1 (el Diablillo); de verdad desde el 10 (el Abisario). Tu demonio hace gran parte del trabajo, y los talentos lo hacen más fuerte. Las guías no coinciden en cuándo entrar en este árbol: algunas entran desde el 10, otras suben primero como Aflicción y cambian hacia el 26 o el 27. Sacrificio demoníaco (como pronto en el 20) solo compensa con Pacto demoníaco (como pronto en el 40). Antes, cualquier demonio que invoques quita el buff.
**Orden sencillo:**
1. Manda a tu demonio al ataque (**Ctrl-1**), y deja que golpee primero.
2. Desde el 30: activa Vínculo de alma (**Shift-X**), y otra vez después de cada invocación.
3. Desde el 25 (Marca demoníaca): Dolor abrasador (bloque D) sobre el enemigo de tu demonio. Otra vez cuando la marca desaparece (10 segundos). Antes de Marca demoníaca: nada de Dolor abrasador.
4. Terror de agonía (**5**) y Corrupción (**2**) contra enemigos que viven lo bastante. Aquí Corrupción tiene 2 segundos de lanzamiento.
5. Relleno: tu varita (no está en el bloque, ponla en tu propia barra) o Descarga de las Sombras (**1**). Drenar vida (**C**) cuando necesitas salud.
6. Demonio casi muerto: Cauce de salud (**F2**). Cuesta tu propia salud.
7. Transfusión de vida (**F**). Con Energías demoníacas tu demonio también recibe maná.
8. Desde el 40 (Pacto demoníaco): Sacrificio demoníaco (**Shift-C**) sobre un demonio, y luego invoca uno distinto (bloque D). El buff dura 2 horas. Las guías no coinciden en qué demonio sacrificar.
9. Desde el 48, con Exterminio: ¿enemigo por debajo del 35% de salud? Descarga de las Sombras o Dolor abrasador, y luego Fuego de alma (**Q**): más rápido, y sin Fragmento de alma.
**Cada 10 niveles:**
- 10: el Abisario (misión; cuesta 1 Fragmento de alma). Su Tormento da **amenaza** (las ganas que tiene un enemigo de atacarlo). Drenar alma (**4**) para conseguir fragmentos. Primeros talentos: Poder profano, Abrazo demoníaco, Diablillo mejorado, Cauce de salud mejorado (pasivos). Los niveles de talento de aquí son los más tempranos; una ventaja puede adelantarlos hasta 5 niveles. Luego Cauce de salud (**F2**) en el 12; Energías demoníacas, Vitalidad vil y Abisario mejorado (talentos, pasivos) desde el 15; Sacrificio (Abisario) en el 16; Consumir sombras (Abisario) y Dolor abrasador (bloque D) en el 18.
- 20: Sacrificio demoníaco (**Shift-C**, un talento): sacrificas a tu demonio a cambio de un buff de 2 horas. Diablillo: un 15% más de daño de sombras. Súcubo o Íncubo: un 15% más de daño de fuego. Abisario: recuperas maná. Manáfago: recuperas salud. Maestro invocador (un talento, pasivo): las invocaciones son más rápidas y más baratas. El Súcubo o el Íncubo (misión). Armadura demoníaca (**Shift-Z**). Luego Sufrimiento (Abisario) en el 24. Dominio de lo maldito (**Shift-F1**, un talento; antes necesitas Maestro invocador) en el 25: tu siguiente invocación es 5,5 segundos más rápida y un 50% más barata. Marca demoníaca y Exterminio (talentos, pasivos) desde el 25.
- 30: Vínculo de alma (**Shift-X**, un talento; antes necesitas Sacrificio demoníaco): un 30% del daño que recibes va a tu demonio, y los dos hacen un 3% más de daño. Dura mientras tu demonio esté ahí. El Manáfago (misión; Bloqueo de hechizo en el 36). Conocimiento demoníaco (un talento, pasivo). Luego Maestro demonogista (un talento, pasivo) desde el 35.
- 40: Pacto demoníaco (un talento, pasivo; antes necesitas Vínculo de alma): el buff de Sacrificio demoníaco se queda cuando invocas un demonio distinto. Solo ahora compensa Sacrificio demoníaco. Aullido de terror (**Shift-F**), el Corcel nefasto (misión). Luego Espiral mortal (**X**) en el 42, Fuego de alma (**Q**) en el 48.
- 50: Inferno (**F3**): un infernal; 1 Piedra infernal cada vez; reutilización de 1 hora. Por lo demás, rangos más fuertes.
- 60: Terror de fatalidad (**F1**). Por lo demás, rangos más fuertes.
**Errores de principiante:**
- Dolor abrasador antes de tener Marca demoníaca. Causa mucha amenaza y le quita el enemigo a tu demonio.
- Sacrificio demoníaco antes de Pacto demoníaco (40). Tu demonio desaparece, e invocar cualquier demonio quita el buff.
- Después de Pacto demoníaco, invocar el mismo demonio que sacrificaste. Entonces el buff desaparece.]] },
			{ band = 3, title = "Destrucción: daño con grandes golpes", body = [[
Desde el nivel 1 (Descarga de las Sombras e Inmolar). Grandes golpes de fuego y de sombras, y es el que más maná cuesta. Algunas guías desaconsejan subir de nivel con él (mucho maná, poco para recuperarlo); otras dicen que se puede jugar, y una dice que es fuerte en mazmorras. Conflagrar es un talento, como pronto en el 25; Incinerar es un talento, como pronto en el 40. El punto de cambio es Sombras y llamas 5/5 (como pronto en el 39): a partir de entonces Conflagrar ya no se come tu Inmolar, y Quemadura de las Sombras siempre te devuelve su Fragmento de alma.
**Orden sencillo:**
1. Manda a tu demonio al ataque (**Ctrl-1**).
2. Inmolar (**3**). Una guía abre con Descarga de las Sombras desde lejos, con Inmolar justo después.
3. Enemigo duro: Terror de agonía (**5**) y tu maldición (**Shift-V**).
4. Desde el 25: Conflagrar (bloque D). Antes de Sombras y llamas 5/5 se come tu Inmolar: úsalo al final de Inmolar, o como último golpe. Después: cada vez que esté listo.
5. Relleno: Descarga de las Sombras (**1**). Desde el 40, Incinerar (bloque D), con Inmolar sobre el enemigo.
6. Desde el 20: Quemadura de las Sombras (**Shift-4**) como último golpe. Así recuperas el Fragmento de alma.
7. Transfusión de vida (**F**) entre combates. Poco maná: tu varita (no está en el bloque, ponla en tu propia barra).
8. Más enemigos: desde el 30, Terror de caos (bloque D) sobre un enemigo duro, y luego ataca a los demás. Lluvia de Fuego (**Shift-1**). Piroinferno (**Shift-2**, desde el 30) solo con salud suficiente.
**Cada 10 niveles:**
- 10: Descarga de las Sombras (**1**) e Inmolar (**3**; rango 2 en el 10). Primer talento: Aterrar (lanzamientos más rápidos) o Descarga de Sombras mejorada. Los niveles de talento de aquí son los más tempranos; una ventaja puede adelantarlos hasta 5 niveles. Luego Descarga de las Sombras rango 3 en el 12 (2,8 segundos de lanzamiento); Secuelas y Cataclismo (talentos, pasivos) desde el 15; Dolor abrasador (bloque D) en el 18.
- 20: Quemadura de las Sombras (**Shift-4**, un talento): un golpe de sombras instantáneo; cuesta 1 Fragmento de alma; reutilización de 15 segundos. Si el enemigo (uno que da PE) muere en 8 segundos, recuperas un fragmento. Ruina (un talento, pasivo): tus críticos de Destrucción golpean más fuerte. Lluvia de Fuego (**Shift-1**). Descarga de las Sombras rango 4 (3 segundos de lanzamiento). Luego Quemadura de las Sombras rango 2 en el 24. Conflagrar (bloque D, un talento) en el 25: un golpe de fuego instantáneo contra un enemigo con tu Inmolar; ese Inmolar desaparece entonces; reutilización de 10 segundos. Llamas agonizantes e Intensidad (talentos, pasivos) desde el 25.
- 30: Terror de caos (bloque D, un talento): 5 minutos sobre un enemigo; un 15% de todo tu daño contra otros enemigos también golpea a este. Solo un enemigo a la vez. Fuego y azufre (antes necesitas Conflagrar) y Piroclasma (antes necesitas Intensidad), talentos, pasivos. Piroinferno (**Shift-2**). Luego Conflagrar rango 2 y Quemadura de las Sombras rango 3 en el 32; Sombras y llamas (un talento, pasivo) desde el 35, 5/5 como pronto en el 39.
- 40: Incinerar (bloque D, un talento; antes necesitas Terror de caos): 2,5 segundos de lanzamiento, un 25% más de daño cuando el enemigo tiene tu Inmolar. Conflagrar rango 3, Quemadura de las Sombras rango 4. Luego Fuego de alma (**Q**) en el 48.
- 50: Incinerar rango 2. Inferno (**F3**).
- 60: Incinerar rango 3, Conflagrar rango 6. Terror de fatalidad (**F1**).
**Errores de principiante:**
- Conflagrar justo después de Inmolar. Se come tu Inmolar (hasta Sombras y llamas 5/5).
- Quemadura de las Sombras sin Fragmento de alma, o contra un enemigo que va a vivir mucho. El fragmento solo vuelve si el enemigo muere en 8 segundos.
- Terror de caos y Terror de agonía sobre el mismo enemigo. Solo cabe un terror.]] },
		},
		PALADIN = {
			{ band = 1, title = "Sagrado: sanador", body = [[
Desde el nivel 1: Luz Sagrada la tienes desde el principio. Un **sanador** mantiene vivo al grupo. Las guías dicen que Sagrado es el árbol más lento para subir de nivel en solitario: sube de nivel como Reprensión y cura en mazmorras, o juega como Sagrado con un amigo. Los botones propios del árbol llegan en el 20 (Favor divino), el 25 (Juramento de luz), el 30 (Choque Sagrado) y el 40 (Vigilia de la Luz).
**Orden sencillo (en grupo):**
Antes del pull: Bendición de Sabiduría (**Shift-V**, desde el 14) sobre ti, Bendición de los Reyes (**Shift-X**, desde el 20) sobre los demás. Aura: Aura de devoción (**Ctrl-1**), o Aura de concentración (**Ctrl-3**, desde el 22) cuando a los lanzadores los golpean mucho.
1. Juramento de luz (**Shift-R**, desde el 25) en el tanque. Dura 1 hora, y solo un jugador puede tenerlo.
2. Destello de Luz (**F2**, desde el 20) es tu cura normal. Antes del 20: Luz Sagrada (**C**).
3. Luz Sagrada (**C**) para un golpe grande. Desde el 25 (Infusión de Luz) se lanza más rápido justo después de un crítico de Choque Sagrado o de Destello de Luz. **Crítico** = un golpe o una cura de suerte, más fuerte.
4. Choque Sagrado (**F4**, desde el 30) cuando no hay tiempo para lanzar, o mientras te mueves.
5. Todo el grupo herido, desde el 40: Vigilia de la Luz (**Shift-F1**) sobre un jugador, y luego Choque Sagrado (**F4**) sobre ese mismo jugador.
6. Favor divino (**Shift-3**, desde el 20) antes de una cura que tiene que ser grande.
7. Un efecto malo sobre un amigo: Purificar, más tarde Purgación (**Shift-C**).
8. Emergencia: Imposición de manos (**Q**). Gasta todo el maná que te queda.
Nada que curar: tu sello (**3**), Sentencia (**2**) y Golpe Sagrado (**1**) de cerca. En solitario: juega como un Paladín de Reprensión; desde el 30, Choque Sagrado (**F4**) contra el enemigo es tu único botón de daño fuerte.
**Cada 10 niveles:**
- 10: ya tienes Luz Sagrada (**C**), Aura de devoción (**Ctrl-1**), Bendición del poderío (**Shift-Z**), Protección divina (**Z**), Martillo de justicia (**E**) y Purificar (**Shift-C**). Nuevo en el 10: Imposición de manos (**Q**), Bendición de Protección (**Shift-F**). Primer talento: Enfoque espiritual (pasivo). Los niveles de talento de aquí son los más tempranos; una ventaja puede adelantarlos hasta 5 niveles. Luego Redención (**F3**, de una misión) en el 12, Bendición de Sabiduría (**Shift-V**) en el 14, Reverencia y Luz curativa (talentos, pasivos) desde el 15, Bendición de Libertad (**R**) en el 18.
- 20: Destello de Luz (**F2**), Bendición de los Reyes (**Shift-X**). Favor divino (**Shift-3**, un talento): tu siguiente Destello de Luz, Luz Sagrada o Choque Sagrado es crítico seguro; reutilización de 2 minutos. Iluminación (un talento, pasivo; antes necesitas Reverencia). Luego Aura de concentración (**Ctrl-3**) en el 22. Juramento de luz (**Shift-R**, un talento) e Infusión de Luz (un talento, pasivo) en el 25.
- 30: Choque Sagrado (**F4**, un talento): instantáneo, daño a un enemigo o cura a un amigo; reutilización de 10 segundos. Intervención divina (**F3** en combate: mueres tú). Sello de luz (bloque D). Luego Escudo divino (**Z**) en el 34, Poder Sagrado (un talento, pasivo) en el 35, Sello de sabiduría (bloque D) en el 38.
- 40: Vigilia de la Luz (**Shift-F1**, un talento; antes necesitas Choque Sagrado): sobre un amigo durante 30 segundos; tu siguiente Choque Sagrado sobre ese amigo no tiene reutilización y también cura a su grupo. Choque Sagrado rango 2. Peto de malla: puedes llevar armadura de placas. Luego Purgación (**Shift-C**) en el 42, Bendición de Sacrificio (bloque D) en el 46, Choque Sagrado rango 3 en el 48.
- 50: Vigilia de la Luz rango 2, Imposición de manos rango 3. Luego Bendición superior de poderío en el 52 y Bendición superior de sabiduría en el 54, Choque Sagrado rango 4 en el 56.
- 60: Bendición superior de reyes, Vigilia de la Luz rango 3; nada nuevo para este rol.
**Errores de principiante:**
- Luz Sagrada para cada golpe pequeño. Destello de Luz (**F2**, desde el 20) es la cura normal barata.
- Vigilia de la Luz sobre un jugador y Choque Sagrado sobre otro. La cura de grupo solo llega con Choque Sagrado sobre el MISMO jugador.
- Pulsar F3 en combate sin querer. Entonces lanza Intervención divina, y mueres tú. Fuera de combate, F3 es Redención.]] },
			{ band = 2, title = "Protección: tanque", body = [[
Desde el nivel 10 (Furia justa y Sello de furia en el instructor). El **tanque** es al que golpean los enemigos, para que el resto del grupo esté a salvo. **Amenaza** = las ganas que tiene un enemigo de atacarte. Llevas un arma de una mano y un escudo. Las guías no se ponen de acuerdo sobre lo bien que sube de nivel Protección en solitario. Los botones del árbol: Baluarte de templario en el 20, Juicio presto en el 25, Escudo Sagrado en el 30.
**Orden sencillo:**
1. Antes del pull: activa Furia justa (sin tecla fija: está en el bloque D, o ponla en tu propia barra; dura 30 minutos). Sello de furia (**F**), una bendición, un aura. Las guías no coinciden en el aura: Aura de devoción (**Ctrl-1**) o Aura de castigo (**Ctrl-2**).
2. Desde el 30: Escudo Sagrado (**Shift-4**) justo antes de que lleguen los enemigos. Púlsalo otra vez cada vez que esté listo.
3. Sentencia (**2**) en el primer enemigo. Con Sello de furia puesto, Sentencia es tu provocación (3 segundos). **Provocación** = hacer que el enemigo te ataque a ti.
4. Dos o más enemigos, desde el 20: Consagración (**Shift-1**) debajo de ellos. Solo los 4 primeros reciben el daño extra.
5. Golpe Sagrado (**1**) cada vez que esté listo.
6. Un enemigo corre hacia otra persona: Sentencia (**2**). ¿No está lista? Desde el 25: Juicio presto (**F1**), una segunda Sentencia con su propia reutilización de 1 minuto.
7. Un enemigo lanza un hechizo: Martillo de justicia (**E**). El Paladín no tiene interrupción.
8. Exorcismo (**5**, desde el 20) contra No-muertos y Demonios. Martillo de cólera (**4**, desde el 44).
9. Llega mucho daño, desde el 20: Baluarte de templario (**X**). Último recurso: Imposición de manos (**Q**).
Poco maná: deja primero Consagración. Desde el 40 (Juramento de escudo): primero Escudo Sagrado, luego Golpe Sagrado. Si no eres el tanque (en solitario, o tanquea otro): usa tu sello en **3**, no Sello de furia.
**Cada 10 niveles:**
- 10: Furia justa (bloque D) y Sello de furia (**F**). Ya tienes Sentencia (**2**), Golpe Sagrado (**1**), Martillo de justicia (**E**), Aura de devoción (**Ctrl-1**) y Protección divina (**Z**). También nuevo: Imposición de manos (**Q**), Bendición de Protección (**Shift-F**). Primer talento: Baluarte (pasivo). Los niveles de talento de aquí son los más tempranos; una ventaja puede adelantarlos hasta 5 niveles. Luego Precisión, Favor del Guardián o Deber sagrado (talentos, pasivos) desde el 15, Aura de castigo (**Ctrl-2**) en el 16.
- 20: Baluarte de templario (**X**, un talento): un escudo que absorbe tanto daño como tu salud máxima, durante 8 segundos; reutilización de 5 minutos. Consagración (**Shift-1**), Bendición de los Reyes (**Shift-X**), Exorcismo (**5**). Especialización en escudos (un talento, pasivo; antes necesitas Baluarte). Luego Juicio presto (**F1**, un talento; antes necesitas Baluarte de templario) y Furia justa mejorada (un talento, pasivo) en el 25.
- 30: Escudo Sagrado (**Shift-4**, un talento; necesitas un escudo): un 30% más de probabilidad de bloquear durante 10 segundos, 4 cargas; reutilización de 10 segundos. La hora de la verdad (un talento, pasivo). Luego Escudo divino (**Z**) en el 34, Credo férreo (un talento, pasivo) en el 35.
- 40: Juramento de escudo (un talento, pasivo; antes necesitas Escudo Sagrado): Golpe Sagrado cada 6 segundos, y funciona con Escudo Sagrado. Peto de malla: puedes llevar armadura de placas. Escudo Sagrado rango 2. Luego Martillo de cólera (**4**) en el 44, Bendición de Sacrificio (bloque D) en el 46.
- 50: Escudo Sagrado rango 3, Cólera sagrada (bloque D); rangos más fuertes de Sello de furia y Consagración.
- 60: Escudo Sagrado rango 4 y rangos más fuertes; nada nuevo para este rol.
**Errores de principiante:**
- Olvidar Furia justa. Sin ella generas mucha menos amenaza. Compruébala antes de cada pull; dura 30 minutos.
- Sello de furia puesto cuando no eres el tanque. Entonces cada Sentencia provoca.
- Sin escudo. Escudo Sagrado no funciona sin uno, y Sello de furia no da absorción.]] },
			{ band = 3, title = "Reprensión: daño cuerpo a cuerpo", body = [[
Desde el nivel 1 (Sello de rectitud); Sentencia llega en el 4, Golpe Sagrado en el 6. Las guías dicen que Reprensión es el árbol más rápido para subir de nivel en solitario, con un arma lenta de dos manos. La misión de clase del 20 te da una. Los botones del árbol: Sello de orden en el 20, Arrepentimiento en el 30.
**Orden sencillo:**
1. Antes del combate: Bendición del poderío (**Shift-Z**) hasta el 20, luego Bendición de los Reyes (**Shift-X**).
2. Aura: Aura de devoción (**Ctrl-1**); Aura de castigo (**Ctrl-2**, desde el 16) contra varios enemigos.
3. Ponte el sello (**3**): Sello de rectitud, hasta que conozcas Sello de orden (desde el 20). Entonces la tecla 3 lanza Sello de orden.
4. Sentencia (**2**) cada vez que esté lista. No gasta el sello.
5. Golpe Sagrado (**1**) cada vez que esté listo.
6. No-muerto o Demonio, desde el 20: Exorcismo (**5**).
7. Dos o más enemigos, desde el 20: Consagración (**Shift-1**). No contra un solo enemigo: cuesta demasiado maná.
8. Desde el 44: Martillo de cólera (**4**) cuando el enemigo tiene un 20% de salud o menos.
9. Enemigo fuerte: Martillo de justicia (**E**), y luego Sentencia (**2**). Con Sello de orden, Sentencia hace el doble de daño contra un enemigo aturdido.
10. Un segundo humanoide, desde el 30: Arrepentimiento (**V**), y no lo golpees.
11. Vuelve a ponerte el sello cuando se acabe (30 segundos). Poca salud: Luz Sagrada (**C**) entre combates.
**Cada 10 niveles:**
- 10: ya tienes Sello de rectitud (**3**), Sentencia (**2**), Golpe Sagrado (**1**), Bendición del poderío (**Shift-Z**) y Martillo de justicia (**E**). Nuevo en el 10: Imposición de manos (**Q**). Primer talento: Oración (la mayoría de las guías) o Desvío (una guía), los dos pasivos. Los niveles de talento de aquí son los más tempranos; una ventaja puede adelantarlos hasta 5 niveles. Luego Sentencia mejorada, Convicción o Sentencia santificada (talentos, pasivos) desde el 15, Aura de castigo (**Ctrl-2**) en el 16.
- 20: Sello de orden (**3**, un talento): a veces tus golpes hacen un golpe sagrado extra. A partir de entonces la tecla 3 lo lanza en lugar de Sello de rectitud. Consagración (**Shift-1**), Exorcismo (**5**), Bendición de los Reyes (**Shift-X**), Destello de Luz (**F2**). Búsqueda de justicia (un talento, pasivo: te mueves un 15% más rápido con 2/2). La misión de clase para un arma de dos manos. Luego Enjuiciador Sagrado y Especialización en armas de dos manos (talentos, pasivos) en el 25.
- 30: Arrepentimiento (**V**, un talento): saca del combate a un humanoide durante hasta 6 segundos; cualquier daño lo despierta; reutilización de 1 minuto. Venganza (un talento, pasivo; antes necesitas Sello de orden): después de un crítico haces más daño durante 30 segundos; se acumula 5 veces. Sello de orden rango 2. Luego Escudo divino (**Z**) en el 34, Campeón de la Luz (un talento, pasivo) en el 35.
- 40: Cólera desellada (un talento, pasivo; antes necesitas Arrepentimiento): tus golpes guardan copias de tu sello, y un golpe con un sello distinto las usa. Peto de malla: puedes llevar armadura de placas. La misión del caballo de combate. Luego Martillo de cólera (**4**) en el 44.
- 50: Sello de orden rango 4, Cólera sagrada (bloque D), Martillo de cólera rango 2 en el 52; nada nuevo para este rol.
- 60: Sello de orden rango 5 y rangos más fuertes; la misión del cargador (Alianza); nada nuevo para este rol.
**Errores de principiante:**
- Volver a ponerte el sello después de cada Sentencia. Sentencia no lo gasta; un sello dura 30 segundos.
- Sello de orden con un arma rápida. Quiere un arma lenta de dos manos.
- Consagración contra un solo enemigo. Cuesta demasiado maná para eso.]] },
		},
	},
}
