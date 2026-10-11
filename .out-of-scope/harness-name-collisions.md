# Renomear skills para fugir de comandos nativos do harness

Os nomes das skills não mudam porque um harness traz um comando ou skill nativo com o mesmo nome (`/prototype`, `/research`, `/code-review` e assim por diante). Pedidos para renomear uma skill, ou adicionar um alias, para evitar uma colisão estão fora do escopo.

## Por que isto está fora do escopo

Os harnesses adicionam comandos nativos o tempo todo, e cada harness escolhe os próprios nomes. Renomear toda vez que um deles cair num nome que já usamos significaria correr atrás de um alvo móvel entre Claude Code, Copilot, Devin e o resto, quebrando a memória muscular de todo usuário e todas as referências cruzadas entre skills a cada vez.

Como um harness resolve duas coisas com o mesmo nome é comportamento do harness, não da skill. O texto da skill está correto de qualquer forma.

A saída é a invocação com namespace. O plugin do Claude Code expõe cada skill sob o nome do plugin, então você sempre consegue chegar à nossa explicitamente:

```
/mattpocock-skills-ptbr:research
/mattpocock-skills-ptbr:code-review
```

(No original em inglês, o namespace é `mattpocock-skills`.)

Se você instalou com o skills.sh, os arquivos são seus: renomeie a pasta e o campo `name:` na sua cópia.

Se um harness não te der nenhum jeito de chegar a uma skill com namespace ou renomeada, reporte isso ao harness.

## Pedidos anteriores

- #423: "/code-review shadows Claude Code own review skill"
- #483: "/code-review name clash with Claude Code built-in"
- #857: "Rename the research skill to avoid conflict with Copilot's built-in /research command"
- #1019: "Shorthand `/prototype` conflicts with hidden new Claude Code built-in skill `/prototype`"
- #1037: "Skill name overlap with devin cli inbuilt commands"
