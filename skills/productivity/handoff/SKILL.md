---
name: handoff
description: Compacta a conversa atual em um documento de handoff para outro agente dar continuidade.
argument-hint: "Para que a próxima sessão vai ser usada?"
disable-model-invocation: true
---

Escreva um documento de handoff resumindo a conversa atual para que um agente novo possa continuar o trabalho. Salve no diretório temporário do sistema operacional do usuário (`$TMPDIR`, senão `/tmp`; `%TEMP%` no Windows), não no workspace atual.

Inclua no documento uma seção "skills sugeridas", nomeando para quais skills o próximo agente deve chamar a ferramenta Skill.

Não duplique conteúdo já registrado em outros artefatos (specs, planos, ADRs, issues, commits, diffs). Referencie-os por caminho ou URL.

Remova qualquer informação sensível, como chaves de API, senhas ou dados pessoais identificáveis.

Se o usuário passou argumentos, trate-os como uma descrição do foco da próxima sessão e adapte o documento a isso.
