# Roadmap de Melhorias — Base Project Claude (Spec-Kit)

**Data da análise:** 2026-07-10
**Método:** análise multi-agente em 6 dimensões (agentes/fluxo, skills, templates/scripts, governança/stack, consistência cruzada, workflow/produto vs. spec-kit upstream) com verificação adversarial de cada achado — 85 achados confirmados, 2 refutados e descartados.
**Escopo:** este documento é o backlog priorizado. **Status:** ✅ ROADMAP COMPLETO — Fases 1–4 aplicadas e validadas em 2026-07-11 (74 itens; suíte de auto-teste do kit: 30/30). Exceções registradas nos itens: /converge adiado (4.22), digests descartados por decisão (4.20).

---

## Sumário executivo

O kit é sólido: gates por etapa, skills com checklists acionáveis, condicionalidade por plataforma bem resolvida, scripts com degradação sem git. Os problemas concentram-se em 4 eixos:

1. **Duplicação** comando × agente × template que contradiz a promessa de "fonte única de verdade";
2. **Gates autodeclarados** — nenhum gate exige execução real de lint/typecheck/testes;
3. **Fluxo sem fechamento** — review reprovado não tem loop de correção; branch de feature nunca é commitada/fechada;
4. **Ausências vs. upstream** — `/clarify`, `/analyze`, bootstrap/init, versionamento do kit.

| Fase | Tema | Itens | Esforço |
|------|------|-------|---------|
| 1 | Correções mecânicas e consistência (quick wins) | 23 | Baixo — 1 sessão |
| 2 | Desduplicação e arquitetura do kit | 16 | Médio |
| 3 | Fechamento dos loops do workflow | 13 | Médio/Alto |
| 4 | Stack, arquitetura e produto do kit | 22 | Alto — incremental |

---

## Fase 1 — Correções mecânicas e consistência (quick wins)

> Correções seguras, sem mudança de design. Podem ser feitas em uma única sessão.

### Templates

- [x] **1.1 Contradição de `[P]` no tasks-template** — T008 e T009 são ambos `[P]`, mas "Dependências" declara "T008 bloqueia T009". Corrigir o exemplo (remover `[P]` de T009 ou usar entidades independentes) e adicionar ao Checklist de Validação: "nenhuma task listada como bloqueada pode ter [P]". `templates/tasks-template.md`
- [x] **1.2 Testes de contrato na Fase 1 do plan-template** — o plan manda "gerar testes de contrato" na Fase 1, mas comando, agente e tasks-template estabelecem que testes nascem no fluxo `/tasks → /implement`. Rebaixar para "especificar os casos de teste que o /tasks transformará em tarefas". `templates/plan-template.md`
- [x] **1.3 Numeração de fases conflitante** — plan-template diz "Fase 3 = execução de tarefas" e "Fase 4 = implementação"; tasks-template usa "Fase 3.1–3.5" para implementação. Unificar: Fase 3 = geração de tasks, Fase 4 = implementação (ou nomes sem número no tasks-template). `templates/plan-template.md`, `templates/tasks-template.md`
- [x] **1.4 Placeholder divergente** — spec-template-tech usa `[###-nome-do-branch]`; todos os demais usam `[###-nome-da-feature]`. Padronizar. `templates/spec-template-tech.md`
- [x] **1.5 openapi-template desatualizado** — migrar para `openapi: 3.1.0`, adicionar `components.securitySchemes` (bearerAuth JWT) referenciado pela resposta 401, incluir exemplo de GET com paginação e respostas 404/500. `templates/openapi-template.yaml`
- [x] **1.6 Criar `research-template.md`** — único artefato do /plan sem template (cabeçalho + seção por incógnita: Decisão, Justificativa, Alternativas, Referências) e referenciá-lo na Fase 0 do plan-template. `templates/`

### Scripts bash

