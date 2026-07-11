# Claude Code Setup — Kit de configuração reutilizável

Esta pasta contém um **kit de setup** para usar o **Claude Code** com fluxo de especificação, planejamento e implementação em qualquer projeto. Os arquivos são genéricos (sem nome de produto ou domínio específico) e podem ser adaptados ao seu repositório.

## Stack de ferramentas

- **Editor**: VS Code
- **AI**: Claude Code (CLI)

## Conteúdo

- **`CLAUDE.md`** — Instruções permanentes para o Claude Code (regras, workflow, skills, roteamento)
- **`AGENTS.md`** — Ponteiro de compatibilidade para outras ferramentas (fonte canônica: CLAUDE.md; não duplica tabelas)
- **`.claude/commands/`** — 11 slash commands (specify, clarify, specify-tech, plan, tasks, analyze, implement, review, constitution, specify-design, taskstoissues)
- **`.claude/agents/`** — 7 agentes especializados (specify, specify-tech, plan, tasks, implement, review, debugger), cada um com o gate da sua etapa
- **`.claude/skills/`** — 15 skills com checklists de qualidade aplicados pelos agentes (3 condicionais: frontend, mobile, devops)
- **`specs/`** — Pasta de especificações por feature (Spec-Driven Development)
- **`docs/arquitetura.md`** — Documento de arquitetura genérico (Clean Architecture, Repository, Adapters, convenções)
- **`memory/constitution.md`** — Constituição do projeto (princípios, governança, checklist)
- **`FEATURE_LIST.md`** — Wiki de features (vazio / "não iniciado")
- **`IMPLEMENTATION_STATUS.md`** — Tabela spec × completude (vazio / "não iniciado")
- **`templates/`** — Templates usados pelos comandos (spec, spec-tech, plan, research, tasks, review, data-model, quickstart, contrato OpenAPI)
- **`scripts/`** — Scripts bash usados pelos comandos + hooks + auto-testes do kit (requer bash; no Windows, use WSL ou Git Bash)
- **`.github/workflows/ci.yml`** — CI: valida os scripts do kit e, quando houver `package.json`, roda lint/typecheck/testes/build do projeto
- **`VERSION` / `CHANGELOG.md`** — Versão do kit e histórico de mudanças (base do fluxo de update)
- **`LICENSE`** — MIT

## Como usar

1. **Copie o conteúdo** para a **raiz do seu repositório**:
   - `CLAUDE.md` e `AGENTS.md` → raiz do repo
   - `.claude/` → raiz do repo
   - `.vscode/` → raiz do repo (merge com `.vscode/` existente se houver)
   - `.gitignore` → raiz do repo (merge com o `.gitignore` existente se houver)
   - `specs/` → raiz do repo
   - `templates/` → raiz do repo (**obrigatório** — os scripts dependem dela)
   - `scripts/` → raiz do repo
   - `docs/` → raiz do repo (merge com `docs/` existente se houver)
   - `memory/` → raiz do repo (merge com `memory/` existente se houver)
   - `FEATURE_LIST.md` e `IMPLEMENTATION_STATUS.md` → raiz do repo

2. **Inicialize o git** se o repositório ainda não for git (`git init`): os comandos criam um branch por feature. Sem git, os scripts funcionam em modo degradado (sem branches e sem lista de arquivos alterados no `/review`).

   Variáveis de ambiente opcionais dos scripts:
   - `SPECIFY_FEATURE={###-nome-da-feature}` — aponta os scripts para uma feature específica quando você não está no branch dela (ex.: `main` ou detached HEAD)
   - `SPECIFY_FETCH=1` — faz `git fetch` antes de numerar uma nova feature, para considerar branches remotos de outros devs (por padrão a numeração usa apenas `specs/` e branches locais, sem acesso à rede)
   - `SPECIFY_PUSH=1` — publica a branch da feature no origin ao criá-la, para que a numeração dos outros devs a enxergue

   **Limitação em times**: a numeração de features só enxerga branches publicadas. Sem `SPECIFY_PUSH=1` (+ `SPECIFY_FETCH=1` nos demais devs), dois devs podem gerar o mesmo número simultaneamente — resolva renomeando uma das branches/diretórios antes do merge.

   Hooks do Claude Code (`.claude/settings.json` + `scripts/bash/hooks/`): bloqueiam `git commit`/`git push` direto na `main` (crie uma branch de feature) e formatam arquivos editados com Prettier quando o projeto o tiver configurado. A leitura de arquivos `.env` reais é negada por permissão (`.env.example` continua acessível). Remova ou ajuste em `.claude/settings.json` se não quiser esses comportamentos.

