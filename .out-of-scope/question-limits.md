# Limite rígido de perguntas durante a sabatina

A skill `/grill-me` (e as sessões de sabatina dentro de outras skills) não impõe um número máximo de perguntas. Pedidos para adicionar um teto configurável ou um limite rígido estão fora do escopo.

## Por que isto está fora do escopo

A sabatina é aberta de propósito. A ideia é continuar cavando até cada ramo da árvore de decisões estar resolvido: alguns planos precisam de três perguntas, outros de cinquenta. Um teto fixo cortaria uma exploração útil em problemas difíceis ou pareceria arbitrário nos fáceis.

Se uma sessão parecer longa demais, as saídas certas já existem:

- O usuário pode parar a sessão a qualquer momento e aceitar o estado atual do plano.
- O usuário pode pedir ao modelo para fechar, resumir e seguir em frente, já que direcionar em linguagem natural é o controle pretendido, não um limite numérico.

Um teto rígido também misturaria dois modos de falha diferentes: um modelo que faz perguntas demais porque o plano está realmente subespecificado (funcionando como deveria) vs. um modelo que faz perguntas redundantes ou de pouco valor (um problema de qualidade do prompt, não de quantidade). A correção para o segundo caso pertence ao prompt da skill, não a um contador.

## Pedidos anteriores

- #44: "Codex just asked me 200 questions"
