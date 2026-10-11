---
name: tdd
description: Desenvolvimento guiado por testes (TDD). Use quando o usuário quiser construir funcionalidades ou corrigir bugs com teste primeiro, mencionar "red-green-refactor" ou "TDD", ou quiser testes de integração.
---

# Desenvolvimento guiado por testes

TDD é o ciclo vermelho → verde. Esta skill é a referência que faz esse ciclo produzir testes que valem a pena manter: o que é um bom teste, onde os testes ficam, os antipadrões e as regras do ciclo. Toda seção vale em todo ciclo: consulte-as antes e durante o ciclo, não depois.

Ao explorar o código, leia o `GLOSSARY.md` (se existir) para que os nomes dos testes e o vocabulário das interfaces batam com a linguagem de domínio do projeto, e respeite os ADRs da área que você está mexendo.

## O que é um bom teste

Testes verificam comportamento por meio de interfaces públicas, não detalhes de implementação. O código pode mudar inteiro; os testes não deveriam. Um bom teste se lê como uma especificação: "usuário consegue finalizar a compra com carrinho válido" diz exatamente que capacidade existe, e sobrevive a refatorações porque não liga para a estrutura interna.

Veja [tests.md](tests.md) para exemplos e [mocking.md](mocking.md) para orientações sobre mocks.

## Seams: onde os testes ficam

Um **seam** é a fronteira pública em que você testa: a interface em que você observa o comportamento sem enfiar a mão por dentro. Os testes vivem nos seams, nunca contra os detalhes internos.

**Teste só nos seams combinados de antemão.** Antes de escrever qualquer teste, anote os seams que serão testados e confirme-os com o usuário. Nenhum teste é escrito num seam não confirmado. Você não consegue testar tudo, então combinar os seams de antemão é como o esforço de teste cai nos caminhos críticos e na lógica complexa, em vez de em todo caso-limite.

Pergunte: "Qual é a interface pública, e quais seams devemos testar?" Dê a cada seam proposto uma nota de uma linha sobre o que ele pega e o que ele deixa passar.

Quando a própria forma dessa interface estiver em questão (quão profundo é o módulo, onde o seam deve ficar, o que a interface deve expor), chame a ferramenta Skill com "codebase-design" para o vocabulário. Ela é a fonte compartilhada dos termos módulo, interface, profundidade, seam, adapter, alavancagem e localidade, e é uma referência a consultar, não uma sessão a conduzir.

## Antipadrões

- **Acoplado à implementação**: faz mock de colaboradores internos, testa métodos privados ou verifica por um canal lateral (consultando o banco de dados em vez de usar a interface). O sinal: o teste quebra quando você refatora, mas o comportamento não mudou.
- **Tautológico**: a asserção recalcula o valor esperado do mesmo jeito que o código (`expect(add(a, b)).toBe(a + b)`, um snapshot derivado à mão do mesmo jeito, uma constante comparada consigo mesma), então ele passa por construção e nunca consegue discordar do código. Os valores esperados precisam vir de uma fonte da verdade independente: um literal sabidamente correto, um exemplo calculado, a spec.
- **Horizontal slicing**: escrever todos os testes primeiro e depois toda a implementação. Testes em lote verificam um comportamento _imaginado_: você testa o _formato_ das coisas em vez do comportamento que o usuário vê, os testes ficam insensíveis a mudanças reais e você se compromete com uma estrutura de testes antes de entender a implementação. Trabalhe em **vertical slices**: um teste → uma implementação → repete, cada teste um **tracer bullet** que responde ao que o ciclo anterior ensinou.

## Regras do ciclo

- **Vermelho antes de verde.** Escreva primeiro o teste que falha, depois só o código suficiente para ele passar. Não antecipe testes futuros nem acrescente funcionalidades especulativas.
- **Um slice por vez.** Um seam, um teste, uma implementação mínima por ciclo.
- **Refatorar não faz parte do ciclo.** Isso pertence à etapa de revisão (veja a skill `code-review`), não ao ciclo de implementação vermelho → verde.
