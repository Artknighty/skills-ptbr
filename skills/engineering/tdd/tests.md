# Testes bons e ruins

## Testes bons

**Estilo integração**: testam por interfaces reais, não por mocks de partes internas.

```typescript
// BOM: testa comportamento observável
test("usuário consegue finalizar a compra com carrinho válido", async () => {
  const cart = createCart();
  cart.add(product);
  const result = await checkout(cart, paymentMethod);
  expect(result.status).toBe("confirmed");
});
```

Características:

- Testa o comportamento que importa para usuários/chamadores
- Usa só a API pública
- Sobrevive a refatorações internas
- Descreve O QUÊ, não COMO
- Uma asserção lógica por teste

## Testes ruins

**Testes de detalhe de implementação**: acoplados à estrutura interna.

```typescript
// RUIM: testa detalhes de implementação
test("checkout chama paymentService.process", async () => {
  const mockPayment = jest.mock(paymentService);
  await checkout(cart, payment);
  expect(mockPayment.process).toHaveBeenCalledWith(cart.total);
});
```

Sinais de alerta:

- Mock de colaboradores internos
- Teste de métodos privados
- Asserções sobre quantidade/ordem de chamadas
- O teste quebra ao refatorar sem mudança de comportamento
- O nome do teste descreve COMO, não O QUÊ
- Verificação por meios externos em vez da interface

```typescript
// RUIM: contorna a interface para verificar
test("createUser grava no banco de dados", async () => {
  await createUser({ name: "Alice" });
  const row = await db.query("SELECT * FROM users WHERE name = ?", ["Alice"]);
  expect(row).toBeDefined();
});

// BOM: verifica pela interface
test("createUser torna o usuário recuperável", async () => {
  const user = await createUser({ name: "Alice" });
  const retrieved = await getUser(user.id);
  expect(retrieved.name).toBe("Alice");
});
```

**Testes tautológicos**: o valor esperado repete a implementação, então o teste passa por construção.

```typescript
// RUIM: o valor esperado é recalculado do mesmo jeito que o código calcula
test("calculateTotal soma os itens", () => {
  const items = [{ price: 10 }, { price: 5 }];
  const expected = items.reduce((sum, i) => sum + i.price, 0);
  expect(calculateTotal(items)).toBe(expected);
});

// BOM: o valor esperado é um literal conhecido e independente
test("calculateTotal soma os itens", () => {
  expect(calculateTotal([{ price: 10 }, { price: 5 }])).toBe(15);
});
```
