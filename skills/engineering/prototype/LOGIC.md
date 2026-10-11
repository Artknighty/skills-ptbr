# Protótipo de lógica

Um único arquivo HTML autocontido (uma **demo compartilhável**) que permite a qualquer pessoa conduzir um modelo de estado clicando em botões. Use quando a pergunta for sobre **regra de negócio, transições de estado ou formato dos dados**: o tipo de coisa que parece razoável no papel, mas só parece errada quando você a passa por casos reais.

Como é um arquivo só, sem nada para instalar, você pode entregá-lo a uma pessoa não desenvolvedora (um designer, um PM, um especialista de domínio) e deixá-la sentir o modelo por conta própria. Então ele fala a língua dela, não a do código.

## Quando este é o formato certo

- "Não sei se esta máquina de estados trata o caso-limite em que acontece X e depois Y."
- "Este modelo de dados realmente me deixa representar o caso em que..."
- "Quero sentir como a API deveria ser antes de escrevê-la."
- Qualquer coisa em que alguém quer **apertar botões e ver o estado mudar**.

Se a pergunta for "como isto deveria ficar", este é o ramo errado. Use [UI.md](UI.md).

## Processo

### 1. Declare a pergunta

Antes de escrever código, anote qual modelo de estado e qual pergunta você está prototipando. Um parágrafo, no topo da demo (numa introdução visível, não só num comentário). Um protótipo de lógica que responde a pergunta errada é puro desperdício, então deixe a pergunta explícita para que possa ser conferida depois, esteja o usuário assistindo agora ou voltando a ela AFK.

### 2. Isole a lógica num módulo portátil

Coloque a lógica de verdade (a parte que responde a pergunta) num único bloco `<script>` escrito como um módulo pequeno e puro, que possa ser tirado dali e colocado no código real depois. A página em volta é descartável; este módulo não.

O formato certo depende da pergunta:

- **Um reducer puro**: `(state, action) => state`. Bom quando as ações são eventos discretos e o estado é um valor único.
- **Uma máquina de estados**: estados e transições explícitos. Boa quando "quais ações são sequer permitidas agora" faz parte da pergunta.
- **Um pequeno conjunto de funções puras** sobre um tipo de dado simples. Bom quando não há um estado atual implícito, só transformações.
- **Uma classe ou módulo com uma superfície de métodos clara**, quando a lógica realmente detém um estado interno contínuo.

Escolha o formato que melhor se encaixa na pergunta feita, *não* o mais fácil de ligar a uma página. Mantenha-o puro: sem DOM, sem `document`, sem handlers de botão mexendo lá dentro. A página chama o módulo; nada flui no sentido contrário. É isso que torna o protótipo útil além da própria vida: depois que a pergunta for respondida, o reducer / a máquina / o conjunto de funções validado sobe sozinho para o módulo real.

### 3. Construa o arquivo HTML compartilhável

Um arquivo, HTML/CSS/JS puro: sem framework, sem bundler, sem servidor, tudo inline para abrir com dois cliques e sobreviver a ser enviado por e-mail. Qualquer pessoa deve conseguir rodá-lo só abrindo.

Escreva para uma pessoa não desenvolvedora. Todo rótulo está em **linguagem de domínio**, não de código: botões e estado se leem como o negócio, não como o reducer. Explique em palavras simples o que está acontecendo.

Organize com uma hierarquia limpa, de cima para baixo:

1. **Título e explicação de uma linha** do que esta demo permite explorar (a pergunta do passo 1).
2. **Estado atual**: todo o estado relevante, renderizado como um painel legível (campos rotulados, não um dump de JSON cru), renderizado de novo a cada clique para que a mudança fique visível. Onde ajudar uma pessoa não desenvolvedora a acompanhar, destaque o que acabou de mudar.
3. **Botões de uso livre**: um botão por ação, sempre disponível, para que qualquer pessoa possa cutucar o modelo em qualquer ordem. Cada clique despacha a ação dele e renderiza o estado de novo.
4. **Roteiros guiados**: um conjunto de **cenários**, um por aba. Cada aba traz uma descrição curta, em linguagem simples, do cenário (a situação que ele monta e o que observar) e, abaixo dela, os **botões a apertar** em ordem para aquele cenário. Cada passo é um botão de verdade: clicar executa aquela ação e avança para o próximo passo. Iniciar um roteiro volta a um estado inicial conhecido, para que o cenário rode do mesmo jeito toda vez.

Escolha cenários que demonstrem os casos incômodos, os difíceis de raciocinar no papel: o caminho feliz, um caso-limite traiçoeiro, uma tentativa de algo que deveria ser proibido.

Deixe bonito, mas contido: tipografia limpa, espaçamento generoso, uma cor de destaque. Sem animações, sem firulas: nada que dispute atenção com o estado e os botões.

### 4. Entregue

Mande o arquivo, ou abra-o para a pessoa. Ela vai clicar nos roteiros e no uso livre quando puder; os momentos interessantes são quando ela diz "espera, isso não deveria ser possível" ou "hum, eu achei que X seria diferente"; esses são os bugs na _ideia_, que é a questão toda. Se ela quiser novas ações ou um novo cenário, acrescente. Protótipos evoluem.

### 5. Registre a resposta e o protótipo

Quando o protótipo tiver respondido a pergunta, registre a resposta e depois registre o protótipo do jeito que a [SKILL](SKILL.md) descreve. O mapeamento específico da lógica: o reducer / a máquina / o conjunto de funções validado sobe para o módulo real (a decisão, absorvida); a casca HTML vai junto para o branch descartável que guarda o protótipo como fonte primária e, por ser um arquivo autocontido, continua trivial de rodar de novo lá.

## Antipadrões

- **Não acrescente testes.** Um protótipo que precisa de testes deixou de ser protótipo.
- **Não ligue no banco de dados real.** Use estado em memória, a menos que a pergunta seja especificamente sobre persistência.
- **Não generalize.** Nada de "e se a gente quiser suportar X depois". O protótipo responde uma pergunta.
- **Não misture a lógica com a página.** Se o módulo puro referencia o DOM, `document` ou handlers de botão, ele deixa de ser transplantável. Mantenha a página como uma casca fina sobre um módulo puro.
- **Não recorra a framework, bundler ou servidor.** Um arquivo em que o destinatário dá dois cliques; um app React ou um servidor de desenvolvimento acabam com o "compartilhável".
- **Não leve a casca HTML para produção.** A página é otimizada para ser clicada à mão. O módulo de lógica por trás dela é a parte que vale guardar.
