---
name: improve-codebase-architecture
description: Varre um código em busca de oportunidades de aprofundamento, apresenta-as como um relatório HTML visual e depois sabatina a que você escolher.
disable-model-invocation: true
---

# Melhorar a arquitetura do código

Exponha atritos de arquitetura e proponha **oportunidades de aprofundamento**: refatorações que transformam módulos rasos em profundos. O objetivo é testabilidade e navegabilidade por IA.

Este comando é _informado_ pelo modelo de domínio do projeto e construído sobre um vocabulário de design compartilhado:

- Chame a ferramenta Skill com "codebase-design" para o vocabulário de arquitetura (**módulo**, **interface**, **profundidade**, **seam**, **adapter**, **alavancagem**, **localidade**) e seus princípios (o teste da exclusão, "a interface é a superfície de teste", "um adapter = seam hipotético, dois = real"). Use exatamente esses termos em toda sugestão, e não escorregue para "componente", "serviço", "API" ou "fronteira".
- A linguagem de domínio do `GLOSSARY.md` dá nome aos bons seams; os ADRs em `docs/adr/` registram decisões que este comando não deve rediscutir.

## Processo

### 1. Explore

**Delimite antes de varrer: YAGNI.** Aprofundar um módulo compensa ao facilitar mudanças futuras nele, então dê peso extra às partes do código que mudaram recentemente. Decida *onde* olhar antes de olhar:

- Se o usuário indicou uma direção (um módulo, um subsistema, um ponto de dor), siga-a e pule a dedução abaixo.
- Caso contrário, percorra um bom trecho do histórico de commits (`git log --oneline`) para encontrar os pontos quentes do código, os arquivos e áreas que aparecem o tempo todo, e deixe esses caminhos atraírem a sua atenção primeiro. Se as mudanças estiverem espalhadas sem um ponto quente claro, amplie a rede.

Leia primeiro o glossário de domínio do projeto (`GLOSSARY.md`) e os ADRs da área que você está mexendo.

Depois dispare um subagente para percorrer o código. Não siga heurísticas rígidas; explore de forma orgânica e anote onde você sente atrito:

- Onde entender um conceito exige pular entre muitos módulos pequenos?
- Onde os módulos são **rasos**, com uma interface quase tão complexa quanto a implementação?
- Onde funções puras foram extraídas só por testabilidade, mas os bugs reais se escondem em como elas são chamadas (sem **localidade**)?
- Onde módulos fortemente acoplados vazam através dos seus seams?
- Quais partes do código não têm testes, ou são difíceis de testar pela interface atual?

Aplique o **teste da exclusão** a tudo que você suspeitar ser raso: apagar isso concentraria a complexidade, ou só a moveria de lugar? Um "sim, concentra" é o sinal que você quer.

### 2. Apresente os candidatos como um relatório HTML

Escreva um arquivo HTML autocontido no diretório temporário do sistema operacional, para que nada caia no repositório. Resolva o diretório temporário a partir de `$TMPDIR`, recorrendo a `/tmp` (ou `%TEMP%` no Windows), e escreva em `<tmpdir>/architecture-review-<timestamp>.html` para que cada execução gere um arquivo novo. Abra-o para o usuário (`xdg-open <caminho>` no Linux, `open <caminho>` no macOS, `start <caminho>` no Windows) e informe o caminho absoluto.

O relatório usa **Tailwind via CDN** para layout e estilo, e **Mermaid via CDN** para diagramas em que um grafo/fluxo/sequência comunica a estrutura de forma confiável. Misture Mermaid com visuais feitos à mão em CSS/SVG: use Mermaid quando as relações tiverem forma de grafo (grafos de chamada, dependências, sequências), e divs/SVG feitos à mão quando quiser algo mais editorial (diagramas de massa, cortes transversais, animações de colapso). Cada candidato ganha uma **visualização de antes/depois**. Seja visual.

Para cada candidato, renderize um card com:

- **Arquivos**: quais arquivos/módulos estão envolvidos
- **Problema**: por que a arquitetura atual está causando atrito
- **Solução**: descrição em linguagem simples do que mudaria
- **Benefícios**: explicados em termos de localidade e alavancagem, e de como os testes melhorariam
- **Diagrama de antes / depois**: lado a lado, desenhado sob medida, ilustrando a superficialidade e o aprofundamento
- **Força da recomendação**: uma entre `Forte`, `Vale explorar`, `Especulativa`, renderizada como um selo

Termine o relatório com uma seção de **Recomendação principal**: qual candidato você atacaria primeiro e por quê.

**Use o vocabulário do GLOSSARY.md para o domínio, e o vocabulário da `/codebase-design` para a arquitetura.** Se o `GLOSSARY.md` define "Pedido", fale em "o módulo de entrada de Pedidos", não em "o FooBarHandler", e nem em "o serviço de Pedidos".

**Conflitos com ADRs**: se um candidato contradiz um ADR existente, só o apresente quando o atrito for real o bastante para justificar revisitar o ADR. Marque isso claramente no card (ex.: um aviso: _"contradiz o ADR-0007, mas vale reabrir porque…"_). Não liste toda refatoração teórica que um ADR proíbe.

Veja [HTML-REPORT.md](HTML-REPORT.md) para a estrutura HTML completa, os padrões de diagrama e as orientações de estilo.

NÃO proponha interfaces ainda. Depois que o arquivo for escrito, pergunte ao usuário: "Qual destes você gostaria de explorar?"

### 3. Ciclo de sabatina

Quando o usuário escolher um candidato, chame a ferramenta Skill com "grilling" para percorrer a árvore de decisões com ele: restrições, dependências, a forma do módulo aprofundado, o que fica atrás do seam, quais testes sobrevivem.

Os efeitos colaterais acontecem no caminho, conforme as decisões se cristalizam; chame a ferramenta Skill com "domain-modeling" para manter o modelo de domínio atualizado enquanto avança:

- **Vai dar ao módulo aprofundado o nome de um conceito que não está no `GLOSSARY.md`?** Acrescente o termo ao `GLOSSARY.md`. Crie o arquivo sob demanda se ele não existir.
- **Afiou um termo vago durante a conversa?** Atualize o `GLOSSARY.md` ali mesmo.
- **O usuário rejeitou o candidato por um motivo de peso?** Ofereça um ADR, assim: _"Quer que eu registre isto como um ADR para que as próximas revisões de arquitetura não voltem a sugerir isso?"_ Só ofereça quando o motivo for realmente necessário para um explorador futuro evitar sugerir a mesma coisa de novo; pule motivos passageiros ("não vale a pena agora") e os autoevidentes.
- **Quer explorar interfaces alternativas para o módulo aprofundado?** Chame a ferramenta Skill com "codebase-design" e use o padrão de subagentes paralelos "projete duas vezes" dela.
