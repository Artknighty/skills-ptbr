## O que faz

A `pr` define o formato do corpo de um pull request: um **Resumo** que mostra a mudança, uma **Evidência** de que ela funciona e uma avaliação de **Risco do merge** sobre quão arriscado é fazê-la entrar. Ela é uma referência de formato, não um fluxo de trabalho. Ela não faz push de branch, não abre o PR e não decide o que entra nele. Ela diz ao [agent](https://www.aihero.dev/ai-coding-dictionary/agent) como o corpo deve ficar quando ele for escrever um.

O resumo é um visual, não um parágrafo. Um corpo de PR padrão descreve o diff em prosa. Este escolhe a **menor visualização** que deixa o ponto principal claro (pseudocódigo, uma árvore de chamadas, uma árvore de componentes, uma árvore de arquivos, um diagrama Mermaid ou um diff com formato próprio) e mantém breves as palavras ao redor. Quem revisa já está com o diff aberto, então o corpo mostra a forma dele antes da leitura.

## Quando usar

Digite `/pr`, ou o agente recorre a ela automaticamente sempre que estiver escrevendo o corpo de um PR.

| A sua situação | Use |
| --- | --- |
| Um branch está pronto e precisa de um corpo que quem revisa consiga escanear | `pr` |
| O código está escrito, mas ninguém o revisou ainda | [code-review](./code-review.md) primeiro, depois `pr` |
| O PR está aberto e os comentários de revisão estão chegando | Nada neste conjunto ainda; a `pr` só escreve o corpo |

## O modelo

Três seções, nesta ordem:

- **Resumo**: um ou mais visuais pequenos, cada um ao lado do texto curto que ele sustenta. Use um, às vezes vários, raramente todos. Mantenha só as chamadas, arquivos, props e fronteiras de que quem revisa precisa.
- **Evidência**: um antes e um depois. Uma screenshot é a evidência mais forte quando a mudança é visual e o [environment](https://www.aihero.dev/ai-coding-dictionary/environment) consegue tirar uma. Caso contrário, use o teste exato que falhava e agora passa, escrito em pseudocódigo, ou a saída de console que mudou.
- **Risco do merge**: se a mudança é uma **porta de mão única** ou uma **porta de mão dupla**, e o **blast radius** dela. Uma porta de mão dupla é barata de reverter; uma porta de mão única (uma migração destrutiva, a remoção de uma API pública, uma decisão difícil de reverter) não é. O blast radius diz o que poderia quebrar se a mudança estiver errada: deslocamento de layout, quem consome uma API, responsividade no celular.

A avaliação da porta é a ideia central. Ela transforma "isto é seguro de mergear?" de uma intuição numa afirmação explícita da qual quem revisa pode discordar. Ela também diz onde gastar a [human review](https://www.aihero.dev/ai-coding-dictionary/human-review). Passe os olhos numa porta de mão dupla com blast radius pequeno, e leia devagar uma porta de mão única.

## Perguntas frequentes

**Posso confiar na avaliação de porta do próprio agente?**

Não às cegas, e é exatamente por isso que ela é declarada. O agente que escreveu a mudança é o mesmo que a avalia, então desconfie mais quando ele disser "mão dupla, blast radius pequeno". O diff também costuma esconder se uma mudança pode ser revertida. Como disse um usuário, "reverter um commit não desenvia um lote de e-mails", e um rollout controlado por flag só continua de mão dupla até a primeira escrita cair no formato novo. A skill dá ao agente uma definição (ações destrutivas e decisões difíceis de reverter são de mão única), não um checklist, então confira a linha de Risco do merge com mais cuidado. Duas coisas ajudam: garanta que o agente tenha o [ticket](https://www.aihero.dev/ai-coding-dictionary/ticket) ou a [spec](https://www.aihero.dev/ai-coding-dictionary/spec) na frente dele, não só o diff, e escreva as mudanças que o seu repositório sempre trata como de mão única (migrações de schema, qualquer coisa que sai para fora ou apaga) num lugar que o agente leia antes de fazer a avaliação.

**Ela abre o PR para mim?**

Não. A `pr` cobre só o corpo. A [implement](./implement.md) termina fazendo commit no branch atual. Pedidos de uma skill ou opção que abra o PR (uma `/to-pr`, ou a `implement` abrindo um PR em vez de fazer commit) ainda são propostas em aberto. A solução de um usuário é uma sobrescrita local de uma frase na `implement` mandando-a abrir um PR. A [implement-spec](./implement-spec.md) é a exceção: ela abre um draft PR quando o seu issue tracker fecha trabalho por meio de PRs ou quando você pede um. Como a `pr` é invocada pelo modelo, o agente usa este formato para o corpo sempre que você pedir para ele abrir um PR.

**Ela não vai só produzir mais uma parede de texto e diagramas?**

A skill foi projetada para evitar isso, mas ainda pode acontecer. A reclamação dos usuários sobre corpos de PR escritos por agentes é constante: "um resumo enorme, mas tudo o que eu preciso saber é o que mudou, como foi verificado, o que pode quebrar e se é seguro mergear." A skill manda o agente pular preâmbulos, manter a prosa breve e escolher a menor visualização, normalmente um visual e raramente todos. Se você ainda receber uma pilha de diagramas, o agente ignorou isso. Se o corpo é enorme porque o diff é enorme, o problema é o tamanho do PR, e a `pr` não vai dividi-lo para você.

**Meu repositório já tem um modelo de PR. Qual vence?**

Nenhum, por padrão. A `pr` tem o próprio modelo e não procura `.github/pull_request_template.md` nem nada parecido. Vários usuários pediram que a skill usasse o modelo do repositório. Se você não fizer nada, o agente fica com duas instruções concorrentes para o mesmo documento. Resolva isso na documentação para agentes do seu repositório, por exemplo preenchendo o modelo do repositório e colocando Resumo, Evidência e Risco do merge dentro dele.

**A saída é HTML? Por que o diagrama Mermaid não renderiza?**

A saída é um corpo de PR em markdown, não uma página HTML. O GitHub e o GitLab renderizam blocos Mermaid na descrição de um PR, mas um terminal não, então o diagrama aparece como texto cru enquanto o agente ainda está te mostrando localmente. Usuários de harnesses de CLI contornaram isso com um renderizador de Mermaid em ASCII ou fazendo o agente anexar uma versão HTML ao PR. O Mermaid é uma de seis visualizações. Uma árvore de chamadas, uma árvore de arquivos ou um diff com formato próprio se leem igual em qualquer lugar.

**Ela consegue organizar os comentários de revisão que voltam?**

Não. Ela escreve o corpo e para. Os usuários já pediram mais de uma vez um jeito de fazer a triagem de comentários de outros desenvolvedores ou de bots de revisão (quais valem uma ação, quais não são problema). Esta skill não faz isso.

**Ela mantém o corpo atualizado conforme o PR muda?**

Não. Ela escreve o corpo num momento, e um PR que muda durante a revisão deixa esse corpo desatualizado. Peça ao agente para reescrever o corpo depois de uma mudança grande. Como o agente está escrevendo o corpo de um PR de novo, ele usa o mesmo formato.

**Minha mudança não tem UI. O que vai em Evidência?**

Tudo menos a screenshot. A screenshot só é a evidência mais forte quando a mudança é visual. Para uma migração, um job em segundo plano ou uma refatoração, a evidência é o teste exato que falhava antes e passa agora, ou a saída de console que mudou. "Os testes estão verdes" sozinho é uma afirmação, não um antes e depois.

**Ela consegue marcar o corpo como escrito por um LLM?**

Não sozinha. A abordagem de um usuário é uma instrução permanente na documentação para agentes do repositório dizendo que toda issue, comentário e PR que o agente escrever termina com uma linha de aviso. Essa regra pertence ao repositório, onde cobre tudo o que o agente publica, e não ao modelo de um tipo de documento.

## Está funcionando se

- Você consegue dizer o que o PR muda só pelo visual do Resumo, antes de abrir o diff.
- O corpo não tem preâmbulo: começa no título Resumo.
- A seção de Evidência mostra um antes e um depois, não uma afirmação de que os testes passam.
- Todo PR declara uma porta e um blast radius, e as portas de mão única são aquelas em que você desacelera.

## Onde se encaixa

A `pr` vem entre a revisão e a retro quando a construção é entregue como pull request: `to-spec → to-tickets → implement → code-review → pr → retro`. Ela é invocada pelo modelo, então também dispara sozinha sempre que o agente escreve o corpo de um PR fora dessa cadeia.

- A [code-review](./code-review.md) roda antes dela, porque o corpo de um PR deve descrever um diff que já foi revisado.
- A [implement](./implement.md) produz os commits que o corpo descreve.

A [ask-matt](./ask-matt.md) te orienta por todo o conjunto quando você não tiver certeza de qual skill a situação pede.
