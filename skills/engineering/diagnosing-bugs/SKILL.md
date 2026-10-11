---
name: diagnosing-bugs
description: Ciclo de diagnóstico para bugs difíceis e regressões de performance. Use quando o usuário disser "diagnostique", "debuga isso", "debug this", ou relatar algo quebrado, lançando erro, falhando ou lento.
---

# Diagnosticando bugs

Uma disciplina para bugs difíceis. Pule fases só quando houver justificativa explícita.

Ao explorar o código, leia o `GLOSSARY.md` (se existir) para ter um modelo mental claro dos módulos relevantes, e consulte os ADRs da área que você está mexendo.

## Oculte segredos

Esta skill faz você mostrar comandos, saídas e artefatos capturados. **Oculte todo segredo primeiro**: escreva `<REDACTED>` no lugar dele. Monte os ciclos usando variáveis de ambiente, para que a credencial fique no ambiente e não no que você mostra. Artefatos capturados carregam headers de autenticação: cite só as linhas que carregam o sinal.

Se a saída com os segredos ocultos não bastar para diagnosticar o bug, diga isso e pergunte ao usuário.

## Fase 1: Monte um feedback loop

**Isto é a skill.** Todo o resto é mecânico. Se você tiver um sinal de passa/falha **enxuto** para o bug (um que fique vermelho _neste_ bug), você vai encontrar a causa; bisect, teste de hipóteses e instrumentação só consomem esse sinal. Se não tiver, nenhuma quantidade de olhar para o código vai te salvar.

Gaste um esforço desproporcional aqui. **Seja agressivo. Seja criativo. Recuse-se a desistir.**

### Formas de montar um, mais ou menos nesta ordem

1. **Teste que falha** em qualquer seam que alcance o bug: unitário, integração, e2e.
2. **Script curl / HTTP** contra um servidor de desenvolvimento rodando.
3. **Invocação de CLI** com uma fixture de entrada, comparando o stdout com um snapshot sabidamente correto.
4. **Script de navegador headless** (Playwright / Puppeteer) que conduz a UI e faz asserções sobre DOM/console/rede.
5. **Reproduza um trace capturado.** Salve em disco uma requisição de rede / payload / log de eventos real; reproduza-o pelo caminho de código de forma isolada.
6. **Harness descartável.** Suba um subconjunto mínimo do sistema (um serviço, dependências mockadas) que exercite o caminho de código do bug com uma única chamada de função.
7. **Loop de property testing / fuzzing.** Se o bug é "às vezes a saída sai errada", rode 1000 entradas aleatórias e procure o modo de falha.
8. **Harness de bisect.** Se o bug apareceu entre dois estados conhecidos (commit, conjunto de dados, versão), automatize "suba no estado X, verifique, repita" para poder rodar `git bisect run`.
9. **Loop diferencial.** Rode a mesma entrada pela versão antiga e pela nova (ou por duas configurações) e compare as saídas.
10. **Script bash HITL** (human in the loop). Último recurso. Se um humano precisa clicar, conduza _ele_ com `scripts/hitl-loop.template.sh` para que o loop continue estruturado. A saída capturada volta para você.

Monte o feedback loop certo e o bug está 90% corrigido.

### Aperte o loop

Trate o loop como um produto. Depois que tiver _um_ loop, deixe-o **enxuto**:

- Dá para deixá-lo mais rápido? (Cache da preparação, pular inicializações não relacionadas, estreitar o escopo do teste.)
- Dá para deixar o sinal mais nítido? (Fazer a asserção sobre o sintoma específico, não "não quebrou".)
- Dá para deixá-lo mais determinístico? (Fixar o tempo, semear o gerador aleatório, isolar o sistema de arquivos, congelar a rede.)

Um loop instável de 30 segundos é pouco melhor do que nenhum loop; um determinístico de 2 segundos é enxuto, um superpoder de depuração.

### Bugs não determinísticos

O objetivo não é uma reprodução limpa, e sim uma **taxa de reprodução maior**. Repita o gatilho 100 vezes, paralelize, adicione estresse, estreite janelas de tempo, injete sleeps. Um bug que falha em 50% das vezes é depurável; em 1%, não; então continue aumentando a taxa até ficar depurável.

### Quando você realmente não consegue montar um loop

Pare e diga isso explicitamente. Liste o que você tentou. Peça ao usuário: (a) acesso a qualquer ambiente que reproduza o bug, (b) um artefato capturado com segredos ocultos (arquivo HAR, dump de log, core dump, gravação de tela com timestamps) ou (c) permissão para adicionar instrumentação temporária em produção. **Não** siga para as hipóteses sem um loop.

### Critério de conclusão: um loop enxuto que fica vermelho

A Fase 1 termina quando o loop é **enxuto** e **capaz de ficar vermelho**: você consegue nomear **um comando** (um caminho de script, uma invocação de teste, um curl) que você **já rodou pelo menos uma vez** (mostre a invocação e a saída, com segredos ocultos), e que é:

