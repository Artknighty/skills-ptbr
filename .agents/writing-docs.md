# Escrevendo as páginas de documentação

> Neste fork, as páginas de `docs/` foram traduzidas e os links entre elas apontam para os arquivos locais em português (no original, apontam para `https://aihero.dev/skills-<nome>`). O resto deste guia descreve as convenções do original.

Toda skill em `engineering/` e `productivity/` tem uma **página de documentação** voltada a humanos em `docs/<bucket>/<nome-da-skill>.md`. A árvore de docs espelha essas duas pastas-bucket de `skills/`. Ela é publicada em `https://aihero.dev/skills-<nome-da-skill>`; a URL é sempre `skills-<nome-da-skill>`, seja qual for o bucket, então o caminho em docs é só organização do repositório. A página não é a skill nem uma cópia do `SKILL.md`. Só esses dois buckets são promovidos; os demais (`misc/`, `in-progress/`, `deprecated/`) não têm página.

A maioria destas skills é **invocada pelo usuário**: o agente nunca vai dispará-las por você, então *você* é o índice que precisa lembrar que elas existem e quando usá-las. Essa memória é **carga cognitiva**. O trabalho de uma página de documentação é aliviá-la: orientar um leitor sobre uma skill para que ele consiga guardá-la na cabeça, saiba quando usá-la e veja onde ela se encaixa no sistema. As páginas, juntas, são um roteador distribuído; cada uma é um nó.

Aja sempre que uma skill promovida for adicionada, renomeada ou tiver o comportamento alterado: crie ou ressincronize a página dela. Uma renomeação também move o arquivo (`docs/<bucket>/<antigo>.md` → `docs/<bucket>/<novo>.md`), porque a URL publicada acompanha o nome; uma skill que muda entre `engineering/` e `productivity/` leva o arquivo de docs para a pasta correspondente. Skills em `misc/`, `in-progress/` e `deprecated/` não ganham página, porque nenhum desses buckets é promovido. Uma skill que sai de um deles para `engineering/` ou `productivity/` ganha uma página; uma que vai no sentido contrário perde a dela. Uma skill promovida que é removida de vez mantém a página como página **arquivada**: deixe o corpo como estava e abra com um aviso em citação (`> **Arquivada.** ...`) indicando a versão em que foi removida e o substituto, se houver, para que a URL publicada continue funcionando.

Como essas páginas são publicadas no `aihero.dev`, **todo link é absoluto**: nunca um caminho relativo ao repositório. Um link para outra skill aponta para `https://aihero.dev/skills-<nome>`; um link para dentro do repositório aponta para a URL completa `https://github.com/mattpocock/skills/...`. Um link relativo que funciona no repositório quebra depois de publicado.

Não há H1. A página publicada tira o título do slug.

## Estrutura da página

Preencha o modelo abaixo, mantendo a ordem. A **moldura fixa** (`## O que faz`, `## Quando usar`, `## Onde se encaixa`) aparece em toda página. `## Pré-requisitos` e as seções livres do meio trazem só o que aquela skill precisa; apague o resto.

Quatro seções fazem uma página valer a leitura: `O que faz`, `Quando usar`, `Perguntas frequentes`, `Está funcionando se`. As duas primeiras orientam o leitor; as duas últimas são onde a página para de resumir a skill e passa a responder à situação do próprio leitor. Cada uma das duas últimas tem uma régua a passar, descrita abaixo, mas trate uma página que não passa em nenhuma como inacabada, não como pronta e curta.

**Uma página não traz comandos de instalação.** O modelo de página do ai-hero renderiza o widget de instalação sozinho (um botão de copiar, o comando de uma skill, o comando do conjunto inteiro e a linha de atualização) acima do corpo. Uma página que também os escreve mostra ao leitor o mesmo comando duas vezes, e as duas cópias se distanciam: o par escrito à mão em cada página ficou desatualizado em relação ao widget ao lado. O texto de instalação é propriedade do site, não da página. Se precisar mudar, mude no ai-hero; o texto canônico vive no [bloco de instalação](./install-block.md).

<page-template>

## O que faz

Um ou dois parágrafos em linguagem simples. Abra com o trabalho da skill numa frase e depois declare a **restrição definidora**: o único fato que faz esta skill se comportar diferente do padrão óbvio (para a `to-spec`: ela não entrevista o usuário de novo, ela sintetiza o que já se sabe). Escreva como uma frase declarativa simples, nunca como um aparte rotulado como "A restrição definidora:" ou "O ponto-chave:"; essa fórmula soa como enchimento. Esta linha é a mais valiosa da página; nunca a omita.

## Quando usar

Como e quando você recorre à skill, em dois tempos que estão praticamente sempre presentes:

