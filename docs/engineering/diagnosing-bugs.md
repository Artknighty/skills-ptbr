## O que faz

A `diagnosing-bugs` roda um diagnóstico em seis fases sobre um bug difícil ou uma regressão de performance: montar uma reprodução, minimizá-la, ordenar hipóteses, instrumentar, corrigir com um teste de regressão, limpar.

Ela não deixa o agente formar uma teoria até existir um feedback loop **enxuto**: um comando nomeado, já rodado uma vez, que fica vermelho *neste* bug e verde quando ele for corrigido. Diante de um relato de bug, um agente de código por padrão lê o código e chuta. Esta skill bloqueia isso. Se não existe um comando capaz de ficar vermelho, não existe Fase 2. Essa única barreira é a razão de ser da skill. Depois que o loop existe, tudo o que vem depois (bisect, teste de hipóteses, instrumentação) é mecânico.

## Quando usar

Digite `/diagnosing-bugs`, ou o agente recorre a ela sozinho quando uma tarefa se encaixa. Ela é invocada pelo modelo e dispara com "diagnostique" ou "debuga isso", ou com um relato de que algo está quebrado, lançando erro, falhando ou lento.

Use nos difíceis: um bug que você não resolve na primeira olhada, uma falha intermitente, uma regressão introduzida entre dois estados sabidamente bons. Ela é lenta e minuciosa de propósito, então é a ferramenta errada para uma pergunta que você quer respondida numa mensagem.

| A sua situação | Para onde ir |
| --- | --- |
| Um defeito específico que você consegue descrever como sintoma | Esta skill |
| Um endpoint lento ou uma regressão de tempo com um antes e depois conhecidos | Esta skill. Ela tem um ramo de performance (meça uma base, depois faça bisect) |
| "Onde estão os gargalos desta codebase?", sem sintoma específico | Não esta skill. Ela diagnostica uma falha conhecida, não faz auditoria |
| Um relato de bug cru de outra pessoa, ainda não confirmado nem escrito direito | [triage](./triage.md) primeiro |
| Código descartável para responder uma pergunta de design, não caçar um defeito | [prototype](./prototype.md) |
| Construir um comportamento planejado com teste primeiro | [tdd](./tdd.md) |
| Perguntar o que teria evitado o bug, depois de corrigido | [retro](./retro.md), rodada na mesma sessão |
| Não existe um bom seam para travar o bug | [improve-codebase-architecture](./improve-codebase-architecture.md), que você mesmo inicia |

## O loop enxuto é a skill

A Fase 1 recebe o maior esforço porque é a única fase difícil. A skill lista formas de montar o loop, mais ou menos em ordem de preferência:

