#!/usr/bin/env bash
#
# Um wizard conduz um humano por um procedimento manual, passo a passo.
# Gerado pela skill /wizard.
#
# Tudo acima do marcador "STAGES" é a biblioteca do wizard: não edite à mão.
# Escreva as etapas, uma por passo, abaixo do marcador.

set -euo pipefail

# ──────────────────────────────────────────────────────────────────────────
# Biblioteca do wizard: UX agradável e consistente, idêntica em todo wizard.
# ──────────────────────────────────────────────────────────────────────────

if [[ -t 1 ]] && command -v tput >/dev/null 2>&1 && [[ "$(tput colors 2>/dev/null || echo 0)" -ge 8 ]]; then
  BOLD=$(tput bold); DIM=$(tput dim); RESET=$(tput sgr0)
  BLUE=$(tput setaf 4); GREEN=$(tput setaf 2); YELLOW=$(tput setaf 3)
else
  BOLD=""; DIM=""; RESET=""; BLUE=""; GREEN=""; YELLOW=""
fi

# Quem escreve o wizard define isto no topo da seção de etapas.
TOTAL_STAGES=0

_STAGE_INDEX=0
ENV_FILE="${ENV_FILE:-.env}"
WRITTEN_ENV=()    # CHAVEs gravadas no ENV_FILE nesta execução
WRITTEN_SECRET=() # NOMEs de secrets definidos nesta execução
SKIPPED=()        # o que não conseguimos fazer (ex.: gh ausente)

# _clear limpa o terminal para que só o passo atual fique na tela. Não faz nada
# quando a saída não é um terminal, para que logs redirecionados continuem legíveis.
_clear() {
  [[ -t 1 ]] || return 0
  if command -v tput >/dev/null 2>&1 && tput clear 2>/dev/null; then return 0; fi
  printf '\033[2J\033[3J\033[H'
}

# banner "Título" mostra a tela de abertura: o que este wizard faz.
banner() {
  _clear
  printf '\n%s%s  %s%s\n' "$BOLD" "$BLUE" "$1" "$RESET"
  printf '%s  %s etapas%s\n\n' "$DIM" "$TOTAL_STAGES" "$RESET"
  printf '%s  Você pilota o navegador; este wizard diz exatamente o que fazer e\n' "$DIM"
  printf '  captura os valores que você copiar de volta. Pare quando quiser com Ctrl-C e rode\n'
  printf '  de novo depois, já que ele lembra os valores já salvos.%s\n' "$RESET"
  pause "Pronto para começar?"
}

# stage "Nome" limpa a tela, depois anuncia uma etapa e mostra o progresso.
# Limpar mantém só o passo atual na tela.
stage() {
  _clear
  _STAGE_INDEX=$((_STAGE_INDEX + 1))
  printf '\n%s%s▸ Etapa %s/%s · %s%s\n' \
    "$BOLD" "$BLUE" "$_STAGE_INDEX" "$TOTAL_STAGES" "$1" "$RESET"
}

# say "..." imprime uma linha de instrução simples.
say()  { printf '  %s\n' "$1"; }
# step "..." é uma ação, com cara de item numerado, que o humano faz no navegador.
step() { printf '  %s•%s %s\n' "$BLUE" "$RESET" "$1"; }
note() { printf '  %s%s%s\n' "$DIM" "$1" "$RESET"; }
warn() { printf '  %s⚠ %s%s\n' "$YELLOW" "$1" "$RESET"; }

# open_url URL abre a URL no navegador do humano, multiplataforma, incluindo WSL.
open_url() {
  local url="$1"
  printf '  %s↗ abrindo%s %s\n' "$GREEN" "$RESET" "$url"
  { if   command -v wslview     >/dev/null 2>&1; then wslview "$url"
    elif command -v explorer.exe >/dev/null 2>&1; then explorer.exe "$url"
    elif command -v xdg-open    >/dev/null 2>&1; then xdg-open "$url"
    elif command -v open        >/dev/null 2>&1; then open "$url"
    else false; fi
  } >/dev/null 2>&1 || warn "não consegui abrir um navegador, então acesse manualmente: $url"
}

