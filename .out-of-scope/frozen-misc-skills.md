# Mudanças nas skills de `misc/`

As skills de `skills/misc/` (`git-guardrails-claude-code`, `migrate-to-shoehorn`, `scaffold-exercises`, `setup-pre-commit` e o que mais cair lá) estão congeladas. Relatos de bug, pedidos de funcionalidade e PRs sobre elas são fechados.

## Por que isto está fora do escopo

`misc/` é para onde vão as skills que eu mantenho, mas raramente uso. Elas não são promovidas: não vão no plugin do Claude Code, não têm página de documentação e eu não as rodo no dia a dia, então não consigo dizer se uma correção está certa nem perceber quando uma correção quebra outra coisa. Mantê-las no mesmo nível das skills promovidas custaria o mesmo que uma skill promovida, por uma fração do uso.

Elas ficam no repositório, sem manutenção, porque ainda funcionam do jeito que estão para algumas pessoas. Se uma não funcionar para você, instale-a com o skills.sh e corrija a sua cópia: os arquivos são seus para editar.

Se uma skill de `misc/` voltar a ser promovida para `engineering/` ou `productivity/` no futuro, ela volta ao escopo a partir daí.

## Pedidos anteriores

- #14: "Potential typo in setup-pre-commit/SKILL.md"
- #301: "`block-dangerous-git.sh` is bypassed by any git global option (e.g. `git -C <dir> push`)"
- #465: "git-guardrails-claude-code documentation is missing benefits over built in Claude code deny rules"
- #898: "git-guardrails-claude-code: hook fails open without jq and misses common git spellings"
