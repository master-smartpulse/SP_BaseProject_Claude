---
description: Analisar a consistência entre spec, plan e tasks antes da implementação — cobertura de requisitos, tasks órfãs, contratos divergentes e violações de constitution. Somente leitura.
argument-hint: (sem argumentos)
allowed-tools: Bash, Read, Grep, Glob
---

Você vai auditar a consistência dos artefatos da feature **antes** do /implement, em modo **somente leitura** — nenhum arquivo é alterado; o resultado é um relatório com correções sugeridas. Execute os passos abaixo.

1. Execute o script abaixo usando a ferramenta Bash a partir da raiz do repositório e interprete FEATURE_DIR e AVAILABLE_DOCS. Todos os caminhos devem ser absolutos.
   ```
   bash scripts/bash/check-implementation-prerequisites.sh --json
   ```
   **IMPORTANTE**: Execute o script apenas uma vez. O JSON é exibido no terminal — use-o para obter o conteúdo real.

2. Carregue: spec da feature, plan.md, tasks.md (obrigatórios) + data-model.md, contracts/ e quickstart.md quando existirem, além de `memory/constitution.md`.

3. Construa o mapa de consistência e verifique, com severidade por achado:
   - **Cobertura de requisitos** (CRÍTICO): todo RF-XXX e cenário de aceite da spec tem pelo menos uma task correspondente (e task de teste)? Use a tabela "Cobertura de Requisitos" do tasks.md como ponto de partida, mas confira contra a spec real.
   - **Tasks órfãs** (MÉDIO): toda task rastreia para um requisito, contrato, entidade ou user story? Tasks sem origem identificável são scope creep.
   - **Contratos × data-model × tasks** (ALTO): todo endpoint em contracts/ tem task de teste de contrato e de implementação? Toda entidade do data-model tem task de modelo? Campos citados nos contratos existem no data-model?
   - **Constitution** (CRÍTICO): violações detectáveis nos artefatos — ordem TDD quebrada no tasks.md, task marcada [P] listada como bloqueada, stack fora da Regra Geral 6 sem desvio justificado no plan.md, [PRECISA ESCLARECIMENTO] restante na spec.
   - **Terminologia** (BAIXO): mesmo conceito com nomes divergentes entre spec, plan e tasks.

4. Gere o relatório (no chat, sem gravar arquivo): tabela de achados com severidade, artefato(s), problema e correção sugerida (incluindo qual comando corrige: editar spec via /clarify, regenerar via /tasks, ajustar plan).

5. **Recomendação final**: PROSSEGUIR para /implement (zero Crítico) ou CORRIGIR antes (com a lista mínima de correções). Peça a decisão do usuário.

**IDIOMA**: Todo o relatório em **português (pt-BR)**.

**Checklist antes de concluir (gate)** — só reporte conclusão se todos estiverem ok:
- [ ] Todos os requisitos da spec cruzados com as tasks (nenhum RF sem verificação)
- [ ] Todos os contratos e entidades cruzados com as tasks
- [ ] Cada achado tem severidade, artefato e correção sugerida
- [ ] Nenhum arquivo foi modificado (somente leitura)
- [ ] Recomendação final explícita (prosseguir ou corrigir)

Observação: Este comando não substitui o /review (que audita o **código** após a implementação) — ele audita os **artefatos** antes dela.
