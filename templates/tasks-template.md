# Tarefas: [NOME DA FEATURE]

**Entrada**: Documentos de design em `/specs/[###-nome-da-feature]/`
**Pré-requisitos**: plan.md (obrigatório), research.md, data-model.md, contracts/

## Fluxo de Execução (principal)

```
1. Carregar plan.md do diretório da feature
   → Se não encontrado: ERRO "Nenhum plano de implementação encontrado"
   → Extrair: stack, bibliotecas, estrutura
2. Carregar documentos de design:
   → spec: extrair user stories (uma FASE por história) e requisitos RF-XXX
   → data-model.md: extrair entidades → tarefas de modelo/migration na Fundação
   → contracts/: cada endpoint → tarefas de teste de contrato + implementação na história correspondente
   → research.md: extrair decisões → tarefas de setup
3. Gerar tarefas por estrutura de entrega incremental:
   → Setup: init do projeto, dependências, lint
   → Fundação: infraestrutura compartilhada que bloqueia as histórias (modelos, migrations, middleware)
   → Uma fase por User Story: testes da história (TDD) → implementação → checkpoint validável
   → Polish: testes unitários transversais, performance, documentação
4. Aplicar regras de tarefa:
   → Arquivos diferentes = marcar [P] para paralelo
   → Mesmo arquivo = sequencial (sem [P])
   → Dentro de cada história: testes antes da implementação (TDD)
   → Toda task derivada de requisito leva (RF-xxx)
5. Numerar tarefas sequencialmente (T001, T002...)
6. Gerar grafo de dependências e tabela de Cobertura de Requisitos
7. Validar completude (Checklist de Validação abaixo)
8. Retornar: SUCESSO (tarefas prontas para execução)
```

## Formato: `[ID] [P?] (RF-xxx) Descrição`

- **[P]**: Pode rodar em paralelo (arquivos diferentes, sem dependências)
- **(RF-xxx)**: requisito(s) da spec que a task atende — obrigatório nas tasks de teste e de implementação derivadas de requisitos; tasks de infraestrutura usam (SETUP) ou omitem
- Incluir caminhos exatos de arquivo nas descrições

## Convenções de Caminho

- **Projeto único**: `src/modules/`, `tests/` na raiz do repositório
- **App web**: `backend/src/`, `frontend-web/src/`
- **Mobile**: `backend/src/`, `mobile-app/app/` e `mobile-app/src/` (React Native/Expo)
- **Web + Mobile**: combine `backend/src/`, `frontend-web/src/` e `mobile-app/`
- Os caminhos abaixo assumem projeto único — ajuste conforme a estrutura do plan.md

## Fase 4.1: Setup

- [ ] T001 Criar estrutura do projeto conforme plano de implementação
- [ ] T002 Inicializar projeto [linguagem] com dependências [framework]
- [ ] T003 [P] Configurar ferramentas de lint e formatação

## Fase 4.2: Fundação (bloqueia todas as histórias)

_Infraestrutura compartilhada: entidades, migrations, conexão com DB, middleware. Sem regra de negócio de história específica._

- [ ] T004 [P] (SETUP) Entidade User e DTOs em src/modules/users/dto/
- [ ] T005 (SETUP) Migration inicial do módulo em prisma/migrations (prisma migrate dev --name create-users)
- [ ] T006 (SETUP) Middleware de autenticação em src/shared/auth/

## Fase 4.3: US1 — Registro de usuário (RF-001) 🎯

_TDD dentro do bloco: os testes da história DEVEM ser escritos e DEVEM FALHAR antes da implementação correspondente._

- [ ] T007 [P] (RF-001) Teste de contrato POST /api/users em tests/contract/users-post.spec.ts
- [ ] T008 [P] (RF-001) Teste de integração de registro em tests/integration/registration.spec.ts
- [ ] T009 (RF-001) CreateUserUseCase em src/modules/users/use-cases/create-user/ (depende de T004 — sem [P])
- [ ] T010 (RF-001) UserService e endpoint POST /api/users em src/modules/users/

**Checkpoint US1 (validável)**: testes da história verdes; cenário 1 do quickstart.md executável de ponta a ponta.

## Fase 4.4: US2 — Consulta de usuário (RF-002) 🎯

- [ ] T011 [P] (RF-002) Teste de contrato GET /api/users/{id} em tests/contract/users-get.spec.ts
- [ ] T012 (RF-002) Endpoint GET /api/users/{id} em src/modules/users/controllers/

**Checkpoint US2 (validável)**: testes da história verdes; cenário 2 do quickstart.md executável.

## Fase 4.5: Polish (transversal)

