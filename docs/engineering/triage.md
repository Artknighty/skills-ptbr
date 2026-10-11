## O que faz

A `triage` percorre as issues do tracker do seu projeto. Ela move cada uma por uma pequena máquina de estados de **papéis de triagem** (um papel de categoria e um papel de estado). Cada issue termina como um briefing pronto para agente, uma pergunta específica para quem relatou, ou uma issue fechada com o motivo registrado.

Ela serve só para issues **que você não criou**. Isso significa relatos de bug crus, pedidos de funcionalidade que chegam, ou um pull request externo que apareceu sem aviso: trabalho que entrou no tracker vindo de fora, no formato em que quem relatou o deixou. Os [tickets](https://www.aihero.dev/ai-coding-dictionary/ticket) da [to-tickets](./to-tickets.md) já estão prontos para agente, então, se você rodar a `triage` sobre eles, desperdiça o trabalho. A regra é simples: `/triage` é só para issues que chegam, não para issues que você mesmo criou.

Ela também difere de rotular à mão porque recomenda e depois espera. Ela te dá a avaliação de categoria e de estado com o raciocínio, mais o que encontrou na codebase, e não aplica nada até você mandar.

## Quando usar

Você invoca esta digitando `/triage` e depois descrevendo o que quer em linguagem natural. O [agent](https://www.aihero.dev/ai-coding-dictionary/agent) não vai recorrer a ela sozinho. Exemplos: "Me mostre o que precisa da minha atenção", "vamos olhar o #42", "mova o #42 para ready-for-agent".

| O que você tem | Para onde ir |
| --- | --- |
| Um tracker cheio de relatos crus de outras pessoas | `/triage` |
| Uma ideia sua ainda crua, nada escrito | [grill-with-docs](./grill-with-docs.md) |
| Uma conversa resolvida para transformar numa [spec](https://www.aihero.dev/ai-coding-dictionary/spec) | [to-spec](./to-spec.md) |
| Uma spec para dividir em tickets prontos para agente | [to-tickets](./to-tickets.md) |
| Um bug confirmado que precisa de causa raiz, não de label | [diagnosing-bugs](./diagnosing-bugs.md) |

## Pré-requisitos

A `triage` lê e escreve no seu issue tracker, então a [setup-matt-pocock-skills](./setup-matt-pocock-skills.md) precisa antes configurar esse tracker e o vocabulário de labels dele. Os nomes de papel abaixo são **canônicos**. As strings de label no seu tracker podem ser diferentes, e a configuração fornece o mapeamento. Se o seu tracker já usa exatamente os nomes canônicos, não há nada a mapear nem a configurar.

A configuração do tracker também decide se pull requests externos contam como canal de pedidos, e quem conta como externo. Essa flag vem desligada por padrão, e a configuração não pergunta mais sobre ela. Para trazer PRs para o escopo, ligue-a em `docs/agents/issue-tracker.md`.

## A máquina de estados

Todo item triado termina com exatamente um papel de categoria e um papel de estado. Há duas categorias: `bug` (algo está quebrado) e `enhancement` (funcionalidade nova ou melhoria). Há cinco estados:

| Estado | Significa |
| --- | --- |
| `needs-triage` | Você precisa avaliar. Uma issue sem label normalmente cai aqui primeiro. |
| `needs-info` | Esperando quem relatou. Volta para `needs-triage` quando a pessoa responde. |
| `ready-for-agent` | Totalmente especificada, com um briefing de agente anexado. Um agente [AFK](https://www.aihero.dev/ai-coding-dictionary/afk) pode pegá-la. |
| `ready-for-human` | O mesmo briefing, mais o motivo de um agente não conseguir fazê-la: julgamento, acesso externo, teste manual. |
| `wontfix` | Fechada, com o motivo registrado. |

Esse é o vocabulário inteiro. A regra de exatamente um papel de estado por item mantém as consultas simples. Os estados também são a área mais pedida da [skill](https://www.aihero.dev/ai-coding-dictionary/skill). Os usuários já pediram um estado para trabalho especificado mas bloqueado por outra issue, um estado `deferred` para trabalho que espera um gatilho futuro e um estado terminal `implemented`. Nenhum foi lançado. Veja as perguntas abaixo.

O `wontfix` tem três casos. A diferença importa porque só um deles escreve na base de conhecimento:

| Por que você está fechando | O que acontece |
| --- | --- |
| Já implementado | Um comentário apontando onde a funcionalidade já está. Nada vai para `.out-of-scope/`, porque é uma funcionalidade construída, não rejeitada, e um arquivo ali quebraria as verificações de duplicidade. |
| Bug rejeitado | Explicação educada, depois fecha. |
| Enhancement rejeitado | Um arquivo em `.out-of-scope/`, linkado no comentário de fechamento, depois fecha. |

A `.out-of-scope/` guarda um arquivo markdown por **conceito** rejeitado, não por issue. Cada arquivo é um documento de design curto, não uma linha de banco de dados. Ele diz o que foi rejeitado, por quê, e lista todas as issues que pediram aquilo. A `triage` lê o diretório inteiro antes de avaliar qualquer coisa. Ela compara por conceito, não por palavra-chave, então "tema noturno" corresponde a `modo-escuro.md`. Quando encontra uma correspondência, ela te mostra a decisão antiga e pergunta se você ainda concorda com ela, em vez de discutir o pedido do zero.

## Verifique antes de escrever o briefing

Antes de qualquer [grilling](https://www.aihero.dev/ai-coding-dictionary/grilling), a `triage` confere se a alegação se sustenta. Para um bug, ela o reproduz a partir dos passos de quem relatou. Para um PR, ela faz checkout do branch e roda os testes relevantes. Depois ela reporta um de três resultados:

- Confirmado, com o caminho de código.
- Não foi possível reproduzir.
- Detalhe insuficiente para tentar. Este é o sinal mais forte de `needs-info` que existe.

Na mesma passada, ela faz mais duas verificações no código. A verificação de **redundância** pergunta se a funcionalidade já está implementada, procurando pelo conceito de domínio, não pelas palavras de quem relatou. A verificação de **rejeição anterior** pergunta se a `.out-of-scope/` já diz não. As duas são baratas, e um acerto em qualquer uma produz um `wontfix`.

Todo esse trabalho serve para deixar bom um artefato: o **briefing de agente**. É o comentário estruturado que a `triage` publica quando uma issue vai para `ready-for-agent`. Depois de publicado, o briefing é o contrato e o relato original é só contexto. Os briefings são **duráveis** em vez de precisos, porque uma issue pode ficar semanas em `ready-for-agent` enquanto o código muda. Então um briefing cita tipos, assinaturas e contratos de comportamento, e nunca caminhos de arquivo nem números de linha. Uma reprodução confirmada gera um briefing muito mais forte do que um palpite.

## Um PR é uma issue com código anexado

Se o tracker trata pull requests externos como canal de pedidos, eles passam pela mesma máquina, com as mesmas categorias, estados e transições. Os estados se aplicam ao diff. `ready-for-agent` significa que há um briefing anexado e que um agente deve dar o próximo passo sobre o código. `ready-for-human` significa que uma pessoa pode fazer o merge. Um briefing sobre um PR descreve o que falta fazer no diff existente, não como construir a coisa do zero.

A descoberta mostra só PRs *externos*, porque o branch em andamento de um colaborador não é trabalho de triagem. Esse filtro só vale para a descoberta. Se você citar um PR explicitamente, a `triage` o trata, seja quem for o autor.

## Perguntas frequentes

**Rodei `/to-spec` e `/to-tickets`, e agora esses tickets estão lá sem triagem. Rodo `/triage` sobre eles?**
Não. Eles já estão prontos para agente. A `to-tickets` aplica a label `ready-for-agent` ao publicá-los, então um executor AFK os pega sem mais uma passada. O usuário que topou com isso tinha rodado o fluxo de spec e visto `needs-triage` na saída, e o executor AFK dele ignorou tudo. A `triage` é a rampa de acesso para trabalho que chega de fora. O fluxo de spec é a pista para o trabalho que você mesmo começa. As duas se encontram em `ready-for-agent`, não antes.

**A `triage` ainda é relevante agora que existe o fluxo `to-spec` → `to-tickets` → `implement`?**
Só se você tiver trabalho chegando. A `triage` é mais antiga que esse fluxo e faz outro trabalho: ela trata relatos que outras pessoas registraram. Se tudo no seu tracker veio do seu próprio planejamento, você vai usá-la raramente. Se você mantém algo público, ou se o seu time te manda bugs, é ali que esse trabalho começa. O uso principal são repositórios open source que recebem issues de contribuidores externos.

**O agente tentou aplicar `ready-for-agent` e o `gh` disse que a label não existe.**
Era um bug conhecido ([#616](https://github.com/mattpocock/skills/issues/616)): a `setup-matt-pocock-skills` escrevia o vocabulário de labels em `docs/agents/triage-labels.md`, mas não criava as labels no tracker. (Nota da tradução: a versão do `SKILL.md` de setup em que esta tradução se baseia já manda criar as labels que faltam no GitHub ou no GitLab.) Se ainda faltarem, crie você mesmo, uma vez, as cinco labels de estado e as duas de categoria, com `gh label create` ou pela interface do tracker, e o erro para.

**Cinco estados não bastam. E bloqueado, adiado ou implementado?**
É a lacuna mais registrada da skill. Ela aparece de três formas:

- Uma issue totalmente especificada, mas que espera outra issue fechar ([#139](https://github.com/mattpocock/skills/issues/139)). Quem relatou disse que `ready-for-agent` ali é "tecnicamente verdade", mas enganoso, então um agente a pega e fica travado.
- Trabalho futuro pretendido, mas que espera um gatilho, então ainda não é acionável ([#297](https://github.com/mattpocock/skills/issues/297)).
- Um estado terminal para "implementado, aguardando verificação". Sem ele, um executor AFK pode enfileirar de novo tickets já terminados.

O caso do bloqueio é aceito como real, mas o nome não foi decidido (`blocked` ou `paused`). Nada disso foi lançado. Como solução, as pessoas acrescentam uma label extra local do repositório ao lado da categoria. O espaço de estado então guarda um valor correto, mas a skill não sabe da label extra. Um fork da comunidade vai além e acrescenta `needs-slicing`, `tracking` e labels de esforço. Funciona, mas pertence àquele fork, não à skill.

**Qual a diferença em relação à `/diagnosing-bugs`?**
A verificação aqui é rasa de propósito. Ela responde "isto é real, e mais ou menos onde vive", e não procura a causa raiz. Se um bug não se reproduz a partir dos passos de quem relatou em poucos minutos, use `needs-info`, ou use a [diagnosing-bugs](./diagnosing-bugs.md) se quiser investigar agora. O texto de nenhuma das duas skills menciona a outra ainda. Um usuário relatou essa lacuna, e ela continua aberta.

**Posso apontá-la para o meu backlog inteiro e deixar rodar?**
Pode pedir, mas fique de olho no que ela lê. A passada de "mostre o que precisa de atenção" é uma listagem barata para *seleção*. Você escolhe uma issue, e então a `triage` reúne o [context](https://www.aihero.dev/ai-coding-dictionary/context) completo daquela issue. Se você rodá-la em vinte issues de uma vez, o agente pode usar essa listagem barata como única evidência sem te avisar. A listagem devolve o corpo das issues, mas não os comentários. Um usuário topou exatamente com isso. Três issues já tinham um comentário dizendo "já corrigido, recomendo fechar", e as três ganharam briefings de agente novos. Numa passada em lote, diga explicitamente que ela precisa ler os comentários de cada issue.

**Funciona com o Linear, ou com algo além das GitHub Issues?**
Funciona. O tracker é configuração, não uma suposição fixa no código. As pessoas a rodam com o Linear (pela CLI `linear`), o GitLab e arquivos markdown simples em `.scratch/`. Uma divisão comum é o Linear para issues e planejamento, e o GitHub para código e PRs. As skills que dizem "issue tracker" então apontam para o Linear, e as que dizem "PR" apontam para o GitHub. O tracker de markdown local tem um bug de modelo em aberto: o arquivo gerado pode conter os critérios de aceitação duas vezes, uma no nível de cima e outra dentro do briefing de agente ([#200](https://github.com/mattpocock/skills/issues/200)).

## Está funcionando se

- Todo item em que ela mexe termina com exatamente um papel de categoria e um papel de estado, nunca zero, e nunca dois estados em conflito.
- Ela te dá uma recomendação com o raciocínio e para. Ela não troca a label da issue e segue em frente.
- Ela reproduziu o bug, ou fez checkout e rodou o PR, antes de qualquer coisa chegar a `ready-for-agent`.
- Os briefings que ela escreve citam tipos e comportamentos, e não contêm caminhos de arquivo nem números de linha.
- Quando um pedido que você rejeitou seis meses atrás volta, ela te avisa e cita o motivo antigo em vez de fazer a triagem de novo.
- Todo comentário que ela publica começa com `> *Isto foi gerado por IA durante a triagem.*`

## Onde se encaixa

A `triage` é uma **rampa de acesso**, não um passo da cadeia principal. O fluxo principal começa numa ideia sua (sabatina, spec, tickets, implementação, revisão). A `triage` é a pista paralela para o trabalho que veio de outra pessoa. As duas pistas terminam no mesmo lugar: uma issue com a label `ready-for-agent` e um briefing. A [implement](./implement.md) pega isso do mesmo jeito que pega um ticket da [to-tickets](./to-tickets.md). Quando um pedido precisa de mais detalhe antes que a `triage` consiga escrever o briefing, ela roda a [grilling](../productivity/grilling.md) e a [domain-modeling](./domain-modeling.md) juntas, uma rodada de perguntas por vez, registrando as decisões no `GLOSSARY.md` e nos ADRs conforme você as toma. Quando não tiver certeza de em qual pista está, a [ask-matt](./ask-matt.md) te orienta.
