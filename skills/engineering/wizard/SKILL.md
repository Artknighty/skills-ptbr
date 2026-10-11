---
name: wizard
description: Gera um assistente (wizard) interativo em bash que conduz um humano por passos que só ele pode executar. Use ao provisionar infraestrutura, configurar credenciais ou secrets de CI, navegar por um painel de terceiros desconhecido, ou rodar uma migração ou virada pontual. Não invoque para passos que o próprio agente consegue executar.
---

# Wizard

Um **wizard** é um script bash que conduz um humano, passo a passo, por um procedimento manual que é chato de fazer à mão e chato de reexplicar a uma IA toda vez. Ele abre cada URL, diz exatamente o que clicar e copiar, captura os valores, grava-os onde devem ficar (`.env`, secrets do GitHub), confirma em cada etapa e mostra quantas etapas faltam. Ele pode configurar serviços de terceiros, rodar uma migração pontual ou levar o projeto de um estado a outro.

A UX agradável já está resolvida pelo [template.sh](template.sh): progresso etapa por etapa, barreiras de confirmação, abertura de URL multiplataforma (incluindo WSL), entrada oculta de segredos, gravação idempotente no `.env`, escrita via `gh secret`/`gh variable` e um resumo final. **O seu trabalho é só delimitar o procedimento e escrever as etapas dele.** A biblioteca acima do marcador `STAGES` é idêntica em todo wizard; essa consistência é a questão: nunca a edite à mão.

Um wizard é efêmero por padrão: feito para uma execução, salvo num caminho de rascunho ou em `scripts/`, apagado quando o trabalho termina. Faça commit dele só quando o usuário quiser um caminho de configuração repetível que deva viver no repositório.

## Processo

### 1. Delimite o procedimento

Levante todo passo manual que o humano precisa dar e todo valor capturado no caminho. Leia o repositório primeiro, não pergunte do nada:

- Para configuração: `.env`, `.env.example`, `.env.*`, `README`, `docker-compose*`, configuração do framework e `.github/workflows/*` (toda referência `secrets.*` / `vars.*` é um valor que o wizard precisa produzir).
- Para uma migração ou transição: o estado atual, o estado-alvo e as ações irreversíveis entre eles.

Depois mostre ao usuário a lista ordenada de etapas e os valores que cada uma produz, e confirme: ele pode acrescentar, tirar ou reordenar.

**Pronto quando:** toda etapa tiver nome e ordem e, para cada valor capturado, você souber (a) onde o humano o obtém, (b) onde ele é gravado (`.env`, um secret do GitHub, os dois, ou lugar nenhum; algumas etapas são só ações) e (c) se ele é secreto (entrada oculta) ou público.

### 2. Mapeie o percurso de cada etapa

Para cada etapa, escreva o caminho exato que um humano segue: qual URL abrir, o que fazer lá, onde um valor aparece, qual variável ele preenche: ex.: "Dashboard → Developers → API keys → Reveal test key → copiar". Onde você não souber de verdade a interface atual ou o comando exato, diga isso e pergunte ao usuário ou consulte a documentação: nunca invente passos que talvez não existam.

**Pronto quando:** toda etapa levar a instruções concretas que um desconhecido conseguiria seguir.

### 3. Escreva o wizard

Copie o `template.sh` para o caminho de destino. Substitua a etapa de exemplo por um `stage` por passo, em ordem de dependência. Use as funções da biblioteca: `stage`, `say`/`step`, `open_url`, `ask`/`ask_secret`, `write_env`, `set_secret`/`set_var`, `pause`/`confirm`. Defina `TOTAL_STAGES` com o número de etapas que você escreveu. Escreva os textos exibidos ao humano (os argumentos de `banner`, `stage`, `say`, `step`, `ask` etc.) em português do Brasil.

Mantenha o nível que o modelo estabelece: abra a URL antes de pedir o valor dela, use `ask_secret` para qualquer coisa secreta, `write_env` em todo valor persistido, `set_secret` só nos valores de que o CI realmente precisa e `confirm` antes de qualquer ação irreversível. Cada `stage` limpa a tela para que só o passo atual fique visível: mantenha cada etapa com uma única tarefa focada, para que nada de que o humano precise role para fora da tela. Não mexa na biblioteca acima do marcador.

### 4. Verifique e entregue

- `bash -n <script>`; rode `shellcheck` se estiver disponível.
- `chmod +x <script>`.
- Não rode de ponta a ponta você mesmo: ele abre navegadores e trava esperando entrada humana. Em vez disso, rastreie-o estaticamente: todo valor do passo 1 é capturado e vai parar onde o passo 1 disse, e todo nome de `set_secret` bate exatamente com uma referência `secrets.*` no CI.
- Diga ao usuário como rodá-lo. Se for um caminho de configuração repetível, faça commit e coloque um link no README, para que a próxima pessoa rode o script em vez de perguntar a uma IA.
