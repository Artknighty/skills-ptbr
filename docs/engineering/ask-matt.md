## O que faz

A `ask-matt` é o roteador sobre as skills deste repositório. Você descreve a situação em que está (uma ideia que não consegue começar, uma pilha de relatos de bug chegando, uma [session](https://www.aihero.dev/ai-coding-dictionary/session) que se estendeu demais), e ela nomeia a skill ou a sequência de skills que serve, mais onde ficam as decisões humanas nessa sequência.

Ela recomenda e para. Ela não sabatina, não escreve uma [spec](https://www.aihero.dev/ai-coding-dictionary/spec), não abre arquivo nenhum e não dispara a skill que acabou de citar; o que você recebe de volta é a próxima coisa a digitar, e quem digita é você. Ela também é um mapa escrito à mão das skills deste repositório, não uma varredura do que você tem instalado, então ela não te orienta pelas suas próprias skills nem pelas de outro autor.

## Quando usar

Você invoca esta digitando `/ask-matt`; o agente não vai recorrer a ela sozinho.

| A sua situação | O que o roteador devolve |
| --- | --- |
| Uma ideia, e nenhuma ideia de por onde começar | O começo do fluxo principal, e se a construção é pequena o bastante para pular a spec |
| Bugs e pedidos chegando de outras pessoas | A rampa de acesso da [triage](./triage.md), e por que [tickets](https://www.aihero.dev/ai-coding-dictionary/ticket) que você mesmo gerou não passam por ela |
| Duas skills que parecem intercambiáveis | A linha entre elas, que costuma ser um teste concreto e não questão de gosto. [grill-me](../productivity/grill-me.md) ou [grill-with-docs](./grill-with-docs.md) depende de você estar num diretório de trabalho; [grill-with-docs](./grill-with-docs.md) ou [wayfinder](./wayfinder.md) depende de o esforço caber numa sessão |
| Uma sessão longa e uma decisão sobre o [context](https://www.aihero.dev/ai-coding-dictionary/context) | A árvore ordenada das cinco opções numa fronteira de fase |
| Uma skill que você já escolheu | Nada de útil. Invoque essa skill diretamente. |

## Pré-requisitos

O roteador cita skills; ele não as instala. Tudo para o que ele aponta precisa estar instalado para a recomendação ser acionável, e ele só conhece as skills promovidas deste repositório.

As rotas que dependem do tracker (triage, `to-spec`, `to-tickets`, `implement`) pressupõem que a [setup-matt-pocock-skills](./setup-matt-pocock-skills.md) já configurou um issue tracker no repositório. O roteador as recomenda mesmo antes de isso acontecer.

## Fluxos, não skills

A palavra-guia da skill é **fluxo**, um caminho *através* das skills, não uma skill só. Quando você descreve a sua situação, o roteador te coloca num passo de um fluxo. Isso é uma resposta diferente de "eis a skill que bate com as suas palavras-chave". Há cinco tipos de rota, e a própria skill os descreve por inteiro:

- **O fluxo principal**, da ideia à entrega. Sabatina, spec, tickets, implementação (um ticket por vez, ou o grafo de tarefas inteiro em paralelo com a [implement-spec](./implement-spec.md)), revisão e depois a [retro](./retro.md), que devolve ao ambiente do agente o que a construção ensinou. Ele tem duas bifurcações. Uma é o desvio por um protótipo, para quando uma pergunta precisa de código rodando para ser resolvida. A outra é a divisão em spec e tickets, que só compensa o custo quando a construção leva mais de uma sessão.
- **Rampas de acesso**, para uma situação que gera trabalho e depois desemboca no fluxo principal: relatos de bug chegando, algo quebrado, ou um esforço nebuloso e grande demais para caber numa sessão.
- **Saúde do código**, manutenção e não trabalho de funcionalidade. A [improve-codebase-architecture](./improve-codebase-architecture.md) levanta oportunidades de aprofundamento no código, e cada uma que ela encontra volta ao fluxo principal como ideia.
- **Avulsas**, que ficam fora de todos os fluxos e que você usa sozinhas: o protótipo, o questionário, a pesquisa.
- **Uma camada de vocabulário por baixo**, as duas referências que as outras skills puxam quando o problema são as palavras, não o processo.

## A fronteira de fase

A outra ideia-chave da skill é a **fronteira de fase**. Uma fase é um bloco de trabalho dentro de uma sessão (a [grilling](https://www.aihero.dev/ai-coding-dictionary/grilling), a implementação, o QA), e a fronteira entre duas delas é o único lugar em que cabe a pergunta "o que eu faço com este contexto?". No meio de uma fase não há nada a decidir: continue, ou divida o que falta em [subagents](https://www.aihero.dev/ai-coding-dictionary/subagent).

| Opção | Use quando |
| --- | --- |
| **Continuar** | A próxima fase quer esta na íntegra, ou você ainda tem [smart zone](https://www.aihero.dev/ai-coding-dictionary/smart-zone). É o único lance que mantém a sessão como [primary source](https://www.aihero.dev/ai-coding-dictionary/primary-source), então descarte-o primeiro |
| **`/clear`** | Tudo o que ficou para trás é descartável. A opção mais barata, e você não consegue desfazer se estiver errado |
| **[handoff](../productivity/handoff.md)** | Algo precisa viajar: um novo [harness](https://www.aihero.dev/ai-coding-dictionary/harness), um novo diretório, um colega, uma tarefa paralela separada no meio da fase |
| **Subagente** | A tarefa é delimitada o bastante para rodar com você [longe do teclado](https://www.aihero.dev/ai-coding-dictionary/afk) |
| **`/compact`** | Nenhuma das anteriores. É o padrão, e a árvore muitas vezes termina aqui |

As pessoas costumam errar duas dessas, e é por isso que o roteador dá a ordem e não só a lista. O `/handoff` parece o jeito geral de passar de uma janela de contexto para outra, mas não é. Tudo o que ele te dá é portabilidade. O `/compact` é a última opção da árvore, não a primeira, porque cada uma das quatro acima dele é mais barata ou mais precisa.

## Perguntas frequentes

**Não existe simplesmente uma lista das skills na ordem certa?**

As pessoas vivem pedindo uma no README. Esta skill é essa lista. Uma tabela estática diria `wayfinder → to-spec → to-tickets → implement → code-review → retro` e estaria errada na maioria das situações. As partes importantes são as bifurcações: existe uma codebase, a construção leva várias sessões, dá para resolver esta pergunta conversando. O custo é que o roteador é mantido à mão, então fica atrás do repositório. A `/grilling` foi lançada muito antes de o roteador citá-la.

**Ela me disse que metade das skills não está instalada.**

É um bug conhecido, e não está corrigido. A maioria das skills pelas quais o roteador te orienta define `disable-model-invocation: true`, o que significa que o harness as deixa fora da lista de skills que ele injeta no contexto do agente. O agente lê essa lista como completa e diz que elas estão faltando. Numa sessão relatada, ele declarou ausente todo o fluxo de spec e tickets e redirecionou para `/grilling` e `/tdd` puros. Dezesseis das vinte e sete skills do plugin têm essa flag, então esse é o caso comum, não uma exceção. Elas estão instaladas. Digite o comando de barra mesmo assim, ou confira o `.claude-plugin/plugin.json`, que é a autoridade sobre o que está presente.

**Ela descreveu o comportamento de uma skill, e a skill não faz isso.**

Também é um bug real, e também não está corrigido. O roteador responde a partir do próprio resumo de uma linha de cada skill, não a partir da skill. Um relato detalhado registrou três casos numa única sessão, incluindo uma recomendação de pular a [to-spec](./to-spec.md) baseada só no resumo "transforma a conversa numa spec". O roteador nunca abriu o `to-spec/SKILL.md`. Em todos os casos ele só verificou depois que o usuário questionou, nunca por iniciativa própria. Pular a `to-spec` ali custou uma verificação de seams de verdade, e os tickets que saíram subestimaram o trabalho. Quando o roteador afirmar algo sobre outra skill e você for agir com base nisso, peça para ele abrir aquele `SKILL.md` primeiro. O mesmo vale para perguntas que o mapa nem cobre, como usar ou não o [plan mode](https://www.aihero.dev/ai-coding-dictionary/agent-mode): essa resposta é dedução do [model](https://www.aihero.dev/ai-coding-dictionary/model), não algo escrito aqui.

**Por que é prosa em vez de um checklist numerado?**

É uma reclamação justa. Uma issue aberta argumenta que a maior parte do roteamento é determinística e que a narrativa dificulta escanear. Nada te impede de pedir a forma comprimida: "só me dá a sequência" te dá a sequência. A prosa carrega a parte condicional: as bifurcações, onde se espera uma decisão humana e onde limpar ou compactar entre os passos. Um checklist plano perde exatamente isso.

**Ela consegue me orientar pelas minhas próprias skills, ou pelas de outro autor?**

Não. Três propostas diferentes pediram um roteador que leia o seu diretório `skills/` local e recomende a partir do que estiver instalado. A `ask-matt` não é isso. Ela é um mapa de um conjunto, mantido à mão, e não sabe nada sobre skills que você escreveu ou instalou de outro lugar.

**Ela me mandou editar um SKILL.md.**

O conselho muitas vezes está certo, mas a edição raramente dura. Alguém perguntou como fazer a [implement](./implement.md) fechar tickets, ouviu que devia acrescentar uma linha na skill e viu o problema na hora. O `npx skills update` sobrescreve o arquivo, e a instalação pelo plugin é somente leitura. Coloque comportamentos permanentes no seu próprio `CLAUDE.md` ou `AGENTS.md`, ou diga na invocação. Mudanças feitas no prompt sobrevivem às atualizações. É assim que as pessoas apontam o fluxo para o Linear em vez do GitHub, ou perguntam quais tickets abertos poderiam rodar em paralelo.

**Ela citou uma skill que eu não tenho, ou deixou de citar uma que eu tenho.**

Confira no changelog se houve uma renomeação antes de supor que ela sumiu. A `writing-great-skills` virou [writing-for-agents](../productivity/writing-for-agents.md) sem alias, a `to-prd` virou [to-spec](./to-spec.md), e a `pathfinder` virou [wayfinder](./wayfinder.md). Quatro skills foram aposentadas de vez e absorvidas por outras: `ubiquitous-language`, `design-an-interface`, `qa` e `request-refactor-plan`. Se ela deixar de citar uma skill que você tem, é o atraso do próprio roteador, descrito acima.

## Está funcionando se

- Ela termina dizendo o que digitar e para por aí, em vez de começar o trabalho sozinha.
- A rota que ela devolve menciona onde limpar ou compactar o contexto e onde se espera a sua revisão, não só uma lista de nomes de skills.
- Quando duas skills são parecidas, ela diz qual usar e por que a outra é errada para você.
- Qualquer afirmação dela sobre o comportamento de outra skill aparece no rastro como ela lendo o `SKILL.md` dessa skill.
- Você reconhece a sua própria situação no que ela devolve, e não o cenário genérico mais próximo.

## Onde se encaixa

A `ask-matt` é um **roteador avulso** que fica acima de todo o conjunto. Ela nunca é um passo numa cadeia. Ela aponta para dentro de todas as cadeias, e as outras páginas de documentação linkam de volta para ela para que nenhuma precise redesenhar o grafo. Daqui você costuma cair na [grill-with-docs](./grill-with-docs.md), o começo do fluxo principal, ou na [triage](./triage.md), a rampa de acesso para trabalho que chegou, e não trabalho que você começou.

Ela é uma [secondary source](https://www.aihero.dev/ai-coding-dictionary/secondary-source) sobre as skills que descreve. Quando o roteador e um `SKILL.md` discordarem, o `SKILL.md` está certo.
