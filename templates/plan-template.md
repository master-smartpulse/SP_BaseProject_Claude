---
description: 'Template de plano de implementação para desenvolvimento de features'
---

# Plano de Implementação: [FEATURE]

**Branch**: `[###-nome-da-feature]` | **Data**: [DATA] | **Spec**: [link]
**Entrada**: Especificação da feature em `/specs/[###-nome-da-feature]/spec.md`

## Fluxo de Execução (escopo do comando /plan)

```
1. Carregar spec da feature no caminho de Entrada
   → Se não encontrado: ERRO "Nenhuma spec de feature em {path}"
2. Preencher Contexto Técnico (procurar PRECISA ESCLARECIMENTO)
   → Detectar Tipo de Projeto pelo contexto (web=frontend+backend, mobile=app+api, web+mobile=frontend+app+api)
   → Definir Decisão de Estrutura com base no tipo de projeto
3. Preencher a seção Verificação da Constituição com base no documento da constituição.
4. Avaliar a seção Verificação da Constituição abaixo
   → Se houver violações: Documentar em Rastreamento de Complexidade
   → Se não houver justificativa possível: ERRO "Simplifique a abordagem primeiro"
   → Atualizar Rastreamento de Progresso: Verificação Inicial da Constituição
5. Executar Fase 0 → research.md
   → PRECISA ESCLARECIMENTO de PRODUTO (escopo, permissões, retenção, UX): PARE e sugira /clarify
     — decisões de produto são do usuário, não da pesquisa técnica
   → Se restar PRECISA ESCLARECIMENTO técnico: ERRO "Resolver incógnitas"
6. Executar Fase 1 → contracts, data-model.md, quickstart.md.
7. Reavaliar a seção Verificação da Constituição
   → Se novas violações: Refatorar design, voltar à Fase 1
   → Atualizar Rastreamento de Progresso: Verificação Pós-Design da Constituição
8. Planejar Fase 2 → Descrever abordagem de geração de tarefas (NÃO criar tasks.md)
9. PARAR - Pronto para o comando /tasks
```

**IMPORTANTE**: O comando /plan executa os passos 1-9 e PARA após descrever a abordagem da Fase 2 (passo 8). A criação do tasks.md e a implementação são de outros comandos:

- Fase 3: o comando /tasks cria o tasks.md
- Fases 4-5: Implementação e validação (comando /implement e /review)

## Resumo

[Extrair da spec da feature: requisito principal + abordagem técnica do research]

## Contexto Técnico

**Linguagem/Versão**: [ex.: TypeScript 5.x + Node 20, TypeScript 5.x + Expo SDK 52 ou PRECISA ESCLARECIMENTO] 
**Dependências Principais**: [ex.: NestJS + Prisma, Next.js + TanStack Query, React Native + Expo Router ou PRECISA ESCLARECIMENTO] 
**Armazenamento**: [se aplicável, ex.: PostgreSQL via Prisma, expo-secure-store ou N/A] 
**Testes**: [ex.: Vitest/Jest, Playwright (web E2E), Maestro (mobile E2E) ou PRECISA ESCLARECIMENTO] 
**Plataforma Alvo**: [ex.: servidor Linux, navegadores modernos, iOS 15+/Android 10+ via Expo ou PRECISA ESCLARECIMENTO]
**Tipo de Projeto**: [single/web/mobile/web+mobile - determina estrutura do código e as skills de plataforma a carregar] 
**Metas de Performance**: [específico do domínio, ex.: 1000 req/s, 60 fps ou PRECISA ESCLARECIMENTO] 
**Restrições**: [específico do domínio, ex.: p95 <200ms, memória <100MB ou PRECISA ESCLARECIMENTO] 
**Escala/Escopo**: [específico do domínio, ex.: 10k usuários, 1M LOC ou PRECISA ESCLARECIMENTO]

## Verificação da Constituição

_PORTÃO: Deve passar antes da pesquisa da Fase 0. Reverificar após o design da Fase 1._

[Critérios definidos com base no arquivo da constituição. Para features com frontend: incluir verificação de alinhamento ao design system (design-boilerplate quando existir — Regras Gerais). Verificar Stack Padrão TypeScript conforme o Tipo de Projeto (Regra Geral 6 da Constitution).]

## Estrutura do Projeto

### Documentação (esta feature)

```
specs/[###-feature]/
├── plan.md              # Este arquivo (saída do comando /plan)
├── research.md          # Saída da Fase 0 (comando /plan)
├── data-model.md        # Saída da Fase 1 (comando /plan)
├── quickstart.md        # Saída da Fase 1 (comando /plan)
├── contracts/           # Saída da Fase 1 (comando /plan)
└── tasks.md             # Saída da Fase 3 (comando /tasks - NÃO criado pelo /plan)
```

### Código Fonte (raiz do repositório)

```
# Opção 1: Projeto único (PADRÃO) — Clean Architecture modular (docs/arquitetura.md)
src/
├── modules/
│   └── {feature}/
│       ├── controllers/
│       ├── services/
│       ├── use-cases/
│       ├── repositories/
│       └── dto/
└── lib/

tests/
├── contract/
├── integration/
└── unit/

# Opção 2: Aplicação web (quando "frontend" + "backend" detectados)
backend/
├── src/
│   └── modules/             # Clean Architecture modular (igual à Opção 1)
└── tests/

frontend-web/
├── src/
│   ├── components/
│   ├── pages/
│   └── repository/          # Hooks TanStack Query
└── tests/

# Opção 3: Mobile + API (quando "iOS/Android/app mobile" detectado)
backend/
└── [igual ao backend da Opção 2]

mobile-app/                  # React Native + Expo (TypeScript)
├── app/                     # Rotas (Expo Router)
├── src/
│   ├── api/
│   ├── components/
│   ├── features/
│   ├── repository/          # Hooks TanStack Query
│   └── hooks/
└── eas.json

# Opção 4: Web + Mobile + API (quando "web+mobile" detectado)
# Combine a Opção 2 (backend/ + frontend-web/) com o mobile-app/ da Opção 3
```

