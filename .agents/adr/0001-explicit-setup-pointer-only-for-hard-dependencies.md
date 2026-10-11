# Ponteiro explícito para `/setup-matt-pocock-skills` só nas dependências rígidas

As skills de engenharia dependem de uma configuração por repositório (issue tracker, vocabulário de labels de triagem, estrutura dos documentos de domínio) criada pela `/setup-matt-pocock-skills`. Algumas skills não conseguem funcionar de forma útil sem essa configuração: elas precisam publicar num issue tracker específico ou aplicar uma string de label específica. Outras só a usam para afiar a saída (vocabulário, atenção aos ADRs) e funcionam bem, só que um pouco pior, sem ela.

Separamos essas skills em **dependência rígida** e **dependência branda**:

- **Dependência rígida** (`to-tickets`, `to-spec`, `triage`): incluem um aviso explícito de uma linha: _"… já deve ter sido fornecido a você; se não, rode `/setup-matt-pocock-skills`."_ Sem o mapeamento, a saída fica errada, não só imprecisa.
- **Dependência branda** (`diagnose`, `tdd`, `improve-codebase-architecture`): mencionam "o glossário de domínio do projeto" e "os ADRs da área que você está mexendo" só em texto genérico. Se os documentos não estiverem lá, a skill funciona mesmo assim; a saída só fica menos afiada.

A separação mantém as skills de dependência branda leves em tokens e evita copiar o ponteiro de setup por imitação para lugares onde ele não sustenta nada.
