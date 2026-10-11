---
name: triage
description: "Move issues e PRs externos por uma máquina de estados de papéis de triagem: categoriza, verifica, sabatina se necessário e escreve briefings prontos para agentes."
disable-model-invocation: true
---

# Triagem

Mova as issues do issue tracker do projeto por uma pequena máquina de estados de papéis de triagem.

Se este repositório trata pull requests externos como canal de pedidos (veja a configuração do issue tracker), a triagem também os cobre: **um PR é uma issue com código anexado**, com os mesmos papéis, os mesmos estados e a mesma máquina, e algumas diferenças marcadas com "para um PR" abaixo. Resolva um `#42` solto como issue ou PR conforme a configuração do tracker.

Todo comentário ou issue publicado no issue tracker durante a triagem **precisa** começar com este aviso:

```
> *Isto foi gerado por IA durante a triagem.*
```

## Documentos de referência

- [AGENT-BRIEF.md](AGENT-BRIEF.md): como escrever briefings de agente duráveis
- [OUT-OF-SCOPE.md](OUT-OF-SCOPE.md): como funciona a base de conhecimento `.out-of-scope/`

## Papéis

Dois papéis de **categoria**:

- `bug`: algo está quebrado
- `enhancement`: funcionalidade nova ou melhoria

Cinco papéis de **estado**:

- `needs-triage`: o mantenedor precisa avaliar
- `needs-info`: aguardando mais informações de quem relatou
- `ready-for-agent`: totalmente especificada, pronta para um agente AFK
- `ready-for-human`: precisa de implementação humana
- `wontfix`: não será feita

Para um PR, os mesmos estados se leem em relação ao código anexado: `ready-for-agent` significa que há um briefing anexado e que um agente deve dar o próximo passo sobre o diff; `ready-for-human` significa que está pronto para um humano fazer o merge.

Toda issue triada deve ter exatamente um papel de categoria e um papel de estado. Se houver papéis de estado em conflito, sinalize e pergunte ao mantenedor antes de fazer qualquer outra coisa.

Estes são nomes canônicos de papéis. As strings de label realmente usadas no issue tracker podem ser diferentes. O mapeamento já deve ter sido fornecido a você. Se não, diga ao usuário para rodar `/setup-matt-pocock-skills`.

Transições de estado: uma issue sem label normalmente vai primeiro para `needs-triage`; de lá, vai para `needs-info`, `ready-for-agent`, `ready-for-human` ou `wontfix`. `needs-info` volta para `needs-triage` quando quem relatou responde. O mantenedor pode passar por cima disso a qualquer momento; sinalize transições que pareçam incomuns e pergunte antes de seguir.

## Invocação

O mantenedor invoca `/triage` e descreve o que quer em linguagem natural. Interprete o pedido e aja. Exemplos:

- "Me mostre o que precisa da minha atenção"
- "Vamos olhar o #42" (issue ou PR)
- "Mova o #42 para ready-for-agent"
- "O que está pronto para os agentes pegarem?"

## Mostre o que precisa de atenção

Consulte o issue tracker e apresente três grupos, dos mais antigos para os mais novos:

1. **Sem label**: nunca triadas.
2. **`needs-triage`**: avaliação em andamento.
3. **`needs-info` com atividade de quem relatou desde as últimas notas de triagem**: precisam ser reavaliadas.

Quando PRs estiverem no escopo, inclua os PRs externos nesses grupos e marque cada linha com `[PR]` ou `[issue]`. A descoberta só traz PRs *externos* (a configuração do tracker define quem conta como externo), então o PR em andamento de um colaborador não é trabalho de triagem. Esse filtro vale só para a descoberta; um PR citado explicitamente é sempre triado, seja quem for o autor.

Mostre as contagens e um resumo de uma linha por item. Deixe o mantenedor escolher.

## Fazer a triagem de uma issue ou PR específico

1. **Reúna o contexto.** Leia a issue ou o PR inteiro (corpo, comentários, labels, autor, datas; para um PR, o diff também). Interprete quaisquer notas de triagem anteriores para não perguntar de novo o que já foi resolvido. Explore o código usando o glossário de domínio do projeto, respeitando os ADRs da área. Faça duas verificações no código: (a) **redundância**: procure uma implementação existente do comportamento pedido pelo conceito de domínio (não só pelas palavras do pedido) e informe onde procurou. Se encontrar, é um `wontfix` de já implementado (passo 5). (b) **rejeição anterior**: leia `.out-of-scope/*.md` e aponte qualquer arquivo que se pareça com este pedido.

2. **Recomende.** Diga ao mantenedor a sua recomendação de categoria e estado com o raciocínio, mais um breve resumo do código relevante para o pedido (incluindo se já está implementado). Espere orientação.

3. **Verifique a alegação.** Antes de qualquer sabatina, confira se a alegação se sustenta. Para um bug, reproduza-o a partir dos passos de quem relatou. Para um PR, confirme que o diff faz o que diz: faça checkout dele, rode os testes ou comandos relevantes. Informe o que aconteceu: confirmado (com o caminho de código), falhou, ou detalhe insuficiente (um sinal forte de `needs-info`). Uma verificação confirmada gera um briefing de agente muito mais forte.

4. **Sabatine (se necessário).** Se o pedido precisar ser detalhado, chame a ferramenta Skill duas vezes, uma para "grilling" e outra para "domain-modeling", e sabatine até dar forma a ele, uma rodada de perguntas por vez, afiando termos de domínio e atualizando `GLOSSARY.md`/ADRs no caminho conforme as decisões se firmam.

5. **Aplique o resultado:**
   - `ready-for-agent`: publique um comentário com o briefing de agente ([AGENT-BRIEF.md](AGENT-BRIEF.md)).
   - `ready-for-human`: mesma estrutura de um briefing de agente, mas registre por que não dá para delegar (decisões de julgamento, acesso externo, decisões de design, teste manual).
   - `needs-info`: publique notas de triagem (modelo abaixo).
   - Para `wontfix`, feche a issue, com o comentário dependendo do *motivo*:
     - **Já implementado**: a mudança já existe no código. Aponte onde ela está; **não** escreva em `.out-of-scope/` (essa base é para pedidos *rejeitados*, não para os já construídos).
     - **Rejeitado (bug)**: dê uma explicação educada e feche.
     - **Rejeitado (enhancement)**: escreva em `.out-of-scope/`, faça o link num comentário e feche ([OUT-OF-SCOPE.md](OUT-OF-SCOPE.md)).
   - `needs-triage`: aplique o papel. Comentário opcional se houver progresso parcial.

## Mudança rápida de estado

Se o mantenedor disser "mova o #42 para ready-for-agent", confie nele e aplique o papel diretamente. Confirme o que você vai fazer (mudanças de papel, comentário, fechamento) e aja. Pule a sabatina. Se for mover para `ready-for-agent` sem uma sessão de sabatina, pergunte se ele quer escrever um briefing de agente.

## Modelo de needs-info

```markdown
## Notas de triagem

**O que já estabelecemos:**

- ponto 1
- ponto 2

**O que ainda precisamos de você (@quem-relatou):**

- pergunta 1
- pergunta 2
```

Registre tudo o que foi resolvido durante a sabatina em "já estabelecemos", para que o trabalho não se perca. As perguntas precisam ser específicas e acionáveis, não "por favor, forneça mais informações".

## Retomando uma sessão anterior

Se já existirem notas de triagem na issue ou no PR, leia-as, verifique se quem relatou respondeu alguma pergunta pendente e apresente um quadro atualizado antes de continuar. Não pergunte de novo o que já foi resolvido.