3. **Dia-1 — bootstrap e adaptação** (nesta ordem):
   1. Rode `bash scripts/bash/init-project.sh` — verifica a integridade da cópia, inicializa o git se faltar, limpa `specs/` e remove arquivos que só pertencem ao repo do template
   2. Numa sessão Claude Code, rode **`/constitution`** — preencha a Visão Geral do Produto, "Ratificada em" e ajuste princípios (o comando propaga as mudanças aos templates e docs dependentes)
   3. Ajuste `docs/arquitetura.md` com o nome do produto, stack e convenções do seu time (remova as seções de aplicações que o projeto não tiver — ex.: Mobile num projeto só web)
   4. Rode `/specify "descrição da primeira feature"` e siga o workflow

4. **Instale o Claude Code** se ainda não tiver:
   ```bash
   npm install -g @anthropic-ai/claude-code
   ```

5. **Use os comandos slash** dentro de uma sessão Claude Code:
   - `/specify "descrição da feature"` — Cria spec de produto
   - `/clarify` — Resolve ambiguidades da spec com perguntas ao usuário (entre /specify e /plan)
   - `/specify-tech "descrição do bug ou melhoria"` — Cria spec técnica (despacha o agente debugger quando a causa não está clara)
   - `/plan` — Gera plano de implementação
   - `/tasks` — Gera tasks.md ordenado
   - `/analyze` — Checa consistência spec × plan × tasks antes de implementar (somente leitura)
   - `/implement` — Executa implementação via tasks.md
   - `/review` — Revisa código contra constitution e arquitetura; gera `specs/{feature}/review.md` e, se reprovado, tasks corretivas
   - `/constitution` — Cria ou atualiza a constituição
   - `/specify-design "descrição da tela ou página"` — Direção visual e implementação de UI
   - `/taskstoissues` — Converte as tasks da feature em issues do GitHub (requer gh CLI)

## Workflow de desenvolvimento

```
/specify → (/clarify) → /plan → /tasks → (/analyze) → /implement → /review
                                                          ↑______________|
                                                       loop de correção (se reprovado)
```

| Etapa | Comando | Agente | Descrição |
|---|---|---|---|
| 1. Especificação de produto | `/specify` | specify (PO) | Transforma ideia em spec de produto (branch criada a partir da main) |
| 1b. Esclarecimentos (recomendado) | `/clarify` | — | Até 5 perguntas objetivas ao usuário; respostas registradas na spec |
| 2. Especificação técnica | `/specify-tech` | specify-tech (+ debugger) | Bugs, melhorias, débito técnico; debugger investiga causa raiz |
| 3. Planejamento | `/plan` | plan (Arquiteto) | Gera plano, data-model, contracts, research (gate: ambiguidade de produto → /clarify) |
| 4. Geração de tarefas | `/tasks` | tasks (QA/TL) | Tasks por user story, com TDD, rastreabilidade RF e checkpoints validáveis |
| 4b. Análise de consistência (recomendado) | `/analyze` | — | Cruza spec × plan × tasks antes de implementar (somente leitura) |
| 5. Implementação | `/implement` | implement (Dev) | Executa tasks com TDD, [P] em paralelo, mini-review por fase e commit por task |
| 6. Revisão | `/review` | review (Auditor) | Verificação executável + relatório em review.md + loop de correção |

### Agentes

Cada agente vive em `.claude/agents/{nome}.md`, é **invocado exclusivamente pelo seu comando** e contém o gate (checklist obrigatório) da etapa:

- **specify** (PO) · **specify-tech** (especificador técnico) · **plan** (arquiteto) · **tasks** (QA/TL) · **implement** (dev) · **review** (auditor read-only)
- **debugger** — investigador de causa raiz read-only: reproduz o bug, roda testes, usa git blame e devolve evidência (arquivo:linha); despachado pelo /specify-tech em `[PRECISA INVESTIGAÇÃO]`

