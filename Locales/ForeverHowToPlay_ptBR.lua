local _, ns = ...
-- Brazilian Portuguese "How you play" for WoW Forever (translated 7 Nov 2026 from Modules/ForeverHowToPlay.lua by mh-writer;
-- game names measured in docs/forever/CLIENT_NAMES_FOREVER_2026-11-07.md). Same sections, same order.
if not ns.IS_FOREVER then
	return
end
if GetLocale() ~= "ptBR" then
	return
end
ns.FOREVER_HOWTOPLAY_L = ns.FOREVER_HOWTOPLAY_L or {}
ns.FOREVER_HOWTOPLAY_L.ptBR = {
	COMMON = {
		{ "Antes de começar", [[
- As teclas supõem que o bloco de teclas do MH está colocado: /mh block, depois as etapas 1 e 2.
- **Graus dos feitiços.** A maioria dos feitiços vem em graus: Grau 1, Grau 2, e assim por diante. Um grau mais alto é o mesmo feitiço, só que mais forte. Você compra graus novos com o treinador da sua classe conforme sobe de nível. Você não precisa trocar nada: as teclas do MH lançam um feitiço pelo nome, e o jogo usa o grau mais alto que você conhece.
- **Uma tecla ainda vazia** guarda o lugar dela. Ela se preenche quando você aprende o feitiço. Se um feitiço novo não aparecer, abra o bloco de teclas (/mh block) e aperte **Atualizar (feitiços novos)**.
- **Feitiços de talento** também ganham uma tecla. Se você nunca escolher esse talento, a tecla fica vazia. Tudo bem.
- **Mana** é a barra azul embaixo da sua vida. A maioria dos feitiços custa mana. Quando ela acaba, você não pode lançar feitiços.
- **Tempo de recarga** = a espera antes de você poder apertar um feitiço de novo.
- Teclas fixas, iguais para toda classe: **T** = poção, **Shift-T** = Pedra de Vida, **G** = Berloque.]] },
	},
	DRUID = {
		{ "O que ele faz", [[
O Druida pode mudar de forma. Como conjurador normal, ele lança feitiços e cura. Depois ele pode virar urso ou felino, para lutar de perto. O urso tem uma provocação (Rosnar), então é a forma para tanquear.
Uma **forma** é cada um desses corpos. Numa forma, muitas das suas teclas fazem outra coisa. As teclas do MH trocam sozinhas: a mesma tecla é um feitiço como conjurador e outro feitiço como urso.]] },
		{ "Níveis 1-10: seus botões", [[
- **1** = Ira (nível 1): seu principal feitiço de ataque.
- **2** = Fogo Lunar (4): dano, e depois mais dano ao longo de alguns segundos.
- **C** = Toque de Cura (1): sua cura grande.
- **F4** = Rejuvenescer (4): uma cura que cura você aos poucos.
- **Shift-X** = Marca do Indomado (1): um buff. Um **buff** é um efeito bom em você ou num amigo. Coloque antes de uma luta.
- **Shift-Z** = Espinhos (6): outro buff.
- **V** = Raízes Enredantes (8): prende um inimigo no lugar.
- **X** = Enredamento (10).
- **Shift-E** = o feitiço da sua raça (Fusão Sombria para um Elfo Noturno, Pisada de Guerra para um Tauren).
- **Nível 10, Forma de Urso** (de uma missão): **Ctrl-1** transforma você em urso. Como urso: **1** = Malho, **F** = Rosnar, **Shift-2** = Rugido Desmoralizante.]] },
		{ "Ordem simples (conjurador)", [[
Primeiro Fogo Lunar (2), depois Ira (1) até o inimigo morrer. Pouca vida? Rejuvenescer (F4) ou Toque de Cura (C).]] },
		{ "O que vem depois", [[
- 12: Recrescimento no F2 (cura rápida). Reviver no F3: traz um amigo morto de volta, só fora de combate.
- 16: Forma Aquática no R enquanto você nada. 18: Fogo Feérico no 5 (funciona em toda forma), Hibernar no Shift-Q.
- 20: Forma de Felino (de uma missão) no Ctrl-2, com Garra, Rasgar e Espreitar. Fogo Estelar no 3. Em combate, o F3 vira Renascimento.
- 30: Forma de Viagem no R (para se deslocar), Tranquilidade no Q. 40: Forma de Urso Hediondo (substitui a Forma de Urso no Ctrl-1), Avivar no F1.
- 44: Pele de Árvore no Z, em toda forma.]] },
		{ "Erros de iniciante", [[
- Apertar uma cura enquanto está numa forma. Suas curas só funcionam na sua forma normal, não na Forma de Urso, Forma de Felino, Forma Aquática ou Forma de Viagem. Saia da forma primeiro: aperte de novo a mesma tecla da forma (Ctrl-1 para o urso, Ctrl-2 para o felino).
- Na Forma de Luniscante (um talento, no mínimo nível 40) seus feitiços de ataque funcionam, mas suas curas não.
- O que funciona numa forma: poções, Pele de Árvore, Enredamento, Fogo Feérico e o feitiço da sua raça.]] },
	},
	PALADIN = {
		{ "O que ele faz", [[
O Paladino é um lutador sagrado. Ele bate de perto, cura a si mesmo e aos outros, e protege os amigos. Ele não tem formas nem posturas, então cada tecla sempre faz a mesma coisa.
Um **selo** é um poder sagrado que você coloca em si mesmo. Dura 30 segundos, e você só pode ter um por vez. Uma **aura** é um poder que você liga e deixa ligado; ela ajuda o seu grupo inteiro. Uma **bênção** é um buff que você coloca em si mesmo ou num amigo; dura 60 minutos. Um **buff** é um efeito bom.]] },
		{ "Selos e auras", [[
- **Selo da Retidão** (1): cada golpe causa dano sagrado extra. Uma arma lenta causa mais por golpe.
- **Selo do Cruzado** (6, numa tecla Alt sua): você ataca mais rápido, mas cada golpe causa menos.
- **Selo da Fúria** (10): o selo de tanque. Com um escudo, cada golpe também lhe dá um pequeno escudo.
- **Selo de Comando** (talento, no mínimo nível 20): às vezes os golpes dão um grande golpe sagrado extra. Quando você o tiver, a tecla 3 lança este em vez do Selo da Retidão.
- **Selo da Justiça** (22), **Selo da Luz** (30), **Selo da Sabedoria** (38), todos em teclas Alt suas: às vezes os golpes atordoam, curam você ou lhe dão mana.
- **Aura de Devoção** (1): mais armadura para o seu grupo. **Aura da Retribuição** (16): dano sagrado em tudo que bate no seu grupo. **Aura de Concentração** (22): os conjuradores do seu grupo são menos interrompidos quando levam golpes.]] },
		{ "Níveis 1-10: seus botões", [[
- **3** = Selo da Retidão (nível 1): seu selo.
- **C** = Luz Sagrada (1): sua cura grande. Um Paladino Morto-vivo ganha ela na missão de nível 2 "Redescobrindo a Luz".
- **Ctrl-1** = Aura de Devoção (1, do treinador): ligue e deixe ligada.
- **2** = Julgamento (4): recarga de 10 segundos. Não gasta o seu selo.
- **Shift-Z** = Bênção do Poder (4): coloque em você mesmo.
- **1** = Golpe Sagrado (6): seu golpe principal, de perto.
- **Z** = Proteção Divina (6): por 6 segundos nada pode ferir você, mas você também não pode atacar. Recarga de 5 minutos.
- **E** = Martelo da Justiça (8): atordoa o inimigo. Um **atordoamento** quer dizer que o inimigo não pode se mover nem lançar feitiços por alguns segundos. O Paladino não tem uma interrupção de verdade, então esta é a sua tecla de "pare esse feitiço".
- **Shift-C** = Purificar (8): remove um efeito ruim de um amigo.
- **Q** = Impor as Mãos (10): seu botão de emergência. Cura um amigo (ou você) até a vida cheia, mas gasta toda a mana que ainda resta. Recarga de 20 minutos.
- **Shift-F** = Bênção de Proteção (10): salva um amigo em apuros.
- **F** = Selo da Fúria (10): um selo para tanquear. O Julgamento dele provoca. **Provocar** = fazer o inimigo atacar você.]] },
		{ "Ordem simples", [[
Selo (3) antes da luta. Depois Golpe Sagrado (1) e Julgamento (2) sempre que estiverem prontos. Coloque o selo de novo quando ele acabar (dura 30 segundos). Pouca vida? Luz Sagrada (C).]] },
		{ "O que vem depois", [[
- 12: Redenção no F3 (traz um amigo morto de volta; não em combate). 14: Bênção de Sabedoria no Shift-V.
- 18: Bênção da Liberdade no R (nada pode deixar você lento por um tempo). 20: Consagração no Shift-1 (atinge vários inimigos de uma vez), Exorcismo no 5, Clarão de Luz no F2 (cura rápida), Bênção dos Reis no Shift-X.
- 30: Intervenção Divina: em combate, o F3 lança esta em vez de Redenção. 34: Escudo Divino no Z: 10 segundos em que nada pode ferir você, e você ainda pode lutar (com metade do dano).
- 42: Purificação substitui Purificar no Shift-C. 44: Martelo da Ira no 4 (só quando o inimigo está com 20% de vida ou menos).
- 52-60: num grupo, as teclas de bênção lançam a Bênção Maior para o grupo inteiro; sozinho, elas lançam a normal.]] },
		{ "Erros de iniciante", [[
- Apertar Exorcismo (5) num inimigo normal. Só funciona em inimigos Morto-vivo e Demônio. Esconjurar Morto-vivo (Shift-Q, 24) só funciona em Morto-vivo.
- Apertar Martelo da Ira (4) no começo da luta. Só funciona quando o inimigo está quase morto (20% de vida ou menos).
- Escudo Divino e Proteção Divina compartilham um tempo de recarga, então ficam numa tecla só (Z). Esses feitiços de proteção, e a Bênção de Proteção, dão **Abstinência**: por 1 minuto você não pode receber nenhum deles de novo. Impor as Mãos não dá.]] },
	},
	MAGE = {
		{ "O que ele faz", [[
O Mago fica atrás e lança magia de fogo, de gelo e arcana. Ele mantém os inimigos longe com feitiços que os prendem no lugar ou os deixam lentos. O Mago não tem formas nem posturas, então cada tecla sempre faz a mesma coisa.]] },
		{ "Níveis 1-10: seus botões", [[
- **1** = Bola de Fogo (nível 1): seu principal feitiço de ataque.
- **Shift-Z** = Armadura Gélida (1): um buff em você mesmo. Coloque antes de uma luta. Você só pode ter uma armadura ativa.
- **Shift-X** = Inteligência Arcana (1; a partir do Grau 2: Intelecto Arcano): um buff para você ou um amigo.
- **Ctrl-3** = Atirar: sua **varinha** (um pequeno bastão mágico que atira sozinho), assim que você tiver uma. Útil quando a sua mana está baixa. Quando você aprende Seta de Fogofrio, ela fica com o Ctrl-3; coloque Atirar numa tecla Alt sua se ainda quiser.
- **2** = Seta de Gelo (4): dano de gelo.
- **5** = Impacto de Fogo (6): golpe de fogo instantâneo. **Instantâneo** = sem tempo de conjuração. Recarga de 8 segundos.
- **3** = Mísseis Arcanos (8): dano arcano.
- **Shift-Q** = Polimorfia (8): tira um inimigo da luta por um tempo. Esse tipo de feitiço se chama **CC** (controle de grupo).
- **V** = Nova Congelante (10): congela todo inimigo a até 10 jardas ao seu redor, por até 8 segundos. Dano pode quebrar o efeito. Recarga de 25 segundos.
- Conjurar Água (4) e Conjurar Comida (6) não estão no bloco. Elas vão em teclas Alt suas (bloco D).]] },
		{ "Ordem simples", [[
Seta de Gelo (2) ou Bola de Fogo (1) enquanto o inimigo vem. Impacto de Fogo (5) quando estiver pronto. Inimigo perto de você? Nova Congelante (V), afaste-se, continue lançando.]] },
		{ "O que vem depois", [[
- 12: Queda Lenta no Shift-R. 14: Explosão Arcana no Shift-2 (atinge vários inimigos). 16: Golpe Flamejante no Shift-4.
- 18: Remover Maldição Inferior no Shift-V. 20: Lampejo no R (seu feitiço de movimento), Nevasca no Shift-1, Evocação no F1 (recupera mana), Escudo de Mana no Z, Proteção contra Fogo no F4. Também os teleportes (e depois os portais): feitiços de viagem, fora do bloco. Coloque-os numa barra sua, ou use-os pelo Grimório.
- 22: Calcinar no Ctrl-1, Proteção contra Gelo no F2. 24: Contrafeitiço no E: sua **interrupção** (ela para o feitiço de um inimigo).
- 26: Cone de Frio no Shift-F. 30: Armadura de Gelo: a partir daí o Shift-Z lança esta em vez de Armadura Gélida (ela também protege você contra gelo).
- Talentos a partir do nível 20: Ignimpacto no 4, Lança de Gelo no F, Impacto Arcano no Ctrl-2, Bloco de Gelo no C (no mínimo 25).]] },
		{ "Erros de iniciante", [[
- Esperar as duas proteções ao mesmo tempo. Proteção contra Fogo (F4) e Proteção contra Gelo (F2) compartilham um tempo de recarga de 30 segundos, então só uma por vez.
- Usar Armadura de Mago e Armadura de Gelo juntas. Só uma armadura pode estar ativa por vez. Armadura de Mago (34) está no bloco D.]] },
	},
	HUNTER = {
		{ "O que ele faz", [[
O Caçador atira de longe com uma arma de longo alcance, e a partir do nível 10 tem um **ajudante**: um animal que você doma e que luta ao seu lado. De perto ele tem alguns golpes corpo a corpo.
**Tiro Automático** = sua arma continua atirando sozinha até você parar. **Corpo a corpo** = lutar de perto. O Caçador não tem formas nem posturas, então cada tecla sempre faz a mesma coisa.]] },
		{ "Níveis 1-10: seus botões", [[
- **1** = Tiro Automático (nível 1): começa a atirar. A tecla do MH é feita para que um segundo toque não pare o tiro.
- **5** = Golpe do Raptor (1): seu golpe quando o inimigo está do seu lado.
- **2** = Picada de Serpente (4): dano ao longo de alguns segundos.
- Aspecto do Macaco (4) vai numa tecla Alt sua (bloco D). Um **aspecto** é um buff em você mesmo, parecido com uma postura. Só um aspecto pode estar ativo por vez.
- **3** = Tiro Arcano (6): tiro instantâneo. Recarga de 6 segundos.
- **Shift-Z** = Marca do Caçador (6): coloque no inimigo uma vez.
- **Shift-Q** = Tiro de Concussão (8): deixa o inimigo lento.
- **Shift-R** = Aspecto do Falcão (10): seu aspecto principal.
- **Nível 10, missões do ajudante:** você aprende Domar Fera, Chamar Ajudante e Reviver Ajudante. **F4** = Chamar Ajudante (traz seu ajudante), **F3** = Reviver Ajudante (traz um ajudante morto de volta). Domar Fera não tem tecla; você usa fora de combate.
- A partir daí seu ajudante tem três teclas: **Ctrl-1** = atacar seu alvo, **Ctrl-2** = seguir você, **Ctrl-3** = ficar onde está.]] },
		{ "Ordem simples", [[
Aspecto do Falcão ligado (Shift-R). Ajudante na frente (Ctrl-1). Marca do Caçador (Shift-Z), Picada de Serpente (2), Tiro Automático (1), depois Tiro Arcano (3) quando estiver pronto. Inimigo do seu lado? Golpe do Raptor (5).]] },
		{ "O que vem depois", [[
- 10: Alimentar Ajudante e Dispensar Ajudante não estão no bloco (você usa fora de combate); coloque-os numa barra sua. O mesmo vale para Assustar Fera (14).
- 12: Tiro Distrativo no F (faz o inimigo atacar você), Curar Ajudante no F2 (cura seu ajudante), Cortar Asas no Shift-F.
- 16: Armadilha Imolante no Shift-2, Mordida de Mangusto no Shift-C (só depois de você se esquivar). 18: Tiro Múltiplo no Shift-1.
- 20: Tiro Certo no 4 (seu tiro grande), Aspecto do Guepardo no R (correr rápido), Desvencilhar no Z, Armadilha Congelante no V.
- 26: Tiro Rápido no Q. 30: Fingir de Morto no X, Aspecto da Fera (bloco D). 34: Armadilha Explosiva assume o Shift-2.
- As quatro armadilhas compartilham um tempo de recarga de 30 segundos.]] },
		{ "Erros de iniciante", [[
- Atirar num inimigo bem do seu lado. Sua arma de fogo ou arco não funciona a menos de 8 jardas (a "zona morta"): use Golpe do Raptor (5), ou dê um passo para trás.
- Esperar que uma tecla atire de longe e bata de perto. Uma macro não enxerga distância, então o corpo a corpo tem teclas próprias (5, Shift-F, Shift-C).
- Apertar Curar Ajudante (F2) para se curar. Só cura seu ajudante. O Caçador não tem cura própria.]] },
	},
	WARRIOR = {
		{ "O que ele faz", [[
O Guerreiro luta de perto com uma arma. Ele tem três posturas, e a partir do nível 10 pode tanquear. Ele não se cura, a não ser com Ímpeto da Vitória (nível 20).
O Guerreiro tem **Raiva** em vez de mana. Você ganha Raiva quando bate e quando apanha. Fora de combate, sua Raiva cai devagar até 0.]] },
		{ "Posturas", [[
Uma **postura** é um jeito de lutar que você liga com uma tecla. Você está sempre numa postura. Alguns feitiços só funcionam em uma ou duas posturas. As teclas do MH trocam sozinhas: em outra postura, a mesma tecla lança outro feitiço. Se uma tecla não tem nada para a sua postura, ela não faz nada (sem erro).
- **Postura de Batalha** (1): sua postura para lutar normalmente.
- **Postura de Defesa** (10, de uma missão): a postura para tanquear. Só nela você tem Provocar.
- **Postura de Berserker** (30, da missão "A contenda"). Nela o E vira Murro e o R vira Interceptar.
- **Proficiência Tática** (14, passiva, você não faz nada): você guarda até 10 de Raiva ao trocar de postura.
- Nenhuma tecla troca sua postura sozinha. Você escolhe a postura; as teclas acompanham.]] },
		{ "Níveis 1-10: seus botões", [[
- **1** = Golpe Heroico (nível 1): seu golpe principal, em toda postura.
- **Ctrl-1** = Postura de Batalha (1): ligue e deixe ligada.
- **Shift-X** = Brado de Batalha (1): um buff. Um **buff** é um efeito bom em você ou num amigo. Coloque antes de uma luta.
- **R** = Investida (4): corre até um inimigo para começar uma luta. Só funciona na Postura de Batalha, e não quando você já está lutando.
- **Shift-Z** = Dilacerar (4): um **sangramento**: dano ao longo de alguns segundos. Postura de Batalha e Postura de Defesa.
- **Shift-1** = Trovoada (6): atinge vários inimigos de uma vez. Postura de Batalha e Postura de Defesa. Recarga de 6 segundos.
- **V** = Cortar Tendão (8): deixa o inimigo bem lento por 15 segundos. Postura de Batalha e Postura de Berserker.
- **F1** = Fúria Sanguinária (10): dá Raiva na hora e mais um pouco ao longo de alguns segundos. Custa um pouco de vida. Recarga de 1 minuto.
- **Nível 10, Postura de Defesa** (de uma missão): **Ctrl-2** liga essa postura. A mesma missão dá **5** = Fender Armadura (toda postura) e, na Postura de Defesa, **F** = Provocar. **Provocar** = fazer o inimigo atacar você. Recarga de 8 segundos.
- Disparar Arco, Disparar Pistola, Disparar Besta e Lançar vão em teclas Alt suas (bloco D). Você recebe o que combina com sua arma de longo alcance. Use para **puxar**: acertar um inimigo de longe, para ele vir até você.]] },
		{ "Ordem simples", [[
Postura de Batalha ligada (Ctrl-1), Brado de Batalha (Shift-X). Investida (R) para entrar. Dilacerar (Shift-Z), depois Golpe Heroico (1) de novo e de novo. Vários inimigos? Trovoada (Shift-1).]] },
		{ "O que vem depois", [[
- 12: Subjugar no 2 (Postura de Batalha; depois que o inimigo se esquiva), Trombada com Escudo no E: sua **interrupção** (ela para o feitiço de um inimigo).
- 14: Revanche no 2 (Postura de Defesa), Brado Desmoralizador no Shift-2. 16: Golpe Zombeteiro no F (Postura de Batalha), Levantar Escudo no Z (Postura de Defesa). 18: Desarmar no V (Postura de Defesa).
- 20: Cutilada no Shift-4, Batida no Shift-C, Ímpeto da Vitória no F2 (só nos 20 segundos depois de você matar um inimigo que dá EXP; cura você um pouco; recarga de 30 segundos), Retaliação no C (Postura de Batalha). 22: Brado Intimidador no Shift-Q. 24: Executar no 4 (Postura de Batalha e Postura de Berserker; só quando o inimigo está com 20% de vida ou menos).
- 26: Brado Desafiador no Shift-F. 28: Muralha de Escudos no C (Postura de Defesa).
- 30: Postura de Berserker no Ctrl-3. Nela: Interceptar no R, Raiva Incontrolada no Shift-V. 36: Redemoinho no 2 (Berserker). 38: Murro no E (Berserker). 50: Temeridade no Q (Berserker).
- Talentos: Último Recurso no X e Uivo Perfurante no Shift-R (lentidão em área), no mínimo 20. Golpe Lanceador no F3 (Postura de Batalha) e Golpes Imprudentes no Shift-F1, 25. Golpes a Esmo no Q (Postura de Batalha), Desejo de Matar no Shift-3, Pancada de Concussão no Shift-V (um atordoamento; na Postura de Berserker esta tecla é Raiva Incontrolada), 30. Golpe Mortal, Sede de Sangue ou Escudada no 3, 40.]] },
		{ "Erros de iniciante", [[
- Apertar uma tecla na postura errada. Provocar só funciona na Postura de Defesa, Subjugar só na Postura de Batalha. Na postura errada a tecla não faz nada. Olhe sua postura primeiro.
- Investida na Postura de Defesa. Lá ela só funciona com o talento **Vanguarda**. Sem ele, você recebe um erro vermelho.
- Investida em combate. Investida só começa uma luta; quando você já está lutando, ela não funciona.
- Trovoada (Shift-1) não funciona na Postura de Berserker.
- Trombada com Escudo, Levantar Escudo e Escudada sem escudo. Os três precisam de um escudo na mão secundária.
- Esperar que Batida seja rápida. No Forever ela tem 1,5 segundo de conjuração e recarga de 15 segundos.
- Retaliação e Muralha de Escudos estão ambas no C, cada uma com sua própria recarga de 15 minutos. Guarde para quando estiver em apuros de verdade.]] },
	},
	ROGUE = {
		{ "O que ele faz", [[
O Ladino luta de perto com golpes rápidos. Ele pode chegar perto dos inimigos sem ser visto, e tem muitos jeitos de parar um inimigo por um momento.
O Ladino tem **Energia** em vez de mana. A Energia enche sozinha, rápido: uma barra vazia fica cheia de novo em uns 10 segundos.]] },
		{ "Furtividade e finalizadores", [[
**Furtividade** (nível 1, Shift-R) deixa você difícil de ver. Você anda com metade da velocidade. Alguns ataques só funcionam a partir da Furtividade: eles são seus **abridores**, o primeiro golpe de uma luta. Na Furtividade, as teclas do MH trocam sozinhas:
- **1** vira Garrote (14), **2** vira Emboscar (18), **V** vira Golpe Baixo (26), **Shift-Q** vira Aturdir (10), **F** vira Bater Carteira (4).
- Antes de você conhecer o feitiço Furtividade, a tecla só mantém o feitiço normal dela.
Golpes como Golpe Sinistro dão **Pontos de Combo** (até 5). Um **finalizador** é um golpe que gasta todos os seus Pontos de Combo: Eviscerar (4), Retalhar (Shift-4) e Ruptura (5). Mais pontos deixam ele mais forte.]] },
		{ "Níveis 1-10: seus botões", [[
- **1** = Golpe Sinistro (nível 1): seu golpe principal.
- **4** = Eviscerar (1): seu finalizador principal.
- **Shift-R** = Furtividade (1): andar escondido. Aperte de novo para sair da Furtividade. Depois de sair da Furtividade, você não pode voltar a ela por 10 segundos.
- **Shift-2** = Lançar (1): um arremesso de longe. Você precisa de uma arma de arremesso (como facas de arremesso) no espaço de longo alcance. Com arma de fogo, arco ou besta equipado, a tecla atira com ele em vez disso.
- **2** = Punhalada pelas Costas (4): um golpe forte. Você precisa de uma adaga, e tem que estar atrás do inimigo.
- **F** = Bater Carteira (4): só na Furtividade. Rouba do inimigo.
- **Shift-Q** = Esfaquear (6): para um inimigo por um momento. Qualquer dano quebra o efeito. Esse tipo de feitiço se chama **CC** (controle de grupo).
- **Z** = Evasão (8): você se esquiva de muito mais ataques por 15 segundos. Recarga de 5 minutos.
- **Shift-4** = Retalhar (10): seu segundo finalizador.
- **R** = Disparada (10): correr rápido.
- **Shift-Q** = Aturdir (10): só na Furtividade. Tira um inimigo Humanoide da luta por um tempo, antes de a luta começar. Não funciona em inimigos Fera nem em inimigos que já estão lutando. Dano quebra o efeito. Aturdir não quebra sua Furtividade.
- **F4** = a cura ao longo do tempo da sua raça, se ela tiver uma: Canibalizar (Morto-vivo; só perto de um cadáver Humanoide ou Morto-vivo), Regeneração Rápida (Troll; para quando você se move, age ou leva dano), Ler Meridiano (Celonato da Alta Ordem).
- **Shift-E** = o feitiço da sua raça (por exemplo Fusão Sombria para um Elfo Noturno, Fúria Sangrenta para um Orc).]] },
		{ "Ordem simples", [[
Furtividade (Shift-R) e vá até o inimigo. Golpe Sinistro (1) algumas vezes, depois Eviscerar (4). Com uma adaga e atrás do inimigo: Punhalada pelas Costas (2). A partir do nível 10: mantenha Retalhar (Shift-4) ativo.]] },
		{ "O que vem depois", [[
- 12: Chute no E: sua **interrupção** (ela para o feitiço de um inimigo). 14: Expor Armadura no Shift-Z, Garrote no 1 na Furtividade.
- 16: Finta no F (fora da Furtividade). Ela diminui sua **ameaça**: o quanto o inimigo quer atacar você. Abrir Fechadura (bloco D).
- 18: Emboscar no 2 na Furtividade (adaga, por trás). 20: Ruptura no 5. Venenos (de uma missão; veja abaixo).
- 22: Distração no Shift-F, Sumir no X (sua fuga; cada uso custa um Pó de Clarão, um item nas suas bolsas). 24: Estocar no Shift-3 (um golpe com a arma da mão secundária, então você precisa de uma arma em cada mão; recarga de 10 segundos; devolve 15 de Energia).
- 26: Golpe Baixo no V na Furtividade: um **atordoamento** (o inimigo não pode se mover nem agir por alguns segundos). 30: Golpe no Rim no V fora da Furtividade. Desarmar Armadilha (bloco D). 34: Cegar no Shift-V (custa um Pó Cegante).
- Talentos: Ripostar no Shift-F1 e Premeditação no Shift-C, no mínimo 20. Sangue Frio no F1 e Golpe Fantasmagórico no Shift-X, 25. Rajada de Lâminas no Shift-1 (atinge mais inimigos), Preparação no F3 (zera o tempo de recarga dos seus outros feitiços de Ladino, como Evasão, Disparada e Sumir), Hemorragia no 3, 30. Mutilar no 3, Adrenalina ou Marca da Morte no Q, 40.]] },
		{ "Erros de iniciante", [[
- Apertar um abridor fora da Furtividade. Garrote, Emboscar, Golpe Baixo, Aturdir e Bater Carteira precisam de Furtividade. Fora da Furtividade, a mesma tecla lança o feitiço normal dela.
- Apertar Furtividade de novo sem querer. Isso encerra a Furtividade, e você não pode voltar a ela por 10 segundos.
- Elfo Noturno: Fusão Sombria é o feitiço da sua raça, não a Furtividade da sua classe. Para os seus abridores, use Furtividade (Shift-R).
- Punhalada pelas Costas e Emboscar pela frente, ou sem adaga. Os dois precisam de uma adaga, e você tem que estar atrás do inimigo.
- Bater num inimigo que você tirou da luta com Esfaquear ou Aturdir. Qualquer dano acorda ele.
- Aturdir num inimigo Fera ou num inimigo que já está lutando. Aturdir só funciona em Humanoide, antes da luta.
- Sumir ou Cegar sem pó nas bolsas. Sumir precisa de um Pó de Clarão, Cegar precisa de um Pó Cegante.
- Procurar venenos no bloco. **Venenos** são itens que você faz (você aprende Venenos numa missão por volta do nível 20). Você os coloca na arma. Arraste-os você mesmo para teclas Alt suas (bloco D).
- Golpe Fantasmagórico (talento): depois dele, seu próximo Emboscar ou Garrote funciona sem Furtividade, se você usar dentro de 7 segundos. As teclas do MH não enxergam isso, então fora da Furtividade as teclas 1 e 2 ainda lançam Golpe Sinistro e Punhalada pelas Costas.]] },
	},
	PRIEST = {
		{ "O que ele faz", [[
O Sacerdote cura, e ataca de longe com magia sagrada e de sombra. Ele protege os amigos com um escudo. Depois ele pode escolher **Forma de Sombra** (um talento, no mínimo nível 40): mais dano de sombra, mas nada de cura.
O Sacerdote não tem posturas. Forma de Sombra não muda as teclas: cada tecla sempre faz a mesma coisa.]] },
		{ "Os feitiços da sua raça", [[
Cada raça de Sacerdote tem dois feitiços de Sacerdote próprios: um no nível 10 e um no nível 20. O MH coloca eles no **X** e no **Shift-R**, então toda raça usa as mesmas duas teclas.
- Anão: Prece Desesperada (10, X; recarga de 10 minutos), Castigar (20, Shift-R).
- Humano: Graça Divina (10, Shift-R; uma cura instantânea num amigo abaixo de metade da vida, não em você; recarga de 10 minutos), Ciclo Elétrico (20, X).
- Elfo Noturno: Fragmentos Estelares (10, Shift-R; recarga de 30 segundos), A graça de Eluna (20, X).
- Morto-vivo: Toque de Fraqueza (10, X), Sacrifício Sombrio (20, Shift-R; troque sua própria vida por mana).
- Troll: Bagata da Fraqueza (10, Shift-R), Guarda Sombrio (20, X).
- Gnomo: Clarão Desconcertante (10, Shift-R), Plano de Contingência (20, X; uma proteção num amigo que cura ele e lhe dá um escudo quando a vida dele fica baixa).]] },
		{ "Níveis 1-10: seus botões", [[
- **1** = Punição (nível 1): seu principal feitiço de ataque.
- **C** = Cura Inferior (1): sua cura principal. Depois Cura (16) e Cura Maior (40) assumem esta tecla.
- **5** = Atirar (1): sua **varinha** (um pequeno bastão mágico que atira sozinho). Você precisa ter uma varinha nas mãos.
- **Shift-X** = Palavra de Poder: Fortitude (1): um buff. Um **buff** é um efeito bom em você ou num amigo. Coloque antes de uma luta.
- **2** = Palavra Sombria: Dor (4): dano de sombra.
- **Z** = Palavra de Poder: Escudo (6): um escudo em você ou num amigo. Recarga de 4 segundos, mas a mesma pessoa só pode receber um novo escudo depois de 15 segundos.
- **F** = Desvanecer (8): os inimigos querem atacar você menos por um tempo. Recarga de 30 segundos.
- **F4** = Renovar (8): uma cura que cura aos poucos.
- **3** = Impacto Mental (10): dano de sombra. Recarga de 8 segundos.
- **F3** = Ressurreição (10): traz um amigo morto de volta. Só fora de combate.
- Seu feitiço de raça do nível 10 está no **X** ou no **Shift-R** (veja a lista acima).
- **Shift-E** = a habilidade da sua raça (por exemplo Forma de Pedra para um Anão, Fusão Sombria para um Elfo Noturno).]] },
		{ "Ordem simples", [[
Escudo (Z) em você mesmo. Palavra Sombria: Dor (2), Impacto Mental (3), depois Punição (1). Pouca mana? Use sua varinha (5). Pouca vida? Renovar (F4) ou Cura Inferior (C).]] },
		{ "O que vem depois", [[
- 12: Fogo Interior no Shift-Z. 14: Curar Doença no Shift-C, Grito Psíquico no V (alguns inimigos ao seu redor fogem de medo por até 8 segundos; dano pode acabar com isso; recarga de 30 segundos).
- 18: Dissipar Magia no Shift-V. 20: Cura Célere no F2 (cura rápida), Fogo Sagrado no 4, Agrilhoar Morto-vivo no Shift-Q, Peste Devoradora no Shift-3, seu feitiço de raça do nível 20, Proteção contra Medo (bloco D).
- 30: Prece de Cura no Shift-2 (cura seu grupo), Controle Mental no Shift-F. 32: Palavra Sombria: Morte no Shift-4, Abolir Doença assume o Shift-C. 34: Levitar no R (custa uma Pluma). 48: Prece da Fortitude assume o Shift-X (custa uma Vela Sagrada).
- Talentos: Açoite Mental (assume a tecla 1), Nova Sagrada no Shift-1 e Concentração Interior no F1, no mínimo 20. Abraço Vampírico no Ctrl-3, 25. Penitência no Shift-F1 e Silêncio no E (sua **interrupção**: ela para o feitiço de um inimigo), 30. Infusão de Poder no Q, Forma de Sombra no Ctrl-1, Prece da Recomposição no Ctrl-2, 40.]] },
		{ "Erros de iniciante", [[
- Curar na Forma de Sombra. Nenhum feitiço de cura funciona na Forma de Sombra. Proteção contra Medo e os feitiços de raça do Anão e do Gnomo (Castigar, Clarão Desconcertante) também não funcionam nela. Saia dela primeiro: aperte Ctrl-1 de novo.
- Sentir falta da Punição depois de pegar Açoite Mental. Quando você conhece Açoite Mental, a tecla 1 lança Açoite Mental, não Punição.
- Apertar Atirar (5) sem varinha. Compre ou encontre uma primeiro.
- Procurar uma interrupção no E cedo. O Sacerdote só ganha uma com o talento Silêncio (no mínimo 30).
- Agrilhoar Morto-vivo (Shift-Q) num inimigo normal. Só funciona em inimigos Morto-vivo.]] },
	},
	SHAMAN = {
		{ "O que ele faz", [[
O Xamã lança raios e fogo, cura e coloca totens. Ele pode lutar de longe ou de perto com uma arma. No Forever, um Anão (Aliança) também pode ser Xamã.
O Xamã não tem posturas. **Lobo Fantasma** (nível 20, no R) é uma forma para correr, mas não muda suas teclas.]] },
		{ "Totens e buffs de arma", [[
Um **totem** é um pequeno objeto que você coloca no chão. Ele ajuda você ou seu grupo, ou fere inimigos, enquanto está de pé. Os totens pertencem a quatro elementos: Terra, Fogo, Água e Ar. Você pode ter um totem de cada elemento por vez. Um novo substitui o antigo.
- Cada elemento tem um item de totem que você ganha numa missão de classe: Totem da Terra (nível 4, ou 3 para um celonato), Totem do Fogo (10), Totem da Água (20), Totem do Ar (30). Você precisa desse item nas bolsas para todos os totens daquele elemento.
- Antes do nível 20, cada totem tem sua própria tecla: Totem Litopele (Z), Totem de Prisão Terrena (V), Totem da Garra de Pedra (F), Totem da Força da Terra (Shift-X), Totem Calcinante (5), Totem Sísmico (Shift-F).
- A partir do nível 20 o jogo lhe dá uma **Barra de totens**. Nela você escolhe um totem por elemento. Então uma tecla coloca todos eles: **Ctrl-1** = Chamado dos Elementos (20), **Ctrl-2** = Chamado dos Antepassados (30), **Ctrl-3** = Chamado dos Espíritos (40). Cada um coloca até 4 totens da sua própria página da Barra de totens. Tem 3 segundos de conjuração e custa a mana de todos os totens que coloca.
- **Shift-R** = Chamado Totêmico (22): leva seus totens até você. Revocação Totêmica (20, bloco D) recolhe eles e devolve um quarto da mana deles.
Um **buff de arma** coloca poder na sua arma por 60 minutos. Você tem um por vez. Arma Trinca-pedra (1), Arma de Labaredas (10), Arma da Marca Gélida (20) e Arma de Fúria dos Ventos (30) vão em teclas Alt suas (bloco D). Escolha o que combina com o seu jeito de jogar.]] },
		{ "Níveis 1-10: seus botões", [[
- **1** = Raio (nível 1): seu principal feitiço de ataque.
- **C** = Onda Curativa (1): sua cura grande.
- Arma Trinca-pedra (1) vai no bloco D (veja acima).
- **E** = Choque Terreno (4): sua **interrupção** (ela para o feitiço de um inimigo), e dano.
- **Z** = Totem Litopele (4, de uma missão): você leva menos dano de golpes corpo a corpo. **Corpo a corpo** = lutar de perto.
- **V** = Totem de Prisão Terrena (6): deixa lentos os inimigos perto dele. Recarga de 15 segundos.
- **F** = Totem da Garra de Pedra (8): faz os inimigos ao redor dele atacarem o totem. Recarga de 30 segundos.
- **Shift-Z** = Escudo de Raios (8): um escudo em você mesmo. Só um escudo por vez.
- **2** = Choque Flamejante (10): dano de fogo, e depois mais dano ao longo de alguns segundos.
- **5** = Totem Calcinante (10, de uma missão): seu totem de dano.
- **Shift-X** = Totem da Força da Terra (10): um totem que dá um buff ao seu grupo. Um **buff** é um efeito bom.
- Arma de Labaredas (10) vai no bloco D.
- **Shift-E** = o feitiço da sua raça (por exemplo Pisada de Guerra para um Tauren, Forma de Pedra para um Anão).]] },
		{ "Ordem simples", [[
Buff de arma ligado (bloco D), Escudo de Raios ligado (Shift-Z). Totem Calcinante (5) no chão. Choque Flamejante (2), depois Raio (1). Guarde Choque Terreno (E) para quando o inimigo lançar um feitiço. Pouca vida? Onda Curativa (C).]] },
		{ "O que vem depois", [[
- 12: Nova de Fogo no Shift-4, Expurgar no Shift-Q (remove magia de um inimigo), Espírito Ancestral no F3 (traz um amigo morto de volta). 16: Curar Veneno no Shift-C. 18: Totem Sísmico no Shift-F (remove medo, encanto e sono do seu grupo).
- 20: Lobo Fantasma no R (3 segundos de conjuração, só ao ar livre), Choque Gélido no 4 (deixa lento), Onda Curativa Menor no F2 (cura rápida), Totem de Torrente Curativa no F4 (de uma missão; cura seu grupo aos poucos; precisa do Totem da Água), Chamado dos Elementos no Ctrl-1.
- 22: Curar Doença no Shift-V, Chamado Totêmico no Shift-R. 30: Totem de Aterramento no X (pega um feitiço nocivo mirado em você ou num membro do grupo por perto; não feitiços de área; precisa do Totem do Ar da missão de nível 30), Chamado dos Antepassados no Ctrl-2. 32: Cadeia de Raios no Shift-1 (atinge vários inimigos).
- 40: Cura Encadeada no Shift-2 (cura vários amigos), Chamado dos Espíritos no Ctrl-3.
- Talentos: Escudo de Água (assume o Shift-Z), no mínimo 20. Ataque da Tempestade no 3 e Totem de Vagalhão de Mana no F1, 25. Rapidez da Natureza no Shift-3, 30. Contracorrente no Shift-F1, e Maestria em Raio ou Fúria do Clarividente no Q, 40.]] },
		{ "Erros de iniciante", [[
- Usar um choque logo antes de precisar interromper. Choque Terreno (E), Choque Flamejante (2) e Choque Gélido (4) compartilham um tempo de recarga de 6 segundos. Depois de Choque Flamejante, não há interrupção por até 6 segundos.
- Apertar Nova de Fogo (Shift-4) sem um totem de Fogo no chão. Ela precisa de um dos seus totens de Fogo (como Totem Calcinante ou Totem de Magma). Ela atinge os inimigos perto daquele totem, não os que estão perto de você.
- Colocar um totem sem o item de totem dele. Cada elemento precisa do próprio item de totem nas suas bolsas, de uma missão de classe.
- Lançar feitiços no Lobo Fantasma. Seus feitiços não são feitos para o lobo. Saia do Lobo Fantasma primeiro, depois lance.
- Esquecer o buff de arma. Ele dura 60 minutos e não está no bloco: está em teclas Alt suas (bloco D).
- Esperar dois escudos. Quando você tem Escudo de Água, o Shift-Z lança esse, não Escudo de Raios.]] },
	},
	WARLOCK = {
		{ "O que ele faz", [[
O Bruxo fica atrás e lança magia de sombra e de fogo. Boa parte do dano dele vem devagar: feitiços que ferem o inimigo com o tempo, e maldições. Ele quase sempre tem um demônio junto.
Um **DoT** (dano ao longo do tempo) é um feitiço que fere o inimigo aos poucos por um tempo. Uma **maldição** ou **ruína** é um efeito ruim que você coloca num inimigo. Uma maldição e uma ruína podem estar no mesmo inimigo. O Bruxo não tem formas nem posturas, então cada tecla sempre faz a mesma coisa.]] },
		{ "Seu demônio", [[
Seu **ajudante** é um demônio que você evoca. Ele luta ao seu lado. Você aprende os demônios em missões de classe.
- **Evocar Diabrete** (1): da sua primeira missão de classe na sua área inicial. O nome depende da sua raça: Humano "Ladrão que rouba ladrão...", Gnomo "Primeiros passos", Orc e Troll "Familiares Vis" (ou "Familiares torpes"), Morto-vivo "Perfurando o véu". O Diabrete não custa Estilhaço de Alma.
- **Evocar Emissário do Caos** (10, missão). **Evocar Súcubo** ou **Evocar Íncubo** (20, missão). **Evocar Caçador Vil** (30, missão). Cada um desses custa 1 **Estilhaço de Alma** (veja Drenar Alma abaixo).
- **Inferno** (50) está no **F3**. Cada lançamento precisa de uma Pedra Infernal. Recarga de 1 hora.
- As evocações não estão no bloco. Elas vão em teclas Alt suas (bloco D).
- A partir do seu primeiro demônio, seu ajudante tem três teclas: **Ctrl-1** = atacar seu alvo, **Ctrl-2** = seguir você, **Ctrl-3** = ficar onde está.
- O Emissário do Caos pode provocar (Tormento). O Caçador Vil pode parar o feitiço de um inimigo (Bloquear Feitiço, a partir do 36). Esses são feitiços do próprio demônio, na Barra de ajudante da Blizzard.]] },
		{ "Níveis 1-10: seus botões", [[
- **1** = Seta Sombria (nível 1): seu principal feitiço de ataque.
- **3** = Imolação (1): dano de fogo, e depois mais dano ao longo do tempo.
- **Shift-Z** = Pele de Demônio (1): um buff em você mesmo (mais armadura). Um **buff** é um efeito bom. A partir do 20, Armadura Demoníaca assume esta tecla.
- **2** = Corrupção (4): um DoT.
- **Shift-V** = Maldição da Fraqueza (4): sua maldição. A partir do 20, Maldição dos Elementos assume esta tecla.
- **F** = Conversão de Vida (6): transforma parte da sua vida em mana.
- **5** = Ruína da Agonia (8): sua ruína, um DoT.
- **V** = Medo (8): sua tecla de **CC**. CC (controle de grupo) = um feitiço que tira um inimigo da luta por um tempo.
- **4** = Drenar Alma (10): use para acabar com um inimigo que dá EXP, e você ganha um **Estilhaço de Alma**. Um Estilhaço de Alma é um pequeno item nas suas bolsas. Você precisa de um para evocar a maioria dos demônios (todos menos o Diabrete) e para fazer uma Pedra de Vida ou uma Pedra da Alma. Inimigos cinza (fáceis demais) não dão estilhaço.
- Criar Pedra de Vida (10, custa um Estilhaço de Alma) vai no bloco D. Sua Pedra de Vida fica então no **Shift-T**, como para toda classe.
- **Shift-E** = o feitiço da sua raça (por exemplo Fúria Sangrenta para um Orc, Determinação dos Renegados para um Morto-vivo).]] },
		{ "Ordem simples", [[
Demônio fora (bloco D; todos menos o Diabrete precisam de um Estilhaço de Alma), depois mande ele entrar (Ctrl-1). Corrupção (2), Ruína da Agonia (5), Imolação (3), depois Seta Sombria (1). Pouca mana? Conversão de Vida (F). Pouca vida? Drenar Vida (C, a partir do 14).]] },
		{ "O que vem depois", [[
- 12: Funil de Vida no F2 (cura seu demônio). 14: Drenar Vida no C (sua própria cura grande).
- 16: Fôlego Interminável no Shift-R. 18: Dor Lancinante (bloco D), e Criar Pedra da Alma (custa um Estilhaço de Alma; não está no bloco, coloque você mesmo numa barra sua).
- Maldição de Línguas e Ritual de Evocação (trazer um membro do grupo até você) são pouco usados: também não estão no bloco. Coloque-os numa barra sua se quiser.
- 20: Chuva de Fogo no Shift-1 (atinge vários inimigos), Armadura Demoníaca no Shift-Z, Maldição dos Elementos no Shift-V.
- 28: Banir no Shift-Q. 30: Fogo do Inferno no Shift-2. 32: Proteção contra Sombra no Z (absorve dano de sombra; recarga de 30 segundos).
- 40: Uivo do Terror no Shift-F (amedronta vários inimigos). 42: Espiral da Morte no X (um horror, como medo, e uma cura; recarga de 2 minutos).
- 48: Fogo d'Alma no Q (seu maior golpe; custa um Estilhaço de Alma; 6 segundos de conjuração; recarga de 1 minuto). 50: Inferno no F3. 60: Ruína do Destino no F1.
- Talentos: Sombra Ardente no Shift-4 (custa um Estilhaço de Alma), Amplificar Maldição no Shift-3, Sacrifício Demoníaco no Shift-C, no mínimo 20. Maldição da Exaustão no R (deixa o inimigo lento, para você ficar longe dele), Dominância Vil no Shift-F1 (evocar um demônio rápido), 25. Sifão de Vida no F4 (um DoT que cura você), Vínculo Anímico no Shift-X, 30. Conflagrar (25), Ruína Devastadora (30), Destruição (40) e Incinerar (40), todos no mínimo, vão no bloco D.]] },
		{ "Erros de iniciante", [[
- Evocar um demônio sem Estilhaço de Alma. Todos os demônios menos o Diabrete custam um. Use Drenar Alma (4) para acabar com inimigos que dão EXP.
- Procurar uma interrupção no E. O Bruxo não tem uma própria, então o E fica vazio. Só o Caçador Vil tem uma.
- Apertar Funil de Vida (F2) para se curar. Ele cura seu demônio. Sua própria cura é Drenar Vida (C).
- Banir (Shift-Q) num inimigo normal. Só funciona em inimigos Demônio e Elemental.
- Ruína do Destino (F1) num jogador. Ela não pode ser lançada em jogadores.
- Sentir falta da varinha. Atirar não está no bloco. Arraste do seu Grimório para uma barra sua, você mesmo.]] },
	},
}
