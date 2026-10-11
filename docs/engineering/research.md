## O que faz

A `research` responde uma pergunta lendo as fontes que são donas da resposta e depois deixa um arquivo Markdown com citações no repositório. Ela trabalha só a partir de **[primary sources](https://www.aihero.dev/ai-coding-dictionary/primary-source)** (fontes primárias): documentação oficial, código-fonte, especificações, APIs do próprio fornecedor. Ela segue cada afirmação de volta até a fonte que é dona dela, então não vai repetir o que um post de blog diz sobre uma API quando a documentação da própria API estiver acessível.

Ela não te responde na conversa. A saída é um arquivo, gravado onde o repositório já guarda esse tipo de nota, com um link em cada afirmação. Você recebe um documento ao qual pode reagir, que pode entregar a outro agente ou jogar fora, em vez de uma resposta que some quando a [session](https://www.aihero.dev/ai-coding-dictionary/session) acaba.

## Quando usar

Digite `/research`, ou o [agent](https://www.aihero.dev/ai-coding-dictionary/agent) recorre a ela automaticamente quando uma tarefa vira trabalho braçal de leitura.

Use quando o próximo passo for *descobrir algo* de fora do diretório de trabalho (como uma API de terceiros se comporta, o que uma especificação diz, se uma afirmação sobre uma versão se sustenta) e você preferir não travar a sua própria conversa fazendo a leitura. O que você precisa decide a skill:

| O que você precisa | Use |
| --- | --- |
| Um fato externo do qual uma decisão está esperando | `research` |
| Uma decisão tomada *com* você, por entrevista | [grilling](../productivity/grilling.md) |
| Uma decisão de arquitetura duradoura, escrita no `GLOSSARY.md` e em ADRs | [grill-with-docs](./grill-with-docs.md) |
| Descobrir se uma abordagem funciona na sua codebase | [prototype](./prototype.md) |
| Um plano grande demais para caber numa sessão | [wayfinder](./wayfinder.md) |

A linha entre a `research` e a `grill-with-docs` é a **validade do que volta**. A pesquisa produz fatos de vida curta, como o que o mecanismo de autenticação desta biblioteca faz nesta semana. Um ADR registra uma decisão que você mantém. Se o que você está produzindo é uma decisão e não um fato, você está numa [grilling](https://www.aihero.dev/ai-coding-dictionary/grilling), não pesquisando.

## Trabalho braçal delegado

A leitura roda como um **agente em segundo plano**. Você continua trabalhando enquanto ele segue cada afirmação até a fonte primária, escreve um arquivo Markdown e reporta de volta. A pesquisa é trabalho braçal que você delega, não raciocínio que você terceiriza. Você ganha um documento sobre o qual sabatinar, planejar ou projetar, e a decisão continua sendo sua.

Nada impede o agente em segundo plano de disparar outro agente em segundo plano por conta própria. Esse é o problema mais documentado da skill.

Quem decide onde o arquivo vai é o repositório, não a skill. Ela segue a convenção que já existir para notas. Se não houver nenhuma, ela escolhe um lugar razoável e te diz onde. Ela escreve um arquivo por execução.

## Perguntas frequentes

**Ela disparou um segundo agente de pesquisa. Era para isso acontecer?**

Não. É um bug aberto, a [issue #530](https://github.com/mattpocock/skills/issues/530). A skill manda quem a chama disparar um agente em segundo plano, mas não restringe o tipo de agente. Então quem chama dispara um agente `general-purpose`, que tem a ferramenta `Agent` e as mesmas instruções, e as segue de novo. Um relato mediu uma única tarefa de pesquisa custando uns 450 mil [tokens](https://www.aihero.dev/ai-coding-dictionary/token) em três execuções sobrepostas, e a duplicata terminou meia hora depois num lugar em que o usuário não conseguia vê-la. Isso também acontece fora do Claude Code. Usuários confirmaram o mesmo aninhamento no Codex com o GPT-5.6-sol. Não há correção lançada. Os usuários corrigiram a própria cópia instalada com uma linha dizendo a um agente que já é [subagent](https://www.aihero.dev/ai-coding-dictionary/subagent) para fazer o trabalho ele mesmo. Isso ajuda, mas é só uma instrução, não uma correção estrutural. Depois de invocar a skill, fique de olho na sua lista de tarefas em segundo plano e pare a duplicata.

A falha oposta também acontece. Se as suas instruções globais proíbem um agente de delegar trabalho de novo, o agente em segundo plano recusa a tarefa, e a skill não faz nada sem te avisar.

**Onde o arquivo deve ficar, e devo fazer commit dele?**

A skill coloca o arquivo onde o repositório já guarda notas e não tem mais opinião além disso. A visão da comunidade está praticamente fechada: mantenha ADRs, não arquivos de pesquisa. Uma thread no Discord sobre esta pergunta disse com mais clareza: "ADRs sim. Todo o resto, arquive ou apague depois de terminar. Senão vira entulho de trabalho e pode envenenar leituras futuras do repositório se você tiver se afastado da spec/pesquisa." Um arquivo de pesquisa registra o que era verdade no dia em que foi escrito, então um desatualizado é pior do que nenhum. Pesando tudo, esses arquivos não pertencem ao git, e não há um lar padrão para eles. As pessoas usam o Obsidian, um repositório de conhecimento separado ou o issue tracker.

**O que conta como fonte primária de "alta confiança", e quem decide?**

O [model](https://www.aihero.dev/ai-coding-dictionary/model) decide. A skill cita os *tipos* de fonte que se qualificam (documentação oficial, código-fonte, especificações, APIs do próprio fornecedor), e não há lista de permissões, filtro de domínio nem passada de verificação. Esta foi a objeção mais forte quando a skill foi proposta, e ninguém a respondeu publicamente: "Cinco subagentes de pesquisa apontados para lixo só te dão cinco respostas erradas e confiantes mais rápido. Como você está filtrando o que conta como fonte de alta confiança?" A sua única proteção é a citação em cada afirmação. Siga duas ou três. Se elas caírem num resumo da coisa, e não na coisa, a execução falhou.

**Uma sessão posterior reaproveita o que uma execução anterior encontrou?**

Não. Nada carrega automaticamente um arquivo de pesquisa antigo. O arquivo fica no repositório até um humano ou uma skill apontar para ele. Esta foi a crítica inicial mais forte ao design: "o valor está no markdown virar contexto que o agente relê depois, não na busca em si. Um arquivo morto escrito uma vez é só uma busca chique." A skill lançada não resolve isso. Na prática, o arquivo só é útil quando você mesmo o leva para o próximo passo: anexe-o a uma spec, cite-o numa sessão de sabatina, aponte um [ticket](https://www.aihero.dev/ai-coding-dictionary/ticket) para ele.

**Por que não simplesmente pedir ao agente para ir ler a documentação?**

Você pode, e um prompt de duas linhas dizendo exatamente isso era a prática que esta skill substituiu. A skill te dá duas coisas que o prompt não dá. Ela roda em segundo plano, então o [context](https://www.aihero.dev/ai-coding-dictionary/context) da sua sessão continua limpo. E a restrição a fontes primárias e a saída em arquivo com citações são sempre iguais, em vez de dependerem de como você formulou o prompt. Comparada ao modo de pesquisa profunda do próprio [harness](https://www.aihero.dev/ai-coding-dictionary/harness), a diferença é o arquivo e a regra das fontes primárias, não a busca. Se um prompt de duas linhas te dá o que você precisa numa pergunta pequena, use o prompt de duas linhas.

**Quando ela para de ler?**

A skill não tem critério de parada. Isso aparece como duas reclamações que parecem opostas, mas têm a mesma causa: agentes que vão fundo demais, e agentes que cobrem um assunto de forma ampla, mas perdem o único detalhe que importava. Um praticante disse assim: "skills de pesquisa profunda às vezes são profundas demais. E mandar um agente pesquisar costuma resultar em perder detalhes cruciais." Você precisa definir o escopo. Uma pergunta estreita e respondível (uma API, um comportamento, uma afirmação sobre uma versão) volta muito melhor do que "pesquise X".

**A `/wayfinder` criou tickets de research. Eu mesmo os resolvo?**

Não, agora ela os dispara por você. Uma sessão de traçado dispara um subagente de `/research` por ticket de research e os roda em paralelo. Cada um registra as descobertas num branch descartável `research/<nome>`, com um [context pointer](https://www.aihero.dev/ai-coding-dictionary/context-pointer) a partir do ticket. Os tickets de research são a única exceção à regra de um ticket por sessão da wayfinder, porque são [AFK](https://www.aihero.dev/ai-coding-dictionary/afk): nada espera por você. Um problema conhecido: apagar o branch depois quebra os ponteiros de contexto nos tickets.

## Está funcionando se

- A sua própria sessão continua andando. Se você está parado vendo ela ler, a delegação não aconteceu.
- Aparece exatamente uma tarefa nova em segundo plano. Uma segunda com nome quase idêntico é o bug de aninhamento.
- Aparece um arquivo Markdown novo, na pasta que o repositório já usa para notas, e o agente te diz o caminho.
- Toda afirmação nele tem um link, e seguir dois ao acaso te leva a uma documentação oficial, uma especificação ou o próprio arquivo de código, e não ao texto de alguém sobre isso.
- Você consegue tomar a decisão em que estava travado só com o arquivo, sem voltar às fontes você mesmo.

## Onde se encaixa

A `research` é uma avulsa para usar a qualquer hora. Ela alimenta as skills de raciocínio e não é um passo da cadeia de construção. Você leva o arquivo dela *para dentro* do fluxo. A [grilling](../productivity/grilling.md) e a [grill-with-docs](./grill-with-docs.md) fazem perguntas mais afiadas quando já têm os fatos, e a [to-spec](./to-spec.md) pode sintetizar a partir dele. A [wayfinder](./wayfinder.md) é a única skill que a invoca diretamente. Ela resolve cada ticket de research do mapa com um subagente de `/research`. Para o mapa inteiro, veja a [ask-matt](./ask-matt.md).
