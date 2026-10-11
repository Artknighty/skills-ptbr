---
name: to-tickets
description: Quebra um plano, uma spec ou a conversa atual em um conjunto de tickets tracer-bullet, cada um declarando suas arestas de bloqueio, publicados no tracker configurado (arestas como texto, um arquivo por ticket, no modo local; ou links de bloqueio nativos num tracker real).
disable-model-invocation: true
---

# To Tickets

Quebre um plano, uma spec ou uma conversa em um conjunto de **tickets**: vertical slices tracer-bullet, cada uma declarando os tickets que a **bloqueiam**.

O issue tracker e o vocabulário de labels de triagem já devem ter sido fornecidos a você. Se não, diga ao usuário para rodar `/setup-matt-pocock-skills`.

## Processo

### 1. Reúna o contexto

Trabalhe a partir do que já estiver no contexto da conversa. Se o usuário passar uma referência (caminho de uma spec, número ou URL de uma issue) como argumento, busque-a e leia o corpo inteiro e os comentários.

### 2. Explore o código (opcional)

Se ainda não explorou o código, explore para entender o estado atual. Os títulos e descrições dos tickets devem usar o vocabulário do glossário de domínio do projeto e respeitar os ADRs da área que você está mexendo.

Procure oportunidades de pré-refatorar o código para facilitar a implementação. "Torne a mudança fácil, depois faça a mudança fácil."

### 3. Esboce os vertical slices

Quebre o trabalho em tickets **tracer bullet**.

<vertical-slice-rules>

- Cada slice corta um caminho estreito, mas COMPLETO, por todas as camadas (schema, API, UI, testes): vertical, NÃO um slice horizontal de uma camada só
- Um slice concluído pode ser demonstrada ou verificada sozinha
- Cada slice é dimensionado para caber numa única janela de contexto nova
- Qualquer pré-refatoração deve ser feita primeiro

</vertical-slice-rules>

Dê a cada ticket suas **arestas de bloqueio**: os outros tickets que precisam ser concluídos antes que ele possa começar. Um ticket sem bloqueadores pode começar imediatamente.

**Refatorações amplas são a exceção ao vertical slicing.** Uma **refatoração ampla** é uma mudança mecânica (renomear uma coluna, mudar o tipo de um símbolo compartilhado) cujo **blast radius** se espalha pelo código inteiro, de modo que uma única edição quebra milhares de pontos de chamada de uma vez e nenhum vertical slice consegue entrar verde. Não force isso num tracer bullet; sequencie como **expand–contract** (expandir–contrair). Primeiro expanda: acrescente a forma nova ao lado da antiga para que nada quebre. Depois migre os pontos de chamada em lotes dimensionados pelo blast radius (por pacote, por diretório), cada lote como seu próprio ticket bloqueado pela expansão, mantendo o CI verde de lote em lote porque a forma antiga ainda existe. Por fim contraia: apague a forma antiga quando não restar nenhum chamador, num ticket bloqueado por todos os lotes de migração. Quando nem os lotes conseguirem ficar verdes sozinhos, mantenha a sequência, mas deixe-os compartilhar um branch de integração em que todos bloqueiam um ticket final de integrar-e-verificar; o verde só é prometido ali.

### 4. Valide com o usuário

Apresente a divisão proposta como uma lista numerada. Para cada ticket, mostre:

- **Título**: nome curto e descritivo
- **Bloqueado por**: quais outros tickets (se houver) precisam ser concluídos antes
- **O que entrega**: o comportamento de ponta a ponta que este ticket faz funcionar

Pergunte ao usuário:

- A granularidade parece certa? (grossa demais / fina demais)
- As arestas de bloqueio estão corretas: cada ticket depende só de tickets que realmente o condicionam?
- Algum ticket deveria ser juntado ou dividido mais?

Itere até o usuário aprovar a divisão.

### 5. Publique os tickets no tracker configurado

Publique os tickets aprovados. **Como** depende do tracker que a `/setup-matt-pocock-skills` configurou; os tickets são os mesmos em qualquer caso, só muda o formato das arestas de bloqueio:

- **Arquivos locais** → escreva um arquivo por ticket em `.scratch/<slug-da-feature>/issues/<NN>-<slug>.md`, numerados a partir de `01` em ordem de dependência (bloqueadores primeiro). O "Bloqueado por" de cada arquivo lista os números/títulos de que ele depende. Use o modelo de arquivo por ticket abaixo: um ticket por arquivo, nunca um único arquivo combinado.
- **Um issue tracker real (GitHub, Linear, …)** → publique uma issue por ticket em ordem de dependência (bloqueadores primeiro), para que as arestas de bloqueio de cada ticket possam referenciar identificadores reais. Use a relação de bloqueio nativa da plataforma quando houver; senão, preencha o "Bloqueado por" de cada ticket com as issues bloqueadoras. Se a origem foi uma issue existente, faça de cada ticket uma sub-issue dela (operação do documento do tracker). Aplique a label de triagem `ready-for-agent`, salvo instrução em contrário; os tickets são, por construção, prontos para um agente pegar.

Trabalhe a **fronteira**: qualquer ticket cujos bloqueadores estejam todos concluídos. Numa cadeia puramente linear, isso significa de cima para baixo.

NÃO feche nem modifique nenhuma issue mãe.

<local-ticket-template>

# <NN>: <Título do ticket>

**O que construir:** o comportamento de ponta a ponta que este ticket faz funcionar, do ponto de vista do usuário, não uma lista de implementação camada por camada.

**Bloqueado por:** os números/títulos dos tickets que condicionam este, ou "Nenhum (pode começar imediatamente)".

**Status:** ready-for-agent

- [ ] Critério de aceitação 1
- [ ] Critério de aceitação 2

</local-ticket-template>

<issue-template>

## Issue mãe

Uma referência à issue mãe no tracker (se a origem foi uma issue existente; caso contrário, omita esta seção).

## O que construir

O comportamento de ponta a ponta que este ticket faz funcionar, do ponto de vista do usuário, não implementação camada por camada.

## Critérios de aceitação

- [ ] Critério 1
- [ ] Critério 2

## Bloqueado por

- Uma referência a cada ticket bloqueador, ou "Nenhum (pode começar imediatamente)". Omita esta seção quando os bloqueadores tiverem sido definidos como arestas nativas.

</issue-template>

Em qualquer das formas, evite caminhos de arquivo ou trechos de código específicos: ficam obsoletos rápido. Exceção: se um protótipo produziu um trecho que codifica uma decisão com mais precisão do que a prosa consegue (máquina de estados, reducer, schema, formato de tipo), coloque-o inline e anote brevemente que veio de um protótipo. Corte até as partes ricas em decisão, não uma demo funcional, só o que importa.
