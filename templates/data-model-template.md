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

- [Entidade 1] 1—N [Entidade 2]: [descrição da relação]

**Transições de estado** _(se aplicável — remover se não houver)_:

- [estado A] → [estado B] quando [evento]

## Convenções (constitution e docs/arquitetura.md)

- Esquema do banco em inglês, snake_case (`@map`/`@@map` no Prisma)
- Toda entidade exposta na API tem DTO e tipos TypeScript correspondentes
- Validação em runtime com Zod alinhada aos tipos

## Checklist

- [ ] Toda entidade citada na spec está modelada
- [ ] Validações derivadas dos requisitos (não inventadas)
- [ ] Relacionamentos e cardinalidades definidos
- [ ] Índices identificados para os padrões de acesso previstos
