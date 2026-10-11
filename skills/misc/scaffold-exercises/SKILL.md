---
name: scaffold-exercises
description: Cria estruturas de diretório de exercícios com seções, problems, solutions e explainers que passam no lint. Use quando o usuário quiser fazer o scaffold de exercícios, criar stubs de exercícios ou montar uma nova seção de curso.
---

# Scaffold de exercícios

Crie estruturas de diretório de exercícios que passem no `pnpm ai-hero-cli internal lint` e depois faça commit com `git commit`.

## Nomes de diretório

- **Seções**: `XX-nome-da-secao/` dentro de `exercises/` (ex.: `01-retrieval-skill-building`)
- **Exercícios**: `XX.YY-nome-do-exercicio/` dentro de uma seção (ex.: `01.03-retrieval-with-bm25`)
- Número da seção = `XX`, número do exercício = `XX.YY`
- Os nomes ficam em kebab-case (minúsculas, hífens)

## Variantes de exercício

Cada exercício precisa de pelo menos uma destas subpastas:

- `problem/`: workspace do aluno, com TODOs
- `solution/`: implementação de referência
- `explainer/`: material conceitual, sem TODOs

Ao criar stubs, use `explainer/` por padrão, a menos que o plano diga outra coisa.

## Arquivos obrigatórios

Cada subpasta (`problem/`, `solution/`, `explainer/`) precisa de um `readme.md` que:

- **Não esteja vazio** (precisa ter conteúdo de verdade; uma única linha de título já serve)
- Não tenha links quebrados

Ao criar stubs, crie um readme mínimo com um título e uma descrição:

```md
# Título do exercício

Descrição aqui
```

Se a subpasta tiver código, ela também precisa de um `main.ts` (com mais de 1 linha). Mas, para stubs, um exercício só com readme serve.

## Fluxo de trabalho

1. **Interprete o plano**: extraia os nomes das seções, dos exercícios e os tipos de variante
2. **Crie os diretórios**: `mkdir -p` para cada caminho
3. **Crie os readmes stub**: um `readme.md` por pasta de variante, com um título
4. **Rode o lint**: `pnpm ai-hero-cli internal lint` para validar
5. **Corrija os erros**: itere até o lint passar

## Resumo das regras de lint

O linter (`pnpm ai-hero-cli internal lint`) verifica:

- Cada exercício tem subpastas (`problem/`, `solution/`, `explainer/`)
- Existe pelo menos um entre `problem/`, `explainer/` ou `explainer.1/`
- O `readme.md` existe e não está vazio na subpasta principal
- Nenhum arquivo `.gitkeep`
- Nenhum arquivo `speaker-notes.md`
- Nenhum link quebrado nos readmes
- Nenhum comando `pnpm run exercise` nos readmes
- `main.ts` obrigatório por subpasta, a menos que seja só readme

## Movendo/renomeando exercícios

Ao renumerar ou mover exercícios:

1. Use `git mv` (não `mv`) para renomear diretórios; isso preserva o histórico do git
2. Atualize o prefixo numérico para manter a ordem
3. Rode o lint de novo depois de mover

Exemplo:

```bash
git mv exercises/01-retrieval/01.03-embeddings exercises/01-retrieval/01.04-embeddings
```

## Exemplo: criando stubs a partir de um plano

Dado um plano como:

```
Seção 05: Construindo memória
- 05.01 Introdução à memória
- 05.02 Memória de curto prazo (explainer + problem + solution)
- 05.03 Memória de longo prazo
```

Crie:

```bash
mkdir -p exercises/05-construindo-memoria/05.01-introducao-a-memoria/explainer
mkdir -p exercises/05-construindo-memoria/05.02-memoria-de-curto-prazo/{explainer,problem,solution}
mkdir -p exercises/05-construindo-memoria/05.03-memoria-de-longo-prazo/explainer
```

Depois crie os readmes stub:

```
exercises/05-construindo-memoria/05.01-introducao-a-memoria/explainer/readme.md -> "# Introdução à memória"
exercises/05-construindo-memoria/05.02-memoria-de-curto-prazo/explainer/readme.md -> "# Memória de curto prazo"
exercises/05-construindo-memoria/05.02-memoria-de-curto-prazo/problem/readme.md -> "# Memória de curto prazo"
exercises/05-construindo-memoria/05.02-memoria-de-curto-prazo/solution/readme.md -> "# Memória de curto prazo"
exercises/05-construindo-memoria/05.03-memoria-de-longo-prazo/explainer/readme.md -> "# Memória de longo prazo"
```
