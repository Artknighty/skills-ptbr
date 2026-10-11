## O que faz

A `improve-codebase-architecture` levanta **oportunidades de aprofundamento** numa codebase. São lugares em que um módulo raso (uma interface quase tão complexa quanto aquilo que ela esconde) poderia virar um profundo. Ela as escreve num relatório HTML autocontido e depois te faz uma [grilling](https://www.aihero.dev/ai-coding-dictionary/grilling) sobre a que você escolher.

Ela nunca muda o código. A execução inteira produz uma conversa e um arquivo HTML no diretório temporário do sistema operacional. Você faz a refatoração depois, numa [session](https://www.aihero.dev/ai-coding-dictionary/session) separada, pelo fluxo normal de construção. Isso faz dela um levantamento, não uma ferramenta de refatoração, então dá para rodá-la numa codebase em que você ainda não está pronto para mexer.

Dois filtros impedem o relatório de virar conselho genérico de limpeza. Primeiro, todo candidato precisa passar no **teste da exclusão**: se você removesse este módulo, a complexidade dele iria para trás de uma interface menor, ou se espalharia pelos chamadores? Só o primeiro caso ganha um card. Segundo, a menos que você a aponte para uma área específica, ela lê primeiro o histórico recente de commits e concentra a varredura nos caminhos que mudam com frequência. Aprofundar um código que ninguém mexe é uma refatoração que nunca se paga.

## Quando usar

Você invoca esta digitando `/improve-codebase-architecture`; o [agent](https://www.aihero.dev/ai-coding-dictionary/agent) não vai recorrer a ela sozinho.

Ela não é um passo do loop principal de construção. Você a roda periodicamente para enfileirar mais trabalho que melhora a codebase. As pessoas a usam em quatro situações:

| Situação | Como é usada |
| --- | --- |
| Manutenção de rotina | Rode a cada poucos dias, ou quando tiver um tempo livre, para que a estrutura não se degrade entre uma funcionalidade e outra. |
| Antes de uma construção grande | Aponte-a para a [spec](https://www.aihero.dev/ai-coding-dictionary/spec) e pergunte "como podemos tornar esta mudança fácil?". É o prompt mais eficaz para ela. |
| Auditoria de código legado | Rode num repositório grande, sem estrutura ou feito no [vibe coding](https://www.aihero.dev/ai-coding-dictionary/vibe-coding) para descobrir em que estado ele está. |
| Testes em código legado | Use para encontrar os seams que faltam antes de escrever testes contra código intestável. |

Onde ela pode ser confundida com as irmãs:

- Para projetar um módulo que você já escolheu, use a [codebase-design](./codebase-design.md). Esta skill encontra o módulo a trabalhar, e a `codebase-design` é onde você o projeta.
- Para um esforço inteiro grande demais para caber numa sessão, use a [wayfinder](./wayfinder.md).
- Para "esta coisa específica está quebrada", use a [diagnosing-bugs](./diagnosing-bugs.md). Ela te manda de volta para cá quando a descoberta real é que não existe um bom seam para travar o bug.

## Pré-requisitos

Nenhum para rodar. Se existirem um `GLOSSARY.md` ou ADRs em `docs/adr/`, ela os lê e usa os substantivos do seu próprio domínio. Um candidato então se lê como "aprofundar o módulo de entrada de Pedidos", e não "refatorar o FooBarHandler".

Ela escreve em dois lugares. O relatório vai para `<tmpdir>/architecture-review-<timestamp>.html`, fora do repositório. Durante o loop de sabatina, ela acrescenta ou afia termos no `GLOSSARY.md`, criando o arquivo se ele não existir. Ela também se oferece para registrar um candidato rejeitado como ADR, para que uma execução futura não o sugira de novo.

## Profundidade, e o relatório que a caça

A skill se apoia numa ideia: **profundidade**. Um módulo profundo coloca muito comportamento atrás de uma interface pequena e estável. Um módulo raso expõe a implementação por uma interface quase tão larga quanto o código por baixo dela. O relatório procura três formas de superficialidade:

- Funções puras extraídas só por testabilidade, enquanto os bugs reais estão em como os chamadores as usam (sem **localidade**).
- Módulos que vazam através dos próprios **seams**.
- Um conceito que você não consegue entender sem abrir cinco arquivos.

Para cada uma, ele propõe o aprofundamento que a corrige.

Cada candidato é um card com os arquivos envolvidos, o atrito, uma solução em linguagem simples, o benefício em termos de **localidade** e **alavancagem**, um diagrama de antes/depois e um selo de força.

| Selo | O que significa para você |
| --- | --- |
| `Forte` | O teste da exclusão passa com clareza e o atrito é real. Leve a sério. |
| `Vale explorar` | Aprofundamento plausível, mas o retorno depende de para onde o código vai em seguida. |
| `Especulativa` | Incluído para completar. Você pode ignorar a maioria destes. |

O relatório termina com uma **Recomendação principal**, o candidato que ela faria primeiro. Depois a skill para e pergunta qual candidato você quer explorar. Nesse ponto você não decidiu nada, e nenhum código mudou.

## O que acontece depois que você escolhe um

Quando você escolhe um candidato, começa uma sessão de [grilling](../productivity/grilling.md) sobre ele. Ela cobre as restrições, o que vai atrás do seam, quais testes sobrevivem e como a interface aprofundada deveria ficar. A saída dessa sessão é uma decisão, não um diff. Daí em diante vale o fluxo normal: leve a decisão para a [to-spec](./to-spec.md), depois para a [to-tickets](./to-tickets.md), depois para a [implement](./implement.md).

## Perguntas frequentes

**Ela me sabatinou por uma hora sobre uma ideia em vez de me mostrar opções. Dá para desligar isso?**

Dá. Diga isso ao invocá-la ("não me sabatine, só mostre o relatório"). Esta é a reclamação mais comum sobre a skill. Um usuário gostava dela como "um jeito prático de ter uma análise completa de melhorias", mas, depois que o loop de sabatina foi acrescentado, achou-a "quase inutilizável". Nas sessões dele, ela propunha uma única solução e depois fazia "dezenas ou centenas de perguntas". A intenção do design é que o relatório venha primeiro e a sabatina só comece num candidato que você escolheu. Mas [models](https://www.aihero.dev/ai-coding-dictionary/model) mais fracos pulam direto para uma entrevista sobre a primeira ideia que tiveram. Os resultados naquela thread variam muito de modelo para modelo. É uma issue aberta, e a skill ainda não tem um modo sem sabatina documentado.

**O relatório abriu como HTML cru, sem estilo e sem diagramas. O que aconteceu?**

O relatório carrega o Tailwind e o Mermaid de CDNs, então precisa de acesso à rede quando você o abre. Se algo bloquear esses scripts, a página quebra sem erro nenhum. No caso relatado, um hook de segurança exigia hashes SRI. O agente os acrescentou, mas a CDN entregou ao navegador bytes diferentes dos que entregou ao `curl` que calculou o hash, então o navegador bloqueou o script. Ambientes offline e bloqueados têm o mesmo problema. O agente não consegue ver isso, porque nunca renderiza a página. Como solução, peça CSS inline e diagramas em SVG feitos à mão em vez do esquema com CDN. É uma issue aberta.

**Ela me deu doze candidatos. Trabalho todos na mesma sessão ou começo uma nova?**

Use um candidato por sessão. Se você trabalhar vários numa conversa, a [context window](https://www.aihero.dev/ai-coding-dictionary/context-window) se enche com o relatório, a sabatina, as edições do modelo de domínio e as mudanças de código, tudo ao mesmo tempo. O relatório é só um arquivo temporário, então leve adiante o candidato, não o arquivo. Escolha um, sabatine, e leve a decisão para a `/to-spec`. Transforme o resto em [tickets](https://www.aihero.dev/ai-coding-dictionary/ticket) que você pode pegar separadamente depois. Coloque a melhoria escolhida numa spec em vez de ir direto para a implementação. As pessoas perguntam isso com frequência, e a própria skill não documenta um fluxo para isso.

**Como devo fazer o prompt?**

Com a próxima coisa que você vai construir. Se uma construção grande estiver chegando, aponte-a para a spec e pergunte "como podemos tornar esta mudança fácil?". Uma execução sem prompt procura pontos quentes sozinha. Isso serve para a manutenção de rotina, mas uma direção torna o relatório acionável.

**Ela funciona numa codebase legada grande?**

Em parte. Ela funciona bem em codebases grandes existentes que não têm uma estrutura consistente, e é a ferramenta de manutenção recomendada depois de qualquer organização estrutural pontual. Mas usuários com projetos fora de controle relatam que ela "ajudou um pouco, mas ainda não dá conta". Um desenvolvedor com uma codebase legada de oito anos relatou que o modelo ficou andando em círculos, embora a mesma skill produza um grafo limpo num repositório arrumado. Ainda não existe uma skill `/refactor` dedicada a esse caso. Se a codebase não tiver um vocabulário compartilhado, rode a [grill-with-docs](./grill-with-docs.md) primeiro para criar um. Isso costuma melhorar muito a saída desta skill.

**Qual a diferença em relação à `/codebase-design`?**

A `/codebase-design` é uma referência, não uma condutora de sessão. Ela fornece o vocabulário (módulo, interface, profundidade, seam, adapter, alavancagem, localidade), e esta skill o usa. Se você der a um agente novo a `/codebase-design` como tarefa, ele falha de um jeito conhecido. Ela não tem um processo próprio a seguir, então o agente inventa um, explora o código de novo e roda por muito tempo antes de te perguntar qualquer coisa. Rode esta skill, e deixe que ela use aquela.

**Ela algum dia vai me dizer que a codebase está boa?**

Raramente, então saiba disso antes de começar. A skill existe para produzir descobertas, então tende a produzir candidatos em vez de concluir que não há nada errado. Use os selos de força para compensar isso. Se todos os candidatos de um relatório forem `Especulativa`, a skill não encontrou nada.

**Ela funciona no Codex ou em outro harness?**

Em parte. O passo de exploração cita diretamente a ferramenta `Agent` do Claude Code com `subagent_type=Explore`. Um [harness](https://www.aihero.dev/ai-coding-dictionary/harness) sem essa ferramenta pode pular a exploração paralela em vez de usar o equivalente dele. A skill ainda roda, mas a varredura fica menos completa. Alguém propôs uma reescrita neutra em relação ao harness, mas ela não foi incorporada.

**Como eu implemento módulos profundos em TypeScript na prática?**

A skill não traz uma boa resposta. As pessoas pedem com frequência um `TYPESCRIPT.md` com layouts concretos de arquivos e módulos para os princípios, e ele não existe. A skill te diz onde um aprofundamento cabe e o que vai atrás do seam. Transformar isso numa estrutura de pacotes ou diretórios é com você.

## Está funcionando se

- Os candidatos citam os conceitos do seu domínio, não nomes de classe inventados: "o módulo de entrada de Pedidos", não "o FooBarHandler".
- Os candidatos estão em arquivos que você editou recentemente, não em partes do repositório que ninguém mexe.
- Nenhum código mudou durante a execução. O único arquivo novo é o relatório HTML no seu diretório temporário.
- Ela para depois do relatório e pergunta qual candidato você quer. Ela não continua sozinha.
- Cada card explica o retorno como localidade ou alavancagem e diz quais testes ficam mais simples, não só "isto fica mais limpo".
- Quando você rejeita um candidato por um motivo duradouro, ela se oferece para registrar um ADR, para que a próxima execução não o sugira de novo.

## Onde se encaixa

A `improve-codebase-architecture` é **manutenção periódica**. Você a roda a cada poucos dias, fora de qualquer cadeia, para enfileirar trabalho, não para fazê-lo. As vizinhas dela:

- A [codebase-design](./codebase-design.md) é dona do vocabulário de profundidade e seam que todo candidato usa.
- A [grilling](../productivity/grilling.md) percorre a árvore de decisões depois que você escolhe um candidato.
- A [domain-modeling](./domain-modeling.md) mantém o `GLOSSARY.md` e os ADRs atualizados enquanto você toma a decisão.

A saída dela é uma ideia, que volta para o fluxo principal de construção pela [grill-with-docs](./grill-with-docs.md) ou pela [to-spec](./to-spec.md). A contraparte dela no fim do fluxo principal é a [retro](./retro.md). Esta skill melhora o código em que o agente trabalha, e a `retro` melhora o ambiente ao redor dele (verificações, padrões, arquivos de orientação) depois de uma construção. Para saber qual skill serve numa situação, a [ask-matt](./ask-matt.md) é o roteador de todo o conjunto.
