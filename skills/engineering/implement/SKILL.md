---
name: implement
description: "Implementa um trabalho com base em uma spec ou em um conjunto de tickets."
disable-model-invocation: true
---

Implemente o trabalho descrito pelo usuário na spec ou nos tickets.

Se o usuário passar uma referência de ticket, busque-o no issue tracker e diga o título dele antes de começar. Se a referência for ambígua, pergunte.

Chame a ferramenta Skill com "tdd" sempre que possível, nos seams combinados de antemão.

Rode o typecheck com frequência, arquivos de teste individuais com frequência e a suíte de testes completa uma vez, no final.

Ao terminar, chame a ferramenta Skill com "code-review" para revisar o trabalho.

Faça commit do seu trabalho no branch atual.
