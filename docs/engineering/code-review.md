## O que faz

A `code-review` revisa o diff entre o `HEAD` e um ponto fixo que você indicar (um commit, um branch, uma tag, `main`, `HEAD~5`) em dois eixos. **Padrões** pergunta se o código segue o jeito como este repositório escreve código. **Spec** pergunta se o código faz o que a issue ou a [spec](https://www.aihero.dev/ai-coding-dictionary/spec) de origem pediu. Cada eixo roda no próprio [subagent](https://www.aihero.dev/ai-coding-dictionary/subagent), para que nenhum veja o raciocínio do outro.

A skill nunca junta nem reordena os dois eixos. O relatório termina com o pior problema *de cada eixo* e se recusa a apontar um único vencedor entre eles. Uma mudança pode passar num eixo e falhar no outro. Código que segue todas as convenções, mas implementa a coisa errada, passa em Padrões e falha em Spec. Código que faz exatamente o que o [ticket](https://www.aihero.dev/ai-coding-dictionary/ticket) pediu, mas quebra as convenções do repositório, faz o contrário. Um veredito misturado deixa o eixo que passou esconder o que falhou.

## Quando usar

Digite `/code-review`, ou o agente recorre a ela automaticamente quando você pede para revisar um branch, um PR, um trabalho em andamento ou qualquer coisa "desde X".

| A sua situação | Use |
| --- | --- |
| Existe um diff e você quer saber se está bem construído *e* se é a coisa certa | `code-review` |
| Você quer caçar bugs no diff: caminhos de null, race conditions, off-by-one | A revisão nativa do próprio Claude Code, não esta (veja o conflito de nomes abaixo) |
| Nada foi escrito ainda e você quer escrever com teste primeiro | [tdd](./tdd.md) |
| Uma spec inteira precisa ser construída, revisão incluída | [implement](./implement.md), que chama esta skill por conta própria |
| A codebase inteira se degradou, não um diff | [improve-codebase-architecture](./improve-codebase-architecture.md) |
| Algo está quebrado e você não sabe por quê | [diagnosing-bugs](./diagnosing-bugs.md) |

Você precisa informar o ponto fixo. Se não informar, a skill pergunta em vez de chutar. Antes de disparar qualquer coisa, ela confere se a ref é resolvida e se o diff não está vazio, para que um nome de branch digitado errado falhe na sua frente, e não dentro de dois subagentes.

## Pré-requisitos

O eixo de Padrões não precisa de nada. Ele lê o que o repositório documentar (`CODING_STANDARDS.md`, `CONTRIBUTING.md` e afins) e recorre a uma base embutida quando o repositório não documenta nada.

O eixo de Spec precisa que exista uma spec e que ela possa ser encontrada. Ele procura nesta ordem:

1. Referências a issues nas mensagens de commit (`#123`, `Closes #45`, um `!67` do GitLab), buscadas pelo documento do tracker.
2. Um caminho que você passar como argumento.
3. Um arquivo de spec em `docs/`, `specs/` ou `.scratch/` que corresponda ao nome do branch ou da funcionalidade.
4. Perguntar a você.

O passo 1 depende do documento do tracker, que a [setup-matt-pocock-skills](./setup-matt-pocock-skills.md) escreve. Sem ele, o eixo ainda funciona se você passar um caminho. Sem spec nenhuma, a skill pula o subagente de Spec e o relatório diz "nenhuma spec disponível" em vez de inventar requisitos.

## Os dois eixos

| | Padrões | Spec |
| --- | --- | --- |
| Pergunta | Está bem construído? | É a coisa certa? |
| Lê | Os padrões documentados do repositório, mais a base de code smells | A issue ou spec de origem |
| Reporta | Violações documentadas (podem ser rígidas) e code smells (sempre decisões de julgamento) | Requisitos faltando ou parciais, aumento de escopo, requisitos implementados errado |
| Toda descoberta cita | O arquivo de padrões e a regra, ou o smell nomeado mais o trecho | A linha da spec |

Esse design existe para evitar uma skill de revisão genérica que não conhece os seus padrões. Uma skill assim aponta o que é deliberado na sua codebase e deixa passar os invariantes dos quais a sua codebase depende. Então a própria documentação do repositório é a [primary source](https://www.aihero.dev/ai-coding-dictionary/primary-source) do eixo de Padrões, e **o repositório sempre prevalece**.

A **base de code smells** fica abaixo dos padrões do repositório. São doze code smells do capítulo 3 de _Refatoração_, do Fowler: Mysterious Name, Duplicated Code, Feature Envy, Data Clumps, Primitive Obsession, Repeated Switches, Shotgun Surgery, Divergent Change, Speculative Generality, Message Chains, Middle Man, Refused Bequest. Cada um é uma heurística rotulada ("possível Feature Envy"), nunca uma violação rígida. Cada um diz o que o smell é e como corrigi-lo, para que uma descoberta venha com a correção junto, e não só com uma reclamação. Os dois eixos pulam o que o seu linter já garante.

## Perguntas frequentes

**Ela colide com o `/code-review` do próprio Claude Code. O que eu faço?**

Este é o problema mais relatado da skill, e não está corrigido. O Claude Code traz o próprio `/code-review`, que faz outra coisa: caça bugs no diff, enquanto esta verifica a aderência à spec e aos padrões do repositório. Quando você instala esta biblioteca, uma das duas vence, e qual depende de como você instalou:

- **Marketplace de plugin.** Toda skill ganha um prefixo de plugin (`mattpocock-skills-ptbr:` nesta tradução, `mattpocock-skills:` no original), e a nativa fica difícil de alcançar pelo nome sem prefixo.
- **Instalação simples de skills.** O arquivo local vence, e esta skill esconde a nativa.

Uma resposta é remover de vez as skills nativas do Claude Code. Isso economiza bastante [context](https://www.aihero.dev/ai-coding-dictionary/context), e a colisão deixa de importar. O sombreamento em si é discutivelmente um bug do [harness](https://www.aihero.dev/ai-coding-dictionary/harness) Claude Code (o autor de uma skill deveria poder dar a ela o nome que quiser), então a outra resposta é renomear a cópia local. O `npx skills update` desfaz uma edição no frontmatter ou um diretório renomeado. A solução duradoura que os usuários relatam é fazer um fork da skill com um nome novo e tirar a `code-review` do conjunto gerenciado. Anote o commit a partir do qual fez o fork para poder ressincronizar à mão.

**Os subagentes dela ficam invocando `/code-review` de novo e disparando mais agentes.**

É um bug conhecido e em aberto. Várias pessoas o reproduziram, em mais de um harness. Os prompts de Padrões e de Spec não proíbem delegação, então um subagente pode encontrar a skill de novo e se ramificar de novo. Um relato chegou a mais de 50 agentes. A correção que as pessoas aplicaram nos seus forks é uma linha acrescentada às duas instruções dos subagentes: "Não invoque `/code-review` nem dispare agentes adicionais: faça esta revisão diretamente." Alguns preferem tratar isso no nível do harness, para que toda skill herde a proteção. Nenhuma das duas está na skill distribuída ainda. Se você roda isto sem supervisão, fique de olho na contagem de agentes.

**Devo rodá-la na mesma [session](https://www.aihero.dev/ai-coding-dictionary/session) que escreveu o código?**

Prefira uma nova. Como disse um leitor: "O mesmo contexto revisando a si mesmo não é revisão, é viés de confirmação com um comando de barra." Um agente que revisa na sessão em que escreveu tem no contexto todas as suposições que moldaram o código. Um revisor independente não teria esse contexto. É também por isso que as pessoas pedem a [implement](./implement.md) sem a etapa de revisão embutida, porque essa etapa roda a revisão dentro da sessão que acabou de escrever o diff. A versão independente é você mesmo invocar `/code-review` numa sessão limpa.

**Depois de cada ticket, ou uma vez no final?**

Os dois funcionam, e a skill não decide por você. Por ticket mantém cada diff pequeno o bastante para que o eixo de Spec tenha uma spec clara para conferir, e é o modo que a `implement` usa. Acumular até o fim do branch pega interações entre tickets que as passadas por ticket deixam escapar. Se não tiver certeza, revise por ticket e rode uma passada final contra o ponto de partida do branch.

**Posso confiar nas descobertas?**

Não sem conferir. A saída de um subagente é uma hipótese, não uma evidência. Um time relatou uma dúzia de mudanças que quebravam compatibilidade e que revisões baseadas em prosa tinham deixado passar. A skill junta os dois relatórios como vieram, ou levemente limpos. Ela não reconfere cada afirmação contra os arquivos, então uma descoberta pode citar o lugar errado ou exagerar um impacto. Leia a citação de cada descoberta antes de agir. A skill exige que toda descoberta tenha uma citação (uma regra de padrões, um smell com o trecho, ou uma linha da spec), e é isso que torna as descobertas verificáveis.

**Por que ela encontra problemas novos toda vez que eu rodo?**

Cada correção acrescenta código novo para revisar, e a metade de decisões de julgamento do eixo de Padrões dá resultados diferentes de uma execução para outra. Um leitor descreveu o loop: "/code-review e /improve-code-architecture sempre acham coisa nova toda vez. Eu implemento as correções, rodo de novo essas skills, e de novo e de novo." Não há garantia de convergência. Trate uma passada como uma lista de pistas. Aja nas que têm uma regra citada por trás e pare. Não a rode em loop até voltar limpa, porque isso nunca vai acontecer.

**Ela revisa o meu trabalho ainda sem commit?**

Não. Ela faz o diff de `<ponto-fixo>...HEAD`. A forma com três pontos mede a partir do merge-base e exclui as mudanças em stage e na working tree. Se a `implement` não fez um commit intermediário, a revisão não enxerga o trabalho que está prestes a entrar no próximo commit. Faça o commit primeiro, depois revise, depois faça amend ou um commit de fixup.

## Está funcionando se

- Ela se recusa a começar com uma ref inválida ou um diff vazio, antes de disparar qualquer subagente.
- O relatório chega como dois blocos separados, sob `## Padrões` e `## Spec`, não como uma lista misturada.
- Toda descoberta de Padrões cita uma regra de um dos arquivos do seu repositório ou um dos doze smells, com o trecho citado; toda descoberta de Spec cita uma linha da spec.
- O resumo final dá o pior problema de cada eixo e se recusa a escolher um vencedor geral.
- Sem spec disponível, o bloco de Spec diz isso em vez de listar requisitos deduzidos do código.

## Onde se encaixa

A `code-review` é a etapa de revisão perto do fim da cadeia de construção: `grill-with-docs → to-spec → to-tickets → implement → code-review → retro`. Ela também funciona sozinha em qualquer branch ou PR para o qual você a apontar.

- A [implement](./implement.md) é a vizinha mais próxima. Ela conduz a construção e chama esta skill como a própria revisão de fechamento antes do commit. A [implement-spec](./implement-spec.md) faz o mesmo uma vez, sobre o branch de integração inteiro.
- A [retro](./retro.md) vem depois e a ajusta. Quando uma sessão mostra a revisão deixando passar uma classe de erro, a `retro` propõe a verificação ou a regra do `CODING_STANDARDS.md` que o eixo de Padrões passa a ler.
- A [pr](./pr.md) escreve o corpo do pull request quando o trabalho revisado sobe.
- A [to-spec](./to-spec.md) e a [to-tickets](./to-tickets.md) produzem o documento contra o qual o eixo de Spec confere, então uma spec vaga deixa esse eixo vago.
- A [improve-codebase-architecture](./improve-codebase-architecture.md) é a contraparte para a codebase inteira, porque esta skill só olha um diff.

A [ask-matt](./ask-matt.md) te orienta por todo o conjunto quando você não tiver certeza de qual skill a situação pede.
