---
name: wayfinder
description: Planeja um pedaço enorme de trabalho (mais do que uma sessão de agente comporta) como um mapa compartilhado de tickets de decisão no seu issue tracker, e os resolve um por vez até que o caminho até o destino esteja claro.
disable-model-invocation: true
---

Chegou uma ideia solta, grande demais para uma sessão de agente e envolta em neblina: o caminho daqui até o **destino** ainda não está visível. Wayfinding é encontrar esse caminho, não sair correndo em direção ao destino. Esta skill traça o caminho como um **mapa compartilhado** no issue tracker do repositório e depois trabalha os **tickets de decisão** dele (perguntas cuja resolução é uma decisão, não fatias de uma construção a executar) um por vez, até a rota ficar clara.

O destino varia de esforço para esforço, e dar nome a ele é o primeiro ato do traçado: ele molda cada ticket. Pode ser uma spec a ser entregue e iterada, uma decisão a ser travada antes de o planejamento começar, ou uma mudança feita no lugar, como a migração de uma estrutura de dados. O mapa é independente de domínio: trabalho de engenharia, conteúdo de curso, o que se encaixar no formato.

## Planeje, não execute

A wayfinder é **planejamento** por padrão: cada ticket resolve uma decisão, e o mapa termina quando o caminho está claro, sem nada mais a decidir antes de alguém ir lá e fazer a coisa. A vontade de simplesmente fazer o trabalho costuma ser o sinal de que você chegou à borda do mapa e é hora de passar adiante. Um esforço pode sobrescrever isso nas **Notas** dele, trazendo a execução para dentro do próprio mapa, mas, sem isso, produza decisões, não entregáveis.

## Refira-se pelo nome

Todo mapa e todo ticket é uma issue, então tem um **nome**: o título. Em tudo o que o humano lê (narração, as Decisões até aqui do mapa), refira-se a ele por esse nome, nunca por um id, número ou slug solto. Uma parede de `#42, #43, #44` é ilegível; nomes se leem de relance. O id e a URL não somem; o nome envolve o link, mas eles vão _dentro_ do nome, nunca no lugar dele.

## O mapa

O mapa é uma única issue no issue tracker deste repositório, com a label `wayfinder:map`, o artefato canônico. Os tickets dele são issues filhas do mapa.

O mapa é um **índice**, não um depósito. Ele lista as decisões tomadas e aponta para os tickets que guardam o detalhe delas; uma decisão vive em exatamente um lugar, o ticket dela, então o mapa nunca a repete, só resume e faz o link.

**Onde o mapa, os tickets filhos, os bloqueios e as consultas de fronteira ficam fisicamente depende do tracker.** O issue tracker já deve ter sido fornecido a você. Se não, diga ao usuário para rodar `/setup-matt-pocock-skills`. Consulte a seção "Operações de wayfinding" do documento do tracker para ver como _este_ repositório as expressa. Se nenhum tracker tiver sido fornecido, use o tracker de markdown local por padrão.

### O corpo do mapa

O mapa inteiro em baixa resolução, carregado uma vez por sessão. Os tickets abertos **não** são listados: eles são issues filhas abertas, encontradas por consulta.

```markdown
## Destino

<como é chegar ao fim deste mapa: a spec, decisão ou mudança até a qual este esforço está encontrando o caminho. Uma ou duas linhas; toda sessão se orienta por ele antes de escolher um ticket.>

## Notas

<domínio; skills que toda sessão deve consultar; preferências permanentes para este esforço>

## Decisões até aqui

<!-- o índice: uma linha por ticket fechado, o bastante para julgar a relevância; depois siga o link para o detalhe que o ticket guarda -->

- [<título do ticket fechado>](link): <resumo de uma linha da resposta>

## Ainda não especificado

<!-- veja "Névoa de guerra": neblina dentro do escopo que você ainda não consegue transformar em ticket; vai se graduando conforme a fronteira avança -->

## Fora do escopo

<!-- veja "Fora do escopo": trabalho decidido como além do destino; fechado, nunca se gradua -->
```

### Tickets

Cada ticket é uma **issue filha** do mapa; o id da issue no tracker é a identidade dele. O corpo é a pergunta, dimensionada para uma sessão de agente de 100 mil tokens:

```markdown
## Pergunta

<a decisão ou investigação que este ticket resolve>
```

