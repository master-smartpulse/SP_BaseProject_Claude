# Relatório de Revisão: [NOME DA FEATURE]

**Branch**: `[###-nome-da-feature]` | **Data**: [DATA] | **Arquivos revisados**: [N]
**Entrada**: Arquivos alterados no branch da feature

## Fluxo de Execução (principal)

```
1. Carregar contexto obrigatório (constitution, arquitetura)
   → Se não encontrado: ERRO "Documentos de governança não encontrados"
2. Carregar contexto da feature (spec, plan) quando disponível
3. Identificar arquivos alterados via script ou git diff
   → Se nenhum arquivo: AVISO "Nenhum arquivo alterado encontrado"
4. Para cada arquivo alterado:
   → Classificar tipo (controller, service, use-case, repository, component, screen, hook, teste, config, outro)
   → Aplicar checklists das skills relevantes ao tipo
5. Consolidar achados por severidade
6. Gerar tabela de conformidade por área
7. Determinar resultado: APROVADO (zero Crítico + zero Alto) ou REPROVADO
8. Retornar: relatório completo
```

---

## Resumo

- **Crítico**: [N] | **Alto**: [N] | **Médio**: [N] | **Baixo**: [N]
- **Resultado**: [APROVADO / REPROVADO]

---

## Achados

### Críticos

_Achados que bloqueiam merge. Devem ser corrigidos antes de prosseguir._

#### [CRÍTICO-001] [Título curto]
- **Arquivo**: `path/to/file.ts:linha`
- **Regra violada**: [Princípio da Constitution / Checklist da skill]
- **Problema**: [Descrição específica do que está errado]
- **Correção sugerida**: [O que fazer para resolver]

### Altos

_Achados que devem ser corrigidos. Risco significativo se ignorados._

#### [ALTO-001] [Título curto]
- **Arquivo**: `path/to/file.ts:linha`
- **Regra violada**: [Princípio / Checklist]
- **Problema**: [Descrição]
- **Correção sugerida**: [O que fazer]

### Médios

_Melhorias recomendadas. Não bloqueiam mas aumentam qualidade._

#### [MEDIO-001] [Título curto]
- **Arquivo**: `path/to/file.ts:linha`
- **Regra violada**: [Princípio / Checklist]
- **Problema**: [Descrição]
- **Correção sugerida**: [O que fazer]

### Baixos

_Observações menores. Podem ser tratadas em momento oportuno._

#### [BAIXO-001] [Título curto]
- **Arquivo**: `path/to/file.ts:linha`
- **Observação**: [Descrição]
- **Sugestão**: [O que poderia melhorar]

---

## Conformidade por Área

| Área | Status | Observações |
|------|--------|-------------|
| Arquitetura (camadas) | [✅/⚠️/❌] | [breve] |
| Segurança | [✅/⚠️/❌] | [breve] |
| Testes | [✅/⚠️/❌] | [breve] |
| Performance | [✅/⚠️/❌] | [breve] |
| Frontend Web | [✅/⚠️/❌/N/A] | [N/A se a feature não tem código web] |
| Mobile | [✅/⚠️/❌/N/A] | [N/A se a feature não tem código mobile] |
| Constitution (regras gerais) | [✅/⚠️/❌] | [breve] |
| Aderência à spec | [✅/⚠️/❌] | [breve] |

**Legenda**: ✅ Conforme | ⚠️ Parcial (achados Médios/Baixos) | ❌ Não conforme (achados Críticos/Altos)

---

## Arquivos Revisados

| Arquivo | Tipo | Achados |
|---------|------|---------|
| `[path]` | [controller/service/use-case/repository/component/screen/hook/teste/config] | [N Crítico, N Alto, N Médio, N Baixo] |

---

## Próximos Passos

_Preencher apenas se REPROVADO_

1. [Corrigir achado CRÍTICO-001 em path/to/file.ts]
2. [Corrigir achado ALTO-001 em path/to/file.ts]
3. [Rodar /review novamente após correções]

---

## Checklist de Validação

_PORTÃO: Verificado antes de emitir o relatório_

- [ ] Contexto carregado (constitution, arquitetura, spec e plan quando disponíveis)
- [ ] Todos os arquivos alterados foram revisados
- [ ] Checklists de arquitetura, segurança, testes e performance aplicados (e frontend web/mobile quando houver código dessas plataformas)
- [ ] Cada achado tem severidade, arquivo, regra violada e correção sugerida
- [ ] Tabela de conformidade preenchida
- [ ] Resultado final determinado (APROVADO/REPROVADO)

---
