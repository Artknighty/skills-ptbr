## O que faz

A `wizard` gera um script bash interativo que conduz um humano, passo a passo, por um procedimento manual: configurar serviços de terceiros, rodar uma migração pontual, levar um projeto do estado A ao estado B. Ele abre cada URL, diz o que clicar e copiar, captura o que volta e grava isso em arquivos `.env` e em secrets do GitHub Actions.

O [agent](https://www.aihero.dev/ai-coding-dictionary/agent) escreve o script; ele nunca o roda. Quem roda é você, na sua máquina. Um wizard é um programa, não uma lista de instruções. O script executa cada passo em ordem e guarda os valores que você digita. A sua parte é clicar, colar e apertar Enter.

## Quando usar

Você pode digitar `/wizard`, e o agente também pode recorrer a ela sozinho. Quando ele bate num passo que você precisa dar (uma chave que ele não consegue gerar, um painel em que ele não consegue clicar), ele te constrói um wizard em vez de escrever as instruções no chat, onde elas somem rolando para cima.

Use quando a próxima coisa que te bloqueia for uma passagem por um painel:

| Situação | O que o wizard faz |
| --- | --- |
| Um dev novo precisa de seis serviços configurados antes de o app subir | Abre cada painel em ordem, captura as chaves, grava no `.env` e no CI |
| Uma migração pontual precisa de chaves viradas numa ordem específica | Sequencia os passos irreversíveis atrás de barreiras de confirmação |
| Um projeto precisa ir do estado A ao estado B uma vez | Percorre a transição e reporta o que não conseguiu fazer |
| Você está prestes a escrever esses passos num README | Escreve uma versão executável no lugar, que falha de forma visível quando um passo fica desatualizado |

Não recorra a ela para *decidir* o que construir; para isso, as ferramentas são a [grill-with-docs](./grill-with-docs.md) e a [to-spec](./to-spec.md).

## Pré-requisitos

Nenhum para gerar um. O wizard que ela escreve roda em bash e usa o `gh` quando uma etapa define um secret ou variável do GitHub. Se o `gh` não estiver instalado ou autenticado, a execução não falha. Aquela etapa mostra um aviso, e o resumo final te diz o que definir à mão.

## Etapas

Uma **etapa** (stage) é uma tarefa focada numa tela. O script limpa o terminal entre as etapas, então uma etapa que transborda a tela perde a parte que rolou para cima. Você escreve as etapas em ordem de dependência e define `TOTAL_STAGES`, que alimenta a exibição do progresso.

A [skill](https://www.aihero.dev/ai-coding-dictionary/skill) delimita o procedimento antes de escrever qualquer script. Ela lê o repositório em vez de perguntar do nada: `.env*`, `docker-compose*`, configuração do framework e toda referência `secrets.*` / `vars.*` em `.github/workflows/`. Cada uma dessas referências é um valor que o wizard precisa produzir. Depois ela te mostra a lista ordenada de etapas para você confirmar. Só depois da confirmação ela mapeia cada etapa para o caminho exato que um humano segue ("Dashboard → Developers → API keys → Reveal test key → copiar"). Onde ela não conhece a interface atual, ela te pergunta ou consulta a documentação em vez de inventar cliques.

Para cada valor capturado, a delimitação decide para onde ele vai:

| Destino | Quando |
| --- | --- |
| Só `.env` | O dev local precisa, o CI não |
| Secret do GitHub | O CI lê, e é sensível |
| Variável do GitHub | O CI lê, e é público |
| `.env` e um secret | O dev local e o CI precisam |
| Lugar nenhum | A etapa é só uma ação: uma chave virada, um plano atualizado |

## O modelo já resolve a UX

O [modelo](../../skills/engineering/wizard/template.sh) traz a experiência inteira: progresso, barreiras de confirmação, abertura de URL multiplataforma incluindo WSL, entrada oculta para segredos, gravação idempotente no `.env`, escrita via `gh secret` / `gh variable` e um resumo final de tudo o que precisou ser pulado. Tudo acima do marcador `STAGES` é uma biblioteca fixa, idêntica em todo wizard e nunca editada à mão. Como a biblioteca nunca muda, todo wizard se comporta do mesmo jeito. O único trabalho por wizard é delimitar o procedimento e escrever as etapas dele. (Nesta tradução, os textos exibidos pela biblioteca estão em português.)

O agente que escreve um wizard nunca o roda de ponta a ponta, porque o script abre navegadores e espera entrada humana. O agente o confere estaticamente: `bash -n`, `shellcheck` onde estiver disponível, e um rastreio de que todo valor vai parar onde a delimitação disse, com cada nome de `set_secret` correspondendo a uma referência `secrets.*` real no CI. Então a primeira execução é sua, e essa execução é o teste.

## Efêmero por padrão

| O que você tem | O que fazer com o script |
| --- | --- |
| Uma migração pontual, uma configuração pessoal, uma transição que você nunca vai repetir | Salve num caminho de rascunho ou em `scripts/`, rode, apague |
| Um caminho de configuração de que a próxima pessoa no repositório também vai precisar | Faça commit e coloque um link no README, para que ela rode o script em vez de perguntar de novo a um agente |

## Perguntas frequentes

**Minhas chaves de API acabam indo para o contexto do modelo?**

Não. O agente escreve um script; ele não o roda. Você mesmo roda o script, e ele captura a chave com entrada oculta no terminal e a grava direto no `.env` ou no `gh secret`. O wizard é uma CLI, e o modelo não está conectado a ela. Isso vale só para os valores que o wizard captura durante a execução. Se você colar uma chave no chat enquanto delimita o procedimento, ela está no [context](https://www.aihero.dev/ai-coding-dictionary/context) como qualquer outro texto colado.

**Dá para voltar e corrigir um valor que digitei errado?**

Não no meio da execução. Não há botão de voltar. As etapas só andam para a frente, e uma resposta errada na etapa 3 significa Ctrl-C e rodar de novo. Rodar de novo é barato, porque qualquer valor já gravado no `.env` é oferecido de volta como padrão, então você aperta Enter nas etapas que acertou e redigita só a errada. Os usuários pediram isso na semana do lançamento, e continua em aberto: "amei! Só uma coisa: tem como voltar e corrigir o que você digitou?"

**Ele sabe o que eu já configurei?**

Em parte, e menos do que as reações do lançamento supunham. Ele lê o repositório antes de perguntar (os seus arquivos `.env`, o `docker-compose`, a configuração do framework, as referências `secrets.*` no CI), então delimita o trabalho aos valores que faltam em vez de começar do zero como um README. O que ele não faz é conferir o serviço de terceiros. Se uma chave existe no seu `.env`, o wizard a oferece de volta e o Enter a mantém; se você já criou a conta no Stripe mas nunca salvou a chave, o wizard ainda te manda para o painel buscá-la.

**Onde ela fica no fluxo de trabalho, depois da sabatina e da spec?**

Em nenhum lugar em particular. Ela é avulsa, não um passo da cadeia. O palpite comum é `/grill-with-docs → /to-spec → /wizard`, e essa sequência serve, mas o gatilho é aparecer um procedimento manual, o que pode acontecer a qualquer momento: antes de começar, no meio da construção ou muito depois da entrega. Ela também funciona como ferramenta de descoberta. A delimitação encontra os pré-requisitos escondidos de uma tarefa, como as três chaves de API em que você não tinha pensado, antes de você se comprometer com o trabalho.

**Ela funciona fora do Claude Code?**

O script funciona. É bash puro, e roda igual seja qual for o [harness](https://www.aihero.dev/ai-coding-dictionary/harness) que o gerou. A skill em si é invocada pelo modelo, então aparece listada em todo lugar: digite `/wizard` no Claude Code ou `$wizard` no Codex, ou só descreva a configuração em que você travou. Ser invocada pelo modelo também a mantém longe da [#693](https://github.com/mattpocock/skills/issues/693), em que os apps desktop e web do Claude tiram as skills *invocadas pelo usuário* da lista do [model](https://www.aihero.dev/ai-coding-dictionary/model) e dizem que elas não estão instaladas.

**Ela não era invocada pelo usuário antes?**

Era. Agora ela é invocada pelo modelo, então o agente recorre a ela sem ser pedido quando bate num passo que você precisa dar. Nada que você conseguia fazer antes parou de funcionar. A invocação pelo modelo deixa o agente chamar a skill além de você, então `/wizard` se comporta como antes. A mudança corrige uma falha. Antes, um agente que batia num muro de credenciais no meio da construção despejava seis passos numerados no chat para você seguir à mão. Agora ele escreve um wizard.

**Ela ficava em `in-progress/`. Onde está agora?**

Em `engineering/`, desde a v1.2. Ela se formou do bucket beta e agora vai no plugin, então chega junto com o resto do conjunto promovido em vez de exigir uma instalação individual. O comportamento dela não mudou com a formatura.

## Está funcionando se

- Você recebe uma lista ordenada de etapas, e os valores que cada uma produz, e é chamado a confirmar, antes de existir qualquer script.
- Toda URL é aberta antes de o valor daquela página ser pedido. Nunca te pedem para colar algo que você não foi mandado buscar.
- Os segredos são digitados às cegas. Nada sensível aparece no seu histórico do terminal.
- Cada etapa cabe numa tela. Nada de que você ainda precisa rolou para cima.
- Ctrl-C e rodar de novo continua de onde você parou, oferecendo os valores já salvos como padrão.
- A tela final lista o que ele gravou e, separadamente, o que ele não conseguiu fazer e você precisa terminar à mão.

## Onde se encaixa

A `wizard` é uma avulsa para usar a qualquer hora, posicionada na linha em que a automação para e um humano precisa clicar. A vizinha mais próxima é a [setup-matt-pocock-skills](./setup-matt-pocock-skills.md), porque as duas existem para deixar um repositório funcionando. Aquela configura este conjunto de skills, e a `wizard` gera um caminho de configuração para todo o resto. Ela também combina com a [implement](./implement.md): quando uma construção entrega uma funcionalidade que precisa de credenciais ou de uma virada manual, um wizard cobre os passos que só um humano pode dar. Quando não tiver certeza de qual skill serve no momento, a [ask-matt](./ask-matt.md) te orienta.
