---
name: git-guardrails-claude-code
description: "Configura hooks do Claude Code para bloquear comandos git perigosos (push, reset --hard, clean, branch -D etc.) antes que sejam executados. Use quando o usuário quiser impedir operações git destrutivas, adicionar hooks de segurança para git ou bloquear git push/reset no Claude Code."
---

# Configurar guardrails de git

Configura um hook `PreToolUse` que intercepta e bloqueia comandos git perigosos antes que o Claude os execute.

## O que é bloqueado

- `git push` (todas as variantes, incluindo `--force`)
- `git reset --hard`
- `git clean -f` / `git clean -fd`
- `git branch -D`
- `git checkout .` / `git restore .`

Quando um comando é bloqueado, o Claude recebe uma mensagem dizendo que não tem autorização para executar esses comandos.

## Passos

### 1. Pergunte o escopo

Pergunte ao usuário: instalar **só para este projeto** (`.claude/settings.json`) ou **para todos os projetos** (`~/.claude/settings.json`)?

### 2. Copie o script do hook

O script incluído está em: [scripts/block-dangerous-git.sh](scripts/block-dangerous-git.sh)

Copie-o para o destino conforme o escopo:

- **Projeto**: `.claude/hooks/block-dangerous-git.sh`
- **Global**: `~/.claude/hooks/block-dangerous-git.sh`

Torne-o executável com `chmod +x`.

### 3. Adicione o hook às configurações

Adicione ao arquivo de configurações adequado:

**Projeto** (`.claude/settings.json`):

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/block-dangerous-git.sh"
          }
        ]
      }
    ]
  }
}
```

**Global** (`~/.claude/settings.json`):

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "~/.claude/hooks/block-dangerous-git.sh"
          }
        ]
      }
    ]
  }
}
```

Se o arquivo de configurações já existir, faça o merge do hook no array `hooks.PreToolUse` existente. Não sobrescreva as outras configurações.

### 4. Pergunte sobre personalização

Pergunte se o usuário quer adicionar ou remover algum padrão da lista de bloqueio. Edite o script copiado de acordo.

### 5. Verifique

Rode um teste rápido:

```bash
echo '{"tool_input":{"command":"git push origin main"}}' | <caminho-do-script>
```

Deve sair com código 2 e imprimir uma mensagem `BLOQUEADO` no stderr.
