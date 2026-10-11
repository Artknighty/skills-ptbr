## O que faz

A `wayfinder` pega um esforço grande demais para uma [session](https://www.aihero.dev/ai-coding-dictionary/session) de agente. É uma ideia cujo **destino** você consegue nomear, mas cuja rota ainda não consegue ver. A wayfinder a traça como um **mapa** compartilhado de **tickets de decisão** no seu issue tracker e depois resolve os tickets um por vez, até a rota ficar clara.

Ela planeja e não constrói. Todo ticket faz uma pergunta, e a resposta é uma decisão, não uma fatia de uma construção. O mapa termina quando não sobra nada a decidir antes de alguém construir a coisa. Essa regra separa um ticket da wayfinder de um [ticket](https://www.aihero.dev/ai-coding-dictionary/ticket) de implementação comum, e é a regra que os agentes mais quebram. Quando o mapa clareia, a wayfinder passa adiante e não continua para o código.

## Quando usar

Você invoca esta digitando `/wayfinder`; o [agent](https://www.aihero.dev/ai-coding-dictionary/agent) não vai recorrer a ela sozinho.

Ela é o fluxo mais pesado do conjunto, então o gatilho é estreito. O esforço precisa ser maior do que uma sessão de agente comporta, e a rota até o destino precisa estar pouco clara. A divisão é o número de sessões: `/grill-with-docs` para planejamento numa sessão só, `/wayfinder` para planejamento em várias sessões.

| O que você tem na sua frente | O que rodar |
| --- | --- |
| Uma funcionalidade bem delimitada que dá para resolver de uma vez | [grill-me](../productivity/grill-me.md), ou [grill-with-docs](./grill-with-docs.md) quando houver codebase |
| Um projeto do zero, ou uma construção que se estende por muitas sessões, com a rota ainda pouco clara | `/wayfinder` |
| Uma conversa em que as decisões já foram tomadas | [to-spec](./to-spec.md): pule o mapa |
| Um mapa da wayfinder que clareou | [to-spec](./to-spec.md), depois [to-tickets](./to-tickets.md) e [implement](./implement.md) |
| Uma sessão existente que já cresceu demais | diga "passe para a `/wayfinder`" (a [handoff](../productivity/handoff.md) faz a ponte tanto para dentro de um mapa quanto para fora dele) |

Projeto do zero não é requisito. As pessoas usam a wayfinder com frequência em codebases legadas e meio construídas, e ela pode ser ainda mais útil ali, porque muito da neblina é "o que já é verdade aqui", e não "o que deveríamos fazer".

## Pré-requisitos

O mapa e os tickets vivem no issue tracker do repositório, então a wayfinder precisa da configuração de tracker feita pela [setup-matt-pocock-skills](./setup-matt-pocock-skills.md). Esse passo escreve uma seção "Operações de wayfinding". A seção descreve como expressar o mapa, os tickets filhos, as arestas de bloqueio e as consultas de fronteira no GitHub, no GitLab ou em markdown local. A wayfinder encontra esse documento pelo ponteiro no seu `CLAUDE.md` / `AGENTS.md`, não por um caminho fixo. Sem tracker configurado, ela usa arquivos markdown locais.

O tracker faz um trabalho de verdade. Os links de bloqueio nativos dele mostram a fronteira na própria interface do tracker. Num tracker sem links de dependência nativos (um Gitea próprio, digamos), a wayfinder deduz os bloqueadores a partir do texto do mapa. Funciona, mas você precisa supervisionar mais de perto.

## O mapa, a neblina e a fronteira

O **mapa** é uma única issue com a label `wayfinder:map`, e os tickets dele são as issues filhas. Ele é um **índice, não um depósito**. Uma decisão vive em exatamente um lugar, o ticket dela, e o mapa só traz um resumo de uma linha e um link. Uma sessão carrega o mapa em baixa resolução e abre tickets individuais quando precisa. Isso permite que um mapa continue crescendo sem que toda sessão carregue o histórico inteiro dele.

O mapa tem quatro seções:

- **Destino.** Como é o fim deste mapa. Você o nomeia primeiro, antes de existir qualquer ticket, porque o destino fixa o escopo contra o qual você mede cada ticket.
- **Decisões até aqui.** Uma linha por ticket fechado, cada uma com um link para onde o detalhe está.
- **Ainda não especificado.** Esta é a **névoa de guerra**: decisões que você percebe que estão vindo, mas ainda não consegue formular com nitidez. O teste entre neblina e ticket é se você consegue fazer a pergunta com precisão *agora*, não se consegue respondê-la. Quando você resolve um ticket, a neblina à frente dele se dissipa, e o que agora dá para especificar se gradua num ticket novo.
- **Fora do escopo.** Trabalho além do destino. A neblina só se acumula *rumo* ao destino, então o trabalho fora do escopo continua fechado e nunca se gradua.

A **fronteira** é o conjunto de tickets abertos, desbloqueados e ainda não assumidos (a borda do conhecido). Uma sessão assume um ticket atribuindo-o a si mesma antes de fazer qualquer trabalho. O responsável atribuído *é* a marca de que o ticket foi assumido, então sessões concorrentes o pulam. As sessões se referem aos tickets pelo nome, nunca por um `#42` solto, porque uma parede de números de issue é difícil de ler na narração.

## Os quatro tipos de ticket de decisão

Todo ticket carrega uma label `wayfinder:<tipo>`. Cada ticket é **[HITL](https://www.aihero.dev/ai-coding-dictionary/human-in-the-loop)** (trabalhado com um humano que fala por si mesmo) ou **[AFK](https://www.aihero.dev/ai-coding-dictionary/afk)** (conduzido só pelo agente). Um ticket HITL só se resolve pela troca ao vivo. Um agente que responde às próprias perguntas de [grilling](https://www.aihero.dev/ai-coding-dictionary/grilling) quebrou isso.

| Tipo | Modo | Use quando | Resolvido por |
| --- | --- | --- | --- |
| `grilling` | HITL | O padrão. A pergunta pode ser resolvida conversando. | [grilling](../productivity/grilling.md) mais [domain-modeling](./domain-modeling.md), numa sessão nova |
| `prototype` | HITL | "Como isto deveria ficar" ou "como deveria se comportar": uma pergunta que conversa não resolve. | [prototype](./prototype.md), com um link do ticket para o artefato construído |
| `research` | AFK | Um fato de fora do diretório de trabalho está bloqueando uma decisão. | Um [subagent](https://www.aihero.dev/ai-coding-dictionary/subagent) de [research](./research.md), disparado quando você traça o mapa e rodando em paralelo num branch `research/<nome>` |
| `task` | Qualquer um | Nada a decidir, mas um trabalho manual bloqueia uma decisão, como provisionar acesso, criar conta num serviço ou mover dados para você ver o formato deles. | O agente sozinho onde puder, senão um checklist preciso para o humano |

`task` é o único tipo que *faz* em vez de decidir. Ele só pertence ao mapa porque destrava uma decisão, nunca porque entrega parte do destino. É o tipo que mais dá errado na prática. Os agentes o leem como um passo de implementação e começam a escrever código de produto dentro do mapa.

Research é a única exceção a *um ticket por sessão*.

## Perguntas frequentes

**Qual a diferença em relação à `/grill-with-docs`? Com qual eu começo?**
Número de sessões, não tamanho do projeto. A `/grill-with-docs` é planejamento numa sessão só; a wayfinder é planejamento em várias sessões. Se você consegue manter a coisa toda numa conversa, a sabatina é mais barata e melhor, e a wayfinder é mais lenta e densa para esse caso. O resumo da comunidade é que a wayfinder só faz sentido se o trabalho não cabe numa única sessão. Esta é de longe a pergunta mais feita sobre a wayfinder. As pessoas continuam perguntando porque as descrições das skills não dizem de que lado dessa linha a sua tarefa está. Você precisa julgar o número de sessões por conta própria.

**Quando ela pergunta o "destino", é o fim desta sessão ou o fim de tudo?**
O fim do mapa inteiro, não só da primeira sessão. A pergunta soa ambígua, mas a wayfinder é por definição uma ferramenta de várias sessões, então uma resposta no escopo de uma sessão nunca faz sentido. Destinos típicos são uma [spec](https://www.aihero.dev/ai-coding-dictionary/spec) a entregar, uma decisão a travar antes de o planejamento começar, uma prova de conceito ou uma mudança feita no lugar, como uma migração de dados.

**O mapa clareou. A wayfinder já não escreveu a spec e criou os tickets? Por que ainda preciso da `/to-spec` e da `/to-tickets`?**
Não. Os tickets da wayfinder são tickets de decisão, e quando o mapa fecha eles também já estão todos fechados. O que sobra é um mapa cheio de decisões ligadas, que não é um plano de construção. A [to-spec](./to-spec.md) condensa essas decisões ligadas numa spec (`/to-spec #<issue_do_mapa>`), e a [to-tickets](./to-tickets.md) fatia essa spec em tickets de implementação tracer-bullet. Se você levar o mapa direto para a [implement](./implement.md), pula a condensação e perde o detalhe ligado. Vá direto para a implementação só quando o esforço se revelar pequeno. Algumas pessoas rodam o pipeline mais curto e dizem que funciona. Os dois passos extras te dão uma spec explícita que um revisor ou um colega consegue ler, o que importa mais quando você não trabalha sozinho.

**Meu agente começou a escrever código de produção no meio de uma sessão da wayfinder.**
Esta é a falha mais relatada desta skill, e uma lacuna real da skill a causa. Você pode sobrescrever o padrão "planeje, não execute" da wayfinder nas **Notas** do mapa. Mas quem escreve as Notas é o agente, então a restrição e a exceção a ela vivem num arquivo que pertence ao próprio agente restrito. Um usuário viu um agente escrever "este mapa inclui execução" nas próprias Notas. Em sessões seguintes, o agente leu essa linha de volta como permissão e construiu num servidor em produção. A skill não tem uma trava rígida para "eu quis dizer o padrão". Até ter, leia as Notas de qualquer mapa que você mesmo não traçou, mantenha a implementação em sessões separadas e trate qualquer `wayfinder:task` que pareça uma fatia da construção como tipo errado.

**Tracei 27 tickets, e quando cheguei no décimo terceiro o resto já não fazia sentido.**
Esta pergunta é literal de um relato de usuário, e outros relatam o mesmo resultado. Por padrão, a wayfinder planeja de forma abrangente. Quando tickets posteriores se apoiam em suposições que tickets anteriores invalidam, o mapa cai na armadilha de cascata de que os críticos acusam a skill. Duas coisas ajudam. Primeiro, delimite o mapa a um destino bem definido, não ao produto inteiro. Os usuários relatam que mapas delimitados a um épico definido se comportam melhor do que um "implementar a V1" esparramado. O objetivo é entregar incrementos pequenos, não planejar algo enorme. Segundo, use [prototyping](https://www.aihero.dev/ai-coding-dictionary/prototyping) sem dó. A rota se mantém atual porque artefatos concretos e baratos expõem a incerteza antes de a implementação depender dela. A wayfinder é "prototipar ao máximo", não "planejar ao máximo".

**Posso trabalhar vários tickets em paralelo?**
A fronteira te mostra quais tickets dá para pegar, e as arestas de bloqueio tornam o trabalho paralelo seguro no papel. Na prática, um ticket por vez é o padrão mais seguro. Se você trabalhar dois tickets de grilling ao mesmo tempo, uma sessão pode te fazer uma pergunta que você acabou de responder na outra, porque as sessões não compartilham [context](https://www.aihero.dev/ai-coding-dictionary/context). Os tickets de protótipo também têm uma lacuna conhecida. Um usuário relatou um agente que construiu três variações de UI, escolheu uma sozinho e fechou o ticket. Essa escolha é sua, e a skill ainda não diz isso com clareza suficiente. Se for rodar tickets em paralelo, revise você mesmo o grafo de dependências antes.

**Eu preciso usar as GitHub Issues?**
Não. Qualquer issue tracker funciona. O GitHub tem o melhor suporte, porque as sub-issues e relações de bloqueio nativas dele tornam a fronteira visível sem abrir o mapa. As pessoas também usam GitLab, Linear, Jira e markdown local. Há duas ressalvas. Num tracker sem bloqueio nativo, a wayfinder deduz o grafo de dependências a partir do texto, e você precisa corrigi-lo à mão. O markdown local coloca os artefatos no seu repositório, o que não é recomendado, porque material guardado no repositório tende a persistir sem querer. Mantenedores de open source enfrentam o problema oposto (trackers públicos se enchem de tickets de planejamento gerados por agente) e muitas vezes escolhem o markdown local mesmo assim.

**A sabatina é exaustiva. Cada pergunta tem três parágrafos.**
Esta é a reclamação em aberto mais afiada sobre a wayfinder, e ninguém a resolveu ainda. Um usuário destrinchou assim: a prolixidade em si causa exaustão de decisão, e o tamanho esconde *por que* o agente faz uma pergunta, então você perde o encadeamento de uma decisão para outra conforme o mapa cresce. A prolixidade parece uma característica do conjunto atual de [models](https://www.aihero.dev/ai-coding-dictionary/model), não da skill. Os usuários tentam duas mitigações: um [reasoning effort](https://www.aihero.dev/ai-coding-dictionary/effort) menor e uma instrução de linguagem simples no seu `CLAUDE.md` global. Espere pensar bastante aqui de qualquer jeito. A wayfinder exige muito raciocínio de você, e isso é a maior parte do propósito dela, não um defeito.

**Uma decisão que já fechei se revelou errada. Edito o ticket antigo ou crio um novo?**
Não há orientação oficial, e o padrão do agente não ajuda. Ele tende a projetar em volta da decisão ruim em vez de questioná-la, então você precisa conduzi-lo. O que funciona é dizer à wayfinder com clareza o que mudou. Ela então atualiza o mapa, revisa os tickets afetados e comenta nos fechados. Dá para se recuperar de mudanças de escopo no meio do mapa. Mas, se você *projetou* um mapa para mudar, é sinal de que o escopo está errado.

**Para onde foi a `decision-mapping`?**
É esta skill. A v1.1 a renomeou para `wayfinder`, e você a invoca como `/wayfinder`. "Mapa de decisões" era jargão, e também impreciso, porque só um dos quatro tipos de ticket é uma decisão por si só. O nome novo deu à skill um vocabulário consistente (destino, névoa de guerra, fronteira, o mapa) em vez de um termo inventado por cima. A unidade manteve a palavra "decisão": um ticket da wayfinder é um **ticket de decisão**, para que as pessoas não o leiam como ticket de implementação.

## Está funcionando se

- O destino está escrito e combinado antes de existir um único ticket.
- Todo ticket aberto se lê como uma pergunta. Qualquer ticket que diga "construir o X" está com o tipo errado ou pertence a depois do mapa.
- Você consegue olhar para o seu tracker e ver quais tickets dá para pegar sem abrir o mapa, porque o bloqueio nativo mostra a fronteira.
- Uma sessão resolve um ticket, publica a resposta como comentário de resolução, fecha o ticket e acrescenta uma linha em *Decisões até aqui* no mapa. Depois para.
- **Ainda não especificado** encolhe com o tempo. Quando a neblina se gradua num ticket, ela sai dessa seção e não aparece nos dois lugares.
- Quando a sabatina inicial em largura não encontra neblina nenhuma, a skill para e te diz que o esforço é pequeno o bastante para dispensar o mapa.
- A sessão que termina o mapa te aponta para uma spec, não para um pull request.

## Onde se encaixa

A `wayfinder` é uma **rampa de acesso situacional**, não o ponto de partida padrão. A maior parte do trabalho ainda começa na cadeia ideia → entrega guiada pela sabatina. Você usa a wayfinder quando a ideia é grande demais para caber numa sessão. Ela volta para essa cadeia pela [to-spec](./to-spec.md), porque um mapa que clareou passa adiante e não constrói.

A maior parte do trabalho acontece em outras skills que a wayfinder agenda. A [grilling](../productivity/grilling.md) e a [domain-modeling](./domain-modeling.md) resolvem o tipo de ticket padrão, a [prototype](./prototype.md) resolve os tickets que conversa não resolve, e a [research](./research.md) roda como subagente para que a leitura dela fique fora da sua sessão. A [handoff](../productivity/handoff.md) leva trabalho para dentro e para fora: para dentro de um mapa a partir de uma conversa que cresceu demais, e para fora de um mapa quando uma tarefa paralela aparece no meio da sessão. Para qualquer outra coisa, a [ask-matt](./ask-matt.md) te orienta por todo o conjunto.
