# Claude Code Setup — Kit de configuração reutilizável

Esta pasta contém um **kit de setup** para usar o **Claude Code** com fluxo de especificação, planejamento e implementação em qualquer projeto. Os arquivos são genéricos (sem nome de produto ou domínio específico) e podem ser adaptados ao seu repositório.

## Stack de ferramentas

- **Editor**: VS Code
- **AI**: Claude Code (CLI)

## Conteúdo

- **`CLAUDE.md`** — Instruções permanentes para o Claude Code (regras, workflow, skills, roteamento)
- **`AGENTS.md`** — Resumo das diretrizes para compatibilidade com outras ferramentas (fonte canônica: CLAUDE.md)
- **`.claude/commands/`** — Slash commands do Claude Code (specify, specify-tech, plan, tasks, implement, review, constitution, specify-design)
- **`.claude/agents/`** — Personas de agentes especializados carregados pelos comandos
- **`.claude/skills/`** — Skills com checklists de qualidade aplicados pelos agentes
- **`specs/`** — Pasta de especificações por feature (Spec-Driven Development)
- **`docs/arquitetura.md`** — Documento de arquitetura genérico (Clean Architecture, Repository, Adapters, convenções)
- **`memory/constitution.md`** — Constituição do projeto (princípios, governança, checklist)
- **`FEATURE_LIST.md`** — Wiki de features (vazio / "não iniciado")
- **`IMPLEMENTATION_STATUS.md`** — Tabela spec × completude (vazio / "não iniciado")
- **`templates/`** — Templates usados pelos comandos (spec, spec-tech, plan, tasks, review, data-model, quickstart, contrato OpenAPI)
- **`scripts/`** — Scripts bash usados pelos comandos (requer bash; no Windows, use WSL ou Git Bash)

## Como usar

1. **Copie o conteúdo** para a **raiz do seu repositório**:
   - `CLAUDE.md` e `AGENTS.md` → raiz do repo
   - `.claude/` → raiz do repo
   - `specs/` → raiz do repo
   - `templates/` → raiz do repo (**obrigatório** — os scripts dependem dela)
   - `scripts/` → raiz do repo
   - `docs/` → raiz do repo (merge com `docs/` existente se houver)
   - `memory/` → raiz do repo (merge com `memory/` existente se houver)
   - `FEATURE_LIST.md` e `IMPLEMENTATION_STATUS.md` → raiz do repo

2. **Inicialize o git** se o repositório ainda não for git (`git init`): os comandos criam um branch por feature. Sem git, os scripts funcionam em modo degradado (sem branches e sem lista de arquivos alterados no `/review`).

3. **Adapte** ao seu projeto:
   - Preencha a seção "Visão Geral do Produto" em `memory/constitution.md` e as descrições de produto em `FEATURE_LIST.md` e `IMPLEMENTATION_STATUS.md`
   - Ajuste `docs/arquitetura.md` com o nome do produto, stack e convenções do seu time (remova as seções de aplicações que o projeto não tiver — ex.: Mobile num projeto só web)
   - Preencha "Ratificada em" em `memory/constitution.md` ao adotar a constituição

4. **Instale o Claude Code** se ainda não tiver:
   ```bash
   npm install -g @anthropic-ai/claude-code
   ```

5. **Use os comandos slash** dentro de uma sessão Claude Code:
   - `/specify "descrição da feature"` — Cria spec de produto
   - `/specify-tech "descrição do bug ou melhoria"` — Cria spec técnica
   - `/plan` — Gera plano de implementação
   - `/tasks` — Gera tasks.md ordenado
   - `/implement` — Executa implementação via tasks.md
   - `/review` — Revisa código contra constitution e arquitetura
   - `/constitution` — Cria ou atualiza a constituição
   - `/specify-design "descrição da tela ou página"` — Direção visual e implementação de UI

## Workflow de desenvolvimento

```
/specify → /plan → /tasks → /implement → /review
```

| Etapa | Comando | Agente | Descrição |
|---|---|---|---|
| 1. Especificação de produto | `/specify` | specify (PO) | Transforma ideia em spec de produto |
| 2. Especificação técnica | `/specify-tech` | specify-tech | Bugs, melhorias, débito técnico |
| 3. Planejamento | `/plan` | plan (Arquiteto) | Gera plano, data-model, contracts, research |
| 4. Geração de tarefas | `/tasks` | tasks (QA/TL) | Quebra plano em tarefas TDD ordenadas |
| 5. Implementação | `/implement` | implement (Dev) | Executa tasks com qualidade de produção |
| 6. Revisão | `/review` | review (Auditor) | Valida código contra constitution e arquitetura |

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
└── tasks.md         — Tarefas ordenadas (/tasks)
```

## Resumo de arquivos

| Onde colocar no repo | Origem neste kit |
|----------------------|------------------|
| `CLAUDE.md` | `CLAUDE.md` |
| `AGENTS.md` | `AGENTS.md` |
| `.claude/` | `.claude/` |
| `specs/` | `specs/` |
| `docs/arquitetura.md` | `docs/arquitetura.md` |
| `memory/constitution.md` | `memory/constitution.md` |
| `FEATURE_LIST.md` | `FEATURE_LIST.md` |
| `IMPLEMENTATION_STATUS.md` | `IMPLEMENTATION_STATUS.md` |
| `templates/` | `templates/` |
| `scripts/` | `scripts/` |
