Este repositório é a tradução para pt-BR de [mattpocock/skills](https://github.com/mattpocock/skills). As convenções da tradução (o que fica em inglês, vocabulário fixo, como sincronizar com o original) estão em [TRADUCAO.md](./TRADUCAO.md). Leia-o antes de editar qualquer skill.

As skills ficam organizadas em pastas-bucket dentro de `skills/`:

- `engineering/`: trabalho diário com código
- `productivity/`: ferramentas diárias de fluxo de trabalho fora do código
- `misc/`: mantidas, mas raramente usadas, não promovidas
- `in-progress/`: beta: públicas de propósito, não incluídas no plugin
- `deprecated/`: não são mais usadas

Toda skill em `engineering/` ou `productivity/` (os buckets **promovidos**) precisa ter uma referência no `README.md` da raiz e uma entrada no array `skills` do `.claude-plugin/plugin.json` (o plugin do Claude Code inclui exatamente o conjunto promovido). Skills em `misc/`, `in-progress/` e `deprecated/` não podem aparecer em nenhum dos dois.

O `.claude-plugin/marketplace.json` é o marketplace deste repositório (`skills-ptbr`), e o plugin se chama `mattpocock-skills-ptbr`. Rode `claude plugin validate . --strict` depois de mexer em qualquer um dos manifests.

Cada entrada de skill no `README.md` da raiz precisa linkar o nome da skill para o `SKILL.md` dela.

Cada pasta-bucket tem um `README.md` que lista todas as skills do bucket com uma descrição de uma linha, com o nome da skill linkado para o `SKILL.md`. Os `README.md` dos buckets promovidos e o `README.md` da raiz agrupam as entradas em **Invocadas pelo usuário** e **Invocadas pelo modelo**; os `README.md` dos buckets não promovidos (`misc/`, `in-progress/`) usam uma lista plana.

Todo `SKILL.md` é invocado pelo usuário (`disable-model-invocation: true` mais `policy.allow_implicit_invocation: false` em `agents/openai.yaml`, acessível só pelo humano) ou invocado pelo modelo (acessível pelo modelo ou pelo usuário). Uma skill invocada pelo usuário tem `description` voltada a humanos (resumo de uma linha); uma invocada pelo modelo tem `description` voltada ao modelo, com os gatilhos ("Use quando..."). Dependências entre skills são escritas como instrução explícita para chamar a ferramenta Skill (`Chame a ferramenta Skill com "grilling"`), e só podem apontar para skills invocadas pelo modelo; para uma invocada pelo usuário, diga ao humano para rodá-la (`diga ao usuário para rodar /setup-matt-pocock-skills`).

O [`ask-matt`](./skills/engineering/ask-matt/SKILL.md) é o roteador que mapeia todas as skills acessíveis ao usuário e como elas se relacionam. Sempre que você adicionar, renomear, remover ou mudar o encaixe de uma skill acessível ao usuário nos fluxos, releia o `SKILL.md` do `ask-matt` e atualize-o para que o mapa continue correto: uma skill nova que ele nunca menciona, ou uma obsoleta para a qual ele ainda roteia, é um roteador que mente.

Para (re)linkar todas as skills fora de `deprecated/` e `misc/` nos diretórios de skills locais (`~/.claude/skills`, `~/.agents/skills`), rode `scripts/link-skills.sh`. Cada entrada é um symlink para este repositório, então um `git pull` mantém as skills instaladas atualizadas; rode o script de novo depois de adicionar, remover ou renomear uma skill.

Sem travessões (o caractere de travessão longo) em nenhum texto deste repositório (`SKILL.md`, docs, `README.md`, ADRs, comentários de código). Onde uma frase pedir um, reescreva com vírgula, dois-pontos, ponto, parênteses ou uma conjunção, o que a frase realmente pedir; nunca faça uma substituição cega de caractere.

## Skills de agente

### Labels de triagem

Nomes canônicos, sem alteração. Veja `docs/agents/triage-labels.md`.
