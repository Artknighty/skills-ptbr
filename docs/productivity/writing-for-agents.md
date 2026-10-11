## O que faz

A `writing-for-agents` é a referência para escrever documentos voltados a agentes: uma skill, um `AGENTS.md` ou `CLAUDE.md`, uma [spec](https://www.aihero.dev/ai-coding-dictionary/spec), um prompt de execução, um README, qualquer documento que um [agent](https://www.aihero.dev/ai-coding-dictionary/agent) leia. O formato muda, mas a escrita não. As mesmas alavancas tornam cada um previsível, de modo que o agente siga o mesmo *processo* a cada execução (não necessariamente chegando à mesma saída).

A correção padrão dela é apagar, não explicar. Peça a um agente para escrever instruções para outro agente e ele vai gastar a maior parte das palavras explicando o que o [model](https://www.aihero.dev/ai-coding-dictionary/model) já sabe. Cada uma dessas linhas é um **no-op**: custa [context](https://www.aihero.dev/ai-coding-dictionary/context) e não muda comportamento nenhum. Esta referência te ajuda a encontrá-las, então ela é tão útil num documento que você já tem quanto num arquivo em branco.

Ela se chamava `writing-great-skills` até a v1.1. O nome novo combina com o que ela sempre foi. Quase nada nela é específico de skills. A mecânica exclusiva de skills (frontmatter, a escolha entre invocação pelo modelo ou pelo usuário, skills roteadoras) vive num `SKILL-MECHANICS.md` linkado, que você só lê quando o documento à sua frente for uma skill.

## Quando usar

Digite `/writing-for-agents`, ou o agente recorre a ela sozinho quando você estiver criando ou editando uma skill, ou modificando o `AGENTS.md` ou o `CLAUDE.md`.

Recorra a ela manualmente para tudo o mais que um agente lê: a sua documentação, specs e [tickets](https://www.aihero.dev/ai-coding-dictionary/ticket), prompts de sistema e de [AFK](https://www.aihero.dev/ai-coding-dictionary/afk). O teste é uma pergunta: um agente lê isto? Não importa como o agente chega ao documento: um ponteiro o cita, um humano o cola, ou ele está no repositório. Para descobrir o que uma codebase contém, use a [grill-with-docs](../engineering/grill-with-docs.md). Esta referência controla como um documento se lê, não o que ele sabe.

## As duas cargas

A ideia central são dois orçamentos que todo documento e ponteiro gasta:

- **Carga de contexto**: o custo do material sempre carregado na janela do agente: uma linha do `AGENTS.md`, a descrição de uma skill, qualquer coisa que fique no contexto a cada [turn](https://www.aihero.dev/ai-coding-dictionary/turn), dispare ou não.
- **Carga cognitiva**: o custo, para você, de lembrar quais documentos existem e quando recorrer a cada um. Você é o índice. Não tente minimizar esse custo, porque ele é o preço da agência humana.

Depois que você pensa nessas duas cargas, a maioria das decisões de autoria (dividir ou não, deixar inline ou separar, apontar ou empurrar) vira a mesma troca feita em lugares diferentes.

## As alavancas

- **[Context pointers](https://www.aihero.dev/ai-coding-dictionary/context-pointer)** (ponteiros de contexto): a referência mantida no contexto que nomeia um material fora do contexto e codifica quando alcançá-lo. A descrição de uma skill e uma linha do `AGENTS.md` citando um documento são a mesma coisa. É a *redação* do ponteiro, não o alvo, que decide com que confiabilidade o agente o segue.
- **Hierarquia de informação**: a escada que vai do passo no arquivo, à referência no arquivo, à referência separada atrás de um ponteiro. **[Progressive disclosure](https://www.aihero.dev/ai-coding-dictionary/progressive-disclosure)** é mover material escada abaixo para que o topo continue fácil de ler.
- **Critérios de conclusão**: quão clara e exigente é a condição de pronto de cada passo, e o **trabalho braçal** que essa exigência gera. Eles são a defesa contra a **conclusão prematura**.
- **Palavras-guia**: um conceito compacto que já está no pré-treinamento do modelo (*enxuto*, *vermelho*, *tracer bullet*) e com o qual o agente pensa enquanto executa o documento. Ela age em dois lugares. No corpo, guia a execução; no ponteiro, dispara a invocação.
- **Poda**: fonte única da verdade, relevância e o teste do no-op aplicado frase a frase, contra a **duplicação**, o **sedimento** e o **inchaço** (sprawl).

## Perguntas frequentes

**Para onde foi a `/writing-great-skills`?**
É esta skill, renomeada na v1.1. Os usuários já a apontavam para `AGENTS.md`, documentação, specs, tickets e prompts de execução muito antes da renomeação. Estrutura, palavras-guia e poda valem para qualquer texto que um agente leia. Não há alias. Reinstale com o nome novo.

**"Escrever para agentes": então quem escreve é o agente?**
É o contrário. Você é o autor; o agente é o leitor. É isso que torna a coisa difícil. Você escreve para um leitor que já leu de tudo, então explicação é desperdício e precisão é o trabalho inteiro.

**Não posso só pedir para o agente escrever por mim?**
Pode, e ele vai produzir algo prolixo. Sozinho, o modelo explica o que já sabe, e não aplica o teste do no-op nem procura uma palavra-guia por conta própria. Use a referência para revisar o rascunho. A maior parte do valor dela vem dessa passada de revisão.

**Pedi para um agente enxugar um documento e ele cortou a funcionalidade.**
Agentes mandados "enxugar" otimizam o tamanho, porque o tamanho é o que eles conseguem ver. O teste do no-op verifica comportamento, não estilo: apague a linha e pergunte se o comportamento do agente mudou. Quando uma frase reprovar, apague a frase inteira em vez de aparar palavras, e resolva uma discordância sobre ela rodando o documento, não discutindo.

**Como eu sei quando está pronto?**
Quando funciona e você não encontra mais duplicação, sedimento nem no-ops. Não há avaliação automatizada. Você confere rodando o documento à mão e usando o vocabulário dos modos de falha para diagnosticar problemas. Quando um documento se comporta mal, o mesmo vocabulário te ajuda a corrigir: dê nome ao modo de falha primeiro, depois corrija isso.

**Isto deveria ficar no `CLAUDE.md` ou em outro lugar?**
Pergunte qual carga você quer pagar. O `CLAUDE.md` é carregado em toda [session](https://www.aihero.dev/ai-coding-dictionary/session), incondicionalmente. Um material atrás de um ponteiro só custa a linha do próprio ponteiro até disparar. Qualquer coisa que se aplique a uma sessão em cada dez custa carga de contexto nas outras nove.

**Preciso reescrever meus documentos a cada modelo novo?**
Na maioria das vezes não, e ajustar demais a um modelo causa problemas próprios. Atualizar para um modelo novo costuma ser mais uma passada de no-ops, não uma reescrita.

**Minha skill só funciona exatamente na tarefa a partir da qual eu a criei.**
O método comum (fazer o trabalho uma vez e depois pedir ao agente que o transforme numa skill) se ajusta demais àquela execução, e os exemplos saem específicos demais. Guarde a execução como evidência e depois generalize de propósito: tire o que pertencia àquele repositório e àqueles arquivos e escreva para a classe de tarefa.

**Inglês não é a minha primeira língua. Eu perco a vantagem das palavras-guia?**
Não. Encontrar a palavra que empacota o máximo de comportamento no mínimo de [tokens](https://www.aihero.dev/ai-coding-dictionary/token) é um trabalho que a referência faz por você.

## Está funcionando se

- O documento fica mais curto à medida que fica melhor, e você se surpreende com o pouco que sobra.
- Você consegue apontar uma palavra-guia e vê-la mudar o comportamento do agente em mais de um lugar.
- Nada é dito duas vezes, de forma nenhuma. A duplicação é o sinal mais confiável de que um documento nunca foi testado.
- A referência de que só um ramo precisa fica atrás de um ponteiro, não no arquivo principal.

## Onde se encaixa

É uma referência avulsa para usar a qualquer hora. Ela vale para o conjunto inteiro, não para uma skill. Todas as skills daqui foram escritas com ela, e ela também cobre os documentos que as outras skills produzem (um `GLOSSARY.md` e seus ADRs, uma spec, um ticket) quando um agente precisa lê-los. A única skill que a chama diretamente é a [retro](../engineering/retro.md), que a carrega antes de propor qualquer arquivo de orientação ou skill. Quando não tiver certeza de qual skill ou fluxo serve para uma tarefa, a [ask-matt](../engineering/ask-matt.md) te orienta por todo o conjunto.
