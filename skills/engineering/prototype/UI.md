# Protótipo de UI

Gere **várias variações de UI radicalmente diferentes** numa única rota, alternáveis por uma barra flutuante na parte de baixo. O usuário alterna entre as variantes no navegador, escolhe uma (ou rouba pedaços de cada) e joga o resto fora.

Se a pergunta for sobre lógica/estado e não sobre a aparência de algo, este é o ramo errado. Use [LOGIC.md](LOGIC.md).

## Quando este é o formato certo

- "Como esta página deveria ficar?"
- "Quero ver algumas opções para este dashboard antes de me comprometer."
- "Tente um layout diferente para a tela de configurações."
- Sempre que o usuário, de outro jeito, passaria um dia escolhendo entre três mockups vagos na cabeça.

## Dois subformatos: prefira fortemente o subformato A

Um protótipo de UI é muito mais fácil de julgar quando está **encostado no resto do app**: cabeçalho real, sidebar real, dados reais, densidade real. Uma rota descartável sozinha é um vácuo: toda variante parece boa isolada. Adote o subformato A sempre que houver uma página existente plausível para hospedar as variantes. Só recorra ao subformato B se o protótipo realmente não tiver um lar por perto.

### Subformato A: ajuste numa página existente (preferido)

A rota já existe. As variantes são renderizadas **na mesma rota**, controladas por um parâmetro de busca `?variant=` na URL. A busca de dados, os parâmetros e a autenticação existentes continuam. Só a renderização troca. Este é o padrão; escolha-o a menos que haja um motivo específico para não escolher.

Se o protótipo é para algo que ainda não tem página, mas *viveria naturalmente dentro de uma* (uma nova seção do dashboard, um novo card na tela de configurações, um novo passo num fluxo existente), continua sendo o subformato A. Monte as variantes dentro da página hospedeira.

### Subformato B: uma página nova (último recurso)

Use só quando o que está sendo prototipado realmente não tiver uma página existente onde viver (ex.: uma superfície de topo totalmente nova, ou um fluxo que não dá para embutir em nenhum lugar razoável).

Crie uma **rota descartável** seguindo a convenção de rotas que o projeto já usa. Não invente uma nova estrutura de topo. Dê um nome que deixe óbvio que é um protótipo (ex.: inclua a palavra `prototype` no caminho ou no nome do arquivo). Mesmo padrão `?variant=`.

Antes de se comprometer com o subformato B, confira: realmente não existe uma página onde isto pudesse ser embutido? Uma rota vazia esconde problemas de design que uma preenchida exporia.

Nos dois subformatos, a barra flutuante é idêntica.

## Processo

### 1. Declare a pergunta e escolha N

O padrão é **3 variantes**. Mais de 5 deixa de ser radicalmente diferente e começa a ser ruído, então limite aí.

Anote o plano numa linha, no local do protótipo ou num comentário no topo do arquivo:

> "Três variantes da página de configurações, alternáveis via `?variant=`, na rota existente `/settings`."

Isso funciona esteja o usuário aqui para questionar ou não.

### 2. Gere variantes radicalmente diferentes

Esboce cada variante. Prenda cada uma a:

- O propósito da página e os dados a que ela tem acesso.
- A biblioteca de componentes / sistema de estilos do projeto (TailwindCSS, shadcn, MUI, CSS puro, o que for).
- Um nome de componente exportado claro, ex.: `VariantA`, `VariantB`, `VariantC`.

As variantes precisam ser **estruturalmente diferentes**: layout diferente, hierarquia de informação diferente, ação principal diferente, não só cores diferentes. Três grades de cards levemente ajustadas não são um protótipo de UI, são papel de parede. Se dois esboços saírem parecidos demais, refaça um com a orientação explícita "não use uma grade de cards".

### 3. Ligue tudo

Crie um único componente alternador na rota:

```tsx
// pseudocódigo, adapte ao framework do projeto
const variant = searchParams.get('variant') ?? 'A';
return (
  <>
    {variant === 'A' && <VariantA {...data} />}
    {variant === 'B' && <VariantB {...data} />}
    {variant === 'C' && <VariantC {...data} />}
    <PrototypeSwitcher variants={['A','B','C']} current={variant} />
  </>
);
```

Para o subformato A (página existente): mantenha toda a busca de dados existente acima do alternador; só a subárvore renderizada muda por variante.

Para o subformato B (página nova): a rota descartável em `/prototype/<nome>` monta o mesmo alternador.

### 4. Construa o alternador flutuante

Uma barrinha de posição fixa no centro inferior da tela, com três peças:

- **Seta esquerda**: vai para a variante anterior (dando a volta).
- **Rótulo da variante**: mostra a chave da variante atual e, se a variante exportar um nome, esse nome também. Ex.: `B (Layout com sidebar)`.
- **Seta direita**: avança (dando a volta).

Comportamento:

- Clicar numa seta atualiza o parâmetro de busca da URL (use o roteador do framework, ex.: `router.replace` no Next, `navigate` no React Router etc.), para que a variante seja compartilhável e estável ao recarregar.
- Teclado: as setas `←` e `→` também alternam. Não intercepte as setas quando um `<input>`, `<textarea>` ou `[contenteditable]` estiver com foco.
- Visualmente distinta da página (ex.: uma pílula de alto contraste, sombra sutil), para que fique óbvio que ela não faz parte do design em avaliação.
- Escondida em builds de produção: condicione a `process.env.NODE_ENV !== 'production'` ou verificação equivalente, para que um merge acidental do protótipo não leve a barra aos usuários.

Coloque o alternador num único componente compartilhado, para que os dois subformatos possam reaproveitá-lo. Coloque-o onde a UI compartilhada vive no projeto.

### 5. Entregue

Mostre a URL (e as chaves de `?variant=`). O usuário vai alternar quando puder. O feedback interessante costuma ser **"quero o cabeçalho da B com a sidebar da C"**, que é o design que ele realmente quer.

### 6. Registre a resposta e limpe

Quando uma variante vencer, registre a resposta (qual variante e por quê) e depois registre o protótipo do jeito que a [SKILL](SKILL.md) descreve. Incorpore a vencedora ao código real e leve o resto para o branch descartável, não para o main:

- **Subformato A**: incorpore a vencedora à página existente; tire do main as variantes perdedoras e o alternador.
- **Subformato B**: promova a variante vencedora a uma rota de verdade; tire do main a rota descartável e o alternador.

O conjunto completo de variantes é a fonte primária, então ele vai para o branch descartável, não para o lixo, já que componentes de variante e o alternador deixados no branch principal apodrecem rápido e confundem o próximo leitor.

## Antipadrões

- **Variantes que diferem só na cor ou no texto.** Isso é um ajuste, não um protótipo. Variantes de verdade discordam sobre a estrutura.
- **Compartilhar código demais entre variantes.** Um `<Header>` compartilhado tudo bem; um `<Layout>` compartilhado acaba com o propósito. Cada variante deve ser livre para jogar o layout fora.
- **Ligar variantes a mutações reais.** Protótipos só de leitura tudo bem. Se uma variante precisar alterar dados, aponte-a para um stub: a pergunta é "como isto deveria ficar", não "o backend funciona".
- **Promover o protótipo direto para produção.** O código da variante foi escrito sob as restrições de protótipo (sem testes, tratamento de erro mínimo). Reescreva direito quando for incorporá-lo.