- [ ] T013 [P] Testes unitários de validação em tests/unit/validation.spec.ts
- [ ] T014 Testes de performance (<200ms)
- [ ] T015 [P] Atualizar documentação Swagger/OpenAPI dos endpoints alterados
- [ ] T016 Remover duplicação
- [ ] T017 Executar todos os cenários de validação do quickstart.md

## Dependências

- Fundação (T004-T006) antes de todas as histórias
- Dentro de cada história: testes antes da implementação (T007-T008 antes de T009-T010; T011 antes de T012)
- T004 bloqueia T009 (entidade antes do use case)
- Histórias antes do polish (T013-T017)
- Histórias independentes entre si podem ser executadas em qualquer ordem (priorize pela ordem da spec)

## Cobertura de Requisitos

_PORTÃO: todo RF da spec precisa de pelo menos uma task de implementação E uma task de teste._

| Requisito | User Story / Fase | Tasks de implementação | Tasks de teste |
|-----------|-------------------|------------------------|----------------|
| RF-001 | US1 (Fase 4.3) | T009, T010 | T007, T008 |
| RF-002 | US2 (Fase 4.4) | T012 | T011 |

## Execução Paralela de Tasks [P]

Mecanismo (executado pelo agente implement): tasks [P] da mesma fase são despachadas como **subagents paralelos** — uma invocação por task, no mesmo turno, cada uma com as instruções completas da task (descrição, caminho de arquivo, casos de teste). O template garante que tasks [P] não compartilham arquivos; o implement consolida os resultados e valida a fase antes de avançar. Sem paralelismo disponível, executar sequencialmente na ordem dos IDs.

```
# Exemplo — lançar T007-T008 juntos (um subagent por task, mesmo turno):
Subagent A: "Executar T007 (RF-001): teste de contrato POST /api/users em tests/contract/users-post.spec.ts — [casos de teste da task]"
Subagent B: "Executar T008 (RF-001): teste de integração de registro em tests/integration/registration.spec.ts — [cenários]"
```

## Notas

- Tarefas [P] = arquivos diferentes, sem dependências
- Verificar que os testes falham antes de implementar (dentro de cada história)
- Fazer commit após cada tarefa (Conventional Commits, em inglês)
- Cada história termina num **checkpoint validável** — valor verificável antes de seguir para a próxima
- Evitar: tarefas vagas, conflitos no mesmo arquivo
- **Fase "Correções"**: quando o /review reprova, ele apensa aqui uma fase adicional com tasks corretivas (IDs continuando a sequência, cada uma citando o achado — ex.: "T018 Corrigir CRÍTICO-001: ..."); o ciclo é `/implement Correções` → novo `/review`
- **Regras Gerais (Constitution):** Não incluir tarefas de criação de arquivos .md (README, CHANGELOG, etc.) a menos que o usuário solicite explicitamente. Para features com frontend: garantir alinhamento ao design system (design-boilerplate quando existir — Regras Gerais da Constitution). Tarefas devem usar a Stack Padrão TypeScript conforme o Tipo de Projeto do plan.md (Regra Geral 6)

## Regras de Geração de Tarefas

_Aplicadas durante a execução principal_

1. **A partir das Histórias de Usuário** (estrutura principal):
 - Cada user story da spec → uma FASE própria com: testes da história [P] → implementação → checkpoint validável
 - Cenários de quickstart → critérios do checkpoint da história correspondente
2. **A partir dos Contratos**:
 - Cada endpoint → task de teste de contrato [P] + task de implementação, ambas na fase da história que o endpoint atende
3. **A partir do Modelo de Dados**:
 - Cada entidade compartilhada → task de criação de modelo [P] na Fundação
 - Schema novo/alterado → task de migration na Fundação (prisma migrate)
 - Entidade exclusiva de uma história → pode viver na fase da história
4. **Ordenação**:
 - Setup → Fundação → US1 → US2 → ... → Polish
 - Dentro de cada história: testes → implementação
 - Dependências bloqueiam execução paralela

## Checklist de Validação

_PORTÃO: Verificado antes de retornar_

- [ ] Cada user story da spec tem fase própria com checkpoint validável
- [ ] Todos os contratos têm testes correspondentes na história certa
- [ ] Todas as entidades têm tarefas de modelo (e migration quando altera schema)
- [ ] Dentro de cada história, testes vêm antes da implementação
- [ ] Tarefas paralelas realmente independentes
- [ ] Cada tarefa especifica caminho exato do arquivo
- [ ] Nenhuma tarefa modifica o mesmo arquivo que outra tarefa [P]
- [ ] Nenhuma tarefa marcada [P] aparece como bloqueada na seção Dependências
- [ ] Tabela de Cobertura de Requisitos preenchida; nenhum RF sem task de implementação e de teste
