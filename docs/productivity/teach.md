## O que faz

A `teach` transforma o diretório em que você a roda num workspace de ensino permanente e te ensina um assunto ao longo de muitas [sessions](https://www.aihero.dev/ai-coding-dictionary/session), em lições HTML curtas e autocontidas.

Ela não ensina a partir do que o [model](https://www.aihero.dev/ai-coding-dictionary/model) já sabe. Ela trata o [parametric knowledge](https://www.aihero.dev/ai-coding-dictionary/parametric-knowledge) (conhecimento paramétrico) como não confiável. Antes de ensinar, ela encontra recursos de alta confiança, registra-os no `RESOURCES.md` e os cita dentro de cada lição. Ela também é [stateful](https://www.aihero.dev/ai-coding-dictionary/stateful) (com estado). A missão, os recursos, as lições e o registro do que você aprendeu vivem todos como arquivos no diretório, então a próxima sessão continua a partir desses arquivos, não do que sobrou da última conversa.

## Quando usar

Você invoca esta digitando `/teach`; o [agent](https://www.aihero.dev/ai-coding-dictionary/agent) não vai recorrer a ela sozinho.

Use quando o aprendizado for o projeto: uma linguagem, um framework, uma codebase em que você acabou de entrar, yoga, shaders, uma certificação. Ela não é a ferramenta para uma explicação de passagem.

| O que você quer | A que recorrer |
| --- | --- |
| Aprender um assunto ao longo de semanas, com sessões que se acumulam | `teach` |
| Uma ideia explicada dentro da sessão em que você já está | Só pergunte, nessa sessão |
| A última mensagem do agente explicada de novo porque não fez sentido | [wait-what](./wait-what.md) |
| Afiar um raciocínio que você já tem, em vez de adquirir material novo | [grill-me](./grill-me.md) |
| Um agente em segundo plano que leia [primary sources](https://www.aihero.dev/ai-coding-dictionary/primary-source) e te deixe um documento com citações | [research](../engineering/research.md) |
| Aprender algo que apareceu no meio de uma sabatina, sem descarrilar a [grilling](https://aihero.dev/ai-coding-dictionary/grilling) | [handoff](./handoff.md) para um workspace de ensino, e então `teach` lá |

## Pré-requisitos

A `teach` monta um diretório em vez de produzir um arquivo, e a skill pressupõe uma missão por workspace, então rode-a num lugar que você aceite dedicar a um único assunto. Mantenha-a fora do projeto em que você está trabalhando. Um repositório separado é o melhor lar, melhor do que uma pasta global `~/.learnings/` ou o próprio projeto de trabalho. Um repositório dedicado também permite fazer commit das lições, que é como times as têm compartilhado.

O que se acumula nesse diretório:

| Caminho | O que guarda |
| --- | --- |
| `MISSION.md` | Por que você está aprendendo isso. Todo outro arquivo depende dele. Se estiver faltando, a primeira coisa que a `teach` faz é te entrevistar até ele existir |
| `RESOURCES.md` | As fontes verificadas das quais ela ensina, divididas em Conhecimento e Sabedoria (comunidades) |
| `lessons/*.html` | As lições numeradas: a unidade principal de ensino |
| `reference/*.html` | Cheat sheets comprimidos, algoritmos, glossários: os documentos aos quais você volta |
| `learning-records/*.md` | Notas no estilo de ADR sobre o que você comprovadamente aprendeu, usadas para decidir o que ensinar em seguida |
| `assets/*` | Componentes reutilizáveis, começando por uma folha de estilo compartilhada, para que as lições pareçam um curso só |
| `NOTES.md` | As suas preferências de ensino declaradas |

Duas observações sobre essa lista. Um glossário serve para a maioria dos assuntos, mas a skill traz um `GLOSSARY-FORMAT.md` para o qual o `SKILL.md` não aponta mais, então você só ganha um se pedir ([issue #559](https://github.com/mattpocock/skills/issues/559)). Tudo isso cai no diretório em que você rodou `/teach`.

## Força de armazenamento, não fluência

A palavra para pensar é **força de armazenamento**: retenção de longo prazo, em oposição à **fluência**, a lembrança do momento que parece domínio enquanto você está lendo e some uma semana depois. A `teach` constrói a primeira por meio de dificuldade desejável: prática de recuperação, espaçamento, intercalação. O conhecimento vem primeiro. Nessa etapa a dificuldade joga contra você, porque consome a memória de trabalho de que você precisa para entender. Depois a `teach` treina a habilidade por meio de um feedback loop curto, e nessa etapa a dificuldade é a ferramenta.

Duas coisas decidem o que você aprende. A **missão** (o motivo concreto, do mundo real, pelo qual você quer isso) é a base de toda lição. Sem ela, as lições ficam abstratas e nada decide o que vem a seguir. A partir da missão e dos registros de aprendizado, a `teach` escolhe a próxima lição dentro da sua **zona de desenvolvimento proximal**: difícil o bastante para exigir esforço, mas não tão à frente que você não consiga aprender.

A força de armazenamento também é o motivo de a skill questionar em vez de concordar. Uma pergunta que exige **sabedoria** (julgamento do mundo real) recebe uma tentativa de resposta e depois uma indicação de uma comunidade onde você pode testá-la. A skill não te deixa pular um quiz. Um usuário relatou que disse "valeu demais" e ouviu que o treino ainda não tinha acabado.

## Lições, referências e componentes

Uma **lição** é um único arquivo HTML autocontido, curto o bastante para terminar de uma vez, amarrado à missão, que te dá uma vitória tangível. Ela cita as fontes, recomenda uma fonte primária para você ler por conta própria e linka para lições irmãs e documentos de referência.

Você raramente volta a uma lição, mas volta aos documentos de referência. Então a forma curta de uma lição (a tabela de sintaxe, o algoritmo, a sequência de posturas, o glossário) pertence a `reference/`, não enterrada na lição que a apresentou.

As lições são montadas a partir de **componentes** em `assets/`: folhas de estilo, widgets de quiz, simuladores, auxiliares de diagrama. Reaproveitar é o padrão. O agente lê `assets/` antes de escrever uma lição e constrói a partir do que já está lá. Ele escreve qualquer coisa nova que uma segunda lição poderia usar como componente, não inline. A folha de estilo compartilhada é o primeiro componente de todo workspace, e é ela que faz as lições parecerem um curso só em vez de várias páginas sem relação.

## Perguntas frequentes

**Onde ela coloca os arquivos? Os meus foram parar em `~/.claude/skills`.**
No diretório em que você rodou `/teach` ([#377](https://github.com/mattpocock/skills/issues/377)).

**Fico numa sessão só ou começo uma nova por lição?**
As três abordagens funcionam: ficar na mesma sessão, invocar `/teach` de novo numa sessão nova, ou abrir uma sessão nova na mesma pasta. Cada lição é uma invocação própria. O estado do curso vive na pasta, não na conversa. O comum é abrir uma sessão nova no workspace e dizer `/teach próxima lição de <assunto>`.

**Como eu sei que ela não está me ensinando algo inventado?**
Não sabe, só pela palavra da skill. Você lê as fontes primárias. A `teach` não é confiável o bastante para ser aceita sem conferência, e nenhuma skill construída sobre um LLM é. A ancoragem (`RESOURCES.md`, citações em toda lição, uma fonte primária recomendada por lição) torna barato conferir uma lição. Ela não elimina a necessidade de conferir. Essa falha já aconteceu: um usuário aprendendo o cubo mágico 2x2 recebeu sequências de movimentos inventadas que não resolvem o cubo. Num caso assim, verifique o modelo, o harness, o nível de esforço e a fonte. O risco é maior em domínios procedurais com notação precisa, e menor onde a saída é verificável na hora, como código que dá para rodar.

**A resposta certa do quiz é sempre a primeira opção.**
Várias pessoas confirmaram isso no Sonnet, no Opus e no GLM, e continua sem correção. O `SKILL.md` agora exige que toda resposta tenha o mesmo número de palavras. Isso tira outra pista (a resposta certa costumava ser a única bem justificada), mas não diz nada sobre a posição. Um contribuidor testou uma correção para a posição no nível da instrução, e a resposta certa ainda caiu na opção A 33 de 33 vezes em nove lições ([#335](https://github.com/mattpocock/skills/issues/335)). Então a correção real é um componente de quiz em `assets/` que embaralhe as respostas, não uma redação melhor. Até isso sair, ignore a posição da resposta. O seu diretório `assets/` é seu para mudar, então você pode pedir um componente que embaralhe na renderização como correção local.

**Ela supôs que eu já sabia coisas e usou termos que nunca definiu.**
Esta é a reclamação real mais comum. Não existe uma etapa de avaliação. A `teach` deduz o seu nível a partir da missão e dos registros de aprendizado, e na primeira sessão não há registro nenhum. Um usuário que a rodava dentro de um pipeline da wayfinder resumiu assim: "Ela nunca fez uma sabatina para estabelecer meu ponto de partida, então fez um monte de suposições sobre o que eu já sabia." Outro relatou lições com jargão não definido, e uma lição sobre o hardware dele que cobria o que o hardware fazia, mas nunca dizia o que ele não fazia. Duas coisas ajudam: diga o seu conhecimento prévio e as suas lacunas na primeira mensagem, e corrija o nível em voz alta quando uma lição errar o alvo, porque a correção vira um registro de aprendizado e orienta a próxima. Uma etapa explícita de avaliação de conhecimento é um pedido de funcionalidade em aberto ([#725](https://github.com/mattpocock/skills/issues/725)), não um comportamento já disponível.

**Ela faz repetição espaçada, e sabe quando parar de ensinar?**
Não para a primeira, e não de forma confiável para a segunda. A skill monta lições em torno de espaçamento e intercalação, mas nada agenda uma revisão, e não há integração com Anki nem com calendário. Os usuários pedem as duas coisas com frequência. Uma lacuna relacionada são os critérios de saída. Como disse um usuário, a `teach` "é boa em fazer a próxima lição, mas não tão boa em saber quando parar e passar para revisão ou prática real". Se você quiser revisão ou treino em vez de material novo, peça; a skill não vai propor a mudança sozinha.

**Ela só serve para código?**
Não. A maior parte do uso relatado é fora da programação: coreano, registro formal do japonês, piano, violão, design de jogos de tabuleiro, OpenSCAD, enredos de filmes, certificações Azure e CCNA, provas de faculdade, e crianças de oito e dez anos ganhando livros para imprimir sobre escape rooms e salamandras-de-fogo. Nada na skill é específico de programação. Missão, recursos, zona de desenvolvimento proximal e treino funcionam do mesmo jeito em qualquer domínio. Dentro do código, os usuários relatam mais valor em se orientar numa codebase desconhecida ou na stack de um time novo do que em aprender uma linguagem do zero.

**Com qual modelo devo rodá-la?**
Não há resposta canônica, e as diferenças relatadas são grandes. Os usuários relatam que um [reasoning effort](https://www.aihero.dev/ai-coding-dictionary/effort) maior produz lições melhores do que o nível médio. Um usuário rodou a mesma skill pela Copilot CLI com o Codex e recebeu um único card HTML de 30 linhas onde o Claude Code produziu uma lição completa. Ela roda sem modificação no Claude Cowork, se a sua organização permitir adicionar skills lá. Se as lições saírem rasas, troque o modelo, o [harness](https://www.aihero.dev/ai-coding-dictionary/harness) ou o esforço antes de reescrever o seu prompt.

## Está funcionando se

- A primeira coisa que ela faz num diretório vazio é te entrevistar sobre por que você quer isso, em vez de produzir uma lição.
- O `RESOURCES.md` se enche antes das lições, e cada lição cita uma fonte primária que vale ler por conta própria.
- As afirmações de uma lição têm links para fora. Uma lição sem citações é a skill ensinando de memória.
- Uma lição se faz de uma vez só e te deixa capaz de fazer uma coisa que você não conseguia antes.
- Abrir uma sessão nova na pasta e dizer "próxima lição" continua o curso em vez de recomeçá-lo.
- A pasta `learning-records/` cresce, e as lições param de ensinar de novo o que você já demonstrou.
- As lições parecem um curso só: linkam a folha de estilo de `assets/` em vez de cada uma ter a sua.
- Uma pergunta que exige julgamento te leva a um fórum, subreddit ou aula, não só a uma resposta.

## Onde se encaixa

A `teach` é uma **avulsa para usar a qualquer hora**. Ela não é um passo numa cadeia de construção e não compartilha artefatos com o fluxo de engenharia; ela trabalha no próprio diretório enquanto você estudar o assunto.

A única vizinha de verdade é a [handoff](./handoff.md). Juntas, elas respondem "o que eu faço se estou sendo sabatinado sobre algo que não entendo?". Não pare a sabatina para aprender. Faça `/handoff` para um workspace de ensino, aprenda o assunto lá com `/teach` e depois volte e continue de onde parou. A alternativa próxima é a [research](../engineering/research.md), para quando o que você quer é um documento com citações, não lições e retenção. Quando não tiver certeza de qual skill ou fluxo serve, a [ask-matt](../engineering/ask-matt.md) te orienta por todo o conjunto.
