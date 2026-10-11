# Distribuir o conjunto de skills como plugin nativo do Claude Code; adiar um plugin nativo do Codex

> ADR histórico do repositório original. Neste fork, o plugin se chama `mattpocock-skills-ptbr` e é instalado pelo marketplace próprio `skills-ptbr` (veja o README).

Estas skills sempre puderam ser instaladas via [skills.sh](https://skills.sh/mattpocock/skills) (`npx skills add mattpocock/skills`), que copia arquivos de skill editáveis para o projeto do usuário no Claude Code, no Codex e em outros harnesses compatíveis com o padrão Agent Skills. Um pedido recorrente é uma distribuição **plug-and-play**: assinar o conjunto como um pacote somente leitura e sempre atualizado, que você não edita, em vez de um fork que é seu. É exatamente isso que os sistemas nativos de plugin oferecem.

Distribuímos um **plugin nativo do Claude Code** e, por enquanto, **adiamos** um **plugin nativo do Codex**. A divisão é imposta pela forma como o manifest de plugin de cada ecossistema seleciona skills, diante da organização em buckets deste repositório.

## A restrição: skills em buckets vs. seleção por caminho único

As skills vivem em pastas-bucket dentro de `skills/`: `engineering/` e `productivity/` são **promovidas** (distribuídas); `misc/`, `personal/`, `in-progress/` e `deprecated/` **não** são. Um plugin precisa expor só o conjunto promovido, que se espalha por duas dessas pastas.

- **Claude Code**: o `.claude-plugin/plugin.json` aceita `skills` como um **array de caminhos explícitos de diretórios de skill**. Listamos as skills promovidas uma a uma, excluímos todo o resto sem ambiguidade e adicionamos `.claude-plugin/marketplace.json` para que o repositório seja seu próprio marketplace de um plugin só. Verificado de ponta a ponta: `claude plugin validate . --strict` passa, e `marketplace add` → `install` resolve todas as skills promovidas.

- **Codex**: o `.codex-plugin/plugin.json` só aceita `skills` como uma **string de caminho único** (arrays são rejeitados com `missing or invalid plugin.json`), e o Codex descobre os arquivos `SKILL.md` recursivamente abaixo dele. Não há como nomear duas pastas-bucket, nem selecionar um subconjunto, a partir de um caminho. Duas saídas foram testadas e rejeitadas:
  - Apontar para `./skills/` também distribuiria `deprecated/`, `in-progress/`, `personal/` e `misc/`: skills aposentadas, rascunhos e skills pessoais que deliberadamente não promovemos.
  - Um diretório plano e curado de **symlinks** para os buckets não sobrevive à instalação: o Codex copia a árvore do plugin para o cache dele e **descarta os symlinks**, então as skills chegam vazias.

As únicas formas robustas de dar ao Codex um caminho único só com as promovidas são (a) **reestruturar** para que `skills/` contenha só skills promovidas (tirando dali os buckets não promovidos, com um blast radius grande sobre o `CLAUDE.md`, o `scripts/link-skills.sh`, os README dos buckets e o fluxo de desenvolvimento local que depende de `in-progress/` e `personal/`), ou (b) **versionar cópias duplicadas** das skills promovidas num diretório plano (um fardo de sincronização e uma segunda fonte da verdade). As duas são decisões estruturais, não algo para empacotar junto com a distribuição do plugin do Claude. Muito provavelmente é esse o motivo original, meio esquecido, de um plugin não ter sido distribuído antes: os formatos de manifest não expressavam de forma limpa um subconjunto curado de um repositório em buckets.

## Decisão

- Distribuir agora o **plugin do Claude Code** (`.claude-plugin/plugin.json` + `.claude-plugin/marketplace.json`), curado para o conjunto promovido, como entrega principal da v1.2.
- Manter o **skills.sh** como instalador universal: ele já atende o Codex e outros harnesses hoje, então nenhum usuário de Codex fica sem caminho de instalação.
- **Adiar** o plugin nativo do Codex até decidirmos entre reestruturar `skills/` só com as promovidas ou versionar uma cópia plana gerada. Revisitar quando o Codex suportar um array / lista de inclusão em `skills` ou preservar symlinks na instalação.

## Invariantes que isto cria

- Toda skill promovida tem uma entrada no array `skills` do `.claude-plugin/plugin.json` (isso já era regra no `CLAUDE.md`; agora também controla o conteúdo do plugin).
- A `version` do `.claude-plugin/plugin.json` acompanha a versão do `package.json`: atualize as duas juntas a cada release. O Claude usa a `version` do plugin para decidir quando os usuários com o plugin instalado veem uma atualização.

## Atualização, 2026-08-05

O `mattpocock-skills` foi aceito no **marketplace oficial do Claude Code** (nome configurado `claude-plugins-official`, repositório de origem `anthropics/claude-plugins-official`), que toda instalação do Claude Code tem por padrão. `claude plugins install mattpocock-skills` passou a ser o caminho documentado, e o fluxo `marketplace add` → `install` acima foi substituído. O texto de instalação vive em [.agents/install-block.md](../install-block.md).

A listagem oficial aponta para a URL git deste repositório e lê o `.claude-plugin/plugin.json` diretamente, então não depende do `.claude-plugin/marketplace.json`. Esse arquivo é mantido só como alternativa para instalar o repositório diretamente (um commit ainda não lançado, ou um fork).

Verificado em 2026-08-05, no Claude Code 2.1.222, contra a listagem ao vivo:

- `claude plugins install mattpocock-skills` resolve sem nenhum marketplace adicionado antes, e reporta `mattpocock-skills@claude-plugins-official`.
- `claude plugin details mattpocock-skills` então reporta a versão 1.2.0 e carrega as skills promovidas.
- O `source` da listagem é `{"source": "url", "url": "https://github.com/mattpocock/skills.git", "sha": …}`: o **sha é fixado**, então um release chega aos usuários quando esse pin anda, não no momento em que criamos a tag. No momento desta escrita o pin está dois commits atrás do `main`, e por isso a listagem mostra 22 skills em vez das 24 do `plugin.json`.
- O `/plugin install mattpocock-skills` dentro da sessão **não** foi exercitado: `/plugin` não está disponível em sessões headless (`claude -p`). Ele roda o mesmo resolvedor da CLI, e a forma de exemplo documentada é `/plugin install <nome>@claude-plugins-official`.

## Atualização, 2026-10-07

A restrição do Codex acima deixou de valer. O `main` do Codex aceita um array de strings em `skills` e recorre ao `.claude-plugin/` quando não existe `.codex-plugin/` ([manifest.rs](https://github.com/openai/codex/blob/main/codex-rs/core-plugins/src/manifest.rs)). O Codex continua descartando symlinks.

No Codex 0.161.0, a instalação pelo marketplace `@mattpocock` carrega as skills promovidas invocadas pelo modelo e nada de `misc/` ou `in-progress/`. A CLI do Copilot lê os mesmos manifests e reporta "Installed 27 skills".

## Atualização, 2026-10-08: instalações gerenciadas primeiro

O `@mattpocock` agora é o caminho principal no Codex, no Copilot e no VS Code, ao custo de uma ativação única no Copilot. O Claude Code continua no `claude-plugins-official`, como na atualização de 2026-08-05, porque ele se atualiza sozinho por padrão e não precisa de `marketplace add`.

A invariante de versão acima agora vale para todo caminho gerenciado. O `npm run version` já a mantém rodando `scripts/sync-plugin-version.mjs`. O `marketplace.json` não tem campo `version`, então não tem como ficar dessincronizado.
