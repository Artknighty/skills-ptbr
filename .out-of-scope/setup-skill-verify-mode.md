# Modo de verificação para a `setup-matt-pocock-skills`

Este projeto não vai adicionar um modo dedicado de verificação (nem uma skill separada de verificação) para a `setup-matt-pocock-skills`.

## Por que isto está fora do escopo

Uma segunda skill (ou uma flag `--verify`) para checar se os artefatos `docs/agents/*.md` ainda correspondem ao schema dos modelos iniciais duplicaria um trabalho que a skill de setup existente já faz na conversa.

O fluxo pretendido é: **rode `/setup-matt-pocock-skills` e peça para ela verificar a sua configuração atual.** A skill é guiada por prompt, então o mantenedor pode limitá-la a uma passada de verificação ("não reescreva nada, só compare os meus arquivos existentes com os modelos iniciais atuais e reporte as diferenças") sem precisar de um caminho de código separado. Adicionar uma flag ou uma skill irmã dividiria a superfície de uma funcionalidade que já dá para expressar pela entrada em linguagem natural.

Manter o gerenciamento de configuração numa skill só também evita o custo de manutenção de duas skills se distanciando uma da outra quando os modelos iniciais evoluem.

## Pedidos anteriores

- #106: Feature request: verify/check mode for setup-matt-pocock-skills
