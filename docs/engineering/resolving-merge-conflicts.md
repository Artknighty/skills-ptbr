> **Arquivada.** Esta skill foi removida do plugin na v1.3.0 e não é mais mantida. Nada a substitui: o agente resolve um conflito de merge ou rebase sem uma skill dedicada. A página continua no ar como referência.

## O que faz

A `resolving-merge-conflicts` trabalha um merge ou rebase do git em andamento, trecho por trecho, depois roda as verificações do próprio projeto e conclui a operação com um commit.

Ela se recusa a tratar um conflito como problema de texto. Antes de mexer num trecho, ela rastreia cada lado até a **[primary source](https://www.aihero.dev/ai-coding-dictionary/primary-source)** dele (a mensagem de commit, o PR, a issue original), para escolher entre duas intenções e não entre dois blocos de texto, e preserva as duas sempre que forem compatíveis. Quando não forem, ela escolhe o lado que corresponde ao objetivo declarado do merge e diz qual foi o trade-off. Ela não inventa comportamento novo para esconder um choque, e nunca usa `--abort`. Ela sempre leva o merge até um commit concluído.

## Quando usar

Digite `/resolving-merge-conflicts`, ou o [agent](https://www.aihero.dev/ai-coding-dictionary/agent) recorre a ela automaticamente quando uma tarefa se encaixa.

Use quando o git já parou em conflitos que não conseguiu resolver sozinho. Ela se limita ao conflito à sua frente, não ao que está de um lado ou de outro dele:

| A sua situação | Skill |
| --- | --- |
| No meio de um merge ou rebase, com marcadores de conflito na árvore | Esta |
| O merge terminou, e agora algo se comporta mal por motivos que você não enxerga | [diagnosing-bugs](./diagnosing-bugs.md) |
| Planejando como fatiar o trabalho para que os branches colidam menos | Nenhuma: veja a pergunta sobre trabalho paralelo abaixo |

## Fontes primárias acima de `ours` e `theirs`

A skill existe para impedir a resolução por flag: `--ours`, `--theirs`, ou apagar à mão o bloco que parece menos importante, para que os marcadores sumam e o build compile. Essa resolução pode ser sintaticamente perfeita e ainda assim jogar fora em silêncio uma mudança que alguém fez de propósito.

Você não consegue preservar uma intenção que não leu. Então o trabalho começa no histórico (commits, PRs, [tickets](https://www.aihero.dev/ai-coding-dictionary/ticket)) e só depois vai para o diff. O passo de verificação existe pelo mesmo motivo. A skill encontra as [automated checks](https://www.aihero.dev/ai-coding-dictionary/automated-check) do próprio repositório e as roda antes do commit, porque um merge é o lugar mais fácil do git para produzir código que satisfaz os dois branches e não passa nos testes de nenhum.

## Perguntas frequentes

**O Claude Code já resolve conflitos muito bem sozinho. Por que isso precisa de uma skill?**

O valor acrescentado são os passos de "encontrar as fontes primárias" e "rodar os feedback loops", que de outro jeito você precisa pedir à mão toda vez. Um agente sem instrução normalmente produz uma resolução plausível só a partir do diff e para por aí. O valor da skill são os dois passos que ela não deixa o agente pular: ler por que cada lado existe e rodar as verificações depois. É um ganho pequeno sobre um bom [model](https://www.aihero.dev/ai-coding-dictionary/model), e isso é intencional. Pelo menos um leitor previu que esta é uma skill inteira que vira no-op conforme os modelos melhoram.

**Devo manter agentes paralelos longe dos mesmos arquivos para evitar conflitos desde o início?**

Na maioria das vezes, não. Separar arquivos por zona entre tarefas paralelas custa mais do que economiza, porque os agentes são bons o bastante em conflitos de merge para que a troca não seja tão dura quanto parece. A única disciplina que vale manter é fazer as refatorações grandes primeiro. Uma renomeação grande entrando depois que dez branches já saíram dela é o caso que continua caro.

Uma ressalva de um relato de usuário sobre worktrees paralelas: quando [sessions](https://www.aihero.dev/ai-coding-dictionary/session) irmãs constroem cada uma um ticket na própria árvore, o merge de volta fica melhor nas mãos da sessão que escreveu a mudança, porque é ela que já conhece a intenção. Se um agente resolve os conflitos de todo mundo no final, ele perde o [context](https://www.aihero.dev/ai-coding-dictionary/context) que o passo 2 desta skill precisa então reconstruir.

**Por que nunca `--abort`?**

Abortar joga fora o trabalho de resolução e te devolve ao mesmo conflito, intacto, na próxima tentativa. A skill foi escrita para o caso em que o merge vai acontecer. Se você decidiu que ele não deve acontecer, essa é uma decisão a tomar antes de invocá-la, não um desvio dentro do loop.

## Está funcionando se

- O agente te cita mensagens de commit, PRs ou issues enquanto resolve, não só trechos do diff.
- Todo trecho termina com o comportamento dos dois lados, ou com uma nota explícita dizendo o que foi descartado e por quê.
- Nada aparece no resultado que não estava em nenhum dos branches.
- O agente encontrou o typecheck, os testes e a formatação e os rodou verdes *antes* do commit, não depois de você perceber algo quebrado.
- Você termina com a árvore limpa e a operação concluída, incluindo todos os commits restantes num rebase de vários commits.

## Onde se encaixa

Uma avulsa para usar a qualquer hora, sem dependência de nenhuma outra skill: ela começa quando o git trava e termina quando a árvore está limpa e com commit. A única vizinha de verdade é a [diagnosing-bugs](./diagnosing-bugs.md), que assume no ponto em que um merge foi resolvido de forma limpa mas o código resultante se comporta mal: um problema de diagnóstico, não de conflito. Ela fica fora do fluxo principal da ideia à entrega, então a [ask-matt](./ask-matt.md) é o mapa do que roda antes e depois dela.