### Garantias de qualidade do fluxo

- **Checkpoints humanos**: `/specify`, `/plan` e `/tasks` param e pedem sua aprovação antes de sugerir a próxima etapa — nada avança sozinho para o `/implement`
- **Gates executáveis**: o `/implement` e o `/review` **rodam** typecheck, lint e testes de verdade e citam a saída; falha = gate reprovado (não é checkbox declarativo)
- **Entrega incremental**: tasks organizadas por user story (fundação compartilhada → uma fase por história → polish), cada história fecha num checkpoint validável
- **Rastreabilidade**: toda task cita o requisito `(RF-xxx)`; tabela de Cobertura de Requisitos no tasks.md e no relatório de revisão — nenhum RF sem task de implementação e de teste
- **Loop de correção**: `/review` reprovado converte achados Crítico/Alto em tasks na fase "Correções" → `/implement Correções` → novo `/review`; aprovado = DoD cumprido e PR sugerido
- **Guardrails automatizados** (hooks): commit/push na main bloqueado; format-on-edit com Prettier (quando configurado); leitura de `.env` reais negada

## Estrutura gerada para cada feature

```
specs/{###-nome-da-feature}/
├── spec.md          — Especificação de produto (/specify)
├── spec-tech.md     — Especificação técnica (/specify-tech)
├── plan.md          — Plano de implementação (/plan)
├── research.md      — Pesquisa técnica (/plan)
├── data-model.md    — Modelo de dados (/plan)
├── quickstart.md    — Cenários de validação (/plan)
├── contracts/       — Contratos de API (/plan)
├── tasks.md         — Tarefas ordenadas (/tasks)
└── review.md        — Relatório de revisão (/review)
```

> `spec.md` e `spec-tech.md` são **alternativos**, nunca coexistem: `/specify` cria `{###-nome}/` com `spec.md`; `/specify-tech` cria diretório e branch próprios com sufixo `-tech` (ex.: `002-corrigir-sessao-tech/`) contendo `spec-tech.md`.

## Resumo de arquivos

| Onde colocar no repo | Origem neste kit |
|----------------------|------------------|
| `CLAUDE.md` | `CLAUDE.md` |
| `AGENTS.md` | `AGENTS.md` |
| `.claude/` | `.claude/` |
| `.vscode/` | `.vscode/` |
| `.gitignore` | `.gitignore` |
| `specs/` | `specs/` |
| `docs/arquitetura.md` | `docs/arquitetura.md` |
| `memory/constitution.md` | `memory/constitution.md` |
| `FEATURE_LIST.md` | `FEATURE_LIST.md` |
| `IMPLEMENTATION_STATUS.md` | `IMPLEMENTATION_STATUS.md` |
| `templates/` | `templates/` |
| `scripts/` | `scripts/` |
| `.github/` | `.github/` |
| `VERSION` e `CHANGELOG.md` | raiz |
| `LICENSE` | raiz (substitua pela licença do seu projeto se for fechado) |

## Versionamento do kit e updates

- O kit segue versionamento semântico: arquivo `VERSION` + entradas no `CHANGELOG.md` + tag `v{VERSION}` no repositório do template.
- Projetos derivados sincronizam os arquivos **do kit** (`.claude/`, `templates/`, `scripts/`, `AGENTS.md`, `VERSION`) com:
  ```bash
  bash scripts/bash/update-from-base.sh --source <path-ou-git-url-do-template> [--ref v1.0.0] [--dry-run]
  ```
  Arquivos do **projeto** (CLAUDE.md, constitution, docs, specs, FEATURE_LIST, IMPLEMENTATION_STATUS) nunca são tocados — leia o CHANGELOG do template para follow-ups manuais (ex.: emendas de constitution).

## MCP

O kit **não configura servidores MCP por padrão** — nenhum `.mcp.json` é incluído. Se o seu projeto precisar (ex.: Supabase, Playwright), adicione um `.mcp.json` na raiz do repo derivado e registre no `plan.md` quando uma feature depender de um servidor MCP específico.
