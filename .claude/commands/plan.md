---
description: Executar o fluxo de planejamento de implementação usando o template de plano para gerar artefatos de design.
allowed-tools: Bash, Read, Write, Edit, Glob
---

Leia `.claude/agents/plan.md` e adote a persona definida. Leia também `.claude/skills/backend-architect/SKILL.md` e `.claude/skills/security-reviewer/SKILL.md` e aplique seus checklists (camadas, contratos, segurança no desenho). Em seguida execute os passos abaixo.

Com os detalhes de implementação fornecidos como argumento, faça o seguinte:

1. Execute o script abaixo usando a ferramenta Bash a partir da raiz do repositório e interprete o JSON para obter FEATURE_SPEC, IMPL_PLAN, SPECS_DIR, BRANCH. Todos os caminhos de arquivo devem ser absolutos.
   ```
   bash scripts/bash/setup-plan.sh --json
   ```
2. Leia e analise a especificação da feature para entender:
   - Requisitos da feature e user stories
   - Requisitos funcionais e não funcionais
   - Critérios de sucesso e de aceite
   - Restrições ou dependências técnicas mencionadas

3. **OBRIGATÓRIO** — Leia antes de qualquer decisão de plano:
   - `memory/constitution.md` — requisitos constitucionais
   - `docs/arquitetura.md` — decisões de arquitetura, padrões e restrições (sempre ler; caminho a partir da raiz do repo)

4. Execute o template do plano de implementação:
   - Carregue `templates/plan-template.md` (já copiado para o caminho IMPL_PLAN)
   - Defina o caminho de entrada como FEATURE_SPEC
   - Execute os passos 1-9 do "Fluxo de Execução (escopo do comando /plan)" do template
   - O template é autocontido e executável
   - Siga o tratamento de erros e as verificações de gate conforme especificado
   - Deixe o template guiar a geração de artefatos em $SPECS_DIR:
     - Fase 0 gera research.md
     - Fase 1 gera data-model.md, contracts/, quickstart.md
     - Fase 2 apenas descreve a abordagem de geração de tarefas — **não** criar tasks.md (responsabilidade do comando /tasks)
   - Incorpore os detalhes fornecidos pelo usuário nos argumentos no Contexto Técnico: $ARGUMENTS
   - Atualize o Acompanhamento de Progresso ao concluir cada fase
   **IDIOMA**: Todos os artefatos gerados (research.md, data-model.md, quickstart.md, plan.md e contracts) devem ser escritos em **português (pt-BR)**.

5. Verifique se a execução foi concluída:
   - Confira se o Acompanhamento de Progresso indica todas as fases concluídas
   - Garanta que todos os artefatos obrigatórios foram gerados
   - Confirme que não há estados ERROR na execução

6. Informe os resultados com nome do branch, caminhos dos arquivos e artefatos gerados.

7. **Ao finalizar:** Atualize sempre `IMPLEMENTATION_STATUS.md` (tabela spec × completude) e `FEATURE_LIST.md` (wiki de features do produto). Princípio 8 da Constitution.

**Gate**: antes de concluir, verifique o **Checklist obrigatório (gate)** definido em `.claude/agents/plan.md` — só reporte conclusão se todos os itens estiverem ok.

Use caminhos absolutos a partir da raiz do repositório em todas as operações de arquivo.
