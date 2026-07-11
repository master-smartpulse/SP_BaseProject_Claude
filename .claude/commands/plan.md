---
description: Executar o fluxo de planejamento de implementação usando o template de plano para gerar artefatos de design.
argument-hint: contexto técnico adicional para o plano (opcional)
allowed-tools: Bash, Read, Write, Edit, Glob
---

Leia `.claude/agents/plan.md` e adote a persona definida. O agente define as skills a carregar (backend-architect, security-reviewer, data-modeler, api-contract-designer e, condicionalmente, devops-delivery) — siga-o. Em seguida execute os passos abaixo.

Com os detalhes de implementação fornecidos como argumento, faça o seguinte:

1. Execute o script abaixo usando a ferramenta Bash a partir da raiz do repositório e interprete o JSON para obter FEATURE_SPEC, IMPL_PLAN, FEATURE_DIR, BRANCH e HAS_GIT. Todos os caminhos de arquivo devem ser absolutos.
   ```
   bash scripts/bash/setup-plan.sh --json
   ```
2. Leia e analise a especificação da feature para entender:
   - Requisitos da feature e user stories
   - Requisitos funcionais e não funcionais
   - Critérios de sucesso e de aceite
   - Restrições ou dependências técnicas mencionadas

   **Gate de esclarecimentos**: se a spec contiver `[PRECISA ESCLARECIMENTO]` de natureza de **produto** (escopo, permissões, retenção, UX), sugira rodar `/clarify` e aguarde — decisões de produto são do usuário, não da pesquisa técnica. Incógnitas puramente técnicas seguem para a Fase 0 (research).

3. **OBRIGATÓRIO** — Leia antes de qualquer decisão de plano:
   - `memory/constitution.md` — requisitos constitucionais
   - `docs/arquitetura.md` — decisões de arquitetura, padrões e restrições (sempre ler; caminho a partir da raiz do repo)

4. Execute o template do plano de implementação:
   - Carregue `templates/plan-template.md` (já copiado para o caminho IMPL_PLAN)
   - Defina o caminho de entrada como FEATURE_SPEC
   - Execute os passos 1-9 do "Fluxo de Execução (escopo do comando /plan)" do template
   - O template é autocontido e executável
   - Siga o tratamento de erros e as verificações de gate conforme especificado
   - Deixe o template guiar a geração de artefatos em FEATURE_DIR:
     - Fase 0 gera research.md
     - Fase 1 gera data-model.md, contracts/, quickstart.md
     - Fase 2 apenas descreve a abordagem de geração de tarefas — **não** criar tasks.md (responsabilidade do comando /tasks)
   - Incorpore os detalhes fornecidos pelo usuário nos argumentos no Contexto Técnico: $ARGUMENTS
   - Atualize o Rastreamento de Progresso ao concluir cada fase
   **IDIOMA**: Todos os artefatos gerados (research.md, data-model.md, quickstart.md, plan.md e contracts) devem ser escritos em **português (pt-BR)** — exceto, nos contracts, os paths de API e as propriedades JSON, que ficam em **inglês** (constitution, Regra Geral 5; descriptions em pt-BR).

5. Verifique se a execução foi concluída:
   - Confira se o Rastreamento de Progresso indica todas as fases concluídas
   - Garanta que todos os artefatos obrigatórios foram gerados
   - Confirme que não há estados ERROR na execução

6. **Checkpoint de aprovação**: informe os resultados (branch, artefatos gerados) com um resumo das **decisões de arquitetura** (stack, estrutura, contratos, riscos e desvios registrados) e **pergunte explicitamente se o usuário aprova o plano** antes de sugerir `/tasks`. Não inicie a próxima etapa sem aprovação.

**Gate**: antes de concluir, verifique o **Checklist obrigatório (gate)** definido em `.claude/agents/plan.md` — só reporte conclusão se todos os itens estiverem ok.

Use caminhos absolutos a partir da raiz do repositório em todas as operações de arquivo.
