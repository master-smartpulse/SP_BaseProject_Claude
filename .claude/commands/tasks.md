---
description: Gerar um tasks.md acionável e ordenado por dependências para a feature com base nos artefatos de design disponíveis.
allowed-tools: Bash, Read, Write, Edit, Glob
---

Leia `.claude/agents/tasks.md` e adote a persona definida. Leia também `.claude/skills/test-designer/SKILL.md` e aplique seu checklist (cenário feliz, erro, mocks, edge cases nas tarefas de teste). Em seguida execute os passos abaixo.

Com o contexto fornecido como argumento, faça o seguinte:

1. Execute o script abaixo usando a ferramenta Bash a partir da raiz do repositório e interprete a lista FEATURE_DIR e AVAILABLE_DOCS. Todos os caminhos devem ser absolutos.
   ```
   bash scripts/bash/check-task-prerequisites.sh --json
   ```
2. Carregue e analise os documentos de design disponíveis (caminhos a partir de FEATURE_DIR ou saída do script):
   - **OBRIGATÓRIO**: Leia a **spec** da feature (ex.: spec.md no diretório da feature) para cruzar requisitos com as tasks.
   - **OBRIGATÓRIO**: Leia plan.md para stack e bibliotecas
   - SE EXISTIR: Leia data-model.md para entidades
   - SE EXISTIR: Leia contracts/ para endpoints da API
   - SE EXISTIR: Leia research.md para decisões técnicas
   - SE EXISTIR: Leia quickstart.md para cenários de teste

   Observação: Nem todos os projetos têm todos os documentos. Exemplo:
   - Ferramentas CLI podem não ter contracts/
   - Bibliotecas simples podem não precisar de data-model.md
   - Gere as tasks com base no que estiver disponível

3. Gere as tasks seguindo o template:
   - Use `templates/tasks-template.md` como base
   - Substitua as tasks de exemplo por tasks reais com base em:
     - **Tasks de setup**: Inicialização do projeto, dependências, lint
     - **Tasks de teste [P]**: Uma por contrato, uma por cenário de integração
     - **Tasks de núcleo**: Uma por entidade, serviço, comando CLI, endpoint
     - **Tasks de integração**: Conexões com DB, middleware, logging
     - **Tasks de polish [P]**: Testes unitários, performance, documentação

4. Regras de geração de tasks:
   - Cada arquivo de contrato → task de teste de contrato marcada [P]
   - Cada entidade no data-model → task de criação de modelo marcada [P]
   - Cada endpoint → task de implementação (não paralela se compartilhar arquivos)
   - Cada user story → teste de integração marcado [P]
   - Arquivos diferentes = pode ser paralelo [P]
   - Mesmo arquivo = sequencial (sem [P])

5. Ordene as tasks por dependências:
   - Setup antes de tudo
   - Testes antes da implementação (TDD)
   - Modelos antes de serviços
   - Serviços antes de endpoints
   - Núcleo antes de integração
   - Tudo antes de polish

6. Inclua exemplos de execução paralela:
   - Agrupe tasks [P] que podem rodar juntas
   - Mostre os comandos reais de execução paralela

7. Crie FEATURE_DIR/tasks.md com:
   - Nome correto da feature a partir do plano de implementação
   - Tasks numeradas (T001, T002, etc.)
   - Caminhos de arquivo claros para cada task
   - Notas de dependência
   - Orientação de execução paralela
   **IDIOMA**: O arquivo tasks.md e todas as descrições de tasks devem ser escritos em **português (pt-BR)**.

Contexto para geração de tasks: $ARGUMENTS

O tasks.md deve ser imediatamente executável — cada task deve ser específica o suficiente para ser concluída sem contexto adicional.

**Gate**: antes de concluir, verifique o **Checklist obrigatório (gate)** definido em `.claude/agents/tasks.md` — só reporte conclusão se todos os itens estiverem ok.

**Ao finalizar:** Atualize sempre `IMPLEMENTATION_STATUS.md` (tabela spec × completude) e `FEATURE_LIST.md` (wiki de features do produto). Princípio 8 da Constitution.
