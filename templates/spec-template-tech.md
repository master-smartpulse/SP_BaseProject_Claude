# Especificação Técnica: [TÍTULO]

**Tipo**: [Bug / Melhoria / Refatoração / Performance / Segurança / Débito técnico]  
**Branch**: `[###-nome-da-feature]`  
**Criado**: [DATA]  
**Status**: Rascunho  
**Entrada**: Descrição fornecida: "$ARGUMENTS"

## Fluxo de Execução (principal)

```
1. Interpretar descrição técnica a partir da Entrada
   → Se vazio: ERRO "Nenhuma descrição fornecida"
2. Identificar tipo (bug, melhoria, refatoração, etc.) e escopo
3. Para bugs: identificar causa raiz e comportamento atual vs esperado
4. Para melhorias/refactor: delimitar escopo e impacto em módulos/APIs
5. Definir critérios de aceite testáveis e verificáveis
6. Marcar ambiguidades com [PRECISA ESCLARECIMENTO: pergunta]
   → Decisões do usuário são resolvidas pelo /clarify, que registra as respostas
     numa seção "## Esclarecimentos" (criada sob demanda) e atualiza a spec
7. Executar checklist de gate antes de retornar
8. Retornar: SUCESSO (spec técnica pronta para /plan)
```

---

## ⚡ Diretrizes

- ✅ Foque em CAUSA RAIZ (bugs), ESCOPO e IMPACTO (melhorias/refactor)
- ✅ Critérios de aceite devem ser testáveis e verificáveis
- ❌ Evite scope creep: escopo delimitado, sem expandir para outras mudanças

---

## Problema / Objetivo _(obrigatório)_

### Resumo

[Uma ou duas frases: o que está errado ou o que se quer alcançar.]

### Comportamento Atual _(obrigatório para bugs)_

[Descrever o que acontece hoje: passos para reproduzir, resultado observado, evidências (logs, stack trace, etc.).]

### Comportamento Esperado _(obrigatório para bugs)_

[Descrever o resultado correto após a correção.]

### Causa Raiz _(obrigatório para bugs; opcional para outros)_

[Explicar a causa técnica raiz do problema. Se ainda desconhecida, marcar [PRECISA ESCLARECIMENTO] e descrever hipóteses.]

---

## Escopo e Impacto _(obrigatório)_

### Escopo Incluído

- [Lista do que está DENTRO do escopo desta spec.]
- [Arquivos, módulos ou APIs diretamente afetados.]

### Escopo Excluído (fora desta spec)

- [O que NÃO será feito nesta mudança — evita scope creep.]

### Impacto em Módulos/APIs

| Módulo / API | Tipo de impacto | Observação |
| -------------|-----------------|------------|
| [ex.: `src/services/auth.js`] | [alteração / novo / remoção] | [breve] |
| [ex.: contrato POST /login] | [alteração / inalterado] | [breve] |

---

## Critérios de Aceite _(obrigatório)_

Cada critério deve ser **testável** (automático ou manual com passos claros).

- **CA-001**: [Critério verificável, ex.: "Ao enviar X, a resposta deve ser Y em <200ms."]
- **CA-002**: [Ex.: "Teste unitário Z passa; cobertura de branch em foo() ≥ 80%."]
- **CA-003**: [Ex.: "Nenhuma regressão em testes E2E da área Y."]

---

## Abordagem Técnica _(opcional)_

[Se já houver direção técnica aprovada: padrões a seguir, libs, mudanças de contrato. Caso contrário, deixar para a fase /plan.]

---

## Riscos e Dependências

- **Riscos**: [Ex.: mudança de contrato quebra clientes legados.]
- **Dependências**: [Ex.: PR #X precisa ser mergeado antes.]

---

## Checklist de Gate (antes de concluir)

- [ ] Causa raiz documentada (bugs); comportamento atual vs esperado claro
- [ ] Critérios de aceite testáveis e verificáveis
- [ ] Escopo delimitado; impacto em módulos/APIs identificado
- [ ] Nenhum [PRECISA ESCLARECIMENTO] restante sem justificativa

---

## Status de Execução

- [ ] Descrição interpretada
- [ ] Tipo e escopo identificados
- [ ] Causa raiz / objetivo documentados
- [ ] Critérios de aceite definidos
- [ ] Checklist de gate aprovado

---
