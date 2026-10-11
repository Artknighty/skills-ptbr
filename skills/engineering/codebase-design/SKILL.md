---
name: codebase-design
description: Vocabulário compartilhado para projetar módulos profundos. Use quando o usuário quiser projetar ou melhorar a interface de um módulo, encontrar oportunidades de aprofundamento, decidir onde fica um seam, deixar o código mais testável ou mais navegável por IA, ou quando outra skill precisar do vocabulário de módulos profundos.
---

# Design de código

Projete **módulos profundos**: muito comportamento atrás de uma interface pequena, posicionada num seam limpo, testável por essa interface. Use esta linguagem e estes princípios sempre que um código estiver sendo projetado ou reestruturado. O objetivo é alavancagem para quem chama, localidade para quem mantém e testabilidade para todo mundo.

## Glossário

Use exatamente estes termos: não troque por "componente", "serviço", "API" ou "fronteira". Linguagem consistente é a questão toda.

**Módulo**: qualquer coisa com uma interface e uma implementação. Deliberadamente independente de escala: uma função, uma classe, um pacote ou uma fatia que atravessa camadas. _Evitar_: unidade, componente, serviço.

**Interface**: tudo o que quem chama precisa saber para usar o módulo corretamente: a assinatura de tipos, mas também invariantes, restrições de ordem, modos de erro, configuração obrigatória e características de desempenho. _Evitar_: API, assinatura (estreitos demais, referem-se só à superfície no nível dos tipos).

**Implementação**: o que está dentro de um módulo, o corpo de código dele. Diferente de **Adapter**: algo pode ser um adapter pequeno com uma implementação grande (um repositório Postgres) ou um adapter grande com uma implementação pequena (um fake em memória). Use "adapter" quando o assunto for o seam; "implementação" nos demais casos.

**Profundidade** (depth): alavancagem na interface. A quantidade de comportamento que quem chama (ou um teste) consegue exercitar por unidade de interface que precisa aprender. Um módulo é **profundo** quando muito comportamento fica atrás de uma interface pequena, e **raso** quando a interface é quase tão complexa quanto a implementação.

**Seam** _(Michael Feathers)_: um lugar onde você pode alterar o comportamento sem editar nesse lugar; o *local* onde vive a interface de um módulo. Onde colocar o seam é uma decisão de design própria, separada do que vai atrás dele. _Evitar_: fronteira (sobrecarregado pelo bounded context do DDD).

**Adapter**: algo concreto que satisfaz uma interface num seam. Descreve o *papel* (que encaixe ele preenche), não a substância (o que tem dentro).

**Alavancagem** (leverage): o que quem chama ganha com a profundidade. Mais capacidade por unidade de interface aprendida. Uma implementação se paga em N pontos de chamada e M testes.

**Localidade** (locality): o que quem mantém ganha com a profundidade. Mudanças, bugs, conhecimento e verificação se concentram num lugar só, em vez de se espalharem pelos chamadores. Corrigiu uma vez, corrigiu em todo lugar.

## Profundo vs. raso

**Módulo profundo** (deep module) = interface pequena + muita implementação:

```
┌──────────────────────┐
│  Interface Pequena   │  ← Poucos métodos, parâmetros simples
├──────────────────────┤
│                      │
│Implementação Profunda│  ← Lógica complexa escondida
│                      │
└──────────────────────┘
```

**Módulo raso** (shallow module) = interface grande + pouca implementação (evite):

```
┌─────────────────────────────────┐
│        Interface Grande         │  ← Muitos métodos, parâmetros complexos
├─────────────────────────────────┤
│  Implementação Fina             │  ← Só repassa adiante
└─────────────────────────────────┘
```

Ao projetar uma interface, pergunte:

- Consigo reduzir o número de métodos?
- Consigo simplificar os parâmetros?
- Consigo esconder mais complexidade lá dentro?

## Princípios

- **Profundidade é propriedade da interface, não da implementação.** Um módulo profundo pode ser composto internamente de partes pequenas, mockáveis e substituíveis; elas só não fazem parte da interface. Um módulo pode ter **seams internos** (privados à implementação, usados pelos próprios testes) além do **seam externo** na interface.
- **O teste da exclusão.** Imagine apagar o módulo. Se a complexidade some, ele só repassava. Se a complexidade reaparece em N chamadores, ele estava pagando o próprio sustento.
- **A interface é a superfície de teste.** Chamadores e testes atravessam o mesmo seam. Se você quer testar *além* da interface, provavelmente o módulo está com a forma errada.
- **Um adapter significa um seam hipotético. Dois adapters significam um seam real.** Não introduza um seam a menos que algo realmente varie através dele.

## Projetando para testabilidade

Boas interfaces tornam o teste natural:

1. **Receba dependências, não as crie.**

   ```typescript
   // Testável
   function processOrder(order, paymentGateway) {}

   // Difícil de testar
   function processOrder(order) {
     const gateway = new StripeGateway();
   }
   ```

2. **Retorne resultados, não produza efeitos colaterais.**

   ```typescript
   // Testável
   function calculateDiscount(cart): Discount {}

   // Difícil de testar
   function applyDiscount(cart): void {
     cart.total -= discount;
   }
   ```

3. **Pouca área de superfície.** Menos métodos = menos testes necessários. Menos parâmetros = preparação de teste mais simples.

## Relações

- Um **Módulo** tem exatamente uma **Interface** (a superfície que apresenta a chamadores e testes).
- **Profundidade** é uma propriedade de um **Módulo**, medida em relação à sua **Interface**.
- Um **Seam** é onde vive a **Interface** de um **Módulo**.
- Um **Adapter** fica num **Seam** e satisfaz a **Interface**.
- A **Profundidade** produz **Alavancagem** para quem chama e **Localidade** para quem mantém.

## Enquadramentos rejeitados

- **Profundidade como razão entre linhas de implementação e linhas de interface** (Ousterhout): premia inchar a implementação. Usamos profundidade como alavancagem.
- **"Interface" como a palavra-chave `interface` do TypeScript ou os métodos públicos de uma classe**: estreito demais: interface aqui inclui todo fato que quem chama precisa saber.
- **"Fronteira"**: sobrecarregado pelo bounded context do DDD. Diga **seam** ou **interface**.

## Indo mais fundo

- **Aprofundar um grupo de módulos dadas as suas dependências**, veja [DEEPENING.md](DEEPENING.md): categorias de dependência, disciplina de seams e teste por substituição em vez de camadas.
- **Explorar interfaces alternativas**, veja [DESIGN-IT-TWICE.md](DESIGN-IT-TWICE.md): dispare subagentes paralelos para projetar a interface de vários jeitos radicalmente diferentes e depois compare por profundidade, localidade e posicionamento do seam.
