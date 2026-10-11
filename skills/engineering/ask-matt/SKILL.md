---
name: ask-matt
description: Pergunte qual skill ou fluxo se encaixa na sua situação. Um roteador sobre as skills deste repositório.
disable-model-invocation: true
---

# Ask Matt

Você não lembra de todas as skills, então pergunte.

Antes de afirmar o que uma skill faz ou recomendar pular um passo, leia o SKILL.md dessa skill: os resumos aqui servem só para orientação.

Um **fluxo** é um caminho pelas skills. A maioria dos caminhos corre por um **fluxo principal**, e duas **rampas de acesso** desembocam nele. Todo o resto é avulso, ou uma camada de vocabulário que roda por baixo.

## O fluxo principal: ideia → entrega

A rota que a maior parte do trabalho percorre. Você tem uma ideia e quer que ela seja construída.

1. **`/grill-with-docs`** afia a ideia por meio de uma sabatina. Comece por aqui sempre que estiver **trabalhando num diretório de trabalho**: ela tem estado e guarda o que aprende no `GLOSSARY.md` e em ADRs. (Sem diretório de trabalho? Use `/grill-me`, descrita em Avulsas. As duas rodam a mesma primitiva `/grilling`; `grill-with-docs` é a que deixa um rastro em papel, o que a torna a melhor das duas sempre que houver um repositório onde deixá-lo.)
2. **Bifurcação: dá para resolver todas as perguntas conversando?** Se uma pergunta precisa de uma resposta executável (estado, regra de negócio, uma UI que você precisa ver), faça um desvio por um protótipo, ligado por **`/handoff`** nas duas direções (um protótipo vive no próprio diretório, que é exatamente para o que serve o `/handoff`; veja Fronteiras de fase):
   - **`/handoff`** para sair, depois abra uma sessão nova a partir desse arquivo,
   - **`/prototype`** para responder a pergunta com código descartável,
   - **`/handoff`** de volta com o que você aprendeu, e referencie isso na conversa original da ideia.
3. **Bifurcação: é uma construção que leva várias sessões?**
   - **Sim** → **`/to-spec`** (transforma a conversa em uma spec), depois **`/to-tickets`** para dividi-la em tickets tracer-bullet, cada um declarando suas **arestas de bloqueio**. Depois trabalhe os tickets de um destes dois jeitos:
     - **`/implement`** por ticket, **rodando `/clear` no contexto entre um e outro**. Num tracker local, é um arquivo por ticket em `.scratch/<feature>/issues/`, trabalhados à mão começando pelos que bloqueiam; num tracker real, as arestas viram links de bloqueio nativos, então qualquer ticket cujos bloqueadores estejam prontos pode ser pego. Cada ticket é autocontido, então o contexto do anterior é descartável.
     - **`/implement-spec`** para a spec inteira de uma vez. Ela lê os tickets como um **grafo de tarefas**, roda subagentes implementadores em paralelo por toda a **fronteira** pronta e junta tudo em um único **branch de integração**. Use quando você preferir orquestrar a construção a conduzir cada ticket pessoalmente.
   - **Não** → **`/implement`** aqui mesmo, na mesma janela de contexto.

   Em qualquer dos casos, o código é construído conduzindo **`/tdd`** (um slice red-green por vez) e fecha com **`/code-review`**, uma revisão em dois eixos (Padrões + Spec) do diff. `/implement` roda as duas por ticket; cada implementador da `/implement-spec` conduz `/tdd`, e ela roda um único `/code-review` sobre o branch de integração. Use **`/tdd`** sozinha quando só quiser construir um comportamento concreto com teste primeiro, sem uma spec completa, e **`/code-review`** sozinha sempre que quiser revisar um branch ou PR em relação a um ponto fixo.

   Quando o trabalho sobe como pull request, **`/pr`** dá forma ao corpo: o menor visual que mostra a mudança, evidência de antes/depois de que funciona e a avaliação de porta de mão única ou de mão dupla. Ela é invocada pelo modelo, então o agente recorre a ela sempre que escreve um PR.

4. **`/retro`** fecha o ciclo. Depois de uma construção, sobretudo uma que deu errado, ela revisa a sessão e sugere mudanças no **ambiente** do agente, não no código: ponteiros de navegação, verificações automatizadas, os padrões de código que a `/code-review` aplica, arquivos de orientação, ferramentas. Erros mecânicos viram verificações determinísticas; decisões de julgamento viram padrões de código. A próxima construção então começa de um ambiente melhor.

### Higiene de contexto

