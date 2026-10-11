# Skills do Matt Pocock (pt-BR)

Uma coleção de skills de agente (comandos de barra e comportamentos) carregadas pelo Claude Code. As skills são organizadas em buckets e consumidas pela configuração por repositório gerada pela `/setup-matt-pocock-skills`.

## Linguagem

**Issue tracker**:
A ferramenta que hospeda as issues de um repositório: GitHub Issues, Linear, uma convenção de markdown local em `.scratch/` ou algo parecido. Skills como `to-tickets`, `to-spec` e `triage` leem e escrevem nele.
_Evitar_: gerenciador de backlog, backend de backlog, hospedeiro de issues, rastreador

**Issue**:
Uma unidade de trabalho acompanhada dentro de um **Issue tracker**: um bug, uma tarefa, uma spec ou uma fatia produzida pela `to-tickets`.
_Evitar_: ticket (use só ao citar sistemas externos que os chamam assim, ou para um **Ticket de decisão**, veja abaixo)

**Ticket de decisão**:
Uma unidade da `wayfinder`: uma **Issue** filha de um `wayfinder:map` que guarda uma *pergunta* cuja resolução é uma decisão, não uma fatia de uma construção a executar. O qualificador **de decisão** é o que o distingue de um ticket de implementação; a `wayfinder` apresenta o termo e depois usa só "ticket".

**Papel de triagem**:
Uma label canônica da máquina de estados aplicada a uma **Issue** durante a triagem (ex.: `needs-triage`, `ready-for-agent`). Cada papel corresponde a uma string de label real no **Issue tracker** via `docs/agents/triage-labels.md`.

**Sabatina** (grilling):
Entrevista implacável conduzida pelo agente, em rodadas, até que toda a árvore de design esteja resolvida. É a tradução usada aqui para "grilling"; o nome da skill continua `grilling`.
_Evitar_: interrogatório, questionário (este último é o artefato da `to-questionnaire`)

**Seam**:
Mantido em inglês, como em Michael Feathers: o lugar onde vive a interface de um módulo, onde dá para alterar o comportamento sem editar ali. Veja a skill `codebase-design`.
_Evitar_: fronteira, costura

## Relações

- Um **Issue tracker** guarda muitas **Issues**
- Uma **Issue** carrega um **Papel de triagem** por vez
- Um **Ticket de decisão** é uma **Issue** (filha de um `wayfinder:map`)

## Ambiguidades sinalizadas

- "backlog" era usado tanto para a *ferramenta* que hospeda as issues quanto para o *conjunto de trabalho* dentro dela. Resolvido: a ferramenta é o **Issue tracker**; "backlog" não é mais usado como termo de domínio.
- "backend de backlog" / "gerenciador de backlog". Resolvido: unificados em **Issue tracker**.
