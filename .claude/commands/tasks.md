---
description: Gerar um tasks.md acionável e ordenado por dependências para a feature com base nos artefatos de design disponíveis.
argument-hint: contexto adicional para a geração de tasks (opcional)
allowed-tools: Bash, Read, Write, Edit, Glob
---

Leia `.claude/agents/tasks.md` e adote a persona definida. O agente define as skills a carregar (test-designer, para os casos de teste das tarefas) — siga-o. Em seguida execute os passos abaixo.

Com o contexto fornecido como argumento, faça o seguinte:

1. Execute o script abaixo usando a ferramenta Bash a partir da raiz do repositório e interprete FEATURE_DIR e AVAILABLE_DOCS. Todos os caminhos devem ser absolutos.
   ```
   bash scripts/bash/check-task-prerequisites.sh --json
   ```
   **IMPORTANTE**: Execute o script apenas uma vez. O JSON é exibido no terminal — use-o para obter o conteúdo real.

2. Carregue e analise os documentos de design disponíveis (caminhos a partir de FEATURE_DIR ou saída do script):
   - **OBRIGATÓRIO**: spec da feature — para cruzar requisitos com as tasks
   - **OBRIGATÓRIO**: plan.md — stack, bibliotecas e estrutura
   - SE EXISTIR: data-model.md, contracts/, research.md, quickstart.md

   Observação: nem toda feature tem todos os documentos (ex.: ferramenta CLI sem contracts/; biblioteca simples sem data-model.md). Gere as tasks com base no que estiver disponível.

3. Crie FEATURE_DIR/tasks.md usando `templates/tasks-template.md` como base. As **regras de geração, ordenação por dependências, marcação [P] e o Checklist de Validação estão definidos no próprio template** (fonte única dessas regras) — execute o "Fluxo de Execução" do template do início ao fim, substituindo as tasks de exemplo por tasks reais da feature, com IDs (T001, T002…), caminhos de arquivo e casos de teste.
   **IDIOMA**: O arquivo tasks.md e todas as descrições de tasks devem ser escritos em **português (pt-BR)**.

Contexto para geração de tasks: $ARGUMENTS

O tasks.md deve ser imediatamente executável — cada task deve ser específica o suficiente para ser concluída sem contexto adicional.

**Gate**: antes de concluir, verifique o **Checklist obrigatório (gate)** definido em `.claude/agents/tasks.md` — só reporte conclusão se todos os itens estiverem ok.

**Checkpoint de aprovação (obrigatório)**: apresente um resumo do tasks.md (nº de tasks por fase, tabela de Cobertura de Requisitos, tasks [P]) e **pergunte explicitamente se o usuário aprova** antes de sugerir `/analyze` (recomendado) ou `/implement`. A implementação é a etapa de maior custo de reversão — nunca a inicie sem aprovação.