1. Um teste que falha em qualquer seam que alcance o bug.
2. Um script curl ou HTTP contra um servidor de desenvolvimento rodando.
3. Uma invocação de CLI com uma fixture de entrada, comparada com um snapshot sabidamente correto.
4. Um script de navegador headless fazendo asserções sobre DOM, console ou rede.
5. Uma captura reproduzida: uma requisição, payload ou log de eventos salvo, rodado isoladamente pelo caminho de código.
6. Um harness descartável: um subconjunto mínimo do sistema, uma chamada de função.
7. Um loop de property testing ou fuzzing, para "às vezes a saída sai errada".
8. Um harness de bisect que você pode entregar ao `git bisect run`.
9. Um loop diferencial: a mesma entrada, versão antiga contra a nova.
10. Um script bash [human in the loop](https://www.aihero.dev/ai-coding-dictionary/human-in-the-loop), último recurso. A skill traz o `scripts/hitl-loop.template.sh` para isso: o agente roda o script, você segue as instruções no seu terminal, e as suas respostas voltam como saída interpretável.

Ter *um* loop não é o objetivo. **Enxuto** é: rápido (segundos), determinístico (o mesmo veredito a cada execução), nítido (faz a asserção sobre o seu sintoma exato, não "não quebrou") e executável pelo agente sem você. Um loop instável de 30 segundos é pouco melhor do que nenhum. Para um bug que só aparece às vezes, o alvo não é uma reprodução limpa, e sim uma **taxa de reprodução maior**: repita o gatilho, paralelize, acrescente estresse, injete sleeps, até a taxa de falha ficar alta o bastante para depurar.

Quando o agente não consegue montar um, a skill manda ele parar e dizer isso, listar o que tentou e te pedir acesso ao [environment](https://www.aihero.dev/ai-coding-dictionary/environment), um artefato capturado ou permissão para adicionar instrumentação temporária. Ele não pode seguir para as hipóteses mesmo assim.

## As barreiras entre as fases

As fases são barreiras, não um checklist. O agente não consegue entrar numa fase até uma condição específica ser verdadeira.

| Barreira | O que precisa ser verdade |
| --- | --- |
| Entrar na Fase 2 | Um comando nomeado, já rodado e mostrado com a saída, que consegue ficar vermelho neste bug |
| Entrar na Fase 3 | A reprodução foi reproduzida *e* minimizada: todo elemento restante é necessário para reproduzir o bug |
| Entrar na Fase 4 | Existem de 3 a 5 hipóteses ordenadas e falseáveis, cada uma com a sua previsão, mostradas a você antes de qualquer teste |
| Entrar na Fase 5 | As sondas correspondem a uma previsão específica, uma variável por vez, e todo log de depuração tem uma marca como `[DEBUG-a4f2]`, para que um grep encontre todos na limpeza |
| Pronto | A reprodução original não reproduz mais, a instrumentação sumiu, e a mensagem de commit cita a hipótese que se revelou correta |

A Fase 5 tem uma exceção. O agente escreve o teste de regressão antes da correção, mas só se existir um **seam correto** para ele: um em que o teste exercite o padrão real do bug como ele ocorre no ponto de chamada. Quando o único seam disponível for raso demais, a skill manda o agente dizer isso em vez de escrever um teste que dá falsa confiança. O seam que falta é por si só uma descoberta, e o agente o registra em vez de escondê-lo.

## Perguntas frequentes

**Ela dispara em perguntas rápidas em que eu só queria uma resposta direta.**
Este é o problema mais relatado da skill. Especialmente no GPT-5.6-Sol, os usuários relatam que ela dispara com uma simples descrição de um problema: "o modelo dispara a skill diagnosing-bugs, bem formal, em vez disso. Aí ele monta um cenário de reprodução (muitas vezes um cenário mockado de pouco valor) antes de me dar uma resposta ou sugestão. Isso gera atrasos consideráveis nas respostas." Quatro pessoas diferentes relataram o mesmo problema na [issue #578](https://github.com/mattpocock/skills/issues/578). A correção aceita é começar com uma abordagem mais leve e só passar para o diagnóstico completo quando o problema exigir, mas essa mudança não foi lançada. A skill está ajustada para o comportamento de invocação do Claude Code, e um [model](https://www.aihero.dev/ai-coding-dictionary/model) com limiar de ativação mais baixo a dispara demais. Até a correção sair, a solução é dizer o que você quer ("só responde isso, não diagnostica") ou desligar a invocação pelo modelo para ela no seu [harness](https://www.aihero.dev/ai-coding-dictionary/harness).

**Posso apontá-la para uma codebase e perguntar onde estão os problemas de performance?**
Não. Ela diagnostica uma falha que você já consegue nomear. O ramo de performance dela é para uma regressão com sintoma (estabeleça uma medição de base, depois faça bisect; meça primeiro, corrija depois), não para uma varredura proativa. Uma skill para a versão proativa foi [proposta e fechada](https://github.com/mattpocock/skills/issues/431); nenhuma skill faz isso hoje.

**Ela para e me pergunta antes de escrever a correção?**
Não. Só a Fase 3 tem um checkpoint humano: a lista ordenada de hipóteses é mostrada a você antes de qualquer teste, e o agente segue com a própria ordem se você estiver ausente. Não há barreira entre a instrumentação e a correção, então o agente pode começar a escrever código antes de você concordar com a causa raiz dele. A [issue #124](https://github.com/mattpocock/skills/issues/124) pede essa barreira e continua aberta. Se você a quiser, diga isso ao invocar a skill.

**Já rodei `/triage` neste relato de bug. Isto é o mesmo trabalho de novo?**
Em parte, e nenhuma das skills diz isso. Como disse um leitor: "O passo 3 da triage é basicamente uma instância rasa e limitada das Fases 1 e 2 da diagnosing-bugs, mas nenhum dos arquivos menciona o outro." A triage faz uma passada limitada de "isto é mesmo um bug, e qual é a superfície"; esta skill faz a versão minuciosa. Rodar a triage antes não é desperdício, porque a verificação dela costuma te dar a maior parte da matéria-prima da Fase 1. Mas espere que esta skill refaça esse trabalho por inteiro, e não espere uma referência cruzada avisando.

**A saída da reprodução que ela mostra pode vazar segredos?**
Pode. A skill pede ao agente para mostrar a invocação e a saída, e para pedir artefatos como arquivos HAR, dumps de log e core dumps. A [issue #674](https://github.com/mattpocock/skills/issues/674) levanta exatamente isso (credenciais, tokens, cookies e dados pessoais copiados para um chat, uma issue ou um PR) e propõe um guardrail de ocultação. (Nota da tradução: a versão do `SKILL.md` em que esta tradução se baseia já tem uma seção "Oculte segredos" que manda trocar todo segredo por `<REDACTED>`; esta resposta do original é anterior a ela.) Mesmo assim, confira você mesmo, principalmente antes de a saída ir para algum lugar público.

**O meu scanner de segurança marcou esta skill como de alto risco.**
O Snyk a marca, e é um falso positivo. Ela é a única skill do conjunto que traz um script de shell executável (`hitl-loop.template.sh`) junto com instruções para rodá-lo e para fazer curl num servidor de desenvolvimento. Um `.sh` distribuído, instruções para rodá-lo e HTTP de saída juntos bastam para disparar um scanner estático. O script em si tem umas 30 linhas de prompts `read -r -p` que param esperando entrada humana. O scanner avalia o que a skill poderia fazer, não uma exploração comprovada.

**O que aconteceu com a `/diagnose`?**
A v1.0.0 a renomeou para `/diagnosing-bugs`. O nome antigo não existe mais. Qualquer coisa sua que encadeie `/diagnose` (uma skill invólucro, um prompt salvo) precisa ser atualizada.

## Está funcionando se

- Ela te mostra um comando e a saída vermelha dele antes de oferecer uma única teoria. Se a teoria vier primeiro, a skill não está rodando.
- A falha que ela reproduz é a que você relatou, não uma parecida que encontrou no caminho.
- Ela encolhe a reprodução antes de começar a chutar, e sabe te dizer por que precisa de cada peça restante.
- Ela te mostra uma lista ordenada de 3 a 5 hipóteses, cada uma com uma previsão que você poderia falsear, antes de testar qualquer uma.
- Todo log de depuração que ela acrescenta tem uma marca como `[DEBUG-a4f2]`, e um grep por essa marca volta vazio quando ela declara pronto.
- A mensagem do commit ou do PR diz qual hipótese estava certa.
- Quando não consegue travar o bug com um teste, ela diz isso em vez de escrever um teste raso.

## Onde se encaixa

A `diagnosing-bugs` é uma avulsa para usar a qualquer hora. Você a inicia quando algo está quebrado, e ela termina quando a correção e o teste de regressão dela entram. Ela não guarda estado e não precisa de configuração prévia. A [ask-matt](./ask-matt.md) encaminha "algo está quebrado" para cá.

Duas vizinhas importam. A [retro](./retro.md) vem depois: quando a correção entrar, rode-a na mesma sessão para perguntar o que teria evitado o bug, enquanto a sessão tem mais informação do que tinha no começo. A `diagnosing-bugs` nunca invoca a `retro` sozinha, porque a `retro` é invocada pelo usuário. A [triage](./triage.md) vem antes, para bugs que chegam como relatos crus de outras pessoas, e faz uma versão mais rasa das mesmas duas primeiras fases.
