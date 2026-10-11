---
name: setup-ts-deep-modules
description: Configura o dependency-cruiser num repositório TypeScript para que cada pacote seja um módulo profundo (deep module), com a implementação escondida em subpastas e acessível só pelos arquivos de entry point. Invocada pelo usuário.
disable-model-invocation: true
---

# Configurar módulos profundos em TS

Faça de cada pacote deste repositório um **módulo profundo** (deep module): muito comportamento atrás de uma interface pequena. A superfície pública de um pacote são os **entry points** dele (os arquivos na raiz do pacote), e tudo nas subpastas fica escondido. Esta skill instala o [dependency-cruiser](https://github.com/sverweij/dependency-cruiser) e as regras que fazem dos entry points a única porta de entrada, e depois prova que as regras funcionam.

Para o vocabulário (módulo profundo, interface, seam, profundidade), chame a ferramenta Skill com "codebase-design" e use a linguagem dela do começo ao fim.

## O formato que isto impõe

```
src/packages/
  <nome>/
    index.ts        ← um entry point (público). Importe este de fora.
    client.ts       ← outro entry point. Os pacotes podem expor VÁRIOS.
    lib/            ← implementação: escondida de fora, livre para se importar internamente.
    tests/          ← testes co-localizados + fixtures (uma subpasta, portanto privada).
```

A superfície pública são os **arquivos da raiz** do pacote, não um único `index.ts` designado. Por convenção, a implementação fica em `lib/` e os testes em `tests/`, o que dá a todo pacote o mesmo formato de duas pastas. Mas a regra em si é geral: *qualquer coisa* em *qualquer* subpasta é privada, então você nunca estende a configuração para adicionar uma pasta.

Quatro regras, todas com severidade `error`:

1. **Fronteira dos entry points**: código de fora de um pacote (código da aplicação ou de outro pacote) só pode importar os entry points dele (os arquivos da raiz), nunca nada nas subpastas.
2. **Liberdade dentro do pacote**: os arquivos de um pacote se importam livremente entre si.
3. **Testes pelos entry points**: arquivos em `<pacote>/tests/` podem importar os entry points de qualquer pacote e as próprias fixtures de `tests/`, mas nunca os detalhes internos das subpastas de nenhum pacote (nem do próprio). Testes de integração entre pacotes tudo bem; imports profundos, não.
4. **Sem ciclos**: nenhum ciclo de dependência.

**Entry points, não um barrel.** Como a superfície pública é *todo* arquivo da raiz, um pacote pode expor vários entry points pequenos (`index.ts`, `client.ts`, `server.ts`) em vez de afunilar tudo por um `index.ts` gigante. Barrel files que reexportam uma subárvore inteira são desencorajados; mantenha os entry points pequenos e esconda a implementação nas subpastas.

Camadas (quais pacotes podem depender de quais) são uma preocupação *diferente* e ficam como um esboço comentado na configuração, para este repositório preencher.

## Passos

### 1. Detecte o ambiente

- **Gerenciador de pacotes**: `pnpm-lock.yaml` → pnpm, `yarn.lock` → yarn, `bun.lockb` → bun, senão npm. Use-o em todos os comandos abaixo (`pnpm`/`yarn`/`npm run`/`bunx`).
- **Raiz dos pacotes**: se `src/` existir, use `src/packages`; senão, `packages`. Confirme a escolha com o usuário se o repositório já tiver outra convenção óbvia.
- **Configuração existente**: procure um arquivo `.dependency-cruiser.*`. Se existir, **não** o sobrescreva: faça o merge das quatro regras e das opções nele e diga ao usuário o que você acrescentou.

**Pronto quando:** o gerenciador de pacotes, a raiz dos pacotes e a situação da configuração existente forem todos conhecidos.

### 2. Instale o dependency-cruiser

Instale `dependency-cruiser` como devDependency com o gerenciador de pacotes detectado.

**Pronto quando:** `dependency-cruiser` estiver em `devDependencies`.

### 3. Escreva a configuração

Copie [`dependency-cruiser.config.cjs`](./dependency-cruiser.config.cjs) para a raiz do repositório como `.dependency-cruiser.cjs`. Defina `PACKAGES_ROOT` com a raiz detectada no passo 1. As regras se baseiam na profundidade do caminho e não dependem de extensão, então nada mais precisa ser adaptado.

**Pronto quando:** `.dependency-cruiser.cjs` existir com o `PACKAGES_ROOT` correto e as quatro regras `forbidden` estiverem presentes.

### 4. Ligue nas verificações

- Adicione um script `lint:boundaries`: `depcruise <raiz-dos-pacotes>` (ou `depcruise src`).
- Inclua-o no comando de verificação geral do repositório, aquele que já roda o typecheck (ex.: um script `check` / `ci` / `validate`). **Não** mexa no `tsconfig` nem adicione path aliases.
- Se não houver script geral, adicione `lint:boundaries` e diga ao usuário para incluí-lo no CI.

**Pronto quando:** `lint:boundaries` existir e rodar como parte do mesmo comando que o typecheck.

### 5. Crie o pacote de exemplo

Crie um `<raiz-dos-pacotes>/example/` versionado, como modelo para copiar:

- `index.ts` é um entry point. Exporte uma função que delega para um arquivo interno (para que o pacote seja visivelmente *profundo*, e não um repasse).
- `lib/impl.ts`: um arquivo interno numa **subpasta**, importado pelo `index.ts`, inacessível de fora.
- `tests/example.test.ts` importa **só** `../index` (um entry point) e faz asserções sobre a função pública.

Diga ao usuário que isto é um modelo inicial para copiar ou apagar.

**Pronto quando:** o pacote de exemplo existir, expuser o comportamento por um entry point na raiz e esconder o `impl` numa subpasta.

### 6. Prove que as regras funcionam

Este é o critério de conclusão da skill inteira: uma configuração que não falha numa violação não vale nada.

1. Rode `lint:boundaries`. Ele precisa **passar** no exemplo limpo.
2. Adicione temporariamente um import profundo em `tests/example.test.ts` (ex.: `import { thing } from "../lib/impl"`). Rode `lint:boundaries` de novo; ele precisa **falhar** com `tests-through-entrypoints`.
3. Desfaça o import profundo. Rode mais uma vez; ele precisa **passar**.

**Pronto quando:** você tiver observado um sucesso, depois uma falha no import profundo, depois um sucesso de novo. Se o passo 2 não falhar, as regras não estão ligadas corretamente; corrija antes de terminar.

### 7. Documente a convenção

Escreva um `README.md` **na pasta dos pacotes** (`<raiz-dos-pacotes>/README.md`, ao lado dos pacotes que ele rege) cobrindo: o layout `src/packages/<nome>/` (entry points na raiz, `lib/` para a implementação, `tests/` para os testes), "importe só pelos entry points de um pacote (os arquivos da raiz)" e como rodar `lint:boundaries`. **Desencoraje barrel files** explicitamente: exponha vários entry points pequenos em vez de reexportar uma subárvore inteira por um único index. Limite-se ao trecho para copiar mais as quatro regras, um parágrafo cada.

Depois acrescente um **ponteiro de contexto** para ele no arquivo de instruções para agentes do repositório (`CLAUDE.md` se existir, senão `AGENTS.md`, criando o `AGENTS.md` se nenhum dos dois existir). Uma linha basta, ex.: `Os pacotes são módulos profundos: veja [src/packages/README.md](./src/packages/README.md) antes de criar ou importar um.` É isso que faz um agente descobrir a regra de fronteira em vez de tropeçar nela.

**Pronto quando:** `<raiz-dos-pacotes>/README.md` existir e desencorajar barrels, e o `CLAUDE.md`/`AGENTS.md` do repositório linkar para ele.

## Observações

- As referências `$1` da configuração (o group matching do dependency-cruiser) são o que permite a um pacote alcançar os próprios detalhes internos enquanto quem está de fora não consegue. Não as achate em regras separadas por pacote.
- Público vs. privado é decidido pela **profundidade**: os arquivos da raiz de um pacote são entry points; qualquer coisa numa subpasta é privada. As subpastas convencionais são `lib/` (implementação) e `tests/`, mas a regra não as fixa no código: qualquer subpasta é privada, então uma pasta nova nunca exige mudar a configuração. Adicionar um entry point é só adicionar um arquivo na raiz (sem barrel).
- Os pacotes são **planos**: um único nível de filhos imediatos sob a raiz. Os detalhes internos de um pacote podem ter quantos níveis você quiser; um pacote não pode conter outro pacote.
- Use `.cjs` (não `.js`) para que o `module.exports` da configuração funcione mesmo em repositórios com `"type": "module"`.
