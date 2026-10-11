# Issue tracker: GitHub

As issues e specs deste repositório vivem como issues do GitHub. Use a CLI `gh` para todas as operações.

## Convenções

- **Criar uma issue**: `gh issue create --title "..." --body "..."`. Use um heredoc para corpos com várias linhas.
- **Ler uma issue**: `gh issue view <número> --json number,title,body,labels,comments`.
- **Listar issues**: `gh issue list --state open --json number,title,body,labels,comments --jq '[.[] | {number, title, body, labels: [.labels[].name], comments: [.comments[].body]}]'` com os filtros `--label` e `--state` adequados.
- **Tornar uma issue sub-issue de uma issue mãe**: `gh issue create --parent <mãe> ...`, ou `gh issue edit <mãe> --add-sub-issue <filha>` depois (`gh` 2.94+). Com `gh` mais antigo: `gh api --method POST repos/<dono>/<repo>/issues/<mãe>/sub_issues -F sub_issue_id=<database-id-da-filha>` (database id, como em **Bloqueio** abaixo). Sem sub-issues, coloque `Parte de #<mãe>` no topo do corpo da filha.
- **Comentar numa issue**: `gh issue comment <número> --body "..."`
- **Aplicar / remover labels**: `gh issue edit <número> --add-label "..."` / `--remove-label "..."`
- **Fechar**: `gh issue close <número> --comment "..."`

Deduza o repositório a partir de `git remote -v`; o `gh` faz isso automaticamente quando roda dentro de um clone.

## Pull requests como canal de triagem

**PRs como canal de pedidos: não.** _(Mude para `sim` se este repositório trata PRs externos como pedidos de funcionalidade; a `/triage` lê esta flag.)_

Quando estiver `sim`, os PRs passam pelas mesmas labels e estados que as issues, usando os equivalentes `gh pr`:

- **Ler um PR**: `gh pr view <número> --comments` e `gh pr diff <número>` para o diff.
- **Listar PRs externos para triagem**: `gh api --paginate 'repos/{owner}/{repo}/pulls?state=open' --jq '.[] | select(.author_association | IN("OWNER","MEMBER","COLLABORATOR") | not) | {number, title, author: .user.login, author_association, labels: [.labels[].name]}'`.
- **Comentar / rotular / fechar**: `gh pr comment`, `gh pr edit --add-label`/`--remove-label`, `gh pr close`.

O GitHub compartilha uma única numeração entre issues e PRs, então um `#42` solto pode ser qualquer um dos dois: resolva com `gh pr view 42` e, se falhar, `gh issue view 42`.

## Quando uma skill disser "publique no issue tracker"

Crie uma issue no GitHub.

## Quando uma skill disser "busque o ticket relevante"

Leia como em **Ler uma issue** acima.

## Operações de wayfinding

Usadas pela `/wayfinder`. O **mapa** é uma única issue com issues **filhas** como tickets.

- **Mapa**: uma única issue com a label `wayfinder:map`, contendo o corpo com Notas / Decisões até aqui / Neblina. `gh issue create --label wayfinder:map`.
- **Ticket filho**: uma issue ligada ao mapa como sub-issue do GitHub (veja **Tornar uma issue sub-issue de uma issue mãe**). Onde sub-issues não estiverem habilitadas, acrescente a filha a uma task list no corpo do mapa e coloque `Parte de #<mapa>` no topo do corpo da filha. Labels: `wayfinder:<tipo>` (`research`/`prototype`/`grilling`/`task`). Depois de assumido, o ticket é atribuído ao dev que está conduzindo.
- **Bloqueio**: as **dependências nativas entre issues** do GitHub, a representação canônica e visível na interface. Adicione uma aresta com `gh api --method POST repos/<dono>/<repo>/issues/<filha>/dependencies/blocked_by -F issue_id=<database-id-do-bloqueador>`, em que `<database-id-do-bloqueador>` é o **database id** numérico do bloqueador (`gh api repos/<dono>/<repo>/issues/<n> --jq .id`, _não_ o `#número` nem o `node_id`). O GitHub informa `issue_dependencies_summary.blocked_by` (só bloqueadores abertos, a barreira viva). Onde dependências não estiverem disponíveis, recorra a uma linha `Bloqueado por: #<n>, #<n>` no topo do corpo da filha. Um ticket está desbloqueado quando todos os bloqueadores estão fechados.
- **Consulta da fronteira**: liste as filhas abertas do mapa (`gh issue list --state open`, restrito às sub-issues / task list do mapa), descarte as que têm um bloqueador aberto (`issue_dependencies_summary.blocked_by > 0`, ou uma issue aberta na linha `Bloqueado por`) ou um responsável atribuído; a primeira na ordem do mapa vence.
- **Assumir**: `gh issue edit <n> --add-assignee @me`, a primeira escrita da sessão.
- **Resolver**: `gh issue comment <n> --body "<resposta>"`, depois `gh issue close <n>`, depois acrescente um ponteiro de contexto (resumo + link) em Decisões até aqui, no mapa.
