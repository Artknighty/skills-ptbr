# Aprofundamento

Como aprofundar com segurança um grupo de módulos rasos, dadas as suas dependências. Pressupõe o vocabulário de [SKILL.md](SKILL.md): **módulo**, **interface**, **seam**, **adapter**.

## Categorias de dependência

Ao avaliar um candidato a aprofundamento, classifique as dependências dele. A categoria determina como o módulo aprofundado é testado através do seu seam.

### 1. No mesmo processo

Computação pura, estado em memória, sem I/O. Sempre dá para aprofundar: junte os módulos e teste diretamente pela nova interface. Nenhum adapter necessário.

### 2. Substituível localmente

Dependências que têm substitutos locais para teste (PGLite para Postgres, sistema de arquivos em memória). Dá para aprofundar se o substituto existir. O módulo aprofundado é testado com o substituto rodando na suíte de testes. O seam é interno; nenhum port na interface externa do módulo.

### 3. Remota, mas própria (Ports & Adapters)

Seus próprios serviços do outro lado de uma fronteira de rede (microsserviços, APIs internas). Defina um **port** (interface) no seam. O módulo profundo detém a lógica; o transporte é injetado como um **adapter**. Os testes usam um adapter em memória. A produção usa um adapter HTTP/gRPC/fila.

Formato da recomendação: *"Defina um port no seam, implemente um adapter HTTP para produção e um adapter em memória para teste, para que a lógica fique num único módulo profundo mesmo sendo implantada através de uma rede."*

### 4. Realmente externa (Mock)

Serviços de terceiros (Stripe, Twilio etc.) que você não controla. O módulo aprofundado recebe a dependência externa como um port injetado; os testes fornecem um adapter de mock.

## Disciplina de seams

- **Um adapter significa um seam hipotético. Dois adapters significam um seam real.** Não introduza um port a menos que pelo menos dois adapters se justifiquem (tipicamente produção + teste). Um seam com um só adapter é só indireção.
- **Seams internos vs. seams externos.** Um módulo profundo pode ter seams internos (privados à implementação, usados pelos próprios testes) além do seam externo na interface. Não exponha seams internos pela interface só porque os testes os usam.

## Estratégia de teste: substitua, não empilhe

- Os testes unitários antigos dos módulos rasos viram desperdício quando existirem testes na interface do módulo aprofundado; apague-os.
- Escreva testes novos na interface do módulo aprofundado. A **interface é a superfície de teste**.
- Os testes fazem asserções sobre resultados observáveis pela interface, não sobre estado interno.
- Os testes devem sobreviver a refatorações internas, já que descrevem comportamento, não implementação. Se um teste precisa mudar quando a implementação muda, ele está testando além da interface.