- [x] **1.7 Guarda no setup-plan.sh** — hoje o `cp` incondicional sobrescreve `plan.md` preenchido ao reexecutar /plan. Criar backup (`plan.md.bak`) + aviso em stderr. Renomear a chave JSON `SPECS_DIR` (que carrega FEATURE_DIR) para `FEATURE_DIR`, atualizando `.claude/commands/plan.md` em conjunto; incluir HAS_GIT na saída texto. `scripts/bash/setup-plan.sh`
- [x] **1.8 Transliteração de acentos em branch** — "Autenticação de Usuários" vira `autentica-o-de-usu-rios`. Inserir `iconv -f UTF-8 -t ASCII//TRANSLIT 2>/dev/null || cat` antes da limpeza em `clean_branch_name` e `generate_branch_name`. `scripts/bash/common.sh`, `create-new-feature.sh`
- [x] **1.9 Escape de JSON** — criar `json_escape()` em common.sh (escapar `\` e `"`) e aplicar a todo valor interpolado; usar `git -c core.quotepath=false` em diff/ls-files para nomes UTF-8 crus. `scripts/bash/*.sh`
- [x] **1.10 `set -euo pipefail`** nos 6 scripts (atenção: bash 3.2 do macOS exige o idiom `${arr[@]+"${arr[@]}"}` em arrays possivelmente vazios). `scripts/bash/*.sh`
- [x] **1.11 `eval $(get_feature_paths)` quebra com apóstrofo no caminho** — escapar com `printf %q` ou eliminar o eval definindo as variáveis como globais. `scripts/bash/common.sh` e consumidores
- [x] **1.12 `git fetch --all --prune` como efeito colateral oculto** ao numerar features — remover do caminho padrão ou tornar opt-in via `SPECIFY_FETCH=1` documentada. `scripts/bash/common.sh`
- [x] **1.13 AVAILABLE_DOCS omite plan.md** no check-task-prerequisites (o /tasks o declara obrigatório) — adicionar `[[ -f "$IMPL_PLAN" ]] && docs+=("plan.md")` + check_file na saída texto. `scripts/bash/check-task-prerequisites.sh`
- [x] **1.14 Comentários em pt-BR no common.sh** violam a Regra Geral 5 do próprio template — traduzir para inglês. `scripts/bash/common.sh`
- [x] **1.15 Documentar `SPECIFY_FEATURE`** — a variável de override existe mas não aparece em nenhuma mensagem de erro nem doc. Ampliar a mensagem de `check_feature_branch` com a dica e documentar nos comandos/CLAUDE.md. `scripts/bash/common.sh`, `CLAUDE.md`

### Referências cruzadas

- [x] **1.16 `/constitution` procura tokens que não existem** — o comando espera `[IDENTIFICADOR_EM_MAIÚSCULAS]`, mas a constitution v1.2.0 já está preenchida sem tokens. Reescrever os passos 1–2 para operar sobre o arquivo concreto (emendas, bump de versão, seções "(a definir)"). `.claude/commands/constitution.md`
- [x] **1.17 Gate do agente tasks usa "FR-XXX"** mas o spec-template define "RF-XXX" — corrigir o prefixo para a verificação de cobertura funcionar. `.claude/agents/tasks.md`
- [x] **1.18 Agente plan cita estados "ERROR/WARN/SUCCESS"** que não existem no plan-template (que usa "ERRO", "Fase 0/1/2", "Rastreamento de Progresso") — alinhar nomenclatura. `.claude/agents/plan.md`
- [x] **1.19 Roteamento do /specify-design promete ux-design-reviewer** na tabela do CLAUDE.md, mas o comando não a carrega — adicionar a leitura da skill ao comando ou corrigir a tabela. `.claude/commands/specify-design.md`, `CLAUDE.md`
- [x] **1.20 Sufixo `-tech` não documentado** — /specify-tech cria `###-nome-tech` com spec-tech.md, mas o diagrama "Estrutura de specs" sugere spec.md e spec-tech.md coexistindo no mesmo diretório. Documentar que são alternativos. `CLAUDE.md`, `README.md`, `AGENTS.md`
- [x] **1.21 Deriva de idioma Guardrail 8 × Regra Geral 5** — "Documentação em pt-BR" vs "artefatos técnicos em inglês". Reescrever o guardrail espelhando exatamente a Regra Geral 5, citando `contracts/` como exceção em inglês dentro de `specs/`. `CLAUDE.md`
- [x] **1.22 "Sem any" contraditório** — guardrail proíbe, mas a validação do Princípio 2 aceita `warning`. Elevar para `error` com exceção via `eslint-disable-next-line` + justificativa. `memory/constitution.md`
- [x] **1.23 Higiene de arquivos auxiliares** — `.gitignore`: adicionar `playwright-report/`, `test-results/`, `*.tsbuildinfo`, `.turbo/`, `.idea/`. `extensions.json`: remover TS nightly, adicionar Playwright (e Expo comentado). `README`: incluir `.vscode/` e `.gitignore` nas instruções de cópia. `.gitignore`, `.vscode/extensions.json`, `README.md`

---

## Fase 2 — Desduplicação e arquitetura do kit

> Um dono por tipo de conteúdo; eliminar os caminhos duplos que geram deriva.

### Comandos × agentes

- [x] **2.1 Duplo caminho de invocação** — comandos mandam "adotar a persona" na thread principal, mas as descriptions dos agentes convidam à auto-delegação como subagent; os agentes não conhecem seus scripts (specify não cita create-new-feature.sh etc.). Auto-delegação geraria spec fora da convenção de branch/diretório. Escolher um modelo: (a) agentes autocontidos com scripts + comandos como gatilhos de delegação, ou (b) descriptions com "Invocado exclusivamente pelo comando /X". `.claude/agents/*`, `.claude/commands/*`
  **Decisão registrada (2026-07-11): opção (b)** — comandos permanecem o caminho oficial; as descriptions dos 6 agentes declaram "invocado exclusivamente pelo comando /X" e citam o script da etapa, bloqueando auto-delegação fora da convenção.
- [x] **2.2 Regras triplicadas de tasks e implement** — regras de geração ("cada contrato → task [P]") vivem em comando + agente + template; ordem de fases e marcação `[X]` em comando + agente; skills condicionais em CLAUDE.md + comando + agente. Definir dono: regras de geração só no template, fases/gate só no agente, comando só orquestra (script + artefatos + referência ao gate). `.claude/commands/tasks.md`, `.claude/agents/tasks.md`, `templates/tasks-template.md`, idem implement
- [x] **2.3 Checklists do /review duplicados em 3 artefatos** — inclusive o critério de aprovação (zero Crítico + zero Alto) repetido. Checklists detalhados só no agente (ou nas skills), formato e critério de aprovação só no template, comando só orquestra. `.claude/commands/review.md`, `.claude/agents/review.md`, `templates/review-template.md`
- [x] **2.4 Review "read-only" contraditório** — agente declara `tools: Bash, Read, Grep, Glob` (Bash irrestrito permite escrita), enquanto o comando tem `Write, Edit` e o passo 9 exige escrever em IMPLEMENTATION_STATUS/FEATURE_LIST (impossível para o subagent). Decidir quem escreve o quê; restringir Bash a comandos de leitura via permissions/hooks. `.claude/agents/review.md`, `.claude/commands/review.md`, `.claude/settings.json`
- [x] **2.5 Gate do /specify-design mora no comando** — quebra o padrão "gate mora no agente/skill". Mover o gate para a SKILL.md e reduzir o comando a triagem + $ARGUMENTS + referência ao gate. `.claude/commands/specify-design.md`, `.claude/skills/specify-design/SKILL.md`
- [x] **2.6 Campo `model` por agente** — nenhum agente define modelo; escolher deliberadamente por papel (maior raciocínio para plan/review; mais barato para etapas mecânicas) ou documentar `model: inherit`. `.claude/agents/*`
- [x] **2.7 `argument-hint` + escopo via `$ARGUMENTS`** — adicionar argument-hint a todos os comandos; /implement e /review devem aceitar argumentos (retomar de task X, revisar arquivos específicos). `.claude/commands/*`
- [x] **2.8 AGENTS.md divergente do CLAUDE.md** que diz espelhar (tabelas com linhas diferentes) — ou reduzir a um ponteiro curto, ou sincronizar as tabelas (10 regras, mesma ordem). `AGENTS.md`, `CLAUDE.md`
  **Decisão registrada (2026-07-11): ponteiro compacto** — AGENTS.md reescrito sem tabelas duplicadas (workflow em uma linha, digest de guardrails com remissão ao CLAUDE.md como fonte vinculante), eliminando o custo de sincronização.

### Scripts

- [x] **2.9 Duplicação massiva nos scripts** — parsing de argumentos idêntico nos 2 `create-*`; bloco de serialização JSON repetido nos 3 `check-*`; drift já existente (aviso de git presente num create e ausente no outro). Extrair para common.sh: `parse_create_args()`, `json_array()`, `create_feature_scaffold()`. `scripts/bash/*`

### Skills

- [x] **2.10 tech-expert sem checklist** (única das 12; contradiz o CLAUDE.md) e com name-dropping sem frameworks de decisão — adicionar checklist verificável (causa raiz/hipóteses, referência citada, ≥1 alternativa com trade-offs, conformidade checada) e critérios concretos (quando introduzir fila/cache/CQRS vs manter CRUD). `.claude/skills/tech-expert/SKILL.md`
- [x] **2.11 Frontmatter fora do padrão** — description do tech-expert sem 3ª pessoa/cláusula de exclusão; test-designer sem "nunca para..." na description. `.claude/skills/tech-expert`, `.claude/skills/test-designer`
- [x] **2.12 `allowed-tools` nas skills analíticas** — security-reviewer, performance-concurrency-analyst, backend-architect, ux-design-reviewer declaram-se read-only apenas em prosa. Adicionar frontmatter `allowed-tools`. `.claude/skills/*`
- [x] **2.13 Fronteira backend-architect × tech-expert** ambígua no termo "arquitetura" — regra explícita nas duas skills + refinar tabela de roteamento: "dúvida conceitual → tech-expert; desenho/revisão do código deste repo → backend-architect". `CLAUDE.md`, skills
- [x] **2.14 Regras mobile triplicadas** (mobile-engineer, security-reviewer, performance-analyst) sem fonte única — replicar o padrão do backend: regra completa no mobile-engineer, demais referenciam. `.claude/skills/*`
- [x] **2.15 specify-design: references duplicam o SKILL.md** — principles.md repete quase toda a seção 3 (deveria estender); validation.md mistura dois assuntos (memória + validação) e o índice descreve só metade. Enxugar SKILL.md para resumos + ponteiros; dividir/renomear validation.md. `.claude/skills/specify-design/`
- [x] **2.16 Padronizar formato das 12 skills** — template único (Papel / Responsabilidades / Checklist / tabela de foco / O que não faz / Estilo de saída), idioma dos títulos uniforme; tornar verificáveis os itens vagos de ux-design-reviewer ("toda tela tem tabela de estados") e product-spec-writer ("≥2 benchmarks nomeados ou ausência justificada"). `.claude/skills/*`

---

## Fase 3 — Fechamento dos loops do workflow

> As mudanças de maior impacto no resultado das features geradas pelo kit.

- [x] **3.1 Criar `/clarify`** ⭐ (único achado de impacto ALTO) — varre a spec ativa, formula até N perguntas objetivas com opções ao usuário, grava respostas em `## Esclarecimentos` no spec.md e remove os marcadores. Tornar o /plan um gate: `[PRECISA ESCLARECIMENTO]` de produto → sugerir /clarify em vez de decidir via research. `.claude/commands/clarify.md` (novo)
- [x] **3.2 Criar `/analyze`** — agente read-only (Read, Grep, Glob) entre /tasks e /implement: cruza spec × plan × tasks e reporta requisito sem task, task órfã, contrato divergente do data-model, violação de constitution — com severidades, no padrão do review-template. `.claude/commands/analyze.md` (novo)
- [x] **3.3 Persistir o relatório do /review + loop de correção** — definir destino explícito (`specs/{feature}/review.md`, exceção sancionada ao Guardrail 7; adicionar à "Estrutura de specs"); criar fluxo de correção: comando `/fix` que converte achados Crítico/Alto em tasks corretivas apensadas ao tasks.md (fase "Correções"), ou /implement aceitar review.md como entrada. `.claude/commands/review.md`, `CLAUDE.md`
- [x] **3.4 Gates com execução real** — (a) gate do /implement e do /review passa a exigir rodar e reportar `tsc --noEmit` + lint + testes (falha = gate reprovado, não checkbox); (b) hooks de exemplo no settings.json: PostToolUse em Edit|Write rodando typecheck/format no arquivo; (c) o /review executa lint/typecheck/test via Bash e cola os resultados no relatório. `.claude/agents/implement.md`, `.claude/agents/review.md`, `.claude/settings.json`
- [x] **3.5 Checkpoint humano entre etapas** — ao final de /specify, /plan e /tasks: apresentar resumo das decisões e pedir aprovação antes de sugerir o próximo comando — no mínimo antes do /implement (maior custo de reversão). `.claude/commands/*`
- [x] **3.6 Review incremental por fase do /implement** — despachar o agente review sobre o diff de cada fase (3.2 Testes, 3.3 Núcleo, 3.4 Integração), bloqueando avanço em achados Críticos; o review passa a aceitar lista de arquivos como entrada (resolve também o caso CHANGED_FILES vazio). `.claude/commands/implement.md`
- [x] **3.7 Mecanismo real para `[P]`** — instruir o /implement a despachar lotes [P] como subagents paralelos (isolamento por propriedade de arquivo, consolidação antes da próxima fase); atualizar o "Exemplo de Paralelo" do template para o mecanismo real. `.claude/commands/implement.md`, `templates/tasks-template.md`
- [x] **3.8 Rastreabilidade por IDs** — formato de task `[T00x] [P?] (RF-xxx)`; tabela "Cobertura de Requisitos" (RF × tasks × testes) no tasks-template com gate "nenhum RF sem task e sem teste"; seção de cobertura por requisito no review-template. `templates/tasks-template.md`, `templates/review-template.md`
- [x] **3.9 Gate do implementation-engineer exige TDD e suíte verde** — adicionar: "testes correspondentes existem e passam", "tsc --noEmit sem erros", "lint sem erros". `.claude/skills/implementation-engineer/SKILL.md`
- [x] **3.10 Evidência executável nos checklists de análise** — security: `npm audit` sem altas/críticas não triadas; performance: log de queries do Prisma no hotspot analisado; test-designer: citar a evidência red→green. `.claude/skills/*`
- [x] **3.11 DoD operacional para IMPLEMENTATION_STATUS** — fórmula determinística (% = tasks [X]/total) + colunas discretas (Spec✓/Plan✓/Tasks✓/Impl✓/Review APROVADO); DoD: 100% tasks + review aprovado + gates executados. Restringir o gatilho de atualização aos comandos que mudam estado real (hoje /tasks também é obrigado a atualizar) e incluir /specify-design; considerar fundir FEATURE_LIST + IMPLEMENTATION_STATUS num único PRODUCT_STATUS.md ou derivar o % por script. `IMPLEMENTATION_STATUS.md`, `memory/constitution.md`, comandos
  **Decisão registrada (2026-07-11):** mantidos os dois arquivos (papéis distintos: wiki de produto × status operacional); a fusão foi descartada. Fórmula determinística + DoD + gatilho restrito implementados (constitution v1.4.0, Princípio 8). Derivar % por script fica como melhoria futura opcional.
- [x] **3.12 Novo agente `debugger`** — `[PRECISA INVESTIGAÇÃO]` não tem dono: agente read-only (Bash, Read, Grep, Glob) invocado pelo /specify-tech que reproduz o bug, roda testes, inspeciona logs/git blame e devolve evidência de causa raiz. `.claude/agents/debugger.md` (novo)
- [x] **3.13 Endurecer settings.json** — hook PreToolUse bloqueando `git commit/push` na main; `permissions.deny` para `Read(.env*)`; format-on-edit; manter allow atual. `.claude/settings.json`

---

## Fase 4 — Stack, arquitetura e produto do kit

> Decisões de stack que faltam, exemplos idiomáticos e o kit como produto distribuível.

### Stack e arquitetura

- [x] **4.1 Regra de dispensa Service × UseCase** — as duas camadas obrigatórias sem exceção não são idiomáticas em NestJS (CRUD trivial = 4 camadas + barrels + IUseCase). Documentar: "CRUD trivial pode fluir Controller → Service → Repository; UseCase obrigatório quando há regra de negócio composta ou reuso entre entrypoints". Ajustar Guardrail 1 e Princípio 1 com a mesma redação. `docs/arquitetura.md`, `memory/constitution.md`, `CLAUDE.md`
- [x] **4.2 Estratégia de contrato compartilhado** — validação dividida (class-validator no back, Zod no front) sem mecanismo para o "reuso de tipos" da Regra Geral 6. Decidir e registrar: gerar tipos do cliente via openapi-typescript a partir do Swagger, ou Zod ponta a ponta via nestjs-zod + pacote shared. `docs/arquitetura.md`
  **Decisão registrada (2026-07-11):** class-validator no backend (idiomático NestJS) + tipos dos clientes gerados via `openapi-typescript` a partir do Swagger; Zod ponta a ponta via nestjs-zod registrado como desvio permitido via plan.md.
- [x] **4.3 Autenticação subespecificada** — sem estratégia de refresh token no backend e sem regra de armazenamento no front web (espelhar o rigor do mobile): cookie httpOnly+SameSite ou token em memória + refresh explícito. Referenciar no checklist do security-reviewer. `docs/arquitetura.md`, `.claude/skills/security-reviewer/SKILL.md`
- [x] **4.4 Decisões de engenharia ausentes** — package manager (pnpm workspaces como padrão), tooling de monorepo (turborepo opcional), engines mínimas (Node LTS, TS ≥5.x), pacote `packages/shared` para tipos/schemas. `memory/constitution.md` (Regra Geral 6) ou `docs/arquitetura.md`
- [x] **4.5 Camada "Models" fantasma** — listada no Princípio 1 mas ausente da estrutura de módulo e da validação. Ou adicionar `models/`/`entities/` à estrutura, ou remover da lista declarando que Prisma + types/ cumprem o papel. `memory/constitution.md`, `docs/arquitetura.md`
- [x] **4.6 Exemplos NestJS idiomáticos na arquitetura** — adapter completo (interface + token Symbol + provider useFactory por env + @Inject), binding de repository por token, e subseção "Pipeline HTTP" (ValidationPipe global com whitelist, guards, exception filters). `docs/arquitetura.md`
- [x] **4.7 CI/CD e pre-commit exigidos mas inexistentes** — a constitution exige pipeline e Husky que o kit não traz. Adicionar `.github/workflows/ci.yml` mínimo comentado (lint, tsc --noEmit, test, build) + passo de setup Husky/lint-staged no README, marcados como opcionais de adoção; alinhar a redação do Princípio 7 (incluir "testes" na validação). `.github/` (novo), `README.md`, `memory/constitution.md`

### Novas skills

- [x] **4.8 Skill `data-modeler`** — o /plan produz data-model.md sem skill de modelagem: chaves e índices justificados por query prevista, migrations aditivas/reversíveis, soft vs hard delete, enums Prisma vs domínio, relações que evitam N+1 por design. Carregada pelo agente plan. `.claude/skills/data-modeler/` (novo)
- [x] **4.9 Skill `api-contract-designer`** — contracts/ sem gate próprio: verbos/status corretos, formato de erro único, paginação/ordenação padronizadas, idempotência, OpenAPI válido. Carregada pelo agente plan. `.claude/skills/api-contract-designer/` (novo)
- [x] **4.10 Skill `devops-delivery`** (condicional) — CI com typecheck+lint+test, Dockerfile multi-stage, envs via ConfigModule, logs estruturados com correlation id, health/readiness. Carregada no /plan e /review quando a feature tocar infraestrutura. `.claude/skills/devops-delivery/` (novo)
- [x] **4.11 Migrations no fluxo** — stack declara Prisma mas migrations não existem em nenhum agente/comando/template: toda entidade nova/alterada gera decisão de migration no plan e task na fase de Integração; o review checa "schema alterado sem migration". `templates/data-model-template.md`, `templates/tasks-template.md`, `.claude/agents/review.md`

### Kit como produto

- [x] **4.12 Bootstrap/init** — onboarding hoje é cópia manual de 10 itens (upstream tem `specify init`). Criar `scripts/bash/init-project.sh`: limpa specs/ e histórico do template, pergunta nome/aplicações, preenche placeholders (constitution, FEATURE_LIST, STATUS), grava "Ratificada em", remove seções de plataformas ausentes. `scripts/bash/` (novo), `README.md`
- [x] **4.13 Roteiro dia-1 no README** — (1) bootstrap, (2) rodar /constitution para preencher placeholders e data, (3) ajustar arquitetura, (4) /specify da primeira feature. Refletir no CLAUDE.md. `README.md`
- [x] **4.14 Versionamento do kit + canal de update** — arquivo VERSION + CHANGELOG do template + git tags + `scripts/bash/update-from-base.sh` que sincroniza apenas os arquivos do kit (.claude/, templates/, scripts/, AGENTS.md), preservando constitution/specs/docs do derivado. raiz, `scripts/bash/`
- [x] **4.15 Fluxo git com fechamento** — nenhuma etapa commita, abre PR ou faz merge da branch de feature. Definir: /implement commita por task (Conventional Commits), /review aprovado sugere/abre PR via `gh`; documentar o ciclo completo. `.claude/commands/implement.md`, `.claude/commands/review.md`, `README.md`
- [x] **4.16 Colisão de numeração em times** — `next_feature_number` só enxerga branches publicadas; como nada faz push, dois devs geram o mesmo número. Push da branch ao criar (opt-in) ou documentar a limitação + resolução de conflito. `scripts/bash/common.sh`
- [x] **4.17 `/specify --update` e branch a partir de main** — o comando promete "criar ou atualizar" mas sempre cria; a branch nasce da branch atual (pode ramificar de outra feature). Detectar branch de feature atual e oferecer modo update; criar branches novas a partir de main. `scripts/bash/create-new-feature.sh`, `.claude/commands/specify.md`
- [x] **4.18 tasks por user story** (upstream migrou) — Fase de fundação compartilhada + um bloco por US (testes → implementação → checkpoint validável), mantendo TDD por bloco. Reduz risco do /implement estourar contexto antes de valor verificável. `templates/tasks-template.md`
- [x] **4.19 O kit não testa a si mesmo** — 7 scripts bash sem shellcheck/bats/CI. Adicionar shellcheck + testes bats mínimos + workflow de CI do próprio template. `scripts/`, `.github/`
- [x] **4.20 Custo de contexto (~70KB por comando)** — /review carrega constitution + arquitetura + CLAUDE.md + agente + comando + 4–6 skills. Considerar digests/@imports e mover detalhes para leitura sob demanda. `CLAUDE.md`, docs
  **Decisão registrada (2026-07-11): sem digests.** A desduplicação das Fases 2–3 já enxugou comandos e checklists (fonte única por conteúdo + skills condicionais); criar digests reintroduziria exatamente a fonte dupla eliminada. As leituras obrigatórias restantes são necessárias para a qualidade — custo aceito conscientemente.
- [x] **4.21 Política MCP ausente** — sem `.mcp.json` nem menção; definir política (ex.: nenhum servidor por padrão + seção no README sobre como adicionar). raiz, `README.md`
- [x] **4.22 LICENSE + comandos opcionais do upstream** — adicionar LICENSE (kit feito para ser copiado); avaliar `/taskstoissues` (via gh CLI, rastreabilidade externa) e um `/converge` simplificado para brownfield (inventaria código existente, preenche FEATURE_LIST retroativamente, gera spec-tech de gaps). raiz, `.claude/commands/`
  **Decisão registrada (2026-07-11):** LICENSE (MIT) e `/taskstoissues` implementados. `/converge` **adiado** para backlog futuro — comando grande e especulativo; implementar quando houver um caso real de adoção brownfield para calibrar.

---

## Apêndice — Achados refutados na verificação (descartados)

| Achado | Motivo da refutação |
|--------|---------------------|
| "Falta gate para `[PRECISA ESCLARECIMENTO]`" | O plan-template já bloqueia com ERRO se restar marcador (o gap real é o `/clarify` interativo — item 3.1) |
| "references/ do specify-design não cobre o modo Frontend" | A seção 4 do SKILL.md já contém a galeria de tons e diretrizes essenciais do modo Frontend |

---

**Como usar este roadmap:** as fases são incrementais mas independentes — a Fase 1 inteira é segura para aplicar de uma vez; nas demais, cada item é autocontido. Marcar os checkboxes conforme aplicado e registrar desvios de decisão (ex.: escolher (a) ou (b) nos itens com alternativas) neste próprio arquivo.
