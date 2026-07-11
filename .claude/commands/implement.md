---
description: Executar o plano de implementação processando e executando todas as tasks definidas no tasks.md
argument-hint: fase ou IDs de tasks para executar/retomar (opcional)
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
---

Leia `.claude/agents/implement.md` e adote a persona definida. O agente é a **fonte única do processo de implementação**: define as skills a carregar (incluindo as condicionais por plataforma, conforme o Tipo de Projeto no plan.md), a ordem das fases, o tratamento de dependências e marcadores [P], o TDD e a marcação [X] no tasks.md — siga-o. Em seguida execute os passos abaixo.

Escopo (opcional): $ARGUMENTS — se fornecido (ex.: uma fase ou IDs de tasks específicas), execute apenas o escopo indicado, respeitando as dependências; caso contrário, execute todas as tasks pendentes.

1. Execute o script abaixo usando a ferramenta Bash a partir da raiz do repositório e interprete FEATURE_DIR e AVAILABLE_DOCS. Todos os caminhos devem ser absolutos.
   ```
   bash scripts/bash/check-implementation-prerequisites.sh --json
   ```
   **IMPORTANTE**: Execute o script apenas uma vez. O JSON é exibido no terminal — use-o para obter o conteúdo real.

2. Carregue **contexto completo** conforme a seção "Suas responsabilidades" do agente: spec, plan.md, tasks.md, `memory/constitution.md` e `docs/arquitetura.md` (obrigatórios) + data-model.md, contracts/, research.md, quickstart.md e review.md quando existirem (se o tasks.md tiver fase "Correções", priorize-a). Não pule nenhum artefato disponível.

3. Execute a implementação seguindo o processo definido no agente: fases na ordem do tasks.md, dependências respeitadas, TDD (testes antes da implementação correspondente), coordenação por arquivo, [X] ao concluir cada task, progresso e falhas reportados com contexto.

4. Validação de conclusão: confirme que todas as tasks do escopo foram concluídas, que os testes passam e que a implementação corresponde à spec e ao plano técnico; informe o status final com resumo do trabalho.

5. **Ao finalizar:** Atualize `IMPLEMENTATION_STATUS.md` (coluna Impl % conforme a fórmula definida no próprio arquivo: tasks [X] ÷ total) e `FEATURE_LIST.md`. Princípio 8 da Constitution.

**IDIOMA**: Documentação, specs e mensagens ao usuário em **português (pt-BR)**. Código, comentários no código e commits em **inglês** (constitution, Regra Geral 5).

**Gate**: antes de concluir, verifique o **Checklist obrigatório (gate)** definido em `.claude/agents/implement.md` — só reporte conclusão se todos os itens estiverem ok.

Observação: Este comando assume que existe um tasks.md completo. Se as tasks estiverem incompletas ou ausentes, sugira executar `/tasks` primeiro para regenerar a lista.
