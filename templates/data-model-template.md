# Modelo de Dados: [NOME DA FEATURE]

**Branch**: `[###-nome-da-feature]` | **Data**: [DATA]
**Entrada**: spec da feature e research.md

## Entidades

### [Entidade 1]

**Descrição**: [o que representa no domínio]

| Campo | Tipo | Obrigatório | Descrição / Validação |
|-------|------|-------------|------------------------|
| id | uuid | sim | Identificador único |
| [campo] | [tipo] | [sim/não] | [regra de validação derivada dos requisitos da spec] |

**Relacionamentos**:

- [Entidade 1] 1—N [Entidade 2]: [descrição da relação; `onDelete`: Cascade/Restrict/SetNull — decisão explícita]

**Ciclo de vida**: [soft delete (`deletedAt`) ou hard delete — com justificativa (retenção, auditoria, LGPD)]

**Índices**: [cada índice cita a consulta prevista que o justifica — nenhum especulativo]

**Transições de estado** _(se aplicável — remover se não houver)_:

- [estado A] → [estado B] quando [evento]

## Migrations

_Obrigatório quando a feature cria ou altera schema (docs/arquitetura.md, Convenções de Banco)._

- **Migration prevista**: [ex.: `prisma migrate dev --name create-users` — aditiva]
- **Reversibilidade**: [aditiva/reversível; se breaking, plano expand-contract: adicionar → migrar dados → remover]
- **Backfill/seed**: [necessário? como?]

## Convenções (constitution e docs/arquitetura.md)

- Esquema do banco em inglês, snake_case (`@map`/`@@map` no Prisma)
- Toda entidade exposta na API tem DTO e tipos TypeScript correspondentes
- Validação em runtime com Zod alinhada aos tipos

## Checklist (ver skill data-modeler — fonte única do checklist completo)

- [ ] Toda entidade citada na spec está modelada
- [ ] Validações derivadas dos requisitos (não inventadas), com RF citado
- [ ] Relacionamentos com cardinalidade e `onDelete` explícitos
- [ ] Unique constraints para invariantes de negócio
- [ ] Índices justificados pelos padrões de acesso previstos
- [ ] Soft vs hard delete decidido por entidade
- [ ] Migration planejada (aditiva/reversível; breaking → expand-contract)
