## O que faz

Você digita `wait-what` quando não entendeu uma mensagem. O [agent](https://www.aihero.dev/ai-coding-dictionary/agent) então explica de novo o que acabou de dizer. Ele acrescenta o contexto que estava te faltando, escreve em português simples e usa o vocabulário do `GLOSSARY.md` do seu projeto.

A skill tem três linhas. Isso é o design, não um rascunho inacabado. Skills contra a prolixidade costumam falhar porque ficam longas demais. Uma skill de concisão com quatrocentas linhas ainda deixa o [model](https://www.aihero.dev/ai-coding-dictionary/model) prolixo, porque o modelo copia o tamanho da skill, não o pedido dela. Esta tem uma única palavra-guia precisa e nada mais.

## Quando usar

Você a invoca digitando `/wait-what`. O agente não vai recorrer a ela sozinho, e nem deveria. Só você sabe quando parou de acompanhar.

Use assim que perceber que está lendo na diagonal. Por exemplo, o agente começou a usar um jargão que ele mesmo inventou, enfiou cinco siglas numa frase, ou explicou uma decisão cuja premissa você nunca viu. Ela conserta a conversa em que você já está. Para impedir que o jargão sequer apareça, use a [grill-with-docs](../engineering/grill-with-docs.md), que constrói a linguagem compartilhada de antemão.

## O nome é o mecanismo

A palavra-guia é **espera** (no original, **wait**). "Seja conciso" é uma instrução sobre a saída do agente, e o modelo a obedece cortando palavras e te perdendo ainda mais. **Espera** é sobre o *seu* estado. Diz que você parou de entender aqui. Um agente que ouve "seja breve" escreve fragmentos picotados. Um agente que ouve "espera, você me perdeu" volta um pouco e explica.

Essa diferença é a skill inteira. Toda correção popular para a prolixidade nomeia a *saída*: `/tldr`, `/no-fluff`, `/talk-normal`. O modelo corrige demais e cai em fragmentos picotados, mais curtos e nada mais claros. Nomear quem *ouve* pede as duas metades de uma vez: menos palavras **e** o contexto que estava faltando.

A skill pede para explicar de novo **isso**, não "essa última mensagem". O que te perdeu costuma ser maior que um parágrafo, então o agente decide até onde voltar.

## Ela se encaixa na linguagem que você já tem

O corpo reaproveita as palavras-guia que já estão no seu `CLAUDE.md` global e no `GLOSSARY.md` do projeto. O ASD-STE100 Simplified Technical English (frases curtas, uma ideia por frase, voz ativa) define o registro, que nesta tradução é aplicado ao português. A linguagem ubíqua fornece os substantivos. A skill, o `CLAUDE.md` e o `GLOSSARY.md` usam os mesmos [tokens](https://www.aihero.dev/ai-coding-dictionary/token), então invocá-la não é uma instrução nova. É um lembrete de uma que o agente já aceitou.

Se você não tem `GLOSSARY.md` (nem um `GLOSSARY-MAP.md` apontando para um, no contexto em questão), a skill funciona mesmo assim. Você só perde a metade do vocabulário de domínio.

## Está funcionando se

- A nova explicação é **mais curta e mais clara**, não mais curta e mais seca.
- Ela acrescenta a premissa que estava te faltando, em vez de só apagar palavras.
- Os substantivos do projeto substituem os inventados. Os termos do seu `GLOSSARY.md` voltam.
- Você pode usá-la duas vezes seguidas e ela não degrada em secura.

## Onde se encaixa

Você pode usar a `wait-what` a qualquer momento, em qualquer conversa, dentro de qualquer outra skill. Ela conserta uma mensagem depois do fato. A correção de verdade é uma linguagem compartilhada combinada de antemão, e isso é a [grill-with-docs](../engineering/grill-with-docs.md): uma sessão de [grilling](https://www.aihero.dev/ai-coding-dictionary/grilling) que roda a [domain-modeling](../engineering/domain-modeling.md) pelo caminho, registrando no seu `GLOSSARY.md` as palavras que vocês dois usam. Se não tiver certeza de qual skill serve no momento, a [ask-matt](../engineering/ask-matt.md) te orienta.
