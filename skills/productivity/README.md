# Produtividade

Ferramentas gerais de fluxo de trabalho, não específicas de código.

## Invocadas pelo usuário

Acessíveis só quando você digita o nome (Claude Code: `disable-model-invocation: true`; Codex: `policy.allow_implicit_invocation: false` em `agents/openai.yaml`).

- **[grill-me](./grill-me/SKILL.md)**: Seja sabatinado sem trégua sobre um plano ou design até que todos os ramos da árvore de design estejam resolvidos.
- **[handoff](./handoff/SKILL.md)**: Compacta a conversa atual em um documento de handoff para que outro agente continue o trabalho.
- **[teach](./teach/SKILL.md)**: Ensina ao usuário uma nova habilidade ou conceito ao longo de várias sessões, usando o diretório atual como um espaço de ensino com estado.
- **[to-questionnaire](./to-questionnaire/SKILL.md)**: Transforma uma decisão que você não consegue tomar sozinho em um questionário Markdown para a única pessoa que consegue (preenchido de forma assíncrona ou junto, numa reunião).
- **[wait-what](./wait-what/SKILL.md)**: Use no momento em que uma mensagem não fizer sentido. O agente explica de novo com o contexto que está faltando, em português simples, usando o vocabulário do seu `GLOSSARY.md`.

## Invocadas pelo modelo

Acessíveis pelo modelo ou pelo usuário (descrições ricas em gatilhos, para o modelo saber quando usá-las).

- **[grilling](./grilling/SKILL.md)**: Sabatina o usuário sem trégua sobre um plano, decisão ou ideia até que todos os ramos da árvore de design estejam resolvidos.
- **[writing-for-agents](./writing-for-agents/SKILL.md)**: Como escrever documentos para agentes: skills, AGENTS.md/CLAUDE.md e qualquer documento que um agente alcança por um ponteiro.
