# Engenharia

Skills que uso todo dia para trabalhar com código.

## Invocadas pelo usuário

Acessíveis só quando você digita o nome (Claude Code: `disable-model-invocation: true`; Codex: `policy.allow_implicit_invocation: false` em `agents/openai.yaml`).

- **[ask-matt](./ask-matt/SKILL.md)**: Pergunte qual skill ou fluxo se encaixa na sua situação. Um roteador sobre as skills invocadas pelo usuário deste repositório.
- **[grill-with-docs](./grill-with-docs/SKILL.md)**: Sessão de sabatina que também constrói o modelo de domínio do projeto, afiando a terminologia e atualizando `GLOSSARY.md` e ADRs no caminho.
- **[triage](./triage/SKILL.md)**: Move issues por uma máquina de estados de papéis de triagem.
- **[improve-codebase-architecture](./improve-codebase-architecture/SKILL.md)**: Varre um código em busca de oportunidades de aprofundamento, apresenta-as como um relatório HTML visual e depois sabatina a que você escolher.
- **[setup-matt-pocock-skills](./setup-matt-pocock-skills/SKILL.md)**: Configura este repositório para as skills de engenharia (issue tracker, labels de triagem, estrutura dos documentos de domínio). Rode uma vez por repositório.
- **[to-spec](./to-spec/SKILL.md)**: Transforma a conversa atual em uma spec e a publica no issue tracker.
- **[to-tickets](./to-tickets/SKILL.md)**: Quebra qualquer plano, spec ou conversa em um conjunto de tickets tracer-bullet, cada um declarando suas arestas de bloqueio, seja como texto num arquivo local, seja como links de bloqueio nativos num tracker real.
- **[implement](./implement/SKILL.md)**: Constrói o trabalho descrito por uma spec ou conjunto de tickets, conduzindo `/tdd` em seams combinados de antemão e fechando com `/code-review` antes do commit.
- **[implement-spec](./implement-spec/SKILL.md)**: Implementa uma spec inteira em um único branch de integração. Trabalha os tickets como um grafo de tarefas, rodando subagentes implementadores por toda a fronteira pronta para máxima concorrência, e fecha com `/code-review`.
- **[wayfinder](./wayfinder/SKILL.md)**: Planeja um pedaço enorme de trabalho (mais do que uma sessão de agente comporta) como um mapa compartilhado de tickets de decisão no issue tracker, resolvidos um por vez até que o caminho até o destino esteja claro.
- **[retro](./retro/SKILL.md)**: Sugere melhorias no ambiente do agente de código (navegação, verificações automatizadas, padrões de código, arquivos de orientação, ferramentas) depois de uma sessão, das mais graves para as menos graves.

## Invocadas pelo modelo

Acessíveis pelo modelo ou pelo usuário (descrições ricas em gatilhos, para o modelo saber quando usá-las).

- **[prototype](./prototype/SKILL.md)**: Constrói um protótipo descartável para responder uma pergunta de design: um único arquivo HTML compartilhável para estado/lógica, ou várias variações de UI alternáveis.

- **[diagnosing-bugs](./diagnosing-bugs/SKILL.md)**: Ciclo disciplinado de diagnóstico para bugs difíceis e regressões de performance: monte um feedback loop que fica vermelho neste bug → minimize → levante hipóteses → instrumente → corrija → teste de regressão.
- **[research](./research/SKILL.md)**: Investiga uma pergunta em fontes primárias de alta confiança e registra as descobertas como um arquivo Markdown com citações no repositório, rodando como agente em segundo plano.
- **[tdd](./tdd/SKILL.md)**: Desenvolvimento guiado por testes com um ciclo red-green-refactor. Constrói funcionalidades ou corrige bugs um vertical slice por vez.
- **[domain-modeling](./domain-modeling/SKILL.md)**: Constrói e afia ativamente o modelo de domínio de um projeto, questionando termos, testando com cenários e atualizando `GLOSSARY.md` e ADRs no caminho.
- **[codebase-design](./codebase-design/SKILL.md)**: Disciplina e vocabulário compartilhados para projetar módulos profundos: interfaces pequenas, seams limpos, testáveis pela interface.
- **[code-review](./code-review/SKILL.md)**: Revisão em dois eixos do diff desde um ponto fixo: **Padrões** (segue os padrões de código do repositório, mais uma base de code smells de Fowler?) e **Spec** (implementa fielmente a issue/spec de origem?), rodando como subagentes paralelos.
- **[pr](./pr/SKILL.md)**: O formato que o corpo de um pull request deve ter: um resumo como o menor visual que deixa a mudança clara, evidência de antes/depois de que funciona e uma avaliação do risco do merge (porta de mão única ou de mão dupla, mais o blast radius).
- **[wizard](./wizard/SKILL.md)**: Gera um assistente interativo em bash que conduz um humano por passos que só ele pode executar: provisionar infraestrutura, configurar credenciais ou secrets de CI, navegar por um painel de terceiros desconhecido ou rodar uma migração ou virada pontual.
