# Fronteiras de fase

Uma **fase** é um bloco de trabalho dentro de uma sessão: a sabatina, a implementação, o QA. A definição é vaga de propósito: uma fase termina quando você pensa *"ok, isso aqui terminou"*.

A **fronteira de fase** é o intervalo entre duas fases, e é o único lugar em que esta decisão cabe. No meio de uma fase não há decisão a tomar: continue, ou divida o trabalho restante em subagentes. Compactar no meio de uma fase faz o agente perder o fio da meada.

## As cinco opções

| Opção          | O que faz                                                                 |
| -------------- | ------------------------------------------------------------------------- |
| **Continuar**  | Fica na sessão. Nenhuma troca de contexto.                                |
| **`/clear`**   | Esvazia a janela de contexto e começa do zero.                            |
| **`/handoff`** | Escreve um arquivo markdown portátil e inicia uma sessão em qualquer lugar com ele. |
| **Subagente**  | Manda a tarefa para a própria janela de contexto dela e recebe um relatório. |
| **`/compact`** | Comprime este contexto e inicia uma sessão nova com o resumo.             |

## A árvore

Percorra de cima para baixo na fronteira. O primeiro **sim** vence.

**1. Dá para continuar nesta sessão?** Duas coisas tornam a resposta sim: a próxima fase precisa desta fase como **fonte primária**, ou você ainda tem [smart zone](https://www.aihero.dev/ai-coding-dictionary/smart-zone) suficiente (~150 mil tokens) para a próxima fase caber. Sabatina → implementação é o sim clássico: a implementação quer o raciocínio na íntegra, não um resumo dele. Continuar não custa nada e não perde nada, então descarte essa opção antes de qualquer outra.

**2. O contexto é irrelevante para o que vem a seguir?** Tudo nesta sessão (a exploração, as decisões, os becos sem saída) é descartável? Se sim, **`/clear`**. É o lance mais barato do tabuleiro: não leva tempo e devolve a janela inteira. E `/clear` também não é definitivo: a sessão antiga continua retomável.

O custo de errar aqui é de mão única. Limpe um contexto *relevante* e você perde o **porquê** do que construiu, e nenhuma releitura do diff o traz de volta.

**3. Você precisa fazer handoff?** O `/handoff` é de uso restrito. Você só precisa dele quando estiver:

- trocando para um **novo harness** (Claude → Codex),
- indo para um **novo diretório** ou repositório,
- mandando o trabalho para um **colega**,
- ou separando uma tarefa paralela que você encontrou **no meio de uma fase**, sem descarrilar o que está fazendo.

Essa lista é a cláusula inteira. O que o `/handoff` compra é **portabilidade**: um arquivo que viaja. Se nada vai viajar, você não precisa dele.

**4. A tarefa pode ser feita AFK?** Ela é delimitada o bastante para rodar com você longe do teclado, sem direcionamento? Então mande para um **subagente** e deixe esta sessão intacta. Revisão automatizada é o caso clássico: o agente lê o diff e reporta, e você não é necessário enquanto isso.

**5. Senão, `/compact`.** Contexto relevante, mesmo harness, mesmo diretório, e você precisa continuar no ciclo: é aqui que a árvore termina, e termina aqui com frequência. Passe uma instrução (`/compact vamos fazer o QA desta área`) para que o resumo mantenha o que a próxima fase precisa.

`/compact` é o **padrão, não a primeira opção**. Fica no fundo porque as quatro perguntas acima são todas mais baratas ou mais precisas. O modo de falha de quem começa por aqui é uma sessão nova que está confiantemente errada sobre uma decisão que o resumo achatou.

## Fontes primárias e secundárias

Todo lance exceto **Continuar** transforma uma **fonte primária** numa **fonte secundária**: a sessão como aconteceu, substituída por um resumo dela. A troca tem sempre o mesmo formato:

| Fonte                               | Informação | Ruído  | Espaço para trabalhar |
| ----------------------------------- | ---------- | ------ | --------------------- |
| Primária (Continuar)                | Completa   | Muito  | Pouco                 |
| Secundária (`/compact`, `/handoff`) | Com perdas | Menos  | Muito                 |

É por isso que a pergunta 1 vem primeiro. Você só paga a perda quando ficar custa mais do que economiza.

## São decisões de julgamento

As perguntas não são objetivas: cada uma carrega gosto pessoal, e a mesma fronteira pode ir para dois lados em dois dias diferentes. O valor está em fazê-las **em ordem**, na fronteira, e não no meio do trabalho.
