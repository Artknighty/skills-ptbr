---
name: setup-matt-pocock-skills
description: "Configura este repositório para as skills de engenharia: define o issue tracker, o vocabulário de labels de triagem e a estrutura dos documentos de domínio. Rode uma vez antes do primeiro uso das outras skills de engenharia."
disable-model-invocation: true
---

# Configurar as skills do Matt Pocock

Monte a configuração por repositório que as skills de engenharia pressupõem:

- **Issue tracker**: onde as issues vivem (GitHub por padrão; markdown local também é suportado de fábrica)
- **Labels de triagem**: as strings usadas para os cinco papéis canônicos de triagem
- **Documentos de domínio**: onde ficam o `GLOSSARY.md` e os ADRs, e as regras de leitura para quem os consome

Esta é uma skill guiada por prompt, não um script determinístico. Explore, apresente o que encontrou, confirme com o usuário e depois escreva.

Escreva todos os arquivos gerados (o bloco no `CLAUDE.md`/`AGENTS.md` e os `docs/agents/*.md`) em português do Brasil. Os identificadores ficam como estão: nomes de labels, valores de `Status:`, nomes de arquivo, comandos e nomes de skills.

## Processo

### 1. Explore

Olhe o repositório atual para entender o estado inicial dele. Leia o que existir; não presuma:

- `git remote -v` e `.git/config`: é um repositório GitHub? Qual?
- `AGENTS.md` e `CLAUDE.md` na raiz do repositório: algum deles existe? Já existe uma seção `## Skills de agente` (ou `## Agent skills`, gerada pela versão original em inglês) em algum deles?
- `GLOSSARY.md` e `GLOSSARY-MAP.md` na raiz do repositório
- `docs/adr/` e quaisquer diretórios `src/*/docs/adr/`
- `docs/agents/`: a saída anterior desta skill já existe?
- `.scratch/`: sinal de que uma convenção de issue tracker em markdown local já está em uso
- A skill `triage` está instalada? (uma pasta de skill `triage` ao lado desta, ou `triage` entre as suas skills disponíveis.) Isso decide se a Seção B roda ou não.
- Sinais de monorepo: um `pnpm-workspace.yaml`, um campo `workspaces` no `package.json`, ou um `packages/*` preenchido com `src/` próprio. Só aparecem num repositório realmente grande, com vários pacotes; a ausência deles significa contexto único, que é o caso de quase todo repositório.

### 2. Apresente o que encontrou e pergunte

Resuma o que existe e o que falta. Depois percorra as seções em ordem. Uma seção, uma resposta, depois a próxima.

Abra cada seção com a resposta recomendada, para que o usuário possa aceitá-la com uma palavra. Dê uma explicação de uma linha só quando a escolha realmente se ramificar; pule a seção inteira quando a exploração já tiver resolvido (a Seção B quando a `triage` não estiver instalada, a Seção C quando não houver monorepo).

**Seção A: Issue tracker.**

> Explicação: O "issue tracker" é onde as issues deste repositório vivem. Skills como `to-tickets`, `triage` e `to-spec` leem e escrevem nele. Elas precisam saber se devem chamar `gh issue create`, escrever um arquivo markdown em `.scratch/` ou seguir algum outro fluxo que você descrever. Escolha o lugar onde você de fato acompanha o trabalho deste repositório.

Postura padrão: estas skills foram projetadas para o GitHub. Se um `git remote` apontar para o GitHub, proponha o GitHub. Se um `git remote` apontar para o GitLab (`gitlab.com` ou um host próprio), proponha o GitLab. Caso contrário (ou se o usuário preferir), ofereça:

