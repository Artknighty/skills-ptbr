# Integrações de issue tracker: só GitHub, GitLab e markdown local

A `setup-matt-pocock-skills` oferece suporte de primeira classe a exatamente três issue trackers, um por modelo inicial em `skills/engineering/setup-matt-pocock-skills/`:

- **GitHub** (`issue-tracker-github.md`, via `gh`)
- **GitLab** (`issue-tracker-gitlab.md`, via `glab`)
- **Markdown local** (`issue-tracker-local.md`, arquivos em `.scratch/`)

Pedidos para adicionar um backend de primeira classe para qualquer outro tracker estão fora do escopo. Isso inclui Jira, Linear, Azure DevOps, Trello, YouTrack e trackers novos focados em agentes.

## Por que isto está fora do escopo

Todo backend de issue tracker fixa no texto das skills o formato de uma CLI (comandos, flags, interpretação da saída). Cada backend novo é superfície de manutenção permanente, porque precisa continuar funcionando conforme a CLI da ferramenta evolui, e precisa continuar sendo testado com `/to-spec`, `/to-tickets`, `/triage` e companhia. Eu uso GitHub, então é o backend que consigo de fato manter correto. O GitLab é parecido o bastante para ir junto, e o markdown local não precisa de CLI nenhuma.

Popularidade não muda isso. O Jira é muito usado e tem CLI oficial (`acli`), e mesmo assim não vai ganhar um modelo: é um backend que eu não uso, com semântica de links, estados de workflow e manias de CLI próprios a manter testados. O custo cai em mim, seja a ferramenta popular ou não.

Todo outro tracker passa pela opção **Outro** da `/setup-matt-pocock-skills`: você descreve o seu fluxo num parágrafo e a skill o registra como texto em `docs/agents/issue-tracker.md`. Esse arquivo é seu. Se você refinou um fluxo de Jira ou Linear que funciona, mantenha-o no seu próprio repositório ou publique, e aponte a configuração para ele.

## Pedidos anteriores

- #99: "Add dex as an issue tracker backend" (o dex tinha uns 3 meses e umas 300 estrelas na época do pedido)
- #258: "Add Jira as first-class issue tracker via Rovo MCP"
- #1137: "Add Jira as a first-class issue tracker, via Atlassian's official CLI (`acli`)"
