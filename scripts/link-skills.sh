#!/usr/bin/env bash
set -euo pipefail

# NOTA: Script só para desenvolvimento, feito para quem mantém este repositório.
# Não é um instalador oficial.
#
# Linka todas as skills do repositório nos diretórios locais de skills usados
# por cada harness de agente:
#   - ~/.claude/skills: Claude Code
#   - ~/.agents/skills: Codex e outros harnesses compatíveis com Agent Skills
# Cada entrada é um symlink para este repositório, então um `git pull` basta
# para manter as skills instaladas atualizadas.

REPO="$(cd "$(dirname "$0")/.." && pwd)"
DESTS=("$HOME/.claude/skills" "$HOME/.agents/skills")

# Coleta as skills do repositório uma vez e linka em cada destino. `deprecated/`
# está aposentado, e `misc/` é mantido mas raramente usado e não promovido (veja
# o README de cada bucket): nenhum dos dois pertence a um diretório de skills de
# uso diário, então ambos são pulados aqui, como em todo lugar em que skills não
# promovidas ficam de fora. `in-progress/` CONTINUA sendo linkado: é público de
# propósito, e esta instalação local é exatamente onde o feedback loop roda.
names=()
srcs=()
while IFS= read -r -d '' skill_md; do
  src="$(dirname "$skill_md")"
  names+=("$(basename "$src")")
  srcs+=("$src")
done < <(find "$REPO/skills" -name SKILL.md -not -path '*/node_modules/*' -not -path '*/deprecated/*' -not -path '*/misc/*' -print0)

for DEST in "${DESTS[@]}"; do
  # Se $DEST for um symlink que aponta para dentro deste repositório, acabaríamos
  # gravando os symlinks de cada skill de volta na própria árvore skills/ do
  # repositório. Detecta e aborta em vez de poluir a cópia de trabalho.
  if [ -L "$DEST" ]; then
    resolved="$(readlink -f "$DEST")"
    case "$resolved" in
      "$REPO"|"$REPO"/*)
        echo "erro: $DEST é um symlink para dentro deste repositório ($resolved)." >&2
        echo "Remova-o (rm \"$DEST\") e rode de novo; o script vai recriá-lo como um diretório de verdade." >&2
        exit 1
        ;;
    esac
  fi

  mkdir -p "$DEST"

  for i in "${!names[@]}"; do
    name="${names[$i]}"
    src="${srcs[$i]}"
    target="$DEST/$name"

    if [ -e "$target" ] && [ ! -L "$target" ]; then
      rm -rf "$target"
    fi

    ln -sfn "$src" "$target"
    echo "linkado $name -> $src ($DEST)"
  done
done
