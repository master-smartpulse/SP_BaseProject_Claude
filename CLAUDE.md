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
| 1b. Esclarecimentos (recomendado) | `/clarify` | — | Resolve ambiguidades da spec com o usuário |
| 2. Especificação técnica | `/specify-tech` | specify-tech (+ debugger) | Bugs, melhorias, débito técnico |
| 3. Planejamento | `/plan` | plan (Arquiteto) | Gera plano, data-model, contracts, research |
| 4. Geração de tarefas | `/tasks` | tasks (QA/TL) | Quebra plano em tarefas TDD ordenadas |
| 4b. Análise de consistência (recomendado) | `/analyze` | — | Valida spec × plan × tasks antes de implementar |
| 5. Implementação | `/implement` | implement (Dev) | Executa tasks com qualidade de produção |
| 6. Revisão | `/review` | review (Auditor) | Valida código, gera review.md e o loop de correção |

## Comandos disponíveis (slash commands)

Cada comando está em `.claude/commands/{nome}.md`:

- **`/specify`** — Cria spec de produto a partir de descrição em linguagem natural
- **`/clarify`** — Resolve ambiguidades da spec com perguntas objetivas ao usuário (entre /specify e /plan)
- **`/specify-tech`** — Cria spec técnica para bug, melhoria ou refatoração
- **`/plan`** — Gera plano de implementação com artefatos de design
- **`/tasks`** — Gera tasks.md ordenado por dependências
- **`/analyze`** — Checa consistência spec × plan × tasks antes do /implement (somente leitura)
- **`/implement`** — Executa o plano de implementação via tasks.md
- **`/review`** — Revisa código e artefatos contra constitution e arquitetura; gera specs/{feature}/review.md e o loop de correção
- **`/constitution`** — Cria ou atualiza a constituição do projeto
- **`/specify-design`** — Desenha ou implementa UI com triagem automática entre Interface (dashboards, SaaS) e Frontend (landings, marketing)
- **`/taskstoissues`** — Converte as tasks da feature em issues do GitHub via gh CLI (rastreabilidade externa; requer aprovação antes de criar)

## Agentes disponíveis

Cada agente está em `.claude/agents/{nome}.md`:

- **specify** — Product Owner: transforma ideias em specs de produto
- **plan** — Arquiteto: gera plano, data-model, contracts, research
- **tasks** — QA/Tech Lead: quebra plano em tarefas TDD ordenadas
- **implement** — Dev especialista: executa tasks com qualidade de produção
- **specify-tech** — Especificador técnico: bugs, melhorias, débito técnico
- **review** — Auditor de conformidade: valida código contra constitution e arquitetura (read-only)
- **debugger** — Investigador de causa raiz (read-only): reproduz bugs e devolve evidência; despachado pelo specify-tech em [PRECISA INVESTIGAÇÃO] e disponível ao /implement

Cada agente contém o **Checklist obrigatório (gate)** da sua etapa — fonte única de verdade; os comandos apenas referenciam. O design de UI (`/specify-design`) e o tech-expert vivem como skills, não como agentes — o gate do `/specify-design` vive na própria skill.

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
- **data-modeler** — Modelagem Prisma/PostgreSQL: relações, índices justificados, migrations, soft/hard delete (carregada pelo /plan)
- **api-contract-designer** — Contratos REST/OpenAPI: verbos/status, erro único, paginação, idempotência (carregada pelo /plan)
- **devops-delivery** — CI, Docker, configuração tipada, logs estruturados, health checks, migrations no deploy (condicional: features de infraestrutura)
- **tech-expert** — Orientação técnica de alto nível: padrões, DDD, Clean Code, Well-Architected (consultada pelo /specify-tech)
- **specify-design** — Design de UI com triagem automática entre Interface (apps/dashboards) e Frontend (landings/marketing)

## Categorização e Roteamento

Antes de executar qualquer pedido, classifique-o e aplique o agente/skill correspondente.

### Workflow de Feature (comandos slash)

| Pedido do usuário | Comando | Agente | Skills |
|---|---|---|---|
| Nova feature, ideia de produto, user story | `/specify` | specify | product-spec-writer, ux-design-reviewer |
| Resolver ambiguidades/[PRECISA ESCLARECIMENTO] da spec | `/clarify` | — | — |
| Checar consistência spec × plan × tasks antes de implementar | `/analyze` | — | — |
| Investigar bug sem causa clara, reproduzir falha | (via /specify-tech) | debugger | — |
| Planejar implementação, arquitetura de feature | `/plan` | plan | backend-architect, security-reviewer, data-modeler, api-contract-designer (+ devops-delivery se tocar infra) |
| Gerar tarefas, quebrar trabalho | `/tasks` | tasks | test-designer |
| Implementar, codar, executar tasks | `/implement` | implement | implementation-engineer, test-designer (+ frontend-engineer se a feature tiver frontend web; + mobile-engineer se tiver mobile) |
| Bug, melhoria técnica, refatoração, débito técnico | `/specify-tech` | specify-tech | tech-expert |
| Atualizar constituição, princípios | `/constitution` | — | — |
| Revisar código, validar regras, auditoria | `/review` | review | backend-architect, security-reviewer, test-designer, performance-concurrency-analyst (+ frontend-engineer se houver código web; + mobile-engineer se houver código mobile; + devops-delivery se houver infra) |
| Desenhar UI, propor direção visual, implementar tela/landing/dashboard | `/specify-design` | — | specify-design, ux-design-reviewer |
| Criar issues no GitHub a partir das tasks | `/taskstoissues` | — | — |

