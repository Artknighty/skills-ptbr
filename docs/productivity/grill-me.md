## O que faz

A `grill-me` pega uma **ideia solta** e te entrevista até você conseguir se comprometer com ela. Você não precisa de um plano pronto para começar, porque a [session](https://www.aihero.dev/ai-coding-dictionary/session) existe justamente para produzir um. Ela pergunta em **rodadas**. Cada rodada é a **fronteira** inteira, ou seja, toda pergunta cujos pré-requisitos você já resolveu. Por isso ela nunca te pergunta algo que depende de uma resposta que ainda não ouviu.

Ela é **[stateless](https://www.aihero.dev/ai-coding-dictionary/stateless)** (sem estado). Não escreve arquivo nenhum e não deixa workspace para trás. O único resultado é uma versão mais clara da ideia, na sua própria cabeça.

## Quando usar

Você invoca esta digitando `/grill-me`; o [agent](https://www.aihero.dev/ai-coding-dictionary/agent) não vai recorrer a ela sozinho. Comece numa **conversa nova**, não em cima de um plano que você já pediu para um agente escrever.

Use assim que tiver uma ideia que vale levar a sério (uma funcionalidade, um rumo de produto, uma decisão de negócio, um texto), e muito antes de ter descoberto o que ela envolve. Ideia vaga não é motivo para esperar, porque a sessão existe para tirar a vagueza. Se você já consegue especificar a coisa com precisão, não precisa sabatiná-la.

Qual das três skills de sabatina você quer depende do que está na sua frente:

| O que você tem | Use |
| --- | --- |
| Qualquer coisa, em qualquer lugar | `grill-me`. Não precisa de repositório, não escreve arquivos, e o assunto não precisa ser código. |
| Uma codebase com a qual se alinhar | [grill-with-docs](../engineering/grill-with-docs.md). É a mesma entrevista, mas [stateful](https://www.aihero.dev/ai-coding-dictionary/stateful) (com estado): ela lê o seu código e guarda o que aprende em `GLOSSARY.md` e ADRs. |
| Algo grande demais para uma sessão | [wayfinder](../engineering/wayfinder.md). Ela traça o esforço como um mapa e roda sessões de sabatina dentro dele. |

Deixe o [plan mode](https://www.aihero.dev/ai-coding-dictionary/agent-mode) desligado. O plan mode faz o agente ter pressa de produzir um plano, quando você quer que ele continue perguntando.

## É uma conversa, não um interrogatório

A skill faz as perguntas, mas quem é dono do escopo é **você**. Muita gente não percebe isso. É a diferença entre uma sessão que transforma uma ideia em decisões e uma que produz bobagem com cara de certeza.

O modo de falha é a **passividade**: responder "concordo, concordo, concordo" por quarenta perguntas e sair com um plano que o agente escreveu e você só balançou a cabeça. Parece produtivo porque foi longo. Mas você não decidiu nada, e o resultado parece mais certo do que é.

Ser ativo é conduzir. Questione uma pergunta que veio com menos detalhe do que você precisa. Avise quando o escopo estiver escapando. Responda "não sei" quando for verdade. Esta skill ajuda um engenheiro, não substitui um. A qualidade do resultado depende da qualidade das suas respostas, não da quantidade de perguntas.

O erro oposto existe, mas é mais raro: ficar na entrevista tanto tempo que você nunca chega ao código.

## Sabatinável e não sabatinável

Algumas perguntas dá para responder conversando. Outras não, e nenhuma quantidade de sabatina vai te levar lá.

"Um formulário longo ou três páginas?" e "como essa interação deveria parecer?" são **não sabatináveis**. Você precisa de algo para reagir antes de conseguir responder. Quando topar com uma dessas, pare a sabatina. Construa a versão descartável com a [prototype](../engineering/prototype.md), olhe para ela, depois volte e responda numa linha.

As sessões ficam longas demais quando você tenta resolver conversando uma pergunta não sabatinável. O agente fica reformulando, você fica chutando, e o escopo cresce junto com a incerteza.

## Está funcionando se

- Você discorda de alguma coisa. Uma sessão sem nenhuma resistência sua é uma sessão de que você não precisava.
- As perguntas chegam em poucas rodadas, não uma de cada vez por muito tempo, e as rodadas seguintes claramente se apoiam no que você disse antes.
- Você termina num lugar que não esperava, porque uma pergunta te mostrou uma decisão que você vinha tomando sem perceber.
- No final, você conseguiria defender cada escolha para alguém que não estava lá.

## Perguntas frequentes

**Quantas perguntas devo esperar, e como sei quando termina?**
Conte rodadas, não perguntas. Quarenta e seis perguntas em quatro rodadas é uma sessão normal. Ela termina quando a fronteira fica vazia: todos os ramos foram visitados e nada ficou como suposição não dita.

**Ela me fez duzentas perguntas. O que deu errado?**
Normalmente o escopo era grande demais. Peça ao agente para quebrar o trabalho em pedaços menores primeiro e depois sabatine cada um. Sessões muito longas também escorregam para a **[dumb zone](https://www.aihero.dev/ai-coding-dictionary/smart-zone)**, em que a [context window](https://www.aihero.dev/ai-coding-dictionary/context-window) está tão cheia que as perguntas pioram.

**Dá para voltar a uma pergunta por vez?**
Dá. Adicione isto ao seu `CLAUDE.md` global:

```
Na sabatina, faça uma pergunta por vez.
```

**E se eu realmente não souber a resposta?**
Diga isso. "Não sei" é uma resposta de verdade, e uma pergunta que você não consegue responder costuma ser um sinal para prototipar, não para chutar.

**Começo uma sessão nova antes de escrever a spec?**
Não. O valor da sessão é o [context](https://www.aihero.dev/ai-coding-dictionary/context) que você acabou de construir. Entregue a mesma conversa direto para a [to-spec](../engineering/to-spec.md).

**O modelo faz diferença?**
Mais do que na maioria das skills. A sabatina depende do conhecimento do próprio [model](https://www.aihero.dev/ai-coding-dictionary/model) sobre como sistemas quebram, então use o seu melhor. A implementação segue principalmente o contexto, então um modelo mais barato serve lá.

## Onde se encaixa

A `grill-me` é uma **avulsa que você roda em qualquer lugar, sobre qualquer coisa**. Por ser sem estado, ela é portátil. Não precisa de repositório, workspace nem configuração, e não pressupõe que a ideia seja sobre software. As pessoas a usam para decisões de negócio, para escrita e para decidir o que fazer em seguida: qualquer coisa que não conseguem pensar com clareza sozinhas.

A portabilidade é a única diferença em relação à [grill-with-docs](../engineering/grill-with-docs.md). Aquela skill roda a mesma entrevista, mas lê uma codebase com a qual se alinhar e registra o que aprende como `GLOSSARY.md` e ADRs. As duas usam a skill [grilling](./grilling.md) por baixo. A `grill-me` é a porta de entrada invocada pelo usuário que não guarda estado.

Se o que você sabatinou acabar sendo software, dá para entregar a mesma conversa para a [to-spec](../engineering/to-spec.md) e seguir para o fluxo de construção (uma opção, não o propósito da skill). Quando não tiver certeza de qual fluxo serve, a [ask-matt](../engineering/ask-matt.md) te orienta.