- **Modo de invocação.** Diga se você a digita ou se o agente a dispara. Uma skill invocada pelo usuário: "Você invoca esta digitando `/<nome>`, e o agente não vai recorrer a ela sozinho." Uma skill invocada pelo modelo: "Digite `/<nome>`, ou o agente recorre a ela automaticamente quando uma tarefa se encaixa."
- **Fronteira do gatilho.** A entrada do índice: "use quando …". Quando a skill puder ser confundida com uma irmã, acrescente a outra metade: "para <X>, use [<irmã>](https://aihero.dev/skills-<irmã>)."

## Pré-requisitos

Opcional: inclua só quando a skill precisar de algo pronto para funcionar; caso contrário, omita o título inteiro. Cobre: um **workspace em que ela escreve** (uma skill com estado como a `grill-with-docs` escreve `GLOSSARY.md` e ADRs; a `teach` monta um diretório inteiro, então diga o que ela escreve e onde), **configuração prévia** (`triage`/`to-spec`/`to-tickets` precisam que a `setup-matt-pocock-skills` tenha configurado um issue tracker) ou **ferramentas específicas do repositório**. Uma skill sem estado que roda em qualquer lugar não tem pré-requisitos, então tire a seção.

## <meio livre>

De uma a três seções curtas, no *próprio vocabulário* da skill, que façam a ficha cair. Escolha os títulos que combinarem com a skill: o loop que ela roda, o artefato que produz, a bifurcação que faz, o antipadrão que elimina. Não há título prescrito; as skills são heterogêneas demais para um só.

O único ponto inegociável: **mostre a palavra-guia / ideia definidora da skill** (feedback loop _enxuto_, _módulo profundo_, código descartável que responde uma pergunta, red-green). Isso rende duas vezes: o leitor aprende o que a skill *é* e aprende a palavra com que vai pensar depois para *recorrer* a ela.

## Perguntas frequentes

As perguntas que os leitores realmente fazem sobre esta skill, cada uma em negrito com a resposta nas linhas abaixo. Sem subtítulos.

Uma pergunta observada sempre vence uma inventada, então vá encontrá-las antes de escrever qualquer uma:

- **A wiki.** Se `~/repos/matt/personal-wiki` existir nesta máquina, ela é a fonte mais rica que há. A área `wiki/audience/` dela é organizada em torno do que o público quer, discute e **com o que se confunde**: leia primeiro `wiki/index.md`, para o registro de páginas, e depois as páginas que tocam nesta skill. Toda página traz links `sources:` para as threads originais de X, Discord, GitHub e e-mail; a wiki é uma fonte secundária, então cite a pergunta da própria pessoa, não o resumo da wiki. Pule este item onde o diretório não existir.
- **As issues deste repositório.** `gh issue list --repo mattpocock/skills --search "<nome-da-skill>" --state all`. Uma pergunta aberta duas vezes é uma pergunta que a página deve responder.
- **O `CHANGELOG.md`.** Qualquer coisa renomeada, movida ou com comportamento alterado gera um "para onde foi?" que a página precisa responder.

Onde a busca render pouco, a seção também pode trazer uma pergunta que um leitor obviamente faria, mas **a contagem continua fiel às evidências**. Uma skill muito discutida merece seis; uma obscura, uma ou duas, ou nenhuma. Encher uma skill pouco discutida para igualar uma rica é como a seção se enche de perguntas que ninguém tem, e uma pergunta inventada não ensina nada ao leitor.

Ordene pela frequência com que cada uma aparece, a mais afiada primeiro, e diga a verdade desagradável onde ela for verdade: uma sessão de sabatina muito longa geralmente significa que o escopo era grande demais; um modelo a quem se pede para escrever a própria skill produz algo prolixo. Omita o título onde não houver nada que valha responder.

## Está funcionando se

Alguns tópicos dizendo o que o leitor vê quando a skill está fazendo o trabalho dela. A régua de cada um é que o leitor consiga conferir sem abrir o `SKILL.md`: um sinal no próprio trabalho dele, ou no rastro à frente dele. "O documento fica mais curto à medida que fica melhor" passa; "a seção da biblioteca é idêntica byte a byte ao `template.sh`" é uma verificação de conformidade dos detalhes internos da skill usando o nome desta seção. Inclua onde os sinais forem nítidos; omita o título onde ficarem vagos.

## Onde se encaixa

Sempre presente. Situe a skill no sistema em uma ou duas frases:

