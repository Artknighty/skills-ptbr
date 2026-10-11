## O que faz

A `prototype` escreve **código descartável que responde uma pergunta**: este modelo de estado parece certo, ou como esta tela deveria ficar. A pergunta vem primeiro e decide o que você constrói. Um protótipo que responde a pergunta errada é desperdício, por mais bonito que esteja.

Descartável é uma restrição sobre como o código é *escrito*, não uma promessa de destruí-lo. Sem testes, sem tratamento de erro além do que o faz rodar, sem abstrações, sem persistência, porque nada disso te ajuda a aprender a única coisa que você está tentando aprender. Duas coisas sobrevivem. A resposta vai para o código real, e o protótipo vai para um branch fora do main como evidência dessa resposta.

## Quando usar

Digite `/prototype`, ou o [agent](https://www.aihero.dev/ai-coding-dictionary/agent) recorre a ela automaticamente quando uma tarefa se encaixa.

Use no momento em que você bater numa pergunta que não dá para resolver conversando: uma máquina de estados cujos casos-limite você não consegue guardar na cabeça, uma tela que você não consegue imaginar até ver três versões lado a lado. As sessões de [grilling](https://www.aihero.dev/ai-coding-dictionary/grilling) se alongam nessas perguntas. O agente reformula, você chuta, e o escopo cresce. Pare a sabatina, construa a versão descartável, olhe para ela e responda numa linha. Se, em vez disso, algo já construído está se comportando mal e você quer saber por quê, use a [diagnosing-bugs](./diagnosing-bugs.md); prototipar explora o que construir, não por que a coisa construída está quebrada.

Você também vai chegar aqui sem escolher. A [wayfinder](./wayfinder.md) registra [tickets](https://www.aihero.dev/ai-coding-dictionary/ticket) de decisão do tipo `prototype` no mapa dela, e você trabalha um deles com esta skill.

## Dois ramos

A pergunta escolhe o ramo, e os ramos produzem artefatos diferentes:

- **"Esta lógica / este modelo de estado parece certo?"**: um **único arquivo HTML compartilhável**. Uma página autocontida, sem build e sem servidor, que alguém abre com dois cliques. Ela tem um painel de estado rotulado que é renderizado de novo a cada clique, botões de uso livre para cutucar o modelo em qualquer ordem e **roteiros guiados** em abas (um cenário por aba, cada um com os botões a apertar em ordem logo abaixo). Tudo é rotulado em linguagem de domínio, então você pode entregar para um designer, um PM ou um especialista de domínio e deixar a pessoa testar o modelo sozinha. A lógica por trás da página é um módulo puro e pequeno (um reducer, uma máquina, um conjunto de funções) sem código de DOM, então você pode levar a versão validada direto para o código real.
- **"Como isto deveria ficar?"**: várias variações de UI **radicalmente diferentes** numa rota, alternáveis por uma barra flutuante embaixo e por um parâmetro `?variant=` na URL. As variantes precisam discordar sobre a estrutura, não sobre a cor; três grades de cards com pequenos ajustes não respondem nada. Elas são renderizadas dentro de uma página real sempre que possível, com dados reais e densidade real, porque uma variante julgada numa página vazia sempre parece boa.

As duas mantêm o estado em memória, começam sem configuração nenhuma e te mostram o estado completo depois de cada passo. No momento em que você se pegar endurecendo uma delas (acrescentando um teste, ligando o banco de dados real, generalizando para um caso que talvez você queira depois), você parou de prototipar.

## O protótipo é uma fonte primária

Um protótipo terminado deixa duas coisas, e elas vão para lugares diferentes.

Você registra a **resposta** (o veredito mais a pergunta que ele resolveu) em algum lugar permanente: uma mensagem de commit, um ADR, a issue de implementação. O main fica com a resposta, no código real.

O **protótipo** é a evidência executável de onde a resposta veio, e você não o apaga. Ele também não pertence ao main, porque ninguém o mantém e ele fica obsoleto rápido. Então você faz commit dele num branch descartável `prototype/<nome>` saindo do main, nunca faz merge, e deixa um [context pointer](https://www.aihero.dev/ai-coding-dictionary/context-pointer) para esse branch na issue de implementação. O main continua limpo, e quem pegar o trabalho depois consegue encontrar e rodar de novo o protótipo.

## Perguntas frequentes

**Espera, o protótipo não deveria ser apagado?**
Não mais. Antes era assim: construir, guardar a resposta, jogar o código fora. A objeção mais forte a isso não era sobre velocidade. Era *quem pega o trabalho na próxima [session](https://www.aihero.dev/ai-coding-dictionary/session), e a partir de quê?* Um resumo em prosa de um protótipo perde justamente o que o tornava convincente. Então a skill agora trata o protótipo como [primary source](https://www.aihero.dev/ai-coding-dictionary/primary-source). Ele vai para um branch `prototype/<nome>` fora do main, e a issue de implementação aponta para ele. O que mudou foi onde o código mora, não a disciplina; ele continua nunca entrando no main.

**Ela costumava construir um app de terminal. Para onde isso foi?**
O ramo de lógica agora gera um único arquivo HTML compartilhável. Um app de terminal só pode ser conduzido por alguém com o repositório clonado e um runtime instalado, o que exclui justamente as pessoas cuja opinião o protótipo precisa: o designer, o PM, o especialista de domínio que sabe o que o modelo de estado deveria significar. Um arquivo autocontido que abre com dois cliques e continua funcionando depois de enviado por e-mail pode ser conduzido por qualquer pessoa. O módulo de lógica pura por baixo não mudou, e continua sendo a parte que você leva para o código real.

**Um agente me mandou rodar `/prototype` quando eu deveria estar implementando.**
É um problema conhecido de nome. Um agente que não conhece o fluxo lê `prototype`, uma palavra genérica e atraente, como "o próximo passo óbvio" depois que existem tickets. Então os agentes a recomendam pelo nome mesmo quando o design já foi resolvido na conversa. Se você já sabe o que construir, o próximo passo é `/implement`, por ticket. Recorra a um protótipo só quando uma pergunta de design específica estiver em aberto e conversar não a resolver.

**Devo prototipar a aplicação inteira antes de construir qualquer funcionalidade de produção (digamos, para fazer uma demo para clientes)?**
Isso é outro artefato, que só compartilha o nome desta skill. Um protótipo aqui é delimitado a uma pergunta, e "como é o app inteiro?" não é uma. Um protótipo do app inteiro não tem um ponto natural de parada, então ele escorrega para virar o app de produção: a passada de limpeza nunca acontece, e código escrito sob as regras de protótipo (sem testes, sem tratamento de erro) acaba na frente dos usuários. Se você precisa de uma demo de vendas, construa uma demo de propósito e deixe explícito que nada ali é produção. Se precisa resolver uma pergunta de design, corte até essa pergunta.

**Como eu rodo isso numa sessão própria?**
Um protótipo vive no próprio diretório e gera muito [context](https://www.aihero.dev/ai-coding-dictionary/context) que você não quer na conversa que fez a pergunta, então rode-o em outro lugar e traga de volta só a resposta. Use a [handoff](../productivity/handoff.md) para levar o trabalho para essa sessão e para trazer a resposta de volta.

**Isso não é o jeito mais rápido possível de queimar tokens?**
Pode ser, se você prototipar perguntas que poderia ter respondido conversando, ou deixar um protótipo se espalhar por uma funcionalidade inteira. A comparação que importa não é [tokens](https://www.aihero.dev/ai-coding-dictionary/token) contra zero; é tokens contra construir o modelo de estado errado e descobrir depois que ele já tem chamadores em produção. Mantenha a pergunta estreita e a execução curta, e o gasto fica proporcional.

## Está funcionando se

- Você consegue dizer numa frase que pergunta o protótipo existe para responder, e ela está escrita no topo da demo, não só na sua cabeça.
- Alguém que não lê código consegue conduzir a demo de lógica. A pessoa abre o arquivo, aperta os botões de uma aba de roteiro e descreve com as próprias palavras o que vê.
- Alguém diz "espera, isso não deveria ser possível" ou "hum, eu achei que X". Isso é um bug na *ideia*, que é para o que o protótipo serve.
- As variantes de UI discordam sobre layout e hierarquia de informação, não só sobre cor e texto, e o feedback que você recebe é "o cabeçalho da B com a sidebar da C".
- Ele é respondido de uma vez só. Se você ainda estiver construindo um dia depois, a pergunta era grande demais; divida.
- Quando acaba, o main contém a decisão e nada do protótipo, e a issue de implementação aponta para o branch que ainda o guarda.

## Onde se encaixa

A `prototype` é uma **avulsa para usar a qualquer hora**: você a usa para resolver uma pergunta de design e depois volta ao seu trabalho. Outra skill também a roda.

Quem mais a roda é a [wayfinder](./wayfinder.md). Um mapa da wayfinder é feito de **tickets de decisão**, e `prototype` é um dos quatro tipos que um ticket pode ter: o usado quando a pergunta que bloqueia é "como isto deveria ficar" ou "como deveria se comportar", que nenhuma discussão resolve. Quando uma discussão está vaga, a wayfinder faz algo concreto para reagir, e esta skill constrói essa coisa. A resposta resolve um ticket de protótipo, e o mapa linka o protótipo como asset.

As outras vizinhas ficam antes e depois disso. A [grill-me](../productivity/grill-me.md) e a [grill-with-docs](./grill-with-docs.md) respondem perguntas sabatináveis; as não sabatináveis vêm para cá, e a resposta de uma linha volta para a entrevista. Depois, um modelo de estado ou uma direção de UI validados viram entrada já resolvida para a [to-spec](./to-spec.md), que pode colocar inline o trecho rico em decisões que o protótipo produziu em vez de descrevê-lo em prosa. Para qualquer outra coisa, a [ask-matt](./ask-matt.md) te orienta por todo o conjunto.
