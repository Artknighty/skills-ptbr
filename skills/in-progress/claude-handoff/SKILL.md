---
name: claude-handoff
description: Passa a conversa atual para um agente novo em segundo plano, que começa o trabalho na hora.
argument-hint: "Para que a próxima sessão vai ser usada?"
disable-model-invocation: true
---

Escreva um resumo de handoff da conversa atual para que um agente novo possa continuar o trabalho. Salve-o no diretório temporário do sistema operacional do usuário e depois dispare um agente em segundo plano usando esse resumo como prompt: `claude --bg --name "<nome descritivo>" -- "$(cat <arquivo do resumo>)"`. Passar o arquivo impede o shell de executar crases ou expandir `$` no resumo. Ele começa no diretório de trabalho atual e retorna imediatamente; o usuário o gerencia com `claude agents`.

Sempre passe `-n`/`--name` com um nome descritivo (ex.: `--name "Corrigir bug de login"`); ele define o nome exibido na lista de jobs, no seletor de sessões e no título do terminal.

Inclua no resumo uma seção "skills sugeridas", nomeando para quais skills o próximo agente deve chamar a ferramenta Skill.

Não duplique conteúdo já registrado em outros artefatos (specs, planos, ADRs, issues, commits, diffs). Referencie-os por caminho ou URL.

Remova qualquer informação sensível, como chaves de API, senhas ou dados pessoais identificáveis, já que o resumo vira o prompt do agente.

Se o usuário passou argumentos, trate-os como uma descrição do foco da próxima sessão e adapte o resumo a isso.
