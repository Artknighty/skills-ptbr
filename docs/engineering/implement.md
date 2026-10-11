## O que faz

A `implement` constrói um trabalho que já foi decidido. Você a aponta para um [ticket](https://www.aihero.dev/ai-coding-dictionary/ticket), uma [spec](https://www.aihero.dev/ai-coding-dictionary/spec) ou o plano que vocês acabaram de combinar na conversa, e ela escreve o código, conduz a [tdd](./tdd.md) nos seams, roda o typecheck pelo caminho, roda a [code-review](./code-review.md) no final e faz commit no branch atual.

Ela nunca reabre o plano. Não há entrevista, rodada de esclarecimento nem proposta de abordagem diferente. O que foi resolvido antes é a entrada, e o trabalho inteiro da skill é transformar isso num commit. É isso que a separa de digitar "constrói isso" para um [agent](https://www.aihero.dev/ai-coding-dictionary/agent) novo, que muitas vezes reprojeta o trabalho enquanto o constrói.

## Quando usar

Você invoca esta digitando `/implement`, e o agente não vai recorrer a ela sozinho. Ela vem com `disable-model-invocation: true`, então nenhuma outra skill consegue chamá-la também. Onde a [ask-matt](./ask-matt.md) ou a [to-tickets](./to-tickets.md) disserem "depois `/implement` por ticket", isso é uma instrução para você, não algo que o agente fará sem ser pedido.

Onde o trabalho está agora decide se esta é a skill certa:

| O trabalho está… | Use |
| --- | --- |
| Num ticket no tracker | `/implement #42`, um ticket por [session](https://www.aihero.dev/ai-coding-dictionary/session), fazendo [clearing](https://www.aihero.dev/ai-coding-dictionary/clearing) do contexto entre um ticket e outro |
| Numa spec ainda não dividida, e a construção leva várias sessões | [to-tickets](./to-tickets.md) primeiro, depois `/implement` por ticket |
| Numa spec, e a construção é pequena | `/implement` direto contra a spec |
| Só na conversa que você acabou de ter, e ainda é pequeno | `/implement` ali mesmo, na mesma janela |
| Ainda não está escrito em lugar nenhum | [grill-with-docs](./grill-with-docs.md), ou [grill-me](../productivity/grill-me.md) se não houver codebase |
| Um comportamento concreto que você quer com teste primeiro, sem spec | [tdd](./tdd.md) direto |
| Já construído, e você quer que seja conferido | [code-review](./code-review.md) direto |

O caso da mesma sessão vale ser citado porque a primeira linha da própria skill não o cobre. O `SKILL.md` diz "na spec ou nos tickets", o que empurra o [model](https://www.aihero.dev/ai-coding-dictionary/model) a procurar um arquivo que não existe. Se o plano só existe na conversa, diga isso ao invocá-la.

## Pré-requisitos

A `implement` faz commit no branch em que você está. Ela não cria um, e não pergunta. Confira se está no branch onde quer o trabalho antes de começar.

Se os tickets vieram da [to-tickets](./to-tickets.md), a [setup-matt-pocock-skills](./setup-matt-pocock-skills.md) configurou o tracker em que eles vivem. A `code-review` lê a mesma configuração para encontrar a spec de origem no fechamento.

## O que uma execução faz

Uma execução tem cinco passos, em ordem:

1. Ler o ticket ou a spec e definir os seams.
2. Conduzir a [tdd](./tdd.md) nos seams combinados de antemão, um slice red-green por vez.
3. Rodar o typecheck com frequência e arquivos de teste individuais pelo caminho.
4. Rodar a suíte de testes completa uma vez, no final.
5. Rodar a [code-review](./code-review.md) e depois fazer commit no branch atual.

Uma execução cobre um ticket. Os tickets que a [to-tickets](./to-tickets.md) produz são vertical slices tracer-bullet dimensionados para caber numa única [context window](https://www.aihero.dev/ai-coding-dictionary/context-window) nova, então o ritmo pretendido é: limpar o contexto, implementar um ticket, fazer commit, limpar de novo. Cada ticket é autocontido, então você pode descartar o contexto do ticket anterior.

## Seams combinados de antemão

A ideia central da skill é o **seam**, a fronteira pública em que você observa o comportamento sem enfiar a mão por dentro. Os testes vivem nos seams. Quando o seam é combinado antes de existir qualquer código, os testes duram, e você pode reescrever a implementação por baixo sem mudá-los.

A parte do "combinado de antemão" importa, e também é o ponto mais fraco da skill. Nada dentro da `implement` combina os seams. Quem pergunta é a `tdd`, e ela se recusa a escrever um teste num seam não confirmado. Então, na prática, o acordo acontece antes, na spec, ou na primeira troca da execução. Se não acontecer em lugar nenhum, a execução vira "só escreve o código" e nada te avisa. Citar os seams na spec é o que impede isso.

## Perguntas frequentes

**Ela terminou, mas o meu ticket continua aberto e os critérios de aceitação continuam desmarcados.**

Correto, e esperado. A `implement` não tem passo de conclusão. Ela termina no commit e nunca mexe no item de trabalho. Isso vale tanto no GitHub Issues quanto no tracker de markdown local, então não é um problema de integração com o tracker. Ela também não age sobre as descobertas da `code-review`, e não marca as caixas `- [ ]` da issue de origem. Feche o ticket e confira os critérios você mesmo. Isso importa mais numa cadeia de dependências, porque a `to-tickets` define a fronteira como os tickets cujos bloqueadores estão todos fechados. Se nada for fechado, nada fica visivelmente desbloqueado.

**Posso apontá-la para todos os meus tickets de uma vez, ou rodar vários em paralelo?**

Não com a `/implement`: uma invocação, um ticket. Para uma spec inteira numa execução, use a [implement-spec](./implement-spec.md), que entrega cada ticket da fronteira pronta a um [subagent](https://www.aihero.dev/ai-coding-dictionary/subagent) na própria worktree e depois junta os resultados num único branch de integração. Rodar várias sessões de `/implement` lado a lado num mesmo checkout é pior do que não suportado. Um relato de campo descreve um `git commit --amend` numa sessão caindo no commit de outra sessão, um stash sumindo de `refs/stash` e commits caindo no branch errado, tudo numa única tarde com três issues. As sessões compartilham um diretório de trabalho, um índice e um HEAD. Os usuários contornam isso com git worktrees, mas o `refs/stash` também é compartilhado entre worktrees, então só worktrees não resolvem o caso do stash.

**Ela pode abrir um pull request em vez de fazer commit?**

Não vem embutido. Ela faz commit direto no branch atual. Várias pessoas acham isso afoito demais, porque o código entra antes de elas conseguirem verificar se funciona. Não há flag de configuração nem modo de PR. As pessoas sobrescrevem isso na invocação ("faça commit num branch e abra um PR") ou editando a cópia local da skill. Quando o agente escreve o PR, a [pr](./pr.md) dá forma ao corpo.

**A `code-review` diz que não consegue ver as minhas mudanças.**

A `code-review` revisa `git diff <ponto-fixo>...HEAD`, que exclui as mudanças em stage e na working tree. A `implement` a roda antes do commit, então, a menos que já exista um commit intermediário, não há nada nesse diff para revisar. Várias pessoas relataram isso, e não está corrigido em nenhum dos dois lados. Faça o commit primeiro e depois revise contra o ponto de onde você criou o branch.

À parte disso, algumas pessoas não querem a revisão dentro da execução, porque um agente revisando o código que acabou de escrever tende a favorecer a própria solução. Rodar a [code-review](./code-review.md) numa sessão nova contra um ponto fixo é uma alternativa válida. O mesmo viés é o motivo de aquela skill rodar os dois eixos em subagentes separados.

**Um ticket queimou 150 mil tokens. Estou usando errado?**

Provavelmente não. É mais provável que o ticket seja grande demais. Uma execução explora a codebase, faz um loop red-green por seam, roda a suíte completa e uma revisão, então um ticket não trivial passar de 100 mil [tokens](https://www.aihero.dev/ai-coding-dictionary/token) é normal, não sinal de que algo quebrou. A correção é antes. Dimensione os tickets na [to-tickets](./to-tickets.md) para que cada um caiba numa janela nova. Se um ticket continuar passando do limite, divida-o em vez de aumentar o nível de [effort](https://www.aihero.dev/ai-coding-dictionary/effort).

**`/implement #2` numa sessão nova trabalhou em algo que não tinha nada a ver.**

O agente resolveu o `#2` contra outra lista numerada no contexto, como um arquivo de tarefas ou checklist, e não contra o tracker configurado. A `implement` agora busca no issue tracker a referência passada e diz o título dela antes de começar, e pergunta quando a referência é ambígua. Confira se o título bate com o ticket que você quis dizer; passar a URL da issue ou `dono/repo#2` elimina a ambiguidade de vez.

## Está funcionando se

- A sessão começa lendo o ticket ou a spec e dizendo o que vai construir, em vez de te perguntar o que construir.
- Dá para ver uma chamada real da ferramenta Skill para a `tdd` no rastro, não só testes aparecendo no diff.
- Typechecks e arquivos de teste individuais rodam várias vezes durante a execução, e a suíte completa roda uma vez perto do fim.
- A execução chega a um commit no seu branch atual sem você precisar mandá-la continuar.
- O diff tem o tamanho de um ticket: um vertical slice por todas as camadas, não vários tickets varridos juntos.

## Onde se encaixa

A `implement` é o passo de construção da cadeia principal:

```txt
grill-with-docs → to-spec → to-tickets → implement → code-review → retro
```

As vizinhas dela são a [to-tickets](./to-tickets.md), que produz os tickets que ela consome e declara as arestas de bloqueio que decidem a ordem deles; a [tdd](./tdd.md), que ela conduz internamente em cada seam; e a [code-review](./code-review.md), que ela roda antes do commit. Ela fica depois das skills de planejamento e confia nelas. Ela não revalida a forma do que recebeu, então um mapa mal estruturado ou um ticket fatiado horizontalmente é construído como está escrito.

Essa confiança é o motivo de a [wayfinder](./wayfinder.md) entrar na cadeia pela [to-spec](./to-spec.md) em vez de levar o mapa direto para a `implement`. Vá direto de um mapa para a `implement` só quando o esforço se revelar pequeno.

A [ask-matt](./ask-matt.md) é o roteador de todo o conjunto quando você não tiver certeza de em qual fluxo está.
