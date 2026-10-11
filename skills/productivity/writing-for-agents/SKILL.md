---
name: writing-for-agents
description: Como escrever documentos para agentes. Use ao criar ou editar skills, ou ao modificar AGENTS.md ou CLAUDE.md.
---

Referência para escrever qualquer documento que um agente consome: uma skill, um `AGENTS.md` / `CLAUDE.md`, um documento alcançado por um ponteiro. A embalagem muda; a escrita não: as mesmas alavancas tornam cada um previsível, já que o agente segue o mesmo _processo_ a cada execução, em vez de produzir a mesma saída.

Quando o documento que você está escrevendo for uma skill, leia [`SKILL-MECHANICS.md`](SKILL-MECHANICS.md) para frontmatter, escolha de invocação e skills roteadoras.

## Ponteiros de contexto

Um **ponteiro de contexto** é uma referência mantida no contexto do agente que nomeia algum material fora do contexto e codifica a condição para alcançá-lo. A descrição de uma skill é um; uma linha no `AGENTS.md` nomeando um documento é o mesmo objeto. É a _redação_ do ponteiro, não o alvo, que decide quando o agente alcança o material, e com que confiabilidade. Um alvo indispensável atrás de um ponteiro mal redigido é um bug de variância: afie a redação primeiro, e só coloque o material inline se afiar não resolver.

Um ponteiro faz dois trabalhos: dizer o que o material é e listar os **ramos** que devem disparar o acesso a ele (um ramo é um caso distinto que o documento trata, de modo que execuções diferentes seguem caminhos diferentes por ele). Cada palavra de um ponteiro sempre carregado custa a cada turno, então ele merece uma poda ainda mais dura que o corpo:

- **Ponha a palavra-guia na frente**: o ponteiro é onde ela faz o trabalho de gatilho.
- **Um gatilho por ramo.** Sinônimos que renomeiam um único ramo são um ramo escrito duas vezes; junte-os e mantenha só ramos realmente distintos.
- **Corte a identidade que o corpo já carrega.**

## As duas cargas

Todo documento e ponteiro que você acrescenta gasta um de dois orçamentos:

- **Carga de contexto** é o custo do material sempre carregado na janela do agente: uma linha do `AGENTS.md`, uma descrição de skill, qualquer coisa que fique no contexto a cada turno, gastando tokens e atenção quer dispare, quer não.
- **Carga cognitiva** é o custo para o humano: quais documentos existem e quando recorrer a cada um. O humano é o índice. Não é um custo a minimizar: é o preço da agência humana; gaste-o onde o julgamento humano importa e remova-o onde não importa.

Material alcançado só por um ponteiro escapa da carga de contexto ao preço da linha do próprio ponteiro; material sem ponteiro nenhum depende inteiramente da carga cognitiva.

## Hierarquia de informação

Um documento é feito de dois tipos de conteúdo: **passos** (as ações ordenadas que o agente executa) e **referência** (definições, regras, fatos consultados sob demanda). Os dois se misturam livremente: só passos (uma receita), só referência (as regras de uma revisão, esta skill) ou ambos. A decisão central é onde cada parte fica na **hierarquia de informação**, uma escada ordenada por quão imediatamente o agente precisa do material:

1. **Passo no arquivo** é o nível principal: o que o agente faz, em ordem.
2. **Referência no arquivo** é consultada sob demanda. Muitas vezes é legitimamente um conjunto plano de pares (todas as regras de uma revisão no mesmo degrau), o que é um arranjo correto, não um cheiro.
3. **Referência separada** é empurrada para um arquivo separado, alcançada por um ponteiro de contexto, carregada só quando o ponteiro dispara. Vai de um arquivo irmão na mesma pasta até referência totalmente externa, que vive em qualquer lugar e para a qual qualquer documento pode apontar.

Empurre pouco para baixo e o topo incha; empurre demais e você esconde material de que o agente realmente precisa. Essa tensão é a decisão inteira.