Mantenha os passos 1 a 3 em **uma única janela de contexto contínua** (não compacte nem limpe até depois da `/to-tickets`), para que a sabatina, a spec e os tickets se apoiem todos no mesmo raciocínio. Cada `/implement` então começa do zero, trabalhando a partir do ticket. Rode `/retro` na sessão que ela está revisando, antes de limpar; depois de limpar, aponte-a para o log dessa sessão.

O limite disso é a **[smart zone](https://www.aihero.dev/ai-coding-dictionary/smart-zone)**: a janela (~150 mil tokens nos modelos de ponta) dentro da qual o modelo ainda raciocina com precisão. Se uma sessão se aproximar dela antes da `/to-tickets`, não siga em frente degradado; rode `/compact` na fronteira de fase mais próxima e continue (veja Fronteiras de fase).

## Rampas de acesso

Uma situação inicial que gera trabalho e depois desemboca no fluxo principal.

- **Bugs e pedidos se acumulando** → **`/triage`**. Ela move issues pelos papéis de triagem e produz issues prontas para agente, que a **`/implement`** pega depois.

  A triagem é só para issues **que você não criou**: relatos de bug, pedidos de funcionalidade que chegam, qualquer coisa que chegue crua. Tickets produzidos pela `/to-tickets` já estão prontos para agente, então **não faça triagem deles**.

- **Algo está quebrado** → **`/diagnosing-bugs`**. Para os difíceis: o bug que resiste a uma primeira olhada, a falha intermitente, a regressão que entrou entre dois estados sabidamente bons. Ela se recusa a teorizar até ter um **feedback loop enxuto** (um comando que já fica vermelho *neste* bug) e então corrige com um teste de regressão. Depois que a correção entrar, rode **`/retro`** na mesma sessão para perguntar o que teria evitado o bug; se a descoberta real for que não há um bom seam para travá-lo, isso é trabalho para a **`/improve-codebase-architecture`**.

- **Um esforço enorme e nebuloso: um projeto do zero ou uma funcionalidade enorme, grande demais para uma sessão** → **`/wayfinder`**, o fluxo mais exigente cognitivamente daqui. Quando o caminho daqui até o destino ainda não está visível, ela traça um **mapa compartilhado** de **tickets de decisão** no issue tracker e os resolve um por vez, produzindo **decisões, não entregáveis**, até a neblina recuar e o caminho ficar claro. Enquanto a **`/grill-with-docs`** afia uma ideia que cabe numa sessão, a wayfinder é para a ideia que não cabe, e é mais lenta e mais densa, então guarde-a exatamente para isso, nunca para uma funcionalidade bem delimitada.

  Quando o mapa clareia, **ela passa adiante, não constrói**: entre no fluxo principal pela **`/to-spec`**, que condensa as decisões ligadas do mapa num plano construível, e depois `/to-tickets` e `/implement` como de costume. Levar o mapa direto para a `/implement` pula essa condensação e joga fora o detalhe ligado, então vá direto para a `/implement` só quando o esforço se revelar realmente pequeno.

## Saúde do código

Não é trabalho de funcionalidade, é manutenção.

- **`/improve-codebase-architecture`** roda sempre que você tiver um tempo livre, para manter o código bom para os agentes trabalharem nele. Ela levanta **oportunidades de aprofundamento**; escolher uma _gera uma ideia_ que você pode levar para o fluxo principal pela `/grill-with-docs`. Ela é o levantamento que encontra os candidatos; a **`/codebase-design`** (abaixo) é a bancada em que você projeta o escolhido.

## Vocabulário por baixo

Duas referências invocadas pelo modelo que rodam *por baixo* das outras skills, cada uma a única fonte da verdade do seu vocabulário. Use-as diretamente quando o problema forem as **palavras**, não o processo; ou deixe as skills acima puxarem-nas.

- **`/domain-modeling`**: afia a linguagem de *domínio* do projeto: questiona um termo vago, resolve uma palavra sobrecarregada ("conta" fazendo três papéis), registra uma decisão difícil de reverter como ADR. É a disciplina ativa que a `/grill-with-docs` conduz para manter o `GLOSSARY.md` um glossário limpo.
- **`/codebase-design`** é o vocabulário de módulos profundos (módulo, interface, profundidade, seam, adapter, alavancagem, localidade) para projetar a *forma* de um módulo: muito comportamento atrás de uma interface pequena, num seam limpo. A `/tdd` e a `/improve-codebase-architecture` falam essa língua.

## Fronteiras de fase

Uma **fase** é um bloco de trabalho dentro de uma sessão: a sabatina, a implementação, o QA. Na **fronteira** entre duas delas você tem cinco opções, e escolher entre elas é a decisão mais nebulosa de todo este mapa:

- **Continuar**: ficar onde está. Não custa nada, não perde nada.
- **`/clear`**: esvazia a janela, quando nada daqui importa para o que vem a seguir.
- **`/handoff`** escreve um arquivo markdown portátil. Uso restrito: só para um **novo harness**, um **novo diretório**, um **colega**, ou para separar uma tarefa paralela **no meio de uma fase**. O que ela compra é portabilidade.
- **Subagente**: manda uma tarefa bem delimitada para a própria janela dela e recebe um relatório de volta.
- **`/compact`** comprime este contexto e inicia uma sessão nova com ele. É o **padrão**, no fundo da árvore, não a primeira opção.

Leia [PHASE-BOUNDARIES.md](PHASE-BOUNDARIES.md) para a árvore ordenada: as cinco perguntas, o raciocínio por trás de cada ramo e por que o custo da fonte primária faz de **Continuar** a primeira a ser descartada. Tome a decisão **na** fronteira; no meio de uma fase, continue ou divida o restante em subagentes.

## Avulsas

Totalmente fora do fluxo principal.

- **`/grill-me`**: a mesma entrevista implacável da `/grill-with-docs`, mas **sem estado**: não salva nada localmente e não constrói `GLOSSARY.md`. Use quando você **não estiver trabalhando num diretório de trabalho** (afiando um plano, um design, um texto, qualquer coisa sem um repositório por baixo). Se estiver num diretório de trabalho, use a `/grill-with-docs`: ela roda a mesma entrevista e deixa um rastro em papel, então é estritamente a melhor.
- **`/grilling`** é a primitiva de entrevista em si: rodadas, a fronteira, fatos são trabalho do agente e decisões são suas. `/grill-me` e `/grill-with-docs` são as duas portas de entrada nomeadas, e `/triage`, `/wayfinder` e `/improve-codebase-architecture` a rodam internamente. Use-a diretamente só quando quiser a entrevista sem nenhum invólucro.
- **`/prototype`** é um programa pequeno e descartável que responde uma pergunta de design: este modelo de estado parece certo, ou como deveria ser esta UI. Descartável é uma restrição sobre como o código é escrito, não uma promessa de destruí-lo: a resposta é incorporada ao código real, e o próprio protótipo é mantido como **fonte primária** num branch `prototype/<nome>` saindo do main, referenciado na issue de implementação. É o desvio do passo 2 do fluxo principal, mas use-a sempre que uma pergunta de design for difícil de resolver no papel.
- **`/research`**: delega o trabalho braçal de leitura a um **agente em segundo plano**: ele investiga uma pergunta em **fontes primárias** e deixa um arquivo Markdown com citações no repositório. Continue trabalhando enquanto ele lê. O arquivo produzido é algo a levar *para dentro* do fluxo principal pela `/grill-with-docs`, já que a pesquisa alimenta o raciocínio em vez de substituí-lo.
- **`/to-questionnaire`** entra quando o que está te bloqueando não está na sua cabeça nem no código, e sim na **de outra pessoa**, e escreve para ela um questionário a preencher. É o inverso da `/grill-me`: em vez de te entrevistar sobre o assunto, ela te entrevista sobre o **envio** (para quem vai, o que você precisa receber) e mira as perguntas na lacuna. O que volta é material para a `/grill-with-docs` ou a `/to-spec`.
- **`/wizard`** é para os passos que só um **humano** pode dar: provisionar infraestrutura, configurar credenciais ou secrets de CI, clicar por um painel de terceiros desconhecido, rodar uma migração ou virada pontual. Ela gera um script bash interativo que abre cada URL, captura cada valor e o grava no `.env` e nos secrets do GitHub, para que o procedimento deixe de ser algo que você reexplica a um agente toda vez. É invocada pelo modelo, então o agente recorre a ela no momento em que bate num muro que só você consegue passar. Se o agente puder simplesmente fazer sozinho, deve fazer; isto é para quando há de fato um humano no ciclo.
- **`/wait-what`** é o corretivo para uma mensagem que não fez sentido. Use no meio da conversa, dentro de qualquer outra skill, e o agente reexplica o que acabou de dizer com o contexto que estava te faltando, em português simples, usando o vocabulário do `GLOSSARY.md`. Ela age depois do fato; a `/grill-with-docs` é a cura antecipada, porque uma linguagem compartilhada combinada cedo é o que impede o jargão de sequer aparecer.
- **`/teach`**: aprenda um conceito ao longo de várias sessões, usando o diretório atual como um workspace com estado.
- **`/writing-for-agents`** é a referência para escrever documentos que agentes consomem: skills, AGENTS.md, documentos apontados.

## Pré-requisito

**`/setup-matt-pocock-skills`**: rode antes do seu primeiro fluxo de engenharia para configurar o issue tracker, as labels de triagem e a estrutura de documentos que as outras skills pressupõem. Issue trackers customizados também funcionam.
