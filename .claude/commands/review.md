---
description: Revisar código e artefatos da sessão contra constitution, arquitetura e padrões do projeto. Gera relatório de conformidade.
argument-hint: arquivos ou escopo adicional a revisar (opcional)
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
---

Leia `.claude/agents/review.md` e adote a persona definida. O agente é a **fonte única do processo de auditoria**: define as skills a carregar (incluindo as condicionais por plataforma, conforme os arquivos em CHANGED_FILES) e como aplicar os checklists — cada SKILL.md é a fonte do seu próprio checklist. Em seguida execute os passos abaixo.

Escopo adicional (opcional): $ARGUMENTS — arquivos ou diretórios a incluir além dos detectados pelo script.

1. Execute o script abaixo usando a ferramenta Bash a partir da raiz do repositório e interprete a saída JSON para obter FEATURE_DIR, AVAILABLE_DOCS e CHANGED_FILES. Todos os caminhos devem ser absolutos.
   ```
   bash scripts/bash/check-review-prerequisites.sh --json
   ```
   **IMPORTANTE**: Execute o script apenas uma vez. O JSON é exibido no terminal — use-o para obter o conteúdo real.

2. Carregue **contexto obrigatório**:
   - **OBRIGATÓRIO**: `memory/constitution.md` — princípios e regras gerais
   - **OBRIGATÓRIO**: `docs/arquitetura.md` — padrões arquiteturais e convenções
   - SE EXISTIR em AVAILABLE_DOCS: spec da feature (aderência funcional) e plan (aderência técnica)

3. Carregue `templates/review-template.md` — **fonte única do formato do relatório e do critério de aprovação/reprovação**.

4. Identifique **todos os arquivos a revisar**: CHANGED_FILES + o escopo adicional de $ARGUMENTS. Se o total for vazio, peça ao usuário para indicar os arquivos.

5. Para cada arquivo, aplique os checklists conforme definido no agente (skills carregadas + Regras Gerais e Checklist de Conformidade da constitution).

6. **Verificação executável**: se o projeto tiver os comandos configurados (package.json/tsconfig), execute via Bash typecheck (`tsc --noEmit` ou equivalente), lint e a suíte de testes, e inclua o resultado real na seção "Verificação Executável" do relatório. Falha em qualquer um = resultado REPROVADO, independentemente dos demais achados. Se o tooling não existir ainda, registre N/A com o motivo.

7. Gere o **relatório de revisão** na estrutura do template: achados com severidade, arquivo, regra violada e correção sugerida; tabela de conformidade por área; resultado final conforme o critério do template. **Salve o relatório em `FEATURE_DIR/review.md`** (artefato sancionado do fluxo — constitution, Regra Geral 2; sobrescreva se existir, o relatório reflete o estado atual do branch).

8. **Loop de correção** — se REPROVADO:
   - Converta cada achado Crítico/Alto em task corretiva e apense ao `tasks.md` numa fase **"Correções"** (IDs continuando a sequência; cada task cita o achado, ex.: "T024 Corrigir CRÍTICO-001: ..."). Esta é a única escrita permitida além do relatório e dos arquivos de status.
   - Sugira o ciclo: `/implement Correções` → novo `/review`.
   - Se APROVADO: informe que a feature cumpriu o DoD de revisão e **sugira fechar o ciclo git** — abrir o PR com `gh pr create --fill` (se o repo tiver remote GitHub e o usuário aprovar) ou merge conforme o fluxo do time. Não abra o PR sem aprovação explícita (ação externa).

9. **Ao finalizar:** Atualize `IMPLEMENTATION_STATUS.md` (coluna Review e DoD, conforme a fórmula definida no próprio arquivo) e `FEATURE_LIST.md` — a escrita é responsabilidade **deste comando, no contexto principal** (o agente review é read-only e não escreve arquivos). Princípio 8 da Constitution.

**IDIOMA**: Todo o relatório e comunicação em **português (pt-BR)**.

**Gate**: antes de concluir, verifique o **Checklist obrigatório (gate)** definido em `.claude/agents/review.md` — só reporte conclusão se todos os itens estiverem ok.
