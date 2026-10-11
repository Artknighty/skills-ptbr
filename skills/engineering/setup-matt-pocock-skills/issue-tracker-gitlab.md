# Issue tracker: GitLab

As issues e specs deste repositório vivem como issues do GitLab. Use a CLI [`glab`](https://gitlab.com/gitlab-org/cli) para todas as operações.

## Convenções

- **Criar uma issue**: `glab issue create --title "..." --description "..."`. Use um heredoc para descrições com várias linhas. Passe `--description -` para abrir um editor.
- **Ler uma issue**: `glab issue view <número> --comments`. Use `-F json` para saída legível por máquina.
- **Listar issues**: `glab issue list -O json` com os filtros `--label` adequados.
- **Comentar numa issue**: `glab issue note <número> --message "..."`. O GitLab chama comentários de "notes".
- **Aplicar / remover labels**: `glab issue update <número> --label "..."` / `--unlabel "..."`. Várias labels podem ser separadas por vírgula ou passadas repetindo a flag.
- **Fechar**: `glab issue close <número>`. O `glab issue close` não aceita um comentário de fechamento, então publique a explicação antes com `glab issue note <número> --message "..."` e depois feche.
- **Merge requests**: o GitLab chama PRs de "merge requests". Use `glab mr create`, `glab mr view`, `glab mr note` etc., no mesmo formato de `gh pr ...`, com `mr` no lugar de `pr` e `note`/`--message` no lugar de `comment`/`--body`.

Deduza o repositório a partir de `git remote -v`; o `glab` faz isso automaticamente quando roda dentro de um clone.

## Merge requests como canal de triagem

**MRs como canal de pedidos: não.** _(Mude para `sim` se este repositório trata merge requests externos como pedidos de funcionalidade; a `/triage` lê esta flag.)_

Quando estiver `sim`, os MRs passam pelas mesmas labels e estados que as issues, usando os equivalentes `glab mr`:

- **Ler um MR**: `glab mr view <número> --comments` e `glab mr diff <número>` para o diff.
- **Listar MRs externos para triagem**: `glab mr list -F json`, depois mantenha só os MRs cujo autor não seja membro/dono do projeto (o MR de um contribuidor, não um trabalho em andamento de um mantenedor).
- **Comentar / rotular / fechar**: `glab mr note`, `glab mr update --label`/`--unlabel`, `glab mr close`.

Diferente do GitHub, o GitLab numera issues e MRs separadamente, então `#42` não é ambíguo depois que você sabe a qual canal o mantenedor se refere.

## Quando uma skill disser "publique no issue tracker"

Crie uma issue no GitLab.

## Quando uma skill disser "busque o ticket relevante"

Rode `glab issue view <número> --comments`.

## Operações de wayfinding

Usadas pela `/wayfinder`. O **mapa** é uma única issue com issues **filhas** como tickets.

- **Mapa**: uma única issue com a label `wayfinder:map`, contendo o corpo com Notas / Decisões até aqui / Neblina. `glab issue create --label wayfinder:map`. (Nos planos do GitLab com epics nativos, um epic pode conter o mapa; uma issue com label funciona em qualquer lugar.)
- **Ticket filho**: uma issue com `Parte de #<mapa>` no topo da descrição e as labels `wayfinder:<tipo>` (`research`/`prototype`/`grilling`/`task`). Depois de assumido, o ticket é atribuído ao dev que está conduzindo.
- **Bloqueio**: o **link de bloqueio nativo** do GitLab, a representação canônica e visível na interface. Adicione-o com a quick action `/blocked_by #<n>`, publicada como note (`glab issue note <filha> --message "/blocked_by #<bloqueador>"`). Links de bloqueio nativos são recurso dos planos Premium/Ultimate; no plano gratuito (ou onde não estiverem disponíveis), recorra a uma linha `Bloqueado por: #<n>, #<n>` no topo da descrição. Um ticket está desbloqueado quando todos os bloqueadores estão fechados.
- **Consulta da fronteira**: `glab issue list -O json` restrito às filhas do mapa; descarte as que têm um bloqueador aberto (um link nativo `blocked_by` para uma issue aberta, via `glab api projects/:id/issues/<iid-da-filha>/links`, ou uma issue aberta na linha `Bloqueado por`) ou um responsável atribuído; a primeira na ordem do mapa vence.
- **Assumir**: `glab issue update <n> --assignee @me`, a primeira escrita da sessão.
- **Resolver**: `glab issue note <n> --message "<resposta>"`, depois `glab issue close <n>`, depois acrescente um ponteiro de contexto (resumo + link) em Decisões até aqui, no mapa.
