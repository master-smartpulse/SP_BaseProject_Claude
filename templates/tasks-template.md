# Tarefas: [NOME DA FEATURE]

**Entrada**: Documentos de design em `/specs/[###-nome-da-feature]/`
**Pré-requisitos**: plan.md (obrigatório), research.md, data-model.md, contracts/

## Fluxo de Execução (principal)

```
1. Carregar plan.md do diretório da feature
   → Se não encontrado: ERRO "Nenhum plano de implementação encontrado"
   → Extrair: stack, bibliotecas, estrutura
2. Carregar documentos de design opcionais:
   → data-model.md: Extrair entidades → tarefas de modelo
   → contracts/: Cada arquivo → tarefa de teste de contrato
   → research.md: Extrair decisões → tarefas de setup
3. Gerar tarefas por categoria:
   → Setup: init do projeto, dependências, lint
   → Testes: testes de contrato, testes de integração
   → Núcleo: modelos, serviços, comandos CLI
   → Integração: DB, middleware, logging
   → Polish: testes unitários, performance, docs
4. Aplicar regras de tarefa:
   → Arquivos diferentes = marcar [P] para paralelo
   → Mesmo arquivo = sequencial (sem [P])
   → Testes antes da implementação (TDD)
5. Numerar tarefas sequencialmente (T001, T002...)
6. Gerar grafo de dependências
7. Criar exemplos de execução paralela
8. Validar completude das tarefas:
   → Todos os contratos têm testes?
   → Todas as entidades têm modelos?
   → Todos os endpoints implementados?
9. Retornar: SUCESSO (tarefas prontas para execução)
```

## Formato: `[ID] [P?] Descrição`

- **[P]**: Pode rodar em paralelo (arquivos diferentes, sem dependências)
- Incluir caminhos exatos de arquivo nas descrições

## Convenções de Caminho

- **Projeto único**: `src/modules/`, `tests/` na raiz do repositório
- **App web**: `backend/src/`, `frontend-web/src/`
- **Mobile**: `backend/src/`, `mobile-app/app/` e `mobile-app/src/` (React Native/Expo)
- **Web + Mobile**: combine `backend/src/`, `frontend-web/src/` e `mobile-app/`
- Os caminhos abaixo assumem projeto único — ajuste conforme a estrutura do plan.md

## Fase 3.1: Setup

- [ ] T001 Criar estrutura do projeto conforme plano de implementação
- [ ] T002 Inicializar projeto [linguagem] com dependências [framework]
- [ ] T003 [P] Configurar ferramentas de lint e formatação

## Fase 3.2: Testes Primeiro (TDD) ⚠️ CONCLUIR ANTES DA 3.3

**CRÍTICO: Estes testes DEVEM ser escritos e DEVEM FALHAR antes de QUALQUER implementação**

- [ ] T004 [P] Teste de contrato POST /api/users em tests/contract/users-post.spec.ts
- [ ] T005 [P] Teste de contrato GET /api/users/{id} em tests/contract/users-get.spec.ts
- [ ] T006 [P] Teste de integração de registro de usuário em tests/integration/registration.spec.ts
- [ ] T007 [P] Teste de integração do fluxo de autenticação em tests/integration/auth.spec.ts

## Fase 3.3: Implementação do Núcleo (SOMENTE após os testes falharem)

- [ ] T008 [P] Entidade User e DTOs em src/modules/users/dto/
- [ ] T009 [P] CreateUserUseCase em src/modules/users/use-cases/create-user/
- [ ] T010 [P] UserRepository (Prisma) em src/modules/users/repositories/
- [ ] T011 UserService e endpoint POST /api/users em src/modules/users/
- [ ] T012 Endpoint GET /api/users/{id} em src/modules/users/controllers/
- [ ] T013 Validação de entrada
- [ ] T014 Tratamento de erros e logging

## Fase 3.4: Integração

- [ ] T015 Conectar UserRepository ao Prisma Client
- [ ] T016 Middleware de autenticação
- [ ] T017 Logging de request/response
- [ ] T018 CORS e headers de segurança

## Fase 3.5: Polish

- [ ] T019 [P] Testes unitários de validação em tests/unit/validation.spec.ts
- [ ] T020 Testes de performance (<200ms)
- [ ] T021 [P] Atualizar documentação Swagger/OpenAPI dos endpoints alterados
- [ ] T022 Remover duplicação
- [ ] T023 Executar cenários de validação do quickstart.md

## Dependências

- Testes (T004-T007) antes da implementação (T008-T014)
- T008 bloqueia T009, T015
- T016 bloqueia T018
- Implementação antes do polish (T019-T023)

## Exemplo de Paralelo

```
# Lançar T004-T007 juntos:
Tarefa: "Teste de contrato POST /api/users em tests/contract/users-post.spec.ts"
Tarefa: "Teste de contrato GET /api/users/{id} em tests/contract/users-get.spec.ts"
Tarefa: "Teste de integração de registro em tests/integration/registration.spec.ts"
Tarefa: "Teste de integração de auth em tests/integration/auth.spec.ts"
```

## Notas

- Tarefas [P] = arquivos diferentes, sem dependências
- Verificar que os testes falham antes de implementar
- Fazer commit após cada tarefa
- Evitar: tarefas vagas, conflitos no mesmo arquivo
- **Regras Gerais (Constitution):** Não incluir tarefas de criação de arquivos .md (README, CHANGELOG, etc.) a menos que o usuário solicite explicitamente. Para features com frontend: garantir alinhamento ao design system (design-boilerplate quando existir — Regras Gerais, Constitution v1.2.0). Tarefas devem usar a Stack Padrão TypeScript conforme o Tipo de Projeto do plan.md (Regra Geral 6)

## Regras de Geração de Tarefas

_Aplicadas durante a execução principal_

1. **A partir dos Contratos**:
 - Cada arquivo de contrato → tarefa de teste de contrato [P]
 - Cada endpoint → tarefa de implementação
2. **A partir do Modelo de Dados**:
 - Cada entidade → tarefa de criação de modelo [P]
 - Relacionamentos → tarefas na camada de serviço
3. **A partir das Histórias de Usuário**:
 - Cada história → teste de integração [P]
 - Cenários de quickstart → tarefas de validação

4. **Ordenação**:
 - Setup → Testes → Modelos → Serviços → Endpoints → Polish
 - Dependências bloqueiam execução paralela

## Checklist de Validação

_PORTÃO: Verificado antes de retornar_

- [ ] Todos os contratos têm testes correspondentes
- [ ] Todas as entidades têm tarefas de modelo
- [ ] Todos os testes vêm antes da implementação
- [ ] Tarefas paralelas realmente independentes
- [ ] Cada tarefa especifica caminho exato do arquivo
- [ ] Nenhuma tarefa modifica o mesmo arquivo que outra tarefa [P]
