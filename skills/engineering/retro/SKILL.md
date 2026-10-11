---
name: retro
description: "Faz uma retrospectiva de uma sessão de código."
disable-model-invocation: true
---

O usuário pediu uma **retrospectiva**. Você está sugerindo melhorias no **ambiente** do agente de código para melhorar as próximas execuções.

## Passos

1. Chame a ferramenta Skill com `writing-for-agents` para o guia de estilo de escrita.

2. Leia as fontes primárias da sessão que o usuário indicar. Isso pode significar procurar nos logs de sessão desta máquina. Se o usuário não indicar uma sessão, use a atual.

3. Procure candidatos a melhoria nestas categorias.

- **Navegação**: foi fácil para o agente encontrar os arquivos certos? Há dependências escondidas entre arquivos? Um **ponteiro de navegação** facilitaria? _Use quando_ a sessão demorou para encontrar uma informação.
- **Verificações automatizadas**: há verificações automatizadas que poderiam pegar erros que o agente cometeu? Lint, tipagem, testes, linters de sistema de arquivos? Leia primeiro o próprio comando de verificação do repositório (os scripts `lint`/`check` do `package.json`/ferramenta de build, o workflow de CI), para que uma verificação que já existe mas está desligada ou silenciosamente quebrada seja a descoberta, e não uma reinvenção. Um repositório sem nenhum **guardrail** (nenhum hook de pre-commit e nenhum job de CI rodando o comando de lint/typecheck/teste) é por si só uma descoberta: um repositório sem lint é uma oportunidade perdida permanente, não um padrão neutro. _Use quando_ o agente cometeu um erro que uma verificação automatizada poderia ter pegado, ou quando o repositório não tem guardrail nenhum.
- **Padrões de código**: o **agente revisor** deveria receber uma nova regra para aplicar? Alguma regra existente deveria ser removida ou esclarecida? Classifique a violação primeiro: uma **mecânica** (um padrão sintático fixo, uma API proibida, um formato de import, uma regra de localização de arquivo) ganha uma verificação determinística, ponto: uma regra customizada no linter do próprio repositório, um novo hook de pre-commit ou um novo job de CI, o que a linguagem do repositório e o guardrail existente tornarem mais barato. Por padrão, construa a verificação em vez de escrever a regra. Reserve o `CODING_STANDARDS.md` para genuínas **decisões de julgamento** (consistência entre arquivos, "combina com o estilo ao redor", qualquer coisa que nenhum guardrail jamais conseguiria substituir). _Use quando_ o agente revisor não pegou um erro.
- **AGENTS.md global**: há instruções de orientação que deveriam ir para os padrões de código (ou para verificações automatizadas)? _Use quando_ o arquivo AGENTS.md estiver especialmente grande, no repositório OU no escopo global do usuário.
- **Economia de ferramentas**: o agente fez chamadas de ferramenta caras que poderiam ser enxugadas? Existe alguma ferramenta customizada (CLIs, MCPs) especialmente ineficiente em tokens? _Use quando_ o agente fez uma chamada de ferramenta cara.
- **No-ops**: procure instruções nos arquivos de orientação que não modificam o comportamento do agente. _Use quando_ os arquivos de orientação estiverem grandes e difíceis de manejar.
- **Acesso a informação**: procure oportunidades de aumentar o acesso do agente a informação. Espelhar os logs do servidor de desenvolvimento, acesso somente leitura a serviços de terceiros. _Use quando_ uma informação crucial não estava disponível para o agente.

4. Apresente esses candidatos ao usuário, em ordem de gravidade.

## Referência

### Implementação vs. revisão

Lembre que todo trabalho passa por duas etapas: implementação e revisão. O agente de implementação é o que sofre mais **pressão de contexto**. Ele é responsável por explorar, escrever código e depurar falhas.

O agente de revisão é o que sofre menos pressão de contexto: ele recebe um diff, então não precisa explorar. Muitas vezes não precisa escrever código nem depurar.

Isso significa que o agente de revisão deve ser o responsável por impor os padrões de código, não o agente de implementação.

### Arquivos

Você tem acesso a vários arquivos no repositório:

- `CLAUDE.md`/`AGENTS.md`: estes arquivos são empurrados para a janela de contexto de qualquer agente que trabalhe neste repositório. Devem ser usados com extrema parcimônia, normalmente só para **ponteiros de navegação** para outros arquivos.
- `CODING_STANDARDS.md`: este arquivo é lido durante a revisão, não durante a implementação. Acrescente **ponteiros de navegação** para pastas de documentação se o arquivo de padrões passar de 1.000 linhas.
- Documentação: use documentos como arquivos de referência, apontados por outros arquivos. Procure documentos existentes antes de escrever novos.
- Skills: use skills para documentação (já que a descrição delas vai para a janela de contexto do agente) ou para comandos invocados pelo usuário. Siga as orientações da skill `writing-for-agents`.
