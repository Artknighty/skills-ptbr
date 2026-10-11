## O que faz

A `retro` revisa uma [session](https://www.aihero.dev/ai-coding-dictionary/session) de código e sugere melhorias no **[environment](https://www.aihero.dev/ai-coding-dictionary/environment)** (ambiente) do agente, para que a próxima execução seja melhor. Ela lê o próprio registro da sessão (a atual por padrão, ou uma que você indicar nos logs de sessão). Ela encontra os momentos em que o agente sofreu e te dá uma lista de correções candidatas, das mais graves para as menos graves.

Ela muda o ambiente, não o código. Pegue o bug que o agente entregou, o arquivo que ele precisou de vinte [tool calls](https://www.aihero.dev/ai-coding-dictionary/tool-call) para encontrar, ou a regra que o revisor deixou passar. A `retro` não corrige nenhum deles diretamente. Ela pergunta o que no repositório deixou aquilo acontecer e propõe a verificação, o ponteiro ou o padrão que impede isso da próxima vez. E ela só propõe. Nada muda até você escolher um candidato.

## Quando usar

Você invoca esta digitando `/retro`, e o agente não vai recorrer a ela sozinho.

Use no fim de uma sessão que foi mais difícil do que deveria. Por exemplo, o agente procurou algo por tempo demais, cometeu um erro que uma ferramenta poderia ter pegado ou precisou de uma informação que não conseguiu obter. Uma sessão tranquila tem pouco a ensinar, e as descobertas vêm das difíceis. Se o que você quer é um veredito sobre o código que a sessão produziu, use a [code-review](./code-review.md).

## Onde as descobertas vão parar

Cada candidato pertence a uma categoria, e a categoria decide para onde vai a correção:

| O que deu errado na sessão | Corrija com |
| --- | --- |
| O agente demorou para encontrar um arquivo ou um fato | Um **ponteiro de navegação** a partir de um arquivo que ele já lê |
| Ele cometeu um erro que uma ferramenta poderia ter pegado | Uma **[automated check](https://www.aihero.dev/ai-coding-dictionary/automated-check)** (verificação automatizada): regra de lint, tipo, teste, hook de pre-commit, job de CI |
| O revisor deixou passar um erro de julgamento | Uma regra no `CODING_STANDARDS.md` para o agente revisor |
| O `AGENTS.md` ou o `CLAUDE.md` está grande | Tire a orientação dele e leve para os padrões ou para verificações |
| Uma chamada de ferramenta foi cara para o que devolveu | Enxugue a ferramenta, ou substitua-a |
| Um arquivo de orientação está cheio de linhas que não mudam nada | Apague os **no-ops** |
| O agente precisou de uma informação que não conseguia alcançar | Amplie o acesso dele: espelhe o log do servidor de desenvolvimento num arquivo, dê acesso somente leitura a um serviço |

A ideia central é que os padrões pertencem ao **revisor**, não a quem implementa. O agente que implementa sofre a maior pressão de contexto, porque explora, escreve código e depura falhas. O agente que revisa recebe um diff e mais nada. Então uma regra nova vai para onde há espaço para aplicá-la, que é a revisão. Ela nunca vai para o [AGENTS.md](https://www.aihero.dev/ai-coding-dictionary/agents-md), que é carregado na [context window](https://www.aihero.dev/ai-coding-dictionary/context-window) de toda sessão, seja relevante ou não.

Antes de escrever qualquer regra, a `retro` classifica a violação. Uma violação **mecânica** (uma API proibida, um formato de import, uma regra de localização de arquivo) ganha uma verificação determinística, porque uma verificação pode falhar e uma frase num arquivo de padrões não pode. Só as decisões de julgamento de verdade, que nenhum linter consegue impor, viram prosa. Se o repositório não tem guardrail nenhum (nenhum hook de pre-commit e nenhum job de CI rodando lint, typecheck e testes), a `retro` reporta isso como uma descoberta própria.

## Perguntas frequentes

**Ela escreve a regra de lint sozinha, ou espera um sim? Dá para ligá-la para rodar depois de toda sessão?**

Ela espera. A `retro` só propõe. Nada muda até você escolher um candidato, então ela não edita nada por conta própria nem instala hook automaticamente. Isso é proposital. Um usuário pediu exatamente isso depois de ter "se queimado com hooks automáticos que bloqueavam mudanças boas". Decidir o que merece uma verificação permanente exige julgamento, então a skill continua com [human in the loop](https://www.aihero.dev/ai-coding-dictionary/human-in-the-loop) e invocada pelo usuário. Alguns usuários a rodam depois de toda execução de implementação. Mas uma sessão tranquila tem pouco a ensinar, então rodar depois de toda sessão produz principalmente regras de que ninguém precisava. Não há modo de simulação. Uma verificação proposta é código como qualquer outro, então teste-a no repositório antes de deixá-la bloquear merges.

**Isso não vai acumular regras de lint para sempre? Ela alguma vez sugere remover uma?**

Em parte, e este é o ponto mais fraco dela. Ela consegue remover prosa: no-ops em arquivos de orientação, e orientações no `AGENTS.md` ou no `CLAUDE.md` que pertencem aos padrões ou a uma verificação. Ela as marca para exclusão quando os arquivos estão grandes. Ela as julga contra a única sessão que lê, então trate cada uma como candidata ao teste da exclusão, não como veredito. Ela não audita as regras de lint, os hooks ou os jobs de CI que propôs no mês passado. Ela enxerga uma sessão, então não consegue te dizer que uma regra agora dispara demais ou que o bug por trás dela já não existe. A poda das verificações continua sendo com você. Uma regra que dispara o tempo todo em código bom é o sinal para removê-la.

**Ela não vai só inventar conselhos genéricos para preencher as categorias?**

Esta é a crítica mais forte a ela. Um usuário descobriu que, "quando o trabalho termina, a IA tende a esquecer as dificuldades do meio da sessão e inventa conselhos genéricos para satisfazer as categorias da retro". Todo candidato precisa vir do próprio registro da sessão, então o conselho é específico daquela sessão. Isso tem um custo além do benefício. Ela raramente inventa algo irrelevante, mas pode dar peso demais ao assunto daquela única sessão. Descarte qualquer candidato que você não consiga ligar a um momento específico. Trate também a ordem de gravidade como um primeiro rascunho, porque um erro silencioso e caro pode ficar abaixo de um barulhento e barato.

**Minha sessão está longa. Rodo agora ou começo do zero?**

Por padrão, ela revisa a sessão atual. Esse é o melhor caso, porque as dificuldades ainda estão na context window. Se a sessão já saiu da [smart zone](https://www.aihero.dev/ai-coding-dictionary/smart-zone), faça [clearing](https://www.aihero.dev/ai-coding-dictionary/clearing) dela e aponte uma `/retro` nova para a sessão anterior nos logs de sessão.

**O agente vive cometendo o mesmo erro. Devo acrescentar uma linha no `CLAUDE.md`?**

Normalmente não, e é aqui que a `retro` mais questiona. Uma linha no `CLAUDE.md` é carregada em toda sessão, diminui o peso de todo o resto do arquivo e fica desatualizada conforme o código muda. Se o erro é mecânico, a correção é uma verificação que falha. Se é uma decisão de julgamento, vai para os padrões de código que o revisor lê. O `AGENTS.md` e o `CLAUDE.md` são para ponteiros de navegação e pouco mais. Pelo mesmo motivo, a `retro` não é um [memory system](https://www.aihero.dev/ai-coding-dictionary/memory-system). Ela não guarda o que aconteceu. Ela muda o ambiente para que o erro não possa acontecer de novo.

**Minha configuração menciona `CODING_STANDARDS.md` e eu não tenho um. De onde ele vem?**

Nenhuma skill traz o arquivo. Na primeira vez que uma sessão encontra uma regra de julgamento para o revisor, a `retro` propõe criá-lo. Depois que você aceita, a [code-review](./code-review.md) passa a lê-lo. Qualquer outro documento de padrões que você já mantenha, como o `CONTRIBUTING.md`, funciona do mesmo jeito.

**Qual a diferença em relação à `improve-codebase-architecture`?**

A entrada é diferente. A [improve-codebase-architecture](./improve-codebase-architecture.md) só precisa do código, e procura melhorias estruturais nele. A `retro` precisa de um histórico de sessão, e melhora o ambiente em que o agente trabalha, não o código. Você usa as duas; uma não substitui a outra.

## Está funcionando se

- Todo candidato aponta para um momento específico da sessão, não para uma boa prática genérica.
- Erros repetidos viram verificações que falham, e o seu `AGENTS.md` fica mais curto com o tempo, não mais longo.
- Se uma verificação já existia mas não estava ligada, a descoberta é ligá-la, não uma proposta de construir uma nova.
- A próxima sessão no mesmo tipo de tarefa encontra o que precisa mais rápido.

## Onde se encaixa

A `retro` é o último passo da cadeia principal, onde você revisa como a cadeia foi:

```txt
grill-with-docs → to-spec → to-tickets → implement → code-review → retro
```

Rode-a depois de uma construção da qual valha aprender algo, na mesma sessão ou apontada para o log dessa sessão. Dá para pular depois de uma construção tranquila.

- A [code-review](./code-review.md) é o agente revisor que a `retro` mais ajusta. Os novos padrões de código vão para onde o eixo de Padrões dela os lê.
- A [writing-for-agents](../productivity/writing-for-agents.md) define o estilo de escrita de todo arquivo de orientação e skill que a `retro` propõe, e a `retro` a carrega antes de começar.

A [ask-matt](./ask-matt.md) te orienta por todo o conjunto quando você não tiver certeza de qual skill a situação pede.
