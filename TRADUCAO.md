# Notas da tradução

Tradução para pt-BR de [mattpocock/skills](https://github.com/mattpocock/skills), feita a partir do commit `49dd158d1076134a641b33efb035946536778336` (2026-10-09, versão 1.3.1).

## O que está traduzido

Tudo. Isso inclui as 27 skills do plugin (`engineering/` e `productivity/`), as skills fora do plugin (`misc/` e `in-progress/`), as 28 páginas de `docs/`, a governança (`SCOPE.md`, `.out-of-scope/`, `.agents/`), o `README.md`, o `CLAUDE.md` (o `AGENTS.md` é um arquivo de uma linha apontando para ele; no original é um symlink, que o Windows não consegue extrair sem privilégio de administrador), o `GLOSSARY.md`, os manifests do plugin, e as mensagens e comentários de todos os scripts (`wizard/template.sh`, `hitl-loop.template.sh`, `block-dangerous-git.sh`, `link-skills.sh`, `dependency-cruiser.config.cjs`).

A `LICENSE` foi mantida no original de propósito, por ser texto jurídico. Os títulos de issues citados em "Pedidos anteriores" (em `.out-of-scope/`) também ficaram em inglês, porque são os títulos reais das issues no GitHub original.

Foram removidos `.changeset/`, `.github/`, `CHANGELOG.md`, `package.json`, `package-lock.json` e `scripts/sync-plugin-version.mjs`. São a maquinaria de release do upstream e não têm uso num fork pessoal.

Nas páginas de `docs/`, os links entre páginas apontam para os arquivos locais em português. Os links para o AI Coding Dictionary continuam apontando para o original em inglês, porque ele não tem tradução.

## O que fica em inglês

- **Nomes de skill e comandos**: `/grill-me`, `tdd`, `setup-matt-pocock-skills`... (o campo `name` do frontmatter não muda).
- **Nome da ferramenta**: as instruções dizem "Chame a ferramenta Skill com ..."; `Skill` é o nome real da ferramenta no harness.
- **Nomes de arquivo e diretório** que as skills leem ou geram: `SKILL.md`, `GLOSSARY.md`, `GLOSSARY-MAP.md`, `docs/adr/`, `docs/agents/`, `.scratch/`, `.out-of-scope/`, `MISSION.md`, `RESOURCES.md`, `NOTES.md`, `CODING_STANDARDS.md`, `map.md`, `spec.md`.
- **Identificadores de máquina**: labels (`needs-triage`, `ready-for-agent`, `wontfix`, `bug`, `enhancement`, `wayfinder:map`, `wayfinder:research`...), valores de `Status:` (`claimed`, `resolved`, `ready-for-agent`, `proposed`, `accepted`...), chaves de frontmatter, `display_name` dos `agents/openai.yaml`.
- **Código**: identificadores em exemplos de código continuam em inglês; comentários e strings de teste foram traduzidos.

## Termos técnicos: o critério

Fica em inglês o jargão que dev brasileiro fala em inglês no dia a dia. Fica em português o que tem tradução consagrada no Brasil. Traduzir de volta para o inglês algo como "banco de dados" deixaria o texto artificial, então essa segunda lista é intencional.

| Fica em inglês | Fica em português |
| --- | --- |
| feedback loop, loop, tight → "enxuto" só como adjetivo | refatoração, refatorar |
| seam, adapter, port, Ports & Adapters | módulo, interface, implementação |
| vertical slice, horizontal slicing, tracer bullet, expand–contract | máquina de estados, injeção de dependência |
| mock, stub, fake, fixture, snapshot | teste unitário, teste de integração, teste de regressão |
| red-green-refactor (com "vermelho/verde" para o estado do teste) | banco de dados, sistema de arquivos |
| bisect, typecheck, lint, guardrail, hook, pre-commit, CI | histórias de usuário, critérios de aceitação |
| commit, branch, merge, diff, PR, draft PR, worktree, stage | modelo de domínio, linguagem ubíqua |
| issue, ticket, spec, issue tracker, label, sub-issue, task list, database id | subagente, janela de contexto, ponteiro de contexto |
| blast radius, trade-off, task runner, headers, payload, endpoint | módulo profundo / raso (com "deep / shallow module" no glossário) |
| handoff, harness, prompt, token, smart zone, AFK, HITL | alavancagem, localidade, profundidade (com o termo em inglês no glossário) |
| progressive disclosure, no-op, sprawl (glosado como "inchaço") | carga de contexto, carga cognitiva, palavra-guia |
| nomes dos code smells do Fowler (Feature Envy, Shotgun Surgery...), com a tradução entre parênteses | sabatina / sabatinar (para "grilling", que é o conceito da skill, não jargão técnico) |

## Vocabulário fixo das skills

As skills apontam umas para as outras por estas palavras, então elas precisam ser sempre as mesmas.

| Original | Tradução |
| --- | --- |
| round / frontier / design tree | rodada / fronteira / árvore de design |
| blocking edges / Blocked by | arestas de bloqueio / Bloqueado por |
| claim (a ticket) | assumir (o ticket); o valor de `Status:` continua `claimed` |
| triage role / agent brief | papel de triagem / briefing de agente |
| user-invoked / model-invoked | invocada pelo usuário / invocada pelo modelo |
| fog of war | névoa de guerra (neblina) |
| Destination / Notes / Decisions so far / Not yet specified / Out of scope | Destino / Notas / Decisões até aqui / Ainda não especificado / Fora do escopo |
| Wayfinding operations | Operações de wayfinding |
| `## Agent skills` (bloco no CLAUDE.md) | `## Skills de agente` |
| Standards / Spec (eixos da code-review) | Padrões / Spec |
| Summary / Evidence / Merge Danger / Door | Resumo / Evidência / Risco do merge / Porta |
| Strong / Worth exploring / Speculative | Forte / Vale explorar / Especulativa |
| What it does / When to reach for it / Prerequisites / Common questions / It's working if / Where it fits | O que faz / Quando usar / Pré-requisitos / Perguntas frequentes / Está funcionando se / Onde se encaixa |

## Adaptações além da tradução literal

- `setup-matt-pocock-skills`: instrução explícita para gerar os `docs/agents/*.md` e o bloco do `CLAUDE.md` em português, e para reconhecer (e substituir) um bloco `## Agent skills` deixado pela versão em inglês.
- `wizard`: instrução para escrever em português os textos exibidos ao humano; o `template.sh` tem a interface traduzida e o `confirm` aceita `s` ou `y`.
- `wait-what`: "plain English / ASD-STE100" virou "português simples e direto, no espírito do ASD-STE100".
- `grilling`, `tdd`, `diagnosing-bugs`, `code-review`, `prototype`: gatilhos da `description` em português, mantendo os gatilhos em inglês mais comuns ("grill", "TDD", "debug this").
- Plugin renomeado para `mattpocock-skills-ptbr` no marketplace `skills-ptbr`, para não colidir com o original.
- `GLOSSARY.md`: o exemplo `ready-for-afk` do original foi corrigido para `ready-for-agent`, a label que existe de fato.
- Todas as `description` do frontmatter com dois-pontos ficaram entre aspas (YAML inválido sem elas).
- Em quatro páginas de `docs/` (`diagnosing-bugs`, `setup-matt-pocock-skills`, `tdd`, `triage`), o texto original descreve um comportamento que o `SKILL.md` atual já mudou. Nesses pontos há uma "Nota da tradução" indicando a diferença, em vez de repetir uma informação desatualizada. Em `domain-modeling`, uma pergunta que ficou ilegível no original por causa de uma substituição automática (`GLOSSARY.md` vs `GLOSSARY.md`) foi reescrita com o sentido da discussão.
- A mensagem de bloqueio do `block-dangerous-git.sh` passou a começar com `BLOQUEADO:` (o `SKILL.md` foi ajustado junto).
- Os exemplos usam nomes brasileiros quando são texto (Pedidos, Faturamento, PSE, "cancelamento"); identificadores dentro de código continuam em inglês.

## Sincronizando com o original

```bash
git remote add upstream https://github.com/mattpocock/skills.git
git fetch upstream
git diff 49dd158d1076134a641b33efb035946536778336 upstream/main --stat -- skills docs .agents .out-of-scope README.md SCOPE.md GLOSSARY.md CLAUDE.md
```

O diff mostra quais arquivos mudaram no original desde a base desta tradução. Retraduza só esses e atualize o commit base no topo deste arquivo. Não faça merge direto: ele traria o texto em inglês por cima.