Cada ticket carrega uma label `wayfinder:<tipo>`, uma entre `research`, `prototype`, `grilling`, `task` (veja [Tipos de ticket](#tipos-de-ticket)). As labels `wayfinder:` são as únicas que um mapa e seus tickets carregam, nunca uma label de triagem como `ready-for-agent`: eles são decisões, não trabalho de implementação.

Uma sessão **assume** um ticket atribuindo-o ao dev que conduz o mapa, **primeiro**, antes de qualquer trabalho, para que sessões concorrentes o pulem. Essa atribuição _é_ o que marca o ticket como assumido: um ticket aberto e sem responsável está livre.

O bloqueio usa a relação de dependência **nativa** do tracker: essencial porque ela mostra a fronteira _visualmente_ na própria interface do tracker, então o humano vê o que dá para pegar sem abrir o mapa. Só um tracker sem bloqueio nativo recorre a uma convenção no corpo. Um ticket está **desbloqueado** quando todos os tickets que o bloqueiam estão fechados; a **fronteira** são as filhas abertas, desbloqueadas e livres, a borda do conhecido.

A resposta não faz parte do corpo; ela é registrada na resolução (veja [Trabalhe o mapa](#trabalhe-o-mapa)). Assets criados ao resolver um ticket são linkados a partir da issue, não colados nela.

## Tipos de ticket

Todo ticket é **HITL** (humano no ciclo, trabalhado _com_ um humano que fala por si mesmo) ou **AFK**, conduzido só pelo agente. Um ticket HITL só se resolve por essa troca ao vivo; o agente nunca faz o papel do humano nela (um agente de sabatina que responde às próprias perguntas quebrou isso).

- **Research** (AFK): Ler documentação, APIs de terceiros ou recursos locais como bases de conhecimento para trazer à tona um fato de que uma decisão depende. Resolvido por um subagente que chama a ferramenta Skill com "research". Use quando for necessário conhecimento de fora do diretório de trabalho atual.
- **Prototype** (HITL): Aumentar a fidelidade da discussão criando um artefato barato, rústico e concreto ao qual reagir (um roteiro, uma versão rascunho, um stub, ou código de UI/lógica), chamando a ferramenta Skill com "prototype". Faz o link do protótipo como asset. Use quando "como deveria ficar" ou "como deveria se comportar" for a pergunta-chave.
- **Grilling** (HITL): Conversa. O caso padrão. Sempre chame a ferramenta Skill duas vezes, uma para "grilling" e outra para "domain-modeling".
- **Task** (HITL ou AFK): Trabalho manual que precisa acontecer antes que uma _decisão_ possa ser tomada: nada a decidir, prototipar ou pesquisar, mas a discussão está travada até ele ser feito. Criar conta num serviço para poder avaliar a API dele, provisionar acesso, mover dados para poder ver o formato deles. É o único tipo que _faz_ em vez de decidir, e ele merece seu lugar por destravar uma decisão, não por entregar o destino. O agente o conduz sozinho onde puder (AFK); caso contrário, entrega ao humano um checklist preciso (HITL). Resolvido quando o trabalho estiver feito; a resposta registra o que foi feito e quaisquer fatos resultantes (onde ficam as credenciais, novas URLs, contagens de linhas) de que tickets posteriores dependam.

## Névoa de guerra

O mapa é _deliberadamente_ incompleto: não trace o que você ainda não consegue ver. Além dos tickets vivos fica a **névoa de guerra**: a visão turva das decisões e investigações que você percebe que estão vindo, mas ainda não consegue fixar, porque dependem de perguntas ainda abertas. Resolver um ticket dissipa a neblina à frente dele, graduando o que agora dá para especificar em tickets novos, um por vez, até que o caminho até o destino esteja claro e não reste nenhum ticket.

A seção **Ainda não especificado** do mapa é onde essa visão turva é registrada: a pergunta suspeita, a área a revisitar depois. É a fronteira não descoberta _rumo_ ao destino: tudo ali está dentro do escopo, só não está nítido o bastante para virar ticket. Escreva com a soltura ou a completude que a visão permitir; isso também serve de placa de sinalização para colaboradores verem para onde o esforço está indo.

**Neblina ou ticket?** O teste é se você consegue formular a pergunta com precisão agora, _não_ se consegue respondê-la agora.

- **Ticket quando** a pergunta já está nítida, mesmo que esteja bloqueada e você ainda não possa agir sobre ela.
- **Ainda não especificado quando** você ainda não consegue formulá-la com essa nitidez. Não pré-fatie a neblina em pedaços do tamanho de tickets: ela é mais grossa que um ticket, e uma mancha pode se graduar em vários tickets, ou em nenhum, quando a fronteira chegar até ela.

**Ainda não especificado** exclui o que já está decidido (Decisões até aqui), o que já é um ticket vivo e o que está fora do escopo (a próxima seção).

## Fora do escopo

A neblina só se acumula _rumo_ ao destino. O destino fixa o escopo, então o trabalho além dele está **fora do escopo**: não é neblina e não pertence a **Ainda não especificado**. Ele ganha uma seção própria de **Fora do escopo** no mapa: trabalho que você conscientemente excluiu _deste_ esforço. É o escopo, não a nitidez, que o coloca aqui.

Trabalho fora do escopo nunca se gradua (a fronteira para no destino), então ele só volta se o destino for redesenhado, e aí como um esforço novo, não como uma retomada.

Declarar algo fora do escopo é um ato de delimitação, não um passo na rota. Quando um ticket que já existe se revelar além do destino (incluído por engano no escopo durante o traçado, ou exposto por uma resolução), **feche-o** (um ticket fechado está inequivocamente fora da fronteira) e deixe uma linha na seção **Fora do escopo**: o resumo mais o porquê de estar fora do escopo, com link para o ticket fechado. Ele fica fora de **Decisões até aqui**, que registra a rota realmente percorrida; um limite de escopo não é um passo nela.

## Invocação

Dois modos. Em qualquer um, **nunca resolva mais de um ticket por sessão**, com exceção dos tickets de research.

### Trace o mapa

O usuário invoca com uma ideia solta.

1. **Dê nome ao destino.** Chame a ferramenta Skill duas vezes, uma para "grilling" e outra para "domain-modeling", para fixar até onde este mapa está encontrando o caminho: a spec, a decisão ou a mudança. O destino fixa o escopo, então ele é resolvido primeiro.
2. **Mapeie a fronteira.** Sabatine de novo, desta vez **em largura**: espalhe-se por todo o espaço em vez de se aprofundar num fio só, trazendo à tona as decisões abertas e os primeiros passos que dá para dar agora. **Se isso não revelar neblina nenhuma** (o caminho até o destino já está claro, a jornada inteira pequena o bastante para uma sessão), você não precisa de um mapa. Pare e pergunte ao usuário como ele quer seguir.
3. **Crie o mapa** (label `wayfinder:map`): Destino e Notas preenchidos, Decisões até aqui vazio, a neblina esboçada em **Ainda não especificado**.
4. **Crie os tickets que dá para especificar agora** como issues filhas do mapa e depois ligue as arestas de bloqueio numa **segunda passada** (as issues precisam de ids antes de poderem se referenciar). Escreva as referências cruzadas nessa passada também, com ids reais: um `#<n>` de placeholder vira link automático para uma issue sem relação. A ligação as separa entre a fronteira e as bloqueadas; tudo o que você ainda não consegue especificar fica na neblina: a seção **Ainda não especificado**.
5. **Dispare os subagentes de research.** Para cada ticket `research` que você acabou de criar, dispare um subagente que chama a ferramenta Skill com "research" para resolvê-lo em paralelo, registrando as descobertas num branch descartável `research/<nome>` com um ponteiro de contexto a partir do ticket. Faça push do branch, mas não abra PR: ele nunca é mergeado.
6. Pare: traçar é trabalho de uma sessão; não resolve nada à mão.

### Trabalhe o mapa

O usuário invoca com um mapa (URL ou número). O ticket é **opcional**: sem um, quem escolhe a próxima decisão é você, não o usuário.

1. Carregue o **mapa**: a visão em baixa resolução, não o corpo de cada ticket.
2. Escolha o ticket. Se o usuário indicou um, use-o. Caso contrário, pegue o primeiro ticket da fronteira, na ordem. **Assuma-o**: atribua-o a você antes de qualquer trabalho.
3. Resolva-o conforme o tipo que a label `wayfinder:<tipo>` dele indica (veja [Tipos de ticket](#tipos-de-ticket)). Leia a label, não só o corpo: o corpo nunca diz o tipo. **Dê zoom quando precisar**: busque o corpo completo de qualquer ticket relacionado ou fechado sob demanda; chame a ferramenta Skill para as skills que o bloco `## Notas` indicar. Na dúvida, chame a ferramenta Skill duas vezes, uma para "grilling" e outra para "domain-modeling".
4. Registre a resolução: publique a resposta como um **comentário de resolução**, **feche** a issue e **acrescente um ponteiro de contexto** em Decisões até aqui, no mapa.
5. Acrescente os tickets que surgiram (criar-e-depois-ligar); gradue a neblina que a resposta tornou especificável, tirando cada mancha graduada de **Ainda não especificado** para que ela viva só como o novo ticket. Se a resposta revelar que um ticket (este ou outro) está além do destino, **declare-o fora do escopo** em vez de resolvê-lo na rota. Se a decisão invalidar outras partes do mapa, atualize ou apague esses tickets.

O usuário pode rodar tickets desbloqueados em paralelo, então espere que outras sessões estejam editando o tracker ao mesmo tempo.