# pause "msg" espera o humano confirmar que fez a parte manual.
pause() {
  printf '  %s%s%s ' "$DIM" "${1:-Pressione Enter para continuar}" "$RESET"
  read -r _ || true
}

# confirm "pergunta" é uma barreira s/N; retorna sucesso no sim (aceita s ou y).
confirm() {
  local reply=""
  printf '  %s? %s [s/N] ' "$YELLOW" "$1"
  read -r reply || true
  [[ "$reply" =~ ^[SsYy] ]]
}

# _existing CHAVE: valor atual de CHAVE no ENV_FILE, se houver, desfazendo as aspas
# simples do write_env ou as aspas duplas de um valor dotenv comum.
_existing() {
  [[ -f "$ENV_FILE" ]] || return 1
  local line value sq="'\\''"; line=$(grep -E "^${1}=" "$ENV_FILE" | tail -n1) || return 1
  value="${line#*=}"
  if [[ "$value" == \'*\' ]]; then value="${value:1:${#value}-2}"; value="${value//"$sq"/\'}"
  elif [[ "$value" == \"*\" ]]; then
    value="${value:1:${#value}-2}"
    [[ "$value" == *[\\\$\"]* ]] && return 1   # escapes, $ ou ": não dá para decodificar com segurança; pergunte de novo
  fi
  printf '%s' "$value"
}

# ask CHAVE "Prompt" lê um valor em $CHAVE. Oferece o valor existente no .env como
# padrão ao rodar de novo (Enter o mantém). Entrada visível (não secreta), editada
# com Readline. Falha em EOF sem entrada.
ask() {
  local key="$1" prompt="$2" current input s=$'\001' e=$'\002' p rc=0
  current=$(_existing "$key" || true)
  # O Readline precisa dos códigos de cor envolvidos em \001..\002 para posicionar o cursor.
  p="  $s$BOLD$e$prompt$s$RESET$e "
  [[ -n "$current" ]] && p+="$s$DIM$e[Enter mantém o atual]$s$RESET$e "
  read -e -r -p "$p" input || rc=1
  if (( rc )) && [[ -z "$input" ]]; then return 1; fi
  [[ -z "$input" && -n "$current" ]] && input="$current"
  printf -v "$key" '%s' "$input"
}

# ask_secret CHAVE "Prompt" é como ask, mas a entrada fica oculta.
ask_secret() {
  local key="$1" prompt="$2" current input rc=0
  current=$(_existing "$key" || true)
  if [[ -n "$current" ]]; then
    printf '  %s%s%s %s[Enter mantém o atual]%s ' "$BOLD" "$prompt" "$RESET" "$DIM" "$RESET"
  else
    printf '  %s%s%s ' "$BOLD" "$prompt" "$RESET"
  fi
  read -rs input || rc=1
  printf '\n'
  if (( rc )) && [[ -z "$input" ]]; then return 1; fi
  [[ -z "$input" && -n "$current" ]] && input="$current"
  printf -v "$key" '%s' "$input"
}

# write_env CHAVE VALOR insere ou atualiza CHAVE='VALOR' no ENV_FILE (substitui
# qualquer linha existente) e define $CHAVE. Idempotente. Cria o ENV_FILE com modo
# 0600; grava através de um symlink e mantém o modo de um arquivo existente.
write_env() {
  local key="$1" value="$2" tmp sq="'\\''"
  [[ -e "$ENV_FILE" ]] || (umask 077 && : > "$ENV_FILE")
  tmp=$(mktemp)
  grep -vE "^${key}=" "$ENV_FILE" > "$tmp" || true
  printf "%s='%s'\n" "$key" "${value//\'/$sq}" >> "$tmp"
  cat "$tmp" > "$ENV_FILE"
  rm -f "$tmp"
  printf -v "$key" '%s' "$value"
  WRITTEN_ENV+=("$key")
  printf '  %s✓ gravado%s %s → %s\n' "$GREEN" "$RESET" "$key" "$ENV_FILE"
}

# set_secret NOME VALOR define um secret de repositório do GitHub Actions via gh.
# Recorre a um aviso (e o registra) se o gh não estiver disponível ou autenticado.
set_secret() {
  local name="$1" value="$2"
  if command -v gh >/dev/null 2>&1 && gh auth status >/dev/null 2>&1; then
    if printf '%s' "$value" | gh secret set "$name" >/dev/null 2>&1; then
      WRITTEN_SECRET+=("$name")
      printf '  %s✓ definido%s secret do GitHub %s\n' "$GREEN" "$RESET" "$name"
      return
    fi
  fi
  SKIPPED+=("secret do GitHub $name (defina manualmente: gh secret set $name)")
  warn "secret do GitHub $name pulado: gh não está pronto; defina depois"
}

# set_var NOME VALOR define uma variável de repositório do GitHub Actions (não secreta).
set_var() {
  local name="$1" value="$2"
  if command -v gh >/dev/null 2>&1 && gh auth status >/dev/null 2>&1; then
    if gh variable set "$name" --body "$value" >/dev/null 2>&1; then
      printf '  %s✓ definida%s variável do GitHub %s\n' "$GREEN" "$RESET" "$name"
      return
    fi
  fi
  SKIPPED+=("variável do GitHub $name")
  warn "variável do GitHub $name pulada: gh não está pronto; defina depois"
}

# finish limpa a tela e mostra um resumo final de tudo o que foi configurado.
finish() {
  _clear
  printf '\n%s%s  ✓ Configuração concluída%s\n' "$BOLD" "$GREEN" "$RESET"
  (( ${#WRITTEN_ENV[@]} ))    && note "${#WRITTEN_ENV[@]} valor(es) gravado(s) em $ENV_FILE: ${WRITTEN_ENV[*]}"
  (( ${#WRITTEN_SECRET[@]} )) && note "${#WRITTEN_SECRET[@]} secret(s) do GitHub definido(s): ${WRITTEN_SECRET[*]}"
  if (( ${#SKIPPED[@]} )); then
    printf '\n'; warn "ainda falta fazer à mão:"
    for s in "${SKIPPED[@]}"; do note "  - $s"; done
  fi
  printf '\n'
}

# ──────────────────────────────────────────────────────────────────────────
# STAGES: escreva esta seção. Um stage() por passo que o humano executa.
# Substitua o exemplo abaixo. Defina TOTAL_STAGES igual ao número de etapas escritas.
# Mantenha toda etapa dentro de run_wizard e a última linha como está: assim o bash
# lê o arquivo inteiro antes da primeira pergunta, e uma edição no meio da execução
# não consegue quebrá-lo.
# ──────────────────────────────────────────────────────────────────────────

run_wizard() {

TOTAL_STAGES=1

banner "Configuração do Stripe"

# ── Etapa de exemplo: substitua pelos seus passos reais ─────────────────────
stage "Stripe: chaves de API"
say "Vamos pegar suas chaves de teste do Stripe e guardá-las para o dev local + CI."
open_url "https://dashboard.stripe.com/test/apikeys"
step "Na página de chaves de API, copie a Publishable key (começa com pk_test_)."
ask STRIPE_PUBLISHABLE_KEY "Cole a publishable key:"
step "Clique em 'Reveal test key' na linha da Secret key e copie-a."
ask_secret STRIPE_SECRET_KEY "Cole a secret key:"
write_env STRIPE_PUBLISHABLE_KEY "$STRIPE_PUBLISHABLE_KEY"
write_env STRIPE_SECRET_KEY "$STRIPE_SECRET_KEY"
set_secret STRIPE_SECRET_KEY "$STRIPE_SECRET_KEY"   # o CI precisa desta
# ──────────────────────────────────────────────────────────────────────────

finish
}

run_wizard "$@"; exit
