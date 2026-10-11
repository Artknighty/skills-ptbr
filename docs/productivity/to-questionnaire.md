## O que faz

A `to-questionnaire` transforma uma decisão que você não consegue resolver sozinho num **questionário**: um documento Markdown que você entrega à única pessoa que tem o que te falta, para ela preencher de forma assíncrona ou para vocês dois percorrerem juntos numa reunião.

Ela te sabatina sobre o **envio**, nunca sobre o assunto. Uma entrevista sobre o tema não faz sentido, porque não conhecer o tema é justamente o motivo de você estar escrevendo para outra pessoa. Então ela pergunta as duas coisas que você sempre consegue responder (para quem isso vai e o que você precisa receber de volta) e mira cada pergunta do documento na **lacuna** entre as duas.

## Quando usar

Você invoca esta digitando `/to-questionnaire`; o [agent](https://www.aihero.dev/ai-coding-dictionary/agent) não vai recorrer a ela sozinho.

Use quando uma decisão estiver travada num conhecimento que vive na cabeça de outra pessoa: um cliente, um especialista de domínio, um diretor dono das regras de negócio, um colega de um time com o qual você não convive. A skill certa depende de onde estão as respostas:

| As respostas estão… | Use |
| --- | --- |
| Na sua própria cabeça, ainda sem forma | [grill-me](./grill-me.md) |
| Na codebase | [grill-with-docs](../engineering/grill-with-docs.md) |
| Na cabeça de outra pessoa | `to-questionnaire` |
| Na cabeça de ninguém ainda; a pergunta precisa de algo para reagir | [prototype](../engineering/prototype.md) |

O caso comum é uma sessão de [grilling](https://www.aihero.dev/ai-coding-dictionary/grilling) que empaca porque algumas das perguntas que ela levantou não cabe a você responder. Rode `/to-questionnaire` nessa mesma conversa para levar essas perguntas para fora, depois traga as respostas de volta e continue.

## O envio, não o assunto

A entrevista são duas trocas, e então ela para.

- **Para quem vai?** O papel da pessoa, a especialidade dela, a relação dela com você. Isso define o tom e quanto contexto o documento precisa carregar. Um cliente de fora precisa ser orientado; um colega de time, não.
- **O que você precisa receber de volta?** As decisões ou fatos concretos que você não consegue resolver sozinho. Isso vira o checklist do documento final. Cada item que você citar ganha uma pergunta mirada nele.

Tudo depois disso é redação. A skill grava o arquivo em `to-questionnaire-<slug>.md` no diretório atual. Não há configuração, workspace, nem nada para ajustar.

## O documento

O documento é um **questionário de descoberta**, porque falta contexto a você e a outra pessoa o tem. Isso define o formato:

- Uma linha de objetivo dizendo qual decisão depende dele, e uma seção curta de contexto para um destinatário que não conhece nada do seu histórico.
- Perguntas ordenadas **da mais importante para a menos importante** e agrupadas sob títulos por tema, porque no assíncrono você talvez só tenha uma passada.
- Uma ideia por pergunta, nunca composta, com um espaço de resposta abaixo e uma linha de *por que isso importa* só onde a pergunta puder ser mal interpretada.
- Permissão explícita para responder "não sei", porque uma incerteza sinalizada é útil, e um chute confiante que parece fato não é.
- Um fechamento genérico: tem algo que não perguntamos e que deveríamos saber?

De propósito, o documento não é duas coisas. Ele não é **ramificado**. As perguntas são uma lista plana e agrupada, não uma árvore que pula a seção D se você respondeu A. Ele também não é **para vários destinatários**. Uma execução produz um documento para uma pessoa.

## Perguntas frequentes

**Ela lê a minha sessão de sabatina e extrai as perguntas de lá?**
Não como um passo próprio. A skill não tem uma fase de ingestão. Ela pergunta sobre o envio e depois redige. O que a faz funcionar depois de uma sabatina é você rodá-la na **mesma conversa**, para que a [session](https://www.aihero.dev/ai-coding-dictionary/session) já esteja no [context](https://www.aihero.dev/ai-coding-dictionary/context) e a redação possa se apoiar nela. Se você começar numa sessão nova, ela não sabe nada da sabatina, e você mesmo fornece o assunto de novo quando responder "o que você precisa receber de volta?".

**As respostas que faltam não estão todas com a mesma pessoa. Dá para dividir por destinatário?**
Não. O primeiro passo pede *o* destinatário, no singular, e a skill ajusta o tom e o contexto do documento inteiro para essa pessoa. Se três pessoas têm três partes da resposta, rode três vezes, uma por pessoa. Já pediram um documento único que encaminhasse as perguntas por disciplina ou papel, mas isso não foi lançado.

**As perguntas são dependentes: ela pula seções com base em respostas anteriores?**
Não. O design com perguntas dependentes foi explorado e não foi lançado. A saída é um documento estático: grupos por tema, da mais importante para a menos importante, todas as perguntas valendo. A objeção a isso é justa. Um [model](https://www.aihero.dev/ai-coding-dictionary/model) que planeja mais de duas ou três perguntas à frente de uma resposta real planeja mal, e um documento ramificado precisa planejar todas elas à frente de cada resposta.

**E se o destinatário também não souber?**
O documento diz para ele falar isso. Ele pede explicitamente "não sei" e respostas parciais. Uma incerteza sinalizada vale mais do que um chute, porque uma resposta vaga e uma confiantemente errada ficam idênticas quando voltam para o seu contexto.

**Ela envia para algum lugar (Slack, issue tracker, e-mail)?**
Não. Ela grava um arquivo Markdown no diretório atual e te diz o caminho. A entrega é com você: cole num [ticket](https://www.aihero.dev/ai-coding-dictionary/ticket), solte numa thread do Slack, anexe num e-mail ou abra numa tela compartilhada e percorram ao vivo. As pessoas já fizeram as quatro coisas à mão.

**Isso não é só a `/grill-me` em modo lote?**
Não. A `grill-me` já pergunta em **rodadas**. Ela faz de uma vez toda a fronteira de perguntas abertas e depois a recalcula a partir das suas respostas, então ela já atende a necessidade de "me dá todas as perguntas de uma vez". A `to-questionnaire` difere em outro eixo. Ela trata de em que cabeça estão as respostas, não de como as perguntas são entregues. Para você mesmo responder mais rápido, use a `grill-me`. Para tirar as respostas de outra pessoa, use esta.

**Eu não poderia só pedir isso ao agente, sem uma skill?**
Poderia, e muita gente fazia isso antes de ela existir: arquivos `OPEN_QUESTIONS.md`, planilhas enviadas a clientes, um ticket de "precisa de mais informação" por pergunta sem resposta. A skill te dá duas coisas: a entrevista nunca escorrega para o assunto, e o documento sai num formato que um destinatário não técnico consegue preencher. Se você já tem um formato da casa que funciona, não precisa disto.

## Está funcionando se

- Ela pergunta sobre o destinatário e sobre o que você precisa receber, e então para de perguntar. Se perguntar sobre o próprio assunto, a skill saiu do trilho.
- Todo item que você citou como "o que preciso receber" tem uma pergunta correspondente no arquivo.
- As perguntas parecem miradas no que o *destinatário* sabe, não as suas próprias dúvidas copiadas ao pé da letra.
- Você poderia entregar o arquivo a alguém que não estava na conversa, e a pessoa saberia por que o recebeu e até quando responder.
- As respostas que voltam servem de entrada para uma nova rodada de sabatina, em vez de virarem um novo monte de perguntas.

## Onde se encaixa

A `to-questionnaire` é uma avulsa para usar a qualquer hora. Você a usa onde o seu próprio conhecimento acaba e o próximo passo é perguntar a outra pessoa, não rodar outra skill. Isso acontece mais no meio do fluxo, quando o planejamento empaca em algo que não cabe a você decidir.

A vizinha dela é a [grill-me](./grill-me.md), e as duas diferem em onde estão as respostas. A sabatina tira as respostas de você; um questionário as tira de outra pessoa. Alimente o que voltar numa nova rodada de sabatina, ou na [grill-with-docs](../engineering/grill-with-docs.md) ou na [to-spec](../engineering/to-spec.md) se o trabalho estiver indo para uma construção. Quando não tiver certeza de qual skill serve no momento, a [ask-matt](../engineering/ask-matt.md) te orienta.
