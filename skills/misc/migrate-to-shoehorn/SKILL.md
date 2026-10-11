---
name: migrate-to-shoehorn
description: Migra arquivos de teste de type assertions com `as` para @total-typescript/shoehorn. Use quando o usuário mencionar shoehorn, quiser substituir `as` nos testes ou precisar de dados de teste parciais.
---

# Migrar para o shoehorn

## Por que shoehorn?

O `shoehorn` permite passar dados parciais nos testes mantendo o TypeScript satisfeito. Ele substitui as assertions com `as` por alternativas type-safe.

**Só código de teste.** Nunca use o shoehorn em código de produção.

Problemas do `as` nos testes:

- Fomos treinados a não usá-lo
- É preciso especificar o tipo-alvo manualmente
- Double-as (`as unknown as Type`) para dados propositalmente errados

## Instalação

```bash
npm i @total-typescript/shoehorn
```

## Padrões de migração

### Objetos grandes em que só poucas propriedades importam

Antes:

```ts
type Request = {
  body: { id: string };
  headers: Record<string, string>;
  cookies: Record<string, string>;
  // ...mais 20 propriedades
};

it("busca o usuário pelo id", () => {
  // Só importa o body.id, mas é preciso fingir a Request inteira
  getUser({
    body: { id: "123" },
    headers: {},
    cookies: {},
    // ...fingir todas as 20 propriedades
  });
});
```

Depois:

```ts
import { fromPartial } from "@total-typescript/shoehorn";

it("busca o usuário pelo id", () => {
  getUser(
    fromPartial({
      body: { id: "123" },
    }),
  );
});
```

### `as Type` → `fromPartial()`

Antes:

```ts
getUser({ body: { id: "123" } } as Request);
```

Depois:

```ts
import { fromPartial } from "@total-typescript/shoehorn";

getUser(fromPartial({ body: { id: "123" } }));
```

### `as unknown as Type` → `fromAny()`

Antes:

```ts
getUser({ body: { id: 123 } } as unknown as Request); // tipo errado de propósito
```

Depois:

```ts
import { fromAny } from "@total-typescript/shoehorn";

getUser(fromAny({ body: { id: 123 } }));
```

## Quando usar cada um

| Função          | Caso de uso                                                 |
| --------------- | ----------------------------------------------------------- |
| `fromPartial()` | Passar dados parciais que ainda passam no typecheck         |
| `fromAny()`     | Passar dados propositalmente errados (mantém o autocomplete) |
| `fromExact()`   | Exigir o objeto completo (trocar por fromPartial depois)    |

## Fluxo de trabalho

1. **Levante os requisitos**: pergunte ao usuário:
   - Quais arquivos de teste têm assertions com `as` causando problemas?
   - Estão lidando com objetos grandes em que só algumas propriedades importam?
   - Precisam passar dados propositalmente errados para testar erros?

2. **Instale e migre**:
   - [ ] Instale: `npm i @total-typescript/shoehorn`
   - [ ] Encontre arquivos de teste com assertions `as`: `grep -r " as [A-Z]" --include="*.test.ts" --include="*.spec.ts"`
   - [ ] Substitua `as Type` por `fromPartial()`
   - [ ] Substitua `as unknown as Type` por `fromAny()`
   - [ ] Adicione os imports de `@total-typescript/shoehorn`
   - [ ] Rode o typecheck para verificar