**Progressive disclosure** (revelação progressiva) é o movimento escada abaixo (para fora do arquivo principal e para trás de um ponteiro) para que o topo continue legível. Não é principalmente uma otimização de tokens: é como a hierarquia é protegida. A ramificação é o teste mais limpo para decidir o que separar: deixe inline o que todo ramo precisa e empurre para trás de um ponteiro o que só alguns ramos alcançam. Quando um documento tem passos, uma referência no arquivo que deveria estar separada os soterra e transforma prestar atenção neles num cara ou coroa: uma alavanca de variância, não só de legibilidade.

**Co-localização** é a companheira dentro do arquivo: enquanto a escada decide _quão abaixo_ uma parte fica, a co-localização decide _o que fica ao lado dela_ uma vez lá. Mantenha a definição, as regras e as ressalvas de um conceito sob um único título, em vez de espalhadas, para que ler uma parte traga as vizinhas junto. O teste: o documento deve parecer documentação escrita para o agente. Material agrupado lê assim; material espalhado, não. (Diferente de duplicação: duplicar repete um significado em dois lugares; espalhar fragmenta um significado em muitos.)

**Inchaço** (sprawl) é o modo de falha aqui: um documento simplesmente longo demais, mesmo quando cada linha está viva e é única. A atenção se dilui no excesso, e cada linha extra é mais uma a manter relevante. A cura é a escada: mova a referência para trás de ponteiros e divida por ramo ou sequência para que cada caminho carregue só o que precisa.

## Passos e critérios de conclusão

Todo passo termina em um **critério de conclusão**, a condição que diz ao agente que o trabalho está feito. Duas propriedades fazem dele uma alavanca:

- **Clareza**: o agente consegue distinguir feito de não feito? Um limite vago ("entendimento alcançado") convida à **conclusão prematura**: encerrar o passo antes de ele estar realmente feito, com a atenção escorregando para _estar pronto_. Os passos visíveis que ainda vêm (os **passos pós-conclusão**) fazem a força de atração; a clareza do critério é a resistência. Defenda nesta ordem: **afie o limite primeiro** (local e barato); só se ele for irredutivelmente vago _e_ você observar a pressa, esconda os passos seguintes dividindo a sequência. Esconder só funciona atravessando uma fronteira real de contexto (um handoff ou o despacho de um subagente; uma chamada inline deixa os passos seguintes no contexto e não limpa nada).
- **Exigência**: quanto ele requer. "Todo modelo modificado contabilizado" força trabalho minucioso onde "produza uma lista de mudanças" não força. A exigência impulsiona o **trabalho braçal** (a escavação que o agente faz dentro do trabalho, latente na redação em vez de escrita como passo próprio), e não está presa a passos: "toda regra aplicada" amarra um corpo de referência plana assim como "todo passo feito" amarra uma sequência, e é assim que um documento só de referência ainda carrega um nível de exaustividade.

Os critérios mais fortes são verificáveis e exaustivos.

## Quando dividir

Dividir um documento em dois gasta uma das duas cargas, então divida só quando o corte compensar:

- **Por sequência**: divida uma série de passos quando os passos pós-conclusão tentarem o agente a apressar o que está à frente dele. Mantê-los fora de vista gera mais trabalho braçal na tarefa atual. Cuidado com o inverso: juntar sequências expõe cada passo aos passos que vêm depois, convidando à conclusão prematura.
- **Por invocação**, específico de skills: veja [`SKILL-MECHANICS.md`](SKILL-MECHANICS.md).

## Palavras-guia

Uma **palavra-guia** é um conceito compacto que já vive no pré-treinamento do modelo e com o qual o agente pensa enquanto executa o documento (_lição_, _névoa de guerra_, _tracer bullets_). Repetida como token, nunca como frase, ela acumula uma definição distribuída e ancora toda uma região de comportamento com o mínimo de tokens, recrutando conhecimento prévio que o modelo já tem. Cunhar a sua própria funciona se você a definir com clareza, mas uma palavra inventada não recruta nada: você paga em tokens de definição o que uma palavra pré-treinada dá de graça; procure primeiro uma palavra existente.

