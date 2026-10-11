# Invocadas pelo modelo vs. invocadas pelo usuário

Todo `SKILL.md` deste repositório é uma skill. O único eixo que as separa é a **invocação**, quem consegue alcançá-la:

- **Invocada pelo usuário**: acessível **só pelo humano digitando o nome dela**. Defina `disable-model-invocation: true` no frontmatter (Claude Code) e `policy.allow_implicit_invocation: false` em `agents/openai.yaml` (Codex). A `description` é **voltada a humanos**: um resumo de uma linha lido por uma pessoa navegando pelos comandos de barra. Tire as listas de gatilho ("Use quando o usuário disser…").
- **Invocada pelo modelo**: acessível **pelo modelo ou pelo usuário**. É o padrão: omita `disable-model-invocation` e o bloco `policy` do `agents/openai.yaml`. A `description` é **voltada ao modelo** e mantém uma redação rica em gatilhos ("Use quando o usuário quiser…, mencionar…, pedir…") para que a invocação automática dispare. O teste para saber se uma skill deve continuar invocada pelo modelo: _o modelo poderia, de forma útil, recorrer a ela sozinho?_ (Reuso é o motivo para extrair uma skill, não o teste.)

Cada harness tira uma skill invocada pelo usuário do alcance do modelo do seu jeito, de modo que nada além do humano consegue dispará-la: nenhuma outra skill consegue. Uma skill invocada pelo usuário pode invocar skills invocadas pelo modelo, mas nunca consegue alcançar outra skill invocada pelo usuário.

Toda skill também tem um `agents/openai.yaml` ao lado do `SKILL.md`. Ele guarda os metadados de interface do Codex: `interface.display_name` e `interface.short_description` para o seletor de skills e, nas skills invocadas pelo usuário, o `policy.allow_implicit_invocation: false` que faz par com o `disable-model-invocation`. Mantenha os dois em sincronia: uma skill é invocada pelo usuário nos dois harnesses ou em nenhum.

Os `README.md` dos buckets e o `README.md` da raiz agrupam as entradas em **Invocadas pelo usuário** e **Invocadas pelo modelo**.

## Dependências entre elas

Dependências são expressas como uma instrução explícita para **chamar a ferramenta Skill** com a skill nomeada (`Chame a ferramenta Skill com "grilling"`), não como referências cruzadas profundas do tipo `../outra-skill/ARQUIVO.md`, nem como uma menção solta no estilo `/skill` deixada para o modelo interpretar. Nomear a ferramenta é o que faz ela disparar: a maioria dos harnesses expõe a invocação de skills como uma ferramenta que o modelo chama, e deixar isso explícito tem uma taxa de acerto maior do que soltar um `/nome` no meio do texto e torcer para ele ser lido como comando. Tirar a `/` inicial também deixa a instrução mais neutra em relação ao harness, não menos: o nome de uma skill sozinho não pressupõe a sintaxe de gatilho de nenhum harness.

Documentos de referência compartilhados vivem dentro da skill que é dona deles; outras skills chegam a esse material chamando a ferramenta Skill com ela, não linkando entre pastas.

Isto vale para instruções **operativas**: os passos de uma skill mandando o agente ir rodar outra skill agora. Um texto roteador que só nomeia skills para um humano escolher (`ask-matt`, `README.md` dos buckets) não está invocando nada, então mantém os nomes no estilo `/skill` como simples rótulos.

A ferramenta Skill recebe uma skill por chamada. Um passo que precisa de duas skills são duas chamadas, não uma chamada com dois nomes: diga isso (`Chame a ferramenta Skill duas vezes, uma para "grilling" e outra para "domain-modeling"`), não "chame-a com X e Y", que se lê como uma única chamada recebendo os dois.

Toda esta convenção só vale quando a skill nomeada é **invocada pelo modelo**. Uma skill invocada pelo usuário nunca pode ser alcançada assim, ponto: pela invariante acima, nenhuma outra skill consegue chamá-la, nem nomeando-a para a ferramenta Skill. Quando o pré-requisito de um passo for uma skill invocada pelo usuário (ex.: `setup-matt-pocock-skills`), escreva como uma instrução para o humano agir: "diga ao usuário para rodar `/setup-matt-pocock-skills`", nunca como uma chamada da ferramenta Skill.

## Trabalho de domínio passivo vs. ativo

Apenas _ler_ o `GLOSSARY.md` em busca de vocabulário é um ponteiro de uma linha em texto, não a skill `domain-modeling`. Só a disciplina ativa de construir/afiar (questionar termos, cenários de casos-limite, escrever ADRs, atualizar o `GLOSSARY.md` no caminho) é a `domain-modeling`.
