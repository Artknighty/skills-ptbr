#!/usr/bin/env bash
# Loop de reprodução com human in the loop (HITL).
# Copie este arquivo, edite os passos abaixo e execute.
# O agente executa o script; o usuário segue as instruções no terminal dele.
#
# Uso:
#   bash hitl-loop.template.sh
#
# Duas funções auxiliares:
#   step "<instrução>"            → mostra a instrução e espera Enter
#   capture VAR "<pergunta>"      → mostra a pergunta e lê a resposta em VAR
#
# No final, os valores capturados são impressos como CHAVE=VALOR para o agente interpretar.
#
# `capture` imprime o valor de volta no terminal, onde o agente o lê,
# então capture observações, e deixe o login com o usuário como um `step`.

set -euo pipefail

step() {
  printf '\n>>> %s\n' "$1"
  read -r -p "    [Enter quando terminar] " _
}

capture() {
  local var="$1" question="$2" answer
  printf '\n>>> %s\n' "$question"
  read -r -p "    > " answer
  printf -v "$var" '%s' "$answer"
}

# --- edite abaixo -------------------------------------------------------

step "Abra o app em http://localhost:3000 e faça login."

capture ERRORED "Clique no botão 'Exportar'. Deu erro? (s/n)"

capture ERROR_MSG "Cole a mensagem de erro (ou 'nenhuma'):"

# --- edite acima --------------------------------------------------------

printf '\n--- Capturado ---\n'
printf 'ERRORED=%s\n' "$ERRORED"
printf 'ERROR_MSG=%s\n' "$ERROR_MSG"
