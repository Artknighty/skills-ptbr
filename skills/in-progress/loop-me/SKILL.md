---
name: loop-me
description: Me sabatine sobre as specs dos workflows que quero construir, dentro deste workspace.
disable-model-invocation: true
argument-hint: "Um workflow para projetar, ou nada para sair procurando um"
---

Conduza uma sessão de `/grilling` com estado cuja única saída são specs de **workflow**. Use a disciplina da sabatina (implacável, uma rodada de perguntas por vez, uma resposta recomendada em cada uma) mirando o vocabulário e o objetivo abaixo. Crie, edite e apague specs conforme a sabatina resolve as coisas.

## A lente do loop

Um **loop** é um padrão recorrente na vida do usuário: a carreira, a semana, a manhã, uma única atividade repetida. Enxergar a vida como loops dentro de loops revela o quanto as atividades são previsíveis, e é isso que faz valer a pena **delegá-las**. Use a lente para encontrar loops que valham uma spec, e proponha loops que o usuário ainda não percebeu.

Um **workflow** é a spec de um loop, tornada real. Você roda um workflow sobre um loop: o loop é a instância dele em execução. Os workflows vivem em `workflows/*.md` e são a fonte da verdade.

## Vocabulário

Uma linguagem compartilhada, usada só quando um workflow pedir: nunca um checklist. **Não imponha nada estrutural**: um workflow não precisa de IA, de checkpoint nem de agendamento, a menos que a sabatina mostre que precisa.

- **Trigger**: o que dispara cada execução, um **evento** (um e-mail novo, uma issue nova) ou um **agendamento** (toda manhã). Disparar por evento costuma ser mais eficiente.
- **Checkpoint**: um ponto de human in the loop em que o usuário é chamado a verificar ou decidir. Alguns workflows não têm nenhum e rodam de forma autônoma; alguns nem usam IA.
- **Empurre para a direita**: adie o checkpoint ao máximo. Faça o máximo de trabalho antes de envolver o humano, para que ele seja chamado uma vez, tarde, com tudo preparado.
- **Brief**: o que um checkpoint apresenta, um resumo enxuto e pronto para decisão (o que foi produzido, por quê e um link para o próprio asset), nunca a saída bruta. O usuário lê um brief, não um rascunho. A velocidade da revisão é imperativa.

## Definição de pronto

Uma spec de workflow está pronta quando um agente implementador conseguiria construí-la sem fazer uma única pergunta. Sabatine até lá; nada está pronto enquanto restar uma pergunta.

## O workspace

- `workflows/*.md`: uma spec por workflow.
- `NOTES.md`: notas brutas sobre o mundo do usuário, as ferramentas que ele usa, os canais que ele processa e a terminologia própria dele para ambos. Quando estiver vazio ou ralo, entreviste-o sobre o mundo dele antes de especificar qualquer coisa. Afie termos vagos em termos canônicos conforme aparecem, e registre-os aqui.
