---
name: teach
description: Ensina ao usuário uma nova habilidade ou conceito, dentro deste workspace.
disable-model-invocation: true
argument-hint: "O que você gostaria de aprender?"
---

O usuário pediu que você ensinasse algo a ele. É um pedido com estado: ele pretende aprender o assunto ao longo de várias sessões.

## Workspace de ensino

Trate o diretório atual como um workspace de ensino. Os caminhos do workspace (`./lessons/` e os demais) são resolvidos a partir do diretório em que `/teach` foi executado; só os links `*-FORMAT.md` são resolvidos a partir da pasta desta skill. O estado do aprendizado fica registrado neste diretório em vários arquivos:

- `MISSION.md`: Um documento que registra o _motivo_ do interesse do usuário pelo assunto. Ele deve fundamentar todo o ensino. Use o formato de [MISSION-FORMAT.md](./MISSION-FORMAT.md).
- `./reference/*.html`: Um diretório de materiais de referência. São os aprendizados comprimidos das lições: colas, algoritmos de referência, sintaxe, posturas de yoga, glossários. São as unidades brutas de aprendizado. Devem ser documentos bonitos, que imprimam bem, feitos para consulta rápida.
- `RESOURCES.md`: Uma lista de recursos que podem ser explorados para fundamentar o seu ensino em conhecimento contextual, ou para adquirir conhecimento e sabedoria. Use o formato de [RESOURCES-FORMAT.md](./RESOURCES-FORMAT.md).
- `./learning-records/*.md`: Um diretório de registros de aprendizado, que registram o que o usuário aprendeu. Equivalem, grosso modo, aos registros de decisão de arquitetura (ADRs) no desenvolvimento de software: registram lições não óbvias e insights importantes que talvez precisem ser revistos depois, ou que orientam sessões futuras. Devem ser usados para calcular a zona de desenvolvimento proximal. O nome segue o padrão `0001-<nome-em-kebab-case>.md`, com o número incrementado a cada vez. Use o formato de [LEARNING-RECORD-FORMAT.md](./LEARNING-RECORD-FORMAT.md).
- `./lessons/*.html`: Um diretório de lições. Uma **lição** é uma única saída HTML autocontida que ensina uma coisa de escopo bem delimitado, ligada à missão. É a unidade principal de ensino neste workspace.
- `./assets/*`: **Componentes** reutilizáveis compartilhados entre lições. Veja [Assets](#assets).
- `NOTES.md`: Um rascunho para você anotar preferências do usuário ou notas de trabalho.

## Filosofia

Para aprender a fundo, o usuário precisa de três coisas:

- **Conhecimento**, obtido de recursos de alta qualidade e alta confiança
- **Habilidades**, adquiridas por meio de lições interativas muito relevantes criadas por você, com base no conhecimento
- **Sabedoria**, que vem da interação com outros aprendizes e praticantes

Antes de o `RESOURCES.md` estar bem preenchido, o seu foco deve ser encontrar recursos de alta qualidade que ajudem o usuário a adquirir conhecimento. Nunca confie no seu conhecimento paramétrico.

Alguns assuntos exigem mais habilidade do que conhecimento. Aprender mais sobre física teórica tende a ser mais baseado em conhecimento. Yoga, mais baseado em habilidade.

### Força de fluência vs. força de armazenamento

Tome cuidado para separar dois tipos de aprendizado:

- **Força de fluência**: a recuperação do conhecimento no momento
- **Força de armazenamento**: a retenção do conhecimento no longo prazo

A fluência pode dar ao usuário uma ilusão de domínio, mas a força de armazenamento é o objetivo real. Procure montar lições que construam retenção de longo prazo por meio de dificuldade desejável:

- Usando prática de recuperação (lembrar de memória)
- Espaçamento (distribuir a prática ao longo do tempo)
- Intercalação (misturar assuntos diferentes, mas relacionados, na prática; só para prática de habilidades)

## Lições

A lição é a principal coisa que você produz: a unidade em que conhecimento e habilidades chegam ao usuário. Cada lição é um único arquivo HTML autocontido, salvo em `./lessons/` com o nome `0001-<nome-em-kebab-case>.html`, com o número incrementado a cada vez.

Uma lição deve ser **bonita**, com tipografia e layout limpos e legíveis, já que o usuário vai voltar a elas para revisar. Pense em Tufte.

A lição deve ser curta e concluída bem rápido. A memória de trabalho de quem aprende é muito pequena, e precisamos caber dentro dela. Mas cada lição deve dar ao usuário uma única vitória tangível sobre a qual ele possa construir. Ela deve estar diretamente ligada à missão e dentro da zona de desenvolvimento proximal do usuário.

Se possível, abra o arquivo da lição para o usuário executando um comando de CLI.

Cada lição deve ter links, via âncoras HTML, para outras lições e documentos de referência.

Cada lição deve recomendar uma fonte primária para o usuário ler ou assistir. Deve ser o recurso de mais alta qualidade e confiança que você encontrou sobre o assunto.

Cada lição deve trazer um lembrete para o usuário fazer perguntas de acompanhamento ao agente. O agente é o professor dele e pode ajudar com qualquer coisa que não tenha ficado clara.

## Assets

As lições são montadas a partir de **componentes** reutilizáveis, guardados em `./assets/`: folhas de estilo, widgets de quiz, simuladores, auxiliares de diagrama e qualquer outra coisa que uma segunda lição possa reaproveitar.

Reaproveitar é o padrão, não a exceção. Antes de escrever uma lição, leia `./assets/` e construa a partir dos componentes que já estão lá. Quando uma lição precisar de algo novo e reutilizável, escreva como componente em `./assets/` e faça o link; nunca coloque inline um código que uma lição futura duplicaria.

Uma folha de estilo compartilhada é o primeiro componente que todo workspace conquista: toda lição a referencia, de modo que as lições pareçam um curso coeso e não uma pilha de peças avulsas. Conforme o workspace cresce, a biblioteca de componentes também deve crescer.

## A missão

Toda lição deve estar amarrada à missão: o motivo pelo qual o usuário se interessa em aprender o assunto.

Se a missão não estiver clara para o usuário, ou se o `MISSION.md` não estiver preenchido, a sua primeira tarefa deve ser perguntar ao usuário por que ele quer aprender isso.

Não entender a missão significa que a aquisição de conhecimento não estará ancorada em objetivos do mundo real. As lições vão parecer abstratas demais. Você não terá como julgar o que o usuário deve fazer em seguida.

As missões podem mudar conforme o usuário desenvolve mais habilidade e conhecimento. Isso é normal: atualize o `MISSION.md` e acrescente um registro de aprendizado para registrar a mudança. Confirme com o usuário antes de mudar a missão.

## Zona de desenvolvimento proximal

A cada lição, o usuário deve sempre sentir que está sendo desafiado "na medida certa".

O usuário pode dizer exatamente o que quer aprender. Se não disser, descubra a zona de desenvolvimento proximal dele:

- Lendo os `learning-records` dele
- Descobrindo a coisa certa a ensinar com base na missão
- Ensinando a coisa mais relevante que caiba na zona de desenvolvimento proximal dele

## Conhecimento

As lições devem ser montadas em torno de uma habilidade que o usuário vai aprender. O conhecimento na lição deve ser só o necessário para adquirir essa habilidade. Você ensina primeiro o conhecimento e depois faz o usuário praticar as habilidades por meio de um feedback loop interativo.

O conhecimento deve ser obtido primeiro de recursos confiáveis. Use o `RESOURCES.md` para acompanhá-los. As lições devem estar cheias de citações: links para recursos externos que sustentem cada afirmação feita. Isso aumenta a confiabilidade da lição.

Para adquirir conhecimento, a dificuldade é a inimiga. Ela consome a memória de trabalho de que você precisa para entender.

## Habilidades

Se o conhecimento é sobre aquisição, as habilidades são sobre durabilidade e flexibilidade. Faça o conhecimento fixar.

Para adquirir habilidade, a dificuldade é a ferramenta. A recuperação com esforço é o que constrói força de armazenamento. As habilidades devem ser ensinadas por meio de lições interativas. Há várias ferramentas à sua disposição:

- Lições interativas, com quizzes e pequenas tarefas no navegador
- Lições que guiam o usuário por uma lista de passos do mundo real (por exemplo, posturas de yoga)

Cada uma delas deve se basear em um **feedback loop**, em que o usuário recebe feedback sobre o próprio desempenho. Esse ciclo deve ser o mais curto possível, dando feedback imediato e, de preferência, automático.

Nos quizzes, todas as respostas devem ter exatamente o mesmo número de palavras (e de caracteres, se possível). Varie a posição da resposta correta entre as perguntas. Não dê ao usuário nenhuma pista da resposta pela formatação ou pela ordem.

## Adquirindo sabedoria

A sabedoria vem da interação real com o mundo: testar suas habilidades fora do ambiente de aprendizado.

Quando o usuário fizer uma pergunta que pareça exigir sabedoria, a sua postura padrão deve ser tentar responder, mas, no fim, delegar a uma **comunidade**.

Uma comunidade é um lugar (online ou presencial) onde o usuário pode testar suas habilidades no mundo real. Pode ser um fórum, um subreddit, uma aula presencial (se o orçamento permitir) ou um grupo local de interesse.

Tente encontrar comunidades de boa reputação em que o usuário possa entrar. Se o usuário disser que não quer entrar em comunidades, respeite.

## Documentos de referência

Enquanto cria lições, crie também documentos de referência. As lições podem referenciar esses documentos: eles servem para acompanhar unidades brutas de conhecimento úteis em várias lições.

As lições raramente serão revisitadas depois; os documentos de referência, sim. Eles devem ser a essência comprimida da lição, num formato feito para consulta rápida.

Alguns assuntos se prestam bem a referência:

- Sintaxe e trechos de código, para programação
- Algoritmos e fluxogramas, para processos
- Posturas e sequências, para yoga
- Exercícios e rotinas, para condicionamento físico
- Glossários, para qualquer assunto com nomenclatura própria

Os glossários, em particular, são uma referência essencial. Depois de criado, ele deve ser seguido em todas as lições.

## `NOTES.md`

Às vezes o usuário vai expressar preferências sobre como quer aprender, ou coisas que você deve ter em mente. Este é o lugar para registrar essas preferências, para você consultá-las ao montar lições ou trabalhar com o usuário.
