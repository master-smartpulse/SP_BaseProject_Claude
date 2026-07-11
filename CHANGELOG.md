# Changelog do Kit

Registro de mudanças do template-base (versionamento semântico; tag `v{VERSION}` a cada release).
Projetos derivados: use `scripts/bash/update-from-base.sh` para sincronizar os arquivos do kit e leia as entradas abaixo para follow-ups manuais (emendas de constitution, novos comandos).

## 1.0.3 — 2026-07-11

- ShellCheck limpo (gate do CI que passou a ser obrigatório na 1.0.2): SC2155 (declare/assign separados em 17 pontos — exit codes não são mais mascarados sob `set -e`), SC2043 e SC2034 resolvidos
- Merge do conteúdo remoto de docs/layout (protótipos adicionados por outro colaborador)

## 1.0.2 — 2026-07-11

Correções da re-auditoria das dimensões pendentes (28 achados verificados, vários reproduzidos em sandbox).

### Bugs
- init-project.sh ancorava a raiz via git e operava no repo errado quando o kit estava aninhado — agora ancora no próprio script, com aviso de repo externo
- update-from-base.sh apagava `.claude/settings.local.*` e customizações locais via `rsync --delete` — agora preserva settings.local.*, documenta o efeito, tem trap de cleanup e avisa quando `--ref` é ignorado com source local
- pre-bash-guard: fecha o bypass `git -C/-c ... commit|push` e elimina falsos positivos de substring (regex ancorada em posição de comando)
- ci.yml: instala sem `--frozen-lockfile` quando não há pnpm-lock.yaml (com warning); corepack respeita `packageManager`; fallback de typecheck não baixa TS da rede; shellcheck instalado de fato (sem skip silencioso)
- Hooks referenciados via `$CLAUDE_PROJECT_DIR` (funcionam com qualquer cwd); post-edit-format resolve package.json pela raiz do projeto
- run-tests.sh: isola git config global/system do runner; sumário sempre impresso via trap; bits de execução dos 6 scripts novos corrigidos (755)

### Consistência
- Constitution v1.5.1: barrels/validação/checklist condicionam use-cases/ à Dispensa; item de CI no Checklist de Conformidade; gatilho de atualização classifica /taskstoissues e /constitution (listas alinhadas nos 3 documentos)
- README: passo de cópia inclui .github/, VERSION, CHANGELOG e LICENSE; instalação do Claude Code antes do dia-1; deny list de .env exata (+ .env.test); update "por padrão" + --include-claude-md documentado
- /specify-tech documenta o modo --update; plan-template exemplifica Node 22/TS 5.5+; openapi-template com ErrorResponse nos 401; cabeçalho do update-from-base lista VERSION
- docs/arquitetura.md: sem hipótese de "nomes em português no domínio"; exemplo EmailModule com premissa de ConfigModule global; rodapé atualizado
- init-project.sh com saída uniformizada em inglês

### Testes
- Novos: transliteração em locale C, branch de feature nasce da main (merge-base), SPECIFY_PUSH sem origin, smoke de init-project e update-from-base em --dry-run

## 1.0.1 — 2026-07-11

Correções da segunda auditoria (35 achados verificados sobre a v1.0.0).

### Bugs e regressões
- Mini-review do implement citava fases antigas (Testes/Núcleo/Integração) — agora Fundação e cada User Story
- Transliteração de branch robusta a ambientes sem locale UTF-8 (CI Linux): `utf8_locale()` força C.UTF-8/en_US.UTF-8 quando disponível (+ teste dedicado)
- ci.yml: flags `--if-present` do pnpm na posição correta; typecheck com fallback explícito para `npx tsc --noEmit`
- allowed-tools: `Task` adicionado a /implement e /specify-tech (despacho de subagents estava bloqueado); `Glob` no /constitution; `Bash` removido do ux-design-reviewer

### Consistência
- Description do agente review agora permite o despacho como mini-review pelo implement (com prompt do subagent especificado: só reporta, não grava)
- --update implementado também no create-tech-spec.sh (helper `reuse_feature_scaffold` compartilhado)
- Rastreabilidade estendida a specs técnicas: CA-xxx aceito na mecânica de cobertura do tasks-template e no gate do agente tasks (que agora exige task de teste por requisito + tabela)
- spec-template com múltiplas user stories (US1, US2… — uma fase por história); spec-template-tech documenta /clarify
- /specify e /specify-tech e /tasks delegam a lista de skills ao agente (fim da dupla fonte); ux-design-reviewer condicional a UI
- /review passo 8 reestruturado (ramos REPROVADO/APROVADO); template anota que mini-reviews não gravam
- /plan: "Rastreamento de Progresso" (nome real da seção) e exceção de inglês para paths/JSON dos contracts
- Checklist de [P] do tasks-template esclarece que ordenação entre fases não conta como bloqueio; checkpoints apontam para o cenário da história
- IMPLEMENTATION_STATUS: coluna "Feature" (antes duplicava "Spec"); README lista VERSION entre os arquivos sincronizados
- mobile-engineer inclui validação de parâmetros de deep link (fecha a referência da fonte única citada pelo security-reviewer)

### Melhorias nos agentes
- implement: dono do commit definido (subagents [P] não commitam), limite de 2 tentativas no mini-review, despacho do debugger em falhas sem causa clara, sugere /review ao concluir
- specify-tech: skills condicionais por categoria (security-reviewer, performance-concurrency-analyst, data-modeler); checkpoint sugere /clarify
- review: carrega api-contract-designer/data-modeler quando o diff toca contratos/schema; enumeração do relatório inclui Cobertura de Requisitos
- /clarify: caminho explícito para "zero ambiguidades" (não inventa perguntas); /taskstoissues: label `correcoes` + protocolo de falha parcial
- backend-architect declara fronteiras com data-modeler/api-contract-designer; tech-expert com allowed-tools; api-contract-designer valida OpenAPI via redocly quando disponível

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
