# Formato do registro de aprendizado

Os registros de aprendizado ficam em `./learning-records/` e usam numeração sequencial: `0001-slug.md`, `0002-slug.md` etc. Crie o diretório sob demanda: só quando o primeiro registro for escrito.

Eles são o equivalente, no ensino, aos ADRs: registram lições não óbvias, insights importantes e conhecimento prévio declarado que vão orientar sessões futuras. São usados para calcular a zona de desenvolvimento proximal.

## Modelo

```md
# {Título curto do que foi aprendido ou estabelecido}

{1 a 3 frases: o que foi aprendido (ou que conhecimento prévio foi estabelecido) e por que isso importa para as próximas sessões.}
```

Esse é o formato inteiro. Um registro de aprendizado pode ser um único parágrafo. O valor está em registrar _que_ isso agora é sabido e _por que_ isso muda o que ensinar em seguida, não em preencher seções.

## Seções opcionais

Inclua só quando agregarem valor de verdade. A maioria dos registros não vai precisar.

- Frontmatter de **Status** (`active | superseded by LR-NNNN`): útil quando um entendimento anterior se revela errado e é substituído.
- **Evidência**: como o usuário demonstrou o entendimento (uma pergunta respondida, um exercício concluído, uma experiência anterior citada). Útil quando a afirmação puder ser revisitada.
- **Implicações**: o que isso destrava ou descarta para as próximas sessões. Vale registrar quando não for óbvio.

## Numeração

Procure em `./learning-records/` o maior número existente e some um.

## Quando escrever um registro de aprendizado

Escreva um quando qualquer uma destas condições for verdadeira:

1. **O usuário demonstrou entendimento real de algo não trivial**: não só exposição, mas evidência de que ele consegue usar o conceito corretamente. Isso define um novo piso para o que ensinar em seguida.
2. **O usuário revelou conhecimento prévio**: "Eu já sei X." Registre para que as próximas sessões não ensinem de novo. Registre também a _profundidade_ declarada.
3. **Um equívoco foi corrigido**: o usuário acreditava em algo errado e agora entende por quê. Esses valem muito: preveem tropeços futuros em assuntos relacionados.
4. **A missão mudou em resposta ao aprendizado**: o usuário descobriu que se importava com algo diferente do que pensava. Faça o link cruzado com [[MISSION.md]] e atualize-o.

### O que _não_ conta

- Material que foi apenas coberto. Cobertura não é aprendizado. Espere a evidência.
- Qualquer coisa já registrada de forma concisa no [[GLOSSARY.md]] como definição de termo. Não duplique.
- Logs de atividade sessão a sessão. Registros de aprendizado não são um diário: são insights com peso de decisão.

## Substituição

Quando um registro posterior contradiz um anterior (o entendimento do usuário se aprofundou ou foi corrigido), marque o registro antigo como `Status: superseded by LR-NNNN` em vez de apagá-lo. O histórico de como o entendimento evoluiu é, por si só, um sinal útil.
