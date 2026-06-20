# Diretrizes do Projeto

> **Fonte canônica:** `CLAUDE.md`. Este arquivo é um resumo para compatibilidade com outras ferramentas — em caso de divergência, vale o CLAUDE.md.

Este projeto usa **Spec-Driven Development** com workflow estruturado: especificar → planejar → gerar tarefas → implementar → revisar.

## Documentos obrigatórios

Antes de qualquer decisão de código ou arquitetura, leia:

- `memory/constitution.md` — Princípios fundamentais, governança e checklist de conformidade
- `docs/arquitetura.md` — Arquitetura técnica, padrões (Clean Architecture, Repository, Adapters) e convenções

## Workflow de desenvolvimento

| Etapa | Comando | Agente | Descrição |
|---|---|---|---|
| 1. Especificação de produto | `/specify` | specify (PO) | Transforma ideia em spec de produto |
| 2. Especificação técnica | `/specify-tech` | specify-tech | Bugs, melhorias, débito técnico |
| 3. Planejamento | `/plan` | plan (Arquiteto) | Gera plano, data-model, contracts, research |
| 4. Geração de tarefas | `/tasks` | tasks (QA/TL) | Quebra plano em tarefas TDD ordenadas |
| 5. Implementação | `/implement` | implement (Dev) | Executa tasks com qualidade de produção |
| 6. Revisão | `/review` | review (Auditor) | Valida código contra constitution e arquitetura |
| Design de UI | `/specify-design` | — (skill) | Direção visual e implementação de UI (Interface ou Frontend) |
| Governança | `/constitution` | — | Cria ou atualiza a constituição do projeto |

## Agentes disponíveis

Cada agente está em `.claude/agents/{nome}.md`:

- **specify** — Product Owner: transforma ideias em specs de produto
- **plan** — Arquiteto: gera plano, data-model, contracts, research
- **tasks** — QA/Tech Lead: quebra plano em tarefas TDD ordenadas
- **implement** — Dev especialista: executa tasks com qualidade de produção
- **specify-tech** — Especificador técnico: bugs, melhorias, débito técnico
- **review** — Auditor de conformidade: valida código contra constitution e arquitetura (read-only)

Os gates de cada etapa vivem nos agentes (fonte única); tech-expert e specify-design são skills.

## Skills disponíveis

Cada skill está em `.claude/skills/{nome}/SKILL.md`:

- **product-spec-writer** — Especificação focada em produto e valor de negócio
- **ux-design-reviewer** — Fluxos, acessibilidade, feedback, estados extremos
- **backend-architect** — Camadas, SOLID, contratos, consistência estrutural
- **security-reviewer** — Vulnerabilidades (OWASP), sanitização, auth/authz, sessão/JWT, rate limiting, segurança mobile, logging seguro
- **implementation-engineer** — Código backend aderente a padrões, tipagem forte, DI
- **frontend-engineer** — Frontend web React/TypeScript: estado, data-fetching, formulários, performance de UI (carregada apenas quando a feature tem frontend web)
- **mobile-engineer** — Mobile React Native/Expo: navegação, armazenamento seguro, offline, permissões (carregada apenas quando a feature tem mobile)
- **test-designer** — TDD, testes AAA, integração, E2E (Playwright/Maestro), edge cases, mocks
- **refactor-specialist** — Simplificação, nomes, duplicação, complexidade
- **performance-concurrency-analyst** — N+1, async/await, event loop, memória; performance web e mobile
- **tech-expert** — Orientação técnica de alto nível: padrões, DDD, Clean Code, Well-Architected (consultada pelo /specify-tech)
- **specify-design** — Design de UI com triagem automática entre Interface (apps/dashboards) e Frontend (landings/marketing)

## Regras gerais

1. **Clean Architecture**: Controller → Service → UseCase → Repository
2. **TypeScript strict**: Sem `any`; tipos explícitos
3. **Repository Pattern**: Sem ORM direto fora de repositories
4. **TDD**: Testes antes da implementação
5. **Comentários essenciais apenas**: Código autoexplicativo
6. **Sem arquivos .md não solicitados**
7. **Idiomas**: Documentação, specs e mensagens ao usuário em pt-BR; código, comentários e commits em inglês (constitution, Regra Geral 5)
8. **Stack Padrão TypeScript**: NestJS/Prisma no backend, React na web, React Native/Expo no mobile — condicional por aplicação presente no projeto (constitution, Regra Geral 6)

## Estrutura de specs

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
