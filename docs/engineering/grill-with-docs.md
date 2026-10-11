## O que faz

A `grill-with-docs` te entrevista sobre um plano ou design até você e o [agent](https://www.aihero.dev/ai-coding-dictionary/agent) terem o mesmo entendimento dele, e escreve no seu repositório o vocabulário e as decisões difíceis enquanto faz isso. É a mesma entrevista que a [grill-me](../productivity/grill-me.md) roda (uma rodada de perguntas, depois espera, depois a próxima rodada), apontada para uma codebase.

Ela é **[stateful](https://www.aihero.dev/ai-coding-dictionary/stateful)** (com estado). Todas as outras skills de sabatina deixam a [session](https://www.aihero.dev/ai-coding-dictionary/session) só na sua cabeça; esta deixa arquivos no disco. Quando um termo se resolve, a skill o escreve no `GLOSSARY.md` na hora, não numa leva no final. Quando uma decisão passa por três barreiras, a skill a escreve como ADR. Essa é a diferença inteira, e é também a causa da maioria dos problemas que as pessoas têm com a skill. Os artefatos são arquivos reais num repositório real, então podem estar faltando quando você esperava que estivessem lá, e podem se desencontrar quando mais de uma pessoa escreve neles.

## Quando usar

Você invoca esta digitando `/grill-with-docs`, e o agente não vai recorrer a ela sozinho.

Use no começo de uma mudança, num repositório, quando o plano ainda está nebuloso e as palavras para a coisa ainda não estão fixadas. Ela é a ferramenta de uma sessão só. A skill de sabatina certa depende do que está na sua frente:

| O que você tem | Use |
| --- | --- |
| Você não está trabalhando num diretório de trabalho | [grill-me](../productivity/grill-me.md) |
| Um repositório, e uma mudança que dá para resolver numa sessão | `grill-with-docs` |
| Um esforço grande demais para caber numa sessão (um projeto do zero, uma funcionalidade grande) | [wayfinder](./wayfinder.md) |
| Um repositório sem documentação de domínio nenhuma, e nenhuma funcionalidade específica em mente | `grill-with-docs`, apontada para o repositório e não para uma mudança |
| Uma decisão travada num conhecimento que está na cabeça de outra pessoa | [to-questionnaire](../productivity/to-questionnaire.md) |

A divisão com a wayfinder se resume ao número de sessões: `/grill-with-docs` para planejamento numa sessão só, `/wayfinder` para planejamento em várias sessões.

## Pré-requisitos

A skill escreve no seu repositório, então você precisa estar num lugar onde seja seguro escrever. Os termos resolvidos vão para um glossário `GLOSSARY.md` na raiz, ou para o `GLOSSARY.md` do contexto relevante, se um `GLOSSARY-MAP.md` na raiz marcar o repositório como de múltiplos contextos. As decisões vão para `docs/adr/`. A skill só cria os dois quando precisa deles. Nada existe até o primeiro termo ou decisão ser fixado, então você não prepara nada de antemão.

Ela também precisa de duas outras skills presentes, porque o próprio `SKILL.md` dela é uma linha que delega para elas. A [grilling](../productivity/grilling.md) fornece a entrevista, e a [domain-modeling](./domain-modeling.md) fornece a escrita. Instalar só a `grill-with-docs` te dá uma skill que não funciona.

## O rastro em papel

Três coisas saem de uma sessão, e elas não são iguais.

| O que se resolveu | Onde vai parar |
| --- | --- |
| Um termo: a palavra do próprio projeto para uma coisa | `GLOSSARY.md`, no caminho, no momento em que se resolve |
| Uma decisão difícil de reverter, surpreendente sem contexto e um trade-off real | Um ADR em `docs/adr/` |
| Todo o resto que você decidiu | A conversa, e mais nenhum lugar |

A terceira linha é a que pega as pessoas desprevenidas. O `GLOSSARY.md` é só um glossário. Ele não guarda detalhes de implementação, nem [spec](https://www.aihero.dev/ai-coding-dictionary/spec), nem rascunhos. Um ADR precisa das três condições ao mesmo tempo, então a maioria das decisões não se qualifica e a maioria das sessões não produz nenhum. Uma sessão que rende um glossário mais afiado e zero ADRs está funcionando como projetado, mas significa que a maior parte do que vocês combinaram existe só na [context window](https://www.aihero.dev/ai-coding-dictionary/context-window) em que foi combinada. Entregue essa mesma conversa para a [to-spec](./to-spec.md) em vez de fazer [clearing](https://www.aihero.dev/ai-coding-dictionary/clearing) dela.

O glossário é a saída principal. Esta skill constrói linguagem de domínio: as palavras do próprio projeto, combinadas uma vez, para que você, o agente e seus colegas não precisem decifrá-las de novo. Nem todo mundo concorda que isso melhora o desempenho do agente. A objeção mais forte é que um termo e a explicação dele em linguagem comum dão o mesmo resultado no [model](https://www.aihero.dev/ai-coding-dictionary/model), e que o vocabulário encurta principalmente a comunicação entre os humanos que o compartilham. Nessa visão, o glossário continua valioso, mas o valor vai para os humanos.

## Perguntas frequentes

**Uso esta ou a `/wayfinder`?**
O escopo decide. Use esta para qualquer coisa que dá para resolver numa sessão; use a [wayfinder](./wayfinder.md) quando o esforço for grande demais para caber numa, e ela traça primeiro o trabalho como um mapa de [tickets](https://www.aihero.dev/ai-coding-dictionary/ticket) de decisão. A wayfinder é mais lenta e mais densa, e recorrer a ela numa funcionalidade bem delimitada é o erro comum. Ela não substitui esta skill, e pode iniciar uma sessão de sabatina para as partes do mapa que pedem uma.

**Ela rodou, mas não apareceu nenhum `GLOSSARY.md` nem ADR.**
Há duas causas conhecidas. A primeira é que nada se qualificou. ADRs precisam passar nas três barreiras, e uma sessão sobre uma mudança sem vocabulário novo não tem nada a escrever. A segunda é um bug real. Quando a skill roda dentro de outra camada de orquestração (um invólucro de desenvolvimento guiado por spec, um framework multiagente, uma regra que a invoca como passo do pipeline de outra pessoa), os usuários relatam que a metade que escreve arquivos silenciosamente não acontece, enquanto a entrevista continua rodando. O bug está registrado e não foi corrigido. Se você estiver nesse cenário, confira o diretório de trabalho antes de confiar na saída da sessão.

**Ela perguntou tudo de uma vez, sem recomendações, e nunca mencionou o `GLOSSARY.md`.**
É a skill falhando em carregar as duas dependências. Como o `SKILL.md` é uma delegação de uma linha, um agente que não carrega a [grilling](../productivity/grilling.md) e a [domain-modeling](./domain-modeling.md) chuta o que sabatina significa, e você recebe todas as perguntas de uma vez, sem estrutura. O carregamento parcial é mais confuso. A `grilling` carrega, a `domain-modeling` não, e você ganha uma boa entrevista sem rastro em papel. A frequência disso depende do modelo e do nível de [effort](https://www.aihero.dev/ai-coding-dictionary/effort), e é o problema mais relatado desta skill. Se suspeitar disso, pergunte diretamente ao agente quais skills ele carregou.

**Para onde foram todas as minhas outras decisões?**
Só para a conversa. Esta é a reclamação em aberto mais séria sobre a skill. O glossário não é uma spec, a maioria das respostas não merece um ADR, e nenhum registro liga cada resposta resolvida a uma spec, um ticket e um teste. Os passos seguintes amaciam respostas precisas (garantias de ordem, requisitos negativos, valores padrão numéricos) em prosa mais fraca, e o resultado pode parecer completo enquanto falta justamente o que você decidiu. Por enquanto, mantenha a sessão e entregue-a direto para a [to-spec](./to-spec.md). Depois releia a spec comparando com as suas próprias respostas, em vez de supor que ela as registrou.

**Posso apontá-la para um repositório existente que não tem documentação nenhuma?**
Pode. Esta é a skill certa para uma codebase sem ADRs, sem linguagem de domínio e sem princípios de design: invoque-a e diga "me ajude a documentar meu repositório". Os usuários costumam combiná-la com a [improve-codebase-architecture](./improve-codebase-architecture.md) para construir ou consertar um `GLOSSARY.md`. Espere ter de conduzi-la. Ela lê o código e te pergunta sobre o que encontra, e você decide quais das palavras que já existem na codebase são as certas.

**O que eu faço quando a sessão termina?**
A mensagem de fechamento da skill muitas vezes fica em aberto, o que é um problema conhecido. No fluxo principal, a resposta é a [to-spec](./to-spec.md), na mesma conversa. Se a mudança for pequena o bastante para construir logo, vá direto para a [implement](./implement.md).

**Por que ela se chama assim?**
Ninguém está satisfeito com o nome. Existe uma sugestão aberta para renomeá-la para `grill-domain-model`, que descreve o comportamento com mais precisão. Nada andou nisso. Se uma renomeação acontecer, a página de documentação vai junto e a URL muda.

## Está funcionando se

- O `GLOSSARY.md` muda *durante* a sessão, termo a termo, em vez de aparecer de uma vez no final.
- O glossário se lê como vocabulário puro (as palavras do seu projeto com definições enxutas) e não contém detalhe de implementação nem prosa com cara de spec.
- As perguntas que a codebase consegue responder são respondidas lendo a codebase, não perguntadas a você.
- Você ganha poucos ADRs ou nenhum, e os que aparecem são decisões que você ficaria irritado de ter que discutir de novo.
- Ela questiona uma palavra que você usou porque o seu glossário existente a define de outro jeito.

## Onde se encaixa

A `grill-with-docs` é o começo da cadeia principal de construção:

```txt
grill-with-docs → to-spec → to-tickets → implement → code-review → retro
```

Ela vem antes de qualquer coisa ser escrita como spec. Ela produz o entendimento compartilhado e o vocabulário fixado que a [to-spec](./to-spec.md) depois sintetiza sem te entrevistar de novo. As vizinhas próximas são a [grill-me](../productivity/grill-me.md), a mesma entrevista sem repositório e sem arquivos, e a [domain-modeling](./domain-modeling.md), a disciplina de glossário e ADR que ela conduz; as duas usam a primitiva [grilling](../productivity/grilling.md) para a entrevista. Antes dela, a [wayfinder](./wayfinder.md) traça esforços grandes demais para uma sessão e pode devolver partes do mapa para ela. Quando não tiver certeza de qual skill ou fluxo serve, a [ask-matt](./ask-matt.md) te orienta.
