---
name: devops-delivery
description: Garante que a feature seja entregável e operável — CI com typecheck/lint/testes, Docker multi-stage, configuração tipada, logs estruturados com correlation id, health checks e migrations no deploy. Use ao planejar ou revisar features que tocam infraestrutura, pipeline, deploy, observabilidade ou configuração — carregada condicionalmente pelo /plan e /review; nunca para implementar lógica de negócio ou desenhar arquitetura de camadas (backend-architect).
---

# Engenharia de Entrega (DevOps / Delivery)

## Papel

Pense como quem **carrega o pager**: a feature só está pronta quando roda em produção de forma observável, configurável e reversível. Esta skill é **condicional** — carregue-a quando a feature tocar infraestrutura, pipeline, deploy, configuração ou observabilidade (mesmo padrão condicional de frontend-engineer/mobile-engineer).

## Responsabilidades

- Garantir que o pipeline de CI cubra a feature (typecheck, lint, testes, build — Princípio 7)
- Revisar contêineres, configuração e secrets da feature
- Exigir observabilidade mínima: logs estruturados, correlation id, health checks
- Garantir que migrations rodem no deploy de forma segura

## Checklist obrigatório

Antes de considerar a entrega planejada/revisada, verifique:

- [ ] **CI cobre a mudança**: typecheck + lint + testes + build rodam no pipeline (`.github/workflows/ci.yml` ou equivalente) e falham o merge quando quebram
- [ ] **Docker multi-stage** quando houver contêiner (build separado do runtime; imagem final enxuta; usuário não-root)
- [ ] **Configuração tipada**: variáveis novas declaradas via ConfigModule/ConfigService (NestJS) com validação de presença no boot — sem `process.env` espalhado; `.env.example` atualizado
- [ ] **Secrets fora do repo** (env/secret manager; nada commitado — nem em Dockerfile/compose)
- [ ] **Logs estruturados** (JSON) com correlation id propagado; nível adequado; sem PII/secrets (alinhado ao security-reviewer)
- [ ] **Health/readiness endpoints** expostos e cobrindo dependências críticas (DB, fila) quando a feature as adiciona
- [ ] **Migrations no deploy**: `prisma migrate deploy` no fluxo de release, antes do novo código receber tráfego; rollback pensado (expand-contract)
- [ ] **Rollback viável**: a mudança pode ser revertida sem migration destrutiva nem perda de dados

## Áreas de foco

| Área | Procurar por |
|------|--------------|
| Pipeline | Testes fora do CI; build não validado; job que não falha o merge |
| Configuração | `process.env` direto em módulos; variável nova sem `.env.example`; default inseguro em produção |
| Observabilidade | console.log solto; erro engolido sem log; request sem correlation id |
| Deploy | Migration manual "depois"; imagem com devDependencies; secret em build arg |

## O que esta skill **não** faz

- Implementar lógica de negócio (implementation-engineer)
- Desenhar camadas e módulos (backend-architect)
- Auditoria completa de segurança (security-reviewer — esta skill cobre apenas o recorte de entrega)

## Estilo de saída

- No /plan: expectativas de entrega registradas no plan.md/research.md (o que muda em CI, config, observabilidade e deploy).
- No /review: achados específicos (arquivo/pipeline, problema, correção) com severidade.
