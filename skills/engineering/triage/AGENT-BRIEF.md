# Escrevendo briefings de agente

Um briefing de agente é um comentário estruturado publicado numa issue ou PR do GitHub quando ele vai para `ready-for-agent`. É a especificação com autoridade a partir da qual um agente AFK vai trabalhar. O corpo original e a discussão são contexto: o briefing de agente é o contrato.

O briefing diz **o que o agente deve fazer**, o que vale para os dois canais: para uma issue, é construir a mudança do zero; para um PR, é o que falta fazer *sobre o diff existente*: terminá-lo, fechar lacunas, atender pontos de revisão. Os princípios são os mesmos; o exemplo de PR abaixo mostra a diferença.

## Princípios

### Durabilidade acima de precisão

A issue pode ficar em `ready-for-agent` por dias ou semanas. O código vai mudar nesse meio-tempo. Escreva o briefing de modo que ele continue útil mesmo com arquivos renomeados, movidos ou refatorados.

- **Faça**: descreva interfaces, tipos e contratos de comportamento
- **Faça**: nomeie tipos, assinaturas de função ou formatos de configuração específicos que o agente deve procurar ou modificar
- **Não faça**: citar caminhos de arquivo; eles ficam obsoletos
- **Não faça**: citar números de linha
- **Não faça**: presumir que a estrutura atual da implementação vai continuar a mesma

### Comportamental, não procedural

Descreva **o que** o sistema deve fazer, não **como** implementar. O agente vai explorar o código do zero e tomar as próprias decisões de implementação.

- **Bom:** "O tipo `SkillConfig` deve aceitar um campo opcional `schedule` do tipo `CronExpression`"
- **Ruim:** "Abra src/types/skill.ts e adicione um campo schedule na linha 42"
- **Bom:** "Quando um usuário rodar `/triage` sem argumentos, ele deve ver um resumo das issues que precisam de atenção"
- **Ruim:** "Adicione um switch na função principal do handler"

### Critérios de aceitação completos

O agente precisa saber quando terminou. Todo briefing de agente precisa ter critérios de aceitação concretos e testáveis. Cada critério deve ser verificável de forma independente.

- **Bom:** "Rodar `gh issue list --label needs-triage` retorna issues que já passaram pela classificação inicial"
- **Ruim:** "A triagem deve funcionar corretamente"

### Limites de escopo explícitos

Diga o que está fora do escopo. Isso impede o agente de enfeitar demais ou de fazer suposições sobre funcionalidades vizinhas.

## Modelo

```markdown
## Briefing para o agente

**Categoria:** bug / enhancement
**Resumo:** descrição de uma linha do que precisa acontecer

**Comportamento atual:**
Descreva o que acontece hoje. Para bugs, é o comportamento quebrado.
Para enhancements, é o status quo sobre o qual a funcionalidade se apoia.

**Comportamento desejado:**
Descreva o que deve acontecer depois que o trabalho do agente terminar.
Seja específico sobre casos-limite e condições de erro.

**Interfaces-chave:**
- `NomeDoTipo`: o que precisa mudar e por quê
- Tipo de retorno de `nomeDaFuncao()`: o que retorna hoje vs. o que deveria retornar
- Formato de configuração: quaisquer novas opções de configuração necessárias

**Critérios de aceitação:**
- [ ] Critério específico e testável 1
- [ ] Critério específico e testável 2
- [ ] Critério específico e testável 3

**Fora do escopo:**
- Algo que NÃO deve ser alterado ou tratado nesta issue
- Funcionalidade vizinha que pode parecer relacionada, mas é separada
```

## Exemplos

### Bom briefing de agente (bug)

```markdown
## Briefing para o agente

**Categoria:** bug
**Resumo:** O corte da descrição de skill quebra no meio da palavra e gera saída quebrada

**Comportamento atual:**
Quando a descrição de uma skill passa de 1024 caracteres, ela é cortada em
exatamente 1024 caracteres, sem respeitar o limite das palavras. Isso gera
descrições que terminam no meio de uma palavra (ex.: "Use quando o usuário quiser confi").

**Comportamento desejado:**
O corte deve acontecer no último limite de palavra antes dos 1024 caracteres
e acrescentar "..." para indicar que houve corte.

**Interfaces-chave:**
- O campo `description` do tipo `SkillMetadata`: nenhuma mudança de tipo,
  mas a lógica de validação/processamento que o preenche precisa respeitar
  os limites de palavra
- Qualquer função que lê o frontmatter do SKILL.md e extrai a descrição

**Critérios de aceitação:**
- [ ] Descrições com menos de 1024 caracteres ficam inalteradas
- [ ] Descrições com mais de 1024 caracteres são cortadas no último limite
      de palavra antes dos 1024 caracteres
- [ ] Descrições cortadas terminam com "..."
- [ ] O tamanho total incluindo "..." não passa de 1024 caracteres

**Fora do escopo:**
- Mudar o próprio limite de 1024 caracteres
- Suporte a descrições com várias linhas
```

