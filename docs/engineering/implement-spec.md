## O que faz

A `implement-spec` pega uma [spec](https://www.aihero.dev/ai-coding-dictionary/spec) e os [tickets](https://www.aihero.dev/ai-coding-dictionary/ticket) dela e entrega tudo numa única execução. O [agent](https://www.aihero.dev/ai-coding-dictionary/agent) orquestrador entrega cada ticket a um [subagent](https://www.aihero.dev/ai-coding-dictionary/subagent) implementador trabalhando na própria git worktree, faz o merge de cada branch concluído num único **branch de integração**, roda a [code-review](./code-review.md) sobre o resultado e resolve os tickets.

Ela lê os tickets como um **grafo de tarefas**, não como uma lista. As arestas de bloqueio decidem o que pode começar, então a todo momento existe uma **fronteira** de tickets cujos bloqueadores já entraram, e todo ticket da fronteira roda ao mesmo tempo. Essa é a diferença em relação a trabalhar os tickets um por um. Quem dita o ritmo é a forma do grafo, não a ordem dos tickets no tracker.

## Quando usar

Você invoca esta digitando `/implement-spec`, e o agente não vai recorrer a ela sozinho.

| A sua situação | Use |
| --- | --- |
| Uma spec dividida em tickets com arestas de bloqueio, que você quer entregue numa execução | `/implement-spec` |
| Um ticket por vez, na sua própria [context window](https://www.aihero.dev/ai-coding-dictionary/context-window), fazendo [clearing](https://www.aihero.dev/ai-coding-dictionary/clearing) entre os tickets | [implement](./implement.md) |
| Uma spec ainda não dividida em tickets | [to-tickets](./to-tickets.md) primeiro |
| Um trabalho pequeno, sem um grafo de verdade | [implement](./implement.md) direto |

## Pré-requisitos

- **Um issue tracker.** A skill lê os tickets do tracker configurado pela [setup-matt-pocock-skills](./setup-matt-pocock-skills.md) e os resolve lá. Se nenhum tiver sido configurado, ela para e te manda rodar aquela skill primeiro, em vez de chutar.
- **Tickets com arestas de bloqueio**, do jeito que a [to-tickets](./to-tickets.md) os escreve. Sem arestas, o grafo é plano e todos os tickets começam de uma vez.
- **Um [harness](https://www.aihero.dev/ai-coding-dictionary/harness) que rode subagentes em segundo plano e dê a cada um uma git worktree.** A skill existe para rodar tickets ao mesmo tempo, então, num harness que roda subagentes um por vez, ela é só uma `implement` mais lenta.

## O branch de integração

Tudo vai parar num branch só. Cada implementador:

1. confirma que a worktree dele parte do branch de integração antes de começar,
2. constrói o ticket com a [tdd](./tdd.md), red-green, um slice por vez,
3. faz merge da ponta do branch de integração no próprio branch antes de reportar que terminou, para que a entrada seja um fast-forward.

É o tracker que decide se vai existir um pull request. Se o seu tracker fecha trabalho por meio de PRs, ou se você pedir um, a skill abre um draft PR depois do primeiro merge e o marca como pronto no final. Caso contrário, a execução termina no branch de integração com cada ticket resolvido do jeito que o seu tracker fecha trabalho, o que funciona totalmente offline com um tracker de markdown local.

Os implementadores falam com o orquestrador por meio de [context pointers](https://www.aihero.dev/ai-coding-dictionary/context-pointer) (a spec, o ticket, notas de exploração compartilhadas, commits anteriores) em vez de resumos colados. Isso mantém pequeno o prompt de cada subagente e deixa espaço na janela do orquestrador para o grafo.

## Perguntas frequentes

**Qual a diferença em relação a eu mesmo rodar `/implement` em cada ticket?**

É a pergunta que a skill existe para responder. Antes de ela sair, as pessoas viviam construindo as próprias versões, e um usuário descreveu a necessidade: ele queria "subagentes implementando os tickets" em vez de "ter que criar uma sessão nova para cada um e mandar implementar um ticket por vez, quando uma spec pode ter mais de 5 tickets". Com a `implement`, o despachante é você: uma [session](https://www.aihero.dev/ai-coding-dictionary/session) por ticket, limpando no meio, e você mesmo acompanhando quais tickets estão desbloqueados. A `implement-spec` passa esse trabalho para uma sessão orquestradora. O preço é que você não lê mais o trabalho de cada ticket conforme ele entra; você revisa o branch de integração no final. Para começar uma execução, limpe o contexto e digite `/implement-spec` com um ponteiro para a spec (um número de issue ou um caminho de arquivo). Para uma mudança pequena, sem grafo de verdade, pule esta e use a `implement` direto.

**Ela precisa do GitHub? Quero que pare no branch.**

Não, não mais. Um usuário que gostava da versão em andamento tinha exatamente esta reclamação: "ela cria um PR no final, o que exige um repositório online como o GitHub. Queria que fizesse o mesmo trabalho offline e parasse no branch onde todo o trabalho foi juntado." A execução agora termina no branch de integração. Um PR só abre quando o tracker configurado fecha trabalho por meio de PRs ou quando você pede um, então, num tracker de markdown local, a execução termina com cada ticket resolvido e o trabalho juntado no branch.

**O loop de revisão e correção dela rodou por horas, ou ficou "corrigindo" tickets que ainda nem tinham sido construídos.**

As duas coisas acontecem quando a `code-review` roda em qualquer momento diferente do único ponto que a skill dá a ela. Ela compara o código com a spec inteira, então só faz sentido depois que todos os tickets entraram. Se ela rodar no meio da execução, todo ticket ainda não construído aparece como falha. O agente então constrói esse ticket, e isso dispara outra revisão. No final, a skill roda a `code-review` uma vez e manda todas as descobertas para um único subagente de correção, mas ainda não diz quando parar depois dessa correção. Um usuário relatou uma funcionalidade de cinco tickets em que "o loop de revisão e correção levou umas quatro horas". Se você vir uma segunda revisão ampla começar, mande-a fazer verificações focadas só nas descobertas corrigidas e parar. Espere que essa primeira revisão encontre problemas reais. A saída da execução é um rascunho que a revisão completa, não algo para entregar sozinho.

**Ela conduz a tdd como a implement faz?**

Agora sim, mas no começo não. Os usuários da versão em andamento perceberam que "os subagentes implementadores não herdam a diretiva /tdd", então o red-green parava assim que eles passavam de um ticket para uma spec inteira. Cada implementador agora constrói o ticket com a `tdd`. Ainda não existe um passo em que você combine os seams interativamente, como numa sessão de `implement`, então cite os seams na spec ou nos tickets se quiser fixá-los.

**Dois implementadores rodando em paralelo se chocaram no mesmo arquivo, ou escolheram nomes diferentes para a mesma coisa.**

As worktrees não eliminam colisões; elas as adiam para a hora do merge. Uma aresta de bloqueio escrita a partir do texto do ticket é um palpite sobre quais arquivos cada ticket vai mexer, e dois tickets em "partes diferentes da codebase" ainda compartilham um catálogo de mensagens, um registro de configuração ou um tipo. Cada implementador só vê o próprio ticket e as notas compartilhadas, nunca o trabalho em andamento do outro, então os tickets de web e de mobile de um usuário acrescentaram a mesma string como `blockedSince` e `blockedOn`. Quando dois tickets da fronteira mexem num mesmo arquivo compartilhado, ou acrescente uma aresta de bloqueio entre eles para que rodem um depois do outro, ou faça as notas de exploração fixarem os nomes exatos que cada ticket acrescenta.

**Tickets bloqueados nunca começam, mesmo depois que o bloqueador entrou.**

É um problema conhecido no GitHub. A contagem de "blocked by" do tracker só cai quando um bloqueador é *fechado*, e os tickets normalmente fecham quando o PR é mergeado, que é o fim da execução. O tracker é a fonte certa para o grafo inicial, mas uma fonte desatualizada no meio da execução. Mande o orquestrador acompanhar ele mesmo quais tickets já entraram no branch de integração e calcular a fronteira a partir disso.

**Isto substitui o Sandcastle ou um script AFK?**

Não. As pessoas perguntam porque as skills agora chegam na implementação: "o Sandcastle ainda é relevante? Suas skills agora parecem dar conta da implementação também." A `implement-spec` coloca um agente no comando da orquestração dentro de uma sessão de harness, o que não precisa de infraestrutura e te deixa acompanhar e conduzir. Para trabalho realmente [AFK](https://www.aihero.dev/ai-coding-dictionary/afk), um loop determinístico ([Sandcastle](https://github.com/mattpocock/sandcastle), um script de shell, um job de CI) é mais rápido, mais barato e mais confiável, porque nenhum agente toma as decisões de orquestração.

**O teste principal de um ticket foi pulado dentro da worktree, e ele reportou verde.**

Uma worktree só tem o que o git rastreia. Testes que leem fixtures ignoradas pelo git, bancos locais ou credenciais podem ser pulados em silêncio ali. Para um ticket cuja verificação depende de material não rastreado, mande o orquestrador rodá-lo no checkout principal.

## Está funcionando se

- Vários implementadores rodam ao mesmo tempo sempre que o grafo permite, não um depois do outro.
- Um ticket começa assim que o último bloqueador dele entra no branch de integração, não quando a execução inteira termina.
- O rastro de cada ticket mostra a `tdd` rodando, com um teste falhando antes do código.
- Os merges no branch de integração são fast-forwards, não resoluções de conflito.
- A execução termina num único branch com todos os tickets resolvidos, e um PR só se o seu tracker quiser um.

## Onde se encaixa

A `implement-spec` é o passo de construção da cadeia principal, como alternativa paralela a rodar a [implement](./implement.md) uma vez por ticket:

```txt
grill-with-docs → to-spec → to-tickets → implement-spec → retro
```

As vizinhas dela são a [to-tickets](./to-tickets.md), que declara as arestas de bloqueio que ela lê como grafo de tarefas, e a [code-review](./code-review.md), que ela roda sobre o branch de integração antes de fechar. A [ask-matt](./ask-matt.md) é o roteador de todo o conjunto quando você não tiver certeza de em qual fluxo está.