- [ ] **Capaz de ficar vermelho**: ele conduz o caminho de código real do bug e faz a asserção sobre o **sintoma exato do usuário**, de modo que consegue ficar vermelho neste bug e verde depois de corrigido. Não "roda sem erro"; ele precisa conseguir _pegar este bug específico_.
- [ ] **Determinístico**: o mesmo veredito a cada execução (bugs instáveis: uma taxa de reprodução alta e fixa, como acima).
- [ ] **Rápido**: segundos, não minutos.
- [ ] **Executável pelo agente**: você consegue rodá-lo sem supervisão; humano no loop só via `scripts/hitl-loop.template.sh`.

Se você se pegar lendo código para montar uma teoria antes de esse comando existir, **pare: pular direto para uma hipótese é exatamente a falha que esta skill evita.** Sem comando capaz de ficar vermelho, sem Fase 2.

## Fase 2: Reproduza + minimize

Rode o loop. Veja-o ficar vermelho quando o bug aparece.

Confirme:

- [ ] O loop produz o modo de falha que o **usuário** descreveu, não uma falha diferente que por acaso está por perto. Bug errado = correção errada.
- [ ] A falha é reproduzível em várias execuções (ou, para bugs não determinísticos, reproduzível numa taxa alta o bastante para depurar).
- [ ] Você registrou o sintoma exato (mensagem de erro, saída errada, tempo lento) para que as fases seguintes possam verificar que a correção realmente o resolve.

### Minimize

Depois que estiver vermelho, encolha a reprodução até o **menor cenário que ainda fica vermelho**. Corte entradas, chamadores, configuração, dados e passos **um de cada vez**, rodando o loop de novo depois de cada corte, e mantenha só o que sustenta a falha.

Por que se dar ao trabalho: uma reprodução mínima encolhe o espaço de hipóteses na Fase 3 (menos peças móveis sob suspeita) e vira o teste de regressão limpo na Fase 5.

Pronto quando **todo elemento restante for essencial**: remover qualquer um deles faz o loop ficar verde.

Não siga adiante até ter reproduzido **e** minimizado.

## Fase 3: Levante hipóteses

Gere **de 3 a 5 hipóteses ordenadas** antes de testar qualquer uma. Gerar uma hipótese só ancora na primeira ideia plausível.

Cada hipótese precisa ser **falseável**: diga a previsão que ela faz.

> Formato: "Se <X> é a causa, então <mudar Y> vai fazer o bug sumir / <mudar Z> vai piorá-lo."

Se você não consegue dizer a previsão, a hipótese é um palpite: descarte ou afie.

**Mostre a lista ordenada ao usuário antes de testar.** Muitas vezes ele tem conhecimento de domínio que reordena tudo na hora ("acabamos de subir uma mudança no #3"), ou sabe de hipóteses que já descartou. Checkpoint barato, grande economia de tempo. Não fique bloqueado por isso; siga com a sua ordem se o usuário estiver AFK.

## Fase 4: Instrumente

Cada sonda precisa corresponder a uma previsão específica da Fase 3. **Mude uma variável por vez.**

Preferência de ferramentas:

1. **Inspeção com depurador / REPL**, se o ambiente suportar. Um breakpoint vale mais que dez logs.
2. **Logs direcionados** nas fronteiras que distinguem as hipóteses.
3. Nunca "logar tudo e dar grep".

**Marque todo log de depuração** com um prefixo único, ex.: `[DEBUG-a4f2]`. A limpeza no final vira um único grep. Logs sem marca sobrevivem; logs marcados morrem.

**Ramo de performance.** Para regressões de performance, logs geralmente são a ferramenta errada. Em vez disso: estabeleça uma medição de base (harness de tempo, `performance.now()`, profiler, plano de consulta) e depois faça bisect. Meça primeiro, corrija depois.

## Fase 5: Corrija + teste de regressão

Escreva o teste de regressão **antes da correção**, mas só se houver um **seam correto** para ele.

Um seam correto é aquele em que o teste exercita o **padrão real do bug** como ele ocorre no ponto de chamada. Se o único seam disponível for raso demais (teste com um só chamador quando o bug precisa de vários, teste unitário que não consegue replicar a cadeia que disparou o bug), um teste de regressão ali dá uma falsa confiança.

**Se não existe um seam correto, isso por si só é a descoberta.** Anote. A arquitetura do código está impedindo que o bug seja travado. Sinalize isso para a próxima fase.

Se existe um seam correto:

1. Transforme a reprodução minimizada em um teste que falha nesse seam.
2. Veja-o falhar. Se você forçou o vermelho alterando código ou uma fixture, faça `diff` contra uma cópia intacta para provar que a alteração entrou antes de confiar nela.
3. Aplique a correção.
4. Veja-o passar.
5. Rode de novo o feedback loop da Fase 1 contra o cenário original (não minimizado).

## Fase 6: Limpeza

Obrigatório antes de declarar pronto:

- [ ] A reprodução original não reproduz mais (rode de novo o loop da Fase 1)
- [ ] O teste de regressão passa (ou a ausência de seam está documentada)
- [ ] Toda a instrumentação `[DEBUG-...]` foi removida (dê `grep` no prefixo)
- [ ] Protótipos descartáveis apagados (ou movidos para um local de depuração claramente marcado)
- [ ] A hipótese que se revelou correta está escrita na mensagem do commit / PR, para que o próximo a depurar aprenda