**Decisão de Estrutura**: [PADRÃO Opção 1 a menos que o Contexto Técnico indique app web/mobile]

## Fase 0: Esboço e Pesquisa

1. **Extrair incógnitas do Contexto Técnico** acima:
 - Para cada PRECISA ESCLARECIMENTO **técnico** → tarefa de pesquisa (os de natureza de **produto** devem ter sido resolvidos via /clarify — se restarem, sugira /clarify antes de prosseguir)
 - Para cada dependência → tarefa de melhores práticas
 - Para cada integração → tarefa de padrões

2. **Gerar e disparar agentes de pesquisa**:

   ```
   Para cada incógnita no Contexto Técnico:
     Tarefa: "Pesquisar {incógnita} para {contexto da feature}"
   Para cada escolha de tecnologia:
     Tarefa: "Encontrar melhores práticas para {tech} em {domínio}"
   ```

3. **Consolidar achados** em `research.md` (use `templates/research-template.md` como base), uma seção por incógnita:
 - Decisão: [o que foi escolhido]
 - Justificativa: [por que foi escolhido]
 - Alternativas consideradas: [o que mais foi avaliado]

**Saída**: research.md com todos os PRECISA ESCLARECIMENTO resolvidos

## Fase 1: Design e Contratos

_Pré-requisitos: research.md completo_

1. **Extrair entidades da spec da feature** → `data-model.md` (use `templates/data-model-template.md` como base):
 - Nome da entidade, campos, relacionamentos
 - Regras de validação dos requisitos
 - Transições de estado se aplicável

2. **Gerar contratos de API** a partir dos requisitos funcionais (use `templates/openapi-template.yaml` como base):
 - Para cada ação do usuário → endpoint
 - Usar padrões REST/GraphQL
 - Saída do schema OpenAPI/GraphQL em `/contracts/`

3. **Especificar os casos de teste de contrato** a partir dos contratos (sem criar arquivos de teste — isso é responsabilidade do fluxo /tasks → /implement):
 - Um caso de teste por endpoint, documentado no próprio contrato ou no quickstart
 - Cobrir schemas de request/response e códigos de erro
 - O /tasks converterá cada caso em tarefa de teste que DEVE falhar antes da implementação

4. **Extrair cenários de teste** das histórias de usuário (use `templates/quickstart-template.md` como base para o quickstart.md):
 - Cada história → cenário de teste de integração
 - Teste quickstart = passos de validação da história

**Saída**: data-model.md, /contracts/* (com casos de teste de contrato especificados), quickstart.md

## Fase 2: Abordagem de Planejamento de Tarefas

_Esta seção descreve o que o comando /tasks fará - NÃO executar durante o /plan_

**Estratégia de Geração de Tarefas**:

- Carregar `templates/tasks-template.md` como base
- Estrutura de entrega incremental: Setup → Fundação (infra compartilhada) → **uma fase por user story** (testes da história → implementação → checkpoint validável) → Polish
- Cada endpoint dos contratos → teste de contrato [P] + implementação, na fase da história que atende
- Cada entidade compartilhada → tarefa de modelo [P] (+ migration) na Fundação
- Toda task derivada de requisito rastreia (RF-xxx); tabela de Cobertura de Requisitos obrigatória

**Estratégia de Ordenação**:

- TDD dentro de cada história: testes antes da implementação
- Ordem de dependência: Fundação antes das histórias; modelos antes de serviços antes de UI
- Marcar [P] para execução paralela (arquivos independentes)

**Saída Estimada**: 20-40 tarefas numeradas e ordenadas em tasks.md, proporcional ao nº de user stories

**IMPORTANTE**: Esta fase é executada pelo comando /tasks, NÃO pelo /plan

## Fase 3+: Implementação Futura

_Estas fases estão fora do escopo do comando /plan_

**Fase 3**: Geração de tarefas (comando /tasks cria tasks.md) 
**Fase 4**: Implementação (comando /implement executa o tasks.md seguindo princípios da constituição) 
**Fase 5**: Validação (rodar testes, executar quickstart.md, validação de performance)

## Rastreamento de Complexidade

_Preencher SOMENTE se a Verificação da Constituição tiver violações que precisem ser justificadas_

| Violação | Por que é necessária | Alternativa mais simples rejeitada porque |
| -------------------------- | ------------------ | ------------------------------------ |
| [ex.: 4º projeto] | [necessidade atual] | [por que 3 projetos não bastam] |
| [ex.: padrão Repository] | [problema específico] | [por que acesso direto ao DB não basta] |

## Rastreamento de Progresso

_Este checklist é atualizado durante o fluxo de execução_

**Status das Fases**:

- [ ] Fase 0: Pesquisa concluída (comando /plan)
- [ ] Fase 1: Design concluído (comando /plan)
- [ ] Fase 2: Planejamento de tarefas concluído (comando /plan - apenas descrever abordagem)
- [ ] Fase 3: Tarefas geradas (comando /tasks)
- [ ] Fase 4: Implementação concluída
- [ ] Fase 5: Validação aprovada

**Status dos Portões**:

- [ ] Verificação Inicial da Constituição: APROVADO
- [ ] Verificação Pós-Design da Constituição: APROVADO
- [ ] Todos os PRECISA ESCLARECIMENTO resolvidos
- [ ] Desvios de complexidade documentados

---

_Baseado na Constituição vigente - Ver `memory/constitution.md`_
