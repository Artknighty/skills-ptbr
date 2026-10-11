# Mecânica das skills

O ramo específico de skills de [`writing-for-agents`](SKILL.md): o que muda quando o documento é uma skill (frontmatter, a escolha de invocação e as skills roteadoras). Todo o resto sobre como escrevê-la é a referência universal em `SKILL.md`.

## Invocação

Duas escolhas, trocando uma carga pela outra:

- Uma skill **invocada pelo modelo** mantém uma `description`, para que o agente possa dispará-la por conta própria e outras skills possam alcançá-la. Você ainda pode digitar o nome dela: a invocação pelo modelo sempre _inclui_ o acesso pelo usuário; uma descrição só acrescenta a descoberta pelo agente, nunca remove o acesso humano. A descrição é o ponteiro de contexto de nível mais alto da skill, obrigado a ficar carregado o tempo todo: carga de contexto permanente em troca de descobribilidade. Uma skill invocada pelo modelo cujo conteúdo é todo referência também serve de lar para referência compartilhada: outra skill pode invocá-la, então a referência de que várias skills precisam vive num lugar só. Mecânica: omita `disable-model-invocation` e escreva uma descrição voltada ao modelo carregando os ramos de gatilho (as regras de escrita de ponteiros do `SKILL.md` valem por inteiro).
- Uma skill **invocada pelo usuário** tira a descrição do alcance do agente: só o humano digitando o nome dela consegue invocá-la, e nenhuma outra skill consegue. Zero carga de contexto, mas ela gasta carga cognitiva: você é o índice que precisa lembrar que ela existe. Mecânica: defina `disable-model-invocation: true`; a `description` passa a ser voltada a humanos: um resumo de uma linha, sem listas de gatilho.

Escolha a invocação pelo modelo só quando o agente precisar alcançar a skill sozinho, ou outra skill precisar. Se ela só dispara à mão, faça-a invocada pelo usuário e não pague carga de contexto.

Referência compartilhada de que duas skills invocadas pelo usuário precisam não pode viver em nenhuma das duas: sem descrições, nenhuma consegue disparar a outra. Empurre-a para um arquivo comum fora do sistema de skills: referência externa para a qual qualquer skill pode apontar.

## Dividindo por invocação

O corte por invocação na divisão (o corte por sequência está em `SKILL.md`): separe uma skill invocada pelo modelo quando você tiver uma palavra-guia distinta que deva dispará-la sozinha (uma palavra de gatilho que você realmente usa nos seus prompts), ou quando outra skill precisar alcançá-la. Você paga carga de contexto pela nova descrição sempre carregada, então esse alcance independente tem de valer a pena.

## Skills roteadoras

Quando as skills invocadas pelo usuário se multiplicam além do que você consegue lembrar, essa carga cognitiva acumulada é curada por uma **skill roteadora**: uma skill invocada pelo usuário que nomeia as outras e quando recorrer a cada uma, para que o humano tenha uma skill para lembrar em vez de muitas. Ela só pode sugerir, nunca dispará-las: skills invocadas pelo usuário não têm descrição, então nada além do humano consegue alcançá-las.
