## O que faz

A `to-tickets` pega um plano, uma [spec](https://www.aihero.dev/ai-coding-dictionary/spec) ou a conversa em que você está e a quebra num conjunto de **[tickets](https://www.aihero.dev/ai-coding-dictionary/ticket)** no seu issue tracker. Cada ticket declara as suas **arestas de bloqueio**: os outros tickets que precisam terminar antes que ele possa começar.

Todo ticket é um **tracer bullet**: um caminho estreito, mas completo, por todas as camadas da mudança (schema, API, UI, testes) que você consegue demonstrar sozinho assim que ele entra. É isso que diferencia a skill do jeito óbvio de dividir trabalho, que é cortar uma camada por vez e integrar no final. Ela também dimensiona cada ticket para caber numa única [context window](https://www.aihero.dev/ai-coding-dictionary/context-window) nova, porque quem vai pegar o ticket é uma [session](https://www.aihero.dev/ai-coding-dictionary/session) que nunca viu a sua spec.

## Quando usar

Você invoca esta digitando `/to-tickets`. O [agent](https://www.aihero.dev/ai-coding-dictionary/agent) não vai recorrer a ela sozinho.

| Onde você está | O que rodar |
| --- | --- |
| Você tem uma issue de spec e a construção leva várias sessões | `/to-tickets`, ou `/to-tickets #<issue_da_spec>` |
| O plano está só na conversa, nunca foi escrito | `/to-tickets` lê a conversa diretamente, sem precisar de spec |
| A mudança inteira cabe numa context window | [implement](./implement.md), pule os tickets |
| Nada foi decidido ainda | [grill-with-docs](./grill-with-docs.md), depois [to-spec](./to-spec.md) |
| Um mapa da [wayfinder](./wayfinder.md) clareou | [to-spec](./to-spec.md) primeiro, para condensar o mapa, depois `/to-tickets` |

Os tickets que a `to-tickets` produz já são, por construção, prontos para agente. Não rode a [triage](./triage.md) sobre eles. A triagem é para trabalho que chegou de outra pessoa.

## Pré-requisitos

A `to-tickets` publica num tracker, então a [setup-matt-pocock-skills](./setup-matt-pocock-skills.md) precisa ter configurado um para este repositório, junto com o vocabulário de labels de triagem. Qualquer tipo funciona: um tracker real como o GitHub ou o Linear, ou arquivos markdown locais em `.scratch/`, que funcionam sem configuração extra.

## Tracer bullets, não camadas

Um slice **horizontal** entrega uma camada da mudança. Nada funciona até todas as camadas entrarem, e os critérios de aceitação de cada ticket precisam alcançar trabalho que pertence a outro ticket. Um slice **vertical** (o tracer bullet) entrega um caminho fino por todas as camadas de uma vez, então pode ser verificado sozinho e é dono de tudo o que ele avalia.

Esta é a regra que as pessoas mais quebram. Um time rodou uma pilha de 26 tickets fatiados por camada (corpus, produtor, agregador, seletor) e teve umas vinte execuções de agente por ticket fechado, cerca de três quartos delas de retrabalho. O próprio post-mortem deles ligou todas as classes de falha ao horizontal slicing, e não às implementações.

Duas coisas acontecem antes de qualquer publicação. A `to-tickets` procura oportunidades de pré-refatoração (o princípio "torne a mudança fácil, depois faça a mudança fácil") e coloca esse trabalho na frente. Depois ela apresenta a divisão como uma lista numerada e te consulta sobre ela: a granularidade está certa, as arestas de bloqueio são reais, algo deveria ser juntado ou dividido? Nada chega ao tracker até você aprovar, e essa consulta é o lugar para questionar.

## Arestas de bloqueio

As arestas são a razão de ser do artefato. Elas funcionam de dois jeitos, conforme o tracker:

| Tracker | Onde ficam as arestas | Como você as trabalha |
| --- | --- | --- |
| Markdown local | Texto em um arquivo por ticket em `.scratch/<feature>/issues/<NN>-<slug>.md`, numerados com os bloqueadores primeiro | De cima para baixo, à mão |
| Um tracker real (GitHub, Linear) | Links de bloqueio nativos, ou sub-issues onde o tracker as tiver | Qualquer ticket cujos bloqueadores estejam prontos está na **fronteira** e pode ser pego |

As arestas vivem no ticket de qualquer jeito. O tracker só decide se algo consegue agir sobre elas em paralelo. A `to-tickets` produz o artefato; executá-lo (uma sessão por vez, ou uma frota) é trabalho seu, não da skill.

## A exceção da refatoração ampla

Um formato quebra a regra do tracer bullet. Uma **refatoração ampla** é uma única mudança mecânica (renomear uma coluna, mudar o tipo de um símbolo compartilhado) cujo **blast radius** cobre a codebase inteira. Uma edição quebra milhares de pontos de chamada, então nenhum vertical slice consegue entrar verde.

A `to-tickets` sequencia isso como **expand–contract** (expandir–contrair):

- **Expandir**: acrescente a forma nova ao lado da antiga, para que nada quebre.
- **Migrar**: passe os pontos de chamada em lotes dimensionados pelo blast radius (por pacote, por diretório), um ticket por lote, cada um bloqueado pela expansão. O CI continua verde porque a forma antiga ainda existe.
- **Contrair**: apague a forma antiga quando não restar nenhum chamador, num ticket bloqueado por todos os lotes de migração.

Quando nem os lotes conseguem ficar verdes sozinhos, eles compartilham um branch de integração e todos bloqueiam um ticket final de integrar-e-verificar. O CI só precisa estar verde nesse ticket.

## Perguntas frequentes

**Ela produziu doze tickets para uma mudança de três linhas.**
A decomposição excessiva é o problema mais relatado desta skill, e muitos usuários a veem. O [model](https://www.aihero.dev/ai-coding-dictionary/model) tende a unidades atômicas e perde o agrupamento que daria sentido a elas. A etapa de consulta é onde você corrige isso. Peça para juntar tickets, e ela junta. Há também um limite inferior. Se a mudança inteira cabe numa context window, você nem precisa desta skill. Vá direto para a [implement](./implement.md).

**Os tickets saíram um por camada: todo o schema num, toda a API em outro.**
Essa é a falha contra a qual a regra do vertical slice foi escrita, e a skill ainda a produz às vezes. Pegue isso na etapa de consulta fazendo uma pergunta por ticket: o que eu consigo demonstrar quando isto estiver pronto? Um ticket sem resposta é um slice horizontal. Algumas pessoas acrescentam uma linha de "caminho da demo" a cada ticket por esse motivo, e relatam que isso empurra o modelo para vertical slices.

**No GitHub, os tickets não foram criados como sub-issues da issue da spec.**
Isso foi relatado em uma dúzia de execuções e vários modelos, [mais completamente na issue #554](https://github.com/mattpocock/skills/issues/554). Corrigido: a `to-tickets` agora faz de cada ticket uma sub-issue da issue de origem, e o modelo de tracker do GitHub traz o comando (`gh issue create --parent <n>`, `gh` 2.94+). Rode a [setup-matt-pocock-skills](./setup-matt-pocock-skills.md) de novo para atualizar um `docs/agents/issue-tracker.md` antigo.

**O "Bloqueado por" foi escrito no corpo da issue em vez de virar um link de bloqueio de verdade.**
É o mesmo tipo de problema, [relatado na issue #513](https://github.com/mattpocock/skills/issues/513), em que o agente chegou a afirmar que o GitHub não tem relação de bloqueio nativa nenhuma. Ele tem: `gh issue create --blocked-by 12,15`. Como a skill publica os bloqueadores primeiro, os números deles sempre estão disponíveis na hora da criação. O texto no corpo deveria ser a alternativa para trackers sem aresta nativa, não o padrão. O modelo de ticket agora omite `## Bloqueado por` quando as arestas são nativas.

**Para onde vão os tickets locais? As notas da v1.1 falavam de um `tickets.md` na raiz.**
Falavam, e isso era um bug. Um único arquivo compartilhado também causava condições de corrida quando agentes paralelos escreviam nele. O modo local agora escreve um arquivo por ticket em `.scratch/<slug-da-feature>/issues/<NN>-<slug>.md`, em ordem de dependência, seguindo o layout que o modelo de tracker local já descrevia. O prefixo `NN` é um ID de ticket de verdade, então `/implement 03` funciona em vez de redigitar um título longo.

**Ela ficava cortando quando tentava ler a minha spec.**
Uma spec muito grande pode passar do que uma issue do tracker devolve de forma limpa. Não há uma cópia local para recorrer, então o agente gasta [tool calls](https://www.aihero.dev/ai-coding-dictionary/tool-call) buscando pedaços de novo e nunca chega ao fim. Não faça [clearing](https://www.aihero.dev/ai-coding-dictionary/clearing) nem [compaction](https://www.aihero.dev/ai-coding-dictionary/compaction) entre a `/to-spec` e a `/to-tickets`. Rode as duas na mesma context window e o agente nunca vai precisar buscar a spec de volta.

**Os critérios de aceitação não avaliavam nada: alguns passavam antes de qualquer trabalho ser feito.**
O modelo pede critérios e não diz nada sobre se eles podem falhar, então isso acontece. Três formatos se repetem: um critério que já era verdade no commit de base, um critério que só o trabalho de outro ticket consegue satisfazer, e um que repete o pedido em vez de derivar do artefato. O vertical slicing evita a maior parte disso, porque um slice que entrega comportamento novo falha, por construção, no commit de base. Ainda vale a pena conferir à mão. Para cada critério, diga a observação que o mostraria falso e confirme que ele falha no commit de onde o implementador parte.

**Os tickets estão publicados. Como eu os executo de fato?**
A skill para no artefato, e não há modo de despacho automático. O despacho é manual: olhe o quadro, conte os tickets sem bloqueadores abertos e abra esse número de sessões de agente. Dê a cada ticket um contexto novo, e limpe entre eles. A [implement](./implement.md) não fecha nem marca o ticket de forma confiável quando termina, nem no GitHub nem no markdown local, então você mesmo atualiza o estado do ticket.

## Está funcionando se

- Todo ticket tem resposta para "o que eu consigo demonstrar quando isto estiver pronto?", e a resposta é um comportamento, não uma camada.
- A lista volta para você numerada, com uma linha "Bloqueado por" em cada um, antes de qualquer coisa ser publicada.
- O ticket do topo não tem bloqueadores e pode começar imediatamente.
- Nada no corpo de um ticket é caminho de arquivo ou número de linha, exceto um trecho produzido por um protótipo.
- Cada ticket se lê como algo que uma sessão nova conseguiria terminar sem você na sala.
- A pré-refatoração, quando encontrada, fica no começo da ordem e não misturada nos tickets de funcionalidade.

## Onde se encaixa

A `to-tickets` é um passo da cadeia principal de construção:

```txt
grill-with-docs → to-spec → to-tickets → implement → code-review → retro
```

Antes dela vem a [to-spec](./to-spec.md), que lhe entrega uma spec resolvida para fatiar. Mantenha as duas numa mesma context window, sem limpar entre elas. Depois vem a [implement](./implement.md), que constrói um ticket por sessão nova, conduzindo a [tdd](./tdd.md) para os testes e fechando com a [code-review](./code-review.md). A [implement-spec](./implement-spec.md) é o outro caminho a partir daqui. Ela lê as mesmas arestas de bloqueio como um grafo de tarefas e constrói em paralelo todos os tickets prontos num único branch de integração. Quando não tiver certeza de qual skill ou fluxo serve, a [ask-matt](./ask-matt.md) te orienta.
