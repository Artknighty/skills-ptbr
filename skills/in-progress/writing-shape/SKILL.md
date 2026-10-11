---
name: writing-shape
description: "Escrita, fase de exploit: dá à matéria-prima a forma de um artigo, parágrafo por parágrafo."
disable-model-invocation: true
---

<what-to-do>

O usuário passou (ou vai passar) um arquivo markdown de matéria-prima. Trate-o como a pilha de entrada: pode ser desde uma lista arrumada de fragmentos até um paredão de prosa sem estrutura ou uma transcrição. O formato não importa. Leia-o de ponta a ponta antes de fazer qualquer outra coisa.

Depois conduza uma sessão de modelagem que produza um documento de artigo separado. Isto é **exploit**: a exploração acabou, a pilha está fechada: comprometa-se com uma estrutura e garimpe a pilha para preenchê-la. Não edite o arquivo de matéria-prima: para esta skill, ele é somente leitura.

Se o usuário não disse onde salvar o artigo, pergunte uma vez e guarde o caminho.

</what-to-do>

<supporting-info>

## O loop

1. **Leia a pilha.** Leia o arquivo de entrada inteiro. Forme uma noção do que tem nele.
2. **Defina os pré-requisitos.** Combine com o usuário o que o leitor já sabe ao chegar: os conceitos **ancorados** desde o início. Todo o resto precisa ser ancorado por um bloco antes que um bloco posterior possa depender dele. Veja [Ancoragem](#ancoragem).
3. **Esboce 2 ou 3 aberturas candidatas.** Cada abertura deve sugerir uma tese ou um ângulo diferente para o artigo. Mostre todas. Faça o usuário escolher ou compor um híbrido. A abertura escolhida define o que o resto do artigo precisa fazer.
4. **Cresça parágrafo por parágrafo.** Depois que a abertura entrar, pergunte "dada esta abertura, o que o leitor precisa ouvir agora?". Tire material da pilha para responder. O próximo bloco só pode depender de conceitos ancorados, e ancora conceitos novos ao entrar. Discuta a forma que o próximo bloco vai ter: um parágrafo, uma lista, uma tabela, um callout, uma citação, um bloco de código. Cada escolha de formato deve ser deliberada e defensável.
5. **Acrescente ao arquivo do artigo conforme avança.** Não acumule. Escreva cada parágrafo ou bloco combinado imediatamente, para que o usuário veja o artigo tomando forma.
6. **Repita o passo 4 até o artigo ficar pronto.** Quem decide quando está pronto é o usuário.

## Ancoragem

Todo **conceito** precisa estar **ancorado** antes que um bloco possa depender dele: ou o leitor chegou sabendo, ou o encontrou num bloco anterior. Um bloco que depende de um conceito não ancorado perde o leitor. A unidade é o conceito, não a palavra para ele: um bloco pode depender de uma ideia que o leitor não tem mesmo sem jargão nenhum à vista. Quando um conceito tem um nome (um **termo**), ancorá-lo significa fazer a ideia e o termo chegarem juntos.

Um conceito é ancorado de um destes dois jeitos:

- **Pré-requisito**: ancorado antes da abertura. O leitor o traz. Fixado no início.
- **Introduzido**: um bloco o estabelece e, daí em diante, ele está ancorado pelo resto do artigo.

Mantenha uma lista corrente do que está ancorado. Quando você perguntar "o que o leitor precisa ouvir agora?", um conceito não ancorado de que o próximo movimento precisa é, por si só, a resposta: ancore-o primeiro (aqui ou num bloco anterior), senão você não consegue fazer o movimento. É a identificação de lacunas de [Tirando da pilha](#tirando-da-pilha) um nível acima: lá falta material na pilha; aqui falta um alicerce no artigo.

A alavanca é o que você transforma em pré-requisito versus o que você ancora dentro do artigo. Exija demais de saída e você exclui leitores; ancore demais dentro do texto e a abertura se afoga em definições. Resolva isso com o usuário ao definir os pré-requisitos.

## Clima da conversa

É uma sessão de sabatina invertida. Na ideação, a pergunta era "o que você está realmente percebendo?". Aqui é "o que este artigo está realmente defendendo, e em que ordem o leitor precisa ouvir isso?". Questione. Não deixe transições fracas passarem. Se um parágrafo não merece o lugar, corte.

Movimentos específicos para continuar usando:

- "O que este parágrafo faz pelo leitor que o anterior não fez?"
- "Se eu cortar isto, o que quebra?"
- "Isto é prosa ou deveria ser uma lista? Por que prosa?"
- "Esta frase está fazendo dois trabalhos: divida ou escolha um."
- "A abertura prometeu X. Escorregamos para Y. Ou retomamos o fio, ou mudamos a abertura."

## Tirando da pilha

Trate a matéria-prima como uma pedreira, não como um roteiro. Pegue um fragmento, retrabalhe-o para caber no parágrafo ao redor e posicione-o. Um fragmento pode ser dividido em vários parágrafos, fundido com outro ou parafraseado. O trabalho da pilha é ser garimpada; o trabalho do artigo é soar como uma voz só.

Se faltar na pilha algo de que o artigo precisa, nomeie a lacuna explicitamente: "Precisamos de um exemplo aqui e a pilha não tem. Me dê um agora ou cortamos esta seção."

## Discussões de formato que valem a pena ter

Ao escolher como apresentar um bloco, pese estes trade-offs em voz alta com o usuário, não em silêncio:

- **Prosa vs. lista.** Prosa carrega argumento; listas carregam itens paralelos. Se os itens não forem realmente paralelos, prosa é melhor. Se forem, uma lista é mais rápida de escanear.
- **Inline vs. callout.** Dicas, avisos e apartes vão em callouts (`> [!TIP]`, `> [!NOTE]`), mas só se realmente descarrilariam o argumento principal se ficassem inline. Caso contrário, deixe inline.
- **Tabela vs. estrutura repetida.** Se o mesmo formato se repete 3 ou mais vezes com os mesmos campos, tabela. Senão, prosa com abertura em negrito.
- **Citação vs. paráfrase.** Cite quando a redação original é o ponto. Parafraseie quando só a ideia importa.
- **Bloco de código vs. código inline.** Várias linhas, executável ou ilustrativo → bloco. Um token ou identificador → inline.

## Ritmo de escrita

Acrescente ao arquivo do artigo conforme cada bloco for combinado. Releia o arquivo do disco antes de cada escrita: o usuário pode ter editado entre um turno e outro. Nunca sobrescreva às cegas. Se o usuário quiser um parágrafo reescrito, edite aquele parágrafo específico no lugar; deixe o resto quieto.

## Fora do escopo

- Garimpar fragmentos novos que não estão na pilha (trate as lacunas como em "Tirando da pilha").
- Editar o arquivo de matéria-prima.
- Publicar, formatar para uma plataforma específica ou acrescentar frontmatter que o usuário não pediu.

</supporting-info>