- **GitHub**: as issues vivem nas GitHub Issues do repositório (usa a CLI `gh`)
- **GitLab**: as issues vivem nas GitLab Issues do repositório (usa a CLI [`glab`](https://gitlab.com/gitlab-org/cli))
- **Markdown local**: as issues vivem como arquivos em `.scratch/<feature>/` neste repositório (bom para projetos solo ou repositórios sem remoto)
- **Outro** (Jira, Linear etc.): peça ao usuário para descrever o fluxo em um parágrafo; a skill vai registrá-lo como texto livre

Registre a escolha em `docs/agents/issue-tracker.md`. Os modelos de GitHub e GitLab trazem uma flag "PRs como canal de pedidos", com padrão **desligado**. Deixe desligada e não toque no assunto: um usuário que queira PRs externos na fila de triagem pode mudar a flag no arquivo depois.

**Seção B: Vocabulário de labels de triagem.** Pule esta seção inteira se a skill `triage` não estiver instalada (a exploração te disse), já que uma skill não instalada não precisa de labels.

Se estiver instalada, faça exatamente uma pergunta:

> Quer manter as labels de triagem padrão? (recomendado: **sim**)

O padrão são os cinco papéis canônicos, com cada label igual ao nome do papel: `needs-triage`, `needs-info`, `ready-for-agent`, `ready-for-human`, `wontfix`. Com **sim**, escreva-as como estão. Só se o usuário disser não, geralmente porque o tracker dele já usa outros nomes (ex.: `bug:triage` no lugar de `needs-triage`), colete as substituições para que a `triage` aplique as labels existentes em vez de criar duplicatas.

**Seção C: Documentos de domínio.** O padrão é **contexto único** (um `GLOSSARY.md` + `docs/adr/` na raiz do repositório). Isso serve para quase todo repositório; escreva sem perguntar.

Ofereça **múltiplos contextos** (um `GLOSSARY-MAP.md` na raiz apontando para arquivos `GLOSSARY.md` por contexto) só quando a exploração tiver encontrado sinais de monorepo. Nesse caso, confirme qual estrutura o usuário quer.

### 3. Confirme e edite

Mostre ao usuário um rascunho de:

- O bloco `## Skills de agente` a acrescentar ao `CLAUDE.md` ou ao `AGENTS.md`, o que for editado (veja as regras de escolha no passo 4)
- O conteúdo de `docs/agents/issue-tracker.md`, `docs/agents/domain.md` e `docs/agents/triage-labels.md` (este último só quando a `triage` estiver instalada)

Deixe-o editar antes de escrever.

### 4. Escreva

**Escolha o arquivo a editar:**

- Se `CLAUDE.md` existir, edite-o.
- Senão, se `AGENTS.md` existir, edite-o.
- Se nenhum dos dois existir, pergunte ao usuário qual criar; não escolha por ele.

Nunca crie `AGENTS.md` quando `CLAUDE.md` já existir (nem o contrário); sempre edite o que já está lá.

Se um bloco `## Skills de agente` (ou `## Agent skills`, da versão em inglês) já existir no arquivo escolhido, atualize o conteúdo dele no próprio lugar em vez de acrescentar um duplicado; se ele estiver em inglês, substitua-o pela versão em português. Não sobrescreva edições do usuário nas seções ao redor.

O bloco:

```markdown
## Skills de agente

### Issue tracker

[resumo de uma linha de onde as issues são acompanhadas]. Veja `docs/agents/issue-tracker.md`.

### Labels de triagem

[resumo de uma linha do vocabulário de labels]. Veja `docs/agents/triage-labels.md`.

### Documentos de domínio

[resumo de uma linha da estrutura: "contexto único" ou "múltiplos contextos"]. Veja `docs/agents/domain.md`.
```

Inclua o sub-bloco `### Labels de triagem`, e escreva `docs/agents/triage-labels.md`, só quando a `triage` estiver instalada e a Seção B tiver rodado. Caso contrário, os dois são omitidos.

Quando a Seção B tiver rodado com GitHub ou GitLab, crie cada label configurada que faltar no tracker (`gh label create` / `glab label create`).

Depois escreva os arquivos de documentação usando os modelos iniciais desta pasta de skill como ponto de partida:

- [issue-tracker-github.md](./issue-tracker-github.md): issue tracker no GitHub
- [issue-tracker-gitlab.md](./issue-tracker-gitlab.md): issue tracker no GitLab
- [issue-tracker-local.md](./issue-tracker-local.md): issue tracker em markdown local
- [triage-labels.md](./triage-labels.md): mapeamento de labels (só se a `triage` estiver instalada)
- [domain.md](./domain.md): regras de leitura dos documentos de domínio + estrutura

Para issue trackers do tipo "outro", escreva `docs/agents/issue-tracker.md` do zero a partir da descrição do usuário.

### 5. Pronto

Diga ao usuário que a configuração terminou e quais skills de engenharia vão passar a ler esses arquivos. Mencione que ele pode editar `docs/agents/*.md` diretamente depois; rodar esta skill de novo só é necessário se ele quiser trocar de issue tracker ou recomeçar do zero.
