# In Progress

Beta. Estas skills são públicas de propósito: experimente e conte o que quebra. Elas ficam fora do plugin e do README da raiz até se formarem num bucket estável, não têm páginas de documentação e podem mudar ou sumir sem aviso.

O plugin não traz estas skills. Instale uma diretamente:

```bash
npx skills@latest add <seu-usuario>/skills-ptbr --skill=<nome>
```

- **[loop-me](./loop-me/SKILL.md)**: Sabatine-se até chegar a specs implementáveis dos workflows que você quer construir, ao longo de várias sessões, usando o diretório atual como workspace com estado. Invocada pelo usuário.
- **[writing-beats](./writing-beats/SKILL.md)**: Dá forma a um artigo como uma jornada de beats, no estilo "escolha sua aventura". Escolha um beat inicial, escreva só esse beat e depois mude de direção para o próximo, até o artigo chegar a um fim natural.
- **[writing-fragments](./writing-fragments/SKILL.md)**: Sessão de sabatina que extrai de você fragmentos (pedaços heterogêneos de texto) e os acrescenta a um único documento como matéria-prima para um artigo futuro.
- **[writing-shape](./writing-shape/SKILL.md)**: Pega um arquivo markdown de matéria-prima e lhe dá a forma de um artigo, parágrafo por parágrafo, discutindo as escolhas de formato a cada passo.
- **[claude-handoff](./claude-handoff/SKILL.md)**: Passa a conversa atual para um agente novo em segundo plano, que começa o trabalho na hora, alimentado com um resumo de handoff via `claude --bg`. Invocada pelo usuário.
- **[setup-ts-deep-modules](./setup-ts-deep-modules/SKILL.md)**: Configura o dependency-cruiser num repositório TypeScript para que cada pacote seja um módulo profundo (deep module): implementação escondida em subpastas, acessível só pelos arquivos de entry point, com testes exercitando o pacote por eles. Invocada pelo usuário.
