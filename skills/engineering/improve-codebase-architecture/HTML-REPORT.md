# Formato do relatório HTML

A revisão de arquitetura é renderizada como um único arquivo HTML autocontido no diretório temporário do sistema operacional. Tailwind e Mermaid vêm ambos de CDNs. O Mermaid cuida bem dos diagramas em forma de grafo; divs feitas à mão e SVG inline cuidam dos visuais mais editoriais (diagramas de massa, cortes transversais). Misture os dois: não dependa do Mermaid para tudo, senão fica com cara genérica.

## Estrutura

```html
<!doctype html>
<html lang="pt-BR">
  <head>
    <meta charset="utf-8" />
    <title>Revisão de arquitetura de {{nome do repositório}}</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script type="module">
      import mermaid from "https://cdn.jsdelivr.net/npm/mermaid@11/dist/mermaid.esm.min.mjs";
      mermaid.initialize({ startOnLoad: true, theme: "neutral", securityLevel: "loose" });
    </script>
    <style>
      /* pequena camada própria para o que o Tailwind não cobre bem:
         linhas tracejadas de seam, pontas de seta com cara de desenho à mão etc. */
      .seam { stroke-dasharray: 4 4; }
      .leak { stroke: #dc2626; }
      .deep { background: linear-gradient(135deg, #0f172a, #1e293b); }
    </style>
  </head>
  <body class="bg-stone-50 text-slate-900 font-sans">
    <main class="max-w-5xl mx-auto px-6 py-12 space-y-12">
      <header>...</header>
      <section id="candidates" class="space-y-10">...</section>
      <section id="top-recommendation">...</section>
    </main>
  </body>
</html>
```

## Cabeçalho

Nome do repositório, data e uma legenda compacta: caixa sólida = módulo, linha tracejada = seam, seta vermelha = vazamento, caixa escura e grossa = módulo profundo. Sem parágrafo de introdução. Direto para os candidatos.

## Card do candidato

Os diagramas carregam o peso. A prosa é escassa, simples, e usa os termos do glossário (da skill `/codebase-design`) sem cerimônia.

Cada candidato é um `<article>`:

- **Título**: curto, dá nome ao aprofundamento (ex.: "Colapsar o pipeline de entrada de Pedidos").
- **Linha de selos**: força da recomendação (`Forte` = esmeralda, `Vale explorar` = âmbar, `Especulativa` = ardósia), mais uma etiqueta para a categoria de dependência (`no mesmo processo`, `substituível localmente`, `ports & adapters`, `mock`).
- **Arquivos**: lista em fonte monoespaçada, `font-mono text-sm`.
- **Diagrama de antes / depois**: a peça central. Duas colunas, lado a lado. Veja os padrões abaixo.
- **Problema**: uma frase. O que dói.
- **Solução**: uma frase. O que muda.
- **Ganhos**: tópicos de até 6 palavras cada. Ex.: "Testes batem numa interface só", "Lógica de preço para de vazar", "Apaga 4 wrappers rasos".
- **Aviso de ADR** (se for o caso): uma linha numa caixa em tom âmbar.

Nada de parágrafos de explicação. Se o diagrama precisa de um parágrafo para ser entendido, redesenhe o diagrama.

## Padrões de diagrama

Escolha o padrão que se encaixa no candidato. Misture. Não faça todos os diagramas iguais. A variedade faz parte da proposta.

### Grafo Mermaid (o burro de carga para dependências / fluxo de chamadas)

Use um `flowchart` ou `graph` do Mermaid quando a ideia for "X chama Y que chama Z, e olha a bagunça". Envolva-o num card estilizado com Tailwind para não parecer que caiu de paraquedas. Estilize com classDef para pintar de vermelho as arestas de vazamento e de escuro o módulo profundo. Diagramas de sequência funcionam bem para "antes: 6 idas e voltas; depois: 1".

