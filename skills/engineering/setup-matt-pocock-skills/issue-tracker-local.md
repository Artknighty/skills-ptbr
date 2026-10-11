# Issue tracker: Markdown local

As issues e specs deste repositório vivem como arquivos markdown em `.scratch/`.

## Convenções

- Uma feature por diretório: `.scratch/<slug-da-feature>/`
- A spec é `.scratch/<slug-da-feature>/spec.md`
- As issues de implementação são um arquivo por ticket em `.scratch/<slug-da-feature>/issues/<NN>-<slug>.md`, numerados a partir de `01`, nunca um único arquivo combinado de tickets
- O estado de triagem é registrado numa linha `Status:` perto do topo de cada arquivo de issue (veja `triage-labels.md` para as strings dos papéis)
- Comentários e histórico de conversa são acrescentados ao final do arquivo, sob um título `## Comentários`

## Quando uma skill disser "publique no issue tracker"

Crie um arquivo novo em `.scratch/<slug-da-feature>/` (criando o diretório se necessário).

## Quando uma skill disser "busque o ticket relevante"

Leia o arquivo no caminho referenciado. Normalmente o usuário vai passar o caminho ou o número da issue diretamente.

## Operações de wayfinding

Usadas pela `/wayfinder`. O **mapa** é um arquivo com um arquivo **filho** por ticket.

- **Mapa**: `.scratch/<esforço>/map.md` (o corpo com Notas / Decisões até aqui / Neblina).
- **Ticket filho**: `.scratch/<esforço>/issues/NN-<slug>.md`, numerados a partir de `01`, com a pergunta no corpo. Uma linha `Tipo:` registra o tipo do ticket (`research`/`prototype`/`grilling`/`task`); uma linha `Status:` registra `claimed`/`resolved`.
- **Bloqueio**: uma linha `Bloqueado por: NN, NN` perto do topo. Um ticket está desbloqueado quando todos os arquivos que ele lista estão `resolved`.
- **Fronteira**: procure em `.scratch/<esforço>/issues/` os arquivos abertos, desbloqueados e ainda não assumidos; o de menor número vence.
- **Assumir**: defina `Status: claimed` e salve antes de qualquer trabalho.
- **Resolver**: acrescente a resposta sob um título `## Resposta`, defina `Status: resolved` e depois acrescente um ponteiro de contexto (resumo + link) em Decisões até aqui, no `map.md`.
