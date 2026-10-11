---
name: implement-spec
description: "Implementa em código o resultado de /to-spec e /to-tickets."
disable-model-invocation: true
---

Você recebeu uma spec. Ela deve ter tickets associados, descrevendo como implementá-la.

O issue tracker já deve ter sido fornecido a você. Se não, diga ao usuário para rodar `/setup-matt-pocock-skills`.

O objetivo é a spec inteira implementada em um único **branch de integração**, com cada ticket resolvido do jeito que o issue tracker fecha trabalho.

Os tickets não são uma lista de passos. São um **grafo de tarefas** com relações de bloqueio entre eles. Isso significa que sempre existe uma **fronteira** de tickets prontos para serem pegos.

A comunicação com os subagentes deve ser enxuta. Comunique-se principalmente por **ponteiros de contexto**: para a spec, os tickets, as notas de pesquisa e os commits anteriores. Não duplique informação já disponível por ponteiros.

Os **subagentes implementadores** devem rodar em segundo plano sempre que possível, para máxima concorrência.

## Passos

1. Leia a spec e os tickets para entender o grafo de tarefas.

2. (opcional) Use um **subagente de exploração** para fazer qualquer exploração exigida pelos tickets: arquivos relevantes do código ou documentação externa. Garanta que o subagente de exploração possa salvar arquivos: ele deve salvar suas notas em markdown num diretório fora do repositório, acessível a todos os subagentes futuros. Isso deixa os **subagentes implementadores** focados em implementar, não em explorar.

3. Crie o branch de integração. Se o issue tracker fecha trabalho por meio de PRs, ou se o usuário pedir um, abra um draft PR depois do primeiro merge no passo 5 (um branch sem commits à frente do main não consegue abrir um), marcado como fechando a spec e os tickets.

4. Use **subagentes implementadores** para implementar cada ticket, cada um na própria worktree, no próprio branch. Cada subagente implementador:
   - confirma que a worktree dele parte do branch de integração antes de começar, e faz reset para ele se não partir;
   - chama a ferramenta Skill com `tdd` para construir o ticket;
   - faz merge da ponta do branch de integração no próprio branch antes de reportar que terminou

5. Quando um **subagente implementador** terminar, faça o merge do trabalho dele no branch de integração com um **subagente de merge**.

6. Se isso mudar a **fronteira** de tickets disponíveis, dispare mais **subagentes implementadores** para trabalhar nos novos tickets. Isso permite a máxima concorrência.

7. Quando todos os tickets estiverem concluídos, chame a ferramenta Skill com `code-review` sobre o branch de integração. Corrija todos os problemas levantados pela revisão em um único **subagente implementador**.

8. Se houver um draft PR, marque-o como pronto para revisão. Caso contrário, resolva cada ticket do jeito que o issue tracker fecha trabalho e informe o branch de integração.

9. Limpe todas as worktrees dos **subagentes implementadores**.
