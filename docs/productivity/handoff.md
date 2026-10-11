## O que faz

A `handoff` compacta a conversa em que você está num **documento de handoff**: um arquivo markdown, gravado no diretório temporário do sistema operacional e não no workspace, que um [agent](https://www.aihero.dev/ai-coding-dictionary/agent) novo pode ler para assumir o trabalho.

O que ela te dá é **portabilidade**, não compressão, então a skill é mais restrita do que parece. Você só precisa de um arquivo quando o trabalho precisa *viajar*: para um novo [harness](https://www.aihero.dev/ai-coding-dictionary/harness), um novo diretório, um colega, ou uma tarefa paralela que você quer separar. Se nada vai viajar, você não precisa de handoff. Ficar na [session](https://www.aihero.dev/ai-coding-dictionary/session), `/clear`, um [subagent](https://www.aihero.dev/ai-coding-dictionary/subagent) e `/compact` cobrem o caso comum de fim de fase, e o `/compact` cobre isso com mais frequência do que esta skill.

## Quando usar

Você invoca esta digitando `/handoff`; o agente não vai recorrer a ela sozinho. Passe uma nota dizendo para que serve a próxima sessão, e a skill escreve o documento com esse propósito.

Há quatro gatilhos, e só quatro:

| Situação | Por que um arquivo |
| --- | --- |
| Trocar de harness (Claude → Codex) | O novo harness não enxerga o [context](https://www.aihero.dev/ai-coding-dictionary/context) antigo |
| Ir para outro diretório ou repositório | Um diretório de protótipo é o caso comum |
| Mandar o trabalho para um colega | Ele precisa de algo que consiga ler |
| Separar uma tarefa paralela encontrada no meio da fase | Você continua trabalhando; um segundo agente pega a bifurcação |

Para qualquer outra coisa (mesmo harness, mesmo diretório, você terminou a [grilling](https://www.aihero.dev/ai-coding-dictionary/grilling) e está indo para a implementação), use `/compact`. A [ask-matt](../engineering/ask-matt.md) tem a árvore ordenada das cinco opções numa fronteira de fase.

## Bifurcar é o uso que as pessoas pulam

A descrição da skill parece falar de retomar uma sessão: escreva um resumo, termine aqui, retome lá. Lida assim, ela parece um `/compact` pior, e as pessoas a pulam. O caso da bifurcação é o que vale conhecer. Você **continua na sua sessão** e entrega uma cópia do contexto acumulado para um segundo agente trabalhando em paralelo.

É isso que o desvio pela [prototype](../engineering/prototype.md) usa. Você está no meio de uma conversa de design, bate numa pergunta que só código rodando vai resolver, e não quer gastar a conversa que construiu para descobrir a resposta. Faça handoff para uma sessão de protótipo, pegue a resposta, faça handoff da resposta de volta e referencie isso na conversa original. O trabalho atravessa duas vezes, a sua conversa original continua viva, e você não reexplica nada.

Três das cinco opções numa fronteira de fase preservam coisas diferentes: o `/compact` preserva a sua intenção, o `/clear` não preserva nada, o `/handoff` preserva a capacidade do trabalho de se mover.

## O que viaja e o que não viaja

O documento leva o fio da meada vivo (o que está em andamento, por quê e o que vem a seguir) mais uma seção de **skills sugeridas** dizendo a que o próximo agente deve recorrer. A skill remove segredos antes de gravar o arquivo.

De propósito, ele não leva nada que já esteja escrito em outro lugar. O documento referencia specs, planos, ADRs, issues, commits e diffs por caminho ou URL, e nunca os copia. Isso mantém o arquivo pequeno e mantém o detalhe já resolvido num lugar só, em vez de duas cópias que se distanciam.

## Perguntas frequentes

**Handoff ou compact?**
`/compact`, a menos que algo vá viajar. Continuar na mesma tarefa é um compact, não um handoff. Quando o harness e o diretório continuam os mesmos e você precisa continuar no loop, a árvore da fronteira de fase termina no `/compact` na maioria dos dias. O `/handoff` não resume melhor. A vantagem dele é que o resultado é um arquivo que você pode levar a um lugar aonde o `/compact` não chega.

**Então qual é a diferença real entre compact, clear e handoff?**
Cada um preserva uma coisa diferente. O `/compact` comprime este contexto e continua numa janela nova, então a sua intenção sobrevive. O `/clear` esvazia a janela e começa do zero. Isso é o certo quando tudo para trás é descartável, e você não consegue desfazer se não for. O `/handoff` grava um arquivo portátil, então o trabalho sobrevive à mudança para outro lugar. Os três transformam uma **[primary source](https://www.aihero.dev/ai-coding-dictionary/primary-source)** (a conversa como aconteceu) numa **[secondary source](https://www.aihero.dev/ai-coding-dictionary/secondary-source)** (um resumo dela). Continuar é a única opção que não faz isso, e é por isso que você a descarta primeiro.

**Para onde foi o meu arquivo de handoff?**
Para o diretório temporário, que é o problema mais relatado da skill. A skill o resolve como `$TMPDIR`, senão `/tmp` (`%TEMP%` no Windows), mas os caminhos são longos. Peça o caminho de volta e guarde-o antes de seguir. O temporário é proposital, porque um handoff é um documento em trânsito, não um artefato que você mantém. O temporário também não é durável, como explica a próxima pergunta.

**Meu handoff sumiu entre uma sessão e outra.**
Alguns ambientes limpam o temporário entre sessões (o Codex é o caso relatado), e um reboot esvazia o `/private/tmp`. Se a próxima sessão não for começar na próxima hora, ou for começar em outro harness, copie o arquivo para um lugar durável assim que ele for gravado. O mesmo vale para tudo o que o documento *aponta*: se ele referencia outros arquivos no temporário, o próximo agente não consegue segui-los.

**Como eu entrego isso de fato ao próximo agente?**
Abra a sessão nova e aponte para o caminho: leia este arquivo e continue. Aponte para o arquivo em vez de colar o resumo num comando de shell. O shell estraga um resumo que contém crases ou `$(...)` quando você o interpola em `claude "<resumo>"`. O resultado comum é um corte silencioso, não um erro, então o novo agente começa com um briefing incompleto e nada te avisa.

**Isso é o mesmo que `/branch`, `--fork-session` ou o `/handoff` nativo?**
São parecidos, não idênticos. `/branch` não é uma skill distribuída aqui; `/handoff` é o nome canônico. Um fork herda uma cópia exata do contexto; esta skill produz uma compressão *direcionada* a uma próxima tarefa declarada, num arquivo. Onde um fork serve (mesma máquina, mesmo harness, mesmo diretório), o fork dá menos trabalho. O arquivo é a melhor escolha quando o destino é um lugar aonde o fork não vai.

**Quando algo deveria ir para o `CLAUDE.md`?**
Pergunte se aquilo continua verdade no mês que vem. O `CLAUDE.md` é contexto permanente sobre o projeto, carregado em toda sessão, relevante ou não. Um handoff é sobre um trabalho em andamento e é inútil depois que esse trabalho entra. Se você vive reexplicando um fato, ele pertence ao `CLAUDE.md`. Uma tarefa pela metade pertence a um handoff.

**Ele registra o quê, mas não o porquê.**
É uma crítica justa, e aparece com frequência. Duas coisas ajudam. Passe o argumento (diga para que é a próxima sessão), para que a skill mantenha o raciocínio relevante para *aquilo* em vez de achatá-lo. E fique de olho em afirmações confiantes que a sessão nunca verificou, como "X não está construído" ou "Y está pronto". O próximo agente confia no documento e não o reconfere, então uma crença escrita como fato vira uma premissa falsa para tudo o que vem depois. Leia o documento antes de entregá-lo e rebaixe o que você só supôs.

**Por que isso é uma skill e não um slash command?**
Os dois funcionam; servem a situações diferentes. Como skill, ela é distribuída e atualizada pelo mesmo caminho de instalação de todo o resto daqui, o que a torna compartilhável. É o frontmatter dela, não o mecanismo, que impede o agente de dispará-la sozinho.

## Está funcionando se

- O documento é uma pequena fração da conversa, e as specs, issues e diffs aparecem nele como caminhos e URLs, não como texto copiado.
- Você consegue lê-lo do zero, sem a sessão original aberta, e saber o que fazer a seguir.
- O agente novo começa a trabalhar em vez de pedir para você reexplicar o contexto.
- No caso da bifurcação, a sua sessão original está igual quando você volta a ela.
- A seção de skills sugeridas cita a skill que você mesmo teria escolhido.
- Nada nele é uma chave, um token ou uma senha.

## Onde se encaixa

A `handoff` é uma **avulsa para usar a qualquer hora**. Ela trabalha entre sessões, não dentro de uma cadeia de construção. É de uso restrito, e você vai usá-la menos do que as outras quatro opções numa fronteira de fase. A vizinha mais próxima é a [prototype](../engineering/prototype.md), porque um protótipo vive no próprio diretório e a ida e volta é exatamente o movimento para o qual esta skill existe. Quando estiver numa fronteira sem saber se continua, limpa, faz handoff, delega ou compacta, a [ask-matt](../engineering/ask-matt.md) tem a árvore que ordena essas cinco opções e te orienta pelo resto do conjunto.
