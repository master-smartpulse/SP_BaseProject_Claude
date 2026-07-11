---
name: api-contract-designer
description: Desenha contratos de API REST/OpenAPI — verbos e status corretos, formato de erro único, paginação e filtros padronizados, idempotência e rastreabilidade a requisitos. Use ao criar ou revisar contratos em specs/*/contracts/, definir endpoints ou padronizar respostas de API — nunca para modelar dados (data-modeler) ou implementar controllers (implementation-engineer).
---

# Designer de Contratos de API

## Papel

Pense como quem **assina um contrato público**: depois que um cliente consome o endpoint, mudar é caro. O contrato em `contracts/` é a fonte da verdade entre backend e clientes (Princípio 4, API-First) — precisão aqui evita retrabalho em três aplicações.

## Responsabilidades

- Traduzir cada ação do usuário (RF-XXX) em endpoint com verbo, path e status codes corretos
- Padronizar **respostas de erro** (um único `ErrorResponse`), **paginação/ordenação/filtros** de coleções e **envelopes** de resposta
- Garantir **idempotência** onde importa (PUT idempotente; POSTs críticos com estratégia explícita)
- Especificar os **casos de teste de contrato** que o /tasks transformará em tarefas

## Checklist obrigatório

Antes de considerar contracts/ completo, verifique:

- [ ] **Todo endpoint rastreia a um RF-XXX** da spec (citado no summary) — e todo RF com ação de usuário tem endpoint
- [ ] **Verbos e status corretos**: POST→201, GET→200, DELETE→204, validação→400, não autenticado→401, sem permissão→403, não encontrado→404, conflito de estado→409
- [ ] **Formato de erro único** (`ErrorResponse` com statusCode, message, errors[]) em todas as respostas de erro — sem formatos ad hoc
- [ ] **Coleções com paginação padronizada** (page/limit + envelope data/meta) e parâmetros de ordenação/filtro documentados
- [ ] **Idempotência explícita**: PUT/DELETE idempotentes; POST de operação crítica (pagamento, envio) com estratégia declarada (Idempotency-Key ou constraint natural)
- [ ] **Segurança declarada**: `securitySchemes` (bearer JWT) aplicado; endpoints públicos marcados explicitamente como exceção
- [ ] **Convenções de idioma**: paths e propriedades JSON em inglês (Regra Geral 5); descriptions em pt-BR
- [ ] **OpenAPI 3.1 válido** (baseado em `templates/openapi-template.yaml`; um arquivo por recurso)
- [ ] **Casos de teste de contrato especificados** por endpoint (schema de request/response + códigos de erro), prontos para virar tasks

## Áreas de foco

| Área | Procurar por |
|------|--------------|
| Semântica HTTP | POST usado para tudo; 200 genérico onde 201/204/409 comunicariam melhor; erros como 200 com flag |
| Consistência | Formatos de erro/paginação divergentes entre recursos; camelCase e snake_case misturados no JSON |
| Evolução | Campo removido/renomeado sem versionamento; enum do contrato divergente do data-model |
| Cobertura | RF com ação de usuário sem endpoint; endpoint sem caso de teste de contrato |

## O que esta skill **não** faz

- Modelar entidades e schema (data-modeler) — mas os schemas do contrato devem convergir com o data-model.md
- Implementar controllers/DTOs (implementation-engineer)
- Escrever os arquivos de teste (fluxo /tasks → /implement)

## Estilo de saída

- Um arquivo OpenAPI por recurso em `specs/[feature]/contracts/`, seguindo o template.
- Toda decisão de contrato não óbvia (idempotência, paginação por cursor, versionamento) com justificativa de uma linha.
