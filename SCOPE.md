# Escopo

> Este arquivo descreve a política de contribuição do repositório original, [mattpocock/skills](https://github.com/mattpocock/skills), em primeira pessoa do autor. Num fork pessoal ele vale como referência de como o catálogo é curado.

Este repositório é o conjunto de skills que eu uso todo dia. Ele é curado: ideias são bem-vindas, e cada uma é julgada pela régua abaixo. As issues servem para acompanhar mudanças nas skills. Perguntas e discussões vão para o [GitHub Discussions](https://github.com/mattpocock/skills/discussions).

## A régua

Uma issue de ideia ou feedback só continua aberta se passar nas **duas** partes:

1. **Falha observada.** Ela descreve algo que deu errado numa sessão real: o que você rodou, o que a skill fez, o que você esperava. Uma melhoria hipotética ("seria melhor se...") não passa nesta parte.
2. **Combina com a filosofia.** Ela não corresponde a nada em [`.out-of-scope/`](./.out-of-scope/) nem a uma rejeição anterior, e não é uma opção de configuração, um desvio específico de harness ou um ajuste para servir ao fluxo de uma pessoa só. Essas coisas pertencem ao seu próprio `CLAUDE.md` / `AGENTS.md`, ou a um fork (o skills.sh te dá uma cópia editável).

O tamanho não importa: uma correção de uma palavra e uma reescrita enfrentam a mesma régua. Reações e comentários de +1 não contam.

## Por bucket

- **`engineering/`, `productivity/`, `in-progress/`**: a régua acima.
- **`misc/`**: congelado e sem manutenção. Toda issue é fechada. Veja [`frozen-misc-skills.md`](./.out-of-scope/frozen-misc-skills.md).
- **Skills novas**: propostas e contribuições são fechadas. Se o comportamento dá para compor a partir de skills existentes, ele não ganha uma nova. Veja [`new-skills.md`](./.out-of-scope/new-skills.md).

## Já decidido

Cada arquivo em [`.out-of-scope/`](./.out-of-scope/) registra um conceito rejeitado e o porquê. Leia-os antes de abrir uma issue:

- [`frozen-misc-skills.md`](./.out-of-scope/frozen-misc-skills.md)
- [`harness-name-collisions.md`](./.out-of-scope/harness-name-collisions.md)
- [`mainstream-issue-trackers-only.md`](./.out-of-scope/mainstream-issue-trackers-only.md)
- [`native-question-tool.md`](./.out-of-scope/native-question-tool.md)
- [`new-skills.md`](./.out-of-scope/new-skills.md)
- [`question-limits.md`](./.out-of-scope/question-limits.md)
- [`setup-skill-verify-mode.md`](./.out-of-scope/setup-skill-verify-mode.md)
- [`subagent-recursion.md`](./.out-of-scope/subagent-recursion.md)

## Issues pouco claras

Uma issue que não dá para julgar pela régua recebe uma rodada de perguntas e a label `needs-info`. Sem resposta de quem relatou em 14 dias, ela é fechada. Rejeições são fechadas como "not planned".
