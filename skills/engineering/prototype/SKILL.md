---
name: prototype
description: Constrói um protótipo descartável para responder uma pergunta de design. Use quando o usuário quiser verificar se um modelo de estado ou uma lógica parece certa, prototipar algo, ou explorar como uma UI deveria ficar.
---

# Protótipo

Um protótipo é **código descartável que responde uma pergunta**. A pergunta decide o formato.

## Escolha um ramo

Identifique qual pergunta está sendo respondida, usando o prompt do usuário, o código ao redor ou perguntando, se o usuário estiver por perto:

- **"Esta lógica / este modelo de estado parece certo?"** → [LOGIC.md](LOGIC.md). Construa um único arquivo HTML compartilhável (botões de uso livre mais roteiros guiados em abas) que leve a máquina de estados por casos difíceis de raciocinar no papel, e que uma pessoa não desenvolvedora consiga conduzir.
- **"Como isto deveria ficar?"** → [UI.md](UI.md). Gere várias variações de UI radicalmente diferentes numa única rota, alternáveis por um parâmetro de busca na URL e uma barra flutuante na parte de baixo.

Os dois ramos produzem artefatos muito diferentes, então errar aqui desperdiça o protótipo inteiro. Se a pergunta for realmente ambígua e o usuário não estiver acessível, adote o ramo que melhor combinar com o código ao redor (um módulo de backend → lógica; uma página ou componente → UI) e declare essa suposição no topo do protótipo.

## Regras que valem para os dois

1. **Descartável desde o primeiro dia, e claramente marcado como tal.** Coloque o código do protótipo perto de onde ele vai realmente ser usado (ao lado do módulo ou página para o qual está prototipando), para que o contexto seja óbvio, mas dê um nome que deixe claro para um leitor casual que é um protótipo, não produção. Para rotas de UI descartáveis, siga a convenção de rotas que o projeto já usa; não invente uma nova estrutura de topo.
2. **Trivial de rodar.** Um protótipo de UI começa com um comando no task runner do projeto: `pnpm <nome>`, `python <caminho>`, `bun <caminho>` etc. Uma demo de lógica é um único arquivo HTML em que o usuário dá dois cliques. De qualquer forma, nenhum raciocínio necessário para iniciá-lo.
3. **Sem persistência por padrão.** O estado vive em memória. A persistência é aquilo que o protótipo está _verificando_, não algo de que ele deveria depender. Se a pergunta envolver explicitamente um banco de dados, use um banco de rascunho ou um arquivo local com um nome claro como "PROTÓTIPO, pode apagar".
4. **Pule o acabamento.** Sem testes, sem tratamento de erro além do que torna o protótipo _executável_, sem abstrações. A ideia é aprender algo rápido.
5. **Exponha o estado.** Depois de cada ação (lógica) ou a cada troca de variante (UI), imprima ou renderize todo o estado relevante para o usuário ver o que mudou.
6. **Registre quando terminar.** Incorpore qualquer decisão validada ao código real e depois registre o próprio protótipo como **fonte primária**: faça commit dele num branch descartável, fora do main, e deixe um ponteiro de contexto para esse branch na issue de implementação. Registre também a resposta (o veredito e a pergunta que ele resolveu) na issue ou num commit. O branch principal fica só com a decisão validada.