```html
<div class="rounded-lg border border-slate-200 bg-white p-4">
  <pre class="mermaid">
    flowchart LR
      A[OrderHandler] --> B[OrderValidator]
      B --> C[OrderRepo]
      C -.vazamento.-> D[PricingClient]
      classDef leak stroke:#dc2626,stroke-width:2px;
      class C,D leak
  </pre>
</div>
```

### Caixas e setas feitas à mão (quando o layout do Mermaid briga com você)

Módulos como `<div>`s com bordas e rótulos. Setas como elementos SVG inline `<line>` ou `<path>` posicionados de forma absoluta sobre um contêiner relativo. Recorra a isso quando quiser que o diagrama de "depois" pareça um único módulo profundo de borda grossa com o interior acinzentado, já que o Mermaid não renderiza isso com o peso certo.

### Corte transversal (bom para superficialidade em camadas)

Empilhe faixas horizontais (`h-12 border-l-4`) para mostrar as camadas por onde uma chamada passa. Antes: 6 camadas finas, cada uma sem fazer nada. Depois: 1 faixa grossa rotulada com a responsabilidade consolidada.

### Diagrama de massa (bom para "interface tão larga quanto a implementação")

Dois retângulos por módulo: um para a área de superfície da interface, outro para a implementação. Antes: o retângulo da interface é quase tão alto quanto o da implementação (raso). Depois: o retângulo da interface é baixo e o da implementação é alto (profundo).

### Colapso do grafo de chamadas

Antes: uma árvore de chamadas de função renderizada como caixas aninhadas. Depois: a mesma árvore colapsada numa caixa só, com as chamadas agora internas aparecendo esmaecidas dentro dela.

## Orientações de estilo

- Puxe para o editorial, não para o dashboard corporativo. Espaço em branco generoso. Serifa opcional nos títulos (`font-serif` combina bem com stone/slate).
- Cor com moderação: uma cor de destaque (esmeralda ou índigo) mais vermelho para vazamento e âmbar para avisos.
- Mantenha os diagramas com ~320px de altura, para que antes/depois caibam confortavelmente lado a lado sem rolagem.
- Use `text-xs uppercase tracking-wider` para os rótulos de módulo dentro dos diagramas, para que se leiam como esquema, não como UI.
- Os únicos scripts são o CDN do Tailwind e o import ESM do Mermaid. Fora isso o relatório é estático: sem código de aplicação, sem interatividade além da própria renderização do Mermaid.

## Seção de recomendação principal

Um card maior. Nome do candidato, uma frase sobre o porquê, link de âncora para o card dele. Só isso.

## Tom

Português simples e conciso, mas os substantivos e verbos de arquitetura vêm direto da skill `/codebase-design`. Concisão não é desculpa para desviar.

**Use exatamente:** módulo, interface, implementação, profundidade, profundo, raso, seam, adapter, alavancagem, localidade.

**Nunca substitua por:** componente, serviço, unidade (no lugar de módulo) · API, assinatura (no lugar de interface) · fronteira (no lugar de seam) · camada, wrapper (no lugar de módulo, quando você quer dizer módulo).

**Formulações que combinam com o estilo:**

- "O módulo de entrada de Pedidos é raso: a interface quase espelha a implementação."
- "O cálculo de preço vaza através do seam."
- "Aprofunde: uma interface, um lugar para testar."
- "Dois adapters justificam o seam: HTTP em produção, em memória nos testes."

Os **tópicos de ganhos** nomeiam o ganho em termos do glossário: *"localidade: os bugs se concentram num módulo"*, *"alavancagem: uma interface, N pontos de chamada"*, *"a interface encolhe; a implementação absorve os wrappers"*. Não escreva *"mais fácil de manter"* ou *"código mais limpo"*, porque esses termos não estão no glossário e não merecem o espaço.

Sem rodeios, sem pigarro, sem "vale notar que…". Se uma frase pode ser um tópico, faça um tópico. Se um tópico pode ser cortado, corte. Se um termo não está no glossário da `/codebase-design`, procure um que esteja antes de inventar um novo.
