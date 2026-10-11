---
name: setup-pre-commit
description: Configura hooks de pre-commit com Husky, lint-staged (Prettier), typecheck e testes no repositório atual. Use quando o usuário quiser adicionar hooks de pre-commit, configurar o Husky, configurar o lint-staged ou adicionar formatação/typecheck/testes no momento do commit.
---

# Configurar hooks de pre-commit

## O que isto configura

- Hook de pre-commit do **Husky**
- **lint-staged** rodando o Prettier em todos os arquivos em stage
- Configuração do **Prettier** (se não existir)
- Scripts de **typecheck** e **test** no hook de pre-commit

## Passos

### 1. Detecte o gerenciador de pacotes

Procure `package-lock.json` (npm), `pnpm-lock.yaml` (pnpm), `yarn.lock` (yarn), `bun.lockb` (bun). Use o que estiver presente. Use npm por padrão se não estiver claro.

### 2. Instale as dependências

Instale como devDependencies:

```
husky lint-staged prettier
```

### 3. Inicialize o Husky

```bash
npx husky init
```

Isso cria o diretório `.husky/` e adiciona `prepare: "husky"` ao package.json.

### 4. Crie o `.husky/pre-commit`

Escreva este arquivo (não precisa de shebang no Husky v9+):

```
npx lint-staged
npm run typecheck
npm run test
```

**Adapte**: troque `npm` pelo gerenciador de pacotes detectado. Se o repositório não tiver script `typecheck` ou `test` no package.json, omita essas linhas e avise o usuário.

### 5. Crie o `.lintstagedrc`

```json
{
  "*": "prettier --ignore-unknown --write"
}
```

### 6. Crie o `.prettierrc` (se não existir)

Só crie se não existir nenhuma configuração do Prettier. Use estes padrões:

```json
{
  "useTabs": false,
  "tabWidth": 2,
  "printWidth": 80,
  "singleQuote": false,
  "trailingComma": "es5",
  "semi": true,
  "arrowParens": "always"
}
```

### 7. Verifique

- [ ] `.husky/pre-commit` existe e é executável
- [ ] `.lintstagedrc` existe
- [ ] o script `prepare` no package.json é `"husky"`
- [ ] a configuração do `prettier` existe
- [ ] Rode `npx lint-staged` para verificar se funciona

### 8. Faça o commit

Coloque em stage todos os arquivos alterados/criados e faça commit com a mensagem: `Add pre-commit hooks (husky + lint-staged + prettier)`

Isso vai passar pelos novos hooks de pre-commit: um bom smoke test de que tudo funciona.

## Observações

- O Husky v9+ não precisa de shebang nos arquivos de hook
- `prettier --ignore-unknown` pula arquivos que o Prettier não consegue interpretar (imagens etc.)
- O pre-commit roda primeiro o lint-staged (rápido, só os arquivos em stage) e depois o typecheck e os testes completos
