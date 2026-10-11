# Projete duas vezes

Quando o usuário quiser explorar interfaces alternativas para um candidato a aprofundamento já escolhido, use este padrão de subagentes paralelos. Baseado em "Design It Twice" (Ousterhout): a sua primeira ideia dificilmente é a melhor.

Usa o vocabulário de [SKILL.md](SKILL.md): **módulo**, **interface**, **seam**, **adapter**, **alavancagem**.

## Processo

### 1. Enquadre o espaço do problema

Antes de disparar subagentes, escreva para o usuário uma explicação do espaço do problema do candidato escolhido:

- As restrições que qualquer interface nova precisaria satisfazer
- As dependências em que ela se apoiaria, e em que categoria cada uma cai (veja [DEEPENING.md](DEEPENING.md))
- Um esboço de código ilustrativo e aproximado para ancorar as restrições: não uma proposta, só um jeito de tornar as restrições concretas

Mostre isso ao usuário e siga imediatamente para o Passo 2. O usuário lê e pensa enquanto os subagentes trabalham em paralelo.

### 2. Dispare os subagentes

Dispare 3 ou mais subagentes em paralelo. Cada um precisa produzir uma interface **radicalmente diferente** para o módulo aprofundado.

Passe a cada subagente um briefing técnico separado (caminhos de arquivo, detalhes de acoplamento, categoria de dependência de [DEEPENING.md](DEEPENING.md), o que fica atrás do seam). O briefing é independente da explicação do espaço do problema voltada ao usuário no Passo 1. Dê a cada agente uma restrição de design diferente:

- Agente 1: "Minimize a interface: no máximo 1 a 3 pontos de entrada. Maximize a alavancagem por ponto de entrada."
- Agente 2: "Maximize a flexibilidade: suporte muitos casos de uso e extensões."
- Agente 3: "Otimize para o chamador mais comum: torne o caso padrão trivial."
- Agente 4 (se fizer sentido): "Projete em torno de Ports & Adapters para as dependências que atravessam o seam."

Inclua no briefing tanto o vocabulário de [SKILL.md](SKILL.md) quanto o do GLOSSARY.md, para que cada subagente dê nomes de forma consistente com a linguagem de arquitetura e com a linguagem de domínio do projeto.

Cada subagente entrega:

1. Interface (tipos, métodos, parâmetros, mais invariantes, ordem, modos de erro)
2. Exemplo de uso mostrando como os chamadores a usam
3. O que a implementação esconde atrás do seam
4. Estratégia de dependências e adapters (veja [DEEPENING.md](DEEPENING.md))
5. Trade-offs: onde a alavancagem é alta, onde é fraca

### 3. Apresente e compare

Apresente os designs um de cada vez para o usuário absorver cada um e depois compare-os em prosa. Contraste por **profundidade** (alavancagem na interface), **localidade** (onde a mudança se concentra) e **posicionamento do seam**.

Depois de comparar, dê a sua própria recomendação: qual design você acha mais forte e por quê. Se elementos de designs diferentes combinarem bem, proponha um híbrido. Tenha opinião: o usuário quer uma leitura firme, não um cardápio.
