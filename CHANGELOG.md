# Changelog do Kit

Registro de mudanças do template-base (versionamento semântico; tag `v{VERSION}` a cada release).
Projetos derivados: use `scripts/bash/update-from-base.sh` para sincronizar os arquivos do kit e leia as entradas abaixo para follow-ups manuais (emendas de constitution, novos comandos).

## 1.0.0 — 2026-07-11

Primeira versão versionada, consolidando a auditoria multi-agente e as 4 fases do roadmap de melhorias.

### Novos comandos e agentes
- `/clarify` — resolve ambiguidades da spec com o usuário (gate no /plan para ambiguidades de produto)
- `/analyze` — auditoria de consistência spec × plan × tasks antes do /implement (read-only)
- `/taskstoissues` — converte tasks.md em issues do GitHub via gh CLI
- Agente `debugger` — investigação de causa raiz read-only (despachado pelo /specify-tech)

### Novas skills
- `data-modeler`, `api-contract-designer`, `devops-delivery` (condicional para features de infra)

### Workflow
- Loop de correção: /review salva `specs/{feature}/review.md` e, se reprovado, apensa fase "Correções" ao tasks.md
- Gates com verificação executável (typecheck/lint/testes rodados de verdade) no /implement e /review
- Checkpoints de aprovação humana ao final de /specify, /plan e /tasks
- tasks.md reestruturado por user story (fundação + uma fase por história com checkpoint validável)
- Rastreabilidade RF → task → teste com tabela de Cobertura de Requisitos
- Mini-review por fase e execução paralela real de tasks [P] no /implement
- Fluxo git fechado: commit por task (Conventional Commits), PR sugerido no /review aprovado

### Constitution (v1.2.0 → v1.5.0)
- v1.3.0: `no-explicit-any` como error com exceção justificada
- v1.4.0: review.md sancionado; gatilho de atualização de FEATURE_LIST/IMPLEMENTATION_STATUS restrito; DoD operacional
- v1.5.0: dispensa do UseCase para CRUD trivial; entidades = modelos Prisma + types/; testes obrigatórios no CI; TDD por história

### Infraestrutura do kit
- Hooks: bloqueio de commit/push na main; format-on-edit com Prettier; deny de leitura de `.env` reais
- Scripts: transliteração pt-BR em nomes de branch, JSON escapado, `set -euo pipefail`, helpers compartilhados, backup de plan.md, `--update`, branch a partir da main, `SPECIFY_FEATURE`/`SPECIFY_FETCH`/`SPECIFY_PUSH`
- Bootstrap `init-project.sh`, atualização `update-from-base.sh`, suíte de auto-teste `scripts/tests/run-tests.sh`, CI em `.github/workflows/ci.yml`
- Arquitetura: regra de dispensa do UseCase, contrato compartilhado via openapi-typescript, autenticação/sessão especificada, pipeline HTTP NestJS, decisões de engenharia (pnpm, Node ≥22, TS ≥5.5, packages/shared), exemplos de Adapter/DI
- LICENSE (MIT), VERSION, CHANGELOG