- **Papel.** Dê nome a ele: um **passo da cadeia** (`grill-with-docs → to-spec → to-tickets → implement → code-review`), uma **configuração de uma vez só** (`setup-matt-pocock-skills`), **manutenção periódica** (`improve-codebase-architecture`, "a cada poucos dias") ou uma **avulsa para usar a qualquer hora** (`diagnosing-bugs`, `prototype`, `handoff`). O mapa de uma avulsa é uma frase honesta, o que é muito melhor do que omitir a seção.
- **Vizinhas.** As uma ou duas irmãs que importam, cada uma com uma justificativa, com link absoluto.
- **O mapa.** Aponte para a [ask-matt](https://aihero.dev/skills-ask-matt), o roteador de todo o conjunto, para que esta página continue sendo um nó e nunca precise redesenhar o grafo.

</page-template>

## Convenções

- Explique o **porquê**, não o processo. A página orienta e situa a skill; ela nunca reproduz os passos do `SKILL.md` nem despeja modelos: um humano escolhendo uma ferramenta não precisa do runbook.
- **Nunca cite o autor.** A página é um documento técnico, não um registro de quem disse o quê. "O Matt diz", "a resposta do próprio Matt", "a posição dele é", uma resposta citada: tudo isso sai. Uma descoberta da busca de perguntas vale ser mantida; a atribuição dela, não. Declare a substância como uma afirmação simples sobre a skill ("a correção é uma instrução direta: …", "a divisão se resume ao número de sessões") e tire a moldura. O leitor está decidindo se usa uma ferramenta; uma opinião pesa o mesmo de qualquer jeito, e uma atribuída fica datada assim que a posição muda. Citar um *usuário* continua ok: "um usuário relatou …" é evidência sobre a skill no mundo real, e continua anônima.
- Use as **palavras-guia** da skill (_seam_, _módulo profundo_, _tracer bullet_) para que a página e a skill falem a mesma língua.
- **Use o termo do [AI Coding Dictionary](https://www.aihero.dev/ai-coding-dictionary) quando existir um, e linke o primeiro uso na página.** O dicionário é o vocabulário da casa para programação com IA: _context window_, _subagent_, _harness_, _primary source_, _agent mode_. Prefira a palavra dele a um sinônimo que você inventar. Linke a primeira ocorrência de cada termo para `https://www.aihero.dev/ai-coding-dictionary/<slug>` (o slug é o termo em minúsculas, com caracteres não alfanuméricos virando hífens: _context window_ → `context-window`) e deixe as ocorrências seguintes sem link. Linke só onde a palavra tiver o sentido do dicionário: um *modelo* de domínio, um *contexto* de fundo ou um *token* de autenticação são outras palavras que só coincidem. Nunca linke dentro de um título, de um trecho de código ou de um link existente, e nunca linke uma palavra que nomeia uma skill deste repositório em vez do conceito. Para a lista completa de termos, leia `~/repos/ai/ai-coding-dictionary/dictionary/` se existir nesta máquina (um arquivo por termo, o nome do arquivo *é* o termo) e, caso contrário, [mattpocock/dictionary-of-ai-coding](https://github.com/mattpocock/dictionary-of-ai-coding), que é a fonte da verdade nos dois casos.
- **Ramificações vão numa tabela ou numa lista, nunca num parágrafo.** Onde a página apresenta uma escolha (dois artefatos que a skill pode produzir, quatro situações que a disparam, cinco opções numa fronteira), o leitor está procurando a única linha que corresponde à situação dele. Um parágrafo o obriga a ler tudo para descobrir. Uma tabela markdown curta (condição na coluna da esquerda, o que fazer na da direita) ou uma lista com tópicos devolve isso num relance. Isso vale onde quer que a ramificação apareça, mais frequentemente em `## Quando usar` e no meio livre.
- Mantenha a própria página com pouca carga. Ela é documentação *sobre* skills de baixa carga cognitiva; mobília (títulos sobrando, links repetidos) é exatamente o que ela critica.

## Pronto quando

- A página existe em `docs/<bucket>/<nome>.md`, e nenhuma página obsoleta sobrevive a uma renomeação ou mudança de bucket.
- A página não traz link para o código-fonte e não escreve nenhum comando de instalação próprio.
- `## O que faz` declara a restrição definidora, em prosa simples, não como aparte rotulado.
- A página não cita nem nomeia o autor: toda afirmação se sustenta sozinha.
- `## Quando usar` declara o modo de invocação e a fronteira do gatilho.
- `## Onde se encaixa` nomeia o papel e linka para a `ask-matt`.
- Um pré-requisito (workspace, configuração prévia, ferramentas) é declarado onde existir, e a seção não aparece onde não existir.
- O meio mostra a palavra-guia.
- Todo termo do AI Coding Dictionary que a página usa está escrito do jeito do dicionário, e o primeiro uso dele (e só o primeiro) linka para o verbete.
- Toda ramificação de várias vias é uma tabela ou lista, não um parágrafo que o leitor precise ler inteiro.
- A busca por perguntas reais foi feita (a wiki, as issues, o changelog), e `## Perguntas frequentes` tem o tamanho do que ela encontrou, não foi inflada para igualar a página de uma skill mais rica.
- Todo tópico de `## Está funcionando se` pode ser conferido sem abrir o `SKILL.md`.
- As seções aparecem na ordem do modelo.
- Todo link é absoluto, e todos funcionam.
