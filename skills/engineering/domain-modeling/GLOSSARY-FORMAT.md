# Formato do GLOSSARY.md

## Estrutura

```md
# {Nome do contexto}

{Uma ou duas frases descrevendo o que é este contexto e por que ele existe.}

## Linguagem

**Pedido**:
{Uma ou duas frases descrevendo o termo}
_Evitar_: Compra, transação

**Fatura**:
Uma cobrança enviada a um cliente após a entrega.
_Evitar_: Conta, boleto

**Cliente**:
Uma pessoa ou organização que faz pedidos.
_Evitar_: Freguês, comprador, conta
```

## Regras

- **Tenha opinião.** Quando existem várias palavras para o mesmo conceito, escolha a melhor e liste as outras em `_Evitar_`.
- **Mantenha as definições enxutas.** No máximo uma ou duas frases. Defina o que ele É, não o que ele faz.
- **Inclua só termos específicos do contexto deste projeto.** Conceitos gerais de programação (timeouts, tipos de erro, padrões utilitários) não entram, mesmo que o projeto os use muito. Antes de adicionar um termo, pergunte: este é um conceito exclusivo deste contexto ou um conceito geral de programação? Só o primeiro entra.
- **Agrupe os termos sob subtítulos** quando surgirem grupos naturais. Se todos os termos pertencem a uma única área coesa, uma lista plana serve.

## Repositórios de contexto único vs. múltiplos contextos

**Contexto único (a maioria dos repositórios):** Um `GLOSSARY.md` na raiz do repositório.

**Múltiplos contextos:** Um `GLOSSARY-MAP.md` na raiz do repositório lista os contextos, onde eles vivem e como se relacionam:

```md
# Mapa de glossários

## Contextos

- [Pedidos](./src/pedidos/GLOSSARY.md): recebe e acompanha os pedidos dos clientes
- [Faturamento](./src/faturamento/GLOSSARY.md): gera faturas e processa pagamentos
- [Expedição](./src/expedicao/GLOSSARY.md): gerencia a separação no estoque e o envio

## Relações

- **Pedidos → Expedição**: Pedidos emite eventos `PedidoRealizado`; Expedição os consome para iniciar a separação
- **Expedição → Faturamento**: Expedição emite eventos `RemessaDespachada`; Faturamento os consome para gerar faturas
- **Pedidos ↔ Faturamento**: Tipos compartilhados para `ClienteId` e `Dinheiro`
```

A skill deduz qual estrutura se aplica:

- Se existir `GLOSSARY-MAP.md`, leia-o para encontrar os contextos
- Se existir só um `GLOSSARY.md` na raiz, é contexto único
- Se nenhum dos dois existir, crie um `GLOSSARY.md` na raiz sob demanda quando o primeiro termo for resolvido

Quando houver vários contextos, deduza a qual deles o assunto atual se refere. Se não estiver claro, pergunte.
