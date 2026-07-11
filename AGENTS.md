# Diretrizes do Projeto

> **Fonte canônica: `CLAUDE.md`** — leia-o para o conteúdo completo e vinculante (workflow, comandos, agentes, skills, roteamento e guardrails). Este arquivo é apenas um ponteiro de compatibilidade para outras ferramentas; ele não duplica tabelas para não divergir da fonte.

Este projeto usa **Spec-Driven Development**:

```
/specify (ou /specify-tech) → (/clarify) → /plan → /tasks → (/analyze) → /implement → /review
```

Comandos auxiliares: `/constitution` (governança) e `/specify-design` (UI). Se o `/review` reprovar, ele apensa tasks corretivas ao tasks.md (fase "Correções") e o ciclo é `/implement Correções` → novo `/review`.

## Antes de qualquer decisão de código ou arquitetura, leia

1. `CLAUDE.md` — regras de trabalho, roteamento de agentes/skills e Guardrails Permanentes
2. `memory/constitution.md` — princípios, regras gerais e checklist de conformidade
3. `docs/arquitetura.md` — arquitetura técnica e convenções (Clean Architecture, Repository, Adapters)

## Resumo mínimo dos guardrails

Lista completa e vinculante em `CLAUDE.md` (seção "Guardrails Permanentes"):

- Clean Architecture: Controller → Service → UseCase → Repository, sem bypass
- TypeScript strict, sem `any`; Repository Pattern (sem ORM direto fora de repositories)
- TDD: testes antes da implementação correspondente
- Specs em `specs/` e comunicação com usuário final em pt-BR; todo o resto (código, comentários, commits, artefatos técnicos) em inglês
- Stack Padrão TypeScript: NestJS/Prisma (backend), React (web), React Native/Expo (mobile) — condicional por aplicação presente; desvios justificados no plan.md
- Sem arquivos .md não solicitados; comentários apenas quando essenciais

## Estrutura de specs

Cada feature vive em `specs/{###-nome-da-feature}/` (detalhes e artefatos por comando no `CLAUDE.md`, seção "Estrutura de specs"). `spec.md` e `spec-tech.md` são alternativos: `/specify-tech` cria diretório e branch próprios com sufixo `-tech`.
