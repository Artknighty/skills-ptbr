# Sabatina pela ferramenta nativa de perguntas do harness

As sessões de sabatina (`/grilling`, `/grill-me`, `/grill-with-docs` e a sabatina dentro de outras skills) fazem as perguntas como texto simples no chat. Pedidos para encaminhá-las pela interface nativa de perguntas de um harness (o `AskUserQuestion` do Claude Code, uma "question tool" do host, um modo de questionário estruturado ou em lote) estão fora do escopo.

## Por que isto está fora do escopo

As skills são texto neutro em relação ao harness. Elas rodam no Claude Code, Codex, Copilot, Cursor e em tudo onde o skills.sh instala, e cada harness tem uma ferramenta de perguntas diferente, ou nenhuma. Citar a ferramenta de um harness na skill significa ou um desvio específico de harness em cada skill de sabatina, ou uma skill que só funciona direito num lugar.

A interface de perguntas também muda a própria sabatina. Seletores estruturados empurram o modelo para perguntas de múltipla escolha com respostas prontas, que é o oposto do que a sabatina busca: perguntas abertas que você responde com as próprias palavras, um ramo da árvore de decisões por vez. Eu experimentei a interface do `AskUserQuestion` e não a quero nestas skills.

Se você prefere a ferramenta de perguntas do seu harness, diga isso no seu próprio `CLAUDE.md` / `AGENTS.md` ("na sabatina, pergunte via AskUserQuestion"). É uma preferência de uma linha, por usuário, e a skill compartilhada não precisa saber dela.

## Pedidos anteriores

- #19: "grill-me: not always using the question tool"
- #643: "Proposal: Use AskQuestion for structured input during grilling sessions"
- #840: "Use host's question tool for grilling sessions"
- #1107: "Grilling doesn't use Agent's native QA tool OOTB"
- #1152: "Proposal: experimental HTML questionnaire mode for batch grilling"
