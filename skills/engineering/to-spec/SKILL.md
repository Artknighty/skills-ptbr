---
name: to-spec
description: "Transforma a conversa atual em uma spec e a publica no issue tracker do projeto: sem entrevista, só a síntese do que já foi discutido."
disable-model-invocation: true
---

Esta skill pega o contexto da conversa atual e o entendimento do código e produz uma spec. NÃO entreviste o usuário; apenas sintetize o que você já sabe.

O issue tracker e o vocabulário de labels de triagem já devem ter sido fornecidos a você. Se não, diga ao usuário para rodar `/setup-matt-pocock-skills`.

## Processo

1. Explore o repositório para entender o estado atual do código, se ainda não tiver feito isso. Use o vocabulário do glossário de domínio do projeto ao longo de toda a spec e respeite os ADRs da área que você está mexendo.

2. Esboce os seams em que você vai testar a funcionalidade. Prefira seams existentes a novos. Use o seam mais alto possível. Se forem necessários seams novos, proponha-os no ponto mais alto que conseguir. Quanto menos seams pelo código, melhor; o número ideal é um.

Confirme com o usuário que esses seams correspondem às expectativas dele.

3. Escreva a spec usando o modelo abaixo e publique-a no issue tracker do projeto. Aplique a label de triagem `ready-for-agent`; não é preciso triagem adicional.

<spec-template>

## Problema

O problema que o usuário está enfrentando, do ponto de vista do usuário.

## Solução

A solução para o problema, do ponto de vista do usuário.

## Histórias de usuário

Uma lista LONGA e numerada de histórias de usuário. Cada história deve seguir o formato:

1. Como <ator>, eu quero <funcionalidade>, para que <benefício>

<user-story-example>
1. Como cliente de banco pelo celular, eu quero ver o saldo das minhas contas, para que eu possa tomar decisões mais bem informadas sobre os meus gastos
</user-story-example>

Esta lista de histórias deve ser extremamente extensa e cobrir todos os aspectos da funcionalidade.

## Decisões de implementação

Uma lista das decisões de implementação tomadas. Pode incluir:

- Os módulos que serão construídos/modificados
- As interfaces desses módulos que serão modificadas
- Esclarecimentos técnicos do desenvolvedor
- Decisões de arquitetura
- Mudanças de schema
- Contratos de API
- Interações específicas

NÃO inclua caminhos de arquivo ou trechos de código específicos. Eles podem ficar desatualizados muito rápido.

Exceção: se um protótipo produziu um trecho que codifica uma decisão com mais precisão do que a prosa consegue (máquina de estados, reducer, schema, formato de tipo), coloque-o inline dentro da decisão relevante e anote brevemente que veio de um protótipo. Corte até as partes ricas em decisão, não uma demo funcional, só o que importa.

## Decisões de teste

Uma lista das decisões de teste tomadas. Inclua:

- Uma descrição do que faz um bom teste (testar só comportamento externo, não detalhes de implementação)
- Quais módulos serão testados
- Precedentes para os testes (ou seja, tipos parecidos de teste já existentes no código)

## Fora do escopo

Uma descrição do que está fora do escopo desta spec.

## Observações adicionais

Quaisquer observações adicionais sobre a funcionalidade.

</spec-template>
