## O que faz

A `tdd` constrói uma funcionalidade ou corrige um bug com teste primeiro: um teste que falha, depois só o código suficiente para ele passar, depois o próximo comportamento. Ela traz os padrões que fazem esse loop produzir testes que valem a pena manter: o que é um bom teste, onde os testes ficam, para que servem os mocks e os três antipadrões que deixam uma suíte sem valor.

Ela não escreve teste nenhum num seam que você não combinou antes. Antes de existir qualquer teste, ela diz as fronteiras públicas em que pretende testar e para esperando a sua confirmação. O esforço de teste é finito, e esse passo o gasta nos caminhos críticos e não em todo caso-limite. A `tdd` também é uma **referência**, não uma condutora. Ela contém as regras do loop, e outra coisa (você, ou a [implement](./implement.md)) conduz a [session](https://www.aihero.dev/ai-coding-dictionary/session) que as aplica.

## Quando usar

Digite `/tdd`, ou o [agent](https://www.aihero.dev/ai-coding-dictionary/agent) recorre a ela automaticamente quando uma tarefa se encaixa: construir uma funcionalidade ou corrigir um bug com teste primeiro, ou quando você diz "red-green-refactor".

Use quando houver um comportamento concreto para construir, com uma entrada e uma saída observável, e você quiser testes que sobrevivam a uma refatoração.

| A sua situação | Para onde ir |
| --- | --- |
| Um comportamento com entradas e saídas definidas (regra de negócio, um contrato de requisição/resposta, uma transformação, uma validação) | `tdd` |
| O comportamento ainda não está definido | [to-spec](./to-spec.md), que também combina os seams de teste antes de qualquer código ser escrito |
| A questão é na verdade a forma da interface, não os testes | [codebase-design](./codebase-design.md) |
| Você tem uma [spec](https://www.aihero.dev/ai-coding-dictionary/spec) ou [tickets](https://www.aihero.dev/ai-coding-dictionary/ticket) e quer que a construção inteira rode por você | [implement](./implement.md), que conduz a `tdd` por ticket |
| Configuração, ligações, código de cola, anotações de tipo, CRUD que só delega | Nada aqui encaixa bem; veja a lacuna em aberto abaixo |

Essa última linha é uma lacuna real. A skill decide *onde* ficam os seams, mas nada nela decide *se* uma mudança vale o loop. Se você a rodar numa mudança sem uma fonte da verdade independente contra a qual fazer asserções, você ganha um teste que repete a implementação. É o antipadrão tautológico contra o qual a skill avisa, alcançado pelo outro lado. É a [issue #746](https://github.com/mattpocock/skills/issues/746), e está aberta. Até ela fechar, essa decisão é sua, ou escreva a regra no seu `CLAUDE.md`.

## Pré-requisitos

A [codebase-design](./codebase-design.md) precisa estar instalada. A `tdd` tinha as próprias notas sobre módulos profundos e design de interface; a v1.0 as apagou em favor da skill compartilhada, e a `tdd` agora usa o vocabulário de design de interface dela. Mais nada; a skill é [stateless](https://www.aihero.dev/ai-coding-dictionary/stateless) (sem estado) e não escreve arquivos próprios.

## O loop, e o seam em que ele roda

A skill se apoia em três termos.

**Red-green.** Escreva o teste que falha, depois só o código suficiente para ele passar. Não escreva código para o teste depois do próximo. Não há fase de refactor. A skill a tirou em junho de 2026 porque os agentes quase nunca a faziam, e porque revisão e implementação funcionam melhor como sessões separadas. A refatoração pertence à [code-review](./code-review.md).

**Vertical slice.** Escreva um teste num seam, depois a implementação mínima, e repita. O primeiro ciclo é um **tracer bullet** que prova um único caminho de ponta a ponta. O oposto é o horizontal slicing: todos os testes primeiro, depois todo o código. Testes escritos em lote verificam um comportamento *imaginado*. Eles conferem o formato das coisas em vez do que um usuário faz, e te comprometem com uma estrutura de testes antes de você entender a implementação.

**Seam combinado de antemão.** Um seam é a fronteira pública em que você observa o comportamento sem enfiar a mão por dentro. A regra não tem exceções. Nenhum teste vai num seam não confirmado. Na cadeia completa, os seams são combinados antes, durante a [to-spec](./to-spec.md): "a `/tdd` é instruída a trabalhar só nos seams de teste combinados de antemão, e a `/code-review` confere que só os seams combinados foram usados." Invocada sozinha, a `tdd` te pergunta diretamente.

Os três antipadrões que ela foi escrita para evitar:

| Antipadrão | O sinal |
| --- | --- |
| Acoplado à implementação | O teste quebra quando você renomeia uma função interna, embora o comportamento não tenha mudado. Colaboradores internos mockados, contagem de chamadas nas asserções, consultas ao banco de dados usadas para verificar em vez da interface. |
| Tautológico | O valor esperado é calculado do mesmo jeito que o código calcula, então o teste passa por construção. Os valores esperados precisam vir de outro lugar: um literal sabidamente correto, um exemplo calculado, a spec. |
| Horizontal slicing | Um lote de testes entrou antes de qualquer implementação. |

Mocks são só para as fronteiras do sistema: APIs externas, tempo, aleatoriedade, às vezes o sistema de arquivos ou o banco de dados. Nunca faça mock dos seus próprios módulos.

## Perguntas frequentes

**Por que ela não refatora? A descrição diz "red-green-refactor".**

Porque o passo de refactor foi removido e a descrição não. A remoção foi proposital. Os agentes quase nunca faziam o passo, e manter implementação e revisão em sessões separadas funciona melhor. Se o resultado ainda conta como TDD de livro importa menos do que se o loop produz código melhor. O desencontro entre a frase de gatilho e o corpo está registrado como [issue #589](https://github.com/mattpocock/skills/issues/589) e continua aberto, então "red-green-refactor" continua funcionando como frase que dispara a skill. O que você ganha é red-green, com a refatoração na [code-review](./code-review.md).

**Ela me pediu para escolher um seam de teste e eu não fazia ideia de qual escolher.**

Este é o atrito mais relatado da skill ([issue #607](https://github.com/mattpocock/skills/issues/607)). Na versão original, o prompt lista os seams candidatos só pelo nome, sem dizer o que cada um pega ou deixa passar, então você escolhe entre rótulos. (Nota da tradução: o `SKILL.md` em que esta tradução se baseia já pede uma nota de uma linha por seam dizendo o que ele pega e o que deixa passar.) Se ainda assim faltar clareza, peça ao agente os trade-offs antes de responder: o que o seam de componente deixa passar que o seam de integração pega, e quanto mais lento ele é. É também por isso que a cadeia combina os seams antes, na `to-spec`, onde você tem a funcionalidade inteira à vista e não um único prompt.

**Ela escreveu a implementação antes do teste, mesmo a skill dizendo vermelho primeiro.**

Acontece. Um usuário questionou o [model](https://www.aihero.dev/ai-coding-dictionary/model) sobre isso e recebeu uma resposta de honestidade incomum: "Eu sabia que a skill dizia 'um teste por vez, veja-o falhar pelo motivo certo'. Eu li. Só caí no meu hábito normal." A skill aceita isso. Nenhuma instrução faz um agente obedecer 100% das vezes, e uma redação mais rígida restringe a criatividade do agente por pouco ganho. O loop vale a pena mesmo quando o agente não o segue à risca, porque os resultados ainda são melhores no geral. Se a aderência estrita importar para um slice específico, acompanhe a execução em vez de confiar que a skill vai impô-la.

**Ela deveria escrever testes de navegador ou end-to-end primeiro?**

Normalmente não, e a skill não vai impedir. Um usuário relatou o agente escrevendo um teste de Playwright primeiro, depois passando um loop longo rodando-o de novo e concluindo que o *teste* estava quebrado, para uma funcionalidade que ainda não existia. Testes de navegador são lentos o bastante para que o feedback loop red-green deixe de se pagar. Diga no `CLAUDE.md` do seu repositório que testes de navegador vêm depois que o comportamento funciona.

**A `/tdd` substitui a `/implement`, ou a `/do-work` do curso?**

Não. A `/tdd` documenta a metodologia; a `/implement` é um loop simples de trabalho→feedback→commit e é a substituta direta da `/do-work`. O passo único `/do-work` do curso agora está dividido entre `/implement`, `/tdd` e `/code-review`. Se você está perguntando qual rodar contra um ticket, a resposta é quase sempre `/implement`.

**Para onde foram as orientações sobre módulos profundos e design de interface?**

Para a [codebase-design](./codebase-design.md) na v1.0, generalizadas para que várias skills compartilhem um vocabulário. O `refactoring.md` saiu na mesma época; refatorar agora é trabalho da [code-review](./code-review.md), e é aquela skill que traz a base de code smells do Fowler.

**Ela sabe dos meus outros tickets?**

Não. Rodada contra um ticket, ela pode propor trabalho que pertence a um ticket irmão, porque não enxerga o resto do grafo de issues ([issue #129](https://github.com/mattpocock/skills/issues/129)). Isso não é trabalho da `tdd`. Passar a spec junto com o ticket ajuda; dimensionar bem os tickets desde o início ajuda mais.

## Está funcionando se

- Ela para e diz os seams em que pretende testar, e espera, antes de existir qualquer arquivo de teste.
- Um teste aparece, fica vermelho, recebe só o código suficiente para passar, e só então aparece o próximo teste, não um lote de testes seguido de um lote de código.
- Os nomes dos testes se leem como capacidades ("usuário consegue finalizar a compra com carrinho válido"), não como detalhes internos ("checkout chama paymentService.process").
- Os valores esperados nas asserções são literais que você consegue rastrear até a spec, não valores recalculados do jeito que o código calcula.
- Renomear uma função interna não quebra nada na suíte.
- Os mocks só aparecem nas fronteiras externas (a API de pagamento, o relógio) e nunca em volta dos seus próprios módulos.

## Onde se encaixa

A `tdd` roda dentro do passo de construção da cadeia principal; ela não é um passo próprio:

```txt
grill-with-docs → to-spec → to-tickets → implement → code-review → retro
```

A [to-spec](./to-spec.md) combina os seams de teste de antemão, a [implement](./implement.md) conduz a `tdd` por ticket, e a [code-review](./code-review.md) confere depois que só os seams combinados foram usados, e é dona da refatoração que a `tdd` não faz mais. A outra vizinha é a [codebase-design](./codebase-design.md), a fonte compartilhada do vocabulário de seam e de módulo profundo que a `tdd` usa. Você também pode usá-la sozinha, sempre que houver um comportamento concreto para construir e nenhuma spec completa em jogo. Quando não tiver certeza de qual skill serve na sua situação, a [ask-matt](./ask-matt.md) te orienta.
