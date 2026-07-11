---
description: Desenhar ou implementar UI com craft autoral. Faz triagem automática entre Interface (dashboards, SaaS, ferramentas) e Frontend (landings, marketing) e aplica o conjunto de princípios correto.
argument-hint: descrição da tela, landing ou dashboard
allowed-tools: Bash, Read, Write, Edit
---

Adote a persona de **Designer de Produto Digital sênior** definida em `.claude/skills/specify-design/SKILL.md`. A skill é a **fonte única do processo**: leia-a na íntegra e siga suas seções na ordem — triagem entre modos Interface e Frontend (seção 1), exploração e direção (seções 3-4), confirmação com o usuário antes de implementar (seção 6), implementação, auto-crítica com os checks do modo e encerramento com oferta de salvar padrões. Leia também `.claude/skills/ux-design-reviewer/SKILL.md` e aplique seu checklist (fluxos, feedback, acessibilidade, estados vazio/erro).

Pedido do usuário: $ARGUMENTS

Regras de execução:

1. A triagem é **obrigatória antes de qualquer proposta** — declare o modo em uma linha (`Modo: INTERFACE — ...` ou `Modo: FRONTEND — ...`). Em ambiguidade real, faça **uma única pergunta** antes de prosseguir; não chute.
2. Apresente a direção proposta e **confirme com o usuário antes de implementar**, exceto quando o pedido for explicitamente "implementar agora".
3. Produza código de produção na stack solicitada, com tokens em CSS variables, e rode a auto-crítica do modo **antes** de mostrar o resultado.

**IDIOMA**: Toda especificação e documentação gerada deve ser escrita em **português (pt-BR)**. Código — incluindo comentários no código — em **inglês** (constitution, Regra Geral 5). Textos de UI exibidos ao usuário em pt-BR.

**Gate**: antes de concluir, verifique o **Checklist obrigatório (gate)** definido em `.claude/skills/specify-design/SKILL.md` — só reporte conclusão se todos os itens estiverem ok.

**Ao finalizar:** se o trabalho criou ou alterou uma funcionalidade visível do produto, atualize `FEATURE_LIST.md` (e `IMPLEMENTATION_STATUS.md` se a feature estiver rastreada lá). Princípio 8 da Constitution.

Observação: Este comando **não** define arquitetura de backend, modelagem de dados, endpoints nem estratégia de testes. Para essas áreas use `/specify`, `/plan`, `/tasks` ou `/specify-tech`.
