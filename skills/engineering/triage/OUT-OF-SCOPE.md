# Base de conhecimento de fora do escopo

O diretório `.out-of-scope/` de um repositório guarda registros persistentes de pedidos de funcionalidade rejeitados. Ele serve a dois propósitos:

1. **Memória institucional**: por que uma funcionalidade foi rejeitada, para que o raciocínio não se perca quando a issue for fechada
2. **Deduplicação**: quando chega uma issue nova parecida com uma rejeição anterior, a skill pode trazer à tona a decisão anterior em vez de rediscuti-la

## Estrutura de diretórios

```
.out-of-scope/
├── modo-escuro.md
├── sistema-de-plugins.md
└── api-graphql.md
```

Um arquivo por **conceito**, não por issue. Várias issues pedindo a mesma coisa ficam agrupadas num arquivo só.

## Formato do arquivo

O arquivo deve ser escrito num estilo leve e legível, mais parecido com um documento de design curto do que com um registro de banco de dados. Use parágrafos, trechos de código e exemplos para deixar o raciocínio claro e útil para quem o encontrar pela primeira vez.

```markdown
# Modo escuro

Este projeto não suporta modo escuro nem temas configuráveis pelo usuário.

## Por que isto está fora do escopo

O pipeline de renderização pressupõe uma única paleta de cores definida em
`ThemeConfig`. Suportar vários temas exigiria:

- Um provedor de contexto de tema envolvendo toda a árvore de componentes
- Resolução de estilo sensível ao tema em cada componente
- Uma camada de persistência para as preferências de tema do usuário

É uma mudança de arquitetura significativa que não se alinha ao foco do
projeto em criação de conteúdo. Temas são uma preocupação de quem consome o
resultado, embutindo-o ou redistribuindo-o.

```ts
// A interface ThemeConfig atual não foi projetada para troca em tempo de execução:
interface ThemeConfig {
  colors: ColorPalette; // paleta única, resolvida em tempo de build
  fonts: FontStack;
}
```

## Pedidos anteriores

- #42: "Adicionar suporte a modo escuro"
- #87: "Tema noturno para acessibilidade"
- #134: "Opção de tema escuro"
```

### Dando nome ao arquivo

Use um nome curto e descritivo em kebab-case para o conceito: `modo-escuro.md`, `sistema-de-plugins.md`, `api-graphql.md`. O nome deve ser reconhecível o bastante para que alguém navegando pelo diretório entenda o que foi rejeitado sem abrir o arquivo.

### Escrevendo o motivo

O motivo deve ter substância: não "não queremos isso", e sim o porquê. Bons motivos citam:

- O escopo ou a filosofia do projeto ("Este projeto foca em X; temas são uma preocupação de quem consome")
- Restrições técnicas ("Suportar isto exigiria Y, que conflita com a nossa arquitetura Z")
- Decisões estratégicas ("Escolhemos usar A em vez de B porque...")

O motivo deve ser durável. Evite citar circunstâncias temporárias ("estamos ocupados demais agora"); essas não são rejeições de verdade, são adiamentos.

## Quando consultar `.out-of-scope/`

Durante a triagem (Passo 1: Reúna o contexto), leia todos os arquivos de `.out-of-scope/`. Ao avaliar uma issue nova:

- Verifique se o pedido corresponde a um conceito fora do escopo já existente
- A correspondência é por semelhança de conceito, não por palavra-chave: "tema noturno" corresponde a `modo-escuro.md`
- Se houver correspondência, mostre ao mantenedor: "Isto é parecido com `.out-of-scope/modo-escuro.md`. Rejeitamos isso antes porque [motivo]. Você ainda pensa assim?"

O mantenedor pode:

- **Confirmar**: a issue nova é acrescentada à lista de "Pedidos anteriores" do arquivo existente e depois fechada
- **Reconsiderar**: o arquivo de fora do escopo é apagado ou atualizado, e a issue segue pela triagem normal
- **Discordar**: as issues são relacionadas, mas distintas; siga com a triagem normal

## Quando escrever em `.out-of-scope/`

Só quando um **enhancement** (não um bug) for *rejeitado* como `wontfix`. Isso vale para PRs de enhancement exatamente como para issues: um PR rejeitado é registrado aqui para que o mesmo pedido não volte como código novo.

**Não** escreva aqui quando algo for fechado como `wontfix` por **já estar implementado**. Isso é uma funcionalidade construída, não rejeitada; registrá-la envenenaria as verificações de deduplicação com falsas rejeições. Nesse caso, o comentário de fechamento aponta onde a funcionalidade já está.

O fluxo:

1. O mantenedor decide que um pedido de funcionalidade está fora do escopo
2. Verifique se já existe um arquivo correspondente em `.out-of-scope/`
3. Se sim: acrescente a issue nova à lista de "Pedidos anteriores"
4. Se não: crie um arquivo novo com o nome do conceito, a decisão, o motivo e o primeiro pedido anterior
5. Publique um comentário na issue explicando a decisão e mencionando o arquivo de `.out-of-scope/`
6. Feche a issue com a label `wontfix`

## Atualizando ou removendo arquivos de fora do escopo

Se o mantenedor mudar de ideia sobre um conceito rejeitado antes:

- Apague o arquivo de `.out-of-scope/`
- A skill não precisa reabrir issues antigas; elas são registros históricos
- A issue nova que motivou a reconsideração segue pela triagem normal