### Bom briefing de agente (enhancement)

```markdown
## Briefing para o agente

**Categoria:** enhancement
**Resumo:** Adicionar suporte ao diretório `.out-of-scope/` para registrar pedidos de funcionalidade rejeitados

**Comportamento atual:**
Quando um pedido de funcionalidade é rejeitado, a issue é fechada com a label
`wontfix` e um comentário. Não existe registro persistente da decisão nem do
raciocínio. Pedidos parecidos no futuro exigem que o mantenedor se lembre ou
procure a discussão anterior.

**Comportamento desejado:**
Pedidos de funcionalidade rejeitados devem ser documentados em arquivos
`.out-of-scope/<conceito>.md` que registram a decisão, o raciocínio e os links
para todas as issues que pediram a funcionalidade. Ao triar issues novas,
esses arquivos devem ser consultados em busca de correspondências.

**Interfaces-chave:**
- Formato dos arquivos markdown em `.out-of-scope/`: cada arquivo deve ter um
  título `# Nome do conceito`, uma linha `**Decisão:**`, uma linha `**Motivo:**`
  e uma lista `**Pedidos anteriores:**` com links para as issues
- O fluxo de triagem deve ler todos os arquivos `.out-of-scope/*.md` logo no
  início e comparar as issues que chegam com eles por semelhança de conceito

**Critérios de aceitação:**
- [ ] Fechar uma funcionalidade como wontfix cria/atualiza um arquivo em `.out-of-scope/`
- [ ] O arquivo inclui a decisão, o raciocínio e o link para a issue fechada
- [ ] Se já existir um arquivo correspondente em `.out-of-scope/`, a issue nova
      é acrescentada à lista de "Pedidos anteriores" dele em vez de criar uma duplicata
- [ ] Durante a triagem, os arquivos existentes em `.out-of-scope/` são consultados
      e apresentados quando uma issue nova corresponde a uma rejeição anterior

**Fora do escopo:**
- Correspondência automatizada (um humano confirma a correspondência)
- Reabrir funcionalidades rejeitadas anteriormente
- Relatos de bug (só rejeições de enhancement vão para `.out-of-scope/`)
```

### Bom briefing de agente (PR)

Para um PR, o "Comportamento atual" descreve o estado do diff, e o briefing pede ao agente que termine ou corrija o diff em vez de construir do zero.

```markdown
## Briefing para o agente

**Categoria:** enhancement
**Resumo:** Terminar a flag de saída `--json` do contribuidor para `triage list`

**Comportamento atual:**
O PR adiciona uma flag `--json` que serializa a lista de issues em JSON. O caminho
feliz funciona e o diff segue a estrutura de comandos do projeto. Restam duas
lacunas: os erros ainda são impressos como texto para humanos (não JSON), e a
flag nova não tem cobertura de testes.

**Comportamento desejado:**
Com `--json`, toda a saída (inclusive erros) é JSON bem formado no stdout,
e os códigos de saída do comando não mudam. A saída legível para humanos
existente fica intocada quando a flag não é passada.

**Interfaces-chave:**
- O caminho de erro do comando deve emitir `{ "error": string }` com `--json`,
  em vez do erro em texto puro
- Reaproveite o serializador que o PR já adicionou; não introduza um segundo

**Critérios de aceitação:**
- [ ] `triage list --json` emite JSON válido tanto no sucesso quanto no erro
- [ ] Os códigos de saída batem com os do comando sem JSON
- [ ] Um teste cobre a saída de sucesso com `--json` e um caso de erro
- [ ] A saída padrão (sem JSON) fica idêntica byte a byte

**Fora do escopo:**
- Adicionar `--json` a qualquer outro comando
- Mudar o formato JSON do payload de sucesso que o PR já definiu
```

### Briefing de agente ruim

```markdown
## Briefing para o agente

**Resumo:** Corrigir o bug da triagem

**O que fazer:**
A coisa da triagem está quebrada. Olha o arquivo principal e conserta.
A função lá pela linha 150 tem o problema.

**Arquivos a mudar:**
- src/triage/handler.ts (linha 150)
- src/types.ts (linha 42)
```

Isto é ruim porque:
- Não tem categoria
- Descrição vaga ("a coisa da triagem está quebrada")
- Cita caminhos de arquivo e números de linha que vão ficar obsoletos
- Não tem critérios de aceitação
- Não tem limites de escopo
- Não descreve o comportamento atual vs. o desejado
