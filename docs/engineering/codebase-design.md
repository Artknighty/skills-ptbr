## O que faz

A `codebase-design` fixa as palavras que você usa para projetar um módulo: **módulo**, **interface**, **profundidade**, **seam**, **adapter**, **alavancagem**, **localidade**. Ela define cada uma com precisão, proíbe os substitutos frouxos ("componente", "serviço", "API", "fronteira") e declara o punhado de princípios que decorrem delas.

Ela é uma referência, não um processo. Ela não roda loop nenhum, não produz artefato nenhum e nunca para para te fazer uma pergunta. Toda outra skill que mexe com design usa o vocabulário dela. Sozinha, ela te dá as palavras e para. Saiba disso antes de invocá-la. Se você apontar uma [session](https://www.aihero.dev/ai-coding-dictionary/session) para uma skill sem processo e sem regra de parada e disser "vai", o agente inventa um processo. As perguntas abaixo mostram como isso fica.

## Quando usar

Digite `/codebase-design`, ou o agente recorre a ela automaticamente quando uma tarefa de design se encaixa.

Use quando você já sabe qual código vai reprojetar e precisa pensar na forma dele: onde fica o seam, quão pequena a interface pode ficar, se uma extração tira complexidade dos chamadores. Use também para resolver uma discussão sobre o que uma palavra de design significa.

Várias skills estão perto dela. Escolha pelo problema que você tem:

| O problema | A skill |
|---|---|
| A forma de um módulo: a interface, o seam, a profundidade dele | `codebase-design` |
| As *palavras do domínio*: "conta" significa três coisas, duas pessoas querem dizer coisas diferentes com "cancelamento" | [domain-modeling](./domain-modeling.md) |
| Você ainda não sabe *qual* módulo reprojetar | [improve-codebase-architecture](./improve-codebase-architecture.md) (o levantamento que encontra os candidatos) |
| Você quer que o design seja discutido, não só nomeado | [grilling](../productivity/grilling.md) |
| Há um comportamento concreto a construir e você quer testes que sobrevivam a uma refatoração | [tdd](./tdd.md) |

## O vocabulário

O glossário é a skill. A skill define cada termo em relação aos outros e dá a cada um a palavra que ele substitui.

| Termo | O que significa | Não diga |
|---|---|---|
| **Módulo** | Qualquer coisa com uma interface e uma implementação. Deliberadamente independente de escala: uma função, uma classe, um pacote, uma fatia que atravessa camadas. | unidade, componente, serviço |
| **Interface** | Tudo o que quem chama precisa saber para usá-lo corretamente: a assinatura de tipos, mais invariantes, restrições de ordem, modos de erro, configuração obrigatória, características de desempenho. | API, assinatura |
| **Profundidade** (depth) | Alavancagem na interface: quanto comportamento quem chama, ou um teste, consegue exercitar por unidade de interface que precisa aprender. **Profundo** (deep): muito comportamento atrás de uma interface pequena. **Raso** (shallow): a interface é quase tão complexa quanto a implementação. | nenhum |
| **Seam** | O termo de Michael Feathers: um lugar onde dá para alterar o comportamento sem editar naquele lugar. É o *local* de uma interface, e onde colocá-lo é uma decisão própria, separada do que vai atrás dele. | fronteira |
| **Adapter** | Algo concreto que satisfaz uma interface num seam. Ele nomeia um papel, não um tipo de coisa: um fake em memória e um repositório Postgres são ambos adapters. | nenhum |
| **Alavancagem** (leverage) | O que quem chama ganha com a profundidade: mais capacidade por unidade de interface aprendida. | nenhum |
| **Localidade** (locality) | O que quem mantém ganha com a profundidade: mudanças, bugs e verificação ficam num lugar só, então uma correção cobre todos os chamadores. | nenhum |

A skill *não* define profundidade como a razão entre linhas de implementação e linhas de interface, que é a definição do próprio Ousterhout. Essa métrica premia inchar a implementação, então a skill usa profundidade como alavancagem.

## Os quatro princípios

- **Profundidade é propriedade da interface, não da implementação.** Um módulo profundo pode ser construído por dentro a partir de partes pequenas e substituíveis. Os chamadores só não as veem. Um módulo pode ter seams internos que os próprios testes usam, e um seam externo na interface.
- **O teste da exclusão.** Imagine apagar o módulo. Se a complexidade some, o módulo só repassava. Se ela reaparece em N chamadores, o módulo estava escondendo complexidade de verdade.
- **A interface é a superfície de teste.** Chamadores e testes atravessam o mesmo seam. Se você quer testar *além* da interface, o módulo está com a forma errada.
- **Um adapter significa um seam hipotético. Dois adapters significam um real.** Não corte um seam até que algo varie através dele. Um seam com um adapter só é apenas indireção.

Dois arquivos de apoio vão mais longe, e a skill os lê sob demanda, não de saída. O [DEEPENING.md](../../skills/engineering/codebase-design/DEEPENING.md) classifica as dependências de um candidato em quatro categorias (no mesmo processo, substituível localmente, remota mas própria, realmente externa), porque a categoria decide como você testa o módulo aprofundado através do seam dele. O [DESIGN-IT-TWICE.md](../../skills/engineering/codebase-design/DESIGN-IT-TWICE.md) dispara [subagents](https://www.aihero.dev/ai-coding-dictionary/subagent) paralelos para produzir três ou mais interfaces radicalmente diferentes para o mesmo módulo e depois as compara por profundidade, localidade e posicionamento do seam.

## Perguntas frequentes

**Como eu construo de fato um módulo profundo em TypeScript?**

Esta é a pergunta mais feita sobre a skill, e a skill não a responde. Ela define o que um módulo profundo *é*; não diz nada sobre como impedir que um import perdido passe por cima da interface. A [issue #458](https://github.com/mattpocock/skills/issues/458) colocou assim: "digamos que estamos satisfeitos com a interface, ela esconde os detalhes etc. Mas como garantimos isso? Acho que, sem lint ou guardrails claros, humanos e LLMs vão começar a bagunçar com o tempo." A resposta naquela thread deu três opções: envolver numa classe ou IIFE e aceitar que a classe fica enorme; transformar num pacote de um monorepo e aceitar o ferramental de monorepo; ou usar um linter como o [dependency-cruiser](https://github.com/sverweij/dependency-cruiser) para proibir imports que contornem a interface. Desses mecanismos, o Effect é o melhor e o dependency-cruiser, o segundo melhor. Existe uma skill `setup-ts-deep-modules` no bucket `in-progress/` do repositório que estabelece uma convenção `src/packages/<nome>/index.ts`, mas ela é uma skill do canal beta, sem página de documentação.

**Apontei uma sessão para ela e ela queimou 100 mil [tokens](https://www.aihero.dev/ai-coding-dictionary/token) reprojetando coisas que eu nunca pedi.**

É um problema conhecido, registrado como [issue #449](https://github.com/mattpocock/skills/issues/449). A skill é invocada pelo modelo e se descreve como vocabulário, mas nada nela impede de vez que um agente a trate como um processo executável. Mandado "retomar na /codebase-design e conduzir as decisões abertas", um agente pegou a parte da skill mais parecida com um processo: os subagentes paralelos do `DESIGN-IT-TWICE.md`. Ele reexplorou código que uma sessão anterior já tinha mapeado e trabalhou por muito tempo antes de perguntar qualquer coisa. Esta skill não tem nenhum dos guardrails de uma skill condutora (checkpoints, uma pergunta por vez, nada de avançar sozinho), porque ela é uma referência. A solução é invocar uma skill condutora (`/grill-with-docs`, `/improve-codebase-architecture` ou `/tdd`) e usar a `codebase-design` como vocabulário dela. A issue está aberta.

**Para onde foi a `design-an-interface`? E existe uma skill `/interface-design`?**

Esta skill substituiu a `design-an-interface` e ficou com o conteúdo dela. Não falta nada. A técnica "projete duas vezes" dela (subagentes paralelos gerando designs radicalmente diferentes, do Ousterhout) é distribuída aqui como `DESIGN-IT-TWICE.md`. Separadamente, várias pessoas pediram uma skill `/interface-design` dedicada à filosofia de módulo profundo / interface fina; esta skill já cobre essa filosofia, e nenhuma skill separada está planejada. Se você veio procurando qualquer um desses nomes, a página é esta.

**Isto não é uma convenção de estrutura de arquivos, tipo pastas, barrel files, feature slices?**

Não. As pessoas questionaram isso muitas vezes, e a skill não mudou. A [issue #95](https://github.com/mattpocock/skills/issues/95) propôs uma estrutura de arquivos em árvore fractal formalizada como a implementação concreta de módulos profundos; a resposta foi que as duas coisas são independentes: "módulos profundos são sobre o design da interface e o acesso por uma interface estrita, seja qual for a cara do sistema de arquivos. Parece perfeitamente possível ter módulos rasos com essa abordagem." O mesmo apareceu na #458: "Acho que você está amarrando demais o conceito de módulos ao sistema de arquivos. O sistema de arquivos com certeza pode ser uma pista útil da forma dos módulos, mas não há necessidade de usá-lo na construção de módulos profundos." O glossário define **módulo** como independente de escala de propósito.

**A `tdd` usa mesmo este vocabulário?**

Usa agora, mas por muito tempo não usou. A v1.0 tirou da `tdd` as notas inline sobre módulos profundos em favor desta skill compartilhada, mas ninguém acrescentou um ponteiro para substituí-las, então a `tdd` definia "seam" por conta própria e não referenciava nada. O ponteiro agora está na `tdd`, e o agente o segue quando a pergunta em aberto é a forma da interface, não os testes. A `tdd` continua sendo dona de "seam" como a fronteira em que você *testa*; esta skill é dona da forma do módulo por trás dela.

**O padrão "projete duas vezes" funciona fora do Claude Code?**

Não muito bem. O padrão pede subagentes paralelos, e a ferramenta que os dispara tem nome diferente em cada [harness](https://www.aihero.dev/ai-coding-dictionary/harness) (no Claude Code, é uma [tool](https://www.aihero.dev/ai-coding-dictionary/tool) chamada Agent). O repositório traz metadados para outros harnesses, incluindo o Codex, e eles podem não ter uma ferramenta com esse nome. Então a fase de design paralelo é menos portátil do que os metadados da skill sugerem. A [issue #564](https://github.com/mattpocock/skills/issues/564) acompanha isso, e está aberta.

**Posso acrescentar meus próprios conceitos ao glossário, como connascence, module secrets, [progressive disclosure](https://www.aihero.dev/ai-coding-dictionary/progressive-disclosure)?**

Já propuseram esses. A [issue #180](https://github.com/mattpocock/skills/issues/180) acrescenta os module secrets do Parnas e a connascence do Page-Jones como uma camada de nomes para *o que* está vazando através de um seam, com um diff funcionando anexado; a [issue #303](https://github.com/mattpocock/skills/issues/303) propõe progressive disclosure dentro da implementação, para que um módulo profundo na interface pública também tenha estrutura por dentro. As duas estão abertas e não foram incorporadas. O glossário distribuído é pequeno de propósito, e a própria skill dá o motivo: linguagem consistente é a questão toda, e um termo que ninguém usa de forma consistente é pior do que termo nenhum.

## Está funcionando se

- A conversa de design para de produzir as palavras "componente", "serviço" e "fronteira" e passa a produzir "módulo", "interface" e "seam".
- Alguém consegue apontar uma extração proposta e dizer, sem rodeios, se ela passa no teste da exclusão.
- Um seam proposto vem com um segundo adapter nomeado, não só o primeiro.
- A discussão de uma interface cobre invariantes, ordem e modos de erro, não só a assinatura de tipos.
- Invocá-la não inicia uma sessão de trabalho. Se o agente começar a ler arquivos e propor refatorações só a partir da `/codebase-design`, ele confundiu a referência com uma skill condutora.

## Onde se encaixa

A `codebase-design` é uma **avulsa para usar a qualquer hora**, e a camada de vocabulário por baixo das skills de engenharia, não um passo de alguma cadeia. A vizinha mais próxima é a [domain-modeling](./domain-modeling.md), a referência paralela para as palavras do *domínio do problema*, não para a forma do módulo. As duas costumam ser usadas juntas, já que dar um bom nome a um módulo profundo exige as duas. A [improve-codebase-architecture](./improve-codebase-architecture.md) é a outra: ela levanta candidatos a aprofundamento numa codebase e escreve cada um deles neste glossário, então ela encontra o módulo e você o projeta com as palavras desta skill. Quando não tiver certeza de qual skill ou fluxo serve, a [ask-matt](./ask-matt.md) te orienta.
