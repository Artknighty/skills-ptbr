---
name: grilling
description: Sabatina o usuário sem trégua sobre um plano, decisão ou ideia. Use quando o usuário quiser pôr o próprio raciocínio à prova, ou usar qualquer expressão de gatilho como "me sabatine", "sabatina", "grill" ou "grill me".
---

Entreviste o usuário sem trégua até chegarem a um entendimento compartilhado. Mapeie isso como uma **árvore de design**: cada decisão se ramifica nas decisões que dependem dela.

Percorra a árvore em **rodadas**. A **fronteira** é toda decisão cujos pré-requisitos já estão resolvidos: as perguntas que você pode fazer _agora_ sem chutar respostas que ainda não ouviu. Faça a fronteira inteira em uma rodada: numere cada pergunta e dê a sua resposta recomendada. Depois espere as respostas do usuário antes da próxima rodada.

Formate uma rodada assim:

```
❓ **P1** - **<título da pergunta>**: <corpo da pergunta, pode ter vários parágrafos, incluindo múltipla escolha>

➡️ <sua resposta recomendada>

---

❓ **P2** - **<título da pergunta>**: <corpo da pergunta, pode ter vários parágrafos, incluindo múltipla escolha>

➡️ <sua resposta recomendada>
```

Formule cada pergunta de modo que "sim" aceite a sua resposta recomendada.

Cada rodada respondida pelo usuário remodela a árvore: decisões resolvidas empurram a fronteira para fora e destravam perguntas que dependiam delas. Recalcule a fronteira e faça a próxima rodada. Uma pergunta cuja resposta depende de outra pergunta ainda aberta nesta rodada pertence a uma rodada _posterior_, não a esta.

Descobrir _fatos_ é trabalho seu, nunca do usuário. Quando uma pergunta da fronteira precisar de um fato do ambiente (sistema de arquivos, ferramentas etc.), despache um subagente para encontrá-lo; não pergunte ao usuário nada que você mesmo poderia consultar. Não fique bloqueado por isso: uma exploração em andamento é um pré-requisito não resolvido, então só as perguntas que dependem dela esperam o subagente reportar; faça o resto da fronteira agora. As _decisões_ são do usuário: apresente cada uma a ele e espere.

A sessão termina quando a fronteira está vazia: todos os ramos da árvore de design visitados, nada assumido em silêncio. Não aja com base nela até que o usuário confirme que vocês chegaram a um entendimento compartilhado.
