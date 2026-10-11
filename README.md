# Skills para engenheiros de verdade (pt-BR)

> **Tradução para português do Brasil** do repositório [mattpocock/skills](https://github.com/mattpocock/skills), de Matt Pocock, distribuído sob a licença MIT (veja [LICENSE](./LICENSE)). Os comandos (`/grill-me`, `/tdd`, `/to-spec` etc.), nomes de arquivo, labels e identificadores ficam em inglês, exatamente como no original; o texto das skills e os artefatos que elas geram (perguntas, specs, tickets, glossários, ADRs, relatórios) ficam em português. As convenções da tradução estão em [TRADUCAO.md](./TRADUCAO.md).
>
> Baseado na versão 1.3.1 do upstream.

As skills de agente que o Matt usa todo dia para fazer engenharia de verdade, não vibe coding.

Desenvolver aplicações reais é difícil. Abordagens como GSD, BMAD e Spec-Kit tentam ajudar assumindo o controle do processo. Mas, ao fazer isso, elas tiram o seu controle e tornam difícil resolver bugs no próprio processo.

Estas skills foram feitas para serem pequenas, fáceis de adaptar e combináveis. Funcionam com qualquer modelo. São baseadas em décadas de experiência em engenharia. Mexa nelas. Deixe-as do seu jeito. Divirta-se.

Para acompanhar as mudanças nas skills originais e as novas que o Matt criar, existe a newsletter dele (em inglês): [Sign Up To The Newsletter](https://www.aihero.dev/s/skills-newsletter).

## Instalação

Escolha **uma** forma por agente: instalar das duas maneiras deixa cada skill duplicada. E **não instale esta versão junto com a original em inglês**: as duas usam os mesmos nomes de skill (`grill-me`, `tdd`...), e o agente não teria como saber qual usar. Se você já tem a original instalada, desinstale-a antes.

Os exemplos abaixo supõem que você publicou este repositório no seu GitHub como `<seu-usuario>/skills-ptbr`. Troque pelo caminho real.

### 1. Pegue as skills

<details>
<summary><strong>Claude Code</strong> (via marketplace deste repositório)</summary>

```bash
claude plugin marketplace add <seu-usuario>/skills-ptbr
claude plugin install mattpocock-skills-ptbr@skills-ptbr
```

Para atualizar depois de mudar o repositório: `claude plugin marketplace update skills-ptbr`. Para testar localmente sem publicar, troque `<seu-usuario>/skills-ptbr` pelo caminho da pasta clonada (ex.: `./skills-ptbr`).

</details>

<details>
<summary><strong>Qualquer outro agente, ou arquivos editáveis</strong> (atualização manual)</summary>

```bash
npx skills@latest add <seu-usuario>/skills-ptbr -a <agente>  # cursor, opencode, codex, claude-code...; omita -a para escolher
```

Também funciona com um caminho local: `npx skills@latest add ./skills-ptbr`. Quando o instalador perguntar quais skills levar, inclua `setup-matt-pocock-skills`. Para atualizar, rode `npx skills@latest update`, e rode `add` de novo para pegar skills novas.

</details>

<details>
<summary><strong>Mantenedor local</strong> (links simbólicos, atualiza com <code>git pull</code>)</summary>

```bash
./scripts/link-skills.sh
```

Cria links em `~/.claude/skills` e `~/.agents/skills` apontando para este repositório.

</details>

### 2. Rode `/setup-matt-pocock-skills`

No seu agente, rode uma vez por repositório. Ele vai:

- Perguntar qual issue tracker você quer usar (GitHub, GitLab, arquivos locais ou qualquer outro que você descrever)
- Perguntar quais labels você aplica aos tickets na triagem (a `/triage` usa labels)
- Perguntar onde você quer salvar os documentos que forem criados

### 3. Pronto, pode começar.

## Por que estas skills existem

O Matt criou estas skills para corrigir modos de falha comuns que ele vê com o Claude Code, o Codex e outros agentes de código.

### #1: O agente não fez o que eu queria

> "Ninguém sabe exatamente o que quer."
>
> David Thomas & Andrew Hunt, [O Programador Pragmático](https://www.amazon.co.uk/Pragmatic-Programmer-Anniversary-Journey-Mastery/dp/B0833F1T3V)

**O problema**. O modo de falha mais comum no desenvolvimento de software é o desalinhamento. Você acha que o dev sabe o que você quer. Aí você vê o que ele construiu e percebe que ele não te entendeu nada.

Na era da IA é igual. Existe uma lacuna de comunicação entre você e o agente. A correção é uma **sessão de sabatina**: fazer o agente te fazer perguntas detalhadas sobre o que você está construindo.

**A correção** é usar:

- [`/grill-me`](./skills/productivity/grill-me/SKILL.md): para usos fora do código
- [`/grill-with-docs`](./skills/engineering/grill-with-docs/SKILL.md): o mesmo que [`/grill-me`](./skills/productivity/grill-me/SKILL.md), mas com mais vantagens (veja abaixo)

São as skills mais populares do repositório. Elas te ajudam a se alinhar com o agente antes de começar e a pensar a fundo na mudança que você está fazendo. Use _toda_ vez que quiser fazer uma mudança.

### #2: O agente é prolixo demais

> Com uma linguagem ubíqua, as conversas entre desenvolvedores e as expressões do código derivam todas do mesmo modelo de domínio.
>
> Eric Evans, [Domain-Driven Design](https://www.amazon.co.uk/Domain-Driven-Design-Tackling-Complexity-Software/dp/0321125215)

**O problema**: No início de um projeto, os devs e as pessoas para quem eles constroem o software (os especialistas de domínio) normalmente falam línguas diferentes.

O Matt sentiu a mesma tensão com os agentes. Os agentes costumam ser jogados num projeto e precisam decifrar o jargão no caminho. Então usam 20 palavras onde 1 bastaria.

**A correção** é uma linguagem compartilhada. É um documento que ajuda os agentes a decodificar o jargão usado no projeto.

<details>
<summary>
Exemplo
</summary>

Aqui está um [glossário](https://github.com/mattpocock/course-video-manager/blob/076a5a7a182db0fe1e62971dd7a68bcadf010f1c/CONTEXT.md) de exemplo (ainda chamado `CONTEXT.md` nesse commit fixado, de antes de as skills renomearem a convenção), do repositório `course-video-manager` do Matt. Qual é mais fácil de ler?

- **ANTES**: "Tem um problema quando uma aula dentro de uma seção de um curso se torna 'real' (ou seja, ganha um lugar no sistema de arquivos)"
- **DEPOIS**: "Tem um problema na cascata de materialização"

Essa concisão se paga sessão após sessão.

</details>

Isso está embutido na [`/grill-with-docs`](./skills/engineering/grill-with-docs/SKILL.md). É uma sessão de sabatina, mas que te ajuda a construir uma linguagem compartilhada com a IA e a documentar decisões difíceis de explicar em ADRs.

É difícil explicar o quanto isso é poderoso. Talvez seja a técnica mais legal deste repositório. Experimente e veja.

> [!TIP]
> Uma linguagem compartilhada tem muitos outros benefícios além de reduzir a prolixidade:
>
> - **Variáveis, funções e arquivos recebem nomes consistentes**, usando a linguagem compartilhada
> - Com isso, o **código fica mais fácil de navegar** para o agente
> - O agente também **gasta menos tokens pensando**, porque tem acesso a uma linguagem mais concisa

### #3: O código não funciona

> "Sempre dê passos pequenos e deliberados. A velocidade do feedback é o seu limite de velocidade. Nunca pegue uma tarefa grande demais."
>
> David Thomas & Andrew Hunt, [O Programador Pragmático](https://www.amazon.co.uk/Pragmatic-Programmer-Anniversary-Journey-Mastery/dp/B0833F1T3V)

**O problema**: Digamos que você e o agente estão alinhados sobre o que construir. O que acontece quando o agente _ainda assim_ produz porcaria?

É hora de olhar para os seus feedback loops. Sem feedback sobre como o código que ele produz realmente roda, o agente está voando às cegas.

**A correção**: Você precisa do pacote de sempre de feedback loops: tipos estáticos, acesso ao navegador e testes automatizados.

Para testes automatizados, um ciclo red-green-refactor é crítico. É quando o agente escreve primeiro um teste que falha e depois o faz passar. Isso dá ao agente um nível consistente de feedback que resulta em código muito melhor.

Existe uma **skill [`/tdd`](./skills/engineering/tdd/SKILL.md)** que você pode encaixar em qualquer projeto. Ela incentiva o red-green-refactor e dá ao agente bastante orientação sobre o que faz um teste bom ou ruim.

Para depuração, existe também a skill **[`/diagnosing-bugs`](./skills/engineering/diagnosing-bugs/SKILL.md)**, que embala as melhores práticas de depuração num ciclo disciplinado, com uma barreira em cada fase.

### #4: Construímos uma bola de lama

> "Invista no design do sistema _todos os dias_."
>
> Kent Beck, [Programação Extrema (XP) Explicada](https://www.amazon.co.uk/Extreme-Programming-Explained-Embrace-Change/dp/0321278658)

> "Os melhores módulos são profundos. Eles permitem acessar muita funcionalidade por meio de uma interface simples."
>
> John Ousterhout, [A Philosophy Of Software Design](https://www.amazon.co.uk/Philosophy-Software-Design-2nd/dp/173210221X)

**O problema**: A maioria dos apps construídos com agentes é complexa e difícil de mudar. Como os agentes aceleram radicalmente a escrita de código, eles também aceleram a entropia do software. Os códigos ficam mais complexos num ritmo sem precedentes.

**A correção** é uma abordagem radicalmente nova de desenvolvimento com IA: se importar com o design do código.

Isso está embutido em todas as camadas destas skills:

- A [`/to-spec`](./skills/engineering/to-spec/SKILL.md) te pergunta quais módulos você está mexendo antes de criar uma spec

E, crucialmente, a [`/improve-codebase-architecture`](./skills/engineering/improve-codebase-architecture/SKILL.md) varre um código em busca de oportunidades de aprofundamento e te entrega os candidatos. A recomendação é rodá-la no seu código a cada poucos dias. Ela é um levantamento, não um resgate: num código realmente antigo ela vai encontrar candidatos reais, mas não vai desembaraçar a lama por você.

### Resumo

Os fundamentos da engenharia de software importam mais do que nunca. Estas skills são o melhor esforço do Matt para condensar esses fundamentos em práticas repetíveis, para te ajudar a entregar os melhores apps da sua carreira. Divirta-se.

## Referência

As skills se dividem num eixo: quem pode invocá-las. Skills **invocadas pelo usuário** só são acessíveis quando você digita o nome (ex.: `/grill-me`); o trabalho delas é orquestrar. Skills **invocadas pelo modelo** podem ser invocadas por você _ou_ usadas automaticamente pelo agente quando a tarefa se encaixa; elas guardam a disciplina reutilizável. Uma skill invocada pelo usuário pode invocar skills invocadas pelo modelo, mas nunca outra invocada pelo usuário.

### Engenharia

Skills de uso diário para trabalhar com código.

**Invocadas pelo usuário**

- **[ask-matt](./skills/engineering/ask-matt/SKILL.md)**: Pergunte qual skill ou fluxo se encaixa na sua situação. Um roteador sobre as skills invocadas pelo usuário deste repositório.
- **[grill-with-docs](./skills/engineering/grill-with-docs/SKILL.md)**: Sessão de sabatina que também constrói o modelo de domínio do projeto, afiando a terminologia e atualizando `GLOSSARY.md` e ADRs no caminho.
- **[triage](./skills/engineering/triage/SKILL.md)**: Move issues por uma máquina de estados de papéis de triagem.
- **[improve-codebase-architecture](./skills/engineering/improve-codebase-architecture/SKILL.md)**: Varre um código em busca de oportunidades de aprofundamento, apresenta-as como um relatório HTML visual e depois sabatina a que você escolher.
- **[setup-matt-pocock-skills](./skills/engineering/setup-matt-pocock-skills/SKILL.md)**: Configura este repositório para as skills de engenharia (issue tracker, labels de triagem, estrutura dos documentos de domínio). Rode uma vez por repositório, antes de usar as outras skills de engenharia.
- **[to-spec](./skills/engineering/to-spec/SKILL.md)**: Transforma a conversa atual em uma spec e a publica no issue tracker. Sem entrevista, só sintetiza o que já foi discutido.
- **[to-tickets](./skills/engineering/to-tickets/SKILL.md)**: Quebra qualquer plano, spec ou conversa em um conjunto de tickets tracer-bullet, cada um declarando suas arestas de bloqueio, escritos como texto num arquivo local ou como links de bloqueio nativos num tracker real.
- **[implement](./skills/engineering/implement/SKILL.md)**: Constrói o trabalho descrito por uma spec ou conjunto de tickets, conduzindo `/tdd` em seams combinados de antemão e fechando com `/code-review` antes do commit.
- **[implement-spec](./skills/engineering/implement-spec/SKILL.md)**: Implementa uma spec inteira em um único branch de integração. Trabalha os tickets como um grafo de tarefas, rodando subagentes implementadores por toda a fronteira pronta para máxima concorrência, e fecha com `/code-review`.
- **[wayfinder](./skills/engineering/wayfinder/SKILL.md)**: Planeja um pedaço enorme de trabalho, mais do que uma sessão de agente comporta, como um mapa compartilhado de tickets de decisão no issue tracker, e os resolve um por vez até o caminho até o destino ficar claro.
- **[retro](./skills/engineering/retro/SKILL.md)**: Sugere melhorias no ambiente do agente de código (navegação, verificações automatizadas, padrões de código, arquivos de orientação, ferramentas) depois de uma sessão, das mais graves para as menos graves.

**Invocadas pelo modelo**

- **[prototype](./skills/engineering/prototype/SKILL.md)**: Constrói um protótipo descartável para responder uma pergunta de design: um único arquivo HTML compartilhável para perguntas de estado/lógica, ou várias variações de UI radicalmente diferentes, alternáveis numa única rota.
- **[diagnosing-bugs](./skills/engineering/diagnosing-bugs/SKILL.md)**: Ciclo disciplinado de diagnóstico para bugs difíceis e regressões de performance: monte um feedback loop que fica vermelho neste bug → minimize → levante hipóteses → instrumente → corrija → teste de regressão.
- **[research](./skills/engineering/research/SKILL.md)**: Investiga uma pergunta em fontes primárias de alta confiança e registra as descobertas como um arquivo Markdown com citações no repositório, rodando como agente em segundo plano.
- **[tdd](./skills/engineering/tdd/SKILL.md)**: Desenvolvimento guiado por testes com um ciclo red-green-refactor. Constrói funcionalidades ou corrige bugs um vertical slice por vez.
- **[domain-modeling](./skills/engineering/domain-modeling/SKILL.md)**: Constrói e afia ativamente o modelo de domínio de um projeto: questiona termos contra o glossário, testa com cenários de casos-limite e atualiza `GLOSSARY.md` e ADRs no caminho.
- **[codebase-design](./skills/engineering/codebase-design/SKILL.md)**: Disciplina e vocabulário compartilhados para projetar módulos profundos: muito comportamento atrás de uma interface pequena, num seam limpo, testável por essa interface.
- **[code-review](./skills/engineering/code-review/SKILL.md)**: Revisão em dois eixos do diff desde um ponto fixo: **Padrões** (segue os padrões de código do repositório, mais uma base de code smells de Fowler?) e **Spec** (implementa fielmente a issue/spec de origem?), rodando como subagentes paralelos para que um não polua o outro.
- **[pr](./skills/engineering/pr/SKILL.md)**: O formato que o corpo de um pull request deve ter: um resumo como o menor visual que deixa a mudança clara, evidência de antes/depois de que funciona e uma avaliação do risco do merge (porta de mão única ou de mão dupla, mais o blast radius).
- **[wizard](./skills/engineering/wizard/SKILL.md)**: Gera um assistente interativo em bash que conduz um humano por passos que só ele pode executar: provisionar infraestrutura, configurar credenciais ou secrets de CI, navegar por um painel de terceiros desconhecido ou rodar uma migração ou virada pontual.

### Produtividade

Ferramentas gerais de fluxo de trabalho, não específicas de código.

**Invocadas pelo usuário**

- **[grill-me](./skills/productivity/grill-me/SKILL.md)**: Seja sabatinado sem trégua sobre um plano ou design até que todos os ramos da árvore de design estejam resolvidos.
- **[handoff](./skills/productivity/handoff/SKILL.md)**: Compacta a conversa atual em um documento de handoff para que outro agente continue o trabalho.
- **[teach](./skills/productivity/teach/SKILL.md)**: Ensina ao usuário uma nova habilidade ou conceito ao longo de várias sessões, usando o diretório atual como um espaço de ensino com estado.
- **[to-questionnaire](./skills/productivity/to-questionnaire/SKILL.md)**: Transforma uma decisão que você não consegue tomar sozinho em um questionário Markdown para a única pessoa que consegue, preenchido de forma assíncrona ou junto, numa reunião. Ela te sabatina sobre o envio (para quem é, o que você precisa receber), não sobre o assunto.
- **[wait-what](./skills/productivity/wait-what/SKILL.md)**: Use no momento em que uma mensagem não fizer sentido. O agente explica de novo com o contexto que está faltando, em português simples, usando o vocabulário do seu `GLOSSARY.md`.

**Invocadas pelo modelo**

- **[grilling](./skills/productivity/grilling/SKILL.md)**: Sabatina o usuário sem trégua sobre um plano, decisão ou ideia até que todos os ramos da árvore de design estejam resolvidos. A primitiva de entrevista reutilizável por trás de `grill-me`, `grill-with-docs`, `triage`, `wayfinder` e `improve-codebase-architecture`.
- **[writing-for-agents](./skills/productivity/writing-for-agents/SKILL.md)**: Como escrever documentos para agentes: skills, AGENTS.md/CLAUDE.md e qualquer documento que um agente alcança por um ponteiro.
