# Documentos de domínio

Como as skills de engenharia devem consumir a documentação de domínio deste repositório ao explorar o código.

## Antes de explorar, leia estes

- **`GLOSSARY.md`** na raiz do repositório, ou
- **`GLOSSARY-MAP.md`** na raiz do repositório, se existir: ele aponta para um `GLOSSARY.md` por contexto. Leia cada um que for relevante para o assunto.
- **`docs/adr/`**: leia os ADRs que tocam a área em que você vai trabalhar. Em repositórios com múltiplos contextos, verifique também `src/<contexto>/docs/adr/` para decisões do escopo do contexto.

Se algum desses arquivos não existir, **siga em silêncio**. Não sinalize a ausência deles; não sugira criá-los de antemão. A skill `/domain-modeling` (alcançada via `/grill-with-docs` e `/improve-codebase-architecture`) os cria sob demanda quando termos ou decisões forem de fato resolvidos.

## Estrutura de arquivos

Repositório de contexto único (a maioria):

```
/
├── GLOSSARY.md
├── docs/adr/
│   ├── 0001-pedidos-com-event-sourcing.md
│   └── 0002-postgres-para-o-modelo-de-escrita.md
└── src/
```

Repositório com múltiplos contextos (presença de `GLOSSARY-MAP.md` na raiz):

```
/
├── GLOSSARY-MAP.md
├── docs/adr/                          ← decisões do sistema todo
└── src/
    ├── pedidos/
    │   ├── GLOSSARY.md
    │   └── docs/adr/                  ← decisões específicas do contexto
    └── faturamento/
        ├── GLOSSARY.md
        └── docs/adr/
```

## Use o vocabulário do glossário

Quando a sua saída nomear um conceito de domínio (no título de uma issue, numa proposta de refatoração, numa hipótese, no nome de um teste), use o termo como definido no `GLOSSARY.md`. Não escorregue para sinônimos que o glossário explicitamente manda evitar.

Se o conceito de que você precisa ainda não está no glossário, isso é um sinal: ou você está inventando uma linguagem que o projeto não usa (reconsidere), ou há uma lacuna real (anote-a para a `/domain-modeling`).

## Sinalize conflitos com ADRs

Se a sua saída contradiz um ADR existente, exponha isso explicitamente em vez de passar por cima em silêncio:

> _Contradiz o ADR-0007 (pedidos com event sourcing), mas vale reabrir porque…_
