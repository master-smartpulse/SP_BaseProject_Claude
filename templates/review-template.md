# Relatório de Revisão: [NOME DA FEATURE]

**Branch**: `[###-nome-da-feature]` | **Data**: [DATA] | **Arquivos revisados**: [N]
**Entrada**: Arquivos alterados no branch da feature

## Fluxo de Execução (principal)

```
1. Carregar contexto obrigatório (constitution, arquitetura)
   → Se não encontrado: ERRO "Documentos de governança não encontrados"
2. Carregar contexto da feature (spec, plan, tasks) quando disponível
3. Identificar arquivos alterados via script ou git diff
   → Se nenhum arquivo: AVISO "Nenhum arquivo alterado encontrado"
4. Para cada arquivo alterado:
   → Classificar tipo (controller, service, use-case, repository, component, screen, hook, teste, config, outro)
   → Aplicar checklists das skills relevantes ao tipo
5. Executar verificação executável (typecheck, lint, testes) quando o tooling existir
   → Falha em qualquer uma: resultado REPROVADO
6. Consolidar achados por severidade
7. Gerar tabela de conformidade por área e cobertura de requisitos
8. Determinar resultado: APROVADO (zero Crítico + zero Alto + verificação executável verde ou N/A) ou REPROVADO
9. Salvar em specs/[###-nome-da-feature]/review.md e retornar relatório
   (a gravação é feita pelo comando /review no contexto principal; mini-reviews
   por fase despachados pelo implement apenas reportam achados, sem gravar)
```

---

## Resumo

- **Crítico**: [N] | **Alto**: [N] | **Médio**: [N] | **Baixo**: [N]
- **Resultado**: [APROVADO / REPROVADO]

---

## Verificação Executável

_Comandos executados de fato via terminal — falha em qualquer um determina REPROVADO. N/A apenas quando o tooling ainda não existe no projeto (justificar)._

| Verificação | Comando | Status | Resumo da saída |
|-------------|---------|--------|-----------------|
| Typecheck | [ex.: `npx tsc --noEmit`] | [✅/❌/N/A] | [ex.: 0 erros / lista resumida] |
| Lint | [ex.: `npx eslint .`] | [✅/❌/N/A] | [breve] |
| Testes | [ex.: `npm test`] | [✅/❌/N/A] | [ex.: 42 passed, 0 failed] |

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

## Cobertura de Requisitos

_Preenchida a partir da tabela "Cobertura de Requisitos" do tasks.md, conferida contra o código revisado._

| Requisito | Implementado | Testado | Observação |
|-----------|--------------|---------|------------|
| RF-001 | [✅/⚠️/❌] | [✅/⚠️/❌] | [breve] |

---

## Arquivos Revisados

| Arquivo | Tipo | Achados |
|---------|------|---------|
| `[path]` | [controller/service/use-case/repository/component/screen/hook/teste/config] | [N Crítico, N Alto, N Médio, N Baixo] |

---

## Próximos Passos

_Preencher apenas se REPROVADO — loop de correção do workflow_

1. [Achados Crítico/Alto convertidos em tasks corretivas na fase "Correções" do tasks.md: T0XX–T0YY]
2. Rodar `/implement Correções` para executar apenas as tasks corretivas
3. Rodar `/review` novamente — a feature só cumpre o DoD com relatório APROVADO

---

## Checklist de Validação

_PORTÃO: Verificado antes de emitir o relatório_

- [ ] Contexto carregado (constitution, arquitetura, spec e plan quando disponíveis)
- [ ] Todos os arquivos alterados foram revisados
- [ ] Checklists de arquitetura, segurança, testes e performance aplicados (e frontend web/mobile quando houver código dessas plataformas)
- [ ] Verificação executável rodada e registrada (ou N/A justificado)
- [ ] Cada achado tem severidade, arquivo, regra violada e correção sugerida
- [ ] Tabelas de conformidade e de cobertura de requisitos preenchidas
- [ ] Resultado final determinado (APROVADO/REPROVADO)
- [ ] Relatório salvo em specs/[###-nome-da-feature]/review.md

---