### Pedidos diretos (sem comando)

| Tipo de pedido | Skill a aplicar |
|---|---|
| Implementar código backend, criar módulo, endpoint | **implementation-engineer** |
| Implementar tela/componente web (React, Next.js, Vite) | **frontend-engineer** |
| Implementar tela/feature de app mobile (React Native, Expo) | **mobile-engineer** |
| Revisar ou desenhar arquitetura, camadas (código deste projeto) | **backend-architect** |
| Escrever ou revisar testes | **test-designer** |
| Revisar segurança, validação, auth | **security-reviewer** |
| Analisar performance, async, N+1 | **performance-concurrency-analyst** |
| Refatorar, simplificar, limpar código | **refactor-specialist** |
| Modelar dados, schema Prisma, índices, migrations | **data-modeler** |
| Desenhar/padronizar contratos de API, endpoints | **api-contract-designer** |
| CI/CD, Docker, deploy, observabilidade, configuração | **devops-delivery** |
| Especificar feature, user story, produto | **product-spec-writer** |
| UX, fluxos, acessibilidade, design | **ux-design-reviewer** |
| Desenhar UI, criar tela/landing/dashboard, direção visual | **specify-design** |
| Dúvida conceitual: padrões, DDD, boas práticas (sem desenhar código deste projeto) | **tech-expert** |

Ao identificar a categoria, leia a skill correspondente em `.claude/skills/{skill-name}/SKILL.md` e aplique seu checklist.

**Regra condicional por plataforma**: as skills `frontend-engineer` e `mobile-engineer` são carregadas **apenas quando a feature envolve a respectiva plataforma** (conforme o Tipo de Projeto no plan.md ou o pedido do usuário), e `devops-delivery` apenas quando a feature toca infraestrutura/pipeline/deploy. Projetos apenas web nunca carregam mobile-engineer, e vice-versa — isso evita contexto desperdiçado com checklists de áreas que a feature não possui.

## Guardrails Permanentes

Estas regras aplicam-se a **toda** interação, independentemente do comando:

1. **Clean Architecture**: Controller → Service → UseCase → Repository. Sem bypass de camadas. CRUD trivial pode dispensar o UseCase conforme a regra de dispensa do Princípio 1 da constitution.
2. **Sem `any`**: TypeScript strict. Tipos explícitos sempre; `unknown` se necessário; `any` apenas com justificativa documentada.
3. **Repository Pattern**: Todo acesso a dados via Repository. Sem ORM/Prisma direto em services ou controllers.
4. **Dependências injetadas**: Constructor injection. Sem `new` de colaboradores dentro de services/use cases.
5. **Controller limpo**: Apenas HTTP, validação de DTO, chamada a service e mapeamento de resposta. Sem lógica de negócio.
6. **Comentários essenciais apenas**: Código autoexplicativo. Comentários só para "porquê" não óbvio.
7. **Sem arquivos .md não solicitados**: Não criar README, CHANGELOG ou documentação adicional sem pedido explícito.
8. **Idiomas**: Specs em `specs/` e comunicação com o usuário final (UI, mensagens de erro, documentação para stakeholders) em pt-BR. Todo o resto em inglês: código, comentários no código, commits, DTOs, paths de API, propriedades JSON e artefatos técnicos — inclusive paths e propriedades dos contratos OpenAPI em `specs/*/contracts/` (constitution, Regra Geral 5).
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
├── tasks.md         — Tarefas ordenadas (/tasks)
└── review.md        — Relatório de revisão (/review)
```

**Observações**:

- `spec.md` e `spec-tech.md` são **alternativos**, nunca coexistem: `/specify` cria `{###-nome}/` com `spec.md`; `/specify-tech` cria diretório e branch próprios com sufixo `-tech` (ex.: `002-corrigir-sessao-tech/`) contendo `spec-tech.md`.
- Fora de um branch de feature (ex.: `main` ou detached HEAD), exporte `SPECIFY_FEATURE={###-nome-da-feature}` antes de rodar `/plan`, `/tasks`, `/implement` ou `/review` para apontar os scripts para a feature desejada.
