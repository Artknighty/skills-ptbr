# O bloco de instalação canônico

> Este arquivo descreve a instalação do repositório **original** (`mattpocock/skills`). Para instalar esta tradução, siga o [README](../README.md) deste fork: os nomes de plugin e de marketplace são outros (`mattpocock-skills-ptbr@skills-ptbr`).

Uma história de instalação, uma redação. O `README.md`, os `.changeset/*` e todas as páginas em `docs/` precisam dizer **isto** e nada além disto. Mude aqui primeiro e depois propague.

## Instalações gerenciadas primeiro

Comece pelas instalações que se atualizam sozinhas. Recorra ao skills.sh, rotulado como "atualizações manuais", só para agentes que não têm uma instalação assim. Chame um caminho de gerenciado só se ele se atualizar sem o usuário rodar comando nenhum. Coloque qualquer ativação única ao lado do comando de instalação dela. Nunca prometa "instantâneo".

O Claude Code instala do marketplace oficial dele, `claude-plugins-official`. Todo outro caminho gerenciado instala do marketplace próprio deste repositório, `.claude-plugin/marketplace.json` e `plugin.json`. Esses caminhos só reinstalam quando a `version` do `plugin.json` muda. O workflow de Release roda `npm run version`, que copia esse campo do `package.json`, então os usuários recebem um release quando o PR "chore: version skills" é mergeado.

| Agente         | Caminho                          | Atualiza sozinho?                                                       |
| -------------- | -------------------------------- | ----------------------------------------------------------------------- |
| Claude Code    | `@claude-plugins-official`       | Sim, por padrão                                                         |
| Codex          | marketplace `@mattpocock`        | Sim, ao iniciar, por padrão                                             |
| Copilot CLI    | marketplace `@mattpocock`        | Sim, depois de um `autoUpdate: true` único                              |
| VS Code        | Chat: Install Plugin From Source | Sim, diariamente, por padrão                                            |
| Gemini CLI     | `gemini skills install` (copia)  | Não. Uma extensão do Gemini precisaria de um layout plano `skills/<n>/` |
| Todos os demais | skills.sh                       | Não. Rode `npx skills update`, e rode `add` de novo para skills novas   |

Fontes (2026-10-08): Codex `core-plugins/src/manager.rs`; Copilot [cli-config-dir-reference](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-config-dir-reference); VS Code `pluginAutoUpdate.ts`; Gemini `skillLoader.ts`.

Ninguém rodou Auggie, Droid, Qwen ou Goose neste repositório, então eles ficam no skills.sh até alguém rodar.

## Claude Code

<canonical-block name="claude-code">

```bash
claude plugin install mattpocock-skills@claude-plugins-official
```

Atualiza sozinho por padrão.

</canonical-block>

## Codex

<canonical-block name="codex">

```bash
codex plugin marketplace add mattpocock/skills
codex plugin add mattpocock-skills@mattpocock
```

Atualiza sozinho ao iniciar.

</canonical-block>

## GitHub Copilot (CLI e VS Code)

Use o marketplace, não `copilot plugin install mattpocock/skills`. O Copilot descontinuou as instalações diretas de repositório, e elas não conseguem se atualizar sozinhas. A entrada `extraKnownMarketplaces` segue o schema documentado, mas ninguém a rodou ainda.

<canonical-block name="copilot">

```bash
copilot plugin marketplace add mattpocock/skills
copilot plugin install mattpocock-skills@mattpocock
```

Depois, uma única vez, adicione ao `~/.copilot/settings.json`:

```json
{
  "extraKnownMarketplaces": {
    "mattpocock": { "source": { "source": "github", "repo": "mattpocock/skills" }, "autoUpdate": true }
  }
}
```

No VS Code, rode **Chat: Install Plugin From Source** e informe `https://github.com/mattpocock/skills`. Ele se atualiza diariamente.

</canonical-block>

## Gemini CLI

O Gemini não lê o `.claude-plugin`, e o `--path` aceita um bucket só. Uma instalação por bucket promovido dá exatamente o conjunto promovido (27 skills, verificado em 2026-10-07).

<canonical-block name="gemini">

```bash
gemini skills install https://github.com/mattpocock/skills.git --path skills/engineering
gemini skills install https://github.com/mattpocock/skills.git --path skills/productivity
```

Rode os dois comandos de novo para atualizar.

</canonical-block>

## Todos os outros agentes, ou arquivos editáveis (skills.sh)

O `-a` pré-seleciona o agente. Cada agente do comentário foi testado em 2026-10-07. Prefira o skills.sh ao instalador de repositório do próprio agente, como `amp skill add` ou `pi install git:…`, porque esses também trazem `misc/` e `in-progress/`. O `npx skills update` pula as skills adicionadas no upstream depois do `add`, então o bloco manda os usuários rodarem `add` de novo.

<canonical-block name="other-agents">

```bash
npx skills@latest add mattpocock/skills -a <agent>  # cursor, opencode, devin, windsurf, amp, pi; omita -a para escolher
```

Quando o instalador perguntar quais skills levar, inclua `setup-matt-pocock-skills`. Para atualizar, rode `npx skills@latest update`, e rode `add` de novo para pegar skills novas.

</canonical-block>

Use a forma de skill única sempre que uma skill for citada sozinha. As páginas de `docs/` não usam este bloco, porque o ai-hero renderiza o widget de instalação acima do corpo da página. Veja [writing-docs.md](./writing-docs.md).

<canonical-block name="skills-sh-one-skill">

```bash
npx skills@latest add mattpocock/skills --skill=<n>
```

```bash
npx skills@latest update <n>
```

</canonical-block>

`skills@latest` é a grafia fixada em todo lugar.

## Os dois caminhos são exclusivos

O plugin é um pacote gerenciado, somente leitura, que você assina. O skills.sh escreve arquivos que são seus e que você edita. Instalar pelos dois deixa o usuário com cada skill duplicada: sempre diga "escolha um".
