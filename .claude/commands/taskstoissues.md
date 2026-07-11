---
description: Converter as tasks do tasks.md da feature atual em issues do GitHub via gh CLI, com rastreabilidade de requisitos e dependências.
argument-hint: labels ou milestone opcionais (ex. "milestone:MVP label:backend")
allowed-tools: Bash, Read, Glob
---

Você vai converter o tasks.md da feature atual em issues do GitHub, preservando IDs, rastreabilidade (RF-xxx) e dependências. Execute os passos abaixo.

Preferências opcionais do usuário (labels, milestone): $ARGUMENTS

1. **Pré-requisitos**: execute `gh auth status` via Bash. Se o gh CLI não estiver instalado ou autenticado, ou o repositório não tiver remote no GitHub, PARE e informe o que falta (instalar gh, `gh auth login`, configurar remote).

2. Execute o script abaixo a partir da raiz do repositório e interprete FEATURE_DIR:
   ```
   bash scripts/bash/check-implementation-prerequisites.sh --json
   ```
   **IMPORTANTE**: Execute o script apenas uma vez.

3. Leia o `tasks.md` da feature e extraia: fases, tasks (ID, [P], RF-xxx, descrição, caminhos), dependências e a tabela de Cobertura de Requisitos. **Ignore tasks já marcadas [X]** (concluídas) e informe quantas foram puladas.

4. **Confirme antes de criar** (ação externa): apresente o resumo — nº de issues a criar, títulos, labels/milestone — e **pergunte explicitamente se o usuário aprova**. Não crie nenhuma issue sem aprovação.

5. Crie uma issue por task pendente com `gh issue create`:
   - **Título**: `[T00X] Descrição curta` (em pt-BR, como no tasks.md)
   - **Corpo**: fase, requisito(s) (RF-xxx), caminhos de arquivo, casos de teste da task, dependências ("Bloqueada por: T00Y — #<número da issue correspondente>" quando a issue do bloqueio já tiver sido criada) e link para `specs/{feature}/tasks.md`
   - **Labels**: `spec:{###-nome-da-feature}` + fase (`setup`/`fundacao`/`us1`.../`polish`) + as fornecidas em $ARGUMENTS (crie labels inexistentes com `gh label create` se o usuário aprovou)
   - Crie na ordem das dependências (bloqueadoras primeiro) para poder referenciar `#número` nas dependentes.

6. Ao final, reporte: tabela task → issue (#número, URL), tasks puladas ([X]) e o comando para acompanhar (`gh issue list --label "spec:{feature}"`).

**IDIOMA**: Títulos e corpos das issues em **português (pt-BR)** (comunicação de produto); referências técnicas (paths, IDs) como no tasks.md.

**Checklist antes de concluir (gate)** — só reporte conclusão se todos estiverem ok:
- [ ] gh autenticado e remote GitHub confirmados antes de qualquer criação
- [ ] Aprovação explícita do usuário antes de criar issues (ação externa)
- [ ] Uma issue por task pendente, com RF-xxx, dependências e link para o tasks.md
- [ ] Nenhuma task [X] virou issue; tasks puladas reportadas
- [ ] Tabela final task → issue apresentada

Observação: Este comando **não** altera o tasks.md (as issues são espelho para rastreabilidade externa; o tasks.md continua sendo a fonte de execução do /implement).
