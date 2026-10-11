## O que faz

A `domain-modeling` constrói e afia a **linguagem ubíqua** de um projeto enquanto você projeta. Ela questiona um termo que conflita com o glossário, pede uma palavra precisa onde você usou uma vaga e testa uma relação contra um cenário concreto até as fronteiras ficarem exatas.

Ela é a disciplina **ativa**, não a passiva. Qualquer skill pode ler o `GLOSSARY.md` para emprestar o vocabulário. Esta skill é para quando você está *mudando* o modelo, e é por isso que ela te interrompe. Ela escreve um termo no `GLOSSARY.md` no momento em que você o fixa, no meio da conversa, em vez de produzir um glossário arrumado no final. Um glossário escrito no final é um resumo de uma [session](https://www.aihero.dev/ai-coding-dictionary/session); a versão escrita no caminho é a saída da sessão.

## Quando usar

Digite `/domain-modeling`, ou o agente recorre a ela automaticamente quando uma tarefa se encaixa. Na prática, a invocação automática é a parte mais fraca da skill. Quando a `grill-with-docs` ou a `wayfinder` mandam carregá-la, os [models](https://www.aihero.dev/ai-coding-dictionary/model) muitas vezes carregam a `grilling` e pulam esta. Se uma sessão de [grilling](https://www.aihero.dev/ai-coding-dictionary/grilling) rodar e o `GLOSSARY.md` estiver igual no final, foi isso que aconteceu. Invoque-a pelo nome junto com a outra skill.

Use quando o problema forem as *palavras*:

| A situação | O movimento |
| --- | --- |
| Duas pessoas querem dizer coisas diferentes com "cancelamento" | `domain-modeling`: escolha o termo canônico, liste o outro em `_Evitar_` |
| "Conta" está fazendo três papéis em três arquivos | `domain-modeling`: divida em Cliente e Usuário |
| Você acabou de fazer uma escolha de arquitetura difícil de reverter | `domain-modeling`: ela oferece um ADR, se a escolha passar na régua |
| O problema é a *forma* do módulo: onde fica o seam, quão profunda é a interface | [codebase-design](./codebase-design.md) |
| Você quer o plano inteiro interrogado antes de construir | [grill-with-docs](./grill-with-docs.md), que conduz esta skill por baixo |
| Você quer consultar um termo, não mudá-lo | Nada. Leia o `GLOSSARY.md`. É um arquivo. |

## Pré-requisitos

Nenhum de antemão. A skill escreve em dois lugares e cria os dois sob demanda:

- **`GLOSSARY.md`** na raiz do repositório. A skill o cria quando você fixa o primeiro termo. Num repositório com um `GLOSSARY-MAP.md` na raiz, os termos vão para o `GLOSSARY.md` de cada contexto para o qual o mapa aponta.
- **`docs/adr/`**. A skill o cria com o primeiro ADR que passar na régua.

Nada precisa existir antes de você começar, e a skill não cria nada antecipadamente.

## Dois artefatos, duas réguas

O glossário e o ADR têm réguas diferentes. A maior parte dos problemas com esta skill vem de misturar as duas.

| | `GLOSSARY.md` | `docs/adr/NNNN-slug.md` |
| --- | --- | --- |
| Guarda | Termos. O que uma coisa **é**, em uma ou duas frases, com os sinônimos rejeitados em `_Evitar_` | Uma decisão, em uma a três frases: contexto, escolha, motivo |
| Régua para escrever | Um termo vago virou canônico | **As três**: difícil de reverter, surpreendente sem contexto, resultado de um trade-off real |
| Escrito | No caminho, no momento em que o termo é fixado | Oferecido, não presumido |
| Nunca guarda | Detalhes de implementação, uma [spec](https://www.aihero.dev/ai-coding-dictionary/spec), rascunhos, conceitos gerais de programação | Um diário de cada escolha feita nesta sessão |

Falhe em qualquer um dos três testes do ADR e não há ADR. Uma decisão fácil de reverter vai simplesmente ser revertida; uma não surpreendente não é pergunta de ninguém; uma sem alternativa real registra que vocês fizeram o óbvio.

A regra do `GLOSSARY.md` é a que mais importa, porque é a que quebra na prática. **Ele é um glossário e nada mais.** Sem controle, os modelos tratam "escreva no `GLOSSARY.md`" como permissão para guardar cada resposta que você dá, e o arquivo vira uma spec corrente. Esse é o problema mais relatado da skill, em vários modelos.

## Cruzamento com o código, e onde ele para

Quando você diz como algo funciona, a skill confere o código e aponta qualquer contradição. *"Seu código cancela Pedidos inteiros, mas você acabou de dizer que o cancelamento parcial é possível; o que está certo?"* A skill faz a linguagem e o código concordarem, em voz alta, antes de mudar qualquer um dos dois.

Ela cruza com o **código** e com o `GLOSSARY.md` e os ADRs versionados, e mais nada. Ela não procura no seu issue tracker. Se o seu time discutiu uma colisão de nomes e a resolveu numa issue fechada há meses, a skill a levanta de novo como se fosse nova. Existe [um pedido aberto](https://github.com/mattpocock/skills/issues/717) para corrigir isso. Até lá, a solução é colocar a instrução no seu próprio `docs/agents/domain.md`, que as skills já leem.

## Perguntas frequentes

**Meu `GLOSSARY.md` tem 500 linhas. 1.000. 3.000. O que eu faço?**
O tamanho é um sintoma. A causa é que o arquivo absorveu detalhes de implementação e decisões que nunca pertenceram a um glossário. A correção é uma instrução direta: `/grill-with-docs deixe meu GLOSSARY.md mais conciso e remova qualquer detalhe de implementação dele`. Rode isso num arquivo inchado e a maior parte vai embora. Só divida com um `GLOSSARY-MAP.md` quando o arquivo estiver enxuto e ainda cobrir dois domínios que um leitor não ia querer manter na cabeça ao mesmo tempo. Dividir um arquivo inchado te dá vários arquivos inchados. A orientação da skill aqui ainda não é forte o bastante para impedir o crescimento logo de início, e a issue que acompanha isso continua aberta.

**Por que o arquivo se chamava `CONTEXT.md` e agora se chama `GLOSSARY.md`?**
(Nota da tradução: no original, esta pergunta ficou ilegível depois de uma substituição automática de nomes; abaixo está o sentido da discussão.) Era a questão de nome mais discutida de todo o conjunto de skills. O argumento contra `CONTEXT.md` era bom: se o arquivo é "um glossário e nada mais", `GLOSSARY.md` diz isso, e, como disse um leitor, "com agentes de IA, tudo é [context](https://www.aihero.dev/ai-coding-dictionary/context)". O argumento a favor era o mapa: um mapa apontando para vários arquivos de contexto se lia de forma natural, e `context` é a palavra padrão do DDD para uma área delimitada do modelo. As skills hoje usam `GLOSSARY.md` e `GLOSSARY-MAP.md`, e todas procuram exatamente esses nomes, então renomear o arquivo de novo significa ajustar todas elas.

**Para onde foi a `/ubiquitous-language`?**
Foi removida, e não descontinuada. O trabalho dela passou para a `domain-modeling`, que mantém o modelo inteiro continuamente em vez de despejar um glossário a partir de uma conversa. Impor o vocabulário agora importa mais, não menos. Isso roda por baixo da sabatina, da triagem e do mapeamento, em vez de ser uma passada separada de que você precisa lembrar.

**Como eu consigo um glossário para uma codebase que não tem nenhum?**
Peça explicitamente em vez de esperar ele se acumular. `/grill-with-docs me ajude a montar um GLOSSARY.md para o meu repositório existente` é o caminho documentado. Espere um interrogatório longo. Um usuário relatou mais de 50 perguntas antes de o arquivo ficar em forma. O uso incidental constrói o glossário devagar demais num repositório legado.

**Posso manter o modelo de domínio e usar o meu próprio formato de ADR?**
Hoje, não de forma limpa. A metade do glossário e a metade do ADR vêm na mesma skill, então um time com uma convenção de ADR estabelecida (outro modelo, outro local, outra nomenclatura) recebe instruções que conflitam com o estilo da casa. As opções atuais são copiar a skill localmente e editá-la, ou sobrescrever as convenções de ADR na documentação para agentes do seu próprio repositório. Separar as duas coisas é [um pedido aberto](https://github.com/mattpocock/skills/issues/557).

**Um glossário compensa de verdade? É mais um artefato para revisar, e ele pode ficar desatualizado.**
Às vezes não compensa. O DDD fica menos útil quanto mais perto chega da implementação. O retorno está antes, no nome das coisas e no alinhamento de conceitos, não em aggregates e cerimônia de camadas. O controle de sinônimos importa nas fronteiras de nomenclatura: nomes de módulos, nomes de tabelas, enums de status, títulos de issues, comandos de CLI. Importa bem menos na prosa comum. Há também a objeção de que termos de domínio comprimem a comunicação *entre humanos* que já os compartilham, e de que um agente responde do mesmo jeito à descrição em linguagem comum. Nessa leitura, o valor do glossário é manter você e quem revisa alinhados com o que o agente está fazendo, não deixar o agente melhor. Numa construção de um dia, pule. E um glossário escrito por um agente e não revisado é pior do que nenhum: ele se enche de afirmações confiantes que as sessões seguintes tratam como verdade.

**Ela consegue transformar os meus prompts vagos em linguagem de domínio para mim?**
Não, e não há plano para uma skill que faça isso. Uma linguagem de domínio que você mesmo não entende não significa nada depois de escrita. Esta skill impõe precisão depois que você tem o entendimento; ela não inventa um vocabulário que você não tem. A armadilha relacionada é usar palavras de domínio sem fazer a modelagem. Os substantivos certos em cima dos conceitos errados produzem uma saída que parece correta e não é.

## Está funcionando se

- Ela te para no meio da frase para perguntar qual de duas coisas você quis dizer, em vez de escolher uma e seguir em frente.
- O `GLOSSARY.md` muda **durante** a conversa, não numa leva no final.
- Ela se recusa a escrever um ADR para algo que você poderia desfazer amanhã, e diz qual dos três testes falhou.
- As entradas novas definem o que uma coisa *é* em uma ou duas frases e citam em `_Evitar_` as palavras de que você está abrindo mão.
- Ela cita o seu código de volta para você quando o código e a sua frase discordam.
- O `GLOSSARY.md` encolhe com a mesma frequência com que cresce.

## Onde se encaixa

A `domain-modeling` é uma **referência invocada pelo modelo** que roda *por baixo* de outras skills com mais frequência do que sozinha. A [grill-with-docs](./grill-with-docs.md) a conduz por meio de uma sessão de sabatina, a [wayfinder](./wayfinder.md) a carrega enquanto traça um mapa, a [triage](./triage.md) a usa para manter os [tickets](https://www.aihero.dev/ai-coding-dictionary/ticket) nas palavras do próprio projeto, e a [improve-codebase-architecture](./improve-codebase-architecture.md) a chama conforme as decisões se firmam. A irmã mais próxima é a [codebase-design](./codebase-design.md). Juntas, elas são a camada de vocabulário por baixo de todo o resto: esta para o *domínio*, aquela para a *forma* do módulo. Ela também pode ser acessada diretamente, quando você quer a disciplina sem se comprometer com os passos da skill que normalmente a carregaria. Quando não tiver certeza de qual skill serve, a [ask-matt](./ask-matt.md) te orienta.
