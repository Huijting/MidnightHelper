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
		-- not measured: The Great Outdoors (no ptBR quest title in the DB2 cache)
		{ "Acampamento", [[
- **Acampamento** não é uma profissão. Cada profissão pode fazer um **objeto de acampamento**. Culinária faz a fogueira.
- **Comece** com a missão **The Great Outdoors**, em toda zona inicial.
- **1. A fogueira.** Com Culinária, faça um **Kit de Fogueira Básica**: 1 Madeira Simples, com **Pederneira e Lenha** como ferramenta (você fica com ela). Use o kit ao ar livre, fora de combate. A fogueira tem espaço para 3 objetos (Fogueira Profissional 5, Fogueira do Especialista 10). Tempo de recarga: 5 minutos.
- **2. Um objeto.** Faça com a sua profissão. Você precisa de perícia 20 para colocá-lo. Coloque perto da fogueira. O item é gasto.
- **3. Sente-se** perto da fogueira. Você ganha **Fogueira Acolhedora** por 60 segundos. Você pode fabricar, mas não ande. Depois você ganha **Benefícios de Acampamento** por 1 hora, com uma linha por objeto.
- **Regras:** todos os objetos dividem um tempo de recarga de 1 hora. Cada tipo de objeto só uma vez por acampamento.
- **Conflitos:** você não pode ter um buff de acampamento e o buff de classe citado abaixo ao mesmo tempo. A maioria dos buffs de acampamento cresce com o seu nível.
- Esfolamento: **Cadeira de Acampamento** = chance de acerto crítico. Conflita com Aura de Luniscante.
- Ferraria: **Roda de Afiar** = Força. Conflita com Totem da Força da Terra.
- Herborismo: **Vela de Incenso** = Intelecto. Conflita com Inteligência Arcana.
- Alquimia: **Poço de Mana** = mana a cada 5 segundos. Conflita com Bênção de Sabedoria.
- Mineração: **Magnetita** = poder de ataque corpo a corpo. Conflita com Bênção do Poder.
- Pesca: **Aquário** = todos os atributos. Conflita com Bênção dos Reis.
- Primeiros Socorros: **Kit de Primeiros Socorros** = Vigor. Conflita com Palavra de Poder: Fortitude.
- Alfaiataria: **Estandarte de Facção** = Espírito, só para a sua própria facção. Conflita com Espírito Divino.
- Encantamento: **Alaúde Encantado** = armadura, todos os atributos e resistências. Conflita com Marca do Indomado.
- Couraria: **Barraca de Acampamento** = descanse 30 segundos perto dela para ganhar EXP descansada extra, uma vez por hora.
- Engenharia: **Robô de Reagentes** = sem buff, ele vende reagentes.
- **/mh camp** mostra o que o MH consegue ler dos seus buffs de acampamento.]] },
		-- not measured: Innkeeper Wiley (no ptBR creature name in the DB2 cache)
		{ "Pontos de Legado", [[
- **Pontos de Legado** são ganhos pela sua conta inteira: 65 desafios, 1 ponto cada. Cada personagem gasta os próprios pontos, até 16 por enquanto.
- **Como ganhar:** uma classe chegando aos níveis 25, 45 e 60 pela primeira vez. Alquimia, Ferraria, Encantamento, Engenharia, Couraria e Alfaiataria em 150, 225 e 300. Mais alguns por JxJ, masmorras, raides e exploração.
- Profissões de coleta, Culinária, Primeiros Socorros e Pesca não dão pontos.
- A janela abre com o seu primeiro ponto. Para a maioria dos jogadores, isso é no nível 25.
- **Gastar:** aperte o botão **Legado** na barra de menu. Há três árvores: **Profissões**, **Aventura** e **Desenvoltura**. Cada grau custa 1 ponto.
- A **coluna 2** abre depois de 5 pontos naquela árvore, a **coluna 3** depois de 10.
- **Desfazer:** no treinador da sua classe, todas as vantagens de uma vez. O treinador mostra o preço. Você tem Talento é para quem tem? Então desaprenda primeiro os seus talentos de classe.
- **Recompensas** com 15, 25, 40 e 55 pontos ganhos (ganhos, não gastos). Pegue com **Innkeeper Wiley** em Vila Catraca.
- **Exemplo, subir de nível:** **Bem Descansado** (a EXP descansada acumula mais rápido), depois **Talento é para quem tem** (exige Bem Descansado): pontos de talento até 5 níveis mais cedo, nunca mais de 51 no total.
- **Exemplo, profissões:** **Hora Extra** (mais pontos de perícia) e **Colheita Farta** (materiais escassos com mais frequência de Mineração, Herborismo e Esfolamento).
- **Estudo Dedicado** é um botão, não uma vantagem passiva: 25 segundos lançando, depois 23 horas de espera. Ele aumenta em 1 a sua perícia de profissão mais baixa.
- **/mh legacy** mostra quantos pontos o MH consegue ler.]] },
		-- 21 Nov 2026: new 4th section (mh-writer). Measured DB2 ptBR 1.60.1.71037: TALENT_SPEC_SECONDARY "Talentos secundários",
		-- spell 63624 "Aprender Segunda Especialização de Talentos" (no separate "Dual Spec" word in the client).
		{ "Talentos: redefinir e segunda especialização", [[
- **Redefina seus talentos** com o treinador da sua classe: fale com ele e escolha a opção de talentos. Depois distribua seus pontos de novo. Os jogadores dizem que custa 1 de ouro na primeira vez, depois 5, depois 10, e mais depois disso. A Blizzard diz que o preço sobe rápido e baixa uma vez por semana.
- **Segunda Especialização de Talentos:** a partir do nível 40, o treinador da sua classe vende um segundo conjunto de talentos. No jogo, ele se chama **Talentos secundários**. Os jogadores dizem que custa 50 de ouro; a Blizzard não deu preço.
- **Trocar** entre os seus dois conjuntos leva 5 segundos e não funciona em combate.
- **Suas barras depois de trocar:** jogadores relatam que trocar pode mudar suas barras de ação: o jogo pode colocar feitiços nelas, por cima dos seus próprios botões e macros. O MH não viu isso no jogo. Confira suas barras de ação depois da primeira troca.
- **Para quê:** suba de nível com um conjunto e tanque ou cure com o outro. Um Paladino sobe de nível como Retribuição e tanqueia como Proteção, um Druida sobe de nível como felino e cura como Restauração.]] },
	},
	-- 21 Nov 2026: "Level as X, tank as Y" (mh-writer, from ForeverHowToPlay.lua PLANS). Names measured DB2 ptBR
	-- 1.60.1.71037 (SpellName, TalentTab, Map, GlobalStrings); Acônito and Arquibaldo from Wowhead Forever ptBR.
	PLANS = {
		PALADIN = { title = "Suba de nível como Retribuição, tanqueie como Proteção", body = [[
- **Subir de nível:** os guias chamam Retribuição de jeito mais rápido de subir de nível sozinho: uma **arma de duas mãos** lenta e Selo da Retidão, depois Selo de Comando (20, um talento). Gaste seus pontos de talento em Retribuição.
- **Tanquear uma masmorra** funciona desde a primeira, sem trocar os talentos: Cavernas Ígneas para a Horda (a partir do nível 13), Salão dos Thanes para a Aliança (por volta do 13). Fúria Íntegra e Selo da Fúria chegam os dois no 10. Guarde uma **arma de uma mão e um escudo nas bolsas**. Antes da masmorra: equipe os dois, ligue Fúria Íntegra (bloco D) e Selo da Fúria (**F**). Depois: volte para a arma de duas mãos e desligue Fúria Íntegra (clique com o botão direito nela, no canto superior direito). Com Fúria Íntegra ligada, você puxa os inimigos para longe do seu grupo.
- **Quando fica fácil:** no 30 com Escudo Sagrado (um talento de Proteção), e de verdade no 40 com Juramentado do Escudo. Para isso você precisa de talentos de Proteção: a **Segunda Especialização de Talentos** (a partir do 40) lhe dáum segundo conjunto, então você sobe de nível como Retribuição e tanqueia como Proteção. Veja "Talentos: redefinir e segunda especialização" abaixo.
- **Atributos para tanquear:** Vigor primeiro. Os guias não concordam sobre o que vem depois: wowforeverbuilder diz Defesa, Vigor, Poder mágico, Intelecto (nada de Força), outro guia coloca Poder mágico e Intelecto acima de Força. Com Poder mágico, Consagração e Escudo Sagrado seguram melhor os inimigos.
- **Espada de duas mãos de Acônito** (a missão de classe de Morto-vivo no 20): aprenda Espadas de Duas Mãos primeiro, com Arquibaldo na Cidade Baixa. O MH avisa você em Faça isto agora.]] },
		WARRIOR = { title = "Suba de nível e tanqueie como Guerreiro", body = [[
- **Subir de nível:** os guias não concordam. A maioria diz que Proteção sobe de nível mais rápido: uma arma de duas mãos até Revanche no 14, depois uma **arma de uma mão e um escudo**. Um guia acha Proteção mais lenta sozinho. Armas ou Fúria também funcionam; aí guarde uma arma de uma mão e um escudo nas bolsas para tanquear.
- **Tanquear uma masmorra** funciona desde a primeira: Cavernas Ígneas (Horda) a partir do nível 13, Salão dos Thanes (Aliança) a partir do 13 mais ou menos, Minas Mortas a partir do 16, Caverna Ululante a partir do 17. A missão de classe do 10 lhe dáPostura de Defesa, Provocar e Fender Armadura. No Forever, Postura de Defesa gera muito mais ameaça do que no jogo antigo, então os inimigos ficam em você.
- **Quando fica fácil:** no 14-16 com Revanche e Levantar Escudo, e de verdade no 40 com Escudada (um talento) e Armadura de Placa.
- **Talentos:** com talentos de Proteção você sobe de nível e tanqueia com um conjunto só. Subiu de nível como Armas ou Fúria? Então a **Segunda Especialização de Talentos** (a partir do 40) lhe dáum segundo conjunto para tanquear. Veja "Talentos: redefinir e segunda especialização" abaixo.
- **Atributos para tanquear:** Vigor primeiro. Os guias não concordam sobre o resto: um coloca Defesa por último, outro quer Defesa até 440 cedo. Para ameaça: Acerto e Aptidão.]] },
		DRUID = { title = "Suba de nível e tanqueie como Druida", body = [[
- **Subir de nível:** os guias escolhem Combate Feral: o urso a partir do nível 10, o felino a partir do 20. Talentos de Combate Feral servem para os dois, então você sobe de nível como felino e tanqueia como urso com os mesmos talentos. Você não precisa de escudo nem de uma segunda arma.
- **Sua arma conta numa forma.** Blizzard: em Forma de Urso e Forma de Felino, seus golpes normais causam o dano da arma que você segura. Então fique com o melhor cajado ou maça de duas mãos, também para tanquear.
- **Tanquear uma masmorra** funciona desde a primeira: Cavernas Ígneas para a Horda (a partir do nível 13), Salão dos Thanes para a Aliança (por volta do 13). Forma de Urso vem da missão de classe do 10, com Rosnar e Malho (um guia diz só Malho: confira seus feitiços). No Forever, Forma de Urso gera muito mais ameaça do que no jogo antigo.
- **Quando fica fácil:** Patada no 16 (mais inimigos de uma vez), Lacerar no 25 (um talento), e de verdade no 40 com Forma de Urso Hediondo e Mordida Primeva (um talento).
- **Curar em grupo?** Isso precisa de talentos de Restauração e equipamento com Intelecto: a **Segunda Especialização de Talentos** (a partir do 40) lhe dáum segundo conjunto. Veja "Talentos: redefinir e segunda especialização" abaixo.
- **Atributos para tanquear:** os guias não concordam. Para sobreviver: Armadura, depois Defesa até 440, depois Vigor, depois Agilidade. Para ameaça: dano da arma, depois Agilidade, depois Força. Outro guia diz dano da arma, Força, Agilidade enquanto você sobe de nível.]] },
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
- 16: Forma Aquática (de uma missão) no R enquanto você nada. 18: Fogo Feérico no 5 (funciona na maioria das formas, mas não na Forma de Viagem nem na Forma Aquática), Hibernar no Shift-Q.
- 20: Forma de Felino (de uma missão) no Ctrl-2, com Garra, Despedaçar, Rasgar e Espreitar. Investida Feral no E (um talento, no mínimo nível 20). Fogo Estelar no 3. Em combate, o F3 vira Renascimento.
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
- **2** = Julgamento (4): recarga de 10 segundos. Não gasta o seu selo. Só funciona com um selo ativo: coloque o seu selo primeiro (3).
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
- 12: Redenção (de uma missão) no F3 (traz um amigo morto de volta; não em combate). 14: Bênção de Sabedoria no Shift-V.
- 18: Bênção da Liberdade no R (nada pode deixar você lento por um tempo). 20: Consagração no Shift-1 (atinge vários inimigos de uma vez), Exorcismo no 5, Clarão de Luz no F2 (cura rápida), Bênção dos Reis no Shift-X.
- 30: Intervenção Divina: em combate, o F3 lança esta em vez de Redenção. Cuidado: você mesmo morre; o amigo que você escolhe fica a salvo de todos os ataques por um tempo curto. 34: Escudo Divino no Z: 10 segundos em que nada pode ferir você, e você ainda pode lutar (com metade do dano).
- 42: Purificação substitui Purificar no Shift-C. 44: Martelo da Ira no 4 (só quando o inimigo está com 20% de vida ou menos).
- 52-60: num grupo, as teclas de bênção lançam a Bênção Maior para o grupo inteiro; sozinho, elas lançam a normal.]] },
		{ "Erros de iniciante", [[
- Apertar Exorcismo (5) num inimigo normal. Só funciona em inimigos Morto-vivo e Demônio. Esconjurar Morto-vivo (Shift-Q, 24) só funciona em Morto-vivo.
- Apertar Martelo da Ira (4) no começo da luta. Só funciona quando o inimigo está quase morto (20% de vida ou menos).
- Escudo Divino e Proteção Divina compartilham um tempo de recarga, então ficam numa tecla só (Z). Esses feitiços de proteção, a Bênção de Proteção e o Baluarte do Templário dão **Abstinência**: por 1 minuto você não pode receber nenhum deles de novo. Impor as Mãos não dá.]] },
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
- **Nível 10, missões do ajudante:** você aprende Domar Fera, Chamar Ajudante e Dispensar Ajudante; a missão seguinte dá Reviver Ajudante e Alimentar Ajudante. **F4** = Chamar Ajudante (traz seu ajudante), **F3** = Reviver Ajudante (traz um ajudante morto de volta). Domar Fera não tem tecla; você usa fora de combate.
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
Cada raça de Sacerdote tem dois feitiços de Sacerdote próprios: um no nível 10 e um no nível 20. Você ganha os dois de uma missão, não do treinador. O MH coloca eles no **X** e no **Shift-R**, então toda raça usa as mesmas duas teclas.
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
- Curar na Forma de Sombra. Nenhum feitiço de cura funciona na Forma de Sombra. Proteção contra Medo também não funciona nela. Saia dela primeiro: aperte Ctrl-1 de novo.
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
	-- Por função (16 Nov 2026, mh-writer), same shape as ROLES in Modules/ForeverHowToPlay.lua: same band, same order.
	-- Spell names: SpellName ptBR, wowf 1.60.1.70938. Tree names: ForeverMacros.lua SPEC_NAMES.
	ROLES = {
		DRUID = {
			{ band = 2, title = "Urso: tanque", body = [[
A partir do nível 10 (Forma de Urso, de uma missão). O **tanque** é quem os inimigos atacam, para o resto do grupo ficar seguro. Para subir de nível, os guias acham o felino mais tranquilo; o urso é útil do 10 ao 20, e para tanquear em masmorras. O urso usa **Raiva**: você ganha Raiva quando bate e quando apanha.
**Ordem simples:**
1. Puxe com Fogo Feérico (**5**, a partir do 18) ou Investida Feral (**E**, a partir do 20). **Puxar** = acertar um inimigo de longe, para ele vir até você.
2. Rugido Desmoralizante (**Shift-2**) uma vez.
3. Mordida Primeva (**3**, a partir do 40) sempre que estiver pronta.
4. Lacerar (**2**, a partir do 25) até ter 5 acúmulos.
5. Raiva sobrando: Malho (**1**) em um inimigo, Revés (**4**, a partir do 16) em dois ou mais.
6. Rosnar (**F**) quando um inimigo bate em outra pessoa.
**A cada 10 níveis:**
- 10: Forma de Urso (**Ctrl-1**), Malho (**1**), Rosnar (**F**), Rugido Desmoralizante (**Shift-2**). Depois Enfurecer (**Q**) no 12, Trombar (**V**) no 14, Revés (**4**) no 16, Fogo Feérico (**5**) no 18.
- 20: Investida Feral (**E**, um talento): você avança no inimigo, e ele não pode se mover nem lançar feitiços por 4 segundos. Recarga de 15 segundos. Os níveis de talento aqui são os mais cedo possíveis; uma vantagem pode adiantá-los em até 5 níveis.
- 30: Líder do Bando (um talento). Antes disso: Lacerar (**2**, um talento) no 25, Rugido Desafiador (**Shift-F**) no 28.
- 40: Forma de Urso Hediondo substitui a Forma de Urso no **Ctrl-1**. Mordida Primeva (**3**, um talento). Antes disso: Regeneração Frenética (**X**) no 36: transforma Raiva em vida.
- 50: graus mais fortes de Mordida Primeva, Lacerar e Malho. Pele de Árvore (**Z**) no 44.
- 60: graus mais fortes de novo; nada novo para esta função.
**Erros de iniciante:**
- Investida Feral quando o inimigo está a menos de 8 jardas. Ali ela não funciona.
- Enfurecer (**Q**) enquanto você leva golpes pesados. Ele dá Raiva, mas você fica com 27% menos armadura.]] },
			{ band = 2, title = "Felino: dano corpo a corpo", body = [[
A partir do nível 20 (Forma de Felino, de uma missão; Espreitar vem junto). Para subir de nível, é a primeira escolha dos guias: eles dizem que é a mais rápida e a mais tranquila. O felino usa **Energia**, que enche sozinha. Seus golpes dão **Pontos de Combo** (até 5); um **finalizador** gasta todos eles.
**Ordem simples:**
1. Espreitar (**Shift-R**), depois abra com Despedaçar (**3**) por trás. **Espreitar** = andar escondido, para o inimigo não ver você.
2. Fogo Feérico (**5**) em inimigos difíceis.
3. Estraçalhar (**2**, a partir do 24), mas não quando o inimigo está quase morto.
4. Garra (**1**) para Pontos de Combo; Despedaçar (**3**) quando você está atrás do inimigo.
5. Com 4-5 Pontos de Combo: Rasgar (**4**) se o inimigo ainda vai viver muito; senão, Mordida Feroz (**C**, a partir do 24).
6. Poder Cambiante (**Q**, a partir do 40) quando sua Energia está abaixo de 50.
**A cada 10 níveis:**
- 10: nada novo para esta função (o felino chega no 20).
- 20: Forma de Felino (**Ctrl-2**), Garra (**1**), Despedaçar (**3**, por trás), Rasgar (**4**), Espreitar (**Shift-R**). Investida Feral (**E**, um talento): como felino, você salta para trás do inimigo. Presságio de Clareza é passivo: não tem tecla.
- 30: Líder do Bando (um talento). Antes disso: Estraçalhar (**2**) e Mordida Feroz (**C**) no 24, Arremetida (**R**) no 26, Acovardar (**F**) no 28.
- 40: Poder Cambiante (**Q**, um talento): 40 de Energia por mana, recarga de 8 segundos, só como felino. Antes disso: Assolar (bloco D) no 32, Pulo do Gato (**V**, a partir de Espreitar, um atordoamento) no 36. Os níveis de talento aqui são os mais cedo possíveis; uma vantagem pode adiantá-los em até 5 níveis.
- 50: graus mais fortes de Mordida Feroz, Rasgar e Despedaçar; nada novo para esta função.
- 60: graus mais fortes de novo; nada novo para esta função.
**Erros de iniciante:**
- Despedaçar pela frente. Só funciona por trás; pela frente, use Garra.
- Poder Cambiante vezes demais. Aí você fica sem mana para se curar.]] },
			{ band = 1, title = "Equilíbrio: dano à distância", body = [[
A partir do nível 1: Ira está lá desde o começo, Fogo Lunar vem no 4. Forma de Luniscante é um talento, no mínimo nível 40. Os guias dizem que subir de nível como Equilíbrio funciona, mas é mais lento que o felino. Alguns guias pegam a Forma de Luniscante mais tarde (Zygor no 53): 40 não é regra.
**Ordem simples:**
1. Fogo Estelar (**3**, a partir do 20) para abrir em um inimigo.
2. Fogo Lunar (**2**).
3. Nuvem de Insetos (**4**, a partir do 25).
4. Ira (**1**) para preencher. Com Eclipse (a partir do 30): Ira acumula cargas, depois Fogo Estelar (**3**).
5. Furacão (**Shift-1**, a partir do 40) em grupos.
Pouca mana? Continue com Ira: é barata.
**A cada 10 níveis:**
- 10: Ira (**1**), Fogo Lunar (**2**), Espinhos (**Shift-Z**), Raízes Enredantes (**V**), Enredamento (**X**).
- 20: Fogo Estelar (**3**). Presságio de Clareza é passivo: não tem tecla.
- 30: Eclipse (um talento): Ira deixa seus próximos 2 Fogo Estelar mais rápidos. Antes disso: Nuvem de Insetos (**4**, um talento) no 25. Os níveis de talento aqui são os mais cedo possíveis; uma vantagem pode adiantá-los em até 5 níveis.
- 40: Forma de Luniscante (**Ctrl-3**, um talento): custa mana, dá +3% de crítico ao seu grupo (**crítico** = um golpe de sorte, mais forte), mas nela não há curas. Furacão (**Shift-1**), Avivar (**F1**).
- 50: graus mais fortes de Furacão e Fogo Estelar. Pele de Árvore (**Z**) no 44.
- 60: graus mais fortes de novo; nada novo para esta função.
**Erros de iniciante:**
- Curar na Forma de Luniscante. Não dá, e voltar para a forma custa mana.
- Procurar uma tecla para Presságio de Clareza. Ele é passivo: funciona sozinho.]] },
			{ band = 3, title = "Restauração: curandeiro", body = [[
A partir do nível 1: Toque de Cura está lá desde o começo. Os guias não recomendam curar para subir de nível sozinho (os inimigos morrem devagar): suba de nível com Ira e Fogo Lunar, e cure em masmorras. Um **HoT** é uma cura que cura aos poucos.
**Ordem simples (em grupo):**
1. Rejuvenescer (**F4**) no tanque.
2. Recrescimento (**F2**) em alguém com pouca vida.
3. Recomposição Rápida (**Shift-F1**, a partir do 25): só em alguém que tem seu Rejuvenescer ou seu Recrescimento.
4. Crescimento Silvestre (**Shift-2**, a partir do 40) quando mais pessoas levam dano.
5. Toque de Cura (**C**) para dano grande. Emergência: Rapidez da Natureza (**Shift-3**, a partir do 30), depois Toque de Cura.
6. Avivar (**F1**, a partir do 40) quando sua mana está baixa.
**A cada 10 níveis:**
- 10: Toque de Cura (**C**), Rejuvenescer (**F4**). Depois Recrescimento (**F2**) e Reviver (**F3**, fora de combate) no 12, Curar Veneno (**Shift-C**) no 14.
- 20: Renascimento (**F3**, em combate). Depois Remover Maldição (**Shift-V**) no 24, Abolir Veneno (**Shift-C**) no 26.
- 30: Rapidez da Natureza (**Shift-3**, um talento), Tranquilidade (**Q**). Antes disso: Recomposição Rápida (**Shift-F1**, um talento) no 25. Os níveis de talento aqui são os mais cedo possíveis; uma vantagem pode adiantá-los em até 5 níveis.
- 40: Crescimento Silvestre (**Shift-2**, um talento), Avivar (**F1**).
- 50: Dádiva do Indomado (**Shift-X**), um Crescimento Silvestre mais forte.
- 60: graus mais fortes de novo; nada novo para esta função.
**Erros de iniciante:**
- Curar numa forma. As curas só funcionam na sua forma normal.
- Lançar um HoT em alguém que ainda tem ele. O novo substitui o antigo.]] },
		},
		-- Warrior, Mage, Priest, Rogue, Hunter, Shaman, Warlock, Paladin: 17 Nov 2026, mh-writer, from Modules/ForeverHowToPlay.lua.
		-- Spell and talent names: SpellName ptBR, wowf 1.60.1.70938 (by id). Attack power: GlobalStrings ptBR.
		WARRIOR = {
			{ band = 3, title = "Proteção: tanque", body = [[
A partir do nível 10 (Postura de Defesa, de uma missão; a mesma missão dá Provocar e Fender Armadura). O **tanque** é quem os inimigos atacam, para o resto do grupo ficar seguro. Você usa uma arma de uma mão e um escudo. **Ameaça** = o quanto um inimigo quer atacar você; como tanque, você precisa dela em cada inimigo. Os guias não concordam sobre qual árvore sobe de nível mais rápido sozinha: alguns dizem que Proteção é a mais rápida, outros dizem que ela é mais lenta sozinha. Ela pega ritmo por volta do nível 16, quando você tem Levantar Escudo junto com Revanche.
**Ordem simples:**
1. Postura de Defesa (**Ctrl-2**), Brado de Batalha (**Shift-X**). Fúria Sanguinária (**F1**) para ter Raiva no começo.
2. Puxe. **Puxar** = acertar um inimigo de longe, para ele vir até você. Investida (**R**) só funciona na Postura de Batalha (**Ctrl-1**); volte para a Postura de Defesa (**Ctrl-2**) depois. Com Vanguarda (a partir do 25), Investida também funciona na Postura de Defesa. Ou puxe com sua arma de longo alcance (bloco D).
3. Vários inimigos: Brado Desmoralizador (**Shift-2**, a partir do 14) uma vez, Trovoada (**Shift-1**) sempre que estiver pronta.
4. Levantar Escudo (**Z**, a partir do 16), e Revanche (**2**, a partir do 14) assim que acender.
5. Escudada (**3**, a partir do 40) sempre que estiver pronta.
6. Fender Armadura (**5**) no seu alvo principal; até 5 acúmulos num chefe.
7. Provocar (**F**) quando um inimigo ataca outra pessoa.
8. Raiva sobrando: Golpe Heroico (**1**) em um inimigo, Cutilada (**Shift-4**, a partir do 20) em dois ou mais.
**A cada 10 níveis:**
- 10: Postura de Defesa (**Ctrl-2**), Provocar (**F**), Fender Armadura (**5**), Fúria Sanguinária (**F1**). Depois Trombada com Escudo (**E**) no 12, Revanche (**2**) e Brado Desmoralizador (**Shift-2**) no 14, Levantar Escudo (**Z**) no 16, Desarmar (**V**) no 18.
- 20: Último Recurso (**X**, um talento): 30% mais vida máxima por 20 segundos. Ímpeto da Vitória (**F2**), Cutilada (**Shift-4**). Depois Brado Intimidador (**Shift-Q**) no 22, Vanguarda (um talento, passivo) no 25, Brado Desafiador (**Shift-F**) no 26, Muralha de Escudos (**C**) no 28. Os níveis de talento aqui são os mais cedo possíveis; uma vantagem pode adiantá-los em até 5 níveis.
- 30: Pancada de Concussão (**Shift-V**, um talento): um atordoamento de 5 segundos. Postura de Berserker (**Ctrl-3**, de uma missão). Depois Bastião (um talento, passivo) no 35.
- 40: Escudada (**3**, um talento). Armadura de Placa no treinador: você pode usar placa.
- 50: nada novo para esta função. Graus mais fortes de Escudada, Revanche, Fender Armadura e Trovoada.
- 60: graus mais fortes de novo; nada novo para esta função.
**Erros de iniciante:**
- Achar que Trovoada atinge o bando inteiro. Ela atinge 4 inimigos; um quinto pode correr até o curandeiro.
- Deixar inimigos atrás de você. Por trás você não pode bloquear, se esquivar nem aparar, e Revanche não acende.
- Provocar num inimigo que já ataca você. Aí não faz nada.]] },
			{ band = 1, title = "Armas: dano com uma arma grande", body = [[
A partir do nível 1. Você usa uma arma grande de duas mãos e quase sempre fica na Postura de Batalha. Os grandes passos são Golpes a Esmo no 30 e Golpe Mortal no 40. Uma arma nova é o seu maior ganho. Você não tem cura própria, a não ser Ímpeto da Vitória (a partir do 20), então comida e ataduras continuam úteis. Os guias não concordam sobre qual árvore sobe de nível mais rápido; as três funcionam.
**Ordem simples:**
1. Postura de Batalha (**Ctrl-1**), Brado de Batalha (**Shift-X**).
2. Investida (**R**) para começar.
3. Dilacerar (**Shift-Z**), se o inimigo vai viver um tempo.
4. Subjugar (**2**, a partir do 12) assim que acender.
5. Golpe Mortal (**3**, a partir do 40) sempre que estiver pronto; guarde 30 de Raiva para ele.
6. Ímpeto da Vitória (**F2**, a partir do 20) depois de matar, quando falta vida.
7. Dois inimigos: Golpes a Esmo (**Q**, a partir do 30), depois Cutilada (**Shift-4**, a partir do 20). Antes do 30: Trovoada (**Shift-1**).
8. Raiva sobrando: Golpe Heroico (**1**).
**A cada 10 níveis:**
- 10: Golpe Heroico (**1**), Investida (**R**), Dilacerar (**Shift-Z**), Trovoada (**Shift-1**), Cortar Tendão (**V**), Brado de Batalha (**Shift-X**), Fúria Sanguinária (**F1**). Depois Subjugar (**2**) no 12, Brado Desmoralizador (**Shift-2**) no 14.
- 20: Ímpeto da Vitória (**F2**), Cutilada (**Shift-4**), Batida (**Shift-C**), Retaliação (**C**). Depois Executar (**4**) no 24, Golpe Lanceador (**F3**, um talento) no 25: um golpe extra forte em Gigantes e Draconianos. Os níveis de talento aqui são os mais cedo possíveis; uma vantagem pode adiantá-los em até 5 níveis.
- 30: Golpes a Esmo (**Q**, um talento, só na Postura de Batalha): seus próximos 5 golpes também atingem um inimigo ao lado do seu alvo. Postura de Berserker (**Ctrl-3**, de uma missão) com Interceptar (**R**) e Raiva Incontrolada (**Shift-V**). Depois Batida Aprimorada (um talento, passivo) no 35, Redemoinho (**2** na Postura de Berserker) no 36, Murro (**E** na Postura de Berserker) no 38.
- 40: Golpe Mortal (**3**, um talento): o inimigo recebe 50% menos cura por 10 segundos. Armadura de Placa no treinador.
- 50: Temeridade (**Q** na Postura de Berserker). Graus mais fortes de Golpe Mortal.
- 60: graus mais fortes de novo; nada novo para esta função.
**Erros de iniciante:**
- Apertar Golpe Heroico (**1**) o tempo todo. Esse golpe não dá Raiva, então não sobra nada para Golpe Mortal ou Subjugar.
- Batida (**Shift-C**) antes do talento Batida Aprimorada: 1,5 segundo de conjuração, que atrasa seu golpe normal. A maioria dos guias pula ela até lá.
- Procurar uma interrupção no **E** com uma arma de duas mãos. Trombada com Escudo precisa de um escudo; sua interrupção é Murro (38, Postura de Berserker).]] },
			{ band = 2, title = "Fúria: dano com duas armas", body = [[
Uma arma em cada mão, a partir do nível 20 (Empunhar Duas Armas no treinador). Até lá, use sua melhor arma (uma de duas mãos serve) e jogue como Armas. Fúria fica forte de verdade com Redemoinho (36) e Sede de Sangue (40). Você precisa de duas armas boas. Redemoinho, Murro, Interceptar e Raiva Incontrolada só funcionam na Postura de Berserker, então você troca de postura muitas vezes.
**Ordem simples (a partir do 36; antes disso, jogue como Armas):**
1. Brado de Batalha (**Shift-X**). Fúria Sanguinária (**F1**) para ter Raiva.
2. Investida (**R**) na Postura de Batalha (**Ctrl-1**).
3. Desejo de Matar (**Shift-3**, a partir do 30) num inimigo forte.
4. Postura de Berserker (**Ctrl-3**): Redemoinho (**2**, a partir do 36) sempre que estiver pronto.
5. Sede de Sangue (**3**, a partir do 40) sempre que estiver pronta. Os guias divergem sobre qual dos dois vem primeiro.
6. Ímpeto da Vitória (**F2**) depois de matar, quando falta vida.
7. Raiva sobrando: Golpe Heroico (**1**); em dois inimigos, Cutilada (**Shift-4**).
8. Pouca Raiva: Golpes Imprudentes (**Shift-F1**, a partir do 25; custa vida).
**A cada 10 níveis:**
- 10: nada novo para esta função: você joga como Armas, com uma arma.
- 20: Empunhar Duas Armas no treinador: agora uma arma pode ir na sua outra mão. Uivo Perfurante (**Shift-R**, um talento): deixa lentos todos os inimigos perto de você. Ímpeto da Vitória (**F2**), Cutilada (**Shift-4**). Depois Executar (**4**) no 24, Golpes Imprudentes (**Shift-F1**, um talento) no 25. Os níveis de talento aqui são os mais cedo possíveis; uma vantagem pode adiantá-los em até 5 níveis.
- 30: Desejo de Matar (**Shift-3**, um talento). Postura de Berserker (**Ctrl-3**, de uma missão) com Interceptar (**R**) e Raiva Incontrolada (**Shift-V**). Depois Redemoinho (**2** na Postura de Berserker) no 36, Murro (**E** na Postura de Berserker) no 38.
- 40: Sede de Sangue (**3**, um talento; você precisa de Desejo de Matar antes). Ela não cura; ela faz você correr mais rápido. Armadura de Placa no treinador.
- 50: Temeridade (**Q** na Postura de Berserker). Graus mais fortes de Sede de Sangue.
- 60: graus mais fortes de novo; nada novo para esta função.
**Erros de iniciante:**
- Jogar Fúria com uma arma boa e uma segunda ruim.
- Procurar Redemoinho (**2**) na Postura de Batalha. Ele só funciona na Postura de Berserker, e lá Dilacerar e Trovoada não funcionam.
- Desejo de Matar (**Shift-3**) numa luta que você pode perder. Por 30 segundos você também leva 5% mais dano.]] },
		},
		MAGE = {
			{ band = 1, title = "Arcano: dano à distância", body = [[
A partir do nível 8 (Mísseis Arcanos). Impacto Arcano é um talento, no mínimo nível 20; até lá você joga como qualquer mago, com Seta de Gelo, Bola de Fogo e Mísseis Arcanos. Os guias divergem: alguns dizem que Arcano é forte para subir de nível, a maioria aconselha Gelo e diz que Arcano gasta muita mana. A árvore dele não tem lentidões, então é a mais fraca para manter os inimigos longe. Um **feitiço canalizado** continua enquanto você fica parado; se você se mover, ele para. Mísseis Arcanos é um deles.
**Ordem simples:**
1. Abra com Seta de Gelo (**2**): o inimigo então vem devagar.
2. Impacto Arcano (**Ctrl-2**, a partir do 20): um ou dois, num chefe até quatro. Cada um faz o próximo custar mais mana.
3. Salva de Mísseis (a partir do 15) acendeu? Mísseis Arcanos (**3**) na hora: de graça e duas vezes mais rápido.
4. Ira Arcana (**Shift-F1**, a partir do 25) sempre que estiver pronta.
5. Inimigo perto de você? Nova Congelante (**V**), afaste-se.
6. Quase morto: sua varinha (**Ctrl-3**, até o 40) ou Impacto de Fogo (**5**).
7. Inimigo difícil ou chefe: Presença de Espírito (**Shift-3**, a partir do 30), depois Ira Arcana para um grande golpe instantâneo. A partir do 40, também Poder Arcano (**Q**).
Vários inimigos: Nova Congelante (**V**), depois Explosão Arcana (**Shift-2**, a partir do 14). Pouca mana? Evocação (**F1**, a partir do 20).
**A cada 10 níveis:**
- 10: Nova Congelante (**V**). Primeiro talento: Canalização Aprimorada (Mísseis Arcanos não é mais interrompido quando você leva golpes). Depois Explosão Arcana (**Shift-2**) no 14, Salva de Mísseis (um talento, passivo) no 15. Os níveis de talento aqui são os mais cedo possíveis; uma vantagem pode adiantá-los em até 5 níveis.
- 20: Impacto Arcano (**Ctrl-2**, um talento). Lampejo (**R**), Evocação (**F1**), Escudo de Mana (**Z**). Depois Contrafeitiço (**E**) no 24, Ira Arcana (**Shift-F1**, um talento; você precisa de Impacto Arcano antes) no 25.
- 30: Presença de Espírito (**Shift-3**, um talento): seu próximo feitiço com conjuração abaixo de 10 segundos é instantâneo. Armadura de Gelo (**Shift-Z**). Depois Armadura de Mago (bloco D) no 34.
- 40: Poder Arcano (**Q**, um talento; você precisa de Presença de Espírito antes): por 15 segundos seus feitiços causam 30% mais dano, mas custam 30% mais mana. Seta de Fogofrio assume o **Ctrl-3**: coloque sua varinha (Atirar) numa tecla Alt sua.
- 50: graus mais fortes de Impacto Arcano, Ira Arcana e Mísseis Arcanos; nada novo para esta função.
- 60: graus mais fortes de novo; nada novo para esta função.
**Erros de iniciante:**
- Apertar Impacto Arcano de novo e de novo. Cada um faz o próximo custar 100% mais mana; sua mana acaba rápido.
- Se mover durante Mísseis Arcanos. É um feitiço canalizado: se mover para ele.
- Poder Arcano num inimigo normal. Ele também deixa seus feitiços mais caros, e tem recarga de 3 minutos.]] },
			{ band = 2, title = "Fogo: dano à distância", body = [[
A partir do nível 1 (Bola de Fogo). Ignimpacto é um talento, no mínimo nível 20. O jogo de Fogo de verdade começa com Aquecendo (no mínimo 25); antes disso, Ignimpacto só serve para abrir. Os guias dizem que Fogo causa o maior dano em um inimigo, e sobe de nível rápido, mas com mais risco que Gelo: ele não tem congelamentos próprios. Um **crítico** é um golpe de sorte, mais forte.
**Ordem simples:**
1. Abra de longe com Ignimpacto (**4**, a partir do 20). Antes disso: Bola de Fogo (**1**).
2. Bola de Fogo (**1**) como seu feitiço normal.
3. Impacto de Fogo (**5**) sempre que estiver pronto. A partir do 25, cada Impacto de Fogo dá um acúmulo de Aquecendo.
4. Dois ou três acúmulos de Aquecendo (a partir do 25)? Ignimpacto (**4**).
5. Inimigo perto: Calcinar (**Ctrl-1**, a partir do 22) em vez de Bola de Fogo, ou Nova Congelante (**V**) e afaste-se. A partir do 30, Onda de Impacto (**F3**) depois disso.
6. Quase morto: sua varinha (**Ctrl-3**, até o 40) ou Impacto de Fogo.
7. Elite ou chefe, a partir do 40: Combustão (**Q**).
Vários inimigos: Nova Congelante (**V**), Golpe Flamejante (**Shift-4**, a partir do 16), Onda de Impacto (**F3**, a partir do 30).
**A cada 10 níveis:**
- 10: Nova Congelante (**V**). Primeiro talento: Catalisador (Bola de Fogo é lançada mais rápido). Depois Incendiar e Impacto (talentos) no 15, Golpe Flamejante (**Shift-4**) no 16. Os níveis de talento aqui são os mais cedo possíveis; uma vantagem pode adiantá-los em até 5 níveis.
- 20: Ignimpacto (**4**, um talento): 6 segundos de conjuração, então só para abrir. Lampejo (**R**), Evocação (**F1**), Proteção contra Fogo (**F4**), Escudo de Mana (**Z**). Depois Calcinar (**Ctrl-1**) no 22, Contrafeitiço (**E**) no 24, Aquecendo (um talento, passivo; você precisa de Ignimpacto antes) no 25: um crítico com Bola de Fogo, Seta de Fogofrio, Impacto de Fogo ou Calcinar deixa seu próximo Ignimpacto 25% mais rápido, até 3 acúmulos.
- 30: Onda de Impacto (**F3**, um talento): instantânea, ao seu redor; os inimigos ficam 50% mais lentos por 6 segundos. Massa Crítica (um talento). Armadura de Gelo (**Shift-Z**). Depois Poder de Fogo (um talento) no 35.
- 40: Combustão (**Q**, um talento; você precisa de Massa Crítica antes). Seta de Fogofrio assume o **Ctrl-3**: coloque sua varinha (Atirar) numa tecla Alt sua.
- 50: graus mais fortes de Bola de Fogo, Ignimpacto, Onda de Impacto e Seta de Fogofrio; nada novo para esta função.
- 60: graus mais fortes de novo; nada novo para esta função.
**Erros de iniciante:**
- Lançar Ignimpacto quando o inimigo já está em você. 6 segundos de conjuração é lento demais aí.
- Achar que três acúmulos de Aquecendo deixam Ignimpacto instantâneo. Ainda é 1,5 segundo de conjuração: fique parado.
- Procurar um Bloco de Gelo. Fogo não tem. Sua saída: Nova Congelante (**V**), Lampejo (**R**), Onda de Impacto (**F3**).]] },
			{ band = 3, title = "Gelo: dano à distância", body = [[
A partir do nível 4 (Seta de Gelo); Nova Congelante vem no 10. Lança de Gelo é um talento, no mínimo nível 20. Para subir de nível, é a primeira escolha da maioria dos guias: eles dizem que é a mais segura. Ela pega ritmo de verdade por volta do 30. **Congelado** = o inimigo está congelado no lugar e não pode se mover.
**Ordem simples:**
1. Seta de Gelo (**2**) do mais longe que puder. Cada acerto deixa o inimigo lento.
2. Inimigo Congelado (por Nova Congelante, ou pelo talento Queimadura de Frio)? Lança de Gelo (**F**, a partir do 20).
3. Inimigo perto? Nova Congelante (**V**), afaste-se, Seta de Gelo, depois Lança de Gelo.
4. Dedos Glaciais acendeu (a partir do 30)? Lança de Gelo.
5. Lança de Gelo não está pronta e o inimigo está perto: Cone de Frio (**Shift-F**, a partir do 26).
6. Quase morto: sua varinha (**Ctrl-3**, até o 40) ou Impacto de Fogo (**5**).
Vários inimigos (a partir do 20): Nova Congelante (**V**), afaste-se, Nevasca (**Shift-1**), depois Cone de Frio (**Shift-F**). Em apuros: Bloco de Gelo (**C**, a partir do 25), Lampejo (**R**).
**A cada 10 níveis:**
- 10: Nova Congelante (**V**). Primeiro talento: Seta de Gelo Aprimorada (conjuração mais curta). Depois Queimadura de Frio (um talento) no 15: suas lentidões podem congelar o inimigo por 5 segundos. Os níveis de talento aqui são os mais cedo possíveis; uma vantagem pode adiantá-los em até 5 níveis.
- 20: Lança de Gelo (**F**, um talento): 300% mais dano num inimigo Congelado. Nevasca (**Shift-1**), Lampejo (**R**), Evocação (**F1**), Escudo de Mana (**Z**). Depois Proteção contra Gelo (**F2**) no 22, Contrafeitiço (**E**) no 24, Bloco de Gelo (**C**, um talento) no 25, Cone de Frio (**Shift-F**) no 26.
- 30: Ruptura do Gelo (**Shift-C**, um talento): zera a recarga dos seus outros feitiços de Gelo; a recarga dela mesma é de 10 minutos. Dedos Glaciais (um talento; você precisa de Lança de Gelo antes): seus próximos 2 feitiços agem como se o inimigo estivesse Congelado. Armadura de Gelo (**Shift-Z**). Depois Calafrio do Inverno (um talento) no 35.
- 40: Barreira de Gelo (**X**, um talento; você precisa de Ruptura do Gelo antes): um escudo que absorve dano. Seta de Fogofrio assume o **Ctrl-3**: coloque sua varinha (Atirar) numa tecla Alt sua.
- 50: graus mais fortes de Seta de Gelo, Cone de Frio, Armadura de Gelo, Barreira de Gelo e Nevasca; nada novo para esta função.
- 60: graus mais fortes de novo; nada novo para esta função.
**Erros de iniciante:**
- Lança de Gelo num inimigo que não está Congelado. Aí é um golpe pequeno.
- Apertar Impacto de Fogo logo antes de um congelamento. Impacto de Fogo e Lança de Gelo compartilham uma recarga de 8 segundos.
- Usar Ruptura do Gelo à toa. Ela tem recarga de 10 minutos: guarde para quando as coisas derem errado.]] },
		},
		PRIEST = {
			{ band = 1, title = "Disciplina: curandeiro", body = [[
A partir do nível 1: Cura Inferior está lá desde o começo. Os feitiços próprios dela vêm mais tarde: Proteção Anímica no 25 e Penitência no 30, ambos no mínimo. Num grupo, ela é mais forte curando uma pessoa, o tanque. Subir de nível sozinho funciona com Punição, Fogo Sagrado e sua varinha, depois Penitência; os guias não concordam se é mais rápido que Sombra. **Alma Enfraquecida**: depois de uma Palavra de Poder: Escudo, a mesma pessoa não pode receber um novo escudo por 15 segundos.
**Ordem simples (em grupo):**
1. Palavra de Poder: Escudo (**Z**) no tanque, logo antes de puxar. **Puxar** = o primeiro golpe que começa uma luta.
2. Renovar (**F4**) no tanque.
3. Penitência (**Shift-F1**, a partir do 30) em quem está ferido, toda vez que estiver pronta.
4. Sua cura grande (**C**) para dano normal.
5. Cura Célere (**F2**, a partir do 20) quando C é lento demais.
6. Mais pessoas feridas: Prece de Cura (**Shift-2**, a partir do 30).
7. Concentração Interior (**F1**, a partir do 20) antes de uma cura cara. Infusão de Poder (**Q**, a partir do 40) em você mesmo ou num conjurador.
Sozinho: Escudo (**Z**), Fogo Sagrado (**4**, a partir do 20), Punição (**1**), Impacto Mental (**3**), Palavra Sombria: Dor (**2**), Penitência se você não precisar dela para curar, depois sua varinha (**5**).
**A cada 10 níveis:**
- 10: Cura Inferior (**C**), Palavra de Poder: Escudo (**Z**), Renovar (**F4**), Ressurreição (**F3**, só fora de combate), Punição (**1**). Depois Fogo Interior (**Shift-Z**) no 12, Curar Doença (**Shift-C**) no 14, Cura (**C**) no 16, Dissipar Magia (**Shift-V**) no 18.
- 20: Cura Célere (**F2**), Fogo Sagrado (**4**), Proteção contra Medo (bloco D). Concentração Interior (**F1**, um talento): seu próximo feitiço não custa mana e tem mais chance de crítico; recarga de 3 minutos. Depois Proteção Anímica (um talento, passivo) no 25: Escudo não tem recarga e custa menos. Os níveis de talento aqui são os mais cedo possíveis; uma vantagem pode adiantá-los em até 5 níveis.
- 30: Penitência (**Shift-F1**, um talento): cura um amigo ou fere um inimigo; recarga de 12 segundos. Prece de Cura (**Shift-2**), Espírito Divino (bloco D). Depois Abolir Doença (**Shift-C**) no 32, Égide Divina (um talento, passivo) no 35.
- 40: Infusão de Poder (**Q**, um talento; você precisa de Penitência antes): 20% mais dano e cura de feitiços; recarga de 3 minutos. Cura Maior assume o **C**.
- 50: graus mais fortes de Penitência, Prece de Cura, Cura Célere e Renovar. Prece da Fortitude (**Shift-X**) no 48.
- 60: graus mais fortes de novo; nada novo para esta função.
**Erros de iniciante:**
- Dar escudo no mesmo jogador duas vezes seguidas. Alma Enfraquecida impede. É por jogador: outra pessoa pode receber um escudo na hora.
- Penitência num inimigo para curar seu grupo. Ela cura ou fere, não os dois.
- Prece de Cura no jogador errado. Ela cura o grupo do jogador que você escolhe.]] },
			{ band = 2, title = "Sagrado: curandeiro", body = [[
A partir do nível 1: Cura Inferior está lá desde o começo. Sagrado é o curandeiro de grupo. Sozinho, ele sobe de nível devagar: os guias aconselham fazer missões com Punição e sua varinha, e curar em masmorras. Os feitiços próprios dele vêm tarde: Nova Sagrada no 20 e Prece da Recomposição no 40, ambos no mínimo.
**Ordem simples (em grupo):**
1. Renovar (**F4**) no tanque quando ele começa a puxar. **Puxar** = o primeiro golpe que começa uma luta.
2. Prece da Recomposição (**Ctrl-2**, a partir do 40) no tanque antes de puxar, e de novo toda vez que estiver pronta.
3. Sua cura grande (**C**) para dano normal.
4. Cura Célere (**F2**, a partir do 20) quando C chegaria tarde demais.
5. Grupo todo ferido: Prece de Cura (**Shift-2**, a partir do 30). Nova Sagrada (**Shift-1**, a partir do 20) só quando todos estão bem do seu lado; ela custa muita mana.
6. Palavra de Poder: Escudo (**Z**) para ganhar tempo.
7. Um inimigo ataca você: Desvanecer (**F**).
**A cada 10 níveis:**
- 10: Cura Inferior (**C**), Palavra de Poder: Escudo (**Z**), Renovar (**F4**), Ressurreição (**F3**, só fora de combate). Depois Fogo Interior (**Shift-Z**) no 12, Curar Doença (**Shift-C**) no 14, Cura (**C**) no 16, Dissipar Magia (**Shift-V**) no 18.
- 20: Nova Sagrada (**Shift-1**, um talento): instantânea; fere os inimigos ao seu redor e cura seu grupo, sem ameaça. Cura Célere (**F2**), Fogo Sagrado (**4**), Proteção contra Medo (bloco D). Depois Vínculo Sagrado (um talento, passivo) no 25: Cura Célere em outra pessoa cura você pela metade. Os níveis de talento aqui são os mais cedo possíveis; uma vantagem pode adiantá-los em até 5 níveis.
- 30: Prece de Cura (**Shift-2**), Espírito Divino (bloco D). Espírito da Redenção (um talento, passivo). Depois Abolir Doença (**Shift-C**) no 32, Cura Espiritual (um talento, passivo) no 35.
- 40: Prece da Recomposição (**Ctrl-2**, um talento; você precisa de Espírito da Redenção antes): ela cura assim que o alvo leva dano, depois pula para outro membro do grupo, até 5 vezes; recarga de 10 segundos. Cura Maior assume o **C**.
- 50: graus mais fortes de Prece da Recomposição, Nova Sagrada, Prece de Cura e Renovar. Prece da Fortitude (**Shift-X**) no 48.
- 60: graus mais fortes de novo; nada novo para esta função.
**Erros de iniciante:**
- Prece de Cura no jogador errado. Ela cura o grupo do jogador que você escolhe, não o seu.
- Cura Célere para tudo. Ela é rápida mas cara; guarde para emergências.
- Nova Sagrada num grupo que está longe. Ela só funciona bem ao seu redor, e custa muito.]] },
			{ band = 3, title = "Sombra: dano à distância", body = [[
A partir do nível 4 (Palavra Sombria: Dor); Impacto Mental vem no 10. Açoite Mental é um talento, no mínimo nível 20; Forma de Sombra no 40. A maioria dos guias sobe de nível como Sombra; alguns jogam Disciplina até o 40. No começo, sua varinha faz boa parte do trabalho. Sombra não tem feitiço que atinge vários inimigos de uma vez. Um **DoT** é dano em pedacinhos ao longo de alguns segundos. Um **feitiço canalizado** continua enquanto você fica parado.
**Ordem simples:**
1. Palavra de Poder: Escudo (**Z**) em você mesmo, se o inimigo vai chegar até você.
2. Impacto Mental (**3**) de longe, para começar.
3. Palavra Sombria: Dor (**2**).
4. Peste Devoradora (**Shift-3**, a partir do 20) num inimigo que vai viver um tempo.
5. Açoite Mental (**1**, a partir do 20), e deixe ele ir até o fim. Antes disso: Punição (**1**).
6. Termine com sua varinha (**5**).
Pouca mana? Pule Peste Devoradora e Açoite Mental, e use sua varinha mais cedo. A partir do 32: Palavra Sombria: Morte (**Shift-4**) só quando ela vai matar o inimigo. A partir do 40: Forma de Sombra (**Ctrl-1**) ligada antes de puxar o primeiro inimigo, e deixe ligada.
**A cada 10 níveis:**
- 10: Impacto Mental (**3**), recarga de 8 segundos. Você já tem Punição (**1**), Palavra Sombria: Dor (**2**), Palavra de Poder: Escudo (**Z**), Desvanecer (**F**) e sua varinha (**5**). Depois Fogo Interior (**Shift-Z**) no 12, Grito Psíquico (**V**) no 14.
- 20: Açoite Mental (um talento): assume a tecla **1** no lugar de Punição. Peste Devoradora (**Shift-3**): um DoT que também cura você; recarga de 24 segundos. Depois Abraço Vampírico (**Ctrl-3**, um talento) no 25 ou 30: seu grupo é curado em 20% do seu dano de Sombra. Os níveis de talento aqui são os mais cedo possíveis; uma vantagem pode adiantá-los em até 5 níveis.
- 30: Silêncio (**E**, um talento): sua **interrupção** (ela para o feitiço de um inimigo); recarga de 45 segundos. Controle Mental (**Shift-F**). Depois Palavra Sombria: Morte (**Shift-4**) no 32, Levitar (**R**) no 34.
- 40: Forma de Sombra (**Ctrl-1**, um talento; você precisa de Abraço Vampírico antes): 10% mais dano de Sombra, feitiços de Sombra custam metade, 15% menos dano físico recebido, mas nada de feitiços de cura. Antes disso: Trevas (um talento, passivo) no 35.
- 50: graus mais fortes de Açoite Mental, Impacto Mental, Palavra Sombria: Dor, Peste Devoradora e Palavra Sombria: Morte. Prece da Fortitude (**Shift-X**) no 48.
- 60: graus mais fortes de Açoite Mental e Peste Devoradora; nada novo para esta função.
**Erros de iniciante:**
- Palavra Sombria: Morte num inimigo com muita vida. Se ele não morrer, você perde 30% da sua própria vida.
- Parar Açoite Mental cedo. Com o talento Açoite Mental Aprimorado, o último tique é o mais forte.
- Abrir com Impacto Mental num grupo. Ele causa muita ameaça (o quanto um inimigo quer atacar você): deixe o tanque ir primeiro. Se um inimigo atacar você: Desvanecer (**F**).]] },
		},
		ROGUE = {
			{ band = 1, title = "Assassinato: adagas e veneno", body = [[
A partir do nível 1 (Golpe Sinistro e Eviscerar). Você luta de perto, com adagas e veneno. Você usa **Energia**, que enche sozinha. Seus golpes dão **Pontos de Combo** (até 5) no inimigo que você acerta; um **finalizador** gasta todos eles. Mutilar é um talento, no mínimo nível 40, e precisa de uma adaga em cada mão. Até lá você joga com Punhalada pelas Costas ou Golpe Sinistro. Os guias não dizem que este é o começo mais fácil: o grande passo só vem com Mutilar.
**Ordem simples:**
1. A partir do 20: veneno nas duas armas (itens, no bloco D).
2. Espere a Energia cheia. A partir do 18 (Presteza), seu primeiro ataque então custa 10 de Energia a menos.
3. Furtividade (**Shift-R**), vá para trás do inimigo. **Furtividade** = andar escondido, para o inimigo não ver você. Abra com Emboscar (**2**, a partir do 18, adaga na mão principal) ou Garrote (**1**, a partir do 14). Inimigo forte, a partir do 26: Golpe Baixo (**V**), um atordoamento de 4 segundos.
4. Pontos de Combo: Punhalada pelas Costas (**2**) quando você está atrás do inimigo, senão Golpe Sinistro (**1**). A partir do 40: Mutilar (**3**), 2 pontos cada vez.
5. Estocar (**Shift-3**, a partir do 24) sempre que estiver pronto. Com Peçonha (a partir do 30), cada Estocar deixa seu veneno mais forte por 6 segundos.
6. Finalizador: Retalhar (**Shift-4**) numa luta longa; senão Eviscerar (**4**) com 5 pontos. Ruptura (**5**, a partir do 20) num inimigo que vai viver muito (um elite, um chefe).
7. Sangue Frio (**F1**, a partir do 25) logo antes de um Eviscerar com 5 pontos.
**A cada 10 níveis:**
- 10: você já tem Golpe Sinistro (**1**), Eviscerar (**4**), Punhalada pelas Costas (**2**), Furtividade (**Shift-R**), Esfaquear (**Shift-Q**) e Evasão (**Z**). Novo no 10: Retalhar (**Shift-4**), Disparada (**R**), Aturdir (**Shift-Q** na Furtividade), e uma arma em cada mão (Empunhar Duas Armas). Depois Chute (**E**) no 12, Garrote (**1** na Furtividade) e Expor Armadura (**Shift-Z**) no 14, Finta (**F**) no 16, Emboscar (**2** na Furtividade) e Presteza (passivo) no 18.
- 20: Ruptura (**5**). Venenos, de uma missão. Depois Sumir (**X**) no 22, Estocar (**Shift-3**) no 24, Sangue Frio (**F1**, um talento) no 25: seu próximo Golpe Sinistro, Punhalada pelas Costas, Emboscar, Eviscerar ou Mutilar com certeza é crítico (**crítico** = um golpe de sorte, mais forte); recarga de 3 minutos. Golpe Baixo (**V** na Furtividade) no 26. Os níveis de talento aqui são os mais cedo possíveis; uma vantagem pode adiantá-los em até 5 níveis.
- 30: Peçonha (um talento, passivo: sem tecla): cada Estocar dá ao seu veneno 30% mais dano e 20% mais chance de acertar, por 6 segundos. Golpe no Rim (**V**). Depois Cegar (**Shift-V**) no 34, Selar o Destino (um talento, passivo) no 35: um crítico com um ataque que dá Pontos de Combo dá a você um ponto extra.
- 40: Mutilar (**3**, um talento; você precisa de Peçonha antes): 60 de Energia, acerta com as duas adagas, 2 Pontos de Combo, 20% mais dano num inimigo envenenado. Depois Retalhar Grau 2 no 42, Estocar Grau 2 no 44.
- 50: Mutilar Grau 2 e Golpe no Rim Grau 2; nada novo para esta função.
- 60: Mutilar Grau 3 e graus mais fortes; nada novo para esta função.
**Erros de iniciante:**
- Mutilar sem adagas. Ele precisa de uma adaga em cada mão: consiga sua segunda adaga antes do nível 40.
- Esquecer Estocar. Peçonha só funciona por meio de Estocar.
- Trocar para outro inimigo com Pontos de Combo no antigo. Os pontos não vão junto.]] },
			{ band = 2, title = "Combate: dano constante com qualquer arma", body = [[
A partir do nível 1 (Golpe Sinistro e Eviscerar). Você não precisa ficar atrás do inimigo: seu golpe principal é Golpe Sinistro. Ele funciona com qualquer arma de uma mão: espada, machado, maça, arma de punho ou adaga. Vários guias dizem que Combate é a árvore mais fácil para subir de nível sozinho. Eles aconselham uma arma lenta na mão principal e uma rápida na outra mão. Você usa **Energia**, que enche sozinha; seus golpes dão **Pontos de Combo**, e um **finalizador** gasta eles. Rajada de Lâminas (no mínimo 30) é a única coisa que um Ladino tem contra dois inimigos de uma vez.
**Ordem simples:**
1. Espere a Energia cheia (Presteza, a partir do 18).
2. Abra da Furtividade (**Shift-R**) com Garrote (**1**, a partir do 14), ou a partir do 26 com Golpe Baixo (**V**). Só chegar e atacar também serve.
3. Golpe Sinistro (**1**) para Pontos de Combo.
4. Ripostar (**Shift-F1**, a partir do 20) assim que acender: isso acontece depois de você aparar um ataque.
5. Estocar (**Shift-3**, a partir do 24) quando estiver pronto.
6. Finalizador: Retalhar (**Shift-4**) numa luta longa; senão Eviscerar (**4**) com 5 pontos. Os guias divergem sobre quão cedo manter Retalhar ativo.
7. Dois inimigos: Rajada de Lâminas (**Shift-1**, a partir do 30). A partir do 40, junto com Adrenalina (**Q**) para uma luta difícil. Perdendo? Evasão (**Z**).
**A cada 10 níveis:**
- 10: você já tem Golpe Sinistro (**1**), Eviscerar (**4**), Furtividade (**Shift-R**), Esfaquear (**Shift-Q**) e Evasão (**Z**). Novo no 10: Retalhar (**Shift-4**), Disparada (**R**), Aturdir (**Shift-Q** na Furtividade), e uma arma em cada mão. Depois Chute (**E**) no 12, Garrote (**1** na Furtividade) e Expor Armadura (**Shift-Z**) no 14, Finta (**F**) no 16, Presteza (passivo) no 18.
- 20: Ripostar (**Shift-F1**, um talento; você precisa de Deflexão antes): só funciona logo depois de você aparar um ataque. 10 de Energia, e o inimigo fica desarmado por 6 segundos. Ruptura (**5**), e Venenos de uma missão. Depois Sumir (**X**) no 22, Estocar (**Shift-3**) no 24, Execução Impecável (um talento, passivo) no 25: Eviscerar custa 15 de Energia a menos. Golpe Baixo (**V** na Furtividade) no 26. Os níveis de talento aqui são os mais cedo possíveis; uma vantagem pode adiantá-los em até 5 níveis.
- 30: Rajada de Lâminas (**Shift-1**, um talento): por 15 segundos você ataca 20% mais rápido, e cada golpe também atinge um segundo inimigo por perto; recarga de 2 minutos. Carnificina (um talento, passivo): um bônus que depende da sua arma. Golpe no Rim (**V**). Depois Cegar (**Shift-V**) no 34, Clarão de Aço (um talento, passivo) no 35: Estocar devolve até 15 de Energia extra e fica pronto até 2 segundos mais cedo.
- 40: Adrenalina (**Q**, um talento; você precisa de Rajada de Lâminas antes): por 15 segundos sua Energia enche duas vezes mais rápido; recarga de 5 minutos. Depois Retalhar Grau 2 no 42 (30% mais rápido em vez de 20%), Estocar Grau 2 no 44 (25 de Energia de volta em vez de 15).
- 50: Golpe no Rim Grau 2 e graus mais fortes; nada novo para esta função.
- 60: graus mais fortes; nada novo para esta função.
**Erros de iniciante:**
- Rajada de Lâminas perto de um inimigo que você tirou da luta com Aturdir, Esfaquear ou Cegar. Os golpes extras acordam ele.
- Apertar Ripostar quando nada foi aparado. Só funciona logo depois de aparar.
- Punhalada pelas Costas ou Emboscar com espada, machado ou maça. Os dois precisam de uma adaga na mão principal.]] },
			{ band = 3, title = "Subterfúgio: atacar da Furtividade", body = [[
A partir do nível 1 (Golpe Sinistro e Furtividade). Esta árvore luta a partir da Furtividade: um primeiro golpe forte, e muitos Pontos de Combo antes de a luta começar de verdade. **Furtividade** = andar escondido, para o inimigo não ver você. Os guias dizem que subir de nível sozinho é mais lento que com Combate. Hemorragia é um talento, no mínimo nível 30: barato, pela frente, com qualquer arma, mas com uma adaga bate mais forte.Marca da Morte é um talento, no mínimo nível 40. Emboscar e Punhalada pelas Costas precisam de uma adaga na mão principal; Hemorragia e Golpe Fantasmagórico não.
**Ordem simples:**
1. Furtividade (**Shift-R**). Um segundo Humanoide por perto? Aturdir (**Shift-Q**). Aturdir não quebra a Furtividade.
2. Premeditação (**Shift-C**, a partir do 20): 2 Pontos de Combo no inimigo. Depois seu primeiro golpe.
3. Primeiro golpe por trás: Emboscar (**2**, a partir do 18, adaga na mão principal). Inimigo forte, a partir do 26: Golpe Baixo (**V**), um atordoamento de 4 segundos. Os guias divergem sobre a melhor abertura.
4. Golpe Fantasmagórico (**Shift-X**, a partir do 25) e Estocar (**Shift-3**, a partir do 24) sempre que estiverem prontos.
5. Pontos de Combo: a partir do 30, Hemorragia (**3**). Antes disso: Punhalada pelas Costas (**2**) quando você está atrás do inimigo, senão Golpe Sinistro (**1**).
6. Finalizador: Eviscerar (**4**) quando o inimigo está quase morto; Ruptura (**5**) num inimigo que vai viver muito; Retalhar (**Shift-4**) numa luta longa.
7. A partir do 40: Marca da Morte (**Q**) no inimigo mais forte, de preferência enquanto Ruptura ou Garrote está ativo.
8. Emergência: Sumir (**X**). Preparação (**F3**, a partir do 30) deixa Sumir, Evasão e Disparada prontos de novo na hora.
**A cada 10 níveis:**
- 10: você já tem Golpe Sinistro (**1**), Eviscerar (**4**), Punhalada pelas Costas (**2**), Furtividade (**Shift-R**), Esfaquear (**Shift-Q**) e Evasão (**Z**). Novo no 10: Aturdir (**Shift-Q** na Furtividade), Retalhar (**Shift-4**), Disparada (**R**), e uma arma em cada mão. Depois Chute (**E**) no 12, Garrote (**1** na Furtividade) no 14, Finta (**F**) no 16, Emboscar (**2** na Furtividade) e Presteza (passivo) no 18.
- 20: Premeditação (**Shift-C**, um talento): 2 Pontos de Combo no seu alvo; use-os em 20 segundos, ou eles somem; recarga de 2 minutos. Ruptura (**5**), e Venenos de uma missão. Depois Sumir (**X**) no 22, Estocar (**Shift-3**) no 24, Golpe Fantasmagórico (**Shift-X**, um talento) no 25: 40 de Energia, 1 Ponto de Combo, 15% mais esquiva por 7 segundos; recarga de 20 segundos. Golpe Baixo (**V** na Furtividade) no 26. Os níveis de talento aqui são os mais cedo possíveis; uma vantagem pode adiantá-los em até 5 níveis.
- 30: Hemorragia (**3**, um talento; você precisa de Lâminas Serrilhadas antes): 35 de Energia, 1 Ponto de Combo, funciona pela frente; por 15 segundos sua Ruptura e seu Garrote causam 15% mais dano a esse inimigo. Preparação (**F3**, um talento): deixa a recarga dos seus outros feitiços de Ladino pronta na hora; a recarga dela mesma é de 10 minutos. Você pega um destes dois no 30, o outro no 31. Golpe no Rim (**V**). Depois Cegar (**Shift-V**) no 34, Faca de Bota (um talento, passivo) no 35: Estocar pode dar 2 Pontos de Combo.
- 40: Marca da Morte (**Q**, um talento; você precisa de Preparação antes): um finalizador, 25 de Energia, recarga de 10 segundos. Por 6 segundos ela guarda parte do seu dano (mais por Ponto de Combo), depois causa tudo de uma vez, até um limite. O dano de Ruptura e Garrote conta em dobro. Depois Retalhar Grau 2 e Sumir Grau 2 no 42, Estocar Grau 2 no 44, Marca da Morte Grau 2 no 48.
- 50: Golpe no Rim Grau 2, Marca da Morte Grau 3 no 56; nada novo para esta função.
- 60: Marca da Morte Grau 4 e graus mais fortes; nada novo para esta função.
**Erros de iniciante:**
- Emboscar ou Punhalada pelas Costas sem adaga na mão principal, ou pela frente.
- Usar Premeditação e depois esperar. Os 2 pontos somem depois de 20 segundos, e a recarga é de 2 minutos.
- Marca da Morte sem Pontos de Combo. É um finalizador.]] },
		},
		HUNTER = {
			{ band = 1, title = "Domínio das Feras: dano com seu ajudante", body = [[
A partir do nível 10 (seu ajudante, das missões de classe). Seu ajudante faz a maior parte do trabalho: ele mantém o inimigo ocupado enquanto você atira de longe. A maioria dos guias escolhe Domínio das Feras para subir de nível: eles dizem que é o mais fácil e o mais rápido. O Wowhead acrescenta que as três árvores funcionam. Novo no Forever: Evocar Falcão (um talento, no mínimo nível 25) manda pássaros extras no seu alvo. Ponto fraco: grupos de inimigos. Seu ajudante só consegue segurar um.
**Ordem simples:**
Antes de começar: Aspecto do Falcão ligado (**Shift-R**). O talento Aspectos Mortais só funciona assim.
1. Marca do Caçador (**Shift-Z**).
2. Ajudante na frente (**Ctrl-1**), e espere até ele pegar o inimigo.
3. Picada de Serpente (**2**).
4. Evocar Falcão (**Shift-F1**, a partir do 25): mantenha 2 falcões o tempo todo.
5. Tiro Certo (**4**, a partir do 20) enquanto você fica parado. Dois ou mais inimigos: Tiro Múltiplo (**Shift-1**) em vez disso. Eles compartilham uma recarga.
6. Tiro Automático (**1**) continua. Tiro Arcano (**3**): antes do 25, é só usar. A partir do 25, só quando você já tem 2 falcões: ele compartilha uma recarga com Evocar Falcão.
7. Ajudante quase morto: Curar Ajudante (**F2**). Inimigo em você: Intimidação (**Shift-3**, a partir do 30) ou Desvencilhar (**Z**, a partir do 20). Desvencilhar não é um salto: ele faz o inimigo querer menos você, de perto, e para seu ataque automático. Apuros de verdade: Fingir de Morto (**X**, a partir do 30).
8. Inimigo difícil: Ira Bestial (**F1**, a partir do 40) junto com Tiro Rápido (**Q**, a partir do 26).
**A cada 10 níveis:**
- 10: seu ajudante, das missões de classe. Aspecto do Falcão (**Shift-R**). Primeiros talentos: Aspectos Mortais, Treinamento de Resistência. Os níveis de talento aqui são os mais cedo possíveis; uma vantagem pode adiantá-los em até 5 níveis. Depois Curar Ajudante (**F2**) no 12, Tiro Múltiplo (**Shift-1**) no 18.
- 20: Tiro Certo (**4**, do treinador), Aspecto do Guepardo (**R**), Desvencilhar (**Z**), Armadilha Congelante (**V**). Talentos: Rapidez Bestial (seu ajudante corre 30% mais rápido; você precisa dela para Intimidação), Fúria Liberada, Desbravamento.
- 30: Intimidação (**Shift-3**, um talento): seu ajudante atordoa o inimigo por 3 segundos com o próximo golpe; recarga de 1 minuto. Fingir de Morto (**X**). Antes disso: Evocar Falcão (**Shift-F1**, um talento) no 25: um falcão fica 18 segundos, no máximo 2 por vez. Tiro Rápido (**Q**) no 26.
- 40: Ira Bestial (**F1**, um talento; todos os 30 pontos antes dela precisam estar em Domínio das Feras): seu ajudante causa 50% mais dano por 18 segundos; recarga de 2 minutos. Salva (bloco D). Antes disso: Armadilha Explosiva assume o **Shift-2** no 34, Frenesi (um talento, passivo) no 35.
- 50: graus mais fortes de Evocar Falcão, Tiro Certo e Curar Ajudante; nada novo para esta função. Depois do 40, os guias colocam seus pontos em Precisão.
- 60: graus mais fortes de novo; nada novo para esta função.
**Erros de iniciante:**
- Atirar antes de o seu ajudante pegar o inimigo. Aí o inimigo vem até você.
- Ver Evocar Falcão e Tiro Arcano como dois botões separados. Eles compartilham uma recarga: falcões primeiro.
- Lutar no Aspecto do Guepardo ou do Macaco. Aspectos Mortais só funciona com o Falcão ligado.]] },
			{ band = 2, title = "Precisão: dano à distância", body = [[
A partir do nível 1 (Tiro Automático). Seus próprios tiros fazem o trabalho, de longe. Tiro Certo vem no 20 do treinador: não é um talento. Tiro de Franco-atirador é um talento, no mínimo nível 40: 4 segundos de conjuração, com alcance de até 45 jardas. Os guias dizem que subir de nível funciona, mas mais devagar que Domínio das Feras: seu ajudante segura o inimigo pior, porque você causa mais dano. Em grupos ele é forte: Aura de Tiro Certeiro ajuda seu grupo ou raide inteiro. Lobo Solitário (um talento, no mínimo nível 20) dá 20% mais dano enquanto você não tem ajudante; para subir de nível, os guias ficam com o ajudante.
**Ordem simples:**
Antes de começar: Aspecto do Falcão (**Shift-R**) e Aura de Tiro Certeiro (**Shift-X**, a partir do 25) ligados.
1. Marca do Caçador (**Shift-Z**). Com ajudante: ajudante na frente (**Ctrl-1**).
2. Inimigo ainda longe: Tiro de Franco-atirador (**Shift-4**, a partir do 40) para abrir.
3. Picada de Serpente (**2**). Alguns guias pulam ela em lutas curtas.
4. Tiro Certo (**4**, a partir do 20) toda vez que estiver pronto. Fique parado.
5. Tiro Arcano (**3**) no meio, se sua mana permitir.
6. Tiro Automático (**1**) continua.
7. Um grupo de inimigos: Tiro Múltiplo (**Shift-1**) em vez de Tiro Certo. Um grupo grande: Salva (bloco D, a partir do 40).
8. Inimigo em você: Tiro de Dispersão (**E**, a partir do 30), depois afaste-se. Tiro de Concussão (**Shift-Q**) deixa ele lento.
9. Inimigo difícil: Tiro Rápido (**Q**, a partir do 26) no começo.
**A cada 10 níveis:**
- 10: seu ajudante, das missões de classe. Aspecto do Falcão (**Shift-R**). Primeiros talentos: Ataques Letais, Olho de Águia, Tiro de Concussão Aprimorado; a partir do 15: Mira Cuidadosa, Eficiência, Picadas Aprimoradas. Os níveis de talento aqui são os mais cedo possíveis; uma vantagem pode adiantá-los em até 5 níveis. Depois Tiro Múltiplo (**Shift-1**) no 18.
- 20: Tiro Certo (**4**), do treinador: 2 segundos de conjuração, recarga de 6 segundos, compartilhada com Tiro Múltiplo. Talentos: Matança Veloz, Tiro Arcano Aprimorado, Lobo Solitário. Aspecto do Guepardo (**R**), Desvencilhar (**Z**), Armadilha Congelante (**V**).
- 30: Tiro de Dispersão (**E**, um talento): o inimigo fica confuso por 4 segundos, e qualquer dano quebra o efeito; recarga de 30 segundos. Fingir de Morto (**X**). Antes disso: Aura de Tiro Certeiro (**Shift-X**, um talento) no 25: mais Poder de Ataque de Longo Alcance para o seu grupo, por 30 minutos. Tiro Rápido (**Q**) no 26.
- 40: Tiro de Franco-atirador (**Shift-4**, um talento; você precisa de Aura de Tiro Certeiro antes): recarga de 15 segundos, e seus próximos 3 tiros alcançam 10 jardas mais longe. Salva (bloco D). Antes disso: Aura de Tiro Certeiro Grau 2 no treinador no 32, Especialização em Arma de Longo Alcance (um talento, passivo) no 35.
- 50: graus mais fortes: Tiro Certo no 44 e no 52, Tiro de Franco-atirador no 48, Aura de Tiro Certeiro e Salva no 50. Depois do 40, os guias colocam seus pontos em Domínio das Feras.
- 60: graus mais fortes de novo; nada novo para esta função.
**Erros de iniciante:**
- Se mover durante Tiro Certo ou Tiro de Franco-atirador. Eles têm 2 e 4 segundos de conjuração.
- Tiro Múltiplo em um inimigo. Aí Tiro Certo também fica fora por 6 segundos.
- Tiro de Franco-atirador quando o inimigo já está em você. São 4 segundos de conjuração, e ele não funciona a menos de 8 jardas.]] },
			{ band = 3, title = "Sobrevivência: dano de perto, com armadilhas", body = [[
A partir do nível 1 (Golpe do Raptor), mas o jogo de Sobrevivência de verdade começa por volta do 30. No Forever, este é o Caçador corpo a corpo: Golpe do Raptor, Mordida de Mangusto, Contra-ataque e Chute de Moa, mais armadilhas. Você fica com seu ajudante e sua arma de longo alcance: abra de longe, depois chegue perto. Os guias dizem que é a mais lenta das três para subir de nível; até mais ou menos o 30 você joga como qualquer Caçador (ajudante na frente, atirar). Ela custa muita mana, e um golpe grande seu pode tirar o inimigo do seu ajudante. Os guias não concordam sobre qual arma corpo a corpo é a melhor.
**Ordem simples:**
Antes de começar: Aspecto do Falcão (**Shift-R**) enquanto você atira. A partir do 30, Aspecto da Fera para lutar de perto; ele não tem tecla fixa, então coloque numa barra sua.
1. Marca do Caçador (**Shift-Z**). Sem a Marca, Expor Presa não funciona.
2. Ajudante na frente (**Ctrl-1**).
3. Picada de Serpente (**2**), depois Tiro Arcano (**3**) enquanto o inimigo vem, ou enquanto você anda até ele.
4. Uma armadilha aos seus pés: Armadilha Imolante (**Shift-2**, a partir do 16). A partir do 34 essa tecla é Armadilha Explosiva, e Armadilha Imolante não tem tecla: coloque numa barra sua se quiser.
5. De perto: Mordida de Mangusto (**Shift-C**, a partir do 16) assim que acender. Golpe do Raptor (**5**) toda vez que estiver pronto. Chute de Moa (a partir do 30) toda vez que estiver pronto; coloque numa barra sua. Os guias divergem: alguns se afastam para atirar depois de Chute de Moa, outros ficam perto.
6. Contra-ataque (**Shift-V**) logo depois de aparar.
7. O inimigo foge, ou você quer distância de novo: Cortar Asas (**Shift-F**).
8. Em apuros: Coibição (**C**, a partir do 20), Fingir de Morto (**X**, a partir do 30).
**A cada 10 níveis:**
- 10: seu ajudante, das missões de classe. Golpe do Raptor (**5**) você tem desde o nível 1. Primeiros talentos: Rastreamento Aprimorado, Deflexão; a partir do 15: Golpes Selvagens, Sobrevivencialista, Cilada, Tosquiar Asas Aprimorado. Os níveis de talento aqui são os mais cedo possíveis; uma vantagem pode adiantá-los em até 5 níveis. Depois Cortar Asas (**Shift-F**) no 12, Mordida de Mangusto (**Shift-C**) e Armadilha Imolante (**Shift-2**) no 16.
- 20: Coibição (**C**, um talento): 25% mais esquiva e aparo por 10 segundos; recarga de 5 minutos. Armadilha Congelante (**V**), Tiro Certo (**4**), Empunhar Duas Armas (passivo, treinador). Desvencilhar (**Z**): não é um salto; ele diminui sua **ameaça** (o quanto um inimigo quer atacar você) de perto, e para seu ataque automático. Talentos: Firmeza, Armadilhas Espertas.
- 30: Chute de Moa (um talento; sem tecla fixa, coloque numa barra sua): 100% de dano da arma, depois você corre 30% mais rápido por 3 segundos; recarga de 8 segundos. Aspecto da Fera (treinador; coloque numa barra sua): mais Poder de ataque corpo a corpo. Fingir de Morto (**X**). Antes disso: Contra-ataque (**Shift-V**, um talento), a partir do 25 ou 30 (as fontes divergem): ele fica ativo depois de você aparar, e prende o inimigo no lugar por 5 segundos. Gume do Predador (um talento, passivo) a partir do 25. Também nesta fileira: Expor Presa, Desenvoltura, Disciplina de Sobrevivencialista.
- 40: Ataques Lacerantes (um talento, passivo; você precisa de Expor Presa antes): Mordida de Mangusto também faz o inimigo sangrar. Antes disso: Armadilha Explosiva assume o **Shift-2** no 34, Reflexo Relâmpago (um talento, passivo) no 35.
- 50: graus mais fortes: Contra-ataque no 42 e no 54, Mordida de Mangusto no 44, Armadilha Explosiva no 44 e no 54, Golpe do Raptor no 48, Aspecto da Fera no 50. Os guias não concordam sobre onde vão seus pontos depois do 40.
- 60: graus mais fortes de novo; nada novo para esta função.
**Erros de iniciante:**
- Entrar correndo direto. Abra de longe (Marca, ajudante, Picada, um tiro), depois chegue perto.
- Apertar Mordida de Mangusto ou Contra-ataque quando eles não acendem. Mordida de Mangusto só funciona depois de uma esquiva (ou por meio de Expor Presa), Contra-ataque só depois de aparar.
- Ficar no Aspecto do Falcão de perto depois do nível 30. O Falcão só ajuda seus tiros; a Fera dá Poder de ataque corpo a corpo.]] },
		},
		SHAMAN = {
			{ band = 1, title = "Elemental: dano à distância", body = [[
A partir do nível 1: Raio está lá desde o começo. Raios e fogo de longe. Choque Flamejante vem no 10, Cadeia de Raios no 32. Maestria em Raio é um talento, no mínimo nível 40. Os guias sobem de nível como Aperfeiçoamento: Elemental funciona, mas o custo de mana é muito alto, você precisa ficar parado para lançar, e muitos inimigos de uma vez são difíceis.
**Ordem simples:**
Antes de começar: Escudo de Raios (**Shift-Z**, a partir do 8) ligado. Totem Calcinante (**5**, a partir do 10) no chão antes de puxar.
1. Abra de longe com Raio (**1**).
2. Choque Flamejante (**2**, a partir do 10) num inimigo que vai viver muito.
3. Raio (**1**) para preencher.
4. Três ou mais inimigos: Nova de Fogo (**Shift-4**, a partir do 12) e Cadeia de Raios (**Shift-1**, a partir do 32) quando estiverem prontas.
5. Maestria em Raio (**Q**, a partir do 40) para um elite ou um grupo grande.
6. Guarde Choque Terreno (**E**) para quando o inimigo lançar um feitiço: ele interrompe o feitiço.
Pouca vida: Onda Curativa (**C**). Inimigo perto demais: Totem de Prisão Terrena (**V**) ou Choque Gélido (**4**, a partir do 20).
**A cada 10 níveis:**
- 10: Raio (**1**), Choque Terreno (**E**, a partir do 4), Escudo de Raios (**Shift-Z**, a partir do 8). Choque Flamejante (**2**), Totem Calcinante (**5**, de uma missão). Primeiros talentos: Convecção, Concussão (passivo). Os níveis de talento aqui são os mais cedo possíveis; uma vantagem pode adiantá-los em até 5 níveis. Depois Nova de Fogo (**Shift-4**) e Expurgar (**Shift-Q**) no 12, Totem Sísmico (**Shift-F**) no 18.
- 20: Choque Gélido (**4**), Lobo Fantasma (**R**), Chamado dos Elementos (**Ctrl-1**). Concentração Elemental (um talento, passivo). Depois Chamado Totêmico (**Shift-R**) no 22. Prisão Terrena (um talento) no 25: Totem de Prisão Terrena (**V**) prende os inimigos no lugar por 5 segundos, só no momento em que você o coloca. Totem de Magma (bloco D) no 26.
- 30: Chamado do Trovão (um talento, passivo). Totem de Aterramento (**X**), Chamado dos Antepassados (**Ctrl-2**), Reencarnação (passivo). Raios Sobrecarregados (um talento, passivo). Depois Cadeia de Raios (**Shift-1**) no 32, Fúria Elemental (um talento, passivo) no 35.
- 40: Maestria em Raio (**Q**, um talento): por 15 segundos Raio é lançado 0,5 segundo mais rápido e Cadeia de Raios não tem recarga; recarga de 3 minutos. Chamado dos Espíritos (**Ctrl-3**), Cura Encadeada (**Shift-2**). Armadura de Malha no treinador.
- 50: graus mais fortes de Raio, Cadeia de Raios, Choque Terreno, Choque Flamejante, Nova de Fogo e Totem Calcinante; nada novo para esta função.
- 60: graus mais fortes de novo; nada novo para esta função.
**Erros de iniciante:**
- Choque Terreno por dano num grupo. Ele causa muita **ameaça** (o quanto um inimigo quer atacar você). E ele compartilha a recarga com Choque Flamejante: depois disso você fica sem interrupção.
- Cadeia de Raios em um inimigo. Custa muita mana e tem recarga de 6 segundos.
- Terminar cada inimigo com um feitiço. A mana é o seu limite: bata com a arma num inimigo que está quase morto.]] },
			{ band = 2, title = "Aperfeiçoamento: dano corpo a corpo", body = [[
A partir do nível 1: você bate com sua arma, com Arma Trinca-pedra nela. Os guias sobem de nível como Aperfeiçoamento: eles dizem que é a escolha confortável. Use uma arma lenta de duas mãos. Ataque da Tempestade é um talento, no mínimo nível 25; Arma de Fúria dos Ventos vem no 30 do treinador. A mana é o seu limite: quando ela fica baixa, pare de lançar e continue batendo. O conselho de um guia para o buff de arma: Arma Trinca-pedra sozinho, Arma de Labaredas em grupo, Arma de Fúria dos Ventos a partir do 30. Num grupo pequeno, Aperfeiçoamento pode tanquear por um tempo com Arma Trinca-pedra (Armas Espirituais então dá mais ameaça), mas não há provocação nem recarga defensiva.
**Ordem simples:**
Antes de começar: buff de arma ligado (bloco D), Escudo de Raios (**Shift-Z**), Totem Calcinante (**5**) ou seus totens no chão.
1. Puxe com Raio (**1**). **Puxar** = acertar um inimigo de longe, para ele vir até você.
2. Ataque da Tempestade (**3**, a partir do 25) sempre que estiver pronto.
3. Raio (**1**) com 5 acúmulos de Arma da Voragem (a partir do 35): aí ele é instantâneo e de graça.
4. Choque Terreno (**E**). Em grupo, alterne com Choque Flamejante (**2**).
5. Nova de Fogo (**Shift-4**, a partir do 12) quando um totem de Fogo está no chão e sobra mana; mais contra vários inimigos.
6. Fúria do Clarividente (**Q**, a partir do 40) para um elite ou uma puxada grande.
7. Fora isso, só continue batendo.
Depois da luta: Onda Curativa (**C**). Emergência durante a luta: Onda Curativa Menor (**F2**, a partir do 20).
**A cada 10 níveis:**
- 10: Arma Trinca-pedra (bloco D), Raio (**1**), Choque Terreno (**E**, a partir do 4), Escudo de Raios (**Shift-Z**, a partir do 8). Choque Flamejante (**2**), Totem Calcinante (**5**), Totem da Força da Terra (**Shift-X**), Arma de Labaredas (bloco D). Primeiros talentos: Golpes Trovejantes e outros (passivos); Destreza Mental (passivo) a partir do 15. Os níveis de talento aqui são os mais cedo possíveis; uma vantagem pode adiantá-los em até 5 níveis. Depois Nova de Fogo (**Shift-4**) no 12.
- 20: Lobo Fantasma (**R**), Choque Gélido (**4**), Onda Curativa Menor (**F2**), Chamado dos Elementos (**Ctrl-1**). Concentração Xamanística (um talento, passivo): Choques e Escudo de Raios custam 45% menos mana. Depois Ataque da Tempestade (**3**, um talento) no 25. Ímpeto (um talento, passivo) a partir do 25. Lobo Fantasma Aprimorado (um talento) a partir do 25: Lobo Fantasma fica mais rápido (instantâneo com os dois pontos) e também funciona em lugares fechados; os guias pegam ele em níveis bem diferentes. Totem de Magma (bloco D) no 26.
- 30: Arma de Fúria dos Ventos (bloco D). Ataque da Tempestade Aprimorado e Armas Espirituais (talentos). Totem de Aterramento (**X**), Chamado dos Antepassados (**Ctrl-2**). Depois Totem de Fúria dos Ventos no 32 (sem tecla: use a Barra de totens), Cadeia de Raios (**Shift-1**) no 32, Arma da Voragem (um talento, passivo) no 35.
- 40: Fúria do Clarividente (**Q**, um talento): você bate 30% mais rápido por 25 segundos; só os golpes da arma, não seus feitiços. Recarga de 3 minutos. Nem todo guia pega ela no 40: alguns vão primeiro para Restauração, por mana. Chamado dos Espíritos (**Ctrl-3**), armadura de Malha, uma Arma de Fúria dos Ventos mais forte. Depois Totem da Graça do Ar no 42 (sem tecla: use a Barra de totens).
- 50: graus mais fortes de Arma de Fúria dos Ventos, Arma Trinca-pedra, Choque Terreno, Raio e Totem da Força da Terra; nada novo para esta função.
- 60: graus mais fortes de novo; nada novo para esta função.
**Erros de iniciante:**
- Raio com menos de 5 acúmulos de Arma da Voragem. Ele reinicia o tempo do seu golpe. E Arma da Voragem só ajuda Raio: não as curas, não Cadeia de Raios.
- Arma Trinca-pedra em grupo enquanto você causa o dano, depois de ter Armas Espirituais. Com Trinca-pedra você gera 30% mais ameaça, sem ela 30% menos. Use Labaredas ou Fúria dos Ventos.
- Procurar uma provocação. O Xamã não tem. Totem da Garra de Pedra (**F**) faz os inimigos atacarem o totem, não você.]] },
			{ band = 3, title = "Restauração: curandeiro", body = [[
A partir do nível 1: Onda Curativa está lá desde o começo, e é sua cura principal enquanto você sobe de nível. Os guias não aconselham subir de nível sozinho como Restauração (os inimigos morrem devagar), mas ela é boa em grupo. Entre masmorras, você faz missões com Raio e Choque Flamejante. Contracorrente é um talento, no mínimo nível 40. Um Xamã pode remover Veneno e Doença, mas não maldições nem magia.
**Ordem simples (em grupo):**
Antes de começar: Escudo de Água (**Shift-Z**, a partir do 20). Totens no chão: Chamado dos Elementos (**Ctrl-1**, a partir do 20) ou Totem de Torrente Curativa (**F4**, a partir do 20).
1. Contracorrente (**Shift-F1**, a partir do 40) no tanque ou em quem leva dano.
2. Cura Encadeada (**Shift-2**, a partir do 40) nesse mesmo alvo quando mais pessoas estão feridas.
3. Onda Curativa (**C**) para uma pessoa ou o tanque.
4. Onda Curativa Menor (**F2**, a partir do 20) quando precisa ser rápido.
5. Emergência: Rapidez da Natureza (**Shift-3**, a partir do 30), depois Onda Curativa (**C**).
6. Totem de Vagalhão de Mana (**F1**, a partir do 25) quando sua mana acaba.
7. Ninguém ferido: Raio (**1**).
**A cada 10 níveis:**
- 10: Onda Curativa (**C**). Primeiros talentos: Onda Curativa Aprimorada (uma Onda Curativa mais rápida), Concentração das Marés (passivo). Os níveis de talento aqui são os mais cedo possíveis; uma vantagem pode adiantá-los em até 5 níveis. Depois Espírito Ancestral (**F3**, fora de combate) no 12, Curar Veneno (**Shift-C**) no 16, Totem Sísmico (**Shift-F**) no 18.
- 20: Onda Curativa Menor (**F2**), Totem de Torrente Curativa (**F4**, de uma missão), Chamado dos Elementos (**Ctrl-1**), Lobo Fantasma (**R**). Escudo de Água (**Shift-Z**, um talento): 3 esferas de água; quando você leva um golpe ou um dos seus feitiços é crítico, você recupera 2% da sua mana por esfera. Dura 10 minutos. A partir daí o Shift-Z lança Escudo de Água, não Escudo de Raios. Depois Curar Doença (**Shift-V**) no 22. Totem de Vagalhão de Mana (**F1**, um talento) no 25: devolve mana ao seu grupo; recarga de 5 minutos. Totem de Fonte de Mana no 26 (sem tecla: use a Barra de totens).
- 30: Rapidez da Natureza (**Shift-3**, um talento): seu próximo feitiço de Natureza com conjuração abaixo de 10 segundos é instantâneo; recarga de 3 minutos. Caminho da Cura (um talento, passivo). Totem de Aterramento (**X**), Chamado dos Antepassados (**Ctrl-2**), Reencarnação (passivo). Depois Purificação (um talento, passivo) no 35, um Totem de Vagalhão de Mana mais forte no 38.
- 40: Cura Encadeada (**Shift-2**). Contracorrente (**Shift-F1**, um talento; você precisa de Caminho da Cura antes): uma cura ao longo de 15 segundos, não uma cura instantânea, e uma Cura Encadeada que você lança direto nesse alvo cura 25% mais; recarga de 12 segundos. Chamado dos Espíritos (**Ctrl-3**), armadura de Malha.
- 50: graus mais fortes de Contracorrente, Cura Encadeada, Onda Curativa, Onda Curativa Menor, Totem de Vagalhão de Mana e Totem de Torrente Curativa; nada novo para esta função.
- 60: graus mais fortes de novo; nada novo para esta função.
**Erros de iniciante:**
- Cura Encadeada em alguém que não é o alvo da sua Contracorrente. O bônus só conta quando você lança direto nesse alvo.
- Apertar só Rapidez da Natureza. Ela não cura nada sozinha: ela deixa seu próximo feitiço de Natureza instantâneo. Aperte Onda Curativa logo depois.
- Tentar remover uma maldição. Um Xamã não pode; só Veneno (**Shift-C**) e Doença (**Shift-V**).]] },
		},
		WARLOCK = {
			{ band = 1, title = "Suplício: dano ao longo do tempo", body = [[
A partir do nível 4 (Corrupção) e 8 (Ruína da Agonia). Você coloca DoTs no inimigo e deixa seu demônio segurá-lo. A maioria dos guias sobe de nível como Suplício. Sifão de Vida é um talento, no mínimo nível 30. Destruição é um talento, no mínimo nível 40: enquanto você o canaliza, seu Sifão de Vida, sua Corrupção e sua Ruína da Agonia nesse inimigo tiquetam 100% mais rápido. Destruição não cura você.
**Ordem simples:**
1. Mande seu demônio entrar (**Ctrl-1**).
2. Ruína da Agonia (**5**) para puxar. O dano dela começa baixo, então seu demônio pega o inimigo.
3. Corrupção (**2**). Com Corrupção Aprimorada 5/5 ela é instantânea (no mínimo 14).
4. Sifão de Vida (**F4**, a partir do 30), só num inimigo que vai viver muito.
5. Imolação (**3**) só num inimigo difícil.
6. Inimigo difícil: coloque também sua maldição (**Shift-V**). Os guias divergem sobre quão cedo.
7. Para preencher: até mais ou menos o nível 30, sua varinha (Atirar; não está no bloco, coloque numa barra sua), depois Drenar Vida (**C**). Os guias divergem um pouco sobre quando trocar.
8. Transe Sombrio acendeu (Martelo do Ocaso, a partir do 25)? Seta Sombria (**1**): aí ela é instantânea.
9. A partir do 40: Destruição (bloco D) em vez de Drenar Vida quando sua vida está boa. Coloque seus DoTs primeiro.
10. Mais vida que mana? Conversão de Vida (**F**).
11. Precisa de um Estilhaço de Alma? Termine o inimigo com Drenar Alma (**4**).
Dois inimigos: DoTs no primeiro, Medo (**V**) nele, depois lute com o segundo. Dano pode quebrar o Medo, e os guias divergem sobre DoTs antes do Medo.
**A cada 10 níveis:**
- 10: Drenar Alma (**4**), Criar Pedra de Vida (bloco D), o Emissário do Caos (missão). Você já tem Seta Sombria (**1**), Imolação (**3**), Corrupção (**2**, 4), Maldição da Fraqueza (**Shift-V**, 4), Conversão de Vida (**F**, 6), Ruína da Agonia (**5**, 8) e Medo (**V**, 8). Primeiro talento: Corrupção Aprimorada ou Supressão (os guias divergem). Os níveis de talento aqui são os mais cedo possíveis; uma vantagem pode adiantá-los em até 5 níveis. Depois Funil de Vida (**F2**) no 12; Drenar Vida (**C**) e Corrupção Grau 2 (15 segundos) no 14; Drenagens Aprimoradas e Colheita de Almas (talentos, passivos) a partir do 15; Dor Lancinante (bloco D) e Criar Pedra da Alma no 18.
- 20: Amplificar Maldição (**Shift-3**, um talento): sua próxima Maldição da Fraqueza ou Ruína da Agonia é 50% mais forte; recarga de 3 minutos. Maldição dos Elementos (**Shift-V**), Armadura Demoníaca (**Shift-Z**), Chuva de Fogo (**Shift-1**), o Súcubo ou Íncubo (missão). Depois Corrupção Grau 3 (18 segundos) e Drenar Mana no 24. Maldição da Exaustão (**R**, um talento; você precisa de Amplificar Maldição antes) no 25: o inimigo fica 30% mais lento por 12 segundos. Martelo do Ocaso (um talento, passivo) no 25: uma pequena chance de sua próxima Seta Sombria ser instantânea. Banir (**Shift-Q**) no 28.
- 30: Sifão de Vida (**F4**, um talento): passa vida do inimigo para você, por 30 segundos. Sifão da Alma (um talento, passivo): Drenar Vida, Drenar Alma e Destruição causam mais para cada Corrupção, Sifão de Vida e Ruína da Agonia sua no inimigo. Drenar Vida Grau 3, Fogo do Inferno (**Shift-2**), o Caçador Vil (missão). Depois Proteção contra Sombra (**Z**) no 32, Maestria em Sombras (um talento, passivo) no 35, Sifão de Vida Grau 2 e Drenar Vida Grau 4 no 38.
- 40: Destruição (bloco D, um talento; você precisa de Sifão de Vida antes): um feitiço canalizado de 6 segundos que causa dano a cada segundo e faz seus DoTs nesse inimigo tiquetarem 100% mais rápido. Uivo do Terror (**Shift-F**), o Corcel Vil (missão). Depois Espiral da Morte (**X**) no 42, Fogo d'Alma (**Q**) e Sifão de Vida Grau 3 no 48.
- 50: Inferno (**F3**). Maldição dos Elementos Grau 4. Fora isso, graus mais fortes.
- 60: Ruína do Destino (**F1**): um golpe grande depois de 60 segundos; não em jogadores. Fora isso, graus mais fortes.
**Erros de iniciante:**
- Colocar Ruína da Agonia de novo cedo demais. Os tiques mais fortes dela vêm no fim.
- Usar Destruição quando você precisa de vida. Destruição não cura; Drenar Vida cura.
- Maldição da Temeridade no inimigo em que você quer usar Medo. Esse inimigo ignora Medo.]] },
			{ band = 2, title = "Demonologia: dano com seu demônio", body = [[
A partir do nível 1 (o Diabrete), de verdade a partir do 10 (o Emissário do Caos). Seu demônio faz boa parte do trabalho, e os talentos deixam ele mais forte. Os guias divergem sobre quando entrar nesta árvore: alguns entram a partir do 10, outros sobem de nível como Suplício primeiro e trocam por volta do 26 ou 27. Sacrifício Demoníaco (no mínimo 20) só vale a pena com Pacto Demoníaco (no mínimo 40). Antes disso, qualquer demônio que você evocar remove o buff.
**Ordem simples:**
1. Mande seu demônio entrar (**Ctrl-1**), e deixe ele bater primeiro.
2. A partir do 30: Vínculo Anímico (**Shift-X**) ligado, e de novo depois de cada evocação.
3. A partir do 25 (Marca Demoníaca): Dor Lancinante (bloco D) no inimigo do seu demônio. De novo quando a marca acabar (10 segundos). Antes de Marca Demoníaca: nada de Dor Lancinante.
4. Ruína da Agonia (**5**) e Corrupção (**2**) em inimigos que vivem o bastante. Corrupção tem 2 segundos de conjuração aqui.
5. Para preencher: sua varinha (não está no bloco, coloque numa barra sua) ou Seta Sombria (**1**). Drenar Vida (**C**) quando você precisa de vida.
6. Demônio quase morto: Funil de Vida (**F2**). Ele custa sua própria vida.
7. Conversão de Vida (**F**). Com Energias Demoníacas, seu demônio também ganha mana.
8. A partir do 40 (Pacto Demoníaco): Sacrifício Demoníaco (**Shift-C**) num demônio, depois evoque um diferente (bloco D). O buff dura 2 horas. Os guias divergem sobre qual demônio sacrificar.
9. A partir do 48, com Dizimação: inimigo abaixo de 35% de vida? Seta Sombria ou Dor Lancinante, depois Fogo d'Alma (**Q**): mais rápido, e sem Estilhaço de Alma.
**A cada 10 níveis:**
- 10: o Emissário do Caos (missão; custa 1 Estilhaço de Alma). O Tormento dele dá **ameaça** (o quanto um inimigo quer atacá-lo). Drenar Alma (**4**) para estilhaços. Primeiros talentos: Poder Profano, Abraço Demoníaco, Diabrete Aprimorado, Funil de Vida Aprimorado (passivos). Os níveis de talento aqui são os mais cedo possíveis; uma vantagem pode adiantá-los em até 5 níveis. Depois Funil de Vida (**F2**) no 12; Energias Demoníacas, Vitalidade Vil e Emissário do Caos Aprimorado (talentos, passivos) a partir do 15; Sacrificar (Emissário do Caos) no 16; Consumir Sombras (Emissário do Caos) e Dor Lancinante (bloco D) no 18.
- 20: Sacrifício Demoníaco (**Shift-C**, um talento): você sacrifica seu demônio por um buff de 2 horas. Diabrete: 15% mais dano de Sombra. Súcubo ou Íncubo: 15% mais dano de Fogo. Emissário do Caos: mana de volta. Caçador Vil: vida de volta. Mestre-evocador (um talento, passivo): evocações são mais rápidas e mais baratas. O Súcubo ou Íncubo (missão). Armadura Demoníaca (**Shift-Z**). Depois Sofrimento (Emissário do Caos) no 24. Dominância Vil (**Shift-F1**, um talento; você precisa de Mestre-evocador antes) no 25: sua próxima evocação é 5,5 segundos mais rápida e 50% mais barata. Marca Demoníaca e Dizimação (talentos, passivos) a partir do 25.
- 30: Vínculo Anímico (**Shift-X**, um talento; você precisa de Sacrifício Demoníaco antes): 30% do dano em você vai para o seu demônio, e vocês dois causam 3% mais dano. Dura enquanto seu demônio estiver lá. O Caçador Vil (missão; Bloquear Feitiço no 36). Conhecimento Demoníaco (um talento, passivo). Depois Mestre Demonologista (um talento, passivo) a partir do 35.
- 40: Pacto Demoníaco (um talento, passivo; você precisa de Vínculo Anímico antes): o buff de Sacrifício Demoníaco fica quando você evoca um demônio diferente. Só agora Sacrifício Demoníaco vale a pena. Uivo do Terror (**Shift-F**), o Corcel Vil (missão). Depois Espiral da Morte (**X**) no 42, Fogo d'Alma (**Q**) no 48.
- 50: Inferno (**F3**): um Infernal; 1 Pedra Infernal cada vez; recarga de 1 hora. Fora isso, graus mais fortes.
- 60: Ruína do Destino (**F1**). Fora isso, graus mais fortes.
**Erros de iniciante:**
- Dor Lancinante antes de você ter Marca Demoníaca. Ela causa muita ameaça e tira o inimigo do seu demônio.
- Sacrifício Demoníaco antes de Pacto Demoníaco (40). Seu demônio some, e evocar qualquer demônio remove o buff.
- Depois de Pacto Demoníaco, evocar o mesmo demônio que você sacrificou. Aí o buff some.]] },
			{ band = 3, title = "Destruição: dano com golpes grandes", body = [[
A partir do nível 1 (Seta Sombria e Imolação). Golpes grandes de fogo e de sombra, e é a que mais gasta mana. Alguns guias aconselham não subir de nível com ela (muita mana, pouco jeito de recuperá-la); outros dizem que dá para jogar, e um diz que ela é forte em masmorras. Conflagrar é um talento, no mínimo nível 25; Incinerar é um talento, no mínimo nível 40. A virada é Sombra e Chama 5/5 (no mínimo 39): a partir daí Conflagrar não consome mais sua Imolação, e Sombra Ardente sempre devolve seu Estilhaço de Alma.
**Ordem simples:**
1. Mande seu demônio entrar (**Ctrl-1**).
2. Imolação (**3**). Um guia abre com Seta Sombria de longe, com Imolação logo depois.
3. Inimigo difícil: Ruína da Agonia (**5**) e sua maldição (**Shift-V**).
4. A partir do 25: Conflagrar (bloco D). Antes de Sombra e Chama 5/5 ele consome sua Imolação: use no fim da Imolação, ou como último golpe. Depois disso: toda vez que estiver pronto.
5. Para preencher: Seta Sombria (**1**). A partir do 40, Incinerar (bloco D), com Imolação no inimigo.
6. A partir do 20: Sombra Ardente (**Shift-4**) como último golpe. Aí você recebe o Estilhaço de Alma de volta.
7. Conversão de Vida (**F**) entre as lutas. Pouca mana: sua varinha (não está no bloco, coloque numa barra sua).
8. Mais inimigos: a partir do 30, Ruína Devastadora (bloco D) num inimigo difícil, depois ataque o resto. Chuva de Fogo (**Shift-1**). Fogo do Inferno (**Shift-2**, a partir do 30) só com vida suficiente.
**A cada 10 níveis:**
- 10: Seta Sombria (**1**) e Imolação (**3**; Grau 2 no 10). Primeiro talento: Ruína (conjurações mais rápidas) ou Seta Sombria Aprimorada. Os níveis de talento aqui são os mais cedo possíveis; uma vantagem pode adiantá-los em até 5 níveis. Depois Seta Sombria Grau 3 no 12 (2,8 segundos de conjuração); Consequência e Cataclismo (talentos, passivos) a partir do 15; Dor Lancinante (bloco D) no 18.
- 20: Sombra Ardente (**Shift-4**, um talento): um golpe de Sombra instantâneo; custa 1 Estilhaço de Alma; recarga de 15 segundos. Se o inimigo (um que dá EXP) morrer em 8 segundos, você recebe um estilhaço de volta. Ruína (um talento, passivo): seus críticos de Destruição batem mais forte. Chuva de Fogo (**Shift-1**). Seta Sombria Grau 4 (3 segundos de conjuração). Depois Sombra Ardente Grau 2 no 24. Conflagrar (bloco D, um talento) no 25: um golpe de Fogo instantâneo num inimigo com sua Imolação; essa Imolação então some; recarga de 10 segundos. Chamas Agonizantes e Intensidade (talentos, passivos) a partir do 25.
- 30: Ruína Devastadora (bloco D, um talento): 5 minutos em um inimigo; 15% de todo o seu dano em outros inimigos também atinge este. Só um inimigo por vez. Fogo e Enxofre (você precisa de Conflagrar antes) e Piroclasma (você precisa de Intensidade antes), talentos, passivos. Fogo do Inferno (**Shift-2**). Depois Conflagrar Grau 2 e Sombra Ardente Grau 3 no 32; Sombra e Chama (um talento, passivo) a partir do 35, 5/5 no mínimo no 39.
- 40: Incinerar (bloco D, um talento; você precisa de Ruína Devastadora antes): 2,5 segundos de conjuração, 25% mais dano quando o inimigo tem sua Imolação. Conflagrar Grau 3, Sombra Ardente Grau 4. Depois Fogo d'Alma (**Q**) no 48.
- 50: Incinerar Grau 2. Inferno (**F3**).
- 60: Incinerar Grau 3, Conflagrar Grau 6. Ruína do Destino (**F1**).
**Erros de iniciante:**
- Conflagrar logo depois de Imolação. Ele consome sua Imolação (até Sombra e Chama 5/5).
- Sombra Ardente sem Estilhaço de Alma, ou num inimigo que vai viver muito. O estilhaço só volta se o inimigo morrer em 8 segundos.
- Ruína Devastadora e Ruína da Agonia no mesmo inimigo. Só cabe uma ruína nele.]] },
		},
		PALADIN = {
			{ band = 1, title = "Sagrado: curandeiro", body = [[
A partir do nível 1: Luz Sagrada está lá desde o começo. Um **curandeiro** mantém o grupo vivo. Os guias dizem que Sagrado é a árvore mais lenta para subir de nível sozinho: suba de nível como Retribuição e cure em masmorras, ou jogue Sagrado com um amigo. Os botões próprios da árvore vêm no 20 (Favorecimento Divino), 25 (Juramento de Luz), 30 (Choque Sagrado) e 40 (Luz Zelosa).
**Ordem simples (em grupo):**
Antes de puxar: Bênção de Sabedoria (**Shift-V**, a partir do 14) em você mesmo, Bênção dos Reis (**Shift-X**, a partir do 20) nos outros. Aura: Aura de Devoção (**Ctrl-1**), ou Aura de Concentração (**Ctrl-3**, a partir do 22) quando os conjuradores levam muitos golpes.
1. Juramento de Luz (**Shift-R**, a partir do 25) no tanque. Dura 1 hora, e só um jogador pode ter.
2. Clarão de Luz (**F2**, a partir do 20) é sua cura normal. Antes do 20: Luz Sagrada (**C**).
3. Luz Sagrada (**C**) para um golpe grande. A partir do 25 (Infusão de Luz), ela é lançada mais rápido logo depois de um crítico de Choque Sagrado ou Clarão de Luz. **Crítico** = um golpe ou uma cura de sorte, mais forte.
4. Choque Sagrado (**F4**, a partir do 30) quando não há tempo para lançar, ou enquanto você se move.
5. O grupo inteiro ferido, a partir do 40: Luz Zelosa (**Shift-F1**) em um jogador, depois Choque Sagrado (**F4**) nesse mesmo jogador.
6. Favorecimento Divino (**Shift-3**, a partir do 20) antes de uma cura que precisa ser grande.
7. Um efeito ruim num amigo: Purificar, depois Purificação (**Shift-C**).
8. Emergência: Impor as Mãos (**Q**). Ele gasta toda a mana que ainda resta.
Nada para curar: seu selo (**3**), Julgamento (**2**) e Golpe Sagrado (**1**) de perto. Sozinho: jogue como um Paladino de Retribuição; a partir do 30, Choque Sagrado (**F4**) no inimigo é o seu único botão forte de dano.
**A cada 10 níveis:**
- 10: você já tem Luz Sagrada (**C**), Aura de Devoção (**Ctrl-1**), Bênção do Poder (**Shift-Z**), Proteção Divina (**Z**), Martelo da Justiça (**E**) e Purificar (**Shift-C**). Novo no 10: Impor as Mãos (**Q**), Bênção de Proteção (**Shift-F**). Primeiro talento: Foco Espiritual (passivo). Os níveis de talento aqui são os mais cedo possíveis; uma vantagem pode adiantá-los em até 5 níveis. Depois Redenção (**F3**, de uma missão) no 12, Bênção de Sabedoria (**Shift-V**) no 14, Reverência e Luz Curativa (talentos, passivos) a partir do 15, Bênção da Liberdade (**R**) no 18.
- 20: Clarão de Luz (**F2**), Bênção dos Reis (**Shift-X**). Favorecimento Divino (**Shift-3**, um talento): seu próximo Clarão de Luz, Luz Sagrada ou Choque Sagrado com certeza é crítico; recarga de 2 minutos. Iluminação (um talento, passivo; você precisa de Reverência antes). Depois Aura de Concentração (**Ctrl-3**) no 22. Juramento de Luz (**Shift-R**, um talento) e Infusão de Luz (um talento, passivo) no 25.
- 30: Choque Sagrado (**F4**, um talento): instantâneo, dano num inimigo ou cura num amigo; recarga de 10 segundos. Intervenção Divina (**F3** em combate: você mesmo morre). Selo da Luz (bloco D). Depois Escudo Divino (**Z**) no 34, Poder Sagrado (um talento, passivo) no 35, Selo da Sabedoria (bloco D) no 38.
- 40: Luz Zelosa (**Shift-F1**, um talento; você precisa de Choque Sagrado antes): num amigo por 30 segundos; seu próximo Choque Sagrado nesse amigo não tem recarga e também cura o grupo dele. Choque Sagrado Grau 2. Armadura de Placa: você pode usar placa. Depois Purificação (**Shift-C**) no 42, Bênção do Sacrifício (bloco D) no 46, Choque Sagrado Grau 3 no 48.
- 50: Luz Zelosa Grau 2, Impor as Mãos Grau 3. Depois Bênção Maior de Poder no 52 e Bênção Maior de Sabedoria no 54, Choque Sagrado Grau 4 no 56.
- 60: Bênção Maior dos Reis, Luz Zelosa Grau 3; nada novo para esta função.
**Erros de iniciante:**
- Luz Sagrada para cada golpe pequeno. Clarão de Luz (**F2**, a partir do 20) é a cura normal barata.
- Luz Zelosa em um jogador e Choque Sagrado em outro. A cura de grupo só vem de Choque Sagrado no MESMO jogador.
- Apertar F3 em combate sem querer. Aí ele lança Intervenção Divina, e você mesmo morre. Fora de combate, F3 é Redenção.]] },
			{ band = 2, title = "Proteção: tanque", body = [[
A partir do nível 10 (Fúria Íntegra e Selo da Fúria no treinador). O **tanque** é quem os inimigos atacam, para o resto do grupo ficar seguro. **Ameaça** = o quanto um inimigo quer atacar você. Você usa uma arma de uma mão e um escudo. Os guias não concordam sobre quão bem Proteção sobe de nível sozinho. Os botões da árvore: Baluarte do Templário no 20, Julgamento Célere no 25, Escudo Sagrado no 30.
**Ordem simples:**
1. Antes de puxar: Fúria Íntegra ligada (sem tecla fixa: está no bloco D, ou coloque numa barra sua; dura 30 minutos). Selo da Fúria (**F**), uma bênção, uma aura. Os guias não concordam sobre a aura: Aura de Devoção (**Ctrl-1**) ou Aura da Retribuição (**Ctrl-2**).
2. A partir do 30: Escudo Sagrado (**Shift-4**) logo antes de os inimigos chegarem até você. Aperte de novo toda vez que estiver pronto.
3. Julgamento (**2**) no primeiro inimigo. Com Selo da Fúria ativo, Julgamento é sua provocação (3 segundos). **Provocar** = fazer o inimigo atacar você.
4. Dois ou mais inimigos, a partir do 20: Consagração (**Shift-1**) embaixo deles. Só os 4 primeiros levam o dano extra.
5. Golpe Sagrado (**1**) toda vez que estiver pronto.
6. Um inimigo corre para outra pessoa: Julgamento (**2**). Não está pronto? A partir do 25: Julgamento Célere (**F1**), um segundo Julgamento com sua própria recarga de 1 minuto.
7. Um inimigo lança um feitiço: Martelo da Justiça (**E**). O Paladino não tem interrupção.
8. Exorcismo (**5**, a partir do 20) em inimigos Morto-vivo e Demônio. Martelo da Ira (**4**, a partir do 44).
9. Muito dano chegando, a partir do 20: Baluarte do Templário (**X**). Último recurso: Impor as Mãos (**Q**).
Pouca mana: largue Consagração primeiro. A partir do 40 (Juramentado do Escudo): Escudo Sagrado primeiro, depois Golpe Sagrado. Não é o tanque (sozinho, ou outra pessoa tanqueia): use seu selo no **3**, não o Selo da Fúria.
**A cada 10 níveis:**
- 10: Fúria Íntegra (bloco D) e Selo da Fúria (**F**). Você já tem Julgamento (**2**), Golpe Sagrado (**1**), Martelo da Justiça (**E**), Aura de Devoção (**Ctrl-1**) e Proteção Divina (**Z**). Também novo: Impor as Mãos (**Q**), Bênção de Proteção (**Shift-F**). Primeiro talento: Reduto (passivo). Os níveis de talento aqui são os mais cedo possíveis; uma vantagem pode adiantá-los em até 5 níveis. Depois Precisão, Estima do Guardião ou Dever Sagrado (talentos, passivos) a partir do 15, Aura da Retribuição (**Ctrl-2**) no 16.
- 20: Baluarte do Templário (**X**, um talento): um escudo que absorve dano igual à sua vida máxima, por 8 segundos; recarga de 5 minutos. Consagração (**Shift-1**), Bênção dos Reis (**Shift-X**), Exorcismo (**5**). Especialização em Escudo (um talento, passivo; você precisa de Reduto antes). Depois Julgamento Célere (**F1**, um talento; você precisa de Baluarte do Templário antes) e Fúria Íntegra Aprimorada (um talento, passivo) no 25.
- 30: Escudo Sagrado (**Shift-4**, um talento; você precisa de um escudo): 30% mais chance de bloquear por 10 segundos, 4 cargas; recarga de 10 segundos. Ajuste de Contas (um talento, passivo). Depois Escudo Divino (**Z**) no 34, Doutrina do Ferro (um talento, passivo) no 35.
- 40: Juramentado do Escudo (um talento, passivo; você precisa de Escudo Sagrado antes): Golpe Sagrado a cada 6 segundos, e ele funciona com Escudo Sagrado. Armadura de Placa: você pode usar placa. Escudo Sagrado Grau 2. Depois Martelo da Ira (**4**) no 44, Bênção do Sacrifício (bloco D) no 46.
- 50: Escudo Sagrado Grau 3, Ira Sagrada (bloco D); graus mais fortes de Selo da Fúria e Consagração.
- 60: Escudo Sagrado Grau 4 e graus mais fortes; nada novo para esta função.
**Erros de iniciante:**
- Esquecer Fúria Íntegra. Sem ela você gera bem menos ameaça. Confira antes de cada puxada; ela dura 30 minutos.
- Selo da Fúria ligado quando você não é o tanque. Cada Julgamento então provoca.
- Sem escudo. Escudo Sagrado não funciona sem um, e Selo da Fúria não dá absorção.]] },
			{ band = 3, title = "Retribuição: dano corpo a corpo", body = [[
A partir do nível 1 (Selo da Retidão); Julgamento vem no 4, Golpe Sagrado no 6. Os guias dizem que Retribuição é a árvore mais rápida para subir de nível sozinho, com uma arma lenta de duas mãos. A missão de classe no 20 dá uma. Os botões da árvore: Selo de Comando no 20, Contrição no 30.
**Ordem simples:**
1. Antes da luta: Bênção do Poder (**Shift-Z**) até o 20, depois Bênção dos Reis (**Shift-X**).
2. Aura: Aura de Devoção (**Ctrl-1**); Aura da Retribuição (**Ctrl-2**, a partir do 16) contra vários inimigos.
3. Selo ligado (**3**): Selo da Retidão, até você conhecer Selo de Comando (a partir do 20). Aí a tecla 3 lança Selo de Comando.
4. Julgamento (**2**) toda vez que estiver pronto. Ele não gasta o selo.
5. Golpe Sagrado (**1**) toda vez que estiver pronto.
6. Morto-vivo ou Demônio, a partir do 20: Exorcismo (**5**).
7. Dois ou mais inimigos, a partir do 20: Consagração (**Shift-1**). Não em um inimigo só: custa mana demais.
8. A partir do 44: Martelo da Ira (**4**) quando o inimigo está com 20% de vida ou menos.
9. Inimigo forte: Martelo da Justiça (**E**), depois Julgamento (**2**). Com Selo de Comando, Julgamento causa dano em dobro num inimigo atordoado.
10. Um segundo Humanoide, a partir do 30: Contrição (**V**), e não bata nele.
11. Coloque o selo de novo quando ele acabar (30 segundos). Pouca vida: Luz Sagrada (**C**) entre as lutas.
**A cada 10 níveis:**
- 10: você já tem Selo da Retidão (**3**), Julgamento (**2**), Golpe Sagrado (**1**), Bênção do Poder (**Shift-Z**) e Martelo da Justiça (**E**). Novo no 10: Impor as Mãos (**Q**). Primeiro talento: Bênção (a maioria dos guias) ou Deflexão (um guia), ambos passivos. Os níveis de talento aqui são os mais cedo possíveis; uma vantagem pode adiantá-los em até 5 níveis. Depois Julgamento Aprimorado, Convicção ou Julgamento Santificado (talentos, passivos) a partir do 15, Aura da Retribuição (**Ctrl-2**) no 16.
- 20: Selo de Comando (**3**, um talento): seus golpes às vezes dão um golpe Sagrado extra. A partir daí a tecla 3 lança ele em vez de Selo da Retidão. Consagração (**Shift-1**), Exorcismo (**5**), Bênção dos Reis (**Shift-X**), Clarão de Luz (**F2**). Busca de Justiça (um talento, passivo: você se move 15% mais rápido com 2/2). A missão de classe para uma arma de duas mãos. Depois Arbítrio Sagrado e Especialização em Arma de Duas Mãos (talentos, passivos) no 25.
- 30: Contrição (**V**, um talento): tira um Humanoide da luta por até 6 segundos; qualquer dano acorda ele; recarga de 1 minuto. Vingança (um talento, passivo; você precisa de Selo de Comando antes): depois de um crítico você causa mais dano por 30 segundos; acumula 5 vezes. Selo de Comando Grau 2. Depois Escudo Divino (**Z**) no 34, Campeão da Luz (um talento, passivo) no 35.
- 40: Ira Desatada (um talento, passivo; você precisa de Contrição antes): seus golpes guardam cópias do seu selo, e um golpe com um selo diferente usa elas. Armadura de Placa: você pode usar placa. A missão do Cavalo de Guerra. Depois Martelo da Ira (**4**) no 44.
- 50: Selo de Comando Grau 4, Ira Sagrada (bloco D), Martelo da Ira Grau 2 no 52; nada novo para esta função.
- 60: Selo de Comando Grau 5 e graus mais fortes; a missão do Corcel (Aliança); nada novo para esta função.
**Erros de iniciante:**
- Colocar o selo de novo depois de cada Julgamento. Julgamento não gasta o selo; um selo dura 30 segundos.
- Selo de Comando com uma arma rápida. Ele quer uma arma lenta de duas mãos.
- Consagração em um inimigo só. Custa mana demais para isso.]] },
		},
	},
}
