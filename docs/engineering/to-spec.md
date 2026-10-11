## O que faz

A `to-spec` transforma a conversa que você acabou de ter numa **[spec](https://www.aihero.dev/ai-coding-dictionary/spec)** e a publica no seu issue tracker como uma única issue.

Ela não te entrevista. Quando você recorre a ela, as decisões já foram tomadas. Então ela sintetiza o que se sabe (a partir da conversa, da codebase, do seu `GLOSSARY.md` e dos ADRs) e não começa uma nova rodada de perguntas. A spec registra decisões que você já tomou. Ela não é lugar para tomar decisões novas.

## Quando usar

Você invoca esta digitando `/to-spec`; o [agent](https://www.aihero.dev/ai-coding-dictionary/agent) não vai recorrer a ela sozinho.

Use quando a construção for grande demais para uma [session](https://www.aihero.dev/ai-coding-dictionary/session) de agente e precisar ser dividida em várias. Esse é o gatilho inteiro:

| Onde você está | O que rodar |
| --- | --- |
| Você ainda não decidiu nada | [grill-with-docs](./grill-with-docs.md) primeiro |
| Decidido, e o trabalho cabe numa [context window](https://www.aihero.dev/ai-coding-dictionary/context-window) | [implement](./implement.md): pule a spec |
| Decidido, e o trabalho se estende por várias sessões | `/to-spec`, depois [to-tickets](./to-tickets.md) |
| Um mapa da [wayfinder](./wayfinder.md) clareou | `/to-spec #<issue_do_mapa>` |

## Pré-requisitos

A `to-spec` publica a spec como uma issue, então a [setup-matt-pocock-skills](./setup-matt-pocock-skills.md) precisa antes configurar um tracker e o vocabulário de labels de triagem deste repositório. Qualquer tipo de tracker funciona: um tracker real como o GitHub, ou arquivos markdown locais em `.scratch/`, que funcionam sem configuração extra.

## A spec é um registro de decisões

A spec existe porque as janelas de contexto acabam. Você resolveu muitas coisas durante a [grilling](https://www.aihero.dev/ai-coding-dictionary/grilling): a forma da solução, as escolhas que vocês discutiram e o que você recusou de propósito. Tudo isso está numa conversa que você está prestes a limpar. A spec guarda isso.

Então a spec não valida nem decide nada. Ela registra o que você decidiu, no vocabulário do seu próprio projeto, para que uma sessão nova possa pegar o trabalho sem você explicá-lo de novo. Se a spec afirma algo que você nunca disse, isso é um defeito.

## Seams antes da prosa

Antes de escrever qualquer coisa, a `to-spec` esboça os **seams** em que a funcionalidade vai ser testada e os confere com você. Ela prefere seams existentes a novos, e escolhe o seam mais alto que conseguir. O número ideal de seams para uma mudança é um.

Outras skills usam esses seams combinados depois. A [tdd](./tdd.md) só trabalha em seams combinados de antemão. A [code-review](./code-review.md) revisa o diff contra a spec, então um seam que ninguém combinou aparece como descoberta da revisão. As duas ligações passam por este documento. É por isso que você deve levar a sério a conversa sobre seams aqui, e não deixá-la para a implementação.

## Perguntas frequentes

**Para onde foi a `/to-prd`?**
É esta skill, renomeada na v1.1. "Spec" agora é o termo único usado em todo lugar, e o slug antigo `to-prd` não funciona mais, então reinstale com o nome novo. O vocabulário antigo foi substituído pelo par *spec* e *tickets*. A spec é o destino e as decisões que o fixam. Os [tickets](https://www.aihero.dev/ai-coding-dictionary/ticket) são os passos que levam até lá. Se você mudar de direção, apague os tickets inacabados e mantenha a spec.

**Por que a spec ganha a label `ready-for-agent`? Não quero um agente implementando a partir dela.**
A label significa "não precisa de mais triagem": o documento está completo o bastante para um agente trabalhar a partir dele. Ela marca uma entrada, não uma ordem de serviço. Mas agentes [AFK](https://www.aihero.dev/ai-coding-dictionary/afk) que procuram `ready-for-agent` não enxergam essa diferença. Eles vão tentar construir a spec inteira numa execução em vez de pegar os tickets. Este é o problema mais relatado da skill. Até isso mudar, exclua explicitamente a spec mãe no prompt do seu agente AFK, ou tire a label depois que a `/to-tickets` rodar.

**Por que não ir direto da sabatina para a `/to-tickets` e pular a spec?**
Muitas vezes você deve. A spec só compensa o passo em trabalho de várias sessões. O valor dela é que os tickets são descartáveis e a spec não. Cada ticket é dimensionado para uma janela de contexto nova e depois é apagado ou fechado, enquanto a spec fica como o único lugar que registra o raciocínio por trás deles. Numa mudança de uma sessão só, isso não te dá nada, e você paga por um passo extra de síntese em que o [model](https://www.aihero.dev/ai-coding-dictionary/model) pode se desviar. Vá da sabatina para a `/implement`.

**Acabei de terminar um mapa da wayfinder. O que eu passo para ela?**
Passe a issue principal do mapa, `/to-spec #<issue_do_mapa>`, não os tickets de decisão individuais. A [wayfinder](./wayfinder.md) produz decisões espalhadas por um mapa, não entregáveis. A `to-spec` as condensa num documento a partir do qual dá para construir. Se você levar o mapa direto para a `/implement`, perde esse passo.

**A spec é para eu revisar, ou é só para o agente?**
Principalmente para o agente, e ela se lê assim: completa, densa e cheia de referências. Leia os seams e a seção de fora do escopo. Nesses dois lugares, uma decisão errada é mais barata de pegar agora e mais cara de descobrir depois. As pessoas reclamam de ter que ler tudo, e não há modo resumo. Mas, se a spec te surpreender, a sabatina foi rasa demais; a spec não está longa demais.

**Mantenho a spec congelada depois que os tickets começam, ou deixo o agente reescrevê-la?**
Nada a mantém sincronizada. Na prática, ela é um retrato do que você sabia naquele momento, e fica desatualizada na primeira vez que a implementação te ensinar algo. Trate-a como descartável depois que o trabalho for entregue. O seu `GLOSSARY.md` e os ADRs são os arquivos feitos para durar. Se você aprender durante a implementação algo que deveria durar, coloque lá, não numa spec editada.

**Meu trabalho é uma refatoração ou uma fronteira de módulo, não uma funcionalidade. O modelo serve?**
Serve menos, e é uma limitação conhecida. O modelo se apoia muito em histórias de usuário, que não combinam com trabalho de arquitetura. Você acaba escrevendo histórias que ninguém pediu em volta de decisões que na verdade são sobre interfaces e invariantes. Use as seções de decisões de implementação e de decisões de teste. Registre as decisões de arquitetura duradouras como ADRs pela [grill-with-docs](./grill-with-docs.md), não na spec.

**Ela procura trabalho relacionado no tracker, ou cita os ADRs que está respeitando?**
Não às duas coisas. Ela lê e segue os ADRs da área que toca, mas não faz link para eles. Ela também não procura no tracker issues que se sobreponham antes de escrever, então uma spec pode duplicar um trabalho que alguém já registrou, e nada te avisa. Se a área estiver movimentada, procure no tracker você mesmo antes.

**A `/to-tickets` não conseguiu ler a minha spec: ficava cortando.**
Uma issue do tracker pode não devolver uma spec muito grande por inteiro, e não há uma cópia local para usar no lugar. Para corrigir, não faça [clearing](https://www.aihero.dev/ai-coding-dictionary/clearing) nem [compaction](https://www.aihero.dev/ai-coding-dictionary/compaction) entre a `/to-spec` e a `/to-tickets`. Rode as duas na mesma janela, e a `/to-tickets` nunca vai precisar buscar a spec de novo.

## Está funcionando se

- Ela começa a escrever em vez de te fazer uma nova rodada de perguntas.
- Ela te mostra os seams antes de escrever, e propõe o mínimo que consegue.
- Ela usa os substantivos do seu projeto, não um texto genérico de gestão de produto.
- Você se lembra de ter tomado cada decisão que está nela. Ela não inventou nada para preencher uma seção.
- A seção de fora do escopo lista coisas reais. O que você recusou costuma ser o conjunto de linhas mais útil da página.

## Onde se encaixa

A `to-spec` é um passo da cadeia principal de construção, mas só no ramo de várias sessões:

```txt
grill-with-docs → to-spec → to-tickets → implement → code-review → retro
```

Antes dela, a [grill-with-docs](./grill-with-docs.md) toma as decisões que esta skill só registra, e um mapa terminado da [wayfinder](./wayfinder.md) entra na cadeia aqui. Depois, a [to-tickets](./to-tickets.md) corta a spec em tickets tracer-bullet para a [implement](./implement.md) construir. Quando não tiver certeza de qual skill ou fluxo serve, a [ask-matt](./ask-matt.md) te orienta.
