# Instruções do Projeto

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

## Comandos disponíveis (slash commands)

Cada comando está em `.claude/commands/{nome}.md`:

- **`/specify`** — Cria spec de produto a partir de descrição em linguagem natural
- **`/specify-tech`** — Cria spec técnica para bug, melhoria ou refatoração
- **`/plan`** — Gera plano de implementação com artefatos de design
- **`/tasks`** — Gera tasks.md ordenado por dependências
- **`/implement`** — Executa o plano de implementação via tasks.md
- **`/review`** — Revisa código e artefatos contra constitution e arquitetura
- **`/constitution`** — Cria ou atualiza a constituição do projeto
- **`/specify-design`** — Desenha ou implementa UI com triagem automática entre Interface (dashboards, SaaS) e Frontend (landings, marketing)

## Agentes disponíveis

Cada agente está em `.claude/agents/{nome}.md`:

- **specify** — Product Owner: transforma ideias em specs de produto
- **plan** — Arquiteto: gera plano, data-model, contracts, research
- **tasks** — QA/Tech Lead: quebra plano em tarefas TDD ordenadas
- **implement** — Dev especialista: executa tasks com qualidade de produção
- **specify-tech** — Especificador técnico: bugs, melhorias, débito técnico
- **review** — Auditor de conformidade: valida código contra constitution e arquitetura (read-only)

Cada agente contém o **Checklist obrigatório (gate)** da sua etapa — fonte única de verdade; os comandos apenas referenciam. O design de UI (`/specify-design`) e o tech-expert vivem como skills, não como agentes.

## Skills disponíveis

Cada skill está em `.claude/skills/{nome}/SKILL.md`:

- **product-spec-writer** — Especificação focada em produto e valor de negócio
- **ux-design-reviewer** — Fluxos, acessibilidade, feedback, estados extremos
- **backend-architect** — Camadas, SOLID, contratos, consistência estrutural
- **security-reviewer** — Vulnerabilidades (OWASP), sanitização, auth/authz, sessão/JWT, rate limiting, segurança mobile, logging seguro
- **implementation-engineer** — Código backend aderente a padrões, tipagem forte, DI
- **frontend-engineer** — Frontend web React/TypeScript: estado, data-fetching, formulários, performance de UI
- **mobile-engineer** — Mobile React Native/Expo: navegação, armazenamento seguro, offline, permissões
- **test-designer** — TDD, testes AAA, integração, E2E (Playwright/Maestro), edge cases, mocks
- **refactor-specialist** — Simplificação, nomes, duplicação, complexidade
- **performance-concurrency-analyst** — N+1, async/await, event loop, memória; performance web (re-renders, CWV) e mobile (listas, UI thread)
- **tech-expert** — Orientação técnica de alto nível: padrões, DDD, Clean Code, Well-Architected (consultada pelo /specify-tech)
- **specify-design** — Design de UI com triagem automática entre Interface (apps/dashboards) e Frontend (landings/marketing)

## Categorização e Roteamento

Antes de executar qualquer pedido, classifique-o e aplique o agente/skill correspondente.

### Workflow de Feature (comandos slash)

| Pedido do usuário | Comando | Agente | Skills |
|---|---|---|---|
| Nova feature, ideia de produto, user story | `/specify` | specify | product-spec-writer, ux-design-reviewer |
| Planejar implementação, arquitetura de feature | `/plan` | plan | backend-architect, security-reviewer |
| Gerar tarefas, quebrar trabalho | `/tasks` | tasks | test-designer |
| Implementar, codar, executar tasks | `/implement` | implement | implementation-engineer, test-designer (+ frontend-engineer se a feature tiver frontend web; + mobile-engineer se tiver mobile) |
| Bug, melhoria técnica, refatoração, débito técnico | `/specify-tech` | specify-tech | tech-expert |
| Atualizar constituição, princípios | `/constitution` | — | — |
| Revisar código, validar regras, auditoria | `/review` | review | backend-architect, security-reviewer, test-designer, performance-concurrency-analyst (+ frontend-engineer se houver código web; + mobile-engineer se houver código mobile) |
| Desenhar UI, propor direção visual, implementar tela/landing/dashboard | `/specify-design` | — | specify-design, ux-design-reviewer |

### Pedidos diretos (sem comando)

| Tipo de pedido | Skill a aplicar |
|---|---|
| Implementar código backend, criar módulo, endpoint | **implementation-engineer** |
| Implementar tela/componente web (React, Next.js, Vite) | **frontend-engineer** |
| Implementar tela/feature de app mobile (React Native, Expo) | **mobile-engineer** |
| Revisar ou desenhar arquitetura, camadas | **backend-architect** |
| Escrever ou revisar testes | **test-designer** |
| Revisar segurança, validação, auth | **security-reviewer** |
| Analisar performance, async, N+1 | **performance-concurrency-analyst** |
| Refatorar, simplificar, limpar código | **refactor-specialist** |
| Especificar feature, user story, produto | **product-spec-writer** |
| UX, fluxos, acessibilidade, design | **ux-design-reviewer** |
| Desenhar UI, criar tela/landing/dashboard, direção visual | **specify-design** |
| Dúvida técnica, padrão, arquitetura, DDD | **tech-expert** |

Ao identificar a categoria, leia a skill correspondente em `.claude/skills/{skill-name}/SKILL.md` e aplique seu checklist.

**Regra condicional por plataforma**: as skills `frontend-engineer` e `mobile-engineer` são carregadas **apenas quando a feature envolve a respectiva plataforma** (conforme o Tipo de Projeto no plan.md ou o pedido do usuário). Projetos apenas web nunca carregam mobile-engineer, e vice-versa — isso evita contexto desperdiçado com checklists de plataformas que o projeto não possui.

## Guardrails Permanentes

Estas regras aplicam-se a **toda** interação, independentemente do comando:

1. **Clean Architecture**: Controller → Service → UseCase → Repository. Sem bypass de camadas.
2. **Sem `any`**: TypeScript strict. Tipos explícitos sempre; `unknown` se necessário; `any` apenas com justificativa documentada.
3. **Repository Pattern**: Todo acesso a dados via Repository. Sem ORM/Prisma direto em services ou controllers.
4. **Dependências injetadas**: Constructor injection. Sem `new` de colaboradores dentro de services/use cases.
5. **Controller limpo**: Apenas HTTP, validação de DTO, chamada a service e mapeamento de resposta. Sem lógica de negócio.
6. **Comentários essenciais apenas**: Código autoexplicativo. Comentários só para "porquê" não óbvio.
7. **Sem arquivos .md não solicitados**: Não criar README, CHANGELOG ou documentação adicional sem pedido explícito.
8. **Idiomas**: Documentação, specs e mensagens ao usuário final em português (pt-BR). Código, comentários no código, commits e artefatos técnicos em inglês (conforme constitution, Regra Geral 5).
9. **TDD**: Testes escritos antes da implementação correspondente (constitution, Princípio 5).
10. **Stack Padrão TypeScript**: NestJS/Prisma no backend, React na web, React Native/Expo no mobile — condicional por aplicação presente no projeto; desvios justificados no plan.md (constitution, Regra Geral 6).

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
