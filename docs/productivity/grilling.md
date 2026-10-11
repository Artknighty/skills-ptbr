## O que faz

A `grilling` é o loop de entrevista que põe à prova um plano, uma decisão ou uma ideia antes que alguém aja com base neles. Ela mapeia o assunto como uma **árvore de design**: cada decisão se ramifica nas decisões que dependem dela, e ela te entrevista ramo por ramo até nenhuma suposição ficar sem ser dita.

Ela não faz uma pergunta por vez, e não faz todas de uma vez. Cada **rodada** traz a **fronteira** inteira: toda decisão cujos pré-requisitos já estão resolvidos, e nada além disso. Duas perguntas nunca dividem uma rodada se uma depender da outra; uma pergunta que depende de uma resposta ainda aberta fica para uma rodada posterior. As suas respostas resolvem decisões, a fronteira avança, e a próxima rodada pergunta o que isso destravou. Treze perguntas normalmente cabem em umas três rodadas, não em treze.

## Quando usar

Digite `/grilling`, ou o [agent](https://www.aihero.dev/ai-coding-dictionary/agent) recorre a ela sozinho quando uma tarefa se encaixa. É a única [skill](https://www.aihero.dev/ai-coding-dictionary/skill) da família de sabatina invocada pelo modelo, então você raramente a digita. Normalmente uma skill que você *digitou* a roda por você.

Digitar `/grilling` diretamente te dá a entrevista pura e nada mais. Quando você quiser algo além disso:

| O que você tem | Use |
| --- | --- |
| Você não está num diretório de trabalho | [grill-me](./grill-me.md): a mesma [session](https://www.aihero.dev/ai-coding-dictionary/session), com um nome que o agente nunca dispara sozinho |
| Você está num diretório de trabalho | [grill-with-docs](../engineering/grill-with-docs.md): a mesma sessão, e ela escreve `GLOSSARY.md` e ADRs pelo caminho |
| Um esforço grande demais para caber numa sessão | [wayfinder](../engineering/wayfinder.md): ela traça um mapa e roda a sabatina dentro dos tickets de decisão |
| Uma pergunta que conversa não resolve: como algo deveria parecer ou se comportar | [prototype](../engineering/prototype.md): construa a versão descartável e depois volte |
| Uma skill sua que precisa de uma entrevista | Invoque `/grilling` a partir dela, em vez de escrever outra entrevista |

## A rodada, a fronteira e quem decide

A skill se apoia em três ideias.

A **árvore de design** é o modelo do assunto: decisões com decisões penduradas nelas. A **fronteira** é o conjunto de decisões cujos pré-requisitos estão todos resolvidos: as únicas perguntas que o agente já pode fazer. Uma **rodada** é uma fronteira, perguntada por inteiro e respondida por inteiro.

Dentro de uma rodada, toda pergunta tem um formato fixo: numerada e com título depois de um `❓`, depois o corpo, depois a resposta recomendada do agente sozinha numa linha com `➡️`. Esse formato permite responder uma rodada pelo número ("1 sim, 2 a segunda opção, 3 não, explico por quê") em vez de citar as perguntas de volta. O formato tem um problema conhecido. Às vezes a recomendação argumenta *contra* a pergunta do jeito que ela foi redigida, então concordar com a recomendação significa responder "não" à pergunta. Quando isso acontecer, responda à recomendação e deixe isso claro.

A outra metade do design é a separação entre fatos e decisões. Fatos são trabalho da própria skill. Quando uma pergunta da fronteira precisa de algo que o [environment](https://www.aihero.dev/ai-coding-dictionary/environment) (ambiente) pode resolver, o agente despacha um [subagent](https://www.aihero.dev/ai-coding-dictionary/subagent) para descobrir em vez de te perguntar. A rodada não espera essa pesquisa; só as perguntas que dependem dela esperam. As decisões são suas, e o agente precisa esperar por elas. Um agente rodando a `grilling` que responde às próprias decisões quebrou a skill. A sessão termina quando a fronteira fica vazia. O agente então espera você confirmar um entendimento compartilhado antes de agir com base no que vocês combinaram.

A fronteira tem um limite. O agente a escolhe por julgamento; não a calcula a partir de um grafo. Então ele pode colocar duas perguntas na mesma rodada e só depois perceber que uma resposta deveria ter mudado a outra. A única proteção é avisá-lo. Isso reabre o ramo afetado na rodada seguinte.

## O que fica aqui e o que fica nos invólucros

Esta página cobre o mecanismo. As páginas das skills que envolvem esta respondem às perguntas mais comuns.

| Pergunta | Onde é respondida |
| --- | --- |
| A árvore, a fronteira, as rodadas, o formato das perguntas, fatos vs. decisões | Aqui |
| Quanto tempo uma sessão deve durar, o que fazer com uma pergunta que não dá para responder conversando, como não ficar só balançando a cabeça | [grill-me](./grill-me.md) |
| O que é escrito no `GLOSSARY.md`, o que vira ADR | [grill-with-docs](../engineering/grill-with-docs.md) |

## Perguntas frequentes

**Dá para voltar a uma pergunta por vez?**
Dá, e uma boa parte do público faz isso. Adicione isto ao seu `CLAUDE.md` global:

```
Na sabatina, faça uma pergunta por vez.
```

Nem todo mundo prefere o padrão em rodadas. Usuários que leem devagar, que trabalham numa segunda língua ou que usam o formato sequencial para manter o foco relatam que uma pergunta por vez funciona melhor para eles. Essa opção é uma configuração suportada, não uma gambiarra.

**Para onde foi a `/batch-grill-me`?**
Para dentro desta skill. As perguntas em rodadas saíram por pouco tempo como uma skill separada e depois foram para dentro da própria `grilling`, para que tudo o que é construído sobre a primitiva (`grill-me`, `grill-with-docs`, `triage`, `wayfinder`) ganhasse isso de uma vez. Não existe `batch-grill-me` para instalar, nem uma skill sequencial separada; a linha no `CLAUDE.md` acima é o caminho de volta para uma por vez.

**Fazer uma rodada inteira de uma vez não perde as perguntas que as minhas respostas anteriores teriam levantado?**
Esta é a objeção mais comum às rodadas, e a fronteira responde a ela. Uma rodada só contém perguntas que não dependem umas das outras, então nenhuma resposta de uma rodada consegue invalidar outra pergunta da mesma rodada. As suas respostas continuam mudando o que vem depois delas, porque o agente monta cada rodada seguinte do zero. Você perde alguma coisa, mas menos do que "todas as perguntas de uma vez" dá a entender. Veja o limite da fronteira acima.

**Ela ficou sem perguntas e começou a construir.**
A confirmação existe para isso. A skill termina quando você diz que o entendimento é compartilhado, não quando a fronteira esvazia. [Models](https://www.aihero.dev/ai-coding-dictionary/model) mais fracos e mais rápidos ainda pulam essa etapa. Os usuários relatam isso mais em modelos de menor esforço ou fora da fronteira tecnológica, que reduzem "entreviste até haver entendimento compartilhado" a duas perguntas e um roteiro. Se o seu fizer isso, a correção confiável é uma linha no seu próprio `AGENTS.md` ou `CLAUDE.md` dizendo ao agente para não implementar sem permissão.

**Ela respondeu às próprias perguntas em vez de me perguntar.**
Isso é um bug da execução, e é o motivo de o texto da skill separar fatos de decisões. Acontece mais quando outra skill roda a `grilling` para resolver um ticket e o agente entende essa tarefa como permissão para seguir em frente. A mesma restrição explica por que não existe modo assíncrono. Já pediram uma variante que lê uma issue do GitHub e publica um único memorando de decisão consolidado, e isso é outra skill, porque uma sabatina que ninguém responde produz a opinião do agente, não a sua.

**Dá para limitar o número de perguntas?**
Não, e um limite está fora do escopo de propósito. Alguns planos precisam de três perguntas e outros de cinquenta; um teto fixo ou corta o caso difícil ou parece arbitrário no fácil. O controle pretendido é a linguagem natural. Peça para ela fechar, ou pare e aceite o plano onde está. Se uma sessão estiver ficando muito longa, a causa costuma ser escopo grande demais; quebre o trabalho e sabatine os pedaços.

**Instalei só a `grill-me` e nada acontece.**
A `grill-me` é uma skill de uma linha cujo corpo inteiro é "rode uma sessão de `/grilling`", então ela precisa desta skill instalada também. O mesmo vale para a `grill-with-docs`, que além disso precisa da [domain-modeling](../engineering/domain-modeling.md). Instalar o conjunto inteiro evita o problema; instalar de forma seletiva significa instalar as primitivas também.

**A `grill-with-docs` rodou, mas nunca carregou a `grilling`.**
É um bug real, ainda não corrigido, e os usuários o relatam em vários [harnesses](https://www.aihero.dev/ai-coding-dictionary/harness) e modelos. Uma skill que nomeia outra skill não garante que essa outra seja carregada, e a `grill-with-docs` nomeia duas. O sinal é uma sessão que pergunta tudo de uma vez, sem recomendações. Isso significa que o modelo está improvisando uma entrevista em vez de rodar esta. Perguntar diretamente ao agente se ele carregou a `grilling` e a `domain-modeling` costuma resolver.

## Está funcionando se

- Uma rodada chega como lista numerada, cada pergunta com a recomendação numa linha `➡️` separada, e você consegue responder a rodada inteira pelo número.
- Nada numa rodada precisa que outra pergunta da mesma rodada seja respondida antes.
- As rodadas seguintes perguntam coisas que a primeira não poderia ter perguntado.
- Ela vai atrás dos fatos (lendo arquivos, despachando um subagente) em vez de te perguntar algo que poderia descobrir.
- Uma pesquisa rodando em segundo plano não trava a rodada; só as perguntas que dependem dela esperam.
- Ela para no final e pede para você confirmar que o entendimento é compartilhado, em vez de começar a trabalhar.
- O número de perguntas fica alto enquanto o número de rodadas fica baixo.

## Onde se encaixa

A `grilling` é uma **primitiva**, não um passo que você agenda: a única fonte da verdade da técnica de entrevista, mantida num lugar só para que toda skill que precisa de uma entrevista recorra a ela em vez de inventar uma. A [grill-me](./grill-me.md) e a [grill-with-docs](../engineering/grill-with-docs.md) são as duas portas de entrada invocadas pelo usuário, e a `grill-with-docs` é onde começa a cadeia principal de construção, antes da [to-spec](../engineering/to-spec.md). A [wayfinder](../engineering/wayfinder.md) a roda para resolver tickets de decisão, a [triage](../engineering/triage.md) para transformar um relato vago num relato trabalhável, e a [improve-codebase-architecture](../engineering/improve-codebase-architecture.md) para percorrer a árvore depois que você escolhe um candidato a aprofundar. Quando não tiver certeza de qual porta de entrada serve, a [ask-matt](../engineering/ask-matt.md) te orienta.
