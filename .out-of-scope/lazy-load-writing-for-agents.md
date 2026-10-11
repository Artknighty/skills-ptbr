# Carregar `writing-for-agents` sob demanda nas skills que julgam textos para agentes

A `retro` carrega a `writing-for-agents` em toda execução, não só antes de escrever. Pedidos para adiar esse carregamento até a skill editar uma skill, um `AGENTS.md`/`CLAUDE.md` ou um documento estão fora do escopo.

## Por que isto está fora do escopo

A `writing-for-agents` é mais do que um guia de estilo. Ela define o que é uma instrução no-op e o que faz uma boa skill, e a `retro` usa essas definições para julgar os arquivos de orientação que lê, antes de escrever qualquer coisa. Uma retro que só lê e reporta ainda precisa dela. Carregue-a sob demanda e os candidatos de No-ops e de Skills passam a ser julgados sem régua nenhuma.

## Pedidos anteriores

- #1238: "retro: load writing-for-agents only before writing" (fechado)
