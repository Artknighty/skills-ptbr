# Formato de ADR

Os ADRs ficam em `docs/adr/` e usam numeração sequencial: `0001-slug.md`, `0002-slug.md` etc.

Crie o diretório `docs/adr/` sob demanda: só quando o primeiro ADR for necessário.

## Modelo

```md
# {Título curto da decisão}

{1 a 3 frases: qual é o contexto, o que decidimos e por quê.}
```

Só isso. Um ADR pode ser um único parágrafo. O valor está em registrar *que* uma decisão foi tomada e *por quê*, não em preencher seções.

## Seções opcionais

Inclua só quando agregarem valor de verdade. A maioria dos ADRs não vai precisar.

- Frontmatter de **Status** (`proposed | accepted | deprecated | superseded by ADR-NNNN`): útil quando decisões são revisitadas
- **Opções consideradas**: só quando valer a pena lembrar das alternativas rejeitadas
- **Consequências**: só quando efeitos não óbvios mais adiante precisarem ser destacados

## Numeração

Procure em `docs/adr/` o maior número existente e some um.

## Quando oferecer um ADR

As três condições precisam ser verdadeiras:

1. **Difícil de reverter**: o custo de mudar de ideia depois é significativo
2. **Surpreendente sem contexto**: um leitor futuro vai olhar o código e se perguntar "por que diabos fizeram desse jeito?"
3. **Resultado de um trade-off real**: havia alternativas genuínas e vocês escolheram uma por motivos específicos

Se uma decisão é fácil de reverter, pule: vocês simplesmente vão revertê-la. Se não é surpreendente, ninguém vai se perguntar o porquê. Se não havia alternativa real, não há nada a registrar além de "fizemos o óbvio".

### O que se qualifica

- **Forma da arquitetura.** "Estamos usando um monorepo." "O modelo de escrita usa event sourcing; o modelo de leitura é projetado no Postgres."
- **Padrões de integração entre contextos.** "Pedidos e Faturamento se comunicam por eventos de domínio, não por HTTP síncrono."
- **Escolhas de tecnologia que trazem lock-in.** Banco de dados, barramento de mensagens, provedor de autenticação, alvo de deploy. Não toda biblioteca: só as que levariam um trimestre para trocar.
- **Decisões de fronteira e escopo.** "Os dados de cliente pertencem ao contexto Cliente; os outros contextos os referenciam só por ID." Os "nãos" explícitos valem tanto quanto os "sins".
- **Desvios deliberados do caminho óbvio.** "Usamos SQL manual em vez de um ORM por causa de X." Qualquer coisa em que um leitor razoável presumiria o contrário. Isso impede o próximo engenheiro de "consertar" algo que foi deliberado.
- **Restrições que não aparecem no código.** "Não podemos usar AWS por exigências de compliance." "Os tempos de resposta precisam ficar abaixo de 200 ms por causa do contrato da API do parceiro."
- **Alternativas rejeitadas quando a rejeição não é óbvia.** Se vocês consideraram GraphQL e escolheram REST por motivos sutis, registre; senão alguém vai sugerir GraphQL de novo daqui a seis meses.
