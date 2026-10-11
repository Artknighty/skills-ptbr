## O que faz

A `setup-matt-pocock-skills` responde três perguntas sobre um repositório: onde as issues vivem, como se chamam as labels de triagem e onde ficam os documentos de domínio. Ela registra as respostas como arquivos markdown em `docs/agents/`.

Esses arquivos são a única coisa que muda de um repositório para outro. As skills em si são idênticas em todo lugar. Elas leem o `docs/agents/issue-tracker.md` em tempo de execução e fazem o que ele diz. É por isso que o conjunto não está preso ao GitHub, e por isso você nunca edita o arquivo de uma skill para apontá-la para outro tracker. Invocá-la com "ligue as skills a um issue tracker customizado" funciona com qualquer coisa a que você consiga se conectar programaticamente, sem mudar as skills.

Ela é uma skill guiada por prompt, não um script determinístico. Ela lê o seu `git remote`, o `CLAUDE.md` e o `GLOSSARY.md`, propõe o que encontrou e espera você confirmar antes de escrever qualquer coisa.

## Quando usar

Você invoca esta digitando `/setup-matt-pocock-skills`; o [agent](https://www.aihero.dev/ai-coding-dictionary/agent) não vai recorrer a ela sozinho. Os metadados dela a marcam como não invocável de propósito, então nenhuma outra skill consegue dispará-la por você.

Use uma vez por repositório, antes do primeiro uso de qualquer outra skill de engenharia. Se a [triage](./triage.md), a [to-spec](./to-spec.md), a [to-tickets](./to-tickets.md) ou a [wayfinder](./wayfinder.md) começarem a chutar para onde vão as suas issues, ou a aplicar labels que o seu tracker não tem, este repositório ainda não foi configurado. Dá para rodá-la num repositório no meio de um projeto. A skill lê o que já está lá, então nenhum trabalho anterior se perde.

## Pré-requisitos

Ela escreve no repositório em que você a roda:

| Ela escreve | Onde |
| --- | --- |
| `issue-tracker.md` | `docs/agents/` |
| `domain.md` | `docs/agents/` |
| `triage-labels.md` | `docs/agents/`, só quando a skill `triage` estiver instalada |
| Um bloco `## Skills de agente` | no `CLAUDE.md` ou no `AGENTS.md`, o que já existir |

Você faz commit de tudo como markdown. Não há modo por usuário nem global. A configuração vive no repositório, então cada repositório tem a própria cópia.

## As três decisões

Ela começa cada seção pela resposta recomendada e pula qualquer pergunta que a exploração já respondeu. A maioria das execuções só precisa de duas confirmações.

| Decisão | O que ela propõe | Quando pergunta |
| --- | --- | --- |
| **Issue tracker** | o que corresponde ao seu `git remote` | sempre, porque esta é a única escolha de verdade |
| **Labels de triagem** | manter os cinco nomes canônicos (`needs-triage`, `needs-info`, `ready-for-agent`, `ready-for-human`, `wontfix`) | só se a skill `triage` estiver instalada |
| **Documentos de domínio** | contexto único: um `GLOSSARY.md` mais `docs/adr/` na raiz | só se perceber sinais de monorepo, e aí oferece um `GLOSSARY-MAP.md` de múltiplos contextos |

As opções de tracker:

| Opção | Onde as issues vivem | Precisa de |
| --- | --- | --- |
| **GitHub** | as GitHub Issues do repositório | a CLI `gh` |
| **GitLab** | as GitLab Issues do repositório | a CLI `glab` |
| **Markdown local** | arquivos em `.scratch/<feature>/` neste repositório | nada, nem mesmo um remoto |
| **Outro** | onde você disser | um parágrafo seu descrevendo o fluxo |

As três primeiras vêm como modelos na skill e funcionam de fábrica. O markdown local é uma opção completa, não um quebra-galho. A skill suporta um projeto solo sem remoto. Uma ressalva: não use markdown local se você usa GitHub. São alternativas, então escolha uma.

"Outro" também é uma opção completa. É como Jira, Linear, Azure DevOps e Beads funcionam. Você descreve o fluxo, a skill registra o seu texto em `docs/agents/issue-tracker.md`, e as skills seguintes seguem o texto. Os usuários já construíram isso: uma variante de Jira via [MCP](https://www.aihero.dev/ai-coding-dictionary/mcp), uma CLI do Gitea com o formato do `gh`, um painel local feito à mão.

## Perguntas frequentes

**Eu preciso usar o GitHub?**

Não. GitHub, GitLab e markdown local em `.scratch/` vêm como modelos prontos, e qualquer outra coisa funciona pelo caminho "outro". Esta é a pergunta mais repetida, mais ou menos nestas palavras: *"travado no github"*, *"posso usar GitLab / Jira"*, *"e o Azure DevOps"*. A resposta é sempre a mesma: quem escolhe o tracker é a configuração, não a skill.

**Preciso rodá-la de novo depois de atualizar as skills?**

A resposta direta depois da v1.1 era sim. A mensagem de fechamento da própria skill é mais branda. Ela diz para rodar de novo só para trocar de tracker ou recomeçar. As duas posições se defendem. Os modelos iniciais mudam entre versões, então um `docs/agents/issue-tracker.md` de uma versão antiga pode ficar desatualizado em relação às skills que agora o leem. Se uma skill seguinte fizer algo diferente do que os documentos descrevem, rode a configuração de novo. É barato.

**Ela escreveu no `CLAUDE.md`, mas eu uso o Codex.**

É uma lacuna conhecida, e continua aberta. A regra de escolha do arquivo é "edite o `CLAUDE.md` se existir, senão o `AGENTS.md`". Ela confere qual arquivo existe, não qual [harness](https://www.aihero.dev/ai-coding-dictionary/harness) está rodando. Num repositório com um `CLAUDE.md` que sobrou do Claude Code, a skill escreve o bloco `## Skills de agente` num arquivo que o Codex nunca lê. Os usuários têm duas soluções: mover o bloco para o `AGENTS.md` à mão, ou manter o `AGENTS.md` como canônico e fazer do `CLAUDE.md` um ponteiro de uma linha para ele. Se nenhum dos dois arquivos existir, a skill pergunta qual criar em vez de escolher. Isso já confundiu quem esperava que ela decidisse.

**Ela não criou as minhas labels de triagem.**

(Nota da tradução: a versão do `SKILL.md` em que esta tradução se baseia já manda criar no GitHub ou no GitLab as labels configuradas que faltarem, com `gh label create` / `glab label create`, quando a Seção B roda. A resposta abaixo descreve o comportamento anterior; confira se a sua execução fez isso.) O `docs/agents/triage-labels.md` é um *mapeamento*: ele diz à `/triage` quais strings do seu tracker correspondem aos cinco papéis canônicos. Num repositório GitHub novo, as labels ainda não existem, e os usuários já registraram isso como bug mais de uma vez. Duas consequências:

- Se o seu tracker já usa os nomes canônicos, o mapeamento é uma tabela de identidade e não há nada a configurar. Esse é o caso comum pretendido, não um passo faltando.
- Esta skill também não cria as labels `wayfinder:map` e `wayfinder:<tipo>` da [wayfinder](./wayfinder.md), e `gh issue create --label <inexistente>` falha em vez de criar a label. Crie-as à mão antes da primeira execução da wayfinder num repositório GitHub.

**Posso configurar aqui o comportamento das outras skills (ritmo da [grilling](https://www.aihero.dev/ai-coding-dictionary/grilling), formato das perguntas, tom)?**

Não. Ela configura três coisas: tracker, labels, estrutura dos documentos. Os usuários já pediram que ela fosse o lugar das preferências por usuário. A resposta é que as skills continuam opinativas e não aceitam configuração por usuário. Preferências pertencem ao seu `CLAUDE.md`, como instruções simples, que toda skill já lê.

**Posso guardar a configuração em `~/.claude` em vez de fazer commit dela em todo repositório?**

Hoje não. Um usuário que roda as skills em muitos repositórios tem um pedido aberto para isso, mas não existe modo por usuário. Todo repositório carrega o próprio `docs/agents/`.

**Não é estranho ter uma skill que configura as outras skills?**

Uma reclamação antiga diz que sim, nestas palavras: *"ter uma skill para configurar a outra skill não me parece certo: significa que o LLM está configurando as próprias skills."* A troca é real. Sem um passo de configuração, toda skill que mexe com issues precisaria da própria cópia das instruções do tracker. A saída é markdown que você pode ler e editar, e isso limita o risco. Você pode ler cada arquivo que ela escreveu e mudá-lo à mão. Faça as mudanças do dia a dia desse jeito, não com outra execução.

## Está funcionando se

- `docs/agents/issue-tracker.md` e `docs/agents/domain.md` existem, mais o `triage-labels.md` se a `triage` estiver instalada.
- Uma seção `## Skills de agente` aparece no arquivo de instruções que o seu harness lê, com um resumo de uma linha apontando para cada um desses arquivos.
- O tracker que ela propôs corresponde ao remoto que você usa, e as strings das labels correspondem a labels que existem no seu tracker.
- Depois, a `/to-tickets` publica sem te perguntar onde vivem as issues, e a `/triage` aplica labels em vez de inventá-las.
- Nada nos arquivos das skills mudou. Se a configuração editou um `SKILL.md`, algo deu errado.

## Onde se encaixa

A `setup-matt-pocock-skills` é a **configuração de uma vez só** do fluxo de engenharia, a pré-condição que todo o resto pressupõe, não um passo da cadeia. As vizinhas dela são as que a leem: a [triage](./triage.md), que aplica o vocabulário de labels escrito aqui; a [to-spec](./to-spec.md) e a [to-tickets](./to-tickets.md), que publicam no tracker indicado aqui; e a [wayfinder](./wayfinder.md), que lê a seção "Operações de wayfinding" do mesmo arquivo do tracker para aprender a guardar mapas e [tickets](https://www.aihero.dev/ai-coding-dictionary/ticket) filhos. A [domain-modeling](./domain-modeling.md) preenche depois a estrutura de documentos de domínio que a configuração registra. Ela cria o `GLOSSARY.md` e os ADRs só quando você resolve um termo ou uma decisão, então um repositório sem documentos de domínio depois da configuração é normal. Para saber qual skill usar em seguida, a [ask-matt](./ask-matt.md) orienta por todo o conjunto.
