# Proteções contra subagentes invocando skills recursivamente

As skills não adicionam proteções contra subagentes que invocam skills recursivamente ou disparam agentes aninhados (um subagente da `/code-review` invocando de novo a `/code-review`, um agente da `/research` disparando outro agente). Pedidos para adicionar instruções de agente-folha, limites de profundidade ou linhas de "não invoque esta skill" estão fora do escopo.

## Por que isto está fora do escopo

Quem deve impedir loops infinitos de subagentes é o harness, não as skills. O harness decide quais ferramentas e skills um subagente alcança e quão fundo o aninhamento pode ir, então um limite definido lá vale para todas as skills de uma vez. Uma proteção escrita no texto de uma skill cobre só aquela skill, custa tokens a cada execução e ainda depende de o modelo escolher obedecer.

Se um subagente entrar em recursão ou se ramificar sem limite, reporte isso ao harness.

## Pedidos anteriores

- #530: "research skill: spawned background agent can recursively re-spawn another agent (uncontrolled nesting)"
- #573: "code-review sub-agents recursively invoke /code-review and fan out" (PR #1186, "code-review: make the Standards and Spec sub-agents leaf reviewers", fechado)