Ela ancora duas vezes. No corpo, a _execução_: o agente recorre ao mesmo comportamento toda vez que a palavra aparece, e dentro de uma referência plana ela foca a atenção numa classe de coisa a procurar. Num ponteiro, a _invocação_: quando a mesma palavra vive nos seus prompts, nos seus documentos e no seu código, o agente liga essa linguagem compartilhada ao material e o alcança com mais confiabilidade.

Cace oportunidades de refatorar com palavras-guia. Uma tríade escrita por extenso em três lugares, um ponteiro gastando uma frase para acenar para uma ideia. Cada um é um trecho implorando para colapsar num único token:

- "rápido, determinístico, de baixo overhead" → _enxuto_ (um ciclo _enxuto_).
- "um ciclo em que você acredita" → _vermelho_, transformando uma condição vaga num estado binário observável (o ciclo fica _vermelho_ no bug, ou não fica).

Você ganha duas vezes: menos tokens e um gancho mais afiado para o agente pendurar o raciocínio. Suponha que todo documento carrega reformulações que palavras-guia aposentariam. Vá encontrá-las.

**Negação** é o modo de falha ao lado desta alavanca: guiar por proibição arrasta o comportamento proibido para o contexto e o torna _mais_ disponível, não menos. _Não pense num elefante_, e o elefante é tudo o que existe; a negação é um modificador fraco que o conceito fortemente ativado atropela, então a proibição é meio lida como instrução para fazer a coisa. Formule no **positivo**: diga o comportamento-alvo ("escreva comentários de uma linha") para que o proibido nunca seja dito. Uma proibição só merece lugar como uma barreira rígida que você não consegue formular de forma positiva; mesmo assim, junte-a ao alvo positivo para que a atenção caia no que fazer.

## Poda

- Mantenha cada significado em uma **única fonte da verdade**: um lugar com autoridade, para que mudar o comportamento seja uma edição num só lugar. **Duplicação** (o mesmo significado em mais de um lugar) custa manutenção e tokens, e infla a proeminência de um significado na escada além da posição real dele. (O inverso acidental de uma palavra-guia, que repete um token de propósito, nunca o significado.)
- O **ambiente** também é uma fonte da verdade (scripts do `package.json`, arquivos de configuração, a estrutura de diretórios, a saída de `--help`), e um documento que o repete é um **cache**: uma cópia de uma consulta, que só compensa a carga quando a consulta é cara. Faça cache do que o agente não consegue descobrir olhando: a convenção não escrita, o motivo por trás de uma escolha, a pegadinha que nenhuma configuração confessa. Deixe as consultas de um arquivo ou um comando para o ambiente, onde não ficam obsoletas.
- Verifique cada linha quanto à **relevância**: ela ainda tem a ver com o que o documento faz? Uma linha perde relevância por nunca ter a ver com a tarefa (mera exposição, ou um ramo que deveria estar num arquivo separado) ou por ficar obsoleta conforme o comportamento ou o mundo que ela descreve muda. Documentos mais curtos são mais fáceis de manter relevantes. Sem disciplina de poda, o destino padrão é o **sedimento**: camadas obsoletas que se acumulam porque acrescentar parece seguro e remover parece arriscado, até você precisar perfurar todas elas para achar o que ainda está vivo.
- Cace **no-ops** frase a frase: uma instrução que o modelo já obedece por padrão paga carga para não dizer nada. O teste (ela muda o comportamento em relação ao padrão?) é relativo ao modelo, não ao leitor: duas pessoas discordando sobre um no-op discordam sobre o padrão, e resolvem isso executando o documento, não debatendo. Quando uma frase reprovar, apague a frase inteira em vez de aparar palavras dela. O teste também avalia palavras-guia: uma palavra fraca demais para vencer o padrão (_seja minucioso_ quando o agente já é mais ou menos minucioso) é um no-op, e a correção é uma palavra mais forte (_implacável_), não outra técnica.
